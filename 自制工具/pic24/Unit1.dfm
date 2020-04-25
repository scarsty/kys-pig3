object Form1: TForm1
  Left = 198
  Top = 181
  BorderIcons = [biSystemMenu, biMinimize]
  BorderStyle = bsSingle
  Caption = 'Combine Fight Images'
  ClientHeight = 273
  ClientWidth = 371
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object Label4: TLabel
    Left = 272
    Top = 32
    Width = 89
    Height = 22
    Alignment = taCenter
    AutoSize = False
    Caption = '0/0'
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -19
    Font.Name = 'Courier New'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object GroupBox1: TGroupBox
    Left = 16
    Top = 72
    Width = 337
    Height = 97
    TabOrder = 0
    object Label1: TLabel
      Left = 16
      Top = 24
      Width = 20
      Height = 13
      Caption = 'from'
    end
    object Label2: TLabel
      Left = 96
      Top = 24
      Width = 9
      Height = 13
      Caption = 'to'
    end
    object Label3: TLabel
      Left = 184
      Top = 24
      Width = 24
      Height = 13
      Caption = 'back'
    end
    object SpeedButton2: TSpeedButton
      Left = 288
      Top = 56
      Width = 23
      Height = 22
      Hint = 'Browse IDX file as the model.'
      HelpType = htKeyword
      Glyph.Data = {
        76010000424D7601000000000000760000002800000020000000100000000100
        04000000000000010000120B0000120B00001000000000000000000000000000
        800000800000008080008000000080008000808000007F7F7F00BFBFBF000000
        FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00555555555555
        5555555555555555555555555555555555555555555555555555555555555555
        555555555555555555555555555555555555555FFFFFFFFFF555550000000000
        55555577777777775F55500B8B8B8B8B05555775F555555575F550F0B8B8B8B8
        B05557F75F555555575F50BF0B8B8B8B8B0557F575FFFFFFFF7F50FBF0000000
        000557F557777777777550BFBFBFBFB0555557F555555557F55550FBFBFBFBF0
        555557F555555FF7555550BFBFBF00055555575F555577755555550BFBF05555
        55555575FFF75555555555700007555555555557777555555555555555555555
        5555555555555555555555555555555555555555555555555555}
      NumGlyphs = 2
      ParentShowHint = False
      ShowHint = True
      OnClick = SpeedButton2Click
    end
    object Edit1: TEdit
      Left = 224
      Top = 56
      Width = 57
      Height = 21
      TabOrder = 0
      Text = 'fight'
    end
    object Edit3: TEdit
      Left = 56
      Top = 16
      Width = 25
      Height = 21
      TabOrder = 1
      Text = '1'
    end
    object Edit4: TEdit
      Left = 120
      Top = 16
      Width = 25
      Height = 21
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
      TabOrder = 2
      Text = '1'
    end
    object Edit5: TEdit
      Left = 224
      Top = 16
      Width = 25
      Height = 21
      TabOrder = 3
      Text = '70'
    end
    object Edit9: TEdit
      Left = 256
      Top = 16
      Width = 25
      Height = 21
      TabOrder = 4
      Text = '70'
    end
    object Edit10: TEdit
      Left = 288
      Top = 16
      Width = 25
      Height = 21
      TabOrder = 5
      Text = '30'
    end
    object CheckBox1: TCheckBox
      Left = 16
      Top = 64
      Width = 57
      Height = 17
      Caption = 'fight'
      TabOrder = 6
    end
    object CheckBox2: TCheckBox
      Left = 160
      Top = 64
      Width = 57
      Height = 17
      Caption = 'model'
      TabOrder = 7
    end
    object CheckBox3: TCheckBox
      Left = 80
      Top = 64
      Width = 65
      Height = 17
      Caption = 'append'
      TabOrder = 8
    end
  end
  object GroupBox2: TGroupBox
    Left = 16
    Top = 16
    Width = 249
    Height = 49
    TabOrder = 1
    object SpeedButton1: TSpeedButton
      Left = 200
      Top = 16
      Width = 23
      Height = 22
      Hint = 'Browse BMP file,'
      HelpType = htKeyword
      Glyph.Data = {
        76010000424D7601000000000000760000002800000020000000100000000100
        04000000000000010000120B0000120B00001000000000000000000000000000
        800000800000008080008000000080008000808000007F7F7F00BFBFBF000000
        FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00555555555555
        5555555555555555555555555555555555555555555555555555555555555555
        555555555555555555555555555555555555555FFFFFFFFFF555550000000000
        55555577777777775F55500B8B8B8B8B05555775F555555575F550F0B8B8B8B8
        B05557F75F555555575F50BF0B8B8B8B8B0557F575FFFFFFFF7F50FBF0000000
        000557F557777777777550BFBFBFBFB0555557F555555557F55550FBFBFBFBF0
        555557F555555FF7555550BFBFBF00055555575F555577755555550BFBF05555
        55555575FFF75555555555700007555555555557777555555555555555555555
        5555555555555555555555555555555555555555555555555555}
      NumGlyphs = 2
      ParentShowHint = False
      ShowHint = True
      OnClick = SpeedButton1Click
    end
    object Edit6: TEdit
      Left = 16
      Top = 16
      Width = 73
      Height = 21
      TabOrder = 0
      Text = 'Name'
    end
    object Edit8: TEdit
      Left = 144
      Top = 16
      Width = 41
      Height = 21
      TabOrder = 1
    end
    object Edit7: TEdit
      Left = 96
      Top = 16
      Width = 41
      Height = 21
      Enabled = False
      TabOrder = 2
      Text = 'num'
    end
  end
  object GroupBox3: TGroupBox
    Left = 16
    Top = 176
    Width = 337
    Height = 57
    Caption = 'Target'
    TabOrder = 2
    object Label6: TLabel
      Left = 16
      Top = 28
      Width = 27
      Height = 13
      Caption = 'target'
    end
    object BitBtn1: TBitBtn
      Left = 176
      Top = 16
      Width = 65
      Height = 25
      Caption = 'trans'
      TabOrder = 0
      OnClick = BitBtn1Click
      Glyph.Data = {
        76010000424D7601000000000000760000002800000020000000100000000100
        04000000000000010000120B0000120B00001000000000000000000000000000
        800000800000008080008000000080008000808000007F7F7F00BFBFBF000000
        FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00555555000000
        000055555F77777777775555000FFFFFFFF0555F777F5FFFF55755000F0F0000
        FFF05F777F7F77775557000F0F0FFFFFFFF0777F7F7F5FFFFFF70F0F0F0F0000
        00F07F7F7F7F777777570F0F0F0FFFFFFFF07F7F7F7F5FFFFFF70F0F0F0F0000
        00F07F7F7F7F777777570F0F0F0FFFFFFFF07F7F7F7F5FFF55570F0F0F0F000F
        FFF07F7F7F7F77755FF70F0F0F0FFFFF00007F7F7F7F5FF577770F0F0F0F00FF
        0F057F7F7F7F77557F750F0F0F0FFFFF00557F7F7F7FFFFF77550F0F0F000000
        05557F7F7F77777775550F0F0000000555557F7F7777777555550F0000000555
        55557F7777777555555500000005555555557777777555555555}
      NumGlyphs = 2
    end
    object BitBtn2: TBitBtn
      Left = 256
      Top = 16
      Width = 65
      Height = 25
      Caption = 'exit'
      TabOrder = 1
      OnClick = BitBtn2Click
      Glyph.Data = {
        76010000424D7601000000000000760000002800000020000000100000000100
        04000000000000010000130B0000130B00001000000000000000000000000000
        800000800000008080008000000080008000808000007F7F7F00BFBFBF000000
        FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00333333333333
        3333333333FFFFF3333333333999993333333333F77777FFF333333999999999
        33333337777FF377FF3333993370739993333377FF373F377FF3399993000339
        993337777F777F3377F3393999707333993337F77737333337FF993399933333
        399377F3777FF333377F993339903333399377F33737FF33377F993333707333
        399377F333377FF3377F993333101933399377F333777FFF377F993333000993
        399377FF3377737FF7733993330009993933373FF3777377F7F3399933000399
        99333773FF777F777733339993707339933333773FF7FFF77333333999999999
        3333333777333777333333333999993333333333377777333333}
      NumGlyphs = 2
    end
    object Edit2: TEdit
      Left = 72
      Top = 20
      Width = 89
      Height = 21
      TabOrder = 2
      Text = 'fight000'
    end
  end
  object ProgressBar1: TProgressBar
    Left = 16
    Top = 240
    Width = 337
    Height = 17
    TabOrder = 3
  end
  object OpenDialog1: TOpenDialog
    Filter = 'BMP Files.|*.bmp'
  end
  object OpenDialog2: TOpenDialog
    Filter = '*.idx|*.idx'
    Left = 32
  end
  object XPManifest1: TXPManifest
    Left = 336
    Top = 8
  end
end
