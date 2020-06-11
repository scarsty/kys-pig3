VERSION 5.00
Begin VB.Form frmPicEdit 
   Caption         =   "贴图编辑"
   ClientHeight    =   8010
   ClientLeft      =   60
   ClientTop       =   345
   ClientWidth     =   11175
   LinkTopic       =   "Form1"
   ScaleHeight     =   534
   ScaleMode       =   3  'Pixel
   ScaleWidth      =   745
   StartUpPosition =   2  '屏幕中心
   Begin VB.CommandButton cmdSet 
      Caption         =   "设置透明色"
      Height          =   375
      Left            =   2880
      TabIndex        =   25
      ToolTipText     =   "用透明色替换当前颜色"
      Top             =   3600
      Width           =   1095
   End
   Begin VB.CommandButton Cmdwh 
      Caption         =   "确认宽高"
      Height          =   375
      Left            =   0
      TabIndex        =   23
      Top             =   1560
      Width           =   1335
   End
   Begin VB.CheckBox chkOffset 
      Caption         =   "显示偏移"
      Height          =   255
      Left            =   0
      TabIndex        =   22
      Top             =   2040
      Width           =   1095
   End
   Begin VB.CommandButton cmdConvert2 
      Caption         =   "颜色转换2"
      Height          =   375
      Left            =   5640
      TabIndex        =   21
      Top             =   120
      Width           =   1335
   End
   Begin VB.CommandButton cmdConvert 
      Caption         =   "颜色转换"
      Height          =   375
      Left            =   4200
      TabIndex        =   20
      Top             =   120
      Width           =   1335
   End
   Begin VB.PictureBox Picbak 
      Appearance      =   0  'Flat
      AutoRedraw      =   -1  'True
      BackColor       =   &H80000005&
      BorderStyle     =   0  'None
      ForeColor       =   &H80000008&
      Height          =   375
      Left            =   9000
      ScaleHeight     =   25
      ScaleMode       =   3  'Pixel
      ScaleWidth      =   41
      TabIndex        =   19
      Top             =   120
      Visible         =   0   'False
      Width           =   615
   End
   Begin VB.HScrollBar HScroll1 
      Height          =   255
      Left            =   4080
      TabIndex        =   18
      Top             =   7440
      Width           =   6855
   End
   Begin VB.VScrollBar VScroll1 
      Height          =   6855
      Left            =   10920
      TabIndex        =   17
      Top             =   600
      Width           =   255
   End
   Begin VB.CommandButton cmdCopy 
      Caption         =   "复制到剪贴板"
      Height          =   375
      Left            =   0
      TabIndex        =   16
      Top             =   3000
      Width           =   1335
   End
   Begin VB.CommandButton cmdPaste 
      Caption         =   "从剪贴板复制"
      Height          =   375
      Left            =   0
      TabIndex        =   15
      Top             =   2520
      Width           =   1335
   End
   Begin VB.CommandButton cmdTrans 
      Caption         =   "选择透明色"
      Height          =   375
      Left            =   1680
      TabIndex        =   14
      ToolTipText     =   "选择透明色为当前颜色"
      Top             =   3600
      Width           =   1095
   End
   Begin VB.ComboBox ComboScale 
      Height          =   300
      ItemData        =   "frmPicEdit.frx":0000
      Left            =   8280
      List            =   "frmPicEdit.frx":0010
      Style           =   2  'Dropdown List
      TabIndex        =   11
      Top             =   120
      Width           =   1095
   End
   Begin VB.PictureBox PicLarge 
      Appearance      =   0  'Flat
      AutoRedraw      =   -1  'True
      BackColor       =   &H80000005&
      ForeColor       =   &H80000008&
      Height          =   6855
      Left            =   4080
      ScaleHeight     =   455
      ScaleMode       =   3  'Pixel
      ScaleWidth      =   455
      TabIndex        =   10
      ToolTipText     =   "左键拾取颜色，右键修改颜色"
      Top             =   600
      Width           =   6855
   End
   Begin VB.PictureBox PicPalette 
      Appearance      =   0  'Flat
      AutoRedraw      =   -1  'True
      BackColor       =   &H80000005&
      ForeColor       =   &H80000008&
      Height          =   3855
      Left            =   240
      ScaleHeight     =   255
      ScaleMode       =   3  'Pixel
      ScaleWidth      =   255
      TabIndex        =   9
      ToolTipText     =   "单击选择颜色"
      Top             =   4080
      Width           =   3855
   End
   Begin VB.CommandButton cmdok 
      Caption         =   "保存修改"
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
      Left            =   9720
      TabIndex        =   8
      Top             =   120
      Width           =   1335
   End
   Begin VB.PictureBox Pic1 
      Appearance      =   0  'Flat
      AutoRedraw      =   -1  'True
      BackColor       =   &H80000005&
      ForeColor       =   &H80000008&
      Height          =   3375
      Left            =   1440
      ScaleHeight     =   223
      ScaleMode       =   3  'Pixel
      ScaleWidth      =   167
      TabIndex        =   7
      Top             =   120
      Width           =   2535
   End
   Begin VB.TextBox txtY 
      Height          =   270
      Left            =   600
      TabIndex        =   6
      Text            =   "0"
      Top             =   1200
      Width           =   615
   End
   Begin VB.TextBox txtX 
      Height          =   270
      Left            =   600
      TabIndex        =   4
      Text            =   "0"
      Top             =   840
      Width           =   615
   End
   Begin VB.TextBox txtHeight 
      Height          =   270
      Left            =   600
      TabIndex        =   3
      Text            =   "0"
      Top             =   480
      Width           =   615
   End
   Begin VB.TextBox txtwidth 
      Height          =   270
      Left            =   600
      TabIndex        =   1
      Text            =   "0"
      Top             =   120
      Width           =   615
   End
   Begin VB.Label Label6 
      Caption         =   "放大倍数"
      Height          =   255
      Left            =   7320
      TabIndex        =   26
      Top             =   120
      Width           =   855
   End
   Begin VB.Label lblxy 
      Caption         =   "0,0"
      ForeColor       =   &H00FF0000&
      Height          =   255
      Left            =   4680
      TabIndex        =   24
      Top             =   7800
      Width           =   2055
   End
   Begin VB.Shape ShapeColor 
      FillStyle       =   0  'Solid
      Height          =   375
      Left            =   600
      Top             =   3600
      Width           =   975
   End
   Begin VB.Label Label5 
      Caption         =   "选择颜色"
      Height          =   375
      Left            =   120
      TabIndex        =   13
      Top             =   3600
      Width           =   495
   End
   Begin VB.Label Label3 
      Caption         =   "X偏移"
      Height          =   255
      Left            =   0
      TabIndex        =   12
      Top             =   840
      Width           =   615
   End
   Begin VB.Label Label4 
      Caption         =   "Y偏移"
      Height          =   255
      Left            =   0
      TabIndex        =   5
      Top             =   1200
      Width           =   615
   End
   Begin VB.Label Label2 
      Caption         =   "高度"
      Height          =   255
      Left            =   0
      TabIndex        =   2
      Top             =   480
      Width           =   615
   End
   Begin VB.Label Label1 
      Caption         =   "宽度"
      Height          =   255
      Left            =   0
      TabIndex        =   0
      Top             =   120
      Width           =   495
   End
End
Attribute VB_Name = "frmPicEdit"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Option Explicit

Public Yes As Long

Private picScale As Long
Private Data() As Long
Private WW As Long
Private HH As Long



Private Sub chkOffset_Click()
    ShowData
End Sub

Private Sub cmdConvert_Click()
Dim i As Long, j As Long
Dim c As Long
Dim rr As Long, gg As Long, bb As Long
Dim yy As Long, uu As Long, vv As Long
Dim rc(255) As Long, gc(255) As Long, bc(255) As Long
Dim yc(255) As Long, uc(255) As Long, vc(255) As Long
Dim vmin As Long, v As Long
Dim nn As Long
    Me.MousePointer = vbHourglass
    
    For i = 0 To 255
        rc(i) = (mcolor_RGB(i) \ 65536) And &HFF
        gc(i) = (mcolor_RGB(i) \ 256) And &HFF
        bc(i) = mcolor_RGB(i) And &HFF
        yc(i) = 0.299 * rc(i) + 0.587 * gc(i) + 0.114 * bc(i)
        uc(i) = -0.1687 * rc(i) - 0.3313 * gc(i) + 0.5 * bc(i) + 128
        vc(i) = 0.5 * rc(i) - 0.4187 * gc(i) - 0.0813 * bc(i) + 128
    Next i
    
    For i = 0 To WW - 1
        For j = 0 To HH - 1
            If Data(i, j) <> MASKCOLOR Then
                vmin = 100000#
                rr = Data(i, j) And &HFF
                gg = (Data(i, j) \ 256) And &HFF
                bb = (Data(i, j) \ 65536) And &HFF
                yy = 0.299 * rr + 0.587 * gg + 0.114 * bb
                uu = -0.1687 * rr - 0.3313 * gg + 0.5 * bb + 128
                vv = 0.5 * rr - 0.4187 * gg - 0.0813 * bb + 128
                
                For c = 0 To 255
                    v = 2 * (yy - yc(c)) ^ 2 + (uu - uc(c)) ^ 2 + (vv - vc(c)) ^ 2
                    If v < vmin Then
                        vmin = v
                        nn = c
                    End If
                Next c
                Data(i, j) = RGB(rc(nn), gc(nn), bc(nn))
            End If
        Next j
    Next i
    Me.MousePointer = vbDefault
    ShowData
End Sub

Private Sub cmdConvert2_Click()
Dim i As Long, j As Long
Dim c As Long
Dim rr As Long, gg As Long, bb As Long
Dim rc(255) As Long, gc(255) As Long, bc(255) As Long
Dim vmin As Long, v As Long
Dim nn As Long
    Me.MousePointer = vbHourglass
    For i = 0 To 255
        rc(i) = (mcolor_RGB(i) \ 65536) And &HFF
        gc(i) = (mcolor_RGB(i) \ 256) And &HFF
        bc(i) = mcolor_RGB(i) And &HFF
    Next i
    
    For i = 0 To WW - 1
        For j = 0 To HH - 1
            If Data(i, j) <> MASKCOLOR Then
                vmin = 100000#
                rr = Data(i, j) And &HFF
                gg = (Data(i, j) \ 256) And &HFF
                bb = (Data(i, j) \ 65536) And &HFF
                
                For c = 0 To 255
                    v = (rc(c) - rr) ^ 2 + (bb - bc(c)) ^ 2 + (gg - gc(c)) ^ 2
                    If v < vmin Then
                        vmin = v
                        nn = c
                    End If
                Next c
                Data(i, j) = RGB(rc(nn), gc(nn), bc(nn))
            End If
        Next j
    Next i
    Me.MousePointer = vbDefault
    ShowData
End Sub

Private Sub cmdCopy_Click()
    Clipboard.Clear
    Clipboard.SetData Pic1.Image, vbCFBitmap
End Sub

Private Sub cmdok_Click()
    Yes = 1
    SavePic
    Me.Hide
End Sub

Private Sub cmdPaste_Click()
Dim i As Long, j As Long
Dim picdata As New StdPicture
    Set picdata = Clipboard.GetData
    Picbak.Width = ScaleX(picdata.Width, vbHimetric, vbPixels)
    Picbak.height = ScaleY(picdata.height, vbHimetric, vbPixels)
    WW = Picbak.Width
    HH = Picbak.height
    txtwidth.Text = WW
    txtHeight.Text = HH
    ReDim Data(WW - 1, HH - 1)
    Picbak.Picture = picdata
    For j = 0 To HH - 1
        For i = 0 To WW - 1
            Data(i, j) = Picbak.Point(i, j)
        Next i
    Next j
    ShowData
End Sub

Private Sub cmdSet_Click()
Dim i As Long, j As Long
    For i = 0 To WW - 1
        For j = 0 To HH - 1
            If Data(i, j) = ShapeColor.FillColor Then
                Data(i, j) = MASKCOLOR
            End If
        Next j
    Next i
    ShowData
        
End Sub

Private Sub cmdTrans_Click()
    ShapeColor.FillColor = MASKCOLOR
End Sub

Private Sub Cmdwh_Click()
Dim w As Long, h As Long
Dim i As Long, j As Long
    On Error GoTo Label1
    w = txtwidth.Text
    h = txtHeight.Text
    Picbak.Width = w
    Picbak.height = h
    Picbak.ForeColor = MASKCOLOR
    For j = 0 To HH - 1
        For i = 0 To WW - 1
            Picbak.PSet (i, j), Data(i, j)
        Next i
    Next j
    WW = w
    HH = h
    ReDim Data(WW - 1, HH - 1)
    For j = 0 To HH - 1
        For i = 0 To WW - 1
            Data(i, j) = Picbak.Point(i, j)
        Next i
    Next j
    
    ShowData
Exit Sub
Label1:
   txtwidth.Text = WW
   txtHeight.Text = HH

End Sub

Private Sub ComboScale_click()
Dim Index As Long
Dim i As Long, j As Long
    Index = ComboScale.Text
    If Index < 1 Then Exit Sub
    picScale = Index
    
    If picScale * WW > PicLarge.Width Then
        HScroll1.Min = 0
        HScroll1.Max = picScale * WW - PicLarge.Width
        HScroll1.LargeChange = 5 * picScale
        HScroll1.SmallChange = picScale
        HScroll1.value = 0
    Else
        HScroll1.Min = 0
        HScroll1.Max = 0
    End If
    If picScale * HH > PicLarge.height Then
        VScroll1.Min = 0
        VScroll1.Max = picScale * HH - PicLarge.height
        VScroll1.LargeChange = 5 * picScale
        VScroll1.SmallChange = 1 * picScale
        VScroll1.value = 0
    Else
        VScroll1.Min = 0
        VScroll1.Max = 0
    End If
    
    ShowData
End Sub

Private Sub Form_Load()
Dim i As Long, j As Long
Dim rr As Long, gg As Long, bb As Long

    Me.Caption = StrUnicode(Me.Caption)
    For i = 0 To Me.Controls.Count - 1
        Call SetCaption(Me.Controls(i))
    Next i
    Yes = 0
    
    For j = 0 To 15
        For i = 0 To 15
            rr = (mcolor_RGB(i + j * 16) \ 65536) And &HFF&
            gg = (mcolor_RGB(i + j * 16) \ 256) And &HFF
            bb = mcolor_RGB(i + j * 16) And &HFF
            
            PicPalette.Line (i * 16, j * 16)-((i + 1) * 16, (j + 1) * 16), RGB(rr, gg, bb), BF
        Next i
    Next j
    
    
    
End Sub

Public Sub Showpic()
Dim temp As Long
Dim dib As New clsDIB
Dim i As Long, j As Long
    WW = g_PP.Width
    HH = g_PP.height
    txtwidth.Text = WW
    txtHeight.Text = HH
    txtX.Text = g_PP.X
    txtY.Text = g_PP.Y
    
    If WW > 0 And HH > 0 Then
        ReDim Data(WW - 1, HH - 1)
        
        Picbak.Width = WW
        Picbak.height = HH
        dib.CreateDIB WW, HH
        Picbak.BackColor = MASKCOLOR
        temp = BitBlt(dib.CompDC, 0, 0, WW, HH, Picbak.hdc, 0, 0, &HCC0020)
        
        Call genPicData(g_PP, dib.addr, WW, HH, 0, 0)
            ' 复制到dib上
        temp = BitBlt(Picbak.hdc, 0, 0, WW, HH, dib.CompDC, 0, 0, &HCC0020)
        
        For j = 0 To HH - 1
            For i = 0 To WW - 1
                Data(i, j) = Picbak.Point(i, j)
            Next i
        Next j
    End If
        ComboScale.ListIndex = 0

End Sub


Private Sub ShowData()
Dim i As Long, j As Long
    If WW = 0 Or HH = 0 Then Exit Sub
    Picbak.BackColor = MASKCOLOR
    Picbak.Width = WW
    Picbak.height = HH
    For j = 0 To HH - 1
        For i = 0 To WW - 1
            Picbak.PSet (i, j), Data(i, j)
        Next i
    Next j

    Pic1.BackColor = MASKCOLOR
    For j = 0 To HH - 1
        For i = 0 To WW - 1
            Pic1.PSet (i, j), Data(i, j)
            Picbak.PSet (i, j), Data(i, j)
        Next i
    Next j
    
    If chkOffset.value = 1 Then
        Pic1.Line (txtX.Text, txtY.Text - 10)-(txtX.Text, txtY.Text + 10), vbRed
        Pic1.Line (txtX.Text - 10, txtY.Text)-(txtX.Text + 10, txtY.Text), vbRed
    
    End If
    
    PicLarge.BackColor = vbBlack
'    For j = 0 To HH - 1
'        For i = 0 To WW - 1
'            PicLarge.Line (i * picScale - HScroll1.value, j * picScale - VScroll1.value)-((i + 1) * picScale - HScroll1.value, (j + 1) * picScale - VScroll1.value), Data(i, j), BF
 '       Next i
 '   Next j
        
    PicLarge.PaintPicture Picbak.Image, 0, 0, WW * picScale - HScroll1.value, HH * picScale - VScroll1.value, HScroll1.value / picScale, VScroll1.value / picScale, WW - HScroll1.value / picScale, HH - VScroll1.value / picScale
        
End Sub



Private Sub HScroll1_Change()
    ShowData
End Sub


Private Sub PicLarge_MouseDown(Button As Integer, Shift As Integer, X As Single, Y As Single)
Dim i As Long, j As Long
    i = (HScroll1.value + X) \ picScale
    j = (VScroll1.value + Y) \ picScale
    lblxy.Caption = i & "," & j
    If i >= WW Or j >= HH Then Exit Sub
If Button = vbLeftButton Then
    ShapeColor.FillColor = Data(i, j)
ElseIf Button = vbRightButton Then
    Data(i, j) = ShapeColor.FillColor
End If
    ShowData

End Sub

Private Sub PicLarge_MouseMove(Button As Integer, Shift As Integer, X As Single, Y As Single)
Dim i As Long, j As Long
    i = (HScroll1.value + X) \ picScale
    j = (VScroll1.value + Y) \ picScale
    If i >= WW Or j >= HH Then Exit Sub
    lblxy.Caption = i & "," & j
End Sub

Private Sub PicPalette_MouseDown(Button As Integer, Shift As Integer, X As Single, Y As Single)
Dim rr As Long, gg As Long, bb As Long
Dim color As Long
    color = (X \ 16) + (Y \ 16) * 16
            rr = (mcolor_RGB(color) \ 65536) And &HFF&
            gg = (mcolor_RGB(color) \ 256) And &HFF
            bb = mcolor_RGB(color) And &HFF

    ShapeColor.FillColor = RGB(rr, gg, bb)

End Sub


Private Sub VScroll1_Change()
    ShowData
End Sub


Private Sub SavePic()
Dim i As Long, j As Long
Dim k As Long
Dim tmpbyte(1000) As Byte
Dim num As Long
Dim maskNum As Long
Dim solidNum As Long
Dim status As Long
Dim p As Long
    cmdConvert_Click
    g_PP.Width = WW
    g_PP.height = HH
    If WW = 0 And HH = 0 Then
        g_PP.isEmpty = True
        Exit Sub
    End If
    
    g_PP.X = txtX.Text
    g_PP.Y = txtY.Text
    ReDim g_PP.Data(0)
    p = 0
    For j = 0 To HH - 1
        num = 0
        i = 0
        Do
            maskNum = 0
            Do
               If Data(i, j) <> MASKCOLOR Then Exit Do
               i = i + 1
               maskNum = maskNum + 1
               If i >= WW Then Exit Do
            Loop
            If i >= WW Then
                Exit Do
            End If
            solidNum = 0
            tmpbyte(num) = maskNum
            Do
                If Data(i, j) = MASKCOLOR Then Exit Do
                If i >= WW Then Exit Do
                tmpbyte(num + 2 + solidNum) = get256(Data(i, j))
                i = i + 1
                solidNum = solidNum + 1
                If i >= WW Then Exit Do
                
            Loop
            tmpbyte(num + 1) = solidNum
            num = num + solidNum + 2
            If i >= WW Then Exit Do
        Loop
        ReDim Preserve g_PP.Data(p + num)
        g_PP.Data(p) = num
        For i = 0 To num - 1
            g_PP.Data(p + i + 1) = tmpbyte(i)
        Next i
        p = p + num + 1
    Next j
    g_PP.DataLong = p
    Call RLEto32(g_PP)
End Sub


Private Function get256(d As Long) As Byte
Dim i As Long
Dim rr As Long, gg As Long, bb As Long
Dim r2 As Long, g2 As Long, b2 As Long
            
    b2 = (d \ 65536) And &HFF&
    g2 = (d \ 256) And &HFF
    r2 = d And &HFF
    For i = 0 To 255
        rr = (mcolor_RGB(i) \ 65536) And &HFF&
        gg = (mcolor_RGB(i) \ 256) And &HFF
        bb = mcolor_RGB(i) And &HFF
        If r2 = rr And g2 = gg And b2 = bb Then
            get256 = i
            Exit For
        End If
    Next i
End Function
