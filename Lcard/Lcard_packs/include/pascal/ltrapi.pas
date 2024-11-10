unit ltrapi;
interface
uses windows, SysUtils, ltrapitypes, ltrapidefine;

const
          LTR_OK                    =  0;     //*��������� ��� ������.*/
          LTR_ERROR_UNKNOWN         = -1;     //*����������� ������.*/
          LTR_ERROR_PARAMETRS       = -2;     //*������ ������� ����������.*/
          LTR_ERROR_MEMORY_ALLOC    = -3;     //*������ ������������� ��������� ������.*/
          LTR_ERROR_OPEN_CHANNEL    = -4;     //*������ �������� ������ ������ � ��������.*/
          LTR_ERROR_OPEN_SOCKET     = -5;     //*������ �������� ������.*/
          LTR_ERROR_CHANNEL_CLOSED  = -6;     //*������. ����� ������ � �������� �� ������.*/
          LTR_ERROR_SEND            = -7;     //*������ ����������� ������.*/
          LTR_ERROR_RECV            = -8;     //*������ ������ ������.*/
          LTR_ERROR_EXECUTE         = -9;     //*������ ������ � �����-������������.*/
          LTR_WARNING_MODULE_IN_USE = -10;    //*����� ������ � �������� ������ � ������� ���������
                                                //� � ����� - �� ���*/
          LTR_ERROR_NOT_CTRL_CHANNEL= -11;    //* ����� ������ ��� ���� �������� ������ ���� CC_CONTROL */                                                
type
// �������� ��� ���������� ������� ����������, ���������� ��� ����������������� ����������������
en_LTR_UserIoCfg=(LTR_USERIO_DIGIN1=1,// ����� �������� ������ � ���������� � DIGIN1
                  LTR_USERIO_DIGIN2   = 2,    // ����� �������� ������ � ���������� � DIGIN2
                  LTR_USERIO_DIGOUT   = 0,    // ����� �������� ������� (����������� ��. en_LTR_DigOutCfg)
                  LTR_USERIO_DEFAULT  = LTR_USERIO_DIGOUT);
// �������� ��� ���������� �������� DIGOUTx
en_LTR_DigOutCfg=(
    LTR_DIGOUT_CONST0   = $00, // ���������� ������� ����������� "0"
    LTR_DIGOUT_CONST1   = $01, // ���������� ������� ���������� "1"
    LTR_DIGOUT_USERIO0  = $02, // ����� ��������� � ����� userio0 (PF1 � ���. 0, PF1 � ���. 1)
    LTR_DIGOUT_USERIO1  = $03, // ����� ��������� � ����� userio1 (PG13)
    LTR_DIGOUT_DIGIN1   = $04, // ����� ��������� �� ����� DIGIN1
    LTR_DIGOUT_DIGIN2   = $05, // ����� ��������� �� ����� DIGIN2
    LTR_DIGOUT_START    = $06, // �� ����� �������� ����� "�����"
    LTR_DIGOUT_SECOND   = $07, // �� ����� �������� ����� "�������"
    LTR_DIGOUT_DEFAULT  = LTR_DIGOUT_CONST0
    );
// �������� ��� ���������� ������� "�����" � "�������"
en_LTR_MarkMode=(
    LTR_MARK_OFF                = $00, // ����� ���������
    LTR_MARK_EXT_DIGIN1_RISE    = $01, // ����� �� ������ DIGIN1
    LTR_MARK_EXT_DIGIN1_FALL    = $02, // ����� �� ����� DIGIN1
    LTR_MARK_EXT_DIGIN2_RISE    = $03, // ����� �� ������ DIGIN2
    LTR_MARK_EXT_DIGIN2_FALL    = $04, // ����� �� ����� DIGIN2
    LTR_MARK_INTERNAL           = $05  // ���������� ��������� �����
    );

TLTR=record
     saddr:Cardinal;                     // ������� ����� �������
	   sport:word;                         // ������� ���� �������
	   csn:SERNUMtext;                     // �������� ����� ������
	   cc:WORD;                            // ����� ������ ������
	   flags:Cardinal;                     // ����� ��������� ������
	   tmark:Cardinal;                     // ��������� �������� ����� �������
	   internal:Pointer;                   // ��������� �� �����
end;
pTLTR = ^TLTR;
TLTR_CONFIG=record
     userio:array[0..3]of WORD;
     digout:array[0..1]of WORD;
     digout_en:WORD;
end;

// ������� ��� ����������� ����������
Function LTR__GenericCtlFunc(
    	TLTR:Pointer;                       // ���������� LTR
    	request_buf:Pointer;                // ����� � ��������
    	request_size:Cardinal;              // ����� ������� (� ������)
    	reply_buf:Pointer;                  // ����� ��� ������ (��� NULL)
    	reply_size:Cardinal;                // ����� ������ (� ������)
    	ack_error_code:integer;             // ����� ������, ���� ack �� GOOD (0 = �� ������������ ack)
    	timeout:Cardinal                   // �������, ��
    ):integer; stdcall;

// ������� ������ ����������



Function LTR_Init(ltr:pTLTR):integer;  stdcall;
Function LTR_Open(ltr:pTLTR):integer;  stdcall;
Function LTR_Close(ltr:pTLTR):integer;  stdcall;
Function LTR_IsOpened(ltr:pTLTR):integer;  stdcall;
Function LTR_Recv(ltr:pTLTR; dataDWORD:Pointer; tmarkDWORD:POINTER; size:Cardinal; timeout:Cardinal):integer;  stdcall;
Function LTR_Send(ltr:pTLTR; dataDWORD:Pointer; size:Cardinal; timeout:Cardinal):integer;  stdcall;
Function LTR_GetCrates(ltr:pTLTR; csnBYTE:Pointer):integer;  stdcall;
Function LTR_GetCrateModules(ltr:pTLTR; midWORD:Pointer):integer;  stdcall;
Function LTR_SetServerProcessPriority(ltr:pTLTR; Priority:Cardinal):integer;  stdcall;
Function LTR_GetCrateRawData(ltr:pTLTR; dataDWORD:Pointer; tmarkDWORD:Pointer; size:Cardinal; timeout:Cardinal):integer;  stdcall;
Function LTR_GetErrorString(error:integer):string;  stdcall;

Function    LTR_GetCrateInfo(ltr:pTLTR; CrateInfoTCRATE_INFO:Pointer):integer; stdcall;
Function    LTR_Config(ltr:pTLTR; confTLTR_CONFIG:Pointer):integer; stdcall;
Function    LTR_StartSecondMark(ltr:pTLTR; mode:en_LTR_MarkMode):integer; stdcall;
Function    LTR_StopSecondMark(ltr:pTLTR):integer; stdcall;
Function    LTR_MakeStartMark(ltr:pTLTR; mode:en_LTR_MarkMode):integer; stdcall;
Function    LTR_GetListOfIPCrates(ltr:pTLTR; max_entries:DWORD; ip_net:DWORD; ip_mask:DWORD; entries_foundDWORD:Pointer; entries_returnedDWORD:Pointer; info_array:TIPCRATE_ENTRY):integer; stdcall;
Function    LTR_AddIPCrate(ltr:pTLTR; ip_addr:DWORD; flags:DWORD; permanent:BOOL):integer; stdcall;
Function    LTR_DeleteIPCrate(ltr:pTLTR; ip_addr:DWORD; permanent:BOOL):integer; stdcall;
Function    LTR_ConnectIPCrate(ltr:pTLTR; ip_addr:DWORD):integer; stdcall;
Function    LTR_DisconnectIPCrate(ltr:pTLTR; ip_addr:DWORD):integer; stdcall;
Function    LTR_ConnectAllAutoIPCrates(ltr:pTLTR):integer; stdcall;
Function    LTR_DisconnectAllIPCrates(ltr:pTLTR):integer; stdcall;
Function    LTR_SetIPCrateFlags(ltr:pTLTR; ip_addr:DWORD; new_flags:DWORD; permanent:BOOL):integer; stdcall;
Function    LTR_GetIPCrateDiscoveryMode(ltr:pTLTR; enabledBOOL:Pointer; autoconnectBOOL:Pointer):integer; stdcall;
Function    LTR_SetIPCrateDiscoveryMode(ltr:pTLTR; enabled:BOOL; autoconnect:BOOL; permanent:BOOL):integer; stdcall;
Function    LTR_GetLogLevel(ltr:pTLTR; levelINT:Pointer):integer; stdcall;
Function    LTR_SetLogLevel(ltr:pTLTR; level:integer;  permanent:BOOL):integer; stdcall;
Function    LTR_ServerRestart(ltr:pTLTR):integer; stdcall;
Function    LTR_ServerShutdown(ltr:pTLTR):integer; stdcall;
Function    LTR_SetTimeout(ltr:pTLTR; ms:Cardinal):integer; stdcall;
Function    LTR_GetServerProcessPriority(ltr:pTLTR; Priority:Pointer):integer; stdcall;
Function    LTR_GetServerVersion(ltr:pTLTR; version:Pointer):integer; stdcall;


Implementation
  Function LTR__GenericCtlFunc(TLTR:Pointer;request_buf:Pointer;request_size:Cardinal;reply_buf:Pointer;reply_size:Cardinal;ack_error_code:integer;timeout:Cardinal):integer;external 'ltrapi.dll';
  Function LTR_Init(ltr:pTLTR):integer;external 'ltrapi.dll';
  Function LTR_Open(ltr:pTLTR):integer;external 'ltrapi.dll';
  Function LTR_Close(ltr:pTLTR):integer;external 'ltrapi.dll';
  Function LTR_IsOpened(ltr:pTLTR):integer;external 'ltrapi.dll';
  Function LTR_Recv(ltr:pTLTR; dataDWORD:Pointer; tmarkDWORD:POINTER; size:Cardinal; timeout:Cardinal):integer;external 'ltrapi.dll';
  Function LTR_Send(ltr:pTLTR; dataDWORD:Pointer; size:Cardinal; timeout:Cardinal):integer;external 'ltrapi.dll';
  Function LTR_GetCrates(ltr:pTLTR; csnBYTE:Pointer):integer;external 'ltrapi.dll';
  Function LTR_GetCrateModules(ltr:pTLTR; midWORD:Pointer):integer;external 'ltrapi.dll';
  Function LTR_SetServerProcessPriority(ltr:pTLTR; Priority:Cardinal):integer;external 'ltrapi.dll';
  Function LTR_GetCrateRawData(ltr:pTLTR; dataDWORD:Pointer; tmarkDWORD:Pointer; size:Cardinal; timeout:Cardinal):integer;external 'ltrapi.dll';
  Function LTR_GetErrorString(error:integer):string; external 'ltrapi.dll';

  Function LTR_GetCrateInfo(ltr:pTLTR; CrateInfoTCRATE_INFO:Pointer):integer; external 'ltrapi.dll';
  Function LTR_Config(ltr:pTLTR; confTLTR_CONFIG:Pointer):integer; external 'ltrapi.dll';
  Function LTR_StartSecondMark(ltr:pTLTR; mode:en_LTR_MarkMode):integer; external 'ltrapi.dll';
  Function LTR_StopSecondMark(ltr:pTLTR):integer; external 'ltrapi.dll';
  Function LTR_MakeStartMark(ltr:pTLTR; mode:en_LTR_MarkMode):integer; external 'ltrapi.dll';
  Function LTR_GetListOfIPCrates(ltr:pTLTR; max_entries:DWORD; ip_net:DWORD; ip_mask:DWORD; entries_foundDWORD:Pointer; entries_returnedDWORD:Pointer; info_array:TIPCRATE_ENTRY):integer; external 'ltrapi.dll';
  Function LTR_AddIPCrate(ltr:pTLTR; ip_addr:DWORD; flags:DWORD; permanent:BOOL):integer; external 'ltrapi.dll';
  Function LTR_DeleteIPCrate(ltr:pTLTR; ip_addr:DWORD; permanent:BOOL):integer; external 'ltrapi.dll';
  Function LTR_ConnectIPCrate(ltr:pTLTR; ip_addr:DWORD):integer; external 'ltrapi.dll';
  Function LTR_DisconnectIPCrate(ltr:pTLTR; ip_addr:DWORD):integer; external 'ltrapi.dll';
  Function LTR_ConnectAllAutoIPCrates(ltr:pTLTR):integer; external 'ltrapi.dll';
  Function LTR_DisconnectAllIPCrates(ltr:pTLTR):integer; external 'ltrapi.dll';
  Function LTR_SetIPCrateFlags(ltr:pTLTR; ip_addr:DWORD; new_flags:DWORD; permanent:BOOL):integer; external 'ltrapi.dll';
  Function LTR_GetIPCrateDiscoveryMode(ltr:pTLTR; enabledBOOL:Pointer; autoconnectBOOL:Pointer):integer; external 'ltrapi.dll';
  Function LTR_SetIPCrateDiscoveryMode(ltr:pTLTR; enabled:BOOL; autoconnect:BOOL; permanent:BOOL):integer; external 'ltrapi.dll';
  Function LTR_GetLogLevel(ltr:pTLTR; levelINT:Pointer):integer; external 'ltrapi.dll';
  Function LTR_SetLogLevel(ltr:pTLTR; level:integer;  permanent:BOOL):integer; external 'ltrapi.dll';
  Function LTR_ServerRestart(ltr:pTLTR):integer; external 'ltrapi.dll';
  Function LTR_ServerShutdown(ltr:pTLTR):integer; external 'ltrapi.dll';
  Function LTR_SetTimeout(ltr:pTLTR; ms:Cardinal):integer; external 'ltrapi.dll';
  Function LTR_GetServerProcessPriority(ltr:pTLTR; Priority:Pointer):integer; external 'ltrapi.dll';
  Function LTR_GetServerVersion(ltr:pTLTR; version:Pointer):integer; external 'ltrapi.dll';

end.


