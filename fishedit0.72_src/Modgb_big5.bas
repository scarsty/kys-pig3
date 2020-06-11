Attribute VB_Name = "modgb_big5"
Option Explicit


' 汉字不同区域转换模块
' 函数列表：
'     LoadResStr   读字符串资源并转换为合适的字符集
'     JtoF            简体unicode转换为繁体unicode
'     UnicodetoBIG5   unicode到big5的转换
'     Big5toUnicode   big5到unicode的转换
'     LoadMB          读码表文件
'
'
'  需要设定全局变量     Charset  = "GBK"  or "BIG5"
'

Public gbk_big5(128 To 255, 255, 1) As Byte
Public big5_gbk(128 To 255, 255, 1) As Byte
Public unicodeF_J(255, 255, 1) As Byte


' 读字符串资源并转换为合适的字符集
' 输入
'      id:       资源id
'
' 返回值：
'      转换后的字符串
'
' 说明: 资源文件是用简体写的，可能在储存或者编译时就转换成unicode了，但是在繁体系统中不能显示其中的简化字，
'       估计繁体系统中没有这些字符。因此必须进行unicode简体 to unicode繁体的转换。其实直接造个繁体的资源文件
'        也可以
      
Public Function LoadResStr(Id As Long) As String
Dim buffer() As Byte
Dim tmpstr As String
    
    buffer = LoadResData(Id, 6)         ' 按照字节数组形式读资源文件
    If Charset = "GBK" Then
        LoadResStr = buffer          ' 当前操作系统字符集采用GBK则直接赋值（直接把字节数据赋值给字符串并不进行unicode转换）
    Else
        tmpstr = buffer
        LoadResStr = JtoF(tmpstr)    ' 把简体unicode转换为繁体unicode（big5繁体系统中不能显示简体字）
    End If

End Function


' 计算byte数组实际长度，到0为止。只用于判断以0结尾的字节字串实际长度
' 输入
'      data()              输入的数组
'      lengthdata          数组长度
' 返回值
'      数组实际长度（后面为0）
Private Function getlengthb(Data() As Byte, lengthdata As Long) As Long
Dim i As Long
   For i = 0 To lengthdata - 1
       If Data(i) = 0 Then
           getlengthb = i
           
           Exit Function
       End If
   Next i
   getlengthb = lengthdata
End Function

' 简体unicode转换为繁体unicode
' 输入
'      data       待转换的字符串
' 返回值
'      转换后的字符串


Public Function JtoF(Data As String) As String
Dim i As Long
Dim lengthb As Long
Dim tmpdata() As Byte
Dim tmpresult() As Byte
Dim b0 As Byte, b1 As Byte

    lengthb = LenB(Data)
    If lengthb = 0 Then
        JtoF = ""
        Exit Function
    End If
    ReDim tmpdata(lengthb - 1)
    ReDim tmpresult(lengthb - 1)
    
    For i = 0 To lengthb - 1                 ' 把字符串复制到字节数组
        tmpdata(i) = AscB(MidB(Data, i + 1, 1))
    Next i

    For i = 0 To lengthb - 1 Step 2          ' unicode为两个字节一个字符
        b0 = tmpdata(i)
        b1 = tmpdata(i + 1)
        If unicodeF_J(b0, b1, 0) = 0 And unicodeF_J(b0, b1, 1) = 0 Then   ' 为0表示此unicode字符没有对应的繁体，不用转换
            tmpresult(i) = b0
            tmpresult(i + 1) = b1
        Else
            tmpresult(i) = unicodeF_J(b0, b1, 0)            ' 查表转换
            tmpresult(i + 1) = unicodeF_J(b0, b1, 1)
        End If
    Next i
    JtoF = tmpresult                         ' 把数组直接赋值给字符串
End Function


' unicode到big5的转换
' 输入
'        data    待转换的字符串
' 输出
'        lengthdata   输出big5数组长度
'        big5data()   保存转换后的big5数组

Public Sub UnicodetoBIG5(Data As String, lengthdata As Long, big5data() As Byte)
Dim lengthb As Long
Dim lengthUnicode As Long
Dim result As Long
Dim testgb() As Byte
Dim GBstr As String
Dim i As Long
Dim p As Long
Dim b0 As Byte, b1 As Byte
Dim bf0 As Byte, bf1 As Byte


If Charset = "GBK" Then    ' 操作系统字符集为gbk
    
    GBstr = StrConv(Data, vbFromUnicode)   ' unicode 转换为gbk
    
    lengthb = LenB(GBstr)
    lengthdata = lengthb
    ReDim testgb(lengthb - 1)
    For i = 0 To lengthb - 1
        testgb(i) = AscB(MidB(GBstr, i + 1, 1))  ' gbk赋值到字节数组
    Next i
    
    
    p = 0
    ReDim big5data(lengthb - 1)
    
    While p < lengthb
        b0 = testgb(p)
        If b0 < 128 Then                ' 单字节不是汉字，不转换，直接赋值
            big5data(p) = b0
            p = p + 1
        Else
            b1 = testgb(p + 1)
            bf0 = gbk_big5(b0, b1, 0)
            bf1 = gbk_big5(b0, b1, 1)
            If bf0 > 0 And bf1 > 0 Then  '  ' 转换表中有则转换为BIG5
                big5data(p) = bf0
                big5data(p + 1) = bf1
            Else
                big5data(p) = AscB("?")    ' 没有则用？代替
                big5data(p + 1) = AscB("?")
            End If
            p = p + 2
        End If
    Wend
Else      ' 操作系统字符集为big5
    GBstr = StrConv(Data, vbFromUnicode)   ' 直接转换成big5字符串
    lengthdata = LenB(GBstr)
    ReDim big5data(lengthdata - 1)
    For i = 0 To lengthdata - 1
        big5data(i) = AscB(MidB(GBstr, i + 1, 1))  ' 复制到字节数组
    Next i
End If
    

End Sub


' big5到unicode的转换
' 输入
'       data           保存big5的数组
'       lengthdata     data数组长度
' 返回值
'       转换后的unicode字符串

Public Function Big5toUnicode(Data() As Byte, lengthdata As Long) As String
Dim tmpdata() As Byte
Dim p As Long
Dim b0 As Byte, b1 As Byte
Dim bf0 As Byte, bf1 As Byte
Dim lengthb
    p = 0
    lengthb = getlengthb(Data, lengthdata)     ' 计算实际长度（不包括后面的若干个0的）
    If lengthb = 0 Then Exit Function
    ReDim tmpdata(lengthb - 1)
    
    
    
If Charset = "GBK" Then        ' 操作系统字符集为gbk
    While p < lengthb
        b0 = Data(p)
        If b0 < 128 Then        ' 单字节不是汉字，不转换，直接赋值
            tmpdata(p) = b0
            p = p + 1
        Else
            b1 = Data(p + 1)
            bf0 = big5_gbk(b0, b1, 0)
            bf1 = big5_gbk(b0, b1, 1)
            If bf0 > 0 Or bf1 > 0 Then    ' 转换表中有则转换为gbk
                tmpdata(p) = bf0
                tmpdata(p + 1) = bf1
             Else
                 tmpdata(p) = AscB("?")    ' 没有则用？代替
                 tmpdata(p + 1) = AscB("?")
             End If
            p = p + 2
        End If
    Wend
    Big5toUnicode = StrConv(tmpdata, vbUnicode)   ' gbk转换为unicode
Else            ' 操作系统字符集为big5
    Dim i As Long
    For i = 0 To lengthb - 1
        tmpdata(i) = Data(i)               ' 复制data中实际数据，去掉后面的0
    Next i
    Big5toUnicode = StrConv(tmpdata, vbUnicode)  ' big5转换为unicode
End If
End Function

' 程序中gbk字符能正确显示，在big5下，用于控件、菜单等
Public Function StrUnicode(ss As String) As String
If Charset = "GBK" Then
    StrUnicode = ss
Else
    StrUnicode = GBKtoUnicode(StrConv(ss, vbFromUnicode))
    ' StrUnicode = JtoF(ss)
End If
End Function


' 程序中gbk字符能正确显示，在big5下, 用于程序字符串
Public Function StrUnicode2(ss As String) As String
If Charset = "GBK" Then
    StrUnicode2 = ss
Else
    'StrUnicode = GBKtoUnicode(StrConv(ss, vbFromUnicode))
     StrUnicode2 = JtoF(ss)
End If
End Function


' gbk到unicode的转换
' 输入
'       data           保存big5的数组
'       lengthdata     data数组长度
' 返回值
'       转换后的unicode字符串

Public Function GBKtoUnicode(ss As String) As String
Dim i As Long
Dim Data() As Byte
Dim tmpdata() As Byte
Dim p As Long
Dim b0 As Byte, b1 As Byte
Dim bf0 As Byte, bf1 As Byte
Dim lengthb
    p = 0
    'lengthb = getlengthb(data, lengthdata)     ' 计算实际长度（不包括后面的若干个0的）
    'If lengthb = 0 Then Exit Function
    'ReDim tmpdata(lengthb - 1)
    
    lengthb = LenB(ss)
    If lengthb = 0 Then
        GBKtoUnicode = ""
        Exit Function
    End If
    ReDim Data(lengthb - 1)
    ReDim tmpdata(lengthb - 1)
    
    For i = 0 To lengthb - 1
        Data(i) = AscB(MidB(ss, i + 1, 1))
    Next i
    
    
If Charset = "BIG5" Then        ' 操作系统字符集为big5
    While p < lengthb
        b0 = Data(p)
        If b0 < 128 Then        ' 单字节不是汉字，不转换，直接赋值
            tmpdata(p) = b0
            p = p + 1
        Else
            b1 = Data(p + 1)
            bf0 = gbk_big5(b0, b1, 0)
            bf1 = gbk_big5(b0, b1, 1)
            If bf0 > 0 Or bf1 > 0 Then    ' 转换表中有则转换为gbk
                tmpdata(p) = bf0
                tmpdata(p + 1) = bf1
            Else
                 tmpdata(p) = AscB("?")   ' 没有则用？代替
                 tmpdata(p + 1) = AscB("?")
            End If
            p = p + 2
        End If
    Wend
    GBKtoUnicode = StrConv(tmpdata, vbUnicode)   ' gbk转换为unicode
    GBKtoUnicode = JtoF(GBKtoUnicode)
Else                            ' 操作系统字符集为gbk
    For i = 0 To lengthb - 1
        tmpdata(i) = Data(i)               ' 复制data中实际数据，去掉后面的0
    Next i
    GBKtoUnicode = StrConv(tmpdata, vbUnicode)  ' big5转换为unicode
End If
End Function


' 读取码表文件
' 1 成功
' 0 失败
Public Function LoadMB() As Long
Dim i As Long, j As Long
Dim filenum As Long
Dim filename As String
Dim b0 As Byte, b1 As Byte
Dim c0 As Byte, c1 As Byte
    
    
    filename = App.Path & "\mb.dat"        ' 码表文件名
    If Dir(filename) = "" Then
        MsgBox "file " & filename & " not exist"
        LoadMB = 0
        Exit Function
    End If
    
    filenum = FreeFile()
    
    Open App.Path & "\mb.dat" For Binary Access Read As #filenum
    For i = &HA0 To &HFE
        For j = &H40 To &HFE
            If j <= &H7E Or j >= &HA1 Then
                Get #filenum, , b0
                Get #filenum, , b1
                big5_gbk(i, j, 0) = b0
                big5_gbk(i, j, 1) = b1
            End If
        Next j
    Next i
            
            
    For i = &H81 To &HFE
        For j = &H40 To &HFE
            If j <> &H7F Then
                Get #filenum, , b0
                Get #filenum, , b1
                gbk_big5(i, j, 0) = b0
                gbk_big5(i, j, 1) = b1
            End If
        Next j
    Next i

    For i = &H81 To &HFE
        For j = &H40 To &HFE
            If j <> &H7F Then
                Get #filenum, , b0
                Get #filenum, , b1
                Get #filenum, , c0
                Get #filenum, , c1
                unicodeF_J(b0, b1, 0) = c0
                unicodeF_J(b0, b1, 1) = c1
            End If
        Next j
    Next i
    Close filenum
    LoadMB = 1

End Function


