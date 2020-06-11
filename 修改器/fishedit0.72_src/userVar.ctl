VERSION 5.00
Begin VB.UserControl userVar 
   ClientHeight    =   1020
   ClientLeft      =   0
   ClientTop       =   0
   ClientWidth     =   1860
   ClipBehavior    =   0  '无
   BeginProperty Font 
      Name            =   "Times New Roman"
      Size            =   9
      Charset         =   0
      Weight          =   400
      Underline       =   0   'False
      Italic          =   0   'False
      Strikethrough   =   0   'False
   EndProperty
   ScaleHeight     =   1020
   ScaleWidth      =   1860
   Begin VB.TextBox txtX 
      Height          =   285
      Left            =   0
      TabIndex        =   2
      Text            =   "Text1"
      Top             =   0
      Width           =   1575
   End
   Begin VB.CheckBox chkX 
      Caption         =   "变量"
      Height          =   255
      Left            =   0
      TabIndex        =   1
      Top             =   720
      Width           =   735
   End
   Begin VB.ComboBox ComboX 
      Enabled         =   0   'False
      Height          =   345
      Left            =   0
      Style           =   2  'Dropdown List
      TabIndex        =   0
      Top             =   360
      Width           =   1815
   End
End
Attribute VB_Name = "userVar"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = False
Option Explicit
'缺省属性值:
Const m_def_Showtype = 0
'属性变量:
Dim m_Showtype As Boolean


'注意！不要删除或修改下列被注释的行！
'MappingInfo=txtX,txtX,-1,Text
Public Property Get Text() As String
Attribute Text.VB_Description = "返回/设置控件中包含的文本。"
    Text = txtX.Text
End Property

Public Property Let Text(ByVal New_Text As String)
    txtX.Text() = New_Text
    PropertyChanged "Text"
End Property

'注意！不要删除或修改下列被注释的行！
'MappingInfo=chkX,chkX,-1,Value
Public Property Get Value() As Integer
Attribute Value.VB_Description = "返回/设置对象的值。"
    Value = chkX.Value
End Property

Public Property Let Value(ByVal New_Value As Integer)
    chkX.Value() = New_Value
    PropertyChanged "Value"
End Property

'注意！不要删除或修改下列被注释的行！
'MemberInfo=0,0,0,0
Public Property Get Showtype() As Boolean
    Showtype = m_Showtype
End Property

Public Property Let Showtype(ByVal New_Showtype As Boolean)
    m_Showtype = New_Showtype
    If m_Showtype = True Then
        chkX.Visible = True
    Else
        chkX.Value = 1
        chkX.Visible = False
    End If
    PropertyChanged "Showtype"
End Property

'注意！不要删除或修改下列被注释的行！
'MemberInfo=8
Public Function SetCombo() As Long
Dim i As Long
Dim s As String
    ComboX.Clear
    ComboX.AddItem StrUnicode2("=未定义变量=")
    For i = 1 To KdefName.Count
        ComboX.AddItem KdefName(i)
    Next i
    
    If chkX.Value = 1 Then
        s = GetKdefname(txtX.Text)
        If s = "" Then
            ComboX.ListIndex = 0
        Else
            ComboX.Text = s
        End If
    End If
End Function

Private Sub chkX_Click()
    If chkX.Value = 1 Then
        ComboX.Enabled = True
    Else
        ComboX.Enabled = False
    End If
End Sub

Private Sub ComboX_click()
Dim s As String
    If ComboX.ListIndex > 0 Then
        s = ComboX.Text
        txtX.Text = CLng(Mid(s, 1, InStr(s, ":") - 1))
    End If
End Sub

 

Private Sub UserControl_Initialize()
    chkX.Caption = StrUnicode2("变量")
End Sub

'为用户控件初始化属性
Private Sub UserControl_InitProperties()
    m_Showtype = m_def_Showtype
End Sub

'从存贮器中加载属性值
Private Sub UserControl_ReadProperties(PropBag As PropertyBag)

    txtX.Text = PropBag.ReadProperty("Text", "Text1")
    chkX.Value = PropBag.ReadProperty("Value", 0)
    m_Showtype = PropBag.ReadProperty("Showtype", m_def_Showtype)
End Sub

'将属性值写到存储器
Private Sub UserControl_WriteProperties(PropBag As PropertyBag)

    Call PropBag.WriteProperty("Text", txtX.Text, "Text1")
    Call PropBag.WriteProperty("Value", chkX.Value, 0)
    Call PropBag.WriteProperty("Showtype", m_Showtype, m_def_Showtype)
End Sub

