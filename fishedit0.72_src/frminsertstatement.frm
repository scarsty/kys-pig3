VERSION 5.00
Begin VB.Form frminsertstatement 
   Caption         =   "插入指令"
   ClientHeight    =   2925
   ClientLeft      =   60
   ClientTop       =   345
   ClientWidth     =   9315
   LinkTopic       =   "Form2"
   ScaleHeight     =   2925
   ScaleWidth      =   9315
   StartUpPosition =   2  '屏幕中心
   Begin VB.Frame Frame2 
      Caption         =   "跳转方向"
      Height          =   735
      Left            =   360
      TabIndex        =   7
      Top             =   1920
      Width           =   7095
      Begin VB.OptionButton Option4 
         Caption         =   "向上跳转"
         Height          =   375
         Left            =   4080
         TabIndex        =   9
         Top             =   240
         Width           =   2175
      End
      Begin VB.OptionButton Option3 
         Caption         =   "向下跳转"
         Height          =   375
         Left            =   360
         TabIndex        =   8
         Top             =   240
         Value           =   -1  'True
         Width           =   2175
      End
   End
   Begin VB.Frame Frame1 
      Caption         =   "条件指令转移选择"
      Height          =   735
      Left            =   360
      TabIndex        =   4
      Top             =   1080
      Width           =   7095
      Begin VB.OptionButton Option2 
         Caption         =   "否（条件不满足）跳转"
         Height          =   375
         Left            =   4080
         TabIndex        =   6
         Top             =   240
         Width           =   2535
      End
      Begin VB.OptionButton Option1 
         Caption         =   "是（条件满足）跳转"
         Height          =   375
         Left            =   360
         TabIndex        =   5
         Top             =   240
         Value           =   -1  'True
         Width           =   2415
      End
   End
   Begin VB.CommandButton cmdcancel 
      Caption         =   "取消"
      Height          =   375
      Left            =   7920
      TabIndex        =   3
      Top             =   1200
      Width           =   1095
   End
   Begin VB.CommandButton cmdok 
      Caption         =   "确定"
      Height          =   375
      Left            =   7920
      TabIndex        =   2
      Top             =   360
      Width           =   1095
   End
   Begin VB.ComboBox ComboStatment 
      Height          =   300
      Left            =   480
      Style           =   2  'Dropdown List
      TabIndex        =   0
      Top             =   600
      Width           =   6855
   End
   Begin VB.Label Label1 
      Caption         =   "请选择要插入的指令："
      Height          =   255
      Left            =   240
      TabIndex        =   1
      Top             =   120
      Width           =   2535
   End
End
Attribute VB_Name = "frminsertstatement"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Option Explicit

Private Sub cmdcancel_Click()
    Unload Me
End Sub

Private Sub cmdok_Click()
Dim tmpstat As Statement
Dim labelstat As Statement
Dim Index As Long
    Index = ComboStatment.ListIndex
    If Index < 0 Then Exit Sub
    Set tmpstat = New Statement
    If Index = &H44 Then
        tmpstat.Id = &HFFFF
        tmpstat.DataNum = 0
        KdefInfo(frmmain.Combokdef.ListIndex).kdef.Add tmpstat, , frmmain.listkdef.ListIndex + 1
        Call re_Analysis(frmmain.Combokdef.ListIndex)
        Unload Me
        Exit Sub
    End If
    tmpstat.Id = Index
    tmpstat.DataNum = StatAttrib(Index).length - 1
    If StatAttrib(tmpstat.Id).isGoto = 0 Then
        KdefInfo(frmmain.Combokdef.ListIndex).kdef.Add tmpstat, , frmmain.listkdef.ListIndex + 1
    Else
        If Option3.value = True Then
            tmpstat.yesOffset = StatAttrib(tmpstat.Id).yesOffset
            tmpstat.noOffset = StatAttrib(tmpstat.Id).noOffset
            If Option1.value = True Then
                tmpstat.isGoto = 1
                tmpstat.Data(tmpstat.yesOffset - 1) = 1
            Else
                tmpstat.isGoto = 2
                tmpstat.Data(tmpstat.noOffset - 1) = 1
            End If
            tmpstat.gotoLabel = "Label" & KdefInfo(frmmain.Combokdef.ListIndex).numlabel
            KdefInfo(frmmain.Combokdef.ListIndex).numlabel = KdefInfo(frmmain.Combokdef.ListIndex).numlabel + 1
            KdefInfo(frmmain.Combokdef.ListIndex).kdef.Add tmpstat, , frmmain.listkdef.ListIndex + 1
            Set labelstat = New Statement
            labelstat.islabel = True
            labelstat.note = tmpstat.gotoLabel
            Set tmpstat = New Statement
            tmpstat.Id = 0
            tmpstat.DataNum = 0
            KdefInfo(frmmain.Combokdef.ListIndex).kdef.Add tmpstat, , frmmain.listkdef.ListIndex + 2
            KdefInfo(frmmain.Combokdef.ListIndex).kdef.Add labelstat, , frmmain.listkdef.ListIndex + 3
        Else
            tmpstat.yesOffset = StatAttrib(tmpstat.Id).yesOffset
            tmpstat.noOffset = StatAttrib(tmpstat.Id).noOffset
            If Option1.value = True Then
                tmpstat.isGoto = 1
                tmpstat.Data(tmpstat.yesOffset - 1) = -tmpstat.DataNum - 2
            Else
                tmpstat.isGoto = 2
                tmpstat.Data(tmpstat.noOffset - 1) = -tmpstat.DataNum - 2
            End If
            tmpstat.gotoLabel = "Label" & KdefInfo(frmmain.Combokdef.ListIndex).numlabel
            KdefInfo(frmmain.Combokdef.ListIndex).numlabel = KdefInfo(frmmain.Combokdef.ListIndex).numlabel + 1
            
            Set labelstat = New Statement
            labelstat.islabel = True
            labelstat.note = tmpstat.gotoLabel
            KdefInfo(frmmain.Combokdef.ListIndex).kdef.Add labelstat, , frmmain.listkdef.ListIndex + 1
            Set labelstat = New Statement
            labelstat.Id = 0
            labelstat.DataNum = 0
            KdefInfo(frmmain.Combokdef.ListIndex).kdef.Add labelstat, , frmmain.listkdef.ListIndex + 2
            
            KdefInfo(frmmain.Combokdef.ListIndex).kdef.Add tmpstat, , frmmain.listkdef.ListIndex + 3

        End If
    End If
    Call re_Analysis(frmmain.Combokdef.ListIndex)
    Unload Me
End Sub

Private Sub ComboStatment_click()
Dim Index As Long
    Index = ComboStatment.ListIndex
    If Index < 0 Then Exit Sub
    If Index = &H44 Then Exit Sub
    If StatAttrib(Index).isGoto = 1 Then
        Frame1.Visible = True
    End If
End Sub

Private Sub Form_Load()
Dim i As Long

    Me.Caption = LoadResStr(1001)
    Label1.Caption = LoadResStr(1002)
    
    Frame1.Caption = LoadResStr(1002)
    Option1.Caption = LoadResStr(1004)
    Option2.Caption = LoadResStr(1005)
    cmdok.Caption = LoadResStr(102)
     cmdcancel.Caption = LoadResStr(103)
    
    
    For i = 0 To &H43
        ComboStatment.AddItem i & "(" & Hex(i) & ")：" & StatAttrib(i).notes
    Next i
    ComboStatment.AddItem -1 & "：" & LoadResStr(1006)
    Frame1.Visible = False
End Sub
