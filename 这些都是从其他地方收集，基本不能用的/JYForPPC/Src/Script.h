
#ifndef SCRIPT_H
#define SCRIPT_H

#ifdef __cplusplus
extern "C"
{
#endif
short JY_RunTriggerScript(short wScriptEntry,short aiWuPin);
VOID JY_ThingSet(short iWuPin,short iNum);//添减物品
short JY_FindThing(short iWuPin);//查找物品
VOID SetSceneInStatus(short iNum);//设置场景状态
short JY_CheckGroupNum(VOID);//检查队员人数
VOID JY_GroupSet(short iPerson,BOOL bIn);//队员入、离队
VOID JY_ThingSort(VOID);//
VOID JY_Sleep(VOID);//睡觉
short JY_FindPerson(short iPerson);//查找队伍中某人
VOID JY_SetScenePic(short iScene,short iLayer,short x,short y,short Pic);//设置某场景某层(x,y)图像
VOID JY_SetPersonStatus(short iType,short iPerson,short iNum,bool bSet);//设置某人某属性值，bSet=true设置数值=iNum，bSet=false在原有值上加
VOID JY_MoveScene(short xOld,short yOld,short xNew,short yNew,short iDrawHero);//移动场景iDrawHero=1显示人物行走
VOID JY_MoveSub(short direct);
short JY_UseThing(short iPersonIdx,short iWuPinIdx);//某人使用物品
short JY_UseThingForUser(short iPerson,short iWuPin,short iWuPinNum);
short JY_UseThingForNpc(short iPerson,short iWuPinIdx);//
short JY_UserYLJD(short iUsePersonIdx,short iDestPersonIdx,short iType);//某人向某人医疗解毒
short JY_AllPersonExit(VOID);
VOID JY_CheckBook(VOID);
short JY_WuDaoDaHui(VOID);
VOID JY_GaoChangMiGong(VOID);
extern BOOL       g_fScriptSuccess;
#ifdef __cplusplus
}
#endif

#endif