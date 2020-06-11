VERSION 5.00
Begin VB.UserControl UserVar2 
   ClientHeight    =   1125
   ClientLeft      =   0
   ClientTop       =   0
   ClientWidth     =   1980
   BeginProperty Font 
      Name            =   "Times New Roman"
      Size            =   9
      Charset         =   0
      Weight          =   400
      Underline       =   0   'False
      Italic          =   0   'False
      Strikethrough   =   0   'False
   EndProperty
   ScaleHeight     =   1125
   ScaleWidth      =   1980
   Begin VB.CheckBox chkK 
      Caption         =   "变量"
      Height          =   375
      Left            =   0
      TabIndex        =   3
      Top             =   720
      Width           =   1095
   End
   Begin VB.TextBox txtK 
      Height          =   330
      Left            =   0
      TabIndex        =   2
      Text            =   "Text2"
      Top             =   0
      Width           =   1815
   End
   Begin VB.ComboBox ComboK0 
      Height          =   345
      Left            =   0
      TabIndex        =   1
      Text            =   "Combo1"
      Top             =   360
      Width           =   1815
   End
   Begin VB.ComboBox ComboK1 
      Height          =   345
      Left            =   0
      TabIndex        =   0
      Text            =   "Combo1"
      Top             =   360
      Width           =   1815
   End
End
Attribute VB_Name = "UserVar2"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = False
Option Explicit

Private Sub combok0_click()
Dim s As String
Dim id As Long
    If ComboK0.ListIndex >= 0 Then
        s = ComboK0.Text
        id = InStr(s, ":")
        If id > 1 Then
            txtK.Text = CLng(Mid(s, 1, id - 1))
        End If
    End If
End Sub

Private Sub combok1_click()
Dim s As String
Dim id As Long
    If ComboK1.ListIndex > 0 Then
        s = ComboK1.Text
        id = InStr(s, ":")
        If id > 1 Then
            txtK.Text = CLng(Mid(s, 1, id - 1))
        End If
    End If

End Sub

Private Sub chkK_Click()
    If chkK.Value = 1 Then
        ComboK1.Enabled = True
        ComboK1.Visible = True
        ComboK0.Enabled = False
        ComboK0.Visible = False
    Else
        ComboK1.Enabled = False
        ComboK1.Visible = False
        ComboK0.Enabled = True
        ComboK0.Visible = True
    End If
End Sub

'注意！不要删除或修改下列被注释的行！
'MappingInfo=txtK,txtK,-1,Text
Public Property Get Text() As String
Attribute Text.VB_Description = "返回/设置控件中包含的文本。"
    Text = txtK.Text
End Property

Public Property Let Text(ByVal New_Text As String)
    txtK.Text() = New_Text
    PropertyChanged "Text"
End Property

'注意！不要删除或修改下列被注释的行！
'MappingInfo=chkK,chkK,-1,Value
Public Property Get Value() As Integer
Attribute Value.VB_Description = "返回/设置对象的值。"
    Value = chkK.Value
End Property

Public Property Let Value(ByVal New_Value As Integer)
    chkK.Value() = New_Value
    PropertyChanged "Value"
End Property

'注意！不要删除或修改下列被注释的行！
'MappingInfo=ComboK0,ComboK0,-1,Clear
Public Sub Clear()
Attribute Clear.VB_Description = "清除控件或系统剪贴板的内容。"
    ComboK0.Clear
End Sub

'注意！不要删除或修改下列被注释的行！
'MappingInfo=ComboK0,ComboK0,-1,AddItem
Public Sub AddItem(ByVal Item As String, Optional ByVal Index As Variant)
Attribute AddItem.VB_Description = "添加一项到 Listbox 或 ComboBox 控件，或添加一行到 Grid 控件。"
    ComboK0.AddItem Item, Index
End Sub

'注意！不要删除或修改下列被注释的行！
'MemberInfo=8
Public Function SetCombo() As Long
Dim i As Long
Dim s1 As String
Dim id As Long
Dim flag As Long
Dim k As Long
    ComboK1.Clear
    ComboK1.AddItem StrUnicode2("=未定义变量=")
    For i = 1 To KdefName.Count
        ComboK1.AddItem KdefName(i)
    Next i
    chkK_Click
    If chkK.Value = 1 Then
        s1 = GetKdefname(txtK.Text)
        If s1 = "" Then
            ComboK1.ListIndex = 0
        Else
            ComboK1.Text = s1
        End If
    Else
        flag = 0
        
      
        If flag = 1 Then
            ComboK0.ListIndex = k
        End If
    End If

End Function

Private Sub UserControl_Initialize()
        chkK.Caption = StrUnicode2("变量")
End Sub

'从存贮器中加载属性值
Private Sub UserControl_ReadProperties(PropBag As PropertyBag)

    txtK.Text = PropBag.ReadProperty("Text", "Text1")
    chkK.Value = PropBag.ReadProperty("Value", 0)
End Sub

'将属性值写到存储器
Private Sub UserControl_WriteProperties(PropBag As PropertyBag)

    Call PropBag.WriteProperty("Text", txtK.Text, "Text1")
    Call PropBag.WriteProperty("Value", chkK.Value, 0)
End Sub

