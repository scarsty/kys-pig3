
// INCLUDES ///////////////////////////////////////////////////////////////////

#include <vector>

#include "FH_Log.h"

// DEFINES ////////////////////////////////////////////////////////////////////
// TYPES //////////////////////////////////////////////////////////////////////

// 窗口的句柄与默认消息处理函数地址
typedef struct _Wnd_Handle_And_Def_Proc
	{
	HWND hwnd;
	WNDPROC def_wnd_proc;
	} Wnd_Handle_And_Def_Proc;

// PROTOTYPES /////////////////////////////////////////////////////////////////

INT_PTR CALLBACK Edit_Control_Proc(HWND hDlg, UINT msg, WPARAM wParam, LPARAM lParam);
void Save_Def_Wnd_Proc(HWND hwnd, WNDPROC def_wnd_proc);
WNDPROC Load_Def_Wnd_Proc(HWND hwnd);

// EXTERNALS //////////////////////////////////////////////////////////////////
// GLOBALS ////////////////////////////////////////////////////////////////////

// 窗口的句柄与默认消息处理函数地址对应表
std::vector<Wnd_Handle_And_Def_Proc> Vec_Wnd_Handle_And_Def_Proc;

// FUNCTIONS //////////////////////////////////////////////////////////////////

//-----------------------------------------------------------------------------
// Name: Init_File()
// Desc: Log文件初始化
//       传入的文件名为空时，Log文件名为当前执行文件名.log，路径和当前进程相同
//       该文件可以在使用时被用户打开查看内容，但不能修改
//
//返回值：
// 0	正常返回
//-1	之前已执行过初始化
//-2~-4	无法生成Log文件名
//-5	无法打开或创建Log文件
//-----------------------------------------------------------------------------
int CLog::Init_File(const char *log_file_name)
	{
	// 传入的文件名地址不为空的话，其指向的字符串就不能为空
	assert( log_file_name == NULL || (log_file_name && *log_file_name) );

	if (_h_file) return -1;		// 之前已执行过初始化

	// 传入的文件名地址为空时，创建默认Log文件名
	char default_log_file_name[_MAX_PATH];
	if (log_file_name == NULL)
		{
		// 获得当前执行文件完整路径
		char self_name[MAX_PATH];
		const DWORD self_name_len = GetModuleFileName(NULL, self_name, MAX_PATH);
		if (self_name_len == 0 || self_name_len == MAX_PATH)
			return -2;		// 获得当前执行文件完整路径出错

		// 提取当前执行文件完整路径中的文件名
		char fname[_MAX_FNAME];
		errno_t err = _splitpath_s(self_name, NULL, 0, NULL, 0, fname, _MAX_FNAME, NULL, 0);
		if (err != 0) return -3;	// 分解路径出错

		// 合并Log文件名，扩展名为".log"
		err = _makepath_s(default_log_file_name, _MAX_PATH, NULL, NULL, fname, ".log");
		if (err != 0) return -4;	// 合并路径出错

		// 把Log文件名地址指向默认Log文件名
		log_file_name = default_log_file_name;
		}

	// 打开Log文件
	HANDLE hFile = CreateFile(log_file_name,
							  GENERIC_WRITE,
							  FILE_SHARE_READ,
							  NULL,
							  OPEN_ALWAYS,
							  FILE_ATTRIBUTE_NORMAL,
							  NULL);
	if (hFile == INVALID_HANDLE_VALUE) return -5;		// 无法打开或创建Log文件

	// 文件指针移到文件末尾（即写入方式为附加）
	SetFilePointer(hFile, 0, NULL, FILE_END);

	// 在成功初始化之后才接受文件句柄
	_h_file = hFile;
	return 0;
	} // end Init_File



//-----------------------------------------------------------------------------
// Name: Init_Edit_Control()
// Desc: 初始化用于日志输出的Edit控件（不包含Rich Edit控件）
//       控件由调用者创建，控件样式需求：能垂直滚动(ES_AUTOVSCROLL / WS_VSCROLL)、能显示多行(ES_MULTILINE)
//
//返回值：
// 0	正常返回
// -1	之前已执行过初始化
// -2	获取控件原有样式失败，或者原样式为空
// -3	控件样式不合要求
// -4	修改控件样式失败
// -5	刷新控件样式失败
// -6	无法替换控件消息处理函数
//-----------------------------------------------------------------------------
int CLog::Init_Edit_Control(HWND const hEditControl)
	{
	assert(hEditControl);

	if (_h_edit_control) return -1;		// 之前已执行过初始化

	///////////////////////////////////////////////////////////
	// 检测并修改控件样式

	// 获取控件原有样式
	// 本函数失败时返回0，如果要返回的值本身就是0也会返回0
	DWORD Pre_Control_Style = static_cast<DWORD>( GetWindowLongPtr(hEditControl, GWL_STYLE) );
	if (Pre_Control_Style == 0) return -2;		// 获取控件原有样式失败，或者原样式为空

	// 检测样式是否满足需要
	if (!(Pre_Control_Style & ES_AUTOVSCROLL || Pre_Control_Style & WS_VSCROLL) ||
		!(Pre_Control_Style & ES_MULTILINE))
		return -3;		// 控件样式不合要求

	// 修改可在创建后修改的样式：去掉“能用Tab切换到该控件”
	DWORD Control_Style = Pre_Control_Style;
	Control_Style &= ~WS_TABSTOP;

	// 设置已修改的样式
	// 本函数失败时返回0，如果要返回的值本身就是0也会返回0
	Pre_Control_Style = static_cast<DWORD>( SetWindowLongPtr(hEditControl, GWL_STYLE, Control_Style) );
	if (Pre_Control_Style == 0) return -4;		// 修改控件样式失败（原样式不会为空，若为空前面已经返回了）

	// 刷新控件样式
	DWORD result = SetWindowPos(hEditControl, 0, 0, 0, 0, 0,
								SWP_NOMOVE | SWP_NOSIZE | SWP_NOZORDER | SWP_FRAMECHANGED);
	if (result == 0) return -5;		// 刷新控件样式失败

	///////////////////////////////////////////////////////////
	// 调整控件属性

	// 设置控件可输入字符数为最大
	SendMessage(hEditControl, EM_SETLIMITTEXT, 0, 0);

	///////////////////////////////////////////////////////////
	// 自定控件消息处理函数

	// 用自定消息处理函数代替默认消息处理函数
	// 本函数失败时返回0，如果要返回的值本身就是0也会返回0
	// 但有效的函数地址不可能为0，因此返回0就说明失败
	WNDPROC DefControlProc = reinterpret_cast<WNDPROC>(
		SetWindowLongPtr(hEditControl, GWLP_WNDPROC, reinterpret_cast<LONG>(Edit_Control_Proc)) );
	if (DefControlProc == 0) return -6;		// 无法替换控件消息处理函数

	// 保存当前控件的默认消息处理函数地址
	Save_Def_Wnd_Proc(hEditControl, DefControlProc);

	// 在成功初始化之后才接受控件句柄
	_h_edit_control = hEditControl;
	return 0;
	} // end Init_Edit_Control



//-----------------------------------------------------------------------------
// Name: Write()
// Desc: 输出包含指定前缀的日志信息到指定目标
//       首先把信息转化为字符串输出到缓冲区，然后调用各目标的输出方法
//       目标可以为多个，如果输出目标中有未被初始化的，则忽略该目标，不返回错误
//       换行统一写成\r\n
//
// 如果传入的输出目标包含无效位，且不包含被初始化的目标，则数据依然会输出到缓冲区。
// 但如果传入的目标都是有效的（即用宏定义的），则可以保证传入的目标都没有被初始化时函数立即返回。
// 即，可以在写代码时加入很多输出到文件的语句，但只要在程序开始时不初始化Log文件，就几乎没有时间损失。
//
// 返回值（只指示出最后一个错误）
// 0	正常返回
// -1	写入前缀到缓冲区失败
// -2	写入传入信息到缓冲区失败
// -101~-200	输出到控制台出错
// -201~-300	输出到文件出错
// -301~-400	输出到Edit控件出错
//-----------------------------------------------------------------------------
int CLog::Write(DWORD log_target, LOG_PREFIX const log_prefix, const char * const str, ...)
	{
	assert(str);

	// 除掉传入的输出目标中的无效目标
	// 如果目标句柄无效，则直接将输出目标中的对应位清零
	if (_h_file == NULL)			log_target &= ~TAR_FILE;
	if (_h_edit_control == NULL)	log_target &= ~TAR_EDIT_CONTROL;

	if (log_target == NULL) return 0;		// 输出目标为空

	///////////////////////////////////////////////////////////
	// 把信息输出到缓冲区

	// 按样式输出前缀到缓冲区，记录写入缓冲区的前缀字符数
	int count_pre = _Sprint_Prefix(log_prefix);
	if (count_pre < 0) return -1;		// 写入前缀到缓冲区失败

	// 把传入信息输出到缓冲区，位置在前缀的后面
	va_list arglist;
	va_start(arglist, str);
	int count = vsprintf_s(_buffer + count_pre, LOG_BUFFER_SIZE - count_pre, str, arglist);
	va_end(arglist);
	if (count < 0) return -2;		// 写入传入信息到缓冲区失败

	// 计算缓冲区中总共被写入的字符数（不包含结尾空字符）
	// sprintf_s()保证输出数据以空字符结尾，因此总字符数一定比缓冲区size小
	int total_count = count_pre + count;

	///////////////////////////////////////////////////////////
	// 缓冲区已写入完毕，调用各目标相应的方法记录数据

	// 数据可能要输出到多个目标，不能因为一个目标出错就返回，但又要指示错误情况，因此要用到返回值变量
	// 返回值变量只能指示出最后一个错误
	int ret_val = 0;

	// 输出到控制台
	if (log_target & TAR_CONSOLE)
		{
		int result = _Write_Console(_buffer, total_count);
		if (result != 0) ret_val = -100 + result;		// 输出到控制台出错
		}

	// 输出到文件
	if (log_target & TAR_FILE)
		{
		int result = _Write_File(_buffer, total_count);
		if (result != 0) ret_val = -200 + result;		// 输出到文件出错
		}

	// 输出到Edit控件
	if (log_target & TAR_EDIT_CONTROL)
		{
		int result = _Write_Edit_Control(_buffer, total_count);
		if (result != 0) ret_val = -300 + result;		// 输出到Edit控件出错
		}

	return ret_val;
	} // end Write



//-----------------------------------------------------------------------------
// Name: Write()
// Desc: 输出包含默认前缀的日志信息到默认目标
//       给出默认参数后，完全照搬参数齐全的同名函数的代码
//-----------------------------------------------------------------------------
int CLog::Write(const char * const str, ...)
	{
	assert(str);

	// 给出未传入的参数
	DWORD log_target = _target;
	LOG_PREFIX const log_prefix = _prefix;

	///////////////////////////////////////////////////////////////////////////
	// 完全照搬参数齐全的同名函数的代码，那边如果修改了只需完全复制过来就行

	// 除掉传入的输出目标中的无效目标
	// 如果目标句柄无效，则直接将输出目标中的对应位清零
	if (_h_file == NULL)			log_target &= ~TAR_FILE;
	if (_h_edit_control == NULL)	log_target &= ~TAR_EDIT_CONTROL;

	if (log_target == NULL) return 0;		// 输出目标为空

	///////////////////////////////////////////////////////////
	// 把信息输出到缓冲区

	// 按样式输出前缀到缓冲区，记录写入缓冲区的前缀字符数
	int count_pre = _Sprint_Prefix(log_prefix);
	if (count_pre < 0) return -1;		// 写入前缀到缓冲区失败

	// 把传入信息输出到缓冲区，位置在前缀的后面
	va_list arglist;
	va_start(arglist, str);
	int count = vsprintf_s(_buffer + count_pre, LOG_BUFFER_SIZE - count_pre, str, arglist);
	va_end(arglist);
	if (count < 0) return -2;		// 写入传入信息到缓冲区失败

	// 计算缓冲区中总共被写入的字符数（不包含结尾空字符）
	// sprintf_s()保证输出数据以空字符结尾，因此总字符数一定比缓冲区size小
	int total_count = count_pre + count;

	///////////////////////////////////////////////////////////
	// 缓冲区已写入完毕，调用各目标相应的方法记录数据

	// 数据可能要输出到多个目标，不能因为一个目标出错就返回，但又要指示错误情况，因此要用到返回值变量
	// 返回值变量只能指示出最后一个错误
	int ret_val = 0;

	// 输出到控制台
	if (log_target & TAR_CONSOLE)
		{
		int result = _Write_Console(_buffer, total_count);
		if (result != 0) ret_val = -100 + result;		// 输出到控制台出错
		}

	// 输出到文件
	if (log_target & TAR_FILE)
		{
		int result = _Write_File(_buffer, total_count);
		if (result != 0) ret_val = -200 + result;		// 输出到文件出错
		}

	// 输出到Edit控件
	if (log_target & TAR_EDIT_CONTROL)
		{
		int result = _Write_Edit_Control(_buffer, total_count);
		if (result != 0) ret_val = -300 + result;		// 输出到Edit控件出错
		}

	return ret_val;
	//
	///////////////////////////////////////////////////////////////////////////
	} // end Write



//-----------------------------------------------------------------------------
// Name: _Sprint_Prefix()
// Desc: 按样式输出前缀到缓冲区
//       返回输出的字符数，不包括结尾空字符。如果输出失败，则返回负值
//-----------------------------------------------------------------------------
int CLog::_Sprint_Prefix(LOG_PREFIX const log_prefix)
	{
	int count_pre = 0;		// 写入缓冲区的前缀字符数
	switch (log_prefix)
		{
		// 无
		case PRE_NULL:
			{
			return 0;
			}
		// 日期
		case PRE_DATE:
			{
			// 获取当前时间
			SYSTEMTIME time;
			GetLocalTime(&time);
			// 输出当前日期（返回值为写入的字符数）
			count_pre = sprintf_s(_buffer, LOG_BUFFER_SIZE, "[%4d/%02d/%02d] ",
								  time.wYear, time.wMonth, time.wDay);
			break;
			}
		// 日期与时间
		case PRE_DATE_TIME:
			{
			SYSTEMTIME time;
			GetLocalTime(&time);
			count_pre = sprintf_s(_buffer, LOG_BUFFER_SIZE, "[%4d/%02d/%02d %02d:%02d:%02d] ",
								  time.wYear, time.wMonth, time.wDay,
								  time.wHour, time.wMinute, time.wSecond);
			break;
			}
		// 时间
		case PRE_TIME:
			{
			SYSTEMTIME time;
			GetLocalTime(&time);
			count_pre = sprintf_s(_buffer, LOG_BUFFER_SIZE, "[%02d:%02d:%02d] ",
								  time.wHour, time.wMinute, time.wSecond);
			break;
			}
		// 时间（带毫秒）
		case PRE_TIME_MS:
			{
			SYSTEMTIME time;
			GetLocalTime(&time);
			count_pre = sprintf_s(_buffer, LOG_BUFFER_SIZE, "[%02d:%02d:%02d.%03d] ",
								  time.wHour, time.wMinute, time.wSecond, time.wMilliseconds);
			break;
			}
		// 相对程序开始运行时的天数与时间
		case PRE_RELATIVE_DAY_TIME:
			{
			// 用“从系统启动到现在经过的毫秒数”减去“从系统启动到程序开始运行经过的毫秒数”
			DWORD ms = GetTickCount() - _tick_count_start;
			count_pre = sprintf_s(_buffer, LOG_BUFFER_SIZE, "[%d day(s) %02d:%02d:%02d] ",
								  ms/(24*60*60*1000),
								  ms/(60*60*1000)%24,(ms/(60*1000))%60, (ms/1000)%60);
			break;
			}
		// 相对程序开始运行时的时间（带毫秒）
		case PRE_RELATIVE_TIME_MS:
			{
			DWORD ms = GetTickCount() - _tick_count_start;
			count_pre = sprintf_s(_buffer, LOG_BUFFER_SIZE, "[%d:%02d:%02d.%03d] ",
								  ms/(60*60*1000), (ms/(60*1000))%60, (ms/1000)%60, ms%1000);
			break;
			}
		// 相对程序开始运行时的秒数（带毫秒）
		case PRE_RELATIVE_S_MS:
			{
			DWORD ms = GetTickCount() - _tick_count_start;
			count_pre = sprintf_s(_buffer, LOG_BUFFER_SIZE, "[%d.%03d] ", ms/1000, ms%1000);
			break;
			}
		} // end switch (log_prefix)

	return count_pre;
	} // end _Sprint_Prefix



//-----------------------------------------------------------------------------
// Name: _Write_Console()
// Desc: 记录数据到控制台
//       传入缓冲地址和输出字节数
//       换行必须写成\r\n（会在函数内转换为\n）
//-----------------------------------------------------------------------------
int CLog::_Write_Console(const char * buffer, int const count)
	{
	assert(buffer && count > 0 && count < LOG_BUFFER_SIZE);

	///////////////////////////////////////////////////////////
	// 删掉缓冲中的\r
	// 控制台内换行写作\r\n时，会多出一个\r，在控制台上看不出来，只有输出到文件才能看得到

	// 临时缓冲
	char tmp_buffer[LOG_BUFFER_SIZE];
	char *p_tmp = tmp_buffer;

	// 从原缓冲中读取数据，把除\r外的所有字符依次复制到临时缓冲中
	const char *p_buffer = buffer;
	const char * const buffer_end = buffer + count;
	while (p_buffer < buffer_end)
		{
		if (*p_buffer != '\r')
			*p_tmp++ = *p_buffer++;
		else
			++p_buffer;
		}
	// 在临时缓冲中加上结尾的空字符
	*p_tmp = '\0';

	// 把要输出的缓冲指定为临时缓冲
	buffer = tmp_buffer;

	///////////////////////////////////////////////////////////

	return printf("%s",buffer);
	}



//-----------------------------------------------------------------------------
// Name: _Write_File()
// Desc: 记录数据到文件
//       传入缓冲地址和输出字节数
//       换行必须写成\r\n
//-----------------------------------------------------------------------------
int CLog::_Write_File(const char * const buffer, int const count)
	{
	assert(buffer && count > 0 && count < LOG_BUFFER_SIZE);

	// 把数据写入文件
	DWORD nBytes;
	WriteFile(_h_file, buffer, count, &nBytes, NULL);

	// 立即保存文件缓冲区中的数据（频繁纪录数据时硬盘负荷过重，只能去掉这句）
	//FlushFileBuffers(_h_file);

	return 0;
	}



//-----------------------------------------------------------------------------
// Name: _Write_Edit_Control()
// Desc: 记录文本数据到Edit控件
//       传入缓冲地址和输出字节数（字节数暂时用不到）
//       换行必须写成\r\n
//-----------------------------------------------------------------------------
int CLog::_Write_Edit_Control(const char * const buffer, int const count)
	{
	assert(buffer && count > 0 && count < LOG_BUFFER_SIZE);

	// 把Edit控件内的光标移到最后
	SendMessage(_h_edit_control, EM_SETSEL, -1, -1);

	// 把刚生成的文字附加到Edit控件内光标所在文字处
	SendMessage(_h_edit_control, EM_REPLACESEL, false, (LPARAM)buffer);

	return 0;
	}



//-----------------------------------------------------------------------------
// Name: Edit_Control_Proc()
// Desc: 用于日志输出的Edit控件的自定消息处理函数
//-----------------------------------------------------------------------------
INT_PTR CALLBACK Edit_Control_Proc(HWND hDlg, UINT msg, WPARAM wParam, LPARAM lParam)
	{
	switch(msg)
		{
		// 所有鼠标和键盘消息
		case WM_KEYDOWN:
		case WM_KEYUP:
		case WM_LBUTTONDOWN:
		case WM_LBUTTONUP:
		case WM_LBUTTONDBLCLK:
		case WM_RBUTTONDOWN:
		case WM_RBUTTONUP:
		case WM_RBUTTONDBLCLK:
		case WM_MBUTTONDOWN:
		case WM_MBUTTONUP:
		case WM_MBUTTONDBLCLK:
			return true;

		default:
			{
			// 获取本控件的默认消息处理函数地址
			WNDPROC Def_Wnd_Proc = Load_Def_Wnd_Proc(hDlg);
			// 返回的地址为空时，说明传入的句柄出错或该句柄先前并未保存，这些错误都能被编写者避开
			assert(Def_Wnd_Proc != NULL);
			// 调用控件原来的消息处理函数
			return CallWindowProc(Def_Wnd_Proc, hDlg, msg, wParam, lParam);
			}
		}
	} // end Edit_Control_Proc



//-----------------------------------------------------------------------------
// Name: Save_Def_Wnd_Proc()
// Desc: 保存当前窗口的默认消息处理函数地址
//-----------------------------------------------------------------------------
void Save_Def_Wnd_Proc(HWND hwnd, WNDPROC def_wnd_proc)
	{
	Wnd_Handle_And_Def_Proc tmp = {hwnd, def_wnd_proc};
	Vec_Wnd_Handle_And_Def_Proc.push_back(tmp);
	}



//-----------------------------------------------------------------------------
// Name: Load_Def_Wnd_Proc()
// Desc: 获取传入的句柄代表的窗口的默认消息处理函数地址
//       返回空地址表示传入的句柄出错或该句柄先前并未保存，这些错误都能被编写者避开
//-----------------------------------------------------------------------------
WNDPROC Load_Def_Wnd_Proc(HWND hwnd)
	{
	// 遍历vector容器寻找传入句柄，找到则返回相应的函数地址
	for (std::vector<Wnd_Handle_And_Def_Proc>::iterator it = Vec_Wnd_Handle_And_Def_Proc.begin();
		 it != Vec_Wnd_Handle_And_Def_Proc.end(); ++it)
		{
		if ( (*it).hwnd == hwnd )
			return (*it).def_wnd_proc;
		}

	// 没有找到则返回空地址
	return NULL;
	}

