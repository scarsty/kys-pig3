VERSION 5.00
Begin VB.Form frm50_0x28 
   Caption         =   "50指令28"
   ClientHeight    =   2175
   ClientLeft      =   60
   ClientTop       =   420
   ClientWidth     =   4200
   LinkTopic       =   "Form1"
   ScaleHeight     =   2175
   ScaleWidth      =   4200
   StartUpPosition =   2  '屏幕中心
   Begin VB.TextBox txtNote 
      Appearance      =   0  'Flat
      BackColor       =   &H80000013&
      BorderStyle     =   0  'None
      ForeColor       =   &H00FF0000&
      Height          =   615
      Left            =   120
      Locked          =   -1  'True
      MultiLine       =   -1  'True
      TabIndex        =   3
      Text            =   "frm50_0x28.frx":0000
      Top             =   1440
      Width           =   3375
   End
   Begin VB.CommandButton cmdcancel 
      Caption         =   "取消"
      Height          =   375
      Left            =   2520
      TabIndex        =   1
      Top             =   960
      Width           =   1335
   End
   Begin VB.CommandButton cmdok 
      Caption         =   "确定"
      Height          =   375
      Left            =   2520
      TabIndex        =   0
      Top             =   240
      Width           =   1335
   End
   Begin fishedit.userVar userVar 
      Height          =   975
      Left            =   120
      TabIndex        =   2
      Top             =   360
      Width           =   2055
      _ExtentX        =   3625
      _ExtentY        =   1720
   End
   Begin VB.Label Label1 
      Caption         =   "战斗人物序号"
      Height          =   255
      Left            =   120
      TabIndex        =   4
      Top             =   120
      Width           =   1575
   End
End
Attribute VB_Name = "frm50_0x28"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Option Explicit
Dim kk As Statement

Private Sub cmdok_Click()
    kk.Data(1) = userVar.Text
    kk.Data(2) = 0
    kk.Data(3) = 0
    kk.Data(4) = 0
    kk.Data(5) = 0
    kk.Data(6) = 0
    Unload Me
End Sub

Private Sub Form_Load()
Dim num50 As Long
Dim i As Long
Dim s1 As String
    Call ConvertForm(Me)
    

    Set kk = KdefInfo(frmmain.Combokdef.ListIndex).kdef.Item(frmmain.listkdef.ListIndex + 1)
    
    Call Set50Form(Me, kk.Data(0))
    
    userVar.Text = kk.Data(1)
   
    
    userVar.Showtype = False
    userVar.SetCombo
End Sub
