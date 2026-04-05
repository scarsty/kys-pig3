#pragma once
// kys_engine.h - 基础引擎: 音频、文件IO、绘图、文字、屏幕管理
// 对应 kys_engine.pas

#include "kys_type.h"
#include <string>
#include <vector>

// 音频系统
bool EnsureMixerCreated();
bool EnsureTrackForAudio(MIX_Track*& track, MIX_Audio* audio);
MIX_Track* AcquireSfxTrack(MIX_Audio* audio);
void InitialMusic();
void FreeAllMusic();
void PlayMP3(int MusicNum, int times, int frombeginning = 1);
void PlayMP3(const char* filename, int times);
void StopMP3(int frombeginning = 1);
void PlaySound(int SoundNum, int times);
void PlaySound(int SoundNum, int times, int x, int y, int z);
void PlaySound(int SoundNum);
void PlaySound(const char* filename, int times);
void PlaySoundA(int SoundNum, int times);

// SDL事件
bool EventFilter(void* p, SDL_Event* e);
bool EventWatch(void* p, SDL_Event* e);
void SendKeyEvent(int keyvalue);

// 基本绘图
void PutPixel(SDL_Surface* surface, int x, int y, uint32 pixel);
uint32 GetPixel(SDL_Surface* surface, int x, int y);
uint32 ColColor(int num);
bool JudgeInScreen(int px, int py, int w, int h, int xs, int ys);
bool JudgeInScreen(int px, int py, int w, int h, int xs, int ys, int xx, int yy, int xw, int yh);
TPosition GetPositionOnScreen(int x, int y, int CenterX, int CenterY);

// 字符编码
std::string Big5ToUnicode(const char* str);
std::string GBKToUnicode(const char* str);
std::string UnicodeToGBK(const char* str);
std::string Traditional2Simplified(const std::string& str);
std::string Simplified2Traditional(const std::string& str);
bool IsStringUTF8(const std::string& strtmp);

// 文字绘制
void* CreateFontTile(int num, int usesur, int& w, int& h);
void DrawText(const std::string& word, int x_pos, int y_pos, uint32 color, int engwidth = -1);
void DrawEngText(const std::string& word, int x_pos, int y_pos, uint32 color);
void DrawShadowText(const std::string& word, int x_pos, int y_pos, uint32 color1, uint32 color2,
    SDL_Texture* Tex = nullptr, SDL_Surface* Sur = nullptr, int realPosition = 0, int eng = 0);
void DrawEngShadowText(const std::string& word, int x_pos, int y_pos, uint32 color1, uint32 color2,
    SDL_Texture* Tex = nullptr, SDL_Surface* Sur = nullptr);
int DrawLength(const std::string& str);
void SetFontSize(int Chnsize, int engsize, int initial = 0);

// 矩形绘制
void DrawRectangle(int x, int y, int w, int h, uint32 colorin, uint32 colorframe, int alpha, int trans = 1);
void DrawRectangleWithoutFrame(int x, int y, int w, int h, uint32 colorin, int alpha);
void DrawItemFrame(int x, int y, int realcoord = 0);

// 部分图片绘制
void DrawPartPic(void* pic, int x, int y, int w, int h, int x1, int y1);

// 文件读取
char* ReadFileToBuffer(char* p, const std::string& filename, int size, int malloc_flag);
void FreeFileBuffer(char*& p);
void ReadTxtFileToBuffer(char* p, const std::string& filename);
std::string ReadFileToString(const std::string& filename);
std::vector<int> ReadNumbersFromString(const std::string& str);

// IDX/GRP加载
TIDXGRP LoadIdxGrp(const std::string& stridx, const std::string& strgrp);

// PNG贴图
void InitialPicArrays();
void ReadTiles();
int LoadPNGTiles(const std::string& path, TPNGIndexArray& PNGIndexArray, int LoadPic = 1, int16_t* frame = nullptr);
void LoadOnePNGTexture(const std::string& path, void* z, TPNGIndex& PNGIndex, int forceLoad = 0);
void DrawPNGTile(SDL_Renderer* r, TPNGIndex& PNGIndex, int FrameNum, int px, int py);
void DrawPNGTile(SDL_Renderer* r, TPNGIndex& PNGIndex, int FrameNum, int px, int py,
    SDL_Rect* region, int shadow, int alpha, uint32 mixColor, int mixAlpha,
    double scalex, double scaley, double angle, SDL_Point* center);
void DrawPNGTileS(SDL_Surface* scr, TPNGIndex& PNGIndex, int FrameNum, int px, int py,
    SDL_Rect* region, int shadow, int alpha, uint32 mixColor, int mixAlpha,
    double scalex, double scaley, double angle);

// 屏幕管理
void ResizeWindow(int w, int h);
void CreateMainRenderTextures();
void CreateAssistantRenderTextures();
void DestroyRenderTextures();
void ResizeSimpleText(int initial = 0);
void SwitchFullscreen();
void UpdateAllScreen();
void UpdateScreen(int x = 0, int y = 0, int w = 0, int h = 0);
void CleanTextScreen();
void CleanKeyValue();
void LoadFreshScreen();
void LoadFreshScreen(int x, int y);
void FreeFreshScreen();

// 鼠标
void SDL_GetMouseState2(int& x, int& y);
void GetMousePosition(int& x, int& y, int x0, int y0, int yp = 0);
bool InRegion(int x1, int y1, int x, int y, int w, int h);
bool MouseInRegion(int x, int y, int w, int h);
bool MouseInRegion(int x, int y, int w, int h, int& x1, int& y1);
int RegionParameter(int x, int x1, int x2);

// 系统
uint32 CheckBasicEvent();
int AngleToDirection(double y, double x);
void QuitConfirm();
void ChangeCol();
void TransBlackScreen();
void RecordFreshScreen();
void RecordFreshScreen(int x, int y, int w, int h);
void LoadTeamSimpleStatus(int& max);

// 视频播放
bool PlayMovie(const std::string& filename);

// 排序
void QuickSortB(TBuildInfo* a, int l, int r);

// 真实坐标转换
void GetRealRect(int& x, int& y, int& w, int& h, int force = 0);
TStretchInfo KeepRatioScale(int w0, int h0, int w1, int h1);
SDL_FRect rect2f(const SDL_Rect& r);

// 调试
void tic();
void toc();
