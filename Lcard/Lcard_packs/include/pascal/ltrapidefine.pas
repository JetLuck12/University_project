unit ltrapidefine;
interface
uses windows, SysUtils;

const
// ������� �����-����������� $
LTR010CMD          =       ($8000);
LTR010CMD_STOP     =       (LTR010CMD or $00);
LTR010CMD_PROGR    =       (LTR010CMD or $40);
LTR010CMD_RESET    =       (LTR010CMD or $80);
LTR010CMD_INSTR    =       (LTR010CMD or $C0);
LTR010_SLOT_MASK   =       ($F shl 8);
//
SIGNAL_RBUF_OVF    =       ($FFFFFFF0);  // ������� ������ -> ������ : ������������ ������  �������
SIGNAL_TSTAMP      =       ($FFFFFFF1);  // ������� ������ -> ������ : ����� �������
//
SADDR_LOCAL        =       ((127 shl 24)or(0 shl 16)or(0 shl 8)or(1 shl 0));
SADDR_DEFAULT      =       (SADDR_LOCAL);
SPORT_DEFAULT      =       (11111);
// ���� ������� ������-������
CC_CONTROL         =        0 ;           // ����� ��� ������ c ������� � ����� 0, �� ��
CC_MODULE1         =        1 ;           // ����� ��� ������ c ������� � ����� 1
CC_MODULE2         =        2 ;           // ����� ��� ������ c ������� � ����� 2
CC_MODULE3         =        3 ;           // ����� ��� ������ c ������� � ����� 3
CC_MODULE4         =        4 ;           // ����� ��� ������ c ������� � ����� 4
CC_MODULE5         =        5 ;           // ����� ��� ������ c ������� � ����� 5
CC_MODULE6         =        6 ;           // ����� ��� ������ c ������� � ����� 6
CC_MODULE7         =        7 ;           // ����� ��� ������ c ������� � ����� 7
CC_MODULE8         =        8 ;           // ����� ��� ������ c ������� � ����� 8
CC_MODULE9         =        9 ;           // ����� ��� ������ c ������� � ����� 9
CC_MODULE10        =       10 ;           // ����� ��� ������ c ������� � ����� 10
CC_MODULE11        =       11 ;           // ����� ��� ������ c ������� � ����� 11
CC_MODULE12        =       12 ;           // ����� ��� ������ c ������� � ����� 12
CC_MODULE13        =       13 ;           // ����� ��� ������ c ������� � ����� 13
CC_MODULE14        =       14 ;           // ����� ��� ������ c ������� � ����� 14
CC_MODULE15        =       15 ;           // ����� ��� ������ c ������� � ����� 15
CC_MODULE16        =       16 ;           // ����� ��� ������ c ������� � ����� 16
CC_DEBUG_FLAG      =       $8000 ;       // ���� ������� - ������ ���������� � ����� �
                                                // ��� ���� � ������� ��� �������� �� �������.
                                                // �.�. �� ���������� ������������� ������ ������.
CC_RAW_DATA_FLAG   =       $4000 ;       // ���� ������� - ����� �������� � ��� �����������
                                            	// ������� �������� �� USB ��� �������� �� �������
CRATE_MAX          =       16    ;       // ������������ ����� ������� ������������� ����� ��������
MODULE_MAX         =       16    ;       // ������������ ����� ������� � ����� ������
FLAG_RBUF_OVF      =       (1 shl 0) ;   // ���� ������������ ������ �������
FLAG_RFULL_DATA    =       (1 shl 1) ;   // ���� ��������� ������ � ������ ������� � ������� LTR_GetCrateRawData
FLAG_SIGNAL_TSTAMP =       (1 shl 8) ;   // ���� ������� ������� SIGNAL_TSTAMP
// �������������� �������
MID_EMPTY          =       0      ;       // ������������� ���������������
MID_LTR11          =       $0B0B ;       // ������������� ������ LTR11
MID_LTR22          =       $1616 ;       // ������������� ������ LTR22
MID_LTR27          =       $1B1B ;       // ������������� ������ LTR27
MID_LTR34          =       $2222 ;       // ������������� ������ LTR34
MID_LTR41          =       $2929 ;       // ������������� ������ LTR41
MID_LTR42          =       $2A2A ;       // ������������� ������ LTR42
MID_LTR43          =       $2B2B ;       // ������������� ������ LTR43
MID_LTR51          =       $3333 ;       // ������������� ������ LTR51
MID_LTR114         =       $7272 ;       // ������������� ������ LTR114
MID_LTR212         =       $D4D4 ;       // ������������� ������ LTR212

// ��������� �������� ����� ������ ��� ���������� ����� ��������
// (�������� � �����, ����� ���� ��� �� ������ ������������� ������
// �������, ������� ���������� �� ���� �����, �������� "//SERVER_CONTROL"
CSN_SERVER_CONTROL   =  '#SERVER_CONTROL';


// ������� ������-������
CONTROL_COMMAND_SIZE                        =8;
CONTROL_COMMAND_START                       =$FFFFFFFF;
CONTROL_COMMAND_BASE_MASK_                  =$FFFFFF00;
CONTROL_COMMAND_BASE_                       =$ABCDEF00;

CONTROL_COMMAND_INIT_CONNECTION             =(CONTROL_COMMAND_BASE_ + $00);
CONTROL_COMMAND_SET_SERVER_PROCESS_PRIORITY =(CONTROL_COMMAND_BASE_ + $01); //SERVER_CONTROL
CONTROL_COMMAND_GET_CRATE_TYPE              =(CONTROL_COMMAND_BASE_ + $02);
CONTROL_COMMAND_GET_SERVER_PROCESS_PRIORITY =(CONTROL_COMMAND_BASE_ + $03); //SERVER_CONTROL
CONTROL_COMMAND_PUT_ARRAY                   =(CONTROL_COMMAND_BASE_ + $80);
CONTROL_COMMAND_GET_ARRAY                   =(CONTROL_COMMAND_BASE_ + $81);
CONTROL_COMMAND_GET_DESCRIPTION             =(CONTROL_COMMAND_BASE_ + $82);
CONTROL_COMMAND_BOOT_LOADER_GET_DESCRIPTION =(CONTROL_COMMAND_BASE_ + $83);
CONTROL_COMMAND_BOOT_LOADER_SET_DESCRIPTION =(CONTROL_COMMAND_BASE_ + $84);
CONTROL_COMMAND_GET_CRATES                  =(CONTROL_COMMAND_BASE_ + $87); //SERVER_CONTROL
CONTROL_COMMAND_GET_MODULES                 =(CONTROL_COMMAND_BASE_ + $88);
CONTROL_COMMAND_GET_CRATE_RAW_DATA          =(CONTROL_COMMAND_BASE_ + $89);
CONTROL_COMMAND_GET_CRATE_RAW_DATA_SIZE     =(CONTROL_COMMAND_BASE_ + $8A);
CONTROL_COMMAND_LOAD_FPGA                   =(CONTROL_COMMAND_BASE_ + $8B);
CONTROL_COMMAND_IP_GET_LIST                 =(CONTROL_COMMAND_BASE_ + $91); //SERVER_CONTROL
CONTROL_COMMAND_IP_ADD_LIST_ENTRY           =(CONTROL_COMMAND_BASE_ + $92); //SERVER_CONTROL
CONTROL_COMMAND_IP_DELETE_LIST_ENTRY        =(CONTROL_COMMAND_BASE_ + $93); //SERVER_CONTROL
CONTROL_COMMAND_IP_CONNECT                  =(CONTROL_COMMAND_BASE_ + $94); //SERVER_CONTROL
CONTROL_COMMAND_IP_DISCONNECT               =(CONTROL_COMMAND_BASE_ + $95); //SERVER_CONTROL
CONTROL_COMMAND_IP_CONNECT_ALL_AUTO         =(CONTROL_COMMAND_BASE_ + $96); //SERVER_CONTROL
CONTROL_COMMAND_IP_DISCONNECT_ALL           =(CONTROL_COMMAND_BASE_ + $97); //SERVER_CONTROL
CONTROL_COMMAND_IP_SET_FLAGS                =(CONTROL_COMMAND_BASE_ + $98); //SERVER_CONTROL
CONTROL_COMMAND_IP_GET_DISCOVERY_MODE       =(CONTROL_COMMAND_BASE_ + $99); //SERVER_CONTROL
CONTROL_COMMAND_IP_SET_DISCOVERY_MODE       =(CONTROL_COMMAND_BASE_ + $9A); //SERVER_CONTROL
CONTROL_COMMAND_GET_LOG_LEVEL               =(CONTROL_COMMAND_BASE_ + $F0); //SERVER_CONTROL
CONTROL_COMMAND_SET_LOG_LEVEL               =(CONTROL_COMMAND_BASE_ + $F1); //SERVER_CONTROL
CONTROL_COMMAND_RESTART_SERVER              =(CONTROL_COMMAND_BASE_ + $F2); //SERVER_CONTROL
CONTROL_COMMAND_SHUTDOWN_SERVER             =(CONTROL_COMMAND_BASE_ + $F3); //SERVER_CONTROL
CONTROL_COMMAND_BOOT_LOADER_PUT_ARRAY       =(CONTROL_COMMAND_BASE_ + $FD);
CONTROL_COMMAND_BOOT_LOADER_GET_ARRAY       =(CONTROL_COMMAND_BASE_ + $FE);
CONTROL_COMMAND_CALL_APPLICATION            =(CONTROL_COMMAND_BASE_ + $FF);
//CONTROL_COMMAND_START_ALL_CRATE_MODULES     (CONTROL_COMMAND_BASE_ + $90);

// ������� �� ������� �������
CONTROL_ACKNOWLEDGE_SIZE                    =4;
CONTROL_ACKNOWLEDGE_MODULE_IN_USE           =$ABCDEFDD;
CONTROL_ACKNOWLEDGE_GOOD                    =$ABCDEFEE;
CONTROL_ACKNOWLEDGE_BAD                     =$ABCDEFFF;

// �������� ������ (��� TCRATE_INFO)
CRATE_TYPE_UNKNOWN                      =0;
CRATE_TYPE_LTR010                       =10;
CRATE_TYPE_LTR021                       =21;
CRATE_TYPE_LTR030                       =30;
CRATE_TYPE_LTR031                       =31;
CRATE_TYPE_BOOTLOADER                   =99;

// ��������� ������ (��� TCRATE_INFO)
CRATE_IFACE_UNKNOWN                     =0;
CRATE_IFACE_USB                         =1;
CRATE_IFACE_TCPIP                       =2;

// ��������� ������ (��� TIPCRATE_ENTRY)
CRATE_IP_STATUS_OFFLINE                 =0;
CRATE_IP_STATUS_CONNECTING              =1;
CRATE_IP_STATUS_ONLINE                  =2;
CRATE_IP_STATUS_ERROR                   =3;

// ����� ���������� ������ (��� TIPCRATE_ENTRY � ������� CONTROL_COMMAND_IP_SET_FLAGS)
CRATE_IP_FLAG_AUTOCONNECT               =$00000001;
CRATE_IP_FLAG__VALID_BITS_              =$00000001;


// ������������� ��������� ������������ LTR010
SEL_AVR_DM                              =$82000000;
SEL_AVR_PM                              =$83000000;
SEL_DMA_TEST_FLAG                       =$84000000;
SEL_FLASH_BUFFER                        =$85000000;
SEL_FPGA_DATA                           =$86000000;
SEL_FPGA_FLAGS                          =$87000000;
SEL_FLASH_DSP                           =$88000000;
SEL_FLASH_STATUS                        =$89000000;
SEL_SDRAM	                              =$8A000000;
SEL_SRAM	                              =$8B000000;
SEL_DSP                                 =$90000000;
SEL_DSP_SPI                             =$91000000;
SEL_DSP_SPI_BOOT                        =$92000000;
SEL_DSP_MEM                             =$93000000;



//
LTR010_FIRMWARE_SIZE                    =$3000;
LTR010_BOOT_LOADER_SIZE                 =$1000;
LTR010_FIRMWARE_VERSION_ADDRESS         =SEL_AVR_PM + $2FF0;
LTR010_BOOT_LOADER_VERSION_ADDRESS      =SEL_AVR_PM + $3FF0;
LTR010_MODULE_DESCRIPTOR_ADDRESS        =SEL_AVR_PM + $3000;
LTR010_FIRMWARE_START_ADDRESS           =SEL_AVR_PM + $0000;
LTR010_BOOT_LOADER_START_ADDRESS        =SEL_AVR_PM + $3C00;
//
EP1K100_SIZE                            =164*1024+100;
EP1K50_SIZE                             = 96*1024+100;
EP1K30_SIZE                             = 58*1024+100;
EP1K10_SIZE                             = 22*1024+100;
FPGA_INFO_SIZE                          =250;
NAME_SIZE                               =16;
SERIAL_NUMBER_SIZE                      =16;
implementation
end.
