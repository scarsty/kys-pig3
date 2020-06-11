VERSION 5.00
Begin VB.Form frm50_0x44 
   Caption         =   "50指令44"
   ClientHeight    =   2940
   ClientLeft      =   60
   ClientTop       =   420
   ClientWidth     =   8385
   LinkTopic       =   "Form1"
   ScaleHeight     =   2940
   ScaleWidth      =   8385
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
      TabIndex        =   8
      Text            =   "frm50_0x44.frx":0000
      Top             =   2040
      Width           =   6495
   End
   Begin VB.CommandButton cmdcancel 
      Caption         =   "取消"
      Height          =   375
      Left            =   6840
      TabIndex        =   7
      Top             =   1800
      Width           =   1335
   End
   Begin VB.CommandButton cmdok 
      Caption         =   "确定"
      Height          =   375
      Left            =   6840
      TabIndex        =   6
      Top             =   840
      Width           =   1335
   End
   Begin fishedit.userVar userE 
      Height          =   1455
      Left            =   4560
      TabIndex        =   2
      Top             =   840
      Width           =   2055
      _ExtentX        =   3625
      _ExtentY        =   2566
   End
   Begin fishedit.userVar userT 
      Height          =   1335
      Left            =   2280
      TabIndex        =   1
      Top             =   840
      Width           =   2055
      _ExtentX        =   3625
      _ExtentY        =   2355
   End
   Begin fishedit.userVar userID 
      Height          =   1335
      Left            =   120
      TabIndex        =   0
      Top             =   840
      Width           =   1575
      _ExtentX        =   2778
      _ExtentY        =   2355
   End
   Begin VB.Label Label3 
      Caption         =   "效果编号  "
      Height          =   255
      Left            =   4560
      TabIndex        =   5
      Top             =   480
      Width           =   1335
   End
   Begin VB.Label Label2 
      Caption         =   "人物动作类型"
      Height          =   375
      Left            =   2280
      TabIndex        =   4
      Top             =   480
      Width           =   1935
   End
   Begin VB.Label Label1 
      Caption         =   "战斗序号 "
      Height          =   375
      Left            =   120
      TabIndex        =   3
      Top             =   480
      Width           =   1695
   End
End
Attribute VB_Name = "frm50_0x44"
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
    kk.Data(1) = userID.Value + userT.Value * 2 + userE.Value * 4
    kk.Data(2) = userID.Text
    kk.Data(3) = userT.Text
    kk.Data(4) = userE.Text
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

    
    userID.Value = IIf((kk.Data(1) And &H1) > 0, 1, 0)
    userT.Value = IIf((kk.Data(1) And &H2) > 0, 1, 0)
    userE.Value = IIf((kk.Data(1) And &H4) > 0, 1, 0)


    
    
    userID.Text = kk.Data(2)
    userID.SetCombo
    userT.Text = kk.Data(3)
    userT.SetCombo
    
    
    userE.Text = kk.Data(4)
    userE.SetCombo
    
    
    
    

    Call Set50Form(Me, kk.Data(0))

End Sub

