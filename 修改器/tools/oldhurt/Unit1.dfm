object Form1: TForm1
  Left = 109
  Top = 114
  BorderIcons = [biSystemMenu, biMinimize]
  BorderStyle = bsSingle
  Caption = 'Main'
  ClientHeight = 473
  ClientWidth = 756
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Scaled = False
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object GroupBox1: TGroupBox
    Left = 32
    Top = 24
    Width = 417
    Height = 265
    Caption = #22522#26412#20260#23475#20844#24335'('#21452#26041#27494#23398#24120#35782#22240#23376#21482#33021#20026'0,1,2.'#27494#23398#25915#20987#22240#23376#21482#33021#20026'2,1,1/2.)'
    TabOrder = 1
    object Label1: TLabel
      Left = 24
      Top = 32
      Width = 114
      Height = 13
      Caption = #26368#20302#26377#25928#27494#23398#24120#35782'      '
    end
    object Label2: TLabel
      Left = 24
      Top = 64
      Width = 153
      Height = 13
      Caption = #25915#26041#27494#23398#24120#35782#22240#23376'                   '
    end
    object Label3: TLabel
      Left = 232
      Top = 64
      Width = 141
      Height = 13
      Caption = #23432#26041#27494#23398#24120#35782#22240#23376'               '
    end
    object Label4: TLabel
      Left = 24
      Top = 112
      Width = 120
      Height = 13
      Caption = #22522#26412#25915#20987#22240#23376'                '
    end
    object Label5: TLabel
      Left = 232
      Top = 112
      Width = 93
      Height = 13
      Caption = #27494#23398#25915#20987#22240#23376'       '
    end
    object Label6: TLabel
      Left = 24
      Top = 144
      Width = 84
      Height = 13
      Caption = #38450#24481#22240#23376'            '
    end
    object Label7: TLabel
      Left = 24
      Top = 192
      Width = 78
      Height = 13
      Caption = #20260#23475#22240#23376'          '
    end
    object Label9: TLabel
      Left = 24
      Top = 224
      Width = 108
      Height = 13
      Caption = #38543#26426#25915#20987#19978#38480'            '
    end
    object Label10: TLabel
      Left = 232
      Top = 224
      Width = 108
      Height = 13
      Caption = #38543#26426#38450#24481#19978#38480'            '
    end
    object Edit1: TEdit
      Left = 152
      Top = 24
      Width = 33
      Height = 21
      TabOrder = 0
      Text = '0'
    end
    object Edit2: TEdit
      Left = 152
      Top = 56
      Width = 33
      Height = 21
      TabOrder = 1
      Text = '0'
    end
    object Edit4: TEdit
      Left = 152
      Top = 104
      Width = 33
      Height = 21
      TabOrder = 2
      Text = '0'
    end
    object Edit5: TEdit
      Left = 360
      Top = 104
      Width = 33
      Height = 21
      TabOrder = 3
      Text = '0'
    end
    object Edit6: TEdit
      Left = 152
      Top = 136
      Width = 33
      Height = 21
      TabOrder = 4
      Text = '0'
    end
    object Edit7: TEdit
      Left = 152
      Top = 184
      Width = 33
      Height = 21
      TabOrder = 5
      Text = '0'
    end
    object Edit8: TEdit
      Left = 152
      Top = 216
      Width = 33
      Height = 21
      TabOrder = 6
      Text = '0'
    end
    object Edit9: TEdit
      Left = 360
      Top = 216
      Width = 33
      Height = 21
      TabOrder = 7
      Text = '0'
    end
    object Edit3: TEdit
      Left = 360
      Top = 56
      Width = 33
      Height = 21
      TabOrder = 8
      Text = '0'
    end
  end
  object Button1: TButton
    Left = 480
    Top = 360
    Width = 75
    Height = 25
    Caption = #35835#21462
    TabOrder = 0
    OnClick = Button1Click
  end
  object GroupBox2: TGroupBox
    Left = 32
    Top = 304
    Width = 417
    Height = 137
    Caption = #22791#29992#20260#23475#20844#24335
    TabOrder = 2
    object Label11: TLabel
      Left = 25
      Top = 36
      Width = 108
      Height = 13
      Caption = #22791#29992#25915#20987#22240#23376'            '
    end
    object Label12: TLabel
      Left = 25
      Top = 68
      Width = 129
      Height = 13
      Caption = #22791#29992#38543#26426#25915#20987#19978#38480'           '
    end
    object Label13: TLabel
      Left = 233
      Top = 68
      Width = 123
      Height = 13
      Caption = #22791#29992#38543#26426#38450#24481#19979#38480'         '
    end
    object Edit10: TEdit
      Left = 152
      Top = 28
      Width = 33
      Height = 21
      TabOrder = 0
      Text = '0'
    end
    object Edit11: TEdit
      Left = 152
      Top = 60
      Width = 33
      Height = 21
      TabOrder = 1
      Text = '0'
    end
    object Edit12: TEdit
      Left = 360
      Top = 60
      Width = 33
      Height = 21
      TabOrder = 2
      Text = '0'
    end
  end
  object Button2: TButton
    Left = 656
    Top = 360
    Width = 75
    Height = 25
    Caption = #35828#26126
    TabOrder = 3
    OnClick = Button2Click
  end
  object BitBtn1: TBitBtn
    Left = 568
    Top = 360
    Width = 75
    Height = 25
    Caption = #20889#20837
    TabOrder = 4
    OnClick = BitBtn1Click
  end
  object Button3: TButton
    Left = 480
    Top = 400
    Width = 75
    Height = 25
    Caption = #27983#35272
    TabOrder = 5
    OnClick = Button3Click
  end
  object Edit14: TEdit
    Left = 568
    Top = 400
    Width = 161
    Height = 21
    TabOrder = 6
    Text = '.\z.dat'
  end
  object GroupBox3: TGroupBox
    Left = 472
    Top = 24
    Width = 257
    Height = 313
    Caption = #20854#20182
    TabOrder = 7
    object Label8: TLabel
      Left = 32
      Top = 48
      Width = 90
      Height = 13
      Caption = #20013#27602#31243#24230#25351#25968'      '
    end
    object Label14: TLabel
      Left = 32
      Top = 88
      Width = 90
      Height = 13
      Caption = #20013#27602#25439#34880#22240#23376'      '
    end
    object Label15: TLabel
      Left = 32
      Top = 128
      Width = 78
      Height = 13
      Caption = #21307#30103#38656#20307#21147'      '
    end
    object Label16: TLabel
      Left = 32
      Top = 168
      Width = 90
      Height = 13
      Caption = #22686#24378#21307#30103#22240#23376'      '
    end
    object Label17: TLabel
      Left = 32
      Top = 208
      Width = 90
      Height = 13
      Caption = #26263#22120#25216#24039#22240#23376'      '
    end
    object Label18: TLabel
      Left = 32
      Top = 248
      Width = 90
      Height = 13
      Caption = #31354#25381#21319#32423#36895#24230'      '
    end
    object Edit13: TEdit
      Left = 144
      Top = 40
      Width = 89
      Height = 21
      TabOrder = 0
      Text = '0'
    end
    object Edit15: TEdit
      Left = 144
      Top = 80
      Width = 89
      Height = 21
      TabOrder = 1
      Text = '0'
    end
    object Edit16: TEdit
      Left = 144
      Top = 120
      Width = 89
      Height = 21
      TabOrder = 2
      Text = '0'
    end
    object Edit17: TEdit
      Left = 144
      Top = 160
      Width = 89
      Height = 21
      TabOrder = 3
      Text = '0'
    end
    object Edit18: TEdit
      Left = 144
      Top = 200
      Width = 89
      Height = 21
      TabOrder = 4
      Text = '0'
    end
    object Edit19: TEdit
      Left = 144
      Top = 240
      Width = 89
      Height = 21
      TabOrder = 5
      Text = '0'
    end
    object CheckBox1: TCheckBox
      Left = 32
      Top = 283
      Width = 145
      Height = 17
      Caption = #21319#32423#22686#21152#23646#24615#22266#23450'             '
      TabOrder = 6
    end
  end
  object OpenDialog1: TOpenDialog
    DefaultExt = 'dat'
    Filter = 'Z.dat file|*.dat|All types|*.*'
    InitialDir = '.'
  end
  object XPManifest1: TXPManifest
    Left = 32
  end
end
