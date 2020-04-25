// 读取idx/grp的贴图文件。
// 为提高速度，采用缓存方式读取。把idx/grp读入内存，然后定义若干个缓存表面
// 经常访问的pic放在缓存表面中
#include "Main.h"

static struct PicFileCache pic_file[PIC_FILE_NUM];     

LIST_HEAD(cache_head);             //定义cache链表头

static INT currentCacheNum=0;      // 当前使用的cache数

static INT g_MAXCacheNum = 1000;          // 最大Cache个数
extern WORD g_wInitialWidth;
extern WORD g_wInitialHeight;
extern WORD g_wInitialHeight;

INT CacheFailNum=0;

// 初始化Cache数据。游戏开始时调用
INT Init_Cache(VOID)
{
    INT i = 0;
    for(i=0;i<PIC_FILE_NUM;i++){
        pic_file[i].num =0;
        pic_file[i].idx =NULL;
        pic_file[i].pcache=NULL;
    }
    return 0;
}
// 初始化贴图cache信息
// 在主地图/场景/战斗切换时调用
INT JY_PicInit(VOID)
{
    struct list_head *pos,*p;
    int i;
 
	//MEMORYSTATUS   buffer; 
	//GlobalMemoryStatus(&buffer);
	//INT i1 = buffer.dwTotalPhys/1024;
	//INT i2 = buffer.dwAvailPhys/1024;

    //如果链表不为空，删除全部链表
    list_for_each_safe(pos,p,&cache_head){
        struct CacheNode *tmp= list_entry(pos, struct CacheNode , list);
        if(tmp->s!=NULL) 
			SafeFreeSdlSurface(tmp->s);       //删除表面
		list_del(pos);		 
		SafeFree(tmp);
	}

    for(i=0;i<PIC_FILE_NUM;i++){
        pic_file[i].num =0;
        SafeFree(pic_file[i].idx);
        SafeFree(pic_file[i].pcache);
    }

	//GlobalMemoryStatus(&buffer);
	//INT i3 = buffer.dwTotalPhys/1024;
	//INT i4 = buffer.dwAvailPhys/1024;

    currentCacheNum=0; 
    CacheFailNum=0;
    return 0;
}

// 加载文件信息
// filename 文件名  不需要后缀，idx/grp
// id  0-9
INT JY_PicLoadFile(const char*filename, INT id)
{
    INT i;
    struct CacheNode *tmpcache;
    char str[255];
    FILE *fp;
    INT count;

    if (id<0 || id>=PIC_FILE_NUM)
	{  // id超出范围
        return 1;
	}

	if(pic_file[id].pcache){        //释放当前文件占用的空间，并清理cache
		INT i;
		for(i=0;i<pic_file[id].num;i++){   //循环全部贴图，
            tmpcache=pic_file[id].pcache[i];
            if(tmpcache){       // 该贴图有缓存则删除
			    if(tmpcache->s!=NULL) 
				    SDL_FreeSurface(tmpcache->s);       //删除表面
			    list_del(&tmpcache->list);              //删除链表
			    SafeFree(tmpcache);                  //释放cache内存
                currentCacheNum--;
            }
		}
        SafeFree(pic_file[id].pcache);
    }
    SafeFree(pic_file[id].idx);

    // 读取idx文件
    sprintf(str,"%s%s.idx",JY_PREFIX,filename);
	
	fp = fopen(str,"rb");//UTIL_OpenRequiredFile(str);
	if (fp==NULL)
		TerminateOnError("JY_PicLoadFile: 打开文件失败%s!\n", str);
	pic_file[id].num =JY_GetFileLength(fp) / 4 / 6;
    pic_file[id].idx =(INT *)malloc((pic_file[id].num+1)*4*6);
    if(pic_file[id].idx ==NULL){
		TerminateOnError("JY_PicLoadFile: 分配内存失败%s!\n", str);
		return 1;
    }

    count=fread(pic_file[id].idx,4,pic_file[id].num * 6,fp);
	//count = 0;
	//INT iTEmp = 0;
	//FILE *fpTemp = fopen("1.txt", "w");
	//for(i=0;i<pic_file[id].num;i++)
	//{
	//	fprintf(fpTemp, "%d ", i);
	//	for(int j=0;j<6;j++)
	//	{
	//		iTEmp = pic_file[id].idx[count];
	//		fprintf(fpTemp, "%d ", iTEmp);
	//		count++;
	//	}
	//	fprintf(fpTemp, "\n");
	//}
	//fclose(fpTemp);
    UTIL_CloseFile(fp);
  	INT iSize = pic_file[id].num*sizeof(struct CacheNode *);
	pic_file[id].pcache =(struct CacheNode **)malloc(iSize);
    if(pic_file[id].pcache ==NULL)
	{
		TerminateOnError("JY_PicLoadFile: 不能分配内存  pcache memory\n");
		return 1;
    }

	for(i=0;i<pic_file[id].num;i++)
		pic_file[id].pcache[i]=NULL;

    return 0;
} 

// 加载并显示贴图
// fileid        贴图文件id 
// picid     贴图编号
// x,y       显示位置
//  flag 不同bit代表不同含义，缺省均为0
//  B0    0 考虑偏移xoff，yoff。=1 不考虑偏移量
//  B1    0     , 1 与背景alpla 混合显示, value 为alpha值(0-256), 0表示透明
//  B2            1 全黑
//  B3            1 全白
//  value 按照flag定义，为alpha值， 

INT JY_LoadPic(INT fileid, INT picid, INT x,INT y,INT flag,INT value)
{ 
    struct CacheNode *newcache,*tmpcache;
	INT find=0;
 
 	picid=picid/2;

	if(fileid<0 || fileid >=PIC_FILE_NUM || picid<0 || picid>=pic_file[fileid].num )    // 参数错误
		return 1;

	if(pic_file[fileid].pcache[picid]==NULL){   //当前贴图没有加载
		//生成cache数据
		newcache=(struct CacheNode *)malloc(sizeof(struct CacheNode));
		if(newcache==NULL)
		{
			TerminateOnError("JY_LoadPic: 分配内存失败:newcache memory!\n");
			return 1;
		}

		newcache->s=LoadPic(fileid,picid,&newcache->xoff,&newcache->yoff);
        newcache->id =picid;
		newcache->fileid =fileid;
        pic_file[fileid].pcache[picid]=newcache;

        if(currentCacheNum<g_MAXCacheNum)
		{  //cache没满
            list_add(&newcache->list ,&cache_head);    //加载到表头
            currentCacheNum=currentCacheNum+1;
 		}
		else
		{   //cache 已满
            tmpcache=list_entry(cache_head.prev, struct CacheNode , list);  //最后一个cache
            pic_file[tmpcache->fileid].pcache[tmpcache->id]=NULL;
			if(tmpcache->s!=NULL) 
				SafeFreeSdlSurface(tmpcache->s);       //删除表面
			list_del(&tmpcache->list);
			SafeFree(tmpcache);
			
			list_add(&newcache->list ,&cache_head);    //加载到表头
            CacheFailNum++;
            if(CacheFailNum % 100 ==1)
                TerminateOnError("JY_LoadPic: 分配内存失败:Pic Cache is full!\n");
        }
    }
	else
	{   //已加载贴图
 		newcache=pic_file[fileid].pcache[picid];
		list_del(&newcache->list);    //把这个cache从链表摘出
		list_add(&newcache->list ,&cache_head);    //再插入到表头
	}

	if(flag & 0x00000001)
        BlitSurface(newcache->s , x,y,flag,value);
	else
        BlitSurface(newcache->s , x - newcache->xoff,y - newcache->yoff,flag,value);

    return 0;
}

// 加载贴图到表面
SDL_Surface *LoadPic(INT fileid,INT picid, INT *xoffset,INT *yoffset)
{ 	
	INT iFileLen = 0;
	INT iW = 0;
	INT iH = 0;
	INT iOffX = 0;
	INT iOffY = 0;
	INT iOffset = 0;

    SDL_Surface *surf=NULL;
	SDL_Surface *surfTemp=NULL;

    if(pic_file[fileid].idx ==NULL){
		TerminateOnError("LoadPic: fileid %d can not load?\n",fileid);
        return NULL;
    }

	iFileLen = pic_file[fileid].idx[picid * 6];
	iW = pic_file[fileid].idx[picid * 6+1] * g_iZoom;
	iH = pic_file[fileid].idx[picid * 6+2] * g_iZoom ;
	iOffX = pic_file[fileid].idx[picid * 6+3] * g_iZoom ;
	//iOffY = pic_file[fileid].idx[picid * 6+4] ;
	//修正Y偏移
	if (pic_file[fileid].idx[picid * 6+2] - pic_file[fileid].idx[picid * 6+4] > 0)
		iOffY = pic_file[fileid].idx[picid * 6+2] * g_iZoom - (pic_file[fileid].idx[picid * 6+2] - pic_file[fileid].idx[picid * 6+4]) * g_iZoom;
	else if (pic_file[fileid].idx[picid * 6+2] - pic_file[fileid].idx[picid * 6+4] < 0)
		iOffY = pic_file[fileid].idx[picid * 6+2] * g_iZoom + (pic_file[fileid].idx[picid * 6+4] - pic_file[fileid].idx[picid * 6+2]) * g_iZoom;
	else
		iOffY = iH;
	iOffset = pic_file[fileid].idx[picid * 6+5];
	
	*xoffset = iOffX;
	*yoffset = iOffY;
	LPBYTE pBuf = NULL;

	FILE *fp = NULL;

	if(iFileLen>0)
	{
		pBuf = (LPBYTE)malloc(iFileLen + 2);
		if (pBuf == NULL)
		{
			TerminateOnError("LoadPic:不能分配内存 mapPic Mem \n");
		}
		if ( fileid == 0 )
		{
			fp = gpGlobals->f.fpMmapGrp;
		}
		if ( fileid == 1 )
		{
			fp = gpGlobals->f.fpSmapGrp;
		}
		if ( fileid == 2 )
		{
			fp = gpGlobals->f.fpHdGrpGrp;
		}
		if ( fileid == 3 )
		{
			fp = gpGlobals->f.fpWmapGrp;
		}
		if ( fileid == 4 )
		{
			fp = gpGlobals->f.fpEftGrp;
		}
		if ( fileid == 5 )
		{
			if(gpGlobals->f.fpFightGrp == NULL)
			{
				SafeFree(pBuf);
				return NULL;
			}
			fp = gpGlobals->f.fpFightGrp;

		}
		if (JY_GRPReadChunk(pBuf,iFileLen,iOffset,fp) > -1)
		{
			surf = SDL_CreateRGBSurface(SDL_SWSURFACE, iW, iH,8, 0,0,0, 0);
			SDL_SetPalette(surf, SDL_LOGPAL|SDL_PHYSPAL, g_colors, 0, 256);
			INT iNum = 0;
			for(INT i=0;i<iH;i++)
			{
				for(INT j=0;j<iW;j++)
				{
					iNum = i/g_iZoom * iW/g_iZoom +j/g_iZoom;
					JY_PutPixel(surf,j,i,pBuf[iNum]);
					//iNum++;
				}
			}
			
			SDL_SetColorKey(surf,SDL_SRCCOLORKEY|SDL_RLEACCEL ,TRANSCOLOR);  //使用RLE加速  
		}
		SafeFree(pBuf);
    }
    fp == NULL;
    return surf;
}


//得到贴图大小
INT JY_GetPicXY(INT fileid, INT picid, INT *w,INT *h)
{
    struct CacheNode *newcache;
	INT r=JY_LoadPic(fileid, picid, g_wInitialWidth+1,g_wInitialHeight+1,1,0);   //加载贴图到看不见的位置

    *w=0;
	*h=0;

	if(r!=0)
		return 1;

    newcache=pic_file[fileid].pcache[picid/2];

    if(newcache->s){      // 已有，则直接显示
        *w= newcache->s->w;
        *h= newcache->s->h;
	}

	return 0;
}

//按照原来游戏的RLE格式创建表面
SDL_Surface* CreatePicSurface32(unsigned char *data, INT w,INT h,INT datalong)
{    
	INT x1=0,y1=0,p=0;    
	INT i,j;
	INT yoffset;
	INT row;
	INT start;
    INT x;
    INT solidnum;
	SDL_Surface *ps1,*ps2 ;
    Uint32 *data32=NULL;

    data32=(Uint32 *)malloc(w*h*4);
	if(data32==NULL){
		TerminateOnError("CreatePicSurface32: 不能分配内存  data32 memory!");
		return NULL;
	}

	for(i=0;i<w*h;i++)
		data32[i]=TRANSCOLOR;

	for(i=0;i<h;i++){
        yoffset=i*w;       
        row=data[p];            // i行数据个数
		start=p;
		p++;
		if(row>0){
			x=0;                // i行目前列
            while(1){
                x=x+data[p];    // i行空白点个数，跳个透明点
				if(x>=w)        // i行宽度到头，结束
					break;

				p++;
                solidnum=data[p];  // 不透明点个数
                p++;
				for(j=0;j<solidnum;j++){
                    data32[yoffset+x]=data[p];//m_color32[data[p]];
					p++;
					x++;
				}
                if(x>=w)
					break;     // i行宽度到头，结束
				if(p-start>=row) 
					break;    // i行没有数据，结束
			}
            if(p+1>=datalong) 
				break;
		}
	}
 
    ps1=SDL_CreateRGBSurfaceFrom(data32,w,h,32,w*4,0xff0000,0xff00,0xff,0);  //创建32位表面
	if(ps1==NULL){
		TerminateOnError("CreatePicSurface32: 不能分配内存  SDL_Surface ps1!");
	}
    ps2 = ps1;
	//ps2=SDL_DisplayFormat(ps1);   // 把32位表面改为当前表面
	if(ps2==NULL){
		TerminateOnError("CreatePicSurface32: 不能分配内存  SDL_Surface ps2!\n");
	}

	SafeFreeSdlSurface(ps1);      
	SafeFree(data32);   	
    SDL_SetColorKey(ps2,SDL_SRCCOLORKEY|SDL_RLEACCEL ,TRANSCOLOR);  //使用RLE加速

    return ps2;
   	
}
