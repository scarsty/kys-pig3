object Form1: TForm1
  Left = 457
  Top = 208
  BorderIcons = [biSystemMenu, biMinimize]
  BorderStyle = bsSingle
  Caption = 'Talk Patch.'
  ClientHeight = 408
  ClientWidth = 460
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 13
  object GroupBox1: TGroupBox
    Left = 24
    Top = 16
    Width = 401
    Height = 177
    Caption = 'Z File'
    TabOrder = 0
    object SpeedButton1: TSpeedButton
      Left = 184
      Top = 32
      Width = 23
      Height = 22
      Glyph.Data = {
        76010000424D7601000000000000760000002800000020000000100000000100
        04000000000000010000120B0000120B00001000000000000000000000000000
        800000800000008080008000000080008000808000007F7F7F00BFBFBF000000
        FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00333333333333
        333333333333FF3333333333333C0C333333333333F777F3333333333CC0F0C3
        333333333777377F33333333C30F0F0C333333337F737377F333333C00FFF0F0
        C33333F7773337377F333CC0FFFFFF0F0C3337773F33337377F3C30F0FFFFFF0
        F0C37F7373F33337377F00FFF0FFFFFF0F0C7733373F333373770FFFFF0FFFFF
        F0F073F33373F333373730FFFFF0FFFFFF03373F33373F333F73330FFFFF0FFF
        00333373F33373FF77333330FFFFF000333333373F333777333333330FFF0333
        3333333373FF7333333333333000333333333333377733333333333333333333
        3333333333333333333333333333333333333333333333333333}
      NumGlyphs = 2
      OnClick = SpeedButton1Click
    end
    object SpeedButton2: TSpeedButton
      Left = 184
      Top = 67
      Width = 23
      Height = 22
      Glyph.Data = {
        76010000424D7601000000000000760000002800000020000000100000000100
        04000000000000010000120B0000120B00001000000000000000000000000000
        800000800000008080008000000080008000808000007F7F7F00BFBFBF000000
        FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00333333333333
        333333333333FF3333333333333C0C333333333333F777F3333333333CC0F0C3
        333333333777377F33333333C30F0F0C333333337F737377F333333C00FFF0F0
        C33333F7773337377F333CC0FFFFFF0F0C3337773F33337377F3C30F0FFFFFF0
        F0C37F7373F33337377F00FFF0FFFFFF0F0C7733373F333373770FFFFF0FFFFF
        F0F073F33373F333373730FFFFF0FFFFFF03373F33373F333F73330FFFFF0FFF
        00333373F33373FF77333330FFFFF000333333373F333777333333330FFF0333
        3333333373FF7333333333333000333333333333377733333333333333333333
        3333333333333333333333333333333333333333333333333333}
      NumGlyphs = 2
      OnClick = SpeedButton2Click
    end
    object Label1: TLabel
      Left = 16
      Top = 112
      Width = 133
      Height = 13
      Caption = 'Chinese charactors in 1 line.'
    end
    object Label9: TLabel
      Left = 240
      Top = 112
      Width = 87
      Height = 13
      Caption = 'Pixels in 1 column.'
    end
    object Label10: TLabel
      Left = 16
      Top = 144
      Width = 117
      Height = 13
      Caption = 'Size of 1 charactor (x, y).'
    end
    object Label11: TLabel
      Left = 240
      Top = 144
      Width = 59
      Height = 13
      Caption = 'Alpha blend.'
    end
    object Edit1: TEdit
      Left = 16
      Top = 32
      Width = 153
      Height = 21
      TabOrder = 0
      Text = 'z.dat'
    end
    object BitBtn1: TBitBtn
      Left = 224
      Top = 32
      Width = 73
      Height = 25
      Caption = 'Read Z'
      TabOrder = 1
      OnClick = BitBtn1Click
      Glyph.Data = {
        76010000424D7601000000000000760000002800000020000000100000000100
        04000000000000010000120B0000120B00001000000000000000000000000000
        800000800000008080008000000080008000808000007F7F7F00BFBFBF000000
        FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00333333303333
        333333333337FF3333333333330003333333333333777F333333333333080333
        3333333333777F3333333333330003333333333333777F3333333333330F0333
        33333333337F7F3333333333330F033333333333337373F33333333330F7F033
        333333333737F73F333333330FF7FF03333333337F37F37F333333330FF7FF03
        333333337F37337F333333330FFFFF033333333373F333733333333330FFF033
        33333333373FF733333333333300033333333333337773333333333333333333
        3333333333333333333333333333333333333333333333333333333333333333
        3333333333333333333333333333333333333333333333333333}
      NumGlyphs = 2
    end
    object BitBtn2: TBitBtn
      Left = 312
      Top = 32
      Width = 73
      Height = 25
      Caption = 'Patch Z'
      TabOrder = 2
      OnClick = BitBtn2Click
      Glyph.Data = {
        76010000424D7601000000000000760000002800000020000000100000000100
        04000000000000010000120B0000120B00001000000000000000000000000000
        800000800000008080008000000080008000808000007F7F7F00BFBFBF000000
        FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00333333303333
        333333333337FF3333333333330003333333333333777F333333333333080333
        3333333F33777FF33F3333B33B000B33B3333373F777773F7333333BBB0B0BBB
        33333337737F7F77F333333BBB0F0BBB33333337337373F73F3333BBB0F7F0BB
        B333337F3737F73F7F3333BB0FB7BF0BB3333F737F37F37F73FFBBBB0BF7FB0B
        BBB3773F7F37337F377333BB0FBFBF0BB333337F73F333737F3333BBB0FBF0BB
        B3333373F73FF7337333333BBB000BBB33333337FF777337F333333BBBBBBBBB
        3333333773FF3F773F3333B33BBBBB33B33333733773773373333333333B3333
        333333333337F33333333333333B333333333333333733333333}
      NumGlyphs = 2
    end
    object MaskEdit14: TMaskEdit
      Left = 352
      Top = 108
      Width = 33
      Height = 21
      TabOrder = 3
      Text = '0'
    end
    object Edit2: TEdit
      Left = 16
      Top = 68
      Width = 153
      Height = 21
      TabOrder = 4
      Text = 'talk.grp'
    end
    object BitBtn3: TBitBtn
      Left = 224
      Top = 64
      Width = 161
      Height = 25
      Caption = 'Patch Talk'
      TabOrder = 5
      OnClick = BitBtn3Click
      Glyph.Data = {
        76010000424D7601000000000000760000002800000020000000100000000100
        04000000000000010000120B0000120B00001000000000000000000000000000
        800000800000008080008000000080008000808000007F7F7F00BFBFBF000000
        FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00500000000055
        555557777777775F55550FFFFFFFFF0555557F5555555F7FFF5F0FEEEEEE0000
        05007F555555777775770FFFFFF0BFBFB00E7F5F5557FFF557770F0EEEE000FB
        FB0E7F75FF57775555770FF00F0FBFBFBF0E7F57757FFFF555770FE0B00000FB
        FB0E7F575777775555770FFF0FBFBFBFBF0E7F5575FFFFFFF5770FEEE0000000
        FB0E7F555777777755770FFFFF0B00BFB0007F55557577FFF7770FEEEEE0B000
        05557F555557577775550FFFFFFF0B0555557FF5F5F57575F55500F0F0F0F0B0
        555577F7F7F7F7F75F5550707070700B055557F7F7F7F7757FF5507070707050
        9055575757575757775505050505055505557575757575557555}
      NumGlyphs = 2
    end
    object MaskEdit1: TMaskEdit
      Left = 184
      Top = 108
      Width = 33
      Height = 21
      TabOrder = 6
      Text = '24'
    end
    object MaskEdit15: TMaskEdit
      Left = 144
      Top = 140
      Width = 33
      Height = 21
      TabOrder = 7
      Text = '0'
    end
    object MaskEdit16: TMaskEdit
      Left = 184
      Top = 140
      Width = 33
      Height = 21
      TabOrder = 8
      Text = '0'
    end
    object MaskEdit17: TMaskEdit
      Left = 352
      Top = 140
      Width = 33
      Height = 21
      TabOrder = 9
      Text = '0'
    end
  end
  object GroupBox3: TGroupBox
    Left = 24
    Top = 208
    Width = 401
    Height = 161
    Caption = 'GroupBox3'
    TabOrder = 1
    object Label2: TLabel
      Left = 24
      Top = 32
      Width = 84
      Height = 13
      Caption = 'Size of the dialog.'
    end
    object Label3: TLabel
      Left = 24
      Top = 68
      Width = 101
      Height = 13
      Caption = 'Position of the dialog.'
    end
    object Label4: TLabel
      Left = 24
      Top = 108
      Width = 97
      Height = 13
      Caption = 'Position of the head.'
    end
    object Label5: TLabel
      Left = 168
      Top = 128
      Width = 11
      Height = 13
      Caption = 'x1'
    end
    object Label6: TLabel
      Left = 224
      Top = 128
      Width = 11
      Height = 13
      Caption = 'y1'
    end
    object Label7: TLabel
      Left = 280
      Top = 128
      Width = 11
      Height = 13
      Caption = 'x2'
    end
    object Label8: TLabel
      Left = 336
      Top = 128
      Width = 11
      Height = 13
      Caption = 'y2'
    end
    object MaskEdit2: TMaskEdit
      Left = 144
      Top = 24
      Width = 41
      Height = 21
      TabOrder = 0
      Text = '0'
    end
    object MaskEdit3: TMaskEdit
      Left = 200
      Top = 24
      Width = 41
      Height = 21
      TabOrder = 1
      Text = '0'
    end
    object MaskEdit4: TMaskEdit
      Left = 256
      Top = 24
      Width = 41
      Height = 21
      TabOrder = 2
      Text = '0'
    end
    object MaskEdit5: TMaskEdit
      Left = 312
      Top = 24
      Width = 41
      Height = 21
      TabOrder = 3
      Text = '0'
    end
    object MaskEdit6: TMaskEdit
      Left = 144
      Top = 60
      Width = 41
      Height = 21
      TabOrder = 4
      Text = '0'
    end
    object MaskEdit7: TMaskEdit
      Left = 200
      Top = 60
      Width = 41
      Height = 21
      TabOrder = 5
      Text = '0'
    end
    object MaskEdit8: TMaskEdit
      Left = 256
      Top = 60
      Width = 41
      Height = 21
      TabOrder = 6
      Text = '0'
    end
    object MaskEdit9: TMaskEdit
      Left = 312
      Top = 60
      Width = 41
      Height = 21
      TabOrder = 7
      Text = '0'
    end
    object MaskEdit10: TMaskEdit
      Left = 144
      Top = 100
      Width = 41
      Height = 21
      TabOrder = 8
      Text = '0'
    end
    object MaskEdit11: TMaskEdit
      Left = 200
      Top = 100
      Width = 41
      Height = 21
      TabOrder = 9
      Text = '0'
    end
    object MaskEdit12: TMaskEdit
      Left = 256
      Top = 100
      Width = 41
      Height = 21
      TabOrder = 10
      Text = '0'
    end
    object MaskEdit13: TMaskEdit
      Left = 312
      Top = 100
      Width = 41
      Height = 21
      TabOrder = 11
      Text = '0'
    end
  end
  object OpenDialog1: TOpenDialog
    DefaultExt = 'dat'
    Filter = 'Z file.|*.dat;*.com;*.exe|All types.|*.*'
  end
  object OpenDialog2: TOpenDialog
    DefaultExt = 'grp'
    Filter = 'talk.grp|talk.grp|All types.|*.*'
    Top = 32
  end
  object XPManifest1: TXPManifest
    Left = 40
  end
end
