//-----------------------------------------------------------------------------
// 记录信息到各种对象（控制台、文件、控件）
//-----------------------------------------------------------------------------

#ifndef FH_LOG
#define FH_LOG

// INCLUDES ///////////////////////////////////////////////////////////////////

#define WIN32_LEAN_AND_MEAN

#include <windows.h>
#include <stdio.h>
#include <stdlib.h>
#include <assert.h>

// DEFINES ////////////////////////////////////////////////////////////////////

#define LOG_BUFFER_SIZE		1024		// 一次输入的文字最大长度

// 日志的输出对象
#define TAR_NULL			0
#define TAR_CONSOLE			(1 << 0)		// 控制台
#define TAR_FILE			(1 << 1)		// 文件
#define TAR_EDIT_CONTROL	(1 << 2)		// Edit控件

// MACROS /////////////////////////////////////////////////////////////////////
// TYPES //////////////////////////////////////////////////////////////////////

// 日志前缀，输出日志前先输出的文字
// 输出的时间均为本地时间
enum LOG_PREFIX
	{
	PRE_NULL,
	PRE_DATE,				// 本地时间
	PRE_DATE_TIME,
	PRE_TIME,
	PRE_TIME_MS,
	PRE_RELATIVE_DAY_TIME,	// 相对时间，最多计算到49天
	PRE_RELATIVE_TIME_MS,
	PRE_RELATIVE_S_MS
	};

// CLASS //////////////////////////////////////////////////////////////////////

class CLog
	{
	public:
		CLog()
			{
			_tick_count_start = GetTickCount();		// 必须在程序开头构造该类，否则相对时间会有偏差
			_target = TAR_CONSOLE;
			_prefix = PRE_NULL;
			_h_file = NULL;
			_h_edit_control = NULL;
			}

		~CLog()
			{
			if (_h_file)
				CloseHandle(_h_file);
			}

		// 设置默认记录方式（往哪儿输出，输出前缀是什么）
		// 此处不检查该方式是否已经初始化，因此设置可以在目标初始化之前进行
		void Set(DWORD log_target, LOG_PREFIX log_prefix)
			{
			_target = log_target;
			_prefix = log_prefix;
			}

		// 初始化Log输出目标（控制台不用初始化）
		// 初始化用于日志输出的文件
		int Init_File(const char *log_file_name = NULL);
		// 初始化用于日志输出的Edit控件
		int Init_Edit_Control(HWND hEditControl);

		// 反初始化Log输出目标（可以不反初始化，析构函数能完成所有清理工作）
		// 反初始化用于日志输出的文件
		void Uninit_File()
			{
			// 关闭文件，清空句柄
			if (_h_file)
				{
				CloseHandle(_h_file);
				_h_file = NULL;
				}
			// 清除目标位
			_target &= ~TAR_FILE;
			}
		// 反初始化用于日志输出的Edit控件（控件可能在程序退出之前关闭）
		void Uninit_Edit_Control()
			{
			// 清空句柄，清除目标位
			_h_edit_control = NULL;
			_target &= ~TAR_EDIT_CONTROL;
			}

		// 记录日志信息，输出对象和输出前缀可以使用默认值
		// 两个函数的代码有非常大的重复，但由于可变参数的原因无法提取到函数中，用宏又太麻烦
		int Write(const char *str, ...);
		int Write(DWORD log_target, LOG_PREFIX log_prefix, const char *str, ...);

	private:
		// 按样式输出前缀到缓冲区
		int _Sprint_Prefix(LOG_PREFIX log_prefix);

		// 各对象的数据记录方法
		int _Write_Console(const char *buffer, int count);
		int _Write_File(const char *buffer, int count);
		int _Write_Edit_Control(const char *buffer, int count);

		char _buffer[LOG_BUFFER_SIZE];		// 日志数据的缓冲空间
		DWORD _target;						// Log信息的默认输出目标
		LOG_PREFIX _prefix;					// 输出Log信息时的默认前缀
		DWORD _tick_count_start;			// 程序开始运行时系统已运行的毫秒数
		HANDLE _h_file;						// 用于日志输出的文件的句柄
		HWND _h_edit_control;				// 用于日志输出的Edit控件的句柄
	};

// PROTOTYPES /////////////////////////////////////////////////////////////////
// GLOBALS ////////////////////////////////////////////////////////////////////
// FUNCTIONS //////////////////////////////////////////////////////////////////

#endif // FH_LOG