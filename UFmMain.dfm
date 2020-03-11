object Form1: TForm1
  Left = 0
  Top = 0
  Caption = #32593#32476#36830#25509#29366#24577' / DOS '#21629#20196#25191#34892
  ClientHeight = 524
  ClientWidth = 872
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
  object StatusBar1: TStatusBar
    Left = 0
    Top = 505
    Width = 872
    Height = 19
    Panels = <
      item
        Width = 80
      end>
  end
  object Panel1: TPanel
    Left = 664
    Top = 57
    Width = 208
    Height = 448
    Align = alRight
    TabOrder = 1
    object Button1: TButton
      Left = 6
      Top = 6
      Width = 75
      Height = 25
      Action = AcNetstat
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
      TabOrder = 0
    end
    object Button2: TButton
      Left = 6
      Top = 175
      Width = 75
      Height = 25
      Action = AcFilterNetstat
      TabOrder = 1
    end
    object RadioGroup1: TRadioGroup
      Left = 5
      Top = 37
      Width = 185
      Height = 105
      Caption = #36807#28388
      Items.Strings = (
        #22806#37096'IP'
        #26412#22320#31471#21475
        #22806#37096#31471#21475
        'PID')
      TabOrder = 2
    end
    object EditFilter: TEdit
      Left = 6
      Top = 148
      Width = 187
      Height = 21
      ImeName = #35895#27468#25340#38899#36755#20837#27861' 2'
      TabOrder = 3
    end
    object Button3: TButton
      Left = 6
      Top = 206
      Width = 75
      Height = 25
      Action = AcCancelFilter
      TabOrder = 4
    end
    object Button4: TButton
      Left = 6
      Top = 280
      Width = 75
      Height = 25
      Action = AcDos
      TabOrder = 5
    end
    object EditCmd: TEdit
      Left = 8
      Top = 256
      Width = 185
      Height = 21
      ImeName = #35895#27468#25340#38899#36755#20837#27861' 2'
      TabOrder = 6
      Text = 'Dir'
    end
    object CheckBox1: TCheckBox
      Left = 88
      Top = 8
      Width = 97
      Height = 17
      Caption = #20445#25345#36807#28388
      TabOrder = 7
    end
    object Button6: TButton
      Left = 32
      Top = 376
      Width = 75
      Height = 25
      Caption = 'Button6'
      TabOrder = 8
      OnClick = Button6Click
    end
    object Button7: TButton
      Left = 32
      Top = 408
      Width = 75
      Height = 25
      Caption = 'Button7'
      TabOrder = 9
      OnClick = Button7Click
    end
  end
  object Panel2: TPanel
    Left = 0
    Top = 0
    Width = 872
    Height = 57
    Align = alTop
    TabOrder = 2
    object Button5: TButton
      Left = 24
      Top = 16
      Width = 75
      Height = 25
      Caption = 'ARP'
      TabOrder = 0
      OnClick = Button5Click
    end
  end
  object Panel3: TPanel
    Left = 0
    Top = 57
    Width = 664
    Height = 448
    Align = alClient
    TabOrder = 3
    object DBGrid1: TDBGrid
      Left = 1
      Top = 1
      Width = 662
      Height = 446
      Align = alClient
      DataSource = DataSource1
      ImeName = #35895#27468#25340#38899#36755#20837#27861' 2'
      ReadOnly = True
      TabOrder = 0
      TitleFont.Charset = DEFAULT_CHARSET
      TitleFont.Color = clWindowText
      TitleFont.Height = -11
      TitleFont.Name = 'Tahoma'
      TitleFont.Style = []
      OnTitleClick = DBGrid1TitleClick
    end
  end
  object ActionList1: TActionList
    Left = 544
    Top = 80
    object AcNetstat: TAction
      Caption = 'Netstat'
      Hint = #25191#34892'Netstat'
      OnExecute = AcNetstatExecute
    end
    object AcFilterNetstat: TAction
      Caption = #36807#28388
      OnExecute = AcFilterNetstatExecute
    end
    object AcCancelFilter: TAction
      Caption = #21462#28040#36807#28388
      OnExecute = AcCancelFilterExecute
    end
    object AcDos: TAction
      Caption = 'Dos'#21629#20196
      OnExecute = AcDosExecute
    end
  end
  object DataSource1: TDataSource
    DataSet = DMARP.CldNetstat
    Left = 552
    Top = 208
  end
end
