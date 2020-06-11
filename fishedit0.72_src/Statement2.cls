VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "Statement"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = False
Option Explicit

' 定义指令类 ，vb集合中不能存放结构，所以只能定义一个类


Public Id As Integer      ' 指令标志
Public isGoto As Long     ' 是否为跳转,0 非跳转，1 是跳转，2 否跳转
Public GotoAddress As Integer  ' 跳转偏移
Public yesOffset As Integer    ' 是跳转偏移
Public noOffset As Integer     ' 否跳转偏移
Public gotoLabel As String     ' 跳转的标号
Public islabel As Boolean      ' 是否为标号指令
Public note As String          ' 指令说明
Private priDataNum As Long  ' 后面跟的数据个数(不包括指令标志)
Private priData() As Integer ' 后面跟的数据

Public Property Get DataNum() As Long
    DataNum = priDataNum
End Property

Public Property Let DataNum(ByVal value As Long)
    priDataNum = value
    If value > 0 Then
        ReDim priData(priDataNum - 1)
    End If
End Property

Public Property Get data(ByVal i As Long) As Integer
    data = priData(i)
End Property

Public Property Let data(ByVal i As Long, ByVal value As Integer)
    priData(i) = value
End Property

