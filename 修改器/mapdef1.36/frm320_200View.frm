VERSION 5.00
Object = "{831FDD16-0C5C-11D2-A9FC-0000F8754DA1}#2.0#0"; "MSCOMCTL.OCX"
Begin VB.Form frm320_200View 
   Caption         =   "320*200„Ó®‹Ó^¿´"
   ClientHeight    =   7215
   ClientLeft      =   60
   ClientTop       =   345
   ClientWidth     =   10725
   LinkTopic       =   "Form2"
   MDIChild        =   -1  'True
   ScaleHeight     =   481
   ScaleMode       =   3  'Pixel
   ScaleWidth      =   715
   WindowState     =   2  'Maximized
   Begin MSComctlLib.Slider Slider1 
      Height          =   255
      Left            =   2640
      TabIndex        =   7
      Top             =   7200
      Width           =   3375
      _ExtentX        =   5953
      _ExtentY        =   450
      _Version        =   393216
      Min             =   -30
      Max             =   30
      SelStart        =   1
      Value           =   1
   End
   Begin VB.PictureBox pic320 
      BackColor       =   &H00FF00FF&
      Height          =   3000
      Left            =   7080
      ScaleHeight     =   196
      ScaleMode       =   3  'Pixel
      ScaleWidth      =   316
      TabIndex        =   6
      Top             =   4620
      Width           =   4800
   End
   Begin VB.OptionButton Option1 
      Caption         =   "DEAD"
      BeginProperty Font 
         Name            =   "Times New Roman"
         Size            =   9
         Charset         =   0
         Weight          =   400
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Height          =   180
      Index           =   2
      Left            =   1680
      TabIndex        =   5
      Top             =   7320
      Width           =   855
   End
   Begin VB.OptionButton Option1 
      Caption         =   "TITLE"
      BeginProperty Font 
         Name            =   "Times New Roman"
         Size            =   9
         Charset         =   0
         Weight          =   400
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Height          =   180
      Index           =   1
      Left            =   840
      TabIndex        =   4
      Top             =   7320
      Width           =   855
   End
   Begin VB.OptionButton Option1 
      Caption         =   "KEND"
      BeginProperty Font 
         Name            =   "Times New Roman"
         Size            =   9
         Charset         =   0
         Weight          =   400
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Height          =   180
      Index           =   0
      Left            =   0
      TabIndex        =   3
      Top             =   7320
      Value           =   -1  'True
      Width           =   855
   End
   Begin VB.CommandButton Command1 
      Caption         =   "Play"
      BeginProperty Font 
         Name            =   "Times New Roman"
         Size            =   9
         Charset         =   0
         Weight          =   400
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Height          =   375
      Left            =   6120
      TabIndex        =   2
      Top             =   7200
      Width           =   975
   End
   Begin VB.ListBox lstFrame 
      Columns         =   2
      BeginProperty Font 
         Name            =   "Times New Roman"
         Size            =   9
         Charset         =   0
         Weight          =   400
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Height          =   4560
      Left            =   9600
      TabIndex        =   1
      Top             =   0
      Width           =   2295
   End
   Begin VB.PictureBox pic640 
      BackColor       =   &H00FFFFFF&
      Height          =   7200
      Left            =   0
      ScaleHeight     =   476
      ScaleMode       =   3  'Pixel
      ScaleWidth      =   636
      TabIndex        =   0
      Top             =   0
      Width           =   9600
   End
End
Attribute VB_Name = "frm320_200View"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Dim AutoPlay As Boolean
Private Sub Command1_Click()
Dim I As Long, Start As Integer, Finish As Integer, PlayStep As Integer
Command1.Enabled = False
PlayStep = Slider1.Value
If PlayStep > 0 Then tempINT = lstFrame.ListCount - 1 Else tempINT = 0
For I = lstFrame.ListIndex To tempINT Step PlayStep
  lstFrame.ListIndex = I
Next
Command1.Enabled = True
End Sub

Private Sub Form_Load()
'KEND_GRP
Me.Caption = "Æ¬î^Æ¬Î²„Ó®‹"

PlayMode = 1
If Not palOK Then Call SetColor
Option1_Click 0
End Sub
Private Sub Form_Resize()
pic320.Left = frm320_200View.Width / 15 - pic320.Width - 10
End Sub
Private Sub lstFrame_Click()
If lstFrame.ListIndex < 0 Then Exit Sub
Command1.Enabled = False
If Option1(0).Value = True Then
    Command1.Enabled = True
    Draw320_200 pic320, 0, 0, GamePath & KEND_GRP, GamePath & KEND_IDX, lstFrame.ListIndex
    setStaBarText 5, lstFrame.ListIndex + 1 & "/" & lstFrame.ListCount
ElseIf Option1(1).Value = True Then
    Draw320_200 pic320, 0, 0, GamePath & TITLE_BIG, GamePath & "tmp.tmp", lstFrame.ListIndex
ElseIf Option1(2).Value = True Then
    Draw320_200 pic320, 0, 0, GamePath & DEAD_BIG, GamePath & "tmp.tmp", lstFrame.ListIndex
End If
'BitBlt pic640.hdc, 0, 0, 640, 480, pic320.hdc, 0, 0, vbSrcCopy
StretchBlt pic640.hdc, 0, 0, 640, 480, pic320.hdc, 0, 0, 320, 200, vbSrcCopy
End Sub
Private Sub Option1_Click(Index As Integer)
lstFrame.Clear
Select Case Index
  Case 0
    Dim tempFile As Integer, tempLong As Long
    tempFile = FreeFile
    Open GamePath & KEND_IDX For Binary As #tempFile
    Do
        Get #tempFile, , tempLong
        If tempLong = 0 Then Exit Do
        lstFrame.AddItem tempLong
    Loop
    Close #tempFile
  Case 1, 2
    lstFrame.AddItem 64000
End Select
lstFrame.ListIndex = 0
End Sub
Private Sub pic320_Click()
pic320.Visible = False
End Sub
Private Sub pic640_Click()
pic320.Visible = True
End Sub
Private Sub Slider1_Change()
If Slider1.Value = 0 Then Slider1.Value = 1
Command1.Caption = "Play" & Slider1.Value
End Sub

