object Form1: TForm1
  Left = 380
  Top = 277
  BorderIcons = [biSystemMenu, biMinimize]
  BorderStyle = bsSingle
  Caption = 'Fix Scence File'
  ClientHeight = 235
  ClientWidth = 308
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
    Left = 16
    Top = 48
    Width = 265
    Height = 89
    Caption = 'Fix wrong pictures'
    TabOrder = 0
    object Button1: TButton
      Left = 16
      Top = 24
      Width = 65
      Height = 25
      Caption = 'fix'
      TabOrder = 0
      OnClick = Button1Click
    end
    object ProgressBar1: TProgressBar
      Left = 16
      Top = 56
      Width = 225
      Height = 17
      TabOrder = 1
    end
    object Edit2: TEdit
      Left = 96
      Top = 24
      Width = 57
      Height = 21
      TabOrder = 2
      Text = '4128'
    end
  end
  object GroupBox2: TGroupBox
    Left = 16
    Top = 144
    Width = 201
    Height = 73
    Caption = 'Remove all events'
    TabOrder = 1
    object SpinEdit1: TSpinEdit
      Left = 16
      Top = 24
      Width = 65
      Height = 22
      MaxValue = 0
      MinValue = 0
      TabOrder = 0
      Value = 0
    end
    object Button2: TButton
      Left = 104
      Top = 24
      Width = 75
      Height = 25
      Caption = 'Remove'
      TabOrder = 1
      OnClick = Button2Click
    end
  end
  object BitBtn1: TBitBtn
    Left = 112
    Top = 8
    Width = 65
    Height = 25
    Caption = 'Browse..'
    TabOrder = 2
    OnClick = BitBtn1Click
  end
  object Edit1: TEdit
    Left = 32
    Top = 12
    Width = 65
    Height = 21
    TabOrder = 3
    Text = 's1.grp'
  end
  object XPManifest1: TXPManifest
    Left = 192
    Top = 8
  end
  object OpenDialog1: TOpenDialog
    Filter = 'S files.|s*.grp; allsin.grp'
    Left = 224
    Top = 8
  end
end
