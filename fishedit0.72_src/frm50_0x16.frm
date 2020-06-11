VERSION 5.00
Begin VB.Form frm50_0x16 
   Caption         =   "50指令16"
   ClientHeight    =   4500
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
   ScaleHeight     =   4500
   ScaleWidth      =   9690
   StartUpPosition =   2  '屏幕中心
   Begin VB.TextBox txtNote 
      Appearance      =   0  'Flat
      BackColor       =   &H80000013&
      BorderStyle     =   0  'None
      ForeColor       =   &H00FF0000&
      Height          =   1215
      Left            =   240
      Locked          =   -1  'True
      MultiLine       =   -1  'True
      TabIndex        =   11
      Text            =   "frm50_0x16.frx":0000
      Top             =   2760
      Width           =   6375
   End
   Begin fishedit.UserVar2 UserI 
      Height          =   1215
      Left            =   2160
      TabIndex        =   10
      Top             =   1200
      Width           =   2055
      _ExtentX        =   3625
      _ExtentY        =   2355
   End
   Begin fishedit.UserVar2 UserID 
      Height          =   1215
      Left            =   0
      TabIndex        =   9
      Top             =   1200
      Width           =   1935
      _ExtentX        =   3413
      _ExtentY        =   2143
   End
   Begin fishedit.userVar userValue 
      Height          =   1215
      Left            =   5040
      TabIndex        =   6
      Top             =   1200
      Width           =   1935
      _ExtentX        =   3413
      _ExtentY        =   2778
   End
   Begin VB.ComboBox ComboType 
      Height          =   345
      Left            =   1320
      Style           =   2  'Dropdown List
      TabIndex        =   2
      Top             =   120
      Width           =   2775
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
   Begin VB.Label Label7 
      Caption         =   "="
      Height          =   375
      Left            =   4440
      TabIndex        =   8
      Top             =   1200
      Width           =   495
   End
   Begin VB.Label Label6 
      Caption         =   "属性值X"
      Height          =   375
      Left            =   5040
      TabIndex        =   7
      Top             =   720
      Width           =   1095
   End
   Begin VB.Label Label5 
      Caption         =   "属性偏移I"
      Height          =   375
      Left            =   2280
      TabIndex        =   5
      Top             =   720
      Width           =   1095
   End
   Begin VB.Label Label4 
      Caption         =   "属性编号ID"
      Height          =   375
      Left            =   240
      TabIndex        =   4
      Top             =   720
      Width           =   1095
   End
   Begin VB.Label Label3 
      Caption         =   "属性类别"
      Height          =   255
      Left            =   120
      TabIndex        =   3
      Top             =   120
      Width           =   1095
   End
End
Attribute VB_Name = "frm50_0x16"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Option Explicit
Dim Index As Long
Dim kk As Statement
Dim OffsetName As Collection

 

Private Sub cmdcancel_Click()
    Unload Me
End Sub

Private Sub cmdok_Click()
 
    kk.Data(1) = UserID.Value + UserI.Value * 2 + userValue.Value * 4
    kk.Data(2) = ComboType.ListIndex
    kk.Data(3) = UserID.Text
    kk.Data(4) = UserI.Text
    kk.Data(5) = userValue.Text
    kk.Data(6) = 0

    
    Unload Me
    
End Sub

 

 

 


' 读取属性偏移参数
' i 属性种类
Private Sub SetOffsetName(i As Long)
Dim j As Long
Dim num As Long
Dim tmparray() As String
Dim offset As Long
Dim Name As String
Dim numBYte As Long
    num = GetINILong("R_Modify", "TypedataItem" & i)
    offset = 0
    Set OffsetName = Nothing
    Set OffsetName = New Collection

    For j = 0 To num - 1
        tmparray = Split(SubSpace(GetINIStr("R_Modify", "Data(" & i & "," & j & ")")), " ")
        Name = tmparray(6)
        numBYte = CLng(tmparray(2))
        OffsetName.Add offset & ":" & Name, "ID" & offset
        offset = offset + numBYte
    Next j
    

End Sub


Private Sub ComboType_click()
Dim i As Long
    UserID.Clear
    Select Case ComboType.ListIndex
    Case 0
        For i = 0 To PersonNum - 1
            UserID.AddItem i & ":" & Person(i).Name1
        Next i
        
    Case 1
        For i = 0 To Thingsnum - 1
            UserID.AddItem i & ":" & Things(i).Name1
        Next i
    
    
    Case 2
        For i = 0 To Scenenum - 1
            UserID.AddItem i & ":" & Big5toUnicode(Scene(i).Name1, 10)
        Next i
    
    Case 3
        For i = 0 To WuGongnum - 1
            UserID.AddItem i & ":" & WuGong(i).Name1
        Next i
    Case 4
        
    End Select
    
    Call SetOffsetName(ComboType.ListIndex + 1)
    UserI.Clear
    UserI.AddItem StrUnicode2("=未定义属性偏移=")
    For i = 1 To OffsetName.Count
        UserI.AddItem OffsetName.Item(i)
    Next i
    
End Sub

Private Sub Form_Load()
Dim num50 As Long
Dim i As Long
Dim s1 As String
    Call ConvertForm(Me)
    
    
    Index = frmmain.listkdef.ListIndex
    Set kk = KdefInfo(frmmain.Combokdef.ListIndex).kdef.Item(Index + 1)

    ComboType.Clear
    For i = 1 To 5
        s1 = GetINIStr("R_Modify", "TypeName" & i)
        ComboType.AddItem s1
    Next i
    
    ComboType.ListIndex = kk.Data(2)
    
    
    
    
    
    UserID.Text = kk.Data(3)
    UserID.Value = IIf((kk.Data(1) And &H1) > 0, 1, 0)
    UserI.Value = IIf((kk.Data(1) And &H2) > 0, 1, 0)
    userValue.Value = IIf((kk.Data(1) And &H4) > 0, 1, 0)
    
    UserID.SetCombo

    UserI.Text = kk.Data(4)
    UserI.SetCombo
        
    userValue.Text = kk.Data(5)
    userValue.SetCombo

    Call Set50Form(Me, kk.Data(0))
 
End Sub

 

