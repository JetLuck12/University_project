# This Python file uses the following encoding: utf-8
import redis

class Redis_Wrapper:
    def __init__(self, ip, port):
        self.redis = redis.StrictRedis(host=ip, port=port, decode_responses=True)

    def send_command(self, channel, command):
        self.redis.lpush(channel, command)
        print(f"Команда '{command}' отправлена.")

    def receive_data(self,channel):
        while True:
            _, data = self.redis.blpop(channel)
            print(f"Получены данные: {data}")

