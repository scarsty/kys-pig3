
// INCLUDES ///////////////////////////////////////////////////////////////////

#include "World_Map.h"
#include "Game_Draw.h"

// DEFINES ////////////////////////////////////////////////////////////////////
// MACROS /////////////////////////////////////////////////////////////////////
// TYPES //////////////////////////////////////////////////////////////////////
// CLASS //////////////////////////////////////////////////////////////////////
// PROTOTYPES /////////////////////////////////////////////////////////////////
// EXTERNALS //////////////////////////////////////////////////////////////////
// GLOBALS ////////////////////////////////////////////////////////////////////

// 地图基本图块宽高
const WORD nTILE_WIDTH = 36;
const WORD nTILE_HEIGHT = 18;

// FUNCTIONS //////////////////////////////////////////////////////////////////

//-----------------------------------------------------------------------------
// Name: CWorldMap()
// Desc: 构造函数
//-----------------------------------------------------------------------------
CWorldMap::CWorldMap()
	{
	m_nGetDrawPosStep = 0;

	///////////////////////////////////////////////////////////
	// 计算上下左右需要显示的图块数（参见World_Map.txt）

	DWORD r = g_Cfg.m_nFrameWidth / (nTILE_WIDTH *2);
	DWORD p = g_Cfg.m_nFrameWidth % (nTILE_WIDTH *2);
	int n;							// 左右需要显示的图块数
	bool b_stagger_h = false;		// 水平上与基点图块交错（参见World_Map.txt）
	
	if (p > nTILE_WIDTH || p == 0)
		n = r + (p>0 ? 1 : 0);
	else
		{
		n = r + (p>0 ? 1 : 0) -1;
		b_stagger_h = true;
		}

	DWORD s = g_Cfg.m_nFrameHeight / (nTILE_HEIGHT *2);
	DWORD q = g_Cfg.m_nFrameHeight % (nTILE_HEIGHT *2);
	int m;							// 上下需要显示的图块数（上m，下m-1）
	bool b_stagger_v = false;		// 垂直上与基点图块交错

	if (q > nTILE_HEIGHT || q == 0)
		{
		m = s + (q>0 ? 1 : 0);
		b_stagger_v = true;
		}
	else
		m = s + (q>0 ? 1 : 0);

	///////////////////////////////////////////////////////////
	// 计算四个角的图块相对基点图块的地图坐标偏移值(dx,dy)

	// 水平、垂直都不错开时
	if (!b_stagger_h && !b_stagger_v)
		{
		m_locTopRight.x		= -m + n;
		m_locTopRight.y		= -m - n;
		m_locTopLeft.x		= -m - n;
		m_locTopLeft.y		= -m + n;
		m_locBottomRight.x	=  m + n -1;
		m_locBottomRight.y	=  m - n -1;
		m_locBottomLeft.x	=  m - n -1;
		m_locBottomLeft.y	=  m + n -1;
		m_locRightTop.x		= -m + n;
		m_locRightTop.y		= -m - n;
		m_locRightBottom.x	=  m + n -1;
		m_locRightBottom.y	=  m - n -1;
		m_locLeftTop.x		= -m - n;
		m_locLeftTop.y		= -m + n;
		m_locLeftBottom.x	=  m - n -1;
		m_locLeftBottom.y	=  m + n -1;
		}
	// 水平、垂直都错开时
	else if (b_stagger_h && b_stagger_v)
		{
		m_locTopRight.x		= -m + n;
		m_locTopRight.y		= -m - n -1;
		m_locTopLeft.x		= -m - n -1;
		m_locTopLeft.y		= -m + n;
		m_locBottomRight.x	=  m + n;
		m_locBottomRight.y	=  m - n -1;
		m_locBottomLeft.x	=  m - n -1;
		m_locBottomLeft.y	=  m + n;
		m_locRightTop.x		= -m + n;
		m_locRightTop.y		= -m - n -1;
		m_locRightBottom.x	=  m + n;
		m_locRightBottom.y	=  m - n -1;
		m_locLeftTop.x		= -m - n -1;
		m_locLeftTop.y		= -m + n;
		m_locLeftBottom.x	=  m - n -1;
		m_locLeftBottom.y	=  m + n;
		}
	// 水平错开、垂直不错开时
	else if (b_stagger_h && !b_stagger_v)
		{
		m_locTopRight.x		= -m + n;
		m_locTopRight.y		= -m - n;
		m_locTopLeft.x		= -m - n;
		m_locTopLeft.y		= -m + n;
		m_locBottomRight.x	=  m + n -1;
		m_locBottomRight.y	=  m - n -1;
		m_locBottomLeft.x	=  m - n -1;
		m_locBottomLeft.y	=  m + n -1;
		m_locRightTop.x		= -m + n +1;
		m_locRightTop.y		= -m - n;
		m_locRightBottom.x	=  m + n -1;
		m_locRightBottom.y	=  m - n -2;
		m_locLeftTop.x		= -m - n;
		m_locLeftTop.y		= -m + n +1;
		m_locLeftBottom.x	=  m - n -2;
		m_locLeftBottom.y	=  m + n -1;
		}
	// 水平不错开、垂直错开时
	else
		{
		m_locTopRight.x		= -m + n -1;
		m_locTopRight.y		= -m - n;
		m_locTopLeft.x		= -m - n;
		m_locTopLeft.y		= -m + n -1;
		m_locBottomRight.x	=  m + n -1;
		m_locBottomRight.y	=  m - n;
		m_locBottomLeft.x	=  m - n;
		m_locBottomLeft.y	=  m + n -1;
		m_locRightTop.x		= -m + n;
		m_locRightTop.y		= -m - n;
		m_locRightBottom.x	=  m + n -1;
		m_locRightBottom.y	=  m - n -1;
		m_locLeftTop.x		= -m - n;
		m_locLeftTop.y		= -m + n;
		m_locLeftBottom.x	=  m - n -1;
		m_locLeftBottom.y	=  m + n -1;
		}
	} // end CWorldMap



//-----------------------------------------------------------------------------
// Name: ~CWorldMap()
// Desc: 析构函数
//-----------------------------------------------------------------------------
CWorldMap::~CWorldMap()
	{
	// 卸载世界地图相关数据
	Unload_RLE(&m_mrMmap);
	Unload_COL(&m_mfCol);
	UnloadFile(&m_mfEarth);
	UnloadFile(&m_mfSurface);
	UnloadFile(&m_mfBuilding);
	UnloadFile(&m_mfBuildx);
	UnloadFile(&m_mfBuildy);
	}



//-----------------------------------------------------------------------------
// Name: Init()
// Desc: 初始化世界地图数据
//-----------------------------------------------------------------------------
int CWorldMap::Init()
	{
	///////////////////////////////////////////////////////////
	// 载入世界地图数据

	// 载入RLE图像文件数据
	int result = Load_RLE(&m_mrMmap, g_Cfg.m_fnMmapGrp, g_Cfg.m_fnMmapIdx);
	if (result != 0)
		{
		g_Log.Write("载入GRP和IDX文件时出错\r\n");
		return -1;
		}

	// 载入调色板文件数据
	result = Load_COL(&m_mfCol, g_Cfg.m_fnMmapCol);
	if (result != 0)
		{
		g_Log.Write("载入COL文件时出错\r\n");
		return -1;
		}

	// 把调色板信息附加到图像数据信息上
	Attach_COL(&m_mrMmap, &m_mfCol);

	// 设置透明色
	Set_Trans_Color(COLOR_KEY);

	///////////////////////////////////////////
	// 载入图块排列数据

	result = LoadFile(g_Cfg.m_fnEarth, &m_mfEarth, 0);
	if (result != 0)
		{
		g_Log.Write("载入Earth文件时出错\r\n");
		return -1;
		}

	result = LoadFile(g_Cfg.m_fnSurface, &m_mfSurface, 0);
	if (result != 0)
		{
		g_Log.Write("载入Surface文件时出错\r\n");
		return -1;
		}

	result = LoadFile(g_Cfg.m_fnBuilding, &m_mfBuilding, 0);
	if (result != 0)
		{
		g_Log.Write("载入Building文件时出错\r\n");
		return -1;
		}

	result = LoadFile(g_Cfg.m_fnBuildx, &m_mfBuildx, 0);
	if (result != 0)
		{
		g_Log.Write("载入BuildX文件时出错\r\n");
		return -1;
		}

	result = LoadFile(g_Cfg.m_fnBuildy, &m_mfBuildy, 0);
	if (result != 0)
		{
		g_Log.Write("载入BuildY文件时出错\r\n");
		return -1;
		}

	///////////////////////////////////////////////////////////
	// 地图最大坐标值（暂时不计算，直接给出）

	m_locMax.x = 479;
	m_locMax.y = 479;

	return 0;
	} // end Init



//-----------------------------------------------------------------------------
// Name: Show()
// Desc: 在屏幕上显示世界地图
//       按地图坐标的行来绘制
//       绘制方法参见World_Map.txt
//-----------------------------------------------------------------------------
int CWorldMap::Show(LOC * const plocCenter)
	{
	assert(plocCenter);

	///////////////////////////////////////////////////////////
	// 绘制地图图块
	// 按地图坐标从左到右从上到下绘制

	// 绘制同一Y轴的图块时的起始和结束坐标（相对中心坐标的偏移值）
	LOC begin_loc, end_loc;

	///////////////////////////////////////////
	// 以地图坐标的行来绘制

	// 第一遍绘制地面图块
	while ( __GetDrawPos(&begin_loc, &end_loc) )
		{
		// 绘制一行图块（同Y轴）
		for (LOC draw_loc = begin_loc; draw_loc.x <= end_loc.x; ++draw_loc.x)
			{
			// 根据地图坐标偏移值求出绝对值，然后求出图块索引值
			LOC abs_loc;
			abs_loc.x = plocCenter->x + draw_loc.x;
			abs_loc.y = plocCenter->y + draw_loc.y;
			
			// 地面图像索引
			WORD index;
			// 如果绝对坐标值在实际范围外，则图像索引为0
			if (abs_loc.x > m_locMax.x || abs_loc.x < 0 || abs_loc.y > m_locMax.y || abs_loc.y < 0)
				index = 0;
			else
				index = *(WORD *)( m_mfEarth.pBuffer + abs_loc.x*2 + abs_loc.y*2*(m_locMax.x +1) ) /2;

			// 把地图坐标偏移值转换为屏幕坐标（参见World_Map.txt）
			LOC screen_loc;
			screen_loc.x = g_Cfg.m_nFrameWidth/2 + (draw_loc.x - draw_loc.y)*(nTILE_WIDTH/2);
			screen_loc.y = g_Cfg.m_nFrameHeight/2 -1 + (draw_loc.x + draw_loc.y +2)*(nTILE_HEIGHT/2);

			// 绘制指定索引号的地面图块到指定屏幕坐标
			int result = Draw_RLE_Tile(&m_mrMmap, index, &screen_loc);
			if (result != 0)
				{
				g_Log.Write("绘制世界地图(%d, %d)处的地面图块%u到屏幕坐标(%d, %d)失败\r\n",
							draw_loc.x, draw_loc.y, index, screen_loc.x, screen_loc.y);
				return -1;
				}
			}
		}

	// 第二遍绘制表面图块
	while ( __GetDrawPos(&begin_loc, &end_loc) )
		{
		// 绘制一行图块（同Y轴）
		for (LOC draw_loc = begin_loc; draw_loc.x <= end_loc.x; ++draw_loc.x)
			{
			// 根据地图坐标偏移值求出绝对值，然后求出图块索引值
			LOC abs_loc;
			abs_loc.x = plocCenter->x + draw_loc.x;
			abs_loc.y = plocCenter->y + draw_loc.y;
			
			// 表面图像索引
			WORD index;
			// 如果绝对坐标值在实际范围外，则图像索引为0
			if (abs_loc.x > m_locMax.x || abs_loc.x < 0 || abs_loc.y > m_locMax.y || abs_loc.y < 0)
				index = 0;
			else
				index = *(WORD *)( m_mfSurface.pBuffer + abs_loc.x*2 + abs_loc.y*2*(m_locMax.x +1) ) /2;

			// 把地图坐标偏移值转换为屏幕坐标（参见World_Map.txt）
			LOC screen_loc;
			screen_loc.x = g_Cfg.m_nFrameWidth/2 + (draw_loc.x - draw_loc.y)*(nTILE_WIDTH/2);
			screen_loc.y = g_Cfg.m_nFrameHeight/2 -1 + (draw_loc.x + draw_loc.y +2)*(nTILE_HEIGHT/2);

			// 绘制指定索引号的表面图块到指定屏幕坐标
			int result = Draw_RLE_Tile(&m_mrMmap, index, &screen_loc);
			if (result != 0)
				{
				g_Log.Write("绘制世界地图(%d, %d)处的表面图块%u到屏幕坐标(%d, %d)失败\r\n",
							draw_loc.x, draw_loc.y, index, screen_loc.x, screen_loc.y);
				return -1;
				}
			}
		}

	// 第三遍绘制建筑图块
	while ( __GetDrawPos(&begin_loc, &end_loc) )
		{
		// 绘制一行图块（同Y轴）
		for (LOC draw_loc = begin_loc; draw_loc.x <= end_loc.x; ++draw_loc.x)
			{
			// 根据地图坐标偏移值求出绝对值，然后求出图块索引值
			LOC abs_loc;
			abs_loc.x = plocCenter->x + draw_loc.x;
			abs_loc.y = plocCenter->y + draw_loc.y;
			
			// 建筑图像索引
			WORD index;
			// 如果绝对坐标值在实际范围外，则图像索引为0
			if (abs_loc.x > m_locMax.x || abs_loc.x < 0 || abs_loc.y > m_locMax.y || abs_loc.y < 0)
				index = 0;
			else
				index = *(WORD *)( m_mfBuilding.pBuffer + abs_loc.x*2 + abs_loc.y*2*(m_locMax.x +1) ) /2;

			// 把地图坐标偏移值转换为屏幕坐标（参见World_Map.txt）
			LOC screen_loc;
			screen_loc.x = g_Cfg.m_nFrameWidth/2 + (draw_loc.x - draw_loc.y)*(nTILE_WIDTH/2);
			screen_loc.y = g_Cfg.m_nFrameHeight/2 -1 + (draw_loc.x + draw_loc.y +2)*(nTILE_HEIGHT/2);

			// 绘制指定索引号的建筑图块到指定屏幕坐标
			int result = Draw_RLE_Tile(&m_mrMmap, index, &screen_loc);
			if (result != 0)
				{
				g_Log.Write("绘制世界地图(%d, %d)处的建筑图块%u到屏幕坐标(%d, %d)失败\r\n",
							draw_loc.x, draw_loc.y, index, screen_loc.x, screen_loc.y);
				return -1;
				}
			}
		}

	return 0;
	} // end Show



////-----------------------------------------------------------------------------
//// Name: Show()
//// Desc: 在屏幕上显示世界地图
////       以屏幕上的行来绘制
////       绘制方法参见World_Map.txt
////-----------------------------------------------------------------------------
//int CWorldMap::Show(LOC * const plocCenter)
//	{
//	assert(plocCenter);
//
//	///////////////////////////////////////////////////////////
//	// 绘制地图图块
//	// 按屏幕参照系的从左到右从上到下绘制
//
//	// 绘制一水平线时的起始和结束坐标（相对中心坐标的偏移值）
//	LOC begin_loc, end_loc;
//
//	///////////////////////////////////////////
//	// 以屏幕上的行来绘制
//
//	// 第一遍绘制地面图块
//	while ( __GetDrawPos(&begin_loc, &end_loc) )
//		{
//		// 绘制一行图块（屏幕上从左到右，地图坐标x+1,y-1）
//		for (LOC draw_loc = begin_loc; draw_loc.x <= end_loc.x; ++draw_loc.x, --draw_loc.y)
//			{
//			// 根据地图坐标偏移值求出绝对值，然后求出图块索引值
//			LOC abs_loc;
//			abs_loc.x = plocCenter->x + draw_loc.x;
//			abs_loc.y = plocCenter->y + draw_loc.y;
//			
//			// 地面图像索引
//			WORD index;
//			// 如果绝对坐标值在实际范围外，则图像索引为0
//			if (abs_loc.x > m_locMax.x || abs_loc.x < 0 || abs_loc.y > m_locMax.y || abs_loc.y < 0)
//				index = 0;
//			else
//				index = *(WORD *)( m_mfEarth.pBuffer + abs_loc.x*2 + abs_loc.y*2*(m_locMax.x +1) ) /2;
//
//			// 把地图坐标偏移值转换为屏幕坐标（参见World_Map.txt）
//			LOC screen_loc;
//			screen_loc.x = g_Cfg.m_nFrameWidth/2 + (draw_loc.x - draw_loc.y)*(nTILE_WIDTH/2);
//			screen_loc.y = g_Cfg.m_nFrameHeight/2 -1 + (draw_loc.x + draw_loc.y +2)*(nTILE_HEIGHT/2);
//
//			// 绘制指定索引号的地面图块到指定屏幕坐标
//			int result = Draw_RLE_Tile(&m_mrMmap, index, &screen_loc);
//			if (result != 0)
//				{
//				g_Log.Write("绘制世界地图(%d, %d)处的地面图块%u到屏幕坐标(%d, %d)失败\r\n",
//							draw_loc.x, draw_loc.y, index, screen_loc.x, screen_loc.y);
//				return -1;
//				}
//			}
//		}
//
//	// 第二遍绘制表面图块
//	while ( __GetDrawPos(&begin_loc, &end_loc) )
//		{
//		// 绘制一行图块（屏幕上从左到右，地图坐标x+1,y-1）
//		for (LOC draw_loc = begin_loc; draw_loc.x <= end_loc.x; ++draw_loc.x, --draw_loc.y)
//			{
//			// 根据地图坐标偏移值求出绝对值，然后求出图块索引值
//			LOC abs_loc;
//			abs_loc.x = plocCenter->x + draw_loc.x;
//			abs_loc.y = plocCenter->y + draw_loc.y;
//			
//			// 表面图像索引
//			WORD index;
//			// 如果绝对坐标值在实际范围外，则图像索引为0
//			if (abs_loc.x > m_locMax.x || abs_loc.x < 0 || abs_loc.y > m_locMax.y || abs_loc.y < 0)
//				index = 0;
//			else
//				index = *(WORD *)( m_mfSurface.pBuffer + abs_loc.x*2 + abs_loc.y*2*(m_locMax.x +1) ) /2;
//
//			// 把地图坐标偏移值转换为屏幕坐标（参见World_Map.txt）
//			LOC screen_loc;
//			screen_loc.x = g_Cfg.m_nFrameWidth/2 + (draw_loc.x - draw_loc.y)*(nTILE_WIDTH/2);
//			screen_loc.y = g_Cfg.m_nFrameHeight/2 -1 + (draw_loc.x + draw_loc.y +2)*(nTILE_HEIGHT/2);
//
//			// 绘制指定索引号的表面图块到指定屏幕坐标
//			int result = Draw_RLE_Tile(&m_mrMmap, index, &screen_loc);
//			if (result != 0)
//				{
//				g_Log.Write("绘制世界地图(%d, %d)处的表面图块%u到屏幕坐标(%d, %d)失败\r\n",
//							draw_loc.x, draw_loc.y, index, screen_loc.x, screen_loc.y);
//				return -1;
//				}
//			}
//		}
//
//	// 第三遍绘制建筑图块
//	while ( __GetDrawPos(&begin_loc, &end_loc) )
//		{
//		// 绘制一行图块（屏幕上从左到右，地图坐标x+1,y-1）
//		for (LOC draw_loc = begin_loc; draw_loc.x <= end_loc.x; ++draw_loc.x, --draw_loc.y)
//			{
//			// 根据地图坐标偏移值求出绝对值，然后求出图块索引值
//			LOC abs_loc;
//			abs_loc.x = plocCenter->x + draw_loc.x;
//			abs_loc.y = plocCenter->y + draw_loc.y;
//			
//			// 建筑图像索引
//			WORD index;
//			// 如果绝对坐标值在实际范围外，则图像索引为0
//			if (abs_loc.x > m_locMax.x || abs_loc.x < 0 || abs_loc.y > m_locMax.y || abs_loc.y < 0)
//				index = 0;
//			else
//				index = *(WORD *)( m_mfBuilding.pBuffer + abs_loc.x*2 + abs_loc.y*2*(m_locMax.x +1) ) /2;
//
//			// 把地图坐标偏移值转换为屏幕坐标（参见World_Map.txt）
//			LOC screen_loc;
//			screen_loc.x = g_Cfg.m_nFrameWidth/2 + (draw_loc.x - draw_loc.y)*(nTILE_WIDTH/2);
//			screen_loc.y = g_Cfg.m_nFrameHeight/2 -1 + (draw_loc.x + draw_loc.y +2)*(nTILE_HEIGHT/2);
//
//			// 绘制指定索引号的建筑图块到指定屏幕坐标
//			int result = Draw_RLE_Tile(&m_mrMmap, index, &screen_loc);
//			if (result != 0)
//				{
//				g_Log.Write("绘制世界地图(%d, %d)处的建筑图块%u到屏幕坐标(%d, %d)失败\r\n",
//							draw_loc.x, draw_loc.y, index, screen_loc.x, screen_loc.y);
//				return -1;
//				}
//			}
//		}
//
//	return 0;
//	} // end Show



//-----------------------------------------------------------------------------
// Name: __GetDrawPos()
// Desc: 计算要绘制的一行图块的起点图块和终点图块的位置（相对中心坐标的偏移值），返回是否还需要继续绘制
//       按地图坐标（而不是屏幕坐标），从左到右，从上到下绘制
//-----------------------------------------------------------------------------
bool CWorldMap::__GetDrawPos(LOC * const plocBegin, LOC * const plocEnd)
	{
	assert(plocBegin && plocEnd);

	// 当前起点在上右角，终点在右上角
	if (m_nGetDrawPosStep == 0)
		{
		*plocBegin = m_locTopRight;
		*plocEnd = m_locRightTop;

		// 改变下次起点与终点的位置指示
		m_nGetDrawPosStep = 1;		// 上 - 右
		}
	// 当前起点在上，终点在右
	else if (m_nGetDrawPosStep == 1)
		{
		// 如果起点到达上左角，则过渡到最左边那条线上
		if (plocBegin->x == m_locTopLeft.x && plocBegin->y == m_locTopLeft.y)
			{
			m_nGetDrawPosStep = 2;		// 左 - 右

			// 如果一个错开一个不错开，则左上的y坐标要加1
			if (plocBegin->y < m_locLeftTop.y)
				plocBegin->y = m_locLeftTop.y;
			// 否则起点没有变化，所以要主动到最左边往下一格
			else
				{
				++plocBegin->x;
				++plocBegin->y;
				}
			}
		// 否则向左平移一个位置
		else
			{
			--plocBegin->x;
			++plocBegin->y;
			}

		// 如果终点到达右下角，则过渡到最下边那条线上
		if (plocEnd->x == m_locRightBottom.x && plocEnd->y == m_locRightBottom.y)
			{
			m_nGetDrawPosStep = 3;		// 上 - 下

			// 如果一个错开一个不错开，则下右的y坐标要加1
			if (plocEnd->y < m_locBottomRight.y)
				plocEnd->y = m_locBottomRight.y;
			// 否则起点没有变化，所以要主动到最下边往左一格
			else
				{
				--plocEnd->x;
				++plocEnd->y;
				}
			}
		// 否则向下平移一个位置
		else
			{
			++plocEnd->x;
			++plocEnd->y;
			}
		}
	// 当前起点在上，终点在下
	else if (m_nGetDrawPosStep == 3)
		{
		// 如果起点到达上左角，则过渡到最左边那条线上
		if (plocBegin->x == m_locTopLeft.x && plocBegin->y == m_locTopLeft.y)
			{
			m_nGetDrawPosStep = 4;		// 左 - 下

			// 如果一个错开一个不错开，则左上的y坐标要加1
			if (plocBegin->y < m_locLeftTop.y)
				plocBegin->y = m_locLeftTop.y;
			// 否则起点没有变化，所以要主动到最左边往下一格
			else
				{
				++plocBegin->x;
				++plocBegin->y;
				}
			}
		// 否则向左平移一个位置
		else
			{
			--plocBegin->x;
			++plocBegin->y;
			}

		// 终点向左平移一个位置
		--plocEnd->x;
		++plocEnd->y;
		}
	// 当前起点在左，终点在右
	else if (m_nGetDrawPosStep == 2)
		{
		// 起点向下平移一个位置
		++plocBegin->x;
		++plocBegin->y;

		// 如果终点到达右下角，则过渡到最下边那条线上
		if (plocEnd->x == m_locRightBottom.x && plocEnd->y == m_locRightBottom.y)
			{
			m_nGetDrawPosStep = 4;		// 左 - 下

			// 如果一个错开一个不错开，则下右的y坐标要加1
			if (plocEnd->y < m_locBottomRight.y)
				plocEnd->y = m_locBottomRight.y;
			// 否则起点没有变化，所以要主动到最下边往左一格
			else
				{
				--plocEnd->x;
				++plocEnd->y;
				}
			}
		// 否则向下平移一个位置
		else
			{
			++plocEnd->x;
			++plocEnd->y;
			}
		}
	// 当前起点在左，终点在下
	else
		{
		// 如果起点到达左下角，则说明绘制完毕
		// 把位置指示还原，然后返回false
		if (plocBegin->x == m_locLeftBottom.x && plocBegin->y == m_locLeftBottom.y)
			{
			m_nGetDrawPosStep = 0;		// 上右 - 右上
			return false;
			}
		// 否则起点向下平移一个位置，终点向左平移一个位置
		else
			{
			++plocBegin->x;
			++plocBegin->y;
			--plocEnd->x;
			++plocEnd->y;
			}
		}

	return true;
	} // end __GetDrawPos


////-----------------------------------------------------------------------------
//// Name: __GetDrawPos()
//// Desc: 计算要绘制的一行图块的起点图块和终点图块的位置（相对中心坐标的偏移值），返回是否还需要继续绘制
////       按屏幕参照系，从左到右，从上到下绘制
////       最开始起点在上左角、终点在上右角，最后起点在下左角、终点在下右角
////       其间，起点终点的变化都走Z字，只有端点是否重合会影响到开始走Z字的方向
////-----------------------------------------------------------------------------
//bool CWorldMap::__GetDrawPos(LOC * const plocBegin, LOC * const plocEnd)
//	{
//	assert(plocBegin && plocEnd);
//
//	switch (m_nGetDrawPosStep)
//		{
//		// 第一次绘制，从上左到上右
//		case 0:
//			{
//			*plocBegin = m_locTopLeft;
//			*plocEnd = m_locTopRight;
//
//			// 上左和左上不同，则先向外走Z字（起点y+1，终点x+1）
//			if (m_locTopLeft.y != m_locLeftTop.y)
//				m_nGetDrawPosStep = 1;
//			// 相同，则先向内走Z字（起点x+1，终点y+1）
//			else
//				m_nGetDrawPosStep = 2;
//			}
//			break;
//		// 向外走Z字（起点y+1，终点x+1）
//		case 1:
//			{
//			// 起点到达下左角，说明绘制完毕
//			// 步骤清零，返回已绘制完毕
//			if (plocBegin->x == m_locBottomLeft.x && plocBegin->y == m_locBottomLeft.y)
//				{
//				m_nGetDrawPosStep = 0;
//				return false;
//				}
//
//			++plocBegin->y;
//			++plocEnd->x;
//
//			// 下次向内走Z字
//			m_nGetDrawPosStep = 2;
//			}
//			break;
//		// 向内走Z字（起点x+1，终点y+1）
//		case 2:
//			{
//			// 起点到达下左角，说明绘制完毕
//			// 步骤清零，返回已绘制完毕
//			if (plocBegin->x == m_locBottomLeft.x && plocBegin->y == m_locBottomLeft.y)
//				{
//				m_nGetDrawPosStep = 0;
//				return false;
//				}
//
//			++plocBegin->x;
//			++plocEnd->y;
//
//			// 下次向外走Z字
//			m_nGetDrawPosStep = 1;
//			}
//			break;
//		}
//
//	return true;
//	} // end __GetDrawPos
