#ifndef _SCENE_H
#define	_SCENE_H

#ifdef	__cplusplus
extern "C"
{
#endif
short JY_GetMMap(short x, short y , short flag);
short JY_SetMMap(short x, short y , short flag, short v);
short BuildingSort(short x, short y, short Mypic);
INT JY_DrawMMap(INT x, INT y, INT Mypic);
VOID JY_Game_MMap(VOID);
INT JY_GetMyPic(VOID);
INT JY_CanEnterScene(INT x,INT y);
short JY_GetSMap(short id,short x, short y , short level);
short JY_SetSMap(short id,short x, short y , short level, short v);
short JY_GetD(short Sceneid,short id,short i);
short JY_SetD(short Sceneid,short id,short i,short v);
INT JY_DrawSMap(INT x, INT y,INT xoff,INT yoff, INT Mypic);
VOID JY_Game_SMap(VOID);
INT JY_SceneCanPass(INT x,INT y);
VOID JY_SystemMenu(VOID);
VOID JY_ReDrawMap(VOID);
VOID JY_DrawTalkDialog(short iTalkNum,short iHeadImgNum, short iFlag);
short JY_YiLiaoJieDuDilag(short iType);
short JY_DrawPersonYLJDDilag(short iCurrentItem,short iType);
short JY_DrawPersonListDilag(short iCurrentItem,short iType);
short JY_PresonListDilag(short iType);
short JY_ThingDilag(VOID);
VOID JY_PresonStatusDilag(VOID);

short WarMain(short warid,short flag,short iType);
VOID WarLoad(short warid);
VOID WarSetGlobal(VOID);
VOID WarSelectTeam(VOID);
VOID WarSelectEnemy(VOID);
short WarCalPersonPic(short id);
VOID WarPersonSort(VOID);
VOID WarSetPerson(VOID);
short JY_GetWarMap(short x,short y,short level);
short JY_SetWarMap(short x,short y,short level,short v);
short JY_CleanWarMap(short level,short v);
VOID WarDrawMap(INT flag, INT v1,INT v2);
INT JY_DrawWarNum(INT x, INT y, INT height,INT color);
INT JY_DrawWarMap(INT flag, INT x, INT y, INT v1,INT v2);
INT War_Manual(VOID);
INT War_Manual_Sub(VOID);
short War_GetMinNeiLi(short iPerson);
INT War_Auto(VOID);
INT War_Think(VOID);
INT War_ThinkDrug(INT flag);
INT War_ThinkDoctor(VOID);
VOID War_AutoFight(VOID);
INT JY_GoDilag(VOID);
INT War_AutoSelectWugong(short id);
INT War_AutoSelectEnemy(VOID);
INT War_AutoSelectEnemy_near(VOID);
INT War_AutoMove(INT wugongnum);
VOID WarShowHead(short id);
VOID War_AutoEscape(VOID);
VOID War_CalMoveStep(short id,short iBuShu,short flag);
VOID War_FindNextStep(short step,short flag);
BOOL War_CanMoveXY(short x,short y,short flag);
VOID War_RestMenu(VOID);
VOID War_AutoEatDrug(short flag);
VOID War_AutoDoctor(VOID);
VOID War_AutoDecPoison(VOID);
VOID War_AutoCalMaxEnemyMap(short wugongid,short level);
VOID War_MovePerson(short x,short y);
VOID War_GetCanFightEnemyXY(short &x,short &y);
short War_AutoCalMaxEnemy(short x,short y,short wugongid,short level,short &xmax,short &ymax);
VOID War_AutoExecuteFight(short wugongnum);
short War_Fight_Sub(short id,short wugongnum,short x,short y);
BOOL War_FightSelectType0(short wugong,short level,short x1,short y1);
BOOL War_FightSelectType1(short wugong,short level,short x1,short y1);
BOOL War_FightSelectType2(short wugong,short level,short x1,short y1);
BOOL War_FightSelectType3(short wugong,short level,short x1,short y1);
short War_Direct(short x1,short y1,short x2,short y2);
VOID War_ShowFight(short pid,short wugong,short wugongtype,short eft);
VOID WarDrawEffect(short pic);
short War_MoveMenu(VOID);
VOID War_SelectMove(short &x,short &y);
short WaitKey(VOID);
short War_FightMenu(VOID);
VOID War_AutoMenu(VOID);
short War_PoisonMenu(VOID);
short War_ExecuteMenu(short flag,short thingid);
short War_ExecuteMenu_Sub(short x1,short y1,short flag,short thingid);
short War_PoisonHurt(short pid,short emenyid);
short ExecDecPoison(short pid,short emenyid);
short ExecDoctor(short pid,short emenyid);
short War_AnqiHurt(short pid,short emenyid,short thingid);
short War_DecPoisonMenu(VOID);
short War_DoctorMenu(VOID);
short War_WugongHurtLife(short emenyid,short wugong,short level);
short War_WugongHurtNeili(short emenyid,short wugong,short level);
short War_isEnd(VOID);
VOID War_PersonLostLife(VOID);
VOID War_EndPersonData(short isexp,short warStatus);
short War_AddPersonLevel(short pid);
VOID War_PersonTrainBook(short pid);
ushort TrainNeedExp(short pid);
VOID War_PersonTrainDrug(short pid);
short War_ThingMenu(VOID);
short War_WaitMenu(VOID);
VOID War_StatusMenu(VOID);
VOID JY_DrawSceneName(VOID);
INT JY_TransMap(VOID);
VOID JY_Shop(VOID);
VOID JY_ShopMove();
short JY_PersonExit(short id);
VOID JY_ShowAttribAdd(short pid,short itype,short iNum);
VOID JY_END(VOID);
VOID War_NowStatus(VOID);
short War_AutoDoctorOther(short id);
short War_AutoecPoisonOther(short id);
#ifdef	__cplusplus
}
#endif

#endif