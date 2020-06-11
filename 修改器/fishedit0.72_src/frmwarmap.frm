VERSION 5.00
Begin VB.Form frmwarmap 
   AutoRedraw      =   -1  'True
   Caption         =   "Form1"
   ClientHeight    =   7380
   ClientLeft      =   60
   ClientTop       =   345
   ClientWidth     =   11505
   KeyPreview      =   -1  'True
   LinkTopic       =   "Form1"
   ScaleHeight     =   492
   ScaleMode       =   3  'Pixel
   ScaleWidth      =   767
   StartUpPosition =   2  '屏幕中心
   Begin VB.PictureBox pic1 
      AutoRedraw      =   -1  'True
      ForeColor       =   &H000000FF&
      Height          =   7260
      Left            =   0
      ScaleHeight     =   480
      ScaleMode       =   3  'Pixel
      ScaleWidth      =   640
      TabIndex        =   6
      Top             =   0
      Width           =   9660
   End
   Begin VB.CommandButton cmdright 
      Caption         =   "右"
      Height          =   375
      Left            =   10920
      TabIndex        =   5
      Top             =   3120
      Width           =   495
   End
   Begin VB.CommandButton cmdleft 
      Caption         =   "左"
      Height          =   375
      Left            =   9720
      TabIndex        =   4
      Top             =   3120
      Width           =   495
   End
   Begin VB.CommandButton cmddown 
      Caption         =   "下"
      Height          =   375
      Left            =   10320
      TabIndex        =   3
      Top             =   3360
      Width           =   495
   End
   Begin VB.CommandButton cmdup 
      Caption         =   "上"
      Height          =   375
      Left            =   10320
      TabIndex        =   2
      Top             =   2760
      Width           =   495
   End
   Begin VB.TextBox txty 
      Height          =   285
      Left            =   10800
      TabIndex        =   1
      Text            =   "31"
      Top             =   360
      Width           =   495
   End
   Begin VB.TextBox txtX 
      Height          =   285
      Left            =   9960
      TabIndex        =   0
      Text            =   "32"
      Top             =   360
      Width           =   495
   End
   Begin VB.Label Label4 
      Caption         =   "层1"
      Height          =   255
      Left            =   4080
      TabIndex        =   9
      Top             =   360
      Width           =   375
   End
   Begin VB.Label Label2 
      Caption         =   "Y"
      Height          =   255
      Index           =   1
      Left            =   10560
      TabIndex        =   8
      Top             =   360
      Width           =   255
   End
   Begin VB.Label Label2 
      Caption         =   "X"
      Height          =   255
      Index           =   0
      Left            =   9720
      TabIndex        =   7
      Top             =   360
      Width           =   255
   End
End
Attribute VB_Name = "frmwarmap"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Option Explicit


Dim warmapid As Long
Dim warid As Long









Dim SinData(63, 63) As Integer
Dim SinData2(63, 63) As Integer





Private Sub cmddown_Click()
    If txtY < 64 Then
        txtY = txtY + 1
        Command6_Click
    End If
End Sub

Private Sub cmdleft_Click()
   If txtX > 0 Then
       txtX = txtX - 1
       Command6_Click
   End If
End Sub

Private Sub cmdright_Click()
    If txtX < 64 Then
        txtX = txtX + 1
        Command6_Click
    End If
End Sub

Private Sub cmdup_Click()
    If txtY > 0 Then
        txtY = txtY - 1
        Command6_Click
    End If
End Sub










Private Sub LoadWarmap()
    
Dim filename As String
Dim filenum As Integer


Dim i As Long, j As Long
Dim length As Long

Dim sinid(26) As Long

   'filename = G_Var.JYPath & "\warfld.idx"
   
    sinid(0) = 0
    
    'filenum = FreeFile()
    filenum = OpenBin(G_Var.JYPath & G_Var.WarMapDefIDX, "r")
    For i = 1 To 26
        Get filenum, , sinid(i)
    Next i
      
    Close (filenum)


    filenum = OpenBin(G_Var.JYPath & G_Var.WarMapDefGRP, "r")
    Seek #filenum, sinid(warmapid) + 1
    length = sinid(warmapid + 1) - sinid(warmapid)
        Get filenum, , SinData
            Get filenum, , SinData2
    Close (filenum)

    
    
    
End Sub

Private Sub ShowPicDIBn2()
Dim copmDC As Long
Dim binfo As BITMAPINFO
Dim DIBSectionHandle As Long    ' Handle to DIBSection
Dim OldCompDCBM As Long         ' Original bitmap for CompDC
Dim CompDC As Long
Dim addr As Long
Dim temp As Long
Dim lineSize As Long
Dim picdata() As Long

Dim i As Long, j As Long
Dim RangeX As Long, rangeY As Long
Dim x0 As Integer, y0 As Integer

Dim x1 As Long, Y1 As Long
Dim pic As Long
Dim dx As Long, dy As Long
Dim i1 As Long, j1 As Long
    
    
    x0 = txtX.Text
    y0 = txtY.Text
    
    


    CompDC = CreateCompatibleDC(0)
    With binfo.bmiHeader
        .biSize = 40
        .biWidth = 700
        .biHeight = -500
        .biPlanes = 1
        .biBitCount = 32
        .biCompression = 0
        lineSize = .biWidth * 4
        .biSizeImage = -lineSize * .biHeight
    End With
    
    DIBSectionHandle = CreateDIBSection(CompDC, binfo, 0, addr, 0, 0)
    OldCompDCBM = SelectObject(CompDC, DIBSectionHandle)

   
    
    ReDim picdata(binfo.bmiHeader.biSizeImage / 4)
    
    
    RangeX = 18 + 7    ' 保证不出现漏画贴图，把画的范围扩大
    rangeY = 10 + 11    ' 其实有更好的办法可以先判断出应该画哪些
    
    
    
    
    ' 按屏幕坐标，从右向左，从上到下依次画每个贴图，保证贴图正确，
     For j = -rangeY To 2 * RangeX + rangeY
        For i = RangeX To 0 Step -1
            If j Mod 2 = 0 Then
                i1 = -RangeX + i + j \ 2
                j1 = -i + j \ 2
            Else
                i1 = -RangeX + i + j \ 2
                j1 = -i + j \ 2 + 1
            End If
            x1 = XSCALE * (i1 - j1) + 320
            Y1 = YSCALE * (i1 + j1) + 240
            If y0 + j1 >= 0 And x0 + i1 >= 0 And y0 + j1 < 64 And x0 + i1 < 64 Then
                dx = 0
                dy = 0
                pic = SinData(x0 + i1, y0 + j1) / 2
                ' 画1层
                Call genPicData(WarPic(pic), addr, binfo.bmiHeader.biWidth, -binfo.bmiHeader.biHeight, x1 - WarPic(pic).X, Y1 - WarPic(pic).Y)
                 
            End If
        Next i
    Next j
    
    ' 按屏幕坐标，从右向左，从上到下依次画每个贴图，保证贴图正确，
     For j = -rangeY To 2 * RangeX + rangeY
        For i = RangeX To 0 Step -1
            If j Mod 2 = 0 Then
                i1 = -RangeX + i + j \ 2
                j1 = -i + j \ 2
            Else
                i1 = -RangeX + i + j \ 2
                j1 = -i + j \ 2 + 1
            End If
            x1 = XSCALE * (i1 - j1) + 320
            Y1 = YSCALE * (i1 + j1) + 240
            If y0 + j1 >= 0 And x0 + i1 >= 0 And y0 + j1 < 64 And x0 + i1 < 64 Then
                dx = 0
                dy = 0
                 
                ' 画2层
                pic = SinData2(x0 + i1, y0 + j1) / 2
                If pic > 0 And pic < Warpicnum Then
                    Call genPicData(WarPic(pic), addr, binfo.bmiHeader.biWidth, -binfo.bmiHeader.biHeight, x1 - WarPic(pic).X, Y1 - WarPic(pic).Y)
                End If
            End If
        Next i
    Next j
    
    
 
    
    ' 在当前坐标位置贴图
    Call genPicData(WarPic(0), addr, binfo.bmiHeader.biWidth, -binfo.bmiHeader.biHeight, 320 - WarPic(0).X, 240 - WarPic(0).Y)
    
    ' 复制到dib上
    temp = BitBlt(Pic1.hdc, 0, 0, 640, 480, CompDC, 0, 0, &HCC0020)
   
    For i = 0 To 5
        i1 = WarData(warid).personX(i) - x0
        j1 = WarData(warid).personY(i) - y0
        x1 = XSCALE * (i1 - j1) + 320
        Y1 = YSCALE * (i1 + j1) + 240
        Pic1.CurrentX = x1
        Pic1.CurrentY = Y1 - YSCALE
        Pic1.Print i
    Next i
    
    For i = 0 To 19
        If WarData(warid).Enemy(i) >= 0 Then
            i1 = WarData(warid).EnemyX(i) - x0
            j1 = WarData(warid).EnemyY(i) - y0
            x1 = XSCALE * (i1 - j1) + 320
            Y1 = YSCALE * (i1 + j1) + 240
            Pic1.CurrentX = x1
            Pic1.CurrentY = Y1 - YSCALE
            Pic1.Print "E" & i
        End If
    Next i
    
    
    
    
    temp = GetLastError()
    temp = SelectObject(CompDC, OldCompDCBM)
    temp = DeleteDC(CompDC)
    temp = DeleteObject(DIBSectionHandle)

End Sub




Private Sub Command6_Click()
    Pic1.Cls
    Call ShowPicDIBn2

End Sub



Private Sub Form_Load()
Dim fileid As String
Dim filepic As String
    Me.Caption = LoadResStr(10015)
    cmdup.Caption = LoadResStr(10016)
    cmddown.Caption = LoadResStr(10017)
    cmdleft.Caption = LoadResStr(10018)
    cmdright.Caption = LoadResStr(10019)
    
    warmapid = FrmWarEdit.txtMap.Text
    warid = FrmWarEdit.Combowar.ListIndex
    If warid < 0 Then Unload Me
    
    fileid = G_Var.WarMapIDX
    filepic = G_Var.WarMapGrp
    Call LoadPicFile(G_Var.JYPath & fileid, G_Var.JYPath & filepic, WarPic, Warpicnum)
    
    Call LoadWarmap
    Command6_Click
End Sub
