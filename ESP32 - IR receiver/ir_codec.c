#include "freertos/FreeRTOS.h"
#include "esp32/rom/ets_sys.h"
#include "esp_check.h"
#include "esp_log.h"
#include "driver/rmt_tx.h"

#include "ir_codec.h"
#include "debug.h"



static const char *TAG = "Encoder";

typedef struct
{
    int state;
    rmt_encoder_t base;
    rmt_encoder_t *bytes_encoder;
    rmt_encoder_t *copy_encoder;
    rmt_symbol_word_t trailing_symbol;
} rmt_jetpoint_encoder_t;


void set_jetpoint_settings(ir_jetpoint_settings *settings, bool power, uint8_t mode, uint8_t fan, uint8_t temperature, bool swing, bool sleep)
{
    settings->power = power ? 1 : 0;
    settings->mode = mode;              
    settings->fan = fan;
    settings->temperature = (temperature - 16) & 0x0F; 
    settings->swing = swing ? 1 : 0;
    settings->sleep = sleep ? 1 : 0;
    settings->ones1 = 1; 
}

void encode_jetpoint_settings(rmt_symbol_word_t *symbols, ir_jetpoint_settings *settings)
{
    symbols[0] = (rmt_symbol_word_t){ // leading symbol
        .level0 = 1,
        .duration0 = 3000ULL,
        .level1 = 0,
        .duration1 = 3000ULL,
    };

    for (int i = 1; i < DATA_BITS + 1; i++)  
    {
        bool bit = (settings->raw >> (DATA_BITS-i) ) & 1; // MSB -> LSB
        symbols[i] = (rmt_symbol_word_t){
            .level0 = bit ? 0 : 1, // "1" -> "01" and "0" -> "10" for Manchester encoding IEEE std
            .duration0 = 1000ULL,
            .level1 = bit ? 1 : 0,
            .duration1 = 1000ULL,
        };

    }
    // Copy the original array two times after itself

    memcpy(symbols + (DATA_BITS + 1), symbols, sizeof(rmt_symbol_word_t) * (DATA_BITS + 1));
    memcpy(symbols + 2 * (DATA_BITS + 1), symbols, sizeof(rmt_symbol_word_t) * (DATA_BITS + 1));

    symbols[(DATA_BITS+1)*3] = (rmt_symbol_word_t){  //trailing symbol
        .level0 = 1,
        .duration0 = 4000ULL,
        .level1 = 0,
        .duration1 = 0ULL,
    };
}

size_t rmt_encode_jetpoint(rmt_encoder_t *encoder, rmt_channel_handle_t channel, const void *primary_data, size_t data_size, rmt_encode_state_t *ret_state)
{

    rmt_jetpoint_encoder_t *enc = __containerof(encoder, rmt_jetpoint_encoder_t, base);
    rmt_encode_state_t session_state = RMT_ENCODING_RESET;
    rmt_encode_state_t state = RMT_ENCODING_RESET;
    size_t encoded_symbols = 0;

    rmt_symbol_word_t symbols[(DATA_BITS+1) * 3 + 1];
    encode_jetpoint_settings(symbols, (ir_jetpoint_settings *)primary_data);
    
    switch (enc->state)
    {
    case 0: 
        encoded_symbols += enc->copy_encoder->encode(enc->copy_encoder, channel, symbols, sizeof(symbols), &session_state);
    
        if (session_state & RMT_ENCODING_COMPLETE)
        {
            state |= RMT_ENCODING_COMPLETE;
        }
        if (session_state & RMT_ENCODING_MEM_FULL)
        {
            state |= RMT_ENCODING_MEM_FULL;
            goto out; // yield if there's no free space to put other encoding artifacts
        }
    }

out:
    //ets_printf("TOTAL: encoded %d symbols\n", encoded_symbols);
    *ret_state = state;
    return encoded_symbols;
}

static esp_err_t rmt_del_jetpoint_encoder(rmt_encoder_t *encoder)
{
    rmt_jetpoint_encoder_t *enc = __containerof(encoder, rmt_jetpoint_encoder_t, base);
    rmt_del_encoder(enc->copy_encoder);
    rmt_del_encoder(enc->bytes_encoder);
    free(enc);
    return ESP_OK;
}

static esp_err_t rmt_reset_jetpoint_encoder(rmt_encoder_t *encoder)
{
    rmt_jetpoint_encoder_t *enc = __containerof(encoder, rmt_jetpoint_encoder_t, base);
    rmt_encoder_reset(enc->copy_encoder);
    rmt_encoder_reset(enc->bytes_encoder);
    enc->state = RMT_ENCODING_RESET;
    return ESP_OK;
}

esp_err_t rmt_new_jetpoint_encoder(rmt_encoder_handle_t *ret_encoder){

    esp_err_t ret = ESP_OK;
    rmt_jetpoint_encoder_t *encoder = NULL;
    encoder = rmt_alloc_encoder_mem(sizeof(rmt_jetpoint_encoder_t));
    
    encoder->base.encode = rmt_encode_jetpoint;
    encoder->base.del = rmt_del_jetpoint_encoder;
    encoder->base.reset = rmt_reset_jetpoint_encoder;

    rmt_copy_encoder_config_t copy_encoder_config = {};
    ESP_GOTO_ON_ERROR(rmt_new_copy_encoder(&copy_encoder_config, &encoder->copy_encoder), err, TAG,
                      "create copy encoder failed");

    encoder->trailing_symbol = (rmt_symbol_word_t) {
        .level0 = 1,
        .duration0 = 4000ULL, // add [*resolution / wanted resolution], for duration independent on channel resolution.
        .level1 = 0,
        .duration1 = 0ULL, 
    };

    rmt_bytes_encoder_config_t bytes_encoder_config = { 
        .bit0 = {
            .level0 = 0, 
            .duration0 = 1000ULL,
            .level1 = 1,
            .duration1 = 1000ULL,  
        },
        .bit1 = {
            .level0 = 1,
            .duration0 = 1000ULL,
            .level1 = 0, 
            .duration1 = 1000ULL,
        },
    };

    ESP_GOTO_ON_ERROR(rmt_new_bytes_encoder(&bytes_encoder_config, &encoder->bytes_encoder), err, TAG, "create copy encoder failed");

    *ret_encoder = &encoder->base;
    return ESP_OK;

err:
    if (encoder)
    {
        if (encoder->bytes_encoder)
        {
            rmt_del_jetpoint_encoder(encoder->bytes_encoder);
        }
        if (encoder->copy_encoder)
        {
            rmt_del_jetpoint_encoder(encoder->copy_encoder);
        }
        free(encoder);
    }
    return ret;
}


bool within_tolerance(int duration, int spec_duration){
    return (duration > (spec_duration - DATA_UNIT_DURATION_TOLERANCE)) &&
           (duration < (spec_duration + DATA_UNIT_DURATION_TOLERANCE));
}


void rmt_decode_manchester(rmt_symbol_word_t* symbols, int num_symbols, char *decoded_message){ // Assuming correct message format and durations
    
    //char decoded_message[DATA_BITS + 1];

    print_space_mark_pairs(symbols, num_symbols);

    char bits[DATA_BITS * 2 + 1];
    int bits_ptr = 0;
    int i = 1; // skip leading code

    if(within_tolerance(symbols[0].duration1, 4 * DATA_UNIT_DURATION)){
        bits[bits_ptr++] = symbols->level1 + 48; // + 48 for ASCII conversion
    }
    
    while (bits_ptr < (DATA_BITS * 2))  // manchester encoding, each bit is encoded into a transition - 2 bits
    {                                   //code repeats 3 times, only interested in decoding first repetition 
        bits[bits_ptr++] = symbols->level0 + 48;
        if (within_tolerance(symbols[i].duration0, 2 * DATA_UNIT_DURATION))
        {
            bits[bits_ptr++] = symbols->level0 + 48;
        }

        bits[bits_ptr++] = symbols->level1 + 48;
        if (within_tolerance(symbols[i].duration1, 2 * DATA_UNIT_DURATION))
        {
            bits[bits_ptr++] = symbols->level1 + 48;
        }

        i++;
    }

    print_data("bit representation", bits, bits_ptr, 16);

    i = 0;
    int j = 0;

    while(j < DATA_BITS){ // go over pairs in bits array, first bit in pair is the encoded bit i.e "10" -> '1'                            
        decoded_message[j] = bits[i];                                                          //  "01" -> '0'
        i += 2; // next pair         
        j++;    
    }

}