#include <string.h>
#include "driver/rmt_tx.h"


#define DATA_BITS 34
#define DATA_UNIT_DURATION 1000  // duration of SPACE/MARK
#define DATA_UNIT_DURATION_TOLERANCE 200 
#define MAX_DATA_SYMBOL_BIT_LEN 4 // Biggest data symbol is the trailing, 4000us MARK 
                                  //                                      '1111' after decoding to bits

typedef union {
    struct
    {
        // Data sent with 'power' going first
        uint64_t zeros1 : 1;      // 0        credit to barakwei- https://github.com/barakwei/IRelectra                                                
        uint64_t ones1 : 1;       // 1        for configuration structure
        uint64_t zeros2 : 16;     // 2-17
        uint64_t sleep : 1;       // 18
        uint64_t temperature : 4; // 19-22
        uint64_t zeros3 : 2;      // 23-24
        uint64_t swing : 1;       // 25
        uint64_t zeros4 : 2;      // 26-27
        uint64_t fan : 2;         // 28-29
        uint64_t mode : 3;        // 30-32
        uint64_t power : 1;       // 33     
        uint64_t padding : 30;
    };
    uint64_t raw;

}ir_jetpoint_settings;


esp_err_t rmt_new_jetpoint_encoder(rmt_encoder_handle_t *ret_encoder);

void set_jetpoint_settings(ir_jetpoint_settings* settings, bool power, uint8_t mode, uint8_t fan, uint8_t temperature, bool swing, bool sleep);

void rmt_decode_manchester(rmt_symbol_word_t* symbols, int num_symbols, char *decoded_message);

bool within_tolerance(int duration, int spec_duration);