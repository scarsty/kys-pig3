object Form2: TForm2
  Left = 0
  Top = 0
  BorderStyle = bsDialog
  Caption = 'Form2'
  ClientHeight = 216
  ClientWidth = 347
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 48
    Top = 32
    Width = 24
    Height = 13
    Caption = 'From'
  end
  object Label2: TLabel
    Left = 168
    Top = 32
    Width = 12
    Height = 13
    Caption = 'To'
  end
  object Label3: TLabel
    Left = 48
    Top = 93
    Width = 6
    Height = 13
    Caption = 'X'
  end
  object Label4: TLabel
    Left = 168
    Top = 93
    Width = 6
    Height = 13
    Caption = 'Y'
  end
  object Edit1: TEdit
    Left = 48
    Top = 48
    Width = 81
    Height = 21
    TabOrder = 0
    Text = 'Edit1'
  end
  object Edit2: TEdit
    Left = 168
    Top = 48
    Width = 81
    Height = 21
    TabOrder = 1
    Text = 'Edit2'
  end
  object Edit3: TEdit
    Left = 48
    Top = 112
    Width = 81
    Height = 21
    TabOrder = 2
    Text = 'Edit3'
  end
  object Edit4: TEdit
    Left = 168
    Top = 112
    Width = 81
    Height = 21
    TabOrder = 3
    Text = 'Edit4'
  end
  object Button1: TButton
    Left = 88
    Top = 168
    Width = 75
    Height = 25
    Caption = 'OK'
    TabOrder = 4
    OnClick = Button1Click
  end
  object Button2: TButton
    Left = 200
    Top = 168
    Width = 75
    Height = 25
    Caption = 'Cancel'
    TabOrder = 5
    OnClick = Button2Click
  end
end
