VERSION 5.00
Begin VB.Form frmStatement_0x16 
   Caption         =   "队伍是否有"
   ClientHeight    =   2775
   ClientLeft      =   60
   ClientTop       =   345
   ClientWidth     =   6390
   LinkTopic       =   "Form2"
   ScaleHeight     =   2775
   ScaleWidth      =   6390
   StartUpPosition =   2  '屏幕中心
   Begin VB.ComboBox ComboPerson 
      Height          =   300
      Left            =   1800
      Style           =   2  'Dropdown List
      TabIndex        =   3
      Top             =   960
      Width           =   2655
   End
   Begin VB.CommandButton cmdcancel 
      Caption         =   "取消"
      Height          =   375
      Left            =   4680
      TabIndex        =   2
      Top             =   1320
      Width           =   1335
   End
   Begin VB.CommandButton cmdok 
      Caption         =   "确定"
      Height          =   375
      Left            =   4680
      TabIndex        =   1
      Top             =   480
      Width           =   1335
   End
   Begin VB.TextBox txtid 
      Enabled         =   0   'False
      Height          =   285
      Left            =   960
      TabIndex        =   0
      Text            =   "Text1"
      Top             =   360
      Width           =   855
   End
   Begin VB.Label Label2 
      Caption         =   "队伍是否有人物"
      Height          =   255
      Left            =   120
      TabIndex        =   5
      Top             =   960
      Width           =   1455
   End
   Begin VB.Label Label1 
      Caption         =   "指令id"
      Height          =   375
      Left            =   120
      TabIndex        =   4
      Top             =   360
      Width           =   855
   End
End
Attribute VB_Name = "frmStatement_0x16"
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
    kk.data(0) = ComboPerson.ListIndex
    Unload Me
End Sub

Private Sub Form_Load()
Dim i As Long
    index = Form1.listkdef.ListIndex
    Set kk = KdefInfo(Form1.Combokdef.ListIndex).kdef.Item(index + 1)
    
    ComboPerson.Clear
    For i = 0 To PersonNum - 1
        ComboPerson.AddItem i & "(" & Hex(i) & ")" & Person(i).name1
    Next i

    
    txtid.Text = kk.Id & "(" & Hex(kk.Id) & ")"
    ComboPerson.ListIndex = kk.data(0)
End Sub



