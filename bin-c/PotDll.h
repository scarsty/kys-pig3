#pragma once
#ifdef _MSC_VER 
#define MYTHAPI _stdcall
#ifdef __cplusplus
#ifdef _WINDLL
#define HBAPI extern "C" __declspec(dllexport)
#else
#define HBAPI extern "C" __declspec(dllimport)
#endif
#else
#ifdef _WINDLL
#define HBAPI __declspec(dllexport)
#else
#define HBAPI __declspec(dllimport)
#endif
#endif
#else
#define HBAPI
#define MYTHAPI
#endif

HBAPI void* MYTHAPI PotCreateFromHandle(void* handle);
HBAPI void* MYTHAPI PotCreateFromWindow(void* handle);
HBAPI int MYTHAPI PotInputVideo(void* pot, char* filename);
HBAPI int MYTHAPI PotPlayVideo(void* pot, char* filename, float volume);
HBAPI int MYTHAPI PotSeek(void* pot, int seek);
HBAPI int MYTHAPI PotDestory(void* pot);

#pragma comment(lib, "smallpot.lib")
