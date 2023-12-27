#include <stdio.h>
#include <string.h>
#include <time.h>

#include <esp_http_server.h>
#include "esp_netif.h"
#include "esp_event.h"
#include "esp_log.h"
#include <rom/ets_sys.h>
#include "driver/rmt_tx.h"
#include "freertos/FreeRTOS.h"
#include "freertos/task.h"
#include "freertos/event_groups.h"
#include "nvs_flash.h"

#include "ir_http_server.h"
#include "ir_codec.h"
#include "wifi.h"

#define PORT                        CONFIG_PORT
#define KEEPALIVE_IDLE              CONFIG_KEEPALIVE_IDLE
#define KEEPALIVE_INTERVAL          CONFIG_KEEPALIVE_INTERVAL
#define KEEPALIVE_COUNT             CONFIG_KEEPALIVE_COUNT

static const char *TAG = "IR receiver main";

void app_main(void)
{
    esp_err_t ret = nvs_flash_init();
    if (ret == ESP_ERR_NVS_NO_FREE_PAGES || ret == ESP_ERR_NVS_NEW_VERSION_FOUND) {
      ESP_ERROR_CHECK(nvs_flash_erase());
      ret = nvs_flash_init();
    }
    ESP_ERROR_CHECK(ret);

    //ESP_LOGI(TAG, "ESP_WIFI_MODE_STA");
    esp_log_level_set("wifi", ESP_LOG_WARN);
    wifi_connect_sta();

    setenv("TZ", "IST-2IDT,M3.4.4/26,M10.5.0", 1); // israel
    tzset();

    sntp_sync();
    
    xTaskCreate(ir_http_server_task, "http_server", 4096, NULL, 5, NULL);

    while(1){ // wifi busy loop

        EventBits_t bits = xEventGroupGetBits(wifi_event_group);

        if(bits & WIFI_CONNECTED_BIT) {
            //ESP_LOGI(TAG, "Wi-Fi connected...");
        } else {
            ESP_LOGI(TAG, "Wi-Fi connection lost.");
            break;
        }
        vTaskDelay(pdMS_TO_TICKS(10*1000));
    }

}