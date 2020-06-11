
// INCLUDES ///////////////////////////////////////////////////////////////////

#include "game_window.h"
#include "FH_Log.h"
#include "config.h"
#include "Game.h"

// DEFINES ////////////////////////////////////////////////////////////////////
// MACROS /////////////////////////////////////////////////////////////////////
// TYPES //////////////////////////////////////////////////////////////////////
// CLASS //////////////////////////////////////////////////////////////////////
// PROTOTYPES /////////////////////////////////////////////////////////////////
// EXTERNALS //////////////////////////////////////////////////////////////////

extern CLog g_Log;								// 日志对象
extern CConfig g_Cfg;							// 程序设置对象
extern HINSTANCE g_hInstance;					// 程序实例句柄

// GLOBALS ////////////////////////////////////////////////////////////////////

const char gcGAME_WND_CLASS_NAME[] = "GAME_WND";		// 游戏窗口类名
const char gcGAME_WND_TITLE[] = "金庸群侠传";			// 游戏窗口标题

static bool sg_bWndClassReged = false;					// 是否已注册窗口类

// FUNCTIONS //////////////////////////////////////////////////////////////////

//-----------------------------------------------------------------------------
// Name: CGameWindow()
// Desc: 构造函数
//-----------------------------------------------------------------------------
CGameWindow::CGameWindow()
	{
	m_nState = 0;		// 因为窗口创建好后会发送已激活的消息，而且这里也没有激活，所以不需要设置
	m_nClientWidth = g_Cfg.m_nFrameWidth;		// 设置客户区宽高
	m_nClientHeight = g_Cfg.m_nFrameHeight;
	}



//-----------------------------------------------------------------------------
// Name: ~CGameWindow()
// Desc: 析构函数
//-----------------------------------------------------------------------------
CGameWindow::~CGameWindow()
	{
	///////////////////////////////////////////////////////////
	// 等待所有游戏窗口线程创建的线程结束，然后关闭这些线程的句柄
	// 当前只创建了一个游戏线程

	WaitForMultipleObjects(1, &m_hGameThread, true, INFINITE);

	CloseHandle(m_hGameThread);

	///////////////////////////////////////////////////////////
	}



//-----------------------------------------------------------------------------
// Name: Init()
// Desc: 游戏窗口初始化
//-----------------------------------------------------------------------------
int CGameWindow::Init()
	{
	///////////////////////////////////////////////////////////
	// 如果还未注册窗口类，则创建并注册之

	if (!sg_bWndClassReged)
		{
		if (__RegWndClass() != 0)
			{
			g_Log.Write("注册窗口类失败\r\n");
			return -1;
			}
		sg_bWndClassReged = true;
		}

	///////////////////////////////////////////////////////////
	// 创建游戏窗口

	if (__CreateWnd() != 0)
		{
		g_Log.Write("创建游戏窗口失败\r\n");
		return -1;
		}

	///////////////////////////////////////////////////////////
	// 窗口显示出来后，初始化游戏窗口相关信息
	// 收到WM_CREATE消息时窗口还未显示，所以只能在这个位置执行

	if (__InitWindowInfo() != 0)
		{
		g_Log.Write("初始化游戏窗口相关信息失败\r\n");
		return -1;
		}

	///////////////////////////////////////////////////////////
	// 创建游戏线程
	// 此时窗口已经显示，初始化画面已经没问题了

	if (__CreateGameThread() != 0)
		{
		g_Log.Write("创建游戏线程失败\r\n");
		return -1;
		}

	return 0;
	} // end Init



//-----------------------------------------------------------------------------
// Name: __RegWndClass()
// Desc: 创建并注册窗口类
//-----------------------------------------------------------------------------
int CGameWindow::__RegWndClass()
	{
	// 填充窗口类结构体
	WNDCLASSEX winclass;
	winclass.cbSize         = sizeof(WNDCLASSEX);
	winclass.style			= CS_DBLCLKS | CS_OWNDC | CS_HREDRAW | CS_VREDRAW;
	winclass.lpfnWndProc	= __WndProc;
	winclass.cbClsExtra		= 0;
	winclass.cbWndExtra		= sizeof(CGameWindow *);			// 申请存放窗口关联类实例地址的空间
	winclass.hInstance		= g_hInstance;
	winclass.hIcon			= LoadIcon(NULL, IDI_APPLICATION);
	winclass.hCursor		= LoadCursor(NULL, IDC_ARROW);
	winclass.hbrBackground	= (HBRUSH)GetStockObject(BLACK_BRUSH);
	winclass.lpszMenuName	= NULL;
	winclass.lpszClassName	= gcGAME_WND_CLASS_NAME;
	winclass.hIconSm        = LoadIcon(NULL, IDI_APPLICATION);

	// 注册窗口类
	if (!RegisterClassEx(&winclass))
		return -1;

	return 0;
	} // end __RegWndClass



//-----------------------------------------------------------------------------
// Name: __CreateWnd()
// Desc: 创建窗口
//-----------------------------------------------------------------------------
int CGameWindow::__CreateWnd()
	{
	///////////////////////////////////////////////////////////
	// 根据设置计算窗口属性

	DWORD nWindowStyle;						// 窗口样式
	DWORD nWindowLeft, nWindowTop;			// 窗口左、上边缘位置
	DWORD nWindowWidth, nWindowHeight;		// 窗口宽高（和客户区不同）

	// 全屏模式
	if (g_Cfg.m_bFullScreen)
		{
		nWindowStyle = WS_POPUP | WS_VISIBLE;
		nWindowLeft = 0;
		nWindowTop  = 0;
		nWindowWidth  = m_nClientWidth;
		nWindowHeight = m_nClientHeight;
		}
	// 窗口模式
	else
		{
		nWindowStyle = WS_CAPTION | WS_VISIBLE;
		nWindowLeft = CW_USEDEFAULT;
		nWindowTop  = CW_USEDEFAULT;

		// 给出用户区大小，计算包含控件和边缘后窗口的大小
		// 注意不能计算WS_OVERLAPPED样式，但可以计算同样有细边框标题栏的WS_CAPTION
		RECT rectWindow = {0, 0, m_nClientWidth, m_nClientHeight};
		if (AdjustWindowRect(&rectWindow, nWindowStyle, false) == 0)
			return -1;

		nWindowWidth  = rectWindow.right - rectWindow.left;
		nWindowHeight = rectWindow.bottom - rectWindow.top;
		}

	///////////////////////////////////////////////////////////
	// 创建窗口
	// 顺便把当前窗口关联类实例地址让WM_CREATE消息带到消息处理函数中

	m_hWnd = CreateWindowEx(0,									// 窗口扩展样式
							gcGAME_WND_CLASS_NAME,				// 窗口类名
							gcGAME_WND_TITLE,					// 窗口名
							nWindowStyle,						// 窗口样式
							nWindowLeft, nWindowTop,			// 窗口左上角位置
							nWindowWidth, nWindowHeight,		// 窗口宽高
							NULL,								// 父窗口句柄
							NULL,								// 菜单句柄
							g_hInstance,						// 程序实例句柄
							this);								// 可选参数，可在WM_CREATE消息中接收
	if (m_hWnd == NULL)
		return -2;

	return 0;
	} // end __CreateWnd



//-----------------------------------------------------------------------------
// Name: __InitWindowInfo()
// Desc: 初始化游戏窗口相关信息
//-----------------------------------------------------------------------------
int CGameWindow::__InitWindowInfo()
	{
	///////////////////////////////////////////////////////////
	// 获得用户区位置

	// 计算用户区左上角在屏幕上的位置
	POINT client_point = {0, 0};		// 用户区左上角相对于自己的坐标
	if ( ClientToScreen(m_hWnd, &client_point) == 0 )
		return -2;

	m_rectClient.left   = client_point.x;
	m_rectClient.top    = client_point.y;
	m_rectClient.right  = m_rectClient.left + m_nClientWidth;
	m_rectClient.bottom = m_rectClient.top  + m_nClientHeight;

	///////////////////////////////////////////////////////////
	// 获得窗口四边与用户区四边的差值

	// 获得窗口区域位置
	RECT window_rect;
	if ( GetWindowRect(m_hWnd, &window_rect) == 0 )
		return -3;

	m_rectAdjusted.left		= window_rect.left - m_rectClient.left;
	m_rectAdjusted.top		= window_rect.top - m_rectClient.top;
	m_rectAdjusted.right	= window_rect.right - m_rectClient.right;
	m_rectAdjusted.bottom	= window_rect.bottom - m_rectClient.bottom;

	return 0;
	} // end __InitWindowInfo



//-----------------------------------------------------------------------------
// Name: __CreateGameThread()
// Desc: 创建游戏线程
//-----------------------------------------------------------------------------
int CGameWindow::__CreateGameThread()
	{
	// 创建线程，向线程处理函数传递当前窗口关联类实例地址
	m_hGameThread = CreateThread(NULL, 0, &__GameThreadProc, this, 0, NULL);
	if (m_hGameThread == NULL)
		{
		g_Log.Write("创建游戏线程失败\r\n");
		return -1;
		}

	return 0;
	} // end __CreateGameThread



//-----------------------------------------------------------------------------
// Name: __GameThreadProc()
// Desc: 游戏线程处理函数
//-----------------------------------------------------------------------------
DWORD WINAPI CGameWindow::__GameThreadProc(LPVOID lpParameter)
	{
	assert(lpParameter);

	// 接收当前窗口关联类实例地址
	CGameWindow * const piGameWnd = reinterpret_cast< CGameWindow * >(lpParameter);

	// 创建游戏对象
	CGame Game(piGameWnd);

	///////////////////////////////////////////////////////////
	// 游戏初始化，如果失败则销毁游戏线程并关闭当前游戏窗口

	if (Game.Init() != 0)
		{
		g_Log.Write("游戏初始化失败\r\n");

		// 向当前游戏窗口发送消息，关闭该窗口
		if (PostMessage(piGameWnd->hWnd(), WM_CLOSE, 0, 0) == 0)
			{
			g_Log.Write("__GameThreadProc()：向当前游戏窗口发送关闭窗口消息失败\r\n");
			return -1;
			}

		return -1;
		}

	///////////////////////////////////////////////////////////
	// 游戏主循环
	// 游戏/游戏窗口还没有设置为关闭状态时一直循环

	while ( !piGameWnd->Check(GW_CLOSING) )
		{
		// 如果窗口被最小化，且游戏没有暂停，则游戏暂停
		if ( piGameWnd->Check(GW_MINIMIZED) && !Game.Check(GM_PAUSED) )
			Game.Pause();
		// 如果窗口没有被最小化，且游戏暂停了，则恢复运行
		else if ( !piGameWnd->Check(GW_MINIMIZED) && Game.Check(GM_PAUSED) )
			Game.Unpause();

		// 游戏没有暂停/正在关闭
		if ( !Game.Check(GM_PAUSED | GM_CLOSING) )
			{
			// 游戏主模块，进行一帧内的所有处理
			if (Game.Main() != 0)
				{
				g_Log.Write("游戏主模块出错\r\n");

				// 向当前游戏窗口发送消息，关闭该窗口
				if (PostMessage(piGameWnd->hWnd(), WM_CLOSE, 0, 0) == 0)
					{
					g_Log.Write("__GameThreadProc()：向当前游戏窗口发送关闭窗口消息失败\r\n");
					return -1;
					}

				return -1;
				}
			}
		// 游戏已暂停，休息一会儿
		else if (Game.Check(GM_PAUSED))
			{
			Sleep(100);
			}
		// 游戏正在关闭，而且游戏窗口没有正在关闭
		else
			{
			// 向当前游戏窗口发送消息，关闭该窗口
			if (PostMessage(piGameWnd->hWnd(), WM_CLOSE, 0, 0) == 0)
				{
				g_Log.Write("__GameThreadProc()：向当前游戏窗口发送关闭窗口消息失败\r\n");
				return -1;
				}

			// 跳出游戏主循环
			break;
			}
		}

	return 0;
	} // end __GameThreadProc



//-----------------------------------------------------------------------------
// Name: EventLoop()
// Desc: 消息循环
//-----------------------------------------------------------------------------
WPARAM CGameWindow::EventLoop()
	{
	MSG msg;

	// 接收该线程的所有消息，消息收到后才返回
	// 得到WM_QUIT时函数返回0，出错时返回-1，不检查是否出错
	while(GetMessage(&msg, NULL, 0, 0) != 0)
		DispatchMessage(&msg);

	return msg.wParam;
	} // end EventLoop



//-----------------------------------------------------------------------------
// Name: __WndProc()
// Desc: 窗口消息处理函数
//-----------------------------------------------------------------------------
LRESULT CALLBACK CGameWindow::__WndProc(HWND hwnd, UINT msg, WPARAM wparam, LPARAM lparam)
	{
	switch(msg)
		{
		// 窗口已创建但还未显示
		// lparam指向的结构体中有创建窗口时附加的数据
		case WM_CREATE:
			{
			// 获取窗口关联类实例地址
			CREATESTRUCT *lpCS = reinterpret_cast< LPCREATESTRUCT >(lparam);
			CGameWindow *piGameWnd = reinterpret_cast< CGameWindow * >(lpCS->lpCreateParams);

			// 把窗口关联类实例地址加到系统窗口实例额外空间，以后通过窗口句柄获取
			// 想检测是否成功返回要花点功夫：先清除以前的LastError标志，然后调用SetWindowLongPtr
			// 如果返回0且LastError不为0，则没有成功返回，否则成功
			SetLastError(0);
			LONG_PTR nRet = SetWindowLongPtr(hwnd, 0, reinterpret_cast<LONG_PTR>(piGameWnd));
			if (nRet == 0 && GetLastError() != 0)
				{
				g_Log.Write("把窗口关联类实例地址加到系统窗口实例额外空间时失败\r\n");
				return -1;
				}

			return 0;
			}

		case WM_PAINT:
			{
			// 使窗口有效，没有它们的话窗口会一直收到该消息
			PAINTSTRUCT ps;
   			HDC hdc = BeginPaint(hwnd,&ps);
			EndPaint(hwnd,&ps);
			return 0;
			}

		// 窗口被移动，改写用户区位置
		// lparam中是用户区的左上角屏幕坐标
		case WM_MOVE:
			{
			// 获取当前窗口关联类实例地址（失败时的处理已在函数中做好）
			CGameWindow *piGameWnd = __piGameWnd(hwnd);
			if (piGameWnd == NULL) return -1;

			piGameWnd->m_rectClient.left	= (int)(short) LOWORD(lparam);
			piGameWnd->m_rectClient.top		= (int)(short) HIWORD(lparam);
			piGameWnd->m_rectClient.right	= piGameWnd->m_rectClient.left + piGameWnd->m_nClientWidth;
			piGameWnd->m_rectClient.bottom	= piGameWnd->m_rectClient.top  + piGameWnd->m_nClientHeight;
			return 0;
			}

		// 窗口大小被改变
		// wparam中是变化类型，lparam中是用户区的宽高
		case WM_SIZE:
			{
			// 获取当前窗口关联类实例地址（失败时的处理已在函数中做好）
			CGameWindow *piGameWnd = __piGameWnd(hwnd);
			if (piGameWnd == NULL) return -1;

			switch (wparam)
				{
				// 窗口最小化
				//*********
				case SIZE_MINIMIZED:
					{
					g_Log.Write("Window: %s -> %s\r\n",
						piGameWnd->Check(GW_MINIMIZED) ? "min" : "normal", "Min");
					SET_BIT(piGameWnd->m_nState, GW_MINIMIZED);
					break;
					}
				// 窗口通常形式的大小改变（非最小化、最大化）
				// 可能的情况为：拖动窗口边缘改变了大小、从最大化或最小化恢复*********
				// 在这里只可能出现“从最小化恢复”的情形*********
				case SIZE_RESTORED:
					{
					g_Log.Write("Window: %s -> %s\r\n",
						piGameWnd->Check(GW_MINIMIZED) ? "min" : "normal", "Normal");
					RESET_BIT(piGameWnd->m_nState, GW_MINIMIZED);
					break;
					}
				}
			return 0;
			}

		// 窗口被激活或被解除活动
		// wparam表示窗口是被激活或是被解除活动，lparam中是另一个激活状态正在改变的窗口的线程ID
		case WM_ACTIVATEAPP:
			{
			// 获取当前窗口关联类实例地址（失败时的处理已在函数中做好）
			CGameWindow *piGameWnd = __piGameWnd(hwnd);
			if (piGameWnd == NULL) return -1;

			// 窗口被激活（窗口被创建时也会收到此消息）
			if (wparam)
				SET_BIT(piGameWnd->m_nState, GW_ACTIVATED);
			// 窗口被解除活动（窗口被关闭时也会收到此消息）
			else
				RESET_BIT(piGameWnd->m_nState, GW_ACTIVATED);
			return 0;
			}

		// 准备关闭窗口
		case WM_CLOSE:
			{
			// 获取当前窗口关联类实例地址（失败时的处理已在函数中做好）
			CGameWindow *piGameWnd = __piGameWnd(hwnd);
			if (piGameWnd == NULL) return -1;

			SET_BIT(piGameWnd->m_nState, GW_CLOSING);
			DestroyWindow(hwnd);
			return 0;
			}

		// 窗口已经从屏幕消失，正在被销毁
		case WM_DESTROY:
			{
			PostQuitMessage(0);
			return 0;
			}

		default:
			{
			return DefWindowProc(hwnd, msg, wparam, lparam);
			}

		} // end switch (msg)

	return 0;
	} // end __WinProc



//-----------------------------------------------------------------------------
// Name: __piGameWnd()
// Desc: 根据窗口句柄找到当前窗口关联类实例地址，该地址放在系统窗口实例的额外空间中
//       用在消息处理函数中，成功返回地址，失败返回0
//-----------------------------------------------------------------------------
inline CGameWindow *CGameWindow::__piGameWnd(HWND const hWnd)
	{
	CGameWindow *piGameWnd = reinterpret_cast< CGameWindow * >( GetWindowLongPtr(hWnd, 0) );

	// 如果无法获取当前窗口关联类实例地址，则关闭窗口
	if (piGameWnd == NULL)
		{
		g_Log.Write("获取当前窗口关联类实例地址失败\r\n");
		PostMessage(hWnd, WM_CLOSE, 0, 0);
		return 0;
		}

	return piGameWnd;
	} // end __piGameWnd
