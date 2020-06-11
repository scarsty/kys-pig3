//-----------------------------------------------------------------------------
// 程序设置文件对象
// 由于ini相关函数只支持读写有符号数，先读为int再转换为其他形式
// 如果需要的数位大于int，则只能读取字串再手动转换了
//-----------------------------------------------------------------------------

#ifndef CONFIG
#define CONFIG

// INCLUDES ///////////////////////////////////////////////////////////////////

#define WIN32_LEAN_AND_MEAN

#include <windows.h>
#include <stdio.h>
#include <assert.h>

// DEFINES ////////////////////////////////////////////////////////////////////
// MACROS /////////////////////////////////////////////////////////////////////
// TYPES //////////////////////////////////////////////////////////////////////
// CLASS //////////////////////////////////////////////////////////////////////

// 程序设置对象
class CConfig
	{
	public:
		CConfig()
			{
			m_gcCfgFn[0] = '\0';		// 文件名清零
			}
		~CConfig()
			{
			Save();		// 程序就要退出了，所以这里出错了也不管了，最多记录到日志文件中
			}

		// 从文件载入设置
		int Load();
		// 把当前设置修改为默认设置
		void Reset();
		// 保存当前设置到文件
		int Save();

		// Config段
		int  m_nFrameWidth;				// 画面宽度
		int  m_nFrameHeight;			// 画面高度
		int  m_nFrameRate;				// 主模块帧率（设为0时表示不限制帧率）
		int  m_nFrameBpp;				// 画面色深
		bool m_bFullScreen;				// 画面是否全屏模式
		bool m_bVSync;					// 画面是否垂直同步

		// World Map段
		char m_fnMmapGrp[MAX_PATH],		// 世界地图相关文件名
			 m_fnMmapIdx[MAX_PATH],
			 m_fnMmapCol[MAX_PATH],
			 m_fnEarth[MAX_PATH],
			 m_fnSurface[MAX_PATH],
			 m_fnBuilding[MAX_PATH],
			 m_fnBuildx[MAX_PATH],
			 m_fnBuildy[MAX_PATH];

	private:
		char m_gcCfgFn[MAX_PATH];		// 设置文件名
	};

// PROTOTYPES /////////////////////////////////////////////////////////////////
// EXTERNALS //////////////////////////////////////////////////////////////////
// GLOBALS ////////////////////////////////////////////////////////////////////
// FUNCTIONS //////////////////////////////////////////////////////////////////

#endif // CONFIG