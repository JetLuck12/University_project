import sys
from Redis_Wrapper.Redis_Wrapper import Redis_Wrapper_class
from SMC_Wrapper.Controller_interface import SMCBaseMotorController
from main_window_ui import Ui_MainWindow
from PySide6.QtWidgets import QApplication, QMainWindow
from PySide6.QtCore import Signal
from SMC_Wrapper.Status_poll import MotorPollingThread  # Импорт потока опроса
import paho.mqtt.client as mqtt
import json

# для интерфейса введи в консоль pyside6-uic main_window.ui -o main_window_ui.py

# Шаблон команды
message = {'cmd': '', 'motor': '', 'arg1': 0, 'arg2': 0}

photodiod_id = 11

COMMANDS_WITHOUT_MOTOR = {"load", "save", "help"}
COMMANDS_AND_ARGS = {
                "load": [None, "Name", None],
                "save": [None, "Name", None],
                "create": [None, "Name", "Port"],
                "add": ["Motor name", "Axis name", None],
                "delete": ["Motor name", "Axis name", None],
                "pos": ["Motor name", "Axis name", None],
                "state": ["Motor name", "Axis name", None],
                "start":  ["Motor name", "Axis name", "Position"],
                "stop": ["Motor name", "Axis name", None],
                "status": ["Motor name", "Axis name", None],
                "connect to Redis": [None,None,None]
                }

REDIS_IP = '127.0.0.1'
REDIS_PORT = 6379
REDIS_COMMAND_CHANNEL = 'command_channel'
REDIS_DATA_CHANNEL = 'data_channel'

# Настройки MQTT
MQTT_BROKER = "127.0.0.1"
MQTT_REDIS_COMMAND_TOPIC = "lcard/command"
MQTT_REDIS_DATA_TOPIC = "lcard/data"
PHOTODIOD_COMMANDS = {"start photodiod measurement", "stop photodiod measurement", "calibrate"}

class MainWindow(QMainWindow, Ui_MainWindow):
    motors_updated = Signal(dict)

    def __init__(self):
        super().__init__()

        # Инициализация интерфейса через .ui файл
        self.setupUi(self)

        # Привязка кнопки к методу отправки команд
        self.button_send.clicked.connect(self.execute_command)

        # Настройки окна
        self.setWindowTitle("Controller Commands")

        self.motors = {}

        # Устанавливаем команды в выпадающий список
        self.combo_command.addItems(COMMANDS_AND_ARGS.keys())

        # Установить текстовые поля и компоненты
        self.text_output.append("Welcome to Motor Controller")
        print(self.motors.keys())
        self.combo_motor.addItems(self.motors.keys())  # Добавляем доступные моторы

        self.combo_command.currentIndexChanged.connect(self.on_command_changed)
        self.button_send.clicked.connect(self.on_motor_changed)

        # Запуск потока опроса моторов
        self.motor_polling_thread = MotorPollingThread(self.motors)
        self.motors_updated.connect(self.motor_polling_thread.update_motors)
        self.motor_polling_thread.motor_status_received.connect(self.update_motor_status)
        self.motor_polling_thread.start()

        self.redis = Redis_Wrapper_class(REDIS_IP, REDIS_PORT)

        self.calibration_flag = False
        self.calibration_array = []

    def execute_command(self):
        command = self.combo_command.currentText()
        motor = self.combo_motor.currentText()
        arg1 = self.line_arg1.text().strip()
        arg2 = self.line_arg2.text().strip()

        if command in PHOTODIOD_COMMANDS:
            # Формируем команду для отправки через MQTT
            payload = {
                "cmd": command,
                "motor": motor,
                "arg1": arg1,
                "arg2": arg2
            }
            self.mqtt_client.publish(MQTT_REDIS_COMMAND_TOPIC, json.dumps(payload))
            self.text_output.append(f"Команда '{command}' отправлена через MQTT.")
        else:
            if command == "create":
                self.add_motor(arg1, arg2)
            elif command == "end":
                message['cmd'] = 'end'
                self.close()
            elif command == "connect to Redis":
                self.init_redis_mqtt()
            else:
                if command and motor:
                    if not command.strip():
                        self.text_output.append("Command cannot be empty")
                        return
                    response = self.motors[motor].execute_command(command, arg1, arg2)
                    self.text_output.append(f"response:{response}")
                else:
                    self.text_output.append("Not enough arguments")

    def on_connect(self, client, userdata, flags, rc):
        """Обработка подключения к MQTT."""
        print(f"Подключено к MQTT брокеру с кодом {rc}")
        client.subscribe(MQTT_REDIS_DATA_TOPIC)

    def on_message(self, client, userdata, msg):
        """Обработка входящих данных от перемычки."""
        data = msg.payload.decode()
        print(f"Получены данные: {data}")
        self.text_output.append(f"Received data: {data}")

    # Обработчик обновления статуса моторов
    def update_motor_status(self, motor_data):
        motor_name = motor_data["motor"]
        status = motor_data["status"]
        axis = status['axis']
        # Обновляем статус выбранного мотора
        selected_motor = self.combo_motor.currentText()
        selected_axis = self.combo_axis.currentText()

        if str(motor_name) == str(selected_motor) and str(axis) == str(selected_axis):
            self.motor_state.clear()
            self.motor_pos.display(status['position'])
            self.motor_state.append(status['state'])

    # Обработчик обновления статуса моторов
    def update_photo_status(self, diod_data):
        self.photodiod_pos.clear()
        self.photodiod_pos.display(diod_data['position'])
        self.photodiod_data.clear()
        self.photodiod_data.display(diod_data['intensity'])

    # Отключение/включение выбора мотора в зависимости от команды
    def on_command_changed(self):
        selected_command = self.combo_command.currentText()
        motor = COMMANDS_AND_ARGS[selected_command][0]
        arg1 = COMMANDS_AND_ARGS[selected_command][1]
        arg2 = COMMANDS_AND_ARGS[selected_command][2]
        if  motor == None:
            self.combo_motor.setEnabled(False)
        else:
            self.combo_motor.setEnabled(True)

        self.label_arg1.setText(arg1)

        if  arg2 == None:
            self.line_arg2.setEnabled(False)
        else:
            self.label_arg2.setText(arg2)
            self.line_arg2.setEnabled(True)

    def on_motor_changed(self):
        if self.combo_motor.currentText() != '':
            selected_motor = self.motors[self.combo_motor.currentText()]
            self.combo_axis.clear()
            for axis in selected_motor._motors.keys():
                self.combo_axis.addItem(str(axis))

    # Метод остановки Redis сервера при закрытии программы
    def closeEvent(self, event):
        self.motor_polling_thread.stop()
        event.accept()  # Завершаем программу

    # Метод для добавления нового мотора
    def add_motor(self, motor_name, Port):
        # Добавляем новый мотор в список
        if(Port == ""):
            Port = "COM10"
        smc100 = SMCBaseMotorController(Port, motor_name)
        self.motors[motor_name] = smc100
        self.combo_motor.addItem(motor_name)  # Обновляем список в интерфейсе

        # Отправляем сигнал в поток об обновлении списка моторов
        self.motors_updated.emit(self.motors)
        self.text_output.append(f"Added motor: {motor_name}")

    def calibrate(self, sizeX, sizeY):
        self.calibration_flag = True
        self.calibration_array = []
        motor = self.combo_motor.currentText()
        lower_limit = self.motors[motor].GetAxisExtraPar(photodiod_id, 'lower_limit')
        upper_limit = self.motors[motor].GetAxisExtraPar(photodiod_id, 'upper_limit')
        self.motors[motor].execute_command('start', photodiod_id, lower_limit)
        while(self.motors[motor].execute_command('pos', photodiod_id) != lower_limit):
            pass
        self.redis.send_command("start")
        self.motors[motor].execute_command('start', photodiod_id, upper_limit)
        while(self.motors[motor].execute_command('pos', photodiod_id) != upper_limit):
            pass
        self.redis.send_command("stop")
        max_pos = 0
        max_int = 0
        for item in self.calibration_array:
            if item['intensity'] > max_int:
                max_int = item['intensity']
                max_pos = item['position']
        print(f"Find the best position {max_pos} and intansity {max_int}")


    def init_redis_mqtt(self):
        def on_connect(client, userdata, flags, rc):
            """Обработка подключения к MQTT."""
            print(f"Подключено к MQTT брокеру с кодом {rc}")
            client.subscribe(MQTT_REDIS_DATA_TOPIC)

        def on_message(client, userdata, msg):
            """Обработка входящих данных от перемычки."""
            data = msg.payload.decode()
            print(f"Получены данные: {data}")
            self.update_photo_status(data)
            if (self.calibration_flag):
                self.calibration_array.append(data)
        self.mqtt_client = mqtt.Client()

        self.mqtt_client.on_connect = on_connect
        self.mqtt_client.on_message = on_message

        self.mqtt_client.connect(MQTT_BROKER)

        self.mqtt_client.loop_start()



if __name__ == "__main__":
    app = QApplication(sys.argv)
    window = MainWindow()
    window.show()
    sys.exit(app.exec())
