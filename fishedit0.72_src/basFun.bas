Attribute VB_Name = "basFun"
Option Explicit


Public Function RndLong(i As Long) As Long
    RndLong = Int(Rnd * (i))
End Function


Public Function FMT(ByVal Str As String, ByVal length As Long) As String
    If length > Len(Str) Then
        FMT = String(length - Len(Str), " ")
    Else
        FMT = ""
    End If
    FMT = Str & FMT
End Function



Public Function GetINILong(strSection As String, StrKey As String) As Long
    GetINILong = GetPrivateProfileInt(strSection, StrKey, -65536, G_Var.IniFilename)
    If GetINILong = -65536 Then
        Err.Raise vbObjectError + 1, , "INI Section " & strSection & " Key " & StrKey & " Not found"
    End If
End Function

Public Function GetINIStr(strSection As String, StrKey As String) As String
Dim tmpstr() As Byte
Dim returnval As Long
Dim ttt As String
    ReDim tmpstr(255)
    returnval = GetPrivateProfileString(strSection, StrKey, "", tmpstr(0), 256, G_Var.IniFilename)
    If returnval > 0 Then
        ReDim Preserve tmpstr(returnval - 1)
        If Charset = "GBK" Then
            GetINIStr = StrConv(tmpstr, vbUnicode)
        Else
            ttt = tmpstr
            GetINIStr = GBKtoUnicode(ttt)
        End If
    Else
        GetINIStr = ""
    End If
   ' GetINIStr = tmpstr
End Function

Public Sub PutINIStr(strSection As String, StrKey As String, strVal As String)
Dim returnval As Long
    returnval = WritePrivateProfileString(strSection, StrKey, strVal, G_Var.IniFilename)

End Sub



' 打开二进制文件
' status = "R"   读
' status = "W"   写，备份文件
' Status = "WN"  写新文件，可以比原来文件小，备份文件
Public Function OpenBin(filename As String, status As String) As Long
   OpenBin = FreeFile()
   Select Case UCase(status)
   Case "R"
       If Dir(filename) = "" Then
           Err.Raise vbObjectError + 1, , "File " & filename & " not exist"
       End If
       Open filename For Binary Access Read As OpenBin
   Case "W"
       FileCopy filename, filename & ".bak"
       Open filename For Binary Access Write As OpenBin
   Case "WN"
       If Dir(filename & ".bak") <> "" Then
           Kill filename & ".bak"
       End If
       If Dir(filename) <> "" Then
           Name filename As filename & ".bak"
       End If
       Open filename For Binary Access Write As OpenBin
   End Select
   
End Function

' 转换form中所有空间的caption字符集, 用于新的窗口处理字符串

Public Sub ConvertForm(frm As Form)
Dim i As Long
    frm.Caption = StrUnicode(frm.Caption)
 
    For i = 0 To frm.Controls.Count - 1
         Call SetCaption(frm.Controls(i))
    Next i

   
End Sub

' 设置窗体的字符串信息和窗体标题，用于50指令解析窗口
Public Sub Set50Form(frm As Form, id As Long)
Dim s1 As String

    s1 = GetINIStr("Kdef50", "sub" & id)
    If s1 = "" Then
        s1 = GetINIStr("Kdef50", "Other")
    End If

    frm.Caption = StrUnicode2("50指令") & id & " - " & s1

    On Error Resume Next
    frm.txtNote.Text = StrUnicode(frm.txtNote.Text)

End Sub



' 设置控件的caption属性
Public Sub SetCaption(oo As Object)
    If TypeOf oo Is Menu Then
        oo.Caption = StrUnicode(oo.Caption)
    End If
    If TypeOf oo Is CommandButton Then
        oo.Caption = StrUnicode(oo.Caption)
        oo.ToolTipText = StrUnicode(oo.ToolTipText)
    End If
    If TypeOf oo Is label Then
        oo.Caption = StrUnicode(oo.Caption)
        oo.ToolTipText = StrUnicode(oo.ToolTipText)
    End If
    If TypeOf oo Is CheckBox Then
        oo.Caption = StrUnicode(oo.Caption)
    End If
    If TypeOf oo Is OptionButton Then
        oo.Caption = StrUnicode(oo.Caption)
    End If
    If TypeOf oo Is Frame Then
        oo.Caption = StrUnicode(oo.Caption)
    End If
    If TypeOf oo Is PictureBox Then
        oo.ToolTipText = StrUnicode(oo.ToolTipText)
    End If
    If TypeOf oo Is ListBox Then
        oo.ToolTipText = StrUnicode(oo.ToolTipText)
    End If
    
    
End Sub


Public Function Max_V(x1 As Variant, x2 As Variant) As Variant
    Max_V = IIf(x1 > x2, x1, x2)
End Function

Public Function Min_V(x1 As Variant, x2 As Variant) As Variant
    Min_V = IIf(x1 < x2, x1, x2)
End Function

' 控制x在（xmin，xmax）范围
Public Function RangeValue(x As Variant, ByVal Xmin As Long, ByVal Xmax As Long) As Variant
    If x > Xmax Then
        x = Xmax
    End If
    If x < Xmin Then
        x = Xmin
    End If
    RangeValue = x
End Function


'  去掉字符串前后多余的空格，中间多个连续的空格变成一个空格
Public Function SubSpace(s As String) As String
Dim tmps As String
Dim pos As String
    tmps = Trim(s)
    Do
        pos = InStr(tmps, "  ")
        If pos = 0 Then Exit Do
        tmps = Mid(tmps, 1, pos - 1) & Mid(tmps, pos + 1)
    Loop
    SubSpace = tmps
End Function


Public Function Byte2String(s() As Byte) As String
Dim i As Long
Dim length As Long
Dim tmpbyte() As Byte
Dim MaxArray As Long
    length = 0
    MaxArray = UBound(s, 1)
    For i = 0 To MaxArray
        If s(i) = 0 Then
            length = i
            Exit For
        End If
    Next i
    If length = 0 Then length = MaxArray + 1
    ReDim tmpbyte(length - 1)
    For i = 0 To length - 1
        tmpbyte(i) = s(i)
    Next i
    Byte2String = StrConv(tmpbyte, vbUnicode)
    
End Function

Public Function HexInt(i As Integer) As String
Dim length As Long
    HexInt = Hex(i)
    length = Len(HexInt)
    If length < 4 Then
        HexInt = String(4 - length, "0") & HexInt
    End If
End Function


