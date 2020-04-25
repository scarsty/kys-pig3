#include "util.h"

char *va(const char *format,...)
{
	static char string[256] = {0};
   va_list     argptr;
	//for(int i=0;i< 256;i++)
	//{
	//	string[i] = 0;
	//}
   memset(string, 0, sizeof(string));
   va_start(argptr, format);
   vsnprintf(string, 256, format, argptr);
   va_end(argptr);

   return string;
}

void TerminateOnError(const char *fmt,...)
{
	va_list argptr;
	char string[256];
	extern VOID JY_Shutdown(VOID);

	va_start(argptr, fmt);
	vsnprintf(string, sizeof(string), fmt, argptr);
	va_end(argptr);

	FILE         *fp;
	LPSTR cFile = NULL;
	cFile = va("%s\\ErrLog.Txt", JY_PREFIX);
	fp = fopen(cFile, "wb");
	SafeFree(cFile);
	fprintf(stderr, "\nFATAL ERROR: %s\n", string);
	if (fp != NULL)
	{
		fwrite(string, strlen(string), 1, fp);
		fclose(fp);
	}
	JY_Shutdown();

	exit(255);
}
//FILE *UTIL_OpenRequiredFile(LPCSTR lpszFileName)
//{
//	FILE         *fp = NULL;
// 
//	LPSTR cFile = NULL;
//	cFile = va("%s%s", JY_PREFIX, lpszFileName);
//	fp = fopen(cFile, "rb");
//	SafeFree(cFile);
//	if (fp == NULL)
//	{
//		TerminateOnError("找不到文件: %s!\n", lpszFileName);
//	}
//
//	return fp;
//}
//
//FILE *UTIL_SaveRequiredFile(LPCSTR lpszFileName)
//{
//	FILE         *fp = NULL;
//	LPSTR pFile = NULL;
//	pFile = va("%s%s", JY_PREFIX, lpszFileName);
//	fp = fopen(pFile, "wb");
//
//	if (fp == NULL)
//	{
//		DWORD err = GetLastError();
//		//TCHAR* buffer;
//		//FormatMessage(FORMAT_MESSAGE_ALLOCATE_BUFFER | FORMAT_MESSAGE_FROM_SYSTEM,
//		//	NULL,err,0,(LPTSTR)&buffer,0,NULL);
//		//LocalFree(buffer);
//		TerminateOnError("错误代码:%d不能写到文件: %s!\n",err ,pFile);
//	}
//	SafeFree(pFile);
//	return fp;
//}
//VOID UTIL_SaveRequiredFile0(LPCSTR lpszFileName,FILE **fp)
//{
//	LPSTR pFile = NULL;
//	pFile = va("%s%s", JY_PREFIX, lpszFileName);
//	*fp = fopen(pFile, "wb");
//	if (*fp == NULL)
//	{
//		DWORD err = GetLastError();
//		//TCHAR* buffer;
//		//FormatMessage(FORMAT_MESSAGE_ALLOCATE_BUFFER | FORMAT_MESSAGE_FROM_SYSTEM,
//		//	NULL,err,0,(LPTSTR)&buffer,0,NULL);
//		//LocalFree(buffer);
//		TerminateOnError("错误代码:%d不能写到文件: %s!\n",err ,pFile);
//	}
//	SafeFree(pFile);
//}

//VOID UTIL_CloseFile(FILE **fp)
//{
//   if (*fp != NULL)
//   {
//      fclose(*fp);
//	  *fp = NULL;
//   }
//}

