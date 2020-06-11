#ifndef MAIN_H
#define MAIN_H

#include "common.h"
#include "util.h"
#include "List.h"
#include "jycommon.h"
#include "Font.h"
#include "global.h"
#include "scene.h"
#include "Video.h"
#include "PicCache.h"
#include "input.h"
#include "oggplay.h"
#include "Sound.h"
#include "uigame.h"
#include "script.h"
#include "play.h"
#include "game.h"
extern INT g_iOldRoat;
extern INT g_iDebug;
extern INT g_iSuper;
extern INT g_iFontSize;
extern INT g_iOftenShowXY;
extern INT g_iThingPicList;
extern INT g_iZoom;

extern char g_cmmap[256];
extern char g_csmap[256];
extern char g_cwmap[256];
extern char g_chdgrp[256];
extern char g_ceft[256];
extern char g_cfightidx[256];
extern char g_cfightgrp[256];
extern INT g_iFightNum;
extern INT g_iSmapNum;
extern INT g_iDNum;
extern INT g_iMmapXMax;
extern INT g_iMmapYMax;
extern INT g_iSmapXMax;
extern INT g_iSMapYMax;
extern INT g_iWmapXMax;
extern INT g_iWmapYMax;

extern INT g_iHeroImg;
extern INT g_iThingImg;
extern INT g_iBoatImg;
extern INT g_iMoney;
extern INT g_iWarHeroImg;
extern INT g_iBook;
extern INT g_iBookNum;
extern INT g_iWuLinTie;
extern INT g_iWuLinTieImg;
extern INT g_iHeroHome;
extern INT g_iHeroStartImg;
extern INT g_iHeroStartX;
extern INT g_iHeroStartY;
extern INT g_iWuLinTieEventNum;
extern INT g_iWuLinTieEvent;
extern INT g_iBookPutImg;
extern INT g_iShenZhang;
extern INT g_iGradMax;

extern INT g_ishengmingMax;
extern INT g_ishoushangMax;
extern INT g_izhongduMax;
extern INT g_ineiliMax;
extern INT g_itiliMax;
extern INT g_igongjiliMax;
extern INT g_ifangyuliMax;
extern INT g_iqinggongMax;
extern INT g_iyiliaoMax;
extern INT g_iyongduMax;
extern INT g_ijieduMax;
extern INT g_ikangduMax;
extern INT g_iquanzhangMax;
extern INT g_iyujianMax;
extern INT g_ishuadaoMax;
extern INT g_iteshuMax;
extern INT g_ianqiMax;
extern INT g_iwuxueMax;
extern INT g_ipindeMax;
extern INT g_izizhiMax;
extern INT g_igongjidaiduMax;
extern INT g_ishengwangMax;
extern INT g_iuse50;
extern INT g_iModShouShang;
extern INT g_iModZhongDu;
VOID JY_Shutdown(VOID);
static VOID JY_Init();
static VOID JY_InitConfig(VOID);
#endif