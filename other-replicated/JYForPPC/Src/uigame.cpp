#include "main.h"

INT JY_OpeningMenu(VOID)
{
	short          wItemSelected    = 0;
	short          wDefaultItem     = 0;

	MENUITEM      rgMainMenuItem[4] = {
	  {  0, MAINMENU_LABEL_NEWGAME, "重新开始",   TRUE,     JY_XY(g_wInitialWidth/2 - (g_iFontSize + 4) *2, g_wInitialHeight/2 + g_iFontSize + 4) },
	  {  1, MAINMENU_LABEL_LOADGAME,"载入进度",   TRUE,     JY_XY(g_wInitialWidth/2 - (g_iFontSize + 4) *2, g_wInitialHeight/2 + (g_iFontSize + 4) *2 ) },
	  {  2, MAINMENU_LABEL_EXITGAME,"退出游戏",   TRUE,     JY_XY(g_wInitialWidth/2 - (g_iFontSize + 4) *2, g_wInitialHeight/2 + (g_iFontSize + 4) *3) },
	  {  3, MAINMENU_LABEL_TRANS,"转换资源",   TRUE,     JY_XY(g_wInitialWidth/2 - (g_iFontSize + 4) *2, g_wInitialHeight/2 + (g_iFontSize + 4) *4) },
	};
	MENUITEM      rgLoadMenuItem[4] = {
	  {  1, MAINMENU_LABEL_LOADGAME1,"进度一",  TRUE,     JY_XY(g_wInitialWidth/2 - (g_iFontSize + 4) *2 + (g_iFontSize + 4)/2, g_wInitialHeight/2 + g_iFontSize + 4) },
	  {  2, MAINMENU_LABEL_LOADGAME2,"进度二",  TRUE,     JY_XY(g_wInitialWidth/2 - (g_iFontSize + 4) *2 + (g_iFontSize + 4)/2, g_wInitialHeight/2 + (g_iFontSize + 4) *2) },
	  {  3, MAINMENU_LABEL_LOADGAME3,"进度三",  TRUE,     JY_XY(g_wInitialWidth/2 - (g_iFontSize + 4) *2 + (g_iFontSize + 4)/2, g_wInitialHeight/2 + (g_iFontSize + 4) *3) },
	  {  4, MAINMENU_LABEL_RETURN,"返  回",  TRUE,     JY_XY(g_wInitialWidth/2 - (g_iFontSize + 4) *2 + (g_iFontSize + 4)/2, g_wInitialHeight/2 + (g_iFontSize + 4) *4) }
	};
	LPMENUITEM pMenu = NULL;
	INT iMenuNum = 0;

	//JY_END();

	OGG_Play(0,FALSE);
	OGG_Play(17, TRUE);
	JY_DrawTitleScreen();
	JY_ShowSlow(1,0);

	pMenu = rgMainMenuItem;
	iMenuNum = 4;

	while (TRUE)
	{
		wItemSelected = JY_ShowMenu(pMenu,NULL, iMenuNum, wDefaultItem, FALSE,FALSE,HONGCOLOR - 10,HONGCOLOR);
		if (wItemSelected == 0)
		{
			JY_NewHeroAttrib();
			JY_FillColor(1,g_wInitialHeight/2 + 20,g_wInitialWidth,g_wInitialHeight,0);
			JY_DrawStr(g_wInitialWidth/2,g_wInitialHeight/2+40,"请稍候...",HONGCOLOR,0,FALSE,TRUE);
			JY_ShowSurface();
			break;
		}
		if (wItemSelected == 1)
		{
			JY_FillColor(1,g_wInitialHeight/2 + 20,g_wInitialWidth,g_wInitialHeight,0);
			pMenu = rgLoadMenuItem;
			iMenuNum = 4;
			wItemSelected = JY_ShowMenu(pMenu,NULL, iMenuNum, wDefaultItem, FALSE,FALSE,HONGCOLOR - 10,HONGCOLOR);
			if (wItemSelected != 4)
			{
				JY_FillColor(1,g_wInitialHeight/2 + (g_iFontSize + 4),g_wInitialWidth,g_wInitialHeight,0);
				JY_DrawStr(g_wInitialWidth/2,g_wInitialHeight/2+40,"请稍候...",HONGCOLOR,0,FALSE,TRUE);
				JY_ShowSurface();
				break;
			}
			else
			{
				pMenu = rgMainMenuItem;
				iMenuNum = 4;
				JY_FillColor(1,g_wInitialHeight/2 + 20,g_wInitialWidth,g_wInitialHeight,0);	
			}
		}
		if (wItemSelected == 2)
		{
			wItemSelected = -1;
			break;
		}
		if (wItemSelected == 3)
		{
			JY_FillColor(1,g_wInitialHeight/2 + 20,g_wInitialWidth,g_wInitialHeight,0);
			JY_DrawStr(g_wInitialWidth/2,g_wInitialHeight/2+40,"请稍候...",HONGCOLOR,0,FALSE,TRUE);
			JY_ShowSurface();
			JY_TRANS();
			JY_FillColor(1,g_wInitialHeight/2 + (g_iFontSize + 4),g_wInitialWidth,g_wInitialHeight,0);			
		}
	}

	pMenu = NULL;

	return (INT)wItemSelected;
}

VOID JY_NewHeroAttrib(VOID)
{
	srand((unsigned)SDL_GetTicks());

	JY_CreateNewHeroAttrib();
	bool bExit = false;
	DWORD dwTime = SDL_GetTicks();
	while(!bExit)
	{
		SDL_Delay(100);
		JY_ClearKeyState();
		JY_ProcessEvent();		
		if (g_InputState.dwKeyPress & kKeySearch)
		{
			bExit = TRUE;
		}
		else if (g_InputState.dwKeyPress & kKeyMenu)
		{
			JY_CreateNewHeroAttrib();
		}
	}
}
VOID JY_CreateNewHeroAttrib(VOID)
{
	//新角色属性
	
	gpGlobals->g.Hero.NeiliXingZhi = rand() % 2;
	gpGlobals->g.Hero.HpAdd = rand() % 5 + 3;
	gpGlobals->g.Hero.hpMax = gpGlobals->g.Hero.HpAdd * 3 + 29;
	gpGlobals->g.Hero.hp = gpGlobals->g.Hero.hpMax;
	gpGlobals->g.Hero.NeiliMax = 25 + rand() % 26;
	gpGlobals->g.Hero.Neili = gpGlobals->g.Hero.NeiliMax;
	gpGlobals->g.Hero.GongJiLi = 25 + rand() % 26;	
	gpGlobals->g.Hero.QingGong = 25 + rand() % 26;
	gpGlobals->g.Hero.FangYuLi = 25 + rand() % 26;
	gpGlobals->g.Hero.YiLiao = 22 + rand() % 29;
	gpGlobals->g.Hero.YongDu = 22 + rand() % 29;
	gpGlobals->g.Hero.JieDu = 22 + rand() % 29;
	gpGlobals->g.Hero.KangDu = 22 + rand() % 29;
	gpGlobals->g.Hero.QuanZhang = 21 + rand() % 30;
	gpGlobals->g.Hero.YuJian = 21 + rand() % 30;
	gpGlobals->g.Hero.ShuaDao = 21 + rand() % 30;
	gpGlobals->g.Hero.TeSHuBingQi = 21 + rand() % 30;
	gpGlobals->g.Hero.AnQiJiQiao = 21 + rand() % 30;
	
	short iTemp = rand() % 10;
	if (iTemp <2 )
	{
		gpGlobals->g.Hero.ZiZhi = rand() % 35 + 30;
	}
	else if (iTemp <=7)
	{
		gpGlobals->g.Hero.ZiZhi = rand() % 20 + 60;
	}
	else
	{
		gpGlobals->g.Hero.ZiZhi = rand() % 20 + 75;
	}

	JY_FillColor(1,g_wInitialHeight/2 + 20,g_wInitialWidth,g_wInitialHeight,0);

	char *pText = va("徐小侠\t这样的属性满意么?");
	if (pText == NULL)
		return;

	int iLen = strlen(pText);
	JY_DrawStr((g_iFontSize + 4)*3,g_wInitialHeight/2+(g_iFontSize + 4),pText,HONGCOLOR,0,FALSE,FALSE);
	pText = va("内力:%d 武力:%d 轻功:%d", 
		gpGlobals->g.Hero.Neili,
		gpGlobals->g.Hero.GongJiLi,
		gpGlobals->g.Hero.QingGong);
	if (pText == NULL)
		return;
	JY_DrawStr((g_iFontSize + 4)*3,g_wInitialHeight/2+(g_iFontSize + 4)*2,pText,HONGCOLOR,0,FALSE,FALSE);
	SafeFree(pText);
	pText = va("防御:%d 生命:%d 医疗:%d", 
		gpGlobals->g.Hero.FangYuLi,
		gpGlobals->g.Hero.hp,
		gpGlobals->g.Hero.YiLiao);
	if (pText == NULL)
		return;
	JY_DrawStr((g_iFontSize + 4)*3,g_wInitialHeight/2+(g_iFontSize + 4)*3,pText,HONGCOLOR,0,FALSE,FALSE);
	SafeFree(pText);
	pText = va("使毒:%d 解毒:%d 拳掌:%d", 
		gpGlobals->g.Hero.YongDu,
		gpGlobals->g.Hero.JieDu,
		gpGlobals->g.Hero.QuanZhang);
	if (pText == NULL)
		return;
	JY_DrawStr((g_iFontSize + 4)*3,g_wInitialHeight/2+(g_iFontSize + 4)*4,pText,HONGCOLOR,0,FALSE,FALSE);
	SafeFree(pText);
	pText = va("剑术:%d 刀术:%d 暗器:%d", 
		gpGlobals->g.Hero.YuJian,
		gpGlobals->g.Hero.ShuaDao,
		gpGlobals->g.Hero.AnQiJiQiao);
	if (pText == NULL)
		return;
	JY_DrawStr((g_iFontSize + 4)*3,g_wInitialHeight/2+(g_iFontSize + 4)*5,pText,HONGCOLOR,0,FALSE,FALSE);
	SafeFree(pText);

	JY_ShowSurface();

}
