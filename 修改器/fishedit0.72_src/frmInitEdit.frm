VERSION 5.00
Begin VB.Form frmInitEdit 
   Caption         =   "初始属性修改"
   ClientHeight    =   3555
   ClientLeft      =   60
   ClientTop       =   345
   ClientWidth     =   9345
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
   MDIChild        =   -1  'True
   ScaleHeight     =   3555
   ScaleWidth      =   9345
   WindowState     =   2  'Maximized
   Begin VB.Frame FrameInit 
      Caption         =   "Frame2"
      Height          =   1455
      Left            =   120
      TabIndex        =   12
      Top             =   120
      Width           =   6975
      Begin VB.ComboBox ComboInit 
         Height          =   345
         Left            =   120
         Style           =   2  'Dropdown List
         TabIndex        =   16
         Top             =   720
         Width           =   1935
      End
      Begin VB.TextBox txtbase 
         Height          =   330
         Left            =   2280
         TabIndex        =   15
         Text            =   "Text1"
         Top             =   720
         Width           =   975
      End
      Begin VB.TextBox txtRND 
         Height          =   330
         Left            =   3480
         TabIndex        =   14
         Text            =   "Text2"
         Top             =   720
         Width           =   855
      End
      Begin VB.TextBox txtQQ 
         Height          =   330
         Left            =   5400
         TabIndex        =   13
         Text            =   "Text3"
         Top             =   720
         Width           =   855
      End
      Begin VB.Label Label1 
         Caption         =   "基础值"
         Height          =   255
         Left            =   2280
         TabIndex        =   19
         Top             =   240
         Width           =   975
      End
      Begin VB.Label Label2 
         Caption         =   "随机范围"
         Height          =   495
         Left            =   3480
         TabIndex        =   18
         Top             =   240
         Width           =   1695
      End
      Begin VB.Label Label3 
         Caption         =   "秘笈值"
         Height          =   255
         Left            =   5400
         TabIndex        =   17
         Top             =   240
         Width           =   975
      End
   End
   Begin VB.Frame FrameShow 
      Caption         =   "Frame1"
      Height          =   1695
      Left            =   120
      TabIndex        =   3
      Top             =   1680
      Width           =   6975
      Begin VB.ComboBox ComboShownum 
         Height          =   345
         Left            =   240
         Style           =   2  'Dropdown List
         TabIndex        =   7
         Top             =   840
         Width           =   975
      End
      Begin VB.ComboBox ComboShowVar 
         Height          =   345
         Left            =   1440
         TabIndex        =   6
         Text            =   "Combo1"
         Top             =   840
         Width           =   1935
      End
      Begin VB.TextBox txtFormat 
         Height          =   330
         Left            =   3600
         TabIndex        =   5
         Text            =   "Text1"
         Top             =   840
         Width           =   1455
      End
      Begin VB.TextBox txtVarMax 
         Height          =   330
         Left            =   5280
         TabIndex        =   4
         Text            =   "Text1"
         Top             =   840
         Width           =   855
      End
      Begin VB.Label Label4 
         Caption         =   "最大值"
         Height          =   255
         Left            =   5280
         TabIndex        =   11
         Top             =   480
         Width           =   975
      End
      Begin VB.Label Label5 
         Caption         =   "显示字串"
         Height          =   255
         Left            =   3600
         TabIndex        =   10
         Top             =   480
         Width           =   1335
      End
      Begin VB.Label Label6 
         Caption         =   "显示变量"
         Height          =   255
         Left            =   1440
         TabIndex        =   9
         Top             =   480
         Width           =   1455
      End
      Begin VB.Label Label7 
         Caption         =   "显示顺序"
         Height          =   255
         Left            =   360
         TabIndex        =   8
         Top             =   480
         Width           =   855
      End
   End
   Begin VB.CommandButton CmdModify 
      Caption         =   "Modify"
      Height          =   375
      Left            =   7920
      TabIndex        =   2
      Top             =   1800
      Width           =   1335
   End
   Begin VB.CommandButton cmdcancel 
      Caption         =   "取消"
      Height          =   375
      Left            =   7920
      TabIndex        =   1
      Top             =   1080
      Width           =   1335
   End
   Begin VB.CommandButton cmdok 
      Caption         =   "确定"
      Height          =   375
      Left            =   7920
      TabIndex        =   0
      Top             =   360
      Width           =   1335
   End
End
Attribute VB_Name = "frmInitEdit"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Option Explicit


Private zfilenum As Long
Private zfilename As String

Private Initnum As Long

Private Type InitType
    BaseAddr As Long
    Basedata As Long
    RndAddr As Long
    Rnddata As Byte
    MaxAddr As Long
    MaxData As Byte
    QQAddr As Long
    QQdata As Integer
    Name As String
    VarAddr As Long
End Type

Private InitData() As InitType


Private Shownum As Long

Private Type ShowType
    AddrVar1 As Long
    AddrVar2 As Long
    Var As Long
    AddrStr As Long
    StrByte(8) As Byte
    Str As String
    AddrMax As Long
    MaxData As Byte
End Type

Private ShowData() As ShowType

Private Sub cmdcancel_Click()
    Unload Me
End Sub

Private Sub CmdModify_Click()
    Modify_it
End Sub

Private Sub cmdok_Click()

Dim i As Long
Dim tmpstr As String
Dim tmpstr2 As String
Dim tmpbyte() As Byte
    If MsgBox(LoadResStr(10131), vbYesNo) = vbNo Then Exit Sub
    zfilenum = OpenBin(G_Var.JYPath & G_Var.EXE, "W")
    
    For i = 0 To Initnum - 1
        If InitData(i).BaseAddr >= 0 Then
            Put #zfilenum, InitData(i).BaseAddr + 1, InitData(i).Basedata
        End If
        If InitData(i).RndAddr >= 0 Then
            Put #zfilenum, InitData(i).RndAddr + 1, InitData(i).Rnddata
        End If
        If InitData(i).QQAddr >= 0 Then
            Put #zfilenum, InitData(i).QQAddr + 1, InitData(i).QQdata
        End If
    Next i
        
    For i = 0 To Shownum - 1
        Put #zfilenum, ShowData(i).AddrVar1 + 1, ShowData(i).Var
        Put #zfilenum, ShowData(i).AddrVar2 + 1, ShowData(i).Var
        Call UnicodetoBIG5(ShowData(i).Str, 9, tmpbyte)
        Put #zfilenum, ShowData(i).AddrStr + 1, tmpbyte
        Put #zfilenum, , CByte(0)
        Put #zfilenum, ShowData(i).AddrMax + 1, ShowData(i).MaxData
    Next i
        
    Close (zfilenum)

End Sub


Private Sub ComboInit_click()
Dim Index As Long
    Index = ComboInit.ListIndex
    If Index < 0 Then Exit Sub
    txtbase.Text = InitData(Index).Basedata
    txtRND.Text = InitData(Index).Rnddata
    'txtMax.Text = InitData(index).MaxData
    txtQQ.Text = InitData(Index).QQdata
End Sub

Private Sub ComboShownum_click()
Dim Index As Long
Dim i As Long
    Index = ComboShownum.ListIndex
    If Index < 0 Then Exit Sub
    For i = 0 To Initnum - 1
        If ShowData(Index).Var = InitData(i).VarAddr Then
            ComboShowVar.ListIndex = i
            Exit For
        End If
    Next i
    txtFormat = ShowData(Index).Str
    txtVarMax.Text = ShowData(Index).MaxData
End Sub


Private Sub Form_Load()

    Me.Caption = LoadResStr(218)
    
    cmdok.Caption = LoadResStr(102)
    cmdcancel.Caption = LoadResStr(103)
    
    Label1.Caption = LoadResStr(10301)
    Label2.Caption = LoadResStr(10302)
    Label3.Caption = LoadResStr(10303)
    Label4.Caption = LoadResStr(10304)
    Label5.Caption = LoadResStr(10307)
    Label6.Caption = LoadResStr(10306)
    Label7.Caption = LoadResStr(10305)
    
    CmdModify.Caption = LoadResStr(10308)
    
    FrameInit.Caption = LoadResStr(10309)
    FrameShow.Caption = LoadResStr(10310)
    

    Load_init
    
End Sub

Private Sub Load_init()
Dim i As Long
Dim tmpstr() As String
Dim tmplong As Long
Dim fixupOffset As Long
    Initnum = GetINILong("InitProperty", "initnum")
    ReDim InitData(Initnum - 1)
    For i = 0 To Initnum - 1
        tmpstr = Split(GetINIStr("InitProperty", "Addr" & i), ",")
        InitData(i).BaseAddr = tmpstr(0)
        InitData(i).RndAddr = tmpstr(1)
        InitData(i).MaxAddr = tmpstr(2)
        InitData(i).QQAddr = tmpstr(3)
        InitData(i).VarAddr = tmpstr(4)
        InitData(i).Name = tmpstr(5)
    Next i

    'zfilename = G_Var.JYPath & "\z.dat"
    
    zfilenum = OpenBin(G_Var.JYPath & G_Var.EXE, "R")
    For i = 0 To Initnum - 1
        If InitData(i).BaseAddr >= 0 Then
            Get #zfilenum, InitData(i).BaseAddr + 1, InitData(i).Basedata
        End If
        If InitData(i).RndAddr >= 0 Then
            Get #zfilenum, InitData(i).RndAddr + 1, InitData(i).Rnddata
        End If
        If InitData(i).MaxAddr >= 0 Then
            Get #zfilenum, InitData(i).MaxAddr + 1, InitData(i).MaxData
        End If
        If InitData(i).QQAddr >= 0 Then
            Get #zfilenum, InitData(i).QQAddr + 1, InitData(i).QQdata
        End If
        
    Next i
    ComboInit.Clear
    For i = 0 To Initnum - 1
        ComboInit.AddItem InitData(i).Name
    Next i

    ComboInit.ListIndex = 0
    
    fixupOffset = 8 * GetINILong("newZ", "PageAdd")

    Shownum = GetINILong("InitProperty", "initShownum")
    ReDim ShowData(Shownum - 1)
    For i = 0 To Shownum - 1
        tmpstr = Split(GetINIStr("InitProperty", "InitShow" & i), ",")
        ShowData(i).AddrVar1 = tmpstr(0) + fixupOffset
        ShowData(i).AddrVar2 = tmpstr(1) + fixupOffset
        ShowData(i).AddrStr = tmpstr(2)
        ShowData(i).AddrMax = tmpstr(3)
    Next i
    
    For i = 0 To Shownum - 1
        Get #zfilenum, ShowData(i).AddrVar1 + 1, ShowData(i).Var
        Get #zfilenum, ShowData(i).AddrVar2 + 1, tmplong
        If tmplong <> ShowData(i).Var Then
            MsgBox "Ini show data error:var1<>var2 num=" & i
        End If
        Get #zfilenum, ShowData(i).AddrStr + 1, ShowData(i).StrByte
        ShowData(i).Str = Big5toUnicode(ShowData(i).StrByte, 9)
        Get #zfilenum, ShowData(i).AddrMax + 1, ShowData(i).MaxData
    Next i
    
    Close #zfilenum

    ComboShownum.Clear
    For i = 0 To Shownum - 1
       ComboShownum.AddItem i
    Next i
    
    ComboShowVar.Clear
    For i = 0 To Initnum - 1
        ComboShowVar.AddItem InitData(i).Name
    Next i
    
    ComboShownum.ListIndex = 0

End Sub



Private Sub Modify_it()
Dim Index As Long
    Index = ComboInit.ListIndex
    If Index > -1 Then
        InitData(Index).Basedata = txtbase.Text
        InitData(Index).Rnddata = txtRND.Text
        InitData(Index).QQdata = txtQQ.Text
    End If
    Index = ComboShownum.ListIndex
    If Index >= -1 Then
        ShowData(Index).Var = InitData(ComboShowVar.ListIndex).VarAddr
        ShowData(Index).Str = txtFormat.Text
        ShowData(Index).MaxData = txtVarMax.Text
    End If
End Sub

