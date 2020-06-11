VERSION 5.00
Begin VB.Form frm50_0x12 
   Caption         =   "50指令12"
   ClientHeight    =   2850
   ClientLeft      =   60
   ClientTop       =   345
   ClientWidth     =   9690
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
   ScaleHeight     =   2850
   ScaleWidth      =   9690
   StartUpPosition =   2  '屏幕中心
   Begin VB.TextBox txtNote 
      Appearance      =   0  'Flat
      BackColor       =   &H80000013&
      BorderStyle     =   0  'None
      ForeColor       =   &H00FF0000&
      Height          =   735
      Left            =   240
      Locked          =   -1  'True
      MultiLine       =   -1  'True
      TabIndex        =   8
      Text            =   "frm50_0x12.frx":0000
      Top             =   1920
      Width           =   4215
   End
   Begin VB.CommandButton cmdcancel 
      Caption         =   "取消"
      Height          =   375
      Left            =   7080
      TabIndex        =   1
      Top             =   1320
      Width           =   1335
   End
   Begin VB.CommandButton cmdok 
      Caption         =   "确定"
      Height          =   375
      Left            =   7080
      TabIndex        =   0
      Top             =   480
      Width           =   1335
   End
   Begin fishedit.userVar userS 
      Height          =   1095
      Left            =   240
      TabIndex        =   4
      Top             =   480
      Width           =   1815
      _extentx        =   3201
      _extenty        =   1931
   End
   Begin fishedit.userVar userN 
      Height          =   1095
      Left            =   2760
      TabIndex        =   5
      Top             =   480
      Width           =   1815
      _extentx        =   3201
      _extenty        =   1931
      value           =   1
   End
   Begin VB.Label Label4 
      Caption         =   "个空格"
      Height          =   495
      Left            =   4800
      TabIndex        =   7
      Top             =   480
      Width           =   1215
   End
   Begin VB.Label Label6 
      Caption         =   "="
      Height          =   495
      Left            =   2280
      TabIndex        =   6
      Top             =   600
      Width           =   255
   End
   Begin VB.Label Label5 
      Caption         =   "字符串变量S"
      Height          =   255
      Left            =   240
      TabIndex        =   3
      Top             =   120
      Width           =   1575
   End
   Begin VB.Label Label3 
      Caption         =   "N"
      Height          =   375
      Left            =   2760
      TabIndex        =   2
      Top             =   120
      Width           =   1695
   End
End
Attribute VB_Name = "frm50_0x12"
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
 
    kk.Data(1) = userN.Value
    kk.Data(2) = userS.Text
    kk.Data(3) = userN.Text
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
    
    
    Index = frmmain.listkdef.ListIndex
    Set kk = KdefInfo(frmmain.Combokdef.ListIndex).kdef.Item(Index + 1)

    userS.Text = kk.Data(2)
    userN.Text = kk.Data(3)
 
    userN.Value = IIf((kk.Data(1) And &H1) > 0, 1, 0)
    
    Call Set50Form(Me, kk.Data(0))

    userS.Showtype = False
    userS.SetCombo
    userN.SetCombo

End Sub

 
Private Sub userVar1_GotFocus()

End Sub
