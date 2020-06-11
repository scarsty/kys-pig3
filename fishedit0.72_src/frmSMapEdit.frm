VERSION 5.00
Begin VB.Form frmSMapEdit 
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
   Begin VB.Frame FrameD_Event 
      Caption         =   "修改场景事件"
      Height          =   4815
      Left            =   1800
      TabIndex        =   27
      Top             =   0
      Visible         =   0   'False
      Width           =   1695
      Begin VB.CommandButton Command1 
         Caption         =   "*2"
         Height          =   375
         Left            =   1200
         TabIndex        =   53
         Top             =   4320
         Width           =   375
      End
      Begin VB.TextBox txtD 
         Height          =   285
         Index           =   2
         Left            =   840
         TabIndex        =   52
         Text            =   "0"
         Top             =   1080
         Width           =   735
      End
      Begin VB.CommandButton cmdModifyD 
         Caption         =   "确认修改"
         Enabled         =   0   'False
         Height          =   375
         Left            =   120
         TabIndex        =   51
         Top             =   4320
         Width           =   975
      End
      Begin VB.TextBox txtD 
         Height          =   285
         Index           =   10
         Left            =   840
         TabIndex        =   48
         Text            =   "0"
         Top             =   3960
         Width           =   735
      End
      Begin VB.TextBox txtD 
         Height          =   285
         Index           =   9
         Left            =   840
         TabIndex        =   46
         Text            =   "0"
         Top             =   3600
         Width           =   735
      End
      Begin VB.TextBox txtD 
         Height          =   285
         Index           =   8
         Left            =   840
         TabIndex        =   44
         Text            =   "0"
         Top             =   3240
         Width           =   735
      End
      Begin VB.TextBox txtD 
         Height          =   285
         Index           =   7
         Left            =   840
         OLEDropMode     =   1  'Manual
         TabIndex        =   42
         Text            =   "0"
         Top             =   2880
         Width           =   735
      End
      Begin VB.TextBox txtD 
         Height          =   285
         Index           =   6
         Left            =   840
         OLEDropMode     =   1  'Manual
         TabIndex        =   40
         Text            =   "0"
         Top             =   2520
         Width           =   735
      End
      Begin VB.TextBox txtD 
         Height          =   285
         Index           =   5
         Left            =   840
         OLEDropMode     =   1  'Manual
         TabIndex        =   38
         Text            =   "0"
         Top             =   2160
         Width           =   735
      End
      Begin VB.TextBox txtD 
         Height          =   285
         Index           =   4
         Left            =   840
         TabIndex        =   36
         Text            =   "0"
         Top             =   1800
         Width           =   735
      End
      Begin VB.TextBox txtD 
         Height          =   285
         Index           =   3
         Left            =   840
         TabIndex        =   34
         Text            =   "0"
         Top             =   1440
         Width           =   735
      End
      Begin VB.TextBox txtD 
         Height          =   285
         Index           =   1
         Left            =   840
         TabIndex        =   31
         Text            =   "0"
         Top             =   720
         Width           =   735
      End
      Begin VB.TextBox txtD 
         Height          =   285
         Index           =   0
         Left            =   840
         TabIndex        =   28
         Text            =   "0"
         Top             =   360
         Width           =   735
      End
      Begin VB.Label Label7 
         Caption         =   "纵坐标Y"
         Height          =   255
         Index           =   12
         Left            =   120
         TabIndex        =   50
         Top             =   3960
         Width           =   735
      End
      Begin VB.Label Label7 
         Caption         =   "横坐标X"
         Height          =   255
         Index           =   11
         Left            =   120
         TabIndex        =   49
         Top             =   3600
         Width           =   735
      End
      Begin VB.Label Label7 
         Caption         =   "动画延迟"
         Height          =   255
         Index           =   10
         Left            =   120
         TabIndex        =   47
         ToolTipText     =   "动画延迟帧数"
         Top             =   3240
         Width           =   735
      End
      Begin VB.Label Label7 
         Caption         =   "开始贴图"
         Height          =   255
         Index           =   9
         Left            =   120
         TabIndex        =   45
         ToolTipText     =   "同动画开始贴图编号"
         Top             =   2880
         Width           =   735
      End
      Begin VB.Label Label7 
         Caption         =   "结束贴图"
         Height          =   255
         Index           =   8
         Left            =   120
         TabIndex        =   43
         ToolTipText     =   "动画结束贴图编号*2"
         Top             =   2520
         Width           =   735
      End
      Begin VB.Label Label7 
         Caption         =   "开始贴图"
         Height          =   255
         Index           =   7
         Left            =   120
         TabIndex        =   41
         ToolTipText     =   "动画开始贴图编号*2"
         Top             =   2160
         Width           =   735
      End
      Begin VB.Label Label7 
         Caption         =   "事件3"
         Height          =   255
         Index           =   6
         Left            =   120
         TabIndex        =   39
         ToolTipText     =   "通过触发事件"
         Top             =   1800
         Width           =   735
      End
      Begin VB.Label Label7 
         Caption         =   "事件2"
         Height          =   255
         Index           =   5
         Left            =   120
         TabIndex        =   37
         ToolTipText     =   "物品触发事件"
         Top             =   1440
         Width           =   735
      End
      Begin VB.Label Label7 
         Caption         =   "事件1"
         Height          =   255
         Index           =   4
         Left            =   120
         TabIndex        =   35
         ToolTipText     =   "空格触发事件"
         Top             =   1080
         Width           =   735
      End
      Begin VB.Label Label7 
         Caption         =   "编号"
         Height          =   255
         Index           =   2
         Left            =   120
         TabIndex        =   32
         Top             =   720
         Width           =   735
      End
      Begin VB.Label Label7 
         Caption         =   "能否通过"
         Height          =   255
         Index           =   0
         Left            =   120
         TabIndex        =   29
         ToolTipText     =   "0能通过，1不能通过"
         Top             =   360
         Width           =   735
      End
   End
   Begin VB.Timer Timer1 
      Enabled         =   0   'False
      Interval        =   100
      Left            =   9360
      Top             =   720
   End
   Begin VB.Frame Frame1 
      Caption         =   "当前图片"
      Height          =   5415
      Left            =   0
      TabIndex        =   10
      Top             =   1680
      Width           =   1815
      Begin VB.PictureBox PicEvent 
         AutoRedraw      =   -1  'True
         Height          =   1335
         Left            =   600
         ScaleHeight     =   1275
         ScaleWidth      =   1035
         TabIndex        =   26
         Top             =   3960
         Width           =   1095
      End
      Begin VB.PictureBox PicEarth 
         AutoRedraw      =   -1  'True
         Height          =   615
         Left            =   600
         ScaleHeight     =   555
         ScaleWidth      =   1035
         TabIndex        =   13
         Top             =   240
         Width           =   1095
      End
      Begin VB.PictureBox PicBiuld 
         AutoRedraw      =   -1  'True
         Height          =   1815
         Left            =   600
         ScaleHeight     =   1755
         ScaleWidth      =   1035
         TabIndex        =   12
         Top             =   960
         Width           =   1095
      End
      Begin VB.PictureBox PicAir 
         AutoRedraw      =   -1  'True
         Height          =   855
         Left            =   600
         ScaleHeight     =   795
         ScaleWidth      =   1035
         TabIndex        =   11
         Top             =   2880
         Width           =   1095
      End
      Begin VB.Label lblEventValue 
         Caption         =   "-1"
         Height          =   255
         Left            =   120
         TabIndex        =   25
         Top             =   4440
         Width           =   615
      End
      Begin VB.Label lblEvent 
         Caption         =   "场景事件"
         Height          =   495
         Left            =   120
         TabIndex        =   24
         Top             =   3960
         Width           =   495
      End
      Begin VB.Label Label1 
         Caption         =   "1地面"
         Height          =   255
         Left            =   120
         TabIndex        =   23
         Top             =   240
         Width           =   615
      End
      Begin VB.Label Label2 
         Caption         =   "2建筑"
         Height          =   255
         Left            =   120
         TabIndex        =   22
         Top             =   960
         Width           =   615
      End
      Begin VB.Label Label3 
         Caption         =   "3空中"
         Height          =   255
         Left            =   120
         TabIndex        =   21
         Top             =   2880
         Width           =   615
      End
      Begin VB.Label lbl1 
         Caption         =   "0"
         Height          =   255
         Left            =   120
         TabIndex        =   20
         Top             =   480
         Width           =   615
      End
      Begin VB.Label lbl2 
         BackStyle       =   0  'Transparent
         Caption         =   "0"
         Height          =   255
         Left            =   120
         TabIndex        =   19
         Top             =   1200
         Width           =   495
      End
      Begin VB.Label lbl3 
         Caption         =   "0"
         Height          =   255
         Left            =   120
         TabIndex        =   18
         Top             =   3120
         Width           =   615
      End
      Begin VB.Label Label4 
         Caption         =   "海拔"
         Height          =   255
         Left            =   120
         TabIndex        =   17
         Top             =   1440
         Width           =   615
      End
      Begin VB.Label lbl6 
         BackStyle       =   0  'Transparent
         Caption         =   "0"
         Height          =   255
         Left            =   120
         TabIndex        =   16
         Top             =   3600
         Width           =   615
      End
      Begin VB.Label lbl5 
         Caption         =   "0"
         Height          =   255
         Left            =   120
         TabIndex        =   15
         Top             =   1680
         Width           =   495
      End
      Begin VB.Label Label6 
         Caption         =   "海拔"
         Height          =   255
         Left            =   120
         TabIndex        =   14
         Top             =   3360
         Width           =   615
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
      Left            =   600
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
      TabIndex        =   33
      Top             =   0
      Width           =   735
   End
   Begin VB.Label Label7 
      Caption         =   "能否通过"
      Height          =   255
      Index           =   1
      Left            =   1920
      TabIndex        =   30
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
Attribute VB_Name = "frmSMapEdit"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False

Option Explicit

Private SelectPicNum As Long

Private Const SMapXmax = 64
Private Const SMapYmax = 64

Private SMapPic() As RLEPic
Private SMappicnum As Long

Private ss As Long           ' 当前场景代号

Private SinData0() As Integer

Private SceneIDX() As Long
Private SceneMapNum As Long      ' 场景地图个数，注意与r*中的数据不同

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

Private Recordnum As Long                   ' 进度编号


Private D_Event0() As D_Event_type
Private D_IDX() As Long
Private D_mapnum As Long


Private Current_D_EventNum As Long
Private Current_D_Event_Pic As Long

Private Sub cmdModifyD_Click()
Dim numD As Long
Dim x As Long, Y As Long
    
    numD = FrameD_Event.Tag
    x = txtD(9).Tag
    Y = txtD(10).Tag
    
    D_Event0(numD, ss).isGo = txtD(0).Text
    D_Event0(numD, ss).id = txtD(1).Text
    D_Event0(numD, ss).EventNum1 = txtD(2).Text
    D_Event0(numD, ss).EventNum2 = txtD(3).Text
    D_Event0(numD, ss).EventNum3 = txtD(4).Text
    D_Event0(numD, ss).picnum(0) = txtD(5).Text
    D_Event0(numD, ss).picnum(1) = txtD(6).Text
    D_Event0(numD, ss).picnum(2) = txtD(7).Text
    D_Event0(numD, ss).PicDelay = txtD(8).Text
    D_Event0(numD, ss).x = txtD(9).Text
    D_Event0(numD, ss).Y = txtD(10).Text
                
    SinData0(x, Y, 3, ss) = -1
    SinData0(D_Event0(numD, ss).x, D_Event0(numD, ss).Y, 3, ss) = numD
    cmdModifyD.Enabled = False
    showsmap
End Sub

Private Sub cmdSelectMap_Click()
    SelectPicNum = -1
    Load frmSelectMap
    frmSelectMap.txtIDX = G_Var.SMAPIDX
    frmSelectMap.txtGRP = G_Var.SMAPGRP
    frmSelectMap.cmdshow_Click
    frmSelectMap.Show
End Sub



Private Sub showsmap()
    Pic1.Cls
    Draw_Smap
    Draw_smap_2
End Sub


Private Sub ComboLevel_click()
    If ComboLevel.ListIndex = 4 Then
        FrameD_Event.Visible = True
    Else
        FrameD_Event.Visible = False
    End If
    Set_Note
    showsmap
End Sub


Private Sub ComboScene_click()
    ss = ComboScene.ListIndex
    showsmap
End Sub

Private Sub Command1_Click()
    txtD(5).Text = txtD(5).Text * 2
    txtD(6).Text = txtD(6).Text * 2
    txtD(7).Text = txtD(7).Text * 2
End Sub

Private Sub Form_Load()
Dim filenum As Long
Dim i As Long
Dim fileid As String
Dim filepic As String
    Me.Caption = LoadResStr(226)
    
    For i = 0 To Me.Controls.Count - 1
        Call SetCaption(Me.Controls(i))
    Next i

    Recordnum = 1
    
    isGrid = 0
    
    Call LoadPicFile(G_Var.JYPath & G_Var.SMAPIDX, G_Var.JYPath & G_Var.SMAPGRP, SMapPic, SMappicnum)
    
    Load_DS
    
    
    
    ComboLevel.Clear
    ComboLevel.AddItem LoadResStr(10805)
    ComboLevel.AddItem LoadResStr(10806)
    ComboLevel.AddItem LoadResStr(10807)
    ComboLevel.AddItem LoadResStr(10808)
    ComboLevel.AddItem LoadResStr(10809)
    ComboLevel.AddItem LoadResStr(10810)
    ComboLevel.AddItem LoadResStr(10811)
    ComboLevel.ListIndex = 0

    
    VScrollHeight.Max = SMapXmax - 1
    VScrollHeight.LargeChange = 5
    VScrollHeight.SmallChange = 1
    VScrollHeight.Value = SMapXmax / 2
    
    HScrollWidth.Max = SMapYmax - 1
    HScrollWidth.LargeChange = 5
    HScrollWidth.SmallChange = 1
    HScrollWidth.Value = SMapXmax / 2
    
    
    Current_D_EventNum = -1
    
    Timer1.Enabled = True
End Sub

' 读d*s*
Private Sub Load_DS()
Dim filenum As Long
Dim i As Long
    
    filenum = OpenBin(G_Var.JYPath & G_Var.SIDX(Recordnum), "R")
    SceneMapNum = LOF(filenum) / 4
    Close filenum
    
    filenum = OpenBin(G_Var.JYPath & G_Var.DIDX(Recordnum), "R")
    D_mapnum = LOF(filenum) / 4
    Close filenum
    
    If D_mapnum <> SceneMapNum Then
        Err.Raise vbObjectError + 1, , "frmSMapEdit error: D number not equal S number"
    End If
    
    ReDim SceneIDX(SceneMapNum)
    ReDim SinData0(SMapXmax - 1, SMapYmax - 1, 5, SceneMapNum - 1)
    
    ReDim D_IDX(SceneMapNum)
    ReDim D_Event0(200 - 1, SceneMapNum - 1)
    
    filenum = OpenBin(G_Var.JYPath & G_Var.SIDX(Recordnum), "R")
    For i = 0 To SceneMapNum - 1
        Get filenum, , SceneIDX(i + 1)
    Next i
    Close #filenum
    
    SceneIDX(0) = 0
    
    filenum = OpenBin(G_Var.JYPath & G_Var.SGRP(Recordnum), "R")
    Get #filenum, , SinData0
    Close (filenum)
    
    filenum = OpenBin(G_Var.JYPath & G_Var.DIDX(Recordnum), "R")
    ReDim D_IDX(SceneMapNum)
    For i = 0 To SceneMapNum - 1
        Get filenum, , D_IDX(i + 1)
    Next i
    Close #filenum
    
    D_IDX(0) = 0
    
    filenum = OpenBin(G_Var.JYPath & G_Var.DGRP(Recordnum), "R")
    
    Get filenum, , D_Event0
    
    Close (filenum)

    ComboScene.Clear
    For i = 0 To SceneMapNum - 1
        If i < Scenenum Then
            ComboScene.AddItem i & Big5toUnicode(Scene(i).Name1, 10)
        Else
            ComboScene.AddItem i
        End If
    Next i
    ComboScene.ListIndex = 0

End Sub

' 写D*s*
Private Sub Save_DS()
Dim filenum As Long
Dim i As Long
    
    filenum = OpenBin(G_Var.JYPath & G_Var.SIDX(Recordnum), "WN")
    For i = 1 To SceneMapNum
        Put filenum, , SceneIDX(i)
    Next i
    Close (filenum)
    
    filenum = OpenBin(G_Var.JYPath & G_Var.SGRP(Recordnum), "WN")
    
    Put filenum, , SinData0
    
    Close (filenum)
    
    filenum = OpenBin(G_Var.JYPath & G_Var.DIDX(Recordnum), "WN")
    For i = 1 To SceneMapNum
        Put filenum, , D_IDX(i)
    Next i
    Close (filenum)
    
    filenum = OpenBin(G_Var.JYPath & G_Var.DGRP(Recordnum), "WN")
    
    Put filenum, , D_Event0
    
    Close (filenum)
    

End Sub



' 绘场景地图

Public Sub Draw_Smap()
Dim RangeX As Long, rangeY As Long
Dim i As Long, j As Long
Dim i1 As Long, j1 As Long
Dim x1 As Long, Y1 As Long
Dim picnum As Long
    
Dim temp As Long
Dim lineSize As Long
Dim dx1 As Long, dx2 As Long
Dim dib As New clsDIB

    On Error Resume Next
    dib.CreateDIB Pic1.Width, Pic1.height
    
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
            x1 = XSCALE * (i1 - j1) + Pic1.Width / 2
            Y1 = YSCALE * (i1 + j1) + Pic1.height / 2
            
            If yy + j1 >= 0 And xx + i1 >= 0 And yy + j1 < SMapYmax And xx + i1 < SMapXmax Then
                dx1 = SinData0(xx + i1, yy + j1, 4, ss)
                dx2 = SinData0(xx + i1, yy + j1, 5, ss)
                
                picnum = SinData0(xx + i1, yy + j1, 0, ss) / 2
                If picnum > 0 And picnum < SMappicnum Then
                    If Not (isShowLevel = 1 And ComboLevel.ListIndex <> 1) Then
                        Call genPicData(SMapPic(picnum), dib.addr, Pic1.Width, Pic1.height, x1 - SMapPic(picnum).x, Y1 - SMapPic(picnum).Y)
                    End If
                End If
                picnum = SinData0(xx + i1, yy + j1, 1, ss) / 2
                If picnum > 0 And picnum < SMappicnum Then
                    If Not (isShowLevel = 1 And ComboLevel.ListIndex <> 2) Then
                        Call genPicData(SMapPic(picnum), dib.addr, Pic1.Width, Pic1.height, x1 - SMapPic(picnum).x, Y1 - SMapPic(picnum).Y - dx1)
                    End If
                End If
                picnum = SinData0(xx + i1, yy + j1, 2, ss) / 2
                If picnum > 0 And picnum < SMappicnum Then
                    If Not (isShowLevel = 1 And ComboLevel.ListIndex <> 3) Then
                        Call genPicData(SMapPic(picnum), dib.addr, Pic1.Width, Pic1.height, x1 - SMapPic(picnum).x, Y1 - SMapPic(picnum).Y - dx2)
                    End If
                End If
                picnum = SinData0(xx + i1, yy + j1, 3, ss)
                If picnum >= 0 Then
                    picnum = D_Event0(picnum, ss).picnum(0) / 2
                End If
                If picnum > 0 And picnum < SMappicnum Then
                    If Not (isShowLevel = 1 And ComboLevel.ListIndex <> 4) Then
                        Call genPicData(SMapPic(picnum), dib.addr, Pic1.Width, Pic1.height, x1 - SMapPic(picnum).x, Y1 - SMapPic(picnum).Y - dx1)
                    End If
                End If
            End If
        Next i
    Next j
    
    
    
    Picbak.Cls
     
        ' 复制到dib上
    temp = BitBlt(Picbak.hdc, 0, 0, Pic1.Width, Pic1.height, dib.CompDC, 0, 0, &HCC0020)
   
    
    Picbak.ForeColor = &H808000
    
   
      For j = -rangeY To 2 * RangeX + rangeY
       For i = RangeX To 0 Step -1
           
            If j Mod 2 = 0 Then
                i1 = -RangeX + i + j \ 2
                j1 = -i + j \ 2
            Else
                i1 = -RangeX + i + j \ 2
                j1 = -i + j \ 2 + 1
            End If
            x1 = XSCALE * (i1 - j1) + Pic1.Width / 2
            Y1 = YSCALE * (i1 + j1) + Pic1.height / 2
            If yy + j1 >= 0 And xx + i1 >= 0 And yy + j1 < SMapYmax And xx + i1 < SMapXmax Then
                If isGrid = 1 Then
                      Picbak.Line (x1, Y1)-(x1 + XSCALE, Y1 - YSCALE)
                      Picbak.Line (x1, Y1)-(x1 - XSCALE, Y1 - YSCALE)
                End If
            End If
        Next i
    Next j
    
    Picbak.ForeColor = vbYellow
    Picbak.FontSize = 9
   
      For j = -rangeY To 2 * RangeX + rangeY
       For i = RangeX To 0 Step -1
           
            If j Mod 2 = 0 Then
                i1 = -RangeX + i + j \ 2
                j1 = -i + j \ 2
            Else
                i1 = -RangeX + i + j \ 2
                j1 = -i + j \ 2 + 1
            End If
            x1 = XSCALE * (i1 - j1) + Pic1.Width / 2
            Y1 = YSCALE * (i1 + j1) + Pic1.height / 2
           
           
           If yy + j1 >= 0 And xx + i1 >= 0 And yy + j1 < SMapYmax And xx + i1 < SMapXmax Then
               
                If SinData0(xx + i1, yy + j1, 3, ss) >= 0 Then
                    dx1 = SinData0(xx + i1, yy + j1, 4, ss)
                     Picbak.CurrentX = x1 - XSCALE / 2
                     Picbak.CurrentY = Y1 - YSCALE - 4 - dx1
                    
                     Picbak.Print "[" & SinData0(xx + i1, yy + j1, 3, ss) & "]"
                End If
            End If
        Next i
    Next j
    
End Sub


Public Sub Draw_smap_2()
Dim RangeX As Long, rangeY As Long
Dim i As Long, j As Long
Dim i1 As Long, j1 As Long
Dim x1 As Long, Y1 As Long
Dim picnum As Long

Dim temp As Long
Dim dx As Long
Dim dib As New clsDIB

    dib.CreateDIB Pic1.Width, Pic1.height
    
    temp = BitBlt(dib.CompDC, 0, 0, Pic1.Width, Pic1.height, Picbak.hdc, 0, 0, &HCC0020)
    
    RangeX = 18 + 15
    rangeY = 10 + 15
    
    
    i1 = MouseX - xx
    j1 = MouseY - yy
    
    x1 = XSCALE * (i1 - j1) + Pic1.Width / 2
    Y1 = YSCALE * (i1 + j1) + Pic1.height / 2
    picnum = SelectPicNum
    
        If picnum >= 0 And picnum < SMappicnum And iMode <> 2 Then
            If yy + j1 >= 0 And xx + i1 >= 0 And yy + j1 < SMapYmax And xx + i1 < SMapXmax Then
                Select Case ComboLevel.ListIndex
                Case 2
                    dx = SinData0(xx + i1, yy + j1, 4, ss)
                Case 3
                    dx = SinData0(xx + i1, yy + j1, 5, ss)
                Case 4
                    dx = SinData0(xx + i1, yy + j1, 4, ss)
                    dx = 0
                    picnum = 0
                Case 5
                    dx = SinData0(xx + i1, yy + j1, 4, ss)
                    dx = 0
                    picnum = 0
                Case 6
                    picnum = 0
                    dx = SinData0(xx + i1, yy + j1, 5, ss)
                    dx = 0
                End Select
               
            End If
            
            If iMode = 2 Then
                picnum = 0
            End If

            Call genPicData(SMapPic(picnum), dib.addr, Pic1.Width, Pic1.height, x1 - SMapPic(picnum).x, Y1 - SMapPic(picnum).Y - dx)
       End If
    
     If iMode = 1 And SelectBlock = 0 Then
       If BlockX1 >= 0 And BlockX2 >= 0 And BlockY1 >= 0 And BlockY2 >= 0 Then
           Pic1.ForeColor = vbRed
           For j = -rangeY To 2 * RangeX + rangeY
                For i = RangeX To 0 Step -1
                 
                 If j Mod 2 = 0 Then
                     i1 = -RangeX + i + j \ 2
                     j1 = -i + j \ 2
                 Else
                     i1 = -RangeX + i + j \ 2
                     j1 = -i + j \ 2 + 1
                 End If
                 
                x1 = XSCALE * (i1 - j1) + Pic1.Width / 2
                Y1 = YSCALE * (i1 + j1) + Pic1.height / 2
                 
                If i1 + xx >= MouseX - (BlockX2 - BlockX1) And i1 + xx <= MouseX And _
                   j1 + yy >= MouseY - (BlockY2 - BlockY1) And j1 + yy <= MouseY Then
                    
                    Select Case ComboLevel.ListIndex
                    Case 0
                    Case 1
                        picnum = SinData0(BlockX2 - MouseX + i1 + xx, BlockY2 - MouseY + j1 + yy, 0, ss) / 2
                        If picnum > 0 And picnum < SMappicnum Then
                            Call genPicData(SMapPic(picnum), dib.addr, Pic1.Width, Pic1.height, x1 - SMapPic(picnum).x, Y1 - SMapPic(picnum).Y)
                        End If
                    Case 2
                        picnum = SinData0(BlockX2 - MouseX + i1 + xx, BlockY2 - MouseY + j1 + yy, 1, ss) / 2
                        If picnum > 0 And picnum < SMappicnum Then
                            Call genPicData(SMapPic(picnum), dib.addr, Pic1.Width, Pic1.height, x1 - SMapPic(picnum).x, Y1 - SMapPic(picnum).Y)
                        End If
                    Case 3
                    Case 4
                    Case 5
                        
                    End Select
                End If
               Next i
         Next j
      End If
    End If
     
     
     Pic1.Cls
        ' 复制到dib上
    temp = BitBlt(Pic1.hdc, 0, 0, Pic1.Width, Pic1.height, dib.CompDC, 0, 0, &HCC0020)
   
   
   If iMode = 1 And SelectBlock = 1 And (ComboLevel.ListIndex = 1 Or ComboLevel.ListIndex = 2 Or ComboLevel.ListIndex = 5) Then
       If BlockX1 >= 0 And BlockX2 >= 0 And BlockY1 >= 0 And BlockY2 >= 0 Then
           Pic1.ForeColor = vbRed
           For j = -rangeY To 2 * RangeX + rangeY
                For i = RangeX To 0 Step -1
                 
                 If j Mod 2 = 0 Then
                     i1 = -RangeX + i + j \ 2
                     j1 = -i + j \ 2
                 Else
                     i1 = -RangeX + i + j \ 2
                     j1 = -i + j \ 2 + 1
                 End If
                 x1 = XSCALE * (i1 - j1) + Pic1.Width / 2
                 Y1 = YSCALE * (i1 + j1) + Pic1.height / 2
                 
                 
                If i1 + xx >= Min_V(BlockX1, BlockX2) And i1 + xx <= Max_V(BlockX1, BlockX2) And _
                   j1 + yy >= Min_V(BlockY1, BlockY2) And j1 + yy <= Max_V(BlockY1, BlockY2) Then
                    Pic1.Line (x1, Y1)-(x1 + XSCALE, Y1 - YSCALE)
                    Pic1.Line (x1, Y1)-(x1 - XSCALE, Y1 - YSCALE)
                    Pic1.Line (x1, Y1 - 2 * YSCALE)-(x1 - XSCALE, Y1 - YSCALE)
                    Pic1.Line (x1, Y1 - 2 * YSCALE)-(x1 + XSCALE, Y1 - YSCALE)
                End If
               Next i
         Next j
      End If
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
        Call genPicData(SMapPic(num), dib.addr, pic.Width, pic.height, 0, 0)
    End If
        ' 复制到dib上
    temp = BitBlt(pic.hdc, 0, 0, pic.Width, pic.height, dib.CompDC, 0, 0, &HCC0020)
   
End Sub


Private Sub Form_Resize()
    On Error Resume Next
    If Me.ScaleWidth < 400 Then
        Me.Width = Me.ScaleX(400, vbPixels, vbTwips)
    End If
    Pic1.Width = Me.ScaleWidth - VScrollHeight.Width - Pic1.Left
    If Pic1.Width Mod 2 = 1 Then          ' 宽度保持2的倍数
        Pic1.Width = Pic1.Width + 1
    End If
    HScrollWidth.Width = Pic1.Width
    VScrollHeight.Left = Pic1.Width + Pic1.Left
    
    If Me.ScaleHeight < 400 Then
          Me.height = Me.ScaleY(400, vbPixels, vbTwips)
    End If
    Pic1.height = Me.ScaleHeight - HScrollWidth.height - Pic1.Top
    If Pic1.height Mod 2 = 1 Then
        Pic1.height = Pic1.height + 1
    End If
    VScrollHeight.height = Pic1.height
    HScrollWidth.Top = Pic1.Top + Pic1.height
    Picbak.Width = Pic1.Width
    Picbak.height = Pic1.height
    'Call Game_Mmap_Build
    showsmap
      
End Sub

Private Sub Form_Unload(Cancel As Integer)
    MDIMain.StatusBar1.Panels(1).Text = ""
    MDIMain.StatusBar1.Panels(2).Text = ""
    
End Sub

Private Sub HScrollWidth_Change()
    ScrollValue
    showsmap
End Sub

Private Sub HScrollWidth_Scroll()
    ScrollValue
End Sub

Private Sub lblMenu_Click()
    PopupMenu MDIMain.mnu_SMAPMenu
End Sub

Private Sub pic1_MouseDown(Button As Integer, Shift As Integer, x As Single, Y As Single)
Dim i As Long, j As Long
Dim tmplong As Long
If MouseX >= 0 And MouseX < SMapXmax And MouseY >= 0 And MouseY < SMapYmax Then
    
    If Button = vbLeftButton Then   ' 左键按下，拾取。
        Select Case ComboLevel.ListIndex
        Case 0
        
        Case 1
            SelectPicNum = SinData0(MouseX, MouseY, 0, ss) / 2
            If iMode = 1 Then
                BlockX1 = MouseX
                BlockY1 = MouseY
                BlockX2 = -1
                BlockY2 = -1
                SelectBlock = 1
            End If

        Case 2
            SelectPicNum = SinData0(MouseX, MouseY, 1, ss) / 2
            If iMode = 1 Then
                BlockX1 = MouseX
                BlockY1 = MouseY
                BlockX2 = -1
                BlockY2 = -1
                SelectBlock = 1
            End If
        Case 3
            SelectPicNum = SinData0(MouseX, MouseY, 2, ss) / 2
        Case 4
            If SinData0(MouseX, MouseY, 3, ss) >= 0 And iMode <> 2 Then
                FrameD_Event.Tag = SinData0(MouseX, MouseY, 3, ss)
                txtD(0).Text = D_Event0(SinData0(MouseX, MouseY, 3, ss), ss).isGo
                txtD(1).Text = D_Event0(SinData0(MouseX, MouseY, 3, ss), ss).id
                txtD(2).Text = D_Event0(SinData0(MouseX, MouseY, 3, ss), ss).EventNum1
                txtD(3).Text = D_Event0(SinData0(MouseX, MouseY, 3, ss), ss).EventNum2
                txtD(4).Text = D_Event0(SinData0(MouseX, MouseY, 3, ss), ss).EventNum3
                txtD(5).Text = D_Event0(SinData0(MouseX, MouseY, 3, ss), ss).picnum(0)
                txtD(6).Text = D_Event0(SinData0(MouseX, MouseY, 3, ss), ss).picnum(1)
                txtD(7).Text = D_Event0(SinData0(MouseX, MouseY, 3, ss), ss).picnum(2)
                txtD(8).Text = D_Event0(SinData0(MouseX, MouseY, 3, ss), ss).PicDelay
                txtD(9).Text = D_Event0(SinData0(MouseX, MouseY, 3, ss), ss).x
                txtD(10).Text = D_Event0(SinData0(MouseX, MouseY, 3, ss), ss).Y
                txtD(9).Tag = MouseX
                txtD(10).Tag = MouseY
                cmdModifyD.Enabled = True
            End If
        Case 5
            If iMode <> 1 Then
                SinData0(MouseX, MouseY, 4, ss) = SinData0(MouseX, MouseY, 4, ss) + 1
            Else
                If SelectBlock = 1 Then
                    If BlockX1 >= 0 And BlockX2 >= 0 And BlockY1 >= 0 And BlockY2 >= 0 Then
                        If MouseX >= BlockX1 And MouseX <= BlockX2 And MouseY >= BlockY1 And MouseY <= BlockY2 Then
                            For i = BlockX1 To BlockX2
                                For j = BlockY1 To BlockY2
                                    'If SinData0(i, j, 1, ss) > 0 Then
                                        SinData0(i, j, 4, ss) = SinData0(i, j, 4, ss) + 1
                                    'End If
                                Next j
                            Next i
                        Else
                            SelectBlock = 0
                            BlockX1 = -1
                            BlockY1 = -1
                            BlockX2 = -1
                            BlockY2 = -1
                        End If
                    Else
                        SelectBlock = 0
                        BlockX1 = -1
                        BlockY1 = -1
                        BlockX2 = -1
                        BlockY2 = -1
                    End If
                Else
                    BlockX1 = MouseX
                    BlockY1 = MouseY
                    BlockX2 = -1
                    BlockY2 = -1
                    SelectBlock = 1
                End If
            End If
        Case 6
            SinData0(MouseX, MouseY, 5, ss) = SinData0(MouseX, MouseY, 5, ss) + 1
        End Select
        lblSelectPicNum.Caption = SelectPicNum
        

        
    ElseIf Button = vbRightButton Then
        Select Case iMode
        Case 0
            Select Case ComboLevel.ListIndex
            Case 0
            
            Case 1
                SinData0(MouseX, MouseY, 0, ss) = SelectPicNum * 2
            Case 2
                SinData0(MouseX, MouseY, 1, ss) = SelectPicNum * 2
            Case 3
                SinData0(MouseX, MouseY, 2, ss) = SelectPicNum * 2
            Case 4
                If SinData0(MouseX, MouseY, 3, ss) < 0 Then
                    For i = 0 To 200 - 1
                        If D_Event0(i, ss).isGo = 0 And D_Event0(i, ss).id = 0 And D_Event0(i, ss).EventNum1 = 0 And D_Event0(i, ss).EventNum2 = 0 And D_Event0(i, ss).EventNum3 = 0 And _
                             D_Event0(i, ss).picnum(0) = 0 And D_Event0(i, ss).picnum(1) = 0 And D_Event0(i, ss).picnum(2) = 0 And D_Event0(i, ss).PicDelay = 0 And D_Event0(i, ss).x = 0 And _
                             D_Event0(i, ss).Y = 0 Then
                           SinData0(MouseX, MouseY, 3, ss) = i
                           D_Event0(i, ss).id = i
                           D_Event0(i, ss).x = MouseX
                           D_Event0(i, ss).Y = MouseY
                           Exit For
                        End If
                    Next i
                End If
            Case 5
                SinData0(MouseX, MouseY, 4, ss) = SinData0(MouseX, MouseY, 4, ss) - 1
            Case 6
                SinData0(MouseX, MouseY, 5, ss) = SinData0(MouseX, MouseY, 5, ss) - 1
                
            End Select
        Case 1
            Select Case ComboLevel.ListIndex
            Case 0
            
            Case 1
                    If BlockX1 >= 0 And BlockX2 >= 0 And BlockY1 >= 0 And BlockY2 >= 0 Then
                        For i = BlockX1 To BlockX2
                            For j = BlockY1 To BlockY2
                                If MouseX - BlockX2 + i >= 0 And MouseX - BlockX2 + i < SMapXmax And MouseY - BlockY2 + j >= 0 And MouseY - BlockY2 + j < SMapYmax Then
                                    If SinData0(i, j, 0, ss) > 0 Then
                                        SinData0(MouseX - BlockX2 + i, MouseY - BlockY2 + j, 0, ss) = SinData0(i, j, 0, ss)
                                    End If
                                End If
                            Next j
                        Next i
                    End If
            Case 2
                    If BlockX1 >= 0 And BlockX2 >= 0 And BlockY1 >= 0 And BlockY2 >= 0 Then
                        For i = BlockX1 To BlockX2
                            For j = BlockY1 To BlockY2
                                If MouseX - BlockX2 + i >= 0 And MouseX - BlockX2 + i < SMapXmax And MouseY - BlockY2 + j >= 0 And MouseY - BlockY2 + j < SMapYmax Then
                                    If SinData0(i, j, 1, ss) > 0 Then
                                        SinData0(MouseX - BlockX2 + i, MouseY - BlockY2 + j, 1, ss) = SinData0(i, j, 1, ss)
                                        SinData0(MouseX - BlockX2 + i, MouseY - BlockY2 + j, 4, ss) = SinData0(i, j, 4, ss)
                                    End If
                                End If
                            Next j
                        Next i
                    End If
            Case 5
                If SelectBlock = 1 Then
                    If BlockX1 >= 0 And BlockX2 >= 0 And BlockY1 >= 0 And BlockY2 >= 0 Then
                        If MouseX >= BlockX1 And MouseX <= BlockX2 And MouseY >= BlockY1 And MouseY <= BlockY2 Then
                            For i = BlockX1 To BlockX2
                                For j = BlockY1 To BlockY2
                                    'If SinData0(i, j, 1, ss) > 0 Then
                                        SinData0(i, j, 4, ss) = SinData0(i, j, 4, ss) - 1
                                    'End If
                                Next j
                            Next i
                        Else
                            SelectBlock = 0
                            BlockX1 = -1
                            BlockY1 = -1
                            BlockX2 = -1
                            BlockY2 = -1
                        End If
                    Else
                        SelectBlock = 0
                        BlockX1 = -1
                        BlockY1 = -1
                        BlockX2 = -1
                        BlockY2 = -1
                    End If
                End If

            
            End Select
        Case 2
        
            Select Case ComboLevel.ListIndex
            Case 0
            
            Case 1
               SinData0(MouseX, MouseY, 0, ss) = 0
            Case 2
                SinData0(MouseX, MouseY, 1, ss) = 0
            Case 3
                SinData0(MouseX, MouseY, 2, ss) = 0
            Case 4
                If SinData0(MouseX, MouseY, 3, ss) >= 0 Then
                    tmplong = SinData0(MouseX, MouseY, 3, ss)
                    D_Event0(tmplong, ss).isGo = 0
                    D_Event0(tmplong, ss).id = 0
                    D_Event0(tmplong, ss).EventNum1 = 0
                    D_Event0(tmplong, ss).EventNum2 = 0
                    D_Event0(tmplong, ss).EventNum3 = 0
                    D_Event0(tmplong, ss).picnum(0) = 0
                    D_Event0(tmplong, ss).picnum(1) = 0
                    D_Event0(tmplong, ss).picnum(2) = 0
                    D_Event0(tmplong, ss).PicDelay = 0
                    D_Event0(tmplong, ss).x = 0
                    D_Event0(tmplong, ss).Y = 0
                    SinData0(MouseX, MouseY, 3, ss) = -1
                End If
            Case 5
                SinData0(MouseX, MouseY, 4, ss) = 0
            Case 6
                SinData0(MouseX, MouseY, 5, ss) = 0
            End Select
        End Select
    End If
    showsmap
End If
End Sub

Private Sub Pic1_MouseMove(Button As Integer, Shift As Integer, x As Single, Y As Single)
Dim i1 As Long
Dim j1 As Long
    i1 = ((x - Pic1.Width / 2) / XSCALE + (Y - Pic1.height / 2 + YSCALE) / YSCALE) / 2
    j1 = -((x - Pic1.Width / 2) / XSCALE - (Y - Pic1.height / 2 + YSCALE) / YSCALE) / 2

    MouseX = i1 + xx
    MouseY = j1 + yy
    
    
    If iMode <> 1 Then
        If MouseX >= 0 And MouseX < SMapXmax And MouseY >= 0 And MouseY < SMapYmax Then
            Call Show_picture(PicEarth, SinData0(MouseX, MouseY, 0, ss) / 2)
            Call Show_picture(PicBiuld, SinData0(MouseX, MouseY, 1, ss) / 2)
            Call Show_picture(PicAir, SinData0(MouseX, MouseY, 2, ss) / 2)
            
            lbl1.Caption = SinData0(MouseX, MouseY, 0, ss) / 2
            lbl2.Caption = SinData0(MouseX, MouseY, 1, ss) / 2
            lbl3.Caption = SinData0(MouseX, MouseY, 2, ss) / 2
            lblEventValue.Caption = SinData0(MouseX, MouseY, 3, ss)
            lbl5.Caption = SinData0(MouseX, MouseY, 4, ss)
            lbl6.Caption = SinData0(MouseX, MouseY, 5, ss)
        End If
    Else
        If (Button And vbLeftButton) > 0 Then
            BlockX2 = MouseX
            BlockY2 = MouseY
        End If
    End If
    Draw_smap_2
    
End Sub

Private Sub pic1_MouseUp(Button As Integer, Shift As Integer, x As Single, Y As Single)
Dim x1 As Long, Y1 As Long
Dim x2 As Long, y2 As Long

    If iMode = 1 Then
        If BlockX2 = -1 And BlockY2 = -1 Then
            BlockX1 = -1
            BlockY1 = -1
        End If
        If ComboLevel.ListIndex <> 5 Then
            SelectBlock = 0
        End If

        x1 = Min_V(BlockX1, BlockX2)
        x2 = Max_V(BlockX1, BlockX2)
        Y1 = Min_V(BlockY1, BlockY2)
        y2 = Max_V(BlockY1, BlockY2)
        
        BlockX1 = x1                   ' 设置x1,y1为最小点，x2,y2为大点
        BlockY1 = Y1
        BlockX2 = x2
        BlockY2 = y2
        
        
        
        Draw_smap_2
    End If
End Sub

Private Sub pic1_OLEDragDrop(Data As DataObject, Effect As Long, Button As Integer, Shift As Integer, x As Single, Y As Single)
Dim tmpstrArray() As String
Dim tmplong As Long
   If Data.GetFormat(vbCFText) Then
       tmpstrArray = Split(Data.GetData(vbCFText), ":")
       If tmpstrArray(0) = G_Var.SMAPGRP Then
           tmplong = CLng(tmpstrArray(1))
           SelectPicNum = tmplong
           lblSelectPicNum.Caption = SelectPicNum
       End If
   End If
End Sub

Private Sub Timer1_Timer()
Dim vv As Long
    vv = lblEventValue.Caption
    If vv < 0 Then
        Current_D_EventNum = -1
        PicEvent.Cls
        Exit Sub
    End If
    If vv <> Current_D_EventNum Then
        Current_D_EventNum = vv
        Current_D_Event_Pic = D_Event0(vv, ss).picnum(0)
    Else
        If D_Event0(vv, ss).picnum(1) > Current_D_Event_Pic Then
            Current_D_Event_Pic = Current_D_Event_Pic + 2
        Else
            Current_D_Event_Pic = D_Event0(vv, ss).picnum(0)
        End If
    End If
        
        
    Call Show_picture(PicEvent, Current_D_Event_Pic / 2)
   
    
End Sub



Private Sub txtD_OLEDragDrop(Index As Integer, Data As DataObject, Effect As Long, Button As Integer, Shift As Integer, x As Single, Y As Single)
Dim tmpstrArray() As String
Dim tmplong As Long
   If Data.GetFormat(vbCFText) Then
       tmpstrArray = Split(Data.GetData(vbCFText), ":")
       If tmpstrArray(0) = G_Var.SMAPGRP Then
           tmplong = CLng(tmpstrArray(1))
           txtD(Index).Text = tmplong * 2
       End If
   End If
End Sub

Private Sub VScrollHeight_Change()
    ScrollValue
    showsmap
End Sub


Public Sub ClickMenu(id As String)
    Select Case LCase(id)
    Case "grid"
        MDIMain.mnu_SMAPMenu_Grid.Checked = Not MDIMain.mnu_SMAPMenu_Grid.Checked
        isGrid = IIf(MDIMain.mnu_SMAPMenu_Grid.Checked, 1, 0)
    Case "showlevel"
        MDIMain.mnu_SMAPMenu_ShowLevel.Checked = Not MDIMain.mnu_SMAPMenu_ShowLevel.Checked
        isShowLevel = IIf(MDIMain.mnu_SMAPMenu_ShowLevel.Checked, 1, 0)
    Case "normal"
        MDIMain.mnu_SMAPMenu_Normal.Checked = True
        MDIMain.mnu_SMAPMenu_BLock.Checked = False
        MDIMain.mnu_SMAPMenu_Delete.Checked = False
        iMode = 0
        Set_Note
    Case "block"
        MDIMain.mnu_SMAPMenu_Normal.Checked = False
        MDIMain.mnu_SMAPMenu_BLock.Checked = True
        MDIMain.mnu_SMAPMenu_Delete.Checked = False
        iMode = 1
        Set_Note
    Case "delete"
        MDIMain.mnu_SMAPMenu_Normal.Checked = False
        MDIMain.mnu_SMAPMenu_BLock.Checked = False
        MDIMain.mnu_SMAPMenu_Delete.Checked = True
        iMode = 2
        Set_Note
    Case "loadmap0"
        Recordnum = 0
        MDIMain.mnu_SMAPMenu_LoadMap0.Checked = True
        MDIMain.mnu_SMAPMenu_LoadMap1.Checked = False
        MDIMain.mnu_SMAPMenu_LoadMap2.Checked = False
        MDIMain.mnu_SMAPMenu_LoadMap3.Checked = False
        Load_DS
    Case "loadmap1"
        Recordnum = 1
        MDIMain.mnu_SMAPMenu_LoadMap0.Checked = False
        MDIMain.mnu_SMAPMenu_LoadMap1.Checked = True
        MDIMain.mnu_SMAPMenu_LoadMap2.Checked = False
        MDIMain.mnu_SMAPMenu_LoadMap3.Checked = False
        Load_DS
    Case "loadmap2"
        Recordnum = 2
        MDIMain.mnu_SMAPMenu_LoadMap0.Checked = False
        MDIMain.mnu_SMAPMenu_LoadMap1.Checked = False
        MDIMain.mnu_SMAPMenu_LoadMap2.Checked = True
        MDIMain.mnu_SMAPMenu_LoadMap3.Checked = False
        Load_DS
    Case "loadmap3"
        Recordnum = 3
        MDIMain.mnu_SMAPMenu_LoadMap0.Checked = False
        MDIMain.mnu_SMAPMenu_LoadMap1.Checked = False
        MDIMain.mnu_SMAPMenu_LoadMap2.Checked = False
        MDIMain.mnu_SMAPMenu_LoadMap3.Checked = True
        Load_DS
    Case "save"  ' 保存进度
        Save_DS
    Case "addmap"  ' 增加场景地图
        AddMap
    Case "deletemap"   ' 删除地图
        DeleteMap
    End Select
    showsmap
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
        Case 1, 2
            Str = StrUnicode2("按下左键拖动选择操作块/右键复制块")
        Case 5
            Str = StrUnicode2("按下左键拖动选择操作块/在块上左键升高海拔，右键降低海拔/块外点击取消块")
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
  
    SceneMapNum = SceneMapNum + 1
    ComboScene.AddItem SceneMapNum - 1
    
    ReDim Preserve SceneIDX(SceneMapNum)
    ReDim Preserve SinData0(SMapXmax - 1, SMapYmax - 1, 5, SceneMapNum - 1)
    SceneIDX(SceneMapNum) = SceneIDX(SceneMapNum - 1) + 6# * 2 * SMapXmax * SMapXmax
    
    For i = 0 To SMapXmax - 1
        For j = 0 To SMapYmax - 1
            SinData0(i, j, 3, SceneMapNum - 1) = -1
        Next j
    Next i
    
    
    ReDim Preserve D_IDX(SceneMapNum)
    ReDim Preserve D_Event0(200 - 1, SceneMapNum - 1)
    D_IDX(SceneMapNum) = D_IDX(SceneMapNum - 1) + 4400
    

    If MsgBox(StrUnicode2("是否复制当前场景到新场景？"), vbYesNo, Me.Caption) = vbYes Then
        For k = 0 To 5
            For i = 0 To SMapXmax - 1
                For j = 0 To SMapYmax - 1
                    SinData0(i, j, k, SceneMapNum - 1) = SinData0(i, j, k, ss)
                Next j
            Next i
        Next k
        
        For i = 0 To 200 - 1
            D_Event0(i, SceneMapNum - 1) = D_Event0(i, ss)
        Next i
    End If
    
    
End Sub

Private Sub DeleteMap()
    If MsgBox(StrUnicode2("将要删除最后一个场景，是否继续？"), vbYesNo, Me.Caption) = vbYes Then
        SceneMapNum = SceneMapNum - 1
        
        ReDim Preserve SceneIDX(SceneMapNum)
        ReDim Preserve SinData0(SMapXmax - 1, SMapYmax - 1, 5, SceneMapNum - 1)
        
        ReDim Preserve D_IDX(SceneMapNum)
        ReDim Preserve D_Event0(200 - 1, SceneMapNum - 1)
        ComboScene.RemoveItem SceneMapNum
        ComboScene.ListIndex = 0
    End If
End Sub

Private Sub ScrollValue()
    MouseX = MouseX - xx
    MouseY = MouseY - yy
    xx = HScrollWidth.Value + VScrollHeight.Value - SMapXmax / 2
    yy = -HScrollWidth.Value + VScrollHeight.Value + SMapXmax / 2
    MouseX = MouseX + xx
    MouseY = MouseY + yy
    MDIMain.StatusBar1.Panels(2).Text = " X=" & MouseX & ",Y=" & MouseY
End Sub

Private Sub VScrollHeight_Scroll()
    ScrollValue
End Sub
