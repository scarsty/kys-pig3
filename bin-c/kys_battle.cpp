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
#include <format>
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
    for (int i = 0; i < MAX_BATTLE_ROLE; i++)
        Brole[i].alpha = 255;

    bool autoselect = InitialBField();

    Redraw();
    TransBlackScreen();

    std::string str;
    if (battlenum >= 0 && battlenum < (int)BattleNames.size())
        str = BattleNames[battlenum];
    else
        str = std::string((char*)&WarSta.Name[0]);
    DrawTextWithRect(str, CENTER_X - DrawLength(str) * 5 - 24, CENTER_Y - 150, 0, ColColor(0x14), ColColor(0x16));
    UpdateAllScreen();

    if (autoselect)
    {
        // 如果未发现自动参战设定, 则选择人物
        int SelectTeamList = SelectTeamMembers(forceSingle);
        for (int i = 0; i < 6; i++)
        {
            int x = WarSta.TeamX[i];
            int y = WarSta.TeamY[i];
            if (SelectTeamList & (1 << i))
            {
                InitialBRole(BRoleAmount, TeamList[i], 0, x, y);
                BRoleAmount++;
            }
        }
        for (int i = 0; i < 6; i++)
        {
            int x = WarSta.TeamX[i];
            int y = WarSta.TeamY[i] + 1;
            if (WarSta.TeamMate[i] > 0 && instruct_16(WarSta.TeamMate[i], 1, 0) == 0)
            {
                InitialBRole(BRoleAmount, WarSta.TeamMate[i], 0, x, y);
                BRoleAmount++;
            }
        }
    }

    if (MODVersion == 13)
    {
        // 设定敌方角色的状态, 珍珑之战除外
        if (CurrentBattle != 178)
            SetEnemyAttribute();
        // 欧阳锋洪七公雪山之战
        if (CurrentBattle == 159 || CurrentBattle == 292)
        {
            Rrole[243].CurrentHP = 999;
            Rrole[243].CurrentMP = 10;
            Rrole[243].Movestep = 0;
            Rrole[244].CurrentHP = 999;
            Rrole[244].CurrentMP = 10;
            Rrole[244].Movestep = 0;
        }
    }

    // 调整人物的方向, 面向距离最短的敌人
    for (int i1 = 0; i1 < BRoleAmount; i1++)
    {
        int mindis = 128;
        for (int i2 = 0; i2 < BRoleAmount; i2++)
        {
            if (Brole[i1].Team != Brole[i2].Team)
            {
                int dis = CalBroleDistance(i1, i2);
                if (dis < mindis)
                {
                    Brole[i1].Face = CalFace(i1, i2);
                    mindis = dis;
                }
            }
        }
    }

    for (int i = 0; i < BRoleAmount; i++)
    {
        if (Brole[i].Team == 0)
            Brole[i].AutoMode = 1;
        else
            Brole[i].AutoMode = 0;
        // 战场状态和情侣加成清空
        for (int j = 0; j < 10; j++)
            Brole[i].loverlevel[j] = 0;
        for (int k = 0; k < 34; k++)
            Brole[i].StateLevel[k] = 0;
    }

    TurnBlack();
    int prewhere = Where;
    Where = 2;
    InitialBFieldImage();
    StopMP3();
    PlayMP3(WarSta.MusicNum, -1);
    BlackScreen = 0;

    Bx = Brole[0].X;
    By = Brole[0].Y;
    Redraw();
    TransBlackScreen();
    if (battlenum >= 0 && battlenum < (int)BattleNames.size())
        str = BattleNames[battlenum];
    else
        str = std::string((char*)&WarSta.Name[0]);
    DrawTextWithRect(str, CENTER_X - DrawLength(str) * 5 - 24, CENTER_Y - 150, 0, ColColor(0x14), ColColor(0x16));
    UpdateAllScreen();

    LoadBattleTiles();

    BattleMainControl();

    RestoreRoleStatus();

    if (Bstatus == 1)
    {
        AddExp();
        CheckLevelUp();
        CheckBook();
    }

    Redraw();
    UpdateAllScreen();

    if (Rscene[CurScene].EntranceMusic >= 0)
    {
        StopMP3();
        PlayMP3(Rscene[CurScene].EntranceMusic, -1);
    }

    FreeBattleTiles();

    Where = prewhere;
    return (Bstatus == 1);
}

int getBnum(int rnum)
{
    for (int i = 0; i < BRoleAmount; i++)
        if (Brole[i].rnum == rnum) return i;
    return -1;
}

void LoadBattleTiles()
{
    LoadingBattleTiles = true;
    RecordFreshScreen(CENTER_X - 140, CENTER_Y, 300, 25);
    for (int i = 0; i < BRoleAmount; i++)
    {
        int actionnum = Rrole[Brole[i].rnum].ActionNum;
        if (FPNGIndex[actionnum].Loaded == 0)
        {
            auto buf = std::format("resource/fight/fight{:03d}", actionnum);
            LoadPNGTiles(buf, FPNGIndex[actionnum].PNGIndexArray, 1, &FPNGIndex[actionnum].FightFrame[0]);
            FPNGIndex[actionnum].Loaded = 1;
        }
        int num = 0;
        for (int j = 0; j < 5; j++)
        {
            if (FPNGIndex[actionnum].FightFrame[j] < 0 || FPNGIndex[actionnum].FightFrame[j] > 50)
                FPNGIndex[actionnum].FightFrame[j] = 1;
            if (FPNGIndex[actionnum].FightFrame[j] > 0)
            {
                for (int k = 0; k < 4; k++)
                    Brole[i].StaticPic[k] = num + FPNGIndex[actionnum].FightFrame[j] * k;
                break;
            }
        }
        LoadFreshScreen(CENTER_X - 140, CENTER_Y);
        auto str = std::format("載入戰鬥人物貼圖 {:2d}/{:2d}", i + 1, BRoleAmount);
        DrawTextWithRect(str, CENTER_X - 120, CENTER_Y, 0, ColColor(0x64), ColColor(0x66), 179);
        UpdateAllScreen();
    }
    LoadingBattleTiles = false;
    FreeFreshScreen();
}

void FreeBattleTiles()
{
    // 当前使用全局FPNGIndex数组，不需逐个释放
}

bool InitialBField()
{
    WarSta = WarStaList[CurrentBattle];
    int fieldnum = WarSta.BFieldNum;
    memcpy(&BField[0][0][0], &WARFLD.GRP[WARFLD.IDX[fieldnum]], 2 * 64 * 64 * 2);
    for (int i1 = 0; i1 < 64; i1++)
        for (int i2 = 0; i2 < 64; i2++)
            BField[2][i1][i2] = -1;
    BRoleAmount = 0;
    bool result = true;

    for (int i = 0; i < MAX_BATTLE_ROLE; i++)
    {
        Brole[i].rnum = -1;
        Brole[i].Dead = 1;
        Brole[i].Y = -1;
        Brole[i].X = -1;
    }

    // 我方自动参战数据
    for (int i = 0; i < 6; i++)
    {
        int x = WarSta.TeamX[i];
        int y = WarSta.TeamY[i];
        if (WarSta.AutoTeamMate[i] >= 0)
        {
            InitialBRole(BRoleAmount, WarSta.AutoTeamMate[i], 0, x, y);
            BRoleAmount++;
        }
    }
    // 如没有自动参战人物, 返回假, 激活选择人物
    if (BRoleAmount > 0)
        result = false;
    for (int i = 0; i < 20; i++)
    {
        int x = WarSta.EnemyX[i];
        int y = WarSta.EnemyY[i];
        if (WarSta.Enemy[i] >= 0)
        {
            InitialBRole(BRoleAmount, WarSta.Enemy[i], 1, x, y);
            BRoleAmount++;
        }
    }
    return result;
}

void InitialBRole(int i, int rnum, int team, int x, int y)
{
    if (i < 0 || i >= MAX_BATTLE_ROLE) return;
    Brole[i].rnum = rnum;
    Brole[i].Team = team;
    Brole[i].Y = y;
    Brole[i].X = x;
    if (team == 0)
        Brole[i].Face = 2;
    else
        Brole[i].Face = 1;
    Brole[i].Dead = 0;
    Brole[i].Step = 0;
    Brole[i].Acted = 0;
    Brole[i].ExpGot = 0;
    Brole[i].Auto = 0;
    Brole[i].RealSpeed = 0;
    Brole[i].RealProgress = rand() % 7000;
}

int SelectTeamMembers(int forceSingle)
{
    int x = CENTER_X - 110;
    int y = CENTER_Y - 90;
    int h = 28;
    std::string str1 = "參戰";
    RecordFreshScreen(x, y, 220, 250);
    int result = 0;
    int max_ = 1;
    int menu = 0;
    std::string menuString[9];
    for (int i = 0; i < 6; i++)
    {
        if (TeamList[i] >= 0)
        {
            menuString[i + 1] = (char*)Rrole[TeamList[i]].Name;
            max_++;
        }
    }
    menuString[0] = (forceSingle != 0) ? "   限選一人" : "   全員參戰";
    menuString[max_] = "   開始戰鬥";
    int forall = (1 << (max_ - 1)) - 1;

    auto ShowMultiMenu = [&]()
    {
        LoadFreshScreen(x, y);
        for (int i = 0; i <= max_; i++)
        {
            if (i == 0 || i == max_)
                DrawTextFrame(x + 44, y + h * i, 8);
            else
                DrawTextFrame(x + 14, y + h * i, 14);
            uint32 c1 = (i == menu) ? ColColor(0x64) : (uint32)0;
            uint32 c2 = (i == menu) ? ColColor(0x66) : (uint32)0x202020;
            DrawShadowText(menuString[i].c_str(), x + 33, y + 3 + h * i, c1, c2);
            if ((result & (1 << (i - 1))) > 0 && i > 0 && i < max_)
                DrawShadowText(str1.c_str(), x + 133, y + 3 + h * i, c1, c2);
        }
        UpdateAllScreen();
    };

    ShowMultiMenu();
    while (SDL_WaitEvent(&event))
    {
        CheckBasicEvent();
        int xm, ym;
        if (event.type == SDL_EVENT_KEY_UP)
        {
            if ((event.key.key == SDLK_RETURN || event.key.key == SDLK_SPACE) && menu != max_)
            {
                if (forceSingle == 0)
                {
                    if (menu > 0) result ^= (1 << (menu - 1));
                    else { if (result < forall) result = forall; else result = 0; }
                }
                else { if (menu > 0) result = (1 << (menu - 1)); }
                ShowMultiMenu();
            }
            if ((event.key.key == SDLK_RETURN || event.key.key == SDLK_SPACE) && menu == max_)
            {
                if (result != 0) break;
            }
        }
        if (event.type == SDL_EVENT_KEY_DOWN)
        {
            if (event.key.key == SDLK_UP) { menu--; if (menu < 0) menu = max_; ShowMultiMenu(); }
            if (event.key.key == SDLK_DOWN) { menu++; if (menu > max_) menu = 0; ShowMultiMenu(); }
        }
        if (event.type == SDL_EVENT_MOUSE_BUTTON_UP && MouseInRegion(x, y, 150, (max_ + 1) * h))
        {
            if (event.button.button == SDL_BUTTON_LEFT && menu != max_)
            {
                if (forceSingle == 0)
                {
                    if (menu > 0) result ^= (1 << (menu - 1));
                    else { if (result < forall) result = forall; else result = 0; }
                }
                else { if (menu > 0) result = (1 << (menu - 1)); }
                ShowMultiMenu();
            }
            if (event.button.button == SDL_BUTTON_LEFT && menu == max_)
            {
                if (result != 0) break;
            }
        }
        if (event.type == SDL_EVENT_MOUSE_MOTION)
        {
            if (MouseInRegion(x, y, 150, (max_ + 1) * h, xm, ym))
            {
                int mp = menu;
                menu = (ym - y) / h;
                if (mp != menu) ShowMultiMenu();
            }
        }
    }
    FreeFreshScreen();
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
    int delaytime = 7;
    Bx = Brole[0].X;
    By = Brole[0].Y;

    // 若开启进度条, 则初始化一个随机值
    if (SEMIREAL == 1)
    {
        for (int i = 0; i < BRoleAmount; i++)
            Brole[i].RealProgress = rand() % 7000;
    }

    // 情侣加成对话
    ClearDeadRolePic();
    for (int k = 0; k < MAX_LOVER; k++)
    {
        int m = IFinbattle(loverlist[k][0]);
        int n = IFinbattle(loverlist[k][1]);
        if (m >= 0 && n >= 0 && m != n)
        {
            if (m == 0 && n == 0) break;
            Bx = Brole[n].X;
            By = Brole[n].Y;
            Redraw();
            NewTalk(loverlist[k][1], loverlist[k][4], -2, 0, 0, 28515, 0);
            Bx = Brole[m].X;
            By = Brole[m].Y;
            Redraw();
            NewTalk(loverlist[k][0], loverlist[k][4] + 1, -2, 1, 0, 28515, 0);
            Brole[m].loverlevel[loverlist[k][2]] = loverlist[k][3];
            if (loverlist[k][2] != 6) // 替代伤害为单向
                Brole[n].loverlevel[loverlist[k][2]] = loverlist[k][3];
        }
    }

    // 战斗未分出胜负则继续
    while (Bstatus == 0)
    {
        CalMoveAbility();

        if (SEMIREAL == 0)
            ReArrangeBRole();

        ClearDeadRolePic();

        for (int i = 0; i < BRoleAmount; i++)
        {
            if ((SEMIREAL == 0) || (Brole[i].Acted == 1))
            {
                // 7号状态, 战神, 随机获得一种正面状态
                if (Brole[i].StateLevel[7] > 0)
                {
                    int si = rand() % 21;
                    if (si == 0 || si == 1 || si == 2 || si == 4 || si == 11 || si == 14 || si == 15)
                    {
                        Brole[i].StateLevel[si] = Brole[i].StateLevel[7];
                        Brole[i].StateRound[si] = 3;
                    }
                    else if (si == 7)
                    {
                        Brole[i].StateRound[7] = Brole[i].StateRound[7] + 1;
                    }
                    else if (si == 5 || si == 6 || si == 20)
                    {
                        Brole[i].StateLevel[si] = Brole[i].StateLevel[7] / 2;
                        Brole[i].StateRound[si] = 3;
                    }
                    else
                    {
                        Brole[i].StateLevel[si] = 1;
                        Brole[i].StateRound[si] = 3;
                    }
                }

                // 24号状态, 悲歌, 随机获得一种奖励
                if (Brole[i].StateLevel[24] > 0)
                {
                    int si = rand() % 6;
                    if (si == 0 || si == 1)
                    {
                        if (Brole[i].StateLevel[si] <= 0)
                        {
                            Brole[i].StateLevel[si] = 20;
                            Brole[i].StateRound[si] = 1;
                        }
                        else
                            Brole[i].StateRound[si] = Brole[i].StateRound[si] + 1;
                    }
                    else if (si == 3)
                    {
                        if (Brole[i].StateLevel[si] <= 0)
                        {
                            Brole[i].StateLevel[si] = 3;
                            Brole[i].StateRound[si] = 1;
                        }
                        else
                            Brole[i].StateRound[si] = Brole[i].StateRound[si] + 1;
                    }
                    else if (si == 2)
                    {
                        Rrole[Brole[i].rnum].PhyPower = Rrole[Brole[i].rnum].PhyPower + 50;
                        if (Rrole[Brole[i].rnum].PhyPower > MAX_PHYSICAL_POWER)
                            Rrole[Brole[i].rnum].PhyPower = MAX_PHYSICAL_POWER;
                    }
                    else if (si == 4)
                    {
                        Rrole[Brole[i].rnum].CurrentHP = Rrole[Brole[i].rnum].CurrentHP + 1000;
                        if (Rrole[Brole[i].rnum].CurrentHP > Rrole[Brole[i].rnum].MaxHP)
                            Rrole[Brole[i].rnum].CurrentHP = Rrole[Brole[i].rnum].MaxHP;
                    }
                    else if (si == 5)
                    {
                        Rrole[Brole[i].rnum].CurrentMP = Rrole[Brole[i].rnum].CurrentMP + 1000;
                        if (Rrole[Brole[i].rnum].CurrentMP > Rrole[Brole[i].rnum].MaxMP)
                            Rrole[Brole[i].rnum].CurrentMP = Rrole[Brole[i].rnum].MaxMP;
                    }
                }
            }
            // 是否已行动, 显示数字清空
            Brole[i].Acted = 0;
            Brole[i].ShowNumber = 0;
            Brole[i].Moved = 0;
        }

        if (SEMIREAL == 1)
        {
            Redraw();
            int act = 0;
            int i = 0;
            while (true)
            {
                SDL_PollEvent(&event);
                for (i = 0; i < BRoleAmount; i++)
                {
                    if (Brole[i].Dead == 0)
                    {
                        Brole[i].RealProgress = Brole[i].RealProgress + Brole[i].RealSpeed + delaytime;
                        if (Brole[i].RealProgress >= 10000)
                        {
                            Brole[i].RealProgress = Brole[i].RealProgress - 10000;
                            act = 1;
                            break;
                        }
                    }
                }
                if (act == 1)
                    break;
                Redraw();
                UpdateAllScreen();
                SDL_Delay(delaytime);
                CheckBasicEvent();
            }
        }

        int i;
        if (SEMIREAL == 0)
            i = 0;

        while (i < BRoleAmount && Bstatus == 0)
        {
            // 当前人物位置作为屏幕中心
            Bx = Brole[i].X;
            By = Brole[i].Y;

            if (Brole[i].Dead == 0)
            {
                Redraw();
                UpdateAllScreen();
            }
            CheckBasicEvent();
            // 战场序号保存至变量28005
            x50[28005] = i;

            // 混乱和控制状态, 临时修改其阵营
            Brole[i].PreTeam = Brole[i].Team;
            if (Brole[i].StateLevel[28] < 0)
                Brole[i].Team = rand() % 99;
            if (Brole[i].StateLevel[27] < 0)
                Brole[i].Team = -Brole[i].StateLevel[27] - 1;

            if (Brole[i].Moved == 0)
                Brole[i].Step = CalBroleMoveAbility(i);

            // 26号状态定身
            // 未阵亡, 未被定身, 进入战斗
            if (Brole[i].Dead == 0 && Brole[i].StateLevel[26] >= 0)
            {
                // 我方且非自动战斗, 显示选单
                if (Brole[i].Team == 0 && Brole[i].Auto == 0)
                {
                    TBattleRole tempBrole;
                    if (Brole[i].Acted == 0)
                        tempBrole = Brole[i];
                    switch (BattleMenu(i))
                    {
                    case 0: MoveRole(i); break;
                    case 1: Attack(i); break;
                    case 2: UsePoison(i); break;
                    case 3: MedPoison(i); break;
                    case 4: Medcine(i); break;
                    case 5: BattleMenuItem(i); break;
                    case 6: Wait(i); break;
                    case 7: SelectShowStatus(i); break;
                    case 8:
                    case 9: Rest(i); break;
                    case 10: Auto(i); break;
                    case 11: GiveUp(i); break;
                    default:
                        BField[2][tempBrole.X][tempBrole.Y] = (int16_t)i;
                        BField[2][Brole[i].X][Brole[i].Y] = -1;
                        Brole[i] = tempBrole;
                        break;
                    }
                }
                else
                {
                    AutoBattle3(i);
                    if (Rrole[Brole[i].rnum].addnum == 3) // 额外一次攻击
                    {
                        Brole[i].Acted = 0;
                        AutoBattle3(i);
                    }
                    Brole[i].Acted = 1;
                }
            }
            else
                Brole[i].Acted = 1;

            ClearDeadRolePic();
            Brole[i].Pic = 0;
            if (Brole[i].Dead == 0)
            {
                Redraw();
                UpdateAllScreen();
            }

            // 恢复混乱的人的阵营
            if (Brole[i].StateLevel[28] < 0)
                Brole[i].Team = Brole[i].PreTeam;
            // 检测是否有一方全灭
            Bstatus = BattleStatus();
            // 恢复被控制人的阵营
            if (Brole[i].StateLevel[27] < 0)
                Brole[i].Team = Brole[i].PreTeam;

            if (Brole[i].Acted == 1)
            {
                // 内功
                if (Brole[i].Dead == 0)
                {
                    for (int j = 0; j < 4; j++)
                    {
                        int neinum = Rrole[Brole[i].rnum].NeiGong[j];
                        if (neinum <= 0) break;
                        int neilevel = Rrole[Brole[i].rnum].NGLevel[j] / 100 + 1;
                        Rrole[Brole[i].rnum].NGLevel[j] = std::min(999, Rrole[Brole[i].rnum].NGLevel[j] + 1);

                        if (Rmagic[neinum].AddMP[1] > 0)
                        {
                            // 星宿毒功, 周围5*5格人中毒
                            for (int x1 = -2; x1 <= 2; x1++)
                                for (int y1 = -2; y1 <= 2; y1++)
                                {
                                    if (Brole[i].X + x1 < 0 || Brole[i].X + x1 > 63 || Brole[i].Y + y1 < 0 || Brole[i].Y + y1 > 63)
                                        continue;
                                    if (BField[2][Brole[i].X + x1][Brole[i].Y + y1] >= 0)
                                    {
                                        int bnum = BField[2][Brole[i].X + x1][Brole[i].Y + y1];
                                        if (Brole[bnum].Team != Brole[i].Team)
                                        {
                                            int pnum = Rmagic[neinum].AddMP[0] + (Rmagic[neinum].AddMP[1] - Rmagic[neinum].AddMP[0]) * neilevel / 10;
                                            if (pnum > Rrole[Brole[bnum].rnum].DefPoi + Brole[bnum].loverlevel[3])
                                            {
                                                Rrole[Brole[bnum].rnum].Poison = Rrole[Brole[bnum].rnum].Poison + pnum;
                                                ShowStringOnBrole(std::string((char*)&Rmagic[neinum].Name[0]) + "·群毒", i, 2);
                                            }
                                        }
                                    }
                                }
                        }

                        // 化毒, 将中毒转化为内力
                        if (Rmagic[neinum].AttDistance[5] > 0)
                        {
                            int curepoi = Rmagic[neinum].AttDistance[5] * neilevel;
                            if (curepoi > Rrole[Brole[i].rnum].Poison)
                                curepoi = Rrole[Brole[i].rnum].Poison;
                            if (curepoi > 0)
                                ShowStringOnBrole(std::string((char*)&Rmagic[neinum].Name[0]) + "·化毒", i, 4);
                            Rrole[Brole[i].rnum].Poison = Rrole[Brole[i].rnum].Poison - curepoi;
                            Rrole[Brole[i].rnum].CurrentMP = Rrole[Brole[i].rnum].CurrentMP + curepoi * neilevel;
                            if (Rrole[Brole[i].rnum].CurrentMP > Rrole[Brole[i].rnum].MaxMP)
                                Rrole[Brole[i].rnum].CurrentMP = Rrole[Brole[i].rnum].MaxMP;
                        }

                        // 葵花宝典, 每回合随机获得加轻、加移、闪避状态
                        if (Rmagic[neinum].AddMP[2] == 1 || Rmagic[neinum].AddMP[2] == 10)
                        {
                            if (rand() % 100 > 50)
                            {
                                ModifyState(i, 2, 50, 3);
                                ShowStringOnBrole(std::string((char*)&Rmagic[neinum].Name[0]) + "·身輕", i, 3);
                            }
                            if (rand() % 100 > 50)
                            {
                                ModifyState(i, 3, 5, 3);
                                ShowStringOnBrole(std::string((char*)&Rmagic[neinum].Name[0]) + "·速行", i, 3);
                            }
                            if (rand() % 100 > 50)
                            {
                                ModifyState(i, 16, 50, 3);
                                ShowStringOnBrole(std::string((char*)&Rmagic[neinum].Name[0]) + "·閃避", i, 3);
                            }
                        }

                        // 九阴真经, 每回合随机获得加攻、加防状态, 减受伤
                        if (Rmagic[neinum].AddMP[2] == 2 || Rmagic[neinum].AddMP[2] == 10)
                        {
                            if (rand() % 100 > 50)
                            {
                                ModifyState(i, 0, 10 * neilevel, 3);
                                ShowStringOnBrole(std::string((char*)&Rmagic[neinum].Name[0]) + "·威力", i, 3);
                            }
                            if (rand() % 100 > 50)
                            {
                                ModifyState(i, 1, 10 * neilevel, 3);
                                ShowStringOnBrole(std::string((char*)&Rmagic[neinum].Name[0]) + "·剛體", i, 3);
                            }
                            Rrole[Brole[i].rnum].Hurt = Rrole[Brole[i].rnum].Hurt - 10 * neilevel;
                            if (Rrole[Brole[i].rnum].Hurt < 0)
                                Rrole[Brole[i].rnum].Hurt = 0;
                        }

                        // 北冥真气, 周围5*5格人减内, 自己回内
                        if (Rmagic[neinum].AddMP[2] == 3 || Rmagic[neinum].AddMP[2] == 10)
                        {
                            for (int x1 = -2; x1 <= 2; x1++)
                                for (int y1 = -2; y1 <= 2; y1++)
                                {
                                    if (Brole[i].X + x1 < 0 || Brole[i].X + x1 > 63 || Brole[i].Y + y1 < 0 || Brole[i].Y + y1 > 63)
                                        continue;
                                    if (BField[2][Brole[i].X + x1][Brole[i].Y + y1] >= 0)
                                    {
                                        int bnum = BField[2][Brole[i].X + x1][Brole[i].Y + y1];
                                        if (Brole[bnum].Team != Brole[i].Team)
                                        {
                                            int pnum = 50 * neilevel;
                                            if (pnum > Rrole[Brole[bnum].rnum].CurrentMP)
                                                pnum = Rrole[Brole[bnum].rnum].CurrentMP;
                                            Rrole[Brole[bnum].rnum].CurrentMP = Rrole[Brole[bnum].rnum].CurrentMP - pnum;
                                            Rrole[Brole[i].rnum].CurrentMP = Rrole[Brole[i].rnum].CurrentMP + pnum;
                                            if (Rrole[Brole[i].rnum].CurrentMP > Rrole[Brole[i].rnum].MaxMP)
                                                Rrole[Brole[i].rnum].CurrentMP = Rrole[Brole[i].rnum].MaxMP;
                                            ShowStringOnBrole(std::string((char*)&Rmagic[neinum].Name[0]) + "·納氣", i, 1);
                                        }
                                    }
                                }
                        }
                    }
                }
                RoundOver(i);
                i = i + 1;
                if (SEMIREAL == 1)
                    break;
            }
        }
        CalPoiHurtLife();
        x50[28101] = BRoleAmount;
        RoundOver();
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
}

void ReArrangeBRole()
{
    auto calTotalSpeed = [](int bnum) -> int {
        int rnum = Brole[bnum].rnum;
        int spd = Rrole[rnum].Speed + Ritem[Rrole[rnum].Equip[0]].AddSpeed + Ritem[Rrole[rnum].Equip[1]].AddSpeed;
        spd = spd * (100 + Brole[bnum].StateLevel[2] + Brole[bnum].loverlevel[9]) / 100;
        return spd;
    };
    for (int i1 = 0; i1 < BRoleAmount - 1; i1++)
        for (int i2 = i1 + 1; i2 < BRoleAmount; i2++)
            if (calTotalSpeed(i1) < calTotalSpeed(i2))
                std::swap(Brole[i1], Brole[i2]);

    memset(&BField[2][0][0], -1, sizeof(BField[2]));
    for (int i = 0; i < BRoleAmount; i++)
    {
        if (Brole[i].Dead == 0)
            BField[2][Brole[i].X][Brole[i].Y] = (int16_t)i;
        else
            BField[2][Brole[i].X][Brole[i].Y] = -1;
    }
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
    int x = 50, y = 40, h = 28;
    int MenuStatus = 0xFE0; // bits 5-11 initially on (物品/等待/状态/调息/结束/自动/认输)
    int max = 6;
    std::string word[12];
    std::string num_str[10];
    word[0] = "移動"; word[1] = "武學"; word[2] = "用毒"; word[3] = "解毒";
    word[4] = "醫療"; word[5] = "物品"; word[6] = "等待"; word[7] = "狀態";
    word[8] = "調息"; word[9] = "結束"; word[10] = "自動"; word[11] = "認輸";
    num_str[0] = "零"; num_str[1] = "一"; num_str[2] = "二"; num_str[3] = "三";
    num_str[4] = "四"; num_str[5] = "五"; num_str[6] = "六"; num_str[7] = "七";
    num_str[8] = "八"; num_str[9] = "九";

    int rnum = Brole[bnum].rnum;

    // 移动是否可用
    if (Brole[bnum].Step > 0)
    {
        MenuStatus = MenuStatus | 1;
        max++;
    }
    // 攻击是否可用
    if (Rrole[rnum].PhyPower >= 10 && Rrole[rnum].Poison < 100)
    {
        int p = 0;
        for (int ii = 0; ii < 10; ii++)
        {
            if (Rrole[rnum].Magic[ii] > 0)
            {
                int mnum = Rrole[rnum].Magic[ii];
                if (Rmagic[mnum].NeedItem < 0 ||
                    (Rmagic[mnum].NeedItem >= 0 && Rmagic[mnum].NeedItemAmount <= GetItemAmount(Rmagic[mnum].NeedItem)
                     && Rmagic[mnum].NeedMP <= Rrole[rnum].CurrentMP))
                {
                    p = 1;
                    break;
                }
            }
        }
        if (p > 0)
        {
            MenuStatus = MenuStatus | 2;
            max++;
        }
    }
    // 用毒是否可用
    if (Rrole[rnum].UsePoi > 0 && Rrole[rnum].PhyPower >= 30)
    {
        MenuStatus = MenuStatus | 4;
        max++;
    }
    // 解毒是否可用
    if (Rrole[rnum].MedPoi > 0 && Rrole[rnum].PhyPower >= 50)
    {
        MenuStatus = MenuStatus | 8;
        max++;
    }
    // 医疗是否可用
    if (Rrole[rnum].Medcine > 0 && Rrole[rnum].PhyPower >= 50)
    {
        MenuStatus = MenuStatus | 16;
        max++;
    }
    // 等待是否可用 (SEMIREAL模式下不可用)
    if (SEMIREAL == 1)
    {
        MenuStatus = MenuStatus - 64;
        max--;
    }
    // 调息结束是否可用
    if (Brole[bnum].Moved > 0)
    {
        MenuStatus = MenuStatus - 256; // 去掉调息
        max--;
    }
    else
    {
        MenuStatus = MenuStatus - 512; // 去掉结束
        max--;
    }

    // 显示战斗菜单的lambda
    auto ShowBMenu = [&](int ms, int menu_idx, int mx) {
        LoadFreshScreen(x, y);
        int p = 0;
        for (int ii = 0; ii < 12; ii++)
        {
            if ((p == menu_idx) && (ms & (1 << ii)))
            {
                DrawTextFrame(x, y + h * p, 4);
                DrawShadowText(word[ii], x + 19, y + h * p + 3, ColColor(0x64), ColColor(0x66));
                p++;
            }
            else if ((p != menu_idx) && (ms & (1 << ii)))
            {
                DrawTextFrame(x + 5, y + h * p, 4, 204);
                DrawShadowText(word[ii], x + 24, y + h * p + 3, 0, 0x202020);
                p++;
            }
        }
        UpdateAllScreen();
    };

    Redraw();
    ShowSimpleStatus(Brole[bnum].rnum, 80, CENTER_Y * 2 - 150);

    // 显示回合数
    auto roundStr = std::format("{}", BattleRound);
    int l = (int)roundStr.size();
    DrawTextFrame(x + 100, y, 4 + l * 2);
    for (int ii = 0; ii < l; ii++)
    {
        int digit = roundStr[ii] - '0';
        if (digit >= 0 && digit <= 9)
            DrawShadowText(num_str[digit], x + 139 + (ii + 1) * 20, y + 3, 0, 0x202020);
    }
    DrawShadowText("回合", x + 119, y + 3, 0, 0x202020);

    UpdateAllScreen();
    RecordFreshScreen(x, y, 90, max * h + 40);
    int menu = 0;
    ShowBMenu(MenuStatus, menu, max);

    while (SDL_WaitEvent(&event))
    {
        CheckBasicEvent();
        switch (event.type)
        {
        case SDL_EVENT_KEY_DOWN:
            if (event.key.key == SDLK_UP)
            {
                menu--;
                if (menu < 0) menu = max;
                ShowBMenu(MenuStatus, menu, max);
            }
            if (event.key.key == SDLK_DOWN)
            {
                menu++;
                if (menu > max) menu = 0;
                ShowBMenu(MenuStatus, menu, max);
            }
            event.key.key = 0;
            break;
        case SDL_EVENT_KEY_UP:
            if (event.key.key == SDLK_RETURN || event.key.key == SDLK_SPACE)
                goto bmenu_done;
            if (event.key.key == SDLK_ESCAPE)
            {
                menu = -1;
                goto bmenu_done;
            }
            break;
        case SDL_EVENT_MOUSE_BUTTON_UP:
        {
            int xm, ym;
            if (event.button.button == SDL_BUTTON_LEFT && menu != -1 && MouseInRegion(x, y, 120, (max + 1) * h, xm, ym))
                goto bmenu_done;
            if (event.button.button == SDL_BUTTON_RIGHT)
            {
                menu = -1;
                goto bmenu_done;
            }
            break;
        }
        case SDL_EVENT_MOUSE_MOTION:
        {
            int xm, ym;
            if (MouseInRegion(x, y, 120, (max + 1) * h, xm, ym))
            {
                int menup = menu;
                menu = (ym - y - 2) / h;
                if (menu > max) menu = max;
                if (menu < 0) menu = 0;
                if (menup != menu)
                    ShowBMenu(MenuStatus, menu, max);
            }
            break;
        }
        }
    }

bmenu_done:
    // 将菜单选项索引映射回word数组索引
    int result = -1;
    if (menu >= 0)
    {
        int p = 0;
        for (int ii = 0; ii < 12; ii++)
        {
            if (MenuStatus & (1 << ii))
            {
                if (p == menu)
                {
                    result = ii;
                    break;
                }
                p++;
            }
        }
    }
    FreeFreshScreen();
    return result;
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
    bool result = (abs(Ax - Bx) + abs(Ay - By)) > 0;
    if (result)
        Brole[bnum].Acted = 2; // 2表示移动过
    if (BField[3][Ax][Ay] > 0)
    {
        int Xinc[5] = { 0, 1, -1, 0, 0 };
        int Yinc[5] = { 0, 0, 0, 1, -1 };
        int linebx[65], lineby[65];
        linebx[0] = Ax;
        lineby[0] = Ay;
        for (int a = 1; a <= BField[3][Ax][Ay]; a++)
        {
            bool seekError = true;
            for (int i = 1; i <= 4; i++)
            {
                int tempx = linebx[a - 1] + Xinc[i];
                int tempy = lineby[a - 1] + Yinc[i];
                if (BField[3][tempx][tempy] == BField[3][linebx[a - 1]][lineby[a - 1]] - 1)
                {
                    linebx[a] = tempx;
                    lineby[a] = tempy;
                    seekError = false;
                    if (BField[7][tempx][tempy] == 0
                        || (BField[7][tempx][tempy] == 1 && tempx == Ax && tempy == Ay))
                        break;
                }
            }
            if (seekError)
                return false;
        }
        int a = BField[3][Ax][Ay] - 1;
        while (true)
        {
            CheckBasicEvent();
            if (linebx[a] - Bx > 0) Brole[bnum].Face = 3;
            else if (linebx[a] - Bx < 0) Brole[bnum].Face = 0;
            else if (lineby[a] - By < 0) Brole[bnum].Face = 2;
            else Brole[bnum].Face = 1;

            SDL_Delay(BATTLE_SPEED);
            if (BField[2][Bx][By] == bnum)
                BField[2][Bx][By] = -1;
            Bx = linebx[a];
            By = lineby[a];
            if (BField[2][Bx][By] == -1)
                BField[2][Bx][By] = bnum;
            Redraw();
            UpdateAllScreen();
            Brole[bnum].Step--;
            Brole[bnum].Moved++;
            a--;
            if (a < 0) break;
        }
        Brole[bnum].X = Bx;
        Brole[bnum].Y = By;
    }
    return result;
}

bool SelectShowStatus(int bnum)
{
    Ax = Bx;
    Ay = By;
    BattleSelecting = true;
    int step = 64, range = 0, AttAreaType = 0;
    CalCanSelect(bnum, 2, 64);
    SelectAimMode = 5;
    DrawBFieldWithCursor(AttAreaType, step, range);
    UpdateAllScreen();
    int pAx = Ax, pAy = Ay;
    SDL_Event event = {};
    bool result = false;
    while (SDL_WaitEvent(&event))
    {
        CheckBasicEvent();
        if (event.type == SDL_EVENT_KEY_UP)
        {
            if (event.key.key == SDLK_RETURN || event.key.key == SDLK_SPACE)
            {
                if (BField[2][Ax][Ay] >= 0)
                {
                    int rnum = Brole[BField[2][Ax][Ay]].rnum;
                    TransBlackScreen();
                    ShowStatus(rnum, BField[2][Ax][Ay]);
                    UpdateAllScreen();
                    WaitAnyKey();
                    DrawBFieldWithCursor(AttAreaType, step, range);
                    UpdateAllScreen();
                }
            }
            if (event.key.key == SDLK_ESCAPE) { result = false; break; }
        }
        if (event.type == SDL_EVENT_KEY_DOWN)
        {
            if (event.key.key == SDLK_LEFT) Ay--;
            if (event.key.key == SDLK_RIGHT) Ay++;
            if (event.key.key == SDLK_DOWN) Ax++;
            if (event.key.key == SDLK_UP) Ax--;
        }
        if (event.type == SDL_EVENT_MOUSE_BUTTON_UP)
        {
            if (event.button.button == SDL_BUTTON_LEFT)
            {
                if (BField[2][Ax][Ay] >= 0)
                {
                    TransBlackScreen();
                    int rnum = Brole[BField[2][Ax][Ay]].rnum;
                    ShowStatus(rnum, BField[2][Ax][Ay]);
                    UpdateAllScreen();
                    WaitAnyKey();
                    DrawBFieldWithCursor(AttAreaType, step, range);
                    UpdateAllScreen();
                }
            }
            if (event.button.button == SDL_BUTTON_RIGHT) { result = false; break; }
        }
        if (event.type == SDL_EVENT_MOUSE_MOTION)
            GetMousePosition(Ax, Ay, Bx, By);
        Ax = RegionParameter(Ax, 0, 63);
        Ay = RegionParameter(Ay, 0, 63);
        if (pAx != Ax || pAy != Ay)
        {
            DrawBFieldWithCursor(AttAreaType, step, range);
            if (BField[2][Ax][Ay] >= 0)
                ShowSimpleStatus(Brole[BField[2][Ax][Ay]].rnum, 80, CENTER_Y * 2 - 150);
            UpdateAllScreen();
            pAx = Ax; pAy = Ay;
        }
    }
    BattleSelecting = false;
    return result;
}

bool SelectAim(int bnum, int step)
{
    int Axp, Ayp;
    Ax = Bx;
    Ay = By;
    BattleSelecting = true;
    DrawBFieldWithCursor(0, step, 0);
    if (BField[2][Ax][Ay] >= 0)
        ShowSimpleStatus(Brole[BField[2][Ax][Ay]].rnum, CENTER_X * 2 - 350, CENTER_Y * 2 - 150);
    UpdateAllScreen();
    bool result = false;
    while (SDL_WaitEvent(&event))
    {
        CheckBasicEvent();
        if (event.type == SDL_EVENT_KEY_UP)
        {
            if (event.key.key == SDLK_RETURN || event.key.key == SDLK_SPACE)
            { result = true; x50[28927] = 1; break; }
            if (event.key.key == SDLK_ESCAPE)
            { result = false; x50[28927] = 0; break; }
        }
        else if (event.type == SDL_EVENT_KEY_DOWN)
        {
            if (event.key.key == SDLK_LEFT)
            { Ay--; if (abs(Ax - Bx) + abs(Ay - By) > step || BField[3][Ax][Ay] < 0) Ay++; }
            if (event.key.key == SDLK_RIGHT)
            { Ay++; if (abs(Ax - Bx) + abs(Ay - By) > step || BField[3][Ax][Ay] < 0) Ay--; }
            if (event.key.key == SDLK_DOWN)
            { Ax++; if (abs(Ax - Bx) + abs(Ay - By) > step || BField[3][Ax][Ay] < 0) Ax--; }
            if (event.key.key == SDLK_UP)
            { Ax--; if (abs(Ax - Bx) + abs(Ay - By) > step || BField[3][Ax][Ay] < 0) Ax++; }
        }
        else if (event.type == SDL_EVENT_MOUSE_BUTTON_UP)
        {
            if (event.button.button == SDL_BUTTON_LEFT)
            {
                if (abs(Axp - Bx) + abs(Ayp - By) <= step && BField[3][Ax][Ay] >= 0)
                { result = true; break; }
            }
            if (event.button.button == SDL_BUTTON_RIGHT)
            { result = false; break; }
        }
        else if (event.type == SDL_EVENT_MOUSE_MOTION)
        {
            GetMousePosition(Axp, Ayp, Bx, By);
            if (Axp >= 0 && Ayp >= 0 && abs(Axp - Bx) + abs(Ayp - By) <= step && BField[3][Axp][Ayp] >= 0)
            { Ax = Axp; Ay = Ayp; }
        }
        DrawBFieldWithCursor(0, step, 0);
        if (BField[2][Ax][Ay] >= 0)
            ShowSimpleStatus(Brole[BField[2][Ax][Ay]].rnum, CENTER_X * 2 - 350, CENTER_Y * 2 - 150);
        UpdateAllScreen();
    }
    BattleSelecting = false;
    return result;
}

bool SelectRange(int bnum, int AttAreaType, int step, int range)
{
    int Axp, Ayp;
    Ax = Bx;
    Ay = By;
    BattleSelecting = true;
    DrawBFieldWithCursor(AttAreaType, step, range);
    if (BField[2][Ax][Ay] >= 0)
        ShowSimpleStatus(Brole[BField[2][Ax][Ay]].rnum, CENTER_X * 2 - 350, CENTER_Y * 2 - 150);
    UpdateAllScreen();
    bool result = false;
    while (SDL_WaitEvent(&event))
    {
        CheckBasicEvent();
        if (event.type == SDL_EVENT_KEY_UP)
        {
            if (event.key.key == SDLK_RETURN || event.key.key == SDLK_SPACE)
            { result = true; x50[28927] = 1; break; }
            if (event.key.key == SDLK_ESCAPE)
            { result = false; x50[28927] = 0; break; }
        }
        else if (event.type == SDL_EVENT_KEY_DOWN)
        {
            if (event.key.key == SDLK_LEFT)
            { Ay--; if (abs(Ax - Bx) + abs(Ay - By) > step) Ay++; }
            if (event.key.key == SDLK_RIGHT)
            { Ay++; if (abs(Ax - Bx) + abs(Ay - By) > step) Ay--; }
            if (event.key.key == SDLK_DOWN)
            { Ax++; if (abs(Ax - Bx) + abs(Ay - By) > step) Ax--; }
            if (event.key.key == SDLK_UP)
            { Ax--; if (abs(Ax - Bx) + abs(Ay - By) > step) Ax++; }
            DrawBFieldWithCursor(AttAreaType, step, range);
            if (BField[2][Ax][Ay] >= 0)
                ShowSimpleStatus(Brole[BField[2][Ax][Ay]].rnum, CENTER_X * 2 - 350, CENTER_Y * 2 - 150);
            UpdateAllScreen();
        }
        else if (event.type == SDL_EVENT_MOUSE_BUTTON_UP)
        {
            if (event.button.button == SDL_BUTTON_LEFT) { result = true; break; }
            if (event.button.button == SDL_BUTTON_RIGHT) { result = false; break; }
        }
        else if (event.type == SDL_EVENT_MOUSE_MOTION)
        {
            GetMousePosition(Axp, Ayp, Bx, By);
            if (abs(Axp - Bx) + abs(Ayp - By) <= step)
            {
                Ax = Axp; Ay = Ayp;
                DrawBFieldWithCursor(AttAreaType, step, range);
                if (BField[2][Ax][Ay] >= 0)
                    ShowSimpleStatus(Brole[BField[2][Ax][Ay]].rnum, CENTER_X * 2 - 350, CENTER_Y * 2 - 150);
                UpdateAllScreen();
            }
        }
    }
    BattleSelecting = false;
    return result;
}

bool SelectDirector(int bnum, int AttAreaType, int step, int range)
{
    Ax = Bx - 1;
    Ay = By;
    BattleSelecting = true;
    DrawBFieldWithCursor(AttAreaType, step, range);
    UpdateAllScreen();
    bool result = false;
    while (SDL_WaitEvent(&event))
    {
        CheckBasicEvent();
        if (event.type == SDL_EVENT_KEY_UP)
        {
            if (event.key.key == SDLK_ESCAPE) break;
            if (event.key.key == SDLK_RETURN || event.key.key == SDLK_SPACE)
            {
                if (Ax != Bx || Ay != By) result = true;
                break;
            }
        }
        else if (event.type == SDL_EVENT_KEY_DOWN)
        {
            if (event.key.key == SDLK_LEFT) { Ay = By - 1; Ax = Bx; }
            if (event.key.key == SDLK_RIGHT) { Ay = By + 1; Ax = Bx; }
            if (event.key.key == SDLK_DOWN) { Ax = Bx + 1; Ay = By; }
            if (event.key.key == SDLK_UP) { Ax = Bx - 1; Ay = By; }
            DrawBFieldWithCursor(AttAreaType, step, range);
            UpdateAllScreen();
        }
        else if (event.type == SDL_EVENT_MOUSE_BUTTON_UP)
        {
            if (event.button.button == SDL_BUTTON_RIGHT) { result = false; break; }
            if (event.button.button == SDL_BUTTON_LEFT) { result = true; break; }
        }
        else if (event.type == SDL_EVENT_MOUSE_MOTION)
        {
            if (MouseInRegion(0, 0, CENTER_X, CENTER_Y)) { Ay = By - 1; Ax = Bx; }
            if (MouseInRegion(0, CENTER_Y, CENTER_X, CENTER_Y)) { Ax = Bx + 1; Ay = By; }
            if (MouseInRegion(CENTER_X, 0, CENTER_X, CENTER_Y)) { Ax = Bx - 1; Ay = By; }
            if (MouseInRegion(CENTER_X, CENTER_Y, CENTER_X, CENTER_Y)) { Ay = By + 1; Ax = Bx; }
            DrawBFieldWithCursor(AttAreaType, step, range);
            UpdateAllScreen();
        }
    }
    BattleSelecting = false;
    return result;
}

bool SelectCross(int bnum, int AttAreaType, int step, int range)
{
    Ax = Bx;
    Ay = By;
    BattleSelecting = true;
    DrawBFieldWithCursor(AttAreaType, step, range);
    UpdateAllScreen();
    bool result = false;
    while (SDL_WaitEvent(&event))
    {
        CheckBasicEvent();
        if (event.type == SDL_EVENT_KEY_UP)
        {
            if (event.key.key == SDLK_RETURN || event.key.key == SDLK_SPACE) { result = true; break; }
            if (event.key.key == SDLK_ESCAPE) { result = false; break; }
        }
        else if (event.type == SDL_EVENT_MOUSE_BUTTON_UP)
        {
            if (event.button.button == SDL_BUTTON_LEFT) { result = true; break; }
            if (event.button.button == SDL_BUTTON_RIGHT) { result = false; break; }
        }
    }
    BattleSelecting = false;
    return result;
}

bool SelectFar(int bnum, int mnum, int level)
{
    int Axp, Ayp;
    int step = Rmagic[mnum].MoveDistance[level - 1];
    int range = Rmagic[mnum].AttDistance[level - 1];
    int AttAreaType = Rmagic[mnum].AttAreaType;
    int minstep = Rmagic[mnum].MinStep;

    Ax = Bx - minstep - 1;
    Ay = By;
    BattleSelecting = true;
    DrawBFieldWithCursor(AttAreaType, step, range);
    UpdateAllScreen();
    bool result = false;
    while (SDL_WaitEvent(&event))
    {
        CheckBasicEvent();
        if (event.type == SDL_EVENT_KEY_UP)
        {
            if (event.key.key == SDLK_RETURN || event.key.key == SDLK_SPACE)
            { result = true; x50[28927] = 1; break; }
            if (event.key.key == SDLK_ESCAPE)
            { result = false; x50[28927] = 0; break; }
        }
        else if (event.type == SDL_EVENT_KEY_DOWN)
        {
            if (event.key.key == SDLK_LEFT)
            {
                Ay--;
                if (abs(Ax - Bx) + abs(Ay - By) > step) Ay++;
                if (abs(Ax - Bx) + abs(Ay - By) <= minstep)
                { if (Ax >= Bx) Ax++; else Ax--; }
                DrawBFieldWithCursor(AttAreaType, step, range);
                UpdateAllScreen();
            }
            if (event.key.key == SDLK_RIGHT)
            {
                Ay++;
                if (abs(Ax - Bx) + abs(Ay - By) > step) Ay--;
                if (abs(Ax - Bx) + abs(Ay - By) <= minstep)
                { if (Ax > Bx) Ax++; else Ax--; }
                DrawBFieldWithCursor(AttAreaType, step, range);
                UpdateAllScreen();
            }
            if (event.key.key == SDLK_DOWN)
            {
                Ax++;
                if (abs(Ax - Bx) + abs(Ay - By) > step) Ax--;
                if (abs(Ax - Bx) + abs(Ay - By) <= minstep)
                { if (Ay >= By) Ay++; else Ay--; }
                DrawBFieldWithCursor(AttAreaType, step, range);
                UpdateAllScreen();
            }
            if (event.key.key == SDLK_UP)
            {
                Ax--;
                if (abs(Ax - Bx) + abs(Ay - By) > step) Ax++;
                if (abs(Ax - Bx) + abs(Ay - By) <= minstep)
                { if (Ay > By) Ay++; else Ay--; }
                DrawBFieldWithCursor(AttAreaType, step, range);
                UpdateAllScreen();
            }
        }
        else if (event.type == SDL_EVENT_MOUSE_BUTTON_UP)
        {
            if (event.button.button == SDL_BUTTON_LEFT) { result = true; break; }
            if (event.button.button == SDL_BUTTON_RIGHT) { result = false; break; }
        }
        else if (event.type == SDL_EVENT_MOUSE_MOTION)
        {
            GetMousePosition(Axp, Ayp, Bx, By);
            if (abs(Axp - Bx) + abs(Ayp - By) <= step && abs(Axp - Bx) + abs(Ayp - By) > minstep)
            {
                Ax = Axp; Ay = Ayp;
                DrawBFieldWithCursor(AttAreaType, step, range);
                UpdateAllScreen();
            }
        }
    }
    BattleSelecting = false;
    return result;
}

void SeekPath2(int x, int y, int step, int myteam, int mode, int bnum)
{
    int Xlist[4097], Ylist[4097], steplist2[4097];
    int Xinc[4] = { 1, -1, 0, 0 };
    int Yinc[4] = { 0, 0, 1, -1 };
    int curgrid = 0, totalgrid = 0;
    int layer = (mode == 3) ? 8 : 3;

    Xlist[totalgrid] = x;
    Ylist[totalgrid] = y;
    steplist2[totalgrid] = 0;
    totalgrid++;

    while (curgrid < totalgrid)
    {
        int curX = Xlist[curgrid];
        int curY = Ylist[curgrid];
        int curstep = steplist2[curgrid];
        if (curstep < step)
        {
            int Bgrid[4];
            for (int i = 0; i < 4; i++)
            {
                Bgrid[i] = 0;
                int nextX = curX + Xinc[i];
                int nextY = curY + Yinc[i];
                if (nextX < 0 || nextX > 63 || nextY < 0 || nextY > 63)
                    Bgrid[i] = 4;
                else if (BField[layer][nextX][nextY] >= 0)
                    Bgrid[i] = 5;
                else if (BField[1][nextX][nextY] > 0 ||
                    (BField[0][nextX][nextY] >= 358 && BField[0][nextX][nextY] <= 362) ||
                    BField[0][nextX][nextY] == 522 || BField[0][nextX][nextY] == 1022 ||
                    (BField[0][nextX][nextY] >= 1324 && BField[0][nextX][nextY] <= 1330) ||
                    BField[0][nextX][nextY] == 1348)
                    Bgrid[i] = 1;
                else if (BField[2][nextX][nextY] >= 0 && Brole[BField[2][nextX][nextY]].Dead == 0 && mode == 0)
                {
                    if (Brole[BField[2][nextX][nextY]].Team == myteam)
                        Bgrid[i] = 2;
                    else
                        Bgrid[i] = 3;
                }
                else if (BField[6][nextX][nextY] < 0 && mode == 0)
                    Bgrid[i] = 8;
                else
                    Bgrid[i] = 0;

                if (mode == 0)
                {
                    for (int j = 0; j < 4; j++)
                    {
                        int nnx = nextX + Xinc[j];
                        int nny = nextY + Yinc[j];
                        if (nnx >= 0 && nnx < 64 && nny >= 0 && nny < 64)
                            if (BField[2][nnx][nny] >= 0 && Brole[BField[2][nnx][nny]].Dead == 0 && Brole[BField[2][nnx][nny]].Team != myteam)
                                BField[7][nextX][nextY] = 1;
                    }
                }
            }

            if (mode == 0)
            {
                if (curstep == 0 || (Bgrid[0] != 3 && Bgrid[1] != 3 && Bgrid[2] != 3 && Bgrid[3] != 3))
                {
                    for (int i = 0; i < 4; i++)
                    {
                        if (Bgrid[i] == 0)
                        {
                            Xlist[totalgrid] = curX + Xinc[i];
                            Ylist[totalgrid] = curY + Yinc[i];
                            steplist2[totalgrid] = curstep + 1;
                            BField[layer][Xlist[totalgrid]][Ylist[totalgrid]] = (int16_t)steplist2[totalgrid];
                            totalgrid++;
                        }
                    }
                }
            }
            else
            {
                for (int i = 0; i < 4; i++)
                {
                    if (Bgrid[i] == 0 || Bgrid[i] == 2 || Bgrid[i] == 3)
                    {
                        Xlist[totalgrid] = curX + Xinc[i];
                        Ylist[totalgrid] = curY + Yinc[i];
                        steplist2[totalgrid] = curstep + 1;
                        BField[layer][Xlist[totalgrid]][Ylist[totalgrid]] = (int16_t)steplist2[totalgrid];
                        totalgrid++;
                    }
                }
            }
        }
        curgrid++;
    }
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
    // 12号状态剑芒, 攻击范围扩大
    if (Brole[bnum].StateLevel[12] != 0 && Rmagic[mnum].HurtType != 2)
    {
        auto sign = [](int x) -> int { return (x > 0) - (x < 0); };
        switch (Rmagic[mnum].AttAreaType)
        {
        case 0: case 3: case 6:
            range += Brole[bnum].StateLevel[12]; break;
        case 1: case 4: case 5:
            step += Brole[bnum].StateLevel[12]; break;
        case 2:
            step += sign(step) * Brole[bnum].StateLevel[12];
            range += sign(range) * Brole[bnum].StateLevel[12];
            break;
        }
    }
}

void Attack(int bnum)
{
    int rnum = Brole[bnum].rnum;
    while (true)
    {
        int i = SelectMagic(rnum);
        if (i < 0) return;
        int mnum = Rrole[rnum].Magic[i];
        int level = Rrole[rnum].MagLevel[i] / 100 + 1;
        x50[28928] = mnum;
        x50[28929] = i;
        x50[28100] = i;

        SelectAimMode = 0;
        if (Rmagic[mnum].HurtType == 2)
            SelectAimMode = Rmagic[mnum].AddMP[0];

        int step = Rmagic[mnum].MoveDistance[level - 1];
        int range = Rmagic[mnum].AttDistance[level - 1];
        int AttAreaType = Rmagic[mnum].AttAreaType;

        ModifyRange(bnum, mnum, step, range);
        CalCanSelect(bnum, 1, step);

        bool selected = false;
        switch (Rmagic[mnum].AttAreaType)
        {
        case 0: case 3:
            selected = SelectRange(bnum, AttAreaType, step, range); break;
        case 1: case 4: case 5:
            selected = SelectDirector(bnum, AttAreaType, step, range); break;
        case 2:
            selected = SelectCross(bnum, AttAreaType, step, range); break;
        case 6:
            selected = SelectFar(bnum, mnum, level); break;
        }
        if (selected)
        {
            Brole[bnum].Acted = 1;
            SetAminationPosition(AttAreaType, step, range, SelectAimMode);
            AttackAction(bnum, i, mnum, level);
            break;
        }
    }
}

void AttackAction(int bnum, int i, int mnum, int level)
{
    int rnum = Brole[bnum].rnum;
    // 五岳剑法特殊处理
    if (mnum == 115)
    {
        double five[6] = {};
        five[1] = Rrole[rnum].Fist + (rand() % 1000) / 1000.0;
        five[2] = Rrole[rnum].Sword + (rand() % 1000) / 1000.0;
        five[3] = Rrole[rnum].Knife + (rand() % 1000) / 1000.0;
        five[4] = Rrole[rnum].Unusual + (rand() % 1000) / 1000.0;
        five[5] = Rrole[rnum].HidWeapon + (rand() % 1000) / 1000.0;
        double max_five = five[1];
        Rmagic[mnum].MagicType = 1;
        for (int i1 = 2; i1 <= 5; i1++)
        {
            if (five[i1] > max_five)
            {
                Rmagic[mnum].MagicType = i1;
                max_five = five[i1];
            }
        }
    }
    // 剑法连击
    int twice = 0;
    if (Rmagic[mnum].MagicType == 2)
    {
        if (rand() % 1000 < Rrole[rnum].Sword * (100 + Brole[bnum].StateLevel[30]) / 100)
            twice = 1;
    }
    twice += Brole[bnum].StateLevel[13];
    if (Rrole[rnum].addnum == 1) twice++;

    for (int i1 = 0; i1 <= twice; i1++)
    {
        AttackAction(bnum, mnum, level);
        if (Brole[bnum].Acted == 1)
            Rrole[rnum].MagLevel[i] = std::min(999, Rrole[rnum].MagLevel[i] + rand() % 2 + 1);
    }
    if (MODVersion != 13)
    {
        for (int i1 = 0; i1 <= 3; i1++)
        {
            if (Rrole[rnum].NeiGong[i1] > 0)
                Rrole[rnum].NGLevel[i1] = std::min(999, Rrole[rnum].NGLevel[i1] + rand() % 2);
        }
    }
    CheckAttackAttachment(bnum, mnum, level);
}

void AttackAction(int bnum, int mnum, int level)
{
    int rnum = Brole[bnum].rnum;
    // 消耗体力
    int Phyfee;
    if (Rrole[rnum].MaxMP > 10 * Rrole[rnum].CurrentMP || Rrole[rnum].CurrentMP <= 0)
        Phyfee = 10;
    else
        Phyfee = Rrole[rnum].MaxMP / Rrole[rnum].CurrentMP;
    Rrole[rnum].PhyPower -= Phyfee;
    if (Rrole[rnum].PhyPower < 0) Rrole[rnum].PhyPower = 0;

    // 消耗内力
    Rrole[rnum].CurrentMP -= Rmagic[mnum].NeedMP * level;
    if (Rrole[rnum].CurrentMP < 0)
    {
        Rrole[rnum].CurrentMP = 0;
        level = 0;
    }
    // 消耗自身生命
    Rrole[rnum].CurrentHP -= Rmagic[mnum].NeedHP * level;
    if (Rrole[rnum].CurrentHP < 0) Rrole[rnum].CurrentHP = 1;
    if (Rrole[rnum].CurrentHP > Rrole[rnum].MaxHP) Rrole[rnum].CurrentHP = Rrole[rnum].MaxHP;

    // 出手经验
    switch (MODVersion)
    {
    case 13: Brole[bnum].ExpGot += 1 + rand() % 10; break;
    default: Brole[bnum].ExpGot += 40 + rand() % 10; break;
    }

    // 震动效果
    if ((Rmagic[mnum].Attack[0] + (Rmagic[mnum].Attack[1] - Rmagic[mnum].Attack[0]) * level / 10 > 1000)
        && Rrole[rnum].Attack > 600)
        needOffset = 1;

    if (!UseSpecialAbility(bnum, mnum, level))
    {
        // 内功加成
        double p = 1;
        int lastng = -1;
        for (int i = 0; i < 4; i++)
        {
            int neinum = Rrole[rnum].NeiGong[i];
            if (neinum <= 0) break;
            int neilevel = Rrole[rnum].NGLevel[i] / 100 + 1;
            if ((Rmagic[neinum].MoveDistance[0] == 6 || Rmagic[neinum].MoveDistance[0] == Rmagic[mnum].MagicType)
                && Rmagic[neinum].MoveDistance[1] >= Rmagic[mnum].Attack[1] / 100)
            {
                double np = (100 + Rmagic[neinum].MoveDistance[2] + (Rmagic[neinum].MoveDistance[3] - Rmagic[neinum].MoveDistance[2]) * neilevel / 10.0) / 100.0;
                if (np > p)
                {
                    p = np;
                    lastng = neinum;
                }
            }
            if (Rmagic[neinum].AttDistance[4] == mnum)
                ShowStringOnBrole(std::string(Rmagic[neinum].Name) + "·威力", bnum, 3);
            if (Rmagic[neinum].AttDistance[7] > 0)
                ShowStringOnBrole(std::string(Rmagic[neinum].Name) + "·威力", bnum, 3);
            if (Rmagic[neinum].AttDistance[9] > 0)
                ShowStringOnBrole(std::string(Rmagic[neinum].Name) + "·神威", bnum, 3);
            if (Rmagic[neinum].MoveDistance[8] > 0)
                ShowStringOnBrole(std::string(Rmagic[neinum].Name) + "·輕力", bnum, 3);
            if (Rmagic[neinum].MoveDistance[6] > 0)
                ShowStringOnBrole(std::string(Rmagic[neinum].Name) + "·強内", bnum, 3);
        }
        if (lastng > 0)
            ShowStringOnBrole(std::string(Rmagic[lastng].Name) + "·加力", bnum, 3);

        ShowMagicName(mnum);
        PlaySoundA(Rmagic[mnum].SoundNum, 0);
        PlayActionAmination(bnum, Rmagic[mnum].MagicType);
        CalHurtRole(bnum, mnum, level, 1);
        PlayMagicAmination(bnum, Rmagic[mnum].AmiNum);
        ShowHurtValue(Rmagic[mnum].HurtType);
        if (Rmagic[mnum].NeedItem >= 0)
            instruct_32(Rmagic[mnum].NeedItem, -Rmagic[mnum].NeedItemAmount);
    }

    // 被攻击后的效果检查
    auto sign = [](int x) -> int { return (x > 0) - (x < 0); };
    for (int i = 0; i < BRoleAmount; i++)
    {
        if (Brole[i].Dead == 0)
        {
            if (Rmagic[mnum].HurtType == 0)
            {
                // 8号状态: 风雷, 攻击后直线敌人后移
                if (Brole[bnum].StateLevel[8] > 0 && Brole[bnum].Team != Brole[i].Team)
                {
                    if (BField[4][Brole[i].X][Brole[i].Y] > 0
                        && (Brole[i].X == Bx || Brole[i].Y == By))
                    {
                        int incx = sign(Brole[i].X - Bx);
                        int incy = sign(Brole[i].Y - By);
                        int aimx = Brole[i].X;
                        int aimy = Brole[i].Y;
                        for (int j = 0; j < Brole[bnum].StateLevel[8]; j++)
                        {
                            if (BField[2][aimx + incx][aimy + incy] == -1
                                && BField[1][aimx + incx][aimy + incy] == 0)
                            {
                                aimx += incx;
                                aimy += incy;
                            }
                            else break;
                        }
                        BField[2][Brole[i].X][Brole[i].Y] = -1;
                        Brole[i].X = aimx;
                        Brole[i].Y = aimy;
                        BField[2][aimx][aimy] = i;
                    }
                }
            }
        }
    }
}

void ShowMagicName(int mnum, const std::string& str)
{
    std::string name = str;
    uint32 color1, color2;
    Redraw();
    if (name.empty() && mnum >= 0 && mnum < 1000)
    {
        name = Rmagic[mnum].Name;
        color1 = ColColor(0x14);
        color2 = ColColor(0x16);
    }
    else
    {
        int mode = mnum;
        std::string str0;
        SelectColor(mode, color1, color2, str0);
    }
    int l = DrawLength(name);
    DrawTextWithRect(name, CENTER_X - l * 5 - 24, CENTER_Y - 150, 0, color1, color2, 230);
    UpdateAllScreen();
    SDL_Delay(400);
    event.key.key = 0;
    event.button.button = 0;
}

int SelectMagic(int rnum)
{
    int menuStatus = 0;
    int maxi = 0;
    int h = 28;
    std::string menuString[10], menuEngString[10];

    for (int i = 0; i < 10; i++)
    {
        if (Rrole[rnum].Magic[i] > 0)
        {
            int mnum = Rrole[rnum].Magic[i];
            if ((Rmagic[mnum].NeedItem < 0
                || (Rmagic[mnum].NeedItem >= 0 && Rmagic[mnum].NeedItemAmount <= GetItemAmount(Rmagic[mnum].NeedItem)))
                && Rmagic[mnum].NeedMP <= Rrole[rnum].CurrentMP)
            {
                menuStatus |= (1 << i);
                menuString[i] = Rmagic[mnum].Name;
                auto buf = std::format("{:3d}", Rrole[rnum].MagLevel[i] / 100 + 1);
                menuEngString[i] = buf;
                maxi++;
            }
        }
    }
    maxi--;

    Redraw();
    ShowSimpleStatus(rnum, 80, CENTER_Y * 2 - 150);
    RecordFreshScreen(100, 50, 200, 300);
    UpdateAllScreen();

    int menu = 0;
    if (maxi < 0)
    {
        std::string str = "內力不足以發動任何武學！";
        DrawTextWithRect(str, 100, 50, 0, 0, 0x202020, 255, 0);
        UpdateAllScreen();
        WaitAnyKey();
        FreeFreshScreen();
        return -1;
    }

    // ShowMagicMenu inline
    auto showMenu = [&](int ms, int sel, int mx) {
        LoadFreshScreen(100, 50);
        int p = 0;
        for (int i = 0; i < 10; i++)
        {
            if (ms & (1 << i))
            {
                if (p == sel)
                {
                    DrawTextFrame(103, 50 + h * p, 15);
                    DrawShadowText(menuString[i], 122, 53 + h * p, ColColor(0x64), ColColor(0x66));
                    DrawEngShadowText(menuEngString[i], 242, 53 + h * p, ColColor(0x64), ColColor(0x66));
                }
                else
                {
                    DrawTextFrame(103, 50 + h * p, 15, 204);
                    DrawShadowText(menuString[i], 122, 53 + h * p, 0, 0x202020);
                    DrawEngShadowText(menuEngString[i], 242, 53 + h * p, 0, 0x202020);
                }
                p++;
            }
        }
        UpdateAllScreen();
    };

    showMenu(menuStatus, menu, maxi);
    while (SDL_WaitEvent(&event))
    {
        CheckBasicEvent();
        if (event.type == SDL_EVENT_KEY_UP)
        {
            if (event.key.key == SDLK_RETURN || event.key.key == SDLK_SPACE)
                break;
            if (event.key.key == SDLK_ESCAPE)
            {
                menu = -1;
                break;
            }
        }
        if (event.type == SDL_EVENT_KEY_DOWN)
        {
            if (event.key.key == SDLK_UP)
            {
                menu--;
                if (menu < 0) menu = maxi;
                showMenu(menuStatus, menu, maxi);
            }
            if (event.key.key == SDLK_DOWN)
            {
                menu++;
                if (menu > maxi) menu = 0;
                showMenu(menuStatus, menu, maxi);
            }
        }
        if (event.type == SDL_EVENT_MOUSE_BUTTON_UP)
        {
            if (event.button.button == SDL_BUTTON_LEFT && menu != -1)
                break;
            if (event.button.button == SDL_BUTTON_RIGHT)
            {
                menu = -1;
                break;
            }
        }
        if (event.type == SDL_EVENT_MOUSE_MOTION)
        {
            int xm, ym;
            if (MouseInRegion(100, 50, 190, maxi * h + 32, xm, ym))
            {
                int menup = menu;
                menu = (ym - 52) / h;
                if (menu > maxi) menu = maxi;
                if (menu < 0) menu = 0;
                if (menup != menu)
                    showMenu(menuStatus, menu, maxi);
            }
        }
    }

    int result = menu;
    if (result >= 0)
    {
        int p = 0;
        for (int i = 0; i < 10; i++)
        {
            if (menuStatus & (1 << i))
            {
                p++;
                if (p > menu)
                {
                    result = i;
                    break;
                }
            }
        }
    }
    FreeFreshScreen();
    return result;
}

void SetAminationPosition(int mode, int step, int range, int aimMode)
{
    SetAminationPosition(Bx, By, Ax, Ay, mode, step, range, aimMode);
}

void SetAminationPosition(int bx0, int by0, int ax0, int ay0, int mode, int step, int range, int aimMode)
{
    auto sign = [](int x) { return (x > 0) - (x < 0); };
    memset(&BField[4][0][0], 0, 64 * 64 * sizeof(int16_t));
    int bnum = BField[2][bx0][by0];
    switch (aimMode)
    {
    case 2: case 3: case 6:
        if (bnum >= 0)
            for (int i = 0; i < BRoleAmount; i++)
            {
                if (Brole[i].Dead == 0 &&
                    ((aimMode == 2 && Brole[bnum].Team != Brole[i].Team) ||
                     (aimMode == 3 && Brole[bnum].Team == Brole[i].Team) ||
                     (aimMode == 6)))
                    BField[4][Brole[i].X][Brole[i].Y] = 1 + rand() % 6;
            }
        break;
    case 4:
        BField[4][bx0][by0] = 1;
        break;
    case 0: case 1: case 5:
        switch (mode)
        {
        case 0: case 6: // 目标系点型/菱型/远程
        {
            int dis = range;
            for (int i1 = std::max(ax0 - dis, 0); i1 <= std::min(ax0 + dis, 63); i1++)
            {
                int dis0 = abs(i1 - ax0);
                for (int i2 = std::max(ay0 - dis + dis0, 0); i2 <= std::min(ay0 + dis - dis0, 63); i2++)
                    BField[4][i1][i2] = (abs(i1 - bx0) + abs(i2 - by0)) * 2 + 1;
            }
            break;
        }
        case 3: // 目标系方型/原地系方型
        {
            for (int i1 = std::max(ax0 - range, 0); i1 <= std::min(ax0 + range, 63); i1++)
                for (int i2 = std::max(ay0 - range, 0); i2 <= std::min(ay0 + range, 63); i2++)
                {
                    if (MODVersion == 81)
                        BField[4][i1][i2] = 1;
                    else
                        BField[4][i1][i2] = abs(i1 - bx0) + abs(i2 - by0) * 2 + rand() % 24 + 1;
                }
            break;
        }
        case 1: // 方向系线型
        {
            int i = 1;
            int i1 = sign(ax0 - bx0);
            int i2 = sign(ay0 - by0);
            if (i1 > 0) step = std::min(63 - bx0, step);
            if (i2 > 0) step = std::min(63 - by0, step);
            if (i1 < 0) step = std::min(bx0, step);
            if (i2 < 0) step = std::min(by0, step);
            if (i1 == 0 && i2 == 0) step = 0;
            while (i <= step)
            {
                BField[4][bx0 + i1 * i][by0 + i2 * i] = i * 2 + 1;
                i++;
            }
            break;
        }
        case 2: // 原地系十型/叉型/米型
        {
            for (int i1 = std::max(bx0 - step, 0); i1 <= std::min(bx0 + step, 63); i1++)
                BField[4][i1][by0] = abs(i1 - bx0) * 4;
            for (int i2 = std::max(by0 - step, 0); i2 <= std::min(by0 + step, 63); i2++)
                BField[4][bx0][i2] = abs(i2 - by0) * 4;
            for (int i = 1; i <= range; i++)
            {
                for (int i1 = -i; i1 <= i; i1 += 2 * i)
                    for (int i2 = -i; i2 <= i; i2 += 2 * i)
                    {
                        int xx = bx0 + i1, yy = by0 + i2;
                        if (xx >= 0 && xx <= 63 && yy >= 0 && yy <= 63)
                            BField[4][xx][yy] = 2 * i * 2 + 1;
                    }
            }
            break;
        }
        case 4: // 方向系菱型
        {
            int step1 = (step + 1) / 2;
            int ax1 = bx0 + sign(ax0 - bx0) * step1;
            int ay1 = by0 + sign(ay0 - by0) * step1;
            int dis = step / 2;
            for (int i1 = std::max(ax1 - dis, 0); i1 <= std::min(ax1 + dis, 63); i1++)
            {
                int dis0 = abs(i1 - ax1);
                for (int i2 = std::max(ay1 - dis + dis0, 0); i2 <= std::min(ay1 + dis - dis0, 63); i2++)
                {
                    if (abs(i1 - bx0) != abs(i2 - by0))
                        BField[4][i1][i2] = abs(i1 - bx0) + abs(i2 - by0) * 2 + 1;
                }
            }
            break;
        }
        case 5: // 方向系角型
        {
            int ax1 = bx0 + sign(ax0 - bx0) * step;
            int ay1 = by0 + sign(ay0 - by0) * step;
            int dis = step;
            for (int i1 = std::max(ax1 - dis, 0); i1 <= std::min(ax1 + dis, 63); i1++)
            {
                int dis0 = abs(i1 - ax1);
                for (int i2 = std::max(ay1 - dis + dis0, 0); i2 <= std::min(ay1 + dis - dis0, 63); i2++)
                {
                    if (i1 >= 0 && i1 <= 63 && i2 >= 0 && i2 <= 63 && abs(i1 - bx0) <= step && abs(i2 - by0) <= step)
                        BField[4][i1][i2] = abs(i1 - bx0) + abs(i2 - by0) * 2 + 1;
                }
            }
            break;
        }
        default: break;
        }
        break;
    default: break;
    }
}

void PlayMagicAmination(int bnum, int eNum, int aimMode, int mode)
{
    int minVal = 1000, maxVal = 0;
    for (int i1 = 0; i1 < 64; i1++)
        for (int i2 = 0; i2 < 64; i2++)
        {
            if (BField[4][i1][i2] > 0)
            {
                if (BField[4][i1][i2] > maxVal) maxVal = BField[4][i1][i2];
                if (BField[4][i1][i2] < minVal) minVal = BField[4][i1][i2];
            }
        }

    TPosition posA = GetPositionOnScreen(Ax, Ay, CENTER_X, CENTER_Y);
    TPosition posB = GetPositionOnScreen(Bx, By, CENTER_X, CENTER_Y);
    int x = posA.x - posB.x;
    int y = posB.y - posA.y;
    int z = -((Ax + Ay) - (Bx + By)) * 9;
    PlaySound(eNum, 0, x, y, z);

    if (CellPhone == 1 && needOffset != 0)
        SDL_PlayHapticRumble(haptic, 0.5f, 2000);

    int rnum = Brole[bnum].rnum;
    int endpic = 0;
    if (eNum >= 0 && eNum <= 200)
    {
        if (EPNGIndex[eNum].Loaded == 0)
        {
            auto buf = std::format("resource/eft/eft{:03d}", eNum);
            EPNGIndex[eNum].Amount = LoadPNGTiles(buf, EPNGIndex[eNum].PNGIndexArray, 1);
            EPNGIndex[eNum].Loaded = 1;
        }
        endpic = EPNGIndex[eNum].Amount;
    }
    Redraw();
    int i = 0;
    if (endpic > 0)
    {
        while (SDL_PollEvent(&event) || true)
        {
            CheckBasicEvent();
            DrawBFieldWithEft(i, 0, endpic, minVal, bnum, aimMode, mode, 0xFFFFFFFF, eNum);
            UpdateAllScreen();
            SDL_Delay(BATTLE_SPEED);
            i++;
            if (i > endpic + maxVal - minVal) break;
        }
    }
    needOffset = 0;
    event.key.key = 0;
    event.button.button = 0;
}

void CalHurtRole(int bnum, int mnum, int level, int mode)
{
    int rnum = Brole[bnum].rnum;
    for (int i = 0; i < BRoleAmount; i++)
    {
        if (BField[4][Brole[i].X][Brole[i].Y] > 0 && Brole[bnum].Team != Brole[i].Team
            && Brole[i].Dead == 0 && bnum != i)
        {
            Brole[i].ShowNumber = -1;
            // 生命伤害
            if (Rmagic[mnum].HurtType == 0 || Rmagic[mnum].HurtType == 6)
            {
                int hurt = CalHurtValue(bnum, i, mnum, level, mode) + Brole[bnum].AntiHurt;
                // 刀系福利
                if (Rmagic[mnum].MagicType == 3 && rand() % 1000 < Rrole[rnum].Knife * (100 + Brole[bnum].StateLevel[31]) / 100)
                    hurt = std::min(9999, (int)(hurt * (15 + rand() % 16) / 10));
                // 拳系福利
                if (Rmagic[mnum].MagicType == 1 && rand() % 1000 < Rrole[rnum].Fist * (100 + Brole[bnum].StateLevel[29]) / 100)
                {
                    if (rand() % 100 < 30) ModifyState(i, 0, -30, 3);
                    if (rand() % 100 < 30) ModifyState(i, 1, -30, 3);
                    if (rand() % 100 < 30) ModifyState(i, 2, -30, 3);
                }
                // 特系福利
                if (Rmagic[mnum].MagicType == 4 && rand() % 5000 < Rrole[rnum].Unusual * (100 + Brole[bnum].StateLevel[32]) / 100)
                    ModifyState(bnum, 16, 20, 3);
                // 暗系福利
                if (Rmagic[mnum].MagicType == 5 && rand() % 100 < 10 + Brole[bnum].StateLevel[33])
                    ModifyState(i, 3, -(Rrole[rnum].HidWeapon / 200), 3);

                // 状态4: 受伤害增减
                hurt = (100 - Brole[i].StateLevel[4]) * hurt / 100;

                // 状态15: 灵精, 内力代替
                if (rand() % 100 < Brole[i].StateLevel[15])
                {
                    Rrole[Brole[i].rnum].CurrentMP -= hurt;
                    if (Rrole[Brole[i].rnum].CurrentMP <= 0) Rrole[Brole[i].rnum].CurrentMP = 0;
                    Brole[i].ShowNumber = hurt;
                    hurt = 0;
                }

                // 状态14: 反伤
                if (Brole[i].StateLevel[14] > Brole[bnum].StateLevel[14])
                {
                    int hurt1 = hurt * (Brole[i].StateLevel[14] - Brole[bnum].StateLevel[14]) / 100;
                    hurt = std::max(hurt - hurt1, 0);
                    Brole[i].ShowNumber = hurt;
                    Brole[bnum].ShowNumber = hurt1;
                    Brole[bnum].AntiHurt = hurt1;
                    Rrole[Brole[bnum].rnum].CurrentHP -= hurt1;
                    BField[4][Brole[bnum].X][Brole[bnum].Y] = 20;
                }

                // 状态16: 闪避
                if (rand() % 100 < Brole[i].StateLevel[16])
                {
                    hurt = std::min(1, hurt);
                    Brole[i].ShowNumber = hurt;
                }

                // 吸星融功法
                for (int i1 = 0; i1 < 4; i1++)
                {
                    int neinum = Rrole[Brole[i].rnum].NeiGong[i1];
                    if (neinum <= 0) break;
                    if (Rmagic[neinum].AddMP[3] > 0)
                    {
                        hurt /= 2;
                        Rrole[Brole[i].rnum].CurrentMP += hurt;
                        if (mode == 1)
                            ShowStringOnBrole(std::string(Rmagic[neinum].Name) + "·融功", i, 1);
                        if (Rrole[Brole[i].rnum].CurrentMP > Rrole[Brole[i].rnum].MaxMP)
                            Rrole[Brole[i].rnum].CurrentMP = Rrole[Brole[i].rnum].MaxMP;
                    }
                }

                // 情侣替代受伤
                if (Brole[i].loverlevel[6] > 0)
                {
                    int bnum1 = getBnum(Brole[i].loverlevel[6]);
                    if (bnum1 >= 0 && Brole[bnum1].Dead == 0)
                    {
                        Brole[bnum1].ShowNumber = hurt;
                        Rrole[Brole[i].loverlevel[6]].CurrentHP -= hurt;
                        BField[4][Brole[bnum1].X][Brole[bnum1].Y] = 1;
                        hurt = 0;
                        Brole[i].ShowNumber = 0;
                    }
                }
                else
                {
                    // 慈悲状态
                    if (Brole[i].StateRound[23] > 0)
                    {
                        int bnum1 = getBnum(Brole[i].StateLevel[23]);
                        Brole[bnum1].ShowNumber += hurt;
                        BField[4][Brole[bnum1].X][Brole[bnum1].Y] = 1;
                        Brole[i].ShowNumber = 0;
                        Rrole[Brole[bnum1].rnum].CurrentHP -= hurt;
                        Rrole[Brole[bnum1].rnum].Hurt += hurt * 100 / Rrole[Brole[bnum1].rnum].MaxHP / LIFE_HURT;
                    }
                    else
                    {
                        // 内功影响
                        for (int i1 = 0; i1 < 4; i1++)
                        {
                            int neinum = Rrole[Brole[bnum].rnum].NeiGong[i1];
                            if (neinum <= 0) break;
                            int neilevel = Rrole[Brole[bnum].rnum].NGLevel[i1] / 100 + 1;
                            if (Rmagic[neinum].AttDistance[6] > 0)
                            {
                                Rrole[Brole[i].rnum].PhyPower -= Rmagic[neinum].AttDistance[6] * neilevel;
                                if (mode == 1)
                                    ShowStringOnBrole(std::string(Rmagic[neinum].Name) + "·殺體", i, 2);
                                if (Rrole[Brole[i].rnum].PhyPower < 1) Rrole[Brole[i].rnum].PhyPower = 1;
                            }
                            if (Rmagic[neinum].AttDistance[8] > 0)
                            {
                                Rrole[Brole[i].rnum].CurrentMP -= Rmagic[neinum].AttDistance[8] * neilevel;
                                if (mode == 1)
                                    ShowStringOnBrole(std::string(Rmagic[neinum].Name) + "·殺内", i, 1);
                                if (Rrole[Brole[i].rnum].CurrentMP < 1) Rrole[Brole[i].rnum].CurrentMP = 1;
                            }
                            if (Rmagic[neinum].AddMP[2] == 4)
                            {
                                Rrole[Brole[i].rnum].Hurt += 3 * neilevel;
                                if (mode == 1)
                                    ShowStringOnBrole(std::string(Rmagic[neinum].Name) + "·重傷", i, 1);
                                if (Rrole[Brole[i].rnum].Hurt > 100) Rrole[Brole[i].rnum].Hurt = 100;
                            }
                        }
                        // 普通减血
                        Brole[i].ShowNumber += hurt;
                        Rrole[Brole[i].rnum].CurrentHP -= hurt;
                        Rrole[Brole[i].rnum].Hurt += hurt * 100 / Rrole[Brole[i].rnum].MaxHP / LIFE_HURT;
                    }
                    if (Rrole[Brole[i].rnum].Hurt > 99) Rrole[Brole[i].rnum].Hurt = 99;
                }
                // 击杀经验
                if (Rrole[Brole[i].rnum].CurrentHP <= 0)
                {
                    Rrole[Brole[i].rnum].CurrentHP = 0;
                    switch (MODVersion)
                    {
                    case 13: Brole[bnum].ExpGot += 30 + rand() % 20; break;
                    default: Brole[bnum].ExpGot += 300 + rand() % 20 * 10; break;
                    }
                }
            }
            // 内力伤害
            if (Rmagic[mnum].HurtType == 1 || Rmagic[mnum].HurtType == 6)
            {
                int hurt = Rmagic[mnum].HurtMP[level - 1] + rand() % 5 - rand() % 5;
                if (Rmagic[mnum].HurtType != 6)
                    Brole[i].ShowNumber += hurt;
                Rrole[Brole[i].rnum].CurrentMP -= hurt;
                if (Rrole[Brole[i].rnum].CurrentMP <= 0) Rrole[Brole[i].rnum].CurrentMP = 0;
                Rrole[rnum].CurrentMP += hurt;
                Rrole[rnum].MaxMP += rand() % (hurt / 2 + 1);
                if (Rrole[rnum].MaxMP > MAX_MP) Rrole[rnum].MaxMP = MAX_MP;
                if (Rrole[rnum].CurrentMP > Rrole[rnum].MaxMP) Rrole[rnum].CurrentMP = Rrole[rnum].MaxMP;
            }
            // 中毒
            int addpoi = Rrole[rnum].AttPoi / 5 + Rmagic[mnum].Poison * level / 2 - Rrole[Brole[i].rnum].DefPoi - Brole[i].loverlevel[3];
            if (Rmagic[mnum].AttAreaType == 6 && Brole[bnum].StateLevel[11] > 0)
                addpoi += Brole[bnum].StateLevel[11];
            if (addpoi + Rrole[Brole[i].rnum].Poison > 99)
                addpoi = 99 - Rrole[Brole[i].rnum].Poison;
            if (addpoi < 0) addpoi = 0;
            if (Rrole[Brole[i].rnum].DefPoi + Brole[i].loverlevel[3] >= 99) addpoi = 0;
            Rrole[Brole[i].rnum].Poison += addpoi;
        }
        if (Brole[bnum].AntiHurt > 0) Brole[bnum].AntiHurt = 0;
    }
}

int CalHurtValue(int bnum1, int bnum2, int mnum, int level, int mode)
{
    int rnum1 = Brole[bnum1].rnum;
    int rnum2 = Brole[bnum2].rnum;
    TRole R1 = Rrole[rnum1], R2 = Rrole[rnum2];
    auto& B1 = Brole[bnum1];
    auto& B2 = Brole[bnum2];

    int R1Att = std::max(0, R1.Attack * (100 + B1.StateLevel[0] + B1.loverlevel[0]) / 100);
    int R2Def = std::max(0, R2.Defence * (100 + B2.StateLevel[1] + B2.loverlevel[1]) / 100);

    // 武器增加攻击
    if (R1.Equip[0] >= 0)
    {
        R1Att += Ritem[R1.Equip[0]].AddAttack;
        for (int i = 0; i < 5; i++)
            if (Ritem[R1.Equip[0]].GetItem[i] == mnum) { R1Att += Ritem[R1.Equip[0]].NeedMatAmount[i]; break; }
    }
    if (R1.Equip[1] >= 0) R1Att += Ritem[R1.Equip[1]].AddAttack;
    if (R2.Equip[0] >= 0) R2Def += Ritem[R2.Equip[0]].AddDefence;
    if (R2.Equip[1] >= 0) R2Def += Ritem[R2.Equip[1]].AddDefence;

    // 状态9: 孤注一掷
    if (B1.StateLevel[9] > 0)
        R1Att = R1Att * (R1.MaxHP * 2 - R1.CurrentHP) / R1.MaxHP;

    // 武学常识
    int k1 = 0, k2 = 0;
    for (int i = 0; i < BRoleAmount; i++)
    {
        if (Brole[i].Team == B1.Team && Brole[i].Dead == 0 && Rrole[Brole[i].rnum].Knowledge > MIN_KNOWLEDGE)
            k1 += Rrole[Brole[i].rnum].Knowledge;
        if (Brole[i].Team == B2.Team && Brole[i].Dead == 0 && Rrole[Brole[i].rnum].Knowledge > MIN_KNOWLEDGE)
            k2 += Rrole[Brole[i].rnum].Knowledge;
    }
    // 状态10: 倾国
    for (int i = 0; i < BRoleAmount; i++)
    {
        if (Brole[i].Dead == 0 && Brole[i].StateLevel[10] > 0)
        {
            if (Brole[i].Team == B1.Team) k1 += Brole[i].StateLevel[10];
            else if (Brole[i].Team == B2.Team) k2 += Brole[i].StateLevel[10];
        }
    }

    // 武功伤害
    int mhurt = Rmagic[mnum].Attack[0] + (Rmagic[mnum].Attack[1] - Rmagic[mnum].Attack[0]) * level / 10;

    // 内功加成
    double p = 1, p2 = 1, p3 = 1, p4 = 1;
    for (int i = 0; i < 4; i++)
    {
        int neinum = Rrole[rnum1].NeiGong[i];
        if (neinum <= 0) break;
        int neilevel = Rrole[rnum1].NGLevel[i] / 100 + 1;
        if ((Rmagic[neinum].MoveDistance[0] == 6 || Rmagic[neinum].MoveDistance[0] == Rmagic[mnum].MagicType)
            && Rmagic[neinum].MoveDistance[1] >= Rmagic[mnum].Attack[1] / 100)
        {
            double np = (100 + Rmagic[neinum].MoveDistance[2] + (Rmagic[neinum].MoveDistance[3] - Rmagic[neinum].MoveDistance[2]) * neilevel / 10.0) / 100.0;
            if (np > p) p = np;
        }
        if (Rmagic[neinum].AttDistance[4] == mnum) p2 = 1 + 0.1 * neilevel;
        if (Rmagic[neinum].AttDistance[7] > 0) p3 = (Rmagic[neinum].AttDistance[7] * Rrole[rnum1].Aptitude) / 100.0;
        if (Rmagic[neinum].AttDistance[9] > 0)
        {
            int livenum = 0;
            for (int j = 0; j < BRoleAmount; j++)
                if (Brole[j].Team == B1.Team && Brole[j].Dead == 0) livenum++;
            p4 = 1 + livenum * 0.05 * Rmagic[neinum].AttDistance[9];
        }
    }
    mhurt = (int)(mhurt * p * p2 * p3 * p4);

    // 情侣技加成
    if (B1.loverlevel[4] > 0) mhurt = mhurt * (100 + B1.loverlevel[4]) / 100;

    // 轻功加成
    if (Rmagic[mnum].Attack[3] > 0)
    {
        double sp = (R1.Speed * (B1.StateLevel[2] + Rmagic[mnum].Attack[3]) / 100.0 / 500.0) + 1;
        for (int i = 0; i < 4; i++)
        {
            int neinum = R1.NeiGong[i];
            if (neinum <= 0) break;
            int neilevel = R1.NGLevel[i] / 100 + 1;
            if (Rmagic[neinum].MoveDistance[8] > 0)
                sp *= (100 + Rmagic[neinum].MoveDistance[8] + (Rmagic[neinum].MoveDistance[9] - Rmagic[neinum].MoveDistance[8]) * neilevel / 10.0) / 100.0;
        }
        mhurt = (int)(mhurt * sp);
    }
    // 内力加成
    if (Rmagic[mnum].Attack[2] > 0)
    {
        double mp = (R1.MaxMP * (Rmagic[mnum].Attack[2] + B1.loverlevel[5]) / 100.0 / 9999.0) + 1;
        for (int i = 0; i < 4; i++)
        {
            int neinum = R1.NeiGong[i];
            if (neinum <= 0) break;
            int neilevel = R1.NGLevel[i] / 100 + 1;
            if (Rmagic[neinum].MoveDistance[6] > 0)
                mp *= (100 + Rmagic[neinum].MoveDistance[6] + (Rmagic[neinum].MoveDistance[7] - Rmagic[neinum].MoveDistance[6]) * neilevel / 10.0) / 100.0;
        }
        mhurt = (int)(mhurt * mp);
    }

    // 总攻击
    int att, def;
    if (Rmagic[mnum].MagicType == 5)
        att = k1 + R1.HidWeapon * 2 + mhurt / 2;
    else
        att = k1 + R1Att + mhurt / 2;

    def = R2Def;
    // 内功防御加成
    for (int i = 0; i < 4; i++)
    {
        int neinum = R2.NeiGong[i];
        if (neinum <= 0) break;
        int neilevel = R2.NGLevel[i] / 100 + 1;
        if (Rmagic[neinum].MoveDistance[4] > 0)
        {
            def = def * (100 + Rmagic[neinum].MoveDistance[4] + (Rmagic[neinum].MoveDistance[5] - Rmagic[neinum].MoveDistance[4]) * neilevel / 10) / 100;
            if (mode == 1) ShowStringOnBrole(std::string(Rmagic[neinum].Name) + "·剛體", bnum2, 3);
        }
    }
    def += k2;

    att = att * (100 - Rrole[rnum1].Hurt / 2) / 100;
    def = def * (100 - Rrole[rnum2].Hurt / 2) / 100;
    att = std::max(att, 0);
    def = std::max(def, 0);

    int result;
    if (att + def > 0)
        result = (int)(1.0 * att * att / (att + def) / 2 + rand() % 10 - rand() % 10);
    else
        result = 10 + rand() % 10 - rand() % 10;

    // 距离衰减
    int dis = abs(B1.X - B2.X) + abs(B1.Y - B2.Y);
    if (dis > 10) dis = 10;
    result = result * (100 - (dis - 1) * 3) / 100;

    // 轻功闪避
    int speed1 = R1.Speed * (100 + B1.StateLevel[2] + B1.loverlevel[9]) / 100;
    int speed2 = R2.Speed * (100 + B2.StateLevel[2] + B2.loverlevel[9]) / 100;
    if (speed2 >= speed1)
    {
        double sp = 1 - ((speed2 - speed1) / 360.0);
        if (sp < 0) sp = 0;
        result = (int)(result * sp);
    }

    if (result <= 10 || level <= 0) result = rand() % 10 + 1;
    if (result > 9999) result = 9999;
    return result;
}

int CalHurtValue2(int bnum1, int bnum2, int mnum, int level, int mode)
{
    return CalHurtValue(bnum1, bnum2, mnum, level, mode);
}

void SelectColor(int mode, uint32& color1, uint32& color2, std::string& formatstr)
{
    switch (mode)
    {
    case 0: case 6: color1 = ColColor(0x10); color2 = ColColor(0x13); formatstr = "-{}"; break;
    case 1: color1 = ColColor(0x50); color2 = ColColor(0x53); formatstr = "-{}"; break;
    case 2: color1 = ColColor(0x30); color2 = ColColor(0x32); formatstr = "+{}"; break;
    case 3: color1 = ColColor(0x07); color2 = ColColor(0x05); formatstr = "+{}"; break;
    case 4: color1 = ColColor(0x91); color2 = ColColor(0x93); formatstr = "-{}"; break;
    default: color1 = ColColor(0x14); color2 = ColColor(0x16); formatstr = ""; break;
    }
}

void ShowHurtValue(int mode, int team, const std::string& fstr)
{
    uint32 color1, color2;
    std::string formatstr;
    SelectColor(mode, color1, color2, formatstr);
    if (!fstr.empty()) formatstr = fstr;

    std::vector<std::string> word(BRoleAmount);
    for (int i = 0; i < BRoleAmount; i++)
    {
        if (Brole[i].ShowNumber > 0)
        {
            std::string fmt = formatstr;
            if (mode == 5)
                fmt = (Brole[i].Team == team) ? "+{}" : "-{}";
            if (fmt.find("{}") != std::string::npos)
                word[i] = std::vformat(fmt, std::make_format_args(Brole[i].ShowNumber));
            else
                word[i] = fmt + std::to_string(Brole[i].ShowNumber);
        }
        Brole[i].ShowNumber = -1;
    }
    int i1 = 0;
    while (SDL_PollEvent(&event) || true)
    {
        CheckBasicEvent();
        Redraw();
        for (int i = 0; i < BRoleAmount; i++)
        {
            if (mode == 5)
            {
                if (Brole[i].Team == team) { color1 = ColColor(0x7); color2 = ColColor(0x5); }
                else { color1 = ColColor(0x10); color2 = ColColor(0x13); }
            }
            int x = -(Brole[i].X - Bx) * 18 + (Brole[i].Y - By) * 18 + CENTER_X - 5 * (int)word[i].size();
            int y = (Brole[i].X - Bx) * 9 + (Brole[i].Y - By) * 9 + CENTER_Y - 40;
            if (!word[i].empty())
                DrawEngShadowText(word[i], x, y - i1 * 2, color1, color2);
        }
        SDL_Delay(BATTLE_SPEED);
        UpdateAllScreen();
        i1++;
        if (i1 > 10) break;
    }
    Redraw();
    UpdateAllScreen();
}

void ShowStringOnBrole(const std::string& str, int bnum, int mode, int up)
{
    if (EFFECT_STRING == 1)
    {
        auto sign = [](int x) { return (x > 0) - (x < 0); };
        SetFontSize(18, 16);
        uint32 color1, color2;
        std::string formatstr;
        SelectColor(mode, color1, color2, formatstr);
        int len = DrawLength(str.c_str());
        int x = -(Brole[bnum].X - Bx) * 18 + (Brole[bnum].Y - By) * 18 + CENTER_X - 10;
        int y = (Brole[bnum].X - Bx) * 9 + (Brole[bnum].Y - By) * 9 + CENTER_Y - 40;
        int i1 = 0;
        int i2 = 5 - sign(up) * 5;
        while (SDL_PollEvent(&event) || true)
        {
            CheckBasicEvent();
            Redraw();
            DrawShadowText(str, x - 9 * len / 2 + 5, y - i2 * 2, color1, color2);
            SDL_Delay(BATTLE_SPEED);
            UpdateAllScreen();
            i1++;
            i2 += up;
            if (i1 > 10 || i2 > 10 || i2 < 0) break;
        }
        Redraw();
        SetFontSize(20, 18);
    }
}

void CalPoiHurtLife()
{
    for (int i = 0; i < BRoleAmount; i++)
    {
        Brole[i].ShowNumber = -1;
        if (Brole[i].Dead != 0) continue;
        int rnum = Brole[i].rnum;
        if (rnum < 0 || rnum >= 1000) continue;
        if (Rrole[rnum].Poison > 0 && Brole[i].Acted == 1)
        {
            Rrole[rnum].CurrentHP -= Rrole[rnum].Poison + 5 - rand() % 5;
            if (Rrole[rnum].CurrentHP <= 0)
                Rrole[rnum].CurrentHP = 1;
        }
    }
}

void ClearDeadRolePic()
{
    // 检测是否有角色需要阵亡效果
    bool needeffect = false;
    for (int i = 0; i < BRoleAmount; i++)
    {
        if (Rrole[Brole[i].rnum].CurrentHP <= 0 && Brole[i].Dead == 0)
        {
            needeffect = true;
            break;
        }
    }
    // 阵亡渐隐效果
    int j = 0;
    while ((SDL_PollEvent(&event) || true) && needeffect)
    {
        CheckBasicEvent();
        for (int i = 0; i < BRoleAmount; i++)
        {
            if (Rrole[Brole[i].rnum].CurrentHP <= 0 && Brole[i].Dead == 0)
            {
                Brole[i].mixColor = 0;
                Brole[i].mixAlpha = j;
                Brole[i].alpha = 255 - j * 255 / 100;
            }
        }
        DrawBField();
        UpdateAllScreen();
        SDL_Delay(BATTLE_SPEED / 2);
        j += 5;
        if (j > 100) break;
    }
    // 标记阵亡, 清除BField, 处理状态效果
    for (int i = 0; i < BRoleAmount; i++)
    {
        if (Rrole[Brole[i].rnum].CurrentHP <= 0)
        {
            Brole[i].Dead = 1;
            BField[2][Brole[i].X][Brole[i].Y] = -1;
            // 伤逝状态: 死亡时敌方攻击防御下降
            if (Brole[i].StateLevel[21] > 0)
            {
                Brole[i].StateLevel[21] = 0;
                for (int j2 = 0; j2 < BRoleAmount; j2++)
                {
                    if (Brole[j2].Team != Brole[i].Team && Brole[j2].Dead == 0)
                    {
                        if (Brole[j2].StateLevel[0] > 0)
                        {
                            Brole[j2].StateLevel[0] = -20;
                            Brole[j2].StateRound[0] = 3;
                        }
                        else
                        {
                            Brole[j2].StateLevel[0] -= 20;
                            Brole[j2].StateRound[0] += 3;
                        }
                        if (Brole[j2].StateLevel[1] > 0)
                        {
                            Brole[j2].StateLevel[1] = -20;
                            Brole[j2].StateRound[1] = 3;
                        }
                        else
                        {
                            Brole[j2].StateLevel[1] -= 20;
                            Brole[j2].StateRound[1] += 3;
                        }
                        Rrole[Brole[j2].rnum].Hurt += 10;
                    }
                }
            }
            // 去掉慈悲状态
            for (int j2 = 0; j2 < BRoleAmount; j2++)
            {
                if (Brole[j2].StateLevel[23] == Brole[i].rnum)
                {
                    Brole[j2].StateLevel[23] = 0;
                    Brole[j2].StateRound[23] = 0;
                }
            }
        }
    }
    // 更新存活角色的BField
    for (int i = 0; i < BRoleAmount; i++)
    {
        if (Brole[i].Dead == 0)
            BField[2][Brole[i].X][Brole[i].Y] = (int16_t)i;
    }
}

void Wait(int bnum)
{
    Brole[bnum].Acted = 0;
    Brole[BRoleAmount] = Brole[bnum];

    for (int i = bnum; i < BRoleAmount; i++)
        Brole[i] = Brole[i + 1];

    for (int i = 0; i < BRoleAmount; i++)
    {
        if (Brole[i].Dead == 0)
            BField[2][Brole[i].X][Brole[i].Y] = i;
        else
            BField[2][Brole[i].X][Brole[i].Y] = -1;
    }
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
    int levels = 0, amount = 0;
    for (int i = 0; i < BRoleAmount; i++)
    {
        if (Brole[i].Team == 0 && Brole[i].Dead == 0)
        {
            levels += Rrole[Brole[i].rnum].Level;
            amount++;
        }
    }

    TransBlackScreen();
    DrawMPic(2003, CENTER_X - 260, CENTER_Y - 240 + 15);
    int p = 0;
    for (int i = 0; i < BRoleAmount; i++)
    {
        int rnum = Brole[i].rnum;
        int basicvalue = (amount > 0) ? WarStaList[CurrentBattle].ExpGot / amount : 0;
        if (Brole[i].Team == 0 && Brole[i].Dead == 0)
        {
            int mnum = Ritem[Rrole[rnum].PracticeBook].Magic;
            int mlevel = GetMagicLevel(rnum, mnum);
            basicvalue += Brole[i].ExpGot;
            Rrole[rnum].Exp = std::min(65535, (int)Rrole[rnum].Exp + basicvalue);
            if (mlevel < 10)
                Rrole[rnum].ExpForBook += basicvalue * 4 / 5;
            if (p >= 6)
            {
                UpdateAllScreen();
                Redraw();
                p = 0;
                TransBlackScreen();
                WaitAnyKey();
            }
            int x = CENTER_X - 270 + (p % 2) * 270;
            int y = CENTER_Y - 240 + 90 + (p / 2) * 110;
            Rrole[rnum].ExpForItem += basicvalue * 3 / 5;
            ShowSimpleStatus(rnum, x, y);
            auto str = std::format("經驗+{}", basicvalue);
            DrawTextWithRect(str, x, y + 70, 0, ColColor(0x64), ColColor(0x66), 153, 0);
            p++;
        }
    }
    UpdateAllScreen();
    Redraw();
    WaitAnyKey();
}

void CheckLevelUp()
{
    for (int i = 0; i < BRoleAmount; i++)
    {
        int rnum = Brole[i].rnum;
        while ((uint16_t)Rrole[rnum].Exp >= (uint16_t)LevelUpList[Rrole[rnum].Level - 1] && Rrole[rnum].Level < MAX_LEVEL)
        {
            Rrole[rnum].Exp -= LevelUpList[Rrole[rnum].Level - 1];
            LevelUp(i, rnum);
        }
    }
}

void LevelUp(int bnum, int rnum)
{
    if (rnum < 0)
        rnum = Brole[bnum].rnum;

    if (bnum >= 0 && Brole[bnum].Team == 0)
    {
        Redraw();
        TransBlackScreen();
        ShowStatus(rnum, -1);
    }

    Rrole[rnum].Level++;
    if (Rrole[rnum].IncLife >= 8)
        Rrole[rnum].MaxHP += (Rrole[rnum].IncLife - 8 + rand() % 10) * 3;
    else
        Rrole[rnum].MaxHP += Rrole[rnum].IncLife + rand() % 5;
    if (rand() % 100 > Rrole[rnum].Aptitude)
        Rrole[rnum].MaxHP += rand() % 5;
    if (Rrole[rnum].MaxHP > MAX_HP) Rrole[rnum].MaxHP = MAX_HP;
    Rrole[rnum].CurrentHP = Rrole[rnum].MaxHP;

    if (Rrole[rnum].AddMP >= 8)
        Rrole[rnum].MaxMP += (Rrole[rnum].AddMP - 8 + rand() % 10) * 3;
    else
        Rrole[rnum].MaxMP += Rrole[rnum].AddMP + rand() % 5;
    if (rand() % 100 > Rrole[rnum].Aptitude)
        Rrole[rnum].MaxMP += rand() % 5;
    if (Rrole[rnum].MaxMP > MAX_MP) Rrole[rnum].MaxMP = MAX_MP;
    Rrole[rnum].CurrentMP = Rrole[rnum].MaxMP;

    Rrole[rnum].Attack += 3 - rand() % 2 + rand() % (std::max(1, Rrole[rnum].AddAtk));
    Rrole[rnum].Defence += 3 - rand() % 2 + rand() % (std::max(1, Rrole[rnum].AddDef));
    Rrole[rnum].Speed += 1 + rand() % (std::max(1, Rrole[rnum].AddSpeed));

    if (MODVersion == 41)
        Rrole[rnum].Movestep = Rrole[rnum].Speed * 10 / 15;

    int i1 = 54;
    if (MODVersion == 31) i1 = 49;
    for (int i = 46; i <= i1; i++)
    {
        if (Rrole[rnum].Data[i] > 20 && i != 49)
            Rrole[rnum].Data[i] += rand() % 3;
    }
    for (int i = 43; i <= i1; i++)
    {
        if (Rrole[rnum].Data[i] > MaxProList[i])
            Rrole[rnum].Data[i] = MaxProList[i];
    }

    Rrole[rnum].PhyPower = MAX_PHYSICAL_POWER;
    Rrole[rnum].Hurt = 0;
    Rrole[rnum].Poison = 0;

    if (bnum >= 0 && Brole[bnum].Team == 0)
    {
        ShowStatus(rnum, -2);
        ShowSimpleStatus(rnum, CENTER_X - 150, CENTER_Y - 240 + 10);
        UpdateAllScreen();
        WaitAnyKey();
    }
}

void CheckBook()
{
    for (int i = 0; i < BRoleAmount; i++)
    {
        int rnum = Brole[i].rnum;
        int inum = Rrole[rnum].PracticeBook;
        if (inum >= 0)
        {
            int mnum = Ritem[inum].Magic;
            int mlevel = std::max(1, GetMagicLevel(rnum, mnum));
            while (mlevel < 10)
            {
                int needexp = std::min(30000, (int)((1 + (mlevel - 1) * 0.5) * Ritem[Rrole[rnum].PracticeBook].NeedExp * (1 + (7 - Rrole[rnum].Aptitude / 15.0) * 0.5)));
                if (Rrole[rnum].ExpForBook >= needexp && mlevel < 10)
                {
                    Redraw();
                    TransBlackScreen();
                    EatOneItem(rnum, inum);
                    WaitAnyKey();
                    Redraw();
                    TransBlackScreen();
                    UpdateAllScreen();
                    if (mnum > 0)
                        instruct_33(rnum, mnum, 1);
                    mlevel++;
                    Rrole[rnum].ExpForBook -= needexp;
                }
                else
                    break;
            }

            // 是否能够炼出物品
            if (Rrole[rnum].ExpForItem >= Ritem[inum].NeedExpForItem
                && Ritem[inum].NeedExpForItem > 0 && Brole[i].Team == 0)
            {
                int p = 0;
                for (int i2 = 0; i2 < 5; i2++)
                {
                    if (Ritem[inum].GetItem[i2] >= 0)
                        p++;
                }
                p = rand() % std::max(1, p);
                int needitem = Ritem[inum].NeedMaterial;
                if (Ritem[inum].GetItem[p] >= 0)
                {
                    int needitemamount = Ritem[inum].NeedMatAmount[p];
                    int itemamount = 0;
                    for (int i2 = 0; i2 < MAX_ITEM_AMOUNT; i2++)
                    {
                        if (RItemList[i2].Number == needitem)
                        {
                            itemamount = RItemList[i2].Amount;
                            break;
                        }
                    }
                    if (needitemamount <= itemamount)
                    {
                        Redraw();
                        TransBlackScreen();
                        ShowSimpleStatus(rnum, CENTER_X - 150, CENTER_Y - 240 + 70);
                        DrawTextFrame(CENTER_X - 150, CENTER_Y - 240 + 170, 8);
                        std::string str = "製得物品";
                        DrawShadowText(str, CENTER_X - 150 + 19, CENTER_Y - 240 + 173, 0, 0x202020);
                        instruct_2(Ritem[inum].GetItem[p], 30 + rand() % 25);
                        UpdateAllScreen();
                        instruct_32(needitem, -needitemamount);
                        Rrole[rnum].ExpForItem = 0;
                    }
                }
            }
        }
    }
}

int CalRNum(int team)
{
    int count = 0;
    for (int i = 0; i < BRoleAmount; i++)
        if (Brole[i].Team == team && Brole[i].Dead == 0) count++;
    return count;
}

void BattleMenuItem(int bnum)
{
    if (MenuItem())
    {
        int inum = CurItem;
        int rnum = Brole[bnum].rnum;
        int mode = Ritem[inum].ItemType;
        switch (mode)
        {
        case 3:
            Redraw();
            TransBlackScreen();
            EatOneItem(rnum, inum);
            instruct_32(inum, -1);
            Brole[bnum].Acted = 1;
            WaitAnyKey();
            break;
        case 4:
            if (MODVersion != 13)
                UseHiddenWeapon(bnum, inum);
            break;
        }
    }
}
void UsePoison(int bnum)
{
    int rnum = Brole[bnum].rnum;
    int poi = Rrole[rnum].UsePoi;
    int step = poi / 15 + 1;
    CalCanSelect(bnum, 1, step);
    SelectAimMode = 0;
    bool select = false;
    if (Brole[bnum].Team == 0 && Brole[bnum].Auto == 0)
        select = SelectAim(bnum, step);
    else
    {
        int minDefPoi = MaxProList[49];
        for (int i = 0; i < BRoleAmount; i++)
        {
            if (Brole[i].Dead == 0 && Brole[i].Team != Brole[bnum].Team)
            {
                if (Rrole[Brole[i].rnum].DefPoi <= minDefPoi && Rrole[Brole[i].rnum].Poison < 100 && BField[3][Brole[i].X][Brole[i].Y] >= 0)
                {
                    minDefPoi = Rrole[Brole[i].rnum].DefPoi + Brole[i].loverlevel[3];
                    select = true;
                    Ax = Brole[i].X;
                    Ay = Brole[i].Y;
                }
            }
        }
    }
    if (BField[2][Ax][Ay] >= 0 && select)
    {
        Brole[bnum].Acted = 1;
        Rrole[rnum].PhyPower -= 3;
        int bnum1 = BField[2][Ax][Ay];
        if (Brole[bnum1].Team != Brole[bnum].Team)
        {
            int rnum1 = Brole[bnum1].rnum;
            int addpoi = Rrole[rnum].UsePoi / 3 - (Rrole[rnum1].DefPoi + Brole[bnum1].loverlevel[3]) / 4;

            // 反伤
            if (Brole[bnum1].StateLevel[14] > Brole[bnum].StateLevel[14])
            {
                int addpoi1 = addpoi * (Brole[bnum1].StateLevel[14] - Brole[bnum].StateLevel[14]) / 100;
                addpoi = std::max(addpoi - addpoi1, 0);
                Brole[bnum1].ShowNumber = addpoi;
                Brole[bnum].ShowNumber = addpoi1;
                Brole[bnum].AntiHurt = addpoi1;
                Rrole[Brole[bnum].rnum].Poison += addpoi1;
                BField[4][Brole[bnum].X][Brole[bnum].Y] = 20;
            }

            if (addpoi < 0) addpoi = 0;
            if (addpoi + Rrole[rnum1].Poison > 99) addpoi = 99 - Rrole[rnum1].Poison;
            Rrole[rnum1].Poison += addpoi;
            Brole[bnum1].ShowNumber = addpoi;
            Brole[bnum].ExpGot += addpoi / 5;
            std::string str = "使毒";
            ShowMagicName(2, str);
            SetAminationPosition(0, 0, 0);
            PlayActionAmination(bnum, 0);
            PlayMagicAmination(bnum, 30, 0, 2);
            ShowHurtValue(2);
        }
    }
}

void PlayActionAmination(int bnum, int mode)
{
    // 暗器类用特殊的动作
    if (mode == 5) mode = 4;

    int Ax1 = Ax, Ay1 = Ay;
    // 方向至少朝向一个将被打中的敌人
    int k = 0;
    for (int i = 0; i < BRoleAmount; i++)
    {
        if (Brole[i].Team != Brole[bnum].Team && Brole[i].Dead == 0 && BField[4][Brole[i].X][Brole[i].Y] > 0)
        {
            k++;
            if (rand() % k == 0)
            { Ax1 = Brole[i].X; Ay1 = Brole[i].Y; }
        }
    }
    if (Ax1 != Bx || Ay1 != By)
        Brole[bnum].Face = CalFace(Bx, By, Ax1, Ay1);

    Redraw();
    int rnum = Brole[bnum].rnum;
    int actnum = Rrole[rnum].ActionNum;
    if (rnum == 0) actnum = 0;

    // 如果对应帧数<=0, 寻找第一个不为零的帧数
    if (FPNGIndex[actnum].FightFrame[mode] <= 0)
    {
        for (mode = 0; mode < 5; mode++)
            if (FPNGIndex[actnum].FightFrame[mode] > 0) break;
    }
    if (FPNGIndex[actnum].FightFrame[mode] > 0)
    {
        int beginpic = 0;
        for (int i = 0; i < mode; i++)
            beginpic += FPNGIndex[actnum].FightFrame[i] * 4;
        beginpic += Brole[bnum].Face * FPNGIndex[actnum].FightFrame[mode];
        int endpic = beginpic + FPNGIndex[actnum].FightFrame[mode] - 1;

        int i = beginpic;
        while (SDL_PollEvent(&event) || true)
        {
            CheckBasicEvent();
            DrawBFieldWithAction(bnum, i);
            UpdateAllScreen();
            SDL_Delay(BATTLE_SPEED);
            i++;
            if (i > endpic)
            {
                Brole[bnum].Pic = endpic;
                break;
            }
        }
    }
}

void Medcine(int bnum)
{
    int rnum = Brole[bnum].rnum;
    int med = Rrole[rnum].Medcine;
    int step = med / 15 + 1;
    CalCanSelect(bnum, 1, step);
    SelectAimMode = 1;
    bool select = false;
    if (Brole[bnum].Team == 0 && Brole[bnum].Auto == 0)
        select = SelectAim(bnum, step);
    else
    {
        if (BField[3][Ax][Ay] >= 0) select = true;
    }
    if (BField[2][Ax][Ay] >= 0 && select)
    {
        Brole[bnum].Acted = 1;
        Rrole[rnum].PhyPower -= 4;
        int bnum1 = BField[2][Ax][Ay];
        if (Brole[bnum1].Team == Brole[bnum].Team)
        {
            int rnum1 = Brole[bnum1].rnum;
            int addlife = med * 3 - Rrole[rnum1].Hurt + rand() % 10 - 5;
            if (addlife < 0) addlife = 0;
            if (addlife + Rrole[rnum1].CurrentHP > Rrole[rnum1].MaxHP)
                addlife = Rrole[rnum1].MaxHP - Rrole[rnum1].CurrentHP;
            Rrole[rnum1].CurrentHP += addlife;
            Rrole[rnum1].Hurt -= addlife / 10 / LIFE_HURT;
            if (Rrole[rnum1].Hurt < 0) Rrole[rnum1].Hurt = 0;
            Brole[bnum].ExpGot += addlife / 10;
            Brole[bnum1].ShowNumber = addlife;
            std::string str = "醫療";
            ShowMagicName(3, str);
            SetAminationPosition(0, 0, 0);
            PlayActionAmination(bnum, 0);
            PlayMagicAmination(bnum, 29, 1, 3);
            ShowHurtValue(3);
        }
    }
}

void MedPoison(int bnum)
{
    int rnum = Brole[bnum].rnum;
    int medpoi = Rrole[rnum].MedPoi;
    int step = medpoi / 15 + 1;
    CalCanSelect(bnum, 1, step);
    SelectAimMode = 1;
    bool select = false;
    if (Brole[bnum].Team == 0 && Brole[bnum].Auto == 0)
        select = SelectAim(bnum, step);
    else
    {
        if (BField[3][Ax][Ay] >= 0) select = true;
    }
    if (BField[2][Ax][Ay] >= 0 && select)
    {
        Brole[bnum].Acted = 1;
        Rrole[rnum].PhyPower -= 5;
        int bnum1 = BField[2][Ax][Ay];
        if (Brole[bnum1].Team == Brole[bnum].Team)
        {
            int rnum1 = Brole[bnum1].rnum;
            int minuspoi = Rrole[rnum].MedPoi;
            if (minuspoi < 0) minuspoi = 0;
            if (Rrole[rnum1].Poison - minuspoi <= 0) minuspoi = Rrole[rnum1].Poison;
            Rrole[rnum1].Poison -= minuspoi;
            Brole[bnum1].ShowNumber = minuspoi;
            Brole[bnum].ExpGot += minuspoi / 5;
            std::string str = "解毒";
            ShowMagicName(4, str);
            SetAminationPosition(0, 0, 0);
            PlayActionAmination(bnum, 0);
            PlayMagicAmination(bnum, 36, 1, 4);
            ShowHurtValue(4);
        }
    }
}
void UseHiddenWeapon(int bnum, int inum)
{
    int rnum = Brole[bnum].rnum;
    int hidden = Rrole[rnum].HidWeapon;
    int step = std::min(10, hidden / 15 + 1);
    CalCanSelect(bnum, 1, step);
    bool select = false;
    int eventnum = (inum >= 0) ? Ritem[inum].UnKnow7 : -1;
    if (eventnum > 0)
    {
        CallEvent(eventnum);
    }
    else
    {
        if (Brole[bnum].Team == 0 && Brole[bnum].Auto == 0)
        {
            SelectAimMode = 0;
            select = SelectAim(bnum, step);
        }
        else
        {
            if (BField[3][Ax][Ay] >= 0) select = true;
        }
        if (BField[2][Ax][Ay] >= 0 && select && Brole[BField[2][Ax][Ay]].Team != Brole[bnum].Team)
        {
            // 自动选择最强暗器
            if (Brole[bnum].Team == 0 && Brole[bnum].Auto != 0)
            {
                inum = -1;
                int maxhurt = 0;
                for (int i = 0; i < MAX_ITEM_AMOUNT; i++)
                {
                    if (RItemList[i].Amount > 0 && RItemList[i].Number >= 0)
                        if (Ritem[RItemList[i].Number].ItemType == 4 && Ritem[RItemList[i].Number].AddCurrentHP < maxhurt)
                        { maxhurt = Ritem[RItemList[i].Number].AddCurrentHP; inum = RItemList[i].Number; }
                }
            }
            if (Brole[bnum].Team != 0)
            {
                inum = -1;
                int maxhurt = 0;
                for (int i = 0; i < 4; i++)
                {
                    if (Rrole[rnum].TakingItemAmount[i] > 0 && Rrole[rnum].TakingItem[i] >= 0)
                        if (Ritem[Rrole[rnum].TakingItem[i]].ItemType == 4 && Ritem[Rrole[rnum].TakingItem[i]].AddCurrentHP < maxhurt)
                        { maxhurt = Ritem[Rrole[rnum].TakingItem[i]].AddCurrentHP; inum = Rrole[rnum].TakingItem[i]; }
                }
            }
            if (inum >= 0)
            {
                Brole[bnum].Acted = 1;
                if (Brole[bnum].Team == 0)
                    instruct_32(inum, -1);
                else
                    instruct_41(rnum, inum, -1);

                int bnum1 = BField[2][Ax][Ay];
                if (Brole[bnum1].Team != Brole[bnum].Team)
                {
                    int rnum1 = Brole[bnum1].rnum;
                    Rrole[rnum1].Poison = std::min((int)(Rrole[rnum1].Poison + Ritem[inum].AddPoi * (100 - Rrole[rnum1].DefPoi - Brole[bnum1].loverlevel[3]) / 100), 99);
                    SetAminationPosition(0, 0, 0);
                    std::string str((char*)&Ritem[inum].Name[0]);
                    ShowMagicName(inum, str);
                    PlayActionAmination(bnum, 0);
                    PlayMagicAmination(bnum, Ritem[inum].AmiNum);
                    Rmagic[0].HurtType = 0;
                    Rmagic[0].MagicType = 5;
                    Rmagic[0].Attack[0] = -Ritem[inum].AddCurrentHP;
                    Rmagic[0].Attack[1] = -Ritem[inum].AddCurrentHP * 3;
                    CalHurtRole(bnum, 0, RegionParameter(Rrole[rnum].HidWeapon / 50, 1, 10));
                    ShowHurtValue(0);
                }
            }
        }
    }
}

void Rest(int bnum)
{
    int rnum = Brole[bnum].rnum;
    if (Brole[bnum].Moved > 0 || Brole[bnum].StateLevel[26] < 0)
    {
        // 已移动过或被定身：只恢复少量体力
        Rrole[rnum].PhyPower = std::min((int)(Rrole[rnum].PhyPower + MAX_PHYSICAL_POWER / 15), MAX_PHYSICAL_POWER);
        Brole[bnum].Acted = 1;
    }
    else
    {
        Brole[bnum].Acted = 1;
        int i = 50;
        int curehurt = 2, curepoison = 2;
        if (Rrole[rnum].Hurt <= 0 && Rrole[rnum].Poison <= 0)
        {
            Rrole[rnum].CurrentHP = std::min((int)(Rrole[rnum].CurrentHP + 2 + Rrole[rnum].MaxHP / i), (int)Rrole[rnum].MaxHP);
            Rrole[rnum].PhyPower = std::min((int)(Rrole[rnum].PhyPower + MAX_PHYSICAL_POWER / 15), MAX_PHYSICAL_POWER);
            Rrole[rnum].CurrentMP = std::min((int)(Rrole[rnum].CurrentMP + 2 + Rrole[rnum].MaxMP / i), (int)Rrole[rnum].MaxMP);
        }
        else
        {
            if (Rrole[rnum].Hurt > 0) Rrole[rnum].Hurt -= curehurt;
            if (Rrole[rnum].Poison > 0) Rrole[rnum].Poison -= curepoison;
        }
        // 内功调息
        for (int j = 0; j < 4; j++)
        {
            int neinum = Rrole[rnum].NeiGong[j];
            if (neinum <= 0) break;
            int neilevel = Rrole[rnum].NGLevel[j] / 100 + 1;
            if (Rmagic[neinum].AttDistance[0] > 0)
            {
                Rrole[rnum].CurrentMP += Rrole[rnum].MaxMP * (Rmagic[neinum].AttDistance[0] + (Rmagic[neinum].AttDistance[1] - Rmagic[neinum].AttDistance[0]) * neilevel / 10) / 100;
                ShowStringOnBrole(std::string((char*)&Rmagic[neinum].Name[0]) + "·回内", bnum, 3);
            }
            Rrole[rnum].CurrentMP = std::min((int)Rrole[rnum].CurrentMP, (int)Rrole[rnum].MaxMP);
            if (Rmagic[neinum].AttDistance[2] > 0)
            {
                Rrole[rnum].CurrentHP += Rrole[rnum].MaxHP * (Rmagic[neinum].AttDistance[2] + (Rmagic[neinum].AttDistance[3] - Rmagic[neinum].AttDistance[2]) * neilevel / 10) / 100;
                ShowStringOnBrole(std::string((char*)&Rmagic[neinum].Name[0]) + "·回命", bnum, 3);
            }
            Rrole[rnum].CurrentHP = std::min((int)Rrole[rnum].CurrentHP, (int)Rrole[rnum].MaxHP);
            if (Rmagic[neinum].AddMP[4] > 0)
            {
                Rrole[rnum].PhyPower += Rmagic[neinum].AddMP[4];
                ShowStringOnBrole(std::string((char*)&Rmagic[neinum].Name[0]) + "·回體", bnum, 3);
            }
            Rrole[rnum].PhyPower = std::min((int)Rrole[rnum].PhyPower, MAX_PHYSICAL_POWER);
        }
    }
}

//----------------------------------------------------------------------
// AI
//----------------------------------------------------------------------
void AutoBattle(int bnum)
{
    // Pascal版此函数体已全部注释, 保持空实现
}

bool AutoUseItem(int bnum, int list, int test)
{
    int rnum = Brole[bnum].rnum;
    int temp = 0, p = -1;
    if (Brole[bnum].Team != 0)
    {
        for (int i = 0; i < 4; i++)
        {
            if (Rrole[rnum].TakingItem[i] >= 0)
            {
                if (Ritem[Rrole[rnum].TakingItem[i]].Data[list] > temp)
                {
                    temp = Ritem[Rrole[rnum].TakingItem[i]].Data[list];
                    p = i;
                }
            }
        }
    }
    else
    {
        for (int i = 0; i < MAX_ITEM_AMOUNT; i++)
        {
            if (RItemList[i].Amount > 0 && Ritem[RItemList[i].Number].ItemType == 3)
            {
                if (Ritem[RItemList[i].Number].Data[list] > temp)
                {
                    temp = Ritem[RItemList[i].Number].Data[list];
                    p = i;
                }
            }
        }
    }

    if (p >= 0 && test == 0)
    {
        int inum;
        if (Brole[bnum].Team != 0)
            inum = Rrole[rnum].TakingItem[p];
        else
            inum = RItemList[p].Number;
        Redraw();
        UpdateAllScreen();
        EatOneItem(rnum, inum);
        if (Brole[bnum].Team != 0)
            instruct_41(rnum, Rrole[rnum].TakingItem[p], -1);
        else
            instruct_32(RItemList[p].Number, -1);
        Brole[bnum].Acted = 1;
        SDL_Delay(500);
    }
    return p >= 0;
}

void AutoBattle2(int bnum)
{
    // Pascal版此函数体已全部注释, 保持空实现
}

void AutoBattle3(int bnum)
{
    int rnum = Brole[bnum].rnum;
    ShowSimpleStatus(rnum, 80, CENTER_Y * 2 - 150);
    UpdateAllScreen();
    SDL_Delay(450);

    if (Brole[bnum].AutoMode == 3)
    {
        // 呆子型, 直接调息
        Rest(bnum);
    }
    else
    {
        Brole[bnum].Acted = 0;

        // 生命低于30%, 70%可能医疗或吃药
        if (Brole[bnum].Acted != 1 && Rrole[rnum].CurrentHP < Rrole[rnum].MaxHP * 3 / 10)
        {
            if (Brole[bnum].AutoMode > 0 || Brole[bnum].Team != 0)
            {
                if (rand() % 100 < 70)
                {
                    if (Rrole[rnum].Medcine >= 60 && Rrole[rnum].PhyPower >= 50)
                    {
                        int Movex, Movey;
                        FarthestMove(Movex, Movey, bnum);
                        Ax = Movex;
                        Ay = Movey;
                        MoveAmination(bnum);
                        Medcine(bnum);
                    }
                    else if (Brole[bnum].Team != 0 || (Brole[bnum].Team == 0 && Brole[bnum].AutoMode == 2))
                    {
                        if (AutoUseItem(bnum, 45, 1))
                        {
                            int Movex, Movey;
                            FarthestMove(Movex, Movey, bnum);
                            Ax = Movex;
                            Ay = Movey;
                            MoveAmination(bnum);
                            AutoUseItem(bnum, 45);
                        }
                    }
                }
            }
        }

        // 内力低于30%, 60%可能吃药
        if (Brole[bnum].Acted != 1 && Rrole[rnum].CurrentMP < Rrole[rnum].MaxMP * 3 / 10)
        {
            if (Brole[bnum].Team != 0 || (Brole[bnum].Team == 0 && Brole[bnum].AutoMode == 2))
            {
                if (rand() % 100 < 60 && AutoUseItem(bnum, 50, 1))
                {
                    int Movex, Movey;
                    FarthestMove(Movex, Movey, bnum);
                    Ax = Movex;
                    Ay = Movey;
                    MoveAmination(bnum);
                    AutoUseItem(bnum, 50);
                }
            }
        }

        // 体力低于30%, 50%可能吃药 (仅敌方)
        if (Brole[bnum].Acted != 1 && Brole[bnum].Team != 0 && Rrole[rnum].PhyPower < MAX_PHYSICAL_POWER * 3 / 10)
        {
            if (Brole[bnum].Team != 0 || (Brole[bnum].Team == 0 && Brole[bnum].AutoMode == 2))
            {
                if (rand() % 100 < 50 && AutoUseItem(bnum, 48, 1))
                {
                    int Movex, Movey;
                    FarthestMove(Movex, Movey, bnum);
                    Ax = Movex;
                    Ay = Movey;
                    MoveAmination(bnum);
                    AutoUseItem(bnum, 48);
                }
            }
        }

        if (AI_USE_SPECIAL != 0)
        {
            // 尝试使用特技
            int mnum0 = Rrole[rnum].Magic[0];
            if (Brole[bnum].Acted != 1 && Rrole[rnum].PhyPower >= 10 && Rrole[rnum].Poison < 100)
                SpecialAttack(bnum);
            // 再次尝试 (森罗万象不占用行动)
            if (Rrole[rnum].Magic[0] != mnum0 && Brole[bnum].Acted != 1 && Rrole[rnum].PhyPower >= 10 && Rrole[rnum].Poison < 100)
                SpecialAttack(bnum);

            // 医疗大于70, 寻找生命最低队友医疗
            if (Brole[bnum].Acted != 1 && Rrole[rnum].Medcine > 70 && Rrole[rnum].PhyPower >= 70)
            {
                if (rand() % 100 < 30)
                {
                    int Ax1, Ay1;
                    NearestMoveByPro(Ax, Ay, Ax1, Ay1, bnum, 1, 0, 17, -1, 1);
                    if (Ax1 != -1)
                    {
                        MoveAmination(bnum);
                        Ax = Ax1;
                        Ay = Ay1;
                        Medcine(bnum);
                    }
                }
            }

            // 用毒大于80, 尝试用毒
            if (Brole[bnum].Acted != 1 && Rrole[rnum].UsePoi > 80 && Rrole[rnum].PhyPower >= 60)
            {
                if (rand() % 100 < 15)
                {
                    int Ax1, Ay1;
                    NearestMove(Ax1, Ay1, bnum);
                    if (Ax1 != -1)
                    {
                        MoveAmination(bnum);
                        Ax = Ax1;
                        Ay = Ay1;
                        UsePoison(bnum);
                    }
                }
            }

            // 有可能尝试解毒
            if (Brole[bnum].Acted != 1 && Rrole[rnum].MedPoi > 50 && Rrole[rnum].PhyPower >= 70)
            {
                if (rand() % 100 < 30)
                {
                    int Ax1, Ay1;
                    NearestMoveByPro(Ax, Ay, Ax1, Ay1, bnum, 1, 0, 20, 1, 2);
                    if (Ax1 != -1)
                    {
                        MoveAmination(bnum);
                        Ax = Ax1;
                        Ay = Ay1;
                        MedPoison(bnum);
                    }
                }
            }
        }

        // 尝试攻击 (不使用HurtType==2的特技)
        if (Brole[bnum].Acted != 1 && Rrole[rnum].PhyPower >= 10 && Rrole[rnum].Poison < 100)
        {
            // 判断主系, 若为暗器系则计算预留范围
            int tempMaxMType = 0, mainMType = 0;
            for (int i = 1; i <= 5; i++)
            {
                if (Rrole[rnum].Data[49 + i] > tempMaxMType)
                {
                    mainMType = i;
                    tempMaxMType = Rrole[rnum].Data[49 + i];
                }
            }
            int minstep = 1;
            if (mainMType == 5)
            {
                for (int i = 0; i < HaveMagicAmount(rnum); i++)
                    minstep = std::max(minstep, Rmagic[Rrole[rnum].Magic[i]].MinStep + 1);
            }

            int Movex, Movey, temp1, temp2;
            NearestMoveByPro(Movex, Movey, temp1, temp2, bnum, 0, minstep, 0, 0, 0);
            int Ax1, Ay1, magicid, Cmlevel;
            TryAttack(Ax1, Ay1, magicid, Cmlevel, Movex, Movey, bnum);

            if (magicid > -1)
            {
                // 移动
                Ax = Movex;
                Ay = Movey;
                MoveAmination(bnum);
                // 攻击
                Ax = Ax1;
                Ay = Ay1;
                int Cmnum = Rrole[Brole[bnum].rnum].Magic[magicid];
                int Cmdis = Rmagic[Cmnum].MoveDistance[Cmlevel - 1];
                int Cmrange = Rmagic[Cmnum].AttDistance[Cmlevel - 1];
                ModifyRange(bnum, Cmnum, Cmdis, Cmrange);
                Brole[bnum].Acted = 1;
                SetAminationPosition(Rmagic[Cmnum].AttAreaType, Cmdis, Cmrange);
                AttackAction(bnum, magicid, Cmnum, Cmlevel);
            }
        }

        // 攻击失败, 再次尝试使用特技
        if (Brole[bnum].Acted != 1 && Rrole[rnum].PhyPower >= 10 && Rrole[rnum].Poison < 100)
            SpecialAttack(bnum);

        // 所有行动失败
        if (Brole[bnum].Acted != 1)
        {
            if (Rrole[rnum].CurrentHP > Rrole[rnum].MaxHP / 2 || Rrole[rnum].CurrentMP > Rrole[rnum].MaxMP / 2)
            {
                // 生命或内力 > 50%, 移向敌人并调息
                int Movex, Movey;
                NearestMove(Movex, Movey, bnum);
                Ax = Movex;
                Ay = Movey;
                MoveAmination(bnum);
                Rest(bnum);
            }
            else if (Rrole[rnum].CurrentHP < Rrole[rnum].MaxHP / 10 && Rrole[rnum].CurrentMP < Rrole[rnum].MaxMP / 10)
            {
                // 生命且内力 < 10%, 远离敌人并调息
                int Movex, Movey;
                FarthestMove(Movex, Movey, bnum);
                Ax = Movex;
                Ay = Movey;
                MoveAmination(bnum);
                Rest(bnum);
            }
            else
            {
                // 原地调息
                Rest(bnum);
            }
        }
    }
}

void TryMoveAttack(int& Mx1, int& My1, int& Ax1, int& Ay1, int& tempmaxhurt, int bnum, int mnum, int level)
{
    int step = Brole[bnum].Step;
    int minstep = 0;
    int aimHurt[64][64];
    memset(aimHurt, -1, sizeof(aimHurt));
    int distance = Rmagic[mnum].MoveDistance[level - 1];
    int range = Rmagic[mnum].AttDistance[level - 1];
    int AttAreaType = Rmagic[mnum].AttAreaType;
    int myteam = Brole[bnum].Team;
    tempmaxhurt = 0;
    CalCanSelect(bnum, 0, step);
    Mx1 = -1; My1 = -1;
    for (int curX = 0; curX <= 63; curX++)
    {
        for (int curY = 0; curY <= 63; curY++)
        {
            if (BField[3][curX][curY] >= 0)
            {
                int dis = distance;
                switch (AttAreaType)
                {
                case 1: case 4: case 5: dis = 1; break;
                case 2: dis = 0; minstep = -1; break;
                case 6: minstep = Rmagic[mnum].MinStep; break;
                }
                for (int i1 = std::max(curX - dis, 0); i1 <= std::min(curX + dis, 63); i1++)
                {
                    int dis0 = abs(i1 - curX);
                    for (int i2 = std::max(curY - dis + dis0, 0); i2 <= std::min(curY + dis - dis0, 63); i2++)
                    {
                        if (abs(curX - i1) + abs(curY - i2) <= minstep)
                            continue;
                        SetAminationPosition(curX, curY, i1, i2, AttAreaType, distance, range);
                        int temphurt = 0;
                        if ((AttAreaType == 0 || AttAreaType == 3) && aimHurt[i1][i2] >= 0)
                        {
                            if (aimHurt[i1][i2] > 0)
                                temphurt = aimHurt[i1][i2] + rand() % 5 - rand() % 5;
                        }
                        else
                        {
                            for (int i = 0; i < BRoleAmount; i++)
                            {
                                if (Brole[i].Team != myteam && Brole[i].Dead == 0 && BField[4][Brole[i].X][Brole[i].Y] > 0)
                                    temphurt += CalHurtValue2(bnum, i, mnum, level);
                            }
                            aimHurt[i1][i2] = temphurt;
                        }
                        if (temphurt > tempmaxhurt)
                        {
                            tempmaxhurt = temphurt;
                            Mx1 = curX; My1 = curY;
                            Ax1 = i1; Ay1 = i2;
                        }
                    }
                }
            }
        }
    }
}
void NearestMove(int& Mx1, int& My1, int bnum)
{
    int temp1, temp2;
    NearestMoveByPro(Mx1, My1, temp1, temp2, bnum, 0, 1, 0, 0, 0);
}
void FarthestMove(int& Mx1, int& My1, int bnum)
{
    int step = Brole[bnum].Step;
    int myteam = Brole[bnum].Team;
    int maxdis = 0;
    Mx1 = Bx; My1 = By;
    CalCanSelect(bnum, 0, step);
    for (int curX = 0; curX <= 63; curX++)
    {
        for (int curY = 0; curY <= 63; curY++)
        {
            if (BField[3][curX][curY] >= 0)
            {
                int tempdis = 0;
                for (int k = 0; k < BRoleAmount; k++)
                {
                    if (Brole[k].Team != myteam && Brole[k].Dead == 0)
                        tempdis += abs(curX - Brole[k].X) + abs(curY - Brole[k].Y);
                }
                if (tempdis > maxdis)
                {
                    maxdis = tempdis;
                    Mx1 = curX; My1 = curY;
                }
            }
        }
    }
}
void NearestMoveByPro(int& Mx1, int& My1, int& Ax1, int& Ay1, int bnum, int TeamMate, int KeepDis, int Prolist, int MaxMinPro, int mode)
{
    auto sign = [](int x) { return (x > 0) - (x < 0); };
    CalCanSelect(bnum, 0, Brole[bnum].Step);
    int myteam = Brole[bnum].Team;
    int mindis = 9999;
    int step = Brole[bnum].Step;
    int tempPro = 0;
    if (MaxMinPro < 0) tempPro = 9999;
    bool select = false;
    if (KeepDis < 0) KeepDis = 0;
    Mx1 = Bx; My1 = By;
    int aimX = -1, aimY = -1;

    if (MaxMinPro != 0 && Prolist >= 0 && Prolist < 100)
    {
        for (int i = 0; i < BRoleAmount; i++)
        {
            int rnum = Brole[i].rnum;
            bool isTarget = (TeamMate == 0) ? (myteam != Brole[i].Team) : (myteam == Brole[i].Team);
            if (isTarget && Brole[i].Dead == 0 && Rrole[rnum].Data[Prolist] * sign(MaxMinPro) > tempPro * sign(MaxMinPro))
            {
                if (abs(Brole[i].X - Bx) + abs(Brole[i].Y - By) <= KeepDis + step)
                {
                    bool check = false;
                    switch (mode)
                    {
                    case 0: check = true; break;
                    case 1: check = (Rrole[rnum].CurrentHP < Rrole[rnum].MaxHP * 2 / 3); break;
                    case 2: check = (Rrole[rnum].Poison > 33); break;
                    }
                    if (check)
                    {
                        aimX = Brole[i].X;
                        aimY = Brole[i].Y;
                        tempPro = Rrole[Brole[i].rnum].Data[Prolist];
                        select = true;
                    }
                }
            }
        }
    }

    if (!select && mode == 0)
    {
        for (int i = 0; i < BRoleAmount; i++)
        {
            bool isTarget = (TeamMate == 0) ? (myteam != Brole[i].Team) : (myteam == Brole[i].Team);
            if (isTarget && Brole[i].Dead == 0)
            {
                int tempdis = abs(Brole[i].X - Bx) + abs(Brole[i].Y - By);
                if (tempdis < mindis)
                {
                    mindis = tempdis;
                    aimX = Brole[i].X;
                    aimY = Brole[i].Y;
                }
            }
        }
    }

    KeepDis = std::min(KeepDis, abs(Bx - aimX) + abs(By - aimY) + step);
    mindis = 9999;
    memset(BField[8], -1, sizeof(BField[8]));
    int n = 0;
    if (aimX >= 0 && aimY >= 0)
    {
        BField[8][aimX][aimY] = 0;
        SeekPath2(aimX, aimY, 128, TeamMate, 3, bnum);
        for (int curX = 0; curX <= 63; curX++)
        {
            for (int curY = 0; curY <= 63; curY++)
            {
                if (BField[3][curX][curY] >= 0)
                {
                    int tempdis = BField[8][curX][curY];
                    if (tempdis < 0)
                        tempdis = abs(curX - aimX) + abs(curY - aimY);
                    if (tempdis >= KeepDis)
                    {
                        if (ProbabilityByValue(tempdis, mindis, -1, n))
                        {
                            mindis = tempdis;
                            Mx1 = curX; My1 = curY;
                        }
                    }
                }
            }
        }
    }
    Ax1 = aimX; Ay1 = aimY;
}

bool ProbabilityByValue(int cur, int m, int mode, int& n)
{
    auto sign = [](int x) { return (x > 0) - (x < 0); };
    int s = sign(cur - m) * sign(mode);
    if (s == 1) { n = 1; return true; }
    if (s == 0) { n++; return (rand() % n) == 0; }
    return false;
}

void TryAttack(int& Ax1, int& Ay1, int& magicid, int& cmlevel, int Mx, int My, int bnum)
{
    magicid = -1;
    int rnum = Brole[bnum].rnum;
    int m = HaveMagicAmount(rnum);
    int tempmaxhurt = 0;
    int myteam = Brole[bnum].Team;
    for (int mid = 0; mid < m; mid++)
    {
        int mnum = Rrole[rnum].Magic[mid];
        if (mnum <= 0) break;
        if (Rmagic[mnum].HurtType == 2) continue;
        if (Rmagic[mnum].NeedItem >= 0)
            if (Brole[bnum].Team == 0 && GetItemAmount(Rmagic[mnum].NeedItem) < Rmagic[mnum].NeedItemAmount)
                continue;
        int level = Rrole[rnum].MagLevel[mid] / 100 + 1;
        if (Rrole[rnum].CurrentMP < Rmagic[mnum].NeedMP * level)
            level = Rrole[rnum].CurrentMP / std::max(1, Rmagic[mnum].NeedMP);
        if (level > 10) level = 10;
        if (level <= 0) continue;

        int aimHurt[64][64];
        memset(aimHurt, -1, sizeof(aimHurt));
        int step = Rmagic[mnum].MoveDistance[level - 1];
        int range = Rmagic[mnum].AttDistance[level - 1];
        int AttAreaType = Rmagic[mnum].AttAreaType;
        int minstep = 0;
        ModifyRange(bnum, mnum, step, range);
        int dis = step;
        switch (AttAreaType)
        {
        case 1: case 4: case 5: dis = 1; break;
        case 2: dis = 0; minstep = -1; break;
        case 6: minstep = Rmagic[mnum].MinStep; break;
        }
        for (int i1 = std::max(Mx - dis, 0); i1 <= std::min(Mx + dis, 63); i1++)
        {
            int dis0 = abs(i1 - Mx);
            for (int i2 = std::max(My - dis + dis0, 0); i2 <= std::min(My + dis - dis0, 63); i2++)
            {
                if (abs(Mx - i1) + abs(My - i2) <= minstep) continue;
                SetAminationPosition(Mx, My, i1, i2, AttAreaType, step, range);
                int temphurt = 0;
                if ((AttAreaType == 0 || AttAreaType == 3) && aimHurt[i1][i2] >= 0)
                {
                    if (aimHurt[i1][i2] > 0)
                        temphurt = aimHurt[i1][i2] + rand() % 5 - rand() % 5;
                }
                else
                {
                    for (int i = 0; i < BRoleAmount; i++)
                    {
                        if (Brole[i].Team != myteam && Brole[i].Dead == 0 && BField[4][Brole[i].X][Brole[i].Y] > 0)
                            temphurt += CalHurtValue2(bnum, i, mnum, level);
                    }
                    aimHurt[i1][i2] = temphurt;
                }
                if (temphurt > tempmaxhurt)
                {
                    tempmaxhurt = temphurt;
                    Ax1 = i1; Ay1 = i2;
                    magicid = mid;
                    cmlevel = level;
                }
            }
        }
    }
}
void TryMoveCure(int& Mx1, int& My1, int& Ax1, int& Ay1, int bnum)
{
    int step = Brole[bnum].Step;
    int myteam = Brole[bnum].Team;
    int curedis = Rrole[Brole[bnum].rnum].Medcine / 15 + 1;
    int tempminHP = MAX_HP;
    Mx1 = Bx; My1 = By;
    CalCanSelect(bnum, 0, step);
    for (int curX = 0; curX <= 63; curX++)
    {
        for (int curY = 0; curY <= 63; curY++)
        {
            if (BField[3][curX][curY] >= 0)
            {
                for (int i = 0; i < BRoleAmount; i++)
                {
                    int rnum = Brole[i].rnum;
                    if (Brole[i].Team == myteam && Brole[i].Dead == 0
                        && abs(Brole[i].X - curX) + abs(Brole[i].Y - curY) < curedis
                        && Rrole[rnum].CurrentHP < Rrole[rnum].MaxHP / 2)
                    {
                        if (Rrole[rnum].CurrentHP < tempminHP)
                        {
                            tempminHP = Rrole[rnum].CurrentHP;
                            Mx1 = curX; My1 = curY;
                            Ax1 = Brole[i].X; Ay1 = Brole[i].Y;
                        }
                    }
                }
            }
        }
    }
}
void CureAction(int bnum)
{
    int rnum = Brole[bnum].rnum;
    Rrole[rnum].PhyPower -= 5;
    int bnum1 = BField[2][Ax][Ay];
    int rnum1 = Brole[bnum1].rnum;
    int addlife = Rrole[rnum].Medcine;
    if (addlife < 0) addlife = 0;
    if (addlife + Rrole[rnum1].CurrentHP > Rrole[rnum1].MaxHP)
        addlife = Rrole[rnum1].MaxHP - Rrole[rnum1].CurrentHP;
    Rrole[rnum1].CurrentHP += addlife;
    Rrole[rnum1].Hurt -= addlife / 10 / LIFE_HURT;
    if (Rrole[rnum1].Hurt < 0) Rrole[rnum1].Hurt = 0;
    Brole[bnum1].ShowNumber = addlife;
    SetAminationPosition(0, 0, 0);
    PlayActionAmination(bnum, 0);
    PlayMagicAmination(bnum, 0);
    ShowHurtValue(3);
}

void RoundOver()
{
    BattleRound = BattleRound + 1;
    if (BattleRound % 15 == 0)
    {
        // 乱石嶙峋每整15回合清一次
        bool removeStone = false;
        for (int i1 = 0; i1 < 64; i1++)
            for (int i2 = 0; i2 < 64; i2++)
            {
                if (BField[1][i1][i2] == 1487 * 2 + 1)
                {
                    BField[1][i1][i2] = 0;
                    removeStone = true;
                }
            }
        if (removeStone)
            InitialBFieldImage(1);
    }
    if (GetItemAmount(COMPASS_ID) > 2)
    {
        // 恢复0号人物的森罗万象
        for (int i = 0; i < 1002; i++)
        {
            if (Rmagic[i].ScriptNum == 31)
            {
                Rrole[0].Magic[0] = i;
                break;
            }
        }
    }
}

void RoundOver(int bnum)
{
    if ((SEMIREAL == 0) || (Brole[bnum].Acted == 1))
    {
        // 情侣和状态恢复生命
        int rnum = Brole[bnum].rnum;
        Rrole[rnum].CurrentHP = Rrole[rnum].CurrentHP + Rrole[rnum].MaxHP * Brole[bnum].StateLevel[5] / 100;
        Rrole[rnum].CurrentHP = Rrole[rnum].CurrentHP + Rrole[rnum].MaxHP * Brole[bnum].loverlevel[7] / 100;
        if (Rrole[rnum].CurrentHP > Rrole[rnum].MaxHP)
            Rrole[rnum].CurrentHP = Rrole[rnum].MaxHP;

        // 情侣和状态恢复内力
        Rrole[rnum].CurrentMP = Rrole[rnum].CurrentMP + Rrole[rnum].MaxMP * Brole[bnum].StateLevel[6] / 100;
        Rrole[rnum].CurrentMP = Rrole[rnum].CurrentMP + Rrole[rnum].MaxMP * Brole[bnum].loverlevel[8] / 100;
        if (Rrole[rnum].CurrentMP < 0)
            Rrole[rnum].CurrentMP = 0;
        if (Rrole[rnum].CurrentMP > Rrole[rnum].MaxMP)
            Rrole[rnum].CurrentMP = Rrole[rnum].MaxMP;

        // 状态恢复体力
        int addphy = MAX_PHYSICAL_POWER * Brole[bnum].StateLevel[20] / 100;
        if ((Rrole[rnum].PhyPower + addphy < 20) && (addphy < 0))
            addphy = 0;
        Rrole[rnum].PhyPower = Rrole[rnum].PhyPower + addphy;
        if (Rrole[rnum].PhyPower > MAX_PHYSICAL_POWER)
            Rrole[rnum].PhyPower = MAX_PHYSICAL_POWER;
        if (Rrole[rnum].PhyPower < 1)
            Rrole[rnum].PhyPower = 1;

        for (int j = 0; j < 34; j++)
        {
            if (Brole[bnum].StateRound[j] > 0)
            {
                Brole[bnum].StateRound[j] = Brole[bnum].StateRound[j] - 1;
                if (Brole[bnum].StateRound[j] <= 0)
                    Brole[bnum].StateLevel[j] = 0;
            }
        }
    }
}

bool SelectAutoMode()
{
    int x = 160, y = 82, w = 200, h = 28;
    bool resultVal = true;
    int amount = 0;
    std::vector<std::string> namestr;
    std::vector<int> a;
    for (int i = 0; i < BRoleAmount; i++)
    {
        if (Brole[i].Team == 0 && Brole[i].Dead == 0)
        {
            namestr.push_back((char*)Rrole[Brole[i].rnum].Name);
            a.push_back(i);
            amount++;
        }
    }
    std::string modestring[4];
    modestring[0] = "手動";
    modestring[1] = "全攻";
    modestring[2] = "平衡";
    modestring[3] = "混子";
    std::string str = "確認";

    RecordFreshScreen(x, y, w + 1, (amount + 1) * h + 1);
    std::vector<int> tempmode(BRoleAmount);
    for (int i = 0; i < BRoleAmount; i++) tempmode[i] = Brole[i].AutoMode;

    int menu = 0;
    auto ShowTeamModeMenu = [&]()
    {
        LoadFreshScreen(x, y);
        for (int i = 0; i < amount; i++)
        {
            if (i == menu)
            {
                DrawTextFrame(x, y + h * i, 13);
                DrawShadowText(namestr[i].c_str(), x + 19, y + 3 + h * i, ColColor(0x64), ColColor(0x66));
                DrawShadowText(modestring[Brole[a[i]].AutoMode].c_str(), x + 109, y + 3 + h * i, ColColor(0x64), ColColor(0x66));
            }
            else
            {
                DrawTextFrame(x, y + h * i, 13, 204);
                DrawShadowText(namestr[i].c_str(), x + 19, y + 3 + h * i, 0, 0x202020);
                DrawShadowText(modestring[Brole[a[i]].AutoMode].c_str(), x + 109, y + 3 + h * i, 0, 0x202020);
            }
        }
        DrawTextFrame(x, y + h * amount, 4);
        if (menu == -2)
            DrawShadowText(str.c_str(), x + 19, y + 3 + h * amount, ColColor(0x64), ColColor(0x66));
        else
            DrawShadowText(str.c_str(), x + 19, y + 3 + h * amount, 0, 0x202020);
        UpdateAllScreen();
    };

    ShowTeamModeMenu();
    while (SDL_WaitEvent(&event))
    {
        CheckBasicEvent();
        int xm, ym;
        if (event.type == SDL_EVENT_KEY_UP)
        {
            if (event.key.key == SDLK_RETURN || event.key.key == SDLK_SPACE) break;
            if (event.key.key == SDLK_ESCAPE) { resultVal = false; break; }
            if (event.key.key == SDLK_LEFT && menu >= 0)
            {
                Brole[a[menu]].AutoMode--;
                if (Brole[a[menu]].AutoMode < 0) Brole[a[menu]].AutoMode = 3;
                ShowTeamModeMenu();
            }
            if (event.key.key == SDLK_RIGHT && menu >= 0)
            {
                Brole[a[menu]].AutoMode++;
                if (Brole[a[menu]].AutoMode > 3) Brole[a[menu]].AutoMode = 0;
                ShowTeamModeMenu();
            }
        }
        if (event.type == SDL_EVENT_KEY_DOWN)
        {
            if (event.key.key == SDLK_UP)
            {
                menu--;
                if (menu == -1) menu = -2;
                if (menu == -3) menu = amount - 1;
                ShowTeamModeMenu();
            }
            if (event.key.key == SDLK_DOWN)
            {
                menu++;
                if (menu == amount) menu = -2;
                if (menu == -1) menu = 0;
                ShowTeamModeMenu();
            }
        }
        if (event.type == SDL_EVENT_MOUSE_BUTTON_UP)
        {
            if (event.button.button == SDL_BUTTON_LEFT && MouseInRegion(x, y, w, amount * h + 32))
            {
                if (menu > -1)
                {
                    Brole[a[menu]].AutoMode++;
                    if (Brole[a[menu]].AutoMode > 3) Brole[a[menu]].AutoMode = 0;
                    ShowTeamModeMenu();
                }
                else if (menu == -2) break;
            }
            if (event.button.button == SDL_BUTTON_RIGHT) { resultVal = false; break; }
        }
        if (event.type == SDL_EVENT_MOUSE_MOTION)
        {
            if (MouseInRegion(x, y, w, amount * h + 32, xm, ym))
            {
                int mp = menu;
                menu = (ym - y) / h;
                if (menu < 0) menu = 0;
                if (menu >= amount) menu = -2;
                if (mp != menu) ShowTeamModeMenu();
            }
        }
        event.key.key = 0;
        event.button.button = 0;
    }

    if (!resultVal)
        for (int i = 0; i < BRoleAmount; i++) Brole[i].AutoMode = tempmode[i];
    FreeFreshScreen();
    Redraw();
    UpdateAllScreen();
    return resultVal;
}

void Auto(int bnum)
{
    if (!SelectAutoMode())
        return;
    for (int i = 0; i < BRoleAmount; i++)
    {
        if (Brole[i].Team == 0 && Brole[i].Dead == 0)
        {
            if (Brole[i].AutoMode == 0)
                Brole[i].Auto = 0;
            else
                Brole[i].Auto = 1;
        }
    }
    if (Brole[bnum].Auto > 0)
    {
        AutoBattle3(bnum);
        Brole[bnum].Acted = 1;
    }
}

void SetEnemyAttribute()
{
    for (int i = 0; i < 20; i++)
    {
        int rnum = WarSta.Enemy[i];
        if (rnum >= 0)
        {
            switch (MODVersion)
            {
            case 13:
                Rrole[rnum] = Rrole0[rnum];
                if (Rrole[rnum].RoundLeave < 0) continue;
                if (AUTO_LEVELUP == 0)
                {
                    if (rnum >= 738 && rnum <= 741)
                        SetAttribute(rnum, 71, Rrole[rnum].Repute, Rrole[rnum].RoundLeave, 60);
                }
                else
                {
                    if (rnum >= 331 && rnum <= 878)
                        SetAttribute(rnum, 71, Rrole[rnum].Repute, Rrole[rnum].RoundLeave, 60);
                    else
                        SetAttribute(rnum, 1, Rrole[rnum].Repute, Rrole[rnum].RoundLeave, 60);
                }
                break;
            case 0:
                break;
            default:
                break;
            }
        }
    }
}

int IFinbattle(int num)
{
    if (num < 0) return -1;
    for (int i = 0; i < BRoleAmount; i++)
        if (Brole[i].rnum == num) return i;
    return -1;
}

int16_t GetMagicWithSA2(int16_t SANum)
{
    for (int i = 1; i < 1002; i++)
    {
        if (Rmagic[i].HurtType == 4 && Rmagic[i].ScriptNum == SANum)
            return (int16_t)i;
    }
    return -1;
}

void CallSA2Func(TSpecialAbility2& sa2, int f, int bnum, int mnum, int mnum2, int level)
{
    switch (f)
    {
    case 0: sa2.SA2_0(bnum, mnum, mnum2, level); break;
    case 1: sa2.SA2_1(bnum, mnum, mnum2, level); break;
    case 2: sa2.SA2_2(bnum, mnum, mnum2, level); break;
    case 3: sa2.SA2_3(bnum, mnum, mnum2, level); break;
    case 4: sa2.SA2_4(bnum, mnum, mnum2, level); break;
    case 5: sa2.SA2_5(bnum, mnum, mnum2, level); break;
    case 6: sa2.SA2_6(bnum, mnum, mnum2, level); break;
    case 7: sa2.SA2_7(bnum, mnum, mnum2, level); break;
    case 8: sa2.SA2_8(bnum, mnum, mnum2, level); break;
    case 9: sa2.SA2_9(bnum, mnum, mnum2, level); break;
    case 10: sa2.SA2_10(bnum, mnum, mnum2, level); break;
    case 11: sa2.SA2_11(bnum, mnum, mnum2, level); break;
    case 12: sa2.SA2_12(bnum, mnum, mnum2, level); break;
    case 100: sa2.SA2_100(bnum, mnum, mnum2, level); break;
    case 101: sa2.SA2_101(bnum, mnum, mnum2, level); break;
    case 102: sa2.SA2_102(bnum, mnum, mnum2, level); break;
    case 103: sa2.SA2_103(bnum, mnum, mnum2, level); break;
    default: break;
    }
}

void CheckAttackAttachment(int bnum, int mnum, int level)
{
    TSpecialAbility2 sa2;
    int16_t f = Rrole[Brole[bnum].rnum].AmiFrameNum[0];
    int16_t mnum2 = GetMagicWithSA2(f);
    if (mnum2 > 0 && Rmagic[mnum2].HurtType == 4 && Rmagic[mnum2].Poison == 0 && rand() % 100 < Rmagic[mnum2].NeedMP)
        CallSA2Func(sa2, f, bnum, mnum, mnum2, level);

    for (int i = 0; i < BRoleAmount; i++)
    {
        if (Brole[bnum].Team != Brole[i].Team && Brole[i].Dead == 0 && BField[4][Brole[i].X][Brole[i].Y] > 0)
        {
            f = Rrole[Brole[i].rnum].AmiFrameNum[0];
            mnum2 = GetMagicWithSA2(f);
            if (mnum2 > 0 && Rmagic[mnum2].HurtType == 4 && Rmagic[mnum2].Poison == 1 && rand() % 100 < Rmagic[mnum2].NeedMP)
                CallSA2Func(sa2, f, i, mnum, mnum2, level);
        }
    }
}

void CheckDefenceAttachment(int bnum, int mnum, int level)
{
    // 空实现（与Pascal一致）
}

bool CanSelectAim(int bnum, int aimbnum, int mnum, int aimMode)
{
    int HurtType;
    if (mnum > 0)
    {
        HurtType = Rmagic[mnum].HurtType;
        aimMode = Rmagic[mnum].AddMP[0];
    }
    else
        HurtType = 2;
    if (Brole[aimbnum].Dead == 1)
        return false;
    switch (HurtType)
    {
    case 0: case 1: case 6:
        return Brole[bnum].Team != Brole[aimbnum].Team;
    case 2:
        switch (aimMode)
        {
        case 0: case 2: return Brole[bnum].Team != Brole[aimbnum].Team;
        case 1: case 3: return Brole[bnum].Team == Brole[aimbnum].Team;
        case 4: return bnum == aimbnum;
        case 5: case 6: return true;
        case 7: return false;
        default: return false;
        }
    case 3: return false;
    default: return false;
    }
}

bool UseSpecialAbility(int bnum, int mnum, int level)
{
    if (mnum <= 0) return false;
    if (Rmagic[mnum].HurtType != 2 || Rmagic[mnum].ScriptNum < 0) return false;
    int sn = Rmagic[mnum].ScriptNum;
    TSpecialAbility sa;
    typedef void (TSpecialAbility::*SAFunc)(int, int, int);
    SAFunc func = nullptr;
    switch (sn)
    {
    case 0: func = &TSpecialAbility::SA_0; break;
    case 1: func = &TSpecialAbility::SA_1; break;
    case 2: func = &TSpecialAbility::SA_2; break;
    case 3: func = &TSpecialAbility::SA_3; break;
    case 4: func = &TSpecialAbility::SA_4; break;
    case 5: func = &TSpecialAbility::SA_5; break;
    case 6: func = &TSpecialAbility::SA_6; break;
    case 7: func = &TSpecialAbility::SA_7; break;
    case 8: func = &TSpecialAbility::SA_8; break;
    case 9: func = &TSpecialAbility::SA_9; break;
    case 10: func = &TSpecialAbility::SA_10; break;
    case 11: func = &TSpecialAbility::SA_11; break;
    case 12: func = &TSpecialAbility::SA_12; break;
    case 13: func = &TSpecialAbility::SA_13; break;
    case 14: func = &TSpecialAbility::SA_14; break;
    case 15: func = &TSpecialAbility::SA_15; break;
    case 16: func = &TSpecialAbility::SA_16; break;
    case 17: func = &TSpecialAbility::SA_17; break;
    case 18: func = &TSpecialAbility::SA_18; break;
    case 19: func = &TSpecialAbility::SA_19; break;
    case 20: func = &TSpecialAbility::SA_20; break;
    case 21: func = &TSpecialAbility::SA_21; break;
    case 22: func = &TSpecialAbility::SA_22; break;
    case 23: func = &TSpecialAbility::SA_23; break;
    case 24: func = &TSpecialAbility::SA_24; break;
    case 25: func = &TSpecialAbility::SA_25; break;
    case 26: func = &TSpecialAbility::SA_26; break;
    case 27: func = &TSpecialAbility::SA_27; break;
    case 28: func = &TSpecialAbility::SA_28; break;
    case 29: func = &TSpecialAbility::SA_29; break;
    case 30: func = &TSpecialAbility::SA_30; break;
    case 31: func = &TSpecialAbility::SA_31; break;
    case 32: func = &TSpecialAbility::SA_32; break;
    case 33: func = &TSpecialAbility::SA_33; break;
    case 34: func = &TSpecialAbility::SA_34; break;
    case 35: func = &TSpecialAbility::SA_35; break;
    case 36: func = &TSpecialAbility::SA_36; break;
    case 37: func = &TSpecialAbility::SA_37; break;
    case 38: func = &TSpecialAbility::SA_38; break;
    default: return false;
    }
    (sa.*func)(bnum, mnum, level);
    kyslog("Use Special Ability %d, level %d", mnum, level);
    return true;
}

bool SpecialAttack(int bnum)
{
    bool select = false;
    int movetype = 0;
    int rnum = Brole[bnum].rnum;
    int m = HaveMagicAmount(rnum);
    int magicid = -1, mnum = 0, level = 0;

    for (int i = 0; i < m; i++)
    {
        mnum = Rrole[rnum].Magic[i];
        if (Rmagic[mnum].HurtType == 2)
        {
            bool cond1 = (rand() % (m * 100)) < 100;
            bool cond2 = (Rmagic[mnum].ScriptNum == 0) && (Rmagic[mnum].AddMP[0] == 3 || Rmagic[mnum].AddMP[0] == 4)
                && ((Brole[bnum].StateLevel[Rmagic[mnum].AddMP[1]] <= 0) || (Brole[bnum].StateRound[Rmagic[mnum].AddMP[1]] <= 1))
                && ((rand() % 100) < 80);
            if (cond1 || cond2)
            {
                select = true;
                magicid = i;
                break;
            }
        }
    }

    if (select)
    {
        level = Rrole[rnum].MagLevel[magicid] / 100 + 1;
        if (Rrole[rnum].CurrentMP < Rmagic[mnum].NeedMP * level)
            level = Rrole[rnum].CurrentMP / Rmagic[mnum].NeedMP;
        if (level > 10) level = 10;
        if (level < 1) return false;

        int distance = Rmagic[mnum].MoveDistance[level - 1];
        int range = Rmagic[mnum].AttDistance[level - 1];

        switch (Rmagic[mnum].AddMP[0])
        {
        case 0: case 2: case 5: movetype = 1; break;
        case 1: case 3: case 6: case 7:
            movetype = 3;
            if (Rrole[rnum].CurrentHP < Rrole[rnum].MaxHP / 2) movetype = 2;
            if (Rrole[rnum].CurrentHP > Rrole[rnum].MaxHP * 4 / 5) movetype = 1;
            break;
        case 4:
            movetype = -1;
            if (Rmagic[mnum].AddMP[1] == 21)
            {
                if (Brole[bnum].StateLevel[Rmagic[mnum].AddMP[1]] == 0)
                {
                    int rnd = rand() % Rrole[rnum].MaxHP;
                    if (rnd > Rrole[rnum].CurrentHP) movetype = 1;
                }
            }
            else
            {
                if (Rmagic[mnum].AddMP[1] < 0 || Brole[bnum].StateLevel[Rmagic[mnum].AddMP[1]] == 0)
                {
                    movetype = 3;
                    if (Rrole[rnum].CurrentHP < Rrole[rnum].MaxHP / 2) movetype = 2;
                }
            }
            break;
        }

        if (Rmagic[mnum].ScriptNum == 31)
            if ((level < 10) && (CalRNum(Brole[bnum].Team) <= 1))
                movetype = -1;

        if (movetype > 0)
        {
            int Movex, Movey;
            if (movetype == 1)
            {
                NearestMove(Movex, Movey, bnum);
                Ax = Movex; Ay = Movey;
                MoveAmination(bnum);
            }
            else if (movetype == 2)
            {
                FarthestMove(Movex, Movey, bnum);
                Ax = Movex; Ay = Movey;
                MoveAmination(bnum);
            }

            int maxCount = 0;
            if (Rmagic[mnum].AddMP[0] == 0 || Rmagic[mnum].AddMP[0] == 1 || Rmagic[mnum].AddMP[0] == 5)
            {
                int minstep = -1, dis = 0;
                switch (Rmagic[mnum].AttAreaType)
                {
                case 0: dis = distance; break;
                case 1: dis = 1; break;
                case 2: dis = 0; break;
                case 3: dis = distance; break;
                case 4: dis = 1; break;
                case 5: dis = 1; break;
                case 6: dis = distance; minstep = Rmagic[mnum].MinStep; break;
                }
                for (int i1 = std::max(Bx - dis, 0); i1 <= std::min(Bx + dis, 63); i1++)
                {
                    int dis0 = abs(i1 - Bx);
                    for (int i2 = std::max(By - dis + dis0, 0); i2 <= std::min(By + dis - dis0, 63); i2++)
                    {
                        if (abs(Bx - i1) + abs(By - i2) <= minstep) continue;
                        SetAminationPosition(Bx, By, i1, i2, Rmagic[mnum].AttAreaType, distance, range);
                        int tempcount = 0;
                        for (int i = 0; i < BRoleAmount; i++)
                        {
                            if (Brole[i].Dead == 0 && BField[4][Brole[i].X][Brole[i].Y] > 0)
                            {
                                bool teamOk = (Rmagic[mnum].AddMP[0] == 0 && Brole[i].Team != Brole[bnum].Team)
                                    || (Rmagic[mnum].AddMP[0] == 1 && Brole[i].Team == Brole[bnum].Team)
                                    || (Rmagic[mnum].AddMP[0] == 5);
                                bool stateOk = (Rmagic[mnum].ScriptNum == 0 &&
                                    ((Brole[i].StateLevel[Rmagic[mnum].AddMP[1]] == 0) || (Brole[i].StateRound[Rmagic[mnum].AddMP[1]] <= 1)))
                                    || (Rmagic[mnum].ScriptNum > 0);
                                if (teamOk && stateOk)
                                    tempcount += 100 + rand() % 20;
                            }
                        }
                        if (tempcount > maxCount)
                        {
                            maxCount = tempcount;
                            Ax = i1; Ay = i2;
                        }
                    }
                }
            }
            else
            {
                maxCount = 1;
                Ax = Bx; Ay = By;
            }

            if (maxCount > 0)
            {
                if (Rmagic[mnum].ScriptNum == 0)
                    Brole[bnum].Acted = 1;
                SetAminationPosition(Rmagic[mnum].AttAreaType, distance, range, Rmagic[mnum].AddMP[0]);
                AttackAction(bnum, magicid, mnum, level);
            }
        }
    }
    return false;
}

void GiveUp(int bnum)
{
    std::string menuString[2] = { "取消", "確認" };
    if (CommonMenu(CENTER_X * 2 - 100, 10, 47, 1, 0, menuString, 2) != 1)
        return;
    for (int j = 0; j < BRoleAmount; j++)
        if (Brole[bnum].Team == Brole[j].Team)
            Brole[j].Dead = 1;
}

void ModifyState(int bnum, int statenum, int16_t MaxValue, int16_t maxround)
{
    auto sign = [](int x) { return (x > 0) - (x < 0); };
    if (bnum >= 0 && bnum < BRoleAmount && MaxValue != 0 && maxround > 0)
    {
        if (statenum >= 0 && statenum < 34)
        {
            int16_t curvalue = Brole[bnum].StateLevel[statenum];
            int16_t curround = Brole[bnum].StateRound[statenum];
            switch (sign(curvalue))
            {
            case 0: // 当前无状态
                curvalue = MaxValue;
                curround = maxround;
                break;
            case 1: // 当前正面
                if (MaxValue > 0)
                { curvalue = std::max(curvalue, MaxValue); curround = std::max(curround, maxround); }
                else
                {
                    curvalue = curvalue + MaxValue;
                    if (curvalue == 0) curround = 0;
                    if (curvalue < 0) curround = maxround;
                }
                break;
            case -1: // 当前负面
                if (MaxValue < 0)
                { curvalue = std::min(curvalue, MaxValue); curround = std::max(curround, maxround); }
                else
                {
                    curvalue = curvalue + MaxValue;
                    if (curvalue == 0) curround = 0;
                    if (curvalue > 0) curround = maxround;
                }
                break;
            }
            Brole[bnum].StateLevel[statenum] = curvalue;
            Brole[bnum].StateRound[statenum] = curround;
        }
    }
}

void GiveMeLife(int bnum, int mnum, int level, int Si)
{
    if (BField[2][Ax][Ay] >= 0)
    {
        int aimbnum = BField[2][Ax][Ay];
        if (Brole[aimbnum].Team == Brole[bnum].Team)
        {
            instruct_67(Rmagic[mnum].SoundNum);
            PlayActionAmination(bnum, Rmagic[mnum].MagicType);
            int rnum = Brole[bnum].rnum;
            int addvalue = 100 * level;
            if (addvalue > Rrole[Brole[aimbnum].rnum].CurrentMP)
                addvalue = Rrole[Brole[aimbnum].rnum].CurrentMP;
            if (addvalue > Rrole[Brole[bnum].rnum].MaxHP - Rrole[Brole[bnum].rnum].CurrentHP)
                addvalue = Rrole[Brole[bnum].rnum].MaxHP - Rrole[Brole[bnum].rnum].CurrentHP;
            Rrole[Brole[aimbnum].rnum].CurrentMP -= addvalue;
            Rrole[Brole[bnum].rnum].CurrentHP += addvalue;
            BField[4][Brole[bnum].X][Brole[bnum].Y] = 1;
            BField[4][Brole[aimbnum].X][Brole[aimbnum].Y] = 1;
            if (Brole[aimbnum].StateLevel[Si] > 10)
                Brole[aimbnum].StateRound[Si]++;
            else
            { Brole[aimbnum].StateLevel[Si] = 10; Brole[aimbnum].StateRound[Si] = 3; }
            PlayMagicAmination(bnum, Rmagic[mnum].AmiNum, Rmagic[mnum].AddMP[0]);
        }
    }
    Brole[bnum].Acted = 1;
}

void ambush(int bnum, int mnum, int level, int Si)
{
    int rnum = Brole[bnum].rnum;
    for (int i = 0; i < BRoleAmount; i++)
    {
        if (Brole[i].Dead == 0)
        {
            if (Brole[i].Team != Brole[bnum].Team && Brole[i].StateLevel[18] == 0)
            {
                if (Brole[i].StateLevel[Si] >= 0)
                {
                    Brole[i].StateLevel[Si] = Rmagic[mnum].Attack[0] + (int)(Rmagic[mnum].Attack[0] * (100 + (Rmagic[mnum].Attack[1] - Rmagic[mnum].Attack[0]) * level / 10) / 100);
                    Brole[i].StateRound[Si] = Rmagic[mnum].HurtMP[level - 1];
                }
                else
                {
                    Brole[i].StateLevel[Si]--;
                    Brole[i].StateRound[Si]++;
                }
                BField[4][Brole[i].X][Brole[i].Y] = 1;
            }
            if (Brole[i].StateLevel[18] > 0)
            {
                if (Brole[i].StateLevel[Si] <= 0)
                {
                    Brole[i].StateLevel[Si] = -(Rmagic[mnum].Attack[0] + (int)(Rmagic[mnum].Attack[0] * (100 + (Rmagic[mnum].Attack[1] - Rmagic[mnum].Attack[0]) * level / 10) / 100));
                    Brole[i].StateRound[Si] = Rmagic[mnum].HurtMP[level - 1];
                }
                else
                {
                    Brole[i].StateLevel[Si]++;
                    Brole[i].StateRound[Si]++;
                }
                BField[4][Brole[i].X][Brole[i].Y] = 1;
            }
        }
    }
    PlayMagicAmination(bnum, Rmagic[mnum].AmiNum, Rmagic[mnum].AddMP[0]);
    Brole[bnum].Acted = 1;
}

//----------------------------------------------------------------------
// TSpecialAbility - 主动特技
//----------------------------------------------------------------------
// SA_0: 状态类特技通用入口
void TSpecialAbility::SA_0(int bnum, int mnum, int level)
{
    ShowMagicName(mnum);
    for (int i = 0; i < BRoleAmount; i++)
    {
        if (BField[4][Brole[i].X][Brole[i].Y] > 0 && Brole[i].Dead == 0)
        {
            if (Rmagic[mnum].HurtType == 2)
            {
                int hurt = 0;
                switch (Rmagic[mnum].AddMP[0])
                {
                case 0: if (Brole[bnum].Team != Brole[i].Team) hurt = 1; break;
                case 1: if (Brole[bnum].Team == Brole[i].Team) hurt = 1; break;
                case 4: if (bnum == i) hurt = 1; break;
                }
                if (hurt == 1)
                {
                    int s = 1;
                    while (s <= 5 && Rmagic[mnum].AddMP[s] >= 0)
                    {
                        int k = Brole[i].StateLevel[Rmagic[mnum].AddMP[s]];
                        int j = Rmagic[mnum].Attack[(s - 1) * 2] + (Rmagic[mnum].Attack[(s - 1) * 2] - Rmagic[mnum].Attack[(s - 1) * 2]) * (level - 1) / 9;
                        // 慈悲状态
                        if (Rmagic[mnum].AddMP[s] == 23)
                        {
                            Brole[i].StateLevel[Rmagic[mnum].AddMP[s]] = Brole[bnum].rnum;
                            Brole[i].StateRound[Rmagic[mnum].AddMP[s]] = Rmagic[mnum].HurtMP[level - 1];
                        }
                        else if (Rmagic[mnum].AddMP[s] == 26) // 定身状态
                        {
                            if (rand() % 100 < j)
                            {
                                Brole[i].StateLevel[Rmagic[mnum].AddMP[s]] = -1;
                                Brole[i].StateRound[Rmagic[mnum].AddMP[s]] = Rmagic[mnum].HurtMP[level - 1];
                            }
                        }
                        else
                        {
                            int r = Rmagic[mnum].HurtMP[level - 1];
                            if (bnum == i) r++;
                            ModifyState(i, Rmagic[mnum].AddMP[s], j, r);
                        }
                        s++;
                    }
                }
            }
        }
    }
    PlaySoundA(Rmagic[mnum].SoundNum, 0);
    PlayActionAmination(bnum, Rmagic[mnum].MagicType);
    PlayMagicAmination(bnum, Rmagic[mnum].AmiNum, Rmagic[mnum].AddMP[0]);
    if (Rmagic[mnum].NeedItem >= 0)
        instruct_32(Rmagic[mnum].NeedItem, -Rmagic[mnum].NeedItemAmount);
}

// SA_1: 娇生惯养
void TSpecialAbility::SA_1(int bnum, int mnum, int level)
{
    ShowMagicName(mnum);
    GiveMeLife(bnum, mnum, level, 0);
}

// SA_2: 舍己为人
void TSpecialAbility::SA_2(int bnum, int mnum, int level)
{
    ShowMagicName(mnum);
    if (BField[2][Ax][Ay] >= 0)
    {
        int aimbnum = BField[2][Ax][Ay];
        if (Brole[aimbnum].Team == Brole[bnum].Team)
        {
            instruct_67(Rmagic[mnum].SoundNum);
            PlayActionAmination(bnum, Rmagic[mnum].MagicType);
            int rnum = Brole[bnum].rnum;
            int MPnum = 200 * level;
            if (MPnum > Rrole[rnum].CurrentMP)
                MPnum = Rrole[rnum].CurrentMP;
            if (MPnum > Rrole[Brole[aimbnum].rnum].MaxMP - Rrole[Brole[aimbnum].rnum].CurrentMP)
                MPnum = Rrole[Brole[aimbnum].rnum].MaxMP - Rrole[Brole[aimbnum].rnum].CurrentMP;
            Rrole[rnum].CurrentMP -= MPnum;
            Rrole[Brole[aimbnum].rnum].CurrentMP += MPnum;
            PlayMagicAmination(bnum, Rmagic[mnum].AmiNum, Rmagic[mnum].AddMP[0]);
        }
    }
    Brole[bnum].Acted = 1;
}

// SA_3: 药王神篇，全体解毒
void TSpecialAbility::SA_3(int bnum, int mnum, int level)
{
    if (Brole[bnum].Team != 0 || Brole[bnum].Auto != 0)
    {
        int m = 0;
        for (int i = 0; i < BRoleAmount; i++)
        {
            int rnum = Brole[i].rnum;
            if (Brole[bnum].Team == Brole[i].Team)
                if (Rrole[rnum].Poison > 0) m++;
        }
        if (m < 2) return;
    }
    ShowMagicName(mnum);
    instruct_67(Rmagic[mnum].SoundNum);
    PlayActionAmination(bnum, Rmagic[mnum].MagicType);

    int curenum = 5 * level;
    for (int i = 0; i < BRoleAmount; i++)
    {
        if (Brole[i].Team == Brole[bnum].Team && Brole[i].Dead == 0)
        {
            Brole[i].ShowNumber = std::min((int)Rrole[Brole[i].rnum].Poison, curenum);
            Rrole[Brole[i].rnum].Poison = std::max(0, (int)Rrole[Brole[i].rnum].Poison - curenum);
            BField[4][Brole[i].X][Brole[i].Y] = 1;
        }
    }
    PlayMagicAmination(bnum, Rmagic[mnum].AmiNum, Rmagic[mnum].AddMP[0]);
    ShowHurtValue(4);
    Brole[bnum].Acted = 1;
}

// SA_4: 打坐吐纳，减体力加内力
void TSpecialAbility::SA_4(int bnum, int mnum, int level)
{
    int rnum = Brole[bnum].rnum;
    if (Brole[bnum].Team != 0 || Brole[bnum].Auto != 0)
        if (Rrole[rnum].CurrentMP > Rrole[rnum].MaxMP / 2) return;
    ShowMagicName(mnum);
    instruct_67(Rmagic[mnum].SoundNum);
    PlayActionAmination(bnum, Rmagic[mnum].MagicType);

    int dePhy = 20;
    if (dePhy > Rrole[rnum].PhyPower) dePhy = Rrole[rnum].PhyPower;
    int addMP = dePhy * 100;
    if (addMP > Rrole[rnum].MaxMP - Rrole[rnum].CurrentMP)
        addMP = Rrole[rnum].MaxMP - Rrole[rnum].CurrentMP;
    dePhy = addMP / 100;

    Rrole[rnum].PhyPower -= dePhy;
    Rrole[rnum].CurrentMP += addMP;

    BField[4][Brole[bnum].X][Brole[bnum].Y] = 1;
    Brole[bnum].ShowNumber = addMP;
    PlayMagicAmination(bnum, Rmagic[mnum].AmiNum, Rmagic[mnum].AddMP[0]);
    ShowHurtValue(1, 0, "+d%");
    Brole[bnum].Acted = 1;
}

// SA_5: GiveMeLife(1)
void TSpecialAbility::SA_5(int bnum, int mnum, int level)
{
    ShowMagicName(mnum);
    GiveMeLife(bnum, mnum, level, 1);
}

// SA_6: 妙手空空，偷取敌人物品
void TSpecialAbility::SA_6(int bnum, int mnum, int level)
{
    static const int16_t stealitems[40] = { 0, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 188, 189, 190, 191, 192, 193, 194, 195, 196, 197, 198, 199, 200, 201, 202, 203, 204, 206, 207, 208, 209, 210 };
    static const int16_t stealitems0[30] = { 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 171, 172 };

    auto StealRandom = [&]() {
        if (rand() % 100 < level * 5)
        {
            int si = 0;
            switch (MODVersion)
            {
            case 13: si = stealitems[rand() % 40]; break;
            case 0: si = stealitems0[rand() % 30]; break;
            }
            if ((double)(rand()) / RAND_MAX <= std::pow(0.9954, Ritem[si].Price))
                instruct_2(si, 1 + rand() % level);
        }
    };

    ShowMagicName(mnum);
    int aimbnum = BField[2][Ax][Ay];
    BField[4][Ax][Ay] = 1;
    instruct_67(Rmagic[mnum].SoundNum);
    PlayActionAmination(bnum, Rmagic[mnum].MagicType);
    PlayMagicAmination(bnum, Rmagic[mnum].AmiNum, Rmagic[mnum].AddMP[0]);
    if (aimbnum >= 0)
    {
        if (Brole[aimbnum].Team != Brole[bnum].Team)
        {
            int aimrnum = Brole[aimbnum].rnum;
            int itemid = -1, itemnum = 0, k = 0;
            for (k = 0; k <= 2; k++)
            {
                if (Rrole[aimrnum].TakingItem[k] >= 0)
                {
                    if (rand() % 100 > 50)
                    {
                        itemid = Rrole[aimrnum].TakingItem[k];
                        itemnum = rand() % Rrole[aimrnum].TakingItemAmount[k] + 1;
                        break;
                    }
                }
            }
            if (itemid >= 0)
            {
                Rrole[aimrnum].TakingItemAmount[k] -= itemnum;
                if (Rrole[aimrnum].TakingItemAmount[k] <= 0)
                    Rrole[aimrnum].TakingItem[k] = -1;
                instruct_2(itemid, itemnum);
            }
            else
                StealRandom();
        }
    }
    if (rand() % 100 < 30)
    {
        std::string str = "偷天換日";
        ShowMagicName(0, str);
        memset(&BField[4][0][0], 0, 4096 * 2);
        for (int i = 0; i < BRoleAmount; i++)
            if (Brole[bnum].Team != Brole[i].Team && Brole[i].Dead == 0)
                BField[4][Brole[i].X][Brole[i].Y] = 1 + rand() % 6;
        instruct_67(Rmagic[mnum].SoundNum);
        PlayActionAmination(bnum, Rmagic[mnum].MagicType);
        PlayMagicAmination(bnum, 100, Rmagic[mnum].AddMP[0]);
        Redraw();
        for (int i = 0; i < BRoleAmount; i++)
        {
            Brole[i].ShowNumber = -1;
            if (Brole[bnum].Team != Brole[i].Team && Brole[i].Dead == 0)
            {
                int aimrnum = Brole[aimbnum].rnum;
                int itemid = -1, itemnum = 0;
                for (int kk = 0; kk <= 2; kk++)
                {
                    CheckBasicEvent();
                    if (Rrole[aimrnum].TakingItem[kk] >= 0)
                    {
                        if (rand() % 100 < 30)
                        {
                            itemid = Rrole[aimrnum].TakingItem[kk];
                            itemnum = rand() % Rrole[aimrnum].TakingItemAmount[kk] + 1;
                            break;
                        }
                    }
                }
                if (itemid >= 0)
                {
                    int kk2 = 0;
                    for (kk2 = 0; kk2 <= 2; kk2++)
                        if (Rrole[aimrnum].TakingItem[kk2] == itemid) break;
                    Rrole[aimrnum].TakingItemAmount[kk2] -= itemnum;
                    if (Rrole[aimrnum].TakingItemAmount[kk2] <= 0)
                        Rrole[aimrnum].TakingItem[kk2] = -1;
                    instruct_2(itemid, itemnum);
                }
                else
                    StealRandom();
            }
        }
    }
    Brole[bnum].Acted = 1;
}

// SA_7: 阎王敌，全体加生命
void TSpecialAbility::SA_7(int bnum, int mnum, int level)
{
    if (Brole[bnum].Team != 0 || Brole[bnum].Auto != 0)
    {
        int m = 0;
        for (int i = 0; i < BRoleAmount; i++)
        {
            int rnum = Brole[i].rnum;
            if (Brole[bnum].Team == Brole[i].Team)
                if (Rrole[rnum].CurrentHP < Rrole[rnum].MaxHP * 4 / 5) m++;
        }
        if (m < 2) return;
    }
    ShowMagicName(mnum);
    instruct_67(Rmagic[mnum].SoundNum);
    PlayActionAmination(bnum, Rmagic[mnum].MagicType);
    for (int i = 0; i < BRoleAmount; i++)
    {
        if (Brole[i].Team == Brole[bnum].Team && Brole[i].Dead == 0)
        {
            int curenum = Rrole[Brole[i].rnum].MaxHP * 5 * level / 100;
            Rrole[Brole[i].rnum].CurrentHP += curenum;
            if (Rrole[Brole[i].rnum].CurrentHP > Rrole[Brole[i].rnum].MaxHP)
                Rrole[Brole[i].rnum].CurrentHP = Rrole[Brole[i].rnum].MaxHP;
            BField[4][Brole[i].X][Brole[i].Y] = 1;
            Brole[i].ShowNumber = curenum;
        }
    }
    PlayMagicAmination(bnum, Rmagic[mnum].AmiNum, Rmagic[mnum].AddMP[0]);
    ShowHurtValue(3);
    Brole[bnum].Acted = 1;
}

// SA_8: 运功疗伤，减内加血
void TSpecialAbility::SA_8(int bnum, int mnum, int level)
{
    int rnum = Brole[bnum].rnum;
    if (Brole[bnum].Team != 0 || Brole[bnum].Auto != 0)
        if (Rrole[rnum].CurrentHP > Rrole[rnum].MaxHP / 2) return;
    ShowMagicName(mnum);
    instruct_67(Rmagic[mnum].SoundNum);
    PlayActionAmination(bnum, Rmagic[mnum].MagicType);

    int deMP = 100 * level;
    if (deMP > Rrole[rnum].CurrentMP) deMP = Rrole[rnum].CurrentMP;
    int addHP = deMP;
    if (addHP > Rrole[rnum].MaxHP - Rrole[rnum].CurrentHP)
        addHP = Rrole[rnum].MaxHP - Rrole[rnum].CurrentHP;
    deMP = addHP;

    Rrole[rnum].CurrentMP -= deMP;
    Rrole[rnum].CurrentHP += addHP;

    BField[4][Brole[bnum].X][Brole[bnum].Y] = 1;
    Brole[bnum].ShowNumber = addHP;
    PlayMagicAmination(bnum, Rmagic[mnum].AmiNum, Rmagic[mnum].AddMP[0]);
    ShowHurtValue(3);
    Brole[bnum].Acted = 1;
}

// SA_9: 十面埋伏
void TSpecialAbility::SA_9(int bnum, int mnum, int level)
{
    ShowMagicName(mnum);
    ambush(bnum, mnum, level, 1);
}

// SA_10: 潇湘夜雨
void TSpecialAbility::SA_10(int bnum, int mnum, int level)
{
    ShowMagicName(mnum);
    ambush(bnum, mnum, level, 0);
}

// SA_11: 狮子吼，AOE伤害或治疗盲目队友
void TSpecialAbility::SA_11(int bnum, int mnum, int level)
{
    ShowMagicName(mnum);
    instruct_67(Rmagic[mnum].SoundNum);
    PlayActionAmination(bnum, Rmagic[mnum].MagicType);

    int hurt = 50 * level;
    for (int i = 0; i < BRoleAmount; i++)
    {
        if (i != bnum && Brole[i].Dead == 0 && Brole[i].StateLevel[18] == 0)
        {
            Rrole[Brole[i].rnum].CurrentHP -= hurt;
            if (Rrole[Brole[i].rnum].CurrentHP < 0) Rrole[Brole[i].rnum].CurrentHP = 0;
            BField[4][Brole[i].X][Brole[i].Y] = 1;
            Brole[i].ShowNumber = hurt;
        }
        if (Brole[i].StateLevel[18] > 0)
        {
            Rrole[Brole[i].rnum].CurrentHP += hurt;
            if (Rrole[Brole[i].rnum].CurrentHP > Rrole[Brole[i].rnum].MaxHP)
                Rrole[Brole[i].rnum].CurrentHP = Rrole[Brole[i].rnum].MaxHP;
            BField[4][Brole[i].X][Brole[i].Y] = 1;
        }
    }
    PlayMagicAmination(bnum, Rmagic[mnum].AmiNum, Rmagic[mnum].AddMP[0]);
    ShowHurtValue(0);
    Brole[bnum].Acted = 1;
}

// SA_12: 吸星大法，直线攻击+吸内+拉近
void TSpecialAbility::SA_12(int bnum, int mnum, int level)
{
    ShowMagicName(mnum);
    instruct_67(Rmagic[mnum].SoundNum);
    PlayActionAmination(bnum, Rmagic[mnum].MagicType);
    PlayMagicAmination(bnum, Rmagic[mnum].AmiNum, Rmagic[mnum].AddMP[0]);
    int rnum = Brole[bnum].rnum;
    int incx = Ax - Bx;
    int incy = Ay - By;
    int curx = Bx, cury = By;
    for (int i = 0; i < Rmagic[mnum].MoveDistance[level - 1]; i++)
    {
        curx += incx;
        cury += incy;
        if (curx >= 0 && cury >= 0 && BField[2][curx][cury] >= 0)
        {
            int aimbnum = BField[2][curx][cury];
            int aimx = curx, aimy = cury;
            while (BField[2][aimx - incx][aimy - incy] < 0 && BField[1][aimx - incx][aimy - incy] <= 0)
            {
                aimx -= incx;
                aimy -= incy;
            }
            BField[2][curx][cury] = -1;
            BField[2][aimx][aimy] = aimbnum;
            Brole[aimbnum].X = aimx;
            Brole[aimbnum].Y = aimy;

            int hurt = Rmagic[mnum].HurtMP[level - 1] + rand() % 5 - rand() % 5;
            Brole[aimbnum].ShowNumber = hurt;
            Rrole[Brole[aimbnum].rnum].CurrentMP -= hurt;
            if (Rrole[Brole[aimbnum].rnum].CurrentMP <= 0)
                Rrole[Brole[aimbnum].rnum].CurrentMP = 0;

            Brole[aimbnum].StateLevel[0] = -5 * level;
            Brole[aimbnum].StateRound[0] = level;
            Brole[aimbnum].StateLevel[1] = -5 * level;
            Brole[aimbnum].StateRound[1] = level;

            Rrole[rnum].CurrentMP += hurt;
            Rrole[rnum].MaxMP += rand() % (hurt / 2 + 1);
            if (Rrole[rnum].MaxMP > MAX_MP) Rrole[rnum].MaxMP = MAX_MP;
            if (Rrole[rnum].CurrentMP > Rrole[rnum].MaxMP)
                Rrole[rnum].CurrentMP = Rrole[rnum].MaxMP;
        }
    }
    ShowHurtValue(1);
    Brole[bnum].Acted = 1;
}

// SA_13: 含沙射影，全体下毒
void TSpecialAbility::SA_13(int bnum, int mnum, int level)
{
    ShowMagicName(mnum);
    instruct_67(Rmagic[mnum].SoundNum);
    PlayActionAmination(bnum, Rmagic[mnum].MagicType);
    int rnum = Brole[bnum].rnum;
    int Value = LinearInsert(level, 1, 10, Rmagic[mnum].Attack[0], Rmagic[mnum].Attack[1]);
    for (int i = 0; i < BRoleAmount; i++)
    {
        if (Brole[i].Team != Brole[bnum].Team && Brole[i].Dead == 0)
        {
            int curenum = Value + rand() % 3 - Rrole[Brole[i].rnum].DefPoi - Brole[i].loverlevel[3];
            curenum = std::max(0, curenum);
            Rrole[Brole[i].rnum].Poison += curenum;
            Brole[i].ShowNumber = curenum;
            if (Rrole[Brole[i].rnum].Poison > 99)
                Rrole[Brole[i].rnum].Poison = 99;
            BField[4][Brole[i].X][Brole[i].Y] = 1 + rand() % 6;
        }
    }
    PlayMagicAmination(bnum, Rmagic[mnum].AmiNum, Rmagic[mnum].AddMP[0]);
    ShowHurtValue(2);
    Brole[bnum].Acted = 1;
}

// SA_14: 落石，放置乱石
void TSpecialAbility::SA_14(int bnum, int mnum, int level)
{
    ShowMagicName(mnum);
    instruct_67(Rmagic[mnum].SoundNum);
    PlayActionAmination(bnum, Rmagic[mnum].MagicType);

    int stonenum = Rmagic[mnum].Attack[0] + (Rmagic[mnum].Attack[1] - Rmagic[mnum].Attack[0]) * level / 10;
    CalCanSelect(bnum, 1, Rmagic[mnum].MoveDistance[level - 1]);

    for (int i = 0; i < stonenum; i++)
    {
        Ax = Bx;
        Ay = By;
        if (Brole[bnum].Auto == 0 && Brole[bnum].Team == 0)
        {
            while (BField[2][Ax][Ay] != -1 || BField[1][Ax][Ay] != 0)
                while (!SelectRange(bnum, 0, Rmagic[mnum].MoveDistance[level - 1], 0));
        }
        else
        {
            int k = 0;
            for (int i1 = 0; i1 <= 63; i1++)
                for (int i2 = 0; i2 <= 63; i2++)
                {
                    if (BField[2][i1][i2] == -1 && BField[1][i1][i2] == 0 && BField[3][i1][i2] == 0)
                    {
                        int k1 = rand() % 10000;
                        if (k1 > k) { k = k1; Ax = i1; Ay = i2; }
                    }
                }
        }
        BField[1][Ax][Ay] = 1487 * 2 + 1;
        int x, y;
        CalPosOnImage(Ax, Ay, x, y);
        Redraw();
    }
    Brole[bnum].Acted = 1;
}

// SA_15: 同仇敌忾，多人围殴
void TSpecialAbility::SA_15(int bnum, int mnum, int level)
{
    ShowMagicName(mnum);
    int gridnum = Rmagic[mnum].Attack[0] + (Rmagic[mnum].Attack[1] - Rmagic[mnum].Attack[0]) * level / 10;
    int Ax1 = std::max(0, Ax - gridnum);
    int Ax2 = std::min(63, Ax + gridnum);
    int Ay1 = std::max(0, Ay - gridnum);
    int Ay2 = std::min(63, Ay + gridnum);

    BField[4][Ax][Ay] = 1;
    for (int x = Ax1; x <= Ax2; x++)
    {
        for (int y = Ay1; y <= Ay2; y++)
        {
            if (BField[2][x][y] > -1)
            {
                if (Brole[BField[2][x][y]].Dead == 0 && Brole[BField[2][x][y]].Team == Brole[bnum].Team)
                {
                    int attackbnum = BField[2][x][y];
                    int attackmnum = Rrole[Brole[attackbnum].rnum].Magic[1];
                    int attacklevel = Rrole[Brole[attackbnum].rnum].MagLevel[1] / 100 + 1;
                    ShowMagicName(attackmnum);
                    instruct_67(Rmagic[attackmnum].SoundNum);
                    PlayActionAmination(attackbnum, Rmagic[attackmnum].MagicType);
                    CalHurtRole(attackbnum, attackmnum, attacklevel, 1);
                    PlayMagicAmination(attackbnum, Rmagic[attackmnum].AmiNum, Rmagic[mnum].AddMP[0]);
                    Brole[attackmnum].Pic = 0;
                    ShowHurtValue(Rmagic[attackmnum].HurtType);
                }
            }
        }
    }
    Brole[bnum].Acted = 1;
}

// SA_16: 静诵黄庭，全体恢复体力
void TSpecialAbility::SA_16(int bnum, int mnum, int level)
{
    if (Brole[bnum].Team != 0 || Brole[bnum].Auto != 0)
    {
        int m = 0;
        for (int i = 0; i < BRoleAmount; i++)
        {
            int rnum = Brole[i].rnum;
            if (Brole[bnum].Team == Brole[i].Team)
                if (Rrole[rnum].PhyPower < MAX_PHYSICAL_POWER / 2) m++;
        }
        if (m < 2) return;
    }
    ShowMagicName(mnum);
    instruct_67(Rmagic[mnum].SoundNum);
    PlayActionAmination(bnum, Rmagic[mnum].MagicType);

    int curenum = MAX_PHYSICAL_POWER * 5 * level / 100;
    for (int i = 0; i < BRoleAmount; i++)
    {
        if (Brole[i].Team == Brole[bnum].Team && Brole[i].Dead == 0)
        {
            Rrole[Brole[i].rnum].PhyPower += curenum;
            if (Rrole[Brole[i].rnum].PhyPower > MAX_PHYSICAL_POWER)
                Rrole[Brole[i].rnum].PhyPower = MAX_PHYSICAL_POWER;
            BField[4][Brole[i].X][Brole[i].Y] = 1;
            Brole[i].ShowNumber = curenum;
        }
    }
    PlayMagicAmination(bnum, Rmagic[mnum].AmiNum, Rmagic[mnum].AddMP[0]);
    ShowHurtValue(3);
    Brole[bnum].Acted = 1;
}

// SA_17: 乱世浮萍，把行动机会让给队友
void TSpecialAbility::SA_17(int bnum, int mnum, int level)
{
    ShowMagicName(mnum);
    BField[4][Bx][By] = 1;
    BField[4][Ax][Ay] = 10;
    int bnum2 = BField[2][Ax][Ay];
    Bx = Ax;
    By = Ay;
    if (bnum2 >= 0)
    {
        if (Brole[bnum2].Team == Brole[bnum].Team)
        {
            PlayMagicAmination(bnum, Rmagic[mnum].AmiNum, Rmagic[mnum].AddMP[0]);
            int oldactstatus = Brole[bnum2].Acted;
            Brole[bnum2].Acted = 0;
            if (Brole[bnum2].Auto == 0 && Brole[bnum2].Team == 0)
            {
                while (Brole[bnum2].Acted == 0)
                {
                    switch (BattleMenu(bnum2))
                    {
                    case 0: MoveRole(bnum2); break;
                    case 1: Attack(bnum2); break;
                    case 2: UsePoison(bnum2); break;
                    case 3: MedPoison(bnum2); break;
                    case 4: Medcine(bnum2); break;
                    case 5: BattleMenuItem(bnum2); break;
                    case 6: Wait(bnum2); break;
                    case 7: SelectShowStatus(bnum2); break;
                    case 8: case 9: Rest(bnum2); break;
                    }
                }
            }
            else
                AutoBattle3(bnum2);
            Brole[bnum2].Acted = oldactstatus;
            Rrole[Brole[bnum].rnum].CurrentMP -= Rmagic[mnum].NeedMP * level;
            if (Rrole[Brole[bnum].rnum].CurrentMP < 0)
                Rrole[Brole[bnum].rnum].CurrentMP = 0;
        }
    }
    Brole[bnum].Acted = 1;
}
void TSpecialAbility::SA_18(int bnum, int mnum, int level)
{
    ShowMagicName(mnum);
    int rnum = Brole[bnum].rnum;
    if ((Brole[bnum].Auto != 0) || (Brole[bnum].Team != 0))
    {
        int k = 0;
        for (int i1 = 0; i1 <= 63; i1++)
            for (int i2 = 0; i2 <= 63; i2++)
            {
                if (BField[2][i1][i2] == -1 && BField[1][i1][i2] == 0 && BField[3][i1][i2] == 0)
                {
                    int k1 = rand() % 10000;
                    if (k1 > k) { k = k1; Ax = i1; Ay = i2; }
                }
            }
    }
    if (BField[2][Ax][Ay] == -1 && BField[1][Ax][Ay] == 0 && Rrole[rnum].CurrentHP > 1)
    {
        std::vector<std::string> menuStr;
        std::vector<int> bnumarray;
        for (int i = 0; i < BRoleAmount; i++)
        {
            if (Brole[i].Team == Brole[bnum].Team && Brole[i].Dead == 1)
            {
                menuStr.push_back(std::string((char*)Rrole[Brole[i].rnum].Name));
                bnumarray.push_back(i);
            }
        }
        if (!bnumarray.empty())
        {
            int res;
            if (Brole[bnum].Auto > 0 || Brole[bnum].Team != 0)
                res = 0;
            else
                res = CommonMenu(300, 200, 105, (int)bnumarray.size() - 1, 0, menuStr.data(), (int)menuStr.size());
            int bnum2 = bnumarray[res];
            int rnum2 = Brole[bnum2].rnum;
            int newlife = std::min(Rrole[rnum].CurrentHP - 1, Rrole[rnum].MaxHP * level / 10);
            Rrole[rnum].CurrentHP -= newlife;
            if (Rrole[rnum].CurrentHP < 1) Rrole[rnum].CurrentHP = 1;
            Brole[bnum2].Dead = 0;
            Rrole[rnum2].CurrentHP = newlife;
            if (Rrole[rnum2].CurrentHP > Rrole[rnum2].MaxHP) Rrole[rnum2].CurrentHP = Rrole[rnum2].MaxHP;
            Brole[bnum2].X = Ax; Brole[bnum2].Y = Ay;
            Brole[bnum2].alpha = 255; Brole[bnum2].mixAlpha = 0;
            BField[2][Ax][Ay] = bnum2;
        }
        else
        {
            Rrole[rnum].CurrentHP = std::min((int)Rrole[rnum].MaxHP, Rrole[rnum].CurrentHP + 60 * level);
        }
    }
    else
    {
        Rrole[rnum].CurrentHP = std::min((int)Rrole[rnum].MaxHP, Rrole[rnum].CurrentHP + 60 * level);
    }
    Rrole[rnum].CurrentMP = std::max(0, Rrole[rnum].CurrentMP - Rmagic[mnum].NeedMP * level);
    PlayMagicAmination(bnum, Rmagic[mnum].AmiNum, Rmagic[mnum].AddMP[0]);
    Brole[bnum].Acted = 1;
}
void TSpecialAbility::SA_19(int bnum, int mnum, int level)
{
    ShowMagicName(mnum);
    int16_t bnumarray[31], bnumx[31], bnumy[31];
    int enemyamount = 0;
    bool findenemy = true;
    int bnum2 = BField[2][Ax][Ay];
    if (bnum2 < 0 || (abs(Ax - Bx) + abs(Ay - By) != 1) || (bnum2 >= 0 && Brole[bnum2].Team == Brole[bnum].Team))
    {
        findenemy = false;
        int k = 0;
        for (int i1 = -1; i1 <= 1; i1++)
            for (int i2 = -1; i2 <= 1; i2++)
            {
                if ((i1 * i2 == 0) && (i1 + i2 != 0))
                {
                    int ax1 = Bx + i1, ay1 = By + i2;
                    bnum2 = BField[2][ax1][ay1];
                    if (bnum2 >= 0 && Brole[bnum2].Team != Brole[bnum].Team)
                    {
                        k++;
                        if (rand() % k == 0) { Ax = ax1; Ay = ay1; findenemy = true; }
                    }
                }
            }
    }
    int incx = Ax - Bx, incy = Ay - By;
    int aimx = Ax, aimy = Ay;
    if (findenemy)
    {
        while (true)
        {
            if (BField[2][aimx][aimy] != -1)
            {
                if (Brole[BField[2][aimx][aimy]].Team != Brole[bnum].Team)
                {
                    bnumarray[enemyamount] = BField[2][aimx][aimy];
                    bnumx[enemyamount] = aimx; bnumy[enemyamount] = aimy;
                    enemyamount++;
                }
            }
            else if (BField[1][aimx][aimy] == 0) break;
            else { aimx = Bx; aimy = By; if (enemyamount > 0) enemyamount = 1; break; }
            aimx += incx; aimy += incy;
        }
        if (enemyamount > 0)
        {
            for (int i = 0; i < enemyamount; i++)
            {
                int si = rand() % 5;
                int sn = Rmagic[mnum].AddMP[si];
                int sl = Rmagic[mnum].Attack[si * 2] + (Rmagic[mnum].Attack[si * 2] - Rmagic[mnum].Attack[si * 2]) * level / 10;
                int sr = Rmagic[mnum].HurtMP[level - 1];
                if (sl < Brole[bnumarray[i]].StateLevel[sn]) Brole[bnumarray[i]].StateLevel[sn] = sl;
                if (sr > Brole[bnumarray[i]].StateRound[sn]) Brole[bnumarray[i]].StateRound[sn] = sr;
                Rrole[Brole[bnumarray[i]].rnum].CurrentHP -= Rrole[Brole[bnumarray[i]].rnum].MaxHP / 10;
                if (Rrole[Brole[bnumarray[i]].rnum].CurrentHP < 1) Rrole[Brole[bnumarray[i]].rnum].CurrentHP = 1;
                BField[4][bnumx[i]][bnumy[i]] = (abs(bnumx[i] - Bx) + abs(bnumy[i] - By)) * 10;
            }
        }
        BField[2][Brole[bnum].X][Brole[bnum].Y] = -1;
        BField[2][aimx][aimy] = bnum;
        Brole[bnum].X = aimx; Brole[bnum].Y = aimy;
        Bx = aimx; By = aimy;
        PlayMagicAmination(bnum, Rmagic[mnum].AmiNum, Rmagic[mnum].AddMP[0]);
    }
    Brole[bnum].Acted = 1;
}
void TSpecialAbility::SA_20(int bnum, int mnum, int level)
{
    ShowMagicName(mnum);
    instruct_67(Rmagic[mnum].SoundNum);
    int aimbnum = BField[2][Ax][Ay];
    int step = abs(Ax - Brole[bnum].X) + abs(Ay - Brole[bnum].Y);
    bool sel = false;
    int Ax2 = Ax, Ay2 = Ay;
    if (aimbnum >= 0)
    {
        for (int i1 = -1; i1 <= 1; i1++)
            for (int i2 = -1; i2 <= 1; i2++)
            {
                int k = 0;
                if ((i1 * i2 == 0) && (i1 + i2 != 0))
                {
                    int ax1 = Ax + i1, ay1 = Ay + i2;
                    if ((BField[1][ax1][ay1] <= 0) && (BField[2][ax1][ay1] < 0 || BField[2][ax1][ay1] == bnum))
                    {
                        k++;
                        if (rand() % k == 0) { Ax2 = ax1; Ay2 = ay1; sel = true; }
                    }
                }
            }
    }
    for (int i1 = std::min(Ax2, (int)Brole[bnum].X); i1 <= std::max(Ax2, (int)Brole[bnum].X); i1++)
    {
        int i2 = std::min(Ay2, (int)Brole[bnum].Y) + rand() % std::max(1, abs(Ay2 - Brole[bnum].Y));
        BField[4][i1][i2] = 1 + rand() % 4;
    }
    BField[4][Ax2][Ay2] = 4;
    BField[2][Brole[bnum].X][Brole[bnum].Y] = -1;
    BField[2][Ax2][Ay2] = bnum;
    Brole[bnum].X = Ax2; Brole[bnum].Y = Ay2;
    PlayMagicAmination(bnum, Rmagic[mnum].AmiNum);
    memset(&BField[4][0][0], 0, sizeof(BField[4]));
    if (sel)
    {
        BField[4][Ax][Ay] = 1;
        if (Brole[aimbnum].Team != Brole[bnum].Team)
        {
            Rmagic[mnum].HurtType = 0;
            Rmagic[mnum].Attack[0] = 5 * step * level;
            Rmagic[mnum].Attack[1] = 10 * step * level;
            PlayActionAmination(bnum, Rmagic[mnum].MagicType);
            CalHurtRole(bnum, mnum, level, 1);
            PlayMagicAmination(bnum, Rmagic[mnum].AmiNum);
            ShowHurtValue(Rmagic[mnum].HurtType);
            Rmagic[mnum].HurtType = 2;
        }
    }
    Brole[bnum].Acted = 1;
}
void TSpecialAbility::SA_21(int bnum, int mnum, int level)
{
    if ((Brole[bnum].Team != 0) || (Brole[bnum].Auto != 0))
    {
        int m2 = 0;
        for (int i = 0; i < BRoleAmount; i++)
            if (Brole[bnum].Team == Brole[i].Team && Brole[i].StateLevel[3] <= 0) m2++;
        if (m2 == 0) return;
    }
    ShowMagicName(mnum);
    for (int i = 0; i < BRoleAmount; i++)
    {
        if (Brole[bnum].Team == Brole[i].Team && Brole[i].Dead == 0)
        {
            ModifyState(i, 3, 2, 3);
            if (Rrole[Brole[i].rnum].Equip[1] == 60 || Rrole[Brole[i].rnum].Equip[1] == 61)
            {
                ModifyState(i, 3, 4, 3);
                Rrole[Brole[bnum].rnum].CurrentMP -= Rmagic[mnum].NeedMP * (level - 1);
                if (Rrole[Brole[bnum].rnum].CurrentMP < 0) Rrole[Brole[bnum].rnum].CurrentMP = 0;
                if (Rrole[Brole[bnum].rnum].CurrentMP > Rrole[Brole[bnum].rnum].MaxMP)
                    Rrole[Brole[bnum].rnum].CurrentMP = Rrole[Brole[i].rnum].MaxHP;
            }
            BField[4][Brole[i].X][Brole[i].Y] = 1 + rand() % 6;
        }
    }
    CalMoveAbility();
    PlayMagicAmination(bnum, Rmagic[mnum].AmiNum, Rmagic[mnum].AddMP[0]);
    Brole[bnum].Acted = 1;
}
void TSpecialAbility::SA_22(int bnum, int mnum, int level)
{
    ShowMagicName(mnum);
    for (int i = 0; i < BRoleAmount; i++)
    {
        if (Brole[i].Team == Brole[bnum].Team && Brole[i].Dead == 0)
        {
            for (int j = 0; j <= 4; j++)
            {
                if (Rmagic[mnum].AddMP[1 + j] >= 0)
                {
                    int sl = Rmagic[mnum].Attack[j * 2] + (Rmagic[mnum].Attack[j * 2] - Rmagic[mnum].Attack[j * 2]) * level / 10;
                    Brole[i].StateLevel[Rmagic[mnum].AddMP[1 + j]] = sl;
                    if (Brole[i].StateRound[Rmagic[mnum].AddMP[1 + j]] < 3)
                        Brole[i].StateRound[Rmagic[mnum].AddMP[1 + j]] = 3;
                }
            }
            BField[4][Brole[i].X][Brole[i].Y] = 1 + rand() % 6;
        }
    }
    PlayMagicAmination(bnum, Rmagic[mnum].AmiNum, Rmagic[mnum].AddMP[0]);
    Brole[bnum].Acted = 1;
}
void TSpecialAbility::SA_23(int bnum, int mnum, int level)
{
    if ((Brole[bnum].Team != 0) || (Brole[bnum].Auto != 0))
    {
        if (BField[2][Ax][Ay] >= 0)
        {
            auto& aimbrole = Brole[BField[2][Ax][Ay]];
            int j = 0;
            for (int i = 0; i <= 20; i++)
                if (aimbrole.StateLevel[i] > 0) j++;
            if (j == 0) return;
        }
    }
    ShowMagicName(mnum);
    if (BField[2][Ax][Ay] >= 0)
    {
        auto aimbrole = Brole[BField[2][Ax][Ay]];
        if (aimbrole.Team == Brole[bnum].Team)
        {
            for (int i = 0; i < BRoleAmount; i++)
            {
                if (Brole[i].Team == aimbrole.Team && Brole[i].rnum != aimbrole.rnum)
                {
                    for (int j = 0; j <= 20; j++)
                    {
                        if (aimbrole.StateLevel[j] > 0)
                        {
                            Brole[i].StateLevel[j] = aimbrole.StateLevel[j];
                            Brole[i].StateRound[j] = 3;
                        }
                    }
                    BField[4][Brole[i].X][Brole[i].Y] = 1;
                }
            }
            PlayMagicAmination(bnum, Rmagic[mnum].AmiNum, Rmagic[mnum].AddMP[0]);
        }
    }
    Brole[bnum].Acted = 1;
}
void TSpecialAbility::SA_24(int bnum, int mnum, int level)
{
    if ((Brole[bnum].Team != 0) || (Brole[bnum].Auto != 0))
    {
        if (BField[2][Ax][Ay] >= 0)
        {
            auto& aimbrole = Brole[BField[2][Ax][Ay]];
            int j = 0;
            for (int i = 0; i <= 6; i++)
                if (aimbrole.StateLevel[i] < 0) j++;
            if (j == 0) return;
        }
    }
    ShowMagicName(mnum);
    if (BField[2][Ax][Ay] >= 0)
    {
        auto aimbrole = Brole[BField[2][Ax][Ay]];
        if (aimbrole.Team != Brole[bnum].Team)
        {
            for (int i = 0; i < BRoleAmount; i++)
            {
                if (Brole[i].Team == aimbrole.Team && Brole[i].rnum != aimbrole.rnum)
                {
                    for (int j = 0; j <= 6; j++)
                    {
                        if (j == 2 || j == 4) continue;
                        if (aimbrole.StateLevel[j] < 0)
                        {
                            Brole[i].StateLevel[j] = aimbrole.StateLevel[j];
                            Brole[i].StateRound[j] = 3;
                        }
                    }
                    BField[4][Brole[i].X][Brole[i].Y] = 1;
                }
            }
            PlayMagicAmination(bnum, Rmagic[mnum].AmiNum, Rmagic[mnum].AddMP[0]);
        }
    }
    Brole[bnum].Acted = 1;
}
// SA_25: 全体恢复内力
void TSpecialAbility::SA_25(int bnum, int mnum, int level)
{
    if (Brole[bnum].Team != 0 || Brole[bnum].Auto != 0)
    {
        int m = 0;
        for (int i = 0; i < BRoleAmount; i++)
        {
            int rnum = Brole[i].rnum;
            if (Brole[bnum].Team == Brole[i].Team)
                if (Rrole[rnum].CurrentMP < Rrole[rnum].MaxMP * 4 / 5) m++;
        }
        if (m < 2) return;
    }
    ShowMagicName(mnum);
    for (int i = 0; i < BRoleAmount; i++)
    {
        if (Brole[i].Dead == 0)
        {
            if (Brole[i].Team == Brole[bnum].Team && Brole[i].StateLevel[18] == 0 && i != bnum)
            {
                int addmp = Rrole[Brole[i].rnum].MaxMP * Rmagic[mnum].Attack[0] * level / 100;
                if (Rrole[Brole[i].rnum].CurrentMP + addmp > Rrole[Brole[i].rnum].MaxMP)
                    addmp = Rrole[Brole[i].rnum].MaxMP - Rrole[Brole[i].rnum].CurrentMP;
                Rrole[Brole[i].rnum].CurrentMP += addmp;
                BField[4][Brole[i].X][Brole[i].Y] = 1;
                Brole[i].ShowNumber = addmp;
            }
            if (Brole[i].StateLevel[18] > 0)
            {
                int addmp = Rrole[Brole[i].rnum].MaxMP * Rmagic[mnum].Attack[0] * level / 50;
                if (Rrole[Brole[i].rnum].CurrentMP + addmp > Rrole[Brole[i].rnum].MaxMP)
                    addmp = Rrole[Brole[i].rnum].MaxMP - Rrole[Brole[i].rnum].CurrentMP;
                Rrole[Brole[i].rnum].CurrentMP += addmp;
                BField[4][Brole[i].X][Brole[i].Y] = 1;
                Brole[i].ShowNumber = addmp;
            }
        }
    }
    PlayMagicAmination(bnum, Rmagic[mnum].AmiNum, Rmagic[mnum].AddMP[0]);
    ShowHurtValue(1, 0, "+{}");
    Brole[bnum].Acted = 1;
}

// SA_26: 先天一阳指，直线攻击+定身+我方加血
void TSpecialAbility::SA_26(int bnum, int mnum, int level)
{
    ShowMagicName(mnum);
    instruct_67(Rmagic[mnum].SoundNum);
    PlayActionAmination(bnum, Rmagic[mnum].MagicType);

    for (int i = 0; i < BRoleAmount; i++)
    {
        if (BField[4][Brole[i].X][Brole[i].Y] != 0 && Brole[i].Dead == 0 && bnum != i)
        {
            Brole[i].ShowNumber = -1;
            // 敌方伤害
            if (Brole[i].Team != Brole[bnum].Team)
            {
                int hurt = CalHurtValue(bnum, i, mnum, level, 1);
                Brole[i].ShowNumber = hurt;
                Rrole[Brole[i].rnum].CurrentHP -= hurt;
                Rrole[Brole[i].rnum].Hurt += hurt * 100 / Rrole[Brole[i].rnum].MaxHP / LIFE_HURT;
                // 定身
                int rnd = rand() % 100;
                if (rnd < Rmagic[mnum].Attack[6] + (Rmagic[mnum].Attack[7] - Rmagic[mnum].Attack[6]) * level / 10)
                {
                    Brole[i].StateLevel[26] = -1;
                    Brole[i].StateRound[26] = 3;
                }
                if (Rrole[Brole[i].rnum].Hurt > 99) Rrole[Brole[i].rnum].Hurt = 99;
                Brole[bnum].ExpGot += 1 + rand() % 10;
                if (Rrole[Brole[i].rnum].CurrentHP <= 0)
                {
                    Rrole[Brole[i].rnum].CurrentHP = 0;
                    Brole[bnum].ExpGot += 30 + rand() % 20;
                }
            }
            // 我方加血
            if (Brole[i].Team == Brole[bnum].Team)
            {
                int hurt = Rmagic[mnum].Attack[4] + (Rmagic[mnum].Attack[5] - Rmagic[mnum].Attack[4]) * level / 10;
                Rrole[Brole[i].rnum].CurrentHP += Rrole[Brole[i].rnum].MaxHP * hurt / 100;
                if (Rrole[Brole[i].rnum].CurrentHP > Rrole[Brole[i].rnum].MaxHP)
                    Rrole[Brole[i].rnum].CurrentHP = Rrole[Brole[i].rnum].MaxHP;
                Brole[i].ShowNumber = Rrole[Brole[i].rnum].MaxHP * hurt / 100;
            }
        }
    }
    PlayMagicAmination(bnum, Rmagic[mnum].AmiNum, Rmagic[mnum].AddMP[0]);
    ShowHurtValue(5);
    Brole[bnum].Acted = 1;
}

// SA_27: 韦编三绝，控制目标敌人
void TSpecialAbility::SA_27(int bnum, int mnum, int level)
{
    ShowMagicName(mnum);
    int Pctrl = rand() % 100;
    int Pm = Rmagic[mnum].Attack[0] + (Rmagic[mnum].Attack[1] - Rmagic[mnum].Attack[0]) * level / 10;

    int enemyamount = 0;
    for (int i = 0; i <= BRoleAmount; i++)
    {
        if (Brole[i].Dead == 0 && Brole[i].Team != Brole[bnum].Team)
            enemyamount++;
    }
    if (enemyamount == 1) Pctrl = Pm;

    if (Pctrl < Pm)
    {
        int aimBnum = BField[2][Ax][Ay];
        if (aimBnum >= 0)
        {
            if (Brole[aimBnum].Team != Brole[bnum].Team)
            {
                Brole[aimBnum].StateLevel[27] = -Brole[bnum].Team - 1;
                Brole[aimBnum].StateRound[27] = 3;
                BField[4][Ax][Ay] = 1;
            }
            else
            {
                // 解除我方混乱状态
                Brole[aimBnum].StateLevel[28] = 0;
                Brole[aimBnum].StateRound[28] = 0;
                BField[4][Ax][Ay] = 1;
            }
        }
    }
    Brole[bnum].Acted = 1;
    PlayMagicAmination(bnum, Rmagic[mnum].AmiNum, Rmagic[mnum].AddMP[0]);
}

// SA_28: 断己相杀，与敌人死磕至一方死亡
void TSpecialAbility::SA_28(int bnum, int mnum, int level)
{
    ShowMagicName(mnum);
    int Anum = BField[2][Ax][Ay];
    if (Anum >= 0)
    {
        if (Brole[Anum].Team != Brole[bnum].Team)
        {
            // 找敌方最强武功
            int hmattA = 0, hmnumA = 0, hmlevelA = 0;
            for (int i = 0; i < 10; i++)
            {
                int cmnum = Rrole[Brole[Anum].rnum].Magic[i];
                if (cmnum <= 0) break;
                if (Rmagic[cmnum].HurtType == 2) continue;
                int cmlevel = Rrole[Brole[Anum].rnum].MagLevel[i] / 100 + 1;
                int cmatt = Rmagic[cmnum].Attack[0] + (Rmagic[cmnum].Attack[1] - Rmagic[cmnum].Attack[0]) * cmlevel / 10;
                if (cmatt > hmattA) { hmnumA = cmnum; hmlevelA = cmlevel; hmattA = cmatt; }
            }
            // 找己方最强武功
            int hmattB = 0, hmnumB = 0, hmlevelB = 0;
            for (int i = 0; i < 10; i++)
            {
                int cmnum = Rrole[Brole[bnum].rnum].Magic[i];
                if (cmnum <= 0) break;
                if (Rmagic[cmnum].HurtType == 2) continue;
                int cmlevel = Rrole[Brole[bnum].rnum].MagLevel[i] / 100 + 1;
                int cmatt = Rmagic[cmnum].Attack[0] + (Rmagic[cmnum].Attack[1] - Rmagic[cmnum].Attack[0]) * cmlevel / 10;
                if (cmatt > hmattB) { hmnumB = cmnum; hmlevelB = cmlevel; hmattB = cmatt; }
            }

            int rnumA = Brole[Anum].rnum;
            int rnumB = Brole[bnum].rnum;
            while (true)
            {
                // 己方攻击
                ShowMagicName(hmnumB);
                instruct_67(Rmagic[hmnumB].SoundNum);
                PlayActionAmination(bnum, Rmagic[hmnumB].MagicType);
                int hurt = CalHurtValue(bnum, Anum, hmnumB, hmlevelB, 1);
                BField[4][Brole[Anum].X][Brole[Anum].Y] = 1;
                Bx = Brole[Anum].X; By = Brole[Anum].Y;
                Ax = Brole[bnum].X; Ay = Brole[bnum].Y;
                PlayMagicAmination(bnum, Rmagic[hmnumB].AmiNum);
                Brole[Anum].ShowNumber = hurt;
                ShowHurtValue(Rmagic[hmnumB].HurtType);
                BField[4][Brole[Anum].X][Brole[Anum].Y] = 0;
                Brole[Anum].ShowNumber = 0;
                Rrole[rnumA].CurrentHP -= hurt;
                if (Rrole[rnumA].CurrentHP <= 0) { Rrole[rnumA].CurrentHP = 0; break; }

                // 敌方攻击
                ShowMagicName(hmnumA);
                instruct_67(Rmagic[hmnumA].SoundNum);
                PlayActionAmination(Anum, Rmagic[hmnumA].MagicType);
                hurt = CalHurtValue(Anum, bnum, hmnumA, hmlevelA, 1);
                BField[4][Brole[bnum].X][Brole[bnum].Y] = 1;
                Bx = Brole[bnum].X; By = Brole[bnum].Y;
                Ax = Brole[Anum].X; Ay = Brole[Anum].Y;
                PlayMagicAmination(Anum, Rmagic[hmnumA].AmiNum);
                Brole[bnum].ShowNumber = hurt;
                ShowHurtValue(Rmagic[hmnumA].HurtType);
                Brole[bnum].ShowNumber = 0;
                BField[4][Brole[bnum].X][Brole[bnum].Y] = 0;
                Rrole[rnumB].CurrentHP -= hurt;
                if (Rrole[rnumB].CurrentHP <= 0) { Rrole[rnumB].CurrentHP = 0; break; }
            }
            Rrole[rnumB].CurrentMP -= Rmagic[mnum].NeedMP * level;
            if (Rrole[rnumB].CurrentMP < 0) Rrole[rnumB].CurrentMP = 0;
            Rrole[rnumA].CurrentMP -= Rmagic[mnum].NeedMP * level;
            if (Rrole[rnumA].CurrentMP < 0) Rrole[rnumA].CurrentMP = 0;
            ClearDeadRolePic();
            Brole[Anum].Pic = 0;
            Brole[bnum].Pic = 0;
        }
    }
    Brole[bnum].Acted = 1;
}

// SA_29: 七窍玲珑，延长队友正面状态
void TSpecialAbility::SA_29(int bnum, int mnum, int level)
{
    if (Brole[bnum].Team != 0 || Brole[bnum].Auto != 0)
    {
        int aimbnum = BField[2][Ax][Ay];
        int j = 0;
        for (int i = 0; i <= 20; i++)
            if (Brole[aimbnum].StateLevel[i] > 0) j++;
        if (j == 0) return;
    }
    ShowMagicName(mnum);
    for (int j = 0; j < BRoleAmount; j++)
    {
        if (BField[4][Brole[j].X][Brole[j].Y] != 0 && Brole[j].Team == Brole[bnum].Team)
        {
            int aimbnum = j;
            if (Brole[aimbnum].Team == Brole[bnum].Team)
            {
                int ERound = Rmagic[mnum].Attack[0] + (Rmagic[mnum].Attack[1] - Rmagic[mnum].Attack[0]) * level / 10;
                for (int i = 0; i < STATUS_AMOUNT; i++)
                {
                    if (Brole[aimbnum].StateLevel[i] > 0)
                        Brole[aimbnum].StateRound[i] += ERound;
                }
            }
        }
    }
    PlayMagicAmination(bnum, Rmagic[mnum].AmiNum, Rmagic[mnum].AddMP[0]);
    Brole[bnum].Acted = 1;
}

// SA_30: 排兵布阵，改变队友位置
void TSpecialAbility::SA_30(int bnum, int mnum, int level)
{
    ShowMagicName(mnum);
    if (BField[2][Ax][Ay] >= 0)
    {
        int aimbnum = BField[2][Ax][Ay];
        BField[4][Ax][Ay] = 1;
        auto aimbrole = Brole[BField[2][Ax][Ay]];
        if (aimbrole.Team == Brole[bnum].Team)
        {
            if (Brole[bnum].Auto == 0 && Brole[bnum].Team == 0)
            {
                while (BField[2][Ax][Ay] != -1)
                    while (!SelectRange(bnum, 0, Rmagic[mnum].MoveDistance[level - 1], 0));
            }
            else
            {
                int k = 0;
                CalCanSelect(bnum, 1, Rmagic[mnum].MoveDistance[level - 1]);
                for (int i1 = 0; i1 <= 63; i1++)
                    for (int i2 = 0; i2 <= 63; i2++)
                    {
                        if (BField[2][i1][i2] == -1 && BField[1][i1][i2] == 0 && BField[3][i1][i2] == 0)
                        {
                            int k1 = rand() % 10000;
                            if (k1 > k) { k = k1; Ax = i1; Ay = i2; }
                        }
                    }
            }
            BField[4][Ax][Ay] = 10;
            instruct_67(Rmagic[mnum].SoundNum);
            PlayActionAmination(bnum, Rmagic[mnum].MagicType);
            PlayMagicAmination(bnum, Rmagic[mnum].AmiNum, Rmagic[mnum].AddMP[0]);
            BField[2][aimbrole.X][aimbrole.Y] = -1;
            Brole[aimbnum].X = Ax;
            Brole[aimbnum].Y = Ay;
            BField[2][Ax][Ay] = aimbnum;
        }
    }
    Brole[bnum].Acted = 1;
}

// SA_31: 森罗万象，学习队友/全部角色特技或武功
void TSpecialAbility::SA_31(int bnum, int mnum, int level)
{
    int forall = GetItemAmount(COMPASS_ID);
    int rnum = Brole[bnum].rnum;
    bool AI = (Brole[bnum].Auto != 0) || (Brole[bnum].Team != 0);
    if (Rmagic[Rrole[rnum].Magic[0]].ScriptNum != 31) return;
    ShowMagicName(mnum);
    int amount = 0;
    std::vector<int16_t> mnumarray;
    std::vector<std::string> menuString;
    if (level < 10 || MODVersion != 13)
    {
        mnumarray.resize(260);
        menuString.resize(260);
        for (int i = 0; i < BRoleAmount; i++)
        {
            if (((Brole[i].Team == Brole[bnum].Team && Brole[i].Dead == 0) || level == 10) && i != bnum)
            {
                int eachamount = (MODVersion == 13) ? 1 : 10;
                for (int i1 = 0; i1 < eachamount; i1++)
                {
                    if (Rrole[Brole[i].rnum].Magic[i1] > 0)
                    {
                        mnumarray[amount] = Rrole[Brole[i].rnum].Magic[i1];
                        std::string namemagic = std::string((char*)Rrole[Brole[i].rnum].Name);
                        int namelen = DrawLength(namemagic);
                        for (int pad = namelen; pad < 10; pad++) namemagic += ' ';
                        namemagic += std::string((char*)Rmagic[Rrole[Brole[i].rnum].Magic[i1]].Name);
                        menuString[amount] = namemagic;
                        kyslog("%s", menuString[amount].c_str());
                        amount++;
                    }
                }
            }
        }
    }
    else
    {
        mnumarray.resize(100);
        menuString.resize(100);
        for (int i = 1; i <= 107; i++)
        {
            int ss = GetStarState(i);
            if (ss == 1 || ss > 2 || forall >= 2)
            {
                int rn = StarToRole(i);
                if (Rrole[rn].Magic[0] > 0)
                {
                    if (Rmagic[Rrole[rn].Magic[0]].HurtType == 2)
                    {
                        mnumarray[amount] = Rrole[rn].Magic[0];
                        std::string namemagic = std::string((char*)Rrole[rn].Name);
                        int namelen = DrawLength(namemagic);
                        for (int pad = namelen; pad < 10; pad++) namemagic += ' ';
                        namemagic += std::string((char*)Rmagic[Rrole[rn].Magic[0]].Name);
                        menuString[amount] = namemagic;
                        kyslog("%s", menuString[amount].c_str());
                        amount++;
                    }
                }
            }
        }
    }
    if (amount > 0)
    {
        int res = -1;
        if (AI)
            res = rand() % amount;
        else
        {
            menuString.resize(amount);
            res = CommonScrollMenu(CENTER_X - 60 - (int)menuString[0].size() * 5, 130, 105 + (int)menuString[0].size() * 10, amount - 1, 12, menuString);
        }
        if (res < 0)
        {
            Brole[bnum].Acted = 0;
            return;
        }
        Rrole[Brole[bnum].rnum].Magic[0] = mnumarray[res];
        PlayMagicAmination(bnum, Rmagic[mnumarray[res]].AmiNum, Rmagic[mnumarray[res]].AddMP[0]);
        if (AI) ShowMagicName(Rrole[Brole[bnum].rnum].Magic[0]);
    }
    Brole[bnum].Acted = 1;
    if (forall > 2) Brole[bnum].Acted = 0;
}

// SA_32: 众生平等，均分全场生命值
void TSpecialAbility::SA_32(int bnum, int mnum, int level)
{
    ShowMagicName(mnum);
    int life = 0, sum = 0;
    for (int i = 0; i < BRoleAmount; i++)
    {
        if (Brole[i].Dead == 0)
        {
            life += Rrole[Brole[i].rnum].CurrentHP;
            sum++;
        }
    }
    if (sum != 0)
        life = life / sum;
    else
        life = Rrole[Brole[bnum].rnum].CurrentHP;

    for (int i = 0; i < BRoleAmount; i++)
    {
        if (Brole[i].Dead == 0)
        {
            Rrole[Brole[i].rnum].CurrentHP = life;
            BField[4][Brole[i].X][Brole[i].Y] = 1 + rand() % 6;
        }
    }
    PlayMagicAmination(bnum, Rmagic[mnum].AmiNum, Rmagic[mnum].AddMP[0]);
    Brole[bnum].Acted = 1;
}
void TSpecialAbility::SA_33(int bnum, int mnum, int level)
{
    ShowMagicName(mnum);
    int rnum = Brole[bnum].rnum;
    if (BField[2][Ax][Ay] >= 0)
    {
        int aimbnum1 = BField[2][Ax][Ay];
        int aimbnum2 = -1;
        if (Brole[bnum].Auto == 0 && Brole[bnum].Team == 0)
        {
            while (true)
            {
                if (!SelectRange(bnum, 0, Rmagic[mnum].MoveDistance[level - 1], 0)) break;
                aimbnum2 = BField[2][Ax][Ay];
                if (aimbnum2 == aimbnum1)
                {
                    std::string str = "不可選同一人！";
                    DrawTextWithRect(str, CENTER_X - 70, CENTER_Y - 20, 145, ColColor(15), ColColor(17));
                    WaitAnyKey();
                }
                if (aimbnum2 >= 0 && aimbnum2 != aimbnum1) break;
            }
        }
        else
        {
            int k = 0;
            CalCanSelect(bnum, 1, Rmagic[mnum].MoveDistance[level - 1]);
            for (int i = 0; i < BRoleAmount; i++)
            {
                if (Brole[i].Dead == 0 && BField[3][Brole[i].X][Brole[i].Y] >= 0)
                {
                    int k1 = rand() % 10000;
                    if (k1 > k && i != aimbnum1) { k = k1; Ax = Brole[i].X; Ay = Brole[i].Y; }
                }
            }
        }
        aimbnum2 = BField[2][Ax][Ay];
        instruct_67(Rmagic[mnum].SoundNum);
        PlayActionAmination(bnum, Rmagic[mnum].MagicType);
        if (aimbnum1 >= 0 && aimbnum2 >= 0 && aimbnum1 != aimbnum2)
        {
            int tempmp = Rrole[Brole[aimbnum1].rnum].CurrentMP;
            Rrole[Brole[aimbnum1].rnum].CurrentMP = Rrole[Brole[aimbnum2].rnum].CurrentMP;
            if (Rrole[Brole[aimbnum1].rnum].CurrentMP > Rrole[Brole[aimbnum1].rnum].MaxMP)
                Rrole[Brole[aimbnum1].rnum].CurrentMP = Rrole[Brole[aimbnum1].rnum].MaxMP;
            Rrole[Brole[aimbnum2].rnum].CurrentMP = tempmp;
            if (Rrole[Brole[aimbnum2].rnum].CurrentMP > Rrole[Brole[aimbnum2].rnum].MaxMP)
                Rrole[Brole[aimbnum2].rnum].CurrentMP = Rrole[Brole[aimbnum2].rnum].MaxMP;
            BField[4][Brole[aimbnum1].X][Brole[aimbnum1].Y] = 1;
            BField[4][Brole[aimbnum2].X][Brole[aimbnum2].Y] = 10;
        }
    }
    PlayMagicAmination(bnum, Rmagic[mnum].AmiNum, Rmagic[mnum].AddMP[0]);
    Brole[bnum].Acted = 1;
}
void TSpecialAbility::SA_34(int bnum, int mnum, int level)
{
    ShowMagicName(mnum);
    int rnum = Brole[bnum].rnum;
    if (BField[2][Ax][Ay] >= 0)
    {
        int aimbnum1 = BField[2][Ax][Ay];
        int aimbnum2 = -1;
        if (Brole[bnum].Auto == 0 && Brole[bnum].Team == 0)
        {
            while (true)
            {
                if (!SelectRange(bnum, 0, Rmagic[mnum].MoveDistance[level - 1], 0)) break;
                aimbnum2 = BField[2][Ax][Ay];
                if (aimbnum2 == aimbnum1)
                {
                    std::string str = "不可選同一人！";
                    DrawTextWithRect(str, CENTER_X - 70, CENTER_Y - 20, 145, ColColor(15), ColColor(17));
                    WaitAnyKey();
                }
                if (aimbnum2 >= 0 && aimbnum2 != aimbnum1) break;
            }
        }
        else
        {
            int k = 0;
            CalCanSelect(bnum, 1, Rmagic[mnum].MoveDistance[level - 1]);
            for (int i = 0; i < BRoleAmount; i++)
            {
                if (Brole[i].Dead == 0 && BField[3][Brole[i].X][Brole[i].Y] >= 0)
                {
                    int k1 = rand() % 10000;
                    if (k1 > k && i != aimbnum1) { k = k1; Ax = Brole[i].X; Ay = Brole[i].Y; }
                }
            }
        }
        aimbnum2 = BField[2][Ax][Ay];
        instruct_67(Rmagic[mnum].SoundNum);
        PlayActionAmination(bnum, Rmagic[mnum].MagicType);
        if (aimbnum1 >= 0 && aimbnum2 >= 0 && aimbnum1 != aimbnum2)
        {
            int temphp = Rrole[Brole[aimbnum1].rnum].CurrentHP;
            Rrole[Brole[aimbnum1].rnum].CurrentHP = Rrole[Brole[aimbnum2].rnum].CurrentHP;
            if (Rrole[Brole[aimbnum1].rnum].CurrentHP > Rrole[Brole[aimbnum1].rnum].MaxHP)
                Rrole[Brole[aimbnum1].rnum].CurrentHP = Rrole[Brole[aimbnum1].rnum].MaxHP;
            Rrole[Brole[aimbnum2].rnum].CurrentHP = temphp;
            if (Rrole[Brole[aimbnum2].rnum].CurrentHP > Rrole[Brole[aimbnum2].rnum].MaxHP)
                Rrole[Brole[aimbnum2].rnum].CurrentMP = Rrole[Brole[aimbnum2].rnum].MaxHP;
        }
        BField[4][Brole[aimbnum1].X][Brole[aimbnum1].Y] = 1;
        BField[4][Brole[aimbnum2].X][Brole[aimbnum2].Y] = 10;
    }
    PlayMagicAmination(bnum, Rmagic[mnum].AmiNum, Rmagic[mnum].AddMP[0]);
    Brole[bnum].Acted = 1;
}
void TSpecialAbility::SA_35(int bnum, int mnum, int level)
{
    ShowMagicName(mnum);
    if (BField[2][Ax][Ay] >= 0)
    {
        int aimbnum = BField[2][Ax][Ay];
        if (Brole[aimbnum].Team != Brole[bnum].Team)
        {
            instruct_67(Rmagic[mnum].SoundNum);
            PlayActionAmination(bnum, Rmagic[mnum].MagicType);
            for (int i = 0; i <= 23; i++)
            {
                if (i == 14) continue;
                if (Brole[aimbnum].StateLevel[i] > 0)
                {
                    Brole[aimbnum].StateLevel[i] = 0;
                    Brole[aimbnum].StateRound[i] = 0;
                }
            }
            Brole[aimbnum].StateLevel[4] = -50;
            Brole[aimbnum].StateRound[4] += 3;
            PlayMagicAmination(bnum, Rmagic[mnum].AmiNum, Rmagic[mnum].AddMP[0]);
        }
    }
    Brole[bnum].Acted = 1;
}
void TSpecialAbility::SA_36(int bnum, int mnum, int level)
{
    ShowMagicName(mnum);
    Rmagic[mnum].HurtType = 0;
    Rmagic[mnum].Attack[0] = Rrole[Brole[bnum].rnum].Attack * level;
    Rmagic[mnum].Attack[1] = Rrole[Brole[bnum].rnum].Attack * level;
    if (Rrole[Brole[bnum].rnum].Attack > 200) needOffset = 1;
    PlaySoundA(Rmagic[mnum].SoundNum, 0);
    PlayActionAmination(bnum, Rmagic[mnum].MagicType);
    CalHurtRole(bnum, mnum, level, 1);
    PlayMagicAmination(bnum, Rmagic[mnum].AmiNum);
    ShowHurtValue(Rmagic[mnum].HurtType);
    Rmagic[mnum].HurtType = 2;
    Brole[bnum].Acted = 1;
}
void TSpecialAbility::SA_37(int bnum, int mnum, int level)
{
    ShowMagicName(mnum);
    for (int i = 0; i < BRoleAmount; i++)
    {
        if (Brole[i].Team != Brole[bnum].Team)
        {
            if (Brole[i].StateLevel[2] >= 0)
            {
                Brole[i].StateLevel[2] = Rmagic[mnum].Attack[0] + (int)(Rmagic[mnum].Attack[0] * (100 + (Rmagic[mnum].Attack[1] - Rmagic[mnum].Attack[0]) * level / 10) / 100);
                Brole[i].StateRound[2] = Rmagic[mnum].HurtMP[level - 1];
            }
            else
            {
                Brole[i].StateLevel[2]--;
                Brole[i].StateRound[2]++;
            }
            BField[4][Brole[i].X][Brole[i].Y] = 1;
        }
    }
    PlayMagicAmination(bnum, Rmagic[mnum].AmiNum, Rmagic[mnum].AddMP[0]);
    Brole[bnum].Acted = 1;
}
void TSpecialAbility::SA_38(int bnum, int mnum, int level)
{
    ShowMagicName(mnum);
    for (int i = 0; i < BRoleAmount; i++)
    {
        if (Brole[i].Team != Brole[bnum].Team && Brole[i].Dead == 0)
        {
            Brole[i].ShowNumber = Rrole[Brole[i].rnum].CurrentHP - 50;
            Rrole[Brole[i].rnum].CurrentHP = 50;
            Rrole[Brole[i].rnum].CurrentMP = 50;
            Rrole[Brole[i].rnum].PhyPower = 50;
            BField[4][Brole[i].X][Brole[i].Y] = 1;
        }
    }
    PlayActionAmination(bnum, Rmagic[mnum].MagicType);
    PlayMagicAmination(bnum, Rmagic[mnum].AmiNum, Rmagic[mnum].AddMP[0]);
    ShowHurtValue(0);
    Brole[bnum].Acted = 1;
}

//----------------------------------------------------------------------
// TSpecialAbility2 - 被动特技
//----------------------------------------------------------------------
void TSpecialAbility2::SA2_0(int bnum, int mnum, int mnum2, int level)
{
    if (Rmagic[mnum].MagicType == 3)
    {
        ShowMagicName(mnum2);
        memset(&BField[4][0][0], 0, 4096 * 2);
        for (int i = 0; i < BRoleAmount; i++)
        {
            Brole[i].ShowNumber = -1;
            if (Brole[bnum].Team != Brole[i].Team && Brole[i].Dead == 0)
            {
                BField[4][Brole[i].X][Brole[i].Y] = 1 + rand() % 6;
                int rnum = Brole[i].rnum;
                int hurt = 100 * level + Rrole[Brole[bnum].rnum].Level * 10 - Rrole[rnum].Defence;
                hurt = std::max(0, hurt);
                Rrole[rnum].CurrentHP = std::max(Rrole[rnum].CurrentHP - hurt, 0);
                Brole[i].ShowNumber = hurt;
                ModifyState(i, 26, -1, 3);
            }
        }
        PlayActionAmination(bnum, Rmagic[mnum].MagicType);
        PlayMagicAmination(bnum, Rmagic[mnum2].AmiNum);
        ShowHurtValue(0);
    }
}
void TSpecialAbility2::SA2_1(int bnum, int mnum, int mnum2, int level)
{
    if (Rmagic[mnum].MagicType == 3)
    {
        ShowMagicName(mnum2);
        Ax = Bx; Ay = By;
        switch (Brole[bnum].Face)
        {
        case 0: Ax = Bx - 1; break;
        case 1: Ay = By + 1; break;
        case 2: Ay = By - 1; break;
        case 3: Ax = Bx + 1; break;
        }
        SetAminationPosition(1, 32, 0);
        for (int i = 0; i < BRoleAmount; i++)
        {
            Brole[i].ShowNumber = -1;
            if (Brole[bnum].Team != Brole[i].Team && Brole[i].Dead == 0 && BField[4][Brole[i].X][Brole[i].Y] > 0)
            {
                int rnum = Brole[i].rnum;
                int hurt = 100 * level + Rrole[Brole[bnum].rnum].Level * 10 - Rrole[rnum].Defence;
                hurt = std::max(0, hurt);
                Rrole[rnum].CurrentHP = std::max(Rrole[rnum].CurrentHP - hurt, 0);
                Brole[i].ShowNumber = hurt;
                ModifyState(i, 1, -50, 5);
            }
        }
        PlayActionAmination(bnum, Rmagic[mnum].MagicType);
        PlayMagicAmination(bnum, Rmagic[mnum2].AmiNum);
        ShowHurtValue(0);
    }
}
void TSpecialAbility2::SA2_2(int bnum, int mnum, int mnum2, int level)
{
    if (Rmagic[mnum].MagicType == 4)
    {
        ShowMagicName(mnum2);
        Ax = Bx; Ay = By;
        SetAminationPosition(3, 0, 4);
        for (int i = 0; i < BRoleAmount; i++)
        {
            Brole[i].ShowNumber = -1;
            if (Brole[bnum].Team != Brole[i].Team && Brole[i].Dead == 0 && BField[4][Brole[i].X][Brole[i].Y] > 0)
            {
                int rnum = Brole[i].rnum;
                int hurt = 100 * level + Rrole[Brole[bnum].rnum].Level * 10 - Rrole[rnum].Defence;
                hurt = std::max(0, hurt);
                Rrole[rnum].CurrentHP = std::max(Rrole[rnum].CurrentHP - hurt, 0);
                Brole[i].ShowNumber = hurt;
                ModifyState(i, 0, -50, 5);
            }
        }
        PlayActionAmination(bnum, Rmagic[mnum].MagicType);
        PlayMagicAmination(bnum, Rmagic[mnum2].AmiNum);
        ShowHurtValue(0);
    }
}
void TSpecialAbility2::SA2_3(int bnum, int mnum, int mnum2, int level)
{
    if (mnum == 56)
    {
        ShowMagicName(mnum2);
        memset(&BField[4][0][0], 0, 4096 * 2);
        for (int i = 0; i < BRoleAmount; i++)
        {
            Brole[i].ShowNumber = -1;
            if (Brole[bnum].Team != Brole[i].Team && Brole[i].Dead == 0)
            {
                BField[4][Brole[i].X][Brole[i].Y] = 1 + rand() % 6;
                int rnum = Brole[i].rnum;
                int hurt = 200 + rand() % Rrole[Brole[bnum].rnum].Level * 5;
                Rrole[rnum].CurrentHP = std::max(Rrole[rnum].CurrentHP - hurt, 0);
                Brole[i].ShowNumber = hurt;
                for (int j = 29; j <= 33; j++)
                {
                    if (Brole[i].StateLevel[j] > 0)
                    { Brole[i].StateLevel[j] = 0; Brole[i].StateRound[j] = 0; }
                    else if (rand() % 100 < 50)
                        Brole[i].StateLevel[j] = std::min(-99, (int)Brole[i].StateLevel[j] - 15);
                    Brole[i].StateRound[j] -= 3;
                }
            }
        }
        PlayActionAmination(bnum, Rmagic[mnum].MagicType);
        PlayMagicAmination(bnum, Rmagic[mnum2].AmiNum);
        ShowHurtValue(0);
    }
}
void TSpecialAbility2::SA2_4(int bnum, int mnum, int mnum2, int level)
{
    if (mnum == 24)
    {
        ShowMagicName(mnum2);
        int rnum = Brole[bnum].rnum;
        Rrole[rnum].CurrentMP += Rmagic[mnum].NeedMP * level / 2;
        Rrole[rnum].CurrentMP = std::min(Rrole[rnum].CurrentMP + Rrole[rnum].MaxMP * 30 / 100, (int)Rrole[rnum].MaxMP);
        memcpy(&BField[5][0][0], &BField[4][0][0], 4096 * 2);
        memset(&BField[4][0][0], 0, 4096 * 2);
        BField[4][Brole[bnum].X][Brole[bnum].Y] = 1;
        PlayMagicAmination(bnum, Rmagic[mnum2].AmiNum);
        memcpy(&BField[4][0][0], &BField[5][0][0], 4096 * 2);
        AttackAction(bnum, mnum, level);
    }
}
void TSpecialAbility2::SA2_5(int bnum, int mnum, int mnum2, int level)
{
    if (mnum == 49)
    {
        ShowMagicName(mnum2);
        for (int i = 0; i < BRoleAmount; i++)
        {
            if (Brole[bnum].Team != Brole[i].Team && BField[4][Brole[i].X][Brole[i].Y] > 0)
            {
                ModifyState(i, 0, -50, rand() % 5);
                ModifyState(i, 1, -50, rand() % 5);
                ModifyState(i, 3, -1, rand() % 5);
            }
        }
        memcpy(&BField[5][0][0], &BField[4][0][0], 4096 * 2);
        memset(&BField[4][0][0], 0, 4096 * 2);
        BField[4][Brole[bnum].X][Brole[bnum].Y] = 1;
        PlayMagicAmination(bnum, Rmagic[mnum2].AmiNum);
        memcpy(&BField[4][0][0], &BField[5][0][0], 4096 * 2);
        AttackAction(bnum, mnum, level);
    }
}
void TSpecialAbility2::SA2_6(int bnum, int mnum, int mnum2, int level)
{
    if (mnum == 47)
    {
        ShowMagicName(mnum2);
        memcpy(&BField[5][0][0], &BField[4][0][0], 4096 * 2);
        memset(&BField[4][0][0], 0, 4096 * 2);
        BField[4][Brole[bnum].X][Brole[bnum].Y] = 1;
        PlayMagicAmination(bnum, Rmagic[mnum2].AmiNum);
        memcpy(&BField[4][0][0], &BField[5][0][0], 4096 * 2);
        for (int i = 0; i < BRoleAmount; i++)
        {
            if (Brole[bnum].Team != Brole[i].Team && BField[4][Brole[i].X][Brole[i].Y] > 0)
            {
                Brole[i].StateLevel[1] -= 120;
                Brole[i].StateRound[1] += 1;
            }
        }
        AttackAction(bnum, mnum, level);
        for (int i = 0; i < BRoleAmount; i++)
        {
            if (Brole[bnum].Team != Brole[i].Team && BField[4][Brole[i].X][Brole[i].Y] > 0)
            {
                Brole[i].StateLevel[1] += 120;
                Brole[i].StateRound[1] -= 1;
            }
        }
    }
}
void TSpecialAbility2::SA2_7(int bnum, int mnum, int mnum2, int level)
{
    if (mnum == 254)
    {
        ShowMagicName(mnum2);
        memset(&BField[4][0][0], 0, 4096 * 2);
        for (int i = 0; i < BRoleAmount; i++)
        {
            Brole[i].ShowNumber = -1;
            if (Brole[bnum].Team != Brole[i].Team && Brole[i].Dead == 0)
            {
                BField[4][Brole[i].X][Brole[i].Y] = 1 + rand() % 6;
                int rnum = Brole[i].rnum;
                int hurt = rand() % 100 + rand() % Rrole[Brole[bnum].rnum].CurrentHP;
                Rrole[rnum].CurrentHP = std::max(Rrole[rnum].CurrentHP - hurt, 0);
                Brole[i].ShowNumber = hurt;
            }
        }
        PlayActionAmination(bnum, Rmagic[mnum].MagicType);
        PlayMagicAmination(bnum, Rmagic[mnum2].AmiNum);
        ShowHurtValue(0);
    }
}
void TSpecialAbility2::SA2_8(int bnum, int mnum, int mnum2, int level)
{
    if (mnum == 332)
    {
        ShowMagicName(mnum2);
        int bnum2 = BField[2][Ax][Ay];
        if (bnum2 >= 0 && Brole[bnum].Team != Brole[bnum2].Team)
        {
            int rnum = Brole[bnum].rnum;
            int rnum2 = Brole[bnum2].rnum;
            int hurt = Rrole[rnum].CurrentMP - Rrole[rnum2].CurrentMP;
            int hurtMP = std::min((int)Rrole[rnum].CurrentMP, (int)Rrole[rnum2].CurrentMP);
            Rrole[rnum].CurrentMP -= hurtMP;
            Rrole[rnum2].CurrentMP -= hurtMP;
            if (hurt >= 0)
            {
                Rrole[rnum2].CurrentHP = std::max(Rrole[rnum2].CurrentHP - hurt, 0);
                Brole[bnum].ShowNumber = 0;
                Brole[bnum2].ShowNumber = hurt;
            }
            else
            {
                Rrole[rnum].CurrentHP = std::max(Rrole[rnum].CurrentHP - hurt, 0);
                Brole[bnum].ShowNumber = hurt;
                Brole[bnum2].ShowNumber = 0;
            }
            BField[4][Brole[bnum].X][Brole[bnum].Y] = 1 + rand() % 6;
            PlayActionAmination(bnum, Rmagic[mnum].MagicType);
            PlayMagicAmination(bnum, Rmagic[mnum2].AmiNum);
            ShowHurtValue(Rmagic[mnum].HurtType);
        }
    }
}
void TSpecialAbility2::SA2_9(int bnum, int mnum, int mnum2, int level)
{
    if (mnum == 164 && Rrole[Brole[bnum].rnum].Equip[0] == 31)
    {
        ShowMagicName(mnum2);
        Ax = Bx; Ay = By;
        SetAminationPosition(3, 0, 4);
        for (int i = 0; i < BRoleAmount; i++)
        {
            Brole[i].ShowNumber = -1;
            if (Brole[bnum].Team != Brole[i].Team && BField[4][Brole[i].X][Brole[i].Y] > 0)
            {
                int rnum = Brole[i].rnum;
                int hurt = Rrole[rnum].CurrentHP / 10;
                Rrole[rnum].CurrentHP = std::max(Rrole[rnum].CurrentHP - hurt, 0);
                Brole[i].ShowNumber = hurt;
                if (rand() % 100 < 30) ModifyState(i, 28, -1, 3);
            }
        }
        PlayActionAmination(bnum, Rmagic[mnum].MagicType);
        PlayMagicAmination(bnum, Rmagic[mnum2].AmiNum);
        ShowHurtValue(Rmagic[mnum].HurtType);
    }
}
void TSpecialAbility2::SA2_10(int bnum, int mnum, int mnum2, int level)
{
    int rnum = Brole[bnum].rnum;
    if (mnum == 87 && HaveMagic(rnum, 299, 0))
    {
        ShowMagicName(mnum2);
        Ax = Bx; Ay = By;
        SetAminationPosition(3, 0, 4);
        for (int i = 0; i < BRoleAmount; i++)
        {
            Brole[i].ShowNumber = -1;
            if (Brole[bnum].Team != Brole[i].Team && Brole[i].Dead == 0 && BField[4][Brole[i].X][Brole[i].Y] > 0)
            {
                int rn = Brole[i].rnum;
                int hurt = 100 * level + Rrole[Brole[bnum].rnum].Level * 10 - Rrole[rn].Defence;
                hurt = std::max(0, hurt);
                Rrole[rn].CurrentHP = std::max(Rrole[rn].CurrentHP - hurt, 0);
                Brole[i].ShowNumber = hurt;
                Rrole[rn].Poison = 100;
            }
        }
        PlayActionAmination(bnum, Rmagic[mnum].MagicType);
        PlayMagicAmination(bnum, Rmagic[mnum2].AmiNum);
        ShowHurtValue(0);
    }
}
void TSpecialAbility2::SA2_11(int bnum, int mnum, int mnum2, int level)
{
    if (Rmagic[mnum].MagicType == 3)
    {
        ShowMagicName(mnum2);
        Ax = Bx; Ay = By;
        SetAminationPosition(3, 0, 6);
        for (int i = 0; i < BRoleAmount; i++)
        {
            Brole[i].ShowNumber = -1;
            if (Brole[bnum].Team != Brole[i].Team && Brole[i].Dead == 0 && BField[4][Brole[i].X][Brole[i].Y] > 0)
            {
                int rnum = Brole[i].rnum;
                int hurt = 600;
                Rrole[rnum].CurrentHP = std::max(Rrole[rnum].CurrentHP - hurt, 0);
                Brole[i].ShowNumber = hurt;
            }
        }
        PlayActionAmination(bnum, Rmagic[mnum].MagicType);
        PlayMagicAmination(bnum, Rmagic[mnum2].AmiNum);
        ShowHurtValue(0);
    }
}
void TSpecialAbility2::SA2_12(int bnum, int mnum, int mnum2, int level)
{
    if (Rmagic[mnum].MagicType == 1)
    {
        ShowMagicName(mnum2);
        Ax = Bx; Ay = By;
        SetAminationPosition(3, 0, 4);
        memset(&BField[4][0][0], 0, 4096 * 2);
        for (int i = 0; i < BRoleAmount; i++)
        {
            Brole[i].ShowNumber = -1;
            if (Brole[i].Dead == 0)
            {
                if (Brole[bnum].Team != Brole[i].Team && BField[4][Brole[i].X][Brole[i].Y] > 0)
                {
                    int rnum = Brole[i].rnum;
                    int hurt = Rrole[Brole[bnum].rnum].Defence * 3 + rand() % 10;
                    hurt = std::max(0, hurt);
                    Rrole[rnum].CurrentHP = std::max(Rrole[rnum].CurrentHP - hurt, 0);
                    Brole[i].ShowNumber = hurt;
                }
                if (Brole[i].Team == Brole[bnum].Team)
                {
                    BField[4][Brole[i].X][Brole[i].Y] = 1 + rand() % 6;
                    ModifyState(i, 1, 30 + Rrole[Brole[bnum].rnum].Level, 3);
                }
            }
        }
        PlayActionAmination(bnum, Rmagic[mnum].MagicType);
        PlayMagicAmination(bnum, Rmagic[mnum2].AmiNum);
        ShowHurtValue(0);
    }
}
void TSpecialAbility2::SA2_100(int bnum, int mnum, int mnum2, int level)
{
    int rnum = Brole[bnum].rnum;
    if (HaveMagic(rnum, 301, 0))
    {
        ShowMagicName(mnum2);
        memset(&BField[4][0][0], 0, 4096 * 2);
        BField[4][Brole[bnum].X][Brole[bnum].Y] = 1;
        PlayMagicAmination(bnum, Rmagic[mnum2].AmiNum);
        ModifyState(bnum, 0, 50, 3);
        ModifyState(bnum, 1, 50, 3);
        if (rand() % 100 < 50) ModifyState(bnum, 29, 30, 3);
        if (rand() % 100 < 50) ModifyState(bnum, 30, 30, 3);
        if (rand() % 100 < 50) ModifyState(bnum, 31, 30, 3);
        if (rand() % 100 < 50) ModifyState(bnum, 32, 30, 3);
        if (rand() % 100 < 50) ModifyState(bnum, 33, 30, 3);
    }
}
void TSpecialAbility2::SA2_101(int bnum, int mnum, int mnum2, int level)
{
    int rnum = Brole[bnum].rnum;
    if (HaveMagic(rnum, 128, 0) && !HaveMagic(rnum, 127, 0) && !HaveMagic(rnum, 129, 0) && Rrole[rnum].CurrentMP >= 9000)
    {
        ShowMagicName(mnum2);
        memset(&BField[4][0][0], 0, 4096 * 2);
        BField[4][Brole[bnum].X][Brole[bnum].Y] = 1;
        PlayMagicAmination(bnum, Rmagic[mnum2].AmiNum);
        Rrole[rnum].PhyPower = std::min(MAX_PHYSICAL_POWER, (int)Rrole[rnum].PhyPower + 20);
        Brole[bnum].StateLevel[14] += 50;
    }
}
void TSpecialAbility2::SA2_102(int bnum, int mnum, int mnum2, int level)
{
    int rnum = Brole[bnum].rnum;
    ShowMagicName(mnum2);
    memset(&BField[4][0][0], 0, 4096 * 2);
    BField[4][Brole[bnum].X][Brole[bnum].Y] = 1;
    PlayMagicAmination(bnum, Rmagic[mnum2].AmiNum);
    Rrole[rnum].CurrentHP = Rrole[rnum].MaxHP;
}
void TSpecialAbility2::SA2_103(int bnum, int mnum, int mnum2, int level)
{
    int rnum = Brole[bnum].rnum;
    if (Rrole[rnum].CurrentHP < Rrole[rnum].MaxHP / 3)
    {
        ShowMagicName(mnum2);
        memset(&BField[4][0][0], 0, 4096 * 2);
        BField[4][Brole[bnum].X][Brole[bnum].Y] = 1;
        PlayMagicAmination(bnum, Rmagic[mnum2].AmiNum);
        for (int si = 0; si <= 20; si++)
        {
            if (si == 0 || si == 1 || si == 2 || si == 4 || si == 11 || si == 14 || si == 15)
            { Brole[bnum].StateLevel[si] = 100; Brole[bnum].StateRound[si] = 2; }
            else if (si == 7) {}
            else if (si == 5 || si == 6 || si == 20)
            { Brole[bnum].StateLevel[si] = 50; Brole[bnum].StateRound[si] = 2; }
            else
            { Brole[bnum].StateLevel[si] = 1; Brole[bnum].StateRound[si] = 2; }
        }
    }
}
