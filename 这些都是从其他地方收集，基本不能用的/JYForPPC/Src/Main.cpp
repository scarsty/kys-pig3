#include "Main.h"

#ifdef _WIN32_WCE
#include <windows.h>
#include <aygshell.h>
#endif

#ifndef GETRAWFRAMEBUFFER
#define GETRAWFRAMEBUFFER   0x00020001
#endif

INT g_iOldRoat = 0;
INT g_iDebug = 0;
INT g_iSuper = 0;
INT g_iFontSize = 16;
INT g_iOftenShowXY = 0;
INT g_iThingPicList = 0;
INT g_iZoom = 1;
char g_cmmap[256]={0};
char g_csmap[256]={0};
char g_cwmap[256]={0};
char g_chdgrp[256]={0};
char g_ceft[256]={0};
char g_cfightidx[256]={0};
char g_cfightgrp[256]={0};
INT g_iFightNum=109;
INT g_iSmapNum=100;
INT g_iDNum=200;
INT g_iMmapXMax=480;
INT g_iMmapYMax=480;
INT g_iSmapXMax=64;
INT g_iSMapYMax=64;
INT g_iWmapXMax=64;
INT g_iWmapYMax=64;

INT g_iHeroImg=2501;
INT g_iThingImg=3501;
INT g_iBoatImg=3715;
INT g_iMoney=174;
INT g_iWarHeroImg=2553;
INT g_iBook=144;
INT g_iBookNum=14;
INT g_iWuLinTie=189;
INT g_iWuLinTieImg=3984;
INT g_iHeroHome=70;
INT g_iHeroStartImg=3445;
INT g_iHeroStartX=19;
INT g_iHeroStartY=20;
INT g_iWuLinTieEventNum=11;
INT g_iWuLinTieEvent=932;
INT g_iBookPutImg=2332;
INT g_iShenZhang=143;
INT g_iGradMax=30;

INT g_ishengmingMax=999;
INT g_ishoushangMax=100;
INT g_izhongduMax=100;
INT g_ineiliMax=999;
INT g_itiliMax=100;
INT g_igongjiliMax=100;
INT g_ifangyuliMax=100;
INT g_iqinggongMax=100;
INT g_iyiliaoMax=100;
INT g_iyongduMax=100;
INT g_ijieduMax=100;
INT g_ikangduMax=100;
INT g_iquanzhangMax=100;
INT g_iyujianMax=100;
INT g_ishuadaoMax=100;
INT g_iteshuMax=100;
INT g_ianqiMax=100;
INT g_iwuxueMax=100;
INT g_ipindeMax=100;
INT g_izizhiMax=100;
INT g_igongjidaiduMax=100;
INT g_ishengwangMax=999;
INT g_iuse50=0;
INT g_iModShouShang=10;
INT g_iModZhongDu=10;
typedef struct _RawFrameBufferInfo
{
	WORD wFormat;
	WORD wBPP;
	VOID *pFramePointer;
	int	cxStride;
	int	cyStride;
	int cxPixels;
	int cyPixels;
} RawFrameBufferInfo;
//取得显示模式
VOID GetSysViewMode(RawFrameBufferInfo* rfbi)
{
	#ifdef _WIN32_WCE
	{
		HDC hdc;
		hdc = GetDC(0);  
		if(hdc)
		{
			ExtEscape(hdc, GETRAWFRAMEBUFFER, 0, 0, sizeof(RawFrameBufferInfo), (char*)rfbi);
			ReleaseDC(0, hdc);
		}
	}
	if (rfbi->cxPixels == 0 || rfbi->cyPixels == 0)
	{
		rfbi->cxPixels = GetSystemMetrics(SM_CXSCREEN);
		rfbi->cyPixels = GetSystemMetrics(SM_CYSCREEN);
	}
	#else 
		rfbi->cxPixels = 320;
		rfbi->cyPixels = 240;
	#endif
}


//反转屏幕
void ChangeScreenRota(int rot)
{
#ifdef _WIN32_WCE
	DEVMODE devmode = {0};
	devmode.dmSize = sizeof(DEVMODE);
	if (rot)
	{
		devmode.dmDisplayOrientation = rot; //水平模式
		devmode.dmFields = DM_DISPLAYORIENTATION;
		ChangeDisplaySettingsEx(NULL, &devmode, NULL, 0, NULL);
	}
	else
	{
		devmode.dmFields = DM_DISPLAYORIENTATION;
		ChangeDisplaySettingsEx(NULL, &devmode, 0, CDS_TEST, NULL);

		if ((g_iOldRoat = devmode.dmDisplayOrientation) != DMDO_0)
		{
			devmode.dmDisplayOrientation = DMDO_0; //水平模式
			devmode.dmFields = DM_DISPLAYORIENTATION;
			ChangeDisplaySettingsEx(NULL, &devmode, NULL, 0, NULL);
		}
	}
#endif
}

//主函数入口
int main(int argc,char *argv[])
{
	//初始化环境
	JY_Init();

	//SDL_WM_SetCaption("JYForPPC", 0);
	
	//初始化缓存
	Init_Cache();
	
	//
	JY_PicInit();

	JY_GameMain();

	JY_Shutdown();
	assert(FALSE);
	return 255;
}
//系统初始化
static VOID JY_Init(VOID)
{

	int e;
	RawFrameBufferInfo rfbi;
	memset(&rfbi, 0, sizeof(rfbi));

	JY_InitConfig();

	ChangeScreenRota(g_iOldRoat);

	//取屏幕分辨率
	WORD wScreenWidth = 0;
	WORD wScreenHeight = 0;
	GetSysViewMode(&rfbi);
	wScreenWidth = rfbi.cxPixels;
	wScreenHeight = rfbi.cyPixels;
	if (wScreenWidth < wScreenHeight)
	   e = wScreenHeight, wScreenHeight = wScreenWidth, wScreenWidth = e;

	//初始化SDL
	if (SDL_Init(SDL_INIT_VIDEO | SDL_INIT_AUDIO) == -1)
	{
		TerminateOnError("初始化SDL失败: %s.\n", SDL_GetError());
	}
	//初始化全局数据
	e = JY_InitGlobals();
	if (e != 0)
	{
		TerminateOnError("初始化全局数据失败\n");
	}
	//初始化显示
	e = JY_VideoInit(wScreenWidth, wScreenHeight, TRUE);
	if (e != 0)
	{
		TerminateOnError("初始化显示失败:%s\n", SDL_GetError());
	}
	//初始化字体
	e = JY_InitFont();
	if (e != 0)
	{
		TerminateOnError("初始化字体失败:%s\n");
	}

	JY_InitInput();
	SOUND_OpenAudio();

	char buf[256] = {0};
	char cFile[256] = {0};
	INT iSound = 1;
	BOOL bRtn = FALSE;
	FILE *fp = NULL;
	sprintf(cFile,"%s/mod.txt",JY_PREFIX);
	fp = fopen(cFile,"rb");

	bRtn = GetIniField(fp, "GAME", "sound", "1", buf);
	if (bRtn)
		iSound = atoi(buf);
	if (iSound == 1)
	{
		g_fNoSound = FALSE;
		g_fNoMusic = FALSE;
	}
	else
	{
		g_fNoSound = TRUE;
		g_fNoMusic = TRUE;
	}
	UTIL_CloseFile(fp);
}
//系统退出
VOID JY_Shutdown(VOID)
{
	JY_PicInit();
	//SOUND_CloseAudio();
	//JY_FreeFont();
	//JY_FreeGlobals();
	//JY_ShutdownInput();
	//JY_VideoShutdown();
	//SDL_Quit();

	atexit(SOUND_CloseAudio);
	atexit(JY_FreeFont);
	atexit(JY_FreeGlobals);
	atexit(JY_ShutdownInput);
	atexit(JY_VideoShutdown);
	atexit(SDL_Quit);

	if (g_iOldRoat == 2)
		ChangeScreenRota(0);
}
static VOID JY_InitConfig(VOID)
{
	char cFile[256] = {0};
	

	sprintf(cFile,"%s/settings.txt",JY_PREFIX);
	////改变屏幕方向
	char buf[256] = {0};
	FILE *fp = NULL;
	fp = fopen(cFile,"rb");
	//GetIniField(fp, "test", "test", "0", buf);

	BOOL bRtn = FALSE;
	bRtn = GetIniField(fp, "VIDEO", "direction", "0", buf);
	if (bRtn)
		g_iOldRoat = atoi(buf);
	UTIL_CloseFile(fp);

	sprintf(cFile,"%s/mod.txt",JY_PREFIX);
	fp = fopen(cFile,"rb");

	ClearBuf((LPBYTE)buf,255);
	bRtn = GetIniField(fp, "GAME", "debug", "0", buf);
	if (bRtn)
		g_iDebug = atoi(buf);

	ClearBuf((LPBYTE)buf,255);
	bRtn = GetIniField(fp, "GAME", "super", "0", buf);
	if (bRtn)
		g_iSuper = atoi(buf);

	ClearBuf((LPBYTE)buf,255);
	bRtn = GetIniField(fp, "GAME", "fontsize", "16", buf);
	if (bRtn)
		g_iFontSize = atoi(buf);
	if (g_iFontSize <= 0)
		g_iFontSize = 16;
	ClearBuf((LPBYTE)buf,255);
	bRtn = GetIniField(fp, "GAME", "oftenshowxy", "1", buf);
	if (bRtn)
		g_iOftenShowXY = atoi(buf);
	ClearBuf((LPBYTE)buf,255);
	bRtn = GetIniField(fp, "GAME", "thingpiclist", "0", buf);
	if (bRtn)
		g_iThingPicList = atoi(buf);
	ClearBuf((LPBYTE)buf,255);
	bRtn = GetIniField(fp, "GAME", "zoom", "1", buf);
	if (bRtn)
		g_iZoom = atoi(buf);
	g_iZoom = limitX(g_iZoom,1,10);
	ClearBuf((LPBYTE)buf,255);
	bRtn = GetIniField(fp, "GAME", "font", "0", buf);
	if (bRtn)
		g_CharSet = atoi(buf);
	ClearBuf((LPBYTE)buf,255);
	bRtn = GetIniField(fp, "GAME", "use50", "0", buf);
	if (bRtn)
		g_iuse50 = atoi(buf);

	ClearBuf((LPBYTE)buf,255);
	bRtn = GetIniField(fp, "CONFIG", "mmap", "mmap", buf);
	strcpy(g_cmmap,buf);
	ClearBuf((LPBYTE)buf,255);
	bRtn = GetIniField(fp, "CONFIG", "smap", "smap", buf);
	strcpy(g_csmap,buf);
	ClearBuf((LPBYTE)buf,255);
	bRtn = GetIniField(fp, "CONFIG", "wmap", "wwap", buf);
	strcpy(g_cwmap,buf);
	ClearBuf((LPBYTE)buf,255);
	bRtn = GetIniField(fp, "CONFIG", "hdgrp", "hdgrp", buf);
	strcpy(g_chdgrp,buf);
	ClearBuf((LPBYTE)buf,255);
	bRtn = GetIniField(fp, "CONFIG", "eft", "eft", buf);
	strcpy(g_ceft,buf);
	ClearBuf((LPBYTE)buf,255);
	bRtn = GetIniField(fp, "CONFIG", "fightidx", "fight\%03d", buf);
	strcpy(g_cfightidx,buf);
	ClearBuf((LPBYTE)buf,255);
	bRtn = GetIniField(fp, "CONFIG", "fightgrp", "fight\%03d", buf);
	strcpy(g_cfightgrp,buf);
	ClearBuf((LPBYTE)buf,255);
	bRtn = GetIniField(fp, "CONFIG", "fightnum", "109", buf);
	if (bRtn)
		g_iFightNum = atoi(buf);

	ClearBuf((LPBYTE)buf,255);
	bRtn = GetIniField(fp, "CONFIG", "mmapxmax", "480", buf);
	if (bRtn)
		g_iMmapXMax = atoi(buf);

	ClearBuf((LPBYTE)buf,255);
	bRtn = GetIniField(fp, "CONFIG", "mmapymax", "480", buf);
	if (bRtn)
		g_iMmapYMax = atoi(buf);
	ClearBuf((LPBYTE)buf,255);
	bRtn = GetIniField(fp, "CONFIG", "smapxmax", "64", buf);
	if (bRtn)
		g_iSmapXMax = atoi(buf);
	ClearBuf((LPBYTE)buf,255);
	bRtn = GetIniField(fp, "CONFIG", "smapxmax", "64", buf);
	if (bRtn)
		g_iSMapYMax = atoi(buf);
	ClearBuf((LPBYTE)buf,255);
	bRtn = GetIniField(fp, "CONFIG", "wmapxmax", "64", buf);
	if (bRtn)
		g_iWmapXMax = atoi(buf);
	ClearBuf((LPBYTE)buf,255);
	bRtn = GetIniField(fp, "CONFIG", "wmapxmax", "64", buf);
	if (bRtn)
		g_iWmapYMax = atoi(buf);
	ClearBuf((LPBYTE)buf,255);
	bRtn = GetIniField(fp, "CONFIG", "smapnum", "100", buf);
	if (bRtn)
		g_iSmapNum = atoi(buf);
	ClearBuf((LPBYTE)buf,255);
	bRtn = GetIniField(fp, "CONFIG", "dnum", "200", buf);
	if (bRtn)
		g_iDNum = atoi(buf);

	ClearBuf((LPBYTE)buf,255);
	bRtn = GetIniField(fp, "CONFIG", "heroimg", "2501", buf);
	if (bRtn)
		g_iHeroImg = atoi(buf);
	ClearBuf((LPBYTE)buf,255);
	bRtn = GetIniField(fp, "CONFIG", "thingimg", "3501", buf);
	if (bRtn)
		g_iThingImg = atoi(buf);
	ClearBuf((LPBYTE)buf,255);
	bRtn = GetIniField(fp, "CONFIG", "boatimg", "3715", buf);
	if (bRtn)
		g_iBoatImg = atoi(buf);
	ClearBuf((LPBYTE)buf,255);
	bRtn = GetIniField(fp, "CONFIG", "money", "174", buf);
	if (bRtn)
		g_iMoney = atoi(buf);
	ClearBuf((LPBYTE)buf,255);
	bRtn = GetIniField(fp, "CONFIG", "warheroimg", "2553", buf);
	if (bRtn)
		g_iWarHeroImg = atoi(buf);
	ClearBuf((LPBYTE)buf,255);
	bRtn = GetIniField(fp, "CONFIG", "book", "144", buf);
	if (bRtn)
		g_iBook = atoi(buf);
	ClearBuf((LPBYTE)buf,255);
	bRtn = GetIniField(fp, "CONFIG", "booknum", "14", buf);
	if (bRtn)
		g_iBookNum = atoi(buf);
	ClearBuf((LPBYTE)buf,255);
	bRtn = GetIniField(fp, "CONFIG", "wulintie", "189", buf);
	if (bRtn)
		g_iWuLinTie = atoi(buf);
	ClearBuf((LPBYTE)buf,255);
	bRtn = GetIniField(fp, "CONFIG", "wulintieimg", "3984", buf);
	if (bRtn)
		g_iWuLinTieImg = atoi(buf);
	ClearBuf((LPBYTE)buf,255);
	bRtn = GetIniField(fp, "CONFIG", "herohome", "70", buf);
	if (bRtn)
		g_iHeroHome = atoi(buf);
	ClearBuf((LPBYTE)buf,255);
	bRtn = GetIniField(fp, "CONFIG", "herostartimg", "3445", buf);
	if (bRtn)
		g_iHeroStartImg = atoi(buf);
	ClearBuf((LPBYTE)buf,255);
	bRtn = GetIniField(fp, "CONFIG", "herostartx", "19", buf);
	if (bRtn)
		g_iHeroStartX = atoi(buf);
	ClearBuf((LPBYTE)buf,255);
	bRtn =GetIniField(fp, "CONFIG", "herostarty", "20", buf);
	if (bRtn)
		g_iHeroStartY = atoi(buf);
	ClearBuf((LPBYTE)buf,255);
	bRtn = GetIniField(fp, "CONFIG", "wulintieeventnum", "11", buf);
	if (bRtn)
		g_iWuLinTieEventNum = atoi(buf);
	ClearBuf((LPBYTE)buf,255);
	bRtn = GetIniField(fp, "CONFIG", "wulintieevent", "932", buf);
	if (bRtn)
		g_iWuLinTieEvent = atoi(buf);
	ClearBuf((LPBYTE)buf,255);
	bRtn = GetIniField(fp, "CONFIG", "bookputimg", "2332", buf);
	if (bRtn)
		g_iBookPutImg = atoi(buf);
	ClearBuf((LPBYTE)buf,255);
	bRtn = GetIniField(fp, "CONFIG", "shenzhang", "143", buf);
	if (bRtn)
		g_iShenZhang = atoi(buf);
	ClearBuf((LPBYTE)buf,255);
	bRtn = GetIniField(fp, "CONFIG", "modshoushang", "10", buf);
	if (bRtn)
		g_iModShouShang = atoi(buf);
	if (g_iModShouShang <= 0)
		g_iModShouShang =1;
	ClearBuf((LPBYTE)buf,255);
	bRtn = GetIniField(fp, "CONFIG", "modzhongdu", "143", buf);
	if (bRtn)
		g_iModZhongDu = atoi(buf);
	if (g_iModZhongDu <= 0)
		g_iModZhongDu =1;


	ClearBuf((LPBYTE)buf,255);
	bRtn = GetIniField(fp, "LEVE", "gradmax", "30", buf);
	if (bRtn)
		g_iGradMax = atoi(buf);

	ClearBuf((LPBYTE)buf,255);
	bRtn = GetIniField(fp, "ATTRIBMAX", "shengming", "999", buf);
	if (bRtn)
		g_ishengmingMax = atoi(buf);
	ClearBuf((LPBYTE)buf,255);
	bRtn = GetIniField(fp, "ATTRIBMAX", "shoushang", "100", buf);
	if (bRtn)
		g_ishoushangMax = atoi(buf);
	ClearBuf((LPBYTE)buf,255);
	bRtn = GetIniField(fp, "ATTRIBMAX", "zhongdu", "100", buf);
	if (bRtn)
		g_izhongduMax = atoi(buf);
	ClearBuf((LPBYTE)buf,255);
	bRtn = GetIniField(fp, "ATTRIBMAX", "neili", "100", buf);
	if (bRtn)
		g_ineiliMax = atoi(buf);
	ClearBuf((LPBYTE)buf,255);
	bRtn = GetIniField(fp, "ATTRIBMAX", "tili", "100", buf);
	if (bRtn)
		g_itiliMax = atoi(buf);
	ClearBuf((LPBYTE)buf,255);
	bRtn = GetIniField(fp, "ATTRIBMAX", "book", "144", buf);
	if (bRtn)
		g_iGradMax = atoi(buf);
	ClearBuf((LPBYTE)buf,255);
	bRtn = GetIniField(fp, "ATTRIBMAX", "gongjili", "100", buf);
	if (bRtn)
		g_igongjiliMax = atoi(buf);
	ClearBuf((LPBYTE)buf,255);
	bRtn = GetIniField(fp, "ATTRIBMAX", "fangyuli", "100", buf);
	if (bRtn)
		g_ifangyuliMax = atoi(buf);
	ClearBuf((LPBYTE)buf,255);
	bRtn = GetIniField(fp, "ATTRIBMAX", "qinggong", "100", buf);
	if (bRtn)
		g_iqinggongMax = atoi(buf);
	ClearBuf((LPBYTE)buf,255);
	bRtn = GetIniField(fp, "ATTRIBMAX", "yiliao", "100", buf);
	if (bRtn)
		g_iyiliaoMax = atoi(buf);
	ClearBuf((LPBYTE)buf,255);
	bRtn = GetIniField(fp, "ATTRIBMAX", "yongdu", "100", buf);
	if (bRtn)
		g_iyongduMax = atoi(buf);
	ClearBuf((LPBYTE)buf,255);
	bRtn = GetIniField(fp, "ATTRIBMAX", "jiedu", "100", buf);
	if (bRtn)
		g_ijieduMax = atoi(buf);
	ClearBuf((LPBYTE)buf,255);
	bRtn = GetIniField(fp, "ATTRIBMAX", "kangdu", "100", buf);
	if (bRtn)
		g_ikangduMax = atoi(buf);
	ClearBuf((LPBYTE)buf,255);
	bRtn = GetIniField(fp, "ATTRIBMAX", "quanzhang", "100", buf);
	if (bRtn)
		g_iquanzhangMax = atoi(buf);
	ClearBuf((LPBYTE)buf,255);
	bRtn = GetIniField(fp, "ATTRIBMAX", "yujian", "100", buf);
	if (bRtn)
		g_iyujianMax = atoi(buf);
	ClearBuf((LPBYTE)buf,255);
	bRtn = GetIniField(fp, "ATTRIBMAX", "shuadao", "100", buf);
	if (bRtn)
		g_ishuadaoMax = atoi(buf);
	ClearBuf((LPBYTE)buf,255);
	bRtn = GetIniField(fp, "ATTRIBMAX", "teshu", "100", buf);
	if (bRtn)
		g_iteshuMax = atoi(buf);
	ClearBuf((LPBYTE)buf,255);
	bRtn = GetIniField(fp, "ATTRIBMAX", "anqi", "100", buf);
	if (bRtn)
		g_ianqiMax = atoi(buf);
	ClearBuf((LPBYTE)buf,255);
	bRtn = GetIniField(fp, "ATTRIBMAX", "wuxue", "100", buf);
	if (bRtn)
		g_iwuxueMax = atoi(buf);
	ClearBuf((LPBYTE)buf,255);
	bRtn = GetIniField(fp, "ATTRIBMAX", "pinde", "100", buf);
	if (bRtn)
		g_ipindeMax = atoi(buf);
	ClearBuf((LPBYTE)buf,255);
	bRtn = GetIniField(fp, "ATTRIBMAX", "zizhi", "100", buf);
	if (bRtn)
		g_izizhiMax = atoi(buf);
	ClearBuf((LPBYTE)buf,255);
	bRtn = GetIniField(fp, "ATTRIBMAX", "gongjidaidu", "100", buf);
	if (bRtn)
		g_igongjidaiduMax = atoi(buf);
	ClearBuf((LPBYTE)buf,255);
	bRtn = GetIniField(fp, "ATTRIBMAX", "shengwang", "999", buf);
	if (bRtn)
		g_ishengwangMax = atoi(buf);

	UTIL_CloseFile(fp);
}