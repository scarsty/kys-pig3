VERSION 5.00
Object = "{831FDD16-0C5C-11D2-A9FC-0000F8754DA1}#2.0#0"; "MSCOMCTL.OCX"
Begin VB.MDIForm MDIFormMain 
   BackColor       =   &H8000000C&
   Caption         =   "金庸群俠傳多功能編輯器(未找到遊戲)"
   ClientHeight    =   6870
   ClientLeft      =   165
   ClientTop       =   450
   ClientWidth     =   8865
   Icon            =   "MDIFormMain.frx":0000
   LinkTopic       =   "MDIForm1"
   StartUpPosition =   2  '屏幕中心
   WindowState     =   2  'Maximized
   Begin MSComctlLib.ProgressBar ProgressBar1 
      Align           =   2  'Align Bottom
      Height          =   255
      Left            =   0
      TabIndex        =   1
      Top             =   6315
      Width           =   8865
      _ExtentX        =   15637
      _ExtentY        =   450
      _Version        =   393216
      Appearance      =   1
   End
   Begin MSComctlLib.StatusBar StatusBar1 
      Align           =   2  'Align Bottom
      Height          =   300
      Left            =   0
      TabIndex        =   0
      Top             =   6570
      Width           =   8865
      _ExtentX        =   15637
      _ExtentY        =   529
      _Version        =   393216
      BeginProperty Panels {8E3867A5-8586-11D1-B16A-00C0F0283628} 
         NumPanels       =   7
         BeginProperty Panel1 {8E3867AB-8586-11D1-B16A-00C0F0283628} 
            Object.Width           =   9349
            MinWidth        =   9349
         EndProperty
         BeginProperty Panel2 {8E3867AB-8586-11D1-B16A-00C0F0283628} 
            Object.Width           =   2117
            MinWidth        =   2117
         EndProperty
         BeginProperty Panel3 {8E3867AB-8586-11D1-B16A-00C0F0283628} 
            Object.Width           =   1764
            MinWidth        =   1764
         EndProperty
         BeginProperty Panel4 {8E3867AB-8586-11D1-B16A-00C0F0283628} 
            Object.Width           =   1411
            MinWidth        =   1411
         EndProperty
         BeginProperty Panel5 {8E3867AB-8586-11D1-B16A-00C0F0283628} 
            Object.Width           =   1764
            MinWidth        =   1764
         EndProperty
         BeginProperty Panel6 {8E3867AB-8586-11D1-B16A-00C0F0283628} 
            Object.Width           =   1411
            MinWidth        =   1411
         EndProperty
         BeginProperty Panel7 {8E3867AB-8586-11D1-B16A-00C0F0283628} 
            Object.Width           =   2822
            MinWidth        =   2822
         EndProperty
      EndProperty
      BeginProperty Font {0BE35203-8F91-11CE-9DE3-00AA004BB851} 
         Name            =   "Times New Roman"
         Size            =   9
         Charset         =   0
         Weight          =   400
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
   End
   Begin VB.Menu mnuFuncView 
      Caption         =   "功能/設置(&O)"
      Begin VB.Menu nmuSetGamePath 
         Caption         =   "設置遊戲安裝位置"
      End
      Begin VB.Menu mnuSavManager 
         Caption         =   "進度管理"
         Enabled         =   0   'False
      End
      Begin VB.Menu mnuSetGameLanguage 
         Caption         =   "遊戲簡繁轉換"
         Enabled         =   0   'False
      End
      Begin VB.Menu mnuExit 
         Caption         =   "退出(&X)"
      End
   End
   Begin VB.Menu mnuSavEdit 
      Caption         =   "遊戲編輯(&E)"
      Begin VB.Menu mnuEditRx 
         Caption         =   "遊戲基本進度"
      End
      Begin VB.Menu mnuSavEditLine1 
         Caption         =   "-"
      End
      Begin VB.Menu mnuEditSx 
         Caption         =   "場景地圖/事件"
      End
      Begin VB.Menu mnuEvent1 
         Caption         =   "事件/对话"
         Enabled         =   0   'False
      End
      Begin VB.Menu mnu 
         Caption         =   "战斗地图"
         Enabled         =   0   'False
      End
      Begin VB.Menu mnuEarth 
         Caption         =   "外景地图"
         Enabled         =   0   'False
      End
   End
   Begin VB.Menu mnuPicEdit 
      Caption         =   "图像/贴图(&P)"
      Begin VB.Menu mnuTileEdit 
         Caption         =   "貼圖資源"
      End
      Begin VB.Menu mnuPicEditLine1 
         Caption         =   "-"
      End
      Begin VB.Menu mnuPicEdit31 
         Caption         =   "片尾全屏動畫"
      End
      Begin VB.Menu mnuPicEditLine3 
         Caption         =   "-"
      End
      Begin VB.Menu mnuCol 
         Caption         =   "调色板"
         Enabled         =   0   'False
      End
   End
   Begin VB.Menu mnuHelp 
      Caption         =   "幫助(&H)"
      Begin VB.Menu mnuReadme 
         Caption         =   "內容(&C)"
      End
      Begin VB.Menu mnuAbout 
         Caption         =   "關於(&A)"
      End
   End
   Begin VB.Menu mnu1 
      Caption         =   "菜单1"
      Visible         =   0   'False
      Begin VB.Menu mnu1MapEdit1 
         Caption         =   "刷新圖層"
         Index           =   0
      End
      Begin VB.Menu mnu1MapEdit1 
         Caption         =   "小地圖"
         Checked         =   -1  'True
         Index           =   1
      End
      Begin VB.Menu mnu1MapEdit1 
         Caption         =   "複制到剪貼板"
         Index           =   2
      End
      Begin VB.Menu mnu1MapEdit1 
         Caption         =   "Windows畫圖"
         Index           =   3
      End
      Begin VB.Menu mnu1MapEdit1 
         Caption         =   "允許編輯"
         Checked         =   -1  'True
         Index           =   4
      End
      Begin VB.Menu mnu1MapEdit1 
         Caption         =   "顯示事件標記"
         Checked         =   -1  'True
         Index           =   5
      End
      Begin VB.Menu mnu1MapEdit1 
         Caption         =   "貼圖選擇器"
         Enabled         =   0   'False
         Index           =   6
      End
      Begin VB.Menu mnu1_layer1 
         Caption         =   "圖層"
         Begin VB.Menu mnu1_Layer 
            Caption         =   "0層(地表)"
            Checked         =   -1  'True
            Index           =   0
         End
         Begin VB.Menu mnu1_Layer 
            Caption         =   "1層(建築/植物)"
            Checked         =   -1  'True
            Index           =   1
         End
         Begin VB.Menu mnu1_Layer 
            Caption         =   "2層(空中)"
            Checked         =   -1  'True
            Index           =   2
         End
         Begin VB.Menu mnu1_Layer 
            Caption         =   "3層(事件)"
            Checked         =   -1  'True
            Index           =   3
         End
         Begin VB.Menu mnu1_Layer 
            Caption         =   "4層(Y偏移對應1/3層)"
            Enabled         =   0   'False
            Index           =   4
         End
         Begin VB.Menu mnu1_Layer 
            Caption         =   "5層(Y偏移對應2層)"
            Enabled         =   0   'False
            Index           =   5
         End
      End
      Begin VB.Menu mnu1_Grid1 
         Caption         =   "網格"
         Begin VB.Menu mnu1_Grid 
            Caption         =   "不顯示"
            Checked         =   -1  'True
            Index           =   0
         End
         Begin VB.Menu mnu1_Grid 
            Caption         =   "網格顔色"
            Enabled         =   0   'False
            Index           =   1
         End
         Begin VB.Menu mnu1_Grid 
            Caption         =   "4X"
            Index           =   2
         End
         Begin VB.Menu mnu1_Grid 
            Caption         =   "8X"
            Index           =   3
         End
         Begin VB.Menu mnu1_Grid 
            Caption         =   "16X"
            Index           =   4
         End
         Begin VB.Menu mnu1_Grid 
            Caption         =   "32X"
            Index           =   5
         End
         Begin VB.Menu mnu1_Grid 
            Caption         =   "64X"
            Index           =   6
         End
         Begin VB.Menu mnu1_Grid 
            Caption         =   "128X"
            Index           =   7
         End
      End
      Begin VB.Menu mnu1_Line1 
         Caption         =   "-"
      End
      Begin VB.Menu mnu1_Jindu1 
         Caption         =   "取進度"
         Begin VB.Menu mnu1_Jindu 
            Caption         =   "進度一"
            Checked         =   -1  'True
            Index           =   0
         End
         Begin VB.Menu mnu1_Jindu 
            Caption         =   "進度二"
            Index           =   1
         End
         Begin VB.Menu mnu1_Jindu 
            Caption         =   "進度三"
            Index           =   2
         End
      End
      Begin VB.Menu mnu1_Line2 
         Caption         =   "-"
      End
      Begin VB.Menu mnu1MapEdit2 
         Caption         =   "保存當前場景"
         Index           =   0
      End
      Begin VB.Menu mnu1MapEdit2 
         Caption         =   "關閉地圖編輯器"
         Index           =   1
      End
   End
   Begin VB.Menu mnu2 
      Caption         =   "菜单2"
      Visible         =   0   'False
      Begin VB.Menu mnu2_RxEdit1 
         Caption         =   "刷新显示"
         Index           =   0
      End
      Begin VB.Menu mnu2_RxEdit1 
         Caption         =   "数字显示十六进制"
         Enabled         =   0   'False
         Index           =   1
      End
      Begin VB.Menu mnu2_RxEdit1 
         Caption         =   "Windows计算器"
         Index           =   2
      End
      Begin VB.Menu mnu2_RxEdit1 
         Caption         =   "取进度..."
         Index           =   3
      End
      Begin VB.Menu mnu2_RxEdit1 
         Caption         =   "保存..."
         Index           =   4
      End
      Begin VB.Menu mnu2_RxEdit1 
         Caption         =   "关闭"
         Index           =   5
      End
      Begin VB.Menu mnu2_Line1 
         Caption         =   "-"
      End
      Begin VB.Menu mnu2_RxEdit2 
         Caption         =   "物品种类全满"
         Index           =   0
      End
      Begin VB.Menu mnu2_RxEdit2 
         Caption         =   "批量修改物品数量..."
         Index           =   1
      End
      Begin VB.Menu mnu2_Line2 
         Caption         =   "-"
      End
      Begin VB.Menu mnu2_RxEdit3 
         Caption         =   "Simplified(简体中文GBK)"
         Index           =   0
      End
      Begin VB.Menu mnu2_RxEdit3 
         Caption         =   "Traditional(羉砰いゅBIG5)"
         Checked         =   -1  'True
         Index           =   1
      End
   End
End
Attribute VB_Name = "MDIFormMain"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Option Explicit


Private Sub MDIForm_Load()
If App.PrevInstance Then
 MsgBox "程序正在運行，請檢查窗口是否被最小化!", vbExclamation, "程序已經運行!"
 Unload Me
 End
End If

ShowProgressInStatusBar True
Call setMenuText
GamePath = GetSetting("jyEditor", "startup", "gamepath", "")
If GamePath = "" Then
 MsgBox "請先設置遊戲位置，否則無法編輯", vbExclamation, "未設置遊戲路逕"
Else
 Me.Caption = "金庸群俠傳多功能編輯器(遊戲路逕：" & GamePath & ")"
End If

mnuAbout_Click
If MsgBox("是簡體中文用戶嗎？?" & vbCrLf & " Yes=GBK  /  No=BIG5", vbQuestion + vbYesNo) = vbYes Then
  mnu2_RxEdit3(0).Checked = True
  mnu2_RxEdit3(1).Checked = False
End If
Call iniVar(GamePath)
End Sub

Private Sub MDIForm_QueryUnload(Cancel As Integer, UnloadMode As Integer)
Unload Me
End
End Sub

Private Sub MDIForm_Unload(Cancel As Integer)
ShowProgressInStatusBar False
End
End Sub

Private Sub mnu1_refresh_Click()

End Sub







Private Sub mnuAbout_Click()
frmAbout.Show vbModal
End Sub

Private Sub mnuEditRx_Click()
Load frmRxEdit
End Sub

Private Sub mnuEditSx_Click()
'MsgBox "注意:本程序还没完成，不能设置游戏目录，当前默认为读取上一级文件夹中的地图。所以一定要在金庸群侠传游戏文件夹下再建一个文件夹，把本软件(共3个文件)复制到新文件夹下再运行，否则找不到地图！", vbInformation, "安装需知"
 Me.MousePointer = 11
 Load frmMapEdit
 
End Sub

Private Sub mnuExit_Click()
Unload Me
End Sub


Private Sub mnuPicEdit31_Click()
frm320_200View.Show
End Sub

Private Sub mnuReadme_Click()
Shell "notepad " & App.Path & "\readme.txt", vbNormalFocus
End Sub

Private Sub mnuTileEdit_Click()
frmTileEdit.Show
End Sub

Private Sub nmuSetGamePath_Click()
 Dim TempFileName As String, I As Integer, tempStr As String
 'ComDlg1.Filter = "金庸主程序(z.*)|z.*|存档文件(*.grp)|*.grp|所有文件(*.*)|*.*"
 'ComDlg1.flags = 4  '无只读复选
     Dim ofn As OPENFILENAME
    Dim Rtn As String

    ofn.lStructSize = Len(ofn)
    ofn.hwndOwner = Me.hwnd
    ofn.hInstance = App.hInstance
    ofn.lpstrFilter = "金庸主程序(Z.*);存檔文件(*.grp)"  '"金庸主程序(z.*)|z.*|存檔文件(*.grp)|*.grp|所有文件(*.*)|*.*"
    ofn.lpstrFile = Space(254)
    ofn.nMaxFile = 255
    ofn.lpstrFileTitle = Space(254)
    ofn.nMaxFileTitle = 255
    ofn.lpstrInitialDir = App.Path
    ofn.lpstrTitle = "打開金庸遊戲文件"
    ofn.flags = 6148

    Rtn = GetOpenFileName(ofn)

    If Rtn >= 1 Then
        TempFileName = ofn.lpstrFile
    Else
        Exit Sub
    End If
 For I = Len(TempFileName) To 1 Step -1
  If Mid$(TempFileName, I, 1) = "\" Then
   tempStr = Left$(TempFileName, I)
   TempFileName = Right$(TempFileName, Len(TempFileName) - I)
   Exit For
  End If
 Next
 If GamePath = tempStr Then
     MsgBox "還是原來的遊戲目錄嘛，根本沒有變", vbInformation
     Exit Sub
 Else
     GamePath = tempStr
     SaveSetting "jyEditor", "startup", "gamepath", GamePath
     Me.Caption = "金庸群俠傳多功能編輯器(遊戲路逕：" & GamePath & ")"
     MsgBox "注意：改變遊戲目錄後一定要重新啓動一次場景編輯器。", vbExclamation
     Call iniVar(GamePath)
 End If

End Sub

Private Sub ShowProgressInStatusBar(ByVal bShowProgressBar As Boolean)
    Dim tRC As RECT
    If bShowProgressBar Then
        SendMessageAny StatusBar1.hwnd, SB_GETRECT, 1, tRC
        With tRC
            .Top = (.Top * Screen.TwipsPerPixelY)
            .Left = (.Left * Screen.TwipsPerPixelX)
            .Bottom = (.Bottom * Screen.TwipsPerPixelY) - .Top
            .Right = (.Right * Screen.TwipsPerPixelX) - .Left
        End With
        With ProgressBar1
            SetParent .hwnd, StatusBar1.hwnd
            .Move tRC.Left, tRC.Top, 1, tRC.Bottom
            .Visible = False
            .Value = 0
        End With
    Else
        SetParent ProgressBar1.hwnd, Me.hwnd
        ProgressBar1.Visible = False
    End If
End Sub

Private Sub mnu1MapEdit1_Click(Index As Integer) '地图编辑菜单
frmMapEdit.DoWithMenu1 Index
End Sub

Private Sub mnu1_Layer_Click(Index As Integer)
frmMapEdit.DoWithMenu2 Index
End Sub

Private Sub mnu1_Jindu_Click(Index As Integer)
frmMapEdit.DoWithMenu3 Index
End Sub

Private Sub mnu1MapEdit2_Click(Index As Integer)
frmMapEdit.DoWithMenu4 Index
End Sub
Private Sub mnu1_Grid_Click(Index As Integer)
frmMapEdit.DoWithMenu5 Index
End Sub

Private Sub mnu2_RxEdit1_Click(Index As Integer)
frmRxEdit.DoWithMenu1 Index
End Sub
Private Sub mnu2_RxEdit2_Click(Index As Integer)
frmRxEdit.DoWithMenu2 Index
End Sub
Private Sub mnu2_RxEdit3_Click(Index As Integer)
frmRxEdit.DoWithMenu3 Index
End Sub
Private Sub setMenuText()
mnuFuncView.Caption = "功能/設置(&O)"
nmuSetGamePath.Caption = "設置遊戲安裝位置"
mnuExit.Caption = "退出(&X)"
mnuSavEdit.Caption = "遊戲編輯(&E)"
mnuEditRx.Caption = "遊戲基本進度"
mnuEditSx.Caption = "場景地圖/事件"
mnuHelp.Caption = "幫助(&H)"
mnuReadme.Caption = "內容(&C)"
mnuAbout.Caption = "關於(&A)"
mnuPicEdit.Caption = "图像/贴图(&P)"
mnuTileEdit.Caption = "貼圖資源"
mnuPicEdit31.Caption = "標題和片尾全屏動畫"

mnu1MapEdit1(0).Caption = "刷新圖層"
mnu1MapEdit1(1).Caption = "小地圖"
mnu1MapEdit1(2).Caption = "複制到剪貼板"
mnu1MapEdit1(3).Caption = "Windows畫圖"
mnu1MapEdit1(4).Caption = "允許編輯"
mnu1MapEdit1(5).Caption = "顯示事件標記"
mnu1MapEdit1(6).Caption = "貼圖選擇器"
mnu1_layer1.Caption = "圖層"
mnu1_Layer(0).Caption = "0層(地表)"
mnu1_Layer(1).Caption = "1層(建築/植物)"
mnu1_Layer(2).Caption = "2層(空中)"
mnu1_Layer(3).Caption = "3層(事件)"
mnu1_Layer(4).Caption = "4層(Y偏移對應1/3層)"
mnu1_Layer(5).Caption = "5層(Y偏移對應2層)"
mnu1_Grid1.Caption = "網格"
mnu1_Grid(0).Caption = "不顯示"
mnu1_Grid(1).Caption = "網格顔色"
mnu1_Grid(2).Caption = "4X"
mnu1_Grid(3).Caption = "8X"
mnu1_Grid(4).Caption = "16X"
mnu1_Grid(5).Caption = "32X"
mnu1_Grid(6).Caption = "64X"
mnu1_Grid(7).Caption = "128X"
mnu1_Jindu1.Caption = "取進度"
mnu1_Jindu(0).Caption = "進度一"
mnu1_Jindu(1).Caption = "進度二  "
mnu1_Jindu(2).Caption = "進度三"
mnu1MapEdit2(0).Caption = "保存當前場景"
mnu1MapEdit2(1).Caption = "關閉地圖編輯器"

End Sub
