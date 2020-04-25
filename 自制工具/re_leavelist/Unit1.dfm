object Form1: TForm1
  Left = 468
  Top = 330
  Width = 336
  Height = 217
  Caption = 'Form1'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 13
  object SpinEdit1: TSpinEdit
    Left = 208
    Top = 120
    Width = 65
    Height = 22
    MaxValue = 0
    MinValue = 0
    TabOrder = 0
    Value = 0
    OnChange = SpinEdit1Change
  end
  object Button1: TButton
    Left = 168
    Top = 48
    Width = 49
    Height = 25
    Caption = 'open'
    TabOrder = 1
    OnClick = Button1Click
  end
  object Button2: TButton
    Left = 224
    Top = 48
    Width = 49
    Height = 25
    Caption = 'save'
    TabOrder = 2
    OnClick = Button2Click
  end
  object SpinEdit2: TSpinEdit
    Left = 48
    Top = 120
    Width = 121
    Height = 22
    MaxValue = 100
    MinValue = 1
    TabOrder = 3
    Value = 0
    OnChange = SpinEdit2Change
  end
  object Edit1: TEdit
    Left = 40
    Top = 48
    Width = 121
    Height = 21
    TabOrder = 4
    Text = 'Edit1'
  end
  object OpenDialog1: TOpenDialog
    Left = 392
    Top = 48
  end
  object XPManifest1: TXPManifest
    Left = 280
    Top = 8
  end
end
