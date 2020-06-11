VERSION 5.00
Begin VB.Form frm50_0x46 
   Caption         =   "50指令46"
   ClientHeight    =   3120
   ClientLeft      =   60
   ClientTop       =   420
   ClientWidth     =   11610
   LinkTopic       =   "Form1"
   ScaleHeight     =   3120
   ScaleWidth      =   11610
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
      TabIndex        =   12
      Text            =   "frm50_0x46.frx":0000
      Top             =   2280
      Width           =   9735
   End
   Begin VB.CommandButton cmdcancel 
      Caption         =   "取消"
      Height          =   375
      Left            =   10080
      TabIndex        =   6
      Top             =   1320
      Width           =   1335
   End
   Begin VB.CommandButton cmdok 
      Caption         =   "确定"
      Height          =   375
      Left            =   10080
      TabIndex        =   5
      Top             =   360
      Width           =   1335
   End
   Begin fishedit.userVar user5 
      Height          =   1575
      Left            =   8040
      TabIndex        =   4
      Top             =   600
      Width           =   1815
      _ExtentX        =   3201
      _ExtentY        =   2778
   End
   Begin fishedit.userVar user4 
      Height          =   1575
      Left            =   6000
      TabIndex        =   3
      Top             =   600
      Width           =   1935
      _ExtentX        =   3413
      _ExtentY        =   2778
   End
   Begin fishedit.userVar user3 
      Height          =   1575
      Left            =   4080
      TabIndex        =   2
      Top             =   600
      Width           =   1935
      _ExtentX        =   3413
      _ExtentY        =   2778
   End
   Begin fishedit.userVar user2 
      Height          =   1575
      Left            =   2160
      TabIndex        =   1
      Top             =   600
      Width           =   1815
      _ExtentX        =   3201
      _ExtentY        =   2778
   End
   Begin fishedit.userVar user1 
      Height          =   1575
      Left            =   120
      TabIndex        =   0
      Top             =   600
      Width           =   1815
      _ExtentX        =   3201
      _ExtentY        =   2778
   End
   Begin VB.Label Label5 
      Caption         =   "数值 "
      Height          =   375
      Left            =   8040
      TabIndex        =   11
      Top             =   120
      Width           =   1455
   End
   Begin VB.Label Label4 
      Caption         =   "y长度"
      Height          =   375
      Left            =   6000
      TabIndex        =   10
      Top             =   120
      Width           =   1575
   End
   Begin VB.Label Label3 
      Caption         =   "x长度"
      Height          =   375
      Left            =   4080
      TabIndex        =   9
      Top             =   120
      Width           =   1695
   End
   Begin VB.Label Label2 
      Caption         =   "y起始点"
      Height          =   375
      Left            =   2160
      TabIndex        =   8
      Top             =   120
      Width           =   1455
   End
   Begin VB.Label Label1 
      Caption         =   "x起始点 "
      Height          =   375
      Left            =   120
      TabIndex        =   7
      Top             =   120
      Width           =   1575
   End
End
Attribute VB_Name = "frm50_0x46"
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
 If user5.Text <> 0 Or 1 Then
    MsgBox "only can 0 or 1", vbOKOnly, "!warning!"
    Exit Sub
   Else
    kk.Data(1) = user1.Value + user2.Value * 2 + user3.Value * 4 + user4.Value * 8 + user5.Value * 16
    kk.Data(2) = user1.Text
    kk.Data(3) = user2.Text
    kk.Data(4) = user3.Text
    kk.Data(5) = user4.Text
    kk.Data(6) = user5.Text
    Unload Me
 End If
End Sub

Private Sub Form_Load()
Dim num50 As Long
Dim i As Long
Dim s1 As String
    Call ConvertForm(Me)
    
    
    Index = frmmain.listkdef.ListIndex
    Set kk = KdefInfo(frmmain.Combokdef.ListIndex).kdef.Item(Index + 1)

    
    user1.Value = IIf((kk.Data(1) And &H1) > 0, 1, 0)
    user2.Value = IIf((kk.Data(1) And &H2) > 0, 1, 0)
    user3.Value = IIf((kk.Data(1) And &H4) > 0, 1, 0)
    user4.Value = IIf((kk.Data(1) And &H8) > 0, 1, 0)
    user5.Value = IIf((kk.Data(1) And &H16) > 0, 1, 0)

    
    
    user1.Text = kk.Data(2)
    user1.SetCombo
    user2.Text = kk.Data(3)
    user2.SetCombo
    
    
    user3.Text = kk.Data(4)
    user3.SetCombo
    user4.Text = kk.Data(5)
    user4.SetCombo
    user5.Text = kk.Data(6)
    user5.SetCombo
    
    
    
    

    Call Set50Form(Me, kk.Data(0))

End Sub


