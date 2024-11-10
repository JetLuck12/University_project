unit ltr27api;
interface
uses windows, SysUtils, ltrapitypes, ltrapidefine, ltrapi;
const
        LTR27_ERROR_SEND_DATA           =-3000;
        LTR27_ERROR_RECV_DATA           =-3001;
        LTR27_ERROR_RESET_MODULE        =-3002;
        LTR27_ERROR_NOT_LTR27           =-3003;
        LTR27_ERROR_PARITY              =-3004;
        LTR27_ERROR_OVERFLOW            =-3005;
        LTR27_ERROR_INDEX               =-3006;
        LTR27_ERROR                     =-3007;
        LTR27_ERROR_EXCHANGE            =-3008;
        LTR27_ERROR_FORMAT              =-3008;
        LTR27_ERROR_CRC                 =-3010;

        LTR27_MEZZANINE_NUMBER          =8;

        LTR27_DATA_CORRECTION           =1 shl 0;
        LTR27_DATA_VALUE                =1 shl 1;
// ������� ��� �������
        LTR27_MODULE_DESCRIPTION        =1 shl 0;
        LTR27_MEZZANINE1_DESCRIPTION    =1 shl 1;
        LTR27_MEZZANINE2_DESCRIPTION    =1 shl 2;
        LTR27_MEZZANINE3_DESCRIPTION    =1 shl 3;
        LTR27_MEZZANINE4_DESCRIPTION    =1 shl 4;
        LTR27_MEZZANINE5_DESCRIPTION    =1 shl 5;
        LTR27_MEZZANINE6_DESCRIPTION    =1 shl 6;
        LTR27_MEZZANINE7_DESCRIPTION    =1 shl 7;
        LTR27_MEZZANINE8_DESCRIPTION    =1 shl 8;
        LTR27_ALL_MEZZANINE_DESCRIPTION =510; //(��� ���� ����� LTR27_MODULE_DESCRIPTION)
        LTR27_ALL_DESCRIPTION           =511;//��� ����


type
// ��������� �������� ������
TINFO_LTR27=record
	    Module:TDESCRIPTION_MODULE;
	    Cpu:TDESCRIPTION_CPU;
	    Mezzanine:array[0..LTR27_MEZZANINE_NUMBER-1]of TDESCRIPTION_MEZZANINE;
end;

TMezzanine=record
      Name :array[0..15]of char;              // �������� ���������
      MUnit:array[0..15]of char;              // ���������� ���������� ���.��������   � � ��� UNIT �� � PASCAL ��� ���������������
      ConvCoeff:array[0..1]of double;          // ������� � �������� ��� ��������� ���� � ���.��������
      CalibrCoeff:array[0..3]of double;        // ������������� ������������
end;



TLTR27=record
  //**** ��������� ����������       //
  size:integer;
  Channel:TLTR;                     //
  subchannel:BYTE ;                 //
  //**** ��������� ������           //
  FrequencyDivisor:byte;	 	        // �������� ������� ������������� 0..255 (1000..4 ��)
  Mezzanine:array[0..LTR27_MEZZANINE_NUMBER-1]of TMezzanine;// ������������� ��������
  ModuleInfo:TINFO_LTR27;
end;                           //
pTLTR27=^TLTR27;// ��������� �������� ������

  // �������� �������
  Function  LTR27_Init                (module:pTLTR27):Integer; stdcall;
  Function  LTR27_Open                (module:pTLTR27; saddrDWORD:Cardinal; sport:WORD; csnCHAR:Pointer; cc:WORD):Integer; stdcall;
  Function  LTR27_Close               (module:pTLTR27):Integer; stdcall;
  Function  LTR27_IsOpened            (module:pTLTR27):Integer; stdcall;
  Function  LTR27_Echo                (module:pTLTR27):Integer; stdcall;
  Function  LTR27_GetConfig           (module:pTLTR27):Integer; stdcall;
  Function  LTR27_SetConfig           (module:pTLTR27):Integer; stdcall;
  Function  LTR27_ADCStart            (module:pTLTR27):Integer; stdcall;
  Function  LTR27_ADCStop             (module:pTLTR27):Integer; stdcall;
  Function  LTR27_Recv                (module:pTLTR27; dataDWORD:Pointer; tstampDWORD:Pointer; sizeDWORD:Cardinal; timeoutDWORD:Cardinal):Integer; stdcall;
  Function  LTR27_ProcessData         (module:pTLTR27; src_dataDWORD:Pointer; dst_dataDouble:Pointer; sizeDWORD:Pointer; calibr:BOOLEAN; value:BOOLEAN):Integer; stdcall;
  Function  LTR27_GetDescription      (module:pTLTR27; flags:WORD):Integer; stdcall;
  Function  LTR27_WriteMezzanineDescr (module:pTLTR27; mn:BYTE):Integer; stdcall;
  // ������� ���������������� ���������
  Function  LTR27_GetErrorString(error:integer):Pointer; stdcall;
implementation
  // �������� �������
  Function  LTR27_Init                (module:pTLTR27):Integer; external 'ltr27api.dll';
  Function  LTR27_Open                (module:pTLTR27; saddrDWORD:Cardinal; sport:WORD; csnCHAR:Pointer; cc:WORD):Integer; external 'ltr27api.dll';
  Function  LTR27_Close               (module:pTLTR27):Integer; external 'ltr27api.dll';
  Function  LTR27_IsOpened            (module:pTLTR27):Integer; external 'ltr27api.dll';
  Function  LTR27_Echo                (module:pTLTR27):Integer; external 'ltr27api.dll';
  Function  LTR27_GetConfig           (module:pTLTR27):Integer; external 'ltr27api.dll';
  Function  LTR27_SetConfig           (module:pTLTR27):Integer; external 'ltr27api.dll';
  Function  LTR27_ADCStart            (module:pTLTR27):Integer; external 'ltr27api.dll';
  Function  LTR27_ADCStop             (module:pTLTR27):Integer; external 'ltr27api.dll';
  Function  LTR27_Recv                (module:pTLTR27; dataDWORD:Pointer; tstampDWORD:Pointer; sizeDWORD:Cardinal; timeoutDWORD:Cardinal):Integer; external 'ltr27api.dll';
  Function  LTR27_ProcessData         (module:pTLTR27; src_dataDWORD:Pointer; dst_dataDouble:Pointer; sizeDWORD:Pointer; calibr:BOOLEAN; value:BOOLEAN):Integer; external 'ltr27api.dll';
  Function  LTR27_GetDescription      (module:pTLTR27; flags:WORD):Integer; external 'ltr27api.dll';
  Function  LTR27_WriteMezzanineDescr (module:pTLTR27; mn:BYTE):Integer; external 'ltr27api.dll';
  // ������� ���������������� ���������
  Function  LTR27_GetErrorString(error:integer):Pointer; external 'ltr27api.dll';
end.


