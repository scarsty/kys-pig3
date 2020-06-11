
// INCLUDES ///////////////////////////////////////////////////////////////////

#include "RLE.h"

// DEFINES ////////////////////////////////////////////////////////////////////
// MACROS /////////////////////////////////////////////////////////////////////

// 创建DirectX中的32位色彩
#define BGR(r,g,b)	((DWORD)(((BYTE)(b)|((WORD)((BYTE)(g))<<8))|(((DWORD)(BYTE)(r))<<16)))

// TYPES //////////////////////////////////////////////////////////////////////
// CLASS //////////////////////////////////////////////////////////////////////
// PROTOTYPES /////////////////////////////////////////////////////////////////
// EXTERNALS //////////////////////////////////////////////////////////////////
// GLOBALS ////////////////////////////////////////////////////////////////////

COLORREF Trans_Color;		// 透明色

// FUNCTIONS //////////////////////////////////////////////////////////////////

//-----------------------------------------------------------------------------
// Name: Load_RLE()
// Desc: 载入RLE图像文件数据（.GRP, .IDX）并调整到可用状态
//-----------------------------------------------------------------------------
int Load_RLE(Mem_RLE * const p_rle, const char * const filename_grp, const char * const filename_idx)
	{
	assert(p_rle);
	assert(filename_grp && *filename_grp);

	///////////////////////////////////////////////////////////
	// 读入.GRP、.IDX

	// 把.GRP读入内存
	int result = LoadFile(filename_grp, &p_rle->Grp, 0);
	if (result < 0) return -1;			// 读入文件失败

	// 如果传入了.IDX文件名，则把.IDX读入内存
	if (filename_idx && *filename_idx)
		{
		result = LoadFile(filename_idx, &p_rle->Idx, 2);
		if (result < 0) return -2;		// 读入文件失败
		}
	// 没有.IDX文件，则.GRP中只包含一个图像
	else
		{
		p_rle->Idx.pBuffer = NULL;
		p_rle->Idx.nSize = 0;
		p_rle->nImages = 1;
		return 0;
		}

	///////////////////////////////////////////////////////////
	// 此时.IDX存在，分析并修正其数据

	if (p_rle->Idx.nSize %4 != 0) return -3;		// .idx文件格式错误（长度不是4的整数倍）

	// 计算图像个数（第一个图像的偏移地址0x0000不写在.idx文件中）
	p_rle->nImages = (p_rle->Idx.nSize /4) +1;

	if (p_rle->nImages > 0x10000) return -4;		// 图像个数超过2字节索引的上限

	///////////////////////////////////////
	// 清除索引文件中的无效数据
	// .idx中的数据标明数据的开始位置，由于第一个的开始位置为0，所以省略不写。
	// 只要位置不超过.grp文件的限度，都是有效的。
	// 如果超出限度，则当作指向第一个图像。

	// .idx数据地址
	DWORD *p_addr = (DWORD *)p_rle->Idx.pBuffer;
	// .idx数据结尾地址
	const DWORD *p_addr_end = (DWORD *)(p_rle->Idx.pBuffer + p_rle->Idx.nSize);

	// 依次检查每个偏移地址
	for (; p_addr < p_addr_end; ++p_addr)
		{
		// 如果偏移地址处图像的像素数据在.grp文件外（前8字节为图像属性），则把该偏移地址清零
		if (*p_addr >= p_rle->Grp.nSize + 8)
			*p_addr = 0;
		}

	return 0;
	} // end Load_RLE



//-----------------------------------------------------------------------------
// Name: Load_COL()
// Desc: 载入调色板文件数据（并调整到可用状态）
//-----------------------------------------------------------------------------
int Load_COL(Mem_File * const p_col, const char * const filename_col)
	{
	assert(p_col);
	assert(filename_col && *filename_col);

	// 把.COL读入内存
	int result = LoadFile(filename_col, p_col, 2);
	if (result < 0) return -1;			// 读入文件失败

	// 检查调色板文件大小（固定为768字节）
	if (p_col->nSize != 256*3) return -2;	// .col文件格式错误

	// 把调色板内色彩改为通用24位色彩
	BYTE *color = p_col->pBuffer;
	for (DWORD i = 0; i < p_col->nSize; ++i)
		*color++ *= 4;

	return 0;
	} // end Load_COL



//-----------------------------------------------------------------------------
// RleWriteLine32()
// 把一行RLE数据写入内存，写入像素为32位
// 透明像素转换为指定的色彩后写入
// 输入：目标地址，rle数据地址（一行开始位置），图像宽度，调色板地址
//-----------------------------------------------------------------------------
int RleWriteLine32(DWORD *dst, BYTE *src, short width, BYTE * const p_col)
	{
	///////////////////////////////////////////////////////////
	// rle本行数据长度（不包括本字节）
	int length = *src++;

	// 本行数据长度小于0
	if (length < 0) return -1;
	// 本行数据长度为0，表示全都是透明像素
	else if (length == 0)
		{
		// 写入透明像素
		for (int i = 0; i < width; ++i)
			*dst++ = Trans_Color;

		return 0;
		}

	///////////////////////////////////////////////////////////
	// “透明像素长度+不透明像素长度+不透明像素索引”段
	BYTE c;
	do {
		///////////////////////////////////////
		// 写入透明像素

		// 透明像素长度
		c = *src++;

		if ((width -= c) < 0) return -2;		// 像素个数超过图像宽度

		// 写入透明像素
		for (int i = 0; i < c; ++i)
			*dst++ = Trans_Color;

		if (--length == 0) break;		// 已读完本行rle数据

		///////////////////////////////////////
		// 写入不透明像素

		// 不透明像素长度
		c = *src++;

		if ((width -= c) < 0) return -2;		// 像素个数超过图像宽度
		if ((length -= c + 1) < 0) return -3;	// rle不透明像素个字节数超过本行长度

		// 写入不透明像素
		for (int i = 0; i < c; ++i)
			{
			// 当前颜色值地址，三字节依次为r,g,b
			BYTE *tmp = p_col + (*src++) *3;
			*dst++ = BGR(*tmp, *(tmp+1), *(tmp+2));
			}
		} while (length > 0);

	// 本行结尾还有透明像素没写入
	// 此处length只可能等于0
	if (width > 0)
		{
		for (int i = 0; i < width; ++i)
			*dst++ = Trans_Color;
		}

	return 0;
	} // end RleWriteLine32



//-----------------------------------------------------------------------------
// RleWriteLine8()
// 把一行RLE数据写入内存，写入像素为8位
// 透明像素直接跳过不写
// 输入：目标地址，rle数据地址（一行开始位置），图像宽度
//-----------------------------------------------------------------------------
int RleWriteLine8(BYTE *dst, BYTE *src, short width)
	{
	///////////////////////////////////////////////////////////
	// rle本行数据长度（不包括本字节）
	int length = *src++;

	// 本行数据长度小于0
	if (length < 0) return -1;
	// 本行数据长度为0，表示全都是透明像素
	else if (length == 0)
		return 0;		// 什么都不写入，直接返回

	///////////////////////////////////////////////////////////
	// “透明像素长度+不透明像素长度+不透明像素索引”段
	BYTE c;
	do {
		///////////////////////////////////////
		// 跳过透明像素

		// 透明像素长度
		c = *src++;

		if ((width -= c) < 0) return -2;		// 像素个数超过图像宽度

		// 跳过透明像素
		dst += c;

		if (--length == 0) break;		// 已读完本行rle数据

		///////////////////////////////////////
		// 写入不透明像素

		// 不透明像素长度
		c = *src++;

		if ((width -= c) < 0) return -2;		// 像素个数超过图像宽度
		if ((length -= c + 1) < 0) return -3;	// rle不透明像素个字节数超过本行长度

		// 写入不透明像素
		for (int i = 0; i < c; ++i)
			*dst++ = *src++;

		} while (length > 0);

	// 本行结尾可能还有透明像素，不过不用去管

	return 0;
	} // end RleWriteLine8
