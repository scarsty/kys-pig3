//-----------------------------------------------------------------------------
// 游戏窗口对象
//-----------------------------------------------------------------------------

#ifndef GAME_WINDOW
#define GAME_WINDOW

// INCLUDES ///////////////////////////////////////////////////////////////////

#define WIN32_LEAN_AND_MEAN

#include <windows.h>
#include <stdio.h>
#include <assert.h>

#include "FH_Bit.h"

// DEFINES ////////////////////////////////////////////////////////////////////

// 窗口状态
#define GW_ACTIVATED		(1 << 0)		// 窗口被激活
#define GW_MINIMIZED		(1 << 1)		// 窗口被最小化（全屏时切换到桌面）
#define GW_CLOSING			(1 << 2)		// 窗口正在被关闭

// MACROS /////////////////////////////////////////////////////////////////////
// TYPES //////////////////////////////////////////////////////////////////////
// CLASS //////////////////////////////////////////////////////////////////////

class CGameWindow
	{
	public:
		CGameWindow();
		~CGameWindow();

		int Init();
		// 窗口的事件循环
		static WPARAM EventLoop();

		// 检查窗口状态
		DWORD Check(DWORD bits) {return CHECK_BIT(m_nState, bits);}
		// 获取窗口句柄
		HWND hWnd() {return m_hWnd;}
		// 获取客户区位置
		const RECT *rectClient() {return &m_rectClient;}
		// 获取客户区宽度
		int ClientWidth()  {return m_nClientWidth;}
		// 获取客户区高度
		int ClientHeight() {return m_nClientHeight;}

	private:
		// 注册窗口类
		static int __RegWndClass();
		// 创建窗口
		int __CreateWnd();
		// 初始化窗口相关信息
		int __InitWindowInfo();
		// 创建游戏线程
		int __CreateGameThread();
		// 游戏线程处理函数
		static DWORD WINAPI __GameThreadProc(LPVOID lpParameter);
		// 窗口消息处理函数
		static LRESULT CALLBACK __WndProc(HWND hwnd, UINT msg, WPARAM wparam, LPARAM lparam);

		// 获取当前窗口关联类实例地址（用在消息处理函数中）
		static CGameWindow *__piGameWnd(HWND hWnd);


		HWND	m_hWnd;							// 窗口句柄
		DWORD	m_nState;						// 窗口状态（位域变量）
		RECT	m_rectClient;					// 窗口模式下的客户区位置
		int		m_nClientWidth;					// 窗口模式下的客户区宽高，只能在修改设置时变动
		int		m_nClientHeight;
		RECT	m_rectAdjusted;					// 窗口四边与用户区四边的差值（上左为负），和窗口样式有关
		HANDLE	m_hGameThread;					// 游戏线程句柄
	};

// PROTOTYPES /////////////////////////////////////////////////////////////////
// EXTERNALS //////////////////////////////////////////////////////////////////
// GLOBALS ////////////////////////////////////////////////////////////////////
// FUNCTIONS //////////////////////////////////////////////////////////////////

#endif // GAME_WINDOW