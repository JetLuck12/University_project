import time
import redis
import json

message = {'cmd' : '',
           'motor' : '',
           'arg1' : 0,
           'arg2' : 0}

redis_host = '192.168.197.189'
redis_port = 6379
controller_commands_channel = 'controller_commands'
controller_output_channel = 'controller_output'

controller_commands_redis = redis.StrictRedis(host=redis_host, port=redis_port, db=0)
controller_commands_pubsub = controller_commands_redis.pubsub()
controller_commands_pubsub.subscribe(controller_commands_channel)

controller_output_redis = redis.StrictRedis(host=redis_host, port=redis_port, db=0)
controller_output_pubsub = controller_output_redis.pubsub()
controller_output_pubsub.subscribe(controller_output_channel)

def listen_from_controller():
    time.sleep(1)
    message_ = controller_output_pubsub.parse_response()
    if message_:
        if message_[0] == "Unknown":
            print("Unknown command, try help")
        elif message_[0].decode('utf-8') == 'subscribe':
            return
        else:
            print(message_)

if __name__ == "__main__":
    controller_output_pubsub.parse_response()
    while 1:
        data = input("Print the command: ").lower().split(' ')
        print(data)
        if data[0] == "help":
               print("List of commands and args:")
               print("Load             [\"filename\"]")
               print("Save             [\"filename\"]")
               print("Create           [\"family\\domain\\name\"]")
               print("Add              [motor, axis]")
               print("Delete           [motor, axis]")
               print("Pos              [motor, axis]")
               print("State            [motor, axis]")
               print("Start            [motor, axis]")
               print("Stop             [motor, axis]")
               print("Status           [motor, axis]")
               print("Calibrate        [diode_motor, size]")
        else:
            if len(data) > 1:
                message['cmd'] = data[0]
                message['motor'] = data[1]
                if len(data) > 2:
                    message['arg1'] = data[2]
                else:
                    message['arg1'] = ''
                if len(data) > 3:
                    message['arg2'] = data[3]
                else:
                    message['arg2'] = ''

                json_pub = json.dumps(message)
                controller_commands_redis.publish(controller_commands_channel,json_pub)
                listen_from_controller()
            else:
                print("Not enough arguments")