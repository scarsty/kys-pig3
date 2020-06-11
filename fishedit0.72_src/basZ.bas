Attribute VB_Name = "basZ"
Option Explicit




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




Private Type ObjectTable_Type
    VirtualSize As Long
    RelocBaseAddr As Long
    ObjectFlags As Long
    PageTableIndex As Long
    PageTableNumber As Long
    tmp As Long
End Type


Private Type FixupRecord_type
    b1 As Byte
    b2 As Byte
    PageOffset As Integer
    Index As Byte
    OffsetLong As Long
    OffsetInt As Integer
    RealPageoffset As Long
End Type

Private Type ObjectPageTable_type
    D1 As Integer
    D2 As Integer
End Type



' 得到程序段起始地址
Public Function GetZStart() As Long
Dim zfilenum As Long
Dim addr_Le As Long
Dim le As LE_Head_type
    zfilenum = OpenBin(G_Var.JYPath & G_Var.EXE, "R")
    
    Get #zfilenum, &H3C + 1, addr_Le
    Get #zfilenum, addr_Le + 1, le
    GetZStart = le.DataPagesOffset + le.PageSize
    Close #zfilenum
End Function



' 改变代码
' fileid 打开的z.dat文件句柄
' Base 要写的基地址   即程序起始段地址，后面的位置信息是按照load后的地址20000,
' INIsection Inistr Ini信息
'   格式为： 第一个字符串为位置信息，后面依次为要修改的字节内容。注意都为16进制，前面没有前导符

Public Sub ChangeZCode(fileid As Long, base As Long, INISection As String, INIstr As String)
Dim tmpstrArray() As String
Dim i As Long
        tmpstrArray = Split(GetINIStr(INISection, INIstr), ",")
        For i = 0 To UBound(tmpstrArray, 1)
            tmpstrArray(i) = "&h" & Trim(tmpstrArray(i))
        Next i
        For i = 1 To UBound(tmpstrArray, 1)
            Put #fileid, CLng(tmpstrArray(0)) - &H20000 + base + i, CByte(tmpstrArray(i))
        Next i
End Sub



Public Function Get16(base As Long, Str As String) As Long
    Get16 = CLng("&h" & Trim(Str)) + base - &H20000
End Function


 

Public Function ReadZValue(fileid As Long, INISection As String, INIstr As String) As Long
Dim tmpstrArray() As String
Dim tmpbyte As Byte
Dim tmpInt As Integer
Dim tmplong As Long
    tmpstrArray = Split(GetINIStr(INISection, INIstr), ",")
    Select Case tmpstrArray(1)
    Case 1
        Get #fileid, CLng("&h" & tmpstrArray(0)) + 1, tmpbyte
        ReadZValue = tmpbyte
    Case 2
        Get #fileid, CLng("&h" & tmpstrArray(0)) + 1, tmpInt
        ReadZValue = tmplong
    Case 4
        Get #fileid, CLng("&h" & tmpstrArray(0)) + 1, tmplong
        ReadZValue = tmplong
    End Select
End Function





' 无符号整数转换为无符号的long
Public Function Int2Long(x As Integer) As Long
If x >= 0 Then
    Int2Long = x
Else
    Int2Long = 65536 + x
End If
End Function

' long型转换为无符号int
Public Function Long2int(x As Long) As Integer
If x < 32768 Then
    Long2int = x
Else
    Long2int = x - 65536
End If
End Function



' 读取asm指令，并处理为指定测试
' filename asm文件名
' Startaddr z.dat 指令区起始地址
' SectionSize z.dat每个section的大小
' casm 返回的集合

Public Sub ReadAsm(ByVal filename As String, ByVal StartAddr As Long, ByVal SectionSize As Long, casm As Collection)
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





End Sub


' 读取asm指令，并处理为指定测试
' filename asm文件名
' Startaddr z.dat 指令区起始地址
' SectionSize z.dat每个section的大小
' casm 返回的集合

Public Sub ReadZmodify(ByVal filename As String, casm As Collection)
Dim fileid As Long
Dim tmpinput As String
Dim i As Long, j As Long
Dim currentAddr As Long
Dim tmparray() As String
Dim asm As clsX86
Dim tmpHex As String
    Set casm = New Collection
    
    fileid = FreeFile()
    Open filename For Input Access Read As #fileid
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
            If tmparray(0) = "start" Then
                currentAddr = CLng("&h" & tmparray(1))
            Else
                Set asm = New clsX86
                asm.Str = tmpinput
                asm.Address = currentAddr
                asm.num = 0
                asm.Style = 1
                For i = 0 To UBound(tmparray)
                    asm.Data(asm.num) = CLng("&h" & tmparray(i))
                    asm.num = asm.num + 1
                Next i
                currentAddr = currentAddr + asm.num
                casm.Add asm
            End If
        End If
    Loop

    Close #fileid


End Sub




