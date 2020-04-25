#ifndef FONT_H
#define FONT_H

#include "common.h"
#include "jycommon.h"

#ifdef __cplusplus
extern "C"
{
#endif
extern TTF_Font *gpFont;
INT JY_InitFont(VOID);
VOID JY_FreeFont(VOID);
INT LoadMB(VOID);
INT  JY_CharSet(const char *src, char *dest, INT flag);
VOID Big5toUnicode(LPBYTE buf,int len);
#ifdef __cplusplus
}
#endif

#endif