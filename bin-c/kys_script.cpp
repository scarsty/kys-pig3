// kys_script.cpp - Lua脚本接口
// 对应 kys_script.pas

#include "kys_script.h"
#include "kys_main.h"
#include "kys_engine.h"
#include "kys_draw.h"
#include "kys_battle.h"
#include "kys_event.h"

#include "lua52.h"

#include <cstring>
#include <cstdlib>
#include <cstdio>
#include <cmath>
#include <algorithm>
#include <vector>
#include <string>

// ---- 脚本管理 ----

void InitialScript()
{
    Lua_script = luaL_newstate();
    luaL_openlibs(Lua_script);

    // 注册所有Lua函数 (按字母序, 含instruct_N别名)
    lua_register(Lua_script, "add3eventnum", Lua_Add3EventNum);
    lua_register(Lua_script, "instruct_26", Lua_Add3EventNum);
    lua_register(Lua_script, "addaptitude", Lua_AddAptitude);
    lua_register(Lua_script, "instruct_34", Lua_AddAptitude);
    lua_register(Lua_script, "addattack", Lua_AddAttack);
    lua_register(Lua_script, "instruct_47", Lua_AddAttack);
    lua_register(Lua_script, "addethics", Lua_AddEthics);
    lua_register(Lua_script, "instruct_37", Lua_AddEthics);
    lua_register(Lua_script, "addhp", Lua_AddHP);
    lua_register(Lua_script, "instruct_48", Lua_AddHP);
    lua_register(Lua_script, "additem", Lua_AddItem);
    lua_register(Lua_script, "instruct_32", Lua_AddItem);
    lua_register(Lua_script, "addmp", Lua_AddMP);
    lua_register(Lua_script, "instruct_46", Lua_AddMP);
    lua_register(Lua_script, "addrepute", Lua_AddRepute);
    lua_register(Lua_script, "instruct_56", Lua_AddRepute);
    lua_register(Lua_script, "addroleintobattle", Lua_AddRoleIntoBattle);
    lua_register(Lua_script, "addspeed", Lua_AddSpeed);
    lua_register(Lua_script, "instruct_45", Lua_AddSpeed);
    lua_register(Lua_script, "allleave", Lua_AllLeave);
    lua_register(Lua_script, "instruct_59", Lua_AllLeave);
    lua_register(Lua_script, "anothergetitem", Lua_AnotherGetItem);
    lua_register(Lua_script, "instruct_41", Lua_AnotherGetItem);
    lua_register(Lua_script, "npcgetitem", Lua_AnotherGetItem);
    lua_register(Lua_script, "askbattle", Lua_AskBattle);
    lua_register(Lua_script, "instruct_5", Lua_AskBattle);
    lua_register(Lua_script, "askjoin", Lua_AskJoin);
    lua_register(Lua_script, "instruct_9", Lua_AskJoin);
    lua_register(Lua_script, "askrest", Lua_AskRest);
    lua_register(Lua_script, "instruct_11", Lua_AskRest);
    lua_register(Lua_script, "asksoftstar", Lua_AskSoftStar);
    lua_register(Lua_script, "instruct_51", Lua_AskSoftStar);
    lua_register(Lua_script, "askyesorno", Lua_AskYesOrNo);
    lua_register(Lua_script, "endamination", Lua_BackHome);
    lua_register(Lua_script, "instruct_62", Lua_BackHome);
    lua_register(Lua_script, "instruct_24", Lua_Blank);
    lua_register(Lua_script, "instruct_65", Lua_Blank);
    lua_register(Lua_script, "instruct_7", Lua_Blank);
    lua_register(Lua_script, "instruct_57", Lua_BreakStoneGate);
    lua_register(Lua_script, "changemmapmusic", Lua_ChangeMMapMusic);
    lua_register(Lua_script, "instruct_8", Lua_ChangeMMapMusic);
    lua_register(Lua_script, "changescene", Lua_ChangeScene);
    lua_register(Lua_script, "changescenepic", Lua_ChangeScenePic);
    lua_register(Lua_script, "instruct_38", Lua_ChangeScenePic);
    lua_register(Lua_script, "checkbutton", Lua_CheckButton);
    lua_register(Lua_script, "clear", Lua_Clear);
    lua_register(Lua_script, "instruct_0", Lua_Clear);
    lua_register(Lua_script, "clearbutton", Lua_ClearButton);
    lua_register(Lua_script, "clearrolefrombattle", Lua_ClearRoleFromBattle);
    lua_register(Lua_script, "compareprointeam", Lua_CompareProInTeam);
    lua_register(Lua_script, "darkscene", Lua_DarkScene);
    lua_register(Lua_script, "instruct_14", Lua_DarkScene);
    lua_register(Lua_script, "dead", Lua_Dead);
    lua_register(Lua_script, "instruct_15", Lua_Dead);
    lua_register(Lua_script, "delay", Lua_Delay);
    lua_register(Lua_script, "drawrect", Lua_DrawRect);
    lua_register(Lua_script, "eatoneitem", Lua_EatOneItem);
    lua_register(Lua_script, "enternumber", Lua_EnterNumber);
    lua_register(Lua_script, "execevent", Lua_ExecEvent);
    lua_register(Lua_script, "instruct_58", Lua_FightForTop);
    lua_register(Lua_script, "forcebattleresult", Lua_ForceBattleResult);
    lua_register(Lua_script, "getbattlenumber", Lua_GetBattleNumber);
    lua_register(Lua_script, "getbattlepro", Lua_GetBattlePro);
    lua_register(Lua_script, "getbattlerolepro", Lua_GetBattleRolePro);
    lua_register(Lua_script, "getbutton", Lua_GetButton);
    lua_register(Lua_script, "getcurrentevent", Lua_GetCurrentEvent);
    lua_register(Lua_script, "getcurrentscene", Lua_GetCurrentScene);
    lua_register(Lua_script, "getitem", Lua_GetItem);
    lua_register(Lua_script, "instruct_2", Lua_GetItem);
    lua_register(Lua_script, "getitemlist", Lua_GetItemList);
    lua_register(Lua_script, "getitempro", Lua_GetItemPro);
    lua_register(Lua_script, "getmagicpro", Lua_GetMagicPro);
    lua_register(Lua_script, "getmainmapposition", Lua_GetMainMapPosition);
    lua_register(Lua_script, "getmember", Lua_GetMember);
    lua_register(Lua_script, "getglobalvalue", Lua_GetGlobalValue);
    lua_register(Lua_script, "getmouseposition", Lua_GetMousePosition);
    lua_register(Lua_script, "getnameasstring", Lua_GetNameAsString);
    lua_register(Lua_script, "getrolepro", Lua_GetRolePro);
    lua_register(Lua_script, "getsceneeventpro", Lua_GetSceneEventPro);
    lua_register(Lua_script, "getsceneface", Lua_GetSceneFace);
    lua_register(Lua_script, "getscenemappro", Lua_GetSceneMapPro);
    lua_register(Lua_script, "getsceneposition", Lua_GetScenePosition);
    lua_register(Lua_script, "getscenepro", Lua_GetScenePro);
    lua_register(Lua_script, "getscreensize", Lua_GetScreenSize);
    lua_register(Lua_script, "gettime", Lua_GetTime);
    lua_register(Lua_script, "haveitem", Lua_HaveItemBool);
    lua_register(Lua_script, "haveitemamount", Lua_HaveItemAmount);
    lua_register(Lua_script, "instruct_18", Lua_HaveItemBool);
    lua_register(Lua_script, "instruct_43", Lua_HaveItemBool);
    lua_register(Lua_script, "instruct_16", Lua_InTeam);
    lua_register(Lua_script, "inteam", Lua_InTeam);
    lua_register(Lua_script, "instruct_10", Lua_Join);
    lua_register(Lua_script, "join", Lua_Join);
    lua_register(Lua_script, "instruct_61", Lua_Judge14BooksPlaced);
    lua_register(Lua_script, "judge14booksplaced", Lua_Judge14BooksPlaced);
    lua_register(Lua_script, "instruct_50", Lua_Judge5Item);
    lua_register(Lua_script, "instruct_29", Lua_JudgeAttack);
    lua_register(Lua_script, "judgeattack", Lua_JudgeAttack);
    lua_register(Lua_script, "instruct_28", Lua_JudgeEthics);
    lua_register(Lua_script, "judgeethics", Lua_JudgeEthics);
    lua_register(Lua_script, "instruct_55", Lua_JudgeEventNum);
    lua_register(Lua_script, "judgeeventnum", Lua_JudgeEventNum);
    lua_register(Lua_script, "instruct_42", Lua_JudgeFemaleInTeam);
    lua_register(Lua_script, "judgefemaleinteam", Lua_JudgeFemaleInTeam);
    lua_register(Lua_script, "instruct_31", Lua_JudgeMoney);
    lua_register(Lua_script, "judgemoney", Lua_JudgeMoney);
    lua_register(Lua_script, "judgesceneevent", Lua_JudgeSceneEvent);
    lua_register(Lua_script, "instruct_60", Lua_JudgeScenePic);
    lua_register(Lua_script, "judgescenepic", Lua_JudgeScenePic);
    lua_register(Lua_script, "instruct_36", Lua_JudgeSexual);
    lua_register(Lua_script, "judgesexual", Lua_JudgeSexual);
    lua_register(Lua_script, "jumpscene", Lua_JumpScene);
    lua_register(Lua_script, "learnmagic", Lua_LearnMagic);
    lua_register(Lua_script, "instruct_21", Lua_LeaveTeam);
    lua_register(Lua_script, "leave", Lua_LeaveTeam);
    lua_register(Lua_script, "leaveteam", Lua_LeaveTeam);
    lua_register(Lua_script, "instruct_13", Lua_LightScene);
    lua_register(Lua_script, "lightscene", Lua_LightScene);
    lua_register(Lua_script, "memberamount", Lua_MemberAmount);
    lua_register(Lua_script, "menu", Lua_Menu);
    lua_register(Lua_script, "instruct_3", Lua_ModifyEvent);
    lua_register(Lua_script, "modifyevent", Lua_ModifyEvent);
    lua_register(Lua_script, "instruct_33", Lua_OldLearnMagic);
    lua_register(Lua_script, "learnmagic2", Lua_OldLearnMagic);
    lua_register(Lua_script, "instruct_17", Lua_OldSetSceneMapPro);
    lua_register(Lua_script, "setscenemappro2", Lua_OldSetSceneMapPro);
    lua_register(Lua_script, "setscenemap", Lua_OldSetSceneMapPro);
    lua_register(Lua_script, "instruct_19", Lua_OldSetScenePosition);
    lua_register(Lua_script, "setsceneposition2", Lua_OldSetScenePosition);
    lua_register(Lua_script, "instruct_1", Lua_OldTalk);
    lua_register(Lua_script, "instruct_54", Lua_OpenAllScene);
    lua_register(Lua_script, "openallscene", Lua_OpenAllScene);
    lua_register(Lua_script, "instruct_39", Lua_OpenScene);
    lua_register(Lua_script, "openscene", Lua_OpenScene);
    lua_register(Lua_script, "pause", Lua_Pause);
    lua_register(Lua_script, "instruct_44", Lua_Play2Animation);
    lua_register(Lua_script, "play2animation", Lua_Play2Animation);
    lua_register(Lua_script, "playaction", Lua_PlayAction);
    lua_register(Lua_script, "instruct_27", Lua_PlayAnimation);
    lua_register(Lua_script, "playanimation", Lua_PlayAnimation);
    lua_register(Lua_script, "playhurtvalue", Lua_PlayHurtValue);
    lua_register(Lua_script, "instruct_66", Lua_PlayMusic);
    lua_register(Lua_script, "playmusic", Lua_PlayMusic);
    lua_register(Lua_script, "instruct_67", Lua_PlayWave);
    lua_register(Lua_script, "playwave", Lua_PlayWave);

    // set/put 系列
    lua_register(Lua_script, "setbattlepro", Lua_SetBattlePro);
    lua_register(Lua_script, "setbattlerolepro", Lua_SetBattleRolePro);
    lua_register(Lua_script, "setitempro", Lua_SetItemPro);
    lua_register(Lua_script, "setmagicpro", Lua_SetMagicPro);
    lua_register(Lua_script, "setmember", Lua_SetMember);
    lua_register(Lua_script, "setglobalvalue", Lua_SetGlobalValue);
    lua_register(Lua_script, "setrolepro", Lua_SetRolePro);
    lua_register(Lua_script, "setsceneeventpro", Lua_SetSceneEventPro);
    lua_register(Lua_script, "setscenemappro", Lua_SetSceneMapPro);
    lua_register(Lua_script, "setscenepro", Lua_SetScenePro);

    lua_register(Lua_script, "putbattlepro", Lua_SetBattlePro);
    lua_register(Lua_script, "putbattlerolepro", Lua_SetBattleRolePro);
    lua_register(Lua_script, "putitempro", Lua_SetItemPro);
    lua_register(Lua_script, "putmagicpro", Lua_SetMagicPro);
    lua_register(Lua_script, "putmember", Lua_SetMember);
    lua_register(Lua_script, "putglobalvalue", Lua_SetGlobalValue);
    lua_register(Lua_script, "putrolepro", Lua_SetRolePro);
    lua_register(Lua_script, "putsceneeventpro", Lua_SetSceneEventPro);
    lua_register(Lua_script, "putscenemappro", Lua_SetSceneMapPro);
    lua_register(Lua_script, "putscenepro", Lua_SetScenePro);

    lua_register(Lua_script, "instruct_12", Lua_Rest);
    lua_register(Lua_script, "rest", Lua_Rest);
    lua_register(Lua_script, "instruct_25", Lua_SceneFromTo);
    lua_register(Lua_script, "scenefromto", Lua_SceneFromTo);
    lua_register(Lua_script, "selectoneaim", Lua_SelectOneAim);
    lua_register(Lua_script, "selectoneteammember", Lua_SelectOneTeamMember);
    lua_register(Lua_script, "setaminationlayer", Lua_SetAminationLayer);
    lua_register(Lua_script, "setattribute", Lua_SetAttribute);
    lua_register(Lua_script, "setmainmapposition", Lua_SetMainMapPosition);
    lua_register(Lua_script, "setmenuesctype", Lua_SetMenuEscType);
    lua_register(Lua_script, "instruct_49", Lua_SetMPPro);
    lua_register(Lua_script, "setmppro", Lua_SetMPPro);
    lua_register(Lua_script, "setpersonmppro", Lua_SetMPPro);
    lua_register(Lua_script, "instruct_35", Lua_SetOneMagic);
    lua_register(Lua_script, "setonemagic", Lua_SetOneMagic);
    lua_register(Lua_script, "instruct_23", Lua_SetOneUsePoi);
    lua_register(Lua_script, "setoneusepoi", Lua_SetOneUsePoi);
    lua_register(Lua_script, "instruct_40", Lua_SetRoleFace);
    lua_register(Lua_script, "setroleface", Lua_SetRoleFace);
    lua_register(Lua_script, "setsceneface", Lua_SetSceneFace);
    lua_register(Lua_script, "setsceneposition", Lua_SetScenePosition);
    lua_register(Lua_script, "instruct_63", Lua_SetSexual);
    lua_register(Lua_script, "showability", Lua_ShowAbility);
    lua_register(Lua_script, "instruct_52", Lua_ShowEthics);
    lua_register(Lua_script, "showethics", Lua_ShowEthics);
    lua_register(Lua_script, "showpicture", Lua_ShowPicture);
    lua_register(Lua_script, "instruct_53", Lua_ShowRepute);
    lua_register(Lua_script, "showrepute", Lua_ShowRepute);
    lua_register(Lua_script, "showstatus", Lua_ShowStatus);
    lua_register(Lua_script, "showstring", Lua_ShowString);
    lua_register(Lua_script, "showstringwithbox", Lua_ShowStringWithBox);
    lua_register(Lua_script, "setnameasstring", Lua_SetNameAsString);
    lua_register(Lua_script, "talk", Lua_Talk);
    lua_register(Lua_script, "instruct_20", Lua_TeamIsFull);
    lua_register(Lua_script, "teamisfull", Lua_TeamIsFull);
    lua_register(Lua_script, "instruct_6", Lua_TryBattle);
    lua_register(Lua_script, "trybattle", Lua_TryBattle);
    lua_register(Lua_script, "instruct_4", Lua_UseItem);
    lua_register(Lua_script, "useitem", Lua_UseItem);
    lua_register(Lua_script, "instruct_30", Lua_WalkFromTo);
    lua_register(Lua_script, "walkfromto", Lua_WalkFromTo);
    lua_register(Lua_script, "instruct_64", Lua_WeiShop);
    lua_register(Lua_script, "weishop", Lua_WeiShop);
    lua_register(Lua_script, "instruct_22", Lua_ZeroAllMP);
    lua_register(Lua_script, "zeroallmp", Lua_ZeroAllMP);
    lua_register(Lua_script, "getx50", Lua_GetX50);
    lua_register(Lua_script, "setx50", Lua_SetX50);
    lua_register(Lua_script, "putx50", Lua_SetX50);

    lua_register(Lua_script, "showtitle", Lua_ShowTitle);
    lua_register(Lua_script, "readtalkasstring", Lua_ReadTalkAsString);
    lua_register(Lua_script, "checkjumpflag", Lua_CheckJumpFlag);
    lua_register(Lua_script, "exit", Lua_ExitScript);
    lua_register(Lua_script, "addroleprowithhint", Lua_AddRoleProWithHint);
    lua_register(Lua_script, "colcolor", Lua_ColColor);
    lua_register(Lua_script, "setbattlename", Lua_SetBattleName);
    lua_register(Lua_script, "showsimplestatus", Lua_ShowSimpleStatus);
    lua_register(Lua_script, "updateallscreen", Lua_UpdateAllScreen);

    lua_register(Lua_script, "putitemintro", Lua_SetItemIntro);
    lua_register(Lua_script, "setitemintro", Lua_SetItemIntro);

    lua_register(Lua_script, "setshowmainrole", Lua_SetShowMR);
    lua_register(Lua_script, "setscreenblendmode", Lua_SetScreenBlendMode);
    lua_register(Lua_script, "playmovie", Lua_PlayMovie);
    lua_register(Lua_script, "resetscene", Lua_ResetScene);

    lua_register(Lua_script, "setteam", Lua_SetTeam);
    lua_register(Lua_script, "getteam", Lua_GetTeam);

    lua_register(Lua_script, "read_mem", Lua_ReadMem);
    lua_register(Lua_script, "write_mem", Lua_WriteMem);

    lua_register(Lua_script, "getrolename", Lua_GetRoleName);
    lua_register(Lua_script, "getitemname", Lua_GetItemName);
    lua_register(Lua_script, "getmagicname", Lua_GetMagicName);
    lua_register(Lua_script, "getsubmapname", Lua_GetSubMapName);

    lua_register(Lua_script, "drawlength", Lua_DrawLengthS);
    lua_register(Lua_script, "getkey", Lua_GetKey);
}

void DestroyScript()
{
    lua_close(Lua_script);
}

void ExecScript(const std::string& filename, const std::string& functionname)
{
    FILE* f = fopen(filename.c_str(), "rb");
    if (!f) return;
    fseek(f, 0, SEEK_END);
    long len = ftell(f);
    fseek(f, 0, SEEK_SET);
    std::string script(len, 0);
    fread(&script[0], 1, len, f);
    fclose(f);
    ExecScriptString(script, functionname);
}

void ExecScriptString(const std::string& script, const std::string& functionname)
{
    std::string s = script;
    // 去BOM
    if (s.size() >= 3 && (uint8_t)s[0] == 0xEF && (uint8_t)s[1] == 0xBB && (uint8_t)s[2] == 0xBF)
    {
        kyslog("Found BOM, replace it to space");
        s[0] = ' '; s[1] = ' '; s[2] = ' ';
    }
    // 转小写
    for (auto& c : s)
        if (c >= 'A' && c <= 'Z') c = c - 'A' + 'a';

    int result = luaL_loadbuffer(Lua_script, s.c_str(), s.size(), "code");
    if (result == 0)
    {
        result = lua_pcall(Lua_script, 0, 0, 0);
        if (!functionname.empty())
        {
            lua_getglobal(Lua_script, functionname.c_str());
            result = lua_pcall(Lua_script, 0, 1, 0);
        }
    }
    if (result != 0)
    {
        kyslog("%s", lua_tostring(Lua_script, -1));
        lua_pop(Lua_script, 1);
    }
}

// 处理50-32指令改写参数
static lua_Integer lua_tointeger_ex(lua_State* L, int pos)
{
    int n = lua_gettop(L);
    lua_Integer result = lua_tointeger(L, pos);
    int actualpos = (pos < 0) ? (n + pos + 1) : pos;
    if (actualpos == p5032pos)
    {
        result = p5032value;
        p5032pos = -100;
    }
    return result;
}

// ---- Lua回调函数实现 ----

int Lua_Blank(lua_State* L)
{
    return 0;
}

int Lua_Pause(lua_State* L)
{
    lua_pushinteger(L, WaitAnyKey());
    return 1;
}

int Lua_GetMousePosition(lua_State* L)
{
    SDL_Event ev;
    SDL_PollEvent(&ev);
    float fx, fy;
    SDL_GetMouseState(&fx, &fy);
    lua_pushinteger(L, (int)fx);
    lua_pushinteger(L, (int)fy);
    return 2;
}

int Lua_ClearButton(lua_State* L)
{
    event.key.key = 0;
    event.button.button = 0;
    return 0;
}

int Lua_CheckButton(lua_State* L)
{
    SDL_PollEvent(&event);
    int t = (event.button.button > 0) ? 1 : 0;
    lua_pushinteger(L, t);
    SDL_Delay(10);
    return 1;
}

int Lua_GetButton(lua_State* L)
{
    lua_pushinteger(L, event.key.key);
    lua_pushinteger(L, event.button.button);
    return 2;
}

int Lua_ExecEvent(lua_State* L)
{
    int n = lua_gettop(L);
    int e = lua_tointeger_ex(L, -n);
    for (int i = 0; i < n - 1; i++)
        x50[0x7100 + i] = lua_tointeger_ex(L, -n + 1 + i);
    CallEvent(e);
    return 0;
}

int Lua_GetTime(lua_State* L)
{
    int t = (int)(SDL_GetTicks() / 1000);
    lua_pushinteger(L, t);
    return 1;
}

int Lua_Clear(lua_State* L)
{
    Redraw();
    return 0;
}

int Lua_OldTalk(lua_State* L)
{
    int talknum = lua_tointeger_ex(L, -3);
    int headnum = lua_tointeger_ex(L, -2);
    int dismode = lua_tointeger_ex(L, -1);
    instruct_1(talknum, headnum, dismode);
    return 0;
}

int Lua_Talk(lua_State* L)
{
    int n = lua_gettop(L);
    int nums[6] = {-1, -2, -2, 0, 0, 0};
    std::string strs[2];
    int inum = 0;
    for (int i = -n; i <= -1; i++)
    {
        if (inum <= 5)
        {
            nums[inum] = lua_tointeger_ex(L, i);
            inum++;
        }
    }
    if (lua_type(L, -n + 1) != LUA_TNUMBER)
        strs[0] = lua_tostring(L, -n + 1);
    if (lua_type(L, -n + 2) != LUA_TNUMBER)
        strs[1] = lua_tostring(L, -n + 2);
    if (nums[3] < 0) nums[3] = abs(nums[3]);
    NewTalk(nums[0], nums[1], nums[2], nums[3], nums[4], nums[5], 0, strs[0], strs[1]);
    return 0;
}

int Lua_GetItem(lua_State* L)
{
    int inum = lua_tointeger_ex(L, -2);
    int amount = lua_tointeger_ex(L, -1);
    instruct_2(inum, amount);
    return 0;
}

int Lua_AddItem(lua_State* L)
{
    int inum = lua_tointeger_ex(L, -2);
    int amount = lua_tointeger_ex(L, -1);
    instruct_32(inum, amount);
    return 0;
}

int Lua_ShowString(lua_State* L)
{
    uint32_t color1 = ColColor(5);
    uint32_t color2 = ColColor(7);
    int n = lua_gettop(L);
    int x = lua_tointeger_ex(L, -n);
    int y = lua_tointeger_ex(L, -n + 1);
    const char* str = lua_tostring(L, -n + 2);
    if (n >= 5)
    {
        color1 = lua_tointeger_ex(L, -n + 3);
        color2 = lua_tointeger_ex(L, -n + 4);
    }
    DrawShadowText(str, x, y, color1, color2);
    UpdateAllScreen();
    return 0;
}

int Lua_ShowStringWithBox(lua_State* L)
{
    int alpha = 0;
    uint32_t color1 = 0, color2 = 0x202020;
    uint32_t incolor = 0, framecolor = ColColor(255);
    int n = lua_gettop(L);
    int x = lua_tointeger_ex(L, -n);
    int y = lua_tointeger_ex(L, -n + 1);
    const char* str = lua_tostring(L, -n + 2);
    if (n >= 4) alpha = lua_tointeger_ex(L, -n + 3);
    if (n >= 6)
    {
        color1 = lua_tointeger_ex(L, -n + 4);
        color2 = lua_tointeger_ex(L, -n + 5);
    }
    if (n >= 7) incolor = lua_tointeger_ex(L, -n + 6);
    if (n >= 8) framecolor = lua_tointeger_ex(L, -n + 7);
    DrawTextFrame(x, y, DrawLength(str), alpha, framecolor, 0);
    DrawShadowText(str, x + 19, y + 3, color1, color2);
    UpdateAllScreen();
    return 0;
}

int Lua_Menu(lua_State* L)
{
    int n = lua_tointeger_ex(L, -5);
    int len = (int)luaL_len(L, -1);
    n = std::min(n, len);
    std::vector<std::string> menuStr(n);
    int maxwidth = 0;
    for (int i = 0; i < n; i++)
    {
        lua_pushinteger(L, i + 1);
        lua_gettable(L, -2);
        const char* p = lua_tostring(L, -1);
        menuStr[i] = p ? p : "";
        int w = DrawLength(menuStr[i].c_str());
        if (w > maxwidth) maxwidth = w;
        lua_pop(L, 1);
    }
    int w = lua_tointeger_ex(L, -2);
    int y = lua_tointeger_ex(L, -3);
    int x = lua_tointeger_ex(L, -4);
    if (w <= 0) w = maxwidth * 10 + 8;
    lua_pushinteger(L, CommonScrollMenu(x, y, w, n - 1, 15, menuStr));
    return 1;
}

int Lua_AskYesOrNo(lua_State* L)
{
    std::string menuStr[2] = {"\xe5\x90\xa6", "\xe6\x98\xaf"}; // 否, 是
    int y = lua_tointeger_ex(L, -2);
    int x = lua_tointeger_ex(L, -1);
    lua_pushinteger(L, CommonMenu2(x, y, 78, menuStr));
    return 1;
}

int Lua_ModifyEvent(lua_State* L)
{
    int n = lua_gettop(L);
    std::vector<int> x(n);
    for (int i = 0; i < n; i++)
        x[i] = lua_tointeger_ex(L, -(n - i));
    if (n >= 13)
        instruct_3(x);
    if (n == 4)
    {
        if (x[0] < 0) x[0] = CurScene;
        if (x[1] < 0) x[1] = CurEvent;
        DData[x[0]][x[1]][x[2]] = x[3];
    }
    return 0;
}

int Lua_UseItem(lua_State* L)
{
    int n = lua_gettop(L);
    int inum = lua_tointeger_ex(L, -1);
    if (n == 3) inum = lua_tointeger_ex(L, -3);
    lua_pushboolean(L, inum == CurItem);
    return 1;
}

int Lua_HaveItemAmount(lua_State* L)
{
    int inum = lua_tointeger_ex(L, -1);
    lua_pushinteger(L, GetItemAmount(inum));
    return 1;
}

int Lua_HaveItemBool(lua_State* L)
{
    int n = lua_gettop(L);
    int inum = lua_tointeger_ex(L, -n);
    lua_pushboolean(L, instruct_18(inum, 1, 0) == 1);
    return 1;
}

int Lua_AnotherGetItem(lua_State* L)
{
    instruct_41(lua_tointeger_ex(L, -3), lua_tointeger_ex(L, -2), lua_tointeger_ex(L, -1));
    return 0;
}

int Lua_CompareProInTeam(lua_State* L)
{
    int n = 0;
    int datalist = lua_tointeger_ex(L, -2);
    int val = lua_tointeger_ex(L, -1);
    for (int i = 0; i < 6; i++)
        if (Rrole[TeamList[i]].Data[datalist] == val) n++;
    lua_pushinteger(L, n);
    return 1;
}

int Lua_AllLeave(lua_State* L) { instruct_59(); return 0; }
int Lua_AskBattle(lua_State* L) { lua_pushboolean(L, instruct_5(1, 0) == 1); return 1; }

int Lua_TryBattle(lua_State* L)
{
    int n = lua_gettop(L);
    int getexp = 1, single = 0;
    int battlenum = lua_tointeger_ex(L, -n);
    if (n >= 2) getexp = lua_tointeger_ex(L, -n + 1);
    if (n >= 3) single = lua_tointeger_ex(L, -n + 2);
    if (ForceBattleWin == 0)
        lua_pushboolean(L, Battle(battlenum, getexp, single));
    else
        lua_pushboolean(L, true);
    return 1;
}

int Lua_AskJoin(lua_State* L) { lua_pushboolean(L, instruct_9(1, 0) == 1); return 1; }
int Lua_Join(lua_State* L) { instruct_10(lua_tointeger_ex(L, -1)); return 0; }
int Lua_AskRest(lua_State* L) { lua_pushboolean(L, instruct_11(1, 0) == 1); return 1; }
int Lua_Rest(lua_State* L) { instruct_12(); return 0; }
int Lua_LightScene(lua_State* L) { instruct_13(); return 0; }
int Lua_DarkScene(lua_State* L) { instruct_14(); return 0; }
int Lua_Dead(lua_State* L) { instruct_15(); return 0; }

int Lua_InTeam(lua_State* L)
{
    lua_pushboolean(L, instruct_16(lua_tointeger_ex(L, -lua_gettop(L)), 1, 0) == 1);
    return 1;
}

int Lua_TeamIsFull(lua_State* L) { lua_pushboolean(L, instruct_20(1, 0) == 1); return 1; }
int Lua_LeaveTeam(lua_State* L) { instruct_21(lua_tointeger_ex(L, -1)); return 0; }

int Lua_LearnMagic(lua_State* L)
{
    int n = lua_gettop(L);
    std::vector<int> x(n);
    for (int i = 0; i < n; i++)
        x[i] = lua_tointeger_ex(L, -(n - i));
    if (n == 2) instruct_33(x[0], x[1], 0);
    if (n == 3) StudyMagic(x[0], 0, x[1], x[2], 0);
    if (n == 4) StudyMagic(x[0], x[1], x[2], x[3], 0);
    return 0;
}

int Lua_OldLearnMagic(lua_State* L)
{
    instruct_33(lua_tointeger_ex(L, -3), lua_tointeger_ex(L, -2), lua_tointeger_ex(L, -1));
    return 0;
}

int Lua_GetMainMapPosition(lua_State* L)
{
    lua_pushinteger(L, My);
    lua_pushinteger(L, Mx);
    return 2;
}

int Lua_SetMainMapPosition(lua_State* L)
{
    Mx = lua_tointeger_ex(L, -1);
    My = lua_tointeger_ex(L, -2);
    return 0;
}

int Lua_GetScenePosition(lua_State* L)
{
    lua_pushinteger(L, Sy);
    lua_pushinteger(L, Sx);
    return 2;
}

int Lua_SetScenePosition(lua_State* L)
{
    Sx = lua_tointeger_ex(L, -1);
    Sy = lua_tointeger_ex(L, -2);
    return 0;
}

int Lua_OldSetScenePosition(lua_State* L)
{
    instruct_19(lua_tointeger_ex(L, -2), lua_tointeger_ex(L, -1));
    return 0;
}

int Lua_GetSceneFace(lua_State* L) { lua_pushinteger(L, SFace); return 1; }
int Lua_SetSceneFace(lua_State* L) { SFace = lua_tointeger_ex(L, -1); return 0; }
int Lua_Delay(lua_State* L) { SDL_Delay(lua_tointeger_ex(L, -1)); return 0; }

int Lua_DrawRect(lua_State* L)
{
    int n = lua_gettop(L);
    std::vector<int> x(n);
    for (int i = 0; i < n; i++)
        x[i] = lua_tointeger_ex(L, -(n - i));
    if (n == 7)
        DrawRectangle(x[0], x[1], x[2], x[3], x[4], x[5], x[6]);
    if (n == 6)
        DrawRectangleWithoutFrame(x[0], x[1], x[2], x[3], x[4], x[5]);
    return 0;
}

int Lua_MemberAmount(lua_State* L)
{
    int n = 0;
    for (int i = 0; i < 6; i++)
        if (TeamList[i] >= 0) n++;
    lua_pushinteger(L, n);
    return 1;
}

int Lua_GetMember(lua_State* L)
{
    int n = lua_tointeger_ex(L, -1);
    lua_pushinteger(L, (n >= 0 && n <= 5) ? TeamList[n] : 0);
    return 1;
}

int Lua_SetMember(lua_State* L)
{
    TeamList[lua_tointeger_ex(L, -1)] = lua_tointeger_ex(L, -2);
    return 0;
}

int Lua_GetGlobalValue(lua_State* L)
{
    int n1 = lua_tointeger_ex(L, -2);
    int n2 = lua_tointeger_ex(L, -1);
    if (n1 >= 0 && n1 <= 20 && n2 >= 0 && n2 <= 14)
        lua_pushinteger(L, Rshop[n1].Data[n2]);
    else
        lua_pushinteger(L, -2);
    return 1;
}

int Lua_SetGlobalValue(lua_State* L)
{
    Rshop[lua_tointeger_ex(L, -2)].Data[lua_tointeger_ex(L, -1)] = lua_tointeger_ex(L, -3);
    return 0;
}

int Lua_GetRolePro(lua_State* L)
{
    lua_pushinteger(L, Rrole[lua_tointeger_ex(L, -2)].Data[lua_tointeger_ex(L, -1)]);
    return 1;
}

// 内部辅助：赋值或字符串写入
static void SetPro(lua_State* L, int* pos)
{
    if (lua_isnumber(L, -3))
        *pos = lua_tointeger_ex(L, -3);
    else if (lua_isstring(L, -3))
    {
        const char* str = lua_tostring(L, -3);
        int len = (int)strlen(str);
        char* p = (char*)pos;
        for (int i = 0; i < len; i++)
            p[i] = str[i];
    }
}

int Lua_SetRolePro(lua_State* L)
{
    SetPro(L, &Rrole[lua_tointeger_ex(L, -2)].Data[lua_tointeger_ex(L, -1)]);
    return 0;
}

int Lua_GetItemPro(lua_State* L)
{
    lua_pushinteger(L, Ritem[lua_tointeger_ex(L, -2)].Data[lua_tointeger_ex(L, -1)]);
    return 1;
}

int Lua_SetItemPro(lua_State* L)
{
    SetPro(L, &Ritem[lua_tointeger_ex(L, -2)].Data[lua_tointeger_ex(L, -1)]);
    return 0;
}

int Lua_SetItemIntro(lua_State* L)
{
    int itemnum = lua_tointeger_ex(L, -2);
    const char* str = lua_tostring(L, -1);
    int len = (int)strlen(str);
    memset(Ritem[itemnum].Introduction, 0, sizeof(Ritem[itemnum].Introduction));
    if (len > 15)
        kyslog("Intro length is too long!");
    else
        memcpy(Ritem[itemnum].Introduction, str, len);
    return 0;
}

int Lua_GetMagicPro(lua_State* L)
{
    lua_pushinteger(L, Rmagic[lua_tointeger_ex(L, -2)].Data[lua_tointeger_ex(L, -1)]);
    return 1;
}

int Lua_SetMagicPro(lua_State* L)
{
    SetPro(L, &Rmagic[lua_tointeger_ex(L, -2)].Data[lua_tointeger_ex(L, -1)]);
    return 0;
}

int Lua_GetScenePro(lua_State* L)
{
    lua_pushinteger(L, Rscene[lua_tointeger_ex(L, -2)].Data[lua_tointeger_ex(L, -1)]);
    return 1;
}

int Lua_SetScenePro(lua_State* L)
{
    SetPro(L, &Rscene[lua_tointeger_ex(L, -2)].Data[lua_tointeger_ex(L, -1)]);
    return 0;
}

int Lua_GetSceneMapPro(lua_State* L)
{
    lua_pushinteger(L, SData[lua_tointeger_ex(L, -4)][lua_tointeger_ex(L, -3)][lua_tointeger_ex(L, -1)][lua_tointeger_ex(L, -2)]);
    return 1;
}

int Lua_SetSceneMapPro(lua_State* L)
{
    SData[lua_tointeger_ex(L, -4)][lua_tointeger_ex(L, -3)][lua_tointeger_ex(L, -1)][lua_tointeger_ex(L, -2)] = lua_tointeger_ex(L, -5);
    return 0;
}

int Lua_OldSetSceneMapPro(lua_State* L)
{
    std::vector<int> list(5);
    for (int i = 0; i < 5; i++)
        list[i] = lua_tointeger_ex(L, i - 5);
    instruct_17(list);
    return 0;
}

int Lua_GetSceneEventPro(lua_State* L)
{
    int snum = lua_tointeger_ex(L, -3);
    int eNum = lua_tointeger_ex(L, -2);
    if (snum == -2) snum = CurScene;
    if (eNum == -2) eNum = CurEvent;
    lua_pushinteger(L, DData[snum][eNum][lua_tointeger_ex(L, -1)]);
    return 1;
}

int Lua_SetSceneEventPro(lua_State* L)
{
    int snum = lua_tointeger_ex(L, -3);
    int eNum = lua_tointeger_ex(L, -2);
    if (snum == -2) snum = CurScene;
    if (eNum == -2) eNum = CurEvent;
    DData[snum][eNum][lua_tointeger_ex(L, -1)] = lua_tointeger_ex(L, -4);
    return 0;
}

int Lua_JudgeSceneEvent(lua_State* L)
{
    int t = 0;
    if (DData[CurScene][lua_tointeger_ex(L, -3)][2 + lua_tointeger_ex(L, -2)] == lua_tointeger_ex(L, -1))
        t = 1;
    lua_pushinteger(L, t);
    return 1;
}

int Lua_PlayMusic(lua_State* L) { instruct_66(lua_tointeger_ex(L, -1)); return 0; }
int Lua_PlayWave(lua_State* L) { instruct_67(lua_tointeger_ex(L, -1)); return 0; }

int Lua_WalkFromTo(lua_State* L)
{
    instruct_30(lua_tointeger_ex(L, -4), lua_tointeger_ex(L, -3), lua_tointeger_ex(L, -2), lua_tointeger_ex(L, -1));
    return 0;
}

int Lua_SceneFromTo(lua_State* L)
{
    instruct_25(lua_tointeger_ex(L, -4), lua_tointeger_ex(L, -3), lua_tointeger_ex(L, -2), lua_tointeger_ex(L, -1));
    return 0;
}

int Lua_PlayAnimation(lua_State* L)
{
    instruct_27(lua_tointeger_ex(L, -3), lua_tointeger_ex(L, -2), lua_tointeger_ex(L, -1));
    return 0;
}

int Lua_GetNameAsString(lua_State* L)
{
    int typenum = lua_tointeger_ex(L, -2);
    int num = lua_tointeger_ex(L, -1);
    const char* p = "";
    switch (typenum)
    {
    case 0: p = Rrole[num].Name; break;
    case 1: p = Ritem[num].Name; break;
    case 2: p = Rscene[num].Name; break;
    case 3: p = Rmagic[num].Name; break;
    }
    lua_pushstring(L, p);
    return 1;
}

int Lua_SetNameAsString(lua_State* L)
{
    int typenum = lua_tointeger_ex(L, -2);
    int num = lua_tointeger_ex(L, -1);
    char* p = nullptr;
    switch (typenum)
    {
    case 0: p = Rrole[num].Name; break;
    case 1: p = Ritem[num].Name; break;
    case 2: p = Rscene[num].Name; break;
    case 3: p = Rmagic[num].Name; break;
    }
    if (p)
    {
        const char* s = lua_tostring(L, -3);
        int len = s ? (int)strlen(s) : 0;
        for (int i = 0; i <= len; i++)
            p[i] = (i < len) ? s[i] : 0;
    }
    return 0;
}

int Lua_ReadTalkAsString(lua_State* L)
{
    int num = lua_tointeger_ex(L, -1);
    std::vector<uint8_t> a;
    ReadTalk(num, a);
    lua_pushstring(L, (const char*)a.data());
    return 1;
}

int Lua_ChangeScene(lua_State* L)
{
    int n = lua_gettop(L);
    CurScene = lua_tointeger_ex(L, -n);
    int x, y;
    if (n == 1)
    {
        x = Rscene[CurScene].EntranceX;
        y = Rscene[CurScene].EntranceY;
    }
    else
    {
        x = lua_tointeger_ex(L, -n + 1);
        y = lua_tointeger_ex(L, -n + 2);
    }
    Cx = x + Cx - Sx;
    Cy = y + Cy - Sy;
    Sx = x;
    Sy = y;
    instruct_14();
    InitialScene();
    DrawScene();
    instruct_13();
    ShowSceneName(CurScene);
    CheckEvent3();
    return 0;
}

int Lua_ShowPicture(lua_State* L)
{
    int n = lua_gettop(L);
    int x = lua_tointeger_ex(L, -2);
    int y = lua_tointeger_ex(L, -1);
    if (n == 4)
    {
        int t = lua_tointeger_ex(L, -4);
        int p = lua_tointeger_ex(L, -3);
        switch (t)
        {
        case 0: DrawMPic(p, x, y); break;
        case 1: case 2: DrawSPic(p, x, y); break;
        case 3: DrawHeadPic(p, x, y); break;
        case 4: DrawEPic(p, x, y); break;
        }
    }
    return 0;
}

int Lua_GetItemList(lua_State* L)
{
    int i = lua_tointeger_ex(L, -1);
    lua_pushinteger(L, RItemList[i].Number);
    lua_pushinteger(L, RItemList[i].Amount);
    return 2;
}

int Lua_GetCurrentScene(lua_State* L) { lua_pushinteger(L, CurScene); return 1; }
int Lua_GetCurrentEvent(lua_State* L) { lua_pushinteger(L, CurEvent); return 1; }

int Lua_GetBattleNumber(lua_State* L)
{
    int n = lua_gettop(L);
    if (n == 0)
        lua_pushinteger(L, x50[28005]);
    else
    {
        int rnum = lua_tointeger_ex(L, -1);
        int t = -1;
        for (int i = 0; i < BRoleAmount; i++)
        {
            if (Brole[i].rnum == rnum)
            {
                t = i;
                break;
            }
        }
        lua_pushinteger(L, t);
    }
    return 1;
}

int Lua_SelectOneAim(lua_State* L)
{
    if (lua_tointeger_ex(L, -1) == 0)
        SelectAim(lua_tointeger_ex(L, -3), lua_tointeger_ex(L, -2));
    lua_pushinteger(L, BField[2][Ax][Ay]);
    return 1;
}

int Lua_GetBattleRolePro(lua_State* L)
{
    lua_pushinteger(L, Brole[lua_tointeger_ex(L, -2)].Data[lua_tointeger_ex(L, -1)]);
    return 1;
}

int Lua_SetBattleRolePro(lua_State* L)
{
    Brole[lua_tointeger_ex(L, -2)].Data[lua_tointeger_ex(L, -1)] = lua_tointeger_ex(L, -3);
    return 0;
}

int Lua_PlayAction(lua_State* L)
{
    int bnum = lua_tointeger_ex(L, -3);
    int mtype = lua_tointeger_ex(L, -2);
    PlayActionAmination(bnum, mtype);
    PlayMagicAmination(bnum, mtype);
    return 0;
}

int Lua_PlayHurtValue(lua_State* L)
{
    ShowHurtValue(lua_tointeger_ex(L, -1));
    return 0;
}

int Lua_SetAminationLayer(lua_State* L)
{
    int x = lua_tointeger_ex(L, -5);
    int y = lua_tointeger_ex(L, -4);
    int w = lua_tointeger_ex(L, -3);
    int h = lua_tointeger_ex(L, -2);
    int t = lua_tointeger_ex(L, -1);
    for (int i1 = x; i1 < x + w; i1++)
        for (int i2 = y; i2 < y + h; i2++)
            BField[4][i1][i2] = t;
    return 0;
}

int Lua_ClearRoleFromBattle(lua_State* L)
{
    Brole[lua_tointeger_ex(L, -1)].Dead = 1;
    return 0;
}

int Lua_AddRoleIntoBattle(lua_State* L)
{
    int bnum = BRoleAmount;
    BRoleAmount++;
    int team = lua_tointeger_ex(L, -4);
    int rnum = lua_tointeger_ex(L, -3);
    int x = lua_tointeger_ex(L, -2);
    int y = lua_tointeger_ex(L, -1);
    Brole[bnum].rnum = rnum;
    Brole[bnum].Team = team;
    Brole[bnum].X = x;
    Brole[bnum].Y = y;
    Brole[bnum].Face = 1;
    Brole[bnum].Dead = 0;
    Brole[bnum].Step = 0;
    Brole[bnum].Acted = 1;
    Brole[bnum].ShowNumber = -1;
    Brole[bnum].ExpGot = 0;
    lua_pushinteger(L, bnum);
    return 1;
}

int Lua_ForceBattleResult(lua_State* L) { BStatus = lua_tointeger_ex(L, -1); return 0; }
int Lua_AskSoftStar(lua_State* L) { instruct_51(); return 0; }

int Lua_WeiShop(lua_State* L)
{
    int n = lua_gettop(L);
    if (n == 0) instruct_64();
    else NewShop(lua_tointeger_ex(L, -1));
    return 0;
}

int Lua_OpenAllScene(lua_State* L) { instruct_54(); return 0; }
int Lua_ShowEthics(lua_State* L) { instruct_52(); return 0; }
int Lua_ShowRepute(lua_State* L) { instruct_53(); return 0; }
int Lua_ChangeMMapMusic(lua_State* L) { instruct_8(lua_tointeger_ex(L, -1)); return 0; }
int Lua_ZeroAllMP(lua_State* L) { instruct_22(); return 0; }
int Lua_SetOneUsePoi(lua_State* L) { instruct_23(lua_tointeger_ex(L, -2), lua_tointeger_ex(L, -1)); return 0; }

int Lua_Add3EventNum(lua_State* L)
{
    instruct_26(lua_tointeger_ex(L, -5), lua_tointeger_ex(L, -4), lua_tointeger_ex(L, -3), lua_tointeger_ex(L, -2), lua_tointeger_ex(L, -1));
    return 0;
}

int Lua_Judge5Item(lua_State* L)
{
    std::vector<int> list(7);
    for (int i = 0; i < 7; i++)
        list[i] = lua_tointeger_ex(L, i - 7);
    int n = instruct_50(list);
    lua_pushboolean(L, n == list[5]);
    return 1;
}

int Lua_JudgeEthics(lua_State* L)
{
    int n = lua_gettop(L);
    lua_pushboolean(L, instruct_28(lua_tointeger_ex(L, -n), lua_tointeger_ex(L, 1 - n), lua_tointeger_ex(L, 2 - n), 1, 0) == 1);
    return 1;
}

int Lua_JudgeAttack(lua_State* L)
{
    int n = lua_gettop(L);
    lua_pushboolean(L, instruct_29(lua_tointeger_ex(L, -n), lua_tointeger_ex(L, 1 - n), lua_tointeger_ex(L, 2 - n), 1, 0) == 1);
    return 1;
}

int Lua_JudgeMoney(lua_State* L)
{
    int n = lua_gettop(L);
    lua_pushboolean(L, instruct_31(lua_tointeger_ex(L, -n), 1, 0) == 1);
    return 1;
}

int Lua_AddAptitude(lua_State* L) { instruct_34(lua_tointeger_ex(L, -2), lua_tointeger_ex(L, -1)); return 0; }

int Lua_SetOneMagic(lua_State* L)
{
    instruct_35(lua_tointeger_ex(L, -4), lua_tointeger_ex(L, -3), lua_tointeger_ex(L, -2), lua_tointeger_ex(L, -1));
    return 0;
}

int Lua_JudgeSexual(lua_State* L)
{
    lua_pushboolean(L, instruct_36(lua_tointeger_ex(L, -lua_gettop(L)), 1, 0) == 1);
    return 1;
}

int Lua_AddEthics(lua_State* L) { instruct_37(lua_tointeger_ex(L, -1)); return 0; }

int Lua_ChangeScenePic(lua_State* L)
{
    instruct_38(lua_tointeger_ex(L, -4), lua_tointeger_ex(L, -3), lua_tointeger_ex(L, -2), lua_tointeger_ex(L, -1));
    return 0;
}

int Lua_OpenScene(lua_State* L) { instruct_39(lua_tointeger_ex(L, -1)); return 0; }
int Lua_JudgeFemaleInTeam(lua_State* L) { lua_pushboolean(L, instruct_42(1, 0) == 1); return 1; }

int Lua_Play2Animation(lua_State* L)
{
    instruct_44(lua_tointeger_ex(L, -6), lua_tointeger_ex(L, -5), lua_tointeger_ex(L, -4),
        lua_tointeger_ex(L, -3), lua_tointeger_ex(L, -2), lua_tointeger_ex(L, -1));
    return 0;
}

int Lua_AddSpeed(lua_State* L) { instruct_45(lua_tointeger_ex(L, -2), lua_tointeger_ex(L, -1)); return 0; }
int Lua_AddMP(lua_State* L) { instruct_46(lua_tointeger_ex(L, -2), lua_tointeger_ex(L, -1)); return 0; }
int Lua_AddAttack(lua_State* L) { instruct_47(lua_tointeger_ex(L, -2), lua_tointeger_ex(L, -1)); return 0; }
int Lua_AddHP(lua_State* L) { instruct_48(lua_tointeger_ex(L, -2), lua_tointeger_ex(L, -1)); return 0; }
int Lua_SetMPPro(lua_State* L) { instruct_49(lua_tointeger_ex(L, -2), lua_tointeger_ex(L, -1)); return 0; }

int Lua_JudgeEventNum(lua_State* L)
{
    int n = lua_gettop(L);
    lua_pushboolean(L, instruct_55(lua_tointeger_ex(L, -n), lua_tointeger_ex(L, 1 - n), 1, 0) == 1);
    return 1;
}

int Lua_AddRepute(lua_State* L) { instruct_56(lua_tointeger_ex(L, -1)); return 0; }
int Lua_BreakStoneGate(lua_State* L) { instruct_57(); return 0; }
int Lua_FightForTop(lua_State* L) { instruct_58(); return 0; }

int Lua_JudgeScenePic(lua_State* L)
{
    int n = lua_gettop(L);
    lua_pushboolean(L, instruct_60(lua_tointeger_ex(L, -n), lua_tointeger_ex(L, 1 - n), lua_tointeger_ex(L, 2 - n), 1, 0) == 1);
    return 1;
}

int Lua_Judge14BooksPlaced(lua_State* L) { lua_pushboolean(L, instruct_61(1, 0) == 1); return 1; }

int Lua_SetSexual(lua_State* L)
{
    instruct_63(lua_tointeger_ex(L, -2), lua_tointeger_ex(L, -1));
    return 0;
}

int Lua_BackHome(lua_State* L)
{
    instruct_62(lua_tointeger_ex(L, -6), lua_tointeger_ex(L, -5), lua_tointeger_ex(L, -4),
        lua_tointeger_ex(L, -3), lua_tointeger_ex(L, -2), lua_tointeger_ex(L, -1));
    return 0;
}

int Lua_EatOneItem(lua_State* L)
{
    int n = lua_gettop(L);
    if (n == 2)
        EatOneItem(lua_tointeger_ex(L, -n), lua_tointeger_ex(L, 1 - n));
    return 0;
}

int Lua_SelectOneTeamMember(lua_State* L)
{
    const char* s = lua_tostring(L, -3);
    lua_pushinteger(L, SelectOneTeamMember(0, 0, s ? s : "", lua_tointeger_ex(L, -2), lua_tointeger_ex(L, -1)));
    return 1;
}

int Lua_SetAttribute(lua_State* L)
{
    SetAttribute(lua_tointeger_ex(L, -5), lua_tointeger_ex(L, -4), lua_tointeger_ex(L, -3),
        lua_tointeger_ex(L, -2), lua_tointeger_ex(L, -1));
    return 0;
}

int Lua_SetRoleFace(lua_State* L) { instruct_40(lua_tointeger_ex(L, -1)); return 0; }

int Lua_EnterNumber(lua_State* L)
{
    lua_pushinteger(L, EnterNumber(lua_tointeger_ex(L, -5), lua_tointeger_ex(L, -4),
        lua_tointeger_ex(L, -3), lua_tointeger_ex(L, -2), lua_tointeger_ex(L, -1)));
    return 1;
}

int Lua_SetMenuEscType(lua_State* L) { MenuEscType = lua_tointeger_ex(L, -1); return 0; }

int Lua_GetBattlePro(lua_State* L)
{
    lua_pushinteger(L, WarStaList[lua_tointeger_ex(L, -2)].Data[lua_tointeger_ex(L, -1)]);
    return 1;
}

int Lua_SetBattlePro(lua_State* L)
{
    WarStaList[lua_tointeger_ex(L, -2)].Data[lua_tointeger_ex(L, -1)] = lua_tointeger_ex(L, -3);
    return 0;
}

int Lua_ShowStatus(lua_State* L)
{
    ShowStatus(lua_tointeger_ex(L, -1));
    UpdateAllScreen();
    return 0;
}

int Lua_ShowSimpleStatus(lua_State* L)
{
    ShowSimpleStatus(lua_tointeger_ex(L, -3), lua_tointeger_ex(L, -2), lua_tointeger_ex(L, -1));
    return 0;
}

int Lua_UpdateAllScreen(lua_State* L) { UpdateAllScreen(); return 0; }

int Lua_ShowAbility(lua_State* L)
{
    ShowAbility(lua_tointeger_ex(L, -1), -1);
    UpdateAllScreen();
    return 0;
}

int Lua_GetScreenSize(lua_State* L)
{
    lua_pushinteger(L, CENTER_X * 2);
    lua_pushinteger(L, CENTER_Y * 2);
    return 2;
}

int Lua_JumpScene(lua_State* L)
{
    JumpScene(lua_tointeger_ex(L, -3), lua_tointeger_ex(L, -2), lua_tointeger_ex(L, -1));
    return 0;
}

int Lua_GetX50(lua_State* L)
{
    lua_pushinteger(L, x50[lua_tointeger_ex(L, -1)]);
    return 1;
}

int Lua_SetX50(lua_State* L)
{
    if (lua_isstring(L, 2))
    {
        const char* str = lua_tostring(L, 2);
        char* p = (char*)&x50[lua_tointeger(L, 1)];
        int len = (int)strlen(str);
        for (int i = 0; i < len; i++)
            p[i] = str[i];
    }
    else
        x50[lua_tointeger(L, 1)] = lua_tointeger(L, 2);
    return 0;
}

int Lua_ShowTitle(lua_State* L)
{
    int n = lua_gettop(L);
    int talknum = lua_tointeger_ex(L, -n);
    std::string str;
    if (!lua_isnumber(L, -n))
        str = lua_tostring(L, -n);
    int color = 1;
    if (n > 1)
        color = lua_tointeger_ex(L, -1);
    NewTalk(0, talknum, -1, 2, 1, color, 0, str);
    return 0;
}

int Lua_CheckJumpFlag(lua_State* L)
{
    lua_pushboolean(L, instruct_36(256, 1, 0) == 1);
    return 1;
}

int Lua_ExitScript(lua_State* L)
{
    lua_pushstring(L, "exit()");
    lua_error(L);
    return 1;
}

int Lua_AddRoleProWithHint(lua_State* L)
{
    int n = lua_gettop(L);
    std::string str;
    if (n >= 4)
        str = lua_tostring(L, -n + 3);
    AddRoleProWithHint(lua_tointeger_ex(L, -n), lua_tointeger_ex(L, -n + 1), lua_tointeger_ex(L, -n + 2), str);
    return 0;
}

int Lua_ColColor(lua_State* L)
{
    lua_pushinteger(L, ColColor(lua_tointeger_ex(L, -1)));
    return 1;
}

int Lua_SetBattleName(lua_State* L)
{
    BattleNames[lua_tointeger_ex(L, -2)] = lua_tostring(L, -1);
    return 0;
}

int Lua_SetShowMR(lua_State* L)
{
    ShowMR = (lua_tointeger_ex(L, -1) != 0);
    return 0;
}

int Lua_SetScreenBlendMode(lua_State* L)
{
    ScreenBlendMode = lua_tointeger_ex(L, -1);
    return 0;
}

int Lua_PlayMovie(lua_State* L)
{
    DrawRectangleWithoutFrame(0, 0, CENTER_X * 2, CENTER_Y * 2, 0, 0);
    if (PlayMovie(lua_tostring(L, -1)))
    {
        CleanKeyValue();
        WaitAnyKey();
    }
    Redraw();
    return 0;
}

int Lua_ResetScene(lua_State* L)
{
    memcpy(Rscene, Rscene0, sizeof(TScene) * 1002);
    ReSetEntrance();
    return 0;
}

int Lua_SetTeam(lua_State* L)
{
    TeamList[lua_tointeger_ex(L, -2)] = lua_tointeger_ex(L, -1);
    return 0;
}

int Lua_GetTeam(lua_State* L)
{
    lua_pushnumber(L, TeamList[lua_tointeger_ex(L, -1)]);
    return 1;
}

int Lua_ReadMem(lua_State* L)
{
    int x = lua_tointeger_ex(L, -1);
    instruct_50e(26, 0, 0, x % 65536, x / 65536, 9999, 0);
    lua_pushnumber(L, x50[9999]);
    return 1;
}

int Lua_WriteMem(lua_State* L)
{
    int x = lua_tointeger_ex(L, -2);
    x50[9999] = lua_tointeger_ex(L, -1);
    instruct_50e(25, 1, 0, x % 65536, x / 65536, 9999, 0);
    return 0;
}

int Lua_GetRoleName(lua_State* L) { lua_pushstring(L, Rrole[lua_tointeger_ex(L, -1)].Name); return 1; }
int Lua_GetItemName(lua_State* L) { lua_pushstring(L, Ritem[lua_tointeger_ex(L, -1)].Name); return 1; }
int Lua_GetMagicName(lua_State* L) { lua_pushstring(L, Rmagic[lua_tointeger_ex(L, -1)].Name); return 1; }
int Lua_GetSubMapName(lua_State* L) { lua_pushstring(L, Rscene[lua_tointeger_ex(L, -1)].Name); return 1; }

int Lua_DrawLengthS(lua_State* L)
{
    const char* str = lua_tostring(L, -1);
    lua_pushinteger(L, DrawLength(str));
    return 1;
}

int Lua_GetKey(lua_State* L)
{
    lua_pushinteger(L, WaitAnyKey());
    return 1;
}
