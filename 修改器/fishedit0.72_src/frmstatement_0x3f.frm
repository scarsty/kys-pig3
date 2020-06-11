VERSION 5.00
Begin VB.Form frmstatement_0x3f 
   Caption         =   "设置人物性别"
   ClientHeight    =   2430
   ClientLeft      =   60
   ClientTop       =   345
   ClientWidth     =   5460
   LinkTopic       =   "Form2"
   ScaleHeight     =   2430
   ScaleWidth      =   5460
   StartUpPosition =   2  '屏幕中心
   Begin VB.ComboBox Combosex 
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
      ItemData        =   "frmstatement_0x3f.frx":0000
      Left            =   1080
      List            =   "frmstatement_0x3f.frx":000D
      Style           =   2  'Dropdown List
      TabIndex        =   7
      Top             =   1560
      Width           =   2295
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
      TabIndex        =   3
      Text            =   "Text1"
      Top             =   360
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
      Left            =   3960
      TabIndex        =   2
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
      Left            =   3960
      TabIndex        =   1
      Top             =   1440
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
      Left            =   1080
      Style           =   2  'Dropdown List
      TabIndex        =   0
      Top             =   960
      Width           =   2295
   End
   Begin VB.Label Label3 
      Caption         =   "性别"
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
      Top             =   1560
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
      TabIndex        =   5
      Top             =   360
      Width           =   855
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
      Left            =   120
      TabIndex        =   4
      Top             =   960
      Width           =   735
   End
End
Attribute VB_Name = "frmstatement_0x3f"
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

 
    kk.data(1) = Combosex.ListIndex
    Unload Me
End Sub



Private Sub Form_Load()
Dim i As Long
       
   Combosex.Clear
   Combosex.AddItem LoadResStr(6302)
   Combosex.AddItem LoadResStr(6303)
   Combosex.AddItem LoadResStr(6304)
    
    
    index = frmmain.listkdef.ListIndex
    Set kk = KdefInfo(frmmain.Combokdef.ListIndex).kdef.Item(index + 1)
    
    Comboperson.Clear
    For i = 0 To PersonNum - 1
        Comboperson.AddItem i & "(" & Hex(i) & ")" & Person(i).name1
    Next i



    
    txtid.Text = kk.Id & "(" & Hex(kk.Id) & ")"
    Comboperson.ListIndex = kk.data(0)
    Combosex.ListIndex = kk.data(1)


    Me.Caption = LoadResStr(6301)
    Label1.Caption = LoadResStr(1102)
    Label2.Caption = LoadResStr(2001)
    Label3.Caption = LoadResStr(578)

    cmdok.Caption = LoadResStr(102)
    cmdcancel.Caption = LoadResStr(103)



End Sub








