#pragma once
// kys_draw.h - 图形绘制系统
// 对应 kys_draw.pas

#include "kys_type.h"
#include <string>

// 绘制各类图片
void DrawPic(SDL_Surface* sur, int Pictype, int num, int px, int py, int shadow, int alpha, uint32 mixColor, int mixAlpha);
void DrawTPic(int imgnum, int px, int py, SDL_Rect* region = nullptr, int shadow = 0, int Alpha = 255,
    uint32 mixColor = 0, int mixAlpha = 0, double scalex = 1, double scaley = 1, double angle = 0);
void DrawMPic(int num, int px, int py, int Framenum = -1, int shadow = 0, int alpha = 255,
    uint32 mixColor = 0, int mixAlpha = 0, double scalex = 1, double scaley = 1, double angle = 0);
void DrawSPic(int num, int px, int py);
void DrawSPic(int num, int px, int py, SDL_Rect* region, int shadow, int alpha, uint32 mixColor, int mixAlpha);
void DrawHeadPic(int num, int px, int py, int shadow = 0, int alpha = 255,
    uint32 mixColor = 0, int mixAlpha = 0, double scalex = 1, double scaley = 1);
void DrawEPic(int num, int px, int py, int eNum = 0);
void DrawEPic(int num, int px, int py, int shadow, int alpha,
    uint32 mixColor, int mixAlpha, int eNum,
    double scalex = 1, double scaley = 1, double angle = 0, SDL_Point* center = nullptr);
void DrawFPic(int num, int px, int py, int index);
void DrawFPic(int num, int px, int py, int index, int shadow, int alpha, uint32 mixColor, int mixAlpha);
void DrawCPic(int num, int px, int py, int shadow = 0, int alpha = 255,
    uint32 mixColor = 0, int mixAlpha = 0);
void DrawIPic(int num, int px, int py, int shadow = 0, int alpha = 255,
    uint32 mixColor = 0, int mixAlpha = 0);

// 屏幕绘制
void Redraw();
void DrawMMap();
void DrawScene();
void DrawSceneWithoutRole(int x = 0, int y = 0);
void DrawRoleOnScene(int x = 0, int y = 0);
void DrawBField();
void DrawBfieldWithoutRole(int x = 0, int y = 0);
void DrawRoleOnBfield(int x = 0, int y = 0, uint32 mixColor = 0, int mixAlpha = 0, int Alpha = 255);

// 场景初始化
void InitialScene(int Visible = 0);
void InitialBFieldImage(int layer = 0);
void ExpandGroundOnImg();

// 坐标计算
int CalBlock(int x, int y);
void CalPosOnImage(int i1, int i2, int& x, int& y);
void CalLTPosOnImageByCenter(int i1, int i2, int& x, int& y);

// 地面纹理
void LoadGroundTex(int x = 0, int y = 0);

// 带效果的战场绘制
void DrawBFieldWithCursor(int AttAreaType, int step = 0, int range = 0);
void DrawBFieldWithEft(int Epicnum, int beginpic, int endpic, int curlevel = 0, int bnum = 0,
    int SelectAimMode = 0, int flash = 0, uint32 mixColor = 0, int index = 0,
    int shadow = 0, int alpha = 0, uint32 MixColor2 = 0, int MixAlpha2 = 0);
void DrawBFieldWithAction(int bnum, int Apicnum);

// UI元素
void DrawBlackScreen();
void DrawClouds();
void DrawProgress();
void DrawVirtualKey();
int DrawTextFrame(int x, int y, int len, int alpha = 255, uint32 mixColor = 0, int mixAlpha = 0);
void DrawTextWithRect(const std::string& word, int x, int y, int w, uint32 color1, uint32 color2,
    int alpha = 255, int Refresh = 1);

// 贴图销毁
void DestroyAllTextures(int all = 0);
