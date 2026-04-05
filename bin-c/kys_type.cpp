// kys_type.cpp - 全局大数组定义
// 对应 kys_type.pas implementation

#include "kys_type.h"

// 大地图数据
int16_t Earth[480][480] = {};
int16_t Surface[480][480] = {};
int16_t Building[480][480] = {};
int16_t BuildX[480][480] = {};
int16_t BuildY[480][480] = {};
int16_t Entrance[480][480] = {};

// 角色/物品/场景/武功/商店
// 使用偏移1来模拟Pascal的[-1..1000]
TRole Rrole[1002] = {}, Rrole0[1002] = {};
TItem Ritem[1002] = {}, Ritem0[1002] = {};
TScene Rscene[1002] = {}, Rscene0[1002] = {};
TMagic Rmagic[1002] = {}, Rmagic0[1002] = {};
TShop RShop[22] = {}, RShop0[22] = {};

// 场景/事件数据
int16_t SData[401][6][64][64] = {};
int16_t DData[401][200][11] = {};

// 战场地图
int16_t BField[10][64][64] = {};
TWarData WarStaList[401] = {};

// 扩展指令50变量
// Pascal: x50: array[-$8000..$7FFF] => 使用偏移0x8000访问
int x50[0x10000] = {};

// 寻路
int16_t linex[480 * 480] = {};
int16_t liney[480 * 480] = {};
int Fway[480][480] = {};

// 扩展地面
int16_t ExGroundS[192][192] = {};
int16_t ExGroundB[192][192] = {};
