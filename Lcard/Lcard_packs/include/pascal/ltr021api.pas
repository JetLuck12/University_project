//-----------------------------------------------------------------------------
// crate controller LTR021
//-----------------------------------------------------------------------------
unit ltr021api;
interface
uses windows, SysUtils, ltrapi,ltrapidefine,ltrapitypes;
const
// ���� ������
        LTR021_OK                     =LTR_OK;    //��������� ��� ������.
        LTR021_ERROR_GET_ARRAY        =-200;     //������ ���������� ������� GET_ARRAY.
        LTR021_ERROR_PUT_ARRAY        =-201;     //������ ���������� ������� PUT_ARRAY.
        LTR021_ERROR_GET_MODULE_NAME  =-202;     //������ ���������� ������� GET_MODULE_NAME.
        LTR021_ERROR_GET_MODULE_GESCR =-203;     //������ ���������� ������� GET_MODULE_DESCRIPTOR.
        LTR021_ERROR_CRATE_TYPE       =-204;     //�������� ��� ������.
//-----------------------------------------------------------------------------
type
TDESCRIPTION_LTR021=packed record
                Module:TDESCRIPTION_MODULE;
                Cpu:TDESCRIPTION_CPU;
                Fpga:TDESCRIPTION_FPGA;
                Interface_:TDESCRIPTION_INTERFACE;
            end;


_LTR021_Sync_Type = ( LTR021_No_Sync=0,
                      LTR021_Rising_Start,
                      LTR021_Falling_Start,
                      LTR021_Rising_Sync,
                      LTR021_Falling_Sync,
			    LTR021_INT_START,
			    LTR021_INT_SEC);

TLTR021=packed record
                ltr:TLTR;
            end;
pTLTR021 = ^TLTR021;

//-----------------------------------------------------------------------------
Function  LTR021_Init(module:pTLTR021):integer; stdcall;
Function  LTR021_Open(module:pTLTR021; saddr:Cardinal; sport:word; csnCHAR:Pointer):integer;stdcall;
Function  LTR021_Close(module:pTLTR021):integer;stdcall;
Function  LTR021_GetArray(module:pTLTR021; bufBYTE:Pointer; size:Cardinal; address:Cardinal):integer;stdcall;
Function  LTR021_PutArray(module:pTLTR021; bufBYTE:Pointer; size:Cardinal; address:Cardinal):integer;stdcall;
Function  LTR021_GetDescription(module:pTLTR021; descriptionTDESCRIPTION_LTR021:Pointer):integer;stdcall;
Function  LTR021_SetCrateSyncType(module:pTLTR021; SyncType:Cardinal):integer;stdcall;

implementation

  Function  LTR021_Init(module:pTLTR021):integer;external 'ltr021api.dll';
  Function  LTR021_Open(module:pTLTR021; saddr:Cardinal; sport:word; csnCHAR:Pointer):integer;external'ltr021api.dll';
  Function  LTR021_Close(module:pTLTR021):integer;external'ltr021api.dll';
  Function  LTR021_GetArray(module:pTLTR021; bufBYTE:Pointer; size:Cardinal; address:Cardinal):integer;external'ltr021api.dll';
  Function  LTR021_PutArray(module:pTLTR021; bufBYTE:Pointer; size:Cardinal; address:Cardinal):integer;external'ltr021api.dll';
  Function  LTR021_GetDescription(module:pTLTR021; descriptionTDESCRIPTION_LTR021:Pointer):integer;external'ltr021api.dll';
  Function  LTR021_SetCrateSyncType(module:pTLTR021; SyncType:Cardinal):integer;external'ltr021api.dll';




end.
