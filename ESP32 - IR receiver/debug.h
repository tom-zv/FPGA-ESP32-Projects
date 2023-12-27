
#include "driver/rmt_tx.h"

void print_data(const char *preamble, char *data, size_t data_len , size_t line_len);
void print_space_mark_pairs(rmt_symbol_word_t* symbols, int num_symbols);