/** @file ltr01api.h
    ���� �������� ����������� ������� ��� ��������� ��������������� ��������������
    �������������� ������� ������� LTR. ��� �������������� ������ ����������
    ����� MID ������ MID_LTR01. ������, ����� �������������� ������ ������� ����������,
    ����� � ������� ������������ ��������������.

    � ���������� ������ ��� ����� ������� ��� ��������� ���������� � �������������
    ��������� ������������ ID (� ������ ������� ��� ������������� � API
    ����� �������������� �������), ��� � ���������� �������, ����������� ���
    �� ���� ����� (��� �������� ������ �� ������� �������� ��� �����������
    ������� �������).

    ���������� �� ���������� ��������������� ���� ��� ����������� ���������
    ������ LTR01, � ���������� �������� ��������� ���������� TLTR. ��� �������
    ��� ����� �������� ����������� � API �������������� �������. */

#ifndef LTR01API_H_
#define LTR01API_H_


#include "ltrapi.h"

#ifdef __cplusplus
extern "C" {                                 // only need to export C interface if
                                             // used by C++ source code
#endif

#ifdef _WIN32
    #ifdef LTR01API_EXPORTS
      #define LTR01API_DllExport(type) __declspec(dllexport) type APIENTRY
    #else
      #define LTR01API_DllExport(type) __declspec(dllimport) type APIENTRY
    #endif
#elif defined __GNUC__
    #define LTR01API_DllExport(type) __attribute__ ((visibility("default"))) type
#else
    #define LTR01API_DllExport(type)  type
#endif

/** ������ �������������� ������� */
typedef enum {
    LTR01_SUBID_GROUP_GENERAL = 0, /**< ����� ������, � ������� ���� ������ ��� ��������������
                                        � �����-���� ������ ��� ������, ������������� ��
                                        �������� ������������ �� ������ */
    LTR01_SUBID_GROUP_LTRK    = 1, /**< ������ ��������� LTRK */
} e_LTR01_SUBID_GROUP;


/** ������ ��� �������� �������������� �� ������ � ������ ������ */
#define LTR01_MAKE_SUBID(group, num)    ((((group) & 0x7) << 10) | ((num) & 0x3FF))
#define LTR01_MAKE_SUBID_GENERAL(num)   LTR01_MAKE_SUBID(LTR01_SUBID_GROUP_GENERAL, num)
#define LTR01_MAKE_SUBID_LTRK(num)      LTR01_MAKE_SUBID(LTR01_SUBID_GROUP_LTRK, num)

/** ������������ ������ ����� ��������������� ������ */
#define LTR01_MODULE_NAME_SIZE          32

/** ���� ����������� ���������������, ����������� ����������, ����� ������ ��������������
    ������ ������� ���������� */
typedef enum {
    LTR01_SUBID_INVALID = 0,
    LTR01_SUBID_LTRS511 = LTR01_MAKE_SUBID_GENERAL(1), /**< ������������� ������ LTRS511 */
    LTR01_SUBID_LTRS411 = LTR01_MAKE_SUBID_GENERAL(2), /**< ������������� ������ LTRS411 */
    LTR01_SUBID_LTRS412 = LTR01_MAKE_SUBID_GENERAL(3), /**< ������������� ������ LTRS412 */
    LTR01_SUBID_LTRT10  = LTR01_MAKE_SUBID_GENERAL(4), /**< ������������� ������ LTRT10 */
    LTR01_SUBID_LTRT13  = LTR01_MAKE_SUBID_GENERAL(5), /**< ������������� ������ LTRT13 */
    LTR01_SUBID_LTRK511 = LTR01_MAKE_SUBID_GENERAL(6), /**< ������������� ������ LTRK511 */
    LTR01_SUBID_LTRK416 = LTR01_MAKE_SUBID_GENERAL(7), /**< ������������� ������ LTRK416 */
    LTR01_SUBID_LTRK415 = LTR01_MAKE_SUBID_GENERAL(8), /**< ������������� ������ LTRK415 */
    LTR01_SUBID_LTRK71  = LTR01_MAKE_SUBID_GENERAL(9), /**< ������������� ������ LTRK71 */
} e_LTR01_SUBID;



/*============================================================================*/

/**  @brief �������� ���������� � �������.

    ������� ������������� ���������� � ����� �� �������������� ������� � MID ������ 1.
    � ������������ � ����������� �����������, ��������� ������� ������ � ���
    ������������� ��������� �������������� �������������.

    ����� ���������� ������ ���������� ������� ���������� � ������� LTR01_Close().
 *
 *��������� ����������
    ��������� ����������, ����� ������ � ��������, ��� ��� ������ LTR01.
    @param[in] hnd              ��������� ��� ��������� ���������� � ��������,
                                �������������� ��������������������� � ������� LTR_Init()
    @param[in] ltrd_addr        IP-����� ������, �� ������� �������� ������ ltrd, � 32-������
                                ������� (������ � ������� "������ ������� IP-�������"
                                @docref_ltrapi{����������� ��� ���������� ltrapi}).
                                ���� ������ ltrd �������� �� ��� �� ������, ��� � ���������,
                                ���������� ������ �������, �� � �������� ������
                                ����� �������� LTRD_ADDR_DEFAULT.
    @param[in] ltrd_port        TCP-���� ��� ����������� � ������ ltrd. �� ���������
                                ������������ LTRD_PORT_DEFAULT.
    @param[in] csn              �������� ����� ������, � ������� ��������� ������������
                                ������. ������������ ����� �������������� ����� ASCII-������.
                                ��� ���������� � ������ ��������� ������� ����� ��������
                                ������ ������ ��� ������� ���������.
    @param[in] slot_num         ����� ����� ������, � ������� ���������� ������������ ������.
                                �������� �� LTR_CC_CHNUM_MODULE1 �� LTR_CC_CHNUM_MODULE16.
    @param[in] subid            ���� �� ����� #LTR01_SUBID_INVALID, �� ������� ���������
                                �������� �� ������������ ��������������� ��������������
                                ���������� � ������ ���������
    @param[out] cpld_ver        ���� �� NULL, �� � ������ ���������� �����������
                                ������ CPLD, ���������� � ������ �� ����� ������.
    @param[out] modification    ��� ����������� ������ (���� ��������������).
                                ������������ ������ ��� subid ��������� ��
                                #LTR01_SUBID_INVALID.
    @return                     ��� ������ */
LTR01API_DllExport(INT) LTR01_Open(TLTR *hnd, DWORD ltrd_addr, WORD ltrd_port,
                                   const CHAR *csn, INT slot_num, WORD subid,
                                   BYTE *cpld_ver, BYTE *modification);

/** �������� ����� ��������� � ������� LTR01_Open() ����������.
    @param[in] hnd              ��������� ���������� � ��������
    @return                     ��� ������ */
LTR01API_DllExport(INT) LTR01_Close(TLTR *hnd);

/** ��������� ��������������� ID ��� ������ LTR01, � ������� ���� �����������
    �� ����� ����� � ������� LTR01_Open().
    �������������� ID ��������� ������, ����� ������� ������ �������������� ������
    ����������.
    @param[in] hnd              ��������� ���������� � ��������.
    @param[out] subid           ��� ������ ������������ �������������� ID-������
                                �� #e_LTR01_SUBID.
    @param[out] modification    ��� ����������� ������ (���� ��������������).
    @return                     ��� ������ */
LTR01API_DllExport(INT) LTR01_GetModuleSubID(TLTR *hnd, WORD *subid, BYTE *modification);

/** ��������������� ������� ��� ��������� ��������������� ID ������ �� ���� �����.
    ������� ������������� ���������� � �������, �������� ID ������ � ���������
    ������������� ����������.

    ���������� ������������������ ������� LTR_Init(), LTR01_Open(),
    LTR01_GetModuleSubID() � LTR01_Close().

    @param[in] ltrd_addr        IP-����� ������, �� ������� �������� ������ ltrd, � 32-������
                                ������� (������ � ������� "������ ������� IP-�������"
                                @docref_ltrapi{����������� ��� ���������� ltrapi}).
                                ���� ������ ltrd �������� �� ��� �� ������, ��� � ���������,
                                ���������� ������ �������, �� � �������� ������
                                ����� �������� LTRD_ADDR_DEFAULT.
    @param[in] ltrd_port        TCP-���� ��� ����������� � ������ ltrd. �� ���������
                                ������������ LTRD_PORT_DEFAULT.
    @param[in] csn              �������� ����� ������, � ������� ��������� ������������
                                ������. ������������ ����� �������������� ����� ASCII-������.
                                ��� ���������� � ������ ��������� ������� ����� ��������
                                ������ ������ ��� ������� ���������.
    @param[in] slot_num         ����� ����� ������, � ������� ���������� ������������ ������.
                                �������� �� LTR_CC_CHNUM_MODULE1 �� LTR_CC_CHNUM_MODULE16.
    @param[out] subid           ��� ������ ������������ �������������� ID-������
                                �� #e_LTR01_SUBID.
    @param[out] modification    ��� ����������� ������ (���� ��������������).
    @return                     ��� ������ */
LTR01API_DllExport(INT) LTR01_GetSubID(DWORD ltrd_addr, WORD ltrd_port, const CHAR *csn,
                                       INT slot_num, WORD *subid, BYTE *modification);

/** ��������� �������� ������ �� ��� ��������������� ��������������.
    ������� ��������� ��� �������������, ������������� ������������ LTR01_GetModuleNameEx().

    @param[in] subid            �������������� ������������� �� #e_LTR01_SUBID.
    @return                     ������ � ������ ������ */
LTR01API_DllExport(LPCSTR) LTR01_GetModuleName(WORD subid);

/** ��������� ������� �������� ������ �� ��� ��������������� ��������������.

    ������� �������� ������ �������� ������ � ������ ����������� � ��������������
    � ������. ���� ��� ������� ������������� ������, �� �������� ���������� ��
    ����� ������������ ��������, �� ����� ���������� ������ LTR_ERROR_UNKNOWN_MODULE_ID
    � �������������� ������ ��������� ��� ���������.

    @param[in] subid           �������������� ������������� ������ (����� ���� ������� ����� LTR01_GetModuleSubID())
    @param[in] modification    ����������� ������ (����� ���� �������� ����� LTR01_GetModuleSubID())
                                ��� ��������� ������ 0, ���� ����� �������� �������� ��� �����������.
    @param[out] module_name    ������, � ������� ����� ��������� �������� ���� ������. ������ ������ ����
                                ������������ ������� ��� ���������� �� ������� ���� #LTR01_MODULE_NAME_SIZE
                                ��������.

    @return                    ��� ������. */
LTR01API_DllExport(INT) LTR01_GetModuleNameEx(WORD subid, BYTE modification, CHAR *module_name);

/*============================================================================*/

#ifdef __cplusplus
}                                          // only need to export C interface if
                                           // used by C++ source code
#endif

#endif                      /* #ifndef LTR11API_H_ */
