VERSION 5.00
Begin VB.Form frmStatement_0x15 
   Caption         =   "离队"
   ClientHeight    =   2325
   ClientLeft      =   60
   ClientTop       =   345
   ClientWidth     =   6225
   LinkTopic       =   "Form2"
   ScaleHeight     =   2325
   ScaleWidth      =   6225
   StartUpPosition =   2  '屏幕中心
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
      Left            =   840
      TabIndex        =   3
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
      Left            =   4560
      TabIndex        =   2
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
      Left            =   4560
      TabIndex        =   1
      Top             =   1200
      Width           =   1335
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
      Left            =   1680
      Style           =   2  'Dropdown List
      TabIndex        =   0
      Top             =   840
      Width           =   2655
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
      Left            =   0
      TabIndex        =   5
      Top             =   240
      Width           =   855
   End
   Begin VB.Label Label2 
      Caption         =   "离队队员"
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
      Left            =   240
      TabIndex        =   4
      Top             =   840
      Width           =   1455
   End
End
Attribute VB_Name = "frmStatement_0x15"
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
    Unload Me
End Sub

Private Sub Form_Load()
Dim i As Long
    index = frmmain.listkdef.ListIndex
    Set kk = KdefInfo(frmmain.Combokdef.ListIndex).kdef.Item(index + 1)
    
    Comboperson.Clear
    For i = 0 To PersonNum - 1
        Comboperson.AddItem i & "(" & Hex(i) & ")" & Person(i).name1
    Next i

    
    txtid.Text = kk.Id & "(" & Hex(kk.Id) & ")"
    Comboperson.ListIndex = kk.data(0)
    
    
    Me.Caption = LoadResStr(534)
    Label1.Caption = LoadResStr(1102)
    Label2.Caption = LoadResStr(534) & LoadResStr(2001)
    
 
   
    cmdok.Caption = LoadResStr(102)
    cmdcancel.Caption = LoadResStr(103)
    
    
    
End Sub




