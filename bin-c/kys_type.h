#pragma once
// kys_type.h - 类型定义与全局变量声明
// 对应 kys_type.pas

#include <SDL3/SDL.h>
#include <SDL3_mixer/SDL_mixer.h>
#include <SDL3_ttf/SDL_ttf.h>
#include <cstdint>
#include <map>
#include <string>
#include <vector>

// Forward declarations
struct lua_State;

// 基本类型别名
using uint32 = uint32_t;
using uint16 = uint16_t;

// 数组大小常量
constexpr int MAX_BATTLE_ROLE = 100;
constexpr int MAX_EPNG = 201;
constexpr int MAX_FPNG = 1001;

// ---- 简单结构体 ----

struct TPosition
{
    int x = 0, y = 0;
};

struct TPicInfo
{
    int w = 0, h = 0, offx = 0, offy = 0;
};

struct TStretchInfo
{
    int px = 0, py = 0, num = 0, den = 0;
};

struct TBuildInfo
{
    int c = 0;
    int16_t b = 0, x = 0, y = 0;
};

struct TItemList
{
    int Number = -1;
    int Amount = 0;
};

struct TCloud
{
    int Picnum = 0;
    int Shadow = 0;
    int Alpha = 0;
    uint32 mixColor = 0;
    int mixAlpha = 0;
    int Positionx = 0, Positiony = 0, Speedx = 0, Speedy = 0;
};

// 函数指针类型
using TPInt1 = void (*)(int);

// PNG贴图索引
struct TPNGIndex
{
    int FileNum = 0, PointerNum = 0, Frame = 0, x = 0, y = 0, w = 0, h = 0, Loaded = 0, UseGRP = 0;
    void* BeginPointer = nullptr;
    std::vector<void*> Pointers;
};

// PNG贴图索引组 (效果和战斗用)
struct TPNGIndexes
{
    int Amount = 0, Loaded = 0;
    int16_t FightFrame[5] = {};
    std::vector<TPNGIndex> PNGIndexArray;
};

using TPNGIndexArray = std::vector<TPNGIndex>;

// IDX/GRP数据
struct TIDXGRP
{
    int Amount = 0;
    std::vector<int> IDX;
    std::vector<uint8_t> GRP;
};

// ---- 游戏核心数据结构 ----
// 使用union实现按元素/按数组两种访问方式, 对应Pascal中的variant record
// 注意: pig3中integer为32位(4字节)

struct TRole
{
    union
    {
        struct
        {
            int ListNum, HeadNum, IncLife, ActionNum;
            char Name[20];
            int AddAtk, AddSpeed, AddDef, AddMP, RoundLeave;
            int Sexual, Level;
            int Exp;
            int CurrentHP, MaxHP, Hurt, Poison, PhyPower;
            int ExpForItem;
            int Equip[2];
            int AmiFrameNum[5];
            int AmiDelay[5];
            int SoundDealy[5];
            int MPType, CurrentMP, MaxMP;
            int Attack, Speed, Defence, Medcine, UsePoi, MedPoi, DefPoi, Fist, Sword, Knife, Unusual, HidWeapon;
            int Knowledge, Ethics, AttPoi, Movestep, Repute, Aptitude, PracticeBook;
            int ExpForBook;
            int Magic[10], MagLevel[10];
            int TakingItem[4], TakingItemAmount[4];
            int addnum;
            int NeiGong[4], NGLevel[4];
        };
        int Data[100];
    };
};

struct TItem
{
    union
    {
        struct
        {
            int ListNum;
            int UnUse[8];
            int ForgeTimes, Price;
            char Name[40];
            char Introduction[60];
            int Magic, AmiNum, User, EquipType, ShowIntro, ItemType, UnKnow5, UnKnow6, UnKnow7;
            int AddCurrentHP, AddMaxHP, AddPoi, AddPhyPower, ChangeMPType, AddCurrentMP, AddMaxMP;
            int AddAttack, AddSpeed, AddDefence, AddMedcine, AddUsePoi, AddMedPoi, AddDefPoi;
            int AddFist, AddSword, AddKnife, AddUnusual, AddHidWeapon, AddKnowledge, AddRepute, AddMove, AddAttPoi;
            int OnlyPracRole, NeedMPType, NeedMP, NeedAttack, NeedSpeed, NeedUsePoi, NeedMedcine, NeedMedPoi;
            int NeedFist, NeedSword, NeedKnife, NeedUnusual, NeedHidWeapon, NeedAptitude;
            int NeedExp, NeedExpForItem, NeedMaterial;
            int GetItem[5], NeedMatAmount[5];
        };
        int Data[95];
    };
};

struct TScene
{
    union
    {
        struct
        {
            int ListNum;
            char Name[20];
            int ExitMusic, EntranceMusic;
            int JumpScene, EnCondition;
            int MainEntranceY1, MainEntranceX1, MainEntranceY2, MainEntranceX2;
            int EntranceY, EntranceX;
            int ExitY[3], ExitX[3];
            int JumpY1, JumpX1, JumpY2, JumpX2;
        };
        int Data[26];
    };
};

struct TMagic
{
    union
    {
        struct
        {
            int ListNum;
            char Name0[20];
            int NeedHP, MinStep, NeedItem, NeedItemAmount, ScriptNum;
            int SoundNum, MagicType, AmiNum, HurtType, AttAreaType, NeedMP, Poison;
            int Attack[10], MoveDistance[10], AttDistance[10], AddMP[10], HurtMP[10];
            char Name[40];
        };
        int Data[68];
    };
};

struct TShop
{
    union
    {
        struct
        {
            int Item[5], Amount[5], Price[5];
        };
        int Data[15];
    };
};

struct TBattleRole
{
    union
    {
        struct
        {
            int rnum, Team, Y, X, Face, Dead, Step, Acted;
            int Pic, ShowNumber, AntiHurt, AutoMode, PreTeam, ExpGot, Auto, Moved;
            int loverlevel[10];
            int StateLevel[34], StateRound[34];
            int RealSpeed, RealProgress, BHead;
            int StaticPic[4];
            int shadow, alpha;
            uint32 mixColor;
            int mixAlpha;
        };
        int Data[83];
    };
};

struct TWarData
{
    union
    {
        struct
        {
            int16_t Warnum;
            char Name1[10];
            int16_t BFieldNum, ExpGot, MusicNum;
            int16_t TeamMate[6], AutoTeamMate[6], TeamY[6], TeamX[6];
            int16_t Enemy[20], EnemyY[20], EnemyX[20];
            char Name[100];
        };
        int16_t Data[0x5D];
    };
};

struct TWoodMan
{
    union
    {
        struct
        {
            uint8_t EnemyAmount;
            uint8_t Exy[2][2];
            uint8_t Rx, Ry, ExitX, ExitY;
            uint8_t GameData[19 * 19];
        };
        uint8_t Data[370];
    };
};

struct TLoadTileData
{
    int amount = 0;
    std::string path;
    void* filemem = nullptr;    // pzip_t
    TPNGIndex* beginIndex = nullptr;
};

// ---- 全局变量 ----
// 大数组使用extern (定义在kys_type.cpp), 其余使用C++17 inline变量

// 程序路径
inline std::string AppPath;

// MOD系统
inline int MODVersion = 13;
// 13-金庸水浒传(小猪3), 31-再战江湖, 12-苍龙逐日, 41-ptt, 81-梁羽生群侠传

inline std::string TitleString;
inline std::string iniFilename = "config/kysmod.ini";

// 字体
inline const char* CHINESE_FONT = "font/chinese.ttf";
inline int CHINESE_FONT_SIZE = 20;
inline int CHINESE_FONT_REALSIZE = 20;
inline const char* ENGLISH_FONT = "font/eng.ttf";
inline int ENGLISH_FONT_SIZE = 18;
inline int ENGLISH_FONT_REALSIZE = 18;
inline int CHNFONT_SPACEWIDTH = 0;

// 屏幕中心
inline int CENTER_X = 480;
inline int CENTER_Y = 270;

inline int ui_x = 10;
inline int ui_y = 10;

// 游戏常数 (多数可由ini文件改变)
inline int BEGIN_MISSION_NUM = 100;
inline int MISSION_AMOUNT = 49;
inline int STATUS_AMOUNT = 29;
inline int BEGIN_EVENT = 301;
inline int BEGIN_SCENE = 0;
inline int BEGIN_Sx = 20;
inline int BEGIN_Sy = 19;
inline int SOFTSTAR_BEGIN_TALK = 2547;
inline int SOFTSTAR_NUM_TALK = 18;
inline int MAX_PHYSICAL_POWER = 100;
inline int MONEY_ID = 0;
inline int COMPASS_ID = 1;
inline int BEGIN_LEAVE_EVENT = 1;
inline int BEGIN_BATTLE_ROLE_PIC = 2553;
inline int MAX_LEVEL = 60;
inline int MAX_WEAPON_MATCH = 100;
inline int MAX_LOVER = 100;
inline int MAX_LOVER_STATE = 10;
inline int MIN_KNOWLEDGE = 80;
inline int MAX_ITEM_AMOUNT = 304;
inline int MAX_HP = 9999;
inline int MAX_MP = 9999;
inline int MaxProList[16] = { 100, 100, 100, 100, 100, 100, 100, 100, 100, 100, 100, 100, 100, 100, 100, 100 };
inline int LIFE_HURT = 100;
inline int NOVEL_BOOK = 144;
inline int MAX_HEAD_NUM = 189;
inline int BEGIN_NAME_IN_TALK = 0;
inline int BEGIN_WALKPIC = 2501;
inline int BEGIN_WALKPIC2 = 2501;

// 调色板数据
inline uint8_t ACol[769] = {};
inline uint8_t ACol1[769] = {};
inline uint8_t ACol2[769] = {};

// 大地图数据 (extern - 大数组)
extern int16_t Earth[480][480];
extern int16_t Surface[480][480];
extern int16_t Building[480][480];
extern int16_t BuildX[480][480];
extern int16_t BuildY[480][480];
extern int16_t Entrance[480][480];

// 游戏状态
inline int InShip = 0, Useless1 = 0;
inline int Mx = 0, My = 0, Sx = 0, Sy = 0, MFace = 0;
inline int ShipX = 0, ShipY = 0, ShipX1 = 0, ShipY1 = 0, ShipFace = 0;
inline int TeamList[6] = {};
inline std::vector<TItemList> RItemList;

// 角色/物品/场景/武功/商店 (extern - 大数组)
extern TRole Rrole[1002], Rrole0[1002];    // [-1..1000] => 用偏移1访问
extern TItem Ritem[1002], Ritem0[1002];
extern TScene Rscene[1002], Rscene0[1002];
extern TMagic Rmagic[1002], Rmagic0[1002];
extern TShop RShop[22], RShop0[22];

inline int SceneAmount = 0;

// 场景/事件数据 (extern - 巨大数组)
extern int16_t SData[401][6][64][64];
extern int16_t DData[401][200][11];

// 战场地图
extern int16_t BField[10][64][64];
extern TWarData WarStaList[401];
inline TWarData WarSta;

// 列表
inline int16_t LeaveList[100] = {};
inline int16_t LevelUpList[100] = {};

// SDL运行时对象
inline SDL_Event event = {};
inline TTF_Font* Font = nullptr;
inline TTF_Font* EngFont = nullptr;

// 视频设置
inline int PNG_TILE = 1;
inline int PNG_LOAD_ALL = 1;
inline int TRY_FIND_GRP = 1;
inline int BIG_PNG_TILE = 0;
inline int FULLSCREEN = 0;
inline int RESOLUTIONX = 0, RESOLUTIONY = 0;
inline int RENDERER = -1;
inline int SW_SURFACE = 0;
inline int SW_OUTPUT = 0;
inline int SMOOTH = 1;

inline int ImageWidth = 0, ImageHeight = 0;

inline int MPicAmount = 0, SPicAmount = 0, CPicAmount = 0, HPicAmount = 0, IPicAmount = 0;

// IDX/GRP
inline TIDXGRP WARFLD, KDEF;
inline std::vector<std::string> TDEF;

// PNG贴图索引
inline TPNGIndexArray MPNGIndex, SPNGIndex, HPNGIndex, CPNGIndex, TitlePNGIndex, IPNGIndex;
inline TPNGIndexes EPNGIndex[201];
inline TPNGIndexes FPNGIndex[1001];

// 音频
inline int VOLUME = 0, VOLUMEWAV = 0, SOUND3D = 0;
inline uint32_t SoundFlag = 0;

inline std::vector<MIX_Audio*> Music;
inline std::vector<MIX_Audio*> ESound;
inline std::vector<MIX_Audio*> ASound;

inline int StartMusic = 0;
inline int ExitSceneMusicNum = 0;
inline int NowMusic = -1;

// 事件和脚本
extern int x50[0x10000];    // [-0x8000..0x7FFF] => 偏移0x8000访问
inline lua_State* lua_script = nullptr;
inline int CurSceneRolePic = 0;
inline int NeedRefreshScene = 1;

// 游戏体验设置
inline int CLOUD_AMOUNT = 60;
inline std::vector<TCloud> Cloud;
inline int WALK_SPEED = 0, WALK_SPEED2 = 0;
inline int MMAPAMI = 0;
inline int SCENEAMI = 0;
inline int SEMIREAL = 0;
inline int KDEF_SCRIPT = 0;
inline int NIGHT_EFFECT = 0;
inline int EXIT_GAME = 0;

// 其他
inline SDL_Mutex* mutex = nullptr;
inline uint32 ChangeColorList[2][21] = {};
inline bool AskingQuit = false;
inline int begin_time = 0;
inline double now_time = 0;

inline TPosition TitlePosition = {};
inline TPosition OpenPicPosition = {};
inline int OpenPic = 0;

// 运行时状态
inline int MStep = 0, Still = 0;
inline int Cx = 0, Cy = 0, SFace = 0, SStep = 0;
inline int CurScene = 0, CurEvent = -1, CurItem = -1, CurrentBattle = 0, Where = 0;
inline int SaveNum = 0;

// 战场
inline TBattleRole Brole[100] = {};
inline int BRoleAmount = 0;
inline int Bx = 0, By = 0, Ax = 0, Ay = 0;
inline int Bstatus = 0;

// 寻路
extern int16_t linex[480 * 480];
extern int16_t liney[480 * 480];
inline int nowstep = 0;
extern int Fway[480][480];

// 物品列表
inline int16_t ItemList[969] = {};

// 扩展
inline int BATTLE_SPEED = 10;
inline int EFFECT_STRING = 0;
inline int SIMPLE = 0;
inline bool LoadingScene = false;

inline int16_t LastShowScene = -1;
inline TWoodMan WoodManSta = {};

inline std::string Star[108];
inline std::string RoleName[108];
inline int loverlist[100][5] = {};

inline int SelectAimMode = 0;

inline bool ShowMR = true;
inline int BlackScreen = 0;
inline int TimeInWater = 0;

inline std::vector<std::vector<int16_t>> gamearray;

inline bool showBlackScreen = false;

inline std::vector<std::string> MissionStr;

inline bool LoadingTiles = true;
inline bool ReadingTiles = false;
inline bool LoadingBattleTiles = false;

inline void* pMPic = nullptr;
inline void* pSPic = nullptr;
inline void* pEPic = nullptr;
inline void* pHPic = nullptr;
inline void* pIPic = nullptr;

inline int ScreenBlendMode = 0;

inline int MenuEscType = -1;
inline int MenuEscTeammate = 0;
inline int MenuItemType = 0;
inline SDL_Rect TitleMenu[4] = {};

inline int TEXT_LAYER = 0;
inline int HaveText = 1;
inline int ZIP_SAVE = 1;
inline int OPEN_MOVIE = 1;
inline int OPEN_RECITATION = 1;
inline int THREAD_READ_MOVIE = 1;
inline int KEEP_SCREEN_RATIO = 1;
inline int THREAD_READ_PNG = 0;
inline int DISABLE_MENU_AMI = 0;

inline MIX_Audio* openAudio = nullptr;
inline std::string MovieName;

inline int BasicOffset = 0, RoleOffset = 0, ItemOffset = 0, SceneOffset = 0, MagicOffset = 0, WeiShopOffset = 0, LenR = 0;

inline std::string versionstr = "  108 Brothers and Sisters";

inline std::vector<std::string> BattleNames, loverstrs, statestrs;

inline int EXPAND_GROUND = 1;
extern int16_t ExGroundS[192][192];
extern int16_t ExGroundB[192][192];

inline int AI_USE_SPECIAL = 1;
inline int BattleRound = 0;

inline int offsetX = 0, offsetY = 0;
inline int needOffset = 0;

inline std::string EventScriptPath = "script/event/ka";
inline std::string EventScriptExt = ".lua";
inline int p5032pos = -100;
inline int p5032value = -1;

inline const char* pEvent = nullptr;

inline SDL_Window* window = nullptr;
inline SDL_Renderer* render = nullptr;

inline SDL_Texture* screenTex = nullptr;
inline SDL_Texture* ImgSGroundTex = nullptr;
inline SDL_Texture* ImgBGroundTex = nullptr;
inline SDL_Texture* TextScreenTex = nullptr;
inline SDL_Texture* BlackScreenTex = nullptr;
inline SDL_Texture* SimpleStateTex = nullptr;

inline const char* keystate = nullptr;
inline uint8_t* keyup = nullptr;
inline uint8_t* keydown = nullptr;
inline uint8_t* keyright = nullptr;
inline uint8_t* keyleft = nullptr;

inline SDL_Texture* SimpleStatusTex[6] = {};
inline SDL_Texture* SimpleTextTex[6] = {};

inline std::map<int, void*> CharTex;
inline void* WoodPic = nullptr;

inline int PRESENT_SYNC = 1;
inline uint32 RenderFlag = 0;
inline uint32 WindowFlag = 0;

inline int LESS_VIDEOMEMERY = 0;
inline int FONT_MEMERY = 1;
inline int FULL_DESKTOP = 0;
inline int AUTO_LEVELUP = 0;

inline uint32 SurfaceFlag = 0;

inline SDL_Surface* CurTargetSurface = nullptr;
inline SDL_Surface* RealScreen = nullptr;
inline SDL_Surface* screen = nullptr;
inline SDL_Surface* ImgSGround = nullptr;
inline SDL_Surface* ImgBGround = nullptr;
inline SDL_Surface* TextScreen = nullptr;
inline SDL_Surface* BlackScreenSur = nullptr;
inline SDL_Surface* SimpleState = nullptr;
inline std::vector<SDL_Surface*> FreshScreen;

inline SDL_Surface* SimpleStatus[6] = {};
inline SDL_Surface* SimpleText[6] = {};

inline int SkipTalk = 0;

// 手柄
inline SDL_Joystick* joy = nullptr;
inline uint32 JOY_RETURN = 0, JOY_ESCAPE = 0;
inline uint32 JOY_LEFT = 0, JOY_RIGHT = 0, JOY_UP = 0, JOY_DOWN = 0;
inline uint32 JOY_MOUSE_LEFT = 0, JOY_AXIS_DELAY = 0;

inline int CellPhone = 0;
inline int ScreenRotate = 0;
inline int FingerCount = 0;
inline uint32 FingerTick = 0;
inline bool FreeWalking = false;
inline bool BattleSelecting = false;

// 虚拟按键
inline int ShowVirtualKey = 0;
inline uint32 VirtualKeyValue = 0;
inline int VirtualKeyX = 150;
inline int VirtualKeyY = 250;
inline int VirtualKeySize = 60;
inline int VirtualKeySpace = 25;

// 临时计时
inline uint64_t tttt = 0;

// 视频播放
inline void* smallpot = nullptr;

// 简繁转换
inline void* cct2s = nullptr;
inline void* ccs2t = nullptr;

inline int ForceBattleWin = 0;

// 手机震动
inline SDL_Haptic* haptic = nullptr;

// 色值蒙版
constexpr uint32 RMask = 0xFF0000;
constexpr uint32 GMask = 0xFF00;
constexpr uint32 BMask = 0xFF;
constexpr uint32 AMask = 0xFF000000;

// ---- 辅助宏/函数 ----

inline uint32 MapRGBA(uint8_t r, uint8_t g, uint8_t b, uint8_t a = 255)
{
    return (uint32(a) << 24) | (uint32(r) << 16) | (uint32(g) << 8) | uint32(b);
}

inline void GetRGBA(uint32 color, uint8_t* r, uint8_t* g, uint8_t* b, uint8_t* a = nullptr)
{
    if (a) *a = (color >> 24) & 0xFF;
    *r = (color >> 16) & 0xFF;
    *g = (color >> 8) & 0xFF;
    *b = color & 0xFF;
}

inline void kyslog(const char* fmt, ...)
{
    va_list args;
    va_start(args, fmt);
    SDL_LogMessageV(SDL_LOG_CATEGORY_APPLICATION, SDL_LOG_PRIORITY_INFO, fmt, args);
    va_end(args);
}
