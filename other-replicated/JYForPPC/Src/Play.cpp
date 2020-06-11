#include "main.h"
VOID JY_StartFrame(VOID)
{
	if (gpGlobals->g.Status == 1)//首次加载场景地图
	{
		JY_PicInit();
		JY_PicLoadFile("\\Resource\\data\\Smap\\Smap",1);
		JY_PicLoadFile("\\Resource\\data\\Hdgrp\\Hdgrp",2);
		gpGlobals->g.Status = 4;
		JY_ShowSlow(1,1);
		JY_DrawSMap(gpGlobals->g.pBaseList->SMapX,
			gpGlobals->g.pBaseList->SMapY,
			gpGlobals->g.iSubSceneX,
			gpGlobals->g.iSubSceneY,
			gpGlobals->g.iMyPic);
		JY_DrawSceneName();
		JY_ShowSlow(1,0);
		JY_Delay(1000);
	} 
	else if (gpGlobals->g.Status == 2)//首次加载大地图
	{
		JY_PicInit();
		JY_LoadMMap();
		JY_PicLoadFile("\\Resource\\data\\Mmap\\Mmap",0);
		JY_PicLoadFile("\\Resource\\data\\Hdgrp\\Hdgrp",2);
		gpGlobals->g.Status = 3;
		OGG_Play(0, FALSE);
		OGG_Play(16, TRUE);
		JY_ShowSlow(1,1);
		JY_DrawMMap(gpGlobals->g.pBaseList->WMapX,
			gpGlobals->g.pBaseList->WMapY,
			JY_GetMyPic());
		JY_ShowSlow(1,0);
	} 
	else if (gpGlobals->g.Status == 3)//大地图
	{
		JY_Game_MMap();
	}
	else if (gpGlobals->g.Status == 4)//
	{
		JY_Game_SMap();
	}
}
