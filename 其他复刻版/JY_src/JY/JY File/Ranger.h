//-----------------------------------------------------------------------------
// Ranger.grp和Ranger.idx，游戏数据表格文件
// 描述游戏内的以下信息：基本数据，人物，物品，场景，武功，小宝商店
//-----------------------------------------------------------------------------

#ifndef JY_RANGER
#define JY_RANGER

// INCLUDES ///////////////////////////////////////////////////////////////////

#define WIN32_LEAN_AND_MEAN

#include <windows.h>
#include <stdio.h>
#include <assert.h>

#include "FH_File.h"

// DEFINES ////////////////////////////////////////////////////////////////////
// MACROS /////////////////////////////////////////////////////////////////////
// TYPES //////////////////////////////////////////////////////////////////////
// CLASS //////////////////////////////////////////////////////////////////////

// 单个场景信息结构体
// 其中坐标为0表示位置不存在
// 不要使用它，因为中间可能会有空隙，而原数据是没有空隙的
typedef struct _RANGER_SCENE
	{
	short nIndex;				// 00 场景编号
	char  gcName[10];			// 02 场景名称，Big5编码，如果有空余位置则补0
	short nOutMusic;			// 12 出门音乐
	short nInMusic;				// 14 进门音乐
	short nJumpScene;			// 16 跳转场景，-1表示没有
	short nInRequirement;		// 18 进入条件，0开放，1关闭，2需要轻功
	short nWorldMapInX1;		// 20 外景入口X1
	short nWorldMapInY1;		// 22 外景入口Y1
	short nWorldMapInX2;		// 24 外景入口X2
	short nWorldMapInY2;		// 26 外景入口Y2
	short nInX;					// 28 场景内入口X
	short nInY;					// 30 场景内入口Y
	short nOutX1;				// 32 场景内出口X1
	short nOutX2;				// 34 场景内出口X2
	short nOutX3;				// 36 场景内出口X3
	short nOutY1;				// 38 场景内出口Y1
	short nOutY2;				// 40 场景内出口Y2
	short nOutY3;				// 42 场景内出口Y3
	short nJumpOutX;			// 44 场景内跳转出口X，进入其他场景
	short nJumpOutY;			// 46 场景内跳转出口Y
	short nJumpInX;				// 48 场景内跳转入口X，从其他场景来到本场景
	short nJumpInY;				// 50 场景内跳转入口Y
	} RANGER_SCENE;

// PROTOTYPES /////////////////////////////////////////////////////////////////
// EXTERNALS //////////////////////////////////////////////////////////////////

// 各数据长度或偏移
extern const DWORD nRANGER_SCENE_SIZE;				// Ranger文件中单个Scene数据段的长度

// GLOBALS ////////////////////////////////////////////////////////////////////
// FUNCTIONS //////////////////////////////////////////////////////////////////

#endif // JY_RANGER