#ifndef VIDEO_H
#define VIDEO_H

#ifdef __cplusplus
extern "C"
{
#endif

#include "common.h"

#define SafeFreeSdlSurface(p) do {if(p) {SDL_FreeSurface(p);p=NULL;}} while(0)

extern SDL_Surface *gpScreen;
extern WORD g_wInitialWidth;
extern WORD g_wInitialHeight;
extern SDL_Color	g_colors[256];
extern Uint32	g_colors32[256];

typedef VOID (*LPITEMCHANGED_CALLBACK)(short);
#define MENUITEM_VALUE_CANCELLED      -1

#define MAINMENU_LABEL_NEWGAME             1
#define MAINMENU_LABEL_LOADGAME            2
#define MAINMENU_LABEL_EXITGAME            3
#define MAINMENU_LABEL_LOADGAME1           4
#define MAINMENU_LABEL_LOADGAME2           5
#define MAINMENU_LABEL_LOADGAME3           6

#define MAINMENU_LABEL_YILIAO          7
#define MAINMENU_LABEL_JIEDU           8
#define MAINMENU_LABEL_WUPIN           9
#define MAINMENU_LABEL_ZHUANGTAI       10
#define MAINMENU_LABEL_LIDUI           11
#define MAINMENU_LABEL_XITONG          12

#define MAINMENU_LABEL_SAVE1         13
#define MAINMENU_LABEL_SAVE2         14
#define MAINMENU_LABEL_SAVE3         15
#define MAINMENU_LABEL_LOAD1		 16
#define MAINMENU_LABEL_LOAD2         17
#define MAINMENU_LABEL_LOAD3         18
#define MAINMENU_LABEL_SOUND         19
#define MAINMENU_LABEL_MUSIC         20
#define MAINMENU_LABEL_EXIT          21

#define MAINMENU_LABEL_MOVE         22
#define MAINMENU_LABEL_GONGJI       23
#define MAINMENU_LABEL_YONGDU       24
#define MAINMENU_LABEL_WAIT		    25
#define MAINMENU_LABEL_REST         26
#define MAINMENU_LABEL_AUTO         27

#define MAINMENU_LABEL_GO          97
#define MAINMENU_LABEL_RETURN        98
#define MAINMENU_LABEL_TRANS         99

typedef struct tagMENUITEM
{
   short          wValue;
   short          wNumWord;
   LPCSTR         pText;//LPCSTR
   BOOL          fEnabled;
   JY_POS        pos;
} MENUITEM, *LPMENUITEM;

INT JY_VideoInit(WORD wScreenWidth,WORD wScreenHeight,BOOL fFullScreen);
INT JY_VideoInitPaltte(VOID);
VOID JY_VideoShutdown(VOID);
VOID JY_VideoBackupScreen(short iNum);
VOID JY_VideoRestoreScreen(short iNum);
INT JY_FillColor(INT x1,INT y1,INT x2,INT y2,Uint32 color);
INT JY_ShowSurface(VOID);
INT JY_Delay(INT x);
INT JY_GetTime(VOID);
INT JY_ShowSlow(INT delaytime,INT Flag);
VOID JY_DrawTitleScreen(VOID);
INT JY_DrawStr(INT x, INT y, const char *str,INT color,INT charset,BOOL bBox,BOOL bOffset);
INT JY_DrawMenu(LPMENUITEM rgMenuItem,INT nMenuItem,short wDefaultItem,BOOL bBox,Uint32 color,Uint32 colorSelect);
short JY_ShowMenu(LPMENUITEM rgMenuItem,LPITEMCHANGED_CALLBACK lpfnMenuItemChanged,INT nMenuItem,short wDefaultItem,BOOL bBox,BOOL bEsc,Uint32 color,Uint32 colorSelect);
INT BlitSurface(SDL_Surface* lps, INT x, INT y ,INT flag,INT value);
INT BlitSurface0(SDL_Surface* lps, INT x, INT y ,INT w,INT h);
VOID JY_PutPixel(SDL_Surface *surface, INT x, INT y, Uint32 pixel);
VOID JY_DrawBox(INT x1,INT y1,INT x2,INT y2,Uint32 color);
int JY_Background(int x1,int y1,int x2,int y2,int Bright);
VOID JY_DrawTalkDialogBak(short iHeadImgNum, short iFlag);
VOID JY_ThingDilagBack(short iFlag);
short JY_DrawThingDilag(short iFristItem,short iCurrentItem,short iEndItem,short iType);
VOID JY_DrawPersonStatus(short iCurrentItem);
VOID JY_DrawGetThingDialog(short iWuPin, short iNum);
short JY_DrawTextDialog(LPCSTR strInfo,JY_POS pos,bool bBk,bool bWaitKey,BOOL bOffset);
INT JY_GetColor(INT r,INT g,INT b);
VOID JY_DrawMemUse(VOID);
VOID JY_BlitSurfaceRoat(VOID);
short JY_DrawTransDilag(short iFristItem,short iCurrentItem,short iEndItem);
#ifdef __cplusplus
}
#endif

#endif