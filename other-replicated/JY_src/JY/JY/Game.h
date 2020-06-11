//-----------------------------------------------------------------------------
// 游戏对象
//-----------------------------------------------------------------------------

#ifndef GAME
#define GAME

// INCLUDES ///////////////////////////////////////////////////////////////////

#define WIN32_LEAN_AND_MEAN

#include <windows.h>
#include <stdio.h>
#include <assert.h>

#include "FH_Bit.h"
#include "game_window.h"

#include "Game_Public.h"
#include "Game_Time.h"
#include "Player.h"
#include "World_Map.h"

// DEFINES ////////////////////////////////////////////////////////////////////

// 游戏状态
#define GM_PAUSED				(1 << 0)		// 游戏被暂停
#define GM_CLOSING				(1 << 1)		// 游戏正在关闭

// MACROS /////////////////////////////////////////////////////////////////////
// TYPES //////////////////////////////////////////////////////////////////////
// CLASS //////////////////////////////////////////////////////////////////////

// 游戏对象
class CGame
	{
	public:
		CGame(CGameWindow *piGameWnd);
		~CGame();

		int Init();
		// 游戏主模块
		int Main();
		// 暂停游戏
		int Pause();
		// 游戏从暂停中恢复
		int Unpause();
		// 保存游戏数据
		void Save() {}

		// 检查游戏状态
		DWORD Check(DWORD bits) {return CHECK_BIT(m_nState, bits);}

	private:
		// 处理输入
		int __ProcessInput();
		// 显示图像
		int __Display();


		DWORD m_nState;							// 游戏状态
		CGameWindow * const m_piGameWnd;		// 所在窗口关联类实例地址
		CGameTime m_Time;						// 游戏时间对象
		CPlayer m_Player;						// 游戏者对象
		CWorldMap m_WorldMap;					// 世界地图对象

		int m_nPressLength;						// 按键动作持续时间，超过这个时间才算又一次按键动作

#ifdef DEBUG
		LONGLONG m_nCpuCount;					// （一段代码所花费的）CPU计数
		LONGLONG m_nCpuCountSum;				// 累计获取的CPU计数
		LONGLONG m_nCpuCountLastCalc;			// 上次计算时间关系的时间
#endif // DEBUG
	};

// PROTOTYPES /////////////////////////////////////////////////////////////////
// EXTERNALS //////////////////////////////////////////////////////////////////
// GLOBALS ////////////////////////////////////////////////////////////////////
// FUNCTIONS //////////////////////////////////////////////////////////////////

#endif // GAME