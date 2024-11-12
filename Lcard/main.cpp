#include <windows.h>
#include <stdio.h>
#include "hiredis/hiredis/hiredis.h"
#include "Lcard_wrapper.h"
#include "redis_wrapper.h"

#define MAX_SIZE 100000
#define REDIS_IP "127.0.0.1"
#define REDIS_PORT 6379

void measurement_loop(redisContext* command_ctx, redisContext* data_ctx, PTLTR114 ltr) {
    float measurements[MAX_SIZE];
    int measurement_count = 0;

    while (1) {
        // Check for stop command
        redisReply* reply = (redisReply*)redisCommand(command_ctx, "BLPOP command_channel 0");
        if (reply != NULL && strcmp(reply->element[1]->str, "stop") == 0) {
            freeReplyObject(reply);
            break;
        }
        freeReplyObject(reply);

        // Collect data
        float data_point = get_ltr_data(ltr);
        measurements[measurement_count++] = data_point;

        if (measurement_count == MAX_SIZE) {
            send_data_to_redis(data_ctx, measurements, measurement_count);
            measurement_count = 0;
        }
    }

    // Send remaining data
    if (measurement_count > 0) {
        send_data_to_redis(data_ctx, measurements, measurement_count);
    }
}

int main() {
    printf("Programm starting...\n");
    fflush(stdout);

    // Initialize Redis contexts for command and data channels
    redisContext* command_ctx = redisConnect(REDIS_IP, REDIS_PORT);
    redisContext* data_ctx = redisConnect(REDIS_IP, REDIS_PORT);
    if (command_ctx == NULL || command_ctx->err || data_ctx == NULL || data_ctx->err) {
        printf("Error connecting to Redis: %s\n", command_ctx->errstr);
        return 1;
    }

    // Wait for start command
    while (1) {
        redisReply* reply = (redisReply*)redisCommand(command_ctx, "BLPOP command_channel 0");
        if (reply != NULL && strcmp(reply->element[1]->str, "start") == 0) {
            printf("Start command received.\n");
            freeReplyObject(reply);
            break;
        }
        freeReplyObject(reply);
    }

    // Initialize photodiode
    PTLTR114 ltr = init_photodiod();
    if (ltr == NULL) {
        printf("Error initializing photodiode.\n");
        return 1;
    }

    // Start measurement loop
    measurement_loop(command_ctx, data_ctx, ltr);

    printf("Measurement stopped.\n");
    redisFree(command_ctx);
    redisFree(data_ctx);
    return 0;
}
