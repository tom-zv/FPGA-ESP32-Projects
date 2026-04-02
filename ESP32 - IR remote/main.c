#include <stdio.h>
#include <string.h>
#include <time.h>

#include "freertos/FreeRTOS.h"
#include "freertos/task.h"
#include "freertos/event_groups.h"
#include "nvs_flash.h"
#include "esp_log.h"
#include "esp_netif.h"
#include "esp_event.h"

#include "ir_http_server.h"
#include "wifi.h"

static const char *TAG = "IR remote main";

void app_main(void)
{
    esp_err_t ret = nvs_flash_init();
    if (ret == ESP_ERR_NVS_NO_FREE_PAGES || ret == ESP_ERR_NVS_NEW_VERSION_FOUND) {
        ESP_ERROR_CHECK(nvs_flash_erase());
        ret = nvs_flash_init();
    }
    ESP_ERROR_CHECK(ret);

    esp_log_level_set("wifi", ESP_LOG_WARN);
    wifi_connect_sta();

    setenv("TZ", "IST-2IDT,M3.4.4/26,M10.5.0", 1); // Israel timezone
    tzset();

    sntp_sync();

    xTaskCreate(ir_http_server_task, "http_server", 4096, NULL, 5, NULL);

    // Monitor Wi-Fi connection; reconnect logic is handled in event handlers
    while (1) {
        EventBits_t bits = xEventGroupGetBits(wifi_event_group);
        if (!(bits & WIFI_CONNECTED_BIT)) {
            ESP_LOGI(TAG, "Wi-Fi connection lost.");
            break;
        }
        vTaskDelay(pdMS_TO_TICKS(10 * 1000));
    }
}