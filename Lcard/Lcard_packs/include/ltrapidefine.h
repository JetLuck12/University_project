#ifndef LTRAPIDEFINE_H_
#define LTRAPIDEFINE_H_


/***************************************************************************//**
  @addtogroup const_list
  @{
  *****************************************************************************/

/** IP-����� ��� ����������� � ������ ltrd, ��������������� ������, �����
   ������ �������� �� ��������� ������ (��� ��, ������ ��������������� ����������) */
#define LTRD_ADDR_LOCAL   (0x7F000001l)
/** IP-����� �� ��������� ��� ����������� � ������ ltrd */
#define LTRD_ADDR_DEFAULT (LTRD_ADDR_LOCAL)
/** TCP-����, �������������� �� ���������, ��� ����������� � ������ ltrd */
#define LTRD_PORT_DEFAULT (11111)


/** ������������ ���������� �������, ������� ����� �������� � �������
    ������� LTR_GetCrates(). � ������, ���� ������� ����� ���� ������, ��
    ����� ��������������� �������� LTR_GetCratesEx(), ������� �� �����
    ����������� �� ���������� ������� */
#define LTR_CRATES_MAX             16l
/** ������������ ���������� ������� � ����� ������ */
#define LTR_MODULES_PER_CRATE_MAX  16l


/** ���� ������ ������ ������������ ������ ��������� ������ ������ ��� ������������
    �����������, �� ����� ����������� ����������� ���������� � ltrd, �� ���������
    �� � ����� ������� */
#define LTR_CSN_SERVER_CONTROL              "#SERVER_CONTROL"



/** ������ ������� ��� ���������� �� ������� ltrd */
enum en_LTR_CC_ChNum {
    LTR_CC_CHNUM_CONTROL                = 0,  /**< ����� ��� �������� ����������� �������� ������ ��� ������ ltrd */
    LTR_CC_CHNUM_MODULE1                = 1,  /**< ����� ��� ������ c ������� � ����� 1 */
    LTR_CC_CHNUM_MODULE2                = 2,  /**< ����� ��� ������ c ������� � ����� 2 */
    LTR_CC_CHNUM_MODULE3                = 3,  /**< ����� ��� ������ c ������� � ����� 3 */
    LTR_CC_CHNUM_MODULE4                = 4,  /**< ����� ��� ������ c ������� � ����� 4 */
    LTR_CC_CHNUM_MODULE5                = 5,  /**< ����� ��� ������ c ������� � ����� 5 */
    LTR_CC_CHNUM_MODULE6                = 6,  /**< ����� ��� ������ c ������� � ����� 6 */
    LTR_CC_CHNUM_MODULE7                = 7,  /**< ����� ��� ������ c ������� � ����� 7 */
    LTR_CC_CHNUM_MODULE8                = 8,  /**< ����� ��� ������ c ������� � ����� 8 */
    LTR_CC_CHNUM_MODULE9                = 9,  /**< ����� ��� ������ c ������� � ����� 9 */
    LTR_CC_CHNUM_MODULE10               = 10, /**< ����� ��� ������ c ������� � ����� 10 */
    LTR_CC_CHNUM_MODULE11               = 11, /**< ����� ��� ������ c ������� � ����� 11 */
    LTR_CC_CHNUM_MODULE12               = 12, /**< ����� ��� ������ c ������� � ����� 12 */
    LTR_CC_CHNUM_MODULE13               = 13, /**< ����� ��� ������ c ������� � ����� 13 */
    LTR_CC_CHNUM_MODULE14               = 14, /**< ����� ��� ������ c ������� � ����� 14 */
    LTR_CC_CHNUM_MODULE15               = 15, /**< ����� ��� ������ c ������� � ����� 15 */
    LTR_CC_CHNUM_MODULE16               = 16, /**< ����� ��� ������ c ������� � ����� 16 */
    /** @cond not_supported */
    LTR_CC_CHNUM_USERDATA               = 18  /**< ����������� ��� �������� ����������������
                                                ������ �� ������. ����� �������������� ������
                                                � ������������������ ���������������� ���������
                                               */
    /** @endcond */
};

/** ������ ������ ����� ltrd ��� ������ ������� ���������� ������ */
enum en_LTR_CC_Iface {
    LTR_CC_IFACE_USB                = 0x0100, /**< ����� ��������, ��� ���������� ������ ����
                                                  � �������, ������������ �� USB-���������� */
    LTR_CC_IFACE_ETH                = 0x0200, /**< ����� ��������, ��� ���������� ������ ����
                                                  � �������, ������������ �� Ethernet (TCP/IP) */
};

/** �������������� ����� ������ ����� � ltrd */
enum en_LTR_CC_Flags {
    /** @cond not_supported */
    LTR_CC_FLAG_RAW_DATA            = 0x4000 /**< ���� ������� --- ltrd �������� �������
                                                  ��� ������, ������� �������� �� ������,
                                                  ��� �������� �� ������� */
    /** @endcond */
};


/** @cond internal */
#define LTR_CC_CHNUM(cc)        ((cc) & 0x00FF)
#define LTR_CC_IFACE(cc)        ((cc) & 0x0F00)
#define LTR_CC_FLAGS(cc)        ((cc) & 0xF000)
/** @endcond */


/** ����� ��������� ���������� */
enum en_LTR_ChStateFlags {
    LTR_FLAG_RBUF_OVF            = (1u<<0),    /**< ���� ������������ ������. ��������� ���
                                                    ��-�� ����, ��� ������ �� �������� ������,
                                                    � ltrd ��������� ������������ ������� �������.
                                                    �������������� � �������� ������ ���� ������ */
    LTR_FLAG_RFULL_DATA          = (1u<<1)     /**< ���� ��������� ������ � ������ �������
                                                    � ������� LTR_GetCrateRawData() */
};

/** ������ ������� �������������� ������ � ��������� ������� */
#define LTR_MID_MODULE(x)             (((x) & 0xFF) | (((x) & 0xFF) << 8))

/** �������������� ������� */
enum en_LTR_MIDs {
    LTR_MID_EMPTY               = 0,                    /**< ������ ���� */
    LTR_MID_IDENTIFYING         = 0xFFFF,               /**< ������ � �������� ����������� ���� */
    LTR_MID_INVALID             = 0xFFFE,               /**< ������ � ���������������� ����������� */
    LTR_MID_LTR01               = LTR_MID_MODULE(1),    /**< ������������� ������ LTR01 */
    LTR_MID_LTR11               = LTR_MID_MODULE(11),   /**< ������������� ������ LTR11 */
    LTR_MID_LTR12               = LTR_MID_MODULE(12),   /**< ������������� ������ LTR11 */
    LTR_MID_LTR22               = LTR_MID_MODULE(22),   /**< ������������� ������ LTR22 */
    LTR_MID_LTR24               = LTR_MID_MODULE(24),   /**< ������������� ������ LTR24 */
    LTR_MID_LTR25               = LTR_MID_MODULE(25),   /**< ������������� ������ LTR25 */
    LTR_MID_LTR27               = LTR_MID_MODULE(27),   /**< ������������� ������ LTR27 */
    LTR_MID_LTR34               = LTR_MID_MODULE(34),   /**< ������������� ������ LTR34 */
    LTR_MID_LTR35               = LTR_MID_MODULE(35),   /**< ������������� ������ LTR35 */
    LTR_MID_LTR41               = LTR_MID_MODULE(41),   /**< ������������� ������ LTR41 */
    LTR_MID_LTR42               = LTR_MID_MODULE(42),   /**< ������������� ������ LTR42 */
    LTR_MID_LTR43               = LTR_MID_MODULE(43),   /**< ������������� ������ LTR43 */
    LTR_MID_LTR51               = LTR_MID_MODULE(51),   /**< ������������� ������ LTR51 */
    LTR_MID_LTR114              = LTR_MID_MODULE(114),  /**< ������������� ������ LTR114 */
    LTR_MID_LTR210              = LTR_MID_MODULE(210),  /**< ������������� ������ LTR210 */
    LTR_MID_LTR212              = LTR_MID_MODULE(212),  /**< ������������� ������ LTR212 */
    LTR_MID_LTR216              = LTR_MID_MODULE(216)   /**< ������������� ������ LTR216 */
};

/** ���� ������� */
enum en_LTR_CrateTypes {
    LTR_CRATE_TYPE_UNKNOWN                      = 0, /**< ����������� ��� ������ */
    LTR_CRATE_TYPE_LTR010                       = 10, /**< ����� LTR-U-8 ��� LTR-U-16 */
    LTR_CRATE_TYPE_LTR021                       = 21, /**< ����� LTR-U-1 */
    LTR_CRATE_TYPE_LTR030                       = 30, /**< ����� LTR-EU-8 ��� LTR-EU-16 */
    LTR_CRATE_TYPE_LTR031                       = 31, /**< ����� LTR-EU-2 */
    /** @cond kd_extension */
    LTR_CRATE_TYPE_LTR032                       = 32, /**< ����� LTR-E-7 ��� LTR-E-15 */
    /** @endcond */
    LTR_CRATE_TYPE_LTR_CU_1                     = 40, /**< ����� LTR-CU-1 */
    LTR_CRATE_TYPE_LTR_CEU_1                    = 41, /**< ����� LTR-CEU-1 */
    LTR_CRATE_TYPE_BOOTLOADER                   = 99  /**< ����� � ������ ����������
                                                           (���� � ���� ������ ������ ������ ���) */
};

/** ��������� ����������� ������ */
enum en_LTR_CrateIface {
    LTR_CRATE_IFACE_UNKNOWN             = 0, /**< ������������ ��� ���������� ������.
                                                          ��� �������� � ������� ������ ��������
                                                          ����� ���������, ��� ��������� �����������
                                                          ������ �� ����� �������� */
    LTR_CRATE_IFACE_USB                 = 1, /**< ����� ��������� �� ���������� USB */
    LTR_CRATE_IFACE_TCPIP               = 2  /**< ����� ��������� �� Ethernet (TCP/IP) */
};


/** ��������� ���������� � �������, ��������������� ������ � IP-������� */
enum en_LTR_CrateIpStatus {
    LTR_CRATE_IP_STATUS_OFFLINE                = 0, /**< ����� �� ��������� */
    LTR_CRATE_IP_STATUS_CONNECTING             = 1, /**< ���� ������� ��������� ���������� � �������
                                                         (�������� ��������, �� ��� �� ���������) */
    LTR_CRATE_IP_STATUS_ONLINE                 = 2, /**< ����� ��������� */
    LTR_CRATE_IP_STATUS_ERROR                  = 3  /**< ������ ����������� ������.
                                                         ���������� ���������� �� �������. */
};

/** �����, ��������������� ������ � IP-������� ������ */
enum en_LTR_CrateIpFlags {
    /** ���� ���������, ��� ������ ltrd ������ ��� ������ ��� ��� �����������
        ����� ���� ������ ��������� ����������� � ������ � IP-�������,
        ��������������� ������ ������ */
    LTR_CRATE_IP_FLAG_AUTOCONNECT              =  0x1,
    /** ���� ���������, ��� ��� ������ ��������� ���������� � �������
        ��� ��� ������� ����� �� ������ � ���������� ������� ������ ltrd ������
        ��������� ����� ������� �����������. ���� ���� �� ����������, �� � ����
        ������� ������ ��������� � ��������� #LTR_CRATE_IP_STATUS_ERROR � �������
        �������� ������ �� �����������. ���� ���� ����������, �� ����� ��������
        �������� ������� ����� ������������ ����� ������� ���������� �
        ��� ������� ����� ����������� �� ��� ���, ���� ���������� �� �����
        �����������,  ���� ���� �� ����� ��������� ����� ������� ������� ����������,
        ���� ���� ���� ��� ������� ��������������� ������ � IP-�������.

        ������ ����������� �������� ������� � ������ ltrd 2.1.5.0 � ltrapi 1.31.1. */
    LTR_CRATE_IP_FLAG_RECONNECT                =  0x2
};




/** ������ ������ � ��������� ������ � �������� ������ */
#define LTR_MODULE_NAME_SIZE                16
/** ������ ������ � ���������`���������� � �������� ������ */
#define LTR_CRATE_DEVNAME_SIZE              32
/** ������ ������ � �������� ������� ������ */
#define LTR_CRATE_SERIAL_SIZE               16
/** ������ ������ � ������� �������� ������ � ��� �������� */
#define LTR_CRATE_SOFTVER_SIZE              32
/** ������ ������ � �������� ������ � ��� �������� */
#define LTR_CRATE_REVISION_SIZE             16
/** ������ ������ � ��������� ����� ����� � �������� ������ */
#define LTR_CRATE_BOARD_OPTIONS_SIZE       16
/** ������ ������ � ������� ���������� � �������� ������ */
#define LTR_CRATE_BOOTVER_SIZE              16
/** ������ ������ � ��������� ���������� � �������� ������ */
#define LTR_CRATE_CPUTYPE_SIZE              16
/** ������ ������ � ��������� ���� ������ */
#define LTR_CRATE_TYPE_NAME                 16
/** ������ �������������� ���������� � ������ */
#define LTR_CRATE_SPECINFO_SIZE             48
/** ������ ������ � ��������� ���� FPGA � �������� ������ */
#define LTR_CRATE_FPGA_NAME_SIZE            32
/** ������ ������ � ������� �������� FPGA � �������� ������ */
#define LTR_CRATE_FPGA_VERSION_SIZE         32

/** ������������ ���-�� ����������� � ������, ��������� ������� ������������ � ���������� */
#define LTR_CRATE_THERM_MAX_CNT              8


/** ����� �� �������� ������ */
enum en_LTR_ModuleDescrFlags {
    LTR_MODULE_FLAGS_HIGH_BAUD          = 0x0001, /**< �������, ��� ������ ����������
                                                       ������� �������� ����������
                                                       �������� ���� � ������ */
    LTR_MODULE_FLAGS_USE_HARD_SEND_FIFO = 0x0100, /**< �������, ��� ������ ���������� ����������
                                                       ����������� ����������� FIFO �� ��������
                                                       ������ */
    LTR_MODULE_FLAGS_USE_SYNC_MARK      = 0x0200  /**< �������, ��� ������ ������������
                                                       ������������� ����������� */
};

/** @cond kd_extension */
#define LTR_CARD_START_OFF (0)
#define LTR_CARD_START_RUN (1)
/** @endcond */


/** ������� �� ��������� � �� �� ���������� �������� � ltrd */
#define LTR_DEFAULT_SEND_RECV_TIMEOUT   10000UL


/** ����� ������ ������ */
enum en_LTR_CrateMode {
    LTR_CRATE_MODE_BOOTLOADER = 1, /**< ����� ��������� � ��������� ���������� */
    LTR_CRATE_MODE_WORK       = 2, /**< ����� ��������� � ������� ��������� */
    LTR_CRATE_MODE_CONTROL    = 3  /**< ����� ��������� � ���������, ����� ���������
                                     ������ ����������� ������� (��������, ����
                                     ����� ��������� �� �� ���� ����������, �� �������
                                     ��������) */
};


/** @brief ��������� ����

    ���������, ������������ ������� ��������� ���� ������. ������ ���������
    ������������ � �������� ������ � ������� � ltrapi, �.�. �������� ������ ���
    ������ �������, �� ��� ���� �� ������������ ��������� ������ ���������� */
typedef enum {
    LTR_FPGA_STATE_NO_POWER       = 0x0, /**< ��� ������� ������� ���� */
    LTR_FPGA_STATE_NSTATUS_TOUT   = 0x1, /**< ������� ����� �������� ����������
                                                ���� � �������� */
    LTR_FPGA_STATE_CONF_DONE_TOUT = 0x2, /**< ������� ����� �������� ����������
                                                �������� ���� (������ ��������,
                                                ��� �� Flash ��� ��������������
                                                ��������) */
    LTR_FPGA_STATE_LOAD_PROGRESS  = 0x3, /**< ���� �������� ���� */
    LTR_FPGA_STATE_POWER_ON       = 0x4, /**< ��������� ����� POWER_ON. ��������������
                                              � ���, ��� ���� ����������� ������ ������� */
    LTR_FPGA_STATE_LOAD_DONE      = 0x7, /**< �������� ���� ���������,
                                                �� ������ ���� ��� �� ��������� */
    LTR_FPGA_STATE_WORK           = 0xF  /**< ���������� ������� ��������� ���� */
} e_LTR_FPGA_STATE;
/*================================================================================================*/

/** @} */

#endif /*#ifndef LTRAPIDEFINE_H_*/
