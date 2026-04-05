// kys_draw.cpp - 绘制实现
// 对应 kys_draw.pas

#include "kys_draw.h"
#include "kys_type.h"
#include "kys_main.h"
#include "kys_engine.h"
#include "kys_event.h"
#include "kys_battle.h"

#include <SDL3/SDL.h>
#include <algorithm>
#include <cmath>
#include <cstring>

//----------------------------------------------------------------------
// DrawPic - 画单个图片
//----------------------------------------------------------------------
void DrawPic(SDL_Surface* sur, int Pictype, int num, int px, int py, int shadow, int alpha, uint32 mixColor, int mixAlpha)
{
    if (num < 0) return;
    if (PNG_TILE > 0)
    {
        TPNGIndex* pIndex = nullptr;
        int maxNum = 0;
        switch (Pictype)
        {
        case 0: if (num < (int)MPNGIndex.size()) pIndex = &MPNGIndex[num]; break;
        case 1: if (num < (int)SPNGIndex.size()) pIndex = &SPNGIndex[num]; break;
        case 3: if (num < (int)TitlePNGIndex.size()) pIndex = &TitlePNGIndex[num]; break;
        case 4: if (num < (int)HPNGIndex.size()) pIndex = &HPNGIndex[num]; break;
        case 6: if (num < (int)CPNGIndex.size()) pIndex = &CPNGIndex[num]; break;
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
            DrawPNGTile(render, TitlePNGIndex[imgnum], 0, px, py, region, shadow, Alpha, mixColor, mixAlpha, scalex, scaley, angle, nullptr);
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
            if (Framenum == -1) Framenum = SDL_GetTicks() / 200 + rand() % 3;
            if (num == 1377 || num == 1388 || num == 1404 || num == 1417)
                Framenum = SDL_GetTicks() / 200;
            if (PNG_LOAD_ALL == 0 && MPNGIndex[num].Loaded == 0)
                LoadOnePNGTexture("resource/mmap/", pMPic, MPNGIndex[num]);
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
                LoadOnePNGTexture("resource/smap/", pSPic, SPNGIndex[num]);
            int f = SDL_GetTicks() / 300 + rand() % 3;
            DrawPNGTile(render, SPNGIndex[num], f, px, py);
        }
    }
}

void DrawSPic(int num, int px, int py, SDL_Rect* region, int shadow, int alpha, uint32 mixColor, int mixAlpha)
{
    if (num >= 0 && num < SPicAmount)
    {
        if (num == 1941) { num = 0; py -= 50; }
        if (PNG_TILE > 0)
        {
            if (PNG_LOAD_ALL == 0 && SPNGIndex[num].Loaded == 0)
                LoadOnePNGTexture("resource/smap/", pSPic, SPNGIndex[num]);
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
                LoadOnePNGTexture("resource/head", pHPic, HPNGIndex[num]);
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
                DrawPNGTile(render, EPNGIndex[eNum].PNGIndexArray[num], 0, px, py, nullptr, shadow, alpha, mixColor, mixAlpha, scalex, scaley, angle, center);
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
                char buf[64];
                snprintf(buf, sizeof(buf), "resource/fight/fight%03d", index);
                LoadPNGTiles(buf, FPNGIndex[index].PNGIndexArray, 1);
                FPNGIndex[index].Loaded = 1;
            }
            if (num >= 0 && num < (int)FPNGIndex[index].PNGIndexArray.size())
                DrawPNGTile(render, FPNGIndex[index].PNGIndexArray[num], 0, px, py, nullptr, shadow, alpha, mixColor, mixAlpha, 1, 1, 0, nullptr);
        }
    }
}

//----------------------------------------------------------------------
// DrawCPic - 云图
//----------------------------------------------------------------------
void DrawCPic(int num, int px, int py, int shadow, int alpha, uint32 mixColor, int mixAlpha)
{
    if (PNG_TILE > 0 && num >= 0 && num < (int)CPNGIndex.size())
        DrawPNGTile(render, CPNGIndex[num], 0, px, py, nullptr, shadow, alpha, mixColor, mixAlpha, 1, 1, 0, nullptr);
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
                LoadOnePNGTexture("resource/item/", pIPic, IPNGIndex[num]);
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
        if (OpenPicPosition.x < -400 + CENTER_X * 2)
        {
            OpenPic = 31 + rand() % 6;
            OpenPicPosition.x = 0;
            OpenPicPosition.y = 0;
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
        if (OpenPicPosition.x < -400 + CENTER_X * 2 || OpenPicPosition.x == 0)
        {
            OpenPic = 31 + rand() % 6;
            OpenPicPosition.x = 0;
            OpenPicPosition.y = 0;
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
            if (k >= 2000) break;
            int i1 = Mx + i + sum / 2;
            int i2 = My - i + (sum - sum / 2);
            TPosition pos = GetPositionOnScreen(i1, i2, Mx, My);

            if (i1 >= 0 && i1 < 480 && i2 >= 0 && i2 < 480)
            {
                if (BIG_PNG_TILE == 0)
                {
                    DrawMPic(Earth[i1][i2] / 2, pos.x, pos.y);
                    if (Surface[i1][i2] > 0)
                        DrawMPic(Surface[i1][i2] / 2, pos.x, pos.y);
                }

                int num = Building[i1][i2] / 2;
                // 主角位置
                if (i1 == Mx && i2 == My)
                {
                    if (InShip == 0)
                    {
                        if (Still == 0)
                            num = BEGIN_WALKPIC + MFace * 7 + MStep;
                        else
                            num = BEGIN_WALKPIC + 27 + MFace * 6 + MStep;
                    }
                    else
                        num = 3715 + MFace * 4 + (MStep + 1) / 2;
                }
                // 空船位置
                if (MODVersion == 13 && CellPhone == 0)
                    if (i1 == ShipY && i2 == ShipX && InShip == 0)
                        num = 3715 + ShipFace * 4;

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
                DrawMPic(0, pos.x, pos.y);
        }
    }

    QuickSortB(BuildArray, 0, k - 1);
    for (int i = 0; i < k; i++)
    {
        TPosition pos = GetPositionOnScreen(BuildArray[i].x, BuildArray[i].y, Mx, My);
        DrawMPic(BuildArray[i].b, pos.x, pos.y);
    }

    DrawClouds();
    if (HaveText == 1) CleanTextScreen();
    DrawVirtualKey();
}

//----------------------------------------------------------------------
// DrawScene - 画场景
//----------------------------------------------------------------------
void DrawScene()
{
    int Cx1, Cy1;
    if (CurEvent < 0) { Cx1 = Sx; Cy1 = Sy; }
    else { Cx1 = Cx; Cy1 = Cy; }

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
        for (int i = -widthregion; i <= widthregion; i++)
        {
            int i1 = Cx1 + i + sum / 2;
            int i2 = Cy1 - i + (sum - sum / 2);
            if (i1 >= -64 && i1 <= 127 && i2 >= -64 && i2 <= 127)
            {
                int num = ExGroundS[i1 + 64][i2 + 64] / 2;
                if (num > 0 && num < (int)SPNGIndex.size() && SPNGIndex[num].Frame > 1)
                {
                    TPosition pos = GetPositionOnScreen(i1, i2, Cx1, Cy1);
                    DrawSPic(num, pos.x, pos.y);
                }
            }
        }

    // 建筑和事件层
    for (int sum = -sumregion; sum <= sumregion + 15; sum++)
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
                    if (num > 0) DrawSPic(num, pos.x, pos.y);
                }
                if (SData[CurScene][1][i1][i2] > 0)
                {
                    int num = SData[CurScene][1][i1][i2] / 2;
                    DrawSPic(num, pos.x, pos.y - SData[CurScene][4][i1][i2]);
                }
                if (ShowMR && i1 == Sx && i2 == Sy)
                    DrawSPic(CurSceneRolePic, pos.x, pos.y - SData[CurScene][4][i1][i2]);
                if (SData[CurScene][2][i1][i2] > 0)
                {
                    int num = SData[CurScene][2][i1][i2] / 2;
                    DrawSPic(num, pos.x, pos.y - SData[CurScene][5][i1][i2]);
                }
                if (SData[CurScene][3][i1][i2] >= 0)
                {
                    int num = DData[CurScene][SData[CurScene][3][i1][i2]][5] / 2;
                    if (num > 0)
                        DrawSPic(num, pos.x, pos.y - SData[CurScene][4][i1][i2]);
                }
            }
        }

    if (showBlackScreen) DrawBlackScreen();
    if (HaveText == 1) CleanTextScreen();
}

void DrawSceneWithoutRole(int x, int y) { /* TODO */ }
void DrawRoleOnScene(int x, int y) { /* TODO */ }
void ExpandGroundOnImg() { /* TODO */ }

void InitialScene(int Visible)
{
    // 设置场景角色贴图
    int rnum = Rscene[CurScene + 1].EntranceX;
    if (rnum >= 0 && rnum < 1000)
        CurSceneRolePic = Rrole[rnum + 1].Data[14];  // WalkPic
    else
        CurSceneRolePic = BEGIN_WALKPIC;

    // 初始化ExGroundS (扩展地面数据)
    memset(ExGroundS, 0, sizeof(ExGroundS));

    // 从SData复制地面数据
    for (int i1 = 0; i1 < 64; i1++)
        for (int i2 = 0; i2 < 64; i2++)
            ExGroundS[i1 + 64][i2 + 64] = (int16_t)SData[CurScene][0][i1][i2];

    // 扩展地面 - 周围复制
    if (EXPAND_GROUND == 1)
    {
        for (int i1 = 0; i1 < 64; i1++)
        {
            for (int i2 = 0; i2 < 64; i2++)
            {
                ExGroundS[i1][i2 + 64] = ExGroundS[64][i2 + 64];
                ExGroundS[i1 + 128][i2 + 64] = ExGroundS[127][i2 + 64];
            }
        }
        for (int i1 = 0; i1 < 192; i1++)
        {
            for (int i2 = 0; i2 < 64; i2++)
            {
                ExGroundS[i1][i2] = ExGroundS[i1][64];
                ExGroundS[i1][i2 + 128] = ExGroundS[i1][127];
            }
        }
    }
}

int CalBlock(int x, int y)
{
    return x * 64 + y;
}

void CalPosOnImage(int i1, int i2, int& x, int& y)
{
    x = -(i1 - 32) * 18 + (i2 - 32) * 18 + ImageWidth / 2;
    y = (i1 - 32) * 9 + (i2 - 32) * 9 + ImageHeight / 2;
}

void CalLTPosOnImageByCenter(int i1, int i2, int& x, int& y)
{
    x = -(i1) * 18 + (i2) * 18;
    y = (i1) * 9 + (i2) * 9;
}

//----------------------------------------------------------------------
// 战场绘制
//----------------------------------------------------------------------
void DrawBField()
{
    // TODO: 完整战场绘制
    int Bx1 = Bx, By1 = By;
    int widthregion = CENTER_X / 36 + 3;
    int sumregion = CENTER_Y / 9;

    for (int sum = -sumregion; sum <= sumregion + 15; sum++)
        for (int i = -widthregion; i <= widthregion; i++)
        {
            int i1 = Bx1 + i + sum / 2;
            int i2 = By1 - i + (sum - sum / 2);
            if (i1 >= 0 && i1 < 64 && i2 >= 0 && i2 < 64)
            {
                TPosition pos = GetPositionOnScreen(i1, i2, Bx1, By1);
                int num = BField[CurrentBattle][i1][i2] / 2;
                if (num > 0) DrawSPic(num, pos.x, pos.y);
            }
        }

    // 画战场上的角色
    for (int i = 0; i < BRoleAmount; i++)
    {
        if (Brole[i].Dead != 0) continue;
        TPosition pos = GetPositionOnScreen(Brole[i].X, Brole[i].Y, Bx1, By1);
        // TODO: 画角色贴图
    }
}

void DrawBfieldWithoutRole(int x, int y) { /* TODO */ }

void DrawRoleOnBfield(int x, int y, uint32 mixColor, int mixAlpha, int Alpha)
{
    // TODO: 画战场角色
}

void InitialBFieldImage(int layer) { /* TODO */ }

void DrawBFieldWithCursor(int AttAreaType, int step, int range)
{
    // TODO: 画战场选择光标
}

void DrawBlackScreen()
{
    DrawRectangleWithoutFrame(0, 0, CENTER_X * 2, CENTER_Y * 2, MapRGBA(0, 0, 0), 50);
}

void DrawBFieldWithEft(int Epicnum, int beginpic, int endpic, int curlevel, int bnum, int SelectAimMode, int flash,
    uint32 mixColor, int index, int shadow, int alpha, uint32 MixColor2, int MixAlpha2)
{
    // TODO: 战场特效绘制
}

void DrawBFieldWithAction(int bnum, int Apicnum)
{
    // TODO: 战场动作绘制
}

//----------------------------------------------------------------------
// DrawClouds - 画云
//----------------------------------------------------------------------
void DrawClouds()
{
    if (Where != 0) return;
    for (int i = 0; i < (int)Cloud.size(); i++)
    {
        DrawCPic(Cloud[i].Picnum, Cloud[i].Positionx, Cloud[i].Positiony,
            Cloud[i].Shadow, Cloud[i].Alpha, Cloud[i].mixColor, Cloud[i].mixAlpha);
        Cloud[i].Positionx += Cloud[i].Speedx;
        Cloud[i].Positiony += Cloud[i].Speedy;
        if (Cloud[i].Positionx > CENTER_X * 2 + 200)
            CloudCreateOnSide(i);
    }
}

void DrawProgress()
{
    // TODO: 画加载进度
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
    // 简单文字框
    DrawRectangle(x, y, len * 10 + 24, 30, MapRGBA(0, 0, 0), MapRGBA(255, 255, 255), 50, 0);
    return len * 10 + 24;
}

void DrawTextWithRect(const std::string& word, int x, int y, int w, uint32 color1, uint32 color2, int alpha, int Refresh)
{
    DrawRectangle(x, y, w, 30, MapRGBA(0, 0, 0), MapRGBA(255, 255, 255), alpha);
    DrawShadowText(word, x + 5, y + 5, color1, color2);
    if (Refresh == 1) UpdateAllScreen();
}

void DrawVirtualKey()
{
    if (CellPhone == 0 || ShowVirtualKey == 0) return;
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
