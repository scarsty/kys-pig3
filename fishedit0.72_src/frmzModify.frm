VERSION 5.00
Begin VB.Form frmzModify 
   Caption         =   "z.dat Modify"
   ClientHeight    =   6090
   ClientLeft      =   60
   ClientTop       =   345
   ClientWidth     =   10455
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
   ScaleHeight     =   406
   ScaleMode       =   3  'Pixel
   ScaleWidth      =   697
   WindowState     =   2  'Maximized
   Begin VB.TextBox txtScale 
      Enabled         =   0   'False
      Height          =   285
      Left            =   3720
      TabIndex        =   51
      Text            =   "0"
      Top             =   5280
      Width           =   1215
   End
   Begin VB.CheckBox chkHurt 
      Caption         =   "修改伤害生命与受伤比例"
      Height          =   255
      Left            =   240
      TabIndex        =   49
      Top             =   5280
      Width           =   2415
   End
   Begin VB.TextBox txtFit 
      Enabled         =   0   'False
      Height          =   330
      Left            =   9360
      TabIndex        =   48
      Text            =   "0"
      Top             =   4800
      Width           =   855
   End
   Begin VB.ComboBox ComboWugong 
      Enabled         =   0   'False
      Height          =   345
      Left            =   6600
      Style           =   2  'Dropdown List
      TabIndex        =   46
      Top             =   4800
      Width           =   1575
   End
   Begin VB.ComboBox ComboThing 
      Enabled         =   0   'False
      Height          =   345
      Left            =   4800
      Style           =   2  'Dropdown List
      TabIndex        =   45
      Top             =   4800
      Width           =   1695
   End
   Begin VB.HScrollBar HScrollFit 
      Enabled         =   0   'False
      Height          =   255
      Left            =   2640
      TabIndex        =   43
      Top             =   4800
      Width           =   1455
   End
   Begin VB.CheckBox chkfit 
      Caption         =   "修改武功武器配合"
      Height          =   255
      Left            =   240
      TabIndex        =   42
      Top             =   4800
      Width           =   2295
   End
   Begin VB.ComboBox ComboLight 
      Enabled         =   0   'False
      Height          =   345
      Left            =   4800
      Style           =   2  'Dropdown List
      TabIndex        =   41
      Top             =   4440
      Width           =   1695
   End
   Begin VB.HScrollBar HScrollLight 
      Enabled         =   0   'False
      Height          =   255
      Left            =   2640
      TabIndex        =   39
      Top             =   4440
      Width           =   1455
   End
   Begin VB.CheckBox chkModifyLight 
      Caption         =   "修改亮灯场景"
      Height          =   255
      Left            =   240
      TabIndex        =   38
      Top             =   4440
      Width           =   2175
   End
   Begin VB.ListBox ListCancel 
      Columns         =   4
      Height          =   1080
      Left            =   240
      Style           =   1  'Checkbox
      TabIndex        =   36
      Top             =   3240
      Width           =   9975
   End
   Begin VB.TextBox txtMemory 
      Height          =   285
      Index           =   2
      Left            =   5880
      TabIndex        =   35
      Text            =   "Text1"
      Top             =   480
      Width           =   1335
   End
   Begin VB.TextBox txtMemory 
      Height          =   285
      Index           =   1
      Left            =   3960
      TabIndex        =   34
      Text            =   "Text1"
      Top             =   480
      Width           =   1335
   End
   Begin VB.TextBox txtMemory 
      Height          =   285
      Index           =   0
      Left            =   2160
      TabIndex        =   33
      Text            =   "Text1"
      Top             =   480
      Width           =   1335
   End
   Begin VB.CheckBox chkMemory 
      Caption         =   "内存修改"
      Height          =   255
      Left            =   240
      TabIndex        =   28
      Top             =   600
      Width           =   1095
   End
   Begin VB.CheckBox chkmodifyneilimax 
      Caption         =   "修改内力最大值"
      Height          =   255
      Left            =   3720
      TabIndex        =   27
      Top             =   2400
      Width           =   1935
   End
   Begin VB.OptionButton Optwater2 
      Caption         =   "正常"
      Enabled         =   0   'False
      Height          =   255
      Left            =   2880
      TabIndex        =   26
      Top             =   240
      Value           =   -1  'True
      Width           =   1335
   End
   Begin VB.OptionButton Optwater1 
      Caption         =   "水上飘"
      Enabled         =   0   'False
      Height          =   255
      Left            =   1680
      TabIndex        =   25
      Top             =   240
      Width           =   1215
   End
   Begin VB.TextBox txtneilimax 
      Enabled         =   0   'False
      Height          =   285
      Left            =   5880
      TabIndex        =   24
      Top             =   2400
      Width           =   735
   End
   Begin VB.TextBox txtlifemax 
      Enabled         =   0   'False
      Height          =   285
      Left            =   2280
      TabIndex        =   23
      Top             =   2400
      Width           =   735
   End
   Begin VB.CheckBox chkModifyLifeMax 
      Caption         =   "修改生命最大值"
      Height          =   255
      Left            =   240
      TabIndex        =   22
      Top             =   2400
      Width           =   1695
   End
   Begin VB.TextBox txtliduishijian 
      Enabled         =   0   'False
      Height          =   330
      Left            =   9000
      TabIndex        =   20
      Text            =   "0"
      Top             =   2040
      Width           =   615
   End
   Begin VB.ComboBox Comboperson 
      Enabled         =   0   'False
      Height          =   345
      Left            =   5880
      Style           =   2  'Dropdown List
      TabIndex        =   17
      Top             =   2040
      Width           =   1815
   End
   Begin VB.HScrollBar HScrollPerson 
      Enabled         =   0   'False
      Height          =   255
      Left            =   3840
      TabIndex        =   16
      Top             =   2040
      Width           =   1575
   End
   Begin VB.CheckBox chkaddlidui 
      Caption         =   "增加离队人员为50个"
      Height          =   255
      Left            =   240
      TabIndex        =   15
      Top             =   2040
      Width           =   2175
   End
   Begin VB.CheckBox chkModifyfightfilename 
      Caption         =   "修改游戏目录中文件名"
      Enabled         =   0   'False
      Height          =   375
      Left            =   4320
      TabIndex        =   14
      Top             =   1680
      Width           =   3015
   End
   Begin VB.CheckBox chkmodifyfight 
      Caption         =   "修改z.dat中fight文件名和文件个数"
      Height          =   255
      Left            =   240
      TabIndex        =   13
      Top             =   1680
      Width           =   3975
   End
   Begin VB.TextBox txtWMP 
      Enabled         =   0   'False
      Height          =   285
      Left            =   6120
      TabIndex        =   12
      Text            =   "Text1"
      Top             =   1320
      Width           =   1695
   End
   Begin VB.TextBox txtWDX 
      Enabled         =   0   'False
      Height          =   285
      Left            =   3480
      TabIndex        =   10
      Text            =   "Text1"
      Top             =   1320
      Width           =   1455
   End
   Begin VB.CheckBox chkModifywar 
      Caption         =   "修改战斗贴图文件名"
      Height          =   255
      Left            =   240
      TabIndex        =   8
      Top             =   1320
      Width           =   2295
   End
   Begin VB.TextBox txtsmp 
      Enabled         =   0   'False
      Height          =   285
      Left            =   6120
      TabIndex        =   7
      Text            =   "Text1"
      Top             =   960
      Width           =   1695
   End
   Begin VB.TextBox txtSDX 
      Enabled         =   0   'False
      Height          =   285
      Left            =   3480
      TabIndex        =   6
      Text            =   "Text1"
      Top             =   960
      Width           =   1455
   End
   Begin VB.CheckBox chkmodifySmp 
      Caption         =   "修改场景贴图文件名"
      Height          =   255
      Left            =   240
      TabIndex        =   3
      Top             =   960
      Width           =   2175
   End
   Begin VB.CheckBox chkgowater 
      Caption         =   "修改水上飘"
      Height          =   255
      Left            =   240
      TabIndex        =   2
      Top             =   240
      Width           =   1335
   End
   Begin VB.CommandButton cmdok 
      Caption         =   "确定"
      Height          =   375
      Left            =   8880
      TabIndex        =   1
      Top             =   240
      Width           =   1335
   End
   Begin VB.CommandButton cmdcancel 
      Caption         =   "取消"
      Height          =   375
      Left            =   8880
      TabIndex        =   0
      Top             =   840
      Width           =   1335
   End
   Begin VB.Label Label13 
      Caption         =   "比例值"
      Height          =   255
      Left            =   2880
      TabIndex        =   50
      Top             =   5280
      Width           =   735
   End
   Begin VB.Label Label12 
      Caption         =   "增加攻击力"
      Height          =   255
      Left            =   8280
      TabIndex        =   47
      Top             =   4800
      Width           =   1095
   End
   Begin VB.Label lblFit 
      Caption         =   "0"
      Height          =   255
      Left            =   4200
      TabIndex        =   44
      Top             =   4800
      Width           =   495
   End
   Begin VB.Label LblLight 
      Caption         =   "0"
      Height          =   255
      Left            =   4200
      TabIndex        =   40
      Top             =   4440
      Width           =   495
   End
   Begin VB.Label Label11 
      Caption         =   "取消选中属性的最大值限制"
      Height          =   255
      Left            =   240
      TabIndex        =   37
      Top             =   2760
      Width           =   4335
   End
   Begin VB.Label Label10 
      Caption         =   "修改时请参考修改器附带的说明文件z_modify.txt"
      ForeColor       =   &H00FF0000&
      Height          =   255
      Left            =   120
      TabIndex        =   32
      Top             =   5760
      Width           =   4455
   End
   Begin VB.Label Label1 
      Caption         =   "总内存"
      Height          =   255
      Left            =   1440
      TabIndex        =   31
      Top             =   600
      Width           =   735
   End
   Begin VB.Label Label2 
      Caption         =   "M1"
      Height          =   255
      Left            =   3600
      TabIndex        =   30
      Top             =   540
      Width           =   375
   End
   Begin VB.Label Label3 
      Caption         =   "M2"
      Height          =   255
      Left            =   5400
      TabIndex        =   29
      Top             =   540
      Width           =   375
   End
   Begin VB.Label Label9 
      Caption         =   "离队事件编号"
      Height          =   255
      Left            =   7800
      TabIndex        =   21
      Top             =   2040
      Width           =   1095
   End
   Begin VB.Label Label8 
      Caption         =   "可离队人员"
      Height          =   255
      Left            =   2520
      TabIndex        =   19
      Top             =   2040
      Width           =   1095
   End
   Begin VB.Label Lblliduiperson 
      Caption         =   "0"
      Height          =   255
      Left            =   5520
      TabIndex        =   18
      Top             =   2040
      Width           =   375
   End
   Begin VB.Label Label7 
      Caption         =   "WMP Name"
      Height          =   255
      Left            =   5040
      TabIndex        =   11
      Top             =   1320
      Width           =   975
   End
   Begin VB.Label Label6 
      Caption         =   "WDX Name"
      Height          =   255
      Left            =   2520
      TabIndex        =   9
      Top             =   1320
      Width           =   975
   End
   Begin VB.Label Label5 
      Caption         =   "SMP Name"
      Height          =   255
      Left            =   5040
      TabIndex        =   5
      Top             =   960
      Width           =   975
   End
   Begin VB.Label Label4 
      Caption         =   "SDX Name"
      Height          =   255
      Left            =   2520
      TabIndex        =   4
      Top             =   960
      Width           =   975
   End
End
Attribute VB_Name = "frmzModify"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Option Explicit

Private zfilenum As Long
'Private zfilename As String

Private ZStart As Long

Const length_filesdx As Long = &HD

Private LiduiPerson(50 - 1) As Byte
Private LightScene(10) As Integer

Private Type WeaponFit_type
    ThingID As Integer
    WugongID As Integer
    AddValue As Integer
End Type

Private WeaponFit(6) As WeaponFit_type

' 读离队人员列表
Private Sub ReadLiduiPerson()
Dim p As Long
Dim tmpbyte As Byte
Dim i As Long
    zfilenum = OpenBin(G_Var.JYPath & G_Var.EXE, "R")
    p = 0
    For i = 0 To 50 - 1
        Get #zfilenum, Get16(ZStart, GetINIStr("ZModify", "LiduiPersonAddr")) + 1 + i, tmpbyte
        If tmpbyte <> 0 Then
            LiduiPerson(p) = tmpbyte
            p = p + 1
        End If
    Next i
    Close zfilenum
End Sub



Private Sub chkaddlidui_Click()
    If chkaddlidui.value = 1 Then
        HScrollPerson.Enabled = True
        Comboperson.Enabled = True
        txtliduishijian.Enabled = True
        HScrollPerson.Min = 0
        HScrollPerson.Max = 49
        Call ReadLiduiPerson
        HScrollPerson.value = 0
        HScrollPerson_Change
    Else
        HScrollPerson.Enabled = False
        Comboperson.Enabled = False
        txtliduishijian.Enabled = False
    End If
End Sub

Private Sub chkfit_Click()
    If chkfit.value = 1 Then
        HScrollFit.Enabled = True
        ComboThing.Enabled = True
        ComboWugong.Enabled = True
        txtFit.Enabled = True
        HScrollFit.Min = 0
        HScrollFit.Max = 6
        Call ReadLiduiPerson
        HScrollFit.value = 0
        HScrollFit_Change
    Else
        HScrollFit.Enabled = False
        ComboThing.Enabled = False
        ComboWugong.Enabled = False
        txtFit.Enabled = False
    End If
End Sub

Private Sub chkgowater_Click()
    If chkgowater.value = 0 Then
        Optwater1.Enabled = False
        Optwater2.Enabled = False
    Else
        Optwater1.Enabled = True
        Optwater2.Enabled = True
    End If
End Sub

Private Sub chkHurt_Click()
    If chkHurt.value = 1 Then
        txtScale.Enabled = True
    Else
        txtScale.Enabled = False
    End If
End Sub

Private Sub chkMemory_Click()
    If chkMemory.value = 0 Then
        txtMemory(0).Enabled = False
        txtMemory(1).Enabled = False
        txtMemory(2).Enabled = False
    Else
        txtMemory(0).Enabled = True
        txtMemory(1).Enabled = True
        txtMemory(2).Enabled = True
    End If
End Sub




Private Sub chkmodifyfight_Click()
    If chkmodifyfight.value = 0 Then
        chkModifyfightfilename.Enabled = False
    Else
        chkModifyfightfilename.Enabled = True
    End If
End Sub








Private Sub chkModifyLifeMax_Click()
    If chkModifyLifeMax.value = 0 Then
        txtlifemax.Enabled = False
    Else
        txtlifemax.Enabled = True
    End If
End Sub

Private Sub chkModifyLight_Click()
    If chkModifyLight.value = 1 Then
        HScrollLight.Enabled = True
        ComboLight.Enabled = True
        HScrollLight.Min = 0
        HScrollLight.Max = 10
        HScrollLight.value = 0
        HScrollLight_Change
    Else
        HScrollLight.Enabled = False
        ComboLight.Enabled = False
       ' ComboLight.ListIndex = -1
    End If

End Sub

Private Sub chkmodifyneilimax_Click()
    If chkmodifyneilimax.value = 0 Then
        txtneilimax.Enabled = False
    Else
        txtneilimax.Enabled = True
    End If
End Sub




Private Sub chkmodifySmp_Click()
    If chkmodifySmp.value = 0 Then
        txtSDX.Enabled = False
        txtsmp.Enabled = False
    Else
        txtSDX.Enabled = True
        txtsmp.Enabled = True
    End If
End Sub


Private Sub chkModifywar_Click()
    If chkModifywar.value = 0 Then
        txtWDX.Enabled = False
        txtWMP.Enabled = False
    Else
        txtWDX.Enabled = True
        txtWMP.Enabled = True
    End If

End Sub





Private Sub cmdcancel_Click()
    Unload Me
End Sub

Private Sub cmdok_Click()
Dim i As Long, j As Long
Dim tmpstr As String
Dim tmpstr2 As String
Dim tmpAddress As Long
Dim tmpValue As Long
Dim tmpstrArray() As String
Dim tmpbyte As Byte
    If MsgBox(LoadResStr(10131), vbYesNo) = vbNo Then Exit Sub
    zfilenum = OpenBin(G_Var.JYPath & G_Var.EXE, "W")
        
        ' 写水上飘设置
        If chkgowater.value = 1 Then
            If Optwater1.value = True Then
                Call ChangeZCode(zfilenum, ZStart, "Zmodify", "WaterYes")
            Else
                Call ChangeZCode(zfilenum, ZStart, "Zmodify", "WaterNo")
            End If
        End If
        ' 写内存分配
        If chkMemory.value = 1 Then
            tmpstrArray = Split(GetINIStr("ZModify", "MemoryAddr"), ",")
            For i = 0 To 2
                Put #zfilenum, Get16(ZStart, tmpstrArray(i)) + 1, CLng(txtMemory(i).Text)
            Next i
        End If
        ' 写sdx，smp文件名
        If chkmodifySmp.value = 1 Then
                tmpstr = Trim(txtSDX.Text)
                Put #zfilenum, Get16(ZStart, GetINIStr("ZModify", "SDXFileNameAddr")) + 1, tmpstr
                Put #zfilenum, , CByte(0)
                tmpstr = Trim(txtsmp.Text)
                Put #zfilenum, Get16(ZStart, GetINIStr("ZModify", "SMPFileNameAddr")) + 1, tmpstr
                Put #zfilenum, , CByte(0)
                tmpstrArray = Split(GetINIStr("ZModify", "S_FileNameLengthAddr"), ",")
                For i = 0 To UBound(tmpstrArray, 1)
                    Put #zfilenum, Get16(ZStart, tmpstrArray(i)) + 1, CByte(0)
                Next i
                
        End If
        ' 写wdx，wmp文件名
        If chkModifywar.value = 1 Then
                tmpstr = Trim(txtWDX.Text)
                Put #zfilenum, Get16(ZStart, GetINIStr("ZModify", "WDXFileNameAddr")) + 1, tmpstr
                Put #zfilenum, , CByte(0)
                tmpstr = Trim(txtWMP.Text)
                Put #zfilenum, Get16(ZStart, GetINIStr("ZModify", "WMPFileNameAddr")) + 1, tmpstr
                Put #zfilenum, , CByte(0)
                tmpstrArray = Split(GetINIStr("ZModify", "W_FileNameLengthAddr"), ",")
                For i = 0 To UBound(tmpstrArray, 1)
                    Put #zfilenum, Get16(ZStart, tmpstrArray(i)) + 1, CByte(0)
                Next i
        End If
        
         ' 写fdx，fmp文件名
         
        If chkmodifyfight.value = 1 Then
        
            Put #zfilenum, Get16(ZStart, GetINIStr("ZModify", "F_FilenameLengthAddr")) + 1, CByte(10)
            For i = 0 To 219
                tmpstr = "fdx" & Format(i, "000")
                If chkModifyfightfilename.value = 1 Then
                    tmpstr2 = "fight" & Format(i, "000") & ".idx"
                    If Dir(G_Var.JYPath & "\" & tmpstr2) <> "" Then
                        If Dir(G_Var.JYPath & "\" & tmpstr) <> "" Then
                            Kill G_Var.JYPath & "\" & tmpstr
                        End If
                        Name G_Var.JYPath & "\" & tmpstr2 As G_Var.JYPath & "\" & tmpstr
                    End If
                End If
                Put #zfilenum, Get16(ZStart, GetINIStr("ZModify", "FDXFileNameAddr")) + 1 + i * 10, tmpstr
                Put #zfilenum, , CByte(0)
                Put #zfilenum, , CByte(0)
                Put #zfilenum, , CByte(0)
                Put #zfilenum, , CByte(0)
                tmpstr = "fmp" & Format(i, "000")
                If chkModifyfightfilename.value = 1 Then
                    tmpstr2 = "fight" & Format(i, "000") & ".grp"
                    If Dir(G_Var.JYPath & "\" & tmpstr2) <> "" Then
                        If Dir(G_Var.JYPath & "\" & tmpstr) <> "" Then
                            Kill G_Var.JYPath & "\" & tmpstr
                        End If
                        Name G_Var.JYPath & "\" & tmpstr2 As G_Var.JYPath & "\" & tmpstr
                    End If
                End If
                Put #zfilenum, Get16(ZStart, GetINIStr("ZModify", "FMPFileNameAddr")) + 1 + i * 10, tmpstr
                Put #zfilenum, , CByte(0)
                Put #zfilenum, , CByte(0)
                Put #zfilenum, , CByte(0)
                Put #zfilenum, , CByte(0)
            Next i
        End If
        
        ' 增加离队人员
        If chkaddlidui.value = 1 Then
            Call ChangeZCode(zfilenum, ZStart, "ZModify", "LiduiChangeData1")
            Call ChangeZCode(zfilenum, ZStart, "ZModify", "LiduiChangeData2")
            Call ChangeZCode(zfilenum, ZStart, "ZModify", "LiduiChangeData3")
            For i = 0 To 50 - 1
                Put #zfilenum, Get16(ZStart, GetINIStr("ZModify", "LiduiPersonAddr")) + 1 + i, LiduiPerson(i)
            Next i
            Put #zfilenum, Get16(ZStart, GetINIStr("ZModify", "LiduiEventAddr")) + 1, CInt(txtliduishijian.Text)
        End If
        
        If chkModifyLifeMax.value = 1 Then
            ' 修改生命最大值
            tmpstrArray = Split(GetINIStr("ZModify", "LifeMaxAddr"), ",")
            For i = 0 To UBound(tmpstrArray, 1)
                 Put #zfilenum, Get16(ZStart, tmpstrArray(i)) + 1, CInt(txtlifemax.Text)
            Next i
        End If
        
        If chkmodifyneilimax.value = 1 Then
            ' 修改内力最大值
            tmpstrArray = Split(GetINIStr("ZModify", "NeiliMaxAddr"), ",")
            For i = 0 To UBound(tmpstrArray, 1)
                 Put #zfilenum, CLng(tmpstrArray(i)) + 1, CInt(txtneilimax.Text)
            Next i
        End If
        
        ' 修改各项属性最大值
        For i = 0 To CLng(GetINIStr("ZModify", "numShuxing")) - 1
            If ListCancel.Selected(i) = True Then
                tmpstrArray = Split(GetINIStr("ZModify", "Shuxing" & i), ",")
                For j = 0 To UBound(tmpstrArray, 1) / 2 - 1
                    Put #zfilenum, Get16(ZStart, tmpstrArray(j * 2 + 1)) + 1, CInt(Get16(ZStart, tmpstrArray(j * 2 + 2)))
                Next j
            End If
        Next i
  
        ' 写亮灯场景
        If chkModifyLight.value = 1 Then
            Put #zfilenum, Get16(ZStart, GetINIStr("ZModify", "LightlistAddr")) + 1, LightScene
        End If
         
        ' 读武功武器配合
        If chkfit.value = 1 Then
            Put #zfilenum, Get16(ZStart, GetINIStr("ZModify", "FitListAddr")) + 1, WeaponFit
        End If
        
        ' 写伤害比例
        If chkHurt.value = 1 Then
            Put #zfilenum, Get16(ZStart, GetINIStr("ZModify", "AddrLifeScale")) + 1, CLng(txtScale.Text)
        End If
        
    Close (zfilenum)

End Sub

Private Sub ComboLight_click()
    If ComboLight.ListIndex >= 0 Then
        LightScene(HScrollLight.value) = ComboLight.ListIndex
    End If
End Sub

Private Sub Comboperson_click()
    If Comboperson.ListIndex >= 0 Then
        LiduiPerson(HScrollPerson.value) = Comboperson.ListIndex
    End If
End Sub

Private Sub ComboThing_click()
    If ComboThing.ListIndex >= 0 Then
        WeaponFit(HScrollFit.value).ThingID = ComboThing.ListIndex
    End If

End Sub

Private Sub ComboWugong_click()
    If ComboWugong.ListIndex >= 0 Then
        WeaponFit(HScrollFit.value).WugongID = ComboWugong.ListIndex
    End If

End Sub

Private Sub Form_Load()
Dim tmp As Integer
Dim tmpbyte As Byte
Dim tmplong As Long
Dim tmpstr As String
Dim i As Long
Dim tmpstrArray() As String

    For i = 0 To Me.Controls.Count - 1
         Call SetCaption(Me.Controls(i))
    Next i

    ZStart = GetZStart()
    
    Comboperson.Clear
    For i = 0 To PersonNum - 1
        If i > 255 Then Exit For
        Comboperson.AddItem i & Person(i).Name1
    Next i
    
    ComboLight.Clear
    For i = 0 To Scenenum - 1
        ComboLight.AddItem i & Big5toUnicode(Scene(i).Name1, 10)
    Next i
    
    ComboThing.Clear
    For i = 0 To Thingsnum - 1
        ComboThing.AddItem i & Things(i).name2
    Next i
    
    ComboWugong.Clear
    For i = 0 To WuGongnum - 1
        ComboWugong.AddItem i & WuGong(i).Name1
    Next i
    
    ListCancel.Clear
    For i = 0 To CLng(GetINIStr("ZModify", "numShuxing")) - 1
        tmpstrArray = Split(GetINIStr("ZModify", "Shuxing" & i), ",")
        ListCancel.AddItem tmpstrArray(0)
    Next i
    

    
    zfilenum = OpenBin(G_Var.JYPath & G_Var.EXE, "R")
        
        
        ' 读内存分配
        tmpstrArray = Split(GetINIStr("ZModify", "MemoryAddr"), ",")
        For i = 0 To 2
            Get #zfilenum, Get16(ZStart, tmpstrArray(i)) + 1, tmplong
            txtMemory(i) = tmplong
        Next i
        
        
        
        ' 读sdx文件名
        tmpstr = String(length_filesdx, " ")
        Get #zfilenum, Get16(ZStart, GetINIStr("ZModify", "SDXFileNameAddr")) + 1, tmpstr
        txtSDX.Text = tmpstr
         ' 读smp文件名
        Get #zfilenum, Get16(ZStart, GetINIStr("ZModify", "SMPFileNameAddr")) + 1, tmpstr
        txtsmp.Text = tmpstr
       
        ' 读wdx文件名
        tmpstr = String(length_filesdx, " ")
        Get #zfilenum, Get16(ZStart, GetINIStr("ZModify", "WDXFileNameAddr")) + 1, tmpstr
        txtWDX.Text = tmpstr
         ' 读wmp文件名
        Get #zfilenum, Get16(ZStart, GetINIStr("ZModify", "WMPFileNameAddr")) + 1, tmpstr
        txtWMP.Text = tmpstr
        
        ' 读离队事件编号
        Get #zfilenum, Get16(ZStart, GetINIStr("ZModify", "LiduiEventAddr")) + 1, tmp
        txtliduishijian.Text = tmp
        
        ' 生命最大值
        tmpstrArray = Split(GetINIStr("ZModify", "LifeMaxAddr"), ",")
        
        Get #zfilenum, Get16(ZStart, tmpstrArray(0)) + 1, tmp
        txtlifemax.Text = tmp
        
        ' 内力最大值
        tmpstrArray = Split(GetINIStr("ZModify", "NeiliMaxAddr"), ",")
        Get #zfilenum, Get16(ZStart, (tmpstrArray(0))) + 1, tmp
        txtneilimax.Text = tmp
        
        ' 读亮灯场景
        Get #zfilenum, Get16(ZStart, GetINIStr("ZModify", "LightlistAddr")) + 1, LightScene
         
        ' 读武功武器配合
        Get #zfilenum, Get16(ZStart, GetINIStr("ZModify", "FitListAddr")) + 1, WeaponFit
        
        ' 读伤害比例
        Get #zfilenum, Get16(ZStart, GetINIStr("ZModify", "AddrLifeScale")) + 1, tmplong
        txtScale.Text = tmplong
    Close (zfilenum)

End Sub

Private Sub HScrollFit_Change()
    ComboThing.ListIndex = WeaponFit(HScrollFit.value).ThingID
    ComboWugong.ListIndex = WeaponFit(HScrollFit.value).WugongID
    txtFit.Text = WeaponFit(HScrollFit.value).AddValue
    lblFit.Caption = HScrollFit.value
End Sub

Private Sub HScrollLight_Change()
    ComboLight.ListIndex = LightScene(HScrollLight.value)
    LblLight.Caption = HScrollLight.value
End Sub

Private Sub HScrollPerson_Change()
    Comboperson.ListIndex = LiduiPerson(HScrollPerson.value)
    Lblliduiperson.Caption = HScrollPerson.value
End Sub

Private Sub txtFit_Change()
    WeaponFit(HScrollFit.value).AddValue = txtFit.Text
End Sub
