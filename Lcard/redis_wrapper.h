#ifndef REDIS_WRAPPER_H
#define REDIS_WRAPPER_H

#include "hiredis/hiredis/hiredis.h"

void send_data_to_redis(redisContext* data_ctx, float* data, int length);

#endif // REDIS_WRAPPER_H
