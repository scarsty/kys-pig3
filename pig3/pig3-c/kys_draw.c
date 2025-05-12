#include "kys_draw.h"
#include "kys_engine.h"

void DrawTPic(int imgnum, int px, int py, SDL_Rect *region, int shadow,
              int alpha, Uint32 mixColor, int mixAlpha, double angle)
{
    DrawPNGTile(KYS.render, TitlePNGIndex[imgnum], 0, px, py, region, shadow, alpha, mixColor,
                mixAlpha, 1, 1, angle, NULL);
}


void Redraw()
{
    switch(KYS.Where)
    {
        case 3:
        {
            //CleanTextScreen;
            DrawTPic(0, KYS.OpenPicPosition.x, KYS.OpenPicPosition.y, NULL, 0, 0, 0, 0, 0);
            DrawTPic(12, KYS.CENTER_X - 384 + 45, KYS.CENTER_Y - 240 + 53, NULL, 0, 0, 0, 0, 0);
            DrawTPic(10, KYS.CENTER_X - 384 + 45, KYS.CENTER_Y - 240 + 43, NULL, 0, 0, 0, 0, 0);
            DrawTPic(10, KYS.CENTER_X - 384 + 524, KYS.CENTER_Y - 240 + 43, NULL, 0, 0, 0, 0, 0);
            DrawShadowText(KYS.versionstr, KYS.OpenPicPosition.x + 5, KYS.CENTER_Y - 240 + 455, 0, 0);
            break;
        }
        case 4:
        {
            DrawTPic(0, KYS.OpenPicPosition.x, KYS.OpenPicPosition.y, NULL, 0, 0, 0, 0, 0);
            DrawShadowText(KYS.versionstr, KYS.OpenPicPosition.x + 5, KYS.CENTER_Y - 240 + 455, 0, 0);
            break;
        }
    }
}