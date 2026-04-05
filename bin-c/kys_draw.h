#pragma once
// kys_draw.h - 图形绘制系统
// 对应 kys_draw.pas

#include "kys_type.h"
#include <string>

// 绘制各类图片
void DrawPic(SDL_Surface* sur, int Pictype, int num, int px, int py, int shadow, int alpha, uint32 mixColor, int mixAlpha);
void DrawTPic(int imgnum, int px, int py, SDL_Rect* region = nullptr, int shadow = 0, int Alpha = 0,
    uint32 mixColor = 0, int mixAlpha = 0, float scalex = 1, float scaley = 1, float angle = 0);
void DrawMPic(int num, int px, int py, int Framenum = -1, int shadow = 0, int alpha = 0,
    uint32 mixColor = 0, int mixAlpha = 0, float scalex = 1, float scaley = 1, float angle = 0);
void DrawSPic(int num, int px, int py, int shadow = 0, int alpha = 0,
    uint32 mixColor = 0, int mixAlpha = 0, float scalex = 1, float scaley = 1, float angle = 0);
void DrawSPic(int num, int px, int py, int shadow, int alpha,
    uint32 mixColor, int mixAlpha, int depth,
    int16_t* BlockImgR, int Width, int Height, int size, int leftupx, int leftupy,
    float scalex = 1, float scaley = 1, float angle = 0);
void DrawHeadPic(int num, int px, int py, int shadow = 0, int alpha = 0,
    uint32 mixColor = 0, int mixAlpha = 0);
void DrawHeadPic(int num, int px, int py, int shadow, int alpha,
    uint32 mixColor, int mixAlpha, int depth,
    int16_t* BlockImgR, int Width, int Height, int size, int leftupx, int leftupy);
void DrawEPic(int egroup, int eNum, int px, int py, int shadow = 0, int alpha = 0,
    uint32 mixColor = 0, int mixAlpha = 0);
void DrawEPic(int egroup, int eNum, int px, int py, int shadow, int alpha,
    uint32 mixColor, int mixAlpha, int depth,
    int16_t* BlockImgR, int Width, int Height, int size, int leftupx, int leftupy);
void DrawFPic(int fgroup, int fnum, int px, int py, int shadow = 0, int alpha = 0,
    uint32 mixColor = 0, int mixAlpha = 0);
void DrawFPic(int fgroup, int fnum, int px, int py, int shadow, int alpha,
    uint32 mixColor, int mixAlpha, int depth,
    int16_t* BlockImgR, int Width, int Height, int size, int leftupx, int leftupy);
void DrawCPic(int num, int px, int py, int shadow = 0, int alpha = 0,
    uint32 mixColor = 0, int mixAlpha = 0);
void DrawIPic(int num, int px, int py, int shadow = 0, int alpha = 0,
    uint32 mixColor = 0, int mixAlpha = 0);

// 屏幕绘制
void Redraw();
void DrawMMap();
void DrawScene();
void DrawSceneWithoutRole();
void DrawRoleOnScene();
void DrawBField();
void DrawBfieldWithoutRole();
void DrawRoleOnBfield();

// 场景初始化
void InitialScene(int Visible = 0);
void InitialBFieldImage();
void ExpandGroundOnImg();

// 坐标计算
int CalBlock(int x, int y, int centerx, int centery);
TPosition CalPosOnImage(int x, int y, int centerx, int centery);
TPosition CalLTPosOnImageByCenter(int centerx, int centery);

// 地面纹理
void LoadGroundTex();

// 带效果的战场绘制
void DrawBFieldWithCursor(int bnum, int mode, int step = 0);
void DrawBFieldWithEft(int bnum, int egroup, int beginpic, int endpic);
void DrawBFieldWithAction(int bnum, int beginpic, int endpic);

// UI元素
void DrawBlackScreen();
void DrawClouds();
void DrawProgress(int x, int y, int w);
void DrawVirtualKey();
int DrawTextFrame(int x, int y, int num);
void DrawTextWithRect(const std::string& word, int x, int y, int w, uint32 color1, uint32 color2);

// 贴图销毁
void DestroyAllTextures();
