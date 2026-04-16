// kys_main.cpp - 游戏主流程实现
// 对应 kys_main.pas

#include "kys_main.h"
#include "kys_battle.h"
#include "kys_draw.h"
#include "kys_engine.h"
#include "kys_event.h"
#include "kys_script.h"

#include <SDL3/SDL.h>
#include <SDL3_mixer/SDL_mixer.h>
#include <SDL3_ttf/SDL_ttf.h>

#include "INIReader.h"
#include "PotConv.h"
#include "SimpleCC.h"
#include "ZipFile.h"
#include "filefunc.h"
#include "strfunc.h"
#ifndef KYS_NO_MOVIE
#include "PotDll.h"
#endif
#include <zip.h>

// 在kys_engine.cpp中定义
extern std::string zip_express(zip_t* z, const std::string& filename);

#include <algorithm>
#include <cmath>
#include <cstring>
#include <format>
#include <fstream>

static std::vector<std::string> gLaunchArgs;

void SetLaunchArgs(int argc, char* argv[])
{
    gLaunchArgs.clear();
    if (argc <= 1 || argv == nullptr)
    {
        return;
    }
    gLaunchArgs.reserve(argc - 1);
    for (int i = 1; i < argc; ++i)
    {
        gLaunchArgs.emplace_back(argv[i] ? argv[i] : "");
    }
}

#ifdef __ANDROID__
#include <android/asset_manager.h>
#include <android/asset_manager_jni.h>
#include <android/log.h>
#include <jni.h>
#include <sys/stat.h>

static void mkdirp(const std::string& path)
{
    size_t pos = 0;
    while ((pos = path.find('/', pos + 1)) != std::string::npos)
        mkdir(path.substr(0, pos).c_str(), 0755);
    mkdir(path.c_str(), 0755);
}

// 递归提取APK assets到目标目录
static void extractAssetsRecursive(JNIEnv* env, jobject jAssetMgr, AAssetManager* nativeMgr,
    const std::string& assetPath, const std::string& outDir)
{
    jclass cls = env->GetObjectClass(jAssetMgr);
    jmethodID listMid = env->GetMethodID(cls, "list", "(Ljava/lang/String;)[Ljava/lang/String;");
    jstring jPath = env->NewStringUTF(assetPath.c_str());
    auto files = (jobjectArray)env->CallObjectMethod(jAssetMgr, listMid, jPath);
    env->DeleteLocalRef(jPath);
    if (!files) return;

    mkdirp(outDir);
    int count = env->GetArrayLength(files);
    for (int i = 0; i < count; i++)
    {
        auto jName = (jstring)env->GetObjectArrayElement(files, i);
        const char* name = env->GetStringUTFChars(jName, nullptr);
        std::string childAsset = assetPath.empty() ? std::string(name) : assetPath + "/" + name;
        std::string childOut = outDir + "/" + name;

        AAsset* asset = AAssetManager_open(nativeMgr, childAsset.c_str(), AASSET_MODE_STREAMING);
        if (asset)
        {
            FILE* f = fopen(childOut.c_str(), "wb");
            if (f)
            {
                char buf[65536];
                int nb;
                while ((nb = AAsset_read(asset, buf, sizeof(buf))) > 0)
                    fwrite(buf, 1, nb, f);
                fclose(f);
            }
            AAsset_close(asset);
        }
        else
        {
            extractAssetsRecursive(env, jAssetMgr, nativeMgr, childAsset, childOut);
        }
        env->ReleaseStringUTFChars(jName, name);
        env->DeleteLocalRef(jName);
    }
    env->DeleteLocalRef(files);
}

// 从APK assets提取game目录到内部存储
static void extractGameAssets(const std::string& targetDir, const std::string& versionName)
{
    JNIEnv* env = (JNIEnv*)SDL_GetAndroidJNIEnv();
    jobject activity = (jobject)SDL_GetAndroidActivity();
    jclass cls = env->GetObjectClass(activity);
    jmethodID mid = env->GetMethodID(cls, "getAssets", "()Landroid/content/res/AssetManager;");
    jobject jAssetMgr = env->CallObjectMethod(activity, mid);
    AAssetManager* nativeMgr = AAssetManager_fromJava(env, jAssetMgr);

    __android_log_print(ANDROID_LOG_INFO, "kys", "Extracting game assets to %s ...", targetDir.c_str());
    // assets根目录即为game内容, 从asset根提取
    extractAssetsRecursive(env, jAssetMgr, nativeMgr, "", targetDir);

    // 写版本标记
    std::string verFile = targetDir + "/.asset_version";
    FILE* vf = fopen(verFile.c_str(), "w");
    if (vf) { fputs(versionName.c_str(), vf); fclose(vf); }
    __android_log_print(ANDROID_LOG_INFO, "kys", "Asset extraction complete.");
}

// 检查是否需要提取assets
static bool needExtractAssets(const std::string& targetDir, const std::string& versionName)
{
    std::string verFile = targetDir + "/.asset_version";
    FILE* f = fopen(verFile.c_str(), "r");
    if (!f) return true;
    char buf[128] = {};
    fgets(buf, sizeof(buf), f);
    fclose(f);
    return std::string(buf) != versionName;
}
#endif // __ANDROID__

// potdll前向声明 (动态加载)
//static void* (*PotCreateFromWindow)(SDL_Window*) = nullptr;

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
    {
        // 资源文件已打包在APK assets中, 首次运行时提取到app内部存储
        const char* intPath = SDL_GetAndroidInternalStoragePath();
        std::string basePath(intPath);
        AppPath = basePath + "/game/";
        CellPhone = 1;
        SDL_SetHint(SDL_HINT_ORIENTATIONS, "LandscapeLeft LandscapeRight");
        std::string assetVer = "1.0";  // 更新资源时修改此版本号
        if (needExtractAssets(AppPath, assetVer))
        {
            extractGameAssets(AppPath, assetVer);
        }
    }
#else
    AppPath = "../game/";
#endif

    // Pascal behavior: first arg appends to "../game" (e.g. "0" -> "../game0/").
    if (!gLaunchArgs.empty())
    {
        if (!AppPath.empty() && (AppPath.back() == '/' || AppPath.back() == '\\'))
        {
            AppPath.pop_back();
        }
        AppPath += gLaunchArgs[0] + "/";
    }

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
        if (RENDERER == 1)
        {
            render_str = "opengl";
        }
        if (RENDERER == 2)
        {
            render_str = "software";
        }
    }
    else
    {
        render_str = "";
    }

    if (RENDERER == 2)
    {
        SMOOTH = 0;
    }

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
        if (RESOLUTIONY > RESOLUTIONX)
        {
            ScreenRotate = 0;
        }
    }

    kyslog("Creating renderer");
    render = SDL_CreateRenderer(window, render_str);

    SDL_RenderClear(render);
    SDL_RenderPresent(render);

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
#ifndef KYS_NO_MOVIE
    smallpot = PotCreateFromWindow(window);
#endif
    Start();
    Quit();
}

//----------------------------------------------------------------------
// Quit - 关闭所有资源并退出
//----------------------------------------------------------------------
void Quit()
{
    if (SDL_JoystickConnected(joy))
    {
        SDL_CloseJoystick(joy);
    }
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
    TitleString = "Legend of Little Village III - 108 Brothers and Sisters (c++)";

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
        BEGIN_EVENT = 691;
        BEGIN_SCENE = 70;
        MONEY_ID = 174;
        COMPASS_ID = 182;
        BEGIN_LEAVE_EVENT = 100;
        BEGIN_NAME_IN_TALK = 4021;
        MAX_LOVER = 0;
        BEGIN_Sx = 13;
        BEGIN_Sy = 54;
        break;
    case 13:
        // 默认: 小猪3
        break;
    case 31:
        TitleString = "Wider rivers and deeper lakes";
        versionstr += "-再战江湖";
        BEGIN_EVENT = 691;
        BEGIN_SCENE = 70;
        MONEY_ID = 174;
        COMPASS_ID = 182;
        BEGIN_LEAVE_EVENT = 1;
        BEGIN_NAME_IN_TALK = 8015;
        MAX_LOVER = 0;
        BEGIN_Sx = 13;
        BEGIN_Sy = 54;
        break;
    case 41:
        TitleString = "PTT";
        versionstr += "-乡民闯江湖";
        BEGIN_EVENT = 691;
        BEGIN_SCENE = 70;
        MONEY_ID = 174;
        COMPASS_ID = 182;
        BEGIN_LEAVE_EVENT = 1050;
        BEGIN_NAME_IN_TALK = 5693;
        MAX_LOVER = 0;
        BEGIN_Sx = 20;
        BEGIN_Sy = 19;
        break;
    case 81:
        TitleString = "Liang Yu Sheng";
        versionstr = " 梁羽生群侠传";
        BEGIN_EVENT = 1;
        BEGIN_SCENE = 0;
        MONEY_ID = 174;
        COMPASS_ID = 182;
        BEGIN_LEAVE_EVENT = 1;
        BEGIN_NAME_IN_TALK = 8015;
        MAX_LOVER = 0;
        StartMusic = 0;
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
    {
        Quit();
    }

    INIReaderNormal ini;
    ini.loadFile(iniFilename);
    kyslog("Find ini file: %s", iniFilename.c_str());

    if (CellPhone == 0)
    {
        CellPhone = ini.getInt("system", "CellPhone", 0);
    }
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
    //TRY_FIND_GRP = ini.getInt("system", "TRY_FIND_GRP", 0);
    //PNG_LOAD_ALL = ini.getInt("system", "PNG_LOAD_ALL", 0);
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

    if (KEEP_SCREEN_RATIO == 0)
    {
        TEXT_LAYER = 0;
    }

    if (!filefunc::fileExist(AppPath + "save/ranger.grp"))
    {
        ZIP_SAVE = 1;
    }
    if (KDEF_SCRIPT == 2 && !filefunc::fileExist(AppPath + "script/event.imz"))
    {
        KDEF_SCRIPT = 1;
    }
    if (DISABLE_MENU_AMI != 0)
    {
        DISABLE_MENU_AMI = 25;
    }

    // 最大属性值表
    MaxProList[43] = 999;    // 攻击 (Data[43])
    MaxProList[44] = 500;    // 轻功 (Data[44])
    MaxProList[45] = 999;    // 防御 (Data[45])
    MaxProList[46] = 200;    // 医疗 (Data[46])
    MaxProList[47] = 100;    // 用毒 (Data[47])
    MaxProList[48] = 100;    // 解毒 (Data[48])
    MaxProList[49] = 100;    // 抗毒 (Data[49])
    MaxProList[50] = 999;    // 拳掌 (Data[50])
    MaxProList[51] = 999;    // 御剑 (Data[51])
    MaxProList[52] = 999;    // 耍刀 (Data[52])
    MaxProList[53] = 999;    // 特殊 (Data[53])
    MaxProList[54] = 999;    // 暗器 (Data[54])
    MaxProList[55] = 100;    // 常识 (Data[55])
    MaxProList[56] = 100;    // 品德 (Data[56])
    MaxProList[57] = 100;    // 带毒 (Data[57])
    MaxProList[58] = 200;    // 移动 (Data[58])

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
    {
        BattleNames[i] = WarStaList[i].Name;
    }

    // 载入对话
    {
        std::string content = filefunc::readFileToString(AppPath + "resource/talk1.txt");
        auto lines = strfunc::splitString(content, "\n");
        TDEF.clear();
        for (auto& line : lines)
        {
            TDEF.push_back(line);
        }
    }

    // 情侣加成字串
    loverstrs.resize(10);
    loverstrs[0] = "攻擊";
    loverstrs[1] = "防禦";
    loverstrs[2] = "移動";
    loverstrs[3] = "避毒";
    loverstrs[4] = "強武";
    loverstrs[5] = "強內";
    loverstrs[6] = "代傷";
    loverstrs[7] = "回命";
    loverstrs[8] = "回內";
    loverstrs[9] = "輕功";

    // 状态字串
    statestrs.resize(34);
    statestrs[0] = "攻擊";
    statestrs[1] = "防禦";
    statestrs[2] = "輕功";
    statestrs[3] = "移動";
    statestrs[4] = "傷害";
    statestrs[5] = "回命";
    statestrs[6] = "回內";
    statestrs[7] = "戰神";
    statestrs[8] = "風雷";
    statestrs[9] = "孤注";
    statestrs[10] = "傾國";
    statestrs[11] = "毒箭";
    statestrs[12] = "遠攻";
    statestrs[13] = "連擊";
    statestrs[14] = "反傷";
    statestrs[15] = "靈精";
    statestrs[16] = "閃避";
    statestrs[17] = "博采";
    statestrs[18] = "聆音";
    statestrs[19] = "青翼";
    statestrs[20] = "回體";
    statestrs[21] = "傷逝";
    statestrs[22] = "黯然";
    statestrs[23] = "慈悲";
    statestrs[24] = "悲歌";
    statestrs[26] = "定身";
    statestrs[27] = "控制";
    statestrs[28] = "混亂";
    statestrs[29] = "拳理";
    statestrs[30] = "劍意";
    statestrs[31] = "刀氣";
    statestrs[32] = "奇兵";
    statestrs[33] = "狙擊";

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
    if (cct2s)
    {
        delete (SimpleCC*)cct2s;
        cct2s = nullptr;
    }
    if (ccs2t)
    {
        delete (SimpleCC*)ccs2t;
        ccs2t = nullptr;
    }

    auto* t2s = new SimpleCC();
    t2s->init({
        AppPath + "cc/TSCharacters.txt",
        AppPath + "cc/TSPhrases.txt"
        });
    cct2s = t2s;

    auto* s2t = new SimpleCC();
    s2t->init({
        AppPath + "cc/STCharacters.txt",
        AppPath + "cc/STPhrases.txt"
        });
    ccs2t = s2t;
}

//----------------------------------------------------------------------
// Start - 显示开头画面和标题菜单
//----------------------------------------------------------------------
void Start()
{
    Where = 4;
    LoadPNGTiles("resource/title", TitlePNGIndex, 1);
    InitialPicArrays();

    ReadingTiles = true;

    kyslog("Play movie and start music");
    if (OPEN_MOVIE == 1)
    {
        PlayMovie(AppPath + "movie/1.wmv");
    }
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
    {
        CloudCreate(i);
    }

    NewStartAmi();

    // 标题菜单
    LoadR(0);
    int menu = 0;
    bool Selected = false;
    int headnum = 0, alpha = 255, alphastep = -5;

    while (SDL_PollEvent(&event) || true)
    {
        Redraw();

        if (alpha >= 255)
        {
            alphastep = -5;
        }
        if (alpha <= 0)
        {
            alphastep = 5;
        }
        alpha += alphastep;
        if (alpha >= 255)
        {
            headnum = rand() % (MODVersion == 13 ? 412 : std::max(1, HPicAmount));
        }

        int x = CENTER_X - 80;
        int y = CENTER_Y - 30;
        int maxm = 3;
        for (int i = 0; i <= maxm; i++)
        {
            DrawTPic(16, x - 40, y + i * 50, nullptr, 0, 191, 0, 0);
            if (i != menu)
            {
                DrawTPic(3 + i, x, y + 50 * i);
            }
            else
            {
                DrawTPic(23 + i, x, y + 50 * i);
            }
        }
        UpdateAllScreen();
        CheckBasicEvent();

        switch (event.type)
        {
        case SDL_EVENT_KEY_UP:
            if (event.key.key == SDLK_RETURN || event.key.key == SDLK_SPACE)
            {
                Selected = true;
            }
            break;
        case SDL_EVENT_KEY_DOWN:
            if (event.key.key == SDLK_UP)
            {
                menu--;
                if (menu < 0)
                {
                    menu = maxm;
                }
            }
            if (event.key.key == SDLK_DOWN)
            {
                menu++;
                if (menu > maxm)
                {
                    menu = 0;
                }
            }
            break;
        case SDL_EVENT_MOUSE_BUTTON_UP:
            if (event.button.button == SDL_BUTTON_LEFT && MouseInRegion(x, y, 300, 200))
            {
                Selected = true;
            }
            break;
        case SDL_EVENT_MOUSE_MOTION:
        {
            int x1, y1;
            if (MouseInRegion(x, y, 300, 200, x1, y1))
            {
                menu = std::min(maxm, (y1 - y) / 50);
            }
            break;
        }
        }
        CleanKeyValue();
        SDL_Delay(40);

        if (Selected)
        {
            switch (menu)
            {
            case 3: return;    // 退出
            case 1:
                if (MenuLoadAtBeginning(0) >= 0)
                {
                    CurEvent = -1;
                    if (Where == 1)
                    {
                        WalkInScene(0);
                    }
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
        DrawTPic(9, x, y, nullptr, 0, i * 255 / 20);
        UpdateAllScreen();
        SDL_Delay(20);
        SDL_PollEvent(&event);
        CheckBasicEvent();
        if ((event.type == SDL_EVENT_KEY_UP && event.key.key == SDLK_ESCAPE) || (event.type == SDL_EVENT_MOUSE_BUTTON_UP && event.button.button == SDL_BUTTON_RIGHT))
        {
            return;
        }
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
        if ((event.type == SDL_EVENT_KEY_UP && event.key.key == SDLK_ESCAPE) || (event.type == SDL_EVENT_MOUSE_BUTTON_UP && event.button.button == SDL_BUTTON_RIGHT))
        {
            return;
        }
    }

    SDL_Rect src;
    src.x = 0;
    src.y = 0;
    src.w = TitlePNGIndex[12].w;
    src.h = TitlePNGIndex[12].h;
    for (int i = 0; i <= 89; i++)
    {
        Redraw();
        src.w = i * 5 + 50;
        if (src.w > 490)
        {
            break;
        }
        DrawTPic(12, x + 2, y + 10, &src);
        DrawTPic(10, x, y);
        DrawTPic(10, x + i * 5 + 34, y);
        UpdateAllScreen();
        SDL_Delay(20);
        SDL_PollEvent(&event);
        CheckBasicEvent();
        if ((event.type == SDL_EVENT_KEY_UP && event.key.key == SDLK_ESCAPE) || (event.type == SDL_EVENT_MOUSE_BUTTON_UP && event.button.button == SDL_BUTTON_RIGHT))
        {
            return;
        }
    }

    x = CENTER_X - 80;
    Where = 3;
    for (int i = 0; i <= 2; i++)
    {
        Redraw();
        DrawTPic(14 + i, x - 40, CENTER_Y - 30, nullptr, 0, 64);
        DrawTPic(14 + i, x - 40, CENTER_Y - 30 + 50, nullptr, 0, 128);
        DrawTPic(14 + i, x - 40, CENTER_Y - 30 + 100, nullptr, 0, 191);
        DrawTPic(14 + i, x - 40, CENTER_Y - 30 + 150, nullptr, 0, 255);
        UpdateAllScreen();
        SDL_Delay(20);
        SDL_PollEvent(&event);
        CheckBasicEvent();
        if ((event.type == SDL_EVENT_KEY_UP && event.key.key == SDLK_ESCAPE) || (event.type == SDL_EVENT_MOUSE_BUTTON_UP && event.button.button == SDL_BUTTON_RIGHT))
        {
            return;
        }
    }

    for (int i = 0; i <= 20; i++)
    {
        Redraw();
        for (int j = 0; j <= 3; j++)
        {
            DrawTPic(16, x - 40, CENTER_Y - 30 + j * 50, nullptr, 0, 191);
            DrawTPic(3 + j, x, CENTER_Y - 30 + j * 50, nullptr, 0, i * 255 / 20, 0, 0);
        }
        UpdateAllScreen();
        SDL_Delay(20);
        SDL_PollEvent(&event);
        CheckBasicEvent();
        if ((event.type == SDL_EVENT_KEY_UP && event.key.key == SDLK_ESCAPE) || (event.type == SDL_EVENT_MOUSE_BUTTON_UP && event.button.button == SDL_BUTTON_RIGHT))
        {
            return;
        }
    }
    Where = 3;
    kyslog("begin end");
}

void StartAmi()
{
    if (OPEN_RECITATION == 0)
    {
        return;
    }
    // 读取开头文字
    std::vector<std::string> words;
    std::ifstream ifs(AppPath + "txt/start.txt");
    if (ifs.is_open())
    {
        std::string line;
        while (std::getline(ifs, line))
        {
            words.push_back(line);
        }
        ifs.close();
    }
    CleanTextScreen();
    instruct_14();
    if (18 <= (int)TitlePNGIndex.size() - 1)
    {
        for (int i = 20; i >= 0; i--)
        {
            Redraw();
            DrawTPic(18, -TitlePNGIndex[18].w + CENTER_X * 2, 0, nullptr, 0, 255 - i * 255 / 20);
            UpdateAllScreen();
            SDL_Delay(20);
            SDL_PollEvent(&event);
        }
    }
    PlayMP3(60, 0);
    ScrollTextAmi(words, 20, 18, 25, 0, 0, 1, 200, 18, 0);
    PlayMP3(StartMusic, -1);
    CleanTextScreen();
    instruct_14();
}

//----------------------------------------------------------------------
// InitialRole - 初始化主角
//----------------------------------------------------------------------
bool InitialRole()
{
    LoadR(0);
    std::string input_name = (SIMPLE == 1) ? "萧笑竹" : "蕭笑竹";

    Redraw();
    RecordFreshScreen();
    UpdateAllScreen();
    bool result = EnterString(input_name, CENTER_X - 163, CENTER_Y + 10, 86, 100);
    FreeFreshScreen();

    if (FULLSCREEN == 1)
    {
        Redraw();
        UpdateAllScreen();
    }
    result = result && !input_name.empty();
    if (result)
    {
        std::string fullname = Simplified2Traditional(input_name);
        memset(Rrole[0].Name, 0, 20);
        int len = std::min((int)fullname.size(), 12);
        memcpy(Rrole[0].Name, fullname.c_str(), len);

        std::string surname, givenname;
        DivideName((char*)Rrole[0].Name, surname, givenname);
        Redraw();
        do
        {
            Rrole[0].MaxHP = 100 + rand() % 26;
            Rrole[0].CurrentHP = Rrole[0].MaxHP;
            Rrole[0].MaxMP = 100 + rand() % 26;
            Rrole[0].CurrentMP = Rrole[0].MaxMP;
            Rrole[0].MPType = rand() % 2;
            Rrole[0].IncLife = 1 + rand() % 10;
            Rrole[0].Attack = 30 + rand() % 6;
            Rrole[0].Speed = 30 + rand() % 6;
            Rrole[0].Defence = 30 + rand() % 6;
            Rrole[0].Medcine = 25 + rand() % 6;
            Rrole[0].UsePoi = 25 + rand() % 6;
            Rrole[0].MedPoi = 25 + rand() % 6;
            Rrole[0].Fist = 25 + rand() % 6;
            Rrole[0].Sword = 25 + rand() % 6;
            Rrole[0].Knife = 25 + rand() % 6;
            Rrole[0].Unusual = 25 + rand() % 6;
            Rrole[0].HidWeapon = 25 + rand() % 6;
            Rrole[0].Aptitude = 50 + rand() % 40;
            if (MODVersion != 13)
            {
                Rrole[0].Aptitude = rand() % 100;
            }
            Redraw();
            ShowStatus(0);
            DrawTextWithRect("資質", 150, CENTER_Y + 120, 80, 0, 0x202020, 179, 0);
            auto buf = std::format("{:4d}", Rrole[0].Aptitude);
            DrawEngShadowText(buf, 200, CENTER_Y + 123, ColColor(0x64), ColColor(0x66));
            DrawTextWithRect("選定屬性后按回車或這裡確認", 175, CENTER_Y + 171, 260, 0, 0, 255);
            UpdateAllScreen();
            int i = WaitAnyKey();
            if (i == SDLK_RETURN || i == SDLK_Y || (MouseInRegion(175, CENTER_Y + 171, 260, 22) && i != SDLK_ESCAPE))
            {
                break;
            }
            if (i == SDLK_ESCAPE) { return false; }
        } while (true);    // repeat until Enter/Y/click

        InitGrowth();
        if (MODVersion == 0 || MODVersion == 13 || MODVersion == 31 || MODVersion == 12 || MODVersion == 41)
        {
            if (input_name == "曹輕羽")
            {
                Rrole[0].MaxHP = 125;
                Rrole[0].CurrentHP = 125;
                Rrole[0].MaxMP = 125;
                Rrole[0].CurrentMP = 125;
                Rrole[0].MPType = 2;
                Rrole[0].IncLife = 28;
                Rrole[0].AddMP = 28;
                Rrole[0].AddAtk = 8;
                Rrole[0].AddDef = 8;
                Rrole[0].AddSpeed = 4;
                Rrole[0].Attack = 35;
                Rrole[0].Speed = 35;
                Rrole[0].Defence = 35;
                Rrole[0].Medcine = 30;
                Rrole[0].UsePoi = 30;
                Rrole[0].MedPoi = 30;
                Rrole[0].Fist = 30;
                Rrole[0].Sword = 30;
                Rrole[0].Knife = 30;
                Rrole[0].Unusual = 30;
                Rrole[0].HidWeapon = 30;
                Rrole[0].Aptitude = 100;
                Rrole[0].MagLevel[0] = 999;
            }
            if (input_name == "小小豬")
            {
                Rrole[0].addnum = 1;
                Rrole[0].Aptitude = 100;
                Rrole[0].MagLevel[0] = 999;
                Rrole[0].AmiFrameNum[0] = 2;
                if (MODVersion == 31)
                {
                    Rrole[0].HeadNum = 448;
                }
            }
        }
        Redraw();
        ShowStatus(0);
        UpdateAllScreen();
        if (MODVersion == 13)
        {
            StartAmi();
        }
        instruct_14();
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
    {
        dst[i] = src[i];
    }
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

    std::string filenamer = (num == 0) ? "ranger.grp" : ("r" + s + ".grp");
    std::string filenames = (num == 0) ? "allsin.grp" : ("s" + s + ".grp");
    std::string filenamed = (num == 0) ? "alldef.grp" : ("d" + s + ".grp");

    std::vector<char> pbuf(LenR + 8192, 0);

    if (ZIP_SAVE == 0)
    {
        std::string fr = AppPath + "save/" + filenamer;
        std::string fs = AppPath + "save/" + filenames;
        std::string fd = AppPath + "save/" + filenamed;
        if (filefunc::fileExist(fr) && filefunc::fileExist(fs) && filefunc::fileExist(fd))
        {
            auto dr = filefunc::readFileToString(fr);
            memcpy(pbuf.data(), dr.data(), std::min((int)dr.size(), LenR));
            auto ds = filefunc::readFileToString(fs);
            memcpy(&SData[0], ds.data(), std::min((int)ds.size(), (int)sizeof(SData)));
            auto dd = filefunc::readFileToString(fd);
            memcpy(&DData[0], dd.data(), std::min((int)dd.size(), (int)sizeof(DData)));
        }
        else
        {
            return false;
        }
    }
    else
    {
        zip_t* z = zip_open(zfilename.c_str(), ZIP_RDONLY, nullptr);
        if (z)
        {
            std::string dr = zip_express(z, filenamer);
            if (dr.empty())
            {
                zip_close(z);
                return false;
            }
            memcpy(pbuf.data(), dr.data(), std::min((int)dr.size(), LenR));
            std::string ds = zip_express(z, filenames);
            if (!ds.empty())
            {
                memcpy(&SData[0], ds.data(), std::min((int)ds.size(), (int)sizeof(SData)));
            }
            std::string dd = zip_express(z, filenamed);
            if (!dd.empty())
            {
                memcpy(&DData[0], dd.data(), std::min((int)dd.size(), (int)sizeof(DData)));
            }
            zip_close(z);
        }
        else
        {
            return false;
        }
    }

    // 解析主数据
    char* p = pbuf.data();
    bool isold = false;
    int intsize = 4;

    BufferRead(p, (char*)&InShip, intsize);
    BufferRead(p, (char*)&Useless1, intsize);
    BufferRead(p, (char*)&My, intsize);
    BufferRead(p, (char*)&Mx, intsize);
    BufferRead(p, (char*)&Sy, intsize);
    BufferRead(p, (char*)&Sx, intsize);
    BufferRead(p, (char*)&MFace, intsize);
    BufferRead(p, (char*)&ShipX, intsize);
    BufferRead(p, (char*)&ShipY, intsize);
    BufferRead(p, (char*)&ShipX1, intsize);
    BufferRead(p, (char*)&ShipY1, intsize);
    BufferRead(p, (char*)&ShipFace, intsize);

    if (My > 65536)
    {
        isold = true;
        intsize = 2;
        p = pbuf.data();
        BufferRead16to32(p, (char*)&InShip, intsize);
        BufferRead16to32(p, (char*)&Useless1, intsize);
        BufferRead16to32(p, (char*)&My, intsize);
        BufferRead16to32(p, (char*)&Mx, intsize);
        BufferRead16to32(p, (char*)&Sy, intsize);
        BufferRead16to32(p, (char*)&Sx, intsize);
        BufferRead16to32(p, (char*)&MFace, intsize);
        BufferRead16to32(p, (char*)&ShipX, intsize);
        BufferRead16to32(p, (char*)&ShipY, intsize);
        BufferRead16to32(p, (char*)&ShipX1, intsize);
        BufferRead16to32(p, (char*)&ShipY1, intsize);
        BufferRead16to32(p, (char*)&ShipFace, intsize);
    }

    if (isold)
    {
        int16_t temp[6];
        for (int i = 0; i < 6; i++)
        {
            BufferRead(p, (char*)&temp[i], intsize);
            TeamList[i] = temp[i];
        }
        for (int i = 0; i < MAX_ITEM_AMOUNT; i++)
        {
            int16_t tnum;
            BufferRead(p, (char*)&tnum, 2);
            RItemList[i].Number = tnum;
            BufferRead(p, (char*)&RItemList[i].Amount, 4);
        }
    }
    else
    {
        BufferRead(p, (char*)&TeamList[0], intsize * 6);
        BufferRead(p, (char*)&RItemList[0], (int)(sizeof(TItemList) * MAX_ITEM_AMOUNT));
    }

    std::vector<int> temp32;
    if (isold)
    {
        // 旧版16位数据转32位
        int remain = LenR - RoleOffset;
        std::vector<int16_t> temp16(remain / 2);
        memcpy(temp16.data(), p, remain);
        temp32.resize(remain / 4);
        for (int i = 0; i < (int)temp32.size(); i++)
        {
            temp32[i] = (i < (int)temp16.size()) ? temp16[i] : 0;
        }
        p = (char*)temp32.data();
    }

    BufferRead(p, (char*)&Rrole[0], ItemOffset - RoleOffset);
    if (num == 0 || MODVersion == 13 || MODVersion == 31)
    {
        BufferRead(p, (char*)&Ritem[0], SceneOffset - ItemOffset);
    }
    else
    {
        p += SceneOffset - ItemOffset;
    }
    BufferRead(p, (char*)&Rscene[0], MagicOffset - SceneOffset);
    if (num == 0 || MODVersion == 31)
    {
        BufferRead(p, (char*)&Rmagic[0], WeiShopOffset - MagicOffset);
    }
    else
    {
        p += WeiShopOffset - MagicOffset;
    }
    BufferRead(p, (char*)&RShop[0], LenR - WeiShopOffset);

    // 设置位置和场景
    if (ShipX1 >= 0)
    {
        CurScene = ShipX1;
        Where = 1;
    }
    else
    {
        CurScene = -1;
        Where = 0;
    }

    if (num == 0)
    {
        Where = 3;
        CurScene = BEGIN_SCENE;
        Sx = BEGIN_Sx;
        Sy = BEGIN_Sy;
    }

    ReSetEntrance();
    RoleName[0] = (char*)Rrole[0].Name;

    if (MODVersion == 13)
    {
        BEGIN_MISSION_NUM = Rrole[650].Data[0];
        MissionStr.resize(MISSION_AMOUNT);
        for (int i = 0; i < MISSION_AMOUNT; i++)
        {
            std::vector<uint8_t> talkarray;
            ReadTalk(BEGIN_MISSION_NUM + i, talkarray);
            MissionStr[i] = (char*)talkarray.data();
        }
    }

    ScreenBlendMode = 0;
    ShowMR = true;

    // 特别修正
    if (num == 0)
    {
        memcpy(&Rrole0[0], &Rrole[0], sizeof(TRole) * 1001);
        memcpy(&Rscene0[0], &Rscene[0], sizeof(TScene) * 1001);
        for (int i = 0; i <= 1000; i++)
        {
            if (MODVersion == 13)
            {
                if (i != 168 && i != 169 && i != 119 && i != 120 && i != 166 && i != 167)
                {
                    CorrectMagic(i);
                }
            }
            else
            {
                CorrectMagic(i);
            }
        }
    }
    else
    {
        if (MODVersion == 13)
        {
            Rrole[168].Data[73] = 97;
            Rrole[168].Data[63] = 121;
            Rrole[8].AmiFrameNum[0] = 3;
            Rrole[13].AmiFrameNum[0] = 5;
        }
        if (MODVersion != 13)
        {
            for (int i = 0; i <= 1000; i++)
            {
                if (Rrole[i].Level <= 0)
                {
                    break;
                }
                if (Rrole[i].PracticeBook >= 0)
                {
                    Ritem[Rrole[i].PracticeBook].User = i;
                }
                if (Rrole[i].Equip[0] >= 0)
                {
                    Ritem[Rrole[i].Equip[0]].User = i;
                }
                if (Rrole[i].Equip[1] >= 0)
                {
                    Ritem[Rrole[i].Equip[1]].User = i;
                }
            }
        }
    }
    return true;
}

bool SaveR(int num)
{
    SaveNum = num;
    if (Where == 1)
    {
        ShipX1 = CurScene;
    }
    else
    {
        ShipX1 = -1;
    }

    std::vector<char> pbuf(LenR + 4, 0);
    char* p = pbuf.data();

    BufferWrite(p, (char*)&InShip, 4);
    BufferWrite(p, (char*)&Useless1, 4);
    BufferWrite(p, (char*)&My, 4);
    BufferWrite(p, (char*)&Mx, 4);
    BufferWrite(p, (char*)&Sy, 4);
    BufferWrite(p, (char*)&Sx, 4);
    BufferWrite(p, (char*)&MFace, 4);
    BufferWrite(p, (char*)&ShipX, 4);
    BufferWrite(p, (char*)&ShipY, 4);
    BufferWrite(p, (char*)&ShipX1, 4);
    BufferWrite(p, (char*)&ShipY1, 4);
    BufferWrite(p, (char*)&ShipFace, 4);
    BufferWrite(p, (char*)&TeamList[0], 4 * 6);
    BufferWrite(p, (char*)&RItemList[0], (int)(sizeof(TItemList) * MAX_ITEM_AMOUNT));

    BufferWrite(p, (char*)&Rrole[0], ItemOffset - RoleOffset);
    BufferWrite(p, (char*)&Ritem[0], SceneOffset - ItemOffset);
    BufferWrite(p, (char*)&Rscene[0], MagicOffset - SceneOffset);
    BufferWrite(p, (char*)&Rmagic[0], WeiShopOffset - MagicOffset);
    BufferWrite(p, (char*)&RShop[0], LenR - WeiShopOffset);

    std::string s = (num > 0 && ZIP_SAVE == 1) ? "1" : std::to_string(num);
    std::string filenamer = (num == 0) ? "ranger.grp" : ("r" + s + ".grp");
    std::string filenames = (num == 0) ? "allsin.grp" : ("s" + s + ".grp");
    std::string filenamed = (num == 0) ? "alldef.grp" : ("d" + s + ".grp");

    if (ZIP_SAVE == 0)
    {
        std::ofstream fr(AppPath + "save/" + filenamer, std::ios::binary);
        if (!fr)
        {
            return false;
        }
        fr.write(pbuf.data(), LenR);
        fr.close();
        std::ofstream fs(AppPath + "save/" + filenames, std::ios::binary);
        if (fs)
        {
            fs.write((char*)&SData[0], sizeof(SData));
            fs.close();
        }
        std::ofstream fd(AppPath + "save/" + filenamed, std::ios::binary);
        if (fd)
        {
            fd.write((char*)&DData[0], sizeof(DData));
            fd.close();
        }
    }
    else
    {
        std::string zfilename = AppPath + "save/" + std::to_string(num) + ".zip";
        zip_t* z = zip_open(zfilename.c_str(), ZIP_CREATE | ZIP_TRUNCATE, nullptr);
        if (!z)
        {
            return false;
        }

        zip_source_t* src_r = zip_source_buffer(z, pbuf.data(), LenR, 0);
        if (src_r)
        {
            zip_file_add(z, filenamer.c_str(), src_r, ZIP_FL_OVERWRITE);
        }

        zip_source_t* src_s = zip_source_buffer(z, &SData[0], sizeof(SData), 0);
        if (src_s)
        {
            zip_file_add(z, filenames.c_str(), src_s, ZIP_FL_OVERWRITE);
        }

        zip_source_t* src_d = zip_source_buffer(z, &DData[0], sizeof(DData), 0);
        if (src_d)
        {
            zip_file_add(z, filenamed.c_str(), src_d, ZIP_FL_OVERWRITE);
        }

        zip_close(z);
    }
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
        {
            if (event.key.key != 0 || event.button.button != 0)
            {
                break;
            }
        }
        SDL_Delay(20);
    }
    int result = event.key.key;
    if (event.type == SDL_EVENT_MOUSE_BUTTON_UP)
    {
        if (event.button.button == SDL_BUTTON_LEFT)
        {
            result = SDLK_SPACE;
        }
        if (event.button.button == SDL_BUTTON_RIGHT)
        {
            result = SDLK_ESCAPE;
        }
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
    if (Where >= 3)
    {
        return;
    }
    uint32_t next_time = SDL_GetTicks();
    uint32_t next_time2 = SDL_GetTicks();
    uint32_t next_time3 = SDL_GetTicks();

    int Mx1 = 0, My1 = 0;
    Where = 0;
    int walking = 0;
    int speed = 0;
    int stillcount = 0;
    int axp = 0, ayp = 0, axp1 = 0, ayp1 = 0;
    int gotoEntrance = -1;
    int x1, y1;

    DrawMMap();
    UpdateAllScreen();
    Still = 0;
    MStep = 0;

    while (SDL_PollEvent(&event) || true)
    {
        if (Where >= 3)
        {
            break;
        }

        // 闪烁效果
        uint32_t now = SDL_GetTicks();
        if ((int)(now - next_time2) > 0)
        {
            next_time2 = now + 200;
        }

        // 飘云
        if ((int)(now - next_time3) > 0 && MMAPAMI > 0)
        {
            for (int i = 0; i < CLOUD_AMOUNT; i++)
            {
                Cloud[i].Positionx += Cloud[i].Speedx;
                Cloud[i].Positiony += Cloud[i].Speedy;
                if (Cloud[i].Positionx > 17279 || Cloud[i].Positionx < 0 ||
                    Cloud[i].Positiony > 8639 || Cloud[i].Positiony < 0)
                {
                    CloudCreateOnSide(i);
                }
            }
            next_time3 = now + 40;
        }

        // 主角动作
        if ((int)(now - next_time) > 0 && Where == 0)
        {
            if (walking == 0)
            {
                stillcount++;
            }
            else
            {
                stillcount = 0;
            }
            next_time = now + 320;
        }

        CheckBasicEvent();
        switch (event.type)
        {
        case SDL_EVENT_KEY_DOWN:
        {
            if (event.key.key == SDLK_LEFT)
            {
                MFace = 2;
                walking = 1;
            }
            if (event.key.key == SDLK_RIGHT)
            {
                MFace = 1;
                walking = 1;
            }
            if (event.key.key == SDLK_UP)
            {
                MFace = 0;
                walking = 1;
            }
            if (event.key.key == SDLK_DOWN)
            {
                MFace = 3;
                walking = 1;
            }
            break;
        }
        case SDL_EVENT_KEY_UP:
        {
            if (*keyup == 0 && *keydown == 0 && *keyleft == 0 && *keyright == 0)
            {
                walking = 0;
                speed = 0;
            }
            if (event.key.key == SDLK_ESCAPE)
            {
                MenuEsc();
                if (Where >= 3)
                {
                    break;
                }
            }
            if (event.key.key == SDLK_TAB)
            {
                SpecialFunction();
            }
            break;
        }
        case SDL_EVENT_MOUSE_MOTION:
        {
            if (ShowVirtualKey == 0)
            {
                SDL_GetMouseState2(x1, y1);
                if (x1 < CENTER_X && y1 < CENTER_Y)
                {
                    MFace = 2;
                }
                if (x1 > CENTER_X && y1 < CENTER_Y)
                {
                    MFace = 0;
                }
                if (x1 < CENTER_X && y1 > CENTER_Y)
                {
                    MFace = 3;
                }
                if (x1 > CENTER_X && y1 > CENTER_Y)
                {
                    MFace = 1;
                }
            }
            break;
        }
        case SDL_EVENT_MOUSE_BUTTON_UP:
        {
            if (event.button.button == SDL_BUTTON_RIGHT)
            {
                event.button.button = 0;
                MenuEsc();
                if (Where >= 3)
                {
                    break;
                }
                nowstep = -1;
                walking = 0;
            }
            if (event.button.button == SDL_BUTTON_LEFT)
            {
                if (CellPhone == 1)
                {
                    event.button.button = 0;
                    break;
                }
                walking = 2;
                GetMousePosition(axp, ayp, Mx, My);
                if (axp >= 0 && axp <= 479 && ayp >= 0 && ayp <= 479)
                {
                    memset(Fway, -1, sizeof(Fway));
                    FindWay(Mx, My);
                    gotoEntrance = -1;
                    if (axp >= 0 && ayp >= 0 && BuildY[axp][ayp] > 0 && Entrance[axp][ayp] < 0)
                    {
                        int bx = BuildX[axp][ayp];
                        int by = BuildY[axp][ayp];
                        for (int i1 = bx - 3; i1 <= bx; i1++)
                        {
                            for (int i2 = by - 3; i2 <= by; i2++)
                            {
                                if (i1 >= 0 && i2 >= 0 && Entrance[i1][i2] >= 0 &&
                                    BuildX[i1][i2] == bx && BuildY[i1][i2] == by)
                                {
                                    axp = i1;
                                    ayp = i2;
                                    goto found_entrance;
                                }
                            }
                        }
                        found_entrance:;
                    }
                    if (Entrance[axp][ayp] >= 0)
                    {
                        int minstep = 4096;
                        for (int i = 0; i < 4; i++)
                        {
                            axp1 = axp;
                            ayp1 = ayp;
                            switch (i)
                            {
                            case 0: if (axp1 > 0) axp1 = axp - 1; break;
                            case 1: ayp1 = ayp + 1; break;
                            case 2: if (ayp1 > 0) ayp1 = ayp - 1; break;
                            case 3: axp1 = axp + 1; break;
                            }
                            int step = Fway[axp1][ayp1];
                            if (step >= 0 && minstep > step)
                            {
                                gotoEntrance = i;
                                minstep = step;
                            }
                        }
                        if (gotoEntrance >= 0)
                        {
                            switch (gotoEntrance)
                            {
                            case 0: axp = axp - 1; break;
                            case 1: ayp = ayp + 1; break;
                            case 2: ayp = ayp - 1; break;
                            case 3: axp = axp + 1; break;
                            }
                            gotoEntrance = 3 - gotoEntrance;
                        }
                    }
                    Moveman(Mx, My, axp, ayp);
                    nowstep = Fway[axp][ayp] - 1;
                }
                else
                {
                    walking = 0;
                }
            }
            break;
        }
        }

        // 如果主角正在行走, 则移动主角
        if (walking > 0)
        {
            Still = 0;
            stillcount = 0;
            switch (walking)
            {
            case 1:
            {
                speed++;
                Mx1 = Mx;
                My1 = My;
                if (speed == 1 || speed >= 5)
                {
                    switch (MFace)
                    {
                    case 0: Mx1--; break;
                    case 1: My1++; break;
                    case 2: My1--; break;
                    case 3: Mx1++; break;
                    }
                    MStep++;
                    if (MStep >= 7)
                    {
                        MStep = 1;
                    }
                    if (CanWalk(Mx1, My1))
                    {
                        Mx = Mx1;
                        My = My1;
                    }
                }
                break;
            }
            case 2:
            {
                if (nowstep < 0)
                {
                    walking = 0;
                    if (gotoEntrance >= 0)
                    {
                        MFace = gotoEntrance;
                    }
                }
                else
                {
                    Still = 0;
                    if (linex[nowstep] - Mx < 0)
                    {
                        MFace = 0;
                    }
                    else if (linex[nowstep] - Mx > 0)
                    {
                        MFace = 3;
                    }
                    else if (liney[nowstep] - My > 0)
                    {
                        MFace = 1;
                    }
                    else
                    {
                        MFace = 2;
                    }
                    MStep++;
                    if (MStep >= 7)
                    {
                        MStep = 1;
                    }
                    if (abs(Mx - linex[nowstep]) + abs(My - liney[nowstep]) == 1 &&
                        CanWalk(linex[nowstep], liney[nowstep]))
                    {
                        Mx = linex[nowstep];
                        My = liney[nowstep];
                    }
                    else
                    {
                        walking = 0;
                    }
                    nowstep--;
                }
                break;
            }
            }

            // 每走一步均重画屏幕, 并检测是否处于某场景入口
            Redraw();
            UpdateAllScreen();
            if (CheckEntrance())
            {
                walking = 0;
                MStep = 0;
                Still = 0;
                stillcount = 0;
                if (MMAPAMI == 0)
                {
                    DrawMMap();
                    UpdateAllScreen();
                }
            }
        }

        if (Where == 1)
        {
            WalkInScene(0);
        }

        event.key.key = 0;
        event.button.button = 0;

        // 静止时画面和光标
        if (walking == 0 && Where == 0)
        {
            if (MMAPAMI > 0)
            {
                DrawMMap();
                GetMousePosition(axp, ayp, Mx, My);
                TPosition pos = GetPositionOnScreen(axp, ayp, Mx, My);
                DrawMPic(1, pos.x, pos.y, -1, 0, 128, 0, 0);
                if (!CanWalk(axp, ayp))
                {
                    if (InRegion(axp, 0, 479) && InRegion(ayp, 0, 479) && Entrance[axp][ayp] >= 0)
                    {
                        DrawMPic(2001, pos.x, pos.y, -1, 0, 64, 0, 0);
                    }
                    else
                    {
                        DrawMPic(2001, pos.x, pos.y, -1, 0, 128, 0, 0);
                    }
                }
                UpdateAllScreen();
            }
            SDL_Delay(40);
        }
        else
        {
            SDL_Delay((uint32_t)WALK_SPEED);
        }
    }
}

//----------------------------------------------------------------------
// CanWalk - 判断主地图是否可行走
//----------------------------------------------------------------------
bool CanWalk(int x, int y)
{
    if (MODVersion == 13 && CellPhone == 0)
    {
        bool result = false;
        if (x >= 0 && y >= 0 && x < 480 && y < 480)
        {
            result = (BuildX[x][y] == 0);
            if (x <= 0 || x >= 479 || y <= 0 || y >= 479 ||
                (Surface[x][y] >= 1692 && Surface[x][y] <= 1700))
            {
                result = false;
            }
            if (Earth[x][y] == 838 || (Earth[x][y] >= 612 && Earth[x][y] <= 670))
            {
                result = false;
            }
            if (((Earth[x][y] >= 358 && Earth[x][y] <= 362) ||
                (Earth[x][y] >= 506 && Earth[x][y] <= 670) ||
                (Earth[x][y] >= 1016 && Earth[x][y] <= 1022)))
            {
                if (InShip == 1)
                {
                    if (Earth[x][y] == 838 || (Earth[x][y] >= 612 && Earth[x][y] <= 670))
                    {
                        result = false;
                    }
                    else if (Surface[x][y] >= 1746 && Surface[x][y] <= 1788)
                    {
                        result = false;
                    }
                    else
                    {
                        result = true;
                    }
                }
                else if (x == ShipY && y == ShipX)
                {
                    InShip = 0;
                    result = true;
                }
                else if (Mx == ShipY && My == ShipX)
                {
                    InShip = 1;
                    result = true;
                }
                else
                {
                    result = false;
                }
            }
            else
            {
                if (InShip == 1)
                {
                    ShipY = Mx;
                    ShipX = My;
                    ShipFace = MFace;
                }
                InShip = 0;
            }
        }
        return result;
    }

    bool result;
    if (x <= 0 || x >= 479 || y <= 0 || y >= 479)
    {
        result = false;
    }
    else
    {
        result = (BuildX[x][y] == 0);
        if (Earth[x][y] == 838 || (Earth[x][y] >= 612 && Earth[x][y] <= 670))
        {
            result = false;
        }
    }
    if ((Earth[Mx][My] >= 358 && Earth[Mx][My] <= 362) ||
        (Earth[Mx][My] >= 506 && Earth[Mx][My] <= 670) ||
        (Earth[Mx][My] >= 1016 && Earth[Mx][My] <= 1022))
    {
        InShip = 1;
    }
    else
    {
        InShip = 0;
    }
    return result;
}

//----------------------------------------------------------------------
// CheckEntrance - 检查是否到达入口
//----------------------------------------------------------------------
bool CheckEntrance()
{
    int minspeed = 300;
    if (MODVersion != 13)
    {
        minspeed = 70;
    }
    int x = Mx, y = My;
    switch (MFace)
    {
    case 0: x--; break;
    case 1: y++; break;
    case 2: y--; break;
    case 3: x++; break;
    }
    if (x < 0 || x >= 480 || y < 0 || y >= 480)
    {
        return false;
    }
    if (Entrance[x][y] >= 0)
    {
        int snum = Entrance[x][y];
        bool canEnter = false;
        if (Rscene[snum].EnCondition == 0)
        {
            canEnter = true;
        }
        if (Rscene[snum].EnCondition == 2)
        {
            for (int i = 0; i < 6; i++)
            {
                if (TeamList[i] >= 0)
                {
                    if (Rrole[TeamList[i]].Speed > minspeed)
                    {
                        canEnter = true;
                    }
                }
            }
        }
        if (canEnter)
        {
            TurnBlack();
            CurScene = Entrance[x][y];
            SFace = MFace;
            SStep = 0;
            Sx = Rscene[CurScene].EntranceX;
            Sy = Rscene[CurScene].EntranceY;
            SaveR(11);
            WalkInScene(0);
            CurScene = -1;
            BlackScreen = 0;
        }
        return canEnter;
    }
    return false;
}

//----------------------------------------------------------------------
// WalkInScene - 场景内行走
//----------------------------------------------------------------------
int WalkInScene(int Open)
{
    uint32_t next_time = SDL_GetTicks();
    Where = 1;
    int walking = 0;
    CurEvent = -1;
    int stillcount = 0;
    int speed = 0;
    int AmiCount = 0;
    int axp = 0, ayp = 0, axp1 = 0, ayp1 = 0;
    int gotoEvent = -1;
    int x1, y1;
    int Sx1, Sy1;
    int PreScene;
    ExitSceneMusicNum = Rscene[CurScene].ExitMusic;

    InitialScene();
    for (int i = 0; i < 200; i++)
    {
        if (DData[CurScene][i][7] < DData[CurScene][i][6])
        {
            int range = DData[CurScene][i][6] - DData[CurScene][i][7] + 2;
            if (range > 0)
            {
                DData[CurScene][i][5] = DData[CurScene][i][7] + (DData[CurScene][i][8] * 2) % range;
            }
        }
    }

    if (Open == 1)
    {
        Sx = BEGIN_Sx;
        Sy = BEGIN_Sy;
        Cx = Sx;
        Cy = Sy;
        ShowMR = false;
        if (MODVersion != 13)
        {
            CurSceneRolePic = 3445;
            ShowMR = true;
            SFace = 1;
        }
        CurEvent = SData[CurScene][3][Sx][Sy];
        CallEvent(BEGIN_EVENT);
        ShowMR = true;
        UpdateAllScreen();
        CurEvent = -1;
    }

    SStep = 0;
    uint32_t now2 = 0;
    TimeInWater = 15 + Rrole[0].CurrentMP / 100;

    CurSceneRolePic = BEGIN_WALKPIC2 + SFace * 7;
    DrawScene();
    ShowSceneName(CurScene);
    CheckEvent3();

    while (SDL_PollEvent(&event) || true)
    {
        uint32_t timer1 = SDL_GetTicks();
        now2 += 20;
        if ((int)now2 > 4000)
        {
            now2 = 0;
            TimeInWater--;
        }
        if (Where != 1)
        {
            break;
        }

        // 场景内动态效果
        uint32_t now = SDL_GetTicks();
        if ((int)(now - next_time) > 0)
        {
            for (int i = 0; i < 200; i++)
            {
                if (DData[CurScene][i][7] < DData[CurScene][i][6])
                {
                    DData[CurScene][i][5] += 2;
                    if (DData[CurScene][i][5] > DData[CurScene][i][6])
                    {
                        DData[CurScene][i][5] = DData[CurScene][i][7];
                    }
                }
            }
            if (walking == 0)
            {
                stillcount++;
            }
            else
            {
                stillcount = 0;
            }
            if (stillcount >= 10)
            {
                SStep = 0;
                stillcount = 0;
            }
            next_time = now + 200;
            AmiCount++;
        }

        // 检查是否位于出口
        if ((Sx == Rscene[CurScene].ExitX[0] && Sy == Rscene[CurScene].ExitY[0]) ||
            (Sx == Rscene[CurScene].ExitX[1] && Sy == Rscene[CurScene].ExitY[1]) ||
            (Sx == Rscene[CurScene].ExitX[2] && Sy == Rscene[CurScene].ExitY[2]))
        {
            Where = 0;
            instruct_14();
            break;
        }
        // 检查是否位于跳转口
        if (Sx == Rscene[CurScene].JumpX1 && Sy == Rscene[CurScene].JumpY1 &&
            Rscene[CurScene].JumpScene >= 0)
        {
            instruct_14();
            PreScene = CurScene;
            CurScene = Rscene[CurScene].JumpScene;
            if (Rscene[PreScene].MainEntranceX1 != 0)
            {
                Sx = Rscene[CurScene].EntranceX;
                Sy = Rscene[CurScene].EntranceY;
            }
            else
            {
                Sx = Rscene[CurScene].JumpX2;
                Sy = Rscene[CurScene].JumpY2;
            }
            InitialScene();
            walking = 0;
            now2 = 0;
            TimeInWater = 15 + Rrole[0].CurrentMP / 100;
            DrawScene();
            ShowSceneName(CurScene);
            CheckEvent3();
        }

        CheckBasicEvent();
        switch (event.type)
        {
        case SDL_EVENT_KEY_UP:
        {
            if (*keyup == 0 && *keydown == 0 && *keyleft == 0 && *keyright == 0)
            {
                walking = 0;
                speed = 0;
            }
            if (event.key.key == SDLK_ESCAPE)
            {
                MenuEsc();
                if (Where >= 3)
                {
                    break;
                }
                walking = 0;
            }
            if (event.key.key == SDLK_RETURN || event.key.key == SDLK_SPACE)
            {
                CheckEvent1();
            }
            if (event.key.key == SDLK_TAB)
            {
                SpecialFunction();
            }
            break;
        }
        case SDL_EVENT_KEY_DOWN:
        {
            if (event.key.key == SDLK_LEFT)
            {
                SFace = 2;
                walking = 1;
            }
            if (event.key.key == SDLK_RIGHT)
            {
                SFace = 1;
                walking = 1;
            }
            if (event.key.key == SDLK_UP)
            {
                SFace = 0;
                walking = 1;
            }
            if (event.key.key == SDLK_DOWN)
            {
                SFace = 3;
                walking = 1;
            }
            break;
        }
        case SDL_EVENT_MOUSE_MOTION:
        {
            if (ShowVirtualKey == 0)
            {
                SDL_GetMouseState2(x1, y1);
                if (x1 < CENTER_X && y1 < CENTER_Y)
                {
                    SFace = 2;
                }
                if (x1 > CENTER_X && y1 < CENTER_Y)
                {
                    SFace = 0;
                }
                if (x1 < CENTER_X && y1 > CENTER_Y)
                {
                    SFace = 3;
                }
                if (x1 > CENTER_X && y1 > CENTER_Y)
                {
                    SFace = 1;
                }
            }
            break;
        }
        case SDL_EVENT_MOUSE_BUTTON_UP:
        {
            if (event.button.button == SDL_BUTTON_RIGHT)
            {
                MenuEsc();
                if (Where >= 3)
                {
                    break;
                }
                nowstep = 0;
                walking = 0;
                if (Where == 0)
                {
                    if (Rscene[CurScene].ExitMusic >= 0)
                    {
                        StopMP3();
                        PlayMP3(Rscene[CurScene].ExitMusic, -1);
                    }
                    break;
                }
            }
            if (event.button.button == SDL_BUTTON_MIDDLE)
            {
                CheckEvent1();
            }
            if (event.button.button == SDL_BUTTON_LEFT)
            {
                if (CellPhone == 1)
                {
                    event.button.button = 0;
                    break;
                }
                if (walking == 0)
                {
                    walking = 2;
                    GetMousePosition(axp, ayp, Sx, Sy, SData[CurScene][4][Sx][Sy]);
                    if (axp >= 0 && axp <= 63 && ayp >= 0 && ayp <= 63)
                    {
                        memset(Fway, -1, sizeof(Fway));
                        FindWay(Sx, Sy);
                        gotoEvent = -1;
                        if (InRegion(axp, 0, 64) && InRegion(ayp, 0, 64) &&
                            SData[CurScene][3][axp][ayp] >= 0)
                        {
                            if (abs(axp - Sx) + abs(ayp - Sy) == 1)
                            {
                                if (axp < Sx) SFace = 0;
                                if (axp > Sx) SFace = 3;
                                if (ayp < Sy) SFace = 2;
                                if (ayp > Sy) SFace = 1;
                                if (CheckEvent1())
                                {
                                    walking = 0;
                                }
                            }
                            else
                            {
                                if (!CanWalkInScene(axp, ayp))
                                {
                                    int minstep = 4096;
                                    for (int i = 0; i < 4; i++)
                                    {
                                        axp1 = axp;
                                        ayp1 = ayp;
                                        switch (i)
                                        {
                                        case 0: axp1 = axp - 1; break;
                                        case 1: ayp1 = ayp + 1; break;
                                        case 2: ayp1 = ayp - 1; break;
                                        case 3: axp1 = axp + 1; break;
                                        }
                                        int step = Fway[axp1][ayp1];
                                        if (step >= 0 && minstep > step)
                                        {
                                            gotoEvent = i;
                                            minstep = step;
                                        }
                                    }
                                    if (gotoEvent >= 0)
                                    {
                                        switch (gotoEvent)
                                        {
                                        case 0: axp = axp - 1; break;
                                        case 1: ayp = ayp + 1; break;
                                        case 2: ayp = ayp - 1; break;
                                        case 3: axp = axp + 1; break;
                                        }
                                        gotoEvent = 3 - gotoEvent;
                                    }
                                }
                            }
                        }
                        if (axp >= 0 && ayp >= 0)
                        {
                            Moveman(Sx, Sy, axp, ayp);
                            nowstep = Fway[axp][ayp] - 1;
                        }
                    }
                    else
                    {
                        walking = 0;
                    }
                }
                else
                {
                    walking = 0;
                }
                event.button.button = 0;
            }
            break;
        }
        }

        // 是否处于行走状态
        if (walking > 0)
        {
            switch (walking)
            {
            case 1:
            {
                speed++;
                stillcount = 0;
                if (speed == 1 || speed >= 5)
                {
                    Sx1 = Sx;
                    Sy1 = Sy;
                    switch (SFace)
                    {
                    case 0: Sx1--; break;
                    case 1: Sy1++; break;
                    case 2: Sy1--; break;
                    case 3: Sx1++; break;
                    }
                    SStep++;
                    if (SStep >= 7)
                    {
                        SStep = 1;
                    }
                    if (CanWalkInScene(Sx1, Sy1))
                    {
                        Sx = Sx1;
                        Sy = Sy1;
                    }
                }
                break;
            }
            case 2:
            {
                if (nowstep >= 0)
                {
                    if (liney[nowstep] - Sy < 0)
                    {
                        SFace = 2;
                    }
                    else if (liney[nowstep] - Sy > 0)
                    {
                        SFace = 1;
                    }
                    else if (linex[nowstep] - Sx > 0)
                    {
                        SFace = 3;
                    }
                    else
                    {
                        SFace = 0;
                    }
                    SStep++;
                    if (SStep >= 7)
                    {
                        SStep = 1;
                    }
                    if (abs(Sx - linex[nowstep]) + abs(Sy - liney[nowstep]) == 1)
                    {
                        Sx = linex[nowstep];
                        Sy = liney[nowstep];
                    }
                    else
                    {
                        walking = 0;
                    }
                    nowstep--;
                }
                else
                {
                    walking = 0;
                    if (gotoEvent >= 0)
                    {
                        SFace = gotoEvent;
                        CheckEvent1();
                    }
                }
                break;
            }
            }

            CurSceneRolePic = BEGIN_WALKPIC2 + SFace * 7 + SStep;
            DrawScene();
            UpdateAllScreen();
            CheckEvent3();
        }

        event.key.key = 0;
        event.button.button = 0;

        if (walking == 0 && Where == 1)
        {
            if (SCENEAMI > 0)
            {
                CurSceneRolePic = BEGIN_WALKPIC2 + SFace * 7 + SStep;
                DrawScene();
                if (walking == 0)
                {
                    GetMousePosition(axp, ayp, Sx, Sy, SData[CurScene][4][Sx][Sy]);
                    if (axp >= 0 && axp < 64 && ayp >= 0 && ayp < 64)
                    {
                        TPosition pos = GetPositionOnScreen(axp, ayp, Sx, Sy);
                        DrawMPic(1, pos.x, pos.y - SData[CurScene][4][axp][ayp], 0, 0, 128, 0, 0);
                        if (!CanWalkInScene(axp, ayp))
                        {
                            if (SData[CurScene][3][axp][ayp] >= 0)
                            {
                                DrawMPic(2001, pos.x, pos.y - SData[CurScene][4][axp][ayp], 0, 0, 64, 0, 0);
                            }
                            else
                            {
                                DrawMPic(2001, pos.x, pos.y - SData[CurScene][4][axp][ayp], 0, 0, 128, 0, 0);
                            }
                        }
                    }
                }
                UpdateAllScreen();
            }
            SDL_Delay(40);
        }
        else
        {
            SDL_Delay((uint32_t)WALK_SPEED2);
        }
    }

    MFace = SFace;
    ReSetEntrance();
    if (ExitSceneMusicNum > 0 && Where != 3)
    {
        StopMP3();
        PlayMP3(ExitSceneMusicNum, -1);
    }
    return 0;
}

void ShowSceneName(int snum)
{
    UpdateAllScreen();
    std::string scenename = (char*)Rscene[snum].Name;
    DrawTextWithRect(scenename, CENTER_X - DrawLength(scenename) * 5 - 23, 100, 0, 0, 0x202020);
    SDL_Delay(500);
    if (LastShowScene != snum)
    {
        LastShowScene = snum;
        if (Rscene[snum].EntranceMusic >= 0)
        {
            StopMP3();
            PlayMP3(Rscene[snum].EntranceMusic, -1);
        }
    }
}

bool CanWalkInScene(int x1, int y1, int x, int y)
{
    if (x < 0 || x > 63 || y < 0 || y > 63)
        return false;
    // 建筑层: 仅 -2, -1, 0 可通行
    if (SData[CurScene][1][x][y] > 0 || SData[CurScene][1][x][y] < -2)
        return false;
    // 高度差检查(仅相邻格)
    if (abs(SData[CurScene][4][x][y] - SData[CurScene][4][x1][y1]) > 10
        && abs(x1 - x) + abs(y1 - y) == 1)
        return false;
    // 事件类型1阻挡
    if (SData[CurScene][3][x][y] >= 0
        && DData[CurScene][SData[CurScene][3][x][y]][0] == 1)
        return false;
    // 特定地面贴图阻挡
    int g = SData[CurScene][0][x][y];
    if ((g >= 358 && g <= 362) || g == 522 || g == 1022
        || (g >= 1324 && g <= 1330) || g == 1348)
        return false;
    return true;
}

bool CanWalkInScene(int x, int y)
{
    return CanWalkInScene(Sx, Sy, x, y);
}

bool CheckEvent1()
{
    int x = Sx, y = Sy;
    switch (SFace)
    {
    case 0: x = x - 1; break;
    case 1: y = y + 1; break;
    case 2: y = y - 1; break;
    case 3: x = x + 1; break;
    }
    bool result = false;
    if (x >= 0 && x < 64 && y >= 0 && y < 64 && SData[CurScene][3][x][y] >= 0)
    {
        CurEvent = SData[CurScene][3][x][y];
        if (DData[CurScene][CurEvent][2] > 0)
        {
            Cx = Sx;
            Cy = Sy;
            SStep = 0;
            CurSceneRolePic = BEGIN_WALKPIC2 + SFace * 7 + SStep;
            CallEvent(DData[CurScene][CurEvent][2]);
            result = true;
        }
    }
    CurEvent = -1;
    if (MMAPAMI == 0 || SCENEAMI == 0)
    {
        Redraw();
        UpdateAllScreen();
    }
    return result;
}

bool CheckEvent3()
{
    int enumVal = SData[CurScene][3][Sx][Sy];
    bool result = false;
    if (enumVal >= 0 && DData[CurScene][enumVal][4] > 0)
    {
        CurEvent = enumVal;
        Cx = Sx;
        Cy = Sy;
        CallEvent(DData[CurScene][enumVal][4]);
        result = true;
        CurEvent = -1;
        if (MMAPAMI == 0 || SCENEAMI == 0)
        {
            Redraw();
            UpdateAllScreen();
        }
    }
    return result;
}

void TurnBlack()
{
    instruct_14();
}

void Moveman(int x1, int y1, int x2, int y2)
{
    if (x2 >= 0 && y2 >= 0 && Fway[x2][y2] > 0)
    {
        int Xinc[4] = { 0, 1, -1, 0 };
        int Yinc[4] = { -1, 0, 0, 1 };
        linex[0] = (int16_t)x2;
        liney[0] = (int16_t)y2;
        for (int a = 1; a <= Fway[x2][y2]; a++)
        {
            for (int i = 0; i < 4; i++)
            {
                int tempx = linex[a - 1] + Xinc[i];
                int tempy = liney[a - 1] + Yinc[i];
                if (tempx >= 0 && tempy >= 0 && Fway[tempx][tempy] == Fway[linex[a - 1]][liney[a - 1]] - 1)
                {
                    linex[a] = (int16_t)tempx;
                    liney[a] = (int16_t)tempy;
                    break;
                }
            }
        }
    }
}

bool FindWay(int x1, int y1)
{
    int16_t Xlist[4097], Ylist[4097], steplist[4097];
    int curgrid = 0, totalgrid = 1;
    int Bgrid[4];
    int Xinc[4] = { 0, 1, -1, 0 };
    int Yinc[4] = { -1, 0, 0, 1 };

    Xlist[0] = (int16_t)x1;
    Ylist[0] = (int16_t)y1;
    steplist[0] = 0;
    Fway[x1][y1] = 0;

    int mode = MODVersion;
    if (CellPhone == 1)
    {
        mode = 0;
    }

    while (curgrid < totalgrid)
    {
        int curX = Xlist[curgrid];
        int curY = Ylist[curgrid];
        int curstep = steplist[curgrid];

        if (Where == 1)
        {
            for (int i = 0; i < 4; i++)
            {
                int nextX = curX + Xinc[i];
                int nextY = curY + Yinc[i];
                if (nextX < 0 || nextX > 63 || nextY < 0 || nextY > 63)
                {
                    Bgrid[i] = 3;
                }
                else if (Fway[nextX][nextY] >= 0)
                {
                    Bgrid[i] = 2;
                }
                else if (!CanWalkInScene(curX, curY, nextX, nextY))
                {
                    Bgrid[i] = 1;
                }
                else
                {
                    Bgrid[i] = 0;
                }
            }
        }
        else
        {
            for (int i = 0; i < 4; i++)
            {
                int nextX = curX + Xinc[i];
                int nextY = curY + Yinc[i];
                if (nextX < 0 || nextX > 479 || nextY < 0 || nextY > 479)
                {
                    Bgrid[i] = 3;
                }
                else if (Entrance[nextX][nextY] >= 0)
                {
                    Bgrid[i] = 6;
                }
                else if (Fway[nextX][nextY] >= 0)
                {
                    Bgrid[i] = 2;
                }
                else if (BuildX[nextX][nextY] > 0)
                {
                    Bgrid[i] = 1;
                }
                else if (Surface[nextX][nextY] >= 1692 && Surface[nextX][nextY] <= 1700)
                {
                    Bgrid[i] = 1;
                }
                else if (Earth[nextX][nextY] == 838 || (Earth[nextX][nextY] >= 612 && Earth[nextX][nextY] <= 670))
                {
                    Bgrid[i] = 1;
                }
                else if ((Earth[nextX][nextY] >= 358 && Earth[nextX][nextY] <= 362) || (Earth[nextX][nextY] >= 506 && Earth[nextX][nextY] <= 670) || (Earth[nextX][nextY] >= 1016 && Earth[nextX][nextY] <= 1022))
                {
                    if (nextX == ShipY && nextY == ShipX)
                    {
                        Bgrid[i] = 4;
                    }
                    else if ((Surface[nextX][nextY] / 2 >= 863 && Surface[nextX][nextY] / 2 <= 872) || (Surface[nextX][nextY] / 2 >= 852 && Surface[nextX][nextY] / 2 <= 854) || (Surface[nextX][nextY] / 2 >= 858 && Surface[nextX][nextY] / 2 <= 860))
                    {
                        Bgrid[i] = 0;
                    }
                    else
                    {
                        Bgrid[i] = 5;
                    }
                }
                else
                {
                    Bgrid[i] = 0;
                }
            }
        }

        for (int i = 0; i < 4; i++)
        {
            bool canWalk = false;
            if (mode == 13)
            {
                if ((InShip == 1 && Bgrid[i] == 5) || ((Bgrid[i] == 0 || Bgrid[i] == 4) && InShip == 0))
                {
                    canWalk = true;
                }
            }
            else if (MODVersion == 22)
            {
                if ((InShip == 1 && Bgrid[i] == 5) || ((Bgrid[i] == 0 || Bgrid[i] == 4) && InShip == 0))
                {
                    canWalk = true;
                }
            }
            else
            {
                if (Bgrid[i] == 0 || Bgrid[i] == 4 || Bgrid[i] == 5 || Bgrid[i] == 7)
                {
                    canWalk = true;
                }
            }
            if (canWalk)
            {
                int nx = curX + Xinc[i];
                int ny = curY + Yinc[i];
                Xlist[totalgrid] = (int16_t)nx;
                Ylist[totalgrid] = (int16_t)ny;
                steplist[totalgrid] = (int16_t)(curstep + 1);
                Fway[nx][ny] = steplist[totalgrid];
                totalgrid++;
                if (totalgrid > 4096)
                {
                    return false;
                }
            }
        }
        curgrid++;
        if (Where == 0 && curX - Mx > 22 && curY - My > 22)
        {
            break;
        }
    }
    return true;
}

//----------------------------------------------------------------------
// CommonMenu - 通用菜单
//----------------------------------------------------------------------
int CommonMenu(int x, int y, int w, int max, int default_, const std::string menuString[], int count)
{
    std::string emptyEng[1];
    return CommonMenu(x, y, w, max, default_, menuString, emptyEng, 1, 0, 0x202020, ColColor(0x64), ColColor(0x66), count);
}

int CommonMenu(int x, int y, int w, int max, int default_, const std::string menuString[], const std::string menuEngString[], int count)
{
    return CommonMenu(x, y, w, max, default_, menuString, menuEngString, 1, 0, 0x202020, ColColor(0x64), ColColor(0x66), count);
}

int CommonMenu(int x, int y, int w, int max, int default_, const std::string menuString[], const std::string menuEngString[],
    int needFrame, uint32 color1, uint32 color2, uint32 menucolor1, uint32 menucolor2, int count)
{
    int h = 28;
    int menu = default_;
    if (menu < 0)
    {
        menu = 0;
    }
    if (menu > max)
    {
        menu = max;
    }

    // 判断是否有英文串
    int p = 0;
    if (count > 0 && menuEngString != nullptr && menuEngString[0].size() > 0)
    {
        p = 1;
    }

    // 计算最大文字长度
    int len = 0, lene = 0;
    for (int i = 0; i <= max && i < count; i++)
    {
        int len1 = DrawLength(menuString[i]);
        if (len1 > len)
        {
            len = len1;
        }
        if (p == 1)
        {
            len1 = DrawLength(menuEngString[i]) + 2;
            if (len1 > lene)
            {
                lene = len1;
            }
        }
    }
    int len1 = len + lene;
    w = w + 40;

    RecordFreshScreen(x, y, w, max * h + h + 2);

    // 内部绘制函数
    auto ShowCommonMenu = [&]()
    {
        LoadFreshScreen(x, y);
        for (int i = 0; i <= std::min(max, count - 1); i++)
        {
            int alpha;
            uint32 c1, c2;
            if (i == menu)
            {
                alpha = 255;
                c1 = menucolor1;
                c2 = menucolor2;
            }
            else
            {
                alpha = 230;
                c1 = color1;
                c2 = color2;
            }
            DrawTextFrame(x, y + i * h, len1, alpha);
            DrawShadowText(menuString[i], x + 19, y + 3 + h * i, c1, c2);
            if (p == 1)
            {
                DrawEngShadowText(menuEngString[i], x + 19 + len * 10 + 20, y + 3 + h * i, c1, c2);
            }
        }
    };

    ShowCommonMenu();
    UpdateAllScreen();

    while (SDL_WaitEvent(&event))
    {
        CheckBasicEvent();
        switch (event.type)
        {
        case SDL_EVENT_KEY_DOWN:
            if (event.key.key == SDLK_DOWN)
            {
                menu++;
                if (menu > max)
                {
                    menu = 0;
                }
                ShowCommonMenu();
                UpdateAllScreen();
            }
            if (event.key.key == SDLK_UP)
            {
                menu--;
                if (menu < 0)
                {
                    menu = max;
                }
                ShowCommonMenu();
                UpdateAllScreen();
            }
            break;
        case SDL_EVENT_KEY_UP:
            if (event.key.key == SDLK_ESCAPE)
            {
                event.key.key = SDLK_UNKNOWN;
                event.button.button = 0;
                FreeFreshScreen();
                return -1;
            }
            if (event.key.key == SDLK_RETURN || event.key.key == SDLK_SPACE)
            {
                event.key.key = SDLK_UNKNOWN;
                event.button.button = 0;
                FreeFreshScreen();
                return menu;
            }
            break;
        case SDL_EVENT_MOUSE_BUTTON_UP:
            if (event.button.button == SDL_BUTTON_RIGHT)
            {
                event.key.key = SDLK_UNKNOWN;
                event.button.button = 0;
                FreeFreshScreen();
                return -1;
            }
            if (event.button.button == SDL_BUTTON_LEFT)
            {
                if (MouseInRegion(x, y, w, max * h + h + 2))
                {
                    event.key.key = SDLK_UNKNOWN;
                    event.button.button = 0;
                    FreeFreshScreen();
                    return menu;
                }
            }
            break;
        case SDL_EVENT_MOUSE_MOTION:
        {
            int mx, my;
            if (MouseInRegion(x, y, w, max * h + h + 2, mx, my))
            {
                int menup = menu;
                menu = (my - y - 2) / h;
                if (menu > max)
                {
                    menu = max;
                }
                if (menu < 0)
                {
                    menu = 0;
                }
                if (menup != menu)
                {
                    ShowCommonMenu();
                    UpdateAllScreen();
                }
            }
            break;
        }
        }
    }
    FreeFreshScreen();
    return -1;
}

int CommonScrollMenu(int x, int y, int w, int max, int maxshow, const std::string menuString[], int count)
{
    int menu = 0, menutop = 0;
    if (maxshow > max + 1)
    {
        maxshow = max + 1;
    }

    // 计算最大文本宽度
    int len = 0;
    for (int i = 0; i <= max && i < count; i++)
    {
        int len1 = DrawLength(menuString[i]);
        if (len1 > len)
        {
            len = len1;
        }
    }
    int len1 = len;
    w = len1 * 10 + 40;
    int h = 28;

    RecordFreshScreen(x, y, w + 1, maxshow * h + 32);

    auto ShowMenu = [&]()
    {
        LoadFreshScreen(x, y);
        int ms = std::min(max + 1, maxshow);
        for (int i = menutop; i < menutop + ms && i <= max; i++)
        {
            uint32 c1, c2;
            int alpha;
            if (i == menu)
            {
                alpha = 255;
                c1 = ColColor(0x64);
                c2 = ColColor(0x66);
            }
            else
            {
                alpha = 230;
                c1 = 0;
                c2 = 0x202020;
            }
            DrawTextFrame(x, y + h * (i - menutop), len1, alpha);
            DrawShadowText(menuString[i], x + 19, y + 3 + h * (i - menutop), c1, c2);
        }
    };

    ShowMenu();
    UpdateAllScreen();

    int result = -1;
    while (SDL_WaitEvent(&event))
    {
        CheckBasicEvent();
        if (event.type == SDL_EVENT_KEY_DOWN)
        {
            if (event.key.key == SDLK_DOWN)
            {
                menu++;
                if (menu - menutop >= maxshow)
                {
                    menutop++;
                }
                if (menu > max)
                {
                    menu = 0;
                    menutop = 0;
                }
                ShowMenu();
                UpdateAllScreen();
            }
            if (event.key.key == SDLK_UP)
            {
                menu--;
                if (menu <= menutop)
                {
                    menutop = menu;
                }
                if (menu < 0)
                {
                    menu = max;
                    menutop = std::max(0, menu - maxshow + 1);
                }
                ShowMenu();
                UpdateAllScreen();
            }
        }
        if (event.type == SDL_EVENT_KEY_UP)
        {
            if (event.key.key == SDLK_PAGEDOWN)
            {
                menu += maxshow;
                menutop += maxshow;
                if (menu > max)
                {
                    menu = max;
                }
                if (menutop > max - maxshow + 1)
                {
                    menutop = std::max(0, max - maxshow + 1);
                }
                ShowMenu();
                UpdateAllScreen();
            }
            if (event.key.key == SDLK_PAGEUP)
            {
                menu -= maxshow;
                menutop -= maxshow;
                if (menu < 0)
                {
                    menu = 0;
                }
                if (menutop < 0)
                {
                    menutop = 0;
                }
                ShowMenu();
                UpdateAllScreen();
            }
            if (event.key.key == SDLK_ESCAPE && Where <= 2)
            {
                result = -1;
                break;
            }
            if (event.key.key == SDLK_RETURN || event.key.key == SDLK_SPACE)
            {
                result = menu;
                break;
            }
        }
        if (event.type == SDL_EVENT_MOUSE_BUTTON_UP)
        {
            if (event.button.button == SDL_BUTTON_RIGHT && Where <= 2)
            {
                result = -1;
                break;
            }
            if (event.button.button == SDL_BUTTON_LEFT)
            {
                if (MouseInRegion(x, y, w, max * h + 32))
                {
                    result = menu;
                    break;
                }
            }
        }
        if (event.type == SDL_EVENT_MOUSE_WHEEL)
        {
            if (event.wheel.y < 0)
            {
                menu++;
                if (menu - menutop >= maxshow)
                {
                    menutop++;
                }
                if (menu > max)
                {
                    menu = 0;
                    menutop = 0;
                }
                ShowMenu();
                UpdateAllScreen();
            }
            if (event.wheel.y > 0)
            {
                menu--;
                if (menu <= menutop)
                {
                    menutop = menu;
                }
                if (menu < 0)
                {
                    menu = max;
                    menutop = std::max(0, menu - maxshow + 1);
                }
                ShowMenu();
                UpdateAllScreen();
            }
        }
        if (event.type == SDL_EVENT_MOUSE_MOTION)
        {
            int x1, y1;
            if (MouseInRegion(x, y, w, max * h + 32, x1, y1))
            {
                int menup = menu;
                menu = (y1 - y - 2) / h + menutop;
                if (menu > max)
                {
                    menu = max;
                }
                if (menu < 0)
                {
                    menu = 0;
                }
                if (menup != menu)
                {
                    ShowMenu();
                    UpdateAllScreen();
                }
            }
        }
    }
    event.key.key = 0;
    event.button.button = 0;
    FreeFreshScreen();
    UpdateAllScreen();
    return result;
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
    if (!str.empty())
    {
        DrawTextWithRect(str, CENTER_X - 275, CENTER_Y - 193, 0, 0, 0x202020);
    }
    RecordFreshScreen(CENTER_X - 275, CENTER_Y - 160, 551, 310);

    TPosition pos[6];
    for (int i = 0; i < 3; i++)
    {
        pos[2 * i].x = CENTER_X - 270;
        pos[2 * i + 1].x = CENTER_X;
        pos[2 * i].y = CENTER_Y - 150 + i * 100;
        pos[2 * i + 1].y = CENTER_Y - 150 + i * 100;
    }
    int max;
    LoadTeamSimpleStatus(max);

    int menu = 0, premenu = -1;
    event.key.key = 0;
    event.button.button = 0;
    int result = -1;

    while (true)
    {
        SDL_PollEvent(&event);
        if (menu != premenu)
        {
            LoadFreshScreen(CENTER_X - 275, CENTER_Y - 160);
            DrawRectangle(CENTER_X - 275, CENTER_Y - 160, 550, 310, 0, ColColor(0x64), 128);
            for (int i = 0; i <= max; i++)
            {
                if (i == menu)
                {
                    if ((1 << i) & mask)
                    {
                        DrawSimpleStatusByTeam(i, pos[i].x, pos[i].y, 0, 0);
                    }
                    else
                    {
                        DrawSimpleStatusByTeam(i, pos[i].x, pos[i].y, MapRGBA(192, 16, 56), 30);
                    }
                }
                else
                {
                    DrawSimpleStatusByTeam(i, pos[i].x, pos[i].y, 0, 30);
                }
            }
            UpdateAllScreen();
            premenu = menu;
        }
        CheckBasicEvent();
        if (event.type == SDL_EVENT_KEY_DOWN && event.key.key == SDLK_LEFT)
        {
            menu--;
            if (menu < 0)
            {
                menu = max;
            }
        }
        if (event.type == SDL_EVENT_KEY_DOWN && event.key.key == SDLK_RIGHT)
        {
            menu++;
            if (menu > max)
            {
                menu = 0;
            }
        }
        if (event.type == SDL_EVENT_KEY_DOWN && event.key.key == SDLK_UP)
        {
            menu -= 2;
            if (menu < 0)
            {
                menu += max + 1;
            }
        }
        if (event.type == SDL_EVENT_KEY_DOWN && event.key.key == SDLK_DOWN)
        {
            menu += 2;
            if (menu > max)
            {
                menu -= max + 1;
            }
        }
        if ((event.type == SDL_EVENT_KEY_UP && event.key.key == SDLK_ESCAPE) || (event.type == SDL_EVENT_MOUSE_BUTTON_UP && event.button.button == SDL_BUTTON_RIGHT))
        {
            result = -1;
            break;
        }
        if ((event.type == SDL_EVENT_KEY_UP && (event.key.key == SDLK_RETURN || event.key.key == SDLK_SPACE)) || (event.type == SDL_EVENT_MOUSE_BUTTON_UP && event.button.button == SDL_BUTTON_LEFT))
        {
            if (menu >= 0 && menu <= max && ((1 << menu) & mask))
            {
                result = menu;
                break;
            }
        }
        if (event.type == SDL_EVENT_MOUSE_MOTION)
        {
            int x1, y1;
            if (MouseInRegion(pos[0].x, pos[0].y, pos[5].x + 270 - pos[0].x, pos[5].y + 100 - pos[0].y, x1, y1))
            {
                menu = (y1 - pos[0].y) / 100 * 2 + (x1 - pos[0].x) / 270;
            }
        }
        SDL_Delay(10);
        event.key.key = 0;
        event.button.button = 0;
    }
    FreeFreshScreen();
    return result;
}

//----------------------------------------------------------------------
// MenuEsc - ESC主菜单
//----------------------------------------------------------------------
void MenuEsc()
{
    for (int i = 0; i < 4; i++)
    {
        TitleMenu[i].x = CENTER_X + 220 + 60 * i;
        TitleMenu[i].y = 15;
        TitleMenu[i].w = 60;
        TitleMenu[i].h = 30;
    }
    MenuEscTeammate = 0;

    NeedRefreshScene = 0;
    TPosition pos[4];
    pos[0].x = CENTER_X;
    pos[0].y = CENTER_Y - 120;
    pos[1].x = CENTER_X - 140;
    pos[1].y = CENTER_Y + 10;
    pos[2].x = CENTER_X + 140;
    pos[2].y = CENTER_Y + 10;
    pos[3].x = CENTER_X;
    pos[3].y = CENTER_Y + 140;

    RecordFreshScreen();
    CleanTextScreen();

    // 展开动画
    for (int i = DISABLE_MENU_AMI; i <= 25; i++)
    {
        LoadFreshScreen();
        DrawMPic(2020, CENTER_X - 193, CENTER_Y - 182, 0, 0, i * 255 / 25, 0, 0);
        for (int j = 0; j < 4; j++)
        {
            int x1 = LinearInsert(i, 0, 25, CENTER_X, pos[j].x);
            int y1 = LinearInsert(i, 0, 25, CENTER_Y, pos[j].y);
            DrawMPic(2021, x1 - 65, y1 - 70, 0, 0, i * 255 / 25, 0, 0);
            DrawMPic(2022 + j, x1 - 30, y1 - 25, 0, 0, i * 255 / 25, 0, 0);
        }
        UpdateAllScreen();
        SDL_PollEvent(&event);
        CheckBasicEvent();
        SDL_Delay(10);
    }

    event.key.key = 0;
    event.button.button = 0;
    bool selected = false;
    int j = 0;
    int menu = 0;
    int menup = -1;

    // 如果鼠标在某个有效位置则重设初值
    for (int i = 0; i < 4; i++)
    {
        if (MouseInRegion(pos[i].x - 65, pos[i].y - 70, 130, 140))
        {
            menu = i;
            break;
        }
    }

    while (SDL_PollEvent(&event) || true)
    {
        if (Where >= 3)
        {
            break;
        }

        LoadFreshScreen();
        CleanTextScreen();
        if (menup != menu)
        {
            j = 0;
        }

        DrawMPic(2020, CENTER_X - 193, CENTER_Y - 182);
        for (int i = 0; i < 4; i++)
        {
            if (i != menu)
            {
                DrawMPic(2021, pos[i].x - 65, pos[i].y - 70);
            }
            else
            {
                j += 6;
                if (j >= 360)
                {
                    j = 0;
                }
                SDL_Rect dest;
                dest.x = pos[i].x - MPNGIndex[2021].w / 2;
                dest.y = pos[i].y - MPNGIndex[2021].h / 2;
                int k = 45 - abs(j / 4 - 45);
                DrawMPic(2021, dest.x, dest.y, 0, 0, 255 - k * 255 / 100, 0, k, 1, 1, j);
            }
            DrawMPic(2022 + i, pos[i].x - 30, pos[i].y - 25);
        }
        menup = menu;

        auto info = std::format("位置：({:3d}, {:3d})", My, Mx);
        DrawShadowText(info, 5, 5, ColColor(0x64), ColColor(0x66));
        UpdateAllScreen();
        CheckBasicEvent();

        switch (event.type)
        {
        case SDL_EVENT_KEY_UP:
            if (event.key.key == SDLK_UP)
            {
                menu = 0;
            }
            if (event.key.key == SDLK_LEFT)
            {
                menu = 1;
            }
            if (event.key.key == SDLK_RIGHT)
            {
                menu = 2;
            }
            if (event.key.key == SDLK_DOWN)
            {
                menu = 3;
            }
            if (event.key.key == SDLK_ESCAPE)
            {
                goto menuesc_exit;
            }
            if (event.key.key == SDLK_RETURN || event.key.key == SDLK_SPACE)
            {
                selected = true;
            }
            if (event.key.key >= SDLK_1 && event.key.key <= SDLK_4)
            {
                menu = event.key.key - SDLK_1;
                selected = true;
            }
            break;
        case SDL_EVENT_MOUSE_BUTTON_UP:
            if (event.button.button == SDL_BUTTON_RIGHT)
            {
                goto menuesc_exit;
            }
            if (event.button.button == SDL_BUTTON_LEFT)
            {
                menu = -1;
                for (int i = 0; i < 4; i++)
                {
                    if (MouseInRegion(pos[i].x - 65, pos[i].y - 70, 130, 140))
                    {
                        menu = i;
                        break;
                    }
                }
                if (menu >= 0)
                {
                    selected = true;
                }
            }
            break;
        case SDL_EVENT_MOUSE_MOTION:
            menu = -1;
            for (int i = 0; i < 4; i++)
            {
                if (MouseInRegion(pos[i].x - 65, pos[i].y - 70, 130, 140))
                {
                    menu = i;
                    break;
                }
            }
            break;
        }

        if (selected)
        {
            selected = false;
            while (menu >= 0 && menu <= 3)
            {
                MenuEscType = menu;
                switch (menu)
                {
                case 0: MenuStatus(); break;
                case 1: MenuAbility(); break;
                case 2: MenuItem(); break;
                case 3: MenuSystem(); break;
                }
                // 物品和系统有可能使屏幕内容变化
                if (Where < 3 && (menu == 2 || menu == 3))
                {
                    FreeFreshScreen();
                    Redraw();
                    RecordFreshScreen();
                }
                menu = MenuEscType;
            }
            // 脚本控制esc的选项
            if (MenuEscType == -2)
            {
                break;
            }
        }
        CleanKeyValue();
        SDL_Delay(30);
    }

menuesc_exit:
    CleanKeyValue();
    // 收起动画
    for (int i = 25; i >= DISABLE_MENU_AMI; i--)
    {
        LoadFreshScreen();
        DrawMPic(2020, CENTER_X - 193, CENTER_Y - 182, 0, 0, i * 255 / 25, 0, 0);
        for (int j2 = 0; j2 < 4; j2++)
        {
            int x1 = LinearInsert(i, 0, 25, CENTER_X, pos[j2].x);
            int y1 = LinearInsert(i, 0, 25, CENTER_Y, pos[j2].y);
            DrawMPic(2021, x1 - 65, y1 - 70, 0, 0, i * 255 / 25, 0, 0);
            DrawMPic(2022 + j2, x1 - 30, y1 - 25, 0, 0, i * 255 / 25, 0, 0);
        }
        UpdateAllScreen();
        SDL_PollEvent(&event);
        CheckBasicEvent();
        SDL_Delay(10);
    }

    NeedRefreshScene = 1;
    FreeFreshScreen();
}

void DrawTitleMenu(int menu)
{
    if (Where <= 1)
    {
        for (int i = 0; i < 4; i++)
        {
            if (i == menu)
            {
                DrawMPic(2022 + i, TitleMenu[i].x, TitleMenu[i].y, 0, 0, 255, 0, 0, 0.75, 0.75);
            }
            else
            {
                DrawMPic(2022 + i, TitleMenu[i].x, TitleMenu[i].y, 0, 0, 255, 0, 50, 0.75, 0.75);
            }
        }
    }
}

int CheckTitleMenu()
{
    int result = MenuEscType;
    if (event.type == SDL_EVENT_MOUSE_BUTTON_UP && event.button.button == SDL_BUTTON_LEFT
        && MouseInRegion(TitleMenu[0].x, TitleMenu[0].y,
            TitleMenu[3].x + TitleMenu[3].w - TitleMenu[0].x,
            TitleMenu[3].y + TitleMenu[3].h - TitleMenu[0].y))
    {
        for (int i = 0; i < 4; i++)
        {
            if (MouseInRegion(TitleMenu[i].x, TitleMenu[i].y, TitleMenu[i].w, TitleMenu[i].h))
            {
                result = i;
                break;
            }
        }
    }
    if (event.type == SDL_EVENT_KEY_UP && event.key.key >= SDLK_1 && event.key.key <= SDLK_4)
    {
        result = event.key.key - SDLK_1;
    }
    return result;
}

//----------------------------------------------------------------------
// 菜单实现 (框架)
//----------------------------------------------------------------------
void MenuMedcine()
{
    std::string str = "隊員醫療能力";
    DrawTextWithRect(str, 80, 30, 132, ColColor(0x23), ColColor(0x21));
    int menu = SelectOneTeamMember(80, 65, "%4d", 46, 0);
    UpdateAllScreen();
    if (menu >= 0)
    {
        int role1 = TeamList[menu];
        str = "隊員目前生命";
        DrawTextWithRect(str, 80, 30, 132, ColColor(0x23), ColColor(0x21));
        menu = SelectOneTeamMember(80, 65, "%4d/%4d", 17, 18);
        int role2 = TeamList[menu];
        if (menu >= 0)
        {
            EffectMedcine(role1, role2);
        }
    }
    Redraw();
}

void MenuMedPoison()
{
    std::string str = "隊員解毒能力";
    DrawTextWithRect(str, 80, 30, 132, ColColor(0x23), ColColor(0x21));
    int menu = SelectOneTeamMember(80, 65, "%4d", 48, 0);
    UpdateAllScreen();
    if (menu >= 0)
    {
        int role1 = TeamList[menu];
        str = "隊員中毒程度";
        DrawTextWithRect(str, 80, 30, 132, ColColor(0x23), ColColor(0x21));
        menu = SelectOneTeamMember(80, 65, "%4d", 20, 0);
        int role2 = TeamList[menu];
        if (menu >= 0)
        {
            EffectMedPoison(role1, role2);
        }
    }
    Redraw();
}
bool MenuItem()
{
    int listLT = 0, x = 0, y = 0, px = -1, py = -1, col = 7, row = 3;
    int plistLT = 0, pmenu = -1, iamount, menu, maxteam;
    int d = 83;
    int titlex1 = CENTER_X - 200, titley1 = 50, titlew = 45, titlemax = 10;
    int xp = titlex1, yp = titley1 + 25;
    int regionx1 = xp + 5, regionx2 = regionx1 + d * col;
    int regiony1 = yp + 35, regiony2 = regiony1 + d * row;
    int intitle = 1, pintitle = -1, dragitem = -1, dragitemx = 0, dragitemy = 0, dragteammate = -1;
    int level;
    bool refresh = true;
    bool Result = false;

    int ItemTypeList[11] = { 0, 10, 11, 3, 4, 21, 22, 23, 24, 25, 32 };
    std::string words2[23] = {
        "生命", "生命", "中毒", "體力",
        "內力", "內力", "內力", "攻擊",
        "輕功", "防禦", "醫療", "用毒",
        "解毒", "抗毒", "拳掌", "御劍",
        "耍刀", "特殊", "暗器", "作弊",
        "品德", "移動", "帶毒"
    };
    std::string words3[13] = {
        "內力", "內力", "攻擊", "輕功",
        "用毒", "醫療", "解毒", "拳掌",
        "御劍", "耍刀", "特殊", "暗器",
        "資質"
    };
    std::string menuString[11] = {
        "劇情", "兵器", "護甲",
        "丹藥", "暗器", "拳經",
        "劍譜", "刀錄", "奇門",
        "暗典", "心法"
    };

    LoadTeamSimpleStatus(maxteam);
    int curitem = -1;
    Redraw();
    TransBlackScreen();
    DrawTitleMenu(2);
    RecordFreshScreen();

    if (Where == 2)
    {
        menu = 3;
    }
    else
    {
        menu = MenuItemType;
    }
    iamount = ReadItemList(ItemTypeList[MenuItemType]);

    while (SDL_PollEvent(&event) || true)
    {
        if (refresh)
        {
            if (menu != pmenu)
            {
                listLT = 0;
            }
            iamount = ReadItemList(ItemTypeList[menu]);
            LoadFreshScreen();
            CleanTextScreen();

            // === ShowMenuItem inline ===
            {
                int dt = d * row, l = 6, w2 = 90;
                int lostfocus = (dragitem >= 0) ? 1 : intitle;
                DrawTextFrame(xp - 8, yp, 60, 230);
                DrawTextFrame(xp - 8, 45 + dt + yp, 60, 230, 0, 20);
                for (int i1 = 0; i1 < row; i1++)
                {
                    for (int i2 = 0; i2 < col; i2++)
                    {
                        int listnum = ItemList[i1 * col + i2 + listLT];
                        if (listnum >= 0 && listnum < MAX_ITEM_AMOUNT)
                        {
                            int item = RItemList[listnum].Number;
                            if (item >= 0)
                            {
                                DrawIPic(item, i2 * d + 5 + xp, i1 * d + 35 + yp, 0, 230, 0, 10);
                            }
                        }
                    }
                }
                int listnum = ItemList[y * col + x + listLT];
                int item = -1;
                if (listnum >= 0 && listnum < MAX_ITEM_AMOUNT && lostfocus == 0)
                {
                    item = RItemList[listnum].Number;
                    DrawIPic(item, x * d + 5 + xp + 1, y * d + 35 + yp + 1, 0, 255, 0, 0);
                }
                curitem = (dragitem >= 0) ? dragitem : item;
                CurItem = curitem;

                if (listnum >= 0 && listnum < MAX_ITEM_AMOUNT && item >= 0 && RItemList[listnum].Amount > 0)
                {
                    int amount = RItemList[listnum].Amount;
                    auto buf = std::format("{:8d}", amount);
                    DrawShadowText(buf, 510 + xp, 3 + yp, ColColor(0x64), ColColor(0x66));
                    int len = DrawLength(std::string((char*)Ritem[item].Name));
                    DrawShadowText(std::string((char*)Ritem[item].Name), 290 - len * 5 + xp, 3 + yp, 0, 0x202020);
                    if (item == COMPASS_ID)
                    {
                        buf = std::format("{:3d},{:3d}", My, Mx);
                        std::string s1 = "你的位置：";
                        DrawShadowText(s1, 8 + xp, 48 + dt + yp, 0, 0x202020);
                        DrawShadowText(buf, 108 + xp, 48 + dt + yp, ColColor(0x64), ColColor(0x66));
                        buf = std::format("{:3d},{:3d}", ShipX, ShipY);
                        std::string s2 = "船的位置：";
                        DrawShadowText(s2, 188 + xp, 48 + dt + yp, 0, 0x202020);
                        DrawShadowText(buf, 288 + xp, 48 + dt + yp, ColColor(0x64), ColColor(0x66));
                    }
                    else
                    {
                        DrawShadowText(std::string((char*)Ritem[item].Introduction), 8 + xp, 47 + dt + yp, 0, 0x202020);
                        if (Ritem[item].User >= 0)
                        {
                            int len2 = DrawLength(std::string((char*)Ritem[item].Introduction));
                            std::string suse = "使用";
                            int namelen = DrawLength(std::string((char*)Rrole[Ritem[item].User].Name));
                            DrawShadowText(suse, 18 + namelen * 10 + len2 * 10 + xp, 47 + dt + yp, ColColor(0x64), ColColor(0x66));
                            DrawShadowText(std::string((char*)Rrole[Ritem[item].User].Name), 18 + len2 * 10 + xp, 47 + dt + yp, ColColor(0x64), ColColor(0x66));
                        }
                    }
                }
                // 功效/需求
                if (item >= 0 && Ritem[item].ItemType > 0)
                {
                    int p2[23] = {}, p3[13] = {};
                    int len2 = 0, len3 = 0;
                    for (int i = 0; i <= 22; i++)
                    {
                        if (Ritem[item].Data[45 + i] != 0 && i != 4)
                        {
                            p2[i] = 1;
                            len2++;
                        }
                    }
                    if (Ritem[item].ChangeMPType == 2)
                    {
                        p2[4] = 1;
                        len2++;
                    }
                    for (int i = 0; i <= 12; i++)
                    {
                        if (Ritem[item].Data[69 + i] != 0 && i != 0)
                        {
                            p3[i] = 1;
                            len3++;
                        }
                    }
                    if ((Ritem[item].NeedMPType == 0 || Ritem[item].NeedMPType == 1) && Ritem[item].ItemType != 3)
                    {
                        p3[0] = 1;
                        len3++;
                    }
                    int l1 = l - 1;
                    if (len2 + len3 > 0)
                    {
                        for (int i = 0; i < (len2 + l1) / l + (len3 + l1) / l; i++)
                        {
                            DrawTextFrame(xp - 8, 75 + dt + yp + i * 28, 60, 204, 0, 50);
                        }
                    }
                    if (len2 > 0)
                    {
                        std::string s = "功效：";
                        DrawShadowText(s, 8 + xp, 78 + dt + yp, ColColor(0x21), ColColor(0x23));
                    }
                    if (len3 > 0)
                    {
                        std::string s = "需求：";
                        DrawShadowText(s, 8 + xp, 78 + dt + (len2 + l1) / l * 28 + yp, ColColor(0x21), ColColor(0x23));
                    }
                    int i1 = 0;
                    for (int i = 0; i <= 22; i++)
                    {
                        if (p2[i])
                        {
                            std::string str2 = std::format("{}", Ritem[item].Data[45 + i]);
                            if (i == 4)
                            {
                                switch (Ritem[item].ChangeMPType)
                                {
                                case 0: str2 = "陰"; break;
                                case 1: str2 = "陽"; break;
                                case 2: str2 = "調和"; break;
                                }
                            }
                            uint32 c1, c2;
                            if (i == 0 || i == 5)
                            {
                                c1 = ColColor(0x10);
                                c2 = ColColor(0x13);
                            }
                            else
                            {
                                c1 = ColColor(0x64);
                                c2 = ColColor(0x66);
                            }
                            DrawShadowText(words2[i], 68 + (i1 % l) * w2 + xp, (i1 / l) * 28 + 78 + dt + yp, ColColor(5), ColColor(7));
                            DrawShadowText(str2, 108 + (i1 % l) * w2 + xp, (i1 / l) * 28 + 78 + dt + yp, c1, c2);
                            i1++;
                        }
                    }
                    i1 = 0;
                    for (int i = 0; i <= 12; i++)
                    {
                        if (p3[i])
                        {
                            std::string str2 = std::format("{}", Ritem[item].Data[69 + i]);
                            if (i == 0)
                            {
                                switch (Ritem[item].NeedMPType)
                                {
                                case 0: str2 = "陰"; break;
                                case 1: str2 = "陽"; break;
                                case 2: str2 = "調和"; break;
                                }
                            }
                            uint32 c1, c2;
                            if (i == 1)
                            {
                                c1 = ColColor(0x10);
                                c2 = ColColor(0x13);
                            }
                            else
                            {
                                c1 = ColColor(0x64);
                                c2 = ColColor(0x66);
                            }
                            DrawShadowText(words3[i], 68 + (i1 % l) * w2 + xp, ((len2 + l1) / l + i1 / l) * 28 + 78 + dt + yp, ColColor(0x50), ColColor(0x4E));
                            DrawShadowText(str2, 108 + (i1 % l) * w2 + xp, ((len2 + l1) / l + i1 / l) * 28 + 78 + dt + yp, c1, c2);
                            i1++;
                        }
                    }
                }
                if (lostfocus == 0)
                {
                    DrawItemFrame(x, y);
                }
            }
            // === End ShowMenuItem ===

            if (Where != 2)
            {
                for (int i = 0; i <= maxteam; i++)
                {
                    if (CanEquip(TeamList[i], curitem))
                    {
                        DrawSimpleStatusByTeam(i, ui_x, ui_y + i * 80, 0, 0);
                    }
                    else
                    {
                        DrawSimpleStatusByTeam(i, ui_x, ui_y + i * 80, 0, 50);
                    }
                    if (curitem >= 0 && TeamList[i] == Ritem[curitem].User)
                    {
                        std::string s = "使用中";
                        DrawTextWithRect(s, ui_x + 15, ui_y + i * 80 + 50, 0, ColColor(0x64), ColColor(0x66), 128, 0);
                    }
                    if (Ritem[curitem].Magic > 0)
                    {
                        level = GetMagicLevel(TeamList[i], Ritem[curitem].Magic);
                        if (level > 0)
                        {
                            auto buf = std::format("{:2d}級", level);    // %2d級
                            DrawShadowText(buf, ui_x + 220, ui_y + 80 * i + 60, ColColor(0x64), ColColor(0x66));
                        }
                    }
                }
            }
            // 标题栏
            DrawTextFrame(titlex1 - 8, titley1 - 3, titlemax * 5);
            for (int i = 0; i <= titlemax; i++)
            {
                uint32 c1 = 0, c2 = 0x202020;
                if (intitle == 0)
                {
                    c1 = ColColor(0x7A);
                    c2 = ColColor(0x7C);
                }
                if (i == menu)
                {
                    c1 = ColColor(0x64);
                    c2 = ColColor(0x66);
                }
                DrawShadowText(menuString[i], titlex1 + titlew * i + 12, titley1, c1, c2);
            }
            if (dragitem >= 0)
            {
                SDL_GetMouseState2(dragitemx, dragitemy);
                DrawIPic(dragitem, dragitemx - d / 2, dragitemy - d / 2, 0, 255, 0, 0);
            }
            UpdateAllScreen();
            px = x;
            py = y;
            plistLT = listLT;
            pmenu = menu;
            pintitle = intitle;
            Result = false;
        }
        refresh = false;
        CheckBasicEvent();

        // Event handling
        if (event.type == SDL_EVENT_KEY_DOWN)
        {
            if (intitle == 0)
            {
                if (event.key.key == SDLK_DOWN)
                {
                    y++;
                    if (y < 0)
                    {
                        y = 0;
                    }
                    if (y >= row)
                    {
                        if (ItemList[listLT + col * row] >= 0)
                        {
                            listLT += col;
                        }
                        y = row - 1;
                    }
                }
                if (event.key.key == SDLK_UP)
                {
                    y--;
                    if (y < 0)
                    {
                        y = 0;
                        if (listLT > 0)
                        {
                            listLT -= col;
                        }
                    }
                }
                if (event.key.key == SDLK_PAGEDOWN)
                {
                    if (iamount > col * row)
                    {
                        listLT += col * row;
                        if (y < 0)
                        {
                            y = 0;
                        }
                        if (ItemList[listLT + col * row] < 0)
                        {
                            y = y - (iamount - listLT) / col - 1 + row;
                            listLT = (iamount / col - row + 1) * col;
                            if (y >= row)
                            {
                                y = row - 1;
                            }
                        }
                    }
                    else
                    {
                        y = iamount / col;
                    }
                }
                if (event.key.key == SDLK_PAGEUP)
                {
                    listLT -= col * row;
                    if (listLT < 0)
                    {
                        y += listLT / col;
                        listLT = 0;
                        if (y < 0)
                        {
                            y = 0;
                        }
                    }
                }
            }
            if (event.key.key == SDLK_RIGHT)
            {
                if (intitle == 0)
                {
                    x++;
                    if (x >= col)
                    {
                        x = 0;
                    }
                }
                else
                {
                    menu++;
                    if (menu > titlemax)
                    {
                        menu = 0;
                    }
                }
            }
            if (event.key.key == SDLK_LEFT)
            {
                if (intitle == 0)
                {
                    x--;
                    if (x < 0)
                    {
                        x = col - 1;
                    }
                }
                else
                {
                    menu--;
                    if (menu < 0)
                    {
                        menu = titlemax;
                    }
                }
            }
        }
        if (event.type == SDL_EVENT_KEY_UP)
        {
            if (event.key.key == SDLK_ESCAPE)
            {
                if (intitle == 0)
                {
                    intitle = 1;
                }
                else
                {
                    MenuEscType = -1;
                    Result = false;
                    break;
                }
            }
            if (event.key.key == SDLK_RETURN || event.key.key == SDLK_SPACE || (event.key.key == SDLK_DOWN && intitle == 1))
            {
                if (intitle == 0)
                {
                    CurItem = RItemList[ItemList[y * col + x + listLT]].Number;
                    if (Where != 2 && CurItem >= 0 && ItemList[y * col + x + listLT] >= 0)
                    {
                        UseItem(CurItem);
                        if (Ritem[CurItem].ItemType == 0)
                        {
                            LoadTeamSimpleStatus(maxteam);
                        }
                    }
                    Result = true;
                }
                else
                {
                    intitle = 0;
                }
            }
        }
        if (event.type == SDL_EVENT_MOUSE_BUTTON_DOWN)
        {
            if (event.button.button == SDL_BUTTON_LEFT)
            {
                int xm2, ym2;
                if (MouseInRegion(regionx1, regiony1, regionx2 - regionx1, regiony2 - regiony1, xm2, ym2))
                {
                    intitle = 0;
                    x = (xm2 - regionx1) / d;
                    y = (ym2 - regiony1) / d;
                    if (x >= col)
                    {
                        x = col - 1;
                    }
                    if (y >= row)
                    {
                        y = row - 1;
                    }
                    if (x < 0)
                    {
                        x = 0;
                    }
                    if (y < 0)
                    {
                        y = 0;
                    }
                    if (ItemList[y * col + x + listLT] >= 0)
                    {
                        CurItem = RItemList[ItemList[y * col + x + listLT]].Number;
                        dragitem = CurItem;
                    }
                }
            }
        }
        if (event.type == SDL_EVENT_MOUSE_BUTTON_UP)
        {
            if (event.button.button == SDL_BUTTON_RIGHT)
            {
                MenuEscType = -1;
                Result = false;
                break;
            }
            if (event.button.button == SDL_BUTTON_LEFT)
            {
                if (dragitem >= 0)
                {
                    int xm2, ym2;
                    if (MouseInRegion(ui_x, ui_y, 250, 480, xm2, ym2))
                    {
                        dragteammate = (ym2 - ui_y) / 80;
                        if (dragteammate > 5)
                        {
                            dragteammate = -1;
                        }
                        if (Where != 2 && TeamList[dragteammate] >= 0)
                        {
                            UseItem(dragitem, dragteammate);
                            if (Ritem[CurItem].ItemType == 0)
                            {
                                LoadTeamSimpleStatus(maxteam);
                            }
                            dragitem = -1;
                            Result = true;
                        }
                    }
                }
                if (dragitem >= 0)
                {
                    if (CellPhone == 0)
                    {
                        UseItem(CurItem, -1);
                        if (Ritem[CurItem].ItemType == 0)
                        {
                            LoadTeamSimpleStatus(maxteam);
                        }
                        Result = true;
                    }
                    refresh = true;
                    dragitem = -1;
                }
            }
        }
        if (event.type == SDL_EVENT_MOUSE_WHEEL)
        {
            if (event.wheel.y < 0)
            {
                y++;
                if (y < 0)
                {
                    y = 0;
                }
                if (y >= row)
                {
                    if (ItemList[listLT + col * row] >= 0)
                    {
                        listLT += col;
                    }
                    y = row - 1;
                }
            }
            if (event.wheel.y > 0)
            {
                y--;
                if (y < 0)
                {
                    y = 0;
                    if (listLT > 0)
                    {
                        listLT -= col;
                    }
                }
            }
            if (event.wheel.x < 0)
            {
                x++;
                if (x >= col)
                {
                    x = 0;
                }
            }
            if (event.wheel.x > 0)
            {
                x--;
                if (x < 0)
                {
                    x = col - 1;
                }
            }
        }
        if (event.type == SDL_EVENT_MOUSE_MOTION)
        {
            if (dragitem == -1)
            {
                int xm2, ym2;
                if (MouseInRegion(titlex1, titley1, (titlemax + 1) * titlew, 20, xm2, ym2))
                {
                    intitle = 1;
                    menu = (xm2 - titlex1 - 10) / titlew;
                }
                if (MouseInRegion(regionx1, regiony1, regionx2 - regionx1, regiony2 - regiony1, xm2, ym2))
                {
                    intitle = 0;
                    x = (xm2 - regionx1) / d;
                    y = (ym2 - regiony1) / d;
                    if (x >= col)
                    {
                        x = col - 1;
                    }
                    if (y >= row)
                    {
                        y = row - 1;
                    }
                    if (x < 0)
                    {
                        x = 0;
                    }
                    if (y < 0)
                    {
                        y = 0;
                    }
                }
                if (MouseInRegion(regionx1, regiony2, regionx2 - regionx1, 30))
                {
                    if (ItemList[listLT + col * row] >= 0)
                    {
                        listLT += col;
                    }
                }
                if (MouseInRegion(regionx1, regiony1 - 30, regionx2 - regionx1, 30))
                {
                    if (listLT > 0)
                    {
                        listLT -= col;
                    }
                }
            }
        }

        if (Where < 2)
        {
            MenuEscType = CheckTitleMenu();
            if (MenuEscType != 2)
            {
                break;
            }
        }
        refresh = refresh || (x != px) || (y != py) || (listLT != plistLT) || (menu != pmenu) || (intitle != pintitle) || Result || (dragitem >= 0);
        event.key.key = 0;
        event.button.button = 0;
        SDL_Delay(20);
        if (Where == 2 && Result && menu == 3)
        {
            break;
        }
        if (MODVersion != 13 && Where == 2 && Result && menu == 4)
        {
            break;
        }
        if (Where > 2)
        {
            break;
        }
    }
    MenuItemType = menu;
    FreeFreshScreen();
    return Result;
}
int ReadItemList(int ItemType)
{
    int p = 0;
    memset(ItemList, -1, sizeof(ItemList));
    for (int i = 0; i < MAX_ITEM_AMOUNT; i++)
    {
        if (RItemList[i].Number >= 0)
        {
            int subType = Ritem[RItemList[i].Number].ItemType;
            if (subType == 1 && ItemType >= 10)
            {
                subType = 10 + Ritem[RItemList[i].Number].EquipType;
            }
            if (subType == 2 && ItemType >= 20)
            {
                int mnum = Ritem[RItemList[i].Number].Magic;
                if (mnum <= 0)
                {
                    subType = 20;
                }
                else
                {
                    switch (Rmagic[mnum].HurtType)
                    {
                    case 1: subType = 26; break;
                    case 2: subType = 27; break;
                    case 3: subType = 28; break;
                    default: subType = 20 + Rmagic[mnum].MagicType; break;
                    }
                }
                if (subType == 20 || subType == 26 || subType == 27 || subType == 28)
                {
                    subType = 32;
                }
            }
            if (subType == ItemType || ItemType == -1)
            {
                ItemList[p] = i;
                p++;
            }
            if (MODVersion == 13 && RItemList[i].Number == MONEY_ID && ItemType == 4)
            {
                ItemList[p] = i;
                p++;
            }
        }
    }
    return p;
}
void UseItem(int inum, int teammate)
{
    if (Where == 2)
    {
        return;
    }
    CurItem = inum;
    int potentialUser = -1;
    if (teammate >= 0 && teammate <= 5)
    {
        potentialUser = TeamList[teammate];
    }
    int menu = -1;
    switch (Ritem[inum].ItemType)
    {
    case 0:    // 剧情物品
    {
        if (Ritem[inum].UnKnow7 > 0)
        {
            CallEvent(Ritem[inum].UnKnow7);
        }
        else
        {
            if (Where == 1)
            {
                int x = Sx, y = Sy;
                switch (SFace)
                {
                case 0: x--; break;
                case 1: y++; break;
                case 2: y--; break;
                case 3: x++; break;
                }
                if (SData[CurScene][3][x][y] >= 0)
                {
                    CurEvent = SData[CurScene][3][x][y];
                    if (DData[CurScene][CurEvent][3] >= 0)
                    {
                        Cx = Sx;
                        Cy = Sy;
                        SStep = 0;
                        CurSceneRolePic = BEGIN_WALKPIC2 + SFace * 7 + SStep;
                        CallEvent(DData[CurScene][CurEvent][3]);
                    }
                }
                CurEvent = -1;
            }
        }
        break;
    }
    case 1:    // 装备
    {
        menu = 1;
        if (Ritem[inum].User >= 0 && (potentialUser < 0 || (Ritem[inum].User != potentialUser && CanEquip(potentialUser, inum))))
        {
            TransBlackScreen();
            UpdateAllScreen();
            std::string menuString[2] = { "取消", "繼續" };    // 取消, 繼續
            std::string str = "此物品正有人裝備，是否繼續？";
            DrawTextWithRect(str, CENTER_X - 142, CENTER_Y - 40, 285, 0, 0x202020);
            menu = CommonMenu2(CENTER_X - 45, CENTER_Y, 45, menuString);
        }
        if (menu == 1)
        {
            if (teammate == -1)
            {
                TransBlackScreen();
                UpdateAllScreen();
                std::string str = "誰要裝備";
                std::string str1((char*)&Ritem[inum].Name[0]);
                int off = DrawTextFrame(CENTER_X - 275, CENTER_Y - 193, 8 + DrawLength(str1));
                DrawShadowText(str, CENTER_X - 275 + off, CENTER_Y - 193 + 3, 0, 0x202020);
                DrawShadowText(str1, CENTER_X - 275 + 80 + off, CENTER_Y - 193 + 3, ColColor(0x64), ColColor(0x66));
                UpdateAllScreen();
                int mask = 0;
                for (int i = 0; i <= 5; i++)
                {
                    if (TeamList[i] >= 0 && CanEquip(TeamList[i], inum))
                    {
                        mask |= (1 << i);
                    }
                }
                menu = SelectOneTeamMember(80, 65, "", 0, 0, mask);
            }
            else
            {
                menu = teammate;
            }
            if (menu >= 0)
            {
                int rnum = TeamList[menu];
                int p = Ritem[inum].EquipType;
                if (p < 0 || p > 1)
                {
                    p = 0;
                }
                if (CanEquip(rnum, inum))
                {
                    if (Ritem[inum].User >= 0)
                    {
                        Rrole[Ritem[inum].User].Equip[p] = -1;
                    }
                    if (Rrole[rnum].Equip[p] >= 0)
                    {
                        Ritem[Rrole[rnum].Equip[p]].User = -1;
                    }
                    Rrole[rnum].Equip[p] = inum;
                    Ritem[inum].User = rnum;
                }
                else
                {
                    std::string str = "此人不適合裝備此物品";
                    DrawTextWithRect(str, CENTER_X - 100, CENTER_Y + 40, 205, ColColor(0x64), ColColor(0x66));
                    WaitAnyKey();
                    Redraw();
                }
            }
        }
        break;
    }
    case 2:    // 秘笈
    {
        menu = 1;
        if (Ritem[inum].User >= 0 && (potentialUser < 0 || (Ritem[inum].User != potentialUser && CanEquip(potentialUser, inum))))
        {
            TransBlackScreen();
            UpdateAllScreen();
            std::string menuString[2] = { "取消", "繼續" };    // 取消, 繼續
            std::string str = "此秘笈正有人修煉，是否繼續？";
            DrawTextWithRect(str, CENTER_X - 142, CENTER_Y - 40, 285, 0, 0x202020);
            menu = CommonMenu2(CENTER_X - 45, CENTER_Y, 45, menuString);
        }
        if (menu == 1)
        {
            if (teammate == -1)
            {
                TransBlackScreen();
                UpdateAllScreen();
                std::string str = "誰要修煉";
                std::string str1((char*)&Ritem[inum].Name[0]);
                int off = DrawTextFrame(CENTER_X - 275, CENTER_Y - 193, 8 + DrawLength(str1));
                DrawShadowText(str, CENTER_X - 275 + off, CENTER_Y - 193 + 3, 0, 0x202020);
                DrawShadowText(str1, CENTER_X - 275 + 80 + off, CENTER_Y - 193 + 3, ColColor(0x64), ColColor(0x66));
                UpdateAllScreen();
                int mask = 0;
                for (int i = 0; i <= 5; i++)
                {
                    if (TeamList[i] >= 0 && CanEquip(TeamList[i], inum))
                    {
                        mask |= (1 << i);
                    }
                }
                menu = SelectOneTeamMember(80, 65, "", 0, 0, mask);
            }
            else
            {
                menu = teammate;
            }
            if (menu >= 0)
            {
                int rnum = TeamList[menu];
                if (CanEquip(rnum, inum, 1))
                {
                    int preUser = Ritem[inum].User;
                    if (Ritem[inum].User >= 0)
                    {
                        Rrole[Ritem[inum].User].PracticeBook = -1;
                    }
                    if (Rrole[rnum].PracticeBook >= 0)
                    {
                        Ritem[Rrole[rnum].PracticeBook].User = -1;
                    }
                    Rrole[rnum].PracticeBook = inum;
                    Ritem[inum].User = rnum;
                    if (preUser != rnum)
                    {
                        Rrole[rnum].ExpForItem = 0;
                        Rrole[rnum].ExpForBook = 0;
                    }
                }
                else
                {
                    std::string str = "此人不適合修煉此秘笈";
                    DrawTextWithRect(str, CENTER_X - 100, CENTER_Y + 40, 205, ColColor(0x64), ColColor(0x66));
                    WaitAnyKey();
                    Redraw();
                }
            }
        }
        break;
    }
    case 3:    // 药品
    {
        TransBlackScreen();
        UpdateAllScreen();
        if (Where != 2)
        {
            if (teammate == -1)
            {
                std::string str = "誰要服用";
                std::string str1((char*)&Ritem[inum].Name[0]);
                DrawTextWithRect(str, CENTER_X - 275, CENTER_Y - 193, DrawLength(str1) * 10 + 80, 0, 0x202020);
                DrawShadowText(str1, CENTER_X - 275 + 99, CENTER_Y - 193 + 2, ColColor(0x64), ColColor(0x66));
                UpdateAllScreen();
                menu = SelectOneTeamMember(80, 65, "", 0, 0);
            }
            else
            {
                menu = teammate;
            }
        }
        if (menu >= 0)
        {
            int rnum = TeamList[menu];
            TransBlackScreen();
            EatOneItem(rnum, inum);
            instruct_32(inum, -1);
            ShowSimpleStatus(TeamList[menu], 0, 0, menu);
            WaitAnyKey();
        }
        break;
    }
    case 4:    // 暗器类不处理
        break;
    }
}
bool CanEquip(int rnum, int inum, int use)
{
    auto sign = [](int x)
    {
        return (x > 0) - (x < 0);
    };
    if (inum < 0 || rnum < 0)
    {
        return false;
    }
    bool result = false;
    switch (Ritem[inum].ItemType)
    {
    case 0:
    case 4: result = false; break;
    case 3: result = true; break;
    case 1:
    case 2:
    {
        result = true;
        if (sign(Ritem[inum].NeedMP) * Rrole[rnum].CurrentMP < Ritem[inum].NeedMP)
        {
            result = false;
        }
        if (sign(Ritem[inum].NeedAttack) * Rrole[rnum].Attack < Ritem[inum].NeedAttack)
        {
            result = false;
        }
        if (sign(Ritem[inum].NeedSpeed) * Rrole[rnum].Speed < Ritem[inum].NeedSpeed)
        {
            result = false;
        }
        if (sign(Ritem[inum].NeedUsePoi) * Rrole[rnum].UsePoi < Ritem[inum].NeedUsePoi)
        {
            result = false;
        }
        if (sign(Ritem[inum].NeedMedcine) * Rrole[rnum].Medcine < Ritem[inum].NeedMedcine)
        {
            result = false;
        }
        if (sign(Ritem[inum].NeedMedPoi) * Rrole[rnum].MedPoi < Ritem[inum].NeedMedPoi)
        {
            result = false;
        }
        if (sign(Ritem[inum].NeedFist) * Rrole[rnum].Fist < Ritem[inum].NeedFist)
        {
            result = false;
        }
        if (sign(Ritem[inum].NeedSword) * Rrole[rnum].Sword < Ritem[inum].NeedSword)
        {
            result = false;
        }
        if (sign(Ritem[inum].NeedKnife) * Rrole[rnum].Knife < Ritem[inum].NeedKnife)
        {
            result = false;
        }
        if (sign(Ritem[inum].NeedUnusual) * Rrole[rnum].Unusual < Ritem[inum].NeedUnusual)
        {
            result = false;
        }
        if (sign(Ritem[inum].NeedHidWeapon) * Rrole[rnum].HidWeapon < Ritem[inum].NeedHidWeapon)
        {
            result = false;
        }
        if (sign(Ritem[inum].NeedAptitude) * Rrole[rnum].Aptitude < Ritem[inum].NeedAptitude)
        {
            result = false;
        }
        // 内力性质
        if (Rrole[rnum].MPType < 2 && Ritem[inum].NeedMPType < 2)
        {
            if (Rrole[rnum].MPType != Ritem[inum].NeedMPType)
            {
                result = false;
            }
        }
        // 专用人物
        if (Ritem[inum].OnlyPracRole >= 0 && result)
        {
            result = (Ritem[inum].OnlyPracRole == rnum);
        }
        // 武功栏是否已满
        if (Ritem[inum].Magic > 0)
        {
            int mnum = Ritem[inum].Magic;
            if (GetMagicLevel(rnum, mnum) > 0)
            {
                result = true;
            }
            else
            {
                switch (Rmagic[mnum].HurtType)
                {
                case 3:
                    if (HaveMagicAmount(rnum, 1) >= 4)
                    {
                        result = false;
                    }
                    break;
                case 0:
                case 1:
                case 2:
                    if (HaveMagicAmount(rnum) >= 10)
                    {
                        result = false;
                    }
                    break;
                }
            }
        }
        break;
    }
    }
    // 自宫物品
    if (MODVersion != 13 && use == 1)
    {
        if ((inum == 78 || inum == 93) && result && Rrole[rnum].Sexual != 2)
        {
            TransBlackScreen();
            UpdateAllScreen();
            std::string menuString[2] = { "取消", "繼續" };    // 取消, 繼續
            std::string str = "是否要自宮？";
            DrawTextWithRect(str, CENTER_X - 63, CENTER_Y, 0, 0, 0x202020);
            if (CommonMenu2(CENTER_X - 49, CENTER_Y + 40, 48, menuString) == 1)
            {
                Rrole[rnum].Sexual = 2;
            }
            else
            {
                result = false;
            }
        }
    }
    return result;
}

void MenuStatus()
{
    std::string menuString[3];
    menuString[0] = "更換";
    menuString[1] = "卸下";
    menuString[2] = "取消";
    Redraw();
    DrawMPic(2015, CENTER_X - 384 + 283, CENTER_Y - 240);
    TransBlackScreen();
    DrawTitleMenu(0);
    RecordFreshScreen();

    event.key.key = 0;
    event.button.button = 0;

    int max = 0;
    LoadTeamSimpleStatus(max);
    int menu = MenuEscTeammate;
    int premenu = -1;
    int equip = 0, preequip = -1;
    int item1x = CENTER_X - 384 + 340;
    int item2x = CENTER_X - 384 + 540;
    int item1y = CENTER_Y - 240 + 360;
    int item2y = item1y;
    int d = 83;
    int xm, ym;

    while (SDL_PollEvent(&event) || true)
    {
        if (menu != premenu || equip != preequip)
        {
            LoadFreshScreen();
            for (int i = 0; i <= max; i++)
            {
                DrawSimpleStatusByTeam(i, ui_x, ui_y + i * 80, 0, (i == menu) ? 0 : 50);
            }
            ShowStatus(TeamList[menu]);
            if (equip == 0)
            {
                DrawItemFrame(item1x, item1y, 1);
            }
            else
            {
                DrawItemFrame(item2x, item2y, 1);
            }
            UpdateAllScreen();
            premenu = menu;
            preequip = equip;
        }
        CheckBasicEvent();
        if ((event.type == SDL_EVENT_KEY_DOWN && event.key.key == SDLK_UP)
            || (event.type == SDL_EVENT_MOUSE_WHEEL && event.wheel.y > 0))
        {
            menu--;
            if (menu < 0)
            {
                menu = max;
            }
        }
        if ((event.type == SDL_EVENT_KEY_DOWN && event.key.key == SDLK_DOWN)
            || (event.type == SDL_EVENT_MOUSE_WHEEL && event.wheel.y < 0))
        {
            menu++;
            if (menu > max)
            {
                menu = 0;
            }
        }
        if (event.type == SDL_EVENT_KEY_DOWN && (event.key.key == SDLK_LEFT || event.key.key == SDLK_RIGHT))
        {
            equip = 1 - equip;
        }
        if ((event.type == SDL_EVENT_KEY_UP && event.key.key == SDLK_ESCAPE)
            || (event.type == SDL_EVENT_MOUSE_BUTTON_UP && event.button.button == SDL_BUTTON_RIGHT))
        {
            MenuEscType = -1;
            break;
        }
        if (event.type == SDL_EVENT_MOUSE_MOTION)
        {
            if (MouseInRegion(ui_x, ui_y, 250, 480, xm, ym))
            {
                if (VirtualKeyValue <= 0)
                {
                    menu = std::min(max, (ym - ui_y) / 80);
                }
            }
            if (MouseInRegion(item1x, item1y, d, d))
            {
                equip = 0;
            }
            if (MouseInRegion(item2x, item2y, d, d))
            {
                equip = 1;
            }
        }
        // 点击武器槽
        if ((event.type == SDL_EVENT_MOUSE_BUTTON_UP && event.button.button == SDL_BUTTON_LEFT && MouseInRegion(item1x, item1y, d, d))
            || (event.type == SDL_EVENT_KEY_UP && equip == 0 && (event.key.key == SDLK_RETURN || event.key.key == SDLK_SPACE)))
        {
            int sel = CommonMenu2(item1x - 40, item1y + d, 47, menuString, 2);
            if (sel == 1)    // 卸下
            {
                int rnum = TeamList[menu];
                int inum = Rrole[rnum].Equip[0];
                if (inum >= 0)
                {
                    if (Ritem[inum].User >= 0)
                    {
                        Rrole[rnum].Equip[0] = -1;
                    }
                    Ritem[inum].User = -1;
                }
            }
            else if (sel == 0)    // 更換
            {
                MenuItemType = 1;
                MenuEscType = 2;
                MenuItem();
                if (MenuEscType == -1)
                {
                    MenuEscType = 0;
                }
            }
            premenu = -1;
        }
        // 点击护具槽
        if ((event.type == SDL_EVENT_MOUSE_BUTTON_UP && event.button.button == SDL_BUTTON_LEFT && MouseInRegion(item2x, item2y, d, d))
            || (event.type == SDL_EVENT_KEY_UP && equip == 1 && (event.key.key == SDLK_RETURN || event.key.key == SDLK_SPACE)))
        {
            int sel = CommonMenu2(item2x - 40, item2y + d, 45, menuString, 2);
            if (sel == 1)    // 卸下
            {
                int rnum = TeamList[menu];
                int inum = Rrole[rnum].Equip[1];
                if (inum >= 0)
                {
                    if (Ritem[inum].User >= 0)
                    {
                        Rrole[rnum].Equip[1] = -1;
                    }
                    Ritem[inum].User = -1;
                }
            }
            else if (sel == 0)    // 更換
            {
                MenuItemType = 1;
                MenuEscType = 2;
                MenuItem();
                if (MenuEscType == -1)
                {
                    MenuEscType = 0;
                }
            }
            premenu = -1;
        }
        MenuEscType = CheckTitleMenu();
        if (MenuEscType != 0)
        {
            break;
        }
        SDL_Delay(20);
        event.key.key = 0;
        event.button.button = 0;
    }
    MenuEscTeammate = menu;
    FreeFreshScreen();
}

void ShowStatusByTeam(int tnum)
{
    if (TeamList[tnum] >= 0)
    {
        ShowStatus(TeamList[tnum]);
    }
}

void ShowStatus(int rnum, int bnum)
{
    if (rnum < 0 || rnum >= 1000)
    {
        return;
    }
    const char* strs[] = {
        "等級", "生命", "內力", "體力", "經驗", "升級",
        "攻擊", "防禦", "輕功", "移動",
        "醫療能力", "用毒能力", "解毒能力",
        "拳掌功夫", "御劍能力", "耍刀技巧",
        "特殊兵器", "暗器技巧",
        "武器", "護具",
        "所會武功",
        "受傷", "中毒", "所會內功"
    };

    int xp = CENTER_X - 384 + 260;
    int yp = CENTER_Y - 240 + 5;
    int w = 560;
    int h = 26;
    int item1x = CENTER_X - 384 + 340;
    int item2x = CENTER_X - 384 + 540;
    int item1y = CENTER_Y - 240 + 360;
    int item2y = item1y;
    int x, y;
    std::string buf;
    uint32 color1, color2;

    if (Where == 3)
    {
        xp = CENTER_X - 384 + 100;
        TransBlackScreen();
    }

    x = xp;
    y = yp;
    if (bnum >= 0)
    {
        DrawHeadPic(Rrole[rnum].HeadNum, xp + 60, yp + 10);
        x = xp + 60;
        y = yp - 15;
        std::string name = Rrole[rnum].Name;
        DrawTextWithRect(name, x + 58 - DrawLength((const char*)Rrole[rnum].Name) * 5, y + 180, 0, 0, 0, 255, 0);

        for (int i = 0; i <= 5; i++)
        {
            DrawTextWithRect(strs[i], x - 10, y + 208 + h * i, 140, 0, 0x202020, 179, 0);
        }

        buf = std::format("{:4d}", Rrole[rnum].Level);
        DrawEngShadowText(buf, x + 110, y + 211 + h * 0, ColColor(0x64), ColColor(0x66));

        if (Rrole[rnum].Hurt >= 67)
        {
            color1 = ColColor(0x14);
            color2 = ColColor(0x16);
        }
        else if (Rrole[rnum].Hurt >= 34)
        {
            color1 = ColColor(0x0E);
            color2 = ColColor(0x10);
        }
        else
        {
            color1 = ColColor(5);
            color2 = ColColor(7);
        }
        buf = std::format("{:4d}", Rrole[rnum].CurrentHP);
        DrawEngShadowText(buf, x + 60, y + 211 + h * 1, color1, color2);
        DrawEngShadowText("/", x + 100, y + 211 + h * 1, ColColor(0x64), ColColor(0x66));

        if (Rrole[rnum].Poison >= 67)
        {
            color1 = ColColor(0x35);
            color2 = ColColor(0x37);
        }
        else if (Rrole[rnum].Poison >= 1)
        {
            color1 = ColColor(0x30);
            color2 = ColColor(0x32);
        }
        else
        {
            color1 = ColColor(0x21);
            color2 = ColColor(0x23);
        }
        buf = std::format("{:4d}", Rrole[rnum].MaxHP);
        DrawEngShadowText(buf, x + 110, y + 211 + h * 1, color1, color2);

        if (Rrole[rnum].MPType == 0)
        {
            color1 = ColColor(0x4E);
            color2 = ColColor(0x50);
        }
        else if (Rrole[rnum].MPType == 1)
        {
            color1 = ColColor(5);
            color2 = ColColor(7);
        }
        else
        {
            color1 = ColColor(0x64);
            color2 = ColColor(0x66);
        }
        buf = std::format("{:4d}/{:4d}", Rrole[rnum].CurrentMP, Rrole[rnum].MaxMP);
        DrawEngShadowText(buf, x + 60, y + 211 + h * 2, color1, color2);

        buf = std::format("{:4d}/{:4d}", Rrole[rnum].PhyPower, MAX_PHYSICAL_POWER);
        DrawEngShadowText(buf, x + 60, y + 211 + h * 3, ColColor(0x64), ColColor(0x66));

        buf = std::format("{:5d}", (uint16_t)Rrole[rnum].Exp);
        DrawEngShadowText(buf, x + 100, y + 211 + h * 4, ColColor(0x64), ColColor(0x66));
        buf = std::format("{:5d}", (uint16_t)LevelUpList[Rrole[rnum].Level - 1]);
        DrawEngShadowText(buf, x + 100, y + 211 + h * 5, ColColor(0x64), ColColor(0x66));

        if (Where != 2)
        {
            DrawTextWithRect(strs[18], item1x + 85, item1y, 0, 0, 0x202020, 255, 0);
            DrawTextWithRect(strs[19], item2x + 85, item2y, 0, 0, 0x202020, 255, 0);
            if (Rrole[rnum].Equip[0] >= 0)
            {
                DrawTextWithRect(Ritem[Rrole[rnum].Equip[0]].Name, item1x + 85, item1y + 30, 0, ColColor(0x64), ColColor(0x66), 179, 0);
                DrawIPic(Rrole[rnum].Equip[0], item1x, item1y);
            }
            if (Rrole[rnum].Equip[1] >= 0)
            {
                DrawTextWithRect(Ritem[Rrole[rnum].Equip[1]].Name, item2x + 85, item2y + 30, 0, ColColor(0x64), ColColor(0x66), 179, 0);
                DrawIPic(Rrole[rnum].Equip[1], item2x, item2y);
            }
        }
    }

    x = xp - 20;
    y = yp + 35;
    if (bnum < 0)
    {
        x = CENTER_X - 390;
        y = CENTER_Y - 240 + 80;
        h = 26;
        if (bnum == -2)
        {
            x += 100;
        }
    }

    if (bnum < 0)
    {
        if (bnum == -1)
        {
            for (int i = 0; i <= 2; i++)
            {
                DrawTextWithRect(strs[i], x + 280, y + 2 + h * i, 240, 0, 0x202020, 153, 0);
            }
            for (int i = 0; i <= 14; i++)
            {
                DrawShadowText("->", x + 450, y + 5 + h * i, ColColor(0x64), ColColor(0x66));
            }
        }
        buf = std::format("{:4d}", Rrole[rnum].Level);
        DrawEngShadowText(buf, x + 380, y + 5 + h * 0, ColColor(0x64), ColColor(0x66));
        buf = std::format("{:4d}", Rrole[rnum].MaxHP);
        DrawEngShadowText(buf, x + 380, y + 5 + h * 1, ColColor(0x64), ColColor(0x66));
        buf = std::format("{:4d}", Rrole[rnum].MaxMP);
        DrawEngShadowText(buf, x + 380, y + 5 + h * 2, ColColor(0x64), ColColor(0x66));
        y += 3 * h;
    }

    int addnum[4] = {};
    if (Rrole[rnum].Equip[0] >= 0)
    {
        addnum[0] += Ritem[Rrole[rnum].Equip[0]].AddAttack;
        addnum[1] += Ritem[Rrole[rnum].Equip[0]].AddDefence;
        addnum[2] += Ritem[Rrole[rnum].Equip[0]].AddSpeed;
        addnum[3] += Ritem[Rrole[rnum].Equip[0]].AddMove * 10;
    }
    if (Rrole[rnum].Equip[1] >= 0)
    {
        addnum[0] += Ritem[Rrole[rnum].Equip[1]].AddAttack;
        addnum[1] += Ritem[Rrole[rnum].Equip[1]].AddDefence;
        addnum[2] += Ritem[Rrole[rnum].Equip[1]].AddSpeed;
        addnum[3] += Ritem[Rrole[rnum].Equip[1]].AddMove * 10;
    }

    if (Where == 2 && bnum >= 0)
    {
        addnum[0] += Brole[bnum].StateLevel[0] * Rrole[rnum].Attack / 100;
        addnum[1] += Brole[bnum].StateLevel[1] * Rrole[rnum].Defence / 100;
        addnum[2] += Brole[bnum].StateLevel[2] * Rrole[rnum].Speed / 100;
        addnum[3] += Brole[bnum].StateLevel[3] * 10;
        addnum[0] += Brole[bnum].loverlevel[0] * Rrole[rnum].Attack / 100;
        addnum[1] += Brole[bnum].loverlevel[1] * Rrole[rnum].Defence / 100;
        addnum[2] += Brole[bnum].loverlevel[9] * Rrole[rnum].Speed / 100;
        addnum[3] += Brole[bnum].loverlevel[2] * 10;
    }

    for (int i = 6; i <= 17; i++)
    {
        w = 120;
        if (i <= 9 && addnum[i - 6] != 0)
        {
            w = 190;
        }
        if (bnum == -1)
        {
            w = 240;
        }
        if (bnum != -2)
        {
            DrawTextWithRect(strs[i], x + 280, y + 2 + h * (i - 6), w, 0, 0x202020, 153, 0);
        }
    }

    color1 = ColColor(0x64);
    color2 = ColColor(0x66);
    if (bnum >= 0)
    {
        for (int i = 0; i < 4; i++)
        {
            if (addnum[i] != 0)
            {
                if (addnum[i] > 0)
                {
                    buf = std::format(" (+{})", addnum[i]);
                }
                else
                {
                    buf = std::format(" ({})", addnum[i]);
                }
                DrawEngShadowText(buf, x + 420, y + 5 + i * h, color1, color2);
            }
        }
    }

    color1 = ColColor(0x64);
    color2 = ColColor(0x66);
    buf = std::format("{:4d}", Rrole[rnum].Attack + addnum[0]);
    SetColorByPro(Rrole[rnum].Attack + addnum[0], 600, color1, color2);
    DrawEngShadowText(buf, x + 380, y + 5 + h * 0, color1, color2);

    buf = std::format("{:4d}", Rrole[rnum].Defence + addnum[1]);
    SetColorByPro(Rrole[rnum].Defence + addnum[1], 600, color1, color2);
    DrawEngShadowText(buf, x + 380, y + 5 + h * 1, color1, color2);

    buf = std::format("{:4d}", Rrole[rnum].Speed + addnum[2]);
    SetColorByPro(Rrole[rnum].Speed + addnum[2], 300, color1, color2);
    DrawEngShadowText(buf, x + 380, y + 5 + h * 2, color1, color2);

    buf = std::format("{:4d}", Rrole[rnum].Movestep + addnum[3]);
    SetColorByPro(Rrole[rnum].Movestep + addnum[3], 100, color1, color2);
    DrawEngShadowText(buf, x + 380, y + 5 + h * 3, color1, color2);

    buf = std::format("{:4d}", Rrole[rnum].Medcine);
    SetColorByPro(Rrole[rnum].Medcine, 200, color1, color2);
    DrawEngShadowText(buf, x + 380, y + 5 + h * 4, color1, color2);

    buf = std::format("{:4d}", Rrole[rnum].UsePoi);
    SetColorByPro(Rrole[rnum].UsePoi, 100, color1, color2);
    DrawEngShadowText(buf, x + 380, y + 5 + h * 5, color1, color2);

    buf = std::format("{:4d}", Rrole[rnum].MedPoi);
    SetColorByPro(Rrole[rnum].MedPoi, 100, color1, color2);
    DrawEngShadowText(buf, x + 380, y + 5 + h * 6, color1, color2);

    buf = std::format("{:4d}", Rrole[rnum].Fist);
    SetColorByPro(Rrole[rnum].Fist, 300, color1, color2);
    DrawEngShadowText(buf, x + 380, y + 5 + h * 7, color1, color2);

    buf = std::format("{:4d}", Rrole[rnum].Sword);
    SetColorByPro(Rrole[rnum].Sword, 300, color1, color2);
    DrawEngShadowText(buf, x + 380, y + 5 + h * 8, color1, color2);

    buf = std::format("{:4d}", Rrole[rnum].Knife);
    SetColorByPro(Rrole[rnum].Knife, 300, color1, color2);
    DrawEngShadowText(buf, x + 380, y + 5 + h * 9, color1, color2);

    buf = std::format("{:4d}", Rrole[rnum].Unusual);
    SetColorByPro(Rrole[rnum].Unusual, 300, color1, color2);
    DrawEngShadowText(buf, x + 380, y + 5 + h * 10, color1, color2);

    buf = std::format("{:4d}", Rrole[rnum].HidWeapon);
    SetColorByPro(Rrole[rnum].HidWeapon, 300, color1, color2);
    DrawEngShadowText(buf, x + 380, y + 5 + h * 11, color1, color2);

    if (Where == 2 && bnum >= 0)
    {
        int k = 0;
        for (int i = 0; i < (int)loverstrs.size(); i++)
        {
            if (Brole[bnum].loverlevel[i] != 0 && !loverstrs[i].empty())
            {
                if (Brole[bnum].loverlevel[i] > 0)
                {
                    color1 = 0xfd6c9e;
                    color2 = 0xff69b4;
                }
                else
                {
                    color1 = ColColor(0x50);
                    color2 = ColColor(0x4E);
                }
                DrawShadowText(loverstrs[i], xp + 70 + 70 * (k % 4), yp + 360 + h * (k / 4), color1, color2);
                int simple_temp = SIMPLE;
                SIMPLE = 0;
                DrawShadowText("♥", xp + 110 + 70 * (k % 4), yp + 360 + h * (k / 4), color1, color2);
                SIMPLE = simple_temp;
                k++;
            }
        }
        k = 0;
        for (int i = 0; i < 34; i++)
        {
            if (Brole[bnum].StateRound[i] != 0 && i < (int)statestrs.size() && !statestrs[i].empty())
            {
                if (Brole[bnum].StateLevel[i] >= 0)
                {
                    color1 = ColColor(0x14);
                    color2 = ColColor(0x16);
                }
                else
                {
                    color1 = ColColor(0x50);
                    color2 = ColColor(0x4E);
                }
                DrawShadowText(statestrs[i], xp + 70 + 50 * (k % 8), yp + 390 + h * (k / 8), color1, color2);
                k++;
            }
        }
    }
}

void ShowSimpleStatus(int rnum, int x, int y, int forTeam)
{
    if (rnum < 0)
    {
        return;
    }
    int x1 = 0, y1 = 0, w1 = 960, h1 = 90;
    GetRealRect(x1, y1, w1, h1);

    if (forTeam == -1)
    {
        SDL_SetRenderTarget(render, SimpleStateTex);
        SDL_SetRenderDrawBlendMode(render, SDL_BLENDMODE_NONE);
        SDL_SetRenderDrawColor(render, 0, 0, 0, 0);
        SDL_RenderClear(render);
    }
    else
    {
        forTeam = std::clamp(forTeam, 0, 5);
    }

    SDL_Rect dest2 = { x, y, 960, 90 };
    int ox = 0, oy = 0;

    SetFontSize(17, 12);
    DrawMPic(2002, ox, oy);

    uint32 mixColor = MapRGBA(255 - Rrole[rnum].Poison * 2, 255, 255 - Rrole[rnum].Poison * 2);
    int mixAlpha = -1;
    DrawHeadPic(Rrole[rnum].HeadNum, ox + 10, oy, 0, 255, mixColor, mixAlpha, 0.5, 0.5);

    int alpha = 51;
    int w;
    uint32 color;

    // HP bar
    if (Rrole[rnum].MaxHP == 0)
    {
        w = 138;
    }
    else
    {
        w = 138 * Rrole[rnum].CurrentHP / std::min((int)Rrole[rnum].MaxHP, 9999);
    }
    w = std::clamp(w, 0, 138);
    color = MapRGBA(196, std::max(0, 25 - Rrole[rnum].Hurt / 5), 16);
    DrawRectangleWithoutFrame(ox + 96, oy + 32, w, 9, color, -1);
    DrawRectangleWithoutFrame(ox + 96 + w, oy + 32, 138 - w, 9, color, alpha);

    // MP bar
    if (Rrole[rnum].MaxMP == 0)
    {
        w = 138;
    }
    else
    {
        w = 138 * Rrole[rnum].CurrentMP / Rrole[rnum].MaxMP;
    }
    w = std::clamp(w, 0, 138);
    switch (Rrole[rnum].MPType)
    {
    case 0: color = MapRGBA(112, 12, 112); break;
    case 1: color = MapRGBA(224, 180, 32); break;
    default: color = MapRGBA(160, 160, 160); break;
    }
    DrawRectangleWithoutFrame(ox + 96, oy + 48, w, 9, color, -1);
    DrawRectangleWithoutFrame(ox + 96 + w, oy + 48, 138 - w, 9, color, alpha);

    // PhyPower bar
    w = 83 * Rrole[rnum].PhyPower / MAX_PHYSICAL_POWER;
    w = std::clamp(w, 0, 83);
    color = MapRGBA(128, 128, 255);
    DrawRectangleWithoutFrame(ox + 115, oy + 65, w, 9, color, -1);
    DrawRectangleWithoutFrame(ox + 115 + w, oy + 65, 83 - w, 9, color, alpha);

    SDL_Texture* tex = nullptr;
    SDL_Surface* sur = nullptr;
    if (TEXT_LAYER == 1)
    {
        ox = dest2.x;
        oy = dest2.y;
        if (forTeam == -1)
        {
            tex = TextScreenTex;
        }
        else
        {
            tex = SimpleTextTex[forTeam];
        }
    }

    // Name
    std::string str = Rrole[rnum].Name;
    DrawShadowText(str, ox + 115, oy + 8, ColColor(0x64), ColColor(0x66), tex, sur);

    // Level
    std::string buf = std::format("{}", Rrole[rnum].Level);
    DrawEngShadowText(buf, ox + 102 - (int)buf.size() * 3, oy + 6, ColColor(5), ColColor(7), tex, sur);

    // HP
    uint32 color1, color2;
    if (Rrole[rnum].Hurt >= 67)
    {
        color1 = ColColor(0x14);
        color2 = ColColor(0x16);
    }
    else if (Rrole[rnum].Hurt >= 34)
    {
        color1 = ColColor(0x10);
        color2 = ColColor(0x0E);
    }
    else
    {
        color1 = ColColor(5);
        color2 = ColColor(7);
    }
    buf = std::format("{:4d}", Rrole[rnum].CurrentHP);
    DrawEngShadowText(buf, ox + 138, oy + 28, color1, color2, tex, sur);
    DrawEngShadowText("/", ox + 165, oy + 28, ColColor(0x64), ColColor(0x66), tex, sur);

    if (Rrole[rnum].Poison >= 67)
    {
        color1 = ColColor(0x35);
        color2 = ColColor(0x37);
    }
    else if (Rrole[rnum].Poison >= 1)
    {
        color1 = ColColor(0x30);
        color2 = ColColor(0x32);
    }
    else
    {
        color1 = ColColor(0x21);
        color2 = ColColor(0x23);
    }
    buf = std::format("{:4d}", Rrole[rnum].MaxHP);
    DrawEngShadowText(buf, ox + 173, oy + 28, color1, color2, tex, sur);

    // MP
    if (Rrole[rnum].MPType == 0)
    {
        color1 = ColColor(0x4E);
        color2 = ColColor(0x50);
    }
    else if (Rrole[rnum].MPType == 1)
    {
        color1 = ColColor(0x1C);
        color2 = ColColor(0x1D);
    }
    else
    {
        color1 = ColColor(0x64);
        color2 = ColColor(0x66);
    }
    buf = std::format("{:4d}", Rrole[rnum].CurrentMP);
    DrawEngShadowText(buf, ox + 138, oy + 44, color1, color2, tex, sur);
    DrawEngShadowText("/", ox + 165, oy + 44, color1, color2, tex, sur);
    buf = std::format("{:4d}", Rrole[rnum].MaxMP);
    DrawEngShadowText(buf, ox + 173, oy + 44, color1, color2, tex, sur);

    // PhyPower
    buf = std::format("{:3d}", Rrole[rnum].PhyPower);
    DrawEngShadowText(buf, ox + 148, oy + 61, ColColor(5), ColColor(7), tex, sur);

    ResetFontSize();

    if (forTeam == -1)
    {
        SDL_SetRenderTarget(render, screenTex);
        SDL_FRect destf = { (float)dest2.x, (float)dest2.y, (float)dest2.w, (float)dest2.h };
        SDL_RenderTexture(render, SimpleStateTex, nullptr, &destf);
    }
}

void SetColorByPro(int Cur, int MaxValue, uint32& color1, uint32& color2)
{
    int r[] = { 250, 50, 250, 250 };
    int g[] = { 250, 250, 250, 50 };
    int b[] = { 250, 50, 50, 50 };
    double vp[] = { 0, 0.5, 0.75, 1.0 };
    double v = (MaxValue > 0) ? (double)Cur / MaxValue : 0;
    if (v > 1)
    {
        v = 1;
    }
    if (v < 0)
    {
        v = 0;
    }
    int i = 0;
    while (i < 2 && v >= vp[i + 1])
    {
        i++;
    }
    int r1 = RegionParameter(LinearInsert(v, vp[i], vp[i + 1], r[i], r[i + 1]), 0, 250);
    int g1 = RegionParameter(LinearInsert(v, vp[i], vp[i + 1], g[i], g[i + 1]), 0, 250);
    int b1 = RegionParameter(LinearInsert(v, vp[i], vp[i + 1], b[i], b[i + 1]), 0, 250);
    int r2 = (int)(r1 * 0.8);
    int g2 = (int)(g1 * 0.8);
    int b2 = (int)(b1 * 0.8);
    color1 = MapRGBA(r1, g1, b1);
    color2 = MapRGBA(r2, g2, b2);
}

void MenuAbility()
{
    std::string menustring2[3] = { "更換", "卸下", "取消" };
    int x = CENTER_X - 384 + 270;
    int y = CENTER_Y - 240 + 5;
    Redraw();
    DrawMPic(2008, CENTER_X - 384 + 283, CENTER_Y - 240);
    TransBlackScreen();
    DrawTitleMenu(1);
    RecordFreshScreen();

    int itemx = x + 230;
    int itemy = y + 380;
    int d = 83;
    int max = 0;
    LoadTeamSimpleStatus(max);
    int menu = MenuEscTeammate;
    int premenu = -1;
    int select = 0;
    int preselect = -1;
    int mouseactive = 0;
    int maxselect = (MODVersion == 0) ? 3 : 2;

    while (SDL_PollEvent(&event) || true)
    {
        if (menu != premenu || select != preselect)
        {
            LoadFreshScreen();
            CleanTextScreen();
            for (int i = 0; i <= max; i++)
            {
                if (i == menu)
                {
                    DrawSimpleStatusByTeam(i, ui_x, ui_y + i * 80, 0, 0);
                }
                else
                {
                    DrawSimpleStatusByTeam(i, ui_x, ui_y + i * 80, 0, 50);
                }
            }
            ShowAbility(TeamList[menu], select, (menu == 0 && MODVersion != 13) ? 1 : 0);
            UpdateAllScreen();
            premenu = menu;
            preselect = select;
        }
        CheckBasicEvent();
        if ((event.type == SDL_EVENT_KEY_DOWN && event.key.key == SDLK_UP) || (event.type == SDL_EVENT_MOUSE_WHEEL && event.wheel.y > 0))
        {
            menu--;
            if (menu < 0)
            {
                menu = max;
            }
        }
        if ((event.type == SDL_EVENT_KEY_DOWN && event.key.key == SDLK_DOWN) || (event.type == SDL_EVENT_MOUSE_WHEEL && event.wheel.y < 0))
        {
            menu++;
            if (menu > max)
            {
                menu = 0;
            }
        }
        if (event.type == SDL_EVENT_KEY_DOWN && event.key.key == SDLK_LEFT)
        {
            select--;
            if (select < 0)
            {
                select = maxselect;
            }
        }
        if (event.type == SDL_EVENT_KEY_DOWN && event.key.key == SDLK_RIGHT)
        {
            select++;
            if (select > maxselect)
            {
                select = 0;
            }
        }
        if ((event.type == SDL_EVENT_KEY_UP && event.key.key == SDLK_ESCAPE) || (event.type == SDL_EVENT_MOUSE_BUTTON_UP && event.button.button == SDL_BUTTON_RIGHT))
        {
            MenuEscType = -1;
            break;
        }
        if ((event.type == SDL_EVENT_KEY_UP && (event.key.key == SDLK_RETURN || event.key.key == SDLK_SPACE)) || (event.type == SDL_EVENT_MOUSE_BUTTON_UP && event.button.button == SDL_BUTTON_LEFT && mouseactive == 1))
        {
            if (select >= 0)
            {
                if ((select == 0 && Rrole[TeamList[menu]].Medcine > 0) || (select == 1 && Rrole[TeamList[menu]].MedPoi > 0))
                {
                    TransBlackScreen();
                    int menu2 = SelectOneTeamMember(x + 50, y + 80 + select * 150,
                        "選擇目標隊友", 0, 0);    // 選擇目標隊友
                    if (menu2 >= 0)
                    {
                        if (select == 0)
                        {
                            EffectMedcine(TeamList[menu], TeamList[menu2]);
                        }
                        else
                        {
                            EffectMedPoison(TeamList[menu], TeamList[menu2]);
                        }
                        ShowSimpleStatus(TeamList[menu2], 0, 0, menu2);
                        ShowSimpleStatus(TeamList[menu], 0, 0, menu);
                    }
                }
                if (select == 2)
                {
                    switch (CommonMenu(itemx + d + 10, itemy, 47, 2, 2, menustring2, 3))
                    {
                    case 0:
                        MenuItemType = 4;
                        MenuEscType = 2;
                        MenuItem();
                        if (MenuEscType == -1)
                        {
                            MenuEscType = 1;
                        }
                        break;
                    case 1:
                        if (Rrole[TeamList[menu]].PracticeBook >= 0)
                        {
                            int rnum = TeamList[menu];
                            int inum = Rrole[rnum].PracticeBook;
                            Rrole[rnum].PracticeBook = -1;
                            Ritem[inum].User = -1;
                        }
                        break;
                    }
                    preselect = -1;
                }
                if (select == 3 && menu == 0 && Where == 0)
                {
                    MenuLeave();
                    LoadTeamSimpleStatus(max);
                }
            }
            preselect = -1;
        }
        if (event.type == SDL_EVENT_MOUSE_MOTION)
        {
            int xm, ym;
            if (MouseInRegion(ui_x, ui_y, 250, 480, xm, ym))
            {
                menu = (ym - ui_y) / 80;
            }
            if (menu > max)
            {
                menu = max;
            }
            mouseactive = 0;
            if (MouseInRegion(x + 50, y + 50, 100, 30))
            {
                select = 0;
                mouseactive = 1;
            }
            if (MouseInRegion(x + 200, y + 50, 100, 30))
            {
                select = 1;
                mouseactive = 1;
            }
            if (MouseInRegion(itemx, itemy, d, d))
            {
                select = 2;
                mouseactive = 1;
            }
            if (MouseInRegion(x + 350, y + 50, 100, 30))
            {
                select = 3;
                mouseactive = 1;
            }
        }
        MenuEscType = CheckTitleMenu();
        if (MenuEscType != 1)
        {
            break;
        }
        SDL_Delay(20);
        event.key.key = 0;
        event.button.button = 0;
    }
    MenuEscTeammate = menu;
    FreeFreshScreen();
}
void ShowAbility(int rnum, int select, int showLeave)
{
    std::string strs[4] = { "普通", "武學", "內功", "修煉物品" };    // 普通, 武學, 內功, 修煉物品
    std::string strs1[3] = { "醫療", "解毒", "離隊" };               // 醫療, 解毒, 離隊
    int x = CENTER_X - 384 + 250;
    int y = CENTER_Y - 240 + 5;
    int itemx = x + 230;
    int itemy = y + 380;
    uint32 color1, color2;

    DrawTextWithRect(strs[0], x + 70, y + 20, 10, 0, 0x202020, 255, 0);

    // 醫療
    if (Rrole[rnum].Medcine > 0)
    {
        color1 = 0;
        color2 = 0x202020;
        if (select == 0)
        {
            color1 = ColColor(0x64);
            color2 = ColColor(0x66);
        }
    }
    else
    {
        color1 = ColColor(0x68);
        color2 = ColColor(0x6F);
    }
    std::string buf;
    buf = std::format("{:4d}", Rrole[rnum].Medcine);
    std::string str = strs1[0] + buf;
    DrawTextWithRect(str, x + 70, y + 50, 0, color1, color2, 204, 0);

    // 解毒
    if (Rrole[rnum].MedPoi > 0)
    {
        color1 = 0;
        color2 = 0x202020;
        if (select == 1)
        {
            color1 = ColColor(0x64);
            color2 = ColColor(0x66);
        }
    }
    else
    {
        color1 = ColColor(0x68);
        color2 = ColColor(0x6F);
    }
    buf = std::format("{:4d}", Rrole[rnum].MedPoi);
    str = strs1[1] + buf;
    DrawTextWithRect(str, x + 220, y + 50, 0, color1, color2, 204, 0);

    // 離隊
    if (showLeave != 0)
    {
        color1 = 0;
        color2 = 0x202020;
        if (select == 3 && Where == 0)
        {
            color1 = ColColor(0x64);
            color2 = ColColor(0x66);
        }
        if (Where != 0)
        {
            color1 = ColColor(0x68);
            color2 = ColColor(0x6F);
        }
        DrawTextWithRect(strs1[2], x + 370, y + 50, 0, color1, color2, 204, 0);
    }

    // 武功
    DrawTextWithRect(strs[1], x + 70, y + 90, 0, 0, 0x202020, 255, 0);
    for (int i = 0; i <= 9; i++)
    {
        int magicnum = Rrole[rnum].Magic[i];
        int x1 = x + 70 + (i % 2) * 200;
        int y1 = y + 120 + 28 * (i / 2);
        DrawTextFrame(x1, y1, 14, 204);
        if (magicnum > 0)
        {
            DrawShadowText(std::string((char*)Rmagic[magicnum].Name), x1 + 19, y1 + 3, 0, 0x202020);
            buf = std::format("{:2d}", Rrole[rnum].MagLevel[i] / 100 + 1);
            DrawEngShadowText(buf, x1 + 139, y1 + 3, 0, 0x202020);
        }
    }

    // 内功
    DrawTextWithRect(strs[2], x + 70, y + 270, 10, 0, 0x202020, 255, 0);
    for (int i = 0; i <= 3; i++)
    {
        int magicnum = Rrole[rnum].NeiGong[i];
        int x1 = x + 70 + (i % 2) * 200;
        int y1 = y + 300 + 28 * (i / 2);
        DrawTextFrame(x1, y1, 14, 204);
        if (magicnum > 0)
        {
            DrawShadowText(std::string((char*)Rmagic[magicnum].Name), x1 + 19, y1 + 3, 0, 0x202020);
            buf = std::format("{:2d}", Rrole[rnum].NGLevel[i] / 100 + 1);
            DrawEngShadowText(buf, x1 + 139, y1 + 3, 0, 0x202020);
        }
    }

    DrawTextWithRect(strs[3], x + 70, y + 370, 0, 0, 0x202020, 255, 0);

    // 秘笈
    if (Rrole[rnum].PracticeBook >= 0)
    {
        int mlevel = 1;
        int magicnum = Ritem[Rrole[rnum].PracticeBook].Magic;
        mlevel = std::max(1, GetMagicLevel(rnum, magicnum));
        int needexp = std::min(30000, (int)((1 + (mlevel - 1) * 0.5) * Ritem[Rrole[rnum].PracticeBook].NeedExp * (1 + (7 - Rrole[rnum].Aptitude / 15) * 0.5)));
        DrawTextWithRect(std::string((char*)Ritem[Rrole[rnum].PracticeBook].Name), x + 70, y + 400, 0, 0, 0x202020, 204, 0);
        if (mlevel == 10)
        {
            buf = std::format("{}/=", (uint16_t)Rrole[rnum].ExpForBook);
        }
        else
        {
            buf = std::format("{}/{}", (uint16_t)Rrole[rnum].ExpForBook, needexp);
        }
        DrawTextWithRect(buf, x + 70, y + 428, 0, ColColor(0x64), ColColor(0x66), 204, 0);
        DrawIPic(Rrole[rnum].PracticeBook, itemx, itemy, 0, 255, 0, 0);
    }
    else
    {
        DrawTextFrame(x + 70, y + 400, 1, 204, 0);
    }
    if (select == 2)
    {
        DrawItemFrame(itemx, itemy, 1);
    }
}
void MenuLeave()
{
    TransBlackScreen();
    int menu = SelectOneTeamMember(CENTER_X - 384 + 270 + 50, CENTER_Y - 240 + 7 + 80,
        "要求誰離隊", 0, 0);    // 要求誰離隊
    if (menu >= 0)
    {
        for (int i = 0; i < 100; i++)
        {
            if (LeaveList[i] == TeamList[menu])
            {
                CallEvent(BEGIN_LEAVE_EVENT + i * 2);
                break;
            }
        }
    }
    Redraw();
}

void MenuSystem()
{
    // 标题区的位置, 标题每项的宽度
    int titlex1 = CENTER_X;
    int titley1 = 50;
    int titlew = 60;
    int max = 5;
    int maxteam;
    LoadTeamSimpleStatus(maxteam);

    Redraw();
    TransBlackScreen();
    DrawTitleMenu(3);
    RecordFreshScreen();

    std::string menuString[6] = { "讀檔", "存檔", "設置", "製作", "特殊", "離開" };

    int menu = 0, pmenu = -1;
    event.key.key = 0;
    event.button.button = 0;
    int intitle = 1;

    while (SDL_PollEvent(&event) || true)
    {
        if (menu != pmenu)
        {
            LoadFreshScreen();
            CleanTextScreen();
            if (Where != 2)
            {
                for (int i = 0; i <= maxteam; i++)
                {
                    DrawSimpleStatusByTeam(i, ui_x, ui_y + i * 80, 0, 0);
                }
            }
            DrawTextFrame(titlex1 - 20, titley1 - 3, max * 8, 255);
            for (int i = 0; i <= max; i++)
            {
                uint32 color1 = 0, color2 = 0x202020;
                if (intitle == 0)
                {
                    color1 = ColColor(0x7A);
                    color2 = ColColor(0x7C);
                }
                if (i == menu)
                {
                    color1 = ColColor(0x64);
                    color2 = ColColor(0x66);
                }
                DrawShadowText(menuString[i], titlex1 + titlew * i + 20, titley1, color1, color2);
            }
            UpdateAllScreen();
            pmenu = menu;
        }
        CheckBasicEvent();
        if (intitle == 0)
        {
            switch (menu)
            {
            case 0:
                if (MenuLoad() >= 0)
                {
                    FreeFreshScreen();
                    DrawTitleMenu();
                    TransBlackScreen();
                    DrawTitleMenu(3);
                    LoadTeamSimpleStatus(maxteam);
                    RecordFreshScreen();
                }
                break;
            case 1: MenuSave(); break;
            case 2: MenuSet(); break;
            case 3: Maker(); break;
            case 4: SpecialFunction(); break;
            case 5: MenuQuit(); break;
            }
            intitle = 1;
            pmenu = -1;
            if (Where >= 3)
            {
                MenuEscType = -1;
                break;
            }
        }
        switch (event.type)
        {
        case SDL_EVENT_KEY_DOWN:
            if (event.key.key == SDLK_RIGHT)
            {
                if (intitle == 1)
                {
                    menu++;
                    if (menu > max)
                    {
                        menu = 0;
                    }
                }
            }
            if (event.key.key == SDLK_LEFT)
            {
                if (intitle == 1)
                {
                    menu--;
                    if (menu < 0)
                    {
                        menu = max;
                    }
                }
            }
            break;
        case SDL_EVENT_KEY_UP:
            if (event.key.key == SDLK_ESCAPE)
            {
                MenuEscType = -1;
                goto menusystem_exit;
            }
            if (event.key.key == SDLK_RETURN || event.key.key == SDLK_SPACE || (event.key.key == SDLK_DOWN && intitle == 1))
            {
                intitle = 0;
            }
            break;
        case SDL_EVENT_MOUSE_BUTTON_UP:
        {
            if (event.button.button == SDL_BUTTON_RIGHT)
            {
                MenuEscType = -1;
                goto menusystem_exit;
            }
            if (event.button.button == SDL_BUTTON_LEFT)
            {
                int xm, ym;
                if (intitle == 1 && MouseInRegion(titlex1, titley1, (max + 1) * titlew, 20, xm, ym))
                {
                    menu = (xm - titlex1 - 10) / titlew;
                    intitle = 0;
                }
            }
            break;
        }
        case SDL_EVENT_MOUSE_MOTION:
        {
            int xm, ym;
            if (MouseInRegion(titlex1, titley1, (max + 1) * titlew, 20, xm, ym))
            {
                intitle = 1;
                menu = (xm - titlex1 - 10) / titlew;
            }
            break;
        }
        }
        MenuEscType = CheckTitleMenu();
        if (MenuEscType != 3)
        {
            break;
        }
        event.key.key = 0;
        event.button.button = 0;
        SDL_Delay(20);
    }
menusystem_exit:
    FreeFreshScreen();
}

void MenuSet()
{
    int menu = 0, pmenu = -1, x, y, w, h, h0, maxmenu;
    int valuechanged = 0, pressed = 0, leftright = 0;
    int xm, ym;
    uint32 color1, color2, mixcolorl, mixcolorr;
    int mixalphal, mixalphar, arrowy, arrowlx, arrowrx;

    maxmenu = 8;
    std::string str[8] = {
        "音樂音量",          // 音樂音量
        "音效音量",          // 音效音量
        "大地圖走路延遲",    // 大地圖走路延遲
        "內場景走路延遲",    // 內場景走路延遲
        "戰鬥動畫延遲",      // 戰鬥動畫延遲
        "戰鬥文字顯示",      // 戰鬥文字顯示
        "顯示模式",          // 顯示模式
        "文字設置"           // 文字設置
    };
    std::string str2[8];
    std::string menuString[2] = {
        "取消",    // 取消
        "確定"     // 確定
    };
    int Value[9];
    Value[0] = VOLUME;
    Value[1] = VOLUMEWAV;
    Value[2] = WALK_SPEED;
    Value[3] = WALK_SPEED2;
    Value[4] = BATTLE_SPEED;
    Value[5] = EFFECT_STRING;
    Value[6] = FULLSCREEN;
    Value[7] = SIMPLE;
    Value[maxmenu] = 0;

    x = CENTER_X + 120;
    y = 90;
    w = 300;
    h0 = 28;
    h = (maxmenu + 1) * h0 + 5;
    RecordFreshScreen(x, y, w + 1, h + 1);
    arrowy = 4;
    arrowlx = x + 170;
    arrowrx = x + 235;

    while (SDL_PollEvent(&event) || true)
    {
        if ((menu != pmenu) || (valuechanged == 1) || (leftright != 0))
        {
            LoadFreshScreen(x, y);
            CleanTextScreenRect(x, y, w, h);
            for (int i = 0; i <= maxmenu - 1; i++)
            {
                if (i == menu)
                {
                    color1 = ColColor(0x64);
                    color2 = ColColor(0x66);
                    DrawTextFrame(x + 10 - 29, y + 5 + i * h0 - 3, 26);
                }
                else
                {
                    color1 = 0;
                    color2 = 0x202020;
                    DrawTextFrame(x + 10 - 29, y + 5 + i * h0 - 3, 26, 230);
                }
                if (i < 5)
                {
                    auto buf = std::format("{:5d}", Value[i]);
                    str2[i] = buf;
                    mixalphal = 0;
                    mixalphar = 0;
                    mixcolorl = 0xFFFFFFFF;
                    mixcolorr = 0xFFFFFFFF;
                    if (i == menu)
                    {
                        if (leftright < 0)
                        {
                            mixalphal = 25;
                        }
                        if (leftright > 0)
                        {
                            mixalphar = 25;
                        }
                    }
                    if (Value[i] <= 0)
                    {
                        mixcolorl = 0;
                        mixalphal = 50;
                    }
                    if (Value[i] >= 100)
                    {
                        mixcolorr = 0;
                        mixalphar = 50;
                    }
                    DrawMPic(2004, arrowlx, y + 5 + i * h0 + arrowy, -1, 0, 255, mixcolorl, mixalphal);
                    DrawMPic(2005, arrowrx, y + 5 + i * h0 + arrowy, -1, 0, 255, mixcolorr, mixalphar);
                }
                else
                {
                    if (i == 5)
                    {
                        str2[i] = (Value[i] == 0) ? "關閉" : "打開";    // 關閉 : 打開
                    }
                    if (i == 6)
                    {
                        str2[i] = (Value[i] == 0) ? "窗口" : "全屏";    // 窗口 : 全屏
                    }
                    if (i == 7)
                    {
                        str2[i] = (Value[i] == 0) ? "繁體" : "簡體";    // 繁體 : 簡體
                    }
                }
                DrawShadowText(str[i], x + 10, y + 5 + i * h0, color1, color2);
                DrawShadowText(str2[i], x + 170, y + 5 + i * h0, color1, color2);
            }
            for (int i = 0; i <= 1; i++)
            {
                if ((i == Value[maxmenu]) && (menu == maxmenu))
                {
                    color1 = ColColor(0x64);
                    color2 = ColColor(0x66);
                }
                else
                {
                    color1 = 0;
                    color2 = 0x202020;
                }
                DrawTextFrame(x + 140 + 80 * i - 19, y + 5 + maxmenu * h0 - 3, 4);
                DrawShadowText(menuString[i], x + 140 + 80 * i, y + 5 + maxmenu * h0, color1, color2);
            }
            UpdateAllScreen();
            pmenu = menu;
            valuechanged = 0;
        }
        CheckBasicEvent();

        if (event.type == SDL_EVENT_KEY_DOWN)
        {
            if (event.key.key == SDLK_UP)
            {
                menu--;
                if (menu < 0)
                {
                    menu = maxmenu;
                }
            }
            if (event.key.key == SDLK_DOWN)
            {
                menu++;
                if (menu > maxmenu)
                {
                    menu = 0;
                }
            }
            if (event.key.key == SDLK_LEFT)
            {
                if (menu < 5)
                {
                    Value[menu] = std::max(Value[menu] - 1, 0);
                    leftright--;
                }
                else
                {
                    Value[menu] = 1 - Value[menu];
                }
                valuechanged = 1;
            }
            if (event.key.key == SDLK_RIGHT)
            {
                if (menu < 5)
                {
                    Value[menu] = std::min(Value[menu] + 1, 100);
                    leftright++;
                }
                else
                {
                    Value[menu] = 1 - Value[menu];
                }
                valuechanged = 1;
            }
        }
        if (event.type == SDL_EVENT_KEY_UP)
        {
            if (event.key.key == SDLK_ESCAPE)
            {
                break;
            }
            if (event.key.key == SDLK_RETURN || event.key.key == SDLK_SPACE)
            {
                if (menu == maxmenu)
                {
                    pressed = Value[maxmenu];
                    break;
                }
            }
            if (event.key.key == SDLK_LEFT || event.key.key == SDLK_RIGHT)
            {
                leftright = 0;
                valuechanged = 1;
            }
        }
        if (event.type == SDL_EVENT_MOUSE_BUTTON_DOWN)
        {
            if (event.button.button == SDL_BUTTON_LEFT)
            {
                if (MouseInRegion(arrowlx, y + 5, 20, h0 * 5))
                {
                    Value[menu] = std::max(Value[menu] - 1, 0);
                    leftright--;
                }
                else if (MouseInRegion(arrowrx, y + 5, 20, h0 * 5))
                {
                    Value[menu] = std::min(Value[menu] + 1, 100);
                    leftright++;
                }
                else
                {
                    leftright = 0;
                }
                if (leftright != 0)
                {
                    valuechanged = 1;
                }
            }
        }
        if (event.type == SDL_EVENT_MOUSE_BUTTON_UP)
        {
            if (event.button.button == SDL_BUTTON_LEFT)
            {
                if (MouseInRegion(x, y + 5, w, h - 5))
                {
                    if (MouseInRegion(x + 160 + 13, y + 5 + maxmenu * h0, 50, h0) || MouseInRegion(x + 210 + 13, y + 5 + maxmenu * h0, 50, h0))
                    {
                        pressed = Value[maxmenu];
                        break;
                    }
                    if (MouseInRegion(x + 160 + 13, y + 5 + 5 * h0, 50, h0))
                    {
                        Value[5] = 1 - Value[5];
                    }
                    if (MouseInRegion(x + 160 + 13, y + 5 + 6 * h0, 50, h0))
                    {
                        Value[6] = 1 - Value[6];
                    }
                    if (MouseInRegion(x + 160 + 13, y + 5 + 7 * h0, 50, h0))
                    {
                        Value[7] = 1 - Value[7];
                    }
                    leftright = 0;
                    valuechanged = 1;
                }
            }
            if (event.button.button == SDL_BUTTON_RIGHT)
            {
                break;
            }
        }
        if (event.type == SDL_EVENT_MOUSE_MOTION)
        {
            if (MouseInRegion(x, y + 5, w, h - 5, xm, ym))
            {
                menu = std::min((ym - y - 5) / h0, maxmenu);
                if (menu == maxmenu)
                {
                    if (MouseInRegion(x + 160 + 13, y + 5 + maxmenu * h0, 50, h0))
                    {
                        Value[maxmenu] = 0;
                        valuechanged = 1;
                    }
                    if (MouseInRegion(x + 210 + 13, y + 5 + maxmenu * h0, 50, h0))
                    {
                        Value[maxmenu] = 1;
                        valuechanged = 1;
                    }
                }
            }
        }

        if (abs(leftright) <= 1)
        {
            event.key.key = 0;
        }
        if (leftright == 0)
        {
            event.button.button = 0;
        }
        SDL_Delay(20);
    }
    CleanKeyValue();

    if (pressed == 1)
    {
        VOLUME = Value[0];
        StopMP3(0);
        PlayMP3(NowMusic, -1, 0);
        VOLUMEWAV = Value[1];
        WALK_SPEED = Value[2];
        WALK_SPEED2 = Value[3];
        BATTLE_SPEED = Value[4];
        EFFECT_STRING = Value[5];
        if (FULLSCREEN != Value[6])
        {
            FULLSCREEN = Value[6];
            SDL_SetRenderTarget(render, nullptr);
            SDL_RenderClear(render);
            if (FULLSCREEN == 0)
            {
                SDL_SetWindowFullscreen(window, false);
            }
            else
            {
                SDL_SetWindowFullscreen(window, true);
            }
            SDL_SetRenderTarget(render, screenTex);
            MenuEscType = -1;
        }
        SIMPLE = Value[7];

        INIReaderNormal ini;
        ini.loadFile(iniFilename);
        ini.setKey("music", "VOLUME", std::to_string(VOLUME));
        ini.setKey("music", "VOLUMEWAV", std::to_string(VOLUMEWAV));
        ini.setKey("system", "WALK_SPEED", std::to_string(WALK_SPEED));
        ini.setKey("system", "WALK_SPEED2", std::to_string(WALK_SPEED2));
        ini.setKey("system", "BATTLE_SPEED", std::to_string(BATTLE_SPEED));
        ini.setKey("system", "EFFECT_STRING", std::to_string(EFFECT_STRING));
        ini.setKey("system", "FULLSCREEN", std::to_string(FULLSCREEN));
        ini.setKey("system", "SIMPLE", std::to_string(SIMPLE));
        ini.saveFile(iniFilename);
    }
    FreeFreshScreen();
}

static std::string GetFileDateTime(const std::string& filepath)
{
    return filefunc::getFileTime(filepath);
}

int MenuLoad()
{
    int x = CENTER_X, y = 90;
    std::string menuString[11] = {
        "進度一", "進度二", "進度三",
        "進度四", "進度五", "進度六",
        "進度七", "進度八", "進度九",
        "進度十", "自動檔"
    };
    std::string menuEngString[11];
    for (int i = 0; i < 11; i++)
    {
        std::string filename;
        if (ZIP_SAVE == 0)
        {
            filename = AppPath + "save/r" + std::to_string(i + 1) + ".grp";
        }
        else
        {
            filename = AppPath + "save/" + std::to_string(i + 1) + ".zip";
        }
        if (filefunc::fileExist(filename))
        {
            menuEngString[i] = GetFileDateTime(filename);
        }
        else
        {
            menuEngString[i] = "-------------------";
        }
    }
    int menu = CommonMenu(x, y, 280, 10, 0, menuString, menuEngString, 11);
    if (menu >= 0)
    {
        LastShowScene = -1;
        if (LoadR(menu + 1))
        {
            if (Where == 1)
            {
                JumpScene(CurScene, Sy, Sx);
            }
            MenuEscType = -2;
        }
        else
        {
            menu = -1;
            std::string str = "讀檔失敗！索引丟失或文件不存在！";
            DrawTextWithRect(str, x - 40, y + 310, 322, MapRGBA(240, 20, 20), MapRGBA(212, 20, 20));
            WaitAnyKey();
        }
    }
    return menu;
}

int MenuLoadAtBeginning(int mode)
{
    int x = CENTER_X - 175, y = CENTER_Y - 110;
    std::string menuString[11] = {
        "進度一", "進度二", "進度三",
        "進度四", "進度五", "進度六",
        "進度七", "進度八", "進度九",
        "進度十", "自動檔"
    };
    std::string menuEngString[11];
    for (int i = 0; i < 11; i++)
    {
        std::string filename;
        if (ZIP_SAVE == 0)
        {
            filename = AppPath + "save/r" + std::to_string(i + 1) + ".grp";
        }
        else
        {
            filename = AppPath + "save/" + std::to_string(i + 1) + ".zip";
        }
        if (filefunc::fileExist(filename))
        {
            menuEngString[i] = GetFileDateTime(filename);
        }
        else
        {
            menuEngString[i] = "-------------------";
        }
    }
    UpdateAllScreen();
    int menu = CommonMenu(x, y, 300, 10, 0, menuString, menuEngString, 11);
    if (menu >= 0)
    {
        if (mode == 0)
        {
            if (LoadR(menu + 1))
            {
                instruct_14();
            }
            else
            {
                menu = -2;
                std::string str = "讀檔失敗！";
                DrawTextWithRect(str, x - 40, y + 310, 322, MapRGBA(240, 20, 20), MapRGBA(212, 20, 20));
                WaitAnyKey();
            }
        }
        else if (mode == 1)
        {
            if (!LoadForSecondRound(menu + 1))
            {
                menu = -2;
                std::string str = "讀檔失敗！";
                DrawTextWithRect(str, x - 40, y + 310, 322, MapRGBA(240, 20, 20), MapRGBA(212, 20, 20));
                WaitAnyKey();
            }
        }
    }
    return menu;
}

bool LoadForSecondRound(int num)
{
    int mode = 0;
    if (LoadR(num))
    {
        int s = 0;
        for (int i = 0; i <= 107; i++)
        {
            if (GetStarState(i) > 0)
            {
                s++;
            }
        }
        mode = s / 36;
    }
    int round = GetItemAmount(COMPASS_ID);
    if (round >= 2)
    {
        mode = 3;
    }
    bool result = (mode > 0);

    if (result)
    {
        std::vector<TItemList> tempRItemList(MAX_ITEM_AMOUNT);
        TRole tempRrole[1002];
        memcpy(tempRrole, Rrole, sizeof(Rrole));
        memcpy(tempRItemList.data(), RItemList.data(), sizeof(TItemList) * MAX_ITEM_AMOUNT);

        LoadR(0);

        if (mode >= 1)
        {
            if (Rrole[0].HeadNum == 0)
            {
                Rrole[0] = tempRrole[0];
                Rrole[0].Level = 1;
                Rrole[0].Attack = 10;
                Rrole[0].Defence = 10;
                Rrole[0].CurrentHP = 0;
                Rrole[0].CurrentMP = 0;
                Rrole[0].MaxHP = Rrole[0].MaxHP / 40;
                Rrole[0].MaxMP = Rrole[0].MaxMP / 40;
                Rrole[0].Exp = 0;
                Rrole[0].MagLevel[0] = 800;
                Rrole[0].Equip[0] = -1;
                Rrole[0].Equip[1] = -1;
                Rrole[0].PracticeBook = -1;
                for (int i = 1; i <= 9; i++)
                {
                    Rrole[0].Magic[i] = 0;
                    Rrole[0].MagLevel[i] = 0;
                }
                for (int i = 0; i <= 3; i++)
                {
                    Rrole[0].NeiGong[i] = 0;
                    Rrole[0].NGLevel[i] = 0;
                }
            }
            for (int i = 0; i <= 107; i++)
            {
                int rnum = StarToRole(i);
                if (Rrole[rnum].Magic[0] > 0)
                {
                    Rrole[rnum].MagLevel[0] = tempRrole[rnum].MagLevel[0];
                }
            }
        }
        if (mode >= 2)
        {
            for (int i = 0; i < MAX_ITEM_AMOUNT; i++)
            {
                if (tempRItemList[i].Number < 0)
                {
                    break;
                }
                int itemtype = Ritem[tempRItemList[i].Number].ItemType;
                if (tempRItemList[i].Number == MONEY_ID || itemtype == 1 || itemtype == 3 || itemtype == 4)
                {
                    instruct_32(tempRItemList[i].Number, tempRItemList[i].Amount);
                }
            }
            if (Rrole[0].AmiFrameNum[0] < 0)
            {
                Rrole[0].AmiFrameNum[0] = 8;
            }
        }
        if (mode >= 3)
        {
            instruct_32(COMPASS_ID, round);
            for (int i = 0; i < MAX_ITEM_AMOUNT; i++)
            {
                if (tempRItemList[i].Number < 0)
                {
                    break;
                }
                int itemtype = Ritem[tempRItemList[i].Number].ItemType;
                if (itemtype == 2)
                {
                    instruct_32(tempRItemList[i].Number, tempRItemList[i].Amount);
                }
            }
        }
    }
    else
    {
        LoadR(0);
    }
    instruct_14();
    return result;
}
void MenuSave()
{
    std::string menuString[10] = {
        "進度一", "進度二", "進度三",
        "進度四", "進度五", "進度六",
        "進度七", "進度八", "進度九",
        "進度十"
    };
    std::string menuEngString[10];
    for (int i = 0; i < 10; i++)
    {
        std::string filename;
        if (ZIP_SAVE == 0)
        {
            filename = AppPath + "save/r" + std::to_string(i + 1) + ".grp";
        }
        else
        {
            filename = AppPath + "save/" + std::to_string(i + 1) + ".zip";
        }
        if (filefunc::fileExist(filename))
        {
            menuEngString[i] = GetFileDateTime(filename);
        }
        else
        {
            menuEngString[i] = "-------------------";
        }
    }
    if ((Where == 1 && MODVersion == 13 && CurScene == 71) || ScreenBlendMode > 0)
    {
        std::string str = "此時不可存檔！";
        DrawTextWithRect(str, CENTER_X + 60, 90, 152, ColColor(5), ColColor(7));
        WaitAnyKey();
    }
    else
    {
        int menu = CommonMenu(CENTER_X + 60, 90, 280, 9, 0, menuString, menuEngString, 10);
        if (menu >= 0)
        {
            if (!SaveR(menu + 1))
            {
                std::string str = "存檔失敗！";
                DrawTextWithRect(str, CENTER_X - 384 + 420 - 40, CENTER_Y - 240 + 90 + 280, 322,
                    MapRGBA(240, 20, 20), MapRGBA(212, 20, 20));
                WaitAnyKey();
            }
        }
    }
}

void MenuQuit()
{
    std::string menuString[3] = { "取消", "確定", "Test" };
    int n = 1;
    int menu = CommonMenu(CENTER_X + 60 * 5, 90, 47, n, 0, menuString, n + 1);
    if (menu == 1)
    {
        Where = 3;
        MenuEscType = -2;
    }
    if (menu == 2)
    {
        std::string str = "輸入腳本文件名";
        DrawTextWithRect(str, CENTER_X - 80, CENTER_Y - 240 + 130, 148, 0, ColColor(0x23));
        int scriptNum = EnterNumber(0, 100, CENTER_X - 80, CENTER_Y - 240 + 200, 1);
        str = "輸入功能編號";
        DrawTextWithRect(str, CENTER_X + 120, CENTER_Y - 240 + 130, 128, 0, ColColor(0x23));
        int funcNum = EnterNumber(0, 32767, CENTER_X + 120, CENTER_Y - 240 + 200, 0);
        std::string scriptFile = AppPath + "script/" + std::to_string(scriptNum) + ".lua";
        std::string funcName = "f" + std::to_string(funcNum);
        ExecScript(scriptFile, funcName);
    }
}

//----------------------------------------------------------------------
// 效果函数
//----------------------------------------------------------------------
void EffectMedcine(int role1, int role2)
{
    int addlife = Rrole[role1].Medcine * 2 - Rrole[role2].Hurt + rand() % 10 - 5;
    if (addlife < 0)
    {
        addlife = 0;
    }
    if (Rrole[role1].PhyPower < 50)
    {
        addlife = 0;
    }
    if (addlife > Rrole[role2].MaxHP - Rrole[role2].CurrentHP)
    {
        addlife = Rrole[role2].MaxHP - Rrole[role2].CurrentHP;
    }
    Rrole[role2].CurrentHP += addlife;
    if (addlife > 0)
    {
        Rrole[role1].PhyPower -= 5;
    }
    if (Where != 2)
    {
        TransBlackScreen();
        DrawRectangle(CENTER_X - 150 + 30, 170, 155, 52, 0, ColColor(255), 77);
        DrawShadowText(std::string(Rrole[role2].Name), CENTER_X - 150 + 35, 172, ColColor(0x23), ColColor(0x21));
        std::string word = "增加生命";
        DrawShadowText(word, CENTER_X - 150 + 35, 197, ColColor(0x7), ColColor(0x5));
        auto buf = std::format("{:4d}", addlife);
        DrawEngShadowText(buf, CENTER_X - 150 + 135, 197, ColColor(0x66), ColColor(0x64));
        ShowSimpleStatus(role2, CENTER_X - 150, 70);
        UpdateAllScreen();
        WaitAnyKey();
        Redraw();
    }
}

void EffectMedPoison(int role1, int role2)
{
    int minuspoi = Rrole[role1].MedPoi;
    if (minuspoi > Rrole[role2].Poison)
    {
        minuspoi = Rrole[role2].Poison;
    }
    if (Rrole[role1].PhyPower < 50)
    {
        minuspoi = 0;
    }
    Rrole[role2].Poison -= minuspoi;
    if (minuspoi > 0)
    {
        Rrole[role1].PhyPower -= 3;
    }
    if (Where != 2)
    {
        TransBlackScreen();
        DrawRectangle(CENTER_X - 150 + 30, 170, 155, 52, 0, ColColor(255), 77);
        std::string word = "減少中毒";
        DrawShadowText(word, CENTER_X - 150 + 35, 197, ColColor(0x7), ColColor(0x5));
        DrawShadowText(std::string(Rrole[role2].Name), CENTER_X - 150 + 35, 172, ColColor(0x23), ColColor(0x21));
        auto buf = std::format("{:4d}", minuspoi);
        DrawEngShadowText(buf, CENTER_X - 150 + 135, 197, ColColor(0x66), ColColor(0x64));
        ShowSimpleStatus(role2, CENTER_X - 150, 70);
        UpdateAllScreen();
        WaitAnyKey();
        Redraw();
    }
}

void EatOneItem(int rnum, int inum)
{
    const char* wordList[25] = {
        "增加生命", "增加生命最大值", "增加中毒程度", "增加體力",
        "內力門路陰陽合一", "增加內力", "增加內力最大值", "增加攻擊力",
        "增加輕功", "增加防禦力", "增加醫療能力", "增加用毒能力",
        "增加解毒能力", "增加抗毒能力", "增加拳掌能力", "增加御劍能力",
        "增加耍刀能力", "增加特殊兵器", "增加暗器技巧", "增加武學常識",
        "增加品德指數", "增加移動力", "增加攻擊帶毒", "受傷程度", "修習武學等級"
    };
    int rolelist[25] = {
        17, 18, 20, 21, 40, 41, 42, 43, 44, 45, 46, 47, 48, 49,
        50, 51, 52, 53, 54, 55, 56, 58, 57, 19, 0
    };
    int addvalue[25] = {};
    for (int i = 0; i < 23; i++)
    {
        addvalue[i] = Ritem[inum].Data[45 + i];
        if (Ritem[inum].ItemType == 2)
        {
            if (i == 7 || i == 9)
            {
                if (rand() % 200 < 2 * Rrole[rnum].Aptitude)
                {
                    addvalue[i]++;
                }
            }
        }
    }
    // 减少受伤
    addvalue[23] = -(addvalue[0] / (LIFE_HURT / 2));
    if (-addvalue[23] > Rrole[rnum].Data[19])
    {
        addvalue[23] = -Rrole[rnum].Data[19];
    }
    // 增加生命/内力上限处理
    if (addvalue[1] + Rrole[rnum].Data[18] > MAX_HP)
    {
        addvalue[1] = MAX_HP - Rrole[rnum].Data[18];
    }
    if (addvalue[6] + Rrole[rnum].Data[42] > MAX_MP)
    {
        addvalue[6] = MAX_MP - Rrole[rnum].Data[42];
    }
    if (addvalue[1] + Rrole[rnum].Data[18] < 0)
    {
        addvalue[1] = -Rrole[rnum].Data[18];
    }
    if (addvalue[6] + Rrole[rnum].Data[42] < 0)
    {
        addvalue[6] = -Rrole[rnum].Data[42];
    }

    for (int j = 7; j <= 22; j++)
    {
        if (addvalue[j] != 0)
        {
            if (addvalue[j] + Rrole[rnum].Data[rolelist[j]] > MaxProList[rolelist[j]])
            {
                addvalue[j] = MaxProList[rolelist[j]] - Rrole[rnum].Data[rolelist[j]];
            }
            if (addvalue[j] + Rrole[rnum].Data[rolelist[j]] < 0)
            {
                addvalue[j] = -Rrole[rnum].Data[rolelist[j]];
            }
            if (j >= 14 && j <= 18)
            {
                if (rand() % 200 < 200 - 2 * Rrole[rnum].Aptitude)
                {
                    addvalue[j]++;
                }
            }
        }
    }
    if (addvalue[0] + Rrole[rnum].Data[17] > addvalue[1] + Rrole[rnum].Data[18])
    {
        addvalue[0] = addvalue[1] + Rrole[rnum].Data[18] - Rrole[rnum].Data[17];
    }
    if (addvalue[2] + Rrole[rnum].Data[20] < 0)
    {
        addvalue[2] = -Rrole[rnum].Data[20];
    }
    if (addvalue[3] + Rrole[rnum].Data[21] > MAX_PHYSICAL_POWER)
    {
        addvalue[3] = MAX_PHYSICAL_POWER - Rrole[rnum].Data[21];
    }
    if (addvalue[5] + Rrole[rnum].Data[41] > addvalue[6] + Rrole[rnum].Data[42])
    {
        addvalue[5] = addvalue[6] + Rrole[rnum].Data[42] - Rrole[rnum].Data[41];
    }

    // 所修习武学的等级
    if (Ritem[inum].ItemType == 2 && Ritem[inum].Magic > 0)
    {
        addvalue[24] = GetMagicLevel(rnum, Ritem[inum].Magic) + 1;
        if (addvalue[24] > 10)
        {
            addvalue[24] = 10;
        }
    }
    else
    {
        addvalue[24] = 0;
    }

    // 统计项目数
    int p = 0;
    for (int i = 0; i < 25; i++)
    {
        if (i != 4 && addvalue[i] != 0)
        {
            p++;
        }
    }
    if (addvalue[4] == 2 && Rrole[rnum].Data[40] != 2)
    {
        p++;
    }

    int xp = CENTER_X - 150;
    int yp = CENTER_Y - 240 + 70;
    DrawTextFrame(14 + xp, 99 + yp, 4 + DrawLength(std::string(Ritem[inum].Name)));
    std::string str = (Ritem[inum].ItemType == 2) ? "練成" : "服用";
    DrawShadowText(str, 33 + xp, 102 + yp, 0, ColColor(0x23));
    DrawShadowText(std::string(Ritem[inum].Name), 73 + xp, 102 + yp, ColColor(0x64), ColColor(0x66));

    int l;
    if (p < 11)
    {
        l = p;
    }
    else
    {
        l = p / 2 + 1;
        xp -= 90;
    }
    if (p == 0)
    {
        str = "無明顯效果";
        DrawTextWithRect(str, 14 + xp, 132 + yp, 10, ColColor(0x64), ColColor(0x66));
    }
    p = 0;

    for (int i = 0; i < 25; i++)
    {
        int x = 0, y = 0;
        if (p >= l)
        {
            x = 200;
            y = -l * 28;
        }
        if (i != 4 && addvalue[i] != 0)
        {
            if (i != 24)
            {
                Rrole[rnum].Data[rolelist[i]] += addvalue[i];
            }
            DrawTextFrame(14 + xp, 127 + yp + y + p * 28, 18, 230, 0, 25);
            DrawShadowText(std::string(wordList[i]), 33 + xp + x, 130 + yp + y + p * 28, 0, 0x202020);
            auto buf = std::format("{:5d}", addvalue[i]);
            DrawEngShadowText(buf, 163 + xp + x, 130 + yp + y + p * 28, ColColor(0x64), ColColor(0x66));
            p++;
        }
        if (i == 4 && addvalue[i] == 2)
        {
            if (Rrole[rnum].Data[rolelist[i]] != 2)
            {
                Rrole[rnum].Data[rolelist[i]] = 2;
                DrawTextFrame(14 + xp, 127 + yp + y + p * 28, 18, 230, 0, 25);
                DrawShadowText(std::string(wordList[i]), 33 + xp + x, 130 + yp + y + p * 28, 0, 0x202020);
                p++;
            }
        }
    }
    ShowSimpleStatus(rnum, xp, yp);
    UpdateAllScreen();
}

//----------------------------------------------------------------------
// CallEvent - 调用事件
//----------------------------------------------------------------------
void CallEvent(int num)
{
    if (num == 0)
    {
        return;
    }
    NeedRefreshScene = 0;
    SkipTalk = 0;

    if (KDEF_SCRIPT >= 1)
    {
        if (KDEF_SCRIPT == 1)
        {
            std::string filename = AppPath + EventScriptPath + std::to_string(num) + EventScriptExt;
            if (filefunc::fileExist(filename))
            {
                kyslog("Enter script %d", num);
                ExecScript(filename);
                goto done;
            }
        }
        else
        {
            kyslog("Enter script %d", num);
            std::string script = LoadStringFromIMZMEM(AppPath + "script/event/", pEvent, num);
            ExecScriptString(script);
            goto done;
        }
    }

    // 使用KDEF二进制指令
    if (KDEF.Amount > 0 && num > 0 && num < (int)KDEF.IDX.size())
    {
        int offset = KDEF.IDX[num];
        int len = KDEF.IDX[num + 1] - offset;
        if (len <= 0)
        {
            goto done;
        }
        std::vector<int16_t> e(len / 2 + 1, 0);
        memcpy(e.data(), &KDEF.GRP[offset], len);
        kyslog("Event %d", num);
        int i = 0;
        int elen = (int)e.size();
        while (true)
        {
            SDL_PollEvent(&event);
            CheckBasicEvent();
            if (i >= elen - 1)
            {
                break;
            }
            if (e[i] < 0)
            {
                break;
            }
            switch (e[i])
            {
            case 0: i += 1; break;
            case 1:
                instruct_1(e[i + 1], e[i + 2], e[i + 3]);
                i += 4;
                break;
            case 2:
                instruct_2(e[i + 1], e[i + 2]);
                i += 3;
                break;
            case 3:
                instruct_3({ e[i + 1], e[i + 2], e[i + 3], e[i + 4], e[i + 5], e[i + 6], e[i + 7], e[i + 8], e[i + 9], e[i + 10], e[i + 11], e[i + 12], e[i + 13] });
                i += 14;
                break;
            case 4:
                i += instruct_4(e[i + 1], e[i + 2], e[i + 3]);
                i += 4;
                break;
            case 5:
                i += instruct_5(e[i + 1], e[i + 2]);
                i += 3;
                break;
            case 6:
                i += instruct_6(e[i + 1], e[i + 2], e[i + 3], e[i + 4]);
                i += 5;
                break;
            case 7: i += 1; goto done;
            case 8:
                instruct_8(e[i + 1]);
                i += 2;
                break;
            case 9:
                i += instruct_9(e[i + 1], e[i + 2]);
                i += 3;
                break;
            case 10:
                instruct_10(e[i + 1]);
                i += 2;
                break;
            case 11:
                i += instruct_11(e[i + 1], e[i + 2]);
                i += 3;
                break;
            case 12:
                instruct_12();
                i += 1;
                break;
            case 13:
                instruct_13();
                i += 1;
                break;
            case 14:
                instruct_14();
                i += 1;
                break;
            case 15:
                instruct_15();
                i += 1;
                goto done;
            case 16:
                i += instruct_16(e[i + 1], e[i + 2], e[i + 3]);
                i += 4;
                break;
            case 17:
                instruct_17({ e[i + 1], e[i + 2], e[i + 3], e[i + 4], e[i + 5] });
                i += 6;
                break;
            case 18:
                i += instruct_18(e[i + 1], e[i + 2], e[i + 3]);
                i += 4;
                break;
            case 19:
                instruct_19(e[i + 1], e[i + 2]);
                i += 3;
                break;
            case 20:
                i += instruct_20(e[i + 1], e[i + 2]);
                i += 3;
                break;
            case 21:
                instruct_21(e[i + 1]);
                i += 2;
                break;
            case 22:
                instruct_22();
                i += 1;
                break;
            case 23:
                instruct_23(e[i + 1], e[i + 2]);
                i += 3;
                break;
            case 24:
                instruct_24();
                i += 1;
                break;
            case 25:
                instruct_25(e[i + 1], e[i + 2], e[i + 3], e[i + 4]);
                i += 5;
                break;
            case 26:
                instruct_26(e[i + 1], e[i + 2], e[i + 3], e[i + 4], e[i + 5]);
                i += 6;
                break;
            case 27:
                instruct_27(e[i + 1], e[i + 2], e[i + 3]);
                i += 4;
                break;
            case 28:
                i += instruct_28(e[i + 1], e[i + 2], e[i + 3], e[i + 4], e[i + 5]);
                i += 6;
                break;
            case 29:
                i += instruct_29(e[i + 1], e[i + 2], e[i + 3], e[i + 4], e[i + 5]);
                i += 6;
                break;
            case 30:
                instruct_30(e[i + 1], e[i + 2], e[i + 3], e[i + 4]);
                i += 5;
                break;
            case 31:
                i += instruct_31(e[i + 1], e[i + 2], e[i + 3]);
                i += 4;
                break;
            case 32:
                instruct_32(e[i + 1], e[i + 2]);
                i += 3;
                break;
            case 33:
                instruct_33(e[i + 1], e[i + 2], e[i + 3]);
                i += 4;
                break;
            case 34:
                instruct_34(e[i + 1], e[i + 2]);
                i += 3;
                break;
            case 35:
                instruct_35(e[i + 1], e[i + 2], e[i + 3], e[i + 4]);
                i += 5;
                break;
            case 36:
                i += instruct_36(e[i + 1], e[i + 2], e[i + 3]);
                i += 4;
                break;
            case 37:
                instruct_37(e[i + 1]);
                i += 2;
                break;
            case 38:
                instruct_38(e[i + 1], e[i + 2], e[i + 3], e[i + 4]);
                i += 5;
                break;
            case 39:
                instruct_39(e[i + 1]);
                i += 2;
                break;
            case 40:
                instruct_40(e[i + 1]);
                i += 2;
                break;
            case 41:
                instruct_41(e[i + 1], e[i + 2], e[i + 3]);
                i += 4;
                break;
            case 42:
                i += instruct_42(e[i + 1], e[i + 2]);
                i += 3;
                break;
            case 43:
                i += instruct_43(e[i + 1], e[i + 2], e[i + 3]);
                i += 4;
                break;
            case 44:
                instruct_44(e[i + 1], e[i + 2], e[i + 3], e[i + 4], e[i + 5], e[i + 6]);
                i += 7;
                break;
            case 45:
                instruct_45(e[i + 1], e[i + 2]);
                i += 3;
                break;
            case 46:
                instruct_46(e[i + 1], e[i + 2]);
                i += 3;
                break;
            case 47:
                instruct_47(e[i + 1], e[i + 2]);
                i += 3;
                break;
            case 48:
                instruct_48(e[i + 1], e[i + 2]);
                i += 3;
                break;
            case 49:
                instruct_49(e[i + 1], e[i + 2]);
                i += 3;
                break;
            case 50:
            {
                int p = instruct_50({ e[i + 1], e[i + 2], e[i + 3], e[i + 4], e[i + 5], e[i + 6], e[i + 7] });
                i += 8;
                if (p < 622592)
                {
                    i += p;
                }
                else
                {
                    e[i + ((p + 32768) / 655360) - 1] = (int16_t)(p % 655360);
                }
                break;
            }
            case 51:
                instruct_51();
                i += 1;
                break;
            case 52:
                instruct_52();
                i += 1;
                break;
            case 53:
                instruct_53();
                i += 1;
                break;
            case 54:
                instruct_54();
                i += 1;
                break;
            case 55:
                i += instruct_55(e[i + 1], e[i + 2], e[i + 3], e[i + 4]);
                i += 5;
                break;
            case 56:
                instruct_56(e[i + 1]);
                i += 2;
                break;
            case 57: i += 1; break;
            case 58:
                instruct_58();
                i += 1;
                break;
            case 59:
                instruct_59();
                i += 1;
                break;
            case 60:
                i += instruct_60(e[i + 1], e[i + 2], e[i + 3], e[i + 4], e[i + 5]);
                i += 6;
                break;
            case 61:
                i += e[i + 1];
                i += 3;
                break;
            case 62:
                instruct_62(e[i + 1], e[i + 2], e[i + 3], e[i + 4], e[i + 5], e[i + 6]);
                i += 7;
                goto done;
            case 63:
                instruct_63(e[i + 1], e[i + 2]);
                i += 3;
                break;
            case 64:
                instruct_64();
                i += 1;
                break;
            case 65: i += 1; break;
            case 66:
                instruct_66(e[i + 1]);
                i += 2;
                break;
            case 67:
                instruct_67(e[i + 1]);
                i += 2;
                break;
            case 68:
                NewTalk(e[i + 1], e[i + 2], e[i + 3], e[i + 4], e[i + 5], e[i + 6], e[i + 7]);
                i += 8;
                break;
            case 69:
                ReSetName(e[i + 1], e[i + 2], e[i + 3]);
                i += 4;
                break;
            case 70:
                ShowTitle(e[i + 1], e[i + 2]);
                i += 3;
                break;
            case 71:
                JumpScene(e[i + 1], e[i + 2], e[i + 3]);
                i += 4;
                break;
            case 72:
                SetAttribute(e[i + 1], e[i + 2], e[i + 3], e[i + 4], e[i + 5]);
                i += 6;
                break;
            default: i += 1; break;
            }
        }
    }

done:
    event.key.key = 0;
    event.button.button = 0;
    if (NeedRefreshScene == 1)
    {
        // InitialScene(0);
    }
    NeedRefreshScene = 1;
}

void ReSetEntrance()
{
    memset(Entrance, -1, sizeof(Entrance));
    for (int i = 0; i < std::min(SceneAmount, 1002); i++)
    {
        if (Rscene[i].MainEntranceX1 >= 0 && Rscene[i].MainEntranceX1 < 480
            && Rscene[i].MainEntranceY1 >= 0 && Rscene[i].MainEntranceY1 < 480)
        {
            Entrance[Rscene[i].MainEntranceX1][Rscene[i].MainEntranceY1] = (int16_t)i;
        }
        if (Rscene[i].MainEntranceX2 >= 0 && Rscene[i].MainEntranceX2 < 480
            && Rscene[i].MainEntranceY2 >= 0 && Rscene[i].MainEntranceY2 < 480)
        {
            Entrance[Rscene[i].MainEntranceX2][Rscene[i].MainEntranceY2] = (int16_t)i;
        }
    }
}
void Maker()
{
    std::vector<std::string> words;
    words.push_back("");
    words.push_back("《金庸水滸傳》");
    words.push_back("hugebase");
    words.push_back("Legend of Little Village III");
    words.push_back("108 Brothers And Sisters");
    words.push_back("");

    words.push_back("鐵血丹心論壇出品");
    words.push_back("www.tiexuedanxin.net");
    words.push_back("www.dawuxia.net");
    words.push_back("www.txdx.net");
    words.push_back("");

    words.push_back("總策劃");
    words.push_back("小小猪");
    words.push_back("");

    words.push_back("總架構");
    words.push_back("bttt");
    words.push_back("");

    words.push_back("程式");
    words.push_back("凯哥");
    words.push_back("bttt");
    words.push_back("小小猪");
    words.push_back("真正的强强");
    words.push_back("无酒肆屋");
    words.push_back("");

    words.push_back("事件");
    words.push_back("小小猪");
    words.push_back("凶神恶煞");
    words.push_back("凯哥");
    words.push_back("KA");
    words.push_back("");

    words.push_back("腳本");
    words.push_back("柳无色");
    words.push_back("bttt");
    words.push_back("无酒肆屋");
    words.push_back("DonaldHuang");
    words.push_back("雲淡風清");
    words.push_back("");

    words.push_back("劇本");
    words.push_back("风神无名");
    words.push_back("天外草");
    words.push_back("云潇潇");
    words.push_back("赫连春水");
    words.push_back("馋师无相");
    words.push_back("");

    words.push_back("設計");
    words.push_back("风神无名");
    words.push_back("qja");
    words.push_back("南宫梦");
    words.push_back("xuantianxi");
    words.push_back("");

    words.push_back("美工");
    words.push_back("游客");
    words.push_back("xuantianxi");
    words.push_back("令狐心情");
    words.push_back("小孩家家");
    words.push_back("伊人枕边醉");
    words.push_back("Czhe520");
    words.push_back("流木匆匆");
    words.push_back("无酒肆屋");
    words.push_back("项羽");
    words.push_back("楼芊芊");
    words.push_back("短歌微吟");
    words.push_back("蕴殊");
    words.push_back("宁夜");
    words.push_back("出门在哪儿");
    words.push_back("");

    words.push_back("場景");
    words.push_back("游客");
    words.push_back("柳无色");
    words.push_back("");

    words.push_back("音效");
    words.push_back("凯哥");
    words.push_back("云潇潇");
    words.push_back("赫连春水");
    words.push_back("");

    words.push_back("工具");
    words.push_back("KA");
    words.push_back("真正的强强");
    words.push_back("bttt");
    words.push_back("");

    words.push_back("測試");
    words.push_back("9523");
    words.push_back("gn0811");
    words.push_back("张贝克");
    words.push_back("Chopsticks");
    words.push_back("天真木頭人");
    words.push_back("叶墨");
    words.push_back("柳无色");
    words.push_back("路人甲");
    words.push_back("杨裕彪");
    words.push_back("CLRGC");
    words.push_back("");

    words.push_back("校對");
    words.push_back("天一水");
    words.push_back("天下有敵");
    words.push_back("南窗寄傲生");
    words.push_back("xq3366");
    words.push_back("");

    words.push_back("Android移植");
    words.push_back("KA");
    words.push_back("bttt");
    words.push_back("");

    words.push_back("特別感謝");
    words.push_back("河洛工作室");
    words.push_back("智冠科技");
    words.push_back("游泳的鱼");
    words.push_back("chaoliu");
    words.push_back("fanyixia");
    words.push_back("hihi88byebye");
    words.push_back("chenxurui07");
    words.push_back("晴空飞雪");
    words.push_back("蓝雨冰刀");
    words.push_back("玉芷馨");
    words.push_back("chumsdock");
    words.push_back("沧海一笑");
    words.push_back("ena");
    words.push_back("qiu001");
    words.push_back("winson7891");
    words.push_back("halfrice");
    words.push_back("soastao");
    words.push_back("NamelessOne47");
    words.push_back("lsl330");
    words.push_back("泥巴");
    words.push_back("王子");
    words.push_back("ice");
    words.push_back("黑天鹅");
    words.push_back("");

    words.push_back("開發工具以及開發庫");
    words.push_back("Free Pascal Compiler");
    words.push_back("Lazarus / CodeTyphon");
    words.push_back("MSVC / Clang / GCC");
    words.push_back("ADT / NDK");
    words.push_back("SDL & TTF & Image & gfx & Mixer");
    words.push_back("OpenGL");
    words.push_back("bass & bassmidi");
    words.push_back("FFmpeg / Libav");
    words.push_back("zlib / minizip / libzip");
    words.push_back("lua");
    words.push_back("Github Copilot");
    words.push_back("");

    words.push_back("致謝以下開源項目");
    words.push_back("JEDI-SDL");
    words.push_back("kys-pascal");
    words.push_back("kys-cpp");
    words.push_back("smallpot / smallpot-lite");
    words.push_back("UltraStar Deluxe");
    words.push_back("Open Chinese Convert");
    words.push_back("Pascal Game Development");
    words.push_back("");

    words.push_back("致謝以下MOD項目");
    words.push_back("金庸群俠前傳");
    words.push_back("人在江湖-雜兵模擬器");
    words.push_back("逐夢江湖行");
    words.push_back("");

    words.push_back(
        "特別致謝短歌行"
        "MIDI音色庫");
    words.push_back("");

    words.push_back("再次致謝");
    words.push_back("論壇無數版友");
    words.push_back("以及網絡上的諸多素材");
    words.push_back("");

    if (Where < 3)
    {
        PlayMP3(StartMusic, -1);
        Redraw();
    }
    ScrollTextAmi(words, 22, 20, 23, 0, 0, 0, 15, -1, 0);
}

void ScrollTextAmi(std::vector<std::string>& words, int chnsize, int engsize, int linespace,
    int align, int alignx, int style, int delay, int picnum, int scrolldirect)
{
    Redraw();
    CleanTextScreen();
    SetFontSize(chnsize, engsize, 1);

    int texw, texh0;
    if (TEXT_LAYER == 0)
    {
        texw = CENTER_X * 2;
        texh0 = CENTER_Y * 2;
    }
    else
    {
        texw = RESOLUTIONX;
        texh0 = RESOLUTIONY;
    }
    int texh = (int)words.size() * linespace + texh0 * 3 / 2;

    if (picnum < 0)
    {
        RecordFreshScreen();
    }

    SDL_Texture* tex = nullptr;
    SDL_Surface* sur = nullptr;
    tex = SDL_CreateTexture(render, SDL_PIXELFORMAT_ARGB8888, SDL_TEXTUREACCESS_TARGET, texw, texh);
    SDL_SetRenderTarget(render, tex);
    SDL_SetRenderDrawBlendMode(render, SDL_BLENDMODE_NONE);
    SDL_SetRenderDrawColor(render, 0, 0, 0, 255);
    SDL_RenderFillRect(render, nullptr);
    SDL_SetRenderTarget(render, screenTex);
    if (TEXT_LAYER == 0)
    {
        SDL_SetTextureBlendMode(tex, SDL_BLENDMODE_BLEND);
    }
    else
    {
        SDL_SetTextureBlendMode(tex, SDL_BLENDMODE_NONE);
    }

    for (int l = 0; l < (int)words.size(); l++)
    {
        std::string str = words[l];
        int len = DrawLength(str.c_str());
        int x;
        if (align == 0)
        {
            x = texw / 2 - len * chnsize / 4 - 10;
        }
        else
        {
            x = alignx;
        }

        uint32 color1 = ColColor(0x64);
        uint32 color2 = ColColor(0x66);
        if (l > 0 && !words[l - 1].empty() && style == 0)
        {
            color1 = ColColor(5);
            color2 = ColColor(7);
        }
        DrawShadowText(str, x, l * linespace + texh0, color1, color2, tex, sur, 1);
    }
    ResetFontSize();

    SDL_SetTextureAlphaMod(tex, 192);

    int i = 0;
    CleanTextScreen();
    HaveText = 1;
    while (SDL_PollEvent(&event) || true)
    {
        SDL_FRect dest = { 0, (float)-i, (float)texw, (float)texh0 };
        if (picnum < 0)
        {
            LoadFreshScreen();
            if (TEXT_LAYER == 1)
            {
                SDL_SetRenderTarget(render, TextScreenTex);
            }
            else
            {
                SDL_SetRenderTarget(render, screenTex);
            }
            SDL_RenderTexture(render, tex, &dest, nullptr);
        }
        else
        {
            if (picnum <= (int)TitlePNGIndex.size() - 1)
            {
                int w = TitlePNGIndex[picnum].w;
                int h = TitlePNGIndex[picnum].h;
                SDL_FRect src;
                src.x = (float)(i * (w - CENTER_X * 2) / std::max(1, texh - CENTER_Y * 2) + w - CENTER_X * 2);
                src.y = 0;
                src.w = (float)(CENTER_X * 2);
                src.h = (float)h;
                SDL_SetRenderTarget(render, screenTex);
                SDL_Rect src1 = Rectf2(src);
                DrawTPic(picnum, 0, 0, &src1);
                SDL_FRect destpic = { 0, 240, (float)texw, (float)(texh0 - 240) };
                SDL_FRect tempdest = { 0, (float)(-i + texh0 / 2), (float)texw, (float)(texh0 / 2) };
                if (TEXT_LAYER != 0)
                {
                    SDL_SetRenderTarget(render, TextScreenTex);
                }
                else
                {
                    SDL_SetTextureAlphaMod(tex, 255);
                }
                SDL_RenderTexture(render, tex, &tempdest, &destpic);
            }
        }
        UpdateAllScreen();
        i--;
        if (i <= -texh + texh0)
        {
            WaitAnyKey();
            break;
        }
        CheckBasicEvent();
        if (event.type == SDL_EVENT_MOUSE_BUTTON_UP && event.button.button == SDL_BUTTON_RIGHT)
        {
            break;
        }
        if (event.type == SDL_EVENT_KEY_UP && event.key.key == SDLK_ESCAPE)
        {
            break;
        }
        SDL_Delay(delay);
    }

    SDL_DestroyTexture(tex);

    if (picnum < 0)
    {
        FreeFreshScreen();
    }
    HaveText = 1;
    CleanTextScreen();
    CleanKeyValue();
}

void InitGrowth()
{
    int r;
    if (Rrole[0].Aptitude > 75)
    {
        r = rand() % 8;
        Rrole[0].IncLife = r + 14;
        r = rand() % 8;
        Rrole[0].AddMP = r + 14;
        r = rand() % 3;
        Rrole[0].AddAtk = r + 3;
        r = rand() % 3;
        Rrole[0].AddDef = r + 3;
        r = rand() % 3;
        Rrole[0].AddSpeed = r;
    }
    else if (Rrole[0].Aptitude > 60)
    {
        r = rand() % 8;
        Rrole[0].IncLife = r + 17;
        r = rand() % 8;
        Rrole[0].AddMP = r + 17;
        r = rand() % 3;
        Rrole[0].AddAtk = r + 4;
        r = rand() % 3;
        Rrole[0].AddDef = r + 4;
        r = rand() % 3;
        Rrole[0].AddSpeed = r + 1;
    }
    else
    {
        r = rand() % 8;
        Rrole[0].IncLife = r + 20;
        r = rand() % 8;
        Rrole[0].AddMP = r + 20;
        r = rand() % 3;
        Rrole[0].AddAtk = r + 5;
        r = rand() % 3;
        Rrole[0].AddDef = r + 5;
        r = rand() % 3;
        Rrole[0].AddSpeed = r + 1;
    }
}

void CloudCreate(int num)
{
    if (num < 0 || num >= (int)Cloud.size())
    {
        return;
    }
    Cloud[num].Positionx = rand() % 17280;
    Cloud[num].Positiony = rand() % 8640;
    Cloud[num].Speedx = rand() % 3 + 1;
    Cloud[num].Speedy = 0;
    Cloud[num].Picnum = rand() % std::max(1, CPicAmount);
    Cloud[num].Shadow = 0;
    Cloud[num].Alpha = 255 - (rand() % 50 + 30) * 255 / 100;
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
    std::string scriptFile = AppPath + "script/1.lua";
    if (!filefunc::fileExist(scriptFile))
    {
        str = " Script fail!";
        DrawTextWithRect(str, CENTER_X - 384 + 400, CENTER_Y - 240 + 150, 150, ColColor(0x64), ColColor(0x66));
        WaitAnyKey();
        return;
    }
    ExecScript(scriptFile, str2);
}
