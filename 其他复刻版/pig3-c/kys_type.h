#pragma once
#include "SDL3/SDL.h"
#include "SDL3_image/SDL_image.h"
#include "SDL3_ttf/SDL_ttf.h"
#include "bass.h"
#include <locale.h>
#include <math.h>
#include <stdio.h>
#include <string.h>
#include <wchar.h>
#include <vector>

#define MAX_PATH 1024

typedef unsigned char byte;

typedef struct Position
{
    int x, y;
} Position;

typedef struct PNGIndex
{
    int FileNum, PointerNum, Frame, x, y, w, h, Loaded, UseGRP;
    SDL_Surface* CurPointer;
    SDL_Texture* CurPointerT;
} PNGIndex;

inline SDL_Event event;
inline SDL_Window* window;
inline SDL_Renderer* render;

inline int MODVersion;
inline char* TitleString;
inline char AppPath[MAX_PATH];

inline char *CHINESE_FONT, *ENGLISH_FONT;
inline int CHINESE_FONT_SIZE, CHINESE_FONT_REALSIZE, ENGLISH_FONT_SIZE, ENGLISH_FONT_REALSIZE;

inline TTF_Font *Font, *Engfont;

inline int SoundFlag, RenderFlag, WindowFlag;
inline int RENDERER, SOUND3D, CENTER_X, CENTER_Y, RESOLUTIONX, RESOLUTIONY;

inline int StartMusic;
inline int SW_SURFACE;

inline int Where;

inline char* versionstr;

inline Position OpenPicPosition;

inline std::vector<PNGIndex> TitlePNGs;

