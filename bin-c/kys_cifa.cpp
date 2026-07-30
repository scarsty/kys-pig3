// kys_cifa.cpp - Cifa script interface

#include "kys_cifa.h"
#include "kys_battle.h"
#include "kys_draw.h"
#include "kys_engine.h"
#include "kys_event.h"
#include "kys_main.h"
#include "kys_script.h"

#include "Cifa.h"

#include <SDL3/SDL.h>
#include <algorithm>
#include <cstdlib>
#include <cstdint>
#include <cstdio>
#include <cstring>
#include <ctime>
#include <string>
#include <unordered_map>
#include <vector>

using cifa::Object;
using cifa::ObjectVector;

int cifa_arg_int(ObjectVector& args, size_t index, int defaultValue = 0)
{
    if (index >= args.size())
    {
        return defaultValue;
    }
    if (args[index].isType<std::string>())
    {
        const std::string text = args[index].toString();
        char* end = nullptr;
        long value = strtol(text.c_str(), &end, 10);
        return end != text.c_str() ? (int)value : 0;
    }
    return args[index].toInt();
}

std::string cifa_arg_string(ObjectVector& args, size_t index, const std::string& defaultValue = "")
{
    return index < args.size() ? args[index].toString() : defaultValue;
}

Object cifa_bool(bool value)
{
    return Object(value ? 1 : 0);
}

Object cifa_array(std::initializer_list<Object> values)
{
    return Object(std::vector<Object>(values));
}

std::vector<std::string> cifa_string_array(const Object& object)
{
    std::vector<std::string> result;
    if (!object.isType<std::vector<Object>>())
    {
        return result;
    }
    const auto& values = object.ref<std::vector<Object>>();
    result.reserve(values.size());
    for (const auto& value : values)
    {
        result.push_back(value.hasValue() ? value.toString() : "");
    }
    return result;
}

void cifa_set_pro(ObjectVector& args, int* pos)
{
    if (args.empty())
    {
        return;
    }
    if (args[0].isType<std::string>())
    {
        std::string str = args[0].toString();
        char* p = (char*)pos;
        memcpy(p, str.data(), str.size());
        return;
    }
    *pos = args[0].toInt();
}

void RegisterCifaFunctions(cifa::Cifa& c)
{
    auto R = [&](const char* name, cifa::Cifa::func_type f)
    {
        c.register_function(name, f);
    };
    auto R50 = [&](const char* name, int code)
    {
        R(name, [code](ObjectVector& args) -> Object {
            int values[6] = {};
            for (size_t i = 0; i < args.size() && i < 6; i++)
                values[i] = cifa_arg_int(args, i);
            const int result = instruct_50e(code, values[0], values[1], values[2], values[3], values[4], values[5]);
            return cifa_bool(result == values[4]);
        });
    };

    R("clear", [](ObjectVector&) -> Object { Redraw(); return Object(); });
    R("instruct_0", [](ObjectVector&) -> Object { Redraw(); return Object(); });
    R("pause", [](ObjectVector&) -> Object { return Object(WaitAnyKey()); });
    R("getkey", [](ObjectVector&) -> Object { return Object(WaitAnyKey()); });
    R("gettime", [](ObjectVector&) -> Object { return Object((int)(SDL_GetTicks() / 1000)); });
    R("time", [](ObjectVector&) -> Object { return Object((int)time(nullptr)); });
    R("randomseed", [](ObjectVector& args) -> Object { srand((unsigned int)cifa_arg_int(args, 0)); return Object(); });
    R("random", [](ObjectVector& args) -> Object { int minValue = 1; int maxValue = RAND_MAX; if (args.size() == 1) { maxValue = cifa_arg_int(args, 0); } if (args.size() >= 2) { minValue = cifa_arg_int(args, 0); maxValue = cifa_arg_int(args, 1); } if (maxValue < minValue) std::swap(minValue, maxValue); return Object(minValue + rand() % (maxValue - minValue + 1)); });
    R("delay", [](ObjectVector& args) -> Object { SDL_Delay(cifa_arg_int(args, 0)); return Object(); });
    R("clearbutton", [](ObjectVector&) -> Object { event.key.key = 0; event.button.button = 0; return Object(); });
    R("checkbutton", [](ObjectVector&) -> Object { SDL_PollEvent(&event); int t = (event.button.button > 0) ? 1 : 0; SDL_Delay(10); return Object(t); });
    R("getbutton", [](ObjectVector&) -> Object { return cifa_array({ Object((int)event.key.key), Object((int)event.button.button) }); });
    R("getmouseposition", [](ObjectVector&) -> Object { SDL_Event ev; SDL_PollEvent(&ev); float x = 0, y = 0; SDL_GetMouseState(&x, &y); return cifa_array({ Object((int)x), Object((int)y) }); });
    R("getscreen", [](ObjectVector&) -> Object { return cifa_array({ Object(CENTER_X * 2), Object(CENTER_Y * 2) }); });
    R("getscreensize", [](ObjectVector&) -> Object { return cifa_array({ Object(CENTER_X * 2), Object(CENTER_Y * 2) }); });
    R("getcurrentscene", [](ObjectVector&) -> Object { return Object(CurScene); });
    R("getcurrentevent", [](ObjectVector&) -> Object { return Object(CurEvent); });

    R("talk", [](ObjectVector& args) -> Object {
        int nums[6] = { -1, -2, -2, 0, 0, 0 };
        std::string strs[2];
        for (size_t i = 0; i < args.size() && i < 6; i++)
        {
            nums[i] = cifa_arg_int(args, i);
        }
        if (args.size() >= 2 && args[1].isType<std::string>()) strs[0] = args[1].toString();
        if (args.size() >= 3 && args[2].isType<std::string>()) strs[1] = args[2].toString();
        if (nums[3] < 0) nums[3] = abs(nums[3]);
        NewTalk(nums[0], nums[1], nums[2], nums[3], nums[4], nums[5], 0, strs[0], strs[1]);
        return Object();
    });
    R("instruct_1", [](ObjectVector& args) -> Object { instruct_1(cifa_arg_int(args, 0), cifa_arg_int(args, 1), cifa_arg_int(args, 2)); return Object(); });
    R("showstring", [](ObjectVector& args) -> Object { DrawShadowText(cifa_arg_string(args, 2), cifa_arg_int(args, 0), cifa_arg_int(args, 1), args.size() >= 5 ? cifa_arg_int(args, 3) : ColColor(5), args.size() >= 5 ? cifa_arg_int(args, 4) : ColColor(7)); UpdateAllScreen(); return Object(); });
    R("showstringwithbox", [](ObjectVector& args) -> Object { std::string str = cifa_arg_string(args, 2); DrawTextFrame(cifa_arg_int(args, 0), cifa_arg_int(args, 1), DrawLength(str), args.size() >= 4 ? cifa_arg_int(args, 3) : 255, args.size() >= 8 ? cifa_arg_int(args, 7) : ColColor(255), 0); DrawShadowText(str, cifa_arg_int(args, 0) + 19, cifa_arg_int(args, 1) + 3, args.size() >= 6 ? cifa_arg_int(args, 4) : 0, args.size() >= 6 ? cifa_arg_int(args, 5) : 0x202020); UpdateAllScreen(); return Object(); });
    R("showtitle", [](ObjectVector& args) -> Object { std::string str; int talknum = cifa_arg_int(args, 0); if (!args.empty() && args[0].isType<std::string>()) str = args[0].toString(); NewTalk(0, talknum, -1, 2, 1, cifa_arg_int(args, 1, 1), 0, str); return Object(); });
    R("menu", [](ObjectVector& args) -> Object { int n = cifa_arg_int(args, 0); std::vector<std::string> menuStr = args.size() >= 5 ? cifa_string_array(args[4]) : std::vector<std::string>(); n = std::min(n, (int)menuStr.size()); if (n < 0) n = 0; menuStr.resize(n); int maxwidth = 0; for (const auto& s : menuStr) maxwidth = std::max(maxwidth, DrawLength(s.c_str())); int w = cifa_arg_int(args, 3); if (w <= 0) w = maxwidth * 10 + 8; return Object(CommonScrollMenu(cifa_arg_int(args, 1), cifa_arg_int(args, 2), w, n - 1, 15, menuStr)); });
    R("askyesorno", [](ObjectVector& args) -> Object { std::string menuStr[2] = { "否", "是" }; return Object(CommonMenu2(cifa_arg_int(args, 1), cifa_arg_int(args, 0), 78, menuStr)); });
    R("enternumber", [](ObjectVector& args) -> Object { if (args.empty()) return Object(EnterNumber(-32768, 32767, CENTER_X - 90, CENTER_Y - 90)); return Object(EnterNumber(cifa_arg_int(args, 0), cifa_arg_int(args, 1), cifa_arg_int(args, 2), cifa_arg_int(args, 3), cifa_arg_int(args, 4))); });
    R("showspecialtalk", [](ObjectVector& args) -> Object { int display = cifa_arg_int(args, 3); NewTalk(cifa_arg_int(args, 0), cifa_arg_int(args, 1), cifa_arg_int(args, 2), display % 100, (display % 100) / 10, display / 100, 0); return Object(); });
    R("digging", [](ObjectVector& args) -> Object { return Object(Digging(cifa_arg_int(args, 0), cifa_arg_int(args, 1), cifa_arg_int(args, 2), cifa_arg_int(args, 3))); });
    R("showstarlist", [](ObjectVector&) -> Object { ShowStarList(); return Object(); });
    R("getstarstate", [](ObjectVector& args) -> Object { return Object(GetStarState(cifa_arg_int(args, 0))); });
    R("setstarstate", [](ObjectVector& args) -> Object { SetStarState(cifa_arg_int(args, 0), cifa_arg_int(args, 1)); return Object(); });
    R("showteammatelist", [](ObjectVector&) -> Object { NewTeammateList(); return Object(); });
    R("changeitem", [](ObjectVector& args) -> Object { int amount = cifa_arg_int(args, 1); if (cifa_arg_int(args, 3) == 1) amount = -amount; if (cifa_arg_int(args, 2) == 0) instruct_2(cifa_arg_int(args, 0), amount); else instruct_32(cifa_arg_int(args, 0), amount); return Object(); });
    R("spellpicture", [](ObjectVector& args) -> Object { return cifa_bool(SpellPicture(cifa_arg_int(args, 0), cifa_arg_int(args, 1))); });
    R("rearrangeitem", [](ObjectVector& args) -> Object { ReArrangeItem(cifa_arg_int(args, 0, 1)); return Object(); });
    R("showmap", [](ObjectVector&) -> Object { ShowMap(); return Object(); });
    R("showteammate", [](ObjectVector& args) -> Object { ShowTeamMate(cifa_arg_int(args, 0), cifa_arg_int(args, 1), cifa_arg_int(args, 2)); return Object(); });
    R("lamp", [](ObjectVector& args) -> Object { return cifa_bool(Lamp(cifa_arg_int(args, 0), cifa_arg_int(args, 1), cifa_arg_int(args, 2), cifa_arg_int(args, 3))); });
    R("roleending", [](ObjectVector& args) -> Object { RoleEnding(cifa_arg_int(args, 0), cifa_arg_int(args, 1), cifa_arg_int(args, 2)); return Object(); });
    R("missionlist", [](ObjectVector& args) -> Object { MissionList(cifa_arg_int(args, 0)); return Object(); });
    R("setmissionstate", [](ObjectVector& args) -> Object { SetMissionState(cifa_arg_int(args, 0), cifa_arg_int(args, 1)); return Object(); });
    R("woodman", [](ObjectVector& args) -> Object { return cifa_bool(WoodMan(cifa_arg_int(args, 0))); });
    R("booklist", [](ObjectVector&) -> Object { BookList(); return Object(); });
    R("getstaramount", [](ObjectVector&) -> Object { return Object(GetStarAmount()); });
    R("dancerafter90s", [](ObjectVector&) -> Object { return Object(DancerAfter90S()); });
    R("newshop", [](ObjectVector& args) -> Object { NewShop(cifa_arg_int(args, 0)); return Object(); });

    R("giveitem", [](ObjectVector& args) -> Object { instruct_2(cifa_arg_int(args, 0), cifa_arg_int(args, 1)); return Object(); });
    R("getitem", [](ObjectVector& args) -> Object { return Object(Ritem[cifa_arg_int(args, 0)].Data[cifa_arg_int(args, 1)]); });
    R("setitem", [](ObjectVector& args) -> Object { Ritem[cifa_arg_int(args, 0)].Data[cifa_arg_int(args, 1)] = cifa_arg_int(args, 2); return Object(); });
    R("getrole", [](ObjectVector& args) -> Object { return Object(Rrole[cifa_arg_int(args, 0)].Data[cifa_arg_int(args, 1)]); });
    R("setrole", [](ObjectVector& args) -> Object { Rrole[cifa_arg_int(args, 0)].Data[cifa_arg_int(args, 1)] = cifa_arg_int(args, 2); return Object(); });
    R("getsubmapinfo", [](ObjectVector& args) -> Object { return Object(Rscene[cifa_arg_int(args, 0)].Data[cifa_arg_int(args, 1)]); });
    R("setsubmapinfo", [](ObjectVector& args) -> Object { Rscene[cifa_arg_int(args, 0)].Data[cifa_arg_int(args, 1)] = cifa_arg_int(args, 2); if (cifa_arg_int(args, 1) >= 10 && cifa_arg_int(args, 1) < 14) ReSetEntrance(); return Object(); });
    R("getmagic", [](ObjectVector& args) -> Object { return Object(Rmagic[cifa_arg_int(args, 0)].Data[cifa_arg_int(args, 1)]); });
    R("setmagic", [](ObjectVector& args) -> Object { Rmagic[cifa_arg_int(args, 0)].Data[cifa_arg_int(args, 1)] = cifa_arg_int(args, 2); return Object(); });
    R("getshop", [](ObjectVector& args) -> Object { return Object(RShop[cifa_arg_int(args, 0)].Data[cifa_arg_int(args, 1)]); });
    R("setshop", [](ObjectVector& args) -> Object { RShop[cifa_arg_int(args, 0)].Data[cifa_arg_int(args, 1)] = cifa_arg_int(args, 2); return Object(); });
    R("getitemamount", [](ObjectVector& args) -> Object { return Object(GetItemAmount(cifa_arg_int(args, 0))); });
    R("instruct_2", [](ObjectVector& args) -> Object { instruct_2(cifa_arg_int(args, 0), cifa_arg_int(args, 1)); return Object(); });
    R("additem", [](ObjectVector& args) -> Object { instruct_2(cifa_arg_int(args, 0), cifa_arg_int(args, 1)); return Object(); });
    R("additemwithouthint", [](ObjectVector& args) -> Object { instruct_32(cifa_arg_int(args, 0), cifa_arg_int(args, 1)); return Object(); });
    R("instruct_32", [](ObjectVector& args) -> Object { instruct_32(cifa_arg_int(args, 0), cifa_arg_int(args, 1)); return Object(); });
    R("haveitemamount", [](ObjectVector& args) -> Object { return Object(GetItemAmount(cifa_arg_int(args, 0))); });
    R("haveitem", [](ObjectVector& args) -> Object { return cifa_bool(instruct_18(cifa_arg_int(args, 0), 1, 0) == 1); });
    R("instruct_18", [](ObjectVector& args) -> Object { return cifa_bool(instruct_18(cifa_arg_int(args, 0), 1, 0) == 1); });
    R("instruct_43", [](ObjectVector& args) -> Object { return cifa_bool(instruct_18(cifa_arg_int(args, 0), 1, 0) == 1); });
    R("useitem", [](ObjectVector& args) -> Object { int inum = args.size() == 3 ? cifa_arg_int(args, 0) : cifa_arg_int(args, args.empty() ? 0 : args.size() - 1); return cifa_bool(inum == CurItem); });
    R("instruct_4", [](ObjectVector& args) -> Object { int inum = args.size() == 3 ? cifa_arg_int(args, 0) : cifa_arg_int(args, args.empty() ? 0 : args.size() - 1); return cifa_bool(inum == CurItem); });
    R("getitemlist", [](ObjectVector& args) -> Object { int i = cifa_arg_int(args, 0); return cifa_array({ Object(RItemList[i].Number), Object(RItemList[i].Amount) }); });
    R("anothergetitem", [](ObjectVector& args) -> Object { instruct_41(cifa_arg_int(args, 0), cifa_arg_int(args, 1), cifa_arg_int(args, 2)); return Object(); });
    R("instruct_41", [](ObjectVector& args) -> Object { instruct_41(cifa_arg_int(args, 0), cifa_arg_int(args, 1), cifa_arg_int(args, 2)); return Object(); });
    R("npcgetitem", [](ObjectVector& args) -> Object { instruct_41(cifa_arg_int(args, 0), cifa_arg_int(args, 1), cifa_arg_int(args, 2)); return Object(); });
    R("setitemintro", [](ObjectVector& args) -> Object { int itemnum = cifa_arg_int(args, 0); std::string str = cifa_arg_string(args, 1); memset(Ritem[itemnum].Introduction, 0, sizeof(Ritem[itemnum].Introduction)); if (str.size() > 15) kyslog("Intro length is too long!"); else memcpy(Ritem[itemnum].Introduction, str.data(), str.size()); return Object(); });

    R("modifyevent", [](ObjectVector& args) -> Object { std::vector<int> x; for (auto& arg : args) x.push_back(arg.toInt()); if (x.size() >= 13) instruct_3(x); if (x.size() == 4) { if (x[0] < 0) x[0] = CurScene; if (x[1] < 0) x[1] = CurEvent; DData[x[0]][x[1]][x[2]] = x[3]; } return Object(); });
    R("instruct_3", [](ObjectVector& args) -> Object { std::vector<int> x; for (auto& arg : args) x.push_back(arg.toInt()); instruct_3(x); return Object(); });
    R("instruct_17", [](ObjectVector& args) -> Object { std::vector<int> x(5); for (size_t i = 0; i < 5 && i < args.size(); i++) x[i] = cifa_arg_int(args, i); instruct_17(x); return Object(); });
    R("setscenemap", [](ObjectVector& args) -> Object { std::vector<int> x(5); for (size_t i = 0; i < 5 && i < args.size(); i++) x[i] = cifa_arg_int(args, i); instruct_17(x); return Object(); });
    R("setscenemappro2", [](ObjectVector& args) -> Object { std::vector<int> x(5); for (size_t i = 0; i < 5 && i < args.size(); i++) x[i] = cifa_arg_int(args, i); instruct_17(x); return Object(); });
    R("execevent", [](ObjectVector& args) -> Object { if (args.empty()) return Object(); int eventNum = args[0].toInt(); for (size_t i = 1; i < args.size(); i++) x50[0x7100 + (int)i - 1] = args[i].toInt(); CallEvent(eventNum); return Object(); });
    R("add3eventnum", [](ObjectVector& args) -> Object { instruct_26(cifa_arg_int(args, 0), cifa_arg_int(args, 1), cifa_arg_int(args, 2), cifa_arg_int(args, 3), cifa_arg_int(args, 4)); return Object(); });
    R("instruct_26", [](ObjectVector& args) -> Object { instruct_26(cifa_arg_int(args, 0), cifa_arg_int(args, 1), cifa_arg_int(args, 2), cifa_arg_int(args, 3), cifa_arg_int(args, 4)); return Object(); });

    R("askbattle", [](ObjectVector&) -> Object { return cifa_bool(instruct_5(1, 0) == 1); });
    R("instruct_5", [](ObjectVector&) -> Object { return cifa_bool(instruct_5(1, 0) == 1); });
    R("trybattle", [](ObjectVector& args) -> Object { bool result = ForceBattleWin != 0 || Battle(cifa_arg_int(args, 0), cifa_arg_int(args, 1, 1), cifa_arg_int(args, 2, 0)); return cifa_bool(result); });
    R("instruct_6", [](ObjectVector& args) -> Object { bool result = ForceBattleWin != 0 || Battle(cifa_arg_int(args, 0), cifa_arg_int(args, 1, 1), cifa_arg_int(args, 2, 0)); return cifa_bool(result); });
    R("askjoin", [](ObjectVector&) -> Object { return cifa_bool(instruct_9(1, 0) == 1); });
    R("instruct_9", [](ObjectVector&) -> Object { return cifa_bool(instruct_9(1, 0) == 1); });
    R("askrest", [](ObjectVector&) -> Object { return cifa_bool(instruct_11(1, 0) == 1); });
    R("instruct_11", [](ObjectVector&) -> Object { return cifa_bool(instruct_11(1, 0) == 1); });
    R("join", [](ObjectVector& args) -> Object { instruct_10(cifa_arg_int(args, 0)); return Object(); });
    R("instruct_10", [](ObjectVector& args) -> Object { instruct_10(cifa_arg_int(args, 0)); return Object(); });
    R("leave", [](ObjectVector& args) -> Object { instruct_21(cifa_arg_int(args, 0)); return Object(); });
    R("leaveteam", [](ObjectVector& args) -> Object { instruct_21(cifa_arg_int(args, 0)); return Object(); });
    R("instruct_21", [](ObjectVector& args) -> Object { instruct_21(cifa_arg_int(args, 0)); return Object(); });
    R("allleave", [](ObjectVector&) -> Object { instruct_59(); return Object(); });
    R("instruct_59", [](ObjectVector&) -> Object { instruct_59(); return Object(); });
    R("teamisfull", [](ObjectVector&) -> Object { return cifa_bool(instruct_20(1, 0) == 1); });
    R("instruct_20", [](ObjectVector&) -> Object { return cifa_bool(instruct_20(1, 0) == 1); });
    R("inteam", [](ObjectVector& args) -> Object { return cifa_bool(instruct_16(cifa_arg_int(args, 0), 1, 0) == 1); });
    R("instruct_16", [](ObjectVector& args) -> Object { return cifa_bool(instruct_16(cifa_arg_int(args, 0), 1, 0) == 1); });
    R("rest", [](ObjectVector&) -> Object { instruct_12(); return Object(); });
    R("instruct_12", [](ObjectVector&) -> Object { instruct_12(); return Object(); });
    R("lightscene", [](ObjectVector&) -> Object { instruct_13(); return Object(); });
    R("instruct_13", [](ObjectVector&) -> Object { instruct_13(); return Object(); });
    R("darkscene", [](ObjectVector&) -> Object { instruct_14(); return Object(); });
    R("instruct_14", [](ObjectVector&) -> Object { instruct_14(); return Object(); });
    R("dead", [](ObjectVector&) -> Object { instruct_15(); return Object(); });
    R("instruct_15", [](ObjectVector&) -> Object { instruct_15(); return Object(); });
    R("asksoftstar", [](ObjectVector&) -> Object { instruct_51(); return Object(); });
    R("instruct_51", [](ObjectVector&) -> Object { instruct_51(); return Object(); });
    R("instruct_7", [](ObjectVector&) -> Object { return Object(); });
    R("instruct_24", [](ObjectVector&) -> Object { return Object(); });
    R("instruct_65", [](ObjectVector&) -> Object { return Object(); });

    R("getrolepro", [](ObjectVector& args) -> Object { return Object(Rrole[cifa_arg_int(args, 0)].Data[cifa_arg_int(args, 1)]); });
    R("setrolepro", [](ObjectVector& args) -> Object { cifa_set_pro(args, &Rrole[cifa_arg_int(args, 1)].Data[cifa_arg_int(args, 2)]); return Object(); });
    R("getitempro", [](ObjectVector& args) -> Object { return Object(Ritem[cifa_arg_int(args, 0)].Data[cifa_arg_int(args, 1)]); });
    R("setitempro", [](ObjectVector& args) -> Object { cifa_set_pro(args, &Ritem[cifa_arg_int(args, 1)].Data[cifa_arg_int(args, 2)]); return Object(); });
    R("getmagicpro", [](ObjectVector& args) -> Object { return Object(Rmagic[cifa_arg_int(args, 0)].Data[cifa_arg_int(args, 1)]); });
    R("setmagicpro", [](ObjectVector& args) -> Object { cifa_set_pro(args, &Rmagic[cifa_arg_int(args, 1)].Data[cifa_arg_int(args, 2)]); return Object(); });
    R("getscenepro", [](ObjectVector& args) -> Object { return Object(Rscene[cifa_arg_int(args, 0)].Data[cifa_arg_int(args, 1)]); });
    R("setscenepro", [](ObjectVector& args) -> Object { cifa_set_pro(args, &Rscene[cifa_arg_int(args, 1)].Data[cifa_arg_int(args, 2)]); return Object(); });
    R("getsceneeventpro", [](ObjectVector& args) -> Object { int snum = cifa_arg_int(args, 0); int eventNum = cifa_arg_int(args, 1); if (snum == -2) snum = CurScene; if (eventNum == -2) eventNum = CurEvent; return Object(DData[snum][eventNum][cifa_arg_int(args, 2)]); });
    R("setsceneeventpro", [](ObjectVector& args) -> Object { int snum = cifa_arg_int(args, 1); int eventNum = cifa_arg_int(args, 2); if (snum == -2) snum = CurScene; if (eventNum == -2) eventNum = CurEvent; DData[snum][eventNum][cifa_arg_int(args, 3)] = cifa_arg_int(args, 0); return Object(); });
    R("getscenemappro", [](ObjectVector& args) -> Object { return Object(SData[cifa_arg_int(args, 0)][cifa_arg_int(args, 1)][cifa_arg_int(args, 3)][cifa_arg_int(args, 2)]); });
    R("setscenemappro", [](ObjectVector& args) -> Object { SData[cifa_arg_int(args, 1)][cifa_arg_int(args, 2)][cifa_arg_int(args, 4)][cifa_arg_int(args, 3)] = cifa_arg_int(args, 0); return Object(); });
    R("getd", [](ObjectVector& args) -> Object { return Object(DData[cifa_arg_int(args, 0)][cifa_arg_int(args, 1)][cifa_arg_int(args, 2)]); });
    R("setd", [](ObjectVector& args) -> Object { int scene = cifa_arg_int(args, 0); DData[scene][cifa_arg_int(args, 1)][cifa_arg_int(args, 2)] = cifa_arg_int(args, 3); if (scene == CurScene) NeedRefreshScene = 1; return Object(); });
    R("gets", [](ObjectVector& args) -> Object { return Object(SData[cifa_arg_int(args, 0)][cifa_arg_int(args, 1)][cifa_arg_int(args, 3)][cifa_arg_int(args, 2)]); });
    R("sets", [](ObjectVector& args) -> Object { int scene = cifa_arg_int(args, 0); SData[scene][cifa_arg_int(args, 1)][cifa_arg_int(args, 3)][cifa_arg_int(args, 2)] = cifa_arg_int(args, 4); if (scene == CurScene) NeedRefreshScene = 1; return Object(); });
    R("getbattlepro", [](ObjectVector& args) -> Object { return Object(WarStaList[cifa_arg_int(args, 0)].Data[cifa_arg_int(args, 1)]); });
    R("setbattlepro", [](ObjectVector& args) -> Object { WarStaList[cifa_arg_int(args, 1)].Data[cifa_arg_int(args, 2)] = cifa_arg_int(args, 0); return Object(); });
    R("getbattlerolepro", [](ObjectVector& args) -> Object { return Object(Brole[cifa_arg_int(args, 0)].Data[cifa_arg_int(args, 1)]); });
    R("setbattlerolepro", [](ObjectVector& args) -> Object { Brole[cifa_arg_int(args, 1)].Data[cifa_arg_int(args, 2)] = cifa_arg_int(args, 0); return Object(); });
    R("getglobalvalue", [](ObjectVector& args) -> Object { int n1 = cifa_arg_int(args, 0); int n2 = cifa_arg_int(args, 1); return Object((n1 >= 0 && n1 <= 20 && n2 >= 0 && n2 <= 14) ? RShop[n1].Data[n2] : -2); });
    R("setglobalvalue", [](ObjectVector& args) -> Object { RShop[cifa_arg_int(args, 1)].Data[cifa_arg_int(args, 2)] = cifa_arg_int(args, 0); return Object(); });

    R("getnameasstring", [](ObjectVector& args) -> Object { int type = cifa_arg_int(args, 0); int num = cifa_arg_int(args, 1); const char* p = ""; switch (type) { case 0: p = Rrole[num].Name; break; case 1: p = Ritem[num].Name; break; case 2: p = Rscene[num].Name; break; case 3: p = Rmagic[num].Name; break; } return Object(std::string(p)); });
    R("setnameasstring", [](ObjectVector& args) -> Object { std::string s = cifa_arg_string(args, 0); int type = cifa_arg_int(args, 1); int num = cifa_arg_int(args, 2); char* p = nullptr; switch (type) { case 0: p = Rrole[num].Name; break; case 1: p = Ritem[num].Name; break; case 2: p = Rscene[num].Name; break; case 3: p = Rmagic[num].Name; break; } if (p) { memcpy(p, s.data(), s.size()); p[s.size()] = 0; } return Object(); });
    R("readtalkasstring", [](ObjectVector& args) -> Object { std::vector<uint8_t> data; ReadTalk(cifa_arg_int(args, 0), data); return Object(std::string((const char*)data.data())); });
    R("getrolename", [](ObjectVector& args) -> Object { return Object(std::string(Rrole[cifa_arg_int(args, 0)].Name)); });
    R("getitemname", [](ObjectVector& args) -> Object { return Object(std::string(Ritem[cifa_arg_int(args, 0)].Name)); });
    R("getmagicname", [](ObjectVector& args) -> Object { return Object(std::string(Rmagic[cifa_arg_int(args, 0)].Name)); });
    R("getsubmapname", [](ObjectVector& args) -> Object { return Object(std::string(Rscene[cifa_arg_int(args, 0)].Name)); });

    R("getmainmapposition", [](ObjectVector&) -> Object { return cifa_array({ Object(My), Object(Mx) }); });
    R("setmainmapposition", [](ObjectVector& args) -> Object { Mx = cifa_arg_int(args, 1); My = cifa_arg_int(args, 0); return Object(); });
    R("getsceneposition", [](ObjectVector&) -> Object { return cifa_array({ Object(Sy), Object(Sx) }); });
    R("setsceneposition", [](ObjectVector& args) -> Object { Sx = cifa_arg_int(args, 1); Sy = cifa_arg_int(args, 0); return Object(); });
    R("setsceneposition2", [](ObjectVector& args) -> Object { instruct_19(cifa_arg_int(args, 0), cifa_arg_int(args, 1)); return Object(); });
    R("instruct_19", [](ObjectVector& args) -> Object { instruct_19(cifa_arg_int(args, 0), cifa_arg_int(args, 1)); return Object(); });
    R("getsceneface", [](ObjectVector&) -> Object { return Object(SFace); });
    R("setsceneface", [](ObjectVector& args) -> Object { SFace = cifa_arg_int(args, 0); return Object(); });
    R("changescene", [](ObjectVector& args) -> Object { CurScene = cifa_arg_int(args, 0); int x = args.size() == 1 ? Rscene[CurScene].EntranceX : cifa_arg_int(args, 1); int y = args.size() == 1 ? Rscene[CurScene].EntranceY : cifa_arg_int(args, 2); Cx = x + Cx - Sx; Cy = y + Cy - Sy; Sx = x; Sy = y; instruct_14(); InitialScene(); DrawScene(); instruct_13(); ShowSceneName(CurScene); CheckEvent3(); return Object(); });
    R("jumpscene", [](ObjectVector& args) -> Object { JumpScene(cifa_arg_int(args, 0), cifa_arg_int(args, 1), cifa_arg_int(args, 2)); return Object(); });

    R("learnmagic", [](ObjectVector& args) -> Object { if (args.size() == 2) instruct_33(cifa_arg_int(args, 0), cifa_arg_int(args, 1), 0); if (args.size() == 3) StudyMagic(cifa_arg_int(args, 0), 0, cifa_arg_int(args, 1), cifa_arg_int(args, 2), 0); if (args.size() >= 4) StudyMagic(cifa_arg_int(args, 0), cifa_arg_int(args, 1), cifa_arg_int(args, 2), cifa_arg_int(args, 3), 0); return Object(); });
    R("learnmagic2", [](ObjectVector& args) -> Object { instruct_33(cifa_arg_int(args, 0), cifa_arg_int(args, 1), cifa_arg_int(args, 2)); return Object(); });
    R("instruct_33", [](ObjectVector& args) -> Object { instruct_33(cifa_arg_int(args, 0), cifa_arg_int(args, 1), cifa_arg_int(args, 2)); return Object(); });
    R("eatoneitem", [](ObjectVector& args) -> Object { if (args.size() >= 2) EatOneItem(cifa_arg_int(args, 0), cifa_arg_int(args, 1)); return Object(); });
    R("selectoneteammember", [](ObjectVector& args) -> Object { return Object(SelectOneTeamMember(0, 0, cifa_arg_string(args, 0), cifa_arg_int(args, 1), cifa_arg_int(args, 2))); });
    R("setattribute", [](ObjectVector& args) -> Object { SetAttribute(cifa_arg_int(args, 0), cifa_arg_int(args, 1), cifa_arg_int(args, 2), cifa_arg_int(args, 3), cifa_arg_int(args, 4)); return Object(); });
    R("setroleface", [](ObjectVector& args) -> Object { instruct_40(cifa_arg_int(args, 0)); return Object(); });
    R("instruct_40", [](ObjectVector& args) -> Object { instruct_40(cifa_arg_int(args, 0)); return Object(); });
    R("instruct_63", [](ObjectVector& args) -> Object { instruct_63(cifa_arg_int(args, 0), cifa_arg_int(args, 1)); return Object(); });
    R("showstatus", [](ObjectVector& args) -> Object { ShowStatus(cifa_arg_int(args, 0)); UpdateAllScreen(); return Object(); });
    R("showsimplestatus", [](ObjectVector& args) -> Object { ShowSimpleStatus(cifa_arg_int(args, 0), cifa_arg_int(args, 1), cifa_arg_int(args, 2)); return Object(); });
    R("showability", [](ObjectVector& args) -> Object { ShowAbility(cifa_arg_int(args, 0), -1); UpdateAllScreen(); return Object(); });
    R("updateallscreen", [](ObjectVector&) -> Object { UpdateAllScreen(); return Object(); });
    R("drawlength", [](ObjectVector& args) -> Object { return Object(DrawLength(cifa_arg_string(args, 0).c_str())); });
    R("drawrect", [](ObjectVector& args) -> Object { if (args.size() == 7) DrawRectangle(cifa_arg_int(args, 0), cifa_arg_int(args, 1), cifa_arg_int(args, 2), cifa_arg_int(args, 3), cifa_arg_int(args, 4), cifa_arg_int(args, 5), cifa_arg_int(args, 6)); if (args.size() == 6) DrawRectangleWithoutFrame(cifa_arg_int(args, 0), cifa_arg_int(args, 1), cifa_arg_int(args, 2), cifa_arg_int(args, 3), cifa_arg_int(args, 4), cifa_arg_int(args, 5)); return Object(); });
    R("showpicture", [](ObjectVector& args) -> Object { if (args.size() == 4) { int t = cifa_arg_int(args, 0); int p = cifa_arg_int(args, 1); int x = cifa_arg_int(args, 2); int y = cifa_arg_int(args, 3); switch (t) { case 0: DrawMPic(p, x, y); break; case 1: case 2: DrawSPic(p, x, y); break; case 3: DrawHeadPic(p, x, y); break; case 4: DrawEPic(p, x, y); break; } } return Object(); });
    R("colcolor", [](ObjectVector& args) -> Object { return Object((double)ColColor(cifa_arg_int(args, 0))); });

    R("playmusic", [](ObjectVector& args) -> Object { instruct_66(cifa_arg_int(args, 0)); return Object(); });
    R("changemmapmusic", [](ObjectVector& args) -> Object { instruct_8(cifa_arg_int(args, 0)); return Object(); });
    R("instruct_8", [](ObjectVector& args) -> Object { instruct_8(cifa_arg_int(args, 0)); return Object(); });
    R("instruct_66", [](ObjectVector& args) -> Object { instruct_66(cifa_arg_int(args, 0)); return Object(); });
    R("playwave", [](ObjectVector& args) -> Object { instruct_67(cifa_arg_int(args, 0)); return Object(); });
    R("instruct_67", [](ObjectVector& args) -> Object { instruct_67(cifa_arg_int(args, 0)); return Object(); });
    R("walkfromto", [](ObjectVector& args) -> Object { instruct_30(cifa_arg_int(args, 0), cifa_arg_int(args, 1), cifa_arg_int(args, 2), cifa_arg_int(args, 3)); return Object(); });
    R("instruct_30", [](ObjectVector& args) -> Object { instruct_30(cifa_arg_int(args, 0), cifa_arg_int(args, 1), cifa_arg_int(args, 2), cifa_arg_int(args, 3)); return Object(); });
    R("scenefromto", [](ObjectVector& args) -> Object { instruct_25(cifa_arg_int(args, 0), cifa_arg_int(args, 1), cifa_arg_int(args, 2), cifa_arg_int(args, 3)); return Object(); });
    R("instruct_25", [](ObjectVector& args) -> Object { instruct_25(cifa_arg_int(args, 0), cifa_arg_int(args, 1), cifa_arg_int(args, 2), cifa_arg_int(args, 3)); return Object(); });
    R("playanimation", [](ObjectVector& args) -> Object { instruct_27(cifa_arg_int(args, 0), cifa_arg_int(args, 1), cifa_arg_int(args, 2)); return Object(); });
    R("instruct_27", [](ObjectVector& args) -> Object { instruct_27(cifa_arg_int(args, 0), cifa_arg_int(args, 1), cifa_arg_int(args, 2)); return Object(); });
    R("play2animation", [](ObjectVector& args) -> Object { instruct_44(cifa_arg_int(args, 0), cifa_arg_int(args, 1), cifa_arg_int(args, 2), cifa_arg_int(args, 3), cifa_arg_int(args, 4), cifa_arg_int(args, 5)); return Object(); });
    R("instruct_44", [](ObjectVector& args) -> Object { instruct_44(cifa_arg_int(args, 0), cifa_arg_int(args, 1), cifa_arg_int(args, 2), cifa_arg_int(args, 3), cifa_arg_int(args, 4), cifa_arg_int(args, 5)); return Object(); });
    R("endanimation", [](ObjectVector& args) -> Object { instruct_62(cifa_arg_int(args, 0), cifa_arg_int(args, 1), cifa_arg_int(args, 2), cifa_arg_int(args, 3), cifa_arg_int(args, 4), cifa_arg_int(args, 5)); return Object(); });
    R("instruct_62", [](ObjectVector& args) -> Object { instruct_62(cifa_arg_int(args, 0), cifa_arg_int(args, 1), cifa_arg_int(args, 2), cifa_arg_int(args, 3), cifa_arg_int(args, 4), cifa_arg_int(args, 5)); return Object(); });
    R("playaction", [](ObjectVector& args) -> Object { int bnum = cifa_arg_int(args, 0); int mtype = cifa_arg_int(args, 1); PlayActionAnimation(bnum, mtype); PlayMagicAnimation(bnum, mtype); return Object(); });
    R("playhurtvalue", [](ObjectVector& args) -> Object { ShowHurtValue(cifa_arg_int(args, 0)); return Object(); });
    R("setanimationlayer", [](ObjectVector& args) -> Object { int x = cifa_arg_int(args, 0); int y = cifa_arg_int(args, 1); int w = cifa_arg_int(args, 2); int h = cifa_arg_int(args, 3); int t = cifa_arg_int(args, 4); for (int i1 = x; i1 < x + w; i1++) for (int i2 = y; i2 < y + h; i2++) BField[4][i1][i2] = t; return Object(); });
    R("clearrolefrombattle", [](ObjectVector& args) -> Object { Brole[cifa_arg_int(args, 0)].Dead = 1; return Object(); });
    R("addroleintobattle", [](ObjectVector& args) -> Object { int bnum = BRoleAmount++; Brole[bnum].rnum = cifa_arg_int(args, 1); Brole[bnum].Team = cifa_arg_int(args, 0); Brole[bnum].X = cifa_arg_int(args, 2); Brole[bnum].Y = cifa_arg_int(args, 3); Brole[bnum].Face = 1; Brole[bnum].Dead = 0; Brole[bnum].Step = 0; Brole[bnum].Acted = 1; Brole[bnum].ShowNumber = -1; Brole[bnum].ExpGot = 0; return Object(bnum); });
    R("forcebattleresult", [](ObjectVector& args) -> Object { Bstatus = cifa_arg_int(args, 0); return Object(); });
    R("getbattlenumber", [](ObjectVector& args) -> Object { if (args.empty()) return Object(x50[28005]); int rnum = cifa_arg_int(args, 0); int result = -1; for (int i = 0; i < BRoleAmount; i++) if (Brole[i].rnum == rnum) { result = i; break; } return Object(result); });
    R("selectoneaim", [](ObjectVector& args) -> Object { if (cifa_arg_int(args, 2) == 0) SelectAim(cifa_arg_int(args, 0), cifa_arg_int(args, 1)); return Object(BField[2][Ax][Ay]); });

    R("judgeethics", [](ObjectVector& args) -> Object { return cifa_bool(instruct_28(cifa_arg_int(args, 0), cifa_arg_int(args, 1), cifa_arg_int(args, 2), 1, 0) == 1); });
    R("instruct_28", [](ObjectVector& args) -> Object { return cifa_bool(instruct_28(cifa_arg_int(args, 0), cifa_arg_int(args, 1), cifa_arg_int(args, 2), 1, 0) == 1); });
    R("judgeattack", [](ObjectVector& args) -> Object { return cifa_bool(instruct_29(cifa_arg_int(args, 0), cifa_arg_int(args, 1), cifa_arg_int(args, 2), 1, 0) == 1); });
    R("instruct_29", [](ObjectVector& args) -> Object { return cifa_bool(instruct_29(cifa_arg_int(args, 0), cifa_arg_int(args, 1), cifa_arg_int(args, 2), 1, 0) == 1); });
    R("judgemoney", [](ObjectVector& args) -> Object { return cifa_bool(instruct_31(cifa_arg_int(args, 0), 1, 0) == 1); });
    R("instruct_31", [](ObjectVector& args) -> Object { return cifa_bool(instruct_31(cifa_arg_int(args, 0), 1, 0) == 1); });
    R("judgesexual", [](ObjectVector& args) -> Object { return cifa_bool(instruct_36(cifa_arg_int(args, 0), 1, 0) == 1); });
    R("instruct_36", [](ObjectVector& args) -> Object { return cifa_bool(instruct_36(cifa_arg_int(args, 0), 1, 0) == 1); });
    R("judgefemaleinteam", [](ObjectVector&) -> Object { return cifa_bool(instruct_42(1, 0) == 1); });
    R("instruct_42", [](ObjectVector&) -> Object { return cifa_bool(instruct_42(1, 0) == 1); });
    R("judgeeventnum", [](ObjectVector& args) -> Object { return cifa_bool(instruct_55(cifa_arg_int(args, 0), cifa_arg_int(args, 1), 1, 0) == 1); });
    R("instruct_55", [](ObjectVector& args) -> Object { return cifa_bool(instruct_55(cifa_arg_int(args, 0), cifa_arg_int(args, 1), 1, 0) == 1); });
    R("judgescenepic", [](ObjectVector& args) -> Object { return cifa_bool(instruct_60(cifa_arg_int(args, 0), cifa_arg_int(args, 1), cifa_arg_int(args, 2), 1, 0) == 1); });
    R("instruct_60", [](ObjectVector& args) -> Object { return cifa_bool(instruct_60(cifa_arg_int(args, 0), cifa_arg_int(args, 1), cifa_arg_int(args, 2), 1, 0) == 1); });
    R("judge14booksplaced", [](ObjectVector&) -> Object { return cifa_bool(instruct_61(1, 0) == 1); });
    R("instruct_61", [](ObjectVector&) -> Object { return cifa_bool(instruct_61(1, 0) == 1); });
    R("judgesceneevent", [](ObjectVector& args) -> Object { return cifa_bool(DData[CurScene][cifa_arg_int(args, 0)][2 + cifa_arg_int(args, 1)] == cifa_arg_int(args, 2)); });
    R("compareprointeam", [](ObjectVector& args) -> Object { int count = 0; int datalist = cifa_arg_int(args, 0); int value = cifa_arg_int(args, 1); for (int i = 0; i < 6; i++) if (Rrole[TeamList[i]].Data[datalist] == value) count++; return Object(count); });
    R("instruct_50", [](ObjectVector& args) -> Object { std::vector<int> x(7); for (size_t i = 0; i < 7 && i < args.size(); i++) x[i] = cifa_arg_int(args, i); int result = instruct_50(x); return cifa_bool(result == x[5]); });
    R50("setx50value", 0);
    R50("setx50array", 1);
    R50("getx50array", 2);
    R50("calcx50", 3);
    R50("comparex50", 4);
    R50("clearx50all", 5);
    R50("gettalk", 8);
    R50("format", 9);
    R50("stringlength", 10);
    R50("concat", 11);
    R50("spaces", 12);
    R50("setr", 16);
    R50("getr", 17);
    R50("teamset", 18);
    R50("teamget", 19);
    R50("itemamount", 20);
    R50("dset", 21);
    R50("dget", 22);
    R50("sset", 23);
    R50("sget", 24);
    R50("memoryset", 25);
    R50("memoryget", 26);
    R50("getname", 27);
    R50("battlenumber", 28);
    R50("selectaim", 29);
    R50("battlefieldget", 30);
    R50("battlefieldset", 31);
    R50("setnextarg", 32);
    R50("drawstring", 33);
    R50("drawrect50", 34);
    R50("keytox50", 35);
    R50("showmessage", 36);
    R50("delay50", 37);
    R50("randomtox50", 38);
    R50("menutox50", 39);
    R50("scrollmenu", 40);
    R50("drawpicture50", 41);
    R50("mainmappositionset", 42);
    R50("eventcall", 43);
    R50("battleanimation", 44);
    R50("showhurtvalue", 45);
    R50("seteffect", 46);
    R50("redraw", 47);
    R50("debug", 48);
    R50("pe", 49);
    R50("entername", 50);
    R50("inputnumber", 51);
    R50("havemagic", 52);
    R50("roleattributeadd", 53);
    R50("walkpictureset", 54);
    R50("movieplay", 55);
    R50("scriptcall", 60);
    R("setjumpflag", [](ObjectVector& args) -> Object { x50[0x7000] = cifa_arg_int(args, 0) ? 0 : 1; return Object(); });
    R("checkjumpflag", [](ObjectVector&) -> Object { return cifa_bool(x50[0x7000] == 0); });

    R("addaptitude", [](ObjectVector& args) -> Object { instruct_34(cifa_arg_int(args, 0), cifa_arg_int(args, 1)); return Object(); });
    R("instruct_34", [](ObjectVector& args) -> Object { instruct_34(cifa_arg_int(args, 0), cifa_arg_int(args, 1)); return Object(); });
    R("addethics", [](ObjectVector& args) -> Object { instruct_37(cifa_arg_int(args, 0)); return Object(); });
    R("instruct_37", [](ObjectVector& args) -> Object { instruct_37(cifa_arg_int(args, 0)); return Object(); });
    R("addhp", [](ObjectVector& args) -> Object { instruct_48(cifa_arg_int(args, 0), cifa_arg_int(args, 1)); return Object(); });
    R("instruct_48", [](ObjectVector& args) -> Object { instruct_48(cifa_arg_int(args, 0), cifa_arg_int(args, 1)); return Object(); });
    R("addmp", [](ObjectVector& args) -> Object { instruct_46(cifa_arg_int(args, 0), cifa_arg_int(args, 1)); return Object(); });
    R("instruct_46", [](ObjectVector& args) -> Object { instruct_46(cifa_arg_int(args, 0), cifa_arg_int(args, 1)); return Object(); });
    R("addattack", [](ObjectVector& args) -> Object { instruct_47(cifa_arg_int(args, 0), cifa_arg_int(args, 1)); return Object(); });
    R("instruct_47", [](ObjectVector& args) -> Object { instruct_47(cifa_arg_int(args, 0), cifa_arg_int(args, 1)); return Object(); });
    R("addspeed", [](ObjectVector& args) -> Object { instruct_45(cifa_arg_int(args, 0), cifa_arg_int(args, 1)); return Object(); });
    R("instruct_45", [](ObjectVector& args) -> Object { instruct_45(cifa_arg_int(args, 0), cifa_arg_int(args, 1)); return Object(); });
    R("addrepute", [](ObjectVector& args) -> Object { instruct_56(cifa_arg_int(args, 0)); return Object(); });
    R("instruct_56", [](ObjectVector& args) -> Object { instruct_56(cifa_arg_int(args, 0)); return Object(); });
    R("setmppro", [](ObjectVector& args) -> Object { instruct_49(cifa_arg_int(args, 0), cifa_arg_int(args, 1)); return Object(); });
    R("instruct_49", [](ObjectVector& args) -> Object { instruct_49(cifa_arg_int(args, 0), cifa_arg_int(args, 1)); return Object(); });
    R("setpersonmppro", [](ObjectVector& args) -> Object { instruct_49(cifa_arg_int(args, 0), cifa_arg_int(args, 1)); return Object(); });
    R("setonemagic", [](ObjectVector& args) -> Object { instruct_35(cifa_arg_int(args, 0), cifa_arg_int(args, 1), cifa_arg_int(args, 2), cifa_arg_int(args, 3)); return Object(); });
    R("instruct_35", [](ObjectVector& args) -> Object { instruct_35(cifa_arg_int(args, 0), cifa_arg_int(args, 1), cifa_arg_int(args, 2), cifa_arg_int(args, 3)); return Object(); });
    R("setoneusepoi", [](ObjectVector& args) -> Object { instruct_23(cifa_arg_int(args, 0), cifa_arg_int(args, 1)); return Object(); });
    R("instruct_23", [](ObjectVector& args) -> Object { instruct_23(cifa_arg_int(args, 0), cifa_arg_int(args, 1)); return Object(); });
    R("changescenepic", [](ObjectVector& args) -> Object { instruct_38(cifa_arg_int(args, 0), cifa_arg_int(args, 1), cifa_arg_int(args, 2), cifa_arg_int(args, 3)); return Object(); });
    R("instruct_38", [](ObjectVector& args) -> Object { instruct_38(cifa_arg_int(args, 0), cifa_arg_int(args, 1), cifa_arg_int(args, 2), cifa_arg_int(args, 3)); return Object(); });
    R("openscene", [](ObjectVector& args) -> Object { instruct_39(cifa_arg_int(args, 0)); return Object(); });
    R("instruct_39", [](ObjectVector& args) -> Object { instruct_39(cifa_arg_int(args, 0)); return Object(); });
    R("breakstonegate", [](ObjectVector&) -> Object { instruct_57(); return Object(); });
    R("instruct_57", [](ObjectVector&) -> Object { instruct_57(); return Object(); });
    R("fightfortop", [](ObjectVector&) -> Object { instruct_58(); return Object(); });
    R("instruct_58", [](ObjectVector&) -> Object { instruct_58(); return Object(); });
    R("showethics", [](ObjectVector&) -> Object { instruct_52(); return Object(); });
    R("instruct_52", [](ObjectVector&) -> Object { instruct_52(); return Object(); });
    R("showrepute", [](ObjectVector&) -> Object { instruct_53(); return Object(); });
    R("instruct_53", [](ObjectVector&) -> Object { instruct_53(); return Object(); });
    R("openallscene", [](ObjectVector&) -> Object { instruct_54(); return Object(); });
    R("instruct_54", [](ObjectVector&) -> Object { instruct_54(); return Object(); });
    R("zeromp", [](ObjectVector&) -> Object { instruct_22(); return Object(); });
    R("zeroallmp", [](ObjectVector&) -> Object { instruct_22(); return Object(); });
    R("instruct_22", [](ObjectVector&) -> Object { instruct_22(); return Object(); });
    R("weishop", [](ObjectVector& args) -> Object { if (args.empty()) instruct_64(); else NewShop(cifa_arg_int(args, 0)); return Object(); });
    R("instruct_64", [](ObjectVector& args) -> Object { if (args.empty()) instruct_64(); else NewShop(cifa_arg_int(args, 0)); return Object(); });
    R("resetscene", [](ObjectVector&) -> Object { memcpy(Rscene, Rscene0, sizeof(TScene) * 1002); ReSetEntrance(); return Object(); });
    R("setbattlename", [](ObjectVector& args) -> Object { BattleNames[cifa_arg_int(args, 0)] = cifa_arg_string(args, 1); return Object(); });
    R("setscreenblendmode", [](ObjectVector& args) -> Object { ScreenBlendMode = cifa_arg_int(args, 0); return Object(); });
    R("setshowmainrole", [](ObjectVector& args) -> Object { ShowMR = cifa_arg_int(args, 0) != 0; return Object(); });
    R("addroleprowithhint", [](ObjectVector& args) -> Object { AddRoleProWithHint(cifa_arg_int(args, 0), cifa_arg_int(args, 1), cifa_arg_int(args, 2), cifa_arg_string(args, 3)); return Object(); });
#ifndef KYS_NO_MOVIE
    R("playmovie", [](ObjectVector& args) -> Object { DrawRectangleWithoutFrame(0, 0, CENTER_X * 2, CENTER_Y * 2, 0, 255); if (PlayMovie(cifa_arg_string(args, 0))) { CleanKeyValue(); WaitAnyKey(); } Redraw(); return Object(); });
#endif
    R("setmenuesctype", [](ObjectVector& args) -> Object { MenuEscType = cifa_arg_int(args, 0); return Object(); });
    R("setteam", [](ObjectVector& args) -> Object { TeamList[cifa_arg_int(args, 0)] = cifa_arg_int(args, 1); return Object(); });
    R("getteam", [](ObjectVector& args) -> Object { return Object(TeamList[cifa_arg_int(args, 0)]); });
    R("getmember", [](ObjectVector& args) -> Object { int n = cifa_arg_int(args, 0); return Object((n >= 0 && n <= 5) ? TeamList[n] : 0); });
    R("setmember", [](ObjectVector& args) -> Object { TeamList[cifa_arg_int(args, 1)] = cifa_arg_int(args, 0); return Object(); });
    R("memberamount", [](ObjectVector&) -> Object { int n = 0; for (int i = 0; i < 6; i++) if (TeamList[i] >= 0) n++; return Object(n); });
    R("getx50", [](ObjectVector& args) -> Object { return Object(x50[cifa_arg_int(args, 0)]); });
    R("getx50string", [](ObjectVector& args) -> Object { return Object(std::string((char*)&x50[cifa_arg_int(args, 0)])); });
    R("setx50", [](ObjectVector& args) -> Object { int pos = cifa_arg_int(args, 0); if (args.size() >= 2 && args[1].isType<std::string>()) { std::string str = args[1].toString(); memcpy((char*)&x50[pos], str.data(), str.size()); ((char*)&x50[pos])[str.size()] = 0; } else { x50[pos] = cifa_arg_int(args, 1); } return Object(); });
    R("clearx50", [](ObjectVector&) -> Object { memset(x50, 0, sizeof(x50)); return Object(); });
    R("makespaces", [](ObjectVector& args) -> Object { return Object(std::string(std::max(0, cifa_arg_int(args, 0)), ' ')); });
    R("random50", [](ObjectVector& args) -> Object { int upper = cifa_arg_int(args, 0); return Object(upper > 0 ? rand() % upper : 0); });
    R("menu50", [](ObjectVector& args) -> Object { int count = std::max(0, cifa_arg_int(args, 0)); int table = cifa_arg_int(args, 1); std::vector<std::string> choices; choices.reserve(count); int width = 0; for (int index = 0; index < count; index++) { std::string text((char*)&x50[x50[table + index]]); width = std::max(width, DrawLength(text.c_str())); choices.push_back(std::move(text)); } return Object(CommonScrollMenu(cifa_arg_int(args, 2), cifa_arg_int(args, 3), width * 10 + 7, count - 1, cifa_arg_int(args, 4, 10), choices) + 1); });
    R("scrollmenu50", [](ObjectVector& args) -> Object { int count = std::max(0, cifa_arg_int(args, 0)); int table = cifa_arg_int(args, 1); std::vector<std::string> choices; choices.reserve(count); int width = 0; for (int index = 0; index < count; index++) { std::string text((char*)&x50[x50[table + index]]); width = std::max(width, DrawLength(text.c_str())); choices.push_back(std::move(text)); } int maxShow = cifa_arg_int(args, 4); if (maxShow == 0) maxShow = 5; return Object(CommonScrollMenu(cifa_arg_int(args, 2), cifa_arg_int(args, 3), width * 10 + 7, count - 1, maxShow, choices) + 1); });
    R("drawpicture", [](ObjectVector& args) -> Object { int type = cifa_arg_int(args, 0); int picture = cifa_arg_int(args, 1); int x = cifa_arg_int(args, 2); int y = cifa_arg_int(args, 3); if (type == 0) { if (Where == 1) DrawSPic(picture / 2, x, y); else DrawMPic(picture / 2, x, y); } else if (type == 1) DrawHeadPic(picture, x, y); UpdateAllScreen(); return Object(); });
    R("addroleattribute", [](ObjectVector& args) -> Object { int role = cifa_arg_int(args, 0); int attribute = cifa_arg_int(args, 1); int amount = cifa_arg_int(args, 2); if (attribute >= 43 && attribute <= 58) Rrole[role].Data[attribute] = RegionParameter(Rrole[role].Data[attribute] + amount, 0, MaxProList[attribute]); if (attribute == 18) { Rrole[role].MaxHP = std::min(Rrole[role].MaxHP + amount, MAX_HP); Rrole[role].CurrentHP = std::min(Rrole[role].CurrentHP + amount, Rrole[role].MaxHP); } if (attribute == 42) { Rrole[role].MaxMP = std::min(Rrole[role].MaxMP + amount, MAX_MP); Rrole[role].CurrentMP = std::min(Rrole[role].CurrentMP + amount, Rrole[role].MaxMP); } return Object(); });
    R("setwalkpicture", [](ObjectVector& args) -> Object { BEGIN_WALKPIC = cifa_arg_int(args, 0); BEGIN_WALKPIC2 = cifa_arg_int(args, 1); return Object(); });
    R("callscript", [](ObjectVector& args) -> Object { ExecScript(std::format("{}script/{}.lua", AppPath, cifa_arg_int(args, 0)), std::format("f{}", cifa_arg_int(args, 1))); return Object(); });
    R("callevent", [](ObjectVector& args) -> Object { return Object(instruct_50e(43, 0, cifa_arg_int(args, 0), cifa_arg_int(args, 1), cifa_arg_int(args, 2), cifa_arg_int(args, 3), cifa_arg_int(args, 4))); });
    R("read_mem", [](ObjectVector& args) -> Object { int x = cifa_arg_int(args, 0); instruct_50e(26, 0, 0, x % 65536, x / 65536, 9999, 0); return Object(x50[9999]); });
    R("write_mem", [](ObjectVector& args) -> Object { int x = cifa_arg_int(args, 0); x50[9999] = cifa_arg_int(args, 1); instruct_50e(25, 1, 0, x % 65536, x / 65536, 9999, 0); return Object(); });

}

void InitialCifaScript()
{
    cifa_script = cifa::Cifa();
    cifa_script.set_output_error(false);
    cifa_script.set_include_dirs({ AppPath + "script", AppPath + "script/event", AppPath + "script/event-cifa" });
    RegisterCifaFunctions(cifa_script);
}

void DestroyCifaScript()
{
    cifa_script = cifa::Cifa();
}

std::string NormalizeCifaScript(std::string script)
{
    if (script.size() >= 3 && (uint8_t)script[0] == 0xEF && (uint8_t)script[1] == 0xBB && (uint8_t)script[2] == 0xBF)
    {
        script[0] = ' ';
        script[1] = ' ';
        script[2] = ' ';
    }
    for (auto& character : script)
    {
        if (character >= 'A' && character <= 'Z')
        {
            character = character - 'A' + 'a';
        }
    }
    return script;
}

void ExecCifaScript(const std::string& filename, const std::string& functionname)
{
    FILE* file = fopen(filename.c_str(), "rb");
    if (!file)
    {
        return;
    }
    fseek(file, 0, SEEK_END);
    long length = ftell(file);
    fseek(file, 0, SEEK_SET);
    std::string script(length, 0);
    fread(script.data(), 1, length, file);
    fclose(file);
    ExecCifaScriptString(script, functionname);
}

void ExecCifaScriptString(const std::string& script, const std::string& functionname)
{
    static thread_local int callDepth = 0;
    struct CallDepthGuard
    {
        CallDepthGuard() { ++callDepth; }
        ~CallDepthGuard() { --callDepth; }
    } callDepthGuard;

    std::string code = NormalizeCifaScript(script);
    Object result = cifa_script.run_script(code);
    if (cifa_script.has_error())
    {
        if (callDepth == 1)
        {
            kyslog("{}", cifa_script.get_errors_str());
        }
        return;
    }
    if (!functionname.empty())
    {
        cifa_script.run_script(NormalizeCifaScript(functionname + "();"));
        if (cifa_script.has_error())
        {
            if (callDepth == 1)
            {
                kyslog("{}", cifa_script.get_errors_str());
            }
        }
    }
}
