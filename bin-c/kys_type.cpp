// kys_type.cpp - 全局大数组定义
// 对应 kys_type.pas implementation

#include "kys_type.h"

// 大地图数据
int16_t Earth[MAIN_MAP_SIZE][MAIN_MAP_SIZE] = {};
int16_t Surface[MAIN_MAP_SIZE][MAIN_MAP_SIZE] = {};
int16_t Building[MAIN_MAP_SIZE][MAIN_MAP_SIZE] = {};
int16_t BuildX[MAIN_MAP_SIZE][MAIN_MAP_SIZE] = {};
int16_t BuildY[MAIN_MAP_SIZE][MAIN_MAP_SIZE] = {};
int16_t Entrance[MAIN_MAP_SIZE][MAIN_MAP_SIZE] = {};

// 角色/物品/场景/武功/商店
// Pascal的[-1..1000]中[-1]为缓冲, 数据从[0]开始
TRole Rrole[1002] = {}, Rrole0[1002] = {};
TItem Ritem[1002] = {}, Ritem0[1002] = {};
TScene Rscene[1002] = {}, Rscene0[1002] = {};
TMagic Rmagic[1002] = {}, Rmagic0[1002] = {};
TShop RShop[22] = {}, RShop0[22] = {};

// 场景/事件数据
int16_t SData[401][6][SCENE_MAP_SIZE][SCENE_MAP_SIZE] = {};
int16_t DData[401][200][11] = {};

// 战场地图
int16_t BField[10][SCENE_MAP_SIZE][SCENE_MAP_SIZE] = {};
TWarData WarStaList[401] = {};

// 扩展指令50变量
// Pascal: x50: array[-$8000..$7FFF] => 使用偏移0x8000访问
int x50[0x10000] = {};

// 寻路
int16_t linex[480 * 480] = {};
int16_t liney[480 * 480] = {};
int Fway[480][480] = {};

// 扩展地面
int16_t ExGroundS[64][64] = {};
int16_t ExGroundB[64][64] = {};
