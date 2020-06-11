VERSION 5.00
Begin VB.Form frmStatement_0x01 
   Caption         =   "对话修改"
   ClientHeight    =   5250
   ClientLeft      =   60
   ClientTop       =   345
   ClientWidth     =   9900
   LinkTopic       =   "Form2"
   ScaleHeight     =   5250
   ScaleWidth      =   9900
   StartUpPosition =   2  '屏幕中心
   Begin VB.CommandButton CmdModifyTalk 
      Caption         =   "重排星号"
      Height          =   375
      Left            =   4560
      TabIndex        =   16
      Top             =   3600
      Width           =   1455
   End
   Begin VB.Timer Timer1 
      Enabled         =   0   'False
      Interval        =   100
      Left            =   1440
      Top             =   840
   End
   Begin VB.OptionButton Option2 
      Caption         =   "保存到新的对话"
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
      Left            =   2160
      TabIndex        =   15
      Top             =   3600
      Width           =   2175
   End
   Begin VB.OptionButton Option1 
      Caption         =   "保存到原有对话"
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
      TabIndex        =   14
      Top             =   3600
      Value           =   -1  'True
      Width           =   1815
   End
   Begin VB.CommandButton Comcancel 
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
      Left            =   8400
      TabIndex        =   13
      Top             =   4680
      Width           =   1335
   End
   Begin VB.CommandButton Comok 
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
      Left            =   8400
      TabIndex        =   12
      Top             =   3840
      Width           =   1335
   End
   Begin VB.ComboBox ComboShow 
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
      ItemData        =   "frmStatement_0x01.frx":0000
      Left            =   1680
      List            =   "frmStatement_0x01.frx":0002
      Style           =   2  'Dropdown List
      TabIndex        =   11
      Top             =   4200
      Width           =   4815
   End
   Begin VB.TextBox txttalk 
      BeginProperty Font 
         Name            =   "Times New Roman"
         Size            =   9
         Charset         =   0
         Weight          =   400
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Height          =   735
      Left            =   240
      MultiLine       =   -1  'True
      ScrollBars      =   3  'Both
      TabIndex        =   8
      Text            =   "frmStatement_0x01.frx":0004
      Top             =   2640
      Width           =   9615
   End
   Begin VB.PictureBox pic1 
      AutoRedraw      =   -1  'True
      BeginProperty Font 
         Name            =   "Times New Roman"
         Size            =   9
         Charset         =   0
         Weight          =   400
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Height          =   1455
      Left            =   2640
      ScaleHeight     =   93
      ScaleMode       =   3  'Pixel
      ScaleWidth      =   85
      TabIndex        =   6
      Top             =   600
      Width           =   1335
   End
   Begin VB.ListBox Listperson 
      BeginProperty Font 
         Name            =   "Times New Roman"
         Size            =   9
         Charset         =   0
         Weight          =   400
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Height          =   2085
      Left            =   7200
      TabIndex        =   4
      Top             =   120
      Width           =   1695
   End
   Begin VB.ComboBox Combotalkman 
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
      ItemData        =   "frmStatement_0x01.frx":000A
      Left            =   3960
      List            =   "frmStatement_0x01.frx":000C
      Style           =   2  'Dropdown List
      TabIndex        =   3
      Top             =   240
      Width           =   1695
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
      Left            =   1080
      TabIndex        =   1
      Text            =   "Text1"
      Top             =   240
      Width           =   855
   End
   Begin VB.Label Label5 
      Caption         =   "对话显示方式"
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
      TabIndex        =   10
      Top             =   4200
      Width           =   1095
   End
   Begin VB.Label lbltalknum 
      Caption         =   "按游戏格式必须每隔12个汉字加一个 星号""*"""
      BeginProperty Font 
         Name            =   "Times New Roman"
         Size            =   9
         Charset         =   0
         Weight          =   400
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      ForeColor       =   &H00FF0000&
      Height          =   255
      Left            =   1680
      TabIndex        =   9
      Top             =   2280
      Width           =   3735
   End
   Begin VB.Label Label4 
      Caption         =   "对话内容"
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
      TabIndex        =   7
      Top             =   2280
      Width           =   1215
   End
   Begin VB.Label Label3 
      Caption         =   "说话人"
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
      Left            =   6000
      TabIndex        =   5
      Top             =   240
      Width           =   1575
   End
   Begin VB.Label Label2 
      Caption         =   "说话人头像"
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
      Left            =   2760
      TabIndex        =   2
      Top             =   240
      Width           =   1215
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
      TabIndex        =   0
      Top             =   240
      Width           =   855
   End
End
Attribute VB_Name = "frmStatement_0x01"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Option Explicit

Dim index As Long
Dim kk As Statement



Private Sub CmdModifyTalk_Click()
Dim tmpstr As String
Dim NewStr As String
Dim NewSubStr As String
Dim tmp() As String
Dim i As Long
Dim Width As Long
    tmpstr = txttalk.Text
    tmp = Split(tmpstr, "*")
    tmpstr = ""
    For i = 0 To UBound(tmp)
        tmpstr = tmpstr & tmp(i)
    Next i
    NewStr = ""
    While Len(tmpstr) > 0
        NewSubStr = ""
        Width = 0
        Do
            If Len(tmpstr) = 0 Then
                Exit Do
            End If
            NewSubStr = NewSubStr & Left(tmpstr, 1)
            If Abs(Asc(Left(tmpstr, 1))) < 128 Then
                Width = Width + 1
            Else
                Width = Width + 2
            End If
            tmpstr = Mid(tmpstr, 2)
            
            If Width >= 23 Then
                Exit Do
            End If
        Loop
        
        If Len(tmpstr) > 0 Then
            If Width = 23 Then
                If Abs(Asc((Left(tmpstr, 1)))) < 128 Then
                    NewSubStr = NewSubStr & Left(tmpstr, 1)
                    tmpstr = Mid(tmpstr, 2)
                End If
            End If
        End If
        If Len(tmpstr) > 0 Then
            NewStr = NewStr & NewSubStr & "*"
        Else
            NewStr = NewStr & NewSubStr
        End If
    Wend
    txttalk.Text = NewStr
End Sub

Private Sub Combotalkman_click()
Dim i As Long
    If Combotalkman.ListIndex < 0 Then Exit Sub
    pic1.Cls
    Call ShowPicDIB(HeadPic(Combotalkman.ListIndex), pic1.hdc, 0, pic1.ScaleHeight)
    pic1.Refresh
    Listperson.Clear
    
    For i = 1 To HeadtoPerson(Combotalkman.ListIndex).Count
        Listperson.AddItem HeadtoPerson(Combotalkman.ListIndex).Item(i) & Person(HeadtoPerson(Combotalkman.ListIndex).Item(i)).Name1
    Next i
End Sub

Private Sub Combotalkman_GotFocus()
    Timer1.Enabled = True
End Sub

Private Sub Combotalkman_LostFocus()
    Timer1.Enabled = False
End Sub

Private Sub Combotalkman_Scroll()
    Combotalkman_click
End Sub

Private Sub Comcancel_Click()
    Unload Me
End Sub

Private Sub Comok_Click()
    kk.data(1) = Combotalkman.ListIndex
    kk.data(2) = ComboShow.ListIndex
    If Option1.value = True Then
        talk(kk.data(0)) = txttalk.Text
    Else
        numtalk = numtalk + 1
        ReDim Preserve talk(numtalk - 1)
        ReDim Preserve TalkIdx(numtalk)
        kk.data(0) = numtalk - 1
        talk(kk.data(0)) = txttalk.Text
    End If
    
    Unload Me
End Sub

Private Sub Form_Load()
Dim i As Long
    Combotalkman.Clear
    For i = 0 To Headnum - 1
        Combotalkman.AddItem i
    Next i
    ComboShow.Clear
    ComboShow.AddItem LoadResStr(1109)
    ComboShow.AddItem LoadResStr(1110)
    ComboShow.AddItem LoadResStr(1111)
    ComboShow.AddItem LoadResStr(1112)
    ComboShow.AddItem LoadResStr(1113)
    ComboShow.AddItem LoadResStr(1114)
    

    
    
    
    index = frmmain.listkdef.ListIndex
    Set kk = KdefInfo(frmmain.Combokdef.ListIndex).kdef.Item(index + 1)
    txtid.Text = kk.id & "(" & Hex(kk.id) & ")"
    txttalk.Text = talk(kk.data(0))
    Combotalkman.ListIndex = kk.data(1)
    ComboShow.ListIndex = kk.data(2)
    
    
    Me.Caption = LoadResStr(1101)
    Label1.Caption = LoadResStr(1102)
    Label2.Caption = LoadResStr(1103)
    Label3.Caption = LoadResStr(1104)
    Label4.Caption = LoadResStr(1105)
    lbltalknum.Caption = LoadResStr(305)
    Label5.Caption = LoadResStr(1106)
    Option1.Caption = LoadResStr(1107)
    Option2.Caption = LoadResStr(1108)
    Comok.Caption = LoadResStr(102)
    Comcancel.Caption = LoadResStr(103)
    CmdModifyTalk.Caption = LoadResStr(1115)
   
End Sub




Private Sub Timer1_Timer()
    Combotalkman_click
End Sub
