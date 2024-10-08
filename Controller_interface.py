from smc100_new import SMCMotorHW
import redis, json
import os
import time
import struct
import pickle

DefaultPort = "COM10"
Y_motors = (2,5,7)
X_motors = (1,3,6)

# Redis connect

redis_host = 'localhost'
redis_port = 6379
controller_commands_channel = 'controller_commands'
controller_output_channel = 'controller_output'

controller_commands_redis = redis.StrictRedis(host=redis_host, port=6379)
controller_commands_pubsub = controller_commands_redis.pubsub()
controller_commands_pubsub.subscribe(controller_commands_channel)

controller_output_redis = redis.StrictRedis(host=redis_host, port=6379)
controller_output_pubsub = controller_output_redis.pubsub()
controller_output_pubsub.subscribe(controller_output_channel)

motors = {}

DataPipe = r'\\.\pipe\DataPipe'
MotorPipe = r'\\.\pipe\MotorPipe'

class SMCBaseMotorController():
    def __init__(self, Port, name):
        """Constructor"""
        self.Port = Port
        self.smc100 = SMCMotorHW(self.Port)
        print('Init: SUCCESS')
        self.name = name
        # do some initialization
        self.attributes = {}
        self._motors = {}
        self._isMoving = None
        self._moveStartTime = None
        self.error = None
        
#        self._threshold = 0.05
#        self._target = None
        self._timeout = 10

       

    def execute_command(self, cmd, arg1, arg2):
        """execute command and return value"""
        #get command and args 
        command_name = cmd.lower()

        # Logic of executing commands
        if command_name == 'add':
            axis = int(arg1)
            self.AddDevice(arg1)
            return "New device added"
        elif command_name == 'delete':
            axis = int(arg1)
            self.DeleteDevice(axis)
            return "Device deleted"
        elif command_name == 'pos':
            axis = int(arg1)
            position = self.ReadOne(axis)
            return f"Position of {axis} is {position}"
        elif command_name == 'state':
            axis = int(arg1)
            state = self.StateOne(axis)
            return f"State of {axis} is: {state}"
        elif command_name == 'start':
            axis,position = int(arg1), int(arg2)
            self.StartOne(axis, position)
            return f"Motor of axis {axis} going to {position}"
        elif command_name == 'stop':
            axis = int(arg1)
            self.StopOne(axis)
            return f"{axis} stopped"
        elif command_name == 'status':
            axis = int(arg1)
            self.status(axis)
            return "Status published"
        else:
            return f"Unknown command: {cmd}"

    def AddDevice(self, axis):
        self.attributes[axis] = {}
#        self.attributes[position_value] = None
        self.attributes[axis]['step_per_unit'] = 0
        self.attributes[axis]['step_per_unit_set'] = False
        self.attributes[axis]['lower_limit'] = 2
        self.attributes[axis]['upper_limit'] = 20
        self.attributes[axis]['offset'] = 0
        self.attributes[axis]['revision'] = self.smc100.getRevision(axis)
        
        #print(self.attributes[axis]['revision'])
        #print(self.smc100.getRevision(axis))
        self._motors[axis] = True

    def DeleteDevice(self, axis):
        self.attributes.pop(axis)
        del self._motors[axis]

    def ReadOne(self, axis):
        """Get the specified motor position"""
        return self.smc100.getPosition(axis)

    def StateOne(self, axis):
        """Get the specified motor state"""
        state = self.smc100.getState(axis)
        if state == 1:
            return "Motor in target position"
        elif state == 2:
            return "Motor is moving"
        elif state == 3:
            return "Unknown state"

    def StartOne(self, axis, position):
        """Move the specified motor to the specified position"""
        low = self.attributes[axis]['lower_limit']
        upp = self.attributes[axis]['upper_limit']
#        offset = self.attributes[axis]['offset']

#        new_position = position
#        if(offset>=0):
#            new_position = position + offset
#        print(position)
#        print(new_position)
#        print(offset)
        if(position < low or position > upp):
            raise ValueError('Invalid position: exceed lower or upper limit')
        self.smc100.move(axis, position, waitStop=False) #we dont want to wait until reach position...

    def StopOne(self, axis):
        """Stop the specified motor"""
        self.smc100.stop(axis)
    
    def status(self, axis):
        status = {
            'model' : 'SMC100',
            'error' : self.error,
            'move_status' : self.StateOne(axis),
            'coord' : self.ReadOne(axis),
            'velocity' : self.smc100.GetAxisPar(axis, 'velocity'),
            'acceleration' : self.smc100.GetAxisPar(axis, 'acceleration')
            }
        json_string = json.dumps(status)
        return json_string
    

    def SetAxisPar(self, axis, name, value):
        """ Set the standard pool motor parameters.
        @param axis to set the parameter
        @param name of the parameter
        @param value to be set
        """
        par_name = name.lower()
        spu = float(value)

        if par_name == 'step_per_unit':
            self.attributes[axis]['step_per_unit_set'] = True
            self.attributes[axis]['step_per_unit'] = spu
        elif name == 'acceleration':
            self.smc100.setAcceleration(axis, spu)
        elif name == 'velocity':
            self.smc100.setVelocity(axis, spu)
        elif name == 'offset':
            self.attributes[axis]['offset'] = spu

#        elif name == 'lower_limit':
#            self.attributes[axis]['lower_limit'] = float(value)
#        elif name == 'upper_limit':
#            self.attributes[axis]['upper_limit'] = float(value)


    def GetAxisPar(self, axis, name):
        """ Get the standard pool motor parameters.
        @param axis to get the parameter
        @param name of the parameter to get the value
        @return the value of the parameter
        """
        par_name = name.lower()
        if par_name == 'step_per_unit':
            value = self.attributes[axis]['step_per_unit']
        elif name == 'acceleration':
            value = self.smc100.getAcceleration(axis)
        elif name == 'velocity':
            value = self.smc100.getVelocity(axis)
        elif name == 'offset':
            value = self.attributes[axis]['offset']
        return value

    def GetAxisExtraPar(self, axis, name):
        par_name = name.lower()
        if par_name == 'lower_limit':
            value = self.attributes[axis]['lower_limit']
        elif par_name == 'upper_limit':
            value = self.attributes[axis]['upper_limit']
        elif par_name == 'revision':
            value = self.attributes[axis]['revision']
#            value = self.smc100.getRevision(axis)
        return value



    def SetAxisExtraPar(self, axis, name, value):
        par_name = name.lower()
        if par_name == 'lower_limit':
            self.attributes[axis]['lower_limit'] = float(value)
        elif par_name == 'upper_limit':
            self.attributes[axis]['upper_limit'] = float(value)
        elif par_name == 'revision':
            pass
        
def calibration(self, size_x, size_y):
    #X
    photo_diod_x = 11
    self.StartOne(photo_diod_x, 2);
    while(motor.smc100.getPosition(photo_diod_x) != 0):
        motor_pipe(-3)
        time.sleep(0.1)
    self.StartOne(photo_diod_x, 250);
    motor_pipe(-1)
    while(self.smc100.getPosition(photo_diod_x) < 19):
        if(photo_pipe(DataPipe) == -1):
            pos = self.smc100.getPosition(photo_diod_x)
            if(pos is None):
                motor_pipe(-2)
            else:
                motor_pipe(pos)
    xPos = photo_pipe(DataPipe)
    self.StartOne(photo_diod_x, xPos)
    #Y
    photo_diod_y = 10
    self.StartOne(photo_diod_y, 2);
    while(motor.smc100.getPosition(1) != 0):
        motor_pipe(-3)
        time.sleep(0.1)
    self.StartOne(photo_diod_y, 250);
    motor_pipe(-1)
    while(self.smc100.getPosition(1) < 19):
        if(photo_pipe(DataPipe) == -1):
            pos = self.smc100.getPosition(photo_diod_y)
            if(pos is None):
                motor_pipe(-2)
            else:
                motor_pipe(pos)
    yPos = photo_pipe(DataPipe)
    self.StartOne(photo_diod_y, yPos)
    for axis in X_motors:
        self.StartOne(axis, xPos)
    for axis in Y_motors:
        self.StartOne(axis, yPos)

def create_motor(name, Port = "COM3"):
    print("New motor created\n")
    smc100 = SMCBaseMotorController(Port, name)
    motors[name] = smc100
    return f"Motor {name} created"


    

if __name__ == "__main__":
    """Get command from redis and execute them"""
    exit_flag = 0;
    motor = None
    while exit_flag == 0:
        messages = controller_commands_pubsub.parse_response()
        if messages:
            print("Received messages:", messages)
            for message in messages:
                if isinstance(message, (bytes, str)):
                    try:
                        message = json.loads(message)
                    except json.decoder.JSONDecodeError as e:
                        print("Error decoding JSON:", e)
                        continue

                    if message["cmd"] == 'create':
                        response = create_motor(message["motor"])
                    elif message["cmd"] == 'calibrate':
                        motor.calibration(message["arg1"], message["arg2"])
                    elif message["cmd"]:
                        if message["arg1"] in motors:
                            motor = motors[message["arg1"]]
                            response = motor.execute_command(message["cmd"], message["arg1"], message["arg2"])
                        else:
                            response = f"Error: Motor with key '{message['arg1']}' not found."
                    
                    print("Received command:", message["cmd"], message["motor"], message["arg1"], message["arg2"])
                    print("Response", response)
                    controller_commands_redis.publish(controller_output_channel, response)
                else:
                    print("Skipped non-string message:", message)
        else:
            print("No messages received")
            
        # for motor_name in motors:
        #     motor = motors[motor_name]
        #     for axis in motor.attributes:
        #         if motor.smc100.getPosition(axis) <  motor.attributes[axis]['lower_limit'] + 0.5 or motor.smc100.getPosition(axis) >  motor.attributes[axis]['upper_limit'] - 0.5:
        #             motor.error = 1
        #             motor.StopOne(axis)
        #             controller_commands_redis.publish(controller_output_channel, f'Motor {motor.name} on {axis} is stopped')
        

def photo_pipe(pipe_name):
    while not os.path.exists(pipe_name):
        time.sleep(0.01)

    with open(pipe_name, 'rb') as pipe:
        data = pipe.read(4)  
        number = struct.unpack('i', data)[0]
        print(f"Received number: {number}")
    return number
        
def motor_pipe(pos):
    while not os.path.exists(MotorPipe):
        print("Waiting for the pipe to be created...")
        time.sleep(0.01)
    
    with open(MotorPipe, 'rb') as pipe:
        message = struct.pack('i', pos)
        pipe.write(message)
        print("Message sent from Python")


#            self.attributes[axis]['revision'] = str(value)

#Tests 
# def test_sardana():
#     device_name = "test/motor1"
#     device_proxy = PyTango.DeviceProxy(device_name)


#     inst = PyTango.DeviceProxy("sardana/motor1/1")
#     inst = SardanaDevice("sardana/motor1/1")

#     print(inst.ping())
#     print(inst.state())
#     smc100 = SMCBaseMotorController(inst,{})

# test_sardana()
