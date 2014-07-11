unit kys_main;

{
 All Heros in Kam Yung's Stories - The Replicated Edition

 Created by S.weyl in 2008 May.
 No Copyright (C) reserved.
 
 You can build it by Delphi with JEDI-SDL support.
 
 This resouce code file which is not perfect so far,
 can be modified and rebuilt freely,
 or translate it to another programming language.
 But please keep this section when you want to spread a new vision. Thanks.
 Note: it must not be a good idea to use this as a pascal paradigm.

}

{
 任何人获得这份代码之后, 均可以自由增删功能, 重新
 编译, 或译为其他语言. 但请保留本段文字.
}

interface

uses
  Windows,
  SysUtils,
  SDL_TTF,
  //SDL_mixer,
  SDL_image,
  SDL,
  Math,
  lua52,
  iniFiles,
  Dialogs,
  bassmidi, bass;

type

  TPosition = record
    x, y: integer;
  end;

  TRect = record
    x, y, w, h: integer;
  end;

  TPicInfo = record
    w, h, offx, offy: integer;
  end;

  TItemList = record
    Number, Amount: smallint;
  end;

  TCallType = (Element, Address);

  //以下所有类型均有两种引用方式：按照别名引用；按照短整数数组引用

  TRole = record
    case TCallType of
      Element: (ListNum, HeadNum, IncLife, State1: smallint;
        Name: array[0..9] of char;
        AddAtk, AddSpeed, AddDef, AddMP, RoundLeave: smallint;
        Sexual, Level: smallint;
        Exp: Uint16;
        CurrentHP, MaxHP, Hurt, Poision, PhyPower: smallint;
        ExpForItem: Uint16;
        Equip: array[0..1] of smallint;
        AmiFrameNum, AmiDelay, SoundDealy: array[0..4] of smallint;
        MPType, CurrentMP, MaxMP: smallint;
        Attack, Speed, Defence, Medcine, UsePoi, MedPoi, DefPoi, Fist, Sword, Knife, Unusual, HidWeapon: smallint;
        Knowledge, Ethics, AttPoi, Movestep, Repute, Aptitude, PracticeBook: smallint;
        ExpForBook: Uint16;
        Magic, MagLevel: array[0..9] of smallint;
        TakingItem, TakingItemAmount: array[0..3] of smallint;
        addnum: smallint;
        NeiGong, NGLevel: array[0..3] of smallint
      );
      Address: (Data: array[0..99] of smallint);
  end;

  TItem = record
    case TCallType of
      Element: (ListNum: smallint;
        Name1, Name: array[0..19] of char;
        Introduction: array[0..29] of char;
        Magic, AmiNum, User, EquipType, ShowIntro, ItemType, UnKnow5, UnKnow6, UnKnow7: smallint;
        AddCurrentHP, AddMaxHP, AddPoi, AddPhyPower, ChangeMPType, AddCurrentMP, AddMaxMP: smallint;
        AddAttack, AddSpeed, AddDefence, AddMedcine, AddUsePoi, AddMedPoi, AddDefPoi: smallint;
        AddFist, AddSword, AddKnife, AddUnusual, AddHidWeapon, AddKnowledge, AddRepute, AddMove, AddAttPoi: smallint;
        OnlyPracRole, NeedMPType, NeedMP, NeedAttack, NeedSpeed, NeedUsePoi, NeedMedcine, NeedMedPoi: smallint;
        NeedFist, NeedSword, NeedKnife, NeedUnusual, NeedHidWeapon, NeedAptitude: smallint;
        NeedExp, NeedExpForItem, NeedMaterial: smallint;
        GetItem, NeedMatAmount: array[0..4] of smallint);
      Address: (Data: array[0..94] of smallint);
  end;

  TScence = record
    case TCallType of
      Element: (ListNum: smallint;
        Name: array[0..9] of char;
        ExitMusic, EntranceMusic: smallint;
        JumpScence, EnCondition: smallint;
        MainEntranceY1, MainEntranceX1, MainEntranceY2, MainEntranceX2: smallint;
        EntranceY, EntranceX: smallint;
        ExitY, ExitX: array[0..2] of smallint;
        JumpY1, JumpX1, JumpY2, JumpX2: smallint);
      Address: (Data: array[0..25] of smallint);
  end;

  TMagic = record
    case TCallType of
      Element: (ListNum: smallint;
        Name: array[0..9] of char;
        UnKnow: array[0..4] of smallint;
        SoundNum, MagicType, AmiNum, HurtType, AttAreaType, NeedMP, Poision: smallint;
        Attack, MoveDistance, AttDistance, AddMP, HurtMP: array[0..9] of smallint);
      Address: (Data: array[0..67] of smallint);
  end;

  TShop = record
    case TCallType of
      Element: (Item, Amount, Price: array[0..4] of smallint);
      Address: (Data: array[0..14] of smallint);
  end;

  TBattleRole = record
    case TCallType of
      Element: (rnum, Team, Y, X, Face, Dead, Step, Acted: smallint;
        Pic, ShowNumber, UnUse1, UnUse2, UnUse3, ExpGot, Auto: smallint;
        loverlevel: array[0..9] of smallint;
        StateLevel, StateRound: array[0..27] of smallint;
        RealSpeed, RealProgress, BHead: smallint);
      Address: (Data: array[0..82] of smallint);
  end;
  //情侣加成，loverlevel：
  //0加攻、1加防、2加移、3抗毒、4武功威力、5内功加成、6替代受伤、7回复生命、8回复内力、9轻功
  //特技导致状态，Statelevel：
  //0攻击,1防御,2轻功,3移动,4伤害,5回血,6回内
  //7战神,8风雷,9孤注,10倾国,11毒箭,12剑芒,13连击
  //14乾坤,15灵精,16奇门,17博采,18聆音,19青翼,20回体
  //21伤逝,22黯然,23慈悲,24悲歌,25,26定身,27控制


  TWarSta = record
    case TcallType of
      Element: (BattleNum: smallint;
        BattleName: array[0..9] of byte;
        battlemap, exp, battlemusic: smallint;
        mate, automate, mate_x, mate_y: array[0..5] of smallint;
        enemy, enemy_x, enemy_y: array[0..19] of smallint);
      Address: (Data: array[0..$5C] of smallint;)
  end;
  //战场数据, 即war.sta文件的映像



  TWoodMan = record
    case TcallType of
      Element: (EnemyAmount: byte;
        Exy: array[0..1] of array[0..1] of byte;
        Rx, Ry, ExitX, ExitY: byte;
        GameData: array[0..19 * 19 - 1] of byte);
      Address: (Data: array[0..369] of byte;)
  end; //木人游戏的映像


  TCloud = record
    Picnum: integer;
    Shadow: integer;
    Alpha: integer;
    MixColor: Uint32;
    MixAlpha: integer;
    Positionx, Positiony, Speedx, Speedy: integer;
  end;

  TPInt1 = procedure(i: integer);


//程序重要子程
procedure Run;
procedure Quit;

//游戏开始画面, 行走等
procedure Start;
procedure StartAmi;
procedure ReadFiles;
function InitialRole: boolean;
procedure LoadR(num: integer);
procedure SaveR(num: integer);
function WaitAnyKey: integer;
procedure Walk;
function CanWalk(x, y: integer): boolean;
function CheckEntrance: boolean;
function InScence(Open: integer): integer;
procedure ShowScenceName(snum: integer);
function CanWalkInScence(x, y: integer): boolean;
procedure CheckEvent1;
procedure CheckEvent3;
procedure turnblack;

//选单子程
function CommonMenu(x, y, w, max: integer): integer; overload;
procedure ShowCommonMenu(x, y, w, max, menu: integer); overload;
function CommonMenu(x, y, w, max, default: integer; menustring, menuengstring: array of WideString): integer; overload;
function CommonMenu(x, y, w, max, default: integer; menustring: array of WideString): integer; overload;
function CommonMenu(x, y, w, max, default: integer; menustring, menuengstring: array of WideString;
  fn: TPInt1): integer; overload;
procedure ShowCommonMenu(x, y, w, max, menu: integer; menustring, menuengstring: array of WideString); overload;
function CommonScrollMenu(x, y, w, max, maxshow: integer): integer; overload;
procedure ShowCommonScrollMenu(x, y, w, max, maxshow, menu, menutop: integer); overload;
function CommonScrollMenu(x, y, w, max, maxshow: integer; menustring: array of WideString): integer; overload;
function CommonScrollMenu(x, y, w, max, maxshow: integer; menustring, menuengstring: array of WideString): integer;
  overload;
procedure ShowCommonScrollMenu(x, y, w, max, maxshow, menu, menutop: integer;
  menustring, menuengstring: array of WideString); overload;
function CommonMenu2(x, y, w: integer): integer; overload;
procedure ShowCommonMenu2(x, y, w, menu: integer); overload;
function CommonMenu2(x, y, w: integer; menustring: array of WideString): integer; overload;
procedure ShowCommonMenu2(x, y, w, menu: integer; menustring: array of WideString); overload;
function SelectOneTeamMember(x, y: integer; str: string; list1, list2: integer): integer;
procedure MenuEsc;
procedure ShowMenu(menu: integer);
procedure MenuMedcine;
procedure MenuMedPoision;
function MenuItem: boolean;
function ReadItemList(ItemType: integer): integer;
procedure ShowMenuItem(row, col, x, y, atlu: integer);
procedure DrawItemFrame(x, y: integer);
procedure UseItem(inum: integer);
function CanEquip(rnum, inum: integer): boolean;
procedure MenuStatus;
procedure ShowStatusByTeam(tnum: integer);
procedure ShowStatus(rnum: integer; bnum: integer = 0);
procedure MenuLeave;
procedure MenuSystem;
procedure ShowMenuSystem(menu: integer);
procedure MenuLoad;
function MenuLoadAtBeginning: boolean;
procedure MenuSave;
procedure MenuQuit;

//医疗, 解毒, 使用物品的效果等
procedure EffectMedcine(role1, role2: integer);
procedure EffectMedPoision(role1, role2: integer);
procedure EatOneItem(rnum, inum: integer);

//事件系统
procedure CallEvent(num: integer);
procedure ReSetEntrance; //重设入口
procedure Maker;

procedure swap(var x, y: byte);
procedure initgrowth();

procedure CloudCreate(num: integer);
procedure CloudCreateOnSide(num: integer);



var

  CHINESE_FONT: PAnsiChar = 'resource\kaiu.ttf';
  CHINESE_FONT_SIZE: integer = 20;
  ENGLISH_FONT: PAnsiChar = 'resource\consola.ttf';
  ENGLISH_FONT_SIZE: integer = 18;

  CENTER_X: integer = 320;
  CENTER_Y: integer = 240;

  //以下为常数表, 其中多数可以由ini文件改变
  BEGIN_MISSION_NUM: integer = 100; //任务起始对话
  MISSION_AMOUNT: integer = 100; //任务数
  STATUS_AMOUNT: integer = 100; //状态数
  ITEM_BEGIN_PIC: integer = 3445; //物品起始图片
  BEGIN_EVENT: integer = 232; //初始事件
  BEGIN_SCENCE: integer = 0; //初始场景
  BEGIN_Sx: integer = 20; //初始坐标(程序中的x, y与游戏中是相反的, 这是早期的遗留问题)
  BEGIN_Sy: integer = 19; //初始坐标
  SOFTSTAR_BEGIN_TALK: integer = 2547; //软体娃娃对话的开始编号
  SOFTSTAR_NUM_TALK: integer = 18; //软体娃娃的对话数量
  MAX_PHYSICAL_POWER: integer = 100; //最大体力
  MONEY_ID: integer = 0; //银两的物品代码
  COMPASS_ID: integer = 1; //罗盘的物品代码
  BEGIN_LEAVE_EVENT: integer = 950; //起始离队事件
  BEGIN_BATTLE_ROLE_PIC: integer = 2553; //人物起始战斗贴图
  MAX_LEVEL: integer = 301; //最大等级
  MAX_WEAPON_MATCH: integer = 34; //'武功武器配合'组合的数量
  MAX_LOVER: integer = 23; //情侣加成数量
  MAX_LOVER_STATE: integer = 10;
  MIN_KNOWLEDGE: integer = 80; //最低有效武学常识
  MAX_ITEM_AMOUNT: integer = 456; //最大物品数量
  MAX_HP: integer = 999; //最大生命
  MAX_MP: integer = 999; //最大内功
  SIMPLE: integer = 0; //简繁
  fullscreen: integer; //是否全屏
  MaxProList: array[43..58] of integer = (100, 100, 100, 100, 100, 100, 100, 100, 100, 100,
    100, 100, 100, 100, 100, 100);
  //最大攻击值~最大左右互博值

  LIFE_HURT: integer = 2; //伤害值比例

  //以下3个常数实际并未使用, 不能由ini文件指定
  NOVEL_BOOK: integer = 144; //天书起始编码(因偷懒并未使用)
  MAX_HEAD_NUM: integer = 189; //有专有头像的最大人物编号, 仅用于对话指令
  BEGIN_WALKPIC: integer = 2500; //起始的行走贴图(并未使用)

  MPic, SPic, WPic, EPic: array[0..10000000] of byte;
  MIdx, SIdx, WIdx, EIdx: array[0..10000] of integer;
  FPic: array[0..1000000] of byte;
  FIdx: array[0..300] of integer;
  HPic: array[0..2000000] of byte;
  HIdx: array[0..500] of integer;
  //以上为贴图的内容及索引
  Earth, Surface, Building, BuildX, BuildY, Entrance: array[0..479, 0..479] of smallint;
  //主地图数据
  ACol, ACol1, ACol2: array[0..768] of byte;
  //默认调色板数据
  LastShowScene: smallint = -1;
  InShip, Useless1, Mx, My, Sx, Sy, MFace, ShipX, ShipY, ShipX1, ShipY1, ShipFace: smallint;
  TeamList: array[0..5] of smallint;
  RItemList: array of TItemList;
  WoodManSta: TWoodMan;
  MStep: integer = 1;
  Still: integer;
  //主地图坐标, 方向, 步数, 是否处于静止
  Cx, Cy, SFace, SStep: integer;
  //场景内坐标, 场景中心点, 方向, 步数
  CurScence, CurEvent, CurItem, CurrentBattle, Where: integer;
  //当前场景, 事件(在场景中的事件号), 使用物品, 战斗
  //where: 0-主地图, 1-场景, 2-战场, 3-开头画面
  SaveNum: integer;
  //存档号, 未使用
  RRole: array[0..1000] of TRole;
  RItem: array[0..1000] of TItem;
  RScence: array[0..1000] of TScence;
  RMagic: array[0..1000] of TMagic;
  RShop: array[0..20] of TShop;
  //R文件数据, 均远大于原有容量
  ItemList: array[0..500] of smallint;
  ScenceAmount: integer;
  SData: array[0..400, 0..5, 0..63, 0..63] of smallint;
  DData: array[0..400, 0..199, 0..10] of smallint;
  //S, D文件数据
  //Scence1, SData[CurScence, 1, , Scence3, Scence4, Scence5, Scence6, Scence7, Scence8: array[0..63, 0..63] of smallint;
  //当前场景数据
  //0-地面, 1-建筑, 2-物品, 3-事件, 4-建筑高度, 5-物品高度
  ScenceImg, ScenceImg2: array[0..2303, 0..1401] of Uint32;
  //ScenceImgEx: array[0..2303, -250..-1] of Uint32;
  //场景的图形映像. 实时重画场景效率较低, 故首先生成映像, 需要时载入
  //ScenceD: array[0..199, 0..10] of smallint;
  //当前场景事件
  BFieldImg: array[0..2303, 0..1401] of Uint32;
  //战场图形映像

  BlockImg, BlockImg2: array[0..2303, 0..1401] of integer;
  BlockScreen: array of integer;
  //场景和战场的遮挡信息, 前者不会记录地板数据, 将需要遮挡的部分的像素记录为该像素隶属物品位置的深度
  //(定义为 depth =  x + y), 该值是决定遮挡的关键部分. 后者仅记录当前屏幕的遮挡深度

  BField: array[0..7, 0..63, 0..63] of smallint;
  //战场数据
  //0-地面, 1-建筑, 2-人物, 3-可否被选中, 4-攻击范围, 5, 6 ,7-未使用
  WarSta: TwarSta;
  //战场数据, 即war.sta文件的映像
  BRole: array[0..99] of TBattleRole;
  //战场人物属性
  //0-人物序号, 1-敌我, 2, 3-坐标, 4-面对方向, 5-是否仍在战场, 6-可移动步数, 7-是否行动完毕,
  //8-贴图(未使用), 9-头上显示数字, 10, 11, 12-未使用, 13-已获得经验, 14-是否自动战斗
  BRoleAmount: integer;
  //战场人物总数
  Bx, By, Ax, Ay: integer;
  //当前人物坐标, 选择目标的坐标
  Bstatus: integer;
  //战斗状态, 0-继续, 1-胜利, 2-失败
  SelectAimMode: integer;
  //选择攻击目标的方式, 0-范围内敌方, 1-范围内我方, 2-敌方全部, 3-我方全部, 4-自身, 5-范围内全部, 6-全部
  //高亮
  HighLight: boolean = False;
  LeaveList: array[0..99] of smallint;
  EffectList: array[0..199] of smallint;
  LevelUpList: array[0..99] of smallint;
  MatchList: array[0..99, 0..2] of smallint;
  //各类列表, 前四个从文件读入
  Star: array[0..107] of WideString;
  RoleName: array[0..107] of WideString;
  loverlist: array[0..24, 0..4] of smallint;

  ShowMR: boolean = True;
  blackscreen: integer = 0;
  screen, RealScreen, prescreen: PSDL_Surface;
  //主画面
  event: TSDL_Event;
  //事件
  Font, EngFont: PTTF_Font;
  TextColor: TSDL_Color;
  Text: PSDL_Surface;
  //字体

  Music: array[0..99] of HSTREAM;
  ESound: array[0..99] of HSAMPLE;
  ASound: array[0..99] of HSAMPLE;
  //声音
  ExitScenceMusicNum: integer;
  //离开场景的音乐
  MusicName: string;
  time: integer;
  MenuString, MenuEngString: array of WideString;
  //选单所使用的字符串
  x50: array[-$8000..$7FFF] of smallint;
  //扩充指令50所使用的变量
  gamearray: array of array of smallint;
  snowalpha: array[0..479] of array[0..639] of byte;
  //黑幕遮罩
  //ScComp: TPSPascalCompiler;
  //ScExec: TPSExec;
  lua_script: Plua_state;
  showBlackScreen: boolean;
  gray: boolean = False;
  MissionStr: array of array of byte;
  WoodPic: Psdl_Surface;
  nowmusic: integer = 0;

  VideoMemMain: integer = 0;
  VideoMemScence: integer = 0;
  VideoMemBattle: integer = 1;
  MSurface, SSurface, BSurface: array of PSDL_Surface;
  MNumber, SNumber, BNumber: integer;
  MInfo, SInfo, BInfo: array of TPicInfo;
  AutoMode: array of integer;

  encrypt: integer = 0;
  versionstr: WideString = '完整版 v2.12 (20130331)';
  kkey: array[0..69] of byte = (8, 32, 60, 3, 1, 22, 6, 53, 65, 29, 67, 38, 20, 9, 50, 35,
    16, 14, 52, 7, 68, 62, 37, 61, 21, 47, 27, 44, 0, 13, 5, 40, 25, 51, 59, 56, 30, 17, 55,
    64, 46, 42, 45, 15, 39, 48, 41, 24, 26, 54, 66, 36, 49, 69, 10, 34, 2, 63, 33, 11, 23,
    31, 58, 19, 57, 28, 43, 18, 12, 4);

  VOLUME, VOLUMEWAV, SOUND3D, eaxon: integer;
  SoundFlag: longword;

  FWay: array[0..479, 0..479] of smallint;
  linex, liney: array[0..480 * 480 - 1] of smallint;
  nowstep: integer;

  GLHR: integer = 1; //是否使用OPENGL绘图
  SMOOTH: integer = 1; //平滑设置 0-不平滑, 1-平滑

  ScreenFlag: Uint32;
  RESOLUTIONX: integer;
  RESOLUTIONY: integer;

  RegionRect: TSDL_Rect; //指定刷新范围


  CPic: array[0..100000] of byte;
  CIdx: array[0..20] of integer;
  //云的贴图内容及索引
  KDef: array[0..1000000] of byte;
  KIdx: array[0..20000] of integer;
  //事件的内容及索引
  TDef: array[0..1000000] of byte;
  Tidx: array[0..20000] of integer;
  //对话的内容及索引

  CLOUD_AMOUNT: integer = 60; //云的数量
  Cloud: array of TCloud;

  AppPath: string;

  WALK_SPEED1: integer = 10;
  WALK_SPEED2: integer = 10;
  BATTLE_SPEED: integer = 10;
  MMAPAMI: integer = 1;
  SCENCEAMI: integer = 1;
  EFFECT_STRING: integer = 0;

  SEMIREAL: integer = 0;
  BHead: array of PSDL_Surface; //半即时用于画头像

  AskingQuit: boolean;
  NeedRefreshScence: integer;

  begin_time: integer; //游戏开始时间, 单位为分钟, 0~1439
  now_time: real;
  NIGHT_EFFECT: integer = 1; //是否使用白昼和黑夜效果

  EXIT_GAME: integer = 0; //退出时的提问方式
  KDEF_SCRIPT: integer = 0;

implementation

uses kys_script, kys_event, kys_engine, kys_battle;

//初始化字体, 音效, 视频, 启动游戏

procedure Run;
var
  title: string;
  p, p1: PChar;
  //info: BASS_INFO;
begin

{$IFDEF UNIX}
  AppPath := ExtractFilePath(ParamStr(0));
{$ELSE}
  AppPath := '';
{$ENDIF}
  //初始化字体
  TTF_Init();
  font := TTF_OpenFont(CHINESE_FONT, CHINESE_FONT_SIZE);
  engfont := TTF_OpenFont(ENGLISH_FONT, ENGLISH_FONT_SIZE);
  if font = nil then
  begin
    MessageBox(0, PChar(Format('Error:%s!', [SDL_GetError])), 'Error', MB_OK or MB_ICONHAND);
    exit;
  end;

  ReadFiles;
  //showmessage('');

  //初始化音频系统
  //SDL_Init(SDL_INIT_AUDIO);
  //Mix_OpenAudio(MIX_DEFAULT_FREQUENCY, MIX_DEFAULT_FORMAT, 2, 4096);

  SoundFlag := 0;
  if SOUND3D = 1 then
    SoundFlag := BASS_DEVICE_3D or SoundFlag;

  BASS_Init(-1, 22050, SoundFlag, 0, nil);

  if BASS_SetEAXParameters(-1, 0.0, -1.0, -1.0) then
    eaxon := 1
  else
    eaxon := 0;
  //BASS_GetInfo(info);

  //初始化视频系统
  Randomize;

  if (SDL_Init(SDL_INIT_VIDEO) < 0) then
  begin
    MessageBox(0, PChar(Format('Couldn''t initialize SDL : %s', [SDL_GetError])), 'Error', MB_OK or MB_ICONHAND);
    SDL_Quit;
    exit;
  end;

  ScreenFlag := {SDL_DOUBLEBUF or} SDL_RESIZABLE;

  if GLHR = 1 then
  begin
    ScreenFlag := SDL_OPENGL or SDL_RESIZABLE;
    SDL_GL_SetAttribute(SDL_GL_RED_SIZE, 8);
    SDL_GL_SetAttribute(SDL_GL_GREEN_SIZE, 8);
    SDL_GL_SetAttribute(SDL_GL_BLUE_SIZE, 8);
    SDL_GL_SetAttribute(SDL_GL_DEPTH_SIZE, 8);
    SDL_GL_SetAttribute(SDL_GL_DOUBLEBUFFER, 1);
  end;

  RealScreen := SDL_SetVideoMode(RESOLUTIONX, RESOLUTIONY, 32, ScreenFlag);
  screen := SDL_CreateRGBSurface(ScreenFlag, CENTER_X * 2, CENTER_Y * 2, 32, 0, 0, 0, 0);
  prescreen := SDL_CreateRGBSurface(ScreenFlag, CENTER_X * 2, CENTER_Y * 2, 32, 0, 0, 0, 0);

  {if (screen = nil) then
  begin
    MessageBox(0, PChar(Format('Couldn''t set 640x480x8 video mode : %s', [SDL_GetError])), 'Error', MB_OK or MB_ICONHAND);
    SDL_Quit;
    halt(1);
  end;}


  title := 'Legend  of  Little  Village  III  -  108  Brothers  And  Sisters';
  p := @title[1];
  while p^ <> char(0) do
  begin
    if p^ = char($20) then
    begin
      if random(2) = 1 then
      begin
        p1 := p;
        while (p1^ <> char(0)) do
        begin
          p1^ := (p1 + 1)^;
          Inc(p1);
        end;
      end;
    end;
    Inc(p);

  end;


  SDL_WM_SetCaption(@title[1], 'code by s.weyl');

  InitialScript;
  InitialMusic;
  //ReadFiles;

  if fullscreen = 1 then
    RealScreen := SDL_SetVideoMode(CENTER_X * 2, CENTER_Y * 2, 32, (ScreenFlag or SDL_FULLSCREEN));
  PlayBeginningMovie;
  Start;

  Quit;

end;

//关闭所有已打开的资源, 退出

procedure Quit;
begin
  DestroyScript;
  TTF_CloseFont(font);
  TTF_CloseFont(engfont);
  TTF_Quit;
  SDL_Quit;
  BASS_Free();
  halt(1);
  exit;

end;

//Main game.
//显示开头画面

procedure Start;
var
  menu, menup, i, col, i1, i2, x, y: integer;
  into, selected: boolean;
begin

  begin_time := random(1440);
  now_time := begin_time;
  ChangeCol;
  
  for i1 := 0 to 479 do
    for i2 := 0 to 479 do
      Entrance[i1, i2] := -1;

  display_img('resource\open.png', 0, 0);

  SDL_EnableKeyRepeat(0, 10);
  MStep := 0;

  where := 3;
  menu := 0;

  Setlength(RItemlist, MAX_ITEM_AMOUNT);
  for i := 0 to MAX_ITEM_AMOUNT - 1 do
  begin
    RItemlist[i].Number := -1;
    RItemlist[i].Amount := 0;
  end;


  SetLength(Cloud, CLOUD_AMOUNT);
  for i := 0 to CLOUD_AMOUNT - 1 do
  begin
    CloudCreate(i);
  end;

  SetLength(BlockScreen, screen.w * screen.h);

  //SpellPicture(1,50);
  x := 425;
  y := 275;
  //drawrectanglewithoutframe(270, 150, 100, 70, 0, 20);
  drawshadowtext(@versionstr[1], 5, 455, colcolor(5), colcolor(7));
  drawtitlepic(0, x, y);
  drawtitlepic(menu + 1, x, y + menu * 20);
  SDL_UpdateRect2(screen, 0, 0, screen.w, screen.h);
  PlayMp3(59, -1);
  //WoodMan(3);
  //事件等待
  SDL_EnableKeyRepeat(20, 100);
  into := False;
  while (SDL_WaitEvent(@event) >= 0) do
  begin
    //redraw;
    into := False;
    //关闭窗口事件
    CheckBasicEvent;

    //如选择第2项, 则退出(所有编号从0开始)
    if (((event.type_ = SDL_KEYUP) and ((event.key.keysym.sym = sdlk_return) or
      (event.key.keysym.sym = sdlk_space))) or ((event.type_ = SDL_MOUSEBUTTONUP) and
      (event.button.button = sdl_button_left))) and (menu = 2) then
    begin
      break;
    end;
    //选择第0项, 重新开始游戏
    if (((event.type_ = SDL_KEYUP) and ((event.key.keysym.sym = sdlk_return) or
      (event.key.keysym.sym = sdlk_space))) or ((event.type_ = SDL_MOUSEBUTTONUP) and
      (event.button.button = sdl_button_left))) and (menu = 0) then
    begin
      if InitialRole then
      begin
        CurScence := BEGIN_SCENCE;
        Inscence(1);
        SDL_UpdateRect2(screen, 0, 0, screen.w, screen.h);
        into := True;
      end;
    end;
    //选择第1项, 读入进度
    if (((event.type_ = SDL_KEYUP) and ((event.key.keysym.sym = sdlk_return) or
      (event.key.keysym.sym = sdlk_space))) or ((event.type_ = SDL_MOUSEBUTTONUP) and
      (event.button.button = sdl_button_left) and (round(event.button.x / (RealScreen.w / screen.w)) > x) and
      (round(event.button.x / (RealScreen.w / screen.w)) < x + 80) and
      (round(event.button.y / (RealScreen.h / screen.h)) > y) and
      (round(event.button.y / (RealScreen.h / screen.h)) < y + 60))) and (menu = 1) then
    begin
      //LoadR(1);
      if menuloadAtBeginning then
      begin
        //redraw;
        //SDL_UpdateRect2(screen, 0, 0, screen.w, screen.h);
        CurEvent := -1; //when CurEvent=-1, Draw scence by Sx, Sy. Or by Cx, Cy.
        into := True;
      end
      else
      begin
        drawtitlepic(0, x, y);
        drawtitlepic(menu + 1, x, y + menu * 20);
        SDL_UpdateRect2(screen, 0, 0, screen.w, screen.h);
      end;
    end;
    //按下方向键上
    if ((event.type_ = SDL_KEYUP) and (event.key.keysym.sym = sdlk_up)) then
    begin
      menu := menu - 1;
      if menu < 0 then
        menu := 2;
      drawtitlepic(0, x, y);
      drawtitlepic(menu + 1, x, y + menu * 20);
      SDL_UpdateRect2(screen, 0, 0, screen.w, screen.h);
    end;
    //按下方向键下
    if ((event.type_ = SDL_KEYUP) and (event.key.keysym.sym = sdlk_down)) then
    begin
      menu := menu + 1;
      if menu > 2 then
        menu := 0;
      drawtitlepic(0, x, y);
      drawtitlepic(menu + 1, x, y + menu * 20);
      SDL_UpdateRect2(screen, 0, 0, screen.w, screen.h);
    end;
    //鼠标移动
    if (event.type_ = SDL_MOUSEMOTION) then
    begin
      if (round(event.button.x / (RealScreen.w / screen.w)) > x) and
        (round(event.button.x / (RealScreen.w / screen.w)) < x + 80) and
        (round(event.button.y / (RealScreen.h / screen.h)) > y) and
        (round(event.button.y / (RealScreen.h / screen.h)) < y + 60) then
      begin
        menup := menu;
        menu := (round(event.button.y / (RealScreen.h / screen.h)) - y) div 20;
        if menu <> menup then
        begin
          drawtitlepic(0, x, y);
          drawtitlepic(menu + 1, x, y + menu * 20);
          SDL_UpdateRect2(screen, 0, 0, screen.w, screen.h);
        end;
      end
      else
        menu := -1;
    end;
    if into then
    begin

      if where = 1 then
      begin
        InScence(0);
      end;
      if where < 3 then
        Walk;

    end;

  end;

  SDL_EnableKeyRepeat(30, 30);

end;

//开头字幕

procedure StartAmi;
var
  x, y, i, len: integer;
  str: WideString;
  p: integer;
begin
  turnblack;
  redraw;
  i := fileopen('list\start.txt', fmOpenRead);
  len := fileseek(i, 0, 2);
  fileseek(i, 0, 0);
  setlength(str, len + 1);
  fileread(i, str[1], len);
  fileclose(i);
  p := 1;
  x := 30;
  y := 80;
  drawrectanglewithoutframe(0, 0, CENTER_X * 2, CENTER_Y * 2, 0, 60);
  for i := 1 to len + 1 do
  begin
    if str[i] = widechar(10) then
      str[i] := ' ';
    if str[i] = widechar(13) then
    begin
      str[i] := widechar(0);
      drawshadowtext(@str[p], x, y, colcolor($FF), colcolor($FF));
      p := i + 1;
      y := y + 25;
      SDL_UpdateRect2(screen, 0, 0, screen.w, screen.h);
    end;
    if str[i] = widechar($2A) then
    begin
      str[i] := ' ';
      y := 55;
      redraw;
      waitanykey;
      drawrectanglewithoutframe(0, 0, CENTER_X * 2, CENTER_Y * 2, 0, 60);
    end;
  end;
  waitanykey;
  turnblack;
  //instruct_13;
  blackscreen := 0;
end;

//读取必须的文件

procedure ReadFiles;
var
  tnum, beginnum, offset, len, idx, grp, col, t1, i, i1, b: integer;
  filename: string;
  p: pbyte;
  Kys_ini: TIniFile;
  Namestr: array of byte;

begin
  Filename := ExtractFilePath(ParamStr(0)) + 'kysmod.ini';
  Kys_ini := TIniFile.Create(filename);

  try
    {ITEM_BEGIN_PIC := Kys_ini.ReadInteger('constant', 'ITEM_BEGIN_PIC', 3501);
    MAX_HEAD_NUM := Kys_ini.ReadInteger('constant', 'MAX_HEAD_NUM', 189);
    BEGIN_EVENT := Kys_ini.ReadInteger('constant', 'BEGIN_EVENT', 691);
    BEGIN_SCENCE := Kys_ini.ReadInteger('constant', 'BEGIN_SCENCE', 70);
    BEGIN_Sx := Kys_ini.ReadInteger('constant', 'BEGIN_Sx', 20);
    BEGIN_Sy := Kys_ini.ReadInteger('constant', 'BEGIN_Sy', 19);
    SOFTSTAR_BEGIN_TALK := Kys_ini.ReadInteger('constant', 'SOFTSTAR_BEGIN_TALK', 2547);
    SOFTSTAR_NUM_TALK := Kys_ini.ReadInteger('constant', 'SOFTSTAR_NUM_TALK', 18);
    MAX_PHYSICAL_POWER := Kys_ini.ReadInteger('constant', 'MAX_PHYSICAL_POWER', 100);
    BEGIN_WALKPIC := Kys_ini.ReadInteger('constant', 'BEGIN_WALKPIC', 2500);
    MONEY_ID := Kys_ini.ReadInteger('constant', 'MONEY_ID', 174);
    COMPASS_ID := Kys_ini.ReadInteger('constant', 'COMPASS_ID', 182);
    BEGIN_LEAVE_EVENT := Kys_ini.ReadInteger('constant', 'BEGIN_LEAVE_EVENT', 950);
    BEGIN_BATTLE_ROLE_PIC := Kys_ini.ReadInteger('constant', 'BEGIN_BATTLE_ROLE_PIC', 2553);
    MAX_LEVEL := Kys_ini.ReadInteger('constant', 'MAX_LEVEL', 30);
    MAX_WEAPON_MATCH := Kys_ini.ReadInteger('constant', 'MAX_WEAPON_MATCH', 7);
    MIN_KNOWLEDGE := Kys_ini.ReadInteger('constant', 'MIN_KNOWLEDGE', 80);
    MAX_HP := Kys_ini.ReadInteger('constant', 'MAX_HP', 999);
    MAX_MP := Kys_ini.ReadInteger('constant', 'MAX_MP', 999);
    LIFE_HURT := Kys_ini.ReadInteger('constant', 'LIFE_HURT', 10);
    NOVEL_BOOK := Kys_ini.ReadInteger('constant', 'NOVEL_BOOK', 144);
    MISSION_AMOUNT := Kys_ini.ReadInteger('constant', 'MISSION_AMOUNT', 100);
    }
    //物品起始图片
    ITEM_BEGIN_PIC := 5720;
    //初始事件
    BEGIN_EVENT := 301;
    //初始场景
    BEGIN_SCENCE := 0;
    //初始坐标(程序中的x,y与游戏中是相反的,这是早期的遗留问题)
    BEGIN_Sx := 20;
    BEGIN_Sy := 19;
    //软体娃娃对话的开始编号
    SOFTSTAR_BEGIN_TALK := 2547;
    //软体娃娃的对话数量
    SOFTSTAR_NUM_TALK := 18;
    //最大体力
    MAX_PHYSICAL_POWER := 100;
    //银两的物品代码
    MONEY_ID := 0;
    //罗盘的物品代码
    COMPASS_ID := 1;
    //起始离队事件
    BEGIN_LEAVE_EVENT := 1;
    //人物起始战斗贴图
    BEGIN_BATTLE_ROLE_PIC := 2553;
    //最大等级
    MAX_LEVEL := 60;
    //'武功武器配合'组合的数量
    MAX_WEAPON_MATCH := 100;
    //最低有效武学常识
    MIN_KNOWLEDGE := 80;
    //最大物品数量
    MAX_ITEM_AMOUNT := 456;
    //伤害值比例
    LIFE_HURT := 100;
    //最大生命
    MAX_HP := 9999;
    //最大内功
    MAX_MP := 9999;
    //攻击
    MaxProList[43] := 999;
    //轻功
    MaxProList[44] := 500;
    //防御
    MaxProList[45] := 999;
    //医疗
    MaxProList[46] := 200;
    //用毒
    MaxProList[47] := 100;
    //解毒
    MaxProList[48] := 100;
    //抗毒
    MaxProList[49] := 100;
    //拳掌
    MaxProList[50] := 999;
    //御剑
    MaxProList[51] := 999;
    //耍刀
    MaxProList[52] := 999;
    //特殊
    MaxProList[53] := 999;
    //暗器
    MaxProList[54] := 999;
    //常识
    MaxProList[55] := 100;
    //品德
    MaxProList[56] := 100;
    //带毒
    MaxProList[57] := 100;
    //左右
    MaxProList[58] := 200;
    //任务列表长度
    MISSION_AMOUNT := 49;
    //状态数量
    STATUS_AMOUNT := 28;


    SIMPLE := Kys_ini.ReadInteger('set', 'SIMPLE', 0);
    Fullscreen := Kys_ini.ReadInteger('video', 'FULLSCREEN', 0);
    VideoMemMain := Kys_ini.ReadInteger('video', 'MAINMAP', 0);
    VideoMemScence := Kys_ini.ReadInteger('video', 'SCENCE', 0);
    VideoMemBattle := Kys_ini.ReadInteger('video', 'BATTLE', 0);
    VOLUME := Kys_ini.ReadInteger('music', 'VOLUME', 30);
    VOLUMEWAV := Kys_ini.ReadInteger('music', 'VOLUMEWAV', 30);
    SMOOTH := Kys_ini.ReadInteger('system', 'SMOOTH', 1);
    GLHR := Kys_ini.ReadInteger('system', 'GLHR', 1);
    RESOLUTIONX := Kys_ini.ReadInteger('system', 'RESOLUTIONX', 640);
    RESOLUTIONY := Kys_ini.ReadInteger('system', 'RESOLUTIONY', 480);
    WALK_SPEED1 := Kys_ini.ReadInteger('set', 'WALK_SPEED1', 10);
    WALK_SPEED2 := Kys_ini.ReadInteger('set', 'WALK_SPEED2', 10);
    BATTLE_SPEED := Kys_ini.ReadInteger('set', 'BATTLE_SPEED', 20);
    SOUND3D := Kys_ini.ReadInteger('music', 'SOUND3D', 1);
    MMAPAMI := Kys_ini.ReadInteger('system', 'MMAPAMI', 1);
    SCENCEAMI := Kys_ini.ReadInteger('system', 'SCENCEAMI', 2);
    SEMIREAL := Kys_ini.ReadInteger('system', 'SEMIREAL', 0);
    EFFECT_STRING := Kys_ini.ReadInteger('system', 'EFFECT_STRING', 0);
    NIGHT_EFFECT := Kys_ini.ReadInteger('system', 'NIGHT_EFFECT', 1);
    EXIT_GAME := Kys_ini.ReadInteger('system', 'EXIT_GAME', 0);
    KDEF_SCRIPT := Kys_ini.ReadInteger('system', 'KDEF_SCRIPT', 0);

    // for i := 43 to 58 do
    // begin
    //   MaxProList[i] := Kys_ini.ReadInteger('constant', 'MaxProList' + inttostr(i), 100);
    //  end;

  finally
    Kys_ini.Free;
  end;
  //showmessage(booltostr(fileexists(filename)));
  //showmessage(inttostr(max_level));

  col := fileopen('resource\mmap.col', fmopenread);
  fileread(col, ACol[0], 768);
  fileclose(col);
  move(ACol[0], ACol1[0], 768);
  move(ACol[0], ACol2[0], 768);

  idx := fileopen('resource\mmap.idx', fmopenread);
  grp := fileopen('resource\mmap.grp', fmopenread);
  len := fileseek(grp, 0, 2);
  fileseek(grp, 0, 0);
  fileread(grp, MPic[0], len);
  tnum := fileseek(idx, 0, 2) div 4;
  fileseek(idx, 0, 0);
  fileread(idx, MIdx[0], tnum * 4);
  fileclose(grp);
  fileclose(idx);
  MNumber := tnum;

  idx := fileopen('resource\sdx', fmopenread);
  grp := fileopen('resource\smp', fmopenread);
  len := fileseek(grp, 0, 2);
  fileseek(grp, 0, 0);
  fileread(grp, SPic[0], len);
  tnum := fileseek(idx, 0, 2) div 4;
  fileseek(idx, 0, 0);
  fileread(idx, SIdx[0], tnum * 4);
  fileclose(grp);
  fileclose(idx);
  SNumber := tnum;

  idx := fileopen('resource\wdx', fmopenread);
  grp := fileopen('resource\wmp', fmopenread);
  len := fileseek(grp, 0, 2);
  fileseek(grp, 0, 0);
  fileread(grp, WPic[0], len);
  tnum := fileseek(idx, 0, 2) div 4;
  fileseek(idx, 0, 0);
  fileread(idx, WIdx[0], tnum * 4);
  fileclose(grp);
  fileclose(idx);
  BNumber := tnum;

  idx := fileopen('resource\eft.idx', fmopenread);
  grp := fileopen('resource\eft.grp', fmopenread);
  len := fileseek(grp, 0, 2);
  fileseek(grp, 0, 0);
  fileread(grp, EPic[0], len);
  tnum := fileseek(idx, 0, 2) div 4;
  fileseek(idx, 0, 0);
  fileread(idx, EIdx[0], tnum * 4);
  fileclose(grp);
  fileclose(idx);

  idx := fileopen('resource\hdgrp.idx', fmopenread);
  grp := fileopen('resource\hdgrp.grp', fmopenread);
  len := fileseek(grp, 0, 2);
  fileseek(grp, 0, 0);
  fileread(grp, HPic[0], len);
  tnum := fileseek(idx, 0, 2) div 4;
  fileseek(idx, 0, 0);
  fileread(idx, HIdx[0], tnum * 4);
  fileclose(grp);
  fileclose(idx);

  idx := fileopen(AppPath + 'resource/cloud.idx', fmopenread);
  grp := fileopen(AppPath + 'resource/cloud.grp', fmopenread);
  len := fileseek(grp, 0, 2);
  fileseek(grp, 0, 0);
  fileread(grp, CPic[0], len);
  tnum := fileseek(idx, 0, 2) div 4;
  fileseek(idx, 0, 0);
  fileread(idx, CIdx[0], tnum * 4);
  fileclose(grp);
  fileclose(idx);

  idx := fileopen(AppPath + 'resource/kdef.idx', fmopenread);
  grp := fileopen(AppPath + 'resource/kdef.grp', fmopenread);
  len := fileseek(grp, 0, 2);
  fileseek(grp, 0, 0);
  fileread(grp, KDef[0], len);
  tnum := fileseek(idx, 0, 2) div 4;
  fileseek(idx, 0, 0);
  fileread(idx, KIdx[0], tnum * 4);
  fileclose(grp);
  fileclose(idx);

  idx := fileopen(AppPath + 'resource/talk.idx', fmopenread);
  grp := fileopen(AppPath + 'resource/talk.grp', fmopenread);
  len := fileseek(grp, 0, 2);
  fileseek(grp, 0, 0);
  fileread(grp, TDef[0], len);
  tnum := fileseek(idx, 0, 2) div 4;
  fileseek(idx, 0, 0);
  fileread(idx, TIdx[0], tnum * 4);
  fileclose(grp);
  fileclose(idx);

  col := fileopen('resource\earth.002', fmopenread);
  fileread(col, Earth[0, 0], 480 * 480 * 2);
  fileclose(col);
  col := fileopen('resource\surface.002', fmopenread);
  fileread(col, surface[0, 0], 480 * 480 * 2);
  fileclose(col);
  col := fileopen('resource\building.002', fmopenread);
  fileread(col, Building[0, 0], 480 * 480 * 2);
  fileclose(col);
  col := fileopen('resource\buildx.002', fmopenread);
  fileread(col, Buildx[0, 0], 480 * 480 * 2);
  fileclose(col);
  col := fileopen('resource\buildy.002', fmopenread);
  fileread(col, Buildy[0, 0], 480 * 480 * 2);
  fileclose(col);
  col := fileopen('list\leave.bin', fmopenread);
  fileread(col, leavelist[0], 200);
  fileclose(col);
  col := fileopen('list\effect.bin', fmopenread);
  fileread(col, effectlist[0], 200);
  fileclose(col);
  col := fileopen('list\levelup.bin', fmopenread);
  fileread(col, leveluplist[0], 200);
  fileclose(col);
  col := fileopen('list\match.bin', fmopenread);
  fileread(col, matchlist[0], MAX_WEAPON_MATCH * 3 * 2);
  fileclose(col);
  col := fileopen('list\lover.bin', fmopenread);
  fileread(col, loverlist[0], MAX_LOVER * 5 * 2);
  fileclose(col);

  //升级经验统一为1000点
  //for i1 := 0 to 200 - 1 do
  //  leveluplist[i1] := 1000;


  // if fileexists('resource\black.pic') then
  // begin
  //   blackscreen := IMG_Load('resource\black.pic');

  // end;

  for i1 := 0 to 479 do
  begin
    for i := 0 to 639 do
    begin
      b := ((i - ((CENTER_X * 2) shr 1)) * (i - ((CENTER_X * 2) shr 1)) + (i1 - ((CENTER_Y * 2) shr 1)) *
        (i1 - ((CENTER_Y * 2) shr 1))) div 150;
      if b > 100 then
        b := 100;
      snowalpha[i1][i] := b;
    end;
  end;
  //showmessage(inttostr((CENTER_X * 2) shr 1));
  InitialSurfaces;

  Star[0] := '天魁星';
  Star[1] := '天罡星';
  Star[2] := '天机星';
  Star[3] := '天闲星';
  Star[4] := '天勇星';
  Star[5] := '天雄星';
  Star[6] := '天猛星';
  Star[7] := '天威星';
  Star[8] := '天英星';
  Star[9] := '天贵星';
  Star[10] := '天富星';
  Star[11] := '天满星';
  Star[12] := '天孤星';
  Star[13] := '天伤星';
  Star[14] := '天立星';
  Star[15] := '天捷星';
  Star[16] := '天暗星';
  Star[17] := '天祐星';
  Star[18] := '天空星';
  Star[19] := '天速星';
  Star[20] := '天异星';
  Star[21] := '天杀星';
  Star[22] := '天微星';
  Star[23] := '天究星';
  Star[24] := '天退星';
  Star[25] := '天寿星';
  Star[26] := '天剑星';
  Star[27] := '天平星';
  Star[28] := '天罪星';
  Star[29] := '天损星';
  Star[30] := '天败星';
  Star[31] := '天牢星';
  Star[32] := '天慧星';
  Star[33] := '天暴星';
  Star[34] := '天哭星';
  Star[35] := '天巧星';
  Star[36] := '地魁星';
  Star[37] := '地煞星';
  Star[38] := '地勇星';
  Star[39] := '地杰星';
  Star[40] := '地雄星';
  Star[41] := '地威星';
  Star[42] := '地英星';
  Star[43] := '地奇星';
  Star[44] := '地猛星';
  Star[45] := '地文星';
  Star[46] := '地正星';
  Star[47] := '地阔星';
  Star[48] := '地阖星';
  Star[49] := '地强星';
  Star[50] := '地暗星';
  Star[51] := '地轴星';
  Star[52] := '地会星';
  Star[53] := '地佐星';
  Star[54] := '地佑星';
  Star[55] := '地灵星';
  Star[56] := '地兽星';
  Star[57] := '地微星';
  Star[58] := '地慧星';
  Star[59] := '地暴星';
  Star[60] := '地然星';
  Star[61] := '地猖星';
  Star[62] := '地狂星';
  Star[63] := '地飞星';
  Star[64] := '地走星';
  Star[65] := '地巧星';
  Star[66] := '地明星';
  Star[67] := '地进星';
  Star[68] := '地退星';
  Star[69] := '地满星';
  Star[70] := '地遂星';
  Star[71] := '地周星';
  Star[72] := '地隐星';
  Star[73] := '地异星';
  Star[74] := '地理星';
  Star[75] := '地俊星';
  Star[76] := '地乐星';
  Star[77] := '地捷星';
  Star[78] := '地速星';
  Star[79] := '地镇星';
  Star[80] := '地稽星';
  Star[81] := '地魔星';
  Star[82] := '地妖星';
  Star[83] := '地幽星';
  Star[84] := '地伏星';
  Star[85] := '地空星';
  Star[86] := '地僻星';
  Star[87] := '地全星';
  Star[88] := '地孤星';
  Star[89] := '地角星';
  Star[90] := '地短星';
  Star[91] := '地藏星';
  Star[92] := '地囚星';
  Star[93] := '地平星';
  Star[94] := '地损星';
  Star[95] := '地奴星';
  Star[96] := '地察星';
  Star[97] := '地恶星';
  Star[98] := '地丑星';
  Star[99] := '地数星';
  Star[100] := '地阴星';
  Star[101] := '地刑星';
  Star[102] := '地壮星';
  Star[103] := '地劣星';
  Star[104] := '地健星';
  Star[105] := '地耗星';
  Star[106] := '地贼星';
  Star[107] := '地狗星';
  {  RoleName[0] := '主角';
    RoleName[1] := '郭靖';
    RoleName[2] := '黄蓉';
    RoleName[3] := '韦小宝';
    RoleName[4] := '石破天';
    RoleName[5] := '袁承志';
    RoleName[6] := '胡斐';
    RoleName[7] := '张无忌';
    RoleName[8] := '令狐冲';
    RoleName[9] := '阿九';
    RoleName[10] := '赵敏';
    RoleName[11] := '香香';
    RoleName[12] := '小龙女';
    RoleName[13] := '杨过';
    RoleName[14] := '任盈盈';
    RoleName[15] := '陈家洛';
    RoleName[16] := '周芷若';
    RoleName[17] := '虚竹';
    RoleName[18] := '王语嫣';
    RoleName[19] := '段誉';
    RoleName[20] := '小昭';
    RoleName[21] := '萧峰';
    RoleName[22] := '阿朱';
    RoleName[23] := '袁紫衣';
    RoleName[24] := '苗若兰';
    RoleName[25] := '程灵素';
    RoleName[26] := '萧中慧';
    RoleName[27] := '袁冠南';
    RoleName[28] := '狄云';
    RoleName[29] := '仪琳';
    RoleName[30] := '水笙';
    RoleName[31] := '李文秀';
    RoleName[32] := '双儿';
    RoleName[33] := '温青青';
    RoleName[34] := '霍青桐';
    RoleName[35] := '郭襄';
    RoleName[36] := '谢逊';
    RoleName[37] := '不戒';
    RoleName[38] := '范遥';
    RoleName[39] := '杨逍';
    RoleName[40] := '陈近南';
    RoleName[41] := '殷天正';
    RoleName[42] := '卓不凡';
    RoleName[43] := '韦一笑';
    RoleName[44] := '神雕';
    RoleName[45] := '朱子柳';
    RoleName[46] := '无尘';
    RoleName[47] := '陆乘风';
    RoleName[48] := '赵半山';
    RoleName[49] := '文泰来';
    RoleName[50] := '吴六奇';
    RoleName[51] := '莫大';
    RoleName[52] := '骆冰';
    RoleName[53] := '苏荃';
    RoleName[54] := '余鱼同';
    RoleName[55] := '李沅芷';
    RoleName[56] := '钟灵';
    RoleName[57] := '石清';
    RoleName[58] := '闵柔';
    RoleName[59] := '建宁';
    RoleName[60] := '灵鹫四剑';
    RoleName[61] := '周颠';
    RoleName[62] := '武三通';
    RoleName[63] := '蓝凤凰';
    RoleName[64] := '陆无双';
    RoleName[65] := '冯阿三';
    RoleName[66] := '说不得';
    RoleName[67] := '吴领军';
    RoleName[68] := '范百龄';
    RoleName[69] := '陆冠英';
    RoleName[70] := '程遥迦';
    RoleName[71] := '彭莹玉';
    RoleName[72] := '平一指';
    RoleName[73] := '黛绮丝';
    RoleName[74] := '薛慕华';
    RoleName[75] := '耶律齐';
    RoleName[76] := '康广陵';
    RoleName[77] := '木婉清';
    RoleName[78] := '田伯光';
    RoleName[79] := '乌老大';
    RoleName[80] := '程青竹';
    RoleName[81] := '曲非烟';
    RoleName[82] := '何铁手';
    RoleName[83] := '王难姑';
    RoleName[84] := '胡青牛';
    RoleName[85] := '张中';
    RoleName[86] := '冷谦';
    RoleName[87] := '焦宛儿';
    RoleName[88] := '程瑛';
    RoleName[89] := '张三';
    RoleName[90] := '李四';
    RoleName[91] := '柯镇恶';
    RoleName[92] := '苟读';
    RoleName[93] := '石清露';
    RoleName[94] := '冯默风';
    RoleName[95] := '阿绣';
    RoleName[96] := '公孙萼';
    RoleName[97] := '郭芙';
    RoleName[98] := '李傀儡';
    RoleName[99] := '阿珂';
    RoleName[100] := '韦春芳';
    RoleName[101] := '武敦儒';
    RoleName[102] := '武修文';
    RoleName[103] := '老头子';
    RoleName[104] := '祖千秋';
    RoleName[105] := '桃谷六仙';
    RoleName[106] := '胡桂南';
    RoleName[107] := '太岳四侠';   }


  idx := fileopen('resource\talk.idx', fmopenread);
  grp := fileopen('resource\talk.grp', fmopenread);



  for i := 1 to 107 do
  begin
    t1 := i;
    fileseek(idx, (t1 - 1) * 4, 0);
    fileread(idx, offset, 4);
    fileread(idx, len, 4);
    len := (len - offset);
    setlength(NameStr, len + 1);
    fileseek(grp, offset, 0);
    fileread(grp, NameStr[0], len);

    for i1 := 0 to len - 1 do
    begin
      NameStr[i1] := (NameStr[i1] xor $FF);
      if NameStr[i1] = (255) then
        NameStr[i1] := (0);

    end;
    NameStr[i1] := (0);
    RoleName[i] := Big5toUnicode(@NameStr[0]);
  end;

  fileclose(idx);
  fileclose(grp);

end;




//初始化主角属性

function InitialRole: boolean;
var
  i, x, y: integer;
  p: array[0..14] of integer;
  str, str0, Name: WideString;
  str1: string;
  p0, p1: PChar;
begin
  LoadR(0);
  //显示输入姓名的对话框
  //form1.ShowModal;
  //str := form1.edit1.text;
  //showmessage(inttostr(where));
  if fullscreen = 1 then
    realscreen := SDL_SetVideoMode(RESOLUTIONX, RESOLUTIONY, 32, ScreenFlag);

  str1 := '蕭笑竹'; //默认名
  str := '請輸入主角之姓名              ';
  if SIMPLE = 1 then
  begin
    str1 := '萧笑竹'; //默认名
    str := '请输入主角之姓名              ';
  end;
  Result := inputquery('Enter name', str, str1);
  if fullscreen = 1 then
  begin
    realscreen := SDL_SetVideoMode(CENTER_X * 2, CENTER_Y * 2, 32, ScreenFlag or SDL_FULLSCREEN);
    redraw;
    drawtitlepic(0, 425, 275);
    drawtitlepic(1, 425, 275);
    SDL_UpdateRect2(screen, 0, 0, screen.w, screen.h);
  end;
  if str1 = '' then
    Result := False;
  if Result then
  begin
    Name := Simplified2Traditional(str1);
    str1 := unicodetobig5(@Name[1]);
    p0 := @rrole[0].Name;
    p1 := @str1[1];
    for i := 0 to 4 do
      rrole[0].Data[4 + i] := 0;
    for i := 0 to 7 do
    begin
      (p0 + i)^ := (p1 + i)^;
    end;
    redraw;
    //showmessage('');
    str := ' 資質';
    repeat
      Rrole[0].MaxHP := 100 + random(26);
      Rrole[0].CurrentHP := Rrole[0].MaxHP;
      Rrole[0].MaxMP := 100 + random(26);
      Rrole[0].CurrentMP := Rrole[0].MaxMP;
      Rrole[0].MPType := random(2);
      Rrole[0].IncLife := 1 + random(10);

      Rrole[0].Attack := 30 + random(6);
      Rrole[0].Speed := 30 + random(6);
      Rrole[0].Defence := 30 + random(6);
      Rrole[0].Medcine := 25 + random(6);
      Rrole[0].UsePoi := 25 + random(6);
      Rrole[0].MedPoi := 25 + random(6);
      Rrole[0].Fist := 25 + random(6);
      Rrole[0].Sword := 25 + random(6);
      Rrole[0].Knife := 25 + random(6);
      Rrole[0].Unusual := 25 + random(6);
      Rrole[0].HidWeapon := 25 + random(6);

      rrole[0].Aptitude := 50 + random(40);
      redraw;
      //showmessage('');
      showstatus(0);
      //showmessage('');
      drawshadowtext(@str[1], 30, CENTER_Y + 111, colcolor($21), colcolor($23));
      str0 := format('%4d', [RRole[0].Aptitude]);
      drawengshadowtext(@str0[1], 150, CENTER_Y + 111, colcolor($64), colcolor($66));
      str0 := '選定屬性后按Y鍵確認';
      drawshadowtext(@str0[1], 200, CENTER_Y + 111, colcolor($5), colcolor($7));
      SDL_UpdateRect2(screen, 0, 0, screen.w, screen.h);
      {if SDL_WaitEvent(@event) >= 0 then
      begin
        //showmessage('');
        if (event.type_ = SDL_MOUSEBUTTONUP) and (event.button.button = sdl_button_left) then
        //and (event.button.x > 200) and (event.button.x < 450)
        //and (event.button.y > CENTER_Y +111) and (event.button.y < CENTER_Y + 133) then
        begin
          showmessage('');
          break;
        end;
      end;}

    until waitanykey = sdlk_y;

    //设定初始成长
    initgrowth();

    if Name = '曹輕羽' then
    begin
      Rrole[0].MaxHP := 125;
      Rrole[0].CurrentHP := 125;
      Rrole[0].MaxMP := 125;
      Rrole[0].CurrentMP := 125;
      Rrole[0].MPType := 2;
      Rrole[0].IncLife := 28;
      Rrole[0].AddMP := 28;
      Rrole[0].AddAtk := 8;
      Rrole[0].AddDef := 8;
      Rrole[0].AddSpeed := 4;

      Rrole[0].Attack := 35;
      Rrole[0].Speed := 35;
      Rrole[0].Defence := 35;
      Rrole[0].Medcine := 30;
      Rrole[0].UsePoi := 30;
      Rrole[0].MedPoi := 30;
      Rrole[0].Fist := 30;
      Rrole[0].Sword := 30;
      Rrole[0].Knife := 30;
      Rrole[0].Unusual := 30;
      Rrole[0].HidWeapon := 30;

      rrole[0].Aptitude := 100;
      rrole[0].MagLevel[0] := 999;
    end;

    if Name = '風劍琴' then
    begin
      rrole[0].addnum := 1;
    end;

    //redraw;
    showstatus(0);
    drawshadowtext(@str[1], 30, CENTER_Y + 111, colcolor($21), colcolor($23));
    str0 := format('%4d', [RRole[0].Aptitude]);
    drawengshadowtext(@str0[1], 150, CENTER_Y + 111, colcolor($64), colcolor($66));
    SDL_UpdateRect2(screen, 0, 0, screen.w, screen.h);

    StartAmi;
    //EndAmi;
  end;
end;

procedure initgrowth();
var
  r: integer;
begin
  if rrole[0].Aptitude > 75 then
  begin
    r := random(8);
    rrole[0].IncLife := r + 14;
    r := random(8);
    rrole[0].AddMP := r + 14;
    r := random(3);
    rrole[0].AddAtk := r + 3;
    r := random(3);
    rrole[0].AddDef := r + 3;
    r := random(3);
    rrole[0].AddSpeed := r;
  end
  else
  if rrole[0].Aptitude > 60 then
  begin
    r := random(8);
    rrole[0].IncLife := r + 17;
    r := random(8);
    rrole[0].AddMP := r + 17;
    r := random(3);
    rrole[0].AddAtk := r + 4;
    r := random(3);
    rrole[0].AddDef := r + 4;
    r := random(3);
    rrole[0].AddSpeed := r + 1;
  end
  else
  begin
    r := random(8);
    rrole[0].IncLife := r + 20;
    r := random(8);
    rrole[0].AddMP := r + 20;
    r := random(3);
    rrole[0].AddAtk := r + 5;
    r := random(3);
    rrole[0].AddDef := r + 5;
    r := random(3);
    rrole[0].AddSpeed := r + 1;
  end;
end;

//读入存档, 如为0则读入起始存档

procedure LoadR(num: integer);
var
  filename: string;
  str: PChar;
  key1, key2: pbyte;
  idx, grp, t1, offset, i1, i2, len, lenkey: integer;
  BasicOffset, RoleOffset, ItemOffset, ScenceOffset, MagicOffset, WeiShopOffset, i, LenOfData: integer;
begin
  SaveNum := num;
  filename := 'R' + IntToStr(num);

  if num = 0 then
    filename := 'ranger';
  idx := fileopen('save\ranger.idx', fmopenread);
  grp := fileopen('save\' + filename + '.grp', fmopenread);

  fileread(idx, RoleOffset, 4);
  fileread(idx, ItemOffset, 4);
  fileread(idx, ScenceOffset, 4);
  fileread(idx, MagicOffset, 4);
  fileread(idx, WeiShopOffset, 4);
  fileread(idx, len, 4);
  LenOfData := fileseek(grp, 0, 2);
  fileseek(grp, 0, 0);

  fileread(grp, Inship, 2);
  fileread(grp, useless1, 2);
  fileread(grp, My, 2);
  fileread(grp, Mx, 2);
  fileread(grp, Sy, 2);
  fileread(grp, Sx, 2);
  fileread(grp, Mface, 2);
  fileread(grp, shipx, 2);
  fileread(grp, shipy, 2);
  fileread(grp, shipx1, 2);
  fileread(grp, shipy1, 2);
  fileread(grp, shipface, 2);
  fileread(grp, teamlist[0], 2 * 6);
  fileread(grp, Ritemlist[0], sizeof(Titemlist) * max_item_amount);

  fileread(grp, RRole[0], ItemOffset - RoleOffset);
  fileread(grp, RItem[0], ScenceOffset - ItemOffset);
  fileread(grp, RScence[0], MagicOffset - ScenceOffset);
  fileread(grp, RMagic[0], WeiShopOffset - MagicOffset);
  fileread(grp, Rshop[0], len - WeiShopOffset);

  //showmessage(inttostr(lenofdata));
  if LenOfData > len then
  begin
    fileread(grp, where, 2);
    if smallint(where) < 0 then
      where := 0
    else
    begin
      curScence := where;
      where := 1;
    end;
  end
  else
    where := 0;
  if num = 0 then
  begin
    where := 3;
    curScence := BEGIN_SCENCE;
    Sx := BEGIN_Sx;
    Sy := BEGIN_Sy;
  end;
  fileclose(idx);
  fileclose(grp);

  if encrypt = 1 then
  begin
    key1 := @Ritemlist[0];
    key2 := @RRole[0];
    for i := 0 to min(sizeof(Titemlist) * max_item_amount, ItemOffset - RoleOffset) - 1 do
    begin
      swap(key1^, key2^);
      Inc(key1);
      Inc(key2);
    end;
    key1 := @RItem[0];
    key2 := @Rmagic[0];
    for i := 0 to min(ScenceOffset - ItemOffset, WeiShopOffset - MagicOffset) - 1 do
    begin
      swap(key1^, key2^);
      Inc(key1);
      Inc(key2);
    end;
  end;

  //初始化入口

  ScenceAmount := (MagicOffset - ScenceOffset) div 52;
  ResetEntrance;

  filename := 'S' + IntToStr(num);
  if num = 0 then
    filename := 'Allsin';
  grp := fileopen('save\' + filename + '.grp', fmopenread);
  fileread(grp, Sdata, ScenceAmount * 64 * 64 * 6 * 2);
  fileclose(grp);
  filename := 'D' + IntToStr(num);
  if num = 0 then
    filename := 'Alldef';
  grp := fileopen('save\' + filename + '.grp', fmopenread);
  fileread(grp, Ddata, ScenceAmount * 200 * 11 * 2);
  fileclose(grp);
  str := @Rrole[0].Name;
  len := MultiByteToWideChar(950, 0, PChar(str), -1, nil, 0);
  setlength(RoleName[0], len - 1);
  MultiByteToWideChar(950, 0, PChar(str), length(str), pwidechar(RoleName[0]), len + 1);
  RoleName[0] := concat(' ', RoleName[0]);
  idx := fileopen('resource\talk.idx', fmopenread);
  grp := fileopen('resource\talk.grp', fmopenread);


  BEGIN_MISSION_NUM := RRole[650].Data[0];
  setlength(MissionStr, MISSION_AMOUNT);
  for i := 0 to MISSION_AMOUNT - 1 do
  begin
    t1 := BEGIN_MISSION_NUM + i;
    if t1 = 0 then
    begin
      offset := 0;
      fileread(idx, len, 4);
    end
    else
    begin
      fileseek(idx, (t1 - 1) * 4, 0);
      fileread(idx, offset, 4);
      fileread(idx, len, 4);
    end;
    len := (len - offset);
    setlength(MissionStr[i], len + 1);
    fileseek(grp, offset, 0);
    fileread(grp, MissionStr[i][0], len);

    for i1 := 0 to len - 1 do
    begin
      MissionStr[i][i1] := (MissionStr[i][i1] xor $FF);
      if MissionStr[i][i1] = (255) then
        MissionStr[i][i1] := (0);

    end;
    MissionStr[i][i1] := (0);

  end;

  fileclose(idx);
  fileclose(grp);
  blackscreen := 0;
  //callevent(290);
  //callevent(319);
  //callevent(1311);
end;

//存档

procedure SaveR(num: integer);
var
  filename: string;
  key1, key2: pbyte;
  idx, grp, i1, i2, length, ScenceAmount: integer;
  BasicOffset, RoleOffset, ItemOffset, ScenceOffset, MagicOffset, WeiShopOffset, i: integer;
  tmp: smallint;
begin
  SaveNum := num;
  filename := 'R' + IntToStr(num);
  tmp := -1;
  if num = 0 then
    filename := 'ranger';
  idx := fileopen('save\ranger.idx', fmopenread);
  grp := filecreate('save\' + filename + '.grp', fmopenreadwrite);
  BasicOffset := 0;
  fileread(idx, RoleOffset, 4);
  fileread(idx, ItemOffset, 4);
  fileread(idx, ScenceOffset, 4);
  fileread(idx, MagicOffset, 4);
  fileread(idx, WeiShopOffset, 4);
  fileread(idx, length, 4);

  if encrypt = 1 then
  begin
    key1 := @Ritemlist[0];
    key2 := @RRole[0];
    for i := 0 to min(sizeof(Titemlist) * max_item_amount, ItemOffset - RoleOffset) - 1 do
    begin
      swap(key1^, key2^);
      Inc(key1);
      Inc(key2);
    end;
    key1 := @RItem[0];
    key2 := @Rmagic[0];
    for i := 0 to min(ScenceOffset - ItemOffset, WeiShopOffset - MagicOffset) - 1 do
    begin
      swap(key1^, key2^);
      Inc(key1);
      Inc(key2);
    end;
  end;

  fileseek(grp, 0, 0);
  filewrite(grp, Inship, 2);
  filewrite(grp, useless1, 2);

  filewrite(grp, My, 2);
  filewrite(grp, Mx, 2);
  filewrite(grp, Sy, 2);
  filewrite(grp, Sx, 2);
  filewrite(grp, Mface, 2);
  filewrite(grp, shipx, 2);
  filewrite(grp, shipy, 2);
  filewrite(grp, shipx1, 2);
  filewrite(grp, shipy1, 2);
  filewrite(grp, shipface, 2);
  filewrite(grp, teamlist[0], 2 * 6);
  filewrite(grp, Ritemlist[0], sizeof(Titemlist) * max_item_amount);

  filewrite(grp, RRole[0], ItemOffset - RoleOffset);
  filewrite(grp, RItem[0], ScenceOffset - ItemOffset);
  filewrite(grp, RScence[0], MagicOffset - ScenceOffset);
  filewrite(grp, RMagic[0], WeiShopOffset - MagicOffset);
  filewrite(grp, Rshop[0], length - WeiShopOffset);


  if where = 0 then
  begin
    useless1 := -1;
    filewrite(grp, useless1, 2);
  end
  else
    filewrite(grp, curScence, 2);

  fileclose(idx);
  fileclose(grp);

  if encrypt = 1 then
  begin
    key1 := @Ritemlist[0];
    key2 := @RRole[0];
    for i := 0 to min(sizeof(Titemlist) * max_item_amount, ItemOffset - RoleOffset) - 1 do
    begin
      swap(key1^, key2^);
      Inc(key1);
      Inc(key2);
    end;
    key1 := @RItem[0];
    key2 := @Rmagic[0];
    for i := 0 to min(ScenceOffset - ItemOffset, WeiShopOffset - MagicOffset) - 1 do
    begin
      swap(key1^, key2^);
      Inc(key1);
      Inc(key2);
    end;
  end;

  ScenceAmount := (MagicOffset - ScenceOffset) div 52;

  filename := 'S' + IntToStr(num);
  if num = 0 then
    filename := 'Allsin';
  grp := filecreate('save\' + filename + '.grp');
  filewrite(grp, Sdata, ScenceAmount * 64 * 64 * 6 * 2);
  fileclose(grp);
  filename := 'D' + IntToStr(num);
  if num = 0 then
    filename := 'Alldef';
  grp := filecreate('save\' + filename + '.grp');
  filewrite(grp, Ddata, ScenceAmount * 200 * 11 * 2);
  fileclose(grp);

end;

//等待任意按键

function WaitAnyKey: integer;
begin
  //event.type_ := SDL_NOEVENT;
  SDL_EventState(SDL_KEYDOWN, SDL_ENABLE);
  SDL_EventState(SDL_KEYUP, SDL_ENABLE);
  SDL_EventState(SDL_mousebuttonUP, SDL_ENABLE);
  SDL_EventState(SDL_mousebuttonDOWN, SDL_ENABLE);
  event.key.keysym.sym := 0;
  event.button.button := 0;
  while (SDL_WaitEvent(@event) >= 0) do
  begin
    CheckBasicEvent;
    if (event.type_ = SDL_KEYUP) or (event.type_ = SDL_mousebuttonUP) then
      if (event.key.keysym.sym <> 0) or (event.button.button <> 0) then
        break;
  end;
  Result := event.key.keysym.sym;
  event.key.keysym.sym := 0;
  event.button.button := 0;
end;

//于主地图行走


//于主地图行走

procedure Walk;
var
  word: array[0..10] of Uint16;
  x, y, i1, i, Ayp, menu, Axp, walking, Mx1, My1, Mx2, My2, speed, stillcount, needrefresh: integer;
  now, next_time, next_time2, next_time3: uint32;
  keystate: PChar;
begin

  Where := 0;
  next_time := sdl_getticks;
  next_time2 := sdl_getticks;
  next_time3 := sdl_getticks;

  walking := 0;
  //resetpallet;
  DrawMMap;
  SDL_EnableKeyRepeat(30, 30);
  StopMp3;
  PlayMp3(16, -1);
  still := 0;
  speed := 0;

  blackscreen := 0;

  event.key.keysym.sym := 0;
  //事件轮询(并非等待)
  while SDL_PollEvent(@event) >= 0 do
  begin
    needrefresh := 0;

    //主地图动态效果, 实际仅有主角的动作
    now := sdl_getticks;

    //闪烁效果
    if (integer(now - next_time2) > 0) then
    begin
      ChangeCol;
      next_time2 := now + 200;
      //needrefresh := 1;
      //DrawMMap;
    end;

    //飘云
    if (integer(now - next_time3) > 0) and (MMAPAMI > 0) then
    begin
      for i := 0 to CLOUD_AMOUNT - 1 do
      begin
        Cloud[i].Positionx := Cloud[i].Positionx + Cloud[i].Speedx;
        Cloud[i].Positiony := Cloud[i].Positiony + Cloud[i].Speedy;
        if (Cloud[i].Positionx > 17279) or (Cloud[i].Positionx < 0) or (Cloud[i].Positiony > 8639) or
          (Cloud[i].Positiony < 0) then
        begin
          CloudCreateOnSide(i);
        end;
      end;
      next_time3 := now + 40;
      //needrefresh := 1;
    end;

    if (integer(now - next_time) > 0) and (Where = 0) then
    begin
      if (walking = 0) then
        stillcount := stillcount + 1
      else
        stillcount := 0;

      if stillcount >= 10 then
      begin
        still := 1;
        mstep := mstep + 1;
        if mstep > 6 then
          mstep := 1;
      end;
      next_time := now + 300;
      //needrefresh := 1;
    end;

    CheckBasicEvent;
    case event.type_ of
      //方向键使用压下按键事件
      SDL_KEYDOWN:
      begin
        if (event.key.keysym.sym = sdlk_left) or (event.key.keysym.sym = sdlk_kp4) then
        begin
          MFace := 2;
          walking := 2;
        end;
        if (event.key.keysym.sym = sdlk_right) or (event.key.keysym.sym = sdlk_kp6) then
        begin
          MFace := 1;
          walking := 2;
        end;
        if (event.key.keysym.sym = sdlk_up) or (event.key.keysym.sym = sdlk_kp8) then
        begin
          MFace := 0;
          walking := 2;
        end;
        if (event.key.keysym.sym = sdlk_down) or (event.key.keysym.sym = sdlk_kp2) then
        begin
          MFace := 3;
          walking := 2;
        end;
      end;
      //功能键(esc)使用松开按键事件
      SDL_KEYUP:
      begin
        keystate := PChar(SDL_GetKeyState(nil));
        walking := 0;
        if (puint8(keystate + sdlk_left)^ = 0) and (puint8(keystate + sdlk_right)^ = 0) and
          (puint8(keystate + sdlk_up)^ = 0) and (puint8(keystate + sdlk_down)^ = 0) then
        begin
          walking := 0;
          speed := 0;
        end;
          {if event.key.keysym.sym in [sdlk_left, sdlk_right, sdlk_up, sdlk_down] then
          begin
            walking := 0;
          end;}
        if (event.key.keysym.sym = sdlk_escape) then
        begin
          //event.key.keysym.sym:=0;
          MenuEsc;
          nowstep := -1;
          walking := 0;
        end;
          {if (event.key.keysym.sym = sdlk_f11) then
          begin
            execscript(pchar('script/1.lua'), pchar('f1'));
          end;
          if (event.key.keysym.sym = sdlk_f10) then
          begin
            callevent(1);
          end;}
          {if (event.key.keysym.sym = sdlk_f4) then
          begin
            if gametime > 0 then
            begin
              menu := 0;
              setlength(menustring, 2);
              setlength(menuengstring, 0);
              menustring[0] := UTF8Decode(' 回合制');
              menustring[1] := UTF8Decode(' 半即時');
              menu := commonmenu(27, 30, 90, 1, battlemode div 2);
              if menu >= 0 then
              begin
                battlemode := min(2, menu * 2);
                Kys_ini.WriteInteger('set', 'battlemode', battlemode);
              end;
              setlength(Menustring, 0);
            end;
          end;

          if (event.key.keysym.sym = sdlk_f3) then
          begin
            menu := 0;
            setlength(menustring, 2);
            setlength(menuengstring, 0);
            menustring[0] := UTF8Decode(' 天氣特效：開');
            menustring[1] := UTF8Decode(' 天氣特效：關');
            menu := commonmenu(27, 30, 180, 1, effect);
            if menu >= 0 then
            begin
              effect := menu;
              Kys_ini.WriteInteger('set', 'effect', effect);
            end;
            setlength(Menustring, 0);
          end;

          if (event.key.keysym.sym = sdlk_f1) then
          begin
            menu := 0;
            setlength(menustring, 2);
            menustring[0] := UTF8Decode(' 繁體字');
            menustring[1] := UTF8Decode(' 簡體字');
            menu := commonmenu(27, 30, 90, 1, simple);
            if menu >= 0 then
            begin
              simple := menu;
              Kys_ini.WriteInteger('set', 'simple', simple);
            end;
            setlength(Menustring, 0);
          end;

          if (event.key.keysym.sym = sdlk_f2) then
          begin
            menu := 0;
            setlength(menustring, 3);
            menustring[0] := UTF8Decode(' 遊戲速度：快');
            menustring[1] := UTF8Decode(' 遊戲速度：中');
            menustring[2] := UTF8Decode(' 遊戲速度：慢');
            menu := commonmenu(27, 30, 180, 2, min(gamespeed div 10, 2));
            if menu >= 0 then
            begin
              if menu = 0 then gamespeed := 1;
              if menu = 1 then gamespeed := 10;
              if menu = 2 then gamespeed := 20;
              Kys_ini.WriteInteger('constant', 'game_speed', gamespeed);
            end;
            setlength(Menustring, 0);
          end;

          if (event.key.keysym.sym = sdlk_f5) then
          begin
            if fullscreen = 1 then
            begin
              if HW = 0 then screen := SDL_SetVideoMode(CENTER_X * 2, CENTER_Y * 2, 32, SDL_HWSURFACE or SDL_DOUBLEBUF or SDL_ANYFORMAT)
              else screen := SDL_SetVideoMode(CENTER_X * 2, CENTER_Y * 2, 32, SDL_SWSURFACE or SDL_DOUBLEBUF or SDL_ANYFORMAT);
            end
            else
              screen := SDL_SetVideoMode(CENTER_X * 2, CENTER_Y * 2, 32, SDL_FULLSCREEN);
            fullscreen := 1 - fullscreen;
            Kys_ini.WriteInteger('set', 'fullscreen', fullscreen);
          end;
          CheckHotkey(event.key.keysym.sym);}
      end;

      Sdl_mousemotion:
      begin
        if (event.button.x < CENTER_x) and (event.button.y < CENTER_y) then
          Mface := 2;
        if (event.button.x > CENTER_x) and (event.button.y < CENTER_y) then
          Mface := 0;
        if (event.button.x < CENTER_x) and (event.button.y > CENTER_y) then
          Mface := 3;
        if (event.button.x > CENTER_x) and (event.button.y > CENTER_y) then
          Mface := 1;
      end;
      //如按下鼠标左键, 设置状态为行走
      //如松开鼠标左键, 设置状态为不行走
      //右键则呼出系统选单
      Sdl_mousebuttonup:
      begin
        if event.button.button = sdl_button_right then
        begin
          event.button.button := 0;
          //showmessage(inttostr(walking));
          menuesc;
          nowstep := -1;
          walking := 0;
        end;
        if event.button.button = sdl_button_left then
        begin
          walking := 1;
          Axp := MX + (-round(event.button.x / (RealScreen.w / screen.w)) + CENTER_x + 2 *
            round(event.button.y / (RealScreen.h / screen.h)) - 2 * CENTER_y + 18) div 36;
          Ayp := MY + (round(event.button.x / (RealScreen.w / screen.w)) - CENTER_x + 2 *
            round(event.button.y / (RealScreen.h / screen.h)) - 2 * CENTER_y + 18) div 36;
          if (ayp >= 0) and (ayp <= 479) and (axp >= 0) and (axp <= 479) {and canWalk(axp, ayp)} then
          begin
            for i := 0 to 479 do
              for i1 := 0 to 479 do
                Fway[i, i1] := -1;
            findway(MX, MY);
            Moveman(MX, MY, Axp, Ayp);
            nowstep := Fway[Axp, Ayp] - 1;
          end;
        end;
      end;
    end;

    if where = 1 then
    begin
      InScence(0);
    end;

    if walking = 2 then
    begin
      speed := speed + 1;
      still := 0;
      stillcount := 0;
      Mx1 := Mx;
      My1 := My;
      case mface of
        0: Mx1 := Mx1 - 1;
        1: My1 := My1 + 1;
        2: My1 := My1 - 1;
        3: Mx1 := Mx1 + 1;
      end;
      Mstep := Mstep + 1;
      if Mstep > 7 then
        Mstep := 2;
      if canwalk(Mx1, My1) = True then
      begin
        Mx := Mx1;
        My := My1;
      end;
      if (speed <= 1) then
        walking := 0;
      if inship = 1 then
      begin
        shipx := my;
        shipy := mx;
      end;
      //每走一步均重画屏幕, 并检测是否处于某场景入口
      DrawMMap;
      SDL_UpdateRect2(screen, 0, 0, screen.w, screen.h);
      if CheckEntrance then
        walking := 0;
    end;

    if (nowstep < 0) and (walking = 1) then
      walking := 0;

    if (nowstep >= 0) and (walking = 1) then
    begin
      still := 0;
      if sign(linex[nowstep] - Mx) < 0 then
        MFace := 0
      else if sign(linex[nowstep] - Mx) > 0 then
        MFace := 3
      else if sign(liney[nowstep] - My) > 0 then
        MFace := 1
      else
        MFace := 2;
      MStep := 7 - nowstep mod 6;

      Mx := linex[nowstep];
      My := liney[nowstep];

      Dec(nowstep);

      if inship = 1 then
      begin
        shipx := my;
        shipy := mx;
      end;
      if (shipy = mx) and (shipx = my) then
      begin
        inship := 1;
      end;
      //每走一步均重画屏幕, 并检测是否处于某场景入口
      if CheckEntrance then
        walking := 0;
      DrawMMap;
      SDL_UpdateRect2(screen, 0, 0, screen.w, screen.h);
    end;

    //如果当前处于标题画面, 则退出, 用于战斗失败
    if where >= 3 then
    begin
      exit;
    end;

    //SDL_Delay(Walk_speed1);

    if (walking = 0) and (speed = 0) and (where = 0) then
    begin
      if MMAPAMI > 0 then
      begin
        DrawMMap;
        SDL_UpdateRect2(screen, 0, 0, screen.w, screen.h);
      end;
      SDL_Delay(40); //静止时只需刷新率与最频繁的动态效果相同即可
    end
    else
      SDL_Delay(Walk_speed1);

    event.key.keysym.sym := 0;
    event.button.button := 0;

  end;

  SDL_EnableKeyRepeat(0, 10);

end;

{procedure Walk;
var
  word: array[0..10] of Uint16;
  x, y, walking, i1, axp, ayp, Mx1, My1, Mx2, My2, i: integer;
  now, next_time: uint32;
  // p:boolean;
begin

  next_time := sdl_getticks;
  Where := 0;
  walking := 0;
  mstep := 1;
  DrawMMap;
  SDL_EnableKeyRepeat(30, 30);
  StopMp3;
  PlayMp3(16, -1);
  still := 0;

  blackscreen := 0;
  //  p:=woodman(1);
    //事件轮询(并非等待)
  while SDL_PollEvent(@event) >= 0 do
  begin
    //如果当前处于标题画面, 则退出, 用于战斗失败
    if where >= 3 then
    begin
      break;
    end;
    //主地图动态效果, 实际仅有主角的动作
    now := sdl_getticks;

    if (integer(now - next_time) > 0) and (Where = 0) then
    begin
      if (Mx2 = Mx) and (My2 = My) then
      begin
        still := 1;
        mstep := mstep + 1;
        if mstep > 6 then
          mstep := 1;
      end;
      Mx2 := Mx;
      My2 := My;
      if still = 1 then
        next_time := now + 500
      else
        next_time := now + 2000;

      DrawMMap;
      SDL_UpdateRect2(screen, 0, 0, screen.w, screen.h);
      //else next_time:=next_time
    end;
    //如果主角正在行走, 则依据鼠标位置移动主角, 仅用于使用鼠标行走
    if (nowstep >= 0) and (walking = 1) then
    begin
      still := 0;
      if sign(linex[nowstep] - Mx) < 0 then
        MFace := 0
      else if sign(linex[nowstep] - Mx) > 0 then
        MFace := 3
      else if sign(liney[nowstep] - My) > 0 then
        MFace := 1
      else MFace := 2;

      MStep := 6 - nowstep mod 6;


      Mx := linex[nowstep];
      My := liney[nowstep];

      dec(nowstep);

      //每走一步均重画屏幕, 并检测是否处于某场景入口
      DrawMMap;
      SDL_Delay(10);
      //sdl_delay(5);
      SDL_UpdateRect2(screen, 0, 0, screen.w, screen.h);
      CheckEntrance;

      if inship = 1 then
      begin
        shipx := my;
        shipy := mx;
      end;
      if (shipy = mx) and (shipx = my) then
      begin
        inship := 1;
      end;
    end
    else
    begin
      walking := 0;
    end;

    CheckBasicEvent;
    case event.type_ of
      //方向键使用压下按键事件
      SDL_KEYDOWN:
        begin
          if (event.key.keysym.sym = sdlk_left) then
          begin
            still := 0;
            MFace := 2;
            MStep := Mstep + 1;
            if MStep > 6 then
              MStep := 1;
            if canwalk(Mx, My - 1) = true then
            begin
              My := My - 1;
            end;
            DrawMMap;
            //sdl_delay(5);
            SDL_UpdateRect2(screen, 0, 0, screen.w, screen.h);
            CheckEntrance;
          end;
          if (event.key.keysym.sym = sdlk_right) then
          begin
            still := 0;
            MFace := 1;
            MStep := Mstep + 1;
            if MStep > 6 then
              MStep := 1;
            if canwalk(Mx, My + 1) = true then
            begin
              My := My + 1;
            end;
            DrawMMap;
            //sdl_delay(5);
            SDL_UpdateRect2(screen, 0, 0, screen.w, screen.h);
            CheckEntrance;
          end;
          if (event.key.keysym.sym = sdlk_up) then
          begin
            still := 0;
            MFace := 0;
            MStep := Mstep + 1;
            if MStep > 6 then
              MStep := 1;
            if canwalk(Mx - 1, My) = true then
            begin
              Mx := Mx - 1;
            end;
            DrawMMap;
            //sdl_delay(5);
            SDL_UpdateRect2(screen, 0, 0, screen.w, screen.h);
            CheckEntrance;
          end;
          if (event.key.keysym.sym = sdlk_down) then
          begin
            still := 0;
            MFace := 3;
            MStep := Mstep + 1;
            if MStep > 6 then
              MStep := 1;
            if canwalk(Mx + 1, My) = true then
            begin
              Mx := Mx + 1;
            end;
            DrawMMap;
            //sdl_delay(5);
            SDL_UpdateRect2(screen, 0, 0, screen.w, screen.h);
            CheckEntrance;
          end;
          if (Inship = 1) then //isboat??
          begin
            shipy := Mx;
            shipx := My;
          end;
        end;
      //功能键(esc)使用松开按键事件
      SDL_KEYUP:
        begin
          if (event.key.keysym.sym = sdlk_escape) then
          begin
            //event.key.keysym.sym:=0;
            MenuEsc;
            walking := 0;
          end;
          if (event.key.keysym.sym = sdlk_f8) then
          begin
            if fullscreen = 0 then
              screen := SDL_SetVideoMode(CENTER_X * 2, CENTER_Y * 2, 32, SDL_SWSURFACE or SDL_DOUBLEBUF or SDL_ANYFORMAT)
            else
              screen := SDL_SetVideoMode(CENTER_X * 2, CENTER_Y * 2, 32, SDL_FULLSCREEN);
            fullscreen := 1 - fullscreen;
          end;
        end;
      //如松开鼠标左键, 设置状态为不行走
      //右键则呼出系统选单
      Sdl_mousebuttonup:
        begin
          if event.button.button = sdl_button_right then
          begin
            event.button.button := 0;
            menuesc;

            nowstep := -1;
            walking := 0;
          end;
        end;
      //如按下鼠标左键, 设置状态为行走
      Sdl_mousebuttondown:
        begin
          if event.button.button = sdl_button_left then
          begin
            walking := 1;
            Axp := MX + (-round(event.button.x / (RealScreen.w / screen.w)) + CENTER_x + 2 * round(event.button.y / (RealScreen.h / screen.h)) - 2 * CENTER_y + 18) div 36;
            Ayp := MY + (round(event.button.x / (RealScreen.w / screen.w)) - CENTER_x + 2 * round(event.button.y / (RealScreen.h / screen.h)) - 2 * CENTER_y + 18) div 36;
            if (ayp >= 0) and (ayp <= 479) and (axp >= 0) and (axp <= 479) then
            begin
              for i := 0 to 479 do
                for i1 := 0 to 479 do
                  Fway[i, i1] := -1;
              findway(MX, MY);
              Moveman(MX, MY, Axp, Ayp);
              nowstep := Fway[Axp, Ayp] - 1;
            end;
          end;
        end;
    end;
    if where >= 3 then
    begin
      break;
    end;
    SDL_Delay(9);
    event.key.keysym.sym := 0;
    event.button.button := 0;

  end;

  SDL_EnableKeyRepeat(0, 10);

end;}

//判定主地图某个位置能否行走, 是否变成船
//function in kys_main.pas


function CanWalk(x, y: integer): boolean;
begin
  if buildx[x, y] = 0 then
    canwalk := True
  else
    canwalk := False;
  //canwalk:=true;  //This sentence is used to test.
  if (x <= 0) or (x >= 479) or (y <= 0) or (y >= 479) or ((surface[x, y] >= 1692) and (surface[x, y] <= 1700)) then
    canwalk := False;
  if (earth[x, y] = 838) or ((earth[x, y] >= 612) and (earth[x, y] <= 670)) then
    canwalk := False;
  if ((earth[x, y] >= 358) and (earth[x, y] <= 362)) or ((earth[x, y] >= 506) and (earth[x, y] <= 670)) or
    ((earth[x, y] >= 1016) and (earth[x, y] <= 1022)) then
  begin
    if (Inship = 1) then //isship
    begin
      if (earth[x, y] = 838) or ((earth[x, y] >= 612) and (earth[x, y] <= 670)) then
      begin
        canwalk := False;
      end
      else if ((surface[x, y] >= 1746) and (surface[x, y] <= 1788)) then
      begin
        canwalk := False;
      end
      else
        canwalk := True;
    end

    else
    if (x = shipy) and (y = shipx) then //touch ship?
    begin
      InShip := 1;
      canwalk := True;
    end
    else if (mx = shipy) and (my = shipx) then //touch ship?
    begin
      InShip := 1;
      canwalk := True;
    end
    else
      //      InShip := 0;           //option_explicit_ori_on
      canwalk := False;
  end
  else
  begin
    if (Inship = 1) then //isboat??
    begin
      shipy := Mx; //arrrive
      shipx := My;
      shipface := Mface;
    end;
    InShip := 0;
  end;

  //canwalk := true;

end;


//Check able or not to ertrance a scence.
//检测是否处于某入口, 并是否达成进入条件

function CheckEntrance: boolean;
var
  x, y, i, snum: integer;
  //CanEntrance: boolean;
begin
  x := Mx;
  y := My;
  case Mface of
    0: x := x - 1;
    1: y := y + 1;
    2: y := y - 1;
    3: x := x + 1;
  end;
  Result := False;
  if (Entrance[x, y] >= 0) then
  begin
    Result := False;
    snum := entrance[x, y];
    if (RScence[snum].EnCondition = 0) then
      Result := True;
    //是否有人轻功超过70
    if (RScence[snum].EnCondition = 2) then
      for i := 0 to 5 do
        if teamlist[i] >= 0 then
          if Rrole[teamlist[i]].Speed > 70 then
            Result := True;
    if Result = True then
    begin
      turnblack;
      CurScence := Entrance[x, y];
      SFace := MFace;
      Mface := 3 - Mface;
      SStep := 0;
      Sx := RScence[CurScence].EntranceX;
      Sy := RScence[CurScence].EntranceY;
      //如达成条件, 进入场景并初始化场景坐标
      SaveR(6);
      InScence(0);
      //showmessage('');
      CurScence := -1;
      blackscreen := 0;
      //waitanykey;
    end;
    //instruct_13;
  end;
  //result := canentrance;
end;


procedure UpdateScenceAmi;
var
  now, next_time: uint32;
begin
  next_time := sdl_getticks;
  now := sdl_getticks;
  while True do
  begin
    now := sdl_getticks;
    if now > next_time then
    begin
      if where = 1 then
        initialscence(2);
      next_time := next_time + 200;
      sdl_delay(200);
    end;
    if (where < 1) or (where > 2) then
      break;
  end;

end;

//Walk in a scence, the returned value is the scence number when you exit. If it is -1.
//InScence(1) means the new game.
//在内场景行走, 如参数为1表示新游戏

function InScence(Open: integer): integer;
var
  grp, idx, offset, just, i1, i2, x, y: integer;
  Sx1, Sy1, s, i, AXP, ayp, walking, Prescence, haveami, speed: integer;
  filename: string;
  word: WideString;
  scencename: WideString;
  now, next_time, now2: uint32;
  keystate: PChar;
  UpDate: PSDL_Thread;
begin

  //UpDate:=SDL_CreateThread(@UpdateScenceAmi, nil);
  //LockScence:=false;
  next_time := sdl_getticks;
  Where := 1;
  walking := 0;
  just := 0;
  CurEvent := -1;
  SDL_EnableKeyRepeat(30, 30);
  speed := 0;

  blackscreen := 0;
  InitialScence;

  for i := 0 to 199 do

    if (DData[CurScence, i, 7] < DData[CurScence, i, 6]) then
    begin
      DData[CurScence, i, 5] := DData[CurScence, i, 7] + DData[CurScence, i, 8] * 2 mod
        (DData[CurScence, i, 6] - DData[CurScence, i, 7] + 2);
    end;

  now2 := 0;
  //showmessage('');
  if Open = 1 then
  begin
    Sx := BEGIN_Sx;
    Sy := BEGIN_Sy;
    Cx := Sx;
    Cy := Sy;
    CurEvent := BEGIN_EVENT;
    DrawScence;
    SDL_UpdateRect2(screen, 0, 0, screen.w, screen.h);
    Callevent(BEGIN_EVENT);
    CurEvent := -1;

  end;

  time := 15 + rrole[0].CurrentMP div 100;
  Drawscence;

  ShowScenceName(CurScence);
  //是否有第3类事件位于场景入口


  CheckEvent3;

  if SCENCEAMI = 2 then
    UpDate := SDL_CreateThread(@UpdateScenceAmi, nil);

  while (SDL_PollEvent(@event) >= 0) do
  begin
    now2 := now2 + 20;
    if integer(now2) > 4000 then
    begin
      now2 := 0;
      time := time - 1;
    end;

    if where = 0 then
    begin
      break;
    end;

    if sx > 63 then
      sx := 63;
    if sy > 63 then
      sy := 63;
    if sx < 0 then
      sx := 0;
    if sy < 0 then
      sy := 0;
    //场景内动态效果
    now := sdl_getticks;
    //next_time:=sdl_getticks;
    if integer(now - next_time) > 0 then
    begin
      haveAmi := 0;
      for i := 0 to 199 do
        if (DData[CurScence, i, 7] < DData[CurScence, i, 6]) {and (AmiCount > (DData[CurScence, i, 8] + 1))} then
        begin
          DData[CurScence, i, 5] := DData[CurScence, i, 5] + 2;
          if DData[CurScence, i, 5] > DData[CurScence, i, 6] then
            DData[CurScence, i, 5] := DData[CurScence, i, 7];
          haveAmi := haveAmi + 1;
        end;

      {for i := 0 to 199 do
        if (DData[CurScence, i, 8] > 0) or (DData[CurScence, i, 6] > 0) then
        begin
          //屏蔽了旗子的动态效果, 因贴图太大不好处理
          if ((DData[CurScence, i, 5] < 5498) or (DData[CurScence, i, 5] > 5692)) and
            (DData[CurScence, i, 7] > 0) then
          begin
            DData[CurScence, i, 5] := DData[CurScence, i, 5] + 2;
            if DData[CurScence, i, 5] > DData[CurScence, i, 6] then
              DData[CurScence, i, 5] := DData[CurScence, i, 7];
            updatescence(DData[CurScence, i, 10], DData[CurScence, i, 9]);
          end;
        end;}
      if SCENCEAMI = 1 then
      begin
        InitialScence(1);
      end;

      next_time := now + 200;
      ChangeCol;
      //DrawScence;
      //SDL_UpdateRect2(screen, 0, 0, screen.w, screen.h);
    end;

    //检查是否位于出口, 如是则退出
    if (((sx = RScence[CurScence].ExitX[0]) and (sy = RScence[CurScence].ExitY[0])) or
      ((sx = RScence[CurScence].ExitX[1]) and (sy = RScence[CurScence].ExitY[1])) or
      ((sx = RScence[CurScence].ExitX[2]) and (sy = RScence[CurScence].ExitY[2]))) then
    begin
      ResetEntrance;

      Where := 0;
      Result := -1;
      Mface := Sface;
      break;
    end;
    //检查是否位于跳转口, 如是则重新初始化场景
    if ((sx = RScence[CurScence].JumpX1) and (sy = RScence[CurScence].JumpY1)) and
      (RScence[CurScence].JumpScence >= 0) then
    begin
      turnblack;
      PreScence := CurScence;
      CurScence := Rscence[CurScence].JumpScence;
      if RScence[PreScence].MainEntranceX1 <> 0 then
      begin
        Sx := RScence[CurScence].EntranceX;
        Sy := RScence[CurScence].EntranceY;
      end
      else
      begin
        Sx := RScence[CurScence].JumpX2;
        Sy := RScence[CurScence].JumpY2;
      end;
      {if Sx = 0 then
      begin
        Sx := RScence[CurScence].JumpX2;
        Sy := RScence[CurScence].JumpY2;
      end;
      if Sx = 0 then
      begin
        Sx := RScence[CurScence].EntranceX;
        Sy := RScence[CurScence].EntranceY;
      end;}

      event.key.keysym.sym := 0;
      blackscreen := 0;
      time := 30 + rrole[0].CurrentMP div 100;
      InitialScence;
      Walking := 0;
      Drawscence;
      ShowScenceName(CurScence);
      CheckEvent3;

    end;

    //是否处于行走状态, 参考Walk
    if walking = 1 then
    begin
      if nowstep >= 0 then
      begin
        if sign(linex[nowstep] - Sy) < 0 then
          SFace := 2
        else if sign(linex[nowstep] - Sy) > 0 then
          sFace := 1
        else if sign(liney[nowstep] - SX) > 0 then
          SFace := 3
        else
          sFace := 0;

        SStep := SStep + 1;

        if SStep >= 7 then
          SStep := 1;

        // if (SData[CurScence, 3, liney[nowstep], linex[nowstep]] >= 0) and (DData[CurScence, SData[CurScence, 3, liney[nowstep], linex[nowstep]], 4] > 0) then
        // saver(6);

        Sy := linex[nowstep];
        sx := liney[nowstep];
        //Redraw;
        //SDL_UpdateRect2(screen, 0, 0, screen.w, screen.h);

        //SDL_Delay(WALK_SPEED2);

        DrawScence;
        SDL_UpdateRect2(screen, 0, 0, screen.w, screen.h);
        CheckEvent3;
        Dec(nowstep);
      end
      else
      begin
        walking := 0;
      end;
    end;

    CheckBasicEvent;
    case event.type_ of
      SDL_KEYUP:
      begin
        keystate := PChar(SDL_GetKeyState(nil));
        if (puint8(keystate + sdlk_left)^ = 0) and (puint8(keystate + sdlk_right)^ = 0) and
          (puint8(keystate + sdlk_up)^ = 0) and (puint8(keystate + sdlk_down)^ = 0) then
        begin
          walking := 0;
          speed := 0;
        end;
        if (event.key.keysym.sym = sdlk_escape) then
        begin
          //showmessage(inttostr(walking));
          MenuEsc;
          walking := 0;
        end;
        //检查是否按下Left Alt+Enter, 是则切换全屏/窗口(似乎并不经常有效)
          {if (event.key.keysym.sym = sdlk_return) and (event.key.keysym.modifier = kmod_lalt) then
          begin
            if fullscreen = 1 then
              screen := SDL_SetVideoMode(CENTER_X * 2, CENTER_Y * 2, 32, SDL_SWSURFACE or SDL_DOUBLEBUF or SDL_ANYFORMAT)
            else
              screen := SDL_SetVideoMode(CENTER_X * 2, CENTER_Y * 2, 32, SDL_FULLSCREEN);
            fullscreen := 1 - fullscreen;
          end;}
        //按下回车或空格, 检查面对方向是否有第1类事件
        if (event.key.keysym.sym = sdlk_return) or (event.key.keysym.sym = sdlk_space) then
        begin
          CheckEvent1;
        end;

      end;
      SDL_KEYDOWN:
      begin
        if (event.key.keysym.sym = sdlk_left) then
        begin
          SFace := 2;
          walking := 2;
        end;
        if (event.key.keysym.sym = sdlk_right) then
        begin
          SFace := 1;
          walking := 2;
        end;
        if (event.key.keysym.sym = sdlk_up) then
        begin
          SFace := 0;
          walking := 2;
        end;
        if (event.key.keysym.sym = sdlk_down) then
        begin
          SFace := 3;
          walking := 2;
        end;
      end;
      Sdl_mousemotion:
      begin
        if (event.button.x < CENTER_x) and (event.button.y < CENTER_y) then
          Sface := 2;
        if (event.button.x > CENTER_x) and (event.button.y < CENTER_y) then
          Sface := 0;
        if (event.button.x < CENTER_x) and (event.button.y > CENTER_y) then
          Sface := 3;
        if (event.button.x > CENTER_x) and (event.button.y > CENTER_y) then
          Sface := 1;
      end;
      Sdl_mousebuttonup:
      begin
        if event.button.button = sdl_button_right then
        begin
          menuesc;
          nowstep := 0;
          walking := 0;
          if where = 0 then
          begin
            if RScence[CurScence].ExitMusic >= 0 then
            begin
              stopmp3;
              playmp3(RScence[CurScence].ExitMusic, -1);
            end;
            redraw;
            SDL_UpdateRect2(screen, 0, 0, screen.w, screen.h);
            break;
          end;
        end;
        if event.button.button = sdl_button_middle then
        begin
          CheckEvent1;
        end;
        if event.button.button = sdl_button_left then
        begin
          if walking = 0 then
          begin
            walking := 1;
            Ayp := (-(round(event.button.x / (RealScreen.w / screen.w))) + CENTER_x + 2 *
              ((round(event.button.y / (RealScreen.h / screen.h))) + Sdata[curScence, 4, sx, sy]) -
              2 * CENTER_y + 18) div 36 + Sx;
            Axp := ((round(event.button.x / (RealScreen.w / screen.w))) - CENTER_x + 2 *
              ((round(event.button.y / (RealScreen.h / screen.h))) + Sdata[curScence, 4, sx, sy]) -
              2 * CENTER_y + 18) div 36 + Sy;
            if (ayp in [0..63]) and (axp in [0..63]) then
            begin
              for i := 0 to 63 do
                for i1 := 0 to 63 do
                  Fway[i, i1] := -1;
              findway(SY, SX);
              Moveman(SY, sx, axp, ayp);
              nowstep := Fway[axp, ayp] - 1;
            end
            else
            begin
              walking := 0;
            end;
          end;
          event.button.button := 0;
        end;
      end;
    end;

    if where >= 3 then
    begin
      break;
    end;

    //是否处于行走状态
    if walking = 2 then
    begin
      speed := speed + 1;
      //stillcount := 0;
      {if walking = 2 then //如果用鼠标则重置方向
      begin
        SDL_GetMouseState2(x, y);
        if (x < CENTER_x) and (y < CENTER_y) then
          Sface := 2;
        if (x > CENTER_x) and (y < CENTER_y) then
          Sface := 0;
        if (x < CENTER_x) and (y > CENTER_y) then
          Sface := 3;
        if (x > CENTER_x) and (y > CENTER_y) then
          Sface := 1;
      end;}
      Sx1 := Sx;
      Sy1 := Sy;
      case Sface of
        0: Sx1 := Sx1 - 1;
        1: Sy1 := Sy1 + 1;
        2: Sy1 := Sy1 - 1;
        3: Sx1 := Sx1 + 1;
      end;
      Sstep := Sstep + 1;
      if Sstep >= 7 then
        Sstep := 1;
      if canwalkInScence(Sx1, Sy1) = True then
      begin
        Sx := Sx1;
        Sy := Sy1;
      end;
      //CurScenceRolePic := 2500 + SFace * 7 + SStep;
      //一定步数之内一次动一格
      if (speed <= 1) then
      begin
        walking := 0;
        //sdl_delay(20);
      end;
      //if (walking = 1) then
      //walking := 0;
      //sdl_delay(5);
      DrawScence;
      SDL_UpdateRect2(screen, 0, 0, screen.w, screen.h);
      CheckEvent3;

    end;


    //sdl_delay(WALK_SPEED2);

    event.key.keysym.sym := 0;
    if (walking = 0) and (speed = 0) and (where = 1) then
    begin
      if SCENCEAMI > 0 then
      begin
        DrawScence;
        SDL_UpdateRect2(screen, 0, 0, screen.w, screen.h);
      end;
      sdl_delay(40);
    end
    else
      sdl_delay(WALK_SPEED2);
    //event.key.keysym.sym := 0;
    //event.button.button := 0;

  end;


  turnblack; //黑屏

  //if (SCENCEAMI = 2) then
  //SDL_KillThread(UpDate);

  ReDraw;
  SDL_UpdateRect2(screen, 0, 0, screen.w, screen.h);

  if Rscence[CurScence].ExitMusic >= 0 then
  begin
    stopmp3;
    playmp3(Rscence[CurScence].ExitMusic, -1);
  end;

end;

procedure ShowScenceName(snum: integer);
var
  scencename: WideString;
  Name: array[0..10] of byte;
  p: pbyte;
  i: integer;
begin
  if LastShowScene <> snum then
  begin
    LastShowScene := snum;
    SDL_UpdateRect2(screen, 0, 0, screen.w, screen.h);
    //显示场景名
    p := @rscence[snum].Name[0];
    for i := 0 to 9 do
    begin
      Name[i] := p^;
      Inc(p, 1);
    end;
    Name[10] := 0;
    scencename := big5tounicode(@Name[0]);
    drawtextwithrect(@scencename[1], 320 - length(PChar(@Name)) * 5 + 7, 100, length(PChar(@Name)) *
      10 + 6, colcolor(5), colcolor(7));
    //waitanykey;
    //改变音乐
    if Rscence[snum].EntranceMusic >= 0 then
    begin
      stopmp3;
      playmp3(Rscence[snum].EntranceMusic, -1);
    end;
    SDL_Delay(500);
  end;
end;

//判定场景内某个位置能否行走

function CanWalkInScence(x, y: integer): boolean;
begin
  if (SData[CurScence, 1, x, y] = 0) then
    Result := True
  else
    Result := False;
  if (SData[CurScence, 3, x, y] >= 0) and (Result) and (DData[CurScence, SData[CurScence, 3, x, y], 0] = 1) then
    Result := False;
  if (abs(SData[CurScence, 4, x, y] - SData[CurScence, 4, sx, sy]) > 9) then
    Result := False;
  //直接判定贴图范围
  if ((SData[CurScence, 0, x, y] >= 358) and (SData[CurScence, 0, x, y] <= 362)) or
    (SData[CurScence, 0, x, y] = 522) or (SData[CurScence, 0, x, y] = 1022) or
    ((SData[CurScence, 0, x, y] >= 1324) and (SData[CurScence, 0, x, y] <= 1330)) or
    (SData[CurScence, 0, x, y] = 1348) then
    Result := False;
  //if SData[CurScence, 0, x, y] = 1358 * 2 then result := true;

end;

//检查是否有第1类事件, 如有则调用

procedure CheckEvent1;
var
  x, y: integer;
begin
  x := Sx;
  y := Sy;
  case SFace of
    0: x := x - 1;
    1: y := y + 1;
    2: y := y - 1;
    3: x := x + 1;
  end;
  //如有则调用事件
  if SData[CurScence, 3, x, y] >= 0 then
  begin
    CurEvent := SData[CurScence, 3, x, y];
    if DData[CurScence, CurEvent, 2] >= 0 then
      callevent(DData[CurScence, SData[CurScence, 3, x, y], 2]);
  end;
  CurEvent := -1;
end;

//检查是否有第3类事件, 如有则调用

procedure CheckEvent3;
var
  enum: integer;
begin
  enum := SData[CurScence, 3, Sx, Sy];
  if (DData[CurScence, enum, 4] > 0) and (enum >= 0) then
  begin
    CurEvent := enum;
    //waitanykey;
    callevent(DData[CurScence, enum, 4]);
    CurEvent := -1;
  end;
end;

//Menus.
//通用选单, (位置(x, y), 宽度, 最大选项(编号均从0开始))
//使用前必须设置选单使用的字符串组才有效, 字符串组不可越界使用

function CommonMenu(x, y, w, max: integer): integer;
var
  menu, menup: integer;
begin
  menu := 0;
  //SDL_EnableKeyRepeat(0,10);
  SDL_EnableKeyRepeat(20, 100);
  //DrawMMap;
  showcommonMenu(x, y, w, max, menu);
  SDL_UpdateRect2(screen, x, y, w + 1, max * 22 + 29);
  while (SDL_WaitEvent(@event) >= 0) do
  begin
    CheckBasicEvent;
    case event.type_ of
      SDL_KEYDOWN:
      begin
        if (event.key.keysym.sym = sdlk_down) then
        begin
          menu := menu + 1;
          if menu > max then
            menu := 0;
          showcommonMenu(x, y, w, max, menu);
          SDL_UpdateRect2(screen, x, y, w + 1, max * 22 + 29);
        end;
        if (event.key.keysym.sym = sdlk_up) then
        begin
          menu := menu - 1;
          if menu < 0 then
            menu := max;
          showcommonMenu(x, y, w, max, menu);
          SDL_UpdateRect2(screen, x, y, w + 1, max * 22 + 29);
        end;
      end;
      SDL_KEYUP:
      begin
        if ((event.key.keysym.sym = sdlk_escape)) then
        begin
          Result := -1;
          ReDraw;
          SDL_UpdateRect2(screen, x, y, w + 1, max * 22 + 29);
          break;
        end;
        if (event.key.keysym.sym = sdlk_return) or (event.key.keysym.sym = sdlk_space) then
        begin
          Result := menu;
          Redraw;
          SDL_UpdateRect2(screen, x, y, w + 1, max * 22 + 29);
          break;
        end;
      end;
      SDL_MOUSEBUTTONUP:
      begin
        if (event.button.button = sdl_button_right) then
        begin
          Result := -1;
          ReDraw;
          SDL_UpdateRect2(screen, x, y, w + 1, max * 22 + 29);
          break;
        end;
        if (event.button.button = sdl_button_left) then
        begin
          if (round(event.button.x / (RealScreen.w / screen.w)) >= x) and
            (round(event.button.x / (RealScreen.w / screen.w)) < x + w) and
            (round(event.button.y / (RealScreen.h / screen.h)) > y) and
            (round(event.button.y / (RealScreen.h / screen.h)) < y + max * 22 + 29) then
          begin
            if menu > -1 then
            begin
              Result := menu;
              Redraw;
              SDL_UpdateRect2(screen, x, y, w + 1, max * 22 + 29);
              break;
            end;
          end;
        end;
      end;
      SDL_MOUSEMOTION:
      begin
        if (round(event.button.x / (RealScreen.w / screen.w)) >= x) and
          (round(event.button.x / (RealScreen.w / screen.w)) < x + w) and
          (round(event.button.y / (RealScreen.h / screen.h)) > y) and
          (round(event.button.y / (RealScreen.h / screen.h)) < y + max * 22 + 29) then
        begin
          menup := menu;
          menu := (round(event.button.y / (RealScreen.h / screen.h)) - y - 2) div 22;
          if menu > max then
            menu := max;
          if menu < 0 then
            menu := 0;
          if menup <> menu then
          begin
            showcommonMenu(x, y, w, max, menu);
            SDL_UpdateRect2(screen, x, y, w + 1, max * 22 + 29);
          end;
        end
        else
          menu := -1;
      end;
    end;
  end;
  //清空键盘键和鼠标键值, 避免影响其余部分
  event.key.keysym.sym := 0;
  event.button.button := 0;
  SDL_EnableKeyRepeat(30, 30);

end;

function CommonMenu(x, y, w, max, default: integer; menustring, menuengstring: array of WideString;
  fn: TPInt1): integer; overload;
var
  menu, menup: integer;
begin
  //{$IFDEF DARWIN}
  RegionRect.x := x;
  RegionRect.y := y;
  RegionRect.w := w + 1;
  RegionRect.h := max * 22 + 29;
  //{$ENDIF}
  menu := default;
  //SDL_EnableKeyRepeat(0,10);
  //DrawMMap;
  showcommonMenu(x, y, w, max, menu, menustring, menuengstring);
  SDL_UpdateRect2(screen, x, y, w + 1, max * 22 + 29);
  fn(menu);
  while (SDL_WaitEvent(@event) >= 0) do
  begin
    CheckBasicEvent;
    case event.type_ of
      SDL_KEYUP:
      begin
        if (event.key.keysym.sym = sdlk_down) then
        begin
          menu := menu + 1;
          if menu > max then
            menu := 0;
          showcommonMenu(x, y, w, max, menu, menustring, menuengstring);
          SDL_UpdateRect2(screen, x, y, w + 1, max * 22 + 29);
          fn(menu);
        end;
        if (event.key.keysym.sym = sdlk_up) then
        begin
          menu := menu - 1;
          if menu < 0 then
            menu := max;
          showcommonMenu(x, y, w, max, menu, menustring, menuengstring);
          SDL_UpdateRect2(screen, x, y, w + 1, max * 22 + 29);
          fn(menu);
        end;
        if ((event.key.keysym.sym = sdlk_escape)) {and (where <= 2)} then
        begin
          Result := -1;
          ReDraw;
          //SDL_UpdateRect2(screen, x, y, w + 1, max * 22 + 29);
          break;
        end;
      end;
      SDL_MOUSEBUTTONUP:
      begin
        if (event.button.button = sdl_button_right) {and (where <= 2)} then
        begin
          Result := -1;
          ReDraw;
          //SDL_UpdateRect2(screen, x, y, w + 1, max * 22 + 29);
          break;
        end;
      end;
      SDL_MOUSEMOTION:
      begin
        if (round(event.button.x / (RealScreen.w / screen.w)) >= x) and
          (round(event.button.x / (RealScreen.w / screen.w)) < x + w) and
          (round(event.button.y / (RealScreen.h / screen.h)) > y) and
          (round(event.button.y / (RealScreen.h / screen.h)) < y + max * 22 + 29) then
        begin
          menup := menu;
          menu := (round(event.button.y / (RealScreen.h / screen.h)) - y - 2) div 22;
          if menu > max then
            menu := max;
          if menu < 0 then
            menu := 0;
          if menup <> menu then
          begin
            showcommonMenu(x, y, w, max, menu, menustring, menuengstring);
            SDL_UpdateRect2(screen, x, y, w + 1, max * 22 + 29);
            fn(menu);
          end;
        end;
      end;
    end;
  end;

  //清空键盘键和鼠标键值, 避免影响其余部分
  event.key.keysym.sym := 0;
  event.button.button := 0;
  //{$IFDEF DARWIN}
  RegionRect.w := 0;
  RegionRect.h := 0;
  //{$ENDIF}
end;

//显示通用选单(位置, 宽度, 最大值)
//这个通用选单包含两个字符串组, 可分别显示中文和英文

procedure ShowCommonMenu(x, y, w, max, menu: integer);
var
  i, p: integer;
begin
  //{$IFDEF DARWIN}
  RegionRect.x := x;
  RegionRect.y := y;
  RegionRect.w := w + 1;
  RegionRect.h := max * 22 + 29;
  //{$ENDIF}
  redraw;
  //{$IFDEF DARWIN}
  RegionRect.w := 0;
  RegionRect.h := 0;
  //{$ENDIF}

  DrawRectangle(x, y, w, max * 22 + 28, 0, colcolor(255), 30);
  if length(Menuengstring) > 0 then
    p := 1
  else
    p := 0;
  for i := 0 to max do
    if i = menu then
    begin
      drawshadowtext(@menustring[i][1], x - 17, y + 2 + 22 * i, colcolor($64), colcolor($66));
      if p = 1 then
        drawengshadowtext(@menuengstring[i][1], x + 93, y + 2 + 22 * i, colcolor($64), colcolor($66));
    end
    else
    begin
      drawshadowtext(@menustring[i][1], x - 17, y + 2 + 22 * i, colcolor($5), colcolor($7));
      if p = 1 then
        drawengshadowtext(@menuengstring[i][1], x + 93, y + 2 + 22 * i, colcolor($5), colcolor($7));
    end;

end;

function CommonMenu(x, y, w, max, default: integer; menustring: array of WideString): integer; overload;
var
  menuengstring: array of WideString;
begin
  setlength(menuengstring, 0);
  Result := CommonMenu(x, y, w, max, default, menustring, menuengstring);
end;

function CommonMenu(x, y, w, max, default: integer; menustring, menuengstring: array of WideString): integer; overload;
var
  menu, menup: integer;
begin
  //{$IFDEF DARWIN}
  RegionRect.x := x;
  RegionRect.y := y;
  RegionRect.w := w + 1;
  RegionRect.h := max * 22 + 29;
  //{$ENDIF}
  menu := default;
  //SDL_EnableKeyRepeat(0,10);
  //DrawMMap;
  showcommonMenu(x, y, w, max, menu, menustring, menuengstring);
  SDL_UpdateRect2(screen, x, y, w + 1, max * 22 + 29);
  while (SDL_WaitEvent(@event) >= 0) do
  begin
    CheckBasicEvent;
    case event.type_ of
      SDL_KEYUP:
      begin
        if (event.key.keysym.sym = sdlk_down) then
        begin
          menu := menu + 1;
          if menu > max then
            menu := 0;
          showcommonMenu(x, y, w, max, menu, menustring, menuengstring);
          SDL_UpdateRect2(screen, x, y, w + 1, max * 22 + 29);
        end;
        if (event.key.keysym.sym = sdlk_up) then
        begin
          menu := menu - 1;
          if menu < 0 then
            menu := max;
          showcommonMenu(x, y, w, max, menu, menustring, menuengstring);
          SDL_UpdateRect2(screen, x, y, w + 1, max * 22 + 29);
        end;
        if ((event.key.keysym.sym = sdlk_escape)) {and (where <= 2)} then
        begin
          Result := -1;
          //ReDraw;
          //SDL_UpdateRect2(screen, x, y, w + 1, max * 22 + 29);
          break;
        end;
        if (event.key.keysym.sym = sdlk_return) or (event.key.keysym.sym = sdlk_space) then
        begin
          Result := menu;
          //Redraw;
          //SDL_UpdateRect2(screen, x, y, w + 1, max * 22 + 29);
          break;
        end;
      end;
      SDL_MOUSEBUTTONUP:
      begin
        if (event.button.button = sdl_button_right) {and (where <= 2)} then
        begin
          Result := -1;
          //ReDraw;
          //SDL_UpdateRect2(screen, x, y, w + 1, max * 22 + 29);
          break;
        end;
        if (event.button.button = sdl_button_left) then
        begin
          if (round(event.button.x / (RealScreen.w / screen.w)) >= x) and
            (round(event.button.x / (RealScreen.w / screen.w)) < x + w) and
            (round(event.button.y / (RealScreen.h / screen.h)) > y) and
            (round(event.button.y / (RealScreen.h / screen.h)) < y + max * 22 + 29) then
          begin
            Result := menu;
            //Redraw;
            //SDL_UpdateRect2(screen, x, y, w + 1, max * 22 + 29);
            break;
          end;
        end;
      end;
      SDL_MOUSEMOTION:
      begin
        if (round(event.button.x / (RealScreen.w / screen.w)) >= x) and
          (round(event.button.x / (RealScreen.w / screen.w)) < x + w) and
          (round(event.button.y / (RealScreen.h / screen.h)) > y) and
          (round(event.button.y / (RealScreen.h / screen.h)) < y + max * 22 + 29) then
        begin
          menup := menu;
          menu := (round(event.button.y / (RealScreen.h / screen.h)) - y - 2) div 22;
          if menu > max then
            menu := max;
          if menu < 0 then
            menu := 0;
          if menup <> menu then
          begin
            showcommonMenu(x, y, w, max, menu, menustring, menuengstring);
            SDL_UpdateRect2(screen, x, y, w + 1, max * 22 + 29);
          end;
        end;
      end;
    end;
  end;

  //清空键盘键和鼠标键值, 避免影响其余部分
  event.key.keysym.sym := 0;
  event.button.button := 0;
  //{$IFDEF DARWIN}
  RegionRect.w := 0;
  RegionRect.h := 0;
  //{$ENDIF}
end;

procedure ShowCommonMenu(x, y, w, max, menu: integer; menustring, menuengstring: array of WideString); overload;
var
  i, p: integer;
  temp: PSDL_Surface;
begin
  redraw;
  DrawRectangle(x, y, w, max * 22 + 28, 0, colcolor(255), 30);
  if (length(Menuengstring) > 0) and (length(Menustring) = length(Menuengstring)) then
    p := 1
  else
    p := 0;
  for i := 0 to min(max, length(Menustring) - 1) do
    if i = menu then
    begin
      drawshadowtext(@menustring[i][1], x - 17, y + 2 + 22 * i, colcolor($64), colcolor($66));
      if p = 1 then
        drawengshadowtext(@menuengstring[i][1], x + 73, y + 2 + 22 * i, colcolor($64), colcolor($66));
    end
    else
    begin
      drawshadowtext(@menustring[i][1], x - 17, y + 2 + 22 * i, colcolor($5), colcolor($7));
      if p = 1 then
        drawengshadowtext(@menuengstring[i][1], x + 73, y + 2 + 22 * i, colcolor($5), colcolor($7));
    end;

end;

//卷动选单

function CommonScrollMenu(x, y, w, max, maxshow: integer): integer;
var
  menu, menup, menutop: integer;
begin

  SDL_EnableKeyRepeat(20, 100);
  menu := 0;
  menutop := 0;
  //SDL_EnableKeyRepeat(0,10);
  //DrawMMap;
  showcommonscrollMenu(x, y, w, max, maxshow, menu, menutop);
  //SDL_UpdateRect2(screen, x, y, w + 1, maxshow * 22 + 29);
  while (SDL_WaitEvent(@event) >= 0) do
  begin
    CheckBasicEvent;
    case event.type_ of
      SDL_KEYDOWN:
      begin
        if (event.key.keysym.sym = sdlk_down) then
        begin
          menu := menu + 1;
          if menu - menutop >= maxshow then
          begin
            menutop := menutop + 1;
          end;
          if menu > max then
          begin
            menu := 0;
            menutop := 0;
          end;
          showcommonscrollMenu(x, y, w, max, maxshow, menu, menutop);
          // SDL_UpdateRect2(screen, x, y, w + 1, maxshow * 22 + 29);
        end;
        if (event.key.keysym.sym = sdlk_up) then
        begin
          menu := menu - 1;
          if menu <= menutop then
          begin
            menutop := menu;
          end;
          if menu < 0 then
          begin
            menu := max;
            menutop := menu - maxshow + 1;
            if menutop < 0 then
              menutop := 0;

          end;
          showcommonscrollMenu(x, y, w, max, maxshow, menu, menutop);
          // SDL_UpdateRect2(screen, x, y, w + 1, maxshow * 22 + 29);
        end;
        if (event.key.keysym.sym = sdlk_pagedown) then
        begin
          menu := menu + maxshow;
          menutop := menutop + maxshow;
          if menu > max then
          begin
            menu := max;
          end;
          if menutop > max - maxshow + 1 then
          begin
            menutop := max - maxshow + 1;
          end;
          showcommonscrollMenu(x, y, w, max, maxshow, menu, menutop);
          //  SDL_UpdateRect2(screen, x, y, w + 1, maxshow * 22 + 29);
        end;
        if (event.key.keysym.sym = sdlk_pageup) then
        begin
          menu := menu - maxshow;
          menutop := menutop - maxshow;
          if menu < 0 then
          begin
            menu := 0;
          end;
          if menutop < 0 then
          begin
            menutop := 0;
          end;
          showcommonscrollMenu(x, y, w, max, maxshow, menu, menutop);
          //  SDL_UpdateRect2(screen, x, y, w + 1, maxshow * 22 + 29);
        end;
      end;
      SDL_KEYUP:
      begin
        if ((event.key.keysym.sym = sdlk_escape)) and (where <= 2) then
        begin
          Result := -1;
          ReDraw;
          SDL_UpdateRect2(screen, 0, 0, screen.w, screen.h);
          break;
        end;
        if (event.key.keysym.sym = sdlk_return) or (event.key.keysym.sym = sdlk_space) then
        begin
          Result := menu;
          Redraw;
          SDL_UpdateRect2(screen, 0, 0, screen.w, screen.h);
          break;
        end;
      end;
      SDL_MOUSEBUTTONUP:
      begin
        if (event.button.button = sdl_button_right) and (where <= 2) then
        begin
          Result := -1;
          ReDraw;
          SDL_UpdateRect2(screen, x, y, w + 1, maxshow * 22 + 29);
          break;
        end;
        if (event.button.button = sdl_button_left) then
        begin
          if (round(event.button.x / (RealScreen.w / screen.w)) >= x) and
            (round(event.button.x / (RealScreen.w / screen.w)) < x + w) and
            (round(event.button.y / (RealScreen.h / screen.h)) > y) and
            (round(event.button.y / (RealScreen.h / screen.h)) < y + max * 22 + 29) then
          begin
            if menu > -1 then
            begin
              Result := menu;
              Redraw;
              SDL_UpdateRect2(screen, x, y, w + 1, maxshow * 22 + 29);
              break;
            end;
          end;
        end;
        if (event.button.button = sdl_button_wheeldown) then
        begin
          menu := menu + 1;
          if menu - menutop >= maxshow then
          begin
            menutop := menutop + 1;
          end;
          if menu > max then
          begin
            menu := 0;
            menutop := 0;
          end;
          showcommonscrollMenu(x, y, w, max, maxshow, menu, menutop);
          //SDL_UpdateRect2(screen, x, y, w + 1, maxshow * 22 + 29);
        end;
        if (event.button.button = sdl_button_wheelup) then
        begin
          menu := menu - 1;
          if menu <= menutop then
          begin
            menutop := menu;
          end;
          if menu < 0 then
          begin
            menu := max;
            menutop := menu - maxshow + 1;
            if menutop < 0 then
              menutop := 0;

          end;
          showcommonscrollMenu(x, y, w, max, maxshow, menu, menutop);
          //SDL_UpdateRect2(screen, x, y, w + 1, maxshow * 22 + 29);
        end;
      end;
      SDL_MOUSEMOTION:
      begin
        if (round(event.button.x / (RealScreen.w / screen.w)) >= x) and
          (round(event.button.x / (RealScreen.w / screen.w)) < x + w) and
          (round(event.button.y / (RealScreen.h / screen.h)) > y) and
          (round(event.button.y / (RealScreen.h / screen.h)) < y + max * 22 + 29) then
        begin
          menup := menu;
          menu := (round(event.button.y / (RealScreen.h / screen.h)) - y - 2) div 22 + menutop;
          if menu > max then
            menu := max;
          if menu < 0 then
            menu := 0;
          if menup <> menu then
          begin
            showcommonscrollMenu(x, y, w, max, maxshow, menu, menutop);
            //SDL_UpdateRect2(screen, x, y, w + 1, maxshow * 22 + 29);
          end;
        end
        else
          menu := -1;
      end;
    end;
  end;
  //清空键盘键和鼠标键值, 避免影响其余部分
  event.key.keysym.sym := 0;
  event.button.button := 0;
  SDL_EnableKeyRepeat(30, 30);

end;

//卷动选单

function CommonScrollMenu(x, y, w, max, maxshow: integer; menustring: array of WideString): integer; overload;
var
  menuengstring: array of WideString;
begin
  setlength(menuengstring, 0);
  Result := CommonScrollMenu(x, y, w, max, maxshow, menustring, menuengstring);
end;

function CommonScrollMenu(x, y, w, max, maxshow: integer; menustring, menuengstring: array of WideString): integer;
  overload;
var
  menu, menup, menutop: integer;
begin
  menu := 0;
  menutop := 0;
  //SDL_EnableKeyRepeat(0,10);
  //DrawMMap;
  showcommonscrollMenu(x, y, w, max, maxshow, menu, menutop, menustring, menuengstring);
  SDL_UpdateRect2(screen, x, y, w + 1, maxshow * 22 + 29);
  while (SDL_WaitEvent(@event) >= 0) do
  begin
    CheckBasicEvent;
    case event.type_ of
      SDL_KEYUP:
      begin
        if (event.key.keysym.sym = sdlk_down) then
        begin
          menu := menu + 1;
          if menu - menutop >= maxshow then
          begin
            menutop := menutop + 1;
          end;
          if menu > max then
          begin
            menu := 0;
            menutop := 0;
          end;
          showcommonscrollMenu(x, y, w, max, maxshow, menu, menutop, menustring, menuengstring);
          SDL_UpdateRect2(screen, x, y, w + 1, maxshow * 22 + 29);
        end;
        if (event.key.keysym.sym = sdlk_up) then
        begin
          menu := menu - 1;
          if menu <= menutop then
          begin
            menutop := menu;
          end;
          if menu < 0 then
          begin
            menu := max;
            menutop := menu - maxshow + 1;
          end;
          showcommonscrollMenu(x, y, w, max, maxshow, menu, menutop, menustring, menuengstring);
          SDL_UpdateRect2(screen, x, y, w + 1, maxshow * 22 + 29);
        end;
        if (event.key.keysym.sym = sdlk_pagedown) then
        begin
          menu := menu + maxshow;
          menutop := menutop + maxshow;
          if menu > max then
          begin
            menu := max;
          end;
          if menutop > max - maxshow + 1 then
          begin
            menutop := max - maxshow + 1;
          end;
          showcommonscrollMenu(x, y, w, max, maxshow, menu, menutop, menustring, menuengstring);
          SDL_UpdateRect2(screen, x, y, w + 1, maxshow * 22 + 29);
        end;
        if (event.key.keysym.sym = sdlk_pageup) then
        begin
          menu := menu - maxshow;
          menutop := menutop - maxshow;
          if menu < 0 then
          begin
            menu := 0;
          end;
          if menutop < 0 then
          begin
            menutop := 0;
          end;
          showcommonscrollMenu(x, y, w, max, maxshow, menu, menutop, menustring, menuengstring);
          SDL_UpdateRect2(screen, x, y, w + 1, maxshow * 22 + 29);
        end;
        if ((event.key.keysym.sym = sdlk_escape)) and (where <= 2) then
        begin
          Result := -1;
          ReDraw;
          SDL_UpdateRect2(screen, x, y, w + 1, maxshow * 22 + 29);
          break;
        end;
        if (event.key.keysym.sym = sdlk_return) or (event.key.keysym.sym = sdlk_space) then
        begin
          Result := menu;
          Redraw;
          SDL_UpdateRect2(screen, x, y, w + 1, maxshow * 22 + 29);
          break;
        end;
      end;
      SDL_MOUSEBUTTONUP:
      begin
        if (event.button.button = sdl_button_right) and (where <= 2) then
        begin
          Result := -1;
          ReDraw;
          SDL_UpdateRect2(screen, x, y, w + 1, maxshow * 22 + 29);
          break;
        end;
        if (event.button.button = sdl_button_left) then
        begin
          if (round(event.button.x / (RealScreen.w / screen.w)) >= x) and
            (round(event.button.x / (RealScreen.w / screen.w)) < x + w) and
            (round(event.button.y / (RealScreen.h / screen.h)) > y) and
            (round(event.button.y / (RealScreen.h / screen.h)) <
            y + max * 22 + 29) then
          begin
            Result := menu;
            Redraw;
            SDL_UpdateRect2(screen, x, y, w + 1, maxshow * 22 + 29);
            break;
          end;
        end;
        if (event.button.button = sdl_button_wheeldown) then
        begin
          menu := menu + 1;
          if menu - menutop >= maxshow then
          begin
            menutop := menutop + 1;
          end;
          if menu > max then
          begin
            menu := 0;
            menutop := 0;
          end;
          showcommonscrollMenu(x, y, w, max, maxshow, menu, menutop, menustring, menuengstring);
          SDL_UpdateRect2(screen, x, y, w + 1, maxshow * 22 + 29);
        end;
        if (event.button.button = sdl_button_wheelup) then
        begin
          menu := menu - 1;
          if menu <= menutop then
          begin
            menutop := menu;
          end;
          if menu < 0 then
          begin
            menu := max;
            menutop := menu - maxshow + 1;
          end;
          showcommonscrollMenu(x, y, w, max, maxshow, menu, menutop, menustring, menuengstring);
          SDL_UpdateRect2(screen, x, y, w + 1, maxshow * 22 + 29);
        end;
      end;
      SDL_MOUSEMOTION:
      begin
        if (round(event.button.x / (RealScreen.w / screen.w)) >= x) and
          (round(event.button.x / (RealScreen.w / screen.w)) < x + w) and
          (round(event.button.y / (RealScreen.h / screen.h)) > y) and
          (round(event.button.y / (RealScreen.h / screen.h)) < y +
          max * 22 + 29) then
        begin
          menup := menu;
          menu := (round(event.button.y / (RealScreen.h / screen.h)) - y - 2) div 22 + menutop;
          if menu > max then
            menu := max;
          if menu < 0 then
            menu := 0;
          if menup <> menu then
          begin
            showcommonscrollMenu(x, y, w, max, maxshow, menu, menutop, menustring, menuengstring);
            SDL_UpdateRect2(screen, x, y, w + 1, maxshow * 22 + 29);
          end;
        end;
      end;
    end;
  end;
  //清空键盘键和鼠标键值, 避免影响其余部分
  event.key.keysym.sym := 0;
  event.button.button := 0;

end;

procedure ShowCommonScrollMenu(x, y, w, max, maxshow, menu, menutop: integer);
var
  i, p: integer;
begin
  //{$IFDEF DARWIN}
  RegionRect.x := x;
  RegionRect.y := y;
  RegionRect.w := w + 1;
  RegionRect.h := maxshow * 22 + 29;
  //{$ENDIF}
  redraw;
  //{$IFDEF DARWIN}
  RegionRect.w := 0;
  RegionRect.h := 0;
  //{$ENDIF}
  //showmessage(inttostr(y));
  if max + 1 < maxshow then
    maxshow := max + 1;
  DrawRectangle(x, y, w, maxshow * 22 + 6, 0, colcolor(255), 30);
  if length(Menuengstring) > 0 then
    p := 1
  else
    p := 0;
  for i := menutop to menutop + maxshow - 1 do
    if i = menu then
    begin
      drawshadowtext(@menustring[i][1], x - 17, y + 2 + 22 * (i - menutop), colcolor($64), colcolor($66));
      if p = 1 then
        drawengshadowtext(@menuengstring[i][1], x + 73, y + 2 + 22 * (i - menutop), colcolor($64), colcolor($66));
    end
    else
    begin
      drawshadowtext(@menustring[i][1], x - 17, y + 2 + 22 * (i - menutop), colcolor($5), colcolor($7));
      if p = 1 then
        drawengshadowtext(@menuengstring[i][1], x + 73, y + 2 + 22 * (i - menutop), colcolor($5), colcolor($7));
    end;
  SDL_UpdateRect2(screen, x, y, w + 2, maxshow * 22 + 8);
end;

procedure ShowCommonScrollMenu(x, y, w, max, maxshow, menu, menutop: integer;
  menustring, menuengstring: array of WideString);
var
  i, p: integer;
begin
  //{$IFDEF DARWIN}
  RegionRect.x := x;
  RegionRect.y := y;
  RegionRect.w := w + 1;
  RegionRect.h := maxshow * 22 + 29;
  //{$ENDIF}
  redraw;
  //{$IFDEF DARWIN}
  RegionRect.w := 0;
  RegionRect.h := 0;
  //{$ENDIF}
  //showmessage(inttostr(y));
  if max + 1 < maxshow then
    maxshow := max + 1;
  DrawRectangle(x, y, w, maxshow * 22 + 6, 0, colcolor(255), 30);
  if (length(Menuengstring) > 0) and (length(Menustring) = length(Menuengstring)) then
    p := 1
  else
    p := 0;
  for i := menutop to menutop + maxshow - 1 do
    if (i = menu) and (i < length(menustring)) then
    begin
      drawshadowtext(@menustring[i][1], x - 17, y + 2 + 22 * (i - menutop), colcolor($66), colcolor($64));
      if p = 1 then
        drawengshadowtext(@menuengstring[i][1], x + 93, y + 2 + 22 * (i - menutop), colcolor($66), colcolor($64));
    end
    else
    begin
      drawshadowtext(@menustring[i][1], x - 17, y + 2 + 22 * (i - menutop), colcolor($7), colcolor($5));
      if p = 1 then
        drawengshadowtext(@menuengstring[i][1], x + 93, y + 2 + 22 * (i - menutop), colcolor($7), colcolor($5));
    end;

end;

//仅有两个选项的横排选单, 为美观使用横排
//此类选单中每个选项限制为两个中文字, 仅适用于提问'继续', '取消'的情况

function CommonMenu2(x, y, w: integer): integer;
var
  menu, menup: integer;
begin
  menu := 0;
  //SDL_EnableKeyRepeat(0,10);
  //DrawMMap;
  SDL_EnableKeyRepeat(20, 100);
  showcommonMenu2(x, y, w, menu);
  SDL_UpdateRect2(screen, x, y, w + 1, 29);
  while (SDL_WaitEvent(@event) >= 0) do
  begin
    CheckBasicEvent;
    case event.type_ of
      SDL_KEYDOWN:
      begin
        if (event.key.keysym.sym = sdlk_left) or (event.key.keysym.sym = sdlk_right) then
        begin
          if menu = 1 then
            menu := 0
          else
            menu := 1;
          showcommonMenu2(x, y, w, menu);
          SDL_UpdateRect2(screen, x, y, w + 1, 29);
        end;
      end;
      SDL_KEYUP:
      begin
        if ((event.key.keysym.sym = sdlk_escape)) and (where <= 2) then
        begin
          Result := -1;
          ReDraw;
          SDL_UpdateRect2(screen, x, y, w + 1, 29);
          break;
        end;
        if (event.key.keysym.sym = sdlk_return) or (event.key.keysym.sym = sdlk_space) then
        begin
          Result := menu;
          Redraw;
          SDL_UpdateRect2(screen, x, y, w + 1, 29);
          break;
        end;
      end;
      SDL_MOUSEBUTTONUP:
      begin
        if (event.button.button = sdl_button_right) and (where <= 2) then
        begin
          Result := -1;
          ReDraw;
          SDL_UpdateRect2(screen, x, y, w + 1, 29);
          break;
        end;
        if (event.button.button = sdl_button_left) then
        begin
          if (round(event.button.x / (RealScreen.w / screen.w)) >= x) and
            (round(event.button.x / (RealScreen.w / screen.w)) < x + w) and
            (round(event.button.y / (RealScreen.h / screen.h)) > y) and
            (round(event.button.y / (RealScreen.h / screen.h)) < y + 29) then
          begin
            if menu > -1 then
            begin
              Result := menu;
              Redraw;
              SDL_UpdateRect2(screen, x, y, w + 1, 29);
              break;
            end;
          end;
        end;
      end;
      SDL_MOUSEMOTION:
      begin
        if (round(event.button.x / (RealScreen.w / screen.w)) >= x) and
          (round(event.button.x / (RealScreen.w / screen.w)) < x + w) and
          (round(event.button.y / (RealScreen.h / screen.h)) > y) and
          (round(event.button.y / (RealScreen.h / screen.h)) < y + 29) then
        begin
          menup := menu;
          menu := (round(event.button.x / (RealScreen.w / screen.w)) - x - 2) div 50;
          if menu > 1 then
            menu := 1;
          if menu < 0 then
            menu := 0;
          if menup <> menu then
          begin
            showcommonMenu2(x, y, w, menu);
            SDL_UpdateRect2(screen, x, y, w + 1, 29);
          end;
        end
        else
          menu := -1;
      end;
    end;
  end;
  //清空键盘键和鼠标键值, 避免影响其余部分
  event.key.keysym.sym := 0;
  event.button.button := 0;
  SDL_EnableKeyRepeat(30, 30);

end;

//显示仅有两个选项的横排选单

procedure ShowCommonMenu2(x, y, w, menu: integer);
var
  i, p: integer;
begin
  //{$IFDEF DARWIN}
  RegionRect.x := x;
  RegionRect.y := y;
  RegionRect.w := w + 1;
  RegionRect.h := 29;
  //{$ENDIF}
  redraw;
  //{$IFDEF DARWIN}
  RegionRect.w := 0;
  RegionRect.h := 0;
  //{$ENDIF}
  DrawRectangle(x, y, w, 28, 0, colcolor(255), 30);
  //if length(Menuengstring) > 0 then p := 1 else p := 0;
  for i := 0 to 1 do
    if i = menu then
    begin
      drawshadowtext(@menustring[i][1], x - 17 + i * 50, y + 2, colcolor($64), colcolor($66));
    end
    else
    begin
      drawshadowtext(@menustring[i][1], x - 17 + i * 50, y + 2, colcolor($5), colcolor($7));
    end;

end;

//仅有两个选项的横排选单, 为美观使用横排
//此类选单中每个选项限制为两个中文字, 仅适用于提问'继续', '取消'的情况

function CommonMenu2(x, y, w: integer; menustring: array of WideString): integer;
var
  menu, menup: integer;
begin
  menu := 0;
  //SDL_EnableKeyRepeat(0,10);
  //DrawMMap;
  showcommonMenu2(x, y, w, menu, menustring);
  SDL_UpdateRect2(screen, x, y, w + 1, 29);
  while (SDL_WaitEvent(@event) >= 0) do
  begin
    CheckBasicEvent;
    case event.type_ of
      SDL_KEYUP:
      begin
        if (event.key.keysym.sym = sdlk_left) or (event.key.keysym.sym = sdlk_right) then
        begin
          if menu = 1 then
            menu := 0
          else
            menu := 1;
          showcommonMenu2(x, y, w, menu, menustring);
          SDL_UpdateRect2(screen, x, y, w + 1, 29);
        end;
        if ((event.key.keysym.sym = sdlk_escape)) and (where <= 2) then
        begin
          Result := -1;
          ReDraw;
          SDL_UpdateRect2(screen, x, y, w + 1, 29);
          break;
        end;
        if (event.key.keysym.sym = sdlk_return) or (event.key.keysym.sym = sdlk_space) then
        begin
          Result := menu;
          Redraw;
          SDL_UpdateRect2(screen, x, y, w + 1, 29);
          break;
        end;
      end;
      SDL_MOUSEBUTTONUP:
      begin
        if (event.button.button = sdl_button_right) and (where <= 2) then
        begin
          Result := -1;
          ReDraw;
          SDL_UpdateRect2(screen, x, y, w + 1, 29);
          break;
        end;
        if (event.button.button = sdl_button_left) then
        begin
          if (round(event.button.x / (RealScreen.w / screen.w)) >= x) and
            (round(event.button.x / (RealScreen.w / screen.w)) < x + w) and
            (round(event.button.y / (RealScreen.h / screen.h)) > y) and
            (round(event.button.y / (RealScreen.h / screen.h)) < y + 29) then
          begin
            Result := menu;
            Redraw;
            SDL_UpdateRect2(screen, x, y, w + 1, 29);
            break;
          end;
        end;
      end;
      SDL_MOUSEMOTION:
      begin
        if (round(event.button.x / (RealScreen.w / screen.w)) >= x) and
          (round(event.button.x / (RealScreen.w / screen.w)) < x + w) and
          (round(event.button.y / (RealScreen.h / screen.h)) > y) and
          (round(event.button.y / (RealScreen.h / screen.h)) < y + 29) then
        begin
          menup := menu;
          menu := (round(event.button.x / (RealScreen.w / screen.w)) - x - 2) div 50;
          if menu > 1 then
            menu := 1;
          if menu < 0 then
            menu := 0;
          if menup <> menu then
          begin
            showcommonMenu2(x, y, w, menu, menustring);
            SDL_UpdateRect2(screen, x, y, w + 1, 29);
          end;
        end;
      end;
    end;
  end;
  //清空键盘键和鼠标键值, 避免影响其余部分
  event.key.keysym.sym := 0;
  event.button.button := 0;

end;

//显示仅有两个选项的横排选单

procedure ShowCommonMenu2(x, y, w, menu: integer; menustring: array of WideString);
var
  i, p: integer;
begin
  //{$IFDEF DARWIN}
  RegionRect.x := x;
  RegionRect.y := y;
  RegionRect.w := w + 1;
  RegionRect.h := 29;
  //{$ENDIF}
  redraw;
  //{$IFDEF DARWIN}
  RegionRect.w := 0;
  RegionRect.h := 0;
  //{$ENDIF}

  DrawRectangle(x, y, w, 28, 0, colcolor(255), 30);
  //if length(Menuengstring) > 0 then p := 1 else p := 0;
  for i := 0 to 1 do
    if i = menu then
    begin
      drawshadowtext(@menustring[i][1], x - 17 + i * 50, y + 2, colcolor($66), colcolor($64));
    end
    else
    begin
      drawshadowtext(@menustring[i][1], x - 17 + i * 50, y + 2, colcolor($7), colcolor($5));
    end;

end;

//选择一名队员, 可以附带两个属性显示

function SelectOneTeamMember(x, y: integer; str: string; list1, list2: integer): integer;
var
  i, amount: integer;
begin
  setlength(Menustring, 6);
  if str <> '' then
    setlength(Menuengstring, 6)
  else
    setlength(Menuengstring, 0);
  amount := 0;

  for i := 0 to 5 do
  begin
    if Teamlist[i] >= 0 then
    begin
      menustring[i] := Big5toUnicode(@RRole[Teamlist[i]].Name);
      if str <> '' then
      begin
        menuengstring[i] := format(str, [Rrole[teamlist[i]].Data[list1], Rrole[teamlist[i]].Data[list2]]);
      end;
      amount := amount + 1;
    end;
  end;
  if str = '' then
    Result := commonmenu(x, y, 105, amount - 1)
  else
    Result := commonmenu(x, y, 105 + length(menuengstring[0]) * 10, amount - 1);

end;

//主选单

procedure MenuEsc;
var
  menu, menup: integer;
begin
  menu := 0;
  SDL_EnableKeyRepeat(20, 100);
  //DrawMMap;
  //showmessage(inttostr(where));
  showMenu(menu);
  //SDL_EventState(SDL_KEYDOWN,SDL_IGNORE);
  while (SDL_WaitEvent(@event) >= 0) do
  begin
    if where >= 3 then
    begin
      break;
    end;
    CheckBasicEvent;
    case event.type_ of
      SDL_KEYDOWN:
      begin
        if (event.key.keysym.sym = sdlk_down) then
        begin
          menu := menu + 1;
          //if menu > 4 - where then
          if menu > 4 then
            menu := 0;
          showMenu(menu);
        end;
        if (event.key.keysym.sym = sdlk_up) then
        begin
          menu := menu - 1;
          if menu < 0 then
            menu := 4;
          //menu := 4 - where;
          showMenu(menu);
        end;
      end;

      SDL_KEYUP:
      begin
        if (event.key.keysym.sym = sdlk_escape) then
        begin
          ReDraw;
          SDL_UpdateRect2(screen, 0, 0, screen.w, screen.h);
          break;
        end;
        if (event.key.keysym.sym = sdlk_return) or (event.key.keysym.sym = sdlk_space) then
        begin
          case menu of
            0: MenuMedcine;
            1: MenuMedPoision;
            2: MenuItem;
            4: MenuSystem;
            //4: MenuLeave;
            3: MenuStatus;
          end;
          SDL_EnableKeyRepeat(20, 100);
          if where >= 3 then
            break;
          showmenu(menu);
        end;
      end;
      SDL_MOUSEBUTTONUP:
      begin
        if event.button.button = sdl_button_right then
        begin
          ReDraw;
          SDL_UpdateRect2(screen, 0, 0, screen.w, screen.h);
          break;
        end;
        if event.button.button = sdl_button_left then
        begin
          //if (round(event.button.y / (RealScreen.h / screen.h)) > 32) and (round(event.button.y / (RealScreen.h / screen.h)) < 32 + 22 * (6 - where * 2)) and (round(event.button.x / (RealScreen.w / screen.w)) > 27) and (round(event.button.x / (RealScreen.w / screen.w)) < 27 + 46) then
          if (round(event.button.y / (RealScreen.h / screen.h)) > 32) and
            (round(event.button.y / (RealScreen.h / screen.h)) < 32 + 22 * 6) and
            (round(event.button.x / (RealScreen.w / screen.w)) > 27) and
            (round(event.button.x / (RealScreen.w / screen.w)) < 27 + 46) then
          begin
            showmenu(menu);
            //showmessage(inttostr(menu));
            case menu of
              0: MenuMedcine;
              1: MenuMedPoision;
              2: MenuItem;
              4: MenuSystem;
              //4: MenuLeave;
              3: MenuStatus;
            end;
            SDL_EnableKeyRepeat(20, 100);
            if where >= 3 then
              break;
            showmenu(menu);
          end;
        end;
      end;
      SDL_MOUSEMOTION:
      begin
        if (round(event.button.y / (RealScreen.h / screen.h)) > 32) and
          (round(event.button.y / (RealScreen.h / screen.h)) < 32 + 22 * 6) and
          (round(event.button.x / (RealScreen.w / screen.w)) > 27) and
          (round(event.button.x / (RealScreen.w / screen.w)) < 27 + 46) then
        begin
          menup := menu;
          menu := (round(event.button.y / (RealScreen.h / screen.h)) - 32) div 22;
          if menu > 5 then
            menu := 5;
          if menu < 0 then
            menu := 0;
          if menup <> menu then
            showmenu(menu);
        end
        else
          menu := -1;
      end;
    end;
  end;
  event.key.keysym.sym := 0;
  event.button.button := 0;
  SDL_EnableKeyRepeat(30, 30);

end;

//显示主选单

procedure ShowMenu(menu: integer);
var
  word: array[0..5] of WideString;
  i, max: integer;
begin
  word[0] := ' 醫療';
  word[1] := ' 解毒';
  word[2] := ' 物品';
  word[3] := ' 狀態';
  //Word[4] := ' 離隊';
  word[4] := ' 系統';
  if where = 0 then
    max := 4
  else
    max := 4;
  ReDraw;
  DrawRectangle(27, 30, 48, max * 22 + 28, 0, colcolor(255), 30);
  //当前所在位置用白色, 其余用黄色
  for i := 0 to max do
    if i = menu then
    begin
      drawshadowtext(@word[i][1], 11, 32 + 22 * i, colcolor($64), colcolor($66));
    end
    else
    begin
      drawshadowtext(@word[i][1], 11, 32 + 22 * i, colcolor($5), colcolor($7));
    end;
  SDL_UpdateRect2(screen, 0, 0, screen.w, screen.h);

end;

//医疗选单, 需两次选择队员

procedure MenuMedcine;
var
  role1, role2, menu: integer;
  str: WideString;
begin
  str := ' 隊員醫療能力';
  drawtextwithrect(@str[1], 80, 30, 132, colcolor($21), colcolor($23));
  menu := SelectOneTeamMember(80, 65, '%3d', 46, 0);
  showmenu(0);
  SDL_UpdateRect2(screen, 0, 0, screen.w, screen.h);
  if menu >= 0 then
  begin
    role1 := TeamList[menu];
    str := ' 隊員目前生命';
    drawtextwithrect(@str[1], 80, 30, 132, colcolor($21), colcolor($23));
    menu := SelectOneTeamMember(80, 65, '%4d/%4d', 17, 18);
    role2 := TeamList[menu];
    if menu >= 0 then
      EffectMedcine(role1, role2);
  end;
  //waitanykey;
  redraw;
  //SDL_UpdateRect2(screen,0,0,screen.w,screen.h);

end;

//解毒选单

procedure MenuMedPoision;
var
  role1, role2, menu: integer;
  str: WideString;
begin
  str := ' 隊員解毒能力';
  drawtextwithrect(@str[1], 80, 30, 132, colcolor($21), colcolor($23));
  menu := SelectOneTeamMember(80, 65, '%3d', 48, 0);
  showmenu(1);
  SDL_UpdateRect2(screen, 0, 0, screen.w, screen.h);
  if menu >= 0 then
  begin
    role1 := TeamList[menu];
    str := ' 隊員中毒程度';
    drawtextwithrect(@str[1], 80, 30, 132, colcolor($21), colcolor($23));
    menu := SelectOneTeamMember(80, 65, '%3d', 20, 0);
    role2 := TeamList[menu];
    if menu >= 0 then
      EffectMedPoision(role1, role2);
  end;
  //waitanykey;
  redraw;
  //showmenu(1);
  //SDL_UpdateRect2(screen,0,0,screen.w,screen.h);

end;

//物品选单

function MenuItem: boolean;
var
  point, atlu, x, y, col, row, xp, yp, iamount, menu, max, xm, ym, i: integer;
  //point似乎未使用, atlu为处于左上角的物品在列表中的序号, x, y为光标位置
  //col, row为总列数和行数
  menustring: array of WideString;
begin
  col := 9;
  row := 4;
  x := 0;
  y := 0;
  atlu := 0;
  setlength(Menuengstring, 0);
  case where of
    0, 1:
    begin
      max := 5;
      setlength(menustring, max + 1);
      menustring[0] := (' 全部物品');
      menustring[1] := (' 劇情物品');
      menustring[2] := (' 神兵寶甲');
      menustring[3] := (' 武功秘笈');
      menustring[4] := (' 靈丹妙藥');
      menustring[5] := (' 傷人暗器');
      xm := 80;
      ym := 30;

    end;
    2:
    begin
      max := 1;
      setlength(menustring, max + 1);
      menustring[0] := (' 靈丹妙藥');
      menustring[1] := (' 傷人暗器');
      xm := 150;
      ym := 150;

    end;
  end;

  menu := 0;
  while menu >= 0 do
  begin
    menu := commonmenu(xm, ym, 87, max, menu, menustring);

    case where of
      0, 1:
      begin
        if menu = 0 then
          i := 100
        else
          i := menu - 1;

      end;
      2:
      begin
        if menu >= 0 then
          i := menu + 3;
      end;
    end;

    if menu < 0 then
      Result := False;

    if (menu >= 0) and (menu < 6) then
    begin
      iamount := ReadItemList(i);
      showMenuItem(row, col, x, y, atlu);
      SDL_UpdateRect2(screen, 0, 0, screen.w, screen.h);
      while (SDL_WaitEvent(@event) >= 0) do
      begin
        CheckBasicEvent;
        case event.type_ of
          SDL_KEYUP:
          begin
            if (event.key.keysym.sym = sdlk_down) then
            begin
              y := y + 1;
              if y < 0 then
                y := 0;
              if (y >= row) then
              begin
                if (ItemList[atlu + col * row] >= 0) then
                  atlu := atlu + col;
                y := row - 1;
              end;
              showMenuItem(row, col, x, y, atlu);
              SDL_UpdateRect2(screen, 0, 0, screen.w, screen.h);
            end;
            if (event.key.keysym.sym = sdlk_up) then
            begin
              y := y - 1;
              if y < 0 then
              begin
                y := 0;
                if atlu > 0 then
                  atlu := atlu - col;
              end;
              showMenuItem(row, col, x, y, atlu);
              SDL_UpdateRect2(screen, 0, 0, screen.w, screen.h);
            end;
            if (event.key.keysym.sym = sdlk_pagedown) then
            begin
              //y := y + row;
              if (iamount > col * row) then
              begin
                atlu := atlu + col * row;
                if y < 0 then
                  y := 0;
                if (ItemList[atlu + col * row] < 0) then
                begin
                  y := y - (iamount - atlu) div col - 1 + row;
                  atlu := (iamount div col - row + 1) * col;
                  if y >= row then
                    y := row - 1;
                end;
              end
              else
                y := iamount div col;
              showMenuItem(row, col, x, y, atlu);
              SDL_UpdateRect2(screen, 0, 0, screen.w, screen.h);
            end;

            if (event.key.keysym.sym = sdlk_pageup) then
            begin
              //y := y - row;
              atlu := atlu - col * row;
              if atlu < 0 then
              begin
                y := y + atlu div col;
                atlu := 0;
                if y < 0 then
                  y := 0;
              end;
              showMenuItem(row, col, x, y, atlu);
              SDL_UpdateRect2(screen, 0, 0, screen.w, screen.h);
            end;
            if (event.key.keysym.sym = sdlk_right) then
            begin
              x := x + 1;
              if x >= col then
                x := 0;
              showMenuItem(row, col, x, y, atlu);
              SDL_UpdateRect2(screen, 0, 0, screen.w, screen.h);
            end;
            if (event.key.keysym.sym = sdlk_left) then
            begin
              x := x - 1;
              if x < 0 then
                x := col - 1;
              showMenuItem(row, col, x, y, atlu);
              SDL_UpdateRect2(screen, 0, 0, screen.w, screen.h);
            end;
            if (event.key.keysym.sym = sdlk_escape) then
            begin
              ReDraw;
              //ShowMenu(2);
              Result := False;
              SDL_UpdateRect2(screen, 0, 0, screen.w, screen.h);
              break;
            end;
            if (event.key.keysym.sym = sdlk_return) or (event.key.keysym.sym = sdlk_space) then
            begin
              ReDraw;
              CurItem := RItemlist[itemlist[(y * col + x + atlu)]].Number;
              if (where <> 2) and (CurItem >= 0) and (itemlist[(y * col + x + atlu)] >= 0) then
                UseItem(CurItem);
              //ShowMenu(2);
              Result := True;
              SDL_UpdateRect2(screen, 0, 0, screen.w, screen.h);
              break;
            end;
          end;
          SDL_MOUSEBUTTONUP:
          begin
            if (event.button.button = sdl_button_right) then
            begin
              ReDraw;
              //ShowMenu(2);
              Result := False;
              SDL_UpdateRect2(screen, 0, 0, screen.w, screen.h);
              break;
            end;
            if (event.button.button = sdl_button_left) then
            begin
              if (round(event.button.x / (RealScreen.w / screen.w)) >= 65) and
                (round(event.button.x / (RealScreen.w / screen.w)) < 541) and
                (round(event.button.y / (RealScreen.h / screen.h)) > 90) and
                (round(event.button.y / (RealScreen.h / screen.h)) < 358) then
              begin
                ReDraw;
                CurItem := RItemlist[itemlist[(y * col + x + atlu)]].Number;
                if (where <> 2) and (CurItem >= 0) and (itemlist[(y * col + x + atlu)] >= 0) then
                  UseItem(CurItem);
                //ShowMenu(2);
                Result := True;
                SDL_UpdateRect2(screen, 0, 0, screen.w, screen.h);
                break;
              end;
            end;
            if (event.button.button = sdl_button_wheeldown) then
            begin
              y := y + 1;
              if y < 0 then
                y := 0;
              if (y >= row) then
              begin
                if (ItemList[atlu + col * 5] >= 0) then
                  atlu := atlu + col;
                y := row - 1;
              end;
              showMenuItem(row, col, x, y, atlu);
              SDL_UpdateRect2(screen, 0, 0, screen.w, screen.h);
            end;
            if (event.button.button = sdl_button_wheelup) then
            begin
              y := y - 1;
              if y < 0 then
              begin
                y := 0;
                if atlu > 0 then
                  atlu := atlu - col;
              end;
              showMenuItem(row, col, x, y, atlu);
              SDL_UpdateRect2(screen, 0, 0, screen.w, screen.h);
            end;
          end;
          SDL_MOUSEMOTION:
          begin
            if (round(event.button.x / (RealScreen.w / screen.w)) >= 65) and
              (round(event.button.x / (RealScreen.w / screen.w)) < 541) and
              (round(event.button.y / (RealScreen.h / screen.h)) > 90) and
              (round(event.button.y / (RealScreen.h / screen.h)) < 358) then
            begin
              xp := x;
              yp := y;
              x := (round(event.button.x / (RealScreen.w / screen.w)) - 70) div 52;
              y := (round(event.button.y / (RealScreen.h / screen.h)) - 95) div 52;
              if x >= col then
                x := col - 1;
              if y >= row then
                y := row - 1;
              if x < 0 then
                x := 0;
              if y < 0 then
                y := 0;
              //鼠标移动时仅在x, y发生变化时才重画
              if (x <> xp) or (y <> yp) then
              begin
                showMenuItem(row, col, x, y, atlu);
                SDL_UpdateRect2(screen, 0, 0, screen.w, screen.h);
              end;
            end;
            if (round(event.button.x / (RealScreen.w / screen.w)) >= 65) and
              (round(event.button.x / (RealScreen.w / screen.w)) < 541) and
              (round(event.button.y / (RealScreen.h / screen.h)) > 358) then
            begin
              //atlu := atlu+col;
              if (ItemList[atlu + col * 5] >= 0) then
                atlu := atlu + col;
              showMenuItem(row, col, x, y, atlu);
              SDL_UpdateRect2(screen, 0, 0, screen.w, screen.h);
            end;
            if (round(event.button.x / (RealScreen.w / screen.w)) >= 65) and
              (round(event.button.x / (RealScreen.w / screen.w)) < 541) and
              (round(event.button.y / (RealScreen.h / screen.h)) < 90) then
            begin
              if atlu > 0 then
                atlu := atlu - col;
              showMenuItem(row, col, x, y, atlu);
              SDL_UpdateRect2(screen, 0, 0, screen.w, screen.h);
            end;
          end;
        end;
      end;
    end;
    if where = 2 then
      break;
    ShowMenu(2);
  end;
  //SDL_UpdateRect2(screen,0,0,screen.w,screen.h);

end;

//读物品列表, 主要是战斗中需屏蔽一部分物品
//利用一个不可能用到的数值（100），表示读取所有物品

function ReadItemList(ItemType: integer): integer;
var
  i, p: integer;
begin
  p := 0;
  for i := 0 to length(ItemList) - 1 do
    ItemList[i] := -1;
  for i := 0 to MAX_ITEM_AMOUNT - 1 do
  begin
    if (RItemlist[i].Number >= 0) then
    begin
      if (Ritem[RItemlist[i].Number].ItemType = ItemType) or (ItemType = 100) then
      begin
        Itemlist[p] := i;
        p := p + 1;
      end;
      if (RItemlist[i].Number = MONEY_ID) and (where = 2) and (ItemType = 4) then
      begin
        Itemlist[p] := i;
        p := p + 1;
      end;
    end;
  end;
  Result := p;

end;

//显示物品选单

procedure ShowMenuItem(row, col, x, y, atlu: integer);
var
  item, i, i1, i2, len, len2, len3, listnum: integer;
  str: WideString;
  words: array[0..10] of WideString;
  words2: array[0..22] of WideString;
  words3: array[0..12] of WideString;
  p2: array[0..22] of integer;
  p3: array[0..12] of integer;
  bscreen: boolean;
begin
  words[0] := ' 劇情物品';
  words[1] := ' 神兵寶甲';
  words[2] := ' 武功秘笈';
  words[3] := ' 靈丹妙藥';
  words[4] := ' 傷人暗器';
  words2[0] := ' 生命';
  words2[1] := ' 生命';
  words2[2] := ' 中毒';
  words2[3] := ' 體力';
  words2[4] := ' 內力';
  words2[5] := ' 內力';
  words2[6] := ' 內力';
  words2[7] := ' 攻擊';
  words2[8] := ' 輕功';
  words2[9] := ' 防禦';
  words2[10] := ' 醫療';
  words2[11] := ' 用毒';
  words2[12] := ' 解毒';
  words2[13] := ' 抗毒';
  words2[14] := ' 拳掌';
  words2[15] := ' 御劍';
  words2[16] := ' 耍刀';
  words2[17] := ' 特殊';
  words2[18] := ' 暗器';
  words2[19] := ' 武學';
  words2[20] := ' 品德';
  words2[21] := ' 移動';
  words2[22] := ' 帶毒';

  words3[0] := ' 內力';
  words3[1] := ' 內力';
  words3[2] := ' 攻擊';
  words3[3] := ' 輕功';
  words3[4] := ' 用毒';
  words3[5] := ' 醫療';
  words3[6] := ' 解毒';
  words3[7] := ' 拳掌';
  words3[8] := ' 御劍';
  words3[9] := ' 耍刀';
  words3[10] := ' 特殊';
  words3[11] := ' 暗器';
  words3[12] := ' 資質';

  ReDraw;
  bscreen := showblackscreen;
  if showblackscreen = True then
    showblackscreen := False;

  drawrectangle(65, 30, 476, 25, 0, colcolor(255), 30);
  drawrectangle(65, 60, 476, 25, 0, colcolor(255), 30);
  drawrectangle(65, 90, 476, 50 * row + 18, 0, colcolor(255), 30);
  drawrectangle(65, 50 * row + 113, 476, 25, 0, colcolor(255), 30);
  //i:=0;
  for i1 := 0 to row - 1 do
    for i2 := 0 to col - 1 do
    begin
      listnum := ItemList[i1 * col + i2 + atlu];
      if (RItemlist[listnum].Number >= 0) and (listnum < MAX_ITEM_AMOUNT) and (listnum >= 0) then
      begin
        DrawMPic(ITEM_BEGIN_PIC + RItemlist[listnum].Number, i2 * 52 + 70, i1 * 52 + 95);
      end;
    end;
  listnum := itemlist[y * col + x + atlu];
  if (listnum >= 0) and (listnum < MAX_ITEM_AMOUNT) then
    item := RItemlist[listnum].Number
  else
    item := -1;

  if (RItemlist[listnum].Amount > 0) and (listnum < MAX_ITEM_AMOUNT) and (listnum >= 0) then
  begin
    str := format('%5d', [RItemlist[listnum].Amount]);
    drawengtext(screen, @str[1], 431, 32, colcolor($64));
    drawengtext(screen, @str[1], 430, 32, colcolor($66));
    len := length(PChar(@Ritem[item].Name));
    drawbig5text(screen, @RItem[item].Name, 296 - len * 5, 32, colcolor($21));
    drawbig5text(screen, @RItem[item].Name, 295 - len * 5, 32, colcolor($23));
    len := length(PChar(@Ritem[item].Introduction));
    drawbig5text(screen, @RItem[item].Introduction, 296 - len * 5, 62, colcolor($5));
    drawbig5text(screen, @RItem[item].Introduction, 295 - len * 5, 62, colcolor($7));
    drawshadowtext(@words[Ritem[item].ItemType, 1], 52, 115 + row * 50, colcolor($21), colcolor($23));
    //如有人使用则显示
    if RItem[item].User >= 0 then
    begin
      str := ' 使用人：';
      drawshadowtext(@str[1], 142, 115 + row * 50, colcolor($21), colcolor($23));
      drawbig5shadowtext(@rrole[RItem[item].User].Name, 232, 115 + row * 50, colcolor($64), colcolor($66));
    end;
    //如是罗盘则显示坐标
    if item = COMPASS_ID then
    begin
      str := ' 你的位置：';
      drawshadowtext(@str[1], 142, 115 + row * 50, colcolor($21), colcolor($23));
      str := format('%3d, %3d', [My, Mx]);
      drawengshadowtext(@str[1], 262, 115 + row * 50, colcolor($64), colcolor($66));

      str := ' 船的位置：';
      drawshadowtext(@str[1], 322, 115 + row * 50, colcolor($21), colcolor($23));
      str := format('%3d, %3d', [Shipx, shipy]);
      drawengshadowtext(@str[1], 442, 115 + row * 50, colcolor($64), colcolor($66));
    end;
  end;

  if (item >= 0) and (ritem[item].ItemType > 0) then
  begin
    len2 := 0;
    for i := 0 to 22 do
    begin
      p2[i] := 0;
      if (ritem[item].Data[45 + i] <> 0) and (i <> 4) then
      begin
        p2[i] := 1;
        len2 := len2 + 1;
      end;
    end;
    if ritem[item].ChangeMPType = 2 then
    begin
      p2[4] := 1;
      len2 := len2 + 1;
    end;

    len3 := 0;
    for i := 0 to 12 do
    begin
      p3[i] := 0;
      if (ritem[item].Data[69 + i] <> 0) and (i <> 0) then
      begin
        p3[i] := 1;
        len3 := len3 + 1;
      end;
    end;
    if (ritem[item].NeedMPType in [0, 1]) and (ritem[item].ItemType <> 3) then
    begin
      p3[0] := 1;
      len3 := len3 + 1;
    end;

    if len2 + len3 > 0 then
      drawrectangle(65, 144 + row * 50, 476, 20 * ((len2 + 2) div 3 + (len3 + 2) div 3) + 5, 0, colcolor(255), 30);

    i1 := 0;
    for i := 0 to 22 do
    begin
      if (p2[i] = 1) then
      begin
        str := format('%6d', [ritem[item].Data[45 + i]]);
        if i = 4 then
          case ritem[item].ChangeMPType of
            0: str := '    陰';
            1: str := '    陽';
            2: str := '  調和';
          end;

        drawshadowtext(@words2[i][1], 52 + i1 mod 3 * 130, i1 div 3 * 20 + 146 + row * 50, colcolor(5), colcolor(7));
        drawshadowtext(@str[1], 102 + i1 mod 3 * 130, i1 div 3 * 20 + 146 + row * 50, colcolor($64), colcolor($66));
        i1 := i1 + 1;
      end;
    end;

    i1 := 0;
    for i := 0 to 12 do
    begin
      if (p3[i] = 1) then
      begin
        str := format('%6d', [ritem[item].Data[69 + i]]);
        if i = 0 then
          case ritem[item].NeedMPType of
            0: str := '    陰';
            1: str := '    陽';
            2: str := '  調和';
          end;

        drawshadowtext(@words3[i][1], 52 + i1 mod 3 * 130, ((len2 + 2) div 3 + i1 div 3) *
          20 + 146 + row * 50, colcolor($50), colcolor($4E));
        drawshadowtext(@str[1], 102 + i1 mod 3 * 130, ((len2 + 2) div 3 + i1 div 3) * 20 +
          146 + row * 50, colcolor($64), colcolor($66));
        i1 := i1 + 1;
      end;
    end;
  end;

  drawItemframe(x, y);
  showblackscreen := bscreen;

end;


//画白色边框作为物品选单的光标

procedure DrawItemFrame(x, y: integer);
var
  i: integer;
begin
  for i := 0 to 49 do
  begin
    putpixel(screen, x * 52 + 71 + i, y * 52 + 96, colcolor(255));
    putpixel(screen, x * 52 + 71 + i, y * 52 + 96 + 49, colcolor(255));
    putpixel(screen, x * 52 + 71, y * 52 + 96 + i, colcolor(255));
    putpixel(screen, x * 52 + 71 + 49, y * 52 + 96 + i, colcolor(255));
  end;

end;

//使用物品

procedure UseItem(inum: integer);
var
  x, y, menu, rnum, p: integer;
  str, str1: WideString;
begin
  CurItem := inum;

  case RItem[inum].ItemType of
    0: //剧情物品
    begin
      //如某属性大于0, 直接调用事件
      if ritem[inum].UnKnow7 > 0 then
        callevent(ritem[inum].UnKnow7)
      else
      begin
        if where = 1 then
        begin
          x := Sx;
          y := Sy;
          case SFace of
            0: x := x - 1;
            1: y := y + 1;
            2: y := y - 1;
            3: x := x + 1;
          end;
          //如面向位置有第2类事件则调用
          if SData[CurScence, 3, x, y] >= 0 then
          begin
            CurEvent := SData[CurScence, 3, x, y];
            if DData[CurScence, SData[CurScence, 3, x, y], 3] >= 0 then
              callevent(DData[CurScence, SData[CurScence, 3, x, y], 3]);
          end;
          CurEvent := -1;
        end;
      end;
    end;
    1: //装备
    begin
      menu := 1;
      if Ritem[inum].User >= 0 then
      begin
        setlength(menustring, 2);
        menustring[0] := ' 取消';
        menustring[1] := ' 繼續';
        str := ' 此物品正有人裝備，是否繼續？';
        drawtextwithrect(@str[1], 80, 30, 285, colcolor(7), colcolor(5));
        menu := commonmenu(80, 65, 45, 1);
      end;
      if menu = 1 then
      begin
        str := ' 誰要裝備';
        str1 := big5tounicode(@Ritem[inum].Name);
        drawtextwithrect(@str[1], 80, 30, length(str1) * 22 + 80, colcolor($21), colcolor($23));
        drawshadowtext(@str1[1], 160, 32, colcolor($64), colcolor($66));
        SDL_UpdateRect2(screen, 0, 0, screen.w, screen.h);
        menu := SelectOneTeamMember(80, 65, '', 0, 0);
        if menu >= 0 then
        begin
          rnum := Teamlist[menu];
          p := Ritem[inum].EquipType;
          if (p < 0) or (p > 1) then
            p := 0;
          if canequip(rnum, inum) then
          begin
            if Ritem[inum].User >= 0 then
              Rrole[Ritem[inum].User].Equip[p] := -1;
            if Rrole[rnum].Equip[p] >= 0 then
              Ritem[RRole[rnum].Equip[p]].User := -1;
            Rrole[rnum].Equip[p] := inum;
            Ritem[inum].User := rnum;
          end
          else
          begin
            str := ' 此人不適合裝備此物品';
            drawtextwithrect(@str[1], 80, 30, 205, colcolor($64), colcolor($66));
            waitanykey;
            redraw;
            //SDL_UpdateRect2(screen,0,0,screen.w,screen.h);
          end;
        end;
      end;
    end;
    2: //秘笈
    begin
      menu := 1;
      if Ritem[inum].User >= 0 then
      begin
        setlength(menustring, 2);
        menustring[0] := ' 取消';
        menustring[1] := ' 繼續';
        str := ' 此秘笈正有人修煉，是否繼續？';
        drawtextwithrect(@str[1], 80, 30, 285, colcolor(7), colcolor(5));
        menu := commonmenu(80, 65, 45, 1);
      end;
      if menu = 1 then
      begin
        str := ' 誰要修煉';
        str1 := big5tounicode(@Ritem[inum].Name);
        drawtextwithrect(@str[1], 80, 30, length(str1) * 22 + 80, colcolor($21), colcolor($23));
        drawshadowtext(@str1[1], 160, 32, colcolor($64), colcolor($66));
        SDL_UpdateRect2(screen, 0, 0, screen.w, screen.h);
        menu := SelectOneTeamMember(80, 65, '', 0, 0);
        if menu >= 0 then
        begin
          rnum := TeamList[menu];
          if canequip(rnum, inum) then
          begin
            if Ritem[inum].User >= 0 then
              Rrole[Ritem[inum].User].PracticeBook := -1;
            if Rrole[rnum].PracticeBook >= 0 then
              Ritem[RRole[rnum].PracticeBook].User := -1;
            Rrole[rnum].PracticeBook := inum;
            Ritem[inum].User := rnum;
            Rrole[rnum].ExpForItem := 0;
            Rrole[rnum].ExpForBook := 0;
            //if (inum in [78, 93]) then
            //  rrole[rnum].Sexual := 2;
          end
          else
          begin
            str := ' 此人不適合修煉此秘笈';
            drawtextwithrect(@str[1], 80, 30, 205, colcolor($64), colcolor($66));
            waitanykey;
            redraw;
            //SDL_UpdateRect2(screen,0,0,screen.w,screen.h);
          end;
        end;
      end;
    end;
    3: //药品
    begin
      if where <> 2 then
      begin
        str := ' 誰要服用';
        str1 := big5tounicode(@Ritem[inum].Name);
        drawtextwithrect(@str[1], 80, 30, length(str1) * 22 + 80, colcolor($21), colcolor($23));
        drawshadowtext(@str1[1], 160, 32, colcolor($64), colcolor($66));
        SDL_UpdateRect2(screen, 0, 0, screen.w, screen.h);
        menu := SelectOneTeamMember(80, 65, '', 0, 0);
        rnum := TeamList[menu];
      end;
      if menu >= 0 then
      begin
        redraw;
        EatOneItem(rnum, inum);
        instruct_32(inum, -1);
        waitanykey;
      end;
    end;
    4: //不处理暗器类物品
    begin
      //if where<>3 then break;
    end;
  end;

end;

//能否装备

function CanEquip(rnum, inum: integer): boolean;
var
  i, r: integer;
begin

  //判断是否符合
  //注意这里对'所需属性'为负值时均添加原版类似资质的处理

  Result := True;

  if sign(Ritem[inum].NeedMP) * Rrole[rnum].CurrentMP < Ritem[inum].NeedMP then
    Result := False;
  if sign(Ritem[inum].NeedAttack) * Rrole[rnum].Attack < Ritem[inum].NeedAttack then
    Result := False;
  if sign(Ritem[inum].NeedSpeed) * Rrole[rnum].Speed < Ritem[inum].NeedSpeed then
    Result := False;
  if sign(Ritem[inum].NeedUsePoi) * Rrole[rnum].UsePoi < Ritem[inum].NeedUsepoi then
    Result := False;
  if sign(Ritem[inum].NeedMedcine) * Rrole[rnum].Medcine < Ritem[inum].NeedMedcine then
    Result := False;
  if sign(Ritem[inum].NeedMedPoi) * Rrole[rnum].MedPoi < Ritem[inum].NeedMedPoi then
    Result := False;
  if sign(Ritem[inum].NeedFist) * Rrole[rnum].Fist < Ritem[inum].NeedFist then
    Result := False;
  if sign(Ritem[inum].NeedSword) * Rrole[rnum].Sword < Ritem[inum].NeedSword then
    Result := False;
  if sign(Ritem[inum].NeedKnife) * Rrole[rnum].Knife < Ritem[inum].NeedKnife then
    Result := False;
  if sign(Ritem[inum].NeedUnusual) * Rrole[rnum].Unusual < Ritem[inum].NeedUnusual then
    Result := False;
  if sign(Ritem[inum].NeedHidWeapon) * Rrole[rnum].HidWeapon < Ritem[inum].NeedHidWeapon then
    Result := False;
  if sign(Ritem[inum].NeedAptitude) * Rrole[rnum].Aptitude < Ritem[inum].NeedAptitude then
    Result := False;

  //内力性质
  if (rrole[rnum].MPType < 2) and (Ritem[inum].NeedMPType < 2) then
    if rrole[rnum].MPType <> Ritem[inum].NeedMPType then
      Result := False;

  //如有专用人物, 前面的都作废
  if (Ritem[inum].OnlyPracRole >= 0) and (Result = True) then
    if (Ritem[inum].OnlyPracRole = rnum) then
      Result := True
    else
      Result := False;



  //内功判断
  if (inum <= 171) and (inum >= 157) then
  begin
    //如已有4种内功, 且物品也能练出武功, 则结果为假
    r := 0;
    for i := 0 to 3 do
      if Rrole[rnum].neigong[i] > 0 then
        r := r + 1;
    if (r >= 4) and (ritem[inum].Magic > 0) then
      Result := False;
    //学过该内功，则为真
    for i := 0 to 3 do
      if Rrole[rnum].neigong[i] = ritem[inum].Magic then
      begin
        Result := True;
        break;
      end;
  end
  else
  begin
    //外功判断
    //如已有10种武功, 且物品也能练出武功, 则结果为假
    r := 0;
    for i := 0 to 9 do
      if Rrole[rnum].Magic[i] > 0 then
        r := r + 1;
    if (r >= 10) and (ritem[inum].Magic > 0) then
      Result := False;

    //学过该武功，则为真
    for i := 0 to 9 do
      if Rrole[rnum].Magic[i] = ritem[inum].Magic then
      begin
        Result := True;
        break;
      end;
  end;
end;

//查看状态选单

{procedure MenuStatus;
var
  str: WideString;
  menu: integer;
begin
  str := ' 查看隊員狀態';
  drawtextwithrect(@str[1], 80, 30, 132, colcolor($21), colcolor($23));
  menu := SelectOneTeamMember(80, 65, '%3d', 15, 0);
  if menu >= 0 then
  begin
    ShowStatus(TeamList[menu]);
    waitanykey;
    redraw;
    SDL_UpdateRect2(screen, 0, 0, screen.w, screen.h);
  end;

end;}

//查看状态选单

procedure MenuStatus;
var
  str: WideString;
  menu, amount, i: integer;
  menustring, menuengstring: array of WideString;
begin
  //str := (' 查看隊員狀態');
  redraw;
  SDL_UpdateRect2(screen, 0, 0, screen.w, screen.h);
  //drawtextwithrect(@str[1], 10, 30, 132, colcolor($23), colcolor($21));
  setlength(Menustring, 6);
  setlength(Menuengstring, 0);
  amount := 0;

  for i := 0 to 5 do
  begin
    if Teamlist[i] >= 0 then
    begin
      menustring[i] := Big5toUnicode(@RRole[Teamlist[i]].Name);
      amount := amount + 1;
    end;
  end;

  {menustring[0] := ' 壹';
  menustring[1] := ' 貳';
  menustring[2] := ' 叁';
  menustring[3] := ' 肆';
  menustring[4] := ' 伍';
  menustring[5] := ' 陸';}

  menu := commonmenu(8, CENTER_Y - 220, 85, amount - 1, 0, menustring, menuengstring, @ShowStatusByTeam);
  redraw;
  SDL_UpdateRect2(screen, 0, 0, screen.w, screen.h);
  //menu := SelectOneTeamMember(27, 65, '%3d', 15, 0);
  {if menu >= 0 then
  begin
    ShowStatus(TeamList[menu]);
    waitanykey;
    redraw;
    SDL_UpdateRect2(screen, 0, 0, screen.w, screen.h);
  end;}

end;

//显示状态

procedure ShowStatusByTeam(tnum: integer);
begin
  if TeamList[tnum] >= 0 then
    ShowStatus(TeamList[tnum]);
end;

//显示状态

procedure ShowStatus(rnum: integer; bnum: integer = 0);
var
  i, magicnum, mlevel, needexp, x, y, w: integer;
  p: array[0..10] of integer;
  addatk, adddef, addspeed: integer;
  str: WideString;
  strs: array[0..23] of WideString;
  strs1: array of WideString;
  color1, color2: uint32;
  Name: WideString;
begin
  strs[0] := ' 等級';
  strs[1] := ' 生命';
  strs[2] := ' 內力';
  strs[3] := ' 體力';
  strs[4] := ' 經驗';
  strs[5] := ' 升級';
  strs[6] := ' 攻擊';
  strs[7] := ' 防禦';
  strs[8] := ' 輕功';
  strs[9] := ' 移動';
  strs[10] := ' 醫療能力';
  strs[11] := ' 用毒能力';
  strs[12] := ' 解毒能力';
  strs[13] := ' 拳掌功夫';
  strs[14] := ' 御劍能力';
  strs[15] := ' 耍刀技巧';
  strs[16] := ' 特殊兵器';
  strs[17] := ' 暗器技巧';
  strs[18] := ' 裝備物品';
  strs[19] := ' 修煉物品';
  strs[20] := ' 所會武功';
  strs[21] := ' 受傷';
  strs[22] := ' 中毒';
  strs[23] := ' 所會內功';

  p[0] := 43;
  p[1] := 45;
  p[2] := 44;
  p[3] := 46;
  p[4] := 47;
  p[5] := 48;
  p[6] := 50;
  p[7] := 51;
  p[8] := 52;
  p[9] := 53;
  p[10] := 54;

  x := 40;
  y := CENTER_Y - 220;
  w := 560;

  if where <> 2 then
  begin
    x := 100;
    //w := 530;
  end;


  //{$IFDEF DARWIN}
  RegionRect.x := x;
  RegionRect.y := y;
  RegionRect.w := 530;
  RegionRect.h := 456;
  //{$ENDIF}
  redraw;
  //{$IFDEF DARWIN}
  RegionRect.w := 0;
  RegionRect.h := 0;
  //{$ENDIF}

  DrawRectangle(x, y, 530, 455, 0, colcolor(255), 50);
  //显示头像
  drawheadpic(Rrole[rnum].HeadNum, x + 60, y + 80);
  //显示姓名
  Name := big5tounicode(@Rrole[rnum].Name);
  drawshadowtext(@Name[1], x + 68 - length(PChar(@Rrole[rnum].Name)) * 5, y + 85, colcolor($64), colcolor($66));
  //显示所需字符
  for i := 0 to 5 do
    drawshadowtext(@strs[i, 1], x - 10, y + 110 + 21 * i, colcolor($21), colcolor($23));
  for i := 6 to 17 do
    drawshadowtext(@strs[i, 1], x + 160, y + 5 + 21 * (i - 6), colcolor($64), colcolor($66));
  drawshadowtext(@strs[20, 1], x + 360, y + 5, colcolor($21), colcolor($23));
  drawshadowtext(@strs[23, 1], x + 360, y + 260, colcolor($21), colcolor($23));

  addatk := 0;
  adddef := 0;
  addspeed := 0;
  if rrole[rnum].Equip[0] >= 0 then
  begin
    addatk := addatk + ritem[rrole[rnum].Equip[0]].AddAttack;
    adddef := adddef + ritem[rrole[rnum].Equip[0]].AddDefence;
    addspeed := addspeed + ritem[rrole[rnum].Equip[0]].AddSpeed;
  end;

  if rrole[rnum].Equip[1] >= 0 then
  begin
    addatk := addatk + ritem[rrole[rnum].Equip[1]].AddAttack;
    adddef := adddef + ritem[rrole[rnum].Equip[1]].AddDefence;
    addspeed := addspeed + ritem[rrole[rnum].Equip[1]].AddSpeed;
  end;

  //攻击, 防御, 轻功
  //单独处理是因为显示顺序和存储顺序不同
  str := format('%4d', [Rrole[rnum].Attack + addatk]);
  drawengshadowtext(@str[1], x + 280, y + 5 + 21 * 0, colcolor(5), colcolor(7));
  str := format('%4d', [Rrole[rnum].Defence + adddef]);
  drawengshadowtext(@str[1], x + 280, y + 5 + 21 * 1, colcolor(5), colcolor(7));
  str := format('%4d', [Rrole[rnum].Speed + addspeed]);
  drawengshadowtext(@str[1], x + 280, y + 5 + 21 * 2, colcolor(5), colcolor(7));

  //其他属性
  str := format('%4d', [Rrole[rnum].Movestep div 10]);
  drawengshadowtext(@str[1], x + 280, y + 5 + 21 * 3, colcolor(5), colcolor(7));

  str := format('%4d', [Rrole[rnum].Medcine]);
  drawengshadowtext(@str[1], x + 280, y + 5 + 21 * 4, colcolor(5), colcolor(7));

  str := format('%4d', [Rrole[rnum].UsePoi]);
  drawengshadowtext(@str[1], x + 280, y + 5 + 21 * 5, colcolor(5), colcolor(7));

  str := format('%4d', [Rrole[rnum].MedPoi]);
  drawengshadowtext(@str[1], x + 280, y + 5 + 21 * 6, colcolor(5), colcolor(7));

  str := format('%4d', [Rrole[rnum].Fist]);
  drawengshadowtext(@str[1], x + 280, y + 5 + 21 * 7, colcolor(5), colcolor(7));

  str := format('%4d', [Rrole[rnum].Sword]);
  drawengshadowtext(@str[1], x + 280, y + 5 + 21 * 8, colcolor(5), colcolor(7));

  str := format('%4d', [Rrole[rnum].Knife]);
  drawengshadowtext(@str[1], x + 280, y + 5 + 21 * 9, colcolor(5), colcolor(7));

  str := format('%4d', [Rrole[rnum].Unusual]);
  drawengshadowtext(@str[1], x + 280, y + 5 + 21 * 10, colcolor(5), colcolor(7));

  str := format('%4d', [Rrole[rnum].HidWeapon]);
  drawengshadowtext(@str[1], x + 280, y + 5 + 21 * 11, colcolor(5), colcolor(7));

  //武功
  for i := 0 to 9 do
  begin
    magicnum := Rrole[rnum].magic[i];
    if magicnum > 0 then
    begin
      drawbig5shadowtext(@Rmagic[magicnum].Name, x + 340, y + 26 + 21 * i, colcolor(5), colcolor(7));
      str := format('%3d', [Rrole[rnum].MagLevel[i] div 100 + 1]);
      drawengshadowtext(@str[1], x + 480, y + 26 + 21 * i, colcolor($64), colcolor($66));
    end;
  end;

  //内功
  for i := 0 to 3 do
  begin
    magicnum := Rrole[rnum].neigong[i];
    if magicnum > 0 then
    begin
      drawbig5shadowtext(@Rmagic[magicnum].Name, x + 340, y + 26 + +260 + 21 * i, colcolor(5), colcolor(7));
      str := format('%3d', [Rrole[rnum].NGLevel[i] div 100 + 1]);
      drawengshadowtext(@str[1], x + 480, y + 26 + 260 + 21 * i, colcolor($64), colcolor($66));
    end;
  end;


  //等级
  str := format('%4d', [Rrole[rnum].Level]);
  drawengshadowtext(@str[1], x + 110, y + 110, colcolor(5), colcolor(7));



  //生命值, 在受伤和中毒值不同时使用不同颜色
  case RRole[rnum].Hurt of
    34..66:
    begin
      color1 := colcolor($E);
      color2 := colcolor($10);
    end;
    67..1000:
    begin
      color1 := colcolor($14);
      color2 := colcolor($16);
    end;
    else
    begin
      color1 := colcolor($7);
      color2 := colcolor($5);
    end;
  end;
  str := format('%4d', [RRole[rnum].CurrentHP]);
  drawengshadowtext(@str[1], x + 60, y + 131, color1, color2);

  str := '/';
  drawengshadowtext(@str[1], x + 100, y + 131, colcolor($64), colcolor($66));

  case RRole[rnum].Poision of
    1..66:
    begin
      color1 := colcolor($30);
      color2 := colcolor($32);
    end;
    67..1000:
    begin
      color1 := colcolor($35);
      color2 := colcolor($37);
    end;
    else
    begin
      color1 := colcolor($23);
      color2 := colcolor($21);
    end;
  end;
  str := format('%4d', [RRole[rnum].MaxHP]);
  drawengshadowtext(@str[1], x + 110, y + 131, color1, color2);
  //内力, 依据内力性质使用颜色
  if rrole[rnum].MPType = 0 then
  begin
    color1 := colcolor($50);
    color2 := colcolor($4E);
  end
  else if rrole[rnum].MPType = 1 then
  begin
    color1 := colcolor($7);
    color2 := colcolor($5);
  end
  else
  begin
    color1 := colcolor($66);
    color2 := colcolor($63);
  end;
  str := format('%4d/%4d', [RRole[rnum].CurrentMP, RRole[rnum].MaxMP]);
  drawengshadowtext(@str[1], x + 60, y + 152, color1, color2);
  //体力
  str := format('%4d/%4d', [rrole[rnum].PhyPower, MAX_PHYSICAL_POWER]);
  drawengshadowtext(@str[1], x + 60, y + 173, colcolor(5), colcolor(7));
  //经验
  str := format('%5d', [uint16(Rrole[rnum].Exp)]);
  drawengshadowtext(@str[1], x + 100, y + 194, colcolor(5), colcolor(7));
  str := format('%5d', [uint16(Leveluplist[Rrole[rnum].Level - 1])]);
  drawengshadowtext(@str[1], x + 100, y + 215, colcolor(5), colcolor(7));

  //str:=format('%5d', [Rrole[rnum,21]]);
  //drawengshadowtext(@str[1],150,295,colcolor($7),colcolor($5));

  //drawshadowtext(@strs[20, 1], 30, 341, colcolor($21), colcolor($23));
  //drawshadowtext(@strs[21, 1], 30, 362, colcolor($21), colcolor($23));

  //drawrectanglewithoutframe(100,351,Rrole[rnum,19],10,colcolor($16),50);
  //中毒, 受伤
  //str := format('%4d', [RRole[rnum].Hurt]);
  //drawengshadowtext(@str[1], 150, 341, colcolor($14), colcolor($16));
  //str := format('%4d', [RRole[rnum].Poision]);
  //drawengshadowtext(@str[1], 150, 362, colcolor($35), colcolor($37));

  //装备, 秘笈
  drawshadowtext(@strs[18, 1], x, y + 260, colcolor($21), colcolor($23));
  drawshadowtext(@strs[19, 1], x + 160, y + 260, colcolor($21), colcolor($23));
  if Rrole[rnum].Equip[0] >= 0 then
    drawbig5shadowtext(@Ritem[Rrole[rnum].Equip[0]].Name, x + 5, y + 281, colcolor(5), colcolor(7));
  if Rrole[rnum].Equip[1] >= 0 then
    drawbig5shadowtext(@Ritem[Rrole[rnum].Equip[1]].Name, x + 5, y + 302, colcolor(5), colcolor(7));

  //计算秘笈需要经验
  if Rrole[rnum].PracticeBook >= 0 then
  begin
    mlevel := 1;
    magicnum := Ritem[Rrole[rnum].PracticeBook].Magic;
    if magicnum > 0 then
      for i := 0 to 9 do
        if Rrole[rnum].Magic[i] = magicnum then
        begin
          mlevel := Rrole[rnum].MagLevel[i] div 100 + 1;
          break;
        end;
    for i := 0 to 3 do
      if Rrole[rnum].NeiGong[i] = magicnum then
      begin
        mlevel := Rrole[rnum].NGLevel[i] div 100 + 1;
        break;
      end;
    //needexp := trunc((1 + (mlevel - 1) * 0.1) * Ritem[Rrole[rnum].PracticeBook].NeedExp * (1 + (6 - Rrole[rnum].Aptitude div 15) * 0.2));
    needexp := trunc((1 + (mlevel - 1) * 0.5) * Ritem[Rrole[rnum].PracticeBook].NeedExp *
      (1 + (7 - Rrole[rnum].Aptitude / 15) * 0.5));

    drawbig5shadowtext(@Ritem[Rrole[rnum].PracticeBook].Name, x + 180, y + 281, colcolor(5), colcolor(7));
    str := format('%5d/%5d', [uint16(Rrole[rnum].ExpForBook), needexp]);
    if mlevel = 10 then
      str := format('%5d/=', [uint16(Rrole[rnum].ExpForBook)]);
    drawengshadowtext(@str[1], x + 200, y + 302, colcolor($64), colcolor($66));
  end;



  if Where = 2 then
  begin
    //情侣加成，loverlevel：
    //0加攻、1加防、2加移、3抗毒、4武功威力、5内功加成、6替代受伤、7回复生命、8回复内力



    //特技导致状态，Statelevel：
    //0攻击,1防御,2轻功,3移动,4伤害,5回血,6回内
    //7战神,8风雷,9孤注,10倾国,11毒箭,12剑芒,13连击
    //14乾坤,15灵精,16奇门,17博采,18聆音,19青翼,20回体
    //21,22,23,24,25,26定身,27控制
    setlength(strs1, STATUS_AMOUNT);
    strs1[0] := ' 攻擊';
    strs1[1] := ' 防禦';
    strs1[2] := ' 輕功';
    strs1[3] := ' 移動';
    strs1[4] := ' 傷害';
    strs1[5] := ' 回命';
    strs1[6] := ' 回內';
    strs1[7] := ' 戰神';
    strs1[8] := ' 風雷';
    strs1[9] := ' 孤注';
    strs1[10] := ' 傾國';
    strs1[11] := ' 毒箭';
    strs1[12] := ' 劍芒';
    strs1[13] := ' 連擊';
    strs1[14] := ' 乾坤';
    strs1[15] := ' 靈精';
    strs1[16] := ' 閃避';
    strs1[17] := ' 博采';
    strs1[18] := ' 聆音';
    strs1[19] := ' 青翼';
    strs1[20] := ' 回體';
    strs1[21] := ' 傷逝';
    strs1[22] := ' 黯然';
    strs1[23] := ' 慈悲';
    strs1[24] := ' 悲歌';
    strs1[25] := ' ';
    strs1[26] := ' 定身';
    strs1[27] := ' 控制';

    for i := 0 to STATUS_AMOUNT - 1 do
    begin
      if Brole[bnum].StateLevel[i] <> 0 then
      begin
        if Brole[bnum].StateLevel[i] > 0 then
        begin
          color1 := colcolor($7);
          color2 := colcolor($5);
        end
        else
        begin
          color1 := colcolor($30);
          color2 := colcolor($32);
        end;

        drawtextwithrect(@strs1[i, 1], x + 20 + 50 * (i mod 7), y + 330 + 30 * (i div 7), 47, color1, color2);
      end;
    end;

  end;
  SDL_UpdateRect2(screen, x, y, 561, 456);

end;

//离队选单

procedure MenuLeave;
var
  str: WideString;
  i, menu: integer;
begin
  str := ' 要求誰離隊？';
  drawtextwithrect(@str[1], 80, 30, 132, colcolor($21), colcolor($23));
  menu := SelectOneTeamMember(80, 65, '%3d', 15, 0);
  if menu >= 0 then
  begin
    for i := 0 to 99 do
      if leavelist[i] = TeamList[menu] then
      begin
        callevent(BEGIN_LEAVE_EVENT + i * 2);
        SDL_EnableKeyRepeat(0, 10);
        break;
      end;
  end;
  redraw;
  SDL_EnableKeyRepeat(20, 100);
end;

//系统选单

procedure MenuSystem;
var
  i, menu, menup: integer;
  filename: string;
  Kys_ini: TIniFile;
begin
  Filename := ExtractFilePath(ParamStr(0)) + 'kysmod.ini';
  Kys_ini := TIniFile.Create(filename);
  menu := 0;
  showmenusystem(menu);
  while (SDL_WaitEvent(@event) >= 0) do
  begin
    if where = 3 then
      break;
    CheckBasicEvent;
    case event.type_ of
      SDL_KEYDOWN:
      begin
        if (event.key.keysym.sym = sdlk_down) then
        begin
          menu := menu + 1;
          if menu > 5 then
            menu := 0;
          showMenusystem(menu);
        end;
        if (event.key.keysym.sym = sdlk_up) then
        begin
          menu := menu - 1;
          if menu < 0 then
            menu := 5;
          showMenusystem(menu);
        end;
      end;

      SDL_KEYUP:
      begin
        if (event.key.keysym.sym = sdlk_escape) then
        begin
          redraw;
          //SDL_UpdateRect2(screen, 80, 30, 47, 137);
          break;
        end;
        if (event.key.keysym.sym = sdlk_return) or (event.key.keysym.sym = sdlk_space) then
        begin
          case menu of
            4:
            begin
              SIMPLE := 1 - SIMPLE;
              Kys_ini.WriteInteger('Set', 'SIMPLE', SIMPLE);
              Break;
            end;
            5:
            begin
              MenuQuit;
              SDL_EnableKeyRepeat(20, 100);
            end;
            3:
            begin
              Maker;
              redraw;
              SDL_UpdateRect2(screen, 0, 0, screen.w, screen.h);
              showMenusystem(menu);
            end;
            1:
            begin
              MenuSave;
              SDL_EnableKeyRepeat(20, 100);
            end;
            0:
            begin
              Menuload;
              SDL_EnableKeyRepeat(20, 100);
            end;
            2:
            begin
              if fullscreen = 1 then
                realscreen := SDL_SetVideoMode(CENTER_X * 2, CENTER_Y * 2, 32, ScreenFlag)
              else
                realscreen := SDL_SetVideoMode(CENTER_X * 2, CENTER_Y * 2, 32, ScreenFlag or SDL_FULLSCREEN);
              fullscreen := 1 - fullscreen;
              Kys_ini.WriteInteger('video', 'FULLSCREEN', fullscreen);
              break;
            end;
          end;
        end;
      end;
      SDL_MOUSEBUTTONUP:
      begin
        if (event.button.button = sdl_button_right) then
        begin
          redraw;
          //SDL_UpdateRect2(screen, 80, 30, 47, 137);
          break;
        end;
        if (event.button.button = sdl_button_left) then
          if (round(event.button.x / (RealScreen.w / screen.w)) >= 80) and
            (round(event.button.x / (RealScreen.w / screen.w)) < 170) and
            (round(event.button.y / (RealScreen.h / screen.h)) > 30) and
            (round(event.button.y / (RealScreen.h / screen.h)) < 162) then
          begin
            case menu of
              4:
              begin
                SIMPLE := 1 - SIMPLE;
                Kys_ini.WriteInteger('Set', 'SIMPLE', SIMPLE);
                Break;
              end;
              5:
              begin
                MenuQuit;
                SDL_EnableKeyRepeat(20, 100);
              end;
              3:
              begin
                Maker;
                redraw;
                SDL_UpdateRect2(screen, 0, 0, screen.w, screen.h);
                showMenusystem(menu);
              end;
              1:
              begin
                MenuSave;
                SDL_EnableKeyRepeat(20, 100);
              end;
              0:
              begin
                Menuload;
                SDL_EnableKeyRepeat(20, 100);
              end;
              2:
              begin
                if fullscreen = 1 then
                  realscreen := SDL_SetVideoMode(CENTER_X * 2, CENTER_Y * 2, 32, ScreenFlag)
                else
                  realscreen := SDL_SetVideoMode(CENTER_X * 2, CENTER_Y * 2, 32, ScreenFlag or SDL_FULLSCREEN);
                fullscreen := 1 - fullscreen;
                Kys_ini.WriteInteger('video', 'FULLSCREEN', fullscreen);
                break;
              end;
            end;
          end;
      end;
      SDL_MOUSEMOTION:
      begin
        if (round(event.button.x / (RealScreen.w / screen.w)) >= 80) and
          (round(event.button.x / (RealScreen.w / screen.w)) < 170) and
          (round(event.button.y / (RealScreen.h / screen.h)) > 30) and
          (round(event.button.y / (RealScreen.h / screen.h)) < 162) then
        begin
          menup := menu;
          menu := (round(event.button.y / (RealScreen.h / screen.h)) - 32) div 22;
          if menu > 5 then
            menu := 5;
          if menu < 0 then
            menu := 0;
          if menup <> menu then
            showMenusystem(menu);
        end;
      end;
    end;
  end;

end;

//显示系统选单

procedure ShowMenuSystem(menu: integer);
var
  word: array[0..5] of WideString;
  i: integer;
begin
  word[0] := ' 讀取進度';
  word[1] := ' 保存進度';
  word[2] := ' 全屏模式';
  word[3] := ' 製作群組';
  word[4] := ' 簡體模式';
  word[5] := ' 返回標題';
  if fullscreen = 1 then
    word[2] := ' 窗口模式';
  if SIMPLE = 1 then
    word[4] := ' 繁体模式';
  //{$IFDEF DARWIN}
  RegionRect.x := 80;
  RegionRect.y := 30;
  RegionRect.w := 91;
  RegionRect.h := 139;
  //{$ENDIF}
  redraw;
  //{$IFDEF DARWIN}
  RegionRect.w := 0;
  RegionRect.h := 0;
  //{$ENDIF}
  DrawRectangle(80, 30, 90, 138, 0, colcolor(255), 30);
  for i := 0 to 5 do
    if i = menu then
    begin
      drawshadowtext(@word[i][1], 64, 32 + 22 * i, colcolor($64), colcolor($66));
    end
    else
    begin
      drawshadowtext(@word[i][1], 64, 32 + 22 * i, colcolor($5), colcolor($7));
    end;
  SDL_UpdateRect2(screen, 80, 30, 95, 139);

end;

//读档选单

procedure MenuLoad;
var
  menu: integer;
begin
  setlength(menustring, 6);
  setlength(Menuengstring, 0);
  menustring[0] := ' 進度一';
  menustring[1] := ' 進度二';
  menustring[2] := ' 進度三';
  menustring[3] := ' 進度四';
  menustring[4] := ' 進度五';
  menustring[5] := ' 自動檔';
  menu := commonmenu(176, 30, 67, 5);
  if menu >= 0 then
  begin
    LastShowScene := -1;
    LoadR(menu + 1);
    if where = 1 then
      JmpScence(curScence, sy, sx);
    Redraw;
    SDL_UpdateRect2(screen, 0, 0, screen.w, screen.h);
  end;
  ShowMenu(4);
  ShowMenusystem(0);

end;

//特殊的读档选单, 仅用在开始时读档

function MenuLoadAtBeginning: boolean;
var
  menu: integer;
begin
  Redraw;
  SDL_UpdateRect2(screen, 0, 0, screen.w, screen.h);
  setlength(menustring, 6);
  setlength(Menuengstring, 0);
  menustring[0] := ' 載入進度一';
  menustring[1] := ' 載入進度二';
  menustring[2] := ' 載入進度三';
  menustring[3] := ' 載入進度四';
  menustring[4] := ' 載入進度五';
  menustring[5] := ' 載入自動檔';
  menu := commonmenu(265, 120, 107, 5);
  Result := False;
  if menu >= 0 then
  begin
    LoadR(menu + 1);
    //Redraw;
    SDL_UpdateRect2(screen, 0, 0, screen.w, screen.h);
    Result := True;
  end;

end;

//存档选单

procedure MenuSave;
var
  menu: integer;
  str: WideString;
begin
  setlength(menustring, 5);
  setlength(menuengstring, 0);
  menustring[0] := ' 進度一';
  menustring[1] := ' 進度二';
  menustring[2] := ' 進度三';
  menustring[3] := ' 進度四';
  menustring[4] := ' 進度五';
  menu := commonmenu(176, 30, 67, 4);
  if menu >= 0 then
  begin
    if (where = 1) and (CurScence = 71) then
    begin
      str := ' 此場景不可存檔！';
      drawtextwithrect(@str[1], 176, 30, 172, colcolor($5), colcolor($7));
      waitanykey;
    end
    else
      SaveR(menu + 1);

  end;
  ShowMenu(4);
  ShowMenusystem(1);

end;

//退出选单

procedure MenuQuit;
var
  menu, n: integer;
  str1, str2: string;
  str: WideString;
begin
  setlength(menustring, 3);
  menustring[0] := ' 取消';
  menustring[1] := ' 確定';
  menustring[2] := ' test';
  n := 1;
  if KDEF_SCRIPT = 1 then
    n := 2;
  menu := commonmenu(177, 30, 45, n);
  if menu = 1 then
  begin
    where := 3;
    instruct_14;
    redraw;
    drawrectanglewithoutframe(0, 0, CENTER_X * 2, CENTER_Y * 2, 0, 60);
    str := ' 请按任意键继续…';
    drawshadowtext(@str[1], CENTER_X - 120, CENTER_Y - 25, colcolor(255), colcolor(255));
    SDL_UpdateRect2(screen, 0, 0, screen.w, screen.h);
    waitanykey;
    ReDraw;
    drawtitlepic(0, 425, 275);
    SDL_UpdateRect2(screen, 0, 0, screen.w, screen.h);
  end;

  if menu = 2 then
  begin
    str := '  Script fail!';
    str1 := '';
    str1 := inputbox('Script file number:', str1, '1');
    str2 := '';
    str2 := inputbox('Function name:', str2, 'f1');
    if execscript(PChar('script\' + str1 + '.lua'), PChar(str2)) <> 0 then
    begin
      DrawTextWithRect(@str[1], 100, 200, 150, $FFFFFF, $FFFFFF);
      waitanykey;
    end;
  end;
  if menu <> 1 then
  begin
    ShowMenu(4);
    ShowMenusystem(5);
  end;
end;

//医疗的效果
//未添加体力的需求与消耗

procedure EffectMedcine(role1, role2: integer);
var
  word: WideString;
  addlife: integer;
begin
  addlife := Rrole[role1].Medcine * 2 - Rrole[role2].Hurt + random(10) - 5;
  if addlife < 0 then
    addlife := 0;
  //if Rrole[role2].Hurt - Rrole[role1].Medcine > 20 then
  //  addlife := 0;
  //if Rrole[role2].Hurt > 66 then
  //  addlife := 0;
  if rrole[role1].PhyPower < 50 then
    addlife := 0;
  {Rrole[role2].Hurt := Rrole[role2].Hurt - addlife div LIFE_HURT;
   if RRole[role2].Hurt < 0 then
     RRole[role2].Hurt := 0;
   }
  if addlife > RRole[role2].MaxHP - Rrole[role2].CurrentHP then
    addlife := RRole[role2].MaxHP - Rrole[role2].CurrentHP;
  Rrole[role2].CurrentHP := Rrole[role2].CurrentHP + addlife;
  if addlife > 0 then
    RRole[role1].PhyPower := RRole[role1].PhyPower - 5;
  DrawRectangle(115, 98, 145, 51, 0, colcolor(255), 30);
  word := ' 增加生命';
  drawshadowtext(@word[1], 100, 125, colcolor(5), colcolor(7));
  drawbig5shadowtext(@rrole[role2].Name, 100, 100, colcolor($21), colcolor($23));
  word := format('%3d', [addlife]);
  drawengshadowtext(@word[1], 220, 125, colcolor($64), colcolor($66));
  SDL_UpdateRect2(screen, 0, 0, screen.w, screen.h);
  waitanykey;
  redraw;

end;

//解毒的效果

procedure EffectMedPoision(role1, role2: integer);
var
  word: WideString;
  minuspoi: integer;
begin
  minuspoi := Rrole[role1].MedPoi;
  if minuspoi > Rrole[role2].Poision then
    minuspoi := Rrole[role2].Poision;
  if rrole[role1].PhyPower < 50 then
    minuspoi := 0;
  Rrole[role2].Poision := Rrole[role2].Poision - minuspoi;
  if minuspoi > 0 then
    RRole[role1].PhyPower := RRole[role1].PhyPower - 3;
  DrawRectangle(115, 98, 145, 51, 0, colcolor(255), 30);
  word := ' 中毒減少';
  drawshadowtext(@word[1], 100, 125, colcolor(5), colcolor(7));
  drawbig5shadowtext(@rrole[role2].Name, 100, 100, colcolor($21), colcolor($23));
  word := format('%3d', [minuspoi]);
  drawengshadowtext(@word[1], 220, 125, colcolor($64), colcolor($66));
  SDL_UpdateRect2(screen, 0, 0, screen.w, screen.h);
  waitanykey;
  redraw;

end;

//使用物品的效果
//练成秘笈的效果

procedure EatOneItem(rnum, inum: integer);
var
  i, j, p, l, x, y: integer;
  word: array[0..23] of WideString;
  addvalue, rolelist: array[0..23] of integer;
  str: WideString;
begin

  word[0] := ' 增加生命';
  word[1] := ' 增加生命最大值';
  word[2] := ' 中毒程度';
  word[3] := ' 增加體力';
  word[4] := ' 內力門路陰陽合一';
  word[5] := ' 增加內力';
  word[6] := ' 增加內力最大值';
  word[7] := ' 增加攻擊力';
  word[8] := ' 增加輕功';
  word[9] := ' 增加防禦力';
  word[10] := ' 增加醫療能力';
  word[11] := ' 增加用毒能力';
  word[12] := ' 增加解毒能力';
  word[13] := ' 增加抗毒能力';
  word[14] := ' 增加拳掌能力';
  word[15] := ' 增加御劍能力';
  word[16] := ' 增加耍刀能力';
  word[17] := ' 增加特殊兵器';
  word[18] := ' 增加暗器技巧';
  word[19] := ' 增加武學常識';
  word[20] := ' 增加品德指數';
  word[21] := ' 增加移動力0.';
  word[22] := ' 增加攻擊帶毒';
  word[23] := ' 受傷程度';
  rolelist[0] := 17;
  rolelist[1] := 18;
  rolelist[2] := 20;
  rolelist[3] := 21;
  rolelist[4] := 40;
  rolelist[5] := 41;
  rolelist[6] := 42;
  rolelist[7] := 43;
  rolelist[8] := 44;
  rolelist[9] := 45;
  rolelist[10] := 46;
  rolelist[11] := 47;
  rolelist[12] := 48;
  rolelist[13] := 49;
  rolelist[14] := 50;
  rolelist[15] := 51;
  rolelist[16] := 52;
  rolelist[17] := 53;
  rolelist[18] := 54;
  rolelist[19] := 55;
  rolelist[20] := 56;
  rolelist[21] := 58;
  rolelist[22] := 57;
  rolelist[23] := 19;
  //rolelist:=(17,18,20,21,40,41,42,43,44,45,46,47,48,49,50,51,52,53,54,55,56,58,57);
  for i := 0 to 22 do
  begin
    addvalue[i] := Ritem[inum].Data[45 + i];
    if Ritem[inum].ItemType = 2 then
    begin
      if (i = 7) or (i = 9) then
      begin
        if (random(200) < 2 * rrole[rnum].Aptitude) then
          addvalue[i] := addvalue[i] + 1;
      end;
    end;
  end;
  //减少受伤
  addvalue[23] := -(addvalue[0] div (LIFE_HURT div 2));

  if -addvalue[23] > rrole[rnum].Data[19] then
    addvalue[23] := -rrole[rnum].Data[19];

  //增加生命, 内力最大值的处理
  if addvalue[1] + rrole[rnum].Data[18] > MAX_HP then
    addvalue[1] := MAX_HP - rrole[rnum].Data[18];
  if addvalue[6] + rrole[rnum].Data[42] > MAX_MP then
    addvalue[6] := MAX_MP - rrole[rnum].Data[42];
  if addvalue[1] + rrole[rnum].Data[18] < 0 then
    addvalue[1] := -rrole[rnum].Data[18];
  if addvalue[6] + rrole[rnum].Data[42] < 0 then
    addvalue[6] := -rrole[rnum].Data[42];

  for j := 7 to 22 do
  begin
    if addvalue[j] + rrole[rnum].Data[rolelist[j]] > maxprolist[rolelist[j]] then
      addvalue[j] := maxprolist[rolelist[j]] - rrole[rnum].Data[rolelist[j]];
    if addvalue[j] + rrole[rnum].Data[rolelist[j]] < 0 then
      addvalue[j] := -rrole[rnum].Data[rolelist[j]];
  end;
  //生命不能超过最大值
  if addvalue[0] + rrole[rnum].Data[17] > addvalue[1] + rrole[rnum].Data[18] then
    addvalue[0] := addvalue[1] + rrole[rnum].Data[18] - rrole[rnum].Data[17];
  //中毒不能小于0
  if addvalue[2] + rrole[rnum].Data[20] < 0 then
    addvalue[2] := -rrole[rnum].Data[20];
  //体力不能超过100
  if addvalue[3] + rrole[rnum].Data[21] > MAX_PHYSICAL_POWER then
    addvalue[3] := MAX_PHYSICAL_POWER - rrole[rnum].Data[21];
  //内力不能超过最大值
  if addvalue[5] + rrole[rnum].Data[41] > addvalue[6] + rrole[rnum].Data[42] then
    addvalue[5] := addvalue[6] + rrole[rnum].Data[42] - rrole[rnum].Data[41];
  p := 0;
  for i := 0 to 23 do
  begin
    if (i <> 4) and (i <> 21) and (addvalue[i] <> 0) then
      p := p + 1;
  end;
  if (addvalue[4] = 2) and (rrole[rnum].Data[40] <> 2) then
    p := p + 1;
  if (addvalue[21] = 1) and (rrole[rnum].Data[58] <> 1) then
    p := p + 1;

  ShowSimpleStatus(rnum, 350, 50);
  DrawRectangle(100, 70, 200, 25, 0, colcolor(255), 25);
  str := ' 服用';
  if Ritem[inum].ItemType = 2 then
    str := ' 練成';
  Drawshadowtext(@str[1], 83, 72, colcolor($21), colcolor($23));
  Drawbig5shadowtext(@Ritem[inum].Name, 143, 72, colcolor($64), colcolor($66));

  //如果增加的项超过11个, 分两列显示
  if p < 11 then
  begin
    l := p;
    Drawrectangle(100, 100, 200, 22 * l + 25, 0, colcolor($FF), 25);
  end
  else
  begin
    l := p div 2 + 1;
    Drawrectangle(100, 100, 400, 22 * l + 25, 0, colcolor($FF), 25);
  end;
  drawbig5shadowtext(@rrole[rnum].Data[4], 83, 102, colcolor($21), colcolor($23));
  str := ' 未增加屬性';
  if p = 0 then
    drawshadowtext(@str[1], 163, 102, colcolor(5), colcolor(7));
  p := 0;
  for i := 0 to 23 do
  begin
    if p < l then
    begin
      x := 0;
      y := 0;
    end
    else
    begin
      x := 200;
      y := -l * 22;
    end;
    if (i <> 4) and (addvalue[i] <> 0) then
    begin
      rrole[rnum].Data[rolelist[i]] := rrole[rnum].Data[rolelist[i]] + addvalue[i];
      drawshadowtext(@word[i, 1], 83 + x, 124 + y + p * 22, colcolor(5), colcolor(7));
      str := format('%4d', [addvalue[i]]);
      drawengshadowtext(@str[1], 243 + x, 124 + y + p * 22, colcolor($64), colcolor($66));
      p := p + 1;
    end;
    //对内力性质特殊处理
    if (i = 4) and (addvalue[i] = 2) then
    begin
      if rrole[rnum].Data[rolelist[i]] <> 2 then
      begin
        rrole[rnum].Data[rolelist[i]] := 2;
        drawshadowtext(@word[i, 1], 83 + x, 124 + y + p * 22, colcolor(5), colcolor(7));
        p := p + 1;
      end;
    end;
    //对左右互搏特殊处理
    //if (i = 21) and (addvalue[i] = 1) then
    //begin
    //  if rrole[rnum].data[rolelist[i]] <> 1 then
    //  begin
    //    rrole[rnum].data[rolelist[i]] := 1;
    //    drawshadowtext(@word[i, 1], 83 + x, 124 + y + p * 22, colcolor(5), colcolor(7));
    //    p := p + 1;
    //  end;
    //end;
  end;
  SDL_UpdateRect2(screen, 0, 0, screen.w, screen.h);

end;

//Event.
//事件系统

procedure CallEvent(num: integer);
var
  e: array of smallint;
  i, idx, grp, offset, len, p, lenkey: integer;
  check: boolean;
begin
  //CurEvent:=num;
  Cx := Sx;
  Cy := Sy;
  Sstep := 0;
  NeedRefreshScence := 0;
  //redraw;
  len := 0;
  if num = 0 then
  begin
    offset := 0;
    len := KIdx[0];
  end
  else
  begin
    offset := KIdx[num - 1];
    len := KIdx[num] - offset;
  end;
  setlength(e, len div 2 + 1);
  move(KDef[offset], e[0], len);


  for i := 0 to len div 2 do
  begin
    if encrypt = 1 then
      if (e[i] in [0..69]) then
        e[i] := Kkey[e[i]];
  end;
  i := 0;
  //普通事件写成子程, 需跳转事件写成函数
  len := length(e);
  while SDL_PollEvent(@event) >= 0 do
  begin
    CheckBasicEvent;
    if (i >= len - 1) then
      break;
    if (e[i] < 0) then
      break;
    case e[i] of
      0:
      begin
        i := i + 1;
        //if where = 1 then InitialScence;
        redraw;
        DrawRectangleWithoutFrame(0, 0, screen.w, screen.h, 0, blackscreen * 10);
        SDL_UpdateRect2(screen, 0, 0, screen.w, screen.h);
      end;
      1:
      begin
        instruct_1(e[i + 1], e[i + 2], e[i + 3]);
        i := i + 4;
      end;
      2:
      begin
        instruct_2(e[i + 1], e[i + 2]);
        i := i + 3;
      end;
      3:
      begin
        instruct_3([e[i + 1], e[i + 2], e[i + 3], e[i + 4], e[i + 5], e[i + 6], e[i + 7],
          e[i + 8], e[i + 9], e[i + 10], e[i + 11], e[i + 12], e[i + 13]]);
        i := i + 14;
      end;
      4:
      begin
        i := i + instruct_4(e[i + 1], e[i + 2], e[i + 3]);
        i := i + 4;
      end;
      5:
      begin
        i := i + instruct_5(e[i + 1], e[i + 2]);
        i := i + 3;
      end;
      6:
      begin
        i := i + instruct_6(e[i + 1], e[i + 2], e[i + 3], e[i + 4]);
        i := i + 5;
      end;
      7: //Break the event.
      begin
        i := i + 1;
        break;
      end;
      8:
      begin
        instruct_8(e[i + 1]);
        i := i + 2;
      end;
      9:
      begin
        i := i + instruct_9(e[i + 1], e[i + 2]);
        i := i + 3;
      end;
      10:
      begin
        instruct_10(e[i + 1]);
        i := i + 2;
      end;
      11:
      begin
        i := i + instruct_11(e[i + 1], e[i + 2]);
        i := i + 3;
      end;
      12:
      begin
        instruct_12;
        i := i + 1;
      end;
      13:
      begin
        instruct_13;
        i := i + 1;
      end;
      14:
      begin
        instruct_14;
        i := i + 1;
      end;
      15:
      begin
        instruct_15;
        i := i + 1;
        break;
      end;
      16:
      begin
        i := i + instruct_16(e[i + 1], e[i + 2], e[i + 3]);
        i := i + 4;
      end;
      17:
      begin
        instruct_17([e[i + 1], e[i + 2], e[i + 3], e[i + 4], e[i + 5]]);
        i := i + 6;
      end;
      18:
      begin
        i := i + instruct_18(e[i + 1], e[i + 2], e[i + 3]);
        i := i + 4;
      end;
      19:
      begin
        instruct_19(e[i + 1], e[i + 2]);
        i := i + 3;
      end;
      20:
      begin
        i := i + instruct_20(e[i + 1], e[i + 2]);
        i := i + 3;
      end;
      21:
      begin
        instruct_21(e[i + 1]);
        i := i + 2;
      end;
      22:
      begin
        instruct_22;
        i := i + 1;
      end;
      23:
      begin
        instruct_23(e[i + 1], e[i + 2]);
        i := i + 3;
      end;
      24:
      begin
        instruct_24;
        i := i + 1;
      end;
      25:
      begin
        instruct_25(e[i + 1], e[i + 2], e[i + 3], e[i + 4]);
        i := i + 5;
      end;
      26:
      begin
        instruct_26(e[i + 1], e[i + 2], e[i + 3], e[i + 4], e[i + 5]);
        i := i + 6;
      end;
      27:
      begin
        instruct_27(e[i + 1], e[i + 2], e[i + 3]);
        i := i + 4;
      end;
      28:
      begin
        i := i + instruct_28(e[i + 1], e[i + 2], e[i + 3], e[i + 4], e[i + 5]);
        i := i + 6;
      end;
      29:
      begin
        i := i + instruct_29(e[i + 1], e[i + 2], e[i + 3], e[i + 4], e[i + 5]);
        i := i + 6;
      end;
      30:
      begin
        instruct_30(e[i + 1], e[i + 2], e[i + 3], e[i + 4]);
        i := i + 5;
      end;
      31:
      begin
        i := i + instruct_31(e[i + 1], e[i + 2], e[i + 3]);
        i := i + 4;
      end;
      32:
      begin
        instruct_32(e[i + 1], e[i + 2]);
        i := i + 3;
      end;
      33:
      begin
        instruct_33(e[i + 1], e[i + 2], e[i + 3]);
        i := i + 4;
      end;
      34:
      begin
        instruct_34(e[i + 1], e[i + 2]);
        i := i + 3;
      end;
      35:
      begin
        instruct_35(e[i + 1], e[i + 2], e[i + 3], e[i + 4]);
        i := i + 5;
      end;
      36:
      begin
        i := i + instruct_36(e[i + 1], e[i + 2], e[i + 3]);
        i := i + 4;
      end;
      37:
      begin
        instruct_37(e[i + 1]);
        i := i + 2;
      end;
      38:
      begin
        instruct_38(e[i + 1], e[i + 2], e[i + 3], e[i + 4]);
        i := i + 5;
      end;
      39:
      begin
        instruct_39(e[i + 1]);
        i := i + 2;
      end;
      40:
      begin
        instruct_40(e[i + 1]);
        i := i + 2;
      end;
      41:
      begin
        instruct_41(e[i + 1], e[i + 2], e[i + 3]);
        i := i + 4;
      end;
      42:
      begin
        i := i + instruct_42(e[i + 1], e[i + 2]);
        i := i + 3;
      end;
      43:
      begin
        i := i + instruct_43(e[i + 1], e[i + 2], e[i + 3]);
        i := i + 4;
      end;
      44:
      begin
        instruct_44(e[i + 1], e[i + 2], e[i + 3], e[i + 4], e[i + 5], e[i + 6]);
        i := i + 7;
      end;
      45:
      begin
        instruct_45(e[i + 1], e[i + 2]);
        i := i + 3;
      end;
      46:
      begin
        instruct_46(e[i + 1], e[i + 2]);
        i := i + 3;
      end;
      47:
      begin
        instruct_47(e[i + 1], e[i + 2]);
        i := i + 3;
      end;
      48:
      begin
        instruct_48(e[i + 1], e[i + 2]);
        i := i + 3;
      end;
      49:
      begin
        instruct_49(e[i + 1], e[i + 2]);
        i := i + 3;
      end;
      50:
      begin
        p := instruct_50([e[i + 1], e[i + 2], e[i + 3], e[i + 4], e[i + 5], e[i + 6], e[i + 7]]);
        i := i + 8;
        if p < 622592 then
          i := i + p
        else
          e[i + ((p + 32768) div 655360) - 1] := p mod 655360;
      end;
      51:
      begin
        instruct_51;
        i := i + 1;
      end;
      52:
      begin
        instruct_52;
        i := i + 1;
      end;
      53:
      begin
        instruct_53;
        i := i + 1;
      end;
      54:
      begin
        instruct_54;
        i := i + 1;
      end;
      55:
      begin
        i := i + instruct_55(e[i + 1], e[i + 2], e[i + 3], e[i + 4]);
        i := i + 5;
      end;
      56:
      begin
        instruct_56(e[i + 1]);
        i := i + 2;
      end;
      57:
      begin
        i := i + 1;
      end;
      58:
      begin
        instruct_58;
        i := i + 1;
      end;
      59:
      begin
        instruct_59;
        i := i + 1;
      end;
      60:
      begin
        i := i + instruct_60(e[i + 1], e[i + 2], e[i + 3], e[i + 4], e[i + 5]);
        i := i + 6;
      end;
      61:
      begin
        i := i + e[i + 1];
        i := i + 3;
      end;
      62:
      begin
        instruct_62(e[i + 1], e[i + 2], e[i + 3], e[i + 4], e[i + 5], e[i + 6]);
        i := i + 7;
        break;
      end;
      63:
      begin
        instruct_63(e[i + 1], e[i + 2]);
        i := i + 3;
      end;
      64:
      begin
        instruct_64;
        i := i + 1;
      end;
      65:
      begin
        i := i + 1;
      end;
      66:
      begin
        instruct_66(e[i + 1]);
        i := i + 2;
      end;
      67:
      begin
        instruct_67(e[i + 1]);
        i := i + 2;
      end;
      68:
      begin
        NewTalk(e[i + 1], e[i + 2], e[i + 3], e[i + 4], e[i + 5], e[i + 6], e[i + 7]);
        i := i + 8;
      end;
      69:
      begin
        ReSetName(e[i + 1], e[i + 2], e[i + 3]);
        i := i + 4;
      end;
      70:
      begin
        ShowTiTle(e[i + 1], e[i + 2]);
        i := i + 3;
      end;
      71:
      begin
        JmpScence(e[i + 1], e[i + 2], e[i + 3]);
        i := i + 4;
      end;
      72:
      begin
        SetAttribute(e[i + 1], e[i + 2], e[i + 3], e[i + 4], e[i + 5]);
        i := i + 6;
      end;
      else
      begin
        i := i + 1;
      end;
    end;
  end;

  event.key.keysym.sym := 0;
  event.button.button := 0;

  if NeedRefreshScence = 1 then
    InitialScence;
  //if where <> 2 then CurEvent := -1;
  if MMAPAMI and SCENCEAMI = 0 then
  begin
    redraw;
    SDL_UpdateRect2(screen, 0, 0, screen.w, screen.h);
  end;
  //SDL_EnableKeyRepeat(30, 30);

end;

procedure turnblack;
var
  i: integer;
begin
  for i := blackscreen to 10 do
  begin
    //Redraw;
    Sdl_Delay(10);
    DrawRectangleWithoutFrame(0, 0, screen.w, screen.h, 0, i * 10);
    SDL_UpdateRect2(screen, 0, 0, screen.w, screen.h);
  end;
  blackscreen := 10;

end;

procedure ReSetEntrance;
var
  i1, i2, i: integer;
begin
  for i1 := 0 to 479 do
    for i2 := 0 to 479 do
      Entrance[i1, i2] := -1;
  for i := 0 to ScenceAmount - 1 do
  begin
    Entrance[RScence[i].MainEntranceX1, RScence[i].MainEntranceY1] := i;
    Entrance[RScence[i].MainEntranceX2, RScence[i].MainEntranceY2] := i;
  end;
end;




procedure Maker;
var
  word: array[-1..68] of WideString;
  x, y, i, l: integer;
  tempscr, tempscr1: PSDL_Surface;
  dest, tempdest: TSDL_Rect;
begin
  word[-1] := ' ';
  word[0] := '《金庸水滸傳》';

  word[1] := '鐵血丹心論壇出品';
  word[2] := 'http://www.txdx.net';
  word[3] := ' ';

  word[4] := '總策劃';
  word[5] := '小小猪';
  word[6] := ' ';

  word[7] := '程式';
  word[8] := 'killer-G';
  word[9] := 's.weyl';
  word[10] := '凶神恶煞';
  word[11] := '黄顺坤';
  word[12] := ' ';

  word[13] := '劇本';
  word[14] := '风神无名';
  word[15] := '天外草';
  word[16] := '云潇潇';
  word[17] := '赫连春水';
  word[18] := '馋师无相';
  word[19] := ' ';

  word[20] := '美工';
  word[21] := '游客';
  word[22] := '令狐心情';
  word[23] := '小孩家家';
  word[24] := '伊人枕边醉';
  word[25] := 'Czhe520';
  word[26] := ' ';

  word[27] := '場景';
  word[28] := '游客';
  word[29] := '柳无色';
  word[30] := ' ';

  word[31] := '设计';
  word[32] := 'qja';
  word[33] := '南宫梦';
  word[34] := '风神无名';
  word[35] := ' ';

  word[36] := '測試';
  word[37] := '9523';
  word[38] := 'gn0811';
  word[39] := '张贝克';
  word[40] := '筷子';
  word[41] := '天真木頭人';
  word[42] := ' ';

  word[43] := '特別感謝';
  word[44] := '游泳的鱼';
  word[45] := 'fanyixia';
  word[46] := 'hihi88byebye';
  word[47] := 'xuantianxi';
  word[48] := 'chenxurui07';
  word[49] := '晴空飞雪';
  word[50] := '蓝雨冰刀';
  word[51] := '玉芷馨';
  word[52] := '流木匆匆';
  word[53] := 'chumsdock';
  word[54] := '沧海一笑';
  word[55] := 'ena';
  word[56] := 'qiu001';
  word[57] := '黑天鹅';
  word[58] := ' ';
  word[59] := ' ';
  word[60] := ' ';
  word[61] := ' ';
  word[62] := ' ';
  word[63] := ' ';
  word[64] := ' ';
  word[65] := '铁血丹心论坛';
  word[66] := '做中国人自己的武侠单机游戏';
  word[67] := 'http://www.txdx.net';
  word[68] := ' ';

  tempscr := SDL_CreateRGBSurface(ScreenFlag, CENTER_X * 2, 1800, 32, 0, 0, 0, 0);
  redraw;
  DrawRectangleWithoutFrame(0, 0, screen.w, screen.h, 0, 50);
  //drawrectanglewithoutframe(0, 50, 640, 380, 0, 50);
  tempscr1 := SDL_ConvertSurface(screen, screen.format, screen.flags);

  sdl_setcolorkey(tempscr, SDL_SRCCOLORKEY, 0);
  for l := 0 to high(word) do
  begin
    if (word[l - 1] = ' ') then
    begin
      drawtext(tempscr, @word[l][1], 310 - length(string(word[l])) * 5 + 1, l * 25, colcolor(104));
      drawtext(tempscr, @word[l][1], 310 - length(string(word[l])) * 5, l * 25, colcolor(99));
    end
    else
    begin
      drawtext(tempscr, @word[l][1], 310 - length(string(word[l])) * 5 + 1, l * 25, colcolor(7));
      drawtext(tempscr, @word[l][1], 310 - length(string(word[l])) * 5, l * 25, colcolor(5));
    end;
  end;

  dest.x := 0;
  dest.y := 50;
  dest.w := 0;
  dest.h := 0;
  {tempdest.x:=0;
  tempdest.y:=0;
  tempdest.w:=CENTER_X * 2;
  tempdest.h:=380;}
  i := 480;
  while SDL_PollEvent(@event) >= 0 do
  begin
    dest.y := i;
    //tempdest.y:=-i;
    SDL_BlitSurface(tempscr1, nil, screen, nil);
    SDL_BlitSurface(tempscr, nil, screen, @dest);
    SDL_UpdateRect2(screen, 0, 0, screen.w, screen.h);
    i := i - 2;
    if i <= -1500 then
    begin
      waitanykey;
      break;
    end;

    CheckBasicEvent;
    case event.type_ of
      SDL_MOUSEBUTTONUP:
        if event.button.button = sdl_button_right then
          break;
      SDL_KEYUP:
        if event.key.keysym.sym = sdlk_escape then
          break;
    end;
    sdl_delay(10);
  end;
  sdl_FreeSurface(tempscr);
  sdl_FreeSurface(tempscr1);
  //showmenu(4);

end;

procedure swap(var x, y: byte);
var
  t: byte;
begin
  t := x;
  x := y;
  y := t;
end;


procedure CloudCreate(num: integer);
begin
  CloudCreateOnSide(num);
  if num in [low(cloud)..high(cloud)] then
    Cloud[num].Positionx := random(17280);

end;

procedure CloudCreateOnSide(num: integer);
begin
  if num in [low(Cloud)..high(Cloud)] then
  begin
    Cloud[num].Picnum := random(9);
    Cloud[num].Shadow := 0;
    Cloud[num].Alpha := random(50) + 25;
    Cloud[num].MixColor := random(256) + random(256) shl 8 + random(256) shl 16 + random(256) shl 24;
    Cloud[num].mixAlpha := random(50);
    Cloud[num].Positionx := 0;
    Cloud[num].Positiony := random(8640);
    Cloud[num].Speedx := 1 + random(3);
    Cloud[num].Speedy := 0;
  end;
end;



end.
