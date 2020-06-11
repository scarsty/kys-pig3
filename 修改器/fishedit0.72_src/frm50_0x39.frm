VERSION 5.00
Begin VB.Form frm50_0x39 
   Caption         =   "50指令39"
   ClientHeight    =   5550
   ClientLeft      =   60
   ClientTop       =   345
   ClientWidth     =   10350
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
   ScaleHeight     =   5550
   ScaleWidth      =   10350
   StartUpPosition =   2  '屏幕中心
   Begin VB.TextBox txtNote 
      Appearance      =   0  'Flat
      BackColor       =   &H80000013&
      BorderStyle     =   0  'None
      ForeColor       =   &H00FF0000&
      Height          =   735
      Left            =   360
      Locked          =   -1  'True
      MultiLine       =   -1  'True
      TabIndex        =   12
      Text            =   "frm50_0x39.frx":0000
      Top             =   4200
      Width           =   6975
   End
   Begin fishedit.userVar userN 
      Height          =   1215
      Left            =   360
      TabIndex        =   3
      Top             =   720
      Width           =   1935
      _ExtentX        =   3413
      _ExtentY        =   2143
   End
   Begin fishedit.userVar userS 
      Height          =   1215
      Left            =   2520
      TabIndex        =   2
      Top             =   720
      Width           =   1935
      _ExtentX        =   3413
      _ExtentY        =   2778
   End
   Begin VB.CommandButton cmdcancel 
      Caption         =   "取消"
      Height          =   375
      Left            =   8760
      TabIndex        =   1
      Top             =   1440
      Width           =   1335
   End
   Begin VB.CommandButton cmdok 
      Caption         =   "确定"
      Height          =   375
      Left            =   8760
      TabIndex        =   0
      Top             =   600
      Width           =   1335
   End
   Begin fishedit.userVar userX 
      Height          =   1215
      Left            =   360
      TabIndex        =   6
      Top             =   2520
      Width           =   1935
      _ExtentX        =   3413
      _ExtentY        =   2143
   End
   Begin fishedit.userVar userY 
      Height          =   1215
      Left            =   2400
      TabIndex        =   7
      Top             =   2520
      Width           =   1935
      _ExtentX        =   3413
      _ExtentY        =   2778
   End
   Begin fishedit.userVar userR 
      Height          =   1215
      Left            =   5160
      TabIndex        =   10
      Top             =   720
      Width           =   1935
      _ExtentX        =   3413
      _ExtentY        =   2778
   End
   Begin VB.Label Label5 
      Caption         =   "返回选择菜单项变量R"
      Height          =   375
      Left            =   5280
      TabIndex        =   11
      Top             =   240
      Width           =   1935
   End
   Begin VB.Label Label4 
      Caption         =   "纵坐标Y"
      Height          =   375
      Left            =   2520
      TabIndex        =   9
      Top             =   2040
      Width           =   1935
   End
   Begin VB.Label Label3 
      Caption         =   "横坐标X"
      Height          =   255
      Left            =   360
      TabIndex        =   8
      Top             =   2040
      Width           =   1575
   End
   Begin VB.Label Label1 
      Caption         =   "菜单显示数组S"
      Height          =   375
      Left            =   2520
      TabIndex        =   5
      Top             =   240
      Width           =   1935
   End
   Begin VB.Label Label2 
      Caption         =   "菜单项个数N"
      Height          =   255
      Left            =   360
      TabIndex        =   4
      Top             =   240
      Width           =   1575
   End
End
Attribute VB_Name = "frm50_0x39"
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
 
    kk.Data(1) = userN.Value + userX.Value * 2 + userY.Value * 4
    kk.Data(2) = userN.Text
    kk.Data(3) = userS.Text
    kk.Data(4) = userR.Text
    kk.Data(5) = userX.Text
    kk.Data(6) = userY.Text

    
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
    userX.Value = IIf((kk.Data(1) And &H2) > 0, 1, 0)
    userY.Value = IIf((kk.Data(1) And &H4) > 0, 1, 0)

    userN.SetCombo
    
    userS.Text = kk.Data(3)
    userS.Showtype = False
    userS.SetCombo
    
    userX.Text = kk.Data(4)
    userX.SetCombo
    userY.Text = kk.Data(5)
    userY.SetCombo
    
    userR.Text = kk.Data(6)
    userR.Showtype = False
    userR.SetCombo
    
    Call Set50Form(Me, kk.Data(0))
 
End Sub

 
