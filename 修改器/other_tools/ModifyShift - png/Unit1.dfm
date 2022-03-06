object Form1: TForm1
  Left = 439
  Top = 219
  Caption = 'Shift'
  ClientHeight = 490
  ClientWidth = 669
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poDesigned
  OnCreate = FormCreate
  OnResize = FormResize
  PixelsPerInch = 96
  TextHeight = 13
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 669
    Height = 350
    Align = alClient
    BevelInner = bvLowered
    BorderWidth = 4
    Color = clWhite
    TabOrder = 0
    object Image1: TImage
      Left = 6
      Top = 6
      Width = 657
      Height = 338
      Align = alClient
      Touch.ParentTabletOptions = False
      Touch.TabletOptions = [toPressAndHold]
      OnClick = Image1Click
      OnDblClick = Image1DblClick
      OnMouseDown = Image1MouseDown
      OnMouseMove = Image1MouseMove
      OnMouseUp = Image1MouseUp
      ExplicitLeft = 5
      ExplicitWidth = 669
      ExplicitHeight = 291
    end
  end
  object Panel2: TPanel
    Left = 0
    Top = 350
    Width = 669
    Height = 140
    Align = alBottom
    BevelInner = bvLowered
    TabOrder = 1
    object SpeedButton1: TSpeedButton
      Left = 518
      Top = 19
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
    object Label1: TLabel
      Left = 179
      Top = 60
      Width = 31
      Height = 13
      Caption = 'mouse'
    end
    object Image3: TImage
      Left = 547
      Top = 6
      Width = 52
      Height = 50
      AutoSize = True
      Transparent = True
      OnClick = Image3Click
      OnDblClick = Image3DblClick
      OnMouseMove = Image3MouseMove
    end
    object Edit1: TEdit
      Left = 216
      Top = 21
      Width = 296
      Height = 21
      TabOrder = 0
      Text = 'Browse the idx file here.'
    end
    object Edit3: TEdit
      Left = 88
      Top = 60
      Width = 33
      Height = 21
      TabOrder = 1
      Text = '0'
    end
    object Edit4: TEdit
      Left = 128
      Top = 60
      Width = 33
      Height = 21
      TabOrder = 2
      Text = '0'
    end
    object SpinEdit1: TSpinEdit
      Left = 24
      Top = 59
      Width = 49
      Height = 22
      MaxValue = 10
      MinValue = 0
      TabOrder = 3
      Value = 0
      OnChange = SpinEdit1Change
    end
    object Edit2: TEdit
      Left = 216
      Top = 60
      Width = 33
      Height = 21
      Enabled = False
      TabOrder = 4
      Text = '0'
    end
    object Edit5: TEdit
      Left = 256
      Top = 60
      Width = 33
      Height = 21
      Enabled = False
      TabOrder = 5
      Text = '0'
    end
    object Button1: TButton
      Left = 8
      Top = 104
      Width = 65
      Height = 25
      Caption = 'Current'
      Enabled = False
      TabOrder = 6
      OnClick = Button1Click
    end
    object Button2: TButton
      Left = 456
      Top = 103
      Width = 75
      Height = 25
      Caption = 'Save all'
      Enabled = False
      TabOrder = 7
      OnClick = Button2Click
    end
    object Button3: TButton
      Left = 537
      Top = 104
      Width = 75
      Height = 25
      Caption = 'Exit'
      TabOrder = 8
      OnClick = Button3Click
    end
    object CheckBox1: TCheckBox
      Left = 411
      Top = 21
      Width = 49
      Height = 17
      Caption = 'fight'
      TabOrder = 9
      Visible = False
      OnClick = CheckBox1Click
    end
    object Button4: TButton
      Left = 150
      Top = 104
      Width = 65
      Height = 25
      Caption = 'All images'
      TabOrder = 10
      OnClick = Button4Click
    end
    object Button5: TButton
      Left = 304
      Top = 56
      Width = 75
      Height = 25
      Caption = 'Play All'
      TabOrder = 11
      OnClick = Button5Click
    end
    object CheckBox2: TCheckBox
      Left = 466
      Top = 22
      Width = 97
      Height = 17
      Caption = 'By shift.'
      Enabled = False
      TabOrder = 12
      Visible = False
    end
    object Button6: TButton
      Left = 385
      Top = 56
      Width = 75
      Height = 25
      Caption = 'Play Here'
      TabOrder = 13
      OnClick = Button6Click
    end
    object Button7: TButton
      Left = 466
      Top = 56
      Width = 75
      Height = 25
      Caption = 'Stop'
      TabOrder = 14
      OnClick = Button7Click
    end
    object Button8: TButton
      Left = 294
      Top = 104
      Width = 75
      Height = 25
      Caption = 'Add One'
      TabOrder = 15
      OnClick = Button8Click
    end
    object Button9: TButton
      Left = 375
      Top = 104
      Width = 75
      Height = 25
      Caption = 'Remove One'
      TabOrder = 16
      OnClick = Button9Click
    end
    object SpinEdit2: TSpinEdit
      Left = 24
      Top = 20
      Width = 49
      Height = 22
      MaxValue = 5
      MinValue = 1
      TabOrder = 17
      Value = 2
      OnChange = SpinEdit2Change
    end
    object Button10: TButton
      Left = 221
      Top = 104
      Width = 65
      Height = 25
      Caption = 'Part images'
      TabOrder = 18
      OnClick = Button10Click
    end
    object Edit6: TEdit
      Left = 88
      Top = 20
      Width = 33
      Height = 21
      TabOrder = 19
      Text = '0'
      OnChange = Edit6Change
    end
    object Edit7: TEdit
      Left = 128
      Top = 20
      Width = 33
      Height = 21
      TabOrder = 20
      Text = '0'
      OnChange = Edit7Change
    end
    object Button11: TButton
      Left = 167
      Top = 20
      Width = 26
      Height = 21
      Caption = '0'
      TabOrder = 21
      OnClick = Button11Click
    end
    object Button12: TButton
      Left = 79
      Top = 103
      Width = 65
      Height = 25
      Caption = 'Return'
      TabOrder = 22
      OnClick = Button12Click
    end
  end
  object OpenDialog1: TOpenDialog
    Filter = 'KA files|*.ka'
  end
  object Timer1: TTimer
    Enabled = False
    Interval = 200
    OnTimer = Timer1Timer
    Top = 32
  end
end
