#ifndef SOUND_H
#define SOUND_H

#include "common.h"
#include "jycommon.h"

#ifdef __cplusplus
extern "C"
{
#endif

INT SOUND_OpenAudio(VOID);

VOID SOUND_CloseAudio(VOID);

VOID SOUND_PlayChannel(INT iSoundNum,INT iChannel,INT iType);

#define SOUND_Play(i) SOUND_PlayChannel((i), 0)

extern BOOL       g_fNoSound;
extern BOOL       g_fNoMusic;

#ifdef __cplusplus
}
#endif

#endif