VERSION 5.00
Begin VB.Form frm50_0x03 
   Caption         =   "50指令3"
   ClientHeight    =   3150
   ClientLeft      =   60
   ClientTop       =   345
   ClientWidth     =   9255
   BeginProperty Font 
      Name            =   "Times New Roman"
      Size            =   9
      Charset         =   0
      Weight          =   400
      Underline       =   0   'False
      Italic          =   0   'False
      Strikethrough   =   0   'False
   EndProperty
   LinkTopic       =   "Form1"
   ScaleHeight     =   3150
   ScaleWidth      =   9255
   StartUpPosition =   2  '屏幕中心
   Begin VB.TextBox txtNote 
      Appearance      =   0  'Flat
      BackColor       =   &H80000013&
      BorderStyle     =   0  'None
      ForeColor       =   &H00FF0000&
      Height          =   735
      Left            =   120
      Locked          =   -1  'True
      MultiLine       =   -1  'True
      TabIndex        =   10
      Text            =   "frm50_0x03.frx":0000
      Top             =   2160
      Width           =   6015
   End
   Begin VB.ComboBox ComboOP 
      Height          =   345
      ItemData        =   "frm50_0x03.frx":0081
      Left            =   4320
      List            =   "frm50_0x03.frx":0094
      Style           =   2  'Dropdown List
      TabIndex        =   9
      Top             =   600
      Width           =   735
   End
   Begin fishedit.userVar userB 
      Height          =   1095
      Left            =   5160
      TabIndex        =   6
      Top             =   600
      Width           =   1815
      _ExtentX        =   3201
      _ExtentY        =   1931
   End
   Begin VB.CommandButton cmdcancel 
      Caption         =   "取消"
      Height          =   375
      Left            =   7440
      TabIndex        =   1
      Top             =   1320
      Width           =   1335
   End
   Begin VB.CommandButton cmdok 
      Caption         =   "确定"
      Height          =   375
      Left            =   7440
      TabIndex        =   0
      Top             =   480
      Width           =   1335
   End
   Begin fishedit.userVar userY 
      Height          =   1095
      Left            =   120
      TabIndex        =   7
      Top             =   600
      Width           =   1815
      _ExtentX        =   3201
      _ExtentY        =   1931
   End
   Begin fishedit.userVar userA 
      Height          =   1095
      Left            =   2400
      TabIndex        =   8
      Top             =   600
      Width           =   1815
      _ExtentX        =   3201
      _ExtentY        =   1931
      Value           =   1
   End
   Begin VB.Label Label8 
      Caption         =   "="
      Height          =   375
      Left            =   2040
      TabIndex        =   5
      Top             =   600
      Width           =   375
   End
   Begin VB.Label Label5 
      Caption         =   "变量Y"
      Height          =   255
      Left            =   120
      TabIndex        =   4
      Top             =   240
      Width           =   495
   End
   Begin VB.Label Label4 
      Caption         =   "B"
      Height          =   255
      Left            =   5400
      TabIndex        =   3
      Top             =   240
      Width           =   495
   End
   Begin VB.Label Label3 
      Caption         =   "变量A"
      Height          =   375
      Left            =   2400
      TabIndex        =   2
      Top             =   240
      Width           =   1695
   End
End
Attribute VB_Name = "frm50_0x03"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Option Explicit
Dim Index As Long
Dim kk As Statement


Private Sub cmdcancel_Click()
    Unload Me
End Sub

Private Sub cmdok_Click()
 
    kk.Data(2) = ComboOP.ListIndex
    kk.Data(3) = userY.Text
    kk.Data(4) = userA.Text
    kk.Data(5) = userB.Text
    kk.Data(6) = 0
    kk.Data(1) = userB.Value
    
    Unload Me
    
End Sub

 

Private Sub Form_Load()
Dim num50 As Long
Dim i As Long
Dim s1 As String
    Call ConvertForm(Me)
    
    
    Index = frmmain.listkdef.ListIndex
    Set kk = KdefInfo(frmmain.Combokdef.ListIndex).kdef.Item(Index + 1)

    Call Set50Form(Me, kk.Data(0))

    userY.Text = kk.Data(3)
    userA.Text = kk.Data(4)
    userB.Text = kk.Data(5)
    
    ComboOP.ListIndex = kk.Data(2)
    
    userB.Value = IIf((kk.Data(1) And &H1) > 0, 1, 0)
    


    userY.Showtype = False
    userY.SetCombo
    userA.Showtype = False
    userA.SetCombo
    userB.SetCombo

End Sub

 
