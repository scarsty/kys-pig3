VERSION 5.00
Begin VB.Form frm50_0x18 
   Caption         =   "50指令18"
   ClientHeight    =   3555
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
   ScaleHeight     =   3555
   ScaleWidth      =   9690
   StartUpPosition =   2  '屏幕中心
   Begin VB.TextBox txtNote 
      Appearance      =   0  'Flat
      BackColor       =   &H80000013&
      BorderStyle     =   0  'None
      ForeColor       =   &H00FF0000&
      Height          =   1095
      Left            =   240
      Locked          =   -1  'True
      MultiLine       =   -1  'True
      TabIndex        =   7
      Text            =   "frm50_0x18.frx":0000
      Top             =   2280
      Width           =   4335
   End
   Begin fishedit.UserVar2 UserX 
      Height          =   1215
      Left            =   2880
      TabIndex        =   6
      Top             =   600
      Width           =   2175
      _ExtentX        =   3836
      _ExtentY        =   2143
   End
   Begin fishedit.userVar userID 
      Height          =   1215
      Left            =   120
      TabIndex        =   3
      Top             =   600
      Width           =   1935
      _ExtentX        =   3413
      _ExtentY        =   2143
   End
   Begin VB.CommandButton cmdcancel 
      Caption         =   "取消"
      Height          =   375
      Left            =   8040
      TabIndex        =   1
      Top             =   1320
      Width           =   1335
   End
   Begin VB.CommandButton cmdok 
      Caption         =   "确定"
      Height          =   375
      Left            =   8040
      TabIndex        =   0
      Top             =   480
      Width           =   1335
   End
   Begin VB.Label Label7 
      Caption         =   "="
      Height          =   375
      Left            =   2160
      TabIndex        =   5
      Top             =   600
      Width           =   495
   End
   Begin VB.Label Label6 
      Caption         =   "队伍ID"
      Height          =   375
      Left            =   240
      TabIndex        =   4
      Top             =   240
      Width           =   1095
   End
   Begin VB.Label Label5 
      Caption         =   "X"
      Height          =   375
      Left            =   3000
      TabIndex        =   2
      Top             =   240
      Width           =   1095
   End
End
Attribute VB_Name = "frm50_0x18"
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
 
    kk.Data(1) = userID.Value + UserX.Value * 2
    kk.Data(2) = userID.Text
    kk.Data(3) = UserX.Text
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
    
    UserX.Clear
    For i = 0 To PersonNum - 1
        UserX.AddItem i & ":" & Person(i).Name1
    Next i

    
    
    userID.Value = IIf((kk.Data(1) And &H1) > 0, 1, 0)
    UserX.Value = IIf((kk.Data(1) And &H2) > 0, 1, 0)
    
    userID.Text = kk.Data(2)
    userID.SetCombo
    
    UserX.Text = kk.Data(3)
    
    UserX.SetCombo

    Call Set50Form(Me, kk.Data(0))

 
End Sub

 
