VERSION 5.00
Begin VB.Form frmChangeRValue 
   Caption         =   "Form1"
   ClientHeight    =   1245
   ClientLeft      =   60
   ClientTop       =   345
   ClientWidth     =   6720
   LinkTopic       =   "Form1"
   ScaleHeight     =   1245
   ScaleWidth      =   6720
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
      Left            =   1680
      Style           =   2  'Dropdown List
      TabIndex        =   4
      Top             =   600
      Width           =   1935
   End
   Begin VB.TextBox Text1 
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
      Left            =   1680
      TabIndex        =   3
      Text            =   "Text1"
      Top             =   120
      Width           =   3255
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
      Left            =   5160
      TabIndex        =   1
      Top             =   720
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
      Left            =   5160
      TabIndex        =   0
      Top             =   120
      Width           =   1335
   End
   Begin VB.Label Label1 
      Caption         =   "Label1"
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
      TabIndex        =   2
      Top             =   120
      Width           =   1455
   End
End
Attribute VB_Name = "frmChangeRValue"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Option Explicit

Public OK As Long
Dim i As Long, j As Long, k As Long

Private Sub cmdcancel_Click()
    Me.Hide
End Sub

Private Sub cmdok_Click()
    OK = 1
    Me.Hide
End Sub

Private Sub Combo1_click()
    If Combo1.ListIndex = -1 Then Exit Sub
    Text1.Text = Combo1.ListIndex - 1
End Sub

Private Sub Form_Load()
    OK = 0
    cmdok.Caption = LoadResStr(102)
    cmdcancel.Caption = LoadResStr(103)
    
    Me.Caption = LoadResStr(10601)
    i = frmREdit.ComboType.ListIndex
    j = frmREdit.ComboNumber.ListIndex
    k = frmREdit.ListItem.ListIndex
    If i < 0 Or j < 0 Or k < 0 Then Exit Sub
    
    
End Sub

