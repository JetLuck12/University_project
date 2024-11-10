unit ltrapitypes;
interface
uses windows, SysUtils;

const
      COMMENT_LENGTH =256;
      ADC_CALIBRATION_NUMBER =256;
      DAC_CALIBRATION_NUMBER =256;
type
   // char16=array[0..15]of char;
    SERNUMtext=array[0..15]of char;

    TCRATE_INFO=record
      CrateType:byte;
      CrateInterface:byte;
    end;


    TDESCRIPTION_MODULE=record
      CompanyName:array[1..16]of char;                     //
      DeviceName:array[1..16]of char;                      // �������� �������
      SerialNumber:array[1..16]of char;                    // �������� ����� �������
      Revision:byte;                                       // ������� �������
      Comment:array[0..256-1]of char;           //
    end;

// �������� ���������� � ����������� �����������
    TDESCRIPTION_CPU=record
      Active:byte;                                         // ���� ������������� ��������� ����� ���������
      Name:array[0..15]of char;                            // ��������
      ClockRate:double;                                    //
      FirmwareVersion:Cardinal;                            //
      Comment:array[0..COMMENT_LENGTH-1]of char;           //
    end;
// �������� ����
    TDESCRIPTION_FPGA=record
      Active:byte;                                         // ���� ������������� ��������� ����� ���������
      Name:array[0..15]of char;                            // ��������
      ClockRate:double;                                    //
      FirmwareVersion:Cardinal;                            //
      Comment:array[0..COMMENT_LENGTH-1]of char;           //
    end;
// �������� ���
    TDESCRIPTION_ADC=record
      Active:byte;                                         // ���� ������������� ��������� ����� ���������
      Name:array[0..15]of char;                            // ��������
      Calibration:array[0..ADC_CALIBRATION_NUMBER-1]of double;// ���������������� ������������
      Comment:array[0..COMMENT_LENGTH-1]of char;           //
    end;

    TDESCRIPTION_DAC =record
      Active:byte;                                         // ���� ������������� ��������� ����� ���������
      Name:array[0..15]of char;                            // ��������
      Calibration:array[0..ADC_CALIBRATION_NUMBER-1]of double;// ���������������� ������������
      Comment:array[0..COMMENT_LENGTH-1]of char;           //
    end;
// �������� h-���������
    TDESCRIPTION_MEZZANINE=record
      Active:byte;                                         // ���� ������������� ��������� ����� ���������
      Name:array[0..15]of char;
      SerialNumber:array[0..15]of char;                    // �������� ����� �������
      Revision:Byte;                                       // ������� �������
      Calibration:array[0..3]of double;                    // ���������������� ������������
      Comment:array[0..COMMENT_LENGTH-1]of char;           // �����������
    end;
// �������� ��������� ��
    TDESCRIPTION_DIGITAL_IO=record
      Active:byte;                                         // ���� ������������� ��������� ����� ���������
      Name:array[0..15]of char;                            // �������� ???????
      InChannels:word;                                     // ����� �������
      OutChannels:word;                                    // ����� �������
      Comment:array[0..COMMENT_LENGTH-1]of char;           // �����������
    end;
// �������� ������������ �������
    TDESCRIPTION_INTERFACE=record
      Active:BYTE;                                         // ���� ������������� ��������� ����� ���������
      Name:array[0..15]of char;                            // ��������
      Comment:array[0..COMMENT_LENGTH-1]of char;           //
    end;
  // ������� ������ IP-�������
  TIPCRATE_ENTRY=record
    ip_addr:DWORD;                                          // IP ����� (host-endian)
    flags:DWORD;                                            // ����� ������� (CRATE_IP_FLAG_...)
    serial_number:array[0..15]of CHAR;                                 // �������� ����� (���� ����� ���������)
    is_dynamic:byte;                                        // 0 = ����� �������������, 1 = ������ �������������
    status:byte;                                            // ��������� (CRATE_IP_STATUS_...)
  end;



implementation
end.
