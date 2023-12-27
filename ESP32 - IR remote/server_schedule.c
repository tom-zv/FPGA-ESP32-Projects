#include <time.h>
#include <ctype.h>
#include "esp_log.h"

#include "ir_http_server.h"
#include "server_schedule.h"

static const char* TAG = "schedule manager";

const char* state_name(uint32_t state){
    switch(state){
        case NOP:
            return "NOP";
        case AC_OFF:
            return "AC_OFF";
        case AC_ON:
            return "AC_ON";
        case EVENT_SCHED_UPDATE:
            return "SCHEDULE_UPDATE";
        case EVENT_SCHED_DEL:
            return "SCHEDULE_DEL";
        default:
            return "UNKNOWN_STATE";
    }
}

int calc_delay_to_event_ms(int event_day, int event_hour, int event_min,
                           int current_day, int current_hour, int current_min)
{
    int delay_days = (event_day - current_day + 7) % 7; // handles current day > event day case (event in next week)
    int delay_hours = event_hour - current_hour;
    int delay_mins = event_min - current_min;

    if (delay_mins < 0)
    {
        delay_mins += 60;
        delay_hours--;
    }

    if (delay_hours < 0)
    {
        delay_hours += 24;
        delay_days--;
    }

    if (delay_days < 0)
    {
        delay_days += 7; // wrap around
    }

    time_t now = time(NULL);
    struct tm *now_tm = localtime(&now);
    return delay_days * 24 * 60 * 60 * 1000 + delay_hours * 60 * 60 * 1000 + delay_mins * 60 * 1000 - now_tm->tm_sec * 1000;
}

int delay_to_nearest_schedule_ms(schedule_manager *smanager)
{
    time_t now = time(NULL);
    struct tm *now_tm = localtime(&now);

    if (smanager->schedule_active) 
    {
        return calc_delay_to_event_ms(smanager->turn_off_day, smanager->entries[smanager->next_event_index].hour_off,
                                      smanager->entries[smanager->next_event_index].minute_off,
                                      now_tm->tm_wday, now_tm->tm_hour, now_tm->tm_min);
    }

    // no active schedule, find nearest schedule start
    int time_delay_ms = INT32_MAX;
    int calc_temp;
    int nearest_sched_index = -1;
    int nearest_sched_wday = -1;

    for (int i = 0; i < MAX_SCHEDULE_ENTRIES; i++)
    {
        if (smanager->entries[i].is_valid)
        {
            int wday = now_tm->tm_wday; // start from current day, to find nearest schedule
            
            for (int days_checked = 0; days_checked < 7; days_checked++)
            {
                uint8_t wday_bitmask = 1 << wday;
                if (wday_bitmask & smanager->entries[i].days_of_week)
                {
                    calc_temp = calc_delay_to_event_ms(wday, smanager->entries[i].hour_on, smanager->entries[i].minute_on,
                                                       now_tm->tm_wday, now_tm->tm_hour, now_tm->tm_min);

                    if (time_delay_ms > calc_temp)
                    {
                        time_delay_ms = calc_temp;
                        nearest_sched_index = i;
                        nearest_sched_wday = wday;
                    }
                    if (days_checked == 0 && calc_temp > (24 * 60 * 60 * 1000)){  // Schedule found might be in a week when checking after the schedule has elapsed.
                        wday = (wday + 1) % 7;                                    // in that case, check other days for closer event
                        continue;
                    }
                    break;                                                                                      
                }
                wday = (wday + 1) % 7;
            }
        }
    }

    if (nearest_sched_index != -1)
    {
        if (smanager->entries[nearest_sched_index].hour_off < smanager->entries[nearest_sched_index].hour_on)
        {
            nearest_sched_wday = (nearest_sched_wday + 1) % 7; // schedule spans midnight. turn_off_day must hold the actual day
                                                               // for correct delay calculation
        }
        smanager->turn_off_day = nearest_sched_wday;
        smanager->next_event_index = nearest_sched_index;
    }
    else
    {
        time_delay_ms = -1; // No schedule
    }

    //ESP_LOGI(TAG, "nearest schedule: index %d, wday %d, delay %d", nearest_sched_index, nearest_sched_wday, time_delay_ms);
    return time_delay_ms;
}

//calculate delay to wakeup & returns wakeup state
uint32_t config_wakeup(schedule_manager *smanager, TimerHandle_t schedule_timer){
    uint32_t scheduler_state = NOP;
    int delay_ms = delay_to_nearest_schedule_ms(smanager);
    
    if (delay_ms > 0) {
        xTimerChangePeriod(schedule_timer, pdMS_TO_TICKS(delay_ms), portMAX_DELAY);
        
        if(smanager->schedule_active) scheduler_state = AC_OFF;
        else scheduler_state = AC_ON;
    }
    
    return scheduler_state;
}

// stores int representation of index in ind, returns the length of the index
int parse_index(char *data, int *ind) 
{
    #define MAX_INDEX_LEN 2

    if(data[0] == 'n' && data[1] == ' ') return -1;
    
    char index_str[MAX_INDEX_LEN + 1];
    int index_len = 0;

    while (isdigit((unsigned char)data[index_len]) && data[index_len] != ' ' && index_len < MAX_INDEX_LEN) index_len++;
    strncpy(index_str, data, index_len);
    index_str[index_len] = '\0';

    *ind = atoi(index_str);
    return index_len;
}

int transfer_data_to_entry(schedule_entry* entries, int i, char* data){

    #define NUM_TIME_FIELDS 4   // Hour on, Minute on, Hour off, Minute off
    #define TIME_FIELD_WIDTH 3  // including space
    #define WDAYS_START_INDEX (NUM_TIME_FIELDS*TIME_FIELD_WIDTH) // Start index of day bitmask in the string

    char time_buffer[TIME_FIELD_WIDTH] = {0};

    for (int j = 0; j < NUM_TIME_FIELDS; j++)
    {
        strncpy(time_buffer, data + j * TIME_FIELD_WIDTH, TIME_FIELD_WIDTH - 1);
        int time_value = atoi(time_buffer);

        switch (j){
        case 0: // hour_on
            if (time_value < 0 || time_value > 23) {
                ESP_LOGE(TAG, "Invalid hour value %d in schedule entry %d", time_value, i);
                return -1;
            }
            entries[i].hour_on = time_value;
            break;
        case 1: // minute_on
            if (time_value < 0 || time_value > 59) {
                ESP_LOGE(TAG, "Invalid minute value %d in schedule entry %d", time_value, i);
                return -1;
            }
            entries[i].minute_on = time_value;
            break;
        case 2: // hour_off
            if (time_value < 0 || time_value > 23) {
                ESP_LOGE(TAG, "Invalid hour value %d in schedule entry %d", time_value, i);
                return -1;
            }
            entries[i].hour_off = time_value;
            break;
        case 3: // minute_off
            if (time_value < 0 || time_value > 59) {
                ESP_LOGE(TAG, "Invalid minute value %d in schedule entry %d", time_value, i);
                return -1;
            }
            entries[i].minute_off = time_value;
            break;
        }
    }
    // Parse day bitmask

    entries[i].days_of_week = 0;
    for (int j = 0; j < 7; j++)
    {
        if (data[WDAYS_START_INDEX + j] == '1')
        {
            entries[i].days_of_week |= (1 << (j));
        }
    }

    entries[i].is_valid = 1;
    entries[i].is_on = 1;

    return ESP_OK;
}

/* Timer used to wake up scheduler task.*/
void timer_callback(TimerHandle_t xTimer){
    TaskHandle_t* task = (TaskHandle_t *)pvTimerGetTimerID(xTimer);
    xTaskNotify(*task, EVENT_SCHED_TIMER, eSetValueWithoutOverwrite);
}

/* Scheduler task - sleeps between the following actions - AC_ON, AC_OFF, SCHEDULE_UPDATE
* The task both sets a wake up timer and the state upon wake up, and handles an interrupt for schedule updates*/
void ac_scheduler_task(void* pvParams){
    server_context *server_ctx = (server_context *)pvParams;
    tx_context *tx_ctx = server_ctx->tx_ctx;
    ac_scheduler_context *schedule_ctx = server_ctx->scheduler_ctx;
    
    schedule_entry schedule_table[MAX_SCHEDULE_ENTRIES] = {0};
    schedule_manager schedule_manager = {
        .entries = schedule_table,
        .schedule_active = 0,
        .next_event_index = -1,
        .turn_off_day = 0
    };
    
    schedule_ctx->schedule_table = schedule_table;
    TimerHandle_t schedule_timer = xTimerCreate("schedule_timer", pdMS_TO_TICKS(10), pdFALSE, (void *)&schedule_ctx->scheduler_task, timer_callback);
    uint32_t scheduler_state = NOP;
    uint32_t notification = NOP;
    int sched_index;
    int index_len;
    int delay_ms = 0;

    for (;;)
    {
        time_t now = time(NULL);
        struct tm *tm = localtime(&now);
        
        ESP_LOGI(TAG,"| current Time: %02d:%02d:%02d | State on wake-up: %s | calculated delay: %ds |",tm->tm_hour, tm->tm_min, tm->tm_sec, state_name(scheduler_state), delay_ms / 1000);
        xTaskNotifyWait(0, EVENT_SCHED_TIMER| EVENT_SCHED_UPDATE | EVENT_SCHED_DEL,  &notification, portMAX_DELAY); 
        if(!(notification & EVENT_SCHED_TIMER)) scheduler_state = notification; // keep state unless schedule change is indicated

        uint32_t uri_err_notification = ESP_OK;
        switch (scheduler_state)
        {
        case AC_ON:
            ESP_LOGI(TAG, "turning AC ON");
            if (tx_ctx->ir_settings->power_state == 0)
            { // toggle AC if off
                tx_ctx->ir_settings->power = 1;
                if (transmit_ir(tx_ctx->tx_channel, tx_ctx->ir_encoder, tx_ctx->ir_settings, tx_ctx->tx_config) == ESP_OK)
                {
                    tx_ctx->ir_settings->power_state = 1;
                }
                else ESP_LOGI(TAG, "Failed to transmit IR!");
                
                tx_ctx->ir_settings->power = 0;
            }

            
            schedule_manager.schedule_active = 1;
            scheduler_state = config_wakeup(&schedule_manager, schedule_timer);

        break;

        case AC_OFF:
            ESP_LOGI(TAG, "turning AC OFF");
            if (tx_ctx->ir_settings->power_state == 1)
            { // toggle AC if on
                tx_ctx->ir_settings->power = 1;
                if (transmit_ir(tx_ctx->tx_channel, tx_ctx->ir_encoder, tx_ctx->ir_settings, tx_ctx->tx_config) == ESP_OK)
                {
                    tx_ctx->ir_settings->power_state = 0;
                }
                else ESP_LOGI(TAG, "Failed to transmit IR!");
                
                schedule_manager.schedule_active = 0;
                scheduler_state = config_wakeup(&schedule_manager, schedule_timer);
            }
        break;
        
        case EVENT_SCHED_UPDATE: // schedule format - "I HH MM HH MM DBITMSK"  || 

            //ESP_LOGI(TAG, "updating schedule; incoming data - %s", schedule_ctx->schedule_data);

            index_len = parse_index(schedule_ctx->schedule_data, &sched_index);
            if(index_len == 0) uri_err_notification = ERR_WRONG_FORMAT;
            else if (index_len == -1) // new schedule
            {
                uint8_t found_slot = 0;
                for (int i = 0; i < MAX_SCHEDULE_ENTRIES; i++) // find empty slot
                {
                    if (schedule_manager.entries[i].is_valid == 0)
                    {
                        if (transfer_data_to_entry(schedule_manager.entries, i, schedule_ctx->schedule_data + 1 + 1) != ESP_OK)
                            uri_err_notification = ERR_WRONG_FORMAT;
                        found_slot = 1;
                        //ESP_LOGI(TAG, "schedule updated, index %d", i);
                        break;
                    }
                }
                if(!found_slot) uri_err_notification = ERR_SCHED_FULL;
            }
            else
            {
                if (sched_index < MAX_SCHEDULE_ENTRIES)
                {
                    if (transfer_data_to_entry(schedule_manager.entries, sched_index, schedule_ctx->schedule_data + index_len + 1) != ESP_OK)
                        uri_err_notification = ERR_WRONG_FORMAT;
                    //ESP_LOGI(TAG, "schedule updated, index %d", sched_index);
                }
            }

            xTaskNotify(schedule_ctx->active_uri_handler, uri_err_notification, eSetValueWithOverwrite);
            xSemaphoreGive(*schedule_ctx->schedule_uri_bSemaphore);

            scheduler_state = config_wakeup(&schedule_manager, schedule_timer);

        break;

        case EVENT_SCHED_TOGGLE:
            ESP_LOGI(TAG, "toggling schedule");
            index_len = parse_index(schedule_ctx->schedule_data, &sched_index);

            if (index_len > 0 )
            {
                if (schedule_manager.entries[sched_index].is_valid == 1)
                {
                    schedule_manager.entries[sched_index].is_on = !schedule_manager.entries[sched_index].is_on;
                }
                else uri_err_notification = ERR_INVALID_ENTRY;
            }
            else uri_err_notification = ERR_WRONG_FORMAT;

            xTaskNotify(schedule_ctx->active_uri_handler, uri_err_notification, eSetValueWithOverwrite);
            xSemaphoreGive(*schedule_ctx->schedule_uri_bSemaphore);

            scheduler_state = config_wakeup(&schedule_manager, schedule_timer);
        break;

        case EVENT_SCHED_DEL: //  
            index_len = parse_index(schedule_ctx->schedule_data, &sched_index);
            
            if (index_len > 0)
            {
                schedule_manager.entries[sched_index].is_valid = 0;
                int next_index = sched_index + 1; 
                while (next_index < MAX_SCHEDULE_ENTRIES && schedule_manager.entries[next_index].is_valid == 1) // compact the table
                {
                    memmove(&schedule_manager.entries[sched_index], &schedule_manager.entries[next_index], sizeof(schedule_entry) * (MAX_SCHEDULE_ENTRIES - next_index));
                    sched_index++; 
                    next_index++; 
                }
            }
            else{
                uri_err_notification = ERR_WRONG_FORMAT;
            }
            xTaskNotify(schedule_ctx->active_uri_handler, uri_err_notification, eSetValueWithOverwrite);
            xSemaphoreGive(*schedule_ctx->schedule_uri_bSemaphore);

            scheduler_state = config_wakeup(&schedule_manager, schedule_timer);
        break;

        default:
            // no scheduler action, back to sleep (shouldnt be reached)
            ESP_LOGE(TAG,"invalid scheduler state: %lu", scheduler_state);
        break;
        }
    }
}