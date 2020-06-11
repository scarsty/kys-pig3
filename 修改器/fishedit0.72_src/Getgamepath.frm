VERSION 5.00
Begin VB.Form Getgamepath 
   BorderStyle     =   3  'Fixed Dialog
   Caption         =   "设置游戏路径"
   ClientHeight    =   3195
   ClientLeft      =   2760
   ClientTop       =   3750
   ClientWidth     =   6330
   LinkTopic       =   "Form1"
   MaxButton       =   0   'False
   MinButton       =   0   'False
   ScaleHeight     =   3195
   ScaleWidth      =   6330
   ShowInTaskbar   =   0   'False
   Begin VB.DirListBox Dir1 
      BeginProperty Font 
         Name            =   "Times New Roman"
         Size            =   9
         Charset         =   0
         Weight          =   400
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Height          =   1875
      Left            =   240
      TabIndex        =   3
      Top             =   720
      Width           =   3855
   End
   Begin VB.DriveListBox Drive1 
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
      Left            =   240
      TabIndex        =   2
      Top             =   240
      Width           =   3855
   End
   Begin VB.CommandButton CancelButton 
      Caption         =   "取消"
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
      Left            =   4680
      TabIndex        =   1
      Top             =   600
      Width           =   1215
   End
   Begin VB.CommandButton OKButton 
      Caption         =   "确定"
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
      Left            =   4680
      TabIndex        =   0
      Top             =   120
      Width           =   1215
   End
End
Attribute VB_Name = "Getgamepath"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False

Option Explicit

Private Sub CancelButton_Click()
    Unload Me
End Sub

Private Sub Drive1_Change()
    Dir1.Path = Drive1.Drive
End Sub

Private Sub Form_Load()
Dim i As Long

    G_Var.JYPath = ""
    Me.Caption = StrUnicode(Me.Caption)
    'Me.Caption = LoadResStr(401)
'    OKButton.Caption = LoadResStr(102)
' ‘   CancelButton.Caption = LoadResStr(103)
    For i = 0 To Me.Controls.Count - 1
        Call SetCaption(Me.Controls(i))
    Next i

   
End Sub

Private Sub OKButton_Click()
    If Dir1.Path <> "" Then
        G_Var.JYPath = Dir1.Path & "\"
        Unload Me
    End If
End Sub
