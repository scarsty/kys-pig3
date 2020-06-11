//-----------------------------------------------------------------------------
// 金庸群侠传使用的RLE（行程长度压缩编码）图像文件相关操作
// 加入了8位像素操作
//-----------------------------------------------------------------------------

#ifndef JY_RLE
#define JY_RLE

// INCLUDES ///////////////////////////////////////////////////////////////////

#define WIN32_LEAN_AND_MEAN

#include <windows.h>
#include <stdio.h>
#include <assert.h>

#include "FH_File.h"

// DEFINES ////////////////////////////////////////////////////////////////////
// MACROS /////////////////////////////////////////////////////////////////////
// TYPES //////////////////////////////////////////////////////////////////////
// CLASS //////////////////////////////////////////////////////////////////////

// 内存中的RLE图像文件信息
typedef struct _Mem_RLE
	{
	Mem_File Grp;	// 图像数据文件信息
	Mem_File Idx;	// 图像索引文件信息
	Mem_File Col;	// 调色板文件信息
	DWORD nImages;	// 图像数目（因为用的是2字节的索引，故图像数目不能超过65536个）
	}Mem_RLE;

// 单个RLE图像信息
typedef struct _RLE_Image
	{
	short nWidth;		// 图像宽度（用有符号数是因为如果文件出错可以很容易的检测出来，不检测问题会很严重）
	short nHeight;		// 图像高度
	short nXCorrection;	// 图像X修正（本身就有正有负）
	short nYCorrection;	// 图像Y修正
	}RLE_Image;

// PROTOTYPES /////////////////////////////////////////////////////////////////

inline void Set_Trans_Color(COLORREF color);
inline void Attach_COL(Mem_RLE *p_rle, const Mem_File *p_col);
inline void Unload_RLE(Mem_RLE *p_rle);
inline void Unload_COL(Mem_File *p_col);
int Load_RLE(Mem_RLE *p_rle, const char *filename_grp, const char *filename_idx);
int Load_COL(Mem_File *p_col, const char *filename_col);
int RleWriteLine32(DWORD *dst, BYTE *src, short width, BYTE *p_col);
int RleWriteLine8(BYTE *dst, BYTE *src, short width);

// EXTERNALS //////////////////////////////////////////////////////////////////
// GLOBALS ////////////////////////////////////////////////////////////////////
// FUNCTIONS //////////////////////////////////////////////////////////////////

//-----------------------------------------------------------------------------
// Name: Set_Trans_Color()
// Desc: 设置透明色
//-----------------------------------------------------------------------------
inline void Set_Trans_Color(COLORREF color)
	{
	extern COLORREF Trans_Color;		// 对外部对象的声明，Trans_Color在RLE.cpp中
	Trans_Color = color;
	}



//-----------------------------------------------------------------------------
// Name: Attach_COL()
// Desc: 把调色板信息附加到图像数据信息上
//-----------------------------------------------------------------------------
inline void Attach_COL(Mem_RLE * const p_rle, const Mem_File * const p_col)
	{
	assert(p_rle && p_col);

	p_rle->Col = *p_col;
	}



//-----------------------------------------------------------------------------
// Name: Unload_RLE()
// Desc: 卸载RLE图像文件数据
//       释放.GRP, .IDX内存，调色板因为有专门的卸载函数，这里不用管
//-----------------------------------------------------------------------------
inline void Unload_RLE(Mem_RLE * const p_rle)
	{
	assert(p_rle);

	UnloadFile(&p_rle->Grp);
	UnloadFile(&p_rle->Idx);
	}



//-----------------------------------------------------------------------------
// Name: Unload_COL()
// Desc: 卸载.COL调色板文件数据
//-----------------------------------------------------------------------------
inline void Unload_COL(Mem_File * const p_col)
	{
	UnloadFile(p_col);
	}


#endif // JY_RLE