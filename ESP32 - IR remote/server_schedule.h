#ifndef SERVER_SCHEDULE_H
#define SERVER_SCHEDULE_H

#include "ir_codec.h"

// Scheduler states.
#define NOP 0
#define AC_OFF 1
#define AC_ON 2

#define EVENT_SCHED_TIMER  0x10
#define EVENT_SCHED_UPDATE  0x20   
#define EVENT_SCHED_TOGGLE  0x40
#define EVENT_SCHED_DEL    0x80

#define ERR_WRONG_FORMAT 1
#define ERR_INVALID_ENTRY 2
#define ERR_SCHED_FULL 3


#define SCHEDULE_BUF_SIZE 24  // schedule format - "I HH MM HH MM DBITMSK" || following schedule_entry
                              //                      24 to fit multi-digit indexes
#define MAX_SCHEDULE_ENTRIES 4
typedef struct
{
    uint8_t hour_on;
    uint8_t minute_on;
    uint8_t hour_off;
    uint8_t minute_off;
    uint8_t days_of_week;
    uint8_t is_on; 
    uint8_t is_valid;
} schedule_entry;


typedef struct
{
    schedule_entry *entries;
    int8_t next_event_index;
    uint8_t schedule_active; 
    uint8_t turn_off_day;
} schedule_manager;



typedef struct ac_scheduler_context{
    TaskHandle_t scheduler_task;
    TaskHandle_t active_uri_handler;
    schedule_entry *schedule_table;
    char* schedule_data; 
    SemaphoreHandle_t *schedule_uri_bSemaphore; // synchronize scheduler with active URI handler
    
} ac_scheduler_context;

void timer_callback(TimerHandle_t timer);

void ac_scheduler_task(void* pvParams);

esp_err_t handle_schedule();

#endif //SERVER_SCHEDULE_H