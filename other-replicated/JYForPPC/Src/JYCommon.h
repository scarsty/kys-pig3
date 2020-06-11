#ifndef _PALUTILS_H
#define _PALUTILS_H

#include "common.h"

#ifdef __cplusplus
extern "C"
{
#endif

typedef LPBYTE      LPSPRITE, LPBITMAPRLE;
typedef LPCBYTE     LPCSPRITE, LPCBITMAPRLE;

typedef DWORD           JY_POS;

#define JY_XY(x, y)    (JY_POS)(((((WORD)(y)) << 16) & 0xFFFF0000) | (((WORD)(x)) & 0xFFFF))
#define JY_X(xy)       (SHORT)((xy) & 0xFFFF)
#define JY_Y(xy)       (SHORT)(((xy) >> 16) & 0xFFFF)

typedef enum tagJYDIRECTION
{
   kDirSouth = 0,
   kDirWest,
   kDirNorth,
   kDirEast,
   kDirUnknown
} JYDIRECTION, *LPJYDIRECTION;

INT JY_FILEReadData(LPBYTE lpBuffer,FILE *fp);
INT JY_IDXGetChunkCount(FILE *fp);
INT JY_IDXGetChunkBaseInfo(INT uiChunkNum,FILE *fp,INT *uiSize,INT *uiAddress);
INT JY_GRPReadChunk(LPBYTE lpBuffer,INT uiBufferSize,INT uiChunkAddress,FILE *fp);
INT JY_GetFileLength(FILE *fp);

#ifdef __cplusplus
}
#endif

#endif // _PALUTILS_H