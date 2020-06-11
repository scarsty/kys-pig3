VERSION 5.00
Begin VB.Form frmstatement_0x02 
   Caption         =   "增加物品"
   ClientHeight    =   2355
   ClientLeft      =   60
   ClientTop       =   345
   ClientWidth     =   7740
   LinkTopic       =   "Form2"
   ScaleHeight     =   2355
   ScaleWidth      =   7740
   StartUpPosition =   2  '屏幕中心
   Begin VB.TextBox txtnum 
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
      Left            =   1320
      TabIndex        =   7
      Text            =   "Text1"
      Top             =   1320
      Width           =   855
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
      Left            =   5760
      TabIndex        =   4
      Top             =   1320
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
      Left            =   5760
      TabIndex        =   3
      Top             =   360
      Width           =   1335
   End
   Begin VB.ComboBox Combothings 
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
      TabIndex        =   2
      Top             =   720
      Width           =   2535
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
      Left            =   840
      TabIndex        =   0
      Text            =   "Text1"
      Top             =   240
      Width           =   855
   End
   Begin VB.Label Label3 
      Caption         =   "数量"
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
      TabIndex        =   6
      Top             =   1320
      Width           =   615
   End
   Begin VB.Label Label2 
      Caption         =   "物品名称"
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
      TabIndex        =   5
      Top             =   720
      Width           =   975
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
      TabIndex        =   1
      Top             =   240
      Width           =   855
   End
End
Attribute VB_Name = "frmstatement_0x02"
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
    kk.Data(0) = Combothings.ListIndex
    kk.Data(1) = txtnum.Text
    Unload Me
End Sub

Private Sub Form_Load()
Dim i As Long
    
    
    Combothings.Clear
    For i = 0 To Thingsnum - 1
        Combothings.AddItem i & "(" & Hex(i) & ")" & Things(i).Name1
    Next i


    Index = frmmain.listkdef.ListIndex
    Set kk = KdefInfo(frmmain.Combokdef.ListIndex).kdef.Item(Index + 1)
    txtid.Text = kk.id & "(" & Hex(kk.id) & ")"
    Combothings.ListIndex = kk.Data(0)
    txtnum.Text = kk.Data(1)

    Me.Caption = LoadResStr(507)
    Label1.Caption = LoadResStr(1102)
    Label2.Caption = LoadResStr(1201)
    Label3.Caption = LoadResStr(1202)
    cmdok.Caption = LoadResStr(102)
    cmdcancel.Caption = LoadResStr(103)
End Sub

Private Sub txtnum_Change()
If txtnum.Text >= 32767 Then
   txtnum.Text = 32767
   Else
   End If
End Sub
