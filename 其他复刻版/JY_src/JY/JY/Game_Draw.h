//-----------------------------------------------------------------------------
// 游戏图像绘制
//-----------------------------------------------------------------------------

#ifndef GAME_DRAW
#define GAME_DRAW

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
// PROTOTYPES /////////////////////////////////////////////////////////////////

int Draw_RLE_Tile(const Mem_RLE *p_rle, WORD index, const LOC *p_loc);
int Create_RLE_Surface(LPDIRECTDRAWSURFACE7 *p_lpdds,
					   const Mem_RLE *p_rle, RLE_Image *p_image, WORD index);

// EXTERNALS //////////////////////////////////////////////////////////////////

extern const DWORD COLOR_KEY;					// 色彩关键字（透明色）

// GLOBALS ////////////////////////////////////////////////////////////////////
// FUNCTIONS //////////////////////////////////////////////////////////////////

#endif // GAME_DRAW