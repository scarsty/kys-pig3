#pragma once
// kys_battle.h - 战斗系统
// 对应 kys_battle.pas

#include "kys_type.h"
#include <string>

// ---- 特殊能力类 ----

class TSpecialAbility
{
public:
    int bnum = 0;
    int mnum = 0;
    int rnum = 0;

    void SA_0(int bnum, int mnum, int level);
    void SA_1(int bnum, int mnum, int level);
    void SA_2(int bnum, int mnum, int level);
    void SA_3(int bnum, int mnum, int level);
    void SA_4(int bnum, int mnum, int level);
    void SA_5(int bnum, int mnum, int level);
    void SA_6(int bnum, int mnum, int level);
    void SA_7(int bnum, int mnum, int level);
    void SA_8(int bnum, int mnum, int level);
    void SA_9(int bnum, int mnum, int level);
    void SA_10(int bnum, int mnum, int level);
    void SA_11(int bnum, int mnum, int level);
    void SA_12(int bnum, int mnum, int level);
    void SA_13(int bnum, int mnum, int level);
    void SA_14(int bnum, int mnum, int level);
    void SA_15(int bnum, int mnum, int level);
    void SA_16(int bnum, int mnum, int level);
    void SA_17(int bnum, int mnum, int level);
    void SA_18(int bnum, int mnum, int level);
    void SA_19(int bnum, int mnum, int level);
    void SA_20(int bnum, int mnum, int level);
    void SA_21(int bnum, int mnum, int level);
    void SA_22(int bnum, int mnum, int level);
    void SA_23(int bnum, int mnum, int level);
    void SA_24(int bnum, int mnum, int level);
    void SA_25(int bnum, int mnum, int level);
    void SA_26(int bnum, int mnum, int level);
    void SA_27(int bnum, int mnum, int level);
    void SA_28(int bnum, int mnum, int level);
    void SA_29(int bnum, int mnum, int level);
    void SA_30(int bnum, int mnum, int level);
    void SA_31(int bnum, int mnum, int level);
    void SA_32(int bnum, int mnum, int level);
    void SA_33(int bnum, int mnum, int level);
    void SA_34(int bnum, int mnum, int level);
    void SA_35(int bnum, int mnum, int level);
    void SA_36(int bnum, int mnum, int level);
    void SA_37(int bnum, int mnum, int level);
    void SA_38(int bnum, int mnum, int level);
};

class TSpecialAbility2
{
public:
    int bnum = 0;
    int rnum = 0;
    int anum = 0;

    void SA2_0(int bnum, int mnum, int mnum2, int level);
    void SA2_1(int bnum, int mnum, int mnum2, int level);
    void SA2_2(int bnum, int mnum, int mnum2, int level);
    void SA2_3(int bnum, int mnum, int mnum2, int level);
    void SA2_4(int bnum, int mnum, int mnum2, int level);
    void SA2_5(int bnum, int mnum, int mnum2, int level);
    void SA2_6(int bnum, int mnum, int mnum2, int level);
    void SA2_7(int bnum, int mnum, int mnum2, int level);
    void SA2_8(int bnum, int mnum, int mnum2, int level);
    void SA2_9(int bnum, int mnum, int mnum2, int level);
    void SA2_10(int bnum, int mnum, int mnum2, int level);
    void SA2_11(int bnum, int mnum, int mnum2, int level);
    void SA2_12(int bnum, int mnum, int mnum2, int level);
    void SA2_100(int bnum, int mnum, int mnum2, int level);
    void SA2_101(int bnum, int mnum, int mnum2, int level);
    void SA2_102(int bnum, int mnum, int mnum2, int level);
    void SA2_103(int bnum, int mnum, int mnum2, int level);
};

// ---- 战斗主要函数 ----

// 战斗入口
bool Battle(int battlenum, int getexp = 0, int forceSingle = 0);
int getBnum(int rnum);

// 初始化
void LoadBattleTiles();
void FreeBattleTiles();
bool InitialBField();
void InitialBRole(int i, int rnum, int team, int x, int y);
int SelectTeamMembers(int forceSingle = 0);

// 战斗控制
void BattleMainControl();
int CalBroleMoveAbility(int bnum);
void CalMoveAbility();
void ReArrangeBRole();
int BattleStatus();
int BattleMenu(int bnum);

// 面向与距离
int CalFace(int x1, int y1, int x2, int y2);
int CalFace(int bnum1, int bnum2);
int CalBroleDistance(int bnum1, int bnum2);

// 移动
void MoveRole(int bnum);
bool MoveAmination(int bnum);
void SeekPath2(int x, int y, int step, int myteam, int mode, int bnum);

// 目标选择
bool SelectShowStatus(int bnum);
bool SelectAim(int bnum, int step);
bool SelectRange(int bnum, int AttAreaType, int step, int range);
bool SelectDirector(int bnum, int AttAreaType, int step, int range);
bool SelectCross(int bnum, int AttAreaType, int step, int range);
bool SelectFar(int bnum, int mnum, int level);
void CalCanSelect(int bnum, int mode, int step);
bool CanSelectAim(int bnum, int aimbnum, int mnum, int aimMode);

// 攻击
void Attack(int bnum);
void AttackAction(int bnum, int i, int mnum, int level);
void AttackAction(int bnum, int mnum, int level);
void ModifyRange(int bnum, int mnum, int& step, int& range);

// 魔法/武功
void ShowMagicName(int mnum, const std::string& str = "");
int SelectMagic(int rnum);
void SetAminationPosition(int mode, int step, int range, int aimMode);
void SetAminationPosition(int bx, int by, int ax, int ay, int mode, int step, int range, int aimMode);
void PlayMagicAmination(int bnum, int eNum, int aimMode = 0, int mode = 0);
void PlayActionAmination(int bnum, int mode);

// 伤害计算
void CalHurtRole(int bnum, int mnum, int level, int mode);
int CalHurtValue(int bnum1, int bnum2, int mnum, int level, int mode);
int CalHurtValue2(int bnum1, int bnum2, int mnum, int level, int mode);
void SelectColor(int mode, uint32& color1, uint32& color2, std::string& formatstr);
void ShowHurtValue(int mode, int team = 0, const std::string& fstr = "");
void ShowStringOnBrole(const std::string& str, int bnum, int mode = 0, int up = 0);
void CalPoiHurtLife();
void ClearDeadRolePic();

// 战斗效果
void Wait(int bnum);
void RestoreRoleStatus();
void AddExp();
void CheckLevelUp();
void LevelUp(int bnum, int rnum);
void CheckBook();
int CalRNum(int team);

// 战斗菜单
void BattleMenuItem(int bnum);
void UsePoison(int bnum);
void Medcine(int bnum);
void MedPoison(int bnum);
void UseHiddenWeapon(int bnum, int inum = 0);
void Rest(int bnum);
void GiveUp(int bnum);

// 回合管理
void RoundOver();
void RoundOver(int bnum);

// AI系统
void AutoBattle(int bnum);
void AutoBattle2(int bnum);
void AutoBattle3(int bnum);
void Auto(int bnum);
bool AutoUseItem(int bnum, int list, int test = 0);
bool SelectAutoMode();
void TryMoveAttack(int& Mx1, int& My1, int& Ax1, int& Ay1, int& tempmaxhurt, int bnum, int mnum, int level);
void NearestMove(int& Mx1, int& My1, int bnum);
void FarthestMove(int& Mx1, int& My1, int bnum);
void NearestMoveByPro(int& Mx1, int& My1, int& Ax1, int& Ay1, int bnum, int TeamMate, int KeepDis, int Prolist, int MaxMinPro, int mode);
bool ProbabilityByValue(int cur, int m, int mode, int& n);
void TryAttack(int& Ax1, int& Ay1, int& magicid, int& cmlevel, int Mx, int My, int bnum);
void TryMoveCure(int& Mx1, int& My1, int& Ax1, int& Ay1, int bnum);
void CureAction(int bnum);
void SetEnemyAttribute();

// 特殊能力
bool UseSpecialAbility(int bnum, int mnum, int level);
bool SpecialAttack(int bnum);
int16_t GetMagicWithSA2(int16_t SANum);
void CheckAttackAttachment(int bnum, int mnum, int level);
void CheckDefenceAttachment(int bnum, int mnum, int level);

// 状态与辅助
void ModifyState(int bnum, int statenum, int16_t MaxValue, int16_t maxround);
void GiveMeLife(int bnum, int mnum, int level, int Si);
void ambush(int bnum, int mnum, int level, int Si);
int IFinbattle(int num);
void AutoBattle2(int bnum);
void AutoBattle3(int bnum);
void TryMoveAttack(int bnum);
void NearestMove(int bnum, int target);
void FarthestMove(int bnum, int target);
void NearestMoveByPro(int bnum);
int ProbabilityByValue(int value);
void TryAttack(int bnum, int mnum);
void TryMoveCure(int bnum);
void CureAction(int bnum);
void RoundOver();
void RoundOver(int bnum);
void SelectAutoMode(int bnum);
void Auto(int bnum);

// 特殊能力
void SetEnemyAttribute();
int IFinbattle(int rnum);
void UseSpecialAbility(int bnum, int mnum);
void SpecialAttack(int bnum, int mnum);
int GetMagicWithSA2(int bnum);
void CheckAttackAttachment(int bnum1, int bnum2, int mnum, int& hurt);
void CheckDefenceAttachment(int bnum1, int bnum2, int mnum, int& hurt);
