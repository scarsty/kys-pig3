VERSION 5.00
Begin VB.Form frm50_0x43 
   Caption         =   "50指令43"
   ClientHeight    =   5820
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
   ScaleHeight     =   5820
   ScaleWidth      =   9690
   StartUpPosition =   2  '屏幕中心
   Begin VB.TextBox txtNote 
      Appearance      =   0  'Flat
      BackColor       =   &H80000013&
      BorderStyle     =   0  'None
      ForeColor       =   &H00FF0000&
      Height          =   975
      Left            =   240
      Locked          =   -1  'True
      MultiLine       =   -1  'True
      TabIndex        =   2
      Text            =   "frm50_0x43.frx":0000
      Top             =   4560
      Width           =   5175
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
   Begin fishedit.userVar userN 
      Height          =   1215
      Left            =   360
      TabIndex        =   3
      Top             =   720
      Width           =   1935
      _extentx        =   3413
      _extenty        =   2143
   End
   Begin fishedit.userVar userX1 
      Height          =   1215
      Left            =   360
      TabIndex        =   4
      Top             =   2640
      Width           =   1935
      _extentx        =   3413
      _extenty        =   2778
   End
   Begin fishedit.userVar userX2 
      Height          =   1215
      Left            =   2520
      TabIndex        =   7
      Top             =   2640
      Width           =   1935
      _ExtentX        =   3413
      _ExtentY        =   2778
   End
   Begin fishedit.userVar userX3 
      Height          =   1215
      Left            =   4560
      TabIndex        =   9
      Top             =   2640
      Width           =   1935
      _ExtentX        =   3413
      _ExtentY        =   2778
   End
   Begin fishedit.userVar userX4 
      Height          =   1215
      Left            =   6600
      TabIndex        =   11
      Top             =   2640
      Width           =   1935
      _ExtentX        =   3413
      _ExtentY        =   2778
   End
   Begin VB.Label Label5 
      Caption         =   "参数X4"
      Height          =   375
      Left            =   6600
      TabIndex        =   12
      Top             =   2160
      Width           =   1935
   End
   Begin VB.Label Label3 
      Caption         =   "参数X3"
      Height          =   375
      Left            =   4560
      TabIndex        =   10
      Top             =   2160
      Width           =   1935
   End
   Begin VB.Label Label1 
      Caption         =   "参数X2"
      Height          =   375
      Left            =   2520
      TabIndex        =   8
      Top             =   2160
      Width           =   1935
   End
   Begin VB.Label Label2 
      Caption         =   "调用事件编号N"
      Height          =   255
      Left            =   360
      TabIndex        =   6
      Top             =   240
      Width           =   1575
   End
   Begin VB.Label Label4 
      Caption         =   "参数X1"
      Height          =   375
      Left            =   360
      TabIndex        =   5
      Top             =   2160
      Width           =   1935
   End
End
Attribute VB_Name = "frm50_0x43"
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
 
    kk.Data(1) = userN.Value + userX1.Value * 2 + userX2.Value * 4 + userX3.Value * 8 + userX4.Value * 16
    kk.Data(2) = userN.Text
    kk.Data(3) = userX1.Text
    kk.Data(4) = userX2.Text
    kk.Data(5) = userX3.Text
    kk.Data(6) = userX4.Text

    
    Unload Me
    
End Sub

 




 

Private Sub Form_Load()
Dim num50 As Long
Dim i As Long
Dim s1 As String
    Call ConvertForm(Me)
    
    
    Index = frmmain.listkdef.ListIndex
    Set kk = KdefInfo(frmmain.Combokdef.ListIndex).kdef.Item(Index + 1)

    
    userN.Value = IIf((kk.Data(1) And &H1) > 0, 1, 0)
    userX1.Value = IIf((kk.Data(1) And &H2) > 0, 1, 0)
    userX2.Value = IIf((kk.Data(1) And &H4) > 0, 1, 0)
    userX3.Value = IIf((kk.Data(1) And &H8) > 0, 1, 0)
    userX4.Value = IIf((kk.Data(1) And &H10) > 0, 1, 0)
    
    userN.Text = kk.Data(2)
    userN.SetCombo
    userX1.Text = kk.Data(3)
    userX1.SetCombo
    userX2.Text = kk.Data(4)
    userX2.SetCombo
    userX3.Text = kk.Data(5)
    userX3.SetCombo
    userX4.Text = kk.Data(6)
    userX4.SetCombo
    

    Call Set50Form(Me, kk.Data(0))
 
End Sub

 
