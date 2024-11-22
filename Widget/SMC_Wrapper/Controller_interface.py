from SMC_Wrapper.smc100_new import SMCMotorHW
import json

class SMCBaseMotorController():
    def __init__(self, Port, name):
        """Constructor"""
        self.Port = Port
        self.smc100 = SMCMotorHW(self.Port)
        print('Init: SUCCESS')
        self.name = name
        self.attributes = {}
        self._motors = {}
        self._isMoving = None
        self._moveStartTime = None
        self.error = None
        self._timeout = 10

    def execute_command(self, cmd, arg1, arg2):
        """Execute command and return value"""
        command_name = cmd.lower()
        if command_name == 'add':
            axis = int(arg1)
            self.AddDevice(axis)
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
            axis, position = int(arg1), int(arg2)
            self.StartOne(axis, position)
            return f"Motor of axis {axis} going to {position}"
        elif command_name == 'stop':
            axis = int(arg1)
            self.StopOne(axis)
            return f"{axis} stopped"
        elif command_name == 'status':
            return self.status(int(arg1))
        else:
            return f"Unknown command: {cmd}"

    def AddDevice(self, axis):
        self.attributes[axis] = {}
        self.attributes[axis]['step_per_unit'] = 0
        self.attributes[axis]['step_per_unit_set'] = False
        self.attributes[axis]['lower_limit'] = 2
        self.attributes[axis]['upper_limit'] = 20
        self.attributes[axis]['offset'] = 0
        self.attributes[axis]['revision'] = self.smc100.getRevision(axis)
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
        if position < low or position > upp:
            raise ValueError('Invalid position: exceed lower or upper limit')
        self.smc100.move(axis, position, waitStop=False)

    def StopOne(self, axis):
        """Stop the specified motor"""
        self.smc100.stop(axis)

    def status(self, axis):
            status = {
                'model': 'SMC100',
                'error': self.error,
                'move_status': self.StateOne(axis),
                'coord': self.ReadOne(axis),
#                'velocity': self.smc100.GetAxisPar(axis, 'velocity'),
#                'acceleration': self.smc100.GetAxisPar(axis, 'acceleration')
            }
            return json.dumps(status)


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
