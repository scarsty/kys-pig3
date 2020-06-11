VERSION 5.00
Begin VB.Form frm50_0x21 
   Caption         =   "50指令21"
   ClientHeight    =   3975
   ClientLeft      =   60
   ClientTop       =   345
   ClientWidth     =   10860
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
   ScaleHeight     =   3975
   ScaleWidth      =   10860
   StartUpPosition =   2  '屏幕中心
   Begin VB.TextBox txtNote 
      Appearance      =   0  'Flat
      BackColor       =   &H80000013&
      BorderStyle     =   0  'None
      ForeColor       =   &H00FF0000&
      Height          =   1455
      Left            =   240
      Locked          =   -1  'True
      MultiLine       =   -1  'True
      TabIndex        =   11
      Text            =   "frm50_0x21.frx":0000
      Top             =   2160
      Width           =   5175
   End
   Begin fishedit.userVar userX 
      Height          =   1095
      Left            =   6840
      TabIndex        =   9
      Top             =   600
      Width           =   1935
      _ExtentX        =   3413
      _ExtentY        =   1931
   End
   Begin fishedit.UserVar2 UserJ 
      Height          =   1335
      Left            =   4200
      TabIndex        =   7
      Top             =   600
      Width           =   2175
      _ExtentX        =   4048
      _ExtentY        =   2566
   End
   Begin fishedit.userVar userI 
      Height          =   1215
      Left            =   2160
      TabIndex        =   4
      Top             =   600
      Width           =   2055
      _ExtentX        =   3625
      _ExtentY        =   2566
   End
   Begin fishedit.UserVar2 UserSceneID 
      Height          =   1215
      Left            =   120
      TabIndex        =   2
      Top             =   600
      Width           =   2055
      _ExtentX        =   3625
      _ExtentY        =   2143
   End
   Begin VB.CommandButton cmdcancel 
      Caption         =   "取消"
      Height          =   375
      Left            =   9240
      TabIndex        =   1
      Top             =   1320
      Width           =   1335
   End
   Begin VB.CommandButton cmdok 
      Caption         =   "确定"
      Height          =   375
      Left            =   9240
      TabIndex        =   0
      Top             =   480
      Width           =   1335
   End
   Begin VB.Label Label7 
      Caption         =   "="
      Height          =   375
      Left            =   6480
      TabIndex        =   10
      Top             =   600
      Width           =   495
   End
   Begin VB.Label Label6 
      Caption         =   "值X"
      Height          =   375
      Left            =   6840
      TabIndex        =   8
      Top             =   120
      Width           =   1095
   End
   Begin VB.Label Label5 
      Caption         =   "场景事件属性编号J"
      Height          =   375
      Left            =   4200
      TabIndex        =   6
      Top             =   120
      Width           =   1815
   End
   Begin VB.Label Label4 
      Caption         =   "场景事件编号I"
      Height          =   375
      Left            =   2160
      TabIndex        =   5
      Top             =   120
      Width           =   1815
   End
   Begin VB.Label Label3 
      Caption         =   "场景代号ID"
      Height          =   375
      Left            =   120
      TabIndex        =   3
      Top             =   120
      Width           =   1815
   End
End
Attribute VB_Name = "frm50_0x21"
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
 
    kk.Data(1) = UserSceneID.Value + userI.Value * 2 + UserJ.Value * 4 + userX.Value * 8
    kk.Data(2) = UserSceneID.Text
    kk.Data(3) = userI.Text
    kk.Data(4) = UserJ.Text
    kk.Data(5) = userX.Text
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
    
    
    UserSceneID.Clear
    For i = 0 To Scenenum - 1
        UserSceneID.AddItem CLng(i) & ":" & Big5toUnicode(Scene(i).Name1, 10)
    Next i
    
    
    UserSceneID.Text = kk.Data(2)
    UserSceneID.Value = IIf((kk.Data(1) And &H1) > 0, 1, 0)
    userI.Value = IIf((kk.Data(1) And &H2) > 0, 1, 0)
    UserJ.Value = IIf((kk.Data(1) And &H4) > 0, 1, 0)
    userX.Value = IIf((kk.Data(1) And &H8) > 0, 1, 0)
    
    UserSceneID.SetCombo


    userI.Text = kk.Data(3)
    userI.SetCombo
    
    UserJ.Clear
    For i = 0 To GetINILong("D_modify", "num") - 1
        UserJ.AddItem i & ":" & GetINIStr("D_modify", "attrib" & i)
    Next i

    UserJ.Text = kk.Data(4)
    
    UserJ.SetCombo
    
    userX.Text = kk.Data(5)
    userX.SetCombo

    
    Call Set50Form(Me, kk.Data(0))

 
End Sub

 
