VERSION 5.00
Begin VB.Form frm50_0x02 
   Caption         =   "50指令2"
   ClientHeight    =   3645
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
   ScaleHeight     =   3645
   ScaleWidth      =   9255
   StartUpPosition =   2  '屏幕中心
   Begin VB.TextBox txtNote 
      Appearance      =   0  'Flat
      BackColor       =   &H80000013&
      BorderStyle     =   0  'None
      ForeColor       =   &H00FF0000&
      Height          =   975
      Left            =   120
      Locked          =   -1  'True
      MultiLine       =   -1  'True
      TabIndex        =   12
      Text            =   "frm50_0x02.frx":0000
      Top             =   2640
      Width           =   4215
   End
   Begin fishedit.userVar userI 
      Height          =   1095
      Left            =   4440
      TabIndex        =   9
      Top             =   1200
      Width           =   1815
      _ExtentX        =   3201
      _ExtentY        =   1931
   End
   Begin VB.ComboBox comboType 
      Height          =   345
      Left            =   120
      Style           =   2  'Dropdown List
      TabIndex        =   7
      Top             =   120
      Width           =   1455
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
      Left            =   0
      TabIndex        =   10
      Top             =   1200
      Width           =   1815
      _ExtentX        =   3201
      _ExtentY        =   1931
   End
   Begin fishedit.userVar userX 
      Height          =   1095
      Left            =   2280
      TabIndex        =   11
      Top             =   1200
      Width           =   1815
      _ExtentX        =   3201
      _ExtentY        =   1931
      Value           =   1
   End
   Begin VB.Label Label8 
      Caption         =   "="
      Height          =   375
      Left            =   1920
      TabIndex        =   8
      Top             =   1200
      Width           =   375
   End
   Begin VB.Label Label7 
      Caption         =   ")"
      BeginProperty Font 
         Name            =   "Times New Roman"
         Size            =   12
         Charset         =   0
         Weight          =   400
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Height          =   375
      Left            =   6480
      TabIndex        =   6
      Top             =   1200
      Width           =   375
   End
   Begin VB.Label Label6 
      Caption         =   "("
      Height          =   375
      Left            =   4200
      TabIndex        =   5
      Top             =   1200
      Width           =   375
   End
   Begin VB.Label Label5 
      Caption         =   "变量Y"
      Height          =   375
      Left            =   240
      TabIndex        =   4
      Top             =   720
      Width           =   855
   End
   Begin VB.Label Label4 
      Caption         =   "下标I"
      Height          =   255
      Left            =   4920
      TabIndex        =   3
      Top             =   600
      Width           =   495
   End
   Begin VB.Label Label3 
      Caption         =   "数组/字符串变量X"
      Height          =   615
      Left            =   2280
      TabIndex        =   2
      Top             =   600
      Width           =   1095
   End
End
Attribute VB_Name = "frm50_0x02"
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
 
    kk.Data(2) = comboType.ListIndex
    kk.Data(3) = userX.Text
    kk.Data(4) = userI.Text
    kk.Data(5) = userY.Text
    kk.Data(6) = 0
    kk.Data(1) = userI.Value
    
    Unload Me
    
End Sub

 

Private Sub Form_Load()
Dim num50 As Long
Dim i As Long
Dim s1 As String
    Call ConvertForm(Me)
    
    comboType.Clear
    comboType.AddItem StrUnicode2("存取16位字")
    comboType.AddItem StrUnicode2("存取8位字节")
    
    Index = frmmain.listkdef.ListIndex
    Set kk = KdefInfo(frmmain.Combokdef.ListIndex).kdef.Item(Index + 1)
    
    comboType.ListIndex = kk.Data(2)
    userX.Text = kk.Data(3)
    userI.Text = kk.Data(4)
    userY.Text = kk.Data(5)
    
    userI.Value = IIf((kk.Data(1) And &H1) > 0, 1, 0)
    
    Call Set50Form(Me, kk.Data(0))

    userX.Showtype = False
    userX.SetCombo
    userY.Showtype = False
    userY.SetCombo
    userI.SetCombo

End Sub

 
