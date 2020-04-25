object Form1: TForm1
  Left = 541
  Top = 339
  BorderStyle = bsDialog
  Caption = 'Crack kdef files'
  ClientHeight = 125
  ClientWidth = 237
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 13
  object Button1: TButton
    Left = 24
    Top = 88
    Width = 75
    Height = 25
    Caption = 'Crack!'
    TabOrder = 0
    OnClick = Button1Click
  end
  object Memo1: TMemo
    Left = 16
    Top = 16
    Width = 209
    Height = 65
    BevelInner = bvNone
    BevelOuter = bvNone
    BorderStyle = bsNone
    Color = clBtnFace
    Enabled = False
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -12
    Font.Name = 'Calibri'
    Font.Style = []
    Lines.Strings = (
      'Please place the Z file and kdef.idx, '
      'kdef.grp in the same path with this '
      'program.'
      'new.idx and new.grp are cracked files.')
    ParentFont = False
    TabOrder = 1
  end
  object Button2: TButton
    Left = 128
    Top = 88
    Width = 75
    Height = 25
    Caption = 'Exit'
    TabOrder = 2
    OnClick = Button2Click
  end
  object XPManifest1: TXPManifest
    Left = 208
  end
end
