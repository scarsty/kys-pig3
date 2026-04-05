#pragma once
// kys_main.h - 游戏主流程: 启动、行走、菜单、存读档、事件系统
// 对应 kys_main.pas

#include "kys_type.h"
#include <string>
#include <vector>

// 程序入口
void Run();
void Quit();
void SetMODVersion();
void ReadFiles();

// 游戏流程
void Start();
void NewStartAmi();
void StartAmi();
bool InitialRole();
void BufferRead(char*& p, char* buf, int size);
void BufferRead16to32(char*& p, char* buf, int size);
void BufferWrite(char*& p, char* buf, int size);
bool LoadR(int num);
bool SaveR(int num);
int WaitAnyKey();

// 行走
void Walk();
bool CanWalk(int x, int y);
void Moveman(int x1, int y1, int x2, int y2);
bool FindWay(int x1, int y1);
bool CheckEntrance();
int WalkInScene(int Open);
void ShowSceneName(int snum);
bool CanWalkInScene(int x, int y);
bool CanWalkInScene(int x1, int y1, int x, int y);
bool CheckEvent1();
bool CheckEvent3();
void TurnBlack();

// 菜单
int CommonMenu(int x, int y, int w, int max, int default_, const std::string menuString[], const std::string menuEngString[], int count);
int CommonMenu(int x, int y, int w, int max, int default_, const std::string menuString[], int count);
int CommonMenu(int x, int y, int w, int max, int default_, const std::string menuString[], const std::string menuEngString[],
    int needFrame, uint32 color1, uint32 color2, uint32 menucolor1, uint32 menucolor2, int count);
int CommonScrollMenu(int x, int y, int w, int max, int maxshow, const std::string menuString[], int count);
int CommonScrollMenu(int x, int y, int w, int max, int maxshow, const std::string menuString[], const std::string menuEngString[], int count);
inline int CommonScrollMenu(int x, int y, int w, int max, int maxshow, const std::vector<std::string>& menuString) {
    return CommonScrollMenu(x, y, w, max, maxshow, menuString.data(), (int)menuString.size());
}
int CommonMenu2(int x, int y, int w, const std::string menuString[], int max = 1);
inline int CommonMenu2(int x, int y, int w, const std::vector<std::string>& menuString, int max = 1) {
    return CommonMenu2(x, y, w, menuString.data(), max);
}
int SelectOneTeamMember(int x, int y, const std::string& str, int list1, int list2, int mask = 63);

void MenuEsc();
void DrawTitleMenu(int menu = -1);
int CheckTitleMenu();
void MenuMedcine();
void MenuMedPoison();
bool MenuItem();
int ReadItemList(int ItemType);
void UseItem(int inum, int teammate = -1);
bool CanEquip(int rnum, int inum, int use = 0);
void MenuStatus();
void ShowStatusByTeam(int tnum);
void ShowStatus(int rnum, int bnum = 0);
void ShowSimpleStatus(int rnum, int x, int y, int forTeam = -1);
void SetColorByPro(int Cur, int MaxValue, uint32& color1, uint32& color2);
void MenuAbility();
void ShowAbility(int rnum, int select, int showLeave = 0);
void MenuLeave();
void MenuSystem();
void MenuSet();
int MenuLoad();
int MenuLoadAtBeginning(int mode);
bool LoadForSecondRound(int num);
void MenuSave();
void MenuQuit();

// 医疗/解毒/使用物品效果
void EffectMedcine(int role1, int role2);
void EffectMedPoison(int role1, int role2);
void EatOneItem(int rnum, int inum);

// 事件系统
void CallEvent(int num);
void ReSetEntrance();
void Maker();
void ScrollTextAmi(std::vector<std::string>& words, int chnsize, int engsize, int linespace,
    int align, int alignx, int style, int delay, int picnum, int scrolldirect);

void InitGrowth();

void CloudCreate(int num);
void CloudCreateOnSide(int num);
bool IsCave(int snum);
bool CheckString(const std::string& str);
void SpecialFunction();
