Attribute VB_Name = "jyModule1"
'人物0~319,物品0~199,武功0~92,场景0~83
Public Rx_GRP(0 To 2) As String '     114,242  进度一
Public Rx_IDX(0 To 2) As String
Public RANGER_GRP   As String '       114,242  进度原始数据
Public RANGER_IDX   As String
Public ALLDEF_GRP   As String '       440,000  各场景事件数据(原始数据)
Public ALLDEF_IDX   As String
Public ALLDEFBK_GRP As String '       440,000  各场景事件数据(备份)
Public ALLDEFBK_IDX As String
Public Dx_GRP(0 To 2) As String '     440,000  各场景事件数据(存档用)
Public Dx_IDX(0 To 2) As String
Public ALLSIN_GRP   As String '     4,915,200  各场景地图结构(原始数据)
Public ALLSIN_IDX   As String
Public ALLSINBK_GRP As String '     4,915,200  各场景地图结构(备份)
Public ALLSINBK_IDX As String
Public Sx_GRP(0 To 2) As String '   4,915,200  各场景地图结构(存档用)
Public Sx_IDX(0 To 2) As String
Public EFT_GRP      As String '       691,627  所有武功效果
Public EFT_IDX      As String
Public ENDWORD_GRP  As String '        75,839  制作群信息
Public ENDWORD_IDX  As String
Public FBK_GRP      As String '       138,677  主角攻击动作136幅(每48幅一种攻击,拳剑刀)
Public FBK_IDX      As String
Public CLOUD_GRP    As String '        10,287  云
Public CLOUD_IDX    As String
Public FMAP_GRP     As String '     1,359,863  所有场景地图块
Public FMAP_IDX     As String
Public HDGRP_GRP    As String '       249,276  所有人物头像
Public HDGRP_IDX    As String
Public KDEF_GRP     As String '       121,214  所有事件压缩脚本
Public KDEF_IDX     As String
Public KEND_GRP     As String '    14,144,000  片尾动画
Public KEND_IDX     As String
Public MMAP_GRP     As String '     1,572,545  所有外景地图块
Public MMAP_IDX     As String
Public TALK_GRP     As String '       192,314  对话(非图像)
Public TALK_IDX     As String
Public TITLE_GRP    As String '         8,179  标题菜单
Public TITLE_IDX    As String
Public WARFLD_GRP   As String '       532,480  战斗场景地图框架数据
Public WARFLD_IDX   As String

Public BUILDING_2   As String '       460,800  外景地图建筑贴图数据(树、山、房屋等)
Public BUILDX_2     As String '       460,800  外景地图建筑覆盖x坐标(一个建筑可能覆盖几个地块坐标)
Public BUILDY_2     As String '       460,800  外景地图建筑覆盖y坐标
Public EARTH_2      As String '       460,800  外景地图底层贴图数据(地面、江河湖海、雪地、沙漠等)
Public SURFACE_2    As String '       460,800  外景地图表面贴图数据(道路，花花草草等)
Public DEAD_BIG     As String '        64,000  GameOver图像
Public TITLE_BIG    As String '        64,000  封面图像
Public HERO_STA     As String '        58,240  各人物原始属性数据(r1.grp的一部分)
Public WAR_STA      As String '        26,040  战斗事件数据
Public TEMP_SWP     As String '     4,194,304  临时交换文件？
Public SWAP_VMC     As String '            50  临时文件变量
Public SHADOW3_MSK  As String '         7,770  阴影帖图数据？
Public SHADOW4_MSK  As String '        11,170  阴影？
Public FONT_C16     As String '       447,136  繁体汉字库
Public FONT3_C16    As String '       447,136  繁体汉字库？
Public FONT3J_C16   As String '       447,136  简体汉字库？
Public FONT_E16     As String '         2,688  可能是英文字库？
Public FONT3_E16    As String '         2,048  可能是英文字库？
Public FONT_X16     As String '         2,048  字库xx
Public ENDCOL_COL   As String '           768  256调色板
Public MMAP_COL     As String '           768  外景地块贴图256调色板
Public DOS4GW_EXE   As String '       265,420  Dos保护模式驱动
Public SETSOUND_EXE As String '       168,741  声卡设置程序
Public Z_EXE        As String '       343,873  主程序
Public Z_COM        As String '           413  破解程序
Public Z_DAT        As String '       343,217  可执行文件 相当 z.exe
Public CFONT        As String '        29,674  汉字点阵字库
Public SOL          As String '       126,158  可能与声音频率有关xxx
Public SIN050       As String '                49,152  11-04-01  12:19 SIN050
Public FIGHTxxx_GRP(0 To 109) As String '       247,429  所有武功动作
Public FIGHTxxx_IDX(0 To 109) As String
Public SDXxxx(0 To 83)   As String '   16,508  场景图块索引
Public SMPxxx(0 To 83)   As String '  598,497  场景图块
Public WDXxxx(0 To 25)   As String '   14,804  场景图块索引
Public WMPxxx(0 To 25)   As String '   15,839  场景图块
Public ATKxx_WAV(0 To 23)    As String '  19,228  攻击音效
Public Exx_WAV(0 To 52)      As String '   7,716  武功音效
Public GAMExx_XMI(0 To 23)   As String '   4,578  游戏MIDI音乐

Public tempInt1 As Integer, tempInt2 As Integer
Public tempLong1 As Long, tempLong2 As Long
Public tempBool1 As Boolean, tempBool2 As Boolean, Busying As Boolean
Public tempStr1 As String, tempStr2 As String
Public GamePath As String

Function iniVar(strPath As String) As Integer
'人物0~319,物品0~199,武功0~92,场景0~83
For i = 0 To 2
  Rx_GRP(i) = strPath & "R" & i & ".GRP" '     114,242  进度一
  Rx_IDX(i) = strPath & "R" & i & ".IDX"
  Dx_GRP(i) = strPath & "D" & i & ".GRP" '     440,000  各场景事件数据(存档用)
  Dx_IDX(i) = strPath & "D" & i & ".IDX"
  Sx_GRP(i) = strPath & "S" & i & ".GRP" '   4,915,200  各场景地图结构(存档用)
  Sx_IDX(i) = strPath & "S" & i & ".IDX"
Next

For i = 0 To 109
  FIGHTxxx_GRP(i) = strPath & "FIGHT" & Format(i, "000") & ".GRP" = strPath & "" & "." '       247,429  所有武功动作
  FIGHTxxx_IDX(i) = strPath & "FIGHT" & Format(i, "000") & ".IDX" = strPath & "" & "."
Next

For i = 0 To 83
  SDXxxx(i) = strPath & "SDX" & Format(i, "000") '   16,508  场景图块索引
  SMPxxx(i) = strPath & "SMP" & Format(i, "000") '  598,497  场景图块
Next

For i = 0 To 25
  WDXxxx(i) = strPath & "WDX" & Format(i, "000")  '   14,804  场景图块索引
  WMPxxx(i) = strPath & "WMP" & Format(i, "000")  '   15,839  场景图块
Next

For i = 0 To 23
  ATKxx_WAV(i) = strPath & "ATK" & Format(i, "00") & ".WAV"   '  19,228  攻击音效
Next

For i = 0 To 52
  Exx_WAV(i) = strPath & "E" & Format(i, "00") & ".WAV"     '   7,716  武功音效
Next

For i = 1 To 24
  GAMExx_XMI(i - 1) = strPath & "GAME" & Format(i, "00") & ".XMI" '   4,578  游戏MIDI音乐
Next
RANGER_GRP = strPath & "RANGER" & ".GRP"   '       114,242  进度原始数据
RANGER_IDX = strPath & "RANGER" & ".IDX"
ALLDEF_GRP = strPath & "ALLDEF" & ".GRP"   '       440,000  各场景事件数据(原始数据)
ALLDEF_IDX = strPath & "ALLDEF" & ".IDX"
ALLDEFBK_GRP = strPath & "ALLDEFBK" & ".GRP" '       440,000  各场景事件数据(备份)
ALLDEFBK_IDX = strPath & "ALLDEFBK" & ".IDX"
ALLSIN_GRP = strPath & "ALLSIN" & ".GRP"   '     4,915,200  各场景地图结构(原始数据)
ALLSIN_IDX = strPath & "ALLSIN" & ".IDX"
ALLSINBK_GRP = strPath & "ALLSINBK" & ".GRP" '     4,915,200  各场景地图结构(备份)
ALLSINBK_IDX = strPath & "ALLSINBK" & ".IDX"
EFT_GRP = strPath & "EFT" & ".GRP"      '       691,627  所有武功效果
EFT_IDX = strPath & "EFT" & ".IDX"
ENDWORD_GRP = strPath & "ENDWORD" & ".GRP"  '        75,839  制作群信息
ENDWORD_IDX = strPath & "ENDWORD" & ".IDX"
FBK_GRP = strPath & "FBK" & ".GRP"      '       138,677  主角攻击动作136幅(每48幅一种攻击,拳剑刀)
FBK_IDX = strPath & "FBK" & ".IDX"
CLOUD_GRP = strPath & "CLOUD" & ".GRP"    '        10,287  云
CLOUD_IDX = strPath & "CLOUD" & ".IDX"
FMAP_GRP = strPath & "FMAP" & ".GRP"     '     1,359,863  所有场景地图块
FMAP_IDX = strPath & "FMAP" & ".IDX"
HDGRP_GRP = strPath & "HDGRP" & ".GRP"    '       249,276  所有人物头像
HDGRP_IDX = strPath & "HDGRP" & ".IDX"
KDEF_GRP = strPath & "KDEF" & ".GRP"     '       121,214  所有事件压缩脚本
KDEF_IDX = strPath & "KDEF" & ".IDX"
KEND_GRP = strPath & "KEND" & ".GRP"     '    14,144,000  片尾动画
KEND_IDX = strPath & "KEND" & ".IDX"
MMAP_GRP = strPath & "MMAP" & ".GRP"     '     1,572,545  所有外景地图块
MMAP_IDX = strPath & "MMAP" & ".IDX"
TALK_GRP = strPath & "TALK" & ".GRP"     '       192,314  对话(非图像)
TALK_IDX = strPath & "TALK" & ".IDX"
TITLE_GRP = strPath & "TITLE" & ".GRP"    '         8,179  标题菜单
TITLE_IDX = strPath & "TITLE" & ".IDX"
WARFLD_GRP = strPath & "WARFLD" & ".GRP"   '       532,480  战斗场景地图框架数据
WARFLD_IDX = strPath & "WARFLD" & ".IDX"

BUILDING_2 = strPath & "BUILDING" & ".002"   '       460,800  外景地图建筑贴图数据(树、山、房屋等)
BUILDX_2 = strPath & "BUILDX" & ".002"     '       460,800  外景地图建筑覆盖x坐标(一个建筑可能覆盖几个地块坐标)
BUILDY_2 = strPath & "BUILDY" & ".002"     '       460,800  外景地图建筑覆盖y坐标
EARTH_2 = strPath & "EARTH" & ".002"      '       460,800  外景地图底层贴图数据(地面、江河湖海、雪地、沙漠等)
SURFACE_2 = strPath & "SURFACE" & ".002"    '       460,800  外景地图表面贴图数据(道路，花花草草等)
DEAD_BIG = strPath & "DEAD" & ".BIG"     '        64,000  GameOver图像
TITLE_BIG = strPath & "TITLE" & ".BIG"    '        64,000  封面图像
HERO_STA = strPath & "HERO" & ".STA"     '        58,240  各人物原始属性数据(r1.GRP的一部分)
WAR_STA = strPath & "WAR" & ".STA"      '        26,040  战斗事件数据
TEMP_SWP = strPath & "TEMP" & ".SWP"     '     4,194,304  临时交换文件？
SWAP_VMC = strPath & "SWAP" & ".VMC"     '            50  临时文件变量
SHADOW3_MSK = strPath & "3SHADOW" & ".MSK"  '         7,770  阴影帖图数据？
SHADOW4_MSK = strPath & "4SHADOW" & ".MSK"  '        11,170  阴影？
FONT_C16 = strPath & "FONT" & ".C16"     '       447,136  繁体汉字库
FONT3_C16 = strPath & "FONT3" & ".C16"    '       447,136  繁体汉字库？
FONT3J_C16 = strPath & "FONT3J" & ".C16"   '       447,136  简体汉字库？
FONT_E16 = strPath & "FONT" & ".E16"     '         2,688  可能是英文字库？
FONT3_E16 = strPath & "FONT3" & ".E16"    '         2,048  可能是英文字库？
FONT_X16 = strPath & "FONT" & ".X16"     '         2,048  字库xx
ENDCOL_COL = strPath & "ENDCOL" & ".COL"   '           768  256调色板
MMAP_COL = strPath & "MMAP" & ".COL"     '           768  外景地块贴图256调色板
DOS4GW_EXE = strPath & "DOS4GW" & ".EXE"   '       265,420  Dos保护模式驱动
SETSOUND_EXE = strPath & "SETSOUND" & ".EXE" '       168,741  声卡设置程序
Z_EXE = strPath & "Z" & ".EXE"        '       343,873  主程序
Z_COM = strPath & "Z" & ".COM"        '           413  破解程序
Z_DAT = strPath & "Z" & ".DAT"        '       343,217  可执行文件 相当 z.exe
CFONT = strPath & "CFONT"        '        29,674  汉字点阵字库
SOL = strPath & "SOL"          '       126,158  可能与声音频率有关xxx
SIN050 = strPath & "SIN050"      '                49,152  11-04-01  12:19 SIN050
iniVar = 0
End Function
