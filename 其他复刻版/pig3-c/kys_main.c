#include <stdio.h>
#include "kys_main.h"
#include "kys_engine.h"
#include "kys_draw.h"

int Run(void)
{
    int rendernum = -1;
    int i;
    SDL_RendererInfo info;
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

    KYS.SoundFlag = 0;
    if(KYS.SOUND3D == 1)
    {
        KYS.SoundFlag = BASS_DEVICE_3D | KYS.SoundFlag;
    }
    BASS_Init(-1, 22050, KYS.SoundFlag, 0, NULL);

    SDL_Init(SDL_INIT_VIDEO);
    SDL_SetHint(SDL_HINT_RENDER_SCALE_QUALITY, "1");
    setlocale(LC_CTYPE, "");

    KYS.WindowFlag = 0;
    if(KYS.RENDERER == 1)
    {
        KYS.WindowFlag = SDL_WINDOW_OPENGL;
    }
    KYS.WindowFlag = KYS.WindowFlag | SDL_WINDOW_RESIZABLE;
    KYS.window = SDL_CreateWindow(KYS.TitleString, SDL_WINDOWPOS_CENTERED, SDL_WINDOWPOS_CENTERED, KYS.RESOLUTIONX, KYS.RESOLUTIONY, KYS.WindowFlag);

    for(i = 0; i < SDL_GetNumRenderDrivers(); i++)
    {
        SDL_GetRenderDriverInfo(i, &info);
        printf("Render %d is %s.\n", i, info.name);
        printf(" Support software fallback:  %d\n", (info.flags & SDL_RENDERER_SOFTWARE) != 0);
        printf(" Support hardware acceleration:  %d\n", (info.flags & SDL_RENDERER_ACCELERATED) != 0);
        printf(" Support synchronizing with the refresh rate:  %d\n", (info.flags & SDL_RENDERER_PRESENTVSYNC) != 0);
        printf(" Support rendering to textures:  %d\n", (info.flags & SDL_RENDERER_TARGETTEXTURE) != 0);
        if(strcmp(info.name, "direct3d") & (KYS.RENDERER == 0))
        {
            rendernum = 0;
            printf("Select Direct3D renderer.\n");
        }
        if(strcmp(info.name, "opengl") & (KYS.RENDERER == 1))
        {
            rendernum = 0;
            printf("Select OPENGL renderer.\n");
        }
        if(strcmp(info.name, "software") & (KYS.RENDERER == 2))
        {
            rendernum = 0;
            printf("Select software renderer.\n");
        }
    }

    KYS.render = SDL_CreateRenderer(KYS.window, rendernum, KYS.RenderFlag);

    screentex = SDL_CreateTexture(KYS.render, SDL_PIXELFORMAT_ARGB8888, SDL_TEXTUREACCESS_TARGET, 100, 100);
    SDL_SetRenderTarget(KYS.render, screentex);
    printf(SDL_GetError());
    tex = IMG_LoadTexture(KYS.render, "resource/title/0.png");
    SDL_RenderCopy(KYS.render, tex, NULL, NULL);
    texyuv = SDL_CreateTexture(KYS.render, SDL_PIXELFORMAT_YV12, SDL_TEXTUREACCESS_STREAMING, 100, 100);
    SDL_RenderCopy(KYS.render, texyuv, NULL, NULL);
    DrawUText(L"KAninhao", 0, 0, 0, 20);
    rect.x = 10;
    rect.y = 10;
    rect.w = 100;
    rect.h = 100;
    SDL_SetTextureAlphaMod(tex, 128);
    SDL_RenderCopy(KYS.render, tex, NULL, &rect);

    //SDL_SetRenderTarget(KYS.render, NULL);
    SDL_RenderCopy(KYS.render, screentex, NULL, NULL);
	SDL_SetRenderTarget(KYS.render, NULL);
	SDL_RenderCopy(KYS.render, screentex, NULL, NULL);
    SDL_RenderPresent(KYS.render);


    //Start();
    //Redraw();
    tttt = SDL_GetTicks();
    //for (i=0; i<10000; i++)
    //{DrawTPic(0, 0, 0, NULL, 0, 0, 0, 0, 0);}
    printf("%d", SDL_GetTicks() - tttt);
    //UpdateAllScreen();

	sur = SDL_GetWindowSurface(KYS.window);
	printf("%d", sur);
	
	BYTE* SDL_pixel = (BYTE*)SDL_malloc(rect.w * rect.h * 3);
 
	
	SDL_SaveBMP(sur, "1.bmp");
	printf(SDL_GetError());
    while(SDL_PollEvent(&KYS.event) >= 0)
    {
        SDL_Delay(40);
        if(KYS.event.type == SDL_QUIT)
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
    KYS.MODVersion = 0;
    KYS.StartMusic = 59;
    KYS.TitleString = "Legend of Little Village III - 108 Brothers and Sisters";
    GetCurrentDirectory(MAX_PATH, KYS.AppPath);
    KYS.CHINESE_FONT = "resource/kaiu.ttf";
    KYS.CHINESE_FONT_SIZE = 20;
    KYS.CHINESE_FONT_REALSIZE = 20;
    KYS.ENGLISH_FONT = "resource/consola.ttf";
    KYS.ENGLISH_FONT_SIZE = 18;
    KYS.ENGLISH_FONT_REALSIZE = 18;

    KYS.OpenPicPosition.x = 0;
    KYS.OpenPicPosition.y = 0;

    KYS.versionstr = L"Ω”πÀÆùGÇ˜—› æ∞Ê";
    //switch(MODVersion)
    return 0;
}

int ReadFiles(void)
{
    char inifile[255];
    strcpy(inifile, KYS.AppPath);
    strcat(inifile, "/kysmod.ini");

    KYS.RENDERER = GetPrivateProfileInt("system", "RENDERER", 0, inifile);
    KYS.CENTER_X = GetPrivateProfileInt("system", "CENTER_X", 384, inifile);
    KYS.CENTER_Y = GetPrivateProfileInt("system", "CENTER_Y", 240, inifile);
    KYS.RESOLUTIONX = GetPrivateProfileInt("system", "RESOLUTIONX", KYS.CENTER_X * 2, inifile);
    KYS.RESOLUTIONY = GetPrivateProfileInt("system", "RESOLUTIONY", KYS.CENTER_Y * 2, inifile);

    KYS.SOUND3D = GetPrivateProfileInt("music", "SOUND3D", 0, inifile);

    //printf("%s%d\n", inifile, KYS.SOUND3D);
    return 0;

}

int SetFontSize(int Chnsize, int engsize, int force)
{
    KYS.Font = TTF_OpenFont(KYS.CHINESE_FONT, KYS.CHINESE_FONT_REALSIZE);
    return 0;

}

int Start()
{
    int i;
    LoadPNGTiles("resource/title", &TitlePNGIndex, &TitlePNGTex, &TitlePNGSur, 1);

    NewStartAmi();
    wprintf(L"%ls", KYS.versionstr);
    return 0;

}

void NewStartAmi()
{
    boolean breakami;
    int i, j, x, y;
    SDL_Rect src, dest;

    KYS.Where = 4;
    x = KYS.CENTER_X - 34;
    y = KYS.CENTER_Y - 75;
    for(i = 0; i <= 20; i++)
    {
        Redraw();
        DrawTPic(9, x, y, NULL, 0, 100 - i * 5, 0, 0, 0);
        UpdateAllScreen();
        SDL_Delay(20);
        if(SDL_PollEvent(&KYS.event) >= 0)
        {
            CleanKeyValue();
            if((KYS.event.key.keysym.sym == SDLK_ESCAPE) || (KYS.event.button.button == SDL_BUTTON_RIGHT))
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
        if(SDL_PollEvent(&KYS.event) >= 0)
        {
            if((KYS.event.key.keysym.sym == SDLK_ESCAPE) || (KYS.event.button.button == SDL_BUTTON_RIGHT))
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
        if(SDL_PollEvent(&KYS.event) >= 0)
        {
            if((KYS.event.key.keysym.sym == SDLK_ESCAPE) || (KYS.event.button.button == SDL_BUTTON_RIGHT))
            {
                return;
            }
            CheckBasicEvent();
        }
    }

    KYS.Where = 3;
    for(i = 0; i <= 2; i++)
    {
        Redraw();
        DrawTPic(14 + i, KYS.CENTER_X + 50, KYS.CENTER_Y, NULL, 0, 75, 0, 0, 0);
        DrawTPic(14 + i,  KYS.CENTER_X + 50,  KYS.CENTER_Y + 50, NULL, 0, 50, 0, 0, 0);
        DrawTPic(14 + i,  KYS.CENTER_X + 50,  KYS.CENTER_Y + 100, NULL, 0, 25, 0, 0, 0);
        UpdateAllScreen();
        SDL_Delay(20);
        if(SDL_PollEvent(&KYS.event) >= 0)
        {
            if((KYS.event.key.keysym.sym == SDLK_ESCAPE) || (KYS.event.button.button == SDL_BUTTON_RIGHT))
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
            DrawTPic(16, KYS.CENTER_X + 50, KYS.CENTER_Y + j * 50, NULL, 0, 25, 0, 0, 0);
            DrawTPic(3 + j, KYS.CENTER_X + 90, KYS.CENTER_Y + j * 50, NULL, 0, 100 - i * 5, 0, 0, 0);
        }
        UpdateAllScreen();
        SDL_Delay(20);
        if(SDL_PollEvent(&KYS.event) >= 0)
        {
            if((KYS.event.key.keysym.sym == SDLK_ESCAPE) || (KYS.event.button.button == SDL_BUTTON_RIGHT))
            {
                return;
            }
            CheckBasicEvent();
        }
    }
}