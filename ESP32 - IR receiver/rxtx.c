
#include "freertos/FreeRTOS.h"
#include "freertos/task.h"
#include "freertos/event_groups.h"
#include "driver/rmt_tx.h"
#include "driver/rmt_rx.h"
#include "esp_event.h"

#include "ir_codec.h"
#include "rxtx.h"

//static const char *TAG = "RXTX";

static bool example_rmt_rx_done_callback(rmt_channel_handle_t channel, const rmt_rx_done_event_data_t *edata, void *user_data)
{
    BaseType_t high_task_wakeup = pdFALSE;
    QueueHandle_t receive_queue = (QueueHandle_t)user_data;
    // send the received RMT symbols to the parser task
    xQueueSendFromISR(receive_queue, edata, &high_task_wakeup);
    return high_task_wakeup == pdTRUE;
}


void init_tx_channel(rmt_channel_handle_t* tx_channel)
{ // Setup TX channel

    rmt_tx_channel_config_t tx_chan_config = {
        .clk_src = RMT_CLK_SRC_DEFAULT,
        .gpio_num = GPIO_IR_TX,
        .mem_block_symbols = MEM_BLOCK_SYMBOLS,
        .resolution_hz = CHANNEL_RESOLUTION,
        .trans_queue_depth = 4, // set the number of transactions that can be pending in the background
    };

    ESP_ERROR_CHECK(rmt_new_tx_channel(&tx_chan_config, tx_channel));

    rmt_carrier_config_t carrier_cfg = {
        .duty_cycle = CHANNEL_DC,
        .frequency_hz = CARRIER_FREQ,
    };

    ESP_ERROR_CHECK(rmt_apply_carrier(*tx_channel, &carrier_cfg));
    ESP_ERROR_CHECK(rmt_enable(*tx_channel));
}


void init_rx_channel(rmt_channel_handle_t* rx_channel, QueueHandle_t *receive_queue){
    // Setup RX channel

    //ESP_LOGI(TAG, "create RMT RX channel");
    rmt_rx_channel_config_t rx_channel_cfg = {
        .clk_src = RMT_CLK_SRC_DEFAULT,
        .resolution_hz = CHANNEL_RESOLUTION,
        .mem_block_symbols = MEM_BLOCK_SYMBOLS, // amount of RMT symbols that the channel can store at a time
        .gpio_num = GPIO_IR_RX, 
        .flags.invert_in = true,      
    };
    ESP_ERROR_CHECK(rmt_new_rx_channel(&rx_channel_cfg, rx_channel));
    *receive_queue = xQueueCreate(1, sizeof(rmt_rx_done_event_data_t));
    assert(*receive_queue);

    rmt_rx_event_callbacks_t cbs = {
        .on_recv_done = example_rmt_rx_done_callback,
    };
    ESP_ERROR_CHECK(rmt_rx_register_event_callbacks(*rx_channel, &cbs, *receive_queue));
    ESP_ERROR_CHECK(rmt_enable(*rx_channel));
}

void receiveIR(rmt_channel_handle_t* rx_channel, rmt_symbol_word_t* raw_symbols){

    rmt_receive_config_t receive_config = {
        .signal_range_min_ns = 1250,     //
        .signal_range_max_ns = 12000000, 
    };

    ESP_ERROR_CHECK(rmt_receive(*rx_channel, raw_symbols, (size_t)512, &receive_config));
}