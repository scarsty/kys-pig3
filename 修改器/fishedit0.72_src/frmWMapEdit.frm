VERSION 5.00
Begin VB.Form frmWMapEdit 
   Caption         =   "战斗地图编辑"
   ClientHeight    =   7470
   ClientLeft      =   60
   ClientTop       =   345
   ClientWidth     =   9615
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
   ScaleHeight     =   498
   ScaleMode       =   3  'Pixel
   ScaleWidth      =   641
   Begin VB.Frame Frame1 
      Caption         =   "当前图片"
      Height          =   5415
      Left            =   0
      TabIndex        =   10
      Top             =   1680
      Width           =   1815
      Begin VB.PictureBox PicEarth 
         AutoRedraw      =   -1  'True
         Height          =   615
         Left            =   600
         ScaleHeight     =   555
         ScaleWidth      =   1035
         TabIndex        =   12
         Top             =   240
         Width           =   1095
      End
      Begin VB.PictureBox PicBiuld 
         AutoRedraw      =   -1  'True
         Height          =   1815
         Left            =   600
         ScaleHeight     =   1755
         ScaleWidth      =   1035
         TabIndex        =   11
         Top             =   960
         Width           =   1095
      End
      Begin VB.Label Label1 
         Caption         =   "1地面"
         Height          =   255
         Left            =   120
         TabIndex        =   16
         Top             =   240
         Width           =   615
      End
      Begin VB.Label Label2 
         Caption         =   "2建筑"
         Height          =   255
         Left            =   120
         TabIndex        =   15
         Top             =   960
         Width           =   615
      End
      Begin VB.Label lbl1 
         Caption         =   "0"
         Height          =   255
         Left            =   120
         TabIndex        =   14
         Top             =   480
         Width           =   615
      End
      Begin VB.Label lbl2 
         BackStyle       =   0  'Transparent
         Caption         =   "0"
         Height          =   255
         Left            =   120
         TabIndex        =   13
         Top             =   1200
         Width           =   495
      End
   End
   Begin VB.ComboBox ComboScene 
      Height          =   345
      Left            =   0
      Style           =   2  'Dropdown List
      TabIndex        =   9
      Top             =   0
      Width           =   1695
   End
   Begin VB.HScrollBar HScrollWidth 
      Height          =   255
      Left            =   1800
      TabIndex        =   6
      Top             =   7200
      Width           =   7455
   End
   Begin VB.VScrollBar VScrollHeight 
      Height          =   7335
      Left            =   9240
      Max             =   479
      TabIndex        =   5
      Top             =   0
      Width           =   255
   End
   Begin VB.ComboBox ComboLevel 
      Height          =   345
      ItemData        =   "frmWMapEdit.frx":0000
      Left            =   600
      List            =   "frmWMapEdit.frx":0002
      Style           =   2  'Dropdown List
      TabIndex        =   4
      Top             =   360
      Width           =   1215
   End
   Begin VB.PictureBox PicBak 
      AutoRedraw      =   -1  'True
      BeginProperty Font 
         Name            =   "宋体"
         Size            =   9
         Charset         =   134
         Weight          =   400
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Height          =   375
      Left            =   1320
      ScaleHeight     =   21
      ScaleMode       =   3  'Pixel
      ScaleWidth      =   37
      TabIndex        =   3
      Top             =   720
      Visible         =   0   'False
      Width           =   615
   End
   Begin VB.CommandButton cmdSelectMap 
      Caption         =   "选择贴图"
      Height          =   375
      Left            =   0
      TabIndex        =   1
      Top             =   1200
      Width           =   1095
   End
   Begin VB.PictureBox pic1 
      AutoRedraw      =   -1  'True
      BeginProperty Font 
         Name            =   "宋体"
         Size            =   9
         Charset         =   134
         Weight          =   400
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Height          =   7155
      Left            =   1800
      OLEDropMode     =   1  'Manual
      ScaleHeight     =   473
      ScaleMode       =   3  'Pixel
      ScaleWidth      =   493
      TabIndex        =   0
      Top             =   0
      Width           =   7455
   End
   Begin VB.Label Label7 
      Caption         =   "能否通过"
      Height          =   255
      Index           =   3
      Left            =   0
      TabIndex        =   18
      Top             =   0
      Width           =   735
   End
   Begin VB.Label Label7 
      Caption         =   "能否通过"
      Height          =   255
      Index           =   1
      Left            =   1920
      TabIndex        =   17
      Top             =   720
      Width           =   735
   End
   Begin VB.Label lblMenu 
      Caption         =   "<快捷菜单>"
      ForeColor       =   &H00FF0000&
      Height          =   255
      Left            =   0
      TabIndex        =   8
      Top             =   840
      Width           =   1095
   End
   Begin VB.Label Label5 
      Caption         =   "操作层"
      Height          =   375
      Left            =   0
      TabIndex        =   7
      Top             =   360
      Width           =   735
   End
   Begin VB.Label lblSelectPicNum 
      Caption         =   "0"
      Height          =   255
      Left            =   1200
      TabIndex        =   2
      Top             =   1320
      Width           =   495
   End
End
Attribute VB_Name = "frmWMapEdit"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False

Option Explicit

Private SelectPicNum As Long

Private Const WMapXmax = 64
Private Const WMapYmax = 64

Private WMapPic() As RLEPic
Private WMappicnum As Long

Private ss As Long           ' 当前地图代号

Private Type WarMapDataType
    Data1(WMapXmax - 1, WMapYmax - 1) As Integer
    Data2(WMapXmax - 1, WMapYmax - 1) As Integer
End Type

Private WarMapdata() As WarMapDataType

Private WarIDX() As Long
Private WarMapNum As Long      ' 场景地图个数，注意与r*中的数据不同

Private xx As Long
Private yy As Long

Private MouseX As Long
Private MouseY As Long

Private BlockX1 As Long, BlockY1 As Long     ' 选择块位置
Private BlockX2 As Long, BlockY2 As Long
Private SelectBlock As Long                  ' 0 未选择块，1 选择块

Private iMode As Long                      ' 0 正常   1 块操作  2 删除

Private isGrid As Long                       ' 0 不显示网格 1 显示网格
Private isShowLevel As Long                  ' 0 全部显示   1 只显示操作层
Private isScene As Long                      ' 0 不显示     1 显示场景

Public WarID As Long                         ' 战斗编号




Private Sub cmdSelectMap_Click()
    SelectPicNum = -1
    Load frmSelectMap
    frmSelectMap.txtIDX = G_Var.WarMapIDX
    frmSelectMap.txtGRP = G_Var.WarMapGrp
    frmSelectMap.cmdshow_Click
    frmSelectMap.Show
End Sub



Private Sub showwmap()
    pic1.Cls
    Draw_wmap
    Draw_wmap_2
End Sub


Private Sub ComboLevel_click()
    Set_Note
    showwmap
End Sub


Private Sub ComboScene_click()
    ss = ComboScene.ListIndex
    showwmap
End Sub

Private Sub Form_Load()
Dim filenum As Long
Dim i As Long
Dim fileid As String
Dim filepic As String
    Me.Caption = StrUnicode(Me.Caption)
    
    For i = 0 To Me.Controls.Count - 1
        Call SetCaption(Me.Controls(i))
    Next i
    
    WarID = -1
    
    isGrid = 0
    
    Call LoadPicFile(G_Var.JYPath & G_Var.WarMapIDX, G_Var.JYPath & G_Var.WarMapGrp, WMapPic, WMappicnum)
    
    Load_warfld
    
    
    
    ComboLevel.Clear
    ComboLevel.AddItem LoadResStr(10805)
    ComboLevel.AddItem LoadResStr(10806)
    ComboLevel.AddItem LoadResStr(10807)
    ComboLevel.ListIndex = 0

    
    VScrollHeight.Max = WMapXmax - 1
    VScrollHeight.LargeChange = 5
    VScrollHeight.SmallChange = 1
    VScrollHeight.value = WMapXmax / 2
    
    HScrollWidth.Max = WMapYmax - 1
    HScrollWidth.LargeChange = 5
    HScrollWidth.SmallChange = 1
    HScrollWidth.value = WMapXmax / 2
    
    
End Sub

' 读 warfld
Private Sub Load_warfld()
Dim filenum As Long
Dim i As Long
    
    filenum = OpenBin(G_Var.JYPath & G_Var.WarMapDefIDX, "R")
    WarMapNum = LOF(filenum) / 4
    ReDim WarIDX(WarMapNum)
    ReDim WarMapdata(WarMapNum - 1)
    For i = 0 To WarMapNum - 1
        Get filenum, , WarIDX(i + 1)
    Next i
    Close #filenum
    
    WarIDX(0) = 0
    
    filenum = OpenBin(G_Var.JYPath & G_Var.WarMapDefGRP, "R")
    For i = 0 To WarMapNum - 1
        Get #filenum, WarIDX(i) + 1, WarMapdata(i).Data1
        Get #filenum, , WarMapdata(i).Data2
    Next i
    Close (filenum)
    

    ComboScene.Clear
    For i = 0 To WarMapNum - 1
        ComboScene.AddItem i
    Next i
    ComboScene.ListIndex = 0

End Sub

' 写D*s*
Private Sub Save_warfld()
Dim filenum As Long
Dim i As Long
    
    filenum = OpenBin(G_Var.JYPath & G_Var.WarMapDefIDX, "WN")
    For i = 1 To WarMapNum
        Put filenum, , WarIDX(i)
    Next i
    Close (filenum)
    
    filenum = OpenBin(G_Var.JYPath & G_Var.WarMapDefGRP, "WN")
    For i = 0 To WarMapNum - 1
        Put #filenum, WarIDX(i) + 1, WarMapdata(i).Data1
        Put #filenum, , WarMapdata(i).Data2
    Next i
    Close (filenum)
    
End Sub



' 绘场景地图

Public Sub Draw_wmap()
Dim RangeX As Long, rangeY As Long
Dim i As Long, j As Long
Dim i1 As Long, j1 As Long
Dim x1 As Long, Y1 As Long
Dim picnum As Long
    
Dim temp As Long
Dim lineSize As Long
Dim dx1 As Long, dx2 As Long
Dim dib As New clsDIB

    
    dib.CreateDIB pic1.Width, pic1.height
    
    RangeX = 18 + 15
    rangeY = 10 + 15
    
     For j = -rangeY To 2 * RangeX + rangeY
        For i = RangeX To 0 Step -1
           
            If j Mod 2 = 0 Then
                i1 = -RangeX + i + j \ 2
                j1 = -i + j \ 2
            Else
                i1 = -RangeX + i + j \ 2
                j1 = -i + j \ 2 + 1
            End If
            x1 = XSCALE * (i1 - j1) + pic1.Width / 2
            Y1 = YSCALE * (i1 + j1) + pic1.height / 2
            
            If yy + j1 >= 0 And xx + i1 >= 0 And yy + j1 < WMapYmax And xx + i1 < WMapXmax Then
                
                picnum = WarMapdata(ss).Data1(xx + i1, yy + j1) / 2
                If picnum > 0 And picnum < WMappicnum Then
                    If Not (isShowLevel = 1 And ComboLevel.ListIndex <> 1) Then
                        Call genPicData(WMapPic(picnum), dib.addr, pic1.Width, pic1.height, x1 - WMapPic(picnum).x, Y1 - WMapPic(picnum).Y)
                    End If
                End If
                picnum = WarMapdata(ss).Data2(xx + i1, yy + j1) / 2
                If picnum > 0 And picnum < WMappicnum Then
                    If Not (isShowLevel = 1 And ComboLevel.ListIndex <> 2) Then
                        Call genPicData(WMapPic(picnum), dib.addr, pic1.Width, pic1.height, x1 - WMapPic(picnum).x, Y1 - WMapPic(picnum).Y)
                    End If
                End If
                
            End If
        Next i
    Next j
    
    
    
    PicBak.Cls
     
        ' 复制到dib上
    temp = BitBlt(PicBak.hdc, 0, 0, pic1.Width, pic1.height, dib.CompDC, 0, 0, &HCC0020)
   
    
    PicBak.ForeColor = &H808000
    
   
      For j = -rangeY To 2 * RangeX + rangeY
       For i = RangeX To 0 Step -1
           
            If j Mod 2 = 0 Then
                i1 = -RangeX + i + j \ 2
                j1 = -i + j \ 2
            Else
                i1 = -RangeX + i + j \ 2
                j1 = -i + j \ 2 + 1
            End If
            x1 = XSCALE * (i1 - j1) + pic1.Width / 2
            Y1 = YSCALE * (i1 + j1) + pic1.height / 2
            If yy + j1 >= 0 And xx + i1 >= 0 And yy + j1 < WMapYmax And xx + i1 < WMapXmax Then
                If isGrid = 1 Then
                      PicBak.Line (x1, Y1)-(x1 + XSCALE, Y1 - YSCALE)
                      PicBak.Line (x1, Y1)-(x1 - XSCALE, Y1 - YSCALE)
                End If
            End If
        Next i
    Next j
    
    
End Sub


Public Sub Draw_wmap_2()
Dim RangeX As Long, rangeY As Long
Dim i As Long, j As Long
Dim i1 As Long, j1 As Long
Dim x1 As Long, Y1 As Long
Dim picnum As Long

Dim temp As Long
Dim dx As Long
Dim dib As New clsDIB

    dib.CreateDIB pic1.Width, pic1.height
    
    temp = BitBlt(dib.CompDC, 0, 0, pic1.Width, pic1.height, PicBak.hdc, 0, 0, &HCC0020)
    
    RangeX = 18 + 15
    rangeY = 10 + 15
    
    
    i1 = MouseX - xx
    j1 = MouseY - yy
    
    x1 = XSCALE * (i1 - j1) + pic1.Width / 2
    Y1 = YSCALE * (i1 + j1) + pic1.height / 2
    picnum = SelectPicNum
    
        If picnum >= 0 And picnum < WMappicnum And iMode <> 2 Then
            If iMode = 2 Then
                picnum = 0
            End If

            Call genPicData(WMapPic(picnum), dib.addr, pic1.Width, pic1.height, x1 - WMapPic(picnum).x, Y1 - WMapPic(picnum).Y)
       End If
    
     If iMode = 1 And SelectBlock = 0 Then
       If BlockX1 >= 0 And BlockX2 >= 0 And BlockY1 >= 0 And BlockY2 >= 0 Then
           pic1.ForeColor = vbRed
           For j = -rangeY To 2 * RangeX + rangeY
                For i = RangeX To 0 Step -1
                 
                 If j Mod 2 = 0 Then
                     i1 = -RangeX + i + j \ 2
                     j1 = -i + j \ 2
                 Else
                     i1 = -RangeX + i + j \ 2
                     j1 = -i + j \ 2 + 1
                 End If
                 
                x1 = XSCALE * (i1 - j1) + pic1.Width / 2
                Y1 = YSCALE * (i1 + j1) + pic1.height / 2
                 
                If i1 + xx >= MouseX - (BlockX2 - BlockX1) And i1 + xx <= MouseX And _
                   j1 + yy >= MouseY - (BlockY2 - BlockY1) And j1 + yy <= MouseY Then
                    
                    Select Case ComboLevel.ListIndex
                    Case 0
                    Case 1
                        picnum = WarMapdata(ss).Data1(BlockX2 - MouseX + i1 + xx, BlockY2 - MouseY + j1 + yy) / 2
                        If picnum > 0 And picnum < WMappicnum Then
                            Call genPicData(WMapPic(picnum), dib.addr, pic1.Width, pic1.height, x1 - WMapPic(picnum).x, Y1 - WMapPic(picnum).Y)
                        End If
                    Case 2
                        picnum = WarMapdata(ss).Data2(BlockX2 - MouseX + i1 + xx, BlockY2 - MouseY + j1 + yy) / 2
                        If picnum > 0 And picnum < WMappicnum Then
                            Call genPicData(WMapPic(picnum), dib.addr, pic1.Width, pic1.height, x1 - WMapPic(picnum).x, Y1 - WMapPic(picnum).Y)
                        End If
                    Case 3
                    Case 4
                    End Select
                End If
               Next i
         Next j
      End If
    End If
     
     
     pic1.Cls
        ' 复制到dib上
    temp = BitBlt(pic1.hdc, 0, 0, pic1.Width, pic1.height, dib.CompDC, 0, 0, &HCC0020)
   
   
   If iMode = 1 And SelectBlock = 1 And (ComboLevel.ListIndex = 1 Or ComboLevel.ListIndex = 2) Then
       If BlockX1 >= 0 And BlockX2 >= 0 And BlockY1 >= 0 And BlockY2 >= 0 Then
           pic1.ForeColor = vbRed
           For j = -rangeY To 2 * RangeX + rangeY
                For i = RangeX To 0 Step -1
                 
                 If j Mod 2 = 0 Then
                     i1 = -RangeX + i + j \ 2
                     j1 = -i + j \ 2
                 Else
                     i1 = -RangeX + i + j \ 2
                     j1 = -i + j \ 2 + 1
                 End If
                 x1 = XSCALE * (i1 - j1) + pic1.Width / 2
                 Y1 = YSCALE * (i1 + j1) + pic1.height / 2
                 
                 
                If i1 + xx >= Min_V(BlockX1, BlockX2) And i1 + xx <= Max_V(BlockX1, BlockX2) And _
                   j1 + yy >= Min_V(BlockY1, BlockY2) And j1 + yy <= Max_V(BlockY1, BlockY2) Then
                    pic1.Line (x1, Y1)-(x1 + XSCALE, Y1 - YSCALE)
                    pic1.Line (x1, Y1)-(x1 - XSCALE, Y1 - YSCALE)
                    pic1.Line (x1, Y1 - 2 * YSCALE)-(x1 - XSCALE, Y1 - YSCALE)
                    pic1.Line (x1, Y1 - 2 * YSCALE)-(x1 + XSCALE, Y1 - YSCALE)
                End If
               Next i
         Next j
      End If
    End If
   
    If WarID >= 0 Then
        pic1.ForeColor = vbRed
        For i = 0 To 5
            i1 = WarData(WarID).personX(i) - xx
            j1 = WarData(WarID).personY(i) - yy
            x1 = XSCALE * (i1 - j1) + pic1.Width / 2
            Y1 = YSCALE * (i1 + j1) + pic1.height / 2
            pic1.CurrentX = x1
            pic1.CurrentY = Y1 - YSCALE
            pic1.Print i
        Next i
        
        For i = 0 To 19
            If WarData(WarID).Enemy(i) >= 0 Then
                i1 = WarData(WarID).EnemyX(i) - xx
                j1 = WarData(WarID).EnemyY(i) - yy
                x1 = XSCALE * (i1 - j1) + pic1.Width / 2
                Y1 = YSCALE * (i1 + j1) + pic1.height / 2
                pic1.CurrentX = x1
                pic1.CurrentY = Y1 - YSCALE
                pic1.Print "E" & i
            End If
        Next i
    End If
   
   
    MDIMain.StatusBar1.Panels(2).Text = " X=" & MouseX & ",Y=" & MouseY

End Sub


Public Sub Show_picture(pic As PictureBox, ByVal num As Long)
   
Dim temp As Long
Dim dib As New clsDIB
    
    dib.CreateDIB pic.Width, pic.height
    pic.BackColor = MASKCOLOR
    
    temp = BitBlt(dib.CompDC, 0, 0, pic.Width, pic.height, pic.hdc, 0, 0, &HCC0020)
    
    'Picnum = num
    If num >= 0 Then
        Call genPicData(WMapPic(num), dib.addr, pic.Width, pic.height, 0, 0)
    End If
        ' 复制到dib上
    temp = BitBlt(pic.hdc, 0, 0, pic.Width, pic.height, dib.CompDC, 0, 0, &HCC0020)
   
End Sub


Private Sub Form_Resize()
    On Error Resume Next
    If Me.ScaleWidth < 400 Then
        Me.Width = Me.ScaleX(400, vbPixels, vbTwips)
    End If
    pic1.Width = Me.ScaleWidth - VScrollHeight.Width - pic1.Left
    If pic1.Width Mod 2 = 1 Then          ' 宽度保持2的倍数
        pic1.Width = pic1.Width + 1
    End If
    HScrollWidth.Width = pic1.Width
    VScrollHeight.Left = pic1.Width + pic1.Left
    
    If Me.ScaleHeight < 400 Then
          Me.height = Me.ScaleY(400, vbPixels, vbTwips)
    End If
    pic1.height = Me.ScaleHeight - HScrollWidth.height - pic1.Top
    If pic1.height Mod 2 = 1 Then
        pic1.height = pic1.height + 1
    End If
    VScrollHeight.height = pic1.height
    HScrollWidth.Top = pic1.Top + pic1.height
    PicBak.Width = pic1.Width
    PicBak.height = pic1.height
    'Call Game_Mmap_Build
    showwmap
      
End Sub

Private Sub Form_Unload(Cancel As Integer)
    MDIMain.StatusBar1.Panels(1).Text = ""
    MDIMain.StatusBar1.Panels(2).Text = ""
    
End Sub

Private Sub HScrollWidth_Change()
    ScrollValue
    showwmap
End Sub

Private Sub HScrollWidth_Scroll()
    ScrollValue
End Sub

Private Sub lblMenu_Click()
    PopupMenu MDIMain.mnu_WarMAPMenu
End Sub

Private Sub pic1_MouseDown(Button As Integer, Shift As Integer, x As Single, Y As Single)
Dim i As Long, j As Long
Dim tmplong As Long
If MouseX >= 0 And MouseX < WMapXmax And MouseY >= 0 And MouseY < WMapYmax Then
    
    If Button = vbLeftButton Then   ' 左键按下，拾取。
        Select Case ComboLevel.ListIndex
        Case 0
        
        Case 1
            SelectPicNum = WarMapdata(ss).Data1(MouseX, MouseY) / 2
        Case 2
            SelectPicNum = WarMapdata(ss).Data2(MouseX, MouseY) / 2
        End Select
        lblSelectPicNum.Caption = SelectPicNum
        
        If iMode = 1 Then
            BlockX1 = MouseX
            BlockY1 = MouseY
            BlockX2 = -1
            BlockY2 = -1
            SelectBlock = 1
        End If

        
    ElseIf Button = vbRightButton Then
        Select Case iMode
        Case 0
            Select Case ComboLevel.ListIndex
            Case 0
            
            Case 1
                WarMapdata(ss).Data1(MouseX, MouseY) = SelectPicNum * 2
            Case 2
                WarMapdata(ss).Data2(MouseX, MouseY) = SelectPicNum * 2
                
            End Select
        Case 1
            Select Case ComboLevel.ListIndex
            Case 0
            
            Case 1
                    If BlockX1 >= 0 And BlockX2 >= 0 And BlockY1 >= 0 And BlockY2 >= 0 Then
                        For i = BlockX1 To BlockX2
                            For j = BlockY1 To BlockY2
                                If MouseX - BlockX2 + i >= 0 And MouseX - BlockX2 + i < WMapXmax And MouseY - BlockY2 + j >= 0 And MouseY - BlockY2 + j < WMapYmax Then
                                    If WarMapdata(ss).Data1(i, j) > 0 Then
                                        WarMapdata(ss).Data1(MouseX - BlockX2 + i, MouseY - BlockY2 + j) = WarMapdata(ss).Data1(i, j)
                                    End If
                                End If
                            Next j
                        Next i
                    End If
            Case 2
                    If BlockX1 >= 0 And BlockX2 >= 0 And BlockY1 >= 0 And BlockY2 >= 0 Then
                        For i = BlockX1 To BlockX2
                            For j = BlockY1 To BlockY2
                                If MouseX - BlockX2 + i >= 0 And MouseX - BlockX2 + i < WMapXmax And MouseY - BlockY2 + j >= 0 And MouseY - BlockY2 + j < WMapYmax Then
                                    If WarMapdata(ss).Data2(i, j) > 0 Then
                                        WarMapdata(ss).Data2(MouseX - BlockX2 + i, MouseY - BlockY2 + j) = WarMapdata(ss).Data2(i, j)
                                    End If
                                End If
                            Next j
                        Next i
                    End If
            End Select
        Case 2
        
            Select Case ComboLevel.ListIndex
            Case 0
            
            Case 1
               WarMapdata(ss).Data1(MouseX, MouseY) = 0
            Case 2
                WarMapdata(ss).Data2(MouseX, MouseY) = 0
            End Select
        End Select
    End If
    showwmap
End If
End Sub

Private Sub Pic1_MouseMove(Button As Integer, Shift As Integer, x As Single, Y As Single)
Dim i1 As Long
Dim j1 As Long
    i1 = ((x - pic1.Width / 2) / XSCALE + (Y - pic1.height / 2 + YSCALE) / YSCALE) / 2
    j1 = -((x - pic1.Width / 2) / XSCALE - (Y - pic1.height / 2 + YSCALE) / YSCALE) / 2

    MouseX = i1 + xx
    MouseY = j1 + yy
    
    
    If iMode <> 1 Then
        If MouseX >= 0 And MouseX < WMapXmax And MouseY >= 0 And MouseY < WMapYmax Then
            Call Show_picture(PicEarth, WarMapdata(ss).Data1(MouseX, MouseY) / 2)
            Call Show_picture(PicBiuld, WarMapdata(ss).Data2(MouseX, MouseY) / 2)

            lbl1.Caption = WarMapdata(ss).Data1(MouseX, MouseY) / 2
            lbl2.Caption = WarMapdata(ss).Data2(MouseX, MouseY) / 2
        End If
    Else
        If (Button And vbLeftButton) > 0 Then
            BlockX2 = MouseX
            BlockY2 = MouseY
        End If
    End If
    Draw_wmap_2
    
End Sub

Private Sub pic1_MouseUp(Button As Integer, Shift As Integer, x As Single, Y As Single)
Dim x1 As Long, Y1 As Long
Dim x2 As Long, y2 As Long

    If iMode = 1 Then
        If BlockX2 = -1 And BlockY2 = -1 Then
            BlockX1 = -1
            BlockY1 = -1
        End If
        SelectBlock = 0
        x1 = Min_V(BlockX1, BlockX2)
        x2 = Max_V(BlockX1, BlockX2)
        Y1 = Min_V(BlockY1, BlockY2)
        y2 = Max_V(BlockY1, BlockY2)
        
        BlockX1 = x1                   ' 设置x1,y1为最小点，x2,y2为大点
        BlockY1 = Y1
        BlockX2 = x2
        BlockY2 = y2
        
        Draw_wmap_2
    End If
End Sub

Private Sub pic1_OLEDragDrop(Data As DataObject, Effect As Long, Button As Integer, Shift As Integer, x As Single, Y As Single)
Dim tmpstrArray() As String
Dim tmplong As Long
   If Data.GetFormat(vbCFText) Then
       tmpstrArray = Split(Data.GetData(vbCFText), ":")
       If tmpstrArray(0) = G_Var.WarMapGrp Then
           tmplong = CLng(tmpstrArray(1))
           SelectPicNum = tmplong
           lblSelectPicNum.Caption = SelectPicNum
       End If
   End If
End Sub

Private Sub VScrollHeight_Change()
    ScrollValue
    showwmap
End Sub


Public Sub ClickMenu(Id As String)
    Select Case LCase(Id)
    Case "grid"
        MDIMain.mnu_WarMAPMenu_Grid.Checked = Not MDIMain.mnu_WarMAPMenu_Grid.Checked
        isGrid = IIf(MDIMain.mnu_WarMAPMenu_Grid.Checked, 1, 0)
    Case "showlevel"
        MDIMain.mnu_WarMAPMenu_ShowLevel.Checked = Not MDIMain.mnu_WarMAPMenu_ShowLevel.Checked
        isShowLevel = IIf(MDIMain.mnu_WarMAPMenu_ShowLevel.Checked, 1, 0)
    Case "normal"
        MDIMain.mnu_WarMAPMenu_Normal.Checked = True
        MDIMain.mnu_WarMAPMenu_BLock.Checked = False
        MDIMain.mnu_WarMAPMenu_Delete.Checked = False
        iMode = 0
        Set_Note
    Case "block"
        MDIMain.mnu_WarMAPMenu_Normal.Checked = False
        MDIMain.mnu_WarMAPMenu_BLock.Checked = True
        MDIMain.mnu_WarMAPMenu_Delete.Checked = False
        iMode = 1
        Set_Note
    Case "delete"
        MDIMain.mnu_WarMAPMenu_Normal.Checked = False
        MDIMain.mnu_WarMAPMenu_BLock.Checked = False
        MDIMain.mnu_WarMAPMenu_Delete.Checked = True
        iMode = 2
        Set_Note
    Case "loadmap"
        Load_warfld
    Case "save"  ' 保存进度
        Save_warfld
    Case "addmap"  ' 增加场景地图
        AddMap
    Case "deletemap"   ' 删除地图
        DeleteMap
    End Select
    showwmap
End Sub

Private Sub Set_Note()
Dim Str As String
    Select Case iMode
    Case 0
        Select Case ComboLevel.ListIndex
        Case 0
            Str = LoadResStr(10814)
        Case 1, 2, 3
            Str = LoadResStr(10709)
        Case 4
            Str = LoadResStr(10820)
        Case 5, 6
            Str = LoadResStr(10815)
        End Select
    Case 1
        Select Case ComboLevel.ListIndex
        Case 0
            Str = LoadResStr(10814)
        Case Else
            Str = StrUnicode2("按下左键拖动选择操作块/右键复制块,只有层1/2能进行块操作")
        End Select
    Case 2
        Select Case ComboLevel.ListIndex
        Case 0
            Str = LoadResStr(10814)
        Case 1, 2, 3
            Str = LoadResStr(10710)
        Case 4
            Str = LoadResStr(10821)
        Case 5, 6
            Str = LoadResStr(10816)
        End Select
    End Select
    MDIMain.StatusBar1.Panels(1).Text = Str
End Sub

' 增加场景地图
Private Sub AddMap()
Dim i As Long, j As Long, k As Long
  
    WarMapNum = WarMapNum + 1
    ComboScene.AddItem WarMapNum - 1
    
    ReDim Preserve WarIDX(WarMapNum)
    ReDim Preserve WarMapdata(WarMapNum - 1)
    WarIDX(WarMapNum) = WarIDX(WarMapNum - 1) + 2# * 2 * WMapXmax * WMapYmax
    
    

    If MsgBox(StrUnicode2("是否复制当前战斗地图到新战斗地图？"), vbYesNo, Me.Caption) = vbYes Then
        For i = 0 To WMapXmax - 1
            For j = 0 To WMapYmax - 1
                WarMapdata(WarMapNum - 1).Data1(i, j) = WarMapdata(ss).Data1(i, j)
                WarMapdata(WarMapNum - 1).Data2(i, j) = WarMapdata(ss).Data2(i, j)
            Next j
        Next i
        
    End If
    
    
End Sub

Private Sub DeleteMap()
    If MsgBox(StrUnicode2("将要删除最后一个战斗地图，是否继续？"), vbYesNo, Me.Caption) = vbYes Then
        WarMapNum = WarMapNum - 1
        
        ReDim Preserve WarIDX(WarMapNum)
        ReDim Preserve WarMapdata(WarMapNum - 1)
        
        ComboScene.RemoveItem WarMapNum
        ComboScene.ListIndex = 0
    End If
End Sub

Private Sub ScrollValue()
    MouseX = MouseX - xx
    MouseY = MouseY - yy
    xx = HScrollWidth.value + VScrollHeight.value - WMapXmax / 2
    yy = -HScrollWidth.value + VScrollHeight.value + WMapXmax / 2
    MouseX = MouseX + xx
    MouseY = MouseY + yy
    MDIMain.StatusBar1.Panels(2).Text = " X=" & MouseX & ",Y=" & MouseY
End Sub

Private Sub VScrollHeight_Scroll()
    ScrollValue
End Sub
