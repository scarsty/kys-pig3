#include "main.h"

char appPath[256];
INT g_CharSet = 0;
LPGLOBALVARS gpGlobals = NULL;

void ByteSwap(void* buf)
{
	BYTE* p = (BYTE*)buf;
	BYTE b;
	return;
	b = p[1];
	p[1] = p[0];
	p[0] = b;
}
int FindChars(const char* p, const char* f, BOOL br)
{
	char* s = strstr((char*)p, f);
	if (s)
	{
		if(br)
		{
			return strlen(p) - (s - p);
		}
		else
		{
			return s - p;
		}
	}
	return -1;
}

char** spilwhit(char* str, const char* strsp, DWORD* buf, int buflen, int* ct)
{
	int splen = strlen(strsp), k = 0;
	char *s = str, *p = str;
	char** pr = (char**)buf;
	*ct = 0;
	if(!str || !buf) return NULL;
	while(*s)
	{
		if (FindChars(s, strsp, 0) == 0)
		{
			pr[*ct] = p;
			*s=0;
			s+=splen;
			p=s;
			++(*ct);
			if (*ct==buflen) return pr;
		}
		++s;
	}
	pr[*ct]=p;
	++(*ct);
	return pr;
}

int ReadLine(FILE *fp, char *buffer, int maxlen)
{
	int  i = 0, j = 0; 
	char ch1 = 0; 

	for(i = 0, j = 0; i < maxlen-1; j++) 
	{ 
		if(fread(&ch1, 1, 1, fp) != 1) 
		{ 
			if(feof(fp) != 0) 
			{ 
				if(j == 0) return -1;               /* 文件结束 */ 
				else break; 
			} 
			if(ferror(fp) != 0) return -2;        /* 读文件出错 */ 
			return -2; 
		} 
		else 
		{ 
			if(ch1 == '\n' || ch1 == 0x00) break; /* 换行 */ 
			if(ch1 == '\f' || ch1 == 0x1A)        /* '\f':换页符也算有效字符 */ 
			{ 
				buffer[i++] = ch1; 
				break; 
			} 
			if(ch1 != '\r') buffer[i++] = ch1;    /* 忽略回车符 */ 
		} 
	} 
	buffer[i] = '\0'; 
	return i; 
} 

BOOL GetIniValue(const char* file, const char* session,const char* key,const char*defvalue, char* value)
{
	char buf[256]={0};
	int fnd = 0, n = 0, ct = 0;
	DWORD dbuf[2] ={0};
	char** sp = NULL;

	FILE* fp = fopen(file, "rb");
	strcpy(value, defvalue);
	if (fp)
	{
		fnd = 0, n = 0;
		while (!feof(fp))
		{
			if ((n = ReadLine(fp, buf, 256)) < 0)
			{
				fclose(fp);
				fp=NULL;
				break;
			}
			//if( fgets( buf, 255, fp )==NULL ) 
			//{
			//	fclose(fp);
			//	fp=NULL;
			//	break;
			//}
			if (buf[0] == '[') 
			{
				*(buf+strlen(buf)-1) = 0;
				if (strcmp(buf+1, session) == 0)
					fnd = 1;
				else
					fnd = 0;
				continue;
			}
			if (buf[0] == '#'|| !n || !fnd) continue;

			char* p= strtok(buf,"=");
			if (p != NULL)
			{
				if (strcmp(p, key)==0)
				{
					p=strtok(NULL,"=");
					if (p != NULL)
					{
						strcpy(value, p);
					}
					break;
				}
			}
			//ct = 0;
			//dbuf[0] = dbuf[1] = 0;
			//sp = spilwhit(buf, "=", dbuf, 2, &ct);
			//if (strcmp(sp[0], key)==0) 
			//{
			//	strcpy(value, sp[1]);
			//	break;
			//}
		}
		fclose(fp);
		fp=NULL;
		return fnd;
	}
	return FALSE;
}

BOOL GetIniField(FILE* fp, const char* session,const char* key,const char*defvalue, char* value)
{
	char buf[256]={0};
	int n = 0, ct = 0;
	BOOL fnd = FALSE;
	DWORD dbuf[2] ={0};
	char** sp = NULL;

	strcpy(value, defvalue);
	if (fp)
	{
		fseek(fp, 0, SEEK_SET);
		n = 0;
		fnd = FALSE;
		while (!feof(fp))
		{
			//if( fgets( buf, 255, fp )==NULL ) 
			//{
			//	break;
			//}
			if ((n = ReadLine(fp, buf, 256)) < 0)
			{
				fclose(fp);
				fp=NULL;
				break;
			}
			if (buf[0] == '[') 
			{
				*(buf+strlen(buf)-1) = 0;
				if (strcmp(buf+1, session) == 0)
					fnd = TRUE;
				else
					fnd = FALSE;
				continue;
			}
			if (buf[0] == '#'|| !n || !fnd) continue;

			char* p= strtok(buf,"=");
			if (p)
			{
				if (strcmp(p, key)==0)
				{
					p=strtok(NULL,"=");
					if (p)
					{
						strcpy(value, p);
					}
					break;
				}
			}
		}
		return fnd;
	}
	return FALSE;
}

int arByte2Int(void* arByte, int n)
{
	//BYTE* p = (BYTE*)arByte;
	//int l = 0;

	//while(--n >= 0)
	//{
	//	l = (l<<8) | *(p+n);
	//}
	//return l;
	
	char b[4];
	
	if (n==2)
	{
		b[0] = ((BYTE*)arByte)[0];
		b[1] = ((BYTE*)arByte)[1];
		return *(WORD*)b;
	}
	else if(n==4)
	{	
		b[0] = ((BYTE*)arByte)[0];
		b[1] = ((BYTE*)arByte)[1];
		b[2] = ((BYTE*)arByte)[2];
		b[3] = ((BYTE*)arByte)[3];
		return *(DWORD*)b;
	}
	
	return 0;
}

void Int2arByte(void* arByte, int v, int n)
{
	if (n == 2)
	{
		((BYTE*)arByte)[0] =((BYTE*)(&v))[0];
		((BYTE*)arByte)[1] =((BYTE*)(&v))[1];
	}
	else if(n == 4)
	{
		((BYTE*)arByte)[0] =((BYTE*)(&v))[0];
		((BYTE*)arByte)[1] =((BYTE*)(&v))[1];
		((BYTE*)arByte)[2] =((BYTE*)(&v))[2];
		((BYTE*)arByte)[3] =((BYTE*)(&v))[3];
	}
	
	//BYTE* p = (BYTE*)arByte;
	//int l = v;
	//while (--n >= 0)
	//{
	//	*(p+n) = (l>>(n<<3)) & 0xff;
	//}
}
char* GetAppPath()
{
	static char caResFile[200];
	int iLen, i, iCount;
	#ifdef _WIN32_WCE
		TCHAR caBuf[200];
		memset(caBuf, 0, sizeof(caBuf));
		iLen = GetModuleFileName(NULL, caBuf, sizeof(caBuf));
		WideCharToMultiByte(CP_ACP, 0, caBuf, sizeof(caBuf), caResFile, sizeof(caResFile),0,0);
	#endif

	if (iLen > 0)
	{
		// 查找最后一个\, 将文件名去掉, 从而获得文件所在的路径
		iCount = strlen(caResFile);
		for (i = iCount - 2; i >= 0; i--)	// 从右向左查找, 最后一个字符肯定不是\,因此跳过
		{
			if ('\\' == caResFile[i])	// 找到最右的一个
			{
				caResFile[i + 1 ] = '\0';	// 去掉文件名
				break;
			}
		}
	}
	return caResFile;
}



void ClearBuf(LPBYTE buf,int ilen)
{
	int i = 0;
	for(i=0;i< ilen;i++)
	{
		buf[i] = 0;
	}
}
//初始化全局对象
INT JY_InitGlobals(VOID)
{	
	if (gpGlobals == NULL)
	{
		gpGlobals = (LPGLOBALVARS)calloc(1, sizeof(GLOBALVARS));
		if (gpGlobals == NULL)
		{
			return -1;
		}
		gpGlobals->g.iSceneNum = -1;
		gpGlobals->g.pPersonList = NULL;
		gpGlobals->g.iPersonCount = -1;
		gpGlobals->g.pSceneTypeList = NULL;
		gpGlobals->g.iSceneTypeListCount = -1;
		gpGlobals->g.pBaseList = NULL;
		gpGlobals->g.pThingsList= NULL;
		gpGlobals->g.iThingsListCount = -1;
		gpGlobals->g.iLastUseSystemNum = 0;
		gpGlobals->g.iLastUseTransNum = 0;
		gpGlobals->g.pXiaoBaoList = NULL;
		gpGlobals->g.pWuGongList = NULL;
		gpGlobals->g.iWuGongCount= 0;
		gpGlobals->g.pScene = NULL;
		gpGlobals->g.pD = NULL;
		gpGlobals->g.pSurface = NULL;
		gpGlobals->g.pBuilding = NULL;
		gpGlobals->g.pBuildX = NULL;
		gpGlobals->g.pBuildY=NULL;
		gpGlobals->g.bLoadMmap=FALSE;
		gpGlobals->g.iXScale = 18 *g_iZoom;
		gpGlobals->g.iYScale = 9 *g_iZoom;
		gpGlobals->g.iMMapAddX = 2;
		gpGlobals->g.iMMapAddY = 2;
		gpGlobals->g.iSMapAddX = 2;
		gpGlobals->g.iSMapAddY = 16;
		gpGlobals->g.iWMapAddX = 2;
		gpGlobals->g.iWMapAddY = 16;
		gpGlobals->g.iBuildNumber = 0;
		gpGlobals->g.Status = 0;

		gpGlobals->g.iMyCurrentPic = 0;
		gpGlobals->g.iMyPic = 0;
		gpGlobals->g.iMytick = 0;
		gpGlobals->g.iDirectX[0] = 0;
		gpGlobals->g.iDirectX[1] = 1;
		gpGlobals->g.iDirectX[2] = -1;
		gpGlobals->g.iDirectX[3] = 0;
		gpGlobals->g.iDirectY[0] = -1;
		gpGlobals->g.iDirectY[1] = 0;
		gpGlobals->g.iDirectY[2] = 0;
		gpGlobals->g.iDirectY[3] = 1;

		gpGlobals->g.iSubSceneX = 0;
		gpGlobals->g.iSubSceneY = 0;
		gpGlobals->g.iSceneEventCode = -1;

		gpGlobals->g.iKdefListCount = 0;
		gpGlobals->g.bLoadKdef = FALSE;
		
		gpGlobals->g.iHaveThingsNum = 0;

		gpGlobals->fGameStart = FALSE;
		gpGlobals->fGameLoad = FALSE;
		gpGlobals->fGameSave = FALSE;
		LPSTR cFile = NULL;
		cFile = va("%s\\Resource\\data\\%s\\%s.grp", JY_PREFIX,g_cmmap,g_cmmap);
		if (cFile != NULL)
		{
			gpGlobals->f.fpMmapGrp = fopen(cFile, "rb");
			SafeFree(cFile);
		}
		cFile = va("%s\\Resource\\data\\%s\\%s.grp", JY_PREFIX,g_csmap,g_csmap);
		if (cFile != NULL)
		{
		gpGlobals->f.fpSmapGrp = fopen(cFile, "rb");
		SafeFree(cFile);
		}
		cFile = va("%s\\Resource\\data\\%s\\%s.grp", JY_PREFIX,g_chdgrp,g_chdgrp);
		if (cFile != NULL)
		{
		gpGlobals->f.fpHdGrpGrp = fopen(cFile, "rb");
		SafeFree(cFile);
		}
		cFile = va("%s\\Resource\\data\\%s\\%s.grp", JY_PREFIX,g_cwmap,g_cwmap);
		if (cFile != NULL)
		{
		gpGlobals->f.fpWmapGrp = fopen(cFile, "rb");
		SafeFree(cFile);
		}
		cFile = va("%s\\Resource\\data\\%s\\%s.grp", JY_PREFIX,g_ceft,g_ceft);
		if (cFile != NULL)
		{
		gpGlobals->f.fpEftGrp = fopen(cFile, "rb");
		SafeFree(cFile);
		}
		cFile = va("%s\\Resource\\data\\Talk.idx", JY_PREFIX);
		if (cFile != NULL)
		{
			gpGlobals->f.fpTalkIdx = fopen(cFile,"rb");			
			if (gpGlobals->f.fpTalkIdx == NULL)
				TerminateOnError("打开文件失败%s!\n", cFile);
			SafeFree(cFile);
			//gpGlobals->f.fpTalkIdx = UTIL_OpenRequiredFile("\\Resource\\data\\Talk.idx");
		}
		cFile = va("%s\\Resource\\data\\Talk.grp", JY_PREFIX);
		if (cFile != NULL)
		{
			gpGlobals->f.fpTalkGrp = fopen(cFile,"rb");			
			if (gpGlobals->f.fpTalkGrp == NULL)
				TerminateOnError("打开文件失败%s!\n", cFile);
			SafeFree(cFile);
			//gpGlobals->f.fpTalkGrp = UTIL_OpenRequiredFile("\\Resource\\data\\Talk.grp");	
		}
		
	}
	return 0;
}
//释放全局对象
VOID JY_FreeGlobals(VOID)
{
	if (gpGlobals != NULL)
	{
		UTIL_CloseFile(gpGlobals->f.fpMmapGrp);
		UTIL_CloseFile(gpGlobals->f.fpSmapGrp);
		UTIL_CloseFile(gpGlobals->f.fpHdGrpGrp);
		UTIL_CloseFile(gpGlobals->f.fpWmapGrp);
		UTIL_CloseFile(gpGlobals->f.fpEftGrp);
		UTIL_CloseFile(gpGlobals->f.fpTalkIdx);
		UTIL_CloseFile(gpGlobals->f.fpTalkGrp);
		

		SafeFree(gpGlobals->g.pKdefList);

		SafeFree(gpGlobals->g.pPersonList);
		SafeFree(gpGlobals->g.pSceneTypeList);
		SafeFree(gpGlobals->g.pBaseList);
		SafeFree(gpGlobals->g.pThingsList);
		SafeFree(gpGlobals->g.pXiaoBaoList);
		SafeFree(gpGlobals->g.pWuGongList);

		SafeFree(gpGlobals->g.pScene);
		SafeFree(gpGlobals->g.pD);

		SafeFree(gpGlobals->g.pEarth);
		SafeFree(gpGlobals->g.pSurface);
		SafeFree(gpGlobals->g.pBuilding);
		SafeFree(gpGlobals->g.pBuildX);
		SafeFree(gpGlobals->g.pBuildY);

		free(gpGlobals);
	}
	gpGlobals = NULL;
}

//初始化游戏数据
VOID JY_InitGameData(INT iSaveSlot)
{
	gpGlobals->g.iSceneNum = -1;
	gpGlobals->g.iPersonCount = -1;
	gpGlobals->g.iSceneTypeListCount = -1;
	gpGlobals->g.iThingsListCount = -1;
	gpGlobals->g.iLastUseSystemNum = 0;
	gpGlobals->g.iLastUseTransNum = 0;
	gpGlobals->g.iWuGongCount= 0;
	gpGlobals->g.bLoadMmap=FALSE;
	gpGlobals->g.iXScale = 18 *g_iZoom;
	gpGlobals->g.iYScale = 9 * g_iZoom;
	gpGlobals->g.iMMapAddX = 2;
	gpGlobals->g.iMMapAddY = 2;
	gpGlobals->g.iSMapAddX = 2;
	gpGlobals->g.iSMapAddY = 16;
	gpGlobals->g.iWMapAddX = 2;
	gpGlobals->g.iWMapAddY = 16;
	gpGlobals->g.iBuildNumber = 0;
	gpGlobals->g.Status = 0;
	gpGlobals->g.iMyCurrentPic = 0;
	gpGlobals->g.iMyPic = 0;
	gpGlobals->g.iMytick = 0;
	gpGlobals->g.iSubSceneX = 0;
	gpGlobals->g.iSubSceneY = 0;
	gpGlobals->g.iSceneEventCode = -1;
	gpGlobals->g.iKdefListCount = 0;
	gpGlobals->g.bLoadKdef = FALSE;	
	gpGlobals->g.iHaveThingsNum = 0;
	gpGlobals->fGameStart = FALSE;
	gpGlobals->fGameLoad = FALSE;
	gpGlobals->fGameSave = FALSE;

	//-R
	SafeFree(gpGlobals->g.pBaseList);
	SafeFree(gpGlobals->g.pPersonList);
	SafeFree(gpGlobals->g.pThingsList);
	SafeFree(gpGlobals->g.pSceneTypeList);
	SafeFree(gpGlobals->g.pWuGongList);
	SafeFree(gpGlobals->g.pXiaoBaoList);
	//-S
	SafeFree(gpGlobals->g.pScene);
	//-E
	//memset(gpGlobals->g.sceneEventList,0,sizeof(gpGlobals->g.sceneEventList));
	//-K
	SafeFree(gpGlobals->g.pKdefList);
	//-M
	SafeFree(gpGlobals->g.pEarth);
	SafeFree(gpGlobals->g.pSurface);
	SafeFree(gpGlobals->g.pBuilding);
	SafeFree(gpGlobals->g.pBuildX);
	SafeFree(gpGlobals->g.pBuildY);
	//
	JY_LoadSaveSlot(iSaveSlot);

	gpGlobals->fGameStart = TRUE;
}
//读取游戏进度
VOID JY_LoadSaveSlot(INT iSaveSlot)
{
	INT iNum = 0;
	INT uSize = 0;
	INT uAddress = 0;
	FILE *fpRIdx = NULL;
	FILE *fpRGrp = NULL;

	char cFileIdx[256] = {0};
	char cFileGrp[256] = {0};
	if (iSaveSlot == 0)
	{
		sprintf(cFileIdx,"%s\\Resource\\data\\Ranger.idx",JY_PREFIX);
		sprintf(cFileGrp,"%s\\Resource\\data\\Ranger.grp",JY_PREFIX);
		//fpRIdx = UTIL_OpenRequiredFile("\\Resource\\data\\Ranger.idx");
		//fpRGrp = UTIL_OpenRequiredFile("\\Resource\\data\\Ranger.grp");
	}
	if (iSaveSlot == 1)
	{
		sprintf(cFileIdx,"%s\\Resource\\data\\R1.idx",JY_PREFIX);
		sprintf(cFileGrp,"%s\\Resource\\data\\R1.grp",JY_PREFIX);
		//fpRIdx = UTIL_OpenRequiredFile("\\Resource\\data\\R1.idx");
		//fpRGrp = UTIL_OpenRequiredFile("\\Resource\\data\\R1.grp");
	}
	if (iSaveSlot == 2)
	{
		sprintf(cFileIdx,"%s\\Resource\\data\\R2.idx",JY_PREFIX);
		sprintf(cFileGrp,"%s\\Resource\\data\\R2.grp",JY_PREFIX);
		//fpRIdx = UTIL_OpenRequiredFile("\\Resource\\data\\R2.idx");
		//fpRGrp = UTIL_OpenRequiredFile("\\Resource\\data\\R2.grp");
	}
	if (iSaveSlot == 3)
	{
		sprintf(cFileIdx,"%s\\Resource\\data\\R3.idx",JY_PREFIX);
		sprintf(cFileGrp,"%s\\Resource\\data\\R3.grp",JY_PREFIX);
		//fpRIdx = UTIL_OpenRequiredFile("\\Resource\\data\\R3.idx");
		//fpRGrp = UTIL_OpenRequiredFile("\\Resource\\data\\R3.grp");
	}
	fpRIdx = fopen(cFileIdx,"rb");
	fpRGrp = fopen(cFileGrp,"rb");
	if (fpRIdx == NULL || fpRGrp == NULL)
	{
		UTIL_CloseFile(fpRIdx);
		UTIL_CloseFile(fpRGrp);
		TerminateOnError("打开文件失败%s!\n", cFileGrp);
		return;
	}

	iNum = JY_IDXGetChunkCount(fpRIdx);
	if (iNum < 0)
		TerminateOnError("不能打开Ranger.Idx\n");

	//基本信息
	JY_IDXGetChunkBaseInfo(0,fpRIdx,&uSize,&uAddress);
	if (gpGlobals->g.pBaseList == NULL)
	{
		gpGlobals->g.pBaseList = (LPBASEATTRIB)malloc(uSize);
	}
	if (gpGlobals->g.pBaseList == NULL)
		TerminateOnError("分配基本信息内存失败\n");
	JY_GRPReadChunk((LPBYTE)gpGlobals->g.pBaseList,uSize,uAddress,fpRGrp);

	////人物信息
	JY_IDXGetChunkBaseInfo(1,fpRIdx,&uSize,&uAddress);
	if (gpGlobals->g.pPersonList == NULL)
	{
		gpGlobals->g.pPersonList = (LPPERSONATTRIB)malloc(uSize);
	}
	if (gpGlobals->g.pPersonList == NULL)
		TerminateOnError("分配人物信息内存失败\n");
	JY_GRPReadChunk((LPBYTE)gpGlobals->g.pPersonList,uSize,uAddress,fpRGrp);
	gpGlobals->g.iPersonCount = uSize / 182;

	//物品信息
	JY_IDXGetChunkBaseInfo(2,fpRIdx,&uSize,&uAddress);
	if (gpGlobals->g.pThingsList == NULL)
	{
		gpGlobals->g.pThingsList = (LPTHINGSATTRIB)malloc(uSize);
	}
	if (gpGlobals->g.pThingsList == NULL)
		TerminateOnError("分配物品信息内存失败\n");
	JY_GRPReadChunk((LPBYTE)gpGlobals->g.pThingsList,uSize,uAddress,fpRGrp);
	gpGlobals->g.iThingsListCount = uSize / 190;

	//场景信息
	JY_IDXGetChunkBaseInfo(3,fpRIdx,&uSize,&uAddress);
	if (gpGlobals->g.pSceneTypeList == NULL)
	{
		gpGlobals->g.pSceneTypeList = (LPSCENETYPE)malloc(uSize);
	}
	if (gpGlobals->g.pSceneTypeList == NULL)
		TerminateOnError("分配场景信息内存失败\n");
	JY_GRPReadChunk((LPBYTE)gpGlobals->g.pSceneTypeList,uSize,uAddress,fpRGrp);
	gpGlobals->g.iSceneTypeListCount = uSize / 52;

	//武功信息
	JY_IDXGetChunkBaseInfo(4,fpRIdx,&uSize,&uAddress);
	if (gpGlobals->g.pWuGongList == NULL)
	{
		gpGlobals->g.pWuGongList = (LPWUGONGATTRIB)malloc(uSize);
	}
	if (gpGlobals->g.pWuGongList == NULL)
		TerminateOnError("分配武功信息内存失败\n");
	JY_GRPReadChunk((LPBYTE)gpGlobals->g.pWuGongList,uSize,uAddress,fpRGrp);
	gpGlobals->g.iWuGongCount = uSize / 136;

	//小宝信息
	JY_IDXGetChunkBaseInfo(5,fpRIdx,&uSize,&uAddress);
	if (gpGlobals->g.pXiaoBaoList == NULL)
	{
		gpGlobals->g.pXiaoBaoList = (LPXIAOBAOGATTRIB)malloc(uSize);
	}
	if (gpGlobals->g.pXiaoBaoList == NULL)
		TerminateOnError("分配小宝信息内存失败\n");
	JY_GRPReadChunk((LPBYTE)gpGlobals->g.pXiaoBaoList,uSize,uAddress,fpRGrp);

	UTIL_CloseFile(fpRIdx);
	UTIL_CloseFile(fpRGrp);

	JY_LoadScene();
	JY_LoadAllEvent();
	JY_LoadKdef();

	if (iSaveSlot != 0)
	{
		gpGlobals->g.Status = 2;
		gpGlobals->g.iSceneNum = -1;		
	}
	else
	{
		gpGlobals->g.Status = 1;
		gpGlobals->g.iSceneNum = g_iHeroHome;
		gpGlobals->g.pBaseList->SMapX = g_iHeroStartX;
		gpGlobals->g.pBaseList->SMapY = g_iHeroStartY;

		gpGlobals->g.iMyPic = g_iHeroStartImg;

		if (strcmp((char*)gpGlobals->g.pPersonList[0].name2big5,"MillKnife") == 0)
		{
			gpGlobals->g.pPersonList[0].NeiliXingZhi = 2;
			gpGlobals->g.pPersonList[0].HpAdd = 10;
			gpGlobals->g.pPersonList[0].hpMax = 50;
			gpGlobals->g.pPersonList[0].hp = 50;
			gpGlobals->g.pPersonList[0].NeiliMax = 50;
			gpGlobals->g.pPersonList[0].Neili = 50;
			gpGlobals->g.pPersonList[0].GongJiLi = 50;	
			gpGlobals->g.pPersonList[0].QingGong = 50;
			gpGlobals->g.pPersonList[0].FangYuLi = 50;
			gpGlobals->g.pPersonList[0].YiLiao = 50;
			gpGlobals->g.pPersonList[0].YongDu = 50;
			gpGlobals->g.pPersonList[0].JieDu = 50;
			gpGlobals->g.pPersonList[0].KangDu = 50;
			gpGlobals->g.pPersonList[0].QuanZhang = 50;
			gpGlobals->g.pPersonList[0].YuJian = 50;
			gpGlobals->g.pPersonList[0].ShuaDao = 50;
			gpGlobals->g.pPersonList[0].TeSHuBingQi = 50;
			gpGlobals->g.pPersonList[0].AnQiJiQiao = 50;
			gpGlobals->g.pPersonList[0].ZiZhi = 100;
			JY_ThingSet(g_iMoney,2000);
		}
		else
		{
			gpGlobals->g.pPersonList[0].NeiliXingZhi = gpGlobals->g.Hero.NeiliXingZhi;
			gpGlobals->g.pPersonList[0].HpAdd = gpGlobals->g.Hero.HpAdd;
			gpGlobals->g.pPersonList[0].hpMax = gpGlobals->g.Hero.hpMax;
			gpGlobals->g.pPersonList[0].hp = gpGlobals->g.Hero.hp;
			gpGlobals->g.pPersonList[0].NeiliMax = gpGlobals->g.Hero.NeiliMax;
			gpGlobals->g.pPersonList[0].Neili = gpGlobals->g.Hero.Neili;
			gpGlobals->g.pPersonList[0].GongJiLi = gpGlobals->g.Hero.GongJiLi;	
			gpGlobals->g.pPersonList[0].QingGong = gpGlobals->g.Hero.QingGong;
			gpGlobals->g.pPersonList[0].FangYuLi = gpGlobals->g.Hero.FangYuLi;
			gpGlobals->g.pPersonList[0].YiLiao = gpGlobals->g.Hero.YiLiao;
			gpGlobals->g.pPersonList[0].YongDu = gpGlobals->g.Hero.YongDu;
			gpGlobals->g.pPersonList[0].JieDu = gpGlobals->g.Hero.JieDu;
			gpGlobals->g.pPersonList[0].KangDu = gpGlobals->g.Hero.KangDu;
			gpGlobals->g.pPersonList[0].QuanZhang = gpGlobals->g.Hero.QuanZhang;
			gpGlobals->g.pPersonList[0].YuJian = gpGlobals->g.Hero.YuJian;
			gpGlobals->g.pPersonList[0].ShuaDao = gpGlobals->g.Hero.ShuaDao;
			gpGlobals->g.pPersonList[0].TeSHuBingQi = gpGlobals->g.Hero.TeSHuBingQi;
			gpGlobals->g.pPersonList[0].AnQiJiQiao = gpGlobals->g.Hero.AnQiJiQiao;
			gpGlobals->g.pPersonList[0].ZiZhi = gpGlobals->g.Hero.ZiZhi;
		}
	}
	
	//测试
	//gpGlobals->g.pBaseList->WuPin[4][0] = 121;
	//gpGlobals->g.pBaseList->WuPin[4][1] = 1;
	//gpGlobals->g.pBaseList->WuPin[4][0] = g_iMoney;
	//gpGlobals->g.pBaseList->WuPin[4][1] = 0;

	//整理物品，初始携带物品个数
	JY_ThingSort();

	//修复等级大于10
	for(int i=0;i<6;i++)
	{
		for(int j=0;j< 10;j++)
		{
			if (gpGlobals->g.pBaseList->Group[i] >= 0)
			{
				if (gpGlobals->g.pPersonList[gpGlobals->g.pBaseList->Group[i]].WuGong[j] > 0)
				{
					if (gpGlobals->g.pPersonList[gpGlobals->g.pBaseList->Group[i]].WuGongDengji[j] > 999)
					{
						gpGlobals->g.pPersonList[gpGlobals->g.pBaseList->Group[i]].WuGongDengji[j]=999;
					}
				}
			}
		}
	}
	//测试
	//gpGlobals->g.pPersonList[0].QingGong = 100;
	//gpGlobals->g.pPersonList[0].WuGongDengji[0] = 900;
	//gpGlobals->g.pPersonList[0].hp = 999;
	//gpGlobals->g.pPersonList[0].Neili = 999;
	//gpGlobals->g.pPersonList[0].hpMax = 999;
	//gpGlobals->g.pPersonList[0].NeiliMax = 999;
	//gpGlobals->g.pPersonList[0].WuGong[1] = 27;
	//gpGlobals->g.pPersonList[0].WuGongDengji[0] = 900;
	//gpGlobals->g.pPersonList[0].ZiZhi = 90;
}

//读取游戏事件
INT JY_LoadAllEvent(VOID)
{
	FILE *fp = NULL;	
	if (gpGlobals->g.pD == NULL)
	{
		gpGlobals->g.pD = (short*)malloc(g_iSmapNum*g_iDNum*11*2);
	}
	if (gpGlobals->g.pD == NULL)
		TerminateOnError("不能分配事件内存:JY_LoadAllEvent\n");
	char cFile[256] = {0};
	if (gpGlobals->bCurrentSaveSlot == 0)
	{
		sprintf(cFile,"%s\\Resource\\data\\AllDef.grp",JY_PREFIX);
	}
	if (gpGlobals->bCurrentSaveSlot == 1)
	{
		sprintf(cFile,"%s\\Resource\\data\\D1.grp",JY_PREFIX);
	}
	if (gpGlobals->bCurrentSaveSlot == 2)
	{
		sprintf(cFile,"%s\\Resource\\data\\D2.grp",JY_PREFIX);
	}
	if (gpGlobals->bCurrentSaveSlot == 3)
	{
		sprintf(cFile,"%s\\Resource\\data\\D3.grp",JY_PREFIX);
	}
	fp = fopen(cFile, "rb");
	if (fp == NULL)
	{
		SafeFree(gpGlobals->g.pD);
		TerminateOnError("打开文件失败%s!\n", cFile);
		return -1;
	}
	JY_FILEReadData((LPBYTE)gpGlobals->g.pD,fp);
	//JY_FILEReadData((LPBYTE)gpGlobals->g.sceneEventList,fp);

	//if (gpGlobals->bCurrentSaveSlot == 0)
	//{
	//	fp = UTIL_OpenRequiredFile("\\Resource\\data\\AllDef.grp");
	//	JY_FILEReadData((LPBYTE)gpGlobals->g.sceneEventList,fp);
	//}
	//if (gpGlobals->bCurrentSaveSlot == 1)
	//{
	//	fp = UTIL_OpenRequiredFile("\\Resource\\data\\D1.grp");
	//	JY_FILEReadData((LPBYTE)gpGlobals->g.sceneEventList,fp);
	//}
	//if (gpGlobals->bCurrentSaveSlot == 2)
	//{
	//	fp = UTIL_OpenRequiredFile("\\Resource\\data\\D2.grp");
	//	JY_FILEReadData((LPBYTE)gpGlobals->g.sceneEventList,fp);
	//}
	//if (gpGlobals->bCurrentSaveSlot == 3)
	//{
	//	fp = UTIL_OpenRequiredFile("\\Resource\\data\\D3.grp");
	//	JY_FILEReadData((LPBYTE)gpGlobals->g.sceneEventList,fp);
	//}
	UTIL_CloseFile(fp);
	return 0;
}
//读取内场景定义
INT JY_LoadScene(VOID)
{
	if (gpGlobals->g.pScene == NULL)
	{
		gpGlobals->g.pScene = (short*)malloc(g_iSmapXMax*g_iSMapYMax*6*2*g_iSmapNum);
	}
	if (gpGlobals->g.pScene == NULL)
		TerminateOnError("不能分配场景内存:JY_LoadScene\n");
	FILE *fpGrp = NULL;
	char cFile[256] = {0};
	if (gpGlobals->bCurrentSaveSlot == 0)
	{
		sprintf(cFile,"%s\\Resource\\data\\AllSin.grp",JY_PREFIX);
	}
	if (gpGlobals->bCurrentSaveSlot == 1)
	{
		sprintf(cFile,"%s\\Resource\\data\\S1.grp",JY_PREFIX);
	}
	if (gpGlobals->bCurrentSaveSlot == 2)
	{
		sprintf(cFile,"%s\\Resource\\data\\S2.grp",JY_PREFIX);
	}
	if (gpGlobals->bCurrentSaveSlot == 3)
	{
		sprintf(cFile,"%s\\Resource\\data\\S3.grp",JY_PREFIX);
	}
	fpGrp = fopen(cFile, "rb");

	if (fpGrp == NULL)
	{
		SafeFree(gpGlobals->g.pScene);
		return -1;
	}
	JY_FILEReadData((LPBYTE)gpGlobals->g.pScene,fpGrp);
	UTIL_CloseFile(fpGrp);
	return 0;
}
//读取大地图数据
INT JY_LoadMMap(VOID)
{
	if (gpGlobals->g.bLoadMmap == FALSE)
	{
		FILE *fpBuilding = NULL;
		FILE *fpBuildx = NULL;
		FILE *fpBuildy = NULL;
		FILE *fpEarth = NULL;
		FILE *fpSurface = NULL;

		char cFile[256] = {0};
		sprintf(cFile,"%s\\Resource\\data\\Building.002",JY_PREFIX);
		fpBuilding = fopen(cFile,"rb");//UTIL_OpenRequiredFile("\\Resource\\data\\Building.002");
		if (fpBuilding == NULL)
		{
			TerminateOnError("打开文件失败%s!\n", cFile);
			return -1;
		}
		sprintf(cFile,"%s\\Resource\\data\\Buildx.002",JY_PREFIX);
		fpBuildx = fopen(cFile,"rb");//UTIL_OpenRequiredFile("\\Resource\\data\\Buildx.002");
		if (fpBuildx == NULL)
		{
			UTIL_CloseFile(fpBuilding);
			UTIL_CloseFile(fpBuildx);
			UTIL_CloseFile(fpBuildy);
			UTIL_CloseFile(fpEarth);
			UTIL_CloseFile(fpSurface);
			TerminateOnError("打开文件失败%s!\n", cFile);
			return -1;
		}
		sprintf(cFile,"%s\\Resource\\data\\Buildy.002",JY_PREFIX);
		fpBuildy = fopen(cFile,"rb");//UTIL_OpenRequiredFile("\\Resource\\data\\Buildy.002");
		if (fpBuildy == NULL)
		{
			UTIL_CloseFile(fpBuilding);
			UTIL_CloseFile(fpBuildx);
			UTIL_CloseFile(fpBuildy);
			UTIL_CloseFile(fpEarth);
			UTIL_CloseFile(fpSurface);
			TerminateOnError("打开文件失败%s!\n", cFile);
			return -1;
		}
		sprintf(cFile,"%s\\Resource\\data\\Earth.002",JY_PREFIX);
		fpEarth = fopen(cFile,"rb");//UTIL_OpenRequiredFile("\\Resource\\data\\Earth.002");
		if (fpEarth == NULL)
		{
			UTIL_CloseFile(fpBuilding);
			UTIL_CloseFile(fpBuildx);
			UTIL_CloseFile(fpBuildy);
			UTIL_CloseFile(fpEarth);
			UTIL_CloseFile(fpSurface);
			TerminateOnError("打开文件失败%s!\n", cFile);
			return -1;
		}
		sprintf(cFile,"%s\\Resource\\data\\Surface.002",JY_PREFIX);
		fpSurface = fopen(cFile,"rb");//UTIL_OpenRequiredFile("\\Resource\\data\\Surface.002");
		if (fpSurface == NULL)
		{
			UTIL_CloseFile(fpBuilding);
			UTIL_CloseFile(fpBuildx);
			UTIL_CloseFile(fpBuildy);
			UTIL_CloseFile(fpEarth);
			UTIL_CloseFile(fpSurface);
			TerminateOnError("打开文件失败%s!\n", cFile);
			return -1;
		}
		if (gpGlobals->g.pEarth == NULL)
		{
			gpGlobals->g.pEarth = (short*) malloc(g_iMmapXMax*g_iMmapYMax*2);
		}
		JY_FILEReadData((LPBYTE)gpGlobals->g.pEarth,fpEarth);
		if (gpGlobals->g.pSurface == NULL)
		{
			gpGlobals->g.pSurface = (short*) malloc(g_iMmapXMax*g_iMmapYMax*2);
		}
		JY_FILEReadData((LPBYTE)gpGlobals->g.pSurface,fpSurface);
		if (gpGlobals->g.pBuilding == NULL)
		{
			gpGlobals->g.pBuilding = (short*) malloc(g_iMmapXMax*g_iMmapYMax*2);
		}
		JY_FILEReadData((LPBYTE)gpGlobals->g.pBuilding,fpBuilding);
		if (gpGlobals->g.pBuildX == NULL)
		{
			gpGlobals->g.pBuildX = (short*) malloc(g_iMmapXMax*g_iMmapYMax*2);
		}
		JY_FILEReadData((LPBYTE)gpGlobals->g.pBuildX,fpBuildx);
		if (gpGlobals->g.pBuildY == NULL)
		{
			gpGlobals->g.pBuildY = (short*) malloc(g_iMmapXMax*g_iMmapYMax*2);
		}
		JY_FILEReadData((LPBYTE)gpGlobals->g.pBuildY,fpBuildy);
		
		UTIL_CloseFile(fpBuilding);
		UTIL_CloseFile(fpBuildx);
		UTIL_CloseFile(fpBuildy);
		UTIL_CloseFile(fpEarth);
		UTIL_CloseFile(fpSurface);
		gpGlobals->g.bLoadMmap = TRUE;
	}
	
	return 0;
}
// 限制x大小
INT limitX(INT x, INT xmin, INT xmax)
{
    if(x>xmax)
		x=xmax;
	if(x<xmin)
		x=xmin;
	return x;
}
//转换RLE图像数据
VOID JY_TRANS(VOID)
{
	try
	{
		JY_TRANS_DATA(g_cmmap,"",1);//"MMap"
		JY_TRANS_DATA(g_csmap,"",2);//"SMap"
		JY_TRANS_DATA(g_chdgrp,"",3);//"Hdgrp"
		JY_TRANS_DATA(g_cwmap,"",4);//"WMap"
		JY_TRANS_DATA(g_ceft,"",5);//"Eft"
		
		INT i = 0;
		char cFilegrp[256] = {0};
		char cFileidx[256] = {0};
		for(i=0;i<g_iFightNum+1;i++)
		{
			sprintf(cFilegrp,g_cfightgrp,i);
			sprintf(cFileidx,g_cfightidx,i);
			JY_TRANS_DATA(cFilegrp,cFileidx,6);
			SDL_Delay(50);
		}
		
	}catch(const char* s)
	{
		TerminateOnError(s);
	}
}
VOID JY_TRANS_DATA(LPSTR fileName,LPCSTR fileidxName,INT iType)
{
	INT iLen = 0;
	INT i = 0;
	INT j = 0;
	INT iSize = 0;
	INT iOffset = 0;
	
	INT iStart = 0;
	INT iEnd = 0;

	INT iFileLen = 0;
	INT iW = 0;
	INT iH = 0;
	INT iOffX = 0;
	INT iOffY = 0;

	FILE *fpIdx = NULL;
	FILE *fpGrp = NULL;
	char cFile[256] = {0};
	if (iType == 6)
	{
		sprintf(cFile,"%s\\Resource\\data\\%s.idx",JY_PREFIX,fileidxName);
	}
	else
	{
		sprintf(cFile,"%s\\Resource\\data\\%s.idx",JY_PREFIX,fileName);
	}
	fpIdx = fopen(cFile, "rb");//UTIL_OpenRequiredFile(cFile);
	if (fpIdx == NULL )
	{
		UTIL_CloseFile(fpIdx);
		UTIL_CloseFile(fpGrp);
		return;
	}
	sprintf(cFile,"%s\\Resource\\data\\%s.grp",JY_PREFIX,fileName);
	fpGrp = fopen(cFile, "rb");//UTIL_OpenRequiredFile(cFile);

	if (fpGrp == NULL)
	{
		UTIL_CloseFile(fpIdx);
		UTIL_CloseFile(fpGrp);
		return;
	}

	FILE *fpNewIdx = NULL;
	if (iType == 6)
	{
		sprintf(cFile,"%s\\Resource\\data\\Fight\\%s.idx",JY_PREFIX,fileName);
	}
	else
	{
		sprintf(cFile,"%s\\Resource\\data\\%s\\%s.idx",JY_PREFIX,fileName,fileName);
	}
	fpNewIdx = fopen(cFile, "wb");
	if (fpNewIdx == NULL)
	{
		UTIL_CloseFile(fpIdx);
		UTIL_CloseFile(fpGrp);
		return;
	}
	FILE *fpNewData = NULL;
	if (iType == 1)
	{
		fpNewData = gpGlobals->f.fpMmapGrp;
	}
	if (iType == 2)
	{
		fpNewData = gpGlobals->f.fpSmapGrp;
	}
	if (fpNewData == NULL)
	{
		if (iType == 6)
		{
			sprintf(cFile,"%s\\Resource\\data\\Fight\\%s.grp",JY_PREFIX,fileName);
		}
		else
		{
			sprintf(cFile,"%s\\Resource\\data\\%s\\%s.grp",JY_PREFIX,fileName,fileName);
		}
		fpNewData = fopen(cFile, "wb");
	}
	else
	{
		UTIL_CloseFile(fpNewData);
		if (iType == 6)
		{
			sprintf(cFile,"%s\\Resource\\data\\Fight\\%s.grp",JY_PREFIX,fileName);
		}
		else
		{
			sprintf(cFile,"%s\\Resource\\data\\%s\\%s.grp",JY_PREFIX,fileName,fileName);
		}
		fpNewData = fopen(cFile, "wb");
	}
	if (fpNewData == NULL)
	{
		UTIL_CloseFile(fpIdx);
		UTIL_CloseFile(fpGrp);
		UTIL_CloseFile(fpNewIdx);
		return;
	}
	iLen = JY_GetFileLength(fpIdx);
	iLen = iLen /4;

	for(i=0;i<iLen;i++)
	{
		iFileLen = 0;
		iW = 0;
		iH = 0;
		iOffX = 0;
		iOffY = 0;
		iSize = 0;
		iOffset = 0;
		JY_IDXGetChunkBaseInfo(i,fpIdx,&iSize,&iOffset);

		if (iSize > 12 )//&& iSize < 32767
		{
			LPBYTE buf = NULL;
			buf = (LPBYTE)malloc(iSize);
			if (buf == NULL)
				TerminateOnError("Could not calloc MmapPic Mem \n");
			if (JY_GRPReadChunk(buf,iSize,iOffset,fpGrp) < 0)
				TerminateOnError("Could not Read Mmap.Grp \n");
			
			iW =*(short*)buf;
			iH=*(short*)(buf+2);
			iOffX=*(short*)(buf+4);
			iOffY=*(short*)(buf+6);

			if (iW > 200 && iH > 200)
			{
				SafeFree(buf);
				UTIL_CloseFile(fpIdx);
				UTIL_CloseFile(fpGrp);
				UTIL_CloseFile(fpNewIdx);
				UTIL_CloseFile(fpNewData);
				TerminateOnError("%s文件中%d位置图像宽高越界w=%d,h=%d \n",fileName,iOffset,iW,iH);
			}

			iFileLen = iW * iH;
			iEnd += iFileLen;
			iStart = iEnd -iFileLen;
			
			LPBYTE bufData = NULL;
			bufData = (LPBYTE)malloc(iFileLen);
			if (bufData == NULL)
				TerminateOnError("Could not calloc MmapPic Mem \n");
			//----
			for(j=0;j<iFileLen;j++)
				bufData[j]=TRANSCOLOR;//g_colors32[TRANSCOLOR];
			
			BYTE btRow			= 0;//一行图像所占字节数
			BYTE btTrans		= 0;//透明颜色个数
			BYTE btUnTrans		= 0;//不透明颜色个数
			BYTE btLastUnTrans	= 0;//已经读取过颜色字节数
			BYTE btWidth		= 0;//宽
			BYTE btHeight		= 0;//高
			INT x = 0;
			INT y = 0;
			INT iRowCel = 8;

			btRow = buf[iRowCel];
			btTrans = buf[iRowCel + 1];
			btUnTrans = buf[iRowCel + 2];

			for(int i=0;i<iH;i++)
			{
				btLastUnTrans = 0;
				int iNumH = x;
				for(int j=btLastUnTrans+btUnTrans+2;j<=btRow;)
				{
					//透明点
					for(int k=0;k<btTrans;k++)
					{
						iNumH++;
					}
					//不透明点
					for(int l=0;l<btUnTrans;l++)
					{
						BYTE bColor = buf[iRowCel + 3 + btLastUnTrans + l];
						bufData[ (i+y)*iW +iNumH ] = bColor;
						//VIDEO_PutPixel(lpDstSurface,iNumH,i + y,uiColor);
						iNumH++;
					}
					btLastUnTrans = btLastUnTrans+btUnTrans+2;	
					if (btLastUnTrans < btRow)
					{
						btTrans = buf[iRowCel +btLastUnTrans + 1];
						btUnTrans = buf[iRowCel + btLastUnTrans + 2];
					}
					else
					{
						j=btRow+1;//跳出循环
					}
				}//
				iRowCel = iRowCel + btRow +1;
				btRow = buf[iRowCel];//一行图像所占字节数
				btTrans = buf[iRowCel + 1];
				btUnTrans = buf[iRowCel + 2];
			}
			fwrite(bufData, iFileLen, 1, fpNewData);
			SafeFree(buf);
			SafeFree(bufData);
		}
		fwrite(&iFileLen,4,1,fpNewIdx);
		fwrite(&iW,4,1,fpNewIdx);
		fwrite(&iH,4,1,fpNewIdx);
		fwrite(&iOffX,4,1,fpNewIdx);
		fwrite(&iOffY,4,1,fpNewIdx);
		fwrite(&iStart,4,1,fpNewIdx);
	}
	UTIL_CloseFile(fpIdx);
	UTIL_CloseFile(fpGrp);
	UTIL_CloseFile(fpNewIdx);
	UTIL_CloseFile(fpNewData);
	if (iType == 1)
	{
		UTIL_CloseFile(gpGlobals->f.fpMmapGrp);
		sprintf(cFile,"%s\\Resource\\data\\%s\\%s.grp",JY_PREFIX,fileName,fileName);
		gpGlobals->f.fpMmapGrp =fopen(cFile,"rb"); //UTIL_OpenRequiredFile(cFile);
	}
	else if (iType == 2)
	{
		UTIL_CloseFile(gpGlobals->f.fpSmapGrp);
		sprintf(cFile,"\\Resource\\data\\%s\\%s.grp",JY_PREFIX,fileName,fileName);
		gpGlobals->f.fpSmapGrp =fopen(cFile,"rb"); //UTIL_OpenRequiredFile(cFile);
	}
	
	
}
//读取压缩事件定义
INT JY_LoadKdef(VOID)
{
	if (gpGlobals->g.bLoadKdef == FALSE)
	{
		INT i=0;
		FILE *fpKdefIdx = NULL;
		FILE *fpKdefGrp = NULL;
		char cFile[256] = {0};
		sprintf(cFile,"%s\\Resource\\data\\KDEF.idx",JY_PREFIX);
		fpKdefIdx = fopen(cFile,"rb");//UTIL_OpenRequiredFile("\\Resource\\data\\KDEF.idx");
		if (fpKdefIdx == NULL)
			TerminateOnError("打开文件失败Kdef.idx\n");
		sprintf(cFile,"%s\\Resource\\data\\KDEF.grp",JY_PREFIX);
		fpKdefGrp = fopen(cFile,"rb");//UTIL_OpenRequiredFile("\\Resource\\data\\KDEF.grp");
		if (fpKdefGrp == NULL)
			TerminateOnError("打开文件失败Kdef.grp\n");
		INT iNum = 0;
		iNum = JY_IDXGetChunkCount(fpKdefIdx);
		if (iNum < 0)
			TerminateOnError("Could not Read Kdef.Idx\n");
		gpGlobals->g.pKdefList = (LPKDEFTYPE)calloc(iNum + 1, sizeof(KDEFTYPE));
		if (gpGlobals->g.pKdefList == NULL)
			TerminateOnError("Could not calloc Kdef Idx Mem \n");

		INT *pIdx = NULL;
		pIdx = (INT*)calloc(iNum + 1, sizeof(INT));
		if (pIdx == NULL)
			TerminateOnError("Could not calloc Smap Idx Mem \n");

		JY_FILEReadData((LPBYTE)pIdx,fpKdefIdx);
		INT uPicLen = 0;
		INT uPicOffset = 0;
		for(i=0;i< iNum;i++)
		{
			if (i == 0)
			{
				uPicOffset = 0;
				uPicLen = pIdx[i];
			}
			else
			{
				uPicOffset = pIdx[i -1];
				uPicLen = pIdx[i] - pIdx[i -1];
			}
			if (uPicLen > 0)
			{
				short *buf = NULL;
				buf = (short*)calloc(uPicLen/2 + 1, sizeof(short));
				if (buf == NULL)
					TerminateOnError("Could not calloc Kdef Mem \n");
				if (JY_GRPReadChunk((LPBYTE)buf,uPicLen,uPicOffset,fpKdefGrp) < 0)
					TerminateOnError("Could not Read Kdef.Grp \n");
				gpGlobals->g.pKdefList[i].pData = buf;
				gpGlobals->g.pKdefList[i].iDataLength = uPicLen/2;
				gpGlobals->g.pKdefList[i].iNumlabel = i;
			}
			else
			{
				//gpGlobals->g.scenePicList->pRlePic[i].bIsEmpty = true;
			}

		}
		gpGlobals->g.iKdefListCount = iNum;
		SafeFree(pIdx);
		UTIL_CloseFile(fpKdefIdx);
		UTIL_CloseFile(fpKdefGrp);
	}
	return 0;
}
//保存进度
VOID JY_SaveSaveSlot(INT iSaveSlot)
{
	int iNum = 0;
	int iNumSub = 0;
	INT uSize = 0;
	INT uAddress = 0;
	FILE *fpRIdx = NULL;
	FILE *fpRGrp = NULL;

	char cFileIdx[256] = {0};
	char cFileGrp[256] = {0};
	if (iSaveSlot == 1)
	{
		sprintf(cFileIdx,"%s\\Resource\\data\\R1.idx",JY_PREFIX);
		sprintf(cFileGrp,"%s\\Resource\\data\\R1.grp",JY_PREFIX);
	}
	if (iSaveSlot == 2)
	{
		sprintf(cFileIdx,"%s\\Resource\\data\\R2.idx",JY_PREFIX);
		sprintf(cFileGrp,"%s\\Resource\\data\\R2.grp",JY_PREFIX);
	}
	if (iSaveSlot == 3)
	{
		sprintf(cFileIdx,"%s\\Resource\\data\\R3.idx",JY_PREFIX);
		sprintf(cFileGrp,"%s\\Resource\\data\\R3.grp",JY_PREFIX);
	}
	fpRIdx = fopen(cFileIdx, "rb");
	if (fpRIdx == NULL)
	{
		TerminateOnError("打开文件失败: %s!\n", cFileIdx);
	}
	fpRGrp = fopen(cFileGrp, "wb");
	if (fpRGrp == NULL)
	{
		UTIL_CloseFile(fpRIdx);
		TerminateOnError("打开文件失败: %s!\n", cFileGrp);
	}
	
	iNum = JY_IDXGetChunkCount(fpRIdx);
	if (iNum < 0)
		TerminateOnError("Could not Read Ranger.Idx\n");

	//基本信息
	JY_IDXGetChunkBaseInfo(0,fpRIdx,&uSize,&uAddress);
	if (gpGlobals->g.pBaseList == NULL)
		TerminateOnError("Could not calloc Ranger Idx Mem \n");
	fwrite(gpGlobals->g.pBaseList, uSize, 1, fpRGrp);

	////人物信息
	JY_IDXGetChunkBaseInfo(1,fpRIdx,&uSize,&uAddress);	
	if (gpGlobals->g.pPersonList == NULL)
		TerminateOnError("Could not calloc Ranger Idx Mem \n");
	fwrite(gpGlobals->g.pPersonList, uSize, 1, fpRGrp);
	//物品信息
	JY_IDXGetChunkBaseInfo(2,fpRIdx,&uSize,&uAddress);		
	if (gpGlobals->g.pThingsList == NULL)
		TerminateOnError("Could not calloc Ranger Idx Mem \n");
	fwrite(gpGlobals->g.pThingsList, uSize, 1, fpRGrp);
	//场景信息
	JY_IDXGetChunkBaseInfo(3,fpRIdx,&uSize,&uAddress);	
	if (gpGlobals->g.pSceneTypeList == NULL)
		TerminateOnError("Could not calloc Ranger Idx Mem \n");
	fwrite(gpGlobals->g.pSceneTypeList, uSize, 1, fpRGrp);
	//武功信息
	JY_IDXGetChunkBaseInfo(4,fpRIdx,&uSize,&uAddress);		
	if (gpGlobals->g.pWuGongList == NULL)
		TerminateOnError("Could not calloc Ranger Idx Mem \n");
	fwrite(gpGlobals->g.pWuGongList, uSize, 1, fpRGrp);
	//小宝信息
	JY_IDXGetChunkBaseInfo(5,fpRIdx,&uSize,&uAddress);	
	if (gpGlobals->g.pXiaoBaoList == NULL)
		TerminateOnError("Could not calloc Ranger Idx Mem \n");
	fwrite(gpGlobals->g.pXiaoBaoList, uSize, 1, fpRGrp);

	UTIL_CloseFile(fpRIdx);
	UTIL_CloseFile(fpRGrp);

	//--------------事件------------------
	if (iSaveSlot == 1)
	{
		sprintf(cFileGrp,"%s\\Resource\\data\\D1.grp",JY_PREFIX);		
	}
	if (iSaveSlot == 2)
	{
		sprintf(cFileGrp,"%s\\Resource\\data\\D2.grp",JY_PREFIX);	
	}
	if (iSaveSlot == 3)
	{
		sprintf(cFileGrp,"%s\\Resource\\data\\D3.grp",JY_PREFIX);	
	}
	fpRGrp = fopen(cFileGrp, "wb");
	if (fpRGrp == NULL)
	{
		TerminateOnError("打开文件失败: %s!\n", cFileGrp);
	}
	uSize = g_iSmapNum*g_iDNum*11*2;//sizeof(gpGlobals->g.sceneEventList);//440000;
	fwrite(gpGlobals->g.pD, uSize, 1, fpRGrp);
	//fwrite(gpGlobals->g.sceneEventList, uSize, 1, fpRGrp);
	UTIL_CloseFile(fpRGrp);
	//--------------场景-------------------
	if (gpGlobals->bCurrentSaveSlot == 0)
	{
		sprintf(cFileGrp,"%s\\Resource\\data\\AllSin.grp",JY_PREFIX);
	}
	if (gpGlobals->bCurrentSaveSlot == 1)
	{
		sprintf(cFileGrp,"%s\\Resource\\data\\S1.grp",JY_PREFIX);
	}
	if (gpGlobals->bCurrentSaveSlot == 2)
	{
		sprintf(cFileGrp,"%s\\Resource\\data\\S2.grp",JY_PREFIX);
	}
	if (gpGlobals->bCurrentSaveSlot == 3)
	{
		sprintf(cFileGrp,"%s\\Resource\\data\\S3.grp",JY_PREFIX);
	}
	fpRGrp = fopen(cFileGrp, "wb");
	if (fpRGrp == NULL)
	{
		TerminateOnError("打开文件失败: %s!\n", cFileGrp);
	}
	uSize = g_iSmapXMax*g_iSMapYMax*6*2*g_iSmapNum;//4915200;
	fwrite(gpGlobals->g.pScene, uSize, 1, fpRGrp);
	UTIL_CloseFile(fpRGrp);
}
