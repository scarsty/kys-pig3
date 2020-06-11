//-----------------------------------------------------------------------------
// 图像管理器
//-----------------------------------------------------------------------------

#ifndef IMAGE_MANAGER
#define IMAGE_MANAGER

// INCLUDES ///////////////////////////////////////////////////////////////////

#define WIN32_LEAN_AND_MEAN
#define INITGUID										// DirectX

#include <windows.h>
#include <stdio.h>
#include <assert.h>

#include <mmsystem.h>									// DirectX
#include <objbase.h>
#define DIRECTINPUT_VERSION 0x0800
#include <ddraw.h>
#include <dinput.h>
#include <dsound.h>
//#include <dmksctrl.h>
//#include <dmusici.h>
//#include <dmusicc.h>
//#include <dmusicf.h>

#include "dxlib_dd.h"									// DirectX User Lib
#include "dxlib_di.h"
#include "dxlib_ds.h"

#include "Game_Public.h"
#include "RLE.h"

// DEFINES ////////////////////////////////////////////////////////////////////
// MACROS /////////////////////////////////////////////////////////////////////
// TYPES //////////////////////////////////////////////////////////////////////
// CLASS //////////////////////////////////////////////////////////////////////

// 图像表面信息
typedef struct _SURFACE
	{
	LPDIRECTDRAWSURFACE7 pDDS;	// 图像表面指针
	WORD nActive;				// 图像活性，0表示无活性（不在屏幕内），为2能使在屏幕内的图像保持活性
	WORD nIndex;				// 图像索引
	RLE_Image Image;			// 图像信息
	} SURFACE;

// 图像内存管理器
// 暂时无法实现多线程共用一个管理器
// 因为还未实现线程同步，几个线程可能同时向同一内存写入不同的数据*********
class CImageManager
	{
	public:
		CImageManager();
		~CImageManager();

		// 根据图像索引值获取图像表面信息
		static int GetSurfaceInfo(const Mem_RLE *p_rle, WORD index, SURFACE **ppSurface);
		// 把该图像所在表面激活
		static void SurfaceActivate(SURFACE *pSurface, WORD nActive = 2);
		// 减少图像所在表面活性
		static void SurfaceDeactivate(SURFACE *pSurface);
		// 减少全部表面的活性
		static void SurfaceDeactivateAll();

		// 获取可容纳表面数
		static WORD MaxSurface() {return sm_nMaxSurface;}
		// 获取已创建表面数
		static WORD SurfaceUsed() {return sm_nSurfaceUsed;}

	private:
		// 根据图像索引找到表面编号的表格
		// 表面编号0表示该图像还没有表面，表面编号1对应0号表面
		// 表面编号范围0x00-0xFFFF，0x01-0xFFFF为有效表面编号，总共可以包含0xFFFF个表面（2字节的上限）
		static WORD sm_gSurfaceIndex[0x10000];

		// “根据表面编号找到表面信息的表格”的首个表面信息的地址
		// 上表中的表面编号n对应该表格中的n-1号表面信息，因而不存在0xFFFF号表面信息
		static WORD sm_nMaxSurface;
		static SURFACE * const sm_pSurfaces;

		// 已创建的表面数（如果已满，除非重置当前场景，否则这个值是不会变小的）
		static WORD sm_nSurfaceUsed;
	};

// PROTOTYPES /////////////////////////////////////////////////////////////////
// EXTERNALS //////////////////////////////////////////////////////////////////
// GLOBALS ////////////////////////////////////////////////////////////////////
// FUNCTIONS //////////////////////////////////////////////////////////////////

//-----------------------------------------------------------------------------
// Name: SurfaceActivate()
// Desc: （在屏幕上显示该图像后，）把该图像所在表面激活
//       默认只维持屏幕内的图像的活性
//       极端情况下，每一帧屏幕内的图像都全部不同，那么不在屏幕内的表面最多存活一帧，
//       即最大容量要不小于两个屏幕的图像（所有图像都不同）的表面数。
//       不过这种情况下的实现一般都会先清空所有表面，所以能容纳一个屏幕的图像（所有图像都不同）就行了。
//-----------------------------------------------------------------------------
inline void CImageManager::SurfaceActivate(SURFACE * const pSurface, WORD const nActive)
	{
	pSurface->nActive = nActive;
	}



//-----------------------------------------------------------------------------
// Name: SurfaceDeactivate()
// Desc: 减少图像所在表面活性，每次减1
//-----------------------------------------------------------------------------
inline void CImageManager::SurfaceDeactivate(SURFACE * const pSurface)
	{
	if (pSurface->nActive > 0)
		--pSurface->nActive;
	}



//-----------------------------------------------------------------------------
// Name: SurfaceDeactivateAll()
// Desc: （一帧开始显示图像前，）减少全部表面的活性
//-----------------------------------------------------------------------------
inline void CImageManager::SurfaceDeactivateAll()
	{
	for (int i = 0; i < sm_nSurfaceUsed; ++i)
		SurfaceDeactivate(&sm_pSurfaces[i]);
	}

#endif // IMAGE_MANAGER