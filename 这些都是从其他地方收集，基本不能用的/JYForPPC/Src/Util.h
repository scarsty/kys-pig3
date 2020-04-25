#ifndef UTIL_H
#define UTIL_H

#include "common.h"

#ifdef __cplusplus
extern "C"
{
#endif

char *va(const char *format,...);
//FILE * UTIL_OpenRequiredFile(LPCSTR lpszFileName);
//FILE * UTIL_SaveRequiredFile(LPCSTR lpszFileName);
//VOID UTIL_SaveRequiredFile0(LPCSTR lpszFileName,FILE **fp);
//VOID UTIL_CloseFile(FILE **fp);
void TerminateOnError(const char *fmt,...);

#ifdef __cplusplus
}
#endif

#endif