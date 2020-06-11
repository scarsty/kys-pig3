VERSION 5.00
Begin VB.Form frm50_0x04 
   Caption         =   "50指令4"
   ClientHeight    =   3750
   ClientLeft      =   60
   ClientTop       =   345
   ClientWidth     =   7260
   BeginProperty Font 
      Name            =   "Times New Roman"
      Size            =   9
      Charset         =   0
      Weight          =   400
      Underline       =   0   'False
      Italic          =   0   'False
      Strikethrough   =   0   'False
   EndProperty
   LinkTopic       =   "Form1"
   ScaleHeight     =   3750
   ScaleWidth      =   7260
   StartUpPosition =   2  '屏幕中心
   Begin VB.TextBox txtNote 
      Appearance      =   0  'Flat
      BackColor       =   &H80000013&
      BorderStyle     =   0  'None
      ForeColor       =   &H00FF0000&
      Height          =   735
      Left            =   240
      Locked          =   -1  'True
      MultiLine       =   -1  'True
      TabIndex        =   8
      Text            =   "frm50_0x04.frx":0000
      Top             =   2640
      Width           =   4215
   End
   Begin VB.ComboBox ComboCondition 
      Height          =   345
      ItemData        =   "frm50_0x04.frx":0065
      Left            =   1080
      List            =   "frm50_0x04.frx":0067
      Style           =   2  'Dropdown List
      TabIndex        =   6
      Top             =   120
      Width           =   4215
   End
   Begin VB.CommandButton cmdcancel 
      Caption         =   "取消"
      Height          =   375
      Left            =   5520
      TabIndex        =   1
      Top             =   1560
      Width           =   1335
   End
   Begin VB.CommandButton cmdok 
      Caption         =   "确定"
      Height          =   375
      Left            =   5520
      TabIndex        =   0
      Top             =   600
      Width           =   1335
   End
   Begin fishedit.userVar userA 
      Height          =   1095
      Left            =   240
      TabIndex        =   4
      Top             =   1080
      Width           =   1815
      _extentx        =   3201
      _extenty        =   1931
   End
   Begin fishedit.userVar userB 
      Height          =   1095
      Left            =   2520
      TabIndex        =   5
      Top             =   1080
      Width           =   1815
      _extentx        =   3201
      _extenty        =   1931
      value           =   1
   End
   Begin VB.Label Label4 
      Caption         =   "判断条件"
      Height          =   255
      Left            =   120
      TabIndex        =   7
      Top             =   120
      Width           =   975
   End
   Begin VB.Label Label5 
      Caption         =   "变量A"
      Height          =   255
      Left            =   240
      TabIndex        =   3
      Top             =   720
      Width           =   495
   End
   Begin VB.Label Label3 
      Caption         =   "B"
      Height          =   375
      Left            =   2640
      TabIndex        =   2
      Top             =   720
      Width           =   1695
   End
End
Attribute VB_Name = "frm50_0x04"
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
 
    kk.Data(2) = ComboCondition.ListIndex
    kk.Data(3) = userA.Text
    kk.Data(4) = userB.Text
    kk.Data(5) = 0
    kk.Data(6) = 0
    kk.Data(1) = userB.Value
    
    Unload Me
    
End Sub

 

Private Sub Form_Load()
Dim num50 As Long
Dim i As Long
Dim s1 As String
    Call ConvertForm(Me)
    
    
    Index = frmmain.listkdef.ListIndex
    Set kk = KdefInfo(frmmain.Combokdef.ListIndex).kdef.Item(Index + 1)
    
    Call Set50Form(Me, kk.Data(0))
    
    userA.Text = kk.Data(3)
    userB.Text = kk.Data(4)
 
    ComboCondition.Clear
    ComboCondition.AddItem StrUnicode2("0: A < B 跳转变量JMP设为0，否则设为1")
    ComboCondition.AddItem StrUnicode2("1: A <= B 跳转变量JMP设为0，否则设为1")
    ComboCondition.AddItem StrUnicode2("2: A = B 跳转变量JMP设为0，否则设为1")
    ComboCondition.AddItem StrUnicode2("3: A <> B 跳转变量JMP设为0，否则设为1")
    ComboCondition.AddItem StrUnicode2("4: A >= B 跳转变量JMP设为0，否则设为1")
    ComboCondition.AddItem StrUnicode2("5: A > B 跳转变量JMP设为 0，否则设为1")
    ComboCondition.AddItem StrUnicode2("6: 不管A、B的值，跳转变量JMP设为 0")
    ComboCondition.AddItem StrUnicode2("7: 不管A、B的值，跳转变量JMP设为 1")
    
    ComboCondition.ListIndex = kk.Data(2)
    
    userB.Value = IIf((kk.Data(1) And &H1) > 0, 1, 0)
    


    userA.Showtype = False
    userA.SetCombo
    userB.SetCombo

End Sub

 
