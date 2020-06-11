Attribute VB_Name = "basStatusBar"
Option Explicit

Private Const WS_CHILD As Long = &H40000000             'WS_CHILD 和WS_VISIBLE是必需函数
Private Const WS_VISIBLE As Long = &H10000000
Private Const WM_USER As Long = &H400
Private Const SB_SETPARTS As Long = (WM_USER + 4)       '这两个常数在VB自带的api查询器里没有，需要手工添加
Private Const SB_SETTEXTA As Long = (WM_USER + 1)
Private Declare Function CreateStatusWindow Lib "comctl32.dll" (ByVal style As Long, ByVal lpszText As String, ByVal hwndParent As Long, ByVal wID As Long) As Long
Private Declare Function SendMessage Lib "user32.dll" Alias "SendMessageA" (ByVal hwnd As Long, ByVal wMsg As Long, ByVal wParam As Long, ByRef lParam As Any) As Long
Private Declare Function MoveWindow Lib "user32.dll" (ByVal hwnd As Long, ByVal x As Long, ByVal y As Long, ByVal nWidth As Long, ByVal nHeight As Long, ByVal bRepaint As Long) As Long

'--------------------------------------------------
'
'                       创建状态栏
'函数说明：
'ParenthWnd　　状态栏所属的句柄
'IDC_STATBAR   状态栏的ID号，用于对状态栏的单击之类的操作
'hBarWin       函数返回状态栏的句柄
'szText        要显示的信息
'
'---------------------------------------------------
Public Function CreateStatBar(ParenthWnd As Long, IDC_STATBAR As Long, hBarWin As Long, Optional szText As String = "Demo") As Boolean
    Dim ret As Long                 '返回值
    Dim bar(0 To 1) As Long         '分栏的各项位置
    Dim szbar As Long               '分栏的数目
   
'-------------------------------------------------------
'定义数组
    bar(0) = 235                    '第一栏宽度为245
    bar(1) = -1                     '-1表示后面的分为一栏
   
'-------------------------------------------------------www.想自杀chinai tp ow er.comrK25Hny

    ret = CreateStatusWindow(WS_CHILD Or WS_VISIBLE, ByVal szText, ParenthWnd, IDC_STATBAR)     '创建状态栏
    szbar = 2
    If ret = 0 Then                 '如果创建失败则退出过程
        CreateStatBar = False
        Exit Function
    End If
    hBarWin = ret                   '返回状态栏的句柄
    CreateStatBar = True            '创建成功返回真值
End Function


Public Sub SetStatBar(hbar As Long, szbar As Long, bar() As Long)
    If szbar > 1 Then               '因为默认就是分一栏所以，这里判断为大于1就是分栏
        SendMessage hbar, SB_SETPARTS, szbar, bar(0)    '分栏
    End If
End Sub
'----------------------------
'移动状态栏
'----------------------------
Public Sub MoveStatWindow(hbar As Long)
If hbar Then                '如果状态栏句柄不为0则移动
    Call MoveWindow(hbar, 0, 0, 0, 0, True)
End If
End Sub

'------------------------------
'在指定栏上显示信息
'hBar 为状态栏的句柄
'szbar 指定要在哪一栏显示信息，从0开始计，也就是说，如果分两栏，我们要在第二栏里显示信息，szbar就设置为1
'szText 要显示的信息
'-------------------------------
Public Sub SetBarText(hbar As Long, szbar As Long, strText As String)
    SendMessage hbar, SB_SETTEXTA, szbar, ByVal strText
End Sub

