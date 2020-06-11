VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "clsX86"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = False


Option Explicit

Public Str As String         ' 指令原始字串
Public Style As Long          ' 指令类型  0 label 1 普通 2 fixup 3 短跳转 4 长跳转 5 长地址跳转 6 标号重定位
Public label As String         ' label字符串
Public Address                ' 指令起始地址
Public num As Long             ' 指令字节数
Private priData(20) As Byte     ' 保存指令
Public Fixup As Long          ' Fixup的值
Public offset As Long         ' fixup项或者跳转项在指令中的字节数
Public PageOffset As Integer  ' fixup 的pageoffset
Public PageNum As Long        ' 第几个Page


Public Property Get Data(ByVal i As Long) As Integer
    Data = priData(i)
End Property

Public Property Let Data(ByVal i As Long, ByVal value As Integer)
    priData(i) = value
End Property

