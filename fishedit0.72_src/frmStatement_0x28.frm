VERSION 5.00
Begin VB.Form frmStatement_0x28 
   Caption         =   "改变站立方向"
   ClientHeight    =   2220
   ClientLeft      =   60
   ClientTop       =   345
   ClientWidth     =   6000
   LinkTopic       =   "Form2"
   ScaleHeight     =   2220
   ScaleWidth      =   6000
   StartUpPosition =   2  '屏幕中心
   Begin VB.ComboBox Combo1 
      BeginProperty Font 
         Name            =   "Times New Roman"
         Size            =   9
         Charset         =   0
         Weight          =   400
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Height          =   345
      ItemData        =   "frmStatement_0x28.frx":0000
      Left            =   1080
      List            =   "frmStatement_0x28.frx":0002
      Style           =   2  'Dropdown List
      TabIndex        =   5
      Top             =   840
      Width           =   2655
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
      Left            =   1080
      TabIndex        =   2
      Text            =   "Text1"
      Top             =   240
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
      Left            =   4200
      TabIndex        =   1
      Top             =   360
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
      Left            =   4200
      TabIndex        =   0
      Top             =   1320
      Width           =   1335
   End
   Begin VB.Label Label2 
      Caption         =   "站立方向"
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
      Top             =   840
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
      Left            =   240
      TabIndex        =   3
      Top             =   240
      Width           =   855
   End
End
Attribute VB_Name = "frmStatement_0x28"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Option Explicit
'   40
Dim index As Long
Dim kk As Statement

Private Sub cmdcancel_Click()
    Unload Me
End Sub

Private Sub cmdok_Click()
    kk.data(0) = Combo1.ListIndex
    Unload Me
End Sub

Private Sub Form_Load()

    Combo1.Clear
    Combo1.AddItem LoadResStr(4001)
    Combo1.AddItem LoadResStr(4002)
    Combo1.AddItem LoadResStr(4003)
    Combo1.AddItem LoadResStr(4004)

    index = frmmain.listkdef.ListIndex
    Set kk = KdefInfo(frmmain.Combokdef.ListIndex).kdef.Item(index + 1)
    txtid.Text = kk.Id & "(" & Hex(kk.Id) & ")"
    Combo1.ListIndex = kk.data(0)



    Me.Caption = LoadResStr(556)
    Label1.Caption = LoadResStr(1102)
    Label2.Caption = LoadResStr(556)
    cmdok.Caption = LoadResStr(102)
    cmdcancel.Caption = LoadResStr(103)





End Sub


