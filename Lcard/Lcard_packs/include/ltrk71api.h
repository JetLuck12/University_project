#ifndef LTRK71API_H_
#define LTRK71API_H_

#include "ltr01api.h"

#ifdef __cplusplus
extern "C" {                                 // only need to export C interface if
                                             // used by C++ source code
#endif

#ifdef _WIN32
    #ifdef LTRK71API_EXPORTS
      #define LTRK71API_DllExport(type) __declspec(dllexport) type APIENTRY
    #else
      #define LTRK71API_DllExport(type) __declspec(dllimport) type APIENTRY
    #endif
#elif defined __GNUC__
    #define LTRK71API_DllExport(type) __attribute__ ((visibility("default"))) type
#else
    #define LTRK71API_DllExport(type)  type
#endif


/** ������ ������ � ������ ������ � ��������� #TLTRK71_MODULE_INFO */
#define LTRK71_NAME_SIZE                16
/** ������ ������ � �������� ������� ������ � ��������� #TLTRK71_MODULE_INFO */
#define LTRK71_SERIAL_SIZE              24
/** ������ ������ ��� �������� �������� ������������������ ������ */
#define LTRK71_TX_STREAM_BUF_SIZE       (16*1024)
/** ������������ �������� ���� ������� ������������ ������� */
#define LTRK71_SPECSIG_PERIOD_MAX       15


/** ���� ������, ����������� ��� LTRK71. */
typedef enum {
    LTRK71_ERR_INSUF_OUT_CH_BUF_SIZE   = -11130, /**< �������� ������ ������ ��������� ������ �� ����� */
} e_LTRK71_ERROR_CODES;

/** ���� ��������� ��������������� ������ ������ */
typedef enum {
    LTRK71_INFORMATIVITY_2 = 3, /**< 2-�� ��������������� */
    LTRK71_INFORMATIVITY_4 = 1, /**< 4-�� ��������������� */
    LTRK71_INFORMATIVITY_8 = 0, /**< 8-�� ��������������� */
} e_LTRK71_INFORMATIVITY;

/** ������ ������ ���������� �� ������� ������ */
typedef enum {
    LTRK71_MON_MODE_FROM_STREAM = 0, /**< �� ������� �������� ������ � ������ �� ������ */
    LTRK71_MON_MODE_FROM_BUF    = 1, /**< �� ������� �������� ������ �� ������ ������, ���������� � ������� LTRK71_MonBufWrite() */
} e_LTRK71_MON_MODE;

/** �������� ������ ��� �������� */
typedef enum {
    LTRK71_TXSRC_BUF            = 0, /**< ���������� ���������� � ����� ������ */
    LTRK71_TXSRC_SPECSIG        = 1, /**< ���������� ������ ����������� �����, ��������������� ���� */
} e_LTRK71_TXSRC;

typedef enum {
    LTRK71_SPECSIG_TYPE_PHASE_0   = 0, /**< ���� 0� */
    LTRK71_SPECSIG_TYPE_PHASE_180 = 1, /**< ���� 180� */
    LTRK71_SPECSIG_TYPE_MEANDER   = 2, /**< ������ */
} e_LTRK71_SPECSIG_TYPE;

#pragma pack (4)

/** ���������� � ������ */
typedef struct {
    CHAR        Name[LTRK71_NAME_SIZE];      /**< �������� ������ (�������������� ����� ASCII-������) */
    CHAR        Serial[LTRK71_SERIAL_SIZE];  /**< �������� ����� ������ (�������������� ����� ASCII-������) */
    BYTE        VerPLD;                      /**< ������ �������� PLD  */
    DWORD       Reserved[15];                 /**< ������ */
} TLTRK71_MODULE_INFO;


/** ��������� ������-�������� ������ ������ ������ */
typedef struct {
    BOOLEAN TxEn; /**< ���������� �������� �������� ������ ������ ������.
                       ���� TRUE, �� ����� ������� ������ ������
                       ����� ���������� ���������� �������� ����� ������, �����������
                       � ������� LTRK71_LoadTxStreamBuf() */
    BOOLEAN RxEn; /**< ���������� ������. ���� TRUE, �� ����� ������� ������,
                       ������ ����� ��������� ������ � ���������� � RxChNum
                       ������ � ���������� �� � �� */
    BYTE    RxChNum; /**< ����� ������, � �������� ����������� ������ - 0, 1, 2 */
    BYTE    Informativity;  /**< ��������������� - �������� �� #e_LTRK71_INFORMATIVITY */
    BYTE    TxSrc;          /**< �������� ������ ��� ��������. �������� �� #e_LTRK71_TXSRC */
    BYTE    SpecSigType;    /**< ��� ������������ ������� ��� TxSrc ==  #LTRK71_TXSRC_SPECSIG, �������� �� #e_LTRK71_SPECSIG_TYPE */
    WORD    SpecSigPeriod;  /**< ������ ������������ ������� (�������������� �������� �� 0 �� #LTRK71_SPECSIG_PERIOD_MAX). */
    DWORD   Reserved[6]; /**< ������ */
} TLTRK71_STREAM_CONFIG;

/** ��������� ������ */
typedef struct {
    TLTRK71_STREAM_CONFIG Stream; /**< ��������� ������ */
    DWORD Reserved[16]; /**< ������ */
} TLTRK71_CONFIG;



/** ��������� ��������� ������ */
typedef struct {
    BOOLEAN ExchangeActive; /**< ������� ����������� ������ ������� ������ � �������.
                                 ��������������� ����� ��������� ���������� LTRK71_ExchangeStart()
                                 � ������������ ����� ��������� LTRK71_ExchangeStop(). */
    DWORD Reserved[7]; /**< ������ */
} TLTRK71_STATE;



/** ��������� ������ */
typedef struct {
    INT size;     /**< ������ ���������. ����������� � LTRK71_Init(). */
    /** ���������, ���������� ��������� ���������� � ��������.
        �� ������������ �������� �������������. */
    TLTR Channel;
    /** ��������� �� ������������ ��������� � ����������� �����������,
        ������������� ������������� ����������� � ������������ ��� ������������. */
    PVOID Internal;    
    TLTRK71_CONFIG Cfg; /**< ��������� ������ */
    /** ��������� ������ � ������������ ���������. ���� ���������� ���������
        ����������. ���������������� ���������� ����� ��������������
        ������ ��� ������. */
    TLTRK71_STATE State;
    TLTRK71_MODULE_INFO ModuleInfo; /**< ���������� � ������ */
} TLTRK71;


/** ���������� � �������� ����� ������ ������ � ������. ���������� �� ������
    ������������ ����� LTR � ���������� ��������� ������ � �������
    LTRK71_ProcessData() */
typedef struct {
    WORD Data;              /**< 10-������ ������ */
    BOOLEAN ParityVal;         /**< �������� ���� �������� */
    BOOLEAN ParityOk;      /**< ������� ������ �������� */
    BOOLEAN PhaseMarker;    /**< ������� ������� ������� ���� */
    BYTE    PhaseWordNum;   /**< ����� ����� � ���� �����, ������� � �������� �� ������� ���� */
    BOOLEAN SvcInfo;        /**< ��� ��������� ���������� */
    BYTE    Reserved;       /**< ������. ������ ����������� ������� ���� ��������� �����, ��� ��� ���� = 0, ����� ��������, ������� PhaseMarker  */
} TLTRK71_RX_DATA;

#pragma pack ()

/*============================================================================*/

LTRK71API_DllExport(INT) LTRK71_Init(TLTRK71 *hnd);
LTRK71API_DllExport(INT) LTRK71_Open(TLTRK71 *hnd, DWORD net_addr, WORD net_port,
                                       const CHAR *csn, WORD slot);
LTRK71API_DllExport(INT) LTRK71_Close(TLTRK71 *hnd);
LTRK71API_DllExport(INT) LTRK71_IsOpened(TLTRK71 *hnd);



/** �������� ����� � ����� ��� ������ �� ������� ������
 *  � ������ #LTRK71_MON_MODE_FROM_BUF
 *
 *  @param[in] hnd       ��������� ������.
 *  @param[in] addr      ����� ����� � �����������.
 *  @param[in] word      �������� ������������� �����
 *  @return              ��� ������.
 ******************************************************************************/
LTRK71API_DllExport(INT) LTRK71_MonBufWrite(TLTRK71 *hnd, BYTE addr, BYTE word);


/** ��������� ������ ������ �� ����� ������. ������ ����� �������� �� ����� ����
 *  ���������� �� ������ ������ ������ �� ������, ���� ����������� � �������
 *  LTRK71_MonBufWrite() ������. � ������ ������ ����� ���������� ������� �����
 *  �������������� ����� ��� ����������� ������� ������ ������ ��� �����������/
 *  ������� ������ �����������  ��� ������������� ������ ������.
 *  @param[in] hnd       ��������� ������.
 *  @param[in] mode      ����� ������ �� �������. �������� �� #e_LTRK71_MON_MODE
 *  @param[in] CbrChNum  ����� �������������� ����� (������) � ������ ������ �� ������
 *                       (��� ������ #LTRK71_MON_MODE_FROM_STREAM)
   @return              ��� ������.
 ******************************************************************************/
LTRK71API_DllExport(INT) LTRK71_MonSetMode(TLTRK71 *hnd, DWORD mode, DWORD CbrChNum);


/***************************************************************************//**
   @brief �������� �������� ������������ ������ ��� ������ ��������� ������.

   ������� ��������� ��������� � ����� �������� ��� ������������ ������������ ������
   ��������� ������ ������ ������.

   ��� ������ �������� ������������������ ���������� ������ ��������� ������ � ����� �
   ��������� ������ � ���� TxEn �������� Cfg.Stream, ����� ���� ��������� ����� � �������
   LTRK71_LoadTxStreamBuf().

   @param[in] hnd       ��������� ������.
   @param[in] data      ������ �� size 16-������ ����, � ������� ���������� 10-��� ������������
                        ������. ������� 4 ���� - ������.
   @param[in] size      ���������� ���� � ������ data ��� �������� � ������. �����
                        ���� �� 1 �� #LTRK71_TX_STREAM_BUF_SIZE.
   @return              ��� ������.
 ******************************************************************************/
LTRK71API_DllExport(INT) LTRK71_LoadTxStreamBuf(TLTRK71 *hnd, const WORD *data, WORD size);


/***************************************************************************//**
   @brief ������ ������ ���������� ������� � �������.

   ������� ��������� ������ ������ ������ �� ������ � ���������� ������ �/��� �����������
   ������ ������� ����������� �������� ������������������.

   ��������� ������ ���������� ������� ������ ���� ��������� � ���� Cfg.Stream
   �� ������ ������ �������.

   ���� ��������� ������ �������� ������������������, �� ���� ���������� ����� ������
   ���� �������������� �������� � ������� LTRK71_LoadTxStreamBuf().

   ����� ������ ������ ������� �� ������ ��������� ��������� ������, � �����
   �� ���������� ������ � ������� LTRK71_ExchangeStop()
   ���������� ����� ������� ��� ������� ������, ����� LTRK71_Recv() �
   ���������� � ������� LTRK71_ProcessData().


   @param[in] hnd       ��������� ������.
   @return              ��� ������.
 ******************************************************************************/
LTRK71API_DllExport(INT) LTRK71_ExchangeStart(TLTRK71 *hnd);

/***************************************************************************//**
   @brief ���������� ������ ���������� ������� � �������.

   ������� ��������� ����� ��������, ���������� LTRK71_ExchangeStart().
   ����� ��������� ������ ����� ����������� � ����� ������������ ������ �������,
   ����� ������ ������

   @param[in] hnd       ��������� ������.
   @return              ��� ������.
 ******************************************************************************/
LTRK71API_DllExport(INT) LTRK71_ExchangeStop(TLTRK71 *hnd);


/***************************************************************************//**
   @brief ����� ������ �� ������

   ������� ��������� ������������� ����� ���� �� ������. ������������ �����
   ��������� � ����������� �������, ������� �������� � ���� ��������� ����������.

   ��� ��������� �������� ���� � ��������� �������� ��������� ������������ �������
   LTRK415_ProcessData().

   ������� ���������� ���������� ���� ����� ������ ����������� ���������� ����,
   ���� �� ��������� ��������. ��� ���� ������� �������� ���������� ���� �����
   ������ �� ������������� ��������.

   @param[in]  hnd      ��������� ������.
   @param[out] data     ������, � ������� ����� ��������� �������� �����. ������
                        ���� �������� �� size 32-������ ����.
   @param[out] tmark    ��������� �� ������ �������� �� size 32-������ ����,
                        � ������� ����� ��������� �������� ��������� �����������,
                        ��������������� �������� ������. ��������� �����
                        ������������� ��� ������ ��� ������������ ������ ��������.
                        ����������� ��������� ������� � ������� "�����������"
                        @docref_ltrapi{����������� ��� ���������� ltrapi}.
                        ���� ����������� �� ������������, �� ����� ��������
                        � �������� ��������� ������� ���������.
   @param[in]  size     ������������� ���������� 32-������ ���� �� �����.
   @param[in]  timeout  ������� �� ���������� �������� � �������������. ���� � �������
                        ��������� ������� �� ����� ������� ������������� ����������
                        ����, �� ������� ��� ����� ������ ����������, ���������
                        � �������� ���������� ������� �������� ���������� ����
   @return              �������� ������ ���� ������������� ���� ������. ��������
                        ������ ��� ������ ���� ������������� ���������� �������
                        �������� � ����������� � ������ data ����.
*******************************************************************************/
LTRK71API_DllExport(INT) LTRK71_Recv(TLTRK71 *hnd, DWORD *data, DWORD *tstamp, DWORD size, DWORD timeout);


/***************************************************************************//**
    @brief ��������� �������� ������

    ������� ��������� �� ������ ����, �������� � ������� LTRK71_Recv(), ��������
    ���������� � �������� ����� �� ������.

    �� ������ ����� ������� ���������� ��������� ���� #TLTRK71_RX_DATA,
    � ������� ���������� ��� ���������� �� ��������� ��������� �����.


    @param[in] hnd       ��������� ������.
    @param[in] src_data  ������ �� size 32-������ ����, �������� � ������� LTRK71_Recv().
    @param[out] dst_data ������ �� �������� ���� #TLTRK71_RX_DATA, � ������� �����
                         �������� ��������� ���������. ���������� ��������� �������
                         ������ ���� �� ������ ����������� �������� size. �����
                         ���������� ������� ������ ���������� ����������� ���������
                         ����� �������� � ���������� �������� size.
    @param[in, out] size ��� ������ ������ � ������ ��������� ������ ���� ��������
                         ���������� ���� � src_data, ������� ���������� ����������.
                         ����� ���������� ������� �������� size ����� ��������� �
                         ��������� ���������� ������������ � ����������� � dst_data
                         ����. ��� ������� ��� �������� ������ ���������, �� �����
                         ���������� � ������ ����������� ���� ������������ �������.
    @return              ��� ������.
 ******************************************************************************/
LTRK71API_DllExport(INT) LTRK71_ProcessData(TLTRK71 *hnd, const DWORD *src_data, TLTRK71_RX_DATA *dst_data, INT *size);

/***************************************************************************//**
   @brief ��������� ��������� �� ������.

   ������� ���������� ������, ��������������� ����������� ���� ������, � ���������
   CP1251 ��� Windows ��� UTF-8 ��� Linux. ������� ����� ���������� ��� ������
   �� LTRK71API, ��� � ����� ���� ������ �� ltrapi.

   @param[in] err       ��� ������
   @return              ��������� �� ������, ���������� ��������� �� ������.
 ******************************************************************************/
LTRK71API_DllExport(LPCSTR) LTRK71_GetErrorString(INT err);


#ifdef __cplusplus
}                                          // only need to export C interface if
                                           // used by C++ source code
#endif

#endif                      /* #ifndef LTR11API_H_ */