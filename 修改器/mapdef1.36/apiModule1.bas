Attribute VB_Name = "apiModule1"
Option Explicit
Declare Function SHFileExists Lib "shell32" Alias "#45" (ByVal szPath As String) As Long
Declare Function mciSendString Lib "winmm.dll" Alias "mciSendStringA" (ByVal lpstrCommand As String, ByVal lpstrReturnString As Any, ByVal uReturnLength As Long, ByVal hwndCallback As Long) As Long
Declare Function MoveWindow Lib "user32" (ByVal hwnd As Long, ByVal X As Long, ByVal Y As Long, ByVal nWidth As Long, ByVal nHeight As Long, ByVal bRepaint As Long) As Long
Declare Function SendMessage& Lib "user32" Alias "SendMessageA" (ByVal hwnd As Long, ByVal wMsg As Long, ByVal wParam As Long, lParam As Any)
Public Const CB_SETDROPPEDWIDTH = &H160
Declare Function ShellExecute Lib "shell32.dll" Alias "ShellExecuteA" (ByVal hwnd As Long, ByVal lpOperation As String, ByVal lpFile As String, ByVal lpParameters As String, ByVal lpDirectory As String, ByVal nShowCmd As Long) As Long
Declare Function SetPixel Lib "gdi32" (ByVal hdc As Long, ByVal X As Long, ByVal Y As Long, ByVal crColor As Long) As Long
Declare Function SetPixelV Lib "gdi32" (ByVal hdc As Long, ByVal X As Long, ByVal Y As Long, ByVal crColor As Long) As Long
Declare Function GetWindowsDirectory Lib "kernel32" Alias "GetWindowsDirectoryA" (ByVal lpBuffer As String, ByVal nSize As Long) As Long
Declare Function GetSystemDirectory Lib "kernel32" Alias "GetSystemDirectoryA" (ByVal lpBuffer As String, ByVal nSize As Long) As Long
Declare Function GetOpenFileName Lib "comdlg32.dll" Alias "GetOpenFileNameA" (pOpenfilename As OPENFILENAME) As Long
Declare Function ChooseColor Lib "comdlg32.dll" Alias "ChooseColorA" (pChoosecolor As ChooseColor) As Long
Public Declare Function FindWindowEx Lib "user32" Alias "FindWindowExA" (ByVal HWND1 As Long, ByVal hWnd2 As Long, ByVal lpsz1 As String, ByVal lpsz2 As String) As Long
Public Declare Function SendTBMessage Lib "user32" Alias "SendMessageA" (ByVal hwnd As Long, ByVal wMsg As Long, ByVal wParam As Integer, ByVal lParam As Any) As Long
Public Declare Function SetParent Lib "user32" (ByVal hWndChild As Long, ByVal hWndNewParent As Long) As Long
Public Declare Function SendMessageAny Lib "user32" Alias "SendMessageA" (ByVal hwnd As Long, ByVal Msg As Long, ByVal wParam As Long, lParam As Any) As Long
Declare Function StretchBlt Lib "gdi32" (ByVal hdc As Long, ByVal X As Long, ByVal Y As Long, ByVal nWidth As Long, ByVal nHeight As Long, ByVal hSrcDC As Long, ByVal xSrc As Long, ByVal ySrc As Long, ByVal nSrcWidth As Long, ByVal nSrcHeight As Long, ByVal dwRop As Long) As Long
Declare Function StretchDIBits Lib "gdi32" (ByVal hdc As Long, ByVal X As Long, ByVal Y As Long, ByVal dx As Long, ByVal dy As Long, ByVal SrcX As Long, ByVal SrcY As Long, ByVal wSrcWidth As Long, ByVal wSrcHeight As Long, lpBits As Any, lpBitsInfo As BITMAPINFO, ByVal wUsage As Long, ByVal dwRop As Long) As Long
Public Const LB_ITEMFROMPOINT = &H1A9 '使列表中光标移动到不同的列表项上有不同的提示（ToolTip）
' RECT is used to get the size of the panel we're inserting into
Public Type RECT
    Left As Long
    Top As Long
    Right As Long
    Bottom As Long
End Type
Public Const WM_USER = &H400
Public Const SB_GETRECT As Long = (WM_USER + 10)


Public Const TBSTYLE_FLAT = &H800
Public Const TBSTYLE_TRANSPARENT = &H8000
Public Const TB_SETSTYLE = (WM_USER + 56)
Public Const TB_GETSTYLE = (WM_USER + 57)

Type ChooseColor
     lStructSize As Long
     hwndOwner As Long
     hInstance As Long
     rgbResult As Long
     lpCustColors As String
     flags As Long
     lCustData As Long
     lpfnHook As Long
     lpTemplateName As String
End Type
Type OPENFILENAME
     lStructSize As Long
     hwndOwner As Long
     hInstance As Long
     lpstrFilter As String
     lpstrCustomFilter As String
     nMaxCustFilter As Long
     nFilterIndex As Long
     lpstrFile As String
     nMaxFile As Long
     lpstrFileTitle As String
     nMaxFileTitle As Long
     lpstrInitialDir As String
     lpstrTitle As String
     flags As Long
     nFileOffset As Integer
     nFileExtension As Integer
     lpstrDefExt As String
     lCustData As Long
     lpfnHook As Long
     lpTemplateName As String
End Type
'分割菜单
Type MENUITEMINFO
cbSize As Long
fMask As Long
fType As Long
fState As Long
wID As Long
hSubMenu As Long
hbmpChecked As Long
hbmpUnchecked As Long
dwItemData As Long
dwTypeData As String
cch As Long
End Type
Declare Function GetMenu Lib "user32" (ByVal hwnd As Long) As Long
Declare Function GetMenuItemCount Lib "user32" (ByVal hMenu As Long) As Long
Declare Function GetSubMenu Lib "user32" (ByVal hMenu As Long, ByVal nPos As Long) As Long
Declare Function GetMenuItemInfo Lib "user32" Alias "GetMenuItemInfoA" (ByVal hMenu As Long, ByVal un As Long, ByVal b As Boolean, lpmii As MENUITEMINFO) As Long
Declare Function SetMenuItemInfo Lib "user32" Alias "SetMenuItemInfoA" (ByVal hMenu As Long, ByVal uItem As Long, ByVal fByPosition As Long, lpmii As MENUITEMINFO) As Long
Public Const MIIM_TYPE = &H10
Public Const RGB_STARTNEWCOLUMNWITHVERTBAR = &H20&
Public Const MFT_STRING = &H0&
Public Const GWL_WNDPROC = (-4)
Public Const WM_COMMAND = &H111
Public Const WM_MBUTTONDOWN = &H207
Public Const WM_MBUTTONUP = &H208
Public Const WM_MOUSEWHEEL = &H20A
 '支持滚轮的滚动
Public Oldwinproc   As Long
Public Declare Function SetWindowLong Lib "user32" Alias "SetWindowLongA" (ByVal hwnd As Long, ByVal nIndex As Long, ByVal dwNewLong As Long) As Long
Public Declare Function CallWindowProc Lib "user32" Alias "CallWindowProcA" (ByVal lpPrevWndFunc As Long, ByVal hwnd As Long, ByVal Msg As Long, ByVal wParam As Long, ByVal lParam As Long) As Long
Public Declare Function GetWindowLong Lib "user32" Alias "GetWindowLongA" (ByVal hwnd As Long, ByVal nIndex As Long) As Long
'限制鼠标在某一区域移动
Declare Function ClipCursor Lib "user32" (lpRect As Any) As Long
Declare Function ClipCursorClear Lib "user32" Alias "ClipCursor" (ByVal lpRect As Long) As Long
Declare Function ClientToScreen Lib "user32" (ByVal hwnd As Long, lpPoint As POINTAPI) As Long


Public RetValue As Long
Public ClipMode As Boolean
Public Declare Function sndPlaySound Lib "winmm.dll" Alias "sndPlaySoundA" (ByVal lpszSoundName As String, ByVal uFlags As Long) As Long
Public Const SND_SYNC = &H0
Public Const SND_ASYNC = &H1
Public Const SND_NODEFAULT = &H2
Public Const SND_LOOP = &H8
Public Const SND_NOSTOP = &H10


Public Sub SetCursor(ClipObject As Object, Setting As Boolean)
' used to clip the cursor into the viewport and
' turn off the default windows cursor
Dim CurrentPoint As POINTAPI
Dim ClipRect As RECT
If Setting = False Then
' set clip state back to normal
RetValue = ClipCursorClear(0)
Exit Sub
End If
' set current position
With CurrentPoint
.X = 0
.Y = 0
End With
' find position on the screen (not the window)
RetValue = ClientToScreen(ClipObject.hwnd, CurrentPoint)
' designate clip area
With ClipRect
.Top = CurrentPoint.Y
.Left = CurrentPoint.X
.Right = .Left + ClipObject.Width / 15.3
.Bottom = .Top + ClipObject.Height / 15.3
End With ' clip it
RetValue = ClipCursor(ClipRect)
End Sub
Public Function FlexScroll(ByVal hwnd As Long, ByVal wMsg As Long, ByVal wParam As Long, ByVal lParam As Long) As Long
'支持滚轮的滚动  Yu  2004-5-10  15:33
Select Case wMsg
    Case WM_MOUSEWHEEL
        Select Case wParam
                      Case -7864320     '向下滚
                                SendKeys "{PGDN}"
    
                      Case 7864320       '向上滚
                                SendKeys "{PGUP}"
        End Select
End Select
FlexScroll = CallWindowProc(Oldwinproc, hwnd, wMsg, wParam, lParam)
End Function
'在窗体中添加一个命令按钮，Caption=“分割菜单”，双击写如下代码：
Public Sub SplitMenu(HWND1 As Long)
Dim rv As Long
Dim hSubMenu As Long
Dim mnuItemCount As Long
Dim mInfo As MENUITEMINFO
Dim Pad As Long
'获取菜单项句柄和子菜单项数
hSubMenu = GetSubMenu(GetMenu(HWND1), 5)
hSubMenu = GetSubMenu(hSubMenu, 1)
mnuItemCount = GetMenuItemCount(hSubMenu)
'将子菜单项分成两部分
If mnuItemCount Mod 2 <> 0 Then Pad = 1
'取得当前菜单信息
mInfo.cbSize = Len(mInfo)
mInfo.fMask = MIIM_TYPE
mInfo.fType = MFT_STRING
mInfo.dwTypeData = Space$(256)
mInfo.cch = Len(mInfo.dwTypeData)
rv = GetMenuItemInfo(hSubMenu, (mnuItemCount \ 2) + Pad, True, mInfo)
'按新格式显示菜单
mInfo.fType = RGB_STARTNEWCOLUMNWITHVERTBAR
mInfo.fMask = MIIM_TYPE
rv = SetMenuItemInfo(hSubMenu, (mnuItemCount \ 2) + Pad, True, mInfo)
'If rv Then MsgBox "分割完毕"
End Sub

Public Sub SetComboHeight(ComboBox_Obj As ComboBox, newHeight As Long)
  Dim oldscalemode As Integer
  If TypeOf ComboBox_Obj.Parent Is Frame Then Exit Sub
  oldscalemode = ComboBox_Obj.Parent.ScaleMode
  ComboBox_Obj.Parent.ScaleMode = vbPixels
  MoveWindow ComboBox_Obj.hwnd, ComboBox_Obj.Left, ComboBox_Obj.Top, ComboBox_Obj.Width, newHeight, 1
  ComboBox_Obj.Parent.ScaleMode = oldscalemode
End Sub
Public Sub SetComboWidth(ComboBox_Obj As ComboBox, newWidth As Long)
SendMessage ComboBox_Obj.hwnd, CB_SETDROPPEDWIDTH, newWidth, 0
End Sub


Public Sub MakeToolbarFlat(theToolbar As Control)

    Dim Res As Long
    Dim Style As Long

    Style = SendTBMessage(FindWindowEx(theToolbar.hwnd, 0&, "ToolbarWindow32", vbNullString), TB_GETSTYLE, 0&, 0&)
    Style = Style Or TBSTYLE_FLAT Or TBSTYLE_TRANSPARENT
    Res = SendTBMessage(FindWindowEx(theToolbar.hwnd, 0&, "ToolbarWindow32", vbNullString), TB_SETSTYLE, 0, Style)

    theToolbar.Refresh

End Sub

