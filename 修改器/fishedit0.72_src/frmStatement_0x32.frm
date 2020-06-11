VERSION 5.00
Begin VB.Form frmStatement_0x32 
   Caption         =   "新增50指令"
   ClientHeight    =   2235
   ClientLeft      =   60
   ClientTop       =   345
   ClientWidth     =   8145
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
   ScaleHeight     =   2235
   ScaleWidth      =   8145
   StartUpPosition =   2  '屏幕中心
   Begin VB.ComboBox ComboNew50 
      Height          =   345
      Left            =   1320
      Style           =   2  'Dropdown List
      TabIndex        =   4
      Top             =   840
      Width           =   3375
   End
   Begin VB.TextBox txtid 
      Enabled         =   0   'False
      Height          =   285
      Left            =   1080
      TabIndex        =   2
      Text            =   "Text1"
      Top             =   240
      Width           =   855
   End
   Begin VB.CommandButton cmdok 
      Caption         =   "确定"
      Height          =   375
      Left            =   6360
      TabIndex        =   1
      Top             =   360
      Width           =   1335
   End
   Begin VB.CommandButton cmdcancel 
      Caption         =   "取消"
      Height          =   375
      Left            =   6360
      TabIndex        =   0
      Top             =   1320
      Width           =   1335
   End
   Begin VB.Label Label2 
      Caption         =   "注意：更改新指令ID后所有参数自动清零"
      ForeColor       =   &H00FF0000&
      Height          =   375
      Left            =   240
      TabIndex        =   6
      Top             =   1560
      Width           =   5295
   End
   Begin VB.Label Label3 
      Caption         =   "新指令ID"
      Height          =   375
      Left            =   240
      TabIndex        =   5
      Top             =   840
      Width           =   975
   End
   Begin VB.Label Label1 
      Caption         =   "指令id"
      Height          =   375
      Left            =   240
      TabIndex        =   3
      Top             =   240
      Width           =   855
   End
End
Attribute VB_Name = "frmStatement_0x32"
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
Dim s1 As String
Dim i As Long
    If kk.Data(0) <> ComboNew50.ListIndex Then
        For i = 1 To 6
            kk.Data(i) = 0
        Next i
    End If
    kk.Data(0) = ComboNew50.ListIndex
    Select Case kk.Data(0)
        Case 0
            frm50_0x00.Show vbModal
        Case 1
            frm50_0x01.Show vbModal
        Case 2
            frm50_0x02.Show vbModal
        Case 3
            frm50_0x03.Show vbModal
        Case 4
            frm50_0x04.Show vbModal
        Case 6
            frm50_0x06.Show vbModal
        Case 8
            frm50_0x08.Show vbModal
        Case 9
            frm50_0x09.Show vbModal
        Case 10
            frm50_0x10.Show vbModal
        Case 11
            frm50_0x11.Show vbModal
        Case 12
            frm50_0x12.Show vbModal
        Case 16
            frm50_0x16.Show vbModal
        Case 17
             frm50_0x17.Show vbModal
        Case 18
             frm50_0x18.Show vbModal
        Case 19
             frm50_0x19.Show vbModal
        Case 20
             frm50_0x20.Show vbModal
        Case 21
             frm50_0x21.Show vbModal
        Case 22
             frm50_0x22.Show vbModal
        Case 23
             frm50_0x23.Show vbModal
        Case 24
             frm50_0x24.Show vbModal
        Case 25
             frm50_0x25.Show vbModal
        Case 26
             frm50_0x26.Show vbModal
        Case 27
             frm50_0x27.Show vbModal
        'sub28=取当前人物战斗序号
        Case 28
             frm50_0x28.Show vbModal
        'sub29=选择攻击目标
        Case 29
             frm50_0x29.Show vbModal
        'sub30=读取人物战斗属性
        Case 30
             frm50_0x30.Show vbModal
        '写入人物战斗属性
        Case 31
             frm50_0x31.Show vbModal
        Case 32
             frm50_0x32.Show vbModal
        Case 33
             frm50_0x33.Show vbModal
        Case 34
             frm50_0x34.Show vbModal
        Case 35
             frm50_0x35.Show vbModal
        Case 36
            Load frm50_0x33
            Call Set50Form(frm50_0x33, frm50_0x33.kk.Data(0))
            frm50_0x33.Show vbModal
        Case 37
             frm50_0x37.Show vbModal
        Case 38
             frm50_0x38.Show vbModal
        Case 39
             frm50_0x39.Show vbModal
        Case 40
             frm50_0x40.Show vbModal
        Case 41
             frm50_0x41.Show vbModal
        Case 42
             frm50_0x42.Show vbModal
        Case 43
             frm50_0x43.Show vbModal
        '44 指令：播放效果
         Case 44
             frm50_0x44.Show vbModal
        '45 指令：显示数字
         Case 45
             frm50_0x45.Show vbModal
        '46 指令：设定效果层
        Case 46
             frm50_0x46.Show vbModal
        '47重置战场贴图
        Case 47
             frm50_0x47.Show vbModal
        
        '49 指令：调用任意子程
        Case 49
             frm50_0x49.Show vbModal
        Case Else
        
    End Select
    
    Unload Me
End Sub

Private Sub Form_Load()
Dim num50 As Long
Dim i As Long
Dim s1 As String
    Call ConvertForm(Me)
    Index = frmmain.listkdef.ListIndex
    Set kk = KdefInfo(frmmain.Combokdef.ListIndex).kdef.Item(Index + 1)
    txtid.Text = kk.id & "(" & Hex(kk.id) & ")"
    
    num50 = GetINILong("kdef50", "num")
    
    ComboNew50.Clear
    For i = 0 To num50 - 1
        s1 = GetINIStr("Kdef50", "sub" & i)
        If s1 = "" Then
            s1 = GetINIStr("Kdef50", "Other")
        End If
        ComboNew50.AddItem i & "(" & Hex(i) & "):" & s1
    Next i
    
    ComboNew50.ListIndex = kk.Data(0)
    
End Sub

