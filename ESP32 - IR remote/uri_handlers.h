#ifndef URI_HANDLERS_H
#define URI_HANDLERS_H

#include "http_file_ops.h"
#include "ir_http_server.h"
#include "ir_codec.h"

esp_err_t register_uri_handlers(server_context *server_ctx);

#endif //URI_HANDLERS_H