#include <time.h>

#include <esp_https_server.h>
#include "esp_tls.h"
#include "driver/rmt_tx.h"
#include "esp_netif_sntp.h"
#include "esp_log.h"

#include "wifi.h"
#include "http_file_ops.h"
#include "ir_http_server.h"
#include "server_schedule.h"
#include "uri_handlers.h"

#define USE_HTTPS false
#define DEBUG_HTTPS_CONNECTION false
#define SERVER_PORT_HTTP 8080
#define SERVER_PORT_HTTPS 8443
#define HTTP_DATE_SIZE 30 // Enough to hold "Day, DD Mon YYYY HH:MM:SS GMT"

#define GPIO_IR_TX   27
#define MEM_BLOCK_SYMBOLS 128
#define CHANNEL_RESOLUTION 1000000 
#define CHANNEL_DC 0.33
#define CARRIER_FREQ 33000

static const char *TAG = "IR receiver http server";

esp_err_t sntp_sync(){

    esp_sntp_config_t config = ESP_NETIF_SNTP_DEFAULT_CONFIG("pool.ntp.org");
    esp_netif_sntp_init(&config);

    int retry = 0;
    int retry_count = 4;

    while (esp_netif_sntp_sync_wait(10000 / portTICK_PERIOD_MS) == ESP_ERR_TIMEOUT && ++retry < retry_count)
    {
        ESP_LOGI(TAG, "Waiting for system time to be set... (%d/%d)", retry, retry_count);
    }

    esp_netif_sntp_deinit();
    return ESP_OK;
}
const char* get_http_date(){
    static char http_date[HTTP_DATE_SIZE]; // Static buffer to hold the date
    static time_t last_sync_time = 0; // sync on first run

    time_t now = time(NULL);
    
        
    if(now - last_sync_time >= 24 * 60 * 60) {

        last_sync_time = now;
        sntp_sync();
    }

    struct tm *gm_tm = gmtime(&now);
    strftime(http_date, HTTP_DATE_SIZE, "%a, %d %b %Y %H:%M:%S GMT", gm_tm);
    return http_date;
}

esp_err_t initialize_tx_component(tx_context* tx_ctx) {
    
    rmt_tx_channel_config_t tx_chan_config = {
        .clk_src = RMT_CLK_SRC_DEFAULT,
        .gpio_num = GPIO_IR_TX,
        .mem_block_symbols = MEM_BLOCK_SYMBOLS,
        .resolution_hz = CHANNEL_RESOLUTION,
        .trans_queue_depth = 4,
    };
    ESP_ERROR_CHECK(rmt_new_tx_channel(&tx_chan_config, tx_ctx->tx_channel));
    ESP_ERROR_CHECK(rmt_new_jetpoint_encoder(tx_ctx->ir_encoder));

    set_jetpoint_settings(tx_ctx->ir_settings, 0, 1, 1, 25, 0, 0);
    tx_ctx->tx_config->loop_count = 0;

    rmt_carrier_config_t carrier_cfg = {
        .duty_cycle = CHANNEL_DC,
        .frequency_hz = CARRIER_FREQ,
    };

    ESP_ERROR_CHECK(rmt_apply_carrier(*tx_ctx->tx_channel, &carrier_cfg));
    rmt_enable(*tx_ctx->tx_channel);

    return ESP_OK;
}

esp_err_t setup_server_context(server_context* server_ctx) {
    
    initialize_tx_component(server_ctx->tx_ctx);

    // Allocate shared resources
    char* file_buf = malloc(FILE_BUF_SIZE);
    char* schedule_buf = malloc(SCHEDULE_BUF_SIZE);
    if (!file_buf ) {
        ESP_LOGE(TAG, "Failed to allocate memory for file storage");
        return ESP_ERR_NO_MEM;
    }
    server_ctx->file_buf = file_buf;
    server_ctx->scheduler_ctx->schedule_data = schedule_buf;

    return ESP_OK;
}


#ifdef CONFIG_ESP_TLS_USING_MBEDTLS
#ifdef DEBUG_HTTPS_CONNECTION
static void print_peer_cert_info(const mbedtls_ssl_context *ssl)
{
    const mbedtls_x509_crt *cert;
    const size_t buf_size = 1024;
    char *buf = calloc(buf_size, sizeof(char));
    if (buf == NULL) {
        ESP_LOGE(TAG, "Out of memory - Callback execution failed!");
        return;
    }

    // Logging the peer certificate info
    cert = mbedtls_ssl_get_peer_cert(ssl);
    if (cert != NULL) {
        mbedtls_x509_crt_info((char *) buf, buf_size - 1, "    ", cert);
        ESP_LOGI(TAG, "Peer certificate info:\n%s", buf);
    } else {
        ESP_LOGW(TAG, "Could not obtain the peer certificate!");
    }

    free(buf);
}

static void https_server_user_callback(esp_https_server_user_cb_arg_t *user_cb)
{
    ESP_LOGI(TAG, "User callback invoked!");
#ifdef CONFIG_ESP_TLS_USING_MBEDTLS
    mbedtls_ssl_context *ssl_ctx = NULL;
#endif
    switch(user_cb->user_cb_state) {
        case HTTPD_SSL_USER_CB_SESS_CREATE:
            ESP_LOGD(TAG, "At session creation");
            // Logging the socket FD
            int sockfd = -1;
            esp_err_t esp_ret;
            esp_ret = esp_tls_get_conn_sockfd(user_cb->tls, &sockfd);
            if (esp_ret != ESP_OK) {
                ESP_LOGE(TAG, "Error in obtaining the sockfd from tls context");
                break;
            }
            ESP_LOGI(TAG, "Socket FD: %d", sockfd);
#ifdef CONFIG_ESP_TLS_USING_MBEDTLS
            ssl_ctx = (mbedtls_ssl_context *) esp_tls_get_ssl_context(user_cb->tls);
            if (ssl_ctx == NULL) {
                ESP_LOGE(TAG, "Error in obtaining ssl context");
                break;
            }
            // Logging the current ciphersuite
            ESP_LOGI(TAG, "Current Ciphersuite: %s", mbedtls_ssl_get_ciphersuite(ssl_ctx));
#endif
            break;

        case HTTPD_SSL_USER_CB_SESS_CLOSE:
            ESP_LOGD(TAG, "At session close");
#ifdef CONFIG_ESP_TLS_USING_MBEDTLS
            // Logging the peer certificate
            ssl_ctx = (mbedtls_ssl_context *) esp_tls_get_ssl_context(user_cb->tls);
            if (ssl_ctx == NULL) {
                ESP_LOGE(TAG, "Error in obtaining ssl context");
                break;
            }
            print_peer_cert_info(ssl_ctx);
#endif
            break;
        default:
            ESP_LOGE(TAG, "Illegal state!");
            return;
    }
}
#endif //DEBUG_HTTPS_CONNECTION
#endif

void load_embedded_certs(httpd_ssl_config_t *conf){
    extern const unsigned char servercert_start[] asm("_binary_servercert_pem_start");
    extern const unsigned char servercert_end[]   asm("_binary_servercert_pem_end");
    conf->servercert = servercert_start;
    conf->servercert_len = servercert_end - servercert_start;

    extern const unsigned char prvtkey_pem_start[] asm("_binary_prvtkey_pem_start");
    extern const unsigned char prvtkey_pem_end[]   asm("_binary_prvtkey_pem_end");
    conf->prvtkey_pem = prvtkey_pem_start;
    conf->prvtkey_len = prvtkey_pem_end - prvtkey_pem_start;
}

esp_err_t configure_encrypted_server(httpd_ssl_config_t* conf) {
    load_embedded_certs(conf);
    conf->httpd.lru_purge_enable = true;
    conf->port_secure = SERVER_PORT_HTTPS;
    conf->transport_mode = HTTPD_SSL_TRANSPORT_SECURE;
    conf->httpd.max_uri_handlers = 10;
    conf->httpd.uri_match_fn = httpd_uri_match_wildcard;

    return ESP_OK;
}

esp_err_t config_unencrypted_server(httpd_config_t *conf){
    conf->lru_purge_enable = true;
    conf->server_port = SERVER_PORT_HTTP;
    conf->max_uri_handlers = 10;
    conf->uri_match_fn = httpd_uri_match_wildcard;
    
    return ESP_OK;

}
esp_err_t start_ir_webserver(server_context* server_ctx) {

    httpd_ssl_config_t encrypted_conf = HTTPD_SSL_CONFIG_DEFAULT();
    httpd_config_t unencrypted_conf = HTTPD_DEFAULT_CONFIG();
    esp_err_t ret;
    if(USE_HTTPS)
    {
        configure_encrypted_server(&encrypted_conf);
        ESP_LOGI(TAG, "Starting https server on port: '%d'", encrypted_conf.port_secure);
        ret = httpd_ssl_start(server_ctx->server, &encrypted_conf);
    }
    else {
        config_unencrypted_server(&unencrypted_conf);
        ESP_LOGI(TAG, "Starting http server on port: '%d'", unencrypted_conf.server_port);
        ret = httpd_start(server_ctx->server, &unencrypted_conf);
    }
    
    if (ret != ESP_OK) {
        ESP_LOGE(TAG, "Failed to start server: %s", esp_err_to_name(ret));
        free(server_ctx->file_buf);
        server_ctx->file_buf = NULL;
        return ESP_FAIL;
    }
    register_uri_handlers(server_ctx);
    
    return ESP_OK;
}

esp_err_t stop_ir_webserver(server_context* server_ctx)
{   
    tx_context* tx_ctx = server_ctx->tx_ctx;

    free(server_ctx->file_buf);
    free(server_ctx->scheduler_ctx->schedule_data);
    rmt_disable(*tx_ctx->tx_channel);
    rmt_del_channel(*tx_ctx->tx_channel);
    return httpd_stop(*server_ctx->server);
}

void disconnect_handler(void* arg, esp_event_base_t event_base,
                               int32_t event_id, void* event_data)
{
    server_context* server_ctx = (server_context*) arg;
    if (!server_ctx->server) {
        ESP_LOGI(TAG, "Stopping webserver");
        if (stop_ir_webserver(server_ctx) == ESP_OK) {
            server_ctx->server = NULL;
        } else {
            ESP_LOGE(TAG, "Failed to stop http server");
        }
    }
}
void connect_handler(void* arg, esp_event_base_t event_base,
                            int32_t event_id, void* event_data)
{
    server_context *server_ctx = (server_context *)arg;

    if (server_ctx->server == NULL) {
        ESP_LOGI(TAG, "Starting webserver");
        setup_server_context(server_ctx);
        start_ir_webserver(server_ctx);
    }
}

void ir_http_server_task(void *pvParameters)
{
    httpd_handle_t server = NULL;
    rmt_channel_handle_t tx_channel = {0};
    rmt_transmit_config_t tx_config = {0};
    rmt_encoder_handle_t ir_encoder = {0};
    ir_jetpoint_settings ir_settings = {0};
    tx_context tx_ctx = {
        .tx_channel = &tx_channel,
        .tx_config = &tx_config,
        .ir_encoder = &ir_encoder,
        .ir_settings = &ir_settings,
    };
    
    TaskHandle_t scheduler_task;
    SemaphoreHandle_t sched_data_sem = xSemaphoreCreateBinary();
    xSemaphoreGive(sched_data_sem);
    
    ac_scheduler_context scheduler_ctx = {
        .schedule_uri_bSemaphore = &sched_data_sem,
        .schedule_data = NULL,
    };
    
    server_context server_ctx = {
        .server = &server,
        .tx_ctx = &tx_ctx,
        .scheduler_ctx = &scheduler_ctx,
        .file_buf = NULL,
    };

    if (setup_server_context(&server_ctx) != ESP_OK)
    {
        ESP_LOGE(TAG, "Failed to setup server context");
        vTaskDelete(NULL);
    }

    start_ir_webserver(&server_ctx);
    register_connect_disconnect_handlers((void *)&server_ctx);
    xTaskCreate(ac_scheduler_task, "ac_scheduler", 4096, (void*)&server_ctx, 5, &scheduler_task);
    scheduler_ctx.scheduler_task = scheduler_task;
    mount_spiffs_storage();

    while (1)
    {
        vTaskDelay(pdMS_TO_TICKS(5 * 1000));
    }

    stop_ir_webserver(&server_ctx);
}