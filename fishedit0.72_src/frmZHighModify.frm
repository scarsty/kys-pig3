VERSION 5.00
Begin VB.Form frmZHighModify 
   Caption         =   "Form1"
   ClientHeight    =   4650
   ClientLeft      =   60
   ClientTop       =   345
   ClientWidth     =   7740
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
   ScaleHeight     =   4650
   ScaleWidth      =   7740
   WindowState     =   2  'Maximized
   Begin VB.CheckBox chkAddKdef 
      Caption         =   "增加事件指令"
      Height          =   375
      Left            =   120
      TabIndex        =   18
      Top             =   3960
      Width           =   1815
   End
   Begin VB.CheckBox chkVmode2 
      Caption         =   "修改title,dead,kend等文件"
      Enabled         =   0   'False
      Height          =   255
      Left            =   2280
      TabIndex        =   17
      Top             =   3480
      Visible         =   0   'False
      Width           =   2415
   End
   Begin VB.CheckBox chkVMode 
      Caption         =   "屏幕分辨率640*480"
      Height          =   255
      Left            =   120
      TabIndex        =   16
      Top             =   3480
      Width           =   1935
   End
   Begin VB.TextBox txtWupinAddr 
      Enabled         =   0   'False
      Height          =   285
      Left            =   4200
      TabIndex        =   15
      Top             =   960
      Width           =   975
   End
   Begin VB.TextBox txtDFilelength 
      Enabled         =   0   'False
      Height          =   285
      Left            =   3960
      TabIndex        =   13
      Top             =   2760
      Width           =   1215
   End
   Begin VB.TextBox txtSFilelength 
      Enabled         =   0   'False
      Height          =   285
      Left            =   3960
      TabIndex        =   11
      Top             =   2400
      Width           =   1215
   End
   Begin VB.TextBox txtScenenum 
      Enabled         =   0   'False
      Height          =   285
      Left            =   3960
      TabIndex        =   9
      Top             =   2040
      Width           =   1215
   End
   Begin VB.CheckBox ChkSceneNum 
      Caption         =   "修改实际场景个数"
      Height          =   255
      Left            =   120
      TabIndex        =   7
      Top             =   2040
      Width           =   2535
   End
   Begin VB.CheckBox chkWugong 
      Caption         =   "增加武功容量到361"
      Height          =   255
      Left            =   120
      TabIndex        =   6
      Top             =   1680
      Width           =   2415
   End
   Begin VB.CheckBox chkScene 
      Caption         =   "增加场景容量到315"
      Height          =   255
      Left            =   120
      TabIndex        =   5
      Top             =   1320
      Width           =   2415
   End
   Begin VB.CheckBox chkThing 
      Caption         =   "增加物品容量到344"
      Height          =   255
      Left            =   120
      TabIndex        =   4
      Top             =   960
      Width           =   2415
   End
   Begin VB.CheckBox chkPerson 
      Caption         =   "增加人物容量到720"
      Height          =   255
      Left            =   120
      TabIndex        =   3
      Top             =   600
      Width           =   2415
   End
   Begin VB.CheckBox chkIDX 
      Caption         =   "增加IDX容量到16384"
      Height          =   255
      Left            =   120
      TabIndex        =   2
      Top             =   240
      Width           =   2295
   End
   Begin VB.CommandButton cmdcancel 
      Caption         =   "取消"
      Height          =   375
      Left            =   6240
      TabIndex        =   1
      Top             =   960
      Width           =   1335
   End
   Begin VB.CommandButton cmdok 
      Caption         =   "确定"
      Height          =   375
      Left            =   6240
      TabIndex        =   0
      Top             =   360
      Width           =   1335
   End
   Begin VB.Label Label4 
      Caption         =   "物品贴图起始地址"
      Height          =   255
      Left            =   2640
      TabIndex        =   14
      Top             =   960
      Width           =   1455
   End
   Begin VB.Label Label3 
      Caption         =   "D*文件大小"
      Height          =   255
      Left            =   2760
      TabIndex        =   12
      Top             =   2760
      Width           =   1095
   End
   Begin VB.Label Label2 
      Caption         =   "S*文件大小"
      Height          =   255
      Left            =   2760
      TabIndex        =   10
      Top             =   2400
      Width           =   1095
   End
   Begin VB.Label Label1 
      Caption         =   "场景个数"
      Height          =   255
      Left            =   2760
      TabIndex        =   8
      Top             =   2040
      Width           =   1095
   End
End
Attribute VB_Name = "frmZHighModify"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
 Option Explicit

Private zfilenum As Long
Private zfilename As String

Dim addr_Le As Long

Private StartData() As Byte


Private Type LE_Head_type
    label As String * 2
    b1 As Byte
    b2 As Byte
    formatLevel As Long
    CPUType As Integer
    OSType As Integer
    l1 As Long
    L_10_1 As Long
    PageNumber As Long
    L_18_1 As Long
    L_18_2 As Long
    L_20_1 As Long
    ESP As Long
    PageSize As Long
    LastPageSize As Long
    FixupSize As Long
    L_302 As Long
    LoadSectionSize As Long
    L_382 As Long
    ObjectTableOFfset As Long
    ObjectNumber As Long
    ObjectPageOffset As Long
    L_482 As Long
    ResourceTableOffeset As Long
    L_502 As Long
    ResidentTableOffset As Long
    EntryTableOffset As Long
    L_601 As Long
    L_602 As Long
    FixupPageOffset As Long
    FixupTableOffset As Long
    ImportTableOFfset As Long
    L_702 As Long
    ImportProcOffset As Long
    L_782 As Long
    DataPagesOffset As Long
    L_802 As Long
    L_881 As Long
    L_882 As Long
    L_901 As Long
    L_902 As Long
    L_981 As Long
    L_982 As Long
    L_a01 As Long
    L_a02 As Long
    L_A81 As Long
    
    
End Type

Dim le As LE_Head_type


Private Type ObjectTable_Type
    VirtualSize As Long
    RelocBaseAddr As Long
    ObjectFlags As Long
    PageTableIndex As Long
    PageTableNumber As Long
    tmp As Long
End Type

Dim ObjectTable() As ObjectTable_Type

Private Type FixupRecord_type
    b1 As Byte
    b2 As Byte
    PageOffset As Integer
    Index As Byte
    OffsetLong As Long
    OffsetInt As Integer
    RealPageoffset As Long
End Type
Dim Fixup(20000) As FixupRecord_type
Dim FixupNumber As Long


Private Type ObjectPageTable_type
    D1 As Integer
    D2 As Integer
End Type
Dim ObjectPageTable() As ObjectPageTable_type
Dim Resource() As Byte

Dim FixupPage() As Long

Dim LoadData() As Byte


Private Sub Enlarge_Z()
Dim i As Long, j As Long
Dim PageAdd As Long
Dim tmpstrArray() As String
Dim fixNUM As Long
Dim casm As Collection
Dim newPageFixupnum() As Long
Dim currentFixup As Long
Dim currentPage As Long

    



    PageAdd = GetINILong("AddKdef", "PageAdd")     ' 增加的页数
   
    le.PageNumber = le.PageNumber + PageAdd      ' 页数增加
    le.LastPageSize = le.PageSize                ' 最后页与其它页一样
    
    ObjectTable(1).PageTableNumber = ObjectTable(1).PageTableNumber + PageAdd     ' 第二个Object的页数增加
    
    ReDim Preserve ObjectPageTable(le.PageNumber - 1)     ' 重定义ObjectPage表
    
    For i = 0 To PageAdd - 1    ' ObjectPage表数据
        ObjectPageTable(le.PageNumber - 1 - i).D1 = 0
        ObjectPageTable(le.PageNumber - 1 - i).D2 = le.PageNumber - i
    Next i
    
    ' 重新增加偏移，因增加了ObjectPage
    le.ResourceTableOffeset = le.ResourceTableOffeset + 4 * PageAdd
    le.ResidentTableOffset = le.ResidentTableOffset + 4 * PageAdd
    le.EntryTableOffset = le.EntryTableOffset + 4 * PageAdd
    le.FixupPageOffset = le.FixupPageOffset + 4 * PageAdd
    
    ' 增加两倍偏移，因又增加了FixupPageOffset
    le.FixupTableOffset = le.FixupTableOffset + 4 * PageAdd + 4 * PageAdd
    
    ReDim Preserve FixupPage(le.PageNumber)
    
    fixNUM = 200
    For i = 0 To PageAdd - 1   ' 增加fixup页
        FixupPage(le.PageNumber - PageAdd + i + 1) = FixupPage(le.PageNumber - PageAdd) + 9 * fixNUM * (i + 1)
    Next i
    FixupNumber = FixupNumber + fixNUM * PageAdd
    'ReDim Fixup(FixupNumber - 1)
    
    For i = 0 To PageAdd * fixNUM - 1   ' 新的fix初始值
        Fixup(FixupNumber - fixNUM * PageAdd + i).b1 = &H7
        Fixup(FixupNumber - fixNUM * PageAdd + i).b2 = &H10
        Fixup(FixupNumber - fixNUM * PageAdd + i).PageOffset = 0
        Fixup(FixupNumber - fixNUM * PageAdd + i).Index = 2
        Fixup(FixupNumber - fixNUM * PageAdd + i).OffsetLong = 0
    Next i
    
    
    le.ImportProcOffset = le.ImportProcOffset + 4 * PageAdd + 4 * PageAdd + 9 * fixNUM * PageAdd
    le.ImportTableOFfset = le.ImportProcOffset
    le.DataPagesOffset = &H1F000
    le.FixupSize = le.ImportProcOffset - le.FixupPageOffset + 1
    le.LoadSectionSize = le.ImportProcOffset - le.ObjectTableOFfset + 1
        
    ReDim Preserve LoadData((le.PageNumber - 1) * le.PageSize + le.LastPageSize - 1)
    
    
    
    Call ReadAsm("addkdef.txt", le.DataPagesOffset, le.PageSize, casm)
    
    
    If PageAdd > 0 Then
        ReDim newPageFixupnum(PageAdd - 1)
        
        For i = 0 To PageAdd - 1
            newPageFixupnum(i) = 0
        Next i
        For i = 1 To casm.Count
            If casm(i).Style = 2 Or casm(i).Style = 6 Then
                currentPage = casm(i).PageNum - le.PageNumber + PageAdd - 1
                currentFixup = FixupNumber - fixNUM * PageAdd + currentPage * fixNUM + newPageFixupnum(currentPage)
                Fixup(currentFixup).PageOffset = casm(i).PageOffset
                Fixup(currentFixup).OffsetLong = casm(i).Fixup
                newPageFixupnum(currentPage) = newPageFixupnum(currentPage) + 1
                If newPageFixupnum(currentPage) > fixNUM Then
                    MsgBox "fixup > fixupmax"
                End If
            End If
        Next i
    End If
    
    For i = 1 To casm.Count
        If casm(i).Style <> 0 Then
            For j = 0 To casm(i).num - 1
                LoadData(casm(i).Address + j - CLng(&H1F000)) = casm(i).Data(j)
            Next j
        End If
    Next i
    
    
    
End Sub



Private Sub Load_Fixup()
Dim i As Long, j As Long
Dim fixoffset As Long
Dim PageStart As Long, pageEnd As Long
Dim fileout As Long
Dim offset As Long
Dim tmplong As Long
    zfilenum = OpenBin(G_Var.JYPath & G_Var.EXE, "R")
    
    Get #zfilenum, &H3C + 1, addr_Le
    
    ReDim StartData(addr_Le - 1)
    Get #zfilenum, 1, StartData
    
    Get #zfilenum, addr_Le + 1, le
    
    ReDim ObjectTable(le.ObjectNumber - 1)
    
    Get #zfilenum, addr_Le + 1 + le.ObjectTableOFfset, ObjectTable
    
     ReDim ObjectPageTable(le.PageNumber - 1)
    
    Get #zfilenum, addr_Le + 1 + le.ObjectPageOffset, ObjectPageTable
    
    ReDim Resource(le.FixupPageOffset - le.ResourceTableOffeset - 1)
    
    Get #zfilenum, addr_Le + 1 + le.ResourceTableOffeset, Resource
    
    ReDim FixupPage(le.PageNumber)
    
    Get #zfilenum, addr_Le + 1 + le.FixupPageOffset, FixupPage
    
    
'    读取fixup记录
    
    i = 0
    
    'fileout = OpenBin(G_Var.JYPath & "Fixup.txt", "WN")
    'fileout = FreeFile()
   ' Open App.Path & "\fixup.txt" For Output As #fileout
    For j = 0 To le.PageNumber - 1
        PageStart = FixupPage(j)
        pageEnd = FixupPage(j + 1)
        offset = PageStart
        Do
            If offset >= pageEnd Then Exit Do
            Get #zfilenum, offset + addr_Le + 1 + le.FixupTableOffset, Fixup(i).b1
            Get #zfilenum, , Fixup(i).b2
            If Fixup(i).b2 = &H10 Then
                Get #zfilenum, , Fixup(i).PageOffset
                Get #zfilenum, , Fixup(i).Index
                Get #zfilenum, , Fixup(i).OffsetLong
                offset = offset + 9
            Else
                Get #zfilenum, , Fixup(i).PageOffset
                Get #zfilenum, , Fixup(i).Index
                Get #zfilenum, , Fixup(i).OffsetInt
                offset = offset + 7
            End If
            Fixup(i).RealPageoffset = Fixup(i).PageOffset + le.DataPagesOffset + j * le.PageSize
            i = i + 1
            Get #zfilenum, Fixup(i).RealPageoffset + 1, tmplong
            'Print #fileout, j, i, Hex(Fixup(i).PageOffset), Hex(Fixup(i).RealPageoffset), Hex(Fixup(i).OffsetLong), Hex(Fixup(i).OffsetInt), Hex(tmplong)
        Loop
    Next j
'

    FixupNumber = i
   
       
    ReDim LoadData((le.PageNumber - 1) * le.PageSize + le.LastPageSize - 1)
    
    Get #zfilenum, le.DataPagesOffset + 1, LoadData
    
    Close #zfilenum
    'Close #fileout
End Sub


Private Sub ChkSceneNum_Click()
    If ChkSceneNum.value = 1 Then
        txtScenenum.Enabled = True
        txtDFilelength.Enabled = True
        txtSFilelength.Enabled = True
    Else
        txtScenenum.Enabled = False
        txtDFilelength.Enabled = False
        txtSFilelength.Enabled = False
    End If
End Sub

Private Sub chkThing_Click()
    txtWupinAddr.Enabled = IIf(chkThing.value = 1, True, False)
End Sub



Private Sub chkVMode_Click()
    If chkVMode.value = 1 Then
        chkVmode2.Enabled = True
    Else
        chkVmode2.Enabled = False
    End If
End Sub


Private Sub cmdcancel_Click()
    Unload Me
End Sub



Private Sub cmdok_Click()
Dim i As Long
Dim offset As Long
Dim tmpstrArray() As String
Dim NewSP As Long
    If MsgBox(LoadResStr(10131), vbYesNo) = vbNo Then Exit Sub
        
    NewSP = CLng(GetINIStr("HighLevelZModify", "NewSP"))
        
   
    If chkAddKdef.value = 1 Then

        le.ESP = NewSP
        ObjectTable(1).VirtualSize = NewSP
        Call ChangeFixup("Other")
        Call Enlarge_Z

    End If
    
    
    
    
   
    zfilenum = OpenBin(G_Var.JYPath & "z.dat.new", "WN")
    Put #zfilenum, , StartData
    Put #zfilenum, , le
    Put #zfilenum, le.ObjectTableOFfset + 1 + addr_Le, ObjectTable
    Put #zfilenum, , ObjectPageTable
    Put #zfilenum, , Resource
    Put #zfilenum, , FixupPage
    
    For i = 0 To FixupNumber - 1
            Put #zfilenum, , Fixup(i).b1
            Put #zfilenum, , Fixup(i).b2
            If Fixup(i).b2 = &H10 Then
                Put #zfilenum, , Fixup(i).PageOffset
                Put #zfilenum, , Fixup(i).Index
                Put #zfilenum, , Fixup(i).OffsetLong
            Else
                Put #zfilenum, , Fixup(i).PageOffset
                Put #zfilenum, , Fixup(i).Index
                Put #zfilenum, , Fixup(i).OffsetInt
            End If
    Next i
    
    Put #zfilenum, le.DataPagesOffset + 1, LoadData
    
    
    Close #zfilenum

End Sub

Private Sub cmdok_Click_1()
Dim i As Long
Dim offset As Long
Dim tmpstrArray() As String
Dim SpAddr1 As Long
Dim SpAddr2 As Long
Dim NewSP As Long
    If MsgBox(LoadResStr(10131), vbYesNo) = vbNo Then Exit Sub
        
        ' 修改IDX
        
    SpAddr1 = CLng(GetINIStr("HighLevelZModify", "SPAddr1"))
    SpAddr2 = CLng(GetINIStr("HighLevelZModify", "SPAddr2"))
    NewSP = CLng(GetINIStr("HighLevelZModify", "NewSP"))
        
    ' 增加idx容量
    If chkIDX.value = 1 Then
        Call ChangeFixup("IDX")
    End If
    ' 增加人物容量
    If chkPerson.value = 1 Then
        Call ChangeFixup("Person")
    End If
    
    ' 增加物品容量
    If chkThing.value = 1 Then
        Call ChangeFixup("Wupin")
    End If
    
    ' 增加场景容量
    If chkScene.value = 1 Then
        Call ChangeFixup("Changjing")
    End If
    
    ' 增加武功容量
    If chkWugong.value = 1 Then
        Call ChangeFixup("Wugong")
    End If
    
    
    ' 修改屏幕分辨率
    If chkVMode.value = 1 Then
        Call ChangeFixup("VRAM")
        Call ChangeFixup("Other")
        
        If chkVmode2.value = 1 Then
            Call ModifyTitle
        End If
    End If
   
   
    If chkAddKdef.value = 1 Then
        Call ChangeFixup("Other")
        Call Enlarge_Z
    
    End If
    
   
    zfilenum = OpenBin(G_Var.JYPath & "z.dat.new", "WN")
    Put #zfilenum, , StartData
    Put #zfilenum, , le
    Put #zfilenum, le.ObjectTableOFfset + 1 + addr_Le, ObjectTable
    Put #zfilenum, , ObjectPageTable
    Put #zfilenum, , Resource
    Put #zfilenum, , FixupPage
    
    For i = 0 To FixupNumber - 1
            Put #zfilenum, , Fixup(i).b1
            Put #zfilenum, , Fixup(i).b2
            If Fixup(i).b2 = &H10 Then
                Put #zfilenum, , Fixup(i).PageOffset
                Put #zfilenum, , Fixup(i).Index
                Put #zfilenum, , Fixup(i).OffsetLong
            Else
                Put #zfilenum, , Fixup(i).PageOffset
                Put #zfilenum, , Fixup(i).Index
                Put #zfilenum, , Fixup(i).OffsetInt
            End If
    Next i
    
    Put #zfilenum, le.DataPagesOffset + 1, LoadData
    
    
    Close #zfilenum
   
   
   
    zfilenum = OpenBin(G_Var.JYPath & "z.dat.new", "W")
    Put #zfilenum, SpAddr1 + 1, NewSP
    Put #zfilenum, SpAddr2 + 1, NewSP
    
    
    Put #zfilenum, CLng(GetINIStr("HighLevelZModify", "WupinPicAddr")) + 1, CInt(txtWupinAddr.Text)
    
    
    Put #zfilenum, CLng(GetINIStr("HighLevelZModify", "ChangjingNumAddr")) + 1, CLng(txtScenenum.Text)
    
    tmpstrArray = Split(GetINIStr("HighLevelZModify", "SFileLengthAddr"), ",")
    For i = 0 To UBound(tmpstrArray, 1)
        Put #zfilenum, CLng(tmpstrArray(i)) + 1, CLng(txtSFilelength.Text / 2)
    Next i
    tmpstrArray = Split(GetINIStr("HighLevelZModify", "DFileLengthAddr"), ",")
    For i = 0 To UBound(tmpstrArray, 1)
        Put #zfilenum, CLng(tmpstrArray(i)) + 1, CLng(txtDFilelength.Text)
    Next i
    
    
    If chkVMode.value = 1 Then
        Put #zfilenum, CLng(GetINIStr("HighLevelZModify", "AddAddr")) + 1, CLng(GetINIStr("HighLevelZModify", "AddValue"))
        Put #zfilenum, CLng(GetINIStr("HighLevelZModify", "AddNumber")) + &H53CB1, CByte(0)
    
        Put #zfilenum, CLng(GetINIStr("HighLevelZModify", "LastAddr")) + 1, CLng(GetINIStr("HighLevelZModify", "LastValue"))
    
        tmpstrArray = Split(GetINIStr("VideoMode", "VMode"), ",")
        Put #zfilenum, CLng(tmpstrArray(0)) + 1, CInt(tmpstrArray(1))
        Put #zfilenum, CLng(tmpstrArray(2)) + 1, CInt(tmpstrArray(3))
        
        tmpstrArray = Split(GetINIStr("VideoMode", "VCode1"), ",")
        For i = 1 To UBound(tmpstrArray, 1)
            Put #zfilenum, CLng(tmpstrArray(0)) + i, CByte(tmpstrArray(i))
        Next i
        tmpstrArray = Split(GetINIStr("VideoMode", "VCode2"), ",")
        For i = 1 To UBound(tmpstrArray, 1)
            Put #zfilenum, CLng(tmpstrArray(0)) + i, CByte(tmpstrArray(i))
        Next i
        
        
        
        tmpstrArray = Split(GetINIStr("VideoMode", "AddrVWidth"), ",")
        For i = 0 To UBound(tmpstrArray, 1)
            Put #zfilenum, CLng(tmpstrArray(i)) + 1, CInt(640)
        Next i
        tmpstrArray = Split(GetINIStr("VideoMode", "AddrVWidth2"), ",")
        For i = 0 To UBound(tmpstrArray, 1)
            Put #zfilenum, CLng(tmpstrArray(i)) + 1, CInt(640)
        Next i
        tmpstrArray = Split(GetINIStr("VideoMode", "AddrVHeight"), ",")
        For i = 0 To UBound(tmpstrArray, 1)
            Put #zfilenum, CLng(tmpstrArray(i)) + 1, CInt(480)
        Next i
        
        tmpstrArray = Split(GetINIStr("VideoMode", "AddrVLarge"), ",")
        For i = 0 To UBound(tmpstrArray, 1)
            Put #zfilenum, CLng(tmpstrArray(i)) + 1, CLng(GetINIStr("VideoMode", "VLarge"))
        Next i
        
        tmpstrArray = Split(GetINIStr("VideoMode", "AddrStr"), ",")
        For i = 0 To UBound(tmpstrArray, 1)
            Put #zfilenum, CLng(tmpstrArray(i)) + 1, CLng(GetINIStr("VideoMode", "VStr"))
        Next i
        
        tmpstrArray = Split(GetINIStr("VideoMode", "AddrStr2"), ",")
        For i = 0 To UBound(tmpstrArray, 1)
            Put #zfilenum, CLng(tmpstrArray(i)) + 1, CLng(GetINIStr("VideoMode", "VStr2"))
        Next i
        
        tmpstrArray = Split(GetINIStr("VideoMode", "AddrVMmap1"), ",")
        For i = 0 To UBound(tmpstrArray, 1)
            Put #zfilenum, CLng(tmpstrArray(i)) + 1, CByte(&HB + 10)
        Next i
        tmpstrArray = Split(GetINIStr("VideoMode", "AddrVMmap2"), ",")
        For i = 0 To UBound(tmpstrArray, 1)
            Put #zfilenum, CLng(tmpstrArray(i)) + 1, CByte(&H15 + 5)
        Next i
        tmpstrArray = Split(GetINIStr("VideoMode", "AddrVMmap3"), ",")
        For i = 0 To UBound(tmpstrArray, 1)
            Put #zfilenum, CLng(tmpstrArray(i)) + 1, CByte(&HA + 10)
        Next i
        
        Call ChangeCode(zfilenum, "VideoMode", "VMMAPCode1")
        Call ChangeCode(zfilenum, "VideoMode", "VMMAPCode1_1")
        Call ChangeCode(zfilenum, "VideoMode", "VMMAPCode1_2")
        Call ChangeCode(zfilenum, "VideoMode", "VMMAPCode1_3")
        
        Call ChangeCode(zfilenum, "VideoMode", "VPersonCode1")
        Call ChangeCode(zfilenum, "VideoMode", "VPersonCode2")
        
       
        Call ChangeCode(zfilenum, "VideoMode", "AddrSmap1_1")
        Call ChangeCode(zfilenum, "VideoMode", "AddrSmap1_2")
        Call ChangeCode(zfilenum, "VideoMode", "AddrSmap1_3")
        Call ChangeCode(zfilenum, "VideoMode", "AddrSmap1_4")
        Call ChangeCode(zfilenum, "VideoMode", "AddrSmap1_5")
        Call ChangeCode(zfilenum, "VideoMode", "AddrSmap1_6")
        Call ChangeCode(zfilenum, "VideoMode", "AddrSmap2_1")
        Call ChangeCode(zfilenum, "VideoMode", "AddrSmap2_2")
        
        

        tmpstrArray = Split(GetINIStr("VideoMode", "AddrSmap1"), ",")
        For i = 0 To UBound(tmpstrArray, 1)
            Put #zfilenum, CLng(tmpstrArray(i)) + 1, CByte(&HB + 9)
        Next i
        tmpstrArray = Split(GetINIStr("VideoMode", "AddrSmap2"), ",")
        For i = 0 To UBound(tmpstrArray, 1)
            Put #zfilenum, CLng(tmpstrArray(i)) + 1, CByte(&HF5 - 9)
        Next i


        tmpstrArray = Split(GetINIStr("VideoMode", "AddrSmap3"), ",")
        For i = 0 To UBound(tmpstrArray, 1)
            Put #zfilenum, CLng(tmpstrArray(i)) + 1, CByte(&H1C + 18)
        Next i
        
        tmpstrArray = Split(GetINIStr("VideoMode", "AddrSmap4"), ",")
        For i = 0 To UBound(tmpstrArray, 1)
            Put #zfilenum, CLng(tmpstrArray(i)) + 1, CByte(&H24 - 18)
        Next i
        
        tmpstrArray = Split(GetINIStr("VideoMode", "AddrSmapnew"), ",")
        For i = 0 To UBound(tmpstrArray, 1)
            Put #zfilenum, CLng(tmpstrArray(i)) + 1, CByte(0)
        Next i

        
        tmpstrArray = Split(GetINIStr("VideoMode", "AddrWmap1"), ",")
        For i = 0 To UBound(tmpstrArray, 1)
            Put #zfilenum, CLng(tmpstrArray(i)) + 1, CByte(&HB + 9)
        Next i
        tmpstrArray = Split(GetINIStr("VideoMode", "AddrWmap2"), ",")
        For i = 0 To UBound(tmpstrArray, 1)
            Put #zfilenum, CLng(tmpstrArray(i)) + 1, CByte(&H20 - 18)
        Next i


        tmpstrArray = Split(GetINIStr("VideoMode", "AddrWmap3"), ",")
        For i = 0 To UBound(tmpstrArray, 1)
            Put #zfilenum, CLng(tmpstrArray(i)) + 1, CByte(&H20 + 18)
        Next i

        Call ChangeCode(zfilenum, "VideoMode", "Addrwmap1_1")
        Call ChangeCode(zfilenum, "VideoMode", "Addrwmap1_2")
        Call ChangeCode(zfilenum, "VideoMode", "Addrwmap1_3")
        Call ChangeCode(zfilenum, "VideoMode", "Addrwmap1_4")
        
        Call ChangeCode(zfilenum, "VideoMode", "Addrwmap2_1")
        Call ChangeCode(zfilenum, "VideoMode", "Addrwmap2_2")
        
        Call ChangeCode(zfilenum, "VideoMode", "Addrwmap3_1")
        Call ChangeCode(zfilenum, "VideoMode", "Addrwmap3_2")
        Call ChangeCode(zfilenum, "VideoMode", "Addrwmap3_3")
        Call ChangeCode(zfilenum, "VideoMode", "Addrwmap3_4")
        
        Call ChangeCode(zfilenum, "VideoMode", "Addrwmap4_1")
        Call ChangeCode(zfilenum, "VideoMode", "Addrwmap4_2")
        Call ChangeCode(zfilenum, "VideoMode", "Addrwmap4_3")
        Call ChangeCode(zfilenum, "VideoMode", "Addrwmap4_4")
        Call ChangeCode(zfilenum, "VideoMode", "Addrwmap4_5")
        Call ChangeCode(zfilenum, "VideoMode", "Addrwmap4_6")
        
        
    End If
    
            
    Close zfilenum
End Sub


Private Sub ChangeCode(fileid As Long, INISection As String, INIstr As String)
Dim tmpstrArray() As String
Dim i As Long
        tmpstrArray = Split(GetINIStr(INISection, INIstr), ",")
        For i = 1 To UBound(tmpstrArray, 1)
            Put #fileid, CLng(tmpstrArray(0)) + i, CByte(tmpstrArray(i))
        Next i
        
End Sub

Private Sub ChangeFixup(Str1 As String)
Dim tmpstr() As String
Dim MinAddr As Long
Dim MaxAddr As Long
Dim newAddr As Long
Dim i As Long
Dim k As Long
Dim addr As Long
Dim BaseAddr As Long
Dim filenum As Long
    tmpstr = Split(GetINIStr("HighLevelZModify", Str1 & "AddrRange"), ",")
    newAddr = CLng(GetINIStr("HighLevelZModify", Str1 & "NewAddr"))
    MinAddr = CLng(tmpstr(0))
    MaxAddr = CLng(tmpstr(1))
    filenum = FreeFile
'    Open App.Path & "\fixupChange.txt" For Output As #filenum
    For i = 0 To FixupNumber
        If Fixup(i).OffsetLong >= MinAddr And Fixup(i).OffsetLong < MaxAddr Then
 '           Print #filenum, Hex(Fixup(i).OffsetLong)
            Fixup(i).OffsetLong = Fixup(i).OffsetLong - MinAddr + newAddr
        End If
    Next i
  '  Close #filenum
End Sub

Private Sub Command1_Click()

End Sub

Private Sub Form_Load()
Dim tmplong As Long
Dim tmpInt As Integer
Dim tmpstrArray() As String
Dim i As Long
    Me.Caption = LoadResStr(222)
    For i = 0 To Me.Controls.Count - 1
        Call SetCaption(Me.Controls(i))
    Next i

    Load_Fixup
    
    zfilenum = OpenBin(G_Var.JYPath & G_Var.EXE, "R")
    
    Get #zfilenum, CLng(GetINIStr("HighLevelZModify", "ChangjingNumAddr")) + 1, tmplong
    txtScenenum.Text = tmplong
    
    tmpstrArray = Split(GetINIStr("HighLevelZModify", "SFileLengthAddr"), ",")
    Get #zfilenum, CLng(tmpstrArray(0)) + 1, tmplong
    txtSFilelength.Text = tmplong * 2
    
    tmpstrArray = Split(GetINIStr("HighLevelZModify", "DFileLengthAddr"), ",")
    Get #zfilenum, CLng(tmpstrArray(0)) + 1, tmplong
    txtDFilelength.Text = tmplong
    
    Get #zfilenum, CLng(GetINIStr("HighLevelZModify", "WupinPicAddr")) + 1, tmpInt
    txtWupinAddr.Text = tmpInt
    
    
    Close #zfilenum
End Sub


' 修改title,dead,kend 文件为640*480
Private Sub ModifyTitle()
    

End Sub


' 读取asm指令，并处理为指定测试
' filename asm文件名
' Startaddr z.dat 指令区起始地址
' SectionSize z.dat每个section的大小
' casm 返回的集合

Private Sub ReadAsm(ByVal filename As String, ByVal StartAddr As Long, ByVal SectionSize As Long, casm As Collection)
Dim fileid As Long
Dim tmpinput As String
Dim i As Long, j As Long
Dim currentAddr As Long
Dim currentSection As Long
Dim tmparray() As String
Dim sectionNum As Long
Dim asm As clsX86
Dim tmpHex As String
    Set casm = New Collection
    
    fileid = FreeFile()
    Open App.Path & "\" & filename For Input Access Read As #fileid
    currentAddr = 0                            ' 当前地址
    Do
        Line Input #fileid, tmpinput           ' 读入一行
        tmpinput = Trim(tmpinput)              ' 去掉空格
        i = InStr(1, tmpinput, ";")            ' ";"的位置
        If i = 0 Then
            tmpinput = tmpinput                ' 没有分号
        ElseIf i = 1 Then
            tmpinput = ""                      ' 第一个字符是分号
        Else
            tmpinput = Mid(tmpinput, 1, i - 1) ' 有分号
        End If
        tmpinput = LCase(tmpinput)             ' 变成小写
        tmpinput = SubSpace(tmpinput)              ' 去掉空格
        If tmpinput <> "" Then
            If tmpinput = "end" Then
                Exit Do
            End If
            tmparray = Split(tmpinput)
            If tmparray(0) = "section" Then         ' Section开始，重新计算起始偏移
                sectionNum = CLng(tmparray(1))
                currentAddr = StartAddr + (sectionNum - 1) * SectionSize
                currentSection = sectionNum
            ElseIf tmparray(0) = "start" Then
                currentAddr = CLng("&h" & tmparray(1))
                currentSection = (currentAddr - StartAddr) / SectionSize + 1
            Else
                Set asm = New clsX86
                asm.Str = tmpinput
                asm.Address = currentAddr
                asm.PageNum = currentSection
                If Mid(tmparray(0), 1, 1) = ":" Then    ' label 语句
                    asm.Style = 0
                    asm.label = Mid(tmparray(0), 2)
                Else
                    asm.num = 0
                    asm.Style = 1
                    For i = 0 To UBound(tmparray)
                        Select Case Mid(tmparray(i), 1, 1)
                        Case "*"    'fixup
                            asm.Style = 2
                            asm.offset = i
                            asm.Fixup = CLng("&h" & Mid(tmparray(i), 2)) - CLng(&H20000)
                            asm.PageOffset = asm.Address + asm.offset - StartAddr - (sectionNum - 1) * SectionSize
                            tmpHex = String(8 - Len(tmparray(i)) + 1, "0") & Mid(tmparray(i), 2)
                            asm.Data(asm.num) = CLng("&h" & Mid(tmpHex, 7, 2))
                            asm.num = asm.num + 1
                            asm.Data(asm.num) = CLng("&h" & Mid(tmpHex, 5, 2))
                            asm.num = asm.num + 1
                            asm.Data(asm.num) = CLng("&h" & Mid(tmpHex, 3, 2))
                            asm.num = asm.num + 1
                            asm.Data(asm.num) = CLng("&h" & Mid(tmpHex, 1, 2))
                            asm.num = asm.num + 1
                        Case "'"   ' 短跳转
                            asm.Style = 3
                            asm.offset = i
                            asm.Data(asm.num) = 0
                            asm.num = asm.num + 1
                            asm.label = Mid(tmparray(i), 2)
                        Case """"    ' 长跳转
                            asm.Style = 4
                            asm.offset = i
                            asm.Data(asm.num) = 0
                            asm.num = asm.num + 4
                            asm.label = Mid(tmparray(i), 2)
                        Case "&"        ' 长地址跳转
                            asm.Style = 5
                            asm.offset = i
                            tmpHex = Hex(CLng("&h" & Mid(tmparray(i), 2)) - (asm.Address + asm.num + 4))
                            tmpHex = String(8 - Len(tmpHex), "0") & tmpHex
                            asm.Data(asm.num) = CLng("&h" & Mid(tmpHex, 7, 2))
                            asm.num = asm.num + 1
                            asm.Data(asm.num) = CLng("&h" & Mid(tmpHex, 5, 2))
                            asm.num = asm.num + 1
                            asm.Data(asm.num) = CLng("&h" & Mid(tmpHex, 3, 2))
                            asm.num = asm.num + 1
                            asm.Data(asm.num) = CLng("&h" & Mid(tmpHex, 1, 2))
                            asm.num = asm.num + 1
                        Case "#"    '标号fixup
                            asm.Style = 6
                            asm.offset = i
                            asm.label = Mid(tmparray(i), 2)
                            asm.PageOffset = asm.Address + asm.offset - StartAddr - (sectionNum - 1) * SectionSize
                            asm.num = asm.num + 4
                        Case Else        ' 普通指令
                            asm.Data(asm.num) = CLng("&h" & tmparray(i))
                            asm.num = asm.num + 1
                        End Select
                    Next i
                    currentAddr = currentAddr + asm.num
                End If
                casm.Add asm
            End If
        End If
    Loop

    Close #fileid


   For i = 1 To casm.Count
       Select Case casm(i).Style
       Case 3  '短跳转
           For j = 1 To casm.Count
               If casm(j).Style = 0 Then
                   If casm(j).label = casm(i).label Then
                       tmpHex = Hex(CInt((casm(j).Address - casm(i).offset - 1 - casm(i).Address) * 256))
                       tmpHex = String(4 - Len(tmpHex), "0") & tmpHex
                       casm(i).Data(casm(i).offset) = CLng("&h" & Mid(tmpHex, 1, 2))
                       Exit For
                   End If
               End If
           Next j
       Case 4   '长跳转
           For j = 1 To casm.Count
               If casm(j).Style = 0 Then
                   If casm(j).label = casm(i).label Then
                       tmpHex = Hex(casm(j).Address - casm(i).offset - 4 - casm(i).Address)
                       tmpHex = String(8 - Len(tmpHex), "0") & tmpHex
                       casm(i).Data(casm(i).offset) = CLng("&h" & Mid(tmpHex, 7, 2))
                       casm(i).Data(casm(i).offset + 1) = CLng("&h" & Mid(tmpHex, 5, 2))
                       casm(i).Data(casm(i).offset + 2) = CLng("&h" & Mid(tmpHex, 3, 2))
                       casm(i).Data(casm(i).offset + 3) = CLng("&h" & Mid(tmpHex, 1, 2))
                       Exit For
                   End If
               End If
           Next j
       Case 6   '标号fixup
           For j = 1 To casm.Count
               If casm(j).Style = 0 Then
                   If casm(j).label = casm(i).label Then
                       casm(i).Fixup = casm(j).Address - CLng(&H20000)
                       tmpHex = Hex(casm(i).Fixup)
                       tmpHex = String(8 - Len(tmpHex), "0") & tmpHex
                       casm(i).Data(casm(i).offset) = CLng("&h" & Mid(tmpHex, 7, 2))
                       casm(i).Data(casm(i).offset + 1) = CLng("&h" & Mid(tmpHex, 5, 2))
                       casm(i).Data(casm(i).offset + 2) = CLng("&h" & Mid(tmpHex, 3, 2))
                       casm(i).Data(casm(i).offset + 3) = CLng("&h" & Mid(tmpHex, 1, 2))
                       Exit For
                   End If
               End If
           Next j
       End Select

   Next i




    fileid = FreeFile()
    Open App.Path & "\" & "addkdef.out" For Output Access Write As #fileid
    For i = 1 To casm.Count
        Print #fileid, casm(i).Style, casm(i).offset, casm(i).num, casm(i).label, Hex(casm(i).Address)
        Print #fileid, Hex(casm(i).Fixup), Hex(casm(i).PageOffset)
        For j = 0 To casm(i).num - 1
            Print #fileid, Hex(casm(i).Data(j)),
        Next j
        Print #fileid,
    Next i
    Close #fileid
End Sub
