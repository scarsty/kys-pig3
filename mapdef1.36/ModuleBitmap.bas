Attribute VB_Name = "ModuleBitmap"
Option Explicit
Declare Function SetDIBitsToDevice Lib "gdi32.dll" (ByVal hdc As Long, ByVal X As Long, ByVal Y As Long, ByVal dx As Long, ByVal dy As Long, ByVal SrcX As Long, ByVal SrcY As Long, ByVal Scan As Long, ByVal NumScans As Long, Bits As Any, BitsInfo As Any, ByVal wUsage As Long) As Long
Private Const BI_RGB As Long = 0&
Private Const BI_RLE8 As Long = 1&
Private Const BI_RLE4 As Long = 2&
Public Const DIB_RGB_COLORS As Long = 0
Declare Function InvalidateRect Lib "user32" (ByVal hwnd As Long, lpRect As RECT, ByVal bErase As Long) As Long

'Private Const ImgWidth As Long = &H100
'Private Const ImgHeight As Long = &H100
Private headAdd As Long, nextAdd As Long, headIdx As Integer
Private LineDataLen As Integer, PointSum As Integer
Private Char As String * 1
Private Ch As Byte, maxLine As Integer, emFill As Byte, perDot As Integer
Private BI As BITMAP24INFOHEADER
Private LineBytes As Long
Private MapData() As Byte
Function GetTileINFO(mapFileName As String, mapIdxFileName As String, ByVal headIdx As Long) As RLEPic1
temp1 = FreeFile
Open mapIdxFileName For Binary As #temp1
temp2 = FreeFile
Open mapFileName For Binary As #temp2
 If headIdx <= 0 Then
  headIdx = 0
  headAdd = 0
 Else
  Get #temp1, (headIdx - 1) * 4 + 1, headAdd
 End If
 Get #temp1, headIdx * 4 + 1, nextAdd
 Close #temp1
 Seek #temp2, headAdd + 1
 Get #temp2, , GetTileINFO.Width
 Get #temp2, , GetTileINFO.Height
 Get #temp2, , GetTileINFO.X
 Get #temp2, , GetTileINFO.Y
Close #temp1
Close #temp2
End Function

Sub DrawOneTile2(DstObj As Object, SrcObj As Object, ByVal DstX As Long, ByVal DstY As Long, ByVal SrcX As Long, ByVal SrcY As Long, mapFileName As String, mapIdxFileName As String, ByVal headIdx As Long, withOffset As Boolean, ClearSrc As Boolean)
Dim Width1 As Integer, Width2 As Integer, Height1 As Integer, Height2 As Integer
Dim Readed As Integer, EmptyPoint As Integer
Dim I As Long, K As Long, J As Long, cColor As Long
temp1 = FreeFile
Open mapIdxFileName For Binary As #temp1
temp2 = FreeFile
Open mapFileName For Binary As #temp2
 If headIdx <= 0 Then
  headIdx = 0
  headAdd = 0
 Else
  Get #temp1, (headIdx - 1) * 4 + 1, headAdd
 End If
 Get #temp1, headIdx * 4 + 1, nextAdd
 Close #temp1
 Seek #temp2, headAdd + 1
 Get #temp2, , Width1
 Get #temp2, , Height1
 Get #temp2, , Width2
 Get #temp2, , Height2
 SetBmDataSize Width1, Height1   '设置bmp内存大小
'MsgBox mapFileName
If Not withOffset Then
 Width2 = 0: Height2 = 0
End If
'MsgBox bi.biSizeImage - Width1 * Height1 * 3 & " " & Width1 & " " & Height1
Dim LineIdx As Long, CurIdx As Long
'LineIdx = (bi.biHeight - 1) * LineBytes 'DIB是逆序存储的
For K = 0 To Height1 - 1  '一行一行读
  Get #temp2, , Ch
  LineDataLen = Ch: Readed = 0
  CurIdx = (BI.biHeight - K - 1) * LineBytes
   For J = 0 To Width1 - 1 '读一行
       If LineDataLen = 0 Then Exit For '此行无数据，跳出到下一行
       Get #temp2, , Ch: Readed = Readed + 1
       EmptyPoint = Ch    '透明
       CurIdx = CurIdx + 3 * EmptyPoint
       Get #temp2, , Ch: Readed = Readed + 1
       'PointSum = Ch     '接下来有多少字节有色
       For I = 1 To Ch
          Get #temp2, , Ch: Readed = Readed + 1
          'cColor = palRGB(Ch)
          MapData(CurIdx + 2) = palR(Ch)      'Red
          MapData(CurIdx + 1) = palG(Ch)       'Green
          MapData(CurIdx + 0) = palB(Ch) 'Blue
         CurIdx = CurIdx + 3 '24位一个点
       Next I
    If Readed >= LineDataLen Then Exit For
   Next J
Next K
Close #temp2
If ClearSrc Then SrcObj.Cls
Call SetDIBitsToDevice(SrcObj.hdc, SrcX, SrcY, Width1, Height1, 0, 0, 0, BI.biHeight, MapData(0), BI, DIB_RGB_COLORS)
    'Dim bmp As BITMAP
    'GetObj frmMapEdit.Picture2(2).Picture, Len(bmp), bmp
If DstObj Is Nothing Then
 Else
  TransparentBlt DstObj.hdc, SrcObj.hdc, SrcX, SrcY, Width1, Height1, DstX - Width2, DstY - Height2, &HFF00FF   'frmMapEdit.Picture2(2).BackColor
End If
End Sub
Sub Draw320_200(ofObj As Object, baseX As Integer, baseY As Integer, mapFileName As String, mapIdxFileName As String, headIdx As Long)
Dim Width1 As Integer, Height1 As Integer
Dim I As Long, K As Long, J As Long, cColor As Long
temp1 = FreeFile
Open mapIdxFileName For Binary As #temp1
temp2 = FreeFile
Open mapFileName For Binary As #temp2
 If headIdx <= 0 Then
  headIdx = 0
  headAdd = 0
 Else
  Get #temp1, (headIdx - 1) * 4 + 1, headAdd
 End If
 Get #temp1, headIdx * 4 + 1, nextAdd
 Close #temp1
 Seek #temp2, headAdd + 1
 Width1 = 320
 Height1 = 200
 SetBmDataSize Width1, Height1   '设置bmp内存大小
Dim CurIdx As Long, temp64K(0 To 63999) As Byte
Get #temp2, , temp64K
For K = 0 To Height1 - 1  '一行一行读
  CurIdx = (BI.biHeight - K - 1) * LineBytes
   For J = 0 To Width1 - 1 '读一行
          Ch = temp64K(K * Width1 + J)
          MapData(CurIdx + 2) = palR(Ch)      'Red
          MapData(CurIdx + 1) = palG(Ch)       'Green
          MapData(CurIdx + 0) = palB(Ch) 'Blue
         CurIdx = CurIdx + 3 '24位一个点
   Next J
Next K
Close #temp2
'tempObj.Cls
Call SetDIBitsToDevice(ofObj.hdc, 0, 0, Width1, Height1, 0, 0, 0, BI.biHeight, MapData(0), BI, DIB_RGB_COLORS)

End Sub

Sub SetBmDataSize(ImgWidth As Integer, ImgHeight As Integer)
    With BI
        .biSize = Len(BI)
        .biWidth = ImgWidth
        .biHeight = ImgHeight
        .biBitCount = 24
        .biPlanes = 1
        .biCompression = BI_RGB
        LineBytes = ((.biWidth * .biBitCount + 31) And &HFFFFFFE0) \ 8 '每行占用字节要是8的倍数，不够就补齐
        .biSizeImage = LineBytes * .biHeight
        ReDim MapData(0 To .biSizeImage)
    End With
    Dim I As Long, K As Integer
On Error Resume Next
      For K = 0 To BI.biHeight - 1
        For I = K * LineBytes To (K + 1) * LineBytes - 1 Step 3
          MapData(I) = &HFE 'Blue
          MapData(I + 1) = &H0     'Green
          MapData(I + 2) = &HFE        'Red
        Next I
      Next K
On Error GoTo 0
End Sub
