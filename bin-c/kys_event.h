#pragma once
// kys_event.h - 事件与对话系统
// 对应 kys_event.pas

#include "kys_type.h"
#include <string>
#include <vector>

// ---- 事件指令 ----
void instruct_0();
void instruct_1(int talknum, int headnum, int dismode);
void SetRolePic(int step, int pic = -1);
void instruct_2(int inum, int amount);
void ReArrangeItem(int sort = 0);
void instruct_3(std::vector<int> list);
int instruct_4(int inum, int jump1, int jump2);
int instruct_5(int jump1, int jump2);
int instruct_6(int battlenum, int jump1, int jump2, int getexp);
void instruct_8(int musicnum);
int instruct_9(int jump1, int jump2);
void instruct_10(int rnum);
int instruct_11(int jump1, int jump2);
void instruct_12();
void instruct_13();
void instruct_14();
void instruct_15();
int instruct_16(int rnum, int jump1, int jump2);
void instruct_17(std::vector<int> list);
int instruct_18(int inum, int jump1, int jump2);
void instruct_19(int x, int y);
int instruct_20(int jump1, int jump2);
void instruct_21(int rnum);
void instruct_22();
void instruct_23(int rnum, int Poison);
void instruct_24();
void instruct_25(int x1, int y1, int x2, int y2);
void instruct_26(int snum, int eNum, int add1, int add2, int add3);
void instruct_27(int eNum, int beginpic, int endpic);
int instruct_28(int rnum, int e1, int e2, int jump1, int jump2);
int instruct_29(int rnum, int r1, int r2, int jump1, int jump2);
void instruct_30(int x1, int y1, int x2, int y2);
int instruct_31(int moneynum, int jump1, int jump2);
void instruct_32(int inum, int amount);
void instruct_33(int rnum, int mnum, int dismode);
void instruct_34(int rnum, int iq);
void instruct_35(int rnum, int magiclistnum, int magicnum, int exp);
int instruct_36(int sexual, int jump1, int jump2);
void instruct_37(int Ethics);
void instruct_38(int snum, int layernum, int oldpic, int newpic);
void instruct_39(int snum);
void instruct_40(int director);
void instruct_41(int rnum, int inum, int amount);
int instruct_42(int jump1, int jump2);
int instruct_43(int inum, int jump1, int jump2);
void instruct_44(int enum1, int beginpic1, int endpic1, int enum2, int beginpic2, int endpic2);
void instruct_44e(int enum1, int beginpic1, int endpic1, int enum2, int beginpic2, int enum3, int beginpic3);
void Show3HintString(const std::string& str1, const std::string& str2, const std::string& str3);
void AddRoleProWithHint(int rnum, int datalist, int num, const std::string& word = "");
void instruct_45(int rnum, int speed);
void instruct_46(int rnum, int mp);
void instruct_47(int rnum, int Attack);
void instruct_48(int rnum, int hp);
void instruct_49(int rnum, int MPpro);
int instruct_50(std::vector<int> list);
void instruct_51();
void ShowRolePro(int rnum, int datalist, const std::string& word);
void instruct_52();
void instruct_53();
void instruct_54();
int instruct_55(int eNum, int num, int jump1, int jump2);
void instruct_56(int Repute);
void instruct_57();
void instruct_58();
void instruct_59();
int instruct_60(int snum, int eNum, int pic, int jump1, int jump2);
int instruct_61(int jump1, int jump2);
void instruct_62(int enum1, int beginpic1, int endpic1, int enum2, int beginpic2, int endpic2);
void TextAmi(const std::string& filename);
void EndAmi();
void instruct_63(int rnum, int sexual);
void instruct_64();
void instruct_66(int musicnum);
void instruct_67(int Soundnum);

// ---- 50指令子系统 ----
int e_GetValue(int bit, int t, int x);
int instruct_50e(int code, int e1, int e2, int e3, int e4, int e5, int e6);

// ---- 角色与武功 ----
bool HaveMagic(int person, int mnum, int lv);
int HaveMagicAmount(int rnum, int NeiGong = 0);
int GetMagicLevel(int person, int mnum);
void StudyMagic(int rnum, int magicnum, int newmagicnum, int level, int dismode);

// ---- 字符串处理 ----
void DivideName(const std::string& fullname, std::string& surname, std::string& givenname);
std::string ReplaceStr(const std::string& S, const std::string& Srch, const std::string& Replace);

// ---- 对话系统 ----
void NewTalk(int headnum, int talknum, int namenum, int place, int showhead, int color, int frame,
    const std::string& content = "", const std::string& disname = "");
void ShowTitle(int talknum, int color);
void ReadTalk(int talknum, std::vector<uint8_t>& talk, int needxor = 0);

// ---- 商店系统 ----
void NewShop(int shop_num);

// ---- 星将系统 ----
int GetStarState(int position);
void SetStarState(int position, int state);
int StarToRole(int Starnum);
void TeammateList();
void NewTeammateList();
void ShowTeamMate(int position, int headnum, int Count);
void ShowStarList();

// ---- 任务系统 ----
int GetMissionState(int position);
void SetMissionState(int position, int state);
void MissionList(int mode);

// ---- 小游戏 ----
int Digging(int beginPic, int goal, int shovel, int restrict);
void ShowSurface(int x, int y, int blank, const std::vector<int>& surface);
bool Lamp(int c, int beginpic, int whitecount, int chance);
bool SpellPicture(int num, int chance);
void ExchangePic(int p1, int p2);
bool WoodMan(int Chamber);
void ShowManWalk(int face, int Eface1, int Eface2);
void ShowWoodManWalk(int num, int Eface1, int Eface2, int RoleFace);
int DancerAfter90S();
void RoleEnding(int starnum, int headnum, int talknum);

// ---- 属性与升级 ----
void SetAttribute(int rnum, int selecttype, int modlevel, int minlevel, int maxlevel);
void CalAddPro(int magictype, int& attackadd, int& speedadd, int& defenceadd, int& HPadd, int& MPadd);
int GetItemAmount(int inum);
int CorrectMagic(int rnum);
void BookList();
int GetStarAmount();

// ---- 场景跳转 ----
void JumpScene(int snum, int y, int x);
int ReSetName(int t, int inum, int newnamenum);

// ---- UI与输入 ----
void ShowMap();
int16_t EnterNumber(int MinValue, int MaxValue, int x, int y, int Default = 0);
bool EnterString(std::string& str, int x, int y, int w, int h);
