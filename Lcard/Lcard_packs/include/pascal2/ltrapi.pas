unit ltrapi;
interface
uses SysUtils, ltrapitypes, ltrapidefine;

const
    LTR_OK                              =  0;  // ��������� ��� ������.
    LTR_ERROR_UNKNOWN                   = -1;  // ����������� ������.
    LTR_ERROR_PARAMETERS                = -2;  // ������ ������� ����������.
    LTR_ERROR_PARAMETRS                 =  LTR_ERROR_PARAMETERS;
    LTR_ERROR_MEMORY_ALLOC              = -3;  // ������ ������������� ��������� ������.
    LTR_ERROR_OPEN_CHANNEL              = -4;  // ������ �������� ������ ������ � ��������.
    LTR_ERROR_OPEN_SOCKET               = -5;  // ������ �������� ������.
    LTR_ERROR_CHANNEL_CLOSED            = -6;  // ������. ����� ������ � �������� �� ������.
    LTR_ERROR_SEND                      = -7;  // ������ ����������� ������.
    LTR_ERROR_RECV                      = -8;  // ������ ������ ������.
    LTR_ERROR_EXECUTE                   = -9;  // ������ ������ � �����-������������.
    LTR_WARNING_MODULE_IN_USE           = -10; // ����� ������ � �������� ������ � ������� ���������
                                               // � � �����-�� ���
    LTR_ERROR_NOT_CTRL_CHANNEL          = -11; // ����� ������ ��� ���� �������� ������ ���� CC_CONTROL
    LTR_ERROR_SRV_INVALID_CMD           = -12; // ������� �� �������������� ��������
    LTR_ERROR_SRV_INVALID_CMD_PARAMS    = -13; // ������ �� ������������ ��������� ��������� �������
    LTR_ERROR_INVALID_CRATE             = -14; // ��������� ����� �� ������
    LTR_ERROR_EMPTY_SLOT                = -15; // � ��������� ����� ����������� ������
    LTR_ERROR_UNSUP_CMD_FOR_SRV_CTL     = -16; // ������� �� �������������� ����������� ������� �������
    LTR_ERROR_INVALID_IP_ENTRY          = -17; // �������� ������ �������� ������ ������
    LTR_ERROR_NOT_IMPLEMENTED           = -18; // ������ ����������� �� �����������
    LTR_ERROR_CONNECTION_CLOSED         = -19; // ���������� ���� ������� ��������
    LTR_ERROR_LTRD_UNKNOWN_RETCODE      = -20; // ����������� ��� ������ ������ ltrd
    LTR_ERROR_LTRD_CMD_FAILED           = -21; // ������ ���������� ����������� ������� ltrd
    LTR_ERROR_INVALID_CON_SLOT_NUM      = -22; // ������ �������� ����� ����� ��� �������� ����������

    LTR_ERROR_INVALID_MODULE_DESCR      = -40; // �������� ��������� ������
    LTR_ERROR_INVALID_MODULE_SLOT       = -41; // ������ �������� ���� ��� ������
    LTR_ERROR_INVALID_MODULE_ID         = -42; // �������� ID-������ � ������ �� �����
    LTR_ERROR_NO_RESET_RESPONSE         = -43; // ��� ������ �� ������� �����
    LTR_ERROR_SEND_INSUFFICIENT_DATA    = -44; // �������� ������ ������, ��� �������������
    LTR_ERROR_RECV_INSUFFICIENT_DATA    = -45;
    LTR_ERROR_NO_CMD_RESPONSE           = -46; // ��� ������ �� ������� �����
    LTR_ERROR_INVALID_CMD_RESPONSE      = -47; // ������ �������� ����� �� �������
    LTR_ERROR_INVALID_RESP_PARITY       = -48; // �������� ��� �������� � ��������� ������
    LTR_ERROR_INVALID_CMD_PARITY        = -49; // ������ �������� ���������� �������
    LTR_ERROR_UNSUP_BY_FIRM_VER         = -50; // ����������� �� �������������� ������ ������� ��������
    LTR_ERROR_MODULE_STARTED            = -51; // ������ ��� �������
    LTR_ERROR_MODULE_STOPPED            = -52; // ������ ����������
    LTR_ERROR_RECV_OVERFLOW             = -53; // ��������� ������������ ������
    LTR_ERROR_FIRM_FILE_OPEN            = -54; // ������ �������� ����� ��������
    LTR_ERROR_FIRM_FILE_READ            = -55; // ������ ������ ����� ��������
    LTR_ERROR_FIRM_FILE_FORMAT          = -56; // ������ ������� ����� ��������
    LTR_ERROR_FPGA_LOAD_READY_TOUT      = -57; // �������� ������� �������� ���������� ���� � ��������
    LTR_ERROR_FPGA_LOAD_DONE_TOUT       = -58; // �������� ������� �������� �������� ���� � ������� �����
    LTR_ERROR_FPGA_IS_NOT_LOADED        = -59; // �������� ���� �� ���������
    LTR_ERROR_FLASH_INVALID_ADDR        = -60; // �������� ����� Flash-������
    LTR_ERROR_FLASH_WAIT_RDY_TOUT       = -61; // �������� ������� �������� ���������� ������/�������� Flash-������
    LTR_ERROR_FIRSTFRAME_NOTFOUND       = -62; // First frame in card data stream not found
    LTR_ERROR_CARDSCONFIG_UNSUPPORTED   = -63;
    LTR_ERROR_FLASH_OP_FAILED           = -64; // ������ ��������� �������� flash-�������
    LTR_ERROR_FLASH_NOT_PRESENT         = -65; // Flash-������ �� ����������
    LTR_ERROR_FLASH_UNSUPPORTED_ID      = -66; // ��������� ���������������� ��� flash-������
    LTR_ERROR_FLASH_UNALIGNED_ADDR      = -67; // ������������� ����� flash-������
    LTR_ERROR_FLASH_VERIFY              = -68; // ������ ��� �������� ���������� ������ �� flash-������
    LTR_ERROR_FLASH_UNSUP_PAGE_SIZE     = -69; // ���������� ���������������� ������ �������� flash-������
    LTR_ERROR_FLASH_INFO_NOT_PRESENT    = -70; // ����������� ���������� � ������ �� Flash-������
    LTR_ERROR_FLASH_INFO_UNSUP_FORMAT   = -71; // ���������������� ������ ���������� � ������ �� Flash-������
    LTR_ERROR_FLASH_SET_PROTECTION      = -72; // �� ������� ���������� ������ Flash-������
    LTR_ERROR_FPGA_NO_POWER             = -73; // ��� ������� ���������� ����
    LTR_ERROR_FPGA_INVALID_STATE        = -74; // �� �������������� ��������� �������� ����
    LTR_ERROR_FPGA_ENABLE               = -75; // �� ������� ��������� ���� � ����������� ���������
    LTR_ERROR_FPGA_AUTOLOAD_TOUT        = -76; // ������� ����� �������� �������������� �������� ����
    LTR_ERROR_PROCDATA_UNALIGNED        = -77; // �������������� ������ �� ��������� �� ������� �����
    LTR_ERROR_PROCDATA_CNTR             = -78; // ������ �������� � �������������� ������
    LTR_ERROR_PROCDATA_CHNUM            = -79; // �������� ����� ������ � �������������� ������
    LTR_ERROR_PROCDATA_WORD_SEQ         = -80; // �������� ������������������ ���� � �������������� ������
    LTR_ERROR_FLASH_INFO_CRC            = -81; // �������� ����������� ����� � ���������� ���������� � ������


    { ������� ������ ������� ������� ltrd. }
    LTR_LOGLVL_ERR_FATAL    = 0; // ��������� ������
    LTR_LOGLVL_ERR          = 1; // ������
    LTR_LOGLVL_WARN         = 2; // ��������������
    LTR_LOGLVL_INFO         = 3; // �������������� ���������
    LTR_LOGLVL_DETAIL       = 4; // ������
    LTR_LOGLVL_DBG_HIGH     = 5; // ���������� ��������� ����������� ������ ��������
    LTR_LOGLVL_DBG_MED      = 6; // ���������� ��������� �������� ������ ��������
    LTR_LOGLVL_DBG_LOW      = 7; // ���������� ��������� ������� ������ ��������

   { ����� ������� ��������� ���������� � ������������ �������. }
   LTR_GETCRATES_FLAGS_WORKMODE_ONLY   = $01;
type
// �������� ��� ���������� ������� ����������, ���������� ��� ����������������� ����������������
en_LTR_UserIoCfg=(LTR_USERIO_DIGIN1    =1,// ����� �������� ������ � ���������� � DIGIN1
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
    LTR_DIGOUT_IRIG     = $08, // �������� �������� ������� ������� IRIG (digout1: ����������, digout2: �������)
    LTR_DIGOUT_DEFAULT  = LTR_DIGOUT_CONST0
    );
// �������� ��� ���������� ������� "�����" � "�������"
en_LTR_MarkMode=(
    LTR_MARK_OFF                = $00, // ����� ���������
    LTR_MARK_EXT_DIGIN1_RISE    = $01, // ����� �� ������ DIGIN1
    LTR_MARK_EXT_DIGIN1_FALL    = $02, // ����� �� ����� DIGIN1
    LTR_MARK_EXT_DIGIN2_RISE    = $03, // ����� �� ������ DIGIN2
    LTR_MARK_EXT_DIGIN2_FALL    = $04, // ����� �� ����� DIGIN2
    LTR_MARK_INTERNAL           = $05, // ���������� ��������� �����

    LTR_MARK_NAMUR1_LO2HI       = 8,   // �� ������� NAMUR1 (START_IN), ����������� ����
    LTR_MARK_NAMUR1_HI2LO       = 9,   // �� ������� NAMUR1 (START_IN), ���� ����
    LTR_MARK_NAMUR2_LO2HI       = 10,  // �� ������� NAMUR2 (M1S_IN), ����������� ����
    LTR_MARK_NAMUR2_HI2LO       = 11,  // �� ������� NAMUR2 (M1S_IN), ���� ����

    { �������� ����� - ������� �������� ������� ������� IRIG-B006
       IRIG ����� �������������� ������ ��� ����� "�������", ��� "�����" ������������ }
    LTR_MARK_SEC_IRIGB_DIGIN1   = 16,   // �� ����� DIGIN1, ������ ������
    LTR_MARK_SEC_IRIGB_nDIGIN1  = 17,   // �� ����� DIGIN1, ��������������� ������
    LTR_MARK_SEC_IRIGB_DIGIN2   = 18,   // �� ����� DIGIN2, ������ ������
    LTR_MARK_SEC_IRIGB_nDIGIN2  = 19    // �� ����� DIGIN2, ��������������� ������
    );


{$A4}
TLTR=record
    saddr:LongWord;                     // ������� ����� �������
    sport:word;                         // ������� ���� �������
    csn:SERNUMtext;                     // �������� ����� ������
    cc:WORD;                            // ����� ������ ������
    flags:LongWord;                     // ����� ��������� ������
    tmark:LongWord;                     // ��������� �������� ����� �������
    internal:Pointer;                   // ��������� �� �����
end;
pTLTR = ^TLTR;
TLTR_CONFIG=record
     userio:array[0..3]of WORD;
     digout:array[0..1]of WORD;
     digout_en:WORD;
end;

Type t_crate_ipentry_array = array[0..0] of TLTR_CRATE_IP_ENTRY;
Type p_crate_ipentry_array = ^t_crate_ipentry_array;

{$A+}



Function LTR_Init(out ltr: TLTR):integer; overload;
Function LTR_Open(var ltr: TLTR):integer; overload;
Function LTR_OpenSvcControl(var ltr: TLTR; ltrd_addr : LongWord; ltrd_port : Word): integer;
Function LTR_OpenCrate(var ltr: TLTR; ltrd_addr : LongWord; ltrd_port : Word; crate_iface: Integer; crate_sn: string): integer;
Function LTR_OpenEx(var ltr: TLTR; tout : LongWord):integer;

Function LTR_Close(var ltr: TLTR):integer; overload;
Function LTR_IsOpened(var ltr: TLTR):integer; overload;
//���������� ���� � �������� ������� � ��������� TLTR (������������ ����� ���������)
Procedure LTR_FillSerial(var ltr: TLTR; csn : string);

Function LTR_GetCrates(var ltr: TLTR; var csn: array of string; out crates_cnt: Integer):integer;  overload;
Function LTR_GetCrateModules(var ltr: TLTR; var mids: array of Word):integer; overload;

Function LTR_GetCratesEx(var hsrv: TLTR; crates_max: LongWord; flags: LongWord;
                           out crates_found: LongWord;
                           out crates_returned : LongWord;
                           out csn: array of string;
                           out info_list : array of TLTR_CRATE_INFO):integer;

Function LTR_GetCrateDescr(var hsrv : TLTR; crate_iface : Integer; crate_sn : string; out descr : TLTR_CRATE_DESCR):integer;
Function LTR_GetCrateStatistic(var hsrv : TLTR; crate_iface : Integer; crate_sn : PAnsiChar; out stat : TLTR_CRATE_STATISTIC; size : Integer):integer;
Function LTR_GetModuleStatistic(var hsrv : TLTR; crate_iface : Integer; crate_sn : PAnsiChar; module_slot : integer; out stat : TLTR_MODULE_STATISTIC; size : Integer):integer;

Function LTR_GetCrateInfo(var ltr:TLTR; out CrateInfo:TLTR_CRATE_INFO):integer; overload;
Function LTR_Config(var ltr:TLTR; var conf : TLTR_CONFIG):integer; overload;
Function LTR_StartSecondMark(var ltr:TLTR; mode:en_LTR_MarkMode):integer; overload;
Function LTR_StopSecondMark(var ltr:TLTR):integer; overload;
Function LTR_MakeStartMark(var ltr:TLTR; mode:en_LTR_MarkMode):integer; overload;

Function LTR_AddIPCrate(var ltr: TLTR; ip_addr: LongWord; flags: LongWord; permanent:LongBool):integer; overload;
Function LTR_DeleteIPCrate(var ltr: TLTR; ip_addr: LongWord; permanent:LongBool):integer; overload;
Function LTR_ConnectIPCrate(var ltr: TLTR; ip_addr:LongWord):integer; overload;
Function LTR_DisconnectIPCrate(var ltr: TLTR; ip_addr:LongWord):integer; overload;
Function LTR_ConnectAllAutoIPCrates(var ltr: TLTR):integer; overload;
Function LTR_DisconnectAllIPCrates(var ltr: TLTR):integer; overload;
Function LTR_SetIPCrateFlags(var ltr: TLTR; ip_addr:LongWord; new_flags:LongWord; permanent:LongBool):integer; overload;

Function LTR_GetListOfIPCrates(var ltr: TLTR; ip_net : LongWord; ip_mask:LongWord;
                               out entries_found: LongWord;
                               out entries_returned: LongWord;
                               out info_array: array of TLTR_CRATE_IP_ENTRY):integer;

Function LTR_GetLogLevel(var ltr: TLTR; out level:integer):integer; overload;
Function LTR_SetLogLevel(var ltr: TLTR; level:integer;  permanent: LongBool):integer; overload;
Function LTR_ServerRestart(var ltr: TLTR):integer; overload;
Function LTR_ServerShutdown(var ltr: TLTR):integer; overload;
Function LTR_SetTimeout(var ltr: TLTR; ms:LongWord):integer; overload;
Function LTR_SetServerProcessPriority(var ltr: TLTR; Priority:LongWord):integer; overload;
Function LTR_GetServerProcessPriority(var ltr: TLTR; out Priority:LongWord):integer; overload;
Function LTR_GetServerVersion(var ltr: TLTR; out version:LongWord):integer; overload;
Function LTR_GetLastUnixTimeMark(var ltr: TLTR; out unixtime:UInt64):integer; overload;


Function LTR_CrateGetArray(var ltr: TLTR; address : LongWord; out buf: array of Byte; size : LongWord): Integer;
Function LTR_CratePutArray(var ltr: TLTR; address : LongWord; const buf: array of Byte; size : LongWord): Integer;








{$IFNDEF LTRAPI_DISABLE_COMPAT_DEFS}
// ������� ��� ����������� ����������
Function LTR__GenericCtlFunc(
        TLTR:Pointer;                       // ���������� LTR
        request_buf:Pointer;                // ����� � ��������
        request_size:LongWord;              // ����� ������� (� ������)
        reply_buf:Pointer;                  // ����� ��� ������ (��� NULL)
        reply_size:LongWord;                // ����� ������ (� ������)
        ack_error_code:integer;             // ����� ������, ���� ack �� GOOD (0 = �� ������������ ack)
        timeout:LongWord                   // �������, ��
    ):integer; {$I ltrapi_callconvention};

// ������� ������ ����������



Function LTR_Init(ltr:pTLTR):integer;  {$I ltrapi_callconvention}; overload;
Function LTR_Open(ltr:pTLTR):integer;  {$I ltrapi_callconvention}; overload;
Function LTR_Close(ltr:pTLTR):integer;  {$I ltrapi_callconvention}; overload;
Function LTR_IsOpened(ltr:pTLTR):integer;  {$I ltrapi_callconvention}; overload;
Function LTR_Recv(ltr:pTLTR; dataDWORD:Pointer; tmarkDWORD:POINTER; size:LongWord; timeout:LongWord):integer;  {$I ltrapi_callconvention};
Function LTR_Send(ltr:pTLTR; dataDWORD:Pointer; size:LongWord; timeout:LongWord):integer;  {$I ltrapi_callconvention};
Function LTR_GetCrates(ltr:pTLTR; csnBYTE:Pointer):integer;  {$I ltrapi_callconvention}; overload;
Function LTR_GetCrateModules(ltr:pTLTR; midWORD:Pointer):integer;  {$I ltrapi_callconvention}; overload;

Function LTR_GetCrateRawData(ltr:pTLTR; dataDWORD:Pointer; tmarkDWORD:Pointer; size:LongWord; timeout:LongWord):integer;  {$I ltrapi_callconvention};
Function LTR_GetErrorString(error:integer):string;
Function    LTR_GetCrateInfo(ltr:pTLTR; CrateInfoTCRATE_INFO:Pointer):integer; {$I ltrapi_callconvention}; overload;
Function    LTR_Config(ltr:pTLTR; confTLTR_CONFIG:Pointer):integer; {$I ltrapi_callconvention}; overload;
Function    LTR_StartSecondMark(ltr:pTLTR; mode:en_LTR_MarkMode):integer; {$I ltrapi_callconvention}; overload;
Function    LTR_StopSecondMark(ltr:pTLTR):integer; {$I ltrapi_callconvention};  overload;
Function    LTR_MakeStartMark(ltr:pTLTR; mode:en_LTR_MarkMode):integer; {$I ltrapi_callconvention}; overload;
Function    LTR_AddIPCrate(ltr:pTLTR; ip_addr:LongWord; flags:LongWord; permanent:LongBool):integer; {$I ltrapi_callconvention}; overload;
Function    LTR_DeleteIPCrate(ltr:pTLTR; ip_addr:LongWord; permanent:LongBool):integer; {$I ltrapi_callconvention}; overload;
Function    LTR_ConnectIPCrate(ltr:pTLTR; ip_addr:LongWord):integer; {$I ltrapi_callconvention}; overload;
Function    LTR_DisconnectIPCrate(ltr:pTLTR; ip_addr:LongWord):integer; {$I ltrapi_callconvention}; overload;
Function    LTR_ConnectAllAutoIPCrates(ltr:pTLTR):integer; {$I ltrapi_callconvention}; overload;
Function    LTR_DisconnectAllIPCrates(ltr:pTLTR):integer; {$I ltrapi_callconvention}; overload;
Function    LTR_SetIPCrateFlags(ltr:pTLTR; ip_addr:LongWord; new_flags:LongWord; permanent:LongBool):integer; {$I ltrapi_callconvention}; overload;
Function    LTR_GetLogLevel(ltr:pTLTR; levelINT:Pointer):integer; {$I ltrapi_callconvention}; overload;
Function    LTR_SetLogLevel(ltr:pTLTR; level:integer;  permanent:LongBool):integer; {$I ltrapi_callconvention}; overload;
Function    LTR_ServerRestart(ltr:pTLTR):integer; {$I ltrapi_callconvention}; overload;
Function    LTR_ServerShutdown(ltr:pTLTR):integer; {$I ltrapi_callconvention}; overload;
Function    LTR_SetTimeout(ltr:pTLTR; ms:LongWord):integer; {$I ltrapi_callconvention};  overload;
Function    LTR_SetServerProcessPriority(ltr:pTLTR; Priority:LongWord):integer;  {$I ltrapi_callconvention}; overload;
Function    LTR_GetServerProcessPriority(ltr:pTLTR; Priority:Pointer):integer; {$I ltrapi_callconvention};  overload;
Function    LTR_GetServerVersion(ltr:pTLTR; version:Pointer):integer; {$I ltrapi_callconvention};  overload;
Function    LTR_GetLastUnixTimeMark(ltr:pTLTR; unixtime:Pointer):integer;{$I ltrapi_callconvention};  overload;

Function    LTR_GetIPCrateDiscoveryMode(ltr:pTLTR; enabledBOOL:Pointer; autoconnectBOOL:Pointer):integer; {$I ltrapi_callconvention};
Function    LTR_SetIPCrateDiscoveryMode(ltr:pTLTR; enabled:LongBool; autoconnect:LongBool; permanent:LongBool):integer; {$I ltrapi_callconvention};
{$ENDIF}



Implementation
  Type t_crate_mids_array = array[0..MODULE_MAX-1] of Word;
  Type p_crate_mids_array = ^t_crate_mids_array;

  Type t_crate_info_array = array[0..0] of TLTR_CRATE_INFO;
  Type p_crate_info_array = ^t_crate_info_array;


{$IFNDEF LTRAPI_DISABLE_COMPAT_DEFS}
  Function LTR__GenericCtlFunc(TLTR:Pointer;request_buf:Pointer;request_size:LongWord;reply_buf:Pointer;reply_size:LongWord;ack_error_code:integer;timeout:LongWord):integer; {$I ltrapi_callconvention}; external 'ltrapi';
  Function LTR_Init(ltr:pTLTR):integer; {$I ltrapi_callconvention}; external 'ltrapi';
  Function LTR_Open(ltr:pTLTR):integer; {$I ltrapi_callconvention}; external 'ltrapi';
  Function LTR_Close(ltr:pTLTR):integer; {$I ltrapi_callconvention}; external 'ltrapi';
  Function LTR_IsOpened(ltr:pTLTR):integer; {$I ltrapi_callconvention};  external 'ltrapi';
  Function LTR_Recv(ltr:pTLTR; dataDWORD:Pointer; tmarkDWORD:POINTER; size:LongWord; timeout:LongWord):integer; {$I ltrapi_callconvention}; external 'ltrapi';
  Function LTR_Send(ltr:pTLTR; dataDWORD:Pointer; size:LongWord; timeout:LongWord):integer; {$I ltrapi_callconvention}; external 'ltrapi';
  Function LTR_GetCrates(ltr:pTLTR; csnBYTE:Pointer):integer; {$I ltrapi_callconvention}; external 'ltrapi';
  Function LTR_GetCrateModules(ltr:pTLTR; midWORD:Pointer):integer; {$I ltrapi_callconvention}; external 'ltrapi';
  Function LTR_SetServerProcessPriority(ltr:pTLTR; Priority:LongWord):integer; {$I ltrapi_callconvention}; external 'ltrapi';
  Function LTR_GetCrateRawData(ltr:pTLTR; dataDWORD:Pointer; tmarkDWORD:Pointer; size:LongWord; timeout:LongWord):integer; {$I ltrapi_callconvention}; external 'ltrapi';
  //Function LTR_GetErrorString(error:integer):string; external 'ltrapi';
  Function _get_err_str(err : integer) : PAnsiChar; {$I ltrapi_callconvention}; external 'ltrapi' name 'LTR_GetErrorString';

  Function LTR_GetCrateInfo(ltr:pTLTR; CrateInfoTCRATE_INFO:Pointer):integer; {$I ltrapi_callconvention}; external 'ltrapi';
  Function LTR_Config(ltr:pTLTR; confTLTR_CONFIG:Pointer):integer; {$I ltrapi_callconvention}; external 'ltrapi';
  Function LTR_StartSecondMark(ltr:pTLTR; mode:en_LTR_MarkMode):integer; {$I ltrapi_callconvention};  external 'ltrapi';
  Function LTR_StopSecondMark(ltr:pTLTR):integer; {$I ltrapi_callconvention}; external 'ltrapi';
  Function LTR_MakeStartMark(ltr:pTLTR; mode:en_LTR_MarkMode):integer; {$I ltrapi_callconvention}; external 'ltrapi';




  Function LTR_AddIPCrate(ltr:pTLTR; ip_addr:LongWord; flags:LongWord; permanent:LongBool):integer; {$I ltrapi_callconvention}; external 'ltrapi';
  Function LTR_DeleteIPCrate(ltr:pTLTR; ip_addr:LongWord; permanent:LongBool):integer; {$I ltrapi_callconvention}; external 'ltrapi';
  Function LTR_ConnectIPCrate(ltr:pTLTR; ip_addr:LongWord):integer; {$I ltrapi_callconvention}; external 'ltrapi';
  Function LTR_DisconnectIPCrate(ltr:pTLTR; ip_addr:LongWord):integer; {$I ltrapi_callconvention}; external 'ltrapi';
  Function LTR_ConnectAllAutoIPCrates(ltr:pTLTR):integer; {$I ltrapi_callconvention}; external 'ltrapi';
  Function LTR_DisconnectAllIPCrates(ltr:pTLTR):integer; {$I ltrapi_callconvention}; external 'ltrapi';
  Function LTR_SetIPCrateFlags(ltr:pTLTR; ip_addr:LongWord; new_flags:LongWord; permanent:LongBool):integer; {$I ltrapi_callconvention}; external 'ltrapi';
  Function LTR_GetIPCrateDiscoveryMode(ltr:pTLTR; enabledBOOL:Pointer; autoconnectBOOL:Pointer):integer; {$I ltrapi_callconvention}; external 'ltrapi';
  Function LTR_SetIPCrateDiscoveryMode(ltr:pTLTR; enabled:LongBool; autoconnect:LongBool; permanent:LongBool):integer; {$I ltrapi_callconvention}; external 'ltrapi';
  Function LTR_GetLogLevel(ltr:pTLTR; levelINT:Pointer):integer; {$I ltrapi_callconvention}; external 'ltrapi';
  Function LTR_SetLogLevel(ltr:pTLTR; level:integer;  permanent:LongBool):integer; {$I ltrapi_callconvention}; external 'ltrapi';
  Function LTR_ServerRestart(ltr:pTLTR):integer; {$I ltrapi_callconvention}; external 'ltrapi';
  Function LTR_ServerShutdown(ltr:pTLTR):integer; {$I ltrapi_callconvention}; external 'ltrapi';
  Function LTR_SetTimeout(ltr:pTLTR; ms:LongWord):integer; {$I ltrapi_callconvention}; external 'ltrapi';
  Function LTR_GetServerProcessPriority(ltr:pTLTR; Priority:Pointer):integer; {$I ltrapi_callconvention}; external 'ltrapi';
  Function LTR_GetServerVersion(ltr:pTLTR; version:Pointer):integer; {$I ltrapi_callconvention}; external 'ltrapi';
  Function LTR_GetLastUnixTimeMark(ltr:pTLTR; unixtime:Pointer):integer; {$I ltrapi_callconvention}; external 'ltrapi';
{$ENDIF}





  Function priv_Init(out ltr: TLTR):integer; {$I ltrapi_callconvention}; external 'ltrapi' name 'LTR_Init';
  Function priv_Open(var ltr: TLTR):integer; {$I ltrapi_callconvention}; external 'ltrapi' name 'LTR_Open';
  Function priv_OpenSvcControl(var ltr: TLTR; ltrd_addr : LongWord; ltrd_port : Word) : integer; {$I ltrapi_callconvention}; external 'ltrapi' name 'LTR_OpenSvcControl';
  Function priv_OpenCrate(var ltr: TLTR; ltrd_addr : LongWord; ltrd_port : Word; crate_iface : Integer; crate_snc: PAnsiChar): integer; {$I ltrapi_callconvention}; external 'ltrapi' name 'LTR_OpenCrate';
  Function priv_OpenEx(var ltr: TLTR; tout : LongWord):integer;{$I ltrapi_callconvention}; external 'ltrapi' name 'LTR_OpenEx';
  Function priv_Close(var ltr: TLTR):integer; {$I ltrapi_callconvention}; external 'ltrapi' name 'LTR_Close';
  Function priv_IsOpened(var ltr: TLTR):integer; {$I ltrapi_callconvention}; external 'ltrapi' name 'LTR_IsOpened';
  Function priv_GetCrates(var ltr: TLTR; csn: PAnsiChar): Integer; {$I ltrapi_callconvention}; external 'ltrapi' name 'LTR_GetCrates';
  Function priv_GetCrateModules(var ltr: TLTR; mids: p_crate_mids_array):integer;  {$I ltrapi_callconvention}; external 'ltrapi' name 'LTR_GetCrateModules';

  Function priv_GetCratesEx(var hsrv : TLTR; max_crates: LongWord; flags : LongWord; out crates_found: LongWord; out crates_returned : LongWord; csn: PAnsiChar; info_list: p_crate_info_array):integer;  {$I ltrapi_callconvention}; external 'ltrapi' name 'LTR_GetCratesEx';
  Function priv_GetCrateDescr(var hsrv : TLTR; crate_iface : Integer; crate_sn : PAnsiChar; out descr : TLTR_CRATE_DESCR; size : LongWord):integer;  {$I ltrapi_callconvention}; external 'ltrapi' name 'LTR_GetCrateDescr';
  Function priv_GetCrateStatistic(var hsrv : TLTR; crate_iface : Integer; crate_sn : PAnsiChar; out stat : TLTR_CRATE_STATISTIC; size : LongWord):integer;  {$I ltrapi_callconvention}; external 'ltrapi' name 'LTR_GetCrateStatistic';
  Function priv_GetModuleStatistic(var hsrv : TLTR; crate_iface : Integer; crate_sn : PAnsiChar; module_slot : integer; out stat : TLTR_MODULE_STATISTIC; size : LongWord):integer;  {$I ltrapi_callconvention}; external 'ltrapi' name 'LTR_GetModuleStatistic';


  Function priv_GetCrateInfo(var ltr:TLTR; out CrateInfo:TLTR_CRATE_INFO):integer; {$I ltrapi_callconvention}; external 'ltrapi' name 'LTR_GetCrateInfo';
  Function priv_Config(var ltr:TLTR; var conf : TLTR_CONFIG):integer; {$I ltrapi_callconvention}; external 'ltrapi' name 'LTR_Config';
  Function priv_StartSecondMark(var ltr:TLTR; mode:integer):integer; {$I ltrapi_callconvention}; external 'ltrapi' name 'LTR_StartSecondMark';
  Function priv_StopSecondMark(var ltr:TLTR):integer; {$I ltrapi_callconvention}; external 'ltrapi' name 'LTR_StopSecondMark';
  Function priv_MakeStartMark(var ltr:TLTR; mode:integer):integer; {$I ltrapi_callconvention};  external 'ltrapi' name 'LTR_MakeStartMark';

  Function priv_GetListOfIPCrates(var ltr: TLTR; max_entries:LongWord; ip_net:LongWord; ip_mask:LongWord; out entries_found:LongWord; out entries_returned:LongWord; info_array:p_crate_ipentry_array):integer;{$I ltrapi_callconvention}; external 'ltrapi' name 'LTR_GetListOfIPCrates';
  Function priv_AddIPCrate(var ltr: TLTR; ip_addr: LongWord; flags: LongWord; permanent:LongBool):integer; {$I ltrapi_callconvention}; external 'ltrapi' name 'LTR_AddIPCrate';
  Function priv_DeleteIPCrate(var ltr: TLTR; ip_addr: LongWord; permanent:LongBool):integer; {$I ltrapi_callconvention}; external 'ltrapi' name 'LTR_DeleteIPCrate';
  Function priv_ConnectIPCrate(var ltr: TLTR; ip_addr:LongWord):integer; {$I ltrapi_callconvention}; external 'ltrapi' name 'LTR_ConnectIPCrate';
  Function priv_DisconnectIPCrate(var ltr: TLTR; ip_addr:LongWord):integer; {$I ltrapi_callconvention}; external 'ltrapi' name 'LTR_DisconnectIPCrate';
  Function priv_ConnectAllAutoIPCrates(var ltr: TLTR):integer; {$I ltrapi_callconvention}; external 'ltrapi' name 'LTR_ConnectAllAutoIPCrates';
  Function priv_DisconnectAllIPCrates(var ltr: TLTR):integer; {$I ltrapi_callconvention}; external 'ltrapi' name 'LTR_DisconnectAllIPCrates';
  Function priv_SetIPCrateFlags(var ltr: TLTR; ip_addr:LongWord; new_flags:LongWord; permanent:LongBool):integer; {$I ltrapi_callconvention}; external 'ltrapi' name 'LTR_SetIPCrateFlags';


  Function priv_ResetModule(var hsrv : TLTR; crate_iface : integer; crate_sn : PAnsiChar; module_slot : integer; flags : LongWord):integer; {$I ltrapi_callconvention}; external 'ltrapi' name 'LTR_ResetModule';
  Function priv_GetLogLevel(var ltr: TLTR; out level:integer):integer; {$I ltrapi_callconvention}; external 'ltrapi' name 'LTR_GetLogLevel';
  Function priv_SetLogLevel(var ltr: TLTR; level:integer;  permanent: LongBool):integer; {$I ltrapi_callconvention}; external 'ltrapi' name 'LTR_SetLogLevel';

  Function priv_ServerRestart(var ltr: TLTR):integer; {$I ltrapi_callconvention}; external 'ltrapi' name 'LTR_ServerRestart';
  Function priv_ServerShutdown(var ltr: TLTR):integer; {$I ltrapi_callconvention}; external 'ltrapi' name 'LTR_ServerShutdown';
  Function priv_SetTimeout(var ltr: TLTR; ms:LongWord):integer; {$I ltrapi_callconvention};  external 'ltrapi' name 'LTR_SetTimeout';
  Function priv_SetServerProcessPriority(var ltr: TLTR; Priority:LongWord):integer;  {$I ltrapi_callconvention}; external 'ltrapi' name 'LTR_SetServerProcessPriority';
  Function priv_GetServerProcessPriority(var ltr: TLTR; out Priority:LongWord):integer; {$I ltrapi_callconvention};  external 'ltrapi' name 'LTR_GetServerProcessPriority';
  Function priv_GetServerVersion(var ltr: TLTR; out version:LongWord):integer; {$I ltrapi_callconvention};  external 'ltrapi' name 'LTR_GetServerVersion';
  Function priv_GetLastUnixTimeMark(var ltr: TLTR; out unixtime:UInt64):integer;{$I ltrapi_callconvention};  external 'ltrapi' name 'LTR_GetLastUnixTimeMark';

  Function priv_CrateGetArray(var ltr: TLTR; address : LongWord; out buf; size : LongWord): Integer; {$I ltrapi_callconvention}; external 'ltrapi' name 'LTR_CrateGetArray';
  Function priv_CratePutArray(var ltr: TLTR; address : LongWord; const buf; size : LongWord): Integer; {$I ltrapi_callconvention}; external 'ltrapi' name 'LTR_CratePutArray';


  Procedure LTR_FillSerial(var ltr: TLTR; csn : string);
  var
    i: Integer;
  begin
     for i:=0 to SERIAL_NUMBER_SIZE-1 do     //������������� �������� ����� ������
     begin
       if i < Length(csn) then
       begin
          ltr.csn[i] := AnsiChar(csn[i+1]);
       end
       else
       begin
          ltr.csn[i] := AnsiChar(0);
       end;
     end;
  end;



  Function LTR_Init(out ltr: TLTR):integer; overload;
  begin
    LTR_Init := priv_Init(ltr);
  end;

  Function LTR_Open(var ltr: TLTR):integer; overload;
  begin
    LTR_Open := priv_Open(ltr);
  end;

  Function LTR_OpenSvcControl(var ltr: TLTR; ltrd_addr : LongWord; ltrd_port : Word): integer;
  begin
    LTR_OpenSvcControl := priv_OpenSvcControl(ltr, ltrd_addr, ltrd_port);
  end;
  Function LTR_OpenCrate(var ltr: TLTR; ltrd_addr : LongWord; ltrd_port : Word; crate_iface: Integer; crate_sn: string): integer;
  begin
    LTR_OpenCrate := priv_OpenCrate(ltr, ltrd_addr, ltrd_port, crate_iface, PAnsiChar(AnsiString(crate_sn)));
  end;
  Function LTR_OpenEx(var ltr: TLTR; tout : LongWord):integer;
  begin
    LTR_OpenEx:=priv_OpenEx(ltr, tout);
  end;


  Function LTR_Close(var ltr: TLTR):integer; overload;
  begin
    LTR_Close := priv_Close(ltr);
  end;

  Function LTR_IsOpened(var ltr: TLTR):integer; overload;
  begin
    LTR_IsOpened := priv_IsOpened(ltr);
  end;

  Function LTR_GetCrates(var ltr: TLTR; var csn: array of string; out crates_cnt: Integer):integer;
  var
    serial_array: PAnsiChar;
    res,i: Integer;
  begin
    crates_cnt:=0;
    serial_array:=GetMemory(CRATE_MAX*SERIAL_NUMBER_SIZE);
    res:= priv_GetCrates(ltr, serial_array);
    if res = LTR_OK then
    begin
        for i:=0 to CRATE_MAX-1 do
        begin
            if (serial_array[SERIAL_NUMBER_SIZE*i]<> AnsiChar(0)) then   //��������� � ������ ��� �������� ���������
            begin
                if Length(csn) > crates_cnt then
                begin
                  csn[crates_cnt] := string(StrPas(PAnsiChar(@serial_array[SERIAL_NUMBER_SIZE*i])));
                end;
                crates_cnt:=crates_cnt+1;
            end;
        end;
    end;
    FreeMemory(serial_array);
    LTR_GetCrates := res;
  end;

  Function LTR_GetCrateModules(var ltr: TLTR; var mids: array of Word):integer; overload;
  var
    mid_array: p_crate_mids_array;
    res,i: Integer;
  begin
    mid_array:=GetMemory(MODULE_MAX*2);
    res:= priv_GetCrateModules(ltr, mid_array);
    if res = LTR_OK then
    begin
        for i:=0 to Length(mids)-1 do
        begin
            if (i < MODULE_MAX) then   //��������� � ������ ��� �������� ���������
            begin
                mids[i]:=mid_array^[i];
            end
            else
            begin
                mids[i]:=MID_EMPTY;
            end;
        end;
    end;
    FreeMemory(mid_array);
    LTR_GetCrateModules := res;
  end;

  Function LTR_GetCratesEx(var hsrv: TLTR; crates_max: LongWord; flags: LongWord;
                           out crates_found: LongWord;
                           out crates_returned : LongWord;
                           out csn: array of string;
                           out info_list : array of TLTR_CRATE_INFO):integer;
  var
    info_arr: p_crate_info_array;
    serial_array: PAnsiChar;
    res, i: Integer;
  begin

    if crates_max > 0 then
    begin
      if Length(info_list) >= crates_max then
         info_arr:=GetMemory(crates_max*SizeOf(TLTR_CRATE_INFO))
      else
         info_arr:=nil;

      serial_array:=GetMemory(crates_max*SERIAL_NUMBER_SIZE);
      res:= priv_GetCratesEx(hsrv, crates_max, flags, crates_found, crates_returned,
                             serial_array, info_arr);
      if res = LTR_OK then
      begin
        for i:=0 to crates_returned-1 do
        begin
          if i < Length(csn) then
             csn[i] := string(StrPas(PAnsiChar(@serial_array[SERIAL_NUMBER_SIZE*i])));
          if i < Length(info_list) then
              info_list[i] := info_arr^[i];
        end;
      end;
      FreeMemory(info_arr);
      FreeMemory(serial_array);
    end
    else
    begin
      res:=priv_GetCratesEx(hsrv, 0, flags, crates_found, crates_returned, nil, nil);
    end;

    LTR_GetCratesEx:=res;
  end;

  Function LTR_GetCrateDescr(var hsrv : TLTR; crate_iface : Integer; crate_sn : string; out descr : TLTR_CRATE_DESCR):integer;
  begin
    LTR_GetCrateDescr:=priv_GetCrateDescr(hsrv, crate_iface, PAnsiChar(AnsiString(crate_sn)), descr, sizeof(TLTR_CRATE_DESCR));
  end;
  Function LTR_GetCrateStatistic(var hsrv : TLTR; crate_iface : Integer; crate_sn : PAnsiChar; out stat : TLTR_CRATE_STATISTIC; size : Integer):integer;
  begin
    LTR_GetCrateStatistic:=priv_GetCrateStatistic(hsrv, crate_iface, PAnsiChar(AnsiString(crate_sn)), stat, sizeof(TLTR_CRATE_STATISTIC));
  end;
  Function LTR_GetModuleStatistic(var hsrv : TLTR; crate_iface : Integer; crate_sn : PAnsiChar; module_slot : integer; out stat : TLTR_MODULE_STATISTIC; size : Integer):integer;
  begin
    LTR_GetModuleStatistic:=priv_GetModuleStatistic(hsrv, crate_iface, PAnsiChar(AnsiString(crate_sn)), module_slot, stat, sizeof(TLTR_MODULE_STATISTIC));
  end;

  Function LTR_GetCrateInfo(var ltr:TLTR; out CrateInfo:TLTR_CRATE_INFO):integer; overload;
  begin
    LTR_GetCrateInfo := priv_GetCrateInfo(ltr, Crateinfo);
  end;

  Function LTR_Config(var ltr:TLTR; var conf : TLTR_CONFIG):integer; overload;
  begin
    LTR_Config := priv_Config(ltr, conf);
  end;

  Function LTR_StartSecondMark(var ltr:TLTR; mode:en_LTR_MarkMode):integer; overload;
  begin
    LTR_StartSecondMark := priv_StartSecondMark(ltr, integer(mode));
  end;

  Function LTR_StopSecondMark(var ltr:TLTR):integer; overload;
  begin
    LTR_StopSecondMark := priv_StopSecondMark(ltr);
  end;

  Function LTR_MakeStartMark(var ltr:TLTR; mode:en_LTR_MarkMode):integer; overload;
  begin
    LTR_MakeStartMark := priv_MakeStartMark(ltr, integer(mode));
  end;



  Function LTR_GetListOfIPCrates(var ltr: TLTR; ip_net : LongWord; ip_mask:LongWord;
                                 out entries_found: LongWord;
                                 out entries_returned: LongWord;
                                 out info_array: array of TLTR_CRATE_IP_ENTRY):integer;
  var
    ip_arr: p_crate_ipentry_array;
    res, i: Integer;
  begin
    if Length(info_array) > 0 then
    begin
      ip_arr:=GetMemory(Length(info_array)*SizeOf(TLTR_CRATE_IP_ENTRY));
      res:= priv_GetListOfIPCrates(ltr, Length(info_array),  ip_net, ip_mask,
                                  entries_found, entries_returned, ip_arr);
      if res = LTR_OK then
      begin
        for i:=0 to entries_returned-1 do
          info_array[i] := ip_arr^[i];
      end;
      FreeMemory(ip_arr);
    end
    else
    begin
      res:=priv_GetListOfIPCrates(ltr, 0,  ip_net, ip_mask, entries_found,
                                  entries_returned, nil);
    end;

    LTR_GetListOfIPCrates:=res;
  end;


  Function LTR_AddIPCrate(var ltr: TLTR; ip_addr: LongWord; flags: LongWord; permanent:LongBool):integer; overload;
  begin
    LTR_AddIPCrate:=priv_AddIPCrate(ltr, ip_addr, flags, permanent);
  end;
  Function LTR_DeleteIPCrate(var ltr: TLTR; ip_addr: LongWord; permanent:LongBool):integer; overload;
  begin
    LTR_DeleteIPCrate:=priv_DeleteIPCrate(ltr, ip_addr, permanent);
  end;
  Function LTR_ConnectIPCrate(var ltr: TLTR; ip_addr:LongWord):integer; overload;
  begin
    LTR_ConnectIPCrate:=priv_ConnectIPCrate(ltr, ip_addr);
  end;
  Function LTR_DisconnectIPCrate(var ltr: TLTR; ip_addr:LongWord):integer; overload;
  begin
    LTR_DisconnectIPCrate:=priv_DisconnectIPCrate(ltr, ip_addr);
  end;
  Function LTR_ConnectAllAutoIPCrates(var ltr: TLTR):integer; overload;
  begin
    LTR_ConnectAllAutoIPCrates:=priv_ConnectAllAutoIPCrates(ltr);
  end;
  Function LTR_DisconnectAllIPCrates(var ltr: TLTR):integer; overload;
  begin
    LTR_DisconnectAllIPCrates:=priv_DisconnectAllIPCrates(ltr);
  end;
  Function LTR_SetIPCrateFlags(var ltr: TLTR; ip_addr:LongWord; new_flags:LongWord; permanent:LongBool):integer; overload;
  begin
    LTR_SetIPCrateFlags:=priv_SetIPCrateFlags(ltr, ip_addr, new_flags, permanent);
  end;

  Function LTR_ResetModule(var hsrv : TLTR; crate_iface : integer; crate_sn : string; module_slot : integer; flags : LongWord):integer;
  begin
    LTR_ResetModule:=priv_ResetModule(hsrv, crate_iface, PAnsiChar(AnsiString(crate_sn)), module_slot, flags);
  end;


  Function LTR_GetLogLevel(var ltr: TLTR; out level:integer):integer; overload;
  begin
    LTR_GetLogLevel:=priv_GetLogLevel(ltr, level);
  end;
  Function LTR_SetLogLevel(var ltr: TLTR; level:integer;  permanent: LongBool):integer; overload;
  begin
    LTR_SetLogLevel:=priv_SetLogLevel(ltr, level, permanent);
  end;
  Function LTR_ServerRestart(var ltr: TLTR):integer; overload;
  begin
    LTR_ServerRestart:=priv_ServerRestart(ltr);
  end;
  Function LTR_ServerShutdown(var ltr: TLTR):integer; overload;
  begin
    LTR_ServerShutdown:=priv_ServerShutdown(ltr);
  end;
  Function LTR_SetTimeout(var ltr: TLTR; ms:LongWord):integer; overload;
  begin
    LTR_SetTimeout:=priv_SetTimeout(ltr, ms);
  end;
  Function LTR_SetServerProcessPriority(var ltr: TLTR; Priority:LongWord):integer; overload;
  begin
    LTR_SetServerProcessPriority:=priv_SetServerProcessPriority(ltr, priority);
  end;
  Function LTR_GetServerProcessPriority(var ltr: TLTR; out Priority:LongWord):integer; overload;
  begin
    LTR_GetServerProcessPriority:=priv_GetServerProcessPriority(ltr, priority);
  end;
  Function LTR_GetServerVersion(var ltr: TLTR; out version:LongWord):integer; overload;
  begin
    LTR_GetServerVersion:=priv_GetServerVersion(ltr, version);
  end;
  Function LTR_GetLastUnixTimeMark(var ltr: TLTR; out unixtime:UInt64):integer; overload;
  begin
    LTR_GetLastUnixTimeMark:=priv_GetLastUnixTimeMark(ltr, unixtime);
  end;

  Function LTR_GetErrorString(error:integer):string;
  begin
    LTR_GetErrorString:= string(_get_err_str(error));
  end;

  Function LTR_CrateGetArray(var ltr: TLTR; address : LongWord; out buf: array of Byte; size : LongWord): Integer;
  begin
     LTR_CrateGetArray := priv_CrateGetArray(ltr, address, buf, size);
  end;

  Function LTR_CratePutArray(var ltr: TLTR; address : LongWord; const buf: array of Byte; size : LongWord): Integer;
  begin
    LTR_CratePutArray := priv_CratePutArray(ltr, address, buf, size);
  end;

end.


