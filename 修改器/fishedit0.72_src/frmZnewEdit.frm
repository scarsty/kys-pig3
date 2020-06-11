VERSION 5.00
Begin VB.Form frmznewedit 
   Caption         =   "修改Z.dat"
   ClientHeight    =   7755
   ClientLeft      =   60
   ClientTop       =   345
   ClientWidth     =   10050
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
   ScaleHeight     =   7755
   ScaleWidth      =   10050
   WindowState     =   2  'Maximized
   Begin VB.CommandButton cmdCustom 
      Caption         =   "自定义修改z.dat"
      Height          =   375
      Left            =   6120
      TabIndex        =   98
      Top             =   120
      Width           =   1815
   End
   Begin VB.CheckBox chkFlash 
      Caption         =   "闪烁效果"
      Height          =   495
      Left            =   2400
      TabIndex        =   97
      Top             =   6960
      Width           =   1455
   End
   Begin VB.CheckBox chkVediomode 
      Caption         =   "显示模式640*480"
      Height          =   255
      Left            =   120
      TabIndex        =   96
      Top             =   7080
      Width           =   2175
   End
   Begin VB.TextBox txtmmappicNum 
      Height          =   285
      Left            =   2160
      TabIndex        =   94
      Text            =   "Text1"
      Top             =   6600
      Width           =   1215
   End
   Begin VB.CommandButton cmdAuto 
      Caption         =   "按进度一设置"
      Height          =   375
      Left            =   7920
      TabIndex        =   93
      Top             =   6240
      Width           =   1695
   End
   Begin VB.TextBox txtScenenum 
      Height          =   285
      Left            =   1320
      TabIndex        =   89
      Top             =   6240
      Width           =   1215
   End
   Begin VB.TextBox txtSFilelength 
      Height          =   285
      Left            =   3960
      TabIndex        =   88
      Top             =   6240
      Width           =   1215
   End
   Begin VB.TextBox txtDFilelength 
      Height          =   285
      Left            =   6600
      TabIndex        =   87
      Top             =   6240
      Width           =   1215
   End
   Begin VB.TextBox txtWupinPicAddr 
      Height          =   285
      Left            =   5520
      TabIndex        =   86
      Text            =   "Text1"
      Top             =   5880
      Width           =   1215
   End
   Begin VB.TextBox txtLifescale 
      Height          =   285
      Left            =   2160
      TabIndex        =   84
      Text            =   "Text1"
      Top             =   5880
      Width           =   1215
   End
   Begin VB.TextBox txtShuxing 
      Height          =   285
      Index           =   14
      Left            =   3120
      TabIndex        =   82
      Top             =   5400
      Width           =   735
   End
   Begin VB.TextBox txtShuxing 
      Height          =   285
      Index           =   13
      Left            =   1200
      TabIndex        =   80
      Top             =   5400
      Width           =   735
   End
   Begin VB.TextBox txtShuxing 
      Height          =   285
      Index           =   12
      Left            =   9000
      TabIndex        =   78
      Top             =   5040
      Width           =   735
   End
   Begin VB.TextBox txtShuxing 
      Height          =   285
      Index           =   11
      Left            =   6960
      TabIndex        =   76
      Top             =   5040
      Width           =   735
   End
   Begin VB.TextBox txtShuxing 
      Height          =   285
      Index           =   10
      Left            =   5040
      TabIndex        =   74
      Top             =   5040
      Width           =   735
   End
   Begin VB.TextBox txtShuxing 
      Height          =   285
      Index           =   9
      Left            =   3120
      TabIndex        =   72
      Top             =   5040
      Width           =   735
   End
   Begin VB.TextBox txtShuxing 
      Height          =   285
      Index           =   8
      Left            =   1200
      TabIndex        =   70
      Top             =   5040
      Width           =   735
   End
   Begin VB.TextBox txtShuxing 
      Height          =   285
      Index           =   7
      Left            =   9000
      TabIndex        =   68
      Top             =   4680
      Width           =   735
   End
   Begin VB.TextBox txtShuxing 
      Height          =   285
      Index           =   6
      Left            =   6960
      TabIndex        =   66
      Top             =   4680
      Width           =   735
   End
   Begin VB.TextBox txtShuxing 
      Height          =   285
      Index           =   5
      Left            =   5040
      TabIndex        =   64
      Top             =   4680
      Width           =   735
   End
   Begin VB.TextBox txtShuxing 
      Height          =   285
      Index           =   4
      Left            =   3120
      TabIndex        =   62
      Top             =   4680
      Width           =   735
   End
   Begin VB.TextBox txtShuxing 
      Height          =   285
      Index           =   3
      Left            =   1200
      TabIndex        =   60
      Top             =   4680
      Width           =   735
   End
   Begin VB.TextBox txtShuxing 
      Height          =   285
      Index           =   2
      Left            =   9000
      TabIndex        =   58
      Top             =   4320
      Width           =   735
   End
   Begin VB.TextBox txtShuxing 
      Height          =   285
      Index           =   1
      Left            =   6960
      TabIndex        =   56
      Top             =   4320
      Width           =   735
   End
   Begin VB.TextBox txtShuxing 
      Height          =   285
      Index           =   0
      Left            =   5040
      TabIndex        =   53
      Top             =   4320
      Width           =   735
   End
   Begin VB.TextBox txtlifemax 
      Height          =   285
      Left            =   1200
      TabIndex        =   50
      Top             =   4320
      Width           =   735
   End
   Begin VB.TextBox txtneilimax 
      Height          =   285
      Left            =   3120
      TabIndex        =   49
      Top             =   4320
      Width           =   735
   End
   Begin VB.TextBox txtMaxLevel 
      Height          =   285
      Left            =   6480
      TabIndex        =   48
      Text            =   "0"
      Top             =   3840
      Width           =   855
   End
   Begin VB.HScrollBar HScrollLevel 
      Height          =   255
      Left            =   2160
      TabIndex        =   44
      Top             =   3840
      Width           =   1575
   End
   Begin VB.TextBox txtLevel 
      Height          =   285
      Left            =   4560
      TabIndex        =   43
      Text            =   "0"
      Top             =   3840
      Width           =   855
   End
   Begin VB.TextBox txtEft 
      Height          =   285
      Left            =   4560
      TabIndex        =   40
      Text            =   "0"
      Top             =   3480
      Width           =   855
   End
   Begin VB.HScrollBar HScrollEft 
      Height          =   255
      Left            =   2160
      TabIndex        =   39
      Top             =   3480
      Width           =   1575
   End
   Begin VB.HScrollBar HScrollFit 
      Height          =   255
      Left            =   1920
      TabIndex        =   35
      Top             =   3120
      Width           =   1575
   End
   Begin VB.ComboBox ComboThing 
      Height          =   345
      Left            =   4080
      Style           =   2  'Dropdown List
      TabIndex        =   34
      Top             =   3120
      Width           =   1695
   End
   Begin VB.ComboBox ComboWugong 
      Height          =   345
      Left            =   5880
      Style           =   2  'Dropdown List
      TabIndex        =   33
      Top             =   3120
      Width           =   1575
   End
   Begin VB.TextBox txtFit 
      Height          =   330
      Left            =   8520
      TabIndex        =   32
      Text            =   "0"
      Top             =   3120
      Width           =   855
   End
   Begin VB.HScrollBar HScrollPerson 
      Height          =   255
      Left            =   1920
      TabIndex        =   28
      Top             =   2760
      Width           =   1575
   End
   Begin VB.ComboBox Comboperson 
      Height          =   345
      Left            =   4080
      Style           =   2  'Dropdown List
      TabIndex        =   27
      Top             =   2760
      Width           =   1695
   End
   Begin VB.TextBox txtliduishijian 
      Height          =   330
      Left            =   7560
      TabIndex        =   26
      Text            =   "0"
      Top             =   2760
      Width           =   615
   End
   Begin VB.HScrollBar HScrollLight 
      Height          =   255
      Left            =   1920
      TabIndex        =   23
      Top             =   2400
      Width           =   1575
   End
   Begin VB.ComboBox ComboLight 
      Height          =   345
      Left            =   4080
      Style           =   2  'Dropdown List
      TabIndex        =   22
      Top             =   2400
      Width           =   1695
   End
   Begin VB.TextBox txtXMI 
      Height          =   285
      Left            =   6000
      TabIndex        =   21
      Text            =   "Text1"
      Top             =   1920
      Width           =   1695
   End
   Begin VB.TextBox txtEEE 
      Height          =   285
      Left            =   3960
      TabIndex        =   20
      Text            =   "Text1"
      Top             =   1920
      Width           =   1695
   End
   Begin VB.TextBox txtAtk 
      Height          =   285
      Left            =   1920
      TabIndex        =   19
      Text            =   "Text1"
      Top             =   1920
      Width           =   1695
   End
   Begin VB.TextBox txtfightgrp 
      Height          =   285
      Left            =   3960
      TabIndex        =   16
      Text            =   "Text1"
      Top             =   1560
      Width           =   1695
   End
   Begin VB.TextBox txtfightidx 
      Height          =   285
      Left            =   1920
      TabIndex        =   15
      Text            =   "Text1"
      Top             =   1560
      Width           =   1695
   End
   Begin VB.TextBox txtWDXfilename 
      Height          =   285
      Left            =   1920
      TabIndex        =   13
      Text            =   "Text1"
      Top             =   1200
      Width           =   1695
   End
   Begin VB.TextBox txtWMPfilename 
      Height          =   285
      Left            =   3960
      TabIndex        =   12
      Text            =   "Text1"
      Top             =   1200
      Width           =   1695
   End
   Begin VB.TextBox txtSMPfilename 
      Height          =   285
      Left            =   3960
      TabIndex        =   11
      Text            =   "Text1"
      Top             =   840
      Width           =   1695
   End
   Begin VB.TextBox txtSDXfilename 
      Height          =   285
      Left            =   1920
      TabIndex        =   10
      Text            =   "Text1"
      Top             =   840
      Width           =   1695
   End
   Begin VB.TextBox txtMemory3 
      Height          =   285
      Left            =   4560
      TabIndex        =   8
      Text            =   "Text1"
      Top             =   480
      Width           =   1095
   End
   Begin VB.TextBox txtMemory2 
      Height          =   285
      Left            =   2760
      TabIndex        =   6
      Text            =   "Text1"
      Top             =   480
      Width           =   1095
   End
   Begin VB.TextBox txtMemory1 
      Height          =   285
      Left            =   960
      TabIndex        =   4
      Text            =   "Text1"
      Top             =   480
      Width           =   1095
   End
   Begin VB.CheckBox chkWater 
      Caption         =   "水上飘"
      Height          =   255
      Left            =   120
      TabIndex        =   2
      Top             =   120
      Width           =   855
   End
   Begin VB.CommandButton cmdcancel 
      Caption         =   "取消"
      Height          =   375
      Left            =   8400
      TabIndex        =   1
      Top             =   960
      Width           =   1335
   End
   Begin VB.CommandButton cmdok 
      Caption         =   "修改z.dat"
      Height          =   375
      Left            =   8400
      TabIndex        =   0
      Top             =   120
      Width           =   1335
   End
   Begin VB.Label Label26 
      Caption         =   "主地图实际贴图个数"
      Height          =   255
      Left            =   120
      TabIndex        =   95
      Top             =   6600
      Width           =   1935
   End
   Begin VB.Label Label25 
      Caption         =   "场景个数"
      Height          =   255
      Left            =   120
      TabIndex        =   92
      Top             =   6240
      Width           =   1095
   End
   Begin VB.Label Label24 
      Caption         =   "S*文件大小"
      Height          =   255
      Left            =   2760
      TabIndex        =   91
      Top             =   6240
      Width           =   1095
   End
   Begin VB.Label Label23 
      Caption         =   "D*文件大小"
      Height          =   255
      Left            =   5400
      TabIndex        =   90
      Top             =   6240
      Width           =   1095
   End
   Begin VB.Label Label22 
      Caption         =   "物品贴图起始地址"
      Height          =   255
      Left            =   3960
      TabIndex        =   85
      Top             =   5880
      Width           =   1935
   End
   Begin VB.Label Label21 
      Caption         =   "伤害生命与受伤比例"
      Height          =   255
      Left            =   120
      TabIndex        =   83
      Top             =   5880
      Width           =   1935
   End
   Begin VB.Label Label20 
      Caption         =   "带毒最大值"
      Height          =   255
      Index           =   12
      Left            =   2040
      TabIndex        =   81
      Top             =   5400
      Width           =   1095
   End
   Begin VB.Label Label20 
      Caption         =   "品德最大值"
      Height          =   255
      Index           =   11
      Left            =   120
      TabIndex        =   79
      Top             =   5400
      Width           =   1095
   End
   Begin VB.Label Label20 
      Caption         =   "武学最大值"
      Height          =   255
      Index           =   10
      Left            =   7800
      TabIndex        =   77
      Top             =   5040
      Width           =   1095
   End
   Begin VB.Label Label20 
      Caption         =   "暗器最大值"
      Height          =   255
      Index           =   9
      Left            =   5880
      TabIndex        =   75
      Top             =   5040
      Width           =   1095
   End
   Begin VB.Label Label20 
      Caption         =   "特殊最大值"
      Height          =   255
      Index           =   8
      Left            =   3960
      TabIndex        =   73
      Top             =   5040
      Width           =   1095
   End
   Begin VB.Label Label20 
      Caption         =   "耍刀最大值"
      Height          =   255
      Index           =   7
      Left            =   2040
      TabIndex        =   71
      Top             =   5040
      Width           =   1095
   End
   Begin VB.Label Label20 
      Caption         =   "御剑最大值"
      Height          =   255
      Index           =   6
      Left            =   120
      TabIndex        =   69
      Top             =   5040
      Width           =   1095
   End
   Begin VB.Label Label20 
      Caption         =   "拳掌最大值"
      Height          =   255
      Index           =   5
      Left            =   7800
      TabIndex        =   67
      Top             =   4680
      Width           =   1095
   End
   Begin VB.Label Label20 
      Caption         =   "抗毒最大值"
      Height          =   255
      Index           =   4
      Left            =   5880
      TabIndex        =   65
      Top             =   4680
      Width           =   1095
   End
   Begin VB.Label Label20 
      Caption         =   "解毒最大值"
      Height          =   255
      Index           =   3
      Left            =   3960
      TabIndex        =   63
      Top             =   4680
      Width           =   1095
   End
   Begin VB.Label Label20 
      Caption         =   "用毒最大值"
      Height          =   255
      Index           =   2
      Left            =   2040
      TabIndex        =   61
      Top             =   4680
      Width           =   1095
   End
   Begin VB.Label Label20 
      Caption         =   "医疗最大值"
      Height          =   255
      Index           =   1
      Left            =   120
      TabIndex        =   59
      Top             =   4680
      Width           =   1095
   End
   Begin VB.Label Label20 
      Caption         =   "防御最大值"
      Height          =   255
      Index           =   0
      Left            =   7800
      TabIndex        =   57
      Top             =   4320
      Width           =   1095
   End
   Begin VB.Label Label19 
      Caption         =   "轻功最大值"
      Height          =   255
      Left            =   5880
      TabIndex        =   55
      Top             =   4320
      Width           =   1095
   End
   Begin VB.Label Label18 
      Caption         =   "攻击最大值"
      Height          =   255
      Left            =   3960
      TabIndex        =   54
      Top             =   4320
      Width           =   1215
   End
   Begin VB.Label Label17 
      Caption         =   "内力最大值"
      Height          =   255
      Left            =   2040
      TabIndex        =   52
      Top             =   4320
      Width           =   1215
   End
   Begin VB.Label Label14 
      Caption         =   "生命最大值"
      Height          =   255
      Left            =   120
      TabIndex        =   51
      Top             =   4320
      Width           =   1215
   End
   Begin VB.Label Label16 
      Caption         =   "最大等级"
      Height          =   255
      Left            =   5520
      TabIndex        =   47
      Top             =   3840
      Width           =   855
   End
   Begin VB.Label Label15 
      Caption         =   "各等级升级经验(100个)"
      Height          =   255
      Left            =   120
      TabIndex        =   46
      Top             =   3840
      Width           =   2175
   End
   Begin VB.Label lblLevel 
      Caption         =   "0"
      Height          =   255
      Left            =   3840
      TabIndex        =   45
      Top             =   3840
      Width           =   495
   End
   Begin VB.Label lblEft 
      Caption         =   "0"
      Height          =   255
      Left            =   3840
      TabIndex        =   42
      Top             =   3480
      Width           =   495
   End
   Begin VB.Label Label13 
      Caption         =   "武功效果动画帧数(100个)"
      Height          =   255
      Left            =   120
      TabIndex        =   41
      Top             =   3480
      Width           =   2175
   End
   Begin VB.Label Label11 
      Caption         =   "武功武器配合(100个)"
      Height          =   255
      Left            =   120
      TabIndex        =   38
      Top             =   3120
      Width           =   1695
   End
   Begin VB.Label lblFit 
      Caption         =   "0"
      Height          =   255
      Left            =   3600
      TabIndex        =   37
      Top             =   3120
      Width           =   495
   End
   Begin VB.Label Label12 
      Caption         =   "加攻击力"
      Height          =   255
      Left            =   7560
      TabIndex        =   36
      Top             =   3120
      Width           =   1095
   End
   Begin VB.Label Lblliduiperson 
      Caption         =   "0"
      Height          =   255
      Left            =   3600
      TabIndex        =   31
      Top             =   2760
      Width           =   375
   End
   Begin VB.Label Label10 
      Caption         =   "可离队人员(100个)"
      Height          =   255
      Left            =   120
      TabIndex        =   30
      Top             =   2760
      Width           =   1575
   End
   Begin VB.Label Label9 
      Caption         =   "离队事件编号"
      Height          =   255
      Left            =   6120
      TabIndex        =   29
      Top             =   2760
      Width           =   1095
   End
   Begin VB.Label LblLight 
      Caption         =   "0"
      Height          =   255
      Left            =   3600
      TabIndex        =   25
      Top             =   2400
      Width           =   495
   End
   Begin VB.Label Label8 
      Caption         =   "山洞场景(30个)"
      Height          =   255
      Left            =   120
      TabIndex        =   24
      Top             =   2400
      Width           =   1815
   End
   Begin VB.Label Label7 
      Caption         =   "音乐音效文件名"
      Height          =   255
      Left            =   120
      TabIndex        =   18
      Top             =   1920
      Width           =   1815
   End
   Begin VB.Label Label6 
      Caption         =   "战斗文件名"
      Height          =   255
      Left            =   120
      TabIndex        =   17
      Top             =   1560
      Width           =   1815
   End
   Begin VB.Label Label5 
      Caption         =   "战斗场景贴图文件名"
      Height          =   255
      Left            =   120
      TabIndex        =   14
      Top             =   1200
      Width           =   1815
   End
   Begin VB.Label Label4 
      Caption         =   "场景贴图文件名"
      Height          =   255
      Left            =   120
      TabIndex        =   9
      Top             =   840
      Width           =   1335
   End
   Begin VB.Label Label3 
      Caption         =   "内存2"
      Height          =   255
      Left            =   3960
      TabIndex        =   7
      Top             =   480
      Width           =   735
   End
   Begin VB.Label Label2 
      Caption         =   "内存1"
      Height          =   255
      Left            =   2160
      TabIndex        =   5
      Top             =   480
      Width           =   735
   End
   Begin VB.Label Label1 
      Caption         =   "总内存"
      Height          =   255
      Left            =   120
      TabIndex        =   3
      Top             =   480
      Width           =   735
   End
End
Attribute VB_Name = "frmznewedit"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Option Explicit
Dim WaterValue As Integer
Dim WaterAddr As Long

Private LightScene(29) As Integer
Private AddPerson(99) As Integer

Private Type WeaponFit_type
    ThingID As Integer
    WugongID As Integer
    AddValue As Integer
End Type

Private WeaponFit(99) As WeaponFit_type

Private Eft(99) As Integer

Private LevelExp(99) As Integer

Private Sub cmdAuto_Click()
    txtScenenum.Text = Scenenum
    txtSFilelength.Text = FileLen(G_Var.JYPath & G_Var.SGRP(1))
    txtDFilelength.Text = FileLen(G_Var.JYPath & G_Var.DGRP(1))
    FileCopy G_Var.JYPath & G_Var.RIDX(1), G_Var.JYPath & G_Var.RIDX(0)
    FileCopy G_Var.JYPath & G_Var.SIDX(1), G_Var.JYPath & G_Var.SIDX(0)
    FileCopy G_Var.JYPath & G_Var.DIDX(1), G_Var.JYPath & G_Var.DIDX(0)
    FileCopy G_Var.JYPath & G_Var.SIDX(1), G_Var.JYPath & "allsinbk.idx"
    FileCopy G_Var.JYPath & G_Var.DIDX(1), G_Var.JYPath & "alldefbk.idx"
    
End Sub

Private Sub cmdcancel_Click()
    Unload Me
End Sub

Private Sub cmdCustom_Click()
Dim casm As Collection
Dim i As Long, j As Long
Dim id As Long

    Call ReadZmodify(G_Var.JYPath & "custom.ini", casm)
        
    id = OpenBin(G_Var.JYPath & G_Var.EXE, "W")
    For i = 1 To casm.Count
        If casm(i).Style <> 0 Then
            For j = 0 To casm(i).num - 1
                Put #id, casm(i).Address + j + 1, CByte(casm(i).Data(j))
            Next j
        End If
    Next i

    Close id

End Sub



Private Sub OutVar(id As Long, Value As Variant, Optional addr As Long = -1)
Dim s As String
    If addr <> -1 Then
        Print #id, "Start " & Hex(addr)
    End If
    s = Hex(Value)
    If Len(s) < 8 Then
        s = String(8 - Len(s), "0") & s
    End If
    Select Case VarType(Value)
    Case vbByte
        Print #id, "    " & Mid(s, 7, 2)
    Case vbInteger
        Print #id, "    " & Mid(s, 7, 2) & " " & Mid(s, 5, 2)
    Case vbLong
        Print #id, "    " & Mid(s, 7, 2) & " " & Mid(s, 5, 2) & " " & Mid(s, 3, 2) & " " & Mid(s, 1, 2)
    End Select
End Sub

Private Sub OutZStr(id As Long, sectionstr As String, itemstr As String, s As String)
Dim i As Long
Dim length As Long
Dim tmps As String

    Print #id, "Start " & Hex(CLng("&h" & GetINIStr(sectionstr, itemstr)))
    length = Len(s)
    tmps = ""
    For i = 1 To length
        tmps = tmps & Hex(Asc(Mid(s, i, 1))) & " "
    Next i
    tmps = tmps & "00"
    Print #id, "    " & tmps
End Sub

' 记录修改的z.dat
Private Sub OutputModify()
Dim id As Long
Dim tmpaddr As Long
Dim tmplong As Long
Dim tmpbyte As Byte
Dim tmpstr As String
Dim tmpstrArray() As String
Dim i As Long, j As Long
Dim casm As Collection
Dim filename As String
    
    filename = G_Var.JYPath & "ModifyZ.ini"
    If Dir(filename) <> "" Then
       Kill filename
    End If

    id = FreeFile()
    Open filename For Output As #id
    
    ' 写水上飘
    If chkWater.Value = 0 Then
        WaterValue = CInt("&h" & GetINIStr("NewZEdit", "WaterNo"))
    Else
        WaterValue = CInt("&h" & GetINIStr("NewZEdit", "WaterYes"))
    End If
    Call OutVar(id, WaterValue, WaterAddr)
    ' 写内存
    tmpaddr = CLng("&h" & GetINIStr("NewZEdit", "MemoryAddr1"))
    Call OutVar(id, CLng(txtMemory1.Text), tmpaddr)
    tmpaddr = CLng("&h" & GetINIStr("NewZEdit", "MemoryAddr2"))
    Call OutVar(id, CLng(txtMemory2.Text), tmpaddr)
    tmpaddr = CLng("&h" & GetINIStr("NewZEdit", "MemoryAddr3"))
    Call OutVar(id, CLng(txtMemory3.Text), tmpaddr)
    ' 写sdxsmp
    Call OutZStr(id, "NewZEdit", "SDXFileNameAddr", Trim(txtSDXfilename.Text))
    Call OutZStr(id, "NewZEdit", "SmpFileNameAddr", Trim(txtSMPfilename.Text))
    ' 写wdxwmp
    Call OutZStr(id, "NewZEdit", "wDXFileNameAddr", Trim(txtWDXfilename.Text))
    Call OutZStr(id, "NewZEdit", "wmpFileNameAddr", Trim(txtWMPfilename.Text))
     
    ' 写fight
    Call OutZStr(id, "NewZEdit", "fightIDXFileNameAddr", Trim(txtfightidx.Text))
    Call OutZStr(id, "NewZEdit", "fightGRPFileNameAddr", Trim(txtfightgrp.Text))
   ' 写音乐音效文件名
    Call OutZStr(id, "NewZEdit", "XMIFilenameAddr", Trim(txtXMI.Text))
    Call OutZStr(id, "NewZEdit", "atkFilenameAddr", Trim(txtAtk.Text))
    Call OutZStr(id, "NewZEdit", "eFilenameAddr", Trim(txtEEE.Text))
    ' 写亮灯场景
    Call OutVar(id, LightScene(0), CLng("&h" & GetINIStr("NewZEdit", "LightlistAddr")))
    For i = 1 To UBound(LightScene)
        Call OutVar(id, LightScene(i))
    Next i
    ' 写加入人物
    Call OutVar(id, AddPerson(0), CLng("&h" & GetINIStr("NewZEdit", "AddpersonAddr")))
    For i = 1 To UBound(AddPerson)
        Call OutVar(id, AddPerson(i))
    Next i
    ' 写离队事件起始编号
    Call OutVar(id, CLng(txtliduishijian.Text), CLng("&h" & GetINIStr("NewZEdit", "LiduiEventAddr")))
    ' 写武功武器配合
    Call OutVar(id, WeaponFit(0).ThingID, CLng("&h" & GetINIStr("NewZEdit", "FitAddr")))
    Call OutVar(id, WeaponFit(0).WugongID)
    Call OutVar(id, WeaponFit(0).AddValue)
    For i = 1 To UBound(WeaponFit)
        Call OutVar(id, WeaponFit(i).ThingID)
        Call OutVar(id, WeaponFit(i).WugongID)
        Call OutVar(id, WeaponFit(i).AddValue)
    Next i
    ' 写武功效果动画帧数
    Call OutVar(id, Eft(0), CLng("&h" & GetINIStr("NewZEdit", "eftAddr")))
    For i = 1 To UBound(Eft)
        Call OutVar(id, Eft(i))
    Next i
    
    ' 写等级经验
    Call OutVar(id, LevelExp(0), CLng("&h" & GetINIStr("NewZEdit", "LevelExpAddr")))
    For i = 1 To UBound(LevelExp)
        Call OutVar(id, LevelExp(i))
    Next i
    
    ' 写最大等级
    Call OutVar(id, CByte(txtMaxLevel.Text), CLng("&h" & GetINIStr("NewZEdit", "maxlevel1")))
    Call OutVar(id, CByte(txtMaxLevel.Text), CLng("&h" & GetINIStr("NewZEdit", "maxlevel2")))
    Call OutVar(id, CByte(txtMaxLevel.Text), CLng("&h" & GetINIStr("NewZEdit", "maxlevel3")))
    
    ' 修改生命最大值
    tmpstrArray = Split(GetINIStr("NewZEdit", "LifeMaxAddr"), ",")
    For i = 0 To UBound(tmpstrArray, 1)
         Call OutVar(id, CInt(txtlifemax.Text), CLng("&h" & tmpstrArray(i)))
    Next i
    ' 修改内力最大值
    tmpstrArray = Split(GetINIStr("NewZEdit", "NeiliMaxAddr"), ",")
    For i = 0 To UBound(tmpstrArray, 1)
         Call OutVar(id, CInt(txtneilimax.Text), CLng("&h" & tmpstrArray(i)))
    Next i
    
    ' 写属性最大值
    tmpaddr = CLng("&h" & GetINIStr("NewZEdit", "ShuxingAddr"))
    Call OutVar(id, CInt(txtShuxing(0).Text), tmpaddr)
    For i = 1 To 14
        Call OutVar(id, CInt(txtShuxing(i).Text))
    Next i
    ' 写受伤比例
    Call OutVar(id, CLng(txtLifescale.Text), CLng("&h" & GetINIStr("NewZEdit", "AddrLifeScale")))
    ' 写物品贴图起始地址
    Call OutVar(id, CInt(txtWupinPicAddr.Text), CLng("&h" & GetINIStr("NewZEdit", "WupinPicAddr")))
    
    Call OutVar(id, CLng(txtScenenum.Text), CLng("&h" & GetINIStr("NewZEdit", "ChangjingNumAddr")))
    
    tmpstrArray = Split(GetINIStr("NewZEdit", "SFileLengthAddr"), ",")
    For i = 0 To UBound(tmpstrArray, 1)
        Call OutVar(id, CLng(txtSFilelength.Text / 2), CLng("&h" & tmpstrArray(i)))
    Next i
    tmpstrArray = Split(GetINIStr("NewZEdit", "DFileLengthAddr"), ",")
    For i = 0 To UBound(tmpstrArray, 1)
        Call OutVar(id, CLng(txtDFilelength.Text), CLng("&h" & tmpstrArray(i)))
    Next i

    ' 写主地图实际贴图个数
    Call OutVar(id, CLng(txtmmappicNum.Text), CLng("&h" & GetINIStr("NewZEdit", "MMAPPicNumAddr")))
    Call OutVar(id, CLng(txtmmappicNum.Text * 4), CLng("&h" & GetINIStr("NewZEdit", "MMAPPicNumAddr2")))
    
    
    Call OutVar(id, CLng(chkVediomode.Value), CLng("&h" & GetINIStr("Vediomode", "VedioModeAddr")))
    ' 写显示模式数据
    If chkVediomode.Value = 0 Then   ' 320*200
        tmpstrArray = Split(GetINIStr("VedioMode", "VedioWidthAddr"), ",")
        For i = 0 To UBound(tmpstrArray, 1)
            Call OutVar(id, CInt(320), CLng("&h" & tmpstrArray(i)))
        Next i
        tmpstrArray = Split(GetINIStr("VedioMode", "VedioHeightAddr"), ",")
        For i = 0 To UBound(tmpstrArray, 1)
            Call OutVar(id, CInt(200), CLng("&h" & tmpstrArray(i)))
        Next i
        Call OutVar(id, CInt(312), CLng("&h" & GetINIStr("VedioMode", "VedioAddrStr")))
        Call OutVar(id, CInt(304), CLng("&h" & GetINIStr("VedioMode", "VedioAddrStr2")))
        
        Call OutVar(id, CLng(16000), CLng("&h" & GetINIStr("VedioMode", "VedioBufferAddr")))
        
        tmpstrArray = Split(GetINIStr("VedioMode", "AddrVMmap1"), ",")
        For i = 0 To UBound(tmpstrArray, 1)
            Call OutVar(id, CByte(&HB), CLng("&h" & tmpstrArray(i)))
        Next i
        tmpstrArray = Split(GetINIStr("VedioMode", "AddrVMmap2"), ",")
        For i = 0 To UBound(tmpstrArray, 1)
            Call OutVar(id, CByte(&H15), CLng("&h" & tmpstrArray(i)))
        Next i
        tmpstrArray = Split(GetINIStr("VedioMode", "AddrVMmap3"), ",")
        For i = 0 To UBound(tmpstrArray, 1)
            Call OutVar(id, CByte(&HA), CLng("&h" & tmpstrArray(i)))
        Next i
        
        
        tmpstrArray = Split(GetINIStr("VedioMode", "AddrSMAP1"), ",")
        For i = 0 To UBound(tmpstrArray, 1)
            Call OutVar(id, CByte(&HB), CLng("&h" & tmpstrArray(i)))
        Next i
        tmpstrArray = Split(GetINIStr("VedioMode", "AddrSMAP2"), ",")
        For i = 0 To UBound(tmpstrArray, 1)
            Call OutVar(id, CByte(&HF5), CLng("&h" & tmpstrArray(i)))
        Next i
        tmpstrArray = Split(GetINIStr("VedioMode", "AddrSMAP3"), ",")
        For i = 0 To UBound(tmpstrArray, 1)
            Call OutVar(id, CByte(&H1C), CLng("&h" & tmpstrArray(i)))
        Next i
        tmpstrArray = Split(GetINIStr("VedioMode", "AddrSMAP4"), ",")
        For i = 0 To UBound(tmpstrArray, 1)
            Call OutVar(id, CByte(&H24), CLng("&h" & tmpstrArray(i)))
        Next i
        tmpstrArray = Split(GetINIStr("VedioMode", "AddrSMAPNew1"), ",")
        For i = 0 To UBound(tmpstrArray, 1)
            Call OutVar(id, CByte(&H8), CLng("&h" & tmpstrArray(i)))
        Next i
        tmpstrArray = Split(GetINIStr("VedioMode", "AddrSMAPNew2"), ",")
        For i = 0 To UBound(tmpstrArray, 1)
            Call OutVar(id, CByte(&H9), CLng("&h" & tmpstrArray(i)))
        Next i
        
        tmpstrArray = Split(GetINIStr("VedioMode", "AddrWMAP1"), ",")
        For i = 0 To UBound(tmpstrArray, 1)
            Call OutVar(id, CByte(&HB), CLng("&h" & tmpstrArray(i)))
        Next i
        tmpstrArray = Split(GetINIStr("VedioMode", "AddrWMAP2"), ",")
        For i = 0 To UBound(tmpstrArray, 1)
            Call OutVar(id, CByte(&H20), CLng("&h" & tmpstrArray(i)))
        Next i
        tmpstrArray = Split(GetINIStr("VedioMode", "AddrWMAP3"), ",")
        For i = 0 To UBound(tmpstrArray, 1)
            Call OutVar(id, CByte(&H20), CLng("&h" & tmpstrArray(i)))
        Next i
        
        
        
    Else     ' 640*480
        tmpstrArray = Split(GetINIStr("VedioMode", "VedioWidthAddr"), ",")
        For i = 0 To UBound(tmpstrArray, 1)
            Call OutVar(id, CInt(640), CLng("&h" & tmpstrArray(i)))
        Next i
        tmpstrArray = Split(GetINIStr("VedioMode", "VedioHeightAddr"), ",")
        For i = 0 To UBound(tmpstrArray, 1)
            Call OutVar(id, CInt(480), CLng("&h" & tmpstrArray(i)))
        Next i
        Call OutVar(id, CInt(632), CLng("&h" & GetINIStr("VedioMode", "VedioAddrStr")))
        Call OutVar(id, CInt(624), CLng("&h" & GetINIStr("VedioMode", "VedioAddrStr2")))
    
        Call OutVar(id, CLng(81920), CLng("&h" & GetINIStr("VedioMode", "VedioBufferAddr")))
    
        tmpstrArray = Split(GetINIStr("VedioMode", "AddrVMmap1"), ",")
        For i = 0 To UBound(tmpstrArray, 1)
            Call OutVar(id, CByte(&HB + 10), CLng("&h" & tmpstrArray(i)))
        Next i
        tmpstrArray = Split(GetINIStr("VedioMode", "AddrVMmap2"), ",")
        For i = 0 To UBound(tmpstrArray, 1)
            Call OutVar(id, CByte(&H15 + 5), CLng("&h" & tmpstrArray(i)))
        Next i
        tmpstrArray = Split(GetINIStr("VedioMode", "AddrVMmap3"), ",")
        For i = 0 To UBound(tmpstrArray, 1)
            Call OutVar(id, CByte(&HA + 10), CLng("&h" & tmpstrArray(i)))
        Next i
    
    
        tmpstrArray = Split(GetINIStr("VedioMode", "AddrSMAP1"), ",")
        For i = 0 To UBound(tmpstrArray, 1)
            Call OutVar(id, CByte(&HB + 9), CLng("&h" & tmpstrArray(i)))
        Next i
        tmpstrArray = Split(GetINIStr("VedioMode", "AddrSMAP2"), ",")
        For i = 0 To UBound(tmpstrArray, 1)
            Call OutVar(id, CByte(&HF5 - 9), CLng("&h" & tmpstrArray(i)))
        Next i
        tmpstrArray = Split(GetINIStr("VedioMode", "AddrSMAP3"), ",")
        For i = 0 To UBound(tmpstrArray, 1)
            Call OutVar(id, CByte(&H1C + 18), CLng("&h" & tmpstrArray(i)))
        Next i
        tmpstrArray = Split(GetINIStr("VedioMode", "AddrSMAP4"), ",")
        For i = 0 To UBound(tmpstrArray, 1)
            Call OutVar(id, CByte(&H24 - 18), CLng("&h" & tmpstrArray(i)))
        Next i
        tmpstrArray = Split(GetINIStr("VedioMode", "AddrSMAPNew1"), ",")
        For i = 0 To UBound(tmpstrArray, 1)
            Call OutVar(id, CByte(&H0), CLng("&h" & tmpstrArray(i)))
        Next i
        tmpstrArray = Split(GetINIStr("VedioMode", "AddrSMAPNew2"), ",")
        For i = 0 To UBound(tmpstrArray, 1)
            Call OutVar(id, CByte(&H0), CLng("&h" & tmpstrArray(i)))
        Next i
    
        tmpstrArray = Split(GetINIStr("VedioMode", "AddrWMAP1"), ",")
        For i = 0 To UBound(tmpstrArray, 1)
            Call OutVar(id, CByte(&HB + 9), CLng("&h" & tmpstrArray(i)))
        Next i
        tmpstrArray = Split(GetINIStr("VedioMode", "AddrWMAP2"), ",")
        For i = 0 To UBound(tmpstrArray, 1)
            Call OutVar(id, CByte(&H20 - 18), CLng("&h" & tmpstrArray(i)))
        Next i
        tmpstrArray = Split(GetINIStr("VedioMode", "AddrWMAP3"), ",")
        For i = 0 To UBound(tmpstrArray, 1)
            Call OutVar(id, CByte(&H20 + 18), CLng("&h" & tmpstrArray(i)))
        Next i

    
    
    End If
    
    
    
        ' 写闪烁效果
    
    If chkFlash.Value = 1 Then
        Call OutVar(id, CByte("&h53"), CLng("&h" & GetINIStr("NewZEdit", "FlashAddr")))
    Else
        Call OutVar(id, CByte("&hc3"), CLng("&h" & GetINIStr("NewZEdit", "FlashAddr")))
    End If
    
    
    Print #id, "End"
    Close id
    
    Call ReadZmodify(filename, casm)
        
    id = OpenBin(G_Var.JYPath & G_Var.EXE, "W")
            
        
    For i = 1 To casm.Count
        If casm(i).Style <> 0 Then
            For j = 0 To casm(i).num - 1
                Put #id, casm(i).Address + j + 1, CByte(casm(i).Data(j))
            Next j
        End If
    Next i

    Close id
    
    
End Sub



Private Sub cmdok_Click()
    Call OutputModify
End Sub

Private Sub Comboperson_click()
    If Comboperson.ListIndex >= 0 Then
        AddPerson(HScrollPerson.Value) = Comboperson.ListIndex - 1
    End If

End Sub

Private Sub ComboThing_click()
    If ComboThing.ListIndex >= 0 Then
        WeaponFit(HScrollFit.Value).ThingID = ComboThing.ListIndex
    End If

End Sub

Private Sub ComboWugong_click()
    If ComboWugong.ListIndex >= 0 Then
        WeaponFit(HScrollFit.Value).WugongID = ComboWugong.ListIndex
    End If
End Sub

Private Sub Command1_Click()

End Sub

Private Sub Form_Load()
Dim zfilenum As Long
Dim i As Long
Dim tmpaddr As Long
Dim tmpInt As Integer
Dim tmplong As Long
Dim tmpstr As Long
Dim tmpbyte() As Byte
Dim tmpB1 As Byte, tmpB2 As Byte
Dim tmpstrArray() As String
    Me.Caption = StrUnicode(Me.Caption)
    For i = 0 To Me.Controls.Count - 1
         Call SetCaption(Me.Controls(i))
    Next i
    
    ComboLight.Clear
    ComboLight.AddItem "-1"
    For i = 0 To Scenenum - 1
        ComboLight.AddItem i & Big5toUnicode(Scene(i).Name1, 10)
    Next i

    Comboperson.Clear
    Comboperson.AddItem "-1"
    For i = 0 To PersonNum - 1
        Comboperson.AddItem i & Person(i).Name1
    Next i
    
    ComboThing.Clear
    For i = 0 To Thingsnum - 1
        ComboThing.AddItem i & Things(i).name2
    Next i
    
    ComboWugong.Clear
    For i = 0 To WuGongnum - 1
        ComboWugong.AddItem i & WuGong(i).Name1
    Next i
    
    
    
    zfilenum = OpenBin(G_Var.JYPath & G_Var.EXE, "R")
    WaterAddr = CLng("&h" & GetINIStr("NewZEdit", "WaterAddr"))
    Get #zfilenum, WaterAddr + 1, WaterValue
    If WaterValue = CInt("&h" & GetINIStr("NewZEdit", "WaterYes")) Then
        chkWater.Value = 1
    Else
        chkWater.Value = 0
    End If
    
    tmpaddr = CLng("&h" & GetINIStr("NewZEdit", "MemoryAddr1"))
    Get #zfilenum, tmpaddr + 1, tmplong
    txtMemory1.Text = tmplong
    tmpaddr = CLng("&h" & GetINIStr("NewZEdit", "MemoryAddr2"))
    Get #zfilenum, tmpaddr + 1, tmplong
    txtMemory2.Text = tmplong
    tmpaddr = CLng("&h" & GetINIStr("NewZEdit", "MemoryAddr3"))
    Get #zfilenum, tmpaddr + 1, tmplong
    txtMemory3.Text = tmplong
    
        ' 读sdx文件名
        
    txtSDXfilename.Text = ReadZStr(zfilenum, "NewZEdit", "SDXFileNameAddr")
    txtSMPfilename.Text = ReadZStr(zfilenum, "NewZEdit", "SmpFileNameAddr")
     
        ' 读wdx文件名
    txtWDXfilename.Text = ReadZStr(zfilenum, "NewZEdit", "wDXFileNameAddr")
    txtWMPfilename.Text = ReadZStr(zfilenum, "NewZEdit", "wmpFileNameAddr")
        
        ' 读fight文件名
    txtfightidx.Text = ReadZStr(zfilenum, "NewZEdit", "fightIDXFileNameAddr")
    txtfightgrp.Text = ReadZStr(zfilenum, "NewZEdit", "FightGRPFileNameAddr")
     
   ' 读音乐音效文件名
    txtXMI.Text = ReadZStr(zfilenum, "NewZEdit", "XMIFilenameAddr")
    txtAtk.Text = ReadZStr(zfilenum, "NewZEdit", "ATKFilenameAddr")
    txtEEE.Text = ReadZStr(zfilenum, "NewZEdit", "EFilenameAddr")
    
    
    ' 读亮灯场景
    Get #zfilenum, CLng("&h" & GetINIStr("NewZEdit", "LightlistAddr")) + 1, LightScene
    HScrollLight.Min = 0
    HScrollLight.Max = 29
    HScrollLight.Value = 0
    HScrollLight_Change
    
    ' 读可加入人物
    Get #zfilenum, CLng("&h" & GetINIStr("NewZEdit", "AddPersonAddr")) + 1, AddPerson
    HScrollPerson.Min = 0
    HScrollPerson.Max = 99
    HScrollPerson.Value = 0
    HScrollPerson_Change
    ' 读离队事件起始编号
    Get #zfilenum, CLng("&h" & GetINIStr("NewZEdit", "LiduiEventAddr")) + 1, tmplong
    txtliduishijian.Text = tmplong
    
    ' 读武器武功配合
    Get #zfilenum, CLng("&h" & GetINIStr("NewZEdit", "FitAddr")) + 1, WeaponFit
    HScrollFit.Min = 0
    HScrollFit.Max = 99
    HScrollFit.Value = 0
    HScrollFit_Change
    
    ' 读武功效果动画帧数
    Get #zfilenum, CLng("&h" & GetINIStr("NewZEdit", "EftAddr")) + 1, Eft
    HScrollEft.Min = 0
    HScrollEft.Max = 99
    HScrollEft.Value = 0
    HScrollEft_Change
    
    ' 读等级经验
    Get #zfilenum, CLng("&h" & GetINIStr("NewZEdit", "LevelExpAddr")) + 1, LevelExp
    HScrollLevel.Min = 0
    HScrollLevel.Max = 99
    HScrollLevel.Value = 0
    HScrollLevel_Change

    ' 读最大等级
    Get #zfilenum, CLng("&h" & GetINIStr("NewZEdit", "MAXLevel1")) + 1, tmpB1
    Get #zfilenum, CLng("&h" & GetINIStr("NewZEdit", "MAXLevel2")) + 1, tmpB2
    If tmpB1 = tmpB2 Then
        txtMaxLevel.Text = tmpB1
    Else
        MsgBox "Read z.dat MaxLevel1<>MaxLevel2 in NewZEdit"
    End If
   
        ' 生命最大值
    tmpstrArray = Split(GetINIStr("NewZEdit", "LifeMaxAddr"), ",")
    
    Get #zfilenum, CLng("&h" & tmpstrArray(0)) + 1, tmpInt
    txtlifemax.Text = tmpInt
    
    
    ' 内力最大值
    tmpstrArray = Split(GetINIStr("NewZEdit", "NeiliMaxAddr"), ",")
    Get #zfilenum, CLng("&h" & (tmpstrArray(0))) + 1, tmpInt
    txtneilimax.Text = tmpInt

    ' 读属性最大值
    tmpaddr = CLng("&h" & GetINIStr("NewZEdit", "ShuxingAddr"))
    For i = 0 To 14
        Get #zfilenum, tmpaddr + 2 * i + 1, tmpInt
        txtShuxing(i).Text = tmpInt
    Next i
    ' 读伤害比例
    Get #zfilenum, CLng("&h" & GetINIStr("NewZEdit", "AddrLifeScale")) + 1, tmplong
    txtLifescale.Text = tmplong
    ' 读物品贴图起始地址
    Get #zfilenum, CLng("&h" & GetINIStr("NewZEdit", "WupinPicAddr")) + 1, tmpInt
    txtWupinPicAddr.Text = tmpInt
    ' 读场景个数
    Get #zfilenum, CLng("&h" & GetINIStr("NewZEdit", "ChangjingNumAddr")) + 1, tmplong
    txtScenenum.Text = tmplong
    
    tmpstrArray = Split(GetINIStr("NewZEdit", "SFileLengthAddr"), ",")
    Get #zfilenum, CLng("&h" & tmpstrArray(0)) + 1, tmplong
    txtSFilelength.Text = tmplong * 2
    
    tmpstrArray = Split(GetINIStr("NewZEdit", "DFileLengthAddr"), ",")
    Get #zfilenum, CLng("&h" & tmpstrArray(0)) + 1, tmplong
    txtDFilelength.Text = tmplong

    
    ' 读主地图实际贴图个数
    Get #zfilenum, CLng("&h" & GetINIStr("NewZEdit", "MMAPPicNumAddr")) + 1, tmplong
    txtmmappicNum.Text = tmplong
    
    
    ' 读显示模式
    
    Get #zfilenum, CLng("&h" & GetINIStr("Vediomode", "VedioModeAddr")) + 1, tmplong
    chkVediomode.Value = tmplong
    
    
    
    
    ' 读闪烁效果
    Get #zfilenum, CLng("&h" & GetINIStr("NewZEdit", "FlashAddr")) + 1, tmpB1
    If tmpB1 = CByte("&h53") Then
        chkFlash.Value = 1
    Else
        chkFlash.Value = 0
    End If
    
    
    Close zfilenum
    
    
    
    
    
End Sub


Private Function ReadZStr(id As Long, sectionstr As String, itemstr As String)
Dim tmpbyte() As Byte
    ReDim tmpbyte(20)
    Get #id, CLng("&h" & GetINIStr(sectionstr, itemstr)) + 1, tmpbyte
    ReadZStr = Byte2String(tmpbyte)
End Function


Private Sub WriteZStr(id As Long, sectionstr As String, itemstr As String, s As String)

    Put #id, CLng("&h" & GetINIStr(sectionstr, itemstr)) + 1, s
    Put #id, , CByte(0)
End Sub

Private Sub HScrollEft_Change()
    txtEft.Text = Eft(HScrollEft.Value)
    lblEft.Caption = HScrollEft.Value

End Sub

Private Sub HScrollFit_Change()
    ComboThing.ListIndex = WeaponFit(HScrollFit.Value).ThingID
    ComboWugong.ListIndex = WeaponFit(HScrollFit.Value).WugongID
    txtFit.Text = WeaponFit(HScrollFit.Value).AddValue
    lblFit.Caption = HScrollFit.Value

End Sub

Private Sub HScrollLevel_Change()
    txtLevel.Text = Int2Long(LevelExp(HScrollLevel.Value))
    lblLevel.Caption = HScrollLevel.Value

End Sub

Private Sub HScrollLight_Change()
    ComboLight.ListIndex = LightScene(HScrollLight.Value) + 1
    LblLight.Caption = HScrollLight.Value
End Sub

Private Sub ComboLight_click()
    If ComboLight.ListIndex >= 0 Then
        LightScene(HScrollLight.Value) = ComboLight.ListIndex - 1
    End If
End Sub

Private Sub HScrollPerson_Change()
    Comboperson.ListIndex = AddPerson(HScrollPerson.Value) + 1
    Lblliduiperson.Caption = HScrollPerson.Value
End Sub

Private Sub txtEft_Change()
    Eft(HScrollEft.Value) = txtEft.Text
End Sub

Private Sub txtFit_Change()
    WeaponFit(HScrollFit.Value).AddValue = txtFit.Text
End Sub

Private Sub txtLevel_Change()

   If IsNumeric(txtLevel) Then
       If txtLevel.Text > 32767 Then
          txtLevel.Text = 32767
          MsgBox "超出最大值", vbOKOnly, "警告"
          txtLevel.SetFocus
          Exit Sub
       End If
        LevelExp(HScrollLevel.Value) = Long2int(txtLevel.Text)
    Else
        txtLevel.Text = ""
        MsgBox "不能空白", vbOKOnly, "警告"
        txtLevel.SetFocus
        Exit Sub
    End If
End Sub

