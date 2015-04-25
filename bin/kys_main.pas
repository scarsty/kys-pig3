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
{$IFDEF UNIX}
  baseUnix,
{$ENDIF}
{$IFDEF ANDROID}
  jni,
{$ENDIF}
  LCLIntf,
  LCLType,
  LConvEncoding,
  SysUtils,
  SDL2_TTF,
  SDL2,
  SDL2_image,
  Math,
  iniFiles,
  Dialogs,
  bass,
  kys_type,
  Classes,
  zip,
  unzip,
  ziputils,
  fileinfo,
  winpeimagereader, {need this for reading exe info}
  elfreader, {needed for reading ELF executables}
  machoreader; {needed for reading MACH-O executables}

//function main(paracount: integer; paras: PPChar): integer; stdcall; export;

//程序重要子程
procedure Run0;
procedure Run; stdcall; export;
procedure Quit;
procedure SetMODVersion;

//游戏开始画面, 行走等
procedure Start;
procedure NewStartAmi;
procedure StartAmi;
procedure ReadFiles;
function InitialRole: boolean;
procedure BufferRead(var p: PChar; buf: PChar; size: integer);
procedure BufferWrite(var p: PChar; buf: PChar; size: integer);
function LoadR(num: integer): boolean;
function SaveR(num: integer): boolean;
function WaitAnyKey: integer;
procedure Walk;
function CanWalk(x, y: integer): boolean;
procedure Moveman(x1, y1, x2, y2: integer);
function FindWay(x1, y1: integer): boolean;
function CheckEntrance: boolean;
function WalkInScence(Open: integer): integer;
procedure ShowScenceName(snum: integer);
function CanWalkInScence(x, y: integer): boolean; overload;
function CanWalkInScence(x1, y1, x, y: integer): boolean; overload;
function CheckEvent1: boolean;
function CheckEvent3: boolean;
procedure TurnBlack;

//选单子程
function CommonMenu(x, y, w, max, default: integer; menuString, menuEngString: array of WideString): integer; overload;
function CommonMenu(x, y, w, max, default: integer; menuString: array of WideString): integer; overload;
function CommonMenu(x, y, w, max, default: integer; menuString, menuEngString: array of WideString; needFrame: integer;
  color1, color2, menucolor1, menucolor2: uint32): integer; overload;
//function CommonMenu(x, y, w, max, default: integer; menuString, menuEngString: array of WideString; fn: TPInt1): integer; overload;
function CommonScrollMenu(x, y, w, max, maxshow: integer; menuString: array of WideString): integer; overload;
function CommonScrollMenu(x, y, w, max, maxshow: integer; menuString, menuEngString: array of WideString): integer;
  overload;
function CommonMenu2(x, y, w: integer; menuString: array of WideString; max: integer = 1): integer; overload;
function SelectOneTeamMember(x, y: integer; str: WideString; list1, list2: integer; mask: integer = 63): integer;
procedure MenuEsc;
procedure DrawTitleMenu(menu: integer = -1);
function CheckTitleMenu: integer;
procedure MenuMedcine;
procedure MenuMedPoison;
function MenuItem: boolean;
function ReadItemList(ItemType: integer): integer;
procedure UseItem(inum: integer; teammate: integer = -1);
function CanEquip(rnum, inum: integer; use: integer = 0): boolean;
procedure MenuStatus;
procedure ShowStatusByTeam(tnum: integer);
procedure ShowStatus(rnum: integer; bnum: integer = 0);
procedure ShowSimpleStatus(rnum, x, y: integer; forTeam: integer = -1);
procedure SetColorByPro(Cur, MaxValue: integer; var color1, color2: uint32);
procedure MenuAbility;
procedure ShowAbility(rnum, select: integer; showLeave: integer = 0);
procedure MenuLeave;
procedure MenuSystem;
procedure MenuSet;
function MenuLoad: integer;
function MenuLoadAtBeginning(mode: integer): integer;
function LoadForSecondRound(num: integer): boolean;
procedure MenuSave;
procedure MenuQuit;

//医疗, 解毒, 使用物品的效果等
procedure EffectMedcine(role1, role2: integer);
procedure EffectMedPoison(role1, role2: integer);
procedure EatOneItem(rnum, inum: integer);

//事件系统
procedure CallEvent(num: integer);
procedure ReSetEntrance; //重设入口
procedure Maker;
procedure ScrollTextAmi(words: TStringList; chnsize, engsize, linespace, align, alignx, style, delay, picnum, scrolldirect: integer);


procedure InitGrowth();

procedure CloudCreate(num: integer);
procedure CloudCreateOnSide(num: integer);
function IsCave(snum: integer): boolean;

function CheckString(str: string): boolean;

//输出函数
//procedure write1();


implementation

uses
  kys_script,
  kys_event,
  kys_engine,
  kys_battle,
  kys_draw;

{function main(paracount: integer; paras: PPChar): integer;
begin
  Run;
  result := 0;
end;}

procedure Run0;
var
  th: PSDL_Thread;
begin
  th := SDL_CreateThread(@Run, nil, nil);
end;

//初始化字体, 音效, 视频, 启动游戏

procedure Run;
var
  i: integer;
  rendernum: integer;
  info: TSDL_RendererInfo;
  str: string;
  a: array of integer;
  logo: PSDL_Texture;
  rect: TSDL_Rect;
{$IFDEF UNIX}
  filestat: stat;
{$ENDIF}
begin
{$IFDEF Darwin}
  AppPath := ParamStr(0);
  fpLStat(AppPath, filestat);
  if fpS_IsLnk(filestat.st_mode) then
  begin
    AppPath := fpReadLink(AppPath);
    if AppPath[1] = '.' then
      AppPath := ExtractFilePath(ParamStr(0)) + AppPath;
  end;
  AppPath := ExtractFileDir(ExtractFileDir(AppPath)) + '/game/';
{$ENDIF}
{$IFDEF mswindows}
  AppPath := '../game/';
{$ENDIF}
{$IFDEF android}
  AppPath := SDL_AndroidGetExternalStoragePath() + '/game/';
  //for i := 1 to 4 do
  //AppPath:= ExtractFileDir(AppPath);
  str := SDL_AndroidGetExternalStoragePath() + '/pig3_place_game_here';
  //if not fileexists(str) then
  FileClose(filecreate(str));
  CellPhone := 1;
{$ENDIF}
  //versionstr :=  SDL_AndroidGetExternalStoragePath();
  //test;
  //cellphone:=1;
  ReadFiles;

  ConsoleLog('Read ini and data files ended');

  SetMODVersion;

  //初始化音频系统
  //SDL_Init(SDL_INIT_AUDIO);
  //Mix_OpenAudio(MIX_DEFAULT_FREQUENCY, MIX_DEFAULT_FORMAT, 2, 16384);
  SoundFlag := 0;
  if SOUND3D = 1 then
    SoundFlag := BASS_DEVICE_3D or SoundFlag;
  BASS_Init(-1, 22050, SoundFlag, 0, nil);

  //初始化视频系统
  Randomize;

  SDL_Init(SDL_INIT_VIDEO);

  //找渲染器
  rendernum := -1;
  for i := 0 to SDL_GetNumRenderDrivers() - 1 do
  begin
    SDL_GetRenderDriverInfo(i, @info);
    ConsoleLog('Renderer %d is %s, support:', [i, info.Name]);
    if info.flags and SDL_RENDERER_SOFTWARE <> 0 then
      ConsoleLog('software fallback, ', False);
    if info.flags and SDL_RENDERER_ACCELERATED <> 0 then
      ConsoleLog('hardware acceleration, ', False);
    if info.flags and SDL_RENDERER_PRESENTVSYNC <> 0 then
      ConsoleLog('persent synchronizing, ', False);
    if info.flags and SDL_RENDERER_TARGETTEXTURE <> 0 then
      ConsoleLog('texture rendering, ', False);
    ConsoleLog('...end');
    if (info.Name = 'opengl') or (info.Name = 'opengles2') then
    begin
      if (RENDERER = 1) then
      begin
        rendernum := i;
        ConsoleLog('Select OPENGL renderer');
      end;
    end;
    if info.Name = 'direct3d' then
    begin
      if (RENDERER = 0) then
      begin
        rendernum := i;
        ConsoleLog('Select Direct3D renderer');
      end;
    end;
    if info.Name = 'software' then
    begin
      if (RENDERER = 2) then
      begin
        rendernum := i;
        ConsoleLog('Select software renderer');
      end;
    end;
  end;
  if rendernum = -1 then
    RENDERER := 0;

  if RENDERER = 2 then
  begin
    SMOOTH := 0;
  end;
  SDL_SetHint(SDL_HINT_RENDER_SCALE_QUALITY, PChar(IntToStr(SMOOTH)));

  WindowFlag := 0;
  if RENDERER = 1 then
    WindowFlag := SDL_WINDOW_OPENGL;
  {if (SW_SURFACE <> 0) or (RENDERER = 1) then }
  WindowFlag := WindowFlag or SDL_WINDOW_RESIZABLE;

  if CellPhone = 1 then
  begin
    WindowFlag := WindowFlag or SDL_WINDOW_FULLSCREEN_DESKTOP;
    KEEP_SCREEN_RATIO := 0;
    TEXT_LAYER := 0;
  end;

  RenderFlag := SDL_RENDERER_ACCELERATED or SDL_RENDERER_TARGETTEXTURE;
  if PRESENT_SYNC <> 0 then
    RenderFlag := RenderFlag or SDL_RENDERER_PRESENTVSYNC;

  ConsoleLog('Creating window with width and height %d and %d', [RESOLUTIONX, RESOLUTIONY]);
  window := SDL_CreateWindow(PChar(TitleString), SDL_WINDOWPOS_CENTERED, SDL_WINDOWPOS_CENTERED, RESOLUTIONX, RESOLUTIONY, WindowFlag);
  SDL_GetWindowSize(window, @RESOLUTIONX, @RESOLUTIONY);

  if (CellPhone = 1) then
  begin
    ConsoleLog('Width and height of the window is %d, %d', [RESOLUTIONX, RESOLUTIONY]);
    if (RESOLUTIONY > RESOLUTIONX) then
      ScreenRotate := 0;
    //SDL_WarpMouseInWindow(window, RESOLUTIONX, RESOLUTIONY);
  end;

  if SW_OUTPUT <> 0 then
    RealScreen := SDL_GetWindowSurface(window);

  ConsoleLog('Creating renderer');
  render := SDL_CreateRenderer(window, rendernum, RenderFlag);

  logo := img_loadtexture(render, PChar(AppPath + 'resource/logo.png'));

  rect.w := 294;
  rect.h := 284;
  rect.x := (RESOLUTIONX - rect.w) div 2;
  rect.y := (RESOLUTIONY - rect.h) div 2;

  SDL_RenderClear(render);
  SDL_RenderPresent(render);
  SDL_RenderCopy(render, logo, nil, @rect);
  SDL_RenderPresent(render);
  SDL_DestroyTexture(logo);

  ConsoleLog('All pictures will be loaded as surface: %d', [SW_SURFACE]);
  ConsoleLog('Text will be drawn on single layer: %d', [TEXT_LAYER]);

  ImageWidth := (36 * 32 + CENTER_X) * 2;
  ImageHeight := (18 * 32 + CENTER_Y) * 2;

  //初始化字体
  ConsoleLog('Try to load the fonts');
  TTF_Init();
  SetFontSize(20, 18, -1);

  ConsoleLog('Creating rendered textures');
  CreateMainRenderTextures;
  CreateAssistantRenderTextures;

  ConsoleLog('Initial lua script environment');
  InitialScript;
  ConsoleLog('Initial music');
  InitialMusic;

  ConsoleLog('Record the state of the direction keys');
  //mutex := SDL_CreateMutex();
  keystate := PChar(SDL_GetKeyboardState(nil));
  keyup := puint8(keystate + sdl_SCANCODE_up);
  keydown := puint8(keystate + sdl_SCANCODE_down);
  keyleft := puint8(keystate + sdl_SCANCODE_left);
  keyright := puint8(keystate + sdl_SCANCODE_right);

  ConsoleLog('Set event filter');
  SDL_SetEventFilter(@EventFilter, nil);

  if CellPhone = 0 then
  begin
    SDL_InitSubSystem(SDL_INIT_JOYSTICK);
    if SDL_NumJoysticks() > 0 then
    begin
      ConsoleLog('Found joystick');
      joy := SDL_JoystickOpen(0);
      if SDL_JoystickNumAxes(joy) > 0 then
      begin
        SDL_InitSubSystem(SDL_INIT_TIMER);
        SDL_AddTimer(JOY_AXIS_DELAY, JoyAxisMouse, nil);
      end;
    end;
  end
  else
  begin
    ConsoleLog('Ignore joystick in cellphone ');
  end;

  ConsoleLog('Initial ended, start game');
  Start;

  Quit;

end;

//关闭所有已打开的资源, 退出

procedure Quit;
begin
  if (SDL_JoystickGetAttached(joy)) then
    SDL_JoystickClose(joy);
  DestroyAllTextures();
  DestroyScript;
  TTF_CloseFont(font);
  TTF_CloseFont(engfont);
  TTF_Quit;
  SDL_DestroyRenderer(render);
  SDL_DestroyWindow(window);
  SDL_DestroyMutex(mutex);
  SDL_Quit;
  FreeAllMusic;
  BASS_Free();
  halt(1);
  exit;

end;

procedure SetMODVersion;
var
  filename: string;
  Kys_ini: TIniFile;
  p, p1: PChar;
  FileVerInfo: TFileVersionInfo;
begin
  Setlength(Music, 99);
  Setlength(Esound, 99);
  Setlength(Asound, 99);
  FileVerInfo := TFileVersionInfo.Create(nil);
  try
    FileVerInfo.FileName := ParamStr(1);
    FileVerInfo.ReadFileInfo;
    versionstr := versionstr + '-' + FileVerInfo.VersionStrings.Values['FileVersion'];
  finally
    FileVerInfo.Free;
  end;
  StartMusic := 59;
  TitleString := 'Legend of Little Village III - 108 Brothers and Sisters';

  OpenPicPosition.x := CENTER_X - 384;
  OpenPicPosition.y := CENTER_Y - 240;
  TitlePosition.x := OpenPicPosition.x + 470;
  TitlePosition.y := OpenPicPosition.y + 230;

  case MODVersion of
    0:
    begin
      versionstr := versionstr + '-金庸群俠傳';
      BEGIN_EVENT := 691;
      BEGIN_SCENCE := 70;
      MONEY_ID := 174;
      COMPASS_ID := 182;
      BEGIN_LEAVE_EVENT := 950;
      BEGIN_NAME_IN_TALK := 2977;
      MAX_LOVER := 0;
      EventScriptPath := 'script/oldevent/oldevent_';
      EventScriptExt := '.lua';
    end;
    12:
    begin
      TitleString := 'We Are Dragons';
      versionstr := versionstr + '-蒼龍逐日';
      BEGIN_EVENT := 691;
      BEGIN_SCENCE := 70;
      MONEY_ID := 174;
      COMPASS_ID := 182;
      BEGIN_LEAVE_EVENT := 100;
      BEGIN_NAME_IN_TALK := 4021;
      MAX_LOVER := 0;
      BEGIN_Sx := 13;
      BEGIN_Sy := 54;
    end;
    31:
    begin
      TitleString := 'Wider rivers and deeper lakes';
      versionstr := versionstr + '-再战江湖';
      BEGIN_EVENT := 691;
      BEGIN_SCENCE := 70;
      MONEY_ID := 174;
      COMPASS_ID := 182;
      BEGIN_LEAVE_EVENT := 1;
      BEGIN_NAME_IN_TALK := 8015;
      MAX_LOVER := 0;
      BEGIN_Sx := 13;
      BEGIN_Sy := 54;
    end;
    41:
    begin
      TitleString := 'PTT';
      versionstr := versionstr + '-鄉民闖江湖';
      BEGIN_EVENT := 691;
      BEGIN_SCENCE := 70;
      MONEY_ID := 174;
      COMPASS_ID := 182;
      BEGIN_LEAVE_EVENT := 1050;
      BEGIN_NAME_IN_TALK := 5693;
      MAX_LOVER := 0;
      BEGIN_Sx := 20;
      BEGIN_Sy := 19;
    end;
    81:
    begin
      TitleString := 'Liang Yu Sheng';
      versionstr := ' 梁羽生群侠傳';
      BEGIN_EVENT := 1;
      BEGIN_SCENCE := 0;
      MONEY_ID := 174;
      COMPASS_ID := 182;
      BEGIN_LEAVE_EVENT := 1;
      BEGIN_NAME_IN_TALK := 8015;
      MAX_LOVER := 0;
      StartMusic := 0;
    end;
  end;

  Kys_ini := TIniFile.Create(iniFilename);
  try
    RESOLUTIONX := Kys_ini.ReadInteger('system', 'RESOLUTIONX', CENTER_X * 2);
    RESOLUTIONY := Kys_ini.ReadInteger('system', 'RESOLUTIONY', CENTER_Y * 2);
  finally
    Kys_ini.Free;
  end;

end;

//Main game.
//显示开头画面

procedure Start;
var
  menu, menup, i, col, i1, i2, x, y, k, x1, y1, maxm: integer;
  Selected, into: boolean;
  a, b: uint32;
  headnum, alpha, alphastep: integer;
  LoadThread: PSDL_Thread;
  temp, temp2: PSDL_Surface;
  dest: TSDL_Rect;
  now1: uint32;
  h, m, s, ms: word;
  str: WideString;
begin
  where := 4;
  if PNG_TILE > 0 then
  begin
    LoadPNGTiles('resource/title', TitlePNGIndex, 1);
    InitialPicArrays;
  end;

  ReadingTiles := True;
  now1 := SDL_GetTicks;
  {DecodeTime(time, h, m, s, ms);
  case h of
    6..16: ScreenBlendMode := 0;
    17..20: ScreenBlendMode := 2;
    else
      ScreenBlendMode := 1;
  end;}

  ConsoleLog('Play movie and start music');
  if (OPEN_MOVIE = 1) then
    PlayMovie('open.wmv', 1);
  PlayMP3(StartMusic, -1);
  ConsoleLog('Begin.....');
  Redraw;
  UpdateAllScreen;

  FillChar(Entrance[0, 0], sizeof(Entrance), -1);

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

  NewStartAmi;

  {now1:=sdl_getticks;
  for i:=1 to 10000 do
  DrawTPic(0, 0, 0, 0, 0, 0, 0, 0, 0);
  Message(sdl_getticks-now1);}

  //x := TitlePosition.x;
  //y := TitlePosition.y;
  //事件等待
  Selected := False;
  headnum := 0;
  alpha := 100;
  alphastep := -2;
  LoadR(0);
  menu := 0;
  //ScreenBlendMode := 1;
  while (SDL_PollEvent(@event) >= 0) do
  begin
    Redraw;
    DrawHeadPic(headnum, CENTER_X - 250, CENTER_Y - 30, 0, alpha, 0, 0);
    if alpha >= 100 then
      alphastep := -2;
    if alpha <= 0 then
      alphastep := 2;
    alpha := alpha + alphastep;
    if alpha >= 100 then
    begin
      headnum := random(412);
      if MODVersion <> 13 then
        headnum := random(HPicAmount);
    end;

    x := CENTER_X + 90;
    y := CENTER_Y - 30;
    maxm := 3;
    for i := 0 to maxm do
    begin
      DrawTPic(16, CENTER_X + 50, y + i * 50, nil, 0, 25, 0, 0);
      if i <> menu then
        DrawTPic(3 + i, x, y + 50 * i)
      else
        DrawTPic(23 + i, x + 5, y + 50 * i, nil);
    end;
    DrawTPic(13, CENTER_X - 320, CENTER_Y - 90, nil, 0, 25 + alpha div 2, 0, 0);
    UpdateAllScreen;
    CheckBasicEvent;
    case event.type_ of //键盘事件
      SDL_KEYUP:
      begin
        if ((event.key.keysym.sym = SDLK_RETURN) or (event.key.keysym.sym = SDLK_SPACE)) then
        begin
          Selected := True;
        end;
      end;
      SDL_KEYDOWN:
      begin
        if event.key.keysym.sym = SDLK_UP then
        begin
          menu := menu - 1;
          if menu < 0 then
            menu := maxm;
        end;
        if event.key.keysym.sym = SDLK_DOWN then
        begin
          menu := menu + 1;
          if menu > maxm then
            menu := 0;
        end;
      end;
      //按下鼠标(UP表示抬起按键才执行)
      SDL_MOUSEBUTTONUP:
      begin
        if (event.button.button = SDL_BUTTON_LEFT) and MouseInRegion(x, y, 300, 200) then
        begin
          Selected := True;
        end;
      end;
      //鼠标移动
      SDL_MOUSEMOTION:
      begin
        if MouseInRegion(x, y, 300, 200, x1, y1) then
        begin
          menup := menu;
          menu := min(maxm, (y1 - y) div 50);
        end;
      end;
    end;
    CleanKeyValue;
    SDL_Delay(40);

    if Selected then
    begin
      case menu of
        3: break;
        1:
        begin
          if MenuLoadAtBeginning(0) >= 0 then
          begin
            CurEvent := -1; //when CurEvent=-1, Draw scence by Sx, Sy. Or by Cx, Cy.
            if where = 1 then
              WalkInScence(0);
            Walk;
          end;
        end;
        0:
        begin
          Selected := InitialRole;
          if Selected then
          begin
            CurScence := BEGIN_SCENCE;
            WalkInScence(1);
            Walk;
          end;
        end;
        2:
        begin
          if MenuLoadAtBeginning(1) >= 0 then
          begin
            CurScence := BEGIN_SCENCE;
            WalkInScence(1);
            Walk;
          end;
        end;
      end;
      Selected := False;
    end;
  end;

end;

procedure NewStartAmi;
var
  breakami: boolean;
  i, j, x, y: integer;
  temp, temp2: PSDL_Surface;
  src, dest: TSDL_Rect;
begin
  where := 4;
  breakami := False;
  CleanKeyValue;
  x := CENTER_X - 34;
  y := CENTER_Y - 115;

  for i := 0 to 20 do
  begin
    Redraw;
    DrawTPic(9, x, y, nil, 0, 100 - i * 5);
    UpdateAllScreen;
    SDL_Delay(20);
    if SDL_PollEvent(@event) >= 0 then
    begin
      CleanKeyValue;
      if ((event.key.keysym.sym = SDLK_ESCAPE) or (event.button.button = SDL_BUTTON_RIGHT)) then
      begin
        exit;
      end;
      CheckBasicEvent;
    end;
  end;

  {temp := CopyIndexSurface(TitlePngIndex[9]);
  for i := 0 to 60 do
  begin
    Redraw;
    temp2 := rotozoomSurface(temp, -i * 6, 1, 1);
    dest.x := CENTER_X - temp2.w div 2;
    dest.y := CENTER_Y - temp2.h div 2;
    SDL_BlitSurface(temp2, nil, screen, @dest);
    SDL_FreeSurface(temp2);
    UpdateAllScreen;
    SDL_Delay(20);
    if SDL_PollEvent(@event)>=0then
    begin
    if ((event.key.keysym.sym = SDLK_ESCAPE) or (event.button.button = SDL_BUTTON_RIGHT)) then
      exit;
    CheckBasicEvent;
    end;
  end;
  SDL_FreeSurface(temp);}

  for i := 1 to 60 do
  begin
    Redraw;
    x := x - 4;
    y := trunc(y - 2);
    DrawTPic(9, x, y);
    UpdateAllScreen;
    SDL_Delay(20);
    if SDL_PollEvent(@event) >= 0 then
    begin
      if ((event.key.keysym.sym = SDLK_ESCAPE) or (event.button.button = SDL_BUTTON_RIGHT)) then
        exit;
      CheckBasicEvent;
    end;
  end;
  //writeln(x, y);
  src.x := 0;
  src.y := 0;
  src.w := TitlePNGIndex[12].w;
  src.h := TitlePNGIndex[12].h;
  dest.x := x;
  dest.y := y + 10;
  for i := 0 to 89 do
  begin
    Redraw;
    src.w := i * 5 + 50;
    if src.w > 490 then
      break;
    DrawTPic(12, x + 2, y + 10, @src);
    DrawTPic(10, x, y);
    DrawTPic(10, x + i * 5 + 34, y);
    UpdateAllScreen;
    SDL_Delay(20);
    if SDL_PollEvent(@event) >= 0 then
    begin
      if ((event.key.keysym.sym = SDLK_ESCAPE) or (event.button.button = SDL_BUTTON_RIGHT)) then
        exit;
      CheckBasicEvent;
    end;
  end;

  where := 3;
  for i := 0 to 2 do
  begin
    Redraw;
    DrawTPic(14 + i, CENTER_X + 50, CENTER_Y - 30, nil, 0, 75);
    DrawTPic(14 + i, CENTER_X + 50, CENTER_Y - 30 + 50, nil, 0, 50);
    DrawTPic(14 + i, CENTER_X + 50, CENTER_Y - 30 + 100, nil, 0, 25);
    DrawTPic(14 + i, CENTER_X + 50, CENTER_Y - 30 + 150, nil, 0, 0);
    UpdateAllScreen;
    SDL_Delay(20);
    if SDL_PollEvent(@event) >= 0 then
    begin
      if ((event.key.keysym.sym = SDLK_ESCAPE) or (event.button.button = SDL_BUTTON_RIGHT)) then
        exit;
      CheckBasicEvent;
    end;
  end;

  for i := 0 to 20 do
  begin
    Redraw;
    for j := 0 to 3 do
    begin
      DrawTPic(16, CENTER_X + 50, CENTER_Y - 30 + j * 50, nil, 0, 25);
      DrawTPic(3 + j, CENTER_X + 90, CENTER_Y - 30 + j * 50, nil, 0, 100 - i * 5, 0, 0);
    end;
    UpdateAllScreen;
    SDL_Delay(20);
    if SDL_PollEvent(@event) >= 0 then
    begin
      if ((event.key.keysym.sym = SDLK_ESCAPE) or (event.button.button = SDL_BUTTON_RIGHT)) then
        exit;
      CheckBasicEvent;
    end;
  end;
  where := 3;
end;

//开头字幕

procedure StartAmi;
var
  i: integer;
  words: TStringList;
begin
  if OPEN_RECITATION = 0 then
    exit;
  words := TStringList.Create;
  words.LoadFromFile(AppPath + 'txt/start.txt');
  CleanTextScreen;
  instruct_14;
  if 18 <= High(TitlePNGIndex) then
  begin
    for i := 20 downto 0 do
    begin
      Redraw;
      DrawTPic(18, -TitlePNGIndex[18].w + CENTER_X * 2, 0, nil, 0, i * 5);
      UpdateAllScreen;
      SDL_Delay(20);
      SDL_PollEvent(@event);
      {if ((event.key.keysym.sym = SDLK_ESCAPE) or (event.button.button = SDL_BUTTON_RIGHT)) then
        exit;
      CheckBasicEvent;}
    end;
  end;
  PlayMP3(60, 0);
  //DrawRectangleWithoutFrame(0, 0, CENTER_X * 2, CENTER_Y * 2, 0, 100);
  ScrollTextAmi(words, 20, 18, 25, 0, RESOLUTIONX div 2 - 270, 1, 200, 18, 0);
  PlayMP3(StartMusic, -1);
  words.Free;
  CleanTextScreen;
  instruct_14;
  //TextAmi('txt/start.txt');
end;

//读取必须的文件

procedure ReadFiles;
var
  tnum, beginnum, offset, len, IDX, GRP, col, t1, i, i1, b: integer;
  filename: string;
  p: pbyte;
  Kys_ini: TIniFile;
  Namestr: array of byte;
  str: string;
  tempstr: WideString;
  list: TStringList;
  cf: char;
  zfile: zipfile;
begin
  iniFilename := AppPath + iniFilename;

  if not FileExists(inifilename) then
    Quit;

  Kys_ini := TIniFile.Create(iniFilename);
  ConsoleLog('Find ini file: %s', [iniFilename]);
  try
    SIMPLE := Kys_ini.ReadInteger('system', 'SIMPLE', 0);
    //FULLSCREEN := Kys_ini.ReadInteger('system', 'FULLSCREEN', 0);
    BATTLE_SPEED := Kys_ini.ReadInteger('system', 'BATTLE_SPEED', 10);
    EFFECT_STRING := Kys_ini.ReadInteger('system', 'EFFECT_STRING', 0);
    WALK_SPEED := Kys_ini.ReadInteger('system', 'WALK_SPEED', 10);
    WALK_SPEED2 := Kys_ini.ReadInteger('system', 'WALK_SPEED2', WALK_SPEED);
    SMOOTH := Kys_ini.ReadInteger('system', 'SMOOTH', 1);
    RENDERER := Kys_ini.ReadInteger('system', 'RENDERER', 1);
    CENTER_X := Kys_ini.ReadInteger('system', 'CENTER_X', 384);
    CENTER_Y := Kys_ini.ReadInteger('system', 'CENTER_Y', 240);
    RESOLUTIONX := Kys_ini.ReadInteger('system', 'RESOLUTIONX', CENTER_X * 2);
    RESOLUTIONY := Kys_ini.ReadInteger('system', 'RESOLUTIONY', CENTER_Y * 2);
    MMAPAMI := Kys_ini.ReadInteger('system', 'MMAPAMI', 1);
    SCENCEAMI := Kys_ini.ReadInteger('system', 'SCENCEAMI', 2);
    SEMIREAL := Kys_ini.ReadInteger('system', 'SEMIREAL', 0);
    MODVersion := Kys_ini.ReadInteger('system', 'MODVersion', 0);
    CHINESE_FONT_SIZE := Kys_ini.ReadInteger('system', 'CHINESE_FONT_SIZE', CHINESE_FONT_SIZE);
    ENGLISH_FONT_SIZE := Kys_ini.ReadInteger('system', 'ENGLISH_FONT_SIZE', ENGLISH_FONT_SIZE);
    KDEF_SCRIPT := Kys_ini.ReadInteger('system', 'KDEF_SCRIPT', 0);
    NIGHT_EFFECT := Kys_ini.ReadInteger('system', 'NIGHT_EFFECT', 0);
    EXIT_GAME := Kys_ini.ReadInteger('system', 'EXIT_GAME', 0);
    PNG_TILE := Kys_ini.ReadInteger('system', 'PNG_TILE', 2);
    TRY_FIND_GRP := Kys_ini.ReadInteger('system', 'TRY_FIND_GRP', 0);
    PNG_LOAD_ALL := Kys_ini.ReadInteger('system', 'PNG_LOAD_ALL', 0);
    KEEP_SCREEN_RATIO := Kys_ini.ReadInteger('system', 'KEEP_SCREEN_RATIO', 1);
    //软件模式下禁止文字分层, 错误过多
    TEXT_LAYER := Kys_ini.ReadInteger('system', 'Text_Layer', 0);
    ZIP_SAVE := Kys_ini.ReadInteger('system', 'ZIP_SAVE', 1);
    OPEN_MOVIE := Kys_ini.ReadInteger('system', 'OPEN_MOVIE', 1);
    OPEN_RECITATION := Kys_ini.ReadInteger('system', 'OPEN_RECITATION', 1);
    THREAD_READ_MOVIE := Kys_ini.ReadInteger('system', 'THREAD_READ_MOVIE', 1);
    THREAD_READ_PNG := Kys_ini.ReadInteger('system', 'THREAD_READ_PNG', 0);
    DISABLE_MENU_AMI := Kys_ini.ReadInteger('system', 'DISABLE_MENU_AMI', 0);
    EXPAND_GROUND := Kys_ini.ReadInteger('system', 'EXPAND_GROUND', 1);
    AI_USE_SPECIAL := Kys_ini.ReadInteger('system', 'AI_USE_SPECIAL', 1);
    MODVersion := Kys_ini.ReadInteger('system', 'MODVersion', 13);
    PRESENT_SYNC := Kys_ini.ReadInteger('system', 'PRESENT_SYNC', 1);
    FONT_MEMERY := Kys_ini.ReadInteger('system', 'FONT_VIDEOMEMERY', 1);
    FULL_DESKTOP := Kys_ini.ReadInteger('system', 'FULL_DESKTOP', 0);
    SW_SURFACE := Kys_ini.ReadInteger('system', 'SW_SURFACE', 0);
    SW_OUTPUT := Kys_ini.ReadInteger('system', 'SW_OUTPUT', 0);
    AUTO_LEVELUP := Kys_ini.ReadInteger('system', 'AUTO_LEVELUP', 0);

    VOLUME := Kys_ini.ReadInteger('music', 'VOLUME', 30);
    VOLUMEWAV := Kys_ini.ReadInteger('music', 'VOLUMEWAV', 30);
    SOUND3D := Kys_ini.ReadInteger('music', 'SOUND3D', 1);

    JOY_RETURN := Kys_ini.ReadInteger('joystick', 'JOY_RETURN', 10);
    JOY_ESCAPE := Kys_ini.ReadInteger('joystick', 'JOY_ESCAPE', 13);
    JOY_UP := Kys_ini.ReadInteger('joystick', 'JOY_UP', 0);
    JOY_DOWN := Kys_ini.ReadInteger('joystick', 'JOY_DOWN', 1);
    JOY_LEFT := Kys_ini.ReadInteger('joystick', 'JOY_LEFT', 2);
    JOY_RIGHT := Kys_ini.ReadInteger('joystick', 'JOY_RIGHT', 3);
    JOY_MOUSE_LEFT := Kys_ini.ReadInteger('joystick', 'JOY_MOUSE_LEFT', 12);
    JOY_AXIS_DELAY := Kys_ini.ReadInteger('joystick', 'JOY_AXIS_DELAY', 10);

    if CellPhone <> 0 then
    begin
      ShowVirtualKey := Kys_ini.ReadInteger('system', 'Virtual_Key', 1);
      VirtualKeyX := Kys_ini.ReadInteger('system', 'Virtual_Key_X', 150);
      VirtualKeyY := Kys_ini.ReadInteger('system', 'Virtual_Key_Y', 250);
      VirtualKeySize:=Kys_ini.ReadInteger('system', 'Virtual_Key_Size', 60);
      VirtualKeySpace:= Kys_ini.ReadInteger('system', 'Virtual_Key_Space', 25);
    end
    else
      ShowVirtualKey := 0;
    if KEEP_SCREEN_RATIO = 0 then
      TEXT_LAYER := 0;
    if SW_OUTPUT = 1 then
      TEXT_LAYER := 0;

    if (not FileExists(AppPath + 'resource/mmap/index.ka')) and (not FileExists(AppPath + 'resource/mmap.imz')) then
      PNG_TILE := 0;
    if (not FileExists(AppPath + 'save/ranger.grp')) then
      ZIP_SAVE := 1;
    if (KDEF_SCRIPT = 2) and (not FileExists(AppPath + 'script/event.imz')) then
      KDEF_SCRIPT := 1;
{$ifdef unix}
    THREAD_READ_PNG := 0;
    if RENDERER = 0 then
      RENDERER := 1;
{$endif}
    if DISABLE_MENU_AMI <> 0 then
      DISABLE_MENU_AMI := 25;
  finally
    Kys_ini.Free;
  end;

  MaxProList[43] := 999;  //攻击
  MaxProList[44] := 500;  //轻功
  MaxProList[45] := 999;  //防御
  MaxProList[46] := 200;  //医疗
  MaxProList[47] := 100;  //用毒
  MaxProList[48] := 100;  //解毒
  MaxProList[49] := 100;  //抗毒
  MaxProList[50] := 999;  //拳掌
  MaxProList[51] := 999;  //御剑
  MaxProList[52] := 999;  //耍刀
  MaxProList[53] := 999;  //特殊
  MaxProList[54] := 999;  //暗器
  MaxProList[55] := 100;  //常识
  MaxProList[56] := 100;  //品德
  MaxProList[57] := 100;  //带毒
  MaxProList[58] := 200;  //移动

  ReadFileToBuffer(@ACol[0], AppPath + 'resource/mmap.col', 768, 0);
  move(ACol[0], ACol1[0], 768);
  move(ACol[0], ACol2[0], 768);

  ReadFileToBuffer(@Earth[0, 0], AppPath + 'resource/earth.002', 480 * 480 * 2, 0);
  ReadFileToBuffer(@surface[0, 0], AppPath + 'resource/surface.002', 480 * 480 * 2, 0);
  ReadFileToBuffer(@Building[0, 0], AppPath + 'resource/building.002', 480 * 480 * 2, 0);
  //注意坐标
  ReadFileToBuffer(@Buildy[0, 0], AppPath + 'resource/buildx.002', 480 * 480 * 2, 0);
  ReadFileToBuffer(@Buildx[0, 0], AppPath + 'resource/buildy.002', 480 * 480 * 2, 0);

  ReadFileToBuffer(@leavelist[0], AppPath + 'binlist/leave.bin', 200, 0);
  ReadFileToBuffer(@effectlist[0], AppPath + 'binlist/effect.bin', 200, 0);
  ReadFileToBuffer(@leveluplist[0], AppPath + 'binlist/levelup.bin', 200, 0);

  //ReadFileToBuffer(@matchlist[0], AppPath + 'binlist/match.bin', MAX_WEAPON_MATCH * 3 * 2, 0);
  ReadFileToBuffer(@loverlist[0], AppPath + 'binlist/lover.bin', MAX_LOVER * 5 * 2, 0);

  //ReadFileToBuffer(@FightFrame[0], AppPath + 'resource/fight/fightframe.ka', 5 * 500 * 2, 0);
  ReadFileToBuffer(@WarStaList[0], AppPath + 'resource/war.sta', sizeof(TWarData) * length(WarStaList), 0);

  //pWarfld := ReadFileToBuffer(nil, AppPath + 'resource/warfld.grp', -1, 1);

  KDEF := LoadIdxGrp('resource/kdef.idx', 'resource/kdef.grp');
  TDEF := LoadIdxGrp('resource/talk1.idx', 'resource/talk1.grp');
  WARFLD := LoadIdxGrp('resource/warfld.idx', 'resource/warfld.grp');
  //LoadIdxGrp('resource/name.idx', 'resource/name.grp', NameIdx, NameGrp);

  //升级经验统一为1000点
  //for i1 := 0 to 200 - 1 do
  //  leveluplist[i1] := 1000;

  // if fileexists('resource/black.pic') then
  // begin
  //   blackscreen := IMG_Load('resource/black.pic');

  // end;

  {for i1 := 0 to 479 do
  begin
    for i := 0 to 639 do
    begin
      b := ((i - ((CENTER_X * 2) shr 1)) * (i - ((CENTER_X * 2) shr 1)) + (i1 - ((CENTER_Y * 2) shr 1)) *
        (i1 - ((CENTER_Y * 2) shr 1))) div 150;
      if b > 100 then
        b := 100;
      snowalpha[i1][i] := b;
    end;
  end;}
  //showmessage(inttostr((CENTER_X * 2) shr 1));
  //InitialSurfaces;
  //载入108人名, 星位名
  list := TStringList.Create;
  if FileExists(AppPath + 'txt/starlist.txt') then
  begin
    list.LoadFromFile(AppPath + 'txt/starlist.txt');
    Star[0] := UTF8Decode(list.Strings[0]);
    if list.Count >= 216 then
      for i := 1 to 107 do
      begin
        //ReadTalk(i, NameStr);
        RoleName[i] := UTF8Decode(list.Strings[i + 108]);
        Star[i] := UTF8Decode(list.Strings[i]);
      end;
  end
  else
    for i := 0 to 107 do
    begin
      RoleName[i] := '';
      Star[i] := '';
    end;
  list.Free;
  //载入战斗名
  list := TStringList.Create;
  if FileExists(AppPath + 'txt/battlename.txt') then
    list.LoadFromFile(AppPath + 'txt/battlename.txt');
  setlength(BattleNames, list.Count);
  for i := 0 to list.Count - 1 do
  begin
    BattleNames[i] := UTF8Decode(list.Strings[i]);
  end;
  list.Free;

  setlength(statestrs, length(Brole[0].StateLevel));
  for i := 0 to high(statestrs) do
    statestrs[i] := '';
  statestrs[0] := '攻擊';
  statestrs[1] := '防禦';
  statestrs[2] := '輕功';
  statestrs[3] := '移動';
  statestrs[4] := '傷害';
  statestrs[5] := '回命';
  statestrs[6] := '回內';
  statestrs[7] := '戰神';
  statestrs[8] := '風雷';
  statestrs[9] := '孤注';
  statestrs[10] := '傾國';
  statestrs[11] := '毒箭';
  statestrs[12] := '遠攻';
  statestrs[13] := '連擊';
  statestrs[14] := '反傷';
  statestrs[15] := '靈精';
  statestrs[16] := '閃避';
  statestrs[17] := '博采';
  statestrs[18] := '聆音';
  statestrs[19] := '青翼';
  statestrs[20] := '回體';
  statestrs[21] := '傷逝';
  statestrs[22] := '黯然';
  statestrs[23] := '慈悲';
  statestrs[24] := '悲歌';
  statestrs[26] := '定身';
  statestrs[27] := '控制';
  statestrs[28] := '混亂';
  statestrs[29] := '拳理';
  statestrs[30] := '劍意';
  statestrs[31] := '刀氣';
  statestrs[32] := '奇兵';
  statestrs[33] := '狙擊';

  //读取存档的索引
  if ZIP_SAVE = 0 then
  begin
    IDX := FileOpen(AppPath + 'save/ranger.idx', fmopenread);
    FileRead(IDX, RoleOffset, 4);
    FileRead(IDX, ItemOffset, 4);
    FileRead(IDX, ScenceOffset, 4);
    FileRead(IDX, MagicOffset, 4);
    FileRead(IDX, WeiShopOffset, 4);
    FileRead(IDX, LenR, 4);
    FileClose(IDX);
  end
  else
  begin
    filename := AppPath + 'save/0.zip';
    zfile := unzOpen(PChar(filename));
    if zfile <> nil then
    begin
      if (unzLocateFile(zfile, PChar('ranger.idx'), 2) = UNZ_OK) then
      begin
        unzOpenCurrentFile(zfile);
        unzReadCurrentFile(zfile, @RoleOffset, 4);
        unzReadCurrentFile(zfile, @ItemOffset, 4);
        unzReadCurrentFile(zfile, @ScenceOffset, 4);
        unzReadCurrentFile(zfile, @MagicOffset, 4);
        unzReadCurrentFile(zfile, @WeiShopOffset, 4);
        unzReadCurrentFile(zfile, @LenR, 4);
        unzCloseCurrentFile(zfile);
      end;
      unzClose(zfile);
    end;
  end;
  ScenceAmount := (MagicOffset - ScenceOffset) div sizeof(TScence);

  if KDEF_SCRIPT >= 2 then
  begin
    pEvent := ReadFileToBuffer(nil, AppPath + 'script/event.imz', -1, 1);
  end;

end;

//初始化主角属性

function InitialRole: boolean;
var
  i, x, y, len: integer;
  p: array[0..14] of integer;
  str0, str2: WideString;
  str, str1, Name: string;
  str3: string;
  p0, p1: pWideChar;
{$ifdef android}
  env: PJNIEnv;
  jstr: jstring;
  cstr: PChar;
  activity: jobject;
  clazz: jclass;
  method_id: jmethodID;
  e: TSDL_event;
{$endif}
begin
  LoadR(0);
  //显示输入姓名的对话框
  //form1.ShowModal;
  //str := form1.edit1.text;
  //showmessage(inttostr(where));
  //if FULLSCREEN = 1 then
  //RealScreen := SDL_SetVideoMode(RESOLUTIONX, RESOLUTIONY, 32, ScreenFlag);

  Name := '蕭笑竹'; //默认名
  str := '請輸入主角之姓名';
  if SIMPLE = 1 then
  begin
    Name := '萧笑竹'; //默认名
    str := '请输入主角之姓名';
  end;

{$ifdef android}
  ShowStatus(0);
  UpdateAllScreen;
  str0 := '點擊一下開始選屬性！';
  DrawTextWithRect(@str0[1], 175, CENTER_Y + 171, 10, ColColor($64), ColColor($66));
  env := SDL_AndroidGetJNIEnv();
  activity := SDL_AndroidGetActivity();
  clazz := env^.GetObjectClass(env, activity);
  method_id := env^.GetMethodID(env, clazz, 'mythSetName', '()Ljava/lang/String;');
  jstr := jstring(env^.CallObjectMethod(env, activity, method_id));
  cstr := env^.GetStringUTFChars(env, jstr, 0);
  Name := strpas(cstr);
  env^.ReleaseStringUTFChars(env, jstr, cstr);
  Result := True;
{$else}
  if FULLSCREEN = 0 then
    Result := inputquery('Enter name', str, Name)
  else
    Result := True;

  if FULLSCREEN = 1 then
  begin
    //RealScreen := SDL_SetVideoMode(CENTER_X * 2, CENTER_Y * 2, 32, ScreenFlag or SDL_FULLSCREEN);
    Redraw;
    UpdateAllScreen;
  end;
{$endif}

  Result := Result and (Name <> '');
  if Result then
  begin
    //if SIMPLE <> 0 then
    //Name := CP936ToUTF8(Simplified2Traditional(UTF8ToCP936(Name)));
    str2 := UTF8Decode(Name);
    p0 := @Rrole[0].Name;
    p1 := @str2[1];
    fillchar(Rrole[0].Name[0], 10, 0);
    for i := 0 to min(4, length(str2)) - 1 do
    begin
      p0^ := p1^;
      Inc(p0);
      Inc(p1);
    end;
    DivideName(pWideChar(@Rrole[0].Name[0]), str2, str0);
    ConsoleLog('%s, %s, %s', [WideString(pWideChar(@Rrole[0].Name[0])), str2, str0]);
    Redraw;
    str2 := '資質';
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

      Rrole[0].Aptitude := 50 + random(40);
      if MODVersion <> 13 then
        Rrole[0].Aptitude := random(100);
      Redraw;
      //showmessage('');
      ShowStatus(0);
      //showmessage('');
      DrawTextWithRect(@str2[1], 150, CENTER_Y + 120, 80, 0, $202020, 30, 0);
      str0 := format('%4d', [Rrole[0].Aptitude]);
      DrawEngShadowText(@str0[1], 200, CENTER_Y + 123, ColColor($64), ColColor($66));
      str0 := '選定屬性后按回車或這裡確認';
      DrawTextWithRect(@str0[1], 175, CENTER_Y + 171, 260, ColColor($64), ColColor($66));
      UpdateAllScreen;

      {while SDL_PollEvent(@event) do
      begin

      end;}
      i := WaitAnyKey;
      if MouseInRegion(175, CENTER_Y + 171, 260, 22) and (i <> SDLK_ESCAPE) then
        break;
      if i = SDLK_ESCAPE then
      begin
        Result := False;
        exit;
      end;
    until (i = SDLK_y) or (i = SDLK_RETURN);

    //设定初始成长
    InitGrowth();
    //特殊名字
    case MODVersion of
      0, 13, 31, 12, 41:
      begin
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

          Rrole[0].Aptitude := 100;
          Rrole[0].MagLevel[0] := 999;
        end;

        if Name = '風劍琴' then
        begin
          Rrole[0].addnum := 1;
          Rrole[0].AmiFrameNum[0] := 0;
        end;

        if (Name = '阮小二') then
        begin
          Rrole[0].addnum := 1;
          Rrole[0].Aptitude := 100;
          Rrole[0].MagLevel[0] := 999;
          Rrole[0].AmiFrameNum[0] := 1;
          if MODVersion = 13 then
            Rrole[0].HeadNum := 434;
        end;

        if (Name = '史進') then
        begin
          Rrole[0].addnum := 1;
          Rrole[0].Aptitude := 100;
          Rrole[0].MagLevel[0] := 999;
          Rrole[0].AmiFrameNum[0] := 2;
          if MODVersion = 13 then
            Rrole[0].HeadNum := 435;
        end;

        if (Name = '晁蓋') then
        begin
          Rrole[0].Aptitude := 100;
          Rrole[0].MagLevel[0] := 999;
          Rrole[0].AmiFrameNum[0] := 12;
        end;

        if (Name = '筷子') then
        begin
          instruct_32(277, 1);
          Rrole[0].Fist := 150;
          Ritem[277].ItemType := 1;
          Ritem[277].EquipType := 0;
          Ritem[277].AddSpeed := 150;
          Ritem[277].AddAttack := 75;
          Ritem[277].NeedMPType := 2;
        end;

        if Name = '獨孤令狐' then
        begin
          instruct_33(0, $A8, 1);
          Ritem[$27].AddAttack := 160;
          Ritem[$65].AddAttack := 8;
          Ritem[$6C].AddAttack := 10;
          Ritem[$A5].AddAttack := 6;
          Rrole[0].Movestep := 50;
          Rrole[0].AmiFrameNum[0] := 3;
          //Rrole[0].Magic[2] := $a8;
          //instruct_32($27, 1);
          //instruct_32($65, 1);
          //instruct_32($6c, 1);
          //instruct_32($a5, 1);
        end;
      end;
    end;
    Redraw;
    ShowStatus(0);
    //DrawShadowText(@str2[1], 30, CENTER_Y + 111, ColColor($21), ColColor($23));
    //str0 := format('%4d', [Rrole[0].Aptitude]);
    //DrawEngShadowText(@str0[1], 150, CENTER_Y + 111, ColColor($64), ColColor($66));
    UpdateAllScreen;
    //SDL_Delay(300);

    if MODVersion = 13 then
      StartAmi;
    instruct_14;
    //EndAmi;
  end;
end;

procedure InitGrowth();
var
  r: integer;
begin
  if Rrole[0].Aptitude > 75 then
  begin
    r := random(8);
    Rrole[0].IncLife := r + 14;
    r := random(8);
    Rrole[0].AddMP := r + 14;
    r := random(3);
    Rrole[0].AddAtk := r + 3;
    r := random(3);
    Rrole[0].AddDef := r + 3;
    r := random(3);
    Rrole[0].AddSpeed := r;
  end
  else
  if Rrole[0].Aptitude > 60 then
  begin
    r := random(8);
    Rrole[0].IncLife := r + 17;
    r := random(8);
    Rrole[0].AddMP := r + 17;
    r := random(3);
    Rrole[0].AddAtk := r + 4;
    r := random(3);
    Rrole[0].AddDef := r + 4;
    r := random(3);
    Rrole[0].AddSpeed := r + 1;
  end
  else
  begin
    r := random(8);
    Rrole[0].IncLife := r + 20;
    r := random(8);
    Rrole[0].AddMP := r + 20;
    r := random(3);
    Rrole[0].AddAtk := r + 5;
    r := random(3);
    Rrole[0].AddDef := r + 5;
    r := random(3);
    Rrole[0].AddSpeed := r + 1;
  end;
end;

procedure BufferRead(var p: PChar; buf: PChar; size: integer);
begin
  move(p^, buf^, size);
  p := p + size;
end;

procedure BufferWrite(var p: PChar; buf: PChar; size: integer);
begin
  move(buf^, p^, size);
  p := p + size;
end;

//读入存档, 如为0则读入起始存档
//返回值表示是否成功
function LoadR(num: integer): boolean;
var
  zfilename, filenamer, filenames, filenamed, s: string;
  str, p, p1: PChar;
  key1, key2: pbyte;
  IDX, GRP, t1, offset, i, j, i1, i2, lenkey: integer;
  zfile: unzfile;
  file_info: unz_file_info;
  talkarray: array of byte;
  temp: array[0..1000] of smallint;
begin
  Result := True;

  p := StrAlloc(LenR + 8192);

  SaveNum := num;
  zfilename := AppPath + 'save/' + IntToStr(num) + '.zip';
  if (num > 0) and (ZIP_SAVE = 1) then
    s := '1'
  else
    s := IntToStr(num);
  filenamer := 'r' + s + '.grp';
  if num = 0 then
    filenamer := 'ranger.grp';
  filenames := 's' + s + '.grp';
  if num = 0 then
    filenames := 'allsin.grp';
  filenamed := 'd' + s + '.grp';
  if num = 0 then
    filenamed := 'alldef.grp';

  if ZIP_SAVE = 0 then
  begin
    if FileExists(AppPath + 'save/' + filenamer) and FileExists(AppPath + 'save/' + filenames) and
      FileExists(AppPath + 'save/' + filenamed) then
    begin
      GRP := FileOpen(AppPath + 'save/' + filenamer, fmopenread);
      FileRead(GRP, p^, lenR);
      FileClose(GRP);
      GRP := FileOpen(AppPath + 'save/' + filenames, fmopenread);
      FileRead(GRP, Sdata, ScenceAmount * 64 * 64 * 6 * 2);
      FileClose(GRP);
      GRP := FileOpen(AppPath + 'save/' + filenamed, fmopenread);
      FileRead(GRP, Ddata, ScenceAmount * 200 * 11 * 2);
      FileClose(GRP);
    end
    else
    begin
      Result := False;
    end;
  end
  else
  begin
    zfile := unzOpen(PChar(zfilename));
    if (zfile <> nil) then
    begin
      if (unzLocateFile(zfile, PChar(filenamer), 2) = UNZ_OK) and (unzLocateFile(zfile, PChar(filenames), 2) = UNZ_OK) and
        (unzLocateFile(zfile, PChar(filenamed), 2) = UNZ_OK) then
      begin
        unzLocateFile(zfile, PChar(filenamer), 2);
        unzOpenCurrentFile(zfile);
        unzGetCurrentFileInfo(zfile, @file_info, nil, 0, nil, 0, nil, 0);
        //LenOfData := file_info.uncompressed_size;
        unzReadCurrentFile(zfile, p, LenR);
        unzCloseCurrentFile(zfile);
        unzLocateFile(zfile, PChar(filenames), 2);
        unzOpenCurrentFile(zfile);
        unzReadCurrentFile(zfile, @Sdata[0, 0, 0, 0], sizeof(Sdata));
        unzCloseCurrentFile(zfile);
        unzLocateFile(zfile, PChar(filenamed), 2);
        unzOpenCurrentFile(zfile);
        unzReadCurrentFile(zfile, @Ddata[0, 0, 0], sizeof(Ddata));
        unzCloseCurrentFile(zfile);
      end
      else
      begin
        Result := False;
      end;
      unzClose(zfile);
    end
    else
    begin
      Result := False;
    end;
  end;

  if Result then
  begin
    p1 := p;
    BufferRead(p1, @Inship, 2);
    BufferRead(p1, @useless1, 2);
    BufferRead(p1, @My, 2);
    BufferRead(p1, @Mx, 2);
    BufferRead(p1, @Sy, 2);
    BufferRead(p1, @Sx, 2);
    BufferRead(p1, @Mface, 2);
    BufferRead(p1, @shipx, 2);
    BufferRead(p1, @shipy, 2);
    BufferRead(p1, @shipx1, 2);
    BufferRead(p1, @shipy1, 2);
    BufferRead(p1, @shipface, 2);
    BufferRead(p1, @teamlist[0], 2 * 6);
    BufferRead(p1, @Ritemlist[0], sizeof(Titemlist) * MAX_ITEM_AMOUNT);

    BufferRead(p1, @Rrole[0], ItemOffset - RoleOffset);
    if (num = 0) or (MODVersion = 13) or (MODVersion = 31) then
      BufferRead(p1, @Ritem[0], ScenceOffset - ItemOffset)
    else
      p1 := p1 + ScenceOffset - ItemOffset;
    BufferRead(p1, @Rscence[0], MagicOffset - ScenceOffset);
    if num = 0 then
      BufferRead(p1, @Rmagic[0], WeiShopOffset - MagicOffset)
    else
      p1 := p1 + WeiShopOffset - MagicOffset;
    BufferRead(p1, @Rshop[0], lenR - WeiShopOffset);
    //ShipX1:=-1;
    //if Rrole[167].HeadNum <> 167 then ShipX1 := Rrole[167].HeadNum;
    //Rrole[167].HeadNum := 167;
    if ShipX1 >= 0 then
    begin
      CurScence := ShipX1;
      where := 1;
    end
    else
    begin
      CurScence := -1;
      where := 0;
    end;

    if num = 0 then
    begin
      where := 3;
      CurScence := BEGIN_SCENCE;
      Sx := BEGIN_Sx;
      Sy := BEGIN_Sy;
    end;

    //初始化入口

    ReSetEntrance;

    RoleName[0] := pWideChar(@Rrole[0].Name[0]);
    if MODVersion=13 then
    begin
      BEGIN_MISSION_NUM := Rrole[650].Data[0];
      setlength(MissionStr, MISSION_AMOUNT);

      for i := 0 to MISSION_AMOUNT - 1 do
      begin
        ReadTalk(BEGIN_MISSION_NUM + i, talkarray);
        MissionStr[i] := pWideChar(@talkarray[0]);
      end;
    end;
  end;
  StrDispose(p);

  ScreenBlendMode := 0;
  ShowMR := True;
  //blackscreen := 0;
  //callevent(290);
  //callevent(319);
  //callevent(1311);

  //兼容存档, 判别标准是慕容复头像
  {if Rrole[882].HeadNum = 433 then
  begin
    for i := 1 to high(Rrole) do
      Rrole[i].ActionNum := Rrole[i].HeadNum;
    Rrole[882].HeadNum := 149;
  end;}

  if num = 0 then
  begin
    //if MODVersion = 13 then
    move(Rrole[low(Rrole)], Rrole0[low(Rrole0)], sizeof(TRole) * length(Rrole));
    for i:=0 to High(rrole) do
      correctmagic(i);
  end
  else
  //物品使用者修正
  if MODVersion <> 13 then
    for i := 0 to high(Rrole) do
    begin
      if Rrole[i].Level <= 0 then
        break;
      if Rrole[i].PracticeBook >= 0 then
        Ritem[Rrole[i].PracticeBook].User := i;
      if Rrole[i].Equip[0] >= 0 then
        Ritem[Rrole[i].Equip[0]].User := i;
      if Rrole[i].Equip[1] >= 0 then
        Ritem[Rrole[i].Equip[1]].User := i;
    end;

  //物品修正, 判断标准为最后一个物品的数量
  if Ritemlist[MAX_ITEM_AMOUNT - 1].Amount <> 0 then
  begin
    ConsoleLog('Item list format is old, now converting...');
    move(Ritemlist[0], temp[0], sizeof(Titemlist) * MAX_ITEM_AMOUNT);
    for i := 0 to MAX_ITEM_AMOUNT - 1 do
    begin
      Ritemlist[i].Number := -1;
      Ritemlist[i].Amount := 0;
      if temp[i * 2] >= 0 then
      begin
        Ritemlist[i].Number := temp[i * 2];
        Ritemlist[i].Amount := temp[i * 2 + 1];
      end;
    end;
  end;


  {for i1 := 900 downto 00 do
  begin
    for i2 := 0 to 4 do
      FightFrame[Rrole[i1].HeadNum, i2] := Rrole[i1].AmiFrameNum[i2];
  end;
  idx := filecreate('fightframe.ka');
  filewrite(idx, fightframe[0, 0], sizeof(fightframe));
  fileclose(idx);}

  //以下用于转码
  {if Rrole[166].HeadNum <> 16 then
  begin
    Rrole[166].HeadNum := 16;
    for i1 := 0 to high(Rrole) do
    begin
      big5tou16(@Rrole[i1].Name[0]);
    end;
    for i1 := 0 to high(Rmagic) do
    begin
      big5tou16(@Rmagic[i1].Name[0]);
      big5tou16(@Rmagic[i1].Name0[0]);
    end;
    for i1 := 0 to high(Rscence) do
    begin
      big5tou16(@Rscence[i1].Name[0]);
    end;
    for i1 := 0 to high(Ritem) do
    begin
      big5tou16(@Ritem[i1].Name[0]);
      big5tou16(@Ritem[i1].Introduction[0]);
    end;
  end;}
  //测试武功显示使用, 发布时需去掉
  //instruct_33(0, 369, 1);
  //instruct_33(0, 372, 1);
  //instruct_2(59,1);

end;

//存档

function SaveR(num: integer): boolean;
var
  zfilename, filenamer, filenames, filenamed, s: string;
  key1, key2: pbyte;
  p, p1: PChar;
  IDX, GRP, i1, i2: integer;
  BasicOffset, i: integer;
  zfile: zipfile;
  file_info: zip_fileinfo;
begin
  Result := True;
  BasicOffset := 0;
  if where = 1 then
  begin
    ShipX1 := CurScence;
  end
  else
    ShipX1 := -1;

  p := StrAlloc(LenR + 4);
  p1 := p;

  BufferWrite(p1, @Inship, 2);
  BufferWrite(p1, @useless1, 2);
  BufferWrite(p1, @My, 2);
  BufferWrite(p1, @Mx, 2);
  BufferWrite(p1, @Sy, 2);
  BufferWrite(p1, @Sx, 2);
  BufferWrite(p1, @Mface, 2);
  BufferWrite(p1, @shipx, 2);
  BufferWrite(p1, @shipy, 2);
  BufferWrite(p1, @shipx1, 2);
  BufferWrite(p1, @shipy1, 2);
  BufferWrite(p1, @shipface, 2);
  BufferWrite(p1, @teamlist[0], 2 * 6);
  BufferWrite(p1, @Ritemlist[0], sizeof(Titemlist) * MAX_ITEM_AMOUNT);

  BufferWrite(p1, @Rrole[0], ItemOffset - RoleOffset);
  BufferWrite(p1, @Ritem[0], ScenceOffset - ItemOffset);
  BufferWrite(p1, @Rscence[0], MagicOffset - ScenceOffset);
  BufferWrite(p1, @Rmagic[0], WeiShopOffset - MagicOffset);
  BufferWrite(p1, @Rshop[0], LenR - WeiShopOffset);

  SaveNum := num;
  zfilename := AppPath + 'save/' + IntToStr(num) + '.zip';
  if (num > 0) and (ZIP_SAVE = 1) then
    s := '1'
  else
    s := IntToStr(num);
  filenamer := 'r' + s + '.grp';
  if num = 0 then
    filenamer := 'ranger.grp';
  filenames := 's' + s + '.grp';
  if num = 0 then
    filenames := 'allsin.grp';
  filenamed := 'd' + s + '.grp';
  if num = 0 then
    filenamed := 'alldef.grp';

  if ZIP_SAVE = 0 then
  begin
    GRP := filecreate(AppPath + 'save/' + filenamer, fmopenreadwrite);
    if GRP < 0 then
      Result := False
    else
    begin
      FileSeek(GRP, 0, 0);
      FileWrite(GRP, p^, lenR);
      FileClose(GRP);
    end;
    GRP := filecreate(AppPath + 'save/' + filenames);
    if GRP < 0 then
      Result := False
    else
    begin
      FileWrite(GRP, Sdata, ScenceAmount * 64 * 64 * 6 * 2);
      FileClose(GRP);
    end;
    GRP := filecreate(AppPath + 'save/' + filenamed);
    if GRP < 0 then
      Result := False
    else
    begin
      FileWrite(GRP, Ddata, ScenceAmount * 200 * 11 * 2);
      FileClose(GRP);
    end;
  end
  else
  begin
    zfile := zipOpen(PChar(zfilename), 0);
    if zfile = nil then
    begin
      Result := False;
    end
    else
    begin
      zipOpenNewFileInZip(zFile, PChar(filenamer), nil, nil, 0, nil, 0, nil, Z_DEFLATED, Z_DEFAULT_COMPRESSION);
      zipWriteInFileInZip(zFile, p, lenR);
      zipCloseFileInZip(zfile);
      zipOpenNewFileInZip(zFile, PChar(filenames), nil, nil, 0, nil, 0, nil, Z_DEFLATED, Z_DEFAULT_COMPRESSION);
      zipWriteInFileInZip(zFile, @Sdata[0, 0, 0, 0], ScenceAmount * 64 * 64 * 6 * 2);
      zipCloseFileInZip(zfile);
      zipOpenNewFileInZip(zFile, PChar(filenamed), nil, nil, 0, nil, 0, nil, Z_DEFLATED, Z_DEFAULT_COMPRESSION);
      zipWriteInFileInZip(zFile, @Ddata[0, 0, 0], ScenceAmount * 200 * 11 * 2);
      zipCloseFileInZip(zfile);
      zipClose(zfile, nil);
    end;
  end;
  StrDispose(p);

end;

//等待任意按键

function WaitAnyKey: integer;
var
  x, y: integer;
begin
  //event.type_ := SDL_NOEVENT;
  //SDL_EventState(SDL_KEYDOWN, SDL_ENABLE);
  //SDL_EventState(SDL_KEYUP, SDL_ENABLE);
  //SDL_EventState(SDL_mousebuttonUP, SDL_ENABLE);
  //SDL_EventState(SDL_mousebuttonDOWN, SDL_ENABLE);
  event.key.keysym.sym := 0;
  event.button.button := 0;
  while (SDL_PollEvent(@event) >= 0) do
  begin
    CheckBasicEvent;
    if (event.type_ = SDL_KEYUP) or (event.type_ = SDL_MOUSEBUTTONUP) then
      if (event.key.keysym.sym <> 0) or (event.button.button <> 0) then
        break;
    SDL_Delay(20);
  end;
  Result := event.key.keysym.sym;

  if event.button.button = SDL_BUTTON_LEFT then
  begin
    Result := SDLK_SPACE;
    if CellPhone = 1 then
    begin
      SDL_GetMouseState2(x, y);
      if (y < 100) then
        Result := SDLK_UP;
      if (x < 100) then
        Result := SDLK_LEFT;
      if (x > CENTER_X * 2 - 100) then
        Result := SDLK_RIGHT;
      if (y > CENTER_Y * 2 - 100) then
        Result := SDLK_DOWN;
      if (x < 100) and (y > CENTER_Y * 2 - 100) then
        Result := SDLK_RETURN;
      if (x > CENTER_X * 2 - 100) and (y > CENTER_Y * 2 - 100) then
        Result := SDLK_RETURN;
    end;
  end;
  if event.button.button = SDL_BUTTON_RIGHT then
    Result := SDLK_ESCAPE;

  event.key.keysym.sym := 0;
  event.button.button := 0;
end;

//于主地图行走

procedure Walk;
var
  word: array[0..10] of uint16;
  x, y, walking, Mx1, My1, Mx2, My2, i, i1, i2, stillcount, x1, y1: integer;
  axp, ayp, axp1, ayp1, gotoEntrance, minstep, step, drawed, speed: integer;
  now, next_time, next_time2, next_time3: uint32;
  pos: TPosition;
  info: WideString;
begin
  if where >= 3 then
    exit;
  next_time := SDL_GetTicks;
  next_time2 := SDL_GetTicks;
  next_time3 := SDL_GetTicks;

  Mx1 := 0;
  Mx2 := 0;

  Where := 0;
  walking := 0;
  //speed := 0;
  DrawMMap;
  UpdateAllScreen;
  //SDL_EnableKeyRepeat(50, 30);
  //StopMp3;
  //PlayMp3(16, -1);
  still := 0;
  stillcount := 0;
  MStep := 0;
  //事件轮询(并非等待)
  while SDL_PollEvent(@event) >= 0 do
  begin
    //如果当前处于标题画面, 则退出, 用于战斗失败
    if where >= 3 then
      break;

    //主地图动态效果
    now := SDL_GetTicks;

    //闪烁效果
    if (integer(now - next_time2) > 0) {and (still =  1)} then
    begin
      //ChangeCol;
      next_time2 := now + 200;
      //DrawMMap;
      //updateallscreen;
    end;

    //飘云
    if (integer(now - next_time3) > 0) and (MMAPAMI > 0) then
    begin
      for i := 0 to CLOUD_AMOUNT - 1 do
      begin
        Cloud[i].Positionx := Cloud[i].Positionx + Cloud[i].Speedx;
        Cloud[i].Positiony := Cloud[i].Positiony + Cloud[i].Speedy;
        if (Cloud[i].Positionx > 17279) or (Cloud[i].Positionx < 0) or (Cloud[i].Positiony > 8639) or (Cloud[i].Positiony < 0) then
        begin
          CloudCreateOnSide(i);
        end;
      end;
      next_time3 := now + 40;
      //DrawMMap;
      //updateallscreen;
    end;

    //主角动作
    if (integer(now - next_time) > 0) and (Where = 0) then
    begin
      if (walking = 0) then
        stillcount := stillcount + 1
      else
        stillcount := 0;
      if stillcount >= 10 then
      begin
        if not (MODVersion in [31]) then
          still := 1;
        mstep := mstep + 1;
        if mstep > 6 then
          mstep := 1;
      end;
      next_time := now + 320;
    end;

    CheckBasicEvent;
    case event.type_ of
      //方向键使用压下按键事件, 按下方向设置状态为行走
      SDL_KEYDOWN:
      begin
        if (event.key.keysym.sym = SDLK_LEFT) then
        begin
          MFace := 2;
          walking := 1;
        end;
        if (event.key.keysym.sym = SDLK_RIGHT) then
        begin
          MFace := 1;
          walking := 1;
        end;
        if (event.key.keysym.sym = SDLK_UP) then
        begin
          MFace := 0;
          walking := 1;
        end;
        if (event.key.keysym.sym = SDLK_DOWN) then
        begin
          MFace := 3;
          walking := 1;
        end;
      end;
      //功能键(esc)使用松开按键事件
      SDL_KEYUP:
      begin
        if (keyup^ = 0) and (keydown^ = 0) and (keyleft^ = 0) and (keyright^ = 0) then
        begin
          walking := 0;
          speed := 0;
        end;
        case event.key.keysym.sym of
          //SDLK_LEFT, SDLK_RIGHT, SDLK_UP, SDLK_DOWN: walking := 0;
          SDLK_ESCAPE:
          begin
            MenuEsc;
            if where >= 3 then
              break;
          end;
        end;
      end;
      SDL_MOUSEMOTION:
      begin
        if ShowVirtualKey = 0 then
        begin
          SDL_GetMouseState2(x1, y1);
          if (x1 < CENTER_X) and (y1 < CENTER_Y) then
            Mface := 2;
          if (x1 > CENTER_X) and (y1 < CENTER_Y) then
            Mface := 0;
          if (x1 < CENTER_X) and (y1 > CENTER_Y) then
            Mface := 3;
          if (x1 > CENTER_X) and (y1 > CENTER_Y) then
            Mface := 1;
        end;
      end;
      SDL_MOUSEBUTTONUP:
      begin
        if event.button.button = SDL_BUTTON_RIGHT then
        begin
          event.button.button := 0;
          MenuEsc;
          if where >= 3 then
            break;
          nowstep := -1;
          walking := 0;
        end;
        if event.button.button = SDL_BUTTON_LEFT then
        begin
          walking := 2;
          GetMousePosition(axp, ayp, Mx, My);
          if (axp >= 0) and (axp <= 479) and (ayp >= 0) and (ayp <= 479) {and canWalk(axp, ayp)} then
          begin
            FillChar(Fway[0, 0], sizeof(Fway), -1);
            FindWay(Mx, My);
            gotoEntrance := -1;
            if (Buildy[axp, ayp] > 0) and (Entrance[Axp, Ayp] < 0) then
            begin
              //点到建筑在附近格内寻找入口
              axp := Buildx[axp, ayp];
              ayp := Buildy[axp, ayp];
              for i1 := axp - 3 to axp do
                for i2 := ayp - 3 to ayp do
                  if (Entrance[i1, i2] >= 0) and (buildx[i1, i2] = axp) and (buildy[i1, i2] = ayp) then
                  begin
                    axp := i1;
                    ayp := i2;
                    break;
                  end;
            end;
            if Entrance[Axp, Ayp] >= 0 then
            begin
              minstep := 4096;
              for i := 0 to 3 do
              begin
                Axp1 := Axp;
                Ayp1 := Ayp;
                case i of
                  0: Axp1 := Axp - 1;
                  1: Ayp1 := Ayp + 1;
                  2: Ayp1 := Ayp - 1;
                  3: Axp1 := Axp + 1;
                end;
                step := Fway[Axp1, Ayp1];
                if (step >= 0) and (minstep > step) then
                begin
                  gotoEntrance := i;
                  minstep := step;
                end;
              end;
              if gotoEntrance >= 0 then
              begin
                case gotoEntrance of
                  0: Axp := Axp - 1;
                  1: Ayp := Ayp + 1;
                  2: Ayp := Ayp - 1;
                  3: Axp := Axp + 1;
                end;
                gotoEntrance := 3 - gotoEntrance;
              end;
            end;
            Moveman(Mx, My, Axp, Ayp);
            nowstep := Fway[Axp, Ayp] - 1;
          end
          else
          begin
            walking := 0;
          end;
        end;
      end;
    end;

    //如果主角正在行走, 则移动主角
    if walking > 0 then
    begin
      still := 0;
      stillcount := 0;
      case walking of
        1:
        begin
          speed := speed + 1;
          Mx1 := Mx;
          My1 := My;
          case mface of
            0: Mx1 := Mx1 - 1;
            1: My1 := My1 + 1;
            2: My1 := My1 - 1;
            3: Mx1 := Mx1 + 1;
          end;
          Mstep := Mstep + 1;
          if Mstep >= 7 then
            Mstep := 1;
          if CanWalk(Mx1, My1) = True then
          begin
            Mx := Mx1;
            My := My1;
          end;
          //第一步时短暂停止方便可以只走一格
          if (speed <= 1) then
            SDL_Delay(50);
        end;
        2:
        begin
          if nowstep < 0 then
          begin
            walking := 0;
            if gotoEntrance >= 0 then
            begin
              Mface := gotoEntrance;
              //CheckEntrance;
            end;
          end
          else
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

            MStep := MStep + 1;

            if MStep >= 7 then
              MStep := 1;
            if (abs(Mx - linex[nowstep]) + abs(My - liney[nowstep]) = 1) and CanWalk(linex[nowstep], liney[nowstep]) then
            begin
              Mx := linex[nowstep];
              My := liney[nowstep];
            end
            else
            begin
              walking := 0;
            end;
            Dec(nowstep);
          end;
        end;
      end;

      //每走一步均重画屏幕, 并检测是否处于某场景入口
      Redraw;
      UpdateAllScreen;
      if CheckEntrance then
      begin
        walking := 0;
        MStep := 0;
        still := 0;
        stillcount := 0;
        //speed := 0;
        if MMAPAMI = 0 then
        begin
          DrawMMap;
          UpdateAllScreen;
        end;
      end;

      //SDL_Delay(WALK_SPEED);
    end;

    if where = 1 then
    begin
      WalkInScence(0);
    end;

    event.key.keysym.sym := 0;
    event.button.button := 0;
    //走路时不重复画了
    if (walking = 0) and (where = 0) then
    begin
      if MMAPAMI > 0 then
      begin
        DrawMMap;
        GetMousePosition(axp, ayp, Mx, My);
        //if CanWalk(axp, ayp) then
        pos := GetPositionOnScreen(axp, ayp, Mx, My);
        DrawMPic(1, pos.x, pos.y, -1, 0, 50, 0, 0);
        if not CanWalk(axp, ayp) then
        begin
          if Entrance[axp, ayp] >= 0 then
            DrawMPic(2001, pos.x, pos.y, -1, 0, 75, 0, 0)
          else
            DrawMPic(2001, pos.x, pos.y, -1, 0, 50, 0, 0);
        end;
        UpdateAllScreen;
      end;
      SDL_Delay(40); //静止时只需刷新率与最频繁的动态效果相同即可
    end
    else
      SDL_Delay(WALK_SPEED);
    //writeln(event.type_);
  end;

end;


//判定主地图某个位置能否行走, 是否变成船
//function in kys_main.pas

function CanWalk(x, y: integer): boolean;
begin
  if (MODVersion = 13) and (CellPhone = 0) then
  begin
    Result := False;
    if (x >= 0) and (y >= 0) and (x < 480) and (y < 480) then
    begin
      if buildx[x, y] = 0 then
        Result := True
      else
        Result := False;
      //canwalk:=true;  //This sentence is used to test.
      if (x <= 0) or (x >= 479) or (y <= 0) or (y >= 479) or ((surface[x, y] >= 1692) and (surface[x, y] <= 1700)) then
        Result := False;
      if (earth[x, y] = 838) or ((earth[x, y] >= 612) and (earth[x, y] <= 670)) then
        Result := False;
      if ((earth[x, y] >= 358) and (earth[x, y] <= 362)) or ((earth[x, y] >= 506) and (earth[x, y] <= 670)) or
        ((earth[x, y] >= 1016) and (earth[x, y] <= 1022)) then
      begin
        if (Inship = 1) then //isship
        begin
          if (earth[x, y] = 838) or ((earth[x, y] >= 612) and (earth[x, y] <= 670)) then
          begin
            Result := False;
          end
          else if ((surface[x, y] >= 1746) and (surface[x, y] <= 1788)) then
          begin
            Result := False;
          end
          else
            Result := True;
        end
        else
        if (x = shipy) and (y = shipx) then //touch ship?
        begin
          InShip := 0;
          Result := True;
        end
        else if (Mx = shipy) and (My = shipx) then //touch ship?
        begin
          InShip := 1;
          Result := True;
        end
        else
          //      InShip := 0;           //option_explicit_ori_on
          Result := False;
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
    end;
  end
  else
  begin
    if buildx[x, y] = 0 then
      Result := True
    else
      Result := False;
    if (x <= 0) or (x >= 479) or (y <= 0) or (y >= 479) then
      Result := False;
    if (earth[x, y] = 838) or ((earth[x, y] >= 612) and (earth[x, y] <= 670)) then
      Result := False;
    if ((earth[Mx, My] >= 358) and (earth[Mx, My] <= 362)) or ((earth[Mx, My] >= 506) and (earth[Mx, My] <= 670)) or
      ((earth[Mx, My] >= 1016) and (earth[Mx, My] <= 1022)) then
      InShip := 1
    else
      InShip := 0;
  end;
end;

procedure Moveman(x1, y1, x2, y2: integer);
var
  s, i, i1, i2, a, tempx, tx1, tx2, ty1, ty2, tempy: integer;
  Xinc, Yinc, dir: array[1..4] of integer;
begin
  if Fway[x2, y2] > 0 then
  begin
    Xinc[1] := 0;
    Xinc[2] := 1;
    Xinc[3] := -1;
    Xinc[4] := 0;
    Yinc[1] := -1;
    Yinc[2] := 0;
    Yinc[3] := 0;
    Yinc[4] := 1;
    linex[0] := x2;
    liney[0] := y2;
    for a := 1 to Fway[x2, y2] do
    begin
      for i := 1 to 4 do
      begin
        tempx := linex[a - 1] + Xinc[i];
        tempy := liney[a - 1] + Yinc[i];
        if Fway[tempx, tempy] = Fway[linex[a - 1], liney[a - 1]] - 1 then
        begin
          linex[a] := tempx;
          liney[a] := tempy;
          break;
        end;
      end;
    end;
  end;
end;

function FindWay(x1, y1: integer): boolean;
var
  Xlist: array[0..4096] of smallint;
  Ylist: array[0..4096] of smallint;
  steplist: array[0..4096] of smallint;
  curgrid, totalgrid: integer;
  Bgrid: array[1..4] of integer; //0空位, 1可过, 2已走过 ,3越界
  Xinc, Yinc: array[1..4] of integer;
  curX, curY, curstep, nextX, nextY: integer;
  i, mode: integer;
  CanWalk: boolean;
begin

  mode := MODVersion;
  if CellPhone = 1 then
    mode := 0;
  Result := False;
  Xinc[1] := 0;
  Xinc[2] := 1;
  Xinc[3] := -1;
  Xinc[4] := 0;
  Yinc[1] := -1;
  Yinc[2] := 0;
  Yinc[3] := 0;
  Yinc[4] := 1;
  curgrid := 0;
  totalgrid := 1;
  Xlist[0] := x1;
  Ylist[0] := y1;
  steplist[0] := 0;
  Fway[x1, y1] := 0;

  while curgrid < totalgrid do
  begin
    curX := Xlist[curgrid];
    curY := Ylist[curgrid];
    curstep := steplist[curgrid];
    //判断当前点四周格子的状况
    case where of
      1:
      begin
        for i := 1 to 4 do
        begin
          nextX := curX + Xinc[i];
          nextY := curY + Yinc[i];
          if (nextX < 0) or (nextX > 63) or (nextY < 0) or (nextY > 63) then
            Bgrid[i] := 3  //越界
          else if Fway[nextX, nextY] >= 0 then
            Bgrid[i] := 2 //已走过
          else if not CanWalkInScence(curx, cury, nextx, nexty) then
            Bgrid[i] := 1   //阻碍
          else
            Bgrid[i] := 0;
        end;
      end;
      0:
      begin
        for i := 1 to 4 do
        begin
          nextX := curX + Xinc[i];
          nextY := curY + Yinc[i];
          if (nextX < 0) or (nextX > 479) or (nextY < 0) or (nextY > 479) then
            Bgrid[i] := 3 //越界
          else if (Entrance[nextx, nexty] >= 0) then
            Bgrid[i] := 6 //入口
          else if Fway[nextX, nextY] >= 0 then
            Bgrid[i] := 2 //已走过
          else if buildx[nextx, nexty] > 0 then
            Bgrid[i] := 1 //阻碍
          else if ((surface[nextx, nexty] >= 1692) and (surface[nextx, nexty] <= 1700)) then
            Bgrid[i] := 1
          else if (earth[nextx, nexty] = 838) or ((earth[nextx, nexty] >= 612) and (earth[nextx, nexty] <= 670)) then
            Bgrid[i] := 1
          else if ((earth[nextx, nexty] >= 358) and (earth[nextx, nexty] <= 362)) or
            ((earth[nextx, nexty] >= 506) and (earth[nextx, nexty] <= 670)) or ((earth[nextx, nexty] >= 1016) and
            (earth[nextx, nexty] <= 1022)) then
          begin
            if (nextx = shipy) and (nexty = shipx) then
              Bgrid[i] := 4 //船
            else if ((surface[nextx, nexty] div 2 >= 863) and (surface[nextx, nexty] div 2 <= 872)) or
              ((surface[nextx, nexty] div 2 >= 852) and (surface[nextx, nexty] div 2 <= 854)) or
              ((surface[nextx, nexty] div 2 >= 858) and (surface[nextx, nexty] div 2 <= 860)) then
              Bgrid[i] := 0 //船
            else
              Bgrid[i] := 5; //水
          end
          else
            Bgrid[i] := 0;
        end;
      end;
      //移动的情况
    end;
    for i := 1 to 4 do
    begin
      case mode of
        13://where = 1 必定有 inship = 0, 严格吗?
          if ((inship = 1) and (Bgrid[i] = 5)) or (((Bgrid[i] = 0) or (Bgrid[i] = 4)) and (inship = 0)) then
          begin
            Xlist[totalgrid] := curX + Xinc[i];
            Ylist[totalgrid] := curY + Yinc[i];
            steplist[totalgrid] := curstep + 1;
            Fway[Xlist[totalgrid], Ylist[totalgrid]] := steplist[totalgrid];
            totalgrid := totalgrid + 1;
            if totalgrid > 4096 then
              exit;
          end;
        else
        begin
          CanWalk := False;
          case MODVersion of
            22:
            begin
              if ((inship = 1) and (Bgrid[i] = 5)) or (((Bgrid[i] = 0) or (Bgrid[i] = 4)) and (inship = 0)) then
                CanWalk := True;
            end;
            else
            begin
              if (Bgrid[i] = 0) or (Bgrid[i] = 4) or (Bgrid[i] = 5) or (Bgrid[i] = 7) then
                CanWalk := True;
            end;
          end;
          if CanWalk then
          begin
            Xlist[totalgrid] := curX + Xinc[i];
            Ylist[totalgrid] := curY + Yinc[i];
            steplist[totalgrid] := curstep + 1;
            Fway[Xlist[totalgrid], Ylist[totalgrid]] := steplist[totalgrid];
            totalgrid := totalgrid + 1;
            if totalgrid > 4096 then
              exit;
          end;
        end;
      end;
    end;
    curgrid := curgrid + 1;
    if (where = 0) and (curX - Mx > 22) and (curY - My > 22) then
      break;
  end;

end;


//Check able or not to ertrance a scence.
//检测是否处于某入口, 并是否达成进入条件

function CheckEntrance: boolean;
var
  x, y, i, snum: integer;
  minspeed: integer;
  //CanEntrance: boolean;
begin
  minspeed := 300;
  if MODVersion<>13 then minspeed:=70;
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
    if (Rscence[snum].EnCondition = 0) then
      Result := True;
    //是否有人轻功超过300
    if (Rscence[snum].EnCondition = 2) then
      for i := 0 to 5 do
        if teamlist[i] >= 0 then
          if Rrole[teamlist[i]].Speed > minspeed then
            Result := True;
    if Result = True then
    begin
      TurnBlack;
      CurScence := Entrance[x, y];
      SFace := MFace;
      //Mface := 3 - Mface;
      SStep := 0;
      Sx := Rscence[CurScence].EntranceX;
      Sy := Rscence[CurScence].EntranceY;
      //如达成条件, 进入场景并初始化场景坐标
      SaveR(11);
      WalkInScence(0);
      //showmessage('');
      CurScence := -1;
      BlackScreen := 0;
      //waitanykey;
    end;
    //instruct_13;
  end;
  //result := canentrance;
end;


procedure UpdateScenceAmi;
begin
  while True do
  begin
    if (where = 1) and (CurEvent < 0) and (not LoadingScence) and (NeedRefreshScence = 1) then
      InitialScence(2);
    if (where < 1) or (where > 2) then
      break;
    SDL_Delay(200);
  end;

end;

//Walk in a scence, the returned value is the scence number when you exit. If it is -1.
//InScence(1) means the new game.
//在内场景行走, 如参数为1表示新游戏

function WalkInScence(Open: integer): integer;
var
  GRP, IDX, offset, just, i1, i2, x, y, haveAmi, preface, drawed: integer;
  Sx1, Sy1, s, i, walking, Prescence, stillcount, speed: integer;
  axp, ayp, axp1, ayp1, gotoEvent, minstep, step, x1, y1: integer;
  filename: string;
  scencename: WideString;
  now, now2, next_time, next_time2, timer1, timer2: uint32;
  AmiCount: integer; //场景内动态效果计数
  keystate: PChar;
  UpDate: PSDL_Thread;
  pos: TPosition;
begin
  //LockScence := false;
  next_time := SDL_GetTicks;
  Where := 1;
  walking := 0; // 为0表示静止, 为1表示键盘行走, 为2表示鼠标行走
  just := 0;
  CurEvent := -1;
  AmiCount := 0;
  //speed := 0;
  stillcount := 0;
  exitscencemusicnum := Rscence[CurScence].ExitMusic;

  //SDL_EnableKeyRepeat(50, 30);
  InitialScence;
  for i := 0 to 199 do
    if (DData[CurScence, i, 7] < DData[CurScence, i, 6]) then
    begin
      DData[CurScence, i, 5] := DData[CurScence, i, 7] + DData[CurScence, i, 8] * 2 mod (DData[CurScence, i, 6] - DData[CurScence, i, 7] + 2);
    end;

  if Open = 1 then
  begin
    Sx := BEGIN_Sx;
    Sy := BEGIN_Sy;
    Cx := Sx;
    Cy := Sy;
    ShowMR := False;
    if MODVersion <> 13 then
    begin
      CurScenceRolePic := 3445;
      ShowMR := True;
      SFace := 1;
    end;
    CurEvent := SData[CurScence, 3, Sx, Sy];
    //DrawScence;
    CallEvent(BEGIN_EVENT);
    ShowMR := True;
    UpdateAllScreen;
    CurEvent := -1;
  end;

  SStep := 0;

  now2 := 0;
  TimeInWater := 15 + Rrole[0].CurrentMP div 100;

  CurScenceRolePic := BEGIN_WALKPIC2 + SFace * 7;
  DrawScence;
  ShowScenceName(CurScence);
  //是否有第3类事件位于场景入口
  CheckEvent3;
  //if SCENCEAMI = 2 then
  //UpDate := SDL_CreateThread(@UpdateScenceAmi, nil, nil);
  while (SDL_PollEvent(@event) >= 0) do
  begin
    timer1 := SDL_GetTicks();
    now2 := now2 + 20;
    if integer(now2) > 4000 then
    begin
      now2 := 0;
      TimeInWater := TimeInWater - 1;
    end;
    if where <> 1 then
      break;
    {if Sx > 63 then
      Sx := 63;
    if Sy > 63 then
      Sy := 63;
    if Sx < 0 then
      Sx := 0;
    if Sy < 0 then
      Sy := 0;}
    //场景内动态效果
    now := SDL_GetTicks;
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
      //if we never consider the change of color panel, there is no need to re-initial scence.
      //if (haveAmi > 0) then
      //if not (IsCave(CurScence)) then
      //if SCENCEAMI = 1 then
      //begin
      //InitialScence(1);
      //end;

      if walking = 0 then
        stillcount := stillcount + 1
      else
        stillcount := 0;
      if stillcount >= 10 then
      begin
        SStep := 0;
        stillcount := 0;
      end;

      next_time := now + 200;
      AmiCount := AmiCount + 1;
      //ChangeCol;
    end;

    //检查是否位于出口, 如是则退出
    if (((Sx = Rscence[CurScence].ExitX[0]) and (Sy = Rscence[CurScence].ExitY[0])) or
      ((Sx = Rscence[CurScence].ExitX[1]) and (Sy = Rscence[CurScence].ExitY[1])) or
      ((Sx = Rscence[CurScence].ExitX[2]) and (Sy = Rscence[CurScence].ExitY[2]))) then
    begin
      Where := 0;
      Result := -1;
      instruct_14; //黑屏
      break;
    end;
    //检查是否位于跳转口, 如是则重新初始化场景
    if ((Sx = Rscence[CurScence].JumpX1) and (Sy = Rscence[CurScence].JumpY1)) and (Rscence[CurScence].JumpScence >= 0) then
    begin
      instruct_14;
      PreScence := CurScence;
      CurScence := Rscence[CurScence].JumpScence;
      if Rscence[PreScence].MainEntranceX1 <> 0 then
      begin
        Sx := Rscence[CurScence].EntranceX;
        Sy := Rscence[CurScence].EntranceY;
      end
      else
      begin
        Sx := Rscence[CurScence].JumpX2;
        Sy := Rscence[CurScence].JumpY2;
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
      InitialScence;
      Walking := 0;
      now2 := 0;
      TimeInWater := 15 + Rrole[0].CurrentMP div 100;
      DrawScence;
      ShowScenceName(CurScence);
      CheckEvent3;
    end;

    CheckBasicEvent;
    case event.type_ of
      SDL_KEYUP:
      begin
        if (keyup^ = 0) and (keydown^ = 0) and (keyleft^ = 0) and (keyright^ = 0) then
        begin
          walking := 0;
          speed := 0;
        end;
        if (event.key.keysym.sym = SDLK_ESCAPE) then
        begin
          MenuEsc;
          if where >= 3 then
            break;
          walking := 0;
          //speed := 0;
          //mousewalking := 0;
        end;
        //按下回车或空格, 检查面对方向是否有第1类事件
        if (event.key.keysym.sym = SDLK_RETURN) or (event.key.keysym.sym = SDLK_SPACE) then
        begin
          CheckEvent1;
        end;
      end;
      SDL_KEYDOWN:
      begin
        if (event.key.keysym.sym = SDLK_LEFT) then
        begin
          SFace := 2;
          walking := 1;
        end;
        if (event.key.keysym.sym = SDLK_RIGHT) then
        begin
          SFace := 1;
          walking := 1;
        end;
        if (event.key.keysym.sym = SDLK_UP) then
        begin
          SFace := 0;
          walking := 1;
        end;
        if (event.key.keysym.sym = SDLK_DOWN) then
        begin
          SFace := 3;
          walking := 1;
        end;
      end;
      SDL_MOUSEMOTION:
      begin
        if ShowVirtualKey = 0 then
        begin
          SDL_GetMouseState2(x1, y1);
          if (x1 < CENTER_X) and (y1 < CENTER_Y) then
            Sface := 2;
          if (x1 > CENTER_X) and (y1 < CENTER_Y) then
            Sface := 0;
          if (x1 < CENTER_X) and (y1 > CENTER_Y) then
            Sface := 3;
          if (x1 > CENTER_X) and (y1 > CENTER_Y) then
            Sface := 1;
        end;
      end;
      SDL_MOUSEBUTTONUP:
      begin
        if event.button.button = SDL_BUTTON_RIGHT then
        begin
          MenuEsc;
          if where >= 3 then
            break;
          nowstep := 0;
          walking := 0;
          //speed := 0;
          if where = 0 then
          begin
            if Rscence[CurScence].ExitMusic >= 0 then
            begin
              StopMP3;
              PlayMP3(Rscence[CurScence].ExitMusic, -1);
            end;
            //DrawScence;
            break;
          end;
        end;
        if event.button.button = SDL_BUTTON_MIDDLE then
        begin
          CheckEvent1;
        end;
        if event.button.button = SDL_BUTTON_LEFT then
        begin
          if walking = 0 then
          begin
            walking := 2;
            GetMousePosition(Axp, Ayp, Sx, Sy, SData[CurScence, 4, Sx, Sy]);
            {if (axp < 0) or (axp > 63) or (ayp < 0) or (ayp > 63) then
            begin
              axp := Rscence[CurScence].ExitX[0];
              ayp := Rscence[CurScence].ExitY[0];;
            end;}
            if (axp >= 0) or (axp <= 63) or (ayp >= 0) or (ayp <= 63) then
            begin
              FillChar(Fway[0, 0], sizeof(Fway), -1);
              FindWay(Sx, Sy);
              gotoevent := -1;
              //在手机中放宽要求
              if (CellPhone = 1) and (SData[CurScence, 3, axp, ayp] < 0) then
              begin
                for i1 := axp + 1 downto axp do
                  for i2 := ayp + 1 downto ayp do
                  begin
                    if (SData[CurScence, 3, i1, i2] > 0) and not (CanWalkInScence(i1, i2)) then
                    begin
                      axp := i1;
                      ayp := i2;
                    end;
                  end;
              end;
              if (SData[CurScence, 3, axp, ayp] >= 0) then
              begin
                if abs(Axp - Sx) + Abs(Ayp - Sy) = 1 then
                begin
                  if Axp < Sx then
                    SFace := 0;
                  if Axp > Sx then
                    SFace := 3;
                  if Ayp < Sy then
                    SFace := 2;
                  if Ayp > Sy then
                    SFace := 1;
                  if CheckEvent1 then
                  begin
                    //检查到事件时则不动
                    walking := 0;
                  end;
                end
                else
                begin
                  if (not CanWalkInScence(Axp, Ayp)) then
                  begin
                    minstep := 4096;
                    for i := 0 to 3 do
                    begin
                      Axp1 := Axp;
                      Ayp1 := Ayp;
                      case i of
                        0: Axp1 := Axp - 1;
                        1: Ayp1 := Ayp + 1;
                        2: Ayp1 := Ayp - 1;
                        3: Axp1 := Axp + 1;
                      end;
                      step := Fway[Axp1, Ayp1];
                      if (step >= 0) and (minstep > step) then
                      begin
                        gotoEvent := i;
                        minstep := step;
                      end;
                    end;
                    if gotoEvent >= 0 then
                    begin
                      case gotoEvent of
                        0: Axp := Axp - 1;
                        1: Ayp := Ayp + 1;
                        2: Ayp := Ayp - 1;
                        3: Axp := Axp + 1;
                      end;
                      gotoEvent := 3 - gotoEvent;
                    end;
                  end;
                end;
              end;
              Moveman(Sx, Sy, axp, ayp);
              nowstep := Fway[axp, ayp] - 1;
            end
            else
            begin
              walking := 0;
            end;
          end
          else
            walking := 0;
          event.button.button := 0;
        end;
      end;
    end;

    //是否处于行走状态
    if walking > 0 then
    begin
      case walking of
        1:
        begin
          speed := speed + 1;
          stillcount := 0;
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
          if CanWalkInScence(Sx1, Sy1) = True then
          begin
            Sx := Sx1;
            Sy := Sy1;
          end;

          //一定步数之内一次动一格
          if (speed <= 1) then
            SDL_Delay(50);
        end;
        2:
        begin
          if nowstep >= 0 then
          begin
            if sign(liney[nowstep] - Sy) < 0 then
              SFace := 2
            else if sign(liney[nowstep] - Sy) > 0 then
              sFace := 1
            else if sign(linex[nowstep] - Sx) > 0 then
              SFace := 3
            else
              sFace := 0;
            SStep := SStep + 1;
            if SStep >= 7 then
              SStep := 1;
            if abs(Sx - linex[nowstep]) + abs(Sy - liney[nowstep]) = 1 then
            begin
              Sx := linex[nowstep];
              Sy := liney[nowstep];
            end
            else
            begin
              walking := 0;
              //speed := 0;
            end;
            Dec(nowstep);
          end
          else
          begin
            walking := 0;
            if gotoEvent >= 0 then
            begin
              Sface := gotoEvent;
              CheckEvent1;
            end;
          end;
        end;
      end;
      CurScenceRolePic := BEGIN_WALKPIC2 + SFace * 7 + SStep;
      DrawScence;
      UpdateAllScreen;
      CheckEvent3;
      //SDL_Delay(WALK_SPEED2);
    end;

    event.key.keysym.sym := 0;
    event.button.button := 0;

    if (walking = 0) and (where = 1) then
    begin
      if SCENCEAMI > 0 then
      begin
        //DrawScence;
        CurScenceRolePic := BEGIN_WALKPIC2 + SFace * 7 + SStep;
        DrawScence;
        if walking = 0 then
        begin
          GetMousePosition(Axp, Ayp, Sx, Sy, SData[CurScence, 4, Sx, Sy]);
          //if (axp >= 0) and (axp < 64) and (ayp >= 0) and (ayp < 64) then
          //begin
          pos := GetPositionOnScreen(axp, ayp, Sx, Sy);
          DrawMPic(1, pos.x, pos.y - SData[CurScence, 4, axp, ayp], 0, 0, 50, 0, 0);
          //DrawMPic(1, pos.x, pos.y);
          if not CanWalkInScence(axp, ayp) then
          begin
            if SData[CurScence, 3, axp, ayp] >= 0 then
              DrawMPic(2001, pos.x, pos.y - SData[CurScence, 4, axp, ayp], 0, 0, 75, 0, 0)
            else
              DrawMPic(2001, pos.x, pos.y - SData[CurScence, 4, axp, ayp], 0, 0, 50, 0, 0);
          end;
          //end;
        end;
        UpdateAllScreen;
      end;
      SDL_Delay(40);
    end
    else
    begin
      timer2 := SDL_GetTicks();
      //SDL_Delay(max(0, WALK_SPEED2-(timer2-timer1)));
      SDL_Delay(WALK_SPEED2);
    end;

  end;

  //if where <= 1 then
  MFace := SFace;

  if (exitscencemusicnum > 0) and (where <> 3) then
  begin
    StopMP3;
    PlayMP3(exitscencemusicnum, -1);
  end;
  {if LESS_VIDEOMEMERY <> 0 then
  begin
    DestoryAllTextures;
  end;}
end;

procedure ShowScenceName(snum: integer);
var
  scencename: WideString;
  //c: uint32;
begin
  UpdateAllScreen;
  //显示场景名
  scencename := PCharToUnicode(PChar(@Rscence[snum].Name[0]), 5);
  //c:=sdl_maprgba(screen.format,0,255,0,0);
  DrawTextWithRect(@scencename[1], CENTER_X - DrawLength(scencename) * 5 - 23, 100,
    0, 0, $202020);
  SDL_Delay(500);
  if LastShowScene <> snum then
  begin
    LastShowScene := snum; //改变音乐
    if Rscence[snum].EntranceMusic >= 0 then
    begin
      StopMP3;
      PlayMP3(Rscence[snum].EntranceMusic, -1);
    end;
  end;
end;


//判定场景内某个位置能否行走

function CanWalkInScence(x, y: integer): boolean; overload;
begin
  Result := CanWalkInScence(Sx, Sy, x, y);

end;

function CanWalkInScence(x1, y1, x, y: integer): boolean; overload;
begin
  Result := True;
  if (x < 0) or (x > 63) or (y < 0) or (y > 63) then
    Result := False
  else
  begin
    if (SData[CurScence, 1, x, y] <= 0) and (SData[CurScence, 1, x, y] >= -2) then
      Result := True
    else
      Result := False;
    if (abs(SData[CurScence, 4, x, y] - SData[CurScence, 4, x1, y1]) > 10) and (abs(x1 - x) + abs(y1 - y) = 1) then
      Result := False;
    if (SData[CurScence, 3, x, y] >= 0) and (Result) and (DData[CurScence, SData[CurScence, 3, x, y], 0] = 1) then
      Result := False;
    //直接判定贴图范围
    if ((SData[CurScence, 0, x, y] >= 358) and (SData[CurScence, 0, x, y] <= 362)) or (SData[CurScence, 0, x, y] = 522) or
      (SData[CurScence, 0, x, y] = 1022) or ((SData[CurScence, 0, x, y] >= 1324) and (SData[CurScence, 0, x, y] <= 1330)) or
      (SData[CurScence, 0, x, y] = 1348) then
      Result := False;
    //if SData[CurScence, 0, x, y] = 1358 * 2 then result := true;
  end;
end;

//检查是否有第1类事件, 如有则调用
//0号事件是否屏蔽, 需要注意

function CheckEvent1: boolean;
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
  Result := False;
  if SData[CurScence, 3, x, y] >= 0 then
  begin
    CurEvent := SData[CurScence, 3, x, y];
    if DData[CurScence, CurEvent, 2] > 0 then
    begin
      //writeln(DData[CurScence, SData[CurScence, 3, x, y], 2]);
      Cx := Sx;
      Cy := Sy;
      Sstep := 0;
      CurScenceRolePic := BEGIN_WALKPIC2 + SFace * 7 + SStep;
      CallEvent(DData[CurScence, CurEvent, 2]);
      Result := True;
    end;
  end;
  CurEvent := -1;
  if (MMAPAMI = 0) or (SCENCEAMI = 0) then
  begin
    Redraw;
    UpdateAllScreen;
  end;
end;

//检查是否有第3类事件, 如有则调用

function CheckEvent3: boolean;
var
  enum: integer;
begin
  enum := SData[CurScence, 3, Sx, Sy];
  Result := False;
  if (enum >= 0) and (DData[CurScence, enum, 4] > 0) then
  begin
    CurEvent := enum;
    //waitanykey;
    Cx := Sx;
    Cy := Sy;
    CallEvent(DData[CurScence, enum, 4]);
    Result := True;
    CurEvent := -1;
    if (MMAPAMI = 0) or (SCENCEAMI = 0) then
    begin
      Redraw;
      UpdateAllScreen;
    end;
  end;
end;

//Menus.
//通用选单, (位置(x, y), 宽度, 最大选项(编号均从0开始))
{
function CommonMenu(x, y, w, max, default: integer; menuString, menuEngString: array of WideString;
  fn: TPInt1): integer; overload;
var
  menu, menup, x1, y1: integer;
begin
  Result := CommonMenu(x, y, w, max, default, menuString, menuEngString, 1, $0, $202020,
      ColColor($64), ColColor($66), fn);
end;}

//显示通用选单(位置, 宽度, 最大值)
//这个通用选单包含两个字符串组, 可分别显示中文和英文

function CommonMenu(x, y, w, max, default: integer; menuString: array of WideString): integer; overload;
var
  menuEngString: array of WideString;
begin
  setlength(menuEngString, 0);
  Result := CommonMenu(x, y, w, max, default, menuString, menuEngString);
end;

function CommonMenu(x, y, w, max, default: integer; menuString, menuEngString: array of WideString): integer; overload;
begin
  Result := CommonMenu(x, y, w, max, default, menuString, menuEngString, 1, $0, $202020, ColColor($64), ColColor($66));
end;

function CommonMenu(x, y, w, max, default: integer; menuString, menuEngString: array of WideString; needFrame: integer;
  color1, color2, menucolor1, menucolor2: uint32): integer; overload;
var
  menu, menup, x1, y1, h, len, len1, lene, p, i: integer;

  procedure ShowCommonMenu;
  var
    i, alpha: integer;
    c1, c2: uint32;
  begin
    LoadFreshScreen(x, y);
    //if needframe = 1 then
    //DrawRectangle(x, y, w, max * 22 + 28, 0, ColColor(255), 50);
    for i := 0 to min(max, length(menuString) - 1) do
    begin
      if i = menu then
      begin
        alpha := 0;
        c1 := menucolor1;
        c2 := menucolor2;
      end
      else
      begin
        alpha := 10;
        c1 := color1;
        c2 := color2;
      end;
      //画菜单
      DrawTextFrame(x, y + i * h, len1, alpha);
      DrawShadowText(@menuString[i][1], x + 19, y + 3 + h * i, c1, c2);
      if p = 1 then
        DrawEngShadowText(@menuEngString[i][1], x + 19 + len * 10 + 20, y + 3 + h * i, c1, c2);
    end;

  end;

begin
  h := 28;
  menu := default;
  //标记是否需要英文字串
  if (length(menuEngString) > 0) and (length(menuString) = length(menuEngString)) then
    p := 1
  else
    p := 0;
  len := 0;
  lene := 0;
  //测试长度
  for i := 0 to high(menuString) do
  begin
    len1 := DrawLength(menuString[i]);
    if len1 > len then
      len := len1;
    if p = 1 then
    begin
      len1 := DrawLength(menuEngString[i]) + 2;
      if len1 > lene then
        lene := len1;
    end;
  end;
  len1 := len + lene;
  w := w + 40;
  RecordFreshScreen(x, y, w, max * h + h + 2);
  ShowCommonMenu;
  UpdateAllScreen;
  while (SDL_WaitEvent(@event) >= 0) do
  begin
    CheckBasicEvent;
    case event.type_ of
      SDL_KEYDOWN:
      begin
        if (event.key.keysym.sym = SDLK_DOWN) then
        begin
          menu := menu + 1;
          if menu > max then
            menu := 0;
          ShowCommonMenu;
          UpdateAllScreen;
        end;
        if (event.key.keysym.sym = SDLK_UP) then
        begin
          menu := menu - 1;
          if menu < 0 then
            menu := max;
          ShowCommonMenu;
          UpdateAllScreen;
        end;
      end;
      SDL_KEYUP:
      begin
        if ((event.key.keysym.sym = SDLK_ESCAPE)) {and (where <= 2)} then
        begin
          Result := -1;
          break;
        end;
        if (event.key.keysym.sym = SDLK_RETURN) or (event.key.keysym.sym = SDLK_SPACE) then
        begin
          Result := menu;
          break;
        end;
      end;
      SDL_MOUSEBUTTONUP:
      begin
        if (event.button.button = SDL_BUTTON_RIGHT) {and (where <= 2)} then
        begin
          Result := -1;
          break;
        end;
        if (event.button.button = SDL_BUTTON_LEFT) then
        begin
          if MouseInRegion(x, y, w, max * h + h + 2) then
          begin
            Result := menu;
            break;
          end;
        end;
      end;
      SDL_MOUSEMOTION:
      begin
        if MouseInRegion(x, y, w, max * h + h + 2, x1, y1) then
        begin
          menup := menu;
          menu := (y1 - y - 2) div h;
          if menu > max then
            menu := max;
          if menu < 0 then
            menu := 0;
          if menup <> menu then
          begin
            ShowCommonMenu;
            UpdateAllScreen;
          end;
        end;
      end;
    end;
  end;

  //清空键盘键和鼠标键值, 避免影响其余部分
  event.key.keysym.sym := 0;
  event.button.button := 0;
  FreeFreshScreen;
end;


//卷动选单

function CommonScrollMenu(x, y, w, max, maxshow: integer; menuString: array of WideString): integer; overload;
var
  menuEngString: array of WideString;
begin
  setlength(menuEngString, 0);
  Result := CommonScrollMenu(x, y, w, max, maxshow, menuString, menuEngString);
end;

function CommonScrollMenu(x, y, w, max, maxshow: integer; menuString, menuEngString: array of WideString): integer;
  overload;
var
  menu, menup, menutop, x1, y1, h, i, len, lene, len1, p: integer;

  procedure ShowCommonScrollMenu;
  var
    i, alpha: integer;
    c1, c2: uint32;
  begin
    LoadFreshScreen(x, y);
    //showmessage(inttostr(y));
    if max + 1 < maxshow then
      maxshow := max + 1;
    for i := menutop to menutop + maxshow - 1 do
    begin
      if (i = menu) and (i < length(menuString)) then
      begin
        alpha := 0;
        c1 := ColColor($64);
        c2 := ColColor($66);
      end
      else
      begin
        alpha := 10;
        c1 := 0;
        c2 := $202020;
      end;
      //画菜单
      DrawTextFrame(x, y + h * (i - menutop), len1, alpha);
      DrawShadowText(@menuString[i][1], x + 19, y + 3 + h * (i - menutop), c1, c2);
      if p = 1 then
        DrawEngShadowText(@menuEngString[i][1], x + 19 + (len + 1) * 20, y + 3 + h * (i - menutop),
          c1, c2);
    end;
  end;

begin
  menu := 0;
  menutop := 0;
  if maxshow > max + 1 then
    maxshow := max + 1;
  if (length(menuEngString) > 0) and (length(menuString) = length(menuEngString)) then
    p := 1
  else
    p := 0;
  //测试长度
  len := 0;
  lene := 0;
  for i := 0 to high(menuString) do
  begin
    len1 := DrawLength(menuString[i]);
    if len1 > len then
      len := len1;
    if p = 1 then
    begin
      len1 := DrawLength(menuEngString[i]) + 2;
      if len1 > lene then
        lene := len1;
    end;
  end;
  len1 := len + lene;
  w := len1 * 10 + 40;
  h := 28;
  RecordFreshScreen(x, y, w + 1, maxshow * h + 32);
  ShowCommonScrollMenu;
  //SDL_UpdateRect2(screen, x, y, w + 1, maxshow * 22 + 29);
  UpdateAllScreen;
  while (SDL_WaitEvent(@event) >= 0) do
  begin
    CheckBasicEvent;
    case event.type_ of
      SDL_KEYDOWN:
      begin
        if (event.key.keysym.sym = SDLK_DOWN) then
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
          ShowCommonScrollMenu;
          UpdateAllScreen;
        end;
        if (event.key.keysym.sym = SDLK_UP) then
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
          ShowCommonScrollMenu;
          UpdateAllScreen;
        end;
      end;
      SDL_KEYUP:
      begin
        if (event.key.keysym.sym = SDLK_PAGEDOWN) then
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
          ShowCommonScrollMenu;
          UpdateAllScreen;
        end;
        if (event.key.keysym.sym = SDLK_PAGEUP) then
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
          ShowCommonScrollMenu;
          UpdateAllScreen;
        end;
        if ((event.key.keysym.sym = SDLK_ESCAPE)) and (where <= 2) then
        begin
          Result := -1;
          //Redraw;
          UpdateAllScreen;
          break;
        end;
        if (event.key.keysym.sym = SDLK_RETURN) or (event.key.keysym.sym = SDLK_SPACE) then
        begin
          Result := menu;
          //Redraw;
          UpdateAllScreen;
          break;
        end;
      end;
      SDL_MOUSEBUTTONUP:
      begin
        if (event.button.button = SDL_BUTTON_RIGHT) and (where <= 2) then
        begin
          Result := -1;
          //Redraw;
          UpdateAllScreen;
          break;
        end;
        if (event.button.button = SDL_BUTTON_LEFT) then
        begin
          if MouseInRegion(x, y, w, max * h + 32) then
          begin
            Result := menu;
            //Redraw;
            UpdateAllScreen;
            break;
          end;
        end;
      end;
      SDL_MOUSEWHEEL:
      begin
        if (event.wheel.y < 0) then
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
          ShowCommonScrollMenu;
          UpdateAllScreen;
        end;
        if (event.wheel.y > 0) then
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
          ShowCommonScrollMenu;
          UpdateAllScreen;
        end;
      end;
      SDL_MOUSEMOTION:
      begin
        if MouseInRegion(x, y, w, max * h + 32, x1, y1) then
        begin
          menup := menu;
          menu := (y1 - y - 2) div h + menutop;
          if menu > max then
            menu := max;
          if menu < 0 then
            menu := 0;
          if menup <> menu then
          begin
            ShowCommonScrollMenu;
            UpdateAllScreen;
          end;
        end;
      end;
    end;
  end;
  //清空键盘键和鼠标键值, 避免影响其余部分
  event.key.keysym.sym := 0;
  event.button.button := 0;
  FreeFreshScreen;
end;

//仅有两个选项的横排选单, 为美观使用横排
//此类选单中每个选项限制为两个中文字, 仅适用于提问'继续', '取消'的情况

function CommonMenu2(x, y, w: integer; menuString: array of WideString; max: integer = 1): integer; overload;
var
  menu, menup, x1, y1, len, len1, i: integer;

  procedure ShowCommonMenu2;
  var
    alpha, i: integer;
    c1, c2: uint32;
  begin
    //redraw;
    LoadFreshScreen(x, y);
    //DrawRectangle(x, y, w * (max + 1) + 2, 26, 0, ColColor(255), 50);
    //if length(Menuengstring) > 0 then p := 1 else p := 0;
    for i := 0 to max do
    begin
      if i = menu then
      begin
        alpha := 0;
        c1 := ColColor($64);
        c2 := ColColor($66);
      end
      else
      begin
        alpha := 10;
        c1 := 0;
        c2 := $202020;
      end;
      //画菜单
      DrawTextFrame(x + i * w, y, len, alpha);
      DrawShadowText(@menuString[i][1], x + 19 + i * w, y + 3, c1, c2);
    end;

  end;

begin
  menu := 0;
  ////SDL_EnableKeyRepeat(0,10);
  //DrawMMap;
  //测试长度
  len := 0;
  for i := 0 to high(menuString) do
  begin
    len1 := DrawLength(menuString[i]);
    if len1 > len then
      len := len1;
  end;
  w := w + 40;

  RecordFreshScreen(x, y, w * (max + 1) + 3, 30);
  ShowCommonMenu2;
  UpdateAllScreen;
  CleanKeyValue;
  while (SDL_WaitEvent(@event) >= 0) do
  begin
    CheckBasicEvent;
    case event.type_ of
      SDL_KEYUP:
      begin
        if (event.key.keysym.sym = SDLK_LEFT) then
        begin
          menu := menu - 1;
          if menu < 0 then
            menu := max;
          ShowCommonMenu2;
          UpdateAllScreen;
        end;
        if (event.key.keysym.sym = SDLK_RIGHT) then
        begin
          menu := menu + 1;
          if menu > max then
            menu := 0;
          ShowCommonMenu2;
          UpdateAllScreen;
        end;
        if ((event.key.keysym.sym = SDLK_ESCAPE)) and (where <= 2) then
        begin
          Result := -1;
          //Redraw;
          UpdateAllScreen;
          break;
        end;
        if (event.key.keysym.sym = SDLK_RETURN) or (event.key.keysym.sym = SDLK_SPACE) then
        begin
          Result := menu;
          //Redraw;
          UpdateAllScreen;
          break;
        end;
      end;
      SDL_MOUSEBUTTONUP:
      begin
        if (event.button.button = SDL_BUTTON_RIGHT) and (where <= 2) then
        begin
          Result := -1;
          //ReDraw;
          UpdateAllScreen;
          break;
        end;
        if (event.button.button = SDL_BUTTON_LEFT) then
        begin
          if MouseInRegion(x, y, w * (max + 1), 29) then
          begin
            Result := menu;
            //Redraw;
            UpdateAllScreen;
            break;
          end;
        end;
      end;
      SDL_MOUSEMOTION:
      begin
        if MouseInRegion(x, y, w * (max + 1), 29, x1, y1) then
        begin
          menup := menu;
          menu := (x1 - x - 2) div w;
          if menu > max then
            menu := max;
          if menu < 0 then
            menu := 0;
          if menup <> menu then
          begin
            ShowCommonMenu2;
            UpdateAllScreen;
          end;
        end;
      end;
    end;
    CleanKeyValue;
  end;
  //清空键盘键和鼠标键值, 避免影响其余部分
  event.key.keysym.sym := 0;
  event.button.button := 0;
  FreeFreshScreen;

end;


//选择一名队员
//mask用来表示哪些人是可选的
//当list1为-1时, 表示复数选择, 这时返回的结果是按位表示是否(unfinished)

function SelectOneTeamMember(x, y: integer; str: WideString; list1, list2: integer; mask: integer = 63): integer;
var
  menu, amount, i, premenu, max, x1, y1: integer;
  menuString, menuEngString: array of WideString;
  //SimpleStatus: array[0..5] of PSDL_Surface;
  tempsur, tempsur2: PSDL_Surface;
  dest: TSDL_Rect;
  pos: array[0..5] of tposition;
  list: array[0..5] of integer;
begin
  //str := ('查看隊員狀態');
  //redraw;
  //TransBlackScreen;
  if str <> '' then
  begin
    DrawTextWithRect(@str[1], CENTER_X - 275, CENTER_Y - 193, 0, 0, $202020);
  end;
  //tempsur := SDL_DisplayFormat(screen);
  RecordFreshScreen(CENTER_X - 275, CENTER_Y - 160, 551, 310);
  for i := 0 to 2 do
  begin
    pos[2 * i].x := CENTER_X - 270;
    pos[2 * i + 1].x := CENTER_X;
    pos[2 * i].y := CENTER_Y - 150 + i * 100;
    pos[2 * i + 1].y := CENTER_Y - 150 + i * 100;
  end;
  LoadTeamSimpleStatus(max);

  menu := 0;
  premenu := -1;
  event.key.keysym.sym := 0;
  event.button.button := 0;
  while SDL_PollEvent(@event) >= 0 do
  begin
    if menu <> premenu then
    begin
      //SDL_BlitSurface(tempsur, nil, screen, nil);
      LoadFreshScreen(CENTER_X - 275, CENTER_Y - 160);
      DrawRectangle(CENTER_X - 275, CENTER_Y - 160, 550, 310, 0, ColColor($64), 50);
      for i := 0 to max do
      begin
        dest.x := pos[i].x;
        dest.y := pos[i].y;
        if i = menu then
        begin
          if 1 shl i and mask <> 0 then
            DrawSimpleStatusByTeam(i, pos[i].x, pos[i].y, 0, 0)
          else
          begin
            DrawSimpleStatusByTeam(i, pos[i].x, pos[i].y, MapRGBA(192, 16, 56), 30);
          end;
        end
        else
        begin
          DrawSimpleStatusByTeam(i, pos[i].x, pos[i].y, 0, 30);
        end;
      end;
      UpdateAllScreen;
      premenu := menu;
    end;
    CheckBasicEvent;
    if ((event.type_ = SDL_KEYDOWN) and (event.key.keysym.sym = SDLK_LEFT)) then
    begin
      menu := menu - 1;
      if menu < 0 then
        menu := max;
    end;
    if ((event.type_ = SDL_KEYDOWN) and (event.key.keysym.sym = SDLK_RIGHT)) then
    begin
      menu := menu + 1;
      if menu > max then
        menu := 0;
    end;
    if ((event.type_ = SDL_KEYDOWN) and (event.key.keysym.sym = SDLK_UP)) then
    begin
      //if menu = 0 then menu := max - (1 - max mod 2);
      menu := menu - 2;
      if menu < 0 then
        menu := menu + max + 1;
    end;
    if ((event.type_ = SDL_KEYDOWN) and (event.key.keysym.sym = SDLK_DOWN)) then
    begin
      menu := menu + 2;
      if menu > max then
        menu := menu - max - 1;
    end;
    if ((event.type_ = SDL_KEYUP) and (event.key.keysym.sym = SDLK_ESCAPE)) or ((event.type_ = SDL_MOUSEBUTTONUP) and
      (event.button.button = SDL_BUTTON_RIGHT)) then
    begin
      Result := -1;
      break;
    end;
    if ((event.type_ = SDL_KEYUP) and ((event.key.keysym.sym = SDLK_RETURN) or (event.key.keysym.sym = SDLK_SPACE))) or
      ((event.type_ = SDL_MOUSEBUTTONUP) and (event.button.button = SDL_BUTTON_LEFT)) then
    begin
      if (menu >= 0) and (menu <= max) and (1 shl menu and mask <> 0) then
      begin
        Result := menu;
        break;
      end;
    end;
    if (event.type_ = SDL_MOUSEMOTION) then
    begin
      menu := -1;
      if MouseInRegion(pos[0].x, pos[0].y, pos[5].x + 270 - pos[0].x, pos[5].y + 100 - pos[0].y, x1, y1) then
      begin
        menu := (y1 - pos[0].y) div 100 * 2 + (x1 - pos[0].x) div 270;
      end;
    end;
    SDL_Delay(10);
    event.key.keysym.sym := 0;
    event.button.button := 0;
  end;
  FreeFreshScreen;
  //waitanykey;

end;

//主选单

procedure MenuEsc;
var
  menu, menup, x1, y1, i, j, k: integer;
  pos, pathsign: array[0..3] of TPosition;
  temp, rotoscr, tempscr: PSDL_Surface;
  dest: TSDL_Rect;
  selected: boolean;
  info: WideString;
begin
  for i := 0 to 3 do
  begin
    TitleMenu[i].x := CENTER_X + 120 + 60 * i;
    TitleMenu[i].y := CENTER_Y - 240 + 5;
    TitleMenu[i].w := 60;
    TitleMenu[i].h := 30;
  end;
  MenuEscTeammate := 0;

  NeedRefreshScence := 0;
  pos[0].x := CENTER_X;
  pos[0].y := CENTER_Y - 120;
  pos[1].x := CENTER_X - 140;
  pos[1].y := CENTER_Y + 10;
  pos[2].x := CENTER_X + 140;
  pos[2].y := CENTER_Y + 10;
  pos[3].x := CENTER_X;
  pos[3].y := CENTER_Y + 140;

  //TransBlackScreen;
  RecordFreshScreen;
  CleanTextScreen;
  for i := DISABLE_MENU_AMI to 25 do
  begin
    LoadFreshScreen;
    DrawMPic(2020, CENTER_X - 193, CENTER_Y - 182, 0, 0, 100 - i * 4, 0, 0);
    for j := 0 to 3 do
    begin
      x1 := LinearInsert(i, 0, 25, CENTER_X, pos[j].x);
      y1 := LinearInsert(i, 0, 25, CENTER_Y, pos[j].y);
      DrawMPic(2021, x1 - 65, y1 - 70, 0, 0, 100 - i * 4, 0, 0);
      DrawMPic(2022 + j, x1 - 30, y1 - 25, 0, 0, 100 - i * 4, 0, 0);
    end;
    UpdateAllScreen;
    SDL_PollEvent(@event);
    CheckBasicEvent;
    if PRESENT_SYNC = 0 then
      SDL_Delay(10);
  end;
  //DrawMMap;
  //showmessage(inttostr(where));

  event.key.keysym.sym := 0;
  event.button.button := 0;
  selected := False;
  j := 0;
  menu := 0;
  menup := -1;
  //如果鼠标在其他有效位置重设初值
  for i := 0 to 3 do
  begin
    if MouseInRegion(pos[i].x - 65, pos[i].y - 70, 130, 140) then
    begin
      menu := i;
      break;
    end;
  end;

  while (SDL_PollEvent(@event) >= 0) do
  begin
    if where >= 3 then
    begin
      break;
    end;
    LoadFreshScreen;
    CleanTextScreen;
    if menup <> menu then
      j := 0;
    DrawMPic(2020, CENTER_X - 193, CENTER_Y - 182);
    for i := 0 to 3 do
    begin
      if i <> menu then
        DrawMPic(2021, pos[i].x - 65, pos[i].y - 70)
      else
      begin
        j := j + 6;
        if j >= 360 then
          j := 0;
        dest.x := pos[i].x - MPNGIndex[2021].w div 2;
        dest.y := pos[i].y - MPNGIndex[2021].h div 2;
        k := 45 - abs(j div 4 - 45);
        DrawMPic(2021, dest.x, dest.y, 0, 0, k, 0, k, 1, 1, j);
      end;
      DrawMPic(2022 + i, pos[i].x - 30, pos[i].y - 25);
    end;
    menup := menu;
    info := UTF8Decode(format('位置：(%3d, %3d)', [My, Mx]));
    DrawShadowText(@info[1], 5, 5, ColColor($64), ColColor($66));
    UpdateAllScreen;
    CheckBasicEvent;
    case event.type_ of
      SDL_KEYDOWN:
      begin

      end;
      SDL_KEYUP:
      begin
        if (event.key.keysym.sym = SDLK_UP) then
        begin
          menu := 0;
        end;
        if (event.key.keysym.sym = SDLK_LEFT) then
        begin
          menu := 1;
        end;
        if (event.key.keysym.sym = SDLK_RIGHT) then
        begin
          menu := 2;
        end;
        if (event.key.keysym.sym = SDLK_DOWN) then
        begin
          menu := 3;
        end;
        if (event.key.keysym.sym = SDLK_ESCAPE) then
        begin
          break;
        end;
        if (event.key.keysym.sym = SDLK_RETURN) or (event.key.keysym.sym = SDLK_SPACE) then
        begin
          selected := True;
        end;
        if (event.key.keysym.sym >= SDLK_1) and (event.key.keysym.sym <= SDLK_4) then
        begin
          menu := event.key.keysym.sym - SDLK_1;
          selected := True;
        end;
      end;
      SDL_MOUSEBUTTONUP:
      begin
        if event.button.button = SDL_BUTTON_RIGHT then
        begin
          break;
        end;
        if event.button.button = SDL_BUTTON_LEFT then
        begin
          menu := -1;
          for i := 0 to 3 do
          begin
            if MouseInRegion(pos[i].x - 65, pos[i].y - 70, 130, 140) then
            begin
              menu := i;
              break;
            end;
          end;
          if menu >= 0 then
            selected := True;
        end;
      end;
      SDL_MOUSEMOTION:
      begin
        menu := -1;
        for i := 0 to 3 do
        begin
          if MouseInRegion(pos[i].x - 65, pos[i].y - 70, 130, 140) then
          begin
            menu := i;
            break;
          end;
        end;
      end;
    end;
    if selected then
    begin
      selected := False;
      while (menu >= 0) and (menu <= 3) do
      begin
        MenuEscType := menu;
        case menu of
          0: MenuStatus;
          1: MenuAbility;
          2: MenuItem;
          3: MenuSystem;
          //物品和系统有可能使屏幕内容变化
        end;
        if (where < 3) and ((menu = 2) or (menu = 3)) then
        begin
          FreeFreshScreen;
          Redraw;
          //TransBlackScreen;
          RecordFreshScreen;
          //tempscr := SDL_DisplayFormat(screen);
        end;
        menu := MenuEscType;
      end;
      //引入此处主要为脚本控制esc的选项
      if MenuEscType = -2 then
        break;
    end;
    CleanKeyValue;
    SDL_Delay(30);
  end;
  CleanKeyValue;
  //SDL_FreeSurface(tempscr);

  //redraw;

  //if (MenuEscType > -2) then
  begin
    for i := 25 downto DISABLE_MENU_AMI do
    begin
      //SDL_BlitSurface(tempscr, nil, screen, nil);
      LoadFreshScreen;
      DrawMPic(2020, CENTER_X - 193, CENTER_Y - 182, 0, 0, 100 - i * 4, 0, 0);
      for j := 0 to 3 do
      begin
        x1 := LinearInsert(i, 0, 25, CENTER_X, pos[j].x);
        y1 := LinearInsert(i, 0, 25, CENTER_Y, pos[j].y);
        DrawMPic(2021, x1 - 65, y1 - 70, 0, 0, 100 - i * 4, 0, 0);
        DrawMPic(2022 + j, x1 - 30, y1 - 25, 0, 0, 100 - i * 4, 0, 0);
      end;
      UpdateAllScreen;
      SDL_PollEvent(@event);
      CheckBasicEvent;
      if PRESENT_SYNC = 0 then
        SDL_Delay(10);
    end;
  end;

  {for i := 0 to 11 do
  begin
    ShowSimpleStatus(762 + i, i mod 3 * 200, i div 3 * 80);
  end;
  WaitAnyKey;}

  NeedRefreshScence := 1;
  FreeFreshScreen;
end;


procedure DrawTitleMenu(menu: integer = -1);
var
  i: integer;
  temp1, temp2: PSDL_Surface;
  dest: TSDL_Rect;
begin
  if where <= 1 then
    for i := 0 to 3 do
    begin

      //temp1 := CopyIndexSurface(MPngindex, 2022 + i);
      //temp2 := zoomSurface(temp1, 0.75, 0.75, SMOOTH);
      dest.x := TitleMenu[i].x;
      dest.y := TitleMenu[i].y;
      //SDL_BlitSurface(temp2, nil, screen, @dest);
      //SDL_FreeSurface(temp1);
      //SDL_FreeSurface(temp2);
      if (i = menu) then
        DrawMPic(2022 + i, TitleMenu[i].x, TitleMenu[i].y, 0, 0, 0, 0, 0, 0.75, 0.75)
      else
        DrawMPic(2022 + i, TitleMenu[i].x, TitleMenu[i].y, 0, 0, 0, 0, 50, 0.75, 0.75);
      //DrawMPic(2022 + i, center_x+50+80*j,center_y-240+5, 0, 0, 0, 0);
    end;
end;

function CheckTitleMenu: integer;
var
  i: integer;
begin
  Result := MenuEscType;
  if (event.type_ = SDL_MOUSEBUTTONUP) and (event.button.button = SDL_BUTTON_LEFT) and MouseInRegion(TitleMenu[0].x,
    TitleMenu[0].y, TitleMenu[3].x + TitleMenu[3].w - TitleMenu[0].x, TitleMenu[3].y + TitleMenu[3].h - TitleMenu[0].y) then
  begin
    for i := 0 to 3 do
    begin
      if MouseInRegion(TitleMenu[i].x, TitleMenu[i].y, TitleMenu[i].w, TitleMenu[i].h) then
      begin
        Result := i;
        break;
      end;
    end;
  end;
  if (event.type_ = SDL_KEYUP) and (event.key.keysym.sym >= SDLK_1) and (event.key.keysym.sym <= SDLK_4) then
  begin
    Result := event.key.keysym.sym - SDLK_1;
  end;

end;


//医疗选单, 需两次选择队员

procedure MenuMedcine;
var
  role1, role2, menu: integer;
  str: WideString;
begin
  str := ('隊員醫療能力');
  DrawTextWithRect(@str[1], 80, 30, 132, ColColor($23), ColColor($21));
  menu := SelectOneTeamMember(80, 65, '%4d', 46, 0);
  UpdateAllScreen;
  if menu >= 0 then
  begin
    role1 := TeamList[menu];
    str := ('隊員目前生命');
    DrawTextWithRect(@str[1], 80, 30, 132, ColColor($23), ColColor($21));
    menu := SelectOneTeamMember(80, 65, '%4d/%4d', 17, 18);
    role2 := TeamList[menu];
    if menu >= 0 then
      EffectMedcine(role1, role2);
  end;
  //waitanykey;
  Redraw;
  //SDL_UpdateRect2(screen,0,0,screen.w,screen.h);

end;

//解毒选单

procedure MenuMedPoison;
var
  role1, role2, menu: integer;
  str: WideString;
begin
  str := ('隊員解毒能力');
  DrawTextWithRect(@str[1], 80, 30, 132, ColColor($23), ColColor($21));
  menu := SelectOneTeamMember(80, 65, '%4d', 48, 0);
  UpdateAllScreen;
  if menu >= 0 then
  begin
    role1 := TeamList[menu];
    str := ('隊員中毒程度');
    DrawTextWithRect(@str[1], 80, 30, 132, ColColor($23), ColColor($21));
    menu := SelectOneTeamMember(80, 65, '%4d', 20, 0);
    role2 := TeamList[menu];
    if menu >= 0 then
      EffectMedPoison(role1, role2);
  end;
  //waitanykey;
  Redraw;
  //showmenu(1);
  //SDL_UpdateRect2(screen,0,0,screen.w,screen.h);

end;

//物品选单, 返回值仅在战斗时有用

function MenuItem: boolean;
var
  listLT, x, y, px, py, col, row, xp, yp, plistLT, pmenu, iamount, menu, xm, ym, i, maxteam: integer;
  //point似乎未使用, listLT为处于左上角的物品在列表中的序号, x, y为光标位置
  //col, row为总列数和行数
  regionx1, regiony1, regionx2, regiony2, d, level: integer;
  titlex1, titley1, titlew, titlemax, intitle, pintitle, dragitem, dragitemx, dragitemy, dragteammate, DragSuccess: integer;
  menuString: array of WideString;
  //tempsur, tempsur2: PSDL_Surface;
  dest: TSDL_Rect;
  canuse, precanuse: byte;
  color1, color2: uint32;
  str: WideString;
  words: array[0..10] of WideString;
  words2: array[0..22] of WideString;
  words3: array[0..12] of WideString;
  curitem0: integer;
  refresh: boolean;
  //显示物品选单, intitle表示有灰度
  ItemTypeList: array[0..8] of integer = (0, 1, 3, 4, 21, 22, 23, 30, 31);

  procedure ShowMenuItem(lostfocus: integer);
  var
    item, i, i1, i2, len, len2, len3, listnum, Alpha, dt, l, l1, w, amount: integer;
    str: WideString;
    p2: array[0..22] of integer;
    p3: array[0..12] of integer;
    color1, color2: uint32;
  begin

    dt := d * row;
    l := 4;  //介绍的列数
    l1 := l - 1;
    w := 90; //介绍每列宽度

    //DrawMPic(2006, xp - 13, yp - 33);
    DrawTextFrame(xp - 8, yp, 40, 10);
    //DrawRectangle(xp, yp, d * col + 7, 26, 0, ColColor(255), 30);
    //DrawRectangle(xp, 30 + yp, d * col + 7, d * row + 10, 0, ColColor(255), 30);
    DrawMPic(2006, xp - 3, 27 + yp, 0, 0, 30);
    DrawTextFrame(xp - 8, 45 + dt + yp, 40, 10, 0, 20);
    //DrawRectangle(xp, 45 + dt + yp, d * col + 7, 26, 0, ColColor(255), 30);
    //i:=0;
    for i1 := 0 to row - 1 do
      for i2 := 0 to col - 1 do
      begin
        listnum := ItemList[i1 * col + i2 + listLT];
        if (listnum >= 0) and (listnum < MAX_ITEM_AMOUNT) then
        begin
          item := RItemlist[listnum].Number;
          if (item >= 0) then
          begin
            DrawIPic(item, i2 * d + 5 + xp, i1 * d + 35 + yp, 0, 10, 0, 10);
          end;
        end;
      end;

    listnum := itemlist[y * col + x + listLT];
    if (listnum >= 0) and (listnum < MAX_ITEM_AMOUNT) and (lostfocus = 0) then
    begin
      item := RItemlist[listnum].Number;
      DrawIPic(item, x * d + 5 + xp + 1, y * d + 35 + yp + 1, 0, 0, 0, 0);
      //drawtextframe(x * d + 5 + xp, y * d + 35 + yp + 82, 8);
      //str := UTF8Decode(format('%5d', [RItemlist[listnum].Amount]));
      //DrawShadowText(@str[1], x * d + 5 + xp + 19, y * d + 35 + yp + 85, ColColor($64), ColColor($66));
      //len := DrawLength(pchar(@Ritem[item].Name));
      //DrawU16ShadowText(@Ritem[item].Name, x * d + 5 + xp + 19+140, y * d + 35 + yp + 85, ColColor($64), ColColor($66));
    end
    else
      item := -1;

    curitem := item;
    if (RItemlist[listnum].Amount > 0) and (listnum < MAX_ITEM_AMOUNT) and (listnum >= 0) and (item >= 0) then
    begin
      amount := RItemlist[listnum].Amount;
      str := format('%10d', [amount]);
      DrawShadowText(@str[1], 280 + xp, 3 + yp, ColColor($64), ColColor($66));
      len := DrawLength(PChar(@Ritem[item].Name));
      DrawU16ShadowText(@Ritem[item].Name, 215 - len * 5 + xp, 3 + yp, 0, $202020);
      //drawshadowtext(@words[Ritem[item].ItemType, 1], 252, 115 + row * 50, colcolor($21), colcolor($23));

      //如是罗盘则显示坐标
      if item = COMPASS_ID then
      begin
        str := '你的位置：';
        DrawShadowText(@str[1], 8 + xp, 48 + dt + yp, 0, $202020);
        str := format('%3d,%3d', [My, Mx]);
        DrawShadowText(@str[1], 108 + xp, 48 + dt + yp, ColColor($64), ColColor($66));

        str := '船的位置：';
        DrawShadowText(@str[1], 188 + xp, 48 + dt + yp, 0, $202020);
        str := format('%3d,%3d', [Shipx, shipy]);
        DrawShadowText(@str[1], 288 + xp, 48 + dt + yp, ColColor($64), ColColor($66));
      end
      else
      begin
        len := length(pWideChar(@Ritem[item].Introduction));
        DrawU16ShadowText(@Ritem[item].Introduction, 8 + xp, 47 + dt + yp, 0, $202020);
        //如有人使用则显示
        if Ritem[item].User >= 0 then
        begin
          str := '使用';
          DrawShadowText(@str[1], 18 + length(PChar(@Rrole[Ritem[item].User].Name)) * 10 + len * 20 +
            xp, 47 + dt + yp, ColColor($64), ColColor($66));
          DrawU16ShadowText(@Rrole[Ritem[item].User].Name, 18 + len * 20 + xp, 48 + dt + yp,
            ColColor($64), ColColor($66));
        end;
      end;
    end;

    if (item >= 0) and (Ritem[item].ItemType > 0) then
    begin
      len2 := 0;
      for i := 0 to 22 do
      begin
        p2[i] := 0;
        if (Ritem[item].Data[45 + i] <> 0) and (i <> 4) then
        begin
          p2[i] := 1;
          len2 := len2 + 1;
        end;
      end;
      if Ritem[item].ChangeMPType = 2 then
      begin
        p2[4] := 1;
        len2 := len2 + 1;
      end;

      len3 := 0;
      for i := 0 to 12 do
      begin
        p3[i] := 0;
        if (Ritem[item].Data[69 + i] <> 0) and (i <> 0) then
        begin
          p3[i] := 1;
          len3 := len3 + 1;
        end;
      end;
      if (Ritem[item].NeedMPType in [0, 1]) and (Ritem[item].ItemType <> 3) then
      begin
        p3[0] := 1;
        len3 := len3 + 1;
      end;

      //xp := xp + x * d + 5;
      //yp := yp + y * d + 34 - dt;
      if len2 + len3 > 0 then
      begin
        for i := 0 to (len2 + l1) div l + (len3 + l1) div l - 1 do
          DrawTextFrame(xp - 8, 75 + dt + yp + i * 28, 40, 20, 0, 50);
        //DrawRectangle(xp, 75 + dt + yp, d * col + 7, 20 * ((len2 + l1) div l + (len3 + l1) div l) + 7,
        //0, ColColor(255), 30);
      end;
      //yp:=yp+5;
      //setfontsize(16, 15);
      if len2 > 0 then
      begin
        str := '功效：';
        DrawShadowText(@str[1], 8 + xp, 78 + dt + yp, ColColor($21), ColColor($23));
      end;
      if len3 > 0 then
      begin
        str := '需求：';
        DrawShadowText(@str[1], 8 + xp, 78 + dt + (len2 + l1) div l * 28 + yp, ColColor($21), ColColor($23));
      end;

      i1 := 0;
      for i := 0 to 22 do
      begin
        if (p2[i] = 1) then
        begin
          str := format('%d', [Ritem[item].Data[45 + i]]);
          //if (i = 21) and (Ritem[item].ItemType = 2) then
          //str := format('0.%d', [Ritem[item].Data[45 + i]]);
          //if (i = 1) or (i = 6) then
          //str := format('^%d', [ritem[item].Data[45 + i]]);
          if i = 4 then
            case Ritem[item].ChangeMPType of
              0: str := '陰';
              1: str := '陽';
              2: str := '調和';
            end;
          if (i = 0) or (i = 5) then
          begin
            color1 := ColColor($10);
            color2 := ColColor($13);
          end
          else
          begin
            color1 := ColColor($64);
            color2 := ColColor($66);
          end;
          DrawShadowText(@words2[i][1], 68 + i1 mod l * w + xp, i1 div l * 28 + 78 + dt + yp,
            ColColor(5), ColColor(7));
          DrawShadowText(@str[1], 108 + i1 mod l * w + xp, i1 div l * 28 + 78 + dt + yp,
            color1, color2);
          i1 := i1 + 1;
        end;
      end;

      i1 := 0;
      for i := 0 to 12 do
      begin
        if (p3[i] = 1) then
        begin
          str := format('%d', [Ritem[item].Data[69 + i]]);
          if i = 0 then
            case Ritem[item].NeedMPType of
              0: str := '陰';
              1: str := '陽';
              2: str := '調和';
            end;
          if (i = 1) then
          begin
            color1 := ColColor($10);
            color2 := ColColor($13);
          end
          else
          begin
            color1 := ColColor($64);
            color2 := ColColor($66);
          end;
          DrawShadowText(@words3[i][1], 68 + i1 mod 4 * w + xp, ((len2 + l1) div l + i1 div l) * 28 +
            78 + dt + yp, ColColor($50), ColColor($4E));
          DrawShadowText(@str[1], 108 + i1 mod 4 * w + xp, ((len2 + l1) div l + i1 div l) * 28 + 78 + dt + yp, color1, color2);
          i1 := i1 + 1;
        end;
      end;
      //setfontsize(20, 19);
    end;

    if (lostfocus = 0) {and (item = -1)} then
      DrawItemFrame(x, y);
    //showblackscreen := bscreen;

  end;

begin
  col := 5;
  row := 3;
  x := 0;
  y := 0;
  listLT := 0;

  d := 83;  //图片的尺寸

  //标题区的位置, 标题每项的宽度
  titlex1 := CENTER_X - 384 + 300;
  titley1 := CENTER_Y - 240 + 35;
  titlew := 45;
  titlemax := 8;
  xp := CENTER_X - 384 + 300;
  yp := CENTER_Y - 240 + 65;  //菜单的总体初始位置

  //物品选区的区域
  regionx1 := xp + 5;
  regionx2 := regionx1 + d * col;
  regiony1 := yp + 35;
  regiony2 := regiony1 + d * row;

  words[0] := '劇情物品';
  words[1] := '神兵寶甲';
  words[2] := '武功秘笈';
  words[3] := '靈丹妙藥';
  words[4] := '傷人暗器';
  words2[0] := '生命';
  words2[1] := '生命';
  words2[2] := '中毒';
  words2[3] := '體力';
  words2[4] := '內力';
  words2[5] := '內力';
  words2[6] := '內力';
  words2[7] := '攻擊';
  words2[8] := '輕功';
  words2[9] := '防禦';
  words2[10] := '醫療';
  words2[11] := '用毒';
  words2[12] := '解毒';
  words2[13] := '抗毒';
  words2[14] := '拳掌';
  words2[15] := '御劍';
  words2[16] := '耍刀';
  words2[17] := '特殊';
  words2[18] := '暗器';
  words2[19] := '作弊';
  words2[20] := '品德';
  words2[21] := '移動';
  words2[22] := '帶毒';

  words3[0] := '內力';
  words3[1] := '內力';
  words3[2] := '攻擊';
  words3[3] := '輕功';
  words3[4] := '用毒';
  words3[5] := '醫療';
  words3[6] := '解毒';
  words3[7] := '拳掌';
  words3[8] := '御劍';
  words3[9] := '耍刀';
  words3[10] := '特殊';
  words3[11] := '暗器';
  words3[12] := '資質';

  setlength(menuString, titlemax + 1);
  //menustring[0] := ('全部物品');
  menuString[0] := ('劇情');
  menuString[1] := ('兵甲');
  menuString[2] := ('丹藥');
  menuString[3] := ('暗器');
  menuString[4] := ('拳經');
  menuString[5] := ('劍譜');
  menuString[6] := ('刀錄');
  menuString[7] := ('奇門');
  menuString[8] := ('心法');


  xm := CENTER_X - 384 + 300;
  ym := CENTER_Y - 240 + 5;

  LoadTeamSimpleStatus(maxteam);
  canuse := 0;
  curitem := -1;
  Redraw;
  //DrawMPic(2006, CENTER_X - 384 + 283, CENTER_Y - 240);
  //DrawTitleMenu;
  TransBlackScreen;
  DrawTitleMenu(2);
  RecordFreshScreen;
  //tempsur := SDL_DisplayFormat(screen);

  if where = 2 then
    menu := 2
  else
    menu := MenuItemType;
  iamount := ReadItemList(ItemTypeList[MenuItemType]);
  px := -1;
  py := -1;
  x := 0;
  y := 0;
  Result := False;
  intitle := 1;
  pintitle := -1;
  dragitem := -1;
  curitem0 := -1;
  event.key.keysym.sym := 0;
  event.button.button := 0;
  refresh := True;
  while (SDL_PollEvent(@event) >= 0) do
  begin
    if refresh then
    begin
      //writeln(x, y, listLT, menu, Result, dragitem);
      //writeln(px, py, plistLT, pmenu);
      if menu <> pmenu then
        listLT := 0;
      iamount := ReadItemList(ItemTypeList[menu]);
      LoadFreshScreen;
      //SDL_BlitSurface(tempsur, nil, screen, nil);
      CleanTextScreen;
      if dragitem >= 0 then
      begin
        ShowMenuItem(1);
        curitem := dragitem;
      end
      else
        ShowMenuItem(intitle);
      if where <> 2 then
      begin
        for i := 0 to maxteam do
        begin
          if CanEquip(teamlist[i], curitem) then
          begin
            DrawSimpleStatusByTeam(i, CENTER_X - 384 + 10, CENTER_Y - 240 + i * 80, 0, 0);
          end
          else
          begin
            DrawSimpleStatusByTeam(i, CENTER_X - 384, CENTER_Y - 240 + i * 80, 0, 50);
          end;
          if (curitem >= 0) and (teamlist[i] = Ritem[curitem].User) then
          begin
            //setfontsize(12, 19);
            str := '使用中';
            DrawTextWithRect(@str[1], CENTER_X - 384 + 15, CENTER_Y - 240 + 80 * i + 50, 0,
              ColColor($64), ColColor($66), 50, 0);
            //DrawMPic(2020, CENTER_X - 384 + 15, CENTER_Y - 240 + 80 * i + 50, 0, 0, 30);
          end;
          {if (menu = 2) and (Rrole[teamlist[i]].PracticeBook >= 0) then
          begin
            str := pwidechar(@Ritem[Rrole[teamlist[i]].PracticeBook].Name);
            DrawShadowText(@str[1], CENTER_X - 384 + 15, CENTER_Y - 240 + 80 * i + 60, ColColor($64), ColColor($66));
          end;}
          if (Ritem[curitem].Magic > 0) then
          begin
            level := GetMagicLevel(teamlist[i], Ritem[curitem].Magic);
            if level > 0 then
            begin
              str := UTF8Decode(format('%2d級', [level]));
              DrawShadowText(@str[1], CENTER_X - 384 + 220, CENTER_Y - 240 + 80 * i + 60,
                ColColor($64), ColColor($66));
            end;
          end;
        end;
      end;
      DrawTextFrame(titlex1 - 8, titley1 - 3, 40);
      //DrawRectangle(titlex1, titley1 - 1, d * col + 7, 25, 0, ColColor(255), 40);
      str := '·';
      for i := 0 to titlemax do
      begin
        color1 := 0;
        color2 := $202020;
        if intitle = 0 then
        begin
          color1 := ColColor($7A);
          color2 := ColColor($7C);
        end;
        if i = menu then
        begin
          color1 := ColColor($64);
          color2 := ColColor($66);
        end;
        DrawShadowText(@menuString[i, 1], titlex1 + titlew * i + 12, titley1, color1, color2);
        //if i < titlemax then
        // DrawShadowText(@str[1], titlex1 + titlew * i + 50, titley1, ColColor($7a), ColColor($7c));
      end;
      if dragitem >= 0 then
      begin
        SDL_GetMouseState2(dragitemx, dragitemy);
        DrawIPic(dragitem, dragitemx - d div 2, dragitemy - d div 2, 0, 0, 0, 0);
      end;
      UpdateAllScreen;
      px := x;
      py := y;
      plistLT := listLT;
      pmenu := menu;
      pintitle := intitle;
      Result := False;
    end;
    CheckBasicEvent;
    case event.type_ of
      SDL_KEYDOWN:
      begin
        if intitle = 0 then
        begin
          if (event.key.keysym.sym = SDLK_DOWN) then
          begin
            y := y + 1;
            if y < 0 then
              y := 0;
            if (y >= row) then
            begin
              if (ItemList[listLT + col * row] >= 0) then
                listLT := listLT + col;
              y := row - 1;
            end;
          end;
          if (event.key.keysym.sym = SDLK_UP) then
          begin
            y := y - 1;
            if y < 0 then
            begin
              y := 0;
              if listLT > 0 then
                listLT := listLT - col;
            end;
          end;
          if (event.key.keysym.sym = SDLK_PAGEDOWN) then
          begin
            //y := y + row;
            if (iamount > col * row) then
            begin
              listLT := listLT + col * row;
              if y < 0 then
                y := 0;
              if (ItemList[listLT + col * row] < 0) then
              begin
                y := y - (iamount - listLT) div col - 1 + row;
                listLT := (iamount div col - row + 1) * col;
                if y >= row then
                  y := row - 1;
              end;
            end
            else
              y := iamount div col;
          end;
          if (event.key.keysym.sym = SDLK_PAGEUP) then
          begin
            //y := y - row;
            listLT := listLT - col * row;
            if listLT < 0 then
            begin
              y := y + listLT div col;
              listLT := 0;
              if y < 0 then
                y := 0;
            end;
          end;
        end;
        if (event.key.keysym.sym = SDLK_RIGHT) then
        begin
          if intitle = 0 then
          begin
            x := x + 1;
            if x >= col then
              x := 0;
          end
          else
          begin
            menu := menu + 1;
            if menu > titlemax then
              menu := 0;
          end;
        end;
        if (event.key.keysym.sym = SDLK_LEFT) then
        begin
          if intitle = 0 then
          begin
            x := x - 1;
            if x < 0 then
              x := col - 1;
          end
          else
          begin
            menu := menu - 1;
            if menu < 0 then
              menu := titlemax;
          end;
        end;
        //cleankeyvalue;
      end;
      SDL_KEYUP:
      begin
        if (event.key.keysym.sym = SDLK_ESCAPE) then
        begin
          //ReDraw;
          //ShowMenu(2);
          if intitle = 0 then
            intitle := 1
          else
          begin
            MenuEscType := -1;
            Result := False;

            //updateallscreen;
            break;
          end;
        end;
        if (event.key.keysym.sym = SDLK_RETURN) or (event.key.keysym.sym = SDLK_SPACE) or
          ((event.key.keysym.sym = SDLK_DOWN) and (intitle = 1)) then
        begin
          //ReDraw;
          if intitle = 0 then
          begin
            CurItem := RItemlist[itemlist[(y * col + x + listLT)]].Number;
            if (where <> 2) and (CurItem >= 0) and (itemlist[(y * col + x + listLT)] >= 0) then
            begin
              UseItem(CurItem);
              //剧情类物品有可能改变队伍
              if Ritem[CurItem].ItemType = 0 then
                LoadTeamSimpleStatus(maxteam);
            end;
            //ShowMenu(2);
            Result := True;
          end
          else
            intitle := 0;
        end;
      end;
      SDL_MOUSEBUTTONDOWN:
      begin
        if event.button.button = SDL_BUTTON_LEFT then
        begin
          if MouseInRegion(regionx1, regiony1, regionx2 - regionx1, regiony2 - regiony1, xm, ym) then
          begin
            intitle := 0;
            x := (xm - regionx1) div d;
            y := (ym - regiony1) div d;
            if x >= col then
              x := col - 1;
            if y >= row then
              y := row - 1;
            if x < 0 then
              x := 0;
            if y < 0 then
              y := 0;
            if itemlist[(y * col + x + listLT)] >= 0 then
            begin
              CurItem := RItemlist[itemlist[(y * col + x + listLT)]].Number;
              dragitem := curItem;
              ConsoleLog('%d', [curItem]);
            end;
          end;
        end;
      end;
      SDL_MOUSEBUTTONUP:
      begin
        if (event.button.button = SDL_BUTTON_RIGHT) then
        begin
          //ReDraw;
          //ShowMenu(2);
          MenuEscType := -1;
          Result := False;
          //updateallscreen;
          break;
        end;
        if (event.button.button = SDL_BUTTON_LEFT) then
        begin
          if dragitem >= 0 then
          begin
            if MouseInRegion(CENTER_X - 384, CENTER_Y - 240, 250, 480, xm, ym) then
            begin
              dragteammate := (ym - (CENTER_Y - 240)) div 80;
              if (dragteammate > 5) then
                dragteammate := -1;
              //writeln(dragteammate);
              if (where <> 2) and (TeamList[dragteammate] >= 0) then
              begin
                //if (Ritem[dragitem].ItemType >=1)and (Ritem[dragitem].ItemType <=3) then
                UseItem(dragitem, dragteammate);
                //剧情类物品有可能改变队伍
                if Ritem[CurItem].ItemType = 0 then
                  LoadTeamSimpleStatus(maxteam);
                //DragSuccess := 1;
                dragitem := -1;
                Result := True;
              end;
            end;
          end;
          if dragitem >= 0 then
          begin
            //message('%d %d',[curitem0,curitem]);
            if CellPhone = 0 then
            begin
              UseItem(CurItem, -1);
              //剧情类物品有可能改变队伍
              if Ritem[CurItem].ItemType = 0 then
                LoadTeamSimpleStatus(maxteam);
              Result := True;
            end;
            //curitem0 := curitem;
            refresh := True;
            dragitem := -1;
            ConsoleLog('%d %d', [dragitem, curitem]);
          end;
        end;
      end;
      SDL_MOUSEWHEEL:
      begin
        if (event.wheel.y < 0) then
        begin
          y := y + 1;
          if y < 0 then
            y := 0;
          if (y >= row) then
          begin
            if (ItemList[listLT + col * row] >= 0) then
              listLT := listLT + col;
            y := row - 1;
          end;
        end;
        if (event.wheel.y > 0) then
        begin
          y := y - 1;
          if y < 0 then
          begin
            y := 0;
            if listLT > 0 then
              listLT := listLT - col;
          end;
        end;
        if (event.wheel.x < 0) then
        begin
          x := x + 1;
          if x >= col then
            x := 0;
        end;
        if (event.wheel.x > 0) then
        begin
          x := x - 1;
          if x < 0 then
            x := col - 1;
        end;
      end;
      SDL_MOUSEMOTION:
      begin
        if dragitem = -1 then
        begin
          if MouseInRegion(titlex1, titley1, (titlemax + 1) * titlew, 20, xm, ym) then
          begin
            intitle := 1;
            menu := (xm - titlex1 - 10) div titlew;
          end;
          if MouseInRegion(regionx1, regiony1, regionx2 - regionx1, regiony2 - regiony1, xm, ym) then
          begin
            intitle := 0;
            x := (xm - regionx1) div d;
            y := (ym - regiony1) div d;
            if x >= col then
              x := col - 1;
            if y >= row then
              y := row - 1;
            if x < 0 then
              x := 0;
            if y < 0 then
              y := 0;
          end;
          if MouseInRegion(regionx1, regiony2, regionx2 - regionx1, 30) then
          begin
            //listLT := listLT+col;
            if (ItemList[listLT + col * row] >= 0) then
              listLT := listLT + col;
          end;
          if MouseInRegion(regionx1, regiony1 - 30, regionx2 - regionx1, 30) then
          begin
            if listLT > 0 then
              listLT := listLT - col;
          end;
        end;
      end;
    end;
    if where < 2 then
    begin
      MenuEscType := CheckTitleMenu;
      if MenuEscType <> 2 then
        break;
    end;
    refresh := refresh or (x <> px) or (y <> py) or (listLT <> plistLT) or (menu <> pmenu) or (intitle <> pintitle) or
      Result or (dragitem >= 0);
    event.key.keysym.sym := 0;
    event.button.button := 0;
    SDL_Delay(20);
    if (where = 2) and (Result) and (menu = 2) then
      break;
    if (MODVersion <> 13) and (where = 2) and (Result) and (menu = 3) then
      break;
    if where > 2 then
      break;
  end;
  MenuItemType := menu;
  FreeFreshScreen;
  //SDL_FreeSurface(tempsur);
  //SDL_UpdateRect2(screen,0,0,screen.w,screen.h);

end;

//读物品列表, 主要是战斗中需屏蔽一部分物品
//利用一个不可能用到的数值（-1）, 表示读取所有物品
//一般来说, 参数为物品自身的类型 0-剧情, 1-装备, 2-秘籍, 3-药品, 4-暗器
//因为秘籍太多, 以下进行一些扩展
//20-无武功秘籍, 21-拳法, 22-剑法, 23-刀法, 24-特殊, 25-暗器, 26-吸取内力, 27-特技, 28-内功
//此处为游戏需要, 有扩展即30=24+25+27, 31=20+26+28

function ReadItemList(ItemType: integer): integer;
var
  i, p, subType, mnum: integer;
begin
  p := 0;
  {for i := 0 to length(ItemList) - 1 do
    ItemList[i] := -1;}
  FillChar(ItemList[0], sizeof(ItemList), -1);
  for i := 0 to MAX_ITEM_AMOUNT - 1 do
  begin
    if (RItemlist[i].Number >= 0) then
    begin
      subType := Ritem[RItemlist[i].Number].ItemType;
      //当ItemType>=20时, 认为要选择某一类秘籍
      if (subType = 2) and (ItemType >= 20) then
      begin
        mnum := Ritem[RItemlist[i].Number].Magic;
        if mnum <= 0 then
          subType := 20
        else
          case Rmagic[mnum].HurtType of
            1: subType := 26;
            2: subType := 27;
            3: subType := 28;
            else
              subType := 20 + Rmagic[mnum].MagicType;
          end;
        //扩展部分, 合并部分分类
        if (subType = 2) or (subType = 24) or (subType = 25) or (subType = 27) then
          subType := 30;
        if (subType = 20) or (subType = 26) or (subType = 28) then
          subType := 31;
      end;

      if (subType = ItemType) or (ItemType = -1) then
      begin
        Itemlist[p] := i;
        p := p + 1;
      end;
      //此处认为钱属于暗器
      if (MODVersion = 13) and (RItemlist[i].Number = MONEY_ID) and (ItemType = 4) then
      begin
        Itemlist[p] := i;
        p := p + 1;
      end;
    end;
  end;
  Result := p;
end;


//使用物品, 只限队伍

procedure UseItem(inum: integer; teammate: integer = -1);
var
  x, y, menu, rnum, p, i, mask, potentialUser, preUser, off: integer;
  str, str1: WideString;
  menuString: array of WideString;
begin
  if where = 2 then
    exit;
  CurItem := inum;
  {//following is for test.
  ritem[inum].AddAttack :=1;
  ritem[inum].AddSpeed :=1;
  ritem[inum].AddDefence :=1;
  ritem[inum].AddFist :=1;
  ritem[inum].AddCurrentHP :=1;
  ritem[inum].AddAttPoi :=1;
  ritem[inum].AddMove :=1;
  ritem[inum].AddHidWeapon :=1;
  ritem[inum].AddRepute :=1;
  ritem[inum].AddSword :=1;
  ritem[inum].AddPoi :=1;
  ritem[inum].AddUnusual :=1;
  ritem[inum].AddUsePoi :=1;
  ritem[inum].AddMedPoi :=1;}
  if (teammate >= 0) and (teammate <= 5) then
    potentialUser := Teamlist[teammate]
  else
    potentialUser := -1;
  case Ritem[inum].ItemType of
    0: //剧情物品
    begin
      //如某属性大于0, 直接调用事件
      if Ritem[inum].UnKnow7 > 0 then
        CallEvent(Ritem[inum].UnKnow7)
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
            if DData[CurScence, CurEvent, 3] >= 0 then
            begin
              Cx := Sx;
              Cy := Sy;
              Sstep := 0;
              CurScenceRolePic := BEGIN_WALKPIC2 + SFace * 7 + SStep;
              CallEvent(DData[CurScence, CurEvent, 3]);
            end;
          end;
          CurEvent := -1;
        end;
      end;
    end;
    1: //装备
    begin
      menu := 1;
      //有使用者时, 如有预订者则需预订者不为使用者, 且预订者能装备才提问
      //有使用者, 无预订者必定会提问
      if (Ritem[inum].User >= 0) and ((potentialUser < 0) or ((Ritem[inum].User <> potentialUser) and CanEquip(potentialUser, inum))) then
      begin
        TransBlackScreen;
        UpdateAllScreen;
        setlength(menuString, 2);
        menuString[0] := '取消';
        menuString[1] := '繼續';
        str := '此物品正有人裝備，是否繼續？';
        DrawTextWithRect(@str[1], CENTER_X - 142, CENTER_Y - 40, 285, 0, $202020);
        menu := CommonMenu2(CENTER_X - 45, CENTER_Y, 45, menuString);
      end;
      if menu = 1 then
      begin
        if teammate = -1 then
        begin
          TransBlackScreen;
          UpdateAllScreen;
          str := '誰要裝備';
          str1 := pWideChar(@Ritem[inum].Name);
          off := DrawTextFrame(CENTER_X - 275, CENTER_Y - 193, 8 + DrawLength(str1));
          //DrawTextWithRect(@str[1], CENTER_X - 275, CENTER_Y - 193, length(str1) * 22 + 80, 0, $202020);
          DrawShadowText(@str[1], CENTER_X - 275 + off, CENTER_Y - 193 + 3,{160, 32,} 0, $202020);
          DrawShadowText(@str1[1], CENTER_X - 275 + 80 + off, CENTER_Y - 193 + 3,{160, 32,} ColColor($64),
            ColColor($66));
          UpdateAllScreen;
          mask := 0;
          for i := 0 to 5 do
          begin
            if (teamlist[i] >= 0) then
              if CanEquip(teamlist[i], inum) then
                mask := mask or (1 shl i);
          end;
          menu := SelectOneTeamMember(80, 65, '', 0, 0, mask);
        end
        else
          menu := teammate;
        if menu >= 0 then
        begin
          rnum := Teamlist[menu];
          p := Ritem[inum].EquipType;
          if (p < 0) or (p > 1) then
            p := 0;
          if CanEquip(rnum, inum) then
          begin
            if Ritem[inum].User >= 0 then
              Rrole[Ritem[inum].User].Equip[p] := -1;
            if Rrole[rnum].Equip[p] >= 0 then
              Ritem[Rrole[rnum].Equip[p]].User := -1;
            Rrole[rnum].Equip[p] := inum;
            Ritem[inum].User := rnum;
          end
          else
          begin
            str := '此人不適合裝備此物品';
            DrawTextWithRect(@str[1], CENTER_X - 100, CENTER_Y + 40, 205, ColColor($64), ColColor($66));
            WaitAnyKey;
            Redraw;
            //SDL_UpdateRect2(screen,0,0,screen.w,screen.h);
          end;
        end;
      end;
    end;
    2: //秘笈
    begin
      menu := 1;
      if (Ritem[inum].User >= 0) and ((potentialUser < 0) or ((Ritem[inum].User <> potentialUser) and CanEquip(potentialUser, inum))) then
      begin
        TransBlackScreen;
        UpdateAllScreen;
        setlength(menuString, 2);
        menuString[0] := '取消';
        menuString[1] := '繼續';
        str := '此秘笈正有人修煉，是否繼續？';
        DrawTextWithRect(@str[1], CENTER_X - 142, CENTER_Y - 40, 285, 0, $202020);
        menu := CommonMenu2(CENTER_X - 45, CENTER_Y, 45, menuString);
      end;
      if menu = 1 then
      begin
        if teammate = -1 then
        begin
          TransBlackScreen;
          UpdateAllScreen;
          str := '誰要修煉';
          str1 := pWideChar(@Ritem[inum].Name);
          //DrawTextWithRect(@str[1], CENTER_X - 275, CENTER_Y - 193, length(str1) * 22 + 80, 0, $202020);
          off := DrawTextFrame(CENTER_X - 275, CENTER_Y - 193, 8 + DrawLength(str1));
          //DrawTextWithRect(@str[1], CENTER_X - 275, CENTER_Y - 193, length(str1) * 22 + 80, 0, $202020);
          DrawShadowText(@str[1], CENTER_X - 275 + off, CENTER_Y - 193 + 3,{160, 32,} 0, $202020);
          DrawShadowText(@str1[1], CENTER_X - 275 + 80 + off, CENTER_Y - 193 + 3,{160, 32,} ColColor($64),
            ColColor($66));
          UpdateAllScreen;
          mask := 0;
          for i := 0 to 5 do
          begin
            if (teamlist[i] >= 0) then
              if CanEquip(teamlist[i], inum) then
                mask := mask or (1 shl i);
          end;
          menu := SelectOneTeamMember(80, 65, '', 0, 0, mask);
        end
        else
          menu := teammate;
        if menu >= 0 then
        begin
          rnum := TeamList[menu];
          if CanEquip(rnum, inum, 1) then
          begin
            preUser := Ritem[inum].User;
            if Ritem[inum].User >= 0 then
              Rrole[Ritem[inum].User].PracticeBook := -1;
            if Rrole[rnum].PracticeBook >= 0 then
              Ritem[Rrole[rnum].PracticeBook].User := -1;
            Rrole[rnum].PracticeBook := inum;
            Ritem[inum].User := rnum;
            //自己换给自己不清经验
            if preUser <> rnum then
            begin
              Rrole[rnum].ExpForItem := 0;
              Rrole[rnum].ExpForBook := 0;
            end;
            //if (inum in [78, 93]) then
            //  rrole[rnum].Sexual := 2;
          end
          else
          begin
            str := '此人不適合修煉此秘笈';
            DrawTextWithRect(@str[1], CENTER_X - 100, CENTER_Y + 40, 205, ColColor($64), ColColor($66));
            WaitAnyKey;
            Redraw;
            //SDL_UpdateRect2(screen,0,0,screen.w,screen.h);
          end;
        end;
      end;
    end;
    3: //药品
    begin
      TransBlackScreen;
      UpdateAllScreen;
      if where <> 2 then
      begin
        if teammate = -1 then
        begin
          str := '誰要服用';
          str1 := pWideChar(@Ritem[inum].Name);
          DrawTextWithRect(@str[1], CENTER_X - 275, CENTER_Y - 193, DrawLength(str1) * 10 + 80,
            0, $202020);
          DrawShadowText(@str1[1], CENTER_X - 275 + 99, CENTER_Y - 193 + 2,{160, 32,} ColColor($64), ColColor($66));
          UpdateAllScreen;
          menu := SelectOneTeamMember(80, 65, '', 0, 0);
        end
        else
          menu := teammate;
        rnum := TeamList[menu];
      end;
      if menu >= 0 then
      begin
        //redraw;
        TransBlackScreen;
        EatOneItem(rnum, inum);
        instruct_32(inum, -1);
        ShowSimpleStatus(TeamList[menu], 0, 0, menu);
        WaitAnyKey;
      end;
    end;
    4: //不处理暗器类物品
    begin
      //if where<>3 then break;
    end;
  end;

end;

//能否装备

function CanEquip(rnum, inum: integer; use: integer = 0): boolean;
var
  i, r, mnum: integer;
  menuString: array[0..1] of WideString;
  str: WideString;
begin
  //判断是否符合
  //注意这里对'所需属性'为负值时均添加原版类似资质的处理
  if (inum < 0) or (rnum < 0) then
  begin
    Result := False;
    exit;
  end;
  case Ritem[inum].ItemType of
    0, 4: Result := False;
    3: Result := True;
    1, 2:
    begin
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
      if (Rrole[rnum].MPType < 2) and (Ritem[inum].NeedMPType < 2) then
        if Rrole[rnum].MPType <> Ritem[inum].NeedMPType then
          Result := False;

      //如有专用人物, 前面的都作废
      if (Ritem[inum].OnlyPracRole >= 0) and (Result = True) then
        if (Ritem[inum].OnlyPracRole = rnum) then
          Result := True
        else
          Result := False;

      //如果该物品能练出武功, 需补充判断武功栏是否已满
      //如果学过该武功则强制为真, 如武功栏已满则强制为假
      if Ritem[inum].Magic > 0 then
      begin
        mnum := Ritem[inum].Magic;
        if GetMagicLevel(rnum, mnum) > 0 then
          Result := True
        else
        begin
          case Rmagic[mnum].HurtType of
            3: if HaveMagicAmount(rnum, 1) >= 4 then
                Result := False;
            0, 1, 2: if HaveMagicAmount(rnum) >= 10 then
                Result := False;
          end;
        end;
      end;
    end;
  end;

  //如果以上判定为真, 且属于自宫物品, 则提问, 若选否则为假
  if (MODVersion <> 13) and (use = 1) then
    if (inum in [78, 93]) and (Result = True) and (Rrole[rnum].Sexual <> 2) then
    begin
      TransBlackScreen;
      UpdateAllScreen;
      menuString[0] := ('取消');
      menuString[1] := ('繼續');
      str := ('是否要自宮？');
      DrawTextWithRect(@str[1], CENTER_X - 63, CENTER_Y, 0, 0, $202020);
      if CommonMenu2(CENTER_X - 49, CENTER_Y + 40, 48, menuString) = 1 then
        Rrole[rnum].Sexual := 2
      else
        Result := False;
    end;
end;

//查看状态选单

{procedure MenuStatus;
var
  str: WideString;
  menu: integer;
begin
  str := '查看隊員狀態';
  drawtextwithrect(@str[1], 80, 30, 132, colcolor($21), colcolor($23));
  menu := SelectOneTeamMember(80, 65, '%3d', 15, 0);
  if menu >= 0 then
  begin
    ShowStatus(TeamList[menu]);
    waitanykey;
    redraw;
    updateallscreen;
  end;

end;}

//查看状态选单

procedure MenuStatus;
var
  str: WideString;
  menu, amount, i, x, premenu, max, f, xeff, yeff: integer;
  menuString, menuEngString: array of WideString;
  tempsur, tempsur2, tempsur3: PSDL_Surface;
  dest, dest2: TSDL_Rect;
  item1x, item1y, item2x, item2y, d, rnum, inum, equip, preequip, xm, ym: integer;
begin
  setlength(menuString, 3);
  menuString[0] := '更換';
  menuString[1] := '卸下';
  menuString[2] := '取消';
  Redraw;
  DrawMPic(2015, CENTER_X - 384 + 283, CENTER_Y - 240);
  //DrawTitleMenu;
  TransBlackScreen;
  DrawTitleMenu(0);
  RecordFreshScreen;
  //tempsur := SDL_DisplayFormat(screen);

  event.key.keysym.sym := 0;
  event.button.button := 0;

  LoadTeamSimpleStatus(max);

  //menu := 0;
  menu := MenuEscTeammate;
  premenu := -1;
  xeff := 28;
  yeff := 10;
  dest2.x := xeff;

  //这里的值与显示部分一致
  item1x := CENTER_X - 384 + 340;
  item2x := CENTER_X - 384 + 540;
  item1y := CENTER_Y - 240 + 360;
  item2y := item1y;
  d := 83;
  //dest2.w := tempsur3.w;
  //dest2.h := tempsur3.h;
  f := 0;
  equip := 0;
  preequip := -1;
  while SDL_PollEvent(@event) >= 0 do
  begin
    if (menu <> premenu) or (equip <> preequip) then
    begin
      //SDL_BlitSurface(tempsur, nil, screen, nil);
      LoadFreshScreen;
      for i := 0 to max do
      begin
        if i = menu then
        begin
          DrawSimpleStatusByTeam(i, CENTER_X - 384 + 10, CENTER_Y - 240 + i * 80, 0, 0);
        end
        else
        begin
          DrawSimpleStatusByTeam(i, CENTER_X - 384, CENTER_Y - 240 + i * 80, 0, 50);
        end;
      end;
      //DrawMPic(2008, 320, 0);
      ShowStatus(TeamList[menu]);
      //ShowStatus(280);
      case equip of
        0: DrawItemFrame(item1x, item1y, 1);
        1: DrawItemFrame(item2x, item2y, 1);
      end;
      UpdateAllScreen;
      premenu := menu;
      preequip := equip;
    end;
    {dest.y := 80 * menu + yeff;
    dest.x := xeff;
    SDL_BlitSurface(tempsur3, nil, screen, @dest);
    DrawMPic(2100, xeff, menu * 80 + yeff, f);
    SDL_UpdateRect2(screen, xeff, menu * 80 + yeff, tempsur3.w, tempsur3.h);
    //DrawMPic(2100, 18, menu * 80 + 10, f);
    f := f + 1;}
    CheckBasicEvent;
    if ((event.type_ = SDL_KEYDOWN) and (event.key.keysym.sym = SDLK_UP)) or ((event.type_ = SDL_MOUSEWHEEL) and (event.wheel.y > 0)) then
    begin
      menu := menu - 1;
      if menu < 0 then
        menu := max;
    end;
    if ((event.type_ = SDL_KEYDOWN) and (event.key.keysym.sym = SDLK_DOWN)) or ((event.type_ = SDL_MOUSEWHEEL) and (event.wheel.y < 0)) then
    begin
      menu := menu + 1;
      if menu > max then
        menu := 0;
    end;
    if (event.type_ = SDL_KEYDOWN) and ((event.key.keysym.sym = SDLK_LEFT) or (event.key.keysym.sym = SDLK_RIGHT)) then
    begin
      equip := 1 - equip;
    end;
    if ((event.type_ = SDL_KEYUP) and (event.key.keysym.sym = SDLK_ESCAPE)) or ((event.type_ = SDL_MOUSEBUTTONUP) and
      (event.button.button = SDL_BUTTON_RIGHT)) then
    begin
      MenuEscType := -1;
      break;
    end;
    if (event.type_ = SDL_MOUSEMOTION) then
    begin
      if MouseInRegion(CENTER_X - 384, CENTER_Y - 240, 250, 480, xm, ym) then
      begin
        menu := min(max, (ym - (CENTER_Y - 240)) div 80);
      end;
      if MouseInRegion(item1x, item1y, d, d) then
      begin
        equip := 0;
      end;
      if MouseInRegion(item2x, item2y, d, d) then
      begin
        equip := 1;
      end;
    end;
    if ((event.type_ = SDL_MOUSEBUTTONUP) and (event.button.button = SDL_BUTTON_LEFT) and MouseInRegion(item1x, item1y, d, d)) or
      ((event.type_ = SDL_KEYUP) and (equip = 0) and ((event.key.keysym.sym = SDLK_RETURN) or (event.key.keysym.sym = SDLK_SPACE))) then
    begin
      case CommonMenu2(item1x - 40, item1y + d, 47, menuString, 2) of
        1:
        begin
          rnum := TeamList[menu];
          inum := Rrole[rnum].Equip[0];
          if inum >= 0 then
          begin
            if Ritem[inum].User >= 0 then
              Rrole[rnum].Equip[0] := -1;
            if inum >= 0 then
              Ritem[inum].User := -1;
          end;
        end;
        0:
        begin
          //在这里转到物品选项, 当从物品选项退出时回到状态项
          //当从物品选项以切换方式退出时则不回到原位置, 其余类似
          MenuItemType := 1;
          MenuEscType := 2;
          MenuItem;
          if MenuEscType = -1 then
            MenuEscType := 0;
        end;
      end;
      premenu := -1;
    end;
    if ((event.type_ = SDL_MOUSEBUTTONUP) and (event.button.button = SDL_BUTTON_LEFT) and MouseInRegion(item2x, item2y, d, d)) or
      ((event.type_ = SDL_KEYUP) and (equip = 1) and ((event.key.keysym.sym = SDLK_RETURN) or (event.key.keysym.sym = SDLK_SPACE))) then
    begin
      case CommonMenu2(item2x - 40, item2y + d, 45, menuString, 2) of
        1:
        begin
          rnum := TeamList[menu];
          inum := Rrole[rnum].Equip[1];
          if inum >= 0 then
          begin
            if Ritem[inum].User >= 0 then
              Rrole[rnum].Equip[1] := -1;
            if inum >= 0 then
              Ritem[inum].User := -1;
          end;
        end;
        0:
        begin
          MenuItemType := 1;
          MenuEscType := 2;
          MenuItem;
          if MenuEscType = -1 then
            MenuEscType := 0;
        end;
      end;
      premenu := -1;
    end;
    MenuEscType := CheckTitleMenu;
    if MenuEscType <> 0 then
      break;
    SDL_Delay(20);
    event.key.keysym.sym := 0;
    event.button.button := 0;
  end;
  //waitanykey;
  MenuEscTeammate := menu;
  //SDL_FreeSurface(tempsur);
  FreeFreshScreen;
end;

//显示状态

procedure ShowStatusByTeam(tnum: integer);
begin
  if TeamList[tnum] >= 0 then
    ShowStatus(TeamList[tnum]);
end;

//显示状态
//bnum = -1, -2, 排列不同

procedure ShowStatus(rnum: integer; bnum: integer = 0);
var
  i, k, magicnum, mlevel, needexp, x, y, w, h, xp, yp: integer;
  p: array[0..10] of integer;
  addatk, adddef, addspeed: integer;
  str: WideString;
  strs: array[0..24] of WideString;
  //strs1: array of WideString;
  color1, color2: uint32;
  Name: WideString;
  item1x, item1y, item2x, item2y: integer;
  addnum: array[0..3] of integer;
begin
  //where := 2;
  strs[0] := '等級';
  strs[1] := '生命';
  strs[2] := '內力';
  strs[3] := '體力';
  strs[4] := '經驗';
  strs[5] := '升級';
  strs[6] := '攻擊';
  strs[7] := '防禦';
  strs[8] := '輕功';
  strs[9] := '移動';
  strs[10] := '醫療能力';
  strs[11] := '用毒能力';
  strs[12] := '解毒能力';
  strs[13] := '拳掌功夫';
  strs[14] := '御劍能力';
  strs[15] := '耍刀技巧';
  strs[16] := '特殊兵器';
  strs[17] := '暗器技巧';
  strs[18] := '武器';
  strs[19] := '護具';
  strs[20] := '所會武功';
  strs[21] := '受傷';
  strs[22] := '中毒';
  strs[23] := '所會內功';

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

  xp := CENTER_X - 384 + 260;
  yp := CENTER_Y - 240 + 5;
  w := 560;
  h := 26;
  item1x := CENTER_X - 384 + 340;
  item2x := CENTER_X - 384 + 540;
  item1y := CENTER_Y - 240 + 360;
  item2y := item1y;

  if where = 3 then
  begin
    xp := CENTER_X - 384 + 100;
    TransBlackScreen;
  end;

  x := xp;
  y := yp;
  if bnum >= 0 then
  begin
    //显示头像
    DrawHeadPic(Rrole[rnum].HeadNum, xp + 60, yp + 10);
    x := xp + 60;
    y := yp - 15;

    //显示姓名
    Name := pWideChar(@Rrole[rnum].Name);
    DrawTextWithRect(@Name[1], x + 58 - DrawLength(PChar(@Rrole[rnum].Name)) * 5, y + 180, 0,
      ColColor($64), ColColor($66), 0, 0);

    //显示所需字符
    for i := 0 to 5 do
      DrawTextWithRect(@strs[i, 1], x - 10, y + 208 + h * i, 140, 0, $202020, 30, 0);

    //等级
    str := format('%4d', [Rrole[rnum].Level]);
    DrawEngShadowText(@str[1], x + 110, y + 211 + h * 0, ColColor($64), ColColor($66));

    //生命值, 在受伤和中毒值不同时使用不同颜色
    case Rrole[rnum].Hurt of
      34..66:
      begin
        color1 := ColColor($E);
        color2 := ColColor($10);
      end;
      67..1000:
      begin
        color1 := ColColor($14);
        color2 := ColColor($16);
      end;
      else
      begin
        color1 := ColColor($5);
        color2 := ColColor($7);
      end;
    end;
    str := format('%4d', [Rrole[rnum].CurrentHP]);
    DrawEngShadowText(@str[1], x + 60, y + 211 + h * 1, color1, color2);

    str := '/';
    DrawEngShadowText(@str[1], x + 100, y + 211 + h * 1, ColColor($64), ColColor($66));

    case Rrole[rnum].Poison of
      1..66:
      begin
        color1 := ColColor($30);
        color2 := ColColor($32);
      end;
      67..1000:
      begin
        color1 := ColColor($35);
        color2 := ColColor($37);
      end;
      else
      begin
        color1 := ColColor($21);
        color2 := ColColor($23);
      end;
    end;
    str := format('%4d', [Rrole[rnum].MaxHP]);
    DrawEngShadowText(@str[1], x + 110, y + 211 + h * 1, color1, color2);
    //内力, 依据内力性质使用颜色
    if Rrole[rnum].MPType = 0 then
    begin
      color1 := ColColor($4e);
      color2 := ColColor($50);
    end
    else if Rrole[rnum].MPType = 1 then
    begin
      color1 := ColColor($5);
      color2 := ColColor($7);
    end
    else
    begin
      color1 := ColColor($64);
      color2 := ColColor($66);
    end;
    str := format('%4d/%4d', [Rrole[rnum].CurrentMP, Rrole[rnum].MaxMP]);
    DrawEngShadowText(@str[1], x + 60, y + 211 + h * 2, color1, color2);
    //体力
    str := format('%4d/%4d', [Rrole[rnum].PhyPower, MAX_PHYSICAL_POWER]);
    DrawEngShadowText(@str[1], x + 60, y + 211 + h * 3, ColColor($64), ColColor($66));
    //经验
    str := format('%5d', [uint16(Rrole[rnum].Exp)]);
    DrawEngShadowText(@str[1], x + 100, y + 211 + h * 4, ColColor($64), ColColor($66));
    str := format('%5d', [uint16(Leveluplist[Rrole[rnum].Level - 1])]);
    DrawEngShadowText(@str[1], x + 100, y + 211 + h * 5, ColColor($64), ColColor($66));

    //str:=format('%5d', [Rrole[rnum,21]]);
    //drawengshadowtext(@str[1],150,295,colcolor($7),colcolor($5));

    //drawshadowtext(@strs[20, 1], 30, 341, colcolor($21), colcolor($23));
    //drawshadowtext(@strs[21, 1], 30, 362, colcolor($21), colcolor($23));

    //drawrectanglewithoutframe(100,351,Rrole[rnum,19],10,colcolor($16),50);
    //中毒, 受伤
    //str := format('%4d', [RRole[rnum].Hurt]);
    //drawengshadowtext(@str[1], 150, 341, colcolor($14), colcolor($16));
    //str := format('%4d', [RRole[rnum].Poison]);
    //drawengshadowtext(@str[1], 150, 362, colcolor($35), colcolor($37));

    if where <> 2 then
    begin
      x := xp + 85;
      y := yp;
      //装备, 秘笈
      DrawTextWithRect(@strs[18, 1], item1x + 85, item1y, 0, 0, $202020, 0, 0);
      DrawTextWithRect(@strs[19, 1], item2x + 85, item2y, 0, 0, $202020, 0, 0);
      if Rrole[rnum].Equip[0] >= 0 then
      begin
        DrawTextWithRect(@Ritem[Rrole[rnum].Equip[0]].Name, item1x + 85, item1y + 30,
          0, ColColor($64), ColColor($66), 30, 0);
        DrawIPic(Rrole[rnum].Equip[0], item1x, item1y, 0, 0, 0, 0);
      end;
      if Rrole[rnum].Equip[1] >= 0 then
      begin
        DrawTextWithRect(@Ritem[Rrole[rnum].Equip[1]].Name, item2x + 85, item2y + 30, 0,
          ColColor($64), ColColor($66), 30, 0);
        DrawIPic(Rrole[rnum].Equip[1], item2x, item2y, 0, 0, 0, 0);
      end;
    end;

  end;

  x := xp - 20;
  y := yp + 35;
  if bnum < 0 then
  begin
    x := CENTER_X - 390;
    y := CENTER_Y - 240 + 80;
    h := 26;
    if bnum = -2 then
    begin
      x := x + 100;
    end;
  end;
  //drawshadowtext(@strs[20, 1], x + 360, y + 5, colcolor($21), colcolor($23));
  //drawshadowtext(@strs[23, 1], x + 360, y + 260, colcolor($21), colcolor($23));

  if bnum < 0 then
  begin
    if bnum = -1 then
    begin
      //DrawRectangle(x + 270, y, 260, 325, 0, ColColor(255), 50);
      //display_img(PChar(AppPath + 'resource/lu.png'), x + 270 - 10, y - 38);
      for i := 0 to 2 do
      begin
        DrawTextWithRect(@strs[i, 1], x + 180 + 100, y + 2 + h * i, 240, 0, $202020, 40, 0);
      end;
      for i := 0 to 14 do
      begin
        str := '->';
        DrawShadowText(@str[1], x + 300 + 100 + 50, y + 5 + h * i, ColColor($64), ColColor($66));
      end;
    end;
    str := format('%4d', [Rrole[rnum].Level]);
    DrawEngShadowText(@str[1], x + 280 + 100, y + 5 + h * 0, ColColor($64), ColColor($66));
    str := format('%4d', [Rrole[rnum].MaxHP]);
    DrawEngShadowText(@str[1], x + 280 + 100, y + 5 + h * 1, ColColor($64), ColColor($66));
    str := format('%4d', [Rrole[rnum].MaxMP]);
    DrawEngShadowText(@str[1], x + 280 + 100, y + 5 + h * 2, ColColor($64), ColColor($66));
    y := y + 3 * h;
  end;

  for i := 0 to 3 do
    addnum[i] := 0;

  if Rrole[rnum].Equip[0] >= 0 then
  begin
    addnum[0] := addnum[0] + Ritem[Rrole[rnum].Equip[0]].AddAttack;
    addnum[1] := addnum[1] + Ritem[Rrole[rnum].Equip[0]].AddDefence;
    addnum[2] := addnum[2] + Ritem[Rrole[rnum].Equip[0]].AddSpeed;
    addnum[3] := addnum[3] + Ritem[Rrole[rnum].Equip[0]].AddMove * 10;
  end;

  if Rrole[rnum].Equip[1] >= 0 then
  begin
    addnum[0] := addnum[0] + Ritem[Rrole[rnum].Equip[1]].AddAttack;
    addnum[1] := addnum[1] + Ritem[Rrole[rnum].Equip[1]].AddDefence;
    addnum[2] := addnum[2] + Ritem[Rrole[rnum].Equip[1]].AddSpeed;
    addnum[3] := addnum[3] + Ritem[Rrole[rnum].Equip[1]].AddMove * 10;
  end;

  if (where = 2) and (bnum >= 0) then
  begin
    addnum[0] := addnum[0] + Brole[bnum].StateLevel[0] * Rrole[rnum].Attack div 100;
    addnum[1] := addnum[1] + Brole[bnum].StateLevel[1] * Rrole[rnum].Defence div 100;
    addnum[2] := addnum[2] + Brole[bnum].StateLevel[2] * Rrole[rnum].Speed div 100;
    addnum[3] := addnum[3] + Brole[bnum].StateLevel[3] * 10;
    addnum[0] := addnum[0] + Brole[bnum].loverlevel[0] * Rrole[rnum].Attack div 100;
    addnum[1] := addnum[1] + Brole[bnum].loverlevel[1] * Rrole[rnum].Defence div 100;
    addnum[2] := addnum[2] + Brole[bnum].loverlevel[9] * Rrole[rnum].Speed div 100;
    addnum[3] := addnum[3] + Brole[bnum].loverlevel[2] * 10;
  end;

  for i := 6 to 17 do
  begin
    w := 120;
    if i <= 9 then
      if addnum[i - 6] <> 0 then
        w := 190;
    if bnum = -1 then
      w := 240;
    if bnum <> -2 then
    begin
      DrawTextWithRect(@strs[i, 1], x + 180 + 100, y + 2 + h * (i - 6), w, 0, $202020, 40, 0);
    end;
  end;

  //addnum[0] := -Rrole[rnum].Attack;
  color1 := ColColor($64);
  color2 := ColColor($66);
  if bnum >= 0 then
  begin
    for i := 0 to 3 do
    begin
      if addnum[i] <> 0 then
      begin
        if addnum[i] > 0 then
          str := format(' (+%d)', [addnum[i]])
        else
          str := format(' (%d)', [addnum[i]]);
        DrawEngShadowText(@str[1], x + 280 + 140, y + 5 + i * h, color1, color2);
      end;
    end;
  end;
  color1 := ColColor($64);
  color2 := ColColor($66);
  //攻击, 防御, 轻功
  //单独处理是因为显示顺序和存储顺序不同
  str := format('%4d', [Rrole[rnum].Attack + addnum[0]]);
  SetColorByPro(Rrole[rnum].Attack + addnum[0], 600, color1, color2);
  DrawEngShadowText(@str[1], x + 280 + 100, y + 5 + h * 0, color1, color2);
  str := format('%4d', [Rrole[rnum].Defence + addnum[1]]);
  SetColorByPro(Rrole[rnum].Defence + addnum[1], 600, color1, color2);
  DrawEngShadowText(@str[1], x + 280 + 100, y + 5 + h * 1, color1, color2);
  str := format('%4d', [Rrole[rnum].Speed + addnum[2]]);
  SetColorByPro(Rrole[rnum].Speed + addnum[2], 300, color1, color2);
  DrawEngShadowText(@str[1], x + 280 + 100, y + 5 + h * 2, color1, color2);

  //其他属性
  //移动的增加是乘以10
  str := format('%4d', [Rrole[rnum].Movestep + addnum[3]]);
  SetColorByPro(Rrole[rnum].Movestep + addnum[3], 100, color1, color2);
  DrawEngShadowText(@str[1], x + 280 + 100, y + 5 + h * 3, color1, color2);

  str := format('%4d', [Rrole[rnum].Medcine]);
  SetColorByPro(Rrole[rnum].Medcine, 200, color1, color2);
  DrawEngShadowText(@str[1], x + 280 + 100, y + 5 + h * 4, color1, color2);

  str := format('%4d', [Rrole[rnum].UsePoi]);
  SetColorByPro(Rrole[rnum].UsePoi, 100, color1, color2);
  DrawEngShadowText(@str[1], x + 280 + 100, y + 5 + h * 5, color1, color2);

  str := format('%4d', [Rrole[rnum].MedPoi]);
  SetColorByPro(Rrole[rnum].MedPoi, 100, color1, color2);
  DrawEngShadowText(@str[1], x + 280 + 100, y + 5 + h * 6, color1, color2);

  str := format('%4d', [Rrole[rnum].Fist]);
  SetColorByPro(Rrole[rnum].Fist, 300, color1, color2);
  DrawEngShadowText(@str[1], x + 280 + 100, y + 5 + h * 7, color1, color2);

  str := format('%4d', [Rrole[rnum].Sword]);
  SetColorByPro(Rrole[rnum].Sword, 300, color1, color2);
  DrawEngShadowText(@str[1], x + 280 + 100, y + 5 + h * 8, color1, color2);

  str := format('%4d', [Rrole[rnum].Knife]);
  SetColorByPro(Rrole[rnum].Knife, 300, color1, color2);
  DrawEngShadowText(@str[1], x + 280 + 100, y + 5 + h * 9, color1, color2);

  str := format('%4d', [Rrole[rnum].Unusual]);
  SetColorByPro(Rrole[rnum].Unusual, 300, color1, color2);
  DrawEngShadowText(@str[1], x + 280 + 100, y + 5 + h * 10, color1, color2);

  str := format('%4d', [Rrole[rnum].HidWeapon]);
  SetColorByPro(Rrole[rnum].HidWeapon, 300, color1, color2);
  DrawEngShadowText(@str[1], x + 280 + 100, y + 5 + h * 11, color1, color2);

  {//武功
  for i := 0 to 9 do
  begin
    magicnum := Rrole[rnum].magic[i];
    if magicnum > 0 then
    begin
      DrawU16shadowtext(@Rmagic[magicnum].Name, x + 340, y + 26 + 21 * i, colcolor(5), colcolor(7));
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
      DrawU16shadowtext(@Rmagic[magicnum].Name, x + 340, y + 26 + +260 + 21 * i, colcolor(5), colcolor(7));
      str := format('%3d', [Rrole[rnum].NGLevel[i] div 100 + 1]);
      drawengshadowtext(@str[1], x + 480, y + 26 + 260 + 21 * i, colcolor($64), colcolor($66));
    end;
  end;}

  if (Where = 2) and (bnum >= 0) then
  begin
    //情侣加成, loverlevel：
    //0加攻、1加防、2加移、3抗毒、4武功威力、5内功加成、6替代受伤、7回复生命、8回复内力
    //特技导致状态, Statelevel：
    //0攻击,1防御,2轻功,3移动,4伤害,5回血,6回内
    //7战神,8风雷,9孤注,10倾国,11毒箭,12剑芒,13连击
    //14乾坤,15灵精,16奇门,17博采,18聆音,19青翼,20回体
    //21,22,23,24,25,26定身,27控制
    k := 0;
    for i := 0 to High(Brole[bnum].StateLevel) do
    begin
      if (Brole[bnum].StateLevel[i] <> 0) and (statestrs[i] <> '') then
      begin
        if Brole[bnum].StateLevel[i] > 0 then
        begin
          color1 := ColColor($14);
          color2 := ColColor($16);
        end
        else
        begin
          color1 := ColColor($50);
          color2 := ColColor($4e);
        end;
        DrawShadowText(@statestrs[i, 1], xp + 70 + 50 * (k mod 8), yp + 360 + h * (k div 8), color1, color2);
        if IsConsole then
        begin
          str := IntToStr(Brole[bnum].StateRound[i]);
          DrawEngShadowText(@str[1], xp + 110 + 50 * (k mod 8), yp + 360 + h * (k div 8), color1, color2);
        end;
        k := k + 1;
      end;
    end;
  end;
  //SDL_UpdateRect2(screen, x, y, 561, 456);

end;

//显示简单状态(x, y表示位置)

procedure ShowSimpleStatus(rnum, x, y: integer; forTeam: integer = -1);
var
  i, magicnum, w: integer;
  p: array[0..10] of integer;
  str: WideString;
  strs: array[0..3] of WideString;
  strs1: array[1..17] of WideString;
  color1, color2, color: uint32;
  tex: PSDL_Texture;
  sur: PSDL_Surface;
  dest, dest2, rectcut: TSDL_Rect;
  tran: byte;
  bigtran, Mask, mixColor: uint32;
  engsize, x1, y1, w1, h1, alpha, mixAlpha: integer;
begin
  if rnum < 0 then
    exit;
  x1 := 0;
  y1 := 0;
  w1 := 270;
  h1 := 90;
  GetRealRect(x1, y1, w1, h1);
  //ss := SDL_CreateRGBSurface(screen.flags, 270, 90, 32, RMask, GMask, BMask, AMask);
  //st := SDL_CreateRGBSurface(screen.flags, x1 + w1, y1 + h1, 32, RMask, GMask, BMask, AMask);
  //SDL_SetAlpha(st, 0, 255);
  if forTeam = -1 then
  begin
    if SW_SURFACE = 0 then
    begin
      SDL_SetRenderTarget(render, SimpleStateTex);
      SDL_SetRenderDrawBlendMode(render, SDL_BLENDMODE_NONE);
      SDL_SetRenderDrawColor(render, 0, 0, 0, 0);
      SDL_RenderClear(render);
      //tex := SimpleStateTex;
    end
    else
    begin
      CurTargetSurface := SimpleState;
      SDL_FillRect(SimpleState, nil, 0);
      //sur := SimpleState;
    end;
  end
  else
  begin
    forTeam := RegionParameter(forTeam, 0, 5);
    //sur := SimpleStatus[forTeam];
  end;

  dest2.x := x;
  dest2.y := y;
  dest2.w := 270;
  dest2.h := 90;

  x := 0;
  y := 0;


  SetFontSize(17, 12);
  //engsize := 5;

  DrawMPic(2002, x, y);

  mixColor := MapRGBA(255 - Rrole[rnum].Poison * 2, 255, 255 - Rrole[rnum].Poison * 2);
  //mixColor := SDL_MapRGB(screen.format, 50, 200, 50);
  mixAlpha := -1;
  DrawHeadPic(Rrole[rnum].HeadNum, x + 10, y, 0, 0, mixColor, mixAlpha, 0.5, 0.5);

  //if Text_Layer = 1 then
  alpha := 80;
  //else
  //alpha := 50;

  //文字不分层时使用黑色画空白部分, 使文字略为明显
  if Rrole[rnum].MaxHP = 0 then
    w := 138
  else
    w := 138 * Rrole[rnum].CurrentHP div Rrole[rnum].MaxHP;
  color := MapRGBA(196, max(0, 25 - Rrole[rnum].Hurt div 5), 16);
  DrawRectangleWithoutFrame(x + 96, y + 32, w, 9, color, -1);
  //DrawRectangleWithoutFrame(x + 96 + w, y + 32, 138 - w, 9, color, alpha);
  if Rrole[rnum].MaxMP = 0 then
    w := 138
  else
    w := 138 * Rrole[rnum].CurrentMP div Rrole[rnum].MaxMP;
  case Rrole[rnum].MPType of
    0: color := MapRGBA(112, 12, 112);
    1: color := MapRGBA(224, 180, 32);
    else
      color := MapRGBA(160, 160, 160);
  end;
  DrawRectangleWithoutFrame(x + 96, y + 48, w, 9, color, -1);
  DrawRectangleWithoutFrame(x + 96 + w, y + 48, 138 - w, 9, color, alpha);

  w := 83 * Rrole[rnum].PhyPower div MAX_PHYSICAL_POWER;
  color := MapRGBA(128, 128, 255);

  DrawRectangleWithoutFrame(x + 115, y + 65, w, 9, color, -1);
  DrawRectangleWithoutFrame(x + 115 + w, y + 65, 83 - w, 9, color, alpha);

  tex := nil;
  sur := nil;
  if (TEXT_LAYER = 1) then
  begin
    x := dest2.x;
    y := dest2.y;
    if ForTeam = -1 then
    begin
      tex := TextScreenTex;
      sur := TextScreen;
    end
    else
    begin
      tex := SimpleTextTex[Forteam];
      sur := SimpleText[Forteam];
    end;
  end;

  {strs[0] := '等級';
  strs[1] := '生命';
  strs[2] := '內力';
  strs[3] := '體力';
  //for i := 0 to 3 do
  //drawshadowtext(@strs[i, 1], x + 220, y + 60 + 21 * i, colcolor($21), colcolor($23)); }
  //str := pWideChar(@Rrole[rnum].Name);
  str := PCharToUnicode(@Rrole[rnum].Name, 5);
  DrawShadowText(@str[1], x + 115, y + 8, ColColor($64), ColColor($66), tex, sur);
  str := format('%d', [Rrole[rnum].Level]);
  DrawEngShadowText(@str[1], x + 102 - length(str) * 3, y + 6, ColColor(5), ColColor(7), tex, sur);
  case Rrole[rnum].Hurt of
    34..66:
    begin
      color1 := ColColor($10);
      color2 := ColColor($E);
    end;
    67..1000:
    begin
      color1 := ColColor($14);
      color2 := ColColor($16);
    end;
    else
    begin
      color1 := ColColor($5);
      color2 := ColColor($7);
    end;
  end;

  str := format('%4d', [Rrole[rnum].CurrentHP]);
  DrawEngShadowText(@str[1], x + 138, y + 28, color1, color2, tex, sur);

  str := '/';
  DrawEngShadowText(@str[1], x + 165, y + 28, ColColor($64), ColColor($66), tex, sur);

  case Rrole[rnum].Poison of
    1..66:
    begin
      color1 := ColColor($30);
      color2 := ColColor($32);
    end;
    67..1000:
    begin
      color1 := ColColor($35);
      color2 := ColColor($37);
    end;
    else
    begin
      color1 := ColColor($21);
      color2 := ColColor($23);
    end;
  end;
  str := format('%4d', [Rrole[rnum].MaxHP]);
  DrawEngShadowText(@str[1], x + 173, y + 28, color1, color2, tex, sur);

  //str:=format('%4d/%4d', [Rrole[rnum,17],Rrole[rnum,18]]);
  //drawengshadowtext(@str[1],x+50,y+107,colcolor($7),colcolor($5));
  if Rrole[rnum].MPType = 0 then
  begin
    color1 := ColColor($4e);
    color2 := ColColor($50);
  end
  else
  if Rrole[rnum].MPType = 1 then
  begin
    color1 := ColColor($1c);
    color2 := ColColor($1d);
  end
  else
  begin
    color1 := ColColor($64);
    color2 := ColColor($66);
  end;

  str := format('%4d', [Rrole[rnum].CurrentMP]);
  DrawEngShadowText(@str[1], x + 138, y + 44, color1, color2, tex, sur);

  str := '/';
  DrawEngShadowText(@str[1], x + 165, y + 44, color1, color2, tex, sur);

  str := format('%4d', [Rrole[rnum].MaxMP]);
  DrawEngShadowText(@str[1], x + 173, y + 44, color1, color2, tex, sur);


  str := format('%3d', [Rrole[rnum].PhyPower]);
  DrawEngShadowText(@str[1], x + 148, y + 61, ColColor(5), ColColor(7), tex, sur);
  {if Rrole[rnum].State in [1..17] then
  begin
    strs1[1] := '激昂';
    strs1[2] := '成城';
    strs1[3] := '倾国';
    strs1[4] := '战神';
    strs1[5] := '拼搏';
    strs1[6] := '慈悲';
    strs1[7] := '茫然';
    strs1[8] := '媚惑';
    strs1[9] := '爱怜';
    strs1[10] := '精怪';
    strs1[11] := '奇门';
    strs1[12] := '乾坤';
    strs1[13] := '柔情';
    strs1[14] := '破罩';
    strs1[15] := '左右';
    strs1[16] := '鸳鸯';
    strs1[17] := '神行';
    drawtextwithrect(@strs1[Rrole[rnum].State, 1], x + 5, y + 5, 47, colcolor($64), colcolor($66));
  end;}

  ReSetFontSize;

  if ForTeam = -1 then
  begin
    if SW_SURFACE = 0 then
    begin
      SDL_SetRenderTarget(render, screenTex);
      SDL_RenderCopy(render, SimpleStateTex, nil, @dest2);
    end
    else
    begin
      CurTargetSurface := screen;
      SDL_BlitSurface(SimpleState, nil, screen, @dest2);
    end;
    {if Text_Layer = 1 then
    begin
      dest2 := GetRealRect(dest2);
      x1 := 0;
      y1 := 0;
      w1 := 270;
      h1 := 90;
      rectcut := GetRealRect(x1, y1, w1, h1);
      dest2.x := dest2.x;
      dest2.y := dest2.y;
      //sdl_setrendertarget(render, TextScreenTex);
      //sdl_rendercopy(render, sim);
      //SDL_BlitSurface(st, @rectcut, TextScreen, @dest2);
    end;}
    //UpdateAllScreen;
  end;

end;


procedure SetColorByPro(Cur, MaxValue: integer; var color1, color2: uint32);
var
  v: real;
  r1, g1, b1, r2, g2, b2: byte;
  r, g, b: array[0..3] of byte;
  vp: array[0..3] of real;
  i: integer;
begin
  r[0] := 250;
  r[1] := 50;
  r[2] := 250;
  r[3] := 250;
  g[0] := 250;
  g[1] := 250;
  g[2] := 250;
  g[3] := 50;
  b[0] := 250;
  b[1] := 50;
  b[2] := 50;
  b[3] := 50;
  vp[0] := 0;
  vp[1] := 0.5;
  vp[2] := 0.75;
  vp[3] := 1;
  v := cur / MaxValue;
  if v > 1 then
    v := 1;
  if v < 0 then
    v := 0;
  i := 0;
  while v >= vp[i + 1] do
    i := i + 1;
  if i > 2 then
    i := 2;
  r1 := LinearInsert(v, vp[i], vp[i + 1], r[i], r[i + 1]);
  g1 := LinearInsert(v, vp[i], vp[i + 1], g[i], g[i + 1]);
  b1 := LinearInsert(v, vp[i], vp[i + 1], b[i], b[i + 1]);
  r2 := trunc(r1 * 0.8);
  g2 := trunc(g1 * 0.8);
  b2 := trunc(b1 * 0.8);
  color1 := MapRGBA(r1, g1, b1);
  color2 := MapRGBA(r2, g2, b2);
end;

//技能选单

procedure MenuAbility;
var
  str: WideString;
  menu, amount, i, j, x, y, premenu, max, select, preselect, menu2, itemx, itemy, d, rnum, inum, mouseactive: integer;
  menuString: array [0..5] of WideString;
  menustring2: array [0..2] of WideString;
  tempsur, tempsur2: PSDL_Surface;
  dest: TSDL_Rect;
  drag, xm, ym: integer;
  maxselect: integer;
begin
  //setlength(menustring, 2);
  menustring2[0] := '更換';
  menustring2[1] := '卸下';
  menustring2[2] := '取消';
  x := CENTER_X - 384 + 270;
  y := CENTER_Y - 240 + 5;

  Redraw;
  DrawMPic(2008, CENTER_X - 384 + 283, CENTER_Y - 240);
  //DrawTitleMenu;
  TransBlackScreen;
  DrawTitleMenu(1);
  RecordFreshScreen;
  //tempsur := SDL_DisplayFormat(screen);

  event.key.keysym.sym := 0;
  event.button.button := 0;


  itemx := x + 230;
  itemy := y + 380;
  d := 83;
  LoadTeamSimpleStatus(max);
  //menu := 0;
  menu := MenuEscTeammate;
  premenu := -1;
  select := 0;
  preselect := -1;
  drag := -1;
  case MODVersion of
    0: maxselect := 3;
    else
      maxselect := 2;
  end;
  while SDL_PollEvent(@event) >= 0 do
  begin
    if (menu <> premenu) or (select <> preselect) then
    begin
      LoadFreshScreen;
      //SDL_BlitSurface(tempsur, nil, screen, nil);
      CleanTextScreen;
      for i := 0 to max do
      begin
        if i = menu then
        begin
          DrawSimpleStatusByTeam(i, CENTER_X - 384 + 10, CENTER_Y - 240 + i * 80, 0, 0);
        end
        else
        begin
          DrawSimpleStatusByTeam(i, CENTER_X - 384, CENTER_Y - 240 + i * 80, 0, 50);
        end;
      end;
      //队伍中第一个人才显示离队
      ShowAbility(TeamList[menu], select, byte((menu = 0) and (MODVersion <> 13)));
      //ShowAbility(882, select);
      //updateallscreen;
      UpdateAllScreen;
      premenu := menu;
      preselect := select;
    end;
    CheckBasicEvent;
    if ((event.type_ = SDL_KEYDOWN) and (event.key.keysym.sym = SDLK_UP)) or ((event.type_ = SDL_MOUSEWHEEL) and (event.wheel.y > 0)) then
    begin
      menu := menu - 1;
      if menu < 0 then
        menu := max;
    end;
    if ((event.type_ = SDL_KEYDOWN) and (event.key.keysym.sym = SDLK_DOWN)) or ((event.type_ = SDL_MOUSEWHEEL) and (event.wheel.y < 0)) then
    begin
      menu := menu + 1;
      if menu > max then
        menu := 0;
    end;
    if ((event.type_ = SDL_KEYDOWN) and (event.key.keysym.sym = SDLK_LEFT)) then
    begin
      select := select - 1;
      if select < 0 then
        select := maxselect;
    end;
    if ((event.type_ = SDL_KEYDOWN) and (event.key.keysym.sym = SDLK_RIGHT)) then
    begin
      select := select + 1;
      if select > maxselect then
        select := 0;
    end;
    if ((event.type_ = SDL_KEYUP) and (event.key.keysym.sym = SDLK_ESCAPE)) or ((event.type_ = SDL_MOUSEBUTTONUP) and
      (event.button.button = SDL_BUTTON_RIGHT)) then
    begin
      MenuEscType := -1;
      break;
    end;
    if ((event.type_ = SDL_KEYUP) and ((event.key.keysym.sym = SDLK_RETURN) or (event.key.keysym.sym = SDLK_SPACE))) or
      ((event.type_ = SDL_MOUSEBUTTONUP) and (event.button.button = SDL_BUTTON_LEFT) and (mouseactive = 1)) then
    begin
      if select >= 0 then
      begin
        if ((select = 0) and (Rrole[TeamList[menu]].Medcine > 0)) or ((select = 1) and (Rrole[TeamList[menu]].MedPoi > 0)) then
        begin
          TransBlackScreen;
          menu2 := SelectOneTeamMember(x + 50, y + 80 + select * 150, UTF8Decode('選擇目標隊友'), 0, 0);
          if menu2 >= 0 then
          begin
            case select of
              0: EffectMedcine(TeamList[menu], TeamList[menu2]);
              1: EffectMedPoison(TeamList[menu], TeamList[menu2]);
            end;
            ShowSimpleStatus(TeamList[menu2], 0, 0, menu2);
            ShowSimpleStatus(TeamList[menu], 0, 0, menu);
          end;
        end;
        if select = 2 then
        begin
          case CommonMenu(itemx + d + 10, itemy, 47, 2, 2, menustring2) of
            0:
            begin
              MenuItemType := 4;
              MenuEscType := 2;
              MenuItem;
              if MenuEscType = -1 then
                MenuEscType := 1;
            end;
            1:
            begin
              if Rrole[TeamList[menu]].PracticeBook >= 0 then
              begin
                rnum := TeamList[menu];
                inum := Rrole[rnum].PracticeBook;
                Rrole[rnum].PracticeBook := -1;
                Ritem[inum].User := -1;
              end;
            end;
          end;
          preselect := -1;
        end;
        if (select = 3) and (menu = 0) and (where = 0) then
        begin
          MenuLeave;
          LoadTeamSimpleStatus(max);
        end;
      end;
      preselect := -1;
    end;
    if (event.type_ = SDL_MOUSEMOTION) then
    begin
      if MouseInRegion(CENTER_X - 384, CENTER_Y - 240, 250, CENTER_Y * 2, xm, ym) then
        menu := (ym - (CENTER_Y - 240)) div 80;
      if menu > max then
        menu := max;
      mouseactive := 0;
      if MouseInRegion(x + 50, y + 50, 100, 30) then
      begin
        select := 0;
        mouseactive := 1;
      end;
      if MouseInRegion(x + 200, y + 50, 100, 30) then
      begin
        select := 1;
        mouseactive := 1;
      end;
      if MouseInRegion(itemx, itemy, d, d) then
      begin
        select := 2;
        mouseactive := 1;
      end;
      if MouseInRegion(x + 350, y + 50, 100, 30) then
      begin
        select := 3;
        mouseactive := 1;
      end;
    end;
    MenuEscType := CheckTitleMenu;
    if MenuEscType <> 1 then
      break;
    SDL_Delay(20);
    event.key.keysym.sym := 0;
    event.button.button := 0;
  end;
  MenuEscTeammate := menu;
  FreeFreshScreen;
end;

procedure ShowAbility(rnum, select: integer; showLeave: integer = 0);
var
  i, magicnum, mlevel, needexp, x, y, w, itemx, itemy, x1, y1: integer;
  str: WideString;
  strs: array[0..23] of WideString;
  strs1: array[0..2] of WideString;
  color1, color2: uint32;
begin
  strs[0] := '普通';
  strs[1] := '武學';
  strs[2] := '內功';
  strs[3] := '修煉物品';

  strs1[0] := '醫療';
  strs1[1] := '解毒';
  strs1[2] := '離隊';

  x := CENTER_X - 384 + 250;
  y := CENTER_Y - 240 + 5;
  w := 560;
  itemx := x + 230;
  itemy := y + 380;

  DrawTextWithRect(@strs[0, 1], x + 70, y + 20, 10, 0, $202020, 0, 0);

  if Rrole[rnum].Medcine > 0 then
  begin
    color1 := 0;
    color2 := $202020;
    if select = 0 then
    begin
      color1 := ColColor($64);
      color2 := ColColor($66);
    end;
    //str := format('%4d', [Rrole[rnum].Medcine]);
    //DrawEngShadowText(@str[1], x + 100, y + 50, ColColor($64), ColColor($66));
    //DrawMPic(2009, x + 160, y + 56);
  end
  else
  begin
    color1 := ColColor($68);
    color2 := ColColor($6F);
    //DrawMPic(2012, x + 160, y + 56);
  end;
  str := strs1[0] + format('%4d', [Rrole[rnum].Medcine]);
  DrawTextWithRect(@str[1], x + 70, y + 50, 0, color1, color2, 20, 0);

  if Rrole[rnum].MedPoi > 0 then
  begin
    color1 := 0;
    color2 := $202020;
    if select = 1 then
    begin
      color1 := ColColor($64);
      color2 := ColColor($66);
    end;
    //str := format('%4d', [Rrole[rnum].MedPoi]);
    //DrawEngShadowText(@str[1], x + 250, y + 50, ColColor($64), ColColor($66));
    //DrawMPic(2010, x + 310, y + 56);
  end
  else
  begin
    color1 := ColColor($68);
    color2 := ColColor($6F);
    //DrawMPic(2012, x + 310, y + 56);
  end;
  str := strs1[1] + format('%4d', [Rrole[rnum].MedPoi]);
  DrawTextWithRect(@str[1], x + 220, y + 50, 0, color1, color2, 20, 0);
  //DrawShadowText(@strs1[1, 1], x + 220, y + 50, color1, color2);

  if (showLeave <> 0) then
  begin
    color1 := 0;
    color2 := $202020;
    if (select = 3) and (where = 0) then
    begin
      color1 := ColColor($64);
      color2 := ColColor($66);
    end;
    if where <> 0 then
    begin
      color1 := ColColor($68);
      color2 := ColColor($6F);
    end;
    //str:=strs1[0]+format('%4d', [Rrole[rnum].MedPoi]);
    DrawTextWithRect(@strs1[2, 1], x + 370, y + 50, 0, color1, color2, 20, 0);
    //DrawShadowText(@strs1[2, 1], x + 370, y + 50, color1, color2);
  end;

  //武功
  DrawTextWithRect(@strs[1, 1], x + 70, y + 90, 0, 0, $202020, 0, 0);
  color1 := 0;
  color2 := $202020;
  for i := 0 to 9 do
  begin
    magicnum := Rrole[rnum].magic[i];
    x1 := x + 70 + i mod 2 * 180;
    y1 := y + 120 + 28 * (i div 2);
    DrawTextFrame(x1, y1, 12, 20);
    if magicnum > 0 then
    begin
      {case Rmagic[magicnum].HurtType of
        2:
        begin
          color1 := ColColor($64);
          color2 := ColColor($66);
        end;
        3:
        begin
          color1 := SDL_MapRGB(screen.format, 0, $e4, $e1);
          color2 := SDL_MapRGB(screen.format, 0, $e4, $e1);
        end;
        else
        begin
          case Rmagic[magicnum].MagicType of
            1:
            begin
              color1 := ColColor(5);
              color2 := ColColor(7);
            end;
            2:
            begin
              color1 := SDL_MapRGB(screen.format, 200, 200, 0);
              color2 := SDL_MapRGB(screen.format, 180, 180, 0);
            end;
            3:
            begin
              color1 := ColColor($E);
              color2 := ColColor($10);
            end;
            4:
            begin
              color1 := ColColor($50);
              color2 := ColColor($4E);
            end;
            5:
            begin
              color1 := ColColor($30);
              color2 := ColColor($32);
            end;
            else
            begin
              color1 := ColColor(5);
              color2 := ColColor(7);
            end;
          end;
        end;
      end;}
      DrawShadowText((@Rmagic[magicnum].Name), x1 + 19, y1 + 3, 0, $202020);
      str := format('%2d', [Rrole[rnum].MagLevel[i] div 100 + 1]);
      DrawEngShadowText(@str[1], x1 + 119, y1 + 3, 0, $202020);
    end;
  end;

  //内功
  DrawTextWithRect(@strs[2, 1], x + 70, y + 270, 10, 0, $202020, 0, 0);
  color1 := 0;
  color2 := $202020;
  for i := 0 to 3 do
  begin
    magicnum := Rrole[rnum].neigong[i];
    x1 := x + 70 + i mod 2 * 180;
    y1 := y + 300 + 28 * (i div 2);
    DrawTextFrame(x1, y1, 12, 20);
    if magicnum > 0 then
    begin
      //str := format('%-10s', [pWideChar(@Rmagic[magicnum].Name)]);
      DrawShadowText((@Rmagic[magicnum].Name), x1 + 19, y1 + 3, 0, $202020);
      str := format('%2d', [Rrole[rnum].NGLevel[i] div 100 + 1]);
      DrawEngShadowText(@str[1], x1 + 119, y1 + 3, 0, $202020);
      //DrawEngShadowText(@str[1], x + 210+i mod 2 * 120, y + 256 + 21 * (i div 2), ColColor($64), ColColor($66));
    end;
  end;

  DrawTextWithRect(@strs[3, 1], x + 70, y + 370, 0, 0, $202020, 0, 0);

  //计算秘笈需要经验
  if Rrole[rnum].PracticeBook >= 0 then
  begin
    mlevel := 1;
    magicnum := Ritem[Rrole[rnum].PracticeBook].Magic;
    mlevel := max(1, GetMagicLevel(rnum, magicnum));
    needexp := min(30000, trunc((1 + (mlevel - 1) * 0.5) * Ritem[Rrole[rnum].PracticeBook].NeedExp * (1 + (7 - Rrole[rnum].Aptitude / 15) * 0.5)));

    DrawTextWithRect(@Ritem[Rrole[rnum].PracticeBook].Name, x + 70, y + 400, 0, 0, $202020, 20, 0);
    str := format('%d/%d', [uint16(Rrole[rnum].ExpForBook), needexp]);
    if mlevel = 10 then
      str := format('%d/=', [uint16(Rrole[rnum].ExpForBook)]);
    DrawTextWithRect(@str[1], x + 70, y + 428, 0, ColColor($64), ColColor($66), 20, 0);
    DrawIPic(Rrole[rnum].PracticeBook, itemx, itemy, 0, 0, 0, 0);
    //DrawMPic(2011, x + 170, y + 370);
  end
  else
  begin
    DrawTextFrame(x + 70, y + 400, 1, 20, 0);
    //DrawMPic(2013, x + 170, y + 370);
  end;
  if select = 2 then
    DrawItemFrame(itemx, itemy, 1);
end;

//离队选单

procedure MenuLeave;
var
  str: WideString;
  i, menu: integer;
begin
  //str := '要求誰離隊？';
  //DrawTextWithRect(@str[1], 80, 30, 132, ColColor($21), ColColor($23));
  //menu := SelectOneTeamMember(80, 65, '%3d', 15, 0);
  TransBlackScreen;
  menu := SelectOneTeamMember(CENTER_X - 384 + 270 + 50, CENTER_Y - 240 + 7 + 80, UTF8Decode('要求誰離隊'), 0, 0);
  if menu >= 0 then
  begin
    for i := 0 to 99 do
      if leavelist[i] = TeamList[menu] then
      begin
        CallEvent(BEGIN_LEAVE_EVENT + i * 2);
        //SDL_EnableKeyRepeat(0, 10);
        break;
      end;
  end;
  Redraw;
  //SDL_EnableKeyRepeat(20, 100);
end;

//系统选单

procedure MenuSystem;
var
  pmenu, iamount, menu, max, xm, ym, i, maxteam, l: integer;
  titlex1, titley1, titlew, intitle: integer;
  menuString: array of WideString;
  tempsur, tempsur2: PSDL_Surface;
  dest: TSDL_Rect;
  color1, color2: uint32;
  str: WideString;
begin

  //标题区的位置, 标题每项的宽度
  titlex1 := CENTER_X - 384 + 400;
  titley1 := CENTER_Y - 240 + 60;
  titlew := 60;
  max := 4;
  LoadTeamSimpleStatus(maxteam);

  Redraw;
  //DrawTitleMenu;
  TransBlackScreen;
  DrawTitleMenu(3);
  RecordFreshScreen;
  //tempsur := SDL_DisplayFormat(screen);

  setlength(menuString, max + 1);
  menuString[0] := ('讀檔');
  menuString[1] := ('存檔');
  menuString[2] := ('設置');
  menuString[3] := ('製作');
  menuString[4] := ('離開');

  xm := 300;
  ym := 5;

  menu := 0;
  pmenu := -1;
  event.key.keysym.sym := 0;
  event.button.button := 0;
  intitle := 1; //该值表示是否在标题栏处, 用于判断是否按下

  while (SDL_PollEvent(@event) >= 0) do
  begin
    if (menu <> pmenu) then
    begin
      LoadFreshScreen;
      //SDL_BlitSurface(tempsur, nil, screen, nil);
      if (TEXT_LAYER = 1) then
        SDL_FillRect(TextScreen, nil, 0);
      if where <> 2 then
      begin
        for i := 0 to maxteam do
        begin
          DrawSimpleStatusByTeam(i, CENTER_X - 384, CENTER_Y - 240 + i * 80, 0, 0);
        end;
      end;
      //DrawMPic(2007, titlex1 - 45, titley1 - 15);
      DrawTextFrame(titlex1 - 20, titley1 - 3, 32, 0);
      //DrawRectangle(screen, titlex1, titley1 - 1, 55 * 8 - 115, 25, 0, ColColor(255), 40);
      for i := 0 to max do
      begin
        color1 := 0;
        color2 := $202020;
        if intitle = 0 then
        begin
          color1 := ColColor($7A);
          color2 := ColColor($7C);
        end;
        if i = menu then
        begin
          color1 := ColColor($64);
          color2 := ColColor($66);
        end;
        DrawShadowText(@menuString[i, 1], titlex1 + titlew * i + 20, titley1, color1, color2);
      end;
      UpdateAllScreen;
      pmenu := menu;
    end;
    CheckBasicEvent;
    if intitle = 0 then
    begin
      case menu of
        0:
        begin
          if MenuLoad >= 0 then
          begin
            FreeFreshScreen;
            DrawTitleMenu;
            TransBlackScreen;
            DrawTitleMenu(3);
            LoadTeamSimpleStatus(maxteam);
            RecordFreshScreen;
          end;
        end;
        1: MenuSave;
        2: MenuSet;
        3: Maker;
        4: MenuQuit;
      end;
      intitle := 1;
      pmenu := -1;
      if where >= 3 then
      begin
        MenuEscType := -1;
        break;
      end;
    end;
    case event.type_ of
      SDL_KEYDOWN:
      begin
        if (event.key.keysym.sym = SDLK_RIGHT) then
        begin
          if intitle = 1 then
          begin
            menu := menu + 1;
            if menu > max then
              menu := 0;
          end;
        end;
        if (event.key.keysym.sym = SDLK_LEFT) then
        begin
          if intitle = 1 then
          begin
            menu := menu - 1;
            if menu < 0 then
              menu := max;
          end;
        end;
      end;
      SDL_KEYUP:
      begin
        if (event.key.keysym.sym = SDLK_ESCAPE) then
        begin
          MenuEscType := -1;
          break;
        end;
        if (event.key.keysym.sym = SDLK_RETURN) or (event.key.keysym.sym = SDLK_SPACE) or
          ((event.key.keysym.sym = SDLK_DOWN) and (intitle = 1)) then
        begin
          intitle := 0;
        end;
      end;
      SDL_MOUSEBUTTONDOWN:
      begin

      end;
      SDL_MOUSEBUTTONUP:
      begin
        if (event.button.button = SDL_BUTTON_RIGHT) then
        begin
          MenuEscType := -1;
          break;
        end;
        if (event.button.button = SDL_BUTTON_LEFT) then
        begin
          if (intitle = 1) and (MouseInRegion(titlex1, titley1, 5 * titlew, 20, xm, ym)) then
          begin
            menu := (xm - titlex1 - 10) div titlew;
            intitle := 0;
          end;
        end;
      end;
      SDL_MOUSEMOTION:
      begin
        if MouseInRegion(titlex1, titley1, 5 * titlew, 20, xm, ym) then
        begin
          intitle := 1;
          menu := (xm - titlex1 - 10) div titlew;
        end;
      end;
    end;
    MenuEscType := CheckTitleMenu;
    if MenuEscType <> 3 then
      break;
    event.key.keysym.sym := 0;
    event.button.button := 0;
    SDL_Delay(20);
  end;
  FreeFreshScreen;
  //SDL_FreeSurface(tempsur);
  //SDL_UpdateRect2(screen,0,0,screen.w,screen.h);

end;

procedure MenuSet;
var
  menu, pmenu, x, y, w, h, i, valuechanged, maxmenu, pressed, leftright, xm, ym, h0: integer;
  filename: string;
  str, str2: array[0..7] of WideString;
  menuString: array[0..1] of WideString;
  Value: array [0..8] of integer;
  Kys_ini: TIniFile;
  tempsur: PSDL_Surface;
  dest: TSDL_Rect;
  color1, color2, mixcolorl, mixcolorr: uint32;
  mixalphal, mixalphar, arrowy, arrowlx, arrowrx: integer;
  fullscreenmode: uint32;
begin
  maxmenu := 8;
  pressed := 0;  //为1表示按下确定键
  leftright := 0;  //-1为正在按下左, 1为正在按下右, 在设置数值时使用, 可以加速
  str[0] := '音樂音量';
  str[1] := '音效音量';
  str[2] := '大地圖走路延遲';
  str[3] := '內場景走路延遲';
  str[4] := '戰鬥動畫延遲';
  str[5] := '戰鬥文字顯示';
  str[6] := '顯示模式';
  str[7] := '文字設置';
  Value[0] := volume;
  Value[1] := volumewav;
  Value[2] := walk_speed;
  Value[3] := walk_speed2;
  Value[4] := BATTLE_SPEED;
  Value[5] := EFFECT_STRING;
  Value[6] := FULLSCREEN;
  Value[7] := SIMPLE;
  Value[maxmenu] := 0;
  menuString[0] := '取消';
  menuString[1] := '確定';
  x := CENTER_X - 384 + 440;
  y := CENTER_Y - 240 + 90;
  w := 300;
  h0 := 28;
  h := (maxmenu + 1) * h0 + 5;
  menu := 0;
  pmenu := -1;
  valuechanged := 0;
  dest.x := x;
  dest.y := y;
  dest.w := w + 1;
  dest.h := h + 1;
  //tempsur := SDL_CreateRGBSurface(screen.flags, w + 1, h + 1, 32, RMask, GMask, BMask, 0);
  //SDL_BlitSurface(screen, @dest, tempsur, nil);
  RecordFreshScreen(x, y, w + 1, h + 1);
  arrowy := 4;
  arrowlx := x + 170;
  arrowrx := x + 235;
  while SDL_PollEvent(@event) >= 0 do
  begin
    if (menu <> pmenu) or (valuechanged = 1) or (leftright <> 0) then
    begin
      LoadFreshScreen(x, y);
      //SDL_BlitSurface(tempsur, nil, screen, @dest);
      CleanTextScreenRect(x, y, w, h);
      //DrawRectangle(x, y, w, h, 0, ColColor(255), 50);
      for i := 0 to maxmenu - 1 do
      begin
        if i = menu then
        begin
          color1 := ColColor($64);
          color2 := ColColor($66);
          DrawTextFrame(x + 10 - 29, y + 5 + i * h0 - 3, 26);
        end
        else
        begin
          color1 := 0;
          color2 := $202020;
          DrawTextFrame(x + 10 - 29, y + 5 + i * h0 - 3, 26, 10);
        end;
        if i < 5 then
        begin
          str2[i] := format('%5d', [Value[i]]);
          mixalphal := 0;
          mixalphar := 0;
          mixcolorl := $FFFFFFFF;
          mixcolorr := $FFFFFFFF;
          if i = menu then
          begin
            if leftright < 0 then
              mixalphal := 25;
            if leftright > 0 then
              mixalphar := 25;
          end;
          if Value[i] <= 0 then
          begin
            mixcolorl := 0;
            mixalphal := 50;
          end;
          if Value[i] >= 100 then
          begin
            mixcolorr := 0;
            mixalphar := 50;
          end;
          DrawMPic(2004, arrowlx, y + 5 + i * h0 + arrowy, -1, 0, 0, mixcolorl, mixalphal);
          DrawMPic(2005, arrowrx, y + 5 + i * h0 + arrowy, -1, 0, 0, mixcolorr, mixalphar);
        end
        else
        begin
          if i = 5 then
          begin
            if Value[i] = 0 then
              str2[i] := '關閉'
            else
              str2[i] := '打開';
          end;
          if i = 6 then
          begin
            if Value[i] = 0 then
              str2[i] := '窗口'
            else
              str2[i] := '全屏';
          end;
          if i = 7 then
          begin
            if Value[i] = 0 then
              str2[i] := '繁體'
            else
              str2[i] := '簡體';
          end;
        end;
        DrawShadowText(puint16(str[i]), x + 10, y + 5 + i * h0, color1, color2);
        DrawShadowText(puint16(str2[i]), x + 170, y + 5 + i * h0, color1, color2);
      end;
      for i := 0 to 1 do
      begin
        if (i = Value[maxmenu]) and (menu = maxmenu) then
        begin
          color1 := ColColor($64);
          color2 := ColColor($66);
        end
        else
        begin
          color1 := 0;
          color2 := $202020;
        end;
        DrawTextFrame(x + 140 + 80 * i - 19, y + 5 + maxmenu * h0 - 3, 4);
        DrawShadowText(puint16(menuString[i]), x + 140 + 80 * i, y + 5 + maxmenu * h0, color1, color2);
      end;
      UpdateAllScreen;
      //SDL_UpdateRect2(screen, x, y, w + 1, h + 1);
      pmenu := menu;
      valuechanged := 0;
      //leftright := 0;
    end;
    CheckBasicEvent;
    case event.type_ of
      SDL_KEYDOWN:
      begin
        //writeln(leftright,'before down');
        case event.key.keysym.sym of
          SDLK_UP:
          begin
            menu := menu - 1;
            if menu < 0 then
              menu := maxmenu;
          end;
          SDLK_DOWN:
          begin
            menu := menu + 1;
            if menu > maxmenu then
              menu := 0;
          end;
          SDLK_LEFT:
          begin
            if menu < 5 then
            begin
              //writeln(leftright,'before l down');
              Value[menu] := max(Value[menu] - 1, 0);
              leftright := leftright - 1;
            end
            else
            begin
              Value[menu] := 1 - Value[menu];
            end;
            valuechanged := 1;
          end;
          SDLK_RIGHT:
          begin
            if menu < 5 then
            begin
              Value[menu] := min(Value[menu] + 1, 100);
              leftright := leftright + 1;
            end
            else
            begin
              Value[menu] := 1 - Value[menu];
            end;
            valuechanged := 1;
          end;
        end;
        //writeln(leftright,'down');
      end;
      SDL_KEYUP:
      begin
        case event.key.keysym.sym of
          SDLK_ESCAPE:
          begin
            break;
          end;
          SDLK_RETURN, SDLK_SPACE:
          begin
            if menu = maxmenu then
            begin
              pressed := Value[maxmenu];
              break;
            end;
          end;
          SDLK_LEFT, SDLK_RIGHT:
          begin
            leftright := 0;
            valuechanged := 1;
            //writeln(leftright,'up');
          end;
        end;
      end;
      SDL_MOUSEBUTTONDOWN:
      begin
        case event.button.button of
          SDL_BUTTON_LEFT:
          begin
            if MouseInRegion(arrowlx, y + 5, 20, h0 * 5) then
            begin
              Value[menu] := max(Value[menu] - 1, 0);
              leftright := leftright - 1;
            end
            else if MouseInRegion(arrowrx, y + 5, 20, h0 * 5) then
            begin
              Value[menu] := min(Value[menu] + 1, 100);
              leftright := leftright + 1;
            end
            else
              leftright := 0;
            if leftright <> 0 then
              valuechanged := 1;
          end;
        end;
      end;
      SDL_MOUSEBUTTONUP:
      begin
        case event.button.button of
          SDL_BUTTON_LEFT:
          begin
            if MouseInRegion(x, y + 5, w, h - 5) then
            begin
              if MouseInRegion(x + 160 + 13, y + 5 + maxmenu * h0, 50, h0) or MouseInRegion(x +
                210 + 13, y + 5 + maxmenu * h0, 50, h0) then
              begin
                pressed := Value[maxmenu];
                //writeln(pressed);
                break;
              end;
              if MouseInRegion(x + 160 + 13, y + 5 + 5 * h0, 50, h0) then
              begin
                Value[5] := 1 - Value[5];
                //valuechanged := 1;
              end;
              if MouseInRegion(x + 160 + 13, y + 5 + 6 * h0, 50, h0) then
              begin
                Value[6] := 1 - Value[6];
                //valuechanged := 1;
              end;
              if MouseInRegion(x + 160 + 13, y + 5 + 7 * h0, 50, h0) then
              begin
                Value[7] := 1 - Value[7];
                //valuechanged := 1;
              end;
              leftright := 0;
              valuechanged := 1;
            end;
          end;
          SDL_BUTTON_RIGHT:
          begin
            break;
          end;
        end;
      end;
      SDL_MOUSEMOTION:
      begin
        if MouseInRegion(x, y + 5, w, h - 5, xm, ym) then
        begin
          menu := min((ym - y - 5) div h0, maxmenu);
          if menu = maxmenu then
          begin
            if MouseInRegion(x + 160 + 13, y + 5 + maxmenu * h0, 50, h0) then
            begin
              Value[maxmenu] := 0;
              valuechanged := 1;
            end;
            if MouseInRegion(x + 210 + 13, y + 5 + maxmenu * h0, 50, h0) then
            begin
              Value[maxmenu] := 1;
              valuechanged := 1;
            end;
          end;
        end;
      end;
    end;
    //如左右键正在按下则不清键值, 加快速度
    if abs(leftright) <= 1 then
      event.key.keysym.sym := 0;
    if leftright = 0 then
      event.button.button := 0;
    SDL_Delay(20);
  end;
  CleanKeyValue;
  if pressed = 1 then
  begin
    volume := Value[0];
    StopMP3(0);
    PlayMP3(nowmusic, -1, 0);

    volumewav := Value[1];
    walk_speed := Value[2];
    walk_speed2 := Value[3];
    BATTLE_SPEED := Value[4];
    EFFECT_STRING := Value[5];
    if FULLSCREEN <> Value[6] then
    begin
      FULLSCREEN := Value[6];
      SDL_SetRenderTarget(render, nil);
      SDL_RenderClear(render);
      if FULLSCREEN = 0 then
        SDL_SetWindowFullscreen(window, 0)
      else
      begin
        SDL_SetWindowFullscreen(window, SDL_WINDOW_FULLSCREEN_DESKTOP);
      end;
      SDL_SetRenderTarget(render, screenTex);
      MenuEscType := -1;
    end;

    SIMPLE := Value[7];

    filename := iniFilename;
    Kys_ini := TIniFile.Create(filename);
    try
      Kys_ini.WriteInteger('music', 'VOLUME', VOLUME);
      Kys_ini.WriteInteger('music', 'VOLUMEWAV', VOLUMEWAV);
      Kys_ini.WriteInteger('system', 'WALK_SPEED', walk_speed);
      Kys_ini.WriteInteger('system', 'WALK_SPEED2', walk_speed2);
      Kys_ini.WriteInteger('system', 'BATTLE_SPEED', BATTLE_SPEED);
      Kys_ini.WriteInteger('system', 'EFFECT_STRING', EFFECT_STRING);
      Kys_ini.WriteInteger('system', 'FULLSCREEN', FULLSCREEN);
      Kys_ini.WriteInteger('system', 'SIMPLE', SIMPLE);
    finally
      Kys_ini.Free;
    end;
  end;
  FreeFreshScreen;

end;


//读档选单

function MenuLoad: integer;
var
  menu, i, x, y: integer;
  str: WideString;
  menuString, menuEngString: array[0..10] of WideString;
  filename: string;
begin
  x := CENTER_X - 384 + 420;
  y := CENTER_Y - 240 + 90;
  menuString[0] := '進度一';
  menuString[1] := '進度二';
  menuString[2] := '進度三';
  menuString[3] := '進度四';
  menuString[4] := '進度五';
  menuString[5] := '進度六';
  menuString[6] := '進度七';
  menuString[7] := '進度八';
  menuString[8] := '進度九';
  menuString[9] := '進度十';
  menuString[10] := '自動檔';
  for i := 0 to 10 do
  begin
    if ZIP_SAVE = 0 then
      filename := AppPath + 'save/r' + IntToStr(i + 1) + '.grp'
    else
      filename := AppPath + 'save/' + IntToStr(i + 1) + '.zip';
    if FileExists(filename) then
      menuEngString[i] := FormatDateTime('yyyy-mm-dd hh:mm:ss', FileDateToDateTime(FileAge(filename)))
    else
      menuEngString[i] := '-------------------';
  end;
  menu := CommonMenu(x, y, 280, 10, 0, menuString, menuEngString);
  if menu >= 0 then
  begin
    LastShowScene := -1;
    if LoadR(menu + 1) then
    begin
      if where = 1 then
        JumpScence(CurScence, Sy, Sx);
      //Redraw;
      MenuEscType := -2;
    end
    else
    begin
      menu := -1;
      str := '讀檔失敗！索引丟失或文件不存在！';
      DrawTextWithRect(@str[1], x - 40, y + 310, 322, MapRGBA(240, 20, 20), MapRGBA(212, 20, 20));
      WaitAnyKey;
    end;
    //updateallscreen;
  end;
  Result := menu;

end;

//特殊的读档选单, 仅用在开始时读档

function MenuLoadAtBeginning(mode: integer): integer;
var
  menu, mixAlpha, i, x, y: integer;
  color1, color2, menucolor1, menucolor2: uint32;
  str: WideString;
  menuString, menuEngString: array[0..10] of WideString;
  //menuengstring: array of WideString;
  filename: string;
begin
  //Redraw;
  {if (text_layer = 1) then
  begin
    mixAlpha := 25;
    color1 := ColColor(5);
    color2 := ColColor(7);
    menucolor1 := ColColor($64);
    menucolor2 := ColColor($66);
  end
  else
  begin}
  mixAlpha := 0;
  color1 := 0;
  color2 := $20202020;
  menucolor1 := MapRGBA(240, 20, 20);
  menucolor2 := MapRGBA(212, 20, 20);

  x := CENTER_X - 175;
  y := CENTER_Y - 110;

  //setlength(menuengstring, 0);
  menuString[0] := '進度一';
  menuString[1] := '進度二';
  menuString[2] := '進度三';
  menuString[3] := '進度四';
  menuString[4] := '進度五';
  menuString[5] := '進度六';
  menuString[6] := '進度七';
  menuString[7] := '進度八';
  menuString[8] := '進度九';
  menuString[9] := '進度十';
  menuString[10] := '自動檔';
  for i := 0 to 10 do
  begin
    if ZIP_SAVE = 0 then
      filename := AppPath + 'save/r' + IntToStr(i + 1) + '.grp'
    else
      filename := AppPath + 'save/' + IntToStr(i + 1) + '.zip';
    if FileExists(filename) then
      menuEngString[i] := FormatDateTime('yyyy-mm-dd hh:mm:ss', FileDateToDateTime(FileAge(filename)))
    else
      menuEngString[i] := '-------------------';
  end;
  //DrawTPic(17, CENTER_X - 80, CENTER_Y - 70, nil, 0, 0, 0, 0);
  UpdateAllScreen;
  menu := CommonMenu(x, y, 300, 10, 0, menuString, menuEngString);
  if menu >= 0 then
  begin
    if mode = 0 then
    begin
      if LoadR(menu + 1) then
      begin
        instruct_14;
      end
      else
      begin
        menu := -2;
        str := '讀檔失敗！';
      end;
    end
    else
    begin
      if not LoadForSecondRound(menu + 1) then
      begin
        menu := -2;
        str := '繼承失敗！';
      end;
    end;
  end;
  Result := menu;

  if Result = -2 then
  begin
    //DrawShadowText(@str[1], CENTER_X + 40, CENTER_Y + 200, menucolor1, menucolor2);
    DrawTextWithRect(@str[1], x + 170, y + 310, 0, menucolor1, menucolor2);
    UpdateAllScreen;
    WaitAnyKey;
  end;

end;

function LoadForSecondRound(num: integer): boolean;
var
  i, s, j: integer;
  tempRitemlist: array of TItemList;
  tempRrole: array[-1..1000] of TRole;
  mode, itemtype, rnum: integer;
begin
  Result := False;
  mode := 0;
  if LoadR(num) then
  begin
    s := 0;
    for i := 0 to 107 do
    begin
      if GetStarState(i) > 0 then
        s := s + 1;
    end;
    //可以继承的条件
    mode := s div 36;
  end;
  Result := mode > 0;

  if Result then
  begin
    //记录现有物品和人物
    setlength(tempRItemList, MAX_ITEM_AMOUNT);
    move(Rrole[low(Rrole)], tempRrole[low(tempRrole)], sizeof(TRole) * length(Rrole));
    move(RItemlist[0], tempRItemList[0], sizeof(TItemList) * MAX_ITEM_AMOUNT);

    LoadR(0);

    //保留人物第一个技能的等级
    if mode >= 1 then
    begin
      Rrole[0] := tempRrole[0];
      Rrole[0].Level := 1;
      Rrole[0].Attack := 10;
      Rrole[0].Defence := 10;
      //Rrole[0].Speed:=10;
      Rrole[0].CurrentHP := 0;
      Rrole[0].CurrentMP := 0;
      Rrole[0].MaxHP := Rrole[0].MaxHP div 40;
      Rrole[0].MaxMP := Rrole[0].MaxMP div 40;
      Rrole[0].Exp := 0;
      Rrole[0].MagLevel[0] := 800;
      Rrole[0].Equip[0] := -1;
      Rrole[0].Equip[1] := -1;
      Rrole[0].PracticeBook := -1;
      //清空主角武功
      for i := 1 to 9 do
      begin
        Rrole[0].Magic[i] := 0;
        Rrole[0].MagLevel[i] := 0;
      end;
      for i := 0 to 3 do
      begin
        Rrole[0].NeiGong[i] := 0;
        Rrole[0].NGLevel[i] := 0;
      end;
      for i := 0 to 107 do
      begin
        rnum := StarToRole(i);
        for j := 0 to 0 do
        begin
          if Rrole[rnum].Magic[j] > 0 then
            Rrole[rnum].MagLevel[j] := tempRrole[rnum].MagLevel[j];
        end;
        for j := 0 to -1 do
        begin
          if Rrole[rnum].NeiGong[j] > 0 then
            Rrole[rnum].NGLevel[j] := tempRrole[rnum].NGLevel[j];
        end;
        //Rrole[rnum] := tempRrole[rnum];
      end;
    end;
    //保留除秘籍外物品
    if mode >= 2 then
    begin
      for i := 0 to MAX_ITEM_AMOUNT - 1 do
      begin
        if tempRItemList[i].Number < 0 then
          break;
        itemtype := Ritem[tempRItemList[i].Number].ItemType;
        if (tempRItemList[i].Number = MONEY_ID) or (itemType in [1, 3, 4]) then
          instruct_32(tempRItemList[i].Number, tempRItemList[i].Amount);
      end;
      if Rrole[0].AmiFrameNum[0] < 0 then
        Rrole[0].AmiFrameNum[0] := 8;
    end;
    //保留秘籍, 正式进入二周目
    if mode >= 3 then
    begin
      instruct_32(COMPASS_ID, 1); //周目数即罗盘数
      for i := 0 to MAX_ITEM_AMOUNT - 1 do
      begin
        if tempRItemList[i].Number < 0 then
          break;
        itemtype := Ritem[tempRItemList[i].Number].ItemType;
        if itemType = 2 then
          instruct_32(tempRItemList[i].Number, tempRItemList[i].Amount);
      end;
    end;
  end
  else
    LoadR(0);
  instruct_14;
end;

//存档选单

procedure MenuSave;
var
  menu, i: integer;
  str: WideString;
  menuString, menuEngString: array[0..9] of WideString;
  filename: string;
begin
  menuString[0] := '進度一';
  menuString[1] := '進度二';
  menuString[2] := '進度三';
  menuString[3] := '進度四';
  menuString[4] := '進度五';
  menuString[5] := '進度六';
  menuString[6] := '進度七';
  menuString[7] := '進度八';
  menuString[8] := '進度九';
  menuString[9] := '進度十';
  for i := 0 to 9 do
  begin
    if ZIP_SAVE = 0 then
      filename := AppPath + 'save/r' + IntToStr(i + 1) + '.grp'
    else
      filename := AppPath + 'save/' + IntToStr(i + 1) + '.zip';
    if FileExists(filename) then
      menuEngString[i] := FormatDateTime('yyyy-mm-dd hh:mm:ss', FileDateToDateTime(FileAge(filename)))
    else
      menuEngString[i] := '-------------------';
  end;
  //水浒中的71古墓场景不可存档
  if ((where = 1) and (MODVersion = 13) and (CurScence = 71)) or (ScreenBlendMode > 0) then
  begin
    str := '此時不可存檔！';
    //Redraw;
    DrawTextWithRect(@str[1], CENTER_X - 384 + 480, CENTER_Y - 240 + 90, 152, ColColor($5), ColColor($7));
    WaitAnyKey;
  end
  else
  begin
    menu := CommonMenu(CENTER_X - 384 + 420, CENTER_Y - 240 + 90, 280, 9, 0, menuString, menuEngString);
    if menu >= 0 then
      if not SaveR(menu + 1) then
      begin
        str := '存檔失敗！索引丟失或文件被佔用！';
        DrawTextWithRect(@str[1], CENTER_X - 384 + 420 - 40, CENTER_Y - 240 + 90 + 280, 322,
          MapRGBA(240, 20, 20), MapRGBA(212, 20, 20));
        WaitAnyKey;
      end;
  end;
  //ShowMenu(3);
  //ShowMenusystem(1);

end;

//退出选单

procedure MenuQuit;
var
  menu, n: integer;
  str1, str2: string;
  str: WideString;
  menuString: array [0..2] of WideString;
begin
  menuString[0] := '取消';
  menuString[1] := '確定';
  menuString[2] := 'Test';
  //n := 1;
  //if KDEF_SCRIPT > 0 then
  n := 2;
  menu := CommonMenu(CENTER_X - 384 + 660, CENTER_Y - 240 + 90, 47, n, 0, menuString);
  if menu = 1 then
  begin
    where := 3;
    //instruct_14;
    //Redraw;
    MenuEscType := -2;
    //DrawRectangleWithoutFrame(screen, 0, 0, CENTER_X * 2, CENTER_Y * 2, 0, 60);
    //str := '请按任意键继续…';
    //DrawShadowText(@str[1], CENTER_X - 120, CENTER_Y - 25, ColColor(255), ColColor(255));
    //updateallscreen;
    //PlayMP3(StartMusic, -1);
    //WaitAnyKey;
    //Redraw;
    //DrawTPic(0, TitlePosition.x, TitlePosition.y);
    //updateallscreen;
  end;

  if menu = 2 then
  begin
    //str1 := '';
    //str1 := inputbox('Script file number:', str1, '1');
    //str2 := '';
    //str2 := inputbox('Function name:', str2, 'f1');
    str := '輸入腳本文件名';
    DrawTextWithRect(@str[1], CENTER_X - 80, CENTER_Y - 240 + 130, 148, 0, ColColor($23));
    str1 := IntToStr(EnterNumber(0, 100, CENTER_X - 80, CENTER_Y - 240 + 200, 1));
    str := '輸入功能編號';
    DrawTextWithRect(@str[1], CENTER_X + 120, CENTER_Y - 240 + 130, 128, 0, ColColor($23));
    str2 := 'f' + IntToStr(EnterNumber(0, 32767, CENTER_X + 120, CENTER_Y - 240 + 200, 0));
    if ExecScript(AppPath + 'script/' + str1 + '.lua', str2) <> 0 then
    begin
      str := ' Script fail!';
      DrawTextWithRect(@str[1], CENTER_X - 384 + 400, CENTER_Y - 240 + 150, 150, ColColor($64), ColColor($66));
      WaitAnyKey;
    end;
  end;
  //if menu <> 1 then
  //begin
  //ShowMenu(3);
  //ShowMenusystem(5);
  //end;
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
  if Rrole[role1].PhyPower < 50 then
    addlife := 0;
  {Rrole[role2].Hurt := Rrole[role2].Hurt - addlife div LIFE_HURT;
   if RRole[role2].Hurt < 0 then
     RRole[role2].Hurt := 0;
   }
  if addlife > Rrole[role2].MaxHP - Rrole[role2].CurrentHP then
    addlife := Rrole[role2].MaxHP - Rrole[role2].CurrentHP;
  Rrole[role2].CurrentHP := Rrole[role2].CurrentHP + addlife;
  if addlife > 0 then
    Rrole[role1].PhyPower := Rrole[role1].PhyPower - 5;
  if where <> 2 then
  begin
    TransBlackScreen;
    DrawRectangle(CENTER_X - 150 + 30, 170, {115, 98,} 155, 52, 0, ColColor(255), 30);
    DrawU16ShadowText(@Rrole[role2].Name, CENTER_X - 150 + 35, 172, ColColor($23), ColColor($21));
    word := ('增加生命');
    DrawShadowText(@word[1], CENTER_X - 150 + 35, 197, ColColor($7), ColColor($5));
    word := format('%4d', [addlife]);
    DrawEngShadowText(@word[1], CENTER_X - 150 + 135, 197, ColColor($66), ColColor($64));
    //word := ('減少受傷');
    //drawshadowtext( @word[1], 100, 150, colcolor($7), colcolor($5));
    //word := format('%4d', [minushurt]);
    //drawengshadowtext( @word[1], 220, 150, colcolor($66), colcolor($64));
    ShowSimpleStatus(role2, CENTER_X - 150, 70);
    UpdateAllScreen;
    WaitAnyKey;
    Redraw;
  end;

end;

//解毒的效果

procedure EffectMedPoison(role1, role2: integer);
var
  word: WideString;
  minuspoi: integer;
begin
  minuspoi := Rrole[role1].MedPoi;
  if minuspoi > Rrole[role2].Poison then
    minuspoi := Rrole[role2].Poison;
  if Rrole[role1].PhyPower < 50 then
    minuspoi := 0;
  Rrole[role2].Poison := Rrole[role2].Poison - minuspoi;
  if minuspoi > 0 then
    Rrole[role1].PhyPower := Rrole[role1].PhyPower - 3;
  if where <> 2 then
  begin
    TransBlackScreen;
    DrawRectangle(CENTER_X - 150 + 30, 170, 155, 52, 0, ColColor(255), 30);
    word := ('減少中毒');
    DrawShadowText(@word[1], CENTER_X - 150 + 35, 197, ColColor($7), ColColor($5));
    DrawU16ShadowText(@Rrole[role2].Name, CENTER_X - 150 + 35, 172, ColColor($23), ColColor($21));
    word := format('%4d', [minuspoi]);
    DrawEngShadowText(@word[1], CENTER_X - 150 + 135, 197, ColColor($66), ColColor($64));
    ShowSimpleStatus(role2, CENTER_X - 150, 70);
    UpdateAllScreen;
    WaitAnyKey;
    Redraw;
  end;

end;

//使用物品的效果
//练成秘笈的效果

procedure EatOneItem(rnum, inum: integer);
var
  i, j, p, l, x, y, xp, yp: integer;
  word: array[0..24] of WideString;
  addvalue, rolelist: array[0..24] of integer;
  str: WideString;
begin

  word[0] := '增加生命';
  word[1] := '增加生命最大值';
  word[2] := '增加中毒程度';
  word[3] := '增加體力';
  word[4] := '內力門路陰陽合一';
  word[5] := '增加內力';
  word[6] := '增加內力最大值';
  word[7] := '增加攻擊力';
  word[8] := '增加輕功';
  word[9] := '增加防禦力';
  word[10] := '增加醫療能力';
  word[11] := '增加用毒能力';
  word[12] := '增加解毒能力';
  word[13] := '增加抗毒能力';
  word[14] := '增加拳掌能力';
  word[15] := '增加御劍能力';
  word[16] := '增加耍刀能力';
  word[17] := '增加特殊兵器';
  word[18] := '增加暗器技巧';
  word[19] := '增加武學常識';
  word[20] := '增加品德指數';
  word[21] := '增加移動力';
  word[22] := '增加攻擊帶毒';
  word[23] := '受傷程度';
  word[24] := '修習武學等級';
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
        if (random(200) < 2 * Rrole[rnum].Aptitude) then
          addvalue[i] := addvalue[i] + 1;
      end;
    end;
  end;
  //减少受伤
  addvalue[23] := -(addvalue[0] div (LIFE_HURT div 2));

  if -addvalue[23] > Rrole[rnum].Data[19] then
    addvalue[23] := -Rrole[rnum].Data[19];

  //增加生命, 内力最大值的处理
  if addvalue[1] + Rrole[rnum].Data[18] > MAX_HP then
    addvalue[1] := MAX_HP - Rrole[rnum].Data[18];
  if addvalue[6] + Rrole[rnum].Data[42] > MAX_MP then
    addvalue[6] := MAX_MP - Rrole[rnum].Data[42];
  if addvalue[1] + Rrole[rnum].Data[18] < 0 then
    addvalue[1] := -Rrole[rnum].Data[18];
  if addvalue[6] + Rrole[rnum].Data[42] < 0 then
    addvalue[6] := -Rrole[rnum].Data[42];

  for j := 7 to 22 do
  begin
    //不影响物品不增加或减少的属性
    if addvalue[j] <> 0 then
    begin
      if addvalue[j] + Rrole[rnum].Data[rolelist[j]] > MaxProList[rolelist[j]] then
        addvalue[j] := MaxProList[rolelist[j]] - Rrole[rnum].Data[rolelist[j]];
      if addvalue[j] + Rrole[rnum].Data[rolelist[j]] < 0 then
        addvalue[j] := -Rrole[rnum].Data[rolelist[j]];
      //14到18为五系兵器值, 低资质有额外福利
      if (j >= 14) and (j <= 18) then
      begin
        if (random(200) < 200 - 2 * Rrole[rnum].Aptitude) then
          addvalue[i] := addvalue[i] + 1;
      end;
    end;
  end;
  //生命不能超过最大值
  if addvalue[0] + Rrole[rnum].Data[17] > addvalue[1] + Rrole[rnum].Data[18] then
    addvalue[0] := addvalue[1] + Rrole[rnum].Data[18] - Rrole[rnum].Data[17];
  //中毒不能小于0
  if addvalue[2] + Rrole[rnum].Data[20] < 0 then
    addvalue[2] := -Rrole[rnum].Data[20];
  //体力不能超过最大值
  if addvalue[3] + Rrole[rnum].Data[21] > MAX_PHYSICAL_POWER then
    addvalue[3] := MAX_PHYSICAL_POWER - Rrole[rnum].Data[21];
  //内力不能超过最大值
  if addvalue[5] + Rrole[rnum].Data[41] > addvalue[6] + Rrole[rnum].Data[42] then
    addvalue[5] := addvalue[6] + Rrole[rnum].Data[42] - Rrole[rnum].Data[41];
  //所修习武学的等级
  if (Ritem[inum].ItemType = 2) and (Ritem[inum].Magic > 0) then
  begin
    addvalue[24] := GetMagicLevel(rnum, Ritem[inum].Magic) + 1;
    if addvalue[24] > 10 then
      addvalue[24] := 10;
    //if not canequip(rnum,inum) then addvalue[24] := 0;
  end
  else
    addvalue[24] := 0;

  //统计项目数
  p := 0;
  for i := 0 to 24 do
  begin
    if (i <> 4) {and (i <> 21)} and (addvalue[i] <> 0) then
    begin
      p := p + 1;
    end;
  end;
  if (addvalue[4] = 2) and (Rrole[rnum].Data[40] <> 2) then
    p := p + 1;
  //if (addvalue[21] = 1) and (Rrole[rnum].Data[58] <> 1) then
  //p := p + 1;

  xp := CENTER_X - 150;
  yp := CENTER_Y - 240 + 70;

  //DrawRectangle(30 + xp, 100 + yp, 200, 25, 0, ColColor(255), 25);
  DrawTextFrame(14 + xp, 99 + yp, 4 + DrawLength(pWideChar(@Ritem[inum].Name)));
  str := '服用';
  if Ritem[inum].ItemType = 2 then
    str := '練成';
  DrawShadowText(@str[1], 33 + xp, 102 + yp, 0, ColColor($23));
  DrawU16ShadowText(@Ritem[inum].Name, 73 + xp, 102 + yp, ColColor($64), ColColor($66));

  //如果增加的项超过11个, 分两列显示
  if p < 11 then
  begin
    l := p;
    //DrawRectangle(30 + xp, 130 + yp, 200, 22 * l + 26, 0, ColColor($FF), 25);
  end
  else
  begin
    l := p div 2 + 1;
    xp := xp - 90;
    //DrawRectangle(30 + xp, 130 + yp, 400, 22 * l + 26, 0, ColColor($FF), 25);
  end;
  //DrawU16ShadowText(@Rrole[rnum].Data[4], 33 + xp, 132 + yp, ColColor($21), ColColor($23));
  if p = 0 then
  begin
    str := '無明顯效果';
    DrawTextWithRect(@str[1], 14 + xp, 132 + yp, 10, ColColor($64), ColColor($66));
  end;
  p := 0;

  for i := 0 to 24 do
  begin
    if p < l then
    begin
      x := 0;
      y := 0;
    end
    else
    begin
      x := 200;
      y := -l * 28;
    end;
    if (i <> 4) and (addvalue[i] <> 0) then
    begin
      if i <> 24 then
        Rrole[rnum].Data[rolelist[i]] := Rrole[rnum].Data[rolelist[i]] + addvalue[i];
      DrawTextFrame(14 + xp, 127 + yp + y + p * 28, 18, 10, 0, 25);
      DrawShadowText(@word[i, 1], 33 + xp + x, 130 + yp + y + p * 28, 0, $202020);
      //if i <> 21 then
      str := format('%5d', [addvalue[i]]);
      //else
      //str := format('%5.1f', [addvalue[i] / 10]);
      DrawEngShadowText(@str[1], 163 + xp + x, 130 + yp + y + p * 28, ColColor($64), ColColor($66));
      p := p + 1;
    end;
    //对内力性质特殊处理
    if (i = 4) and (addvalue[i] = 2) then
    begin
      if Rrole[rnum].Data[rolelist[i]] <> 2 then
      begin
        Rrole[rnum].Data[rolelist[i]] := 2;
        DrawTextFrame(14 + xp, 127 + yp + y + p * 28, 18, 10, 0, 25);
        DrawShadowText(@word[i, 1], 33 + xp + x, 130 + yp + y + p * 28, 0, $202020);
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
  ShowSimpleStatus(rnum, xp, yp);
  UpdateAllScreen;

end;

//Event.
//事件系统

procedure CallEvent(num: integer);
var
  e: array of smallint;
  i, IDX, GRP, offset, len, p, lenkey: integer;
  check: boolean;
  script: string;
begin
  if num = 0 then
    exit;
  //CurEvent:=num;
  NeedRefreshScence := 0;
  SkipTalk := 0;
  if (KDEF_SCRIPT = 0) {or (not FileExists(AppPath + EventScriptPath + IntToStr(num) + '.lua'))} then
  begin
    {len := 0;
    if num = 0 then
    begin
      offset := 0;
      len := KIdx[0];
    end
    else
    begin
      offset := KIdx[num - 1];
      len := KIdx[num] - offset;
    end;}
    offset := KDEF.IDX[num];
    len := KDEF.IDX[num + 1] - offset;
    setlength(e, len div 2 + 1);
    move(KDEF.GRP[offset], e[0], len);
    ConsoleLog('Event %d', [num]);
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
      //writeln('Event ', num);
      //Write('Pointer: ', i, ', Run instruct ', e[i], ' ');
      //if e[i] = 50 then
      //Write(e[i + 1], ',', e[i + 2], ',', e[i + 3], ',', e[i + 4], ',', e[i + 5], ',', e[i + 6], ',', e[i + 7]);
      //writeln;
      case e[i] of
        0:
        begin
          //instruct_0;
          i := i + 1;
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
          instruct_3([e[i + 1], e[i + 2], e[i + 3], e[i + 4], e[i + 5], e[i + 6], e[i + 7], e[i + 8],
            e[i + 9], e[i + 10], e[i + 11], e[i + 12], e[i + 13]]);
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
          ShowTitle(e[i + 1], e[i + 2]);
          i := i + 3;
        end;
        71:
        begin
          JumpScence(e[i + 1], e[i + 2], e[i + 3]);
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
  end
  else
  begin
    if KDEF_SCRIPT = 1 then
    begin
      ConsoleLog('Enter script %d', [num]);
      ExecScript(AppPath + EventScriptPath + IntToStr(num) + '.lua', '');
    end
    else
    begin
      ConsoleLog('Enter script %d', [num]);
      script := LoadStringFromIMZMEM(AppPath + 'script/event/', pEvent, num);
      //ConsoleLog(script);
      ExecScriptString(script, '');
    end;
  end;
  event.key.keysym.sym := 0;
  event.button.button := 0;
  //writeln(needrefreshscence);
  //if MODVersion = 0 then
  //CurScenceRolePic := -1;
  if NeedRefreshScence = 1 then
  begin
    //InitialScence(0);
  end;
  NeedRefreshScence := 1;
  //if where <> 2 then CurEvent := -1;
  ////SDL_EnableKeyRepeat(30, 30);

end;

procedure TurnBlack;
begin
  instruct_14;
end;

procedure ReSetEntrance;
var
  i1, i2, i: integer;
begin
  {for i1 := 0 to 479 do
    for i2 := 0 to 479 do
      Entrance[i1, i2] := -1;}
  FillChar(Entrance[0, 0], sizeof(Entrance), -1);
  for i := 0 to min(ScenceAmount - 1, High(Rscence)) do
  begin
    if (Rscence[i].MainEntranceX1 >= 0) and (Rscence[i].MainEntranceX1 < 480) and (Rscence[i].MainEntranceY1 >= 0) and
      (Rscence[i].MainEntranceY1 < 480) then
      Entrance[Rscence[i].MainEntranceX1, Rscence[i].MainEntranceY1] := i;
    if (Rscence[i].MainEntranceX2 >= 0) and (Rscence[i].MainEntranceX2 < 480) and (Rscence[i].MainEntranceY2 >= 0) and
      (Rscence[i].MainEntranceY2 < 480) then
      Entrance[Rscence[i].MainEntranceX2, Rscence[i].MainEntranceY2] := i;
  end;
end;


procedure Maker;
var
  words: TStringList;
begin
  //CallEvent(251);
  words := TStringList.Create;
  //words.LoadFromFile(AppPath + 'txt/group.txt');
  words.Add('');
  words.Add('《金庸巨基傳》');
  //words.Add('Legend of Little Village III');
  words.Add('108 Brothers And Sisters');
  words.Add('');

  words.Add('原鐵血丹心論壇出品');
  words.Add('http://www.dawuxia.net');
  words.Add('http://www.txdx.net');
  words.Add('');

  words.Add('總策劃');
  words.Add('小小猪');
  words.Add('');

  words.Add('架構');
  words.Add('bttt');
  words.Add('');

  words.Add('程式');
  words.Add('凯哥');
  words.Add('bttt');
  words.Add('小小猪');
  words.Add('真正的强强');
  words.Add('无酒肆屋');
  words.Add('');

  words.Add('事件');
  words.Add('小小猪');
  words.Add('凶神恶煞');
  words.Add('凯哥');
  words.Add('KA');
  words.Add('');

  words.Add('腳本');
  words.Add('柳无色');
  words.Add('bttt');
  words.Add('无酒肆屋');
  words.Add('DonaldHuang');
  words.Add('');

  words.Add('劇本');
  words.Add('风神无名');
  words.Add('天外草');
  words.Add('云潇潇');
  words.Add('赫连春水');
  words.Add('馋师无相');
  words.Add('');

  words.Add('設計');
  words.Add('风神无名');
  words.Add('qja');
  words.Add('南宫梦');
  words.Add('xuantianxi');
  words.Add('');

  words.Add('美工');
  words.Add('游客');
  words.Add('xuantianxi');
  words.Add('令狐心情');
  words.Add('小孩家家');
  words.Add('伊人枕边醉');
  words.Add('Czhe520');
  words.Add('流木匆匆');
  words.Add('无酒肆屋');
  words.Add('项羽');
  words.Add('');

  words.Add('場景');
  words.Add('游客');
  words.Add('柳无色');
  words.Add('');

  words.Add('音效');
  words.Add('凯哥');
  words.Add('云潇潇');
  words.Add('赫连春水');
  words.Add('');

  words.Add('工具');
  words.Add('KA');
  words.Add('真正的强强');
  words.Add('bttt');
  words.Add('');

  words.Add('測試');
  words.Add('9523');
  words.Add('gn0811');
  words.Add('张贝克');
  words.Add('Chopsticks');
  words.Add('天真木頭人');
  words.Add('叶墨');
  words.Add('柳无色');
  words.Add('路人甲');
  //words.Add('南窗寄傲生');
  words.Add('杨裕彪');
  words.Add('CLRGC');
  words.Add('');

  words.Add('校對');
  words.Add('天一水');
  words.Add('天下有敌');
  words.Add('南窗寄傲生');
  words.Add('');

  //words.Add('協調');
  //words.Add('bt');
  //words.Add('xuantianxi');
  //words.Add('风神无名');
  //words.Add('KA');
  //words.Add('');

  words.Add('Android移植');
  words.Add('KA');
  words.Add('bttt');
  words.Add('');

  words.Add('特別感謝');
  words.Add('河洛工作室');
  words.Add('智冠科技');
  words.Add('游泳的鱼');
  words.Add('chaoliu');
  words.Add('fanyixia');
  words.Add('hihi88byebye');
  words.Add('chenxurui07');
  words.Add('晴空飞雪');
  words.Add('蓝雨冰刀');
  words.Add('玉芷馨');
  words.Add('chumsdock');
  words.Add('沧海一笑');
  words.Add('ena');
  words.Add('qiu001');
  words.Add('winson7891');
  words.Add('halfrice');
  words.Add('soastao');
  words.Add('ice');
  words.Add('黑天鹅');
  words.Add('');

  words.Add('開發工具以及開發庫');
  words.Add('Free Pascal Compiler');
  words.Add('Lazarus / CodeTyphon');
  words.Add('ADT / NDK');
  words.Add('SDL & TTF & Image & gfx & Mixer');
  words.Add('OpenGL');
  words.Add('bass & bassmidi');
  words.Add('FFmpeg / Libav');
  words.Add('zlib / minizip');
  words.Add('lua');
  words.Add('');

  words.Add('致謝以下開源項目');
  words.Add('JEDI-SDL');
  words.Add('kys-jedisdl');
  words.Add('UltraStar Deluxe');
  words.Add('Open Chinese Convert');
  words.Add('');

  words.Add('特別致謝短歌行MIDI音色庫');
  words.Add('');

  words.Add('再次致謝');
  words.Add('論壇無數版友');
  words.Add('以及網絡上的諸多素材');
  words.Add('');
  //words.Add('铁血丹心论坛');
  //words.Add('做中国人自己的武侠单机游戏');
  //words.Add('http://www.txdx.net');
  if where < 3 then
  begin
    PlayMP3(startmusic, -1);
    Redraw;
  end;
  ScrollTextAmi(words, 22, 20, 23, 0, 0, 0, 15, -1, 0);
  words.Free;
end;


//align: 0-居中, 1-左对齐
//alignx: 非居中时指定横轴位置
procedure ScrollTextAmi(words: TStringList; chnsize, engsize, linespace, align, alignx, style, delay, picnum, scrolldirect: integer);
var
  x, y, i, l, len, w, h, texw, texh, texh0: integer;
  tempscr, tempscr1: PSDL_Surface;
  dest, tempdest, src: TSDL_Rect;
  str: WideString;
  color1, color2: uint32;
  tex, ptex: PSDL_Texture;
  sur, target: PSDL_Surface;
begin
  Redraw;
  CleanTextScreen;
  SetFontSize(chnsize, engsize, 1);
  ptex := SDL_GetRenderTarget(render);
  if TEXT_LAYER = 0 then
  begin
    texw := CENTER_X * 2;
    texh0 := CENTER_Y * 2;
  end
  else
  begin
    texw := RESOLUTIONX;
    texh0 := RESOLUTIONY;
  end;
  texh := (words.Count - 1) * linespace + texh0 * 3 div 2;
  if picnum < 0 then
    RecordFreshScreen;
  if SW_SURFACE = 0 then
  begin
    tex := SDL_CreateTexture(render, SDL_PIXELFORMAT_ARGB8888, SDL_TEXTUREACCESS_TARGET, texw, texh);
    ConsoleLog('Big texture, the width and height are %d and %d', [texw, texh]);
    SDL_SetRenderTarget(render, tex);
    SDL_SetRenderDrawBlendMode(render, SDL_BLENDMODE_NONE);
    SDL_SetRenderDrawColor(render, 0, 0, 0, 255);
    SDL_RenderFillRect(render, nil);
    SDL_SetRenderTarget(render, screenTex);
    if TEXT_LAYER = 0 then
      SDL_SetTextureBlendMode(tex, SDL_BLENDMODE_BLEND)
    else
      SDL_SetTextureBlendMode(tex, SDL_BLENDMODE_NONE);
  end
  else
  begin
    sur := SDL_CreateRGBSurface(0, texw, texh, 32, RMASK, GMASK, BMASK, AMASK);
    if TEXT_LAYER = 0 then
      SDL_SetSurfaceBlendMode(sur, SDL_BLENDMODE_BLEND)
    else
      SDL_SetSurfaceBlendMode(sur, SDL_BLENDMODE_NONE);
    SDL_FillRect(sur, nil, MapRGBA(0, 0, 0, 255));
  end;

  for l := 0 to words.Count - 1 do
  begin
    str := UTF8Decode(words.Strings[l]);
    len := DrawLength(str);
    if align = 0 then
    begin
      x := texw div 2 - len * chnsize div 4 - 10;
    end
    else
    begin
      x := alignx;
    end;
    color1 := ColColor($64);
    color2 := ColColor($66);
    if l > 0 then
    begin
      if (words.Strings[l - 1] <> '') and (style = 0) then
      begin
        color1 := ColColor($5);
        color2 := ColColor($7);
      end;
    end;
    DrawShadowText(@str[1], x, l * linespace + texh0, color1, color2, tex, sur, 1);
  end;
  ReSetFontSize;
  if SW_SURFACE = 0 then
  begin
    SDL_SetTextureAlphaMod(tex, 192);
  end
  else
  begin
    SDL_SetSurfaceAlphaMod(sur, 192);
    target := screen;
    if TEXT_LAYER = 1 then
      target := TextScreen;
  end;

  i := 0;
  CleanTextScreen;
  HaveText := 1;
  while SDL_PollEvent(@event) >= 0 do
  begin
    dest.x := 0;
    dest.y := -i;
    dest.w := texw;
    dest.h := texh0;
    if picnum < 0 then
    begin
      LoadFreshScreen;
      if SW_SURFACE = 0 then
      begin
        if TEXT_LAYER = 1 then
          SDL_SetRenderTarget(render, TextScreenTex)
        else
          SDL_SetRenderTarget(render, screenTex);
        SDL_RenderCopy(render, tex, @dest, nil);
      end
      else
        SDL_BlitSurface(sur, @dest, target, nil);
    end
    else
    begin
      if picnum <= High(TitlePNGIndex) then
      begin
        w := TitlePNGIndex[picnum].w;
        h := TitlePNGIndex[picnum].h;
        src.x := trunc(i * (w - CENTER_X * 2) / max(1, texh - CENTER_Y * 2)) + w - CENTER_X * 2;
        src.y := 0;
        src.w := CENTER_X * 2;
        src.h := h;
        if SW_SURFACE = 0 then
        begin
          SDL_SetRenderTarget(render, screenTex);
        end;
        DrawTPic(picnum, 0, 0, @src);
        dest.x := 0;
        dest.y := texh0 div 2;
        dest.w := texw;
        dest.h := texh0 div 2;
        tempdest.x := 0;
        tempdest.y := -i + texh0 div 2;
        tempdest.w := texw;
        tempdest.h := texh0 div 2;
        if SW_SURFACE = 0 then
        begin
          if TEXT_LAYER <> 0 then
            SDL_SetRenderTarget(render, TextScreenTex)
          else
            SDL_SetTextureAlphaMod(tex, 255);
          SDL_RenderCopy(render, tex, @tempdest, @dest);
        end
        else
        begin
          if TEXT_LAYER = 0 then
            SDL_SetSurfaceAlphaMod(sur, 255);
          SDL_BlitSurface(sur, @tempdest, target, @dest);
        end;
      end;
    end;
    UpdateAllScreen;
    i := i - 1;
    if i <= -texh + texh0 then
    begin
      WaitAnyKey;
      break;
    end;
    CheckBasicEvent;
    case event.type_ of
      SDL_MOUSEBUTTONUP:
        if event.button.button = SDL_BUTTON_RIGHT then
          break;
      SDL_KEYUP:
        if event.key.keysym.sym = SDLK_ESCAPE then
          break;
    end;
    SDL_Delay(delay);
  end;
  if SW_SURFACE = 0 then
    SDL_DestroyTexture(tex)
  else
    SDL_FreeSurface(sur);

  if picnum < 0 then
    FreeFreshScreen;
  HaveText := 1;
  CleanTextScreen;
  CleanKeyValue;
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
    Cloud[num].Picnum := random(CPicAmount);
    Cloud[num].Shadow := 0;
    Cloud[num].Alpha := random(50) + 25;
    Cloud[num].mixColor := random(256) + random(256) shl 8 + random(256) shl 16 + random(256) shl 24;
    Cloud[num].mixAlpha := -1;
    Cloud[num].Positionx := 0;
    Cloud[num].Positiony := random(8640);
    Cloud[num].Speedx := 1 + random(3);
    Cloud[num].Speedy := 0;
  end;
end;

function IsCave(snum: integer): boolean;
begin
  case MODVersion of
    13: Result := snum in [6, 10, 26, 35, 52, 71, 72, 78, 87, 107];
    else
      Result := snum in [5, 7, 10, 41, 42, 46, 65, 66, 67, 72, 79];
      //Result := False;
  end;
end;

function CheckString(str: string): boolean;
begin
  Redraw;
  UpdateAllScreen;
  ShowMessage(str);
  Result := False;
end;

end.
