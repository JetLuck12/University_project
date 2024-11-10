/** @file LTRT13API.h
    ���� �������� ����������� �������, ����� � �������� ��� ������ �
    ���������� ������� LTRT13.

    */

#ifndef LTRT13API_H_
#define LTRT13API_H_


#include "ltr01api.h"

#ifdef __cplusplus
extern "C" {                                 // only need to export C interface if
                                             // used by C++ source code
#endif

#ifdef _WIN32
    #ifdef LTRT13API_EXPORTS
      #define LTRT13API_DllExport(type) __declspec(dllexport) type APIENTRY
    #else
      #define LTRT13API_DllExport(type) __declspec(dllimport) type APIENTRY
    #endif
#elif defined __GNUC__
    #define LTRT13API_DllExport(type) __attribute__ ((visibility("default"))) type
#else
    #define LTRT13API_DllExport(type)  type
#endif


/** ������ ������ � ������ ������ � ��������� #TLTRT13_MODULE_INFO */
#define LTRT13_NAME_SIZE        16
/** ������ ������ � �������� ������� ������ � ��������� #TLTRT13_MODULE_INFO */
#define LTRT13_SERIAL_SIZE      24

/** ����������� �������� ������������� ����� (������������ �� ���������) */
#define LTRT13_RVAL_NOM      99.909


#define LTRT13_EXT_SYNC_FREQ_DIV_MIN   3
#define LTRT13_EXT_SYNC_FREQ_DIV_MAX   255

#define LTRT13_EXT_SYNC_FREQ_MAX       400000

/** ���� ������, ����������� ��� LTRT13. */
typedef enum {
    LTRT13_ERR_MARK_GEN_ENABLED         = -11000,  /**< �������� ����������� ��� ����������� ��������� ����� */
    LTRT13_ERR_EXT_SYNC_FREQ_DIV        = -11001,  /**< �������� �������� �������� ������� ��� ������� SYNC */
} e_LTRT13_ERROR_CODES;

#pragma pack (4)

/** ���������� � ������ */
typedef struct {
    CHAR        Name[LTRT13_NAME_SIZE];      /**< �������� ������ (�������������� ����� ASCII-������) */
    CHAR        Serial[LTRT13_SERIAL_SIZE];  /**< �������� ����� ������ (�������������� ����� ASCII-������) */
    BYTE        VerPLD;                      /**< ������ �������� PLD  */
    LONGLONG    CbrTime;                     /**< ����� ������ �������������� �������� ����� - 64-��� Unixtime */
    double      RValue;                      /**< �������� ������������� ����� */
    DWORD       Reserved[8];                 /**< ������ */
} TLTRT13_MODULE_INFO;


typedef struct {
    DWORD ExtSyncFreqDiv;
} TLTRT13_CONFIG;

typedef struct {
    BOOLEAN MarkGenEn; /**< ��������� �� ��������� ����������� (��������� ������� �� ����� ���� ���������) */
    BOOLEAN ExtSyncGenEn; /**< ��������� �� ��������� ������� ������� ������������� ������������ ������ */
    BOOLEAN ExtStartLevel; /** ������� ������������� ������� ������ START */
    DWORD  ExtSyncFreqDiv;
    double ExtSyncFreq;
} TLTRT13_STATE;



/** ��������� ������ */
typedef struct {
    INT size;     /**< ������ ���������. ����������� � LTRT13_Init(). */
    /** ���������, ���������� ��������� ���������� � ��������.
        �� ������������ �������� �������������. */
    TLTR Channel;
    /** ��������� �� ������������ ��������� � ����������� �����������,
        ������������� ������������� ����������� � ������������ ��� ������������. */
    PVOID Internal;

    /** ��������� ������. ����������� ������������� ����� ������� LTR12_SetADC(). */
    TLTRT13_CONFIG Cfg;
    /** ��������� ������ � ������������ ���������. ���� ���������� ���������
        ����������. ���������������� ���������� ����� ��������������
        ������ ��� ������. */
    TLTRT13_STATE State;
    /** ���������� � ������. */
    TLTRT13_MODULE_INFO ModuleInfo;
} TLTRT13;

#pragma pack ()

/*============================================================================*/

LTRT13API_DllExport(INT) LTRT13_Init(TLTRT13 *hnd);
LTRT13API_DllExport(INT) LTRT13_Open(TLTRT13 *hnd, DWORD net_addr, WORD net_port,
                                     const CHAR *csn, WORD slot);
LTRT13API_DllExport(INT) LTRT13_Close(TLTRT13 *hnd);
LTRT13API_DllExport(INT) LTRT13_IsOpened(TLTRT13 *hnd);


LTRT13API_DllExport(INT) LTRT13_FindExtSyncFreqParams(double adcFreq, DWORD *div, double *resultAdcFreq);
LTRT13API_DllExport(INT) LTRT13_FillExtSyncFreqParams(TLTRT13 *hnd, double adcFreq, double *resultAdcFreq);

LTRT13API_DllExport(INT) LTRT13_SetExtStartLevel(TLTRT13 *hnd, BOOLEAN lvl);
LTRT13API_DllExport(INT) LTRT13_SetExtSyncGenEnabled(TLTRT13 *hnd, BOOLEAN en);
LTRT13API_DllExport(INT) LTRT13_SetMarksGenEnabled(TLTRT13 *hnd, BOOLEAN en);

/***************************************************************************//**
   @brief ��������� ��������� �� ������.

   ������� ���������� ������, ��������������� ����������� ���� ������, � ���������
   CP1251 ��� Windows ��� UTF-8 ��� Linux. ������� ����� ���������� ��� ������
   �� LTRT13API, ��� � ����� ���� ������ �� ltrapi.

   @param[in] err       ��� ������
   @return              ��������� �� ������, ���������� ��������� �� ������.
 ******************************************************************************/
LTRT13API_DllExport(LPCSTR) LTRT13_GetErrorString(INT err);


LTRT13API_DllExport(INT) LTRT13_GetConfig(TLTRT13 *hnd);

#ifdef __cplusplus
}                                          // only need to export C interface if
                                           // used by C++ source code
#endif

#endif                      /* #ifndef LTR11API_H_ */
