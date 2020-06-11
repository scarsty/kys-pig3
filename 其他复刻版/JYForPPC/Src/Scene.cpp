
#include "main.h"



// 取主地图数据 
// flag  0 earth, 1 surface, 2 building, 3 buildx, 4 buildy
short JY_GetMMap(short x, short y , short flag)
{
	INT s=y*g_iMmapXMax+x;
	short v;
	switch(flag)
	{
	case 0:
        v=gpGlobals->g.pEarth[s];
		break;
	case 1:
        v=gpGlobals->g.pSurface[s];
		break;
	case 2:
        v=gpGlobals->g.pBuilding[s];
		break;
	case 3:
        v=gpGlobals->g.pBuildX[s];
		break;
	case 4:
        v=gpGlobals->g.pBuildY[s];
		break;
   }
	return v;

}

// 存主地图数据 
// flag  0 earth, 1 surface, 2 building, 3 buildx, 4 buildy
short JY_SetMMap(short x, short y , short flag, short v)
{
	INT s=y*g_iMmapXMax+x;
 
	switch(flag)
	{
	case 0:
        gpGlobals->g.pEarth[s]=v;
		break;
	case 1:
        gpGlobals->g.pSurface[s]=v;
		break;
	case 2:
        gpGlobals->g.pBuilding[s]=v;
		break;
	case 3:
        gpGlobals->g.pBuildX[s]=v;
		break;
	case 4:
        gpGlobals->g.pBuildY[s]=v;
		break;
   }
	return 0;
}

// 主地图建筑排序 
// x,y 主角坐标
// Mypic 主角贴图编号
short BuildingSort(short x, short y, short Mypic)
{
    INT rangex=g_wInitialWidth/(2*gpGlobals->g.iXScale)/2+1+gpGlobals->g.iMMapAddX;
	INT rangey=g_wInitialHeight/(2*gpGlobals->g.iYScale)/2+1;

	int range=rangex+rangey+gpGlobals->g.iMMapAddY;

	short bak=JY_GetMMap(x,y,2);
	short bakx=JY_GetMMap(x,y,3);
	short baky=JY_GetMMap(x,y,4);
    
	int xmin=limitX(x-range,1,g_iMmapXMax-1);
	int xmax=limitX(x+range,1,g_iMmapXMax-1);
	int ymin=limitX(y-range,1,g_iMmapYMax-1);
	int ymax=limitX(y+range,1,g_iMmapYMax-1);

    int i,j,k,m;
    int dy;
	int repeat=0;
	int p=0;

	BuildingType tmpBuild;

    JY_SetMMap(x,y,2,(short)(Mypic*2));
    JY_SetMMap(x,y,3,x);
    JY_SetMMap(x,y,4,y);

	for(i=xmin;i<=xmax;i++){
		dy=ymin;
		for(j=ymin;j<=ymax;j++){
			int ij3=JY_GetMMap(i,j,3);
			int ij4=JY_GetMMap(i,j,4);
			if( (ij3!=0) && (ij4!=0)){
				repeat=0;
				for(k=0;k<p;k++){
					if((gpGlobals->g.Build[k].x ==ij3) && (gpGlobals->g.Build[k].y==ij4)){
						repeat =1;
						if(k==p-1)
							break;

						for(m=j-1;m>=dy;m--){
							int im3=JY_GetMMap(i,m,3);
							int im4=JY_GetMMap(i,m,4);
							if( (im3!=0) && (im4!=0)){
								if( (im3!=ij3) || (im4!=ij4)){
								    if( (im3!=gpGlobals->g.Build[k].x) || (im4!=gpGlobals->g.Build[k].y)){
										tmpBuild=gpGlobals->g.Build[p-1];
										memmove(&gpGlobals->g.Build[k+1],&gpGlobals->g.Build[k],(p-2-k+1)*sizeof(BuildingType));
										gpGlobals->g.Build[k]=tmpBuild;										 
									}
								}
							}
						}
						dy=j+1;
						break;
					}
				}

				if(repeat==0){
					gpGlobals->g.Build[p].x =ij3;
					gpGlobals->g.Build[p].y =ij4;
					gpGlobals->g.Build[p].num =JY_GetMMap(gpGlobals->g.Build[p].x,gpGlobals->g.Build[p].y,2);
					p++;
				}
			}
		}
	}

    gpGlobals->g.iBuildNumber=p;

    JY_SetMMap(x,y,2,bak);
    JY_SetMMap(x,y,3,bakx);
    JY_SetMMap(x,y,4,baky);   

    return 0;
}
// 绘制主地图
INT JY_DrawMMap(INT x, INT y, INT Mypic)
{
    INT rangex=g_wInitialWidth/(2*gpGlobals->g.iXScale)/2+1+gpGlobals->g.iMMapAddX;
	INT rangey=g_wInitialHeight/(2*gpGlobals->g.iYScale)/2+1;
	INT i,j;
	INT i1,j1;
	INT x1,y1;
    INT picnum;

	JY_FillColor(0,0,0,0,0);

    gpGlobals->g.iBuildNumber=0;
    BuildingSort((short)x, (short)y, (short)Mypic);
  
 	for(j=0;j<=2*2*rangey+gpGlobals->g.iMMapAddY;j++){
	    for(i=-rangex;i<=rangex;i++){
			if(j%2==0){
                i1=i+j/2-rangey;
				j1=-i+j/2-rangey;
			}
			else{
                i1=i+j/2-rangey;
				j1=-i+j/2+1-rangey;
			}
             
            x1=gpGlobals->g.iXScale*(i1-j1)+g_wInitialWidth/2;
			y1=gpGlobals->g.iYScale*(i1+j1)+g_wInitialHeight/2;

			if( ((x+i1)>=0) && ((x+i1)<g_iMmapXMax) && ((y+j1)>=0) && ((y+j1)<g_iMmapYMax) ){
				picnum=JY_GetMMap(x+i1,y+j1,0);
				if(picnum>0)
                    JY_LoadPic(0,picnum,x1,y1,0,0);
				picnum=JY_GetMMap(x+i1,y+j1,1);
				if(picnum>0)
                    JY_LoadPic(0,picnum,x1,y1,0,0);
                     		
			}
		}
	}

	for(i=0;i<gpGlobals->g.iBuildNumber;i++)
	{
        i1=gpGlobals->g.Build[i].x -x;
		j1=gpGlobals->g.Build[i].y -y;
        x1=gpGlobals->g.iXScale*(i1-j1)+g_wInitialWidth/2;
	    y1=gpGlobals->g.iYScale*(i1+j1)+g_wInitialHeight/2;
		picnum=gpGlobals->g.Build[i].num ;
		if(picnum>0)
		{
			JY_LoadPic(0,picnum,x1,y1,0,0);
		}
		//Draw Boat
		if (picnum >= 5002 && picnum <= 5104 )
		{
			i1=gpGlobals->g.pBaseList->BoatX -x;
			j1=gpGlobals->g.pBaseList->BoatY -y;
			x1=gpGlobals->g.iXScale*(i1-j1)+g_wInitialWidth/2;
			y1=gpGlobals->g.iYScale*(i1+j1)+g_wInitialHeight/2;
			if (x1 > 0 && x1 < g_wInitialWidth && y1 >0 && y1 < g_wInitialHeight)
			{
				picnum = g_iBoatImg + gpGlobals->g.pBaseList->BoatWay * 4;
				JY_LoadPic(0,picnum * 2,x1,y1,0,0);
			}
		}
	}
	if (g_iOftenShowXY == 1)
	{
		LPSTR cBuf = NULL;
		cBuf = va("X=%d,Y=%d",gpGlobals->g.pBaseList->WMapX,gpGlobals->g.pBaseList->WMapY);
		JY_DrawStr(5,5,cBuf,HUANGCOLOR,0,TRUE,FALSE);
		SafeFree(cBuf);
	}
     return 0;
}



//大地图循环
VOID JY_Game_MMap(VOID)
{
	INT iDirect = -1;
	INT x = 0;
	INT y = 0;
	if (g_InputState.dwKeyPress & kKeyMenu)
	{
		JY_SystemMenu();
	}
	if (g_InputState.dwKeyPress & kKeySearch)
	{
		return;
	}
	if (g_InputState.dir == kDirNorth)
	{
		iDirect = 0;
	}
	if (g_InputState.dir == kDirSouth)
	{
		iDirect = 3;
	}
	if (g_InputState.dir == kDirEast)
	{
		iDirect = 1;
	}
	if (g_InputState.dir == kDirWest)
	{
		iDirect = 2;
	}
	if (iDirect != -1)
	{
		gpGlobals->g.iMyCurrentPic = gpGlobals->g.iMyCurrentPic + 1;
		x=gpGlobals->g.pBaseList->WMapX + gpGlobals->g.iDirectX[iDirect];
        y=gpGlobals->g.pBaseList->WMapY + gpGlobals->g.iDirectY[iDirect];

		gpGlobals->g.pBaseList->Way = iDirect;
	}
	else
	{
		x=gpGlobals->g.pBaseList->WMapX;
        y=gpGlobals->g.pBaseList->WMapY;
		gpGlobals->g.iMyCurrentPic = 0;
	}

	//
	gpGlobals->g.iSceneNum = JY_CanEnterScene(x,y);
	//
	if (JY_GetMMap(x,y,3) == 0 && JY_GetMMap(x,y,4) == 0)
	{
		short iEarth = -1;
		iEarth = JY_GetMMap(x,y,0);
		if (g_iSuper == 1)
		{
			if ( (iEarth >= 506 && iEarth <= 610 ) || (iEarth >= 640 && iEarth <= 670) ||
				(iEarth >= 358 && iEarth <= 362) ||  iEarth == 614 || iEarth == 934 ||  iEarth == 936 || iEarth == 838 ||
				iEarth == 318 || iEarth == 320 ||  (iEarth >= 1016 && iEarth <= 1022) )
			{
				gpGlobals->g.pBaseList->ChengChuang = 1;
				gpGlobals->g.pBaseList->BoatWay = gpGlobals->g.pBaseList->Way;
				gpGlobals->g.pBaseList->BoatX = x;
				gpGlobals->g.pBaseList->BoatY = y;
				gpGlobals->g.pBaseList->BoatX1 = x + gpGlobals->g.iDirectX[gpGlobals->g.pBaseList->Way];
				gpGlobals->g.pBaseList->BoatY1 = y + gpGlobals->g.iDirectX[gpGlobals->g.pBaseList->Way];
				gpGlobals->g.pBaseList->WMapX = x;
				gpGlobals->g.pBaseList->WMapY = y;
			}
			else
			{
				gpGlobals->g.pBaseList->ChengChuang = 0;
				gpGlobals->g.pBaseList->WMapX = x;
				gpGlobals->g.pBaseList->WMapY = y;
			}
		}
		else
		{
			if ( (iEarth >= 506 && iEarth <= 610 ) || (iEarth >= 640 && iEarth <= 670) ||
				(iEarth >= 358 && iEarth <= 362) ||  iEarth == 614 || iEarth == 838 || iEarth == 934 ||  iEarth == 936 ||
				iEarth == 318 || iEarth == 320 ||  (iEarth >= 1016 && iEarth <= 1022) )
			{
				if (gpGlobals->g.pBaseList->ChengChuang == 0)
				{
					if ( (x == gpGlobals->g.pBaseList->BoatX &&
						  y == gpGlobals->g.pBaseList->BoatY) || 
						 (x == gpGlobals->g.pBaseList->BoatX1 &&
						  y == gpGlobals->g.pBaseList->BoatY1) )
					{
						gpGlobals->g.pBaseList->ChengChuang = 1;
					}
				}
				if (gpGlobals->g.pBaseList->ChengChuang == 1)
				{
					gpGlobals->g.pBaseList->BoatWay = gpGlobals->g.pBaseList->Way;
					gpGlobals->g.pBaseList->BoatX = x;
					gpGlobals->g.pBaseList->BoatY = y;
					gpGlobals->g.pBaseList->BoatX1 = x + gpGlobals->g.iDirectX[gpGlobals->g.pBaseList->Way];
					gpGlobals->g.pBaseList->BoatY1 = y + gpGlobals->g.iDirectX[gpGlobals->g.pBaseList->Way];
					gpGlobals->g.pBaseList->WMapX = x;
					gpGlobals->g.pBaseList->WMapY = y;
				}
			}
			else
			{
				gpGlobals->g.pBaseList->ChengChuang = 0;
				gpGlobals->g.pBaseList->WMapX = x;
				gpGlobals->g.pBaseList->WMapY = y;
			}
		}
	}
	gpGlobals->g.pBaseList->WMapX = limitX(gpGlobals->g.pBaseList->WMapX,10,g_iMmapXMax-10);
	gpGlobals->g.pBaseList->WMapY = limitX(gpGlobals->g.pBaseList->WMapY,10,g_iMmapYMax-10);
	
	JY_DrawMMap(gpGlobals->g.pBaseList->WMapX,gpGlobals->g.pBaseList->WMapY,JY_GetMyPic());
	JY_ShowSurface();

	if (gpGlobals->g.iSceneNum >= 0)
	{
		gpGlobals->g.iSubSceneX = 0;
		gpGlobals->g.iSubSceneY = 0;
		gpGlobals->g.iSceneEventCode = -1;
		gpGlobals->g.Status = 4;
		JY_ShowSlow(1,1);
		JY_PicInit();
		JY_PicLoadFile("\\Resource\\data\\Smap\\Smap",1);
		JY_PicLoadFile("\\Resource\\data\\Hdgrp\\Hdgrp",2);
		if (gpGlobals->g.pSceneTypeList[gpGlobals->g.iSceneNum].InMusic > 0)
		{
			OGG_Play(0, FALSE);
			OGG_Play(gpGlobals->g.pSceneTypeList[gpGlobals->g.iSceneNum].InMusic, TRUE);
		}
		gpGlobals->g.iMyPic=JY_GetMyPic();
		gpGlobals->g.pBaseList->SMapX = gpGlobals->g.pSceneTypeList[gpGlobals->g.iSceneNum].InX;
		gpGlobals->g.pBaseList->SMapY = gpGlobals->g.pSceneTypeList[gpGlobals->g.iSceneNum].InY;
		JY_DrawSMap(gpGlobals->g.pBaseList->SMapX,
			gpGlobals->g.pBaseList->SMapY,
			gpGlobals->g.iSubSceneX,
			gpGlobals->g.iSubSceneY,
			gpGlobals->g.iMyPic);
		JY_DrawSceneName();
		JY_ShowSlow(1,0);
		JY_Delay(1000);
	}

	
}
//取得人物图像
INT JY_GetMyPic(VOID)
{
    INT n;
	if ((gpGlobals->g.Status == 2 || gpGlobals->g.Status == 3) && gpGlobals->g.pBaseList->ChengChuang == 1)
	{
		if (gpGlobals->g.iMyCurrentPic >= 4)
			gpGlobals->g.iMyCurrentPic = 0;
		else
			gpGlobals->g.iMyCurrentPic = 1;
	}
	if (gpGlobals->g.pBaseList->ChengChuang == 0)
	{
		n = g_iHeroImg + gpGlobals->g.pBaseList->Way * 7 + gpGlobals->g.iMyCurrentPic;
	}
	else
	{
		n = g_iBoatImg + gpGlobals->g.pBaseList->Way * 4 + gpGlobals->g.iMyCurrentPic;
	}

	return n;
}
//是否可以进入场景
INT JY_CanEnterScene(INT x,INT y)
{
	INT i = 0;
	INT j = 0;
	for(i =0;i<g_iSmapNum;i++)
	{
		if ( (gpGlobals->g.pSceneTypeList[i].MMapInX1 == x &&
			gpGlobals->g.pSceneTypeList[i].MMapInY1 == y ) ||
			(gpGlobals->g.pSceneTypeList[i].MMapInX2 == x &&
			gpGlobals->g.pSceneTypeList[i].MMapInY2 == y ) )
		{
			if (gpGlobals->g.pSceneTypeList[i].InCondition == 0)
				return i;//gpGlobals->g.pSceneTypeList[i].SceneID
			else if(gpGlobals->g.pSceneTypeList[i].InCondition == 1)
				return -1;
			else if(gpGlobals->g.pSceneTypeList[i].InCondition == 2)
			{
				for(j=0;j<6;j++)
				{
					if (gpGlobals->g.pBaseList->Group[j] != -1)
					{
						if (gpGlobals->g.pPersonList[gpGlobals->g.pBaseList->Group[j]].QingGong >= 70)
						{
							return i;//gpGlobals->g.pSceneTypeList[i].SceneID
						}
					}
				}
			}

		}
	}
	return -1;
}

// 取主地图数据 
// flag  0 earth, 1 surface, 2 building, 3 buildx, 4 buildy
short JY_GetSMap(short id,short x, short y , short level)
{
	if (id < 0 || id >= g_iSmapNum)
		return -1;
	INT s=0;
	s = g_iSmapXMax * g_iSMapYMax * (id * 6 + level) + y * g_iSmapXMax + x;
	return *(gpGlobals->g.pScene + s);
}

// 存主地图数据 
// flag  0 earth, 1 surface, 2 building, 3 buildx, 4 buildy
short JY_SetSMap(short id,short x, short y , short level, short v)
{
	INT s = 0;
	s = g_iSmapXMax * g_iSMapYMax * (id * 6 + level) + y * g_iSmapXMax + x;
	*(gpGlobals->g.pScene + s) = v;	
	return 0;
}
//取D*
short JY_GetD(short Sceneid,short id,short i)
{
    INT s = 0;
    if(Sceneid<0 || Sceneid>=g_iSmapNum){
        TerminateOnError("访问事件内存越界: sceneid=%d !\n",Sceneid);
        return 0;
    }

    s=g_iDNum*11*Sceneid+id*11+i;

	return *(gpGlobals->g.pD+s);
}

//存D*
short JY_SetD(short Sceneid,short id,short i,short v)
{
	INT s = 0;
	if(Sceneid<0 || Sceneid>=g_iSmapNum){
        TerminateOnError("访问事件内存越界: sceneid=%d !\n",Sceneid);
        return 0;
    }

    s=g_iDNum*11*Sceneid+id*11+i;

	*(gpGlobals->g.pD+s)=v;

	return 0;
}
// 绘制场景地图
INT JY_DrawSMap(INT x, INT y,INT xoff,INT yoff, INT Mypic)
{
	int rangex=g_wInitialWidth/(2*gpGlobals->g.iXScale)/2+1+gpGlobals->g.iSMapAddX;
	int rangey=g_wInitialHeight/(2*gpGlobals->g.iYScale)/2+1;
	int i,j;
	int i1,j1;
	int x1,y1;
 
	int xx,yy;

	JY_FillColor(0,0,0,0,0);

	for(j=0;j<=2*2*rangey+gpGlobals->g.iSMapAddY;j++){
	    for(i=-rangex;i<=rangex;i++){
			if(j%2==0){
                i1=i+j/2-rangey;
				j1=-i+j/2-rangey;
			}
			else{
                i1=i+j/2-rangey;
				j1=-i+j/2+1-rangey;
			}
    
            x1=gpGlobals->g.iXScale*(i1-j1)+g_wInitialWidth/2;
			y1=gpGlobals->g.iYScale*(i1+j1)+g_wInitialHeight/2;

			xx=x+i1+xoff;
			yy=y+j1+yoff;

			if( (xx>=0) && (xx<g_iSmapXMax) && (yy>=0) && (yy<g_iSMapYMax) ){
				int d0=JY_GetSMap(gpGlobals->g.iSceneNum,xx,yy,0);
                if(d0>0)
                      JY_LoadPic(1,d0,x1,y1,0,0);             //地面

				int d1=JY_GetSMap(gpGlobals->g.iSceneNum,xx,yy,1);
                int d2=JY_GetSMap(gpGlobals->g.iSceneNum,xx,yy,2);
                int d3=JY_GetSMap(gpGlobals->g.iSceneNum,xx,yy,3);
                int d4=JY_GetSMap(gpGlobals->g.iSceneNum,xx,yy,4);
                int d5=JY_GetSMap(gpGlobals->g.iSceneNum,xx,yy,5);
      
                if(d1>0)
                      JY_LoadPic(1,d1,x1,y1-d4,0,0);           //建筑
			
                if(d2>0)
                      JY_LoadPic(1,d2,x1,y1-d5,0,0);          //空中

				if(d3>=0)
				{           
					// 事件图片
					int picnum=-1;
					int picnum0=JY_GetD(gpGlobals->g.iSceneNum,d3,5);
					int picnum1=JY_GetD(gpGlobals->g.iSceneNum,d3,6);
					int picnum2=JY_GetD(gpGlobals->g.iSceneNum,d3,7);
					if (picnum2<=0)
					{
						picnum=picnum0;
					}
					else
					{
						picnum=picnum2;
					}
					//int picnum=gpGlobals->g.sceneEventList[gpGlobals->g.iSceneNum][d3].PicNum[0];//.PicNum[2];MOD中大部分没有图像//JY_GetD(sceneid,d3,7);
					if(picnum>0)//if(picnum>=0)
					{
                       JY_LoadPic(1,picnum,x1,y1-d4,0,0);
					   if (picnum2 > 0)
					   {
						   picnum++;
						   JY_SetD(gpGlobals->g.iSceneNum,d3,7,picnum);
						   if (picnum > picnum1)
						   {
								JY_SetD(gpGlobals->g.iSceneNum,d3,7,picnum0);
						   }
						//gpGlobals->g.sceneEventList[gpGlobals->g.iSceneNum][d3].PicNum[2]++;
						//if (gpGlobals->g.sceneEventList[gpGlobals->g.iSceneNum][d3].PicNum[2] > 
						//	gpGlobals->g.sceneEventList[gpGlobals->g.iSceneNum][d3].PicNum[1])
						//	gpGlobals->g.sceneEventList[gpGlobals->g.iSceneNum][d3].PicNum[2] =
						//	gpGlobals->g.sceneEventList[gpGlobals->g.iSceneNum][d3].PicNum[0];
					   }
					}
				}
				
				if (Mypic > 0)
				{
					if( (i1==-xoff) && (j1==-yoff) )
					{  //主角
					   JY_LoadPic(1,Mypic*2,x1,y1-d4,0,0);
					}
				}

			}
		}
	}
	if (g_iOftenShowXY == 1)
	{
		LPSTR cBuf = NULL;
		cBuf = va("X=%d,Y=%d",gpGlobals->g.pBaseList->SMapX,gpGlobals->g.pBaseList->SMapY);
		JY_DrawStr(5,5,cBuf,HUANGCOLOR,0,TRUE,FALSE);
		SafeFree(cBuf);
	}
	return 0;
}
//内场景循环
VOID JY_Game_SMap(VOID)
{
	short iScode = -1;
	short iScriptEntry = -1;
	iScode = JY_GetSMap(gpGlobals->g.iSceneNum,gpGlobals->g.pBaseList->SMapX,gpGlobals->g.pBaseList->SMapY,3);
	if ( iScode >= 0)
	{
		if (iScode != gpGlobals->g.iSceneEventCode)
		{
			gpGlobals->g.iSceneEventCode = iScode;
			iScriptEntry = JY_GetD(gpGlobals->g.iSceneNum,iScode,4);
			//iScriptEntry = gpGlobals->g.sceneEventList[gpGlobals->g.iSceneNum][iScode].EventNum3;
			JY_RunTriggerScript(iScriptEntry,-1);
			gpGlobals->g.iSceneEventCode = -1;
		}
	}

	if ( (gpGlobals->g.pSceneTypeList[gpGlobals->g.iSceneNum].OutX[0] == gpGlobals->g.pBaseList->SMapX &&
			gpGlobals->g.pSceneTypeList[gpGlobals->g.iSceneNum].OutY[0] == gpGlobals->g.pBaseList->SMapY) ||
			(gpGlobals->g.pSceneTypeList[gpGlobals->g.iSceneNum].OutX[1] == gpGlobals->g.pBaseList->SMapX &&
			gpGlobals->g.pSceneTypeList[gpGlobals->g.iSceneNum].OutY[1] == gpGlobals->g.pBaseList->SMapY) ||
			(gpGlobals->g.pSceneTypeList[gpGlobals->g.iSceneNum].OutX[2] == gpGlobals->g.pBaseList->SMapX &&
			gpGlobals->g.pSceneTypeList[gpGlobals->g.iSceneNum].OutY[2] == gpGlobals->g.pBaseList->SMapY) )
	{
		gpGlobals->g.Status = 4;		
		if (gpGlobals->g.pSceneTypeList[gpGlobals->g.iSceneNum].OutMusic > 0)
		{
			OGG_Play(0, FALSE);
			OGG_Play(gpGlobals->g.pSceneTypeList[gpGlobals->g.iSceneNum].OutMusic, TRUE);
		}
		gpGlobals->g.iSceneNum = -1;
		JY_PicInit();
		JY_LoadMMap();
		JY_PicLoadFile("\\Resource\\data\\Mmap\\Mmap",0);
		JY_PicLoadFile("\\Resource\\data\\Hdgrp\\Hdgrp",2);
		gpGlobals->g.Status = 3;
		JY_ShowSlow(1,1);
		JY_DrawMMap(gpGlobals->g.pBaseList->WMapX,
			gpGlobals->g.pBaseList->WMapY,
			JY_GetMyPic());
		JY_ShowSlow(1,0);
		return;
	}
	if (gpGlobals->g.pSceneTypeList[gpGlobals->g.iSceneNum].JumpScene >= 0)
	{
		if (gpGlobals->g.pBaseList->SMapX == gpGlobals->g.pSceneTypeList[gpGlobals->g.iSceneNum].JumpX1 &&
			gpGlobals->g.pBaseList->SMapY == gpGlobals->g.pSceneTypeList[gpGlobals->g.iSceneNum].JumpY1)
		{
			gpGlobals->g.iSceneNum = gpGlobals->g.pSceneTypeList[gpGlobals->g.iSceneNum].JumpScene;
			JY_ShowSlow(1,1);
			if (gpGlobals->g.pSceneTypeList[gpGlobals->g.iSceneNum].OutMusic > 0)
			{
				OGG_Play(0, FALSE);
				OGG_Play(gpGlobals->g.pSceneTypeList[gpGlobals->g.iSceneNum].InMusic, TRUE);
			}
			gpGlobals->g.pBaseList->SMapX = gpGlobals->g.pSceneTypeList[gpGlobals->g.iSceneNum].JumpX1;
			gpGlobals->g.pBaseList->SMapY = gpGlobals->g.pSceneTypeList[gpGlobals->g.iSceneNum].JumpY1;
			if (gpGlobals->g.pSceneTypeList[gpGlobals->g.iSceneNum].MMapInX1 == 0 &&
				gpGlobals->g.pSceneTypeList[gpGlobals->g.iSceneNum].MMapInY1 == 0)
			{
				gpGlobals->g.pBaseList->SMapX = gpGlobals->g.pSceneTypeList[gpGlobals->g.iSceneNum].InX;
				gpGlobals->g.pBaseList->SMapY = gpGlobals->g.pSceneTypeList[gpGlobals->g.iSceneNum].InY;
				
			}
			else
			{
				gpGlobals->g.pBaseList->SMapX = gpGlobals->g.pSceneTypeList[gpGlobals->g.iSceneNum].JumpX2;
				gpGlobals->g.pBaseList->SMapY = gpGlobals->g.pSceneTypeList[gpGlobals->g.iSceneNum].JumpY2;
			}
			gpGlobals->g.iSubSceneX = 0;
			gpGlobals->g.iSubSceneY = 0;
			gpGlobals->g.iSceneEventCode = -1;
			JY_DrawSMap(gpGlobals->g.pBaseList->SMapX,
				gpGlobals->g.pBaseList->SMapY,
				gpGlobals->g.iSubSceneX,
				gpGlobals->g.iSubSceneY,
				gpGlobals->g.iMyPic);
			JY_DrawSceneName();
			JY_ShowSlow(1,0);
			JY_Delay(1000);
			return;
		}
	}
	INT iDirect = -1;
	INT x = 0;
	INT y = 0;
	if (g_InputState.dwKeyPress & kKeyMenu)
	{
		JY_SystemMenu();
	}	
	if (g_InputState.dwKeyPress & kKeySearch)
	{
		int x = gpGlobals->g.pBaseList->SMapX;
		int y = gpGlobals->g.pBaseList->SMapY;		
		int xTarget = x + gpGlobals->g.iDirectX[gpGlobals->g.pBaseList->Way];
		int yTarget = y + gpGlobals->g.iDirectY[gpGlobals->g.pBaseList->Way];

		iScode = JY_GetSMap(gpGlobals->g.iSceneNum,xTarget,yTarget,3);
		if ( iScode >= 0)
		{
			if (iScode != gpGlobals->g.iSceneEventCode)
			{
				gpGlobals->g.iSceneEventCode = iScode;
				iScriptEntry = JY_GetD(gpGlobals->g.iSceneNum,iScode,2);
				//iScriptEntry = gpGlobals->g.sceneEventList[gpGlobals->g.iSceneNum][iScode].EventNum1;
				JY_RunTriggerScript(iScriptEntry,-1);
				gpGlobals->g.iSceneEventCode = -1;
			}
		}
		return;
	}
	if (g_InputState.dir == kDirNorth)
	{
		iDirect = 0;
	}
	if (g_InputState.dir == kDirSouth)
	{
		iDirect = 3;
	}
	if (g_InputState.dir == kDirEast)
	{
		iDirect = 1;
	}
	if (g_InputState.dir == kDirWest)
	{
		iDirect = 2;
	}
	if (iDirect != -1)
	{
		gpGlobals->g.iMyCurrentPic = gpGlobals->g.iMyCurrentPic + 1;
		x=gpGlobals->g.pBaseList->SMapX + gpGlobals->g.iDirectX[iDirect];
        y=gpGlobals->g.pBaseList->SMapY + gpGlobals->g.iDirectY[iDirect];

		gpGlobals->g.pBaseList->Way = iDirect;
	}
	else
	{
		x=gpGlobals->g.pBaseList->SMapX;
        y=gpGlobals->g.pBaseList->SMapY;
		gpGlobals->g.iMyCurrentPic = 0;
	}
	if (JY_SceneCanPass(x,y))
	{
		gpGlobals->g.pBaseList->SMapX = x;
		gpGlobals->g.pBaseList->SMapY = y;
	}

	gpGlobals->g.pBaseList->SMapX = limitX(gpGlobals->g.pBaseList->SMapX,1,g_iSmapXMax-2);
	gpGlobals->g.pBaseList->SMapY = limitX(gpGlobals->g.pBaseList->SMapY,1,g_iSMapYMax-2);
	
	gpGlobals->g.iMyPic = JY_GetMyPic();
	JY_DrawSMap(gpGlobals->g.pBaseList->SMapX,
			gpGlobals->g.pBaseList->SMapY,
			gpGlobals->g.iSubSceneX,
			gpGlobals->g.iSubSceneY,
			gpGlobals->g.iMyPic);
	JY_ShowSurface();
	
}
//内场景是否可以通过
INT JY_SceneCanPass(INT x,INT y)
{
	short picnum = -1;

	picnum = JY_GetSMap(gpGlobals->g.iSceneNum,x,y,1);
	if (picnum > 0)
		return 0;

	picnum = JY_GetSMap(gpGlobals->g.iSceneNum,x,y,3);
	if (picnum >= 0)
	{
		if (JY_GetD(gpGlobals->g.iSceneNum,picnum,0) != 0)//if (gpGlobals->g.sceneEventList[gpGlobals->g.iSceneNum][picnum].isGo != 0)
			return 0;
	}
	short iEarth = -1;
	iEarth = JY_GetSMap(gpGlobals->g.iSceneNum,x,y,0);
	if (iEarth == 260 || iEarth == 261 || iEarth == 179 ||
			iEarth == 419 || iEarth == 358 )
	{
		return 0;
	}

	if (gpGlobals->g.iSceneNum == 21)//黑龙潭
	{
		if (iEarth >= 1324 && iEarth <= 1348)
			return 0;
	}

	return 1;
}

//系统菜单
VOID JY_SystemMenu(VOID)
{
	short          wItemSelected    = 0;
	short          wDefaultItem     = 0;
	
	MENUITEM      rgMainMenuItem1[7] = {
	  {  0,      MAINMENU_LABEL_YILIAO,"医疗",   TRUE,     JY_XY(5, 30) },
	  {  1,      MAINMENU_LABEL_JIEDU,"解毒",   TRUE,     JY_XY(5, (g_iFontSize + 4) + 30) },
	  {  2,      MAINMENU_LABEL_WUPIN, "物品",  TRUE,     JY_XY(5, (g_iFontSize + 4)*2 + 30) },
	  {  3,      MAINMENU_LABEL_ZHUANGTAI,"状态",    TRUE,     JY_XY(5, (g_iFontSize + 4)*3 + 30) },
	  {  4,      MAINMENU_LABEL_LIDUI, "离队",  TRUE,     JY_XY(5, (g_iFontSize + 4)*4 + 30) },
	  {  5,      MAINMENU_LABEL_GO, "传送",  TRUE,     JY_XY(5, (g_iFontSize + 4)*5 + 30) },
	  {  6,      MAINMENU_LABEL_XITONG, "系统",  TRUE,     JY_XY(5, (g_iFontSize + 4)*6 + 30) },
	};

	if (g_iSuper == 0)
		rgMainMenuItem1[5].fEnabled = FALSE;
	MENUITEM      rgMainMenuItem0[4] = {
	  {  0,      MAINMENU_LABEL_YILIAO, "医疗",   TRUE,     JY_XY(5, 30) },
	  {  1,      MAINMENU_LABEL_JIEDU,"解毒",   TRUE,     JY_XY(5, (g_iFontSize + 4) + 30) },
	  {  2,      MAINMENU_LABEL_WUPIN, "物品",  TRUE,     JY_XY(5, (g_iFontSize + 4)*2 + 30) },
	  {  3,      MAINMENU_LABEL_ZHUANGTAI, "状态",   TRUE,     JY_XY(5, (g_iFontSize + 4)*3 + 30) },
	};

	MENUITEM      rgMainMenuItem2[9] = {
	  {  0,      MAINMENU_LABEL_SAVE1,"保存进度一",   TRUE,     JY_XY(5, 30) },
	  {  1,      MAINMENU_LABEL_SAVE2,"保存进度二",  TRUE,     JY_XY(5, (g_iFontSize + 4) + 30) },
	  {  2,      MAINMENU_LABEL_SAVE3,"保存进度三",  TRUE,     JY_XY(5, (g_iFontSize + 4)*2 + 30) },
	  {  3,      MAINMENU_LABEL_LOAD1,"读取进度一",   TRUE,     JY_XY(5, (g_iFontSize + 4)*3 + 30) },
	  {  4,      MAINMENU_LABEL_LOAD2,"读取进度二",  TRUE,     JY_XY(5, (g_iFontSize + 4)*4 + 30) },
	  {  5,      MAINMENU_LABEL_LOAD3,"读取进度三",  TRUE,     JY_XY(5, (g_iFontSize + 4)*5 + 30) },
	  {  6,      MAINMENU_LABEL_SOUND,"声音:开",   TRUE,     JY_XY(5, (g_iFontSize + 4)*6 + 30) },
	  {  7,      MAINMENU_LABEL_MUSIC,"声音:关",  TRUE,     JY_XY(5, (g_iFontSize + 4)*7 + 30) },
	  {  8,      MAINMENU_LABEL_EXIT,"系统退出",  TRUE,     JY_XY(5, (g_iFontSize + 4)*8 + 30) },
	};

	LPMENUITEM pMenu = NULL;
	INT iMenuNum = 0;
	
	if (gpGlobals->g.Status == 2 || gpGlobals->g.Status == 3)
	{
		pMenu = rgMainMenuItem1;
		iMenuNum = 7;
		wItemSelected = gpGlobals->g.iLastUseSystemNum;
	}
	if (gpGlobals->g.Status == 1 || gpGlobals->g.Status == 4)
	{
		pMenu = rgMainMenuItem0;
		iMenuNum = 4;
		wItemSelected = gpGlobals->g.iLastUseSystemNum;
	}
	wItemSelected = limitX(wItemSelected,0,iMenuNum-1);
	INT r = -1;

	JY_VideoBackupScreen(1);
	while (TRUE)
	{
		wItemSelected = JY_ShowMenu(pMenu,NULL, iMenuNum, wItemSelected, TRUE,TRUE,HUANGCOLOR,BAICOLOR);
		if (wItemSelected == -1)
		{
			break;
		}
		gpGlobals->g.iLastUseSystemNum = wItemSelected;
		if (wItemSelected == 0)
		{
			JY_YiLiaoJieDuDilag(1);
			JY_VideoRestoreScreen(1);
		}
		if (wItemSelected == 1)
		{
			JY_YiLiaoJieDuDilag(2);
			JY_VideoRestoreScreen(1);
		}
		if (wItemSelected == 2)
		{
			r = JY_ThingDilag();
			JY_VideoRestoreScreen(1);
			if (r == -1)
				break;
		}
		if (wItemSelected == 3)
		{
			JY_PresonStatusDilag();	
			JY_VideoRestoreScreen(1);
		}
		if (wItemSelected == 4)
		{
			JY_VideoRestoreScreen(1);
			JY_VideoBackupScreen(2);
			r = JY_PresonListDilag(2);
			if (r > 0)
			{
				if (JY_DrawTextDialog("确定离开",JY_XY((g_iFontSize + 4)*3+7,(g_iFontSize + 4)+10),TRUE,TRUE,FALSE) == 1)
				{
					JY_VideoRestoreScreen(1);
					JY_PersonExit(gpGlobals->g.pBaseList->Group[r]);
					break;
				}
			}
			JY_VideoRestoreScreen(1);
		}
		if (wItemSelected == 5)
		{
			if ( gpGlobals->g.pPersonList[0].hp <=20 || 
				gpGlobals->g.pPersonList[0].Neili <=20 ||
				gpGlobals->g.pPersonList[0].Tili <=20)
			{
				JY_VideoRestoreScreen(1);
				JY_DrawStr(g_wInitialWidth/2,(g_iFontSize + 4)+10,"身子骨撑不住呀...",HUANGCOLOR,0,FALSE,TRUE);
				JY_ShowSurface();
				JY_Delay(1000);
				JY_VideoRestoreScreen(1);
			}
			else
			{
				r = JY_TransMap();
				if (r>=0)
				{
					short dis = abs(gpGlobals->g.pBaseList->WMapX - JY_X(r)) +
								abs(gpGlobals->g.pBaseList->WMapY - JY_Y(r));
					if (dis <= 0)
						dis = 1;
					gpGlobals->g.pBaseList->WMapX = JY_X(r);//gpGlobals->g.pSceneTypeList[r].MMapInX1;
					gpGlobals->g.pBaseList->WMapY = JY_Y(r);//gpGlobals->g.pSceneTypeList[r].MMapInY1;
					JY_ShowSlow(1,1);
					JY_ReDrawMap();
					JY_ShowSlow(1,0);
					srand((unsigned)SDL_GetTicks());
					short it = rand() %3;
					short ir = rand() %dis;
					float is = (float)ir/960;
					short id = 0;
					LPSTR pChar = NULL;
					if (it == 0)
					{
						id = gpGlobals->g.pPersonList[0].hp * is;
						JY_SetPersonStatus(enum_hp,0,-id,FALSE);
						if (gpGlobals->g.pPersonList[0].hp <= 0)
							gpGlobals->g.pPersonList[0].hp = 1;
						pChar = va("生命流失%d点",id);
						JY_DrawStr(g_wInitialWidth/2-(g_iFontSize + 4)*3,(g_iFontSize + 4)+10,pChar,HUANGCOLOR,0,FALSE,FALSE);
						JY_ShowSurface();
					}
					if (it == 1)
					{
						id = gpGlobals->g.pPersonList[0].Neili * is;
						JY_SetPersonStatus(enum_Neili,0,-id,FALSE);
						if (gpGlobals->g.pPersonList[0].Neili <= 0)
							gpGlobals->g.pPersonList[0].Neili = 1;
						pChar = va("内力流失%d点",id);
						JY_DrawStr(g_wInitialWidth/2-(g_iFontSize + 4)*3,(g_iFontSize + 4)+10,pChar,HUANGCOLOR,0,FALSE,FALSE);
						JY_ShowSurface();
					}
					if (it == 2)
					{
						id = gpGlobals->g.pPersonList[0].Tili * is;
						JY_SetPersonStatus(enum_Tili,0,-id,FALSE);
						if (gpGlobals->g.pPersonList[0].Tili <= 0)
							gpGlobals->g.pPersonList[0].Tili = 1;
						pChar = va("体力流失%d点",id);
						JY_DrawStr(g_wInitialWidth/2-(g_iFontSize + 4)*3,(g_iFontSize + 4)+10,pChar,HUANGCOLOR,0,FALSE,FALSE);
						JY_ShowSurface();
					}
					SafeFree(pChar);
					JY_Delay(1000);
					break;
				}
				else
				{
					JY_VideoRestoreScreen(1);
				}
			}
		}
		if (wItemSelected == 6)
		{
			JY_VideoRestoreScreen(1);
			pMenu = rgMainMenuItem2;
			iMenuNum = 9;
			wItemSelected = JY_ShowMenu(pMenu,NULL, iMenuNum, wDefaultItem, TRUE,TRUE,HUANGCOLOR,BAICOLOR);	
			if (wItemSelected == -1)
			{
				if (gpGlobals->g.Status == 2 || gpGlobals->g.Status == 3)
				{
					pMenu = rgMainMenuItem1;
					iMenuNum = 7;
				}
				if (gpGlobals->g.Status == 1 || gpGlobals->g.Status == 4)
				{
					pMenu = rgMainMenuItem0;
					iMenuNum = 4;
				}
			}
			if (wItemSelected == 0)
			{
				gpGlobals->fGameSave = TRUE;
				gpGlobals->bCurrentSaveSlot = 1;
				JY_DrawStr((g_iFontSize + 4)*4+13,(g_iFontSize + 4)+10,"请稍候...",HUANGCOLOR,0,FALSE,FALSE);
				JY_ShowSurface();
				break;
			}
			if (wItemSelected == 1)
			{
				gpGlobals->fGameSave = TRUE;
				gpGlobals->bCurrentSaveSlot = 2;
				JY_DrawStr((g_iFontSize + 4)*4+13,(g_iFontSize + 4)+10,"请稍候...",HUANGCOLOR,0,FALSE,FALSE);
				JY_ShowSurface();
				break;
			}
			if (wItemSelected == 2)
			{
				gpGlobals->fGameSave = TRUE;
				gpGlobals->bCurrentSaveSlot = 3;
				JY_DrawStr((g_iFontSize + 4)*4+13,(g_iFontSize + 4)+10,"请稍候...",HUANGCOLOR,0,FALSE,FALSE);
				JY_ShowSurface();
				break;
			}
			if (wItemSelected == 3)
			{
				gpGlobals->fGameLoad = TRUE;
				gpGlobals->bCurrentSaveSlot = 1;
				JY_DrawStr((g_iFontSize + 4)*4+13,(g_iFontSize + 4)+10,"请稍候...",HUANGCOLOR,0,FALSE,FALSE);
				JY_ShowSurface();
				break;
			}
			if (wItemSelected == 4)
			{
				gpGlobals->fGameLoad = TRUE;
				gpGlobals->bCurrentSaveSlot = 2;
				JY_DrawStr((g_iFontSize + 4)*4+13,(g_iFontSize + 4)+10,"请稍候...",HUANGCOLOR,0,FALSE,FALSE);
				JY_ShowSurface();
				break;
			}
			if (wItemSelected == 5)
			{
				gpGlobals->fGameLoad = TRUE;
				gpGlobals->bCurrentSaveSlot = 3;
				JY_DrawStr((g_iFontSize + 4)*4+13,(g_iFontSize + 4)+10,"请稍候...",HUANGCOLOR,0,FALSE,FALSE);
				JY_ShowSurface();
				break;
			}
			if (wItemSelected == 6)
			{
				g_fNoSound = FALSE;
				g_fNoMusic = FALSE;
				break;
			}
			if (wItemSelected == 7)
			{
				g_fNoSound = TRUE;
				g_fNoMusic = TRUE;
				break;
			}
			if (wItemSelected == 8)
			{
				gpGlobals->fGameStart = FALSE;
				break;
			}
			JY_VideoRestoreScreen(1);
			wItemSelected = 6;
		}
	}
}
//重绘屏幕
VOID JY_ReDrawMap(VOID)
{
	if (gpGlobals->g.Status == 1 || gpGlobals->g.Status == 4)
	{
		JY_DrawSMap(gpGlobals->g.pBaseList->SMapX,
			gpGlobals->g.pBaseList->SMapY,
			gpGlobals->g.iSubSceneX,
			gpGlobals->g.iSubSceneY,
			gpGlobals->g.iMyPic);
	}
	if (gpGlobals->g.Status == 2 || gpGlobals->g.Status == 3)
	{
		JY_DrawMMap(gpGlobals->g.pBaseList->WMapX,
			gpGlobals->g.pBaseList->WMapY,
			JY_GetMyPic());
		
	}
	if (gpGlobals->g.Status == 5)
	{
		WarDrawMap(0,0,0);
	}
}
//显示对话
VOID JY_DrawTalkDialog(short iTalkNum,short iHeadImgNum, short iFlag)
{
	INT iRtn = -1;
	INT iLen = 0;
	INT iLenW = 0;
	INT uiSize = 0;
	INT uiAddress = 0;
	LPBYTE bufText = NULL;
	INT x = 0;
	INT y = 0;
	iRtn = JY_IDXGetChunkBaseInfo(iTalkNum,gpGlobals->f.fpTalkIdx,&uiSize,&uiAddress);
	if (iRtn == -1)
	{
		return;
	}
	if (uiSize <= 0)
	{
		return;
	}
	bufText = (LPBYTE)malloc(uiSize);
	if (bufText == NULL)
	{
		return;
	}
	iRtn = JY_GRPReadChunk(bufText,uiSize,uiAddress,gpGlobals->f.fpTalkGrp);
	if (iRtn == -1)
	{
		return ;
	}
	for(int i=0;i<uiSize;i++)
	{
		bufText[i] = bufText[i] ^ 0xFF;
	}
	//--
	Big5toUnicode(bufText,uiSize);
	//--
	char *bufTextSplit = NULL;

	JY_DrawTalkDialogBak(iHeadImgNum,iFlag);
	
	INT color = BAICOLOR;

	bool bExit = false;

	if (iFlag % 2 == 0)
	{
		x = 10;
		y = 10;
	}
	else
	{
		x = 10;		
		y = g_wInitialHeight - (g_iFontSize + 4)*4 +5;//g_wInitialHeight/2+(g_iFontSize + 4);
	}

	bufTextSplit = strtok((char*)bufText,"*");
	if (bufTextSplit != NULL)
	{
		JY_DrawStr(x,y,bufTextSplit,color,0,FALSE,FALSE);
	}	
	bufTextSplit = strtok(NULL,"*");
	if (bufTextSplit != NULL)
	{
		JY_DrawStr(x,y+(g_iFontSize + 4),bufTextSplit,color,0,FALSE,FALSE);
	}

	bufTextSplit = strtok(NULL,"*");
	if (bufTextSplit != NULL)
	{
		JY_DrawStr(x,y+(g_iFontSize + 4)*2,bufTextSplit,color,0,FALSE,FALSE);
	}
	bufTextSplit = strtok(NULL,"*");

	JY_ShowSurface();
	while(!bExit)
	{
		SDL_Delay(100);
		JY_ClearKeyState();
		JY_ProcessEvent();
		
		if (g_InputState.dwKeyPress & kKeySearch)
		{
			
			if (bufTextSplit == NULL)
			{
				bExit = TRUE;
			}
			else
			{				
				JY_ReDrawMap();
				JY_DrawTalkDialogBak(iHeadImgNum,iFlag);
				if (iFlag % 2 == 0)
				{
					x = 10;
					y = 10;
				}
				else
				{
					x = 10;		
					y = g_wInitialHeight - (g_iFontSize + 4)*4 +5;//g_wInitialHeight/2+(g_iFontSize + 4);
				}
				if (bufTextSplit != NULL)
				{
					JY_DrawStr(x,y,bufTextSplit,color,0,FALSE,FALSE);
				}

				bufTextSplit = strtok(NULL,"*");
				if (bufTextSplit != NULL)
				{
					JY_DrawStr(x,y+(g_iFontSize + 4),bufTextSplit,color,0,FALSE,FALSE);
				}
				bufTextSplit = strtok(NULL,"*");
				if (bufTextSplit != NULL)
				{
					JY_DrawStr(x,y+(g_iFontSize + 4)*2,bufTextSplit,color,0,FALSE,FALSE);
				}
				bufTextSplit = strtok(NULL,"*");

				JY_ShowSurface();

			}
		}
	}
	SafeFree(bufTextSplit);
	SafeFree(bufText);

}
//医疗解毒菜单
short JY_YiLiaoJieDuDilag(short iType)
{
	bool bExit = false;
	short iCurrentItem = 0;	
	short iDrawNum = -1;
	short iSelectPersonIdx = -1;
	short iTemp = 0;
	BOOL bCanUse = TRUE;
	JY_VideoRestoreScreen(1);
	iDrawNum =JY_DrawPersonYLJDDilag(iCurrentItem,iType);
	JY_DrawPersonListDilag(-1,0);
	JY_ShowSurface();
	while(!bExit)
	{
		JY_ClearKeyState();
		JY_ProcessEvent();		
		if (g_InputState.dwKeyPress & (kKeyDown | kKeyRight))//if (g_InputState.dir == kDirSouth || g_InputState.dir == kDirEast)//
		{
			iCurrentItem++;
			if (iCurrentItem >= iDrawNum )		
			{
				iCurrentItem = 0;
			}
			JY_VideoRestoreScreen(1);
			iDrawNum =JY_DrawPersonYLJDDilag(iCurrentItem,iType);
			JY_DrawPersonListDilag(-1,0);
			JY_ShowSurface();
		}
		else if (g_InputState.dwKeyPress & (kKeyUp | kKeyLeft))//else if (g_InputState.dir == kDirNorth || g_InputState.dir == kDirWest)//
		{		
			iCurrentItem--;
			if (iCurrentItem < 0)
			{
				iCurrentItem = iDrawNum-1;				
			}			
			JY_VideoRestoreScreen(1);
			iDrawNum =JY_DrawPersonYLJDDilag(iCurrentItem,iType);
			JY_DrawPersonListDilag(-1,0);
			JY_ShowSurface();
		}
		else if (g_InputState.dwKeyPress & kKeySearch)
		{
			if (iType == 1)
			{
				if (gpGlobals->g.pPersonList[gpGlobals->g.pBaseList->Group[iCurrentItem]].YiLiao < 20 
					|| gpGlobals->g.pPersonList[gpGlobals->g.pBaseList->Group[iCurrentItem]].Tili < 50)
					bCanUse = FALSE;
				else
					bCanUse = TRUE;
			}
			else
			{
				if (gpGlobals->g.pPersonList[gpGlobals->g.pBaseList->Group[iCurrentItem]].JieDu < 20 
					|| gpGlobals->g.pPersonList[gpGlobals->g.pBaseList->Group[iCurrentItem]].Tili < 50)
					bCanUse = FALSE;
				else
					bCanUse = TRUE;
			}
			if (bCanUse)
			{
				JY_VideoBackupScreen(2);
				iSelectPersonIdx = JY_PresonListDilag(0);
				iTemp = JY_UserYLJD(iCurrentItem,iSelectPersonIdx,iType);

				if (iTemp > 0)
				{
					LPSTR pText = NULL;
					
					if (iType == 1)
					{
						JY_VideoRestoreScreen(1);
						pText = va("恢复生命 %d",iTemp);
						JY_DrawTextDialog(pText,JY_XY((g_iFontSize+4)*3+10,(g_iFontSize+4)*2+20),TRUE,TRUE,FALSE);
						SafeFree(pText);
					}
					else
					{
						JY_VideoRestoreScreen(1);
						pText = va("中和毒素 %d",iTemp);
						JY_DrawTextDialog(pText,JY_XY((g_iFontSize+4)*3+10,(g_iFontSize+4)*2+20),TRUE,TRUE,FALSE);
						SafeFree(pText);
					}
				}
				bExit = true;	
			}
		}
		else if (g_InputState.dwKeyPress & kKeyMenu)
		{
			bExit = true;
		}
	}
	return iTemp;
}
//绘医疗解毒菜单
short JY_DrawPersonYLJDDilag(short iCurrentItem,short iType)
{
	int i = 0;
	int iLen = 0;
	BYTE bufText[30] = {0};
	char *pChar = NULL;
	int x = (g_iFontSize+4) * 3 + 5;
	int y = 10;
	int iPerson = -1;
	int iDrawNum = 0;

	JY_ThingDilagBack(2);
	
	if (iType == 1)
	{
		JY_DrawStr(x + 2,y - 3,"谁要使用医术",BAICOLOR,0,FALSE,FALSE);
		JY_DrawStr(x + 2,y + (g_iFontSize+4)+5,"医疗能力",HUANGCOLOR,0,FALSE,FALSE);
	}
	if (iType == 2)
	{
		JY_DrawStr(x + 2,y - 3,"谁要帮人解毒",BAICOLOR,0,FALSE,FALSE);
		JY_DrawStr(x + 2,y + (g_iFontSize+4)+5,"解毒能力",HUANGCOLOR,0,FALSE,FALSE);
	}
	x+=2;
	y+=(g_iFontSize+4)*2 +13;
	for(i=0;i<6;i++)
	{
		iPerson = gpGlobals->g.pBaseList->Group[i];
		if (iPerson != -1)
		{
			ClearBuf(bufText,30);
			for(int j=0;j< 10;j++)
			{
				if (gpGlobals->g.pPersonList[iPerson].name1big5[j] == 0)
				{
					bufText[j] =0;
					break;
				}
				bufText[j] = gpGlobals->g.pPersonList[iPerson].name1big5[j] ;//^ 0xFF;
				iLen++;
			}
			Big5toUnicode(bufText,iLen);
			if (iType == 1)
			{
				pChar = va("%-8s%3d",bufText,gpGlobals->g.pPersonList[iPerson].YiLiao);
				iLen = strlen(pChar);
			}
			if (iType == 2)
			{
				pChar = va("%-8s%3d",bufText,gpGlobals->g.pPersonList[iPerson].JieDu);
				iLen = strlen(pChar);
			}

			if (i == iCurrentItem)
			{
				JY_DrawStr(x,y,pChar,BAICOLOR,0,FALSE,FALSE);
			}
			else
			{
				if (iType == 1)
				{
					if (gpGlobals->g.pPersonList[iPerson].YiLiao < 20 || gpGlobals->g.pPersonList[iPerson].Tili < 50)
						JY_DrawStr(x,y,pChar,110,0,FALSE,FALSE);
					else
						JY_DrawStr(x,y,pChar,HUANGCOLOR,0,FALSE,FALSE);
				}
				else
				{
					if (gpGlobals->g.pPersonList[iPerson].JieDu < 20 || gpGlobals->g.pPersonList[iPerson].Tili < 50)
						JY_DrawStr(x,y,pChar,110,0,FALSE,FALSE);
					else
						JY_DrawStr(x,y,pChar,HUANGCOLOR,0,FALSE,FALSE);
				}

				
			}			
			y+=(g_iFontSize+4);
			iDrawNum++;
			SafeFree(pChar);
		}
	}

	return iDrawNum;
}
//绘队员列表菜单
short JY_DrawPersonListDilag(short iCurrentItem,short iType)
{
	int i = 0;
	int iLen = 0;
	BYTE bufText[30] = {0};
	char *pChar = NULL;
	int x = 10;
	int y = 10;
	int x1 = 0;
	int y1 = g_wInitialHeight - 60 * g_iZoom;
	int iPerson = -1;
	int iDrawNum = 0;

	if (iType == 1)
		JY_ThingDilagBack(3);
	if (iType == 2)
		JY_ThingDilagBack(6);

	for(i=0;i<6;i++)
	{
		iPerson = gpGlobals->g.pBaseList->Group[i];
		if (iPerson != -1)
		{
			ClearBuf(bufText,30);
			for(int j=0;j< 10;j++)
			{
				if (gpGlobals->g.pPersonList[iPerson].name1big5[j] == 0)
				{
					bufText[j] =0;
					break;
				}
				bufText[j] = gpGlobals->g.pPersonList[iPerson].name1big5[j] ;//^ 0xFF;
				iLen++;
			}
			Big5toUnicode(bufText,iLen);
			if (i == iCurrentItem)
			{
				if (iType == 1)
				{
					if (gpGlobals->g.war.SelectPerson[i][1] > 0)
					{
						JY_FillColor(x,y+g_iFontSize,x+g_iFontSize/2*6,y+g_iFontSize+1,ZHICOLOR);
					}
					JY_DrawStr(x,y,(char*)bufText,BAICOLOR,0,FALSE,FALSE);
				}
				else
				{
					JY_DrawStr(x,y,(char *)bufText,BAICOLOR,0,FALSE,FALSE);
				}
				JY_LoadPic(2,gpGlobals->g.pPersonList[iPerson].PhotoId * 2,x1,y1,1,0);

				ClearBuf(bufText,30);
				for(int k=0;k< 10;k++)
				{
					if (gpGlobals->g.pPersonList[iPerson].name2big5[k] == 0)
					{
						bufText[k] =0;
						break;
					}
					bufText[k] =gpGlobals->g.pPersonList[iPerson].name2big5[k] ;//^ 0xFF;
					iLen++;
				}
				Big5toUnicode(bufText,iLen);
				JY_DrawStr(0,g_wInitialHeight-g_iFontSize,(char*)bufText,HUANGCOLOR,0,FALSE,FALSE);
			}
			else
			{
				if (iType == 1)
				{
					if (gpGlobals->g.war.SelectPerson[i][1] > 0)
					{
						JY_FillColor(x,y+g_iFontSize,x+g_iFontSize/2*6,y+g_iFontSize+1,ZHICOLOR);
						JY_DrawStr(x,y,(char *)bufText,ZHICOLOR,0,FALSE,FALSE);
					}
					else
						JY_DrawStr(x,y,(char *)bufText,HUANGCOLOR,0,FALSE,FALSE);
				}
				else
				{
					JY_DrawStr(x,y,(char *)bufText,HUANGCOLOR,0,FALSE,FALSE);
				}
			}			
			y+=(g_iFontSize+4);
			iDrawNum++;
		}
	}
	pChar = NULL;
	return iDrawNum;
}

//队员列表菜单
short JY_PresonListDilag(short iType)
{
	bool bExit = false;
	short iCurrentItem = 0;
	short iDrawNum = -1;
	JY_VideoRestoreScreen(2);
	iDrawNum =JY_DrawPersonListDilag(iCurrentItem,iType);
	JY_ShowSurface();
	while(!bExit)
	{
		JY_ClearKeyState();
		JY_ProcessEvent();		
		if (g_InputState.dwKeyPress & (kKeyDown | kKeyRight))//if (g_InputState.dir == kDirSouth || g_InputState.dir == kDirEast)//
		{
			iCurrentItem++;
			if (iCurrentItem >= iDrawNum)		
			{
				iCurrentItem = 0;
			}
			JY_VideoRestoreScreen(2);
			JY_DrawPersonListDilag(iCurrentItem,iType);
			JY_ShowSurface();
		}
		else if (g_InputState.dwKeyPress & (kKeyUp | kKeyLeft))//else if (g_InputState.dir == kDirNorth || g_InputState.dir == kDirWest)//
		{		
			iCurrentItem--;
			if (iCurrentItem < 0)
			{
				iCurrentItem = iDrawNum-1;
			}
			JY_VideoRestoreScreen(2);
			JY_DrawPersonListDilag(iCurrentItem,iType);
			JY_ShowSurface();
		}
		else if (g_InputState.dwKeyPress & kKeySearch)
		{
			if (iType == 0 )
			{
				bExit = true;
			}
			else if (iType == 2)
			{
				if (iCurrentItem > 0)
					bExit = true;
			}
			else if (iType == 1)
			{
				if (gpGlobals->g.war.bSelectOther)//可选其他人员
				{
					if (iCurrentItem >= 0)
					{
						if (gpGlobals->g.war.SelectPerson[iCurrentItem][0] >= 0)
						{
							if (gpGlobals->g.war.SelectPerson[iCurrentItem][1] == 3)
							{
								gpGlobals->g.war.SelectPerson[iCurrentItem][1] = 0;
								JY_VideoRestoreScreen(2);
								JY_DrawPersonListDilag(iCurrentItem,iType);
								JY_ShowSurface();
							}
							else if (gpGlobals->g.war.SelectPerson[iCurrentItem][1] == 0)
							{
								gpGlobals->g.war.SelectPerson[iCurrentItem][1] = 3;
								JY_VideoRestoreScreen(2);
								JY_DrawPersonListDilag(iCurrentItem,iType);
								JY_ShowSurface();
							}
						}
					}
				}
			}
		}
		else if (g_InputState.dwKeyPress & kKeyMenu)
		{
			int iFind = 0;
			for(int i=0;i<6;i++)
			{
				iFind+=gpGlobals->g.war.SelectPerson[i][1];
			}
			if (iFind == 0)
			{
				JY_VideoRestoreScreen(1);
				JY_DrawTextDialog("哇,没人怎么斗！",JY_XY(g_wInitialWidth/2,g_wInitialHeight/2),TRUE,TRUE,TRUE);
				JY_ClearKeyState();
				JY_VideoRestoreScreen(2);
				JY_DrawPersonListDilag(iCurrentItem,iType);
				JY_ShowSurface();
			}
			else
			{
				iCurrentItem = -1;
				bExit = true;
			}
		}
		JY_Delay(20);
	}
	return iCurrentItem;
}
//物品菜单
short JY_ThingDilag(VOID)
{
	bool bExit = false;
	short iCurrentItem = gpGlobals->g.iLastUseThingNum;
	
	if (iCurrentItem >=gpGlobals->g.iHaveThingsNum)
		iCurrentItem = gpGlobals->g.iHaveThingsNum -1;
	if (iCurrentItem < 0)
		iCurrentItem = 0;
	short iFristItem = 0;
	short iEndItem = 0 ;
	short iW = 0;
	short iH = 0;
	if (g_iThingPicList == 0)
	{
		iW = 2;
		iEndItem = (g_wInitialHeight -((g_iFontSize+4)*3 +15)) / (g_iFontSize+4) * 2 ;
		iH = iEndItem / 2;
	}
	else
	{
		iH = ((g_wInitialHeight -((g_iFontSize+4)*3 +15)) / 41 )/g_iZoom;
		if ( (((g_wInitialHeight -((g_iFontSize+4)*3 +15)) % 41 )/g_iZoom) > 35)
			iH++;
		iW = ((g_wInitialWidth - ((g_iFontSize+4)*3 +15)) / 41) /g_iZoom;
		if ( (((g_wInitialWidth - ((g_iFontSize+4)*3 +15)) % 41) /g_iZoom) > 35)
			iW++;
		iEndItem = iW * iH;
	}

	short iSpit = iEndItem / 2;

	iFristItem = iCurrentItem;
	iEndItem = iFristItem+iEndItem;
	
	short iDrawNum = -1;
	
	short iSelectItem = -1;
	short iSelectType = -1;
	short iSelectPersonIdx = -1;
	short iTemp = 0;
	char *pChar = NULL;

	JY_VideoRestoreScreen(1);
	iDrawNum =JY_DrawThingDilag(iFristItem,iCurrentItem,iEndItem,0);
	JY_DrawPersonListDilag(-1,0);
	JY_ShowSurface();
	while(!bExit)
	{
		JY_ClearKeyState();
		JY_ProcessEvent();		
		if (g_InputState.dwKeyPress & kKeyRight)//else if (g_InputState.dir == kDirEast )//
		{
			if (g_iThingPicList == 0)
			{
				if (iCurrentItem < iFristItem + iSpit)//一页左半部
				{
					if(iCurrentItem+iSpit < iDrawNum)
						iCurrentItem+=iSpit;
					else
						iCurrentItem=iDrawNum-1;
				}
				else
				{
					if (iCurrentItem+iSpit < gpGlobals->g.iHaveThingsNum)
					{
						iCurrentItem+=iSpit;
						iFristItem+=iSpit*2;
						iEndItem+=iSpit*2;
					}
					else
					{
						iFristItem+=iSpit;
						iEndItem+=iSpit;
					}
				}
			}
			else
			{
				if (iCurrentItem+1 < iEndItem)
				{
					if (iCurrentItem+1 <iDrawNum)
						iCurrentItem++;
				}
				else
				{
					if(iCurrentItem+1 < 200)
					{
						iFristItem+=iW;
						iEndItem+=iW;
					}
				}
			}
			JY_VideoRestoreScreen(1);
			iDrawNum =JY_DrawThingDilag(iFristItem,iCurrentItem,iEndItem,0);
			JY_DrawPersonListDilag(-1,0);
			JY_ShowSurface();
		}
		else if (g_InputState.dwKeyPress & kKeyDown )//if (g_InputState.dir == kDirSouth )//
		{
			if (g_iThingPicList == 0)
			{
				if (iCurrentItem < iDrawNum-1)//
				{
					iCurrentItem++;
				}
				else
				{
					if (iDrawNum == iEndItem)
					{
						if (iCurrentItem+1 < gpGlobals->g.iHaveThingsNum)
						{
							iCurrentItem++;
							iFristItem++;
							iEndItem++;
						}	
						else
						{
							iFristItem++;
							iEndItem++;
						}
					}
				}
			}
			else
			{
				if (iCurrentItem+iW < iEndItem)
				{
					if (iCurrentItem+iW <iDrawNum)
						iCurrentItem+=iW;
				}
				else
				{
					if(iCurrentItem+iW < 200)
					{
						iFristItem+=iW;
						iEndItem+=iW;
					}
				}
			}
			JY_VideoRestoreScreen(1);
			iDrawNum =JY_DrawThingDilag(iFristItem,iCurrentItem,iEndItem,0);
			JY_DrawPersonListDilag(-1,0);
			JY_ShowSurface();
		}
		else if (g_InputState.dwKeyPress &  kKeyLeft)//else if (g_InputState.dir == kDirWest )//
		{		
			if (g_iThingPicList == 0)
			{
				if (iCurrentItem < iFristItem + iSpit)//一页左半部
				{
					if (iCurrentItem - iSpit > 0)
					{
						if ( (iFristItem - iSpit*2) >= 0)
						{
							iCurrentItem-=iSpit;
							iFristItem -=iSpit*2;
							iEndItem-=iSpit*2;
						}
						else
						{
							iFristItem = 0;
							iEndItem = (g_wInitialHeight -((g_iFontSize+4)*3 +15)) / (g_iFontSize+4) * 2 ;
						}
					}
					else
					{
						iCurrentItem=0;
						iFristItem = 0;
						iEndItem = (g_wInitialHeight -((g_iFontSize+4)*3 +15)) / (g_iFontSize+4) * 2 ;
					}
				}
				else
				{
					iCurrentItem-=iSpit;
				}
			}
			else
			{
				if (iCurrentItem-1>=iFristItem)
				{
					iCurrentItem--;
				}
				else
				{
					if (iFristItem-iW > 0)
					{
						iFristItem-=iW;
						iEndItem-=iW;
					}
					else
					{
						iFristItem=0;
						iCurrentItem=0;
						iEndItem=iW * iH;
					}
				}
			}
			JY_VideoRestoreScreen(1);
			iDrawNum = JY_DrawThingDilag(iFristItem,iCurrentItem,iEndItem,0);
			JY_DrawPersonListDilag(-1,0);
			JY_ShowSurface();
		}
		else if (g_InputState.dwKeyPress & kKeyUp )//else if (g_InputState.dir == kDirNorth )//
		{		
			if (g_iThingPicList == 0)
			{
				if (iCurrentItem < iFristItem + iSpit)//一页左半部
				{
					if (iCurrentItem == iFristItem)
					{
						if (iCurrentItem -1 >= 0)
						{
							iCurrentItem--;
							iFristItem--;
							iEndItem--;
						}
						else
						{
							iCurrentItem=0;
							iFristItem=0;
							iEndItem =(g_wInitialHeight -((g_iFontSize+4)*3 +15)) / (g_iFontSize+4) * 2 ;
						}
					}
					else
					{
						iCurrentItem--;
					}
				}
				else
				{
					iCurrentItem--;
				}
			}
			else
			{
				if (iCurrentItem-iW>=iFristItem)
				{
					iCurrentItem-=iW;
				}
				else
				{
					if (iFristItem-iW > 0)
					{
						iFristItem-=iW;
						iEndItem-=iW;
					}
					else
					{
						iFristItem=0;
						iCurrentItem=0;
						iEndItem=iW * iH;
					}
				}
			}
			JY_VideoRestoreScreen(1);
			iDrawNum = JY_DrawThingDilag(iFristItem,iCurrentItem,iEndItem,0);
			JY_DrawPersonListDilag(-1,0);
			JY_ShowSurface();
		}
		else if (g_InputState.dwKeyPress & kKeySearch)
		{
			iSelectItem = gpGlobals->g.pBaseList->WuPin[iCurrentItem][0];
			iSelectType = gpGlobals->g.pThingsList[iSelectItem].LeiXing;
			gpGlobals->g.iLastUseThingNum = iCurrentItem;
			if (iSelectType == 0 )
			{
				JY_UseThing(0,iCurrentItem);
				bExit = true;
				return -1;
			}
			else if (iSelectType == 1 || iSelectType == 2 || iSelectType == 3)//暗器除外
			{
				JY_VideoBackupScreen(2);
				iSelectPersonIdx = JY_PresonListDilag(0);
				iTemp = JY_UseThing(iSelectPersonIdx,iCurrentItem);						
				switch (iTemp)
				{
				case -1:
					pChar = va("该物品不适合此人修炼");
					break;
				case -2:
					pChar = va("该物品不适合此人内力性质");
					break;
				case -3:
					pChar = va("此人内力不适合使用该物品");
					break;
				case -4:
					pChar = va("此人武力不适合使用该物品");
					break;
				case -5:
					pChar = va("此人轻功能力不适合使用该物品");
					break;
				case -6:
					pChar = va("此人用毒能力不适合使用该物品");
					break;
				case -7:
					pChar = va("此人医疗能力不适合使用该物品");
					break;
				case -8:
					pChar = va("此人解毒能力不适合使用该物品");
					break;
				case -9:
					pChar = va("此人拳掌能力不适合使用该物品");
					break;
				case -10:
					pChar = va("此人御剑能力不适合使用该物品");
					break;
				case -11:
					pChar = va("此人耍刀能力不适合使用该物品");
					break;
				case -12:
					pChar = va("此人特殊兵器能力不适合使用该物品");
					break;
				case -13:
					pChar = va("此人暗器能力不适合使用该物品");
					break;
				case -14:
					pChar = va("此人资质不适合使用该物品");
					break;				
				case -15:
					pChar = va("此人性别不适合修炼");
					break;	
				case -16:
					pChar = va("已经学会该武功");
					break;
				}
				JY_VideoRestoreScreen(1);
				if (iTemp < 0)
				{
					JY_DrawStr(90,30,pChar,HUANGCOLOR,0,FALSE,FALSE);
					JY_ShowSurface();
					SafeFree(pChar);
					WaitKey();
					JY_VideoRestoreScreen(1);
				}
				iDrawNum = JY_DrawThingDilag(iFristItem,iCurrentItem,iEndItem,0);
				JY_DrawPersonListDilag(-1,0);
				JY_ShowSurface();
			}
			
		}
		else if (g_InputState.dwKeyPress & kKeyMenu)
		{
			bExit = true;
		}
		SDL_Delay(20);
	}
	return 0;
}
//状态菜单
VOID JY_PresonStatusDilag(VOID)
{
	bool bExit = false;
	short iCurrentItem = 0;
	short iDrawNum = -1;

	JY_VideoRestoreScreen(1);
	JY_ThingDilagBack(1);
	iDrawNum =JY_DrawPersonListDilag(iCurrentItem,0);
	JY_DrawPersonStatus(iCurrentItem);
	JY_ShowSurface();
	while(!bExit)
	{
		JY_ClearKeyState();
		JY_ProcessEvent();		
		if (g_InputState.dwKeyPress & (kKeyDown | kKeyRight))//if (g_InputState.dir == kDirSouth || g_InputState.dir == kDirEast)//
		{
			iCurrentItem++;
			if (iCurrentItem >= iDrawNum)		
			{
				iCurrentItem = 0;
			}
			JY_VideoRestoreScreen(1);
			JY_ThingDilagBack(1);
			JY_DrawPersonListDilag(iCurrentItem,0);
			JY_DrawPersonStatus(iCurrentItem);
			JY_ShowSurface();
		}
		else if (g_InputState.dwKeyPress & (kKeyUp | kKeyLeft))//else if (g_InputState.dir == kDirNorth || g_InputState.dir == kDirWest)//
		{		
			iCurrentItem--;
			if (iCurrentItem < 0)
			{
				iCurrentItem = iDrawNum-1;
			}
			JY_VideoRestoreScreen(1);
			JY_ThingDilagBack(1);
			JY_DrawPersonListDilag(iCurrentItem,0);
			JY_DrawPersonStatus(iCurrentItem);
			JY_ShowSurface();
		}
		else if (g_InputState.dwKeyPress & kKeySearch)
		{
			bExit = true;
		}
		else if (g_InputState.dwKeyPress & kKeyMenu)
		{
			iCurrentItem = -1;
			bExit = true;
		}
		SDL_Delay(20);
	}
	JY_ClearKeyState();
	
}

//战斗
short WarMain(short warid,short flag,short iType)
{
	WarLoad(warid);
	WarSelectTeam();
	WarSelectEnemy();
	gpGlobals->g.war.iType = iType;

	JY_PicInit();
	JY_ShowSlow(1,1);
	JY_PicLoadFile("\\Resource\\data\\Wmap\\Wmap",3);
	JY_PicLoadFile("\\Resource\\data\\Hdgrp\\Hdgrp",2);
	JY_PicLoadFile("\\Resource\\data\\Eft\\Eft",4);

	OGG_Play(0, FALSE);
	OGG_Play(gpGlobals->g.war.pWarSta->iMusic, TRUE);

	INT ifirst = 0;
	INT iwarStatus = 0;
	INT i = 0;
	INT iOldGameStatus = 0;
	iOldGameStatus = gpGlobals->g.Status;
	gpGlobals->g.Status = 5;
	while(1)
	{

		for(i=0;i<gpGlobals->g.war.iPersonNum;i++)
		{
			gpGlobals->g.war.warGroup[i].iPicCode = WarCalPersonPic(i);
		}
		WarPersonSort();
		WarSetPerson();
		INT p = 0;
		while(p<gpGlobals->g.war.iPersonNum)
		{
			gpGlobals->g.war.iEffect = 0;

			if (gpGlobals->g.war.iAutoFight == 1)
			{
				JY_ClearKeyState();
				JY_ProcessEvent();
				if (g_InputState.dwKeyPress & kKeyMenu)
				{
					gpGlobals->g.war.iAutoFight = 0;
				}
			}
			if (gpGlobals->g.war.warGroup[p].bDie == FALSE)
			{
				gpGlobals->g.war.iCurID = p;
				if (gpGlobals->g.war.LastPerson != gpGlobals->g.war.warGroup[gpGlobals->g.war.iCurID].iPerson)
				{
					char cbuf[20] = {0};
					sprintf(cbuf,g_cfightgrp,gpGlobals->g.pPersonList[gpGlobals->g.war.warGroup[gpGlobals->g.war.iCurID].iPerson].PhotoId);
					LPSTR cFile = NULL;
					cFile = va("\\Resource\\data\\Fight\\%s",cbuf);
					JY_PicLoadFile(cFile,5);
					SafeFree(cFile);

					UTIL_CloseFile(gpGlobals->f.fpFightGrp);
					cFile = va("%s\\Resource\\data\\Fight\\%s.grp",JY_PREFIX,cbuf);
					gpGlobals->f.fpFightGrp = fopen(cFile,"rb" );
					SafeFree(cFile);
					gpGlobals->g.war.LastPerson = gpGlobals->g.war.warGroup[gpGlobals->g.war.iCurID].iPerson;
				}
				if (ifirst == 0)
				{
					gpGlobals->g.war.bShowHead = TRUE;
					WarDrawMap(0,0,0);
					JY_ShowSlow(1,0);
					ifirst = 1;
				}
				else
				{
					gpGlobals->g.war.bShowHead = TRUE;
					WarDrawMap(0,0,0);
					JY_ShowSurface();
				}
				INT r = 0;
				if (gpGlobals->g.war.warGroup[p].bSelf == TRUE)
				{
					if (gpGlobals->g.war.iAutoFight == 0)
						r=War_Manual();
					else
						r=War_Auto(); 
				}
				else
				{
					if (iType == 0)
						r=War_Auto();
				}

				iwarStatus = War_isEnd();
				if (r == 7 || r == 6)//状态
				{
					p--;
				}
				if (iwarStatus > 0)
					break;
			}
			p++;
		}
		if (iwarStatus > 0)
			break;
		War_PersonLostLife();
	}

	gpGlobals->g.war.bShowHead = FALSE;
	WarDrawMap(0,0,0);
	JY_VideoBackupScreen(1);

	short r = 0;
	
	if(iwarStatus == 1)
	{
		WarDrawMap(0,0,0);
		JY_DrawTextDialog("战斗胜利",JY_XY(g_wInitialWidth/2,g_iFontSize),TRUE,TRUE,TRUE);
		r = 1;
	}
	if(iwarStatus == 2)
	{
		WarDrawMap(0,0,0);
		JY_DrawTextDialog("战斗失败",JY_XY(g_wInitialWidth/2,g_iFontSize),TRUE,TRUE,TRUE);
		r = 0;
	}
	War_EndPersonData(flag,iwarStatus);
	
	WarSetGlobal();//清除数据
	WaitKey();
	
	gpGlobals->g.Status = iOldGameStatus;
	JY_ShowSlow(1,1);
	//OGG_Play(0, FALSE);
	//OGG_Play(gpGlobals->g.war.pWarSta->iMusic, TRUE);

	gpGlobals->g.iSubSceneX = 0;
	gpGlobals->g.iSubSceneY = 0;
	JY_PicInit();
	JY_PicLoadFile("\\Resource\\data\\Smap\\Smap",1);
	JY_PicLoadFile("\\Resource\\data\\Hdgrp\\Hdgrp",2);
	JY_ReDrawMap();
	return r;
}
//加载战斗数据
VOID WarLoad(short warid)
{
	INT iSize = 0;
	INT iOffset = 0;

	WarSetGlobal();

	FILE *fpWarSta = NULL;//战斗事件
	FILE *fpWarFldIdx = NULL;//战斗场景索引
	FILE *fpWarFldGrp = NULL;//战斗场景

	char cFile[256] = {0};
	sprintf(cFile,"%s\\Resource\\data\\War.sta",JY_PREFIX);
	fpWarSta = fopen(cFile,"rb");//UTIL_OpenRequiredFile("\\Resource\\data\\War.sta");
	if (fpWarSta == NULL)
		TerminateOnError("不能打开文件War.sta\n");
	sprintf(cFile,"%s\\Resource\\data\\Warfld.idx",JY_PREFIX);
	fpWarFldIdx = fopen(cFile,"rb");//UTIL_OpenRequiredFile("\\Resource\\data\\Warfld.idx");
	if (fpWarFldIdx == NULL)
		TerminateOnError("不能打开文件Warfld.idx\n");
	sprintf(cFile,"%s\\Resource\\data\\Warfld.grp",JY_PREFIX);
	fpWarFldGrp = fopen(cFile,"rb");//UTIL_OpenRequiredFile("\\Resource\\data\\Warfld.grp");
	if (fpWarFldGrp == NULL)
		TerminateOnError("不能打开文件Warfld.grp\n");
	iSize = WARDATASIZE;
	iOffset = warid * WARDATASIZE;
	gpGlobals->g.war.pWarSta = (LPWARSTA)malloc(iSize);
	if (gpGlobals->g.war.pWarSta == NULL)
		TerminateOnError("不能分配内存  WarSta Mem \n");
	if( JY_GRPReadChunk((LPBYTE)gpGlobals->g.war.pWarSta,iSize,iOffset,fpWarSta) < 0)
	{
		TerminateOnError("不能读取文件  WarSta Data:%d \n",warid);
	}

	//--
	if (JY_IDXGetChunkBaseInfo(gpGlobals->g.war.pWarSta->iMapId,fpWarFldIdx,&iSize,&iOffset) < 0)
	{
		TerminateOnError("不能读取文件  WarFld Data:%d \n",warid);
	}
	gpGlobals->g.war.pSData = (short *)malloc(g_iSmapXMax * g_iSMapYMax * 6 * 2  );//文件中存两层数据，游戏中用到6层

	if (gpGlobals->g.war.pSData == NULL)
		TerminateOnError("不能分配内存 WarFld Mem \n");
	if( JY_GRPReadChunk((LPBYTE)gpGlobals->g.war.pSData,iSize,iOffset,fpWarFldGrp) < 0)
	{
		TerminateOnError("不能读取文件 WarFld Data:%d \n",warid);
	}
	UTIL_CloseFile(fpWarSta);
	UTIL_CloseFile(fpWarFldIdx);
	UTIL_CloseFile(fpWarFldGrp);
}
//设置战斗全程变量
VOID WarSetGlobal(VOID)
{
	INT i = 0;
	gpGlobals->g.war.iWarId = -1;
	SafeFree(gpGlobals->g.war.pSData);
	SafeFree(gpGlobals->g.war.pWarSta);	
	SafeFree(gpGlobals->g.war.pMoveStep);
	SafeFree(gpGlobals->g.war.pAttackStep);
	for(i = 0;i< 26;i++)
	{
		gpGlobals->g.war.warGroup[i].iPerson = -1;
		gpGlobals->g.war.warGroup[i].bSelf = TRUE;
		gpGlobals->g.war.warGroup[i].x = -1;
		gpGlobals->g.war.warGroup[i].x = -1;
		gpGlobals->g.war.warGroup[i].bDie = TRUE;
		gpGlobals->g.war.warGroup[i].iWay = -1;
		gpGlobals->g.war.warGroup[i].iPicCode = -1;
		gpGlobals->g.war.warGroup[i].iPicType = 0;
		gpGlobals->g.war.warGroup[i].iQingGong = 0;
		gpGlobals->g.war.warGroup[i].iYiDongBushu = 0;
		gpGlobals->g.war.warGroup[i].iDianShu = 0;
		gpGlobals->g.war.warGroup[i].iExp = 0;
		gpGlobals->g.war.warGroup[i].iAutoFoe = -1;
	}
	gpGlobals->g.war.iPersonNum = 0;
	gpGlobals->g.war.iAutoFight = 0;
	gpGlobals->g.war.iCurID = 0;
	gpGlobals->g.war.bShowHead = FALSE;
	gpGlobals->g.war.iEffect = 0;
	gpGlobals->g.war.iEffectColor[2] = JY_GetColor(236, 200, 40);
	gpGlobals->g.war.iEffectColor[3] = JY_GetColor(112, 12, 112);
	gpGlobals->g.war.iEffectColor[4] = JY_GetColor(236, 200, 40);
	gpGlobals->g.war.iEffectColor[5] = JY_GetColor(96, 176, 64);
	gpGlobals->g.war.iEffectColor[6] = JY_GetColor(104, 192, 232);
	gpGlobals->g.war.bSelectOther = TRUE;
	gpGlobals->g.war.LastPerson = -1;
	gpGlobals->g.war.iRound = 0;
	gpGlobals->g.war.iType = 0;

	gpGlobals->g.war.iFlagMaxShaShangPerson = -1;
	gpGlobals->g.war.iFlagMaxYiLiaoPerson = -1;
	gpGlobals->g.war.iFlagMaxShouShangPerson = -1;
	gpGlobals->g.war.iFlagMinFoePerson = -1;
	gpGlobals->g.war.iFlagMaxJieDuPerson=-1;
	gpGlobals->g.war.iFlagMaxZhongDuPerson=-1;
}
//选择我方参战人
VOID WarSelectTeam(VOID)
{
	INT i = 0;
	INT j = 0;
	short iPerson = -1;

	gpGlobals->g.war.iPersonNum =0;
	gpGlobals->g.war.bSelectOther = TRUE;
	//WB090716,如果没有指定战斗人员，默认上一次战斗人员
	BOOL bAuto = FALSE;
	for(i = 0;i< 6;i++)
	{
		if (gpGlobals->g.war.pWarSta->WarAutoPerson[i] >= 0 || gpGlobals->g.war.pWarSta->WarManualPerson[i] >= 0)
		{
			bAuto = TRUE;
		}
	}
	if (bAuto)
	{
		//自动战斗清除上次战斗选择
		for(i = 0;i< 6;i++)
		{
			gpGlobals->g.war.SelectPerson[i][0] = -1;
			gpGlobals->g.war.SelectPerson[i][1] = 0;
		}
	}
	else
	{
		//非自动战斗修改上次自动战斗选择
		for(i = 0;i< 6;i++)
		{
			if (gpGlobals->g.war.SelectPerson[i][1] == 1 || gpGlobals->g.war.SelectPerson[i][1] == 2)
			{
				gpGlobals->g.war.SelectPerson[i][1] = 3;
			}
		}
	}

	for(i = 0;i< 6;i++)
	{
		iPerson = gpGlobals->g.war.pWarSta->WarAutoPerson[i];
		gpGlobals->g.war.SelectPerson[i][0] = gpGlobals->g.pBaseList->Group[i];
		if (iPerson >=0)
		{
			gpGlobals->g.war.warGroup[gpGlobals->g.war.iPersonNum].iPerson = iPerson;
			gpGlobals->g.war.warGroup[gpGlobals->g.war.iPersonNum].bSelf = TRUE;
			gpGlobals->g.war.warGroup[gpGlobals->g.war.iPersonNum].x = gpGlobals->g.war.pWarSta->PersonX[i];
			gpGlobals->g.war.warGroup[gpGlobals->g.war.iPersonNum].y = gpGlobals->g.war.pWarSta->PersonY[i];
			gpGlobals->g.war.warGroup[gpGlobals->g.war.iPersonNum].bDie = FALSE;
			gpGlobals->g.war.warGroup[gpGlobals->g.war.iPersonNum].iWay = 2;
			gpGlobals->g.war.warGroup[gpGlobals->g.war.iPersonNum].iPicCode = -1;
			gpGlobals->g.war.warGroup[gpGlobals->g.war.iPersonNum].iPicType = 0;
			gpGlobals->g.war.warGroup[gpGlobals->g.war.iPersonNum].iQingGong = 0;
			gpGlobals->g.war.warGroup[gpGlobals->g.war.iPersonNum].iYiDongBushu = 0;
			gpGlobals->g.war.warGroup[gpGlobals->g.war.iPersonNum].iDianShu = 0;
			gpGlobals->g.war.warGroup[gpGlobals->g.war.iPersonNum].iExp = 0;
			gpGlobals->g.war.warGroup[gpGlobals->g.war.iPersonNum].iAutoFoe = -1;
			gpGlobals->g.war.iPersonNum++;
		}//
		for(j=0;j<6;j++)
		{
			if (iPerson == gpGlobals->g.pBaseList->Group[j] && gpGlobals->g.pBaseList->Group[j] >= 0)//自动
			{
				gpGlobals->g.war.SelectPerson[j][1] = 1;
				gpGlobals->g.war.bSelectOther = FALSE;
			}
			if (gpGlobals->g.war.pWarSta->WarManualPerson[i] == 
				gpGlobals->g.pBaseList->Group[j] && gpGlobals->g.pBaseList->Group[j] >= 0)//手动
			{
				gpGlobals->g.war.SelectPerson[j][1] = 2;
			}
		}//
	}	

	JY_VideoBackupScreen(2);
	JY_PresonListDilag(1);	

	int iFind = 0;
	for(i = 0;i< 6;i++)
	{
		iFind += gpGlobals->g.war.SelectPerson[i][1];
	}
	if (iFind == 0)//没有人参加战斗的话，主角必须上
	{
		gpGlobals->g.war.SelectPerson[0][1] = 2;
	}

	if (gpGlobals->g.war.bSelectOther)
	{
		for(i = 0;i< 6;i++)
		{
			iPerson = gpGlobals->g.war.SelectPerson[i][0];
			if (iPerson >=0 && gpGlobals->g.war.SelectPerson[i][1] > 1)
			{
				gpGlobals->g.war.warGroup[gpGlobals->g.war.iPersonNum].iPerson = iPerson;
				gpGlobals->g.war.warGroup[gpGlobals->g.war.iPersonNum].bSelf = TRUE;
				gpGlobals->g.war.warGroup[gpGlobals->g.war.iPersonNum].x = gpGlobals->g.war.pWarSta->PersonX[i];
				gpGlobals->g.war.warGroup[gpGlobals->g.war.iPersonNum].y = gpGlobals->g.war.pWarSta->PersonY[i];
				gpGlobals->g.war.warGroup[gpGlobals->g.war.iPersonNum].bDie = FALSE;
				gpGlobals->g.war.warGroup[gpGlobals->g.war.iPersonNum].iWay = 2;
				gpGlobals->g.war.warGroup[gpGlobals->g.war.iPersonNum].iPicCode = -1;
				gpGlobals->g.war.warGroup[gpGlobals->g.war.iPersonNum].iPicType = 0;
				gpGlobals->g.war.warGroup[gpGlobals->g.war.iPersonNum].iQingGong = 0;
				gpGlobals->g.war.warGroup[gpGlobals->g.war.iPersonNum].iYiDongBushu = 0;
				gpGlobals->g.war.warGroup[gpGlobals->g.war.iPersonNum].iDianShu = 0;
				gpGlobals->g.war.warGroup[gpGlobals->g.war.iPersonNum].iExp = 0;
				gpGlobals->g.war.warGroup[gpGlobals->g.war.iPersonNum].iAutoFoe = -1;
				gpGlobals->g.war.iPersonNum++;
			}//
		}
	}

}
//选择敌方参战人
VOID WarSelectEnemy(VOID)
{
	INT i = 0;
	short iPerson = -1;
	for(i = 0;i< 20;i++)
	{
		iPerson = gpGlobals->g.war.pWarSta->WarfoePerson[i];
		if (iPerson >=0)
		{
			gpGlobals->g.war.warGroup[gpGlobals->g.war.iPersonNum].iPerson = iPerson;
			gpGlobals->g.war.warGroup[gpGlobals->g.war.iPersonNum].bSelf = FALSE;
			gpGlobals->g.war.warGroup[gpGlobals->g.war.iPersonNum].x = gpGlobals->g.war.pWarSta->foeX[i];
			gpGlobals->g.war.warGroup[gpGlobals->g.war.iPersonNum].y = gpGlobals->g.war.pWarSta->foeY[i];
			gpGlobals->g.war.warGroup[gpGlobals->g.war.iPersonNum].bDie = FALSE;
			gpGlobals->g.war.warGroup[gpGlobals->g.war.iPersonNum].iWay = 1;
			gpGlobals->g.war.warGroup[gpGlobals->g.war.iPersonNum].iPicCode = -1;
			gpGlobals->g.war.warGroup[gpGlobals->g.war.iPersonNum].iPicType = 0;
			gpGlobals->g.war.warGroup[gpGlobals->g.war.iPersonNum].iQingGong = 0;
			gpGlobals->g.war.warGroup[gpGlobals->g.war.iPersonNum].iYiDongBushu = 0;
			gpGlobals->g.war.warGroup[gpGlobals->g.war.iPersonNum].iDianShu = 0;
			gpGlobals->g.war.warGroup[gpGlobals->g.war.iPersonNum].iExp = 0;
			gpGlobals->g.war.warGroup[gpGlobals->g.war.iPersonNum].iAutoFoe = -1;
			gpGlobals->g.war.iPersonNum++;	
		}//
	}//
}
//计算战斗人物贴图
short WarCalPersonPic(short id)
{
	INT code = -1;
	code = g_iWarHeroImg * 2 + 
		gpGlobals->g.pPersonList[ gpGlobals->g.war.warGroup[id].iPerson].PhotoId * 8 +
		gpGlobals->g.war.warGroup[id].iWay * 2;

	return code;
}
//战斗人物按轻功排序
VOID WarPersonSort(VOID)
{
	INT i = 0;
	INT j = 0;
	short iPerson = -1;
	short iAdd = 0;
	short iMove = 0;

	for(i=0;i<gpGlobals->g.war.iPersonNum;i++)
	{
		iPerson = gpGlobals->g.war.warGroup[i].iPerson;
		iAdd = 0;
		iMove = 0;
		if (iPerson < 0) continue;
		
		if (gpGlobals->g.pPersonList[iPerson].WuQi >= 0)
		{
			iAdd+=gpGlobals->g.pThingsList[gpGlobals->g.pPersonList[iPerson].WuQi].JiaQingGong;
		}
		if (gpGlobals->g.pPersonList[iPerson].Fangju >= 0)
		{
			iAdd+=gpGlobals->g.pThingsList[gpGlobals->g.pPersonList[iPerson].Fangju].JiaQingGong;
		}
		gpGlobals->g.war.warGroup[i].iQingGong = gpGlobals->g.pPersonList[iPerson].QingGong + iAdd;

		iMove = (gpGlobals->g.war.warGroup[i].iQingGong/15) %100 - gpGlobals->g.pPersonList[iPerson].ShouShang/(g_ishoushangMax/5*2);

		iMove = iMove < 0 ? 0 :iMove;

		gpGlobals->g.war.warGroup[i].iYiDongBushu = iMove;
	}
	for(i=0;i<gpGlobals->g.war.iPersonNum -1;i++)
	{
		INT iMax = i;
		WARGROUP wTemp = gpGlobals->g.war.warGroup[i];
		for(j=i;j<gpGlobals->g.war.iPersonNum;j++)
		{
			if (gpGlobals->g.war.warGroup[j].iQingGong > gpGlobals->g.war.warGroup[iMax].iQingGong)
				iMax = j;
		}
		gpGlobals->g.war.warGroup[i] = gpGlobals->g.war.warGroup[iMax];
		gpGlobals->g.war.warGroup[iMax] = wTemp;
	}
}
//设置战斗人物位置和贴图
VOID WarSetPerson(VOID)
{
	JY_CleanWarMap(2,-1);
 	JY_CleanWarMap(5,-1);
	INT i = 0;
	for(i=0;i<gpGlobals->g.war.iPersonNum;i++)
	{
		if (gpGlobals->g.war.warGroup[i].bDie == FALSE)
		{
			JY_SetWarMap(gpGlobals->g.war.warGroup[i].x,gpGlobals->g.war.warGroup[i].y,2,i);
			JY_SetWarMap(gpGlobals->g.war.warGroup[i].x,gpGlobals->g.war.warGroup[i].y,5,gpGlobals->g.war.warGroup[i].iPicCode);
		}
	}
}
//取战斗地图数据
short JY_GetWarMap(short x,short y,short level)
{
    INT s=g_iWmapXMax * g_iWmapYMax * level + y * g_iWmapXMax + x;

	return *(gpGlobals->g.war.pSData + s);

}

//存战斗地图数据
short JY_SetWarMap(short x,short y,short level,short v)
{
    INT s=g_iWmapXMax * g_iWmapYMax * level + y * g_iWmapXMax + x;

	*(gpGlobals->g.war.pSData+s)=v;

	return 0;

}

//设置某层战斗地图为给定值
short JY_CleanWarMap(short level,short v)
{
	short *p = NULL;
    p=gpGlobals->g.war.pSData + g_iWmapXMax * g_iWmapYMax * level;
    if (p == NULL)
		return -1;
	int i=0;
    for(i=0;i<g_iWmapXMax*g_iWmapXMax;i++){
        *p=v;
        p++;
    }
	p = NULL;
    return 0;  
} 
//flag==0 基本
//      1 显示移动路径 (v1,v2) 当前移动位置
//      2 命中人物（武功，医疗等）另一个颜色显示
//      3 在人的头顶显示点数  v1 显示的高度
//      4 战斗动画, v1 战斗人物pic, v2贴图类型(0 使用战斗场景贴图，4，fight***贴图编号
VOID WarDrawMap(INT flag, INT v1,INT v2)
{
	INT x = gpGlobals->g.war.warGroup[gpGlobals->g.war.iCurID].x;
	INT y = gpGlobals->g.war.warGroup[gpGlobals->g.war.iCurID].y;
	if (flag == 0)
	{
		JY_DrawWarMap(0,x,y,0,0);
	}
	else if (flag == 1)
	{
		if (gpGlobals->g.war.pWarSta->iMapId == 0)
			JY_DrawWarMap(1,x,y,v1,v2);
		else
			JY_DrawWarMap(2,x,y,v1,v2);
	}
	else if (flag == 2)
	{
		JY_DrawWarMap(3,x,y,0,0);
	}
	else if (flag == 3)
	{
		INT iColor = gpGlobals->g.war.iEffectColor[gpGlobals->g.war.iEffect];
		JY_DrawWarNum(x,y,v1,iColor);
	}
	else if (flag == 4)
	{
		JY_DrawWarMap(4,x,y,v1,v2);
	}
	if (gpGlobals->g.war.bShowHead)
	{
		if (flag == 1)
		{
			x = v1;
			y = v2;
			short emeny = JY_GetWarMap(x,y,2);
			if (emeny >=0)
			{
				WarShowHead(emeny);
			}
		}
		else
		{
			WarShowHead(-1);
		}
	}
	else
	{
		if (flag == 1)
		{
			x = v1;
			y = v2;
			short emeny = JY_GetWarMap(x,y,2);
			if (emeny >=0)
			{
				WarShowHead(emeny);
			}
		}
	}
}
//绘命中点数
INT JY_DrawWarNum(INT x, INT y, INT height,INT color)
{
    INT rangex=g_wInitialWidth/(2*gpGlobals->g.iXScale)/2+1+gpGlobals->g.iWMapAddX;
	INT rangey=g_wInitialHeight/(2*gpGlobals->g.iYScale)/2+1 ;
	INT i,j;
	INT i1,j1;
	INT x1,y1;
	char tmpstr[255];
 
	INT xx,yy;

	JY_DrawWarMap(0,x,y,0,0);

    // 绘战斗地面
	for(j=0;j<=2*2*rangey+gpGlobals->g.iWMapAddY;j++){
	    for(i=-rangex;i<=rangex;i++){
			if(j%2==0){
                i1=i+j/2-rangey;
				j1=-i+j/2-rangey;
			}
			else{
                i1=i+j/2-rangey;
				j1=-i+j/2+1-rangey;
			}
    
            x1=gpGlobals->g.iXScale*(i1-j1)+g_wInitialWidth/2;
			y1=gpGlobals->g.iYScale*(i1+j1)+g_wInitialHeight/2;
			xx=x+i1 ;
			yy=y+j1 ;
			if( (xx>=0) && (xx<g_iWmapXMax) && (yy>=0) && (yy<g_iWmapYMax) ){
				int num=JY_GetWarMap(xx,yy,2);        // 战斗人
				if(num>=0){
                    int effect=JY_GetWarMap(xx,yy,4);
					if(effect>1){
						INT nn=JY_GetWarMap(xx,yy,3);
						sprintf(tmpstr,"%+d",nn);
						JY_DrawStr(x1,y1-65-height,tmpstr,color,0,FALSE,FALSE);
					}
				}
                
			}
		}
	}

	return 0;
}
//绘战斗地图
INT JY_DrawWarMap(INT flag, INT x, INT y, INT v1,INT v2)
{
    INT rangex=g_wInitialWidth/(2*gpGlobals->g.iXScale)/2+1+gpGlobals->g.iWMapAddX;
	INT rangey=g_wInitialHeight/(2*gpGlobals->g.iYScale)/2+1 ;
	INT i,j;
	INT i1,j1;
	INT x1,y1; 
 
	int xx,yy;

	JY_FillColor(0,0,0,0,0);

    // 绘战斗地面
	for(j=0;j<=2*2*rangey+gpGlobals->g.iWMapAddY;j++){
	    for(i=-rangex;i<=rangex;i++){
			if(j%2==0){
                i1=i+j/2-rangey;
				j1=-i+j/2-rangey;
			}
			else{
                i1=i+j/2-rangey;
				j1=-i+j/2+1-rangey;
			}
    
            x1=gpGlobals->g.iXScale*(i1-j1)+g_wInitialWidth/2;
			y1=gpGlobals->g.iYScale*(i1+j1)+g_wInitialHeight/2;
			xx=x+i1 ;
			yy=y+j1 ;
			if( (xx>=0) && (xx<g_iWmapXMax) && (yy>=0) && (yy<g_iWmapYMax) ){
                int num=JY_GetWarMap(xx,yy,0);            
                if(num>0)
 					JY_LoadPic(3,num,x1,y1,0,0);     //地面
			}
		}
	}
	//JY_ShowSurface();
	if( (flag==1) || (flag==2) ){     //在地面上绘制移动范围
		for(j=0;j<=2*2*rangey+gpGlobals->g.iWMapAddY;j++){
			for(i=-rangex;i<=rangex;i++){
				if(j%2==0){
					i1=i+j/2-rangey;
					j1=-i+j/2-rangey;
				}
				else{
					i1=i+j/2-rangey;
					j1=-i+j/2+1-rangey;
				}
	    
				x1=gpGlobals->g.iXScale*(i1-j1)+g_wInitialWidth/2;
				y1=gpGlobals->g.iYScale*(i1+j1)+g_wInitialHeight/2;
				xx=x+i1 ;
				yy=y+j1 ;
				if( (xx>=0) && (xx<g_iWmapXMax) && (yy>=0) && (yy<g_iWmapYMax) ){
					if(JY_GetWarMap(xx,yy,3)<128){
						int showflag;
						if(flag==1)
							showflag=2+4;
						else
							showflag=2+8;

						if((xx==v1)&&(yy==v2))
							JY_LoadPic(3,0,x1,y1,showflag,128);    
						else
   							JY_LoadPic(3,0,x1,y1,showflag,64);
					}

				}
			}
		}
	}
	//JY_ShowSurface();
    // 绘战斗建筑和人
	for(j=0;j<=2*2*rangey+gpGlobals->g.iWMapAddY;j++){
	    for(i=-rangex;i<=rangex;i++){
			if(j%2==0){
                i1=i+j/2-rangey;
				j1=-i+j/2-rangey;
			}
			else{
                i1=i+j/2-rangey;
				j1=-i+j/2+1-rangey;
			}
    
            x1=gpGlobals->g.iXScale*(i1-j1)+g_wInitialWidth/2;
			y1=gpGlobals->g.iYScale*(i1+j1)+g_wInitialHeight/2;
			xx=x+i1 ;
			yy=y+j1 ;
			if( (xx>=0) && (xx<g_iWmapXMax) && (yy>=0) && (yy<g_iWmapYMax) ){
                int num=JY_GetWarMap(xx,yy,1);    //  建筑      
                if(num>0)
                	JY_LoadPic(3,num,x1,y1,0,0);

				num=JY_GetWarMap(xx,yy,2);        // 战斗人
				if(num>=0){
                    int pic=JY_GetWarMap(xx,yy,5);  // 人贴图
					if(pic>=0){
						switch(flag){
						case 0:
						case 1:
						case 2:  	
                        case 5: //人物常规显示
							JY_LoadPic(3,pic,x1,y1,0,0);
							break;
						case 3:
							if(JY_GetWarMap(xx,yy,4)>1)   //命中
  							    JY_LoadPic(3,pic,x1,y1,4+2,255);  //变黑
							else
							    JY_LoadPic(3,pic,x1,y1,0,0);

							break;
						case 4:
							if( (xx==x) && (yy==y) ){
                                if(v2==0)
								    JY_LoadPic(3,pic,x1,y1,0,0);
                                else
 							        JY_LoadPic(v2,v1,x1,y1,0,0);
                            }
							else{
								 JY_LoadPic(3,pic,x1,y1,0,0);
							}

							break;
						}
					}
				}
                
                if(flag==5){   //武功效果
	                 int effect=JY_GetWarMap(xx,yy,4);
				    if(effect>0){
                         JY_LoadPic(4,v1,x1,y1,0,0);
				    }
                }


			}
		}
	}
     return 0;
}

//手动战斗
INT War_Manual(VOID)
{
	JY_VideoBackupScreen(1);
	JY_VideoBackupScreen(2);
	INT r = 0;
	gpGlobals->g.war.bShowHead = FALSE;
	while(1)
	{
		r=War_Manual_Sub();
		if (r== -1 || r== 0 )
			r = 7;
		break;
	}	
	return r;
}
//手动战斗菜单
INT War_Manual_Sub(VOID)
{
	short iPerson = -1;
	iPerson = gpGlobals->g.war.warGroup[gpGlobals->g.war.iCurID].iPerson;

	short          wItemSelected    = 0;
	short          wDefaultItem     = 0;

	MENUITEM      rgMainMenuItem[10] = {
	  {  0, MAINMENU_LABEL_MOVE, "移动",   TRUE,     JY_XY(5, 10) },
	  {  1, MAINMENU_LABEL_GONGJI,"攻击",   TRUE,     JY_XY(5, 10+(g_iFontSize+4)) },
	  {  2, MAINMENU_LABEL_YONGDU,"用毒",   TRUE,     JY_XY(5, 10+(g_iFontSize+4)*2) },
	  {  3, MAINMENU_LABEL_JIEDU,"解毒",   TRUE,     JY_XY(5, 10+(g_iFontSize+4)*3) },
	  {  4, MAINMENU_LABEL_YILIAO, "医疗",   TRUE,     JY_XY(5, 10+(g_iFontSize+4)*4) },
	  {  5, MAINMENU_LABEL_WUPIN,"物品",   TRUE,     JY_XY(5, 10+(g_iFontSize+4)*5) },
	  {  6, MAINMENU_LABEL_WAIT,"等待",   TRUE,     JY_XY(5, 10+(g_iFontSize+4)*6) },
	  {  7, MAINMENU_LABEL_ZHUANGTAI,"状态",   TRUE,     JY_XY(5, 10+(g_iFontSize+4)*7) },
	  {  8, MAINMENU_LABEL_REST,"休息",   TRUE,     JY_XY(5, 10+(g_iFontSize+4)*8) },
	  {  9, MAINMENU_LABEL_AUTO,"自动",   TRUE,     JY_XY(5, 10+(g_iFontSize+4)*9) },
	};
	
	if (gpGlobals->g.pPersonList[iPerson].Tili <=5 || 
		gpGlobals->g.war.warGroup[gpGlobals->g.war.iCurID].iYiDongBushu <= 0)
	{
		rgMainMenuItem[0].fEnabled = FALSE;
		if (gpGlobals->g.pPersonList[iPerson].Tili <=5)
			wItemSelected = 8;
		else
			wItemSelected = 1;
	}
	
	if (gpGlobals->g.pPersonList[iPerson].Neili < War_GetMinNeiLi(iPerson) || 
		gpGlobals->g.pPersonList[iPerson].Tili < 10)
	{
		rgMainMenuItem[1].fEnabled = FALSE;
		if (rgMainMenuItem[0].fEnabled == FALSE)
			wItemSelected = 5;
		else
		{
			if (rgMainMenuItem[1].fEnabled == FALSE)
				wItemSelected=8;
			else
				wItemSelected = 1;
		}
	}
	int iFindWuGong = 0;
	for(int i=0;i<10;i++)
	{
		if (gpGlobals->g.pPersonList[iPerson].WuGong[i] > 0)
			iFindWuGong++;
	}
	if (iFindWuGong == 0)
	{
		rgMainMenuItem[1].fEnabled = FALSE;
		if (wItemSelected == 1)
			wItemSelected = 8;
	}

	if (gpGlobals->g.pPersonList[iPerson].Tili < 10 || 
		gpGlobals->g.pPersonList[iPerson].YongDu < 20)
	{
		rgMainMenuItem[2].fEnabled = FALSE;
	}
	if (gpGlobals->g.pPersonList[iPerson].Tili < 10 || 
		gpGlobals->g.pPersonList[iPerson].JieDu < 20)
	{
		rgMainMenuItem[3].fEnabled = FALSE;
	}
	if (gpGlobals->g.pPersonList[iPerson].Tili < 50 || 
		gpGlobals->g.pPersonList[iPerson].YiLiao < 20)
	{
		rgMainMenuItem[4].fEnabled = FALSE;
	}
	short r = -1;
	while (TRUE)
	{
		JY_VideoRestoreScreen(1);
		wItemSelected = JY_ShowMenu(rgMainMenuItem,NULL, 10, wItemSelected, TRUE,TRUE,HUANGCOLOR,BAICOLOR);
		if (wItemSelected == -1)
		{
			break;
		}
		if (wItemSelected == 0)
		{
			r = War_MoveMenu();
			if (r>0)
			{
				break;
			}
		}
		if (wItemSelected == 1)
		{
			r = War_FightMenu();
			if (r>0)
				break;
		}
		if (wItemSelected == 9)
		{
			War_AutoMenu();			
			break;
		}
		if (wItemSelected == 2)
		{
			r = War_PoisonMenu();
			if (r>0)
				break;
			WarDrawMap(0,0,0);
		}
		if (wItemSelected == 3)
		{
			r = War_DecPoisonMenu();
			if (r>0)
				break;
			WarDrawMap(0,0,0);
		}
		if (wItemSelected == 4)
		{
			r = War_DoctorMenu();
			if (r>0)
				break;
			WarDrawMap(0,0,0);
		}
		if (wItemSelected == 5)
		{
			gpGlobals->g.war.bShowHead = FALSE;
			WarDrawMap(0,0,0);
			JY_VideoBackupScreen(1);
			r=War_ThingMenu();
			gpGlobals->g.war.bShowHead = TRUE;
			if (r>=0)
			{
				if (gpGlobals->g.pThingsList[r].LeiXing == 3)
				{
					JY_UseThingForUser(iPerson,r,1);
					break;
				} else if (gpGlobals->g.pThingsList[r].LeiXing == 4)
				{
					r=War_ExecuteMenu(4,r);
					if (r > 0)
						break;
				}
				
			}
		}
		if (wItemSelected == 6)
		{
			r=War_WaitMenu();
			if (r>0)
				break;
		}
		if (wItemSelected == 7)
		{
			gpGlobals->g.war.bShowHead = FALSE;
			WarDrawMap(0,0,0);
			JY_VideoBackupScreen(1);
			War_StatusMenu();
			gpGlobals->g.war.bShowHead = TRUE;
			break;
		}
		if (wItemSelected == 8)
		{
			War_RestMenu();
			break;
		}
	}
	return wItemSelected;
}	
//计算所有武功中需要内力最少的
short War_GetMinNeiLi(short iPerson)
{
	INT i = 0;
	INT r = 32765;
	for(i=0;i<10;i++)
	{
		INT iWuGong = -1;
		iWuGong = gpGlobals->g.pPersonList[iPerson].WuGong[i];
		if (iWuGong >= 0)
		{
			if (gpGlobals->g.pWuGongList[iWuGong].XiaoHaoNeiLi < r)
				r = gpGlobals->g.pWuGongList[iWuGong].XiaoHaoNeiLi;
		}
	}
	return r;
}
//自动战斗主函数
INT War_Auto(VOID)
{
	srand((unsigned)SDL_GetTicks());

	INT autotype = 0;
	gpGlobals->g.war.bShowHead = TRUE;

	//计算当前形势，用于修正动作
	War_NowStatus();

	autotype = War_Think();
	if (autotype == 0)//先跑开休息
	{
		War_AutoEscape();  
        War_RestMenu();
	}
	else if (autotype == 1)//自动战斗
	{
		War_AutoFight();
	}
	else if (autotype == 2)//先跑开吃药加生命
	{
		War_AutoEscape();
        War_AutoEatDrug(2);
	}
	else if (autotype == 3)//先跑开吃药加内力
	{
		War_AutoEscape();
        War_AutoEatDrug(3);
	}
	else if (autotype == 4)//先跑开吃药加体力
	{
		War_AutoEscape();
        War_AutoEatDrug(4);
	}
	else if (autotype == 5)//自己医疗
	{
		War_AutoEscape();
        War_AutoDoctor();
	}
	else if (autotype == 6)//医疗他人
	{
		if (gpGlobals->g.war.iFlagMaxShouShangPerson >=0)
		{
			short iCul = -1;
			for(int i=0;i<gpGlobals->g.war.iPersonNum;i++)
			{
				if (gpGlobals->g.war.warGroup[i].iPerson == gpGlobals->g.war.iFlagMaxShouShangPerson)
				{
					iCul = i;
					break;
				}

			}
			if (iCul >= 0)
			{
				War_AutoDoctorOther(iCul);
			}
		}
		else
		{
			War_AutoEscape();  
			War_RestMenu();
		}
	}
	else if (autotype == 7)//解毒他人
	{
		if (gpGlobals->g.war.iFlagMaxZhongDuPerson >=0)
		{
			short iCul = -1;
			for(int i=0;i<gpGlobals->g.war.iPersonNum;i++)
			{
				if (gpGlobals->g.war.warGroup[i].iPerson == gpGlobals->g.war.iFlagMaxZhongDuPerson)
				{
					iCul = i;
					break;
				}

			}
			if (iCul >= 0)
			{
				War_AutoecPoisonOther(iCul);
			}
		}
		else
		{
			War_AutoEscape();  
			War_RestMenu();
		}
	}
	else if (autotype == 8)//自己解毒
	{
		War_AutoEscape();
        War_AutoDecPoison();
	}
	return 0;
}
//思考如何战斗
//0 休息， 1 战斗，2 使用物品增加生命， 3 使用物品增加内力 4 吃药加体力， 5 医疗
INT War_Think(VOID)
{
	INT r = -1;
	short iPerson = -1;
	iPerson = gpGlobals->g.war.warGroup[gpGlobals->g.war.iCurID].iPerson;
	//
	if (gpGlobals->g.pPersonList[iPerson].Tili < 10)
	{
		r=War_ThinkDrug(4);
		if(r>=0)
		{
			return r;
		}
		return 0;
	}
	//
	if (gpGlobals->g.pPersonList[iPerson].hp < gpGlobals->g.pPersonList[iPerson].hpMax/10 || gpGlobals->g.pPersonList[iPerson].ShouShang > g_ishoushangMax/2)
	{
		r=War_ThinkDrug(2);
		if(r>=0)
		{
			return r;
		}
		else//没药医疗
		{
			r=War_ThinkDoctor();//自己医疗
			if(r>=0)
			{
				return r;
			}
			else
			{
				if (gpGlobals->g.pPersonList[iPerson].Neili >= War_GetMinNeiLi(iPerson))
					r =1;//拼死一战
				else
					r =0;//唉暂时等死吧
				return r;
			}
		}
		return 0;
	}
	//
	INT rate=-1;
	INT irand = -1;
	srand((unsigned)SDL_GetTicks());

	if (gpGlobals->g.pPersonList[iPerson].hp < gpGlobals->g.pPersonList[iPerson].hpMax /5)
	{
		rate = 90;
	}
	else if (gpGlobals->g.pPersonList[iPerson].hp < gpGlobals->g.pPersonList[iPerson].hpMax /4)
	{
		rate = 70;
	}
	else if (gpGlobals->g.pPersonList[iPerson].hp < gpGlobals->g.pPersonList[iPerson].hpMax /3)
	{
		rate = 50;
	}
	else if (gpGlobals->g.pPersonList[iPerson].hp < gpGlobals->g.pPersonList[iPerson].hpMax /2)
	{
		rate = 25;
	}	
	irand = rand() % 100;
	if(irand < rate)
	{
		r=War_ThinkDrug(2);
		if(r>=0)
		{
			return r;
		}
		else
		{
			r=War_ThinkDoctor();
			if(r>=0)
			{
				return r;
			}
			else
			{
				if (gpGlobals->g.pPersonList[iPerson].Neili >= War_GetMinNeiLi(iPerson))
					r =1;//拼死一战
				else
					r =0;//唉暂时等死吧
				return r;
			}
		}
	}
	//
	rate=-1;
	if (gpGlobals->g.pPersonList[iPerson].Neili < gpGlobals->g.pPersonList[iPerson].NeiliMax /5)
	{
		rate = 75;
	}
	else if (gpGlobals->g.pPersonList[iPerson].Neili < gpGlobals->g.pPersonList[iPerson].NeiliMax /4)
	{
		rate = 50;
	}	
	irand = rand() % 100;
	if(irand < rate)
	{
		r=War_ThinkDrug(3);
		if(r>=0)
		{
			return r;
		}		
	}

	if (gpGlobals->g.war.iFlagMaxShouShangPerson>= 0)//有受伤需医疗者
	{
		//受伤需医疗者等级大于等于自己
		if (gpGlobals->g.pPersonList[gpGlobals->g.war.iFlagMaxShouShangPerson].grade >= gpGlobals->g.pPersonList[iPerson].grade)
		{
			//自己是医疗能力最大者
			if (gpGlobals->g.war.iFlagMaxYiLiaoPerson == iPerson)
			{
				if (gpGlobals->g.pPersonList[gpGlobals->g.war.iFlagMaxShouShangPerson].ShouShang <= gpGlobals->g.pPersonList[iPerson].YiLiao+20)
				{
					if (gpGlobals->g.war.iFlagMaxShouShangPerson == iPerson)
						return 5;
					else
						return 6;
				}
			}
		}
		else
		{
			//主角受伤不受等级限制
			if (gpGlobals->g.war.iFlagMaxShouShangPerson == 0 && gpGlobals->g.war.warGroup[gpGlobals->g.war.iCurID].bSelf == TRUE)
			{
				//自己是医疗能力最大者
				if (gpGlobals->g.pPersonList[gpGlobals->g.war.iFlagMaxShouShangPerson].ShouShang <= gpGlobals->g.pPersonList[iPerson].YiLiao+20)
				{
					if (gpGlobals->g.war.iFlagMaxShouShangPerson == iPerson)
						return 5;
					else
						return 6;
				}
			}
		}
	}
	if (gpGlobals->g.war.iFlagMaxZhongDuPerson>= 0)//有中毒需解毒者
	{
		//有中毒需解毒者等级大于等于自己
		if (gpGlobals->g.pPersonList[gpGlobals->g.war.iFlagMaxZhongDuPerson].grade >= gpGlobals->g.pPersonList[iPerson].grade)
		{
			//自己是解毒能力最大者
			if (gpGlobals->g.war.iFlagMaxJieDuPerson == iPerson )
			{
				if (gpGlobals->g.pPersonList[gpGlobals->g.war.iFlagMaxZhongDuPerson].ZhongDu <=gpGlobals->g.pPersonList[iPerson].JieDu+20)
				{
					if (gpGlobals->g.war.iFlagMaxZhongDuPerson == iPerson )
						return 8;
					else
						return 7;
				}
			}
		}
		else
		{
			//主角中毒不受等级限制
			if (gpGlobals->g.war.iFlagMaxZhongDuPerson == 0 && gpGlobals->g.war.warGroup[gpGlobals->g.war.iCurID].bSelf == TRUE)
			{
				//自己是中毒能力最大者
				if (gpGlobals->g.pPersonList[gpGlobals->g.war.iFlagMaxZhongDuPerson].ZhongDu <=gpGlobals->g.pPersonList[iPerson].JieDu+20)
				{
					if (gpGlobals->g.war.iFlagMaxZhongDuPerson == iPerson )
						return 8;
					else
						return 7;
				}
			}
		}
	}

	INT iMinNeiLi = -1;
	iMinNeiLi = War_GetMinNeiLi(iPerson);
	if (gpGlobals->g.pPersonList[iPerson].Neili >= iMinNeiLi)
		r =1;
	else
		r =0;

	return r;
}
//能否吃药增加参数flag=2 生命，3内力；4体力
INT War_ThinkDrug(INT flag)
{
	INT r = -1;
	short iPerson = -1;
	INT i = 0;

	iPerson = gpGlobals->g.war.warGroup[gpGlobals->g.war.iCurID].iPerson;		
	short iWuPin = -1;
	if (gpGlobals->g.war.warGroup[gpGlobals->g.war.iCurID].bSelf == TRUE)
	{
		for(i=0;i<200;i++)
		{
			iWuPin = gpGlobals->g.pBaseList->WuPin[i][0];
			if(iWuPin >=0)
			{
				if (gpGlobals->g.pThingsList[iWuPin].LeiXing == 3 && 
					gpGlobals->g.pBaseList->WuPin[i][1] > 0 )
				{
					if (flag == 2 && gpGlobals->g.pThingsList[iWuPin].JiaShengMing > 0)
					{
						r = flag;
						break;
					}
					else if (flag == 3 && gpGlobals->g.pThingsList[iWuPin].JiaNeiLi > 0)
					{
						r = flag;
						break;
					}
					else if (flag == 4 && gpGlobals->g.pThingsList[iWuPin].JiaTiLi > 0)
					{
						r = flag;
						break;
					}
				}
			}
		}
	}
	else
	{
		for(i=0;i<4;i++)
		{
			iWuPin = gpGlobals->g.pPersonList[iPerson].XieDaiWuPin[i];
			if(iWuPin >=0)
			{
				if (gpGlobals->g.pThingsList[iWuPin].LeiXing == 3 && gpGlobals->g.pPersonList[iPerson].XieDaiWuPinShuLiang[i] > 0)
				{
					if (flag == 2 && gpGlobals->g.pThingsList[iWuPin].JiaShengMing > 0)
					{
						r = flag;
						break;
					}
					else if (flag == 3 && gpGlobals->g.pThingsList[iWuPin].JiaNeiLi > 0)
					{
						r = flag;
						break;
					}
					else if (flag == 4 && gpGlobals->g.pThingsList[iWuPin].JiaTiLi > 0)
					{
						r = flag;
						break;
					}
				}
			}
		}
	}
	return r;
}
//考虑是否自己医疗
INT War_ThinkDoctor(VOID)
{
	short iPerson = -1;
	iPerson = gpGlobals->g.war.warGroup[gpGlobals->g.war.iCurID].iPerson;

	if (gpGlobals->g.pPersonList[iPerson].Tili < g_itiliMax/2 || gpGlobals->g.pPersonList[iPerson].YiLiao < 20)
		return -1;
	if (gpGlobals->g.pPersonList[iPerson].ShouShang >  gpGlobals->g.pPersonList[iPerson].YiLiao + 20)
		return -1;

	INT rate = -1;
	INT v = -1;
	v = gpGlobals->g.pPersonList[iPerson].hpMax  - gpGlobals->g.pPersonList[iPerson].hp;
	if (gpGlobals->g.pPersonList[iPerson].YiLiao < v/4)
		rate = 30;
	else if (gpGlobals->g.pPersonList[iPerson].YiLiao < v/3)
		rate = 50;
	else if (gpGlobals->g.pPersonList[iPerson].YiLiao < v/7)
		rate = 70;
	else
		rate = 90;

	INT irand = rand() % 100;
	if (irand < rate)
		return 5;

	return -1;
}
//执行自动战斗
VOID War_AutoFight(VOID)
{
	
	INT iWuGong = -1;
	INT iMove = -1;

	iWuGong = War_AutoSelectWugong(gpGlobals->g.war.iCurID);//选择武功
	if (iWuGong <0)//没有选择到武功，休息
	{
		War_AutoEscape();
        War_RestMenu();
		return;
	}
	iMove = War_AutoMove(iWuGong);//往敌人方向移动
	if (iMove ==1)
	{
		War_AutoExecuteFight(iWuGong);
	}
	else
	{
		War_RestMenu();
	}
}
INT JY_GoDilag(VOID)
{
	return -1;
}
//自动选择合适的武功
INT War_AutoSelectWugong(short id)
{
	short iPerson = -1;
	iPerson = gpGlobals->g.war.warGroup[id].iPerson;
	INT i = 0;
	short iWuGong = -1;
	INT iLib[10] = {0};
	for(i=0;i<10;i++)
	{
		iWuGong = gpGlobals->g.pPersonList[iPerson].WuGong[i];
		INT iGongJi = -1;
		iGongJi = gpGlobals->g.pPersonList[iPerson].GongJiLi;
		if (gpGlobals->g.pPersonList[iPerson].WuQi >= 0)
		{
			if (gpGlobals->g.pThingsList[gpGlobals->g.pPersonList[iPerson].WuQi].JiaGongJiLi > 0)
				iGongJi +=gpGlobals->g.pThingsList[gpGlobals->g.pPersonList[iPerson].WuQi].JiaGongJiLi;
		}
		if (gpGlobals->g.pPersonList[iPerson].Fangju >= 0)
		{
			if (gpGlobals->g.pThingsList[gpGlobals->g.pPersonList[iPerson].Fangju].JiaGongJiLi > 0)
				iGongJi +=gpGlobals->g.pThingsList[gpGlobals->g.pPersonList[iPerson].Fangju].JiaGongJiLi;
		}
		if (iWuGong > 0)
		{
			if (gpGlobals->g.pWuGongList[iWuGong].ShangHaiLeiXing == 0)
			{
				if (gpGlobals->g.pPersonList[iPerson].Neili >= gpGlobals->g.pWuGongList[iWuGong].XiaoHaoNeiLi)
				{
					INT iLevel = gpGlobals->g.pPersonList[iPerson].WuGongDengji[i]/100 ;
					
					iLib[i] = (iGongJi * 3 + gpGlobals->g.pWuGongList[iWuGong].GongJiLi[iLevel]) /2;
				}
				else
				{
					iLib[i] = 0;
				}
			}
			else
			{
				iLib[i] = 10;
			}
		}
	}
	INT maxoffense=0;
	for(i=0;i<10;i++)
	{
		if (iLib[i] > maxoffense)
			maxoffense = iLib[i];
	}
	INT mynum=0;
	INT enemynum=0;
	for(i=0;i<gpGlobals->g.war.iPersonNum;i++)
	{
		if (gpGlobals->g.war.warGroup[i].bDie == FALSE)
		{
			if (gpGlobals->g.war.warGroup[i].bSelf == gpGlobals->g.war.warGroup[id].bSelf)
				mynum++;
			else
				enemynum++;
		}
	}
	INT factor=0;
	if (enemynum > mynum)
		factor = 2;
	else
		factor = 1;
	for(i=0;i<10;i++)
	{
		iWuGong = gpGlobals->g.pPersonList[iPerson].WuGong[i];
		if (iLib[i] > 0)
		{
			if (iLib[i] < maxoffense/2)
				iLib[i] = 0;
			INT iLevel = gpGlobals->g.pPersonList[iPerson].WuGongDengji[i] / 100 ;
			
			iLib[i] = iLib[i] + gpGlobals->g.pWuGongList[iWuGong].GongJiFanWei * factor *
				gpGlobals->g.pWuGongList[iWuGong].ShaShangFanWei[iLevel] * 20;
		}
	}
	INT s[10] = {0};
	INT maxnum=0;
	for(i=0;i<10;i++)
	{
		s[i] = maxnum;
		maxnum=maxnum+iLib[i];
	}
	s[9] = maxnum;
	if (maxnum == 0)
		return -1;
	INT irand = rand() % maxnum;

	INT selectid=-1;
	for(i=0;i<9;i++)
	{
		if (irand >= s[i] && irand < s[i+1])
		{
			selectid = i;
			break;
		}
	}
	return selectid;
}
//选择战斗对手
INT War_AutoSelectEnemy(VOID)
{
	short enemyid = gpGlobals->g.war.iFlagMinFoePerson;//War_AutoSelectEnemy_near();
	if (enemyid < 0)
		enemyid = War_AutoSelectEnemy_near();
	gpGlobals->g.war.warGroup[gpGlobals->g.war.iCurID].iAutoFoe = enemyid;
	return enemyid;
}
//选择最近对手
INT War_AutoSelectEnemy_near(VOID)
{
	War_CalMoveStep(gpGlobals->g.war.iCurID,100,1); 
	INT maxDest = 32765;
	INT nearid=-1;
	INT i =0;
	for(i=0;i<gpGlobals->g.war.iPersonNum;i++)
	{
		if (gpGlobals->g.war.warGroup[gpGlobals->g.war.iCurID].bSelf != gpGlobals->g.war.warGroup[i].bSelf)
		{
			if (gpGlobals->g.war.warGroup[i].bDie == FALSE)
			{
				short step = -1;
				step = JY_GetWarMap(gpGlobals->g.war.warGroup[i].x,gpGlobals->g.war.warGroup[i].y,3);
				if (step < maxDest)
				{
					nearid = i;
					maxDest = step;
				}
			}
		}
	}
	return nearid;
}
//自动往敌人方向移动
//人物武功编号，不是武功id
//返回 1=可以攻击敌人， 0 不能攻击
INT War_AutoMove(INT wugongnum)
{
	short iPerson = -1;
	iPerson = gpGlobals->g.war.warGroup[gpGlobals->g.war.iCurID].iPerson;
	short iWuGong = -1;
	iWuGong = gpGlobals->g.pPersonList[iPerson].WuGong[wugongnum];
	short iLevel = -1;
	iLevel = gpGlobals->g.pPersonList[iPerson].WuGongDengji[wugongnum] / 100;

	short wugongtype = -1;
	wugongtype = gpGlobals->g.pWuGongList[iWuGong].GongJiFanWei;
	short movescope = -1;
	movescope = gpGlobals->g.pWuGongList[iWuGong].YiDongFanWei[iLevel];
	short fightscope = -1;
	fightscope = gpGlobals->g.pWuGongList[iWuGong].ShaShangFanWei[iLevel];

	short scope = -1;
	scope = movescope + fightscope;
	
	short x = 0;
	short y = 0;
	short move = 128;
	short maxenemy=0;
	short movestep = -1;
	INT i =0;
	INT j =0;
	War_CalMoveStep(gpGlobals->g.war.iCurID,gpGlobals->g.war.warGroup[gpGlobals->g.war.iCurID].iYiDongBushu,0);//计算移动步数
	War_AutoCalMaxEnemyMap(iWuGong,iLevel);//计算该武功各个坐标可以攻击到敌人的个数
	for(i=0;i< gpGlobals->g.war.warGroup[gpGlobals->g.war.iCurID].iYiDongBushu;i++)
	{
		INT step_num = gpGlobals->g.war.pMoveStep[i].num;
		if (step_num == 0)
			break;
		for(j=0;j<step_num;j++)
		{
			short xx = gpGlobals->g.war.pMoveStep[i].x[j];
			short yy = gpGlobals->g.war.pMoveStep[i].y[j];
			short num = 0;
			if (wugongtype == 0 || wugongtype == 2 || wugongtype == 3)
			{
				num = JY_GetWarMap(xx,yy,4);//计算这个位置可以攻击到的最多敌人个数
			}
			else if (wugongtype == 1)
			{
				short v = JY_GetWarMap(xx,yy,4);//计算这个位置可以攻击到的最多敌人个数
				if (v >0)
				{
					short xmax = 0;
					short ymax = 0;
					num=War_AutoCalMaxEnemy(xx,yy,iWuGong,iLevel,xmax,ymax);
				}
			}
			if (num > maxenemy)
			{
				maxenemy = num;
				x = xx;
				y = yy;
				move = i;
			}
			else if (num == maxenemy && num > 0)
			{
				if (rand() %3 == 0)
				{
					maxenemy = num;
					x = xx;
					y = yy;
					move = i;
				}
			}
		}
	}
	if (maxenemy > 1)
	{
		War_CalMoveStep(gpGlobals->g.war.iCurID,gpGlobals->g.war.warGroup[gpGlobals->g.war.iCurID].iYiDongBushu,0);
		War_MovePerson(x,y);
		return 1;
	}
	else
	{
		War_GetCanFightEnemyXY(x,y);
		short minDest= 32765;
		if (x == -1)
		{
			short enemyid = War_AutoSelectEnemy();
			War_CalMoveStep(gpGlobals->g.war.iCurID,100,0);
			for(i=0;i<g_iSmapXMax;i++)
			{
				for(j=0;j<g_iSMapYMax;j++)
				{
					short dest=JY_GetWarMap(i,j,3);
					if (dest < 128)
					{
						short dx = abs(i-gpGlobals->g.war.warGroup[enemyid].x);
						short dy = abs(j-gpGlobals->g.war.warGroup[enemyid].y);
						if (minDest > (dx+dy))
						{
							minDest = dx+dy;
							x=i;
							y=j;
						}
						else if (minDest == (dx+dy))
						{
							if(rand() %2 == 0)
							{
								x=i;
								y=j;
							}
						}
					}
				}
			}
		}
		else
		{
			minDest = 0;
		}
		if (minDest < 32765 )
		{
			while(1)
			{
				i = JY_GetWarMap(x,y,3);
				if (i<= gpGlobals->g.war.warGroup[gpGlobals->g.war.iCurID].iYiDongBushu)
					break;
				if (JY_GetWarMap(x-1,y,3) == i-1)
				{
					x--;
				}
				else if (JY_GetWarMap(x+1,y,3) == i-1)
				{
					x++;
				}
				else if (JY_GetWarMap(x,y-1,3) == i-1)
				{
					y--;
				}
				else if (JY_GetWarMap(x,y+1,3) == i-1)
				{
					y++;
				}
			}
			War_MovePerson(x,y);
			//再次计算是否可以攻击到敌人
			War_AutoCalMaxEnemyMap(iWuGong,iLevel);//计算该武功各个坐标可以攻击到敌人的个数
			short xmax = 0;
			short ymax = 0;
			short num = 0;
			num=War_AutoCalMaxEnemy(x,y,iWuGong,iLevel,xmax,ymax);
			if (num > 0)
			{
				return 1;
			}

		}
	}
	return 0;

}	
//显示战斗人头像
VOID WarShowHead(short id)
{
	short idx = -1;

	if (id == -1)
		idx = gpGlobals->g.war.iCurID;
	else
		idx = id;
	if (idx < 0 || idx > gpGlobals->g.war.iPersonNum)
		return;

	short iPerson = -1;
	iPerson = gpGlobals->g.war.warGroup[idx].iPerson;

	INT x1=0;
	INT y1=0;
	INT x2=0;
	INT y2=0;
	INT width = (g_iFontSize+4)*5+2;//102;
	INT height = (g_iFontSize+4)*7+10;//152;

	if (gpGlobals->g.war.warGroup[idx].bSelf == TRUE)
	{
		x1 = g_wInitialWidth - ((g_iFontSize+4) * 6+12);
		y1 = 10;
	}
	else
	{
		x1 = 10;
		y1 = 10;
	}
	x2 = x1 + width;
	y2 = y1 + height;

	JY_DrawBox(x1,y1,x2,y2,BAICOLOR);
	JY_LoadPic(2,gpGlobals->g.pPersonList[iPerson].PhotoId * 2,x1 + (g_iFontSize+4),y1 + 10,1,0);

	BYTE bufText[30] = {0};
	INT iLen = 0;
	ClearBuf(bufText,30);
	LPSTR pChar = NULL;//
	for(int j=0;j< 10;j++)
	{
		if (gpGlobals->g.pPersonList[iPerson].name1big5[j] == 0)
		{
			bufText[j] =0;
			break;
		}
		bufText[j] = gpGlobals->g.pPersonList[iPerson].name1big5[j] ;//^ 0xFF;
		iLen++;
	}
	Big5toUnicode(bufText,iLen);
	JY_DrawStr(x1+30,y1+60*g_iZoom + 10,(char*)bufText,HUANGCOLOR,0,FALSE,FALSE);

	INT color = HUANGCOLOR;
	if (gpGlobals->g.pPersonList[iPerson].ShouShang > 0 && gpGlobals->g.pPersonList[iPerson].ShouShang <(g_ishoushangMax/3))
	{
		color = JY_GetColor(236, 200, 40);
	}
	else if (gpGlobals->g.pPersonList[iPerson].ShouShang > 0 && gpGlobals->g.pPersonList[iPerson].ShouShang < (g_ishoushangMax/3*2))
	{
		color = JY_GetColor(244, 128, 32);
	}
	else
	{
		color = HUANGCOLOR;
	}
	JY_DrawStr(x1+5,y1+60*g_iZoom + 10+(g_iFontSize+4),"生命",HUANGCOLOR,0,FALSE,FALSE);
	pChar = va("%3d",gpGlobals->g.pPersonList[iPerson].hp);
	JY_DrawStr(x1+g_iFontSize*2+3,y1+60*g_iZoom + 10+(g_iFontSize+4),pChar,color,0,FALSE,FALSE);
	SafeFree(pChar);
	JY_DrawStr(x1+g_iFontSize*4+1,y1+60*g_iZoom + 10+(g_iFontSize+4),"/",HUANGCOLOR,0,FALSE,FALSE);
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
	JY_DrawStr(x1+g_iFontSize*4+6,y1+60*g_iZoom + 10+(g_iFontSize+4),pChar,color,0,FALSE,FALSE);
	SafeFree(pChar);
	if (gpGlobals->g.pPersonList[iPerson].NeiliXingZhi == 0)
	{
		color = ZHICOLOR;
	}
	else if (gpGlobals->g.pPersonList[iPerson].NeiliXingZhi == 1)
	{
		color = HUANGCOLOR;
	}
	else
	{
		color = BAICOLOR;
	}
	JY_DrawStr(x1+5,y1+60*g_iZoom + 10+(g_iFontSize+4)*2,"内力",HUANGCOLOR,0,FALSE,FALSE);
	pChar = va("%3d/%3d",gpGlobals->g.pPersonList[iPerson].Neili,
		gpGlobals->g.pPersonList[iPerson].NeiliMax);
	JY_DrawStr(x1+g_iFontSize*2+3,y1+60*g_iZoom + 10+(g_iFontSize+4)*2,pChar,color,0,FALSE,FALSE);
	SafeFree(pChar);
	JY_DrawStr(x1+5,y1+60*g_iZoom + 10+(g_iFontSize+4)*3,"体力",HUANGCOLOR,0,FALSE,FALSE);
	pChar = va("%3d/100",gpGlobals->g.pPersonList[iPerson].Tili);
	JY_DrawStr(x1+g_iFontSize*2+3,y1+60*g_iZoom + 10+(g_iFontSize+4)*3,pChar,HUANGCOLOR,0,FALSE,FALSE);
	SafeFree(pChar);
}
//逃跑
VOID War_AutoEscape(VOID)
{
	short iPerson = -1;
	iPerson = gpGlobals->g.war.warGroup[gpGlobals->g.war.iCurID].iPerson;
	if (gpGlobals->g.pPersonList[iPerson].Tili <= 5)
		return;
	INT maxDest=0;
	INT x = 0;
	INT y = 0;
	INT i = 0;
	INT j = 0;
	INT k = 0;
	War_CalMoveStep(gpGlobals->g.war.iCurID,gpGlobals->g.war.warGroup[gpGlobals->g.war.iCurID].iYiDongBushu,0);
	for(i=0;i<g_iSmapXMax;i++)
	{
		for(j=0;j<g_iSMapYMax;j++)
		{
			if (JY_GetWarMap(i,j,3) < 128)
			{
				INT minDest = 32765;
				for(k=0;k<gpGlobals->g.war.iPersonNum;k++)
				{
					if (gpGlobals->g.war.warGroup[gpGlobals->g.war.iCurID].bSelf != 
						gpGlobals->g.war.warGroup[k].bSelf && gpGlobals->g.war.warGroup[k].bDie == FALSE)
					{
						INT dx = abs(i - gpGlobals->g.war.warGroup[k].x);
						INT dy = abs(j - gpGlobals->g.war.warGroup[k].y);
						if (minDest > (dx + dy))
						{
							minDest=dx+dy;
						}
					}
				}
				if (maxDest < minDest)
				{
					maxDest = minDest;
					x=i;
					y=j;
				}
			}
		}
	}
	if (maxDest > 0)
	{
		War_MovePerson(x,y);
	}
}
//战斗人id,最大步数,flag=0  移动，物品不能绕过，1 武功，用毒医疗等，不考虑挡路
VOID War_CalMoveStep(short id,short iBuShu,short flag)
{
	JY_CleanWarMap(3,255);

	if (iBuShu < 0)
		return;

	short x = 0;
	short y = 0;
	x = gpGlobals->g.war.warGroup[id].x;
	y = gpGlobals->g.war.warGroup[id].y;
	
	if (flag == 0)
	{
		SafeFree(gpGlobals->g.war.pMoveStep);

		gpGlobals->g.war.pMoveStep = (LPMOVESTEP)calloc(iBuShu+1,sizeof(MOVESTEP));
		
		if (gpGlobals->g.war.pMoveStep == NULL)
			TerminateOnError("War_CalMoveStep:分配内存失败pMoveStep\n");
		INT i=0;
		for(i=0;i<iBuShu;i++)
		{
			gpGlobals->g.war.pMoveStep[i].num =0;
		}
		JY_SetWarMap(x,y,3,0);
		
		gpGlobals->g.war.pMoveStep[0].num = 1;
		gpGlobals->g.war.pMoveStep[0].x[0] = x;
		gpGlobals->g.war.pMoveStep[0].y[0] = y;
		for(i=0;i<iBuShu;i++)
		{
			War_FindNextStep(i,flag);
			if (gpGlobals->g.war.pMoveStep[i+1].num == 0)
				break;
		}
	}
	else
	{
		SafeFree(gpGlobals->g.war.pAttackStep);

		gpGlobals->g.war.pAttackStep = (LPMOVESTEP)calloc(iBuShu+1,sizeof(MOVESTEP));
		
		if (gpGlobals->g.war.pAttackStep == NULL)
			TerminateOnError("War_CalMoveStep:分配内存失败pAttackStep\n");
		INT i=0;
		for(i=0;i<iBuShu;i++)
		{
			gpGlobals->g.war.pAttackStep[i].num =0;
		}
		JY_SetWarMap(x,y,3,0);
		
		gpGlobals->g.war.pAttackStep[0].num = 1;
		gpGlobals->g.war.pAttackStep[0].x[0] = x;
		gpGlobals->g.war.pAttackStep[0].y[0] = y;
		for(i=0;i<iBuShu;i++)
		{
			War_FindNextStep(i,flag);
			if (gpGlobals->g.war.pAttackStep[i+1].num == 0)
				break;
		}
	}
}
//设置下一步可移动的坐标
VOID War_FindNextStep(short step,short flag)
{
	short num=0;
	short step1 = step+1;
	short i=0;

	if (flag == 0)
	{
		for(i=0;i<gpGlobals->g.war.pMoveStep[step].num;i++)
		{
			short x = 0;
			short y = 0;
			BOOL bCanMove = FALSE;
			x = gpGlobals->g.war.pMoveStep[step].x[i];
			y = gpGlobals->g.war.pMoveStep[step].y[i];
			if (x+1 < g_iSmapXMax -1)
			{
				short v = JY_GetWarMap(x+1,y,3);			
				bCanMove = War_CanMoveXY(x+1,y,flag);
				if (v == 255 && bCanMove)
				{
					gpGlobals->g.war.pMoveStep[step1].x[num] = x+1;
					gpGlobals->g.war.pMoveStep[step1].y[num] = y;
					JY_SetWarMap(x+1,y,3,step1);
					num++;
				}
			}
			if (x-1 > 0)
			{
				short v = JY_GetWarMap(x-1,y,3);
				bCanMove = War_CanMoveXY(x-1,y,flag);
				if (v == 255 && bCanMove)
				{
					gpGlobals->g.war.pMoveStep[step1].x[num] = x-1;
					gpGlobals->g.war.pMoveStep[step1].y[num] = y;
					JY_SetWarMap(x-1,y,3,step1);
					num++;
				}
			}
			if (y+1 < g_iSMapYMax -1)
			{
				short v = JY_GetWarMap(x,y+1,3);
				bCanMove = War_CanMoveXY(x,y+1,flag);
				if (v == 255 && bCanMove)
				{
					gpGlobals->g.war.pMoveStep[step1].x[num] = x;
					gpGlobals->g.war.pMoveStep[step1].y[num] = y+1;
					JY_SetWarMap(x,y+1,3,step1);
					num++;
				}
			}
			if (y-1 >0)
			{
				short v = JY_GetWarMap(x,y-1,3);
				bCanMove = War_CanMoveXY(x,y-1,flag);
				if (v == 255 && bCanMove)
				{
					gpGlobals->g.war.pMoveStep[step1].x[num] = x;
					gpGlobals->g.war.pMoveStep[step1].y[num] = y-1;
					JY_SetWarMap(x,y-1,3,step1);
					num++;
				}
			}
		}
		gpGlobals->g.war.pMoveStep[step1].num = num;
	}
	else
	{
		for(i=0;i<gpGlobals->g.war.pAttackStep[step].num;i++)
		{
			short x = 0;
			short y = 0;
			BOOL bCanMove = FALSE;
			x = gpGlobals->g.war.pAttackStep[step].x[i];
			y = gpGlobals->g.war.pAttackStep[step].y[i];
			if (x+1 < g_iSmapXMax -1)
			{
				short v = JY_GetWarMap(x+1,y,3);
				if (v == 255 )
				{
					gpGlobals->g.war.pAttackStep[step1].x[num] = x+1;
					gpGlobals->g.war.pAttackStep[step1].y[num] = y;
					JY_SetWarMap(x+1,y,3,step1);
					num++;
				}
			}
			if (x-1 > 0)
			{
				short v = JY_GetWarMap(x-1,y,3);
				if (v == 255 )
				{
					gpGlobals->g.war.pAttackStep[step1].x[num] = x-1;
					gpGlobals->g.war.pAttackStep[step1].y[num] = y;
					JY_SetWarMap(x-1,y,3,step1);
					num++;
				}
			}
			if (y+1 < g_iSMapYMax -1)
			{
				short v = JY_GetWarMap(x,y+1,3);
				if (v == 255 )
				{
					gpGlobals->g.war.pAttackStep[step1].x[num] = x;
					gpGlobals->g.war.pAttackStep[step1].y[num] = y+1;
					JY_SetWarMap(x,y+1,3,step1);
					num++;
				}
			}
			if (y-1 >0)
			{
				short v = JY_GetWarMap(x,y-1,3);
				if (v == 255 )
				{
					gpGlobals->g.war.pAttackStep[step1].x[num] = x;
					gpGlobals->g.war.pAttackStep[step1].y[num] = y-1;
					JY_SetWarMap(x,y-1,3,step1);
					num++;
				}
			}
		}
		gpGlobals->g.war.pAttackStep[step1].num = num;
	}
}
//坐标是否可以通过，判断移动时使用
BOOL War_CanMoveXY(short x,short y,short flag)
{
	short code = -1;
	
	code = JY_GetWarMap(x,y,1);
	if (code > 0)
		return FALSE;
	if (flag == 0)
	{
		code = JY_GetWarMap(x,y,0);
		if (code ==1022 || code ==358 || code == 374 || code == 376 || code == 378 || code == 380)
			return FALSE;
		code = JY_GetWarMap(x,y,2);
		if (code >=0)
			return FALSE;
	}
	return TRUE;
}
//休息
VOID War_RestMenu(VOID)
{
	short iPerson = -1;
	iPerson = gpGlobals->g.war.warGroup[gpGlobals->g.war.iCurID].iPerson;

	short v = 3 + rand() % 3;

	JY_SetPersonStatus(enum_Tili,iPerson,v,FALSE);

	if (gpGlobals->g.pPersonList[iPerson].Tili > 30)
	{
		v = 3 + rand() % (gpGlobals->g.pPersonList[iPerson].Tili/10 -1);
		JY_SetPersonStatus(enum_hp,iPerson,v,FALSE);
		v = 3 + rand() % (gpGlobals->g.pPersonList[iPerson].Tili/10 -1);
		JY_SetPersonStatus(enum_Neili,iPerson,v,FALSE);
	}
}
//吃药加生命flag=2 生命，3内力；4体力
VOID War_AutoEatDrug(short flag)
{
	short iPerson = -1;
	iPerson = gpGlobals->g.war.warGroup[gpGlobals->g.war.iCurID].iPerson;

	short selectid = -1;
	short minvalue = 32765;
	short shouldadd = -1;
	short maxattrib = -1;
	
	if (flag == 2)
	{
		maxattrib = gpGlobals->g.pPersonList[iPerson].hpMax;
		shouldadd = maxattrib - gpGlobals->g.pPersonList[iPerson].hp;
	}
	else if (flag == 3)
	{
		maxattrib = gpGlobals->g.pPersonList[iPerson].NeiliMax;
		shouldadd = maxattrib - gpGlobals->g.pPersonList[iPerson].Neili;
	}
	else if (flag == 4)
	{
		maxattrib = g_itiliMax;
		shouldadd = maxattrib - gpGlobals->g.pPersonList[iPerson].Tili;
	}
	else
		return;

	INT i=0;
	INT j=0;
	short iWuPin = -1;
	if (gpGlobals->g.war.warGroup[gpGlobals->g.war.iCurID].bSelf == TRUE)
	{
		short extra=0;
		for(i=0;i<200;i++)
		{
			iWuPin = gpGlobals->g.pBaseList->WuPin[i][0];
			if (iWuPin >= 0)
			{
				if (flag == 2 && 
					gpGlobals->g.pBaseList->WuPin[i][1] > 0 && 
					gpGlobals->g.pThingsList[iWuPin].LeiXing == 3 &&
					gpGlobals->g.pThingsList[iWuPin].JiaShengMing > 0)
				{
					short v = shouldadd - gpGlobals->g.pThingsList[iWuPin].JiaShengMing;
					if (v < 0)
					{
						extra = 1;
						break;
					}
					else
					{
						if (v < minvalue)
						{
							minvalue = v;
							selectid = iWuPin;
						}
					}
				}
				if (flag == 3 && 
					gpGlobals->g.pBaseList->WuPin[i][1] > 0 && 
					gpGlobals->g.pThingsList[iWuPin].LeiXing == 3 &&
					gpGlobals->g.pThingsList[iWuPin].JiaNeiLi > 0)
				{
					short v = shouldadd - gpGlobals->g.pThingsList[iWuPin].JiaNeiLi;
					if (v < 0)
					{
						extra = 1;
						break;
					}
					else
					{
						if (v < minvalue)
						{
							minvalue = v;
							selectid = iWuPin;
						}
					}
				}
				if (flag == 4 && 
					gpGlobals->g.pBaseList->WuPin[i][1] > 0 && 
					gpGlobals->g.pThingsList[iWuPin].LeiXing == 3 &&
					gpGlobals->g.pThingsList[iWuPin].JiaTiLi > 0)
				{
					short v = shouldadd - gpGlobals->g.pThingsList[iWuPin].JiaTiLi;
					if (v < 0)
					{
						extra = 1;
						break;
					}
					else
					{
						if (v < minvalue)
						{
							minvalue = v;
							selectid = iWuPin;
						}
					}
				}
			}
		}
		if (extra == 1)
		{
			minvalue = 32765;
			for(i=0;i<200;i++)
			{
				iWuPin = gpGlobals->g.pBaseList->WuPin[i][0];
				if (iWuPin >= 0)
				{
					if (flag == 2 && 
						gpGlobals->g.pBaseList->WuPin[i][1] > 0 && 
						gpGlobals->g.pThingsList[iWuPin].LeiXing == 3 &&
						gpGlobals->g.pThingsList[iWuPin].JiaShengMing > 0)
					{
						short v = gpGlobals->g.pThingsList[iWuPin].JiaShengMing - shouldadd;
						if (v >= 0)
						{
							if (v < minvalue)
							{
								minvalue = v;
								selectid = iWuPin;
							}
						}
					}
					if (flag == 3 && 
						gpGlobals->g.pBaseList->WuPin[i][1] > 0 && 
						gpGlobals->g.pThingsList[iWuPin].LeiXing == 3 &&
						gpGlobals->g.pThingsList[iWuPin].JiaNeiLi > 0)
					{
						short v = gpGlobals->g.pThingsList[iWuPin].JiaNeiLi - shouldadd;
						if (v >= 0)
						{
							if (v < minvalue)
							{
								minvalue = v;
								selectid = iWuPin;
							}
						}
					}
					if (flag == 4 && 
						gpGlobals->g.pBaseList->WuPin[i][1] > 0 && 
						gpGlobals->g.pThingsList[iWuPin].LeiXing == 3 &&
						gpGlobals->g.pThingsList[iWuPin].JiaTiLi > 0)
					{
						short v = gpGlobals->g.pThingsList[iWuPin].JiaTiLi - shouldadd;
						if (v >= 0)
						{
							if (v < minvalue)
							{
								minvalue = v;
								selectid = iWuPin;
							}
						}
					}
				}
			}
		}
		JY_UseThingForUser(iPerson,selectid,1);
	}
	else//敌方
	{
		short extra=0;
		for(i=0;i<4;i++)
		{
			iWuPin = gpGlobals->g.pPersonList[iPerson].XieDaiWuPin[i];
			if (iWuPin >= 0)
			{
				if (flag == 2 && 
					gpGlobals->g.pPersonList[iPerson].XieDaiWuPinShuLiang[i] > 0 && 
					gpGlobals->g.pThingsList[iWuPin].LeiXing == 3 &&
					gpGlobals->g.pThingsList[iWuPin].JiaShengMing > 0)
				{
					short v = shouldadd - gpGlobals->g.pThingsList[iWuPin].JiaShengMing;
					if (v < 0)
					{
						extra = 1;
						break;
					}
					else
					{
						if (v < minvalue)
						{
							minvalue = v;
							selectid = i;
						}
					}
				}
				if (flag == 3 && 
					gpGlobals->g.pPersonList[iPerson].XieDaiWuPinShuLiang[i] > 0 && 
					gpGlobals->g.pThingsList[iWuPin].LeiXing == 3 &&
					gpGlobals->g.pThingsList[iWuPin].JiaNeiLi > 0)
				{
					short v = shouldadd - gpGlobals->g.pThingsList[iWuPin].JiaNeiLi;
					if (v < 0)
					{
						extra = 1;
						break;
					}
					else
					{
						if (v < minvalue)
						{
							minvalue = v;
							selectid = i;
						}
					}
				}
				if (flag == 4 && 
					gpGlobals->g.pPersonList[iPerson].XieDaiWuPinShuLiang[i] > 0 && 
					gpGlobals->g.pThingsList[iWuPin].LeiXing == 3 &&
					gpGlobals->g.pThingsList[iWuPin].JiaTiLi > 0)
				{
					short v = shouldadd - gpGlobals->g.pThingsList[iWuPin].JiaTiLi;
					if (v < 0)
					{
						extra = 1;
						break;
					}
					else
					{
						if (v < minvalue)
						{
							minvalue = v;
							selectid = i;
						}
					}
				}
			}
		}
		if (extra == 1)
		{
			minvalue = 32765;
			for(i=0;i<4;i++)
			{
				iWuPin = gpGlobals->g.pPersonList[iPerson].XieDaiWuPin[i];
				if (iWuPin >= 0)
				{
					if (flag == 2 && 
						gpGlobals->g.pPersonList[iPerson].XieDaiWuPinShuLiang[i] > 0 && 
						gpGlobals->g.pThingsList[iWuPin].LeiXing == 3 &&
						gpGlobals->g.pThingsList[iWuPin].JiaShengMing > 0)
					{
						short v = gpGlobals->g.pThingsList[iWuPin].JiaShengMing - shouldadd;
						if (v >= 0)
						{
							if (v < minvalue)
							{
								minvalue = v;
								selectid = i;
							}
						}
					}
					if (flag == 3 && 
						gpGlobals->g.pPersonList[iPerson].XieDaiWuPinShuLiang[i] > 0 && 
						gpGlobals->g.pThingsList[iWuPin].LeiXing == 3 &&
						gpGlobals->g.pThingsList[iWuPin].JiaNeiLi > 0)
					{
						short v = gpGlobals->g.pThingsList[iWuPin].JiaNeiLi - shouldadd;
						if (v >= 0)
						{
							if (v < minvalue)
							{
								minvalue = v;
								selectid = i;
							}
						}
					}
					if (flag == 4 && 
						gpGlobals->g.pPersonList[iPerson].XieDaiWuPinShuLiang[i] > 0 && 
						gpGlobals->g.pThingsList[iWuPin].LeiXing == 3 &&
						gpGlobals->g.pThingsList[iWuPin].JiaTiLi > 0)
					{
						short v = gpGlobals->g.pThingsList[iWuPin].JiaTiLi - shouldadd;
						if (v >= 0)
						{
							if (v < minvalue)
							{
								minvalue = v;
								selectid = i;
							}
						}
					}
				}
			}
		}
		JY_UseThingForNpc(iPerson,selectid);
	}

}
//自动医疗
VOID War_AutoDoctor(VOID)
{
	short x = gpGlobals->g.war.warGroup[gpGlobals->g.war.iCurID].x;
	short y = gpGlobals->g.war.warGroup[gpGlobals->g.war.iCurID].y;
	War_ExecuteMenu_Sub(x,y,3,-1);
}
//自动解毒
VOID War_AutoDecPoison(VOID)
{
	short x = gpGlobals->g.war.warGroup[gpGlobals->g.war.iCurID].x;
	short y = gpGlobals->g.war.warGroup[gpGlobals->g.war.iCurID].y;
	War_ExecuteMenu_Sub(x,y,2,-1);
}
//计算地图上每个位置可以攻击的敌人数目
VOID War_AutoCalMaxEnemyMap(short wugongid,short level)
{
	short wugongtype = -1;
	wugongtype = gpGlobals->g.pWuGongList[wugongid].GongJiFanWei;
	short movescope = -1;
	movescope = gpGlobals->g.pWuGongList[wugongid].YiDongFanWei[level];
	short fightscope = -1;
	fightscope = gpGlobals->g.pWuGongList[wugongid].ShaShangFanWei[level];

	short x0 = gpGlobals->g.war.warGroup[gpGlobals->g.war.iCurID].x;
	short y0 = gpGlobals->g.war.warGroup[gpGlobals->g.war.iCurID].y;

	JY_CleanWarMap(4,0);

	short n= 0;
	short i=0;
	short j=0;
	short direct=0;
	if(wugongtype == 0 || wugongtype == 3)
	{
		for(n=0;n<gpGlobals->g.war.iPersonNum;n++)
		{
			if(n != gpGlobals->g.war.iCurID &&
				gpGlobals->g.war.warGroup[n].bDie == FALSE &&
				gpGlobals->g.war.warGroup[n].bSelf != gpGlobals->g.war.warGroup[gpGlobals->g.war.iCurID].bSelf)
			{
				short xx = gpGlobals->g.war.warGroup[n].x;
				short yy = gpGlobals->g.war.warGroup[n].y;
				War_CalMoveStep(n,movescope,1);
				for(i=1;i<movescope+1;i++)
				{
					short step_num = gpGlobals->g.war.pAttackStep[i].num;
					if(step_num == 0)
						break;
					for(j=0;j<step_num;j++)
					{
						JY_SetWarMap(gpGlobals->g.war.pAttackStep[i].x[j],gpGlobals->g.war.pAttackStep[i].y[j],4,1);
					}
				}
			}
		}
	}
	else if (wugongtype==1 || wugongtype==2)
	{
		for(n=0;n<gpGlobals->g.war.iPersonNum;n++)
		{
			if(n != gpGlobals->g.war.iCurID &&
				gpGlobals->g.war.warGroup[n].bDie == FALSE &&
				gpGlobals->g.war.warGroup[n].bSelf != gpGlobals->g.war.warGroup[gpGlobals->g.war.iCurID].bSelf)
			{
				short xx = gpGlobals->g.war.warGroup[n].x;
				short yy = gpGlobals->g.war.warGroup[n].y;
				for(direct=0;direct<4;direct++)
				{
					for(i=1;i<movescope+1;i++)
					{
						short newxx = xx + gpGlobals->g.iDirectX[direct] * i;
						short newyy = yy + gpGlobals->g.iDirectY[direct] * i;
						if (newxx >=0 && newxx < g_iWmapXMax && newyy >=0 && newyy < g_iWmapYMax)
						{
							short v = JY_GetWarMap(newxx,newyy,4);
							JY_SetWarMap(newxx,newyy,4,v+1);
						}
					}
				}
			}
		}
	}

}
//移动人物到位置x,y
VOID War_MovePerson(short x,short y)
{
	short movenum = JY_GetWarMap(x,y,3);

	if (movenum <= 0)
		return;

	gpGlobals->g.war.warGroup[gpGlobals->g.war.iCurID].iYiDongBushu = 
		gpGlobals->g.war.warGroup[gpGlobals->g.war.iCurID].iYiDongBushu - movenum;

	short *px = NULL;
	short *py = NULL;
	short *pWay = NULL;

	px = (short*)calloc(movenum,sizeof(short));
	if (px == NULL)
		TerminateOnError("War_MovePerson:分配内存失败px\n");
	py = (short*)calloc(movenum,sizeof(short));
	if (py == NULL)
		TerminateOnError("War_MovePerson:分配内存失败py\n");
	pWay = (short*)calloc(movenum,sizeof(short));
	if (pWay == NULL)
		TerminateOnError("War_MovePerson:分配内存失败pWay\n");

	INT i=0;
	short code = -1;

	for(i=movenum;i> 0;i--)
	{
		px[i-1] = x;
		py[i-1] = y;
		if (JY_GetWarMap(x-1,y,3) == i-1)
		{
			x=x-1;
			pWay[i-1] = 1;
		}
		else if (JY_GetWarMap(x+1,y,3) == i-1)
		{
			x=x+1;
			pWay[i-1] = 2;
		}
		else if (JY_GetWarMap(x,y-1,3) == i-1)
		{
			y=y-1;
			pWay[i-1] = 3;
		}
		else if (JY_GetWarMap(x,y+1,3) == i-1)
		{
			y=y+1;
			pWay[i-1] = 0;
		}
	}
	for(i=0;i< movenum;i++)
	{
		JY_SetWarMap(gpGlobals->g.war.warGroup[gpGlobals->g.war.iCurID].x,
			gpGlobals->g.war.warGroup[gpGlobals->g.war.iCurID].y,2,-1);
		JY_SetWarMap(gpGlobals->g.war.warGroup[gpGlobals->g.war.iCurID].x,
			gpGlobals->g.war.warGroup[gpGlobals->g.war.iCurID].y,5,-1);

		gpGlobals->g.war.warGroup[gpGlobals->g.war.iCurID].x = px[i];
		gpGlobals->g.war.warGroup[gpGlobals->g.war.iCurID].y = py[i];
		gpGlobals->g.war.warGroup[gpGlobals->g.war.iCurID].iWay = pWay[i];
		gpGlobals->g.war.warGroup[gpGlobals->g.war.iCurID].iPicCode = WarCalPersonPic(gpGlobals->g.war.iCurID);

		JY_SetWarMap(gpGlobals->g.war.warGroup[gpGlobals->g.war.iCurID].x,
			gpGlobals->g.war.warGroup[gpGlobals->g.war.iCurID].y,2,gpGlobals->g.war.iCurID);
		JY_SetWarMap(gpGlobals->g.war.warGroup[gpGlobals->g.war.iCurID].x,
			gpGlobals->g.war.warGroup[gpGlobals->g.war.iCurID].y,5,gpGlobals->g.war.warGroup[gpGlobals->g.war.iCurID].iPicCode);
		
		WarDrawMap(0,0,0);
		JY_ShowSurface();
		JY_Delay(100);
	}
	SafeFree(px);
	SafeFree(py);
	SafeFree(pWay);

}
//得到可以走到攻击到敌人的最近位置。
VOID War_GetCanFightEnemyXY(short &x,short &y)
{
	short minStep = 32765;
	short newx = 0;
	short newy = 0;

	War_CalMoveStep(gpGlobals->g.war.iCurID,100,0);
	
	for(x=0;x<g_iSmapXMax;x++)
	{
		for(y=0;y<g_iSMapYMax;y++)
		{
			if (JY_GetWarMap(x,y,4) > 0)
			{
				short step = JY_GetWarMap(x,y,3);
				if (step <128)
				{
					if (minStep > step)
					{
						minStep = step;
						newx = x;
						newy = y;
					}
					else if (minStep == step)
					{
						if (rand() %2 ==0)
						{
							newx =x;
							newy =y;
						}
					}
				}

			}
		}
	}
	if (minStep < 32765)
	{
		x =newx;
		y =newy;
	}
	else
	{
		x = -1;
		y = -1;
	}
}

//计算从(x,y)开始攻击最多能够击中几个敌人
short War_AutoCalMaxEnemy(short x,short y,short wugongid,short level,short &xmax,short &ymax)
{
	short wugongtype = -1;
	wugongtype = gpGlobals->g.pWuGongList[wugongid].GongJiFanWei;
	short movescope = -1;
	movescope = gpGlobals->g.pWuGongList[wugongid].YiDongFanWei[level];
	short fightscope = -1;
	fightscope = gpGlobals->g.pWuGongList[wugongid].ShaShangFanWei[level];
	
	short n= 0;
	short i=0;
	short j=0;
	short direct=0;
	short maxnum = 0;
	if(wugongtype == 0 || wugongtype == 3)
	{
		War_CalMoveStep(gpGlobals->g.war.iCurID,movescope,1);
		for(i=1;i<movescope+1;i++)
		{
			short step_num = gpGlobals->g.war.pAttackStep[i].num;
			if(step_num == 0)
				break;
			for(j=0;j<step_num;j++)
			{
				short xx = gpGlobals->g.war.pAttackStep[i].x[j];
				short yy = gpGlobals->g.war.pAttackStep[i].y[j];
				short enemynum=0;
				for(n=0;n<gpGlobals->g.war.iPersonNum;n++)
				{
					if(n != gpGlobals->g.war.iCurID &&
						gpGlobals->g.war.warGroup[n].bDie == FALSE &&
						gpGlobals->g.war.warGroup[n].bSelf != gpGlobals->g.war.warGroup[gpGlobals->g.war.iCurID].bSelf)
					{
						short x1 = abs(gpGlobals->g.war.warGroup[n].x-xx);
						short y1 = abs(gpGlobals->g.war.warGroup[n].y-yy);
						if (x1 <=fightscope && y1 <= fightscope)
							enemynum++;
					}
				}
				if (enemynum>maxnum)
				{
					maxnum=enemynum;
					ymax = yy;
					xmax =xx;
				}
			}
			
		}				
	}
	else if (wugongtype==1)
	{
		for(direct=0;direct<4;direct++)
		{
			short enemynum=0;
			for(i=1;i<movescope+1;i++)
			{
				short newxx = x + gpGlobals->g.iDirectX[direct] * i;
				short newyy = y + gpGlobals->g.iDirectY[direct] * i;
				if (newxx >=0 && newxx < g_iSmapXMax && newyy >=0 && newyy < g_iSMapYMax)
				{
					short id = JY_GetWarMap(newxx,newyy,2);
					if(id>=0)
					{
						if(gpGlobals->g.war.warGroup[gpGlobals->g.war.iCurID].bSelf !=
							gpGlobals->g.war.warGroup[id].bSelf)
						{
							enemynum=enemynum+1;
						}
					}

				}
			}
			if(enemynum>maxnum)
			{
				maxnum=enemynum;
				xmax=x+gpGlobals->g.iDirectX[direct];
				ymax=y+gpGlobals->g.iDirectY[direct];
			}
		}
	}
	else if (wugongtype==2)
	{
		for(direct=0;direct<4;direct++)
		{
			short enemynum=0;
			for(i=1;i<movescope+1;i++)
			{
				short newxx = x + gpGlobals->g.iDirectX[direct] * i;
				short newyy = y + gpGlobals->g.iDirectY[direct] * i;
				if (newxx >=0 && newxx < g_iSmapXMax && newyy >=0 && newyy < g_iSMapYMax)
				{
					short id = JY_GetWarMap(newxx,newyy,2);
					if(id>=0)
					{
						if(gpGlobals->g.war.warGroup[gpGlobals->g.war.iCurID].bSelf !=
							gpGlobals->g.war.warGroup[id].bSelf)
						{
							enemynum=enemynum+1;
						}
					}

				}
			}
			if(enemynum>maxnum)
			{
				maxnum=enemynum;
				xmax=x;
				ymax=y;
			}
		}
	}
	return maxnum;
}
//自动执行战斗，此时的位置一定可以打到敌人自动执行战斗，显示攻击动画
VOID War_AutoExecuteFight(short wugongnum)
{
	short iPerson = -1;
	iPerson = gpGlobals->g.war.warGroup[gpGlobals->g.war.iCurID].iPerson;
	short iWuGong = -1;
	iWuGong = gpGlobals->g.pPersonList[iPerson].WuGong[wugongnum];
	short iLevel = -1;
	iLevel = gpGlobals->g.pPersonList[iPerson].WuGongDengji[wugongnum] / 100 ;

	short x0 = gpGlobals->g.war.warGroup[gpGlobals->g.war.iCurID].x;
	short y0 = gpGlobals->g.war.warGroup[gpGlobals->g.war.iCurID].y;
	short x = -1;
	short y = -1;
	
	War_AutoCalMaxEnemy(x0,y0,iWuGong,iLevel,x,y);

	if (x != -1)
	{
		War_Fight_Sub(gpGlobals->g.war.iCurID,wugongnum,x,y);
	}
}
//执行战斗
short War_Fight_Sub(short id,short wugongnum,short x,short y)
{
	short iPerson = -1;
	iPerson = gpGlobals->g.war.warGroup[id].iPerson;
	short iWuGong = -1;
	iWuGong = gpGlobals->g.pPersonList[iPerson].WuGong[wugongnum];
	short iLevel = -1;
	iLevel = gpGlobals->g.pPersonList[iPerson].WuGongDengji[wugongnum] / 100 ;
	
	JY_CleanWarMap(4,0);

	short fightscope = -1;
	fightscope = gpGlobals->g.pWuGongList[iWuGong].GongJiFanWei;
	if (fightscope == 0)
	{
		if (War_FightSelectType0(iWuGong,iLevel,x,y) == FALSE)
			return 0;
	}
	else if (fightscope == 1)
	{
		War_FightSelectType1(iWuGong,iLevel,x,y);
	}
	else if (fightscope == 2)
	{
		War_FightSelectType2(iWuGong,iLevel,x,y);
	}
	else if (fightscope == 3)
	{
		if (War_FightSelectType3(iWuGong,iLevel,x,y) == FALSE)
			return 0;
	}
	short fightnum=1;
	if (gpGlobals->g.pPersonList[iPerson].ZuoYouHuBo == 1)
		fightnum = 2;	

	short k = 0;
	short i = 0;
	short j = 0;
	for(k=0;k<fightnum;k++)//如果左右互搏，则攻击两次
	{
		for(i=0;i<g_iSmapXMax;i++)
		{
			for(j=0;j<g_iSMapYMax;j++)
			{
				short effect = JY_GetWarMap(i,j,4);
				if(effect>0)//攻击效果地方
				{
					short emeny = JY_GetWarMap(i,j,2);
					if(emeny >=0)//有人
					{
						if(gpGlobals->g.war.warGroup[gpGlobals->g.war.iCurID].bSelf != 
							gpGlobals->g.war.warGroup[emeny].bSelf)//是敌人
						{
							if (gpGlobals->g.pWuGongList[iWuGong].ShangHaiLeiXing == 0)//杀生命
							{
								gpGlobals->g.war.warGroup[emeny].iDianShu = - War_WugongHurtLife(emeny,iWuGong,iLevel);
								gpGlobals->g.war.iEffect = 2;
								JY_SetWarMap(i,j,4,2);
							}
							else
							{
								gpGlobals->g.war.warGroup[emeny].iDianShu = - War_WugongHurtNeili(emeny,iWuGong,iLevel);
								gpGlobals->g.war.iEffect = 3;
								JY_SetWarMap(i,j,4,3);
							}
						}
					}
				}
			}
		}
		War_ShowFight(iPerson,iWuGong,gpGlobals->g.pWuGongList[iWuGong].WuGongLeiXing,gpGlobals->g.pWuGongList[iWuGong].WuGongDongHua);
		for(i=0;i<gpGlobals->g.war.iPersonNum;i++)
			gpGlobals->g.war.warGroup[i].iDianShu = 0;
		gpGlobals->g.war.warGroup[i].iExp = gpGlobals->g.war.warGroup[i].iExp + 2;

		if (gpGlobals->g.pPersonList[iPerson].WuGongDengji[wugongnum] < 900)
		{
			gpGlobals->g.pPersonList[iPerson].WuGongDengji[wugongnum] = gpGlobals->g.pPersonList[iPerson].WuGongDengji[wugongnum] + rand()%2+1;
		}
		//
		if(gpGlobals->g.pPersonList[iPerson].WuGongDengji[wugongnum]/100  != iLevel)
		{
			iLevel = gpGlobals->g.pPersonList[iPerson].WuGongDengji[wugongnum]/100+1;
			BYTE bufText[30] = {0};
			int iLen = 0;
			for(int j=0;j< 10;j++)
			{
				if (gpGlobals->g.pWuGongList[iWuGong].Name1[j] == 0)
				{
					bufText[j] =0;
					break;
				}
				bufText[j] = gpGlobals->g.pWuGongList[iWuGong].Name1[j] ;//^ 0xFF;
				iLen++;
			}
			Big5toUnicode(bufText,iLen);

			char *pChar = va("%s 升为 %d 级",bufText,iLevel);
			if (pChar != NULL)
			{
				JY_DrawTextDialog(pChar,JY_XY(g_wInitialWidth/2,g_iFontSize),TRUE,FALSE,TRUE);
				SafeFree(pChar);
				JY_Delay(500);
			}
			gpGlobals->g.war.iRound = 1;
		}
		//
		JY_SetPersonStatus(enum_Neili,iPerson,-(iLevel+1)/2*gpGlobals->g.pWuGongList[iWuGong].XiaoHaoNeiLi,FALSE);
	}

	JY_SetPersonStatus(enum_Tili,iPerson,-3,FALSE);
	return 1;
}
//选择点攻击
BOOL War_FightSelectType0(short wugong,short level,short x1,short y1)
{
	short x0 = gpGlobals->g.war.warGroup[gpGlobals->g.war.iCurID].x;
	short y0 = gpGlobals->g.war.warGroup[gpGlobals->g.war.iCurID].y;
	War_CalMoveStep(gpGlobals->g.war.iCurID,gpGlobals->g.pWuGongList[wugong].YiDongFanWei[level],1);

	if(x1 == -1 || y1 == -1)
	{
		War_SelectMove(x1,y1);
	}
	if (x1 == -1)
	{
		WaitKey();
		return FALSE;
	}
	gpGlobals->g.war.warGroup[gpGlobals->g.war.iCurID].iWay = War_Direct(x0,y0,x1,y1);
	JY_SetWarMap(x1,y1,4,1);
	return TRUE;
}
//选择线攻击
BOOL War_FightSelectType1(short wugong,short level,short x1,short y1)
{
	short x0 = gpGlobals->g.war.warGroup[gpGlobals->g.war.iCurID].x;
	short y0 = gpGlobals->g.war.warGroup[gpGlobals->g.war.iCurID].y;

	short direct = -1;
	if(x1==-1 || y1 == -1)
	{
		JY_DrawTextDialog("请选择攻击方向",JY_XY(g_wInitialWidth/2,g_iFontSize),TRUE,FALSE,TRUE);
		while(1)
		{
			short key = WaitKey();
			if (g_InputState.dwKeyPress & kKeyUp )//if (g_InputState.dir == kDirNorth)
			{
				//y2=y-1;
				direct=0;
			}
			if (g_InputState.dwKeyPress & kKeyDown )//if (g_InputState.dir == kDirSouth)
			{
				//y2=y+1;
				direct=3;
			}
			if (g_InputState.dwKeyPress & kKeyRight)//if (g_InputState.dir == kDirEast)
			{
				//x2=x+1;
				direct=1;
			}
			if (g_InputState.dwKeyPress &  kKeyLeft)//if (g_InputState.dir == kDirWest)
			{
				//x2=x-1;
				direct=2;
			}
			if(direct >= 0)
				break;
		}
	}
	else
	{
		direct=War_Direct(x0,y0,x1,y1);
	}
	gpGlobals->g.war.warGroup[gpGlobals->g.war.iCurID].iWay = direct;
	short move = gpGlobals->g.pWuGongList[wugong].YiDongFanWei[level];
	short i =0;
	for(i=1;i<=move;i++)
	{
		if(direct==0)
			JY_SetWarMap(x0,y0-i,4,1);
		else if(direct==1)
			JY_SetWarMap(x0+i,y0,4,1);
		else if(direct==2)
			JY_SetWarMap(x0-i,y0,4,1);
		else if(direct==3)
			JY_SetWarMap(x0,y0+i,4,1);
	}	
	return TRUE;
}
//选择十字攻击
BOOL War_FightSelectType2(short wugong,short level,short x1,short y1)
{
	short x0 = gpGlobals->g.war.warGroup[gpGlobals->g.war.iCurID].x;
	short y0 = gpGlobals->g.war.warGroup[gpGlobals->g.war.iCurID].y;

	short move = gpGlobals->g.pWuGongList[wugong].YiDongFanWei[level];
	short i =0;
	for(i=1;i<=move;i++)
	{
		JY_SetWarMap(x0,y0-i,4,1);
		JY_SetWarMap(x0+i,y0,4,1);
		JY_SetWarMap(x0-i,y0,4,1);
		JY_SetWarMap(x0,y0+i,4,1);
	}	
	return TRUE;
}
//选择面攻击
BOOL War_FightSelectType3(short wugong,short level,short x1,short y1)
{
	short x0 = gpGlobals->g.war.warGroup[gpGlobals->g.war.iCurID].x;
	short y0 = gpGlobals->g.war.warGroup[gpGlobals->g.war.iCurID].y;
	War_CalMoveStep(gpGlobals->g.war.iCurID,gpGlobals->g.pWuGongList[wugong].YiDongFanWei[level],1);

	if(x1 == -1 || y1 == -1)
	{
		War_SelectMove(x1,y1);
	}
	if (x1 == -1)
	{
		WaitKey();
		return FALSE;
	}
	gpGlobals->g.war.warGroup[gpGlobals->g.war.iCurID].iWay = War_Direct(x0,y0,x1,y1);
	short move = gpGlobals->g.pWuGongList[wugong].ShaShangFanWei[level] ;
					//gpGlobals->g.pWuGongList[wugong].YiDongFanWei[level];//?jymain中没有移动范围但能攻击到人，此处没有就攻击不到人
	short i =0;
	short j=0;
	for(i=-move;i<=move;i++)
	{
		for(j=-move;j<=move;j++)
		{
			JY_SetWarMap(x1+i,y1+j,4,1);
		}
		
	}	
	return TRUE;
}
//计算人方向
short War_Direct(short x1,short y1,short x2,short y2)
{
	short x = x2-x1;
	short y = y2-y1;
	if(abs(y) > abs(x))
	{
		if(y>0)
			return 3;
		else
			return 0;
	}
	else
	{
		if(x>0)
			return 1;
		else
			return 2;
	}
}
//显示战斗动画
//pid 人id,wugong  武功编号， 0 表示用毒解毒等，使用普通攻击效果
//wogongtype =0 医疗用毒解毒，1,2,3,4 武功类型  -1 暗器
//eft  武功动画效果id  eft.idx/grp中的效果
VOID War_ShowFight(short pid,short wugong,short wugongtype,short eft)
{
	gpGlobals->g.war.bShowHead = FALSE;

	static short Effect[56] = {9,14,17,9,13,17,17,17,18,19,19,15,13,10,10,15,21,16,9,11,8,9,8,8,7,8,8,9,12,19,11,14,12,17,8,11,9,13,10,19,14,17,19,14,21,16,13,18,14,17,17,16,7,0,0};
	short fightdelay = -1;
	short fightframe = -1;
	short sounddelay = -1;
	if(wugongtype >= 0)
	{
		fightdelay = gpGlobals->g.pPersonList[pid].ChuZhaoDongHuaYanChi[wugongtype];//出招动画延迟
		fightframe = gpGlobals->g.pPersonList[pid].ChuZhaoDongHuaZhenShu[wugongtype];//出招动画帧数
		sounddelay = gpGlobals->g.pPersonList[pid].WuGongYinXiaoYanChi[wugongtype];//武功音效延迟
	}
	else
	{
		fightdelay = 0;
		fightframe = -1;
		sounddelay = -1;
	}
	short framenum = fightdelay + Effect[eft];//总帧数=出招动画帧数+各个武功效果贴图个数
	short startframe=0;//计算fignt***中当前出招起始帧
	short i=0;
	if (wugongtype >=0)
	{
		for(i=0;i<wugongtype;i++)
		{
			startframe = startframe + 4 * gpGlobals->g.pPersonList[pid].ChuZhaoDongHuaZhenShu[i];
		}
	}
	short starteft=0;//计算起始武功效果帧
	for(i=0;i<eft;i++)
	{
		starteft=starteft + Effect[i];
	}
	gpGlobals->g.war.warGroup[gpGlobals->g.war.iCurID].iPicType = 0;
	gpGlobals->g.war.warGroup[gpGlobals->g.war.iCurID].iPicCode = WarCalPersonPic(gpGlobals->g.war.iCurID);

	WarSetPerson();

	for(i=0;i<framenum;i++)
	{
		if(fightframe>=0)
		{
			gpGlobals->g.war.warGroup[gpGlobals->g.war.iCurID].iPicType = 1;
			if(i<fightframe)
				gpGlobals->g.war.warGroup[gpGlobals->g.war.iCurID].iPicCode = 
				(startframe+gpGlobals->g.war.warGroup[gpGlobals->g.war.iCurID].iWay * fightframe+i) * 2;
		}
		else
		{
			gpGlobals->g.war.warGroup[gpGlobals->g.war.iCurID].iPicType = 0;
			gpGlobals->g.war.warGroup[gpGlobals->g.war.iCurID].iPicCode = WarCalPersonPic(gpGlobals->g.war.iCurID);
		}
		if (i == sounddelay)
		{
			//出招音效
			SOUND_PlayChannel(gpGlobals->g.pWuGongList[wugong].ChuZhaoYinXiao,0,0);
		}
		if (i == fightdelay)
		{
			//武功音效
			SOUND_PlayChannel(eft,0,1);
		}
		if(gpGlobals->g.war.warGroup[gpGlobals->g.war.iCurID].iPicType == 0)
		{
			WarDrawMap(4,gpGlobals->g.war.warGroup[gpGlobals->g.war.iCurID].iPicCode,0);
		}
		else
		{
			WarDrawMap(4,gpGlobals->g.war.warGroup[gpGlobals->g.war.iCurID].iPicCode,5);
		}
		if(i>=fightdelay)//显示武功效果
		{
			starteft=starteft+1;//此处似乎是eft第一个数据有问题，应该是10，现为9，因此加1
			WarDrawEffect(starteft*2);
		}
		JY_ShowSurface();
		JY_Delay(20/g_iZoom);

	}
	gpGlobals->g.war.warGroup[gpGlobals->g.war.iCurID].iPicType = 0;
	gpGlobals->g.war.warGroup[gpGlobals->g.war.iCurID].iPicCode = WarCalPersonPic(gpGlobals->g.war.iCurID);
	WarSetPerson();
	WarDrawMap(0,0,0);
	JY_ShowSurface();

	//WarDrawMap(2,0,0);//全黑显示命中人物
	//JY_ShowSurface();
	//JY_Delay(100);

	JY_CleanWarMap(3,0);//在地图3写命中点数
	JY_VideoBackupScreen(1);
	for(i=0;i<gpGlobals->g.war.iPersonNum;i++)
	{
		short x1 = gpGlobals->g.war.warGroup[i].x;
		short y1 = gpGlobals->g.war.warGroup[i].y;
		if(gpGlobals->g.war.warGroup[i].bDie == FALSE &&
			JY_GetWarMap(x1,y1,4) > 1)
		{
			JY_SetWarMap(x1,y1,3,gpGlobals->g.war.warGroup[i].iDianShu);
		}
	}
	
	WarDrawMap(3,7*2*g_iZoom,0);
	JY_ShowSurface();
	JY_Delay(800);
	//for(i=1;i<7;i++)//显示命中的点数
	//{
	//	WarDrawMap(3,i*g_iFontSize/5,0);
	//	JY_ShowSurface();
	//}

	WarDrawMap(0,0,0);
	JY_ShowSurface();
	
	gpGlobals->g.war.bShowHead = TRUE;
}
//绘武功效果
VOID WarDrawEffect(short pic)
{
	short x = gpGlobals->g.war.warGroup[gpGlobals->g.war.iCurID].x;
	short y = gpGlobals->g.war.warGroup[gpGlobals->g.war.iCurID].y;
	JY_DrawWarMap(5,x,y,pic,0);
	//if (gpGlobals->g.war.bShowHead)
	//	WarShowHead();
}
//执行移动菜单
short War_MoveMenu(VOID)
{
	gpGlobals->g.war.bShowHead = FALSE;
	if (gpGlobals->g.war.warGroup[gpGlobals->g.war.iCurID].iYiDongBushu <=0)
	{
		return 0;
	}
	War_CalMoveStep(gpGlobals->g.war.iCurID,gpGlobals->g.war.warGroup[gpGlobals->g.war.iCurID].iYiDongBushu,0);//0
	short r = 0;
	short x = -1;
	short y = -1;
	War_SelectMove(x,y);
	if(x!= -1)
	{
		War_MovePerson(x,y);
		r=1;
	}
	else
	{
		r = 0;
	}
	gpGlobals->g.war.bShowHead = TRUE;

	return r;
}
//选择移动位置
VOID War_SelectMove(short &x,short &y)
{
	short x0 = gpGlobals->g.war.warGroup[gpGlobals->g.war.iCurID].x;
	short y0 = gpGlobals->g.war.warGroup[gpGlobals->g.war.iCurID].y;
	x=x0;
	y=y0;
	short iKeyFlag = 1;
	while(1)
	{
		short x2 = x;
		short y2 = y;
		if (iKeyFlag == 1)
		{
			WarDrawMap(1,x,y);
			JY_ShowSurface();
		}
		JY_ClearKeyState();
		JY_ProcessEvent();
		
		iKeyFlag = 0;

		if (g_InputState.dwKeyPress & kKeyMenu)//g_InputState.dwKeyPress
		{
			x=-1;
			y=-1;
			return;
		}
		if (g_InputState.dwKeyPress & kKeySearch)
		{
			return;
		}
		if (g_InputState.dir == kDirNorth)//if (g_InputState.dwKeyPress & kKeyUp )//
		{
			y2=y-1;
			iKeyFlag = 1;
		}
		if (g_InputState.dir == kDirSouth)//if (g_InputState.dwKeyPress & kKeyDown )//
		{
			y2=y+1;
			iKeyFlag = 1;
		}
		if (g_InputState.dir == kDirEast)//if (g_InputState.dwKeyPress & kKeyRight)//
		{
			x2=x+1;
			iKeyFlag = 1;
		}
		if (g_InputState.dir == kDirWest)//if (g_InputState.dwKeyPress &  kKeyLeft)//
		{
			x2=x-1;
			iKeyFlag = 1;
		}
		if (JY_GetWarMap(x2,y2,3)<128)
		{
			x=x2;
			y=y2;
		}
		JY_Delay(100);
	}
}
//等待键盘输入
short WaitKey(VOID)
{
	while(1)
	{
		JY_ClearKeyState();
		JY_ProcessEvent();
		if (g_InputState.dwKeyPress != 0)
			return (short)g_InputState.dwKeyPress;
	}
}
//执行攻击菜单
short War_FightMenu(VOID)
{
	short iPerson = -1;
	iPerson = gpGlobals->g.war.warGroup[gpGlobals->g.war.iCurID].iPerson;

	short numwugong=0;
	short i=0;
	//
	for(i=0;i<10;i++)
	{
		short tmp = gpGlobals->g.pPersonList[iPerson].WuGong[i];
		if(tmp >0)
		{
			numwugong++;
		}
	}
	LPMENUITEM pMenu = NULL;
	if (numwugong > 1)
	{
		short iNum = 0;
		pMenu = (LPMENUITEM)malloc(sizeof(MENUITEM) * numwugong);
		for(i=0;i<10;i++)
		{
			short tmp = gpGlobals->g.pPersonList[iPerson].WuGong[i];
			if(tmp >0)
			{
				pMenu[iNum].pText = (LPSTR)malloc(12);
				int iLen = 0;
				for(int i=0;i<10;i++)
				{
					if (gpGlobals->g.pWuGongList[tmp].Name1[i] == 0)
					{
						//pMenu[iNum].pText[i] =0;
						break;
					}
					//pMenu[iNum].pText[i] = gpGlobals->g.pWuGongList[tmp].Name1[i] ;//^ 0xFF;
					iLen++;
				}
				Big5toUnicode((LPBYTE)pMenu[iNum].pText,iLen);
				pMenu[iNum].pos = JY_XY((g_iFontSize+4)*3+10,8+iNum*(g_iFontSize+4));
				pMenu[iNum].wValue = iNum;
				pMenu[iNum].fEnabled = TRUE;

				if (gpGlobals->g.pWuGongList[tmp].XiaoHaoNeiLi > gpGlobals->g.pPersonList[iPerson].Neili)
					pMenu[iNum].fEnabled = FALSE;

				iNum++;
				
			}
		}
		//
		
	}
	JY_VideoBackupScreen(1);
	short r = -1;
	if (numwugong == 1)
		r=0;
	else
		r= JY_ShowMenu(pMenu,NULL, numwugong, 0, TRUE,TRUE,HUANGCOLOR,BAICOLOR);

	JY_VideoRestoreScreen(2);

	SafeFree(pMenu);

	if (r<0)
		return 0;

	gpGlobals->g.war.bShowHead = FALSE;
	short r2 = War_Fight_Sub(gpGlobals->g.war.iCurID,r,-1,-1);
	gpGlobals->g.war.bShowHead = TRUE;
	return r2;

}
//设置自动战斗
VOID War_AutoMenu(VOID)
{
	gpGlobals->g.war.iAutoFight = 1;
	War_Auto();
}
//用毒菜单
short War_PoisonMenu(VOID)
{
	gpGlobals->g.war.bShowHead = FALSE;
	short r = War_ExecuteMenu(1,0);
	gpGlobals->g.war.bShowHead = TRUE;
	return r;
}
//执行医疗，解毒用毒
//flag=1 用毒， 2 解毒，3 医疗 4 暗器
//thingid 暗器物品id
short War_ExecuteMenu(short flag,short thingid)
{
	short iPerson = -1;
	iPerson = gpGlobals->g.war.warGroup[gpGlobals->g.war.iCurID].iPerson;
	short step = 0;

	if(flag == 1)
	{
		step = gpGlobals->g.pPersonList[iPerson].YongDu / 15 + 1;
	}
	else if(flag == 2)
	{
		step = gpGlobals->g.pPersonList[iPerson].JieDu / 15 + 1;
	}
	else if(flag == 3)
	{
		step = gpGlobals->g.pPersonList[iPerson].YiLiao / 15 + 1;
	}
	else if(flag == 4)
	{
		step = gpGlobals->g.pPersonList[iPerson].AnQiJiQiao / 15 + 1;
	}
	War_CalMoveStep(gpGlobals->g.war.iCurID,step,1);

	short x=-1;
	short y=-1;
	War_SelectMove(x,y);

	if (x==-1)
	{
		WaitKey();
		return 0;
	}
	else
	{
		return War_ExecuteMenu_Sub(x,y,flag,thingid);
	}
}
//执行医疗，解毒用毒暗器的子函数，自动医疗也可调用
short War_ExecuteMenu_Sub(short x1,short y1,short flag,short thingid)
{
	short iPerson = -1;
	iPerson = gpGlobals->g.war.warGroup[gpGlobals->g.war.iCurID].iPerson;
	short x0 = -1;	
	short y0 = -1;
	x0 = gpGlobals->g.war.warGroup[gpGlobals->g.war.iCurID].x;
	y0 = gpGlobals->g.war.warGroup[gpGlobals->g.war.iCurID].y;

	JY_CleanWarMap(4,0);

	gpGlobals->g.war.warGroup[gpGlobals->g.war.iCurID].iWay = War_Direct(x0,y0,x1,y1);

	JY_SetWarMap(x1,y1,4,1);

	short emeny=JY_GetWarMap(x1,y1,2);
	if(emeny>=0)
	{
		if(flag == 1)
		{
			if(gpGlobals->g.war.warGroup[gpGlobals->g.war.iCurID].bSelf != gpGlobals->g.war.warGroup[emeny].bSelf)
			{
				gpGlobals->g.war.warGroup[emeny].iDianShu = 
					War_PoisonHurt(iPerson,gpGlobals->g.war.warGroup[emeny].iPerson);
				JY_SetWarMap(x1,y1,4,5);
				gpGlobals->g.war.iEffect=5;
			}
		}
		if(flag == 2)
		{
			if(gpGlobals->g.war.warGroup[gpGlobals->g.war.iCurID].bSelf == gpGlobals->g.war.warGroup[emeny].bSelf)
			{
				gpGlobals->g.war.warGroup[emeny].iDianShu = 
					ExecDecPoison(iPerson,gpGlobals->g.war.warGroup[emeny].iPerson);
				JY_SetWarMap(x1,y1,4,6);
				gpGlobals->g.war.iEffect=6;
			}
		}
		if(flag == 3)
		{
			if(gpGlobals->g.war.warGroup[gpGlobals->g.war.iCurID].bSelf == gpGlobals->g.war.warGroup[emeny].bSelf)
			{
				gpGlobals->g.war.warGroup[emeny].iDianShu = 
					ExecDoctor(iPerson,gpGlobals->g.war.warGroup[emeny].iPerson);
				JY_SetWarMap(x1,y1,4,4);
				gpGlobals->g.war.iEffect=4;
			}
		}
		if(flag == 4)
		{
			if(gpGlobals->g.war.warGroup[gpGlobals->g.war.iCurID].bSelf != gpGlobals->g.war.warGroup[emeny].bSelf)
			{
				gpGlobals->g.war.warGroup[emeny].iDianShu = 
					War_AnqiHurt(iPerson,gpGlobals->g.war.warGroup[emeny].iPerson,thingid);
				JY_SetWarMap(x1,y1,4,2);
				gpGlobals->g.war.iEffect=2;
			}
		}
	}
	if(flag == 1)
	{
		War_ShowFight(iPerson,0,0,30);
	}
	else if(flag == 2)
	{
		War_ShowFight(iPerson,0,0,36);
	}
	else if(flag == 3)
	{
		War_ShowFight(iPerson,0,0,0);
	}
	else if(flag == 4)
	{
		if (emeny >=0)
			War_ShowFight(iPerson,0,-1,gpGlobals->g.pThingsList[thingid].AnQiDongHuaBianHao);
	}
	short i=0;
	for(i=0;i<gpGlobals->g.war.iPersonNum;i++)
	{
		gpGlobals->g.war.warGroup[i].iDianShu = 0;
	}
	if(flag == 4)
	{
		if (emeny>=0)
		{
			JY_ThingSet(thingid,-1);
			return 1;
		}
		else
		{
			return 0;
		}
	}
	else
	{
		gpGlobals->g.war.warGroup[gpGlobals->g.war.iCurID].iExp += 1;
		JY_SetPersonStatus(enum_Tili,iPerson,-2,FALSE);
	}
	return 1;

}
//计算敌人中毒点数
short War_PoisonHurt(short pid,short emenyid)
{
	short v = (gpGlobals->g.pPersonList[pid].YongDu - gpGlobals->g.pPersonList[emenyid].KangDu )/4;
	v = v<0 ? 0:v;
	JY_SetPersonStatus(enum_ZhongDu,emenyid,v,FALSE);
	return v;
}
//执行解毒
short ExecDecPoison(short pid,short emenyid)
{
	short add = gpGlobals->g.pPersonList[pid].JieDu;
	short value = gpGlobals->g.pPersonList[emenyid].ZhongDu;
	if(value > add+20)
		return 0;
	add = limitX(add/3+rand()%10-rand()%10,0,value);
	JY_SetPersonStatus(enum_ZhongDu,emenyid,-add,FALSE);
	return -add;
}
//执行医疗
short ExecDoctor(short pid,short emenyid)
{
	if (gpGlobals->g.pPersonList[pid].Tili < 50)
		return 0;

	short add = gpGlobals->g.pPersonList[pid].YiLiao;
	short value = gpGlobals->g.pPersonList[emenyid].ShouShang;
	if(value > add+20)
		return 0;

	if(value < 25)
		add=add*4/5;
	else if(value <50)
		add=add*3/4;
	else if(value <75)
		add=add*2/3;
	else
		add=add/2;
	add+= rand()%5;
	JY_SetPersonStatus(enum_ShouShang,emenyid,-add,FALSE);
	JY_SetPersonStatus(enum_hp,emenyid,add,FALSE);
	return add;
}
//计算暗器伤害
short War_AnqiHurt(short pid,short emenyid,short thingid)
{
	short num=0;
	if (gpGlobals->g.pPersonList[emenyid].ShouShang ==0)
		num = gpGlobals->g.pThingsList[thingid].JiaShengMing/4-rand()%5;
	else if(gpGlobals->g.pPersonList[emenyid].ShouShang<=(g_ishoushangMax/3))
		num = gpGlobals->g.pThingsList[thingid].JiaShengMing/3-rand()%5;
	else if(gpGlobals->g.pPersonList[emenyid].ShouShang<=(g_ishoushangMax/3*2))
		num = gpGlobals->g.pThingsList[thingid].JiaShengMing/2-rand()%5;
	else
		num = gpGlobals->g.pThingsList[thingid].JiaShengMing/2-rand()%5;

	num=num-gpGlobals->g.pPersonList[pid].AnQiJiQiao *2/3;

	JY_SetPersonStatus(enum_ShouShang,emenyid,-num/4,FALSE);
	JY_SetPersonStatus(enum_hp,emenyid,num,FALSE);

	if (gpGlobals->g.pThingsList[thingid].JiaZhongDuJieDu > 0)
	{
		num = gpGlobals->g.pThingsList[thingid].JiaZhongDuJieDu + gpGlobals->g.pPersonList[pid].AnQiJiQiao/2;
		num=num-gpGlobals->g.pPersonList[emenyid].KangDu;
		num=limitX(num,0,g_izhongduMax);
		JY_SetPersonStatus(enum_ZhongDu,emenyid,num,FALSE);
	}
	return num;
}
//解毒菜单
short War_DecPoisonMenu(VOID)
{
	gpGlobals->g.war.bShowHead = FALSE;
	short r = War_ExecuteMenu(2,0);
	gpGlobals->g.war.bShowHead = TRUE;
	return r;
}
//医疗菜单
short War_DoctorMenu(VOID)
{
	gpGlobals->g.war.bShowHead = FALSE;
	short r = War_ExecuteMenu(3,0);
	gpGlobals->g.war.bShowHead = TRUE;
	return r;
}
//计算武功伤害生命
short War_WugongHurtLife(short emenyid,short wugong,short level)
{
	short pid = -1;
	pid = gpGlobals->g.war.warGroup[gpGlobals->g.war.iCurID].iPerson;
	short eid = -1;
	eid = gpGlobals->g.war.warGroup[emenyid].iPerson;
	
	short mywuxue=0;
	short emenywuxue=0;
	short i=0;
	for(i=0;i<gpGlobals->g.war.iPersonNum;i++)
	{
		short id = gpGlobals->g.war.warGroup[i].iPerson;
		if(gpGlobals->g.war.warGroup[i].bDie == FALSE &&
			gpGlobals->g.pPersonList[id].WuXueChangShi >= 80)
		{
			if(gpGlobals->g.war.warGroup[gpGlobals->g.war.iCurID].bSelf == gpGlobals->g.war.warGroup[i].bSelf)
				mywuxue=mywuxue+gpGlobals->g.pPersonList[id].WuXueChangShi;
			else
				emenywuxue=emenywuxue+gpGlobals->g.pPersonList[id].WuXueChangShi;
		}
	}
	while(1)
	{
		if( (level+1)/2 * gpGlobals->g.pWuGongList[wugong].XiaoHaoNeiLi > gpGlobals->g.pPersonList[pid].Neili)
			level--;
		else
			break;
	}
	if (level <=0)
		level=1;

	short fightnum=0;

	fightnum=fightnum+(gpGlobals->g.pPersonList[pid].GongJiLi *3 + gpGlobals->g.pWuGongList[wugong].GongJiLi[level])/2;
	
	short iWuGongNeiLiXingZhi = -1;
	for(i=0;i<gpGlobals->g.iThingsListCount;i++)
	{
		if (gpGlobals->g.pThingsList[i].LianChuWuGong == wugong)
		{
			iWuGongNeiLiXingZhi = gpGlobals->g.pThingsList[i].XuNeiLiXingZhi;
			break;
		}
	}
	if (iWuGongNeiLiXingZhi > -1)
	{
		//内功配合武功
		if (gpGlobals->g.pPersonList[pid].NeiliXingZhi != 2)
		{
			if (iWuGongNeiLiXingZhi != 2)
			{
				if (gpGlobals->g.pPersonList[pid].NeiliXingZhi == iWuGongNeiLiXingZhi)
					fightnum = fightnum + level/100 *fightnum;
				else
					fightnum = fightnum - level/100 *fightnum;
			}
		}
		else
		{
			if (iWuGongNeiLiXingZhi == 2)
			{
				fightnum = fightnum + level/100 *fightnum;
			}
		}
	}
	if(gpGlobals->g.pPersonList[pid].WuQi>=0)
	{
		if (gpGlobals->g.pPersonList[pid].NeiliXingZhi != 2)
		{
			if (gpGlobals->g.pThingsList[gpGlobals->g.pPersonList[pid].WuQi].XuNeiLiXingZhi != 2)
			{
				if (gpGlobals->g.pThingsList[gpGlobals->g.pPersonList[pid].WuQi].XuNeiLiXingZhi == 
					gpGlobals->g.pPersonList[pid].NeiliXingZhi)
				{
					fightnum=fightnum+ gpGlobals->g.pThingsList[gpGlobals->g.pPersonList[pid].WuQi].JiaGongJiLi +
						gpGlobals->g.pThingsList[gpGlobals->g.pPersonList[pid].WuQi].JiaGongJiLi/10;
				}
				else
				{
					fightnum=fightnum+ gpGlobals->g.pThingsList[gpGlobals->g.pPersonList[pid].WuQi].JiaGongJiLi -
						gpGlobals->g.pThingsList[gpGlobals->g.pPersonList[pid].WuQi].JiaGongJiLi/10;
				}
			}
			else
			{
				fightnum=fightnum+ gpGlobals->g.pThingsList[gpGlobals->g.pPersonList[pid].WuQi].JiaGongJiLi;
			}
		}
		else
		{
			if (gpGlobals->g.pThingsList[gpGlobals->g.pPersonList[pid].WuQi].XuNeiLiXingZhi != 2)
				fightnum=fightnum+ gpGlobals->g.pThingsList[gpGlobals->g.pPersonList[pid].WuQi].JiaGongJiLi;
			else
				fightnum=fightnum+ gpGlobals->g.pThingsList[gpGlobals->g.pPersonList[pid].WuQi].JiaGongJiLi +
						gpGlobals->g.pThingsList[gpGlobals->g.pPersonList[pid].WuQi].JiaGongJiLi/10;
		}	
		
		//武功武功武器配合增加攻击力
		char bufExt[30] = {0};
		char bufWuQi[30] = {0};
		char cFile[256] = {0};
		char *pNum = NULL;
		int imodWuGong = -1;
		int imodGongJi = 0;
		sprintf(cFile,"%s/mod.txt",JY_PREFIX);
		sprintf(bufWuQi,"%d",gpGlobals->g.pPersonList[pid].WuQi);
		if (GetIniValue(cFile, "EXTRAOFFENSE", bufWuQi, "-1,0", bufExt))
		{
			pNum = strtok(bufExt,",");
			if (pNum)
			{
				imodWuGong = atoi(pNum);
				pNum = strtok(NULL,",");
				if (pNum)
				{
					imodGongJi = atoi(pNum);
				}
			}
			if (imodWuGong == wugong)
			{
				fightnum=fightnum+imodGongJi*2/3; 
			}
		}
		pNum=NULL;
	}
	if(gpGlobals->g.pPersonList[pid].Fangju>=0)
	{
		if (gpGlobals->g.pPersonList[pid].NeiliXingZhi != 2)
		{
			if (gpGlobals->g.pThingsList[gpGlobals->g.pPersonList[pid].Fangju].XuNeiLiXingZhi != 2)
			{
				if (gpGlobals->g.pThingsList[gpGlobals->g.pPersonList[pid].Fangju].XuNeiLiXingZhi == 
					gpGlobals->g.pPersonList[pid].NeiliXingZhi)
				{
					fightnum=fightnum+ gpGlobals->g.pThingsList[gpGlobals->g.pPersonList[pid].Fangju].JiaGongJiLi +
						gpGlobals->g.pThingsList[gpGlobals->g.pPersonList[pid].Fangju].JiaGongJiLi/10;
				}
				else
				{
					fightnum=fightnum+ gpGlobals->g.pThingsList[gpGlobals->g.pPersonList[pid].Fangju].JiaGongJiLi -
						gpGlobals->g.pThingsList[gpGlobals->g.pPersonList[pid].Fangju].JiaGongJiLi/10;
				}
			}
			else
			{
				fightnum=fightnum+ gpGlobals->g.pThingsList[gpGlobals->g.pPersonList[pid].Fangju].JiaGongJiLi;
			}
		}
		else
		{
			if (gpGlobals->g.pThingsList[gpGlobals->g.pPersonList[pid].Fangju].XuNeiLiXingZhi != 2)
				fightnum=fightnum+ gpGlobals->g.pThingsList[gpGlobals->g.pPersonList[pid].Fangju].JiaGongJiLi;
			else
				fightnum=fightnum+ gpGlobals->g.pThingsList[gpGlobals->g.pPersonList[pid].Fangju].JiaGongJiLi +
						gpGlobals->g.pThingsList[gpGlobals->g.pPersonList[pid].Fangju].JiaGongJiLi/10;
		}
		//fightnum=fightnum+ gpGlobals->g.pThingsList[gpGlobals->g.pPersonList[pid].Fangju].JiaGongJiLi;	
	}
	fightnum=fightnum+mywuxue;

	short defencenum=0;
	defencenum=defencenum+gpGlobals->g.pPersonList[eid].FangYuLi;
	if(gpGlobals->g.pPersonList[eid].WuQi>=0)
	{
		if (gpGlobals->g.pPersonList[eid].NeiliXingZhi != 2)
		{
			if (gpGlobals->g.pThingsList[gpGlobals->g.pPersonList[eid].WuQi].XuNeiLiXingZhi != 2)
			{
				if (gpGlobals->g.pThingsList[gpGlobals->g.pPersonList[eid].WuQi].XuNeiLiXingZhi == 
					gpGlobals->g.pPersonList[eid].NeiliXingZhi)
				{
					defencenum=defencenum+ gpGlobals->g.pThingsList[gpGlobals->g.pPersonList[eid].WuQi].JiaFangYuLi +
						gpGlobals->g.pThingsList[gpGlobals->g.pPersonList[eid].WuQi].JiaFangYuLi/10;
				}
				else
				{
					fightnum=fightnum+ gpGlobals->g.pThingsList[gpGlobals->g.pPersonList[eid].WuQi].JiaFangYuLi -
						gpGlobals->g.pThingsList[gpGlobals->g.pPersonList[eid].WuQi].JiaFangYuLi/10;
				}
			}
			else
			{
				defencenum=defencenum+gpGlobals->g.pThingsList[gpGlobals->g.pPersonList[eid].WuQi].JiaFangYuLi;
			}
		}
		else
		{
			if (gpGlobals->g.pThingsList[gpGlobals->g.pPersonList[eid].WuQi].XuNeiLiXingZhi != 2)
				defencenum=defencenum+ gpGlobals->g.pThingsList[gpGlobals->g.pPersonList[eid].WuQi].JiaFangYuLi;
			else
				defencenum=defencenum+ gpGlobals->g.pThingsList[gpGlobals->g.pPersonList[eid].WuQi].JiaFangYuLi +
						gpGlobals->g.pThingsList[gpGlobals->g.pPersonList[eid].WuQi].JiaFangYuLi/10;
		}
		//defencenum=defencenum+ gpGlobals->g.pThingsList[gpGlobals->g.pPersonList[eid].WuQi].JiaFangYuLi;
	}
	if(gpGlobals->g.pPersonList[eid].Fangju>=0)
	{
		if (gpGlobals->g.pPersonList[eid].NeiliXingZhi != 2)
		{
			if (gpGlobals->g.pThingsList[gpGlobals->g.pPersonList[eid].Fangju].XuNeiLiXingZhi != 2)
			{
				if (gpGlobals->g.pThingsList[gpGlobals->g.pPersonList[eid].Fangju].XuNeiLiXingZhi == 
					gpGlobals->g.pPersonList[eid].NeiliXingZhi)
				{
					defencenum=defencenum+ gpGlobals->g.pThingsList[gpGlobals->g.pPersonList[eid].Fangju].JiaFangYuLi +
						gpGlobals->g.pThingsList[gpGlobals->g.pPersonList[eid].Fangju].JiaFangYuLi/10;
				}
				else
				{
					fightnum=fightnum+ gpGlobals->g.pThingsList[gpGlobals->g.pPersonList[eid].Fangju].JiaFangYuLi -
						gpGlobals->g.pThingsList[gpGlobals->g.pPersonList[eid].Fangju].JiaFangYuLi/10;
				}
			}
			else
			{
				defencenum=defencenum+gpGlobals->g.pThingsList[gpGlobals->g.pPersonList[eid].Fangju].JiaFangYuLi;
			}
		}
		else
		{
			if (gpGlobals->g.pThingsList[gpGlobals->g.pPersonList[eid].Fangju].XuNeiLiXingZhi != 2)
				defencenum=defencenum+ gpGlobals->g.pThingsList[gpGlobals->g.pPersonList[eid].Fangju].JiaFangYuLi;
			else
				defencenum=defencenum+ gpGlobals->g.pThingsList[gpGlobals->g.pPersonList[eid].Fangju].JiaFangYuLi +
						gpGlobals->g.pThingsList[gpGlobals->g.pPersonList[eid].Fangju].JiaFangYuLi/10;
		}
		//defencenum=defencenum+ gpGlobals->g.pThingsList[gpGlobals->g.pPersonList[eid].Fangju].JiaFangYuLi;	
	}
	defencenum=defencenum+emenywuxue;

	short hurt=(fightnum-3*defencenum)*2/3+rand()%20-rand()%20;
	if(hurt < 0)
		hurt=rand() %10 + rand()%4-rand()%4;
	if (hurt < 0)
		hurt=0;

	hurt=hurt+gpGlobals->g.pPersonList[pid].Tili/15+gpGlobals->g.pPersonList[eid].ShouShang/(g_ishoushangMax/5);

	short offset = abs(gpGlobals->g.war.warGroup[gpGlobals->g.war.iCurID].x - gpGlobals->g.war.warGroup[emenyid].x) +
					abs(gpGlobals->g.war.warGroup[gpGlobals->g.war.iCurID].y - gpGlobals->g.war.warGroup[emenyid].y);
	if(offset <10)
		hurt=hurt*(100-(offset-1)*3)/100;
    else
        hurt=hurt*2/3;

	if(hurt < 0)
		hurt=rand() %8 + 1;

	JY_SetPersonStatus(enum_hp,eid,-hurt,FALSE);
	JY_SetPersonStatus(enum_ShouShang,eid,hurt/g_iModShouShang,FALSE);

	gpGlobals->g.war.warGroup[gpGlobals->g.war.iCurID].iExp += hurt/5;

	if(gpGlobals->g.pPersonList[eid].hp <= 0)
		gpGlobals->g.war.warGroup[gpGlobals->g.war.iCurID].iExp += gpGlobals->g.pPersonList[eid].grade * 10;

	short poisonnum = level*gpGlobals->g.pWuGongList[wugong].DiRenZhongDu+gpGlobals->g.pPersonList[pid].GongjiDaiDu;
	if(gpGlobals->g.pPersonList[eid].KangDu<poisonnum && gpGlobals->g.pPersonList[eid].KangDu < 90)
	{
		JY_SetPersonStatus(enum_ZhongDu,eid,poisonnum/15,FALSE);
	}
	return hurt;
}
//计算武功伤害内力
short War_WugongHurtNeili(short emenyid,short wugong,short level)
{
	short pid = -1;
	pid = gpGlobals->g.war.warGroup[gpGlobals->g.war.iCurID].iPerson;
	short eid = -1;
	eid = gpGlobals->g.war.warGroup[emenyid].iPerson;
	
	short addvalue=gpGlobals->g.pWuGongList[wugong].JiaNeiLi[level];
	short decvalue=gpGlobals->g.pWuGongList[wugong].ShaShangNeiLi[level];
	if (addvalue > 0)
	{
		JY_SetPersonStatus(enum_NeiliMax,pid,rand() % (addvalue/2),FALSE);
		JY_SetPersonStatus(enum_Neili,pid,addvalue + rand()%3 - rand()%3,FALSE);
	}
	short v=decvalue+rand()%3 - rand()%3;
	JY_SetPersonStatus(enum_Neili,eid,-v,FALSE);

	return -v;
}
//战斗是否结束
short War_isEnd(VOID)
{
	short i=0;
	for(i=0;i<gpGlobals->g.war.iPersonNum;i++)
	{
		if (gpGlobals->g.war.iType == 0)
		{
			if(gpGlobals->g.pPersonList[gpGlobals->g.war.warGroup[i].iPerson ].hp <=0)
				gpGlobals->g.war.warGroup[i].bDie = TRUE;
		}
	}
	WarSetPerson();

	short myNum=0;
	short EmenyNum=0;

	for(i=0;i<gpGlobals->g.war.iPersonNum;i++)
	{
		if(gpGlobals->g.war.warGroup[i].bDie == FALSE)
		{
			if (gpGlobals->g.war.warGroup[i].bSelf == TRUE)
				myNum = 1;
			else
				EmenyNum = 1;
		}
	}
	if (EmenyNum==0)
		return 1;
	if (myNum==0)
		return 2;
	return 0;
}
//计算战斗后每回合由于中毒或受伤而掉血
VOID War_PersonLostLife(VOID)
{
	short i=0;
	for(i=0;i<gpGlobals->g.war.iPersonNum;i++)
	{
		short pid = gpGlobals->g.war.warGroup[i].iPerson;
		if(gpGlobals->g.war.warGroup[i].bDie == FALSE)
		{
			if (gpGlobals->g.pPersonList[pid].ShouShang > 0)
			{
				short dec = gpGlobals->g.pPersonList[pid].ShouShang/20;
				JY_SetPersonStatus(enum_hp,pid,-dec,FALSE);
			}
			if (gpGlobals->g.pPersonList[pid].ZhongDu > 0)
			{
				short dec = gpGlobals->g.pPersonList[pid].ZhongDu/g_iModZhongDu;
				JY_SetPersonStatus(enum_hp,pid,-dec,FALSE);
			}
			if (gpGlobals->g.pPersonList[pid].hp <= 0)
			{
				if (gpGlobals->g.war.iType == 0)
				{
					//gpGlobals->g.pPersonList[pid].hp = 1;
					gpGlobals->g.war.warGroup[i].bDie = TRUE;
				}
				else
				{
					gpGlobals->g.pPersonList[pid].hp = gpGlobals->g.pPersonList[pid].hpMax;
				}
			}
		}
		if (gpGlobals->g.war.iType == 1 && gpGlobals->g.war.iRound == 1 && gpGlobals->g.war.warGroup[i].bSelf == FALSE)
		{
			gpGlobals->g.war.warGroup[i].bDie = TRUE;
		}
	}
}
//战斗以后设置人物参数
VOID War_EndPersonData(short isexp,short warStatus)
{
	short i=0;
	for(i=0;i<gpGlobals->g.war.iPersonNum;i++)
	{
		short pid = gpGlobals->g.war.warGroup[i].iPerson;
		if (gpGlobals->g.war.warGroup[i].bSelf == FALSE)
		{
			gpGlobals->g.pPersonList[pid].hp = gpGlobals->g.pPersonList[pid].hpMax;
			gpGlobals->g.pPersonList[pid].Neili = gpGlobals->g.pPersonList[pid].NeiliMax;
			gpGlobals->g.pPersonList[pid].Tili = g_itiliMax;
			gpGlobals->g.pPersonList[pid].ShouShang = 0;
			gpGlobals->g.pPersonList[pid].ZhongDu = 0;
		}
	}
	if (warStatus==2 && isexp==0)
		return;
	short liveNum=0; 
	for(i=0;i<gpGlobals->g.war.iPersonNum;i++)
	{
		short pid = gpGlobals->g.war.warGroup[i].iPerson;
		if (gpGlobals->g.war.warGroup[i].bSelf == TRUE && gpGlobals->g.war.warGroup[i].bDie == FALSE)
		{
			liveNum++;
		}
	}
	if (warStatus==1)
	{
		for(i=0;i<gpGlobals->g.war.iPersonNum;i++)
		{
			short pid = gpGlobals->g.war.warGroup[i].iPerson;
			if (gpGlobals->g.war.warGroup[i].bSelf == TRUE && gpGlobals->g.war.warGroup[i].bDie == FALSE)
			{
				gpGlobals->g.war.warGroup[i].iExp+=gpGlobals->g.war.pWarSta->iExp/liveNum;
			}
		}
	}
	for(i=0;i<gpGlobals->g.war.iPersonNum;i++)
	{
		short pid = gpGlobals->g.war.warGroup[i].iPerson;
		if (gpGlobals->g.war.warGroup[i].bSelf == TRUE )
		{
			if (gpGlobals->g.pPersonList[pid].hp<gpGlobals->g.pPersonList[pid].hpMax/5)
			{
				gpGlobals->g.pPersonList[pid].hp = gpGlobals->g.pPersonList[pid].hpMax/5;
			}
			if (gpGlobals->g.pPersonList[pid].Tili<10)
			{
				gpGlobals->g.pPersonList[pid].Tili = 10;
			}
		}
	}
	for(i=0;i<gpGlobals->g.war.iPersonNum;i++)
	{
		short pid = gpGlobals->g.war.warGroup[i].iPerson;
		if (gpGlobals->g.pPersonList[pid].XiuLianWuPin >= 0)
		{
			JY_SetPersonStatus(enum_WuPinXiuLian,pid,gpGlobals->g.war.warGroup[i].iExp *8/10,FALSE);
			JY_SetPersonStatus(enum_XiuLianDianShu,pid,gpGlobals->g.war.warGroup[i].iExp *8/10,FALSE);
		}
		if (gpGlobals->g.pPersonList[pid].grade < 30)//满级后不得经验
			JY_SetPersonStatus(enum_exp,pid,gpGlobals->g.war.warGroup[i].iExp,FALSE);
		if (gpGlobals->g.war.warGroup[i].bSelf == TRUE )
		{
			BYTE bufText[30] = {0};
			int iLen = 0;
			for(int j=0;j< 10;j++)
			{
				if (gpGlobals->g.pPersonList[pid].name1big5[j] == 0)
				{
					bufText[j] =0;
					break;
				}
				bufText[j] = gpGlobals->g.pPersonList[pid].name1big5[j] ;//^ 0xFF;
				iLen++;
			}
			Big5toUnicode(bufText,iLen);

			WarDrawMap(0,0,0);
			LPSTR pNew = NULL;
			pNew = va("%s 获得经验点数 %d ",bufText,gpGlobals->g.war.warGroup[i].iExp);
			
			JY_DrawTextDialog(pNew,JY_XY(g_wInitialWidth/2,g_iFontSize),TRUE,TRUE,TRUE);
			SafeFree(pNew);
			
			short r=War_AddPersonLevel(pid);
			if (r == 1)
			{
				WarDrawMap(0,0,0);
				pNew = va("%s 升级了",bufText);
				JY_DrawTextDialog(pNew,JY_XY(g_wInitialWidth/2,g_iFontSize),TRUE,TRUE,TRUE);
				SafeFree(pNew);
			}
			
		}
		War_PersonTrainBook(pid);            //修炼秘籍
        War_PersonTrainDrug(pid);           //修炼药品
	}
}
//人物升级
short War_AddPersonLevel(short pid)
{
	//static ushort ExpList[31] = {0,50,    150,     300 ,500   , 750 ,
 //              1050,  1400,   1800 ,2250  , 2750 ,
 //              3850,  5050,   6350 ,7750  , 9250 ,
 //              10850, 12550, 14350 ,16750 , 18250 ,
 //              21400, 24700, 28150 ,31750 , 35500 ,
	//           39400, 43450, 47650 ,52000 , 60000  };

	short tmplevel=gpGlobals->g.pPersonList[pid].grade;

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

	if (tmplevel >=g_iGradMax)
		return 0;
	if (gpGlobals->g.pPersonList[pid].exp < iLeveExp)
		return 0;
	while(1)
	{
		if (tmplevel >=g_iGradMax)
			break;
		if (gpGlobals->g.pPersonList[pid].exp >= iLeveExp)
		{
			tmplevel++;
			sprintf(cLeve,"%d",tmplevel);
			if (GetIniValue(cFile, "LEVE", cLeve, "-1", buf))
				iLeveExp = atoi(buf);
			if (iLeveExp == -1)
				iLeveExp = 50 * tmplevel;
		}
		else
			break;
	}
	short leveladd = tmplevel - gpGlobals->g.pPersonList[pid].grade;

	gpGlobals->g.pPersonList[pid].grade = gpGlobals->g.pPersonList[pid].grade + leveladd;
	short iTemp = (gpGlobals->g.pPersonList[pid].HpAdd + rand() % 3) * leveladd * 3;
	JY_SetPersonStatus(enum_hpMax,pid,iTemp,FALSE);
	gpGlobals->g.pPersonList[pid].hp = gpGlobals->g.pPersonList[pid].hpMax;
	gpGlobals->g.pPersonList[pid].Tili = g_itiliMax;
	gpGlobals->g.pPersonList[pid].ShouShang = 0;
	gpGlobals->g.pPersonList[pid].ZhongDu = 0;

	short cleveradd = 0;
	if (gpGlobals->g.pPersonList[pid].ZiZhi < 30)
		cleveradd = 2;
	else if (gpGlobals->g.pPersonList[pid].ZiZhi < 50)
		cleveradd = 3;
	else if (gpGlobals->g.pPersonList[pid].ZiZhi < 70)
		cleveradd = 4;
	else if (gpGlobals->g.pPersonList[pid].ZiZhi < 90)
		cleveradd = 5;
	else 
		cleveradd = 6;
	cleveradd = rand()%cleveradd+1;
	iTemp = (9-cleveradd)*leveladd*4;
	JY_SetPersonStatus(enum_NeiliMax,pid,iTemp,FALSE);
	gpGlobals->g.pPersonList[pid].Neili = gpGlobals->g.pPersonList[pid].NeiliMax;

	JY_SetPersonStatus(enum_GongJiLi,pid,cleveradd*leveladd,FALSE);
	JY_SetPersonStatus(enum_FangYuLi,pid,cleveradd*leveladd,FALSE);
	JY_SetPersonStatus(enum_QingGong,pid,cleveradd*leveladd,FALSE);
	if (gpGlobals->g.pPersonList[pid].YiLiao > 20)
		JY_SetPersonStatus(enum_YiLiao,pid,rand()%3,FALSE);
	if (gpGlobals->g.pPersonList[pid].YongDu > 20)
		JY_SetPersonStatus(enum_YongDu,pid,rand()%3,FALSE);
	if (gpGlobals->g.pPersonList[pid].JieDu > 20)
		JY_SetPersonStatus(enum_JieDu,pid,rand()%3,FALSE);
	if (gpGlobals->g.pPersonList[pid].QuanZhang > 20)
		JY_SetPersonStatus(enum_QuanZhang,pid,rand()%3,FALSE);
	if (gpGlobals->g.pPersonList[pid].YuJian > 20)
		JY_SetPersonStatus(enum_YuJian,pid,rand()%3,FALSE);
	if (gpGlobals->g.pPersonList[pid].ShuaDao > 20)
		JY_SetPersonStatus(enum_ShuaDao,pid,rand()%3,FALSE);
	if (gpGlobals->g.pPersonList[pid].AnQiJiQiao > 20)
		JY_SetPersonStatus(enum_AnQiJiQiao,pid,rand()%3,FALSE);

	return 1;
}
//修炼秘籍
VOID War_PersonTrainBook(short pid)
{
	short thingid = gpGlobals->g.pPersonList[pid].XiuLianWuPin;
	if (thingid < 0)
		return;
	short wugongid = gpGlobals->g.pThingsList[thingid].LianChuWuGong;

	ushort needpoint=TrainNeedExp(pid);
	if (gpGlobals->g.pPersonList[pid].XiuLianDianShu >= needpoint)
	{
		JY_SetPersonStatus(enum_hpMax,pid,gpGlobals->g.pThingsList[thingid].JiaSHengMingZuiDa,FALSE);
		if (gpGlobals->g.pThingsList[thingid].GaiBianNeiLiXingZhi == 2)
			JY_SetPersonStatus(enum_NeiliXingZhi,pid,gpGlobals->g.pThingsList[thingid].GaiBianNeiLiXingZhi,FALSE);
		JY_SetPersonStatus(enum_NeiliMax,pid,gpGlobals->g.pThingsList[thingid].JiaNeiLiZuiDa,FALSE);
		JY_SetPersonStatus(enum_GongJiLi,pid,gpGlobals->g.pThingsList[thingid].JiaGongJiLi,FALSE);
		JY_SetPersonStatus(enum_QingGong,pid,gpGlobals->g.pThingsList[thingid].JiaQingGong,FALSE);
		JY_SetPersonStatus(enum_FangYuLi,pid,gpGlobals->g.pThingsList[thingid].JiaFangYuLi,FALSE);
		JY_SetPersonStatus(enum_YiLiao,pid,gpGlobals->g.pThingsList[thingid].JiaYiLiao,FALSE);
		JY_SetPersonStatus(enum_YongDu,pid,gpGlobals->g.pThingsList[thingid].JiaShiDu,FALSE);
		JY_SetPersonStatus(enum_JieDu,pid,gpGlobals->g.pThingsList[thingid].JiaJieDu,FALSE);
		JY_SetPersonStatus(enum_KangDu,pid,gpGlobals->g.pThingsList[thingid].JiaKangDu,FALSE);
		JY_SetPersonStatus(enum_QuanZhang,pid,gpGlobals->g.pThingsList[thingid].JiaQuanZhang,FALSE);
		JY_SetPersonStatus(enum_YuJian,pid,gpGlobals->g.pThingsList[thingid].JiaYuJian,FALSE);
		JY_SetPersonStatus(enum_ShuaDao,pid,gpGlobals->g.pThingsList[thingid].JiaShuaDao,FALSE);
		JY_SetPersonStatus(enum_TeSHuBingQi,pid,gpGlobals->g.pThingsList[thingid].JiaTeShuBingQi,FALSE);
		JY_SetPersonStatus(enum_AnQiJiQiao,pid,gpGlobals->g.pThingsList[thingid].JiaAnQiJiQiao,FALSE);
		JY_SetPersonStatus(enum_PinDe,pid,gpGlobals->g.pThingsList[thingid].JiaPinDe,FALSE);
		JY_SetPersonStatus(enum_WuXueChangShi,pid,gpGlobals->g.pThingsList[thingid].JiaWuXueChangShi,FALSE);
		JY_SetPersonStatus(enum_GongjiDaiDu,pid,gpGlobals->g.pThingsList[thingid].JiaGongFuDaiDu,FALSE);
		
		if (gpGlobals->g.pThingsList[thingid].JiaGongJiCiShu == 1)
			JY_SetPersonStatus(enum_ZuoYouHuBo,pid,1,FALSE);

		gpGlobals->g.pPersonList[pid].XiuLianDianShu = 0;

		if (wugongid >=0)
		{
			short oldwugong=0;
			short i=0;
			for(i=0;i<10;i++)
			{
				if (gpGlobals->g.pPersonList[pid].WuGong[i] == wugongid)
				{
					oldwugong=1;
					gpGlobals->g.pPersonList[pid].WuGongDengji[i] = gpGlobals->g.pPersonList[pid].WuGongDengji[i] +100;
					break;
				}
			}
			if (oldwugong == 0)
			{
				JY_SetPersonStatus(enum_XueHuiWuGong,pid,wugongid,TRUE);
			}
		}

	}
}
//计算修炼成功需要点数
ushort TrainNeedExp(short pid)
{
	short thingid = gpGlobals->g.pPersonList[pid].XiuLianWuPin;
	
	ushort r = 0;
	short i = 0;
	if (thingid >=0)
	{
		short wugongid = gpGlobals->g.pThingsList[thingid].LianChuWuGong;
		if (wugongid >=0)
		{
			short level =0;
			for(i=0;i<10;i++)
			{
				if (gpGlobals->g.pPersonList[pid].WuGong[i] == wugongid)
				{
					level = gpGlobals->g.pPersonList[pid].WuGongDengji[i]/100;
					break;
				}
			}
			if(level < 9)
				r = (7-gpGlobals->g.pPersonList[pid].ZiZhi/15) * gpGlobals->g.pThingsList[thingid].XuExpLianChengMiJi * (level+1);
			else
				r =-1;//最大
		}
		else
		{
			r=(7-gpGlobals->g.pPersonList[pid].ZiZhi/15) * gpGlobals->g.pThingsList[thingid].XuExpLianChengMiJi * 2;
		}
	}
	return r;
}
//战斗后是否修炼出物品
VOID War_PersonTrainDrug(short pid)
{
	short thingid = gpGlobals->g.pPersonList[pid].XiuLianWuPin;
	if (thingid < 0)
		return;
	if (gpGlobals->g.pThingsList[thingid].XuExpLianChuWuPin <=0)
		return;

	ushort needpoint= (7-gpGlobals->g.pPersonList[pid].ZiZhi/15) * gpGlobals->g.pThingsList[thingid].XuExpLianChuWuPin;

	if (gpGlobals->g.pPersonList[pid].WuPinXiuLian >= needpoint)
	{
		short haveMaterial=0;
		short MaterialNum=-1;
		short i=0;
		for(i=0;i<200;i++)
		{
			if (gpGlobals->g.pBaseList->WuPin[i][0] == gpGlobals->g.pThingsList[thingid].XuCaiLiao)
			{
				haveMaterial=1;
				MaterialNum = gpGlobals->g.pBaseList->WuPin[i][1];
			}
		}
		
		if(haveMaterial == 1)
		{
			short enough[5][2]={0};
			short canMake=0;
			for(i=0;i<5;i++)
			{
				if (MaterialNum >= gpGlobals->g.pThingsList[thingid].XuYaoWuPinShuLiang[i])
				{
					canMake = 1;
					enough[i][0] = gpGlobals->g.pThingsList[thingid].LianChuWuPin[i];
					enough[i][1] = gpGlobals->g.pThingsList[thingid].XuYaoWuPinShuLiang[i];
				}
				else
				{
					enough[i][0] = -1;
					enough[i][1] = 0;
				}
			}
			if(canMake == 1)
			{
				short makeID=-1;
				while(1)
				{
					makeID = rand() %5;
					makeID = limitX(makeID,0,4);
					if(enough[makeID][0]>=0)
						break;
				}
				
				//
				if (JY_FindThing(enough[makeID][0]) == -1 )
					JY_ThingSet(enough[makeID][0],1);
				else
					JY_ThingSet(enough[makeID][0],rand()%3+1);
				//
				JY_ThingSet(gpGlobals->g.pThingsList[thingid].XuCaiLiao,-enough[makeID][1]);
				//
				gpGlobals->g.pPersonList[pid].WuPinXiuLian = 0;
			}
		}

	}
}

//战斗物品菜单
short War_ThingMenu(VOID)
{
	bool bExit = false;
	short iCurrentItem = gpGlobals->g.iLastUseThingNum;	
	if (iCurrentItem >=gpGlobals->g.iHaveThingsNum)
		iCurrentItem = gpGlobals->g.iHaveThingsNum -1;
	if (iCurrentItem < 0)
		iCurrentItem = 0;

	short iFristItem = 0;
	short iEndItem = 0;
	short iDrawNum = -1;

	short iW = 0;
	short iH = 0;
	if (g_iThingPicList == 0)
	{
		iW = 2;
		iEndItem = (g_wInitialHeight -((g_iFontSize+4)*3 +15)) / (g_iFontSize+4) * 2 ;
		iH = iEndItem / 2;
	}
	else
	{
		iH = (g_wInitialHeight -((g_iFontSize+4)*3 +15)) / 41*g_iZoom;
		if ( ((g_wInitialHeight -((g_iFontSize+4)*3 +15)) % 41*g_iZoom) > 35*g_iZoom)
			iH++;
		iW = (g_wInitialWidth - ((g_iFontSize+4)*3 +15)) / 41*g_iZoom;
		if ( ((g_wInitialWidth - ((g_iFontSize+4)*3 +15)) % 41*g_iZoom) > 35*g_iZoom)
			iW++;
		iEndItem = iW * iH;
	}
	short iSpit = iEndItem/2;

	iFristItem = iCurrentItem;
	iEndItem = iFristItem+iEndItem;

	short iSelectItem = -1;
	short iSelectType = -1;
	short iSelectPersonIdx = -1;
	short iTemp = 0;
	char *pChar = NULL;

	JY_VideoRestoreScreen(1);
	iDrawNum =JY_DrawThingDilag(iFristItem,iCurrentItem,iEndItem,1);
	JY_ShowSurface();
	while(!bExit)
	{
		JY_ClearKeyState();
		JY_ProcessEvent();		
		if (g_InputState.dwKeyPress & kKeyRight)//else if (g_InputState.dir == kDirEast )//
		{
			if (g_iThingPicList == 0)
			{
				if (iCurrentItem < iFristItem + iSpit)//一页左半部
				{
					if(iCurrentItem+iSpit < iDrawNum)
						iCurrentItem+=iSpit;
					else
						iCurrentItem=iDrawNum-1;
				}
				else
				{
					if (iCurrentItem+iSpit < gpGlobals->g.iHaveThingsNum)
					{
						iCurrentItem+=iSpit;
						iFristItem+=iSpit*2;
						iEndItem+=iSpit*2;
					}
					else
					{
						iFristItem+=iSpit;
						iEndItem+=iSpit;
					}
				}
			}
			else
			{
				if (iCurrentItem+1 < iEndItem)
				{
					if (iCurrentItem+1 <iDrawNum)
						iCurrentItem++;
				}
				else
				{
					if(iCurrentItem+1 < 200)
					{
						iFristItem+=iW;
						iEndItem+=iW;
					}
				}
			}
			JY_VideoRestoreScreen(1);
			iDrawNum =JY_DrawThingDilag(iFristItem,iCurrentItem,iEndItem,1);
			JY_ShowSurface();
		}
		else if (g_InputState.dwKeyPress & kKeyDown )//if (g_InputState.dir == kDirSouth )//
		{
			if (g_iThingPicList == 0)
			{
				if (iCurrentItem < iDrawNum-1)//
				{
					iCurrentItem++;
				}
				else
				{
					if (iDrawNum == iEndItem)
					{
						if (iCurrentItem+1 < gpGlobals->g.iHaveThingsNum)
						{
							iCurrentItem++;
							iFristItem++;
							iEndItem++;
						}	
						else
						{
							iFristItem++;
							iEndItem++;
						}
					}
				}
			}
			else
			{
				if (iCurrentItem+iW < iEndItem)
				{
					if (iCurrentItem+iW <iDrawNum)
						iCurrentItem+=iW;
				}
				else
				{
					if(iCurrentItem+iW < 200)
					{
						iFristItem+=iW;
						iEndItem+=iW;
					}
				}
			}
			JY_VideoRestoreScreen(1);
			iDrawNum =JY_DrawThingDilag(iFristItem,iCurrentItem,iEndItem,1);
			JY_ShowSurface();
		}
		else if (g_InputState.dwKeyPress &  kKeyLeft)//else if (g_InputState.dir == kDirWest )//
		{		
			if (g_iThingPicList == 0)
			{
				if (iCurrentItem < iFristItem + iSpit)//一页左半部
				{
					if (iCurrentItem - iSpit > 0)
					{
						if ( (iFristItem - iSpit*2) >= 0)
						{
							iCurrentItem-=iSpit;
							iFristItem -=iSpit*2;
							iEndItem-=iSpit*2;
						}
						else
						{
							iFristItem = 0;
							iEndItem = (g_wInitialHeight -((g_iFontSize+4)*3 +15)) / (g_iFontSize+4) * 2 ;
						}
					}
					else
					{
						iCurrentItem=0;
						iFristItem = 0;
						iEndItem = (g_wInitialHeight -((g_iFontSize+4)*3 +15)) / (g_iFontSize+4) * 2 ;
					}
				}
				else
				{
					iCurrentItem-=iSpit;
				}
			}
			else
			{
				if (iCurrentItem-1>=iFristItem)
				{
					iCurrentItem--;
				}
				else
				{
					if (iFristItem-iW > 0)
					{
						iFristItem-=iW;
						iEndItem-=iW;
					}
					else
					{
						iFristItem=0;
						iCurrentItem=0;
						iEndItem=iW * iH;
					}
				}
			}
			JY_VideoRestoreScreen(1);
			iDrawNum = JY_DrawThingDilag(iFristItem,iCurrentItem,iEndItem,1);
			JY_ShowSurface();
		}
		else if (g_InputState.dwKeyPress & kKeyUp )//else if (g_InputState.dir == kDirNorth )//
		{		
			if (g_iThingPicList == 0)
			{
				if (iCurrentItem < iFristItem + iSpit)//一页左半部
				{
					if (iCurrentItem == iFristItem)
					{
						if (iCurrentItem -1 >= 0)
						{
							iCurrentItem--;
							iFristItem--;
							iEndItem--;
						}
						else
						{
							iCurrentItem=0;
							iFristItem=0;
							iEndItem =(g_wInitialHeight -((g_iFontSize+4)*3 +15)) / (g_iFontSize+4) * 2 ;
						}
					}
					else
					{
						iCurrentItem--;
					}
				}
				else
				{
					iCurrentItem--;
				}
			}
			else
			{
				if (iCurrentItem-iW>=iFristItem)
				{
					iCurrentItem-=iW;
				}
				else
				{
					if (iFristItem-iW > 0)
					{
						iFristItem-=iW;
						iEndItem-=iW;
					}
					else
					{
						iFristItem=0;
						iCurrentItem=0;
						iEndItem=iW * iH;
					}
				}
			}
			JY_VideoRestoreScreen(1);
			iDrawNum = JY_DrawThingDilag(iFristItem,iCurrentItem,iEndItem,1);
			JY_ShowSurface();
		}
		else if (g_InputState.dwKeyPress & kKeySearch)
		{
			gpGlobals->g.iLastUseThingNum = iCurrentItem;
			iSelectItem = gpGlobals->g.pBaseList->WuPin[iCurrentItem][0];
			iSelectType = gpGlobals->g.pThingsList[iSelectItem].LeiXing;
			if (iSelectType == 0 || iSelectType == 1 || iSelectType == 2  )
			{
				continue;
			}
			else 
			{
				bExit = true;
				JY_VideoRestoreScreen(1);
				JY_ShowSurface();
			}
			
		}
		else if (g_InputState.dwKeyPress & kKeyMenu)
		{
			iSelectItem = -1;
			JY_VideoRestoreScreen(1);
			JY_ShowSurface();
			bExit = true;
		}
		SDL_Delay(50);
	}
	return iSelectItem;
}
//等待，把当前战斗人调到队尾
short War_WaitMenu(VOID)
{
	short i=0;
	short r=0;
	for(i=gpGlobals->g.war.iCurID;i<gpGlobals->g.war.iPersonNum-1;i++)
	{
		WARGROUP tmp0 = gpGlobals->g.war.warGroup[i+1];
		gpGlobals->g.war.warGroup[i+1] = gpGlobals->g.war.warGroup[i];
		gpGlobals->g.war.warGroup[i] = tmp0;
		r=1;
	}

	WarSetPerson();

	for(i=0;i<gpGlobals->g.war.iPersonNum;i++)
	{
		gpGlobals->g.war.warGroup[i].iPicCode = WarCalPersonPic(i);
	}
	return r;
}
//战斗中显示状态
VOID War_StatusMenu(VOID)
{
	JY_ThingDilagBack(5);

	short i = -1;
	for(i=0;i<6;i++)
	{
		if(gpGlobals->g.war.warGroup[gpGlobals->g.war.iCurID].iPerson == gpGlobals->g.pBaseList->Group[i])
		{
			break;
		}
	}
	if (i>=0)
	{
		JY_DrawPersonStatus(i);
		JY_ShowSurface();
		WaitKey();
	}

}
//显示场景名称
VOID JY_DrawSceneName(VOID)
{
	char *pChar = va("%s",gpGlobals->g.pSceneTypeList[gpGlobals->g.iSceneNum].Name1);
	if (pChar != NULL)
	{
		Big5toUnicode((LPBYTE)pChar,strlen(pChar));
			
		JY_DrawStr(10,g_wInitialHeight-(g_iFontSize+4),pChar,HUANGCOLOR,0,FALSE,FALSE);
	}		
	 SafeFree(pChar);
}
//传送地图
INT JY_TransMap(VOID)
{
	bool bExit = false;
	short iCurrentItem = gpGlobals->g.iLastUseTransNum;
	if (iCurrentItem < 0)
		iCurrentItem = 0;

	short iFristItem = 0;
	short iEndItem = (g_wInitialHeight - ((g_iFontSize+4)*2+35)) / (g_iFontSize+4)*2;
	short iSpit = iEndItem / 2;
	short iDrawNum = -1;
	
	iFristItem = iCurrentItem;
	iEndItem = iFristItem+iEndItem;

	short iSelectItem = -1;
	short iSelectType = -1;
	short iSelectPersonIdx = -1;
	short iTemp = 0;
	char *pChar = NULL;
	INT r = -1;
	JY_VideoRestoreScreen(1);
	iDrawNum =JY_DrawTransDilag(iFristItem,iCurrentItem,iEndItem);
	JY_ShowSurface();
	while(!bExit)
	{
		JY_ClearKeyState();
		JY_ProcessEvent();		
		if (g_InputState.dwKeyPress & kKeyRight)//else if (g_InputState.dir == kDirEast )//
		{
			if (iCurrentItem < iFristItem + iSpit)//一页左半部
			{
				if(iCurrentItem+iSpit < iDrawNum)
					iCurrentItem+=iSpit;
				else
					iCurrentItem=iDrawNum-1;
			}
			else
			{
				if (iCurrentItem+iSpit < 84)
				{
					iCurrentItem+=iSpit;
					iFristItem+=iSpit*2;
					iEndItem+=iSpit*2;
				}
				else
				{
					iFristItem+=iSpit;
					iEndItem+=iSpit;
				}
			}
			JY_VideoRestoreScreen(1);
			iDrawNum =JY_DrawTransDilag(iFristItem,iCurrentItem,iEndItem);
			JY_ShowSurface();
		}
		else if (g_InputState.dwKeyPress & kKeyDown )//if (g_InputState.dir == kDirSouth )//
		{
			if (iCurrentItem < iDrawNum-1)//
			{
				iCurrentItem++;
			}
			else
			{
				if (iDrawNum == iEndItem)
				{
					if (iCurrentItem+1 < 84)
					{
						iCurrentItem++;
						iFristItem++;
						iEndItem++;
					}	
					else
					{
						iFristItem++;
						iEndItem++;
					}
				}
			}
			JY_VideoRestoreScreen(1);
			iDrawNum =JY_DrawTransDilag(iFristItem,iCurrentItem,iEndItem);
			JY_ShowSurface();
		}
		else if (g_InputState.dwKeyPress &  kKeyLeft)//else if (g_InputState.dir == kDirWest )//
		{		
			if (iCurrentItem < iFristItem + iSpit)//一页左半部
			{
				if (iCurrentItem - iSpit > 0)
				{
					if ( (iFristItem - iSpit*2) >= 0)
					{
						iCurrentItem-=iSpit;
						iFristItem -=iSpit*2;
						iEndItem-=iSpit*2;
					}
					else
					{
						iFristItem = 0;
						iEndItem = (g_wInitialHeight -75) / 20 * 2 ;
					}
				}
				else
				{
					iCurrentItem=0;
					iFristItem = 0;
					iEndItem = (g_wInitialHeight -75) / 20 * 2 ;
				}
			}
			else
			{
				iCurrentItem-=iSpit;
			}
			JY_VideoRestoreScreen(1);
			iDrawNum =JY_DrawTransDilag(iFristItem,iCurrentItem,iEndItem);
			JY_ShowSurface();
		}
		else if (g_InputState.dwKeyPress & kKeyUp )//else if (g_InputState.dir == kDirNorth )//
		{		

			if (iCurrentItem < iFristItem + iSpit)//一页左半部
			{
				if (iCurrentItem == iFristItem)
				{
					if (iCurrentItem -1 >= 0)
					{
						iCurrentItem--;
						iFristItem--;
						iEndItem--;
					}
					else
					{
						iCurrentItem=0;
						iFristItem=0;
						iEndItem =(g_wInitialHeight -75) / 20 * 2 ;
					}
				}
				else
				{
					iCurrentItem--;
				}
			}
			else
			{
				iCurrentItem--;
			}
			JY_VideoRestoreScreen(1);
			iDrawNum =JY_DrawTransDilag(iFristItem,iCurrentItem,iEndItem);
			JY_ShowSurface();
		}
		else if (g_InputState.dwKeyPress & kKeySearch)
		{
			gpGlobals->g.iLastUseTransNum = iCurrentItem;
			//寻找出口处可以站的位置
			INT xMap1 = gpGlobals->g.pSceneTypeList[iCurrentItem].MMapInX1;
			INT yMap1 = gpGlobals->g.pSceneTypeList[iCurrentItem].MMapInY1;
			INT xMap2 = gpGlobals->g.pSceneTypeList[iCurrentItem].MMapInX2;
			INT yMap2 = gpGlobals->g.pSceneTypeList[iCurrentItem].MMapInY2;

			if (xMap1 == 0 && yMap1 == 0 && xMap2 == 0 && yMap2 ==0)//内场景
			{
				xMap1 = gpGlobals->g.pSceneTypeList[gpGlobals->g.pSceneTypeList[iCurrentItem].JumpScene].MMapInX1;
				yMap1 = gpGlobals->g.pSceneTypeList[gpGlobals->g.pSceneTypeList[iCurrentItem].JumpScene].MMapInY1;
				xMap2 = gpGlobals->g.pSceneTypeList[gpGlobals->g.pSceneTypeList[iCurrentItem].JumpScene].MMapInX2;
				yMap2 = gpGlobals->g.pSceneTypeList[gpGlobals->g.pSceneTypeList[iCurrentItem].JumpScene].MMapInY2;
			}
			if (JY_GetMMap(xMap1,yMap1+1,3) == 0 && JY_GetMMap(xMap1,yMap1+1,4) == 0)
			{
				r = JY_XY(xMap1,yMap1+1);
				JY_ClearKeyState();
				return r;
			}
			if (JY_GetMMap(xMap2,yMap2+1,3) == 0 && JY_GetMMap(xMap2,yMap2+1,4) == 0)
			{
				r = JY_XY(xMap2,yMap2+1);
				JY_ClearKeyState();
				return r;
			}

			if (JY_GetMMap(xMap1+1,yMap1,3) == 0 && JY_GetMMap(xMap1+1,yMap1,4) == 0)
			{
				r = JY_XY(xMap1+1,yMap1);
				JY_ClearKeyState();
				return r;
			}
			if (JY_GetMMap(xMap2+1,yMap2,3) == 0 && JY_GetMMap(xMap2+1,yMap2,4) == 0)
			{
				r = JY_XY(xMap2+1,yMap2);
				JY_ClearKeyState();
				return r;
			}

			if (JY_GetMMap(xMap1-1,yMap1,3) == 0 && JY_GetMMap(xMap1-1,yMap1,4) == 0)
			{
				r = JY_XY(xMap1-1,yMap1);
				JY_ClearKeyState();
				return r;
			}
			if (JY_GetMMap(xMap2-1,yMap2,3) == 0 && JY_GetMMap(xMap2-1,yMap2,4) == 0)
			{
				r = JY_XY(xMap2-1,yMap2);
				JY_ClearKeyState();
				return r;
			}

			if (JY_GetMMap(xMap1,yMap1-1,3) == 0 && JY_GetMMap(xMap1,yMap1-1,4) == 0)
			{
				r = JY_XY(xMap1,yMap1-1);
				JY_ClearKeyState();
				return r;
			}
			if (JY_GetMMap(xMap2,yMap2-1,3) == 0 && JY_GetMMap(xMap2,yMap2-1,4) == 0)
			{
				r = JY_XY(xMap2,yMap2-1);
				JY_ClearKeyState();
				return r;
			}
			bExit = true;
			
		}
		else if (g_InputState.dwKeyPress & kKeyMenu)
		{
			bExit = true;
		}
		SDL_Delay(20);
		//JY_ClearKeyState();
	}

	return r;
}
//商店
VOID JY_Shop(VOID)
{
	short headid=111;
	short id = -1;

	if (gpGlobals->g.iSceneNum == 1)
		id = 0;
	if (gpGlobals->g.iSceneNum == 3)
		id = 1;
	if (gpGlobals->g.iSceneNum == 40)
		id = 2;
	if (gpGlobals->g.iSceneNum == 60)
		id = 3;
	if (gpGlobals->g.iSceneNum == 61)
		id = 4;

	if (id == -1)
		return;

	JY_VideoBackupScreen(1);

	JY_DrawTalkDialog(2974,headid,0);

	short i=0;
	short j=0;
	short iNum = 0;
	LPMENUITEM pMenu = NULL;
	pMenu = (LPMENUITEM)malloc(sizeof(MENUITEM) * 5);
	for(i=0;i<5;i++)
	{
		short tmp = gpGlobals->g.pXiaoBaoList[id].WuPin[i];
		short tmpShuLiang = gpGlobals->g.pXiaoBaoList[id].WuPinShuLiang[i];
		short tmpJiaGe = gpGlobals->g.pXiaoBaoList[id].WuPinJiaGe[i];
		if (tmp >=0)
		{
			LPSTR buf = (LPSTR)malloc(22);
			int iLen = 0;
			for(j=0;j<20;j++)
			{
				if (gpGlobals->g.pThingsList[tmp].name1big5[j] == 0)
				{
					buf[j] = 0;
					break;
				}
				buf[j] = gpGlobals->g.pThingsList[tmp].name1big5[j] ;//^ 0xFF;
				iLen++;
			}

			Big5toUnicode((LPBYTE)buf,iLen);
			pMenu[iNum].pText = (LPSTR)malloc(32);
			//sprintf(pMenu[iNum].pText,"%-12s %5d",buf,tmpJiaGe);
			SafeFree(buf);
			pMenu[iNum].pos = JY_XY(g_wInitialWidth/2-80,g_wInitialHeight/2-20+iNum*(g_iFontSize+4));
			pMenu[iNum].wValue = iNum;
			pMenu[iNum].wNumWord=i;
			if (tmpShuLiang <= 0) 
				pMenu[iNum].fEnabled = FALSE;
			else
				pMenu[iNum].fEnabled = TRUE;
			iNum++;
		}
	}
	
	short r = -1;
	while(TRUE)
	{
		JY_VideoRestoreScreen(1);
		r= JY_ShowMenu(pMenu,NULL, iNum, 0, TRUE,TRUE,HUANGCOLOR,BAICOLOR);
		if (r >= 0)
		{
			short ig_iMoney = -1;
			for(int i=0;i<200;i++)
			{
				if (gpGlobals->g.pBaseList->WuPin[i][0] == g_iMoney)
				{
					ig_iMoney = gpGlobals->g.pBaseList->WuPin[i][1];
					break;
				}
			}
			if (gpGlobals->g.pXiaoBaoList[id].WuPinJiaGe[pMenu[r].wNumWord] >ig_iMoney)
			{
				JY_DrawTalkDialog(2975,headid,0);
			}
			else
			{
				gpGlobals->g.pXiaoBaoList[id].WuPinShuLiang[pMenu[r].wNumWord]--;
				if (gpGlobals->g.pXiaoBaoList[id].WuPinShuLiang[pMenu[r].wNumWord] <= 0)
					pMenu[r].fEnabled = FALSE;
				JY_ThingSet(gpGlobals->g.pXiaoBaoList[id].WuPin[pMenu[r].wNumWord],1);
				JY_ThingSet(g_iMoney,-gpGlobals->g.pXiaoBaoList[id].WuPinJiaGe[pMenu[r].wNumWord]);
				JY_DrawTalkDialog(2976,headid,0);
			}
		}
		else
		{
			break;
		}
	}
	SafeFree(pMenu);
	//设置离开

	short iOutEvent[3] = {-1,-1,-1};
	if (gpGlobals->g.iSceneNum == 1)
	{
		iOutEvent[0] = 17;
		iOutEvent[1] = 18;
	}
	if (gpGlobals->g.iSceneNum == 3)
	{
		iOutEvent[0] = 15;
		iOutEvent[1] = 16;
	}
	if (gpGlobals->g.iSceneNum == 40)
	{
		iOutEvent[0] = 21;
		iOutEvent[1] = 22;
	}
	if (gpGlobals->g.iSceneNum == 60)
	{
		iOutEvent[0] = 17;
		iOutEvent[1] = 18;
	}
	if (gpGlobals->g.iSceneNum == 61)
	{
		iOutEvent[0] = 10;
		iOutEvent[1] = 11;
		iOutEvent[2] = 12;
	}
	for(i=0;i<3;i++)
	{
		JY_SetD(gpGlobals->g.iSceneNum,iOutEvent[i],0,0);
		//gpGlobals->g.sceneEventList[gpGlobals->g.iSceneNum][iOutEvent[i]].isGo = 0;
		JY_SetD(gpGlobals->g.iSceneNum,iOutEvent[i],2,-1);
		//gpGlobals->g.sceneEventList[gpGlobals->g.iSceneNum][iOutEvent[i]].EventNum1 = -1;
		JY_SetD(gpGlobals->g.iSceneNum,iOutEvent[i],3,-1);
		//gpGlobals->g.sceneEventList[gpGlobals->g.iSceneNum][iOutEvent[i]].EventNum2 = -1;
		JY_SetD(gpGlobals->g.iSceneNum,iOutEvent[i],4,939);
		//gpGlobals->g.sceneEventList[gpGlobals->g.iSceneNum][iOutEvent[i]].EventNum3 = 939;
		JY_SetD(gpGlobals->g.iSceneNum,iOutEvent[i],5,-1);
		//gpGlobals->g.sceneEventList[gpGlobals->g.iSceneNum][iOutEvent[i]].PicNum[0] = -1;
		JY_SetD(gpGlobals->g.iSceneNum,iOutEvent[i],6,-1);
		//gpGlobals->g.sceneEventList[gpGlobals->g.iSceneNum][iOutEvent[i]].PicNum[1] = -1;
		JY_SetD(gpGlobals->g.iSceneNum,iOutEvent[i],7,-1);
		//gpGlobals->g.sceneEventList[gpGlobals->g.iSceneNum][iOutEvent[i]].PicNum[2] = -1;
	}
}
//商店移动
VOID JY_ShopMove()
{
	short id = -1;
	short iEvent = -1;
	short iOutEvent[3] = {-1,-1,-1};
	short iSceneId = -1;
	if (gpGlobals->g.iSceneNum == 1)
	{
		id = 0;
		iEvent = 16;
		iOutEvent[0] = 17;
		iOutEvent[1] = 18;
	}
	if (gpGlobals->g.iSceneNum == 3)
	{
		id = 1;
		iEvent = 14;
		iOutEvent[0] = 15;
		iOutEvent[1] = 16;
	}
	if (gpGlobals->g.iSceneNum == 40)
	{
		id = 2;
		iEvent = 20;
		iOutEvent[0] = 21;
		iOutEvent[1] = 22;
	}
	if (gpGlobals->g.iSceneNum == 60)
	{
		id = 3;
		iEvent = 16;
		iOutEvent[0] = 17;
		iOutEvent[1] = 18;
	}
	if (gpGlobals->g.iSceneNum == 61)
	{
		id = 4;
		iEvent = 9;
		iOutEvent[0] = 10;
		iOutEvent[1] = 11;
		iOutEvent[2] = 12;
	}

	if (id == -1)
		return;

	JY_SetD(gpGlobals->g.iSceneNum,iEvent,0,0);
	//gpGlobals->g.sceneEventList[gpGlobals->g.iSceneNum][iEvent].isGo = 0;
	JY_SetD(gpGlobals->g.iSceneNum,iEvent,2,-1);
	//gpGlobals->g.sceneEventList[gpGlobals->g.iSceneNum][iEvent].EventNum1 = -1;
	JY_SetD(gpGlobals->g.iSceneNum,iEvent,3,-1);
	//gpGlobals->g.sceneEventList[gpGlobals->g.iSceneNum][iEvent].EventNum2 = -1;
	JY_SetD(gpGlobals->g.iSceneNum,iEvent,4,-1);
	//gpGlobals->g.sceneEventList[gpGlobals->g.iSceneNum][iEvent].EventNum3 = -1;
	JY_SetD(gpGlobals->g.iSceneNum,iEvent,5,-1);
	//gpGlobals->g.sceneEventList[gpGlobals->g.iSceneNum][iEvent].PicNum[0] = -1;
	JY_SetD(gpGlobals->g.iSceneNum,iEvent,6,-1);
	//gpGlobals->g.sceneEventList[gpGlobals->g.iSceneNum][iEvent].PicNum[1] = -1;
	JY_SetD(gpGlobals->g.iSceneNum,iEvent,7,-1);
	//gpGlobals->g.sceneEventList[gpGlobals->g.iSceneNum][iEvent].PicNum[2] = -1;

	short i=0;
	for(i=0;i<3;i++)
	{
		JY_SetD(gpGlobals->g.iSceneNum,iOutEvent[i],0,0);
		//gpGlobals->g.sceneEventList[gpGlobals->g.iSceneNum][iOutEvent[i]].isGo = 0;
		JY_SetD(gpGlobals->g.iSceneNum,iOutEvent[i],2,-1);
		//gpGlobals->g.sceneEventList[gpGlobals->g.iSceneNum][iOutEvent[i]].EventNum1 = -1;
		JY_SetD(gpGlobals->g.iSceneNum,iOutEvent[i],3,-1);
		//gpGlobals->g.sceneEventList[gpGlobals->g.iSceneNum][iOutEvent[i]].EventNum2 = -1;
		JY_SetD(gpGlobals->g.iSceneNum,iOutEvent[i],4,-1);
		//gpGlobals->g.sceneEventList[gpGlobals->g.iSceneNum][iOutEvent[i]].EventNum3 = -1;
		JY_SetD(gpGlobals->g.iSceneNum,iOutEvent[i],5,-1);
		//gpGlobals->g.sceneEventList[gpGlobals->g.iSceneNum][iOutEvent[i]].PicNum[0] = -1;
		JY_SetD(gpGlobals->g.iSceneNum,iOutEvent[i],6,-1);
		//gpGlobals->g.sceneEventList[gpGlobals->g.iSceneNum][iOutEvent[i]].PicNum[1] = -1;
		JY_SetD(gpGlobals->g.iSceneNum,iOutEvent[i],7,-1);
		//gpGlobals->g.sceneEventList[gpGlobals->g.iSceneNum][iOutEvent[i]].PicNum[2] = -1;
	}
	srand((unsigned)SDL_GetTicks());
	short iNext = 0;
	iNext = rand() % 5;
	while(id == iNext)
	{
		iNext = rand() % 5;
	}
	//if (iNext < 0)
	//	iNext = 0;
	//if (iNext > 4)
	//	iNext = 4;
	if (iNext == 0)
	{
		iSceneId = 1;
		iEvent = 16;
	}
	if (iNext == 1)
	{
		iSceneId = 3;
		iEvent = 14;
	}
	if (iNext == 2)
	{
		iSceneId = 40;
		iEvent = 20;
	}
	if (iNext == 3)
	{
		iSceneId = 60;
		iEvent = 16;
	}
	if (iNext == 4)
	{
		iSceneId = 61;
		iEvent = 9;
	}
	JY_SetD(gpGlobals->g.iSceneNum,iEvent,0,1);
	//gpGlobals->g.sceneEventList[gpGlobals->g.iSceneNum][iEvent].isGo = 1;
	JY_SetD(gpGlobals->g.iSceneNum,iEvent,2,938);
	//gpGlobals->g.sceneEventList[gpGlobals->g.iSceneNum][iEvent].EventNum1 = 938;
	JY_SetD(gpGlobals->g.iSceneNum,iEvent,3,-1);
	//gpGlobals->g.sceneEventList[gpGlobals->g.iSceneNum][iEvent].EventNum2 = -1;
	JY_SetD(gpGlobals->g.iSceneNum,iEvent,4,-1);
	//gpGlobals->g.sceneEventList[gpGlobals->g.iSceneNum][iEvent].EventNum3 = -1;
	JY_SetD(gpGlobals->g.iSceneNum,iEvent,5,8256);
	//gpGlobals->g.sceneEventList[gpGlobals->g.iSceneNum][iEvent].PicNum[0] = 8256;
	JY_SetD(gpGlobals->g.iSceneNum,iEvent,6,8256);
	//gpGlobals->g.sceneEventList[gpGlobals->g.iSceneNum][iEvent].PicNum[1] = 8256;
	JY_SetD(gpGlobals->g.iSceneNum,iEvent,7,8256);
	//gpGlobals->g.sceneEventList[gpGlobals->g.iSceneNum][iEvent].PicNum[2] = 8256;	
}

//离队
short JY_PersonExit(short id)
{
	//short iExit[25][2] = {{1,950},{2,952},{9,954},{16,956},{17,958},
 //                  {25,960},{28,962},{29,964},{35,966},{36,968},
 //                  {37,970},{38,972},{44,974},{45,976},{47,978},
 //                  {48,980},{49,982},{51,984},{53,986},{54,988},
 //                  {58,990},{59,992},{61,994},{63,996},{76,998} };
	//short i=0;
	//short iFind = -1;
	//for(i=0;i< 25;i++)
	//{
	//	if (iExit[i][0] == id)
	//	{
	//		JY_RunTriggerScript(iExit[i][1],-1);
	//		iFind = 1;
	//	}
	//}
	short iFind = -1;
	char buf[20] = {0};
	char cPerson[20] = {0};
	sprintf(cPerson,"%d",id);
	char cFile[256] = {0};
	sprintf(cFile,"%s/mod.txt",JY_PREFIX);
	if (GetIniValue(cFile, "FALLOUT", cPerson, "-1", buf))
		iFind = atoi(buf);
	if (iFind > -1)
		JY_RunTriggerScript(iFind,-1);
	return 1;
}

//显示增加属性点数
VOID JY_ShowAttribAdd(short pid,short itype,short iNum)
{
	BYTE bufText[30] = {0};
	char *pChar = NULL;
	short iLen = 0;
	for(int j=0;j< 10;j++)
	{
		if (gpGlobals->g.pPersonList[pid].name1big5[j] == 0)
		{
			bufText[j] =0;
			break;
		}
		bufText[j] = gpGlobals->g.pPersonList[pid].name1big5[j] ;//^ 0xFF;
		iLen++;
	}
	Big5toUnicode(bufText,iLen);
	if (itype == enum_ZiZhi)
	{
		pChar = va("%s 增加资质%d",bufText,iNum);
	}
	if (itype == enum_PinDe)
	{
		if (iNum < 0)
			pChar = va("%s 减少品德%d",bufText,abs(iNum));
		else
			pChar = va("%s 增加品德%d",bufText,abs(iNum));
	}
	if (itype == enum_QingGong)
	{
		pChar = va("%s 增加轻功%d",bufText,iNum);
	}
	if (itype == enum_NeiliMax)
	{
		pChar = va("%s 增加内力上限%d",bufText,iNum);
	}
	if (itype == enum_GongJiLi)
	{
		pChar = va("%s 增加武力%d",bufText,iNum);
	}
	if (itype == enum_hpMax)
	{
		pChar = va("%s 增加生命上限%d",bufText,iNum);
	}
	if (itype == enum_ShengWang)
	{
		pChar = va("%s 增加声望%d",bufText,iNum);
	}

	JY_DrawStr(g_wInitialWidth/2,g_iFontSize,pChar,HUANGCOLOR,0,TRUE,TRUE);
	JY_ShowSurface();
	SafeFree(pChar);
	WaitKey();
}
//通关动画
VOID JY_END(VOID)
{
	FILE *fpRIdx = NULL;
	FILE *fpRGrp = NULL;
	char cFile[256] = {0};
	sprintf(cFile,"%s\\Resource\\data\\Kend.idx",JY_PREFIX);
	fpRIdx = fopen(cFile,"rb");//UTIL_OpenRequiredFile("\\Resource\\data\\Kend.idx");
	if (fpRIdx == NULL)
		TerminateOnError("打开文件失败%s!\n", cFile);
	sprintf(cFile,"%s\\Resource\\data\\Kend.grp",JY_PREFIX);
	fpRGrp = fopen(cFile,"rb");//UTIL_OpenRequiredFile("\\Resource\\data\\Kend.grp");
	if (fpRGrp == NULL)
		TerminateOnError("打开文件失败%s!\n", cFile);
	INT iLen = 0;
	INT i = 0;
	INT iSize = 0;
	INT iAddress = 0;
	iLen = JY_IDXGetChunkCount(fpRIdx);

	LPBYTE buf = NULL;

	JY_FillColor(0,0,0,0,0);
	for(i=0;i<iLen;i++)
	{
		if (JY_IDXGetChunkBaseInfo(i,fpRIdx,&iSize,&iAddress) > -1)
		{
			buf = (LPBYTE)malloc(iSize);
			if (buf != NULL)
			{
				if (JY_GRPReadChunk(buf,iSize,iAddress,fpRGrp) > -1)
				{
					if (g_iZoom == 1)
					{
						LPBYTE p = NULL;
						SDL_LockSurface(gpScreen);
						INT y = g_wInitialHeight/2 - 240/2;
						INT x = g_wInitialWidth/2 - 320/2;
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
					JY_ShowSurface();
					JY_Delay(20);
				}
			}
			SafeFree(buf);
		}
	}
	UTIL_CloseFile(fpRIdx);
	UTIL_CloseFile(fpRGrp);
}
//计算当前战斗形势
VOID War_NowStatus(VOID)
{
	INT r = -1;
	INT i = 0;

	short iMaxShaShang = -1;
	short iMaxYiLiao = -1;
	short iMaxJieDu = -1;
	short iMaxZhongDu = -1;
	short iMaxShouShang = -1;
	short iMinFoe = 32765;

	gpGlobals->g.war.iFlagMaxShaShangPerson = -1;
	gpGlobals->g.war.iFlagMaxYiLiaoPerson = -1;
	gpGlobals->g.war.iFlagMaxShouShangPerson = -1;
	gpGlobals->g.war.iFlagMinFoePerson = -1;
	gpGlobals->g.war.iFlagMaxJieDuPerson=-1;
	gpGlobals->g.war.iFlagMaxZhongDuPerson=-1;

	for(i=0;i<gpGlobals->g.war.iPersonNum;i++)
	{
		if (gpGlobals->g.war.warGroup[i].bDie == TRUE)
			continue;

		short pid = gpGlobals->g.war.warGroup[i].iPerson;
		short wugongid = War_AutoSelectWugong(i);
		//已方
		if (pid >=0 && gpGlobals->g.war.warGroup[gpGlobals->g.war.iCurID].bSelf == gpGlobals->g.war.warGroup[i].bSelf)
		{
			if (i >= gpGlobals->g.war.iCurID)//可行动
			{
				//最大杀伤
				if (wugongid >=0)
				{
					short iWuGong = gpGlobals->g.pPersonList[pid].WuGong[wugongid];
					short iLeve = gpGlobals->g.pPersonList[pid].WuGongDengji[wugongid]/100;
					if (iWuGong >= 0 && iLeve >= 0 && iLeve <=9)
					{
						if (gpGlobals->g.pWuGongList[iWuGong].GongJiLi[iLeve] > iMaxShaShang)
						{
							iMaxShaShang = gpGlobals->g.pWuGongList[iWuGong].GongJiLi[iLeve];
							gpGlobals->g.war.iFlagMaxShaShangPerson = pid;
						}
					}
				}
				//最大可以医疗
				if (gpGlobals->g.pPersonList[pid].Tili >= 50 && gpGlobals->g.pPersonList[pid].YiLiao >= 20)
				{
					if (gpGlobals->g.pPersonList[pid].YiLiao > iMaxYiLiao)
					{
						iMaxYiLiao = gpGlobals->g.pPersonList[pid].YiLiao;
						gpGlobals->g.war.iFlagMaxYiLiaoPerson = pid;
					}
				}
				//最大可以解毒
				if (gpGlobals->g.pPersonList[pid].Tili >= 50 && gpGlobals->g.pPersonList[pid].JieDu >= 20)
				{
					if (gpGlobals->g.pPersonList[pid].JieDu > iMaxJieDu)
					{
						iMaxJieDu = gpGlobals->g.pPersonList[pid].JieDu;
						gpGlobals->g.war.iFlagMaxJieDuPerson = pid;
					}
				}

			}
			//最大受伤
			INT v = -1;
			v = gpGlobals->g.pPersonList[pid].hpMax  - gpGlobals->g.pPersonList[pid].hp;
			if (v >= gpGlobals->g.pPersonList[pid].hpMax/2)
			{
				if (v > iMaxZhongDu)
				{
					iMaxZhongDu = v;
					gpGlobals->g.war.iFlagMaxShouShangPerson = pid;
				}
			}
			//最大中毒
			v = gpGlobals->g.pPersonList[pid].ZhongDu;
			if (v >= g_izhongduMax/2)
			{
				if (v > iMaxShouShang)
				{
					iMaxShouShang = v;
					gpGlobals->g.war.iFlagMaxZhongDuPerson = pid;
				}
			}
		}
		//敌方
		if (pid >=0 && gpGlobals->g.war.warGroup[gpGlobals->g.war.iCurID].bSelf != gpGlobals->g.war.warGroup[i].bSelf)
		{
			//最小生命
			if (gpGlobals->g.pPersonList[pid].hp < iMinFoe)
			{
				iMinFoe = gpGlobals->g.pPersonList[pid].hp;
				gpGlobals->g.war.iFlagMinFoePerson = pid;
			}
		}
	}
}
//医疗队友
short War_AutoDoctorOther(short id)
{
	short iPerson = -1;
	iPerson = gpGlobals->g.war.warGroup[gpGlobals->g.war.iCurID].iPerson;
	short pidx = gpGlobals->g.war.warGroup[gpGlobals->g.war.iCurID].x;
	short pidy = gpGlobals->g.war.warGroup[gpGlobals->g.war.iCurID].y;

	short step = gpGlobals->g.pPersonList[iPerson].YiLiao / 15 + 1;
	
	short eid = -1;
	eid = gpGlobals->g.war.warGroup[id].iPerson;
	short eidx = gpGlobals->g.war.warGroup[id].x;
	short eidy = gpGlobals->g.war.warGroup[id].y;

	War_CalMoveStep(gpGlobals->g.war.iCurID,step,1);
	JY_CleanWarMap(4,0);
	short i = 0;
	short j = 0;
	BOOL bUse = FALSE;
	for(i=1;i<step+1;i++)
	{
		short step_num = gpGlobals->g.war.pAttackStep[i].num;
		if(step_num == 0 || bUse)
			break;
		for(j=0;j<step_num;j++)
		{
			short xx = gpGlobals->g.war.pAttackStep[i].x[j];
			short yy = gpGlobals->g.war.pAttackStep[i].y[j];
			if (xx == eidx && yy == eidy)//可以医疗到
			{
				bUse = TRUE;
				break;
			}
		}
	}
	if (bUse)//可以医疗到
	{
		gpGlobals->g.war.warGroup[gpGlobals->g.war.iCurID].iWay = War_Direct(pidx,pidy,eidx,eidy);
		gpGlobals->g.war.warGroup[id].iDianShu = ExecDoctor(gpGlobals->g.war.iCurID,eid);
		JY_SetWarMap(eidx,eidy,4,4);
		gpGlobals->g.war.iEffect=4;
		gpGlobals->g.war.warGroup[gpGlobals->g.war.iCurID].iExp += 1;
		JY_SetPersonStatus(enum_Tili,iPerson,-2,FALSE);
		War_ShowFight(iPerson,0,0,0);
		for(i=0;i<gpGlobals->g.war.iPersonNum;i++)
		{
			gpGlobals->g.war.warGroup[i].iDianShu = 0;
		}
		JY_CleanWarMap(4,0);
	}
	else//不可以医疗到
	{
		War_CalMoveStep(gpGlobals->g.war.iCurID,gpGlobals->g.war.warGroup[gpGlobals->g.war.iCurID].iYiDongBushu,0);//计算移动步数
		short mx = -1;
		short my = -1;
		short mindis = 999;
		//计算移动到最近是否能医疗
		for(i=1;i<gpGlobals->g.war.warGroup[gpGlobals->g.war.iCurID].iYiDongBushu+1;i++)
		{
			short step_num = gpGlobals->g.war.pMoveStep[i].num;
			if(step_num == 0 )
				break;
			for(j=0;j<step_num;j++)
			{
				short xx = gpGlobals->g.war.pMoveStep[i].x[j];
				short yy = gpGlobals->g.war.pMoveStep[i].y[j];
				
				if ( mindis > (abs(xx-eidx) + abs(yy-eidx)) )
				{
					mx=xx;
					my=yy;
					mindis = (abs(xx-eidx) + abs(yy-eidx));
				}
			}
		}
		if (mx > -1 && my > -1)//移动到最近
		{
			War_MovePerson(mx,my);
			War_CalMoveStep(gpGlobals->g.war.iCurID,step,1);
			JY_CleanWarMap(4,0);
			for(i=1;i<step+1;i++)
			{
				short step_num = gpGlobals->g.war.pAttackStep[i].num;
				if(step_num == 0 || bUse)
					break;
				for(j=0;j<step_num;j++)
				{
					short xx = gpGlobals->g.war.pAttackStep[i].x[j];
					short yy = gpGlobals->g.war.pAttackStep[i].y[j];
					if (xx == eidx && yy == eidy)//可以医疗到
					{
						bUse = TRUE;
						break;
					}
				}
			}
			if (bUse)//可以医疗
			{
				gpGlobals->g.war.warGroup[gpGlobals->g.war.iCurID].iWay = War_Direct(mx,my,eidx,eidy);
				gpGlobals->g.war.warGroup[id].iDianShu = ExecDoctor(gpGlobals->g.war.iCurID,eid);
				JY_SetWarMap(eidx,eidy,4,4);
				gpGlobals->g.war.iEffect=4;
				gpGlobals->g.war.warGroup[gpGlobals->g.war.iCurID].iExp += 1;
				JY_SetPersonStatus(enum_Tili,iPerson,-2,FALSE);
				War_ShowFight(iPerson,0,0,0);
				for(i=0;i<gpGlobals->g.war.iPersonNum;i++)
				{
					gpGlobals->g.war.warGroup[i].iDianShu = 0;
				}
				JY_CleanWarMap(4,0);
			}
			else
			{
				INT iMinNeiLi = -1;
				iMinNeiLi = War_GetMinNeiLi(iPerson);
				if (gpGlobals->g.pPersonList[iPerson].Neili >= iMinNeiLi)//自动战斗
				{
					War_AutoFight();
				}
				else
				{
					War_RestMenu();
				}
			}
		}
		else//不能移动
		{
			INT iMinNeiLi = -1;
			iMinNeiLi = War_GetMinNeiLi(iPerson);
			if (gpGlobals->g.pPersonList[iPerson].Neili >= iMinNeiLi)//自动战斗
			{
				War_AutoFight();
			}
			else
			{
				War_RestMenu();
			}
		}
	}
	return 0;
}
//解毒队友
short War_AutoecPoisonOther(short id)
{
	short iPerson = -1;
	iPerson = gpGlobals->g.war.warGroup[gpGlobals->g.war.iCurID].iPerson;
	short pidx = gpGlobals->g.war.warGroup[gpGlobals->g.war.iCurID].x;
	short pidy = gpGlobals->g.war.warGroup[gpGlobals->g.war.iCurID].y;

	short step = gpGlobals->g.pPersonList[iPerson].JieDu / 15 + 1;
	
	short eid = -1;
	eid = gpGlobals->g.war.warGroup[id].iPerson;
	short eidx = gpGlobals->g.war.warGroup[id].x;
	short eidy = gpGlobals->g.war.warGroup[id].y;

	War_CalMoveStep(gpGlobals->g.war.iCurID,step,1);
	JY_CleanWarMap(4,0);
	short i = 0;
	short j = 0;
	BOOL bUse = FALSE;
	for(i=1;i<step+1;i++)
	{
		short step_num = gpGlobals->g.war.pAttackStep[i].num;
		if(step_num == 0 || bUse)
			break;
		for(j=0;j<step_num;j++)
		{
			short xx = gpGlobals->g.war.pAttackStep[i].x[j];
			short yy = gpGlobals->g.war.pAttackStep[i].y[j];
			if (xx == eidx && yy == eidy)//可以解毒到
			{
				bUse = TRUE;
				break;
			}
		}
	}
	if (bUse)//可以解毒到
	{
		gpGlobals->g.war.warGroup[gpGlobals->g.war.iCurID].iWay = War_Direct(pidx,pidy,eidx,eidy);
		gpGlobals->g.war.warGroup[id].iDianShu = ExecDecPoison(gpGlobals->g.war.iCurID,eid);
		JY_SetWarMap(eidx,eidy,4,6);
		gpGlobals->g.war.iEffect=4;
		gpGlobals->g.war.warGroup[gpGlobals->g.war.iCurID].iExp += 1;
		JY_SetPersonStatus(enum_Tili,iPerson,-2,FALSE);
		War_ShowFight(iPerson,0,0,36);
		for(i=0;i<gpGlobals->g.war.iPersonNum;i++)
		{
			gpGlobals->g.war.warGroup[i].iDianShu = 0;
		}
		JY_CleanWarMap(4,0);
	}
	else//不可以解毒到
	{
		War_CalMoveStep(gpGlobals->g.war.iCurID,gpGlobals->g.war.warGroup[gpGlobals->g.war.iCurID].iYiDongBushu,0);//计算移动步数
		short mx = -1;
		short my = -1;
		short mindis = 999;
		//计算移动到最近是否能解毒
		for(i=1;i<gpGlobals->g.war.warGroup[gpGlobals->g.war.iCurID].iYiDongBushu+1;i++)
		{
			short step_num = gpGlobals->g.war.pMoveStep[i].num;
			if(step_num == 0 )
				break;
			for(j=0;j<step_num;j++)
			{
				short xx = gpGlobals->g.war.pMoveStep[i].x[j];
				short yy = gpGlobals->g.war.pMoveStep[i].y[j];
				
				if ( mindis > (abs(xx-eidx) + abs(yy-eidx)) )
				{
					mx=xx;
					my=yy;
					mindis = (abs(xx-eidx) + abs(yy-eidx));
				}
			}
		}
		if (mx > -1 && my > -1)//移动到最近
		{
			War_MovePerson(mx,my);
			War_CalMoveStep(gpGlobals->g.war.iCurID,step,1);
			JY_CleanWarMap(4,0);
			for(i=1;i<step+1;i++)
			{
				short step_num = gpGlobals->g.war.pAttackStep[i].num;
				if(step_num == 0 || bUse)
					break;
				for(j=0;j<step_num;j++)
				{
					short xx = gpGlobals->g.war.pAttackStep[i].x[j];
					short yy = gpGlobals->g.war.pAttackStep[i].y[j];
					if (xx == eidx && yy == eidy)//可以解毒到
					{
						bUse = TRUE;
						break;
					}
				}
			}
			if (bUse)//可以解毒
			{
				gpGlobals->g.war.warGroup[gpGlobals->g.war.iCurID].iWay = War_Direct(mx,my,eidx,eidy);
				gpGlobals->g.war.warGroup[id].iDianShu = ExecDecPoison(gpGlobals->g.war.iCurID,eid);
				JY_SetWarMap(eidx,eidy,4,6);
				gpGlobals->g.war.iEffect=4;
				gpGlobals->g.war.warGroup[gpGlobals->g.war.iCurID].iExp += 1;
				JY_SetPersonStatus(enum_Tili,iPerson,-2,FALSE);
				War_ShowFight(iPerson,0,0,36);
				for(i=0;i<gpGlobals->g.war.iPersonNum;i++)
				{
					gpGlobals->g.war.warGroup[i].iDianShu = 0;
				}
				JY_CleanWarMap(4,0);
			}
			else
			{
				INT iMinNeiLi = -1;
				iMinNeiLi = War_GetMinNeiLi(iPerson);
				if (gpGlobals->g.pPersonList[iPerson].Neili >= iMinNeiLi)//自动战斗
				{
					War_AutoFight();
				}
				else
				{
					War_RestMenu();
				}
			}
		}
		else//不能移动
		{
			INT iMinNeiLi = -1;
			iMinNeiLi = War_GetMinNeiLi(iPerson);
			if (gpGlobals->g.pPersonList[iPerson].Neili >= iMinNeiLi)//自动战斗
			{
				War_AutoFight();
			}
			else
			{
				War_RestMenu();
			}
		}
	}
	return 0;
}