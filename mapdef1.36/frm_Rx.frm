VERSION 5.00
Object = "{831FDD16-0C5C-11D2-A9FC-0000F8754DA1}#2.0#0"; "MSCOMCTL.OCX"
Begin VB.Form frmRxEdit 
   Caption         =   "基本进度修改器"
   ClientHeight    =   5385
   ClientLeft      =   60
   ClientTop       =   345
   ClientWidth     =   8385
   BeginProperty Font 
      Name            =   "Times New Roman"
      Size            =   9
      Charset         =   0
      Weight          =   400
      Underline       =   0   'False
      Italic          =   0   'False
      Strikethrough   =   0   'False
   EndProperty
   LinkTopic       =   "Form2"
   MDIChild        =   -1  'True
   ScaleHeight     =   359
   ScaleMode       =   3  'Pixel
   ScaleWidth      =   559
   WindowState     =   2  'Maximized
   Begin VB.CheckBox chkSort 
      Caption         =   "Check2"
      Enabled         =   0   'False
      ForeColor       =   &H00FF0000&
      Height          =   255
      Left            =   5640
      TabIndex        =   30
      Top             =   45
      Width           =   1335
   End
   Begin MSComctlLib.ListView ListView1 
      Height          =   1815
      Left            =   6720
      TabIndex        =   29
      Top             =   360
      Visible         =   0   'False
      Width           =   1575
      _ExtentX        =   2778
      _ExtentY        =   3201
      View            =   3
      LabelWrap       =   -1  'True
      HideSelection   =   -1  'True
      FullRowSelect   =   -1  'True
      GridLines       =   -1  'True
      _Version        =   393217
      ForeColor       =   -2147483640
      BackColor       =   -2147483643
      BorderStyle     =   1
      Appearance      =   1
      NumItems        =   0
   End
   Begin VB.Timer TimerWgAniCtl 
      Enabled         =   0   'False
      Interval        =   100
      Left            =   5280
      Top             =   360
   End
   Begin VB.PictureBox tempPicbox 
      AutoRedraw      =   -1  'True
      Height          =   5055
      Left            =   7560
      ScaleHeight     =   4995
      ScaleWidth      =   4155
      TabIndex        =   28
      Top             =   3240
      Visible         =   0   'False
      Width           =   4215
   End
   Begin VB.ListBox List1 
      BackColor       =   &H00FFC0FF&
      Columns         =   4
      Height          =   1185
      Index           =   3
      Left            =   1320
      TabIndex        =   24
      Top             =   4320
      Visible         =   0   'False
      Width           =   1215
   End
   Begin VB.ListBox List1 
      BackColor       =   &H00E0FFE0&
      Columns         =   6
      Height          =   1185
      Index           =   2
      Left            =   120
      TabIndex        =   23
      Top             =   3960
      Visible         =   0   'False
      Width           =   1215
   End
   Begin VB.ListBox List1 
      BackColor       =   &H00FFC0C0&
      Columns         =   6
      Height          =   1185
      Index           =   1
      Left            =   5040
      TabIndex        =   14
      Top             =   3600
      Width           =   1215
   End
   Begin VB.ListBox List1 
      BackColor       =   &H00C0C0FF&
      Columns         =   6
      Height          =   1185
      Index           =   0
      Left            =   360
      TabIndex        =   21
      Top             =   4560
      Width           =   1215
   End
   Begin VB.CheckBox Check1 
      Caption         =   "快捷菜单"
      ForeColor       =   &H00FF0000&
      Height          =   345
      Left            =   4320
      Style           =   1  'Graphical
      TabIndex        =   9
      Top             =   0
      Width           =   1215
   End
   Begin VB.Frame Frame1 
      Caption         =   "Frame1"
      Height          =   5175
      Index           =   0
      Left            =   3480
      TabIndex        =   1
      Top             =   3720
      Width           =   3375
      Begin VB.TextBox Text1 
         BackColor       =   &H8000000F&
         BorderStyle     =   0  'None
         ForeColor       =   &H00000000&
         Height          =   210
         Index           =   0
         Left            =   1190
         TabIndex        =   8
         Text            =   "a1"
         Top             =   240
         Width           =   590
      End
      Begin VB.Label Label1 
         AutoSize        =   -1  'True
         Caption         =   "lbl1"
         ForeColor       =   &H00800000&
         Height          =   180
         Index           =   0
         Left            =   120
         TabIndex        =   7
         Top             =   240
         Width           =   360
      End
   End
   Begin VB.Frame Frame1 
      Caption         =   "Frame6"
      Height          =   5175
      Index           =   5
      Left            =   2760
      TabIndex        =   6
      Top             =   3000
      Width           =   3135
      Begin VB.TextBox Text6 
         BackColor       =   &H8000000F&
         BorderStyle     =   0  'None
         ForeColor       =   &H00000000&
         Height          =   210
         Index           =   0
         Left            =   1440
         TabIndex        =   18
         Text            =   "a6"
         Top             =   240
         Width           =   975
      End
      Begin VB.Label Label6 
         AutoSize        =   -1  'True
         Caption         =   "lbl6"
         ForeColor       =   &H00000000&
         Height          =   180
         Index           =   0
         Left            =   120
         TabIndex        =   19
         Top             =   240
         Width           =   360
      End
   End
   Begin VB.Frame Frame1 
      Caption         =   "Frame5"
      Height          =   5175
      Index           =   4
      Left            =   2400
      TabIndex        =   5
      Top             =   2880
      Width           =   3135
      Begin VB.PictureBox WgPbox 
         Height          =   1815
         Index           =   0
         Left            =   1320
         ScaleHeight     =   117
         ScaleMode       =   3  'Pixel
         ScaleWidth      =   101
         TabIndex        =   26
         Top             =   600
         Width           =   1575
      End
      Begin VB.TextBox Text5 
         BackColor       =   &H8000000F&
         BorderStyle     =   0  'None
         ForeColor       =   &H00000000&
         Height          =   210
         Index           =   0
         Left            =   1200
         TabIndex        =   16
         Text            =   "a5"
         Top             =   240
         Width           =   560
      End
      Begin VB.Label Label5 
         AutoSize        =   -1  'True
         Caption         =   "lbl5"
         ForeColor       =   &H00800000&
         Height          =   180
         Index           =   0
         Left            =   120
         TabIndex        =   17
         Top             =   240
         Width           =   360
      End
   End
   Begin VB.Frame Frame1 
      Caption         =   "Frame4"
      Height          =   5175
      Index           =   3
      Left            =   3960
      TabIndex        =   4
      Top             =   1080
      Width           =   3135
      Begin VB.TextBox Text4 
         BackColor       =   &H8000000F&
         BorderStyle     =   0  'None
         ForeColor       =   &H00000000&
         Height          =   210
         Index           =   0
         Left            =   1200
         TabIndex        =   22
         Text            =   "a4"
         Top             =   240
         Width           =   560
      End
      Begin VB.Label Label4 
         AutoSize        =   -1  'True
         Caption         =   "lbl4"
         ForeColor       =   &H00800000&
         Height          =   180
         Index           =   0
         Left            =   120
         TabIndex        =   15
         Top             =   240
         Width           =   360
      End
   End
   Begin VB.Frame Frame1 
      Caption         =   "Frame3"
      Height          =   5175
      Index           =   2
      Left            =   3720
      TabIndex        =   3
      Top             =   480
      Width           =   3135
      Begin VB.PictureBox GoodsPbox 
         AutoRedraw      =   -1  'True
         Height          =   1455
         Index           =   0
         Left            =   120
         ScaleHeight     =   93
         ScaleMode       =   3  'Pixel
         ScaleWidth      =   85
         TabIndex        =   25
         Top             =   240
         Width           =   1335
      End
      Begin VB.TextBox Text3 
         BackColor       =   &H8000000F&
         BorderStyle     =   0  'None
         ForeColor       =   &H00000000&
         Height          =   210
         Index           =   0
         Left            =   2760
         TabIndex        =   12
         Text            =   "a3"
         Top             =   240
         Width           =   560
      End
      Begin VB.Label Label3 
         AutoSize        =   -1  'True
         Caption         =   "lbl3"
         ForeColor       =   &H00800000&
         Height          =   180
         Index           =   0
         Left            =   1680
         TabIndex        =   13
         Top             =   240
         Width           =   360
      End
   End
   Begin VB.Frame Frame1 
      Caption         =   "Frame2"
      Height          =   5175
      Index           =   1
      Left            =   120
      TabIndex        =   2
      Top             =   240
      Width           =   3375
      Begin VB.PictureBox NpcPbox 
         Height          =   2055
         Index           =   1
         Left            =   0
         ScaleHeight     =   133
         ScaleMode       =   3  'Pixel
         ScaleWidth      =   104
         TabIndex        =   27
         Top             =   1320
         Width           =   1620
      End
      Begin VB.PictureBox NpcPbox 
         AutoRedraw      =   -1  'True
         Height          =   1095
         Index           =   0
         Left            =   0
         ScaleHeight     =   69
         ScaleMode       =   3  'Pixel
         ScaleWidth      =   106
         TabIndex        =   20
         Top             =   240
         Width           =   1650
      End
      Begin VB.TextBox Text2 
         BackColor       =   &H8000000F&
         BorderStyle     =   0  'None
         ForeColor       =   &H00000000&
         Height          =   210
         Index           =   0
         Left            =   2760
         TabIndex        =   10
         Text            =   "a2"
         Top             =   240
         Width           =   560
      End
      Begin VB.Label Label2 
         AutoSize        =   -1  'True
         Caption         =   "lbl2"
         ForeColor       =   &H00800000&
         Height          =   180
         Index           =   0
         Left            =   1680
         TabIndex        =   11
         Top             =   240
         Width           =   360
      End
   End
   Begin MSComctlLib.TabStrip TabStrip1 
      Height          =   7695
      Left            =   0
      TabIndex        =   0
      Top             =   0
      Width           =   11895
      _ExtentX        =   20981
      _ExtentY        =   13573
      _Version        =   393216
      BeginProperty Tabs {1EFB6598-857C-11D1-B16A-00C0F0283628} 
         NumTabs         =   6
         BeginProperty Tab1 {1EFB659A-857C-11D1-B16A-00C0F0283628} 
            Caption         =   "基本数据"
            ImageVarType    =   2
         EndProperty
         BeginProperty Tab2 {1EFB659A-857C-11D1-B16A-00C0F0283628} 
            Caption         =   "人物"
            ImageVarType    =   2
         EndProperty
         BeginProperty Tab3 {1EFB659A-857C-11D1-B16A-00C0F0283628} 
            Caption         =   "物品"
            ImageVarType    =   2
         EndProperty
         BeginProperty Tab4 {1EFB659A-857C-11D1-B16A-00C0F0283628} 
            Caption         =   "场景"
            ImageVarType    =   2
         EndProperty
         BeginProperty Tab5 {1EFB659A-857C-11D1-B16A-00C0F0283628} 
            Caption         =   "武功"
            ImageVarType    =   2
         EndProperty
         BeginProperty Tab6 {1EFB659A-857C-11D1-B16A-00C0F0283628} 
            Caption         =   "小宝商店"
            ImageVarType    =   2
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
End
Attribute VB_Name = "frmRxEdit"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Option Explicit
Private Type GoodsNumType
 a As Integer
 b As Integer
End Type

Private Type NpcType 'length=b6
 a(0 To 3) As Integer
 b As String * 10
 c As String * 10
 d(0 To 76) As Integer
End Type

Private Type GoodsType 'length=be
 a As Integer
 b As String * 20
 c As String * 20
 d As String * 30
 e(0 To 58) As Integer
End Type

Private Type AddType 'length=34
 a As Integer
 b As String * 10
 c(0 To 19) As Integer
End Type

Private Type WgType 'length=88
 a As Integer
 b As String * 10
 c(0 To 61) As Integer
End Type

Private Type XiaoBaoType
 gName(0 To 4) As Integer
 gNum(0 To 4) As Integer
 gPay(0 To 4) As Integer
End Type

Private Type Part1 '基本0
'在船上/未知/X/Y/nX/nY/未知/X/Y/nX/nY/未知/未知/1/2/3/4/5/未知
 inBoat(0 To 17)    As Integer
 Goods(&H0 To &HC7) As GoodsNumType
End Type
 '人物344'物品e6c4 '武功17b34'场景18c44'小宝1bdac
Dim RxPart1 As Part1
Dim NpcAtt(0 To &H13F) As NpcType
Dim GoodsAtt(0 To &HC7) As GoodsType
Dim WgAtt(0 To &H5C) As WgType
Dim AddAtt(0 To &H53) As AddType
Dim BaoAtt(0 To 4) As XiaoBaoType
Dim CurrentJinDu As Integer, Started As Boolean
Dim POPLST As Integer
Dim CurrentInpLbl As Label, CurrentInpTxt As TextBox, CurrentItmIdx As Integer
Dim CurrentNpc As Integer, CurrentGoods As Integer, CurrentAdd As Integer, CurrentWg As Integer
Dim EnabelANI As Boolean, ANIstartIDX As Integer, ANIendIDX As Integer, CurrentAniIdx As Integer
Dim CurrentAniGrpFile As String, CurrentAniIdxFile As String, CurrentAniBox As PictureBox
Dim CurrentLanguage As String

Private Sub chkSort_Click()
If chkSort.Value = 0 Then
  ListView1.Visible = False
  Exit Sub
End If
'MsgBox TabStrip1.SelectedItem.Index - 2
Dim I As Integer, K As Integer
Dim clmX As ColumnHeader, itmX As ListItem
With ListView1
    .Visible = True
    .ListItems.Clear
    .ColumnHeaders.Clear
    .ColumnHeaders.add , , "ID", 32
    Select Case TabStrip1.SelectedItem.Index - 2
      Case 0
        For I = 0 To Label2.UBound
          .ColumnHeaders.add , , Label2(I).Caption, 48
        Next
        For K = 0 To UBound(NpcAtt)
        Set itmX = ListView1.ListItems.add(, , K)
           For I = 0 To 3
             itmX.SubItems(I + 1) = NpcAtt(K).a(I)
           Next
             itmX.SubItems(5) = NpcAtt(K).b
             itmX.SubItems(6) = NpcAtt(K).c
           For I = 0 To UBound(NpcAtt(K).d)
             itmX.SubItems(I + 7) = NpcAtt(K).d(I)
           Next
        Next
      Case 1
        For I = 0 To Label3.UBound
          .ColumnHeaders.add , , Label3(I).Caption, 48
        Next
        For K = 0 To UBound(GoodsAtt)
        Set itmX = ListView1.ListItems.add(, , K)
             itmX.SubItems(1) = GoodsAtt(K).a
             itmX.SubItems(2) = GoodsAtt(K).b
             itmX.SubItems(3) = GoodsAtt(K).c
             itmX.SubItems(4) = GoodsAtt(K).d
           For I = 0 To UBound(GoodsAtt(K).e)
             itmX.SubItems(I + 5) = GoodsAtt(K).e(I)
           Next
        Next
      Case 2
        For I = 0 To Label4.UBound
          .ColumnHeaders.add , , Label4(I).Caption, 48
        Next
        For K = 0 To UBound(AddAtt)
        Set itmX = ListView1.ListItems.add(, , K)
             itmX.SubItems(1) = AddAtt(K).a
             itmX.SubItems(2) = AddAtt(K).b
           For I = 0 To UBound(AddAtt(K).c)
             itmX.SubItems(I + 3) = AddAtt(K).c(I)
           Next
        Next
      Case 3
        For I = 0 To Label5.UBound
          .ColumnHeaders.add , , Label5(I).Caption, 48
        Next
        For K = 0 To UBound(WgAtt)
        Set itmX = ListView1.ListItems.add(, , K)
             itmX.SubItems(1) = WgAtt(K).a
             itmX.SubItems(2) = WgAtt(K).b
           For I = 0 To UBound(WgAtt(K).c)
             itmX.SubItems(I + 3) = WgAtt(K).c(I)
           Next
        Next
    End Select
End With
End Sub

Private Sub ListView1_Click()
Dim tempIDX As Integer
tempIDX = TabStrip1.SelectedItem.Index - 2
List1(tempIDX).ListIndex = Val(ListView1.ListItems(ListView1.SelectedItem.Index).Text)
Call List1_MouseUp(tempIDX, vbLeftButton, 0, 0, 0)
End Sub

Private Sub ListView1_ColumnClick(ByVal ColumnHeader As MSComctlLib.ColumnHeader)
Dim I As Integer
With ColumnHeader
If .Index = 1 Then Exit Sub
Select Case TabStrip1.SelectedItem.Index - 2
  Case 0
   If .Index = 6 Or .Index = 7 Then Exit Sub
  Case 1
   If .Index = 3 Or .Index = 4 Or .Index = 5 Then Exit Sub
  Case 2, 3
   If .Index = 3 Then Exit Sub
End Select
End With
With ListView1
    .SortKey = ColumnHeader.Index - 1
    '以下是按SIZE排序的程序
        For I = 1 To .ListItems.count
           .ListItems(I).ListSubItems(.SortKey).Text = Format(.ListItems(I).ListSubItems(.SortKey).Text, "000000")
        Next
        If .SortOrder = lvwDescending Then
          .SortOrder = lvwAscending
        Else
          .SortOrder = lvwDescending
        End If
        .Sorted = True
        For I = 1 To .ListItems.count
           .ListItems(I).ListSubItems(.SortKey).Text = Val(.ListItems(I).ListSubItems(.SortKey).Text)
        Next
End With
End Sub
'****************启动******************
Private Sub Form_Load()
Dim I As Integer
For I = 0 To Frame1.count - 1
Frame1(I).Move TabStrip1.ClientLeft, TabStrip1.ClientTop, TabStrip1.ClientWidth, TabStrip1.ClientHeight
Frame1(I).Caption = TabStrip1.Tabs(I + 1).Caption
Next I
If MDIFormMain.mnu2_RxEdit3(0).Checked Then CurrentLanguage = "GB" Else CurrentLanguage = "BIG5"
ReadRx_GRPfile READMODE, 0, 6, 0
iniCtrl
    Set CurrentInpLbl = Label1(0)
    Set CurrentInpTxt = Text1(0)
RefreshCtrl 1, 6
Started = True
Me.Icon = MDIFormMain.Icon
If Not palOK Then Call SetColor    '调色板初始化
End Sub
Private Sub setListSel(tempList As ListBox, temp1 As Integer)
If temp1 > -1 And temp1 < tempList.ListCount Then
 tempList.ListIndex = temp1
Else
 tempList.ListIndex = 0
End If

End Sub

Function RightX(tempstr1 As String, Start As Integer) As String
RightX = Right(tempstr1, Len(tempstr1) - Start)
End Function

Private Sub Frame1_DblClick(Index As Integer)
'Dim fileId As Long, I As Integer
'fileId = FreeFile
'Open "c:\windows\desktop\list1.txt" For Output As #fileId
'For I = 300 To 383
'  Print #fileId, LoadResString(I)
'Next
'Close #fileId
End Sub

Private Sub Label1_MouseMove(Index As Integer, Button As Integer, Shift As Integer, X As Single, Y As Single)
Text1(Index).SetFocus
End Sub
Private Sub Label2_MouseMove(Index As Integer, Button As Integer, Shift As Integer, X As Single, Y As Single)
Text2(Index).SetFocus
End Sub
Private Sub Label3_MouseMove(Index As Integer, Button As Integer, Shift As Integer, X As Single, Y As Single)
Text3(Index).SetFocus
End Sub
Private Sub Label4_MouseMove(Index As Integer, Button As Integer, Shift As Integer, X As Single, Y As Single)
Text4(Index).SetFocus
End Sub
Private Sub Label5_MouseMove(Index As Integer, Button As Integer, Shift As Integer, X As Single, Y As Single)
Text5(Index).SetFocus
End Sub
Private Sub Label6_MouseMove(Index As Integer, Button As Integer, Shift As Integer, X As Single, Y As Single)
Text6(Index).SetFocus
End Sub

 '点击标签
Private Sub Label1_MouseUp(Index As Integer, Button As Integer, Shift As Integer, X As Single, Y As Single)
If Button = vbLeftButton Then
    CurrentInpLbl.BackColor = &H8000000F
    Set CurrentInpLbl = Label1(Index)
    Set CurrentInpTxt = Text1(Index)
    CurrentInpLbl.BackColor = &HFFFFFF - CurrentInpLbl.ForeColor
    Select Case Index
     Case 2, 3
      SetParent List1(2).hwnd, Frame1(0).hwnd
      List1(2).Visible = True
      List1(2).SetFocus
      ClipMode = Not ClipMode '限制鼠标
      SetCursor List1(2), ClipMode
     Case 13 To 17
      setListSel List1(0), RxPart1.inBoat(Index)
      SetParent List1(0).hwnd, Frame1(0).hwnd
      List1(0).Visible = True
      List1(0).SetFocus
      ClipMode = Not ClipMode '限制鼠标
      SetCursor List1(0), ClipMode
     Case Is > 17
      Set CurrentInpTxt = Nothing
      CurrentItmIdx = Index - 18
      SetParent List1(1).hwnd, Frame1(0).hwnd
      List1(1).Visible = True
      List1(1).SetFocus
      setListSel List1(1), RxPart1.Goods(CurrentItmIdx).a
      ClipMode = Not ClipMode '限制鼠标
      SetCursor List1(1), ClipMode
    End Select
Else
 If Index > 17 Then
  Text1(Index).Text = 0
  RxPart1.Goods(Index - 18).a = -1
  Label1(Index).Caption = "无"
 End If
End If
End Sub
 '点击标签
Private Sub Label2_MouseUp(Index As Integer, Button As Integer, Shift As Integer, X As Single, Y As Single)
If Button = vbLeftButton Then
    CurrentInpLbl.BackColor = &H8000000F
    Set CurrentInpLbl = Label2(Index)
    Set CurrentInpTxt = Text2(Index)
    CurrentInpLbl.BackColor = &HFFFFFF - CurrentInpLbl.ForeColor
    Select Case Index
     Case 55 To 64
      setListSel List1(3), NpcAtt(CurrentNpc).d(Index - 6)
      SetParent List1(3).hwnd, Frame1(1).hwnd
      List1(3).Visible = True
      List1(3).SetFocus
      ClipMode = Not ClipMode '限制鼠标,武功
      SetCursor List1(3), ClipMode
     Case 15, 16, 53, 75 To 78
      setListSel List1(1), NpcAtt(CurrentNpc).d(Index - 6)
      SetParent List1(1).hwnd, Frame1(1).hwnd
      List1(1).Visible = True
      List1(1).SetFocus
      ClipMode = Not ClipMode '限制鼠标,物品
      SetCursor List1(1), ClipMode
    End Select
 End If
End Sub
Private Sub Label3_MouseUp(Index As Integer, Button As Integer, Shift As Integer, X As Single, Y As Single)
If Button = vbLeftButton Then
    CurrentInpLbl.BackColor = &H8000000F
    Set CurrentInpLbl = Label3(Index)
    Set CurrentInpTxt = Text3(Index)
    CurrentInpLbl.BackColor = &HFFFFFF - CurrentInpLbl.ForeColor
    Select Case Index
     Case 4
      setListSel List1(3), GoodsAtt(CurrentGoods).e(Index - 4)
      SetParent List1(3).hwnd, Frame1(2).hwnd
      List1(3).Visible = True
      List1(3).SetFocus
      ClipMode = Not ClipMode '限制鼠标，武功
      SetCursor List1(3), ClipMode
     Case 52 To 57
      setListSel List1(1), GoodsAtt(CurrentGoods).e(Index - 4)
      SetParent List1(1).hwnd, Frame1(2).hwnd
      List1(1).Visible = True
      List1(1).SetFocus
      ClipMode = Not ClipMode '限制鼠标，物品
      SetCursor List1(1), ClipMode
     Case 6, 36
      setListSel List1(0), GoodsAtt(CurrentGoods).e(Index - 4)
      SetParent List1(0).hwnd, Frame1(2).hwnd
      List1(0).Visible = True
      List1(0).SetFocus
      ClipMode = Not ClipMode '限制鼠标，人物
      SetCursor List1(0), ClipMode
    End Select
 End If
End Sub
Private Sub Label4_MouseUp(Index As Integer, Button As Integer, Shift As Integer, X As Single, Y As Single)
If Button = vbLeftButton Then
    
    If Index = 2 Then
      If CurrentInpLbl Is Label4(Index) Then
         MidiStop
      Else
         MidiPlay Val(Text4(Index).Text)
      End If
    End If
    If Index = 3 Then
      If CurrentInpLbl Is Label4(Index) Then
         MidiStop
      Else
         MidiPlay Val(Text4(Index).Text)
      End If
    End If
    CurrentInpLbl.BackColor = &H8000000F
    Set CurrentInpLbl = Label4(Index)
    Set CurrentInpTxt = Text4(Index)
    CurrentInpLbl.BackColor = &HFFFFFF - CurrentInpLbl.ForeColor

    If Index = 4 Then
          setListSel List1(2), AddAtt(CurrentAdd).c(2)
          SetParent List1(2).hwnd, Frame1(3).hwnd
          List1(2).Visible = True
          List1(2).SetFocus
          ClipMode = Not ClipMode '限制鼠标，武功
          SetCursor List1(2), ClipMode
    End If
End If
End Sub
Private Sub Label5_MouseUp(Index As Integer, Button As Integer, Shift As Integer, X As Single, Y As Single)
    CurrentInpLbl.BackColor = &H8000000F
    Set CurrentInpLbl = Label5(Index)
    Set CurrentInpTxt = Text5(Index)
    CurrentInpLbl.BackColor = &HFFFFFF - CurrentInpLbl.ForeColor
End Sub
Private Sub Label6_MouseUp(Index As Integer, Button As Integer, Shift As Integer, X As Single, Y As Single)
If Button = vbLeftButton Then
    CurrentInpLbl.BackColor = &H8000000F
    Set CurrentInpLbl = Label6(Index)
    Set CurrentInpTxt = Text6(Index)
    CurrentInpLbl.BackColor = &HFFFFFF - CurrentInpLbl.ForeColor
    If Index Mod 15 < 5 Then
      setListSel List1(1), BaoAtt(Index \ 15).gName(Index Mod 5)
      SetParent List1(1).hwnd, Frame1(5).hwnd
      List1(1).Visible = True
      List1(1).SetFocus
      ClipMode = Not ClipMode '限制鼠标，物品
      SetCursor List1(1), ClipMode
    End If
 End If
End Sub
Private Sub List1_GotFocus(Index As Integer)
'Oldwinproc = GetWindowLong(Me.hwnd, GWL_WNDPROC)
'SetWindowLong Me.hwnd, GWL_WNDPROC, AddressOf FlexScroll
End Sub
Private Sub List1_KeyUp(Index As Integer, KeyCode As Integer, Shift As Integer)
List1_MouseUp Index, vbLeftButton, Shift, 0, 0
End Sub

Private Sub List1_MouseMove(Index As Integer, Button As Integer, Shift As Integer, X As Single, Y As Single)

    Dim lXPoint As Long
    Dim lYPoint As Long
    Dim lIndex As Long

    If Button = 0 Then  '确定在移动鼠标的同时没有按下功能键或者鼠标键
        '获得光标的位置，以像素为单位
        lXPoint = CLng(X / Screen.TwipsPerPixelX)
        lYPoint = CLng(Y / Screen.TwipsPerPixelY)
        '
        With List1(Index)
            '获得 光标所在的标题行的索引
            lIndex = SendMessage(.hwnd, LB_ITEMFROMPOINT, 0, _
                ByVal ((lYPoint * 65536) + lXPoint))
            '将ListBox的Tooltip设置为该标题行的文本
            If (lIndex >= 0) And (lIndex <= .ListCount) Then
              If Index = 2 Then
                .ToolTipText = "(" & AddAtt(lIndex).c(4) & "," & AddAtt(lIndex).c(5) & ")" & LoadResString(lIndex + 300) 'Return the text = .list(lIndex)
                setStaBarText 1, .ToolTipText
              End If
            Else
                .ToolTipText = ""
            End If
        End With
    End If

End Sub

'点击列表
Private Sub List1_MouseUp(Index As Integer, Button As Integer, Shift As Integer, X As Single, Y As Single)
Select Case Index
    Case 0
      List0_Up Index, Button
      If ClipMode Then ClipMode = Not ClipMode: SetCursor List1(0), ClipMode
    Case 1
      List1_Up Index, Button
      If ClipMode Then ClipMode = Not ClipMode: SetCursor List1(1), ClipMode
    Case 2
      List2_Up Index, Button
      If ClipMode Then ClipMode = Not ClipMode: SetCursor List1(2), ClipMode
    Case 3
      List3_Up Index, Button
      If ClipMode Then ClipMode = Not ClipMode: SetCursor List1(3), ClipMode
End Select
End Sub
Private Sub List0_Up(Index As Integer, Button As Integer) '点击了列表人物
Select Case TabStrip1.SelectedItem.Index
  Case 1, 3 '通用
    DoWith_ListClick Index, Button
  Case 2
    If List1(Index).ListIndex > -1 Then CurrentNpc = List1(Index).ListIndex
    RefreshCtrl 2, 2
End Select

End Sub
Private Sub List1_Up(Index As Integer, Button As Integer) '点击了列表物品
If TabStrip1.SelectedItem.Index = 3 And Not ClipMode Then
    If List1(Index).ListIndex > -1 Then CurrentGoods = List1(Index).ListIndex
    RefreshCtrl 3, 3
End If
If ClipMode Then
    DoWith_ListClick Index, Button
    If TabStrip1.SelectedItem.Index = 1 And RxPart1.Goods(CurrentItmIdx).a > -1 Then CurrentInpLbl.ForeColor = QBColor(GoodsAtt(RxPart1.Goods(CurrentItmIdx).a).e(5))
    If TabStrip1.SelectedItem.Index = 3 Then
      List1(1).Visible = True '物品中的物品
      List1(1).ListIndex = CurrentGoods
    End If
End If
End Sub
Private Sub List2_Up(Index As Integer, Button As Integer) '点击了列表场景
If TabStrip1.SelectedItem.Index = 4 And Not ClipMode Then
    If List1(Index).ListIndex > -1 Then CurrentAdd = List1(Index).ListIndex
    RefreshCtrl 4, 4
End If
If ClipMode Then
 Select Case TabStrip1.SelectedItem.Index
  Case 1
    List1(Index).Visible = False
    Text1(2).Text = AddAtt(List1(Index).ListIndex).c(4)
    Text1(3).Text = AddAtt(List1(Index).ListIndex).c(5)
  Case 4
    DoWith_ListClick Index, Button
    List1(2).Visible = True '场景中的场景
    List1(2).ListIndex = CurrentAdd
 End Select
End If
End Sub
Private Sub List3_Up(Index As Integer, Button As Integer) '点击了列表武功
Select Case TabStrip1.SelectedItem.Index
  Case 2, 3 '通用
    DoWith_ListClick Index, Button
  Case 5
    If List1(Index).ListIndex > -1 Then CurrentWg = List1(Index).ListIndex
    RefreshCtrl 5, 5
End Select
End Sub
Private Sub DoWith_ListClick(Index As Integer, Button As Integer) '处理通用点击
List1(Index).Visible = False
    If List1(Index).ListIndex < 0 Then Exit Sub
    If Button = vbLeftButton Then
        CurrentInpLbl.Caption = RightX(List1(Index).List(List1(Index).ListIndex), 4)
        If CurrentInpTxt Is Nothing Then
           
           If TabStrip1.TabIndex = 0 Then RxPart1.Goods(CurrentItmIdx).a = List1(Index).ListIndex
         Else
          CurrentInpTxt.Text = List1(Index).ListIndex
        End If
    End If
End Sub

Private Sub NpcPbox_Click(Index As Integer)
If Index = 1 Then
  With NpcPbox(1)
    If .Width > 1650 Then .Width = NpcPbox(0).Width Else .Width = NpcPbox(0).Width * 2
  End With
End If
End Sub

Private Sub TabStrip1_Click()
TimerWgAniCtl.Enabled = False
Frame1(TabStrip1.SelectedItem.Index - 1).ZOrder 0
Dim temp1 As Integer
temp1 = TabStrip1.SelectedItem.Index - 2
If temp1 > -1 And temp1 < 4 Then
  With List1(temp1)
        SetParent .hwnd, Frame1(temp1 + 1).hwnd
        .Visible = True
        .Move 50, 3400, 11700, 4000
    Select Case temp1
     Case -1 '基本数据
     Case 0
        .Columns = 10
     Case 1
        .Columns = 7
        .Move .Left, 2750, .Width, 4600
     Case 2
     Case 3
        .Columns = 4
        .Move .Left, 2550, 6000, 4800
     Case 4
    End Select
   chkSort.Enabled = True
   SetParent ListView1.hwnd, Frame1(temp1 + 1).hwnd
   ListView1.Move .Left / 15, .Top / 15, .Width / 15, .Height / 15 ', .Width, .Height
   'Debug.Print .Left, .Top, .Width, .Height
   ListView1.Visible = False
  End With
Else
   chkSort.Enabled = False
End If
chkSort.Value = 0

End Sub



Private Sub Text1_GotFocus(Index As Integer) 'Text1焦点
TextN_GotFocus Text1(Index), Label1(Index)
End Sub
Private Sub Text2_GotFocus(Index As Integer) 'Text1焦点
TextN_GotFocus Text2(Index), Label2(Index)
End Sub
Private Sub Text3_GotFocus(Index As Integer) 'Text1焦点
TextN_GotFocus Text3(Index), Label3(Index)
End Sub
Private Sub Text4_GotFocus(Index As Integer) 'Text1焦点
TextN_GotFocus Text4(Index), Label4(Index)
End Sub
Private Sub Text5_GotFocus(Index As Integer) 'Text1焦点
TextN_GotFocus Text5(Index), Label5(Index)
End Sub
Private Sub Text6_GotFocus(Index As Integer) 'Text1焦点
TextN_GotFocus Text6(Index), Label6(Index)
End Sub
Private Sub TextN_GotFocus(tempText As TextBox, tempLabel As Label)
tempText.SelStart = 0
tempText.SelLength = Len(tempText)
setStaBarText 1, tempLabel.ToolTipText
End Sub
Private Sub Text1_Change(Index As Integer) 'Text1改变
'If Not Started Then Exit Sub
If Not ChkInt(Text1(Index).Text) Then Text1(Index).Text = 0: Exit Sub
Dim temp1 As Integer, temp2
temp1 = Val(Text1(Index).Text)
Select Case Index
 Case 0 To 12
  RxPart1.inBoat(Index) = temp1
 Case 13 To 17
         Select Case temp1
          Case Is < -1
           Label1(Index).Caption = "隊伍(無效)"
          Case -1
           Label1(Index).Caption = "隊伍(空)"
          Case Is <= UBound(NpcAtt)
           Label1(Index).Caption = "隊伍(" & NpcAtt(temp1).b & ")"
          Case Else
           Label1(Index).Caption = "隊伍(無效)"
         End Select
    RxPart1.inBoat(Index) = temp1 '写入内存
 Case Is > 17
    RxPart1.Goods(Index - 18).b = temp1 '写入内存
    temp2 = RxPart1.Goods(Index - 18).a
         If temp2 < 0 Or temp2 > 199 Then
            Label1(Index).Caption = "无"
            Label1(Index).ToolTipText = ""
            Label1(Index).ForeColor = &H888888
         Else
            Label1(Index).Caption = GoodsAtt(temp2).b
            Label1(Index).ToolTipText = "[" & Label1(Index).Caption & "] " & GoodsAtt(temp2).d
            Label1(Index).ForeColor = QBColor(GoodsAtt(temp2).e(5))
         End If
    If temp1 < 1 Or temp2 < 0 Then Label1(Index).ForeColor = &H888888
End Select

End Sub
Private Sub Text2_Change(Index As Integer) 'Text2改变
If Not ChkInt(Text2(Index).Text) Then Text2(Index).Text = 0: Exit Sub
Dim temp1 As Integer, hFile As Long, lenFile As Long, ret As Long
temp1 = Val(Text2(Index).Text)
Select Case Index
 Case 0 To 3
  'If temp1 > UBound(FIGHTxxx_GRP) Then Text2(Index).Text = UBound(FIGHTxxx_GRP): Exit Sub
  NpcAtt(CurrentNpc).a(Index) = temp1
  If Index = 1 Then
    DrawOneTile2 tempPicbox, NpcPbox(0), 0, 0, 0, 0, GamePath & HDGRP_GRP, GamePath & HDGRP_IDX, (temp1), False, True
    'DrawOneTile2 tempPicbox, NpcPbox(1), 0, 0, GamePath & FIGHTxxx_GRP((temp1)), GamePath & FIGHTxxx_IDX((temp1)), Int(Rnd * 8), False
      On Error GoTo fileErr
      lenFile = FileLen(GamePath & FIGHTxxx_IDX((temp1)))
      On Error GoTo 0
      If lenFile > 0 And Started Then '人物动画改变!!!
         ANIstartIDX = 0
         ANIendIDX = lenFile \ 4 - 1
         CurrentAniIdx = ANIstartIDX
         CurrentAniGrpFile = GamePath & FIGHTxxx_GRP((temp1))
         CurrentAniIdxFile = GamePath & FIGHTxxx_IDX((temp1))
         Set CurrentAniBox = NpcPbox(1)
         'sndPlaySound GamePath & "E" & Format(temp1, "00") & ".WAV", SND_ASYNC Or SND_NODEFAULT
         
         TimerWgAniCtl = True
      End If
  End If
 Case 4
  NpcAtt(CurrentNpc).b = Text2(Index).Text
 Case 5
  NpcAtt(CurrentNpc).c = Text2(Index).Text
 Case 55 To 64
  If temp1 > UBound(WgAtt) Or temp1 < LBound(WgAtt) Then
    Label2(Index).Caption = "所會武功(無)"
    Label2(Index).ForeColor = &H888888
  Else
    Label2(Index).Caption = WgAtt(temp1).b
    Label2(Index).ForeColor = vbBlue
  End If
 Case 15, 16, 53, 75 To 78
  If temp1 > UBound(GoodsAtt) Or temp1 < LBound(GoodsAtt) Then
    If Index = 16 Then Label2(Index).Caption = "身穿(無)"
    If Index = 15 Then Label2(Index).Caption = "手持(無)"
    If Index = 53 Then Label2(Index).Caption = "修煉物品(無)"
    If Index > 53 Then Label2(Index).Caption = "隨身物品(無)"
    Label2(Index).ForeColor = &H888888
  Else
    Label2(Index).Caption = GoodsAtt(temp1).c
    Label2(Index).ForeColor = vbBlue
  End If
End Select
If Index > 5 Then NpcAtt(CurrentNpc).d(Index - 6) = temp1
Exit Sub

fileErr:
lenFile = 0
setStaBarText 1, "打開文件" & GamePath & "FIGHT" & Format(temp1, "000") & ".IDX" & "失敗!"
NpcPbox(1).Cls
TimerWgAniCtl.Enabled = False
Resume Next
End Sub
Private Sub Text3_Change(Index As Integer) 'Text3改变
If Not ChkInt(Text3(Index).Text) Then Text3(Index).Text = 0: Exit Sub
Dim temp1 As Integer
temp1 = Val(Text3(Index).Text)
Select Case Index
 Case 0
  GoodsAtt(CurrentGoods).a = temp1
  DrawOneTile2 tempPicbox, GoodsPbox(0), 0, 0, 0, 0, GamePath & SMPxxx(0), GamePath & SDXxxx(0), (temp1) + 3501, False, True
 Case 1
  GoodsAtt(CurrentGoods).b = Text3(Index).Text
 Case 2
  GoodsAtt(CurrentGoods).c = Text3(Index).Text
 Case 3
  GoodsAtt(CurrentGoods).d = Text3(Index).Text
 Case 4
  If temp1 > UBound(WgAtt) Or temp1 < LBound(WgAtt) Then
    Label3(Index).Caption = "煉出武功(無)"
    Label3(Index).ForeColor = &H888888
    Exit Sub
  Else
    Label3(Index).Caption = WgAtt(temp1).b
    Label3(Index).ForeColor = vbBlue
  End If
 Case 52
  Label3(Index).ForeColor = vbBlue
  If temp1 > UBound(GoodsAtt) Or temp1 < LBound(GoodsAtt) Then
    Label3(Index).Caption = "所需材料(無)"
  Else
    Label3(Index).Caption = "+" & GoodsAtt(temp1).c
  End If
 Case 53 To 57
  If temp1 > UBound(GoodsAtt) Or temp1 < LBound(GoodsAtt) Then
    Label3(Index).Caption = "煉出物品(無)"
    Label3(Index).ForeColor = &H888888
  Else
    Label3(Index).Caption = GoodsAtt(temp1).c
    Label3(Index).ForeColor = vbBlue
  End If
 Case 6, 36
  If temp1 > UBound(NpcAtt) Or temp1 < LBound(NpcAtt) Then
    If Index = 6 Then Label3(Index).Caption = "誰在使用(無)" Else Label3(Index).Caption = "僅修煉人(無)"
    Label3(Index).ForeColor = &H888888
    'If Temp1 = -1 Then Label3(Index).Caption = ""
  Else
    Label3(Index).Caption = NpcAtt(temp1).b
    Label3(Index).ForeColor = vbBlue
  End If
End Select
If Index > 3 Then GoodsAtt(CurrentGoods).e(Index - 4) = temp1
End Sub
Private Sub Text4_Change(Index As Integer)
If Not ChkInt(Text4(Index).Text) Then Text4(Index).Text = 0: Exit Sub
Dim temp1 As Integer, Song As String
temp1 = Val(Text4(Index).Text)
Select Case Index
 Case 0
  AddAtt(CurrentAdd).a = temp1
 Case 1
  AddAtt(CurrentAdd).b = Text4(Index).Text
 Case 2
   If CurrentInpLbl Is Label4(2) Then
     MidiPlay Val(Text4(2).Text)
   End If
 Case 3
   If CurrentInpLbl Is Label4(2) Then Else MidiPlay temp1
 Case 4
  If temp1 > UBound(AddAtt) Or temp1 < LBound(AddAtt) Then
    Label4(Index).Caption = "跳轉場景(無)"
    Label4(Index).ForeColor = &H888888
  Else
    Label4(Index).Caption = "通向" & AddAtt(temp1).b & ""
    Label4(Index).ForeColor = vbBlue
  End If
End Select
If Index > 1 Then AddAtt(CurrentAdd).c(Index - 2) = temp1
End Sub
Private Sub Text5_Change(Index As Integer)
If Not ChkInt(Text5(Index).Text) Then Text5(Index).Text = 0: Exit Sub
Dim temp1 As Integer, tempStr As String
temp1 = Val(Text5(Index).Text)
Select Case Index
 Case 0
  WgAtt(CurrentWg).a = temp1
 Case 1
  WgAtt(CurrentWg).b = Text5(Index).Text
 Case Is > 1
  WgAtt(CurrentWg).c(Index - 2) = temp1
End Select
If Index = 7 And temp1 < 53 And Started Then  '武功形状动画改变!!!
  sndPlaySound GamePath & "ATK" & Format(WgAtt(CurrentWg).c(5), "00") & ".WAV", SND_ASYNC Or SND_NOSTOP
End If
If Index = 9 And temp1 < 53 And Started Then  '武功形状动画改变!!!
  tempStr = LoadResString(252)
    ANIstartIDX = Val(Mid(tempStr, temp1 * 4 + 1, 3))
    ANIendIDX = Val(Mid(tempStr, (temp1 + 1) * 4 + 1, 3)) - 1
    CurrentAniIdx = ANIstartIDX
    CurrentAniGrpFile = GamePath & EFT_GRP
    CurrentAniIdxFile = GamePath & EFT_IDX
    Set CurrentAniBox = WgPbox(0)
    sndPlaySound GamePath & "E" & Format(WgAtt(CurrentWg).c(7), "00") & ".WAV", SND_ASYNC Or SND_NOSTOP
    TimerWgAniCtl = True
End If
End Sub
Private Sub Text6_Change(Index As Integer)
If Not ChkInt(Text6(Index).Text) Then Text6(Index).Text = 0: Exit Sub
Dim temp1 As Integer
temp1 = Val(Text6(Index).Text)
Dim K As Integer, M As Integer
K = Index \ 15
M = Index Mod 5
Select Case (Index Mod 15) \ 5
    Case 0
      BaoAtt(K).gName(M) = temp1
    Case 1
      BaoAtt(K).gNum(M) = temp1
    Case 2
      BaoAtt(K).gPay(M) = temp1
End Select
If Index = K * 15 + M Then '物品改变
  If temp1 > UBound(GoodsAtt) Or temp1 < LBound(GoodsAtt) Then
    Label6(Index).Caption = "煉出物品(無)"
    Label6(Index).ForeColor = &H888888
  Else
    Label6(Index).Caption = GoodsAtt(temp1).c
    Label6(Index).ToolTipText = "[" & Label6(K * 15 + M).Caption & "] " & GoodsAtt(BaoAtt(K).gName(M)).d
    Label6(Index).ForeColor = QBColor(GoodsAtt(BaoAtt(K).gName(M)).e(5))
  End If
End If
If BaoAtt(K).gName(M) < 0 Or BaoAtt(K).gNum(M) < 1 Then
   Label6(K * 15 + M + 5).ForeColor = &H888888
   Label6(K * 15 + M + 10).ForeColor = &H888888
End If
End Sub
Private Sub convListArray(Cstart As Integer, Cend As Integer, Mode1BIG2GB As Integer)
Dim K As Integer, Cc As Integer
For Cc = Cstart To Cend
   Select Case Cc
    Case 2
          For K = 0 To UBound(NpcAtt)
            NpcAtt(K).b = ConvBIG_GBK(NpcAtt(K).b, Mode1BIG2GB)
            NpcAtt(K).c = ConvBIG_GBK(NpcAtt(K).c, Mode1BIG2GB)
          Next
          
    Case 3
          For K = 0 To &HC7
            GoodsAtt(K).b = ConvBIG_GBK(GoodsAtt(K).b, Mode1BIG2GB)
            GoodsAtt(K).c = ConvBIG_GBK(GoodsAtt(K).c, Mode1BIG2GB)
            GoodsAtt(K).d = ConvBIG_GBK(GoodsAtt(K).d, Mode1BIG2GB)
          Next
    Case 4
          For K = 0 To &H53
            AddAtt(K).b = ConvBIG_GBK(AddAtt(K).b, Mode1BIG2GB)
          Next
    Case 5
          For K = 0 To &H5C
            WgAtt(K).b = ConvBIG_GBK(WgAtt(K).b, Mode1BIG2GB)
          Next
  End Select
Next
End Sub
Function ReadRx_GRPfile(Mode As Integer, Cstart As Integer, Cend As Integer, Jindu As Integer) As String
'读一个进度
Dim K As Integer, M As Integer, Cc As Integer
Dim FileNum1 As Integer, tempstr1 As String, Filename As String
CurrentJinDu = Jindu
Filename = GamePath & Rx_GRP(CurrentJinDu)

If Mode = READMODE Then
  tempstr1 = "由於讀取進度失敗，將無法繼續。"
  If ChkRequiredFile(Filename, 114242, tempstr1, tempstr1, "讀取進度可能會出錯") < 2 Then Exit Function
Else
  If CurrentLanguage = "GB" Then '如果简体中文用户，转成繁再存
   CurrentLanguage = "BIG5"
   convListArray Cstart, Cend, 2
   CurrentLanguage = "GB"
  End If
End If
FileNum1 = FreeFile
Open Filename For Binary As #FileNum1
'1 To 6 全部 or 1 to 1 基本
For Cc = Cstart To Cend
If Mode = READMODE Then
   Select Case Cc
    Case 1
          Seek #FileNum1, 1&
          Get #FileNum1, 1, RxPart1
    Case 2
          Seek #FileNum1, &H345&
          For K = 0 To UBound(NpcAtt)
            Get #FileNum1, , NpcAtt(K)
          Next
          
    Case 3
          Seek #FileNum1, &HE6C5&
          For K = 0 To &HC7
            Get #FileNum1, , GoodsAtt(K)
          Next
    Case 4
          Seek #FileNum1, &H17B35
          For K = 0 To &H53
            Get #FileNum1, , AddAtt(K)
          Next
    Case 5
          Seek #FileNum1, &H18C45
          For K = 0 To &H5C
            Get #FileNum1, , WgAtt(K)
          Next
    Case 6
          Seek #FileNum1, &H1BDAD
          For K = 0 To 4
            Get #FileNum1, , BaoAtt(K)
          Next
  End Select
Else
   Select Case Cc
    Case 1
          Seek #FileNum1, 1&
          Put #FileNum1, 1, RxPart1
    Case 2
          For K = 0 To UBound(NpcAtt)
            Put #FileNum1, &H345& + &HB6& * K, NpcAtt(K)
            PutCleanSpace FileNum1, &H345& + &HB6& * K + 8, NpcAtt(K).b
            PutCleanSpace FileNum1, &H345& + &HB6& * K + 18, NpcAtt(K).c
          Next
    Case 3
          For K = 0 To &HC7
            Put #FileNum1, &HE6C5& + &HBE& * K, GoodsAtt(K)
            PutCleanSpace FileNum1, &HE6C5& + &HBE& * K + 2, GoodsAtt(K).b
            PutCleanSpace FileNum1, &HE6C5& + &HBE& * K + 22, GoodsAtt(K).c
            PutCleanSpace FileNum1, &HE6C5& + &HBE& * K + 42, GoodsAtt(K).d
          Next
    Case 4
          For K = 0 To &H53
            Put #FileNum1, &H17B35 + &H34& * K, AddAtt(K)
            PutCleanSpace FileNum1, &H17B35 + &H34& * K + 2, AddAtt(K).b
          Next
    Case 5
          For K = 0 To &H5C
            Put #FileNum1, &H18C45 + &H88& * K, WgAtt(K)
            PutCleanSpace FileNum1, &H18C45 + &H88& * K + 2, WgAtt(K).b
          Next
    Case 6
          Seek #FileNum1, &H1BDAD
          For K = 0 To 4
            Put #FileNum1, , BaoAtt(K)
          Next
  End Select
End If
Next
Close #FileNum1
If CurrentLanguage = "GB" Then convListArray Cstart, Cend, 1 '如果简体中文用户，繁转简
If Started And READMODE Then RefreshCtrl 1, 6
Me.Caption = "基本進度修改器--進度" & (CurrentJinDu + 1)
End Function
Private Sub PutCleanSpace(tempFile As Integer, FoffSet As Long, ByVal sUnicode As String)
Dim ResultAry() As Byte, I As Integer
Dim SomeStr As String
SomeStr = sUnicode
Call ChangeStrAryToByte(SomeStr, ResultAry) '转换字符串数组
For I = LBound(ResultAry) To UBound(ResultAry)
 If ResultAry(I) = 32 Then ResultAry(I) = 0
Next
Put #tempFile, FoffSet, ResultAry
End Sub
     Function GetCharByte(ByVal OneChar As Integer, ByVal IsHighByte As Boolean) As Byte ' 该函数获得一个字符的高字节或低字节
If IsHighByte Then
If OneChar >= 0 Then
GetCharByte = CByte(OneChar \ 256)
'右移8位，得到高字节
Else
GetCharByte = CByte((OneChar And &H7FFF) \ 256) Or &H80
End If
Exit Function
Else
GetCharByte = CByte(OneChar And &HFF)
'屏蔽掉高字节，得到低字节
Exit Function
End If
End Function

Sub StrToByte(StrToChange As String, ByteArray() As Byte)
'该函数将一个字符串转换成字节数组
Dim LowBound, UpBound As Integer
Dim I, count, Length As Integer
Dim OneChar As Integer

count = 0
Length = Len(StrToChange)
LowBound = LBound(ByteArray)
UpBound = UBound(ByteArray)

For I = LowBound To UpBound
ByteArray(I) = 0 '初始化字节数组
Next

For I = LowBound To UpBound
count = count + 1
If count <= Length Then
OneChar = Asc(Mid(StrToChange, count, 1))

If (OneChar > 255) Or (OneChar < 0) Then
'该字符是非ASCII字符
ByteArray(I) = GetCharByte(OneChar, True) '得到高字节
I = I + 1
If I <= UpBound Then ByteArray(I) = GetCharByte(OneChar, False)
'得到低字节
Else
'该字符是ASCII字符
ByteArray(I) = OneChar
End If
Else
Exit For
End If
Next
End Sub

Sub ChangeStrAryToByte(StrAry As String, ByteAry() As Byte)
'将字符串数组转换成字节数组
Dim LowBound, UpBound As Integer
Dim I, count, StartPos, MaxLen As Integer
Dim TmpByte() As Byte

count = 0
ReDim ByteAry(0)
MaxLen = LenB(StrAry)
ReDim TmpByte(MaxLen + 1)
ReDim Preserve ByteAry(count + MaxLen)
Call StrToByte(StrAry, TmpByte) '转换一个字符串
StartPos = count
Do
ByteAry(count) = TmpByte(count - StartPos)
count = count + 1
Loop Until ByteAry(count - 1) = 0 '将每一个字符串对应的字节数组按顺序填入结果数组中
ReDim Preserve ByteAry(count - 2)
End Sub
Private Sub iniCtrl()
Dim Data1 As String
Dim I As Integer, K As Integer, M As Integer, temp1 As Integer, temp2 As Integer, temp3 As Integer
'绘制基本属性控件

For I = 0 To UBound(RxPart1.inBoat) + UBound(RxPart1.Goods) + 1
  If I > 0 Then Load Label1(I): Load Text1(I)
  With Label1(I)
     .Visible = True
     .Left = Label1(0).Left + (I Mod 7) * 1650
     .Top = Label1(0).Top + (I \ 7) * 220
     If I < 18 Then
       .BackColor = vbWhite
     Else
       .BackColor = &H8000000F
     End If
     Text1(I).Visible = True
     Text1(I).Left = Text1(0).Left + (I Mod 7) * 1650
     Text1(I).Top = Text1(0).Top + (I \ 7) * 220
  End With
Next
'绘制人物属性控件
For I = 0 To 82
  If I > 0 Then Load Label2(I): Load Text2(I)
  With Label2(I)
    .Visible = True
    .Left = Label2(0).Left + (I Mod 6) * 1650
    .Top = Label2(0).Top + (I \ 6) * 220
    Text2(I).Visible = True
    Text2(I).Left = Text2(0).Left + (I Mod 6) * 1650
    Text2(I).Top = Text2(0).Top + (I \ 6) * 220
  End With
Next
For I = 4 To 5
  Text2(I).Left = Text2(I).Left - 700
  Text2(I).Width = Text2(I).Width * 2.2
  Text2(I).BackColor = vbWhite
Next
'绘制物品属性控件
For I = 0 To 62
   If I > 0 Then Load Label3(I): Load Text3(I)
   With Label3(I)
        .Visible = True
        .Left = Label3(0).Left + (I Mod 6) * 1650
        .Top = Label3(0).Top + (I \ 6) * 220
        Text3(I).Visible = True
        Text3(I).Left = Text3(0).Left + (I Mod 6) * 1650
        Text3(I).Top = Text3(0).Top + (I \ 6) * 220
   End With
Next
For I = 1 To 3
  Text3(I).BackColor = vbWhite
  Text3(I).Left = Text3(I).Left - 1080
  Text3(I).Width = Text3(I).Width * 1.85
Next
  Text3(2).Left = Text3(2).Left - 600
  Text3(3).Left = Text3(3).Left - 1200
  Text3(3).Width = Text3(3).Width * 2.65
'绘制场景属性控件
For I = 0 To 21
  If I > 0 Then Load Label4(I): Load Text4(I)
  With Label4(I)
        .Visible = True
        .Left = Label4(0).Left + (I Mod 7) * 1650
        .Top = Label4(0).Top + (I \ 7) * 220
        Text4(I).Visible = True
        Text4(I).Left = Text4(0).Left + (I Mod 7) * 1650
        Text4(I).Top = Text4(0).Top + (I \ 7) * 220
  End With
Next
Text4(1).Left = Text4(1).Left - 700
Text4(1).Width = Text4(1).Width * 2.3
Text4(1).BackColor = vbWhite
'绘制武功属性控件
For I = 0 To 63
   If I > 0 Then Load Label5(I): Load Text5(I)
  With Label5(I)
        .Visible = True
        .Left = Label5(0).Left + (I Mod 7) * 1650
        .Top = Label5(0).Top + (I \ 7) * 220
        Text5(I).Visible = True
        Text5(I).Left = Text5(0).Left + (I Mod 7) * 1650
        Text5(I).Top = Text5(0).Top + (I \ 7) * 220
  End With
Next
  Text5(1).Left = Text5(1).Left - 700
  Text5(1).Width = Text5(1).Width * 2.2
  Text5(1).BackColor = vbWhite
For K = 0 To 4 '小宝
    For I = 0 To 2
      For M = 0 To 4
        temp1 = K * 15 + I * 5 + M
        If temp1 > 0 Then Load Label6(temp1): Load Text6(temp1)
          Label6(temp1).Visible = True
          Label6(temp1).Left = Label6(0).Left + (temp1 Mod 5) * 2400
          Label6(temp1).Top = Label6(0).Top + (temp1 \ 5) * 220
          'Label6(Temp1).ForeColor = QBColor(K + 1)
          Text6(temp1).Visible = True
          Text6(temp1).Left = Text6(0).Left + (temp1 Mod 5) * 2400
          Text6(temp1).Top = Text6(0).Top + (temp1 \ 5) * 220
      Next
    Next
Next

Call ChgLang '切换语言，重读界面文字

Data1 = ""
'Call IniListItem
For I = 0 To 3
    List1(I).Height = 442: List1(I).Width = 673
    List1(2).Height = 300: List1(2).Width = 600
    List1(3).Height = 300: List1(3).Width = 450
    List1(I).Top = (Frame1(I).Height - List1(I).Height) / 2
    List1(I).Left = (Frame1(I).Width - List1(I).Width) / 2
    List1(I).Visible = False
    List1(I).ListIndex = 0
Next
With WgPbox(0)
    .Top = 2550
    .Left = 6100
    .Width = 5600
    .Height = 4700
End With
End Sub

Private Sub RefreshCtrl(Ctart As Integer, Cend As Integer)
If Text1.UBound = 0 Then Exit Sub
Dim I As Integer, K As Integer, M As Integer, temp1 As Integer, X As Integer
For X = Ctart To Cend
 Select Case X
  Case 1
        For I = 0 To UBound(RxPart1.inBoat) '刷新基本属性数据
         Text1(I).Text = RxPart1.inBoat(I)
        Next
        For K = 0 To UBound(RxPart1.Goods)
          If RxPart1.Goods(K).a > -1 And RxPart1.Goods(K).a < 200 Then
            Label1(I + K).Caption = GoodsAtt(RxPart1.Goods(K).a).c
            Label1(I + K).ToolTipText = GoodsAtt(RxPart1.Goods(K).a).d
          Else
            Label1(I + K).Caption = "物品(无效)"
            Label1(I + K).ToolTipText = "此物品ID超出範圍(0~199)"
          End If
          Text1(I + K).Text = RxPart1.Goods(K).b
        Next

  Case 2
        With NpcAtt(CurrentNpc) '刷新人物属性数据
            For I = 0 To 3
             Text2(I).Text = .a(I)
            Next
            Text2(4).Text = .b
            Text2(5).Text = .c
            For I = 6 To 82
             Text2(I).Text = .d(I - 6)
            Next
        End With
  Case 3
        With GoodsAtt(CurrentGoods) '刷新物品属性数据
            Text3(0).Text = .a
            Text3(1).Text = .b
            Text3(2).Text = .c
            Text3(3).Text = .d
            For I = 4 To 62
             Text3(I).Text = .e(I - 4)
            Next
        End With
  Case 4
            With AddAtt(CurrentAdd) '刷新场景
            Text4(0).Text = .a
            Text4(1).Text = .b
            For I = 2 To 21
             Text4(I).Text = .c(I - 2)
            Next
        End With
  Case 5
        With WgAtt(CurrentWg) '刷新武功
            Text5(0).Text = .a
            Text5(1).Text = .b
            For I = 2 To 63
             Text5(I).Text = .c(I - 2)
            Next
        End With
  Case 6
        For K = 0 To 4 '刷新小宝
            For I = 0 To 2
              For M = 0 To 4
                  temp1 = K * 15 + I * 5 + M
                  Select Case I
                  Case 0
                    Text6(temp1) = BaoAtt(K).gName(M)
                  Case 1
                    Text6(temp1) = BaoAtt(K).gNum(M)
                  Case 2
                    Text6(temp1) = BaoAtt(K).gPay(M)
                  End Select
              Next
            Next
        Next
 End Select
Next X
End Sub
Private Sub RefreshCtrl1(Ctart As Integer, Cend As Integer)
Dim I As Integer, X As Integer
For X = Ctart To Cend
 Select Case X
  Case 1
        For I = 0 To Text1.UBound
         Text1_Change I
        Next
  Case 2
        For I = 0 To Text2.UBound
         Text2_Change I
        Next
  Case 3
        For I = 0 To Text3.UBound
         Text3_Change I
        Next
  Case 4
        For I = 0 To Text4.UBound
         Text4_Change I
        Next
  Case 5
        For I = 0 To Text5.UBound
         Text5_Change I
        Next
  Case 6
        For I = 0 To Text6.UBound
         Text6_Change I
        Next
 End Select
Next
End Sub

Private Sub Check1_Click()
If Check1.Value <> 0 Then Check1.Value = 0: Exit Sub
PopupMenu MDIFormMain.mnu2
End Sub
Sub DoWithMenu1(Index As Integer)
Select Case Index
 Case 0 '刷新
   RefreshCtrl1 TabStrip1.SelectedItem.Index, TabStrip1.SelectedItem.Index
 Case 1 '16进制
 Case 2 '计算器
    On Error Resume Next
   Dim systemDir As String, winDir As String, A1 As String, A2 As String
   systemDir = Space(255): winDir = Space(255)
   GetSystemDirectory systemDir, 255
   GetWindowsDirectory winDir, 255
   A1 = Left(Trim(systemDir), Len(Trim(systemDir)) - 1)
   A2 = Left(Trim(winDir), Len(Trim(winDir)) - 1)
   Shell A1 & "\calc", vbNormalFocus
   Shell A2 & "\calc", vbNormalFocus
   Shell Left(A2, 2) & "\Program Files\Accessories\calc", vbNormalFocus
   On Error GoTo 0
 Case 3 '读取
   With frmRxEdit_JinDu
    .Option1(CurrentJinDu).Value = True
    .OKButton.Caption = "讀取"
    .Caption = "讀取進度(R?.GRP)"
    .Check1.Value = 1
    .Show vbModal, MDIFormMain
   End With
 Case 4 '保存
   With frmRxEdit_JinDu
    .Option1(CurrentJinDu).Value = True
    .OKButton.Caption = "保存"
    .Caption = "保存檔案(R?.GRP)"
    .Check1.Value = 2
    .Show vbModal, MDIFormMain
   End With
 Case 5 '退出
   Unload Me
End Select
End Sub
Sub DoWithMenu2(Index As Integer)
Dim I As Integer, K As Integer, M As Integer, tempstr1 As String
Select Case Index
 Case 0 '全部物品
    For K = 0 To UBound(RxPart1.Goods)
      RxPart1.Goods(K).a = K
    Next
 Case 1 '批量数量
    tempstr1 = InputBox("請輸入物品數量，範圍-32768~32767", "批量修改物品數量", "12345")
    If Not ChkInt(tempstr1) Or tempstr1 = "" Then Exit Sub
    For K = 0 To UBound(RxPart1.Goods)
      RxPart1.Goods(K).b = Val(tempstr1)
    Next
End Select
RefreshCtrl 1, 1
End Sub
Sub DoWithMenu3(Index As Integer)
Dim tempStr As String
With MDIFormMain
  If Index = 0 Then
    .mnu2_RxEdit3(0).Checked = True
    tempStr = "GB"
  Else
    .mnu2_RxEdit3(0).Checked = False
    tempStr = "BIG5"
  End If
  .mnu2_RxEdit3(1).Checked = Not .mnu2_RxEdit3(0).Checked
End With
If tempStr = CurrentLanguage Then Exit Sub '语言没变
If CurrentLanguage = "GB" Then
 CurrentLanguage = "BIG5"
 convListArray 1, 6, 2
Else
 CurrentLanguage = "GB"
 convListArray 1, 6, 1
End If
'CurrentLanguage = tempStr
Call ChgLang
RefreshCtrl1 1, 6
End Sub



Function ConvBIG_GBK(str1 As String, Mode1BIG2GB As Integer) As String
Dim BIG5str As String, GBKstr As String
Select Case Mode1BIG2GB '接收BIG5字符
   Case 1
        BIG5str = str1
        If CurrentLanguage = "GB" Then '如果简体中文，BIG5-->GB
            BIG5str = StrConv(BIG5str, vbFromUnicode)
            '将Mem数组转换为Big5码所对应的Unicode码
            BIG5str = StrConv(BIG5str, vbUnicode, &H404)
            '再将Unicode码转换为GBK编码
            BIG5str = StrConv(BIG5str, vbFromUnicode, &H804)
            ConvBIG_GBK = StrConv(BIG5str, vbUnicode)
        Else
            ConvBIG_GBK = BIG5str '如果繁体，不变
        End If
   Case 2 '接收GBK字符
        GBKstr = str1
       If CurrentLanguage = "GB" Then '如果简体中文，不变
            ConvBIG_GBK = GBKstr
       Else '如果繁体中文，GB--->BIG5
            GBKstr = StrConv(GBKstr, vbFromUnicode, &H404)
            ConvBIG_GBK = StrConv(GBKstr, vbUnicode, &H804)
       End If
End Select
End Function

Sub IniListItem()
Dim I As Integer, tempstr1 As String, MemStr(10) As Byte
For I = 0 To 3
  List1(I).Clear
Next
For I = 0 To UBound(NpcAtt)
    List1(0).AddItem Format(I, "000") & " " & NpcAtt(I).b
Next
For I = 0 To UBound(GoodsAtt)
 List1(1).AddItem Format(I, "000") & " " & GoodsAtt(I).c
Next
For I = 0 To UBound(AddAtt)
 List1(2).AddItem Format(I, "000") & " " & AddAtt(I).b
Next
For I = 0 To UBound(WgAtt)
 List1(3).AddItem Format(I, "000") & " " & WgAtt(I).b
Next
End Sub

Private Sub TimerWgAniCtl_Timer()
'动画控制定时器
If CurrentAniIdx > ANIendIDX Then TimerWgAniCtl.Enabled = False: Exit Sub ' CurrentAniIdx = ANIstartIDX
CurrentAniBox.Cls
If CurrentAniIdx = ANIstartIDX Then setStaBarText 1, CurrentAniGrpFile
Select Case TabStrip1.SelectedItem.Index
  Case 2
    DrawOneTile2 CurrentAniBox, tempPicbox, 100, 100, 0, 0, CurrentAniGrpFile, CurrentAniIdxFile, (CurrentAniIdx), True, False
  Case 5 '武功页面
     DrawOneTile2 CurrentAniBox, tempPicbox, 200, 250, 0, 0, CurrentAniGrpFile, CurrentAniIdxFile, (CurrentAniIdx), True, False
End Select
setStaBarText 7, "Frame:" & CurrentAniIdx & "/" & ANIstartIDX & "~" & ANIendIDX
CurrentAniIdx = CurrentAniIdx + 1
End Sub
Private Sub ChgLang()
Dim Data1 As String, temp1 As Integer, I As Integer, K As Integer, M As Integer
IniListItem
Me.Caption = "基本進度修改器-進度" & (CurrentJinDu + 1)
With MDIFormMain
  .mnu2_RxEdit1(0).Caption = "刷新顯示"
  .mnu2_RxEdit1(1).Caption = "數字顯示十六進制"
  .mnu2_RxEdit1(2).Caption = "Windows計算器"
  .mnu2_RxEdit1(3).Caption = "取進度..."
  .mnu2_RxEdit1(4).Caption = "保存..."
  .mnu2_RxEdit1(5).Caption = "關閉..."
  .mnu2_RxEdit2(0).Caption = "物品種類全滿"
  .mnu2_RxEdit2(1).Caption = "批量修改物品數量..."
End With
With TabStrip1
  .Tabs(1).Caption = "基本數據"
  .Tabs(2).Caption = "人物"
  .Tabs(3).Caption = "物品"
  .Tabs(4).Caption = "場景"
  .Tabs(5).Caption = "武功"
  .Tabs(6).Caption = "小寶商店"
End With
Check1.Caption = "快捷菜單"
chkSort.Caption = "排序模式"
Frame1(5).Caption = "小寶商店(1河洛2有間3悅來4龍門5高昇)"
With frmRxEdit_JinDu
  .Frame1(0).Caption = "選擇進度"
  .Frame1(1).Caption = "讀/存範圍"
  .Option1(0).Caption = "進度一"
  .Option1(1).Caption = "進度二"
  .Option1(2).Caption = "進度三"
  .Option2(0).Caption = "全部"
  .Option2(1).Caption = "基本數據"
  .Option2(2).Caption = "人物"
  .Option2(3).Caption = "物品"
  .Option2(4).Caption = "場景"
  .Option2(5).Caption = "武功"
  .Option2(6).Caption = "小寶商店"
  .CancelButton.Caption = "取消"
End With
temp1 = 1 '基本属性
Data1 = LoadResString(101)
For I = 0 To 17
  With Label1(I)
     temp2 = InStr(temp1 + 1, Data1, ",")
     .Caption = Mid(Data1, temp1 + 1, temp2 - temp1 - 1)
     If Left(.Caption, 2) = "未知" Then
       .ForeColor = vbBlack: Text1(I).ForeColor = &H606060
       .ToolTipText = "請幫忙測試這個數的含義，並到www.chao6.com通知潮流"
     End If
     temp1 = temp2
  End With
Next
temp1 = 1
Data1 = LoadResString(201)
For I = 0 To 17
  With Label1(I)
   temp2 = InStr(temp1 + 1, Data1, ",")
   If .ToolTipText = "" Then .ToolTipText = Mid(Data1, temp1 + 1, temp2 - temp1 - 1)
   If .ToolTipText = "~~" Then .ToolTipText = Label1(I - 1).ToolTipText
   temp1 = temp2
  End With
Next

temp1 = 1
Data1 = LoadResString(102)
For I = 0 To 82
  With Label2(I)
    temp2 = InStr(temp1 + 1, Data1, ",")
    .Caption = Mid(Data1, temp1 + 1, temp2 - temp1 - 1)
    temp1 = temp2
        If Left(.Caption, 2) = "未知" Then
      .ForeColor = vbBlack: Text2(I).ForeColor = &H606060
      .ToolTipText = "請幫忙測試這個數的含義，並到www.chao6.com通知潮流"
    End If
  End With
Next
temp1 = 1
Data1 = LoadResString(202)
For I = 0 To 82
  With Label2(I)
   temp2 = InStr(temp1 + 1, Data1, ",")
   If .ToolTipText = "" Then .ToolTipText = Mid(Data1, temp1 + 1, temp2 - temp1 - 1)
   If .ToolTipText = "~~" Then .ToolTipText = Label2(I - 1).ToolTipText
   temp1 = temp2
  End With
Next

temp1 = 1
Data1 = LoadResString(103)
For I = 0 To 62
   With Label3(I)
        temp2 = InStr(temp1 + 1, Data1, ",")
        .Caption = Mid(Data1, temp1 + 1, temp2 - temp1 - 1)
        temp1 = temp2
        If Left(.Caption, 2) = "未知" Then
          .ForeColor = vbBlack: Text3(I).ForeColor = &H606060
          .ToolTipText = "請幫忙測試這個數的含義，並到www.chao6.com通知潮流"
        End If
   End With
Next
temp1 = 1
Data1 = LoadResString(203)
For I = 0 To 62
  With Label3(I)
   temp2 = InStr(temp1 + 1, Data1, ",")
   If .ToolTipText = "" Then .ToolTipText = Mid(Data1, temp1 + 1, temp2 - temp1 - 1)
   If .ToolTipText = "~~" Then .ToolTipText = Label3(I - 1).ToolTipText
   temp1 = temp2
  End With
Next

temp1 = 1
Data1 = LoadResString(104)
For I = 0 To 21
  With Label4(I)
        temp2 = InStr(temp1 + 1, Data1, ",")
        .Caption = Mid(Data1, temp1 + 1, temp2 - temp1 - 1)
        temp1 = temp2
        If Left(.Caption, 2) = "未知" Then
          .ForeColor = vbBlack: Text4(I).ForeColor = &H606060
          .ToolTipText = "請幫忙測試這個數的含義，並到www.chao6.com通知潮流"
        End If
  End With
Next
temp1 = 1
Data1 = LoadResString(204)
For I = 0 To 21
  With Label4(I)
   temp2 = InStr(temp1 + 1, Data1, ",")
   If .ToolTipText = "" Then .ToolTipText = Mid(Data1, temp1 + 1, temp2 - temp1 - 1)
   If .ToolTipText = "~~" Then .ToolTipText = Label4(I - 1).ToolTipText
   temp1 = temp2
  End With
Next

temp1 = 1
Data1 = LoadResString(105)
For I = 0 To 63
  With Label5(I)
        temp2 = InStr(temp1 + 1, Data1, ",")
        .Caption = Mid(Data1, temp1 + 1, temp2 - temp1 - 1)
        temp1 = temp2
        If Left(.Caption, 2) = "未知" Then
          .ForeColor = vbBlack: Text5(I).ForeColor = &H606060
          .ToolTipText = "請幫忙測試這個數的含義，並到www.chao6.com通知潮流"
        End If
  End With
Next
temp1 = 1
Data1 = LoadResString(205)
For I = 0 To 63
  With Label5(I)
   temp2 = InStr(temp1 + 1, Data1, ",")
   If .ToolTipText = "" Then .ToolTipText = Mid(Data1, temp1 + 1, temp2 - temp1 - 1)
   If .ToolTipText = "~~" Then .ToolTipText = Label5(I - 1).ToolTipText
   temp1 = temp2
  End With
Next
For K = 0 To 4 '小宝
    For I = 0 To 2
      For M = 0 To 4
        temp1 = K * 15 + I * 5 + M
          Select Case I
          Case 0
            Label6(temp1).Caption = "物品"
          Case 1
            Label6(temp1).Caption = "數量"
          Case 2
            Label6(temp1).Caption = "價格"
          End Select
       Next
    Next
Next

RefreshCtrl 1, 6
End Sub
Private Sub MidiPlay(temp1 As Integer)
Dim Song As String
MidiStop
If Started And temp1 > -1 Then
    Song = App.Path & "\jymidi\game" & Format(temp1 + 1, "00") & ".mid"
    mciSendString "open " & Song & " type sequencer alias canyon", 0&, 0, 0
    mciSendString "play canyon FROM 0", 0&, 0, 0
    setStaBarText 2, Format(temp1 + 1, "00") & ".mid"
  Else
    setStaBarText 2, "-1,音樂不變"
  End If
End Sub

Private Sub MidiStop()
    mciSendString "close canyon", 0&, 0, 0
    setStaBarText 2, "MIDI Stoped"
End Sub
