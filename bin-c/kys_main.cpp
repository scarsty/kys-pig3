// kys_main.cpp - 游戏主流程实现
// 对应 kys_main.pas

#include "kys_main.h"
#include "kys_engine.h"
#include "kys_draw.h"
#include "kys_event.h"
#include "kys_battle.h"
#include "kys_script.h"

#include <SDL3/SDL.h>
#include <SDL3_ttf/SDL_ttf.h>
#include <SDL3_mixer/SDL_mixer.h>

#include "INIReader.h"
#include "filefunc.h"
#include "strfunc.h"
#include "ZipFile.h"
#include "PotConv.h"
#include "SimpleCC.h"

#include <algorithm>
#include <cmath>
#include <cstring>
#include <fstream>

// potdll前向声明 (动态加载)
static void* (*PotCreateFromWindow)(SDL_Window*) = nullptr;

//----------------------------------------------------------------------
// Run - 程序入口, 初始化SDL、音频、视频、字体、脚本
//----------------------------------------------------------------------
void Run()
{
#ifdef _WIN32
    AppPath = "../game/";
#elif defined(__APPLE__)
    // macOS: 从bundle中获取路径
    AppPath = "../game/";
#elif defined(__ANDROID__)
    AppPath = "/sdcard/kys-pig3/game/";
    CellPhone = 1;
#else
    AppPath = "../game/";
#endif

    kyslog("AppPath: %s", AppPath.c_str());

    ReadFiles();
    SetMODVersion();

    // 初始化音频系统
    SDL_Init(SDL_INIT_AUDIO);

    // 初始化视频系统
    srand((unsigned)time(nullptr));
    SDL_Init(SDL_INIT_VIDEO);

    // 渲染器选择
    const char* render_str = "direct3d12";
    if (CellPhone == 0)
    {
        if (RENDERER == 1) render_str = "opengl";
        if (RENDERER == 2) render_str = "software";
    }
    else
    {
        render_str = "";
    }

    if (RENDERER == 2) SMOOTH = 0;

    WindowFlag = SDL_WINDOW_RESIZABLE;
    if (CellPhone == 1)
    {
        KEEP_SCREEN_RATIO = 0;
        TEXT_LAYER = 0;
    }

    kyslog("Creating window with width and height %d and %d", RESOLUTIONX, RESOLUTIONY);
    window = SDL_CreateWindow(TitleString.c_str(), RESOLUTIONX, RESOLUTIONY, WindowFlag);
    SDL_GetWindowSize(window, &RESOLUTIONX, &RESOLUTIONY);

    if (CellPhone == 1)
    {
        SDL_Rect rect;
        SDL_GetDisplayBounds(0, &rect);
        kyslog("Width and height of the window is %d, %d", RESOLUTIONX, RESOLUTIONY);
        if (RESOLUTIONY > RESOLUTIONX) ScreenRotate = 0;
    }

    if (SW_OUTPUT != 0)
        RealScreen = SDL_GetWindowSurface(window);

    kyslog("Creating renderer");
    render = SDL_CreateRenderer(window, render_str);

    SDL_RenderClear(render);
    SDL_RenderPresent(render);

    kyslog("All pictures will be loaded as surface: %d", SW_SURFACE);
    kyslog("Text will be drawn on single layer: %d", TEXT_LAYER);

    ImageWidth = (36 * 32 + CENTER_X) * 2;
    ImageHeight = (18 * 32 + CENTER_Y) * 2;

    // 初始化字体
    kyslog("Try to load the fonts");
    TTF_Init();
    SetFontSize(20, 18, -1);

    kyslog("Creating rendered textures");
    CreateMainRenderTextures();
    CreateAssistantRenderTextures();

    kyslog("Initial lua script environment");
    InitialScript();
    kyslog("Initial music");
    InitialMusic();

    kyslog("Record the state of the direction keys");
    keystate = (const char*)SDL_GetKeyboardState(nullptr);
    keyup = (uint8_t*)(keystate + SDL_SCANCODE_UP);
    keydown = (uint8_t*)(keystate + SDL_SCANCODE_DOWN);
    keyleft = (uint8_t*)(keystate + SDL_SCANCODE_LEFT);
    keyright = (uint8_t*)(keystate + SDL_SCANCODE_RIGHT);

    kyslog("Set event filter");
    SDL_SetEventFilter((SDL_EventFilter)EventFilter, nullptr);
    SDL_AddEventWatch((SDL_EventFilter)EventWatch, nullptr);

    if (CellPhone == 1)
    {
        SDL_InitSubSystem(SDL_INIT_HAPTIC);
        SDL_HapticID* haptics = SDL_GetHaptics(nullptr);
        if (haptics != nullptr)
        {
            haptic = SDL_OpenHaptic(*haptics);
            kyslog("Initial haptic %p", (void*)haptic);
            SDL_InitHapticRumble(haptic);
        }
    }

    kyslog("Initial ended, start game");
    // smallpot = PotCreateFromWindow(window);  // 视频播放模块 (动态加载)
    Start();
    Quit();
}

//----------------------------------------------------------------------
// Quit - 关闭所有资源并退出
//----------------------------------------------------------------------
void Quit()
{
    if (SDL_JoystickConnected(joy))
        SDL_CloseJoystick(joy);
    DestroyAllTextures();
    DestroyScript();
    TTF_CloseFont(Font);
    TTF_CloseFont(EngFont);
    TTF_Quit();
    SDL_DestroyRenderer(render);
    SDL_DestroyWindow(window);
    SDL_DestroyMutex(mutex);
    SDL_Quit();
    exit(1);
}

//----------------------------------------------------------------------
// SetMODVersion - 设置MOD版本, 配置游戏参数
//----------------------------------------------------------------------
void SetMODVersion()
{
    Music.resize(99, nullptr);
    ESound.resize(99, nullptr);
    ASound.resize(99, nullptr);

    StartMusic = 59;
    TitleString = "Legend of Little Village III - 108 Brothers and Sisters";

    OpenPicPosition.x = 0;
    OpenPicPosition.y = 0;
    TitlePosition.x = OpenPicPosition.x + 470;
    TitlePosition.y = OpenPicPosition.y + 230;

    switch (MODVersion)
    {
    case 0:
        versionstr += "-金庸群侠传";
        BEGIN_EVENT = 691;
        BEGIN_SCENE = 70;
        MONEY_ID = 174;
        COMPASS_ID = 182;
        BEGIN_LEAVE_EVENT = 950;
        BEGIN_NAME_IN_TALK = 0;
        MAX_LOVER = 0;
        EventScriptExt = ".lua";
        break;
    case 12:
        TitleString = "We Are Dragons";
        versionstr += "-苍龙逐日";
        BEGIN_EVENT = 691; BEGIN_SCENE = 70;
        MONEY_ID = 174; COMPASS_ID = 182;
        BEGIN_LEAVE_EVENT = 100; BEGIN_NAME_IN_TALK = 4021;
        MAX_LOVER = 0; BEGIN_Sx = 13; BEGIN_Sy = 54;
        break;
    case 13:
        // 默认: 小猪3
        break;
    case 31:
        TitleString = "Wider rivers and deeper lakes";
        versionstr += "-再战江湖";
        BEGIN_EVENT = 691; BEGIN_SCENE = 70;
        MONEY_ID = 174; COMPASS_ID = 182;
        BEGIN_LEAVE_EVENT = 1; BEGIN_NAME_IN_TALK = 8015;
        MAX_LOVER = 0; BEGIN_Sx = 13; BEGIN_Sy = 54;
        break;
    case 41:
        TitleString = "PTT";
        versionstr += "-乡民闯江湖";
        BEGIN_EVENT = 691; BEGIN_SCENE = 70;
        MONEY_ID = 174; COMPASS_ID = 182;
        BEGIN_LEAVE_EVENT = 1050; BEGIN_NAME_IN_TALK = 5693;
        MAX_LOVER = 0; BEGIN_Sx = 20; BEGIN_Sy = 19;
        break;
    case 81:
        TitleString = "Liang Yu Sheng";
        versionstr = " 梁羽生群侠传";
        BEGIN_EVENT = 1; BEGIN_SCENE = 0;
        MONEY_ID = 174; COMPASS_ID = 182;
        BEGIN_LEAVE_EVENT = 1; BEGIN_NAME_IN_TALK = 8015;
        MAX_LOVER = 0; StartMusic = 0;
        break;
    }

    INIReaderNormal ini;
    ini.loadFile(iniFilename);
    RESOLUTIONX = ini.getInt("system", "RESOLUTIONX", CENTER_X * 2);
    RESOLUTIONY = ini.getInt("system", "RESOLUTIONY", CENTER_Y * 2);
}

//----------------------------------------------------------------------
// ReadFiles - 读取游戏配置和资源文件
//----------------------------------------------------------------------
void ReadFiles()
{
    iniFilename = AppPath + iniFilename;

    if (!filefunc::fileExist(iniFilename))
        Quit();

    INIReaderNormal ini;
    ini.loadFile(iniFilename);
    kyslog("Find ini file: %s", iniFilename.c_str());

    if (CellPhone == 0) CellPhone = ini.getInt("system", "CellPhone", 0);
    SIMPLE = ini.getInt("system", "SIMPLE", 0);
    BATTLE_SPEED = ini.getInt("system", "BATTLE_SPEED", 10);
    EFFECT_STRING = ini.getInt("system", "EFFECT_STRING", 0);
    WALK_SPEED = ini.getInt("system", "WALK_SPEED", 10);
    WALK_SPEED2 = ini.getInt("system", "WALK_SPEED2", WALK_SPEED);
    SMOOTH = ini.getInt("system", "SMOOTH", 1);
    RENDERER = ini.getInt("system", "RENDERER", 1);
    RESOLUTIONX = ini.getInt("system", "RESOLUTIONX", CENTER_X * 2);
    RESOLUTIONY = ini.getInt("system", "RESOLUTIONY", CENTER_Y * 2);
    MMAPAMI = ini.getInt("system", "MMAPAMI", 1);
    SCENEAMI = ini.getInt("system", "SCENEAMI", 2);
    SEMIREAL = ini.getInt("system", "SEMIREAL", 0);
    MODVersion = ini.getInt("system", "MODVersion", 13);
    CHINESE_FONT_SIZE = ini.getInt("system", "CHINESE_FONT_SIZE", CHINESE_FONT_SIZE);
    ENGLISH_FONT_SIZE = ini.getInt("system", "ENGLISH_FONT_SIZE", ENGLISH_FONT_SIZE);
    KDEF_SCRIPT = ini.getInt("system", "KDEF_SCRIPT", 0);
    NIGHT_EFFECT = ini.getInt("system", "NIGHT_EFFECT", 0);
    EXIT_GAME = ini.getInt("system", "EXIT_GAME", 0);
    PNG_TILE = ini.getInt("system", "PNG_TILE", 2);
    TRY_FIND_GRP = ini.getInt("system", "TRY_FIND_GRP", 0);
    PNG_LOAD_ALL = ini.getInt("system", "PNG_LOAD_ALL", 0);
    KEEP_SCREEN_RATIO = ini.getInt("system", "KEEP_SCREEN_RATIO", 1);
    TEXT_LAYER = ini.getInt("system", "Text_Layer", 0);
    ZIP_SAVE = ini.getInt("system", "ZIP_SAVE", 1);
    OPEN_MOVIE = ini.getInt("system", "OPEN_MOVIE", 1);
    OPEN_RECITATION = ini.getInt("system", "OPEN_RECITATION", 1);
    THREAD_READ_MOVIE = ini.getInt("system", "THREAD_READ_MOVIE", 1);
    THREAD_READ_PNG = ini.getInt("system", "THREAD_READ_PNG", 0);
    DISABLE_MENU_AMI = ini.getInt("system", "DISABLE_MENU_AMI", 0);
    EXPAND_GROUND = ini.getInt("system", "EXPAND_GROUND", 1);
    AI_USE_SPECIAL = ini.getInt("system", "AI_USE_SPECIAL", 1);
    PRESENT_SYNC = ini.getInt("system", "PRESENT_SYNC", 1);
    FONT_MEMERY = ini.getInt("system", "FONT_VIDEOMEMERY", 1);
    FULL_DESKTOP = ini.getInt("system", "FULL_DESKTOP", 0);
    SW_SURFACE = ini.getInt("system", "SW_SURFACE", 0);
    SW_OUTPUT = ini.getInt("system", "SW_OUTPUT", 0);
    AUTO_LEVELUP = ini.getInt("system", "AUTO_LEVELUP", 0);

    VOLUME = ini.getInt("music", "VOLUME", 30);
    VOLUMEWAV = ini.getInt("music", "VOLUMEWAV", 30);
    SOUND3D = ini.getInt("music", "SOUND3D", 1);

    JOY_RETURN = ini.getInt("joystick", "JOY_RETURN", 10);
    JOY_ESCAPE = ini.getInt("joystick", "JOY_ESCAPE", 13);
    JOY_UP = ini.getInt("joystick", "JOY_UP", 0);
    JOY_DOWN = ini.getInt("joystick", "JOY_DOWN", 1);
    JOY_LEFT = ini.getInt("joystick", "JOY_LEFT", 2);
    JOY_RIGHT = ini.getInt("joystick", "JOY_RIGHT", 3);
    JOY_MOUSE_LEFT = ini.getInt("joystick", "JOY_MOUSE_LEFT", 12);
    JOY_AXIS_DELAY = ini.getInt("joystick", "JOY_AXIS_DELAY", 10);

    if (CellPhone != 0)
    {
        ShowVirtualKey = ini.getInt("system", "Virtual_Key", 1);
        VirtualKeyX = ini.getInt("system", "Virtual_Key_X", 100);
        VirtualKeyY = ini.getInt("system", "Virtual_Key_Y", 300);
        VirtualKeySize = ini.getInt("system", "Virtual_Key_Size", 50);
        VirtualKeySpace = ini.getInt("system", "Virtual_Key_Space", 15);
    }
    else
    {
        ShowVirtualKey = 0;
    }

    if (KEEP_SCREEN_RATIO == 0) TEXT_LAYER = 0;
    if (SW_OUTPUT == 1) TEXT_LAYER = 0;

    if (!filefunc::fileExist(AppPath + "resource/mmap/index.ka") &&
        !filefunc::fileExist(AppPath + "resource/mmap.zip"))
        PNG_TILE = 0;
    if (!filefunc::fileExist(AppPath + "save/ranger.grp"))
        ZIP_SAVE = 1;
    if (KDEF_SCRIPT == 2 && !filefunc::fileExist(AppPath + "script/event.imz"))
        KDEF_SCRIPT = 1;
    if (DISABLE_MENU_AMI != 0) DISABLE_MENU_AMI = 25;

    // 最大属性值表
    MaxProList[0] = 999;  // 攻击
    MaxProList[1] = 500;  // 轻功
    MaxProList[2] = 999;  // 防御
    MaxProList[3] = 200;  // 医疗
    MaxProList[4] = 100;  // 用毒
    MaxProList[5] = 100;  // 解毒
    MaxProList[6] = 100;  // 抗毒
    MaxProList[7] = 999;  // 拳掌
    MaxProList[8] = 999;  // 御剑
    MaxProList[9] = 999;  // 耍刀
    MaxProList[10] = 999; // 特殊
    MaxProList[11] = 999; // 暗器
    MaxProList[12] = 100; // 常识
    MaxProList[13] = 100; // 品德
    MaxProList[14] = 100; // 带毒
    MaxProList[15] = 200; // 移动

    // 读取调色板
    ReadFileToBuffer((char*)&ACol[0], AppPath + "resource/mmap.col", 768, 0);
    memcpy(ACol1, ACol, 768);
    memcpy(ACol2, ACol, 768);

    // 读取地图数据
    ReadFileToBuffer((char*)&Earth[0][0], AppPath + "resource/earth.002", 480 * 480 * 2, 0);
    ReadFileToBuffer((char*)&Surface[0][0], AppPath + "resource/surface.002", 480 * 480 * 2, 0);
    ReadFileToBuffer((char*)&Building[0][0], AppPath + "resource/building.002", 480 * 480 * 2, 0);
    // 注意坐标xy互换
    ReadFileToBuffer((char*)&BuildY[0][0], AppPath + "resource/buildx.002", 480 * 480 * 2, 0);
    ReadFileToBuffer((char*)&BuildX[0][0], AppPath + "resource/buildy.002", 480 * 480 * 2, 0);

    ReadFileToBuffer((char*)&LeaveList[0], AppPath + "binlist/leave.bin", 200, 0);
    ReadFileToBuffer((char*)&LevelUpList[0], AppPath + "binlist/levelup.bin", 200, 0);

    ReadTxtFileToBuffer((char*)&loverlist[0], AppPath + "list/lover.txt");
    ReadFileToBuffer((char*)&WarStaList[0], AppPath + "resource/war.sta", sizeof(TWarData) * 401, 0);

    KDEF = LoadIdxGrp("resource/kdef.idx", "resource/kdef.grp");
    WARFLD = LoadIdxGrp("resource/warfld.idx", "resource/warfld.grp");

    // 载入108人名和星位名
    if (filefunc::fileExist(AppPath + "txt/starlist.txt"))
    {
        std::string content = filefunc::readFileToString(AppPath + "txt/starlist.txt");
        auto lines = strfunc::splitString(content, "\n");
        if (!lines.empty())
        {
            Star[0] = lines[0];
            if (lines.size() >= 216)
            {
                for (int i = 1; i <= 107 && i + 108 < (int)lines.size(); i++)
                {
                    RoleName[i] = lines[i + 108];
                    Star[i] = lines[i];
                }
            }
        }
    }

    // 载入战斗名
    BattleNames.resize(401);
    for (int i = 0; i < 401; i++)
        BattleNames[i] = WarStaList[i].Name;

    // 载入对话
    {
        std::string content = filefunc::readFileToString(AppPath + "resource/talk1.txt");
        auto lines = strfunc::splitString(content, "\n");
        TDEF.clear();
        for (auto& line : lines)
            TDEF.push_back(line);
    }

    // 情侣加成字串
    loverstrs.resize(10);
    loverstrs[0] = "攻擊"; loverstrs[1] = "防禦"; loverstrs[2] = "移動";
    loverstrs[3] = "避毒"; loverstrs[4] = "強武"; loverstrs[5] = "強內";
    loverstrs[6] = "代傷"; loverstrs[7] = "回命"; loverstrs[8] = "回內";
    loverstrs[9] = "輕功";

    // 状态字串
    statestrs.resize(34);
    statestrs[0] = "攻擊"; statestrs[1] = "防禦"; statestrs[2] = "輕功";
    statestrs[3] = "移動"; statestrs[4] = "傷害"; statestrs[5] = "回命";
    statestrs[6] = "回內"; statestrs[7] = "戰神"; statestrs[8] = "風雷";
    statestrs[9] = "孤注"; statestrs[10] = "傾國"; statestrs[11] = "毒箭";
    statestrs[12] = "遠攻"; statestrs[13] = "連擊"; statestrs[14] = "反傷";
    statestrs[15] = "靈精"; statestrs[16] = "閃避"; statestrs[17] = "博采";
    statestrs[18] = "聆音"; statestrs[19] = "青翼"; statestrs[20] = "回體";
    statestrs[21] = "傷逝"; statestrs[22] = "黯然"; statestrs[23] = "慈悲";
    statestrs[24] = "悲歌"; statestrs[26] = "定身"; statestrs[27] = "控制";
    statestrs[28] = "混亂"; statestrs[29] = "拳理"; statestrs[30] = "劍意";
    statestrs[31] = "刀氣"; statestrs[32] = "奇兵"; statestrs[33] = "狙擊";

    // 读取存档索引
    if (ZIP_SAVE == 0)
    {
        FILE* f = fopen((AppPath + "save/ranger.idx").c_str(), "rb");
        if (f)
        {
            fread(&RoleOffset, 4, 1, f);
            fread(&ItemOffset, 4, 1, f);
            fread(&SceneOffset, 4, 1, f);
            fread(&MagicOffset, 4, 1, f);
            fread(&WeiShopOffset, 4, 1, f);
            fread(&LenR, 4, 1, f);
            fclose(f);
        }
    }
    else
    {
        ZipFile zip;
        std::string zfilename = AppPath + "save/0.zip";
        if (filefunc::fileExist(zfilename))
        {
            zip.openRead(zfilename);
            if (zip.opened())
            {
                std::string data = zip.readFile("ranger.idx");
                if (data.size() >= 24)
                {
                    const int* p = (const int*)data.data();
                    RoleOffset = p[0];
                    ItemOffset = p[1];
                    SceneOffset = p[2];
                    MagicOffset = p[3];
                    WeiShopOffset = p[4];
                    LenR = p[5];
                }
            }
        }
    }
    SceneAmount = (MagicOffset - SceneOffset) / (int)sizeof(TScene);

    if (KDEF_SCRIPT >= 2)
    {
        pEvent = ReadFileToBuffer(nullptr, AppPath + "script/event.imz", -1, 1);
    }

    // 简繁转换
    // cct2s, ccs2t 的初始化 (使用SimpleCC)
}

//----------------------------------------------------------------------
// Start - 显示开头画面和标题菜单
//----------------------------------------------------------------------
void Start()
{
    Where = 4;
    if (PNG_TILE > 0)
    {
        LoadPNGTiles("resource/title", TitlePNGIndex, 1);
        InitialPicArrays();
    }

    ReadingTiles = true;

    kyslog("Play movie and start music");
    if (OPEN_MOVIE == 1)
        PlayMovie(AppPath + "movie/1.wmv");
    SDL_GetWindowSize(window, &RESOLUTIONX, &RESOLUTIONY);
    ResizeWindow(RESOLUTIONX, RESOLUTIONY);
    PlayMP3(StartMusic, -1);
    kyslog("Begin.....");
    Redraw();
    UpdateAllScreen();

    memset(Entrance, -1, sizeof(Entrance));

    RItemList.resize(MAX_ITEM_AMOUNT);
    for (int i = 0; i < MAX_ITEM_AMOUNT; i++)
    {
        RItemList[i].Number = -1;
        RItemList[i].Amount = 0;
    }

    Cloud.resize(CLOUD_AMOUNT);
    for (int i = 0; i < CLOUD_AMOUNT; i++)
        CloudCreate(i);

    NewStartAmi();

    // 标题菜单
    LoadR(0);
    int menu = 0;
    bool Selected = false;
    int headnum = 0, alpha = 100, alphastep = -2;

    while (SDL_PollEvent(&event) || true)
    {
        Redraw();

        if (alpha >= 100) alphastep = -2;
        if (alpha <= 0) alphastep = 2;
        alpha += alphastep;
        if (alpha >= 100)
            headnum = rand() % (MODVersion == 13 ? 412 : std::max(1, HPicAmount));

        int x = CENTER_X - 80;
        int y = CENTER_Y - 30;
        int maxm = 3;
        for (int i = 0; i <= maxm; i++)
        {
            DrawTPic(16, x - 40, y + i * 50, nullptr, 0, 25, 0, 0);
            if (i != menu)
                DrawTPic(3 + i, x, y + 50 * i);
            else
                DrawTPic(23 + i, x, y + 50 * i);
        }
        UpdateAllScreen();
        CheckBasicEvent();

        switch (event.type)
        {
        case SDL_EVENT_KEY_UP:
            if (event.key.key == SDLK_RETURN || event.key.key == SDLK_SPACE)
                Selected = true;
            break;
        case SDL_EVENT_KEY_DOWN:
            if (event.key.key == SDLK_UP) { menu--; if (menu < 0) menu = maxm; }
            if (event.key.key == SDLK_DOWN) { menu++; if (menu > maxm) menu = 0; }
            break;
        case SDL_EVENT_MOUSE_BUTTON_UP:
            if (event.button.button == SDL_BUTTON_LEFT && MouseInRegion(x, y, 300, 200))
                Selected = true;
            break;
        case SDL_EVENT_MOUSE_MOTION:
        {
            int x1, y1;
            if (MouseInRegion(x, y, 300, 200, x1, y1))
                menu = std::min(maxm, (y1 - y) / 50);
            break;
        }
        }
        CleanKeyValue();
        SDL_Delay(40);

        if (Selected)
        {
            switch (menu)
            {
            case 3: return; // 退出
            case 1:
                if (MenuLoadAtBeginning(0) >= 0)
                {
                    CurEvent = -1;
                    if (Where == 1) WalkInScene(0);
                    Walk();
                }
                break;
            case 0:
                Selected = InitialRole();
                if (Selected)
                {
                    CurScene = BEGIN_SCENE;
                    WalkInScene(1);
                    Walk();
                }
                break;
            case 2:
                if (MenuLoadAtBeginning(1) >= 0)
                {
                    CurScene = BEGIN_SCENE;
                    WalkInScene(1);
                    Walk();
                }
                break;
            }
            Selected = false;
        }
    }
}

//----------------------------------------------------------------------
// NewStartAmi - 新游戏开头动画
//----------------------------------------------------------------------
void NewStartAmi()
{
    Where = 4;
    CleanKeyValue();
    int x = CENTER_X - 34;
    int y = CENTER_Y - 115;

    for (int i = 0; i <= 20; i++)
    {
        Redraw();
        DrawTPic(9, x, y, nullptr, 0, 100 - i * 5);
        UpdateAllScreen();
        SDL_Delay(20);
        SDL_PollEvent(&event);
        CheckBasicEvent();
        if ((event.type == SDL_EVENT_KEY_UP && event.key.key == SDLK_ESCAPE) ||
            (event.type == SDL_EVENT_MOUSE_BUTTON_UP && event.button.button == SDL_BUTTON_RIGHT))
            return;
    }

    for (int i = 1; i <= 60; i++)
    {
        Redraw();
        x -= 4;
        y -= 2;
        DrawTPic(9, x, y);
        UpdateAllScreen();
        SDL_Delay(20);
        SDL_PollEvent(&event);
        CheckBasicEvent();
        if ((event.type == SDL_EVENT_KEY_UP && event.key.key == SDLK_ESCAPE) ||
            (event.type == SDL_EVENT_MOUSE_BUTTON_UP && event.button.button == SDL_BUTTON_RIGHT))
            return;
    }

    Where = 3;
}

void StartAmi()
{
    if (OPEN_RECITATION == 0) return;
    // TODO: 实现开头字幕滚动
}

//----------------------------------------------------------------------
// InitialRole - 初始化主角
//----------------------------------------------------------------------
bool InitialRole()
{
    LoadR(0);
    std::string input_name = (SIMPLE == 1) ? "萧笑竹" : "蕭笑竹";

    Redraw();
    UpdateAllScreen();

    // TODO: 实现EnterString输入姓名
    // 暂时使用默认名
    bool result = !input_name.empty();

    if (result)
    {
        std::string fullname = Simplified2Traditional(input_name);
        memset(Rrole[1].Name, 0, 20);  // 偏移1 = Pascal的[0]
        int len = std::min((int)fullname.size(), 19);
        memcpy(Rrole[1].Name, fullname.c_str(), len);
    }
    return result;
}

//----------------------------------------------------------------------
// LoadR / SaveR - 存读档
//----------------------------------------------------------------------
void BufferRead(char*& p, char* buf, int size)
{
    memcpy(buf, p, size);
    p += size;
}

void BufferRead16to32(char*& p, char* buf, int size)
{
    // 将16位数据转换为32位
    int16_t* src = (int16_t*)p;
    int* dst = (int*)buf;
    int count = size / 4;
    for (int i = 0; i < count; i++)
        dst[i] = src[i];
    p += count * 2;
}

void BufferWrite(char*& p, char* buf, int size)
{
    memcpy(p, buf, size);
    p += size;
}

bool LoadR(int num)
{
    SaveNum = num;
    std::string zfilename = AppPath + "save/" + std::to_string(num) + ".zip";
    std::string s = (num > 0 && ZIP_SAVE == 1) ? "1" : std::to_string(num);

    if (ZIP_SAVE == 1)
    {
        ZipFile zip;
        if (!filefunc::fileExist(zfilename))
            return false;
        zip.openRead(zfilename);
        if (!zip.opened())
            return false;

        std::string data = zip.readFile("ranger.grp");
        if (data.empty())
            return false;

        char* p = (char*)data.data();
        BufferRead(p, (char*)&Rrole[1], RoleOffset);  // 偏移1 = Pascal的[0]
        // TODO: 完成剩余数据读取
    }
    else
    {
        std::string filename = AppPath + "save/ranger.grp";
        // TODO: 实现原始文件读取
    }
    return true;
}

bool SaveR(int num)
{
    SaveNum = num;
    // TODO: 实现保存
    return true;
}

//----------------------------------------------------------------------
// WaitAnyKey - 等待任意键
//----------------------------------------------------------------------
int WaitAnyKey()
{
    event.key.key = 0;
    event.button.button = 0;
    while (true)
    {
        SDL_PollEvent(&event);
        CheckBasicEvent();
        if (event.type == SDL_EVENT_KEY_UP || event.type == SDL_EVENT_MOUSE_BUTTON_UP)
            if (event.key.key != 0 || event.button.button != 0)
                break;
        SDL_Delay(20);
    }
    int result = event.key.key;
    if (event.type == SDL_EVENT_MOUSE_BUTTON_UP)
    {
        if (event.button.button == SDL_BUTTON_LEFT) result = SDLK_SPACE;
        if (event.button.button == SDL_BUTTON_RIGHT) result = SDLK_ESCAPE;
    }
    event.key.key = 0;
    event.button.button = 0;
    return result;
}

//----------------------------------------------------------------------
// Walk - 主地图行走
//----------------------------------------------------------------------
void Walk()
{
    Where = 0;
    CleanKeyValue();

    while (SDL_PollEvent(&event) || true)
    {
        Redraw();
        DrawClouds();
        UpdateAllScreen();
        CheckBasicEvent();

        switch (event.type)
        {
        case SDL_EVENT_KEY_UP:
            if (event.key.key == SDLK_ESCAPE) MenuEsc();
            break;
        case SDL_EVENT_KEY_DOWN:
        {
            int dx = 0, dy = 0;
            if (event.key.key == SDLK_UP)    { dx = -1; dy = -1; MFace = 0; }
            if (event.key.key == SDLK_RIGHT)  { dx = 1; dy = -1; MFace = 1; }
            if (event.key.key == SDLK_LEFT)   { dx = -1; dy = 1; MFace = 2; }
            if (event.key.key == SDLK_DOWN)   { dx = 1; dy = 1; MFace = 3; }
            if (dx != 0 || dy != 0)
            {
                int nx = Mx + dx, ny = My + dy;
                if (CanWalk(nx, ny))
                {
                    Mx = nx; My = ny;
                    MStep++;
                    if (CheckEntrance()) break;
                }
            }
            break;
        }
        case SDL_EVENT_MOUSE_BUTTON_UP:
            if (event.button.button == SDL_BUTTON_RIGHT) MenuEsc();
            break;
        }
        CleanKeyValue();
        SDL_Delay((uint32_t)WALK_SPEED);
    }
}

//----------------------------------------------------------------------
// CanWalk - 判断主地图是否可行走
//----------------------------------------------------------------------
bool CanWalk(int x, int y)
{
    if (x < 0 || y < 0 || x >= 480 || y >= 480) return false;
    if (BuildX[x][y] != 0) return false;
    if (x <= 0 || x >= 479 || y <= 0 || y >= 479) return false;
    if (Surface[x][y] >= 1692 && Surface[x][y] <= 1700) return false;
    if (Earth[x][y] == 838 || (Earth[x][y] >= 612 && Earth[x][y] <= 670)) return false;

    // 在船上时的特殊处理
    if (InShip != 0)
    {
        // 水面可走
        if (Earth[x][y] >= 358 && Earth[x][y] <= 362) return true;
        if (Earth[x][y] >= 506 && Earth[x][y] <= 670) return true;
        if (Earth[x][y] >= 1016 && Earth[x][y] <= 1022) return true;
        return false;
    }
    return true;
}

//----------------------------------------------------------------------
// CheckEntrance - 检查是否到达入口
//----------------------------------------------------------------------
bool CheckEntrance()
{
    for (int i = 0; i <= SceneAmount; i++)
    {
        if (Rscene[i + 1].MainEntranceX1 == Mx && Rscene[i + 1].MainEntranceY1 == My)
        {
            CurScene = i;
            WalkInScene(1);
            return true;
        }
        if (Rscene[i + 1].MainEntranceX2 == Mx && Rscene[i + 1].MainEntranceY2 == My)
        {
            CurScene = i;
            WalkInScene(1);
            return true;
        }
    }
    return false;
}

//----------------------------------------------------------------------
// WalkInScene - 场景内行走
//----------------------------------------------------------------------
int WalkInScene(int Open)
{
    Where = 1;
    if (Open == 1)
    {
        Sx = Rscene[CurScene + 1].EntranceX;
        Sy = Rscene[CurScene + 1].EntranceY;
    }
    PlayMP3(Rscene[CurScene + 1].EntranceMusic, -1);
    InitialScene();

    while (SDL_PollEvent(&event) || true)
    {
        Redraw();
        UpdateAllScreen();
        CheckBasicEvent();

        switch (event.type)
        {
        case SDL_EVENT_KEY_UP:
            if (event.key.key == SDLK_ESCAPE) MenuEsc();
            break;
        case SDL_EVENT_KEY_DOWN:
        {
            int dx = 0, dy = 0;
            if (event.key.key == SDLK_UP)    { dx = -1; dy = -1; SFace = 0; }
            if (event.key.key == SDLK_RIGHT)  { dx = 1; dy = -1; SFace = 1; }
            if (event.key.key == SDLK_LEFT)   { dx = -1; dy = 1; SFace = 2; }
            if (event.key.key == SDLK_DOWN)   { dx = 1; dy = 1; SFace = 3; }
            if (dx != 0 || dy != 0)
            {
                int nx = Sx + dx, ny = Sy + dy;
                if (CanWalkInScene(nx, ny))
                {
                    Sx = nx; Sy = ny;
                    SStep++;
                    CheckEvent1();
                }
            }
            if (event.key.key == SDLK_SPACE || event.key.key == SDLK_RETURN)
                CheckEvent3();
            break;
        }
        case SDL_EVENT_MOUSE_BUTTON_UP:
            if (event.button.button == SDL_BUTTON_RIGHT) MenuEsc();
            break;
        }

        // 检查出口
        for (int i = 0; i < 3; i++)
        {
            if (Sx == Rscene[CurScene + 1].ExitX[i] && Sy == Rscene[CurScene + 1].ExitY[i])
            {
                Where = 0;
                PlayMP3(Rscene[CurScene + 1].ExitMusic, -1);
                return 0;
            }
        }

        CleanKeyValue();
        SDL_Delay((uint32_t)WALK_SPEED2);
    }
    return 0;
}

void ShowSceneName(int snum)
{
    // TODO: 显示场景名称
}

bool CanWalkInScene(int x, int y)
{
    if (x < 0 || y < 0 || x >= 64 || y >= 64) return false;
    if (SData[CurScene][1][x][y] > 0) return false;  // 建筑层阻挡
    if (SData[CurScene][3][x][y] > 0) return false;  // 事件层检查(某些事件阻挡)
    return true;
}

bool CanWalkInScene(int x1, int y1, int x, int y)
{
    return CanWalkInScene(x, y);
}

bool CheckEvent1()
{
    int e = SData[CurScene][3][Sx][Sy];
    if (e > 0 && DData[CurScene][e][0] == 1)
    {
        CurEvent = e;
        CallEvent(e);
        return true;
    }
    return false;
}

bool CheckEvent3()
{
    // 面对方向的格子
    int fx = Sx, fy = Sy;
    switch (SFace)
    {
    case 0: fx--; fy--; break;
    case 1: fx++; fy--; break;
    case 2: fx--; fy++; break;
    case 3: fx++; fy++; break;
    }
    if (fx >= 0 && fy >= 0 && fx < 64 && fy < 64)
    {
        int e = SData[CurScene][3][fx][fy];
        if (e > 0 && DData[CurScene][e][0] == 3)
        {
            CurEvent = e;
            CallEvent(e);
            return true;
        }
    }
    return false;
}

void TurnBlack()
{
    instruct_14();
}

void Moveman(int x1, int y1, int x2, int y2)
{
    // TODO: BFS寻路移动
}

bool FindWay(int x1, int y1)
{
    // TODO: BFS寻路
    return false;
}

//----------------------------------------------------------------------
// CommonMenu - 通用菜单
//----------------------------------------------------------------------
int CommonMenu(int x, int y, int w, int max, int default_, const std::string menuString[], int count)
{
    int menu = default_;
    if (menu < 0) menu = 0;
    if (menu > max) menu = max;
    bool Selected = false;

    while (SDL_PollEvent(&event) || true)
    {
        Redraw();
        DrawRectangle(x, y, w, (max + 1) * 25 + 15, MapRGBA(0, 0, 0), MapRGBA(255, 255, 255), 50);
        for (int i = 0; i <= max; i++)
        {
            uint32 c1 = MapRGBA(255, 255, 255);
            uint32 c2 = MapRGBA(0, 0, 0);
            if (i == menu)
            {
                c1 = MapRGBA(255, 255, 0);
                DrawRectangleWithoutFrame(x + 5, y + 8 + i * 25, w - 10, 24, MapRGBA(0, 0, 128), 50);
            }
            DrawShadowText(menuString[i], x + 15, y + 10 + i * 25, c1, c2);
        }
        UpdateAllScreen();
        CheckBasicEvent();

        switch (event.type)
        {
        case SDL_EVENT_KEY_UP:
            if (event.key.key == SDLK_RETURN || event.key.key == SDLK_SPACE)
                return menu;
            if (event.key.key == SDLK_ESCAPE)
                return -1;
            break;
        case SDL_EVENT_KEY_DOWN:
            if (event.key.key == SDLK_UP) { menu--; if (menu < 0) menu = max; }
            if (event.key.key == SDLK_DOWN) { menu++; if (menu > max) menu = 0; }
            break;
        case SDL_EVENT_MOUSE_BUTTON_UP:
            if (event.button.button == SDL_BUTTON_LEFT)
            {
                int mx, my;
                if (MouseInRegion(x, y, w, (max + 1) * 25 + 15, mx, my))
                    return std::min(max, (my - y - 8) / 25);
            }
            if (event.button.button == SDL_BUTTON_RIGHT)
                return -1;
            break;
        case SDL_EVENT_MOUSE_MOTION:
        {
            int mx, my;
            if (MouseInRegion(x, y, w, (max + 1) * 25 + 15, mx, my))
                menu = std::min(max, (my - y - 8) / 25);
            break;
        }
        }
        CleanKeyValue();
        SDL_Delay(20);
    }
    return -1;
}

int CommonMenu(int x, int y, int w, int max, int default_, const std::string menuString[], const std::string menuEngString[], int count)
{
    return CommonMenu(x, y, w, max, default_, menuString, count);
}

int CommonMenu(int x, int y, int w, int max, int default_, const std::string menuString[], const std::string menuEngString[],
    int needFrame, uint32 color1, uint32 color2, uint32 menucolor1, uint32 menucolor2, int count)
{
    return CommonMenu(x, y, w, max, default_, menuString, count);
}

int CommonScrollMenu(int x, int y, int w, int max, int maxshow, const std::string menuString[], int count)
{
    // TODO: 实现滚动菜单
    return CommonMenu(x, y, w, std::min(max, maxshow), 0, menuString, count);
}

int CommonScrollMenu(int x, int y, int w, int max, int maxshow, const std::string menuString[], const std::string menuEngString[], int count)
{
    return CommonScrollMenu(x, y, w, max, maxshow, menuString, count);
}

int CommonMenu2(int x, int y, int w, const std::string menuString[], int max)
{
    return CommonMenu(x, y, w, max, 0, menuString, max + 1);
}

int SelectOneTeamMember(int x, int y, const std::string& str, int list1, int list2, int mask)
{
    // TODO: 实现队员选择
    return 0;
}

//----------------------------------------------------------------------
// MenuEsc - ESC主菜单
//----------------------------------------------------------------------
void MenuEsc()
{
    std::string menuStr[] = { "狀態", "武功", "物品", "系統" };
    if (SIMPLE == 1)
    {
        menuStr[0] = "状态"; menuStr[1] = "武功"; menuStr[2] = "物品"; menuStr[3] = "系统";
    }

    int menu = CommonMenu(CENTER_X - 50, CENTER_Y - 60, 100, 3, 0, menuStr, 4);
    switch (menu)
    {
    case 0: MenuStatus(); break;
    case 1: MenuAbility(); break;
    case 2: MenuItem(); break;
    case 3: MenuSystem(); break;
    }
}

void DrawTitleMenu(int menu) { /* TODO */ }
int CheckTitleMenu() { return -1; /* TODO */ }

//----------------------------------------------------------------------
// 菜单实现 (框架)
//----------------------------------------------------------------------
void MenuMedcine()  { /* TODO: 医疗菜单 */ }
void MenuMedPoison() { /* TODO: 解毒菜单 */ }
bool MenuItem()     { /* TODO: 物品菜单 */ return false; }
int ReadItemList(int ItemType) { /* TODO */ return 0; }
void UseItem(int inum, int teammate) { /* TODO */ }
bool CanEquip(int rnum, int inum, int use) { /* TODO */ return false; }

void MenuStatus()
{
    // TODO: 显示角色状态
}

void ShowStatusByTeam(int tnum)
{
    // TODO: 按队伍显示状态
}

void ShowStatus(int rnum, int bnum)
{
    // TODO: 显示完整状态
}

void ShowSimpleStatus(int rnum, int x, int y, int forTeam)
{
    // TODO: 显示简明状态
}

void SetColorByPro(int Cur, int MaxValue, uint32& color1, uint32& color2)
{
    float ratio = (MaxValue > 0) ? (float)Cur / MaxValue : 0;
    if (ratio >= 0.7f)
    {
        color1 = MapRGBA(255, 255, 255);
        color2 = MapRGBA(0, 0, 0);
    }
    else if (ratio >= 0.3f)
    {
        color1 = MapRGBA(255, 255, 0);
        color2 = MapRGBA(0, 0, 0);
    }
    else
    {
        color1 = MapRGBA(255, 0, 0);
        color2 = MapRGBA(0, 0, 0);
    }
}

void MenuAbility() { /* TODO */ }
void ShowAbility(int rnum, int select, int showLeave) { /* TODO */ }
void MenuLeave()   { /* TODO */ }

void MenuSystem()
{
    std::string menuStr[] = { "讀取", "存檔", "設定", "離開" };
    int menu = CommonMenu(CENTER_X - 50, CENTER_Y - 60, 100, 3, 0, menuStr, 4);
    switch (menu)
    {
    case 0: MenuLoad(); break;
    case 1: MenuSave(); break;
    case 2: MenuSet(); break;
    case 3: MenuQuit(); break;
    }
}

void MenuSet() { /* TODO: 设置菜单 */ }

int MenuLoad()
{
    // TODO: 读档
    return -1;
}

int MenuLoadAtBeginning(int mode)
{
    // TODO: 开始时读档
    return -1;
}

bool LoadForSecondRound(int num) { return false; /* TODO */ }
void MenuSave() { /* TODO */ }

void MenuQuit()
{
    QuitConfirm();
}

//----------------------------------------------------------------------
// 效果函数
//----------------------------------------------------------------------
void EffectMedcine(int role1, int role2) { /* TODO */ }
void EffectMedPoison(int role1, int role2) { /* TODO */ }
void EatOneItem(int rnum, int inum) { /* TODO */ }

//----------------------------------------------------------------------
// CallEvent - 调用事件
//----------------------------------------------------------------------
void CallEvent(int num)
{
    if (KDEF_SCRIPT >= 1)
    {
        // 使用Lua脚本执行事件
        std::string filename = AppPath + EventScriptPath + std::to_string(CurScene) + "_" + std::to_string(num) + EventScriptExt;
        if (filefunc::fileExist(filename))
        {
            ExecScript(filename);
            return;
        }
    }

    // 使用KDEF二进制指令
    // TODO: 实现KDEF指令解析
}

void ReSetEntrance()
{
    memset(Entrance, -1, sizeof(Entrance));
    for (int i = 0; i < std::min(SceneAmount, 1002); i++)
    {
        if (Rscene[i].MainEntranceX1 >= 0 && Rscene[i].MainEntranceX1 < 480
            && Rscene[i].MainEntranceY1 >= 0 && Rscene[i].MainEntranceY1 < 480)
            Entrance[Rscene[i].MainEntranceX1][Rscene[i].MainEntranceY1] = (int16_t)i;
        if (Rscene[i].MainEntranceX2 >= 0 && Rscene[i].MainEntranceX2 < 480
            && Rscene[i].MainEntranceY2 >= 0 && Rscene[i].MainEntranceY2 < 480)
            Entrance[Rscene[i].MainEntranceX2][Rscene[i].MainEntranceY2] = (int16_t)i;
    }
}
void Maker() { /* TODO */ }

void ScrollTextAmi(std::vector<std::string>& words, int chnsize, int engsize, int linespace,
    int align, int alignx, int style, int delay, int picnum, int scrolldirect)
{
    // TODO: 滚动文字动画
}

void InitGrowth() { /* TODO */ }

void CloudCreate(int num)
{
    if (num < 0 || num >= (int)Cloud.size()) return;
    Cloud[num].Positionx = rand() % (CENTER_X * 2 + 400) - 200;
    Cloud[num].Positiony = rand() % (CENTER_Y * 2 + 200) - 100;
    Cloud[num].Speedx = rand() % 3 + 1;
    Cloud[num].Speedy = 0;
    Cloud[num].Picnum = rand() % std::max(1, CPicAmount);
    Cloud[num].Shadow = 0;
    Cloud[num].Alpha = rand() % 50 + 30;
    Cloud[num].mixColor = 0;
    Cloud[num].mixAlpha = 0;
}

void CloudCreateOnSide(int num)
{
    CloudCreate(num);
    Cloud[num].Positionx = -200;
}

bool IsCave(int snum)
{
    switch (MODVersion)
    {
    case 13:
        return snum == 6 || snum == 10 || snum == 26 || snum == 35 || snum == 52
            || snum == 71 || snum == 72 || snum == 78 || snum == 87 || snum == 107;
    case 31:
        return false;
    default:
        return snum == 5 || snum == 7 || snum == 10 || snum == 41 || snum == 42
            || snum == 46 || snum == 65 || snum == 66 || snum == 67 || snum == 72 || snum == 79;
    }
}

bool CheckString(const std::string& str)
{
    return !str.empty();
}

void SpecialFunction()
{
    std::string str = "輸入功能編號";
    DrawTextWithRect(str, CENTER_X + 120, CENTER_Y - 240 + 130, 128, 0, ColColor(0x23));
    std::string str2 = "f" + std::to_string(EnterNumber(0, 32767, CENTER_X + 120, CENTER_Y - 240 + 200, 0));
    ExecScript(AppPath + "script/1.lua", str2);
}
