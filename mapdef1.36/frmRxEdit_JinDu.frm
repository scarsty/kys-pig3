VERSION 5.00
Begin VB.Form frmRxEdit_JinDu 
   BorderStyle     =   3  'Fixed Dialog
   Caption         =   "对话框标题"
   ClientHeight    =   2070
   ClientLeft      =   2760
   ClientTop       =   3750
   ClientWidth     =   2520
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
   MaxButton       =   0   'False
   MinButton       =   0   'False
   ScaleHeight     =   2070
   ScaleWidth      =   2520
   ShowInTaskbar   =   0   'False
   Begin VB.CheckBox Check1 
      Caption         =   "读1存2"
      Height          =   255
      Left            =   1320
      TabIndex        =   14
      Top             =   960
      Value           =   1  'Checked
      Visible         =   0   'False
      Width           =   855
   End
   Begin VB.CommandButton OKButton 
      Caption         =   "确定"
      Height          =   360
      Left            =   1440
      TabIndex        =   13
      Top             =   1200
      Width           =   975
   End
   Begin VB.CommandButton CancelButton 
      Caption         =   "取消"
      Height          =   360
      Left            =   1440
      TabIndex        =   12
      Top             =   1680
      Width           =   975
   End
   Begin VB.Frame Frame1 
      Caption         =   "读/存范围"
      Height          =   2055
      Index           =   1
      Left            =   0
      TabIndex        =   4
      Top             =   0
      Width           =   1335
      Begin VB.OptionButton Option2 
         Caption         =   "全部"
         Height          =   250
         Index           =   0
         Left            =   120
         TabIndex        =   11
         Top             =   240
         Value           =   -1  'True
         Width           =   1095
      End
      Begin VB.OptionButton Option2 
         Caption         =   "小宝商店"
         Height          =   255
         Index           =   6
         Left            =   120
         TabIndex        =   10
         Top             =   1680
         Width           =   1215
      End
      Begin VB.OptionButton Option2 
         Caption         =   "武功"
         Height          =   255
         Index           =   5
         Left            =   120
         TabIndex        =   9
         Top             =   1440
         Width           =   1095
      End
      Begin VB.OptionButton Option2 
         Caption         =   "场景"
         Height          =   255
         Index           =   4
         Left            =   120
         TabIndex        =   8
         Top             =   1200
         Width           =   1095
      End
      Begin VB.OptionButton Option2 
         Caption         =   "物品"
         Height          =   255
         Index           =   3
         Left            =   120
         TabIndex        =   7
         Top             =   960
         Width           =   1095
      End
      Begin VB.OptionButton Option2 
         Caption         =   "人物"
         Height          =   255
         Index           =   2
         Left            =   120
         TabIndex        =   6
         Top             =   720
         Width           =   1095
      End
      Begin VB.OptionButton Option2 
         Caption         =   "基本数据"
         Height          =   255
         Index           =   1
         Left            =   120
         TabIndex        =   5
         Top             =   480
         Width           =   1215
      End
   End
   Begin VB.Frame Frame1 
      Caption         =   "选择进度"
      Height          =   1095
      Index           =   0
      Left            =   1320
      TabIndex        =   0
      Top             =   0
      Width           =   1215
      Begin VB.OptionButton Option1 
         Caption         =   "进度三"
         Height          =   255
         Index           =   2
         Left            =   120
         TabIndex        =   3
         Top             =   720
         Width           =   975
      End
      Begin VB.OptionButton Option1 
         Caption         =   "进度二"
         Height          =   255
         Index           =   1
         Left            =   120
         TabIndex        =   2
         Top             =   480
         Width           =   975
      End
      Begin VB.OptionButton Option1 
         Caption         =   "进度一"
         Height          =   255
         Index           =   0
         Left            =   120
         TabIndex        =   1
         Top             =   240
         Value           =   -1  'True
         Width           =   975
      End
   End
End
Attribute VB_Name = "frmRxEdit_JinDu"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False

Option Explicit

Private Sub CancelButton_Click()
Unload Me
End Sub

Private Sub Form_Load()
Me.Icon = MDIFormMain.Icon
End Sub

Private Sub OKButton_Click()
Dim C1 As Integer, C2 As Integer, C3 As Integer, I As Integer
For I = 0 To 6
  If Option2(I).Value = True Then C1 = I: C2 = I
Next
If C1 = 0 Then C1 = 1: C2 = 6
For I = 0 To 2
  If Option1(I).Value = True Then C3 = I
Next

frmRxEdit.ReadRx_GRPfile Check1.Value, C1, C2, C3
If Check1.Value = 1 Then frmRxEdit.IniListItem
Unload Me
End Sub

Private Sub Option1_DblClick(Index As Integer)
OKButton_Click
End Sub
