unit ltr22api;

interface

uses windows, SysUtils;

const
        LTR_OK=0;
        LTR22_ADC_NUMBERS=4;
        LTR22_ADC_CHANNELS=LTR22_ADC_NUMBERS;
        LTR22_RANGE_NUMBER=6;
        LTR22_RANGE_OVERFLOW=7;

type

TLTR = packed record
        saddr:Cardinal;                       // ������� ����� �������
        sport:word;                       // ������� ���� �������
        csn:array [0..15] of byte;                     // �������� ����� ������
        cc:word;                          // ����� ������ ������
        flags:Cardinal;                       // ����� ��������� ������
        tmark:Cardinal;                       // ��������� �������� ����� �������
        internal:Pointer;                   // ��������� �� �����
end;

DAC_CHANNEL_CALIBRATION=packed record
	FactoryCalibOffset:array [0..LTR22_RANGE_NUMBER] of real;
	FactoryCalibScale:array [0..LTR22_RANGE_NUMBER] of real;

	UserCalibOffset:array [0..LTR22_RANGE_NUMBER] of real;
	UserCalibScale:array [0..LTR22_RANGE_NUMBER] of real;
end;

TDESCRIPTION_MODULE=packed record                        //                                                          //
  CompanyName:array[0..16] of byte;                                  //
  DeviceName:array[0..16] of byte;                                   // �������� �������
  SerialNumber:array[0..16] of byte;                                 // �������� ����� �������
  Revision:byte;                                         // ������� �������
  Comment:array[0..256] of byte;                          //
end;

TDESCRIPTION_CPU=packed record                        //                                                          //
  Active:byte;                                      // ���� ������������� ��������� ����� ���������
  Name:array[0..16] of byte;                                        // ��������
  ClockRate:double;
  FirmwareVersion:Cardinal;                          //
  Comment:array[0..256] of byte;                          //
end;                                     //

// �������� ������ (�� ������������)
TDESCRIPTION_LTR22=packed record                   //                                   //
  Description:TDESCRIPTION_MODULE;    //
  Cpu:TDESCRIPTION_CPU;       //
end;               //


// ���������, �������� ����� ������ ��� ��� ������ E-440
TLTR22 = packed record
   //**** ��������� ����������
  ltr:TLTR;							// ��������� ����������� ������ � ������ � �������� � ltrapi.pdf
  //**** ��������� ������
  // ��������� ������
  Fdiv_rg:byte;						// �������� ������� ������ 1..15
  Adc384:bool;						// �������������� �������� ������� ������� true =3 false =4
  AC_DC_State:bool;					// ��������� true =AC+DC false=AC
  MeasureADCZero:bool;				// ��������� Zero true - �������� false - ���������
  DataReadingProcessed:bool;		// ��������� ���������� ��� true-��� ����������� false - ���
  ADCChannelRange:array [0..LTR22_ADC_NUMBERS] of Byte;// ������ ��������� ��� �� ������� 0 - 1� 1 - 0.3� 2 - 0.1� 3 - 0.03� 4 - 10� 5 - 3�

  ChannelEnabled:array [0..LTR22_ADC_NUMBERS] of bool;		// ��������� �������, ������� - true �������� - false

  SyncType:Byte;		// ��� ������������� 0 - ���������� ����� �� ������� Go
						//1 - ���������
						//2 -  ������� �����
						//3 -  �������������
  SyncMaster:bool;            // true - ������ ������� ������, false - ������ ��������� ������������

  ADCCalibration:array [1..LTR22_ADC_NUMBERS] of DAC_CHANNEL_CALIBRATION;
  ModuleDescription:TDESCRIPTION_LTR22;
end;
pTLTR22 = ^TLTR22;



Function LTR22_Init(module:pTLTR22) : Integer; stdcall;
Function LTR22_Open(module:pTLTR22; saddr:Cardinal; sport:Cardinal;csnArrayByte:Pointer;cc:short) : Integer; stdcall;
Function LTR22_Close(module:pTLTR22) : Integer; stdcall;
Function LTR22_IsOpened(module:pTLTR22) : Integer; stdcall;
Function LTR22_GetConfig(module:pTLTR22) : Integer; stdcall;
Function LTR22_SetConfig(module:pTLTR22) : Integer; stdcall;
Function LTR22_StartADC(module:pTLTR22; WaitSync:bool) : Integer; stdcall;
Function LTR22_StopADC(module:pTLTR22) : Integer; stdcall;
Function LTR22_ClearBuffer(module:pTLTR22; wait_response:bool) : Integer; stdcall;
Function LTR22_SetSyncPriority(module:pTLTR22; SyncMaster:bool) : Integer; stdcall;
Function LTR22_SyncPhaze(module:pTLTR22; timeout:Cardinal) : Integer; stdcall;
Function LTR22_SwitchADCStartStop(module:pTLTR22;Value:bool) : Integer; stdcall;
Function LTR22_SwitchMeasureADCZero(module:pTLTR22;Value:bool) : Integer; stdcall;
Function LTR22_SetFreq(module:pTLTR22;adc384:bool;Freq_dv:Byte) : Integer; stdcall;
Function LTR22_SetADCRange(module:pTLTR22;ADCChannel:Byte;ADCChannelRange:Byte) : Integer; stdcall;
Function LTR22_SetADCChannel(module:pTLTR22;ADCChannel:Byte;EnableADC:bool) : Integer; stdcall;
Function LTR22_GetCalibrovka(module:pTLTR22) : Integer; stdcall;
Function LTR22_Recv(module:pTLTR22; dataCardinalArray:Pointer; tstampCardinal:Pointer; size:Cardinal; timeout:Cardinal) : Integer; stdcall;
Function LTR22_GetModuleDescription(module:pTLTR22) : Integer; stdcall;
Function LTR22_ProcessData(module:pTLTR22; dataSourceCardinalArray:Pointer; dataDestinationDouble:Pointer;
                Size:Cardinal;calibrMainPset:bool;calibrExtraVolts:bool;OverflowFlagsByteArray:Pointer) : Integer; stdcall;

Function LTR22_ReadAVREEPROM(module:pTLTR22; dataByteArray:Pointer; address:short;size:short) : Integer; stdcall;
Function LTR22_WriteAVREEPROM(module:pTLTR22; dataByteArray:Pointer;address:short;size:short) : Integer; stdcall;

Function LTR22_GetErrorString(Index:Integer) : string; stdcall;

implementation
        Function LTR22_Init(module:pTLTR22) : Integer; external 'ltr22api.dll';
        Function LTR22_Open(module:pTLTR22; saddr:Cardinal; sport:Cardinal;csnArrayByte:Pointer;cc:short) : Integer; external 'ltr22api.dll';
        Function LTR22_Close(module:pTLTR22) : Integer; external 'ltr22api.dll';
        Function LTR22_IsOpened(module:pTLTR22) : Integer; external 'ltr22api.dll';
        Function LTR22_GetConfig(module:pTLTR22) : Integer; external 'ltr22api.dll';
        Function LTR22_SetConfig(module:pTLTR22) : Integer; external 'ltr22api.dll';
        Function LTR22_StartADC(module:pTLTR22; WaitSync:bool) : Integer; external 'ltr22api.dll';
        Function LTR22_StopADC(module:pTLTR22) : Integer;external 'ltr22api.dll';
        Function LTR22_ClearBuffer(module:pTLTR22; wait_response:bool) : Integer; external 'ltr22api.dll';
        Function LTR22_SetSyncPriority(module:pTLTR22; SyncMaster:bool) : Integer; external 'ltr22api.dll';
        Function LTR22_SyncPhaze(module:pTLTR22; timeout:Cardinal) : Integer; external 'ltr22api.dll';
        Function LTR22_SwitchADCStartStop(module:pTLTR22;Value:bool) : Integer; external 'ltr22api.dll';
        Function LTR22_SwitchMeasureADCZero(module:pTLTR22;Value:bool) : Integer; external 'ltr22api.dll';
        Function LTR22_SetFreq(module:pTLTR22;adc384:bool;Freq_dv:Byte) : Integer; external 'ltr22api.dll';
        Function LTR22_SetADCRange(module:pTLTR22;ADCChannel:Byte;ADCChannelRange:Byte) : Integer; external 'ltr22api.dll';
        Function LTR22_SetADCChannel(module:pTLTR22;ADCChannel:Byte;EnableADC:bool) : Integer; external 'ltr22api.dll';
        Function LTR22_GetCalibrovka(module:pTLTR22) : Integer; external 'ltr22api.dll';
        Function LTR22_Recv(module:pTLTR22; dataCardinalArray:Pointer; tstampCardinal:Pointer; size:Cardinal; timeout:Cardinal) : Integer; external 'ltr22api.dll';
        Function LTR22_GetModuleDescription(module:pTLTR22) : Integer; external 'ltr22api.dll';
        Function LTR22_ProcessData(module:pTLTR22; dataSourceCardinalArray:Pointer; dataDestinationDouble:Pointer;
                        Size:Cardinal;calibrMainPset:bool;calibrExtraVolts:bool;OverflowFlagsByteArray:Pointer) : Integer; external 'ltr22api.dll';

        Function LTR22_ReadAVREEPROM(module:pTLTR22; dataByteArray:Pointer; address:short;size:short) : Integer; external 'ltr22api.dll';
        Function LTR22_WriteAVREEPROM(module:pTLTR22; dataByteArray:Pointer;address:short;size:short) : Integer; external 'ltr22api.dll';

        Function LTR22_GetErrorString(Index:Integer) : string; external 'ltr22api.dll';
end.
