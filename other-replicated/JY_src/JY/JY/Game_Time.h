//-----------------------------------------------------------------------------
// 游戏时间控制
// 在多处理器系统中，一个线程只会与一个处理器关联
// 毫秒数与帧数的转换：只在精确固定帧数且不丢帧时才准确，因此没有意义
//-----------------------------------------------------------------------------

#ifndef GAME_TIME
#define GAME_TIME

// INCLUDES ///////////////////////////////////////////////////////////////////

#define WIN32_LEAN_AND_MEAN

#include <windows.h>
#include <stdio.h>
#include <assert.h>

#include "Game_Public.h"
#include "FH_Bit.h"

// DEFINES ////////////////////////////////////////////////////////////////////

// 时间对象状态
#define GT_ALLOW_DROP_FRAME		(1 << 0)		// 允许丢帧
#define GT_RUNNING_SLOWLY		(1 << 1)		// 主模块当前运行速度比预期慢
#define GT_DROPPED_THIS_FRAME	(1 << 31)		// 已丢弃当前帧

// MACROS /////////////////////////////////////////////////////////////////////
// TYPES //////////////////////////////////////////////////////////////////////
// CLASS //////////////////////////////////////////////////////////////////////

class CGameTime
	{
	public:
		CGameTime() : m_nState(0) {}
		~CGameTime() {}

		int Init(DWORD nFrameRate);
		// 等待到规定时间（结束本帧）
		int Pass();
		// （游戏暂停又恢复时）恢复游戏时间
		int Restore();
		// 返回是否需要丢帧
		bool ShouldDropThisFrame();
		// 声明丢掉当前帧
		void AnnounceDropThisFrame();
		// 获得当前CPU计数
		int GetCurrentCpuCount(LONGLONG *pnCpuCount);
		// 把毫秒转换为CPU计数
		LONGLONG MsToCpuCount(DWORD ms);
		// 直接返回1秒的CPU计数
		LONGLONG CpuCount1s();

		// 检查时间对象状态
		DWORD Check(DWORD bits) {return CHECK_BIT(m_nState, bits);}

#ifdef DEBUG
		float m_fFpsMain;						// 每秒帧数（主模块）
		float m_fFpsImage;						// 每秒帧数（主模块中的显示图像，真正的FPS）
		float m_fPercent;						// 一秒内某操作所用时间的百分比
#endif // DEBUG

	private:
		DWORD m_nState;							// 时间对象状态（位域变量）
		LONGLONG m_nCPUFreq;					// 每秒的CPU时间计数（固定，但声明成静态成员又太麻烦了）
		LONGLONG m_nCPUFreqFrame;				// 每帧的额定CPU时间计数
		LONGLONG m_nCPUCounterLastFrame;		// 上一帧时记录的CPU时间总计数

#ifdef DEBUG
		DWORD m_nFramesMain;					// 上一秒到现在经过的帧数（主模块）
		DWORD m_nFramesImage;					// 上一秒到现在经过的帧数（主模块中的显示图像）
		LONGLONG m_nCPUCounterLastSecond;		// 上一秒时记录的CPU时间总计数
#endif // DEBUG
	};

// PROTOTYPES /////////////////////////////////////////////////////////////////
// EXTERNALS //////////////////////////////////////////////////////////////////
// GLOBALS ////////////////////////////////////////////////////////////////////
// FUNCTIONS //////////////////////////////////////////////////////////////////

//-----------------------------------------------------------------------------
// Name: Init()
// Desc: 初始化游戏时间
//       需要传入帧率，帧率为0表示不作限制
//-----------------------------------------------------------------------------
inline int CGameTime::Init(DWORD const nFrameRate)
	{
	// 获取CPU频率
	LARGE_INTEGER Counter;
	if (QueryPerformanceFrequency(&Counter) == 0)
		return -1;
	m_nCPUFreq = Counter.QuadPart;

	// 计算每帧的额定CPU时间计数
	// 不限制帧率时每帧的额定CPU时间计数为0，也不允许丢帧（没有丢帧的标准）
	if (nFrameRate != 0)
		{
		m_nCPUFreqFrame = m_nCPUFreq / nFrameRate;
		SET_BIT(m_nState, GT_ALLOW_DROP_FRAME);
		}
	else
		{
		m_nCPUFreqFrame = 0;
		RESET_BIT(m_nState, GT_ALLOW_DROP_FRAME);
		}

	// 初始化上一帧时间计数
	if (QueryPerformanceCounter(&Counter) == 0)
		return -2;
	m_nCPUCounterLastFrame = Counter.QuadPart;

	#ifdef DEBUG
	// 初始化调试信息相关变量
	m_fFpsMain = 0.0;
	m_fFpsImage = 0.0;
	m_fPercent = 0.0;

	m_nFramesMain = 0;
	m_nFramesImage = 0;

	// 初始化上一秒时间计数
	m_nCPUCounterLastSecond = Counter.QuadPart;
	#endif // DEBUG

	return 0;
	} // end Init



//-----------------------------------------------------------------------------
// Name: Pass()
// Desc: 等待到规定时间（结束本帧）
//       获取本次循环所用时间，不够规定的时间则等待，直到够为止；够则直接返回
//-----------------------------------------------------------------------------
inline int CGameTime::Pass()
	{
	// 获取当前CPU时间总计数
	LARGE_INTEGER Counter;
	if (QueryPerformanceCounter(&Counter) == 0)
		return -1;

	// 如果设定为固定帧数，则等待到规定时间
	if (m_nCPUFreqFrame != 0)
		{
		// 当前时间已到达或超过本帧规定结束时间的***2倍***时，设置游戏过慢标志
		if (Counter.QuadPart - m_nCPUCounterLastFrame >= m_nCPUFreqFrame *2)
			SET_BIT(m_nState, GT_RUNNING_SLOWLY);
		// 否清除游戏过慢标志，等待到达规定时间
		else
			{
			RESET_BIT(m_nState, GT_RUNNING_SLOWLY);
			while (Counter.QuadPart - m_nCPUCounterLastFrame < m_nCPUFreqFrame)
				{
				Sleep(1);
				if (QueryPerformanceCounter(&Counter) == 0)
					return -1;
				}
			}
		// 把经过修正的当前时间作为下一帧的开始计数
		// 以没有浪费时间的情况去要求下一帧，以保持记录的精确
		m_nCPUCounterLastFrame += m_nCPUFreqFrame;
		}

#ifdef DEBUG
	// 主模块帧数增加1
	++m_nFramesMain;

	// 如果没有丢掉当前帧，则显示图像帧数增加1
	if (!CHECK_BIT(m_nState, GT_DROPPED_THIS_FRAME))
		++m_nFramesImage;

	// 经过一秒后算出上一秒平均帧数
	if (Counter.QuadPart - m_nCPUCounterLastSecond  >= m_nCPUFreq)
		{
		float tmp = (float)m_nCPUFreq / (Counter.QuadPart - m_nCPUCounterLastSecond);
		m_fFpsMain = m_nFramesMain * tmp;
		m_fFpsImage = m_nFramesImage * tmp;
		// 帧数清零
		m_nFramesMain = 0;
		m_nFramesImage = 0;
		// 把当前计数作为下一秒的开始计数
		m_nCPUCounterLastSecond = Counter.QuadPart;
		}

	// 恢复丢帧状态，为下一帧作准备
	RESET_BIT(m_nState, GT_DROPPED_THIS_FRAME);
#endif // DEBUG

	return 0;
	} // end Pass



//-----------------------------------------------------------------------------
// Name: Restore()
// Desc: （游戏暂停又恢复时）恢复游戏时间
//-----------------------------------------------------------------------------
inline int CGameTime::Restore()
	{
	LARGE_INTEGER Counter;
	if (QueryPerformanceCounter(&Counter) == 0)
		return -1;

	// 更新上一帧时间计数
	m_nCPUCounterLastFrame = Counter.QuadPart;

#ifdef DEBUG
	// 帧数清零
	m_nFramesMain = 0;
	m_nFramesImage = 0;
	// 更新上一秒时间计数
	m_nCPUCounterLastSecond = Counter.QuadPart;
#endif // DEBUG

	return 0;
	} // end Restore



//-----------------------------------------------------------------------------
// Name: ShouldDropThisFrame()
// Desc: 返回是否需要丢帧（跳过当前帧的画面绘制）
//       如果允许丢帧且速度过慢，则丢帧；否则不丢帧
//-----------------------------------------------------------------------------
inline bool CGameTime::ShouldDropThisFrame()
	{
	if (CHECK_BIT(m_nState, GT_ALLOW_DROP_FRAME) && CHECK_BIT(m_nState, GT_RUNNING_SLOWLY))
		return true;
	else
		return false;
	}



//-----------------------------------------------------------------------------
// Name: AnnounceDropThisFrame()
// Desc: 声明丢掉当前帧
//-----------------------------------------------------------------------------
inline void CGameTime::AnnounceDropThisFrame()
	{
#ifdef DEBUG
	SET_BIT(m_nState, GT_DROPPED_THIS_FRAME);
#endif // DEBUG
	}



//-----------------------------------------------------------------------------
// Name: GetCurrentCpuCount()
// Desc: 获得当前CPU计数
//-----------------------------------------------------------------------------
inline int CGameTime::GetCurrentCpuCount(LONGLONG * const pnCpuCount)
	{
	assert(pnCpuCount);

	LARGE_INTEGER Counter;
	if (QueryPerformanceCounter(&Counter) == 0)
		return -1;
	*pnCpuCount = Counter.QuadPart;
	return 0;
	}



//-----------------------------------------------------------------------------
// Name: MsToCpuCount()
// Desc: 把毫秒转换为CPU计数
//-----------------------------------------------------------------------------
inline LONGLONG CGameTime::MsToCpuCount(DWORD const ms)
	{
	static LONGLONG nCPUFreqMs = m_nCPUFreq / 1000;
	return (nCPUFreqMs * ms);
	}



//-----------------------------------------------------------------------------
// Name: CpuCount1s()
// Desc: 直接返回1秒的CPU计数
//-----------------------------------------------------------------------------
inline LONGLONG CGameTime::CpuCount1s()
	{
	return m_nCPUFreq;
	}

#endif // GAME_TIME