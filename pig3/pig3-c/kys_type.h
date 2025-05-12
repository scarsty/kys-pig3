#include <stdio.h>
#include <string.h>
#include <locale.h>
#include <wchar.h>
#include <math.h>
#include "SDL.h"
#include "SDL_ttf.h"
#include "SDL_image.h"
#include "bass.h"

//#define FAST


#ifndef __kys_type__
#define __kys_type__

typedef struct Position
{
    int x, y;
} Position;


typedef struct PNGIndex
{
    int FileNum, PointerNum, Frame, x, y, w, h, Loaded, UseGRP;
    void *BeginPointer;
    SDL_Surface **CurPointer;
    SDL_Texture **CurPointerT;
} PNGIndex;

typedef struct KYSConstants
{

    SDL_Event event;
    SDL_Window *window;
    SDL_Renderer *render;


    int MODVersion;
    char *TitleString;
    char AppPath[MAX_PATH];

    char *CHINESE_FONT, *ENGLISH_FONT;
    int CHINESE_FONT_SIZE, CHINESE_FONT_REALSIZE, ENGLISH_FONT_SIZE, ENGLISH_FONT_REALSIZE;

    TTF_Font *Font, *Engfont;

    int SoundFlag, RenderFlag, WindowFlag;
    int RENDERER, SOUND3D, CENTER_X, CENTER_Y, RESOLUTIONX, RESOLUTIONY;

    int StartMusic;

    int SW_SURFACE;

    int Where;

    wchar_t *versionstr;

    Position OpenPicPosition;


} KYSConstants;


extern KYSConstants KYS;

extern PNGIndex *TitlePNGIndex;
extern SDL_Texture **TitlePNGTex;
extern SDL_Surface **TitlePNGSur;

#endif

