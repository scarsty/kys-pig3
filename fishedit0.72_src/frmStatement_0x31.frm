VERSION 5.00
Begin VB.Form frmStatement_0x31 
   Caption         =   "设置内力属性"
   ClientHeight    =   2520
   ClientLeft      =   60
   ClientTop       =   345
   ClientWidth     =   6840
   LinkTopic       =   "Form2"
   ScaleHeight     =   2520
   ScaleWidth      =   6840
   StartUpPosition =   2  '屏幕中心
   Begin VB.ComboBox ComboNeili 
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
      ItemData        =   "frmStatement_0x31.frx":0000
      Left            =   1320
      List            =   "frmStatement_0x31.frx":000D
      Style           =   2  'Dropdown List
      TabIndex        =   7
      Top             =   1680
      Width           =   2295
   End
   Begin VB.ComboBox ComboPerson 
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
      Left            =   1320
      Style           =   2  'Dropdown List
      TabIndex        =   3
      Top             =   1080
      Width           =   2295
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
      TabIndex        =   2
      Top             =   1560
      Width           =   1335
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
      Top             =   600
      Width           =   1335
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
      Left            =   1200
      TabIndex        =   0
      Text            =   "Text1"
      Top             =   480
      Width           =   855
   End
   Begin VB.Label Label3 
      Caption         =   "内力属性"
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
      Left            =   360
      TabIndex        =   6
      Top             =   1680
      Width           =   735
   End
   Begin VB.Label Label2 
      Caption         =   "人物"
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
      Left            =   360
      TabIndex        =   5
      Top             =   1080
      Width           =   735
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
      Left            =   360
      TabIndex        =   4
      Top             =   480
      Width           =   855
   End
End
Attribute VB_Name = "frmStatement_0x31"
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
    kk.data(0) = Comboperson.ListIndex
    kk.data(1) = ComboNeili.ListIndex
    Unload Me
End Sub

Private Sub Form_Load()
Dim i As Long

   ComboNeili.Clear
   ComboNeili.AddItem LoadResStr(6401)
   ComboNeili.AddItem LoadResStr(6402)
   ComboNeili.AddItem LoadResStr(6403)



    index = frmmain.listkdef.ListIndex
    Set kk = KdefInfo(frmmain.Combokdef.ListIndex).kdef.Item(index + 1)
    
    Comboperson.Clear
    For i = 0 To PersonNum - 1
        Comboperson.AddItem i & "(" & Hex(i) & ")" & Person(i).name1
    Next i
    
    txtid.Text = kk.Id & "(" & Hex(kk.Id) & ")"
    Comboperson.ListIndex = kk.data(0)
    ComboNeili.ListIndex = kk.data(1)
    
    
    
    Me.Caption = LoadResStr(585)
    Label1.Caption = LoadResStr(1102)
    Label2.Caption = LoadResStr(2001)
    Label3.Caption = LoadResStr(585)

    cmdok.Caption = LoadResStr(102)
    cmdcancel.Caption = LoadResStr(103)
    
 
    
End Sub






