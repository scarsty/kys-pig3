// dllmain.cpp : 定义 DLL 应用程序的入口点。

#include "SimpleCC.h"

#ifdef _WIN32
#define DLL_EXPORT __declspec(dllexport)
#else
#define DLL_EXPORT
#endif

extern "C" DLL_EXPORT void* simplecc_create()
{
    auto cc = new SimpleCC();
    return cc;
}

extern "C" DLL_EXPORT int simplecc_load(void* cc, const char* file)
{
    ((SimpleCC*)cc)->init({ file });
    return 0;
}

extern "C" DLL_EXPORT const char* simplecc_convert(void* cc, const char* src)
{
    static std::string result;
    result = ((SimpleCC*)cc)->conv(src);
    return result.c_str();
}
