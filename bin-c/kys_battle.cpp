// kys_battle.cpp - 战斗系统实现
// 对应 kys_battle.pas

#include "kys_battle.h"
#include "kys_type.h"
#include "kys_main.h"
#include "kys_engine.h"
#include "kys_draw.h"
#include "kys_event.h"
#include "kys_script.h"

#include <SDL3/SDL.h>
#include <algorithm>
#include <cmath>
#include <cstring>
#include <cstdlib>

// 内部变量
static TSpecialAbility SA;
static TSpecialAbility2 SA2;

// 寻路相关
static int MoveList[64][64];
static int AttackList[64][64];

//----------------------------------------------------------------------
// Battle - 战斗主函数
//----------------------------------------------------------------------
bool Battle(int battlenum, int getexp, int forceSingle)
{
    Bstatus = 0;
    BattleRound = 1;
    SkipTalk = 0;
    CurrentBattle = battlenum;
    memset(Brole, 0, sizeof(TBattleRole) * MAX_BATTLE_ROLE);

    bool autoselect = InitialBField();

    Redraw();
    TransBlackScreen();

    std::string str;
    if (battlenum >= 0 && battlenum < (int)BattleNames.size())
        str = BattleNames[battlenum];
    DrawTextWithRect(str, CENTER_X - DrawLength(str) * 5 - 24, CENTER_Y - 150, 0, ColColor(0x14), ColColor(0x16));
    UpdateAllScreen();

    if (autoselect)
    {
        int SelectTeamList = SelectTeamMembers(forceSingle);
        for (int i = 0; i < 6; i++)
        {
            int x = WarStaList[battlenum].TeamX[i];
            int y = WarStaList[battlenum].TeamY[i];
            if (SelectTeamList & (1 << i))
            {
                InitialBRole(BRoleAmount, TeamList[i], 0, x, y);
                BRoleAmount++;
            }
        }
    }

    if (MODVersion == 13)
        if (CurrentBattle != 178)
            SetEnemyAttribute();

    LoadBattleTiles();
    Where = 2;

    Bx = Brole[0].X;
    By = Brole[0].Y;

    BattleMainControl();

    Where = 1;
    FreeBattleTiles();

    bool result = (Bstatus == 1);
    if (result && getexp > 0)
    {
        AddExp();
        CheckLevelUp();
        CheckBook();
    }
    RestoreRoleStatus();
    return result;
}

int getBnum(int rnum)
{
    for (int i = 0; i < BRoleAmount; i++)
        if (Brole[i].rnum == rnum) return i;
    return -1;
}

void LoadBattleTiles()
{
    // TODO: 加载战场贴图
}

void FreeBattleTiles()
{
    // TODO: 释放战场贴图
}

bool InitialBField()
{
    BRoleAmount = 0;
    // 从WarStaList加载战场数据
    if (CurrentBattle < 0 || CurrentBattle >= 401) return true;

    TWarData& w = WarStaList[CurrentBattle];
    // 初始化敌方角色
    for (int i = 0; i < 20; i++)
    {
        if (w.EnemyX[i] >= 0 && w.EnemyY[i] >= 0 && w.Enemy[i] >= 0)
        {
            InitialBRole(BRoleAmount, w.Enemy[i], 1, w.EnemyX[i], w.EnemyY[i]);
            BRoleAmount++;
        }
    }
    return true;
}

void InitialBRole(int i, int rnum, int team, int x, int y)
{
    if (i >= MAX_BATTLE_ROLE) return;
    memset(&Brole[i], 0, sizeof(TBattleRole));
    Brole[i].rnum = rnum;
    Brole[i].Team = team;
    Brole[i].X = x;
    Brole[i].Y = y;
    Brole[i].Face = (team == 0) ? 1 : 2;
    Brole[i].Dead = 0;
    Brole[i].Auto = (team == 0) ? 0 : 1;
    Brole[i].Acted = 0;
    Brole[i].ShowNumber = 0;
    Brole[i].Step = 0;

    if (rnum >= 0 && rnum < 1000)
    {
        Brole[i].rnum = rnum;
        // 从角色数据复制战斗属性
        TRole& r = Rrole[rnum + 1];
        Brole[i].Pic = r.Data[14];  // WalkPic
    }
}

int SelectTeamMembers(int forceSingle)
{
    // TODO: 选择上场队员
    // 简化: 全部上场
    int result = 0;
    for (int i = 0; i < 6; i++)
        if (TeamList[i] >= 0) result |= (1 << i);
    return result;
}

int CalFace(int x1, int y1, int x2, int y2)
{
    int dx = x2 - x1, dy = y2 - y1;
    if (abs(dx) >= abs(dy))
        return (dx > 0) ? 3 : 0;
    else
        return (dy > 0) ? 1 : 2;
}

int CalFace(int bnum1, int bnum2)
{
    return CalFace(Brole[bnum1].X, Brole[bnum1].Y, Brole[bnum2].X, Brole[bnum2].Y);
}

int CalBroleDistance(int bnum1, int bnum2)
{
    return abs(Brole[bnum1].X - Brole[bnum2].X) + abs(Brole[bnum1].Y - Brole[bnum2].Y);
}

//----------------------------------------------------------------------
// BattleMainControl - 战斗主控制循环
//----------------------------------------------------------------------
void BattleMainControl()
{
    while (Bstatus == 0)
    {
        CalMoveAbility();
        ReArrangeBRole();

        for (int i = 0; i < BRoleAmount; i++)
        {
            if (Brole[i].Dead != 0) continue;
            if (Brole[i].Acted != 0) continue;

            Bx = Brole[i].X;
            By = Brole[i].Y;

            Redraw();
            UpdateAllScreen();

            if (Brole[i].Auto == 0)
                BattleMenu(i);
            else
                AutoBattle(i);

            Bstatus = BattleStatus();
            if (Bstatus != 0) break;
        }

        if (Bstatus == 0)
        {
            CalPoiHurtLife();
            ClearDeadRolePic();
            Bstatus = BattleStatus();
            RoundOver();
            BattleRound++;
        }
    }
}

int CalBroleMoveAbility(int bnum)
{
    if (bnum < 0 || bnum >= BRoleAmount) return 0;
    int rnum = Brole[bnum].rnum;
    if (rnum < 0 || rnum >= 1000) return 3;
    int step = Rrole[rnum].Movestep;
    int result = step / 10;
    if (result > 15)
        result = 15;
    result = result + Brole[bnum].StateLevel[3] + Brole[bnum].loverlevel[2]
        + Ritem[Rrole[rnum].Equip[1]].AddMove + Ritem[Rrole[rnum].Equip[0]].AddMove;
    if (SEMIREAL == 1 && result > 7)
        result = 7;
    return result;
}

void CalMoveAbility()
{
    int maxRealspeed = 1;
    for (int i = 0; i < BRoleAmount; i++)
    {
        int rnum = Brole[i].rnum;
        if (SEMIREAL == 1 && Brole[i].Dead == 0)
        {
            Brole[i].RealSpeed = (int)(Rrole[rnum].Speed + 100) - Rrole[rnum].Hurt / 10 - Rrole[rnum].Poison / 30;
            maxRealspeed = std::max(maxRealspeed, Brole[i].RealSpeed);
        }
    }
    for (int i = 0; i < BRoleAmount; i++)
    {
        Brole[i].RealSpeed = (int)(Brole[i].RealSpeed * 200.0 / maxRealspeed);
    }
    for (int i = 0; i < BRoleAmount; i++)
        Brole[i].Step = CalBroleMoveAbility(i);
}

void ReArrangeBRole()
{
    // TODO: 按速度排序
    for (int i = 0; i < BRoleAmount; i++)
        Brole[i].Acted = 0;
}

int BattleStatus()
{
    bool teamAlive = false, enemyAlive = false;
    for (int i = 0; i < BRoleAmount; i++)
    {
        if (Brole[i].Dead != 0) continue;
        if (Brole[i].Team == 0) teamAlive = true;
        else enemyAlive = true;
    }
    if (!enemyAlive) return 1;  // 胜利
    if (!teamAlive) return 2;   // 失败
    return 0;
}

int BattleMenu(int bnum)
{
    std::string menuStr[] = { "移動", "攻擊", "用毒", "解毒", "醫療", "物品", "等待", "狀態" };
    int menu = CommonMenu(CENTER_X - 60, CENTER_Y - 100, 80, 7, 0, menuStr, 8);
    switch (menu)
    {
    case 0: MoveRole(bnum); break;
    case 1: Attack(bnum); break;
    case 2: UsePoison(bnum); break;
    case 3: MedPoison(bnum); break;
    case 4: Medcine(bnum); break;
    case 5: BattleMenuItem(bnum); break;
    case 6: Wait(bnum); break;
    case 7: SelectShowStatus(bnum); break;
    default: break;
    }
    Brole[bnum].Acted = 1;
    return menu;
}

void MoveRole(int bnum)
{
    CalCanSelect(bnum, 0, Brole[bnum].Step);
    SelectAimMode = 4;
    if (SelectAim(bnum, Brole[bnum].Step))
    {
        MoveAmination(bnum);
    }
}

bool MoveAmination(int bnum)
{
    // TODO: 移动动画
    return true;
}

bool SelectShowStatus(int bnum) { return false; /* TODO */ }
bool SelectAim(int bnum, int step) { return false; /* TODO */ }
bool SelectRange(int bnum, int AttAreaType, int step, int range) { return false; /* TODO */ }
bool SelectDirector(int bnum, int AttAreaType, int step, int range) { return false; /* TODO */ }
bool SelectCross(int bnum, int AttAreaType, int step, int range) { return false; /* TODO */ }
bool SelectFar(int bnum, int mnum, int level) { return false; /* TODO */ }

void SeekPath2(int x, int y, int step, int myteam, int mode, int bnum)
{
    // BFS寻路
    if (step <= 0) return;
    if (x < 0 || y < 0 || x >= 64 || y >= 64) return;
    // TODO: 完整BFS
}

void CalCanSelect(int bnum, int mode, int step)
{
    if (mode == 0 || mode == 3)
    {
        memset(&BField[3][0][0], -1, 4096 * 2);
        memset(&BField[7][0][0], 0, 4096 * 2);
        if (Brole[bnum].Acted == 0)
            memset(&BField[6][0][0], 0, sizeof(BField[6]));
        BField[3][Brole[bnum].X][Brole[bnum].Y] = 0;
        SeekPath2(Brole[bnum].X, Brole[bnum].Y, step, Brole[bnum].Team, mode, bnum);
        if (Brole[bnum].Acted == 0)
            memcpy(&BField[6][0][0], &BField[3][0][0], 4096 * 2);
    }

    if (mode == 1)
    {
        memset(&BField[3][0][0], -1, 4096 * 2);
        for (int i1 = std::max(0, Brole[bnum].X - step); i1 <= std::min(63, Brole[bnum].X + step); i1++)
        {
            int step0 = abs(i1 - Brole[bnum].X);
            for (int i2 = std::max(0, Brole[bnum].Y - step + step0); i2 <= std::min(63, Brole[bnum].Y + step - step0); i2++)
            {
                BField[3][i1][i2] = 0;
            }
        }
    }

    if (mode == 2)
    {
        for (int i1 = 0; i1 < 64; i1++)
            for (int i2 = 0; i2 < 64; i2++)
            {
                BField[3][i1][i2] = -1;
                if (BField[2][i1][i2] >= 0)
                    BField[3][i1][i2] = 0;
            }
    }
}

void ModifyRange(int bnum, int mnum, int& step, int& range)
{
    // 根据武功修正攻击范围
    if (mnum < 0 || mnum >= 1000) return;
    step = Rmagic[mnum + 1].Data[15];  // AttachType/MoveStep
    range = Rmagic[mnum + 1].Data[16]; // Range
}

void Attack(int bnum)
{
    // TODO: 攻击逻辑
    Brole[bnum].Acted = 1;
}

void AttackAction(int bnum, int i, int mnum, int level) { /* TODO */ }
void AttackAction(int bnum, int mnum, int level) { AttackAction(bnum, -1, mnum, level); }

void ShowMagicName(int mnum, const std::string& str)
{
    std::string name = str;
    if (name.empty() && mnum >= 0 && mnum < 1000)
        name = Rmagic[mnum + 1].Name;
    DrawTextWithRect(name, CENTER_X - DrawLength(name) * 5, CENTER_Y - 30, 0, ColColor(0x14), ColColor(0x16));
    SDL_Delay(500);
}

int SelectMagic(int rnum)
{
    // TODO: 武功选择菜单
    return -1;
}

void SetAminationPosition(int mode, int step, int range, int aimMode) { /* TODO */ }
void SetAminationPosition(int bx, int by, int ax, int ay, int mode, int step, int range, int aimMode) { /* TODO */ }
void PlayMagicAmination(int bnum, int eNum, int aimMode, int mode) { /* TODO */ }

void CalHurtRole(int bnum, int mnum, int level, int mode)
{
    // TODO: 计算伤害范围内角色
}

int CalHurtValue(int bnum1, int bnum2, int mnum, int level, int mode)
{
    // TODO: 伤害计算
    if (bnum1 < 0 || bnum2 < 0) return 0;
    int rnum1 = Brole[bnum1].rnum, rnum2 = Brole[bnum2].rnum;
    if (rnum1 < 0 || rnum2 < 0) return 0;

    int atk = Rrole[rnum1 + 1].Data[26];  // Attack
    int def = Rrole[rnum2 + 1].Data[28];  // Defence
    int hurt = std::max(0, (atk - def) * 2 + rand() % 20);

    if (mnum >= 0 && mnum < 1000)
        hurt += Rmagic[mnum + 1].Data[12] * level / 10;  // Power

    return hurt;
}

int CalHurtValue2(int bnum1, int bnum2, int mnum, int level, int mode)
{
    return CalHurtValue(bnum1, bnum2, mnum, level, mode);
}

void SelectColor(int mode, uint32& color1, uint32& color2, std::string& formatstr)
{
    switch (mode)
    {
    case 0: color1 = ColColor(0x10); color2 = ColColor(0x12); formatstr = "-"; break;
    case 1: color1 = ColColor(0x07); color2 = ColColor(0x05); formatstr = "+"; break;
    default: color1 = ColColor(0x14); color2 = ColColor(0x16); formatstr = ""; break;
    }
}

void ShowHurtValue(int mode, int team, const std::string& fstr) { /* TODO */ }
void ShowStringOnBrole(const std::string& str, int bnum, int mode, int up) { /* TODO */ }

void CalPoiHurtLife()
{
    for (int i = 0; i < BRoleAmount; i++)
    {
        if (Brole[i].Dead != 0) continue;
        int rnum = Brole[i].rnum;
        if (rnum < 0 || rnum >= 1000) continue;
        TRole& r = Rrole[rnum + 1];
        if (r.Data[72] > 0)  // Poison
        {
            int hurt = r.Data[72] / 10;
            r.Data[22] -= hurt;  // CurrentHP
            if (r.Data[22] <= 0)
            {
                r.Data[22] = 0;
                Brole[i].Dead = 1;
            }
        }
    }
}

void ClearDeadRolePic()
{
    for (int i = 0; i < BRoleAmount; i++)
    {
        if (Brole[i].Dead != 0) continue;
        int rnum = Brole[i].rnum;
        if (rnum < 0 || rnum >= 1000) continue;
        if (Rrole[rnum + 1].Data[22] <= 0)
            Brole[i].Dead = 1;
    }
}

void Wait(int bnum)
{
    Brole[bnum].Acted = 1;
}

void RestoreRoleStatus()
{
    for (int i = 0; i < BRoleAmount; i++)
    {
        int rnum = Brole[i].rnum;
        for (int j = 0; j < STATUS_AMOUNT; j++)
        {
            Brole[i].StateLevel[j] = 0;
            Brole[i].StateRound[j] = 0;
        }

        if (Brole[i].Team == 0)
        {
            Rrole[rnum].CurrentHP = Rrole[rnum].CurrentHP + Rrole[rnum].MaxHP / 2;
            if (Rrole[rnum].CurrentHP <= 0)
                Rrole[rnum].CurrentHP = 1;
            if (Rrole[rnum].CurrentHP > Rrole[rnum].MaxHP)
                Rrole[rnum].CurrentHP = Rrole[rnum].MaxHP;
            Rrole[rnum].CurrentMP = Rrole[rnum].CurrentMP + Rrole[rnum].MaxMP / 20;
            if (Rrole[rnum].CurrentMP > Rrole[rnum].MaxMP)
                Rrole[rnum].CurrentMP = Rrole[rnum].MaxMP;
            Rrole[rnum].PhyPower = Rrole[rnum].PhyPower + MAX_PHYSICAL_POWER / 2;
            if (Rrole[rnum].PhyPower > MAX_PHYSICAL_POWER)
                Rrole[rnum].PhyPower = MAX_PHYSICAL_POWER;
        }
        else
        {
            Rrole[rnum].Hurt = 0;
            Rrole[rnum].Poison = 0;
            Rrole[rnum].CurrentHP = Rrole[rnum].MaxHP;
            Rrole[rnum].CurrentMP = Rrole[rnum].MaxMP;
            Rrole[rnum].PhyPower = MAX_PHYSICAL_POWER * 9 / 10;
        }
    }

    for (int i = 0; i < 1002; i++)
    {
        if (Rmagic[i].ScriptNum == 31)
        {
            Rrole[0].Magic[0] = i;
            break;
        }
    }
}

void AddExp()
{
    // TODO: 增加经验值
}

void CheckLevelUp()
{
    // TODO: 检查升级
}

void LevelUp(int bnum, int rnum) { /* TODO */ }
void CheckBook() { /* TODO */ }

int CalRNum(int team)
{
    int count = 0;
    for (int i = 0; i < BRoleAmount; i++)
        if (Brole[i].Team == team && Brole[i].Dead == 0) count++;
    return count;
}

void BattleMenuItem(int bnum) { /* TODO: 战斗中使用物品 */ }
void UsePoison(int bnum) { /* TODO */ }
void PlayActionAmination(int bnum, int mode) { /* TODO */ }
void Medcine(int bnum) { /* TODO */ }
void MedPoison(int bnum) { /* TODO */ }
void UseHiddenWeapon(int bnum, int inum) { /* TODO */ }

void Rest(int bnum)
{
    int rnum = Brole[bnum].rnum;
    if (rnum >= 0 && rnum < 1000)
    {
        TRole& r = Rrole[rnum + 1];
        int hp = std::min(r.Data[23], r.Data[22] + r.Data[23] / 10);  // MaxHP, CurrentHP + 10%
        r.Data[22] = hp;
        int mp = std::min(r.Data[25], r.Data[24] + r.Data[25] / 10);  // MaxMP, CurrentMP + 10%
        r.Data[24] = mp;
    }
    Brole[bnum].Acted = 1;
}

//----------------------------------------------------------------------
// AI
//----------------------------------------------------------------------
void AutoBattle(int bnum)
{
    // 简单AI: 移向最近敌人并攻击
    int mindis = 999, nearest = -1;
    for (int i = 0; i < BRoleAmount; i++)
    {
        if (i == bnum || Brole[i].Dead != 0) continue;
        if (Brole[i].Team == Brole[bnum].Team) continue;
        int dis = CalBroleDistance(bnum, i);
        if (dis < mindis) { mindis = dis; nearest = i; }
    }

    if (nearest >= 0 && mindis <= 1)
    {
        // 近身攻击
        AttackAction(bnum, -1, -1, 0);
    }
    else if (nearest >= 0)
    {
        // 移向敌人
        int dx = (Brole[nearest].X > Brole[bnum].X) ? 1 : -1;
        int dy = (Brole[nearest].Y > Brole[bnum].Y) ? 1 : -1;
        int step = Brole[bnum].Step;
        for (int s = 0; s < step; s++)
        {
            int nx = Brole[bnum].X + dx;
            int ny = Brole[bnum].Y + dy;
            if (nx >= 0 && nx < 64 && ny >= 0 && ny < 64)
            {
                Brole[bnum].X = nx;
                Brole[bnum].Y = ny;
            }
        }
    }
    Brole[bnum].Acted = 1;
}

bool AutoUseItem(int bnum, int list, int test)
{
    // TODO: AI自动使用物品
    return false;
}

void AutoBattle2(int bnum) { AutoBattle(bnum); }
void AutoBattle3(int bnum) { AutoBattle(bnum); }

void TryMoveAttack(int& Mx1, int& My1, int& Ax1, int& Ay1, int& tempmaxhurt, int bnum, int mnum, int level) { /* TODO */ }
void NearestMove(int& Mx1, int& My1, int bnum) { /* TODO */ }
void FarthestMove(int& Mx1, int& My1, int bnum) { /* TODO */ }
void NearestMoveByPro(int& Mx1, int& My1, int& Ax1, int& Ay1, int bnum, int TeamMate, int KeepDis, int Prolist, int MaxMinPro, int mode) { /* TODO */ }

bool ProbabilityByValue(int cur, int m, int mode, int& n)
{
    n = rand() % 100;
    return n < cur * 100 / std::max(1, m);
}

void TryAttack(int& Ax1, int& Ay1, int& magicid, int& cmlevel, int Mx, int My, int bnum) { /* TODO */ }
void TryMoveCure(int& Mx1, int& My1, int& Ax1, int& Ay1, int bnum) { /* TODO */ }
void CureAction(int bnum) { /* TODO */ }

void RoundOver()
{
    BattleRound++;
}

void RoundOver(int bnum)
{
    Brole[bnum].Acted = 1;
}

bool SelectAutoMode()
{
    // TODO: 选择自动战斗模式
    return false;
}

void Auto(int bnum) { AutoBattle(bnum); }

void SetEnemyAttribute()
{
    // TODO: 设定敌方角色属性
}

int IFinbattle(int num)
{
    for (int i = 0; i < BRoleAmount; i++)
        if (Brole[i].rnum == num && Brole[i].Dead == 0) return i;
    return -1;
}

bool UseSpecialAbility(int bnum, int mnum, int level) { return false; /* TODO */ }
bool SpecialAttack(int bnum) { return false; /* TODO */ }
int16_t GetMagicWithSA2(int16_t SANum) { return -1; /* TODO */ }
void CheckAttackAttachment(int bnum, int mnum, int level) { /* TODO */ }
void CheckDefenceAttachment(int bnum, int mnum, int level) { /* TODO */ }
bool CanSelectAim(int bnum, int aimbnum, int mnum, int aimMode) { return true; /* TODO */ }
void GiveUp(int bnum) { Brole[bnum].Dead = 1; }

void ModifyState(int bnum, int statenum, int16_t MaxValue, int16_t maxround) { /* TODO */ }
void GiveMeLife(int bnum, int mnum, int level, int Si) { /* TODO */ }
void ambush(int bnum, int mnum, int level, int Si) { /* TODO */ }

//----------------------------------------------------------------------
// TSpecialAbility - 主动特技
//----------------------------------------------------------------------
void TSpecialAbility::SA_0(int bnum, int mnum, int level) { /* 战神 */ }
void TSpecialAbility::SA_1(int bnum, int mnum, int level) { /* 风雷 */ }
void TSpecialAbility::SA_2(int bnum, int mnum, int level) { /* 孤注 */ }
void TSpecialAbility::SA_3(int bnum, int mnum, int level) { /* 倾国 */ }
void TSpecialAbility::SA_4(int bnum, int mnum, int level) { /* 毒箭 */ }
void TSpecialAbility::SA_5(int bnum, int mnum, int level) { /* 远攻 */ }
void TSpecialAbility::SA_6(int bnum, int mnum, int level) { /* 连击 */ }
void TSpecialAbility::SA_7(int bnum, int mnum, int level) { /* 反伤 */ }
void TSpecialAbility::SA_8(int bnum, int mnum, int level) { /* 灵精 */ }
void TSpecialAbility::SA_9(int bnum, int mnum, int level) { /* 闪避 */ }
void TSpecialAbility::SA_10(int bnum, int mnum, int level) { /* 博采 */ }
void TSpecialAbility::SA_11(int bnum, int mnum, int level) { /* 聆音 */ }
void TSpecialAbility::SA_12(int bnum, int mnum, int level) { /* 青翼 */ }
void TSpecialAbility::SA_13(int bnum, int mnum, int level) { /* 回体 */ }
void TSpecialAbility::SA_14(int bnum, int mnum, int level) { /* 伤逝 */ }
void TSpecialAbility::SA_15(int bnum, int mnum, int level) { /* 黯然 */ }
void TSpecialAbility::SA_16(int bnum, int mnum, int level) { /* 慈悲 */ }
void TSpecialAbility::SA_17(int bnum, int mnum, int level) { /* 悲歌 */ }
void TSpecialAbility::SA_18(int bnum, int mnum, int level) { /* TODO */ }
void TSpecialAbility::SA_19(int bnum, int mnum, int level) { /* TODO */ }
void TSpecialAbility::SA_20(int bnum, int mnum, int level) { /* TODO */ }
void TSpecialAbility::SA_21(int bnum, int mnum, int level) { /* TODO */ }
void TSpecialAbility::SA_22(int bnum, int mnum, int level) { /* TODO */ }
void TSpecialAbility::SA_23(int bnum, int mnum, int level) { /* TODO */ }
void TSpecialAbility::SA_24(int bnum, int mnum, int level) { /* TODO */ }
void TSpecialAbility::SA_25(int bnum, int mnum, int level) { /* 定身 */ }
void TSpecialAbility::SA_26(int bnum, int mnum, int level) { /* 控制 */ }
void TSpecialAbility::SA_27(int bnum, int mnum, int level) { /* 混乱 */ }
void TSpecialAbility::SA_28(int bnum, int mnum, int level) { /* 拳理 */ }
void TSpecialAbility::SA_29(int bnum, int mnum, int level) { /* 剑意 */ }
void TSpecialAbility::SA_30(int bnum, int mnum, int level) { /* 刀气 */ }
void TSpecialAbility::SA_31(int bnum, int mnum, int level) { /* 奇兵 */ }
void TSpecialAbility::SA_32(int bnum, int mnum, int level) { /* 狙击 */ }
void TSpecialAbility::SA_33(int bnum, int mnum, int level) { /* TODO */ }
void TSpecialAbility::SA_34(int bnum, int mnum, int level) { /* TODO */ }
void TSpecialAbility::SA_35(int bnum, int mnum, int level) { /* TODO */ }
void TSpecialAbility::SA_36(int bnum, int mnum, int level) { /* TODO */ }
void TSpecialAbility::SA_37(int bnum, int mnum, int level) { /* TODO */ }
void TSpecialAbility::SA_38(int bnum, int mnum, int level) { /* TODO */ }

//----------------------------------------------------------------------
// TSpecialAbility2 - 被动特技
//----------------------------------------------------------------------
void TSpecialAbility2::SA2_0(int bnum, int mnum, int mnum2, int level) { /* TODO */ }
void TSpecialAbility2::SA2_1(int bnum, int mnum, int mnum2, int level) { /* TODO */ }
void TSpecialAbility2::SA2_2(int bnum, int mnum, int mnum2, int level) { /* TODO */ }
void TSpecialAbility2::SA2_3(int bnum, int mnum, int mnum2, int level) { /* TODO */ }
void TSpecialAbility2::SA2_4(int bnum, int mnum, int mnum2, int level) { /* TODO */ }
void TSpecialAbility2::SA2_5(int bnum, int mnum, int mnum2, int level) { /* TODO */ }
void TSpecialAbility2::SA2_6(int bnum, int mnum, int mnum2, int level) { /* TODO */ }
void TSpecialAbility2::SA2_7(int bnum, int mnum, int mnum2, int level) { /* TODO */ }
void TSpecialAbility2::SA2_8(int bnum, int mnum, int mnum2, int level) { /* TODO */ }
void TSpecialAbility2::SA2_9(int bnum, int mnum, int mnum2, int level) { /* TODO */ }
void TSpecialAbility2::SA2_10(int bnum, int mnum, int mnum2, int level) { /* TODO */ }
void TSpecialAbility2::SA2_11(int bnum, int mnum, int mnum2, int level) { /* TODO */ }
void TSpecialAbility2::SA2_12(int bnum, int mnum, int mnum2, int level) { /* TODO */ }
void TSpecialAbility2::SA2_100(int bnum, int mnum, int mnum2, int level) { /* TODO */ }
void TSpecialAbility2::SA2_101(int bnum, int mnum, int mnum2, int level) { /* TODO */ }
void TSpecialAbility2::SA2_102(int bnum, int mnum, int mnum2, int level) { /* TODO */ }
void TSpecialAbility2::SA2_103(int bnum, int mnum, int mnum2, int level) { /* TODO */ }
