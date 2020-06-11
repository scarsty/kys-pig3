object Form1: TForm1
  Left = 621
  Top = 301
  Width = 367
  Height = 215
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
    Left = 40
    Top = 128
    Width = 65
    Height = 22
    MaxValue = 0
    MinValue = 0
    TabOrder = 0
    Value = 0
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
    Left = 40
    Top = 88
    Width = 73
    Height = 22
    MaxValue = 100
    MinValue = 1
    TabOrder = 3
    Value = 1
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
  object SpinEdit3: TSpinEdit
    Left = 128
    Top = 128
    Width = 49
    Height = 22
    MaxValue = 0
    MinValue = 0
    TabOrder = 5
    Value = 0
  end
  object SpinEdit4: TSpinEdit
    Left = 192
    Top = 128
    Width = 57
    Height = 22
    MaxValue = 0
    MinValue = 0
    TabOrder = 6
    Value = 0
  end
  object Button3: TButton
    Left = 264
    Top = 128
    Width = 49
    Height = 25
    Caption = 'OK'
    TabOrder = 7
    OnClick = Button3Click
  end
  object OpenDialog1: TOpenDialog
    Left = 224
    Top = 8
  end
  object XPManifest1: TXPManifest
    Left = 280
    Top = 8
  end
end
