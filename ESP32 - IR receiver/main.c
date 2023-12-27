#include <stdio.h>
#include <string.h>

#include "freertos/FreeRTOS.h"
#include "freertos/task.h"
#include "freertos/event_groups.h"

#include "esp_event.h"
#include "esp_log.h"

#include "nvs_flash.h"

#include "lwip/err.h"
#include "lwip/sockets.h"
#include "lwip/sys.h"

#include "driver/gpio.h"

#include <rom/ets_sys.h>

#include "driver/rmt_tx.h"
#include "driver/rmt_rx.h"

#include "ir_codec.h"
#include "debug.h"
#include "wifi.h"
#include "rxtx.h"

#define PORT                        CONFIG_PORT
#define KEEPALIVE_IDLE              CONFIG_KEEPALIVE_IDLE
#define KEEPALIVE_INTERVAL          CONFIG_KEEPALIVE_INTERVAL
#define KEEPALIVE_COUNT             CONFIG_KEEPALIVE_COUNT

static const char *TAG = "TCP server";

static void ir_server(const int sock)
{   
    
    rmt_channel_handle_t tx_channel;
    rmt_transmit_config_t config = {
        .loop_count = 0, 
    };
    init_tx_channel(&tx_channel);
    
    rmt_channel_handle_t rx_channel;
    QueueHandle_t receive_queue;
    init_rx_channel(&rx_channel, &receive_queue);

    rmt_symbol_word_t raw_symbols[MEM_BLOCK_SYMBOLS]; 
    rmt_rx_done_event_data_t rx_data;
    
    ir_jetpoint_settings settings;
    set_jetpoint_settings(&settings, 1, 1, 1, 25, 0, 0);
    
    rmt_encoder_handle_t jetpoint_encoder = NULL;
    ESP_ERROR_CHECK(rmt_new_jetpoint_encoder(&jetpoint_encoder));

    int len;
    char tcp_rx_buffer[128];
    
    for(int i = 0; i < 2;i++) len = recv(sock, tcp_rx_buffer, sizeof(tcp_rx_buffer) - 1, 0);  // Filter out connection messages 
    
    do {    // loop receiving TCP messages
        ESP_LOGI(TAG,"Waiting for command");
        len = recv(sock, tcp_rx_buffer, sizeof(tcp_rx_buffer) - 1, 0);
        tcp_rx_buffer[len] = '\0';
        if (len < 0) {
            ESP_LOGE(TAG, "Error occurred during receiving: errno %d", errno);
        } else if (len == 0) {
            ESP_LOGW(TAG, "Connection closed");
            
            rmt_disable(rx_channel);
            rmt_disable(tx_channel);
            rmt_del_channel(rx_channel);
            rmt_del_channel(tx_channel);
        }
        else
        {
            if (!strcmp(tcp_rx_buffer, "rx"))
            {
                ESP_LOGI(TAG,"****** RX ******");
            
                receiveIR(&rx_channel, raw_symbols);
                xQueueReceive(receive_queue, &rx_data, pdMS_TO_TICKS(10000));
        
                char decoded_message[DATA_BITS];
                rmt_decode_manchester(rx_data.received_symbols, rx_data.num_symbols, decoded_message);
                print_data("Decoded message", decoded_message, 16, 16);

                ESP_LOGI(TAG, "****** RX END ******");
            }
            else if (!strcmp(tcp_rx_buffer, "tx"))
            {
                
                ESP_ERROR_CHECK(rmt_transmit(tx_channel, jetpoint_encoder, &settings, sizeof(settings), &config));
                ESP_ERROR_CHECK(rmt_tx_wait_all_done(tx_channel, portMAX_DELAY));
                
            }
            else if(!strcmp(tcp_rx_buffer, "rxtx")){

                ESP_LOGI(TAG, "****** RXTX ******");
                receiveIR(&rx_channel, raw_symbols);

                ESP_ERROR_CHECK(rmt_transmit(tx_channel, jetpoint_encoder, &settings, sizeof(settings), &config));
                ESP_ERROR_CHECK(rmt_tx_wait_all_done(tx_channel, portMAX_DELAY));
                
                xQueueReceive(receive_queue, &rx_data, pdMS_TO_TICKS(10000));
                char decoded_message[DATA_BITS];
                
                rmt_decode_manchester(rx_data.received_symbols, rx_data.num_symbols, decoded_message);

                print_data("Decoded message", decoded_message, 16, 16);

                ESP_LOGI(TAG, "****** RXTX END ******");

            }
            else if(!strncmp(tcp_rx_buffer, "set", 3)){

                uint8_t power, mode, fan, temperature, swing, sleep;

                if (sscanf(tcp_rx_buffer, "set %hhu %hhu %hhu %hhu %hhu %hhu", &power, &mode, &fan, &temperature, &swing, &sleep) == 6)
                {
                    set_jetpoint_settings(&settings, power, mode, fan, temperature, swing, sleep);
                    ESP_LOGI(TAG, "Settings applied: Power=%d, Mode=%d, Fan=%d, Temp= %d, Swing=%d, Sleep=%d\n",
                            settings.power, settings.mode, settings.fan, settings.temperature + 16, settings.swing, settings.sleep);
                }
                else
                {
                    ESP_LOGI(TAG,"Incorrect format");
                }
            }
            else if(!strncmp(tcp_rx_buffer,"freq", 4)){

                int freq;
                if (sscanf(tcp_rx_buffer, "freq %d", &freq)){

                    rmt_carrier_config_t carrier_cfg = {
                        .duty_cycle = 0.33,
                        .frequency_hz = freq,
                    };

                    ESP_ERROR_CHECK(rmt_apply_carrier(tx_channel, &carrier_cfg));
                }

            }
            else{
                ESP_LOGI(TAG, "Invalid command.");
            }
        }

    } while (len > 0);
}

static void tcp_server_task(void *pvParameters)
{
    char addr_str[128];
    int addr_family = (int)pvParameters;
    int ip_protocol = 0;
    int keepAlive = 1;
    int keepIdle = KEEPALIVE_IDLE;
    int keepInterval = KEEPALIVE_INTERVAL;
    int keepCount = KEEPALIVE_COUNT;
    struct sockaddr_storage dest_addr;

    if (addr_family == AF_INET) {
        struct sockaddr_in *dest_addr_ip4 = (struct sockaddr_in *)&dest_addr;
        dest_addr_ip4->sin_addr.s_addr = htonl(INADDR_ANY);
        dest_addr_ip4->sin_family = AF_INET;
        dest_addr_ip4->sin_port = htons(PORT);
        ip_protocol = IPPROTO_IP;
    }

    int listen_sock = socket(addr_family, SOCK_STREAM, ip_protocol);
    if (listen_sock < 0) {
        ESP_LOGE(TAG, "Unable to create socket: errno %d", errno);
        vTaskDelete(NULL);
        return;
    }
    int opt = 1;
    setsockopt(listen_sock, SOL_SOCKET, SO_REUSEADDR, &opt, sizeof(opt));

    ESP_LOGI(TAG, "Socket created");

    int err = bind(listen_sock, (struct sockaddr *)&dest_addr, sizeof(dest_addr));
    if (err != 0) {
        ESP_LOGE(TAG, "Socket unable to bind: errno %d", errno);
        ESP_LOGE(TAG, "IPPROTO: %d", addr_family);
        goto CLEAN_UP;
    }
    ESP_LOGI(TAG, "Socket bound, port %d", PORT);

    err = listen(listen_sock, 1);
    if (err != 0) {
        ESP_LOGE(TAG, "Error occurred during listen: errno %d", errno);
        goto CLEAN_UP;
    }

    while (1) {

        ESP_LOGI(TAG, "Socket listening");

        struct sockaddr_storage source_addr; // Large enough for both IPv4 or IPv6
        socklen_t addr_len = sizeof(source_addr);
        int sock = accept(listen_sock, (struct sockaddr *)&source_addr, &addr_len);
        if (sock < 0) {
            ESP_LOGE(TAG, "Unable to accept connection: errno %d", errno);
            break;
        }

        // Set tcp keepalive option
        setsockopt(sock, SOL_SOCKET, SO_KEEPALIVE, &keepAlive, sizeof(int));
        setsockopt(sock, IPPROTO_TCP, TCP_KEEPIDLE, &keepIdle, sizeof(int));
        setsockopt(sock, IPPROTO_TCP, TCP_KEEPINTVL, &keepInterval, sizeof(int));
        setsockopt(sock, IPPROTO_TCP, TCP_KEEPCNT, &keepCount, sizeof(int));
        // Convert ip address to string

    if (source_addr.ss_family == PF_INET) {
        inet_ntoa_r(((struct sockaddr_in *)&source_addr)->sin_addr, addr_str, sizeof(addr_str) - 1);
    }

        ESP_LOGI(TAG, "Socket accepted ip address: %s", addr_str);

        ir_server(sock);

        shutdown(sock, 0);
        close(sock);
    }

CLEAN_UP:
    close(listen_sock);
    vTaskDelete(NULL);
}


void app_main(void)
{
    esp_err_t ret = nvs_flash_init();
    if (ret == ESP_ERR_NVS_NO_FREE_PAGES || ret == ESP_ERR_NVS_NEW_VERSION_FOUND) {
      ESP_ERROR_CHECK(nvs_flash_erase());
      ret = nvs_flash_init();
    }
    ESP_ERROR_CHECK(ret);

    ESP_LOGI(TAG, "ESP_WIFI_MODE_STA");

    wifi_connect_sta();

    xTaskCreate(tcp_server_task, "tcp_server", 4096, (void*)AF_INET, 5, NULL);

    while(1){ // wifi busy loop

        EventBits_t bits = xEventGroupGetBits(wifi_event_group);

        if(bits & WIFI_CONNECTED_BIT) {
            ESP_LOGI(TAG, "Wi-Fi connected...");
        } else {
            ESP_LOGI(TAG, "Wi-Fi connection lost.");
            break;
        }
        vTaskDelay(pdMS_TO_TICKS(10*1000));
    }

}