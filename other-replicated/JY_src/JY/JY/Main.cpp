//-----------------------------------------------------------------------------
// Win32外壳，程序的入口点
//-----------------------------------------------------------------------------

// INCLUDES ///////////////////////////////////////////////////////////////////

#define WIN32_LEAN_AND_MEAN

#include <windows.h>
#include <stdio.h>
#include <assert.h>

#include "FH_File.h"
#include "FH_Log.h"
#include "config.h"
#include "game_window.h"

// DEFINES ////////////////////////////////////////////////////////////////////
// MACROS /////////////////////////////////////////////////////////////////////
// TYPES //////////////////////////////////////////////////////////////////////
// CLASS //////////////////////////////////////////////////////////////////////
// PROTOTYPES /////////////////////////////////////////////////////////////////

int Init();
void Shutdown();
int RegMainWndClass();
int CreateMainWnd();
WPARAM MainWndEventLoop();
int CreateGameWndThread();
DWORD WINAPI GameWndThreadProc(LPVOID lpParameter);
LRESULT CALLBACK MainWndProc(HWND hwnd, UINT msg, WPARAM wparam, LPARAM lparam);
void CloseGameWndThreadHandleByIndex(int nThreadIndex);

// EXTERNALS //////////////////////////////////////////////////////////////////
// GLOBALS ////////////////////////////////////////////////////////////////////

HINSTANCE g_hInstance = NULL;							// 程序实例句柄
static HWND sg_hMainWnd;								// 主窗口句柄

CConfig g_Cfg;											// 程序设置对象
CLog g_Log;												// 日志对象

const char gcMAIN_WND_CLASS_NAME[] = "WIN_GAME_MAIN";	// 主窗口类名
const char gcMAIN_WND_TITLE[] = "JY_MAIN";				// 主窗口标题
const char gcMUTEX_NAME[] = "FH_JY_GAME";				// 互斥体名，用来保证同一时间只有一个本程序实例

const UINT nWM_CREATE_GAME_WND = WM_APP + 123;			// 主窗口要处理的、创建新的游戏进程的消息
const WPARAM nWPARAM_CREATE_GAME_WND = 456;				// 该消息的参数wparam（为防止意外消息不能为0）
const LPARAM nLPARAM_CREATE_GAME_WND = 789;				// 该消息的参数lparam

const DWORD nMAX_GAME_WND_THREAD = 16;					// 可以同时开启的游戏窗口线程数目上限（最大32）
static DWORD sg_nGameWndThread = 0;								// 已开启的游戏窗口线程数目
static HANDLE sg_ghGameWndThread[nMAX_GAME_WND_THREAD] = {0};	// 游戏窗口线程的句柄列表

// FUNCTIONS //////////////////////////////////////////////////////////////////

//-----------------------------------------------------------------------------
// Name: WinMain()
// Desc: 程序入口
//       在消息循环之前退出WinMain要返回0
//-----------------------------------------------------------------------------
int WINAPI WinMain(	HINSTANCE hinstance, HINSTANCE hprevinstance, LPSTR lpcmdline, int ncmdshow)
	{
	// 保存程序实例句柄
	g_hInstance = hinstance;

	///////////////////////////////////////////////////////////
	// 程序初始化

	int nRet = Init();
	if (nRet == -1)
		{
		// 系统中已存在本程序的实例，而且此时日志文件还未打开
		return 0;
		}
	else if (nRet != 0)
		{
		g_Log.Write("程序初始化失败\r\n");
		return 0;
		}

	///////////////////////////////////////////////////////////
	// 创建并注册主窗口类

	if (RegMainWndClass() != 0)
		{
		g_Log.Write("注册主窗口类失败\r\n");
		return 0;
		}

	///////////////////////////////////////////////////////////
	// 创建主窗口

	if (CreateMainWnd() != 0)
		{
		g_Log.Write("创建主窗口失败\r\n");
		return 0;
		}

	///////////////////////////////////////////////////////////
	// 主窗口消息循环

	WPARAM wParamQuit = MainWndEventLoop();

	///////////////////////////////////////////////////////////
	// 程序反初始化

	Shutdown();

	///////////////////////////////////////////////////////////
	// 返回操作系统

	return static_cast<int>(wParamQuit);
	} // end WinMain



//-----------------------------------------------------------------------------
// Name: Init()
// Desc: 程序初始化
//       返回-1表示已存在同名互斥体
//-----------------------------------------------------------------------------
int Init()
	{
	///////////////////////////////////////////////////////////
	// 创建互斥体
	// 如果已存在该互斥体，则向本程序的另一个实例的主窗口发送创建新的游戏进程的消息
	// 如果有多个已存在实例（正常运行时不可能），则只向第一个找到的发送消息
	// 不保留句柄，该句柄在进程终止后会自动关闭，而且最好在最后关闭

	CreateMutex(NULL, false, gcMUTEX_NAME);

	// 已存在该互斥体
	if (GetLastError() == ERROR_ALREADY_EXISTS)
		{
		// 寻找另一个实例的主窗口
		HWND hWnd = FindWindow(gcMAIN_WND_CLASS_NAME, gcMAIN_WND_TITLE);   
		if (hWnd == NULL)
			return -2;		// 可能函数调用失败，也可能该实例还没建立主窗口

		// 向另一个实例的主窗口发送创建新的游戏进程的消息
		if (PostMessage(hWnd, nWM_CREATE_GAME_WND, nWPARAM_CREATE_GAME_WND, nLPARAM_CREATE_GAME_WND) == 0)
			return -3;

		return -1;
		}

	///////////////////////////////////////////////////////////
	// 把当前路径设置为当前执行文件路径

	if (Set_Process_Dir_to_Exe_Dir() != 0)
		return -4;

	///////////////////////////////////////////////////////////
	// 初始化文件记录

	if (g_Log.Init_File() != 0)
		return -5;

	// 设置默认记录方式
	g_Log.Set(TAR_FILE, PRE_TIME_MS);

	///////////////////////////////////////////////////////////
	// 载入程序设置

	if (g_Cfg.Load() != 0)
		{
		g_Log.Write("载入设置失败\r\n");
		return -6;
		}

	return 0;
	} // end Init



//-----------------------------------------------------------------------------
// Name: Shutdown()
// Desc: 程序反初始化
//-----------------------------------------------------------------------------
void Shutdown()
	{
	// 等待非游戏窗口子线程退出
	;

	// 关闭非游戏窗口子线程句柄
	;
	} // end Shutdown



//-----------------------------------------------------------------------------
// Name: RegMainWndClass()
// Desc: 创建并注册主窗口类
//-----------------------------------------------------------------------------
int RegMainWndClass()
	{
	// 填充窗口类结构体
	WNDCLASSEX winclass;
	winclass.cbSize         = sizeof(WNDCLASSEX);
	winclass.style			= CS_DBLCLKS | CS_OWNDC | CS_HREDRAW | CS_VREDRAW;
	winclass.lpfnWndProc	= MainWndProc;
	winclass.cbClsExtra		= 0;
	winclass.cbWndExtra		= 0;
	winclass.hInstance		= g_hInstance;
	winclass.hIcon			= LoadIcon(NULL, IDI_APPLICATION);
	winclass.hCursor		= LoadCursor(NULL, IDC_ARROW);
	winclass.hbrBackground	= (HBRUSH)GetStockObject(BLACK_BRUSH);
	winclass.lpszMenuName	= NULL;
	winclass.lpszClassName	= gcMAIN_WND_CLASS_NAME;
	winclass.hIconSm        = LoadIcon(NULL, IDI_APPLICATION);

	// 注册窗口类
	if (!RegisterClassEx(&winclass))
		return -1;

	return 0;
	} // end RegMainWndClass



//-----------------------------------------------------------------------------
// Name: CreateMainWnd()
// Desc: 创建主窗口
//       主窗口是隐形的
//-----------------------------------------------------------------------------
int CreateMainWnd()
	{
	sg_hMainWnd = CreateWindowEx(0,			// 窗口扩展样式
		gcMAIN_WND_CLASS_NAME,				// 窗口类名
		gcMAIN_WND_TITLE,					// 窗口名
		WS_POPUP,							// 窗口样式
		0, 0,								// 窗口左上角位置
		0, 0,								// 窗口宽高
		NULL,								// 父窗口句柄
		NULL,								// 菜单句柄
		g_hInstance,						// 程序实例句柄
		NULL);								// 可选参数，可在WM_CREATE消息中接收
	if (sg_hMainWnd == NULL)
		return -1;

	return 0;
	} // end CreateMainWnd



//-----------------------------------------------------------------------------
// Name: MainWndEventLoop()
// Desc: 主窗口消息循环
//       在所有主线程创建的线程结束后，主窗口会被关闭
//-----------------------------------------------------------------------------
WPARAM MainWndEventLoop()
	{
	while (true)
		{
		// 有消息就处理，直到暂时没有消息到来
		MSG msg;
		while (PeekMessage(&msg, NULL, 0, 0, PM_REMOVE))
			{
            if (msg.message == WM_QUIT)
                return msg.wParam;
			DispatchMessage(&msg);
			}

		// 等待子线程退出或本线程消息到来
		DWORD result = MsgWaitForMultipleObjects(
			sg_nGameWndThread, sg_ghGameWndThread, false, INFINITE, QS_ALLINPUT);

		//-------------------------------------------**********
		if (sg_nGameWndThread == 0)
			g_Log.Write("MsgWaitForMultipleObjects()等待的对象为0, 返回0x%X\r\n", result);
		//-------------------------------------------**********

		// 本线程消息到来
		if (result == WAIT_OBJECT_0 + sg_nGameWndThread)
			{}
		// 某个游戏窗口线程退出
		else if (result >= WAIT_OBJECT_0 && result < WAIT_OBJECT_0 + sg_nGameWndThread)
			{
			// 该游戏窗口线程编号
			int nThreadIndex = result - WAIT_OBJECT_0;

			// 关闭该游戏窗口线程的句柄，并整理句柄列表
			CloseGameWndThreadHandleByIndex(nThreadIndex);

			// 游戏窗口线程数减一
			--sg_nGameWndThread;

			// 所有游戏窗口线程都已退出
			if (sg_nGameWndThread == 0)
				{
				// 通知其他子线程关闭
				;

				// 关闭主窗口
				PostMessage(sg_hMainWnd, WM_CLOSE, 0, 0);
				}
			}
		// 其他情况，可能某个对象是被遗弃的互斥体，可能函数调用失败
		else
			{
			g_Log.Write("主窗口消息循环：MsgWaitForMultipleObjects()返回意外结果0x%X\r\n", result);
			PostMessage(sg_hMainWnd, WM_CLOSE, 0, 0);
			}
		} // end while
	} // end MainWndEventLoop



//-----------------------------------------------------------------------------
// Name: CreateGameWndThread()
// Desc: 创建游戏窗口线程
//-----------------------------------------------------------------------------
int CreateGameWndThread()
	{
	// 游戏窗口线程数目已达到上限
	if (sg_nGameWndThread >= nMAX_GAME_WND_THREAD)
		{
		g_Log.Write("游戏窗口数目已达上限，创建游戏窗口失败\r\n");
		return 0;
		}

	// 创建游戏窗口线程
	HANDLE hGameWndThread = CreateThread(NULL, 0, &GameWndThreadProc, NULL, 0, NULL);
	if (hGameWndThread == NULL)
		{
		g_Log.Write("游戏窗口线程创建失败\r\n");
		return -1;
		}

	// 保存游戏窗口线程句柄
	sg_ghGameWndThread[sg_nGameWndThread] = hGameWndThread;

	// 增加游戏窗口线程数目
	++sg_nGameWndThread;

	return 0;
	} // end CreateGameWndThread



//-----------------------------------------------------------------------------
// Name: GameWndThreadProc()
// Desc: 游戏窗口线程处理函数
//-----------------------------------------------------------------------------
DWORD WINAPI GameWndThreadProc(LPVOID lpParameter)
	{
	// 创建游戏窗口对象
	CGameWindow GameWnd;

	// 初始化游戏窗口对象
	if (GameWnd.Init() != 0)
		{
		g_Log.Write("游戏窗口对象初始化失败\r\n");
		return -1;
		}

	// 游戏窗口消息循环
	CGameWindow::EventLoop();

	return 0;
	} // end GameWndThreadProc



//-----------------------------------------------------------------------------
// Name: MainWndProc()
// Desc: 主窗口消息处理函数
//-----------------------------------------------------------------------------
LRESULT CALLBACK MainWndProc(HWND hwnd, UINT msg, WPARAM wparam, LPARAM lparam)
	{
	switch(msg)
		{
		// 窗口已创建但还未显示
		case WM_CREATE:
			{
			// 创建游戏窗口线程，失败则返回初始化不成功
			if (CreateGameWndThread() != 0)
				return -1;
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

		// 创建新的游戏进程
		case nWM_CREATE_GAME_WND:
			{
			// 如果参数一致，则创建游戏进程
			// 如果创建失败，创建函数内会把信息记录到日志，程序照常运行
			if (wparam == nWPARAM_CREATE_GAME_WND && lparam == nLPARAM_CREATE_GAME_WND)
				CreateGameWndThread();
			return 0;
			}

		// 准备关闭窗口
		case WM_CLOSE:
			{
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
	} // end MainWndProc



//-----------------------------------------------------------------------------
// Name: CloseGameWndThreadHandleByIndex()
// Desc: 通过索引关闭游戏窗口线程的句柄，并整理句柄列表
//       每个游戏窗口线程句柄关闭时，都必须调用这个函数，否则整理会无效
//-----------------------------------------------------------------------------
void CloseGameWndThreadHandleByIndex(int const nThreadIndex)
	{
	assert(nThreadIndex >= 0 && nThreadIndex <= nMAX_GAME_WND_THREAD -1);

	///////////////////////////////////////////////////////////
	// 关闭该游戏窗口线程的句柄

	if (CloseHandle(sg_ghGameWndThread[nThreadIndex]) == 0)
		g_Log.Write("关闭游戏窗口线程句柄失败\r\n");
	sg_ghGameWndThread[nThreadIndex] = NULL;

	///////////////////////////////////////////////////////////
	// 整理句柄在句柄列表中的顺序
	// 找到最后一个有效句柄，如果该有效句柄在刚关闭的句柄之后，则调换两者位置
	// 如果没有找到有效句柄，则只可能是如下情况：刚关闭的句柄本身就在列表最后，或在所有有效句柄之后
	// 这些情况下无须调换

	// 从最后一个位置往前找有效句柄，直到刚关闭的句柄的位置
	int i = nMAX_GAME_WND_THREAD -1;
	for (; i > nThreadIndex; --i)
		{
		// 找到有效句柄，调换位置后跳出循环
		if (sg_ghGameWndThread[i] != NULL)
			{
			sg_ghGameWndThread[nThreadIndex] = sg_ghGameWndThread[i];
			sg_ghGameWndThread[i] = NULL;
			break;
			}
		}
	} // end CloseGameWndThreadHandleByIndex
