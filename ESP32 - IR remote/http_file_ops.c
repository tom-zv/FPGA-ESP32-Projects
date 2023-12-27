#include <sys/stat.h>
#include <esp_http_server.h>
#include "esp_vfs.h"
#include "esp_spiffs.h"
#include "esp_log.h"

#include "http_file_ops.h"
#include "ir_http_server.h"

#define FS_BASE_LEN (sizeof(FS_BASE_PATH) - 1)
#define FILE_NAME_MAX (CONFIG_SPIFFS_OBJ_NAME_LEN)
#define DIR_LIST_SIZE 2048
#define MAX_FILE_SIZE   (128*1024) 
#define MAX_FILE_SIZE_STR "128KB"


#define IS_FILE_EXT(filename, ext) \
    (strcasecmp(&filename[strlen(filename) - sizeof(ext) + 1], ext) == 0)

static char* TAG = "http file ops";

esp_err_t mount_spiffs_storage() {

    esp_vfs_spiffs_conf_t conf = {
        .base_path = FS_BASE_PATH,
        .partition_label = "html",
        .max_files = 5, // at the same time
        .format_if_mount_failed = true,        
    };

    esp_err_t ret = esp_vfs_spiffs_register(&conf);

    if (ret != ESP_OK) {
        if (ret == ESP_FAIL) {
            ESP_LOGE(TAG, "Failed to mount or format filesystem");
        } else if (ret == ESP_ERR_NOT_FOUND) {
            ESP_LOGE(TAG, "Failed to find SPIFFS partition");
        } else {
            ESP_LOGE(TAG, "Failed to initialize SPIFFS (%s)", esp_err_to_name(ret));
        }
        return ret;
    }

    return ESP_OK;
}

esp_err_t set_content_type_from_file(httpd_req_t *req, const char *filename)
{ 
    if (IS_FILE_EXT(filename, ".html")) {  // currently only support HTML files
        return httpd_resp_set_type(req, "text/html");
    }
    else if (IS_FILE_EXT(filename, ".js")) {
        return httpd_resp_set_type(req, "application/javascript");
    }
    else if (IS_FILE_EXT(filename, ".css")) {
        return httpd_resp_set_type(req,"text/css");
    }
    /* For any other type always set as plain text */
    return httpd_resp_set_type(req, "text/plain");
}

esp_err_t resp_send_file(httpd_req_t *req, const char *filename){

    FILE *fd = NULL;
    char filepath[FS_BASE_LEN + FILE_NAME_MAX + 1 + 1]; // +1 for null, +1 for '/' between base_path and filename
    struct stat file_stat;

    snprintf(filepath, sizeof(filepath), "%s/%s", FS_BASE_PATH, filename);

    if (stat(filepath, &file_stat) == -1) {
        ESP_LOGE(TAG, "Failed to stat file : %s", filepath);
        httpd_resp_send_err(req, HTTPD_404_NOT_FOUND, "File does not exist");
        return ESP_FAIL;
    }

    //ESP_LOGI(TAG, "Serving file : %s, filesize : %dB", filepath, (int)file_stat.st_size);
    fd = fopen(filepath, "r");
    if (fd == NULL) {
        ESP_LOGE(TAG, "Failed to read file : %s", filename);
        httpd_resp_send_err(req, HTTPD_500_INTERNAL_SERVER_ERROR, "Failed to read file");
        return ESP_FAIL;
    }

    char* file_buf = (char*)req->user_ctx;

    set_content_type_from_file(req, filename);
    size_t read_size;
    if(file_stat.st_size <= MAX_FILE_SIZE){
        read_size = fread(file_buf, 1, file_stat.st_size, fd);
        httpd_resp_send(req, file_buf, read_size);
    }
    else{
        while ((read_size = fread(file_buf, 1, FILE_BUF_SIZE, fd)) > 0)
        {
            httpd_resp_send_chunk(req, file_buf, read_size);
        }
        httpd_resp_send_chunk(req, NULL, 0); // End of chunks
    }
    
    fclose(fd);
    return ESP_OK;
}

// send a json listing the indicated directory
esp_err_t resp_listdir(httpd_req_t *req, const char *dirpath){
    char entry_path[FS_BASE_LEN + FILE_NAME_MAX + 1 + 1];
    char *dir_list = malloc(DIR_LIST_SIZE);

    struct dirent *entry;
    struct stat entry_stat;

    DIR *dir = opendir(dirpath);
    const size_t dirpath_len = strlen(dirpath) + 1; // +1 for '/' 

    snprintf(entry_path, sizeof(entry_path), "%s/", dirpath);

    if (!dir) {
        ESP_LOGE(TAG, "Failed to open dir : %s", dirpath);
        httpd_resp_send_err(req, HTTPD_404_NOT_FOUND, "Directory does not exist");
        return ESP_FAIL;
    }

    size_t bytes_written = snprintf(dir_list, DIR_LIST_SIZE, "{");;

    entry = readdir(dir);
    while(entry != NULL) {
        strlcpy(entry_path+dirpath_len, entry->d_name, sizeof(entry_path) - dirpath_len);
        if (stat(entry_path, &entry_stat) == 0)
        {
            bytes_written += snprintf(dir_list + bytes_written, DIR_LIST_SIZE - bytes_written, "\"%s\":%d", entry->d_name, (int)entry_stat.st_size);
        }
        entry = readdir(dir);
        if (entry != NULL)  {
            bytes_written += snprintf(dir_list + bytes_written, DIR_LIST_SIZE - bytes_written, ",");
        }
    }
    bytes_written += snprintf(dir_list + bytes_written, DIR_LIST_SIZE - bytes_written, "}");
    httpd_resp_set_type(req, "application/json");
    httpd_resp_send(req, dir_list, bytes_written);

    free(dir_list);
    closedir(dir);
    return ESP_OK;
}

esp_err_t upload_file(httpd_req_t *req){

    char filename[FILE_NAME_MAX + 1];
    char filepath[FS_BASE_LEN + FILE_NAME_MAX + 1 + 1]; // +1 for null, +1 for '/'

    if (req->content_len > MAX_FILE_SIZE) {
        ESP_LOGE(TAG, "File too large : %d bytes", req->content_len);
        httpd_resp_send_err(req, HTTPD_400_BAD_REQUEST,
                            "File size must be less than "
                            MAX_FILE_SIZE_STR "!");
        return ESP_FAIL;
    }

    strlcpy(filename, req->uri + sizeof("/upload/") - 1, sizeof(filename));

    // filename cant have trailing '/'
    if (filename[strlen(filename) - 1] == '/') {
        ESP_LOGE(TAG, "Invalid filename : %s", filename);
        httpd_resp_send_err(req, HTTPD_500_INTERNAL_SERVER_ERROR, "Invalid filename");
        return ESP_FAIL;
    }

    snprintf(filepath, sizeof(filepath), "%s/%s", FS_BASE_PATH, filename); 

    FILE *fd = NULL;
    //overwrites allowed
    fd = fopen(filepath, "w");
    if (fd == NULL) {
        ESP_LOGE(TAG, "Failed to create file : %s", filename);
        httpd_resp_send_err(req, HTTPD_500_INTERNAL_SERVER_ERROR, "Failed to create file");
        return ESP_FAIL;
    }

    char* file_buf = (char*) req->user_ctx;

    size_t received = 0;
    size_t remaining = req->content_len;

    while (remaining > 0) {
        // Receive chunk from content body
        if((received = httpd_req_recv(req, file_buf, FILE_BUF_SIZE)) <= 0){
            if (received == HTTPD_SOCK_ERR_TIMEOUT) {
                /* Retry on timeout */
                continue;
            }
            fclose(fd);
            unlink(filepath);
            ESP_LOGE(TAG, "File reception failed!");
            /* Respond with 500 Internal Server Error */
            httpd_resp_send_err(req, HTTPD_500_INTERNAL_SERVER_ERROR, "Failed to receive file");
            return ESP_FAIL;
        }

        // write received data to file
        if (received && (received != fwrite(file_buf, 1, received, fd))) {
            // Couldn't write everything to file 
            fclose(fd);
            unlink(filepath);

            ESP_LOGE(TAG, "File write failed!");
            httpd_resp_send_err(req, HTTPD_500_INTERNAL_SERVER_ERROR, "Failed to write file to storage");
            return ESP_FAIL;
        }

        remaining -= received;
    }

    fclose(fd);
    httpd_resp_sendstr(req, "File uploaded successfully");
    return ESP_OK;
};



