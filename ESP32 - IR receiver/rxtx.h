#include "driver/rmt_tx.h"
#include "driver/rmt_rx.h"

#include "esp_event.h"


#define GPIO_IR_RX   26
#define GPIO_IR_TX   27

#define MEM_BLOCK_SYMBOLS 128
#define CHANNEL_RESOLUTION 1000000 
#define CHANNEL_DC 0.33
#define CARRIER_FREQ 33000

void init_tx_channel(rmt_channel_handle_t* tx_channel);
void init_rx_channel(rmt_channel_handle_t* rx_channel, QueueHandle_t *receive_queue);

void receiveIR(rmt_channel_handle_t* rx_channel, rmt_symbol_word_t* raw_symbols);