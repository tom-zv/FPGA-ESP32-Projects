#ifndef IR_HTTP_SERVER_H
#define IR_HTTP_SERVER_H

#include "ir_codec.h"
#include <esp_http_server.h>
#include "driver/rmt_tx.h"
#include "server_schedule.h"

typedef struct server_context{ // master context
    httpd_handle_t* server;   
    char *file_buf;
    tx_context* tx_ctx;
    ac_scheduler_context* scheduler_ctx;
} server_context;

void ir_http_server_task(void* pvParameters);

esp_err_t start_ir_webserver(server_context *server_context);

void connect_handler(void *arg, esp_event_base_t event_base,
                            int32_t event_id, void *event_data);

void disconnect_handler(void *arg, esp_event_base_t event_base,
                               int32_t event_id, void *event_data);

const char* get_http_date();

esp_err_t sntp_sync();

#endif //IR_HTTP_SERVER_H