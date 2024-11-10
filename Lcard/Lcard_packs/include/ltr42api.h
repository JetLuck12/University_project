#ifndef LTR42API_H_
#define LTR42API_H_


#include "ltrapi.h"


/*================================================================================================*/
#ifdef _WIN32
    #ifdef LTR42API_EXPORTS
        #define LTR42API_DllExport(type)   __declspec(dllexport) type APIENTRY
    #else
        #define LTR42API_DllExport(type)   __declspec(dllimport) type APIENTRY
    #endif
#elif defined __GNUC__
    #define LTR42API_DllExport(type) __attribute__ ((visibility("default"))) type
#else
    #define LTR42API_DllExport(type)   type
#endif


#define LTR42_ERR_DATA_TRANSMISSON_ERROR              (-8013)
#define LTR42_ERR_WRONG_SECOND_MARK_CONF              (-8017)
#define LTR42_ERR_WRONG_START_MARK_CONF               (-8018)

#define LTR42_MARK_MODE_INTERNAL         (0)
#define LTR42_MARK_MODE_MASTER           (1)
#define LTR42_MARK_MODE_EXTERNAL         (2)

#define LTR42_EEPROM_SIZE                (512)


/*================================================================================================*/
#pragma pack(4) 
/* ��������� �������� ������ */
typedef struct {
    CHAR Name[16];
    CHAR Serial[24];
    CHAR FirmwareVersion[8];            /* ������ ����� */
    CHAR FirmwareDate[16];              /* ���� �������� ������ ������ ����� */
} TLTR42_MODULE_INFO;

typedef struct {
    TLTR Channel;
    INT size;                           /* ������ ��������� */
    BOOLEAN AckEna;
    struct {
        INT SecondMark_Mode;            /* ����� �����. 0 - �����., 1-�����.+�����, 2-����� */
        INT StartMark_Mode;
    } Marks;                            /* ��������� ��� ������ � ���������� ������� */
    TLTR42_MODULE_INFO ModuleInfo;
} TLTR42, *PTLTR42;                     /* ��������� �������� ������ */
#pragma pack()


/*================================================================================================*/
#ifdef __cplusplus
extern "C" {
#endif

LTR42API_DllExport(INT) LTR42_Init(TLTR42 *hnd);

LTR42API_DllExport(INT) LTR42_Open(TLTR42 *hnd, INT net_addr, WORD net_port, const CHAR *crate_sn,
    INT slot_num);
LTR42API_DllExport(INT) LTR42_IsOpened(TLTR42 *hnd);
LTR42API_DllExport(INT) LTR42_Close(TLTR42 *hnd);

LTR42API_DllExport(INT) LTR42_Config(TLTR42 *hnd);
LTR42API_DllExport(INT) LTR42_GetConfig(TLTR42 *hnd);
#ifdef LTRAPI_USE_KD_STORESLOTS
LTR42API_DllExport(INT) LTR42_ConfigAndStart(TLTR42 *hnd);
#endif

LTR42API_DllExport(INT) LTR42_WritePort(TLTR42 *hnd, WORD OutputData);
LTR42API_DllExport(INT) LTR42_WriteArray(TLTR42 *hnd, const WORD *OutputArray, INT ArraySize);

#ifdef LTRAPI_USE_KD_STORESLOTS
LTR42API_DllExport(INT) LTR42_WritePortSaved(TLTR42 *hnd, WORD OutputData);
#endif

LTR42API_DllExport(INT) LTR42_StartSecondMark(TLTR42 *hnd);
LTR42API_DllExport(INT) LTR42_StopSecondMark(TLTR42 *hnd);
LTR42API_DllExport(INT) LTR42_MakeStartMark(TLTR42 *hnd);

LTR42API_DllExport(INT) LTR42_WriteEEPROM(TLTR42 *hnd, INT Address, BYTE val);
LTR42API_DllExport(INT) LTR42_ReadEEPROM(TLTR42 *hnd, INT Address, BYTE *val);

#ifdef LTRAPI_USE_KD_STORESLOTS
LTR42API_DllExport(INT) LTR42_StoreConfig(TLTR42 *hnd, TLTR_CARD_START_MODE start_mode);
#endif

LTR42API_DllExport(LPCSTR) LTR42_GetErrorString(INT Error_Code);


/***************************************************************************//**
  @brief ��������� ������ �������� ����� �����

  ������ ������� ��������� ������ ����� ��������, ������������� ������� ��
  ������ ��� ��������� ����� �����, ���� ��������� ���������� ����� ����� ��
  ����� (����� #LTR42_MARK_MODE_MASTER).
  ��-��������� ����� �������� ���������� ������� 200��, ��� ����� ����
  ������������ ��� ������� ������ ��������� �� ������� ��������. ������ �������
  ��������� ���������� ������� ����� ��������.
  ������ ������� �������� ������ � ��������, ������� � ������ 2.0.

  @param[in] hnd        ��������� ������
  @param[in] time_mks   ����� �������� � ���. ���� 0 --- �� ������������ �������
                        ��-��������� (~200��).
  @return               ��� ������
 ******************************************************************************/
LTR42API_DllExport (INT) LTR42_SetStartMarkPulseTime(TLTR42 *hnd, DWORD time_mks);

#ifndef LTRAPI_DISABLE_COMPAT_DEFS
    /** @cond obsoleted */
    typedef TLTR42_MODULE_INFO TINFO_LTR42, *PTINFO_LTR42;
    /** @endcond */
#endif

#ifdef __cplusplus 
}
#endif

#endif
















