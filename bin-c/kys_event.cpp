// kys_event.cpp - 事件与对话系统
// 对应 kys_event.pas

#include "kys_event.h"
#include "kys_main.h"
#include "kys_engine.h"
#include "kys_draw.h"
#include "kys_battle.h"
#include "kys_script.h"

#include <cstring>
#include <cstdlib>
#include <cmath>
#include <algorithm>
#include <cstdio>
#include "filefunc.h"

// ---- 事件指令 ----

// instruct_0: 刷新场景
void instruct_0()
{
    if (NeedRefreshScene == 1)
    {
        Redraw();
        NeedRefreshScene = 0;
    }
}

// instruct_1: 对话
void instruct_1(int talknum, int headnum, int dismode)
{
    int namenum = headnum;
    if (dismode == 2 || dismode == 3)
        headnum = -1;
    if (MODVersion == 81)
        namenum = -2;
    NewTalk(headnum, talknum, namenum, dismode % 2, 0, 0, 0);
}

// 设置主角的步数及图片
void SetRolePic(int step, int pic)
{
    if (step >= 0)
        SStep = step;
    if (step >= 7)
        step = 1;
    if (pic < 0)
        CurSceneRolePic = BEGIN_WALKPIC2 + SFace * 7 + SStep;
}

// instruct_2: 得到物品可显示数量
void instruct_2(int inum, int amount)
{
    instruct_32(inum, amount);
    SetRolePic(0);
    int x = CENTER_X;
    int y = CENTER_Y;
    if (Where == 2)
    {
        x = CENTER_X;
        y = CENTER_Y + 60;
    }
    char word[64];
    snprintf(word, sizeof(word), "%d", amount);
    int l1 = DrawLength(Ritem[inum].Name);
    int l2 = DrawLength(word);
    DrawTextFrame(CENTER_X - (6 + l1 + l2) * 5 - 20, y, 6 + l1 + l2);
    x = CENTER_X - (6 + l1 + l2) * 5 + 1;
    DrawEngShadowText(word, x + 40 + 20 + l1 * 10, 3 + y, 0, 0x202020);
    std::string w2;
    if (amount >= 0)
        w2 = "得到"; // 得到
    else
    {
        w2 = "失去"; // 失去
        amount = -amount;
    }
    DrawShadowText(w2.c_str(), x, 3 + y, 0, 0x202020);
    DrawIPic(inum, CENTER_X - 40, y - 90, 0, 0, 0, 0);
    DrawShadowText(Ritem[inum].Name, x + 40, 3 + y, ColColor(0x64), ColColor(0x66));
    UpdateAllScreen();
    if (Where == 2)
    {
        if (Bstatus == 0)
        {
            SDL_Delay(500);
            Redraw();
        }
        else
            WaitAnyKey();
    }
    else
    {
        WaitAnyKey();
        Redraw();
    }
}

// 重排物品，清除为0的物品，合并同类物品
void ReArrangeItem(int sort)
{
    int p = 0;
    std::vector<int> item(MAX_ITEM_AMOUNT);
    std::vector<int> amount(1002, 0); // max item count

    for (int i = 0; i < MAX_ITEM_AMOUNT; i++)
    {
        if (RItemList[i].Number >= 0 && RItemList[i].Amount > 0)
        {
            if (amount[RItemList[i].Number] == 0)
            {
                item[p] = RItemList[i].Number;
                amount[RItemList[i].Number] = RItemList[i].Amount;
                p++;
            }
            else
                amount[RItemList[i].Number] += RItemList[i].Amount;
        }
    }

    if (sort == 0)
    {
        for (int i = 0; i < MAX_ITEM_AMOUNT; i++)
        {
            if (i < p)
            {
                RItemList[i].Number = item[i];
                RItemList[i].Amount = amount[item[i]];
            }
            else
            {
                RItemList[i].Number = -1;
                RItemList[i].Amount = 0;
            }
        }
    }
    else
    {
        for (int i = 0; i < MAX_ITEM_AMOUNT; i++)
        {
            RItemList[i].Number = -1;
            RItemList[i].Amount = 0;
        }
        int j = 0;
        for (int i = 0; i < (int)amount.size(); i++)
        {
            if (amount[i] > 0)
            {
                RItemList[j].Number = i;
                RItemList[j].Amount = amount[i];
                j++;
            }
        }
    }
}

// instruct_3: 改变事件
void instruct_3(std::vector<int> list)
{
    if (list.size() < 13) return;

    int curPic = 0;
    if (CurEvent > 0)
        curPic = DData[CurScene][CurEvent][5];
    if (list[0] == -2) list[0] = CurScene;
    if (list[1] == -2) list[1] = CurEvent;
    if (list[11] == -2) list[11] = DData[list[0]][list[1]][9];
    if (list[12] == -2) list[12] = DData[list[0]][list[1]][10];
    int preEventPic = DData[list[0]][list[1]][5];

    bool ModifyS = true;
    if ((MODVersion == 12 || MODVersion == 31) && list[0] != CurScene)
        ModifyS = false;
    if (ModifyS)
        SData[list[0]][3][DData[list[0]][list[1]][10]][DData[list[0]][list[1]][9]] = -1;
    for (int i = 0; i <= 10; i++)
    {
        if (list[2 + i] != -2)
            DData[list[0]][list[1]][i] = list[2 + i];
    }
    SData[list[0]][3][DData[list[0]][list[1]][10]][DData[list[0]][list[1]][9]] = list[1];

    if (CurEvent > 0 && DData[CurScene][CurEvent][5] != curPic)
    {
        if (PNG_TILE > 0)
        {
            int idx = DData[CurScene][CurEvent][5] / 2;
            LoadOnePNGTexture("resource/smap/", pSPic, SPNGIndex[idx]);
        }
        Redraw();
    }
    if (list[0] == CurScene && preEventPic != DData[list[0]][list[1]][5])
        NeedRefreshScene = 1;
}

// instruct_4: 是否使用了某剧情物品
int instruct_4(int inum, int jump1, int jump2)
{
    return (inum == CurItem) ? jump1 : jump2;
}

// instruct_5: 询问是否战斗
int instruct_5(int jump1, int jump2)
{
    std::string menuString[2] = {"取消", "戰鬥"}; // 取消, 戰鬥
    std::string str = "是否與之戰鬥？"; // 是否與之戰鬥？
    DrawTextWithRect(str.c_str(), CENTER_X - 75, CENTER_Y - 85, 0, 0, 0x202020);
    std::vector<std::string> ms(menuString, menuString + 2);
    int menu = CommonMenu2(CENTER_X - 49, CENTER_Y - 50, 48, ms);
    int result = (menu == 1) ? jump1 : jump2;
    Redraw();
    UpdateAllScreen();
    return result;
}

// instruct_6: 战斗
int instruct_6(int battlenum, int jump1, int jump2, int getexp)
{
    int result = jump2;
    if (ForceBattleWin == 1 || Battle(battlenum, getexp))
        result = jump1;
    return result;
}

// instruct_8: 设置离场音乐
void instruct_8(int musicnum)
{
    ExitSceneMusicNum = musicnum;
}

// instruct_9: 询问是否加入
int instruct_9(int jump1, int jump2)
{
    std::string menuString[2] = {"取消", "要求"}; // 取消, 要求
    std::string str = "是否要求加入？"; // 是否要求加入？
    DrawTextWithRect(str.c_str(), CENTER_X - 75, CENTER_Y - 85, 0, 0, 0x202020);
    std::vector<std::string> ms(menuString, menuString + 2);
    int menu = CommonMenu2(CENTER_X - 49, CENTER_Y - 50, 48, ms);
    int result = (menu == 1) ? jump1 : jump2;
    Redraw();
    UpdateAllScreen();
    return result;
}

// instruct_10: 加入队友，同时得到其身上物品
void instruct_10(int rnum)
{
    for (int i = 0; i < 6; i++)
    {
        if (TeamList[i] < 0)
        {
            TeamList[i] = rnum;
            for (int i1 = 0; i1 < 4; i1++)
            {
                if (Rrole[rnum].TakingItem[i1] >= 0 && Rrole[rnum].TakingItemAmount[i1] >= 0)
                {
                    if (Rrole[rnum].TakingItemAmount[i1] == 0)
                        Rrole[rnum].TakingItemAmount[i1] = 1;
                    instruct_2(Rrole[rnum].TakingItem[i1], Rrole[rnum].TakingItemAmount[i1]);
                    Rrole[rnum].TakingItem[i1] = -1;
                    Rrole[rnum].TakingItemAmount[i1] = 0;
                }
            }
            break;
        }
    }
}

// instruct_11: 询问是否住宿/通用选择
int instruct_11(int jump1, int jump2)
{
    std::string menuString[2];
    std::string str;
    if (MODVersion == 31 || MODVersion == 12)
    {
        menuString[0] = "N-否"; // N-否
        menuString[1] = "Y-是"; // Y-是
        str = "請作出您的選擇"; // 請作出您的選擇
    }
    else
    {
        menuString[0] = "取消"; // 取消
        menuString[1] = "住宿"; // 住宿
        str = "是否需要住宿？"; // 是否需要住宿？
    }
    DrawTextWithRect(str.c_str(), CENTER_X - 75, CENTER_Y - 85, 0, 0, 0x202020);
    std::vector<std::string> ms(menuString, menuString + 2);
    int menu = CommonMenu2(CENTER_X - 49, CENTER_Y - 50, 48, ms);
    int result = (menu == 1) ? jump1 : jump2;
    Redraw();
    UpdateAllScreen();
    return result;
}

// instruct_12: 住宿恢复
void instruct_12()
{
    for (int i = 0; i < 6; i++)
    {
        int rnum = TeamList[i];
        if (rnum != -1 && Rrole[rnum].Hurt <= 33 && Rrole[rnum].Poison <= 0)
        {
            Rrole[rnum].CurrentHP = Rrole[rnum].MaxHP;
            Rrole[rnum].CurrentMP = Rrole[rnum].MaxMP;
            Rrole[rnum].PhyPower = MAX_PHYSICAL_POWER;
        }
    }
}

// instruct_13: 亮屏
void instruct_13()
{
    NeedRefreshScene = 0;
    BlackScreen = 0;
    Redraw();
    UpdateAllScreen();
}

// instruct_14: 黑屏
void instruct_14()
{
    CleanTextScreen();
    for (int i = 10; i >= 0; i--)
    {
        SDL_Delay(10);
        DrawRectangleWithoutFrame(0, 0, CENTER_X * 2, CENTER_Y * 2, 0, i * 10);
        UpdateAllScreen();
    }
    SDL_Delay(50);
    BlackScreen = 10;
}

// instruct_15: 失败画面
void instruct_15()
{
    Where = 3;
    Redraw();
    DrawRectangleWithoutFrame(0, 0, CENTER_X * 2, CENTER_Y * 2, MapRGBA(196, 25, 16), 60);
    std::string str1 = " 小村的傳說失敗了…"; // 小村的傳說失敗了…
    DrawShadowText(str1.c_str(), CENTER_X - 120, CENTER_Y - 25, ColColor(255), ColColor(255));
    std::string str2 = "但是遊戲是可以重來的！"; // 但是遊戲是可以重來的！
    DrawShadowText(str2.c_str(), CENTER_X - 120, CENTER_Y, ColColor(255), ColColor(255));
    UpdateAllScreen();
    WaitAnyKey();
}

// instruct_16: 队伍中是否有某人
int instruct_16(int rnum, int jump1, int jump2)
{
    for (int i = 0; i < 6; i++)
    {
        if (TeamList[i] == rnum)
            return jump1;
    }
    return jump2;
}

// instruct_17: 改变场景数据
void instruct_17(std::vector<int> list)
{
    if (list.size() < 5) return;
    if (list[0] == -2) list[0] = CurScene;
    SData[list[0]][list[1]][list[3]][list[2]] = list[4];
    if (list[0] == CurScene)
        NeedRefreshScene = 1;
}

// instruct_18: 是否有某物品
int instruct_18(int inum, int jump1, int jump2)
{
    for (int i = 0; i < MAX_ITEM_AMOUNT; i++)
    {
        if (RItemList[i].Number == inum)
            return jump1;
    }
    return jump2;
}

// instruct_19: 改变坐标
void instruct_19(int x, int y)
{
    Sx = y;
    Sy = x;
    Cx = Sx;
    Cy = Sy;
    SStep = 0;
    CurSceneRolePic = BEGIN_WALKPIC2 + SFace * 7 + SStep;
    Redraw();
}

// instruct_20: 判断队伍是否满
int instruct_20(int jump1, int jump2)
{
    for (int i = 0; i < 6; i++)
    {
        if (TeamList[i] < 0)
            return jump2;
    }
    return jump1;
}

// instruct_21: 离队某人
void instruct_21(int rnum)
{
    int newlist[6];
    int p = 0;
    for (int i = 0; i < 6; i++)
    {
        newlist[i] = -1;
        if (TeamList[i] != rnum)
        {
            newlist[p] = TeamList[i];
            p++;
        }
    }
    for (int i = 0; i < 6; i++)
        TeamList[i] = newlist[i];
}

// instruct_22: 清空所有队友MP
void instruct_22()
{
    for (int i = 0; i < 6; i++)
        Rrole[TeamList[i]].CurrentMP = 0;
}

// instruct_23: 设置用毒能力
void instruct_23(int rnum, int Poison)
{
    Rrole[rnum].UsePoi = Poison;
}

// instruct_24: 空指令
void instruct_24()
{
}

// instruct_25: 滚动场景（不显示主角）
void instruct_25(int x1, int y1, int x2, int y2)
{
    auto sgn = [](int v) -> int { return (v > 0) ? 1 : ((v < 0) ? -1 : 0); };
    SDL_Event ev;
    int s = sgn(x2 - x1);
    int i = x1 + s;
    Cx = y1;
    Cy = x1;
    if (s != 0)
    {
        while (SDL_PollEvent(&ev) || true)
        {
            CheckBasicEvent();
            SDL_Delay(50);
            Cy = i;
            DrawScene();
            UpdateAllScreen();
            i += s;
            if (s * (x2 - i) < 0) break;
        }
    }
    s = sgn(y2 - y1);
    i = y1 + s;
    if (s != 0)
    {
        while (SDL_PollEvent(&ev) || true)
        {
            CheckBasicEvent();
            SDL_Delay(50);
            Cx = i;
            DrawScene();
            UpdateAllScreen();
            i += s;
            if (s * (y2 - i) < 0) break;
        }
    }
    Cx = y2;
    Cy = x2;
}

// instruct_26: 修改事件偏移
void instruct_26(int snum, int eNum, int add1, int add2, int add3)
{
    if (snum == -2) snum = CurScene;
    DData[snum][eNum][2] += add1;
    DData[snum][eNum][3] += add2;
    DData[snum][eNum][4] += add3;
}

// instruct_27: 动画
void instruct_27(int eNum, int beginpic, int endpic)
{
    SDL_Event ev;
    if (eNum >= 0 && DData[CurScene][eNum][10] == Sx && DData[CurScene][eNum][9] == Sy)
        eNum = -1;
    if (eNum == -1)
    {
        int i = beginpic;
        while (SDL_PollEvent(&ev) || true)
        {
            CheckBasicEvent();
            CurSceneRolePic = i / 2;
            SDL_Delay(WALK_SPEED2 * 2);
            DrawScene();
            UpdateAllScreen();
            i++;
            if (i > endpic) break;
        }
    }
    else
    {
        int i = beginpic;
        while (SDL_PollEvent(&ev) || true)
        {
            CheckBasicEvent();
            DData[CurScene][eNum][5] = i;
            DData[CurScene][eNum][6] = i;
            DData[CurScene][eNum][7] = i;
            SDL_Delay(20);
            DrawScene();
            UpdateAllScreen();
            i++;
            if (i > endpic) break;
        }
    }
}

// instruct_28: 判断品德范围
int instruct_28(int rnum, int e1, int e2, int jump1, int jump2)
{
    if (Rrole[rnum].Ethics >= e1 && Rrole[rnum].Ethics <= e2)
        return jump1;
    return jump2;
}

// instruct_29: 判断攻击力
int instruct_29(int rnum, int r1, int r2, int jump1, int jump2)
{
    if (Rrole[rnum].Attack >= r1)
        return jump1;
    return jump2;
}

// instruct_30: 主角行走动画
void instruct_30(int x1, int y1, int x2, int y2)
{
    auto sgn = [](int v) -> int { return (v > 0) ? 1 : ((v < 0) ? -1 : 0); };
    SDL_Event ev;
    int s = sgn(x2 - x1);
    Sy = x1 + s;
    if (s > 0) SFace = 1;
    if (s < 0) SFace = 2;
    if (s != 0)
    {
        while (SDL_PollEvent(&ev) || true)
        {
            CheckBasicEvent();
            SDL_Delay(50);
            SStep++;
            if (SStep >= 7) SStep = 1;
            CurSceneRolePic = BEGIN_WALKPIC2 + SFace * 7 + SStep;
            Cx = Sx; Cy = Sy;
            DrawScene();
            UpdateAllScreen();
            Sy += s;
            if (s * (x2 - Sy) < 0) break;
        }
    }
    s = sgn(y2 - y1);
    Sx = y1 + s;
    if (s > 0) SFace = 3;
    if (s < 0) SFace = 0;
    if (s != 0)
    {
        while (SDL_PollEvent(&ev) || true)
        {
            SDL_Delay(50);
            SStep++;
            if (SStep >= 7) SStep = 1;
            CurSceneRolePic = BEGIN_WALKPIC2 + SFace * 7 + SStep;
            Cx = Sx; Cy = Sy;
            DrawScene();
            UpdateAllScreen();
            Sx += s;
            if (s * (y2 - Sx) < 0) break;
        }
    }
    Sx = y2;
    Sy = x2;
    SStep = 0;
    CurSceneRolePic = BEGIN_WALKPIC2 + SFace * 7;
    Cx = Sx;
    Cy = Sy;
}

// instruct_31: 判断银两是否足够
int instruct_31(int moneynum, int jump1, int jump2)
{
    if (moneynum <= 0) return jump1;
    for (int i = 0; i < MAX_ITEM_AMOUNT; i++)
    {
        if (RItemList[i].Number == MONEY_ID && RItemList[i].Amount >= moneynum)
            return jump1;
    }
    return jump2;
}

// instruct_32: 增减物品数量（不显示）
void instruct_32(int inum, int amount)
{
    if (amount == 0) return;
    int i = 0;
    while (RItemList[i].Number >= 0 && i < MAX_ITEM_AMOUNT)
    {
        if (RItemList[i].Number == inum)
        {
            RItemList[i].Amount += amount;
            if (RItemList[i].Amount < 0 && amount >= 0)
                RItemList[i].Amount = 0x7FFFFFFF;
            if (RItemList[i].Amount < 0 && amount < 0)
                RItemList[i].Amount = 0;
            break;
        }
        i++;
    }
    if (RItemList[i].Number < 0)
    {
        RItemList[i].Number = inum;
        RItemList[i].Amount = amount;
    }
    ReArrangeItem();
}

// instruct_33: 学到武功
void instruct_33(int rnum, int mnum, int dismode)
{
    if (Rmagic[mnum].HurtType == 3)
    {
        // 内功
        int p = -1, pm = -1;
        for (int i = 0; i < 4; i++)
        {
            if (Rrole[rnum].NeiGong[i] <= 0 && p < 0) p = i;
            if (Rrole[rnum].NeiGong[i] == mnum) pm = i;
        }
        int idx = (pm >= 0) ? pm : p;
        if (idx >= 0)
        {
            if (Rrole[rnum].NeiGong[idx] <= 0 || Rrole[rnum].NeiGong[idx] == mnum)
            {
                if (Rrole[rnum].NeiGong[idx] > 0)
                    Rrole[rnum].NGLevel[idx] += 100;
                Rrole[rnum].NeiGong[idx] = mnum;
                if (Rrole[rnum].NGLevel[idx] > 999)
                    Rrole[rnum].NGLevel[idx] = 999;
            }
        }
    }
    else
    {
        // 外功
        int p = -1, pm = -1;
        for (int i = 0; i < 10; i++)
        {
            if (Rrole[rnum].Magic[i] <= 0 && p < 0) p = i;
            if (Rrole[rnum].Magic[i] == mnum) pm = i;
        }
        int idx = (pm >= 0) ? pm : p;
        if (idx >= 0)
        {
            if (Rrole[rnum].Magic[idx] <= 0 || Rrole[rnum].Magic[idx] == mnum)
            {
                if (Rrole[rnum].Magic[idx] > 0)
                    Rrole[rnum].MagLevel[idx] += 100;
                Rrole[rnum].Magic[idx] = mnum;
                if (Rrole[rnum].MagLevel[idx] > 999)
                    Rrole[rnum].MagLevel[idx] = 999;
            }
        }
    }
    if (dismode == 0)
    {
        std::string word = "學會"; // 學會
        Show3HintString(Rrole[rnum].Name, word, Rmagic[mnum].Name);
    }
}

// instruct_34: 增加资质
void instruct_34(int rnum, int iq)
{
    if (Rrole[rnum].Aptitude + iq <= 100)
        Rrole[rnum].Aptitude += iq;
    else
    {
        iq = 100 - Rrole[rnum].Aptitude;
        Rrole[rnum].Aptitude = 100;
    }
    if (iq > 0)
    {
        std::string word = "資質增加"; // 資質增加
        char buf[16];
        snprintf(buf, sizeof(buf), "%3d", iq);
        Show3HintString(Rrole[rnum].Name, word, buf);
    }
}

// instruct_35: 设置武功
void instruct_35(int rnum, int magiclistnum, int magicnum, int exp)
{
    if (magiclistnum < 0 || magiclistnum > 9)
    {
        for (int i = 0; i < 10; i++)
        {
            if (Rrole[rnum].Magic[i] <= 0)
            {
                Rrole[rnum].Magic[i] = magicnum;
                Rrole[rnum].MagLevel[i] = exp;
                break;
            }
        }
    }
    else
    {
        Rrole[rnum].Magic[magiclistnum] = magicnum;
        Rrole[rnum].MagLevel[magiclistnum] = exp;
    }
}

// instruct_36: 判断性别
int instruct_36(int sexual, int jump1, int jump2)
{
    if (sexual > 255)
    {
        return (x50[0x7000] == 0) ? jump1 : jump2;
    }
    return (Rrole[0].Sexual == sexual) ? jump1 : jump2;
}

// instruct_37: 修改品德
void instruct_37(int Ethics)
{
    Rrole[0].Ethics += Ethics;
    if (Rrole[0].Ethics > 100) Rrole[0].Ethics = 100;
    if (Rrole[0].Ethics < 0) Rrole[0].Ethics = 0;
}

// instruct_38: 替换场景贴图
void instruct_38(int snum, int layernum, int oldpic, int newpic)
{
    if (snum == -2) snum = CurScene;
    for (int i1 = 0; i1 < 64; i1++)
        for (int i2 = 0; i2 < 64; i2++)
        {
            if (SData[snum][layernum][i1][i2] == oldpic)
                SData[snum][layernum][i1][i2] = newpic;
        }
    if (snum == CurScene)
    {
        Redraw();
        NeedRefreshScene = 0;
    }
}

// instruct_39: 取消场景进入条件
void instruct_39(int snum)
{
    Rscene[snum].EnCondition = 0;
}

// instruct_40: 设置朝向
void instruct_40(int director)
{
    SFace = director;
    CurSceneRolePic = BEGIN_WALKPIC2 + SFace * 7;
    DrawScene();
}

// instruct_41: 修改角色携带物品
void instruct_41(int rnum, int inum, int amount)
{
    int p = 0;
    for (int i = 0; i < 4; i++)
    {
        if (Rrole[rnum].TakingItem[i] == inum)
        {
            Rrole[rnum].TakingItemAmount[i] += amount;
            p = 1;
            break;
        }
    }
    if (p == 0)
    {
        for (int i = 0; i < 4; i++)
        {
            if (Rrole[rnum].TakingItem[i] == -1)
            {
                Rrole[rnum].TakingItem[i] = inum;
                Rrole[rnum].TakingItemAmount[i] = amount;
                break;
            }
        }
    }
    for (int i = 0; i < 4; i++)
    {
        if (Rrole[rnum].TakingItemAmount[i] <= 0)
        {
            Rrole[rnum].TakingItem[i] = -1;
            Rrole[rnum].TakingItemAmount[i] = 0;
        }
    }
}

// instruct_42: 队伍中是否有女性
int instruct_42(int jump1, int jump2)
{
    for (int i = 0; i < 6; i++)
    {
        if (Rrole[TeamList[i]].Sexual == 1)
            return jump1;
    }
    return jump2;
}

// instruct_43: 是否有某物品（同instruct_18）
int instruct_43(int inum, int jump1, int jump2)
{
    for (int i = 0; i < MAX_ITEM_AMOUNT; i++)
    {
        if (RItemList[i].Number == inum)
            return jump1;
    }
    return jump2;
}

// instruct_44: 双事件动画
void instruct_44(int enum1, int beginpic1, int endpic1, int enum2, int beginpic2, int endpic2)
{
    SDL_Event ev;
    SData[CurScene][3][DData[CurScene][enum1][10]][DData[CurScene][enum1][9]] = enum1;
    SData[CurScene][3][DData[CurScene][enum2][10]][DData[CurScene][enum2][9]] = enum2;
    int i = 0;
    while (SDL_PollEvent(&ev) || true)
    {
        CheckBasicEvent();
        DData[CurScene][enum1][5] = beginpic1 + i;
        DData[CurScene][enum2][5] = beginpic2 + i;
        SDL_Delay(20);
        DrawScene();
        UpdateAllScreen();
        i++;
        if (i > endpic1 - beginpic1) break;
    }
}

// instruct_44e: 三事件动画
void instruct_44e(int enum1, int beginpic1, int endpic1, int enum2, int beginpic2, int enum3, int beginpic3)
{
    SDL_Event ev;
    SData[CurScene][3][DData[CurScene][enum1][10]][DData[CurScene][enum1][9]] = enum1;
    SData[CurScene][3][DData[CurScene][enum2][10]][DData[CurScene][enum2][9]] = enum2;
    SData[CurScene][3][DData[CurScene][enum3][10]][DData[CurScene][enum3][9]] = enum3;
    int i = 0;
    while (SDL_PollEvent(&ev) || true)
    {
        CheckBasicEvent();
        DData[CurScene][enum1][5] = beginpic1 + i;
        DData[CurScene][enum2][5] = beginpic2 + i;
        DData[CurScene][enum3][5] = beginpic3 + i;
        SDL_Delay(20);
        DrawScene();
        UpdateAllScreen();
        i++;
        if (i > endpic1 - beginpic1) break;
    }
}

// 显示三段提示字符串
void Show3HintString(const std::string& str1, const std::string& str2, const std::string& str3)
{
    int l1 = DrawLength(str1.c_str());
    int l2 = DrawLength(str2.c_str());
    int l3 = DrawLength(str3.c_str());
    int l = l1 + l2 + l3;
    int x = CENTER_X - l * 5;
    DrawTextFrame(x - 19, 150, l);
    if (l1 > 0) DrawShadowText(str1.c_str(), x, 153, ColColor(0x64), ColColor(0x66));
    if (l2 > 0) DrawShadowText(str2.c_str(), x + l1 * 10, 153, 0, 0x202020);
    if (l3 > 0) DrawShadowText(str3.c_str(), x + l1 * 10 + l2 * 10, 153, ColColor(0x64), ColColor(0x66));
    UpdateAllScreen();
    WaitAnyKey();
    Redraw();
}

// 增加角色属性并显示提示
void AddRoleProWithHint(int rnum, int datalist, int num, const std::string& word)
{
    Rrole[rnum].Data[datalist] += num;
    if (!word.empty())
    {
        char buf[16];
        snprintf(buf, sizeof(buf), "%d", num);
        Show3HintString(Rrole[rnum].Name, word, buf);
    }
}

// instruct_45: 增加轻功
void instruct_45(int rnum, int speed)
{
    Rrole[rnum].Speed += speed;
    char buf[16];
    snprintf(buf, sizeof(buf), "%d", speed);
    Show3HintString(Rrole[rnum].Name, "輕功增加", buf);
}

// instruct_46: 增加内力
void instruct_46(int rnum, int mp)
{
    Rrole[rnum].MaxMP += mp;
    Rrole[rnum].CurrentMP = Rrole[rnum].MaxMP;
    char buf[16];
    snprintf(buf, sizeof(buf), "%d", mp);
    Show3HintString(Rrole[rnum].Name, "內力增加", buf);
}

// instruct_47: 增加武力
void instruct_47(int rnum, int Attack)
{
    Rrole[rnum].Attack += Attack;
    char buf[16];
    snprintf(buf, sizeof(buf), "%d", Attack);
    Show3HintString(Rrole[rnum].Name, "武力增加", buf);
}

// instruct_48: 增加生命
void instruct_48(int rnum, int hp)
{
    Rrole[rnum].MaxHP += hp;
    Rrole[rnum].CurrentHP = Rrole[rnum].MaxHP;
    char buf[16];
    snprintf(buf, sizeof(buf), "%d", hp);
    Show3HintString(Rrole[rnum].Name, "生命增加", buf);
}

// instruct_49: 设置内力类型
void instruct_49(int rnum, int MPpro)
{
    Rrole[rnum].MPType = MPpro;
}

// instruct_50: 扩展指令
int instruct_50(std::vector<int> list)
{
    if (list.size() < 7) return 0;
    if (list[0] <= 128)
        return instruct_50e(list[0], list[1], list[2], list[3], list[4], list[5], list[6]);
    else
    {
        int result = list[6];
        int p = 0;
        for (int i = 0; i < 5; i++)
            p += instruct_18(list[i], 1, 0);
        if (p == 5)
            result = list[5];
        return result;
    }
}

// instruct_51: 随机软星笑话
void instruct_51()
{
    instruct_1(SOFTSTAR_BEGIN_TALK + rand() % SOFTSTAR_NUM_TALK, 0x72, 0);
}

// 显示角色属性
void ShowRolePro(int rnum, int datalist, const std::string& word)
{
    Redraw();
    char buf[16];
    snprintf(buf, sizeof(buf), "%4d", Rrole[rnum].Data[datalist]);
    Show3HintString("", word, buf);
}

// instruct_52: 显示品德
void instruct_52()
{
    int idx = offsetof(TRole, Ethics) / sizeof(int);
    ShowRolePro(0, idx, "你的品德指數為："); // 你的品德指數為：
}

// instruct_53: 显示声望
void instruct_53()
{
    int idx = offsetof(TRole, Repute) / sizeof(int);
    ShowRolePro(0, idx, "你的聲望指數為："); // 你的聲望指數為：
}

// instruct_54: 开放所有场景
void instruct_54()
{
    for (int i = 0; i <= 100; i++)
        Rscene[i].EnCondition = 0;
    Rscene[2].EnCondition = 2;
    Rscene[38].EnCondition = 2;
    Rscene[75].EnCondition = 1;
    Rscene[80].EnCondition = 1;
}

// instruct_55: 判断事件编号
int instruct_55(int eNum, int num, int jump1, int jump2)
{
    return (DData[CurScene][eNum][2] == num) ? jump1 : jump2;
}

// instruct_56: 增加声望
void instruct_56(int Repute)
{
    Rrole[0].Repute += Repute;
    if (Rrole[0].Repute > 200 && Rrole[0].Repute - Repute <= 200)
    {
        instruct_3({70, 11, 0, 11, 0x3A4, -1, -1, 0x1F20, 0x1F20, 0x1F20, 0, 18, 21});
    }
}

// instruct_57: 特殊动画序列
void instruct_57()
{
    instruct_27(-1, 3832 * 2, 3844 * 2);
    instruct_44e(2, 3845 * 2, 3873 * 2, 3, 3874 * 2, 4, 3903 * 2);
}

// instruct_58: 连续战斗
void instruct_58()
{
    static const int headarray[30] = {
        8, 21, 23, 31, 32, 43, 7, 11, 14, 20, 33, 34, 10, 12, 19,
        22, 56, 68, 13, 55, 62, 67, 70, 71, 26, 57, 60, 64, 3, 69
    };
    for (int i = 0; i < 15; i++)
    {
        int p = rand() % 2;
        instruct_1(2854 + i * 2 + p, headarray[i * 2 + p], rand() % 2 * 4 + rand() % 2);
        if (!Battle(102 + i * 2 + p, 0))
        {
            instruct_15();
            break;
        }
        instruct_14();
        instruct_13();
        if (i % 3 == 2)
        {
            instruct_1(2891, 70, 4);
            instruct_12();
            instruct_14();
            instruct_13();
        }
    }
    if (Where != 3)
    {
        instruct_1(2884, 70, 0);
        instruct_1(2885, 70, 0);
        instruct_1(2886, 0, 3);
        instruct_1(2887, 0, 2);
        instruct_1(2888, 19, 1);
        instruct_1(2889, 0, 1);
        instruct_2(0x8F, 1);
    }
}

// instruct_59: 全员离队
void instruct_59()
{
    for (int i = 1; i <= 5; i++)
        CallEvent(BEGIN_LEAVE_EVENT + TeamList[i] * 2);
}

// instruct_60: 判断事件贴图
int instruct_60(int snum, int eNum, int pic, int jump1, int jump2)
{
    if (snum == -2) snum = CurScene;
    return (DData[snum][eNum][5] == pic) ? jump1 : jump2;
}

// instruct_61: 判断所有事件贴图
int instruct_61(int jump1, int jump2)
{
    int result = jump1;
    for (int i = 11; i <= 24; i++)
    {
        if (DData[CurScene][i][5] != 4664)
            result = jump2;
    }
    return result;
}

// instruct_62: 结局动画
void instruct_62(int enum1, int beginpic1, int endpic1, int enum2, int beginpic2, int endpic2)
{
    ShowMR = false;
    instruct_44(enum1, beginpic1, endpic1, enum2, beginpic2, endpic2);
    Where = 3;
    Redraw();
    EndAmi();
    ShowMR = true;
}

// 文字动画
void TextAmi(const std::string& filename)
{
    TurnBlack();
    Redraw();
    // 读取文件内容
    std::string fullpath = AppPath + filename;
    FILE* f = fopen(fullpath.c_str(), "rb");
    if (!f) return;
    fseek(f, 0, SEEK_END);
    long len = ftell(f);
    fseek(f, 0, SEEK_SET);
    std::string str(len, 0);
    fread(&str[0], 1, len, f);
    fclose(f);

    int x = 70, y = 190;
    DrawRectangleWithoutFrame(0, 0, CENTER_X * 2, CENTER_Y * 2, 0, 60);
    std::string line;
    for (int i = 0; i < (int)str.size(); i++)
    {
        if (str[i] == '\n') str[i] = ' ';
        if (str[i] == '\r')
        {
            DrawShadowText(line.c_str(), x, y, ColColor(0xFF), ColColor(0xFF));
            line.clear();
            y += 25;
            UpdateAllScreen();
        }
        else if (str[i] == '*')
        {
            y = 190;
            Redraw();
            WaitAnyKey();
            DrawRectangleWithoutFrame(0, 0, CENTER_X * 2, CENTER_Y * 2, 0, 60);
        }
        else
        {
            line += str[i];
        }
    }
    WaitAnyKey();
    TurnBlack();
    BlackScreen = 0;
}

// 结局动画
void EndAmi()
{
    std::string content = filefunc::readFileToString(AppPath + "txt/end.txt");
    std::vector<std::string> words;
    std::string line;
    for (auto& ch : content)
    {
        if (ch == '\n') { words.push_back(line); line.clear(); }
        else if (ch != '\r') { line += ch; }
    }
    if (!line.empty()) words.push_back(line);

    PlayMP3(StartMusic, -1);
    ScrollTextAmi(words, 22, 21, 25, 1, 40, 0, 30, -1, 0);

    // title pic animation: scroll up from bottom
    if (1 < (int)TitlePNGIndex.size())
    {
        int h = TitlePNGIndex[1].h;
        for (int i = CENTER_Y * 2 - h; i <= 0; i++)
        {
            CheckBasicEvent();
            DrawTPic(1, CENTER_X - 320, i);
            UpdateAllScreen();
            SDL_Delay(6);
        }
    }
    SDL_Delay(1000);
    Maker();
}

// instruct_63: 设置性别
void instruct_63(int rnum, int sexual)
{
    Rrole[rnum].Sexual = sexual;
}

// instruct_64: 韦小宝商店
void instruct_64()
{
    int shopnum = rand() % 5;
    NewShop(shopnum);
    instruct_1(0xBA0, 0x6F, 0);
}

// instruct_66: 切换音乐
void instruct_66(int musicnum)
{
    StopMP3();
    PlayMP3(musicnum, -1);
}

// instruct_67: 播放音效
void instruct_67(int Soundnum)
{
    PlaySoundA(Soundnum, 0);
}

// ---- 50指令子系统----

// 获取变量值
int e_GetValue(int bit, int t, int x)
{
    int i = t & (1 << bit);
    return (i == 0) ? x : x50[x];
}

// 扩展50指令
int instruct_50e(int code, int e1, int e2, int e3, int e4, int e5, int e6)
{
    int result = 0;
    int t1, i, i1, i2;
    char* pw;
    char* pw1;

    switch (code)
    {
    case 0: // 赋值
        x50[e1] = e2;
        break;
    case 1: // 写组
        t1 = e3 + e_GetValue(0, e1, e4);
        x50[t1] = e_GetValue(1, e1, e5);
        if (e2 == 1) x50[t1] &= 0xFF;
        break;
    case 2: // 读组
        t1 = e3 + e_GetValue(0, e1, e4);
        x50[e5] = x50[t1];
        if (e2 == 1) x50[t1] &= 0xFF;
        break;
    case 3: // 算术
        t1 = e_GetValue(0, e1, e5);
        switch (e2)
        {
        case 0: x50[e3] = x50[e4] + t1; break;
        case 1: x50[e3] = x50[e4] - t1; break;
        case 2: x50[e3] = x50[e4] * t1; break;
        case 3: if (t1 != 0) x50[e3] = x50[e4] / t1; break;
        case 4: if (t1 != 0) x50[e3] = x50[e4] % t1; break;
        case 5: if (t1 != 0) x50[e3] = (uint16_t)x50[e4] / t1; break;
        }
        break;
    case 4: // 比较
        x50[0x7000] = 0;
        t1 = e_GetValue(0, e1, e4);
        switch (e2)
        {
        case 0: if (!(x50[e3] < t1)) x50[0x7000] = 1; break;
        case 1: if (!(x50[e3] <= t1)) x50[0x7000] = 1; break;
        case 2: if (!(x50[e3] == t1)) x50[0x7000] = 1; break;
        case 3: if (!(x50[e3] != t1)) x50[0x7000] = 1; break;
        case 4: if (!(x50[e3] >= t1)) x50[0x7000] = 1; break;
        case 5: if (!(x50[e3] > t1)) x50[0x7000] = 1; break;
        case 6: x50[0x7000] = 0; break;
        case 7: x50[0x7000] = 1; break;
        }
        break;
    case 5: // 清零
        memset(x50, 0, sizeof(x50));
        break;
    case 8: // 读对话到字符串
    {
        t1 = e_GetValue(0, e1, e2);
        if (t1 > 0 && t1 <= (int)TDEF.size())
        {
            const std::string& s = TDEF[t1 - 1];
            memcpy(&x50[e3], s.c_str(), s.size());
            ((char*)&x50[e3])[s.size()] = 0;
        }
        break;
    }
    case 9: // 格式化字符串
    {
        e4 = e_GetValue(0, e1, e4);
        pw = (char*)&x50[e2];
        pw1 = (char*)&x50[e3];
        char buf[256];
        snprintf(buf, sizeof(buf), pw1, e4);
        strcpy(pw, buf);
        break;
    }
    case 10: // 字符串长度
        x50[e2] = DrawLength((char*)&x50[e1]);
        break;
    case 11: // 连接字符串
    {
        pw = (char*)&x50[e1];
        pw1 = (char*)&x50[e2];
        int len1 = (int)strlen(pw);
        char* pw2 = (char*)&x50[e3];
        strcpy(pw + len1, pw1);
        strcat(pw, pw2);
        break;
    }
    case 12: // 空格字符串
    {
        e3 = e_GetValue(0, e1, e3);
        pw = (char*)&x50[e2];
        for (int j = 0; j < e3; j++)
            pw[j] = ' ';
        pw[e3] = 0;
        break;
    }
    case 16: // 写R数据
    {
        e3 = e_GetValue(0, e1, e3);
        e4 = e_GetValue(1, e1, e4);
        e5 = e_GetValue(2, e1, e5);
        switch (e2)
        {
        case 0: Rrole[e3].Data[e4 / 2] = e5; break;
        case 1: Ritem[e3].Data[e4 / 2] = e5; break;
        case 2:
            Rscene[e3].Data[e4 / 2] = e5;
            if (e4 >= 20 && e4 < 28) ReSetEntrance();
            break;
        case 3: Rmagic[e3].Data[e4 / 2] = e5; break;
        case 4: RShop[e3].Data[e4 / 2] = e5; break;
        }
        break;
    }
    case 17: // 读R数据
    {
        e3 = e_GetValue(0, e1, e3);
        e4 = e_GetValue(1, e1, e4);
        switch (e2)
        {
        case 0: x50[e5] = Rrole[e3].Data[e4 / 2]; break;
        case 1: x50[e5] = Ritem[e3].Data[e4 / 2]; break;
        case 2: x50[e5] = Rscene[e3].Data[e4 / 2]; break;
        case 3: x50[e5] = Rmagic[e3].Data[e4 / 2]; break;
        case 4: x50[e5] = RShop[e3].Data[e4 / 2]; break;
        }
        break;
    }
    case 18: // 写队伍数据
        e2 = e_GetValue(0, e1, e2);
        e3 = e_GetValue(1, e1, e3);
        TeamList[e2] = e3;
        break;
    case 19: // 读队伍数据
        e2 = e_GetValue(0, e1, e2);
        x50[e3] = TeamList[e2];
        break;
    case 20: // 获取物品数量
    {
        e2 = e_GetValue(0, e1, e2);
        x50[e3] = 0;
        for (int j = 0; j < MAX_ITEM_AMOUNT; j++)
        {
            if (RItemList[j].Number == e2)
            {
                x50[e3] = RItemList[j].Amount;
                break;
            }
        }
        break;
    }
    case 21: // 写场景事件
        e2 = e_GetValue(0, e1, e2);
        e3 = e_GetValue(1, e1, e3);
        e4 = e_GetValue(2, e1, e4);
        e5 = e_GetValue(3, e1, e5);
        DData[e2][e3][e4] = e5;
        if (e2 == CurScene) NeedRefreshScene = 1;
        break;
    case 22: // 读场景事件
        e2 = e_GetValue(0, e1, e2);
        e3 = e_GetValue(1, e1, e3);
        e4 = e_GetValue(2, e1, e4);
        x50[e5] = DData[e2][e3][e4];
        break;
    case 23: // 写场景S数据
        e2 = e_GetValue(0, e1, e2);
        e3 = e_GetValue(1, e1, e3);
        e4 = e_GetValue(2, e1, e4);
        e5 = e_GetValue(3, e1, e5);
        e6 = e_GetValue(4, e1, e6);
        SData[e2][e3][e5][e4] = e6;
        if (e2 == CurScene) NeedRefreshScene = 1;
        break;
    case 24: // 读场景S数据
        e2 = e_GetValue(0, e1, e2);
        e3 = e_GetValue(1, e1, e3);
        e4 = e_GetValue(2, e1, e4);
        e5 = e_GetValue(3, e1, e5);
        x50[e6] = SData[e2][e3][e5][e4];
        break;
    case 25: // 特殊地址
    {
        e5 = e_GetValue(0, e1, e5);
        e6 = e_GetValue(1, e1, e6);
        uint32_t t1u = (uint16_t)e3 + (uint16_t)e4 * 0x10000 + (uint16_t)e6;
        uint32_t iu = (uint16_t)e3 + (uint16_t)e4 * 0x10000;
        switch (t1u)
        {
        case 0x1D295A: Sx = e5; break;
        case 0x1D295C: Sy = e5; break;
        }
        switch (iu)
        {
        case 0x18FE2C:
            if (e6 % 4 <= 1)
                RItemList[e6 / 4].Number = e5;
            else
                RItemList[e6 / 4].Amount = e5;
            break;
        case 0x051C83:
            ACol[e6] = e5 % 256;
            ACol[e6 + 1] = e5 / 256;
            ACol1[e6] = ACol[e6];
            ACol1[e6 + 1] = ACol[e6 + 1];
            ACol2[e6] = ACol[e6];
            ACol2[e6 + 1] = ACol[e6 + 1];
            break;
        case 0x01D295E:
            CurScene = e5;
            InitialScene();
            break;
        }
        UpdateAllScreen();
        break;
    }
    case 26: // 特殊地址
    {
        e6 = e_GetValue(0, e1, e6);
        uint32_t t1u = (uint16_t)e3 + (uint16_t)e4 * 0x10000 + (uint32_t)e6;
        uint32_t iu = (uint16_t)e3 + (uint16_t)e4 * 0x10000;
        switch (t1u)
        {
        case 0x1D295E: x50[e5] = CurScene; break;
        case 0x1D295A: x50[e5] = Sx; break;
        case 0x1D295C: x50[e5] = Sy; break;
        case 0x1C0B88: x50[e5] = Mx; break;
        case 0x1C0B8C: x50[e5] = My; break;
        case 0x05B53A: x50[e5] = 1; break;
        case 0x0544F2: x50[e5] = SFace; break;
        case 0x1E6ED6: x50[e5] = x50[28100]; break;
        case 0x556DA: x50[e5] = Ax; break;
        case 0x556DC: x50[e5] = Ay; break;
        case 0x1C0B90: x50[e5] = SDL_GetTicks() / 55 % 65536; break;
        }
        if (t1u >= 0x18FE2C && t1u < 0x18FE2C + 800)
        {
            int idx2 = t1u - 0x18FE2C;
            if (idx2 % 4 <= 1)
                x50[e5] = RItemList[idx2 / 4].Number;
            else
                x50[e5] = RItemList[idx2 / 4].Amount;
        }
        if (t1u >= 0x1E4A04 && t1u < 0x1E6A04)
        {
            int idx2 = (t1u - 0x1E4A04) / 2;
            x50[e5] = BField[2][idx2 % 64][idx2 / 64];
        }
        break;
    }
    case 27: // 读名字到字符串
    {
        e3 = e_GetValue(0, e1, e3);
        pw = (char*)&x50[e4];
        switch (e2)
        {
        case 0: pw1 = Rrole[e3].Name; break;
        case 1: pw1 = Ritem[e3].Name; break;
        case 2: pw1 = Rscene[e3].Name; break;
        case 3: pw1 = Rmagic[e3].Name; break;
        default: pw1 = (char*)""; break;
        }
        strcpy(pw, pw1);
        break;
    }
    case 28: // 获取战斗编号
        x50[e1] = x50[28005];
        break;
    case 29: // 选择目标
    {
        e2 = e_GetValue(0, e1, e2);
        e3 = e_GetValue(1, e1, e3);
        if (e5 == 0)
            SelectAim(e2, e3);
        x50[e4] = BField[2][Ax][Ay];
        break;
    }
    case 30: // 读战斗属性
        e2 = e_GetValue(0, e1, e2);
        e3 = e_GetValue(1, e1, e3);
        x50[e4] = Brole[e2].Data[e3 / 2];
        break;
    case 31: // 写战斗属性
        e2 = e_GetValue(0, e1, e2);
        e3 = e_GetValue(1, e1, e3);
        e4 = e_GetValue(2, e1, e4);
        Brole[e2].Data[e3 / 2] = e4;
        break;
    case 32: // 修改下一条指令
    {
        e3 = e_GetValue(0, e1, e3);
        result = 655360 * (e3 + 1) + x50[e2];
        if (KDEF_SCRIPT > 0)
        {
            p5032pos = e3;
            p5032value = x50[e2];
        }
        break;
    }
    case 33: // 绘制字符串
    {
        e3 = e_GetValue(0, e1, e3);
        e4 = e_GetValue(1, e1, e4);
        e5 = e_GetValue(2, e1, e5);
        pw = (char*)&x50[e2];
        pw1 = pw;
        i = 0;
        while ((uint8_t)*pw > 0)
        {
            if ((uint8_t)*pw == 0x2A)
            {
                *pw = 0;
                DrawShadowText(pw1, e3 - 2, e4 + 22 * i - 25, 0, 0x202020);
                i++;
                pw1 = pw + 1;
            }
            pw++;
        }
        DrawShadowText(pw1, e3 - 2, e4 + 22 - 25, 0, 0x202020);
        UpdateAllScreen();
        break;
    }
    case 34: // 绘制背景矩形
        e2 = e_GetValue(0, e1, e2);
        e3 = e_GetValue(1, e1, e3);
        e4 = e_GetValue(2, e1, e4);
        e5 = e_GetValue(3, e1, e5);
        e6 = e_GetValue(4, e1, e6);
        DrawRectangle(e2, e3, e4, e5, 0, ColColor(0xFF), std::max(e6, 40));
        break;
    case 35: // 等待按键
    {
        i = WaitAnyKey();
        x50[e1] = i;
        switch (i)
        {
        case SDLK_LEFT: x50[e1] = 154; break;
        case SDLK_RIGHT: x50[e1] = 156; break;
        case SDLK_UP: x50[e1] = 158; break;
        case SDLK_DOWN: x50[e1] = 152; break;
        }
        if (i >= 256 && i < 266)
            x50[e1] = i - 208;
        break;
    }
    case 36: // 绘制字符串带背景，按Y跳转
    {
        e3 = e_GetValue(0, e1, e3);
        e4 = e_GetValue(1, e1, e4);
        e5 = e_GetValue(2, e1, e5);
        pw = (char*)&x50[e2];
        pw1 = pw;
        i1 = 1; i2 = 0; t1 = 0;
        while ((uint8_t)*pw > 0)
        {
            if ((uint8_t)*pw == 0x2A) { if (t1 > i2) i2 = t1; t1 = 0; i1++; }
            if ((uint8_t)*pw == 0x20) t1++;
            pw++; t1++;
        }
        if (t1 > i2) i2 = t1;
        if (i1 == 0) i1 = 1;
        DrawTextFrame(e3 - 15, e4, i2 * 2 / 3);
        pw = (char*)&x50[e2];
        pw1 = pw;
        i = 0;
        while ((uint8_t)*pw > 0)
        {
            if ((uint8_t)*pw == 0x2A)
            {
                *pw = 0;
                DrawShadowText(pw1, e3 + 3, e4 + 22 * i + 2, ColColor(e5 & 0xFF), ColColor((e5 & 0xFF00) >> 8));
                i++; pw1 = pw + 1;
            }
            pw++;
        }
        DrawShadowText(pw1, e3 + 3, e4 + 22 * i + 2, ColColor(e5 & 0xFF), ColColor((e5 & 0xFF00) >> 8));
        UpdateAllScreen();
        i = WaitAnyKey();
        x50[0x7000] = (i == SDLK_Y) ? 0 : 1;
        break;
    }
    case 37: // 延时
        e2 = e_GetValue(0, e1, e2);
        SDL_Delay(e2);
        break;
    case 38: // 随机数
        e2 = e_GetValue(0, e1, e2);
        x50[e3] = rand() % e2;
        break;
    case 39: // 菜单选择
    case 40:
    {
        e2 = e_GetValue(0, e1, e2);
        e5 = e_GetValue(1, e1, e5);
        e6 = e_GetValue(2, e1, e6);
        std::vector<std::string> menuStr(e2);
        t1 = 0;
        for (int j = 0; j < e2; j++)
        {
            menuStr[j] = (char*)&x50[x50[e3 + j]];
            i1 = DrawLength((char*)&x50[x50[e3 + j]]);
            if (i1 > t1) t1 = i1;
        }
        int maxShow = (code == 40) ? ((e1 >> 8) & 0xFF) : 10;
        if (maxShow == 0) maxShow = 5;
        x50[e4] = CommonScrollMenu(e5, e6, t1 * 10 + 7, e2 - 1, maxShow, menuStr) + 1;
        break;
    }
    case 41: // 绘制图片
    {
        e3 = e_GetValue(0, e1, e3);
        e4 = e_GetValue(1, e1, e4);
        e5 = e_GetValue(2, e1, e5);
        switch (e2)
        {
        case 0:
            if (Where == 1) DrawSPic(e5 / 2, e3, e4);
            else DrawMPic(e5 / 2, e3, e4);
            break;
        case 1: DrawHeadPic(e5, e3, e4); break;
        }
        UpdateAllScreen();
        break;
    }
    case 42: // 改变大地图位置
        e2 = e_GetValue(0, e1, e2);
        e3 = e_GetValue(0, e1, e3);
        Mx = e3; My = e2;
        break;
    case 43: // 调用事件
    {
        e2 = e_GetValue(0, e1, e2);
        e3 = e_GetValue(1, e1, e3);
        e4 = e_GetValue(2, e1, e4);
        e5 = e_GetValue(3, e1, e5);
        e6 = e_GetValue(4, e1, e6);
        x50[0x7100] = e3;
        x50[0x7101] = e4;
        x50[0x7102] = e5;
        x50[0x7103] = e6;
        kyslog("Call another event or special process, the code is %d-%d %d %d %d", e2, e3, e4, e5, e6);
        switch (e2)
        {
        case 201: NewTalk(e3, e4, e5, e6 % 100, (e6 % 100) / 10, e6 / 100, 0); break;
        case 202: ScreenBlendMode = 0; break;
        case 203: ScreenBlendMode = 1; break;
        case 204: ScreenBlendMode = 2; break;
        case 205: x50[126] = Digging(e3, e4, e5, e6); break;
        case 207: ShowStarList(); break;
        case 208: x50[28929] = GetStarState(e3); break;
        case 209: SetStarState(e3, e4); break;
        case 210: NewTeammateList(); break;
        case 213:
            if (e6 == 1) e4 = -e4;
            if (e5 == 0) instruct_2(e3, e4);
            else instruct_32(e3, e4);
            break;
        case 214: x50[10032] = EnterNumber(-32768, 32767, CENTER_X - 90, CENTER_Y - 90); break;
        case 217:
            x50[0x7000] = 1;
            if (SpellPicture(e3, e4)) x50[0x7000] = 0;
            break;
        case 219: ReArrangeItem(1); break;
        case 223: ShowMap(); break;
        case 228: ShowTeamMate(e3, e4, e5); break;
        case 236:
            x50[0x7000] = 1;
            if (Lamp(e3, e4, e5, 0)) x50[0x7000] = 0;
            break;
        case 242: RoleEnding(e3, e4, e5); break;
        case 243: MissionList(e3); break;
        case 244: SetMissionState(e3, e4); break;
        case 246:
            x50[0x7000] = 1;
            if (WoodMan(e3)) x50[0x7000] = 0;
            break;
        case 247:
            ShowMR = true;
            if (e3 == 1) ShowMR = false;
            break;
        case 253: BookList(); break;
        case 254: x50[e3] = GetStarAmount(); break;
        case 255: x50[e3] = DancerAfter90S(); break;
        case 352: ShowTitle(e3, 1); break;
        case 365: NewShop(e3); break;
        case 369: x50[15205] = EnterNumber(0, e3, e5, e6); break;
        default: CallEvent(e2); break;
        }
        break;
    }
    case 44: // 播放动作动画
    {
        e2 = e_GetValue(0, e1, e2);
        if (e2 > 100) e2 = e_GetValue(0, 1, e2);
        e3 = e_GetValue(1, e1, e3);
        e4 = e_GetValue(2, e1, e4);
        PlayActionAmination(e2, e3);
        PlayMagicAmination(e2, e4);
        break;
    }
    case 45: // 显示伤害值
    {
        e2 = e_GetValue(0, e1, e2);
        switch (e2)
        {
        case 1: e2 = 0; break;
        case 2: e2 = 2; break;
        case 3: e2 = 4; break;
        case 4: e2 = 3; break;
        case 5: e2 = 1; break;
        }
        ShowHurtValue(e2);
        break;
    }
    case 46: // 设置效果
    {
        e2 = e_GetValue(0, e1, e2);
        e3 = e_GetValue(1, e1, e3);
        e4 = e_GetValue(2, e1, e4);
        e5 = e_GetValue(3, e1, e5);
        e6 = e_GetValue(4, e1, e6);
        for (i1 = e2; i1 < e2 + e4; i1++)
            for (i2 = e3; i2 < e3 + e5; i2++)
                BField[4][i2][i1] = e6;
        break;
    }
    case 47: // 刷新
        Redraw();
        break;
    case 48: // 调试输出参数
        break;
    case 49: // PE不可用
        break;
    case 50: // 输入名字 (简化)
        break;
    case 51: // 输入数字 (简化)
        x50[e1] = 0;
        break;
    case 52: // 判断是否有某武功
    {
        e2 = e_GetValue(0, e1, e2);
        e3 = e_GetValue(1, e1, e3);
        e4 = e_GetValue(2, e1, e4);
        x50[0x7000] = 1;
        if (HaveMagic(e2, e3, e4))
            x50[0x7000] = 0;
        break;
    }
    case 53: // 增加属性
    {
        e2 = e_GetValue(0, e1, e2);
        e3 = e_GetValue(1, e1, e3);
        e4 = e_GetValue(2, e1, e4);
        if (e3 >= 43 && e3 <= 58)
            Rrole[e2].Data[e3] = RegionParameter(Rrole[e2].Data[e3] + e4, 0, MaxProList[e3]);
        if (e3 == 18)
        {
            Rrole[e2].MaxHP = std::min(Rrole[e2].MaxHP + e4, MAX_HP);
            Rrole[e2].CurrentHP = std::min(Rrole[e2].CurrentHP + e4, Rrole[e2].MaxHP);
        }
        if (e3 == 42)
        {
            Rrole[e2].MaxMP = std::min(Rrole[e2].MaxMP + e4, MAX_MP);
            Rrole[e2].CurrentMP = std::min(Rrole[e2].CurrentMP + e4, Rrole[e2].MaxMP);
        }
        break;
    }
    case 54: // 设置行走贴图
        BEGIN_WALKPIC = e_GetValue(0, e1, e2);
        BEGIN_WALKPIC2 = e_GetValue(0, e1, e3);
        break;
    case 55: // 播放视频
    {
        DrawRectangleWithoutFrame(0, 0, CENTER_X * 2, CENTER_Y * 2, 0, 0);
        char vname[64];
        snprintf(vname, sizeof(vname), "%d.wmv", e_GetValue(0, e1, e2));
        if (PlayMovie(vname))
        {
            CleanKeyValue();
            WaitAnyKey();
        }
        Redraw();
        break;
    }
    case 60: // 调用脚本
    {
        e2 = e_GetValue(0, e1, e2);
        e3 = e_GetValue(1, e1, e3);
        char scriptpath[256], funcname[32];
        snprintf(scriptpath, sizeof(scriptpath), "%sscript/%d.lua", AppPath.c_str(), e2);
        snprintf(funcname, sizeof(funcname), "f%d", e3);
        ExecScript(scriptpath, funcname);
        break;
    }
    } // end switch

    return result;
}

// ---- 角色与武器----

bool HaveMagic(int person, int mnum, int lv)
{
    for (int i = 0; i < 10; i++)
    {
        if (Rrole[person].Magic[i] == mnum && Rrole[person].MagLevel[i] >= lv)
            return true;
    }
    for (int i = 0; i < 4; i++)
    {
        if (Rrole[person].NeiGong[i] == mnum && Rrole[person].NGLevel[i] >= lv)
            return true;
    }
    return false;
}

int HaveMagicAmount(int rnum, int NeiGong)
{
    int result = 0;
    if (NeiGong == 0)
    {
        for (int i = 0; i < 10; i++)
            if (Rrole[rnum].Magic[i] > 0) result++;
    }
    else
    {
        for (int i = 0; i < 4; i++)
            if (Rrole[rnum].NeiGong[i] > 0) result++;
    }
    return result;
}

int GetMagicLevel(int person, int mnum)
{
    if (mnum <= 0) return 0;
    if (Rmagic[mnum].HurtType == 3)
    {
        for (int i = 0; i < 4; i++)
        {
            if (Rrole[person].NeiGong[i] == mnum)
                return Rrole[person].NGLevel[i] / 100 + 1;
        }
    }
    else
    {
        for (int i = 0; i < 10; i++)
        {
            if (Rrole[person].Magic[i] == mnum)
                return Rrole[person].MagLevel[i] / 100 + 1;
        }
    }
    return 0;
}

void StudyMagic(int rnum, int magicnum, int newmagicnum, int level, int dismode)
{
    for (int i = 0; i < 10; i++)
    {
        if (Rrole[rnum].Magic[i] == magicnum || Rrole[rnum].Magic[i] == newmagicnum)
        {
            if (level != -2)
                Rrole[rnum].MagLevel[i] += level * 100;
            Rrole[rnum].Magic[i] = newmagicnum;
            if (Rrole[rnum].MagLevel[i] > 999)
                Rrole[rnum].MagLevel[i] = 999;
            break;
        }
    }
    if (dismode == 0)
    {
        DrawRectangle(CENTER_X - 75, 98, 145, 76, 0, ColColor(255), 30);
        std::string word = "學會"; // 學會
        DrawShadowText(word.c_str(), CENTER_X - 90, 125, ColColor(5), ColColor(7));
        DrawShadowText(Rrole[rnum].Name, CENTER_X - 90, 100, ColColor(0x21), ColColor(0x23));
        DrawShadowText(Rmagic[newmagicnum].Name, CENTER_X - 90, 150, ColColor(0x64), ColColor(0x66));
        UpdateAllScreen();
        WaitAnyKey();
        Redraw();
    }
}

// ---- 字符串处理----

void DivideName(const std::string& fullname, std::string& surname, std::string& givenname)
{
    int len = DrawLength(fullname.c_str());
    if (len <= 2)
    {
        surname = "";
        givenname = fullname;
    }
    else if (len <= 4)
    {
        // 单姓
        surname = fullname.substr(0, 3); // UTF-8 one CJK char = 3 bytes
        givenname = fullname.substr(3);
    }
    else
    {
        // 尝试复姓
        surname = fullname.substr(0, 6);
        // 简化处理：默认单姓
        surname = fullname.substr(0, 3);
        givenname = fullname.substr(3);
    }
}

std::string ReplaceStr(const std::string& S, const std::string& Srch, const std::string& Replace)
{
    std::string result;
    std::string source = S;
    size_t pos;
    while ((pos = source.find(Srch)) != std::string::npos)
    {
        result += source.substr(0, pos) + Replace;
        source = source.substr(pos + Srch.size());
    }
    result += source;
    return result;
}

// ---- 对话系统 ----

void ReadTalk(int talknum, std::vector<uint8_t>& talk, int needxor)
{
    if (talknum > 0 && talknum <= (int)TDEF.size())
    {
        const std::string& s = TDEF[talknum - 1];
        talk.resize(s.size() + 1);
        memcpy(talk.data(), s.c_str(), s.size());
        talk[s.size()] = 0;
    }
    else
    {
        talk.resize(1);
        talk[0] = 0;
    }
}

void NewTalk(int headnum, int talknum, int namenum, int place, int showhead, int color, int frame,
    const std::string& content, const std::string& disname)
{
    const int RowSpacing = 25;
    const int ColSpacing = 20;
    const int MaxRow = 5;
    int MaxCol = 25;
    MaxCol = (int)((CENTER_X * 2 - (768 - MaxCol * ColSpacing)) / ColSpacing);

    int Frame_X = 50;
    int Frame_Y = CENTER_Y * 2 - 180;
    int Talk_X = Frame_X + 170;
    int Talk_Y = Frame_Y + 35;
    int Talk_W = MaxCol;
    int Talk_H = MaxRow;
    int Name_X = Talk_X;
    int Name_Y = Frame_Y + 7;
    int Head_X = 30, Head_Y = CENTER_Y * 2 - 200;

    if (place > 2) place = 5 - place;
    if (place == 0) { Head_X = 30; Head_Y = CENTER_Y * 2 - 200; }
    else if (place == 1) { Head_X = CENTER_X * 2 - 200; Head_Y = CENTER_Y * 2 - 200; Talk_X = Frame_X; Name_X = Talk_X; }
    else if (place == 2) { Talk_X = Frame_X + 70; }

    // 颜色映射
    switch (color)
    {
    case 0: color = 28515; break;
    case 1: color = 28421; break;
    case 2: color = 28435; break;
    case 3: color = 28563; break;
    case 4: color = 28466; break;
    case 5: color = 28450; break;
    }
    uint8_t ForeGroundCol = color & 0xFF;
    uint8_t BackGroundCol = (color & 0xFF00) >> 8;

    // 读取对话
    std::string TalkStr;
    if (content.empty())
    {
        if (talknum >= 0)
        {
            std::vector<uint8_t> talk;
            ReadTalk(talknum, talk);
            if (talk.size() > 1)
                TalkStr = (char*)talk.data();
        }
        else
        {
            int idx = -talknum;
            if (idx >= 0 && idx < 0x10000)
                TalkStr = (char*)&x50[idx];
        }
    }
    else
        TalkStr = content;
    TalkStr = " " + TalkStr;

    // 读取名字
    std::string NameStr;
    if (disname.empty())
    {
        if (namenum == -2)
        {
            int HeadNumR = headnum;
            if (headnum >= 412 && headnum <= 429) HeadNumR = 0;
            for (int i = 0; i < 1002; i++)
            {
                if ((Rrole[i].HeadNum == HeadNumR) || (i == 0 && HeadNumR == 0))
                {
                    NameStr = Rrole[i].Name;
                    break;
                }
            }
        }
        else if (namenum > 0)
        {
            std::vector<uint8_t> name;
            ReadTalk(namenum, name);
            if (name.size() > 1)
                NameStr = (char*)name.data();
        }
        else if (namenum == 0)
        {
            NameStr = Rrole[0].Name;
        }
    }
    else
        NameStr = disname;

    // 替换对话中的姓名
    std::string fullname = Rrole[0].Name;
    TalkStr = ReplaceStr(TalkStr, "&&", fullname);

    // 显示对话
    Redraw();
    RecordFreshScreen();

    uint32_t DrawForeCol = ColColor(ForeGroundCol);
    uint32_t DrawBackCol = ColColor(BackGroundCol);
    int len = (int)TalkStr.size();
    int I = 0;
    CleanKeyValue();
    bool skipSync = false;

    while (true)
    {
        LoadFreshScreen();
        DrawRectangleWithoutFrame(0, Frame_Y, CENTER_X * 2, 170, 0, 40);
        if (showhead == 0 && headnum >= 0)
            DrawHeadPic(headnum, Head_X, Head_Y);
        if (!NameStr.empty() || showhead != 0)
            DrawShadowText(NameStr.c_str(), Name_X, Name_Y, ColColor(5), ColColor(7));
        UpdateAllScreen();

        int ix = 0, iy = 0;
        skipSync = false;
        SDL_Event ev;
        while (SDL_PollEvent(&ev) || true)
        {
            CheckBasicEvent();
            if ((ev.type == SDL_EVENT_KEY_UP && ev.key.key == SDLK_ESCAPE) ||
                (ev.type == SDL_EVENT_MOUSE_BUTTON_UP && ev.button.button == SDL_BUTTON_RIGHT))
            {
                skipSync = true;
                SkipTalk = 1;
                break;
            }
            if ((ev.type == SDL_EVENT_KEY_UP && (ev.key.key == SDLK_RETURN || ev.key.key == SDLK_SPACE)) ||
                (ev.type == SDL_EVENT_MOUSE_BUTTON_UP && ev.button.button == SDL_BUTTON_LEFT))
            {
                skipSync = true;
                SkipTalk = 0;
            }
            if (!(ix < Talk_W && iy < Talk_H && I < len))
                break;

            // 检查换行
            if (I + 1 < len && TalkStr[I] == '*' && TalkStr[I + 1] == '*')
            {
                iy++;
                ix = 0;
                I += 2;
                if (iy >= Talk_H) { if (I < len) WaitAnyKey(); break; }
                continue;
            }

            // 写字符
            if (I < len)
            {
                int charlen = 1;
                uint8_t ch = (uint8_t)TalkStr[I];
                if (ch >= 0xE0) charlen = 3;
                else if (ch >= 0xC0) charlen = 2;
                std::string tempstr = TalkStr.substr(I, charlen);
                int xtemp = Talk_X + ColSpacing * ix;
                if (ch < 0x80) xtemp += 5;
                DrawShadowText(tempstr.c_str(), xtemp, Talk_Y + RowSpacing * iy, DrawForeCol, DrawBackCol);
                I += charlen;
            }
            if (!skipSync && SkipTalk == 0)
            {
                SDL_Delay(5);
                UpdateAllScreen();
            }
            ix++;
            if (ix >= Talk_W || iy >= Talk_H)
            {
                ix = 0;
                iy++;
                if (iy >= Talk_H)
                {
                    if (I <= len)
                    {
                        UpdateAllScreen();
                        if (SkipTalk == 0)
                        {
                            WaitAnyKey();
                            if (skipSync) WaitAnyKey();
                            skipSync = false;
                        }
                    }
                    break;
                }
            }
        }
        if (I >= len) break;
    }
    FreeFreshScreen();
    UpdateAllScreen();
    if (SkipTalk == 0)
    {
        WaitAnyKey();
        if (skipSync) WaitAnyKey();
    }
}

void ShowTitle(int talknum, int color)
{
    NewTalk(0, talknum, -1, 2, 1, color, 0);
}

// ---- 星将系统 ----

int GetStarState(int position)
{
    int n = 119;
    if (position > 82)
    {
        n = 120;
        position -= 83;
    }
    position += 30;
    if (position % 2 == 0)
        return Rrole[n].Data[position / 2] & 0xFF;
    else
        return Rrole[n].Data[position / 2] >> 8;
}

void SetStarState(int position, int state)
{
    int n = 119;
    if (position > 82)
    {
        n = 120;
        position -= 83;
    }
    position += 30;
    if (position % 2 == 0)
        Rrole[n].Data[position / 2] = (Rrole[n].Data[position / 2] & 0xFF00) | state;
    else
        Rrole[n].Data[position / 2] = (Rrole[n].Data[position / 2] & 0xFF) | (state << 8);
}

static const int StarToRoleMap[108] = {
    0, 1, 2, 8, 4, 7, 6, 21, 34, 11, 3, 14, 12, 13, 23, 31,
    16, 17, 18, 5, 20, 22, 26, 27, 24, 25, 19, 30, 28, 29, 15, 32,
    10, 33, 9, 35, 36, 38, 46, 39, 40, 41, 48, 43, 49, 45, 89, 47,
    37, 50, 51, 74, 52, 92, 93, 77, 44, 57, 58, 59, 69, 64, 65, 66,
    85, 55, 54, 72, 73, 88, 102, 71, 96, 76, 68, 78, 79, 42, 81, 82,
    83, 84, 53, 80, 56, 95, 70, 90, 97, 104, 105, 91, 67, 75, 369, 60,
    99, 100, 101, 98, 103, 87, 86, 107, 106, 108, 114, 115
};

int StarToRole(int Starnum)
{
    if (Starnum < 0 || Starnum > 107) return 0;
    return StarToRoleMap[Starnum];
}

// 队友列表 (简化版)
void TeammateList()
{
    // 队伍满则退出
    bool full = true;
    for (int i = 0; i < 6; i++)
        if (TeamList[i] < 0) { full = false; break; }
    if (full) return;

    while (true)
    {
        int n = 0;
        std::vector<std::string> menuStr;
        std::vector<int> mateList;
        full = true;
        for (int i = 0; i < 6; i++)
            if (TeamList[i] < 0) { full = false; break; }
        if (full) break;

        for (int i = 0; i < 108; i++)
        {
            if (GetStarState(i) == 1)
            {
                std::string temp = std::string(Star[i]) + " " + RoleName[i];
                menuStr.push_back(temp);
                mateList.push_back(i);
                n++;
            }
        }
        Redraw();
        if (n > 0)
        {
            int menu;
            if (n > 20)
                menu = CommonScrollMenu(220, 15, 200, n - 1, 20, menuStr);
            else
                menu = CommonScrollMenu(220, 15, 200, n - 1, n, menuStr);
            if (menu == -1) break;
            x50[0x7100] = mateList[menu];
            CallEvent(230);
            Redraw();
            UpdateAllScreen();
        }
        else
            break;
    }
}

void NewTeammateList()
{
    // 简化版 - 基本交互框架
    TeammateList(); // 复用基本逻辑
}

void ShowTeamMate(int position, int headnum, int Count)
{
    if (Count == 0) Count = 1;
    int hx = CENTER_X - 85;
    int hy = 55;
    DrawRectangleWithoutFrame(0, 40, CENTER_X * 2, 230, 0, 40);
    for (int i = 1; i <= Count; i++)
        DrawHeadPic(headnum, hx, hy + 8);

    std::string str = std::string(Star[position]) + " " + RoleName[position] + " 成為夥伴"; // 成為夥伴
    int l = DrawLength(str.c_str());
    DrawShadowText(str.c_str(), CENTER_X - 10 * (l / 2) - 10, 230, ColColor(0x5), ColColor(0x8));
    UpdateAllScreen();
    WaitAnyKey();
    Redraw();
}

void ShowStarList()
{
    // 简化版：显示星将列表
    std::vector<std::string> menuStr(108);
    for (int i = 0; i < 108; i++)
    {
        menuStr[i] = Star[i];
        int st = GetStarState(i);
        if (st != 0)
            menuStr[i] += "  " + std::string(RoleName[i]);
    }
    int x = CENTER_X - 384 + 84;
    int y = CENTER_Y - 240 + 15;
    Redraw();
    TransBlackScreen();
    int menu = CommonScrollMenu(x, y, 200, 107, 15, menuStr);
    (void)menu;
    Redraw();
    UpdateAllScreen();
}

// ---- 任务系统 ----

int GetMissionState(int position)
{
    int n = 650 + position / 162;
    int p = position / 2 + 18;
    if (position % 2 == 0)
        return Rrole[n].Data[p] & 0xFF;
    else
        return (Rrole[n].Data[p] >> 8) & 0xFF;
}

void SetMissionState(int position, int state)
{
    int n = 650 + position / 162;
    int p = position / 2 + 18;
    if (position % 2 == 0)
        Rrole[n].Data[p] = (Rrole[n].Data[p] & 0xFF00) | state;
    else
        Rrole[n].Data[p] = (Rrole[n].Data[p] & 0xFF) | (state << 8);
}

void MissionList(int mode)
{
    int n = 0;
    std::vector<std::string> menuStr(MISSION_AMOUNT);
    const char* missiontip[3] = {
        "未開啟", // 未開啟
        "未完成", // 未完成
        "已完成"  // 已完成
    };
    for (int i = 0; i < MISSION_AMOUNT; i++)
    {
        int tip = GetMissionState(i);
        if (tip >= 1 && tip <= 2)
        {
            if (mode == 0 || tip == mode)
            {
                menuStr[n] = std::string(" ") + missiontip[tip] + " " + MissionStr[i] + "  ";
                n++;
            }
        }
    }
    Redraw();
    UpdateAllScreen();
    if (n > 0)
    {
        CommonScrollMenu(150, 30, 500, n - 1, 15, menuStr);
        Redraw();
        UpdateAllScreen();
    }
    else
    {
        std::vector<std::string> ms = {"沒有符合的任務"}; // 沒有符合的任務
        CommonScrollMenu(150, 30, 500, 0, 15, ms);
    }
}

// ---- 小游戏（简化版）---

int Digging(int beginPic, int goal, int shovel, int restrict_val)
{
    int position = 0;
    int x = 80, y = 90;
    int blankpic = beginPic + 2;
    int holepic = blankpic + 2;
    int goldpic = holepic + 2;
    int moneypic = goldpic + 2;
    int boompic = moneypic + 2;
    int result = 0;
    int Surface[81], outcome[81];
    for (int i = 0; i < 81; i++) { Surface[i] = blankpic; outcome[i] = holepic; }
    // 放置10个金子
    int cnt = 0;
    while (cnt < 10) { int n = rand() % 81; if (outcome[n] == holepic) { outcome[n] = goldpic; cnt++; } }
    cnt = 0;
    while (cnt < 10) { int n = rand() % 81; if (outcome[n] == holepic) { outcome[n] = boompic; cnt++; } }
    cnt = 0;
    while (cnt < 10) { int n = rand() % 81; if (outcome[n] == holepic) { outcome[n] = moneypic; cnt++; } }

    DrawRectangle(x, y, 200, 200, 0, ColColor(0xFF), 40);
    DrawRectangle(x, y - 30, 120, 30, 0, ColColor(0xFF), 40);
    DrawRectangle(x - 32, y - 30, 32, 230, 0, ColColor(0xFF), 40);
    for (int i = 0; i < 81; i++)
    {
        DrawSPic(blankpic / 2, (i % 9) * 20 + 10 + x, (i / 9) * 20 + 10 + y);
        DrawSPic(outcome[i] / 2, (i % 9) * 20 + 10 + x, (i / 9) * 20 + 10 + y);
    }
    UpdateAllScreen();
    SDL_Delay(3000);
    Redraw();

    std::vector<int> surfaceVec(Surface, Surface + 81);
    ShowSurface(x, y, blankpic, surfaceVec);
    DrawSPic(shovel / 2, (position % 9) * 20 + 10 + x, (position / 9) * 20 + 5 + y);
    char goalstr[16]; snprintf(goalstr, sizeof(goalstr), "%d", goal);
    DrawShadowText("\xe7\x9b\xae\xe6\xa8\x99:  X", x - 5, y - 25, ColColor(0x21), ColColor(0x23));
    DrawSPic(goldpic / 2, 55 + x, y - 25);
    DrawShadowText(goalstr, x + 85, y - 25, ColColor(0x21), ColColor(0x23));
    for (int i = 0; i < restrict_val; i++)
        DrawSPic(shovel / 2, x - 27, y - 29 + (10 - i) * 20);
    UpdateAllScreen();

    while (SDL_WaitEvent(&event))
    {
        CheckBasicEvent();
        if (event.type == SDL_EVENT_KEY_UP)
        {
            if (event.key.key == SDLK_RETURN || event.key.key == SDLK_SPACE)
            {
                if (Surface[position] == blankpic)
                {
                    Surface[position] = outcome[position];
                    restrict_val--;
                    if (outcome[position] == boompic) restrict_val--;
                    else if (outcome[position] == goldpic) result++;
                    else if (outcome[position] == moneypic) instruct_2(MONEY_ID, 5);
                }
            }
            else if (event.key.key == SDLK_RIGHT) position++;
            else if (event.key.key == SDLK_LEFT) position--;
            else if (event.key.key == SDLK_UP) position -= 9;
            else if (event.key.key == SDLK_DOWN) position += 9;
            if (position > 80) position -= 81;
            if (position < 0) position += 81;
        }
        if (event.type == SDL_EVENT_MOUSE_BUTTON_UP)
        {
            int x1, y1;
            if (MouseInRegion(x + 10, y + 10, 180, 180, x1, y1))
            {
                int p1 = position;
                position = (x1 - 10 - x) / 20 + ((y1 - 10 - y) / 20) * 9;
                if (position == p1)
                {
                    if (Surface[position] == blankpic)
                    {
                        Surface[position] = outcome[position];
                        restrict_val--;
                        if (outcome[position] == boompic) restrict_val--;
                        else if (outcome[position] == goldpic) result++;
                        else if (outcome[position] == moneypic) instruct_2(MONEY_ID, 5);
                    }
                }
            }
        }
        Redraw();
        surfaceVec.assign(Surface, Surface + 81);
        ShowSurface(x, y, blankpic, surfaceVec);
        DrawSPic(shovel / 2, (position % 9) * 20 + 10 + x, (position / 9) * 20 + 5 + y);
        DrawShadowText("\xe7\x9b\xae\xe6\xa8\x99:  X", x - 5, y - 25, ColColor(0x21), ColColor(0x23));
        DrawSPic(goldpic / 2, 55 + x, y - 25);
        DrawShadowText(goalstr, x + 85, y - 25, ColColor(0x21), ColColor(0x23));
        for (int i = 0; i < restrict_val; i++)
            DrawSPic(shovel / 2, x - 27, y - 29 + (10 - i) * 20);
        UpdateAllScreen();
        if (restrict_val <= 0) { SDL_Delay(2000); WaitAnyKey(); break; }
    }
    return result;
}

void ShowSurface(int x, int y, int blank, const std::vector<int>& surface)
{
    DrawRectangle(x, y, 200, 200, 0, ColColor(0xFF), 40);
    for (int i = 0; i < 81; i++)
    {
        DrawSPic(blank / 2, (i % 9) * 20 + 10 + x, (i / 9) * 20 + 10 + y);
        DrawSPic(surface[i] / 2, (i % 9) * 20 + 10 + x, (i / 9) * 20 + 10 + y);
    }
}

bool Lamp(int c, int beginpic, int whitecount, int chance)
{
    int r = c;
    int x = (CENTER_X * 2 - (c * 50)) / 2;
    int y = (CENTER_Y * 2 - (r * 50)) / 2;
    int pic2 = beginpic + 1;
    int pic3 = beginpic + 2;
    int menu = 0;
    int total = c * r;
    gamearray.resize(1);
    gamearray[0].resize(total);
    for (int i = 0; i < total; i++) gamearray[0][i] = beginpic;
    for (int i = 0; i < whitecount; i++)
    {
        int t = rand() % total;
        while (t == beginpic) t = rand() % total;
        gamearray[0][t] = pic2;
    }

    auto toggleLamp = [&](int pos)
    {
        gamearray[0][pos] = (gamearray[0][pos] == beginpic) ? pic2 : beginpic;
        if (pos % c > 0) gamearray[0][pos - 1] = (gamearray[0][pos - 1] == beginpic) ? pic2 : beginpic;
        if (pos % c < c - 1) gamearray[0][pos + 1] = (gamearray[0][pos + 1] == beginpic) ? pic2 : beginpic;
        if (pos / c > 0) gamearray[0][pos - c] = (gamearray[0][pos - c] == beginpic) ? pic2 : beginpic;
        if (pos / c < r - 1) gamearray[0][pos + c] = (gamearray[0][pos + c] == beginpic) ? pic2 : beginpic;
    };

    auto drawAll = [&]()
    {
        DrawRectangleWithoutFrame(x - 10, y - 10, c * 50 + 20, r * 50 + 20, 0, 60);
        for (int i = 0; i < total; i++)
        {
            DrawSPic(gamearray[0][i], x + (i % c) * 50, y + (i / c) * 50);
            if (menu == i) DrawSPic(pic3, x + (menu % c) * 50, y + (menu / c) * 50);
        }
        UpdateAllScreen();
    };
    drawAll();
    bool result = false;
    while (SDL_WaitEvent(&event))
    {
        CheckBasicEvent();
        int x1, y1;
        if (event.type == SDL_EVENT_MOUSE_MOTION)
        {
            if (MouseInRegion(x, y, 50 * c, 50 * r, x1, y1))
                menu = (x1 - x) / 50 + (y1 - y) / 50 * c;
        }
        if (event.type == SDL_EVENT_MOUSE_BUTTON_UP)
        {
            if (event.button.button == SDL_BUTTON_RIGHT) { result = false; break; }
            if (event.button.button == SDL_BUTTON_LEFT)
            {
                if (MouseInRegion(x, y, 50 * c, 50 * r, x1, y1))
                    menu = (x1 - x) / 50 + (y1 - y) / 50 * c;
                toggleLamp(menu);
            }
        }
        if (event.type == SDL_EVENT_KEY_UP)
        {
            if (event.key.key == SDLK_ESCAPE) { result = false; break; }
            if (event.key.key == SDLK_UP) menu -= c;
            if (event.key.key == SDLK_DOWN) menu += c;
            if (event.key.key == SDLK_LEFT) menu--;
            if (event.key.key == SDLK_RIGHT) menu++;
            if (menu < 0) menu += total;
            if (menu > total - 1) menu -= total;
            if (event.key.key == SDLK_RETURN || event.key.key == SDLK_SPACE)
                toggleLamp(menu);
        }
        drawAll();
        result = true;
        for (int i = 0; i < total; i++) { if (gamearray[0][i] == pic2) { result = false; break; } }
        if (result) { SDL_Delay(1000); break; }
    }
    gamearray.clear();
    return result;
}

bool SpellPicture(int num, int chance)
{
    gamearray.resize(1);
    gamearray[0].resize(25);
    int menu = 0, menu2 = -1;
    int x = 120, y = 20, w = 410, h = 440;
    int right = 0;
    int picnum = 4700 + num;
    if (picnum >= SPicAmount) return false;
    LoadOnePNGTexture("resource/smap", pSPic, SPNGIndex[picnum]);
    void* pic = SPNGIndex[picnum].Pointers[0];
    if (!pic) return false;

    for (int i = 0; i < 25; i++) gamearray[0][i] = -1;
    for (int i = 0; i < 25; i++)
    {
        while (true)
        {
            int r = rand() % 25;
            if (gamearray[0][r] == -1 && i != r) { gamearray[0][r] = i; break; }
        }
    }

    Redraw();
    RecordFreshScreen(x - 5, y - 5, w + 1, h + 1);
    // 先显示正确图 2 秒
    DrawRectangle(x - 5, y - 5, w, h, 0, ColColor(255), 50);
    for (int i = 0; i < 25; i++)
        DrawPartPic(pic, ((24 - i) % 5) * 80, ((24 - i) / 5) * 80, 80, 80, (i % 5) * 80 + x, (i / 5) * 80 + y + 30);
    UpdateAllScreen();
    SDL_Delay(2000);

    bool result = false;
    auto drawPuzzle = [&]()
    {
        LoadFreshScreen(x - 5, y - 5);
        DrawRectangle(x - 5, y - 5, w, h, 0, ColColor(255), 50);
        for (int i = 0; i < 25; i++)
            DrawPartPic(pic, ((24 - gamearray[0][i]) % 5) * 80, ((24 - gamearray[0][i]) / 5) * 80, 80, 80, (i % 5) * 80 + x, (i / 5) * 80 + y + 30);
        if (menu2 > -1)
            DrawRectangle((menu2 % 5) * 80 + x, (menu2 / 5) * 80 + y + 30, 80, 80, 0, ColColor(0x64), 0);
        if (menu > -1)
            DrawRectangle((menu % 5) * 80 + x, (menu / 5) * 80 + y + 30, 80, 80, 0, ColColor(0xFF), 0);
        char word[32], word1[32];
        snprintf(word, sizeof(word), "\xe6\xa9\x9f\xe6\x9c\x83%d", chance);
        snprintf(word1, sizeof(word1), "\xe5\x91\xbd\xe4\xb8\xad%d", right);
        DrawShadowText(word, x + 25, y + 5, ColColor(5), ColColor(7));
        DrawShadowText(word1, x + 220, y + 5, ColColor(5), ColColor(7));
        UpdateAllScreen();
    };
    drawPuzzle();

    while (SDL_WaitEvent(&event))
    {
        CheckBasicEvent();
        int xm, ym;
        if (event.type == SDL_EVENT_KEY_UP)
        {
            int menu1 = menu;
            if (event.key.key == SDLK_ESCAPE)
            {
                if (menu2 > -1) menu2 = -1;
                else { result = false; break; }
            }
            if (event.key.key == SDLK_UP) menu -= 5;
            if (event.key.key == SDLK_DOWN) menu += 5;
            if (event.key.key == SDLK_LEFT) menu--;
            if (event.key.key == SDLK_RIGHT) menu++;
            if (menu > 24) menu -= 25;
            if (menu < 0) menu += 25;
            if (event.key.key == SDLK_RETURN || event.key.key == SDLK_SPACE)
            {
                if (menu2 > -1) { ExchangePic(menu, menu2); menu2 = -1; chance--; }
                else if (menu > -1) menu2 = menu;
            }
        }
        if (event.type == SDL_EVENT_MOUSE_MOTION)
        {
            if (MouseInRegion(x, y, w - 5, h - 5, xm, ym))
            {
                int oldm = menu;
                menu = (xm - x) / 80 + (ym - y - 30) / 80 * 5;
                if (menu > 24) menu = -1;
            }
        }
        if (event.type == SDL_EVENT_MOUSE_BUTTON_UP)
        {
            if (event.button.button == SDL_BUTTON_RIGHT)
            {
                if (menu2 > -1) menu2 = -1;
                else { result = false; break; }
            }
            if (event.button.button == SDL_BUTTON_LEFT)
            {
                if (menu2 > -1) { ExchangePic(menu, menu2); menu2 = -1; chance--; }
                else if (menu > -1) menu2 = menu;
            }
        }
        right = 0;
        for (int i = 0; i < 25; i++) { if (gamearray[0][i] == i) right++; }
        drawPuzzle();
        result = (right == 25);
        if (result) { SDL_Delay(700); break; }
        else if (chance == 0) { SDL_Delay(700); break; }
    }
    gamearray.clear();
    FreeFreshScreen();
    return result;
}

void ExchangePic(int p1, int p2)
{
    if (gamearray.empty() || gamearray[0].empty()) return;
    std::swap(gamearray[0][p1], gamearray[0][p2]);
}

bool WoodMan(int Chamber)
{
    Redraw();
    bool result = true;
    int x = 80, y = 90;
    int eface1 = 0, eface2 = 0, roleface = 0, position = 0;
    int picnum = 4714;
    // 读取木人巷数据
    int sz = sizeof(TWoodMan);
    int offset = Chamber * sz;
    char* p = ReadFileToBuffer(nullptr, AppPath + "binlist/woodman.bin", -1, 1);
    memcpy(&WoodManSta, p + offset, sz);
    FreeFileBuffer(p);
    LoadOnePNGTexture("resource/smap", pSPic, SPNGIndex[picnum]);
    WoodPic = SPNGIndex[picnum].Pointers[0];
    if (!WoodPic) return true;

    auto drawScene = [&]()
    {
        for (int i = 0; i < 100; i++)
        {
            int x1 = i / 10, y1 = i % 10;
            if ((x1 + y1) % 2 == 0) DrawPartPic(WoodPic, 0, 450, 48, 30, x1 * 48 + x, y1 * 30 + y);
            else DrawPartPic(WoodPic, 48, 450, 48, 30, x1 * 48 + x, y1 * 30 + y);
        }
        for (int y1 = 0; y1 <= 18; y1++)
        {
            for (int x1 = 0; x1 <= 18; x1++)
            {
                int idx = x1 * 19 + y1;
                if (WoodManSta.GameData[idx] == 1)
                {
                    if (y1 % 2 == 0) DrawPartPic(WoodPic, 48, 192, 48, 48, (x1 / 2) * 48 + 23 + x, (y1 / 2) * 30 - 18 + y);
                    if (x1 % 2 == 0) DrawPartPic(WoodPic, 96, 192, 48, 48, (x1 / 2) * 48 + x, (y1 / 2) * 30 - 15 + y);
                }
                if ((position / 10) * 2 == x1 && (position % 10) * 2 == y1)
                    DrawPartPic(WoodPic, 0, 192 + 18, 48, 30, (position / 10) * 48 + x, (position % 10) * 30 + y);
                if (WoodManSta.ExitX == x1 && WoodManSta.ExitY == y1)
                    DrawPartPic(WoodPic, 96, 450, 48, 30, (x1 / 2) * 48 + x, (y1 / 2) * 30 + y);
                if (WoodManSta.Exy[0][0] == x1 && WoodManSta.Exy[0][1] == y1)
                    DrawPartPic(WoodPic, 0, 48 * eface1, 48, 48, (x1 / 2) * 48 + x, (y1 / 2) * 30 - 25 + y);
                if (WoodManSta.Exy[1][0] == x1 && WoodManSta.Exy[1][1] == y1)
                    DrawPartPic(WoodPic, 0, 48 * eface1, 48, 48, (x1 / 2) * 48 + x, (y1 / 2) * 30 - 25 + y);
                if (WoodManSta.Rx == x1 && WoodManSta.Ry == y1)
                    DrawPartPic(WoodPic, 0, 240 + 48 * roleface, 48, 48, (x1 / 2) * 48 + x, (y1 / 2) * 30 - 25 + y);
            }
        }
        UpdateAllScreen();
    };

    auto doEnemyMove = [&]() -> bool
    {
        for (int i3 = 0; i3 < 2; i3++)
        {
            if (WoodManSta.Exy[i3][0] != 255 && WoodManSta.Exy[i3][1] != 255)
            {
                for (int i2 = 0; i2 < 2; i2++)
                {
                    if (i3 == 0)
                    {
                        if (WoodManSta.Exy[i3][0] < WoodManSta.Rx && WoodManSta.GameData[(WoodManSta.Exy[i3][0] + 1) * 19 + WoodManSta.Exy[i3][1]] == 0)
                        { eface1 = 3; ShowWoodManWalk(i3, eface1, eface2, roleface); }
                        else if (WoodManSta.Exy[i3][0] > WoodManSta.Rx && WoodManSta.GameData[(WoodManSta.Exy[i3][0] - 1) * 19 + WoodManSta.Exy[i3][1]] == 0)
                        { eface1 = 2; ShowWoodManWalk(i3, eface1, eface2, roleface); }
                        else if (WoodManSta.Exy[i3][1] > WoodManSta.Ry && WoodManSta.GameData[WoodManSta.Exy[i3][0] * 19 + WoodManSta.Exy[i3][1] - 1] == 0)
                        { eface1 = 1; ShowWoodManWalk(i3, eface1, eface2, roleface); }
                        else if (WoodManSta.Exy[i3][1] < WoodManSta.Ry && WoodManSta.GameData[WoodManSta.Exy[i3][0] * 19 + WoodManSta.Exy[i3][1] + 1] == 0)
                        { eface1 = 0; ShowWoodManWalk(i3, eface1, eface2, roleface); }
                    }
                    else
                    {
                        if (WoodManSta.Exy[i3][1] > WoodManSta.Ry && WoodManSta.GameData[WoodManSta.Exy[i3][0] * 19 + WoodManSta.Exy[i3][1] + 1] == 0)
                        { eface1 = 1; ShowWoodManWalk(i3, eface1, eface2, roleface); }
                        else if (WoodManSta.Exy[i3][1] < WoodManSta.Ry && WoodManSta.GameData[WoodManSta.Exy[i3][0] * 19 + WoodManSta.Exy[i3][1] - 1] == 0)
                        { eface1 = 0; ShowWoodManWalk(i3, eface1, eface2, roleface); }
                        else if (WoodManSta.Exy[i3][0] < WoodManSta.Rx && WoodManSta.GameData[(WoodManSta.Exy[i3][0] - 1) * 19 + WoodManSta.Exy[i3][1]] == 0)
                        { eface1 = 3; ShowWoodManWalk(i3, eface1, eface2, roleface); }
                        else if (WoodManSta.Exy[i3][0] > WoodManSta.Rx && WoodManSta.GameData[(WoodManSta.Exy[i3][0] + 1) * 19 + WoodManSta.Exy[i3][1]] == 0)
                        { eface1 = 2; ShowWoodManWalk(i3, eface1, eface2, roleface); }
                    }
                }
            }
            if (WoodManSta.Exy[i3][0] == WoodManSta.Rx && WoodManSta.Exy[i3][1] == WoodManSta.Ry)
            {
                SDL_Delay(1000);
                Redraw(); UpdateAllScreen();
                return false; // caught
            }
        }
        return true; // ok
    };

    drawScene();
    while (SDL_WaitEvent(&event))
    {
        drawScene();
        CheckBasicEvent();
        int x1 = WoodManSta.Rx, y1 = WoodManSta.Ry;
        bool canWalk = false, stay = false;
        int xm, ym;
        if (event.type == SDL_EVENT_MOUSE_MOTION)
        {
            if (MouseInRegion(x, y, 480, 300, xm, ym))
                position = (xm - x) / 48 * 10 + (ym - y) / 30;
        }
        if (event.type == SDL_EVENT_KEY_UP)
        {
            if (event.key.key == SDLK_ESCAPE) { result = false; Redraw(); UpdateAllScreen(); break; }
            x1 = WoodManSta.Rx; y1 = WoodManSta.Ry;
            if (event.key.key == SDLK_UP) y1 = WoodManSta.Ry - 2;
            if (event.key.key == SDLK_DOWN) y1 = WoodManSta.Ry + 2;
            if (event.key.key == SDLK_LEFT) x1 = WoodManSta.Rx - 2;
            if (event.key.key == SDLK_RIGHT) x1 = WoodManSta.Rx + 2;
            if (event.key.key == SDLK_RETURN || event.key.key == SDLK_SPACE) { canWalk = true; stay = true; }
            if (y1 - WoodManSta.Ry == 2 && WoodManSta.GameData[WoodManSta.Rx * 19 + WoodManSta.Ry + 1] == 0) { canWalk = true; roleface = 0; }
            if (y1 - WoodManSta.Ry == -2 && WoodManSta.GameData[WoodManSta.Rx * 19 + WoodManSta.Ry - 1] == 0) { canWalk = true; roleface = 1; }
            if (x1 - WoodManSta.Rx == -2 && WoodManSta.GameData[(WoodManSta.Rx - 1) * 19 + WoodManSta.Ry] == 0) { canWalk = true; roleface = 2; }
            if (x1 - WoodManSta.Rx == 2 && WoodManSta.GameData[(WoodManSta.Rx + 1) * 19 + WoodManSta.Ry] == 0) { canWalk = true; roleface = 3; }
            if (canWalk)
            {
                if (!stay) ShowManWalk(roleface, eface1, eface2);
                if (WoodManSta.Rx == WoodManSta.ExitX && WoodManSta.Ry == WoodManSta.ExitY)
                { result = true; SDL_Delay(1000); Redraw(); UpdateAllScreen(); break; }
                if (!doEnemyMove()) { result = false; return result; }
            }
        }
        if (event.type == SDL_EVENT_MOUSE_BUTTON_UP)
        {
            if (event.button.button == SDL_BUTTON_RIGHT) { result = false; Redraw(); UpdateAllScreen(); break; }
            x1 = (position / 10) * 2; y1 = (position % 10) * 2;
            canWalk = false; stay = false;
            if (y1 - WoodManSta.Ry == 2 && WoodManSta.GameData[WoodManSta.Rx * 19 + WoodManSta.Ry + 1] == 0) { canWalk = true; roleface = 0; }
            if (y1 - WoodManSta.Ry == -2 && WoodManSta.GameData[WoodManSta.Rx * 19 + WoodManSta.Ry - 1] == 0) { canWalk = true; roleface = 1; }
            if (x1 - WoodManSta.Rx == -2 && WoodManSta.GameData[(WoodManSta.Rx - 1) * 19 + WoodManSta.Ry] == 0) { canWalk = true; roleface = 2; }
            if (x1 - WoodManSta.Rx == 2 && WoodManSta.GameData[(WoodManSta.Rx + 1) * 19 + WoodManSta.Ry] == 0) { canWalk = true; roleface = 3; }
            if (x1 == WoodManSta.Rx && y1 == WoodManSta.Ry) { canWalk = true; stay = true; }
            if (canWalk)
            {
                if (!stay) ShowManWalk(roleface, eface1, eface2);
                if (WoodManSta.Rx == WoodManSta.ExitX && WoodManSta.Ry == WoodManSta.ExitY)
                { result = true; SDL_Delay(1000); Redraw(); UpdateAllScreen(); return result; }
                if (!doEnemyMove()) { result = false; return result; }
            }
        }
    }
    return result;
}

void ShowManWalk(int face, int Eface1, int Eface2)
{
    int x = 80, y = 90;
    int x2 = 0, y2 = 0;
    if (face == 0) y2 = 10;
    if (face == 1) y2 = -10;
    if (face == 2) x2 = -16;
    if (face == 3) x2 = 16;
    for (int i1 = 0; i1 < 3; i1++)
    {
        for (int i = 0; i < 100; i++)
        {
            int x1 = i / 10, y1 = i % 10;
            if ((x1 + y1) % 2 == 0)
                DrawPartPic(WoodPic, 0, 450, 48, 30, x1 * 48 + x, y1 * 30 + y);
            else
                DrawPartPic(WoodPic, 48, 450, 48, 30, x1 * 48 + x, y1 * 30 + y);
        }
        for (int y1 = 0; y1 <= 18; y1++)
        {
            for (int x1 = 0; x1 <= 18; x1++)
            {
                int idx = x1 * 19 + y1;
                if (WoodManSta.GameData[idx] == 1)
                {
                    if (y1 % 2 == 0)
                        DrawPartPic(WoodPic, 48, 192, 48, 48, (x1 / 2) * 48 + 23 + x, (y1 / 2) * 30 - 18 + y);
                    if (x1 % 2 == 0)
                        DrawPartPic(WoodPic, 96, 192, 48, 48, (x1 / 2) * 48 + x, (y1 / 2) * 30 - 15 + y);
                }
                if (WoodManSta.ExitX == x1 && WoodManSta.ExitY == y1)
                    DrawPartPic(WoodPic, 96, 450, 48, 30, (x1 / 2) * 48 + x, (y1 / 2) * 30 + y);
                if (WoodManSta.Exy[0][0] == x1 && WoodManSta.Exy[0][1] == y1)
                    DrawPartPic(WoodPic, 0, 48 * Eface1, 48, 48, (x1 / 2) * 48 + x, (y1 / 2) * 30 - 25 + y);
                if (WoodManSta.Exy[1][0] == x1 && WoodManSta.Exy[1][1] == y1)
                    DrawPartPic(WoodPic, 0, 48 * Eface1, 48, 48, (x1 / 2) * 48 + x, (y1 / 2) * 30 - 25 + y);
                if (WoodManSta.Rx == x1 && WoodManSta.Ry == y1)
                {
                    if (i1 == 2)
                    {
                        int tx = WoodManSta.Rx, ty = WoodManSta.Ry;
                        if (face == 0) ty = WoodManSta.Ry + 2;
                        if (face == 1) ty = WoodManSta.Ry - 2;
                        if (face == 2) tx = WoodManSta.Rx - 2;
                        if (face == 3) tx = WoodManSta.Rx + 2;
                        DrawPartPic(WoodPic, 0, 240 + 48 * face, 48, 48, (tx / 2) * 48 + x, (ty / 2) * 30 - 25 + y);
                    }
                    else
                        DrawPartPic(WoodPic, 48 * (i1 + 1), 240 + 48 * face, 48, 48,
                            (x1 / 2) * 48 + x + ((i1 + 1) * x2), (y1 / 2) * 30 - 25 + y + ((i1 + 1) * y2));
                }
            }
        }
        UpdateAllScreen();
        SDL_Delay(100);
    }
    if (face == 0) WoodManSta.Ry += 2;
    if (face == 1) WoodManSta.Ry -= 2;
    if (face == 2) WoodManSta.Rx -= 2;
    if (face == 3) WoodManSta.Rx += 2;
}

void ShowWoodManWalk(int num, int Eface1, int Eface2, int RoleFace)
{
    int x = 80, y = 90;
    uint8_t* Ex1 = &WoodManSta.Exy[num][0];
    uint8_t* Ey1 = &WoodManSta.Exy[num][1];
    uint8_t* Ex2 = &WoodManSta.Exy[abs(num - 1)][0];
    uint8_t* Ey2 = &WoodManSta.Exy[abs(num - 1)][1];
    int* Ef1; int* Ef2;
    if (num == 0) { Ef1 = &Eface1; Ef2 = &Eface2; }
    else { Ef2 = &Eface1; Ef1 = &Eface2; }
    int x2 = 0, y2 = 0;
    if (*Ef1 == 0) y2 = 10;
    if (*Ef1 == 1) y2 = -10;
    if (*Ef1 == 2) x2 = -16;
    if (*Ef1 == 3) x2 = 16;
    for (int i1 = 0; i1 < 3; i1++)
    {
        for (int i = 0; i < 100; i++)
        {
            int x1 = i / 10, y1 = i % 10;
            if ((x1 + y1) % 2 == 0)
                DrawPartPic(WoodPic, 0, 450, 48, 30, x1 * 48 + x, y1 * 30 + y);
            else
                DrawPartPic(WoodPic, 48, 450, 48, 30, x1 * 48 + x, y1 * 30 + y);
        }
        for (int y1 = 0; y1 <= 18; y1++)
        {
            for (int x1 = 0; x1 <= 18; x1++)
            {
                int idx = x1 * 19 + y1;
                if (WoodManSta.GameData[idx] == 1)
                {
                    if (y1 % 2 == 0) DrawPartPic(WoodPic, 48, 192, 48, 48, (x1 / 2) * 48 + 23 + x, (y1 / 2) * 30 - 18 + y);
                    if (x1 % 2 == 0) DrawPartPic(WoodPic, 96, 192, 48, 48, (x1 / 2) * 48 + x, (y1 / 2) * 30 - 15 + y);
                }
                if (WoodManSta.ExitX == x1 && WoodManSta.ExitY == y1)
                    DrawPartPic(WoodPic, 96, 450, 48, 30, (x1 / 2) * 48 + x, (y1 / 2) * 30 + y);
                if (*Ex1 == x1 && *Ey1 == y1)
                {
                    if (i1 == 2)
                    {
                        int tx = *Ex1, ty = *Ey1;
                        if (*Ef1 == 0) ty = *Ey1 + 2;
                        if (*Ef1 == 1) ty = *Ey1 - 2;
                        if (*Ef1 == 2) tx = *Ex1 - 2;
                        if (*Ef1 == 3) tx = *Ex1 + 2;
                        DrawPartPic(WoodPic, 0, 48 * (*Ef1), 48, 48, (tx / 2) * 48 + x, (ty / 2) * 30 - 25 + y);
                    }
                    else
                        DrawPartPic(WoodPic, 48 * (i1 + 1), 48 * (*Ef1), 48, 48,
                            (x1 / 2) * 48 + x + (i1 + 1) * x2, (y1 / 2) * 30 - 25 + y + (i1 + 1) * y2);
                }
                if (*Ex2 == x1 && *Ey2 == y1)
                    DrawPartPic(WoodPic, 0, 48 * (*Ef2), 48, 48, (x1 / 2) * 48 + x, (y1 / 2) * 30 - 25 + y);
                if (WoodManSta.Rx == x1 && WoodManSta.Ry == y1)
                    DrawPartPic(WoodPic, 0, 240 + 48 * RoleFace, 48, 48, (x1 / 2) * 48 + x, (y1 / 2) * 30 - 25 + y);
            }
        }
        UpdateAllScreen();
        SDL_Delay(100);
    }
    if (*Ef1 == 0) *Ey1 += 2;
    if (*Ef1 == 1) *Ey1 -= 2;
    if (*Ef1 == 2) *Ex1 -= 2;
    if (*Ef1 == 3) *Ex1 += 2;
}

int DancerAfter90S()
{
    Redraw();
    int DanceNum = 0;
    int DanceLong = 8;
    uint32_t ori_time = SDL_GetTicks();
    uint32_t demand_time = 10000;
    bool iskey = true;
    int16_t DanceList[10];
    DrawRectangle((320 - 43 * (DanceLong / 2)) - 5, 120 - 62, (DanceLong + 1) * 43 + 5, 45, ColColor(0), ColColor(0xFF), 25);
    DrawRectangle(0, 420, 640, 14, ColColor(47), ColColor(0xFF), 0);
    UpdateAllScreen();
    for (int i = 0; i <= DanceLong; i++)
    {
        int tmp = rand() % 4;
        DanceList[i] = tmp;
        DrawSPic(4678 + DanceList[i], 320 - 43 * (DanceLong / 2) + i * 43, 120 - 62);
    }
    int result = 0;
    while (SDL_PollEvent(&event) || true)
    {
        uint32_t now = SDL_GetTicks();
        uint32_t elapsed = now - ori_time;
        if (elapsed < (uint32_t)(demand_time * 0.7))
            DrawRectangle(0, 420, 640 * elapsed / demand_time, 14, ColColor(47), ColColor(0xFF), 100);
        else if (elapsed <= demand_time)
            DrawRectangle(0, 420, 640 * elapsed / demand_time, 14, ColColor(70), ColColor(0xFF), 100);
        else { WaitAnyKey(); result = 0; break; }
        UpdateAllScreen();
        if (event.type == SDL_EVENT_KEY_DOWN)
        {
            if (DanceNum != DanceLong + 1)
            {
                if ((int)(event.key.key - 273) == DanceList[DanceNum] && iskey)
                {
                    DrawSPic(4682 + DanceList[DanceNum], 320 - 43 * (DanceLong / 2) + DanceNum * 43, 120);
                    DanceNum++;
                    iskey = false;
                }
                else if (iskey)
                {
                    for (int i = 0; i <= DanceNum; i++)
                        DrawSPic(4678 + DanceList[i], 320 - 43 * (DanceLong / 2) + i * 43, 120 - 62);
                    DanceNum = 0;
                    iskey = false;
                }
            }
            else if (event.key.key == SDLK_SPACE && iskey)
            {
                result = 1; break;
            }
        }
        if (event.type == SDL_EVENT_KEY_UP)
        {
            iskey = true;
            if (event.key.key == SDLK_ESCAPE) { result = 0; break; }
        }
        event.key.key = 0;
    }
    return result;
}

void RoleEnding(int starnum, int headnum, int talknum)
{
    int status = GetStarState(starnum);
    int framex = CENTER_X - 384;
    int framey = CENTER_Y - 240 + 160 * (starnum % 3);
    int h = 160, w = 768;
    if (starnum % 3 == 0) Redraw();

    uint8_t r = rand() % 128, g = rand() % 128, b = rand() % 128;
    uint32_t clr = MapRGBA(r, g, b);
    DrawRectangleWithoutFrame(framex, framey, w, h - 1, clr, 50);

    int ty = framey + 10, hy = framey;
    int hx, tx, nx, sy2;
    if (starnum % 2 == 0)
    {
        tx = framex + 250; hx = framex + 10; nx = hx + 200; sy2 = nx;
    }
    else
    {
        tx = framex + 10; hx = framex + 588; nx = hx - 55; sy2 = nx;
    }

    std::string str1 = Star[starnum];
    std::string str2;
    if (status == 0) str2 = "？？？"; // ？？？
    else
    {
        DrawHeadPic(headnum, hx, hy);
        str2 = RoleName[starnum];
    }
    int l = DrawLength(str1.c_str());
    DrawShadowText(str1.c_str(), sy2 - (10 * l) / 2, ty, ColColor(0x64), ColColor(0x66));
    l = DrawLength(str2.c_str());
    DrawShadowText(str2.c_str(), nx - (10 * l) / 2, ty + 22, ColColor(0x64), ColColor(0x66));

    if (status > 0)
    {
        std::vector<uint8_t> talkarray;
        ReadTalk(talknum, talkarray);
        std::string talkstr = " " + std::string((char*)talkarray.data());
        std::string namestr = Rrole[0].Name;
        talkstr = ReplaceStr(talkstr, "&&", namestr);
        // 简化显示
        DrawShadowText(talkstr.c_str(), tx, ty, ColColor(5), ColColor(7));
    }
    UpdateAllScreen();
}

// ---- 属性与升级 ----

void CalAddPro(int magictype, int& attackadd, int& speedadd, int& defenceadd, int& HPadd, int& MPadd)
{
    switch (magictype)
    {
    case 1: attackadd = 4; speedadd = 0; defenceadd = 4; HPadd = 30; MPadd = 40; break;
    case 2: attackadd = 5; speedadd = 1; defenceadd = 3; HPadd = 20; MPadd = 30; break;
    case 3: attackadd = 3; speedadd = 0; defenceadd = 5; HPadd = 40; MPadd = 20; break;
    case 4: attackadd = 4; speedadd = 2; defenceadd = 4; HPadd = 30; MPadd = 20; break;
    case 5: attackadd = 2; speedadd = 3; defenceadd = 2; HPadd = 30; MPadd = 30; break;
    default: attackadd = 0; speedadd = 0; defenceadd = 0; HPadd = 0; MPadd = 0; break;
    }
}

void SetAttribute(int rnum, int selecttype, int modlevel, int minlevel, int maxlevel)
{
    if (minlevel == 0) minlevel = 1;
    if (maxlevel == 0) maxlevel = 60;

    int leveltype = selecttype % 10;
    int magictype = selecttype / 10;
    int lv;

    switch (leveltype)
    {
    case 0: lv = Rrole[0].Level; break;
    case 1:
    {
        lv = Rrole[0].Level;
        for (int i = 1; i <= 5; i++)
            if (TeamList[i] > 0 && Rrole[TeamList[i]].Level > lv)
                lv = Rrole[TeamList[i]].Level;
        break;
    }
    case 2:
    {
        lv = Rrole[0].Level;
        for (int i = 1; i <= 5; i++)
            if (TeamList[i] > 0 && Rrole[TeamList[i]].Level < lv)
                lv = Rrole[TeamList[i]].Level;
        break;
    }
    case 3:
    {
        int sum = Rrole[0].Level;
        lv = Rrole[0].Level;
        int j = 1;
        for (int i = 1; i <= 5; i++)
        {
            if (TeamList[i] > 0)
            {
                j++;
                sum += Rrole[TeamList[i]].Level;
                if (Rrole[TeamList[i]].Level < lv)
                    lv = Rrole[TeamList[i]].Level;
            }
            else break;
        }
        if (j > 1) { sum -= lv; lv = sum / (j - 1); }
        break;
    }
    default: lv = Rrole[0].Level; break;
    }

    lv += modlevel;
    if (lv > maxlevel) lv = maxlevel;
    if (lv < minlevel) lv = minlevel;

    // 基础属性
    Rrole[rnum].MaxHP = 50;
    Rrole[rnum].MaxMP = 40;
    Rrole[rnum].Defence = 30;
    Rrole[rnum].Speed = 30;
    Rrole[rnum].Attack = 30;
    Rrole[rnum].Fist = 10;
    Rrole[rnum].Sword = 10;
    Rrole[rnum].Knife = 10;
    Rrole[rnum].Unusual = 10;
    Rrole[rnum].HidWeapon = 10;

    int attackadd, speedadd, defenceadd, HPadd, MPadd;

    // 武功加成
    for (int i = 0; i < 10; i++)
    {
        if (Rrole[rnum].Magic[i] <= 0) break;
        int mnum = Rrole[rnum].Magic[i];
        int magiclevel = Rrole[rnum].MagLevel[i] / 100 + 1;
        int magichurt = Rmagic[mnum].Attack[0] + (Rmagic[mnum].Attack[1] - Rmagic[mnum].Attack[0]) * magiclevel / 10;
        if (Rmagic[mnum].HurtType == 2) magichurt = 1000;
        magichurt /= 10;
        switch (Rmagic[mnum].MagicType)
        {
        case 1: Rrole[rnum].Fist += magichurt; break;
        case 2: Rrole[rnum].Sword += magichurt; break;
        case 3: Rrole[rnum].Knife += magichurt; break;
        case 4: Rrole[rnum].Unusual += magichurt; break;
        case 5: Rrole[rnum].HidWeapon += magichurt; break;
        }
        CalAddPro(magictype, attackadd, speedadd, defenceadd, HPadd, MPadd);
        magiclevel = Rrole[rnum].MagLevel[i] / 100 + 1;
        Rrole[rnum].MaxHP += HPadd * magiclevel;
        Rrole[rnum].MaxMP += MPadd * magiclevel;
        Rrole[rnum].Attack += attackadd * magiclevel;
        Rrole[rnum].Defence += defenceadd * magiclevel;
        Rrole[rnum].Speed += (int)((speedadd + 0.5) * magiclevel);
    }

    // 内功加成
    for (int i = 0; i < 4; i++)
    {
        if (Rrole[rnum].NeiGong[i] <= 0) break;
        int magiclevel = Rrole[rnum].NGLevel[i] / 100 + 1;
        Rrole[rnum].MaxHP += 50 * magiclevel;
        Rrole[rnum].MaxMP += 50 * magiclevel;
        Rrole[rnum].Attack += 2 * magiclevel;
        Rrole[rnum].Defence += 2 * magiclevel;
        Rrole[rnum].Speed += 2 * magiclevel;
        Rrole[rnum].DefPoi += 2 * magiclevel;
    }

    // 等级属性
    auto logN = [](double base, double x) -> double { return (x > 0 && base > 0) ? log(x) / log(base) : 0; };
    Rrole[rnum].Level = lv;
    Rrole[rnum].MaxHP = std::min(MAX_HP, 50 + (int)((Rrole[rnum].IncLife + 1) * lv * logN(4, lv)) + rand() % lv - rand() % lv);
    Rrole[rnum].CurrentHP = Rrole[rnum].MaxHP;
    Rrole[rnum].MaxMP = std::min(MAX_MP, 40 + (int)((Rrole[rnum].AddMP + 1) * lv * logN(4, lv)) + rand() % lv - rand() % lv);
    Rrole[rnum].CurrentMP = Rrole[rnum].MaxMP;
    Rrole[rnum].Attack = 30 + (int)((Rrole[rnum].AddAtk + 1) * (lv - 1) * logN(10, lv)) + rand() % (lv / 2 + 1) - rand() % (lv / 2 + 1);
    Rrole[rnum].Defence = 30 + (int)((Rrole[rnum].AddDef + 1) * (lv - 1) * logN(10, lv)) + rand() % (lv / 2 + 1) - rand() % (lv / 2 + 1);
    Rrole[rnum].Speed = 30 + (int)(Rrole[rnum].AddSpeed * lv * logN(20, lv)) + rand() % (lv / 2 + 1) - rand() % (lv / 2 + 1);

    auto addSkill = [&](int& skill, int lv2) {
        if (skill > 10)
            skill += (int)(2 * lv2 * logN(20, lv2)) + rand() % (lv2 / 3 + 1) - rand() % (lv2 / 3 + 1);
    };
    addSkill(Rrole[rnum].Fist, lv);
    addSkill(Rrole[rnum].Sword, lv);
    addSkill(Rrole[rnum].Knife, lv);
    addSkill(Rrole[rnum].Unusual, lv);
    addSkill(Rrole[rnum].HidWeapon, lv);
    addSkill(Rrole[rnum].Medcine, lv);
    addSkill(Rrole[rnum].UsePoi, lv);
    addSkill(Rrole[rnum].MedPoi, lv);

    for (int i = 46; i <= 54; i++)
    {
        if (Rrole[rnum].Data[i] > MaxProList[i])
            Rrole[rnum].Data[i] = MaxProList[i];
    }

    if (magictype == 7)
    {
        int ml = lv * 20;
        if (ml > 999) ml = 999;
        Rrole[rnum].MagLevel[0] = ml;
    }
}

int GetItemAmount(int inum)
{
    for (int i = 0; i < MAX_ITEM_AMOUNT; i++)
    {
        if (RItemList[i].Number == inum)
            return RItemList[i].Amount;
    }
    return 0;
}

int CorrectMagic(int rnum)
{
    // 调整错位的内容
    for (int i1 = 0; i1 < 10; i1++)
    {
        if (Rrole[rnum].Magic[i1] > 0 && Rmagic[Rrole[rnum].Magic[i1]].HurtType == 3)
        {
            kyslog("Role %d, magic %d", rnum, i1);
            for (int i2 = 0; i2 < 4; i2++)
            {
                if (Rrole[rnum].NeiGong[i2] == Rrole[rnum].Magic[i1]) break;
                if (Rrole[rnum].NeiGong[i2] <= 0)
                {
                    Rrole[rnum].NeiGong[i2] = Rrole[rnum].Magic[i1];
                    Rrole[rnum].NGLevel[i2] = Rrole[rnum].MagLevel[i1];
                    break;
                }
            }
            Rrole[rnum].Magic[i1] = 0;
            Rrole[rnum].MagLevel[i1] = 0;
        }
    }
    for (int i1 = 0; i1 < 4; i1++)
    {
        if (Rrole[rnum].NeiGong[i1] > 0 && Rmagic[Rrole[rnum].NeiGong[i1]].HurtType != 3)
        {
            kyslog("Role %d, inner magic %d", rnum, i1);
            for (int i2 = 0; i2 < 10; i2++)
            {
                if (Rrole[rnum].Magic[i2] == Rrole[rnum].NeiGong[i1]) break;
                if (Rrole[rnum].Magic[i2] <= 0)
                {
                    Rrole[rnum].Magic[i2] = Rrole[rnum].NeiGong[i1];
                    Rrole[rnum].MagLevel[i2] = Rrole[rnum].NGLevel[i1];
                    break;
                }
            }
            Rrole[rnum].NeiGong[i1] = 0;
            Rrole[rnum].NGLevel[i1] = 0;
        }
    }
    return 0;
}

void BookList()
{
    int j = 0;
    std::vector<std::string> menuStr(MAX_ITEM_AMOUNT);
    std::vector<int> itemlist(MAX_ITEM_AMOUNT);
    for (int i = 0; i < MAX_ITEM_AMOUNT; i++)
    {
        if (RItemList[i].Number >= 0 && RItemList[i].Amount > 0)
        {
            if (Ritem[RItemList[i].Number].Magic >= 0)
            {
                menuStr[j] = std::string(" ") + Ritem[RItemList[i].Number].Name;
                itemlist[j] = RItemList[i].Number;
                j++;
            }
        }
    }
    Redraw();
    UpdateAllScreen();
    int i = CommonScrollMenu(220, 10, 200, j - 1, 15, menuStr);
    if (i > -1) i = itemlist[i];
    x50[28931] = i;
}

int GetStarAmount()
{
    int result = 0;
    for (int i = 0; i < 108; i++)
    {
        if (GetStarState(i) > 0) result++;
    }
    return result;
}

// ---- 场景跳转 ----

void JumpScene(int snum, int y, int x)
{
    CurScene = snum;
    if (x == -2) x = Rscene[CurScene].EntranceX;
    if (y == -2) y = Rscene[CurScene].EntranceY;
    Cx = x + Cx - Sx;
    Cy = y + Cy - Sy;
    Sx = x;
    Sy = y;
    TimeInWater = 30 + Rrole[0].CurrentMP / 100;
    InitialScene();
    DrawScene();
    instruct_13();
    ShowSceneName(CurScene);
    CheckEvent3();
}

int ReSetName(int t, int inum, int newnamenum)
{
    std::vector<uint8_t> talkarray;
    ReadTalk(newnamenum, talkarray);
    char* p = nullptr;
    switch (t)
    {
    case 0: p = Rrole[inum].Name; break;
    case 1: p = Ritem[inum].Name; break;
    case 2: p = Rscene[inum].Name; break;
    case 3: p = Rmagic[inum].Name; break;
    case 4: p = Ritem[inum].Introduction; break;
    default: return 0;
    }
    int len = (int)strlen((char*)talkarray.data());
    memcpy(p, talkarray.data(), len);
    p[len] = 0;
    return 0;
}

// ---- 商店系统 ----

void NewShop(int shop_num)
{
    auto& sell = RShop[shop_num];
    int money = GetItemAmount(MONEY_ID);
    int buyAmount[5] = {0};
    int holdAmount[5];
    std::string menuStr[5];

    for (int i = 0; i < 5; i++)
    {
        holdAmount[i] = GetItemAmount(sell.Item[i]);
        menuStr[i] = Ritem[sell.Item[i]].Name;
    }

    int x = CENTER_X - 190, y = 200;
    DrawRectangleWithoutFrame(0, 20, CENTER_X * 2, 120, 0, 40);
    std::string shopStr = "需要買什麼？"; // 需要買什麽？
    DrawShadowText(shopStr.c_str(), CENTER_X - 70, 55, ColColor(0xFF), ColColor(0x0));

    int menu = 0, select = 0, lr = 0;
    bool sure = false;
    SDL_Event ev;

    while (!sure)
    {
        // 计算总价
        int totalprice = 0;
        for (int i = 0; i < 5; i++)
            totalprice += sell.Price[i] * buyAmount[i];

        // 绘制
        DrawRectangle(x, y, 420, 116, 0, ColColor(255), 50);
        for (int i = 0; i < 5; i++)
        {
            char buf[80];
            snprintf(buf, sizeof(buf), "%5d%7d%6d%9d", sell.Price[i], sell.Amount[i], holdAmount[i], buyAmount[i]);
            if (i == menu)
            {
                DrawShadowText(menuStr[i].c_str(), x + 3, y + 2 + 22 * i, ColColor(0x64), ColColor(0x66));
                DrawEngShadowText(buf, x + 120, y + 2 + 22 * i, ColColor(0x64), ColColor(0x66));
            }
            else
            {
                DrawShadowText(menuStr[i].c_str(), x + 3, y + 2 + 22 * i, ColColor(0x5), ColColor(0x7));
                DrawEngShadowText(buf, x + 120, y + 2 + 22 * i, ColColor(0x5), ColColor(0x7));
            }
        }

        char moneyBuf[64];
        snprintf(moneyBuf, sizeof(moneyBuf), "現有銀兩：%5d", money);
        DrawTextWithRect(moneyBuf, x, y + 140, 160, 0, 0x202020, 0, 0);
        snprintf(moneyBuf, sizeof(moneyBuf), "花費估算：%5d", totalprice);
        DrawTextWithRect(moneyBuf, x, y + 180, 160, 0, 0x202020, 0, 0);
        UpdateAllScreen();

        if (SDL_WaitEvent(&ev))
        {
            CheckBasicEvent();
            if (ev.type == SDL_EVENT_KEY_UP)
            {
                if (ev.key.key == SDLK_ESCAPE) break;
                if (ev.key.key == SDLK_UP && menu > 0) menu--;
                if (ev.key.key == SDLK_DOWN && menu < 4) menu++;
                if (ev.key.key == SDLK_LEFT)
                {
                    if (buyAmount[menu] > 0) buyAmount[menu]--;
                }
                if (ev.key.key == SDLK_RIGHT)
                {
                    if (buyAmount[menu] < sell.Amount[menu] && totalprice + sell.Price[menu] <= money)
                        buyAmount[menu]++;
                }
                if (ev.key.key == SDLK_RETURN || ev.key.key == SDLK_SPACE)
                {
                    // 购买
                    for (int i = 0; i < 5; i++)
                    {
                        if (buyAmount[i] > 0)
                        {
                            instruct_32(sell.Item[i], buyAmount[i]);
                            sell.Amount[i] -= buyAmount[i];
                        }
                    }
                    instruct_32(MONEY_ID, -totalprice);
                    sure = true;
                }
            }
            else if (ev.type == SDL_EVENT_MOUSE_BUTTON_UP && ev.button.button == SDL_BUTTON_RIGHT)
                break;
        }
    }
    Redraw();
}

// ---- UI与输入----

void ShowMap()
{
    event.key.key = 0;
    event.button.button = 0;
    int n = 0, p = 0;
    int xp = CENTER_X - 320, yp = 10;
    Redraw();
    double a11 = 1.2762, a12 = -0.7717, a21 = 0.1185, a22 = 1.6291;
    double x0 = 121.9534, y0 = -194.0342;
    int picnum = 4699;
    if (picnum >= SPicAmount) return;
    if (SPNGIndex[picnum].Loaded == 0)
        LoadOnePNGTexture("resource/smap", pSPic, SPNGIndex[picnum]);
    SPNGIndex[picnum].x = 0;
    SPNGIndex[picnum].y = 0;

    // 收集可显示的场景
    std::vector<int> scenex, sceney, scenenum;
    std::vector<std::string> str2, str3;
    int l = SceneAmount;
    for (int i = 0; i < l; i++)
    {
        if ((Rscene[i].MainEntranceY1 == 0 && Rscene[i].MainEntranceX1 == 0 &&
            Rscene[i].MainEntranceX2 == 0 && Rscene[i].MainEntranceY2 == 0) || Rscene[i].EnCondition != 0)
            continue;
        scenex.push_back(Rscene[i].MainEntranceX1);
        sceney.push_back(Rscene[i].MainEntranceY1);
        scenenum.push_back(i);
        str2.push_back((char*)Rscene[i].Name);
        char buf[32]; snprintf(buf, sizeof(buf), "%3d, %3d", Rscene[i].MainEntranceY1, Rscene[i].MainEntranceX1);
        str3.push_back(buf);
    }
    int u = (int)scenex.size();
    if (u == 0) { WaitAnyKey(); return; }

    auto TransCoord = [&](int& tx, int& ty)
    {
        double xt = a11 * tx + a12 * ty + x0;
        double yt = a21 * tx + a22 * ty + y0;
        tx = (int)round(xt) + xp;
        ty = std::max((int)round(yt), 53) + yp;
    };

    while (SDL_PollEvent(&event) || true)
    {
        if (n % 10 == 0)
        {
            SDL_Rect dest1;
            dest1.x = 0; dest1.y = 30; dest1.w = 640; dest1.h = 380;
            DrawSPic(picnum, xp, yp + 30, &dest1, 0, 0, 0, 0);
            for (int i = 0; i < u; i++)
            {
                int tx = 313 + ((sceney[i] - scenex[i]) * 5) / 8;
                int ty = 63 + ((sceney[i] + scenex[i]) * 5) / 16;
                TransCoord(tx, ty);
                dest1.x = 15; dest1.y = 0; dest1.w = 15; dest1.h = 15;
                DrawSPic(picnum, tx, ty, &dest1, 0, 0, 0, 0);
                if (MouseInRegion(tx, ty, 15, 15)) p = i;
            }
            // 选中场景标记
            int tx = 313 + ((sceney[p] - scenex[p]) * 5) / 8;
            int ty = 63 + ((sceney[p] + scenex[p]) * 5) / 16;
            TransCoord(tx, ty);
            dest1.x = 30; dest1.y = 0; dest1.w = 15; dest1.h = 15;
            DrawSPic(picnum, tx, ty, &dest1, 0, 0, 0, 0);
            // 船
            tx = 313 + ((ShipX - ShipY) * 5) / 8;
            ty = 63 + ((ShipX + ShipY) * 5) / 16;
            TransCoord(tx, ty);
            dest1.x = 45; dest1.y = 0; dest1.w = 15; dest1.h = 15;
            DrawSPic(picnum, tx, ty, &dest1, 0, 0, 0, 0);
            CleanTextScreen();
            DrawShadowText(str2[p].c_str(), 37 + xp, 80 + yp, ColColor(21), ColColor(25));
            DrawEngShadowText(str3[p], 37 + xp, 100 + yp, ColColor(255), ColColor(254));
            DrawShadowText("\xe4\xbd\xa0\xe7\x9a\x84\xe4\xbd\x8d\xe7\xbd\xae", 37 + xp, 275 + yp, ColColor(21), ColColor(25));
            char buf[32]; snprintf(buf, sizeof(buf), "%3d, %3d", My, Mx);
            DrawEngShadowText(buf, 37 + xp, 295 + yp, ColColor(255), ColColor(254));
            DrawShadowText("\xe8\x88\xb9\xe7\x9a\x84\xe4\xbd\x8d\xe7\xbd\xae", 37 + xp, 325 + yp, ColColor(21), ColColor(25));
            snprintf(buf, sizeof(buf), "%3d, %3d", ShipX, ShipY);
            DrawEngShadowText(buf, 37 + xp, 345 + yp, ColColor(255), ColColor(254));
        }
        if (n % 20 == 1)
        {
            int tx = 313 + ((My - Mx) * 5) / 8;
            int ty = 63 + ((My + Mx) * 5) / 16;
            TransCoord(tx, ty);
            SDL_Rect dest1;
            dest1.x = 0; dest1.y = 0; dest1.w = 15; dest1.h = 15;
            DrawSPic(picnum, tx, ty, &dest1, 0, 0, 0, 0);
        }
        UpdateAllScreen();
        SDL_Delay(20);
        n++;
        if (n == 1000) n = 0;
        CheckBasicEvent();
        if (event.type == SDL_EVENT_KEY_UP)
        {
            if (event.key.key == SDLK_ESCAPE || event.key.key == SDLK_RETURN || event.key.key == SDLK_SPACE) break;
            if (event.key.key == SDLK_LEFT || event.key.key == SDLK_UP)
            {
                if (u != 0) { p--; if (p <= -1) p = u - 1; }
            }
            if (event.key.key == SDLK_RIGHT || event.key.key == SDLK_DOWN)
            {
                if (u != 0) { p++; if (p >= u) p = 0; }
            }
            event.key.key = 0;
        }
        if (event.type == SDL_EVENT_MOUSE_BUTTON_UP && event.button.button == SDL_BUTTON_RIGHT) break;
        if (event.type == SDL_EVENT_MOUSE_MOTION)
        {
            for (int i = 0; i < u; i++)
            {
                int tx = 313 + ((sceney[i] - scenex[i]) * 5) / 8;
                int ty = 63 + ((sceney[i] + scenex[i]) * 5) / 16;
                TransCoord(tx, ty);
                if (MouseInRegion(tx, ty, 15, 15)) p = i;
            }
        }
    }
}

int16_t EnterNumber(int MinValue, int MaxValue, int x, int y, int Default)
{
    CleanKeyValue();
    int Value = Default;
    MinValue = std::max(-32768, MinValue);
    MaxValue = std::min(32767, MaxValue);

    // 绘制基本界面
    char buf[64];
    snprintf(buf, sizeof(buf), "範圍%d~%d", MinValue, MaxValue); // 範圍
    DrawTextWithRect(buf, x, y - 35, DrawLength(buf) * 10 + 8, 0, ColColor(0x27));
    DrawRectangle(x, y, 180, 180, 0, ColColor(255), 50, 0);
    UpdateAllScreen();

    SDL_Event ev;
    int menu = -1, sure = 0;
    while (SDL_PollEvent(&ev) || true)
    {
        CheckBasicEvent();
        if (ev.type == SDL_EVENT_KEY_UP)
        {
            menu = -1;
            if (ev.key.key >= SDLK_0 && ev.key.key <= SDLK_9) menu = ev.key.key - SDLK_0;
            else if (ev.key.key == SDLK_MINUS) menu = 10;
            else if (ev.key.key == SDLK_BACKSPACE) menu = 11;
            else if (ev.key.key == SDLK_DELETE) menu = 12;
            else if (ev.key.key == SDLK_RETURN || ev.key.key == SDLK_SPACE) { sure = 1; break; }
            sure = 1;
        }
        if (sure > 0 && menu >= 0)
        {
            switch (menu)
            {
            case 0: case 1: case 2: case 3: case 4:
            case 5: case 6: case 7: case 8: case 9:
                if (Value * 10 < 100000) Value = 10 * Value + menu;
                break;
            case 10: Value = -Value; break;
            case 11: Value /= 10; break;
            case 12: Value = 0; break;
            }
            // 刷新显示
            snprintf(buf, sizeof(buf), "%6d", Value);
            DrawRectangle(x, y, 180, 180, 0, ColColor(255), 50, 0);
            DrawShadowText(buf, x + 80, y + 10, ColColor(0x64), ColColor(0x66));
            UpdateAllScreen();
        }
        sure = 0;
        SDL_Delay(25);
    }
    int16_t result = (int16_t)RegionParameter(Value, MinValue, MaxValue);
    CleanKeyValue();
    return result;
}

bool EnterString(std::string& str, int x, int y, int w, int h)
{
    SDL_Rect r = {x, y, w, h};
    SDL_StartTextInput(window);
    SDL_SetTextInputArea(window, &r, 0);
    SDL_Event ev;
    uint32_t tick = 0;
    while (true)
    {
        tick++;
        LoadFreshScreen();
        std::string display = "請輸入主角之姓名：" + str; // 請輸入主角之姓名：
        if (tick % 16 < 8) display += "_";
        else display += " ";
        DrawTextWithRect(display.c_str(), x, y, 280, 0, 0, 0, 1);
        SDL_PollEvent(&ev);
        CheckBasicEvent();
        if (ev.type == SDL_EVENT_TEXT_INPUT)
        {
            str += ev.text.text;
        }
        else if (ev.type == SDL_EVENT_KEY_UP)
        {
            if (ev.key.key == SDLK_RETURN) { SDL_StopTextInput(window); return true; }
            if (ev.key.key == SDLK_ESCAPE) { SDL_StopTextInput(window); return false; }
            if (ev.key.key == SDLK_BACKSPACE)
            {
                int l = (int)str.size();
                if (l >= 3 && (uint8_t)str[l - 1] >= 128)
                    str.resize(l - 3);
                else if (l >= 1)
                    str.resize(l - 1);
            }
        }
        else if (ev.type == SDL_EVENT_MOUSE_BUTTON_UP && ev.button.button == SDL_BUTTON_RIGHT)
        {
            SDL_StopTextInput(window);
            return false;
        }
        SDL_Delay(16);
    }
}
