VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "clsDIB"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = False
Option Explicit

Public CompDC As Long
Public addr As Long

Private binfo As BITMAPINFO
Private DIBSectionHandle As Long    ' Handle to DIBSection
Private OldCompDCBM As Long         ' Original bitmap for CompDC
Private temp As Long
Private lineSize As Long

Private myWidth As Long
Private myHeight As Long


Public Sub CreateDIB(ByVal Width As Long, ByVal height As Long)
    myWidth = Width
    myHeight = height
    CompDC = CreateCompatibleDC(0)
    With binfo.bmiHeader
        .biSize = 40
        .biWidth = Width
        .biHeight = -height
        .biPlanes = 1
        .biBitCount = 32
        .biCompression = 0
        lineSize = .biWidth * 4
        .biSizeImage = -lineSize * .biHeight
    End With
    
    DIBSectionHandle = CreateDIBSection(CompDC, binfo, 0, addr, 0, 0)
    OldCompDCBM = SelectObject(CompDC, DIBSectionHandle)
End Sub



    
Private Sub Class_Terminate()
    temp = GetLastError()
    temp = SelectObject(CompDC, OldCompDCBM)
    temp = DeleteDC(CompDC)
    temp = DeleteObject(DIBSectionHandle)
End Sub
