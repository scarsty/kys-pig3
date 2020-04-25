#ifndef _COMMON_H
#define _COMMON_H

#ifdef __cplusplus
extern "C"
{
#endif
#define _CRTDBG_MAP_ALLOC//¼ì²âÄÚ´æÐ¹Â©

#include <windows.h>//release use
#include <windef.h>//release use
//#include <winnls.h>
//#include <winnt.h>//release use

//#include <wingdi.h>
//#include <winuser.h>
//#include <types.h>
#include <stdio.h>
#include <stdlib.h>
//#include "../crtdbg.h"//¼ì²âÄÚ´æÐ¹Â©
#include <string.h>
#include <time.h>
#include <limits.h>
#include <stdarg.h>
#include <assert.h>

#include "../SDL/SDL.h"
#include "../SDL/SDL_endian.h"
//#pragma comment(lib, "SDL/SDL.lib")
#include "../SDL/SDL_ttf.h"
//#pragma comment(lib, "SDL/SDL_ttf.lib")
//#include "../SDL/SDL_mixer.h"
//#pragma comment(lib, "SDL/SDL_mixer.lib")
//#include "../SDL/SDL_image.h"
//#pragma comment(lib, "SDL/SDL_image.lib")

//#ifdef _SDL_stdinc_h
//#define malloc       SDL_malloc
//#define calloc       SDL_calloc
//#define free         SDL_free
//#define realloc      SDL_realloc
//#endif

#if SDL_BYTEORDER == SDL_LIL_ENDIAN
#define SWAP16(X)    (X)
#define SWAP32(X)    (X)
#else
#define SWAP16(X)    SDL_Swap16(X)
#define SWAP32(X)    SDL_Swap32(X)
#endif

#ifndef max
#define max(a, b)    (((a) > (b)) ? (a) : (b))
#endif

#ifndef min
#define min(a, b)    (((a) < (b)) ? (a) : (b))
#endif

#define SafeFree(p) do {if(p) {free(p);p=NULL;}} while(0)
#define UTIL_CloseFile(p) do {if(p) {fclose(p);p=NULL;}} while(0)

int arByte2Int(void* arByte, int n);
void Int2arByte(void* arByte, int v, int n);
void ByteSwap(void* buf);

#ifdef _WIN32_WCE
#define JY_PREFIX            appPath
#endif

#ifndef _WIN32_WCE
#ifndef __BORLANDC__
#include <io.h>
#endif
#endif

#define vsnprintf _vsnprintf
extern char appPath[256];
char* GetAppPath();

#ifdef _MSC_VER
#pragma warning (disable:4996)
#pragma warning (disable:4761)
#endif

#ifndef _LPCBYTE_DEFINED
#define _LPCBYTE_DEFINED
typedef const unsigned char *LPCBYTE;
#endif

//typedef void* LPBYTE;
//typedef int INT;
//typedef uint32_t DWORD;
//typedef int32_t WORD;
//
//#define VOID void
//#define BOOL bool
typedef uint16_t ushort;
//typedef int16_t SHORT;
//#define FALSE false
//#define TRUE true
//typedef const char* LPSTR;
//
//typedef unsigned char BYTE;

#define JY_PREFIX "."
typedef int SDLKey;
#define SDL_SRCCOLORKEY 1
#define SDL_SRCALPHA 1
#define SDL_LOGPAL 1
#define SDL_PHYSPAL 1
#define SDL_HWSURFACE 1
#define SDL_SetPalette 0
#define SDL_SetAlpha 0

#ifdef __cplusplus
}
#endif

#endif