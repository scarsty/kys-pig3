#pragma once
#include "kys_type.h"

void DrawTPic(int imgnum, int px, int py, SDL_Rect* region, int shadow,
  int alpha, Uint32 mixColor, int mixAlpha, double angle);

void Redraw();