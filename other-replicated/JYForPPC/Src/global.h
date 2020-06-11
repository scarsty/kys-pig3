#ifndef GLOBAL_H
#define GLOBAL_H

#include "common.h"

#ifdef __cplusplus
extern "C"
{
#endif
#define                   HONGCOLOR          21
#define                   ZHICOLOR          79
#define					  TRANSCOLOR         232
#define					  BAICOLOR         101
#define					  HUANGCOLOR         44
#define                   BACKCOLOR          0
#define                   WARDATASIZE        186//战斗数据大小  war.sta数据结构
#define XSCALE 18
#define YSCALE 9
#pragma pack(push,1)
enum JYPERSONSTATUS
{
    enum_sex = 1,//性别
	enum_grade = 2,//等级
	enum_exp = 3,//经验
	enum_hp = 4,//生命
	enum_hpMax = 5,//生命上限
	enum_ShouShang = 6,//受伤程度
	enum_ZhongDu = 7,//中毒程度
	enum_Tili = 8,//体力
	enum_WuPinXiuLian = 9,//物品修炼
	enum_WuQi = 10,//武器
	enum_Fangju = 11,//防具
	enum_NeiliXingZhi = 12,//内力性质
	enum_Neili = 13,//内力
	enum_NeiliMax = 14,//内力上限
	enum_GongJiLi = 15,//攻击力
	enum_QingGong = 16,//轻功
	enum_FangYuLi = 17,//防御力
	enum_YiLiao = 18,//医疗
	enum_YongDu = 19,//用毒
	enum_JieDu = 20,//解毒
	enum_KangDu = 21,//抗毒
	enum_QuanZhang = 22,//拳掌
	enum_YuJian = 23,//御剑
	enum_ShuaDao = 24,//耍刀
	enum_TeSHuBingQi = 25,//特殊兵器
	enum_AnQiJiQiao = 26,//暗器技巧
	enum_WuXueChangShi = 27,//武学常识
	enum_PinDe = 28,//品德
	enum_GongjiDaiDu = 29,//攻击带毒
	enum_ZuoYouHuBo = 30,//左右互搏
	enum_ShengWang = 31,//声望
	enum_ZiZhi = 32,//资质
	enum_XiuLianWuPin = 33,//修炼物品
	enum_XiuLianDianShu = 34,//修炼点数
	enum_XueHuiWuGong=35,//学会武功
};

typedef struct UKeyList
{
	int uK_up, uK_down, uK_left, uK_right, uK_esc, uK_ok;
	int uK_e, uK_w, uK_r, uK_a;
	BOOL bVkey;
} DefinedKey;

typedef struct Building_Type{   
	int x;
	int y;
	int num;
}BuildingType;

//事件类型
typedef struct tagEventType
{
	short isGo;
	short id;
	short EventNum1;
	short EventNum2;
	short EventNum3;
	short PicNum[3];
	short PicDelay;
	short x;
	short y;
}EVENTTYPE, *LPEVENTTYPE;

//所有事件
typedef struct tagKdefType
{
	short iDataLength;
	short *pData;
	short iNumlabel;
}KDEFTYPE, *LPKDEFTYPE;
//基本数据
typedef struct tagBaseAttrib
{
	short ChengChuang;//乘船
	short WeiZhi;//无用
	short WMapX;//大地图人横坐标X
	short WMapY;//大地图人横坐标Y
	short SMapX;//进入场景的横坐标X
	short SMapY;//进入场景的横坐标Y
	short Way;//人面对方向
	short BoatX;//船X
	short BoatY;//船Y
	short BoatX1;//船X1
	short BoatY1;//船Y1
	short BoatWay;//
	short Group[6];//队友
	short WuPin[200][2];
}BASEATTRIB,*LPBASEATTRIB;
//人物属性
typedef struct tagPersonAttrib
{
	short id;//代号
	short PhotoId;//头像
	short HpAdd;//生命增长
	short r4;//无用
	BYTE name1big5[10];//姓名
	BYTE name2big5[10];//外号
	short sex;//性别
	short grade;//等级
	ushort exp;//经验
	short hp;//生命
	short hpMax;//生命上限
	short ShouShang;//受伤程度
	short ZhongDu;//中毒程度
	short Tili;//体力
	ushort WuPinXiuLian;//物品修炼
	short WuQi;//武器
	short Fangju;//防具
	short ChuZhaoDongHuaZhenShu[5];//出招动画帧数/医疗用毒解毒/拳/剑/刀/特殊
	short ChuZhaoDongHuaYanChi[5];//出招动画延迟/医疗用毒解毒/拳/剑/刀/特殊
	short WuGongYinXiaoYanChi[5];//武功音效延迟/医疗用毒解毒/拳/剑/刀/特殊
	short NeiliXingZhi;//内力性质
	short Neili;//内力
	short NeiliMax;//内力上限
	short GongJiLi;//攻击力
	short QingGong;//轻功
	short FangYuLi;//防御力
	short YiLiao;//医疗
	short YongDu;//用毒
	short JieDu;//解毒
	short KangDu;//抗毒
	short QuanZhang;//拳掌
	short YuJian;//御剑
	short ShuaDao;//耍刀
	short TeSHuBingQi;//特殊兵器
	short AnQiJiQiao;//暗器技巧
	short WuXueChangShi;//武学常识
	short PinDe;//品德
	short GongjiDaiDu;//攻击带毒
	short ZuoYouHuBo;//左右互搏
	short ShengWang;//声望
	short ZiZhi;//资质
	short XiuLianWuPin;//修炼物品
	ushort XiuLianDianShu;//修炼点数
	short WuGong[10];//武功
	short WuGongDengji[10];//武功
	short XieDaiWuPin[4];//携带物品
	short XieDaiWuPinShuLiang[4];//携带物品数量
}PERSONATTRIB, *LPPERSONATTRIB;
//物品属性
typedef struct tagThingsAttrib
{
	short id;//代号
	BYTE name1big5[20];//物品名
	BYTE name2big5[20];//物品名
	BYTE ShuoMingbig5[30];//说明
	short LianChuWuGong;//练出武功
	short AnQiDongHuaBianHao;//暗器动画编号
	short ShiYongRen;//使用人
	short ZhuangBeiLeiXing;//装备类型
	short XianShiWuPin;//显示物品说明
	short LeiXing;//类型
	short WeiZhi[3];//未知
	short JiaShengMing;//加生命
	short JiaSHengMingZuiDa;//加生命最大值
	short JiaZhongDuJieDu;//加中毒解毒
	short JiaTiLi;//加体力
	short GaiBianNeiLiXingZhi;//改变内力性质
	short JiaNeiLi;//加内力
	short JiaNeiLiZuiDa;//加内力最大值
	short JiaGongJiLi;//加攻击力
	short JiaQingGong;//加轻功
	short JiaFangYuLi;//加防御力
	short JiaYiLiao;//加医疗
	short JiaShiDu;//加使毒
	short JiaJieDu;//加解毒
	short JiaKangDu;//加抗毒
	short JiaQuanZhang;//加拳掌
	short JiaYuJian;//加御剑
	short JiaShuaDao;//加耍刀
	short JiaTeShuBingQi;//加特殊兵器
	short JiaAnQiJiQiao;//加暗器技巧
	short JiaWuXueChangShi;//加武学常识
	short JiaPinDe;//加品德
	short JiaGongJiCiShu;//加攻击次数
	short JiaGongFuDaiDu;//加功夫带毒
	short JinXiuLianRenWu;//仅修炼人物
	short XuNeiLiXingZhi;//需内力性质
	short XuNeiLi;//需内力
	short XuGongJiLi;//需攻击力
	short XuQingGong;//需轻功
	short XuShiDu;//需使毒
	short XuYiLiao;//需医疗	
	short XuJieDu;//需解毒
	short XuQuanZhang;//需拳掌
	short XuYuJian;//需御剑
	short XuShuaDao;//需耍刀
	short XuTeShuBingQi;//需特殊兵器
	short XuAnQiJiQiao;//需暗器技巧
	short XuZiZHi;//需资质
	short XuExpLianChengMiJi;//练成秘笈需要经验
	short XuExpLianChuWuPin;//练出物品需经验
	short XuCaiLiao;//需材料
	short LianChuWuPin[5];//练出物品
	short XuYaoWuPinShuLiang[5];//需要物品数量	
}THINGSATTRIB, *LPTHINGSATTRIB;
//场景
typedef struct tagSceneType
{
	short SceneID;
	BYTE Name1[10];
	short OutMusic;
	short InMusic;
	short JumpScene;
	short InCondition;
	short MMapInX1;
	short MMapInY1;
	short MMapInX2;
	short MMapInY2;
	short InX;
	short InY;
	short OutX[3];
	short OutY[3];
	short JumpX1;
	short JumpY1;
	short JumpX2;
	short JumpY2;
}SCENETYPE, *LPSCENETYPE;
//武功属性
typedef struct tagWuGongAttrib
{
	short ChengChuang;//代号
	BYTE Name1[10];//名称
	short WeiZhi[5];//无用
	short ChuZhaoYinXiao;//出招音效
	short WuGongLeiXing;//武功类型
	short WuGongDongHua;//武功动画&音效
	short ShangHaiLeiXing;//伤害类型
	short GongJiFanWei;//攻击范围
	short XiaoHaoNeiLi;//消耗内力点数
	short DiRenZhongDu;//敌人中毒点数
	short GongJiLi[10];//攻击力
	short YiDongFanWei[10];//移动范围
	short ShaShangFanWei[10];//杀伤范围
	short JiaNeiLi[10];//加内力
	short ShaShangNeiLi[10];//杀伤内力
}WUGONGATTRIB,*LPWUGONGATTRIB;
//小宝商店
typedef struct tagXiaoBaoAttrib
{
	short WuPin[5];//物品
	short WuPinShuLiang[5];//数量
	short WuPinJiaGe[5];//价格
}XIAOBAOATTRIB,*LPXIAOBAOGATTRIB;

//战斗人员信息
typedef struct tagWarGroup
{
	short iPerson;	
	BOOL  bSelf;
	short x;
	short y;
	BOOL  bDie;
	short iWay;
	short iPicCode;
	short iPicType;
	short iQingGong;
	short iYiDongBushu;
	short iDianShu;
	short iExp;
	short iAutoFoe;
}WARGROUP;

//战斗sta
typedef struct tagWarSta
{
	short iWarId;
	BYTE  Name[10];
	short iMapId;
	ushort iExp;
	short iMusic;
	short WarManualPerson[6];
	short WarAutoPerson[6];
	short PersonX[6];
	short PersonY[6];

	short WarfoePerson[20];
	short foeX[20];
	short foeY[20];
}WARSTA,*LPWARSTA;
//可移动步数
typedef struct tagMoveStep
{
	short x[100];
	short y[100];
	short num;
}MOVESTEP,*LPMOVESTEP;
//战斗
typedef struct tagWarAttrib
{
	short iWarId;//
	short *pSData;//
	LPWARSTA pWarSta;//
	WARGROUP warGroup[26];//
	short iPersonNum;//
	short iAutoFight;//
	short iCurID;//
	BOOL  bShowHead;//
	short iEffect;//
	INT   iEffectColor[7];//
	short SelectPerson[6][2];//参战队员
	BOOL  bSelectOther;//是否可以选择队员
	LPMOVESTEP pMoveStep;//移动步数
	LPMOVESTEP pAttackStep;//攻击步数
	short LastPerson;//最后一次行动人员
	short iRound;//练功时是否结束回合
	short iType;//标记是否练功

	short iFlagMaxShaShangPerson;//可以行动的杀伤最高者
	short iFlagMaxYiLiaoPerson;//可以行动的医疗最高者
	short iFlagMaxShouShangPerson;//受伤最高者
	short iFlagMaxJieDuPerson;//可以行动的解毒最高者
	short iFlagMaxZhongDuPerson;//中毒最高者
	short iFlagMinFoePerson;//敌方最弱者

}WARATTRIB,*LPWARATTRIB;

typedef struct tagFILES
{
	FILE            *fpMmapGrp; //外景地图块
	FILE            *fpSmapGrp; //内景地图块

	FILE            *fpTalkIdx; //对话索引
	FILE            *fpTalkGrp; //对话
	
	FILE            *fpHdGrpGrp;//头像数据

	FILE            *fpWmapGrp;//战斗地图块
	FILE            *fpEftGrp;//武功效果块	

	FILE            *fpFightGrp;//武功动作块	
} FILES, *LPFILES;

typedef struct tagGameData
{
	WARATTRIB   war;
	//
	INT			iSceneNum;	//当前场景编号
	INT         iSceneEventCode;
	LPKDEFTYPE pKdefList;//所有事件脚本
	INT         iKdefListCount;
	BOOL       bLoadKdef;
	//---------------------------------R存档中信息
	LPPERSONATTRIB pPersonList;//人物属性
	INT         iPersonCount;
	LPSCENETYPE pSceneTypeList;//场景基本信息
	INT         iSceneTypeListCount;
	LPBASEATTRIB pBaseList;//基本数据
	LPTHINGSATTRIB pThingsList;//物品属性
	INT         iThingsListCount;
	INT         iHaveThingsNum;
	INT         iLastUseThingNum;//上次使用物品位置
	INT         iLastUseSystemNum;//上次系统菜单位置
	INT         iLastUseTransNum;//上次传送位置
	LPXIAOBAOGATTRIB pXiaoBaoList;//小宝商店
	LPWUGONGATTRIB pWuGongList;//武功属性
	INT         iWuGongCount;
    //-----------------------------------

	//---------------------------------D存档中信息
	//EVENTTYPE sceneEventList[100][200];//场景事件列表
	short *pD;
	//-----------------------------------
	
	//---------------------------------S
	short *pScene;
	//-----------------------------------

	//---------------------------------大地图数据
	short *pEarth;
	short *pSurface;
	short *pBuilding;
	short *pBuildX;
	short *pBuildY;
	BOOL  bLoadMmap;
	short iXScale;
	short iYScale;
	short iMMapAddX;
	short iMMapAddY;
	short iSMapAddX;
	short iSMapAddY;
	short iWMapAddX;
	short iWMapAddY;
	BuildingType Build[2000];        // 建筑排序数组
	int iBuildNumber;     //实际排序个数
	//---------------------------------
	INT             Status;
	PERSONATTRIB Hero;

	short iMyCurrentPic;
	short iMyPic;              //主角当前贴图
    short iMytick;             //主角没有走路的持续帧数
	short iDirectX[4];
	short iDirectY[4];
	//---------------------------------
	short iSubSceneX;
	short iSubSceneY;

} GAMEDATA,*LPGAMEDATA;

typedef struct tagGLOBALVARS
{
	FILES            f;
	GAMEDATA         g;
	INT             bCurrentSaveSlot;    // current save slot (1-5)
	DefinedKey		curDefKey;
	BOOL             fGameStart;
	BOOL             fGameLoad;
	BOOL             fGameSave;
} GLOBALVARS, *LPGLOBALVARS;
#pragma pack(pop)
extern INT g_CharSet;
extern LPGLOBALVARS gpGlobals;

BOOL GetIniValue(const char* file, const char* session,const char* key,const char*defvalue, char* value);
BOOL GetIniField(FILE* fp, const char* session,const char* key,const char*defvalue, char* value);
int ReadLine(FILE *fp, char *buffer, int maxlen);
char** spilwhit(char* str, const char* strsp, DWORD* buf, int buflen, int* ct);
int FindChars(const char* p, const char* f, BOOL br);
void JY_DrawVKeys(void* pixels);
void ClearBuf(LPBYTE buf,int ilen);
INT JY_InitGlobals(VOID);
VOID JY_FreeGlobals(VOID);
VOID JY_InitGameData(INT iSaveSlot);
VOID JY_LoadSaveSlot(INT iSaveSlot);
INT JY_LoadAllEvent(VOID);
INT JY_LoadMMap(VOID);
INT JY_LoadScene(VOID);
INT limitX(INT x, INT xmin, INT xmax);
VOID JY_TRANS(VOID);
VOID JY_TRANS_DATA(LPSTR fileName,LPCSTR fileidxName,INT iType);
INT JY_LoadKdef(VOID);
VOID JY_SaveSaveSlot(INT iSaveSlot);
INT JY_LoadWarScene(VOID);
#ifdef __cplusplus
}
#endif

#endif