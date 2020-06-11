VERSION 5.00
Begin VB.Form frmSelectMap 
   Caption         =   "贴图查看/编辑"
   ClientHeight    =   7320
   ClientLeft      =   60
   ClientTop       =   345
   ClientWidth     =   4815
   BeginProperty Font 
      Name            =   "Times New Roman"
      Size            =   9
      Charset         =   0
      Weight          =   400
      Underline       =   0   'False
      Italic          =   0   'False
      Strikethrough   =   0   'False
   EndProperty
   LinkTopic       =   "Form1"
   MDIChild        =   -1  'True
   ScaleHeight     =   488
   ScaleMode       =   3  'Pixel
   ScaleWidth      =   321
   Begin VB.HScrollBar HScroll1 
      Height          =   255
      Left            =   0
      TabIndex        =   9
      Top             =   7080
      Width           =   4575
   End
   Begin VB.ComboBox ComboFilename 
      Height          =   345
      Left            =   1680
      Style           =   2  'Dropdown List
      TabIndex        =   8
      Top             =   0
      Width           =   2895
   End
   Begin VB.CommandButton cmdShow 
      Caption         =   "贴图查看"
      Height          =   375
      Left            =   3600
      TabIndex        =   7
      Top             =   360
      Width           =   975
   End
   Begin VB.TextBox txtGRP 
      Height          =   270
      Left            =   1920
      TabIndex        =   6
      Top             =   360
      Width           =   1095
   End
   Begin VB.TextBox txtIDX 
      Height          =   270
      Left            =   360
      TabIndex        =   5
      Top             =   360
      Width           =   1095
   End
   Begin VB.ComboBox Combo1 
      Height          =   345
      ItemData        =   "frmSelectMap.frx":0000
      Left            =   840
      List            =   "frmSelectMap.frx":000A
      Style           =   2  'Dropdown List
      TabIndex        =   2
      Top             =   0
      Width           =   855
   End
   Begin VB.VScrollBar VScroll1 
      Height          =   6375
      Left            =   4560
      TabIndex        =   1
      Top             =   720
      Width           =   255
   End
   Begin VB.PictureBox Pic1 
      AutoRedraw      =   -1  'True
      BackColor       =   &H8000000B&
      BeginProperty Font 
         Name            =   "宋体"
         Size            =   9
         Charset         =   134
         Weight          =   400
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Height          =   6375
      Left            =   0
      ScaleHeight     =   421
      ScaleMode       =   3  'Pixel
      ScaleWidth      =   301
      TabIndex        =   0
      Top             =   720
      Width           =   4575
   End
   Begin VB.Label Label3 
      Caption         =   "每行贴图"
      Height          =   255
      Left            =   0
      TabIndex        =   10
      Top             =   0
      Width           =   855
   End
   Begin VB.Label Label2 
      Caption         =   "GRP"
      Height          =   255
      Left            =   1560
      TabIndex        =   4
      Top             =   360
      Width           =   375
   End
   Begin VB.Label Label1 
      Caption         =   "IDX"
      Height          =   255
      Left            =   0
      TabIndex        =   3
      Top             =   360
      Width           =   495
   End
End
Attribute VB_Name = "frmSelectMap"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Option Explicit

Private X_num  As Long            ' pic中显示的每行每列贴图个数
Private Y_num  As Long

Private XWidth(10) As Long        ' pic中每行贴图最大高和每列最大宽
Private YHeight(30) As Long


Private Current_startpic As Long   ' pic 左上角贴图编号
Private current_X As Long          ' 鼠标在pic中贴图位置编号
Private current_Y As Long

Private MapPic() As RLEPic         ' 贴图数据
Private Mappicnum As Long          ' 贴图个数

Private ReadPic As Boolean

Private copyPicnum As Long         ' 复制的贴图编号

Public Sub cmdshow_Click()
Dim fileid As String
Dim filepic As String
    If txtIDX.Text = "" Or txtGRP = "" Then Exit Sub
    fileid = G_Var.JYPath & txtIDX
    filepic = G_Var.JYPath & txtGRP
    
    Call LoadPicFile(fileid, filepic, MapPic, Mappicnum)
    ReadPic = True
    Combo1.ListIndex = 0
    Combo1_click
    copyPicnum = -1
End Sub

Private Sub Combo1_click()
    Select Case Combo1.ListIndex
    Case 0
        X_num = 10
        VScroll1.LargeChange = 5
    Case 1
        X_num = 5
        VScroll1.LargeChange = 3
    Case 2
    
    End Select
    Current_startpic = 0
    VScroll1.Max = Mappicnum \ X_num
    VScroll1.SmallChange = 1
    VScroll1.Value = 0
    Showpic (0)
End Sub



Private Sub ComboFilename_click()
Dim tmpstr() As String
    If ComboFilename.ListIndex = -1 Then Exit Sub
    tmpstr = Split(ComboFilename.Text, ",")
    txtIDX.Text = Trim(tmpstr(0))
    txtGRP.Text = Trim(tmpstr(1))
End Sub



Private Sub Form_Load()
Dim i As Long
Dim tmpstr As String
    Me.Caption = StrUnicode(Me.Caption)
    For i = 0 To Me.Controls.Count - 1
        Call SetCaption(Me.Controls(i))
    Next i
    
    ReadPic = False
    
    Combo1.ListIndex = 0
    Combo1_click
            
    ComboFilename.Clear
    For i = 0 To GetINILong("File", "Filenumber") - 1
        ComboFilename.AddItem GetINIStr("File", "File" & i)
    Next i
    tmpstr = GetINIStr("File", "FightName")
    For i = 0 To GetINILong("FIle", "FightNum") - 1
        ComboFilename.AddItem Replace(tmpstr, "***", Format(i, "000"))
    Next i
    
    Me.Width = Me.ScaleX(400, vbPixels, vbTwips)
    Me.height = Me.ScaleY(400, vbPixels, vbTwips)

    MDIMain.StatusBar1.Panels(1).Text = StrUnicode2("鼠标右键激活菜单/拖放到其它窗口复制贴图")
    copyPicnum = -1
End Sub

' flag =0 重新计算xy
' flag =1 不计算，用于鼠标和水平滚动
Private Sub Showpic(flag As Long)
Dim i As Long
    If ReadPic = True Then
        pic1.Cls
        If flag = 0 Then Gen_XY
        Draw_pic
    End If
End Sub


' 计算绘大地图显示贴图宽高
Public Sub Gen_XY()
Dim i As Long, j As Long
Dim picnum As Long
Dim tmpHeight As Long
Dim WidthMax As Long
    j = 0
    tmpHeight = 0
    Do             ' 计算每行图片的最大高度以及总共显示行数
        YHeight(j) = 50        ' 初始高度
        For i = 0 To X_num - 1
            picnum = j * X_num + i + Current_startpic
            If picnum >= 0 And picnum < Mappicnum Then
                If YHeight(j) < MapPic(picnum).height Then
                    YHeight(j) = MapPic(picnum).height
                End If
            End If
        Next i
        tmpHeight = tmpHeight + YHeight(j)
        If tmpHeight > pic1.height Then Exit Do
        j = j + 1
    Loop
    
    Y_num = j + 1
    
    For i = 0 To X_num - 1             ' 计算每列图片最大宽度
        XWidth(i) = pic1.Width / X_num  ' 初始宽度
        For j = 0 To Y_num - 1
            If picnum >= 0 And picnum < Mappicnum Then
                picnum = j * X_num + i + Current_startpic
                If XWidth(i) < MapPic(picnum).Width Then
                    XWidth(i) = MapPic(picnum).Width
                End If
            End If
        Next j
    Next i
    
    WidthMax = 0
    For i = 0 To X_num - 1
       WidthMax = WidthMax + XWidth(i)
    Next i
    HScroll1.Min = 0
    If WidthMax > pic1.Width Then
        HScroll1.Max = WidthMax - pic1.Width
    Else
        HScroll1.Max = 0
    End If
    HScroll1.SmallChange = 1
    HScroll1.LargeChange = 5
    HScroll1.Value = 0
End Sub

Public Sub Draw_pic()
Dim RangeX As Long, rangeY As Long
Dim i As Long, j As Long
Dim i1 As Long, j1 As Long
Dim x1 As Long, Y1 As Long
Dim picnum As Long

    
Dim copmDC As Long
Dim binfo As BITMAPINFO
Dim DIBSectionHandle As Long    ' Handle to DIBSection
Dim OldCompDCBM As Long         ' Original bitmap for CompDC
Dim CompDC As Long
Dim addr As Long
Dim temp As Long
Dim lineSize As Long

    CompDC = CreateCompatibleDC(0)
    With binfo.bmiHeader
        .biSize = 40
        .biWidth = pic1.Width
        .biHeight = -pic1.height
        .biPlanes = 1
        .biBitCount = 32
        .biCompression = 0
        lineSize = .biWidth * 4
        .biSizeImage = -lineSize * .biHeight
    End With
    
    DIBSectionHandle = CreateDIBSection(CompDC, binfo, 0, addr, 0, 0)
    OldCompDCBM = SelectObject(CompDC, DIBSectionHandle)
    
    
    pic1.BackColor = MASKCOLOR
    temp = BitBlt(CompDC, 0, 0, pic1.Width, pic1.height, pic1.hdc, 0, 0, &HCC0020)
    

     Y1 = 0
     For j = 0 To Y_num - 1
        x1 = 0
        For i = 0 To X_num - 1
            picnum = j * X_num + i + Current_startpic
                If picnum >= 0 And picnum < Mappicnum Then
                    Call genPicData(MapPic(picnum), addr, binfo.bmiHeader.biWidth, -binfo.bmiHeader.biHeight, x1 - HScroll1.Value, Y1 + 10)
                End If
            x1 = x1 + XWidth(i)
        Next i
        Y1 = Y1 + YHeight(j)
    Next j
    
    
    temp = BitBlt(pic1.hdc, 0, 0, pic1.Width, pic1.height, CompDC, 0, 0, &HCC0020)
   
     pic1.ForeColor = vbYellow
     Y1 = 0
     For j = 0 To Y_num - 1
        x1 = 0
        For i = 0 To X_num - 1
            picnum = j * X_num + i + Current_startpic
                
            If picnum >= 0 And picnum < Mappicnum Then
                Call genPicData(MapPic(picnum), addr, binfo.bmiHeader.biWidth, -binfo.bmiHeader.biHeight, x1 - HScroll1.Value, Y1 + 10)
                pic1.CurrentX = x1 - HScroll1.Value
                pic1.CurrentY = Y1
                pic1.Print picnum
                If i = current_X And j = current_Y Then
                    pic1.Line (x1 - HScroll1.Value, Y1)-(x1 - HScroll1.Value + XWidth(i), Y1 + YHeight(j)), vbRed, B
                End If
            End If
            x1 = x1 + XWidth(i)
        Next i
        Y1 = Y1 + YHeight(j)
    Next j
   
       
    temp = GetLastError()
    temp = SelectObject(CompDC, OldCompDCBM)
    temp = DeleteDC(CompDC)
    temp = DeleteObject(DIBSectionHandle)


End Sub


Private Sub Form_Resize()
    On Error Resume Next
    If Me.ScaleWidth < 300 Then
        Me.Width = Me.ScaleX(300, vbPixels, vbTwips)
    End If
    pic1.Width = Me.ScaleWidth - VScroll1.Width
    HScroll1.Width = pic1.Width
    VScroll1.Left = pic1.Width
    
    If Me.ScaleHeight < 400 Then
          Me.height = Me.ScaleY(400, vbPixels, vbTwips)
    End If
    pic1.height = Me.ScaleHeight - HScroll1.height - pic1.Top
    VScroll1.height = pic1.height
    HScroll1.Top = pic1.Top + pic1.height
    Showpic 0
      
End Sub

Private Sub HScroll1_Change()
     Showpic (1)
End Sub




Private Sub Pic1_Click()
    PopupMenu MDIMain.mnu_Selectmap
End Sub



Private Sub Pic1_MouseMove(Button As Integer, Shift As Integer, x As Single, Y As Single)
Dim i As Long
Dim j As Long
Dim x1 As Long, Y1 As Long
Dim n As Long
    x1 = 0 - HScroll1.Value
    For i = 0 To X_num - 1
        x1 = x1 + XWidth(i)
        If x1 > x Then
            current_X = i
            Exit For
        End If
    Next i
    
    Y1 = 0
    For i = 0 To Y_num - 1
        Y1 = Y1 + YHeight(i)
        If Y1 > Y Then
            current_Y = i
            Exit For
        End If
    Next i
    
    
    Showpic (1)
    ' 左按钮按下 则启动拖动
    If (Button And vbLeftButton) > 0 Then
        pic1.OLEDrag
    End If
    n = Current_startpic + current_Y * X_num + current_X
    If n >= 0 And n < Mappicnum Then
        MDIMain.StatusBar1.Panels(2).Text = StrUnicode2("贴图" & n & " 宽" & MapPic(n).Width & _
                   "高" & MapPic(n).height & "X" & MapPic(n).x & "Y" & MapPic(n).Y & _
                    IIf(MapPic(n).isEmpty, "空贴图", ""))
    End If
End Sub

Private Sub Pic1_OLEStartDrag(Data As DataObject, AllowedEffects As Long)
Dim n As Long
    n = Current_startpic + current_Y * X_num + current_X
    If n >= 0 And n < Mappicnum Then
        Data.SetData txtGRP.Text & ":" & CStr(n), vbCFText
        AllowedEffects = vbDropEffectCopy
    End If
    
End Sub

Private Sub VScroll1_Change()
    Current_startpic = VScroll1.Value * X_num
    Showpic (0)
End Sub



Public Sub ClickMenu(id As String)
Dim n As Long
    n = Current_startpic + current_Y * X_num + current_X
    Select Case LCase(id)
    Case "edit"
        Load frmPicEdit
    If n <= 0 Or n > Mappicnum Then
       Exit Sub
    End If
        g_PP = MapPic(n)
        frmPicEdit.Showpic
        frmPicEdit.Show vbModal
        If frmPicEdit.Yes = 1 Then
            MapPic(n) = g_PP
            Showpic (0)
        End If
        
    Case "copy"
        copyPicnum = n
    Case "paste"
        PastePic
    Case "add"
        Mappicnum = Mappicnum + 1
        ReDim Preserve MapPic(Mappicnum - 1)
        Showpic (1)
        MapPic(Mappicnum - 1).isEmpty = True
    Case "delete"
        Mappicnum = Mappicnum - 1
        ReDim Preserve MapPic(Mappicnum - 1)
        Showpic (1)
    Case "save"
        SavePic
    End Select

End Sub

Private Sub PastePic()
Dim i As Long
Dim n As Long
    If copyPicnum < 0 Or copyPicnum >= Mappicnum Then Exit Sub
    n = Current_startpic + current_Y * X_num + current_X
    If MapPic(copyPicnum).isEmpty = False Then
        MapPic(n) = MapPic(copyPicnum)
    End If
    Showpic (1)
End Sub


' 保存贴图
Private Sub SavePic()
Dim fileid As String
Dim filepic As String
Dim filenumID As Long, filenumPic As Long
Dim i As Long
Dim offset As Long
Dim Idx() As Long
    If txtIDX.Text = "" Or txtGRP = "" Then Exit Sub
    fileid = G_Var.JYPath & txtIDX
    filepic = G_Var.JYPath & txtGRP
    
    ReDim Idx(Mappicnum)
    filenumPic = OpenBin(filepic, "WN")
    
    For i = 0 To Mappicnum - 1
        Idx(i + 1) = 0
        If MapPic(i).isEmpty = False Then
            Put #filenumPic, , MapPic(i).Width
            Put #filenumPic, , MapPic(i).height
            Put #filenumPic, , MapPic(i).x
            Put #filenumPic, , MapPic(i).Y
            Put #filenumPic, , MapPic(i).Data
        End If
        offset = Loc(filenumPic)
        Idx(i + 1) = offset
    Next i
    Close #filenumPic
    
    '  处理空贴图id指针指向下一个贴图。
    For i = Mappicnum To 1 Step -1
        If Idx(i) = 0 Then
            Idx(i) = Idx(i + 1)
        End If
    Next i
    
    filenumID = OpenBin(fileid, "WN")
        For i = 1 To Mappicnum
            Put #filenumID, , Idx(i)
        Next i
    Close #filenumID
End Sub
