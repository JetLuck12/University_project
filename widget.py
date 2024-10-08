import sys
import time
import json
import redis
from main_window_ui import Ui_MainWindow
from PySide6.QtWidgets import QApplication, QMainWindow, QVBoxLayout, QPushButton, QLineEdit, QTextEdit, QWidget, QLabel
from PySide6.QtCore import QThread, Signal, QProcess

# Глобальная переменная для хранения объекта Redis-клиента
controller_commands_redis = None
controller_commands_pubsub = None
controller_output_redis = None
controller_output_pubsub = None
controller_commands_channel = 'controller_commands'
controller_output_channel = 'controller_output'

# Шаблон команды
message = {'cmd': '', 'motor': '', 'arg1': 0, 'arg2': 0}

# Поток для подписки и получения данных от контроллера
class ControllerListenerThread(QThread):
    message_received = Signal(str)  # Сигнал для передачи сообщений в основной поток

    def run(self):
        global controller_output_pubsub
        while True:
            time.sleep(1)
            if controller_output_pubsub:
                message_ = controller_output_pubsub.parse_response()
                if message_:
                    if message_[0].decode('utf-8') == 'subscribe':
                        continue
                    else:
                        self.message_received.emit(str(message_))  # Отправляем сообщение в основной поток

# Основное окно приложения
class MainWindow(QMainWindow, Ui_MainWindow):
    def __init__(self):
        super().__init__()


        self.setupUi(self)
        # Привязка кнопки к методу
        self.button_send.clicked.connect(self.send_command)

        # Настройки окна
        self.setWindowTitle("Controller Commands")
        self.setGeometry(200, 200, 800, 800)

        # Основной виджет
        central_widget = QWidget(self)
        self.setCentralWidget(central_widget)

        # Поле для вывода сообщений
        self.output_text = QTextEdit(self)
        self.output_text.setReadOnly(True)

        # Поля для ввода команд
        self.command_input = QLineEdit(self)
        self.command_input.setPlaceholderText("Enter command")

        self.motor_input = QLineEdit(self)
        self.motor_input.setPlaceholderText("Enter motor")

        self.arg1_input = QLineEdit(self)
        self.arg1_input.setPlaceholderText("Enter arg1 (optional)")

        self.arg2_input = QLineEdit(self)
        self.arg2_input.setPlaceholderText("Enter arg2 (optional)")

        # Кнопка для отправки команд
        self.send_button = QPushButton("Send Command", self)
        self.send_button.clicked.connect(self.send_command)
        self.send_button.setEnabled(False)  # Отключаем кнопку до подключения к Redis

        # Компоновка элементов
        layout = QVBoxLayout()
        layout.addWidget(QLabel("Command Input:"))
        layout.addWidget(self.command_input)
        layout.addWidget(self.motor_input)
        layout.addWidget(self.arg1_input)
        layout.addWidget(self.arg2_input)
        layout.addWidget(self.send_button)
        layout.addWidget(QLabel("Controller Output:"))
        layout.addWidget(self.output_text)

        central_widget.setLayout(layout)

        # Процесс для Redis сервера
        self.redis_process = QProcess(self)

        # Запуск Redis при старте программы
        self.start_redis_server()

        self.controller_process = QProcess(self)

        self.start_controller()

    # Метод отправки команды в Redis
    def send_command(self):
        global controller_commands_redis

        if not controller_commands_redis:
            self.output_text.append("Redis is not connected")
            return

        command = self.command_input.text().strip().lower()
        motor = self.motor_input.text().strip()
        arg1 = self.arg1_input.text().strip()
        arg2 = self.arg2_input.text().strip()

        if command == "help":
            help_text = (
                "List of commands and args:\n"
                "Load             [\"filename\"]\n"
                "Save             [\"filename\"]\n"
                "Create           [\"family\\domain\\name\"]\n"
                "Add              [motor, axis]\n"
                "Delete           [motor, axis]\n"
                "Pos              [motor, axis]\n"
                "State            [motor, axis]\n"
                "Start            [motor, axis]\n"
                "Stop             [motor, axis]\n"
                "Status           [motor, axis]\n"
                "Calibrate        [diode_motor, size]\n"
                "End\n"
            )
            self.output_text.append(help_text)
        elif command == "end":
            self.close()
        else:
            if command and motor:
                message['cmd'] = command
                message['motor'] = motor
                message['arg1'] = arg1 if arg1 else ''
                message['arg2'] = arg2 if arg2 else ''

                # Публикуем команду в Redis
                json_pub = json.dumps(message)
                controller_commands_redis.publish(controller_commands_channel, json_pub)
            else:
                self.output_text.append("Not enough arguments")

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
            self.output_text.append("Redis server is already running, connecting...")
            self.connect_redis()  # Если сервер запущен, просто подключаемся
        else:
            self.output_text.append("Starting Redis server...")
            self.redis_process.start("C:/Redis-x64-5.0.14.1/redis-server.exe")
            self.redis_process.readyReadStandardOutput.connect(self.handle_redis_output)
            self.redis_process.readyReadStandardError.connect(self.handle_redis_error)
            self.redis_process.finished.connect(self.on_redis_stopped)

            # Подключаемся к Redis после его старта
            QThread.sleep(1)  # Ждём, пока сервер запустится
            self.connect_redis()

        # Метод запуска другой программы
    def start_controller(self):
        self.controller_process.start("python", ["Controller_interface.py"])
        self.controller_process.readyReadStandardOutput.connect(self.handle_controller_output)
        self.controller_process.readyReadStandardError.connect(self.handle_controller_error)

        self.output_text.append("Constroller interface is started!")

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

            self.output_text.append("Connected to Redis!")
            self.send_button.setEnabled(True)  # Активируем кнопку для отправки команд

            # Запуск потока для получения данных от контроллера
            self.listener_thread = ControllerListenerThread()
            self.listener_thread.message_received.connect(self.update_output)
            self.listener_thread.start()
        except redis.exceptions.ConnectionError:
            self.output_text.append("Failed to connect to Redis. Is the server running?")

    # Метод для обработки вывода Redis сервера
    def handle_redis_output(self):
        try:
            output = self.redis_process.readAllStandardOutput().data().decode('latin-1')  # Используем более устойчивую кодировку
            self.output_text.append(f"Redis Output: {output}")
        except UnicodeDecodeError as e:
            self.output_text.append(f"Decoding error in Redis Output: {e}")

    # Метод для обработки ошибок Redis сервера
    def handle_redis_error(self):
        try:
            error = self.redis_process.readAllStandardError().data().decode('latin-1')  # Используем более устойчивую кодировку
            self.output_text.append(f"Redis Error: {error}")
        except UnicodeDecodeError as e:
            self.output_text.append(f"Decoding error in Redis Error: {e}")

    # Метод для обработки завершения процесса Redis
    def on_redis_stopped(self):
        self.output_text.append("Redis server stopped...")

    # Метод отключения Redis сервера (всегда)
    def shutdown_redis_server(self):
        try:
            # Попытка подключиться к серверу и отправить команду на завершение работы
            test_redis = redis.StrictRedis(host='localhost', port=6379, db=0)
            test_redis.shutdown()  # Команда SHUTDOWN для остановки сервера
            self.output_text.append("Redis server has been shut down.")
        except redis.exceptions.ConnectionError:
            self.output_text.append("Redis server is not running, no need to shut down.")

    # Метод остановки Redis сервера при закрытии программы
    def closeEvent(self, event):
        # Всегда пытаемся отключить сервер Redis
        self.shutdown_redis_server()

        # Если Redis был запущен программой, проверим процесс и завершим его
        if self.redis_process.state() == QProcess.Running:
            self.redis_process.terminate()
            self.output_text.append("Stopping Redis server...")

        event.accept()  # Завершаем программу

    # Метод остановки Redis сервера
    def stop_redis_server(self):
        if self.redis_process.state() == QProcess.Running:
            self.redis_process.terminate()
            self.output_text.append("Stopping Redis server...")

    # Метод остановки Redis сервера
    def stop_controller(self):
        if self.controller_process.state() == QProcess.Running:
            self.controller_process.terminate()
            self.output_text.append("Stopping controller...")

    # Метод для обработки вывода контроллера
    def handle_controller_output(self):
        output = self.controller_process.readAllStandardOutput().data().decode()
        self.output_text.append(f"Controller Output: {output}")

    # Метод для обработки ошибок контроллера
    def handle_controller_error(self):
        error = self.controller_process.readAllStandardError().data().decode()
        self.output_text.append(f"Controller Error: {error}")

    # Обновление текстового поля при получении сообщения от контроллера
    def update_output(self, message):
        if message[0].encode('utf-8') == 'message':
            # Если сообщение начинается с 'message', выводим третье сообщение
            decoded_message = message[2].encode('utf-8')
            self.output_text.append(f"{decoded_message}")
        else:
            # Если формат сообщения отличается, выводим его целиком
            self.output_text.append(f"Controller: {message}")

if __name__ == "__main__":
    app = QApplication(sys.argv)
    window = MainWindow()
    window.show()
    sys.exit(app.exec())
