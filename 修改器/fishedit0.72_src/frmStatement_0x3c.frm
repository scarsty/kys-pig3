VERSION 5.00
Begin VB.Form frmStatement_0x3c 
   Caption         =   "判断场景贴图"
   ClientHeight    =   5790
   ClientLeft      =   60
   ClientTop       =   345
   ClientWidth     =   9390
   LinkTopic       =   "Form2"
   ScaleHeight     =   5790
   ScaleWidth      =   9390
   StartUpPosition =   2  '屏幕中心
   Begin VB.TextBox txtlevel 
      BeginProperty Font 
         Name            =   "Times New Roman"
         Size            =   9
         Charset         =   0
         Weight          =   400
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Height          =   270
      Left            =   1440
      TabIndex        =   15
      Text            =   "Text1"
      Top             =   960
      Width           =   1335
   End
   Begin VB.PictureBox Pic1 
      AutoRedraw      =   -1  'True
      Height          =   2535
      Left            =   1200
      ScaleHeight     =   165
      ScaleMode       =   3  'Pixel
      ScaleWidth      =   157
      TabIndex        =   9
      Top             =   2160
      Width           =   2415
   End
   Begin VB.CommandButton cmdcancel 
      Caption         =   "取消"
      BeginProperty Font 
         Name            =   "Times New Roman"
         Size            =   9
         Charset         =   0
         Weight          =   400
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Height          =   375
      Left            =   8040
      TabIndex        =   8
      Top             =   1200
      Width           =   1335
   End
   Begin VB.CommandButton cmdok 
      Caption         =   "确定"
      BeginProperty Font 
         Name            =   "Times New Roman"
         Size            =   9
         Charset         =   0
         Weight          =   400
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Height          =   375
      Left            =   8040
      TabIndex        =   7
      Top             =   120
      Width           =   1335
   End
   Begin VB.TextBox txtid 
      Enabled         =   0   'False
      BeginProperty Font 
         Name            =   "Times New Roman"
         Size            =   9
         Charset         =   0
         Weight          =   400
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Height          =   285
      Left            =   720
      TabIndex        =   6
      Text            =   "Text1"
      Top             =   0
      Width           =   855
   End
   Begin VB.ComboBox Combomanual 
      BeginProperty Font 
         Name            =   "Times New Roman"
         Size            =   9
         Charset         =   0
         Weight          =   400
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Height          =   345
      Left            =   5400
      Style           =   2  'Dropdown List
      TabIndex        =   5
      Top             =   0
      Width           =   1695
   End
   Begin VB.VScrollBar VScroll1 
      Height          =   5295
      LargeChange     =   20
      Left            =   4080
      TabIndex        =   4
      Top             =   360
      Width           =   255
   End
   Begin VB.PictureBox pic2 
      AutoRedraw      =   -1  'True
      Height          =   4095
      Left            =   4440
      ScaleHeight     =   269
      ScaleMode       =   3  'Pixel
      ScaleWidth      =   213
      TabIndex        =   3
      Top             =   1440
      Width           =   3255
   End
   Begin VB.TextBox txtpic 
      BeginProperty Font 
         Name            =   "Times New Roman"
         Size            =   9
         Charset         =   0
         Weight          =   400
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Height          =   270
      Left            =   4680
      TabIndex        =   2
      Top             =   840
      Width           =   975
   End
   Begin VB.ComboBox ComboAddress 
      BeginProperty Font 
         Name            =   "Times New Roman"
         Size            =   9
         Charset         =   0
         Weight          =   400
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Height          =   345
      Left            =   1440
      Style           =   2  'Dropdown List
      TabIndex        =   1
      Top             =   480
      Width           =   1695
   End
   Begin VB.TextBox txtPicnum 
      BeginProperty Font 
         Name            =   "Times New Roman"
         Size            =   9
         Charset         =   0
         Weight          =   400
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Height          =   270
      Left            =   1440
      TabIndex        =   0
      Top             =   1560
      Width           =   1335
   End
   Begin VB.Label Label3 
      Caption         =   "场景"
      BeginProperty Font 
         Name            =   "Times New Roman"
         Size            =   9
         Charset         =   0
         Weight          =   400
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Height          =   375
      Left            =   120
      TabIndex        =   14
      Top             =   480
      Width           =   1095
   End
   Begin VB.Label Label2 
      Caption         =   "手工确认当前场景"
      BeginProperty Font 
         Name            =   "Times New Roman"
         Size            =   9
         Charset         =   0
         Weight          =   400
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Height          =   255
      Left            =   3240
      TabIndex        =   13
      Top             =   0
      Width           =   1575
   End
   Begin VB.Label Label1 
      Caption         =   "指令id"
      BeginProperty Font 
         Name            =   "Times New Roman"
         Size            =   9
         Charset         =   0
         Weight          =   400
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Height          =   375
      Left            =   0
      TabIndex        =   12
      Top             =   0
      Width           =   855
   End
   Begin VB.Label Label4 
      Caption         =   "场景事件位置"
      BeginProperty Font 
         Name            =   "Times New Roman"
         Size            =   9
         Charset         =   0
         Weight          =   400
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Height          =   255
      Left            =   120
      TabIndex        =   11
      Top             =   960
      Width           =   1215
   End
   Begin VB.Label Label5 
      Caption         =   "贴图编号"
      BeginProperty Font 
         Name            =   "Times New Roman"
         Size            =   9
         Charset         =   0
         Weight          =   400
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Height          =   255
      Left            =   120
      TabIndex        =   10
      Top             =   1560
      Width           =   1215
   End
End
Attribute VB_Name = "frmStatement_0x3c"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Option Explicit
Dim index As Long
Dim kk As Statement
Dim picdata() As RLEPic
Dim picnum As Long




Private Sub cmdcancel_Click()
    Unload Me
End Sub

Private Sub cmdok_Click()
   
    If ComboAddress.ListIndex = 0 Then
        kk.data(0) = &HFFFE
    Else
        kk.data(0) = ComboAddress.ListIndex - 1
    End If
    kk.data(1) = txtlevel.Text
    kk.data(2) = txtPicnum.Text
    
    Unload Me
End Sub

Private Sub txtpicnum_change()
    If Combomanual.ListIndex < 0 Then Exit Sub
        Pic1.Cls
        Call ShowPicDIB(picdata(txtPicnum.Text / 2), Pic1.hdc, Pic1.ScaleWidth / 2, Pic1.ScaleHeight / 2)
        Pic1.Refresh
End Sub

Private Sub Combomanual_Click()
Dim i As Long
    i = Combomanual.ListIndex
    If i = -1 Then
        Exit Sub
    End If
    Call LoadSMap(i, picdata, picnum)
    VScroll1.Min = 0
    VScroll1.Max = (picnum - 1)
    txtpicnum_change
End Sub

Private Sub Form_Load()
Dim i As Long



    Me.Caption = LoadResStr(6001)
    Label1.Caption = LoadResStr(1102)
    Label2.Caption = LoadResStr(1302)
    Label3.Caption = LoadResStr(510)
    Label4.Caption = LoadResStr(6002)
    Label5.Caption = LoadResStr(2101)

    cmdok.Caption = LoadResStr(102)
    cmdcancel.Caption = LoadResStr(103)







    index = frmmain.listkdef.ListIndex
    Set kk = KdefInfo(frmmain.Combokdef.ListIndex).kdef.Item(index + 1)
    
    Combomanual.Clear
    ComboAddress.Clear
    ComboAddress.AddItem "---" & LoadResStr(509) & " ---"
    For i = 1 To Scenenum
        Combomanual.AddItem i - 1 & Big5toUnicode(Scene(i - 1).Name1, 10)
        ComboAddress.AddItem i - 1 & Big5toUnicode(Scene(i - 1).Name1, 10)
    Next i
    
    
    txtid.Text = kk.Id & "(" & Hex(kk.Id) & ")"
    
    If kk.data(0) = &HFFFE Then
        ComboAddress.ListIndex = 0
    Else
        ComboAddress.ListIndex = kk.data(0) + 1
    End If
    txtlevel.Text = kk.data(1)
   
    txtPicnum.Text = kk.data(2)
    
End Sub

Private Sub txtpic_Change()
    If Combomanual.ListIndex = -1 Then Exit Sub
    Pic2.Cls
    Call ShowPicDIB(picdata(txtpic.Text / 2), Pic2.hdc, Pic2.ScaleWidth / 2, Pic2.ScaleHeight / 2)
    Pic2.Refresh
End Sub

Private Sub VScroll1_Change()
    txtpic.Text = VScroll1.value * 2
End Sub








