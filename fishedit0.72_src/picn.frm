VERSION 5.00
Begin VB.Form picn 
   Caption         =   "text"
   ClientHeight    =   1950
   ClientLeft      =   60
   ClientTop       =   420
   ClientWidth     =   6285
   LinkTopic       =   "Form1"
   ScaleHeight     =   1950
   ScaleWidth      =   6285
   StartUpPosition =   2  '屏幕中心
   Begin VB.CommandButton Command3 
      Caption         =   "text"
      Height          =   375
      Left            =   5040
      TabIndex        =   10
      Top             =   1320
      Width           =   1095
   End
   Begin VB.CommandButton Command2 
      Caption         =   "text"
      Height          =   375
      Left            =   5040
      TabIndex        =   9
      Top             =   840
      Width           =   1095
   End
   Begin VB.CommandButton Command1 
      Caption         =   "text"
      Height          =   375
      Left            =   4320
      TabIndex        =   8
      Top             =   360
      Width           =   1815
   End
   Begin VB.TextBox Text4 
      Height          =   375
      Left            =   3000
      TabIndex        =   7
      Text            =   "Text4"
      Top             =   1320
      Width           =   1095
   End
   Begin VB.TextBox Text3 
      Height          =   375
      Left            =   1560
      TabIndex        =   5
      Text            =   "Text3"
      Top             =   1320
      Width           =   975
   End
   Begin VB.TextBox Text2 
      Height          =   375
      Left            =   3000
      TabIndex        =   3
      Text            =   "Text2"
      Top             =   360
      Width           =   1095
   End
   Begin VB.TextBox Text1 
      Height          =   375
      Left            =   1560
      TabIndex        =   1
      Text            =   "Text1"
      Top             =   360
      Width           =   975
   End
   Begin VB.Label Label4 
      Caption         =   "~"
      Height          =   255
      Left            =   2640
      TabIndex        =   6
      Top             =   1440
      Width           =   255
   End
   Begin VB.Label Label3 
      Caption         =   "text"
      Height          =   375
      Left            =   0
      TabIndex        =   4
      Top             =   1320
      Width           =   1335
   End
   Begin VB.Label Label2 
      Caption         =   "~"
      Height          =   255
      Left            =   2640
      TabIndex        =   2
      Top             =   480
      Width           =   255
   End
   Begin VB.Label Label1 
      Caption         =   "text"
      Height          =   255
      Left            =   0
      TabIndex        =   0
      Top             =   360
      Width           =   1455
   End
End
Attribute VB_Name = "picn"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False

Private Sub Command2_Click()
Text1.Text = a
Text2.Text = b
Text3.Text = c
Text4.Text = d
End Sub

Private Sub Form_Load()
picn.Caption = StrUnicode2("批量处理图片~囧")
Label1.Caption = StrUnicode2("需要复制的贴图")
Label3.Caption = StrUnicode2("粘贴贴图到")
Command1.Visible = StrUnicode2("从最后一个贴图开始")
Command1.Visible = False
Command2.Caption = StrUnicode2("确定")
Command3.Caption = StrUnicode2("放弃")
Text1.Text = ""
Text2.Text = ""
Text3.Text = ""
Text4.Text = ""
Dim i As Integer
Dim a As Integer
Dim b As Integer
Dim c As Integer
Dim d As Integer
End Sub

