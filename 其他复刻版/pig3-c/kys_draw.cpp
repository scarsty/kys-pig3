#include "kys_draw.h"
#include "kys_engine.h"

void DrawTPic(int imgnum, int px, int py, SDL_Rect *region, int shadow,
              int alpha, Uint32 mixColor, int mixAlpha, double angle)
{
    DrawPNGTile(render, TitlePNGIndex[imgnum], 0, px, py, region, shadow, alpha, mixColor,
                mixAlpha, 1, 1, angle, NULL);
}


void Redraw()
{
    switch(Where)
    {
        case 3:
        {
            //CleanTextScreen;
            DrawTPic(0, OpenPicPosition.x, OpenPicPosition.y, NULL, 0, 0, 0, 0, 0);
            DrawTPic(12, CENTER_X - 384 + 45, CENTER_Y - 240 + 53, NULL, 0, 0, 0, 0, 0);
            DrawTPic(10, CENTER_X - 384 + 45, CENTER_Y - 240 + 43, NULL, 0, 0, 0, 0, 0);
            DrawTPic(10, CENTER_X - 384 + 524, CENTER_Y - 240 + 43, NULL, 0, 0, 0, 0, 0);
            DrawShadowText(versionstr, OpenPicPosition.x + 5, CENTER_Y - 240 + 455, 0, 0);
            break;
        }
        case 4:
        {
            DrawTPic(0, OpenPicPosition.x, OpenPicPosition.y, NULL, 0, 0, 0, 0, 0);
            DrawShadowText(versionstr, OpenPicPosition.x + 5, CENTER_Y - 240 + 455, 0, 0);
            break;
        }
    }
}