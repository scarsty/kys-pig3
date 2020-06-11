object Form1: TForm1
  Left = 414
  Top = 204
  Width = 376
  Height = 262
  Caption = 'Simple File Editor'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  OnClose = FormClose
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 56
    Top = 192
    Width = 60
    Height = 13
    Caption = 'Press Patch.'
  end
  object CheckBox1: TCheckBox
    Left = 48
    Top = 168
    Width = 129
    Height = 17
    Caption = 'New Edition (+6600h)'
    ParentShowHint = False
    ShowHint = False
    TabOrder = 0
  end
  object Button3: TButton
    Left = 208
    Top = 160
    Width = 75
    Height = 25
    Caption = 'Patch!'
    TabOrder = 1
    OnClick = Button3Click
  end
  object Panel1: TPanel
    Left = 32
    Top = 24
    Width = 281
    Height = 121
    BevelInner = bvLowered
    BevelOuter = bvSpace
    TabOrder = 2
    object Edit1: TEdit
      Left = 24
      Top = 24
      Width = 121
      Height = 21
      TabOrder = 0
      Text = 'z.dat'
    end
    object Edit2: TEdit
      Left = 24
      Top = 68
      Width = 121
      Height = 21
      TabOrder = 1
      Text = 'list1.txt'
    end
    object Button1: TButton
      Left = 174
      Top = 24
      Width = 75
      Height = 25
      Caption = 'Browse...'
      TabOrder = 2
      OnClick = Button1Click
    end
    object Button2: TButton
      Left = 174
      Top = 64
      Width = 75
      Height = 25
      Caption = 'Browse...'
      TabOrder = 3
      OnClick = Button2Click
    end
  end
  object OpenDialog1: TOpenDialog
    InitialDir = '.'
    Left = 328
  end
  object OpenDialog2: TOpenDialog
    InitialDir = '.'
    Left = 328
    Top = 32
  end
end
