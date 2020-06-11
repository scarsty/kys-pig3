
// INCLUDES ///////////////////////////////////////////////////////////////////

#include "FH_File.h"

// DEFINES ////////////////////////////////////////////////////////////////////
// TYPES //////////////////////////////////////////////////////////////////////
// PROTOTYPES /////////////////////////////////////////////////////////////////
// EXTERNALS //////////////////////////////////////////////////////////////////
// GLOBALS ////////////////////////////////////////////////////////////////////
// FUNCTIONS //////////////////////////////////////////////////////////////////

//-----------------------------------------------------------------------------
// Set_Process_Dir_to_Exe_Dir()
// 把当前进程的路径设置为当前执行文件路径
// 防止程序创建的只指定了相对路径的文件的位置不在当前程序所在文件夹或子文件夹下
//-----------------------------------------------------------------------------
int Set_Process_Dir_to_Exe_Dir()
	{
	// 获得当前执行文件完整路径
	char self_name[MAX_PATH];
	const DWORD self_name_len = GetModuleFileName(NULL, self_name, MAX_PATH);
	if (self_name_len == 0 || self_name_len == MAX_PATH)
		return -1;		// 获得当前执行文件完整路径出错

	// 提取当前执行文件完整路径中的盘符和目录
	char drive[_MAX_DRIVE];
	char dir[_MAX_DIR];
	errno_t err = _splitpath_s(self_name, drive, _MAX_DRIVE, dir, _MAX_DIR, NULL, 0, NULL, 0);
	if (err != 0) return -2;	// 分解路径出错

	// 合并提取出的当前执行文件的盘符和目录
	char exe_directory[_MAX_DRIVE + _MAX_DIR];
	err = _makepath_s(exe_directory, _MAX_DRIVE + _MAX_DIR, drive, dir, NULL, NULL);
	if (err != 0) return -3;	// 合并路径出错

	// 设置当前进程的路径为上面合并出的路径
	if (!SetCurrentDirectory(exe_directory))
		return -4;		// 设置当前路径出错

	return 0;
	} // end Set_Process_Dir_to_Exe_Dir



//-----------------------------------------------------------------------------
// GetExeFileName_WithExt()
// 获得在执行文件所在文件夹中的、文件名与执行文件相同的、指定扩展名的文件的完整路径
// 比如执行文件名为sample.exe，通过此函数可以获取同文件夹的sample.ini的完整路径
// 文件名内存空间必须足够大，但本函数不作检测
// 扩展名可以为空，扩展名地址可以为空
//-----------------------------------------------------------------------------
int GetExeFileName_WithExt(char * const filename, const char * const ext)
	{
	assert(filename);

	// 获得当前执行文件完整路径
	char self_name[MAX_PATH];
	const DWORD self_name_len = GetModuleFileName(NULL, self_name, MAX_PATH);
	if (self_name_len == 0 || self_name_len == MAX_PATH)
		return -1;		// 获得当前执行文件完整路径出错

	// 提取当前执行文件完整路径中的盘符、目录、文件名
	char drive[_MAX_DRIVE];
	char dir[_MAX_DIR];
	char fname[_MAX_FNAME];
	errno_t err = _splitpath_s(self_name, drive, _MAX_DRIVE, dir, _MAX_DIR, fname, _MAX_FNAME, NULL, 0);
	if (err != 0) return -2;	// 分解路径出错

	// 合并文件名，加入扩展名ext
	err = _makepath_s(filename, _MAX_PATH, drive, dir, fname, ext);
	if (err != 0) return -3;	// 合并路径出错

	return 0;
	} // end GetExeFileName_WithExt



//-----------------------------------------------------------------------------
// ChangeFilenameExt()
// 修改传入的文件路径中的扩展名
// 文件名内存空间必须足够大（MAX_PATH），但本函数不作检测
// 扩展名可以为空，扩展名地址可以为空
//-----------------------------------------------------------------------------
int ChangeFilenameExt(char * const filename, const char * const ext)
	{
	assert(filename);

	// 提取文件路径中的盘符、目录、文件名
	char drive[_MAX_DRIVE];
	char dir[_MAX_DIR];
	char fname[_MAX_FNAME];
	errno_t err = _splitpath_s(filename, drive, _MAX_DRIVE, dir, _MAX_DIR, fname, _MAX_FNAME, NULL, 0);
	if (err != 0) return -1;	// 分解路径出错

	// 合并文件名，加入扩展名ext
	err = _makepath_s(filename, _MAX_PATH, drive, dir, fname, ext);
	if (err != 0) return -2;	// 合并路径出错

	return 0;
	} // end ChangeFilenameExt



//-----------------------------------------------------------------------------
// LoadFile()
// 把某个已存在的文件读入内存，使用内存映射
// 访问方式：0-只读，1-读写，2-可写但不保存（使用的内存比其他两种多）
// 会修改传入的Mem_File对象，当返回失败时，其值无意义
// 文件为空时，返回失败
//-----------------------------------------------------------------------------
int LoadFile(const char * const filename, Mem_File * const p_memfile, DWORD nAccess)
	{
	assert(filename && *filename);
	assert(p_memfile);

	///////////////////////////////////////////////////////////
	// 确定访问方式

	DWORD nFileAccess;
	DWORD nPageAccess;
	DWORD nFileMapAccess;
	if (nAccess == 0)		// 只读
		{
		nFileAccess = GENERIC_READ;
		nPageAccess = PAGE_READONLY;
		nFileMapAccess = FILE_MAP_READ;
		}
	else if (nAccess == 1)		// 读写
		{
		nFileAccess = GENERIC_READ | GENERIC_WRITE;
		nPageAccess = PAGE_READWRITE;
		nFileMapAccess = FILE_MAP_WRITE;
		}
	else if (nAccess == 2)		// 可写但不保存
		{
		nFileAccess = GENERIC_READ | GENERIC_WRITE;
		nPageAccess = PAGE_WRITECOPY;
		nFileMapAccess = FILE_MAP_COPY;
		}
	else
		return -1;		// 错误的访问方式

	///////////////////////////////////////////////////////////
	// 建立内存映射

	// 打开文件
	HANDLE hFile;
	if (nFileAccess == GENERIC_READ)
		hFile = CreateFile_r(filename);
	else
		hFile = CreateFile_w(filename);

	if (hFile == INVALID_HANDLE_VALUE)
		return -2;		// 无法打开文件

	// 获取文件长度
	p_memfile->nSize = GetFileSize(hFile, NULL);
	if (p_memfile->nSize == INVALID_FILE_SIZE)
		{
		CloseHandle(hFile);
		return -3;		// 无法获取文件长度
		}
	else if (p_memfile->nSize == 0)
		{
		CloseHandle(hFile);
		p_memfile->pBuffer = NULL;
		p_memfile->nSize = 0;
		return -4;		// 文件为空
		}

	// 建立内存文件映射对象
	HANDLE const hFileMap = CreateFileMapping(hFile, NULL, nPageAccess, 0, 0, NULL);
	if (hFileMap == NULL)
		{
		CloseHandle(hFile);
		return -4;		// 内存文件映射对象建立失败
		}

	// 把整个文件映射到进程空间
	p_memfile->pBuffer = static_cast<BYTE *>( MapViewOfFile(hFileMap, nFileMapAccess, 0, 0, 0) );
	if (p_memfile->pBuffer == NULL)
		{
		CloseHandle(hFile);
		CloseHandle(hFileMap);
		return -5;		// 把整个文件映射到进程空间失败
		}

	// 关闭文件句柄和内存映射句柄
	CloseHandle(hFile);
	CloseHandle(hFileMap);
	return 0;
	} // end LoadFile



//-----------------------------------------------------------------------------
// LoadFile_n()
// 在内存中新建固定大小的文件，使用内存映射
// 如果文件名地址为空，则创建无名内存文件
// 会修改传入的Mem_File对象，当返回失败时，其值无意义
// 文件大小为0时，返回失败
//-----------------------------------------------------------------------------
int LoadFile_n(const char * const filename, Mem_File * const p_memfile, DWORD const nFileSize)
	{
	assert( (filename && *filename) || !filename );
	assert(p_memfile);

	if ( (p_memfile->nSize = nFileSize) == 0 )
		return -1;		// 文件大小为0

	// 新建文件，如果没有给出文件名则不创建
	HANDLE hFile;
	if (filename)
		{
		hFile = CreateFile_n(filename);
		if (hFile == INVALID_HANDLE_VALUE)
			return -2;		// 无法建立文件
		}
	else
		hFile = INVALID_HANDLE_VALUE;		// CloseHandle()可以被传入无效的句柄

	// 建立内存文件映射对象
	HANDLE const hFileMap = CreateFileMapping(hFile, NULL, PAGE_READWRITE, 0, nFileSize, NULL);
	if (hFileMap == NULL)
		{
		CloseHandle(hFile);
		return -3;		// 内存文件映射对象建立失败
		}

	// 把整个文件映射到进程空间
	p_memfile->pBuffer = static_cast<BYTE *>( MapViewOfFile(hFileMap, FILE_MAP_WRITE, 0, 0, 0) );
	if (p_memfile->pBuffer == NULL)
		{
		CloseHandle(hFile);
		CloseHandle(hFileMap);
		return -4;		// 把整个文件映射到进程空间失败
		}

	// 关闭文件句柄和内存映射句柄
	CloseHandle(hFile);
	CloseHandle(hFileMap);
	return 0;
	} // end LoadFile_n
