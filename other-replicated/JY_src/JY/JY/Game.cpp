
// INCLUDES ///////////////////////////////////////////////////////////////////

#define WIN32_LEAN_AND_MEAN
#define INITGUID										// DirectX

#include <windows.h>
#include <stdio.h>
#include <assert.h>

#include <mmsystem.h>									// DirectX
#include <objbase.h>
#define DIRECTINPUT_VERSION 0x0800
#include <ddraw.h>
#include <dinput.h>
#include <dsound.h>
//#include <dmksctrl.h>
//#include <dmusici.h>
//#include <dmusicc.h>
//#include <dmusicf.h>

#include "dxlib_dd.h"									// DirectX User Lib
#include "dxlib_di.h"
#include "dxlib_ds.h"

#include "Game.h"
#include "Image_Manager.h"

// DEFINES ////////////////////////////////////////////////////////////////////
// MACROS /////////////////////////////////////////////////////////////////////
// TYPES //////////////////////////////////////////////////////////////////////
// CLASS //////////////////////////////////////////////////////////////////////
// PROTOTYPES /////////////////////////////////////////////////////////////////
// EXTERNALS //////////////////////////////////////////////////////////////////

extern HINSTANCE g_hInstance;					// 程序实例句柄

// GLOBALS ////////////////////////////////////////////////////////////////////
// FUNCTIONS //////////////////////////////////////////////////////////////////

#include "Process_Input.h"
#include "Display.h"

//-----------------------------------------------------------------------------
// Name: CGame
// Desc: 构造游戏对象
//-----------------------------------------------------------------------------
CGame::CGame(CGameWindow * const piGameWnd) 
	: m_nState(0), m_piGameWnd(piGameWnd), m_nPressLength(0)
	{
#ifdef DEBUG
	m_nCpuCount = 0;
	m_nCpuCountSum = 0;
	m_nCpuCountLastCalc = 0;
#endif // DEBUG
	}



//-----------------------------------------------------------------------------
// Name: ~CGame
// Desc: 析构游戏对象
//-----------------------------------------------------------------------------
CGame::~CGame()
	{
	///////////////////////////////////////////////////////////
	// 保存游戏进度

	Save();

	///////////////////////////////////////////////////////////
	// 释放DirectX数据

	// DirectSound
	DSound_Shutdown();
	// DirectInput
	DInput_Shutdown();
	// DirectDraw
	DDraw_Shutdown();

	///////////////////////////////////////////////////////////
	}



//-----------------------------------------------------------------------------
// Name: Init()
// Desc: 初始化游戏
//-----------------------------------------------------------------------------
int CGame::Init()
	{
	///////////////////////////////////////////////////////////
	// 初始化世界地图数据

	int result = m_WorldMap.Init();
	if (result != 0)
		{
		g_Log.Write("初始化世界地图数据失败\r\n");
		return -1;
		}

	///////////////////////////////////////////////////////////
	// 初始化DirectDraw

	if (DDraw_Init(m_piGameWnd->hWnd(), g_Cfg.m_nFrameWidth, g_Cfg.m_nFrameHeight, 
				   g_Cfg.m_nFrameBpp, !g_Cfg.m_bFullScreen) != 1)
		{
		g_Log.Write("DDraw_Init() failed.\r\n");
		return -1;
		}

	///////////////////////////////////////////////////////////
	// 初始化DirectInput

	if (DInput_Init(g_hInstance) != 1)
		{
		g_Log.Write("DInput_Init() failed.\r\n");
		return -1;
		}

	if (DInput_Init_Keyboard(m_piGameWnd->hWnd()) != 1)
		{
		g_Log.Write("DInput_Init_Keyboard() failed.\r\n");
		return -1;
		}

	if (DInput_Init_Mouse(m_piGameWnd->hWnd()) != 1)
		{
		g_Log.Write("DInput_Init_Mouse() failed.\r\n");
		return -1;
		}

	///////////////////////////////////////////////////////////
	// 初始化DirectSound

	if (DSound_Init(m_piGameWnd->hWnd()) != 1)
		{
		g_Log.Write("DSound_Init() failed.\r\n");
		return -1;
		}

	///////////////////////////////////////////////////////////
	// 初始化游戏时间

	if (m_Time.Init(g_Cfg.m_nFrameRate) != 0)
		{
		g_Log.Write("游戏时间初始化失败\r\n");
		return -1;
		}

	return 0;
	} // end Init



//-----------------------------------------------------------------------------
// Name: Main()
// Desc: 游戏主模块，每帧执行一次
//-----------------------------------------------------------------------------
int CGame::Main()
	{
	///////////////////////////////////////////////////////////
	// 处理输入

	if (__ProcessInput() != 0)
		{
		g_Log.Write("process_input() failed.\r\n");
		return -1;
		}

	///////////////////////////////////////////////////////////
	// 处理图像

	// 如果需要丢帧，则不绘制图像
	if (m_Time.ShouldDropThisFrame())
		m_Time.AnnounceDropThisFrame();
	else
		{
		if (__Display() != 0)
			{
			g_Log.Write("display() failed.\r\n");
			return -1;
			}
		}

	///////////////////////////////////////////////////////////
	// 时间处理

	// 游戏在规定时间转入下一帧
	if (m_Time.Pass() != 0)
		{
		g_Log.Write("游戏在规定时间转入下一帧失败\r\n");
		return -1;
		}

	return 0;
	} // end Main



//-----------------------------------------------------------------------------
// Name: Pause()
// Desc: 游戏暂停（窗口最小化时游戏也处与暂停状态）
//-----------------------------------------------------------------------------
int CGame::Pause()
	{
	// 暂停所有声音
	DSound_Pause_All_Sounds();

	// 设置游戏状态为暂停
	SET_BIT(m_nState, GM_PAUSED);

	return 0;
	} // end Pause



//-----------------------------------------------------------------------------
// Name: Unpause()
// Desc: 游戏从暂停状态恢复
//-----------------------------------------------------------------------------
int CGame::Unpause()
	{
	// 取消暂停所有声音
	DSound_Unpause_All_Sounds();

	// 恢复游戏时间
	m_Time.Restore();

	// 清除游戏的暂停状态
	RESET_BIT(m_nState, GM_PAUSED);

	return 0;
	} // end Unpause

