unit ltr11api;
interface
uses windows, SysUtils, ltrapi, ltrapitypes;
const
               LTR11_CLOCK                  =15000; // �������� ������� ������ � ��� */
               LTR11_MAX_CHANNEL            =32;    // ������������ ����� ���������� ������� */
               LTR11_MAX_LCHANNEL           =128;   // ������������ ����� ���������� ������� */
               LTR11_ADC_RANGEQNT           =4;     // ���������� ������� ���������� ��� */
// ���� ������, ������������ ��������� ���������� */
               LTR11_ERR_INVALID_DESCR        =-1000; // ��������� �� ��������� ������ ����� NULL */
               LTR11_ERR_INVALID_ADCMODE      =-1001; // ������������ ����� ������� ��� */
               LTR11_ERR_INVALID_ADCLCHQNT    =-1002; // ������������ ���������� ���������� ������� */
               LTR11_ERR_INVALID_ADCRATE      =-1003; // ������������ �������� ������� ������������� ��� ������*/
               LTR11_ERR_INVALID_ADCSTROBE    =-1004; // ������������ �������� �������� ������� ��� ��� */
               LTR11_ERR_GETFRAME             =-1005; // ������ ��������� ����� ������ � ��� */
               LTR11_ERR_GETCFG               =-1006; // ������ ������ ������������ */
               LTR11_ERR_CFGDATA              =-1007; // ������ ��� ��������� ������������ ������ */
               LTR11_ERR_CFGSIGNATURE         =-1008; // �������� �������� ������� ����� ���������������� ������ ������ */
               LTR11_ERR_CFGCRC               =-1009; // �������� ����������� ����� ���������������� ������*/
               LTR11_ERR_INVALID_ARRPOINTER   =-1010; // ��������� �� ������ ����� NULL */
               LTR11_ERR_ADCDATA_CHNUM        =-1011; // �������� ����� ������ � ������� ������ �� ��� */
               LTR11_ERR_INVALID_CRATESN      =-1012; // ��������� �� ������ � �������� ������� ������ ����� NULL*/
               LTR11_ERR_INVALID_SLOTNUM      =-1013; // ������������ ����� ����� � ������ */
               LTR11_ERR_NOACK                =-1014; // ��� ������������� �� ������ */
               LTR11_ERR_MODULEID             =-1015; // ������� �������� ������, ��������� �� LTR11 */
               LTR11_ERR_INVALIDACK           =-1016; // �������� ������������� �� ������ */
               LTR11_ERR_ADCDATA_SLOTNUM      =-1017; // �������� ����� ����� � ������ �� ��� */
               LTR11_ERR_ADCDATA_CNT          =-1018; // �������� ������� ������� � ������ �� ��� */
               LTR11_ERR_INVALID_STARTADCMODE =-1019; // �������� ����� ������ ����� ������ */
// ������ ������� ��� */
               LTR11_ADCMODE_ACQ            =$00;  // ���� ������ */
               LTR11_ADCMODE_TEST_U1P       =$04;  // ������ ��������� ���������� +U1 */
               LTR11_ADCMODE_TEST_U1N       =$05;  // ������ ��������� ���������� -U1 */
               LTR11_ADCMODE_TEST_U2N       =$06;  // ������ ��������� ���������� -U2 */
               LTR11_ADCMODE_TEST_U2P       =$07;  // ������ ��������� ���������� +U2 */
// ����� ������ ����� ������ ������� */
               LTR11_STARTADCMODE_INT       =0;     // ���������� ����� =�� ������� �����; */
               LTR11_STARTADCMODE_EXTRISE   =1;     // �� ������ �������� �������; */
               LTR11_STARTADCMODE_EXTFALL   =2;     // �� ����� �������� �������. */
// �������� ������������ ��� */
               LTR11_INPMODE_EXTRISE        =0;     // ������ �������������� �� ������ �������� ������� */
               LTR11_INPMODE_EXTFALL        =1;     // ������ �������������� �� ����� �������� ������� */
               LTR11_INPMODE_INT            =2;     // ���������� ������ ��� */
// ������� �������� ������� */
               LTR11_CHGANE_10000MV         =0;     // +-10 � (10000 ��) */
               LTR11_CHGANE_2500MV          =1;     // +-2.5 � (2500 ��) */
               LTR11_CHGANE_625MV           =2;     // +-0.625 � (625 ��) */
               LTR11_CHGANE_156MV           =3;     // +-0.156 � (156 ��) */
// ������ ������ ������� */
               LTR11_CHMODE_16CH            =0;     // 16-��������� */
               LTR11_CHMODE_32CH            =1;     // 32-��������� */

//#ifdef LTR11API_EXPORTS
//  #define LTR11API_DllExport(type) __declspec(dllexport) type APIENTRY
//#else
//  #define LTR11API_DllExport(type) __declspec(dllimport) type APIENTRY
//#endif

//================================================================================================*/
type

   LTR11_GainSet=packed record
        Offset:real;                      // �������� ���� */
        Gain  :real;                      // ���������� ����������� */
   end;
   TINFO_LTR11=packed record              // ���������� � ������ */
        Name  :array[0..15]of char;         // �������� ������ (������) */
        Serial:array[0..23]of char;         // �������� ����� ������ (������) */
        Ver   :word;                        // ������ �� ������ (������� ���� - ��������,������� - ��������
        Date:array[0..13]of char;           // ���� �������� �� (������) */
        CbrCoef:array[0..LTR11_ADC_RANGEQNT-1]of LTR11_GainSet ;      // ������������� ������������ ��� ������� ��������� */
    end;


        ADC_SET=packed record
             divider:integer;               // �������� �������� ������� ������, ��������:
                                            // 2..65535
                                            //
             prescaler:integer;             // ����������� �������� ������� ������:
                                            // 1, 8, 64, 256, 1024
                                            //
        end;


   TLTR11=packed record                     // ���������� � ������ LTR11 */
    size:integer;                           // ������ ��������� � ������ */
    Channel:TLTR;                           // ��������� ������ ����� � ������� */
    StartADCMode:integer;                   // ����� ������ ����� ������:
                                            // LTR11_STARTADCMODE_INT     - ���������� ����� (��
                                            //                              ������� �����);
                                            // LTR11_STARTADCMODE_EXTRISE - �� ������ ��������
                                            //                              �������;
                                            // LTR11_STARTADCMODE_EXTFALL - �� ����� ��������
                                            //                              �������.
                                            //
    InpMode:integer;                        // ����� ����� ������ � ���
                                            //  LTR11_INPMODE_INT     - ���������� ������ ���
                                            //                          (������� �������� AdcRate)
                                            //  LTR11_INPMODE_EXTRISE - �� ������ �������� �������
                                            //  LTR11_INPMODE_EXTFALL - �� ����� �������� �������
                                            //
    LChQnt:integer;                         // ����� �������� ���������� ������� (������ �����) */
    LChTbl:array[0..LTR11_MAX_LCHANNEL-1]of byte;
                                            // ����������� ������� � ��������� ����������� ��������
                                            // ��������� ������ ����� �������: MsbGGMMCCCCLsb
                                            //   GG   - ������� ��������:
                                            //          0 - +-10 �;
                                            //          1 - +-2.5 �;
                                            //          2 - +-0.625 �;
                                            //          3 - +-0.156�;
                                            //   MM   - �����:
                                            //          0 - 16-���������, ������ 1-16;
                                            //          1 - ��������� ������������ ����������
                                            //              �������� ����;
                                            //          2 - 32-���������, ������ 1-16;
                                            //          3 - 32-���������, ������ 17-32;
                                            //   CCCC - ����� ����������� ������:
                                            //          0 - ����� 1 (17);
                                            //          . . .
                                            //          15 - ����� 16 (32).
                                            //
    ADCMode:integer;                        // ����� ����� ������ ��� ��� ��������� ������ */
    ADCRate:ADC_SET;                        // ��������� ��� ������� ������� ������������� ���
                                            // ������� �������������� �� �������:
                                            // F = LTR11_CLOCK/(prescaler*(divider+1)
                                            // ��������!!! ������� 400 ��� �������� ������ �������:
                                            // ��� �� ��������� ����������� � �������� ������ �����
                                            // ��������� ��������:
                                            //   prescaler = 1
                                            //   divider   = 36
                                            //
    ChRate:real;                            // ������� ������ ������ � ��� (������ �����) ���
                                            //���������� ������� ���
                                            //
    ModuleInfo:TINFO_LTR11;
    end;
//================================================================================================*/
    pTLTR11=^TLTR11;
//================================================================================================*/
Function LTR11_Close(module:pTLTR11):integer; stdcall;
Function LTR11_GetConfig(module:pTLTR11):integer;      stdcall;
Function LTR11_GetErrorString(err:integer):string; stdcall;
Function LTR11_GetFrame(module:pTLTR11; bufDWORD:Pointer):integer; stdcall;
Function LTR11_Init(module:pTLTR11):integer; stdcall;
Function LTR11_Open(module:pTLTR11; net_addrDWORD:Cardinal; net_portWORD:word; crate_snCHAR:Pointer;
    slot_numINT:integer):integer; stdcall;
Function LTR11_ProcessData(module:pTLTR11; srcDWORD:Pointer; destDOUBLE:Pointer; sizeINT:Pointer;
    calibrBOOL:boolean; voltBOOL:boolean):integer; stdcall;
Function LTR11_SetADC(module:pTLTR11):integer;   stdcall;
Function LTR11_Start(module:pTLTR11):integer; stdcall;
Function LTR11_Stop(module:pTLTR11):integer; stdcall;
//================================================================================================*/
implementation
      Function LTR11_Close(module:pTLTR11):integer; external 'ltr11api.dll';
      Function LTR11_GetConfig(module:pTLTR11):integer;external 'ltr11api.dll';
      Function LTR11_GetErrorString(err:integer):string;external 'ltr11api.dll';
      Function LTR11_GetFrame(module:pTLTR11; bufDWORD:Pointer):integer;external 'ltr11api.dll';
      Function LTR11_Init(module:pTLTR11):integer;external 'ltr11api.dll';
      Function LTR11_Open(module:pTLTR11; net_addrDWORD:Cardinal; net_portWORD:word; crate_snCHAR:Pointer;
                          slot_numINT:integer):integer;external 'ltr11api.dll';
      Function LTR11_ProcessData(module:pTLTR11; srcDWORD:Pointer; destDOUBLE:Pointer; sizeINT:Pointer;
                          calibrBOOL:boolean; voltBOOL:boolean):integer;external 'ltr11api.dll';
      Function LTR11_SetADC(module:pTLTR11):integer;external 'ltr11api.dll';
      Function LTR11_Start(module:pTLTR11):integer;external 'ltr11api.dll';
      Function LTR11_Stop(module:pTLTR11):integer;external 'ltr11api.dll';
end.
