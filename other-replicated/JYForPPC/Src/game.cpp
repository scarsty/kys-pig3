#include "main.h"
//ÓÎÏ·Ö÷Ñ­»·
VOID JY_GameMain(VOID)
{
	DWORD       dwTime;
	gpGlobals->bCurrentSaveSlot = JY_OpeningMenu();
	if (gpGlobals->bCurrentSaveSlot != -1)
	{		
		JY_InitGameData(gpGlobals->bCurrentSaveSlot);
		dwTime = SDL_GetTicks();
	//	
		while (TRUE)
		{
			if (gpGlobals->g.Status == -1)
			{
				JY_FillColor(0,0,0,0,0);
				gpGlobals->bCurrentSaveSlot = JY_OpeningMenu();
				if (gpGlobals->bCurrentSaveSlot != -1)
				{	
					JY_InitGameData(gpGlobals->bCurrentSaveSlot);
				}
				else
				{
					break;
				}
			}
			if (gpGlobals->fGameStart == FALSE)
			{
				break;
			}
			if (gpGlobals->fGameLoad == TRUE)
			{
				gpGlobals->fGameLoad = FALSE;
				JY_InitGameData(gpGlobals->bCurrentSaveSlot);				
			}
			if (gpGlobals->fGameSave == TRUE)
			{
				gpGlobals->fGameSave = FALSE;
				JY_SaveSaveSlot(gpGlobals->bCurrentSaveSlot);
			}
			gpGlobals->g.iMytick += 1;
			if (gpGlobals->g.iMytick %6 == 0)
			{
				gpGlobals->g.iMyCurrentPic = 0;
			}
			if (gpGlobals->g.iMytick %1000 == 0)
			{
				gpGlobals->g.iMytick = 0;
			}

			JY_ClearKeyState();
			JY_ProcessEvent();
			while (SDL_GetTicks() <= dwTime)
			{
				JY_ProcessEvent();
				SDL_Delay(1);
			}
			dwTime = SDL_GetTicks() + FRAME_TIME;
			JY_StartFrame();
		}
	}
}