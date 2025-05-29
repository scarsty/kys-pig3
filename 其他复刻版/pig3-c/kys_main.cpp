#include <stdio.h>
#include "kys_main.h"
#include "kys_engine.h"
#include "kys_draw.h"
#include "kys_type.h"

int Run(void)
{
    int rendernum = -1;
    int i;
    //SDL_RendererInfo info;
    wchar_t *text;
    SDL_Texture *tex, *texyuv, *screentex;
	SDL_Surface *sur, *sur2;
    Uint32 tttt;
    SDL_Rect rect;
	byte *b;

    SetMODVerion();
    ReadFiles();
    TTF_Init();

    SetFontSize(20, 18, -1);

    SoundFlag = 0;
    if(SOUND3D == 1)
    {
        SoundFlag = BASS_DEVICE_3D | SoundFlag;
    }
    BASS_Init(-1, 22050, SoundFlag, 0, NULL);

    SDL_Init(SDL_INIT_VIDEO);
    //SDL_SetHint(SDL_HINT_RENDER_SCALE_QUALITY, "1");
    setlocale(LC_CTYPE, "");

    WindowFlag = 0;
    if(RENDERER == 1)
    {
        WindowFlag = SDL_WINDOW_OPENGL;
    }
    WindowFlag = WindowFlag | SDL_WINDOW_RESIZABLE;
    window = SDL_CreateWindow(TitleString, RESOLUTIONX, RESOLUTIONY, WindowFlag);

    for(i = 0; i < SDL_GetNumRenderDrivers(); i++)
    {
        //SDL_GetRenderDriverInfo(i, &info);
        //printf("Render %d is %s.\n", i, info.name);
        //printf(" Support software fallback:  %d\n", (info.flags & SDL_RENDERER_SOFTWARE) != 0);
        //printf(" Support hardware acceleration:  %d\n", (info.flags & SDL_RENDERER_ACCELERATED) != 0);
        //printf(" Support synchronizing with the refresh rate:  %d\n", (info.flags & SDL_RENDERER_PRESENTVSYNC) != 0);
        //printf(" Support rendering to textures:  %d\n", (info.flags & SDL_RENDERER_TARGETTEXTURE) != 0);
        //if(strcmp(info.name, "direct3d") & (RENDERER == 0))
        //{
        //    rendernum = 0;
        //    printf("Select Direct3D renderer.\n");
        //}
        //if(strcmp(info.name, "opengl") & (RENDERER == 1))
        //{
        //    rendernum = 0;
        //    printf("Select OPENGL renderer.\n");
        //}
        //if(strcmp(info.name, "software") & (RENDERER == 2))
        //{
        //    rendernum = 0;
        //    printf("Select software renderer.\n");
        //}
    }

    render = SDL_CreateRenderer(window, "Direct3D");

    screentex = SDL_CreateTexture(render, SDL_PIXELFORMAT_ARGB8888, SDL_TEXTUREACCESS_TARGET, RESOLUTIONX, RESOLUTIONY);
    SDL_SetRenderTarget(render, screentex);
    tex = IMG_LoadTexture(render, "resource/title/1.png");
    SDL_RenderTexture(render, tex, NULL, NULL);
    DrawUText("KAninhao", 0, 0, 0xffffffff, 20);

    SDL_SetRenderTarget(render, NULL);
    SDL_RenderTexture(render, screentex, NULL, NULL);
    SDL_RenderPresent(render);

    Start();
    while(SDL_PollEvent(&event) >= 0)
    {
        SDL_Delay(40);
        if(event.type == SDL_EVENT_QUIT)
        {
            break;
        }
    }

    Quit();
    return 0;
}

int Quit()
{
    SDL_Quit();
    return 0;
}

int SetMODVerion(void)
{
    MODVersion = 0;
    StartMusic = 59;
    TitleString = "Legend of Little Village III - 108 Brothers and Sisters";
    GetCurrentDirectory(MAX_PATH, AppPath);
    CHINESE_FONT = "font/chinese.ttf";
    CHINESE_FONT_SIZE = 20;
    CHINESE_FONT_REALSIZE = 20;
    ENGLISH_FONT = "font/english.ttf";
    ENGLISH_FONT_SIZE = 18;
    ENGLISH_FONT_REALSIZE = 18;

    OpenPicPosition.x = 0;
    OpenPicPosition.y = 0;

    versionstr = "金庸水滸傳演示版";
    //switch(MODVersion)
    return 0;
}

int ReadFiles(void)
{
    char inifile[255];
    strcpy(inifile, AppPath);
    strcat(inifile, "/kysmod.ini");

    RENDERER = GetPrivateProfileInt("system", "RENDERER", 0, inifile);
    CENTER_X = GetPrivateProfileInt("system", "CENTER_X", 480, inifile);
    CENTER_Y = GetPrivateProfileInt("system", "CENTER_Y", 270, inifile);
    RESOLUTIONX = GetPrivateProfileInt("system", "RESOLUTIONX", CENTER_X * 2, inifile);
    RESOLUTIONY = GetPrivateProfileInt("system", "RESOLUTIONY", CENTER_Y * 2, inifile);

    SOUND3D = GetPrivateProfileInt("music", "SOUND3D", 0, inifile);

    //printf("%s%d\n", inifile, SOUND3D);
    return 0;

}

int SetFontSize(int Chnsize, int engsize, int force)
{
    Font = TTF_OpenFont(CHINESE_FONT, CHINESE_FONT_REALSIZE);
    return 0;

}

int Start()
{
    int i;
    LoadPNGTiles("resource/title", &TitlePNGIndex, &TitlePNGTex, &TitlePNGSur, 1);

    NewStartAmi();
    wprintf(L"%ls", versionstr);
    return 0;

}

void NewStartAmi()
{
    boolean breakami;
    int i, j, x, y;
    SDL_Rect src, dest;

    Where = 4;
    x = CENTER_X - 34;
    y = CENTER_Y - 75;
    for(i = 0; i <= 20; i++)
    {
        Redraw();
        DrawTPic(9, x, y, NULL, 0, 100 - i * 5, 0, 0, 0);
        UpdateAllScreen();
        SDL_Delay(20);
        if(SDL_PollEvent(&event) >= 0)
        {
            CleanKeyValue();
            if((event.key.key == SDLK_ESCAPE) || (event.button.button == SDL_BUTTON_RIGHT))
            {
                return;
            }
            CheckBasicEvent();
        }
    }

    for(i = 0; i <= 60; i++)
    {
        Redraw();
        x = x - 5;
        y = y - 2;
        DrawTPic(9, x, y, NULL, 0, 0, 0, 0, 0);
        UpdateAllScreen();
        SDL_Delay(20);
        if(SDL_PollEvent(&event) >= 0)
        {
            if((event.key.key == SDLK_ESCAPE) || (event.button.button == SDL_BUTTON_RIGHT))
            {
                return;
            }
            CheckBasicEvent();
        }
    }

    src.x = 0;
    src.y = 0;
    src.w = TitlePNGIndex[12].w;
    src.h = TitlePNGIndex[12].h;
    dest.x = x;
    dest.y = y + 10;
    for(i = 0; i <= 89; i++)
    {
        Redraw();
        src.w = i * 5 + 50;
        if(src.w > 490) break;
        DrawTPic(12, x, y + 10, &src, 0, 0, 0, 0, 0);
        DrawTPic(10, x, y, NULL, 0, 0, 0, 0, 0);
        DrawTPic(10, x + i * 5 + 34, y, NULL, 0, 0, 0, 0, 0);
        UpdateAllScreen();
        SDL_Delay(20);
        if(SDL_PollEvent(&event) >= 0)
        {
            if((event.key.key == SDLK_ESCAPE) || (event.button.button == SDL_BUTTON_RIGHT))
            {
                return;
            }
            CheckBasicEvent();
        }
    }

    Where = 3;
    for(i = 0; i <= 2; i++)
    {
        Redraw();
        DrawTPic(14 + i, CENTER_X + 50, CENTER_Y, NULL, 0, 75, 0, 0, 0);
        DrawTPic(14 + i,  CENTER_X + 50,  CENTER_Y + 50, NULL, 0, 50, 0, 0, 0);
        DrawTPic(14 + i,  CENTER_X + 50,  CENTER_Y + 100, NULL, 0, 25, 0, 0, 0);
        UpdateAllScreen();
        SDL_Delay(20);
        if(SDL_PollEvent(&event) >= 0)
        {
            if((event.key.key == SDLK_ESCAPE) || (event.button.button == SDL_BUTTON_RIGHT))
            {
                return;
            }
            CheckBasicEvent();
        }
    }

    for(i = 0; i <= 20; i++)
    {
        Redraw();
        for(j = 0; j <= 2; j++)
        {
            DrawTPic(16, CENTER_X + 50, CENTER_Y + j * 50, NULL, 0, 25, 0, 0, 0);
            DrawTPic(3 + j, CENTER_X + 90, CENTER_Y + j * 50, NULL, 0, 100 - i * 5, 0, 0, 0);
        }
        UpdateAllScreen();
        SDL_Delay(20);
        if(SDL_PollEvent(&event) >= 0)
        {
            if((event.key.key == SDLK_ESCAPE) || (event.button.button == SDL_BUTTON_RIGHT))
            {
                return;
            }
            CheckBasicEvent();
        }
    }
}