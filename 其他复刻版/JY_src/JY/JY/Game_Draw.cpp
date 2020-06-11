
// INCLUDES ///////////////////////////////////////////////////////////////////

#include "Game_Draw.h"
#include "Image_Manager.h"

// DEFINES ////////////////////////////////////////////////////////////////////
// MACROS /////////////////////////////////////////////////////////////////////
// TYPES //////////////////////////////////////////////////////////////////////
// CLASS //////////////////////////////////////////////////////////////////////
// PROTOTYPES /////////////////////////////////////////////////////////////////
// EXTERNALS //////////////////////////////////////////////////////////////////
// GLOBALS ////////////////////////////////////////////////////////////////////

extern const DWORD COLOR_KEY = BGR(0,255,0);	// 色彩关键字（透明色）

// FUNCTIONS //////////////////////////////////////////////////////////////////

//-----------------------------------------------------------------------------
// Name: Draw_RLE_Tile()
// Desc: 绘制指定索引号的RLE图块到指定屏幕坐标
//       会检查索引号的有效性，以保证之后的需要索引号的函数能正常运行
//       自动管理内存与显存的使用，可以设置使用内存与显存的大小
//-----------------------------------------------------------------------------
int Draw_RLE_Tile(const Mem_RLE * const p_rle, WORD index, const LOC * const p_loc)
	{
	assert(p_rle && p_loc);

	// 检查索引号是否有效
	if (index >= p_rle->nImages)
		{
		//g_Log.Write("图像索引号%u超出.idx文件规定的范围\r\n", index);
		//return -1;

		// 把索引号改为0
		index = 0;
		}

	///////////////////////////////////////////////////////////
	// 获取图像表面信息

	// 给定索引号，获取图像表面信息的指针
	SURFACE *pSurface;
	if (CImageManager::GetSurfaceInfo(p_rle, index, &pSurface) != 0)
		{
		g_Log.Write("获取指定索引号的表面信息失败\r\n");
		return -1;
		}

	// 如果返回的表面指针为空，则说明图像为空，不绘制直接返回
	if (pSurface == NULL)
		return 0;

	///////////////////////////////////////////////////////////
	// 把图像从图像表面变换到后备缓冲表面
	// 到了这里图像表面信息的有效性已被保证

	// 图像区域
	RECT source_rect;
	source_rect.left	= 0;
	source_rect.top		= 0;
	source_rect.right	= pSurface->Image.nWidth;
	source_rect.bottom	= pSurface->Image.nHeight;

	// 屏幕画面区域
	RECT dest_rect;
	dest_rect.left		= (LONG)(p_loc->x - pSurface->Image.nXCorrection);
	dest_rect.top		= (LONG)(p_loc->y - pSurface->Image.nYCorrection);
	dest_rect.right		= (LONG)(dest_rect.left + pSurface->Image.nWidth);
	dest_rect.bottom	= (LONG)(dest_rect.top + pSurface->Image.nHeight);

	// 把图像变换到后备缓冲画面（使用源对象的色彩关键字）
	if (FAILED(lpddsback->Blt(&dest_rect, pSurface->pDDS, &source_rect,
							  (DDBLT_WAIT | DDBLT_KEYSRC), NULL)))
		{
		g_Log.Write("把%u号图像变换到后备缓冲画面(%d, %d, %d, %d)时失败\r\n",
			index, dest_rect.left, dest_rect.top, dest_rect.right, dest_rect.bottom);
		return 0;
		}

	// 把该图像表面激活
	CImageManager::SurfaceActivate(pSurface);

	///////////////////////////////////////////////////////////

	return 0;
	} // end Draw_RLE_Tile



//-----------------------------------------------------------------------------
// Name: Create_RLE_Surface()
// Desc: 根据当前图像编号创建图像表面
//       要求调用者保证索引号的有效性
//-----------------------------------------------------------------------------
int Create_RLE_Surface(LPDIRECTDRAWSURFACE7 * const p_lpdds, 
					   const Mem_RLE * const p_rle, RLE_Image * const p_image, WORD const index)
	{
	assert(p_lpdds && p_rle && p_image);

	///////////////////////////////////////////////////////////
	// 获取图像信息

	// 计算图像在.grp文件中的偏移地址
	// 图像索引号为0时可能根本没有.idx文件
	DWORD addr_begin;
	if (index == 0)
		addr_begin = 0;
	else
		addr_begin = *((DWORD *)p_rle->Idx.pBuffer + index -1);

	// 获取图像宽高、XY修正
	p_image->nWidth = *(short *)(p_rle->Grp.pBuffer + addr_begin);
	p_image->nHeight = *(short *)(p_rle->Grp.pBuffer + addr_begin + 2);
	p_image->nXCorrection = *(short *)(p_rle->Grp.pBuffer + addr_begin + 4);
	p_image->nYCorrection = *(short *)(p_rle->Grp.pBuffer + addr_begin + 6);

	if (p_image->nWidth <= 0 || p_image->nHeight <= 0)
		{
		g_Log.Write(".grp中的图像信息错误 (width:%u, height:%u)\r\n", p_image->nWidth, p_image->nHeight);
		return -1;
		}

	///////////////////////////////////////////////////////////
	// 建立离屏表面存放图像

	// 释放之前的离屏表面
	if (*p_lpdds)
		{
		(*p_lpdds)->Release();
		*p_lpdds = NULL;
		}

	// 根据图像宽高建立离屏表面
	*p_lpdds = DDraw_Create_Surface(p_image->nWidth, p_image->nHeight, DDSCAPS_VIDEOMEMORY, COLOR_KEY);
	if (*p_lpdds == NULL)
		{
		g_Log.Write("建立离屏表面出错\r\n");
		return -1;
		}

	// 锁定画面
	DDRAW_INIT_STRUCT(ddsd);
	if (FAILED((*p_lpdds)->Lock(NULL, &ddsd, DDLOCK_WAIT | DDLOCK_SURFACEMEMORYPTR, NULL)))
		{
		g_Log.Write("锁定画面出错\r\n");
		return -1;
		}

	DWORD lpitch32 = (DWORD)(ddsd.lPitch / 4);
	DWORD *sur_buffer = (DWORD *)ddsd.lpSurface;
	BYTE *rle_buffer = p_rle->Grp.pBuffer + addr_begin + 8;

	// 按行把数据写入表面
	for (int i = 0; i< p_image->nHeight; ++i)
		{
		// 把一行数据写入表面
		int result = RleWriteLine32(sur_buffer, rle_buffer, p_image->nWidth, p_rle->Col.pBuffer);
		if (result < 0)
			{
			g_Log.Write("写入一行数据时出错（行号%d，错误编号%d）\r\n", i, result);
			return -1;
			}
		sur_buffer += lpitch32;
		rle_buffer += *rle_buffer + 1;		// rle数据移到下一行开始
		}

	// 解锁画面
	if (FAILED((*p_lpdds)->Unlock(NULL)))
		{
		g_Log.Write("解锁画面出错\r\n");
		return -1;
		}

	return 0;
	} // end Create_RLE_Surface
