#pragma once
#include "kys_type.h"

int DrawUText(char *text, int x_pos, int y_pos, Uint32 color, int engwidth);
int DrawShadowText(char *text, int x_pos, int y_pos, Uint32 color1, Uint32 color2);

char *ReadFileToBuffer(char *p, char *filename, int size, int needmalloc, int *filesize);
void FreeFileBuffer(char *p);
int LoadPNGTiles(char *path, PNGIndex **P, SDL_Texture ***T, SDL_Surface ***S, int LoadPic);
void LoadOnePNGTexture(char *path, char *p, PNGIndex *P, int forceLoad);
int DrawPNGTile(SDL_Renderer *render, PNGIndex P, int FrameNum,
                int px, int py, SDL_Rect *region, int shadow, int alpha, Uint32 mixColor, int mixAlpha,
                double scalex, double scaley, double angle, SDL_Point *center);
void GetRGBA(Uint32 color, byte *r, byte* g, byte *b, byte *a);

void UpdateAllScreen();

void CleanKeyValue();
void CheckBasicEvent();

//void