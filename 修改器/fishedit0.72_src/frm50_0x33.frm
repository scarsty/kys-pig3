VERSION 5.00
Begin VB.Form frm50_0x33 
   Caption         =   "50指令33"
   ClientHeight    =   6405
   ClientLeft      =   60
   ClientTop       =   345
   ClientWidth     =   9690
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
   ScaleHeight     =   6405
   ScaleWidth      =   9690
   StartUpPosition =   2  '屏幕中心
   Begin VB.TextBox txtNote 
      Appearance      =   0  'Flat
      BackColor       =   &H80000013&
      BorderStyle     =   0  'None
      ForeColor       =   &H00FF0000&
      Height          =   1455
      Left            =   120
      Locked          =   -1  'True
      MultiLine       =   -1  'True
      TabIndex        =   16
      Text            =   "frm50_0x33.frx":0000
      Top             =   4920
      Width           =   5415
   End
   Begin VB.TextBox txt2 
      Enabled         =   0   'False
      Height          =   330
      Left            =   3840
      TabIndex        =   15
      Text            =   "Text1"
      Top             =   3480
      Width           =   735
   End
   Begin VB.TextBox txt1 
      Enabled         =   0   'False
      Height          =   330
      Left            =   3840
      TabIndex        =   14
      Text            =   "Text1"
      Top             =   2640
      Width           =   735
   End
   Begin VB.CommandButton Command1 
      Caption         =   "设置颜色"
      Height          =   375
      Left            =   2280
      TabIndex        =   13
      Top             =   4080
      Width           =   1455
   End
   Begin VB.OptionButton Option2 
      Caption         =   "选择低8位颜色"
      Height          =   375
      Left            =   2280
      TabIndex        =   12
      Top             =   3480
      Width           =   1815
   End
   Begin VB.OptionButton Option1 
      Caption         =   "选择高8位颜色"
      Height          =   375
      Left            =   2280
      TabIndex        =   11
      Top             =   2640
      Value           =   -1  'True
      Width           =   1695
   End
   Begin VB.PictureBox PicPalette 
      Appearance      =   0  'Flat
      AutoRedraw      =   -1  'True
      BackColor       =   &H80000005&
      ForeColor       =   &H80000008&
      Height          =   3855
      Left            =   5760
      ScaleHeight     =   255
      ScaleMode       =   3  'Pixel
      ScaleWidth      =   255
      TabIndex        =   10
      ToolTipText     =   "单击选择颜色"
      Top             =   2160
      Width           =   3855
   End
   Begin fishedit.userVar userS 
      Height          =   1455
      Left            =   240
      TabIndex        =   5
      Top             =   720
      Width           =   1935
      _extentx        =   3413
      _extenty        =   2566
   End
   Begin fishedit.userVar userX 
      Height          =   1215
      Left            =   2400
      TabIndex        =   3
      Top             =   720
      Width           =   1935
      _extentx        =   3413
      _extenty        =   2143
   End
   Begin VB.CommandButton cmdcancel 
      Caption         =   "取消"
      Height          =   375
      Left            =   8040
      TabIndex        =   1
      Top             =   1320
      Width           =   1335
   End
   Begin VB.CommandButton cmdok 
      Caption         =   "确定"
      Height          =   375
      Left            =   8040
      TabIndex        =   0
      Top             =   480
      Width           =   1335
   End
   Begin fishedit.userVar userY 
      Height          =   1215
      Left            =   4440
      TabIndex        =   6
      Top             =   720
      Width           =   1935
      _extentx        =   3413
      _extenty        =   2143
   End
   Begin fishedit.userVar userColor 
      Height          =   1215
      Left            =   120
      TabIndex        =   8
      Top             =   3120
      Width           =   1935
      _extentx        =   3413
      _extenty        =   2143
   End
   Begin VB.Shape Shape2 
      FillStyle       =   0  'Solid
      Height          =   375
      Left            =   4680
      Top             =   3480
      Width           =   855
   End
   Begin VB.Shape Shape1 
      BackColor       =   &H00FF0000&
      FillColor       =   &H00FF0000&
      FillStyle       =   0  'Solid
      Height          =   375
      Left            =   4680
      Top             =   2640
      Width           =   855
   End
   Begin VB.Label Label5 
      Caption         =   "显示颜色Color"
      Height          =   375
      Left            =   120
      TabIndex        =   9
      Top             =   2520
      Width           =   1695
   End
   Begin VB.Label Label3 
      Caption         =   "显示坐标Y"
      Height          =   375
      Left            =   4320
      TabIndex        =   7
      Top             =   240
      Width           =   1095
   End
   Begin VB.Label Label6 
      Caption         =   "显示坐标X"
      Height          =   375
      Left            =   2520
      TabIndex        =   4
      Top             =   240
      Width           =   1095
   End
   Begin VB.Label Label4 
      Caption         =   "要显示的字符串S"
      Height          =   375
      Left            =   240
      TabIndex        =   2
      Top             =   240
      Width           =   1695
   End
End
Attribute VB_Name = "frm50_0x33"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Option Explicit
Dim Index As Long
Public kk As Statement
Dim OffsetName As Collection



Private Sub cmdcancel_Click()
    Unload Me
End Sub

Private Sub cmdok_Click()
 
    kk.Data(1) = userX.Value + userY.Value * 2 + userColor.Value * 4
    kk.Data(2) = userS.Text
    kk.Data(3) = userX.Text
    kk.Data(4) = userY.Text
    kk.Data(5) = userColor.Text
    kk.Data(6) = 0

    
    Unload Me
    
End Sub

 




 

Private Sub Command1_Click()
    If userColor.Value = 0 Then
        userColor.Text = Long2int(txt1.Text * 256 + txt2.Text)
    End If
End Sub

Private Sub Form_Load()
Dim num50 As Long
Dim i As Long, j As Long
Dim rr As Long, gg As Long, bb As Long
Dim color As Long
Dim s1 As String
    Call ConvertForm(Me)
    
    
    Index = frmmain.listkdef.ListIndex
    Set kk = KdefInfo(frmmain.Combokdef.ListIndex).kdef.Item(Index + 1)

    
    userS.Text = kk.Data(2)
    
    userX.Value = IIf((kk.Data(1) And &H1) > 0, 1, 0)
    userY.Value = IIf((kk.Data(1) And &H2) > 0, 1, 0)
    userColor.Value = IIf((kk.Data(1) And &H4) > 0, 1, 0)
    
    userS.Showtype = False
    userS.SetCombo

    userX.Text = kk.Data(3)
    userX.SetCombo
    userY.Text = kk.Data(4)
    userY.SetCombo
    userColor.Text = kk.Data(5)
    userColor.SetCombo

    Call Set50Form(Me, kk.Data(0))
    
    For j = 0 To 15
        For i = 0 To 15
            rr = (mcolor_RGB(i + j * 16) \ 65536) And &HFF&
            gg = (mcolor_RGB(i + j * 16) \ 256) And &HFF
            bb = mcolor_RGB(i + j * 16) And &HFF
            
            PicPalette.Line (i * 16, j * 16)-((i + 1) * 16, (j + 1) * 16), RGB(rr, gg, bb), BF
        Next i
    Next j
    
    
    If userColor.Value = 0 Then
        color = Int2Long(userColor.Text) \ 256
        rr = (mcolor_RGB(color) \ 65536) And &HFF&
        gg = (mcolor_RGB(color) \ 256) And &HFF
        bb = mcolor_RGB(color) And &HFF
        
        Shape1.FillColor = RGB(rr, gg, bb)
        txt1.Text = color
        
        color = Int2Long(userColor.Text) And &HFF
        rr = (mcolor_RGB(color) \ 65536) And &HFF&
        gg = (mcolor_RGB(color) \ 256) And &HFF
        bb = mcolor_RGB(color) And &HFF
        
        Shape2.FillColor = RGB(rr, gg, bb)
        txt2.Text = color
        
        
    End If

 
End Sub

 

Private Sub PicPalette_MouseDown(Button As Integer, Shift As Integer, x As Single, Y As Single)
Dim rr As Long, gg As Long, bb As Long
Dim color As Long
Dim colorRGB As Long
    color = (x \ 16) + (Y \ 16) * 16
    rr = (mcolor_RGB(color) \ 65536) And &HFF&
    gg = (mcolor_RGB(color) \ 256) And &HFF
    bb = mcolor_RGB(color) And &HFF

    colorRGB = RGB(rr, gg, bb)

    If Option1.Value = True Then
        Shape1.FillColor = colorRGB
        txt1.Text = color
    Else
        Shape2.FillColor = colorRGB
        txt2.Text = color
    End If


End Sub
