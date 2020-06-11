//-----------------------------------------------------------------------------
// 文件系统相关
// 把文件读入内存时只使用内存文件映射的方法，不使用复制到物理内存的方法
//-----------------------------------------------------------------------------

#ifndef FH_FILE
#define FH_FILE

// INCLUDES ///////////////////////////////////////////////////////////////////

#define WIN32_LEAN_AND_MEAN

#include <windows.h>
#include <stdio.h>
#include <stdlib.h>
#include <assert.h>

// DEFINES ////////////////////////////////////////////////////////////////////
// MACROS /////////////////////////////////////////////////////////////////////
// TYPES //////////////////////////////////////////////////////////////////////

// 内存中的文件信息
typedef struct _Mem_File
	{
	BYTE *pBuffer;
	DWORD nSize;
	} Mem_File;

// CLASS //////////////////////////////////////////////////////////////////////
// PROTOTYPES /////////////////////////////////////////////////////////////////

inline HANDLE CreateFile_r(const char *filename);
inline HANDLE CreateFile_n(const char *filename);
inline HANDLE CreateFile_w(const char *filename);
inline void UnloadFile(Mem_File *p_memfile);
int Set_Process_Dir_to_Exe_Dir();
int GetExeFileName_WithExt(char *filename, const char *ext);
int ChangeFilenameExt(char *filename, const char *ext);
int LoadFile(const char *filename, Mem_File *p_memfile, DWORD nAccess);
int LoadFile_n(const char *filename, Mem_File *p_memfile, DWORD nFileSize);
inline void UnloadFile(Mem_File *p_memfile);
inline void UnloadFile_n(Mem_File *p_memfile);

// GLOBALS ////////////////////////////////////////////////////////////////////
// FUNCTIONS //////////////////////////////////////////////////////////////////

//-----------------------------------------------------------------------------
// CreateFile_r()
// 打开某个已存在文件，用来读取里面的数据
// 文件如果不存在则出错
// 调用后要检查返回的句柄是否为INVALID_HANDLE_VALUE
//-----------------------------------------------------------------------------
inline HANDLE CreateFile_r(const char * const filename)
	{
	return CreateFile(filename,
					  GENERIC_READ,
					  FILE_SHARE_READ,
					  NULL,
					  OPEN_EXISTING,
					  FILE_ATTRIBUTE_NORMAL,
					  NULL);
	} // end CreateFile_r



//-----------------------------------------------------------------------------
// CreateFile_n()
// 新建某个文件，用来写入数据
// 原文件如果存在会被覆盖
// 调用后要检查返回的句柄是否为INVALID_HANDLE_VALUE
//-----------------------------------------------------------------------------
inline HANDLE CreateFile_n(const char * const filename)
	{
	return CreateFile(filename,
					  GENERIC_READ | GENERIC_WRITE,
					  FILE_SHARE_READ,
					  NULL,
					  CREATE_ALWAYS,
					  FILE_ATTRIBUTE_NORMAL,
					  NULL);
	} // end CreateFile_n



//-----------------------------------------------------------------------------
// CreateFile_w()
// 打开或创建某个文件，用来写入数据
// 如果文件已存在，可以读取数据
// 调用后要检查返回的句柄是否为INVALID_HANDLE_VALUE
//-----------------------------------------------------------------------------
inline HANDLE CreateFile_w(const char * const filename)
	{
	return CreateFile(filename,
					  GENERIC_READ | GENERIC_WRITE,
					  FILE_SHARE_READ,
					  NULL,
					  OPEN_ALWAYS,
					  FILE_ATTRIBUTE_NORMAL,
					  NULL);
	} // end CreateFile_w



//-----------------------------------------------------------------------------
// UnloadFile()
// 释放读入内存的文件，取消文件映射
// 如果有改动且允许写入硬盘的话，改动会被写入硬盘
//-----------------------------------------------------------------------------
inline void UnloadFile(Mem_File * const p_memfile)
	{
	assert(p_memfile);

	if (p_memfile->pBuffer)
		{
		UnmapViewOfFile(p_memfile->pBuffer);		// 取消文件映射也可能出错，但不检查
		p_memfile->pBuffer = NULL;
		p_memfile->nSize = 0;
		}
	} // end UnloadFile



//-----------------------------------------------------------------------------
// UnloadFile_n()
// 保存对文件的更改，释放内存，取消文件映射
//-----------------------------------------------------------------------------
inline void UnloadFile_n(Mem_File * const p_memfile)
	{
	UnloadFile(p_memfile);
	}

#endif // FH_FILE