//-----------------------------------------------------------------------------
// 世界地图对象
//-----------------------------------------------------------------------------

#ifndef WORLD_MAP
#define WORLD_MAP

// INCLUDES ///////////////////////////////////////////////////////////////////

#define WIN32_LEAN_AND_MEAN

#include <windows.h>
#include <stdio.h>
#include <assert.h>

#include "Game_Public.h"
#include "RLE.h"

// DEFINES ////////////////////////////////////////////////////////////////////
// MACROS /////////////////////////////////////////////////////////////////////
// TYPES //////////////////////////////////////////////////////////////////////
// CLASS //////////////////////////////////////////////////////////////////////

// 世界地图对象
class CWorldMap
	{
	public:
		CWorldMap();
		~CWorldMap();

		int Init();
		// 在屏幕上显示世界地图
		int Show(LOC *plocCenter);

		// 获取最大坐标值
		const LOC *locMax() {return &m_locMax;}

	private:
		// 计算要绘制的一行图块的起点图块和终点图块的位置
		bool __GetDrawPos(LOC *plocBegin, LOC *plocEnd);


		Mem_RLE  m_mrMmap;						// 世界地图图块信息
		Mem_File m_mfCol;						// 调色板信息
		Mem_File m_mfEarth;						// 世界地图相关文件信息
		Mem_File m_mfSurface;
		Mem_File m_mfBuilding;
		Mem_File m_mfBuildx;
		Mem_File m_mfBuildy;

		LOC m_locMax;							// 最大坐标值

		LOC m_locTopRight;						// 上右坐标偏移值
		LOC m_locTopLeft;						// 上左坐标偏移值
		LOC m_locBottomRight;					// 下右坐标偏移值
		LOC m_locBottomLeft;					// 下左坐标偏移值
		LOC m_locRightTop;						// 右上坐标偏移值
		LOC m_locRightBottom;					// 右下坐标偏移值
		LOC m_locLeftTop;						// 左上坐标偏移值
		LOC m_locLeftBottom;					// 左下坐标偏移值

		int m_nGetDrawPosStep;					// 获取绘制位置的步骤编号
	};

// PROTOTYPES /////////////////////////////////////////////////////////////////
// EXTERNALS //////////////////////////////////////////////////////////////////
// GLOBALS ////////////////////////////////////////////////////////////////////
// FUNCTIONS //////////////////////////////////////////////////////////////////

#endif // WORLD_MAP