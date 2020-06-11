VERSION 5.00
Begin VB.Form frmD_EventEdit 
   Caption         =   "D_Edit"
   ClientHeight    =   4455
   ClientLeft      =   60
   ClientTop       =   345
   ClientWidth     =   6165
   LinkTopic       =   "Form1"
   ScaleHeight     =   4455
   ScaleWidth      =   6165
   StartUpPosition =   2  '屏幕中心
   Begin VB.CommandButton cmdPic3 
      Caption         =   "Command2"
      Height          =   375
      Left            =   2760
      TabIndex        =   23
      Top             =   2880
      Width           =   1335
   End
   Begin VB.CommandButton CmdPic2 
      Caption         =   "Command1"
      Height          =   375
      Left            =   2760
      TabIndex        =   22
      Top             =   2400
      Width           =   1335
   End
   Begin VB.CommandButton cmdPic1 
      Caption         =   "Command1"
      Height          =   375
      Left            =   2760
      TabIndex        =   21
      Top             =   1920
      Width           =   1335
   End
   Begin VB.TextBox Text11 
      Height          =   270
      Left            =   1800
      TabIndex        =   20
      Text            =   "Text11"
      Top             =   4080
      Width           =   855
   End
   Begin VB.TextBox Text10 
      Height          =   270
      Left            =   1800
      TabIndex        =   18
      Text            =   "Text10"
      Top             =   3720
      Width           =   855
   End
   Begin VB.TextBox Text9 
      Height          =   270
      Left            =   1800
      TabIndex        =   16
      Text            =   "Text9"
      Top             =   3360
      Width           =   855
   End
   Begin VB.TextBox Text8 
      Height          =   270
      Left            =   1800
      TabIndex        =   14
      Text            =   "Text8"
      Top             =   2880
      Width           =   855
   End
   Begin VB.TextBox Text7 
      Height          =   270
      Left            =   1800
      TabIndex        =   13
      Text            =   "Text7"
      Top             =   2400
      Width           =   855
   End
   Begin VB.TextBox Text6 
      Height          =   270
      Left            =   1800
      TabIndex        =   12
      Text            =   "Text6"
      Top             =   1920
      Width           =   855
   End
   Begin VB.TextBox Text5 
      Height          =   270
      Left            =   1800
      TabIndex        =   11
      Text            =   "Text5"
      Top             =   1560
      Width           =   855
   End
   Begin VB.TextBox Text4 
      Height          =   270
      Left            =   1800
      TabIndex        =   9
      Text            =   "Text4"
      Top             =   1200
      Width           =   855
   End
   Begin VB.TextBox Text3 
      Height          =   270
      Left            =   1800
      TabIndex        =   7
      Text            =   "Text3"
      Top             =   840
      Width           =   855
   End
   Begin VB.TextBox Text2 
      Height          =   270
      Left            =   1800
      TabIndex        =   5
      Text            =   "Text2"
      Top             =   480
      Width           =   855
   End
   Begin VB.TextBox Text1 
      Height          =   270
      Left            =   1800
      TabIndex        =   3
      Text            =   "Text1"
      Top             =   120
      Width           =   855
   End
   Begin VB.CommandButton cmdok 
      Caption         =   "确定"
      Height          =   375
      Left            =   4680
      TabIndex        =   1
      Top             =   360
      Width           =   1335
   End
   Begin VB.CommandButton cmdcancel 
      Caption         =   "取消"
      Height          =   375
      Left            =   4680
      TabIndex        =   0
      Top             =   960
      Width           =   1335
   End
   Begin VB.Label Label8 
      Caption         =   "Label8"
      Height          =   255
      Left            =   120
      TabIndex        =   26
      Top             =   2880
      Width           =   2295
   End
   Begin VB.Label Label7 
      Caption         =   "Label7"
      Height          =   255
      Left            =   120
      TabIndex        =   25
      Top             =   2400
      Width           =   2175
   End
   Begin VB.Label Label6 
      Caption         =   "Label6"
      Height          =   255
      Left            =   120
      TabIndex        =   24
      Top             =   1920
      Width           =   2055
   End
   Begin VB.Label Label11 
      Caption         =   "Label11"
      Height          =   255
      Left            =   120
      TabIndex        =   19
      Top             =   4080
      Width           =   1575
   End
   Begin VB.Label Label10 
      Caption         =   "Label10"
      Height          =   255
      Left            =   120
      TabIndex        =   17
      Top             =   3720
      Width           =   1575
   End
   Begin VB.Label Label9 
      Caption         =   "Label9"
      Height          =   255
      Left            =   120
      TabIndex        =   15
      Top             =   3360
      Width           =   1575
   End
   Begin VB.Label Label5 
      Caption         =   "Label5"
      Height          =   255
      Left            =   120
      TabIndex        =   10
      Top             =   1560
      Width           =   1575
   End
   Begin VB.Label Label4 
      Caption         =   "Label4"
      Height          =   255
      Left            =   120
      TabIndex        =   8
      Top             =   1200
      Width           =   1575
   End
   Begin VB.Label Label3 
      Caption         =   "Label3"
      Height          =   255
      Left            =   120
      TabIndex        =   6
      Top             =   840
      Width           =   1575
   End
   Begin VB.Label Label2 
      Caption         =   "Label2"
      Height          =   255
      Left            =   120
      TabIndex        =   4
      Top             =   480
      Width           =   1575
   End
   Begin VB.Label Label1 
      Caption         =   "Label1"
      Height          =   255
      Left            =   120
      TabIndex        =   2
      Top             =   120
      Width           =   1575
   End
End
Attribute VB_Name = "frmD_EventEdit"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Option Explicit



Private Sub cmdcancel_Click()
    Unload Me
End Sub

Private Sub cmdok_Click()
    g_DD.isGo = Text1.Text
    g_DD.id = Text2.Text
   g_DD.EventNum1 = Text3.Text
    g_DD.EventNum2 = Text4.Text
    g_DD.EventNum3 = Text5.Text
    g_DD.Picnum(0) = Text6.Text
    g_DD.Picnum(1) = Text7.Text
    g_DD.Picnum(2) = Text8.Text
    g_DD.PicDelay = Text9.Text
     g_DD.x = Text10.Text
    g_DD.y = Text11.Text
    Unload Me
End Sub

Private Function FindPic() As Long
    Load frmSelectMap
   
    frmSelectMap.txtIDX = "sdx"
    frmSelectMap.txtGRP = "smp"
    frmSelectMap.cmdshow_Click
    frmSelectMap.Show
End Function

Private Sub cmdPic1_Click()
Dim i As Long
    i = FindPic
    If i >= 0 Then
        Text6.Text = i * 2
    End If
End Sub

Private Sub cmdPic2_Click()
Dim i As Long
    i = FindPic
    If i >= 0 Then
        Text7.Text = i * 2
    End If
End Sub


Private Sub cmdPic3_Click()
Dim i As Long
    i = FindPic
    If i >= 0 Then
        Text8.Text = i * 2
    End If
End Sub

Private Sub Form_Load()
    Me.Caption = LoadResStr(10901)
    
    cmdok.Caption = LoadResStr(102)
    cmdcancel.Caption = LoadResStr(103)
    
    Label1.Caption = LoadResStr(10902)
    Label2.Caption = LoadResStr(10903)
    Label3.Caption = LoadResStr(10904)
    Label4.Caption = LoadResStr(10905)
    Label5.Caption = LoadResStr(10906)
    Label6.Caption = LoadResStr(10907)
    Label7.Caption = LoadResStr(10908)
    Label8.Caption = LoadResStr(10909)
    Label9.Caption = LoadResStr(10910)
    Label10.Caption = LoadResStr(10911)
    Label11.Caption = LoadResStr(10912)
    cmdPic1.Caption = LoadResStr(10913)
    CmdPic2.Caption = LoadResStr(10913)
    cmdPic3.Caption = LoadResStr(10913)
    Set_value
    
End Sub

Public Sub Set_value()
    Text1.Text = g_DD.isGo
    Text2.Text = g_DD.id
    Text3.Text = g_DD.EventNum1
    Text4.Text = g_DD.EventNum2
    Text5.Text = g_DD.EventNum3
    Text6.Text = g_DD.Picnum(0)
    Text7.Text = g_DD.Picnum(1)
    Text8.Text = g_DD.Picnum(2)
    Text9.Text = g_DD.PicDelay
    Text10.Text = g_DD.x
    Text11.Text = g_DD.y
End Sub
