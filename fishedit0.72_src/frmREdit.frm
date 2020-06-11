VERSION 5.00
Begin VB.Form frmREdit 
   Caption         =   "Form1"
   ClientHeight    =   6975
   ClientLeft      =   60
   ClientTop       =   345
   ClientWidth     =   10485
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
   ScaleHeight     =   465
   ScaleMode       =   3  'Pixel
   ScaleWidth      =   699
   WindowState     =   2  'Maximized
   Begin VB.CommandButton Command1 
      Caption         =   "退出"
      Height          =   375
      Left            =   8880
      TabIndex        =   11
      Top             =   600
      Width           =   1335
   End
   Begin VB.TextBox Text1 
      Height          =   330
      Left            =   2160
      TabIndex        =   10
      Text            =   "Text1"
      Top             =   600
      Width           =   735
   End
   Begin VB.CommandButton cmdDelete 
      Caption         =   "Delete"
      Height          =   375
      Left            =   7320
      TabIndex        =   7
      Top             =   600
      Width           =   1335
   End
   Begin VB.CommandButton CmdAdd 
      Caption         =   "Add"
      Height          =   375
      Left            =   5880
      TabIndex        =   6
      Top             =   600
      Width           =   1335
   End
   Begin VB.CommandButton cmdSaveRecord 
      Caption         =   "save"
      Height          =   375
      Left            =   7320
      TabIndex        =   5
      Top             =   120
      Width           =   1335
   End
   Begin VB.CommandButton cmdLoadRecord 
      Caption         =   "read"
      Height          =   375
      Left            =   5880
      TabIndex        =   4
      Top             =   120
      Width           =   1335
   End
   Begin VB.ComboBox ComboNumber 
      Height          =   345
      Left            =   2640
      Style           =   2  'Dropdown List
      TabIndex        =   3
      Top             =   120
      Width           =   3015
   End
   Begin VB.ComboBox ComboRecord 
      Height          =   345
      Left            =   8760
      Style           =   2  'Dropdown List
      TabIndex        =   2
      Top             =   120
      Width           =   1455
   End
   Begin VB.ComboBox ComboType 
      Height          =   345
      Left            =   120
      Style           =   2  'Dropdown List
      TabIndex        =   1
      Top             =   120
      Width           =   2175
   End
   Begin VB.ListBox ListItem 
      Columns         =   3
      BeginProperty Font 
         Name            =   "宋体"
         Size            =   9
         Charset         =   0
         Weight          =   400
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Height          =   6000
      Left            =   0
      TabIndex        =   0
      ToolTipText     =   "双击修改"
      Top             =   960
      Width           =   10455
   End
   Begin VB.Label Label2 
      Caption         =   "Label2"
      Height          =   255
      Left            =   1200
      TabIndex        =   9
      Top             =   600
      Width           =   1095
   End
   Begin VB.Label Label1 
      Caption         =   "Label1"
      Height          =   255
      Left            =   120
      TabIndex        =   8
      Top             =   600
      Width           =   975
   End
End
Attribute VB_Name = "frmREdit"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Option Explicit

'Private AllRIDX() As String
'Private ALLRGRP() As String
'Private AllRNote() As String

Private TypeNumber As Long

'Private TypeName() As String
Private TypeDataItem() As Long


Private Type DataItem_type
    ByteNum As Long
    isStr As Long
    isName As Long
    Ref As Long
    Name As String
    note As String
    offset As Long
End Type

Private Type Data_type
    Int As Integer
    Str As String
End Type


Private Type TypeData_Type
    Name As String
    ItemNumber As Long
    DataItem() As DataItem_type
    DataNumber As Long
    DataV() As Data_type
    DataName() As String
    
End Type

Private TypeData() As TypeData_Type




Private Sub Load_R_Type()
Dim i As Long
Dim j As Long
Dim k As Long
Dim ll As Long
Dim num As Long
Dim tmpstr() As String
Dim tmpstr2() As String
Dim NumArray As Long
Dim NumType As Long

    TypeNumber = GetINILong("R_Modify", "TypeNumber")
    ReDim TypeData(TypeNumber - 1)
    
    ReDim TypeDataItem(TypeNumber - 1)
    For i = 0 To TypeNumber - 1
        TypeData(i).Name = GetINIStr("R_Modify", "TypeName" & i)
        TypeDataItem(i) = GetINILong("R_Modify", "TypeDataItem" & i)
    Next i
    
    For i = 0 To TypeNumber - 1
        num = 0
        For j = 0 To TypeDataItem(i) - 1
            tmpstr = Split(SubSpace(GetINIStr("R_Modify", "Data(" & i & "," & j & ")")), " ")
            num = num + CLng(tmpstr(0)) * CLng(tmpstr(1))
        Next j
        TypeData(i).ItemNumber = num
        ReDim TypeData(i).DataItem(num - 1)
        num = 0
        j = 0
        Do While j < TypeDataItem(i)
            tmpstr = Split(SubSpace(GetINIStr("R_Modify", "Data(" & i & "," & j & ")")), " ")
            NumArray = CLng(tmpstr(0))
            NumType = CLng(tmpstr(1))
            For k = 1 To NumArray
                TypeData(i).DataItem(num).ByteNum = CLng(tmpstr(2))
                TypeData(i).DataItem(num).isStr = CLng(tmpstr(3))
                TypeData(i).DataItem(num).isName = CLng(tmpstr(4))
                TypeData(i).DataItem(num).Ref = CLng(tmpstr(5))
                TypeData(i).DataItem(num).Name = tmpstr(6) & IIf(NumArray > 1, k, "")
                TypeData(i).DataItem(num).note = (tmpstr(7))
                num = num + 1
                For ll = 2 To NumType
                    tmpstr2 = Split(SubSpace(GetINIStr("R_Modify", "Data(" & i & "," & j + ll - 1 & ")")), " ")
                    TypeData(i).DataItem(num).ByteNum = CLng(tmpstr2(2))
                    TypeData(i).DataItem(num).isStr = CLng(tmpstr2(3))
                    TypeData(i).DataItem(num).isName = CLng(tmpstr2(4))
                    TypeData(i).DataItem(num).Ref = CLng(tmpstr2(5))
                    TypeData(i).DataItem(num).Name = tmpstr2(6) & IIf(NumArray > 1, k, "")
                    TypeData(i).DataItem(num).note = tmpstr2(7)
                    num = num + 1
                Next ll
            Next k
            j = j + NumType
        Loop
    Next i
    
End Sub



Private Sub Load_R()
Dim i As Long
Dim j As Long
Dim k As Long
Dim filenum As Long
Dim Idx() As Long
Dim DataLong As Long
Dim offset As Long
Dim tmpbyte() As Byte
    ReDim Idx(TypeNumber)
    Idx(0) = 0
    filenum = OpenBin(G_Var.JYPath & G_Var.RIDX(ComboRecord.ListIndex), "R")
    For i = 1 To TypeNumber
        Get #filenum, , Idx(i)
    Next i
    Close #filenum
    
    filenum = OpenBin(G_Var.JYPath & G_Var.RGRP(ComboRecord.ListIndex), "R")
    
    
    For i = 0 To TypeNumber - 1
        DataLong = 0
        For j = 0 To TypeData(i).ItemNumber - 1
            DataLong = DataLong + TypeData(i).DataItem(j).ByteNum
        Next j
        If (Idx(i + 1) - Idx(i)) Mod DataLong <> 0 Then
            Err.Raise vbObjectError + 1, , "R* data format error" & i
        Else
            TypeData(i).DataNumber = (Idx(i + 1) - Idx(i)) / DataLong
        End If
        ReDim TypeData(i).DataV(TypeData(i).ItemNumber - 1, TypeData(i).DataNumber - 1)
        ReDim TypeData(i).DataName(TypeData(i).DataNumber - 1)
        offset = Idx(i)
        Seek #filenum, offset + 1
        For j = 0 To TypeData(i).DataNumber - 1
            For k = 0 To TypeData(i).ItemNumber - 1
                If TypeData(i).DataItem(k).isStr = 0 Then
                    Get #filenum, , TypeData(i).DataV(k, j).Int
                Else
                    ReDim tmpbyte(TypeData(i).DataItem(k).ByteNum - 1)
                    Get #filenum, , tmpbyte
                    TypeData(i).DataV(k, j).Str = Big5toUnicode(tmpbyte, TypeData(i).DataItem(k).ByteNum)
                End If
                If TypeData(i).DataItem(k).isName = 1 Then
                    TypeData(i).DataName(j) = TypeData(i).DataV(k, j).Str
                End If
            Next k
        Next j
    Next i
    
    Close #filenum
    
    ComboType.Clear
    For i = 0 To TypeNumber - 1
        ComboType.AddItem TypeData(i).Name
    Next i
    ComboType.ListIndex = 0

End Sub

Private Sub CmdAdd_Click()
Dim Index As Long
Dim CurrentID As Long
Dim i As Long
Dim tmpstr As String
    Index = ComboType.ListIndex
    If Index < 0 Then Exit Sub
    CurrentID = ComboNumber.ListIndex
    If CurrentID < 0 Then Exit Sub
    tmpstr = LoadResStr(10509) & Trim(TypeData(Index).Name) & " (" & LoadResStr(10511) & ")?"
    
    If MsgBox(tmpstr, vbYesNo, Me.Caption) = vbYes Then
        TypeData(Index).DataNumber = TypeData(Index).DataNumber + 1
        ReDim Preserve TypeData(Index).DataV(TypeData(Index).ItemNumber - 1, TypeData(Index).DataNumber - 1)
        ReDim Preserve TypeData(Index).DataName(TypeData(Index).DataNumber - 1)
        For i = 0 To TypeData(Index).ItemNumber - 1
            TypeData(Index).DataV(i, TypeData(Index).DataNumber - 1) = TypeData(Index).DataV(i, CurrentID)
        Next i
        TypeData(Index).DataName(TypeData(Index).DataNumber - 1) = TypeData(Index).DataName(CurrentID)
            
        ComboType_click
        ComboNumber.ListIndex = TypeData(Index).DataNumber - 1

    End If
    
    
End Sub

Private Sub cmdDelete_Click()
Dim Index As Long
Dim CurrentID As Long
Dim i As Long
    Index = ComboType.ListIndex
    If Index < 0 Then Exit Sub
    CurrentID = ComboNumber.ListIndex
    If CurrentID < 0 Then Exit Sub
    
    If MsgBox(LoadResStr(10510) & TypeData(Index).Name, vbYesNo, Me.Caption) = vbYes Then
        TypeData(Index).DataNumber = TypeData(Index).DataNumber - 1
        ReDim Preserve TypeData(Index).DataV(TypeData(Index).ItemNumber - 1, TypeData(Index).DataNumber - 1)
        ReDim Preserve TypeData(Index).DataName(TypeData(Index).DataNumber - 1)
    End If
    
    ComboType_click
    ComboNumber.ListIndex = 0
    
    
End Sub

Private Sub cmdLoadRecord_Click()
    Load_R
End Sub

Private Sub cmdSaveRecord_Click()
Dim Idx() As Long
Dim i As Long, j As Long, k As Long
Dim filenum As Long
Dim tmpbyte() As Byte
Dim length As Long

    If ComboRecord.ListIndex = -1 Then Exit Sub
    ReDim Idx(TypeNumber)
    Idx(0) = 0
    filenum = OpenBin(G_Var.JYPath & G_Var.RGRP(ComboRecord.ListIndex), "W")
    For i = 0 To TypeNumber - 1
        For j = 0 To TypeData(i).DataNumber - 1
            For k = 0 To TypeData(i).ItemNumber - 1
                If TypeData(i).DataItem(k).isStr = 0 Then
                    Put #filenum, , TypeData(i).DataV(k, j).Int
                Else
                    Call UnicodetoBIG5(TypeData(i).DataV(k, j).Str, length, tmpbyte)
                    ReDim Preserve tmpbyte(TypeData(i).DataItem(k).ByteNum - 1)
                    Put #filenum, , tmpbyte
                End If
            Next k
        Next j
        Idx(i + 1) = Loc(filenum)
    Next i
    Close #filenum
    
    filenum = OpenBin(G_Var.JYPath & G_Var.RIDX(ComboRecord.ListIndex), "W")
    For i = 1 To TypeNumber
        Put #filenum, , Idx(i)
    Next i
    Close #filenum
    
    ReadRR
        
   
    
    
End Sub

Private Sub ComboNumber_click()
Dim typeN As Long
Dim Index As Long
Dim i As Long
Dim tmpstr As String
    Index = ComboNumber.ListIndex
    If Index = -1 Then Exit Sub
    typeN = ComboType.ListIndex
    If typeN = -1 Then Exit Sub
    ListItem.Clear

    For i = 0 To TypeData(typeN).ItemNumber - 1

        
        ListItem.AddItem GenListstr(typeN, Index, i)
    Next i
    ListItem.ListIndex = 0
End Sub

' 生成list字符串
' i type    j   datanumber     k itemnumber
Private Function GenListstr(i As Long, j As Long, k As Long) As String
Dim tmpstr As String
Dim ll As Long
        tmpstr = TypeData(i).DataItem(k).Name
        ll = LenB(StrConv(TypeData(i).DataItem(k).Name, vbFromUnicode))
         If ll < 18 Then
            tmpstr = tmpstr & Space(15 - ll)
         End If
        
        If TypeData(i).DataItem(k).isStr = 1 Then
            tmpstr = tmpstr & TypeData(i).DataV(k, j).Str
        Else
            tmpstr = tmpstr & FMT(TypeData(i).DataV(k, j).Int, 6)
        End If
        
        
        If TypeData(i).DataItem(k).Ref >= 0 And TypeData(i).DataV(k, j).Int >= 0 Then
            tmpstr = tmpstr & " " & TypeData(TypeData(i).DataItem(k).Ref).DataName(TypeData(i).DataV(k, j).Int)
        End If
    GenListstr = tmpstr
End Function


Private Sub ComboType_click()
Dim Index As Long
Dim i As Long
    Index = ComboType.ListIndex
    If Index = -1 Then Exit Sub
    
    ComboNumber.Clear
    For i = 0 To TypeData(Index).DataNumber - 1
        ComboNumber.AddItem i & TypeData(Index).DataName(i)
    Next i
    ComboNumber.ListIndex = 0

End Sub

Private Sub Command1_Click()
End
End Sub

Private Sub Form_Load()
Dim i As Long
    Me.Caption = LoadResStr(224)
    cmdLoadRecord.Caption = LoadResStr(10501)
    cmdSaveRecord.Caption = LoadResStr(10502)
    
    CmdAdd.Caption = LoadResStr(10507)
    cmdDelete.Caption = LoadResStr(10508)
    
    ComboRecord.Clear
    For i = 0 To 3
        ComboRecord.AddItem G_Var.RecordNote(i)
    Next i
    
    ComboRecord.ListIndex = 1
    
    Load_R_Type
    Load_R
    Text1.Text = ""
    Command1.Caption = StrUnicode2("退出")
End Sub

Private Sub ListItem_Click()
Dim i As Long, j As Long, k As Long
    i = ComboType.ListIndex
    j = ComboNumber.ListIndex
    k = ListItem.ListIndex
    If i < 0 Or j < 0 Or k < 0 Then Exit Sub
    MDIMain.StatusBar1.Panels(1).Text = TypeData(i).DataItem(k).note
    
Dim num As Long
    i = ComboType.ListIndex
    j = ComboNumber.ListIndex
    k = ListItem.ListIndex
    If i < 0 Or j < 0 Or k < 0 Then Exit Sub
    Load frmChangeRValue
    
    Label1.Caption = TypeData(i).DataItem(k).Name
    If TypeData(i).DataItem(k).isStr = 0 Then
       Label2.Caption = TypeData(i).DataV(k, j).Int
    Else
       Label2.Caption = TypeData(i).DataV(k, j).Str
    End If
End Sub

Private Sub ListItem_DblClick()
Dim i As Long, j As Long, k As Long
Dim num As Long
    i = ComboType.ListIndex
    j = ComboNumber.ListIndex
    k = ListItem.ListIndex
    If i < 0 Or j < 0 Or k < 0 Then Exit Sub
    Load frmChangeRValue
    
    frmChangeRValue.Label1.Caption = TypeData(i).DataItem(k).Name
    If TypeData(i).DataItem(k).isStr = 0 Then
        frmChangeRValue.Text1.Text = TypeData(i).DataV(k, j).Int
    Else
        frmChangeRValue.Text1.Text = TypeData(i).DataV(k, j).Str
    End If
    If TypeData(i).DataItem(k).Ref >= 0 Then
        frmChangeRValue.Combo1.Clear
        frmChangeRValue.Combo1.AddItem LoadResStr(10602)
        For num = 0 To TypeData(TypeData(i).DataItem(k).Ref).DataNumber - 1
            frmChangeRValue.Combo1.AddItem num & TypeData(TypeData(i).DataItem(k).Ref).DataName(num)
        Next num
        frmChangeRValue.Combo1.ListIndex = TypeData(i).DataV(k, j).Int + 1
        frmChangeRValue.Text1.Enabled = False
    Else
        frmChangeRValue.Combo1.Visible = False
    End If
    
    frmChangeRValue.Show vbModal
    
    If frmChangeRValue.OK = 1 Then
        If TypeData(i).DataItem(k).isStr = 0 Then
             TypeData(i).DataV(k, j).Int = frmChangeRValue.Text1.Text
        Else
            TypeData(i).DataV(k, j).Str = frmChangeRValue.Text1.Text
        End If
        
        ListItem.List(k) = GenListstr(i, j, k)
    End If
    
    Unload frmChangeRValue
End Sub

Private Sub Text1_Change()
Dim a As Integer
Dim i As Long, j As Long, k As Long
Dim num As Long
    i = ComboType.ListIndex
    j = ComboNumber.ListIndex
    k = ListItem.ListIndex
a = 0
If Text1.Text <> "-" Then
   
   If IsNumeric(Text1) Then
      If Text1.Text > 32767 Then
       Text1.Text = 32767
       MsgBox "超出", vbOKOnly, "警告"
      
        Else
          
      End If
      Else
         If IsNumeric(Label2) Then
         If Text1.Text = "" Then
         Exit Sub
         End If
            MsgBox "汗~有没有搞错", vbOKOnly, "这个不是"
            Text1.Text = ""
           Else
             
            Exit Sub
         End If
      End If
     End If


End Sub
Private Sub Text1_KeyDown(KeyCode As Integer, Shift As Integer)
Dim i As Long, j As Long, k As Long
Dim num As Long
    i = ComboType.ListIndex
    j = ComboNumber.ListIndex
    k = ListItem.ListIndex
'如果键码＝13就是回车键，就会发生这种事：
If KeyCode = 13 Then
If Text1.Text = "" Then
MsgBox "错误", vbOKOnly, "警告"
Exit Sub
Else
End If
  If TypeData(i).DataItem(k).isStr = 0 Then
             TypeData(i).DataV(k, j).Int = Text1.Text
        Else
            TypeData(i).DataV(k, j).Str = Text1.Text
  End If
ListItem.List(k) = GenListstr(i, j, k)
ListItem.SetFocus
Text1.Text = ""
End If
'如果键码＝17就是ctrl，就会发生这种事：
If KeyCode = 27 Then
  Text1.Text = ""
  ListItem.SetFocus
End If
End Sub
Private Sub ListItem_KeyDown(KeyCode As Integer, Shift As Integer)
'如果键码＝17就是ctrl，就会发生这种事：
If KeyCode = 17 Then
  Text1.Text = ""
  Text1.SetFocus
End If
End Sub


