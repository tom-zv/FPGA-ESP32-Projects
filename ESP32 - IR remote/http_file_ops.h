#ifndef HTTP_FILE_OPS_H
#define HTTP_FILE_OPS_H

#include "esp_err.h"
#include <esp_https_server.h>

#define FS_BASE_PATH "/irserver"
#define FILE_BUF_SIZE  8192

esp_err_t mount_spiffs_storage();

esp_err_t resp_send_file(httpd_req_t *req, const char *filename);

esp_err_t resp_listdir(httpd_req_t *req, const char *dirpath);

esp_err_t upload_file(httpd_req_t *req);

#endif // HTTP_FILE_OPS_H