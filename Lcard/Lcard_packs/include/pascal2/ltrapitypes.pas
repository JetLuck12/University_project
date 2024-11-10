unit ltrapitypes;
interface
uses SysUtils, ltrapidefine;

const
      COMMENT_LENGTH =256;
      ADC_CALIBRATION_NUMBER =256;
      DAC_CALIBRATION_NUMBER =256;
type
    {$A4}

    SERNUMtext=array[0..15]of AnsiChar;

    TLTR_CRATE_INFO=record
      CrateType:byte;
      CrateInterface:byte;
    end;


     TLTR_DESCRIPTION_MODULE=record
      CompanyName:array[0..16-1]of AnsiChar;                     //
      DeviceName:array[0..16-1]of AnsiChar;                      // �������� �������
      SerialNumber:array[0..16-1]of AnsiChar;                    // �������� ����� �������
      Revision:byte;                                       // ������� �������
      Comment:array[0..256-1]of AnsiChar;           //
    end;

    // �������� ���������� � ����������� �����������
    TLTR_DESCRIPTION_CPU=record
      Active:byte;                                         // ���� ������������� ��������� ����� ���������
      Name:array[0..15]of AnsiChar;                            // ��������
      ClockRate:double;                                    //
      FirmwareVersion:LongWord;                            //
      Comment:array[0..COMMENT_LENGTH-1]of AnsiChar;           //
    end;
    // �������� ����
    TLTR_DESCRIPTION_FPGA=record
      Active:byte;                                         // ���� ������������� ��������� ����� ���������
      Name:array[0..15]of AnsiChar;                            // ��������
      ClockRate:double;                                    //
      FirmwareVersion:LongWord;                            //
      Comment:array[0..COMMENT_LENGTH-1]of AnsiChar;           //
    end;
    // �������� ���
    TLTR_DESCRIPTION_ADC=record
      Active:byte;                                         // ���� ������������� ��������� ����� ���������
      Name:array[0..15]of AnsiChar;                            // ��������
      Calibration:array[0..ADC_CALIBRATION_NUMBER-1]of double;// ���������������� ������������
      Comment:array[0..COMMENT_LENGTH-1]of AnsiChar;           //
    end;

    TLTR_DESCRIPTION_DAC=record
      Active:byte;                                         // ���� ������������� ��������� ����� ���������
      Name:array[0..15]of AnsiChar;                            // ��������
      Calibration:array[0..ADC_CALIBRATION_NUMBER-1]of double;// ���������������� ������������
      Comment:array[0..COMMENT_LENGTH-1]of AnsiChar;           //
    end;
    // �������� h-���������
    TLTR_DESCRIPTION_MEZZANINE=record
      Active:byte;                                         // ���� ������������� ��������� ����� ���������
      Name:array[0..15]of AnsiChar;
      SerialNumber:array[0..15]of AnsiChar;                    // �������� ����� �������
      Revision:Byte;                                       // ������� �������
      Calibration:array[0..3]of double;                    // ���������������� ������������
      Comment:array[0..COMMENT_LENGTH-1]of AnsiChar;           // �����������
    end;
    // �������� ��������� ��
    TLTR_DESCRIPTION_DIGITAL_IO=record
      Active:byte;                                         // ���� ������������� ��������� ����� ���������
      Name:array[0..15]of AnsiChar;                            // �������� ???????
      InChannels:word;                                     // ����� �������
      OutChannels:word;                                    // ����� �������
      Comment:array[0..COMMENT_LENGTH-1]of AnsiChar;           // �����������
    end;
    // �������� ������������ �������
    TLTR_DESCRIPTION_INTERFACE=record
      Active:BYTE;                                         // ���� ������������� ��������� ����� ���������
      Name:array[0..15]of AnsiChar;                            // ��������
      Comment:array[0..COMMENT_LENGTH-1]of AnsiChar;           //
    end;
    // ������� ������ IP-�������
    TLTR_CRATE_IP_ENTRY=record
      ip_addr:LongWord;                                          // IP ����� (host-endian)
      flags:LongWord;                                            // ����� ������� (CRATE_IP_FLAG_...)
      serial_number:array[0..15]of AnsiChar;                  // �������� ����� (���� ����� ���������)
      is_dynamic:byte;                                        // 0 = ����� �������������, 1 = ������ �������������
      status:byte;                                            // ��������� (CRATE_IP_STATUS_...)
    end;

    // ���������� ������
    TLTR_CRATE_STATISTIC=record
      size : LongWord;
      flags : LongWord;
      crate_type : Word;
      crate_intf : Word;
      crate_state : Word;
      crate_mode : Word;
      con_time : UInt64;
      res : array[0..11-1] of Word;
      modules_cnt : Word;
      mids : array[0..LTR_MODULES_PER_CRATE_MAX - 1] of Word;
      res2 : array[0..3*LTR_MODULES_PER_CRATE_MAX - 1] of Word;
      ctl_clients_cnt : Word;
      total_mod_clients_cnt : Word;
      res3 : array[0..11-1] of LongWord;
      wrd_sent : UInt64;
      wrd_recv : UInt64;
      bw_send : Double;
      bw_recv : Double;
      crate_wrd_recv : UInt64;
      internal_rbuf_miss : UInt64;
      internal_rbuf_ovfls : LongWord;
      rbuf_ovfls : LongWord;
      total_start_marks : LongWord;
      total_sec_marks : LongWord;
      crate_start_marks : LongWord;
      crate_sec_marks : LongWord;
      crate_unixtime : UInt64;
      therm_mask : LongWord;
      therm_vals : array[0..LTR_CRATE_THERM_MAX_CNT-1] of single;
      res4 : array[0..19-1] of LongWord;
    end;

    // ���������� ������
    TLTR_MODULE_STATISTIC=record
      size : LongWord;
      client_cnt : Word;
      mid : Word;
      flags : LongWord;
      name : Array[0..LTR_MODULE_NAME_SIZE-1] of AnsiChar;
      res  : Array[0..5-1] of LongWord;
      wrd_sent :  UInt64;
      wrd_recv : UInt64;
      bw_send : Double;
      bw_recv : Double;
      wrd_sent_to_client : UInt64;
      wrd_recv_from_client : UInt64;
      wrd_recv_drop : UInt64;
      rbuf_ovfls : LongWord;
      send_srvbuf_size : LongWord;
      recv_srvbuf_size : LongWord;
      send_srvbuf_full : LongWord;
      recv_srvbuf_full : LongWord;
      send_srvbuf_full_max : LongWord;
      recv_srvbuf_full_max : LongWord;
      res2 : array[0..17-1] of LongWord;
      start_mark : LongWord;
      sec_mark : LongWord;
      hard_send_fifo_size : LongWord;
      hard_send_fifo_unack_words : LongWord;
      hard_send_fifo_underrun : LongWord;
      hard_send_fifo_overrun : LongWord;
      hard_send_fifo_internal : LongWord;
      res3 : array[0..25-1] of LongWord;
    end;

    // ���������� � ������ � ��� ��������
    TLTR_CRATE_DESCR=record
      size : LongWord;
      devname : array[0..LTR_CRATE_DEVNAME_SIZE-1] of AnsiChar;
      serial : array[0..LTR_CRATE_SERIAL_SIZE-1] of AnsiChar;
      soft_ver : array[0..LTR_CRATE_SOFTVER_SIZE-1] of AnsiChar;
      brd_revision : array[0..LTR_CRATE_REVISION_SIZE-1] of AnsiChar;
      brd_opts : array[0..LTR_CRATE_BOARD_OPTIONS_SIZE-1] of AnsiChar;
      bootloader_ver: array[0..LTR_CRATE_BOOTVER_SIZE-1] of AnsiChar;
      cpu_type : array[0..LTR_CRATE_CPUTYPE_SIZE-1] of AnsiChar;
      fpga_name : array[0..LTR_CRATE_FPGA_NAME_SIZE-1] of AnsiChar;
      fpga_version : array[0..LTR_CRATE_FPGA_VERSION_SIZE-1] of AnsiChar;
      crate_type_name : array[0..LTR_CRATE_TYPE_NAME-1] of AnsiChar;
      spec_info : array[0..LTR_CRATE_SPECINFO_SIZE-1] of AnsiChar;
      protocol_ver_major : Byte;
      protocol_ver_minor : Byte;
      slots_config_ver_major : Byte;
      slots_config_ver_minor : Byte;
    end;


{$IFNDEF LTRAPI_DISABLE_COMPAT_DEFS}
    TIPCRATE_ENTRY = TLTR_CRATE_IP_ENTRY;
    TCRATE_INFO = TLTR_CRATE_INFO;
    TDESCRIPTION_MODULE = TLTR_DESCRIPTION_MODULE;
    TDESCRIPTION_CPU = TLTR_DESCRIPTION_CPU;
    TDESCRIPTION_FPGA = TLTR_DESCRIPTION_FPGA;
    TDESCRIPTION_ADC = TLTR_DESCRIPTION_ADC;
    TDESCRIPTION_DAC = TLTR_DESCRIPTION_DAC;
    TDESCRIPTION_MEZZANINE = TLTR_DESCRIPTION_MEZZANINE;
    TDESCRIPTION_DIGITAL_IO = TLTR_DESCRIPTION_DIGITAL_IO;
    TDESCRIPTION_INTERFACE = TLTR_DESCRIPTION_INTERFACE;
{$ENDIF}

    {$A+}

implementation
end.
