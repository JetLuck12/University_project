#ifndef LTRS412API_H_
#define LTRS412API_H_


#include "ltr01api.h"

#ifdef __cplusplus
extern "C" {                                 // only need to export C interface if
                                             // used by C++ source code
#endif

#ifdef _WIN32
    #ifdef LTRS412API_EXPORTS
      #define LTRS412API_DllExport(type) __declspec(dllexport) type APIENTRY
    #else
      #define LTRS412API_DllExport(type) __declspec(dllimport) type APIENTRY
    #endif
#elif defined __GNUC__
    #define LTRS412API_DllExport(type) __attribute__ ((visibility("default"))) type
#else
    #define LTRS412API_DllExport(type)  type
#endif


/** ������ ������ � ������ ������ � ��������� #TLTRS412_MODULE_INFO */
#define LTRS412_NAME_SIZE        16
/** ������ ������ � �������� ������� ������ � ��������� #TLTRS412_MODULE_INFO */
#define LTRS412_SERIAL_SIZE      24
/** ���������� ������� ���� � ������ */
#define LTRS412_RELAY_CNT        16

#pragma pack (4)

/** ���������� � ������ */
typedef struct {
    CHAR        Name[LTRS412_NAME_SIZE];      /**< �������� ������ (�������������� ����� ASCII-������) */
    CHAR        Serial[LTRS412_SERIAL_SIZE];  /**< �������� ����� ������ (�������������� ����� ASCII-������) */
    BYTE        VerPLD;                      /**< ������ �������� PLD  */
    DWORD       Reserved[11];                 /**< ������ */
} TLTRS412_MODULE_INFO;

/** ��������� ��������� ������ */
typedef struct {
    WORD  RelayStates; /**< ������� ��������� ������� ����. ���������������
                            ����������� ��� �������� ������ LTRS412_SetRelayStates() */
    DWORD Reserved[7]; /**< ������ */
} TLTRS412_STATE;



/** ��������� ������ */
typedef struct {
    INT size;     /**< ������ ���������. ����������� � LTRS412_Init(). */
    /** ���������, ���������� ��������� ���������� � ��������.
        �� ������������ �������� �������������. */
    TLTR Channel;
    /** ��������� �� ������������ ��������� � ����������� �����������,
        ������������� ������������� ����������� � ������������ ��� ������������. */
    PVOID Internal;    
    DWORD Reserved[16]; /**< ������ */
    /** ��������� ������ � ������������ ���������. ���� ���������� ���������
        ����������. ���������������� ���������� ����� ��������������
        ������ ��� ������. */
    TLTRS412_STATE State;
    TLTRS412_MODULE_INFO ModuleInfo; /**< ���������� � ������ */
} TLTRS412;

#pragma pack ()

/*============================================================================*/

LTRS412API_DllExport(INT) LTRS412_Init(TLTRS412 *hnd);
LTRS412API_DllExport(INT) LTRS412_Open(TLTRS412 *hnd, DWORD net_addr, WORD net_port,
                                       const CHAR *csn, WORD slot);
LTRS412API_DllExport(INT) LTRS412_Close(TLTRS412 *hnd);
LTRS412API_DllExport(INT) LTRS412_IsOpened(TLTRS412 *hnd);


/***************************************************************************//**
   @brief ��������� ��������� ������� ����.

   ������� ������������� ��������� ���� #LTRS412_RELAY_CNT ������� ���� ������.
   ������� ���� ������������� ���� ��� � ������������ �����, ������� � ��������.
   ���� �� ���������� � 1, �� ���� ��������, ����� - ���������.

   @param[in] hnd       ��������� ������
   @param[in] states    ����� � ���������� ������� ����.
                        ������������� ������ ������� #LTRS412_RELAY_CNT ���.
   @return              ��� ������.
 ******************************************************************************/
LTRS412API_DllExport(INT) LTRS412_SetRelayStates(TLTRS412 *hnd, DWORD states);

/***************************************************************************//**
   @brief ��������� ��������� �� ������.

   ������� ���������� ������, ��������������� ����������� ���� ������, � ���������
   CP1251 ��� Windows ��� UTF-8 ��� Linux. ������� ����� ���������� ��� ������
   �� LTRS412API, ��� � ����� ���� ������ �� ltrapi.

   @param[in] err       ��� ������
   @return              ��������� �� ������, ���������� ��������� �� ������.
 ******************************************************************************/
LTRS412API_DllExport(LPCSTR) LTRS412_GetErrorString(INT err);


#ifdef __cplusplus
}                                          // only need to export C interface if
                                           // used by C++ source code
#endif

#endif                      /* #ifndef LTR11API_H_ */
