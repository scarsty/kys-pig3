
#include "Main.h"

SDL_Surface			*gpScreen           = NULL;
static SDL_Surface	*gpScreenReal       = NULL;
SDL_Surface		    *gpScreenFilp		 = NULL;
SDL_Surface         *gpScreenBak1        = NULL;
SDL_Surface         *gpScreenBak2        = NULL;
static SDL_Surface         *gpScreenMask        = NULL;
SDL_Color	g_colors[256];
Uint32	g_colors32[256];
WORD				g_wInitialWidth		= 0;
WORD				g_wInitialHeight	= 0;
WORD				g_wSclWidth	= 0;
WORD				g_wSclHeight= 0;
float				g_fSclW = 1;
float				g_fSclH = 1;
BOOL				g_bShowVkey	= 0;
//static ushort ExpList[31] = {0,50,    150,     300 ,500   , 750 ,
//               1050,  1400,   1800 ,2250  , 2750 ,
//               3850,  5050,   6350 ,7750  , 9250 ,
//               10850, 12550, 14350 ,16750 , 18250 ,
//               21400, 24700, 28150 ,31750 , 35500 ,
//	           39400, 43450, 47650 ,52000 , 60000  };

//初始化视频
INT JY_VideoInit(WORD wScreenWidth,WORD wScreenHeight,BOOL fFullScreen)
{
	float fw = 0.0;
	float fh = 0.0;
	float fscl = 0.0;

	g_wInitialWidth = wScreenWidth;
	g_wInitialHeight = wScreenHeight;

	g_wSclWidth = g_wInitialWidth;
	g_wSclHeight = g_wInitialHeight;
	g_fSclW = g_wInitialWidth / 320.f;
	g_fSclH = g_wInitialHeight / 240.f;

	//gpScreenReal = SDL_SetVideoMode(wScreenWidth, wScreenHeight, 8,
	//	SDL_HWSURFACE | SDL_RESIZABLE | (fFullScreen ? SDL_FULLSCREEN : 0));

	if (gpScreenReal == NULL)
	{
		return -1;
	}

	gpScreen = SDL_CreateRGBSurface(gpScreenReal->flags & ~SDL_HWSURFACE, wScreenWidth, wScreenHeight, 8,
		gpScreenReal->format->Rmask, gpScreenReal->format->Gmask,
		gpScreenReal->format->Bmask, gpScreenReal->format->Amask);

	if (gpScreen == NULL )
	{
		SafeFreeSdlSurface(gpScreen);
		SafeFreeSdlSurface(gpScreenReal);
		return -2;
	}
	gpScreenFilp = SDL_CreateRGBSurface(gpScreenReal->flags & ~SDL_HWSURFACE, wScreenWidth, wScreenHeight, 8,
		gpScreenReal->format->Rmask, gpScreenReal->format->Gmask,
		gpScreenReal->format->Bmask, gpScreenReal->format->Amask);
	if (gpScreenFilp == NULL )
	{
		SafeFreeSdlSurface(gpScreenFilp);
		SafeFreeSdlSurface(gpScreen);
		SafeFreeSdlSurface(gpScreenReal);
		return -2;
	}
	gpScreenBak1 = SDL_CreateRGBSurface(gpScreenReal->flags & ~SDL_HWSURFACE, wScreenWidth, wScreenHeight, 8,
		gpScreenReal->format->Rmask, gpScreenReal->format->Gmask,
		gpScreenReal->format->Bmask, gpScreenReal->format->Amask);
	if (gpScreenBak1 == NULL )
	{
		SafeFreeSdlSurface(gpScreenBak1);
		SafeFreeSdlSurface(gpScreenFilp);
		SafeFreeSdlSurface(gpScreen);
		SafeFreeSdlSurface(gpScreenReal);
		return -2;
	}
	gpScreenBak2 = SDL_CreateRGBSurface(gpScreenReal->flags & ~SDL_HWSURFACE, wScreenWidth, wScreenHeight, 8,
		gpScreenReal->format->Rmask, gpScreenReal->format->Gmask,
		gpScreenReal->format->Bmask, gpScreenReal->format->Amask);

	if (gpScreenBak1 == NULL )
	{
		SafeFreeSdlSurface(gpScreenBak2);
		SafeFreeSdlSurface(gpScreenBak1);
		SafeFreeSdlSurface(gpScreenFilp);
		SafeFreeSdlSurface(gpScreen);
		SafeFreeSdlSurface(gpScreenReal);
		return -2;
	}

	gpScreenMask = SDL_CreateRGBSurface(gpScreenReal->flags & ~SDL_HWSURFACE, 36*g_iZoom, 18*g_iZoom, 32,
		gpScreenReal->format->Rmask, gpScreenReal->format->Gmask,
		gpScreenReal->format->Bmask, gpScreenReal->format->Amask);

	if (gpScreenMask == NULL )
	{
		SafeFreeSdlSurface(gpScreenBak2);
		SafeFreeSdlSurface(gpScreenBak1);
		SafeFreeSdlSurface(gpScreenFilp);
		SafeFreeSdlSurface(gpScreen);
		SafeFreeSdlSurface(gpScreenReal);
		return -2;
	}

	JY_VideoInitPaltte();

	SDL_SetColorKey(gpScreen,SDL_SRCCOLORKEY,TRANSCOLOR);
	SDL_SetColorKey(gpScreenReal,SDL_SRCCOLORKEY,TRANSCOLOR);
	SDL_SetColorKey(gpScreenFilp,SDL_SRCCOLORKEY,TRANSCOLOR);
	SDL_SetColorKey(gpScreenBak1,SDL_SRCCOLORKEY,TRANSCOLOR);
	SDL_SetColorKey(gpScreenBak2,SDL_SRCCOLORKEY,TRANSCOLOR);
	SDL_SetColorKey(gpScreenMask,SDL_SRCCOLORKEY,TRANSCOLOR);

	return 0;
}


//初始化调色板
INT JY_VideoInitPaltte(VOID)
{
	LPBYTE buf = NULL;
	int iRtn = -1;
	buf = (LPBYTE)malloc(256 * 3);
	if (buf == NULL)
	{
		return iRtn;
	}
	char cFile[256] = {0};
	sprintf(cFile,"%s\\Resource\\data\\Mmap.col",JY_PREFIX);
	FILE *fp = fopen(cFile,"rb");//UTIL_OpenRequiredFile("\\Resource\\data\\Mmap.col");
	if (fp == NULL)
	{
		SafeFree(buf);
		return iRtn;
	}
	JY_FILEReadData(buf,fp);
	UTIL_CloseFile(fp);
	
	int iTemp = 0;
	for(int i=0;i<256;i++)
	{
		g_colors[i].r= buf[iTemp++] * 4;
		g_colors[i].g= buf[iTemp++] * 4;
		g_colors[i].b= buf[iTemp++] * 4;
		//g_colors32[i] = g_colors[i].r * 65536l + g_colors[i].g * 256 + g_colors[i].b ; 
	}
	SafeFree(buf);
	iRtn = SDL_SetPalette(gpScreenReal, SDL_LOGPAL|SDL_PHYSPAL, g_colors, 0, 256);
	iRtn = SDL_SetPalette(gpScreen, SDL_LOGPAL|SDL_PHYSPAL, g_colors, 0, 256);	
	iRtn = SDL_SetPalette(gpScreenFilp, SDL_LOGPAL|SDL_PHYSPAL, g_colors, 0, 256);	
	iRtn = SDL_SetPalette(gpScreenBak1, SDL_LOGPAL|SDL_PHYSPAL, g_colors, 0, 256);	
	iRtn = SDL_SetPalette(gpScreenBak2, SDL_LOGPAL|SDL_PHYSPAL, g_colors, 0, 256);	
	iRtn = SDL_SetPalette(gpScreenMask, SDL_LOGPAL|SDL_PHYSPAL, g_colors, 0, 256);	
	
	return 0;
}
//卸载视频
VOID JY_VideoShutdown(VOID)
{
	SafeFreeSdlSurface(gpScreenFilp);
	SafeFreeSdlSurface(gpScreen);	
	SafeFreeSdlSurface(gpScreenBak1);
	SafeFreeSdlSurface(gpScreenBak2);
	SafeFreeSdlSurface(gpScreenMask);
	SafeFreeSdlSurface(gpScreenReal);
}

//备份当前页面
VOID JY_VideoBackupScreen(short iNum)
{
	if (iNum == 1)
		SDL_BlitSurface(gpScreen, NULL, gpScreenBak1, NULL);
	else
		SDL_BlitSurface(gpScreen, NULL, gpScreenBak2, NULL);
}
//恢复页面
VOID JY_VideoRestoreScreen(short iNum)
{
	if (iNum == 1)
		SDL_BlitSurface(gpScreenBak1, NULL, gpScreen, NULL);
	else
		SDL_BlitSurface(gpScreenBak2, NULL, gpScreen, NULL);
}
// 图形填充
// 如果x1,y1,x2,y2均为0，则填充整个表面
// color, 填充色，用RGB表示，从高到低字节为0RGB
INT JY_FillColor(INT x1,INT y1,INT x2,INT y2,Uint32 color)
{
    SDL_Rect rect;
   
	if(x1==0 || y1==0 || x2==0 || y2==0){
        SDL_FillRect(gpScreen,NULL,color);
	}
	else{
		rect.x=x1;
		rect.y=y1;
		rect.w=x2-x1+1;
		rect.h=y2-y1+1;
		SDL_FillRect(gpScreen,&rect,color);
	}
	return 0;
}
//显示表面
INT JY_ShowSurface(VOID)
{
	
	if (g_bShowVkey)
	{
		void* p = gpScreen->pixels;
		JY_DrawVKeys(p);
		p = NULL;
	}

	if (g_iDebug == 1)
		JY_DrawMemUse();

	if (g_iOldRoat != 0)
	{
		JY_BlitSurfaceRoat();
	}
	else
	{
		SDL_BlitSurface(gpScreen,NULL,gpScreenReal,NULL);
	}

	//SDL_Flip(gpScreenReal);
	return 0;
}

//延时x毫秒
INT JY_Delay(INT x)
{
    SDL_Delay(x);
    return 0;
}

//得到当前时间，单位毫秒
INT JY_GetTime(VOID)
{
    return SDL_GetTicks();
}

// 缓慢显示图形 
// delaytime 每次渐变延时毫秒数
// Flag=0 从暗到亮，1，从亮到暗
INT JY_ShowSlow(INT delaytime,INT Flag)
{
    INT i = 0;
	INT j = 0;
	INT step = 0;
	INT t1 = 0;
	INT t2 = 0;
	INT alpha = 0;

	SDL_BlitSurface(gpScreen ,NULL,gpScreenBak1,NULL);    //当前表面复制到临时表面
	SDL_Color newpalette[256];

	if (Flag == 0)
	{
		for(i=0;i<=32/g_iZoom;i++)
		{
			//t1=JY_GetTime();
		
			SDL_FillRect(gpScreen,NULL,0);          //当前表面变黑

			for (j = 0; j < 256; j++)
			{
				newpalette[j].r = (g_colors[j].r * i * 2 * g_iZoom) >> 6;
				newpalette[j].g = (g_colors[j].g * i * 2 * g_iZoom) >> 6;
				newpalette[j].b = (g_colors[j].b * i * 2 * g_iZoom) >> 6;
			}
			SDL_SetPalette(gpScreenBak1, SDL_LOGPAL|SDL_PHYSPAL, newpalette, 0, 256);
			SDL_BlitSurface(gpScreenBak1 ,NULL,gpScreen,NULL); 
			JY_ShowSurface();
			JY_Delay(1);
			//t2=JY_GetTime();
			//if(delaytime > t2-t1)
			//	JY_Delay(delaytime-(t2-t1)/3);
		}
		
	}
	else
	{
		for(i = 31/g_iZoom; i >= 3; i--)
		{
			//t1=JY_GetTime();
		
			SDL_FillRect(gpScreen,NULL,0);          //当前表面变黑

			for (j = 0; j < 256; j++)
			{
				newpalette[j].r = (g_colors[j].r * i * 2 * g_iZoom) >> 6;
				newpalette[j].g = (g_colors[j].g * i * 2 * g_iZoom) >> 6;
				newpalette[j].b = (g_colors[j].b * i * 2 * g_iZoom) >> 6;
			}
			SDL_SetPalette(gpScreenBak1, SDL_LOGPAL|SDL_PHYSPAL, newpalette, 0, 256);
			SDL_BlitSurface(gpScreenBak1 ,NULL,gpScreen,NULL); 
			JY_ShowSurface();
			JY_Delay(1);
			//t2=JY_GetTime();
			//if(delaytime > t2-t1)
			//	JY_Delay(delaytime-(t2-t1)/3);
		}


	}
	SDL_SetPalette(gpScreenBak1, SDL_LOGPAL|SDL_PHYSPAL, g_colors, 0, 256);

	return 0;
}

//显示游戏头
VOID JY_DrawTitleScreen(VOID)
{
	LPBYTE buf = NULL;
	int iRtn = -1;
	buf = (LPBYTE)malloc(320 * 200);
	if (buf == NULL)
	{
		return;
	}
	char cFile[256] = {0};
	sprintf(cFile,"%s\\Resource\\data\\Title.BIG",JY_PREFIX);
	FILE *fp = fopen(cFile,"rb");//UTIL_OpenRequiredFile("\\Resource\\data\\Title.BIG");
	if (fp == NULL)
	{
		SafeFree(buf);
		return;
	}
	JY_FILEReadData(buf,fp);
	UTIL_CloseFile(fp);

	if (g_iZoom == 1)
	{
		LPBYTE p = NULL;
		SDL_LockSurface(gpScreen);
		INT y = g_wInitialHeight/2 - 240/2;//g_wInitialWidth/320
		INT x = g_wInitialWidth/2 - 320/2;//g_wInitialHeight
		y = y<0 ? 0 :y;
		y = y>g_wInitialHeight ? 0 :y;
		x = x<0 ? 0 :x;
		x = x>g_wInitialWidth ? 0 :x;
		INT i=0;
		INT j=0;
		INT iNum = 0;
		for (j=y; j < y+200; j++)
		{
			p = (LPBYTE)(gpScreen->pixels) + j * gpScreen->pitch +x;
			for (i=x; i < x+320; i++)
			{
				*(p++) = buf[iNum++];//*(buf++);//
			}
		}
		SafeFree(buf);
		SDL_UnlockSurface(gpScreen);
	}
	else
	{
		LPBYTE p = NULL;
		SDL_LockSurface(gpScreen);
		INT y = 0;
		INT x = 0;
		INT i=0;
		INT j=0;
		INT iNum = 0;
		for (j=y; j < y+200*g_iZoom; j++)
		{
			p = (LPBYTE)(gpScreen->pixels) + j * gpScreen->pitch +x;
			for (i=x; i < x+320*g_iZoom; i++)
			{
				iNum = j/g_iZoom * 320 +i/g_iZoom;
				*(p++) = buf[iNum];
			}
		}
		SafeFree(buf);
		SDL_UnlockSurface(gpScreen);
	}

}

// 写字符串
// x,y 坐标
// str 字符串
// color 颜色
// charset 字符集 0 GBK 1 big5
INT JY_DrawStr(INT x, INT y, const char *str,INT color,INT charset,BOOL bBox,BOOL bOffset)
{
    SDL_Color c;   
	SDL_Color cBk;  
	SDL_Surface *fontSurface=NULL;
	SDL_Surface *fontSurfaceBk=NULL;
	SDL_Rect rect;
	char *tmp=NULL;
	int flag=0;
	int ilen = 0;
	int iw = 0;
	int ih = 0;
	ilen= 2*strlen(str)+2;
	SDL_GetRGB(color,gpScreen->format,&c.r,&c.g,&c.b);
	SDL_GetRGB(0,gpScreen->format,&cBk.r,&cBk.g,&cBk.b);
    tmp=(char *)malloc(ilen);  //分配两倍原字符串大小的内存，避免转换到unicode时溢出
	
	if (tmp == NULL)
		TerminateOnError("JY_DrawStr:分配内存失败 tmp");
	for(int i=0;i<ilen;i++)
		tmp[i]=0;
	if(charset==0){     //GBK
		JY_CharSet(str,tmp,3);      
	}
	else if(charset==1){ //big5
		JY_CharSet(str,tmp,2);
	}
	else{
		strcpy(tmp,str);
	}
	

    fontSurface=TTF_RenderUNICODE_Blended(gpFont,(Uint16*)tmp , c);  //生成表面(Uint16*)tmp
	if(fontSurface==NULL)
	{
		SafeFreeSdlSurface(fontSurface);   //释放表面
		SafeFreeSdlSurface(fontSurfaceBk);   //释放表面
		return 1;
	}
	SDL_SetColorKey(fontSurface,SDL_SRCCOLORKEY,TRANSCOLOR);
	SDL_SetPalette(fontSurface, SDL_LOGPAL|SDL_PHYSPAL, g_colors, 0, 256);

	fontSurfaceBk = TTF_RenderUNICODE_Blended(gpFont, (Uint16*)tmp, cBk);  //生成表面
	if(fontSurfaceBk==NULL)
	{
		SafeFreeSdlSurface(fontSurface);   //释放表面
		SafeFreeSdlSurface(fontSurfaceBk);   //释放表面
		return 1;
	}
	SDL_SetColorKey(fontSurfaceBk,SDL_SRCCOLORKEY,TRANSCOLOR);
	SDL_SetPalette(fontSurfaceBk, SDL_LOGPAL|SDL_PHYSPAL, g_colors, 0, 256);
	SafeFree(tmp);
	iw = fontSurface->w;
	ih = fontSurface->h;
	if (bBox)
	{
		if (bOffset)
		{
			JY_DrawBox(x-3-fontSurface->w/2,y-3-fontSurface->h/2,x+fontSurface->w/2+3,y+fontSurface->h/2+3,0);
		}
		else
		{
			JY_DrawBox(x-3,y-3,x+fontSurface->w+3,y+fontSurface->h+3,0);
		}
	}

	if (bOffset)
	{
		rect.x=x+1-fontSurface->w/2;
		rect.y=y+1-fontSurface->h/2;
	}
	else
	{
		rect.x=x+1;
		rect.y=y+1;
	}
	SDL_BlitSurface(fontSurfaceBk, NULL, gpScreen, &rect);    //表面写道游戏表面 
	if (bOffset)
	{
		rect.x=x-fontSurface->w/2;
		rect.y=y-fontSurface->h/2;
	}
	else
	{
		rect.x=x;
		rect.y=y;
	}
    SDL_BlitSurface(fontSurface, NULL, gpScreen, &rect);    //表面写道游戏表面 
    SafeFreeSdlSurface(fontSurface);   //释放表面
	SafeFreeSdlSurface(fontSurfaceBk);   //释放表面
    return JY_XY(iw,ih);
}

//通用菜单
short JY_ShowMenu(LPMENUITEM rgMenuItem,LPITEMCHANGED_CALLBACK lpfnMenuItemChanged,INT nMenuItem,short wDefaultItem,BOOL bBox,BOOL bEsc,Uint32 color,Uint32 colorSelect)
{
	int               i = 0;
	short              wCurrentItem    = (wDefaultItem < nMenuItem ) ? wDefaultItem : 0;
	
	JY_DrawMenu(rgMenuItem,nMenuItem,wCurrentItem,bBox,color,colorSelect);
	while (TRUE)
	{
		JY_ClearKeyState();
		JY_ProcessEvent();
		if (g_InputState.dwKeyPress & (kKeyDown | kKeyRight))//if (g_InputState.dir == kDirSouth || g_InputState.dir == kDirEast)
		{
			wCurrentItem++;
			if (wCurrentItem >= nMenuItem)
				wCurrentItem = 0;
			JY_VideoRestoreScreen(1);
			JY_DrawMenu(rgMenuItem,nMenuItem,wCurrentItem,bBox,color,colorSelect);
		}
		else if (g_InputState.dwKeyPress & (kKeyUp | kKeyLeft))//else if (g_InputState.dir == kDirNorth || g_InputState.dir == kDirWest)
		{
			wCurrentItem--;
			if (wCurrentItem < 0)
				wCurrentItem = nMenuItem -1;	
			JY_VideoRestoreScreen(1);
			JY_DrawMenu(rgMenuItem,nMenuItem,wCurrentItem,bBox,color,colorSelect);
		}
		//if (g_InputState.dwKeyPress & (kKeyDown | kKeyRight))
		//{
		//	wCurrentItem++;
		//	if (wCurrentItem >= nMenuItem)
		//		wCurrentItem = 0;
		//	JY_DrawMenu(rgMenuItem,nMenuItem,wCurrentItem,bBox,color,colorSelect);
		//}
		//else if (g_InputState.dwKeyPress & (kKeyUp | kKeyLeft))
		//{
		//	wCurrentItem--;
		//	if (wCurrentItem < 0)
		//		wCurrentItem = nMenuItem -1;			
		//	JY_DrawMenu(rgMenuItem,nMenuItem,wCurrentItem,bBox,color,colorSelect);
		//}
		else if (g_InputState.dwKeyPress & kKeySearch)
		{
			if (rgMenuItem[wCurrentItem].fEnabled == TRUE)
			{
				if (rgMenuItem[wCurrentItem].fEnabled)
				{
					return rgMenuItem[wCurrentItem].wValue;
				}
			}
		}
		else if (g_InputState.dwKeyPress & kKeyMenu)
		{
			if (bEsc)
			{
				return MENUITEM_VALUE_CANCELLED;
			}
		}
		SDL_Delay(50);
	}

	return MENUITEM_VALUE_CANCELLED;
}
//绘通用菜单
INT JY_DrawMenu(LPMENUITEM rgMenuItem,INT nMenuItem,short wDefaultItem,BOOL bBox,Uint32 color,Uint32 colorSelect)
{
	//JY_ReDrawMap();

	INT x1 = 0;
	INT y1 = 0;
	INT i = 0;
	if (bBox)
	{
		int iw = 0;
		for(i=0;i<nMenuItem;i++)
		{
			if (strlen(rgMenuItem[i].pText) > iw)
				iw = strlen(rgMenuItem[i].pText);
		}
		JY_DrawBox(JY_X(rgMenuItem[0].pos) - 3,
			JY_Y(rgMenuItem[0].pos) - 3,
			JY_X(rgMenuItem[nMenuItem-1].pos) + iw * (g_iFontSize/2+1),
			JY_Y(rgMenuItem[nMenuItem-1].pos) + (g_iFontSize+4) + 3,colorSelect);
	}

	for(i=0;i<nMenuItem;i++)
	{
		x1 = JY_X(rgMenuItem[i].pos);
		y1 = JY_Y(rgMenuItem[i].pos);
		if (wDefaultItem == i)
		{
			JY_DrawStr(x1,y1,rgMenuItem[i].pText,colorSelect,0,FALSE,FALSE);
		}
		else
		{
			if (rgMenuItem[i].fEnabled == TRUE)
				JY_DrawStr(x1,y1,rgMenuItem[i].pText,color,0,FALSE,FALSE);
			else
				JY_DrawStr(x1,y1,rgMenuItem[i].pText,110,0,FALSE,FALSE);
		}
	}
	JY_ShowSurface();
	return 0;
}

//把表面blt到前景表面
INT BlitSurface(SDL_Surface* lps, INT x, INT y ,INT flag,INT value)
{
	if (lps == NULL)
		return 0;

	SDL_Surface *tmps = NULL;
	SDL_Rect r;
	INT i,j;

    Uint32 color=TRANSCOLOR;

	if(value>255)
		value=255;

	r.x=x;
	r.y=y;
	r.w = lps->w;
	r.h = lps->h;
	if((flag & 0x2)==0)
	{        // 没有alpla
        SDL_BlitSurface(lps,NULL,gpScreen,&r);
	}
    else
	{  
		SDL_FillRect(gpScreenMask,NULL,color);
		SDL_BlitSurface(lps,NULL,gpScreenMask,NULL);
		SDL_SetAlpha(gpScreenMask,SDL_SRCALPHA,(Uint8)value);
		SDL_BlitSurface(gpScreenMask,NULL,gpScreen,&r);

		//if( flag &0x4)
		//{
		//	int bpp=lps->format->BitsPerPixel;
		//	tmps=SDL_CreateRGBSurface(SDL_SWSURFACE,lps->w,lps->h,32,
		//		lps->format->Rmask,lps->format->Gmask,lps->format->Bmask,0);
		//	SDL_FillRect(tmps,NULL,color);
		//	SDL_SetColorKey(tmps,SDL_SRCCOLORKEY ,color);			
		//	SDL_BlitSurface(lps,NULL,tmps,NULL);
		//	SDL_SetAlpha(tmps,SDL_SRCALPHA,(Uint8)value);
		//	SDL_BlitSurface(tmps,NULL,gpScreen,&r);
		//	SDL_FreeSurface(tmps);
		//}
		//else if (flag &0x8)
		//{
		//	int bpp=lps->format->BitsPerPixel;
		//	tmps=SDL_CreateRGBSurface(SDL_SWSURFACE,lps->w,lps->h,32,
		//		lps->format->Rmask,lps->format->Gmask,lps->format->Bmask,0);
		//	SDL_FillRect(tmps,NULL,color);
		//	SDL_SetColorKey(tmps,SDL_SRCCOLORKEY ,color);			
		//	SDL_BlitSurface(lps,NULL,tmps,NULL);
		//	SDL_SetAlpha(tmps,SDL_SRCALPHA,(Uint8)value);
		//	SDL_BlitSurface(tmps,NULL,gpScreen,&r);
		//	SDL_FreeSurface(tmps);
		//}
		//else
		//{
		//	SDL_SetAlpha(lps,SDL_SRCALPHA,(Uint8)value);
		//	SDL_BlitSurface(lps,NULL,gpScreen,&r);
		//}
	}
	
	return 0;
}


//把表面某一块blt到前景表面
INT BlitSurface0(SDL_Surface* lps, INT x, INT y ,INT w,INT h)
{
	SDL_Rect r;

	r.x=x;
	r.y=y;
	r.w = w;
	r.h = h;

	SDL_BlitSurface(lps,&r,gpScreen,&r);
	return 0;
}
//绘点
VOID JY_PutPixel(SDL_Surface *surface, INT x, INT y, Uint32 pixel)
{
	if (surface == NULL)
		return;
	if (x < 0 || x> surface->w || y < 0 || y> surface->h)
		return;
	int bpp = surface->format->BytesPerPixel;
	
	Uint8 *p = (Uint8 *)surface->pixels + y * surface->pitch + x * bpp;

	switch(bpp) {
	case 1:
		*p = pixel;
		break;
	case 2:
		*(Uint16 *)p = pixel;
		break;
	case 3:
		if(SDL_BYTEORDER == SDL_BIG_ENDIAN) {
			p[0] = (pixel >> 16) & 0xff;
			p[1] = (pixel >> 8) & 0xff;
			p[2] = pixel & 0xff;
		} else {
			p[0] = pixel & 0xff;
			p[1] = (pixel >> 8) & 0xff;
			p[2] = (pixel >> 16) & 0xff;
		}
		break;

	case 4:
		*(Uint32 *)p = pixel;
		break;
	}
}


//绘矩形框
VOID JY_DrawBox(INT x1,INT y1,INT x2,INT y2,Uint32 color)
{
	//防止越界
	x1 = limitX(x1,1,g_wInitialWidth-1);
	y1 = limitX(y1,1,g_wInitialHeight-1);
	x2 = limitX(x2,1,g_wInitialWidth-1);
	y2 = limitX(y2,1,g_wInitialHeight-1);

	void* p = gpScreen->pixels;
	SDL_LockSurface(gpScreen);
	DrawRect((BYTE*)p,x1+1,x2+1,y1+1,y2+1,0);
	DrawRect((BYTE*)p,x1,x2,y1,y2,255);
	SDL_UnlockSurface(gpScreen);
	JY_Background(x1+2,y1+2,x2-1,y2-1,192);
	//INT s = 4;

	//JY_Background(x1,y1,x2+1,y2+1,128);
	//JY_Background(x1+s,y1,x2-s,y2,128);
	//JY_Background(x2-s,y1+s,x2,y2-s,128);
	//JY_DrawBox_1(x1+1,y1+1,x2,y2,0);
 //   JY_DrawBox_1(x1,y1,x2-1,y2-1,color);
}
// 背景变暗
// 把源表面(x1,y1,x2,y2)矩形内的所有点亮度降低
// bright 亮度等级 0-256 
int JY_Background(int x1,int y1,int x2,int y2,int Bright)
{
    SDL_Surface* lps1; 
    SDL_Rect r; 

	if(x2<=x1 || y2<=y1) 
		return 0;

    Bright=256-Bright;
	if(Bright>255)
		Bright=255;

	lps1=SDL_CreateRGBSurface(SDL_SWSURFACE,x2-x1,y2-y1,16,
		                      gpScreenReal->format->Rmask,gpScreenReal->format->Gmask,gpScreenReal->format->Bmask,0);


 
    SDL_FillRect(lps1,NULL,0);

    int ii = SDL_SetAlpha(lps1,SDL_SRCALPHA,(Uint8)Bright);

    r.x=x1;
	r.y=y1;

	SDL_BlitSurface(lps1,NULL,gpScreen,&r); 

	SDL_FreeSurface(lps1);
	return 1;
}
//绘对话背景
VOID JY_DrawTalkDialogBak(short iHeadImgNum, short iFlag)
{
	int x1 = 0;
	int x2 = 0;
	int y1 = 0;
	int y2 = 0;
	BYTE color;
	color = 255;

	if (iFlag == 1 || iFlag == 3 || iFlag == 5)
	{
		x1 = 5;
		x2 = g_wInitialWidth - 90 * g_iZoom;
		y1 = g_wInitialHeight - (g_iFontSize + 4)*4 -5;//g_wInitialHeight/2+30;
		y2 = g_wInitialHeight - 5;//g_wInitialHeight/2+ (g_iFontSize + 4) * 5 + 10;//110;		
		JY_DrawBox(x1,y1,x2,y2,0);

		x1 = g_wInitialWidth - 85  * g_iZoom;
		x2 = g_wInitialWidth - 5;
		y1 = g_wInitialHeight - (g_iFontSize + 4)*4 -5;//g_wInitialHeight/2+30;
		y2 = g_wInitialHeight - 5;//g_wInitialHeight/2+ (g_iFontSize + 4) * 5 + 10;//110;		
		JY_DrawBox(x1,y1,x2,y2,0);

		if (iHeadImgNum >= 0)
		{
			JY_LoadPic(2,iHeadImgNum * 2,x1 + 10,y1+2,1,0);
		}
	}
	if (iFlag == 0 || iFlag == 2 || iFlag == 4)
	{
		x1 = 5;
		x2 = g_wInitialWidth - 90 * g_iZoom;
		y1 = 5;
		y2 = (g_iFontSize + 4) * 4 + 5;//75;		
		JY_DrawBox(x1,y1,x2,y2,0);

		x1 = g_wInitialWidth - 85 * g_iZoom;
		x2 = g_wInitialWidth - 5;
		y1 = 5;
		y2 = (g_iFontSize + 4) * 4 + 5;//75;		
		JY_DrawBox(x1,y1,x2,y2,0);

		if (iHeadImgNum >= 0)
		{
			JY_LoadPic(2,iHeadImgNum * 2,x1 + 10,y1+2,1,0);
		}
	}
	if (iHeadImgNum == 114)
	{
		LPSTR pChar = NULL;
		pChar = va("%d",gpGlobals->g.pPersonList[0].ZiZhi);
		JY_DrawStr(x1+18,y1+40,pChar,HONGCOLOR,0,FALSE,FALSE);
		SafeFree(pChar);
	}
	else
	{
		int i=0;
		int iCur = -1;
		for(i=0;i<gpGlobals->g.iPersonCount;i++)
		{
			if (iHeadImgNum == gpGlobals->g.pPersonList[i].PhotoId)
			{
				iCur=i;
				break;
			}
		}
		if (iCur >= 0)
		{
			BYTE pTemp[30] = {0};
			INT iLen = 0;
			for(int k=0;k< 10;k++)
			{
				if (gpGlobals->g.pPersonList[iCur].name1big5[k] == 0)
				{
					pTemp[k] =0;
					break;
				}
				pTemp[k] =gpGlobals->g.pPersonList[iCur].name1big5[k] ;//^ 0xFF;
				iLen++;
			}
			Big5toUnicode(pTemp,iLen);
			JY_DrawStr(x1+10,y1+60 * g_iZoom,(char*)pTemp,HUANGCOLOR,0,FALSE,FALSE);
		}
	}
}

//绘物品栏背景
VOID JY_ThingDilagBack(short iFlag)
{
	//JY_ReDrawMap();

	int x1 = 0;
	int x2 = 0;
	int y1 = 0;
	int y2 = 0;
	
	if (iFlag == 0)
	{
		x1 = 5;
		x2 = (g_iFontSize+4)*3;
		y1 = 5;
		y2 = g_wInitialHeight - 5;		
		JY_DrawBox(x1,y1,x2,y2,0);

		if (g_iThingPicList == 0)
		{
			x1 = (g_iFontSize+4)*3+5;
			x2 = (g_iFontSize+4)*3+5 + 50;
			y1 = 5;
			y2 = (g_iFontSize+4)*2+15;		
			JY_DrawBox(x1,y1,x2,y2,0);

			x1 = (g_iFontSize+4)*3+5 + 55;
			x2 = g_wInitialWidth - 5;
			y1 = 5;
			y2 = (g_iFontSize+4)*2+15;		
			JY_DrawBox(x1,y1,x2,y2,0);
		}
		else
		{
			x1 = (g_iFontSize+4)*3+5;
			x2 = g_wInitialWidth - 5;
			y1 = 5;
			y2 = (g_iFontSize+4)*2+15;		
			JY_DrawBox(x1,y1,x2,y2,0);
		}

		x1 = (g_iFontSize+4)*3+5;
		x2 = g_wInitialWidth - 5;
		y1 = (g_iFontSize+4)*2+20;
		y2 = g_wInitialHeight - 5;		

		JY_DrawBox(x1,y1,x2,y2,0);
	}
	else if (iFlag == 1)
	{
		x1 = 5;
		x2 = (g_iFontSize+4)*3;
		y1 = 5;
		y2 = g_wInitialHeight - 5;		
		JY_DrawBox(x1,y1,x2,y2,0);

		x1 = (g_iFontSize+4)*3+5;
		x2 = g_wInitialWidth - 5;
		y1 = 5;
		y2 = g_wInitialHeight - 5;		

		JY_DrawBox(x1,y1,x2,y2,0);
	}
	else if (iFlag == 2)
	{
		x1 = 5;
		x2 = (g_iFontSize+4)*3;
		y1 = 5;
		y2 = g_wInitialHeight - 5;		
		JY_DrawBox(x1,y1,x2,y2,0);

		x1 = (g_iFontSize+4)*3+5;
		x2 = (g_iFontSize+4)*3+5 + g_iFontSize/2*13;
		y1 = 5;
		y2 = (g_iFontSize+4)+5;		
		JY_DrawBox(x1,y1,x2,y2,0);

		x1 = (g_iFontSize+4)*3+5;
		x2 = (g_iFontSize+4)*3+5 + g_iFontSize/2*13;
		y1 = (g_iFontSize+4)+10;
		y2 = (g_iFontSize+4)*2+15;		
		JY_DrawBox(x1,y1,x2,y2,0);

		x1 = (g_iFontSize+4)*3+5;
		x2 = (g_iFontSize+4)*3+5 + g_iFontSize/2*13;
		y1 = (g_iFontSize+4)*2 +13;
		y2 = g_wInitialHeight - 5;		
		JY_DrawBox(x1,y1,x2,y2,0);

	}
	else if (iFlag == 3)
	{
		x1 = 5;
		x2 = (g_iFontSize+4)*3;
		y1 = 5;
		y2 = g_wInitialHeight - 5;		
		JY_DrawBox(x1,y1,x2,y2,0);

		x1 = (g_iFontSize+4)*3+5;
		x2 = (g_iFontSize+4)*3+5 + g_iFontSize/2*13;
		y1 = 5;
		y2 = (g_iFontSize+4)+7;		
		JY_DrawBox(x1,y1,x2,y2,0);
		JY_DrawStr((g_iFontSize+4)*3+8,8,"选择战斗人员",ZHICOLOR,0,FALSE,FALSE);
	}
	else if (iFlag == 4)
	{
		x1 = (g_iFontSize+4)*3+5;
		x2 = g_wInitialWidth - 5;
		y1 = 5;
		y2 = (g_iFontSize+4)*2+5;		
		JY_DrawBox(x1,y1,x2,y2,0);
		JY_DrawStr(g_iFontSize/2*16,8,"穿越必备,消耗能量未知",HUANGCOLOR,0,FALSE,FALSE);

		x1 = (g_iFontSize+4)*3+5;
		x2 = g_wInitialWidth - 5;
		y1 = (g_iFontSize+4)*2+10;
		y2 = g_wInitialHeight - 5;		

		JY_DrawBox(x1,y1,x2,y2,0);
	}
	else if (iFlag == 5)
	{
		x1 = (g_iFontSize+4)*3+5;
		x2 = g_wInitialWidth - 5;
		y1 = 5;
		y2 = g_wInitialHeight - 5;		

		JY_DrawBox(x1,y1,x2,y2,0);
	}
	else if (iFlag == 6)
	{
		x1 = 5;
		x2 = (g_iFontSize+4)*3;
		y1 = 5;
		y2 = g_wInitialHeight - 5;		
		JY_DrawBox(x1,y1,x2,y2,0);

		x1 = (g_iFontSize+4)*3+5;
		x2 = (g_iFontSize+4)*3+5 + g_iFontSize/2*13;
		y1 = 5;
		y2 = (g_iFontSize+4)+7 ;		
		JY_DrawBox(x1,y1,x2,y2,0);
		JY_DrawStr((g_iFontSize+4)*3+8,8,"选择离开队员",ZHICOLOR,0,FALSE,FALSE);
	}

}

//绘物品栏
short JY_DrawThingDilag(short iFristItem,short iCurrentItem,short iEndItem,short iType)
{
	JY_ThingDilagBack(0);

	int i = 0;
	short iWuPin = -1;
	short iWuPinNum = -1;
	int iLen = 0;
	BYTE bufText[30] = {0};
	char *pChar = NULL;
	int x1 = (g_iFontSize+4)*3+10;
	int y1 = (g_iFontSize+4)*2+25;
	int x2 = (g_iFontSize+4)*3+10 + g_iFontSize*8;
	int y2 = (g_iFontSize+4)*2+25;
	int x = x1;
	int y = y1;
	int iSpit = (g_wInitialHeight - ((g_iFontSize+4)*2+35)) / (g_iFontSize+4);
	int iPosWH = 0;
	short iW = 0;
	short iH = 0;
	if (g_iThingPicList == 0)
	{
		iW = 2;
		iSpit = (g_wInitialHeight - ((g_iFontSize+4)*2+35)) / (g_iFontSize+4) ;
		iH = iSpit = (g_wInitialHeight - ((g_iFontSize+4)*2+35)) / (g_iFontSize+4);
	}
	else
	{
		iH = ((g_wInitialHeight -((g_iFontSize+4)*3 +15)) / 41) /g_iZoom;
		if ( (((g_wInitialHeight -((g_iFontSize+4)*3 +15)) % 41)/g_iZoom) > 35)
			iH++;
		iW = ((g_wInitialWidth - ((g_iFontSize+4)*3 +15)) / 41)/g_iZoom;
		if ( (((g_wInitialWidth - ((g_iFontSize+4)*3 +15)) % 41)/g_iZoom) > 35)
			iW++;

		iSpit = ((g_wInitialHeight -((g_iFontSize+4)*3 +15)) / 41)/g_iZoom;
	}


	int iDrawNum = 0;
	short uscode = -1;
	for(i=iFristItem;i<iEndItem;i++)
	{
		if (i< 0 || i>=200)
			continue;

		if (gpGlobals->g.pBaseList->WuPin[i][0] == -1)
			continue;

		iWuPin = gpGlobals->g.pBaseList->WuPin[i][0];
		iWuPinNum = gpGlobals->g.pBaseList->WuPin[i][1];
		
		if (iWuPin < 0 || iWuPin >= gpGlobals->g.iThingsListCount)
			continue;

		ClearBuf(bufText,30);
		for(int j=0;j< 20;j++)
		{
			if (gpGlobals->g.pThingsList[iWuPin].name2big5[j] == 0)
			{
				bufText[j] =0;
				break;
			}
			bufText[j] = gpGlobals->g.pThingsList[iWuPin].name2big5[j] ;//^ 0xFF;
			iLen++;
		}
		Big5toUnicode(bufText,iLen);	

		if (g_iThingPicList == 0)
		{
			pChar = va("%-10s%4d",bufText,iWuPinNum);
			iLen = strlen(pChar);

			if (i == iCurrentItem)
			{
				JY_DrawStr(x,y,pChar,BAICOLOR,0,FALSE,FALSE);
				SafeFree(pChar);
				uscode = g_iThingImg + iWuPin;
				if (gpGlobals->g.Status == 1 || gpGlobals->g.Status == 4)
				{
					if (uscode > 0 )
					{
						JY_LoadPic(1,uscode * 2,(g_iFontSize+4)*3+10,10,1,0);
					}
				}
				if (gpGlobals->g.Status == 2 || gpGlobals->g.Status == 3)
				{
					if (uscode > 0 )
					{
						JY_LoadPic(0,uscode * 2,(g_iFontSize+4)*3+10,10,1,0);
					}
				}
				if (gpGlobals->g.Status == 5)
				{
					if (uscode > 0 )
					{
						JY_LoadPic(3,uscode * 2,(g_iFontSize+4)*3+10,10,1,0);
					}
				}
				iLen = 0;
				ClearBuf(bufText,30);
				if (iWuPin == 182)
				{
					if (g_iOftenShowXY == 0)
					{
						if (gpGlobals->g.Status == 1 || gpGlobals->g.Status == 4 || gpGlobals->g.Status == 5)
						{
							pChar = va("罗盘,人坐标:%d,%d 船坐标:%d,%d",
							gpGlobals->g.pBaseList->SMapX,gpGlobals->g.pBaseList->SMapY,
							gpGlobals->g.pBaseList->BoatX,gpGlobals->g.pBaseList->BoatY);
						}
						else
						{
							pChar = va("罗盘,人坐标:%d,%d 船坐标:%d,%d",
							gpGlobals->g.pBaseList->WMapX,gpGlobals->g.pBaseList->WMapY,
							gpGlobals->g.pBaseList->BoatX,gpGlobals->g.pBaseList->BoatY);
						}
					}
					else
						pChar = va("罗盘,船坐标:%d,%d",gpGlobals->g.pBaseList->BoatX,gpGlobals->g.pBaseList->BoatY);
					if (pChar != NULL)
					{
						JY_DrawStr((g_iFontSize+4)*3+5 + 65,10,pChar,HUANGCOLOR,0,FALSE,FALSE);
					}
					SafeFree(pChar);
				}
				else
				{
					for(int k=0;k< 30;k++)
					{
						if (gpGlobals->g.pThingsList[iWuPin].ShuoMingbig5[k] == 0)
							break;
						bufText[k] = gpGlobals->g.pThingsList[iWuPin].ShuoMingbig5[k] ;//^ 0xFF;
						iLen++;
					}
					Big5toUnicode(bufText,iLen);
					pChar = strtok((char*)bufText,"，");
					if (pChar != NULL)
					{
						JY_DrawStr((g_iFontSize+4)*3+5 + 65,10,pChar,HUANGCOLOR,0,FALSE,FALSE);
					}	
					pChar = strtok(NULL,"，");
					if (pChar != NULL)
					{
						JY_DrawStr((g_iFontSize+4)*3+5 + 65,10+(g_iFontSize+4),pChar,HUANGCOLOR,0,FALSE,FALSE);
					}
				}
				if (gpGlobals->g.pThingsList[iWuPin].ShiYongRen != -1)
				{
					iLen = 0;
					ClearBuf(bufText,30);
					for(int k=0;k< 10;k++)
					{
						if (gpGlobals->g.pPersonList[gpGlobals->g.pThingsList[iWuPin].ShiYongRen].name1big5[k] == 0)
						{
							bufText[k] =0;
							break;
						}
						bufText[k] =gpGlobals->g.pPersonList[gpGlobals->g.pThingsList[iWuPin].ShiYongRen].name1big5[k] ;//^ 0xFF;
						iLen++;
					}
					Big5toUnicode(bufText,iLen);
					pChar = va("(*%s*)",bufText);
					if (pChar != NULL)
					{
						JY_DrawStr((g_iFontSize+4)*12+5,10+(g_iFontSize+4),pChar,HUANGCOLOR,0,FALSE,FALSE);
						SafeFree(pChar);
					}

				}
			}
			else
			{
				JY_DrawStr(x,y,pChar,HUANGCOLOR,0,FALSE,FALSE);
			}
			iDrawNum++;
			if (iDrawNum == iSpit)
			{
				x = x2;
				y = y2;
			}
			else
			{
				y+=(g_iFontSize+4);
			}
		}
		else//图片格式
		{
			pChar = va("%s%4d",bufText,iWuPinNum);
			iLen = strlen(pChar);

			if (i == iCurrentItem)
			{
				iPosWH = JY_DrawStr((g_iFontSize+4)*3+10,10,pChar,HUANGCOLOR,0,FALSE,FALSE);

				JY_DrawBox(x + (iDrawNum%iW)*41*g_iZoom-1,y + (iDrawNum/iW)*41*g_iZoom-1,x + (iDrawNum%iW)*41*g_iZoom+40*g_iZoom,y + (iDrawNum/iW)*41*g_iZoom+40*g_iZoom,ZHICOLOR);

				iLen = 0;
				ClearBuf(bufText,30);
				if (iWuPin == 182)
				{
					if (g_iOftenShowXY == 0)
					{
						if (gpGlobals->g.Status == 1 || gpGlobals->g.Status == 4 || gpGlobals->g.Status == 5)
						{
							pChar = va("人坐标:%d,%d 船坐标:%d,%d",
								gpGlobals->g.pBaseList->SMapX,gpGlobals->g.pBaseList->SMapY,
								gpGlobals->g.pBaseList->BoatX,gpGlobals->g.pBaseList->BoatY);
						}
						else
						{
							pChar = va("人坐标:%d,%d 船坐标:%d,%d",
								gpGlobals->g.pBaseList->WMapX,gpGlobals->g.pBaseList->WMapY,
								gpGlobals->g.pBaseList->BoatX,gpGlobals->g.pBaseList->BoatY);
						}
					}
					else
						pChar = va("船坐标:%d,%d",gpGlobals->g.pBaseList->BoatX,gpGlobals->g.pBaseList->BoatY);
					if (pChar != NULL)
					{
						JY_DrawStr((g_iFontSize+4)*3+10,10+(g_iFontSize+4),pChar,HUANGCOLOR,0,FALSE,FALSE);
					}
					SafeFree(pChar);
				}
				else
				{
					iLen = 0;
					for(int k=0;k< 30;k++)
					{
						if (gpGlobals->g.pThingsList[iWuPin].ShuoMingbig5[k] == 0)
							break;
						bufText[k] = gpGlobals->g.pThingsList[iWuPin].ShuoMingbig5[k] ;//^ 0xFF;
						iLen++;
					}
					Big5toUnicode(bufText,iLen);
					pChar = strtok((char*)bufText,"，");
					iLen = strlen(pChar);
					if (pChar != NULL)
					{
						JY_DrawStr((g_iFontSize+4)*3+10+ JY_X(iPosWH) + 5,10,pChar,HUANGCOLOR,0,FALSE,FALSE);
					}	
					pChar = strtok(NULL,"，");
					if (pChar != NULL)
					{
						JY_DrawStr((g_iFontSize+4)*3+10,10+(g_iFontSize+4),pChar,HUANGCOLOR,0,FALSE,FALSE);
					}
				}
				if (gpGlobals->g.pThingsList[iWuPin].ShiYongRen != -1)
				{
					iLen = 0;
					ClearBuf(bufText,30);
					for(int k=0;k< 10;k++)
					{
						if (gpGlobals->g.pPersonList[gpGlobals->g.pThingsList[iWuPin].ShiYongRen].name1big5[k] == 0)
						{
							bufText[k] =0;
							break;
						}
						bufText[k] =gpGlobals->g.pPersonList[gpGlobals->g.pThingsList[iWuPin].ShiYongRen].name1big5[k] ;//^ 0xFF;
						iLen++;
					}
					Big5toUnicode(bufText,iLen);
					pChar = va("(*%s*)",bufText);
					if (pChar != NULL)
					{
						JY_DrawStr((g_iFontSize+4)*12+5,10+(g_iFontSize+4),pChar,HUANGCOLOR,0,FALSE,FALSE);
						SafeFree(pChar);
					}

				}

			}
			uscode = g_iThingImg + iWuPin;
			if (gpGlobals->g.Status == 1 || gpGlobals->g.Status == 4)
			{
				if (uscode > 0 )
				{
					JY_LoadPic(1,uscode * 2,x + (iDrawNum%iW)*41*g_iZoom,y + (iDrawNum/iW)*41*g_iZoom,1,0);
				}
			}
			if (gpGlobals->g.Status == 2 || gpGlobals->g.Status == 3)
			{
				if (uscode > 0 )
				{
					JY_LoadPic(0,uscode * 2,x + (iDrawNum%iW)*41*g_iZoom,y + (iDrawNum/iW)*41*g_iZoom,1,0);
				}
			}
			if (gpGlobals->g.Status == 5)
			{
				if (uscode > 0 )
				{
					JY_LoadPic(3,uscode * 2,x + (iDrawNum%iW)*41*g_iZoom,y + (iDrawNum/iW)*41*g_iZoom,1,0);
				}
			}
			iDrawNum++;
		}

		
	}
	pChar = NULL;
	return iDrawNum + iFristItem;
}
//绘状态栏
VOID JY_DrawPersonStatus(short iCurrentItem)
{
	if (iCurrentItem < 0 || iCurrentItem > 6)
		return;
	int x1 = (g_iFontSize+4)*3+5;
	int y1 = 5;

	//BlitSurface0(gpScreen,x1+2,y1+2,g_wInitialWidth - 75,g_wInitialHeight - 15);

	short iPerson = gpGlobals->g.pBaseList->Group[iCurrentItem];
	if (iPerson < 0)
		return;

	char *pChar = NULL;
	BYTE bufText[20] = {0};
	int iLen = 0;
	
	short iTemp = 0;

	pChar = va("等级%3d",gpGlobals->g.pPersonList[iPerson].grade);
	if (pChar != NULL)
	{
		JY_DrawStr(x1 + 2,y1 + 2,pChar,BAICOLOR,0,FALSE,FALSE);
		SafeFree(pChar);
	}

	iTemp = gpGlobals->g.pPersonList[iPerson].GongJiLi;
	if (gpGlobals->g.pPersonList[iPerson].WuQi != -1)
	{
		iTemp = iTemp + gpGlobals->g.pThingsList[gpGlobals->g.pPersonList[iPerson].WuQi].JiaGongJiLi;
	}
	if (gpGlobals->g.pPersonList[iPerson].Fangju != -1)
	{
		iTemp = iTemp + gpGlobals->g.pThingsList[gpGlobals->g.pPersonList[iPerson].Fangju].JiaGongJiLi;
	}
	pChar = va("攻击%3d",iTemp);
	if (pChar != NULL)
	{
		JY_DrawStr(x1 + 2,y1 + 2 + (g_iFontSize+4),pChar,BAICOLOR,0,FALSE,FALSE);
		SafeFree(pChar);
	}
	
	iTemp = gpGlobals->g.pPersonList[iPerson].FangYuLi;
	if (gpGlobals->g.pPersonList[iPerson].WuQi != -1)
	{
		iTemp = iTemp + gpGlobals->g.pThingsList[gpGlobals->g.pPersonList[iPerson].WuQi].JiaFangYuLi;
	}
	if (gpGlobals->g.pPersonList[iPerson].Fangju != -1)
	{
		iTemp = iTemp + gpGlobals->g.pThingsList[gpGlobals->g.pPersonList[iPerson].Fangju].JiaFangYuLi;
	}
	pChar = va("防御%3d",iTemp);
	if (pChar != NULL)
	{
		JY_DrawStr(x1 + 2,y1 + 2 + (g_iFontSize+4)*2,pChar,BAICOLOR,0,FALSE,FALSE);
		SafeFree(pChar);
	}
	//
	iTemp = gpGlobals->g.pPersonList[iPerson].QingGong;
	if (gpGlobals->g.pPersonList[iPerson].WuQi != -1)
	{
		iTemp = iTemp + gpGlobals->g.pThingsList[gpGlobals->g.pPersonList[iPerson].WuQi].JiaQingGong;
	}
	if (gpGlobals->g.pPersonList[iPerson].Fangju != -1)
	{
		iTemp = iTemp + gpGlobals->g.pThingsList[gpGlobals->g.pPersonList[iPerson].Fangju].JiaQingGong;
	}
	pChar = va("轻功%3d",iTemp);
	if (pChar != NULL)
	{
		JY_DrawStr(x1 + 2 + (g_iFontSize+4)*3+5,y1 + 2 ,pChar,BAICOLOR,0,FALSE,FALSE);
		SafeFree(pChar);
	}
	
	iTemp = gpGlobals->g.pPersonList[iPerson].YiLiao;
	if (gpGlobals->g.pPersonList[iPerson].WuQi != -1)
	{
		iTemp = iTemp + gpGlobals->g.pThingsList[gpGlobals->g.pPersonList[iPerson].WuQi].JiaYiLiao;
	}
	if (gpGlobals->g.pPersonList[iPerson].Fangju != -1)
	{
		iTemp = iTemp + gpGlobals->g.pThingsList[gpGlobals->g.pPersonList[iPerson].Fangju].JiaYiLiao;
	}
	pChar = va("医疗%3d",iTemp);
	if (pChar != NULL)
	{
		JY_DrawStr(x1 + 2 + (g_iFontSize+4)*3+5,y1 + 2 +(g_iFontSize+4),pChar,BAICOLOR,0,FALSE,FALSE);
		SafeFree(pChar);
	}

	iTemp = gpGlobals->g.pPersonList[iPerson].YongDu;
	if (gpGlobals->g.pPersonList[iPerson].WuQi != -1)
	{
		iTemp = iTemp + gpGlobals->g.pThingsList[gpGlobals->g.pPersonList[iPerson].WuQi].JiaShiDu;
	}
	if (gpGlobals->g.pPersonList[iPerson].Fangju != -1)
	{
		iTemp = iTemp + gpGlobals->g.pThingsList[gpGlobals->g.pPersonList[iPerson].Fangju].JiaShiDu;
	}
	pChar = va("用毒%3d",iTemp);
	if (pChar != NULL)
	{
		JY_DrawStr(x1 + 2 + (g_iFontSize+4)*3+5,y1 + 2 +(g_iFontSize+4)*2,pChar,BAICOLOR,0,FALSE,FALSE);
		SafeFree(pChar);
	}
	//
	iTemp = gpGlobals->g.pPersonList[iPerson].JieDu;
	if (gpGlobals->g.pPersonList[iPerson].WuQi != -1)
	{
		iTemp = iTemp + gpGlobals->g.pThingsList[gpGlobals->g.pPersonList[iPerson].WuQi].JiaJieDu;
	}
	if (gpGlobals->g.pPersonList[iPerson].Fangju != -1)
	{
		iTemp = iTemp + gpGlobals->g.pThingsList[gpGlobals->g.pPersonList[iPerson].Fangju].JiaJieDu;
	}
	pChar = va("解毒%3d",iTemp);
	if (pChar != NULL)
	{
		JY_DrawStr(x1 + 2 + (g_iFontSize+4)*6+5,y1 + 2 ,pChar,BAICOLOR,0,FALSE,FALSE);
		SafeFree(pChar);
	}

	iTemp = gpGlobals->g.pPersonList[iPerson].QuanZhang;
	if (gpGlobals->g.pPersonList[iPerson].WuQi != -1)
	{
		iTemp = iTemp + gpGlobals->g.pThingsList[gpGlobals->g.pPersonList[iPerson].WuQi].JiaQuanZhang;
	}
	if (gpGlobals->g.pPersonList[iPerson].Fangju != -1)
	{
		iTemp = iTemp + gpGlobals->g.pThingsList[gpGlobals->g.pPersonList[iPerson].Fangju].JiaQuanZhang;
	}
	pChar = va("拳掌%3d",iTemp);
	if (pChar != NULL)
	{
		JY_DrawStr(x1 + 2 + (g_iFontSize+4)*6+5,y1 + 2 +(g_iFontSize+4),pChar,BAICOLOR,0,FALSE,FALSE);
		SafeFree(pChar);
	}
	
	iTemp = gpGlobals->g.pPersonList[iPerson].YuJian;
	if (gpGlobals->g.pPersonList[iPerson].WuQi != -1)
	{
		iTemp = iTemp + gpGlobals->g.pThingsList[gpGlobals->g.pPersonList[iPerson].WuQi].JiaYuJian;
	}
	if (gpGlobals->g.pPersonList[iPerson].Fangju != -1)
	{
		iTemp = iTemp + gpGlobals->g.pThingsList[gpGlobals->g.pPersonList[iPerson].Fangju].JiaYuJian;
	}
	pChar = va("御剑%3d",iTemp);
	if (pChar != NULL)
	{
		JY_DrawStr(x1 + 2 + (g_iFontSize+4)*6+5,y1 + 2 +(g_iFontSize+4)*2,pChar,BAICOLOR,0,FALSE,FALSE);
		SafeFree(pChar);
	}
	//
	iTemp = gpGlobals->g.pPersonList[iPerson].ShuaDao;
	if (gpGlobals->g.pPersonList[iPerson].WuQi != -1)
	{
		iTemp = iTemp + gpGlobals->g.pThingsList[gpGlobals->g.pPersonList[iPerson].WuQi].JiaShuaDao;
	}
	if (gpGlobals->g.pPersonList[iPerson].Fangju != -1)
	{
		iTemp = iTemp + gpGlobals->g.pThingsList[gpGlobals->g.pPersonList[iPerson].Fangju].JiaShuaDao;
	}
	pChar = va("耍刀%3d",iTemp);
	if (pChar != NULL)
	{
		JY_DrawStr(x1 + 2 + (g_iFontSize+4)*9+5,y1 + 2 ,pChar,BAICOLOR,0,FALSE,FALSE);
		SafeFree(pChar);
	}
	
	iTemp = gpGlobals->g.pPersonList[iPerson].TeSHuBingQi;
	if (gpGlobals->g.pPersonList[iPerson].WuQi != -1)
	{
		iTemp = iTemp + gpGlobals->g.pThingsList[gpGlobals->g.pPersonList[iPerson].WuQi].JiaTeShuBingQi;
	}
	if (gpGlobals->g.pPersonList[iPerson].Fangju != -1)
	{
		iTemp = iTemp + gpGlobals->g.pThingsList[gpGlobals->g.pPersonList[iPerson].Fangju].JiaTeShuBingQi;
	}
	pChar = va("特殊%3d",iTemp);
	if (pChar != NULL)
	{
		JY_DrawStr(x1 + 2 + (g_iFontSize+4)*9+5,y1 + 2 +(g_iFontSize+4),pChar,BAICOLOR,0,FALSE,FALSE);
		SafeFree(pChar);
	}
	
	iTemp = gpGlobals->g.pPersonList[iPerson].AnQiJiQiao;
	if (gpGlobals->g.pPersonList[iPerson].WuQi != -1)
	{
		iTemp = iTemp + gpGlobals->g.pThingsList[gpGlobals->g.pPersonList[iPerson].WuQi].JiaAnQiJiQiao;
	}
	if (gpGlobals->g.pPersonList[iPerson].Fangju != -1)
	{
		iTemp = iTemp + gpGlobals->g.pThingsList[gpGlobals->g.pPersonList[iPerson].Fangju].JiaAnQiJiQiao;
	}
	pChar = va("暗器%3d",iTemp);
	if (pChar != NULL)
	{
		JY_DrawStr(x1 + 2 + (g_iFontSize+4)*9+5,y1 + 2 +(g_iFontSize+4)*2,pChar,BAICOLOR,0,FALSE,FALSE);
		SafeFree(pChar);
	}

	//-------
	iTemp = gpGlobals->g.pPersonList[iPerson].hp;
	if (gpGlobals->g.pPersonList[iPerson].WuQi != -1)
	{
		iTemp = iTemp + gpGlobals->g.pThingsList[gpGlobals->g.pPersonList[iPerson].WuQi].JiaShengMing;
	}
	if (gpGlobals->g.pPersonList[iPerson].Fangju != -1)
	{
		iTemp = iTemp + gpGlobals->g.pThingsList[gpGlobals->g.pPersonList[iPerson].Fangju].JiaShengMing;
	}
	//
	JY_DrawStr(x1 + 2 ,y1 + 2 +(g_iFontSize+4)*3,"生命",HUANGCOLOR,0,FALSE,FALSE);
	pChar = va("%4d",gpGlobals->g.pPersonList[iPerson].hp);
	INT color = HUANGCOLOR;
	if (gpGlobals->g.pPersonList[iPerson].ShouShang > 0 && gpGlobals->g.pPersonList[iPerson].ShouShang <(g_ishoushangMax/2))
	{
		color = JY_GetColor(236, 200, 40);
	}
	else if (gpGlobals->g.pPersonList[iPerson].ShouShang > 0 && gpGlobals->g.pPersonList[iPerson].ShouShang <(g_ishoushangMax/3*2))
	{
		color = JY_GetColor(244, 128, 32);
	}
	else
	{
		color = HUANGCOLOR;
	}
	JY_DrawStr(x1+g_iFontSize*2+3,y1 + 2 +(g_iFontSize+4)*3,pChar,color,0,FALSE,FALSE);
	SafeFree(pChar);
	JY_DrawStr(x1+g_iFontSize*4,y1 + 2 +(g_iFontSize+4)*3,"/",HUANGCOLOR,0,FALSE,FALSE);
	if (gpGlobals->g.pPersonList[iPerson].ZhongDu == 0)
	{
		color = HUANGCOLOR;
	}
	else if (gpGlobals->g.pPersonList[iPerson].ZhongDu <(g_izhongduMax/2))
	{
		color = JY_GetColor(120,208,88);
	}
	else
	{
		color = JY_GetColor(56,136,36);
	}
	pChar = va("%3d",gpGlobals->g.pPersonList[iPerson].hpMax);
	JY_DrawStr(x1+g_iFontSize*4+10,y1 + 2 +(g_iFontSize+4)*3,pChar,color,0,FALSE,FALSE);
	SafeFree(pChar);

	iTemp = gpGlobals->g.pPersonList[iPerson].Neili;
	if (gpGlobals->g.pPersonList[iPerson].WuQi != -1)
	{
		iTemp = iTemp + gpGlobals->g.pThingsList[gpGlobals->g.pPersonList[iPerson].WuQi].JiaNeiLi;
	}
	if (gpGlobals->g.pPersonList[iPerson].Fangju != -1)
	{
		iTemp = iTemp + gpGlobals->g.pThingsList[gpGlobals->g.pPersonList[iPerson].Fangju].JiaNeiLi;
	}
	pChar = va("内力%4d/%3d",iTemp,gpGlobals->g.pPersonList[iPerson].NeiliMax);
	if (gpGlobals->g.pPersonList[iPerson].NeiliXingZhi == 0)
	{
		if (pChar != NULL)
		{
			JY_DrawStr(x1 + 2 ,y1 + 2 +(g_iFontSize+4)*4,pChar,ZHICOLOR,0,FALSE,FALSE);
			SafeFree(pChar);
		}
	}
	if (gpGlobals->g.pPersonList[iPerson].NeiliXingZhi == 1)
	{
		if (pChar != NULL)
		{
			JY_DrawStr(x1 + 2 ,y1 + 2 +(g_iFontSize+4)*4,pChar,HUANGCOLOR,0,FALSE,FALSE);
			SafeFree(pChar);
		}
	}
	if (gpGlobals->g.pPersonList[iPerson].NeiliXingZhi == 2)
	{
		if (pChar != NULL)
		{
			JY_DrawStr(x1 + 2 ,y1 + 2 +(g_iFontSize+4)*4,pChar,BAICOLOR,0,FALSE,FALSE);
			SafeFree(pChar);
		}
	}

	iTemp = gpGlobals->g.pPersonList[iPerson].Tili;
	if (gpGlobals->g.pPersonList[iPerson].WuQi != -1)
	{
		iTemp = iTemp + gpGlobals->g.pThingsList[gpGlobals->g.pPersonList[iPerson].WuQi].JiaTiLi;
	}
	if (gpGlobals->g.pPersonList[iPerson].Fangju != -1)
	{
		iTemp = iTemp + gpGlobals->g.pThingsList[gpGlobals->g.pPersonList[iPerson].Fangju].JiaTiLi;
	}
	pChar = va("体力%4d/%3d",iTemp,100);
	if (pChar != NULL)
	{
		JY_DrawStr(x1 + 2 ,y1 + 2 +(g_iFontSize+4)*5,pChar,HUANGCOLOR,0,FALSE,FALSE);
		SafeFree(pChar);
	}

	short tmplevel=gpGlobals->g.pPersonList[iPerson].grade;
	int iLeveExp = -1;
	char buf[20] = {0};
	char cLeve[20] = {0};
	char cFile[256] = {0};
	sprintf(cFile,"%s/mod.txt",JY_PREFIX);
	sprintf(cLeve,"%d",tmplevel);
	if (GetIniValue(cFile, "LEVE", cLeve, "-1", buf))
		iLeveExp = atoi(buf);
	if (iLeveExp == -1)
		iLeveExp = 50 * tmplevel;

	pChar = va("经验%4d/%4d",gpGlobals->g.pPersonList[iPerson].exp,iLeveExp);
	if (pChar != NULL)
	{
		JY_DrawStr(x1 + 2 ,y1 + 2 +(g_iFontSize+4)*6,pChar,HUANGCOLOR,0,FALSE,FALSE);
		SafeFree(pChar);
	}

	pChar = va("武器");
	if (pChar != NULL)
	{
		JY_DrawStr(x1 + 2 ,y1 + 2 +(g_iFontSize+4)*7,pChar,HUANGCOLOR,0,FALSE,FALSE);
		SafeFree(pChar);
	}

	if ( gpGlobals->g.pPersonList[iPerson].WuQi != -1)
	{
		int iLen = 0;
		for(int i=0;i<20;i++)
		{
			if (gpGlobals->g.pThingsList[gpGlobals->g.pPersonList[iPerson].WuQi].name2big5[i] == 0)
			{
				bufText[i] =0;
				break;
			}
			bufText[i] = gpGlobals->g.pThingsList[gpGlobals->g.pPersonList[iPerson].WuQi].name2big5[i] ;//^ 0xFF;
			iLen++;
		}
		Big5toUnicode(bufText,iLen);
		JY_DrawStr(x1 + 2 +(g_iFontSize+4)*2,y1 + 2 +(g_iFontSize+4)*7,(char *)bufText,HUANGCOLOR,0,FALSE,FALSE);

	}
	
	pChar = va("防具");
	if (pChar != NULL)
	{
		JY_DrawStr(x1 + 2 ,y1 + 2 +(g_iFontSize+4)*8,pChar,HUANGCOLOR,0,FALSE,FALSE);
		SafeFree(pChar);
	}

	if ( gpGlobals->g.pPersonList[iPerson].Fangju != -1)
	{
		int iLen = 0;
		for(int i=0;i<20;i++)
		{
			if (gpGlobals->g.pThingsList[gpGlobals->g.pPersonList[iPerson].Fangju].name2big5[i] == 0)
			{
				bufText[i] =0;
				break;
			}
			bufText[i] = gpGlobals->g.pThingsList[gpGlobals->g.pPersonList[iPerson].Fangju].name2big5[i] ;//^ 0xFF;
			iLen++;
		}
		Big5toUnicode(bufText,iLen);
		JY_DrawStr(x1 + 2 +(g_iFontSize+4)*2,y1 + 2 +(g_iFontSize+4)*8,(char *)bufText,HUANGCOLOR,0,FALSE,FALSE);
	}

	pChar = va("修炼");
	if (pChar != NULL)
	{
		JY_DrawStr(x1 + 2 ,y1 + 2 +(g_iFontSize+4)*9,pChar,HUANGCOLOR,0,FALSE,FALSE);
		SafeFree(pChar);
	}

	if ( gpGlobals->g.pPersonList[iPerson].XiuLianWuPin != -1)
	{
		int iLen = 0;
		for(int i=0;i<20;i++)
		{
			if (gpGlobals->g.pThingsList[gpGlobals->g.pPersonList[iPerson].XiuLianWuPin].name2big5[i] == 0)
			{
				bufText[i] =0;
				break;
			}
			bufText[i] = gpGlobals->g.pThingsList[gpGlobals->g.pPersonList[iPerson].XiuLianWuPin].name2big5[i] ;//^ 0xFF;
			iLen++;
		}
		Big5toUnicode(bufText,iLen);
		JY_DrawStr(x1 + 2 +(g_iFontSize+4)*2,y1 + 2 +(g_iFontSize+4)*9,(char *)bufText,HUANGCOLOR,0,FALSE,FALSE);
	}

	pChar = va("点数%4d/%4d",gpGlobals->g.pPersonList[iPerson].XiuLianDianShu,TrainNeedExp(iPerson));
	if (pChar != NULL)
	{
		JY_DrawStr(x1 + 2 ,y1 + 2 +(g_iFontSize+4)*10,pChar,HUANGCOLOR,0,FALSE,FALSE);
		SafeFree(pChar);
	}
	
	//----------
	int iWuGongNum = 0;
	if ( gpGlobals->g.pPersonList[iPerson].WuGong[iWuGongNum] > 0)
	{
		iLen = 0;
		ClearBuf(bufText,20);
		for(int i=0;i<10;i++)
		{
			if (gpGlobals->g.pWuGongList[gpGlobals->g.pPersonList[iPerson].WuGong[iWuGongNum]].Name1[i] == 0)
			{
				bufText[i] =0;
				break;
			}
			bufText[i] = gpGlobals->g.pWuGongList[gpGlobals->g.pPersonList[iPerson].WuGong[iWuGongNum]].Name1[i] ;//^ 0xFF;
			iLen++;
		}
		Big5toUnicode(bufText,iLen);
		pChar = va("%-10s%2d",bufText,gpGlobals->g.pPersonList[iPerson].WuGongDengji[iWuGongNum] / 100+1);
		if (pChar != NULL)
		{
			JY_DrawStr(x1 + 2 +(g_iFontSize+4)*6+15,y1 + 2 +(g_iFontSize+4)*3,pChar,HUANGCOLOR,0,FALSE,FALSE);
			SafeFree(pChar);
		}
		
	}
	iWuGongNum++;
	if ( gpGlobals->g.pPersonList[iPerson].WuGong[iWuGongNum] > 0)
	{
		iLen = 0;
		ClearBuf(bufText,20);
		for(int i=0;i<10;i++)
		{
			if (gpGlobals->g.pWuGongList[gpGlobals->g.pPersonList[iPerson].WuGong[iWuGongNum]].Name1[i] == 0)
			{
				bufText[i] =0;
				break;
			}
			bufText[i] = gpGlobals->g.pWuGongList[gpGlobals->g.pPersonList[iPerson].WuGong[iWuGongNum]].Name1[i] ;//^ 0xFF;
			iLen++;
		}
		Big5toUnicode(bufText,iLen);
		pChar = va("%-10s%2d",bufText,gpGlobals->g.pPersonList[iPerson].WuGongDengji[iWuGongNum] / 100 + 1);
		if (pChar != NULL)
		{
			JY_DrawStr(x1 + 2 +(g_iFontSize+4)*6+15,y1 + 2 + iWuGongNum * g_iFontSize + (g_iFontSize+4)*3,pChar,HUANGCOLOR,0,FALSE,FALSE);
			SafeFree(pChar);
		}
			
	}
	iWuGongNum++;
	if ( gpGlobals->g.pPersonList[iPerson].WuGong[iWuGongNum] > 0)
	{
		iLen = 0;
		ClearBuf(bufText,20);
		for(int i=0;i<10;i++)
		{
			if (gpGlobals->g.pWuGongList[gpGlobals->g.pPersonList[iPerson].WuGong[iWuGongNum]].Name1[i] == 0)
			{
				bufText[i] =0;
				break;
			}
			bufText[i] = gpGlobals->g.pWuGongList[gpGlobals->g.pPersonList[iPerson].WuGong[iWuGongNum]].Name1[i] ;//^ 0xFF;
			iLen++;
		}
		Big5toUnicode(bufText,iLen);
		pChar = va("%-10s%2d",bufText,gpGlobals->g.pPersonList[iPerson].WuGongDengji[iWuGongNum] / 100 + 1);
		if (pChar != NULL)
		{
			JY_DrawStr(x1 + 2 +(g_iFontSize+4)*6+15,y1 + 2 + iWuGongNum * g_iFontSize + (g_iFontSize+4)*3,pChar,HUANGCOLOR,0,FALSE,FALSE);
			SafeFree(pChar);
		}
	}
	iWuGongNum++;
	if ( gpGlobals->g.pPersonList[iPerson].WuGong[iWuGongNum] > 0)
	{
		iLen = 0;
		ClearBuf(bufText,20);
		for(int i=0;i<10;i++)
		{
			if (gpGlobals->g.pWuGongList[gpGlobals->g.pPersonList[iPerson].WuGong[iWuGongNum]].Name1[i] == 0)
			{
				bufText[i] =0;
				break;
			}
			bufText[i] = gpGlobals->g.pWuGongList[gpGlobals->g.pPersonList[iPerson].WuGong[iWuGongNum]].Name1[i] ;//^ 0xFF;
			iLen++;
		}
		Big5toUnicode(bufText,iLen);
		pChar = va("%-10s%2d",bufText,gpGlobals->g.pPersonList[iPerson].WuGongDengji[iWuGongNum] / 100 + 1);
		if (pChar != NULL)
		{
			JY_DrawStr(x1 + 2 +(g_iFontSize+4)*6+15,y1 + 2 + iWuGongNum * g_iFontSize + (g_iFontSize+4)*3,pChar,HUANGCOLOR,0,FALSE,FALSE);
			SafeFree(pChar);
		}
	}
	iWuGongNum++;
	if ( gpGlobals->g.pPersonList[iPerson].WuGong[iWuGongNum] > 0)
	{
		iLen = 0;
		ClearBuf(bufText,20);
		for(int i=0;i<10;i++)
		{
			if (gpGlobals->g.pWuGongList[gpGlobals->g.pPersonList[iPerson].WuGong[iWuGongNum]].Name1[i] == 0)
			{
				bufText[i] =0;
				break;
			}
			bufText[i] = gpGlobals->g.pWuGongList[gpGlobals->g.pPersonList[iPerson].WuGong[iWuGongNum]].Name1[i] ;//^ 0xFF;
			iLen++;
		}
		Big5toUnicode(bufText,iLen);
		pChar = va("%-10s%2d",bufText,gpGlobals->g.pPersonList[iPerson].WuGongDengji[iWuGongNum] / 100 + 1);
		if (pChar != NULL)
		{
			JY_DrawStr(x1 + 2 +(g_iFontSize+4)*6+15,y1 + 2 + iWuGongNum * g_iFontSize + (g_iFontSize+4)*3,pChar,HUANGCOLOR,0,FALSE,FALSE);
			SafeFree(pChar);
		}
	}
	iWuGongNum++;
	if ( gpGlobals->g.pPersonList[iPerson].WuGong[iWuGongNum] > 0)
	{
		iLen = 0;
		ClearBuf(bufText,20);
		for(int i=0;i<10;i++)
		{
			if (gpGlobals->g.pWuGongList[gpGlobals->g.pPersonList[iPerson].WuGong[iWuGongNum]].Name1[i] == 0)
			{
				bufText[i] =0;
				break;
			}
			bufText[i] = gpGlobals->g.pWuGongList[gpGlobals->g.pPersonList[iPerson].WuGong[iWuGongNum]].Name1[i] ;//^ 0xFF;
			iLen++;
		}
		Big5toUnicode(bufText,iLen);
		pChar = va("%-10s%2d",bufText,gpGlobals->g.pPersonList[iPerson].WuGongDengji[iWuGongNum] / 100 + 1);
		if (pChar != NULL)
		{
			JY_DrawStr(x1 + 2 +(g_iFontSize+4)*6+15,y1 + 2 + iWuGongNum * g_iFontSize + (g_iFontSize+4)*3,pChar,HUANGCOLOR,0,FALSE,FALSE);
			SafeFree(pChar);
		}	
	}
	iWuGongNum++;
	if ( gpGlobals->g.pPersonList[iPerson].WuGong[iWuGongNum] > 0)
	{
		iLen = 0;
		ClearBuf(bufText,20);
		for(int i=0;i<10;i++)
		{
			if (gpGlobals->g.pWuGongList[gpGlobals->g.pPersonList[iPerson].WuGong[iWuGongNum]].Name1[i] == 0)
			{
				bufText[i] =0;
				break;
			}
			bufText[i] = gpGlobals->g.pWuGongList[gpGlobals->g.pPersonList[iPerson].WuGong[iWuGongNum]].Name1[i] ;//^ 0xFF;
			iLen++;
		}
		Big5toUnicode(bufText,iLen);
		pChar = va("%-10s%2d",bufText,gpGlobals->g.pPersonList[iPerson].WuGongDengji[iWuGongNum] / 100 + 1);
		if (pChar != NULL)
		{
			JY_DrawStr(x1 + 2 +(g_iFontSize+4)*6+15,y1 + 2 + iWuGongNum * g_iFontSize + (g_iFontSize+4)*3,pChar,HUANGCOLOR,0,FALSE,FALSE);
			SafeFree(pChar);
		}
	}
	iWuGongNum++;
	if ( gpGlobals->g.pPersonList[iPerson].WuGong[iWuGongNum] > 0)
	{
		iLen = 0;
		ClearBuf(bufText,20);
		for(int i=0;i<10;i++)
		{
			if (gpGlobals->g.pWuGongList[gpGlobals->g.pPersonList[iPerson].WuGong[iWuGongNum]].Name1[i] == 0)
			{
				bufText[i] =0;
				break;
			}
			bufText[i] = gpGlobals->g.pWuGongList[gpGlobals->g.pPersonList[iPerson].WuGong[iWuGongNum]].Name1[i] ;//^ 0xFF;
			iLen++;
		}
		Big5toUnicode(bufText,iLen);
		pChar = va("%-10s%2d",bufText,gpGlobals->g.pPersonList[iPerson].WuGongDengji[iWuGongNum] / 100 + 1);
		if (pChar != NULL)
		{
			JY_DrawStr(x1 + 2 +(g_iFontSize+4)*6+15,y1 + 2 + iWuGongNum * g_iFontSize + (g_iFontSize+4)*3,pChar,HUANGCOLOR,0,FALSE,FALSE);
			SafeFree(pChar);
		}
	}
	iWuGongNum++;
	if ( gpGlobals->g.pPersonList[iPerson].WuGong[iWuGongNum] > 0)
	{
		iLen = 0;
		ClearBuf(bufText,20);
		for(int i=0;i<10;i++)
		{
			if (gpGlobals->g.pWuGongList[gpGlobals->g.pPersonList[iPerson].WuGong[iWuGongNum]].Name1[i] == 0)
			{
				bufText[i] =0;
				break;
			}
			bufText[i] = gpGlobals->g.pWuGongList[gpGlobals->g.pPersonList[iPerson].WuGong[iWuGongNum]].Name1[i] ;//^ 0xFF;
			iLen++;
		}
		Big5toUnicode(bufText,iLen);
		pChar = va("%-10s%2d",bufText,gpGlobals->g.pPersonList[iPerson].WuGongDengji[iWuGongNum] / 100 + 1);
		if (pChar != NULL)
		{
			JY_DrawStr(x1 + 2 +(g_iFontSize+4)*6+15,y1 + 2 + iWuGongNum * g_iFontSize + (g_iFontSize+4)*3,pChar,HUANGCOLOR,0,FALSE,FALSE);
			SafeFree(pChar);
		}
	}
	iWuGongNum++;
	if ( gpGlobals->g.pPersonList[iPerson].WuGong[iWuGongNum] > 0)
	{
		iLen = 0;
		ClearBuf(bufText,20);
		for(int i=0;i<10;i++)
		{
			if (gpGlobals->g.pWuGongList[gpGlobals->g.pPersonList[iPerson].WuGong[iWuGongNum]].Name1[i] == 0)
			{
				bufText[i] =0;
				break;
			}
			bufText[i] = gpGlobals->g.pWuGongList[gpGlobals->g.pPersonList[iPerson].WuGong[iWuGongNum]].Name1[i] ;//^ 0xFF;
			iLen++;
		}
		Big5toUnicode(bufText,iLen);
		pChar = va("%-10s%2d",bufText,gpGlobals->g.pPersonList[iPerson].WuGongDengji[iWuGongNum] / 100 + 1);
		if (pChar != NULL)
		{
			JY_DrawStr(x1 + 2 +(g_iFontSize+4)*6+15,y1 + 2 + iWuGongNum * g_iFontSize + (g_iFontSize+4)*3,pChar,HUANGCOLOR,0,FALSE,FALSE);
			SafeFree(pChar);
		}
	}
	pChar = NULL;
}
//绘得到物品
VOID JY_DrawGetThingDialog(short iWuPin, short iNum)
{

	if(iWuPin < 0 || iWuPin > 200)
		return;

	BYTE bufText[20] = {0};
	int iLen = 0;
	for(int i=0;i<20;i++)
	{
		if (gpGlobals->g.pThingsList[iWuPin].name2big5[i] == 0)
		{
			bufText[i] =0;
			break;
		}
		bufText[i] = gpGlobals->g.pThingsList[iWuPin].name2big5[i] ;//^ 0xFF;
		iLen++;
	}
	Big5toUnicode(bufText,iLen);
	char *pChar = va("%s%d",bufText,iNum);
	if (pChar == NULL)
		return;

	int x1 = g_wInitialWidth / 2 - (g_iFontSize/2+1) * strlen(pChar) /2;
	int x2 = g_wInitialWidth / 2 + (g_iFontSize/2+1) * strlen(pChar) /2;
	int y1 = 5;
	int y2 = (g_iFontSize+4)+5;
	
	JY_DrawBox(x1,y1,x2,y2,0);

	JY_DrawStr(x1 + 2,y1 + 2 ,pChar,HUANGCOLOR,0,FALSE,FALSE);
	SafeFree(pChar);
	JY_ShowSurface();	
}
//绘提示信息
short JY_DrawTextDialog(LPCSTR strInfo,JY_POS pos,bool bBk,bool bWaitKey,BOOL bOffset)
{
	int x1 = JY_X(pos);
	int y1 = JY_Y(pos);
	
	if (strInfo == NULL)
		return 0;

	JY_DrawStr(x1 + 2,y1 + 2 ,strInfo,HUANGCOLOR,0,bBk,bOffset);
	JY_ShowSurface();

	bool bExit = FALSE;
	if (bWaitKey == FALSE)
	{
		bExit = TRUE;
	}
	short iRtn = 0;
	while(!bExit)
	{
		SDL_Delay(100);
		JY_ClearKeyState();
		JY_ProcessEvent();
		
		if (g_InputState.dwKeyPress & kKeySearch)
		{
			bExit = TRUE;
			iRtn =1;
		}
		if (g_InputState.dwKeyPress & kKeyMenu)
		{
			bExit = TRUE;
			iRtn =0;
		}
	}
	JY_ClearKeyState();

	return iRtn;
}
//转换颜色
INT JY_GetColor(INT r,INT g,INT b)
{
	return SDL_MapRGB(gpScreenReal->format,r,g,b);
}
//绘内存使用情况
VOID JY_DrawMemUse(VOID)
{
	MEMORYSTATUS   buffer; 
	GlobalMemoryStatus(&buffer);
	JY_FillColor(g_wInitialWidth-60*g_iZoom,5,g_wInitialWidth,21*g_iZoom,0);
	LPSTR pChar = NULL;
	pChar = va("%dKb",buffer.dwAvailPhys/1024);
	JY_DrawStr(g_wInitialWidth-60*g_iZoom,5,pChar,HUANGCOLOR,0,FALSE,FALSE);
	SafeFree(pChar);
}

//反转屏幕
VOID JY_BlitSurfaceRoat(VOID)
{
	int i = 0;
	int j = 0;
	int x = 0;
	int y = 0;
	BYTE *src, *des;

	src = (BYTE *)gpScreen->pixels;
	des = (BYTE *)gpScreenFilp->pixels;
	
	SDL_LockSurface(gpScreenFilp);
	i = 0;
	j = (g_wInitialHeight-1) * g_wInitialWidth;
	for(y=0; y<g_wInitialHeight; ++y)
	{
		for(x=0; x<g_wInitialWidth; ++x)
		{
			*(des+j+g_wInitialWidth-1-x) = *(src+i+x);
		}
		i += g_wInitialWidth;
		j -= g_wInitialWidth;
	}
	SDL_UnlockSurface(gpScreenFilp);
	SDL_BlitSurface(gpScreenFilp,NULL,gpScreenReal,NULL);
	src = NULL;
	des = NULL;
}
//绘传送栏
short JY_DrawTransDilag(short iFristItem,short iCurrentItem,short iEndItem)
{
	JY_ThingDilagBack(4);

	if (iCurrentItem<0 || iCurrentItem >= gpGlobals->g.iSceneTypeListCount)
		return 0;

	int i = 0;
	short iWuPin = -1;
	short iWuPinNum = -1;
	int iLen = 0;
	BYTE bufText[30] = {0};
	char *pChar = NULL;
	int x1 = (g_iFontSize+4)*3+10;
	int y1 = (g_iFontSize+4)*2+25;
	int x2 = (g_iFontSize+4)*3+10 + g_iFontSize*8;
	int y2 = (g_iFontSize+4)*2+25;
	int x = x1;
	int y = y1;
	int iSpit = (g_wInitialHeight - ((g_iFontSize+4)*2+35)) / (g_iFontSize+4);
	int iDrawNum = 0;
	short uscode = -1;

	int xMap = 0;
	int yMap = 0;
	short codeBuid = -1;
	short buildx = -1;
	short buildy = -1;
	xMap = gpGlobals->g.pSceneTypeList[iCurrentItem].MMapInX1;
	yMap = gpGlobals->g.pSceneTypeList[iCurrentItem].MMapInY1;
	buildx = JY_GetMMap(xMap,yMap,3);
	buildy = JY_GetMMap(xMap,yMap,4);
	codeBuid = JY_GetMMap(buildx,buildy,2);
	if (codeBuid >=0)
	{
		JY_LoadPic(0,codeBuid,0,0,1,0);
	}

	for(i=iFristItem;i<iEndItem;i++)
	{
		if (i<0 || i >= gpGlobals->g.iSceneTypeListCount)
			continue;

		ClearBuf(bufText,30);
		for(int j=0;j< 10;j++)
		{
			if (gpGlobals->g.pSceneTypeList[i].Name1[j] == 0)
			{
				bufText[j] =0;
				break;
			}
			bufText[j] = gpGlobals->g.pSceneTypeList[i].Name1[j] ;//^ 0xFF;
			iLen++;
		}
		Big5toUnicode(bufText,iLen);
		pChar = va("%-10s%-3d",bufText,i);//MOD中gpGlobals->g.pSceneTypeList[i].SceneID超过83后变成其他了
		iLen = strlen(pChar);
		if (i == iCurrentItem)
		{
			JY_DrawStr(x,y,pChar,BAICOLOR,0,FALSE,FALSE);
			SafeFree(pChar);
			pChar = va("X=%-3d,Y=%-3d",gpGlobals->g.pSceneTypeList[i].MMapInX1,
				gpGlobals->g.pSceneTypeList[i].MMapInY1);
			JY_DrawStr(g_iFontSize/2*16,(g_iFontSize+4)+8,pChar,BAICOLOR,0,FALSE,FALSE);

		}
		else
		{
			JY_DrawStr(x,y,pChar,HUANGCOLOR,0,FALSE,FALSE);
		}
		
		iDrawNum++;
		if (iDrawNum == iSpit)
		{
			x = x2;
			y = y2;
		}
		else
		{
			y+=(g_iFontSize+4);
		}
	}
	pChar = NULL;
	return iDrawNum + iFristItem;
}