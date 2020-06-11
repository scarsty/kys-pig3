
// INCLUDES ///////////////////////////////////////////////////////////////////

#include "Image_Manager.h"
#include "Game_Draw.h"

// DEFINES ////////////////////////////////////////////////////////////////////
// MACROS /////////////////////////////////////////////////////////////////////
// TYPES //////////////////////////////////////////////////////////////////////
// CLASS //////////////////////////////////////////////////////////////////////
// PROTOTYPES /////////////////////////////////////////////////////////////////
// EXTERNALS //////////////////////////////////////////////////////////////////
// GLOBALS ////////////////////////////////////////////////////////////////////

// 根据图像索引找到表面编号的表格（必须全初始化为0）
WORD CImageManager::sm_gSurfaceIndex[0x10000] = {0};

// 根据表面编号找到表面信息的表格（必须全初始化为0）
WORD CImageManager::sm_nMaxSurface = 1000;
SURFACE * const CImageManager::sm_pSurfaces = new SURFACE[CImageManager::sm_nMaxSurface];

// 已创建的表面数（如果已满，除非重置当前场景，否则这个值是不会变小的）
WORD CImageManager::sm_nSurfaceUsed = 0;

// 创建全局图像管理对象
// 这个对象其他文件永远不需要访问，之所以创建对象是需要它的构造和析构函数
static CImageManager g_iImageManager;

// FUNCTIONS //////////////////////////////////////////////////////////////////

//-----------------------------------------------------------------------------
// Name: CImageManager()
// Desc: 构造函数
//-----------------------------------------------------------------------------
CImageManager::CImageManager()
	{
	// 初始化“根据表面编号找到表面信息的表格”
	memset(sm_pSurfaces, 0, sizeof(SURFACE) *sm_nMaxSurface);
	}



//-----------------------------------------------------------------------------
// Name: ~CImageManager()
// Desc: 析构函数
//-----------------------------------------------------------------------------
CImageManager::~CImageManager()
	{
	// 释放全部图像表面
	for (int i = 0; i < sm_nSurfaceUsed; ++i)
		DDraw_Delete_Surface(sm_pSurfaces[i].pDDS);

	// 释放“根据表面编号找到表面信息的表格”内存
	delete [] sm_pSurfaces;
	}



//-----------------------------------------------------------------------------
// Name: GetSurfaceInfo()
// Desc: 根据图像索引值获取图像表面信息
//       索引号为0表示图像为空，索引号只能是2字节
//       表面编号为0表示该图像还没有表面，表面编号为1对应表面表格中的0号表面
//       自动管理表面的创建
//       要求调用者保证索引号的有效性
//-----------------------------------------------------------------------------
int CImageManager::GetSurfaceInfo(const Mem_RLE * const p_rle,
								  WORD const index, SURFACE ** const ppSurface)
	{
	assert(p_rle && ppSurface);

	///////////////////////////////////////////////////////////
	// 如果图像索引值为0，则返回空指针

	if (index == 0)
		{
		*ppSurface = NULL;
		return 0;
		}

	///////////////////////////////////////////////////////////
	// 获得图块的表面信息，如果该图块还没有表面，则创建一个

	// 获得图块在表面信息表格中的位置（表面编号-1）
	WORD i = sm_gSurfaceIndex[index] -1;

	// 该图像还没有表面（表面编号为0）
	if ( i == static_cast<WORD>(-1) )
		{
		// 有空的表面位置（就算目前一个表面都没有创建，方法也是如此）
		if (sm_nSurfaceUsed < sm_nMaxSurface)
			{
			// 分配给当前图像一个位置（非表面编号）
			i = sm_nSurfaceUsed;
			// 已创建表面数加1
			++sm_nSurfaceUsed;
			// 记下其图像索引号
			sm_pSurfaces[i].nIndex = index;
			// 在表面编号表格中设置表面编号（表面信息位置加1）
			sm_gSurfaceIndex[index] = i +1;
			}
		// 没有空的表面信息位置了，只好查找无活性的表面，释放掉它，把当前图像的表面创建后装进去
		else
			{
			// 查找无活性的表面
			DWORD j = 0;
			while (j < sm_nMaxSurface && sm_pSurfaces[j].nActive != 0)
				 ++j;

			// 如果每个表面都有活性，则返回出错
			if (j == sm_nMaxSurface)
				{
				g_Log.Write("有活性的图像数超过预定的最大值\r\n");
				return -1;
				}

			// 根据该位置储存的图像索引号找到其在表面编号表格中的位置，把该表面编号清除
			sm_gSurfaceIndex[sm_pSurfaces[j].nIndex] = 0;

			// 分配给当前图像一个表面信息位置（非表面编号）
			i = static_cast<WORD>(j);
			// 改变该位置储存的图像索引号
			sm_pSurfaces[i].nIndex = index;
			// 在表面编号表格中设置表面编号（位置加1）
			sm_gSurfaceIndex[index] = i +1;
			}

		// 为没有表面的图像创建表面
		int result = Create_RLE_Surface(&sm_pSurfaces[i].pDDS, p_rle, &sm_pSurfaces[i].Image, index);
		if (result != 0)
			{
			g_Log.Write("创建单幅图像的表面失败 (index: %u)\r\n", index);
			return -1;
			}
		}

	///////////////////////////////////////////////////////////

	// 修改要返回的表面信息地址
	*ppSurface = &sm_pSurfaces[i];

	return 0;
	} // end GetSurfaceInfo
