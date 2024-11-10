#include "redis_wrapper.h"
#include "hiredis.h"

void send_data_to_redis(redisContext* data_ctx, float* data, int length) {
    for (int i = 0; i < length; ++i) {
        redisCommand(data_ctx, "RPUSH data_channel %f", data[i]);
    }
}
