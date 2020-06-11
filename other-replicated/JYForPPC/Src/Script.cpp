#include "main.h"

BOOL            g_fScriptSuccess = TRUE;
//查找物品
short JY_FindThing(short iWuPin)
{
	int i = 0;
	for(i = 0;i<200;i++)
	{
		if (gpGlobals->g.pBaseList->WuPin[i][0] == iWuPin)
		{
			return i;
		}
	}
	return -1;
}
//设置物品
VOID JY_ThingSet(short iWuPin,short iNum)
{
	int i = 0;
	int iFind = -1;
	int iEnd = -1;
	for(i = 0;i<200;i++)
	{
		if (gpGlobals->g.pBaseList->WuPin[i][0] == iWuPin && iFind == -1)
		{
			iFind = i;
		}
		if (gpGlobals->g.pBaseList->WuPin[i][0] == -1 && iEnd == -1)
		{
			iEnd = i;
		}
	}
	if (iFind == -1 )
	{
		gpGlobals->g.pBaseList->WuPin[iEnd][0] = iWuPin;
		gpGlobals->g.pBaseList->WuPin[iEnd][1] = iNum;
	}
	else
	{
		gpGlobals->g.pBaseList->WuPin[iFind][1] = gpGlobals->g.pBaseList->WuPin[iFind][1] + iNum;
		if (gpGlobals->g.pBaseList->WuPin[iFind][1] <= 0)
		{
			gpGlobals->g.pBaseList->WuPin[iFind][0] = -1;
			gpGlobals->g.pBaseList->WuPin[iFind][1] = 0;
			JY_ThingSort();
		}
	}
	JY_CheckBook();
}
//整理物品
VOID JY_ThingSort(VOID)
{
	int i = 0;
	int j = 0;
	for(i = 0;i<200;i++)
	{
		if (gpGlobals->g.pBaseList->WuPin[i][0] == -1)
		{
			for(j=i+1;j<200;j++)
			{
				gpGlobals->g.pBaseList->WuPin[j-1][0] = gpGlobals->g.pBaseList->WuPin[j][0];
				gpGlobals->g.pBaseList->WuPin[j-1][1] = gpGlobals->g.pBaseList->WuPin[j][1];
			}
			gpGlobals->g.pBaseList->WuPin[199][0] = -1;
			gpGlobals->g.pBaseList->WuPin[199][1] = 0;
		}
	}
	gpGlobals->g.iHaveThingsNum = 0;
	for(i=0;i<200;i++)
	{
		if (gpGlobals->g.pBaseList->WuPin[i][0] != -1 && gpGlobals->g.pBaseList->WuPin[i][1] > 0)
		{
			gpGlobals->g.iHaveThingsNum++;
		}
		//由于前几次版本排序有问题，在此清除数量为零的物品
		if (gpGlobals->g.pBaseList->WuPin[i][1] == 0)
			gpGlobals->g.pBaseList->WuPin[i][0] = -1;

	}
}
//设置场景状态
VOID SetSceneInStatus(short iNum)
{
	if (iNum == -1)
	{
		int i = 0;
		for(i=0;i<gpGlobals->g.iSceneTypeListCount;i++)
		{
			gpGlobals->g.pSceneTypeList[i].InCondition = 0;
		}
		gpGlobals->g.pSceneTypeList[2].InCondition = 2;//云鹤崖
		gpGlobals->g.pSceneTypeList[38].InCondition = 2;//摩天崖
		gpGlobals->g.pSceneTypeList[75].InCondition = 1;//桃花岛
		gpGlobals->g.pSceneTypeList[80].InCondition = 1;//绝情谷底
	}
}
//检查队伍人数
short JY_CheckGroupNum(VOID)
{
	int i=0;
	int iNum = 0;
	for(i=0;i<6;i++)
	{
		if (gpGlobals->g.pBaseList->Group[i] != -1)
		{
			iNum++;
		}
	}
	return iNum;
}
//查找队员
short JY_FindPerson(short iPerson)
{
	int i=0;
	int iNum = -1;
	for(i=0;i<6;i++)
	{
		if (gpGlobals->g.pBaseList->Group[i] == iPerson)
		{
			iNum = i;
			break;
		}
	}
	return iNum;
}
//队员入离队
VOID JY_GroupSet(short iPerson,BOOL bIn)
{
	int i=0;
	int j=0;
	if(bIn)
	{
		for(i=0;i<6;i++)
		{
			if (gpGlobals->g.pBaseList->Group[i] == -1)
			{
				gpGlobals->g.pBaseList->Group[i] = iPerson;

				//该人物品归公
				for(j=0;j<4;j++)
				{
					if(gpGlobals->g.pPersonList[iPerson].XieDaiWuPin[j] >=0)
					{
						JY_ReDrawMap();
						JY_DrawGetThingDialog(gpGlobals->g.pPersonList[iPerson].XieDaiWuPin[j],
							gpGlobals->g.pPersonList[iPerson].XieDaiWuPinShuLiang[j]);
						JY_Delay(1000);
						JY_ThingSet(gpGlobals->g.pPersonList[iPerson].XieDaiWuPin[j],
							gpGlobals->g.pPersonList[iPerson].XieDaiWuPinShuLiang[j]);
						gpGlobals->g.pPersonList[iPerson].XieDaiWuPin[j] = -1;
						gpGlobals->g.pPersonList[iPerson].XieDaiWuPinShuLiang[j] = 0;
					}
				}
				//该人装备归公
				if (gpGlobals->g.pPersonList[iPerson].WuQi >= 0)
				{
					JY_ReDrawMap();
					JY_DrawGetThingDialog(gpGlobals->g.pPersonList[iPerson].WuQi,1);
					JY_Delay(1000);
				}
				if (gpGlobals->g.pPersonList[iPerson].Fangju >= 0)
				{
					JY_ReDrawMap();
					JY_DrawGetThingDialog(gpGlobals->g.pPersonList[iPerson].Fangju,1);
					JY_Delay(1000);
				}
				break;
			}
		}
	}
	else
	{
		short iCul = -1;
		for(i=0;i<6;i++)
		{
			if (gpGlobals->g.pBaseList->Group[i] == iPerson && gpGlobals->g.pBaseList->Group[i] != -1)
			{
				if (gpGlobals->g.pPersonList[iPerson].WuQi >=0)
				{
					gpGlobals->g.pThingsList[gpGlobals->g.pPersonList[iPerson].WuQi].ShiYongRen = -1;
					gpGlobals->g.pPersonList[iPerson].WuQi = -1;
				}
				if (gpGlobals->g.pPersonList[iPerson].Fangju >=0)
				{
					gpGlobals->g.pThingsList[gpGlobals->g.pPersonList[iPerson].Fangju].ShiYongRen = -1;
					gpGlobals->g.pPersonList[iPerson].Fangju = -1;
				}
				if (gpGlobals->g.pPersonList[iPerson].XiuLianWuPin >=0)
				{
					gpGlobals->g.pThingsList[gpGlobals->g.pPersonList[iPerson].XiuLianWuPin].ShiYongRen = -1;
					//此处既然有人发现此BUG，保留此功能，用于可以多人同时修炼一本秘笈
					//gpGlobals->g.pPersonList[iPerson].XiuLianWuPin = -1;
				}
				gpGlobals->g.pPersonList[iPerson].XiuLianDianShu = 0;
				gpGlobals->g.pPersonList[iPerson].WuPinXiuLian = 0;
				gpGlobals->g.pBaseList->Group[i] = -1;
				iCul = i;
				break;
			}
		}
		if (iCul >=0)
		{
			for(i=iCul+1;i<6;i++)
			{
				gpGlobals->g.pBaseList->Group[i-1] = gpGlobals->g.pBaseList->Group[i];
			}
			gpGlobals->g.pBaseList->Group[5] = -1;
		}
	}
}
//休息
VOID JY_Sleep(VOID)
{
	int i=0;
	int iNum = 0;
	for(i=0;i<6;i++)
	{
		iNum = gpGlobals->g.pBaseList->Group[i];
		if (iNum != -1)
		{
			if (gpGlobals->g.pPersonList[iNum].ShouShang < (g_ishoushangMax/2) && gpGlobals->g.pPersonList[iNum].ZhongDu <=0)
			{
				gpGlobals->g.pPersonList[iNum].hp = gpGlobals->g.pPersonList[iNum].hpMax;
				gpGlobals->g.pPersonList[iNum].Tili = g_itiliMax;
				gpGlobals->g.pPersonList[iNum].Neili = gpGlobals->g.pPersonList[iNum].NeiliMax;
				gpGlobals->g.pPersonList[iNum].ShouShang = 0;
			}
		}
	}
}
//设置场景图像
VOID JY_SetScenePic(short iScene,short iLayer,short x,short y,short Pic)
{
	JY_SetSMap(iScene,x,y,iLayer, Pic);
}
//设置人物状态
VOID JY_SetPersonStatus(short iType,short iPerson,short iNum,bool bSet)
{
	if (iPerson < 0 || iPerson >= gpGlobals->g.iPersonCount)
		return;
	int i = 0;
	int iFind1 = -1;
	int iFind2 = -1;
	switch (iType)
	{
	case enum_sex://性别
		gpGlobals->g.pPersonList[iPerson].sex = iNum;
		break;
	case enum_grade://等级
		if (bSet)
			gpGlobals->g.pPersonList[iPerson].grade = iNum;
		else
		{
			gpGlobals->g.pPersonList[iPerson].grade += iNum;
			if (gpGlobals->g.pPersonList[iPerson].grade < 0)
				gpGlobals->g.pPersonList[iPerson].grade = 0;
			if (gpGlobals->g.pPersonList[iPerson].grade > g_iGradMax)
				gpGlobals->g.pPersonList[iPerson].grade = g_iGradMax;

		}
		break;
	case enum_exp://经验
		if (bSet)
			gpGlobals->g.pPersonList[iPerson].exp = iNum;
		else
		{
			gpGlobals->g.pPersonList[iPerson].exp += iNum;
			if (gpGlobals->g.pPersonList[iPerson].exp < 0)
				gpGlobals->g.pPersonList[iPerson].exp = 0;

		}
		break;
	case enum_hp://生命
		if (bSet)
			gpGlobals->g.pPersonList[iPerson].hp = iNum;
		else
		{
			gpGlobals->g.pPersonList[iPerson].hp += iNum;
			if (gpGlobals->g.pPersonList[iPerson].hp < 0)
				gpGlobals->g.pPersonList[iPerson].hp = 0;
			if (gpGlobals->g.pPersonList[iPerson].hp > gpGlobals->g.pPersonList[iPerson].hpMax)
				gpGlobals->g.pPersonList[iPerson].hp = gpGlobals->g.pPersonList[iPerson].hpMax;

		}
		break;
	case enum_hpMax://生命上限
		if (bSet)
			gpGlobals->g.pPersonList[iPerson].hpMax = iNum;
		else
		{
			gpGlobals->g.pPersonList[iPerson].hpMax += iNum;
			if (gpGlobals->g.pPersonList[iPerson].hpMax < 0)
				gpGlobals->g.pPersonList[iPerson].hpMax = 0;
			if (gpGlobals->g.pPersonList[iPerson].hpMax > g_ishengmingMax)
				gpGlobals->g.pPersonList[iPerson].hpMax = g_ishengmingMax;
			//WB090716
			gpGlobals->g.pPersonList[iPerson].hp += iNum;
			if (gpGlobals->g.pPersonList[iPerson].hp < 0)
				gpGlobals->g.pPersonList[iPerson].hp = 0;
			if (gpGlobals->g.pPersonList[iPerson].hp > gpGlobals->g.pPersonList[iPerson].hpMax)
				gpGlobals->g.pPersonList[iPerson].hp = gpGlobals->g.pPersonList[iPerson].hpMax;
		}
		break;
	case enum_ShouShang://受伤程度
		if (bSet)
			gpGlobals->g.pPersonList[iPerson].ShouShang = iNum;
		else
		{
			gpGlobals->g.pPersonList[iPerson].ShouShang += iNum;
			if (gpGlobals->g.pPersonList[iPerson].ShouShang < 0)
				gpGlobals->g.pPersonList[iPerson].ShouShang = 0;
			if (gpGlobals->g.pPersonList[iPerson].ShouShang > g_ishoushangMax)
				gpGlobals->g.pPersonList[iPerson].ShouShang = g_ishoushangMax;

		}
		break;
	case enum_ZhongDu://中毒程度
		if (bSet)
			gpGlobals->g.pPersonList[iPerson].ZhongDu = iNum;
		else
		{
			gpGlobals->g.pPersonList[iPerson].ZhongDu += iNum;
			if (gpGlobals->g.pPersonList[iPerson].ZhongDu < 0)
				gpGlobals->g.pPersonList[iPerson].ZhongDu = 0;
			if (gpGlobals->g.pPersonList[iPerson].ZhongDu > g_izhongduMax)
				gpGlobals->g.pPersonList[iPerson].ZhongDu = g_izhongduMax;
		}
		break;
	case enum_Tili://体力
		if (bSet)
			gpGlobals->g.pPersonList[iPerson].Tili = iNum;
		else
		{
			gpGlobals->g.pPersonList[iPerson].Tili += iNum;
			if (gpGlobals->g.pPersonList[iPerson].Tili < 0)
				gpGlobals->g.pPersonList[iPerson].Tili = 0;
			if (gpGlobals->g.pPersonList[iPerson].Tili > g_itiliMax)
				gpGlobals->g.pPersonList[iPerson].Tili = g_itiliMax;
		}
		break;
	case enum_WuPinXiuLian://物品修炼
		if (bSet)
			gpGlobals->g.pPersonList[iPerson].WuPinXiuLian = iNum;
		else
		{
			gpGlobals->g.pPersonList[iPerson].WuPinXiuLian += iNum;
			if (gpGlobals->g.pPersonList[iPerson].WuPinXiuLian < 0)
				gpGlobals->g.pPersonList[iPerson].WuPinXiuLian = 0;

		}
		break;
	case enum_WuQi://武器
		break;
	case enum_Fangju://防具
		break;
	case enum_NeiliXingZhi://内力性质
		gpGlobals->g.pPersonList[iPerson].NeiliXingZhi = iNum;
		break;
	case enum_Neili://内力
		if (bSet)
			gpGlobals->g.pPersonList[iPerson].Neili = iNum;
		else
		{
			gpGlobals->g.pPersonList[iPerson].Neili += iNum;
			if (gpGlobals->g.pPersonList[iPerson].Neili < 0)
				gpGlobals->g.pPersonList[iPerson].Neili = 0;
			if (gpGlobals->g.pPersonList[iPerson].Neili > gpGlobals->g.pPersonList[iPerson].NeiliMax)
				gpGlobals->g.pPersonList[iPerson].Neili = gpGlobals->g.pPersonList[iPerson].NeiliMax;
		}
		break;
	case enum_NeiliMax://内力上限
		if (bSet)
			gpGlobals->g.pPersonList[iPerson].NeiliMax = iNum;
		else
		{
			gpGlobals->g.pPersonList[iPerson].NeiliMax += iNum;
			if (gpGlobals->g.pPersonList[iPerson].NeiliMax < 0)
				gpGlobals->g.pPersonList[iPerson].NeiliMax = 0;
			if (gpGlobals->g.pPersonList[iPerson].NeiliMax > g_ineiliMax)
				gpGlobals->g.pPersonList[iPerson].NeiliMax = g_ineiliMax;
			//WB090716
			gpGlobals->g.pPersonList[iPerson].Neili += iNum;
			if (gpGlobals->g.pPersonList[iPerson].Neili < 0)
				gpGlobals->g.pPersonList[iPerson].Neili = 0;
			if (gpGlobals->g.pPersonList[iPerson].Neili > gpGlobals->g.pPersonList[iPerson].NeiliMax)
				gpGlobals->g.pPersonList[iPerson].Neili = gpGlobals->g.pPersonList[iPerson].NeiliMax;
		}
		break;
	case enum_GongJiLi://攻击力
		if (bSet)
			gpGlobals->g.pPersonList[iPerson].GongJiLi = iNum;
		else
		{
			gpGlobals->g.pPersonList[iPerson].GongJiLi += iNum;
			if (gpGlobals->g.pPersonList[iPerson].GongJiLi < 0)
				gpGlobals->g.pPersonList[iPerson].GongJiLi = 0;
			if (gpGlobals->g.pPersonList[iPerson].GongJiLi > g_igongjiliMax)
				gpGlobals->g.pPersonList[iPerson].GongJiLi = g_igongjiliMax;
		}
		break;
	case enum_QingGong://轻功
		if (bSet)
			gpGlobals->g.pPersonList[iPerson].QingGong = iNum;
		else
		{
			gpGlobals->g.pPersonList[iPerson].QingGong += iNum;
			if (gpGlobals->g.pPersonList[iPerson].QingGong < 0)
				gpGlobals->g.pPersonList[iPerson].QingGong = 0;
			if (gpGlobals->g.pPersonList[iPerson].QingGong > g_iqinggongMax)
				gpGlobals->g.pPersonList[iPerson].QingGong = g_iqinggongMax;
		}
		break;
	case enum_FangYuLi://防御力
		if (bSet)
			gpGlobals->g.pPersonList[iPerson].FangYuLi = iNum;
		else
		{
			gpGlobals->g.pPersonList[iPerson].FangYuLi += iNum;
			if (gpGlobals->g.pPersonList[iPerson].FangYuLi < 0)
				gpGlobals->g.pPersonList[iPerson].FangYuLi = 0;
			if (gpGlobals->g.pPersonList[iPerson].FangYuLi > g_ifangyuliMax)
				gpGlobals->g.pPersonList[iPerson].FangYuLi = g_ifangyuliMax;
		}
		break;
	case enum_YiLiao://医疗
		if (bSet)
			gpGlobals->g.pPersonList[iPerson].YiLiao = iNum;
		else
		{
			gpGlobals->g.pPersonList[iPerson].YiLiao += iNum;
			if (gpGlobals->g.pPersonList[iPerson].YiLiao < 0)
				gpGlobals->g.pPersonList[iPerson].YiLiao = 0;
			if (gpGlobals->g.pPersonList[iPerson].YiLiao > g_iyiliaoMax)
				gpGlobals->g.pPersonList[iPerson].YiLiao = g_iyiliaoMax;
		}
		break;
	case enum_YongDu://用毒
		if (bSet)
			gpGlobals->g.pPersonList[iPerson].YongDu = iNum;
		else
		{
			gpGlobals->g.pPersonList[iPerson].YongDu += iNum;
			if (gpGlobals->g.pPersonList[iPerson].YongDu < 0)
				gpGlobals->g.pPersonList[iPerson].YongDu = 0;
			if (gpGlobals->g.pPersonList[iPerson].YongDu > g_iyongduMax)
				gpGlobals->g.pPersonList[iPerson].YongDu = g_iyongduMax;
		}
		break;
	case enum_JieDu://解毒
		if (bSet)
			gpGlobals->g.pPersonList[iPerson].JieDu = iNum;
		else
		{
			gpGlobals->g.pPersonList[iPerson].JieDu += iNum;
			if (gpGlobals->g.pPersonList[iPerson].JieDu < 0)
				gpGlobals->g.pPersonList[iPerson].JieDu = 0;
			if (gpGlobals->g.pPersonList[iPerson].JieDu > g_ijieduMax)
				gpGlobals->g.pPersonList[iPerson].JieDu = g_ijieduMax;
		}
		break;
	case enum_KangDu://抗毒
		if (bSet)
			gpGlobals->g.pPersonList[iPerson].KangDu = iNum;
		else
		{
			gpGlobals->g.pPersonList[iPerson].KangDu += iNum;
			if (gpGlobals->g.pPersonList[iPerson].KangDu < 0)
				gpGlobals->g.pPersonList[iPerson].KangDu = 0;
			if (gpGlobals->g.pPersonList[iPerson].KangDu > g_ikangduMax)
				gpGlobals->g.pPersonList[iPerson].KangDu = g_ikangduMax;
		}
		break;
	case enum_QuanZhang://拳掌
		if (bSet)
			gpGlobals->g.pPersonList[iPerson].QuanZhang = iNum;
		else
		{
			gpGlobals->g.pPersonList[iPerson].QuanZhang += iNum;
			if (gpGlobals->g.pPersonList[iPerson].QuanZhang < 0)
				gpGlobals->g.pPersonList[iPerson].QuanZhang = 0;
			if (gpGlobals->g.pPersonList[iPerson].QuanZhang > g_iquanzhangMax)
				gpGlobals->g.pPersonList[iPerson].QuanZhang = g_iquanzhangMax;
		}
		break;
	case enum_YuJian://御剑
		if (bSet)
			gpGlobals->g.pPersonList[iPerson].YuJian = iNum;
		else
		{
			gpGlobals->g.pPersonList[iPerson].YuJian += iNum;
			if (gpGlobals->g.pPersonList[iPerson].YuJian < 0)
				gpGlobals->g.pPersonList[iPerson].YuJian = 0;
			if (gpGlobals->g.pPersonList[iPerson].YuJian > g_iyujianMax)
				gpGlobals->g.pPersonList[iPerson].YuJian = g_iyujianMax;
		}
		break;
	case enum_ShuaDao://耍刀
		if (bSet)
			gpGlobals->g.pPersonList[iPerson].ShuaDao = iNum;
		else
		{
			gpGlobals->g.pPersonList[iPerson].ShuaDao += iNum;
			if (gpGlobals->g.pPersonList[iPerson].ShuaDao < 0)
				gpGlobals->g.pPersonList[iPerson].ShuaDao = 0;
			if (gpGlobals->g.pPersonList[iPerson].ShuaDao > g_ishuadaoMax)
				gpGlobals->g.pPersonList[iPerson].ShuaDao = g_ishuadaoMax;
		}
		break;
	case enum_TeSHuBingQi://特殊兵器
		if (bSet)
			gpGlobals->g.pPersonList[iPerson].TeSHuBingQi = iNum;
		else
		{
			gpGlobals->g.pPersonList[iPerson].TeSHuBingQi += iNum;
			if (gpGlobals->g.pPersonList[iPerson].TeSHuBingQi < 0)
				gpGlobals->g.pPersonList[iPerson].TeSHuBingQi = 0;
			if (gpGlobals->g.pPersonList[iPerson].TeSHuBingQi > g_iteshuMax)
				gpGlobals->g.pPersonList[iPerson].TeSHuBingQi = g_iteshuMax;
		}
		break;
	case enum_AnQiJiQiao://暗器技巧
		if (bSet)
			gpGlobals->g.pPersonList[iPerson].AnQiJiQiao = iNum;
		else
		{
			gpGlobals->g.pPersonList[iPerson].AnQiJiQiao += iNum;
			if (gpGlobals->g.pPersonList[iPerson].AnQiJiQiao < 0)
				gpGlobals->g.pPersonList[iPerson].AnQiJiQiao = 0;
			if (gpGlobals->g.pPersonList[iPerson].AnQiJiQiao > g_ianqiMax)
				gpGlobals->g.pPersonList[iPerson].AnQiJiQiao = g_ianqiMax;
		}
		break;
	case enum_WuXueChangShi://武学常识
		if (bSet)
			gpGlobals->g.pPersonList[iPerson].WuXueChangShi = iNum;
		else
		{
			gpGlobals->g.pPersonList[iPerson].WuXueChangShi += iNum;
			if (gpGlobals->g.pPersonList[iPerson].WuXueChangShi < 0)
				gpGlobals->g.pPersonList[iPerson].WuXueChangShi = 0;
			if (gpGlobals->g.pPersonList[iPerson].WuXueChangShi > g_iwuxueMax)
				gpGlobals->g.pPersonList[iPerson].WuXueChangShi = g_iwuxueMax;
		}
		break;
	case enum_PinDe://品德
		if (bSet)
			gpGlobals->g.pPersonList[iPerson].PinDe = iNum;
		else
		{
			gpGlobals->g.pPersonList[iPerson].PinDe += iNum;
			if (gpGlobals->g.pPersonList[iPerson].PinDe < 0)
				gpGlobals->g.pPersonList[iPerson].PinDe = 0;
			if (gpGlobals->g.pPersonList[iPerson].PinDe > g_ipindeMax)
				gpGlobals->g.pPersonList[iPerson].PinDe = g_ipindeMax;
		}
		break;
	case enum_GongjiDaiDu://攻击带毒
		if (bSet)
			gpGlobals->g.pPersonList[iPerson].GongjiDaiDu = iNum;
		else
		{
			gpGlobals->g.pPersonList[iPerson].GongjiDaiDu += iNum;
			if (gpGlobals->g.pPersonList[iPerson].GongjiDaiDu < 0)
				gpGlobals->g.pPersonList[iPerson].GongjiDaiDu = 0;
			if (gpGlobals->g.pPersonList[iPerson].GongjiDaiDu > g_igongjidaiduMax)
				gpGlobals->g.pPersonList[iPerson].GongjiDaiDu = g_igongjidaiduMax;
		}
		break;
	case enum_ZuoYouHuBo://左右互搏
		gpGlobals->g.pPersonList[iPerson].ZuoYouHuBo = iNum;
		break;
	case enum_ShengWang://声望
		if (bSet)
			gpGlobals->g.pPersonList[iPerson].ShengWang = iNum;
		else
		{
			gpGlobals->g.pPersonList[iPerson].ShengWang += iNum;
			if (gpGlobals->g.pPersonList[iPerson].ShengWang < 0)
				gpGlobals->g.pPersonList[iPerson].ShengWang = 0;
			if (gpGlobals->g.pPersonList[iPerson].ShengWang > g_ishengwangMax)
				gpGlobals->g.pPersonList[iPerson].ShengWang = g_ishengwangMax;
		}
		break;
	case enum_ZiZhi://资质
		if (bSet)
			gpGlobals->g.pPersonList[iPerson].ZiZhi = iNum;
		else
		{
			gpGlobals->g.pPersonList[iPerson].ZiZhi += iNum;
			if (gpGlobals->g.pPersonList[iPerson].ZiZhi < 0)
				gpGlobals->g.pPersonList[iPerson].ZiZhi = 0;
			if (gpGlobals->g.pPersonList[iPerson].ZiZhi > g_izizhiMax)
				gpGlobals->g.pPersonList[iPerson].ZiZhi = g_izizhiMax;
		}
		break;
	case enum_XiuLianWuPin://修炼物品
		break;
	case enum_XiuLianDianShu://修炼点数
		if (bSet)
			gpGlobals->g.pPersonList[iPerson].XiuLianDianShu = iNum;
		else
		{
			gpGlobals->g.pPersonList[iPerson].XiuLianDianShu += iNum;
			if (gpGlobals->g.pPersonList[iPerson].XiuLianDianShu < 0)
				gpGlobals->g.pPersonList[iPerson].XiuLianDianShu = 0;

		}
		break;
	case enum_XueHuiWuGong://学会武功
		iFind1 = -1;
		iFind2 = -1;
		for(i=0;i<10;i++)
		{
			if (gpGlobals->g.pPersonList[iPerson].WuGong[i] == iNum && iFind1 == -1)
			{
				iFind1 = i;
			}
			if (gpGlobals->g.pPersonList[iPerson].WuGong[i] == 0 && iFind2 == -1)
			{
				iFind2 = i;
			}
		}
		if (iFind1 == -1)
		{
			if (iFind2 == -1)
			{
				////不能超过10中武功
				//for(i=1;i<10;i++)
				//{
				//	gpGlobals->g.pPersonList[iPerson].WuGong[i-1] = gpGlobals->g.pPersonList[iPerson].WuGong[i];
				//	gpGlobals->g.pPersonList[iPerson].WuGongDengji[i-1] = gpGlobals->g.pPersonList[iPerson].WuGongDengji[i];
				//}
				//gpGlobals->g.pPersonList[iPerson].WuGong[9] = iNum;
				//gpGlobals->g.pPersonList[iPerson].WuGongDengji[9] = 0;
			}
			else
			{
				gpGlobals->g.pPersonList[iPerson].WuGong[iFind2] = iNum;
				gpGlobals->g.pPersonList[iPerson].WuGongDengji[iFind2] = 0;
			}
		}
		break;
	}
}
//移动场景
VOID JY_MoveScene(short xOld,short yOld,short xNew,short yNew,short iDrawHero)
{
	short i=0;
	if (iDrawHero == 0)
	{
		if (yNew != yOld)
		{
			if (yNew <yOld)
			{
				for(i=yOld;i>yNew;i--)
				{
					gpGlobals->g.iSubSceneY--;
					JY_DrawSMap(gpGlobals->g.pBaseList->SMapX,gpGlobals->g.pBaseList->SMapY,gpGlobals->g.iSubSceneX,gpGlobals->g.iSubSceneY,gpGlobals->g.iMyPic);
					JY_ShowSurface();
					JY_Delay(20);
				}
			}
			else
			{
				for(i=yOld;i<yNew;i++)
				{
					gpGlobals->g.iSubSceneY++;
					JY_DrawSMap(gpGlobals->g.pBaseList->SMapX,gpGlobals->g.pBaseList->SMapY,gpGlobals->g.iSubSceneX,gpGlobals->g.iSubSceneY,gpGlobals->g.iMyPic);
					JY_ShowSurface();
					JY_Delay(20);
				}
			}
		}
		if (xNew != xOld)
		{
			if (xNew <xOld)
			{
				for(i=xOld;i>xNew;i--)
				{
					gpGlobals->g.iSubSceneX--;
					JY_DrawSMap(gpGlobals->g.pBaseList->SMapX,gpGlobals->g.pBaseList->SMapY,gpGlobals->g.iSubSceneX,gpGlobals->g.iSubSceneY,gpGlobals->g.iMyPic);
					JY_ShowSurface();
					JY_Delay(20);
				}
			}
			else
			{
				for(i=xOld;i<xNew;i++)
				{
					gpGlobals->g.iSubSceneX++;
					JY_DrawSMap(gpGlobals->g.pBaseList->SMapX,gpGlobals->g.pBaseList->SMapY,gpGlobals->g.iSubSceneX,gpGlobals->g.iSubSceneY,gpGlobals->g.iMyPic);
					JY_ShowSurface();
					JY_Delay(20);
				}
			}
		}
		
	}
	else
	{
		gpGlobals->g.iMyCurrentPic = 0;
		gpGlobals->g.iSubSceneY = 0;
		gpGlobals->g.iSubSceneX = 0;
		if (xOld <xNew)
		{
			for(i=xOld;i<xNew;i++)
			{
				JY_MoveSub(1);
				JY_Delay(20);
			}
		}
		else
		{
			for(i=xNew;i<xOld;i++)
			{
				JY_MoveSub(2);
				JY_Delay(20);
			}
		}
		if (yOld <yNew)
		{
			for(i=yOld;i<yNew;i++)
			{
				JY_MoveSub(3);
				JY_Delay(20);
			}
		}
		else
		{
			for(i=yNew;i<yOld;i++)
			{
				JY_MoveSub(0);
				JY_Delay(20);
			}
		}
		gpGlobals->g.iMyCurrentPic = 0;
	}
	//JY_ReDrawMap();
}
VOID JY_MoveSub(short direct)
{
	short x=0;
	short y=0;
	gpGlobals->g.iMyCurrentPic++;
	x=gpGlobals->g.pBaseList->SMapX + gpGlobals->g.iDirectX[direct];
	y=gpGlobals->g.pBaseList->SMapY + gpGlobals->g.iDirectY[direct];
	gpGlobals->g.pBaseList->Way = direct;
	gpGlobals->g.iMyPic = JY_GetMyPic();

	if (JY_SceneCanPass(x,y) == TRUE)
	{
		gpGlobals->g.pBaseList->SMapX = x;
		gpGlobals->g.pBaseList->SMapY = y;
	}
	gpGlobals->g.pBaseList->SMapX = limitX(gpGlobals->g.pBaseList->SMapX,1,g_iSmapXMax-2);
	gpGlobals->g.pBaseList->SMapY = limitX(gpGlobals->g.pBaseList->SMapY,1,g_iSMapYMax-2);
	JY_DrawSMap(gpGlobals->g.pBaseList->SMapX,
			gpGlobals->g.pBaseList->SMapY,
			gpGlobals->g.iSubSceneX,
			gpGlobals->g.iSubSceneY,
			gpGlobals->g.iMyPic);
	JY_ShowSurface();
}
//使用物品
short JY_UseThing(short iPersonIdx,short iWuPinIdx)
{
	short iPerson = -1;
	short iWuPin = -1;
	short iWuPinNum = -1;

	if (iPersonIdx < 0 || iPersonIdx > 6)
		return 0;
	if (iWuPinIdx < 0 || iWuPinIdx > 200)
		return 0;
	iPerson = gpGlobals->g.pBaseList->Group[iPersonIdx];
	iWuPin = gpGlobals->g.pBaseList->WuPin[iWuPinIdx][0];
	iWuPinNum = gpGlobals->g.pBaseList->WuPin[iWuPinIdx][1];
	
	return JY_UseThingForUser(iPerson,iWuPin,iWuPinNum);
}
//队友使用物品
short JY_UseThingForUser(short iPerson,short iWuPin,short iWuPinNum)
{
	short iSelectType = -1;
	short iTemp = -1;
	bool  bUse = false;

	iSelectType = gpGlobals->g.pThingsList[iWuPin].LeiXing;

	if (gpGlobals->g.pThingsList[iWuPin].XuNeiLi != 0)
	{
		if (gpGlobals->g.pPersonList[iPerson].NeiliMax < gpGlobals->g.pThingsList[iWuPin].XuNeiLi)
		{
			return -3;
		}
	}
	if (gpGlobals->g.pThingsList[iWuPin].XuGongJiLi != 0)
	{
		if (gpGlobals->g.pPersonList[iPerson].GongJiLi < gpGlobals->g.pThingsList[iWuPin].XuGongJiLi)
		{
			return -4;
		}
	}
	if (gpGlobals->g.pThingsList[iWuPin].XuQingGong != 0)
	{
		if (gpGlobals->g.pPersonList[iPerson].QingGong < gpGlobals->g.pThingsList[iWuPin].XuQingGong)
		{
			return -5;
		}
	}
	if (gpGlobals->g.pThingsList[iWuPin].XuShiDu != 0)
	{
		if (gpGlobals->g.pPersonList[iPerson].YongDu < gpGlobals->g.pThingsList[iWuPin].XuShiDu)
		{
			return -6;
		}
	}
	if (gpGlobals->g.pThingsList[iWuPin].XuYiLiao != 0)
	{
		if (gpGlobals->g.pPersonList[iPerson].YiLiao < gpGlobals->g.pThingsList[iWuPin].XuYiLiao)
		{
			return -7;
		}
	}
	if (gpGlobals->g.pThingsList[iWuPin].XuJieDu != 0)
	{
		if (gpGlobals->g.pPersonList[iPerson].JieDu < gpGlobals->g.pThingsList[iWuPin].XuJieDu)
		{
			return -8;
		}
	}
	if (gpGlobals->g.pThingsList[iWuPin].XuQuanZhang != 0)
	{
		if (gpGlobals->g.pPersonList[iPerson].QuanZhang < gpGlobals->g.pThingsList[iWuPin].XuQuanZhang)
		{
			return -9;
		}
	}
	if (gpGlobals->g.pThingsList[iWuPin].XuYuJian != 0)
	{
		if (gpGlobals->g.pPersonList[iPerson].YuJian < gpGlobals->g.pThingsList[iWuPin].XuYuJian)
		{
			return -10;
		}
	}
	if (gpGlobals->g.pThingsList[iWuPin].XuShuaDao != 0)
	{
		if (gpGlobals->g.pPersonList[iPerson].ShuaDao < gpGlobals->g.pThingsList[iWuPin].XuShuaDao)
		{
			return -11;
		}
	}
	if (gpGlobals->g.pThingsList[iWuPin].XuTeShuBingQi != 0)
	{
		if (gpGlobals->g.pPersonList[iPerson].TeSHuBingQi < gpGlobals->g.pThingsList[iWuPin].XuTeShuBingQi)
		{
			return -12;
		}
	}
	if (gpGlobals->g.pThingsList[iWuPin].XuAnQiJiQiao != 0)
	{
		if (gpGlobals->g.pPersonList[iPerson].AnQiJiQiao < gpGlobals->g.pThingsList[iWuPin].XuAnQiJiQiao)
		{
			return -13;
		}
	}
	if (gpGlobals->g.pThingsList[iWuPin].XuZiZHi != 0)
	{
		if (gpGlobals->g.pThingsList[iWuPin].XuZiZHi < 0)
		{
			if (strcmp((char*)gpGlobals->g.pPersonList[iPerson].name2big5,"MillKnife") != 0)
			{
				if (gpGlobals->g.pPersonList[iPerson].ZiZhi > (-gpGlobals->g.pThingsList[iWuPin].XuZiZHi))
				{
					return -14;
				}
			}
		}
		else
		{
			if (gpGlobals->g.pPersonList[iPerson].ZiZhi < gpGlobals->g.pThingsList[iWuPin].XuZiZHi)
			{
				return -14;
			}
		}
	}
	if (iSelectType == 0 && (gpGlobals->g.Status == 1 || gpGlobals->g.Status == 4) )
	{
		int x = gpGlobals->g.pBaseList->SMapX;
		int y = gpGlobals->g.pBaseList->SMapY;
		int xTarget = x + gpGlobals->g.iDirectX[gpGlobals->g.pBaseList->Way];
		int yTarget = y + gpGlobals->g.iDirectY[gpGlobals->g.pBaseList->Way];

		short uscode = -1;
		short wScriptEntry = -1;

		uscode = JY_GetSMap(gpGlobals->g.iSceneNum,xTarget,yTarget,3);//gpGlobals->g.scene[gpGlobals->g.iSceneNum].code[3][yTarget][xTarget] ;
		if (uscode >= 0)
		{

			gpGlobals->g.iSceneEventCode = uscode;
			wScriptEntry = JY_GetD(gpGlobals->g.iSceneNum,uscode,3);
			//wScriptEntry = gpGlobals->g.sceneEventList[gpGlobals->g.iSceneNum][uscode].EventNum2;

			if (wScriptEntry == 666 && iWuPin != 174)
			{
				JY_ReDrawMap();
				JY_DrawTalkDialog(2436,106,0);
				JY_ReDrawMap();
				JY_DrawTextDialog("东西给你了,我要练功",JY_XY(g_wInitialWidth/2,g_wInitialHeight/2),TRUE,TRUE,TRUE);
				JY_ReDrawMap();
				//进入练功房
				WarMain(48,0,1);
				JY_ReDrawMap();
				JY_ThingSet(iWuPin,-1);
			}
			else
			{
				JY_ReDrawMap();
				JY_ShowSurface();
				JY_RunTriggerScript(wScriptEntry,iWuPin);
			}
			gpGlobals->g.iSceneEventCode = -1;
			return 0;
		}
	}
	if (iSelectType == 1 || iSelectType == 2) //装备
	{
		if (gpGlobals->g.pThingsList[iWuPin].JinXiuLianRenWu != -1)
		{
			if (iPerson != gpGlobals->g.pThingsList[iWuPin].JinXiuLianRenWu)
				return -1;
		}
		if (gpGlobals->g.pThingsList[iWuPin].XuNeiLiXingZhi != 2)
		{
			if (gpGlobals->g.pPersonList[iPerson].NeiliXingZhi != 2)
			{
				if (gpGlobals->g.pThingsList[iWuPin].XuNeiLiXingZhi != gpGlobals->g.pPersonList[iPerson].NeiliXingZhi)
					return -2;
			}
		}
		int iTempNum = 0;
		for(int i=0;i<6;i++)
		{
			if (gpGlobals->g.pBaseList->Group[i] != -1)
			{
				if (gpGlobals->g.pPersonList[gpGlobals->g.pBaseList->Group[i]].WuQi == iWuPin)
				{
					iTempNum++;
				}
				if (gpGlobals->g.pPersonList[gpGlobals->g.pBaseList->Group[i]].Fangju == iWuPin)
				{
					iTempNum++;
				}
				if (gpGlobals->g.pPersonList[gpGlobals->g.pBaseList->Group[i]].XiuLianWuPin == iWuPin)
				{
					iTempNum++;
				}
			}
		}
		if (iTempNum < iWuPinNum)//使用数量小于物品数量
		{
			if (iSelectType == 1 && gpGlobals->g.pThingsList[iWuPin].ZhuangBeiLeiXing == 0)//武器
			{
				if (gpGlobals->g.pPersonList[iPerson].WuQi != -1)
				{
					gpGlobals->g.pThingsList[gpGlobals->g.pPersonList[iPerson].WuQi].ShiYongRen = -1;
				}
				gpGlobals->g.pPersonList[iPerson].WuQi = iWuPin;
			}
			if (iSelectType == 1 && gpGlobals->g.pThingsList[iWuPin].ZhuangBeiLeiXing == 1)//防具
			{
				if (gpGlobals->g.pPersonList[iPerson].Fangju != -1)
				{
					gpGlobals->g.pThingsList[gpGlobals->g.pPersonList[iPerson].Fangju].ShiYongRen = -1;
				}
				gpGlobals->g.pPersonList[iPerson].Fangju = iWuPin;
			}
			if (iSelectType == 2)//秘笈
			{
				if (gpGlobals->g.pThingsList[iWuPin].LianChuWuGong >=0)
				{
					for(int i=0;i<10;i++)
					{
						if (gpGlobals->g.pPersonList[iPerson].WuGong[i] == gpGlobals->g.pThingsList[iWuPin].LianChuWuGong &&
							gpGlobals->g.pPersonList[iPerson].WuGongDengji[i] > 900)
						{
							return -16;
						}
					}
				}
				if (iWuPin==78 || iWuPin==93)//辟邪和葵花
				{
					if (gpGlobals->g.pPersonList[iPerson].sex == 0)
					{
						JY_VideoRestoreScreen(1);
						int ir = JY_DrawTextDialog("欲练此功,必先自宫,确定下手..",JY_XY(g_wInitialWidth/2,g_wInitialHeight/2),TRUE,TRUE,TRUE);
						if (ir == 0)
							return 0;
						gpGlobals->g.pPersonList[iPerson].sex = 2;
					}
					else if (gpGlobals->g.pPersonList[iPerson].sex == 1)
					{
						return -15;
					}
				}
				if (gpGlobals->g.pPersonList[iPerson].XiuLianWuPin != -1)
				{
					gpGlobals->g.pThingsList[gpGlobals->g.pPersonList[iPerson].XiuLianWuPin].ShiYongRen = -1;
				}
				gpGlobals->g.pPersonList[iPerson].XiuLianWuPin = iWuPin;
				gpGlobals->g.pPersonList[iPerson].XiuLianDianShu = 0;
			}
			gpGlobals->g.pThingsList[iWuPin].ShiYongRen = iPerson;
		}
		else//使用数量大于物品数量（替换最后一次物品使用人）
		{
			if (iSelectType == 1 && gpGlobals->g.pThingsList[iWuPin].ZhuangBeiLeiXing == 0)//武器
			{
				if (gpGlobals->g.pThingsList[iWuPin].ShiYongRen >=0)
					gpGlobals->g.pPersonList[gpGlobals->g.pThingsList[iWuPin].ShiYongRen].WuQi = -1;
				if (gpGlobals->g.pPersonList[iPerson].WuQi != -1)
				{
					gpGlobals->g.pThingsList[gpGlobals->g.pPersonList[iPerson].WuQi].ShiYongRen = -1;
				}
				gpGlobals->g.pPersonList[iPerson].WuQi = iWuPin;
			}
			if (iSelectType == 1 && gpGlobals->g.pThingsList[iWuPin].ZhuangBeiLeiXing == 1)//防具
			{
				if (gpGlobals->g.pPersonList[iPerson].Fangju != -1)
				{
					gpGlobals->g.pThingsList[gpGlobals->g.pPersonList[iPerson].Fangju].ShiYongRen = -1;
				}
				if (gpGlobals->g.pThingsList[iWuPin].ShiYongRen >=0)
					gpGlobals->g.pPersonList[gpGlobals->g.pThingsList[iWuPin].ShiYongRen].Fangju = -1;
				gpGlobals->g.pPersonList[iPerson].Fangju = iWuPin;
			}
			if (iSelectType == 2)//秘笈
			{
				if (gpGlobals->g.pThingsList[iWuPin].LianChuWuGong >=0)
				{
					for(int i=0;i<10;i++)
					{
						if (gpGlobals->g.pPersonList[iPerson].WuGong[i] == gpGlobals->g.pThingsList[iWuPin].LianChuWuGong &&
							gpGlobals->g.pPersonList[iPerson].WuGongDengji[i] > 900)
						{
							return -16;
						}
					}
				}
				if (iWuPin==78 || iWuPin==93)//辟邪和葵花
				{
					if (gpGlobals->g.pPersonList[iPerson].sex == 0)
					{
						JY_VideoRestoreScreen(1);
						int ir = JY_DrawTextDialog("欲练此功,必先自宫,确定下手..",JY_XY(g_wInitialWidth/2,g_wInitialHeight/2),TRUE,TRUE,TRUE);
						if (ir == 0)
							return 0;
						gpGlobals->g.pPersonList[iPerson].sex = 2;
					}
					else if (gpGlobals->g.pPersonList[iPerson].sex == 1)
					{
						return -15;
					}
				}
				if (gpGlobals->g.pThingsList[iWuPin].ShiYongRen >=0)
				{
					gpGlobals->g.pPersonList[gpGlobals->g.pThingsList[iWuPin].ShiYongRen].XiuLianWuPin = -1;
					gpGlobals->g.pPersonList[gpGlobals->g.pThingsList[iWuPin].ShiYongRen].XiuLianDianShu = 0;
				}
				if (gpGlobals->g.pPersonList[iPerson].XiuLianWuPin != -1)
				{
					gpGlobals->g.pThingsList[gpGlobals->g.pPersonList[iPerson].XiuLianWuPin].ShiYongRen = -1;
				}
				gpGlobals->g.pPersonList[iPerson].XiuLianWuPin = iWuPin;
				gpGlobals->g.pPersonList[iPerson].XiuLianDianShu = 0;
			}
			gpGlobals->g.pThingsList[iWuPin].ShiYongRen = iPerson;
		}
	}
	if (iSelectType == 3) //药品
	{
		char pText[255] = {0};
		BYTE pTemp[60] = {0};
		INT iLen = 0;
		INT iNum = 0;
		for(int k=0;k< 20;k++)
		{
			if (gpGlobals->g.pThingsList[iWuPin].name1big5[k] == 0)
			{
				pTemp[k] =0;
				break;
			}
			pTemp[k] =gpGlobals->g.pThingsList[iWuPin].name1big5[k] ;//^ 0xFF;
			iLen++;
		}
		Big5toUnicode(pTemp,iLen);
		sprintf(pText,"使用 %s ",pTemp);
		JY_ReDrawMap();
		JY_DrawStr((g_iFontSize+4)*3+10,(g_iFontSize+4)*2+20,pText,HUANGCOLOR,0,TRUE,FALSE);
		iNum++;
		if (gpGlobals->g.pThingsList[iWuPin].JiaShengMing != 0)
		{
			if (gpGlobals->g.pPersonList[iPerson].hp < gpGlobals->g.pPersonList[iPerson].hpMax)
			{
				JY_SetPersonStatus(enum_hp,iPerson,gpGlobals->g.pThingsList[iWuPin].JiaShengMing,false);		
				JY_SetPersonStatus(enum_ShouShang,iPerson,-gpGlobals->g.pThingsList[iWuPin].JiaShengMing,false);		
				bUse = true;
				sprintf(pText,"加生命 %d ",gpGlobals->g.pThingsList[iWuPin].JiaShengMing);
				JY_DrawStr((g_iFontSize+4)*3+10,(g_iFontSize+4)*2+20+iNum*(g_iFontSize+4)+iNum*3,pText,HUANGCOLOR,0,TRUE,FALSE);
				iNum++;
			}
		}
		if (gpGlobals->g.pThingsList[iWuPin].JiaSHengMingZuiDa != 0)
		{
			if (gpGlobals->g.pPersonList[iPerson].hpMax < g_ishengmingMax)
			{
				JY_SetPersonStatus(enum_hpMax,iPerson,gpGlobals->g.pThingsList[iWuPin].JiaSHengMingZuiDa,false);	
				bUse = true;
				sprintf(pText,"加生命最大 %d ",gpGlobals->g.pThingsList[iWuPin].JiaSHengMingZuiDa);
				JY_DrawStr((g_iFontSize+4)*3+10,(g_iFontSize+4)*2+20+iNum*(g_iFontSize+4)+iNum*3,pText,HUANGCOLOR,0,TRUE,FALSE);
				iNum++;
			}
		}
		if (gpGlobals->g.pThingsList[iWuPin].JiaZhongDuJieDu != 0)
		{
			if (gpGlobals->g.pPersonList[iPerson].ZhongDu > 0)
			{
				JY_SetPersonStatus(enum_ZhongDu,iPerson,gpGlobals->g.pThingsList[iWuPin].JiaZhongDuJieDu,false);	
				bUse = true;
				sprintf(pText,"解毒 %d ",-gpGlobals->g.pThingsList[iWuPin].JiaZhongDuJieDu);
				JY_DrawStr((g_iFontSize+4)*3+10,(g_iFontSize+4)*2+20+iNum*(g_iFontSize+4)+iNum*3,pText,HUANGCOLOR,0,TRUE,FALSE);
				iNum++;
			}
		}
		if (gpGlobals->g.pThingsList[iWuPin].JiaTiLi != 0)
		{
			if (gpGlobals->g.pPersonList[iPerson].Tili < g_itiliMax)
			{
				JY_SetPersonStatus(enum_Tili,iPerson,gpGlobals->g.pThingsList[iWuPin].JiaTiLi,false);	
				bUse = true;
				sprintf(pText,"加体力 %d ",gpGlobals->g.pThingsList[iWuPin].JiaTiLi);
				JY_DrawStr((g_iFontSize+4)*3+10,(g_iFontSize+4)*2+20+iNum*(g_iFontSize+4)+iNum*3,pText,HUANGCOLOR,0,TRUE,FALSE);
				iNum++;
			}
		}
		if (gpGlobals->g.pThingsList[iWuPin].GaiBianNeiLiXingZhi != 0)
		{
			if (gpGlobals->g.pPersonList[iPerson].NeiliXingZhi != gpGlobals->g.pThingsList[iWuPin].GaiBianNeiLiXingZhi)
			{
				JY_SetPersonStatus(enum_NeiliXingZhi,iPerson,gpGlobals->g.pThingsList[iWuPin].GaiBianNeiLiXingZhi,false);
				bUse = true;
				//sprintf(pText+strlen(pText),"改变内力性质 ",NULL);
			}
		}
		if (gpGlobals->g.pThingsList[iWuPin].JiaNeiLi != 0)
		{
			if (gpGlobals->g.pPersonList[iPerson].Neili < gpGlobals->g.pPersonList[iPerson].NeiliMax)
			{
				JY_SetPersonStatus(enum_Neili,iPerson,gpGlobals->g.pThingsList[iWuPin].JiaNeiLi,false);
				bUse = true;
				sprintf(pText,"加内力 %d ",gpGlobals->g.pThingsList[iWuPin].JiaNeiLi);
				JY_DrawStr((g_iFontSize+4)*3+10,(g_iFontSize+4)*2+20+iNum*(g_iFontSize+4)+iNum*3,pText,HUANGCOLOR,0,TRUE,FALSE);
				iNum++;
			}
		}
		if (gpGlobals->g.pThingsList[iWuPin].JiaNeiLiZuiDa != 0)
		{
			if (gpGlobals->g.pPersonList[iPerson].NeiliMax < g_ineiliMax)
			{
				JY_SetPersonStatus(enum_NeiliMax,iPerson,gpGlobals->g.pThingsList[iWuPin].JiaNeiLiZuiDa,false);
				bUse = true;
				sprintf(pText,"加内力最大 %d ",gpGlobals->g.pThingsList[iWuPin].JiaNeiLiZuiDa);
				JY_DrawStr((g_iFontSize+4)*3+10,(g_iFontSize+4)*2+20+iNum*(g_iFontSize+4)+iNum*3,pText,HUANGCOLOR,0,TRUE,FALSE);
				iNum++;
			}
		}
		if (gpGlobals->g.pThingsList[iWuPin].JiaGongJiLi != 0)
		{
			if (gpGlobals->g.pPersonList[iPerson].GongJiLi < g_igongjiliMax)
			{
				JY_SetPersonStatus(enum_GongJiLi,iPerson,gpGlobals->g.pThingsList[iWuPin].JiaGongJiLi,false);
				bUse = true;
				//sprintf(pText+strlen(pText),"加武力 %d ",gpGlobals->g.pThingsList[iWuPin].JiaGongJiLi);
			}
		}
		if (gpGlobals->g.pThingsList[iWuPin].JiaQingGong != 0)
		{
			if (gpGlobals->g.pPersonList[iPerson].QingGong < g_iqinggongMax)
			{
				JY_SetPersonStatus(enum_QingGong,iPerson,gpGlobals->g.pThingsList[iWuPin].JiaQingGong,false);
				bUse = true;
				//sprintf(pText+strlen(pText),"加轻功 %d ",gpGlobals->g.pThingsList[iWuPin].JiaQingGong);
			}
		}
		if (gpGlobals->g.pThingsList[iWuPin].JiaFangYuLi != 0)
		{
			if (gpGlobals->g.pPersonList[iPerson].FangYuLi < g_ifangyuliMax)
			{
				JY_SetPersonStatus(enum_FangYuLi,iPerson,gpGlobals->g.pThingsList[iWuPin].JiaFangYuLi,false);
				bUse = true;
				//sprintf(pText+strlen(pText),"加防御 %d ",gpGlobals->g.pThingsList[iWuPin].JiaFangYuLi);
			}
		}
		if (gpGlobals->g.pThingsList[iWuPin].JiaYiLiao != 0)
		{
			if (gpGlobals->g.pPersonList[iPerson].YiLiao < g_iyiliaoMax)
			{
				JY_SetPersonStatus(enum_YiLiao,iPerson,gpGlobals->g.pThingsList[iWuPin].JiaYiLiao,false);
				bUse = true;
				//sprintf(pText+strlen(pText),"加医疗 %d ",gpGlobals->g.pThingsList[iWuPin].JiaYiLiao);
			}
		}
		if (gpGlobals->g.pThingsList[iWuPin].JiaShiDu != 0)
		{
			if (gpGlobals->g.pPersonList[iPerson].YongDu < g_iyongduMax)
			{
				JY_SetPersonStatus(enum_YongDu,iPerson,gpGlobals->g.pThingsList[iWuPin].JiaShiDu,false);
				bUse = true;
				//sprintf(pText+strlen(pText),"加用毒 %d ",gpGlobals->g.pThingsList[iWuPin].JiaShiDu);
			}
		}
		if (gpGlobals->g.pThingsList[iWuPin].JiaJieDu != 0)
		{
			if (gpGlobals->g.pPersonList[iPerson].JieDu < g_ijieduMax)
			{
				JY_SetPersonStatus(enum_JieDu,iPerson,gpGlobals->g.pThingsList[iWuPin].JiaJieDu,false);
				bUse = true;
				//sprintf(pText+strlen(pText),"加解毒 %d ",gpGlobals->g.pThingsList[iWuPin].JiaJieDu);
			}
		}
		if (gpGlobals->g.pThingsList[iWuPin].JiaKangDu != 0)
		{
			if (gpGlobals->g.pPersonList[iPerson].KangDu < g_ikangduMax)
			{
				JY_SetPersonStatus(enum_KangDu,iPerson,gpGlobals->g.pThingsList[iWuPin].JiaKangDu,false);
				bUse = true;
				//sprintf(pText+strlen(pText),"加抗毒 %d ",gpGlobals->g.pThingsList[iWuPin].JiaKangDu);
			}
		}
		if (gpGlobals->g.pThingsList[iWuPin].JiaQuanZhang != 0)
		{
			if (gpGlobals->g.pPersonList[iPerson].QuanZhang < g_iquanzhangMax)
			{
				JY_SetPersonStatus(enum_QuanZhang,iPerson,gpGlobals->g.pThingsList[iWuPin].JiaQuanZhang,false);
				bUse = true;
				//sprintf(pText+strlen(pText),"加拳掌 %d ",gpGlobals->g.pThingsList[iWuPin].JiaQuanZhang);
			}
		}
		if (gpGlobals->g.pThingsList[iWuPin].JiaYuJian != 0)
		{
			if (gpGlobals->g.pPersonList[iPerson].YuJian < g_iyujianMax)
			{
				JY_SetPersonStatus(enum_YuJian,iPerson,gpGlobals->g.pThingsList[iWuPin].JiaYuJian,false);
				bUse = true;
				//sprintf(pText+strlen(pText),"加御剑 %d ",gpGlobals->g.pThingsList[iWuPin].JiaYuJian);
			}
		}
		if (gpGlobals->g.pThingsList[iWuPin].JiaShuaDao != 0)
		{
			if (gpGlobals->g.pPersonList[iPerson].ShuaDao < g_ishuadaoMax)
			{
				JY_SetPersonStatus(enum_ShuaDao,iPerson,gpGlobals->g.pThingsList[iWuPin].JiaShuaDao,false);
				bUse = true;
				//sprintf(pText+strlen(pText),"加刷刀 %d ",gpGlobals->g.pThingsList[iWuPin].JiaShuaDao);
			}
		}
		if (gpGlobals->g.pThingsList[iWuPin].JiaTeShuBingQi != 0)
		{
			if (gpGlobals->g.pPersonList[iPerson].TeSHuBingQi < g_iteshuMax)
			{
				JY_SetPersonStatus(enum_TeSHuBingQi,iPerson,gpGlobals->g.pThingsList[iWuPin].JiaTeShuBingQi,false);
				bUse = true;
				//sprintf(pText+strlen(pText),"加特殊 %d ",gpGlobals->g.pThingsList[iWuPin].JiaTeShuBingQi);
			}
		}
		if (gpGlobals->g.pThingsList[iWuPin].JiaAnQiJiQiao != 0)
		{
			if (gpGlobals->g.pPersonList[iPerson].AnQiJiQiao < g_ianqiMax)
			{
				JY_SetPersonStatus(enum_AnQiJiQiao,iPerson,gpGlobals->g.pThingsList[iWuPin].JiaAnQiJiQiao,false);
				bUse = true;
				//sprintf(pText+strlen(pText),"加暗器 %d ",gpGlobals->g.pThingsList[iWuPin].JiaAnQiJiQiao);
			}
		}
		if (gpGlobals->g.pThingsList[iWuPin].JiaWuXueChangShi != 0)
		{
			if (gpGlobals->g.pPersonList[iPerson].WuXueChangShi < g_iwuxueMax)
			{
				JY_SetPersonStatus(enum_WuXueChangShi,iPerson,gpGlobals->g.pThingsList[iWuPin].JiaWuXueChangShi,false);
				bUse = true;
				//sprintf(pText+strlen(pText),"加武学 %d ",gpGlobals->g.pThingsList[iWuPin].JiaWuXueChangShi);
			}
		}
		if (gpGlobals->g.pThingsList[iWuPin].JiaPinDe != 0)
		{
			if (gpGlobals->g.pPersonList[iPerson].PinDe < g_ipindeMax)
			{
				JY_SetPersonStatus(enum_PinDe,iPerson,gpGlobals->g.pThingsList[iWuPin].JiaPinDe,false);
				bUse = true;
				//sprintf(pText+strlen(pText),"加品德 %d ",gpGlobals->g.pThingsList[iWuPin].JiaPinDe);
			}
		}
		if (gpGlobals->g.pThingsList[iWuPin].JiaGongFuDaiDu != 0)
		{
			if (gpGlobals->g.pPersonList[iPerson].GongjiDaiDu < g_igongjidaiduMax)
			{
				JY_SetPersonStatus(enum_GongjiDaiDu,iPerson,gpGlobals->g.pThingsList[iWuPin].JiaGongFuDaiDu,false);
				bUse = true;
				//sprintf(pText+strlen(pText),"加带毒 %d ",gpGlobals->g.pThingsList[iWuPin].JiaGongFuDaiDu);
			}
		}
		if (bUse)
		{
			JY_ThingSet(iWuPin,-1);			
			JY_ShowSurface();
			JY_Delay(1000);
		}
	}

	return 0;
}
//NPC使用物品
short JY_UseThingForNpc(short iPerson,short iWuPinIdx)
{
	short iWuPin = -1;
	short iSelectType = -1;
	short iWuPinNum = -1;
	short iTemp = -1;
	bool  bUse = false;

	if (iWuPinIdx < 0 || iWuPinIdx > 4)
		return 0;

	iWuPin = gpGlobals->g.pPersonList[iPerson].XieDaiWuPin[iWuPinIdx];
	iSelectType = gpGlobals->g.pThingsList[iWuPin].LeiXing;
	iWuPinNum = gpGlobals->g.pPersonList[iPerson].XieDaiWuPinShuLiang[iWuPinIdx];
		
	if (iSelectType == 3) //药品
	{
		char pText[255] = {0};
		BYTE pTemp[60] = {0};
		INT iLen = 0;
		INT iNum=0;
		for(int k=0;k< 20;k++)
		{
			if (gpGlobals->g.pThingsList[iWuPin].name1big5[k] == 0)
			{
				pTemp[k] =0;
				break;
			}
			pTemp[k] =gpGlobals->g.pThingsList[iWuPin].name1big5[k] ;//^ 0xFF;
			iLen++;
		}
		Big5toUnicode(pTemp,iLen);
		sprintf(pText,"使用 %s ",pTemp);
		JY_ReDrawMap();
		JY_DrawStr((g_iFontSize+4)*3+10,(g_iFontSize+4)*2+20,pText,HUANGCOLOR,0,TRUE,FALSE);
		iNum++;
		if (gpGlobals->g.pThingsList[iWuPin].JiaShengMing != 0)
		{
			if (gpGlobals->g.pPersonList[iPerson].hp < gpGlobals->g.pPersonList[iPerson].hpMax)
			{
				JY_SetPersonStatus(enum_hp,iPerson,gpGlobals->g.pThingsList[iWuPin].JiaShengMing,false);		
				JY_SetPersonStatus(enum_ShouShang,iPerson,-gpGlobals->g.pThingsList[iWuPin].JiaShengMing,false);		
				bUse = true;
				sprintf(pText,"加生命 %d ",gpGlobals->g.pThingsList[iWuPin].JiaShengMing);
				JY_DrawStr((g_iFontSize+4)*3+10,(g_iFontSize+4)*2+20+iNum*(g_iFontSize+4)+iNum*3,pText,HUANGCOLOR,0,TRUE,FALSE);
				iNum++;
			}
		}
		if (gpGlobals->g.pThingsList[iWuPin].JiaSHengMingZuiDa != 0)
		{
			if (gpGlobals->g.pPersonList[iPerson].hpMax < g_ishengmingMax)
			{
				JY_SetPersonStatus(enum_hpMax,iPerson,gpGlobals->g.pThingsList[iWuPin].JiaSHengMingZuiDa,false);	
				bUse = true;
				sprintf(pText,"加生命最大 %d ",gpGlobals->g.pThingsList[iWuPin].JiaSHengMingZuiDa);
				JY_DrawStr((g_iFontSize+4)*3+10,(g_iFontSize+4)*2+20+iNum*(g_iFontSize+4)+iNum*3,pText,HUANGCOLOR,0,TRUE,FALSE);
				iNum++;
			}
		}
		if (gpGlobals->g.pThingsList[iWuPin].JiaZhongDuJieDu != 0)
		{
			if (gpGlobals->g.pPersonList[iPerson].ZhongDu > 0)
			{
				JY_SetPersonStatus(enum_ZhongDu,iPerson,gpGlobals->g.pThingsList[iWuPin].JiaZhongDuJieDu,false);	
				bUse = true;
				sprintf(pText,"解毒 %d ",-gpGlobals->g.pThingsList[iWuPin].JiaZhongDuJieDu);
				JY_DrawStr((g_iFontSize+4)*3+10,(g_iFontSize+4)*2+20+iNum*(g_iFontSize+4)+iNum*3,pText,HUANGCOLOR,0,TRUE,FALSE);
				iNum++;
			}
		}
		if (gpGlobals->g.pThingsList[iWuPin].JiaTiLi != 0)
		{
			if (gpGlobals->g.pPersonList[iPerson].Tili < g_itiliMax)
			{
				JY_SetPersonStatus(enum_Tili,iPerson,gpGlobals->g.pThingsList[iWuPin].JiaTiLi,false);	
				bUse = true;
				sprintf(pText,"加体力 %d ",gpGlobals->g.pThingsList[iWuPin].JiaTiLi);
				JY_DrawStr((g_iFontSize+4)*3+10,(g_iFontSize+4)*2+20+iNum*(g_iFontSize+4)+iNum*3,pText,HUANGCOLOR,0,TRUE,FALSE);
				iNum++;
			}
		}
		if (gpGlobals->g.pThingsList[iWuPin].GaiBianNeiLiXingZhi != 0)
		{
			if (gpGlobals->g.pPersonList[iPerson].NeiliXingZhi != gpGlobals->g.pThingsList[iWuPin].GaiBianNeiLiXingZhi)
			{
				JY_SetPersonStatus(enum_NeiliXingZhi,iPerson,gpGlobals->g.pThingsList[iWuPin].GaiBianNeiLiXingZhi,false);
				bUse = true;
				//sprintf(pText+strlen(pText),"改变内力性质 ",NULL);
			}
		}
		if (gpGlobals->g.pThingsList[iWuPin].JiaNeiLi != 0)
		{
			if (gpGlobals->g.pPersonList[iPerson].Neili < gpGlobals->g.pPersonList[iPerson].NeiliMax)
			{
				JY_SetPersonStatus(enum_Neili,iPerson,gpGlobals->g.pThingsList[iWuPin].JiaNeiLi,false);
				bUse = true;
				sprintf(pText,"加内力 %d ",gpGlobals->g.pThingsList[iWuPin].JiaNeiLi);
				JY_DrawStr((g_iFontSize+4)*3+10,(g_iFontSize+4)*2+20+iNum*(g_iFontSize+4)+iNum*3,pText,HUANGCOLOR,0,TRUE,FALSE);
				iNum++;
			}
		}
		if (gpGlobals->g.pThingsList[iWuPin].JiaNeiLiZuiDa != 0)
		{
			if (gpGlobals->g.pPersonList[iPerson].NeiliMax < g_ineiliMax)
			{
				JY_SetPersonStatus(enum_NeiliMax,iPerson,gpGlobals->g.pThingsList[iWuPin].JiaNeiLiZuiDa,false);
				bUse = true;
				sprintf(pText,"加内力最大 %d ",gpGlobals->g.pThingsList[iWuPin].JiaNeiLiZuiDa);
				JY_DrawStr((g_iFontSize+4)*3+10,(g_iFontSize+4)*2+20+iNum*(g_iFontSize+4)+iNum*3,pText,HUANGCOLOR,0,TRUE,FALSE);
				iNum++;
			}
		}
		if (gpGlobals->g.pThingsList[iWuPin].JiaGongJiLi != 0)
		{
			if (gpGlobals->g.pPersonList[iPerson].GongJiLi < g_igongjiliMax)
			{
				JY_SetPersonStatus(enum_GongJiLi,iPerson,gpGlobals->g.pThingsList[iWuPin].JiaGongJiLi,false);
				bUse = true;
			}
		}
		if (gpGlobals->g.pThingsList[iWuPin].JiaQingGong != 0)
		{
			if (gpGlobals->g.pPersonList[iPerson].QingGong < g_iqinggongMax)
			{
				JY_SetPersonStatus(enum_QingGong,iPerson,gpGlobals->g.pThingsList[iWuPin].JiaQingGong,false);
				bUse = true;
			}
		}
		if (gpGlobals->g.pThingsList[iWuPin].JiaFangYuLi != 0)
		{
			if (gpGlobals->g.pPersonList[iPerson].FangYuLi < g_ifangyuliMax)
			{
				JY_SetPersonStatus(enum_FangYuLi,iPerson,gpGlobals->g.pThingsList[iWuPin].JiaFangYuLi,false);
				bUse = true;
			}
		}
		if (gpGlobals->g.pThingsList[iWuPin].JiaYiLiao != 0)
		{
			if (gpGlobals->g.pPersonList[iPerson].YiLiao < g_iyiliaoMax)
			{
				JY_SetPersonStatus(enum_YiLiao,iPerson,gpGlobals->g.pThingsList[iWuPin].JiaYiLiao,false);
				bUse = true;
			}
		}
		if (gpGlobals->g.pThingsList[iWuPin].JiaShiDu != 0)
		{
			if (gpGlobals->g.pPersonList[iPerson].YongDu < g_iyongduMax)
			{
				JY_SetPersonStatus(enum_YongDu,iPerson,gpGlobals->g.pThingsList[iWuPin].JiaShiDu,false);
				bUse = true;
			}
		}
		if (gpGlobals->g.pThingsList[iWuPin].JiaJieDu != 0)
		{
			if (gpGlobals->g.pPersonList[iPerson].JieDu < g_ijieduMax)
			{
				JY_SetPersonStatus(enum_JieDu,iPerson,gpGlobals->g.pThingsList[iWuPin].JiaJieDu,false);
				bUse = true;
			}
		}
		if (gpGlobals->g.pThingsList[iWuPin].JiaKangDu != 0)
		{
			if (gpGlobals->g.pPersonList[iPerson].KangDu < g_ikangduMax)
			{
				JY_SetPersonStatus(enum_KangDu,iPerson,gpGlobals->g.pThingsList[iWuPin].JiaKangDu,false);
				bUse = true;
			}
		}
		if (gpGlobals->g.pThingsList[iWuPin].JiaQuanZhang != 0)
		{
			if (gpGlobals->g.pPersonList[iPerson].QuanZhang < g_iquanzhangMax)
			{
				JY_SetPersonStatus(enum_QuanZhang,iPerson,gpGlobals->g.pThingsList[iWuPin].JiaQuanZhang,false);
				bUse = true;
			}
		}
		if (gpGlobals->g.pThingsList[iWuPin].JiaYuJian != 0)
		{
			if (gpGlobals->g.pPersonList[iPerson].YuJian < g_iyujianMax)
			{
				JY_SetPersonStatus(enum_YuJian,iPerson,gpGlobals->g.pThingsList[iWuPin].JiaYuJian,false);
				bUse = true;
			}
		}
		if (gpGlobals->g.pThingsList[iWuPin].JiaShuaDao != 0)
		{
			if (gpGlobals->g.pPersonList[iPerson].ShuaDao < g_ishuadaoMax)
			{
				JY_SetPersonStatus(enum_ShuaDao,iPerson,gpGlobals->g.pThingsList[iWuPin].JiaShuaDao,false);
				bUse = true;
			}
		}
		if (gpGlobals->g.pThingsList[iWuPin].JiaTeShuBingQi != 0)
		{
			if (gpGlobals->g.pPersonList[iPerson].TeSHuBingQi < g_iteshuMax)
			{
				JY_SetPersonStatus(enum_TeSHuBingQi,iPerson,gpGlobals->g.pThingsList[iWuPin].JiaTeShuBingQi,false);
				bUse = true;
			}
		}
		if (gpGlobals->g.pThingsList[iWuPin].JiaAnQiJiQiao != 0)
		{
			if (gpGlobals->g.pPersonList[iPerson].AnQiJiQiao < g_ianqiMax)
			{
				JY_SetPersonStatus(enum_AnQiJiQiao,iPerson,gpGlobals->g.pThingsList[iWuPin].JiaAnQiJiQiao,false);
				bUse = true;
			}
		}
		if (gpGlobals->g.pThingsList[iWuPin].JiaWuXueChangShi != 0)
		{
			if (gpGlobals->g.pPersonList[iPerson].WuXueChangShi < g_iwuxueMax)
			{
				JY_SetPersonStatus(enum_WuXueChangShi,iPerson,gpGlobals->g.pThingsList[iWuPin].JiaWuXueChangShi,false);
				bUse = true;
			}
		}
		if (gpGlobals->g.pThingsList[iWuPin].JiaPinDe != 0)
		{
			if (gpGlobals->g.pPersonList[iPerson].PinDe < g_ipindeMax)
			{
				JY_SetPersonStatus(enum_PinDe,iPerson,gpGlobals->g.pThingsList[iWuPin].JiaPinDe,false);
				bUse = true;
			}
		}
		if (gpGlobals->g.pThingsList[iWuPin].JiaGongFuDaiDu != 0)
		{
			if (gpGlobals->g.pPersonList[iPerson].GongjiDaiDu < g_igongjidaiduMax)
			{
				JY_SetPersonStatus(enum_GongjiDaiDu,iPerson,gpGlobals->g.pThingsList[iWuPin].JiaGongFuDaiDu,false);
				bUse = true;
			}
		}
		if (bUse)
		{
			gpGlobals->g.pPersonList[iPerson].XieDaiWuPinShuLiang[iWuPinIdx] --;
			if (gpGlobals->g.pPersonList[iPerson].XieDaiWuPinShuLiang[iWuPinIdx] <= 0)
			{
				gpGlobals->g.pPersonList[iPerson].XieDaiWuPin[iWuPinIdx] = -1;
				gpGlobals->g.pPersonList[iPerson].XieDaiWuPinShuLiang[iWuPinIdx] = 0;
			}
			JY_ShowSurface();
			JY_Delay(1000);
		}
	}

	return 0;
}
//医疗解毒
short JY_UserYLJD(short iUsePersonIdx,short iDestPersonIdx,short iType)
{
	short iUsePerson = -1;	
	short iDestPerson = -1;	
	short iYiLiaoNengLi = -1;
	short iShouShangChengDu = -1;

	short iJieDuNengLi = -1;
	short iZhongDuChengDu = -1;

	short iTemp = 0;

	if (iUsePersonIdx < 0 || iUsePersonIdx > 6)
		return 0;
	if (iDestPersonIdx < 0 || iDestPersonIdx > 6)
		return 0;
	iUsePerson = gpGlobals->g.pBaseList->Group[iUsePersonIdx];
	iDestPerson = gpGlobals->g.pBaseList->Group[iDestPersonIdx];
	if (gpGlobals->g.pPersonList[iUsePerson].Tili < 50)
	{
		return 0;
	}
	iYiLiaoNengLi = gpGlobals->g.pPersonList[iUsePerson].YiLiao;
	iShouShangChengDu = gpGlobals->g.pPersonList[iDestPerson].ShouShang;
	
	iJieDuNengLi = gpGlobals->g.pPersonList[iUsePerson].JieDu;
	iZhongDuChengDu = gpGlobals->g.pPersonList[iDestPerson].ZhongDu;

	if (iType == 1)
	{
		if (iShouShangChengDu  > iYiLiaoNengLi + 20)
		{
			return 0;
		}
		if (iShouShangChengDu < (g_ishoushangMax/4))
		{
			iYiLiaoNengLi = iYiLiaoNengLi * 4 / 5;
		}
		else if (iShouShangChengDu < (g_ishoushangMax/2))
		{
			iYiLiaoNengLi = iYiLiaoNengLi * 3 / 4;
		}
		else if (iShouShangChengDu <(g_ishoushangMax/4*3))
		{
			iYiLiaoNengLi = iYiLiaoNengLi * 2 / 3;
		}
		else
		{
			iYiLiaoNengLi = iYiLiaoNengLi  / 2;
		}
		iYiLiaoNengLi = iYiLiaoNengLi + rand() % 5;
		if (gpGlobals->g.pPersonList[iDestPerson].ShouShang > 0 || 
			gpGlobals->g.pPersonList[iDestPerson].hp < gpGlobals->g.pPersonList[iDestPerson].hpMax)
		{
			gpGlobals->g.pPersonList[iDestPerson].ShouShang -= iYiLiaoNengLi;
			gpGlobals->g.pPersonList[iDestPerson].ShouShang = gpGlobals->g.pPersonList[iDestPerson].ShouShang < 0 ? 0 :gpGlobals->g.pPersonList[iDestPerson].ShouShang;

			iTemp = iYiLiaoNengLi;			
			gpGlobals->g.pPersonList[iDestPerson].hp += iYiLiaoNengLi;
			if (gpGlobals->g.pPersonList[iDestPerson].hp > gpGlobals->g.pPersonList[iDestPerson].hpMax)
			{
				iTemp = iYiLiaoNengLi - gpGlobals->g.pPersonList[iDestPerson].hp + gpGlobals->g.pPersonList[iDestPerson].hpMax;
			}
			gpGlobals->g.pPersonList[iDestPerson].hp = gpGlobals->g.pPersonList[iDestPerson].hp > gpGlobals->g.pPersonList[iDestPerson].hpMax ? gpGlobals->g.pPersonList[iDestPerson].hpMax :gpGlobals->g.pPersonList[iDestPerson].hp;
			
			gpGlobals->g.pPersonList[iUsePerson].Tili -= 2;
			gpGlobals->g.pPersonList[iUsePerson].Tili = gpGlobals->g.pPersonList[iUsePerson].Tili < 0 ? 0 :gpGlobals->g.pPersonList[iUsePerson].Tili;
		}
		
		return iTemp;

	}
	if (iType == 2)
	{
		if (iZhongDuChengDu  > iJieDuNengLi + 20)
		{
			return 0;
		}		
		iJieDuNengLi = iJieDuNengLi/3 + rand() % 10 - rand() % 10;
		iJieDuNengLi = iJieDuNengLi < 0 ? 0 :iJieDuNengLi;

		
		if (gpGlobals->g.pPersonList[iDestPerson].ZhongDu > 0)
		{
			iTemp = iJieDuNengLi;
			gpGlobals->g.pPersonList[iDestPerson].ZhongDu -= iJieDuNengLi;
			if (gpGlobals->g.pPersonList[iDestPerson].ZhongDu < 0)
			{
				iTemp = gpGlobals->g.pPersonList[iDestPerson].ZhongDu + iJieDuNengLi;
			}
			gpGlobals->g.pPersonList[iDestPerson].ZhongDu = gpGlobals->g.pPersonList[iDestPerson].ZhongDu < 0 ? 0 :gpGlobals->g.pPersonList[iDestPerson].ZhongDu;

			gpGlobals->g.pPersonList[iUsePerson].Tili -= 2;
			gpGlobals->g.pPersonList[iUsePerson].Tili = gpGlobals->g.pPersonList[iUsePerson].Tili < 0 ? 0 :gpGlobals->g.pPersonList[iUsePerson].Tili;
		}

		return iTemp;
	}
	return 0;
}
//全员离队
short JY_AllPersonExit(VOID)
{
	//short iExit[36][2] = { {0,0},{49,2},{4,1},{44,0},{44,1},{37,5},{30,0},{59,0},{40,3},{56,1},{1,7},{1,8},{1,10},
 //                      {40,7},{40,8},{77,0},{54,0},{62,3},{62,4},{60,2},{60,15},{52,1},{61,0},{61,8},{78,0},
 //                      {18,0},{18,1},{69,0},{69,1},{45,0},{52,2},{42,6},{42,7},{8,8},{7,6},{80,1} };

	//short i = 0;
	//for(i=5;i>0;i--)
	//{
	//	JY_GroupSet(gpGlobals->g.pBaseList->Group[i],FALSE);
	//}
	//for(i=0;i<36;i++)
	//{
	//	JY_SetD(iExit[i][0],iExit[i][1],0,0);
	//	//gpGlobals->g.sceneEventList[iExit[i][0]][iExit[i][1]].isGo = 0;
	//	JY_SetD(iExit[i][0],iExit[i][1],2,-1);
	//	//gpGlobals->g.sceneEventList[iExit[i][0]][iExit[i][1]].EventNum1 = -1;
	//	JY_SetD(iExit[i][0],iExit[i][1],3,-1);
	//	//gpGlobals->g.sceneEventList[iExit[i][0]][iExit[i][1]].EventNum2 = -1;
	//	JY_SetD(iExit[i][0],iExit[i][1],4,-1);
	//	//gpGlobals->g.sceneEventList[iExit[i][0]][iExit[i][1]].EventNum3 = -1;
	//	JY_SetD(iExit[i][0],iExit[i][1],5,-1);
	//	//gpGlobals->g.sceneEventList[iExit[i][0]][iExit[i][1]].PicNum[0] = -1;
	//	JY_SetD(iExit[i][0],iExit[i][1],6,-1);
	//	//gpGlobals->g.sceneEventList[iExit[i][0]][iExit[i][1]].PicNum[1] = -1;
	//	JY_SetD(iExit[i][0],iExit[i][1],7,-1);
	//	//gpGlobals->g.sceneEventList[iExit[i][0]][iExit[i][1]].PicNum[2] = -1;
	//	JY_SetD(iExit[i][0],iExit[i][1],8,-1);
	//	//gpGlobals->g.sceneEventList[iExit[i][0]][iExit[i][1]].PicDelay = -1;
	//}
	short iFind = -1;
	char buf[20] = {0};
	char cScene[20] = {0};
	char cFile[256] = {0};
	sprintf(cFile,"%s/mod.txt",JY_PREFIX);
	FILE *fp = NULL;
	fp = fopen(cFile,"rb");

	short i = 0;
	for(i=0;i<gpGlobals->g.iSceneTypeListCount;i++)
	{
		ClearBuf((LPBYTE)buf,19);
		iFind=-1;
		sprintf(cScene,"%d",i);
		if (GetIniField(fp, "ALLFALLOUT", cScene, "-1", buf))
			iFind = atoi(buf);
		if (iFind > -1)
		{
			JY_SetD(i,iFind,0,0);
			JY_SetD(i,iFind,2,-1);
			JY_SetD(i,iFind,3,-1);
			JY_SetD(i,iFind,4,-1);
			JY_SetD(i,iFind,5,-1);
			JY_SetD(i,iFind,6,-1);
			JY_SetD(i,iFind,7,-1);
			JY_SetD(i,iFind,8,-1);
		}
	}
	UTIL_CloseFile(fp);
	for(i=5;i>0;i--)
	{
		JY_GroupSet(gpGlobals->g.pBaseList->Group[i],FALSE);
	}
	return 0;
}
//判断声望和书本
VOID JY_CheckBook(VOID)
{
	if (gpGlobals->g.pPersonList[0].ShengWang < 200)
		return;
	if (JY_FindThing(g_iWuLinTie) >=0)
		return;
	short i=0;
	short iBook = g_iBook;
	for(i=0;i<g_iBookNum;i++)
	{
		if (JY_FindThing(iBook+i) < 0)
			return;
	}
	JY_SetD(g_iHeroHome,g_iWuLinTieEventNum,0,1);
	//gpGlobals->g.sceneEventList[70][11].isGo = 1;
	JY_SetD(g_iHeroHome,g_iWuLinTieEventNum,2,g_iWuLinTieEvent);
	//gpGlobals->g.sceneEventList[70][11].EventNum1 = 932;
	JY_SetD(g_iHeroHome,g_iWuLinTieEventNum,3,-1);
	//gpGlobals->g.sceneEventList[70][11].EventNum2 = -1;
	JY_SetD(g_iHeroHome,g_iWuLinTieEventNum,4,-1);
	//gpGlobals->g.sceneEventList[70][11].EventNum3 = -1;
	JY_SetD(g_iHeroHome,g_iWuLinTieEventNum,5,g_iWuLinTieImg*2);
	//gpGlobals->g.sceneEventList[70][11].PicNum[0] = 7968;
	JY_SetD(g_iHeroHome,g_iWuLinTieEventNum,6,g_iWuLinTieImg*2);
	//gpGlobals->g.sceneEventList[70][11].PicNum[1] = 7968;
	JY_SetD(g_iHeroHome,g_iWuLinTieEventNum,7,g_iWuLinTieImg*2);
	//gpGlobals->g.sceneEventList[70][11].PicNum[2] = 7968;	
}
//武道大会
short JY_WuDaoDaHui(VOID)
{
	short group=5;//比武的组数
	short num1 = 6;//每组有几个战斗
	short num2 = 3;//选择的战斗数
	short startwar=102;//起始战斗编号
	short flag[6] = {0};
	short i=0;
	short j=0;

	for(i=0;i<group;i++)
	{
		for(j=0;j<num1;j++)
		{
			flag[j] = 0;
		}
		for(j=1;j<=num2;j++)
		{
			short r = 0;
			while(1)
			{
				r = rand() % num1;
				if (flag[r] == 0)
				{
					flag[r] = 1;
					break;
				}
			}
			short warnum = r + i * num1;
			JY_ReDrawMap();
			JY_ShowSurface();

			WarLoad(warnum+startwar);
			JY_DrawTalkDialog(2854+warnum,gpGlobals->g.pPersonList[gpGlobals->g.war.pWarSta->WarfoePerson[0]].PhotoId,0);
			JY_ReDrawMap();
			if (WarMain(warnum+startwar,0,0) == 1)
			{
				JY_ReDrawMap();
				JY_ShowSlow(1,0);
				JY_DrawTalkDialog(2853,0,1);
			}
			else
			{
				return 0;
			}
		}
		if (i < group - 1)
		{
			JY_ReDrawMap();
			JY_DrawTalkDialog(2891,70,0);
			JY_ReDrawMap();
			JY_ShowSlow(1,1);
			if (gpGlobals->g.pPersonList[0].ShouShang < (g_ishoushangMax/2) &&
				gpGlobals->g.pPersonList[0].ZhongDu <=0)
			{
				JY_SetPersonStatus(enum_hp,0,g_ishengmingMax,FALSE);
				JY_SetPersonStatus(enum_Tili,0,g_itiliMax,FALSE);
				JY_SetPersonStatus(enum_Neili,0,g_ineiliMax,FALSE);
			}
			JY_ShowSlow(1,0);
			JY_DrawTalkDialog(2892,0,1);
			JY_ReDrawMap();
		}
	}
	JY_ReDrawMap();
	JY_DrawTalkDialog(2884,0,1);
	JY_ReDrawMap();
	JY_DrawTalkDialog(2885,70,0);
	JY_ReDrawMap();
	JY_DrawTalkDialog(2886,12,0);
	JY_ReDrawMap();
	JY_DrawTalkDialog(2887,64,4);
	JY_ReDrawMap();
	JY_DrawTalkDialog(2888,19,0);
	JY_ShowSlow(1,1);
	for(i=24;i<=72;i++)
	{
		JY_SetD(gpGlobals->g.iSceneNum,i,0,0);
		//gpGlobals->g.sceneEventList[gpGlobals->g.iSceneNum][i].isGo = 0;
		JY_SetD(gpGlobals->g.iSceneNum,i,2,-1);
		//gpGlobals->g.sceneEventList[gpGlobals->g.iSceneNum][i].EventNum1 = -1;
		JY_SetD(gpGlobals->g.iSceneNum,i,3,-1);
		//gpGlobals->g.sceneEventList[gpGlobals->g.iSceneNum][i].EventNum2 = -1;
		JY_SetD(gpGlobals->g.iSceneNum,i,4,-1);
		//gpGlobals->g.sceneEventList[gpGlobals->g.iSceneNum][i].EventNum3 = -1;
		JY_SetD(gpGlobals->g.iSceneNum,i,5,-1);
		//gpGlobals->g.sceneEventList[gpGlobals->g.iSceneNum][i].PicNum[0] = -1;
		JY_SetD(gpGlobals->g.iSceneNum,i,6,-1);
		//gpGlobals->g.sceneEventList[gpGlobals->g.iSceneNum][i].PicNum[1] = -1;
		JY_SetD(gpGlobals->g.iSceneNum,i,7,-1);
		//gpGlobals->g.sceneEventList[gpGlobals->g.iSceneNum][i].PicNum[2] = -1;
	}
	JY_ReDrawMap();
	JY_ShowSlow(1,0);
	JY_DrawTalkDialog(2889,0,1);
	JY_ReDrawMap();
	JY_DrawGetThingDialog(g_iShenZhang,1);
	JY_ThingSet(g_iShenZhang,1);
	return 1;
}


//高昌迷宫动画
VOID JY_GaoChangMiGong(VOID)
{
	short uStartCode = 7664;
	short uEndCode = 7674;
	if (uStartCode > 0 && uEndCode > 0)
	{
		for(int i=0;i<(uEndCode-uStartCode)/2;i++)
		{
			gpGlobals->g.iMyPic = uStartCode/2 + i;
			JY_ReDrawMap();
			SDL_Delay(100);
			JY_ShowSurface();
		}
	}

	for(int i=0;i<56;i+=2)
	{
		if (gpGlobals->g.iMyPic< 7688/2)
			gpGlobals->g.iMyPic= (7676+i)/2;

		JY_SetD(gpGlobals->g.iSceneNum,2,5,i+7690);
		JY_SetD(gpGlobals->g.iSceneNum,2,6,i+7690);
		JY_SetD(gpGlobals->g.iSceneNum,2,7,i+7690);
		JY_SetD(gpGlobals->g.iSceneNum,3,5,i+7748);
		JY_SetD(gpGlobals->g.iSceneNum,3,6,i+7748);
		JY_SetD(gpGlobals->g.iSceneNum,3,7,i+7748);
		JY_SetD(gpGlobals->g.iSceneNum,4,5,i+7806);
		JY_SetD(gpGlobals->g.iSceneNum,4,6,i+7806);
		JY_SetD(gpGlobals->g.iSceneNum,4,7,i+7806);

		//gpGlobals->g.sceneEventList[gpGlobals->g.iSceneNum][2].PicNum[0] = i+7690;
		//gpGlobals->g.sceneEventList[gpGlobals->g.iSceneNum][2].PicNum[1] = i+7690;
		//gpGlobals->g.sceneEventList[gpGlobals->g.iSceneNum][2].PicNum[2] = i+7690;
		//gpGlobals->g.sceneEventList[gpGlobals->g.iSceneNum][3].PicNum[0] = i+7748;
		//gpGlobals->g.sceneEventList[gpGlobals->g.iSceneNum][3].PicNum[1] = i+7748;
		//gpGlobals->g.sceneEventList[gpGlobals->g.iSceneNum][3].PicNum[2] = i+7748;
		//gpGlobals->g.sceneEventList[gpGlobals->g.iSceneNum][4].PicNum[0] = i+7806;
		//gpGlobals->g.sceneEventList[gpGlobals->g.iSceneNum][4].PicNum[1] = i+7806;
		//gpGlobals->g.sceneEventList[gpGlobals->g.iSceneNum][4].PicNum[2] = i+7806;
		JY_ReDrawMap();
		SDL_Delay(100);
		JY_ShowSurface();
	}
}
short JY_Use50(short v1,short v2,short v3,short v4,short v5,short v6,short v7)
{
	return 0;
}
//执行脚本
short JY_RunTriggerScript(short wScriptEntry,short aiWuPin)
{
	BOOL	fEnded;
	fEnded = FALSE;

	if (wScriptEntry < 0 || wScriptEntry > gpGlobals->g.iKdefListCount)
		return -1;
	INT iCur = 0;
	short uStartCode = 0;
	short uEndCode = 0;
	short uEventNo = 0;
	short uSceneNum = 0;
	short uTemp = 0;
	short uTempFlag1 = 0;
	short uTempFlag2 = 0;
	short uTempFlag3 = 0;
	short uTempFlag4 = 0;
	short uTempFlag5 = 0;
	LPSTR pChar = NULL;
	JY_POS pos = 0;
	INT x = 0;
	INT y = 0;
	
	while (wScriptEntry != 0 && !fEnded)
	{
		short uScript = gpGlobals->g.pKdefList[wScriptEntry].pData[iCur];
		switch (uScript)
		{
		case 0://清屏指令清除屏幕前景显示，不清除背景画面
			JY_ReDrawMap();
			iCur+=1;
			break;
		case 1://对话(对话编号,人物头像代号,对话框位置)
			uTemp = gpGlobals->g.pKdefList[wScriptEntry].pData[iCur + 1];
			uTempFlag1 = gpGlobals->g.pKdefList[wScriptEntry].pData[iCur + 2];
			uTempFlag2 = gpGlobals->g.pKdefList[wScriptEntry].pData[iCur + 3];
			JY_DrawTalkDialog(uTemp,uTempFlag1,uTempFlag2);
			iCur+=4;
			break;
		case 2://得到物品(物品编号,数量) 
			uTempFlag1 = gpGlobals->g.pKdefList[wScriptEntry].pData[iCur + 1];
			uTempFlag2 = gpGlobals->g.pKdefList[wScriptEntry].pData[iCur + 2];
			JY_ReDrawMap();
			JY_DrawGetThingDialog(uTempFlag1,uTempFlag2);
			JY_Delay(1000);
			JY_ThingSet(uTempFlag1,uTempFlag2);
			iCur+=3;
			break;
		case 3://重新修改事件内容后跟13个2B其中fffe(-2)均表示当前值不变
			uSceneNum = gpGlobals->g.pKdefList[wScriptEntry].pData[++iCur];//场景编号
			if (uSceneNum == -2) uSceneNum = gpGlobals->g.iSceneNum;
			uEventNo = gpGlobals->g.pKdefList[wScriptEntry].pData[++iCur];//场景事件序号
			if (uEventNo == -2) uEventNo = gpGlobals->g.iSceneEventCode;
			uTemp = gpGlobals->g.pKdefList[wScriptEntry].pData[++iCur];
			if (uTemp != -2)
			{
				JY_SetD(uSceneNum,uEventNo,0,uTemp);
				//gpGlobals->g.sceneEventList[uSceneNum][uEventNo].isGo = uTemp;//是否触发
			}
			uTemp = gpGlobals->g.pKdefList[wScriptEntry].pData[++iCur];
			if (uTemp != -2)
			{
				JY_SetD(uSceneNum,uEventNo,1,uTemp);
				//gpGlobals->g.sceneEventList[uSceneNum][uEventNo].id = uTemp;//编号
			}
			uTemp = gpGlobals->g.pKdefList[wScriptEntry].pData[++iCur];
			if (uTemp != -2)
			{
				JY_SetD(uSceneNum,uEventNo,2,uTemp);
				//gpGlobals->g.sceneEventList[uSceneNum][uEventNo].EventNum1 = uTemp;//调查(使用空格)触发的事件编号
			}
			uTemp = gpGlobals->g.pKdefList[wScriptEntry].pData[++iCur];
			if (uTemp != -2)
			{
				JY_SetD(uSceneNum,uEventNo,3,uTemp);
				//gpGlobals->g.sceneEventList[uSceneNum][uEventNo].EventNum2 = uTemp;//主角使用物品时触发的事件
			}
			uTemp = gpGlobals->g.pKdefList[wScriptEntry].pData[++iCur];
			if (uTemp != -2)
			{
				JY_SetD(uSceneNum,uEventNo,4,uTemp);
				//gpGlobals->g.sceneEventList[uSceneNum][uEventNo].EventNum3 = uTemp;//主角通过时触发的事件
			}
			uTemp = gpGlobals->g.pKdefList[wScriptEntry].pData[++iCur];
			if (uTemp != -2)
			{
				JY_SetD(uSceneNum,uEventNo,5,uTemp);
				//gpGlobals->g.sceneEventList[uSceneNum][uEventNo].PicNum[0] = uTemp;//动画起始编号
			}
			uTemp = gpGlobals->g.pKdefList[wScriptEntry].pData[++iCur];
			if (uTemp != -2)
			{
				JY_SetD(uSceneNum,uEventNo,6,uTemp);
				//gpGlobals->g.sceneEventList[uSceneNum][uEventNo].PicNum[1] = uTemp;//动画结束编号
			}
			uTemp = gpGlobals->g.pKdefList[wScriptEntry].pData[++iCur];
			if (uTemp != -2)
			{
				JY_SetD(uSceneNum,uEventNo,7,uTemp);
				//gpGlobals->g.sceneEventList[uSceneNum][uEventNo].PicNum[2] = uTemp;//动画起始编号
			}
			uTemp = gpGlobals->g.pKdefList[wScriptEntry].pData[++iCur];
			if (uTemp != -2)
			{
				JY_SetD(uSceneNum,uEventNo,8,uTemp);
				//gpGlobals->g.sceneEventList[uSceneNum][uEventNo].PicDelay = uTemp;//贴图动画显示延迟帧数
			}
			uTemp = gpGlobals->g.pKdefList[wScriptEntry].pData[++iCur];
			uTempFlag1 = -2;
			uTempFlag2 = -2;
			if (uTemp != -2)
			{
				uTempFlag1 = uTemp;//事件触发点x坐标
			}
			uTemp = gpGlobals->g.pKdefList[wScriptEntry].pData[++iCur];
			if (uTemp != -2)
			{
				uTempFlag2 = uTemp;//事件触发点x坐标
			}
			if (uTempFlag1 != -2 && uTempFlag2 != -2)
			{
				//原坐标清除
				JY_SetSMap(uSceneNum,JY_GetD(uSceneNum,uEventNo,9),
							JY_GetD(uSceneNum,uEventNo,10),3,-1);
				//JY_SetSMap(uSceneNum,gpGlobals->g.sceneEventList[uSceneNum][uEventNo].x,
				//			gpGlobals->g.sceneEventList[uSceneNum][uEventNo].y,3,-1);
				JY_SetD(uSceneNum,uEventNo,9,uTempFlag1);
				//gpGlobals->g.sceneEventList[uSceneNum][uEventNo].x = uTempFlag1;
				JY_SetD(uSceneNum,uEventNo,10,uTempFlag2);
				//gpGlobals->g.sceneEventList[uSceneNum][uEventNo].y = uTempFlag2;
				//新坐标
				JY_SetSMap(uSceneNum,JY_GetD(uSceneNum,uEventNo,9),
							JY_GetD(uSceneNum,uEventNo,10),3,-1);
				//JY_SetSMap(uSceneNum,gpGlobals->g.sceneEventList[uSceneNum][uEventNo].x,
				//			gpGlobals->g.sceneEventList[uSceneNum][uEventNo].y,3,uEventNo);
			}
			
			iCur++;
			break;
		case 4://使用物体触发事件(物品编号,正确转向偏移量,不正确转向偏移量) 
			uTemp = gpGlobals->g.pKdefList[wScriptEntry].pData[iCur + 1];
			uTempFlag1 = gpGlobals->g.pKdefList[wScriptEntry].pData[iCur + 2];
			uTempFlag2 = gpGlobals->g.pKdefList[wScriptEntry].pData[iCur + 3];
			if (uTemp == aiWuPin && aiWuPin != -1)//if (JY_FindThing(uTemp) == -1)
			{
				iCur=iCur + 4 + uTempFlag1;
			}
			else
			{
				iCur=iCur + 4 + uTempFlag2;
			}
			break;
		case 5://询问是否战斗(是转向偏移量,否转向偏移量) 
			uTempFlag1 = gpGlobals->g.pKdefList[wScriptEntry].pData[iCur + 1];
			uTempFlag2 = gpGlobals->g.pKdefList[wScriptEntry].pData[iCur + 2];
			uTemp = JY_DrawTextDialog("是否进行战斗?",JY_XY(g_wInitialWidth / 2,g_iFontSize),TRUE,TRUE,TRUE);
			iCur+=3;
			if (uTemp == 1)
				iCur+=uTempFlag1;
			else
				iCur+=uTempFlag2;
			break;
			break;
		case 6://战斗(战斗场景编号,赢转向偏移量,输转向偏移量,输后是否有经验值得) 
			uSceneNum = gpGlobals->g.pKdefList[wScriptEntry].pData[++iCur];
			uTemp = gpGlobals->g.pKdefList[wScriptEntry].pData[++iCur];
			uTempFlag1 = gpGlobals->g.pKdefList[wScriptEntry].pData[++iCur];
			uTempFlag2 = gpGlobals->g.pKdefList[wScriptEntry].pData[++iCur];
			iCur++;
			JY_ReDrawMap();
			uTempFlag3 = WarMain(uSceneNum,uTempFlag2,0);
			if (uTempFlag3 == 1)
				iCur+=uTemp;//
			else
				iCur+=uTempFlag1;//
			break;
		case 7://无条件返回，事件结束
			fEnded = TRUE;
			break;
		case 8://改变大地图音乐(音乐编号) 
			uTemp = gpGlobals->g.pKdefList[wScriptEntry].pData[++iCur];
			OGG_Play(0, FALSE);
			OGG_Play(uTemp, TRUE);
			iCur++;
			break;
		case 9://询问是否加入(是转向偏移量,否转向偏移量) 
			uTempFlag1 = gpGlobals->g.pKdefList[wScriptEntry].pData[iCur + 1];
			uTempFlag2 = gpGlobals->g.pKdefList[wScriptEntry].pData[iCur + 2];
			JY_ReDrawMap();
			uTemp = JY_DrawTextDialog("是否要求加入?",JY_XY(g_wInitialWidth / 2,g_iFontSize),TRUE,TRUE,TRUE);
			iCur+=3;
			if (uTemp == 1)
				iCur+=uTempFlag1;
			else
				iCur+=uTempFlag2;
			break;
		case 10://加入队员(人物代号) 
			uTemp = gpGlobals->g.pKdefList[wScriptEntry].pData[++iCur];
			JY_GroupSet(uTemp,TRUE);
			iCur++;
			break;
		case 11://询问是否住宿(是转向偏移量,否转向偏移量) 
			uTempFlag1 = gpGlobals->g.pKdefList[wScriptEntry].pData[iCur + 1];
			uTempFlag2 = gpGlobals->g.pKdefList[wScriptEntry].pData[iCur + 2];
			iCur+=3;
			JY_ReDrawMap();
			uTemp = JY_DrawTextDialog("[原版:住宿过夜?Y/N][MOD版:是/否]",JY_XY(g_wInitialWidth / 2,g_iFontSize),TRUE,TRUE,TRUE);
			if (uTemp == 1)
				iCur+=uTempFlag1;
			else
				iCur+=uTempFlag2;
			break;
		case 12://住宿 恢复体力，内力和生命若受伤>33或者中毒，则不能住宿恢复，只能治疗和吃药
			JY_Sleep();
			iCur++;
			break;
		case 13://场景重新显示
			JY_ReDrawMap();
			JY_ShowSlow(1,0);
			iCur++;
			break;
		case 14://场景从明亮渐变为暗淡 
			JY_ShowSlow(1,1);
			iCur++;
			break;
		case 15://死亡回到选单(5300)
			JY_FillColor(0,0,0,0,0);
			JY_DrawTextDialog("大侠请重新再来",JY_XY(g_wInitialWidth / 2,g_wInitialHeight/2),FALSE,TRUE,TRUE);
			fEnded = TRUE;
			gpGlobals->g.Status = -1;
			break;
		case 16://判断某个人是否在队中(人代号,在转向偏移量,不在转向偏移量) 
			uTemp = gpGlobals->g.pKdefList[wScriptEntry].pData[iCur + 1];
			uTempFlag1 = gpGlobals->g.pKdefList[wScriptEntry].pData[iCur + 2];
			uTempFlag2 = gpGlobals->g.pKdefList[wScriptEntry].pData[iCur + 3];
			iCur+=4;
			if (JY_FindPerson(uTemp) >=0)
				iCur+=uTempFlag1;
			else
				iCur+=uTempFlag2;
			break;
		case 17://修改场景的s*贴图(场景编号,图层,横坐标,纵坐标,贴图编号)
			uSceneNum = gpGlobals->g.pKdefList[wScriptEntry].pData[++iCur];
			if (uSceneNum == -2) uSceneNum = gpGlobals->g.iSceneNum;
			uTemp = gpGlobals->g.pKdefList[wScriptEntry].pData[++iCur];
			uTempFlag1 = gpGlobals->g.pKdefList[wScriptEntry].pData[++iCur];
			uTempFlag2 = gpGlobals->g.pKdefList[wScriptEntry].pData[++iCur];
			uStartCode = gpGlobals->g.pKdefList[wScriptEntry].pData[++iCur];
			JY_SetScenePic(uSceneNum,uTemp,uTempFlag1,uTempFlag2,uStartCode);
			iCur++;
			break;
		case 18://判断是否有某种物品(物品编号,有转向偏移量,没有转向偏移量) 
			uTemp = gpGlobals->g.pKdefList[wScriptEntry].pData[++iCur];
			uTempFlag1 = gpGlobals->g.pKdefList[wScriptEntry].pData[++iCur];
			uTempFlag2 = gpGlobals->g.pKdefList[wScriptEntry].pData[++iCur];			
			iCur++;
			if (JY_FindThing(uTemp) >=0)
				iCur+=uTempFlag1;
			else
				iCur+=uTempFlag2;
			break;
		case 19://改变主角当前位置(目标x,目标y) ，瞬间移动，没有一步一步走路
			uTempFlag1 = gpGlobals->g.pKdefList[wScriptEntry].pData[++iCur];
			uTempFlag2 = gpGlobals->g.pKdefList[wScriptEntry].pData[++iCur];
			if (gpGlobals->g.Status == 1 || gpGlobals->g.Status == 4)
			{
				//JY_ShowSlow(1,1);
				gpGlobals->g.pBaseList->SMapX = uTempFlag1;
				gpGlobals->g.pBaseList->SMapY = uTempFlag2;
				//JY_ReDrawMap();
				//JY_ShowSlow(1,0);
			}
			iCur++;
			break;
		case 20://判断队伍是否满(满转向偏移量,不满转向偏移量) 
			uTempFlag1 = gpGlobals->g.pKdefList[wScriptEntry].pData[iCur + 1];
			uTempFlag2 = gpGlobals->g.pKdefList[wScriptEntry].pData[iCur + 2];
			iCur+=3;
			uTemp = JY_CheckGroupNum();
			if (uTemp == 6)
				iCur+=uTempFlag1;
			else
				iCur+=uTempFlag2;
			break;
		case 21://队员离队(人代号) 
			uTemp = gpGlobals->g.pKdefList[wScriptEntry].pData[++iCur];
			JY_GroupSet(uTemp,FALSE);
			iCur++;
			break;
		case 22://队伍全体内力降为0 		
			for(int i=0;i<6;i++)
			{
				uTemp = gpGlobals->g.pBaseList->Group[i];
				if (uTemp != -1)
				{
					JY_SetPersonStatus(enum_Neili,uTemp,0,TRUE);
				}
			}
			iCur++;
			break;
		case 23://设置用毒能力(人代号,数值)
			uTempFlag1 = gpGlobals->g.pKdefList[wScriptEntry].pData[++iCur];
			uTempFlag2 = gpGlobals->g.pKdefList[wScriptEntry].pData[++iCur];
			JY_SetPersonStatus(enum_YongDu,uTempFlag1,uTempFlag2,TRUE);
			iCur++;
			break;
		case 24://死亡黒色背景'这个kdef.grp中没用到 
			iCur++;
			break;
		case 25://场景移动(原始x,原始y,目标x,目标y) , 一步一步显示移动
			uStartCode = gpGlobals->g.pKdefList[wScriptEntry].pData[++iCur];
			uEndCode = gpGlobals->g.pKdefList[wScriptEntry].pData[++iCur];
			uTempFlag1 = gpGlobals->g.pKdefList[wScriptEntry].pData[++iCur];
			uTempFlag2 = gpGlobals->g.pKdefList[wScriptEntry].pData[++iCur];
			JY_MoveScene(uStartCode,uEndCode,uTempFlag1,uTempFlag2,0);
			iCur++;
			break;
		case 26://增加场景事件编号的三个触发事件编号(场景编号,场景事件序号,事件1增加量,事件2增加量,事件3增加量)
			uSceneNum = gpGlobals->g.pKdefList[wScriptEntry].pData[++iCur];//场景编号
			if (uSceneNum == -2) uSceneNum = gpGlobals->g.iSceneNum;
			uEventNo = gpGlobals->g.pKdefList[wScriptEntry].pData[++iCur];//场景事件序号
			if (uEventNo == -2) uEventNo = gpGlobals->g.iSceneEventCode;
			uTemp = gpGlobals->g.pKdefList[wScriptEntry].pData[++iCur];
			if (uTemp != -2)
			{
				JY_SetD(uSceneNum,uEventNo,2,uTemp+JY_GetD(uSceneNum,uEventNo,2));
				//gpGlobals->g.sceneEventList[uSceneNum][uEventNo].EventNum1 = uTemp +
				//	gpGlobals->g.sceneEventList[uSceneNum][uEventNo].EventNum1;//调查(使用空格)触发的事件编号
			}
			uTemp = gpGlobals->g.pKdefList[wScriptEntry].pData[++iCur];
			if (uTemp != -2)
			{
				JY_SetD(uSceneNum,uEventNo,3,uTemp+JY_GetD(uSceneNum,uEventNo,3));
				//gpGlobals->g.sceneEventList[uSceneNum][uEventNo].EventNum2 = uTemp +
				//	gpGlobals->g.sceneEventList[uSceneNum][uEventNo].EventNum2;//主角使用物品时触发的事件
			}
			uTemp = gpGlobals->g.pKdefList[wScriptEntry].pData[++iCur];
			if (uTemp != -2)
			{
				JY_SetD(uSceneNum,uEventNo,4,uTemp+JY_GetD(uSceneNum,uEventNo,4));
				//gpGlobals->g.sceneEventList[uSceneNum][uEventNo].EventNum3 = uTemp +
				//	gpGlobals->g.sceneEventList[uSceneNum][uEventNo].EventNum3;//主角通过时触发的事件
			}
			++iCur;
			break;
		case 27://显示动画
			uEventNo = gpGlobals->g.pKdefList[wScriptEntry].pData[iCur + 1];//标志动画显示位置的当前场景事件编号
			if (uEventNo != -1)
			{
				uTempFlag1 = JY_GetD(gpGlobals->g.iSceneNum,uEventNo,5);
				//uTempFlag1 = gpGlobals->g.sceneEventList[gpGlobals->g.iSceneNum][uEventNo].PicNum[0];
				uTempFlag2 = JY_GetD(gpGlobals->g.iSceneNum,uEventNo,6);
				//uTempFlag2 = gpGlobals->g.sceneEventList[gpGlobals->g.iSceneNum][uEventNo].PicNum[1];
				uTempFlag3 = JY_GetD(gpGlobals->g.iSceneNum,uEventNo,7);
				//uTempFlag3 = gpGlobals->g.sceneEventList[gpGlobals->g.iSceneNum][uEventNo].PicNum[2];
			}
			uStartCode = gpGlobals->g.pKdefList[wScriptEntry].pData[iCur + 2];//起始图编号
			uEndCode = gpGlobals->g.pKdefList[wScriptEntry].pData[iCur + 3];//中止图编号
			if (uStartCode > 0 && uEndCode > 0)
			{
				for(int i=uStartCode;i<uEndCode;i+=2)
				{
					if (uEventNo == -1)
					{
						gpGlobals->g.iMyPic = i/2;
					}
					else
					{
						JY_SetD(gpGlobals->g.iSceneNum,uEventNo,5,i);
						//gpGlobals->g.sceneEventList[gpGlobals->g.iSceneNum][uEventNo].PicNum[0] = i;
						JY_SetD(gpGlobals->g.iSceneNum,uEventNo,6,i);
						//gpGlobals->g.sceneEventList[gpGlobals->g.iSceneNum][uEventNo].PicNum[1] = i;
						JY_SetD(gpGlobals->g.iSceneNum,uEventNo,7,i);
						//gpGlobals->g.sceneEventList[gpGlobals->g.iSceneNum][uEventNo].PicNum[2] = i;
					}
					JY_ReDrawMap();
					SDL_Delay(100);
					JY_ShowSurface();
				}
			}
			if (uEventNo != -1)
			{
				JY_SetD(gpGlobals->g.iSceneNum,uEventNo,5,uTempFlag1);
				//gpGlobals->g.sceneEventList[gpGlobals->g.iSceneNum][uEventNo].PicNum[0] = uTempFlag1;
				JY_SetD(gpGlobals->g.iSceneNum,uEventNo,6,uTempFlag2);
				//gpGlobals->g.sceneEventList[gpGlobals->g.iSceneNum][uEventNo].PicNum[1] = uTempFlag2;
				JY_SetD(gpGlobals->g.iSceneNum,uEventNo,7,uTempFlag3);
				//gpGlobals->g.sceneEventList[gpGlobals->g.iSceneNum][uEventNo].PicNum[2] = uTempFlag3;
			}
			iCur+=4;
			break;
		case 28://判断品德(人代号,数值下限,数值上限,达到转向偏移量,否转向偏移量)
			uTemp = gpGlobals->g.pKdefList[wScriptEntry].pData[++iCur];
			uStartCode = gpGlobals->g.pKdefList[wScriptEntry].pData[++iCur];
			uEndCode = gpGlobals->g.pKdefList[wScriptEntry].pData[++iCur];
			uTempFlag1 = gpGlobals->g.pKdefList[wScriptEntry].pData[++iCur];
			uTempFlag2 = gpGlobals->g.pKdefList[wScriptEntry].pData[++iCur];
			iCur++;
			if (gpGlobals->g.pPersonList[uTemp].PinDe >= uStartCode && 
				gpGlobals->g.pPersonList[uTemp].PinDe <= uEndCode)
			{
				iCur+=uTempFlag1;
			}
			else
			{
				iCur+=uTempFlag2;
			}
			break;
		case 29://判断武力(人代号,数值下限,数值上限,达到转向偏移量,否转向偏移量)
			uTemp = gpGlobals->g.pKdefList[wScriptEntry].pData[++iCur];
			uStartCode = gpGlobals->g.pKdefList[wScriptEntry].pData[++iCur];
			uEndCode = gpGlobals->g.pKdefList[wScriptEntry].pData[++iCur];
			uTempFlag1 = gpGlobals->g.pKdefList[wScriptEntry].pData[++iCur];
			uTempFlag2 = gpGlobals->g.pKdefList[wScriptEntry].pData[++iCur];
			iCur++;
			if (gpGlobals->g.pPersonList[uTemp].GongJiLi >= uStartCode && 
				gpGlobals->g.pPersonList[uTemp].GongJiLi <= uEndCode)
			{
				iCur+=uTempFlag1;
			}
			else
			{
				iCur+=uTempFlag2;
			}
			break;
		case 30://主角走动(原始x,原始y,目标x,目标y) 
			uStartCode = gpGlobals->g.pKdefList[wScriptEntry].pData[++iCur];
			uEndCode = gpGlobals->g.pKdefList[wScriptEntry].pData[++iCur];
			uTempFlag1 = gpGlobals->g.pKdefList[wScriptEntry].pData[++iCur];
			uTempFlag2 = gpGlobals->g.pKdefList[wScriptEntry].pData[++iCur];
			JY_MoveScene(uStartCode,uEndCode,uTempFlag1,uTempFlag2,1);
			iCur++;
			break;
		case 31://判断是否够钱(需要钱数,够钱转向偏移量,不够转向偏移量)
			uTemp = gpGlobals->g.pKdefList[wScriptEntry].pData[++iCur];
			uTempFlag1 = gpGlobals->g.pKdefList[wScriptEntry].pData[++iCur];
			uTempFlag2 = gpGlobals->g.pKdefList[wScriptEntry].pData[++iCur];
			iCur++;
			uTempFlag3 = -1;
			uTempFlag4 = -1;
			for(int i=0;i<200;i++)
			{
				if (gpGlobals->g.pBaseList->WuPin[i][0] == g_iMoney)
				{
					uTempFlag3 = i;
					uTempFlag4 = gpGlobals->g.pBaseList->WuPin[i][1];
					break;
				}
			}
			if (uTempFlag3 >=0 && uTempFlag4 >= uTemp)
				iCur+=uTempFlag1;
			else
				iCur+=uTempFlag2;
			break;
		case 32://增加物品数量(物品编号,数量) 
			uTempFlag1 = gpGlobals->g.pKdefList[wScriptEntry].pData[iCur + 1];
			uTempFlag2 = gpGlobals->g.pKdefList[wScriptEntry].pData[iCur + 2];
			JY_ThingSet(uTempFlag1,uTempFlag2);
			iCur+=3;
			break;
		case 33://学会武功(人代号,武功编号,是否显示学会武功(0显示，1不显示)) 如果武功已满10个则会洗掉第一个武功？
			uTemp = gpGlobals->g.pKdefList[wScriptEntry].pData[++iCur];
			uTempFlag1 = gpGlobals->g.pKdefList[wScriptEntry].pData[++iCur];
			uTempFlag2 = gpGlobals->g.pKdefList[wScriptEntry].pData[++iCur];
			JY_SetPersonStatus(enum_XueHuiWuGong,uTemp,uTempFlag1,TRUE);
			if(uTempFlag2 == 0)
			{
				//显示
			}
			iCur++;
			break;
		case 34://增加资质(人代号,数值) 
			uTempFlag1 = gpGlobals->g.pKdefList[wScriptEntry].pData[iCur + 1];
			uTempFlag2 = gpGlobals->g.pKdefList[wScriptEntry].pData[iCur + 2];
			JY_SetPersonStatus(enum_ZiZhi,uTempFlag1,uTempFlag2,FALSE);
			JY_ReDrawMap();
			JY_ShowAttribAdd(uTempFlag1,enum_ZiZhi,uTempFlag2);
			iCur+=3;
			break;
		case 35://设置武功(人代号,武功栏位,武功编号,武功点数) 			
			uTemp = gpGlobals->g.pKdefList[wScriptEntry].pData[++iCur];
			uTempFlag1 = gpGlobals->g.pKdefList[wScriptEntry].pData[++iCur];
			uTempFlag2 = gpGlobals->g.pKdefList[wScriptEntry].pData[++iCur];
			uStartCode = gpGlobals->g.pKdefList[wScriptEntry].pData[++iCur];
			if (uTempFlag1 >=0)
			{
				gpGlobals->g.pPersonList[uTemp].WuGong[uTempFlag1] = uTempFlag2;
				gpGlobals->g.pPersonList[uTemp].WuGongDengji[uTempFlag1] = uStartCode;
			}
			else
			{
				short iFind1 = -1;
				short iFind2 = -1;
				for(int i=0;i<10;i++)
				{
					if (gpGlobals->g.pPersonList[uTemp].WuGong[i] == uTempFlag2 && iFind1 == -1)
					{
						iFind1 = i;
					}
					if (gpGlobals->g.pPersonList[uTemp].WuGong[i] == 0 && iFind2 == -1)
					{
						iFind2 = i;
					}
				}
				if (iFind1 == -1)
				{
					if (iFind2 == -1)
					{
						//不能超过10种武功
						//for(int i=1;i<10;i++)
						//{
						//	gpGlobals->g.pPersonList[uTemp].WuGong[i-1] = gpGlobals->g.pPersonList[uTemp].WuGong[i];
						//	gpGlobals->g.pPersonList[uTemp].WuGongDengji[i-1] = gpGlobals->g.pPersonList[uTemp].WuGongDengji[i];
						//}
						//gpGlobals->g.pPersonList[uTemp].WuGong[9] = uTempFlag2;
						//gpGlobals->g.pPersonList[uTemp].WuGongDengji[9] = uStartCode;
					}
					else
					{
						gpGlobals->g.pPersonList[uTemp].WuGong[iFind2] = uTempFlag2;
						gpGlobals->g.pPersonList[uTemp].WuGongDengji[iFind2] = uStartCode;
					}
				}
				else
				{
					gpGlobals->g.pPersonList[uTemp].WuGong[iFind1] = uTempFlag2;
					gpGlobals->g.pPersonList[uTemp].WuGongDengji[iFind1] = uStartCode;
				}
			}
			iCur++;
			break;
		case 36://判断主角的性别(主角的性别,是转向偏移量,否转向偏移量) 
			uTemp = gpGlobals->g.pKdefList[wScriptEntry].pData[++iCur];
			uTempFlag1 = gpGlobals->g.pKdefList[wScriptEntry].pData[++iCur];
			uTempFlag2 = gpGlobals->g.pKdefList[wScriptEntry].pData[++iCur];
			iCur++;
			if (gpGlobals->g.pPersonList[0].sex == uTemp )
			{
				iCur+=uTempFlag1;
			}
			else
			{
				iCur+=uTempFlag2;
			}
			break;
		case 37://增加主角品德(数值) 
			uTemp = gpGlobals->g.pKdefList[wScriptEntry].pData[++iCur];
			JY_SetPersonStatus(enum_PinDe,0,uTemp,FALSE);
			JY_ReDrawMap();
			JY_ShowAttribAdd(0,enum_PinDe,uTemp);
			iCur++;
			break;
		case 38://修改场景贴图(场景编号,图层编号,原有贴图,修改后贴图)
			uSceneNum = gpGlobals->g.pKdefList[wScriptEntry].pData[++iCur];
			if (uSceneNum == -2) uSceneNum = gpGlobals->g.iSceneNum;
			uTemp = gpGlobals->g.pKdefList[wScriptEntry].pData[++iCur];
			uTempFlag1 = gpGlobals->g.pKdefList[wScriptEntry].pData[++iCur];
			uTempFlag2 = gpGlobals->g.pKdefList[wScriptEntry].pData[++iCur];
			for(int i=0;i<g_iSmapXMax-1;i++)
			{
				for(int j=0;j<g_iSMapYMax-1;j++)
				{
					if (JY_GetSMap(uSceneNum,i,j,uTemp) == uTempFlag1 )
					{
						JY_SetSMap(uSceneNum,i,j,uTemp,uTempFlag2);
					}
				}
			}
			iCur++;
			break;
		case 39://打开场景(场景编号)
			uSceneNum = gpGlobals->g.pKdefList[wScriptEntry].pData[++iCur];
			gpGlobals->g.pSceneTypeList[uSceneNum].InCondition = 0;
			iCur++;
			break;
		case 40://主角面向何方0上，1右，2左，3下
			uTemp = gpGlobals->g.pKdefList[wScriptEntry].pData[iCur + 1];
			gpGlobals->g.pBaseList->Way = uTemp;
			gpGlobals->g.iMyPic = JY_GetMyPic();
			JY_ReDrawMap();
			iCur+=2;
			break;
		case 41://非我方队员增加物品(人代号,物品编号,数量) 
			uTemp = gpGlobals->g.pKdefList[wScriptEntry].pData[++iCur];
			uTempFlag1 = gpGlobals->g.pKdefList[wScriptEntry].pData[++iCur];
			uTempFlag2 = gpGlobals->g.pKdefList[wScriptEntry].pData[++iCur];
			uTempFlag3 = -1;
			for(int i=0;i<4;i++)
			{
				if (gpGlobals->g.pPersonList[uTemp].XieDaiWuPin[i] == uTempFlag1)
				{
					uTempFlag3=i;
					gpGlobals->g.pPersonList[uTemp].XieDaiWuPinShuLiang[i] += uTempFlag2;
					break;
				}
			}
			if (uTempFlag3 >=0 && gpGlobals->g.pPersonList[uTemp].XieDaiWuPinShuLiang[uTempFlag3] <=0)
			{
				for(int i=uTempFlag3+1;i<4;i++)
				{
					gpGlobals->g.pPersonList[uTemp].XieDaiWuPin[i-1] = gpGlobals->g.pPersonList[uTemp].XieDaiWuPin[i];
					gpGlobals->g.pPersonList[uTemp].XieDaiWuPinShuLiang[i-1] = gpGlobals->g.pPersonList[uTemp].XieDaiWuPinShuLiang[i];
				}
				gpGlobals->g.pPersonList[uTemp].XieDaiWuPin[3] = -1;
				gpGlobals->g.pPersonList[uTemp].XieDaiWuPinShuLiang[3] = 0;
			}
			if (uTempFlag3 == -1)
			{
				for(int i=0;i<4;i++)
				{
					if (gpGlobals->g.pPersonList[uTemp].XieDaiWuPin[i] == -1)
					{
						gpGlobals->g.pPersonList[uTemp].XieDaiWuPin[i] = uTempFlag1;
						gpGlobals->g.pPersonList[uTemp].XieDaiWuPinShuLiang[i] = uTempFlag2;
						break;
					}
				}
			}
			iCur++;
			break;
		case 42://判断队里是否有女性(是转向偏移量,否转向偏移量) 
			uTempFlag1 = gpGlobals->g.pKdefList[wScriptEntry].pData[++iCur];
			uTempFlag2 = gpGlobals->g.pKdefList[wScriptEntry].pData[++iCur];
			iCur++;
			uTempFlag3 = -1;
			uTempFlag4 = -1;
			for(int i=0;i<6;i++)
			{
				uTempFlag3 = gpGlobals->g.pBaseList->Group[i];
				if (uTempFlag3 != -1)
				{
					if (gpGlobals->g.pPersonList[uTempFlag3].sex == 1)
					{
						uTempFlag4++;
					}
				}
			}
			if (uTempFlag4 >=0)
			{
				iCur+=uTempFlag1;
			}
			else
			{
				iCur+=uTempFlag2;
			}
			break;
		case 43://判断物品栏里是否有指定物品(物品编号,有转向偏移量,无转向偏移量)
			uTemp = gpGlobals->g.pKdefList[wScriptEntry].pData[++iCur];
			uTempFlag1 = gpGlobals->g.pKdefList[wScriptEntry].pData[++iCur];
			uTempFlag2 = gpGlobals->g.pKdefList[wScriptEntry].pData[++iCur];
			iCur++;
			if (JY_FindThing(uTemp) >=0)
			{
				iCur+=uTempFlag1;
			}
			else
			{
				iCur+=uTempFlag2;
			}
			break;
		case 44://同时显示两个动画(标志动画显示位置的场景事件编号,起始图,中止图，标志动画显示位置的场景事件编号,起始图,中止图)
			uSceneNum = gpGlobals->g.pKdefList[wScriptEntry].pData[++iCur];
			uStartCode = gpGlobals->g.pKdefList[wScriptEntry].pData[++iCur];
			uEndCode = gpGlobals->g.pKdefList[wScriptEntry].pData[++iCur];
			uEventNo = gpGlobals->g.pKdefList[wScriptEntry].pData[++iCur];
			uTempFlag1 = gpGlobals->g.pKdefList[wScriptEntry].pData[++iCur];
			uTempFlag2 = gpGlobals->g.pKdefList[wScriptEntry].pData[++iCur];

			if (uStartCode > 0 && uEndCode > 0)
			{
				short old1 = JY_GetD(gpGlobals->g.iSceneNum,uSceneNum,5);//gpGlobals->g.sceneEventList[gpGlobals->g.iSceneNum][uSceneNum].PicNum[0];
				short old2 = JY_GetD(gpGlobals->g.iSceneNum,uSceneNum,6);//gpGlobals->g.sceneEventList[gpGlobals->g.iSceneNum][uSceneNum].PicNum[1];
				short old3 = JY_GetD(gpGlobals->g.iSceneNum,uSceneNum,7);//gpGlobals->g.sceneEventList[gpGlobals->g.iSceneNum][uSceneNum].PicNum[2];
				short old4 = JY_GetD(gpGlobals->g.iSceneNum,uEventNo,5);//gpGlobals->g.sceneEventList[gpGlobals->g.iSceneNum][uEventNo].PicNum[0];
				short old5 = JY_GetD(gpGlobals->g.iSceneNum,uEventNo,6);//gpGlobals->g.sceneEventList[gpGlobals->g.iSceneNum][uEventNo].PicNum[1];
				short old6 = JY_GetD(gpGlobals->g.iSceneNum,uEventNo,7);//gpGlobals->g.sceneEventList[gpGlobals->g.iSceneNum][uEventNo].PicNum[2];
				JY_SetD(gpGlobals->g.iSceneNum,uSceneNum,5,uStartCode);//gpGlobals->g.sceneEventList[gpGlobals->g.iSceneNum][uSceneNum].PicNum[0] = uStartCode;
				JY_SetD(gpGlobals->g.iSceneNum,uSceneNum,6,uEndCode);//gpGlobals->g.sceneEventList[gpGlobals->g.iSceneNum][uSceneNum].PicNum[1] = uEndCode;
				JY_SetD(gpGlobals->g.iSceneNum,uSceneNum,7,uStartCode);//gpGlobals->g.sceneEventList[gpGlobals->g.iSceneNum][uSceneNum].PicNum[2] = uStartCode;
				JY_SetD(gpGlobals->g.iSceneNum,uEventNo,5,uTempFlag1);//gpGlobals->g.sceneEventList[gpGlobals->g.iSceneNum][uEventNo].PicNum[0] = uTempFlag1;
				JY_SetD(gpGlobals->g.iSceneNum,uEventNo,6,uTempFlag2);//gpGlobals->g.sceneEventList[gpGlobals->g.iSceneNum][uEventNo].PicNum[1] = uTempFlag2;
				JY_SetD(gpGlobals->g.iSceneNum,uEventNo,7,uTempFlag1);//gpGlobals->g.sceneEventList[gpGlobals->g.iSceneNum][uEventNo].PicNum[2] = uTempFlag1;
				for(int i=0;i<(uEndCode-uStartCode)/2;i++)
				{
					JY_ReDrawMap();
					SDL_Delay(100);
					JY_ShowSurface();
				}
				JY_SetD(gpGlobals->g.iSceneNum,uSceneNum,5,old1);//gpGlobals->g.sceneEventList[gpGlobals->g.iSceneNum][uSceneNum].PicNum[0] = old1;
				JY_SetD(gpGlobals->g.iSceneNum,uSceneNum,6,old2);//gpGlobals->g.sceneEventList[gpGlobals->g.iSceneNum][uSceneNum].PicNum[1] = old2;
				JY_SetD(gpGlobals->g.iSceneNum,uSceneNum,7,old3);//gpGlobals->g.sceneEventList[gpGlobals->g.iSceneNum][uSceneNum].PicNum[2] = old3;
				JY_SetD(gpGlobals->g.iSceneNum,uEventNo,5,old4);//gpGlobals->g.sceneEventList[gpGlobals->g.iSceneNum][uEventNo].PicNum[0] = old4;
				JY_SetD(gpGlobals->g.iSceneNum,uEventNo,6,old5);//gpGlobals->g.sceneEventList[gpGlobals->g.iSceneNum][uEventNo].PicNum[1] = old5;
				JY_SetD(gpGlobals->g.iSceneNum,uEventNo,7,old6);//gpGlobals->g.sceneEventList[gpGlobals->g.iSceneNum][uEventNo].PicNum[2] = old6;
			}

			iCur++;
			break;
		case 45://增加轻功(人代号,数值) 
			uTempFlag1 = gpGlobals->g.pKdefList[wScriptEntry].pData[++iCur];
			uTempFlag2 = gpGlobals->g.pKdefList[wScriptEntry].pData[++iCur];
			JY_SetPersonStatus(enum_QingGong,uTempFlag1,uTempFlag2,FALSE);
			JY_ReDrawMap();
			JY_ShowAttribAdd(uTempFlag1,enum_QingGong,uTempFlag2);
			iCur++;
			break;
		case 46://增加内力(人代号,数值) 
			uTempFlag1 = gpGlobals->g.pKdefList[wScriptEntry].pData[++iCur];
			uTempFlag2 = gpGlobals->g.pKdefList[wScriptEntry].pData[++iCur];
			JY_SetPersonStatus(enum_NeiliMax,uTempFlag1,uTempFlag2,FALSE);
			JY_ReDrawMap();
			//JY_ShowAttribAdd(uTempFlag1,enum_NeiliMax,uTempFlag2);
			//WB20090717事件中内力增加不受最大值限制
			if (uTempFlag1 >=0)
			{
				gpGlobals->g.pPersonList[uTempFlag1].NeiliMax +=uTempFlag2;
				gpGlobals->g.pPersonList[uTempFlag1].Neili +=uTempFlag2;
			}
			iCur++;
			break;
		case 47://增加武力(人代号,数值) 
			uTempFlag1 = gpGlobals->g.pKdefList[wScriptEntry].pData[++iCur];
			uTempFlag2 = gpGlobals->g.pKdefList[wScriptEntry].pData[++iCur];
			JY_SetPersonStatus(enum_GongJiLi,uTempFlag1,uTempFlag2,FALSE);
			JY_ReDrawMap();
			JY_ShowAttribAdd(uTempFlag1,enum_GongJiLi,uTempFlag2);
			iCur++;
			break;
		case 48://增加生命(人代号,数值) 
			uTempFlag1 = gpGlobals->g.pKdefList[wScriptEntry].pData[++iCur];
			uTempFlag2 = gpGlobals->g.pKdefList[wScriptEntry].pData[++iCur];
			JY_SetPersonStatus(enum_hpMax,uTempFlag1,uTempFlag2,FALSE);
			JY_ReDrawMap();
			//JY_ShowAttribAdd(uTempFlag1,enum_hpMax,uTempFlag2);7
			//WB20090717事件中生命增加不受最大值限制
			if (uTempFlag1 >=0)
			{
				gpGlobals->g.pPersonList[uTempFlag1].hpMax +=uTempFlag2;
				gpGlobals->g.pPersonList[uTempFlag1].hp +=uTempFlag2;
			}
			iCur++;
			break;
		case 49://设置内力属性(人代号,数值) 
			uTempFlag1 = gpGlobals->g.pKdefList[wScriptEntry].pData[++iCur];
			uTempFlag2 = gpGlobals->g.pKdefList[wScriptEntry].pData[++iCur];
			JY_SetPersonStatus(enum_NeiliXingZhi,uTempFlag1,uTempFlag2,TRUE);
			iCur++;
			break;
		case 50://判断物品栏里是否有指定的5种物品(物品编号,物品编号,物品编号,物品编号,物品编号,有转向偏移量,无转向偏移量)
			uTempFlag1 = gpGlobals->g.pKdefList[wScriptEntry].pData[++iCur];
			uTempFlag2 = gpGlobals->g.pKdefList[wScriptEntry].pData[++iCur];
			uTempFlag3 = gpGlobals->g.pKdefList[wScriptEntry].pData[++iCur];
			uTempFlag4 = gpGlobals->g.pKdefList[wScriptEntry].pData[++iCur];
			uTempFlag5 = gpGlobals->g.pKdefList[wScriptEntry].pData[++iCur];
			uStartCode = gpGlobals->g.pKdefList[wScriptEntry].pData[++iCur];
			uEndCode = gpGlobals->g.pKdefList[wScriptEntry].pData[++iCur];
			iCur++;
			uTemp = 0;
			if (g_iuse50 == 0)
			{
				if (JY_FindThing(uTempFlag1) >=0)
					uTemp++;
				if (JY_FindThing(uTempFlag2) >=0)
					uTemp++;
				if (JY_FindThing(uTempFlag3) >=0)
					uTemp++;
				if (JY_FindThing(uTempFlag4) >=0)
					uTemp++;
				if (JY_FindThing(uTempFlag5) >=0)
					uTemp++;
				if (uTemp == 5)
				{
					iCur+=uStartCode;
				}
				else
				{
					iCur+=uEndCode;
				}
			}
			else
			{
				//MOD50指令
				JY_Use50(uTempFlag1,uTempFlag2,uTempFlag3,uTempFlag4,uTempFlag5,uStartCode,uEndCode);
			}
			break;
		case 51://问软体娃娃
			srand((unsigned)SDL_GetTicks());
			uTemp = 2547 + rand() % 19;
			uTempFlag1 = 114;
			uTempFlag2 = 0;
			if (uTemp <= 2564)
				JY_DrawTalkDialog(uTemp,uTempFlag1,uTempFlag2);
			else if (uTemp == 2565)
			{
				if (gpGlobals->g.pPersonList[0].WuGongDengji[0] < 900 && g_iSuper ==1)
				{
					if (gpGlobals->g.iHaveThingsNum <=4)
					{
						JY_DrawTextDialog("才来你就搞这,算了,拉你一把",JY_XY(g_wInitialWidth/2,g_iFontSize),TRUE,TRUE,TRUE);
						JY_ReDrawMap();
						gpGlobals->g.pPersonList[0].WuGongDengji[0] = 900;
						JY_DrawTextDialog("你的武功升级了...",JY_XY(g_wInitialWidth/2,g_iFontSize),TRUE,TRUE,TRUE);
						JY_ReDrawMap();
					}
					else
					{
						JY_DrawTextDialog("看你这么不容易的份上,回报你一下",JY_XY(g_wInitialWidth/2,g_iFontSize),TRUE,TRUE,TRUE);
						JY_ReDrawMap();
						gpGlobals->g.pPersonList[0].WuGongDengji[0] += 100;
						JY_DrawTextDialog("你的武功升级了...",JY_XY(g_wInitialWidth/2,g_iFontSize),TRUE,TRUE,TRUE);
						JY_ReDrawMap();
					}
				}
			}
			iCur+=1;
			break;
		case 52:
			JY_ReDrawMap();
			pChar = va("道德%d",gpGlobals->g.pPersonList[0].PinDe);
			JY_DrawTextDialog(pChar,JY_XY(g_wInitialWidth/2,g_iFontSize),TRUE,TRUE,TRUE);
			SafeFree(pChar);
			iCur+=1;
			break;
		case 53:
			JY_ReDrawMap();
			pChar = va("声望%d",gpGlobals->g.pPersonList[0].ShengWang);
			JY_DrawTextDialog(pChar,JY_XY(g_wInitialWidth/2,10),TRUE,TRUE,TRUE);
			SafeFree(pChar);
			iCur+=1;
			break;
		case 54://见过南贤后可以进入各场景 
			SetSceneInStatus(-1);
			iCur+=1;
			break;
		case 55://判断事件编号(场景事件编号,给定编号,是偏移,否偏移) 判断当前场景事件编号的事件1(空格触发)是否为给定事件编号
			uSceneNum = gpGlobals->g.iSceneNum;
			uEventNo = gpGlobals->g.pKdefList[wScriptEntry].pData[++iCur];
			uTemp = gpGlobals->g.pKdefList[wScriptEntry].pData[++iCur];
			uTempFlag1 = gpGlobals->g.pKdefList[wScriptEntry].pData[++iCur];
			uTempFlag2 = gpGlobals->g.pKdefList[wScriptEntry].pData[++iCur];
			iCur++;
			if (JY_GetD(uSceneNum,uEventNo,2) == uTemp)//if (gpGlobals->g.sceneEventList[uSceneNum][uEventNo].EventNum1 == uTemp)
			{
				iCur+=uTempFlag1;
			}
			else
			{
				iCur+=uTempFlag2;
			}
			break;
		case 56://增加声望(数值) 若拿到14天书并且声望大于200，则主角家里出现武林贴(程序中调用指令3)
			uTemp = gpGlobals->g.pKdefList[wScriptEntry].pData[++iCur];
			JY_SetPersonStatus(enum_ShengWang,0,uTemp,FALSE);
			JY_CheckBook();
			JY_ReDrawMap();
			JY_ShowAttribAdd(0,enum_ShengWang,uTemp);
			iCur++;
			break;
		case 57://主角在高昌迷宫砍石门的动画 
			JY_GaoChangMiGong();
			iCur++;
			break;
		case 58://武道大会比武 
			JY_WuDaoDaHui();
			iCur++;
			break;
		case 59://全部队员离队并找不到 所有队员先离队，然后清除全部离队人员的事件，所有人从此找不着。
			iCur++;
			JY_AllPersonExit();
			break;
		case 60://判断场景事件图块(场景,场景事件编号,某地一幅图块,是偏移,否偏移)
			uSceneNum = gpGlobals->g.pKdefList[wScriptEntry].pData[++iCur];
			if (uSceneNum == -2) uSceneNum = gpGlobals->g.iSceneNum;
			uEventNo = gpGlobals->g.pKdefList[wScriptEntry].pData[++iCur];
			if (uEventNo == -2) uEventNo = gpGlobals->g.iSceneEventCode;
			uTemp = gpGlobals->g.pKdefList[wScriptEntry].pData[++iCur];
			uTempFlag1 = gpGlobals->g.pKdefList[wScriptEntry].pData[++iCur];
			uTempFlag2 = gpGlobals->g.pKdefList[wScriptEntry].pData[++iCur];
			iCur++;
			if (JY_GetD(uSceneNum,uEventNo,5) == uTemp)//if (gpGlobals->g.sceneEventList[uSceneNum][uEventNo].PicNum[0] == uTemp)
			{
				iCur+=uTempFlag1;
			}
			else
			{
				iCur+=uTempFlag2;
			}
			break;
		case 61://判断是否放完14本书？(是偏移,否偏移) 
			uTempFlag1 = gpGlobals->g.pKdefList[wScriptEntry].pData[++iCur];
			uTempFlag2 = gpGlobals->g.pKdefList[wScriptEntry].pData[++iCur];
			iCur++;
			uSceneNum = gpGlobals->g.iSceneNum;
			uTemp = 1;
			for(int i=11;i<25;i++)
			{
				if (JY_GetD(uSceneNum,i,5) != g_iBookPutImg*2)//if (gpGlobals->g.sceneEventList[uSceneNum][i].PicNum[0] != 4664)
					uTemp = 0;
			}
			if (uTemp == 1)
			{
				iCur+=uTempFlag1;
			}
			else
			{
				iCur+=uTempFlag2;
			}
			break;
		case 62://播放进入时空机动画".游戏结束 
			iCur++;
			JY_END();
			JY_FillColor(0,0,0,0,0);
			OGG_Play(0,FALSE);
			OGG_Play(24, TRUE);
			JY_DrawTextDialog("大侠终于回家了，呱唧呱唧",JY_XY(g_wInitialWidth / 2,g_wInitialHeight/2),FALSE,TRUE,TRUE);
			fEnded = TRUE;
			gpGlobals->g.Status = -1;
			break;
		case 63://设置性别(人代号,数值) 
			uTempFlag1 = gpGlobals->g.pKdefList[wScriptEntry].pData[++iCur];
			uTempFlag2 = gpGlobals->g.pKdefList[wScriptEntry].pData[++iCur];
			JY_SetPersonStatus(enum_sex,uTempFlag1,uTempFlag2,FALSE);
			iCur++;
			break;
		case 64://韦小宝卖东西
			JY_Shop();
			iCur++;
			break;
		case 65://韦小宝去其它客栈
			JY_ShopMove();
			iCur++;
			break;
		case 66://播放音乐(音乐编号)
			uTemp = gpGlobals->g.pKdefList[wScriptEntry].pData[iCur + 1];
			OGG_Play(0, FALSE);
			OGG_Play(uTemp, TRUE);
			iCur+=2;
			break;
		case 67://播放声音
			uTemp = gpGlobals->g.pKdefList[wScriptEntry].pData[iCur + 1];
			SOUND_PlayChannel(uTemp,0,0);
			iCur+=2;
			break;
		default:
			fEnded = TRUE;
		case -1://结束
			fEnded = TRUE;
			break;

		}
		
	}
	gpGlobals->g.iSceneEventCode = -1;
	return 0;
}