#ifndef IR_CODEC_H
#define IR_CODEC_H

#include <string.h>
#include "driver/rmt_tx.h"

#define DATA_BITS 34
#define DATA_UNIT_DURATION 1000  // duration of SPACE/MARK
#define DATA_UNIT_DURATION_TOLERANCE 200 
#define MAX_DATA_SYMBOL_BIT_LEN 4 // Biggest data symbol is the trailing, 4000us MARK 
                                  //                                      '1111' after decoding to bits

typedef union ir_jetpoint_settings
{
    struct // Data sent with 'power' going first
    {  
        uint64_t zeros1 : 1;      // bits 0        credit to barakwei- https://github.com/barakwei/IRelectra                                                
        uint64_t ones1 : 1;       // bits 1        for configuration structure
        uint64_t zeros2 : 16;     // bits 2-17
        uint64_t sleep : 1;       // bits 18
        uint64_t temperature : 4; // bits 19-22
        uint64_t zeros3 : 2;      // bits 23-24
        uint64_t swing : 1;       // bits 25
        uint64_t zeros4 : 2;      // bits 26-27
        uint64_t fan : 2;         // bits 28-29         
        uint64_t mode : 3;        // bits 30-32     COOL = 1|HEAT = 2|AUTO = 3|DRY = 4|FAN = 5  
        uint64_t power : 1;       // bits 33     
        uint64_t padding : 29;
        uint64_t power_state: 1;  // Current AC state. since 'power' toggles the AC, need a seperate state tracker
    };
    uint64_t raw;

}ir_jetpoint_settings;

typedef struct
{ // context needed for IR TX
    rmt_channel_handle_t *tx_channel;
    rmt_transmit_config_t *tx_config;
    rmt_encoder_handle_t *ir_encoder;
    ir_jetpoint_settings *ir_settings;
} tx_context;

esp_err_t rmt_new_jetpoint_encoder(rmt_encoder_handle_t *ret_encoder);

void set_jetpoint_settings(ir_jetpoint_settings* settings, bool power, uint8_t mode, uint8_t fan, uint8_t temperature, bool swing, bool sleep);

esp_err_t transmit_ir(rmt_channel_handle_t *tx_channel, rmt_encoder_handle_t *ir_encoder,
                      ir_jetpoint_settings *ir_settings, rmt_transmit_config_t *tx_config);

#endif // IR_CODEC_H