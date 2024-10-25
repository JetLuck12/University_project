import sys
from Controller_interface import SMCBaseMotorController
from main_window_ui import Ui_MainWindow
from PySide6.QtWidgets import QApplication, QMainWindow
from PySide6.QtCore import Signal
from Status_poll import MotorPollingThread  # Импорт потока опроса

#для интерфейса введи в консоль pyside6-uic main_window.ui -o main_window_ui.py

# Шаблон команды
message = {'cmd': '', 'motor': '', 'arg1': 0, 'arg2': 0}

COMMANDS_WITHOUT_MOTOR = {"load", "save", "help"}

# Основное окно приложения
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

    def execute_command(self):
        command = self.combo_command.currentText()
        motor = self.combo_motor.currentText()
        arg1 = self.line_arg1.text().strip()
        arg2 = self.line_arg2.text().strip()

        if command:
            if command == "create":
                self.add_motor(arg1, arg2)
            elif command == "end":
                message['cmd'] = 'end'
                self.close()
            else:
                if command and motor:
                    # Проверяем, что команда не пустая
                    if not command.strip():
                        self.text_output.append("Command cannot be empty")
                        return
                    response = self.motors[motor][0].execute_command(command, arg1, arg2)
                    self.text_output.append(f"response:{response}")
                else:
                    self.text_output.append("Not enough arguments")

    # Обработчик обновления статуса моторов
    def update_motor_status(self, motor_data):
        motor_name = motor_data["motor"]
        status = motor_data["status"]

        # Обновляем статус выбранного мотора
        selected_motor = self.combo_motor.currentText()

        if motor_name == selected_motor:
            self.motor_state.clear()
            self.motor_pos.clear()
            self.motor_pos.append(f"Position: {status['position']}")
            self.motor_state.append(f"State: {status['state']}")

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
        event.accept()  # Завершаем программу

    # Метод для добавления нового мотора
    def add_motor(self, motor_name, Port = "COM10"):
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
