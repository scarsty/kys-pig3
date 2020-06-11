Attribute VB_Name = "Module3"
Option Explicit

'
' Copyright (c) Hai Li, Zeal SoftStudio 1997
' All Rights Reserved.
' Email: haili@public.bta.net.cn
' http://www.nease.net/~zealsoft/indexc.html
'
' Demo of TransparentBlt function.
' May be freely used in your applications.
'
Dim cTransparent As Long
#If Win32 Then
    Public Type BITMAP '14 bytes
        bmType As Long
        bmWidth As Long
        bmHeight As Long
        bmWidthBytes As Long
        bmPlanes As Integer
        bmBitsPixel As Integer
        bmBits As Long
    End Type
     Declare Function GetObj Lib "gdi32" Alias "GetObjectA" (ByVal _
        hObject As Long, ByVal nCount As Long, lpObject As Any) As Long
#Else
    Public Type BITMAP
        bmType As Integer
        bmWidth As Integer
        bmHeight As Integer
        bmWidthBytes As Integer
        bmPlanes As String * 1
        bmBitsPixel As String * 1
        bmBits As Long
    End Type
     Declare Function GetObj Lib "GDI" Alias "GetObject" (ByVal hObject _
        As Integer, ByVal nCount As Integer, bmp As Any) As Integer
#End If


#If Win32 Then
    Declare Function BitBlt Lib "gdi32" (ByVal hDestDC As Long, _
        ByVal x As Long, ByVal y As Long, ByVal nWidth As Long, _
        ByVal nHeight As Long, ByVal hSrcDC As Long, ByVal xSrc _
        As Long, ByVal ySrc As Long, ByVal dwRop As Long) As Long
    Declare Function SetBkColor Lib "gdi32" (ByVal hdc As Long, _
        ByVal crColor As Long) As Long
    Declare Function CreateCompatibleDC Lib "gdi32" (ByVal hdc _
        As Long) As Long
    Declare Function CreateBitmap Lib "gdi32" (ByVal nWidth As Long, _
        ByVal nHeight As Long, ByVal nPlanes As Long, ByVal nBitCount _
        As Long, lpBits As Any) As Long
    Declare Function CreateCompatibleBitmap Lib "gdi32" (ByVal hdc As _
        Long, ByVal nWidth As Long, ByVal nHeight As Long) As Long
    Declare Function DeleteDC Lib "gdi32" (ByVal hdc As Long) As Long
    Declare Function DeleteObject Lib "gdi32" (ByVal hObject As Long) _
        As Long
    Declare Function SelectObject Lib "gdi32" (ByVal hdc As Long, _
        ByVal hObject As Long) As Long
#Else
    Declare Function BitBlt Lib "GDI" (ByVal hDestDC As Integer, ByVal _
        SrcX As Integer, ByVal SrcY As Integer, ByVal SrcW As Integer, _
        ByVal SrcH As Integer, ByVal hSrcDC As Integer, ByVal destX As _
        Integer, ByVal destY As Integer, ByVal op As Long) As Integer
    Declare Function SetBkColor Lib "GDI" (ByVal hdc As Integer, ByVal _
        cColor As Long) As Long
    Declare Function CreateCompatibleDC Lib "GDI" (ByVal hdc As Integer) _
        As Integer
    Declare Function DeleteDC Lib "GDI" (ByVal hdc As Integer) As Integer
    Declare Function CreateBitmap Lib "GDI" (ByVal nWidth As Integer, _
        ByVal nHeight As Integer, ByVal cbPlanes As Integer, ByVal cbBits _
        As Integer, lpvBits As Any) As Integer
    Declare Function CreateCompatibleBitmap Lib "GDI" (ByVal hdc As _
        Integer, ByVal nWidth As Integer, ByVal nHeight As Integer) _
        As Integer
    Declare Function SelectObject Lib "GDI" (ByVal hdc As Integer, _
        ByVal hObject As Integer) As Integer
    Declare Function DeleteObject Lib "GDI" (ByVal hObject As Integer) _
        As Integer
#End If




Public Sub TransparentBlt(DstDC As Long, _
    SrcDC As Long, ByVal SrcX As Integer, ByVal SrcY As Integer, _
    ByVal SrcW As Integer, ByVal SrcH As Integer, DstX As Integer, _
    DstY As Integer, TransColor As Long)
    '     DstDC - Device context into image is actually drawn
    '     SrcDC - Device context of source to be made transparent in color TransColor
    '     SrcX, SrcY, SrcW, SrcH - Rectangular region of source bitmap in pixels
    '     DstX, DstY - Coordinates in OutDstDC where the transparent bitmap must go
    '     TransColor - Transparent color
    Dim nRet As Long
    Dim MonoMaskDC As Long, hMonoMask As Long
    Dim MonoInvDC As Long, hMonoInv As Long
    Dim ResultDstDC As Long, hResultDst As Long
    Dim ResultSrcDC As Long, hResultSrc As Long
    Dim hPrevMask As Long, hPrevInv As Long
    Dim hPrevSrc As Long, hPrevDst As Long
    Dim OldBC As Long
    Dim OldMode As Integer
           
    ' Create monochrome mask and inverse masks
    MonoMaskDC = CreateCompatibleDC(DstDC)
    MonoInvDC = CreateCompatibleDC(DstDC)
    ' Create monochrome bitmaps for the mask-related bitmaps:
    hMonoMask = CreateBitmap(SrcW, SrcH, 1, 1, ByVal 0&)
    hMonoInv = CreateBitmap(SrcW, SrcH, 1, 1, ByVal 0&)
    hPrevMask = SelectObject(MonoMaskDC, hMonoMask)
    hPrevInv = SelectObject(MonoInvDC, hMonoInv)
    ' Create keeper DCs and bitmaps
    ResultDstDC = CreateCompatibleDC(DstDC)
    ResultSrcDC = CreateCompatibleDC(DstDC)
    'Create color bitmaps for final result & stored copy of source
    hResultDst = CreateCompatibleBitmap(DstDC, SrcW, SrcH)
    hResultSrc = CreateCompatibleBitmap(DstDC, SrcW, SrcH)
    hPrevDst = SelectObject(ResultDstDC, hResultDst)
    hPrevSrc = SelectObject(ResultSrcDC, hResultSrc)
    ' Copy src to monochrome mask
    OldBC = SetBkColor(SrcDC, TransColor)
    nRet = BitBlt(MonoMaskDC, 0, 0, SrcW, SrcH, SrcDC, _
        SrcX, SrcY, vbSrcCopy)
    TransColor = SetBkColor(SrcDC, OldBC)
    ' Create inverse of mask
    nRet = BitBlt(MonoInvDC, 0, 0, SrcW, SrcH, MonoMaskDC, _
        0, 0, vbNotSrcCopy)
    'Copy background bitmap to result & create final transparent bitmap
    nRet = BitBlt(ResultDstDC, 0, 0, SrcW, SrcH, DstDC, _
        DstX, DstY, vbSrcCopy)
     
    'AND mask bitmap w/ result DC to punch hole in the background by
    'painting black area for non-transparent portion of source bitmap.
    nRet = BitBlt(ResultDstDC, 0, 0, SrcW, SrcH, _
        MonoMaskDC, 0, 0, vbSrcAnd)
    ' Get overlapper
    nRet = BitBlt(ResultSrcDC, 0, 0, SrcW, SrcH, _
        SrcDC, SrcX, SrcY, vbSrcCopy)
    'AND inverse mask w/ source bitmap to turn off bits associated
    'with transparent area of source bitmap by making it black.
    nRet = BitBlt(ResultSrcDC, 0, 0, SrcW, SrcH, _
        MonoInvDC, 0, 0, vbSrcAnd)
    'XOR result w/ source bitmap to make background show through.
    nRet = BitBlt(ResultDstDC, 0, 0, SrcW, SrcH, _
        ResultSrcDC, 0, 0, vbSrcInvert)
    ' Output results
    nRet = BitBlt(DstDC, DstX, DstY, SrcW, SrcH, _
        ResultDstDC, 0, 0, vbSrcCopy)
    ' Clean up
    hMonoMask = SelectObject(MonoMaskDC, hPrevMask)
    DeleteObject hMonoMask
    hMonoInv = SelectObject(MonoInvDC, hPrevInv)
    DeleteObject hMonoInv
    hResultDst = SelectObject(ResultDstDC, hPrevDst)
    DeleteObject hResultDst
    hResultSrc = SelectObject(ResultSrcDC, hPrevSrc)
    DeleteObject hResultSrc
    DeleteDC MonoMaskDC
    DeleteDC MonoInvDC
    DeleteDC ResultDstDC
    DeleteDC ResultSrcDC
End Sub


