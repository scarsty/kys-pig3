VERSION 5.00
Object = "{831FDD16-0C5C-11D2-A9FC-0000F8754DA1}#2.0#0"; "MSCOMCTL.OCX"
Begin VB.Form frmTileEdit 
   Caption         =   "Form2"
   ClientHeight    =   5985
   ClientLeft      =   60
   ClientTop       =   345
   ClientWidth     =   8700
   LinkTopic       =   "Form2"
   MDIChild        =   -1  'True
   ScaleHeight     =   399
   ScaleMode       =   3  'Pixel
   ScaleWidth      =   580
   Visible         =   0   'False
   WindowState     =   2  'Maximized
   Begin VB.CommandButton Command1 
      Caption         =   "插入空圖"
      BeginProperty Font 
         Name            =   "Times New Roman"
         Size            =   9
         Charset         =   0
         Weight          =   400
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Height          =   300
      Index           =   9
      Left            =   3480
      TabIndex        =   33
      Top             =   4440
      Width           =   1350
   End
   Begin VB.CommandButton Command1 
      Caption         =   "插入"
      Enabled         =   0   'False
      BeginProperty Font 
         Name            =   "Times New Roman"
         Size            =   9
         Charset         =   0
         Weight          =   400
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Height          =   300
      Index           =   7
      Left            =   3480
      TabIndex        =   32
      Top             =   3660
      Width           =   1350
   End
   Begin VB.CommandButton Command1 
      Caption         =   "MsPaint"
      BeginProperty Font 
         Name            =   "Times New Roman"
         Size            =   9
         Charset         =   0
         Weight          =   400
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Height          =   300
      Index           =   5
      Left            =   3480
      TabIndex        =   31
      Top             =   2760
      Width           =   1350
   End
   Begin VB.PictureBox picConv 
      AutoRedraw      =   -1  'True
      AutoSize        =   -1  'True
      BackColor       =   &H00FF00FF&
      BorderStyle     =   0  'None
      Height          =   4680
      Left            =   8400
      ScaleHeight     =   312
      ScaleMode       =   3  'Pixel
      ScaleWidth      =   230
      TabIndex        =   30
      Top             =   15
      Width           =   3450
   End
   Begin VB.TextBox Text1 
      BeginProperty Font 
         Name            =   "Times New Roman"
         Size            =   9
         Charset         =   0
         Weight          =   400
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Height          =   270
      Index           =   3
      Left            =   4320
      TabIndex        =   27
      Text            =   "0"
      Top             =   2520
      Width           =   495
   End
   Begin VB.TextBox Text1 
      BeginProperty Font 
         Name            =   "Times New Roman"
         Size            =   9
         Charset         =   0
         Weight          =   400
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Height          =   270
      Index           =   2
      Left            =   4320
      TabIndex        =   26
      Text            =   "0"
      Top             =   2280
      Width           =   495
   End
   Begin VB.ComboBox Combo3 
      Height          =   300
      Left            =   5040
      TabIndex        =   23
      Text            =   "Combo3"
      Top             =   0
      Visible         =   0   'False
      Width           =   1095
   End
   Begin VB.TextBox Text1 
      BeginProperty Font 
         Name            =   "Times New Roman"
         Size            =   9
         Charset         =   0
         Weight          =   400
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Height          =   270
      Index           =   1
      Left            =   4320
      TabIndex        =   22
      Text            =   "0"
      Top             =   2040
      Width           =   495
   End
   Begin VB.TextBox Text1 
      BeginProperty Font 
         Name            =   "Times New Roman"
         Size            =   9
         Charset         =   0
         Weight          =   400
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Height          =   270
      Index           =   0
      Left            =   4320
      TabIndex        =   20
      Text            =   "0"
      Top             =   1800
      Width           =   495
   End
   Begin VB.CommandButton Command1 
      Caption         =   "刪除"
      BeginProperty Font 
         Name            =   "Times New Roman"
         Size            =   9
         Charset         =   0
         Weight          =   400
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Height          =   300
      Index           =   8
      Left            =   3480
      TabIndex        =   18
      Top             =   3960
      Width           =   1350
   End
   Begin VB.CommandButton Command1 
      Caption         =   "添加到尾部"
      Enabled         =   0   'False
      BeginProperty Font 
         Name            =   "Times New Roman"
         Size            =   9
         Charset         =   0
         Weight          =   400
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Height          =   300
      Index           =   6
      Left            =   3480
      TabIndex        =   17
      Top             =   3360
      Width           =   1350
   End
   Begin VB.CommandButton Command1 
      Caption         =   "測試XY"
      BeginProperty Font 
         Name            =   "Times New Roman"
         Size            =   9
         Charset         =   0
         Weight          =   400
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Height          =   300
      Index           =   4
      Left            =   3480
      TabIndex        =   16
      Top             =   1470
      Width           =   1350
   End
   Begin VB.CommandButton Command1 
      Caption         =   "轉換"
      BeginProperty Font 
         Name            =   "Times New Roman"
         Size            =   9
         Charset         =   0
         Weight          =   400
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Height          =   300
      Index           =   3
      Left            =   3480
      TabIndex        =   15
      Top             =   1170
      Width           =   1350
   End
   Begin VB.CommandButton Command1 
      Caption         =   "透明色"
      BeginProperty Font 
         Name            =   "Times New Roman"
         Size            =   9
         Charset         =   0
         Weight          =   400
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Height          =   300
      Index           =   2
      Left            =   3480
      TabIndex        =   13
      Top             =   870
      Width           =   975
   End
   Begin VB.CommandButton Command1 
      Caption         =   "來自剪貼板"
      BeginProperty Font 
         Name            =   "Times New Roman"
         Size            =   9
         Charset         =   0
         Weight          =   400
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Height          =   300
      Index           =   1
      Left            =   3480
      TabIndex        =   12
      Top             =   570
      Width           =   1350
   End
   Begin VB.CommandButton Command1 
      Caption         =   "來自BMP"
      BeginProperty Font 
         Name            =   "Times New Roman"
         Size            =   9
         Charset         =   0
         Weight          =   400
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Height          =   300
      Index           =   0
      Left            =   3480
      TabIndex        =   11
      Top             =   270
      Width           =   1350
   End
   Begin VB.ComboBox Combo2 
      BeginProperty Font 
         Name            =   "Times New Roman"
         Size            =   9
         Charset         =   0
         Weight          =   400
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Height          =   345
      Left            =   4200
      Style           =   2  'Dropdown List
      TabIndex        =   10
      Top             =   0
      Visible         =   0   'False
      Width           =   390
   End
   Begin VB.ComboBox Combo1 
      BeginProperty Font 
         Name            =   "Times New Roman"
         Size            =   9
         Charset         =   0
         Weight          =   400
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Height          =   345
      Left            =   3480
      Style           =   2  'Dropdown List
      TabIndex        =   9
      Top             =   0
      Width           =   1335
   End
   Begin VB.PictureBox picEdit 
      AutoRedraw      =   -1  'True
      AutoSize        =   -1  'True
      BackColor       =   &H00FF00FF&
      BorderStyle     =   0  'None
      Height          =   4680
      Left            =   4920
      ScaleHeight     =   312
      ScaleMode       =   3  'Pixel
      ScaleWidth      =   230
      TabIndex        =   2
      Top             =   15
      Width           =   3450
   End
   Begin VB.PictureBox picView 
      AutoRedraw      =   -1  'True
      BackColor       =   &H00808080&
      Height          =   4680
      Left            =   0
      ScaleHeight     =   308
      ScaleMode       =   3  'Pixel
      ScaleWidth      =   226
      TabIndex        =   0
      Top             =   15
      Width           =   3450
      Begin VB.Line LineY 
         BorderColor     =   &H00000000&
         BorderStyle     =   3  'Dot
         X1              =   115
         X2              =   115
         Y1              =   0
         Y2              =   312
      End
      Begin VB.Line LineX 
         BorderColor     =   &H00000000&
         BorderStyle     =   3  'Dot
         X1              =   0
         X2              =   336
         Y1              =   224
         Y2              =   224
      End
   End
   Begin VB.PictureBox Pic6 
      AutoRedraw      =   -1  'True
      BackColor       =   &H00FFFFFF&
      Height          =   2520
      Left            =   0
      ScaleHeight     =   164
      ScaleMode       =   3  'Pixel
      ScaleWidth      =   896
      TabIndex        =   1
      Top             =   5160
      Width           =   13500
      Begin VB.Shape Shape1 
         BorderColor     =   &H00FF0000&
         Height          =   2445
         Left            =   0
         Top             =   0
         Width           =   1980
      End
   End
   Begin MSComctlLib.Slider Slider1 
      Height          =   210
      Left            =   0
      TabIndex        =   24
      Top             =   4725
      Width           =   10980
      _ExtentX        =   19368
      _ExtentY        =   370
      _Version        =   393216
      LargeChange     =   6
      SmallChange     =   6
   End
   Begin VB.Label Label3 
      AutoSize        =   -1  'True
      Caption         =   "指定寬>"
      BeginProperty Font 
         Name            =   "Times New Roman"
         Size            =   9
         Charset         =   0
         Weight          =   400
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Height          =   225
      Index           =   3
      Left            =   3600
      MousePointer    =   9  'Size W E
      TabIndex        =   29
      Top             =   2520
      Width           =   645
   End
   Begin VB.Label Label3 
      AutoSize        =   -1  'True
      Caption         =   "指定高>"
      BeginProperty Font 
         Name            =   "Times New Roman"
         Size            =   9
         Charset         =   0
         Weight          =   400
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Height          =   225
      Index           =   2
      Left            =   3600
      MousePointer    =   9  'Size W E
      TabIndex        =   28
      Top             =   2310
      Width           =   645
   End
   Begin VB.Label Label4 
      AutoSize        =   -1  'True
      BackColor       =   &H0080FFFF&
      Caption         =   "Label4"
      BeginProperty Font 
         Name            =   "Times New Roman"
         Size            =   9
         Charset         =   0
         Weight          =   400
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      ForeColor       =   &H000000C0&
      Height          =   225
      Left            =   11040
      TabIndex        =   25
      Top             =   4710
      Width           =   480
   End
   Begin VB.Label Label1 
      AutoSize        =   -1  'True
      Caption         =   "Label1"
      BeginProperty Font 
         Name            =   "Times New Roman"
         Size            =   9
         Charset         =   0
         Weight          =   400
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      ForeColor       =   &H00FF0000&
      Height          =   225
      Index           =   2
      Left            =   4680
      TabIndex        =   5
      Top             =   4920
      Width           =   480
   End
   Begin VB.Label Label3 
      AutoSize        =   -1  'True
      Caption         =   "指定高>"
      BeginProperty Font 
         Name            =   "Times New Roman"
         Size            =   9
         Charset         =   0
         Weight          =   400
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Height          =   225
      Index           =   1
      Left            =   3600
      TabIndex        =   21
      Top             =   2070
      Width           =   645
   End
   Begin VB.Label Label3 
      AutoSize        =   -1  'True
      Caption         =   "指定寬>"
      BeginProperty Font 
         Name            =   "Times New Roman"
         Size            =   9
         Charset         =   0
         Weight          =   400
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Height          =   225
      Index           =   0
      Left            =   3600
      TabIndex        =   19
      Top             =   1830
      Width           =   645
   End
   Begin VB.Label lblColor 
      BackColor       =   &H00FFFFFF&
      BorderStyle     =   1  'Fixed Single
      BeginProperty Font 
         Name            =   "Times New Roman"
         Size            =   9
         Charset         =   0
         Weight          =   400
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Height          =   345
      Left            =   4440
      TabIndex        =   14
      Top             =   840
      Width           =   345
   End
   Begin VB.Label Label1 
      AutoSize        =   -1  'True
      Caption         =   "Label1"
      BeginProperty Font 
         Name            =   "Times New Roman"
         Size            =   9
         Charset         =   0
         Weight          =   400
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      ForeColor       =   &H00FF0000&
      Height          =   225
      Index           =   5
      Left            =   10560
      TabIndex        =   8
      Top             =   4920
      Width           =   480
   End
   Begin VB.Label Label1 
      AutoSize        =   -1  'True
      Caption         =   "Label1"
      BeginProperty Font 
         Name            =   "Times New Roman"
         Size            =   9
         Charset         =   0
         Weight          =   400
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      ForeColor       =   &H00FF0000&
      Height          =   225
      Index           =   4
      Left            =   8640
      TabIndex        =   7
      Top             =   4920
      Width           =   480
   End
   Begin VB.Label Label1 
      AutoSize        =   -1  'True
      Caption         =   "Label1"
      BeginProperty Font 
         Name            =   "Times New Roman"
         Size            =   9
         Charset         =   0
         Weight          =   400
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      ForeColor       =   &H00FF0000&
      Height          =   225
      Index           =   3
      Left            =   6600
      TabIndex        =   6
      Top             =   4920
      Width           =   480
   End
   Begin VB.Label Label1 
      AutoSize        =   -1  'True
      Caption         =   "Label1"
      BeginProperty Font 
         Name            =   "Times New Roman"
         Size            =   9
         Charset         =   0
         Weight          =   400
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      ForeColor       =   &H00FF0000&
      Height          =   225
      Index           =   1
      Left            =   2760
      TabIndex        =   4
      Top             =   4920
      Width           =   480
   End
   Begin VB.Label Label1 
      AutoSize        =   -1  'True
      Caption         =   "Label1"
      BeginProperty Font 
         Name            =   "Times New Roman"
         Size            =   9
         Charset         =   0
         Weight          =   400
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      ForeColor       =   &H00FF0000&
      Height          =   225
      Index           =   0
      Left            =   720
      TabIndex        =   3
      Top             =   4920
      Width           =   480
   End
End
Attribute VB_Name = "frmTileEdit"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Dim Started As Boolean
Dim CurTileFile As String, CurTileFileIdx As String
Dim CurStartTile As Long, CurShapePos As Integer, CurSelectTile As Long
Dim PointO As POINTAPI, GetColorPos As POINTAPI
Dim convTileINFO As RLEPic1
Dim withMaskColor As Boolean
Private Sub Combo1_Click()
CurTileFile = Combo1.List(Combo1.ListIndex)
CurTileFile = Left(CurTileFile, InStr(1, CurTileFile, "|") - 1)
CurTileFileIdx = Combo3.List(Combo1.ListIndex)
CurStartTile = Combo2.ListIndex
Me.Caption = "貼圖資源編輯器(當前操作文件：" & CurTileFile & " / " & CurTileFileIdx & ")"
setStaBarText 3, (CurStartTile)
    Dim tempFile As Integer, tempLong As Long
    tempFile = FreeFile
    Open GamePath & CurTileFileIdx For Binary As #tempFile
    tempLong = FileLen(GamePath & CurTileFileIdx) \ 4
    Close #tempFile
    If tempLong < 1 Then Slider1.Max = 1 Else Slider1.Max = tempLong - 1
    Label4 = "Max:" & tempLong - 1
    Slider1.Value = 0
Call Slider1_Change
MsgBox "注意：當前操作的文件是：" & CurTileFile & vbCrLf & "   最後一個貼圖編號是：" & Slider1.Max & "   請記住數據，不要改錯位了！" & vbCrLf & "(最好備份文件，以防出錯無法恢複)", vbInformation, "提醒"
End Sub

Private Sub Command1_Click(Index As Integer) '功能操作
Select Case Index
 Case 0
  Call OpenBMP
  GetColorPos.X = 0: GetColorPos.Y = 0
  lblColor.BackColor = picEdit.Point(0, 0)
 Case 1
  picEdit.Picture = Clipboard.GetData()
  GetColorPos.X = 0: GetColorPos.Y = 0
  lblColor.BackColor = picEdit.Point(0, 0)
 Case 2
  picEdit.MousePointer = 2
 Case 3 '转换
  picConv.Cls
  Command1(3).Caption = "Waiting..."
  Call ConvBMP
  Command1(3).Caption = "轉換"
  Command1(6).Enabled = True
  Command1(7).Enabled = True
 Case 4
  picView.Cls
  TransparentBlt picView.hdc, picConv.hdc, 0, 0, convTileINFO.Width, convTileINFO.Height, PointO.X - convTileINFO.X, PointO.Y - convTileINFO.Y, picConv.BackColor
 Case 5
   On Error Resume Next
   Dim systemDir As String, winDir As String, A1 As String, A2 As String
   systemDir = Space(255): winDir = Space(255)
   GetSystemDirectory systemDir, 255
   GetWindowsDirectory winDir, 255
   A1 = Left(Trim(systemDir), Len(Trim(systemDir)) - 1)
   A2 = Left(Trim(winDir), Len(Trim(winDir)) - 1)
   Shell A1 & "\mspaint", vbNormalFocus
   Shell A2 & "\mspaint", vbNormalFocus
   Shell Left(A2, 2) & "\Program Files\Accessories\mspaint", vbNormalFocus
   On Error GoTo 0
 Case 6
   Call Append
 Case 7
   Call Insert
 Case 8
   Call Delete
 Case 9
   Call InsertBlank
End Select
End Sub
Private Sub InsertBlank()
Dim IDXdata() As Long, I As Long
Dim FileNum1 As Integer
If CurSelectTile = 0 Then
   MsgBox "無數據的空貼圖，需要調用前一個貼圖數據，當前已是第1幅，無法插入！", vbExclamation, "插入空貼圖"
   Exit Sub
End If
FileNum1 = FreeFile
ReDim IDXdata(0 To Slider1.Max + 1) As Long '讀IDX文件
Open GamePath & CurTileFileIdx For Binary As #FileNum1
For I = 1 To UBound(IDXdata)
  Get #FileNum1, , IDXdata(I)
Next
If CurSelectTile = 1 Then
'  IDXdata(CurSelectTile - 1) = 0
Else
'  IDXdata(CurSelectTile - 1) = IDXdata(CurSelectTile - 2)
End If
Seek #FileNum1, (CurSelectTile - 1) * 4 + 1
For I = CurSelectTile - 1 To UBound(IDXdata)
  Put #FileNum1, , IDXdata(I)
Next

Close #FileNum1 '關閉IDX，開始操作GRP
Slider1.Max = Slider1.Max + 1
Label4 = "Max:" & Slider1.Max
Call Slider1_Change
End Sub
Private Sub Delete()
Dim IDXdata() As Long, GRPdata() As Byte, GRPdata1() As Byte, I As Long
Dim FileNum1 As Integer, WriteAdd As Long, WriteAdd1 As Long
FileNum1 = FreeFile
ReDim IDXdata(0 To Slider1.Max + 1) As Long '讀IDX文件
Open GamePath & CurTileFileIdx For Binary As #FileNum1
For I = 1 To UBound(IDXdata)
  Get #FileNum1, , IDXdata(I)
Next
Close #FileNum1
If CurSelectTile > 0 Then
  If IDXdata(CurSelectTile) = IDXdata(CurSelectTile - 1) Then
   If MsgBox("當前位置是一個無數據的空貼圖，實際只是指向前一個貼圖數據，刪除後不會影響貼圖數據的大小，但會使其後的貼圖編號都向前移位。你確定要刪除嗎？", vbQuestion + vbYesNo, "刪除空貼圖") = vbNo Then Exit Sub
   Kill GamePath & CurTileFileIdx
   Open GamePath & CurTileFileIdx For Binary As #FileNum1
    For I = 1 To UBound(IDXdata)
      If I <> CurSelectTile Then Put #FileNum1, , IDXdata(I)
    Next
   GoTo Done
  End If
Else
   MsgBox "不可以在索引爲0的位置插入或刪除貼圖！", vbExclamation, "警告"
   Exit Sub
End If
   
WriteAdd = IDXdata(CurSelectTile)
WriteAdd1 = IDXdata(CurSelectTile + 1)
TileLen = IDXdata(CurSelectTile + 1) - IDXdata(CurSelectTile)
If TileLen = 0 Then
 If MsgBox("後一位置是一個無數據的空貼圖，指向當前貼圖數據，如果刪除，它將指向前一個貼圖。你確定要刪除嗎？", vbQuestion + vbYesNo, "刪除") = vbNo Then Exit Sub
End If
If TileLen < 0 Then
   MsgBox "下一位置貼圖鏈接錯誤，不能刪除", vbCritical, "文件可能錯誤"
   Exit Sub
End If

For I = CurSelectTile + 1 To UBound(IDXdata)
 IDXdata(I) = IDXdata(I) - TileLen
Next

Kill GamePath & CurTileFileIdx
Open GamePath & CurTileFileIdx For Binary As #FileNum1
For I = 1 To UBound(IDXdata)
  If I <> CurSelectTile Then Put #FileNum1, , IDXdata(I)
Next
Close #FileNum1 '關閉IDX，開始操作GRP

Open GamePath & CurTileFile For Binary As #FileNum1
ReDim GRPdata(0 To WriteAdd - 1) As Byte
If LOF(FileNum1) - WriteAdd1 < 1 Then
  ReDim GRPdata1(0) As Byte
 Else
  ReDim GRPdata1(0 To LOF(FileNum1) - WriteAdd1 - 1) As Byte
End If
Get #FileNum1, , GRPdata()
If UBound(GRPdata1) > 0 Then Get #FileNum1, WriteAdd1 + 1, GRPdata1()
Close #FileNum1

Kill GamePath & CurTileFile
Open GamePath & CurTileFile For Binary As #FileNum1
Put #FileNum1, , GRPdata()
If UBound(GRPdata1) > 0 Then Put #FileNum1, , GRPdata1()
Done:
Close #FileNum1
Slider1.Max = Slider1.Max - 1
Label4 = "Max:" & Slider1.Max
Call Slider1_Change
End Sub
Private Sub Insert()
Dim IDXdata() As Long, GRPdata() As Byte, I As Long
Dim FileNum1 As Integer, WriteAdd As Long
FileNum1 = FreeFile
ReDim IDXdata(0 To Slider1.Max + 1) As Long '讀IDX文件
Open GamePath & CurTileFileIdx For Binary As #FileNum1
For I = 1 To UBound(IDXdata)
  Get #FileNum1, , IDXdata(I)
Next
If CurSelectTile > 0 Then
  If IDXdata(CurSelectTile) = IDXdata(CurSelectTile - 1) Then
   Close #FileNum1
   MsgBox "當前位置是一個無數據的空貼圖，實際只是指向前一個貼圖數據，此位置只可刪除，或只能插入空貼圖！", vbExclamation, "空貼圖"
   Exit Sub
  End If
Else
   Close #FileNum1
   MsgBox "不可以在索引爲0的位置插入或刪除貼圖！", vbExclamation, "警告"
   Exit Sub
End If
WriteAdd = IDXdata(CurSelectTile) + 1
TileLen = UBound(convTileINFO.Data) + 9
Seek #FileNum1, CurSelectTile * 4 + 1
For I = CurSelectTile To UBound(IDXdata)
 IDXdata(I) = IDXdata(I) + TileLen
 Put #FileNum1, , IDXdata(I)
Next
Close #FileNum1 '關閉IDX，開始操作GRP


Open GamePath & CurTileFile For Binary As #FileNum1
  If LOF(FileNum1) < WriteAdd Then
   MsgBox "文件長度有錯！", vbCritical, "嚴重錯誤"
   ReDim GRPdata(0) As Byte
  Else
   ReDim GRPdata(0 To LOF(FileNum1) - WriteAdd) As Byte
  End If
  Get #FileNum1, WriteAdd, GRPdata()
   With convTileINFO
    Put #FileNum1, WriteAdd, .Width
    Put #FileNum1, , .Height
    Put #FileNum1, , .X
    Put #FileNum1, , .Y
    Put #FileNum1, , .Data
   End With
  Put #FileNum1, , GRPdata()
Close #FileNum1
Slider1.Max = Slider1.Max + 1
Label4 = "Max:" & Slider1.Max
Call Slider1_Change
End Sub
Private Sub Append()
'convTileINFO.Data()
Dim tempFile As Integer, TileLen As Long
Dim WriteAdd As Long, tempLong2
tempFile = FreeFile
With convTileINFO
    TileLen = UBound(convTileINFO.Data) + 9
    tempFile = FreeFile
    Open GamePath & CurTileFileIdx For Binary As #tempFile
        tempLong2 = Slider1.Max * 4 + 1
        Get #tempFile, tempLong2, WriteAdd
        Put #tempFile, tempLong2 + 4, WriteAdd + TileLen
    Close #tempFile
    Open GamePath & CurTileFile For Binary As #tempFile
        Seek #tempFile, WriteAdd + 1
        Put #tempFile, , .Width
        Put #tempFile, , .Height
        Put #tempFile, , .X
        Put #tempFile, , .Y
        Put #tempFile, , .Data
    Close #tempFile
End With
Slider1.Value = Slider1.Max
Slider1.Max = Slider1.Max + 1
Label4 = "Max:" & Slider1.Max
Call Slider1_Change
End Sub

Sub ConvBMP()
'TransparentBlt picConv.hdc, picEdit.hdc, 0, 0, Val(Text1(0).Text), Val(Text1(1).Text), 0, 0, lblColor.BackColor
If convTileINFO.Width < 1 Or convTileINFO.Height < 1 Then
  MsgBox "圖像寬或高爲非法數據，無法轉換，請修改！", vbCritical, "錯誤"
  Exit Sub
End If
'
'Dim pX As Integer, pY As Integer

'Dim tempColor As Long, tempStr As String

''掃描圖像，轉換顔色
'
'For pY = 0 To convTileINFO.Height - 1
' For pX = 0 To convTileINFO.Width - 1
'    If picEdit.Point(pX, pY) <> lblColor.BackColor Then
'        tempStr = Hex(picEdit.Point(pX, pY))
'        tempStr = String(6 - Len(tempStr), "0") & tempStr
'        B = Val("&H" & Left(tempStr, 2))
'        G = Val("&H" & Mid(tempStr, 3, 2))
'        R = Val("&H" & Right(tempStr, 2))
'        picConv.PSet (pX, pY), R + G * 256& + B * 65536
'    End If
' Next pX
'Next pY
Dim iBitmap As Long, iDC As Long, LineBytes As Long
    Dim bi24BitInfo As BITMAPINFO, bBytes() As Byte

    With bi24BitInfo.bmiHeader
        .biBitCount = 24
        .biCompression = BI_RGB
        .biPlanes = 1
        .biSize = Len(bi24BitInfo.bmiHeader)
        .biWidth = convTileINFO.Width
        .biHeight = convTileINFO.Height
        LineBytes = ((.biWidth * .biBitCount + 31) And &HFFFFFFE0) \ 8 '每行占用字节要是8的倍数，不够就补齐
         ReDim bBytes(0 To LineBytes * .biHeight - 1) As Byte
    End With
    iDC = CreateCompatibleDC(picEdit.hdc)
    iBitmap = CreateDIBSection(iDC, bi24BitInfo, DIB_RGB_COLORS, ByVal 0&, ByVal 0&, ByVal 0&)
    SelectObject iDC, iBitmap
    BitBlt iDC, 0, 0, bi24BitInfo.bmiHeader.biWidth, bi24BitInfo.bmiHeader.biHeight, GetDC(picEdit.hwnd), 0, 0, vbSrcCopy
    '下一句容易非法操作
    GetDIBits iDC, iBitmap, 0, bi24BitInfo.bmiHeader.biHeight, bBytes(0), bi24BitInfo, DIB_RGB_COLORS
    'MsgBox LBound(bBytes)
    DeleteDC iDC
    DeleteObject iBitmap


 Dim R As Byte, G As Byte, b As Byte
 Dim BestColor As Byte
 Dim tempR As Byte, tempG As Byte, tempB As Byte, tempZ As Long
 Dim CntH As Long, CntV As Long, Cnt As Long 'BMP内存宽(4的倍数)，高
 Dim tempData() As Byte
 tempZ = bi24BitInfo.bmiHeader.biWidth * bi24BitInfo.bmiHeader.biHeight - 1
 ReDim tempData(0 To tempZ) As Byte
    tempZ = (convTileINFO.Height - GetColorPos.Y - 1) * LineBytes + GetColorPos.X * 3
    tempB = bBytes(tempZ)
    tempG = bBytes(tempZ + 1)
    tempR = bBytes(tempZ + 2)
    lblColor.BackColor = tempR + tempG * 256& + tempB * 65536
    'Lbound是1
'MsgBox LineBytes
For CntV = 0 To convTileINFO.Height - 1
  For CntH = 0 To convTileINFO.Width - 1
     Cnt = CntV * LineBytes + CntH * 3
        b = bBytes(Cnt)
        G = bBytes(Cnt + 1)
        R = bBytes(Cnt + 2)
        If tempR = R And tempG = G And tempB = b Then
          If withMaskColor Then
              b = 255
              G = 0
              R = 255
            BestColor = Empty
          Else
             BestColor = ConvBMP2GameColor(b, G, R)
          End If
        Else
          BestColor = ConvBMP2GameColor(b, G, R)
        End If
        bBytes(Cnt) = b
        bBytes(Cnt + 1) = G
        bBytes(Cnt + 2) = R
        'offSet1 = convTileINFO.Height - (Cnt - 1) \ LineBytes - 1 '行
        'offSet2 = (Cnt Mod LineBytes) \ 3 '此行第几个
        tempData((convTileINFO.Height - CntV - 1) * convTileINFO.Width + CntH) = BestColor
    
  Next CntH
Next CntV
SetDIBitsToDevice picConv.hdc, 0, 0, bi24BitInfo.bmiHeader.biWidth, bi24BitInfo.bmiHeader.biHeight, 0, 0, 0, bi24BitInfo.bmiHeader.biHeight, bBytes(0), bi24BitInfo, DIB_RGB_COLORS
'Dim I As Byte
'For offSet2 = 0 To convTileINFO.Height - 1 'LBound(tempData) To UBound(tempData)
' For offSet1 = 0 To convTileINFO.Width - 1
'   I = tempData(offSet2 * convTileINFO.Width + offSet1)
'   picConv.PSet (offSet1, offSet2), palB(I) + palG(I) * 256& + palR(I) * 65536 'mColor_RGB(I)
' Next
'Next
ReDim convTileINFO.Data(0 To 63999) As Byte
Dim dataP As Long, lP As Long, eP As Long, tP As Long, colP As Long
Dim LineDataLen As Integer, Readed As Integer, Writed As Integer
Dim I As Long
With convTileINFO
    For I = 0 To .Height - 1
        dataP = I * .Width '指向tempDATA每行第0字节
        lP = lP + LineDataLen '本行数据长度存放
        eP = lP + 1
        tP = eP + 1
        Debug.Print lP, eP, tP
        LineDataLen = 3
        Readed = 0
        Do '一行颜色
          If Readed < .Width Then
            Do While tempData(dataP + Readed) = Empty
            'MsgBox Readed
                .Data(eP) = .Data(eP) + 1
                Readed = Readed + 1 '下一个tempdata地点
                If Readed >= .Width Then Exit Do
            Loop
          End If
          If Readed < .Width Then
            colP = 0
            Do While tempData(dataP + Readed) <> Empty
                colP = colP + 1
                .Data(tP + colP) = tempData(dataP + Readed)
                .Data(tP) = .Data(tP) + 1
                Readed = Readed + 1
                LineDataLen = LineDataLen + 1
                If Readed >= .Width Then Exit Do
            Loop
          End If
          .Data(lP) = .Data(lP) + 2 + .Data(tP)
          If Readed >= .Width Then
            If .Data(tP) = 0 Then
             .Data(lP) = .Data(lP) - 2
             LineDataLen = LineDataLen - 2
             .Data(eP) = 0
            End If
            Exit Do '一行完成
          End If
          eP = lP + LineDataLen
          tP = eP + 1
          LineDataLen = LineDataLen + 2
        Loop
    Next
End With
Debug.Print
ReDim Preserve convTileINFO.Data(LBound(tempData) To lP + LineDataLen - 1)
'For offSet1 = 0 To UBound(convTileINFO.Data)
' Debug.Print convTileINFO.Data(offSet1);
' If (offSet1 + 1) Mod 10 = 0 Then Debug.Print "*"
'Next
'Exit Sub

End Sub
Private Function ConvBMP2GameColor(b As Byte, G As Byte, R As Byte) As Byte
Dim I As Integer, tempSum As Integer, tempSum1 As Integer
Dim r1 As Integer, r2 As Integer, r3 As Integer
Dim bestIdx As Integer, tempINT As Integer
tempSum = 1024
For I = 0 To 255
 r1 = palR(I)
 r2 = palG(I)
 r3 = palB(I)
 tempSum1 = Abs(r1 - R) + Abs(r2 - G) + Abs(r3 - b)
 If tempSum1 < tempSum Then tempSum = tempSum1: bestIdx = I
Next
R = palR(bestIdx)
G = palG(bestIdx)
b = palB(bestIdx)
ConvBMP2GameColor = bestIdx
End Function
Private Sub OpenBMP()
     Dim ofn As OPENFILENAME
    Dim Rtn As String

    ofn.lStructSize = Len(ofn)
    ofn.hwndOwner = Me.hwnd
    ofn.hInstance = App.hInstance
    ofn.lpstrFilter = "24 位位圖 (*.BMP)"  '"金庸主程序(z.*)|z.*|存檔文件(*.grp)|*.grp|所有文件(*.*)|*.*"
    ofn.lpstrFile = Space(254)
    ofn.nMaxFile = 255
    ofn.lpstrFileTitle = Space(254)
    ofn.nMaxFileTitle = 255
    ofn.lpstrInitialDir = App.Path
    ofn.lpstrTitle = "打開位圖文件"
    ofn.flags = 6148

    Rtn = GetOpenFileName(ofn)

    If Rtn >= 1 Then picEdit.Picture = LoadPicture(ofn.lpstrFile)

End Sub

Private Sub Command2_Click()

'On Error Resume Next
'DrawOneTile2 picView, pic6, 0, 0, 0, 0, "c:\windows\desktop\test.grp", "c:\windows\desktop\test.idx", 0, False, True
'On Error GoTo 0
End Sub

Private Sub Form_Load()
Call iniControls


If Not palOK Then Call SetColor
Started = True
Combo1.ListIndex = 0
withMaskColor = True
End Sub

Private Sub iniControls()
Dim I As Integer
Me.Caption = "貼圖資源編輯器"
Command1(0).Caption = "來自BMP"
Command1(1).Caption = "來自剪貼板"
Command1(2).Caption = "透明色"
Command1(3).Caption = "轉換"
Command1(4).Caption = "測試XY"
'Command1(5).Caption = "不能刪除貼圖" '"刪除最後貼圖"
Command1(6).Caption = "添加到尾部"
Command1(7).Caption = "插入0"
Command1(8).Caption = "刪除0"
Command1(9).Caption = "插入空圖"
Command1(9).ToolTipText = "在此處插入無數據的空圖，並指向前一個貼圖，文件不增大"
Label3(0).Caption = "指定寬>"
Label3(1).Caption = "指定高>"
Label3(2).Caption = "X偏移>"
Label3(3).Caption = "Y偏移>"

picView.ToolTipText = "(右鍵－複制到剪貼板)"
Pic6.ToolTipText = "(中鍵－複制到剪貼板)"
picConv.ToolTipText = "(右鍵－複制到剪貼板)"
For I = 0 To Label1.UBound
  Label1(I).Caption = 0
Next
With Combo1
    .AddItem HDGRP_GRP & "|頭像貼圖"
    Combo3.AddItem HDGRP_IDX
    .AddItem FMAP_GRP & "|內景底層貼圖"
    Combo3.AddItem FMAP_IDX
    .AddItem MMAP_GRP & "|外景貼圖"
    Combo3.AddItem MMAP_IDX
    .AddItem CLOUD_GRP & "|雲彩貼圖"
    Combo3.AddItem CLOUD_IDX
    .AddItem TITLE_GRP & "|標題菜單"
    Combo3.AddItem TITLE_IDX
    .AddItem EFT_GRP & "|武功動畫"
    Combo3.AddItem EFT_IDX
    .AddItem FBK_GRP & "|主角出招動畫"
    Combo3.AddItem FBK_IDX
    .AddItem SMPxxx(0) & "|場景00貼圖"
    Combo3.AddItem SDXxxx(0)
    For I = 1 To UBound(SMPxxx)
     If SMPxxx(I) <> SMPxxx(I - 1) Then
      .AddItem SMPxxx(I) & "|場景" & Format(I, "00") & "貼圖"
      Combo3.AddItem SDXxxx(I)
     End If
    Next
    .AddItem WMPxxx(0) & "|戰鬥場景00貼圖"
    Combo3.AddItem WDXxxx(0)
    For I = 1 To UBound(WMPxxx)
     If WMPxxx(I) <> WMPxxx(I - 1) Then
      .AddItem WMPxxx(I) & "|戰鬥場景" & Format(I, "00") & "貼圖"
      Combo3.AddItem WDXxxx(I)
     End If
    Next

     .AddItem FIGHTxxx_GRP(0) & "|人物00出招動畫"
     Combo3.AddItem FIGHTxxx_IDX(0)
    For I = 1 To UBound(FIGHTxxx_GRP)
     If FIGHTxxx_GRP(I) <> FIGHTxxx_GRP(I - 1) Then
       .AddItem FIGHTxxx_GRP(I) & "|人物" & Format(I, "00") & "出招動畫"
       Combo3.AddItem FIGHTxxx_IDX(I)
     End If
    Next
End With

SetComboHeight Combo1, 300
SetComboWidth Combo1, 200
PointO.X = LineY.X1
PointO.Y = LineX.Y1
End Sub

Private Sub Disp6Pic()
End Sub

Private Sub Label3_MouseDown(Index As Integer, Button As Integer, Shift As Integer, X As Single, Y As Single)
If Index = 2 Or Index = 3 Then
 Dim tempN As Integer
 If Button = vbLeftButton Then tempN = 1 Else tempN = -1
 Text1(Index).Text = Val(Text1(Index).Text) + tempN
 Command1_Click 4
End If
End Sub

Private Sub Label3_MouseMove(Index As Integer, Button As Integer, Shift As Integer, X As Single, Y As Single)
If Button <> 0 Then
  Call Label3_MouseDown(Index, Button, Shift, X, Y)
Else
  Text1(Index).SetFocus
End If
End Sub

Private Sub lblColor_Click()
withMaskColor = Not withMaskColor
With Command1(2)
  If withMaskColor Then
    .Caption = "透明色"
    .Enabled = True
  Else
    .Caption = "不透明"
    .Enabled = False
    picEdit.MousePointer = 0
  End If
End With
  
End Sub

Private Sub pic6_MouseUp(Button As Integer, Shift As Integer, X As Single, Y As Single)
Dim SelTileINFO As RLEPic1

If Button = vbLeftButton Or Button = vbRightButton Then
 Dim tempLong As Long
 tempLong = 793 / 6
 
 CurShapePos = X \ tempLong '當前選擇框位置
 If CurStartTile + CurShapePos <= Slider1.Max Then
  CurSelectTile = CurStartTile + CurShapePos
  Shape1.Left = CurShapePos * tempLong
 Else
  CurSelectTile = CurStartTile
  Shape1.Left = 0
  Exit Sub
 End If
 setStaBarText 2, "貼圖:" & CurSelectTile
 Command1(7).Caption = "插入" & CurSelectTile
 Command1(8).Caption = "刪除" & CurSelectTile
 
 SelTileINFO = GetTileINFO(GamePath & CurTileFile, GamePath & CurTileFileIdx, CurStartTile + CurShapePos)
 If Button = vbLeftButton Then
   picView.Cls
   DrawOneTile2 picView, Pic6, (PointO.X), (PointO.Y), tempLong * CurShapePos, 0, GamePath & CurTileFile, GamePath & CurTileFileIdx, CurStartTile + CurShapePos, True, False
 Else
   picEdit.Picture = LoadPicture("")
   Text1(2).Text = SelTileINFO.X
   Text1(3).Text = SelTileINFO.Y
   picEdit.Move picEdit.Left, picEdit.Top, SelTileINFO.Width, SelTileINFO.Height
   DrawOneTile2 picEdit, Pic6, 0, 0, tempLong * CurShapePos, 0, GamePath & CurTileFile, GamePath & CurTileFileIdx, CurStartTile + CurShapePos, False, False
   GetColorPos.X = 0: GetColorPos.Y = 0
   lblColor.BackColor = picEdit.Point(0, 0)
 End If
 setStaBarText 1, "寬/高    " & SelTileINFO.Width & "/" & SelTileINFO.Height & "         X偏移/Y偏移    " & SelTileINFO.X & "/" & SelTileINFO.Y
End If

If Button = vbMiddleButton Then
  Clipboard.Clear
  Clipboard.SetData Pic6.Image
End If
End Sub

Private Sub picConv_MouseDown(Button As Integer, Shift As Integer, X As Single, Y As Single)
If Button = vbRightButton Then
  Clipboard.Clear
  Clipboard.SetData picConv.Image
End If
End Sub

Private Sub picedit_MouseDown(Button As Integer, Shift As Integer, X As Single, Y As Single)
If picEdit.MousePointer = 2 Then
 'picEdit.
     lblColor.BackColor = picEdit.Point(X, Y)
     GetColorPos.X = X
     GetColorPos.Y = Y
      picEdit.MousePointer = 0
End If
If Button = vbRightButton Then Clipboard.SetData picEdit.Picture

End Sub

Private Sub picedit_MouseMove(Button As Integer, Shift As Integer, X As Single, Y As Single)
If picEdit.MousePointer = 2 Then
     lblColor.BackColor = picEdit.Point(X, Y)
     setStaBarText 4, Hex(lblColor.BackColor)
End If
End Sub
Private Function getPixels() As Long
    Dim Dc As Long, rret As Long
    Dim Pos As POINTAPI
    Dc = GetDC(0)
    rret = GetCursorPos(Pos)
    getPixels = GetPixel(Dc, Pos.X, Pos.Y)
    rret = ReleaseDC(0, Dc)
End Function

Private Sub picEdit_Resize()
Command1(6).Enabled = False
Command1(7).Enabled = False
 With picEdit
     If .Width > 230 Then .Width = 230
     If .Height > 312 Then .Height = 312
     picConv.Width = .Width
     picConv.Height = .Height
     Text1(0).Text = .Width
     Text1(1).Text = .Height
     .ToolTipText = "寬" & .Width & "/高" & .Height & "(單擊右鍵複制到剪貼板)"
 End With
End Sub

Private Sub picView_MouseDown(Button As Integer, Shift As Integer, X As Single, Y As Single)
If Button = vbRightButton Then
  Clipboard.Clear
  Clipboard.SetData picView.Image
End If
End Sub

Private Sub Slider1_Change()

Dim I As Integer, tempObj As Object
CurStartTile = Slider1.Value '+ CurShapePos
CurSelectTile = CurStartTile + CurShapePos
Pic6.Cls
If CurSelectTile > Slider1.Max Then
  CurSelectTile = CurStartTile
  Shape1.Left = 0: CurShapePos = 0
End If
For I = 0 To 5
    If CurStartTile + I > Slider1.Max Then Label1(I) = "" Else Label1(I) = CurStartTile + I
Next
 For I = 0 To 5
    If CurStartTile + I > Slider1.Max Then
        'CurSelectTile = CurStartTile
        'Shape1.Left = 0: CurShapePos = 0
        Exit For
    End If
    Set tempObj = Nothing
'    If I = CurShapePos Then
'     picView.Cls
'     Set tempObj = picView
'    End If
     'pic6_MouseUp vbLeftButton, 0, I * (793 / 6), 0
     DrawOneTile2 tempObj, Pic6, 0, 0, I * (793 / 6), 0, GamePath & CurTileFile, GamePath & CurTileFileIdx, CurStartTile + I, False, False
 Next
Pic6.Refresh
pic6_MouseUp vbLeftButton, 0, CurShapePos * (793 / 6), 0
End Sub

Private Sub Text1_Change(Index As Integer)
If Not ChkInt(Text1(Index).Text) Then Text1(Index).Text = 0: Exit Sub
convTileINFO.Width = Val(Text1(0).Text)
convTileINFO.Height = Val(Text1(1).Text)
convTileINFO.X = Val(Text1(2).Text)
convTileINFO.Y = Val(Text1(3).Text)
If Index < 2 Then
  Command1(6).Enabled = False
  Command1(7).Enabled = False
End If
End Sub

Private Sub Text1_GotFocus(Index As Integer)
Text1(Index).SelStart = 0
Text1(Index).SelLength = Len(Text1(Index).Text) + 1
End Sub
