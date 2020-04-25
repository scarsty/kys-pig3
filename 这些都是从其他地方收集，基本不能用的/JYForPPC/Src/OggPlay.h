
#ifndef OGG_PLAY_H
#define OGG_PLAY_H

#include "common.h"

#ifdef __cplusplus

extern "C"
{
#endif

    inline VOID OGG_FillBuffer(LPBYTE stream, INT len) {}

    inline INT OGG_Init(VOID) { return 0; }

    inline VOID OGG_Shutdown(VOID) {}

    inline VOID OGG_Play(INT iNumOGG, INT iFloopTimes) {}

#ifdef __cplusplus
}
#endif

#endif