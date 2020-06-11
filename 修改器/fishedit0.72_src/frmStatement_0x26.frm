VERSION 5.00
Begin VB.Form frmStatement_0x26 
   Caption         =   "修改场景所有贴图"
   ClientHeight    =   2760
   ClientLeft      =   60
   ClientTop       =   345
   ClientWidth     =   7035
   LinkTopic       =   "Form2"
   ScaleHeight     =   2760
   ScaleWidth      =   7035
   StartUpPosition =   2  '屏幕中心
   Begin VB.TextBox txtnewpic 
      BeginProperty Font 
         Name            =   "Times New Roman"
         Size            =   9
         Charset         =   0
         Weight          =   400
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Height          =   270
      Left            =   1440
      TabIndex        =   11
      Top             =   2040
      Width           =   1575
   End
   Begin VB.TextBox txtoldpic 
      BeginProperty Font 
         Name            =   "Times New Roman"
         Size            =   9
         Charset         =   0
         Weight          =   400
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Height          =   270
      Left            =   1440
      TabIndex        =   9
      Top             =   1560
      Width           =   1575
   End
   Begin VB.TextBox txtlevel 
      BeginProperty Font 
         Name            =   "Times New Roman"
         Size            =   9
         Charset         =   0
         Weight          =   400
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Height          =   270
      Left            =   1440
      TabIndex        =   7
      Top             =   1080
      Width           =   1575
   End
   Begin VB.TextBox txtaddress 
      BeginProperty Font 
         Name            =   "Times New Roman"
         Size            =   9
         Charset         =   0
         Weight          =   400
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Height          =   270
      Left            =   1440
      TabIndex        =   5
      Top             =   600
      Width           =   1575
   End
   Begin VB.TextBox txtid 
      Enabled         =   0   'False
      BeginProperty Font 
         Name            =   "Times New Roman"
         Size            =   9
         Charset         =   0
         Weight          =   400
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Height          =   285
      Left            =   960
      TabIndex        =   2
      Text            =   "Text1"
      Top             =   120
      Width           =   855
   End
   Begin VB.CommandButton cmdok 
      Caption         =   "确定"
      BeginProperty Font 
         Name            =   "Times New Roman"
         Size            =   9
         Charset         =   0
         Weight          =   400
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Height          =   375
      Left            =   5280
      TabIndex        =   1
      Top             =   480
      Width           =   1335
   End
   Begin VB.CommandButton cmdcancel 
      Caption         =   "取消"
      BeginProperty Font 
         Name            =   "Times New Roman"
         Size            =   9
         Charset         =   0
         Weight          =   400
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Height          =   375
      Left            =   5280
      TabIndex        =   0
      Top             =   1440
      Width           =   1335
   End
   Begin VB.Label Label5 
      Caption         =   "替换新贴图"
      BeginProperty Font 
         Name            =   "Times New Roman"
         Size            =   9
         Charset         =   0
         Weight          =   400
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Height          =   255
      Left            =   120
      TabIndex        =   10
      Top             =   2040
      Width           =   1095
   End
   Begin VB.Label Label4 
      Caption         =   "原有贴图"
      BeginProperty Font 
         Name            =   "Times New Roman"
         Size            =   9
         Charset         =   0
         Weight          =   400
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Height          =   255
      Left            =   120
      TabIndex        =   8
      Top             =   1560
      Width           =   855
   End
   Begin VB.Label Label3 
      Caption         =   "图层"
      BeginProperty Font 
         Name            =   "Times New Roman"
         Size            =   9
         Charset         =   0
         Weight          =   400
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Height          =   375
      Left            =   120
      TabIndex        =   6
      Top             =   1080
      Width           =   855
   End
   Begin VB.Label Label2 
      Caption         =   "场景编号"
      BeginProperty Font 
         Name            =   "Times New Roman"
         Size            =   9
         Charset         =   0
         Weight          =   400
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Height          =   255
      Left            =   120
      TabIndex        =   4
      Top             =   600
      Width           =   855
   End
   Begin VB.Label Label1 
      Caption         =   "指令id"
      BeginProperty Font 
         Name            =   "Times New Roman"
         Size            =   9
         Charset         =   0
         Weight          =   400
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Height          =   375
      Left            =   120
      TabIndex        =   3
      Top             =   120
      Width           =   855
   End
End
Attribute VB_Name = "frmStatement_0x26"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Option Explicit

Dim index As Long
Dim kk As Statement

Private Sub cmdcancel_Click()
    Unload Me
End Sub

Private Sub cmdok_Click()
    kk.data(0) = txtaddress.Text
    kk.data(1) = txtlevel.Text
    kk.data(2) = txtoldpic.Text
    kk.data(3) = txtnewpic.Text
    Unload Me
End Sub

Private Sub Form_Load()
    index = frmmain.listkdef.ListIndex
    Set kk = KdefInfo(frmmain.Combokdef.ListIndex).kdef.Item(index + 1)
    txtid.Text = kk.Id & "(" & Hex(kk.Id) & ")"
    txtaddress.Text = kk.data(0)
    txtlevel.Text = kk.data(1)
    txtoldpic.Text = kk.data(2)
    txtnewpic.Text = kk.data(3)
    
    
    
    Me.Caption = LoadResStr(3801)
    Label1.Caption = LoadResStr(1102)
    Label2.Caption = LoadResStr(3802)
    Label3.Caption = LoadResStr(3803)
    Label4.Caption = LoadResStr(3804)
    Label5.Caption = LoadResStr(3805)
    cmdok.Caption = LoadResStr(102)
    cmdcancel.Caption = LoadResStr(103)

    
    
    
End Sub


