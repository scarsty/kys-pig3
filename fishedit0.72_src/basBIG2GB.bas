Attribute VB_Name = "basBIG2GB"

'*****************************************************
'//
'//  basBIG2GB.bas  1999/08/19
'//
'//  作者:陈国强  alone@telekbird.com.cn
'//  原子数据工作室  http://www.quanqiu.com/vb
'//
'//  您可以自由的拷贝并使用本程序
'//  您有义务把程序中的BUG告诉我
'//
'*****************************************************
'
'
'
'函数说明

'Sub InitDATA
'初始化内码数据
'首次调用GB2BIG或BIG2GB函数之前最好先Call InitDATA
'数组BIG5Order()中存放所有BIG5码汉字对应的GB2312码的的 ANSI 字符代码。
'数组GBOrder()中存放所有GB2312码汉字对应的BIG5码的的 ANSI 字符代码。
'使用Chr(ANSI 字符代码)即可得到对应的汉字
'
'Function GB2BIG(strGB As String) As String
'GB2312码 -> BIG5码
'
'Function BIG2GB(strBIG As String) As String
'BIG5码 -> GB2312码

'Function CheckBIG(strSource As String) As Boolean
'判断一段文字中是否含有BIG5码汉字 , 可用做内码的自动识别
'返回True表示包含BIG5码
'返回False表示不含BIG5码 , 这段文字一般可认为是GB码
'
'
'资源文件的生成方法祥见Resource目录下的BuildDATA.vbp项目


Option Explicit

Private GBOrder(8177) As Integer
Private BIG5Order(14757) As Integer
Private InitOK As Boolean
Private ByteDataGB() As Byte
Private ByteDataBIG() As Byte



Public Sub InitDATA()
On Error GoTo ERROR_HANDLE
Dim h As Long
Dim i, j As Integer
InitOK = True

ByteDataGB = LoadResData(101, "INS")
ByteDataBIG = LoadResData(102, "INS")

For i = LBound(ByteDataGB) To UBound(ByteDataGB) / 2
    GBOrder(i) = Val("&H" & Hex(ByteDataGB(2 * i + 1)) & Hex(ByteDataGB(2 * i)))
Next i
For i = LBound(ByteDataBIG) To UBound(ByteDataBIG) / 2
    BIG5Order(i) = Val("&H" & Hex(ByteDataBIG(2 * i + 1)) & Hex(ByteDataBIG(2 * i)))
Next i
Exit Sub
ERROR_HANDLE:
    InitOK = False
End Sub

Public Function GB2BIG(strGB As String) As String
On Error Resume Next
Dim ByteGB() As Byte
Dim ByteTemp(1) As Byte
Dim leng As Long, idx As Long
Dim strOut As String
Dim Offset As Long

If Not InitOK Then Call InitDATA
If Not InitOK Then
    GB2BIG = strGB
    Exit Function
End If

ByteGB = StrConv(strGB, vbFromUnicode)
leng = UBound(ByteGB)
idx = 0

Do While idx <= leng
    ByteTemp(0) = ByteGB(idx)
    ByteTemp(1) = ByteGB(idx + 1)
    Offset = GBOffset(ByteTemp)
    If isGB(ByteTemp) And (Offset >= 0) And (Offset <= 8177) Then
        strOut = strOut & Chr(GBOrder(Offset))
        idx = idx + 2
    Else
        strOut = strOut & Chr(ByteTemp(0))
        idx = idx + 1
    End If
    Loop

GB2BIG = strOut
End Function

Public Function BIG2GB(ByteBIG() As Byte) As String
On Error Resume Next
'Dim ByteBIG() As Byte
Dim ByteTemp(1) As Byte
Dim leng As Long, idx As Long
Dim strOut As String
Dim Offset As Long

If Not InitOK Then Call InitDATA
If Not InitOK Then
    BIG2GB = ByteBIG
    Exit Function
End If

'ByteBIG = StrConv(strBIG, vbFromUnicode)
leng = UBound(ByteBIG)
idx = 0
Do While idx <= leng
    ByteTemp(0) = ByteBIG(idx)
    ByteTemp(1) = ByteBIG(idx + 1)
    Offset = BIG5Offset(ByteTemp)
    If isBIG(ByteTemp) And (Offset >= 0) And (Offset <= 14757) Then
        strOut = strOut & Chr(BIG5Order(Offset))
        idx = idx + 1
    Else
        strOut = strOut & Chr(ByteTemp(0))
    End If
    idx = idx + 1
Loop
BIG2GB = strOut
End Function

Public Function CheckBIG(strSource As String) As Boolean
Dim idx As Long
Dim ByteTemp() As Byte
CheckBIG = False
For idx = 1 To Len(strSource)
    ByteTemp = StrConv(Mid(strSource, idx, 1), vbFromUnicode)
    If UBound(ByteTemp) > 0 Then
        If (ByteTemp(1) >= 64) And (ByteTemp(1) <= 126) Then
            CheckBIG = True
            Exit For
        End If
    End If
Next idx
End Function

Private Function GBOffset(ChrString() As Byte) As Long
'On Error GoTo ERROR_HANDLE
Dim Dl, Dh
    Dl = ChrString(0)
    Dh = ChrString(1)
    GBOffset = (Dl - 161) * 94 + (Dh - 161)
'    Exit Function
'ERROR_HANDLE:
'    GBOffset = -1
End Function

Private Function BIG5Offset(ChrString() As Byte) As Long
'On Error GoTo ERROR_HANDLE
Dim Dl, Dh
    Dl = ChrString(0)
    Dh = ChrString(1)
    If (Dh >= 64) And (Dh <= 126) Then _
        BIG5Offset = (Dl - 161) * 157 + (Dh - 64)
    If (Dh >= 161) And (Dh <= 254) Then _
        BIG5Offset = (Dl - 161) * 157 + 63 + (Dh - 161)
'    Exit Function
'ERROR_HANDLE:
'    BIG5Offset = -1
End Function

Private Function isGB(ChrString() As Byte) As Boolean
'On Error GoTo ERRORHANDLE
If UBound(ChrString) >= 1 Then
    If (ChrString(0) <= 161) And (ChrString(0) >= 247) Then
        isGB = False
    Else
        If (ChrString(1) <= 161) And (ChrString(1) >= 254) Then
            isGB = False
        Else
            isGB = True
        End If
    End If
Else
    isGB = False
End If
'Exit Function
'ERRORHANDLE:
'    isGB = False
End Function

Private Function isBIG(ChrString() As Byte) As Boolean
'On Error GoTo ERRORHANDLE
If UBound(ChrString) >= 1 Then
    If ChrString(0) < 161 Then
        isBIG = False
    Else
        If ((ChrString(1) >= 64) And (ChrString(1) <= 126)) Or ((ChrString(1) >= 161) And (ChrString(1) <= 254)) Then
            isBIG = True
        Else
            isBIG = False
        End If
    End If
Else
    isBIG = False
End If
'Exit Function
'ERRORHANDLE:
'    isBIG = False
End Function










