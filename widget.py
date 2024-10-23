import sys
import time
import json
import redis
from Controller_interface import SMCBaseMotorController
from smc100_new import SMCMotorHW
from main_window_ui import Ui_MainWindow
from PySide6.QtWidgets import QApplication, QMainWindow
from PySide6.QtCore import QThread, Signal, QProcess
from Status_poll import MotorPollingThread  # Импорт потока опроса

#для интерфейса введи в консоль pyside6-uic main_window.ui -o main_window_ui.py

# Глобальная переменная для хранения объекта Redis-клиента
controller_commands_redis = None
controller_commands_pubsub = None
controller_output_redis = None
controller_output_pubsub = None
controller_commands_channel = 'controller_commands'
controller_output_channel = 'controller_output'

# Шаблон команды
message = {'cmd': '', 'motor': '', 'arg1': 0, 'arg2': 0}

COMMANDS_WITHOUT_MOTOR = {"load", "save", "help"}

class ControllerListenerThread(QThread):
    # Передаём строку через сигнал
    message_received = Signal(str)  # Сигнал для передачи сообщений в основной поток

    def run(self):
        global controller_output_pubsub
        while True:
            time.sleep(1)  # Спим 1 секунду для ограничения частоты
            if controller_output_pubsub:
                # Получаем сообщение от pubsub
                message_ = controller_output_pubsub.parse_response()

                # Преобразуем байтовое сообщение в JSON-строку перед отправкой
                if isinstance(message_, list):
                    try:
                        # Преобразуем сообщение в строку JSON для передачи через сигнал
                        json_message = json.dumps([msg.decode('utf-8') if isinstance(msg, bytes) else msg for msg in message_])
                        self.message_received.emit(json_message)  # Отправляем как строку
                    except Exception as e:
                        print(f"Error serializing message: {e}")
                else:
                    self.message_received.emit(str(message_))


# Основное окно приложения
class MainWindow(QMainWindow, Ui_MainWindow):
    motors_updated = Signal(dict)

    def __init__(self):
        super().__init__()

        # Инициализация интерфейса через .ui файл
        self.setupUi(self)

        # Привязка кнопки к методу отправки команд
        self.button_send.clicked.connect(self.send_command)

        # Настройки окна
        self.setWindowTitle("Controller Commands")

        # Процесс для Redis сервера
        self.redis_process = QProcess(self)

        # Процесс для запуска другой программы (контроллера)
        self.controller_process = QProcess(self)

        # Запуск Redis при старте программы
        self.start_redis_server()

        # Запуск контроллера при старте программы
        self.start_controller()

        self.motors = {}

        # Устанавливаем команды в выпадающий список
        self.combo_command.addItems([
            "load", "save", "create", "add", "delete",
            "pos", "state", "start", "stop", "status", "calibrate"
        ])

        # Установить текстовые поля и компоненты
        self.text_output.append("Welcome to Motor Controller")
        self.combo_motor.addItems(self.motors.keys())  # Добавляем доступные моторы

        self.combo_command.currentIndexChanged.connect(self.on_command_changed)

        # Запуск потока опроса моторов
        self.motor_polling_thread = MotorPollingThread(self.motors)
        self.motors_updated.connect(self.motor_polling_thread.update_motors)
        self.motor_polling_thread.motor_status_received.connect(self.update_motor_status)
        self.motor_polling_thread.start()

    # Метод отправки команды в Redis
    # Метод отправки команды в Redis
    def send_command(self):
        global controller_commands_redis

        if not controller_commands_redis:
            self.text_output.append("Redis is not connected")
            return

        command = self.combo_command.currentText()
        motor = self.combo_motor.currentText()
        arg1 = self.line_arg1.text().strip()
        arg2 = self.line_arg2.text().strip()

        if command:
            if command == "create":
                self.add_motor(motor, arg1)
            elif command == "add":
                self.motors[motor][0].addDevice(arg1)
            elif command == "end":
                message['cmd'] = 'end'
                controller_commands_redis.publish(controller_commands_channel, json.dumps(message))
                self.close()
            else:
                if command and motor:
                    # Проверяем, что команда не пустая
                    if not command.strip():
                        self.text_output.append("Command cannot be empty")
                        return

                    # Заполняем сообщение
                    message['cmd'] = command
                    message['motor'] = motor
                    message['arg1'] = arg1 if arg1 else ''
                    message['arg2'] = arg2 if arg2 else ''

                    # Проверяем, что сообщение валидное (например, не пустое)
                    if not message['cmd']:
                        self.text_output.append("Command is missing.")
                        return

                    # Публикуем команду в Redis только если сообщение валидное
                    json_pub = json.dumps(message)
                    controller_commands_redis.publish(controller_commands_channel, json_pub)
                else:
                    self.text_output.append("Not enough arguments")

    # Метод для проверки, запущен ли Redis
    def is_redis_running(self, port=6379):
        try:
            # Пробуем подключиться к Redis
            test_redis = redis.StrictRedis(host='localhost', port=port, db=0)
            test_redis.ping()  # Отправляем команду PING
            return True  # Если PING сработал, сервер запущен
        except redis.exceptions.ConnectionError:
            return False  # Если подключение не удалось, сервер не запущен

    # Метод запуска Redis сервера
    def start_redis_server(self):
        # Проверяем, запущен ли Redis
        if self.is_redis_running():
            self.text_output.append("Redis server is already running, connecting...")
            self.connect_redis()  # Если сервер запущен, просто подключаемся
        else:
            self.text_output.append("Starting Redis server...")
            self.redis_process.start("C:/Redis-x64-5.0.14.1/redis-server.exe")
            self.redis_process.readyReadStandardOutput.connect(self.handle_redis_output)
            self.redis_process.readyReadStandardError.connect(self.handle_redis_error)
            self.redis_process.finished.connect(self.on_redis_stopped)

            # Подключаемся к Redis после его старта
            QThread.sleep(1)  # Ждём, пока сервер запустится
            self.connect_redis()

    def controller_finished(self, exitCode, exitStatus):
            if exitStatus == QProcess.NormalExit:
                self.text_output.append(f"Controller finished normally with exit code {exitCode}")
            else:
                self.text_output.append(f"Controller crashed with exit code {exitCode}")

            # Если требуется перезапуск:
            self.restart_controller()

    # Метод запуска контроллера
    def start_controller(self):
        self.controller_process.start("python", ["Controller_interface.py"])
        self.controller_process.readyReadStandardOutput.connect(self.handle_controller_output)
        self.controller_process.readyReadStandardError.connect(self.handle_controller_error)

        self.controller_process.finished.connect(self.controller_finished)
        self.text_output.append("Controller interface is started!")

    # Перезапуск контроллера
    def restart_controller(self):
        self.text_output.append("Restarting Controller interface...")
        self.start_controller()



    # Метод подключения к Redis
    def connect_redis(self):
        global controller_commands_redis, controller_commands_pubsub, controller_output_redis, controller_output_pubsub

        try:
            controller_commands_redis = redis.StrictRedis(host='localhost', port=6379, db=0)
            controller_commands_pubsub = controller_commands_redis.pubsub()
            controller_commands_pubsub.subscribe(controller_commands_channel)

            controller_output_redis = redis.StrictRedis(host='localhost', port=6379, db=0)
            controller_output_pubsub = controller_output_redis.pubsub()
            controller_output_pubsub.subscribe(controller_output_channel)

            self.text_output.append("Connected to Redis!")
            self.button_send.setEnabled(True)  # Активируем кнопку для отправки команд

            # Запуск потока для получения данных от контроллера
            self.listener_thread = ControllerListenerThread()
            self.listener_thread.message_received.connect(self.update_output)
            self.listener_thread.start()
        except redis.exceptions.ConnectionError:
            self.text_output.append("Failed to connect to Redis. Is the server running?")

    # Метод для обработки вывода Redis сервера
    def handle_redis_output(self):
        try:
            output = controller_output_pubsub.parse_response()
            if output[0].decode('utf-8') == 'message':
                self.text_output.append(f"Redis Output: {output}")
        except UnicodeDecodeError as e:
            self.text_output.append(f"Decoding error in Redis Output: {e}")

    # Метод для обработки ошибок Redis сервера
    def handle_redis_error(self):
        try:
            error = self.redis_process.readAllStandardError().data().decode('latin-1')  # Используем более устойчивую кодировку
            self.text_output.append(f"Redis Error: {error}")
        except UnicodeDecodeError as e:
            self.text_output.append(f"Decoding error in Redis Error: {e}")

    # Метод для обработки завершения процесса Redis
    def on_redis_stopped(self):
        self.text_output.append("Redis server stopped...")

    # Метод отключения Redis сервера (всегда)
    def shutdown_redis_server(self):
        try:
            # Попытка подключиться к серверу и отправить команду на завершение работы
            test_redis = redis.StrictRedis(host='localhost', port=6379, db=0)
            test_redis.shutdown()  # Команда SHUTDOWN для остановки сервера
            self.text_output.append("Redis server has been shut down.")
        except redis.exceptions.ConnectionError:
            self.text_output.append("Redis server is not running, no need to shut down.")

    # Обработчик обновления статуса моторов
    def update_motor_status(self, motor_data):
        motor_name = motor_data["motor"]
        status = motor_data["status"]

        # Обновляем статус выбранного мотора
        selected_motor = self.combo_motor.currentText()

        if motor_name == selected_motor:
            self.text_motor_status.clear()  # Очищаем перед обновлением
            self.text_motor_status.append(f"Motor: {motor_name}")
            self.text_motor_status.append(f"Position: {status['position']}")
            self.text_motor_status.append(f"State: {status['state']}")
            self.text_output.append(f"Received status for {motor_name}")

    # Отключение/включение выбора мотора в зависимости от команды
    def on_command_changed(self):
        selected_command = self.combo_command.currentText()
        if selected_command in COMMANDS_WITHOUT_MOTOR:
            self.combo_motor.setEnabled(False)  # Отключаем выбор мотора
        else:
            self.combo_motor.setEnabled(True)  # Включаем выбор мотора


    # Метод остановки Redis сервера при закрытии программы
    def closeEvent(self, event):
        self.motor_polling_thread.stop()

        message['cmd'] = 'end'
        controller_commands_redis.publish(controller_commands_channel, json.dumps(message))

        # Всегда пытаемся отключить сервер Redis
        self.shutdown_redis_server()

        # Если Redis был запущен программой, проверим процесс и завершим его
        if self.redis_process.state() == QProcess.Running:
            self.redis_process.terminate()
            self.text_output.append("Stopping Redis server...")

        if self.controller_process.state() == QProcess.Running:
            self.controller_process.terminate()  # Попробовать завершить нормально
            self.text_output.append("Stopping controller...")
            if not self.controller_process.waitForFinished(3000):  # Подождать 3 секунды
                self.controller_process.kill()  # Принудительно завершить, если не завершился
            self.text_output.append("Controller process terminated.")

        event.accept()  # Завершаем программу

    # Метод для обработки вывода контроллера
    def handle_controller_output(self):
        output = self.controller_process.readAllStandardOutput().data()
        self.text_output.append(f"Controller handle Output: {output}")

    # Метод для обработки ошибок контроллера
    def handle_controller_error(self):
        error = self.controller_process.readAllStandardError().data()
        self.text_output.append(f"Controller Error: {error}")

    def update_output(self, json_message):
        try:
            # Десериализуем строку JSON обратно в список
            message = json.loads(json_message)

            # Проверяем, является ли сообщение списком и содержит ли оно хотя бы 3 элемента
            if isinstance(message, list) and len(message) >= 3:
                # Проверяем, что это сообщение типа 'message'
                if message[0] == 'message':  # Здесь уже строка, т.к. было декодирование
                    # Выводим третий элемент
                    self.text_output.append(f"Controller Redis Output: {message[2]}")
                else:
                    self.text_output.append(f"Unexpected message format: {message}")
            else:
                # Если сообщение не соответствует ожидаемой структуре
                self.text_output.append(f"Invalid message structure: {message}")
        except json.JSONDecodeError as e:
            self.text_output.append(f"Error decoding JSON: {e}")
        except Exception as e:
            self.text_output.append(f"Error processing message: {e}")


    # Метод для добавления нового мотора
    def add_motor(self, motor_name, Port):
        # Добавляем новый мотор в список
        axes = {}
        smc100 = SMCBaseMotorController(Port, motor_name)
        self.motors[motor_name] = smc100,axes
        self.combo_motor.addItem(motor_name)  # Обновляем список в интерфейсе

        # Отправляем сигнал в поток об обновлении списка моторов
        self.motors_updated.emit(self.motors)
        self.text_output.append(f"Added motor: {motor_name}")




if __name__ == "__main__":
    app = QApplication(sys.argv)
    window = MainWindow()
    window.show()
    sys.exit(app.exec())
