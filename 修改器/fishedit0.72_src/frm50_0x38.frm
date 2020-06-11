VERSION 5.00
Begin VB.Form frm50_0x38 
   Caption         =   "50指令38"
   ClientHeight    =   3705
   ClientLeft      =   60
   ClientTop       =   345
   ClientWidth     =   8475
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
   ScaleHeight     =   3705
   ScaleWidth      =   8475
   StartUpPosition =   2  '屏幕中心
   Begin fishedit.userVar userN 
      Height          =   1215
      Left            =   3480
      TabIndex        =   6
      Top             =   720
      Width           =   1935
      _ExtentX        =   3413
      _ExtentY        =   2143
   End
   Begin VB.TextBox txtNote 
      Appearance      =   0  'Flat
      BackColor       =   &H80000013&
      BorderStyle     =   0  'None
      ForeColor       =   &H00FF0000&
      Height          =   735
      Left            =   240
      Locked          =   -1  'True
      MultiLine       =   -1  'True
      TabIndex        =   4
      Text            =   "frm50_0x38.frx":0000
      Top             =   2640
      Width           =   4095
   End
   Begin fishedit.userVar userX 
      Height          =   1215
      Left            =   240
      TabIndex        =   2
      Top             =   720
      Width           =   1935
      _ExtentX        =   3413
      _ExtentY        =   2778
   End
   Begin VB.CommandButton cmdcancel 
      Caption         =   "取消"
      Height          =   375
      Left            =   6360
      TabIndex        =   1
      Top             =   1440
      Width           =   1335
   End
   Begin VB.CommandButton cmdok 
      Caption         =   "确定"
      Height          =   375
      Left            =   6360
      TabIndex        =   0
      Top             =   600
      Width           =   1335
   End
   Begin VB.Label Label2 
      Caption         =   "随机数范围N"
      Height          =   255
      Left            =   3600
      TabIndex        =   7
      Top             =   360
      Width           =   1575
   End
   Begin VB.Label Label1 
      Caption         =   "= Random"
      Height          =   495
      Left            =   2400
      TabIndex        =   5
      Top             =   720
      Width           =   1215
   End
   Begin VB.Label Label6 
      Caption         =   "变量X"
      Height          =   375
      Left            =   360
      TabIndex        =   3
      Top             =   240
      Width           =   1815
   End
End
Attribute VB_Name = "frm50_0x38"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Option Explicit
Dim Index As Long
Dim kk As Statement
Dim OffsetName As Collection



Private Sub cmdcancel_Click()
    Unload Me
End Sub

Private Sub cmdok_Click()
 
    kk.Data(1) = userN.Value
    kk.Data(2) = userN.Text
    kk.Data(3) = userX.Text
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
    
    
    

    userN.Text = kk.Data(2)
    
    userN.Value = IIf((kk.Data(1) And &H1) > 0, 1, 0)
    

    userN.SetCombo
    
    userX.Text = kk.Data(3)

    userX.Showtype = False
    userX.SetCombo
    Call Set50Form(Me, kk.Data(0))
 
End Sub

 
