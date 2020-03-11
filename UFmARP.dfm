object FmARP: TFmARP
  Left = 0
  Top = 0
  Caption = 'ARP'#21015#34920
  ClientHeight = 300
  ClientWidth = 635
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 635
    Height = 65
    Align = alTop
    TabOrder = 0
    object Button1: TButton
      Left = 24
      Top = 16
      Width = 75
      Height = 25
      Caption = #21047#26032
      TabOrder = 0
      OnClick = Button1Click
    end
  end
  object Panel2: TPanel
    Left = 400
    Top = 65
    Width = 235
    Height = 235
    Align = alRight
    TabOrder = 1
  end
  object DBGrid1: TDBGrid
    Left = 0
    Top = 65
    Width = 400
    Height = 235
    Align = alClient
    DataSource = DataSource1
    ImeName = #20013#25991'('#31616#20307') - '#24517#24212' Bing '#36755#20837#27861
    TabOrder = 2
    TitleFont.Charset = DEFAULT_CHARSET
    TitleFont.Color = clWindowText
    TitleFont.Height = -11
    TitleFont.Name = 'Tahoma'
    TitleFont.Style = []
  end
  object DataSource1: TDataSource
    DataSet = CldARP
    Left = 184
    Top = 144
  end
  object CldARP: TClientDataSet
    Active = True
    Aggregates = <>
    Params = <>
    Left = 96
    Top = 144
    Data = {
      490000009619E0BD010000001800000002000000000003000000490002495001
      00490000000100055749445448020002001000034D4143010049000000010005
      57494454480200020011000000}
    object CldARPIP: TStringField
      DisplayWidth = 28
      FieldName = 'IP'
      Size = 16
    end
    object CldARPMAC: TStringField
      DisplayWidth = 45
      FieldName = 'MAC'
      Size = 17
    end
  end
end
