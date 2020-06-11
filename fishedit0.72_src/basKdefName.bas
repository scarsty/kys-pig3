Attribute VB_Name = "basKdefName"
Option Explicit

Public Function GetKdefname(id As Long) As String
    On Error GoTo Label1:
    GetKdefname = KdefName.Item("ID" & id)
     Exit Function
Label1:
    GetKdefname = ""
    
End Function


Public Function GetXchar(ByVal x1 As Integer, ByVal x2 As Integer, ByVal x3 As Integer, ByVal x4 As Integer, ByVal x5 As Integer) As String
Dim tmpbyte(9) As Byte
Dim i As Long
    tmpbyte(0) = x1 And &HFF
    tmpbyte(1) = (x1 And &HFF00) / 256
    tmpbyte(2) = x2 And &HFF
    tmpbyte(3) = (x2 And &HFF00) / 256
    tmpbyte(4) = x3 And &HFF
    tmpbyte(5) = (x3 And &HFF00) / 256
    tmpbyte(6) = x4 And &HFF
    tmpbyte(7) = (x4 And &HFF00) / 256
    tmpbyte(8) = x5 And &HFF
    tmpbyte(9) = (x5 And &HFF00) / 256
    
    GetXchar = ""
    For i = 0 To 9
        If tmpbyte(i) > 0 Then
            GetXchar = GetXchar & Chr(tmpbyte(i))
        Else
            Exit For
        End If
    Next i

End Function


Public Sub SetXchar(s As String, x1 As Integer, x2 As Integer, x3 As Integer, x4 As Integer, x5 As Integer)
Dim tmpbyte(9) As Byte
Dim l As Long
Dim i As Long
    l = Len(s)
    If l > 9 Then
        l = 10
    End If
    
    For i = 0 To 9
        tmpbyte(i) = 0
    Next i
    
    For i = 0 To l - 1
        tmpbyte(i) = Asc(Mid(s, i + 1, 1))
    Next i
    
    x1 = tmpbyte(0) + 256 * tmpbyte(1)
    x2 = tmpbyte(2) + 256 * tmpbyte(3)
    x3 = tmpbyte(4) + 256 * tmpbyte(5)
    x4 = tmpbyte(6) + 256 * tmpbyte(7)
    x5 = tmpbyte(8) + 256 * tmpbyte(9)
    
    

End Sub

' 根据kdefname中的数据，设置下拉框，并设置text的值
' combo  下拉框
' flag  =1 设置值，＝0不设置
' id 变量id

Public Sub SetKdefNameCombo(combo As ComboBox, ByVal flag As Long, ByVal id As Long)
Dim i As Long
Dim s As String
    combo.Clear
    combo.AddItem StrUnicode2("=未定义变量=")
    For i = 1 To KdefName.Count
        combo.AddItem KdefName(i)
    Next i
    
    If flag = 1 Then
        s = GetKdefname(id)
        If s = "" Then
            combo.ListIndex = 0
        Else
            combo.Text = s
        End If
    End If

End Sub

