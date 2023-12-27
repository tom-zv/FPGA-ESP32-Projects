
#include "esp_log.h"
#include "driver/rmt_tx.h"

#include "debug.h"
#include "ir_codec.h"

void print_data(const char *preamble, char *data, size_t data_len , size_t line_len) {

    if (preamble != NULL) {
        printf("%s\n\n", preamble);  
    }

    for (int i = 0; i < data_len; i++) {
        printf("%c", data[i]);

        if ((i+1) % line_len == 0){
            printf("\n");
        }
    }

    if (data_len % line_len != 0) {
        printf("\n");
    }
}

void print_space_mark_pairs(rmt_symbol_word_t* symbols, int num_symbols){

    printf("%d symbols received - printing (%d,%d) pairs\n", num_symbols,symbols->level0, symbols->level1);

    for (int i = 0; i < num_symbols; i++)
    {
        // if((within_tolerance(symbols[i].duration0, 4000) | within_tolerance(symbols[i].duration0, 3000))  && i != 0){ // start of code repeat
        //     printf("\nleading (%d,%d)\n", symbols[i].duration0, symbols[i].duration1);
        //     return; 
        // }
        
        printf("(%4d,%4d)", symbols[i].duration0, symbols[i].duration1);

        if ((i+1) % 10 == 0 )  printf("\n");
        else                   printf(" | ");   
    }
    printf("\n");
}