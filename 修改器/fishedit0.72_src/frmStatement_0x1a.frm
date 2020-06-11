VERSION 5.00
Begin VB.Form frmStatement_0x1a 
   Caption         =   "增加场景事件编号增加值"
   ClientHeight    =   3030
   ClientLeft      =   60
   ClientTop       =   345
   ClientWidth     =   7050
   LinkTopic       =   "Form2"
   ScaleHeight     =   3030
   ScaleWidth      =   7050
   StartUpPosition =   2  '屏幕中心
   Begin VB.TextBox txtkdef3 
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
      Left            =   2640
      TabIndex        =   10
      Top             =   2280
      Width           =   855
   End
   Begin VB.TextBox txtkdef2 
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
      Left            =   2640
      TabIndex        =   9
      Top             =   1920
      Width           =   855
   End
   Begin VB.TextBox txtkdef1 
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
      Left            =   2640
      TabIndex        =   8
      Top             =   1560
      Width           =   855
   End
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
      Left            =   1800
      TabIndex        =   7
      Top             =   1080
      Width           =   1695
   End
   Begin VB.ComboBox ComboAddress 
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
      Left            =   1800
      Style           =   2  'Dropdown List
      TabIndex        =   4
      Top             =   600
      Width           =   1695
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
      Left            =   4920
      TabIndex        =   2
      Top             =   1440
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
      Left            =   4920
      TabIndex        =   1
      Top             =   360
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
      Left            =   1560
      TabIndex        =   0
      Text            =   "Text1"
      Top             =   120
      Width           =   855
   End
   Begin VB.Label Label6 
      Caption         =   "主角经过触发事件编号增加值"
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
      TabIndex        =   13
      Top             =   2280
      Width           =   2415
   End
   Begin VB.Label Label5 
      Caption         =   "使用物品触发事件编号增加值"
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
      TabIndex        =   12
      Top             =   1920
      Width           =   2415
   End
   Begin VB.Label Label4 
      Caption         =   "使用空格触发事件编号增加值"
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
      TabIndex        =   11
      Top             =   1560
      Width           =   2415
   End
   Begin VB.Label Label3 
      Caption         =   "场景事件序号"
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
      TabIndex        =   6
      Top             =   1080
      Width           =   1215
   End
   Begin VB.Label Label2 
      Caption         =   "场景"
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
      TabIndex        =   5
      Top             =   600
      Width           =   1095
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
      TabIndex        =   3
      Top             =   120
      Width           =   855
   End
End
Attribute VB_Name = "frmStatement_0x1a"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Option Explicit
' 26
Dim index As Long
Dim kk As Statement

Private Sub cmdcancel_Click()
    Unload Me
End Sub

Private Sub cmdok_Click()
    If ComboAddress.ListIndex = 0 Then
        kk.data(0) = &HFFFE
    Else
        kk.data(0) = ComboAddress.ListIndex - 1
    End If
    kk.data(1) = txtnum.Text
    kk.data(2) = txtkdef1.Text
    kk.data(3) = txtkdef2.Text
    kk.data(4) = txtkdef3.Text
    Unload Me
End Sub

Private Sub Form_Load()
Dim i As Long
    index = frmmain.listkdef.ListIndex
    Set kk = KdefInfo(frmmain.Combokdef.ListIndex).kdef.Item(index + 1)
    
    ComboAddress.Clear
    ComboAddress.AddItem "---" & LoadResStr(509) & "---"
    For i = 1 To Scenenum
        ComboAddress.AddItem i - 1 & Big5toUnicode(Scene(i - 1).Name1, 10)
    Next i

    
    txtid.Text = kk.Id & "(" & Hex(kk.Id) & ")"
    
    
    If kk.data(0) = &HFFFE Then
        ComboAddress.ListIndex = 0
    Else
        ComboAddress.ListIndex = kk.data(0) + 1
    End If

    txtnum.Text = kk.data(1)
    txtkdef1.Text = kk.data(2)
    txtkdef2.Text = kk.data(3)
    txtkdef3.Text = kk.data(4)


    Me.Caption = LoadResStr(539)
    Label1.Caption = LoadResStr(1102)
    Label2.Caption = LoadResStr(510)
    Label3.Caption = LoadResStr(512)
    Label4.Caption = LoadResStr(2601)
    Label5.Caption = LoadResStr(2602)
    Label6.Caption = LoadResStr(2603)
    cmdok.Caption = LoadResStr(102)
    cmdcancel.Caption = LoadResStr(103)

    
    
End Sub

