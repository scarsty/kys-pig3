Attribute VB_Name = "Module1"
Option Explicit

Declare Sub FloodFill Lib "gdi32" (ByVal hdc As Long, ByVal X As Long, ByVal Y As Long, ByVal crColor As Long)
Declare Function MoveToEx Lib "gdi32" (ByVal hdc As Long, ByVal X As Long, ByVal Y As Long, lpPoint As POINTAPI) As Long
'Declare Function SetPixel Lib "gdi32" (ByVal hdc As Long, ByVal x As Long, ByVal y As Long, ByVal crColor As Long) As Long
Declare Function LineTo Lib "gdi32" (ByVal hdc As Long, ByVal X As Long, ByVal Y As Long) As Long

Public openmode As Integer, rf As String, addnow As Integer
Public temp1 As Integer, temp2 As Integer, temp3 As Long, temp4 As Single, errorlevel As Integer, add As Long
Public AddName(0 To 83) As String, AddAttrib(0 To 199, 0 To 10) As Integer
Public Wd640 As Integer, Ht480 As Integer
Public Const XSCALE = 18
Public Const YSCALE = 9
Public Type POINTAPI
 X As Long
 Y As Long
End Type
Public Type bpos
    X As Integer
    Y As Integer
End Type
Public Function GetiMapPos(X As Single, Y As Single) As bpos
    With GetiMapPos
        .X = Int((X / 4 + Y / 2 - 4) * 2.236 / 40 * 2 - 32)
        .Y = Int((Y / 2 - X / 4) * 2.236 / 40 * 2 + 32)
    End With
End Function
Function Pos2Pixel(I1 As Integer, J1 As Integer) As POINTAPI
 '得到Tile（正方形）左上角坐标
 With Pos2Pixel
  .X = XSCALE * (I1 - J1) + Wd640 / 2 - XSCALE
  .Y = YSCALE * (I1 + J1)
 End With
End Function
