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
 �κ��˻����ݴ���֮��, ������������ɾ����, ����
 ����, ����Ϊ��������. ���뱣����������.
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

  //�����������;����������÷�ʽ�����ձ������ã����ն�������������

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
  //���¼ӳɣ�loverlevel��
  //0�ӹ���1�ӷ���2���ơ�3������4�书������5�ڹ��ӳɡ�6������ˡ�7�ظ�������8�ظ�������9�Ṧ
  //�ؼ�����״̬��Statelevel��
  //0����,1����,2�Ṧ,3�ƶ�,4�˺�,5��Ѫ,6����
  //7ս��,8����,9��ע,10���,11����,12��â,13����
  //14Ǭ��,15�龫,16����,17����,18����,19����,20����
  //21����,22��Ȼ,23�ȱ�,24����,25,26����,27����


  TWarSta = record
    case TcallType of
      Element: (BattleNum: smallint;
        BattleName: array[0..9] of byte;
        battlemap, exp, battlemusic: smallint;
        mate, automate, mate_x, mate_y: array[0..5] of smallint;
        enemy, enemy_x, enemy_y: array[0..19] of smallint);
      Address: (Data: array[0..$5C] of smallint;)
  end;
  //ս������, ��war.sta�ļ���ӳ��



  TWoodMan = record
    case TcallType of
      Element: (EnemyAmount: byte;
        Exy: array[0..1] of array[0..1] of byte;
        Rx, Ry, ExitX, ExitY: byte;
        GameData: array[0..19 * 19 - 1] of byte);
      Address: (Data: array[0..369] of byte;)
  end; //ľ����Ϸ��ӳ��


  TCloud = record
    Picnum: integer;
    Shadow: integer;
    Alpha: integer;
    MixColor: Uint32;
    MixAlpha: integer;
    Positionx, Positiony, Speedx, Speedy: integer;
  end;

  TPInt1 = procedure(i: integer);


//������Ҫ�ӳ�
procedure Run;
procedure Quit;

//��Ϸ��ʼ����, ���ߵ�
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

//ѡ���ӳ�
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

//ҽ��, �ⶾ, ʹ����Ʒ��Ч����
procedure EffectMedcine(role1, role2: integer);
procedure EffectMedPoision(role1, role2: integer);
procedure EatOneItem(rnum, inum: integer);

//�¼�ϵͳ
procedure CallEvent(num: integer);
procedure ReSetEntrance; //�������
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

  //����Ϊ������, ���ж���������ini�ļ��ı�
  BEGIN_MISSION_NUM: integer = 100; //������ʼ�Ի�
  MISSION_AMOUNT: integer = 100; //������
  STATUS_AMOUNT: integer = 100; //״̬��
  ITEM_BEGIN_PIC: integer = 3445; //��Ʒ��ʼͼƬ
  BEGIN_EVENT: integer = 232; //��ʼ�¼�
  BEGIN_SCENCE: integer = 0; //��ʼ����
  BEGIN_Sx: integer = 20; //��ʼ����(�����е�x, y����Ϸ�����෴��, �������ڵ���������)
  BEGIN_Sy: integer = 19; //��ʼ����
  SOFTSTAR_BEGIN_TALK: integer = 2547; //�������޶Ի��Ŀ�ʼ���
  SOFTSTAR_NUM_TALK: integer = 18; //�������޵ĶԻ�����
  MAX_PHYSICAL_POWER: integer = 100; //�������
  MONEY_ID: integer = 0; //��������Ʒ����
  COMPASS_ID: integer = 1; //���̵���Ʒ����
  BEGIN_LEAVE_EVENT: integer = 950; //��ʼ����¼�
  BEGIN_BATTLE_ROLE_PIC: integer = 2553; //������ʼս����ͼ
  MAX_LEVEL: integer = 301; //���ȼ�
  MAX_WEAPON_MATCH: integer = 34; //'�书�������'��ϵ�����
  MAX_LOVER: integer = 23; //���¼ӳ�����
  MAX_LOVER_STATE: integer = 10;
  MIN_KNOWLEDGE: integer = 80; //�����Ч��ѧ��ʶ
  MAX_ITEM_AMOUNT: integer = 456; //�����Ʒ����
  MAX_HP: integer = 999; //�������
  MAX_MP: integer = 999; //����ڹ�
  SIMPLE: integer = 0; //��
  fullscreen: integer; //�Ƿ�ȫ��
  MaxProList: array[43..58] of integer = (100, 100, 100, 100, 100, 100, 100, 100, 100, 100,
    100, 100, 100, 100, 100, 100);
  //��󹥻�ֵ~������һ���ֵ

  LIFE_HURT: integer = 2; //�˺�ֵ����

  //����3������ʵ�ʲ�δʹ��, ������ini�ļ�ָ��
  NOVEL_BOOK: integer = 144; //������ʼ����(��͵����δʹ��)
  MAX_HEAD_NUM: integer = 189; //��ר��ͷ������������, �����ڶԻ�ָ��
  BEGIN_WALKPIC: integer = 2500; //��ʼ��������ͼ(��δʹ��)

  MPic, SPic, WPic, EPic: array[0..10000000] of byte;
  MIdx, SIdx, WIdx, EIdx: array[0..10000] of integer;
  FPic: array[0..1000000] of byte;
  FIdx: array[0..300] of integer;
  HPic: array[0..2000000] of byte;
  HIdx: array[0..500] of integer;
  //����Ϊ��ͼ�����ݼ�����
  Earth, Surface, Building, BuildX, BuildY, Entrance: array[0..479, 0..479] of smallint;
  //����ͼ����
  ACol, ACol1, ACol2: array[0..768] of byte;
  //Ĭ�ϵ�ɫ������
  LastShowScene: smallint = -1;
  InShip, Useless1, Mx, My, Sx, Sy, MFace, ShipX, ShipY, ShipX1, ShipY1, ShipFace: smallint;
  TeamList: array[0..5] of smallint;
  RItemList: array of TItemList;
  WoodManSta: TWoodMan;
  MStep: integer = 1;
  Still: integer;
  //����ͼ����, ����, ����, �Ƿ��ھ�ֹ
  Cx, Cy, SFace, SStep: integer;
  //����������, �������ĵ�, ����, ����
  CurScence, CurEvent, CurItem, CurrentBattle, Where: integer;
  //��ǰ����, �¼�(�ڳ����е��¼���), ʹ����Ʒ, ս��
  //where: 0-����ͼ, 1-����, 2-ս��, 3-��ͷ����
  SaveNum: integer;
  //�浵��, δʹ��
  RRole: array[0..1000] of TRole;
  RItem: array[0..1000] of TItem;
  RScence: array[0..1000] of TScence;
  RMagic: array[0..1000] of TMagic;
  RShop: array[0..20] of TShop;
  //R�ļ�����, ��Զ����ԭ������
  ItemList: array[0..500] of smallint;
  ScenceAmount: integer;
  SData: array[0..400, 0..5, 0..63, 0..63] of smallint;
  DData: array[0..400, 0..199, 0..10] of smallint;
  //S, D�ļ�����
  //Scence1, SData[CurScence, 1, , Scence3, Scence4, Scence5, Scence6, Scence7, Scence8: array[0..63, 0..63] of smallint;
  //��ǰ��������
  //0-����, 1-����, 2-��Ʒ, 3-�¼�, 4-�����߶�, 5-��Ʒ�߶�
  ScenceImg, ScenceImg2: array[0..2303, 0..1401] of Uint32;
  //ScenceImgEx: array[0..2303, -250..-1] of Uint32;
  //������ͼ��ӳ��. ʵʱ�ػ�����Ч�ʽϵ�, ����������ӳ��, ��Ҫʱ����
  //ScenceD: array[0..199, 0..10] of smallint;
  //��ǰ�����¼�
  BFieldImg: array[0..2303, 0..1401] of Uint32;
  //ս��ͼ��ӳ��

  BlockImg, BlockImg2: array[0..2303, 0..1401] of integer;
  BlockScreen: array of integer;
  //������ս�����ڵ���Ϣ, ǰ�߲����¼�ذ�����, ����Ҫ�ڵ��Ĳ��ֵ����ؼ�¼Ϊ������������Ʒλ�õ����
  //(����Ϊ depth =  x + y), ��ֵ�Ǿ����ڵ��Ĺؼ�����. ���߽���¼��ǰ��Ļ���ڵ����

  BField: array[0..7, 0..63, 0..63] of smallint;
  //ս������
  //0-����, 1-����, 2-����, 3-�ɷ�ѡ��, 4-������Χ, 5, 6 ,7-δʹ��
  WarSta: TwarSta;
  //ս������, ��war.sta�ļ���ӳ��
  BRole: array[0..99] of TBattleRole;
  //ս����������
  //0-�������, 1-����, 2, 3-����, 4-��Է���, 5-�Ƿ�����ս��, 6-���ƶ�����, 7-�Ƿ��ж����,
  //8-��ͼ(δʹ��), 9-ͷ����ʾ����, 10, 11, 12-δʹ��, 13-�ѻ�þ���, 14-�Ƿ��Զ�ս��
  BRoleAmount: integer;
  //ս����������
  Bx, By, Ax, Ay: integer;
  //��ǰ��������, ѡ��Ŀ�������
  Bstatus: integer;
  //ս��״̬, 0-����, 1-ʤ��, 2-ʧ��
  SelectAimMode: integer;
  //ѡ�񹥻�Ŀ��ķ�ʽ, 0-��Χ�ڵз�, 1-��Χ���ҷ�, 2-�з�ȫ��, 3-�ҷ�ȫ��, 4-����, 5-��Χ��ȫ��, 6-ȫ��
  //����
  HighLight: boolean = False;
  LeaveList: array[0..99] of smallint;
  EffectList: array[0..199] of smallint;
  LevelUpList: array[0..99] of smallint;
  MatchList: array[0..99, 0..2] of smallint;
  //�����б�, ǰ�ĸ����ļ�����
  Star: array[0..107] of WideString;
  RoleName: array[0..107] of WideString;
  loverlist: array[0..24, 0..4] of smallint;

  ShowMR: boolean = True;
  blackscreen: integer = 0;
  screen, RealScreen, prescreen: PSDL_Surface;
  //������
  event: TSDL_Event;
  //�¼�
  Font, EngFont: PTTF_Font;
  TextColor: TSDL_Color;
  Text: PSDL_Surface;
  //����

  Music: array[0..99] of HSTREAM;
  ESound: array[0..99] of HSAMPLE;
  ASound: array[0..99] of HSAMPLE;
  //����
  ExitScenceMusicNum: integer;
  //�뿪����������
  MusicName: string;
  time: integer;
  MenuString, MenuEngString: array of WideString;
  //ѡ����ʹ�õ��ַ���
  x50: array[-$8000..$7FFF] of smallint;
  //����ָ��50��ʹ�õı���
  gamearray: array of array of smallint;
  snowalpha: array[0..479] of array[0..639] of byte;
  //��Ļ����
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
  versionstr: WideString = '������ v2.12 (20130331)';
  kkey: array[0..69] of byte = (8, 32, 60, 3, 1, 22, 6, 53, 65, 29, 67, 38, 20, 9, 50, 35,
    16, 14, 52, 7, 68, 62, 37, 61, 21, 47, 27, 44, 0, 13, 5, 40, 25, 51, 59, 56, 30, 17, 55,
    64, 46, 42, 45, 15, 39, 48, 41, 24, 26, 54, 66, 36, 49, 69, 10, 34, 2, 63, 33, 11, 23,
    31, 58, 19, 57, 28, 43, 18, 12, 4);

  VOLUME, VOLUMEWAV, SOUND3D, eaxon: integer;
  SoundFlag: longword;

  FWay: array[0..479, 0..479] of smallint;
  linex, liney: array[0..480 * 480 - 1] of smallint;
  nowstep: integer;

  GLHR: integer = 1; //�Ƿ�ʹ��OPENGL��ͼ
  SMOOTH: integer = 1; //ƽ������ 0-��ƽ��, 1-ƽ��

  ScreenFlag: Uint32;
  RESOLUTIONX: integer;
  RESOLUTIONY: integer;

  RegionRect: TSDL_Rect; //ָ��ˢ�·�Χ


  CPic: array[0..100000] of byte;
  CIdx: array[0..20] of integer;
  //�Ƶ���ͼ���ݼ�����
  KDef: array[0..1000000] of byte;
  KIdx: array[0..20000] of integer;
  //�¼������ݼ�����
  TDef: array[0..1000000] of byte;
  Tidx: array[0..20000] of integer;
  //�Ի������ݼ�����

  CLOUD_AMOUNT: integer = 60; //�Ƶ�����
  Cloud: array of TCloud;

  AppPath: string;

  WALK_SPEED1: integer = 10;
  WALK_SPEED2: integer = 10;
  BATTLE_SPEED: integer = 10;
  MMAPAMI: integer = 1;
  SCENCEAMI: integer = 1;
  EFFECT_STRING: integer = 0;

  SEMIREAL: integer = 0;
  BHead: array of PSDL_Surface; //�뼴ʱ���ڻ�ͷ��

  AskingQuit: boolean;
  NeedRefreshScence: integer;

  begin_time: integer; //��Ϸ��ʼʱ��, ��λΪ����, 0~1439
  now_time: real;
  NIGHT_EFFECT: integer = 1; //�Ƿ�ʹ�ð���ͺ�ҹЧ��

  EXIT_GAME: integer = 0; //�˳�ʱ�����ʷ�ʽ
  KDEF_SCRIPT: integer = 0;

implementation

uses kys_script, kys_event, kys_engine, kys_battle;

//��ʼ������, ��Ч, ��Ƶ, ������Ϸ

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
  //��ʼ������
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

  //��ʼ����Ƶϵͳ
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

  //��ʼ����Ƶϵͳ
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

//�ر������Ѵ򿪵���Դ, �˳�

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
//��ʾ��ͷ����

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
  //�¼��ȴ�
  SDL_EnableKeyRepeat(20, 100);
  into := False;
  while (SDL_WaitEvent(@event) >= 0) do
  begin
    //redraw;
    into := False;
    //�رմ����¼�
    CheckBasicEvent;

    //��ѡ���2��, ���˳�(���б�Ŵ�0��ʼ)
    if (((event.type_ = SDL_KEYUP) and ((event.key.keysym.sym = sdlk_return) or
      (event.key.keysym.sym = sdlk_space))) or ((event.type_ = SDL_MOUSEBUTTONUP) and
      (event.button.button = sdl_button_left))) and (menu = 2) then
    begin
      break;
    end;
    //ѡ���0��, ���¿�ʼ��Ϸ
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
    //ѡ���1��, �������
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
    //���·������
    if ((event.type_ = SDL_KEYUP) and (event.key.keysym.sym = sdlk_up)) then
    begin
      menu := menu - 1;
      if menu < 0 then
        menu := 2;
      drawtitlepic(0, x, y);
      drawtitlepic(menu + 1, x, y + menu * 20);
      SDL_UpdateRect2(screen, 0, 0, screen.w, screen.h);
    end;
    //���·������
    if ((event.type_ = SDL_KEYUP) and (event.key.keysym.sym = sdlk_down)) then
    begin
      menu := menu + 1;
      if menu > 2 then
        menu := 0;
      drawtitlepic(0, x, y);
      drawtitlepic(menu + 1, x, y + menu * 20);
      SDL_UpdateRect2(screen, 0, 0, screen.w, screen.h);
    end;
    //����ƶ�
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

//��ͷ��Ļ

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

//��ȡ������ļ�

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
    //��Ʒ��ʼͼƬ
    ITEM_BEGIN_PIC := 5720;
    //��ʼ�¼�
    BEGIN_EVENT := 301;
    //��ʼ����
    BEGIN_SCENCE := 0;
    //��ʼ����(�����е�x,y����Ϸ�����෴��,�������ڵ���������)
    BEGIN_Sx := 20;
    BEGIN_Sy := 19;
    //�������޶Ի��Ŀ�ʼ���
    SOFTSTAR_BEGIN_TALK := 2547;
    //�������޵ĶԻ�����
    SOFTSTAR_NUM_TALK := 18;
    //�������
    MAX_PHYSICAL_POWER := 100;
    //��������Ʒ����
    MONEY_ID := 0;
    //���̵���Ʒ����
    COMPASS_ID := 1;
    //��ʼ����¼�
    BEGIN_LEAVE_EVENT := 1;
    //������ʼս����ͼ
    BEGIN_BATTLE_ROLE_PIC := 2553;
    //���ȼ�
    MAX_LEVEL := 60;
    //'�书�������'��ϵ�����
    MAX_WEAPON_MATCH := 100;
    //�����Ч��ѧ��ʶ
    MIN_KNOWLEDGE := 80;
    //�����Ʒ����
    MAX_ITEM_AMOUNT := 456;
    //�˺�ֵ����
    LIFE_HURT := 100;
    //�������
    MAX_HP := 9999;
    //����ڹ�
    MAX_MP := 9999;
    //����
    MaxProList[43] := 999;
    //�Ṧ
    MaxProList[44] := 500;
    //����
    MaxProList[45] := 999;
    //ҽ��
    MaxProList[46] := 200;
    //�ö�
    MaxProList[47] := 100;
    //�ⶾ
    MaxProList[48] := 100;
    //����
    MaxProList[49] := 100;
    //ȭ��
    MaxProList[50] := 999;
    //����
    MaxProList[51] := 999;
    //ˣ��
    MaxProList[52] := 999;
    //����
    MaxProList[53] := 999;
    //����
    MaxProList[54] := 999;
    //��ʶ
    MaxProList[55] := 100;
    //Ʒ��
    MaxProList[56] := 100;
    //����
    MaxProList[57] := 100;
    //����
    MaxProList[58] := 200;
    //�����б���
    MISSION_AMOUNT := 49;
    //״̬����
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

  //��������ͳһΪ1000��
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

  Star[0] := '�����';
  Star[1] := '�����';
  Star[2] := '�����';
  Star[3] := '������';
  Star[4] := '������';
  Star[5] := '������';
  Star[6] := '������';
  Star[7] := '������';
  Star[8] := '��Ӣ��';
  Star[9] := '�����';
  Star[10] := '�츻��';
  Star[11] := '������';
  Star[12] := '�����';
  Star[13] := '������';
  Star[14] := '������';
  Star[15] := '�����';
  Star[16] := '�찵��';
  Star[17] := '��v��';
  Star[18] := '�����';
  Star[19] := '������';
  Star[20] := '������';
  Star[21] := '��ɱ��';
  Star[22] := '��΢��';
  Star[23] := '�쾿��';
  Star[24] := '������';
  Star[25] := '������';
  Star[26] := '�콣��';
  Star[27] := '��ƽ��';
  Star[28] := '������';
  Star[29] := '������';
  Star[30] := '�����';
  Star[31] := '������';
  Star[32] := '�����';
  Star[33] := '�챩��';
  Star[34] := '�����';
  Star[35] := '������';
  Star[36] := '�ؿ���';
  Star[37] := '��ɷ��';
  Star[38] := '������';
  Star[39] := '�ؽ���';
  Star[40] := '������';
  Star[41] := '������';
  Star[42] := '��Ӣ��';
  Star[43] := '������';
  Star[44] := '������';
  Star[45] := '������';
  Star[46] := '������';
  Star[47] := '������';
  Star[48] := '������';
  Star[49] := '��ǿ��';
  Star[50] := '�ذ���';
  Star[51] := '������';
  Star[52] := '�ػ���';
  Star[53] := '������';
  Star[54] := '������';
  Star[55] := '������';
  Star[56] := '������';
  Star[57] := '��΢��';
  Star[58] := '�ػ���';
  Star[59] := '�ر���';
  Star[60] := '��Ȼ��';
  Star[61] := '�ز���';
  Star[62] := '�ؿ���';
  Star[63] := '�ط���';
  Star[64] := '������';
  Star[65] := '������';
  Star[66] := '������';
  Star[67] := '�ؽ���';
  Star[68] := '������';
  Star[69] := '������';
  Star[70] := '������';
  Star[71] := '������';
  Star[72] := '������';
  Star[73] := '������';
  Star[74] := '������';
  Star[75] := '�ؿ���';
  Star[76] := '������';
  Star[77] := '�ؽ���';
  Star[78] := '������';
  Star[79] := '������';
  Star[80] := '�ػ���';
  Star[81] := '��ħ��';
  Star[82] := '������';
  Star[83] := '������';
  Star[84] := '�ط���';
  Star[85] := '�ؿ���';
  Star[86] := '��Ƨ��';
  Star[87] := '��ȫ��';
  Star[88] := '�ع���';
  Star[89] := '�ؽ���';
  Star[90] := '�ض���';
  Star[91] := '�ز���';
  Star[92] := '������';
  Star[93] := '��ƽ��';
  Star[94] := '������';
  Star[95] := '��ū��';
  Star[96] := '�ز���';
  Star[97] := '�ض���';
  Star[98] := '�س���';
  Star[99] := '������';
  Star[100] := '������';
  Star[101] := '������';
  Star[102] := '��׳��';
  Star[103] := '������';
  Star[104] := '�ؽ���';
  Star[105] := '�غ���';
  Star[106] := '������';
  Star[107] := '�ع���';
  {  RoleName[0] := '����';
    RoleName[1] := '����';
    RoleName[2] := '����';
    RoleName[3] := 'ΤС��';
    RoleName[4] := 'ʯ����';
    RoleName[5] := 'Ԭ��־';
    RoleName[6] := '���';
    RoleName[7] := '���޼�';
    RoleName[8] := '�����';
    RoleName[9] := '����';
    RoleName[10] := '����';
    RoleName[11] := '����';
    RoleName[12] := 'С��Ů';
    RoleName[13] := '���';
    RoleName[14] := '��ӯӯ';
    RoleName[15] := '�¼���';
    RoleName[16] := '������';
    RoleName[17] := '����';
    RoleName[18] := '������';
    RoleName[19] := '����';
    RoleName[20] := 'С��';
    RoleName[21] := '����';
    RoleName[22] := '����';
    RoleName[23] := 'Ԭ����';
    RoleName[24] := '������';
    RoleName[25] := '������';
    RoleName[26] := '���л�';
    RoleName[27] := 'Ԭ����';
    RoleName[28] := '����';
    RoleName[29] := '����';
    RoleName[30] := 'ˮ��';
    RoleName[31] := '������';
    RoleName[32] := '˫��';
    RoleName[33] := '������';
    RoleName[34] := '����ͩ';
    RoleName[35] := '����';
    RoleName[36] := 'лѷ';
    RoleName[37] := '����';
    RoleName[38] := '��ң';
    RoleName[39] := '����';
    RoleName[40] := '�½���';
    RoleName[41] := '������';
    RoleName[42] := '׿����';
    RoleName[43] := 'ΤһЦ';
    RoleName[44] := '���';
    RoleName[45] := '������';
    RoleName[46] := '�޳�';
    RoleName[47] := '½�˷�';
    RoleName[48] := '�԰�ɽ';
    RoleName[49] := '��̩��';
    RoleName[50] := '������';
    RoleName[51] := 'Ī��';
    RoleName[52] := '���';
    RoleName[53] := '����';
    RoleName[54] := '����ͬ';
    RoleName[55] := '������';
    RoleName[56] := '����';
    RoleName[57] := 'ʯ��';
    RoleName[58] := '����';
    RoleName[59] := '����';
    RoleName[60] := '�����Ľ�';
    RoleName[61] := '�ܵ�';
    RoleName[62] := '����ͨ';
    RoleName[63] := '�����';
    RoleName[64] := '½��˫';
    RoleName[65] := '�밢��';
    RoleName[66] := '˵����';
    RoleName[67] := '�����';
    RoleName[68] := '������';
    RoleName[69] := '½��Ӣ';
    RoleName[70] := '��ң��';
    RoleName[71] := '��Ө��';
    RoleName[72] := 'ƽһָ';
    RoleName[73] := '���˿';
    RoleName[74] := 'ѦĽ��';
    RoleName[75] := 'Ү����';
    RoleName[76] := '������';
    RoleName[77] := 'ľ����';
    RoleName[78] := '�ﲮ��';
    RoleName[79] := '���ϴ�';
    RoleName[80] := '������';
    RoleName[81] := '������';
    RoleName[82] := '������';
    RoleName[83] := '���ѹ�';
    RoleName[84] := '����ţ';
    RoleName[85] := '����';
    RoleName[86] := '��ǫ';
    RoleName[87] := '�����';
    RoleName[88] := '����';
    RoleName[89] := '����';
    RoleName[90] := '����';
    RoleName[91] := '�����';
    RoleName[92] := '����';
    RoleName[93] := 'ʯ��¶';
    RoleName[94] := '��Ĭ��';
    RoleName[95] := '����';
    RoleName[96] := '������';
    RoleName[97] := '��ܽ';
    RoleName[98] := '�����';
    RoleName[99] := '����';
    RoleName[100] := 'Τ����';
    RoleName[101] := '�����';
    RoleName[102] := '������';
    RoleName[103] := '��ͷ��';
    RoleName[104] := '��ǧ��';
    RoleName[105] := '�ҹ�����';
    RoleName[106] := '������';
    RoleName[107] := '̫������';   }


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




//��ʼ����������

function InitialRole: boolean;
var
  i, x, y: integer;
  p: array[0..14] of integer;
  str, str0, Name: WideString;
  str1: string;
  p0, p1: PChar;
begin
  LoadR(0);
  //��ʾ���������ĶԻ���
  //form1.ShowModal;
  //str := form1.edit1.text;
  //showmessage(inttostr(where));
  if fullscreen = 1 then
    realscreen := SDL_SetVideoMode(RESOLUTIONX, RESOLUTIONY, 32, ScreenFlag);

  str1 := 'ʒЦ��'; //Ĭ����
  str := 'Ոݔ������֮����              ';
  if SIMPLE = 1 then
  begin
    str1 := '��Ц��'; //Ĭ����
    str := '����������֮����              ';
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
    str := ' �Y�|';
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
      str0 := '�x�����Ժ�Y�I�_�J';
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

    //�趨��ʼ�ɳ�
    initgrowth();

    if Name = '���p��' then
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

    if Name = '�L����' then
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

//����浵, ��Ϊ0�������ʼ�浵

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

  //��ʼ�����

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

//�浵

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

//�ȴ����ⰴ��

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

//������ͼ����


//������ͼ����

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
  //�¼���ѯ(���ǵȴ�)
  while SDL_PollEvent(@event) >= 0 do
  begin
    needrefresh := 0;

    //����ͼ��̬Ч��, ʵ�ʽ������ǵĶ���
    now := sdl_getticks;

    //��˸Ч��
    if (integer(now - next_time2) > 0) then
    begin
      ChangeCol;
      next_time2 := now + 200;
      //needrefresh := 1;
      //DrawMMap;
    end;

    //Ʈ��
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
      //�����ʹ��ѹ�°����¼�
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
      //���ܼ�(esc)ʹ���ɿ������¼�
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
              menustring[0] := UTF8Decode(' �غ���');
              menustring[1] := UTF8Decode(' �뼴�r');
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
            menustring[0] := UTF8Decode(' �����Ч���_');
            menustring[1] := UTF8Decode(' �����Ч���P');
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
            menustring[0] := UTF8Decode(' ���w��');
            menustring[1] := UTF8Decode(' ���w��');
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
            menustring[0] := UTF8Decode(' �[���ٶȣ���');
            menustring[1] := UTF8Decode(' �[���ٶȣ���');
            menustring[2] := UTF8Decode(' �[���ٶȣ���');
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
      //�簴��������, ����״̬Ϊ����
      //���ɿ�������, ����״̬Ϊ������
      //�Ҽ������ϵͳѡ��
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
      //ÿ��һ�����ػ���Ļ, ������Ƿ���ĳ�������
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
      //ÿ��һ�����ػ���Ļ, ������Ƿ���ĳ�������
      if CheckEntrance then
        walking := 0;
      DrawMMap;
      SDL_UpdateRect2(screen, 0, 0, screen.w, screen.h);
    end;

    //�����ǰ���ڱ��⻭��, ���˳�, ����ս��ʧ��
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
      SDL_Delay(40); //��ֹʱֻ��ˢ��������Ƶ���Ķ�̬Ч����ͬ����
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
    //�¼���ѯ(���ǵȴ�)
  while SDL_PollEvent(@event) >= 0 do
  begin
    //�����ǰ���ڱ��⻭��, ���˳�, ����ս��ʧ��
    if where >= 3 then
    begin
      break;
    end;
    //����ͼ��̬Ч��, ʵ�ʽ������ǵĶ���
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
    //���������������, ���������λ���ƶ�����, ������ʹ���������
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

      //ÿ��һ�����ػ���Ļ, ������Ƿ���ĳ�������
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
      //�����ʹ��ѹ�°����¼�
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
      //���ܼ�(esc)ʹ���ɿ������¼�
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
      //���ɿ�������, ����״̬Ϊ������
      //�Ҽ������ϵͳѡ��
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
      //�簴��������, ����״̬Ϊ����
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

//�ж�����ͼĳ��λ���ܷ�����, �Ƿ��ɴ�
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
//����Ƿ���ĳ���, ���Ƿ��ɽ�������

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
    //�Ƿ������Ṧ����70
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
      //��������, ���볡������ʼ����������
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
//���ڳ�������, �����Ϊ1��ʾ����Ϸ

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
  //�Ƿ��е�3���¼�λ�ڳ������


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
    //�����ڶ�̬Ч��
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
          //���������ӵĶ�̬Ч��, ����ͼ̫�󲻺ô���
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

    //����Ƿ�λ�ڳ���, �������˳�
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
    //����Ƿ�λ����ת��, ���������³�ʼ������
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

    //�Ƿ�������״̬, �ο�Walk
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
        //����Ƿ���Left Alt+Enter, �����л�ȫ��/����(�ƺ�����������Ч)
          {if (event.key.keysym.sym = sdlk_return) and (event.key.keysym.modifier = kmod_lalt) then
          begin
            if fullscreen = 1 then
              screen := SDL_SetVideoMode(CENTER_X * 2, CENTER_Y * 2, 32, SDL_SWSURFACE or SDL_DOUBLEBUF or SDL_ANYFORMAT)
            else
              screen := SDL_SetVideoMode(CENTER_X * 2, CENTER_Y * 2, 32, SDL_FULLSCREEN);
            fullscreen := 1 - fullscreen;
          end;}
        //���»س���ո�, �����Է����Ƿ��е�1���¼�
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

    //�Ƿ�������״̬
    if walking = 2 then
    begin
      speed := speed + 1;
      //stillcount := 0;
      {if walking = 2 then //�������������÷���
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
      //һ������֮��һ�ζ�һ��
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


  turnblack; //����

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
    //��ʾ������
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
    //�ı�����
    if Rscence[snum].EntranceMusic >= 0 then
    begin
      stopmp3;
      playmp3(Rscence[snum].EntranceMusic, -1);
    end;
    SDL_Delay(500);
  end;
end;

//�ж�������ĳ��λ���ܷ�����

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
  //ֱ���ж���ͼ��Χ
  if ((SData[CurScence, 0, x, y] >= 358) and (SData[CurScence, 0, x, y] <= 362)) or
    (SData[CurScence, 0, x, y] = 522) or (SData[CurScence, 0, x, y] = 1022) or
    ((SData[CurScence, 0, x, y] >= 1324) and (SData[CurScence, 0, x, y] <= 1330)) or
    (SData[CurScence, 0, x, y] = 1348) then
    Result := False;
  //if SData[CurScence, 0, x, y] = 1358 * 2 then result := true;

end;

//����Ƿ��е�1���¼�, ���������

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
  //����������¼�
  if SData[CurScence, 3, x, y] >= 0 then
  begin
    CurEvent := SData[CurScence, 3, x, y];
    if DData[CurScence, CurEvent, 2] >= 0 then
      callevent(DData[CurScence, SData[CurScence, 3, x, y], 2]);
  end;
  CurEvent := -1;
end;

//����Ƿ��е�3���¼�, ���������

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
//ͨ��ѡ��, (λ��(x, y), ���, ���ѡ��(��ž���0��ʼ))
//ʹ��ǰ��������ѡ��ʹ�õ��ַ��������Ч, �ַ����鲻��Խ��ʹ��

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
  //��ռ��̼�������ֵ, ����Ӱ�����ಿ��
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

  //��ռ��̼�������ֵ, ����Ӱ�����ಿ��
  event.key.keysym.sym := 0;
  event.button.button := 0;
  //{$IFDEF DARWIN}
  RegionRect.w := 0;
  RegionRect.h := 0;
  //{$ENDIF}
end;

//��ʾͨ��ѡ��(λ��, ���, ���ֵ)
//���ͨ��ѡ�����������ַ�����, �ɷֱ���ʾ���ĺ�Ӣ��

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

  //��ռ��̼�������ֵ, ����Ӱ�����ಿ��
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

//��ѡ��

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
  //��ռ��̼�������ֵ, ����Ӱ�����ಿ��
  event.key.keysym.sym := 0;
  event.button.button := 0;
  SDL_EnableKeyRepeat(30, 30);

end;

//��ѡ��

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
  //��ռ��̼�������ֵ, ����Ӱ�����ಿ��
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

//��������ѡ��ĺ���ѡ��, Ϊ����ʹ�ú���
//����ѡ����ÿ��ѡ������Ϊ����������, ������������'����', 'ȡ��'�����

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
  //��ռ��̼�������ֵ, ����Ӱ�����ಿ��
  event.key.keysym.sym := 0;
  event.button.button := 0;
  SDL_EnableKeyRepeat(30, 30);

end;

//��ʾ��������ѡ��ĺ���ѡ��

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

//��������ѡ��ĺ���ѡ��, Ϊ����ʹ�ú���
//����ѡ����ÿ��ѡ������Ϊ����������, ������������'����', 'ȡ��'�����

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
  //��ռ��̼�������ֵ, ����Ӱ�����ಿ��
  event.key.keysym.sym := 0;
  event.button.button := 0;

end;

//��ʾ��������ѡ��ĺ���ѡ��

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

//ѡ��һ����Ա, ���Ը�������������ʾ

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

//��ѡ��

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

//��ʾ��ѡ��

procedure ShowMenu(menu: integer);
var
  word: array[0..5] of WideString;
  i, max: integer;
begin
  word[0] := ' �t��';
  word[1] := ' �ⶾ';
  word[2] := ' ��Ʒ';
  word[3] := ' ��B';
  //Word[4] := ' �x�';
  word[4] := ' ϵ�y';
  if where = 0 then
    max := 4
  else
    max := 4;
  ReDraw;
  DrawRectangle(27, 30, 48, max * 22 + 28, 0, colcolor(255), 30);
  //��ǰ����λ���ð�ɫ, �����û�ɫ
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

//ҽ��ѡ��, ������ѡ���Ա

procedure MenuMedcine;
var
  role1, role2, menu: integer;
  str: WideString;
begin
  str := ' ꠆T�t������';
  drawtextwithrect(@str[1], 80, 30, 132, colcolor($21), colcolor($23));
  menu := SelectOneTeamMember(80, 65, '%3d', 46, 0);
  showmenu(0);
  SDL_UpdateRect2(screen, 0, 0, screen.w, screen.h);
  if menu >= 0 then
  begin
    role1 := TeamList[menu];
    str := ' ꠆TĿǰ����';
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

//�ⶾѡ��

procedure MenuMedPoision;
var
  role1, role2, menu: integer;
  str: WideString;
begin
  str := ' ꠆T�ⶾ����';
  drawtextwithrect(@str[1], 80, 30, 132, colcolor($21), colcolor($23));
  menu := SelectOneTeamMember(80, 65, '%3d', 48, 0);
  showmenu(1);
  SDL_UpdateRect2(screen, 0, 0, screen.w, screen.h);
  if menu >= 0 then
  begin
    role1 := TeamList[menu];
    str := ' ꠆T�ж��̶�';
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

//��Ʒѡ��

function MenuItem: boolean;
var
  point, atlu, x, y, col, row, xp, yp, iamount, menu, max, xm, ym, i: integer;
  //point�ƺ�δʹ��, atluΪ�������Ͻǵ���Ʒ���б��е����, x, yΪ���λ��
  //col, rowΪ������������
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
      menustring[0] := (' ȫ����Ʒ');
      menustring[1] := (' ������Ʒ');
      menustring[2] := (' �������');
      menustring[3] := (' �书����');
      menustring[4] := (' �`����ˎ');
      menustring[5] := (' ���˰���');
      xm := 80;
      ym := 30;

    end;
    2:
    begin
      max := 1;
      setlength(menustring, max + 1);
      menustring[0] := (' �`����ˎ');
      menustring[1] := (' ���˰���');
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
              //����ƶ�ʱ����x, y�����仯ʱ���ػ�
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

//����Ʒ�б�, ��Ҫ��ս����������һ������Ʒ
//����һ���������õ�����ֵ��100������ʾ��ȡ������Ʒ

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

//��ʾ��Ʒѡ��

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
  words[0] := ' ������Ʒ';
  words[1] := ' �������';
  words[2] := ' �书����';
  words[3] := ' �`����ˎ';
  words[4] := ' ���˰���';
  words2[0] := ' ����';
  words2[1] := ' ����';
  words2[2] := ' �ж�';
  words2[3] := ' �w��';
  words2[4] := ' ����';
  words2[5] := ' ����';
  words2[6] := ' ����';
  words2[7] := ' ����';
  words2[8] := ' �p��';
  words2[9] := ' ���R';
  words2[10] := ' �t��';
  words2[11] := ' �ö�';
  words2[12] := ' �ⶾ';
  words2[13] := ' ����';
  words2[14] := ' ȭ��';
  words2[15] := ' ����';
  words2[16] := ' ˣ��';
  words2[17] := ' ����';
  words2[18] := ' ����';
  words2[19] := ' ��W';
  words2[20] := ' Ʒ��';
  words2[21] := ' �Ƅ�';
  words2[22] := ' ����';

  words3[0] := ' ����';
  words3[1] := ' ����';
  words3[2] := ' ����';
  words3[3] := ' �p��';
  words3[4] := ' �ö�';
  words3[5] := ' �t��';
  words3[6] := ' �ⶾ';
  words3[7] := ' ȭ��';
  words3[8] := ' ����';
  words3[9] := ' ˣ��';
  words3[10] := ' ����';
  words3[11] := ' ����';
  words3[12] := ' �Y�|';

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
    //������ʹ������ʾ
    if RItem[item].User >= 0 then
    begin
      str := ' ʹ���ˣ�';
      drawshadowtext(@str[1], 142, 115 + row * 50, colcolor($21), colcolor($23));
      drawbig5shadowtext(@rrole[RItem[item].User].Name, 232, 115 + row * 50, colcolor($64), colcolor($66));
    end;
    //������������ʾ����
    if item = COMPASS_ID then
    begin
      str := ' ���λ�ã�';
      drawshadowtext(@str[1], 142, 115 + row * 50, colcolor($21), colcolor($23));
      str := format('%3d, %3d', [My, Mx]);
      drawengshadowtext(@str[1], 262, 115 + row * 50, colcolor($64), colcolor($66));

      str := ' ����λ�ã�';
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
            0: str := '    �';
            1: str := '    �';
            2: str := '  �{��';
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
            0: str := '    �';
            1: str := '    �';
            2: str := '  �{��';
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


//����ɫ�߿���Ϊ��Ʒѡ���Ĺ��

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

//ʹ����Ʒ

procedure UseItem(inum: integer);
var
  x, y, menu, rnum, p: integer;
  str, str1: WideString;
begin
  CurItem := inum;

  case RItem[inum].ItemType of
    0: //������Ʒ
    begin
      //��ĳ���Դ���0, ֱ�ӵ����¼�
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
          //������λ���е�2���¼������
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
    1: //װ��
    begin
      menu := 1;
      if Ritem[inum].User >= 0 then
      begin
        setlength(menustring, 2);
        menustring[0] := ' ȡ��';
        menustring[1] := ' �^�m';
        str := ' ����Ʒ�������b�䣬�Ƿ��^�m��';
        drawtextwithrect(@str[1], 80, 30, 285, colcolor(7), colcolor(5));
        menu := commonmenu(80, 65, 45, 1);
      end;
      if menu = 1 then
      begin
        str := ' �lҪ�b��';
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
            str := ' ���˲��m���b�����Ʒ';
            drawtextwithrect(@str[1], 80, 30, 205, colcolor($64), colcolor($66));
            waitanykey;
            redraw;
            //SDL_UpdateRect2(screen,0,0,screen.w,screen.h);
          end;
        end;
      end;
    end;
    2: //����
    begin
      menu := 1;
      if Ritem[inum].User >= 0 then
      begin
        setlength(menustring, 2);
        menustring[0] := ' ȡ��';
        menustring[1] := ' �^�m';
        str := ' �������������ޟ����Ƿ��^�m��';
        drawtextwithrect(@str[1], 80, 30, 285, colcolor(7), colcolor(5));
        menu := commonmenu(80, 65, 45, 1);
      end;
      if menu = 1 then
      begin
        str := ' �lҪ�ޟ�';
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
            str := ' ���˲��m���ޟ�������';
            drawtextwithrect(@str[1], 80, 30, 205, colcolor($64), colcolor($66));
            waitanykey;
            redraw;
            //SDL_UpdateRect2(screen,0,0,screen.w,screen.h);
          end;
        end;
      end;
    end;
    3: //ҩƷ
    begin
      if where <> 2 then
      begin
        str := ' �lҪ����';
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
    4: //������������Ʒ
    begin
      //if where<>3 then break;
    end;
  end;

end;

//�ܷ�װ��

function CanEquip(rnum, inum: integer): boolean;
var
  i, r: integer;
begin

  //�ж��Ƿ����
  //ע�������'��������'Ϊ��ֵʱ�����ԭ���������ʵĴ���

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

  //��������
  if (rrole[rnum].MPType < 2) and (Ritem[inum].NeedMPType < 2) then
    if rrole[rnum].MPType <> Ritem[inum].NeedMPType then
      Result := False;

  //����ר������, ǰ��Ķ�����
  if (Ritem[inum].OnlyPracRole >= 0) and (Result = True) then
    if (Ritem[inum].OnlyPracRole = rnum) then
      Result := True
    else
      Result := False;



  //�ڹ��ж�
  if (inum <= 171) and (inum >= 157) then
  begin
    //������4���ڹ�, ����ƷҲ�������书, ����Ϊ��
    r := 0;
    for i := 0 to 3 do
      if Rrole[rnum].neigong[i] > 0 then
        r := r + 1;
    if (r >= 4) and (ritem[inum].Magic > 0) then
      Result := False;
    //ѧ�����ڹ�����Ϊ��
    for i := 0 to 3 do
      if Rrole[rnum].neigong[i] = ritem[inum].Magic then
      begin
        Result := True;
        break;
      end;
  end
  else
  begin
    //�⹦�ж�
    //������10���书, ����ƷҲ�������书, ����Ϊ��
    r := 0;
    for i := 0 to 9 do
      if Rrole[rnum].Magic[i] > 0 then
        r := r + 1;
    if (r >= 10) and (ritem[inum].Magic > 0) then
      Result := False;

    //ѧ�����书����Ϊ��
    for i := 0 to 9 do
      if Rrole[rnum].Magic[i] = ritem[inum].Magic then
      begin
        Result := True;
        break;
      end;
  end;
end;

//�鿴״̬ѡ��

{procedure MenuStatus;
var
  str: WideString;
  menu: integer;
begin
  str := ' �鿴꠆T��B';
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

//�鿴״̬ѡ��

procedure MenuStatus;
var
  str: WideString;
  menu, amount, i: integer;
  menustring, menuengstring: array of WideString;
begin
  //str := (' �鿴꠆T��B');
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

  {menustring[0] := ' Ҽ';
  menustring[1] := ' �E';
  menustring[2] := ' ��';
  menustring[3] := ' ��';
  menustring[4] := ' ��';
  menustring[5] := ' �';}

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

//��ʾ״̬

procedure ShowStatusByTeam(tnum: integer);
begin
  if TeamList[tnum] >= 0 then
    ShowStatus(TeamList[tnum]);
end;

//��ʾ״̬

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
  strs[0] := ' �ȼ�';
  strs[1] := ' ����';
  strs[2] := ' ����';
  strs[3] := ' �w��';
  strs[4] := ' ���';
  strs[5] := ' ����';
  strs[6] := ' ����';
  strs[7] := ' ���R';
  strs[8] := ' �p��';
  strs[9] := ' �Ƅ�';
  strs[10] := ' �t������';
  strs[11] := ' �ö�����';
  strs[12] := ' �ⶾ����';
  strs[13] := ' ȭ�ƹ���';
  strs[14] := ' ��������';
  strs[15] := ' ˣ������';
  strs[16] := ' �������';
  strs[17] := ' ��������';
  strs[18] := ' �b����Ʒ';
  strs[19] := ' �ޟ���Ʒ';
  strs[20] := ' �����书';
  strs[21] := ' �܂�';
  strs[22] := ' �ж�';
  strs[23] := ' �����ȹ�';

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
  //��ʾͷ��
  drawheadpic(Rrole[rnum].HeadNum, x + 60, y + 80);
  //��ʾ����
  Name := big5tounicode(@Rrole[rnum].Name);
  drawshadowtext(@Name[1], x + 68 - length(PChar(@Rrole[rnum].Name)) * 5, y + 85, colcolor($64), colcolor($66));
  //��ʾ�����ַ�
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

  //����, ����, �Ṧ
  //������������Ϊ��ʾ˳��ʹ洢˳��ͬ
  str := format('%4d', [Rrole[rnum].Attack + addatk]);
  drawengshadowtext(@str[1], x + 280, y + 5 + 21 * 0, colcolor(5), colcolor(7));
  str := format('%4d', [Rrole[rnum].Defence + adddef]);
  drawengshadowtext(@str[1], x + 280, y + 5 + 21 * 1, colcolor(5), colcolor(7));
  str := format('%4d', [Rrole[rnum].Speed + addspeed]);
  drawengshadowtext(@str[1], x + 280, y + 5 + 21 * 2, colcolor(5), colcolor(7));

  //��������
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

  //�书
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

  //�ڹ�
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


  //�ȼ�
  str := format('%4d', [Rrole[rnum].Level]);
  drawengshadowtext(@str[1], x + 110, y + 110, colcolor(5), colcolor(7));



  //����ֵ, �����˺��ж�ֵ��ͬʱʹ�ò�ͬ��ɫ
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
  //����, ������������ʹ����ɫ
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
  //����
  str := format('%4d/%4d', [rrole[rnum].PhyPower, MAX_PHYSICAL_POWER]);
  drawengshadowtext(@str[1], x + 60, y + 173, colcolor(5), colcolor(7));
  //����
  str := format('%5d', [uint16(Rrole[rnum].Exp)]);
  drawengshadowtext(@str[1], x + 100, y + 194, colcolor(5), colcolor(7));
  str := format('%5d', [uint16(Leveluplist[Rrole[rnum].Level - 1])]);
  drawengshadowtext(@str[1], x + 100, y + 215, colcolor(5), colcolor(7));

  //str:=format('%5d', [Rrole[rnum,21]]);
  //drawengshadowtext(@str[1],150,295,colcolor($7),colcolor($5));

  //drawshadowtext(@strs[20, 1], 30, 341, colcolor($21), colcolor($23));
  //drawshadowtext(@strs[21, 1], 30, 362, colcolor($21), colcolor($23));

  //drawrectanglewithoutframe(100,351,Rrole[rnum,19],10,colcolor($16),50);
  //�ж�, ����
  //str := format('%4d', [RRole[rnum].Hurt]);
  //drawengshadowtext(@str[1], 150, 341, colcolor($14), colcolor($16));
  //str := format('%4d', [RRole[rnum].Poision]);
  //drawengshadowtext(@str[1], 150, 362, colcolor($35), colcolor($37));

  //װ��, ����
  drawshadowtext(@strs[18, 1], x, y + 260, colcolor($21), colcolor($23));
  drawshadowtext(@strs[19, 1], x + 160, y + 260, colcolor($21), colcolor($23));
  if Rrole[rnum].Equip[0] >= 0 then
    drawbig5shadowtext(@Ritem[Rrole[rnum].Equip[0]].Name, x + 5, y + 281, colcolor(5), colcolor(7));
  if Rrole[rnum].Equip[1] >= 0 then
    drawbig5shadowtext(@Ritem[Rrole[rnum].Equip[1]].Name, x + 5, y + 302, colcolor(5), colcolor(7));

  //����������Ҫ����
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
    //���¼ӳɣ�loverlevel��
    //0�ӹ���1�ӷ���2���ơ�3������4�书������5�ڹ��ӳɡ�6������ˡ�7�ظ�������8�ظ�����



    //�ؼ�����״̬��Statelevel��
    //0����,1����,2�Ṧ,3�ƶ�,4�˺�,5��Ѫ,6����
    //7ս��,8����,9��ע,10���,11����,12��â,13����
    //14Ǭ��,15�龫,16����,17����,18����,19����,20����
    //21,22,23,24,25,26����,27����
    setlength(strs1, STATUS_AMOUNT);
    strs1[0] := ' ����';
    strs1[1] := ' ���R';
    strs1[2] := ' �p��';
    strs1[3] := ' �Ƅ�';
    strs1[4] := ' ����';
    strs1[5] := ' ����';
    strs1[6] := ' �؃�';
    strs1[7] := ' ����';
    strs1[8] := ' �L��';
    strs1[9] := ' ��ע';
    strs1[10] := ' �A��';
    strs1[11] := ' ����';
    strs1[12] := ' ��â';
    strs1[13] := ' �B��';
    strs1[14] := ' Ǭ��';
    strs1[15] := ' �`��';
    strs1[16] := ' �W��';
    strs1[17] := ' ����';
    strs1[18] := ' ����';
    strs1[19] := ' ����';
    strs1[20] := ' ���w';
    strs1[21] := ' ����';
    strs1[22] := ' ��Ȼ';
    strs1[23] := ' �ȱ�';
    strs1[24] := ' ����';
    strs1[25] := ' ';
    strs1[26] := ' ����';
    strs1[27] := ' ����';

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

//���ѡ��

procedure MenuLeave;
var
  str: WideString;
  i, menu: integer;
begin
  str := ' Ҫ���l�xꠣ�';
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

//ϵͳѡ��

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

//��ʾϵͳѡ��

procedure ShowMenuSystem(menu: integer);
var
  word: array[0..5] of WideString;
  i: integer;
begin
  word[0] := ' �xȡ�M��';
  word[1] := ' �����M��';
  word[2] := ' ȫ��ģʽ';
  word[3] := ' �u��Ⱥ�M';
  word[4] := ' ���wģʽ';
  word[5] := ' ���ؘ��}';
  if fullscreen = 1 then
    word[2] := ' ����ģʽ';
  if SIMPLE = 1 then
    word[4] := ' ����ģʽ';
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

//����ѡ��

procedure MenuLoad;
var
  menu: integer;
begin
  setlength(menustring, 6);
  setlength(Menuengstring, 0);
  menustring[0] := ' �M��һ';
  menustring[1] := ' �M�ȶ�';
  menustring[2] := ' �M����';
  menustring[3] := ' �M����';
  menustring[4] := ' �M����';
  menustring[5] := ' �Ԅәn';
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

//����Ķ���ѡ��, �����ڿ�ʼʱ����

function MenuLoadAtBeginning: boolean;
var
  menu: integer;
begin
  Redraw;
  SDL_UpdateRect2(screen, 0, 0, screen.w, screen.h);
  setlength(menustring, 6);
  setlength(Menuengstring, 0);
  menustring[0] := ' �d���M��һ';
  menustring[1] := ' �d���M�ȶ�';
  menustring[2] := ' �d���M����';
  menustring[3] := ' �d���M����';
  menustring[4] := ' �d���M����';
  menustring[5] := ' �d���Ԅәn';
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

//�浵ѡ��

procedure MenuSave;
var
  menu: integer;
  str: WideString;
begin
  setlength(menustring, 5);
  setlength(menuengstring, 0);
  menustring[0] := ' �M��һ';
  menustring[1] := ' �M�ȶ�';
  menustring[2] := ' �M����';
  menustring[3] := ' �M����';
  menustring[4] := ' �M����';
  menu := commonmenu(176, 30, 67, 4);
  if menu >= 0 then
  begin
    if (where = 1) and (CurScence = 71) then
    begin
      str := ' �ˈ������ɴ�n��';
      drawtextwithrect(@str[1], 176, 30, 172, colcolor($5), colcolor($7));
      waitanykey;
    end
    else
      SaveR(menu + 1);

  end;
  ShowMenu(4);
  ShowMenusystem(1);

end;

//�˳�ѡ��

procedure MenuQuit;
var
  menu, n: integer;
  str1, str2: string;
  str: WideString;
begin
  setlength(menustring, 3);
  menustring[0] := ' ȡ��';
  menustring[1] := ' �_��';
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
    str := ' �밴�����������';
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

//ҽ�Ƶ�Ч��
//δ�������������������

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
  word := ' ��������';
  drawshadowtext(@word[1], 100, 125, colcolor(5), colcolor(7));
  drawbig5shadowtext(@rrole[role2].Name, 100, 100, colcolor($21), colcolor($23));
  word := format('%3d', [addlife]);
  drawengshadowtext(@word[1], 220, 125, colcolor($64), colcolor($66));
  SDL_UpdateRect2(screen, 0, 0, screen.w, screen.h);
  waitanykey;
  redraw;

end;

//�ⶾ��Ч��

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
  word := ' �ж��p��';
  drawshadowtext(@word[1], 100, 125, colcolor(5), colcolor(7));
  drawbig5shadowtext(@rrole[role2].Name, 100, 100, colcolor($21), colcolor($23));
  word := format('%3d', [minuspoi]);
  drawengshadowtext(@word[1], 220, 125, colcolor($64), colcolor($66));
  SDL_UpdateRect2(screen, 0, 0, screen.w, screen.h);
  waitanykey;
  redraw;

end;

//ʹ����Ʒ��Ч��
//�������ŵ�Ч��

procedure EatOneItem(rnum, inum: integer);
var
  i, j, p, l, x, y: integer;
  word: array[0..23] of WideString;
  addvalue, rolelist: array[0..23] of integer;
  str: WideString;
begin

  word[0] := ' ��������';
  word[1] := ' �����������ֵ';
  word[2] := ' �ж��̶�';
  word[3] := ' �����w��';
  word[4] := ' �����T·�ꖺ�һ';
  word[5] := ' ���Ӄ���';
  word[6] := ' ���Ӄ������ֵ';
  word[7] := ' ���ӹ�����';
  word[8] := ' �����p��';
  word[9] := ' ���ӷ��R��';
  word[10] := ' �����t������';
  word[11] := ' �����ö�����';
  word[12] := ' ���ӽⶾ����';
  word[13] := ' ���ӿ�������';
  word[14] := ' ����ȭ������';
  word[15] := ' ������������';
  word[16] := ' ����ˣ������';
  word[17] := ' �����������';
  word[18] := ' ���Ӱ�������';
  word[19] := ' ������W���R';
  word[20] := ' ����Ʒ��ָ��';
  word[21] := ' �����Ƅ���0.';
  word[22] := ' ���ӹ��􎧶�';
  word[23] := ' �܂��̶�';
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
  //��������
  addvalue[23] := -(addvalue[0] div (LIFE_HURT div 2));

  if -addvalue[23] > rrole[rnum].Data[19] then
    addvalue[23] := -rrole[rnum].Data[19];

  //��������, �������ֵ�Ĵ���
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
  //�������ܳ������ֵ
  if addvalue[0] + rrole[rnum].Data[17] > addvalue[1] + rrole[rnum].Data[18] then
    addvalue[0] := addvalue[1] + rrole[rnum].Data[18] - rrole[rnum].Data[17];
  //�ж�����С��0
  if addvalue[2] + rrole[rnum].Data[20] < 0 then
    addvalue[2] := -rrole[rnum].Data[20];
  //�������ܳ���100
  if addvalue[3] + rrole[rnum].Data[21] > MAX_PHYSICAL_POWER then
    addvalue[3] := MAX_PHYSICAL_POWER - rrole[rnum].Data[21];
  //�������ܳ������ֵ
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
  str := ' ����';
  if Ritem[inum].ItemType = 2 then
    str := ' ����';
  Drawshadowtext(@str[1], 83, 72, colcolor($21), colcolor($23));
  Drawbig5shadowtext(@Ritem[inum].Name, 143, 72, colcolor($64), colcolor($66));

  //������ӵ����11��, ��������ʾ
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
  str := ' δ���ӌ���';
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
    //�������������⴦��
    if (i = 4) and (addvalue[i] = 2) then
    begin
      if rrole[rnum].Data[rolelist[i]] <> 2 then
      begin
        rrole[rnum].Data[rolelist[i]] := 2;
        drawshadowtext(@word[i, 1], 83 + x, 124 + y + p * 22, colcolor(5), colcolor(7));
        p := p + 1;
      end;
    end;
    //�����һ������⴦��
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
//�¼�ϵͳ

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
  //��ͨ�¼�д���ӳ�, ����ת�¼�д�ɺ���
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
  word[0] := '����ӹˮ�G����';

  word[1] := '�FѪ����Փ����Ʒ';
  word[2] := 'http://www.txdx.net';
  word[3] := ' ';

  word[4] := '���߄�';
  word[5] := 'СС��';
  word[6] := ' ';

  word[7] := '��ʽ';
  word[8] := 'killer-G';
  word[9] := 's.weyl';
  word[10] := '�����ɷ';
  word[11] := '��˳��';
  word[12] := ' ';

  word[13] := '����';
  word[14] := '��������';
  word[15] := '�����';
  word[16] := '������';
  word[17] := '������ˮ';
  word[18] := '��ʦ����';
  word[19] := ' ';

  word[20] := '����';
  word[21] := '�ο�';
  word[22] := '�������';
  word[23] := 'С���Ҽ�';
  word[24] := '���������';
  word[25] := 'Czhe520';
  word[26] := ' ';

  word[27] := '����';
  word[28] := '�ο�';
  word[29] := '����ɫ';
  word[30] := ' ';

  word[31] := '���';
  word[32] := 'qja';
  word[33] := '�Ϲ���';
  word[34] := '��������';
  word[35] := ' ';

  word[36] := '�yԇ';
  word[37] := '9523';
  word[38] := 'gn0811';
  word[39] := '�ű���';
  word[40] := '����';
  word[41] := '����ľ�^��';
  word[42] := ' ';

  word[43] := '�؄e���x';
  word[44] := '��Ӿ����';
  word[45] := 'fanyixia';
  word[46] := 'hihi88byebye';
  word[47] := 'xuantianxi';
  word[48] := 'chenxurui07';
  word[49] := '��շ�ѩ';
  word[50] := '�������';
  word[51] := '����ܰ';
  word[52] := '��ľ�Ҵ�';
  word[53] := 'chumsdock';
  word[54] := '�׺�һЦ';
  word[55] := 'ena';
  word[56] := 'qiu001';
  word[57] := '�����';
  word[58] := ' ';
  word[59] := ' ';
  word[60] := ' ';
  word[61] := ' ';
  word[62] := ' ';
  word[63] := ' ';
  word[64] := ' ';
  word[65] := '��Ѫ������̳';
  word[66] := '���й����Լ�������������Ϸ';
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
