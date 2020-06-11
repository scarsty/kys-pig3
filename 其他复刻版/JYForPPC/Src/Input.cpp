#include "main.h"

JYINPUTSTATE            g_InputState;

extern WORD					 g_wInitialWidth, g_wInitialHeight, 
						 g_wSclWidth, g_wSclHeight;
extern float			 g_fSclW, g_fSclH;

extern BOOL				 g_bShowVkey;

int						 g_iPrvKey = 0;

typedef struct VirtualKeyboardPos
{
	RECT		pos;
	int			key;
}VkRect;

VkRect vkpos[10];


void DrawRect(BYTE* pixels, int x1, int x2, int y1, int y2, BYTE color)
{
	int y = 0, x= 0;
	
	memset(pixels+y1*g_wInitialWidth+x1, color, x2-x1);
	memset(pixels+y2*g_wInitialWidth+x1, color, x2-x1);

	for (y=y1; y<y2; ++y)
	{
		*(pixels+x1+y*g_wInitialWidth) = color;
		*(pixels+x2+y*g_wInitialWidth) = color;
	}
}

void JY_DrawVKeys(void* pixels)
{
	int w = 0, h = 0, i = 0, color = 0;
	int x1, x2, y1, y2, s;

	if (g_iOldRoat == 0)
	{
		w = g_wInitialWidth;
		h = g_wInitialHeight;

		for (i=0; i<10; ++i)
		{
			//x1 = abs(w - vkpos[i].pos.left);
			//x2 = abs(w - vkpos[i].pos.right);
			//y1 = abs(h - vkpos[i].pos.top);
			//y2 = abs(h - vkpos[i].pos.bottom);
			x1 = abs(vkpos[i].pos.left);
			x2 = abs(vkpos[i].pos.right);
			y1 = abs(vkpos[i].pos.top);
			y2 = abs(vkpos[i].pos.bottom);
			if (x1 > x2) s = x1, x1 = x2, x2 = s;
			if (y1 > y2) s = y1, y1 = y2, y2 = s;

			DrawRect((BYTE*)pixels, x1, x2, y1, y2, 0x17);
		}
	}
	else
	{
		for (i=0; i<10; ++i)
		{
			x1 = abs(w - vkpos[i].pos.left);
			x2 = abs(w - vkpos[i].pos.right);
			y1 = abs(h - vkpos[i].pos.top);
			y2 = abs(h - vkpos[i].pos.bottom);
			if (x1 > x2) s = x1, x1 = x2, x2 = s;
			if (y1 > y2) s = y1, y1 = y2, y2 = s;

			DrawRect((BYTE*)pixels, x1, x2, y1, y2, 0x17);
		}
	}
	
}

void Fillvk(VkRect* pvk, char* szRect, int vkey, float fw, float fh)
{
	DWORD rv[5];
	int n;
	char** spl = spilwhit(szRect, ",", rv, 5, &n);

	if (n<4)
	{
		memset(pvk, 0, sizeof(VkRect));
	}
	else
	{
		pvk->pos.left = atoi(spl[0]) * fw;
		pvk->pos.top = atoi(spl[1]) * fh;
		pvk->pos.right = atoi(spl[2]) * fw;
		pvk->pos.bottom = atoi(spl[3]) * fh;

		pvk->key = vkey;
	}

}

static int g_iMouseDownTimer = 0;

int GetVkey(int x, int y, int flag)
{
	int i = 0, k = 0, w = 0, h = 0,x1,x2,y1,y2,j;
	if (!gpGlobals->curDefKey.bVkey) return 0;

	w = g_wInitialWidth;
	h = g_wInitialHeight;
	
	if (g_iOldRoat == 0)
	{
		for (i=0; i<10; ++i)
		{
			x1 = abs(vkpos[i].pos.left);
			x2 = abs(vkpos[i].pos.right);
			y1 = abs(vkpos[i].pos.top);
			y2 = abs(vkpos[i].pos.bottom);
			if (x1>x2) j=x2,x2=x1,x1=j;
			if (y1>y2) j=y2,y2=y1,y1=j;

			if (x > x1 && x < x2
				&& y > y1 && y < y2)
			{
				return vkpos[i].key;
			}
		}
	}
	else
	{
		for (i=0; i<10; ++i)
		{
			x1 = abs(w-vkpos[i].pos.left);
			x2 = abs(w-vkpos[i].pos.right);
			y1 = abs(h-vkpos[i].pos.top);
			y2 = abs(h-vkpos[i].pos.bottom);
			
			if (x1>x2) j=x2,x2=x1,x1=j;
			if (y1>y2) j=y2,y2=y1,y1=j;

			if (x > x1 && x < x2
				&& y > y1 && y < y2)
			{
				return vkpos[i].key;
			}
		}
	}


	if (flag == SDL_MOUSEBUTTONDOWN) g_iMouseDownTimer = SDL_GetTicks();
	else if (flag == SDL_MOUSEBUTTONUP && g_iMouseDownTimer)
		k = SDL_GetTicks() - g_iMouseDownTimer;

	if (k > 1000)
	{
		if (!g_bShowVkey) JY_VideoBackupScreen(2);
		g_bShowVkey = !g_bShowVkey;
		if (!g_bShowVkey) JY_VideoRestoreScreen(2);

		JY_ShowSurface();
		g_iMouseDownTimer = 0;
	}

	return 0;
}

void transKey(int* k)
{
	if (*k == SDLK_UP) 
		*k = SDLK_DOWN;
	else if (*k == SDLK_DOWN)
		*k = SDLK_UP;
	else if (*k == SDLK_LEFT)
		*k = SDLK_RIGHT;
	else if (*k == SDLK_RIGHT)
		*k = SDLK_LEFT;
}

VOID JY_ClearKeyState(VOID)
{
   g_InputState.dwKeyPress = 0;
}
static VOID JY_KeyboardEventFilter(const SDL_Event *lpEvent)
{
	int bVk = 0;
	BOOL bDirKey = 0;
	SDL_Event* pev = (SDL_Event*)lpEvent;
	if (pev->type == SDL_MOUSEBUTTONDOWN)
	{
		g_iPrvKey = bVk = pev->key.keysym.sym = (SDLKey)GetVkey(pev->motion.x, pev->motion.y, SDL_MOUSEBUTTONDOWN);
		if (bVk) pev->type = SDL_KEYDOWN;
	}
	else if (pev->type == SDL_MOUSEMOTION && pev->motion.state)
	{
		bVk = pev->key.keysym.sym = (SDLKey)GetVkey(pev->motion.x, pev->motion.y, SDL_MOUSEBUTTONDOWN);
		if (bVk) g_iMouseDownTimer = 0;

		if (bVk != g_iPrvKey)
		{
			switch (lpEvent->key.keysym.sym)
			{
			case SDLK_UP:
			case SDLK_KP_8:
				if (g_InputState.dir == kDirNorth)
				{
					g_InputState.dir = g_InputState.prevdir;
				}
				g_InputState.prevdir = kDirUnknown;
				bDirKey = 1;
				break;

			case SDLK_DOWN:
			case SDLK_KP_2:
				if (g_InputState.dir == kDirSouth)
				{
					g_InputState.dir = g_InputState.prevdir;
				}
				g_InputState.prevdir = kDirUnknown;
				bDirKey = 1;
				break;

			case SDLK_LEFT:
			case SDLK_KP_4:
				if (g_InputState.dir == kDirWest)
				{
					g_InputState.dir = g_InputState.prevdir;
				}
				g_InputState.prevdir = kDirUnknown;
				bDirKey = 1;
				break;

			case SDLK_RIGHT:
			case SDLK_KP_6:
				if (g_InputState.dir == kDirEast)
				{
					g_InputState.dir = g_InputState.prevdir;
				}
				g_InputState.prevdir = kDirUnknown;
				bDirKey = 1;
				break;

			default:
				break;
			}
		}
		
		if (bDirKey)
		{
			pev->type = SDL_KEYDOWN;
			g_iPrvKey = bVk;
		}
		
	}
	else if (pev->type == SDL_MOUSEBUTTONUP)
	{
		GetVkey(pev->motion.x, pev->motion.y, SDL_MOUSEBUTTONUP);
		bVk = pev->key.keysym.sym = (SDLKey)g_iPrvKey;
		if (bVk) pev->type = SDL_KEYUP;
		g_iMouseDownTimer = 0;
		g_InputState.dwKeyPress = 0;
		g_InputState.prevdir = kDirUnknown;
	}
#ifdef _WIN32_WCE
	
	if (!bVk)
	{
		if (!gpGlobals->curDefKey.uK_ok)
		{
			if (pev->key.keysym.vkey != 0x25//VK_LEFT
				&& pev->key.keysym.vkey != 0x27//VK_RIGHT
				&& pev->key.keysym.vkey != 0x26//VK_UP
				&& pev->key.keysym.vkey != 0x28)//VK_DOWN)
			{
				gpGlobals->curDefKey.uK_ok = pev->key.keysym.vkey;
				pev->key.keysym.sym = SDLK_SPACE;
			}
		}
		else
		{
			if (gpGlobals->curDefKey.uK_ok == pev->key.keysym.vkey)
			{
				pev->key.keysym.sym = SDLK_SPACE;
			}
			else if (!gpGlobals->curDefKey.uK_esc)
			{
				//if (pev->key.keysym.vkey != VK_LEFT
				//	&& pev->key.keysym.vkey != VK_RIGHT
				//	&& pev->key.keysym.vkey != VK_UP
				//	&& pev->key.keysym.vkey != VK_DOWN)
				if (pev->key.keysym.vkey != 0x25//VK_LEFT
					&& pev->key.keysym.vkey != 0x27//VK_RIGHT
					&& pev->key.keysym.vkey != 0x26//VK_UP
					&& pev->key.keysym.vkey != 0x28)//VK_DOWN)
				{
					gpGlobals->curDefKey.uK_esc = pev->key.keysym.vkey;
					pev->key.keysym.sym = SDLK_ESCAPE;
				}
			}
			else if (gpGlobals->curDefKey.uK_esc == pev->key.keysym.vkey)
			{
				pev->key.keysym.sym = SDLK_ESCAPE;
			}

		}

		if (pev->key.keysym.vkey == gpGlobals->curDefKey.uK_left)
			pev->key.keysym.sym = SDLK_LEFT;
		else if (pev->key.keysym.vkey == gpGlobals->curDefKey.uK_right)
			pev->key.keysym.sym = SDLK_RIGHT;
		else if (pev->key.keysym.vkey == gpGlobals->curDefKey.uK_up)
			pev->key.keysym.sym = SDLK_UP;
		else if (pev->key.keysym.vkey == gpGlobals->curDefKey.uK_down)
			pev->key.keysym.sym = SDLK_DOWN;

		else if (pev->key.keysym.vkey == gpGlobals->curDefKey.uK_a)
			pev->key.keysym.sym = SDLK_a;
		else if (pev->key.keysym.vkey == gpGlobals->curDefKey.uK_r)
			pev->key.keysym.sym = SDLK_r;
		else if (pev->key.keysym.vkey == gpGlobals->curDefKey.uK_e)
			pev->key.keysym.sym = SDLK_e;
		else if (pev->key.keysym.vkey == gpGlobals->curDefKey.uK_w)
			pev->key.keysym.sym = SDLK_w;
	}

#endif

   switch (lpEvent->type)
   {
   case SDL_KEYDOWN:
      //
      // Pressed a key
      //
      if (lpEvent->key.keysym.mod & KMOD_ALT)
      {
         if (lpEvent->key.keysym.sym == SDLK_RETURN)
         {
            //
            // Pressed Alt+Enter (toggle fullscreen)...
            //
            //VIDEO_ToggleFullscreen();
            return;
         }
         else if (lpEvent->key.keysym.sym == SDLK_F4)
         {
            //
            // Pressed Alt+F4 (Exit program)...
            //
            JY_Shutdown();
            exit(0);
         }
      }

      switch (lpEvent->key.keysym.sym)
      {
      case SDLK_UP:
      case SDLK_KP_8:
         g_InputState.prevdir = g_InputState.dir;
         g_InputState.dir = kDirNorth;
         g_InputState.dwKeyPress |= kKeyUp;
         break;

      case SDLK_DOWN:
      case SDLK_KP_2:
         g_InputState.prevdir = g_InputState.dir;
         g_InputState.dir = kDirSouth;
         g_InputState.dwKeyPress |= kKeyDown;
         break;

      case SDLK_LEFT:
      case SDLK_KP_4:
         g_InputState.prevdir = g_InputState.dir;
         g_InputState.dir = kDirWest;
         g_InputState.dwKeyPress |= kKeyLeft;
         break;

      case SDLK_RIGHT:
      case SDLK_KP_6:
         g_InputState.prevdir = g_InputState.dir;
         g_InputState.dir = kDirEast;
         g_InputState.dwKeyPress |= kKeyRight;
         break;
	  
      case SDLK_ESCAPE:
      case SDLK_INSERT:
      case SDLK_LALT:
      case SDLK_RALT:
      case SDLK_KP_0:
         g_InputState.dwKeyPress |= kKeyMenu;
         break;

      case SDLK_RETURN:
      case SDLK_SPACE:
      case SDLK_KP_ENTER:
         g_InputState.dwKeyPress |= kKeySearch;
         break;

      case SDLK_PAGEUP:
      case SDLK_KP_9:
         g_InputState.dwKeyPress |= kKeyPgUp;
         break;

      case SDLK_PAGEDOWN:
      case SDLK_KP_3:
         g_InputState.dwKeyPress |= kKeyPgDn;
         break;

      case SDLK_r:
         g_InputState.dwKeyPress |= kKeyRepeat;
         break;

      case SDLK_a:
         g_InputState.dwKeyPress |= kKeyAuto;
         break;

      case SDLK_d:
         g_InputState.dwKeyPress |= kKeyDefend;
         break;

      case SDLK_e:
         g_InputState.dwKeyPress |= kKeyUseItem;
         break;

      case SDLK_w:
         g_InputState.dwKeyPress |= kKeyThrowItem;
         break;

      case SDLK_q:
         g_InputState.dwKeyPress |= kKeyFlee;
         break;

      case SDLK_s:
         g_InputState.dwKeyPress |= kKeyStatus;
         break;

      case SDLK_f:
         g_InputState.dwKeyPress |= kKeyForce;
         break;

      case SDLK_p:
         //VIDEO_SaveScreenshot();
         break;
	  case SDLK_n:
		 g_InputState.dwKeyPress |= kKeyMenu;
         break;
	  case SDLK_y:
		 g_InputState.dwKeyPress |= kKeySearch;
         break;
      default:
         break;
      }
      break;

   case SDL_KEYUP:
      //
      // Released a key
      //
      switch (lpEvent->key.keysym.sym)
      {
      case SDLK_UP:
      case SDLK_KP_8:
         if (g_InputState.dir == kDirNorth)
         {
            g_InputState.dir = g_InputState.prevdir;
         }
         g_InputState.prevdir = kDirUnknown;
         break;

      case SDLK_DOWN:
      case SDLK_KP_2:
         if (g_InputState.dir == kDirSouth)
         {
            g_InputState.dir = g_InputState.prevdir;
         }
         g_InputState.prevdir = kDirUnknown;
         break;

      case SDLK_LEFT:
      case SDLK_KP_4:
         if (g_InputState.dir == kDirWest)
         {
            g_InputState.dir = g_InputState.prevdir;
         }
         g_InputState.prevdir = kDirUnknown;
         break;

      case SDLK_RIGHT:
      case SDLK_KP_6:
         if (g_InputState.dir == kDirEast)
         {
            g_InputState.dir = g_InputState.prevdir;
         }
         g_InputState.prevdir = kDirUnknown;
         break;

      default:
         break;
      }
      break;
   }
}

static int SDLCALL JY_EventFilter(void *userdata, SDL_Event * lpEvent)
{
   switch (lpEvent->type)
   {
   //case SDL_VIDEORESIZE:
      //
      // resized the window
      //
      //VIDEO_Resize(lpEvent->resize.w, lpEvent->resize.h);
      //break;

   case SDL_QUIT:
      //
      // clicked on the close button of the window. Quit immediately.
      //
      JY_Shutdown();
      exit(0);
   }

   JY_KeyboardEventFilter(lpEvent);
   //PAL_JoystickEventFilter(lpEvent);

   return 0;
}

VOID JY_InitInput(VOID)
{
	if (gpGlobals == NULL)
		return;

	char buf[256] = {0};
	char cFile[256] = {0};
	BOOL bRtn = FALSE;
	FILE *fp = NULL;

	g_InputState.dir = kDirUnknown;
	g_InputState.prevdir = kDirUnknown;
	g_InputState.dwKeyPress = 0;
	SDL_SetEventFilter(JY_EventFilter, NULL);
	gpGlobals->curDefKey.bVkey = FALSE;
	gpGlobals->curDefKey.uK_a = 0;
	gpGlobals->curDefKey.uK_down = 0;
	gpGlobals->curDefKey.uK_e = 0;
	gpGlobals->curDefKey.uK_esc = 0;
	gpGlobals->curDefKey.uK_left = 0;
	gpGlobals->curDefKey.uK_ok = 0;
	gpGlobals->curDefKey.uK_r = 0;
	gpGlobals->curDefKey.uK_right = 0;
	gpGlobals->curDefKey.uK_up = 0;
	gpGlobals->curDefKey.uK_w = 0;

   //LPSTR cFile = NULL;
	//cFile = va("%s/settings.txt", appPath);

	sprintf(cFile,"%s/settings.txt",JY_PREFIX);
	fp = fopen(cFile,"rb");

	bRtn = GetIniField(fp, "KEYS", "up", "0", buf);
   if (bRtn)
	   gpGlobals->curDefKey.uK_up = atoi(buf);
   bRtn = GetIniField(fp, "KEYS", "down", "0", buf);
   if (bRtn)
	   gpGlobals->curDefKey.uK_down = atoi(buf);
	bRtn = GetIniField(fp, "KEYS", "left", "0", buf);
   if (bRtn)
	   gpGlobals->curDefKey.uK_left = atoi(buf);
	bRtn = GetIniField(fp, "KEYS", "right", "0", buf);
   if (bRtn)
	   gpGlobals->curDefKey.uK_right = atoi(buf);
	bRtn = GetIniField(fp, "KEYS", "ok", "0", buf);
   if (bRtn)
	   gpGlobals->curDefKey.uK_ok = atoi(buf);
	bRtn = GetIniField(fp, "KEYS", "esc", "0", buf);
   if (bRtn)
	   gpGlobals->curDefKey.uK_esc = atoi(buf);
	bRtn = GetIniField(fp, "KEYS", "useitem", "0", buf);
   if (bRtn)
	   gpGlobals->curDefKey.uK_e = atoi(buf);
	bRtn = GetIniField(fp, "KEYS", "setupitem", "0", buf);
   if (bRtn)
	   gpGlobals->curDefKey.uK_w = atoi(buf);
	bRtn = GetIniField(fp, "KEYS", "repeatact", "0", buf);
   if (bRtn)
	   gpGlobals->curDefKey.uK_r = atoi(buf);
	bRtn = GetIniField(fp, "KEYS", "autoact", "0", buf);
   if (bRtn)
	   gpGlobals->curDefKey.uK_a = atoi(buf);
	bRtn = GetIniField(fp, "KEYS", "enablevkey", "0", buf);
   if (bRtn)
	   gpGlobals->curDefKey.bVkey = atoi(buf);
	UTIL_CloseFile(fp);
	//SafeFree(cFile);
   if (gpGlobals->curDefKey.bVkey)
   {
	   int w = 0,h = 0;
	   float fsw = 0.0,fsh = 0.0;
	   //cFile = va("%s/vkeys.txt", appPath);
		sprintf(cFile,"%s/vkeys.txt",JY_PREFIX);

		fp = fopen(cFile,"rb");

		bRtn = GetIniField(fp, "VKEYS", "width", "1", buf);
	   if (bRtn)
		  w = atoi(buf);
	   bRtn = GetIniField(fp, "VKEYS", "height", "1", buf);
	   if (bRtn)
		  h = atoi(buf);

	   fsw = g_wInitialWidth/(float)w;
	   fsh = g_wInitialHeight/(float)h;

	   bRtn = GetIniField(fp, "VKEYS", "vkup", "0", buf);
	   if (bRtn)
		    Fillvk(vkpos, buf, SDLK_UP, fsw, fsh);
		bRtn = GetIniField(fp, "VKEYS", "vkdown", "0", buf);
	   if (bRtn)
		    Fillvk(vkpos+1, buf, SDLK_DOWN, fsw, fsh);
		bRtn = GetIniField(fp, "VKEYS", "vkleft", "0", buf);
	   if (bRtn)
		   Fillvk(vkpos+2, buf, SDLK_LEFT, fsw, fsh);
		bRtn = GetIniField(fp, "VKEYS", "vkright", "0", buf);
	   if (bRtn)
		   Fillvk(vkpos+3, buf, SDLK_RIGHT, fsw, fsh);
		bRtn = GetIniField(fp, "VKEYS", "vkok", "0", buf);
	   if (bRtn)
		    Fillvk(vkpos+4, buf, SDLK_SPACE, fsw, fsh);
		bRtn = GetIniField(fp, "VKEYS", "vkesc", "0", buf);
	   if (bRtn)
		    Fillvk(vkpos+5, buf, SDLK_ESCAPE, fsw, fsh);
		bRtn = GetIniField(fp, "VKEYS", "vkrepeatact", "0", buf);
	   if (bRtn)
		    Fillvk(vkpos+6, buf, SDLK_r, fsw, fsh);
		bRtn = GetIniField(fp, "VKEYS", "vkautoact", "0", buf);
	   if (bRtn)
		    Fillvk(vkpos+7, buf, SDLK_a, fsw, fsh);
		bRtn = GetIniField(fp, "VKEYS", "vkwearitem", "0", buf);
	   if (bRtn)
		   Fillvk(vkpos+8, buf, SDLK_w, fsw, fsh);

	   bRtn = GetIniField(fp, "VKEYS", "vkuseitem", "0", buf);
	   if (bRtn)
		    Fillvk(vkpos+9, buf, SDLK_e, fsw, fsh);
		//SafeFree(cFile);

	  UTIL_CloseFile(fp);
   }

}

VOID JY_ShutdownInput(VOID)
{
}

VOID JY_ProcessEvent(VOID)
{
   while (SDL_PollEvent(NULL));
}
