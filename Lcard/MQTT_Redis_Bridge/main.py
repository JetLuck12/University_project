import threading
import time
import paho.mqtt.client as mqtt
import redis

# Настройки MQTT
MQTT_BROKER = "127.0.0.1"
MQTT_COMMAND_TOPIC = "lcard/command"
MQTT_DATA_TOPIC = "lcard/data"

# Настройки Redis
REDIS_IP = "127.0.0.1"
REDIS_PORT = 6379
COMMAND_CHANNEL = "command_channel"
DATA_CHANNEL = "data_channel"

# Создание клиентов Redis и MQTT
redis_client = redis.StrictRedis(host=REDIS_IP, port=REDIS_PORT, decode_responses=True)
mqtt_client = mqtt.Client()

def on_connect(client, userdata, flags, rc):
    """Обработка подключения к MQTT."""
    print(f"Connected to MQTT Broker with code {rc}")
    client.subscribe(MQTT_COMMAND_TOPIC)
    client.subscribe(MQTT_DATA_TOPIC)

def on_message(client, userdata, msg):
    """Обработка входящих MQTT сообщений."""
    topic = msg.topic
    payload = msg.payload.decode()
    print(f"Получено сообщение из MQTT: Топик={topic}, Данные={payload}")

    if topic == MQTT_COMMAND_TOPIC:
        # Пересылка команды в Redis
        redis_client.lpush(COMMAND_CHANNEL, payload)
        print(f"Команда '{payload}' переслана в Redis.")
    elif topic == MQTT_DATA_TOPIC:
        # Пересылка данных в Redis
        redis_client.lpush(DATA_CHANNEL, payload)
        print(f"Данные '{payload}' пересланы в Redis.")

def forward_between_mqtt_and_redis():
    """Перенаправление данных между Redis и MQTT."""
    while True:
        try:
            # Проверяем Redis на наличие команд
            if redis_client.llen(COMMAND_CHANNEL) > 0:
                _, command = redis_client.blpop(COMMAND_CHANNEL, timeout=1)
                mqtt_client.publish(MQTT_COMMAND_TOPIC, command)
                print(f"Команда '{command}' переслана в MQTT.")

            # Проверяем Redis на наличие данных
            if redis_client.llen(DATA_CHANNEL) > 0:
                _, data = redis_client.blpop(DATA_CHANNEL, timeout=1)
                mqtt_client.publish(MQTT_DATA_TOPIC, data)
                print(f"Данные '{data}' пересланы в MQTT.")

            # Добавляем задержку для избежания частого опроса
            time.sleep(0.1)

        except Exception as e:
            print(f"Ошибка при пересылке данных: {e}")

# Настройка MQTT клиента
mqtt_client.on_connect = on_connect
mqtt_client.on_message = on_message

# Подключение к MQTT
mqtt_client.connect(MQTT_BROKER)

# Запуск цикла обработки MQTT в отдельном потоке
mqtt_thread = threading.Thread(target=mqtt_client.loop_forever)
mqtt_thread.start()

# Перенаправление данных между Redis и MQTT
try:
    forward_between_mqtt_and_redis()
except KeyboardInterrupt:
    print("Программа завершена.")
    mqtt_client.loop_stop()
    mqtt_client.disconnect()
    mqtt_thread.join()
