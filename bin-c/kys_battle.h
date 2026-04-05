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

    void SA_0();
    void SA_1();
    void SA_2();
    void SA_3();
    void SA_4();
    void SA_5();
    void SA_6();
    void SA_7();
    void SA_8();
    void SA_9();
    void SA_10();
    void SA_11();
    void SA_12();
    void SA_13();
    void SA_14();
    void SA_15();
    void SA_16();
    void SA_17();
    void SA_18();
    void SA_19();
    void SA_20();
    void SA_21();
    void SA_22();
    void SA_23();
    void SA_24();
    void SA_25();
    void SA_26();
    void SA_27();
    void SA_28();
    void SA_29();
    void SA_30();
    void SA_31();
    void SA_32();
    void SA_33();
    void SA_34();
    void SA_35();
    void SA_36();
    void SA_37();
    void SA_38();
};

class TSpecialAbility2
{
public:
    int bnum = 0;
    int rnum = 0;
    int anum = 0;

    void SA2_0();
    void SA2_1();
    void SA2_2();
    void SA2_3();
    void SA2_4();
    void SA2_5();
    void SA2_6();
    void SA2_7();
    void SA2_8();
    void SA2_9();
    void SA2_10();
    void SA2_11();
    void SA2_12();
    void SA2_100();
    void SA2_101();
    void SA2_102();
    void SA2_103();
};

// ---- 战斗主要函数 ----

// 战斗入口
int Battle(int battlenum, int getexp = 0, int forceSingle = 0);
int getBnum(int rnum);

// 初始化
void LoadBattleTiles();
void FreeBattleTiles();
void InitialBField();
void InitialBRole();
void SelectTeamMembers();

// 战斗控制
void BattleMainControl();
void CalBroleMoveAbility(int bnum);
void CalMoveAbility(int bnum, int step);
void ReArrangeBRole();
void BattleStatus(int bnum);
void BattleMenu(int bnum);

// 面向与距离
int CalFace(int x1, int y1, int x2, int y2);
void CalFace(int bnum1, int bnum2);
int CalBroleDistance(int bnum1, int bnum2);

// 移动
void MoveRole(int bnum, int x, int y);
void MoveAmination(int bnum, int x1, int y1, int x2, int y2);
void SeekPath2(int bnum, int ex, int ey);

// 目标选择
void SelectShowStatus(int bnum);
int SelectAim(int bnum, int mnum);
void SelectRange(int bnum, int step, int* list = nullptr, int* count = nullptr);
void SelectDirector(int bnum, int mnum);
void SelectCross(int bnum, int step);
void SelectFar(int bnum, int step);
int CalCanSelect(int bnum, int mnum);
bool CanSelectAim(int bnum, int mnum, int ax, int ay);

// 魔法/武功
void ShowMagicName(int mnum);
int SelectMagic(int bnum);
void SetAminationPosition(int bnum, int mnum);
void SetAminationPosition(int bnum, int mnum, int ax, int ay);
void PlayMagicAmination(int bnum, int mnum);
void PlayActionAmination(int bnum, int action);

// 伤害计算
void CalHurtRole(int bnum, int mnum);
int CalHurtValue(int bnum1, int bnum2, int mnum);
int CalHurtValue(int bnum1, int mnum);
void SelectColor(int& color, int value);
void ShowHurtValue(int bnum);
void ShowStringOnBrole(int bnum, const std::string& str, uint32 color);
int CalPoiHurtLife(int bnum1, int bnum2, int mnum);
void ClearDeadRolePic();

// 战斗效果
void Wait(int bnum, int time = 0);
void RestoreRoleStatus(int bnum);
void AddExp(int bnum, int exp);
void CheckLevelUp(int bnum);
void LevelUp(int bnum);
void CheckBook(int bnum);
int CalRNum(int bnum);

// 战斗菜单
void BattleMenuItem(int bnum);
void UsePoison(int bnum, int mnum);
void Medcine(int bnum, int mnum);
void MedPoison(int bnum, int target);
void UseHiddenWeapon(int bnum);
void Rest(int bnum);
void GiveUp(int bnum);

// AI系统
void AutoBattle(int bnum);
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
