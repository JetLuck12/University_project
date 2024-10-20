import time
import json
from PySide6.QtCore import QThread, Signal

# Поток для опроса моторов
class MotorPollingThread(QThread):
    motor_status_received = Signal(dict)  # Сигнал для передачи статуса моторов в основной поток

    def __init__(self):
        super().__init__()

        # Список моторов для опроса
        self.motors = {
            'motor_1': {"axis": 1},
            'motor_2': {"axis": 2},
            'motor_3': {"axis": 3},
        }
        self.polling_active = True  # Флаг для завершения потока

    # Пример функции, которая симулирует опрос мотора
    def get_motor_status(self, motor_name, axis):
        # Здесь можно использовать реальный метод для получения статуса мотора (например, от SMCMotorHW)
        status = {
            "position": 100,  # Положение мотора
            "state": "moving",  # Состояние: 'moving', 'stopped'
            "axis": axis
        }
        return status

    # Основной метод потока для опроса моторов
    def run(self):
        while self.polling_active:
            # Опрос всех моторов
            for motor_name, motor_info in self.motors.items():
                axis = motor_info["axis"]
                status = self.get_motor_status(motor_name, axis)

                # Передача статуса через сигнал
                self.motor_status_received.emit({
                    "motor": motor_name,
                    "status": status
                })


            # Задержка перед следующим опросом (например, 1 секунда)
            time.sleep(1)

    # Метод для остановки потока
    def stop(self):
        self.polling_active = False
        self.quit()
        self.wait()

