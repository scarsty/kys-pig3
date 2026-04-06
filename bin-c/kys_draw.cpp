// kys_draw.cpp - 绘制实现
// 对应 kys_draw.pas

#include "kys_draw.h"
#include "kys_battle.h"
#include "kys_engine.h"
#include "kys_event.h"
#include "kys_main.h"
#include "kys_type.h"

#include <SDL3/SDL.h>
#include <algorithm>
#include <cmath>
#include <cstring>
#include <format>

//----------------------------------------------------------------------
// DrawPic - 画单个图片
//----------------------------------------------------------------------
void DrawPic(SDL_Surface* sur, int Pictype, int num, int px, int py, int shadow, int alpha, uint32 mixColor, int mixAlpha)
{
    if (num < 0)
    {
        return;
    }
    if (PNG_TILE > 0)
    {
        TPNGIndex* pIndex = nullptr;
        int maxNum = 0;
        switch (Pictype)
        {
        case 0:
            if (num < (int)MPNGIndex.size())
            {
                pIndex = &MPNGIndex[num];
            }
            break;
        case 1:
            if (num < (int)SPNGIndex.size())
            {
                pIndex = &SPNGIndex[num];
            }
            break;
        case 3:
            if (num < (int)TitlePNGIndex.size())
            {
                pIndex = &TitlePNGIndex[num];
            }
            break;
        case 4:
            if (num < (int)HPNGIndex.size())
            {
                pIndex = &HPNGIndex[num];
            }
            break;
        case 6:
            if (num < (int)CPNGIndex.size())
            {
                pIndex = &CPNGIndex[num];
            }
            break;
        }
    }
}

//----------------------------------------------------------------------
// DrawTPic - 标题贴图
//----------------------------------------------------------------------
void DrawTPic(int imgnum, int px, int py, SDL_Rect* region, int shadow, int Alpha, uint32 mixColor, int mixAlpha, double scalex, double scaley, double angle)
{
    if (PNG_TILE > 0)
    {
        if (imgnum >= 0 && imgnum < (int)TitlePNGIndex.size())
        {
            DrawPNGTile(render, TitlePNGIndex[imgnum], 0, px, py, region, shadow, Alpha, mixColor, mixAlpha, scalex, scaley, angle, nullptr);
        }
    }
}

//----------------------------------------------------------------------
// DrawMPic - 主地图贴图
//----------------------------------------------------------------------
void DrawMPic(int num, int px, int py, int Framenum, int shadow, int alpha, uint32 mixColor, int mixAlpha, double scalex, double scaley, double angle)
{
    if (num >= 0 && num < MPicAmount)
    {
        if (PNG_TILE > 0)
        {
            if (Framenum == -1)
            {
                Framenum = SDL_GetTicks() / 200 + rand() % 3;
            }
            if (num == 1377 || num == 1388 || num == 1404 || num == 1417)
            {
                Framenum = SDL_GetTicks() / 200;
            }
            if (PNG_LOAD_ALL == 0 && MPNGIndex[num].Loaded == 0)
            {
                LoadOnePNGTexture("resource/mmap/", pMPic, MPNGIndex[num]);
            }
            DrawPNGTile(render, MPNGIndex[num], Framenum, px, py, nullptr, shadow, alpha, mixColor, mixAlpha, scalex, scaley, angle, nullptr);
        }
    }
}

//----------------------------------------------------------------------
// DrawSPic - 场景贴图
//----------------------------------------------------------------------
void DrawSPic(int num, int px, int py)
{
    if (num >= 0 && num < SPicAmount)
    {
        if (PNG_TILE > 0)
        {
            if (PNG_LOAD_ALL == 0 && SPNGIndex[num].Loaded == 0)
            {
                LoadOnePNGTexture("resource/smap/", pSPic, SPNGIndex[num]);
            }
            int f = SDL_GetTicks() / 300 + rand() % 3;
            DrawPNGTile(render, SPNGIndex[num], f, px, py);
        }
    }
}

void DrawSPic(int num, int px, int py, SDL_Rect* region, int shadow, int alpha, uint32 mixColor, int mixAlpha)
{
    if (num >= 0 && num < SPicAmount)
    {
        if (num == 1941)
        {
            num = 0;
            py -= 50;
        }
        if (PNG_TILE > 0)
        {
            if (PNG_LOAD_ALL == 0 && SPNGIndex[num].Loaded == 0)
            {
                LoadOnePNGTexture("resource/smap/", pSPic, SPNGIndex[num]);
            }
            DrawPNGTile(render, SPNGIndex[num], 0, px, py, region, shadow, alpha, mixColor, mixAlpha, 1, 1, 0, nullptr);
        }
    }
}

//----------------------------------------------------------------------
// DrawHeadPic - 头像
//----------------------------------------------------------------------
void DrawHeadPic(int num, int px, int py, int shadow, int alpha, uint32 mixColor, int mixAlpha, double scalex, double scaley)
{
    if (num >= 0 && num < HPicAmount)
    {
        if (PNG_TILE > 0)
        {
            if (PNG_LOAD_ALL == 0 && HPNGIndex[num].Loaded == 0)
            {
                LoadOnePNGTexture("resource/head", pHPic, HPNGIndex[num]);
            }
            DrawPNGTile(render, HPNGIndex[num], 0, px, py, nullptr, shadow, alpha, mixColor, mixAlpha, scalex, scaley, 0, nullptr);
        }
    }
}

//----------------------------------------------------------------------
// DrawEPic - 效果图
//----------------------------------------------------------------------
void DrawEPic(int num, int px, int py, int eNum)
{
    DrawEPic(num, px, py, 0, 0, 0, 0, eNum);
}

void DrawEPic(int num, int px, int py, int shadow, int alpha, uint32 mixColor, int mixAlpha, int eNum, double scalex, double scaley, double angle, SDL_Point* center)
{
    if (num >= 0 && eNum >= 0 && eNum < MAX_EPNG)
    {
        if (num < EPNGIndex[eNum].Amount)
        {
            if (PNG_TILE > 0)
            {
                DrawPNGTile(render, EPNGIndex[eNum].PNGIndexArray[num], 0, px, py, nullptr, shadow, alpha, mixColor, mixAlpha, scalex, scaley, angle, center);
            }
        }
    }
}

//----------------------------------------------------------------------
// DrawFPic - 战斗人物图
//----------------------------------------------------------------------
void DrawFPic(int num, int px, int py, int index)
{
    DrawFPic(num, px, py, index, 0, 0, 0, 0);
}

void DrawFPic(int num, int px, int py, int index, int shadow, int alpha, uint32 mixColor, int mixAlpha)
{
    if (PNG_TILE > 0)
    {
        if (index >= 0 && index < MAX_FPNG)
        {
            if (FPNGIndex[index].Loaded == 0)
            {
                auto buf = std::format("resource/fight/fight{:03d}", index);
                LoadPNGTiles(buf, FPNGIndex[index].PNGIndexArray, 1);
                FPNGIndex[index].Loaded = 1;
            }
            if (num >= 0 && num < (int)FPNGIndex[index].PNGIndexArray.size())
            {
                DrawPNGTile(render, FPNGIndex[index].PNGIndexArray[num], 0, px, py, nullptr, shadow, alpha, mixColor, mixAlpha, 1, 1, 0, nullptr);
            }
        }
    }
}

//----------------------------------------------------------------------
// DrawCPic - 云图
//----------------------------------------------------------------------
void DrawCPic(int num, int px, int py, int shadow, int alpha, uint32 mixColor, int mixAlpha)
{
    if (PNG_TILE > 0 && num >= 0 && num < (int)CPNGIndex.size())
    {
        DrawPNGTile(render, CPNGIndex[num], 0, px, py, nullptr, shadow, alpha, mixColor, mixAlpha, 1, 1, 0, nullptr);
    }
}

//----------------------------------------------------------------------
// DrawIPic - 物品图
//----------------------------------------------------------------------
void DrawIPic(int num, int px, int py, int shadow, int alpha, uint32 mixColor, int mixAlpha)
{
    if (num >= 0 && num < IPicAmount)
    {
        if (PNG_TILE > 0)
        {
            if (PNG_LOAD_ALL == 0 && IPNGIndex[num].Loaded == 0)
            {
                LoadOnePNGTexture("resource/item/", pIPic, IPNGIndex[num]);
            }
            DrawPNGTile(render, IPNGIndex[num], 0, px, py, nullptr, shadow, alpha, mixColor, mixAlpha, 1, 1, 0, nullptr);
        }
    }
}

//----------------------------------------------------------------------
// Redraw - 重绘屏幕
//----------------------------------------------------------------------
void Redraw()
{
    switch (Where)
    {
    case 0: DrawMMap(); break;
    case 1: DrawScene(); break;
    case 2: DrawBField(); break;
    case 3:
        CleanTextScreen();
        DrawTPic(OpenPic, OpenPicPosition.x, OpenPicPosition.y);
        OpenPicPosition.x--;
        // 滚动背景
        if (OpenPicPosition.x < -TitlePNGIndex[OpenPic].w + CENTER_X * 2)
        {
            OpenPic = 31 + rand() % 6;
            OpenPicPosition.x = 0;
            OpenPicPosition.y = -(rand() % std::max(1, TitlePNGIndex[OpenPic].h - CENTER_Y * 2));
        }
        DrawTPic(12, CENTER_X - 384 + 112, CENTER_Y - 240 + 15);
        DrawTPic(10, CENTER_X - 384 + 110, CENTER_Y - 240 + 5);
        DrawTPic(10, CENTER_X - 384 + 591, CENTER_Y - 240 + 5);
        DrawShadowText(versionstr, 5, CENTER_Y * 2 - 30, ColColor(0x64), ColColor(0x66));
        DrawVirtualKey();
        break;
    case 4:
        CleanTextScreen();
        DrawTPic(OpenPic, OpenPicPosition.x, OpenPicPosition.y);
        if (OpenPicPosition.x < -TitlePNGIndex[OpenPic].w + CENTER_X * 2 || OpenPicPosition.x == 0)
        {
            OpenPic = 31 + rand() % 6;
            OpenPicPosition.x = -(rand() % std::max(1, TitlePNGIndex[OpenPic].w - CENTER_X * 2));
            OpenPicPosition.y = -(rand() % std::max(1, TitlePNGIndex[OpenPic].h - CENTER_Y * 2));
        }
        DrawShadowText(versionstr, 5, CENTER_Y * 2 - 30, ColColor(0x64), ColColor(0x66));
        break;
    }
}

//----------------------------------------------------------------------
// DrawMMap - 画主地图
//----------------------------------------------------------------------
void DrawMMap()
{
    int k = 0;
    TBuildInfo BuildArray[2001];
    int widthregion = CENTER_X / 36 + 3;
    int sumregion = CENTER_Y / 9 + 2;

    for (int sum = -sumregion; sum <= sumregion + 15; sum++)
    {
        for (int i = -widthregion; i <= widthregion; i++)
        {
            if (k >= 2000)
            {
                break;
            }
            int i1 = Mx + i + sum / 2;
            int i2 = My - i + (sum - sum / 2);
            TPosition pos = GetPositionOnScreen(i1, i2, Mx, My);

            if (i1 >= 0 && i1 < 480 && i2 >= 0 && i2 < 480)
            {
                if (BIG_PNG_TILE == 0)
                {
                    DrawMPic(Earth[i1][i2] / 2, pos.x, pos.y);
                    if (Surface[i1][i2] > 0)
                    {
                        DrawMPic(Surface[i1][i2] / 2, pos.x, pos.y);
                    }
                }

                int num = Building[i1][i2] / 2;
                // 主角位置
                if (i1 == Mx && i2 == My)
                {
                    if (InShip == 0)
                    {
                        if (Still == 0)
                        {
                            num = BEGIN_WALKPIC + MFace * 7 + MStep;
                        }
                        else
                        {
                            num = BEGIN_WALKPIC + 27 + MFace * 6 + MStep;
                        }
                    }
                    else
                    {
                        num = 3715 + MFace * 4 + (MStep + 1) / 2;
                    }
                }
                // 空船位置
                if (MODVersion == 13 && CellPhone == 0)
                {
                    if (i1 == ShipY && i2 == ShipX && InShip == 0)
                    {
                        num = 3715 + ShipFace * 4;
                    }
                }

                if (num > 0 && num < MPicAmount)
                {
                    BuildArray[k].x = i1;
                    BuildArray[k].y = i2;
                    BuildArray[k].b = num;
                    int Width = 0, yoffset = 0;
                    if (PNG_TILE > 0)
                    {
                        Width = MPNGIndex[num].w;
                        yoffset = MPNGIndex[num].y;
                        int Height = MPNGIndex[num].h;
                        BuildArray[k].c = ((i1 + i2) - (Width + 35) / 36 - (yoffset - Height + 1) / 9) * 1024 + i2;
                    }
                    k++;
                }
            }
            else
            {
                DrawMPic(0, pos.x, pos.y);
            }
        }
    }

    QuickSortB(BuildArray, 0, k - 1);
    for (int i = 0; i < k; i++)
    {
        TPosition pos = GetPositionOnScreen(BuildArray[i].x, BuildArray[i].y, Mx, My);
        DrawMPic(BuildArray[i].b, pos.x, pos.y);
    }

    DrawClouds();
    if (HaveText == 1)
    {
        CleanTextScreen();
    }
    DrawVirtualKey();
}

//----------------------------------------------------------------------
// DrawScene - 画场景
//----------------------------------------------------------------------
void DrawScene()
{
    int Cx1, Cy1;
    if (CurEvent < 0)
    {
        Cx1 = Sx;
        Cy1 = Sy;
    }
    else
    {
        Cx1 = Cx;
        Cy1 = Cy;
    }

    int widthregion = CENTER_X / 36 + 3;
    int sumregion = CENTER_Y / 9;
    if (showBlackScreen)
    {
        widthregion = 100 / 36 + 3;
        sumregion = 100 / 9;
    }

    LoadGroundTex(Cx1, Cy1);

    // 地面动画帧
    for (int sum = -sumregion; sum <= sumregion + 2; sum++)
    {
        for (int i = -widthregion; i <= widthregion; i++)
        {
            int i1 = Cx1 + i + sum / 2;
            int i2 = Cy1 - i + (sum - sum / 2);
            if (i1 >= 0 && i1 <= 63 && i2 >= 0 && i2 <= 63)
            {
                int num = ExGroundS[i1][i2] / 2;
                if (num > 0 && num < (int)SPNGIndex.size() && SPNGIndex[num].Frame > 1)
                {
                    TPosition pos = GetPositionOnScreen(i1, i2, Cx1, Cy1);
                    DrawSPic(num, pos.x, pos.y);
                }
            }
        }
    }

    // 建筑和事件层
    for (int sum = -sumregion; sum <= sumregion + 15; sum++)
    {
        for (int i = -widthregion; i <= widthregion; i++)
        {
            int i1 = Cx1 + i + sum / 2;
            int i2 = Cy1 - i + (sum - sum / 2);
            if (i1 >= 0 && i1 <= 63 && i2 >= 0 && i2 <= 63)
            {
                TPosition pos = GetPositionOnScreen(i1, i2, Cx1, Cy1);

                if (SData[CurScene][4][i1][i2] > 0)
                {
                    int num = SData[CurScene][0][i1][i2] / 2;
                    if (num > 0)
                    {
                        DrawSPic(num, pos.x, pos.y);
                    }
                }
                if (SData[CurScene][1][i1][i2] > 0)
                {
                    int num = SData[CurScene][1][i1][i2] / 2;
                    DrawSPic(num, pos.x, pos.y - SData[CurScene][4][i1][i2]);
                }
                if (ShowMR && i1 == Sx && i2 == Sy)
                {
                    DrawSPic(CurSceneRolePic, pos.x, pos.y - SData[CurScene][4][i1][i2]);
                }
                if (SData[CurScene][2][i1][i2] > 0)
                {
                    int num = SData[CurScene][2][i1][i2] / 2;
                    DrawSPic(num, pos.x, pos.y - SData[CurScene][5][i1][i2]);
                }
                if (SData[CurScene][3][i1][i2] >= 0)
                {
                    int num = DData[CurScene][SData[CurScene][3][i1][i2]][5] / 2;
                    if (num > 0)
                    {
                        DrawSPic(num, pos.x, pos.y - SData[CurScene][4][i1][i2]);
                    }
                }
            }
        }
    }

    if (showBlackScreen)
    {
        DrawBlackScreen();
    }
    if (HaveText == 1)
    {
        CleanTextScreen();
    }
    DrawVirtualKey();
}

void DrawSceneWithoutRole(int x, int y)
{
    int x1, y1;
    CalLTPosOnImageByCenter(x, y, x1, y1);
    if (showBlackScreen)
    {
        DrawBlackScreen();
    }
    if (HaveText == 1)
    {
        CleanTextScreen();
    }
}

void DrawRoleOnScene(int x, int y)
{
    if (ShowMR)
    {
        TPosition pos = GetPositionOnScreen(Sx, Sy, x, y);
        // 场景角色绘制(简化 - Pascal中也是注释掉的)
    }
}

void ExpandGroundOnImg()
{
    int16_t Ex[64][64];
    memset(Ex, -1, sizeof(Ex));
    for (int i1 = 0; i1 < 64; i1++)
    {
        for (int i2 = 0; i2 < 64; i2++)
        {
            switch (Where)
            {
            case 1: Ex[i1][i2] = SData[CurScene][0][i1][i2]; break;
            case 2: Ex[i1][i2] = BField[0][i1][i2]; break;
            }
        }
    }
    if (SW_SURFACE == 0)
    {
        switch (Where)
        {
        case 1: SDL_SetRenderTarget(render, ImgSGroundTex); break;
        case 2: SDL_SetRenderTarget(render, ImgBGroundTex); break;
        }
    }
    else
    {
        switch (Where)
        {
        case 1: CurTargetSurface = ImgSGround; break;
        case 2: CurTargetSurface = ImgBGround; break;
        }
    }
    SDL_SetRenderDrawColor(render, 0, 0, 0, 0);
    SDL_RenderClear(render);
    for (int i1 = 0; i1 < 64; i1++)
    {
        for (int i2 = 0; i2 < 64; i2++)
        {
            int x, y;
            CalPosOnImage(i1, i2, x, y);
            int num = Ex[i1][i2] / 2;
            if (num > 0)
            {
                DrawSPic(num, x, y);
            }
        }
    }
    SDL_SetRenderTarget(render, screenTex);
    CurTargetSurface = screen;
    switch (Where)
    {
    case 1: memcpy(ExGroundS, Ex, sizeof(Ex)); break;
    case 2: memcpy(ExGroundB, Ex, sizeof(Ex)); break;
    }
}

void InitialScene(int Visible)
{
    memset(ExGroundS, 0, sizeof(ExGroundS));
    for (int i1 = 0; i1 < 64; i1++)
    {
        for (int i2 = 0; i2 < 64; i2++)
        {
            ExGroundS[i1][i2] = (int16_t)SData[CurScene][0][i1][i2];
        }
    }
    ExpandGroundOnImg();
    if (IsCave(CurScene))
        showBlackScreen = true;
    else
        showBlackScreen = false;
}

int CalBlock(int x, int y)
{
    return 128 * (x + y) + y;
}

void CalPosOnImage(int i1, int i2, int& x, int& y)
{
    x = -i1 * 18 + i2 * 18 + ImageWidth / 2;
    y = i1 * 9 + i2 * 9 + 9 + CENTER_Y;
}

void CalLTPosOnImageByCenter(int i1, int i2, int& x, int& y)
{
    x = -(i1) * 18 + (i2) * 18 + ImageWidth / 2 - CENTER_X;
    y = (i1) * 9 + (i2) * 9 + 9;
    if (needOffset != 0)
    {
        x += offsetX;
        y += offsetY;
    }
}

//----------------------------------------------------------------------
// 战场绘制
//----------------------------------------------------------------------
void DrawBField()
{
    int Bx1 = Bx, By1 = By;
    int widthregion = CENTER_X / 36 + 3;
    int sumregion = CENTER_Y / 9;

    LoadGroundTex(Bx1, By1);
    for (int sum = -sumregion; sum <= sumregion + 15; sum++)
    {
        for (int i = -widthregion; i <= widthregion; i++)
        {
            int i1 = Bx1 + i + sum / 2;
            int i2 = By1 - i + (sum - sum / 2);
            if (i1 >= 0 && i1 <= 63 && i2 >= 0 && i2 <= 63)
            {
                TPosition pos = GetPositionOnScreen(i1, i2, Bx1, By1);
                int num = ExGroundB[i1][i2] / 2;

                // 重画闪烁的地面贴图
                if (num > 0 && SPNGIndex[num].Frame > 1)
                {
                    DrawSPic(num, pos.x, pos.y);
                }

                // 建筑和人物
                if (i1 >= 0 && i1 < 64 && i2 >= 0 && i2 < 64)
                {
                    num = BField[1][i1][i2] / 2;
                    if (num > 0)
                    {
                        DrawSPic(num, pos.x, pos.y);
                    }
                    num = BField[2][i1][i2];
                    if (num >= 0)
                    {
                        int picnum;
                        if (Brole[num].Pic > 0)
                        {
                            picnum = Brole[num].Pic;
                        }
                        else
                        {
                            picnum = Brole[num].StaticPic[Brole[num].Face];
                        }
                        DrawFPic(picnum, pos.x, pos.y, Rrole[Brole[num].rnum].ActionNum,
                            Brole[num].shadow, Brole[num].alpha, Brole[num].mixColor, Brole[num].mixAlpha);
                    }
                }
            }
        }
    }

    DrawProgress();
    CleanTextScreen();
    DrawVirtualKey();
}

void DrawBfieldWithoutRole(int x, int y)
{
    // Pascal中也是空实现(注释掉的代码)
}

void DrawRoleOnBfield(int x, int y, uint32 mixColor, int mixAlpha, int Alpha)
{
    // Pascal中也是空实现(注释掉的代码)
}

void InitialBFieldImage(int layer)
{
    for (int i1 = 0; i1 < 64; i1++)
    {
        for (int i2 = 0; i2 < 64; i2++)
        {
            for (int j = 0; j <= 2; j++)
            {
                int num = BField[j][i1][i2] / 2;
                if (num > 0 && num < SPicAmount)
                {
                    LoadOnePNGTexture("resource/smap", pSPic, SPNGIndex[num]);
                }
            }
        }
    }
    ExpandGroundOnImg();
}

void DrawBFieldWithCursor(int AttAreaType, int step, int range)
{
    CleanTextScreen();
    if (SW_SURFACE == 0)
    {
        SDL_SetTextureColorMod(ImgBGroundTex, 128, 128, 128);
    }
    else
    {
        SDL_SetSurfaceColorMod(ImgBGround, 128, 128, 128);
    }
    LoadGroundTex(Bx, By);
    if (SW_SURFACE == 0)
    {
        SDL_SetTextureColorMod(ImgBGroundTex, 255, 255, 255);
    }
    else
    {
        SDL_SetSurfaceColorMod(ImgBGround, 255, 255, 255);
    }
    SetAminationPosition(AttAreaType, step, range);
    for (int i1 = 0; i1 < 64; i1++)
    {
        for (int i2 = 0; i2 < 64; i2++)
        {
            if (BField[0][i1][i2] > 0)
            {
                TPosition pos = GetPositionOnScreen(i1, i2, Bx, By);
                int shadow = 0;
                switch (AttAreaType)
                {
                case 0:
                    if (BField[4][i1][i2] > 0)
                    {
                        shadow = 1;
                    }
                    else if ((abs(i1 - Bx) + abs(i2 - By) <= step) && BField[3][i1][i2] >= 0)
                    {
                        shadow = 0;
                    }
                    else
                    {
                        shadow = -1;
                    }
                    break;
                case 1:
                    if (BField[4][i1][i2] > 0)
                    {
                        shadow = 1;
                    }
                    else if ((i1 == Bx && abs(i2 - By) <= step) || (i2 == By && abs(i1 - Bx) <= step))
                    {
                        shadow = 0;
                    }
                    else
                    {
                        shadow = -1;
                    }
                    break;
                case 2:
                    if (BField[4][i1][i2] > 0)
                    {
                        shadow = 1;
                    }
                    else
                    {
                        shadow = -1;
                    }
                    break;
                case 3:
                    if (BField[4][i1][i2] > 0)
                    {
                        shadow = 1;
                    }
                    else if ((abs(i1 - Bx) + abs(i2 - By) <= step) && BField[0][i1][i2] >= 0)
                    {
                        shadow = 0;
                    }
                    else
                    {
                        shadow = -1;
                    }
                    break;
                case 4:
                    if (BField[4][i1][i2] > 0)
                    {
                        shadow = 1;
                    }
                    else if ((abs(i1 - Bx) + abs(i2 - By) <= step) && abs(i1 - Bx) != abs(i2 - By))
                    {
                        shadow = 0;
                    }
                    else
                    {
                        shadow = -1;
                    }
                    break;
                case 5:
                    if (BField[4][i1][i2] > 0)
                    {
                        shadow = 1;
                    }
                    else if ((abs(i1 - Bx) <= step) && (abs(i2 - By) <= step) && abs(i1 - Bx) != abs(i2 - By))
                    {
                        shadow = 0;
                    }
                    else
                    {
                        shadow = -1;
                    }
                    break;
                case 6:
                {
                    int minstep = 3;
                    if (BField[4][i1][i2] > 0)
                    {
                        shadow = 1;
                    }
                    else if ((abs(i1 - Bx) + abs(i2 - By) <= step) && (abs(i1 - Bx) + abs(i2 - By) > minstep) && BField[3][i1][i2] >= 0)
                    {
                        shadow = 0;
                    }
                    else
                    {
                        shadow = -1;
                    }
                    break;
                }
                }
                if (shadow == 0)
                {
                    DrawSPic(BField[0][i1][i2] / 2, pos.x, pos.y, nullptr, shadow, 0, 0, 0);
                }
                if (shadow > 0)
                {
                    DrawSPic(BField[0][i1][i2] / 2, pos.x, pos.y, nullptr, shadow, 0, 0, 0);
                }
            }
        }
    }

    for (int i1 = 0; i1 < 64; i1++)
    {
        for (int i2 = 0; i2 < 64; i2++)
        {
            TPosition pos = GetPositionOnScreen(i1, i2, Bx, By);
            if (BField[1][i1][i2] > 0)
            {
                DrawSPic(BField[1][i1][i2] / 2, pos.x, pos.y, nullptr, 0, 30, 0, 0);
            }
            int bnum = BField[2][i1][i2];
            if (bnum >= 0 && Brole[bnum].Dead == 0)
            {
                bool highlight = false;
                switch (SelectAimMode)
                {
                case 0: highlight = (BField[4][i1][i2] > 0) && (Brole[bnum].Team != 0); break;
                case 1: highlight = (BField[4][i1][i2] > 0) && (Brole[bnum].Team == 0); break;
                case 2: highlight = Brole[bnum].Team != 0; break;
                case 3: highlight = Brole[bnum].Team == 0; break;
                case 4: highlight = (i1 == Bx) && (i2 == By); break;
                case 5: highlight = (BField[4][i1][i2] > 0); break;
                case 6: highlight = true; break;
                case 7: highlight = false; break;
                }
                uint32 mc = 0xFFFFFFFF;
                int ma = 0, sh = 0;
                if (highlight)
                {
                    ma = 20;
                    sh = 1;
                }
                DrawFPic(Brole[bnum].StaticPic[Brole[bnum].Face], pos.x, pos.y,
                    Rrole[Brole[bnum].rnum].ActionNum, sh, 0, mc, ma);
            }
        }
    }
    DrawVirtualKey();
}

void DrawBlackScreen()
{
    if (SW_SURFACE == 0)
    {
        if (BlackScreenTex == nullptr)
        {
            SDL_Surface* sur = SDL_CreateSurface(CENTER_X * 2, CENTER_Y * 2,
                SDL_GetPixelFormatForMasks(32, RMask, GMask, BMask, AMask));
            SDL_FillSurfaceRect(sur, nullptr, MapRGBA(0, 0, 0, 255));
            for (int i1 = 0; i1 < CENTER_X * 2; i1++)
            {
                for (int i2 = 0; i2 < CENTER_Y * 2; i2++)
                {
                    int x = i1 - CENTER_X;
                    int y = i2 - CENTER_Y + 20;
                    double distance = (double)(x * x + y * y) / 15625.0;
                    if (distance <= 1.0)
                    {
                        uint8_t alpha = (uint8_t)(distance * 255);
                        PutPixel(sur, i1, i2, MapRGBA(0, 0, 0, alpha));
                    }
                }
            }
            BlackScreenTex = SDL_CreateTextureFromSurface(render, sur);
            SDL_SetTextureBlendMode(BlackScreenTex, SDL_BLENDMODE_BLEND);
            SDL_DestroySurface(sur);
        }
        SDL_SetRenderTarget(render, screenTex);
        SDL_RenderTexture(render, BlackScreenTex, nullptr, nullptr);
    }
    else
    {
        if (BlackScreenSur == nullptr)
        {
            BlackScreenSur = SDL_CreateSurface(CENTER_X * 2, CENTER_Y * 2,
                SDL_GetPixelFormatForMasks(32, RMask, GMask, BMask, AMask));
            SDL_FillSurfaceRect(BlackScreenSur, nullptr, MapRGBA(0, 0, 0, 255));
            for (int i1 = 0; i1 < CENTER_X * 2; i1++)
            {
                for (int i2 = 0; i2 < CENTER_Y * 2; i2++)
                {
                    int x = i1 - CENTER_X;
                    int y = i2 - CENTER_Y + 20;
                    double distance = (double)(x * x + y * y) / 15625.0;
                    if (distance <= 1.0)
                    {
                        uint8_t alpha = (uint8_t)(distance * 255);
                        PutPixel(BlackScreenSur, i1, i2, MapRGBA(0, 0, 0, alpha));
                    }
                }
            }
        }
        SDL_BlitSurface(BlackScreenSur, nullptr, screen, nullptr);
    }
}

void DrawBFieldWithEft(int Epicnum, int beginpic, int endpic, int curlevel, int bnum, int SelectAimMode, int flash,
    uint32 mixColor, int index, int shadow, int alpha, uint32 MixColor2, int MixAlpha2)
{
    if (needOffset != 0)
    {
        offsetX = rand() % 5;
        offsetY = rand() % 5;
    }
    int rnum = Brole[bnum].rnum;
    for (int i = 0; i < BRoleAmount; i++)
    {
        int t = 0;
        if (BField[4][Brole[i].X][Brole[i].Y] > 0)
        {
            if (CanSelectAim(bnum, i, -1, SelectAimMode))
            {
                t = 1;
            }
        }
        if (t == 1)
        {
            Brole[i].shadow = 1;
            Brole[i].mixColor = 0xFFFFFFFF;
            Brole[i].mixAlpha = t * (10 + rand() % 40);
        }
    }

    DrawBField();
    for (int i1 = 0; i1 < 64; i1++)
    {
        for (int i2 = 0; i2 < 64; i2++)
        {
            if (BField[4][i1][i2] > 0)
            {
                TPosition pos = GetPositionOnScreen(i1, i2, Bx, By);
                int k = Epicnum + curlevel - BField[4][i1][i2];
                if (k >= beginpic && k <= endpic)
                {
                    shadow = 0;
                    switch (Rrole[rnum].MPType)
                    {
                    case 2:
                        MixColor2 = 0xFFFFFFFF;
                        MixAlpha2 = (rand() % 2) * 20 * Rrole[rnum].CurrentMP / MAX_MP;
                        shadow = 1;
                        break;
                    case 3:
                        MixColor2 = MapRGBA(64, 64, 64);
                        MixAlpha2 = -1 * (rand() % 2);
                        break;
                    default:
                        MixColor2 = 0;
                        MixAlpha2 = 0;
                        break;
                    }
                    if (Rrole[rnum].AttPoi > 0)
                    {
                        MixColor2 = MapRGBA(255 - Rrole[rnum].AttPoi * 2, 255, 255 - Rrole[rnum].AttPoi * 2);
                        MixAlpha2 = -1 * (rand() % 2);
                    }
                    if (SW_SURFACE == 0)
                    {
                        DrawEPic(k, pos.x, pos.y, shadow, 25, MixColor2, MixAlpha2, index);
                    }
                    else
                    {
                        DrawEPic(k, pos.x, pos.y, 0, 0, 0, 0, index);
                    }
                }
            }
        }
    }
    for (int i = 0; i < BRoleAmount; i++)
    {
        Brole[i].shadow = 0;
        Brole[i].mixColor = 0;
        Brole[i].mixAlpha = 0;
    }
    offsetX = 0;
    offsetY = 0;
}

void DrawBFieldWithAction(int bnum, int Apicnum)
{
    Brole[bnum].Pic = Apicnum;
    DrawBField();
}

//----------------------------------------------------------------------
// DrawClouds - 画云
//----------------------------------------------------------------------
void DrawClouds()
{
    if (Where != 0)
    {
        return;
    }
    for (int i = 0; i < (int)Cloud.size(); i++)
    {
        int x = Cloud[i].Positionx - (-Mx * 18 + My * 18 + 8640 - CENTER_X);
        int y = Cloud[i].Positiony - (Mx * 9 + My * 9 + 9 - CENTER_Y);
        DrawCPic(Cloud[i].Picnum, x, y,
            Cloud[i].Shadow, Cloud[i].Alpha, Cloud[i].mixColor, Cloud[i].mixAlpha);
    }
}

void DrawProgress()
{
    if (SEMIREAL == 1)
    {
        int x = CENTER_X - 180;
        int y = CENTER_Y * 2 - 70;
        DrawMPic(2014, x - 150, y - 10);

        std::vector<int> rangeArr(BRoleAmount);
        std::vector<int> p(BRoleAmount);
        for (int i = 0; i < BRoleAmount; i++)
        {
            rangeArr[i] = i;
            p[i] = Brole[i].RealProgress * 480 / 10000;
        }
        // 按进度排序
        for (int i = 0; i < BRoleAmount - 1; i++)
        {
            for (int j = i + 1; j < BRoleAmount; j++)
            {
                if (p[i] <= p[j])
                {
                    std::swap(p[i], p[j]);
                    std::swap(rangeArr[i], rangeArr[j]);
                }
            }
        }
        for (int i = 0; i < BRoleAmount; i++)
        {
            if (Brole[rangeArr[i]].Dead == 0)
            {
                DrawHeadPic(Rrole[Brole[rangeArr[i]].rnum].HeadNum, p[i] + x, y, 0, 0, 0, 0, 0.25f, 0.25f);
            }
        }
    }
}

void LoadGroundTex(int x, int y)
{
    int dx, dy;
    CalLTPosOnImageByCenter(x, y, dx, dy);
    SDL_Rect dest = { dx, dy, CENTER_X * 2, CENTER_Y * 2 };
    SDL_FRect destf = rect2f(dest);
    if (SW_SURFACE == 0)
    {
        switch (Where)
        {
        case 1: SDL_RenderTexture(render, ImgSGroundTex, &destf, nullptr); break;
        case 2: SDL_RenderTexture(render, ImgBGroundTex, &destf, nullptr); break;
        }
    }
    else
    {
        switch (Where)
        {
        case 1: SDL_BlitSurface(ImgSGround, &dest, screen, nullptr); break;
        case 2: SDL_BlitSurface(ImgBGround, &dest, screen, nullptr); break;
        }
    }
}

int DrawTextFrame(int x, int y, int len, int alpha, uint32 mixColor, int mixAlpha)
{
    const int l = 19, m = 20, r = 21;
    DrawTPic(l, x - 1, y, nullptr, 0, alpha, mixColor, mixAlpha);
    SDL_Rect rect = { 0, 0, 10 * len, TitlePNGIndex[m].h };
    DrawTPic(m, x + 19, y, &rect, 0, alpha, mixColor, mixAlpha);
    DrawTPic(r, x + 19 + len * 10, y, nullptr, 0, alpha, mixColor, mixAlpha);
    return 19;
}

void DrawTextWithRect(const std::string& word, int x, int y, int w, uint32 color1, uint32 color2, int alpha, int Refresh)
{
    int len = DrawLength(word);
    len = std::max((w + 9) / 10, len);
    DrawTextFrame(x, y, len, alpha);
    DrawShadowText(word, x + 19, y + 3, color1, color2);
    if (Refresh != 0)
    {
        UpdateAllScreen();
    }
}

void DrawVirtualKey()
{
    if (CellPhone == 0 || ShowVirtualKey == 0)
    {
        return;
    }
    int u = 50, d = 50, l = 50, r = 50;
    switch (VirtualKeyValue)
    {
    case SDLK_UP: u = 0; break;
    case SDLK_LEFT: l = 0; break;
    case SDLK_DOWN: d = 0; break;
    case SDLK_RIGHT: r = 0; break;
    }
    DrawTPic(51, VirtualKeyX, VirtualKeyY, nullptr, 0, u);
    DrawTPic(53, VirtualKeyX - VirtualKeySize - VirtualKeySpace, VirtualKeyY + VirtualKeySize + VirtualKeySpace, nullptr, 0, l);
    DrawTPic(52, VirtualKeyX, VirtualKeyY + VirtualKeySize * 2 + VirtualKeySpace * 2, nullptr, 0, d);
    DrawTPic(54, VirtualKeyX + VirtualKeySize + VirtualKeySpace, VirtualKeyY + VirtualKeySize + VirtualKeySpace, nullptr, 0, r);
    DrawTPic(56, CENTER_X * 2 - 100, CENTER_Y * 2 - 200, nullptr, 0, 50);
    DrawTPic(57, CENTER_X * 2 - 200, CENTER_Y * 2 - 100, nullptr, 0, 50);
    DrawTPic(55, CENTER_X - 120, CENTER_Y * 2 - 70, nullptr, 0, 50);
    DrawTPic(58, CENTER_X + 50, CENTER_Y * 2 - 70, nullptr, 0, 50);
}
