unit kys_type;

interface

uses
  SDL2,
  SDL2_ttf,
  bass,
  lua52,
  Classes;

type

  TPosition = record
    x, y: integer;
  end;

  TPicInfo = record
    w, h, offx, offy: integer;
  end;

  TStretchInfo = record
    px, py, num, den: integer;
  end;

  TBuildInfo = record
    c: integer;
    b, x, y: smallint;
  end;

  TItemList = packed record
    Number: smallint;
    Amount: integer;
  end;

  TCloud = record
    Picnum: integer;
    Shadow: integer;
    Alpha: integer;
    mixColor: uint32;
    mixAlpha: integer;
    Positionx, Positiony, Speedx, Speedy: integer;
  end;

  TPInt1 = procedure(i: integer);

  //PPSDL_Surface = ^PSDL_Surface;
  //PPSDL_Texture = ^PSDL_Texture;

  TPNGIndex = record
    FileNum, PointerNum, Frame, x, y, w, h, Loaded, UseGRP: integer;
    BeginPointer: Pointer;
    //CurPointer: PPSDL_Surface;
    //CurPointerT: PPSDL_Texture;
    Pointers: array of Pointer;
  end;

  //该组用于保存效果和战斗
  TPNGIndexes = record
    Amount, Loaded: integer;
    FightFrame: array [0..4]of smallint;
    PNGIndexArray: array of TPNGIndex;
  end;

  //编号, 帧数(允许为0), 偏移, 是否已经载入(用于部分载入时判断), 是否使用GRP(通常无效)
  //当前表面的指针, 如果帧数不为大于1, 指针可能会变化

  TPNGIndexArray = array of TPNGIndex;

  //TSurfaceArray = array of PSDL_Surface;

  //TTextureArray = array of PSDL_Texture;
  TIntArray = array of integer;
  TByteArray = array of byte;


  TIDXGRP = record
    Amount: integer;
    IDX: array of integer;
    GRP: array of byte;
  end;

  TCallType = (Element, Address);

  //以下所有类型均有两种引用方式：按照别名引用；按照短整数数组引用

  TRole = record
    case TCallType of
      Element: (ListNum, HeadNum, IncLife, ActionNum: smallint;
        Name: array[0..9] of char;
        AddAtk, AddSpeed, AddDef, AddMP, RoundLeave: smallint;
        Sexual, Level: smallint;
        Exp: uint16;
        CurrentHP, MaxHP, Hurt, Poison, PhyPower: smallint;
        ExpForItem: uint16;
        Equip: array[0..1] of smallint;
        AmiFrameNum: array[0..4] of smallint;
        AmiDelay: array[0..4] of smallint;
        SoundDealy: array[0..4] of smallint;
        MPType, CurrentMP, MaxMP: smallint;
        Attack, Speed, Defence, Medcine, UsePoi, MedPoi, DefPoi, Fist,
        Sword, Knife, Unusual, HidWeapon: smallint;
        Knowledge, Ethics, AttPoi, Movestep, Repute, Aptitude, PracticeBook: smallint;
        ExpForBook: uint16;
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
        UnUse: array [0..7] of smallint;
        ForgeTimes, Price: smallint;
        Name: array[0..19] of char;
        Introduction: array[0..29] of char;
        Magic, AmiNum, User, EquipType, ShowIntro, ItemType, UnKnow5,
        UnKnow6, UnKnow7: smallint;
        AddCurrentHP, AddMaxHP, AddPoi, AddPhyPower, ChangeMPType,
        AddCurrentMP, AddMaxMP: smallint;
        AddAttack, AddSpeed, AddDefence, AddMedcine, AddUsePoi,
        AddMedPoi, AddDefPoi: smallint;
        AddFist, AddSword, AddKnife, AddUnusual, AddHidWeapon,
        AddKnowledge, AddRepute, AddMove, AddAttPoi: smallint;
        OnlyPracRole, NeedMPType, NeedMP, NeedAttack, NeedSpeed,
        NeedUsePoi, NeedMedcine, NeedMedPoi: smallint;
        NeedFist, NeedSword, NeedKnife, NeedUnusual, NeedHidWeapon,
        NeedAptitude: smallint;
        NeedExp, NeedExpForItem, NeedMaterial: smallint;
        GetItem, NeedMatAmount: array[0..4] of smallint);
      Address: (Data: array[0..94] of smallint);
  end;

  TScence = record
    case TCallType of
      Element: (ListNum: smallint;
        Name: array[0..9] of char;
        //梁羽生群侠传在这里修改了9为49
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
        Name0: array[0..9] of char;
        //UnKnow: array[0..4] of smallint;
        //UnKnow: 0-减生命（允许为负）, 1-最低攻击范围, 2-需要物品, 3-需要物品的数量, 4-不明
        NeedHP, MinStep, NeedItem, NeedItemAmount, ScriptNum: smallint;
        SoundNum, MagicType, AmiNum, HurtType, AttAreaType, NeedMP, Poison: smallint;
        //MigicType: 对应的动作类型0~5医拳剑刀特暗
        //HurtType: 伤害类型0-生命 1-内力 2-特技 3-内功 6-生命和内力
        Attack, MoveDistance, AttDistance, AddMP, HurtMP: array[0..9] of smallint;
        //这部分的定义随HurtType有很大的不同
        //Attack对于普通武功用0和1计算攻击力, 2内力加成, 3-轻功加成, 4,5, 6,7-仅用于先天一阳指的定身
        //Attack: 状态类特技中用来标记控制的等级, 对应后面AddMP的1~5
        //AddMP: 0-特技类作用对象, 1~5影响的5个状态编号,
        //AddMP: 0,1-内功中标记用毒, 2-有4个取值, 对应1葵花,2九阴,3北冥,4龙卷, 3-吸星融功, 4-回体力
        //MoveDistance: 內功中0,1-類型,最大殺傷/100,對一些威力較低的武功加成, 2,3-前述等級計算, 4,5-影響防禦計算,
        //6,7-加強內力加成, 8,9-加強輕功加成
        //AttDistance: 内功中0,1-回内力, 2,3-回血, 4-特定武功加成, 5-中毒轉內力,
        //6-殺體力, 7-加强資質加成, 8-殺內力, 9-剩余人数加成
        Name: array[0..19] of char);
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
        Pic, ShowNumber, AntiHurt, AutoMode, PreTeam, ExpGot, Auto, Moved: smallint;
        loverlevel: array[0..9] of smallint;
        StateLevel, StateRound: array[0..33] of smallint;
        RealSpeed, RealProgress, BHead: smallint;
        StaticPic: array[0..3] of smallint;
        shadow, alpha: integer;
        mixColor: uint32;
        mixAlpha: integer);
      Address: (Data: array[0..82] of smallint);
  end;
  //情侣加成, loverlevel：
  //0加攻、1加防、2加移、3抗毒、4武功威力、5内功加成、6替代受伤、7回复生命、8回复内力、9轻功
  //特技导致状态, Statelevel-程度, StateRound-剩余回合数
  //0攻击,1防御,2轻功,3移动,4伤害,5回血,6回内
  //7战神,8风雷,9孤注,10倾国(原常识),11毒箭,12剑芒(远攻),13连击
  //14乾坤(反伤),15灵精(内力代替伤害),16奇门(闪避),17博采,18聆音,19青翼,20回体
  //21伤逝,22黯然,23慈悲,24悲歌,25無用,26定身,27控制
  //28混乱,29~33五类武功福利(暂定)


  TWarData = record
    case TCallType of
      Element: (Warnum: smallint;
        Name: array[0..9] of char;
        BFieldNum, ExpGot, MusicNum: smallint;
        TeamMate, AutoTeamMate, TeamY, TeamX: array[0..5] of smallint;
        Enemy, EnemyY, EnemyX: array[0..19] of smallint);
      Address: (Data: array[0..$5C] of smallint);
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

  TLoadTileData = record
    amount: integer;
    path: string;
    filemem: PChar;
    beginIndex: ^TPNGIndex;
  end;

var

  MODVersion: integer = 13;
  //13-金庸水浒传(小猪3)
  //31-再戰江湖
  //81-梁羽生群侠传
  //仅为标记用

  //初始值
  TitleString: string;

  CHINESE_FONT: PAnsiChar = 'font/chinese.ttf';
  CHINESE_FONT_SIZE: integer = 20;
  CHINESE_FONT_REALSIZE: integer = 20;
  ENGLISH_FONT: PAnsiChar = 'font/eng.ttf';
  ENGLISH_FONT_SIZE: integer = 18;
  ENGLISH_FONT_REALSIZE: integer = 18;

  iniFilename: string = 'config/kysmod.ini';

  CENTER_X: integer = 384;
  CENTER_Y: integer = 240;

  AppPath: string; //程序的路径

  //以下为常数表, 其中多数可以由ini文件改变
  BEGIN_MISSION_NUM: integer = 100; //任务起始对话
  MISSION_AMOUNT: integer = 49; //任务数
  STATUS_AMOUNT: integer = 29; //状态数
  //ITEM_BEGIN_PIC: integer = 5720; //物品起始图片
  BEGIN_EVENT: integer = 301; //初始事件
  BEGIN_SCENCE: integer = 0; //初始场景
  BEGIN_Sx: integer = 20; //初始坐标(程序中的x, y与游戏中是相反的, 这是早期的遗留问题)
  BEGIN_Sy: integer = 19; //初始坐标
  SOFTSTAR_BEGIN_TALK: integer = 2547; //软体娃娃对话的开始编号
  SOFTSTAR_NUM_TALK: integer = 18; //软体娃娃的对话数量
  MAX_PHYSICAL_POWER: integer = 100; //最大体力
  MONEY_ID: integer = 0; //银两的物品代码
  COMPASS_ID: integer = 1; //罗盘的物品代码
  BEGIN_LEAVE_EVENT: integer = 1; //起始离队事件
  BEGIN_BATTLE_ROLE_PIC: integer = 2553; //人物起始战斗贴图
  MAX_LEVEL: integer = 60; //最大等级
  MAX_WEAPON_MATCH: integer = 100; //'武功武器配合'组合的数量
  MAX_LOVER: integer = 23; //情侣加成数量
  MAX_LOVER_STATE: integer = 10;
  MIN_KNOWLEDGE: integer = 80; //最低有效武学常识
  MAX_ITEM_AMOUNT: integer = 304; //最大物品数量
  MAX_HP: integer = 9999; //最大生命
  MAX_MP: integer = 9999; //最大内功
  MaxProList: array[43..58] of integer = (100, 100, 100, 100, 100, 100, 100, 100, 100, 100,
    100, 100, 100, 100, 100, 100);
  //最大攻击值~最大左右互博值
  LIFE_HURT: integer = 100; //伤害值比例
  //以下3个常数实际并未使用, 不能由ini文件指定
  NOVEL_BOOK: integer = 144; //天书起始编码(因偷懒并未使用)
  MAX_HEAD_NUM: integer = 189; //有专有头像的最大人物编号, 仅用于对话指令
  BEGIN_NAME_IN_TALK: integer = 0; //对话文件中记录名字的起始位置
  BEGIN_WALKPIC: integer = 2501; //外景起始的行走贴图
  BEGIN_WALKPIC2: integer = 2501; //内景起始的行走贴图
  //游戏数据
  ACol: array[0..768] of byte;
  ACol1: array[0..768] of byte;
  ACol2: array[0..768] of byte;
  //默认调色板数据, 第一个色调及顺序变化, 第二个仅色调变化, 第三个不可变

  Earth, Surface, Building, BuildX, BuildY, Entrance: array[0..479, 0..479] of smallint;
  //主地图数据
  InShip, Useless1, Mx, My, Sx, Sy, MFace, ShipX, ShipY, ShipX1, ShipY1, ShipFace: smallint;
  //方向
  // 2 0
  // 3 1
  //ShipX1用来保存当前场景, 如果为-1表示处于大地图
  //ShipY1用来保存钱的高位.
  TeamList: array[0..5] of smallint;
  RItemList: array of TItemList;
  Rrole: array[-1..1000] of TRole;
  Ritem: array[-1..1000] of TItem;
  Rscence: array[-1..1000] of TScence;
  Rmagic: array[-1..1000] of TMagic;
  RShop: array[-1..20] of TShop;
  //R文件数据, 均远大于原有容量
  Rrole0: array[-1..1000] of TRole;
  //初始进度的人物, 一般来说敌人会先读取这里
  //Ritem0: array[-1..1000] of TItem;
  //初始进度的物品, 一般来说敌人会先读取这里

  SData: array[0..400, 0..5, 0..63, 0..63] of smallint;
  DData: array[0..400, 0..199, 0..10] of smallint;
  //S, D文件数据
  //S数据: 0-地面, 1-建筑, 2-物品, 3-事件, 4-建筑高度, 5-物品高度
  BField: array[0..8, 0..63, 0..63] of smallint;
  //战场数据
  //0-地面, 1-建筑, 2-人物, 3-可否被选中, 4-攻击范围, 5-备份攻击范围,
  //6-标记第一次不能走到的位置, 7-移动时标记敌人身边的位置, 8-计算与目标的距离用
  WarStaList: array[0..400] of TWarData;
  WarSta: TWarData;
  //战场数据, 即war.sta文件的映像
  LeaveList: array[0..99] of smallint;
  EffectList: array[0..199] of smallint;
  LevelUpList: array[0..99] of smallint;
  //MatchList: array[0..99, 0..2] of smallint;
  //各类列表, 前四个从文件读入

  //SDL使用的主要数据
  event: TSDL_Event;
  //事件
  Font, EngFont: PTTF_Font;
  //字体

  //视频部分设置
  PNG_TILE: integer = 1; //使用PNG贴图, 1-独立PNG文件, 2-打包的imz文件
  PNG_LOAD_ALL: integer = 1; //启动时仅载入部分贴图加快速度
  TRY_FIND_GRP: integer = 1; //当找不到PNG贴图时, 会试图寻找GRP中的图
  BIG_PNG_TILE: integer = 0;
  FULLSCREEN: integer; //是否全屏
  RESOLUTIONX, RESOLUTIONY: integer;
  RENDERER: integer = -1; //选择渲染器 -1-自动, 0-directx, 1-opengl, 2-software
  SW_SURFACE: integer = 0; //绘图方式 0-纹理, 1-表面
  SW_OUTPUT: integer = 0;  //输出方式 0-与渲染器相同 1-表面, SW_SURFACE=1才有效
  SMOOTH: integer = 1; //平滑设置 0-完全不平滑, 1-线性平滑, 2-各项异性平滑

  //ImgScence, ImgScenceBack, ImgBField, ImgBBuild: PSDL_Surface;
  //重画场景和战场的图形映像. 实时重画场景效率较低, 故首先生成映像, 需要时载入
  //Img1在场景中用于副线程动态效果, Img2在战场用于仅保存建筑层以方便快速载入

  ImageWidth, ImageHeight: smallint;  //映像的尺寸, 依据画布分辨率计算得到
  //BlockImg, BlockImg2: array of smallint;
  //BlockScreen: TPosition;
  //场景和战场的遮挡信息, 前者不会记录地板数据, 将需要遮挡的部分的像素记录为该像素隶属物品位置的深度
  //(定义为 depth =  x + y), 该值是决定遮挡的关键部分. 后者仅记录当前屏幕的遮挡深度

  MPicAmount, SPicAmount, {BPicAmount, EPicAmount,} CPicAmount, HPicAmount, IPicAmount: integer;

  //以下是各类贴图内容与索引
  //云的贴图内容及索引
  TDEF, WARFLD, KDEF: TIDXGRP;
  //MPic, SPic, WPic, EPic, FPic, HPic, CPic, KDef, TDef, NameGrp: TByteArray;
  //MIdx, SIdx, WIdx, EIdx, Fidx, HIdx, CIdx, KIdx, TIdx, NameIdx: TIntArray;

  MPNGIndex, SPNGIndex, {BPNGIndex, EPNGIndex,} HPNGIndex, CPNGIndex, TitlePNGIndex, IPNGIndex: TPNGIndexArray;

  EPNGIndex: array[0..200] of TPNGIndexes;
  FPNGIndex: array[0..1000] of TPNGIndexes;

  //BHead: array of PSDL_Surface; //半即时用于画头像

  //音频部分设置
  VOLUME, VOLUMEWAV, SOUND3D: integer; //音乐音量 音效音量 是否启用3D音效
  SoundFlag: longword;

  Music: array of HSTREAM;
  ESound: array of HSAMPLE;
  ASound: array of HSAMPLE;

  StartMusic: integer;
  ExitScenceMusicNum: integer; //离开场景的音乐
  nowmusic: integer = -1; //正在播放的音乐
  //MusicName: string;


  //事件和脚本部分
  x50: array[-$8000..$7FFF] of smallint;
  //扩充指令50所使用的变量
  lua_script: Plua_state;
  //lua脚本
  CurScenceRolePic: integer; //主角场景内当前贴图编号, 引入该常量主要用途是25指令事件号为-1的情况
  NeedRefreshScence: integer = 1; //事件是否改写了贴图

  //游戏体验设置
  CLOUD_AMOUNT: integer = 60; //云的数量
  Cloud: array of TCloud;

  WALK_SPEED, WALK_SPEED2: integer; //行走时的主延时, 如果觉得行走速度慢可以修改这里.
  MMAPAMI: integer; //主地图动态效果
  SCENCEAMI: integer; //场景内动态效果的处理方式: 0-关闭, 1-打开, 2-用另一线程处理, 当明显内场景速度拖慢时可以尝试2
  //updating screen should be in main thread, so this is too complicable.
  SEMIREAL: integer = 0; //半即時
  KDEF_SCRIPT: integer = 0; //使用脚本处理事件
  NIGHT_EFFECT: integer = 0; //是否使用白昼和黑夜效果
  EXIT_GAME: integer = 0; //退出时的提问方式

  //其他
  mutex: PSDL_Mutex;
  ChangeColorList: array[0..1, 0..20] of uint32; //替换色表, 无用
  AskingQuit: boolean = False; //是否正在提问退出
  begin_time: integer; //游戏开始时间, 单位为分钟, 0~1439
  now_time: real;

  //游戏开场时的设置
  TitlePosition: TPosition;
  OpenPicPosition: TPosition;

  //游戏内部运行时使用的数据
  MStep, Still: integer;
  //主地图步数, 是否处于静止
  Cx, Cy, SFace, SStep: integer;
  //场景内坐标, 场景中心点, 方向, 步数
  CurScence, CurEvent, CurItem, CurrentBattle, Where: integer;
  //当前场景, 事件(在场景中的事件号), 使用物品, 战斗
  //where: 0-主地图, 1-场景, 2-战场, 3-开头画面
  SaveNum: integer;
  //存档号, 未使用
  Brole: array[0..99] of TBattleRole;
  //战场人物属性
  //0-人物序号, 1-敌我, 2, 3-坐标, 4-面对方向, 5-是否仍在战场, 6-可移动步数, 7-是否行动完毕,
  //8-贴图(未使用), 9-头上显示数字, 10, 11, 12-未使用, 13-已获得经验, 14-是否自动战斗
  BRoleAmount: integer;
  //战场人物总数
  //AutoMode: array of integer;
  Bx, By, Ax, Ay: integer;
  //当前人物坐标, 选择目标的坐标
  Bstatus: integer;
  //战斗状态, 0-继续, 1-胜利, 2-失败

  //寻路使用的变量表
  linex, liney: array[0..480 * 480 - 1] of smallint;
  nowstep: integer;
  Fway: array[0..479, 0..479] of integer;

  ItemList: array[0..968] of smallint; //物品显示使用的列表


  //以下为在原版基础上的扩展

  BATTLE_SPEED: integer = 10;
  EFFECT_STRING: integer = 0;
  SIMPLE: integer = 0; //简繁
  LoadingScence: boolean;

  LastShowScene: smallint = -1;
  WoodManSta: TWoodMan;

  Star: array[0..107] of WideString;
  RoleName: array[0..107] of WideString;
  loverlist: array[0..24, 0..4] of smallint;
  ScenceAmount: integer;

  SelectAimMode: integer;
  //选择攻击目标的方式, 0-范围内敌方, 1-范围内我方, 2-敌方全部, 3-我方全部, 4-自身, 5-范围内全部, 6-全部

  ShowMR: boolean = True;
  BlackScreen: integer = 0;
  //BlackScr: PSDL_Surface = nil;  //专用于绘制山洞黑幕的表面
  //freshscreen: array of PSDL_Surface;  //用于菜单/事件中快速重画的画面,
  TimeInWater: integer;

  //MenuString, MenuEngString: array of WideString;
  //选单所使用的字符串-应避免使用全局变量

  gamearray: array of array of smallint;

  //snowalpha: array[0..479] of array[0..639] of byte;
  //黑幕遮罩, 似乎未使用
  showBlackScreen: boolean;

  MissionStr: array of WideString;

  LoadingTiles: boolean = True; //表示正在载入贴图
  ReadingTiles: boolean = False;
  LoadingBattleTiles: boolean = False;

  pMPic, pSPic, {pBPic,} pEPic, pHPic, pIPic: PChar; //图片文件保存的位置

  ScreenBlendMode: integer = 0;  //色调 0-白天 1-夜晚 2-黄昏 3-水下

  MenuEscType: integer = -1;
  MenuEscTeammate: integer;  //用于在菜单切换, 以及当前队友
  //-1表示返回Esc菜单, -2表示直接退出Esc菜单
  MenuItemType: integer = 0;  //保存物品分类, 用于在其他位置查看物品
  TitleMenu: array[0..3] of TSDL_Rect;

  TEXT_LAYER: integer = 0;  //文字分层

  HaveText: integer = 1;  //表示目前是否需要文字层

  //ScreenScale: real = 1;

  //FightFrame: array[0..4] of smallint;   //临时使用的战斗帧数

  ZIP_SAVE: integer = 1;  //使用zip存档

  OPEN_MOVIE: integer = 1;

  KEEP_SCREEN_RATIO: integer = 1;  //保持拉伸时的长宽比

  THREAD_READ_PNG: integer = 0;   //线程读取贴图
  DISABLE_MENU_AMI: integer = 0;  //弹出菜单的速度
  //InMenuEsc: integer = 0;  //表示是否处于菜单中, 无需刷新场景

  openAudio: HSTREAM;
  MovieName: string;

  BasicOffset, RoleOffset, ItemOffset, ScenceOffset, MagicOffset, WeiShopOffset, LenR: integer;

  versionstr: WideString = '  108 Brothers and Sisters';

  BattleNames, statestrs: array of WideString;  //状态的字串

  EXPAND_GROUND: integer = 1;
  ExGroundS, ExGroundB: array[-64..127, -64..127] of smallint;  //用来使场景边缘的显示效果改善

  AI_USE_SPECIAL: integer = 1;  //AI是否使用特殊技能
  BattleRound: integer = 0;

  offsetX, offsetY: integer;
  needOffset: integer = 0; //偏移值, 震动效果用

  EventScriptPath: string = 'script/event/ka';
  EventScriptExt: string = '.lua';
  p5032pos: integer = -100;  //脚本用于处理50 32使用
  p5032value: integer = -1;

  pEvent: PChar;

  CHNFONT_SPACEWIDTH: integer;

  window: PSDL_Window;
  render: PSDL_Renderer;

  screenTex, ImgSGroundTex, ImgBGroundTex, TextScreenTex, BlackScreenTex, SimpleStateTex: PSDL_Texture;
  //FreshScreenTex: TList;

  keystate: PChar;
  keyup, keydown, keyright, keyleft: puint8;

  SimpleStatusTex: array[0..5] of PSDL_Texture; //全队简明状态的表面
  SimpleTextTex: array[0..5] of PSDL_Texture; //全队简明状态文字的表面

  CharTex: array[$0..$ffff] of PSDL_Texture;  //字符的纹理
  CharSur: array[$0..$ffff] of PSDL_Surface;  //字符的纹理
  CharSize: array[$0..$ffff] of byte;
  WoodPic: Pointer;   //木人游戏的纹理

  PRESENT_SYNC: integer = 1;    //屏幕刷新同步
  RenderFlag: uint32;
  WindowFlag: uint32;

  LESS_VIDEOMEMERY: integer = 0;  //小显存时需要在出场景时释放一些纹理

  FONT_MEMERY: integer = 1;

  FULL_DESKTOP: integer = 0;

  AUTO_LEVELUP: integer = 0;

  SurfaceFlag: uint32;

  CurTargetSurface, RealScreen, screen, ImgSGround, ImgBGround, TextScreen, BlackScreenSur, SimpleState: PSDL_Surface;
  FreshScreen: TList;
  //含义参考上面

  SimpleStatus: array[0..5] of PSDL_Texture; //全队简明状态的表面
  SimpleText: array[0..5] of PSDL_Texture; //全队简明状态文字的表面

  ForceBattleWin: integer = 0;
  SkipTalk: integer = 0;


  //指针图片
  //CursorSurface: array[0..6] of PSDL_Cursor;

  //其他
  //显示数字: 0-红色负, 1-紫色负, 2-绿色正, 3-黄色正, 4-蓝色负
  tttt, cccc1, cccc2: int64;

  //手柄控制相关
  joy: PSDL_Joystick;
  JOY_RETURN, JOY_ESCAPE, JOY_LEFT, JOY_RIGHT, JOY_UP, JOY_DOWN, JOY_MOUSE_LEFT: uint32;
  JOY_AXIS_DELAY: uint32;

  CellPhone: integer = 0;   //是否移动设备
  ScreenRotate: integer = 0;   //是否正在旋转屏幕

  FingerCount: integer = 0;    //双指操作计数
  FingerTick: uint32 = 0;    //双指操作间隔
  FreeWalking: boolean = False;
  BattleSelecting: boolean = False;   //是否处于战场上选择

  //虚拟按键相关
  ShowVirtualKey: integer = 0;
  VirtualKeyValue: Uint32 = 0;
  VirtualKeyX: integer = 150;
  VirtualKeyY: integer = 250;
  VIrtualKeySize: integer = 60;

const
  //色值蒙版, 注意透明蒙版在创建表面时需设为0而不应用此值
  RMask: uint32 = $FF0000;
  GMask: uint32 = $FF00;
  BMask: uint32 = $FF;
  AMask: uint32 = $FF000000;

implementation


end.
