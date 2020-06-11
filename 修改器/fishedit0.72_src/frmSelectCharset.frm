VERSION 5.00
Begin VB.Form frmSelectCharset 
   Caption         =   "Fishedit0.72.1"
   ClientHeight    =   2505
   ClientLeft      =   60
   ClientTop       =   345
   ClientWidth     =   4575
   BeginProperty Font 
      Name            =   "黑体"
      Size            =   10.5
      Charset         =   134
      Weight          =   700
      Underline       =   0   'False
      Italic          =   0   'False
      Strikethrough   =   0   'False
   EndProperty
   ForeColor       =   &H00000000&
   LinkTopic       =   "Form2"
   ScaleHeight     =   2505
   ScaleWidth      =   4575
   StartUpPosition =   2  '屏幕中心
   Begin VB.CommandButton Command2 
      Caption         =   $"frmSelectCharset.frx":0000
      BeginProperty Font 
         Name            =   "黑体"
         Size            =   9
         Charset         =   134
         Weight          =   400
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Height          =   495
      Left            =   480
      TabIndex        =   1
      Top             =   1680
      Width           =   3615
   End
   Begin VB.CommandButton Command1 
      BackColor       =   &H00FFFFFF&
      Caption         =   $"frmSelectCharset.frx":0019
      BeginProperty Font 
         Name            =   "黑体"
         Size            =   9
         Charset         =   134
         Weight          =   400
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Height          =   495
      Left            =   480
      TabIndex        =   0
      Top             =   960
      Width           =   3615
   End
End
Attribute VB_Name = "frmSelectCharset"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Option Explicit

Private Sub Command1_Click()
    Charset = "GBK"
    Unload Me
End Sub

Private Sub Command2_Click()
    Charset = "BIG5"
    Unload Me
End Sub

