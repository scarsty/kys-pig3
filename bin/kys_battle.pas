unit kys_battle;

interface

uses
  SysUtils,
  SDL2,
  Math,
  kys_type,
  kys_main;

//战斗
//从游戏文件的命名来看, 应是'war'这个词的缩写,
//但实际上战斗的规模很小, 使用'battle'显然更合适
function Battle(battlenum, getexp: integer; forceSingle: integer = 0): boolean;
procedure LoadBattleTiles();
procedure FreeBattleTiles();
function InitialBField: boolean;
procedure InitialBRole(i, rnum, team, x, y: integer);
function SelectTeamMembers(forceSingle: integer = 0): integer;
function CalFace(x1, y1, x2, y2: integer): integer; overload;
function CalFace(bnum1, bnum2: integer): integer; overload;
function CalBroleDistance(bnum1, bnum2: integer): integer;
procedure BattleMainControl;
function CalBroleMoveAbility(bnum: integer): integer;
procedure CalMoveAbility;
procedure ReArrangeBRole;
function BattleStatus: integer;
function BattleMenu(bnum: integer): integer;
procedure MoveRole(bnum: integer);
function MoveAmination(bnum: integer): boolean;

function SelectShowStatus(bnum: integer): boolean;
function SelectAim(bnum, step: integer): boolean;
function SelectRange(bnum, AttAreaType, step, range: integer): boolean;
function SelectDirector(bnum, AttAreaType, step, range: integer): boolean;
function SelectCross(bnum, AttAreaType, step, range: integer): boolean;
function SelectFar(bnum, mnum, level: integer): boolean;

//procedure SeekPath(x, y, step: integer);
procedure SeekPath2(x, y, step, myteam, mode: integer; bnum: integer = -1);
procedure CalCanSelect(bnum, mode, step: integer);
procedure ModifyRange(bnum, mnum: integer; var step, range: integer);
procedure Attack(bnum: integer);
procedure AttackAction(bnum, i, mnum, level: integer); overload;
procedure AttackAction(bnum, mnum, level: integer); overload;
procedure ShowMagicName(mnum: integer; str: WideString = '');
function SelectMagic(rnum: integer): integer;
procedure SetAminationPosition(mode, step, range: integer; aimMode: integer = 0); overload;
procedure SetAminationPosition(Bx, By, Ax, Ay, mode, step, range: integer; aimMode: integer = 0); overload;
procedure PlayMagicAmination(bnum, enum: integer; aimMode: integer = 0; mode: integer = 0);
procedure CalHurtRole(bnum, mnum, level: integer; mode: integer = 0);
function CalHurtValue(bnum1, bnum2, mnum, level: integer; mode: integer = 0): integer;
function CalHurtValue2(bnum1, bnum2, mnum, level: integer; mode: integer = 0): integer;
procedure SelectColor(mode: integer; var color1, color2: uint32; var formatstr: string);
procedure ShowHurtValue(mode: integer; team: integer = 0; fstr: string = '');
procedure ShowStringOnBrole(str: WideString; bnum, mode: integer; up: integer = 1);
procedure CalPoiHurtLife;
procedure ClearDeadRolePic;
procedure Wait(bnum: integer);
procedure RestoreRoleStatus;
procedure AddExp;
procedure CheckLevelUp;
procedure LevelUp(bnum: integer; rnum: integer = -1);
procedure CheckBook;
function CalRNum(team: integer): integer;
procedure BattleMenuItem(bnum: integer);
procedure UsePoison(bnum: integer);
procedure PlayActionAmination(bnum, mode: integer);
procedure Medcine(bnum: integer);
procedure MedPoison(bnum: integer);
procedure UseHiddenWeapon(bnum, inum: integer);
procedure Rest(bnum: integer);

procedure AutoBattle(bnum: integer);
function AutoUseItem(bnum, list: integer; test: integer = 0): boolean;

procedure AutoBattle2(bnum: integer);
procedure TryMoveAttack(var Mx1, My1, Ax1, Ay1, tempmaxhurt: integer; bnum, mnum, level: integer);
procedure NearestMove(var Mx1, My1: integer; bnum: integer);
procedure FarthestMove(var Mx1, My1: integer; bnum: integer);
procedure NearestMoveByPro(var Mx1, My1, Ax1, Ay1: integer;
  bnum, TeamMate, KeepDis, Prolist, MaxMinPro, mode: integer);
function ProbabilityByValue(cur, m, mode: integer; var n: integer): boolean;
procedure TryAttack(var Ax1, Ay1, magicid, cmlevel: integer; Mx, My, bnum: integer);

procedure TryMoveCure(var Mx1, My1, Ax1, Ay1: integer; bnum: integer);
procedure CureAction(bnum: integer);
procedure RoundOver; overload;
procedure RoundOver(bnum: integer); overload;
function SelectAutoMode: boolean;
procedure Auto(bnum: integer);
procedure SetEnemyAttribute;
function IFinbattle(num: integer): integer;
function UseSpecialAbility(bnum, mnum, level: integer): boolean;
procedure AutoBattle3(bnum: integer);
function SpecialAttack(bnum: integer): boolean;
function GetMagicWithSA2(SANum: smallint): smallint;
procedure CheckAttackAttachment(bnum, mnum, level: integer);
procedure CheckDefenceAttachment(bnum, mnum, level: integer);
function CanSelectAim(bnum, aimbnum, mnum, aimMode: integer): boolean;


type
{$M+}
  //主动类特技
  TSpecialAbility = class
  published
    procedure SA_0(bnum, mnum, level: integer);
    procedure SA_1(bnum, mnum, level: integer);
    procedure SA_2(bnum, mnum, level: integer);
    procedure SA_3(bnum, mnum, level: integer);
    procedure SA_4(bnum, mnum, level: integer);
    procedure SA_5(bnum, mnum, level: integer);
    procedure SA_6(bnum, mnum, level: integer);
    procedure SA_7(bnum, mnum, level: integer);
    procedure SA_8(bnum, mnum, level: integer);
    procedure SA_9(bnum, mnum, level: integer);
    procedure SA_10(bnum, mnum, level: integer);
    procedure SA_11(bnum, mnum, level: integer);
    procedure SA_12(bnum, mnum, level: integer);
    procedure SA_13(bnum, mnum, level: integer);
    procedure SA_14(bnum, mnum, level: integer);
    procedure SA_15(bnum, mnum, level: integer);
    procedure SA_16(bnum, mnum, level: integer);
    procedure SA_17(bnum, mnum, level: integer);
    procedure SA_18(bnum, mnum, level: integer);
    procedure SA_19(bnum, mnum, level: integer);
    procedure SA_20(bnum, mnum, level: integer);
    procedure SA_21(bnum, mnum, level: integer);
    procedure SA_22(bnum, mnum, level: integer);
    procedure SA_23(bnum, mnum, level: integer);
    procedure SA_24(bnum, mnum, level: integer);
    procedure SA_25(bnum, mnum, level: integer);
    procedure SA_26(bnum, mnum, level: integer);
    procedure SA_27(bnum, mnum, level: integer);
    procedure SA_28(bnum, mnum, level: integer);
    procedure SA_29(bnum, mnum, level: integer);
    procedure SA_30(bnum, mnum, level: integer);
    procedure SA_31(bnum, mnum, level: integer);
    procedure SA_32(bnum, mnum, level: integer);
    procedure SA_33(bnum, mnum, level: integer);
    procedure SA_34(bnum, mnum, level: integer);
    procedure SA_35(bnum, mnum, level: integer);
    procedure SA_36(bnum, mnum, level: integer);
    procedure SA_37(bnum, mnum, level: integer);
  end;

{$M-}

{$M+}
  //被动类特技
  TSpecialAbility2 = class
  published
    procedure SA2_0(bnum, mnum, mnum2, level: integer);
    procedure SA2_1(bnum, mnum, mnum2, level: integer);
    procedure SA2_2(bnum, mnum, mnum2, level: integer);
    procedure SA2_3(bnum, mnum, mnum2, level: integer);
    procedure SA2_4(bnum, mnum, mnum2, level: integer);
    procedure SA2_5(bnum, mnum, mnum2, level: integer);
    procedure SA2_6(bnum, mnum, mnum2, level: integer);
    procedure SA2_7(bnum, mnum, mnum2, level: integer);
    procedure SA2_8(bnum, mnum, mnum2, level: integer);
    procedure SA2_9(bnum, mnum, mnum2, level: integer);
    procedure SA2_10(bnum, mnum, mnum2, level: integer);
    procedure SA2_11(bnum, mnum, mnum2, level: integer);
    procedure SA2_100(bnum, mnum, mnum2, level: integer);
    procedure SA2_101(bnum, mnum, mnum2, level: integer);
  end;

{$M-}

//特技相关子程
procedure ModifyState(bnum, statenum: integer; MaxValue, maxround: smallint);
procedure GiveMeLife(bnum, mnum, level, Si: integer);
procedure ambush(bnum, mnum, level, Si: integer);


implementation

uses
  kys_script,
  kys_event,
  kys_engine,
  kys_draw;


//Battle.
//战斗, 返回值为是否胜利

function Battle(battlenum, getexp: integer; forceSingle: integer = 0): boolean;
var
  i, j, k, SelectTeamList, x, y, num, prewhere, i1, i2, dis, mindis: integer;
  //path: string;
  str: WideString;
  autoselect: boolean;
  //temp, temp2: PSDL_Surface;
  //LoadThread: PSDL_Thread;
  //dest: TSDL_Rect;
begin
  Bstatus := 0;
  BattleRound := 1;
  SkipTalk := 0;
  CurrentBattle := battlenum;
  FillChar(Brole[0], sizeof(TBattleRole) * length(Brole), 0);
  autoselect := InitialBField;

  Redraw;
  TransBlackScreen;
  if (battlenum <= high(BattleNames)) then
    str := BattleNames[battlenum]
  else
    str := pWideChar(@warsta.Name[0]);
  DrawTextWithRect(puint16(str), CENTER_X - DrawLength(str) * 5 - 24, CENTER_Y - 150, 0,
    ColColor($14), ColColor($16));
  UpdateAllScreen;

  if autoselect then
  begin
    //如果未发现自动战斗设定, 则选择人物
    SelectTeamList := SelectTeamMembers(forceSingle);
    for i := 0 to length(warsta.TeamMate) - 1 do
    begin
      x := warsta.TeamX[i];
      y := warsta.TeamY[i];
      if SelectTeamList and (1 shl i) > 0 then
      begin
        InitialBRole(BRoleAmount, TeamList[i], 0, x, y);
        BRoleAmount := BRoleAmount + 1;
      end;
    end;
    for i := 0 to length(warsta.TeamMate) - 1 do
    begin
      x := warsta.TeamX[i];
      y := warsta.TeamY[i] + 1;
      if (warsta.TeamMate[i] > 0) and (instruct_16(warsta.TeamMate[i], 1, 0) = 0) then
      begin
        InitialBRole(BRoleAmount, warsta.TeamMate[i], 0, x, y);
        BRoleAmount := BRoleAmount + 1;
      end;
    end;
  end;

  if MODVersion = 13 then
  begin
    //设定敌方角色的状态, 珍珑之战除外
    if Currentbattle <> 178 then
      SetEnemyAttribute;
    //欧阳锋洪七公雪山之战
    if (Currentbattle = 159) or (Currentbattle = 292) then
    begin
      Rrole[243].CurrentHP := 999;
      Rrole[243].CurrentMP := 10;
      Rrole[243].Movestep := 0;
      Rrole[244].CurrentHP := 999;
      Rrole[244].CurrentMP := 10;
      Rrole[244].Movestep := 0;
    end;
  end;

  //调整人物的方向, 面向距离最短的敌人
  for i1 := 0 to BRoleAmount - 1 do
  begin
    mindis := 128;
    for i2 := 0 to BRoleAmount - 1 do
    begin
      if Brole[i1].Team <> Brole[i2].Team then
      begin
        dis := CalBRoleDistance(i1, i2);
        if dis < mindis then
        begin
          Brole[i1].Face := CalFace(i1, i2);
          mindis := dis;
        end;
      end;
    end;
  end;

  //Setlength(AutoMode, BRoleAmount);
  for i := 0 to BRoleAmount - 1 do
  begin
    if Brole[i].Team = 0 then
      Brole[i].AutoMode := 1
    else
      Brole[i].AutoMode := 0;
    //战场状态和情侣加成清空
    for j := 0 to High(Brole[i].loverlevel) do
      Brole[i].loverlevel[j] := 0;
    for k := 0 to High(Brole[i].StateLevel) do
      Brole[i].StateLevel[k] := 0;

  end;

  TurnBlack;
  prewhere := where;
  Where := 2;
  InitialBFieldImage; //初始化场景
  StopMP3;
  PlayMP3(warsta.MusicNum, -1);
  blackscreen := 0;

  Bx := Brole[0].X;
  By := Brole[0].Y;
  Redraw;
  TransBlackScreen;
  if (battlenum <= high(BattleNames)) then
    str := BattleNames[battlenum]
  else
    str := pWideChar(@warsta.Name[0]);
  DrawTextWithRect(puint16(str), CENTER_X - DrawLength(str) * 5 - 24, CENTER_Y - 150, 0,
    ColColor($14), ColColor($16));
  //DrawTitlePic(8, CENTER_X - 30, TitlePosition.y + 20);
  UpdateAllScreen;

  LoadBattleTiles;

  BattleMainControl;

  RestoreRoleStatus;

  //if (bstatus = 1) or ((bstatus = 2) and (getexp <> 0)) then
  if bstatus = 1 then
  begin
    AddExp;
    CheckLevelUp;
    CheckBook;
  end;

  Redraw;
  UpdateAllScreen;

  if Rscence[CurScence].EntranceMusic >= 0 then
  begin
    StopMP3;
    PlayMP3(Rscence[CurScence].EntranceMusic, -1);
  end;

  FreeBattleTiles;

  Where := prewhere;
  if bstatus = 1 then
    Result := True
  else
    Result := False;
end;

procedure LoadBattleTiles();
var
  i, j, k, num, headnum, actionnum, degree: integer;
  path: string;
  temp: PSDL_Surface;
  timer1, timer2: uint32;
  str: WideString;
  fightarray: array of integer;
begin
  LoadingBattleTiles := True;
  RecordFreshScreen(CENTER_X - 140, CENTER_Y, 300, 25);

  if PNG_TILE > 0 then
  begin
    //setlength(FPNGIndex, BRoleAmount);
    //setlength(FPNGTile, BRoleAmount);
    for i := 0 to BRoleAmount - 1 do
    begin
      actionnum := Rrole[Brole[i].rnum].ActionNum;
      if Brole[i].rnum = 0 then
        actionnum := 0;
      if FPNGIndex[actionnum].Loaded = 0 then
      begin
        LoadPNGTiles(formatfloat('resource/fight/fight000', actionnum), FPNGIndex[actionnum].PNGIndexArray,
          1, @FPNGIndex[actionnum].FightFrame[0]);
        FPNGIndex[actionnum].Loaded := 1;
      end;
      //计算人物静止时的贴图编号
      num := 0;
      for j := 0 to 4 do
      begin
        if FPNGIndex[actionnum].FightFrame[j] > 0 then
        begin
          for k := 0 to 3 do
          begin
            Brole[i].StaticPic[k] := num + FPNGIndex[actionnum].FightFrame[j] * k;
          end;
          break;
        end;
        //num := num + FightFrame[i, j];
      end;
      LoadFreshScreen(CENTER_X - 140, CENTER_Y);
      str := UTF8Decode('載入戰鬥人物貼圖 ') + UTF8Decode(format('%2d/%2d', [i + 1, BRoleAmount]));
      DrawTextWithRect(@str[1], CENTER_X - 120, CENTER_Y, 0, ColColor($64), ColColor($66), 30);
      UpdateAllScreen;
      //DrawRectangleWithoutFrame(screen, CENTER_X- 100+i*10, 30, 10, 10, $FFFFFFFF, 50);
      //SDL_UpdateRect2(screen, CENTER_X- 100+i*10, 30, 10, 10);
    end;
  end;
  LoadingBattleTiles := False;
  FreeFreshScreen;
end;

procedure FreeBattleTiles();
var
  i, j: integer;
begin
  if PNG_TILE > 0 then
  begin
    {for i := 0 to BRoleAmount - 1 do
    begin
      for j := Low(FPNGTile[i]) to High(FPNGTile[i]) do
      begin
        if FPNGTile[i][j] <> nil then
          SDL_FreeSurface(FPNGTile[i][j]);
      end;
      for j := Low(FPNGIndex[i]) to High(FPNGIndex[i]) do
      begin
        FPNGIndex[i][j].CurPointer := nil;
      end;
      setlength(FPNGIndex[i], 0);
      setlength(FPNGTile[i], 0);
    end;
    setlength(FPNGIndex, 0);
    setlength(FPNGTile, 0);}
  end;
end;

//Structure of Bfield arrays:
//0: Ground; 1: Building; 2: Roles(Rrnum);

//Structure of Brole arrays:
//the 1st pointer is "Battle Num";
//The 2nd: 0: rnum, 1: Friend or enemy, 2: y, 3: x, 4: Face, 5: Dead or alive,
//         7: Acted, 8: Pic Num, 9: The number, 10, 11, 12: Auto, 13: Exp gotten.
//初始化战场

function InitialBField: boolean;
var
  sta, GRP, IDX, offset, i, i1, i2, x, y, fieldnum: integer;
begin
  {i := sizeof(warsta);
  sta := FileOpen(AppPath + 'resource/war.sta', fmopenread);
  offset := currentbattle * i;
  FileSeek(sta, offset, 0);
  FileRead(sta, warsta, i);
  FileClose(sta);}
  warsta := WarStaList[CurrentBattle];
  fieldnum := warsta.BFieldNum;
  {if fieldnum = 0 then
    offset := 0
  else
  begin
    idx := FileOpen(AppPath + 'resource/warfld.idx', fmopenread);
    FileSeek(idx, (fieldnum - 1) * 4, 0);
    FileRead(idx, offset, 4);
    FileClose(idx);
  end;
  grp := FileOpen(AppPath + 'resource/warfld.grp', fmopenread);
  FileSeek(grp, offset, 0);
  FileRead(grp, BField[0, 0, 0], 2 * 64 * 64 * 2);
  FileClose(grp);}
  move(WARFLD.GRP[WARFLD.IDX[fieldnum]], Bfield[0, 0, 0], 2 * 64 * 64 * 2);
  for i1 := 0 to 63 do
    for i2 := 0 to 63 do
      BField[2, i1, i2] := -1;
  BRoleAmount := 0;
  Result := True;

  for i := 0 to length(Brole) - 1 do
  begin
    Brole[i].rnum := -1;
    Brole[i].Dead := 1;
    Brole[i].Y := -1;
    Brole[i].X := -1;
  end;

  //我方自动参战数据
  for i := 0 to length(warsta.AutoTeamMate) - 1 do
  begin
    x := warsta.TeamX[i];
    y := warsta.TeamY[i];
    if warsta.AutoTeamMate[i] >= 0 then
    begin
      InitialBRole(BRoleAmount, warsta.AutoTeamMate[i], 0, x, y);
      BRoleAmount := BRoleAmount + 1;
    end;
  end;
  //如没有自动参战人物, 返回假, 激活选择人物
  if BRoleAmount > 0 then
    Result := False;
  for i := 0 to length(warsta.Enemy) - 1 do
  begin
    x := warsta.EnemyX[i];
    y := warsta.EnemyY[i];
    if warsta.Enemy[i] >= 0 then
    begin
      InitialBRole(BRoleAmount, warsta.Enemy[i], 1, x, y);
      BRoleAmount := BRoleAmount + 1;
    end;
  end;

end;

procedure InitialBRole(i, rnum, team, x, y: integer);
begin
  if i in [low(Brole)..high(Brole)] then
  begin
    Brole[i].rnum := rnum;
    Brole[i].Team := team;
    Brole[i].Y := y;
    Brole[i].X := x;
    if Team = 0 then
      Brole[i].Face := 2;
    if Team <> 0 then
      Brole[i].Face := 1;
    Brole[i].Dead := 0;
    Brole[i].Step := 0;
    Brole[i].Acted := 0;
    Brole[i].ExpGot := 0;
    Brole[i].Auto := 0;
    Brole[i].RealSpeed := 0;
    Brole[i].RealProgress := random(7000);
  end;
end;


//选择人物, 返回值为整型, 按bit表示人物是否参战

function SelectTeamMembers(forceSingle: integer = 0): integer;
var
  i, menu, max, menup, xm, ym, x, y, h, forall: integer;
  menuString: array[0..8] of WideString;
  str, str1: WideString;
  //显示选择参战人物选单
  procedure ShowMultiMenu();
  var
    i: integer;
  begin
    LoadFreshScreen(x, y);
    //Drawtextwithrect(@str[1],x + 5, y-35, 200 , colcolor($23), colcolor($21));
    //DrawRectangle(x + 30, CENTER_Y - 90, 150, max * 22 + 28, 0, ColColor(255), 30);
    for i := 0 to max do
    begin
      if (i = 0) or (i = max) then
        DrawTextFrame(x + 44, y + h * i, 8)
      else
        DrawTextFrame(x + 14, y + h * i, 14);
      if i = menu then
      begin
        DrawShadowText(@menuString[i][1], x + 33, y + 3 + h * i, ColColor($64), ColColor($66));
        if ((Result and (1 shl (i - 1))) > 0) and (i > 0) and (i < max) then
          DrawShadowText(@str1[1], x + 133, y + 3 + h * i, ColColor($64), ColColor($66));
      end
      else
      begin
        DrawShadowText(@menuString[i][1], x + 33, y + 3 + h * i, 0, $202020);
        if ((Result and (1 shl (i - 1))) > 0) and (i > 0) and (i < max) then
          DrawShadowText(@str1[1], x + 133, y + 3 + h * i, 0, $202020);
      end;
    end;
    UpdateAllScreen;
  end;

begin
  //redraw;
  //SDL_UpdateRect2(screen, 0, 0, CENTER_X*2, CENTER_Y*2);
  x := CENTER_X - 110;
  y := CENTER_Y - 90;
  h := 28;
  str := ('選擇參與戰鬥之人物');
  str1 := ('參戰');
  RecordFreshScreen(x, y, 220, 250);
  Result := 0;
  max := 1;
  menu := 0;
  //setlength(menustring, 7);
  for i := 0 to 5 do
  begin
    if Teamlist[i] >= 0 then
    begin
      menuString[i + 1] := pWideChar(@Rrole[Teamlist[i]].Name);
      max := max + 1;
    end;
  end;
  menuString[0] := ('   全員參戰');
  if forceSingle <> 0 then
    menuString[0] := ('   限選一人');
  menuString[max] := ('   開始戰鬥');
  ShowMultiMenu;
  ////SDL_EnableKeyRepeat(50, 30);
  forall := round(power(2, (max - 1)) - 1);
  while (SDL_WaitEvent(@event) >= 0) do
  begin
    CheckBasicEvent;
    case event.type_ of
      SDL_KEYUP:
      begin
        if ((event.key.keysym.sym = SDLK_RETURN) or (event.key.keysym.sym = SDLK_SPACE)) and (menu <> max) then
        begin
          //选中人物则反转对应bit
          if forceSingle = 0 then
          begin
            if menu > 0 then
            begin
              Result := Result xor (1 shl (menu - 1));
            end
            else
            begin
              if Result < forall then
                Result := forall
              else
                Result := 0;
            end;
          end
          else
          begin
            if menu > 0 then
              Result := 1 shl (menu - 1);
          end;
          ShowMultiMenu;
        end;
        if ((event.key.keysym.sym = SDLK_RETURN) or (event.key.keysym.sym = SDLK_SPACE)) and (menu = max) then
        begin
          if Result <> 0 then
            break;
        end;
      end;
      SDL_KEYDOWN:
      begin
        if (event.key.keysym.sym = SDLK_UP) then
        begin
          menu := menu - 1;
          if menu < 0 then
            menu := max;
          ShowMultiMenu;
        end;
        if (event.key.keysym.sym = SDLK_DOWN) then
        begin
          menu := menu + 1;
          if menu > max then
            menu := 0;
          ShowMultiMenu;
        end;
      end;
      SDL_MOUSEBUTTONUP:
        if MouseInRegion(x, y, 150, (max + 1) * h) then
        begin
          if (event.button.button = SDL_BUTTON_LEFT) and (menu <> max) then
          begin
            //选中人物则反转对应bit
            if forceSingle = 0 then
            begin
              if menu > 0 then
              begin
                Result := Result xor (1 shl (menu - 1));
              end
              else
              begin
                if Result < forall then
                  Result := forall
                else
                  Result := 0;
              end;
            end
            else
            begin
              if menu > 0 then
                Result := 1 shl (menu - 1);
            end;
            ShowMultiMenu;
          end;
          if (event.button.button = SDL_BUTTON_LEFT) and (menu = max) then
          begin
            if Result <> 0 then
              break;
          end;
        end;
      SDL_MOUSEMOTION:
      begin
        if MouseInRegion(x, y, 150, (max + 1) * h, xm, ym) then
        begin
          menup := menu;
          menu := (ym - 150) div h;
          if menup <> menu then
            ShowMultiMenu;
        end;
      end;
    end;
  end;

  FreeFreshScreen;
end;


//设定敌方角色的状态

procedure SetEnemyAttribute;
var
  i, rnum: integer;
begin
  for i := 0 to 19 do
  begin
    rnum := warsta.enemy[i];
    if rnum >= 0 then
    begin
      //SetAttribute(enum, 71, rrole[enum].Repute , rrole[enum].RoundLeave , warsta.exp div 100);
      //331~878属于杂兵, 应该是忽略了后面的部分boss
      case MODVersion of
        13:
        begin
          Rrole[rnum] := Rrole0[rnum];
          if (rnum > 331) and (rnum <= 878) then
            SetAttribute(rnum, 71, Rrole[rnum].Repute, Rrole[rnum].RoundLeave, 60)
          else
            SetAttribute(rnum, 1, Rrole[rnum].Repute, Rrole[rnum].RoundLeave, 60);
        end;
        0:
        begin
          //Rrole[rnum] := Rrole0[rnum];
        end;
      end;
    end;
  end;
end;

//计算面对的方向

function CalFace(x1, y1, x2, y2: integer): integer; overload;
var
  d1, d2, dm: integer;
begin
  d1 := x2 - x1;
  d2 := y2 - y1;
  dm := abs(d1) - abs(d2);
  if (d1 <> 0) or (d2 <> 0) then
    if (dm >= 0) then
      if d1 < 0 then
        Result := 0
      else
        Result := 3
    else
    if d2 < 0 then
      Result := 2
    else
      Result := 1;
end;

function CalFace(bnum1, bnum2: integer): integer; overload;
begin
  Result := CalFace(Brole[bnum1].X, Brole[bnum1].Y, Brole[bnum2].X, Brole[bnum2].Y);
end;

function CalBroleDistance(bnum1, bnum2: integer): integer;
begin
  Result := abs(Brole[bnum1].X - Brole[bnum2].X) + abs(Brole[bnum1].Y - Brole[bnum2].Y);
end;

//战斗主控制

procedure BattleMainControl;
var
  i, j, neinum, neilevel, bnum, pnum, act: integer;
  k, m, n, si, t, x1, y1, curepoi: integer;
  tempBrole: TBattleRole;
  delaytime: integer;
begin
  delaytime := 7; //毫秒
  Bx := Brole[0].X;
  By := Brole[0].Y;
  //若开启进度条, 则初始化一个随机值
  if SEMIREAL = 1 then
  begin
    for i := 0 to BRoleAmount - 1 do
    begin
      Brole[i].RealProgress := random(7000);
    end;
  end;

  //情侣加成对话
  ClearDeadRolePic;
  for k := 0 to MAX_LOVER - 1 do
  begin
    m := IFinbattle(loverlist[k, 0]);
    n := IFinbattle(loverlist[k, 1]);
    if (m >= 0) and (n >= 0) then
    begin
      Bx := Brole[n].X;
      By := Brole[n].Y;
      Redraw;
      NewTalk(loverlist[k, 1], loverlist[k, 4], -2, 0, 0, 28515, 0);
      Bx := Brole[m].X;
      By := Brole[m].Y;
      Redraw;
      NewTalk(loverlist[k, 0], loverlist[k, 4] + 1, -2, 0, 0, 28515, 0);
      Brole[m].loverlevel[loverlist[k, 2]] := loverlist[k, 3];
      //替代受伤
      if loverlist[k, 2] = 6 then
        for i := 0 to BRoleAmount - 1 do
          if loverlist[k, 3] = Brole[i].rnum then
          begin
            Brole[m].loverlevel[loverlist[k, 2]] := i;
            break;
          end;
    end;
  end;

  //redraw;
  //战斗未分出胜负则继续
  while BStatus = 0 do
  begin
    //CalMoveAbility; //计算移动能力, 因此有些移动能力的状态可能会推迟生效

    if SEMIREAL = 0 then
      ReArrangeBRole; //排列角色顺序

    ClearDeadRolePic; //清除阵亡角色

    for i := 0 to BRoleAmount - 1 do
    begin
      if (SEMIREAL = 0) or (Brole[i].Acted = 1) then
      begin
        //for t := 0 to broleamount do Brole[t].ShowNumber := -1;
        //7号状态, 战神, 随机获得一种正面状态
        if Brole[i].StateLevel[7] > 0 then
        begin
          si := random(21);
          //0攻击,1防御,2轻功,4伤害,14乾坤,15灵精,11毒箭,
          if (si = 0) or (si = 1) or (si = 2) or (si = 4) or (si = 11) or (si = 14) or (si = 15) then
          begin
            Brole[i].StateLevel[si] := Brole[i].StateLevel[7];
            Brole[i].StateRound[si] := 3;
          end
          //7战神
          else if si = 7 then
            Brole[i].StateRound[7] := Brole[i].StateRound[7] + 1
          //5回血,6回内,20回体
          else if (si = 5) or (si = 6) or (si = 20) then
          begin
            Brole[i].StateLevel[si] := Brole[i].StateLevel[7] div 2;
            Brole[i].StateRound[si] := 3;
          end
          else
            //3移动,16奇门,17博采,18聆音,19青翼,8风雷,9孤注,10倾国,12剑芒,13连击
            //这里博采的概率是1%, 有可能是设置错误
          begin
            Brole[i].StateLevel[si] := 1;
            Brole[i].StateRound[si] := 3;
          end;
        end;

        //24号状态, 悲歌, 随机获得一种奖励（0攻、1防、3移、4加血1000、5加内1000、2加体50）
        if Brole[i].StateLevel[24] > 0 then
        begin
          si := random(6);
          //0攻击,1防御
          if (si = 0) or (si = 1) then
          begin
            if Brole[i].StateLevel[si] <= 0 then
            begin
              Brole[i].StateLevel[si] := 20;
              Brole[i].StateRound[si] := 1;
            end
            else
              Brole[i].StateRound[si] := Brole[i].StateRound[si] + 1;
          end
          else if si = 3 then
          begin //3移动
            if Brole[i].StateLevel[si] <= 0 then
            begin
              Brole[i].StateLevel[si] := 3;
              Brole[i].StateRound[si] := 1;
            end
            else
              Brole[i].StateRound[si] := Brole[i].StateRound[si] + 1;
          end
          else if si = 2 then
          begin //2加体50
            Rrole[Brole[i].rnum].PhyPower := Rrole[Brole[i].rnum].PhyPower + 50;
            if Rrole[Brole[i].rnum].PhyPower > MAX_PHYSICAL_POWER then
              Rrole[Brole[i].rnum].PhyPower := MAX_PHYSICAL_POWER;
          end
          else if si = 4 then
          begin //4加血1000
            Rrole[Brole[i].rnum].CurrentHP := Rrole[Brole[i].rnum].CurrentHP + 1000;
            if Rrole[Brole[i].rnum].CurrentHP > Rrole[Brole[i].rnum].MaxHP then
              Rrole[Brole[i].rnum].CurrentHP := Rrole[Brole[i].rnum].MaxHP;
          end
          else if si = 5 then
          begin //5加内1000
            Rrole[Brole[i].rnum].CurrentMP := Rrole[Brole[i].rnum].CurrentMP + 1000;
            if Rrole[Brole[i].rnum].CurrentMP > Rrole[Brole[i].rnum].MaxMP then
              Rrole[Brole[i].rnum].CurrentMP := Rrole[Brole[i].rnum].MaxMP;
          end;
        end;
      end;
      //是否已行动, 显示数字清空
      Brole[i].Acted := 0;
      Brole[i].ShowNumber := 0;
      //移动过的步数, 目前的用处是调息的判断
      Brole[i].Moved := 0;
    end;

    if SEMIREAL = 1 then
    begin
      Redraw;
      act := 0;
      while SDL_PollEvent(@event) >= 0 do
      begin
        for i := 0 to BRoleAmount - 1 do
        begin
          if Brole[i].Dead = 0 then
          begin
            Brole[i].RealProgress := Brole[i].RealProgress + Brole[i].RealSpeed + delaytime;
            if Brole[i].RealProgress >= 10000 then
            begin
              Brole[i].RealProgress := Brole[i].RealProgress - 10000;
              act := 1;
              break;
            end;
          end;
        end;
        if act = 1 then
          break;
        Redraw;
        UpdateAllScreen;
        SDL_Delay(delaytime);
        CheckBasicEvent;
      end;
    end;

    if SEMIREAL = 0 then
      i := 0;

    while (i < BRoleAmount) and (Bstatus = 0) do
    begin
      //当前人物位置作为屏幕中心
      Bx := Brole[i].X;
      By := Brole[i].Y;
      //showstringonbrole('123456677变态啦', i, 6);
      if Brole[i].Dead = 0 then
      begin
        Redraw;
        UpdateAllScreen;
      end;
      CheckBasicEvent;
      //战场序号保存至变量28005
      x50[28005] := i;

      //混亂和控制狀態, 臨時修改其陣營
      Brole[i].PreTeam := Brole[i].Team;
      if Brole[i].StateLevel[28] < 0 then
      begin
        Brole[i].Team := random(99);
      end;
      if Brole[i].StateLevel[27] < 0 then
      begin
        Brole[i].Team := -Brole[i].StateLevel[27] - 1;
      end;
      if Brole[i].Moved = 0 then
        Brole[i].Step := CalBroleMoveAbility(i);
      //26号状态定身
      //未阵亡, 未被定身, 进入战斗
      if (Brole[i].Dead = 0) and (Brole[i].StateLevel[26] >= 0) then
      begin
        //我方且非自动战斗, 显示选单
        if (Brole[i].Team = 0) and (Brole[i].Auto = 0) then
        begin
          if (Brole[i].Acted = 0) then
            tempBrole := Brole[i]; //记录一个临时人物信息, 用于恢复位置
          case BattleMenu(i) of
            0: MoveRole(i);
            1: Attack(i);
            2: UsePoison(i);
            3: MedPoison(i);
            4: Medcine(i);
            5: BattleMenuItem(i);
            6: Wait(i);
            7: SelectShowStatus(i);
            8, 9: Rest(i);
            10: Auto(i);
            else
            begin
              BField[2, tempBrole.X, tempBrole.Y] := i;
              BField[2, Brole[i].X, Brole[i].Y] := -1;
              Brole[i] := tempBrole;
            end;
          end;
        end
        else
        begin
          AutoBattle3(i);
          Brole[i].Acted := 1;
        end;
      end
      else
        Brole[i].Acted := 1;

      ClearDeadRolePic;
      Brole[i].Pic := 0;
      if Brole[i].Dead = 0 then
      begin
        Redraw;
        UpdateAllScreen;
      end;
      //使用战斗人物的空间保存人物的原阵营
      //如果用局部变量可能等待修改人物战场编号时会产生混乱
      //恢复混乱的人的阵营
      if Brole[i].StateLevel[28] < 0 then
      begin
        Brole[i].Team := Brole[i].PreTeam;
      end;
      //检测是否有一方全灭
      Bstatus := BattleStatus;
      //恢复被控制的人的陣營
      if Brole[i].StateLevel[27] < 0 then
      begin
        Brole[i].Team := Brole[i].PreTeam;
      end;

      if (Brole[i].Acted = 1) then
      begin
        //内功
        if Brole[i].Dead = 0 then
          for j := 0 to 3 do
          begin
            neinum := Rrole[Brole[i].rnum].neigong[j];
            if neinum <= 0 then
              break;
            neilevel := Rrole[Brole[i].rnum].NGLevel[j] div 100 + 1;

            if Rmagic[neinum].addmp[1] > 0 then
            begin
              //星宿毒功, 周围5*5格人中毒
              for x1 := -2 to 2 do
                for y1 := -2 to 2 do
                begin
                  if (Brole[i].X + x1 < 0) or (Brole[i].X + x1 > 63) or (Brole[i].Y + y1 < 0) or
                    (Brole[i].Y + y1 > 63) then
                    continue;
                  if BField[2, Brole[i].X + x1, Brole[i].Y + y1] >= 0 then
                  begin
                    bnum := BField[2, Brole[i].X + x1, Brole[i].Y + y1];
                    if Brole[bnum].Team <> Brole[i].Team then
                    begin
                      pnum := Rmagic[neinum].addmp[0] + (Rmagic[neinum].addmp[1] -
                        Rmagic[neinum].addmp[0]) * neilevel div 10;
                      if pnum > Rrole[Brole[bnum].rnum].DefPoi then
                      begin
                        Rrole[Brole[bnum].rnum].Poison := Rrole[Brole[bnum].rnum].Poison + pnum;
                        ShowStringOnBrole(pWideChar(@Rmagic[neinum].Name) + UTF8Decode('·群毒'), i, 2);
                        //if Rrole[brole[bnum].rnum].Poison>100 then Rrole[brole[bnum].rnum].Poison:=100;
                      end;
                    end;
                  end;
                end;
            end;

            //化毒, 将中毒转化为内力
            if Rmagic[neinum].AttDistance[5] > 0 then
            begin
              curepoi := Rmagic[neinum].AttDistance[5] * neilevel;
              if curepoi > Rrole[Brole[i].rnum].Poison then
                curepoi := Rrole[Brole[i].rnum].Poison;
              if curepoi > 0 then
                ShowStringOnBrole(pWideChar(@Rmagic[neinum].Name) + UTF8Decode('·化毒'), i, 4);
              Rrole[Brole[i].rnum].Poison := Rrole[Brole[i].rnum].Poison - curepoi;
              Rrole[Brole[i].rnum].CurrentMP := Rrole[Brole[i].rnum].CurrentMP + curepoi * neilevel;
              if Rrole[Brole[i].rnum].CurrentMP > Rrole[Brole[i].rnum].MaxMP then
                Rrole[Brole[i].rnum].CurrentMP := Rrole[Brole[i].rnum].MaxMP;
            end;

            //葵花宝典, 每回合随机获得加轻、加移、闪避状态
            if Rmagic[neinum].AddMP[2] = 1 then
            begin
              if random(100) > 50 then
              begin
                Brole[i].StateLevel[2] := 50;
                Brole[i].StateRound[2] := 3;
                ShowStringOnBrole(pWideChar(@Rmagic[neinum].Name) + UTF8Decode('·身輕'), i, 3);
              end;
              if random(100) > 50 then
              begin
                Brole[i].StateLevel[3] := 5;
                Brole[i].StateRound[3] := 3;
                ShowStringOnBrole(pWideChar(@Rmagic[neinum].Name) + UTF8Decode('·速行'), i, 3);
              end;
              if random(100) > 50 then
              begin
                Brole[i].StateLevel[16] := 50;
                Brole[i].StateRound[16] := 3;
                ShowStringOnBrole(pWideChar(@Rmagic[neinum].Name) + UTF8Decode('·閃避'), i, 3);
              end;
            end;

            //九阴真经, 每回合随机获得加攻、加防状态, 减受伤
            if Rmagic[neinum].AddMP[2] = 2 then
            begin
              if random(100) > 50 then
              begin
                Brole[i].StateLevel[0] := 10 * neilevel;
                Brole[i].StateRound[0] := 3;
                ShowStringOnBrole(pWideChar(@Rmagic[neinum].Name) + UTF8Decode('·威力'), i, 3);
              end;
              if random(100) > 50 then
              begin
                Brole[i].StateLevel[1] := 10 * neilevel;
                Brole[i].StateRound[1] := 3;
                ShowStringOnBrole(pWideChar(@Rmagic[neinum].Name) + UTF8Decode('·剛體'), i, 3);
              end;
              Rrole[Brole[i].rnum].Hurt := Rrole[Brole[i].rnum].Hurt - 10 * neilevel;
              if Rrole[Brole[i].rnum].Hurt < 0 then
                Rrole[Brole[i].rnum].Hurt := 0;
            end;

            //北冥真气, 周围5*5格人减内, 自己回内
            if Rmagic[neinum].addmp[2] = 3 then
            begin
              for x1 := -2 to 2 do
                for y1 := -2 to 2 do
                begin
                  if (Brole[i].X + x1 < 0) or (Brole[i].X + x1 > 63) or (Brole[i].Y + y1 < 0) or
                    (Brole[i].Y + y1 > 63) then
                    continue;
                  if BField[2, Brole[i].X + x1, Brole[i].Y + y1] >= 0 then
                  begin
                    bnum := BField[2, Brole[i].X + x1, Brole[i].Y + y1];
                    if Brole[bnum].Team <> Brole[i].Team then
                    begin
                      pnum := 50 * neilevel;
                      if pnum > Rrole[Brole[bnum].rnum].CurrentMP then
                        pnum := Rrole[Brole[bnum].rnum].CurrentMP;
                      Rrole[Brole[bnum].rnum].CurrentMP := Rrole[Brole[bnum].rnum].CurrentMP - pnum;
                      Rrole[Brole[i].rnum].currentMP := Rrole[Brole[i].rnum].currentMP + pnum;
                      if Rrole[Brole[i].rnum].currentMP > Rrole[Brole[i].rnum].maxMP then
                        Rrole[Brole[i].rnum].currentMP := Rrole[Brole[i].rnum].maxMP;
                      ShowStringOnBrole(pWideChar(@Rmagic[neinum].Name) + UTF8Decode('·納氣'), i, 1);
                    end;
                  end;
                end;
            end;
          end;
        RoundOver(i);
        i := i + 1;
        if SEMIREAL = 1 then
          break;
      end;
    end;
    CalPoiHurtLife; //计算中毒损血
    x50[28101] := BRoleAmount;
    RoundOver;
  end;

end;

//判断某人是否出场

function IFinbattle(num: integer): integer;
var
  i, r: integer;
begin
  r := -1;
  if num >= 0 then
    for i := 0 to BRoleAmount - 1 do
    begin
      if (Brole[i].rnum = num) {and (Brole[i].Team = 0)} then
      begin
        r := i;
        break;
      end;
    end;
  Result := r;
end;

//按轻功重排人物(考虑装备)
//2号状态, 轻功有加成

procedure ReArrangeBRole;
var
  i, i1, i2, x, t, s1, s2: integer;
  temp: TBattleRole;

  function calTotalSpeed(bnum: integer): integer;
  var
    rnum: integer;
  begin
    rnum := Brole[bnum].rnum;
    Result := Rrole[rnum].Speed + Ritem[Rrole[rnum].Equip[0]].AddSpeed + Ritem[Rrole[rnum].Equip[1]].AddSpeed;
    Result := Result * (100 + Brole[bnum].StateLevel[2] + Brole[bnum].loverlevel[9]) div 100;
  end;

begin
  for i1 := 0 to BRoleAmount - 2 do
    for i2 := i1 + 1 to BRoleAmount - 1 do
    begin
      s1 := calTotalSpeed(i1);
      s2 := calTotalSpeed(i2);
      if s1 < s2 then
      begin
        temp := Brole[i1];
        Brole[i1] := Brole[i2];
        Brole[i2] := temp;
        //t := AutoMode[i1];
        //AutoMode[i1] := AutoMode[i2];
        //AutoMode[i2] := t;
      end;
    end;

  FillChar(BField[2, i1, i2], sizeof(BField[2]), -1);
  {for i1 := 0 to 63 do
    for i2 := 0 to 63 do
      Bfield[2, i1, i2] := -1;}

  for i := 0 to BRoleAmount - 1 do
  begin
    if Brole[i].Dead = 0 then
      BField[2, Brole[i].X, Brole[i].Y] := i
    else
      BField[2, Brole[i].X, Brole[i].Y] := -1;
  end;

end;

//计算可移动步数(考虑装备)

function CalBroleMoveAbility(bnum: integer): integer;
var
  rnum, addspeed, step: integer;
begin
  rnum := Brole[bnum].rnum;
  step := Rrole[rnum].Movestep;
  //step:=step+ritem[rrole[rnum].Equip[0]].AddMove;
  //step:=step+ritem[rrole[rnum].Equip[1]].AddMove;
  //step:= (Rrole[Brole[i].rnum].Level div 10 ) + Rrole[Brole[i].rnum].AddSpeed +2 +Rrole[Brole[i].rnum].Speed div 120;
  //if Rrole[Brole[i].rnum].AddSpeed >= 2 then step:=step+1;

  //if rrole[rnum].Equip[0] >= 0 then
  //  if ritem[rrole[rnum].Equip[0]].AddSpeed > 0 then
  //    step:=step+1;

  //if rrole[rnum].Equip[1] >= 0 then
  //  if ritem[rrole[rnum].Equip[1]].AddSpeed > 0 then
  //    step:=step+1;

  //addspeed := 0;
  //if rrole[rnum].Equip[0] >= 0 then addspeed := addspeed + ritem[rrole[rnum].Equip[0]].AddSpeed;
  //if rrole[rnum].Equip[1] >= 0 then addspeed := addspeed + ritem[rrole[rnum].Equip[1]].AddSpeed;
  //Brole[i].Step := Rrole[Brole[i].rnum].Speed div 30 +1 + addspeed;

  Result := step div 10;
  if Result > 15 then
    Result := 15;
  //情侣和状态增加移动能力
  Result := Result + Brole[bnum].StateLevel[3] + Brole[bnum].loverlevel[2] +
    Ritem[Rrole[rnum].Equip[1]].AddMove + Ritem[Rrole[rnum].Equip[0]].AddMove;

  if (SEMIREAL = 1) and (Result > 7) then
    Result := 7;

end;

procedure CalMoveAbility;
var
  i, rnum: integer;
begin
  for i := 0 to BRoleAmount - 1 do
  begin
    //rnum := Brole[i].rnum;
    //Brole[i].Step := CalBroleMoveAbility(i);
    if SEMIREAL = 1 then
    begin
      Brole[i].RealSpeed := trunc((Rrole[rnum].Speed) + 175) - Rrole[rnum].Hurt div 10 -
        Rrole[rnum].Poison div 30;
      Brole[i].RealSpeed := Brole[i].RealSpeed div 3;
      //if Brole[i].RealSpeed > 200 then
      //Brole[i].RealSpeed := 200 + (Brole[i].RealSpeed - 200) div 3;
    end;
  end;

end;

//0: Continue; 1: Victory; 2:Failed.
//检查是否有一方全部阵亡

function BattleStatus: integer;
var
  i, sum0, sum1: integer;
begin
  sum0 := 0;
  sum1 := 0;
  for i := 0 to BRoleAmount - 1 do
  begin
    if (Brole[i].Team = 0) and (Brole[i].Dead = 0) then
      sum0 := sum0 + 1;
    if (Brole[i].Team <> 0) and (Brole[i].Dead = 0) then
      sum1 := sum1 + 1;
  end;

  if (sum0 > 0) and (sum1 > 0) then
    Result := 0;
  if (sum0 >= 0) and (sum1 = 0) then
    Result := 1;
  if (sum0 = 0) and (sum1 > 0) then
    Result := 2;

end;

//战斗主选单, menustatus按bit保存可用项

function BattleMenu(bnum: integer): integer;
var
  i, p, MenuStatus, menu, max, rnum, menup, xm, ym, step, x, y, h, l: integer;
  realmenu: array[0..10] of integer;
  str: WideString;
  word: array[0..10] of WideString;
  num: array[0..9] of WideString;
  //显示战斗主选单
  procedure ShowBMenu(MenuStatus, menu, max: integer);
  var
    i, p: integer;
  begin
    LoadFreshScreen(x, y);
    //DrawRectangle(100, 50, 47, max * 22 + 28, 0, ColColor(255), 30);
    p := 0;
    for i := 0 to 10 do
    begin
      if (p = menu) and ((MenuStatus and (1 shl i) > 0)) then
      begin
        //DrawMPic(2110 + i, x + 5, y + h * p, SIMPLE);
        DrawTextFrame(x, y + h * p, 4);
        DrawShadowText(@word[i][1], x + 19, y + h * p + 3, ColColor($64), ColColor($66));
        p := p + 1;
      end
      else if (p <> menu) and ((MenuStatus and (1 shl i) > 0)) then
      begin
        //DrawMPic(2110 + i, x, y + h * p, SIMPLE, 0, 20);
        DrawTextFrame(x + 5, y + h * p, 4, 20);
        DrawShadowText(@word[i][1], x + 24, y + h * p + 3, 0, $202020);
        p := p + 1;
      end;
    end;
    //SDL_UpdateRect2(screen, 100, 50, 48, max * 22 + 29);
    UpdateAllScreen;
  end;

begin
  MenuStatus := $7E0;
  max := 5;
  //for i := 0 to 9 do
  word[0] := '移動';
  word[1] := '武學';
  word[2] := '用毒';
  word[3] := '解毒';
  word[4] := '醫療';
  word[5] := '物品';
  word[6] := '等待';
  word[7] := '狀態';
  word[8] := '調息';
  word[9] := '結束';
  word[10] := '自動';
  num[0] := '零';
  num[1] := '一';
  num[2] := '二';
  num[3] := '三';
  num[4] := '四';
  num[5] := '五';
  num[6] := '六';
  num[7] := '七';
  num[8] := '八';
  num[9] := '九';
  rnum := Brole[bnum].rnum;
  //移动是否可用
  if (Brole[bnum].Step > 0) {and (brole[bnum].acted = 0)} then
  begin
    MenuStatus := MenuStatus or 1;
    max := max + 1;
  end;
  //SDL_EnableKeyRepeat(20, 100);
  //can not attack when phisical<10
  //攻击是否可用
  if (Rrole[rnum].PhyPower >= 10) and (Rrole[rnum].Poison < 100) then
  begin
    p := 0;
    for i := 0 to 9 do
    begin
      if Rrole[rnum].Magic[i] > 0 then
      begin
        if (Rmagic[Rrole[rnum].Magic[i]].NeedItem < 0) or
          ((Rmagic[Rrole[rnum].Magic[i]].NeedItem >= 0) and (Rmagic[Rrole[rnum].Magic[i]].NeedItemAmount <=
          GetItemAmount(Rmagic[Rrole[rnum].Magic[i]].NeedItem))) and
          (Rmagic[Rrole[rnum].Magic[i]].NeedMP <= Rrole[rnum].CurrentMP) then
        begin
          p := 1;
          break;
        end;
      end;
    end;
    if p > 0 then
    begin
      MenuStatus := MenuStatus or 2;
      max := max + 1;
    end;
  end;
  //用毒是否可用
  if (Rrole[rnum].UsePoi > 0) and (Rrole[rnum].PhyPower >= 30) then
  begin
    MenuStatus := MenuStatus or 4;
    max := max + 1;
  end;
  //解毒是否可用
  if (Rrole[rnum].MedPoi > 0) and (Rrole[rnum].PhyPower >= 50) then
  begin
    MenuStatus := MenuStatus or 8;
    max := max + 1;
  end;
  //医疗是否可用
  if (Rrole[rnum].Medcine > 0) and (Rrole[rnum].PhyPower >= 50) then
  begin
    MenuStatus := MenuStatus or 16;
    max := max + 1;
  end;
  //等待是否可用
  if SEMIREAL = 1 then
  begin
    MenuStatus := MenuStatus - 64;
    max := max - 1;
  end;
  //计算步数
  //调息结束是否可用
  //未移动时, 结束完全无用
  if Brole[bnum].Moved > 0 then
  begin
    MenuStatus := MenuStatus - 256;
    max := max - 1;
  end
  else
  begin
    MenuStatus := MenuStatus - 512;
    max := max - 1;
  end;

  x := 50;
  y := 40;
  h := 28;

  Redraw;
  ShowSimpleStatus(Brole[bnum].rnum, 80, CENTER_Y * 2 - 130);
  //str := UTF8Decode(format('回合%d', [BattleRound]));
  //DrawTextWithRect(puint16(str), 160, 50, DrawLength(str) * 10 + 7, ColColor($21), ColColor($23), 30);
  //DrawMPic(2121, 160, 50);
  str := UTF8Decode(format('%d', [BattleRound]));
  l := length(str);
  DrawTextFrame(x + 100, y, 4 + l * 2);
  for i := 1 to l do
  begin
    DrawShadowText(puint16(num[StrToInt(str[i])]), x + 139 + i * 20, y + 3, 0, $202020);
    //DrawMPic(2130 + StrToInt(str[i]), 182 + 31 * i, 50);
  end;
  str := '回合';
  DrawShadowText(puint16(str), x + 119, y + 3, 0, $202020);

  UpdateAllScreen;
  RecordFreshScreen(x, y, 90, max * h + 40);
  menu := 0;
  ShowBMenu(MenuStatus, menu, max);
  //SDL_UpdateRect2(screen,0,0,screen.w,screen.h);
  while (SDL_WaitEvent(@event) >= 0) do
  begin
    CheckBasicEvent;
    case event.type_ of
      SDL_KEYDOWN:
      begin
        if (event.key.keysym.sym = SDLK_UP) then
        begin
          menu := menu - 1;
          if menu < 0 then
            menu := max;
          ShowBMenu(MenuStatus, menu, max);
        end;
        if (event.key.keysym.sym = SDLK_DOWN) then
        begin
          menu := menu + 1;
          if menu > max then
            menu := 0;
          ShowBMenu(MenuStatus, menu, max);
        end;
        event.key.keysym.sym := 0;
      end;
      SDL_KEYUP:
      begin
        if (event.key.keysym.sym = SDLK_RETURN) or (event.key.keysym.sym = SDLK_SPACE) then
        begin
          ConsoleLog('%d/%d/%d', [event.type_, event.key.keysym.sym, menu]);
          break;
        end;
        if (event.key.keysym.sym = SDLK_ESCAPE) then
        begin
          menu := -1;
          break;
        end;
      end;
      SDL_MOUSEBUTTONUP:
      begin
        if (event.button.button = SDL_BUTTON_LEFT) and (menu <> -1) and
          MouseInRegion(x, y, 120, (max + 1) * h, xm, ym) then
          break;
        if (event.button.button = SDL_BUTTON_RIGHT) {and (menu <> -1)} then
        begin
          menu := -1;
          break;
        end;
      end;
      SDL_MOUSEMOTION:
      begin
        if MouseInRegion(x, y, 120, (max + 1) * h, xm, ym) then
        begin
          menup := menu;
          menu := (ym - y - 2) div h;
          if menu > max then
            menu := max;
          if menu < 0 then
            menu := 0;
          if menup <> menu then
            ShowBMenu(MenuStatus, menu, max);
        end;
        //else
        //menu := -1;
      end;
    end;
  end;
  //result:=0;
  p := 0;
  for i := 0 to 10 do
  begin
    if (MenuStatus and (1 shl i)) > 0 then
    begin
      p := p + 1;
      if p > menu then
        break;
    end;
  end;
  Result := i;
  if menu = -1 then
    Result := -1;
  //SDL_EnableKeyRepeat(30, 35);
  FreeFreshScreen;
end;


//移动

procedure MoveRole(bnum: integer);
var
  s, i: integer;
begin
  //writeln(Brole[bnum].Step);
  CalCanSelect(bnum, 0, Brole[bnum].Step);
  SelectAimMode := 4;
  if SelectAim(bnum, Brole[bnum].Step) then
  begin
    MoveAmination(bnum);
  end;

end;

//移动动画

function MoveAmination(bnum: integer): boolean;
var
  s, i, a, tempx, tempy: integer;
  linebx, lineby: array[0..64] of integer;
  Xinc, Yinc: array[1..4] of integer;
  seekError: boolean;
begin
  Result := abs(Ax - Bx) + abs(Ay - By) > 0;
  if Result then
    Brole[bnum].Acted := 2; //2表示移动过
  if BField[3, Ax, Ay] > 0 then
  begin
    //Brole[bnum].Step := Brole[bnum].Step - abs(Ax - Bx) - abs(Ay - By);
    Xinc[1] := 1;
    Xinc[2] := -1;
    Xinc[3] := 0;
    Xinc[4] := 0;
    Yinc[1] := 0;
    Yinc[2] := 0;
    Yinc[3] := 1;
    Yinc[4] := -1;
    linebx[0] := Ax;
    lineby[0] := Ay;
    for a := 1 to BField[3, Ax, Ay] do
    begin
      seekError := True;
      for i := 1 to 4 do
      begin
        tempx := linebx[a - 1] + Xinc[i];
        tempy := lineby[a - 1] + Yinc[i];
        if BField[3, tempx, tempy] = BField[3, linebx[a - 1], lineby[a - 1]] - 1 then
        begin
          linebx[a] := tempx;
          lineby[a] := tempy;
          seekError := False;
          if (BField[7, tempx, tempy] = 0) or ((BField[7, tempx, tempy] = 1) and
            (tempx = Ax) and (tempy = Ay)) then
            break;
        end;
      end;
      //如果发现寻路错误则跳出
      if seekError then
      begin
        Result := False;
        exit;
      end;
    end;
    a := BField[3, Ax, Ay] - 1;
    while (SDL_PollEvent(@event) >= 0) do
    begin
      CheckBasicEvent;
      if sign(linebx[a] - Bx) > 0 then
        Brole[bnum].Face := 3
      else if sign(linebx[a] - Bx) < 0 then
        Brole[bnum].Face := 0
      else if sign(lineby[a] - By) < 0 then
        Brole[bnum].Face := 2
      else
        Brole[bnum].Face := 1;
      SDL_Delay(BATTLE_SPEED);
      if BField[2, Bx, By] = bnum then
        BField[2, Bx, By] := -1;
      Bx := linebx[a];
      By := lineby[a];
      if BField[2, Bx, By] = -1 then
        BField[2, Bx, By] := bnum;
      Redraw;
      UpdateAllScreen;
      Brole[bnum].Step := Brole[bnum].Step - 1;
      Brole[bnum].Moved := Brole[bnum].Moved + 1;
      a := a - 1;
      if a < 0 then
        break;
    end;
    Brole[bnum].X := Bx;
    Brole[bnum].Y := By;
  end;

end;


//选择查看状态的目标

function SelectShowStatus(bnum: integer): boolean;
var
  Axp, Ayp, rnum, step, range, AttAreaType, pAx, pAy: integer;
  //strs: array[1..17] of widestring;
begin
  //SDL_EnableKeyRepeat(20, 100);
  Ax := Bx;
  Ay := By;
  BattleSelecting := True;
  step := 64;
  range := 0;
  AttAreaType := 0;
  CalCanSelect(bnum, 2, 64);
  SelectAimMode := 5;
  DrawBFieldWithCursor(AttAreaType, step, range);
  UpdateAllScreen;
  pAx := Ax;
  pAy := Ay;
  while (SDL_WaitEvent(@event) >= 0) do
  begin
    CheckBasicEvent;
    case event.type_ of
      SDL_KEYUP:
      begin
        if (event.key.keysym.sym = SDLK_RETURN) or (event.key.keysym.sym = SDLK_SPACE) then
        begin
          if BField[2, Ax, Ay] >= 0 then
          begin
            rnum := Brole[BField[2, Ax, Ay]].rnum;
            TransBlackScreen;
            ShowStatus(rnum, BField[2, Ax, Ay]);
            UpdateAllScreen;
            WaitAnyKey;
            DrawBFieldWithCursor(AttAreaType, step, range);
            UpdateAllScreen;
          end;
        end;
        if (event.key.keysym.sym = SDLK_ESCAPE) then
        begin
          Result := False;
          break;
        end;
      end;
      SDL_KEYDOWN:
      begin
        if (event.key.keysym.sym = SDLK_LEFT) then
        begin
          Ay := Ay - 1;
        end;
        if (event.key.keysym.sym = SDLK_RIGHT) then
        begin
          Ay := Ay + 1;
        end;
        if (event.key.keysym.sym = SDLK_DOWN) then
        begin
          Ax := Ax + 1;
        end;
        if (event.key.keysym.sym = SDLK_UP) then
        begin
          Ax := Ax - 1;
        end;
      end;
      SDL_MOUSEBUTTONUP:
      begin
        if (event.button.button = SDL_BUTTON_LEFT) then
        begin
          if BField[2, Ax, Ay] >= 0 then
          begin
            TransBlackScreen;
            rnum := Brole[BField[2, Ax, Ay]].rnum;
            ShowStatus(rnum, BField[2, Ax, Ay]);
            //ShowAbility(rnum,0);
            UpdateAllScreen;
            WaitAnyKey;
            DrawBFieldWithCursor(AttAreaType, step, range);
            UpdateAllScreen;
          end;
        end;
        if (event.button.button = SDL_BUTTON_RIGHT) then
        begin
          Result := False;
          break;
        end;
      end;
      SDL_MOUSEMOTION:
      begin
        GetMousePosition(Ax, Ay, Bx, By);
      end;
    end;
    Ax := RegionParameter(Ax, 0, 63);
    Ay := RegionParameter(Ay, 0, 63);
    if (pAx <> Ax) or (pAy <> Ay) then
    begin
      DrawBFieldWithCursor(AttAreaType, step, range);
      if BField[2, Ax, Ay] >= 0 then
        ShowSimpleStatus(Brole[BField[2, Ax, Ay]].rnum, 80, CENTER_Y * 2 - 130);
      UpdateAllScreen;
      pAx := Ax;
      pAy := Ay;
    end;
  end;
  BattleSelecting := False;
  //SDL_EnableKeyRepeat(30, 30);
end;


//选择点

function SelectAim(bnum, step: integer): boolean;
var
  Axp, Ayp: integer;
begin
  //SDL_EnableKeyRepeat(20, 100);
  Ax := Bx;
  Ay := By;
  BattleSelecting := True;
  DrawBFieldWithCursor(0, step, 0);
  if (BField[2, Ax, Ay] >= 0) then
    ShowSimpleStatus(Brole[BField[2, Ax, Ay]].rnum, CENTER_X * 2 - 350, CENTER_Y * 2 - 130);
  UpdateAllScreen;
  while (SDL_WaitEvent(@event) >= 0) do
  begin
    CheckBasicEvent;
    case event.type_ of
      SDL_KEYUP:
      begin
        if (event.key.keysym.sym = SDLK_RETURN) or (event.key.keysym.sym = SDLK_SPACE) then
        begin
          Result := True;
          x50[28927] := 1;
          break;
        end;
        if (event.key.keysym.sym = SDLK_ESCAPE) then
        begin
          Result := False;
          x50[28927] := 0;
          break;
        end;
      end;
      SDL_KEYDOWN:
      begin
        if (event.key.keysym.sym = SDLK_LEFT) then
        begin
          Ay := Ay - 1;
          if (abs(Ax - Bx) + abs(Ay - By) > step) or (BField[3, Ax, Ay] < 0) then
            Ay := Ay + 1;
        end;
        if (event.key.keysym.sym = SDLK_RIGHT) then
        begin
          Ay := Ay + 1;
          if (abs(Ax - Bx) + abs(Ay - By) > step) or (BField[3, Ax, Ay] < 0) then
            Ay := Ay - 1;
        end;
        if (event.key.keysym.sym = SDLK_DOWN) then
        begin
          Ax := Ax + 1;
          if (abs(Ax - Bx) + abs(Ay - By) > step) or (BField[3, Ax, Ay] < 0) then
            Ax := Ax - 1;
        end;
        if (event.key.keysym.sym = SDLK_UP) then
        begin
          Ax := Ax - 1;
          if (abs(Ax - Bx) + abs(Ay - By) > step) or (BField[3, Ax, Ay] < 0) then
            Ax := Ax + 1;
        end;
      end;
      SDL_MOUSEBUTTONUP:
      begin
        if (event.button.button = SDL_BUTTON_LEFT) then
        begin
          if (abs(Axp - Bx) + abs(Ayp - By) <= step) and (BField[3, Ax, Ay] >= 0) then
          begin
            Result := True;
            break;
          end;
        end;
        if (event.button.button = SDL_BUTTON_RIGHT) then
        begin
          Result := False;
          break;
        end;
      end;
      SDL_MOUSEMOTION:
      begin
        GetMousePosition(Axp, Ayp, Bx, By);
        {Axp := (-round(event.button.x / (RealScreen.w / screen.w)) + CENTER_x + 2 *
          round(event.button.y / (RealScreen.h / screen.h)) - 2 * CENTER_y + 18) div 36 + Bx;
        Ayp := (round(event.button.x / (RealScreen.w / screen.w)) - CENTER_x + 2 *
          round(event.button.y / (RealScreen.h / screen.h)) - 2 * CENTER_y + 18) div 36 + By;}
        if (abs(Axp - Bx) + abs(Ayp - By) <= step) and (BField[3, Axp, Ayp] >= 0) then
        begin
          Ax := Axp;
          Ay := Ayp;
        end;
      end;
    end;
    DrawBFieldWithCursor(0, step, 0);
    if BField[2, Ax, Ay] >= 0 then
      ShowSimpleStatus(Brole[BField[2, Ax, Ay]].rnum, CENTER_X * 2 - 350, CENTER_Y * 2 - 130);
    UpdateAllScreen;
  end;
  BattleSelecting := False;
  //SDL_EnableKeyRepeat(30, 30);
end;

//选择原地

function SelectCross(bnum, AttAreaType, step, range: integer): boolean;
var
  Axp, Ayp: integer;
begin
  Ax := Bx;
  Ay := By;
  BattleSelecting := True;
  DrawBFieldWithCursor(AttAreaType, step, range);
  UpdateAllScreen;
  while (SDL_WaitEvent(@event) >= 0) do
  begin
    CheckBasicEvent;
    case event.type_ of
      SDL_KEYUP:
      begin
        if (event.key.keysym.sym = SDLK_RETURN) or (event.key.keysym.sym = SDLK_SPACE) then
        begin
          Result := True;
          break;
        end;
        if (event.key.keysym.sym = SDLK_ESCAPE) then
        begin
          Result := False;
          break;
        end;
      end;
      SDL_MOUSEBUTTONUP:
      begin
        if (event.button.button = SDL_BUTTON_LEFT) then
        begin
          Result := True;
          break;
        end;
        if (event.button.button = SDL_BUTTON_RIGHT) then
        begin
          Result := False;
          break;
        end;
      end;
    end;
  end;
  BattleSelecting := False;
end;

//目标系点叉菱方型、原地系菱方型

function SelectRange(bnum, AttAreaType, step, range: integer): boolean;
var
  Axp, Ayp: integer;
begin
  Ax := Bx;
  Ay := By;
  BattleSelecting := True;
  DrawBFieldWithCursor(AttAreaType, step, range);
  if (BField[2, Ax, Ay] >= 0) then
    ShowSimpleStatus(Brole[BField[2, Ax, Ay]].rnum, CENTER_X * 2 - 350, CENTER_Y * 2 - 130);
  UpdateAllScreen;
  while (SDL_WaitEvent(@event) >= 0) do
  begin
    CheckBasicEvent;
    case event.type_ of
      SDL_KEYUP:
      begin
        if (event.key.keysym.sym = SDLK_RETURN) or (event.key.keysym.sym = SDLK_SPACE) then
        begin
          Result := True;
          x50[28927] := 1;
          break;
        end;
        if (event.key.keysym.sym = SDLK_ESCAPE) then
        begin
          Result := False;
          x50[28927] := 0;
          break;
        end;
      end;
      SDL_KEYDOWN:
      begin
        if (event.key.keysym.sym = SDLK_LEFT) then
        begin
          Ay := Ay - 1;
          if (abs(Ax - Bx) + abs(Ay - By) > step) then
            Ay := Ay + 1;
        end;
        if (event.key.keysym.sym = SDLK_RIGHT) then
        begin
          Ay := Ay + 1;
          if (abs(Ax - Bx) + abs(Ay - By) > step) then
            Ay := Ay - 1;
        end;
        if (event.key.keysym.sym = SDLK_DOWN) then
        begin
          Ax := Ax + 1;
          if (abs(Ax - Bx) + abs(Ay - By) > step) then
            Ax := Ax - 1;
        end;
        if (event.key.keysym.sym = SDLK_UP) then
        begin
          Ax := Ax - 1;
          if (abs(Ax - Bx) + abs(Ay - By) > step) then
            Ax := Ax + 1;
        end;
        DrawBFieldWithCursor(AttAreaType, step, range);
        if (BField[2, Ax, Ay] >= 0) then
          ShowSimpleStatus(Brole[BField[2, Ax, Ay]].rnum, CENTER_X * 2 - 350, CENTER_Y * 2 - 130);
        UpdateAllScreen;
      end;
      SDL_MOUSEBUTTONUP:
      begin
        if (event.button.button = SDL_BUTTON_LEFT) then
        begin
          Result := True;
          break;
        end;
        if (event.button.button = SDL_BUTTON_RIGHT) then
        begin
          Result := False;
          break;
        end;
      end;
      SDL_MOUSEMOTION:
      begin
        GetMousePosition(Axp, Ayp, Bx, By);
        {Axp := (-round(event.button.x / (RealScreen.w / screen.w)) + CENTER_x + 2 *
          round(event.button.y / (RealScreen.h / screen.h)) - 2 * CENTER_y + 18) div 36 + Bx;
        Ayp := (round(event.button.x / (RealScreen.w / screen.w)) - CENTER_x + 2 *
          round(event.button.y / (RealScreen.h / screen.h)) - 2 * CENTER_y + 18) div 36 + By;}
        if (abs(Axp - Bx) + abs(Ayp - By) <= step) then
        begin
          Ax := Axp;
          Ay := Ayp;
          DrawBFieldWithCursor(AttAreaType, step, range);
          if (BField[2, Ax, Ay] >= 0) then
            ShowSimpleStatus(Brole[BField[2, Ax, Ay]].rnum, CENTER_X * 2 - 350, CENTER_Y * 2 - 130);
          UpdateAllScreen;
        end;
      end;
    end;
  end;
  BattleSelecting := False;
end;

//选择远程

function SelectFar(bnum, mnum, level: integer): boolean;
var
  Axp, Ayp: integer;
  AttAreaType, step, range, minstep: integer;
begin
  step := Rmagic[mnum].MoveDistance[level - 1];
  range := Rmagic[mnum].AttDistance[level - 1];
  AttAreaType := Rmagic[mnum].AttAreaType;
  minstep := Rmagic[mnum].MinStep;

  Ax := Bx - minstep - 1;
  Ay := By;
  BattleSelecting := True;
  DrawBFieldWithCursor(AttAreaType, step, range);
  UpdateAllScreen;
  while (SDL_WaitEvent(@event) >= 0) do
  begin
    CheckBasicEvent;
    case event.type_ of
      SDL_KEYUP:
      begin
        if (event.key.keysym.sym = SDLK_RETURN) or (event.key.keysym.sym = SDLK_SPACE) then
        begin
          Result := True;
          x50[28927] := 1;
          break;
        end;
        if (event.key.keysym.sym = SDLK_ESCAPE) then
        begin
          Result := False;
          x50[28927] := 0;
          break;
        end;
      end;
      SDL_KEYDOWN:
      begin
        if (event.key.keysym.sym = SDLK_LEFT) then
        begin
          Ay := Ay - 1;
          if (abs(Ax - Bx) + abs(Ay - By) > step) then
            Ay := Ay + 1;
          if (abs(Ax - Bx) + abs(Ay - By) <= minstep) then
            if Ax >= Bx then
              Ax := Ax + 1
            else
              Ax := Ax - 1;
          DrawBFieldWithCursor(AttAreaType, step, range);
          UpdateAllScreen;
        end;
        if (event.key.keysym.sym = SDLK_RIGHT) then
        begin
          Ay := Ay + 1;
          if (abs(Ax - Bx) + abs(Ay - By) > step) then
            Ay := Ay - 1;
          if (abs(Ax - Bx) + abs(Ay - By) <= minstep) then
            if Ax > Bx then
              Ax := Ax + 1
            else
              Ax := Ax - 1;
          DrawBFieldWithCursor(AttAreaType, step, range);
          UpdateAllScreen;
        end;
        if (event.key.keysym.sym = SDLK_DOWN) then
        begin
          Ax := Ax + 1;
          if (abs(Ax - Bx) + abs(Ay - By) > step) then
            Ax := Ax - 1;
          if (abs(Ax - Bx) + abs(Ay - By) <= minstep) then
            if Ay >= By then
              Ay := Ay + 1
            else
              Ay := Ay - 1;
          DrawBFieldWithCursor(AttAreaType, step, range);
          UpdateAllScreen;
        end;
        if (event.key.keysym.sym = SDLK_UP) then
        begin
          Ax := Ax - 1;
          if (abs(Ax - Bx) + abs(Ay - By) > step) then
            Ax := Ax + 1;
          if (abs(Ax - Bx) + abs(Ay - By) <= minstep) then
            if Ay > By then
              Ay := Ay + 1
            else
              Ay := Ay - 1;
          DrawBFieldWithCursor(AttAreaType, step, range);
          UpdateAllScreen;
        end;
      end;
      SDL_MOUSEBUTTONUP:
      begin
        if (event.button.button = SDL_BUTTON_LEFT) then
        begin
          Result := True;
          break;
        end;
        if (event.button.button = SDL_BUTTON_RIGHT) then
        begin
          Result := False;
          break;
        end;
      end;
      SDL_MOUSEMOTION:
      begin
        GetMousePosition(Axp, Ayp, Bx, By);
        {Axp := (-round(event.button.x / (RealScreen.w / screen.w)) + CENTER_x + 2 *
          round(event.button.y / (RealScreen.h / screen.h)) - 2 * CENTER_y + 18) div 36 + Bx;
        Ayp := (round(event.button.x / (RealScreen.w / screen.w)) - CENTER_x + 2 *
          round(event.button.y / (RealScreen.h / screen.h)) - 2 * CENTER_y + 18) div 36 + By;}
        if (abs(Axp - Bx) + abs(Ayp - By) <= step) and (abs(Axp - Bx) + abs(Ayp - By) > minstep) then
        begin
          Ax := Axp;
          Ay := Ayp;
          DrawBFieldWithCursor(AttAreaType, step, range);
          UpdateAllScreen;
        end;
      end;
    end;
  end;
  BattleSelecting := False;
end;


//选择方向

function SelectDirector(bnum, AttAreaType, step, range: integer): boolean;
var
  str: WideString;
begin
  Ax := Bx - 1;
  Ay := By;
  BattleSelecting := True;
  //str := '選擇攻擊方向';
  //Drawtextwithrect(@str[1], 280, 200, 125, colcolor($21), colcolor($23));
  DrawBFieldWithCursor(AttAreaType, step, range);
  UpdateAllScreen;
  Result := False;
  while (SDL_WaitEvent(@event) >= 0) do
  begin
    CheckBasicEvent;
    case event.type_ of
      SDL_KEYUP:
      begin
        if (event.key.keysym.sym = SDLK_ESCAPE) then
        begin
          break;
        end;
        if (event.key.keysym.sym = SDLK_RETURN) or (event.key.keysym.sym = SDLK_SPACE) then
        begin
          if (Ax <> Bx) or (Ay <> By) then
            Result := True;
          break;
        end;
      end;
      SDL_KEYDOWN:
      begin
        if (event.key.keysym.sym = SDLK_LEFT) then
        begin
          Ay := By - 1;
          Ax := Bx;
          DrawBFieldWithCursor(AttAreaType, step, range);
          UpdateAllScreen;
        end;
        if (event.key.keysym.sym = SDLK_RIGHT) then
        begin
          Ay := By + 1;
          Ax := Bx;
          DrawBFieldWithCursor(AttAreaType, step, range);
          UpdateAllScreen;
        end;
        if (event.key.keysym.sym = SDLK_DOWN) then
        begin
          Ax := Bx + 1;
          Ay := By;
          DrawBFieldWithCursor(AttAreaType, step, range);
          UpdateAllScreen;
        end;
        if (event.key.keysym.sym = SDLK_UP) then
        begin
          Ax := Bx - 1;
          Ay := By;
          DrawBFieldWithCursor(AttAreaType, step, range);
          UpdateAllScreen;
        end;
      end;
      SDL_MOUSEBUTTONUP:
      begin
        if event.button.button = SDL_BUTTON_RIGHT then
        begin
          Result := False;
          break;
        end;
        //按照所点击位置设置方向
        if event.button.button = SDL_BUTTON_LEFT then
        begin
          Result := True;
          break;
          {if MouseInRegion(0, 0, Center_x, Center_y) then
          begin
            Ay := By - 1;
            Ax := Bx;
            Result := True;
            break;
          end;
          if MouseInRegion(0, Center_y, Center_x, Center_y)        then
          begin
            Ax := Bx + 1;
            Ay := By;
            Result := True;
            break;
          end;
          if MouseInRegion(center_x, 0, Center_x, Center_y)  then
          begin
            Ax := Bx - 1;
            Ay := By;
            Result := True;
            break;
          end;
          if MouseInRegion(center_x, center_y, Center_x, Center_y)   then
          begin
            Ay := By + 1;
            Ax := Bx;
            Result := True;
            break;
          end;}
        end;
      end;
      SDL_MOUSEMOTION:
      begin
        if MouseInRegion(0, 0, CENTER_X, CENTER_Y) then
        begin
          Ay := By - 1;
          Ax := Bx;
        end;
        if MouseInRegion(0, CENTER_Y, CENTER_X, CENTER_Y) then
        begin
          Ax := Bx + 1;
          Ay := By;
        end;
        if MouseInRegion(CENTER_X, 0, CENTER_X, CENTER_Y) then
        begin
          Ax := Bx - 1;
          Ay := By;
        end;
        if MouseInRegion(CENTER_X, CENTER_Y, CENTER_X, CENTER_Y) then
        begin
          Ay := By + 1;
          Ax := Bx;
        end;
        DrawBFieldWithCursor(AttAreaType, step, range);
        UpdateAllScreen;
      end;
    end;
  end;
  BattleSelecting := False;
end;


//计算可以被选中的位置
//利用递归确定

{procedure SeekPath(x, y, step: integer);
begin
  if step > 0 then
  begin
    step := step - 1;
    if Bfield[3, x, y] in [0..step] then
    begin
      Bfield[3, x, y] := step;
      if Bfield[3, x + 1, y] in [0..step] then
      begin
        SeekPath(x + 1, y, step);
      end;
      if Bfield[3, x, y + 1] in [0..step] then
      begin
        SeekPath(x, y + 1, step);
      end;
      if Bfield[3, x - 1, y] in [0..step] then
      begin
        SeekPath(x - 1, y, step);
      end;
      if Bfield[3, x, y - 1] in [0..step] then
      begin
        SeekPath(x, y - 1, step);
      end;
    end;
  end;

end;}


//计算可以被选中的位置
//利用队列
//移动过程中, 旁边有敌人, 则不能继续移动
//mode=0移动, 1攻击用毒医疗等, 2查看状态, 3标记出两个人物之间的步数
//1,2并未使用此子程

procedure SeekPath2(x, y, step, myteam, mode: integer; bnum: integer = -1);
var
  Xlist: array[0..4096] of integer;
  Ylist: array[0..4096] of integer;
  steplist: array[0..4096] of integer;
  curgrid, totalgrid: integer;
  Bgrid: array[1..4] of integer;
  //0空位, 1建筑, 2友军, 3敌军, 4出界, 5已走过, 6水面, 7敌人身旁, 8首次无法达到(由第6层标记)
  //代码中有优先级
  Xinc, Yinc: array[1..4] of integer;
  curX, curY, curstep, nextX, nextY, nextnextX, nextnextY: integer;
  i, j, t: integer;
  layer: integer = 3;  //用来寻人使用第8层, 默认第3层
  findAim: boolean = False;  //寻人成功, 准备跳出
begin
  Xinc[1] := 1;
  Xinc[2] := -1;
  Xinc[3] := 0;
  Xinc[4] := 0;
  Yinc[1] := 0;
  Yinc[2] := 0;
  Yinc[3] := 1;
  Yinc[4] := -1;
  curgrid := 0;
  totalgrid := 0;
  Xlist[totalgrid] := x;
  Ylist[totalgrid] := y;
  steplist[totalgrid] := 0;
  totalgrid := totalgrid + 1;
  t := 0;
  if mode = 3 then
    layer := 8;
  while curgrid < totalgrid do
  begin
    curX := Xlist[curgrid];
    curY := Ylist[curgrid];
    curstep := steplist[curgrid];
    //writeln(t, '', curgrid, '', totalgrid, ' ', curstep, ' ', step);
    //t := t + 1;
    if curstep < step then
    begin
      //判断当前点四周格子的状况
      for i := 1 to 4 do
      begin
        Bgrid[i] := 0;
        nextX := curX + Xinc[i];
        nextY := curY + Yinc[i];
        if (nextX < 0) or (nextX > 63) or (nextY < 0) or (nextY > 63) then
          Bgrid[i] := 4
        else if BField[layer, nextX, nextY] >= 0 then
          Bgrid[i] := 5
        else if (BField[1, nextX, nextY] > 0) or ((BField[0, nextX, nextY] >= 358) and
          (BField[0, nextX, nextY] <= 362)) or (BField[0, nextX, nextY] = 522) or
          (BField[0, nextX, nextY] = 1022) or ((BField[0, nextX, nextY] >= 1324) and
          (BField[0, nextX, nextY] <= 1330)) or (BField[0, nextX, nextY] = 1348) then
          Bgrid[i] := 1
        else if (BField[2, nextX, nextY] >= 0) and (Brole[BField[2, nextX, nextY]].Dead = 0) and (mode = 0) then
        begin
          if Brole[BField[2, nextX, nextY]].Team = myteam then
            Bgrid[i] := 2
          else
            Bgrid[i] := 3;
        end
          {else if ((Bfield[0, nextX, nextY] div 2 >= 179) and (Bfield[0, nextX, nextY] div 2 <= 190)) or
            (Bfield[0, nextX, nextY] div 2 = 261) or
            (Bfield[0, nextX, nextY] div 2 = 511) or
            ((Bfield[0, nextX, nextY] div 2 >= 224) and (Bfield[0, nextX, nextY] div 2 <= 232)) or
            ((Bfield[0, nextX, nextY] div 2 >= 662) and (Bfield[0, nextX, nextY] div 2 <= 674)) then
            Bgrid[i] := 6}
        else if (BField[6, nextX, nextY] < 0) and (mode = 0) then
          Bgrid[i] := 8
        else
          Bgrid[i] := 0;
        //寻人成功则跳出, 节省计算量
        if (BField[2, nextX, nextY] = bnum) and (mode = 3) then
        begin
          //exit;
        end;
        if mode = 0 then
          for j := 1 to 4 do
          begin
            nextnextX := nextX + Xinc[j];
            nextnextY := nextY + Yinc[j];
            if (nextnextX >= 0) and (nextnextX < 63) and (nextnextY >= 0) and (nextnextY < 63) then
              if (BField[2, nextnextX, nextnextY] >= 0) and (Brole[BField[2, nextnextX, nextnextY]].Dead =
                0) and (Brole[BField[2, nextnextX, nextnextY]].Team <> myteam) then
              begin
                BField[7, nextX, nextY] := 1;
              end;
          end;
      end;

      //移动的情况
      //若为初始位置, 不考虑旁边是敌军的情况
      //在移动过程中, 旁边没有敌军的情况下才继续移动
      case mode of
        0:
        begin
          if (curstep = 0) or ((Bgrid[1] <> 3) and (Bgrid[2] <> 3) and (Bgrid[3] <> 3) and (Bgrid[4] <> 3)) then
          begin
            for i := 1 to 4 do
            begin
              if (Bgrid[i] = 0) then
              begin
                Xlist[totalgrid] := curX + Xinc[i];
                Ylist[totalgrid] := curY + Yinc[i];
                steplist[totalgrid] := curstep + 1;
                BField[layer, Xlist[totalgrid], Ylist[totalgrid]] := steplist[totalgrid];
                //if (Bgrid[i] = 3) then Bfield[3, Xlist[totalgrid], Ylist[totalgrid]] := step;
                //showmessage(inttostr(steplist[totalgrid]));
                totalgrid := totalgrid + 1;
              end;
            end;
          end;
        end;
          //非移动的情况, 攻击、医疗等
        else
        begin
          for i := 1 to 4 do
          begin
            if (Bgrid[i] = 0) or (Bgrid[i] = 2) or (Bgrid[i] = 3) then
            begin
              Xlist[totalgrid] := curX + Xinc[i];
              Ylist[totalgrid] := curY + Yinc[i];
              steplist[totalgrid] := curstep + 1;
              BField[layer, Xlist[totalgrid], Ylist[totalgrid]] := steplist[totalgrid];
              totalgrid := totalgrid + 1;
            end;
          end;
        end;
      end;
    end;
    curgrid := curgrid + 1;
  end;

end;

{var
  Xlist: array[0..4096] of integer;
  Ylist: array[0..4096] of integer;
  steplist: array[0..4096] of integer;
  curgrid, totalgrid: integer;
  Bgrid: array[1..4] of integer; //0空位, 1建筑, 2友军, 3敌军, 4出界, 5已走过
  Xinc, Yinc: array[1..4] of integer;
  curX, curY, curstep, nextX, nextY: integer;
  i: integer;

begin
  Xinc[1] := 1;
  Xinc[2] := -1;
  Xinc[3] := 0;
  Xinc[4] := 0;
  Yinc[1] := 0;
  Yinc[2] := 0;
  Yinc[3] := 1;
  Yinc[4] := -1;
  curgrid := 0;
  totalgrid := 0;
  Xlist[totalgrid] := x;
  Ylist[totalgrid] := y;
  steplist[totalgrid] := 0;
  totalgrid := totalgrid + 1;
  while curgrid < totalgrid do
  begin
    curX := Xlist[curgrid];
    curY := Ylist[curgrid];
    curstep := steplist[curgrid];
    if curstep < step then
    begin
      //判断当前点四周格子的状况
      for i := 1 to 4 do
      begin
        nextX := curX + Xinc[i];
        nextY := curY + Yinc[i];
        if (nextX < 0) or (nextX > 63) or (nextY < 0) or (nextY > 63) then
          Bgrid[i] := 4
        else if Bfield[3, nextX, nextY] >= 0 then
          Bgrid[i] := 5
        else if (Bfield[1, nextX, nextY] > 0) or ((Bfield[0, nextX, nextY] >= 358) and
          (Bfield[0, nextX, nextY] <= 362)) or (Bfield[0, nextX, nextY] = 522) or
          (Bfield[0, nextX, nextY] = 1022) or ((Bfield[0, nextX, nextY] >= 1324) and
          (Bfield[0, nextX, nextY] <= 1330)) or (Bfield[0, nextX, nextY] = 1348) then
          Bgrid[i] := 1

        else if Bfield[2, nextX, nextY] >= 0 then
        begin
          if BRole[Bfield[2, nextX, nextY]].Team = myteam then
            Bgrid[i] := 2
          else
            Bgrid[i] := 3;
        end
        else
          Bgrid[i] := 0;
      end;

      //移动的情况
      //若为初始位置, 不考虑旁边是敌军的情况
      //在移动过程中, 旁边没有敌军的情况下才继续移动
      if mode = 0 then
      begin
        if (curstep = 0) or ((Bgrid[1] <> 3) and (Bgrid[2] <> 3) and (Bgrid[3] <> 3) and (Bgrid[4] <> 3)) then
        begin
          for i := 1 to 4 do
          begin
            if Bgrid[i] = 0 then
            begin
              Xlist[totalgrid] := curX + Xinc[i];
              Ylist[totalgrid] := curY + Yinc[i];
              steplist[totalgrid] := curstep + 1;
              Bfield[3, Xlist[totalgrid], Ylist[totalgrid]] := steplist[totalgrid];
              totalgrid := totalgrid + 1;
            end;
          end;
        end;
      end
      else
        //非移动的情况, 攻击、医疗等
      begin
        for i := 1 to 4 do
        begin
          if (Bgrid[i] = 0) or (Bgrid[i] = 2) or ((Bgrid[i] = 3)) then
          begin
            Xlist[totalgrid] := curX + Xinc[i];
            Ylist[totalgrid] := curY + Yinc[i];
            steplist[totalgrid] := curstep + 1;
            Bfield[3, Xlist[totalgrid], Ylist[totalgrid]] := steplist[totalgrid];
            totalgrid := totalgrid + 1;
          end;
        end;
      end;
    end;
    curgrid := curgrid + 1;
  end;

end;}

//初始化范围
//mode=0移动, 1攻击用毒医疗等, 2查看状态, 3类似0但是忽略人物

procedure CalCanSelect(bnum, mode, step: integer);
var
  i, i1, i2, step0: integer;
begin
  //step := Brole[bnum].Step;

  if (mode = 0) or (mode = 3) then
  begin
    FillChar(BField[3, 0, 0], 4096 * 2, -1);
    FillChar(BField[7, 0, 0], 4096 * 2, 0); //第7层标记敌人身旁的位置
    if Brole[bnum].Acted = 0 then
      FillChar(BField[6, 0, 0], sizeof(BField[6]), 0); //第6层标记第一次不能走到的位置, 小于0表示不能到达
    BField[3, Brole[bnum].X, Brole[bnum].Y] := 0;
    SeekPath2(Brole[bnum].X, Brole[bnum].Y, Step, Brole[bnum].Team, mode);
    if Brole[bnum].Acted = 0 then
      move(BField[3, 0, 0], BField[6, 0, 0], 4096 * 2); //保存第一次可以走到的位置, 后续的移动只能在此范围
    {else
      for i1 := 0 to 63 do
        for i2 := 0 to 63 do
        begin
          if Bfield[6, i1, i2] = -1 then
            Bfield[3, i1, i2] := -1;
        end;}
  end;

  if mode = 1 then
  begin
    FillChar(BField[3, 0, 0], 4096 * 2, -1);
    for i1 := max(0, Brole[bnum].X - step) to min(63, Brole[bnum].X + step) do
    begin
      step0 := abs(i1 - Brole[bnum].X);
      for i2 := max(0, Brole[bnum].Y - step + step0) to min(63, Brole[bnum].Y + step - step0) do
      begin
        //if (i1 >= 0) and (i1 <= 63) and (i2 >= 0) and (i2 <= 63) then
        BField[3, i1, i2] := 0;
      end;
    end;
  end;

  if mode = 2 then
    for i1 := 0 to 63 do
      for i2 := 0 to 63 do
      begin
        BField[3, i1, i2] := -1;
        if BField[2, i1, i2] >= 0 then
          BField[3, i1, i2] := 0;
      end;

end;


//攻击

procedure Attack(bnum: integer);
var
  rnum, i, mnum, level, step, range, AttAreaType, i1, twice, temp: integer;
  str: string;
begin
  rnum := Brole[bnum].rnum;
  while True do
  begin
    i := SelectMagic(rnum);
    if i < 0 then
      exit;
    mnum := Rrole[rnum].Magic[i];
    level := Rrole[rnum].MagLevel[i] div 100 + 1;
    x50[28928] := mnum;
    x50[28929] := i;
    x50[28100] := i;

    SelectAimMode := 0; //默认为范围内敌方
    if Rmagic[mnum].HurtType = 2 then
      SelectAimMode := Rmagic[mnum].AddMP[0]; //2是特技, 用AddMP[0]表示目标方式
    //1范围内我方, 2敌方全体, 3我方全体, 4自身, 5范围内全部, 6全部, 7无高亮
    //if Rmagic[mnum].HurtType = 5 then
    //selectaimMode := 5;
    //依据攻击范围进一步选择
    step := Rmagic[mnum].MoveDistance[level - 1];
    range := Rmagic[mnum].AttDistance[level - 1];
    AttAreaType := Rmagic[mnum].AttAreaType;

    ModifyRange(bnum, mnum, step, range);

    CalCanSelect(bnum, 1, step);
    case Rmagic[mnum].AttAreaType of
      0, 3:
      begin
        if SelectRange(bnum, AttAreaType, step, range) then
        begin
          Brole[bnum].Acted := 1;
        end;
      end;
      1, 4, 5:
      begin
        if SelectDirector(bnum, AttAreaType, step, range) then
        begin
          Brole[bnum].Acted := 1;
        end;
      end;
      2:
      begin
        if SelectCross(bnum, AttAreaType, step, range) then
        begin
          Brole[bnum].Acted := 1;
        end;
      end;
      6:
      begin
        if SelectFar(bnum, mnum, level) then
        begin
          Brole[bnum].Acted := 1;
        end;
      end;
    end;
    if Brole[bnum].Acted = 1 then
    begin
      SetAminationPosition(AttAreaType, step, range, SelectAimMode);
      AttackAction(bnum, i, mnum, level);
      break;
    end;
  end;
end;

procedure ModifyRange(bnum, mnum: integer; var step, range: integer);
begin
  //12号状态剑芒, 攻击范围扩大
  if (Brole[bnum].StateLevel[12] <> 0) and (Rmagic[mnum].hurtType <> 2) then
  begin
    case Rmagic[mnum].AttAreaType of
      0, 3, 6: range := range + Brole[bnum].StateLevel[12];
      1, 4, 5: step := step + Brole[bnum].StateLevel[12];
      2:
      begin
        step := step + sign(step) * Brole[bnum].StateLevel[12];
        range := range + sign(range) * Brole[bnum].StateLevel[12];
      end;
    end;
  end;
end;

//武学的统一入口

procedure AttackAction(bnum, i, mnum, level: integer); overload;
var
  twice, i1, rnum: integer;
begin
  rnum := Brole[bnum].rnum;
  //剑法的连击
  twice := 0;
  if (Rmagic[mnum].MagicType = 2) {and (Rmagic[mnum].HurtType <> 2)} then
    if random(1000) < Rrole[Brole[bnum].rnum].Sword * (100 + Brole[bnum].StateLevel[30]) div 100 then
      twice := 1;
  twice := twice + Brole[bnum].StateLevel[13] + Rrole[Brole[bnum].rnum].addnum;
  //if Rmagic[mnum].HurtType = 2 then twice := 0;
  //执行攻击效果, 执行次数为（1+本身互博能力+连击状态+剑法连击）
  for i1 := 0 to twice do
  begin
    AttackAction(bnum, mnum, level);
    //武功等级增加
    if Brole[bnum].Acted = 1 then
      Rrole[rnum].MagLevel[i] := min(999, Rrole[rnum].MagLevel[i] + random(2) + 1);
  end;
  if MODVersion = 0 then
    for i1 := 0 to 3 do
    begin
      if Rrole[rnum].NeiGong[i1] > 0 then
        Rrole[rnum].NGLevel[i1] := min(999, Rrole[rnum].NGLevel[i1] + random(2));
    end;
  //检查附加效果
  CheckAttackAttachment(bnum, mnum, level);

end;

//攻击效果
procedure AttackAction(bnum, mnum, level: integer); overload;
var
  i, movestep, j, incx, incy, aimx, aimy, incbing, neinum, neilevel, lastng, rnum, Phyfee: integer;
  p: double;
begin
  rnum := Brole[bnum].rnum;

  //消耗体力
  if (Rrole[rnum].MaxMP > 10 * Rrole[rnum].CurrentMP) or (Rrole[rnum].CurrentMP <= 0) then
    Phyfee := 10
  else
    Phyfee := Rrole[rnum].MaxMP div Rrole[rnum].CurrentMP;
  Rrole[rnum].PhyPower := Rrole[rnum].PhyPower - Phyfee;
  if Rrole[rnum].PhyPower < 0 then
    Rrole[rnum].PhyPower := 0;

  //等级修正
  {if Rmagic[mnum].NeedMP > 0 then
    level := min(level, Rrole[rnum].CurrentMP div Rmagic[mnum].NeedMP);}

  //消耗内力
  Rrole[rnum].CurrentMP := Rrole[rnum].CurrentMP - Rmagic[mnum].NeedMP * level;
  if Rrole[rnum].CurrentMP < 0 then
  begin
    Rrole[rnum].CurrentMP := 0;
    level := 0;
  end;

  //消耗自身生命
  Rrole[rnum].CurrentHP := Rrole[rnum].CurrentHP - Rmagic[mnum].NeedHP * level;
  if Rrole[rnum].CurrentHP < 0 then
    Rrole[rnum].CurrentHP := 1;
  if Rrole[rnum].CurrentHP > Rrole[rnum].MaxHP then
    Rrole[rnum].CurrentHP := Rrole[rnum].MaxHP;

  //出手一次, 获得1到10的经验值
  case MODVersion of
    13: Brole[bnum].ExpGot := Brole[bnum].ExpGot + 1 + random(10);
    else
      Brole[bnum].ExpGot := Brole[bnum].ExpGot + 40 + random(10);
  end;

  //武功的攻击超过1000且人物的攻击超过600, 则使用震动效果
  if (Rmagic[mnum].Attack[0] + (Rmagic[mnum].Attack[1] - Rmagic[mnum].Attack[0]) * level div 10 > 1000) and
    (Rrole[rnum].Attack > 600) then
    needOffset := 1;

  if not UseSpecialAbility(bnum, mnum, level) then
  begin
    //if Brole[bnum].Team = 0 then
    //内功效果的名称显示
    //内功影响武功伤害
    p := 1;
    lastng := -1;
    for i := 0 to 3 do
    begin
      neinum := Rrole[Brole[bnum].rnum].neigong[i];
      if neinum <= 0 then
        break;
      neilevel := Rrole[Brole[bnum].rnum].NGLevel[i] div 100 + 1;

      //普通内功对应类型的加成
      if ((Rmagic[neinum].MoveDistance[0] = 6) or (Rmagic[neinum].MoveDistance[0] = Rmagic[mnum].MagicType)) and
        (Rmagic[neinum].MoveDistance[1] >= Rmagic[mnum].Attack[1] div 100) then
        if (100 + Rmagic[neinum].movedistance[2] + (Rmagic[neinum].movedistance[3] - Rmagic[neinum].movedistance[2]) *
          neilevel / 10) / 100 > p then
        begin
          p := (100 + Rmagic[neinum].movedistance[2] + (Rmagic[neinum].movedistance[3] -
            Rmagic[neinum].movedistance[2]) * neilevel / 10) / 100;
          lastng := neinum;
        end;

      //特定武功加成
      if Rmagic[neinum].AttDistance[4] = mnum then
      begin
        ShowStringOnBrole(pWideChar(@Rmagic[neinum].Name) + UTF8Decode('·威力'), bnum, 3);
      end;

      //资质对武功加成, 段家心法
      if Rmagic[neinum].AttDistance[7] > 0 then
      begin
        ShowStringOnBrole(pWideChar(@Rmagic[neinum].Name) + UTF8Decode('·威力'), bnum, 3);
      end;

      //我方剩余人数加成, 神龙吟
      if Rmagic[neinum].AttDistance[9] > 0 then
      begin
        ShowStringOnBrole(pWideChar(@Rmagic[neinum].Name) + UTF8Decode('·神威'), bnum, 3);
      end;

      //对轻功加成的加成, 玉女心经
      if Rmagic[neinum].MoveDistance[8] > 0 then
      begin
        ShowStringOnBrole(pWideChar(@Rmagic[neinum].Name) + UTF8Decode('·輕力'), bnum, 3);
      end;

      //对内功加成的加成
      if Rmagic[neinum].MoveDistance[6] > 0 then
      begin
        ShowStringOnBrole(pWideChar(@Rmagic[neinum].Name) + UTF8Decode('·強内'), bnum, 3);
      end;
    end;

    if lastng > 0 then
      ShowStringOnBrole(pWideChar(@Rmagic[lastng].Name) + UTF8Decode('·加力'), bnum, 3);

    ShowMagicName(mnum);
    PlaySoundA(Rmagic[mnum].SoundNum, 0);
    PlayActionAmination(bnum, Rmagic[mnum].MagicType); //动作效果
    CalHurtRole(bnum, mnum, level, 1); //计算被打到的人物
    PlayMagicAmination(bnum, Rmagic[mnum].AmiNum); //武功效果
    ShowHurtValue(Rmagic[mnum].HurtType); //显示数字
    if Rmagic[mnum].NeedItem >= 0 then
      instruct_32(Rmagic[mnum].NeedItem, -Rmagic[mnum].NeedItemAmount);
  end;

  //检查被打到人的效果
  for i := 0 to BRoleAmount - 1 do
  begin
    if (Brole[i].Dead = 0) then
    begin
      if Rmagic[mnum].HurtType = 0 then
      begin
        //19号状态, 青翼, 被攻击后移动
        if (Brole[bnum].Team <> Brole[i].Team) and (BField[4, Brole[i].X, Brole[i].Y] > 0) and
          (Brole[i].StateLevel[19] = 1) then
        begin
          movestep := Rrole[Brole[i].rnum].Movestep;
          movestep := movestep div 10;
          movestep := movestep + Brole[i].StateLevel[3] + Brole[i].loverlevel[2] +
            Ritem[Rrole[Brole[i].rnum].Equip[1]].AddMove + Ritem[Rrole[Brole[i].rnum].Equip[0]].AddMove;
          Bx := Brole[i].X;
          By := Brole[i].Y;
          CalCanSelect(i, 0, movestep);
          if (Brole[i].Team = 0) and (Brole[i].Auto = 0) then
            SelectAim(i, movestep)
          else
            FarthestMove(Ax, Ay, i);
          Brole[i].X := Ax;
          Brole[i].Y := Ay;
          BField[2, Bx, By] := -1;
          BField[2, Ax, Ay] := i;
        end;
        //17号状态, 博采, 受攻击后增加兵器值
        if (BField[4, Brole[i].X, Brole[i].Y] > 0) and (Brole[i].StateLevel[17] > 0) then
        begin
          if random(100) < Brole[i].StateLevel[17] then
          begin
            case Rmagic[mnum].MagicType of
              1:
              begin
                if Rrole[i].Fist >= 20 then
                  Rrole[Brole[i].rnum].Fist := min(Rrole[Brole[i].rnum].Fist + 1, MaxProList[50]);
              end;
              2:
              begin
                if Rrole[i].Sword >= 20 then
                  Rrole[Brole[i].rnum].Sword := min(Rrole[Brole[i].rnum].Sword + 1, MaxProList[51]);
              end;
              3:
              begin
                if Rrole[i].Knife >= 20 then
                  Rrole[Brole[i].rnum].Knife := min(Rrole[Brole[i].rnum].Knife + 1, MaxProList[52]);
              end;
              4:
              begin
                if Rrole[i].Unusual >= 20 then
                  Rrole[Brole[i].rnum].Unusual := min(Rrole[Brole[i].rnum].Unusual + 1, MaxProList[53]);
              end;
              5:
              begin
                if Rrole[i].HidWeapon >= 20 then
                  Rrole[Brole[i].rnum].HidWeapon := min(Rrole[Brole[i].rnum].HidWeapon + 1, MaxProList[54]);
              end;
            end;
          end;
        end;
      end;
      //8号状态, 风雷, 攻击后直线敌人后移N格
      if (Brole[bnum].StateLevel[8] > 0) and (Brole[bnum].Team <> Brole[i].Team) then
      begin
        if (BField[4, Brole[i].X, Brole[i].Y] > 0) and ((Brole[i].Y = Bx) or (Brole[i].Y = By)) then
        begin
          incx := sign(Brole[i].X - Bx);
          incy := sign(Brole[i].Y - By);
          aimx := Brole[i].X;
          aimy := Brole[i].Y;
          for j := 0 to Brole[bnum].StateLevel[8] - 1 do
          begin
            if (BField[2, aimx + incx, aimy + incy] = -1) and (BField[1, aimx + incx, aimy + incy] = 0) then
            begin
              aimx := aimx + incx;
              aimy := aimy + incy;
            end
            else
              break;
          end;
          BField[2, Brole[i].x, Brole[i].y] := -1;
          Brole[i].X := aimx;
          Brole[i].Y := aimy;
          BField[2, aimx, aimy] := i;
        end;
      end;
    end;
  end;

end;

procedure ShowMagicName(mnum: integer; str: WideString = '');
var
  l, mode: integer;
  color1, color2: uint32;
  str0: string;
begin
  Redraw;
  if (str = '') and (mnum >= 0) then
  begin
    str := pWideChar(@Rmagic[mnum].Name);
    color1 := ColColor($14);
    color2 := ColColor($16);
  end
  else
  begin
    mode := mnum;
    SelectColor(mode, color1, color2, str0);
  end;

  l := DrawLength(str);
  DrawTextWithRect(@str[1], CENTER_X - l * 5 - 24, CENTER_Y - 150, 0, color1, color2, 10);
  UpdateAllScreen;
  SDL_Delay(400);
  event.key.keysym.sym := 0;
  event.button.button := 0;

end;

//选择武功

function SelectMagic(rnum: integer): integer;
var
  i, p, MenuStatus, max, menu, menup, xm, ym, h: integer;
  str: WideString;
  menuString, menuEngString: array of WideString;

  //显示武功选单

  procedure ShowMagicMenu(MenuStatus, menu, max: integer);
  var
    i, p: integer;
  begin
    LoadFreshScreen(100, 50);
    //DrawRectangle(100, 50, 167, max * 22 + 28, 0, ColColor(255), 30);
    p := 0;
    for i := 0 to 9 do
    begin
      if (p = menu) and ((MenuStatus and (1 shl i) > 0)) then
      begin
        DrawTextFrame(103, 50 + h * p, 15);
        DrawShadowText(@menuString[i][1], 122, 53 + h * p, ColColor($64), ColColor($66));
        DrawEngShadowText(@menuEngString[i][1], 242, 53 + h * p, ColColor($64), ColColor($66));
        p := p + 1;
      end
      else if (p <> menu) and ((MenuStatus and (1 shl i) > 0)) then
      begin
        DrawTextFrame(103, 50 + h * p, 15, 20);
        DrawShadowText(@menuString[i][1], 122, 53 + h * p, 0, $202020);
        DrawEngShadowText(@menuEngString[i][1], 242, 53 + h * p, 0, $202020);
        p := p + 1;
      end;
    end;
    UpdateAllScreen;
    //updateallscreen;

  end;

begin
  MenuStatus := 0;
  max := 0;
  h := 28;
  setlength(menuString, 10);
  setlength(menuEngString, 10);
  //SDL_EnableKeyRepeat(20, 100);
  for i := 0 to 9 do
  begin
    if Rrole[rnum].Magic[i] > 0 then
    begin
      if ((Rmagic[Rrole[rnum].Magic[i]].NeedItem < 0) or ((Rmagic[Rrole[rnum].Magic[i]].NeedItem >= 0) and
        (Rmagic[Rrole[rnum].Magic[i]].NeedItemAmount <= GetItemAmount(Rmagic[Rrole[rnum].Magic[i]].NeedItem)))) and
        ((Rmagic[Rrole[rnum].Magic[i]].NeedMP <= Rrole[rnum].CurrentMP)) then
      begin
        MenuStatus := MenuStatus or (1 shl i);
        menuString[i] := pWideChar(@Rmagic[Rrole[rnum].Magic[i]].Name);
        menuEngString[i] := format('%3d', [Rrole[rnum].MagLevel[i] div 100 + 1]);
        max := max + 1;
      end;
    end;
  end;
  max := max - 1;

  Redraw;
  ShowSimpleStatus(rnum, 80, CENTER_Y * 2 - 130);
  RecordFreshScreen(100, 50, 200, 300);
  UpdateAllScreen;
  menu := 0;
  if max < 0 then
  begin
    Result := -1;
    str := '內力不足以發動任何武學！';
    DrawTextWithRect(@str[1], 100, 50, 0, 0, $202020, 0, 0);
    UpdateAllScreen;
    WaitAnyKey;
    exit;
  end;
  ShowMagicMenu(MenuStatus, menu, max);
  while (SDL_WaitEvent(@event) >= 0) do
  begin
    CheckBasicEvent;
    case event.type_ of
      SDL_KEYUP:
      begin
        if (event.key.keysym.sym = SDLK_RETURN) or (event.key.keysym.sym = SDLK_SPACE) then
        begin
          break;
        end;
        if (event.key.keysym.sym = SDLK_ESCAPE) then
        begin
          menu := -1;
          break;
        end;
      end;
      SDL_KEYDOWN:
      begin
        if (event.key.keysym.sym = SDLK_UP) then
        begin
          menu := menu - 1;
          if menu < 0 then
            menu := max;
          ShowMagicMenu(MenuStatus, menu, max);
        end;
        if (event.key.keysym.sym = SDLK_DOWN) then
        begin
          menu := menu + 1;
          if menu > max then
            menu := 0;
          ShowMagicMenu(MenuStatus, menu, max);
        end;
      end;
      SDL_MOUSEBUTTONUP:
      begin
        if (event.button.button = SDL_BUTTON_LEFT) and (menu <> -1) then
        begin
          break;
        end;
        if (event.button.button = SDL_BUTTON_RIGHT) then
        begin
          menu := -1;
          break;
        end;
      end;
      SDL_MOUSEMOTION:
      begin
        if MouseInRegion(100, 50, 190, max * h + 32, xm, ym) then
        begin
          menup := menu;
          menu := (ym - 52) div h;
          if menu > max then
            menu := max;
          if menu < 0 then
            menu := 0;
          if menup <> menu then
            ShowMagicMenu(MenuStatus, menu, max);
        end
        else
          menu := -1;
      end;
    end;
  end;

  Result := menu;
  if Result >= 0 then
  begin
    p := 0;
    for i := 0 to 9 do
    begin
      if (MenuStatus and (1 shl i)) > 0 then
      begin
        p := p + 1;
        if p > menu then
          break;
      end;
    end;
    Result := i;
  end;
  FreeFreshScreen;
  //SDL_EnableKeyRepeat(30, 35);
end;


//设定攻击范围
//使用比较复杂但是高效的方式重写, 主要是为AI计算也可使用

procedure SetAminationPosition(mode, step, range: integer; aimMode: integer = 0); overload;
begin
  SetAminationPosition(Bx, By, Ax, Ay, mode, step, range, aimMode);
end;

procedure SetAminationPosition(Bx, By, Ax, Ay, mode, step, range: integer; aimMode: integer = 0); overload;
var
  i, i1, i2, dis0, dis, Ax1, Ay1, step1, bnum: integer;
begin
  FillChar(BField[4, 0, 0], 4096 * 2, 0);
  //按攻击类型判断是否在范围内
  //1范围内我方, 2敌方全体, 3我方全体, 4自身, 5范围内全部, 6全部, 7无高亮
  bnum := BField[2, Bx, By];
  case aimMode of
    2, 3, 6:
      if bnum >= 0 then
        for i := 0 to BRoleAmount - 1 do
        begin
          if (Brole[i].Dead = 0) and (((aimMode = 2) and (Brole[bnum].Team <> Brole[i].Team)) or
            ((aimMode = 3) and (Brole[bnum].Team = Brole[i].Team)) or (aimMode = 6)) then
            BField[4, Brole[i].X, Brole[i].Y] := 1 + random(6);
        end;
    4: BField[4, Bx, By] := 1;
    0, 1, 5:
      case mode of
        0, 6: //目标系点型、目标系十型、目标系菱型、原地系菱型、远程
        begin
          dis := range;
          for i1 := max(Ax - dis, 0) to min(Ax + dis, 63) do
          begin
            dis0 := abs(i1 - Ax);
            for i2 := max(Ay - dis + dis0, 0) to min(Ay + dis - dis0, 63) do
            begin
              BField[4, i1, i2] := (abs(i1 - Bx) + abs(i2 - By)) * 2 + 1;
            end;
          end;
          //if (abs(i1 - Ax) + abs(i2 - Ay)) <= range then
          //Bfield[4, i1, i2] := 1;
        end;
        3: //目标系方型、原地系方型
        begin
          for i1 := max(Ax - range, 0) to min(Ax + range, 63) do
            for i2 := max(Ay - range, 0) to min(Ay + range, 63) do
            begin
              if MODVersion = 81 then
                BField[4, i1, i2] := 1
              else
                BField[4, i1, i2] := abs(i1 - Bx) + abs(i2 - By) * 2 + random(24) + 1;
            end;
        end;
        1: //方向系线型
        begin
          i := 1;
          i1 := sign(Ax - Bx);
          i2 := sign(Ay - By);
          if i1 > 0 then
            step := min(63 - Bx, step);
          if i2 > 0 then
            step := min(63 - By, step);
          if i1 < 0 then
            step := min(Bx, step);
          if i2 < 0 then
            step := min(By, step);
          if (i1 = 0) and (i2 = 0) then
            step := 0;
          while i <= step do
          begin
            BField[4, Bx + i1 * i, By + i2 * i] := i * 2 + 1;
            i := i + 1;
          end;
        end;
        2: //原地系十型、原地系叉型、原地系米型
        begin
          for i1 := max(Bx - step, 0) to min(Bx + step, 63) do
            BField[4, i1, By] := abs(i1 - Bx) * 4;
          for i2 := max(By - step, 0) to min(By + step, 63) do
            BField[4, Bx, i2] := abs(i2 - By) * 4;
          for i := 1 to range do
          begin
            i1 := -i;
            while i1 <= i do
            begin
              i2 := -i;
              while i2 <= i do
              begin
                if (Bx + i1 in [0..63]) and (By + i2 in [0..63]) then
                  BField[4, Bx + i1, By + i2] := 2 * i * 2 + 1;
                i2 := i2 + 2 * i;
              end;
              i1 := i1 + 2 * i;
            end;
          end;
        end;
        4: //方向系菱型
        begin
          step1 := (step + 1) div 2;
          Ax1 := Bx + sign(Ax - Bx) * step1;
          Ay1 := By + sign(Ay - By) * step1;
          dis := step div 2;
          for i1 := max(Ax1 - dis, 0) to min(Ax1 + dis, 63) do
          begin
            dis0 := abs(i1 - Ax1);
            for i2 := max(Ay1 - dis + dis0, 0) to min(Ay1 + dis - dis0, 63) do
            begin
              if abs(i1 - Bx) <> abs(i2 - By) then
                BField[4, i1, i2] := abs(i1 - Bx) + abs(i2 - By) * 2 + 1;
            end;
          end;
          //Bfield[4, Bx, By] := 0;
        end;
        5: //方向系角型
        begin
          Ax1 := Bx + sign(Ax - Bx) * step;
          Ay1 := By + sign(Ay - By) * step;
          dis := step;
          for i1 := max(Ax1 - dis, 0) to min(Ax1 + dis, 63) do
          begin
            dis0 := abs(i1 - Ax1);
            for i2 := max(Ay1 - dis + dis0, 0) to min(Ay1 + dis - dis0, 63) do
            begin
              if (i1 in [0..63]) and (i2 in [0..63]) and (abs(i1 - Bx) <= step) and (abs(i2 - By) <= step) then
                BField[4, i1, i2] := abs(i1 - Bx) + abs(i2 - By) * 2 + 1;
            end;
          end;
          //Bfield[4, Bx, By] := 0;
        end;
        7: //啥东西？
        begin
          if ((Ax = Bx) and (i2 = Ay) and (abs(i1 - Ax) <= step)) or ((Ay = By) and (i1 = Ax) and
            (abs(i2 - Ay) <= step)) then
            BField[4, i1, i2] := 1;
        end;
      end;
  end;

  {if play = 1 then
  begin
    for i1:=0 to 63 do
    for i2:=0 to 63 do
    if Bfield[4, i1, i2] = 1 then
  begin
    Bfield[4, i1, i2] := abs(i1 - Bx) + abs(i2 - By) * 4;
  end;
  end;}

end;

//显示武功效果

procedure PlayMagicAmination(bnum, enum: integer; aimMode: integer = 0; mode: integer = 0);
var
  beginpic, i, i1, i2, endpic, x, y, z, min, max, rnum: integer;
  posA, posB: TPosition;
begin
  min := 1000;
  max := 0;
  for i1 := 0 to 63 do
    for i2 := 0 to 63 do
    begin
      if BField[4, i1, i2] > 0 then
      begin
        if BField[4, i1, i2] > max then
          max := BField[4, i1, i2];
        if BField[4, i1, i2] < min then
          min := BField[4, i1, i2];
      end;
    end;

  beginpic := 0;
  //含音效
  posA := GetPositionOnScreen(Ax, Ay, CENTER_X, CENTER_Y);
  posB := GetPositionOnScreen(Bx, By, CENTER_X, CENTER_Y);
  x := posA.x - posB.x;
  y := posB.y - posA.y;
  z := -((Ax + Ay) - (Bx + By)) * 9;

  PlaySound(enum, 0, x, y, z);
  {for i := 0 to enum - 1 do
    beginpic := beginpic + effectlist[i];
  endpic := beginpic + effectlist[enum] - 1;}
  rnum := Brole[bnum].rnum;

  if enum <= High(EPNGIndex) then
  begin
    if EPNGIndex[enum].Loaded = 0 then
    begin
      EPNGIndex[enum].Amount := LoadPNGTiles(formatfloat('resource/eft/eft000', enum),
        EPNGIndex[enum].PNGIndexArray, 1);
      EPNGIndex[enum].Loaded := 1;
    end;
    endpic := EPNGIndex[enum].Amount;
  end
  else
    endpic := 0;
  Redraw;
  i := 0;
  while (SDL_PollEvent(@event) >= 0) do
  begin
    CheckBasicEvent;
    DrawBFieldWithEft(i, beginpic, endpic, min, bnum, aimMode, mode, $FFFFFFFF, enum);
    UpdateAllScreen;
    //updateallscreen;
    SDL_Delay(BATTLE_SPEED);
    i := i + 1;
    if i > endpic + max - min then
      break;
    //writeln(k);
  end;
  needOffset := 0;
  event.key.keysym.sym := 0;
  event.button.button := 0;
end;

//判断是否有非行动方角色在攻击范围之内, 以及对状态的控制

procedure CalHurtRole(bnum, mnum, level: integer; mode: integer = 0);
var
  i, rnum, hurt, addpoi, mp, hurt1: integer;
  k, j, s, temp, i1, neinum, neilevel: integer;
begin

  rnum := Brole[bnum].rnum;
  {if Rrole[rnum].CurrentMP < Rmagic[mnum].NeedMP * ((level + 1) div 2) then
    level := Rrole[rnum].CurrentMP div Rmagic[mnum].NeedMP * 2;
  if level > 10 then
    level := 10;
  writeln(Rrole[rnum].CurrentMP, level, Rmagic[mnum].NeedMP);}
  for i := 0 to BRoleAmount - 1 do
  begin
    if (BField[4, Brole[i].X, Brole[i].Y] > 0) and (Brole[bnum].Team <> Brole[i].Team) and
      (Brole[i].Dead = 0) and (bnum <> i) then
    begin
      Brole[i].ShowNumber := -1;
      //生命伤害
      if (Rmagic[mnum].HurtType = 0) or (Rmagic[mnum].HurtType = 6) then
      begin
        hurt := CalHurtValue(bnum, i, mnum, level, mode) + Brole[bnum].AntiHurt;
        //刀系福利, 伤害有几率翻倍
        if (Rmagic[mnum].MagicType = 3) and (random(1000) < Rrole[rnum].Knife *
          (100 + Brole[bnum].StateLevel[31]) div 100) then
          hurt := min(9999, trunc(hurt * (15 + random(16)) / 10));

        //拳系福利, 几率降低目标的攻防轻
        if (Rmagic[mnum].MagicType = 1) and (random(1000) < Rrole[rnum].Fist *
          (100 + Brole[bnum].StateLevel[29]) div 100) then
        begin
          if random(100) < 30 then
            ModifyState(i, 0, -30, 3);
          if random(100) < 30 then
            ModifyState(i, 1, -30, 3);
          if random(100) < 30 then
            ModifyState(i, 2, -30, 3);
        end;

        //特系福利, 几率打成脑残
        if (Rmagic[mnum].MagicType = 4) and (random(5000) < Rrole[rnum].Unusual *
          (100 + Brole[bnum].StateLevel[32]) div 100) then
          ModifyState(i, 28, -1, 3);

        //暗系福利, 几率降低移动
        if (Rmagic[mnum].MagicType = 5) and (random(100) < 10 * (100 + Brole[bnum].StateLevel[33]) div 100) then
          ModifyState(i, 3, -(Rrole[rnum].HidWeapon div 200), 3);

        //以下是状态影响最终伤害的处理, 主要是守方的被动状态
        //4 受伤害增加或减少
        hurt := (100 - Brole[i].StateLevel[4]) * hurt div 100;
        Brole[i].ShowNumber := hurt;

        //15, 靈精, 内力代替
        if random(100) < Brole[i].StateLevel[15] then
        begin
          Rrole[Brole[i].rnum].CurrentMP := Rrole[Brole[i].rnum].CurrentMP - hurt;
          if Rrole[Brole[i].rnum].CurrentMP <= 0 then
            Rrole[Brole[i].rnum].CurrentMP := 0;
          //Rrole[Brole[i].rnum].Hurt := Rrole[Brole[i].rnum].Hurt + hurt div LIFE_HURT;
          Brole[i].ShowNumber := hurt;
          hurt := 0;
        end;

        //16 奇门, 不受伤
        temp := random(100);
        if temp < Brole[i].StateLevel[16] then
        begin
          //Rrole[Brole[i].rnum].CurrentHP := Rrole[Brole[i].rnum].CurrentHP - hurt;
          hurt := 1;
          Brole[i].ShowNumber := hurt;
        end;

        //14 乾坤, 反弹
        if Brole[i].StateLevel[14] > 0 then
        begin
          hurt1 := hurt * Brole[i].StateLevel[14] div 100;
          hurt := max(hurt - hurt1, 0);
          Brole[i].ShowNumber := hurt;
          Brole[bnum].ShowNumber := hurt1;
          Brole[bnum].AntiHurt := hurt1;
          Rrole[Brole[bnum].rnum].CurrentHP := Rrole[Brole[bnum].rnum].CurrentHP - hurt1;
          BField[4, Brole[bnum].X, Brole[bnum].Y] := 20;
        end;

        //吸星融功法
        for i1 := 0 to 3 do
        begin
          neinum := Rrole[Brole[i].rnum].neigong[i1];
          if neinum <= 0 then
            break;
          if Rmagic[neinum].AddMP[3] > 0 then
          begin
            hurt := hurt div 2;
            Rrole[Brole[i].rnum].CurrentMP := Rrole[Brole[i].rnum].CurrentMP + hurt;
            if mode = 1 then
              ShowStringOnBrole(pWideChar(@Rmagic[neinum].Name) + UTF8Decode('·融功'), i, 1);
            if Rrole[Brole[i].rnum].CurrentMP > Rrole[Brole[i].rnum].MaxMP then
              Rrole[Brole[i].rnum].CurrentMP := Rrole[Brole[i].rnum].MaxMP;
          end;
        end;

        if (Brole[i].loverlevel[6] > 0) and (Brole[Brole[i].loverlevel[6]].dead = 0) then
        begin
          //情侣, 替代受伤
          Brole[Brole[i].loverlevel[6]].ShowNumber := hurt;
          Rrole[Brole[i].loverlevel[6]].CurrentHP := Rrole[Brole[i].loverlevel[6]].CurrentHP - hurt;
          //if Rrole[brole[i].loverlevel[6]].CurrentHP<0 then Rrole[brole[i].loverlevel[6]].CurrentHP:=0;
        end
        else
        begin
          //慈悲状态, 替代减血
          if Brole[i].StateLevel[23] > 0 then
          begin
            Brole[Brole[i].StateLevel[23]].ShowNumber := hurt;
            BField[4, Brole[Brole[i].StateLevel[23]].X, Brole[Brole[i].StateLevel[23]].Y] := 1;
            BField[4, Brole[i].X, Brole[i].Y] := 0;
            Rrole[Brole[Brole[i].StateLevel[23]].rnum].CurrentHP :=
              Rrole[Brole[Brole[i].StateLevel[23]].rnum].CurrentHP - hurt;
            //受伤
            Rrole[Brole[Brole[i].StateLevel[23]].rnum].Hurt :=
              Rrole[Brole[Brole[i].StateLevel[23]].rnum].Hurt + hurt * 100 div
              Rrole[Brole[Brole[i].StateLevel[23]].rnum].MAXHP div LIFE_HURT;
          end
          else
          begin
            //内功影响, 减血同时减体、减内, 伤害转内力
            for i1 := 0 to 3 do
            begin
              neinum := Rrole[Brole[bnum].rnum].neigong[i1];
              if neinum <= 0 then
                break;
              neilevel := Rrole[Brole[bnum].rnum].NGLevel[i1] div 100 + 1;
              if Rmagic[neinum].AttDistance[6] > 0 then
              begin
                Rrole[Brole[i].rnum].PhyPower :=
                  Rrole[Brole[i].rnum].PhyPower - Rmagic[neinum].AttDistance[6] * neilevel;
                if mode = 1 then
                  ShowStringOnBrole(pWideChar(@Rmagic[neinum].Name) + UTF8Decode('·殺體'), i, 2);
                if Rrole[Brole[i].rnum].PhyPower < 1 then
                  Rrole[Brole[i].rnum].PhyPower := 1;
              end;
              if Rmagic[neinum].AttDistance[8] > 0 then
              begin
                Rrole[Brole[i].rnum].CurrentMP :=
                  Rrole[Brole[i].rnum].CurrentMP - Rmagic[neinum].AttDistance[8] * neilevel;
                if mode = 1 then
                  ShowStringOnBrole(pWideChar(@Rmagic[neinum].Name) + UTF8Decode('·殺内'), i, 1);
                if Rrole[Brole[i].rnum].CurrentMP < 1 then
                  Rrole[Brole[i].rnum].CurrentMP := 1;
              end;
              if Rmagic[neinum].AddMP[2] = 4 then
              begin //龙卷罡气, 重伤
                Rrole[Brole[i].rnum].Hurt :=
                  Rrole[Brole[i].rnum].Hurt + 3 * neilevel;
                if mode = 1 then
                  ShowStringOnBrole(pWideChar(@Rmagic[neinum].Name) + UTF8Decode('·重傷'), i, 1);
                if Rrole[Brole[i].rnum].Hurt > 100 then
                  Rrole[Brole[i].rnum].Hurt := 100;
              end;
            end;
            //普通减血
            Brole[i].ShowNumber := hurt;
            Rrole[Brole[i].rnum].CurrentHP := Rrole[Brole[i].rnum].CurrentHP - hurt;
            //受伤
            Rrole[Brole[i].rnum].Hurt := Rrole[Brole[i].rnum].Hurt + hurt * 100 div
              Rrole[Brole[i].rnum].MAXHP div LIFE_HURT;
          end;

          if Rrole[Brole[i].rnum].Hurt > 99 then
            Rrole[Brole[i].rnum].Hurt := 99;
        end;
        //if Rrole[Brole[i].rnum].CurrentHP <= 0 then Brole[bnum].ExpGot := Brole[bnum].ExpGot + hurt div 2;
        //把敌人打死获得30到50的经验值
        if Rrole[Brole[i].rnum].CurrentHP <= 0 then
        begin
          Rrole[Brole[i].rnum].CurrentHP := 0;
          case MODVersion of
            13: Brole[bnum].ExpGot := Brole[bnum].ExpGot + 30 + random(20);
            else
              Brole[bnum].ExpGot := Brole[bnum].ExpGot + 300 + random(20) * 10;
          end;
        end;
      end;
      //内力伤害
      if (Rmagic[mnum].HurtType = 1) or (Rmagic[mnum].HurtType = 6) then
      begin
        hurt := Rmagic[mnum].HurtMP[level - 1] + random(5) - random(5);
        if Rmagic[mnum].HurtType <> 6 then
          Brole[i].ShowNumber := hurt;
        Rrole[Brole[i].rnum].CurrentMP := Rrole[Brole[i].rnum].CurrentMP - hurt;
        if Rrole[Brole[i].rnum].CurrentMP <= 0 then
          Rrole[Brole[i].rnum].CurrentMP := 0;
        //增加己方内力及最大值
        Rrole[rnum].CurrentMP := Rrole[rnum].CurrentMP + hurt;
        Rrole[rnum].MaxMP := Rrole[rnum].MaxMP + random(hurt div 2);
        if Rrole[rnum].MaxMP > MAX_MP then
          Rrole[rnum].MaxMP := MAX_MP;
        if Rrole[rnum].CurrentMP > Rrole[rnum].MaxMP then
          Rrole[rnum].CurrentMP := Rrole[rnum].MaxMP;
      end;
      //中毒
      addpoi := Rrole[rnum].AttPoi div 5 + Rmagic[mnum].Poison * level div 2 - Rrole[Brole[i].rnum].DefPoi;
      if (Rmagic[mnum].AttAreaType = 6) and (Brole[i].StateLevel[11] > 0) then
        addpoi := addpoi + Brole[i].StateLevel[11]; //毒箭状态
      if addpoi + Rrole[Brole[i].rnum].Poison > 99 then
        addpoi := 99 - Rrole[Brole[i].rnum].Poison;
      if addpoi < 0 then
        addpoi := 0;
      if Rrole[Brole[i].rnum].DefPoi >= 99 then
        addpoi := 0;
      Rrole[Brole[i].rnum].Poison := Rrole[Brole[i].rnum].Poison + addpoi;
    end;
    if Brole[bnum].AntiHurt > 0 then
      Brole[bnum].AntiHurt := 0;
  end;
end;

//计算伤害值, 第一公式如小于0则取一个随机数, 无第二公式

function CalHurtValue(bnum1, bnum2, mnum, level: integer; mode: integer = 0): integer;
var
  i, j, rnum1, rnum2, mhurt, R1Att, R1Def, R2Att, R2Def, att, def, k1, k2, dis, neinum,
  neilevel, livenum, speed1, speed2: integer;
  p, p2, p3, p4: real;
  R1, R2: TRole;
  B1, B2: TBattleRole;
begin
  //以下是状态影响属性的处理, 攻守方均可能中此类状态

  rnum1 := Brole[bnum1].rnum; //攻方人物编号
  rnum2 := Brole[bnum2].rnum; //防方人物编号

  R1 := Rrole[rnum1];
  R2 := Rrole[rnum2];
  B1 := Brole[bnum1];
  B2 := Brole[bnum2];

  //攻击状态、防御状态、情侣的攻防加成
  R1Att := max(0, R1.Attack * (100 + b1.StateLevel[0] + b1.loverlevel[0]) div 100);
  R2Def := max(0, R2.Defence * (100 + b2.StateLevel[1] + b2.loverLevel[1]) div 100);

  //如果有武器, 增加攻击, 检查配合列表
  if r1.Equip[0] >= 0 then
  begin
    R1att := R1att + Ritem[r1.Equip[0]].AddAttack;
    for i := 0 to 4 do
    begin
      if (Ritem[r1.Equip[0]].GetItem[i] = mnum) then
      begin
        R1att := R1att + Ritem[r1.Equip[0]].NeedMatAmount[i];
        break;
      end;
    end;
  end;
  //防具增加攻击
  if r1.Equip[1] >= 0 then
    R1att := R1att + Ritem[r1.Equip[1]].AddAttack;
  //武器, 防具增加防御
  if r2.Equip[0] >= 0 then
    R2def := R2def + Ritem[r2.Equip[0]].AddDefence;
  if r2.Equip[1] >= 0 then
    R2def := R2def + Ritem[r2.Equip[1]].AddDefence;

  //9号状态, 孤注, 随生命减少而攻击增加
  if b1.StateLevel[9] > 0 then
  begin
    R1Att := R1Att * (r1.MaxHP * 2 - r1.CurrentHP) div r1.MaxHP;
  end;

  //计算双方武学常识
  k1 := 0;
  k2 := 0;
  for i := 0 to BRoleAmount - 1 do
  begin
    if (Brole[i].Team = Brole[bnum1].Team) and (Brole[i].Dead = 0) and
      (Rrole[Brole[i].rnum].Knowledge > MIN_KNOWLEDGE) then
      k1 := k1 + Rrole[Brole[i].rnum].Knowledge;
    if (Brole[i].Team = Brole[bnum2].Team) and (Brole[i].Dead = 0) and
      (Rrole[Brole[i].rnum].Knowledge > MIN_KNOWLEDGE) then
      k2 := k2 + Rrole[Brole[i].rnum].Knowledge;
  end;

  //10号状态, 倾国
  for i := 0 to BRoleAmount - 1 do
  begin
    if (Brole[i].Dead = 0) and (Brole[i].StateLevel[10] > 0) then
      if Brole[i].Team = b1.Team then
        k1 := k1 + Brole[i].StateLevel[10]
      else if Brole[i].Team = b2.Team then
        k2 := k2 + Brole[i].StateLevel[10];
  end;


  //武功伤害
  //mhurt := Rmagic[mnum].Attack[level - 1];
  mhurt := Rmagic[mnum].Attack[0] + (Rmagic[mnum].Attack[1] - Rmagic[mnum].Attack[0]) * level div 10;

  //内功影响武功伤害
  p := 1;
  p2 := 1;
  p3 := 1;
  p4 := 1;
  for i := 0 to 3 do
  begin
    neinum := Rrole[Brole[bnum1].rnum].neigong[i];
    if neinum <= 0 then
      break;
    neilevel := Rrole[Brole[bnum1].rnum].NGLevel[i] div 100 + 1;
    if ((Rmagic[neinum].MoveDistance[0] = 6) or (Rmagic[neinum].MoveDistance[0] = Rmagic[mnum].MagicType)) and
      (Rmagic[neinum].MoveDistance[1] >= Rmagic[mnum].Attack[1] div 100) then
      p := max(p, (100 + Rmagic[neinum].movedistance[2] + (Rmagic[neinum].movedistance[3] -
        Rmagic[neinum].movedistance[2]) * neilevel / 10) / 100);

    //特定武功加成
    if Rmagic[neinum].AttDistance[4] = mnum then
    begin
      p2 := 1 + 0.1 * neilevel;
    end;

    //资质对武功加成, 段家心法
    if Rmagic[neinum].AttDistance[7] > 0 then
    begin
      p3 := (Rmagic[neinum].AttDistance[7] * Rrole[rnum1].Aptitude) / 100;
    end;

    //我方剩余人数加成, 神龙吟
    if Rmagic[neinum].AttDistance[9] > 0 then
    begin
      livenum := 0;
      for j := 0 to BRoleAmount - 1 do
        if (Brole[j].Team = B1.Team) and (Brole[j].Dead = 0) then
          livenum := livenum + 1;
      p4 := 1 + livenum * 0.05 * Rmagic[neinum].AttDistance[9];
    end;

  end;

  mhurt := trunc(mhurt * p * p2 * p3 * p4); //数据设好之后恢复此句
  //mhurt := trunc(mhurt * p);

  //情侣技影响武功伤害
  if Brole[bnum1].loverlevel[4] > 0 then
    mhurt := mhurt * (100 + Brole[bnum1].loverlevel[4]) div 100;

  //轻功加成
  if Rmagic[mnum].Attack[3] > 0 then
  begin
    p := (R1.Speed * (b1.StateLevel[2] + Rmagic[mnum].Attack[3]) / 100 / 500) + 1;
    for i := 0 to 3 do
    begin
      neinum := R1.neigong[i];
      if neinum <= 0 then
        break;
      neilevel := R1.NGLevel[i] div 100 + 1;
      if Rmagic[neinum].MoveDistance[8] > 0 then
      begin
        p := p * (100 + Rmagic[neinum].MoveDistance[8] + (Rmagic[neinum].MoveDistance[9] -
          Rmagic[neinum].MoveDistance[8]) * neilevel / 10) / 100;
      end;
    end;
    mhurt := trunc(mhurt * p);
  end;

  //内力加成
  if Rmagic[mnum].Attack[2] > 0 then
  begin
    p := (R1.MaxMP * (Rmagic[mnum].Attack[2] + Brole[bnum1].loverlevel[5]) / 100 / 9999) + 1;
    for i := 0 to 3 do
    begin
      neinum := R1.neigong[i];
      if neinum <= 0 then
        break;
      neilevel := R1.NGLevel[i] div 100 + 1;
      if Rmagic[neinum].MoveDistance[6] > 0 then
      begin
        p := p * (100 + Rmagic[neinum].MoveDistance[6] + (Rmagic[neinum].MoveDistance[7] -
          Rmagic[neinum].MoveDistance[6]) * neilevel / 10) / 100;
      end;
    end;
    mhurt := trunc(mhurt * p);
  end;

  //总攻击
  if (Rmagic[mnum].MagicType = 5) then
    att := k1 + R1.HidWeapon * 2 + mhurt div 2
  else
    att := k1 + R1Att + mhurt div 2;

  //总防御
  def := R2Def;

  //内功影响防御
  for i := 0 to 3 do
  begin
    neinum := R2.neigong[i];
    if neinum <= 0 then
      break;
    neilevel := R2.NGLevel[i] div 100 + 1;
    if Rmagic[neinum].MoveDistance[4] > 0 then
    begin
      def := def * (100 + Rmagic[neinum].MoveDistance[4] + (Rmagic[neinum].MoveDistance[5] -
        Rmagic[neinum].MoveDistance[4]) * neilevel div 10) div 100;
      if mode = 1 then
        ShowStringOnBrole(pWideChar(@Rmagic[neinum].Name) + UTF8Decode('·剛體'), bnum2, 3);
    end;
  end;

  //武常影响防御
  def := def + k2;

  //攻击, 防御按受伤的折扣
  att := att * (100 - Rrole[rnum1].Hurt div 2) div 100;
  def := def * (100 - Rrole[rnum2].Hurt div 2) div 100;
  att := max(att, 0);
  def := max(def, 0);
  //总公式
  //result := (att - def) *2 div 3 + random(20) - random(20);
  //分母仅在二者都为0时才为零, 此时认为攻击失败
  if att + def > 0 then
    Result := trunc((1.0 * att * att) / (att + def) / 2 + random(10) - random(10))
  else
    Result := 10 + random(10) - random(10);
  //result := ( att * att ) div ( att + def ) div 4;
  //writeln(att, ', ', def, ' ,', Result);
  //距离衰减

  dis := abs(b1.X - b2.X) + abs(b1.Y - b2.Y);
  if dis > 10 then
    dis := 10;
  Result := Result * (100 - (dis - 1) * 3) div 100;

  //轻功闪避
  speed1 := R1.Speed * (100 + b1.StateLevel[2] + b1.loverlevel[9]) div 100;
  speed2 := R2.Speed * (100 + b2.StateLevel[2] + b2.loverLevel[9]) div 100;

  if (speed2 >= speed1) then
  begin
    p := 1 - ((speed2 - speed1) / 360);
    if (p < 0) then
      p := 0;
    Result := trunc(Result * p);
  end;

  if (Result <= 10) or (level <= 0) then
    Result := random(10) + 1;
  if (Result > 9999) then
    Result := 9999;

  //if (r2.CurrentHP - result < 0) then result := r2.CurrentHP;
  //showmessage(inttostr(result));
  {x50[28004] := Result;
  x50[28001] := bnum1;
  x50[28002] := mnum;
  x50[28003] := rnum2;
  //CallEvent(401);
  Result := x50[28004];}

end;

function CalHurtValue2(bnum1, bnum2, mnum, level: integer; mode: integer = 0): integer;
begin
  case Rmagic[mnum].HurtType of
    1:
    begin
      Result := Rmagic[mnum].HurtMP[level - 1] div 5;
      if Rrole[Brole[bnum1].rnum].CurrentMP < Rrole[Brole[bnum1].rnum].MaxMP div 10 then
        Result := Result * 3;
    end;
    else
    begin
      Result := CalHurtValue(bnum1, bnum2, mnum, level, mode);
      if Result >= Rrole[Brole[bnum2].rnum].CurrentHP then
        Result := Result * 3 div 2;
    end;
  end;

end;

procedure SelectColor(mode: integer; var color1, color2: uint32; var formatstr: string);
begin
  case mode of
    0, 6: //伤血
    begin
      color1 := ColColor($10);
      color2 := ColColor($13);
      formatstr := '-%d';
    end;
    1: //伤内
    begin
      color1 := ColColor($50);
      color2 := ColColor($53);
      formatstr := '-%d';
    end;
    2: //中毒
    begin
      color1 := ColColor($30);
      color2 := ColColor($32);
      formatstr := '+%d';
    end;
    3: //医疗
    begin
      color1 := ColColor($7);
      color2 := ColColor($5);
      formatstr := '+%d';
    end;
    4: //解毒
    begin
      color1 := ColColor($91);
      color2 := ColColor($93);
      formatstr := '-%d';
    end;
  end;
end;

//显示数字: 0-红色负, 1-紫色负, 2-绿色正, 3-黄色正, 4-蓝色负

procedure ShowHurtValue(mode: integer; team: integer = 0; fstr: string = '');
var
  i, i1, x, y: integer;
  color1, color2: uint32;
  word: array of WideString;
  str: string;
begin
  SelectColor(mode, color1, color2, str);
  if fstr <> '' then
    str := fstr;
  setlength(word, BRoleAmount);
  for i := 0 to BRoleAmount - 1 do
  begin
    if Brole[i].ShowNumber > 0 then
    begin
      if mode = 5 then //先天一阳指, 我方加血, 敌方减血
        if Brole[i].Team = team then
          str := '+%d'
        else
          str := '-%d';
      word[i] := format(str, [Brole[i].ShowNumber]);
    end;
    Brole[i].ShowNumber := -1;
  end;
  i1 := 0;
  while SDL_PollEvent(@event) >= 0 do
  begin
    CheckBasicEvent;
    Redraw;
    for i := 0 to BRoleAmount - 1 do
    begin
      if mode = 5 then //先天一阳指, 我方加血, 敌方减血
        if Brole[i].Team = team then
        begin
          color1 := ColColor($7);
          color2 := ColColor($5);
        end
        else
        begin
          color1 := ColColor($10);
          color2 := ColColor($13);
        end;
      x := -(Brole[i].X - Bx) * 18 + (Brole[i].Y - By) * 18 + CENTER_X - 5 * length(word[i]);
      y := (Brole[i].X - Bx) * 9 + (Brole[i].Y - By) * 9 + CENTER_Y - 40;
      if word[i] <> '' then
        DrawEngShadowText(@word[i, 1], x, y - i1 * 2, color1, color2);
    end;
    SDL_Delay(BATTLE_SPEED);
    UpdateAllScreen;
    i1 := i1 + 1;
    if i1 > 10 then
      break;
  end;
  Redraw;
  UpdateAllScreen;
end;


procedure ShowStringOnBrole(str: WideString; bnum, mode: integer; up: integer = 1);
var
  len, i1, i2, x, y: integer;
  color1, color2: uint32;
  formatstr: string;
  p: puint16;
begin
  if EFFECT_STRING = 1 then
  begin
    SetFontSize(18, 16);
    SelectColor(mode, color1, color2, formatstr);

    len := DrawLength(str);

    x := -(Brole[bnum].X - Bx) * 18 + (Brole[bnum].Y - By) * 18 + CENTER_X - 10;
    y := (Brole[bnum].X - Bx) * 9 + (Brole[bnum].Y - By) * 9 + CENTER_Y - 40;
    i1 := 0;
    i2 := 5 - sign(up) * 5;
    while SDL_PollEvent(@event) >= 0 do
    begin
      CheckBasicEvent;
      Redraw;
      DrawShadowText(@str[1], x - 9 * len div 2 + 5, y - i2 * 2, color1, color2);
      SDL_Delay(BATTLE_SPEED);
      UpdateAllScreen;
      i1 := i1 + 1;
      i2 := i2 + up;
      if (i1 > 10) or (i2 > 10) or (i2 < 0) then
        break;
    end;
    Redraw;
    SetFontSize(20, 18);
  end;
end;


//计算中毒减少的生命

procedure CalPoiHurtLife;
var
  i: integer;
  p: boolean;
begin
  p := False;
  for i := 0 to BRoleAmount - 1 do
  begin
    Brole[i].ShowNumber := -1;
    if (Rrole[Brole[i].rnum].Poison > 0) and (Brole[i].Dead = 0) and (Brole[i].Acted = 1) then
    begin
      Rrole[Brole[i].rnum].CurrentHP := Rrole[Brole[i].rnum].CurrentHP - Rrole[Brole[i].rnum].Poison - 5 + random(5);
      if Rrole[Brole[i].rnum].CurrentHP <= 0 then
        Rrole[Brole[i].rnum].CurrentHP := 1;
      //Brole[i].ShowNumber := Rrole[Brole[i].rnum, 20] div 2+1;
      //p := true;
    end;
  end;
  //if p then showhurtvalue(0);

end;

//设置生命低于0的人物为已阵亡, 主要是清除所占的位置

procedure ClearDeadRolePic;
var
  i, j, i1, i2, rnum, bpicnum: integer;
  pos: TPosition;
  //tempsur, tempsur2, tempsur3: PSDL_Surface;
  //dest: TSDL_Rect;
  needeffect: boolean;
begin
  //检测是否需要效果
  needeffect := False;
  for i := 0 to BRoleAmount - 1 do
  begin
    if (Rrole[Brole[i].rnum].CurrentHP <= 0) and (Brole[i].Dead = 0) then
    begin
      needeffect := True;
      break;
    end;
  end;
  //撤退渐变效果
  j := 0;
  while (SDL_PollEvent(@event) >= 0) and needeffect do
  begin
    CheckBasicEvent;
    for i := 0 to BRoleAmount - 1 do
    begin
      if (Rrole[Brole[i].rnum].CurrentHP <= 0) and (Brole[i].Dead = 0) then
      begin
        Brole[i].mixColor := 0;
        Brole[i].mixAlpha := j;
        Brole[i].alpha := j;
      end;
    end;

    DrawBfield;

    UpdateAllScreen;
    SDL_Delay(BATTLE_SPEED div 2);
    j := j + 5;
    if j > 100 then
      break;
  end;
  //注意, 这段代码每次攻击后都会执行, 因此需注意去掉某些状态
  for i := 0 to BRoleAmount - 1 do
  begin
    if Rrole[Brole[i].rnum].CurrentHP <= 0 then
    begin
      Brole[i].Dead := 1;
      BField[2, Brole[i].X, Brole[i].Y] := -1;
      //Brole[i].X := 0;
      //Brole[i].Y := 0;
      //伤逝状态, 被击退时敌人攻击防御下降
      //如果敌人有攻击防御正面状态, 强制设为-20%, 如有负面状态则叠加
      if Brole[i].StateLevel[21] > 0 then
      begin

        Brole[i].StateLevel[21] := 0;
        Brole[i].StateLevel[21] := 0;
        for j := 0 to BRoleAmount - 1 do
        begin
          if (Brole[j].Team <> Brole[i].team) and (Brole[j].Dead = 0) then
          begin
            if Brole[j].StateLevel[0] > 0 then
            begin
              Brole[j].StateLevel[0] := -20;
              Brole[j].StateRound[0] := 3;
            end
            else
            begin
              Brole[j].StateLevel[0] := Brole[j].StateLevel[0] - 20;
              Brole[j].StateRound[0] := Brole[j].StateRound[0] + 3;
            end;
            if Brole[j].StateLevel[1] > 0 then
            begin
              Brole[j].StateLevel[1] := -20;
              Brole[j].StateRound[1] := 3;
            end
            else
            begin
              Brole[j].StateLevel[1] := Brole[j].StateLevel[1] - 20;
              Brole[j].StateRound[1] := Brole[j].StateRound[1] + 3;
            end;
            Rrole[Brole[j].rnum].Hurt := Rrole[Brole[j].rnum].Hurt + 10;
          end;
        end;
      end;

      //去掉慈悲状态
      for j := 0 to BRoleAmount - 1 do
        if Brole[j].StateLevel[23] = Brole[i].rnum then
        begin
          Brole[j].StateLevel[23] := 0;
          Brole[j].StateRound[23] := 0;
        end;
      //bmount
    end;
  end;
  for i := 0 to BRoleAmount - 1 do
    if Brole[i].Dead = 0 then
      BField[2, Brole[i].X, Brole[i].Y] := i;

end;


//等待, 似乎不太完善

procedure Wait(bnum: integer);
var
  i, i1, i2, x: integer;
begin
  Brole[bnum].Acted := 0;
  Brole[BRoleAmount] := Brole[bnum];

  for i := bnum to BRoleAmount - 1 do
    Brole[i] := Brole[i + 1];

  for i := 0 to BRoleAmount - 1 do
  begin
    if Brole[i].Dead = 0 then
      BField[2, Brole[i].X, Brole[i].Y] := i
    else
      BField[2, Brole[i].X, Brole[i].Y] := -1;
  end;

end;

//战斗结束恢复人物状态

procedure RestoreRoleStatus;
var
  i, j, rnum: integer;
begin
  for i := 0 to BRoleAmount - 1 do
  begin
    rnum := Brole[i].rnum;
    //回复状态
    //Rrole[rnum].State := 0;
    for j := 0 to STATUS_AMOUNT - 1 do
    begin
      Brole[i].StateLevel[j] := 0;
      Brole[i].StateRound[j] := 0;
    end;

    //我方恢复部分生命, 内力; 敌方恢复全部
    if Brole[i].Team = 0 then
    begin
      Rrole[rnum].CurrentHP := Rrole[rnum].CurrentHP + Rrole[rnum].MaxHP div 2;
      if Rrole[rnum].CurrentHP <= 0 then
        Rrole[rnum].CurrentHP := 1;
      if Rrole[rnum].CurrentHP > Rrole[rnum].MaxHP then
        Rrole[rnum].CurrentHP := Rrole[rnum].MaxHP;
      Rrole[rnum].CurrentMP := Rrole[rnum].CurrentMP + Rrole[rnum].MaxMP div 20;
      if Rrole[rnum].CurrentMP > Rrole[rnum].MaxMP then
        Rrole[rnum].CurrentMP := Rrole[rnum].MaxMP;
      Rrole[rnum].PhyPower := Rrole[rnum].PhyPower + MAX_PHYSICAL_POWER div 2;
      if Rrole[rnum].PhyPower > MAX_PHYSICAL_POWER then
        Rrole[rnum].PhyPower := MAX_PHYSICAL_POWER;
    end
    else
    begin
      Rrole[rnum].Hurt := 0;
      Rrole[rnum].Poison := 0;
      Rrole[rnum].CurrentHP := Rrole[rnum].MaxHP;
      Rrole[rnum].CurrentMP := Rrole[rnum].MaxMP;
      Rrole[rnum].PhyPower := MAX_PHYSICAL_POWER * 9 div 10;
    end;
  end;

  //恢复0号人物的森罗万象
  if MODVersion in [0, 13] then
    Rrole[0].Magic[0] := 278;

end;



//增加经验

procedure AddExp;
var
  i, mnum, mlevel, i1, i2, rnum, basicvalue, amount, levels, p, x, y: integer;
  str: WideString;
begin
  levels := 0;
  amount := 0;
  for i := 0 to BRoleAmount - 1 do
  begin
    if (Brole[i].Team = 0) and (Brole[i].Dead = 0) then
    begin
      levels := levels + Rrole[Brole[i].rnum].Level;
      amount := amount + 1;
    end;
  end;
  p := 0;

  TransBlackScreen;
  //str:=' 戰鬥勝利';
  //drawtextwithrect(@str[1], CENTER_X - 250, 40, 86, colcolor($21), colcolor($23));
  //display_img(pchar(AppPath + 'resource/bw.png'), CENTER_X - 260, 15);
  DrawMPic(2003, CENTER_X - 260, CENTER_Y - 240 + 15);
  for i := 0 to BRoleAmount - 1 do
  begin
    rnum := Brole[i].rnum;
    //amount := Calrnum(0);
    if amount > 0 then
      basicvalue := warsta.ExpGot div amount
    else
      basicvalue := 0;

    {//太岳四侠练功, 20级以上不得经验
    if (Rrole[rnum].Level >= 20) and (warsta.Warnum = 31) then
      basicvalue := 0;
    //桃谷六仙练功, 40级以上不得经验
    if (Rrole[rnum].Level >= 40) and (warsta.Warnum = 160) then
      basicvalue := 0;}

    //basicvalue :=  0;
    if (Brole[i].Team = 0) and (Brole[i].Dead = 0) then
    begin
      //  if rrole[Brole[i].rnum].Level < warsta.exp then
      //  begin
      //    Rrole[rnum].Exp := Rrole[rnum].Exp + Brole[i].ExpGot;
      //    basicvalue:=trunc(300*(power(1.5,warsta.exp - rrole[Brole[i].rnum].level+1)));
      //  end
      //  else
      //    basicvalue:=trunc(300*power(1.5,warsta.exp - rrole[Brole[i].rnum].level));

      //  if basicvalue>3000 then basicvalue:=3000;

      mnum := Ritem[Rrole[rnum].PracticeBook].Magic;
      mlevel := GetMagicLevel(rnum, mnum);

      basicvalue := basicvalue + Brole[i].ExpGot;
      Rrole[rnum].Exp := min(65535, Rrole[rnum].Exp + basicvalue);

      if mlevel < 10 then
      begin
        Rrole[rnum].ExpForBook := Rrole[rnum].ExpForBook + basicvalue div 5 * 4;
      end;
      if p >= 6 then
      begin
        UpdateAllScreen;
        Redraw;
        p := 0;
        TransBlackScreen;
        WaitAnyKey;
        //display_img(pchar(AppPath + 'resource/bw.png'), CENTER_X - 260, 15);
        //str:='戰鬥勝利';
        //drawtextwithrect(@str[1], CENTER_X - 250, 40, 86, colcolor($21), colcolor($23));
      end;
      x := CENTER_X - 270 + p mod 2 * 270;
      y := CENTER_Y - 240 + 90 + p div 2 * 110;
      Rrole[rnum].ExpForItem := Rrole[rnum].ExpForItem + basicvalue div 5 * 3;
      ShowSimpleStatus(rnum, x, y);
      //DrawRectangle(screen, x + 100, y+83, 145, 25, 0, colcolor(255), 25);
      //str := '得經驗';
      //Drawshadowtext(@str[1], x + 100 - 17, y+85, colcolor($21), colcolor($23));
      str := UTF8Decode(format('經驗+%d', [basicvalue]));
      DrawTextWithRect(@str[1], x, y + 70, 0, ColColor($64), ColColor($66), 40, 0);
      p := p + 1;
    end;

  end;
  UpdateAllScreen;
  Redraw;
  WaitAnyKey;

end;

//检查是否能够升级

procedure CheckLevelUp;
var
  i, rnum: integer;
begin
  for i := 0 to BRoleAmount - 1 do
  begin
    rnum := Brole[i].rnum;
    while (uint16(Rrole[rnum].Exp) >= uint16(LevelUplist[Rrole[rnum].Level - 1])) and
      (Rrole[rnum].Level < MAX_LEVEL) do
    begin
      Rrole[rnum].Exp := Rrole[rnum].Exp - LevelUplist[Rrole[rnum].Level - 1];
      LevelUp(i);
    end;
  end;

end;

//升级, 如是我方人物显示状态

procedure LevelUp(bnum: integer; rnum: integer = -1);
var
  i, add, levelA: integer;
  str: WideString;
begin
  if rnum < 0 then
    rnum := Brole[bnum].rnum;

  if (bnum >= 0) and (Brole[bnum].Team = 0) then
  begin
    Redraw;
    TransBlackScreen;
    ShowStatus(rnum, -1);
    //showsimplestatus(rnum,  CENTER_X - 300,50);
    //str := '升級';
    //Drawtextwithrect(@str[1], 50, CENTER_Y - 150, 46, colcolor($21), colcolor($23));
    //waitanykey;
  end;
  Rrole[rnum].Level := Rrole[rnum].Level + 1;
  if Rrole[rnum].IncLife >= 8 then
    Rrole[rnum].MaxHP := Rrole[rnum].MaxHP + (Rrole[rnum].IncLife - 8 + random(10)) * 3
  else
    Rrole[rnum].MaxHP := Rrole[rnum].MaxHP + Rrole[rnum].IncLife + random(5);
  if random(100) > Rrole[rnum].Aptitude then
    Rrole[rnum].MaxHP := Rrole[rnum].MaxHP + random(5);
  if Rrole[rnum].MaxHP > MAX_HP then
    Rrole[rnum].MaxHP := MAX_HP;
  Rrole[rnum].CurrentHP := Rrole[rnum].MaxHP;

  if Rrole[rnum].AddMP >= 8 then
    Rrole[rnum].MaxMP := Rrole[rnum].MaxMP + (Rrole[rnum].AddMP - 8 + random(10)) * 3
  else
    Rrole[rnum].MaxMP := Rrole[rnum].MaxMP + Rrole[rnum].AddMP + random(5);
  if random(100) > Rrole[rnum].Aptitude then
    Rrole[rnum].MaxMP := Rrole[rnum].MaxMP + random(5);
  if Rrole[rnum].MaxMP > MAX_MP then
    Rrole[rnum].MaxMP := MAX_MP;
  Rrole[rnum].CurrentMP := Rrole[rnum].MaxMP;

  Rrole[rnum].Attack := Rrole[rnum].Attack + 3 - random(2) + random(Rrole[rnum].AddAtk);
  Rrole[rnum].Defence := Rrole[rnum].Defence + 3 - random(2) + random(Rrole[rnum].AddDef);

  Rrole[rnum].Speed := Rrole[rnum].Speed + 1 + random(Rrole[rnum].AddSpeed);

  for i := 46 to 54 do
  begin
    //抗毒不增加
    if (Rrole[rnum].Data[i] > 20) and (i <> 49) then
      Rrole[rnum].Data[i] := Rrole[rnum].Data[i] + random(3);
  end;
  for i := 43 to 54 do
  begin
    if Rrole[rnum].Data[i] > MaxProList[i] then
      Rrole[rnum].Data[i] := MaxProList[i];
  end;

  Rrole[rnum].PhyPower := MAX_PHYSICAL_POWER;
  Rrole[rnum].Hurt := 0;
  Rrole[rnum].Poison := 0;

  if (bnum >= 0) and (Brole[bnum].Team = 0) then
  begin
    ShowStatus(rnum, -2);
    ShowSimpleStatus(rnum, CENTER_X - 150, CENTER_Y - 240 + 10);
    //str := '升級';
    //Drawtextwithrect(@str[1], 50, CENTER_Y - 150, 46, colcolor($21), colcolor($23));
    UpdateAllScreen;
    WaitAnyKey;
  end;

end;

//检查身上秘笈

procedure CheckBook;
var
  i, i1, i2, p, rnum, inum, mnum, mlevel, needexp, needitem, needitemamount, itemamount: integer;
  str: WideString;
begin
  for i := 0 to BRoleAmount - 1 do
  begin
    rnum := Brole[i].rnum;
    inum := Rrole[rnum].PracticeBook;
    if inum >= 0 then
    begin
      mnum := Ritem[inum].Magic;
      mlevel := max(1, GetMagicLevel(rnum, mnum));
      while (mlevel < 10) do
      begin
        needexp := trunc((1 + (mlevel - 1) * 0.5) * Ritem[Rrole[rnum].PracticeBook].NeedExp *
          (1 + (7 - Rrole[rnum].Aptitude / 15) * 0.5));
        if (Rrole[rnum].ExpForBook >= needexp) and (mlevel < 10) then
        begin
          Redraw;
          TransBlackScreen;
          EatOneItem(rnum, inum);
          WaitAnyKey;
          Redraw;
          TransBlackScreen;
          UpdateAllScreen;
          if mnum > 0 then
          begin
            instruct_33(rnum, mnum, 1);
          end;
          mlevel := mlevel + 1;
          Rrole[rnum].ExpForBook := Rrole[rnum].ExpForBook - needexp;
        end
        else
          break;
      end;

      //是否能够炼出物品
      if (Rrole[rnum].ExpForItem >= Ritem[inum].NeedExpForItem) and (Ritem[inum].NeedExpForItem > 0) and
        (Brole[i].Team = 0) then
      begin
        //Redraw;
        //TransBlackScreen;
        p := 0;
        for i2 := 0 to 4 do
        begin
          if Ritem[inum].GetItem[i2] >= 0 then
            p := p + 1;
        end;
        p := random(p);
        needitem := Ritem[inum].NeedMaterial;
        if Ritem[inum].GetItem[p] >= 0 then
        begin
          needitemamount := Ritem[inum].NeedMatAmount[p];
          itemamount := 0;
          for i2 := 0 to MAX_ITEM_AMOUNT - 1 do
            if RItemList[i2].Number = needitem then
            begin
              itemamount := RItemList[i2].Amount;
              break;
            end;
          if needitemamount <= itemamount then
          begin
            Redraw;
            TransBlackScreen;
            ShowSimpleStatus(rnum, CENTER_X - 150, CENTER_Y - 240 + 70);
            //DrawRectangle(CENTER_X - 150 + 30, CENTER_Y - 240 + 170,{115, 63,} 90, 25, 0, ColColor(255), 25);
            DrawTextFrame(CENTER_X - 150, CENTER_Y - 240 + 170, 4);
            str := '製得物品';
            DrawShadowText(@str[1], CENTER_X - 150 + 19, CENTER_Y - 240 + 173, 0, $202020);
            instruct_2(Ritem[inum].GetItem[p], 30 + random(25));
            UpdateAllScreen;
            instruct_32(needitem, -needitemamount);
            Rrole[rnum].ExpForItem := 0;
            //WaitAnyKey;
          end;
        end;
        //ShowStatus(rnum);
        //waitanykey;
      end;
    end;
  end;

end;

//统计一方人数

function CalRNum(team: integer): integer;
var
  i: integer;
begin
  Result := 0;
  for i := 0 to BRoleAmount - 1 do
  begin
    if (Brole[i].Team = team) and (Brole[i].Dead = 0) then
      Result := Result + 1;
  end;

end;

//战斗中物品选单

procedure BattleMenuItem(bnum: integer);
var
  rnum, inum, mode: integer;
  str: WideString;
begin
  if MenuItem then
  begin
    inum := CurItem;
    rnum := Brole[bnum].rnum;
    mode := Ritem[inum].ItemType;
    case mode of
      3:
      begin
        Redraw;
        TransBlackScreen;
        EatOneItem(rnum, inum);
        instruct_32(inum, -1);
        Brole[bnum].Acted := 1;
        WaitAnyKey;
      end;
      4:
      begin
        if MODVersion <> 13 then
          UseHiddenWeapon(bnum, inum);
      end;
    end;
  end;

end;

//动作动画

procedure PlayActionAmination(bnum, mode: integer);
var
  rnum, i, beginpic, endpic, IDX, GRP, tnum, len, Ax1, Ay1, actnum, k: integer;
  filename: string;
begin
  //暗器类用特殊的动作
  if mode = 5 then
    mode := 4;

  Ax1 := Ax;
  Ay1 := Ay;
  //方向至少朝向一个将被打中的敌人
  k := 0;
  for i := 0 to BRoleAmount - 1 do
  begin
    if (Brole[i].Team <> Brole[bnum].Team) and (Brole[i].Dead = 0) and (BField[4, Brole[i].X, Brole[i].Y] > 0) then
    begin
      k := k + 1;
      if random(k) = 0 then
      begin
        Ax1 := Brole[i].X;
        Ay1 := Brole[i].Y;
      end;
    end;
  end;
  if (Ax1 <> Bx) or (Ay1 <> By) then
    Brole[bnum].Face := CalFace(Bx, By, Ax1, Ay1);

  Redraw;
  rnum := Brole[bnum].rnum;
  actnum := Rrole[rnum].ActionNum;
  if rnum = 0 then
    actnum := 0;

  //计算动作帧数
  //if Rrole[rnum].AmiFrameNum[mode] > 0 then
  //如果对应帧数小于等于0, 则寻找第一个不为零的帧数
  if FPNGIndex[actnum].FightFrame[mode] <= 0 then
  begin
    for mode := 0 to 4 do
      if FPNGIndex[actnum].FightFrame[mode] > 0 then
        break;
  end;
  if FPNGIndex[actnum].FightFrame[mode] > 0 then
  begin
    beginpic := 0;
    for i := 0 to 4 do
    begin
      if i >= mode then
        break;
      //beginpic := beginpic + Rrole[rnum].AmiFrameNum[i] * 4;
      beginpic := beginpic + FPNGIndex[actnum].FightFrame[i] * 4;
    end;
    //beginpic := beginpic + Brole[bnum].Face * Rrole[rnum].AmiFrameNum[mode];
    //endpic := beginpic + Rrole[rnum].AmiFrameNum[mode] - 1;
    beginpic := beginpic + Brole[bnum].Face * FPNGIndex[actnum].FightFrame[mode];
    endpic := beginpic + FPNGIndex[actnum].FightFrame[mode] - 1;

    //filename := formatfloat('fight/fight000', Rrole[rnum].HeadNum);
    //LoadIdxGrp(filename + '.idx', filename + '.grp', FIdx, FPic);

    i := beginpic;
    while (SDL_PollEvent(@event) >= 0) do
    begin
      CheckBasicEvent;
      DrawBFieldWithAction(bnum, i);
      UpdateAllScreen;
      //updateallscreen;
      SDL_Delay(BATTLE_SPEED);
      i := i + 1;
      if i > endpic then
      begin
        Brole[bnum].Pic := endpic;
        break;
      end;
    end;
  end;

end;

//用毒

procedure UsePoison(bnum: integer);
var
  rnum, bnum1, rnum1, poi, step, addpoi, minDefPoi, i: integer;
  select: boolean;
  str: WideString;
begin
  rnum := Brole[bnum].rnum;
  poi := Rrole[rnum].UsePoi;
  step := poi div 15 + 1;
  CalCanSelect(bnum, 1, step);
  SelectAimMode := 0;
  if (Brole[bnum].Team = 0) and (Brole[bnum].Auto = 0) then
    select := SelectAim(bnum, step)
  else
  begin
    minDefPoi := MaxProList[49];
    //showmessage(inttostr(mindefpoi));
    for i := 0 to BRoleAmount - 1 do
    begin
      if (Brole[i].Dead = 0) and (Brole[i].Team <> Brole[bnum].Team) then
      begin
        if (Rrole[Brole[i].rnum].DefPoi <= minDefPoi) and (Rrole[Brole[i].rnum].Poison < 100) and
          (BField[3, Brole[i].X, Brole[i].Y] >= 0) then
        begin
          //bnum1 := i;
          minDefPoi := Rrole[Brole[i].rnum].DefPoi;
          //showmessage(inttostr(mindefpoi));
          Select := True;
          Ax := Brole[i].X;
          Ay := Brole[i].Y;
        end;
      end;
    end;
  end;
  if (BField[2, Ax, Ay] >= 0) and (select = True) then
  begin
    Brole[bnum].Acted := 1;
    Rrole[rnum].PhyPower := Rrole[rnum].PhyPower - 3;
    bnum1 := BField[2, Ax, Ay];
    if Brole[bnum1].Team <> Brole[bnum].Team then
    begin
      rnum1 := Brole[bnum1].rnum;
      addpoi := Rrole[rnum].UsePoi div 3 - Rrole[rnum1].DefPoi div 4;
      if addpoi < 0 then
        addpoi := 0;
      if addpoi + Rrole[rnum1].Poison > 99 then
        addpoi := 99 - Rrole[rnum1].Poison;
      Rrole[rnum1].Poison := Rrole[rnum1].Poison + addpoi;
      Brole[bnum1].ShowNumber := addpoi;
      Brole[bnum].ExpGot := Brole[bnum].ExpGot + addpoi div 5;
      str := UTF8Decode('使毒');
      ShowMagicName(2, str);
      SetAminationPosition(0, 0, 0);
      PlayActionAmination(bnum, 0);
      PlayMagicAmination(bnum, 30, 0, 2);
      ShowHurtValue(2);
    end;
  end;
end;

//医疗

procedure Medcine(bnum: integer);
var
  rnum, bnum1, rnum1, med, step, addlife: integer;
  select: boolean;
  str: WideString;
begin
  rnum := Brole[bnum].rnum;
  med := Rrole[rnum].Medcine;
  step := med div 15 + 1;
  CalCanSelect(bnum, 1, step);
  SelectAimMode := 1;
  if (Brole[bnum].Team = 0) and (Brole[bnum].Auto = 0) then
    select := SelectAim(bnum, step)
  else
  begin
    if BField[3, Ax, Ay] >= 0 then
      select := True;
  end;
  if (BField[2, Ax, Ay] >= 0) and (select = True) then
  begin
    Brole[bnum].Acted := 1;
    Rrole[rnum].PhyPower := Rrole[rnum].PhyPower - 4;
    bnum1 := BField[2, Ax, Ay];
    if Brole[bnum1].Team = Brole[bnum].Team then
    begin
      rnum1 := Brole[bnum1].rnum;
      addlife := med * 3 - Rrole[rnum1].Hurt + random(10) - 5;
      if addlife < 0 then
        addlife := 0;
      //if Rrole[rnum1].Hurt - med > 20 then
      //  addlife := 0;
      //if Rrole[rnum1].Hurt > 66 then
      //  addlife := 0;

      if addlife + Rrole[rnum1].CurrentHP > Rrole[rnum1].MaxHP then
        addlife := Rrole[rnum1].MaxHP - Rrole[rnum1].CurrentHP;
      Rrole[rnum1].CurrentHP := Rrole[rnum1].CurrentHP + addlife;
      Rrole[rnum1].Hurt := Rrole[rnum1].Hurt - addlife div 10 div LIFE_HURT;
      if Rrole[rnum1].Hurt < 0 then
        Rrole[rnum1].Hurt := 0;
      Brole[bnum].ExpGot := Brole[bnum].ExpGot + addlife div 10;
      Brole[bnum1].ShowNumber := addlife;
      str := UTF8Decode('醫療');
      ShowMagicName(3, str);
      SetAminationPosition(0, 0, 0);
      PlayActionAmination(bnum, 0);
      PlayMagicAmination(bnum, 29, 1, 3);
      ShowHurtValue(3);
    end;
  end;

end;

//解毒

procedure MedPoison(bnum: integer);
var
  rnum, bnum1, rnum1, medpoi, step, minuspoi: integer;
  select: boolean;
  str: WideString;
begin
  rnum := Brole[bnum].rnum;
  medpoi := Rrole[rnum].MedPoi;
  step := medpoi div 15 + 1;
  CalCanSelect(bnum, 1, step);
  SelectAimMode := 1;
  if (Brole[bnum].Team = 0) and (Brole[bnum].Auto = 0) then
    select := SelectAim(bnum, step)
  else
  begin
    if BField[3, Ax, Ay] >= 0 then
      select := True;
  end;
  if (BField[2, Ax, Ay] >= 0) and (select = True) then
  begin
    Brole[bnum].Acted := 1;
    Rrole[rnum].PhyPower := Rrole[rnum].PhyPower - 5;
    bnum1 := BField[2, Ax, Ay];
    if Brole[bnum1].Team = Brole[bnum].Team then
    begin
      rnum1 := Brole[bnum1].rnum;
      minuspoi := Rrole[rnum].MedPoi;
      if minuspoi < 0 then
        minuspoi := 0;
      if Rrole[rnum1].Poison - minuspoi <= 0 then
        minuspoi := Rrole[rnum1].Poison;
      Rrole[rnum1].Poison := Rrole[rnum1].Poison - minuspoi;
      Brole[bnum1].ShowNumber := minuspoi;
      Brole[bnum].ExpGot := Brole[bnum].ExpGot + minuspoi div 5;
      str := UTF8Decode('解毒');
      ShowMagicName(4, str);
      SetAminationPosition(0, 0, 0);
      PlayActionAmination(bnum, 0);
      PlayMagicAmination(bnum, 36, 1, 4);
      ShowHurtValue(4);
    end;
  end;

end;

//使用暗器

procedure UseHiddenWeapon(bnum, inum: integer);
var
  rnum, bnum1, rnum1, hidden, step, hurt, poison, i, maxhurt, eventnum: integer;
  select: boolean;
  str: WideString;
begin
  //calcanselect(bnum, 1);
  rnum := Brole[bnum].rnum;
  hidden := Rrole[rnum].HidWeapon;
  step := min(10, hidden div 15 + 1);
  CalCanSelect(bnum, 1, step);
  select := False;
  if inum < 0 then
    eventnum := -1
  else
    eventnum := Ritem[inum].UnKnow7;
  if eventnum > 0 then
    CallEvent(eventnum)
  else
  begin
    if (Brole[bnum].Team = 0) and (Brole[bnum].Auto = 0) then
    begin
      SelectAimMode := 0;
      select := SelectAim(bnum, step);
    end
    else
    begin
      if BField[3, Ax, Ay] >= 0 then
      begin
        select := True;
      end;
    end;
    if (BField[2, Ax, Ay] >= 0) and (select = True) and (Brole[BField[2, Ax, Ay]].Team <> Brole[bnum].Team) then
    begin
      //如果自动, 选择伤害最大的暗器
      if (Brole[bnum].Team = 0) and (Brole[bnum].Auto <> 0) then
      begin
        inum := -1;
        maxhurt := 0;
        for i := 0 to MAX_ITEM_AMOUNT - 1 do
        begin
          if (RItemList[i].Amount > 0) and (RItemList[i].Number >= 0) then
            if (Ritem[RItemList[i].Number].ItemType = 4) and (Ritem[RItemList[i].Number].AddCurrentHP < maxhurt) then
            begin
              maxhurt := Ritem[RItemList[i].Number].AddCurrentHP;
              inum := RItemList[i].Number;
            end;
        end;
      end;
      if (Brole[bnum].Team <> 0) then
      begin
        begin
          inum := -1;
          maxhurt := 0;
          for i := 0 to 3 do
          begin
            if (Rrole[rnum].TakingItemAmount[i] > 0) and (Rrole[rnum].TakingItem[i] >= 0) then
              if (Ritem[Rrole[rnum].TakingItem[i]].ItemType = 4) and
                (Ritem[Rrole[rnum].TakingItem[i]].AddCurrentHP < maxhurt) then
              begin
                maxhurt := Ritem[RItemList[i].Number].AddCurrentHP;
                inum := RItemList[i].Number;
              end;
          end;
        end;
      end;

      if inum >= 0 then
      begin
        Brole[bnum].Acted := 1;
        if Brole[bnum].Team = 0 then
          instruct_32(inum, -1)
        else
          instruct_41(rnum, inum, -1);

        bnum1 := BField[2, Ax, Ay];
        if Brole[bnum1].Team <> Brole[bnum].Team then
        begin
          rnum1 := Brole[bnum1].rnum;
          //hurt := Rrole[rnum].HidWeapon - Ritem[inum].AddCurrentHP - Rrole[rnum1].HidWeapon;
          //hurt := max(hurt * (Rrole[rnum1].Hurt div 33 + 1), 1 + random(10));
          //Rrole[rnum1].CurrentHP := Rrole[rnum1].CurrentHP - hurt;
          //Brole[bnum1].ShowNumber := hurt;
          //Brole[bnum1].ExpGot := Brole[bnum1].ExpGot + hurt;
          //Rrole[rnum1].Hurt := min(Rrole[rnum1].Hurt + hurt div LIFE_HURT, 99);
          Rrole[rnum1].Poison := min(Rrole[rnum1].Poison + Ritem[inum].AddPoi *
            (100 - Rrole[rnum1].DefPoi) div 100, 99);
          SetAminationPosition(0, 0, 0);
          str := pWideChar(@Ritem[inum].Name);
          ShowMagicName(inum, str);
          PlayActionAmination(bnum, 0);
          PlayMagicAmination(bnum, Ritem[inum].AmiNum);
          Rmagic[0].HurtType := 0;
          Rmagic[0].MagicType := 5;
          Rmagic[0].Attack[0] := -Ritem[inum].AddCurrentHP;
          Rmagic[0].Attack[1] := -Ritem[inum].AddCurrentHP * 3;
          CalHurtRole(bnum, 0, RegionParameter(Rrole[rnum].HidWeapon div 50, 1, 10));
          ShowHurtValue(0);
        end;
      end;
    end;
  end;

end;

//调息和回合结束, 依据Acted的标记来判断是否已经移动过,
//调息仅在不移动时可用, 正常状态下, 少量恢复血、内、体
//若已中毒或受伤, 不恢复血内体, 少量减轻中毒和受伤程度
//内功, 可大量恢复血内体
//已经移动过则使用回合结束少量恢复状态
//被定身不能调息
procedure Rest(bnum: integer);
var
  rnum, i, j, curehurt, curepoison, neinum, neilevel, step: integer;
begin
  //step := CalBroleMoveAbililty(bnum);
  if (Brole[bnum].Moved > 0) or (Brole[bnum].StateLevel[26] < 0) then
  begin
    rnum := Brole[bnum].rnum;
    Rrole[rnum].PhyPower := min(Rrole[rnum].PhyPower + MAX_PHYSICAL_POWER div 15, MAX_PHYSICAL_POWER);
    Brole[bnum].Acted := 1;
  end
  else
  begin
    Brole[bnum].Acted := 1;
    rnum := Brole[bnum].rnum;
    i := 50;
    curehurt := 2;
    curepoison := 2;

    if (Rrole[rnum].Hurt <= 0) and (Rrole[rnum].Poison <= 0) then
    begin
      Rrole[rnum].CurrentHP := min(Rrole[rnum].CurrentHP + 2 + Rrole[rnum].MaxHP div i, Rrole[rnum].MaxHP);
      Rrole[rnum].PhyPower := min(Rrole[rnum].PhyPower + MAX_PHYSICAL_POWER div 15, MAX_PHYSICAL_POWER);
      Rrole[rnum].CurrentMP := min(Rrole[rnum].CurrentMP + 2 + Rrole[rnum].MaxMP div i, Rrole[rnum].MaxMP);
    end
    else
    begin
      if Rrole[rnum].Hurt > 0 then
        Rrole[rnum].Hurt := Rrole[rnum].Hurt - curehurt;
      if Rrole[rnum].Poison > 0 then
        Rrole[rnum].Poison := Rrole[rnum].Poison - curepoison;
    end;

    for j := 0 to 3 do
    begin
      neinum := Rrole[Brole[bnum].rnum].neigong[j];
      if neinum <= 0 then
        break;
      neilevel := Rrole[Brole[bnum].rnum].NGLevel[j] div 100 + 1;
      if Rmagic[neinum].AttDistance[0] > 0 then
      begin
        Rrole[Brole[bnum].rnum].CurrentMP :=
          Rrole[Brole[bnum].rnum].CurrentMP + Rrole[Brole[bnum].rnum].MaxMP *
          (Rmagic[neinum].AttDistance[0] + (Rmagic[neinum].AttDistance[1] - Rmagic[neinum].AttDistance[0]) *
          neilevel div 10) div 100;
        ShowStringOnBrole(pWideChar(@Rmagic[neinum].Name) + UTF8Decode('·回内'), bnum, 3);
      end;
      Rrole[Brole[bnum].rnum].CurrentMP := min(Rrole[Brole[bnum].rnum].CurrentMP, Rrole[Brole[bnum].rnum].MaxMP);
      if Rmagic[neinum].AttDistance[2] > 0 then
      begin
        Rrole[Brole[bnum].rnum].CurrentHP :=
          Rrole[Brole[bnum].rnum].CurrentHP + Rrole[Brole[bnum].rnum].MaxHP *
          (Rmagic[neinum].AttDistance[2] + (Rmagic[neinum].AttDistance[3] - Rmagic[neinum].AttDistance[2]) *
          neilevel div 10) div 100;
        ShowStringOnBrole(pWideChar(@Rmagic[neinum].Name) + UTF8Decode('·回命'), bnum, 3);
      end;
      Rrole[Brole[bnum].rnum].CurrentHP := min(Rrole[Brole[bnum].rnum].CurrentHP, Rrole[Brole[bnum].rnum].MaxHP);
      if Rmagic[neinum].AddMP[4] > 0 then
      begin
        Rrole[Brole[bnum].rnum].PhyPower := Rrole[Brole[bnum].rnum].PhyPower + Rmagic[neinum].AddMP[4];
        ShowStringOnBrole(pWideChar(@Rmagic[neinum].Name) + UTF8Decode('·回體'), bnum, 3);
      end;
      Rrole[Brole[bnum].rnum].PhyPower := min(Rrole[Brole[bnum].rnum].PhyPower, MAX_PHYSICAL_POWER);
    end;
  end;

end;


//The AI.

procedure AutoBattle(bnum: integer);
{var
  i, p, a, temp, rnum, inum, eneamount, aim, mnum, level, Ax1, Ay1, i1, i2, step, step1, dis0, dis: integer;
  str: WideString;}
begin
  {rnum := Brole[bnum].rnum;
  ShowSimpleStatus(rnum, 50, CENTER_Y * 2 - 160);
  SDL_Delay(BATTLE_SPEED * 25);
  //showmessage('');
  //Life is less than 20%, 70% probality to medcine or eat a pill.
  //生命低于20%, 70%可能医疗或吃药
  if (Brole[bnum].Acted = 0) and (Rrole[rnum].CurrentHP < Rrole[rnum].MaxHP div 5) then
  begin
    if random(100) < 70 then
    begin
      //医疗大于50, 且体力大于50才对自身医疗
      if (Rrole[rnum].Medcine >= 50) and (Rrole[rnum].PhyPower >= 50) and (random(100) < 50) then
      begin
        Medcine(bnum);
      end
      else
      begin
        // if can't medcine, eat the item which can add the most life on its body.
        //无法医疗则选择身上加生命最多的药品, 我方从物品栏选择
        AutoUseItem(bnum, 45);
      end;
    end;
  end;

  //MP is less than 20%, 60% probality to eat a pill.
  //内力低于20%, 60%可能吃药
  if (Brole[bnum].Acted = 0) and (Rrole[rnum].CurrentMP < Rrole[rnum].MaxMP div 5) then
  begin
    if random(100) < 60 then
    begin
      AutoUseItem(bnum, 50);
    end;
  end;

  //Physical power is less than 20%, 80% probality to eat a pill.
  //体力低于20%, 80%可能吃药
  if (Brole[bnum].Acted = 0) and (Rrole[rnum].PhyPower < MAX_PHYSICAL_POWER div 5) then
  begin
    if random(100) < 80 then
    begin
      AutoUseItem(bnum, 48);
    end;
  end;

  //如未能吃药且体力大于10, 则尝试攻击
  if (Brole[bnum].Acted = 0) and (Rrole[rnum].PhyPower >= 10) then
  begin
    //在敌方选择一个人物
    eneamount := CalRNum(1 - Brole[bnum].Team);
    aim := random(eneamount) + 1;
    //showmessage(inttostr(eneamount));
    for i := 0 to BRoleAmount - 1 do
    begin
      if (Brole[bnum].Team <> Brole[i].Team) and (Brole[i].Dead = 0) then
      begin
        aim := aim - 1;
        if aim <= 0 then
          break;
      end;
    end;
    //Seclect one enemy randomly and try to close it.
    //尝试走到离敌人最近的位置
    Ax := Bx;
    Ay := By;
    Ax1 := Brole[i].X;
    Ay1 := Brole[i].Y;
    CalCanSelect(bnum, 0, Brole[bnum].step);
    dis0 := abs(Ax1 - Bx) + abs(Ay1 - By);
    for i1 := min(Ax1, Bx) to max(Ax1, Bx) do
      for i2 := min(Ay1, By) to max(Ay1, By) do
      begin
        if Bfield[3, i1, i2] >= 0 then
        begin
          dis := abs(Ax1 - i1) + abs(Ay1 - i2);
          if (dis < dis0) and (abs(i1 - Bx) + abs(i2 - By) <= Brole[bnum].Step) then
          begin
            Ax := i1;
            Ay := i2;
            dis0 := dis;
          end;
        end;
      end;
    if Bfield[3, Ax, Ay] >= 0 then
      MoveAmination(bnum);
    Ax := Brole[i].X;
    Ay := Brole[i].Y;

    //Try to attack it. select the best WUGONG.
    //使用目前最强的武功攻击
    p := 0;
    a := 0;
    temp := 0;
    for i1 := 0 to 9 do
    begin
      mnum := Rrole[rnum].Magic[i1];
      if mnum > 0 then
      begin
        a := a + 1;
        level := Rrole[rnum].MagLevel[i1] div 100 + 1;
        if Rrole[rnum].CurrentMP < Rmagic[mnum].NeedMP * ((level + 1) div 2) then
          level := Rrole[rnum].CurrentMP div Rmagic[mnum].NeedMP * 2;
        if level > 10 then
          level := 10;
        if level <= 0 then
          level := 1;
        if Rmagic[mnum].Attack[level - 1] > temp then
        begin
          p := i1;
          temp := Rmagic[mnum].Attack[level - 1];
        end;
      end;
    end;
    //5% probility to re-select WUGONG randomly.
    //5%的可能重新选择武功
    if random(100) < 5 then
      p := random(a);

    //If the most powerful Wugong can't attack the aim,
    //re-select the one which has the longest attatck-distance.
    //如最强武功打不到, 选择攻击距离最远的武功
    if abs(Ax - Bx) + abs(Ay - By) > step then
    begin
      p := 0;
      a := 0;
      temp := 0;
      for i1 := 0 to 9 do
      begin
        mnum := Rrole[rnum].Magic[i1];
        if mnum > 0 then
        begin
          level := Rrole[rnum].MagLevel[i1] div 100 + 1;
          a := Rmagic[mnum].MoveDistance[level - 1];
          if Rmagic[mnum].AttAreaType = 3 then
            a := a + Rmagic[mnum].AttDistance[level - 1];
          if a > temp then
          begin
            p := i1;
            temp := a;
          end;
        end;
      end;
    end;

    mnum := Rrole[rnum].Magic[p];
    level := Rrole[rnum].MagLevel[p] div 100 + 1;
    step := Rmagic[mnum].MoveDistance[level - 1];
    step1 := 0;
    if Rmagic[mnum].AttAreaType = 3 then
      step1 := Rmagic[mnum].AttDistance[level - 1];
    if abs(Ax - Bx) + abs(Ay - By) <= step + step1 then
    begin
      //step := Rmagic[mnum, 28+level-1];
      if (Rmagic[mnum].AttAreaType = 3) then
      begin
        //step1 := Rmagic[mnum, 38+level-1];
        dis := 0;
        Ax1 := Bx;
        Ay1 := By;
        for i1 := min(Ax, Bx) to max(Ax, Bx) do
          for i2 := min(Ay, By) to max(Ay, By) do
          begin
            if (abs(i1 - Ax) <= step1) and (abs(i2 - Ay) <= step1) and
              (abs(i1 - Bx) + abs(i2 - By) <= step + step1) then
            begin
              if dis < abs(i1 - Bx) + abs(i2 - By) then
              begin
                dis := abs(i1 - Bx) + abs(i2 - By);
                Ax1 := i1;
                Ay1 := i2;
              end;
            end;
          end;
        Ax := Ax1;
        Ay := Ay1;
      end;
      if Rmagic[mnum].AttAreaType <> 3 then
        SetAminationPosition(Rmagic[mnum].AttAreaType, step, step1)
      else
        SetAminationPosition(Rmagic[mnum].AttAreaType, step, step1);

      if bfield[4, Ax, Ay] <> 0 then
      begin
        Brole[bnum].Acted := 1;
        for i1 := 0 to Brole[bnum].StateLevel[13] + Rrole[Brole[bnum].rnum].addnum do
        begin
          Rrole[rnum].MagLevel[p] := Rrole[rnum].MagLevel[p] + random(2) + 1;
          if Rrole[rnum].MagLevel[p] > 999 then
            Rrole[rnum].MagLevel[p] := 999;
          if Rmagic[mnum].UnKnow[4] > 0 then
          begin
            //rmagic[mnum].UnKnow[4] := strtoint(InputBox('Enter name', 'ssss', '10'));
            execscript(PChar('script\SpecialMagic' + IntToStr(Rmagic[mnum].UnKnow[4]) + '.lua'),
              PChar('f' + IntToStr(Rmagic[mnum].UnKnow[4])));
            if Rmagic[mnum].NeedMP * (level + 1) div 2 > Rrole[rnum].CurrentMP then
            begin
              level := Rrole[rnum].CurrentMP div Rmagic[mnum].NeedMP * 2;
            end;
            Rrole[rnum].CurrentMP := Rrole[rnum].CurrentMP - Rmagic[mnum].NeedMP * (level + 1) div 2;
            if Rrole[rnum].CurrentMP < 0 then
              Rrole[rnum].CurrentMP := 0;
          end
          else
            AttackAction(bnum, mnum, level);
        end;
      end;
    end;
  end;

  //If all other actions fail, rest.
  //如果上面行动全部失败则休息
  if Brole[bnum].Acted = 0 then
    Rest(bnum);

  //检查是否有esc被按下
  if SDL_PollEvent(@event) >= 0 then
  begin
    CheckBasicEvent;
    if (event.key.keysym.sym = SDLK_ESCAPE) then
    begin
      Brole[bnum].Auto := 0;
    end;
  end;}
end;

//自动使用list的值最大的物品
//test 仅检测是否有相关物品

function AutoUseItem(bnum, list: integer; test: integer = 0): boolean;
var
  i, p, temp, rnum, inum: integer;
  str: WideString;
begin
  rnum := Brole[bnum].rnum;
  if Brole[bnum].Team <> 0 then
  begin
    temp := 0;
    p := -1;
    for i := 0 to 3 do
    begin
      if Rrole[rnum].TakingItem[i] >= 0 then
      begin
        if Ritem[Rrole[rnum].TakingItem[i]].Data[list] > temp then
        begin
          temp := Ritem[Rrole[rnum].TakingItem[i]].Data[list];
          p := i;
        end;
      end;
    end;
  end
  else
  begin
    temp := 0;
    p := -1;
    for i := 0 to MAX_ITEM_AMOUNT - 1 do
    begin
      if (RItemList[i].Amount > 0) and (Ritem[RItemList[i].Number].ItemType = 3) then
      begin
        if Ritem[RItemList[i].Number].Data[list] > temp then
        begin
          temp := Ritem[RItemList[i].Number].Data[list];
          p := i;
        end;
      end;
    end;
  end;

  if (p >= 0) and (test = 0) then
  begin
    if Brole[bnum].Team <> 0 then
      inum := Rrole[rnum].TakingItem[p]
    else
      inum := RItemList[p].Number;
    Redraw;
    UpdateAllScreen;
    EatOneItem(rnum, inum);
    if Brole[bnum].Team <> 0 then
      instruct_41(rnum, Rrole[rnum].TakingItem[p], -1)
    else
      instruct_32(RItemList[p].Number, -1);
    Brole[bnum].Acted := 1;
    SDL_Delay(500);
  end;
  Result := p >= 0;

end;

//自动战斗AI2, 小小猪更改
procedure AutoBattle2(bnum: integer);
{var
  i, p, a, temp, rnum, inum, eneamount, aim, mnum, level, Ax1, Ay1, i1, i2, step, step1, dis0, dis: integer;
  Cmnum, Cmlevel, Cmtype, Cmdis, Cmrange, Clevel: integer;
  Movex, Movey, Mx1, My1, tempmaxhurt, maxhurt, tempminHP, twice: integer;
  str: WideString;}
begin
  {rnum := Brole[bnum].rnum;
  ShowSimpleStatus(rnum, 50, CENTER_Y * 2 - 160);
  SDL_Delay(450);

  if AutoMode[bnum] = 2 then
  begin
    Rest(bnum);
  end
  else
  begin

    //showmessage('');
    //Life is less than 30%, 70% probality to medcine or eat a pill.
    //生命低于30%, 70%可能医疗或吃药
    if (Brole[bnum].Acted = 0) and (Rrole[rnum].CurrentHP < (Rrole[rnum].MaxHP * 3) div 10) then
    begin
      if (Brole[bnum].Team <> 0) or ((Brole[bnum].Team = 0) and (AutoMode[bnum] > 0)) then
      begin
        if random(100) < 70 then
        begin
          FarthestMove(Movex, Movey, bnum);
          Ax := Movex;
          Ay := Movey;
          MoveAmination(bnum);
          //医疗大于50, 且体力大于50才对自身医疗
          if (Rrole[rnum].Medcine >= 50) and (Rrole[rnum].PhyPower >= 50) then
          begin
            Medcine(bnum);
          end
          else if (Brole[bnum].Team <> 0) or ((Brole[bnum].Team = 0) and (AutoMode[bnum] = 1)) then
          begin
            // if can't medcine, eat the item which can add the most life on its body.
            //无法医疗则选择身上加生命最多的药品, 我方从物品栏选择
            AutoUseItem(bnum, 45);
          end;
        end;
      end;
    end;

    //MP is less than 30%, 60% probality to eat a pill.
    //内力低于30%, 60%可能吃药
    if (Brole[bnum].Acted = 0) and (Rrole[rnum].CurrentMP < (Rrole[rnum].MaxMP * 3) div 10) then
    begin
      if (Brole[bnum].Team <> 0) or ((Brole[bnum].Team = 0) and (AutoMode[bnum] = 1)) then
      begin
        if (random(100) < 60) then
        begin
          FarthestMove(Movex, Movey, bnum);
          Ax := Movex;
          Ay := Movey;
          MoveAmination(bnum);
          AutoUseItem(bnum, 50);
        end;
      end;
    end;

    //Physical power is less than 30%, 80% probality to eat a pill.
    //体力低于30%, 80%可能吃药
    if (Brole[bnum].Acted = 0) and (Brole[bnum].Team <> 0) and (Rrole[rnum].PhyPower <
      (MAX_PHYSICAL_POWER * 3 div 10)) then
    begin
      if (Brole[bnum].Team <> 0) or ((Brole[bnum].Team = 0) and (AutoMode[bnum] = 1)) then
      begin
        if random(100) < 80 then
        begin
          FarthestMove(Movex, Movey, bnum);
          Ax := Movex;
          Ay := Movey;
          MoveAmination(bnum);
          AutoUseItem(bnum, 48);
        end;
      end;
    end;

    //自身医疗大于60, 寻找生命低于50％的队友进行医疗
    if (Brole[bnum].Acted = 0) and (Rrole[rnum].Medcine >= 60) and (Rrole[rnum].PhyPower > 50) then
    begin
      if (Brole[bnum].Team <> 0) or ((Brole[bnum].Team = 0) and (AutoMode[bnum] > 0)) then
      begin
        Mx1 := -1;
        Ax1 := -1;
        TryMoveCure(Mx1, My1, Ax1, Ay1, bnum);
        if Ax1 <> -1 then
        begin
          //移动
          Ax := Mx1;
          Ay := My1;
          MoveAmination(bnum);

          //医疗
          Ax := Ax1;
          Ay := Ay1;
          CureAction(bnum);
          Brole[bnum].Acted := 1;
        end;
      end;
    end;

    //尝试攻击
    if (Brole[bnum].Acted = 0) and (Rrole[rnum].PhyPower >= 10) then
    begin
      Movex := -1;
      Ax := -1;
      mnum := 0;
      Cmlevel := 0;
      Cmtype := 0;
      Cmdis := 0;
      Cmrange := 0;

      p := 0;
      a := 0;
      tempmaxhurt := 0;
      maxhurt := 0;
      for i := 0 to 9 do
      begin
        mnum := Rrole[rnum].Magic[i];
        if mnum <= 0 then
          break;
        if ((mnum < 131) or (mnum > 160)) and (Rmagic[mnum].NeedMP < Rrole[rnum].CurrentMP) then
        begin
          if (Rmagic[mnum].NeedItem < 0) or ((Rmagic[mnum].NeedItem >= 0) and
            (Rmagic[mnum].NeedItemAmount <= GetItemAmount(Rmagic[mnum].NeedItem))) then
          begin
            //if  Rmagic[mnum].NeedItem>= 0 then
            //           instruct_32(Rmagic[mnum].NeedItem, -Rmagic[mnum].NeedItemAmount);

            a := a + 1;
            level := Rrole[rnum].MagLevel[i] div 100 + 1;
            if Rrole[rnum].CurrentMP < Rmagic[mnum].NeedMP * ((level + 1) div 2) then
              level := Rrole[rnum].CurrentMP div Rmagic[mnum].NeedMP * 2;
            if level > 10 then
              level := 10;
            if level <= 0 then
              level := 1;

            for i1 := 0 to 63 do
              for i2 := 0 to 63 do
                Bfield[3, i1, i2] := -1;

            Bfield[3, Brole[bnum].X, Brole[bnum].Y] := 0;

            TryMoveAttack(Mx1, My1, Ax1, Ay1, tempmaxhurt, bnum, mnum, level);

            if tempmaxhurt > maxhurt then
            begin
              p := i;
              Cmnum := mnum;
              Clevel := level;
              Cmtype := Rmagic[mnum].AttAreaType;
              Cmdis := Rmagic[mnum].MoveDistance[level - 1];
              Cmrange := Rmagic[mnum].AttDistance[level - 1];
              Movex := Mx1;
              Movey := My1;
              Ax := Ax1;
              Ay := Ay1;
              maxhurt := tempmaxhurt;
            end;
          end;
        end;
      end;

      //移动并攻击
      if Ax <> -1 then
      begin
        //移动
        Ax1 := Ax;
        Ay1 := Ay;
        Ax := Movex;
        Ay := Movey;

        MoveAmination(bnum);

        //攻击
        Ax := Ax1;
        Ay := Ay1;
        SetAminationPosition(Rmagic[Cmnum].AttAreaType, Cmdis, Cmrange);
        Brole[bnum].Acted := 1;

        twice := 0;
        if Rmagic[Rrole[rnum].Magic[p]].MagicType = 2 then
          if random(1000) < Rrole[Brole[bnum].rnum].Sword then
            twice := 1;

        for i1 := 0 to Brole[bnum].StateLevel[13] + Rrole[Brole[bnum].rnum].addnum + twice do
        begin
          mnum := Rrole[rnum].Magic[p];
          Rrole[rnum].MagLevel[p] := Rrole[rnum].MagLevel[p] + random(2) + 1;
          if Rrole[rnum].MagLevel[p] > 999 then
            Rrole[rnum].MagLevel[p] := 999;
          if Rmagic[mnum].UnKnow[4] > 0 then
          begin
            execscript(PChar('script/SpecialMagic' + IntToStr(Rmagic[mnum].UnKnow[4]) + '.lua'),
              PChar('f' + IntToStr(Rmagic[mnum].UnKnow[4])));
            if Rmagic[mnum].NeedMP * (level + 1) div 2 > Rrole[rnum].CurrentMP then
            begin
              level := Rrole[rnum].CurrentMP div Rmagic[mnum].NeedMP * 2;
            end;
            Rrole[rnum].CurrentMP := Rrole[rnum].CurrentMP - Rmagic[mnum].NeedMP * (level + 1) div 2;

            if Rrole[rnum].CurrentMP < 0 then
              Rrole[rnum].CurrentMP := 0;
          end
          else
            AttackAction(bnum, Cmnum, Clevel);
        end;
      end;
    end;

    //If all other actions fail, rest.
    //如果上面行动全部失败, 则移动到离敌人最近的地方, 休息
    if Brole[bnum].Acted = 0 then
    begin
      NearestMove(Movex, Movey, bnum);
      Ax := Movex;
      Ay := Movey;
      MoveAmination(bnum);
      Rest(bnum);
    end;
  end;}

end;


//尝试移动并攻击, step为最大移动步数
//武功已经事先选好, distance为武功距离, range为武功范围, AttAreaType为武功类型
//尝试每一个可以移动到的点, 考察在该点攻击的情况, 选择最合适的目标点

procedure TryMoveAttack(var Mx1, My1, Ax1, Ay1, tempmaxhurt: integer; bnum, mnum, level: integer);
var
  i, i1, i2, eneamount, aim, curX, curY, dis, dis0: integer;
  tempX, tempY, tempdis: integer;
  step, distance, range, AttAreaType, myteam, minstep: integer;
  tempBx, tempBy, tempAx, tempAy, temphurt: integer;
  aimHurt: array[0..63, 0..63] of integer;
begin
  step := Brole[bnum].Step;
  minstep := 0;

  FillChar(aimHurt[0, 0], 4096 * 4, -1);
  distance := Rmagic[mnum].MoveDistance[level - 1];
  range := Rmagic[mnum].AttDistance[level - 1];
  AttAreaType := Rmagic[mnum].AttAreaType;
  myteam := Brole[bnum].Team;
  tempmaxhurt := 0;

  CalCanSelect(bnum, 0, step);

  Mx1 := -1;
  My1 := -1;
  //aim := 0;
  for curX := 0 to 63 do
    for curY := 0 to 63 do
    begin
      if BField[3, curX, curY] >= 0 then
      begin
        case AttAreaType of
          0:
            dis := distance;
          //calpoint(Mx1, My1, Ax1, Ay1, tempmaxhurt, curX, curY, bnum, mnum, level);
          1:
            dis := 1;
          //calline(Mx1, My1, Ax1, Ay1, tempmaxhurt, curX, curY, bnum, mnum, level);
          2:
          begin
            dis := 0;
            minstep := -1;
            //calcross(Mx1, My1, Ax1, Ay1, tempmaxhurt, curX, curY, bnum, mnum, level);
          end;
          3:
            dis := distance;
          //calarea(Mx1, My1, Ax1, Ay1, tempmaxhurt, curX, curY, bnum, mnum, level);
          4:
            dis := 1;
          //caldirdiamond(Mx1, My1, Ax1, Ay1, tempmaxhurt, curX, curY, bnum, mnum, level);
          5:
            dis := 1;
          //caldirangle(Mx1, My1, Ax1, Ay1, tempmaxhurt, curX, curY, bnum, mnum, level);
          6:
          begin
            dis := distance;
            minstep := Rmagic[mnum].MinStep;
            //calfar(Mx1, My1, Ax1, Ay1, tempmaxhurt, curX, curY, bnum, mnum, level);
          end;
        end;
        for i1 := max(curX - dis, 0) to min(curX + dis, 63) do
        begin
          dis0 := abs(i1 - curX);
          for i2 := max(curY - dis + dis0, 0) to min(curY + dis - dis0, 63) do
          begin
            if abs(curX - i1) + abs(curY - i2) <= minstep then
              continue;
            SetAminationPosition(curX, curY, i1, i2, AttAreaType, distance, range);
            temphurt := 0;
            if ((AttAreaType = 0) or (AttAreaType = 3)) and (aimHurt[i1, i2] >= 0) then
            begin
              if aimHurt[i1, i2] > 0 then
                temphurt := aimHurt[i1, i2] + random(5) - random(5); //点面类攻击已经计算过的点简单处理
            end
            else
            begin
              for i := 0 to BRoleAmount - 1 do
              begin
                if (Brole[i].Team <> myteam) and (Brole[i].Dead = 0) and (BField[4, Brole[i].X, Brole[i].Y] > 0) then
                begin
                  temphurt := temphurt + CalHurtValue2(bnum, i, mnum, level);
                end;
              end;
              //inc(aim);
              aimHurt[i1, i2] := temphurt;
            end;
            if temphurt > tempmaxhurt then
            begin
              tempmaxhurt := temphurt;
              Mx1 := curX;
              My1 := curY;
              Ax1 := i1;
              Ay1 := i2;
            end;
          end;
        end;
      end;
    end;
  //showmessage(inttostr(aim));
end;


//移动到离最近的敌人最近的地方

procedure NearestMove(var Mx1, My1: integer; bnum: integer);
var
  temp1, temp2: integer;
begin
  NearestMoveByPro(Mx1, My1, temp1, temp2, bnum, 0, 1, 0, 0, 0);

end;


//移动到离敌人最远的地方（与每一个敌人的距离之和最大）

procedure FarthestMove(var Mx1, My1: integer; bnum: integer);
var
  i, i1, i2, k, tempdis, maxdis: integer;
  aimX, aimY: integer;
  step, myteam: integer;
  curgrid, totalgrid: integer;
  curX, curY, curstep, nextX, nextY: integer;
begin
  step := Brole[bnum].Step;
  myteam := Brole[bnum].Team;
  maxdis := 0;

  Mx1 := Bx;
  My1 := By;

  CalCanSelect(bnum, 0, step);

  for curX := 0 to 63 do
    for curY := 0 to 63 do
    begin
      if BField[3, curX, curY] >= 0 then
      begin
        tempdis := 0;
        for k := 0 to BRoleAmount - 1 do
        begin
          if (Brole[k].Team <> myteam) and (Brole[k].Dead = 0) then
            tempdis := tempdis + abs(curX - Brole[k].X) + abs(curY - Brole[k].Y);
        end;
        if tempdis > maxdis then
        begin
          maxdis := tempdis;
          Mx1 := curX;
          My1 := curY;
        end;
      end;
    end;
end;


//TeamMate: 0-search enemy, 1-search teammate.
//KeepDis: keep steps to the aim. It minimun value is 1. But 0 means itself.
//Prolist: the properties of role.
//MaxMinPro: 1-search max, -1-search min, 0-any.
//mode: 0-nearest only, 1-medcine, 2-use poison, 3-force keepdis

procedure NearestMoveByPro(var Mx1, My1, Ax1, Ay1: integer;
  bnum, TeamMate, KeepDis, Prolist, MaxMinPro, mode: integer);
var
  i, tempdis, mindis, tempPro, rnum, n: integer;
  aimX, aimY: integer;
  step, myteam: integer;
  curX, curY: integer;
  select, check: boolean;
begin
  CalCanSelect(bnum, 0, Brole[bnum].Step);
  myteam := Brole[bnum].Team;
  mindis := 9999;
  step := Brole[bnum].Step;

  tempPro := 0;
  if MaxMinPro < 0 then
    tempPro := 9999;
  //CalCanSelect(bnum, 0, step);

  select := False;
  if KeepDis < 0 then
    KeepDis := 0;
  //showmessage(inttostr(keepdis));
  Mx1 := Bx;
  My1 := By;
  aimX := -1;
  aimY := -1;

  if (MaxMinPro <> 0) and (Prolist >= low(Rrole[0].Data)) and (Prolist <= high(Rrole[0].Data)) then
  begin
    for i := 0 to BRoleAmount - 1 do
    begin
      rnum := Brole[i].rnum;
      if (((TeamMate = 0) and (myteam <> Brole[i].Team)) or ((TeamMate <> 0) and (myteam = Brole[i].Team))) and
        (Brole[i].Dead = 0) and (Rrole[rnum].Data[Prolist] * sign(MaxMinPro) > tempPro * sign(MaxMinPro)) then
      begin
        if abs(Brole[i].X - Bx) + abs(Brole[i].Y - By) <= KeepDis + step then
        begin
          check := False;
          case mode of
            0: check := True;
            1: if (Rrole[rnum].CurrentHP < Rrole[rnum].MaxHP * 2 div 3) then
                check := True;
            2: if (Rrole[rnum].Poison > 33) then
                check := True;
          end;
          if check then
          begin
            aimX := Brole[i].X;
            aimY := Brole[i].Y;
            tempPro := Rrole[Brole[i].rnum].Data[Prolist];
            select := True;
          end;
        end;
      end;
    end;
  end;

  //AI有可能进行两次移动, 即决定辅助类行动失败, 即转为攻击.
  //若目标为敌方,  在移动之后仍会进行二次判断, 有可能行动失败后转为攻击.
  //若为己方(医疗或解毒)先估测失败可能, 如必定失败则不会行动

  //若按属性寻找失败(未指定最大最小, 或者全部在安全距离之外), 则按距离找最近
  if (not select) and (mode = 0) then
  begin
    for i := 0 to BRoleAmount - 1 do
    begin
      if (((TeamMate = 0) and (myteam <> Brole[i].Team)) or ((TeamMate <> 0) and (myteam = Brole[i].Team))) and
        (Brole[i].Dead = 0) then
      begin
        tempdis := abs(Brole[i].X - Bx) + abs(Brole[i].Y - By);
        if tempdis < mindis then
        begin
          mindis := tempdis;
          aimX := Brole[i].X;
          aimY := Brole[i].Y;
        end;
      end;
    end;
  end;

  //if mode<> 0 then
  KeepDis := min(KeepDis, abs(Bx - aimX) + abs(By - aimY) + step);
  mindis := 9999;


  FillChar(BField[8, 0, 0], sizeof(BField[8]), -1);
  BField[8, aimX, aimY] := 0;
  SeekPath2(aimX, aimY, 128, TeamMate, 3, bnum);  //从敌方的位置寻路回自己的位置, 标记每格到目标的距离
  n := 0;
  if aimX > 0 then
  begin
    for curX := 0 to 63 do
      for curY := 0 to 63 do
      begin
        //注意此时保存能否走到的是3, 保存距离的是8
        if BField[3, curX, curY] >= 0 then
        begin
          tempdis := BField[8, curX, curY];
          if tempdis < 0 then
            tempdis := abs(curX - aimX) + abs(curY - aimY);
          if (tempdis >= KeepDis) then
            if ProbabilityByValue(tempdis, mindis, -1, n) then
            begin
              mindis := tempdis;
              Mx1 := curX;
              My1 := curY;
            end;
        end;
      end;
  end;
  Ax1 := aimX;
  Ay1 := aimY;
end;

//mode: 1找最大值, -1最小值, 0任意
//n为当前点数
function ProbabilityByValue(cur, m, mode: integer; var n: integer): boolean;
begin
  case sign(cur - m) * sign(mode) of
    1:
      //找到更小的, 直接设置为选中
    begin
      n := 1;
      Result := True;
    end;
    0:
      //找到相同的, 选中几率与当前找到几个点有关
    begin
      n := n + 1;
      Result := random(n) = 0;
    end;
    else
      Result := False;
  end;
end;

//在可医疗范围内, 寻找生命不足一半的生命最少的友军,

procedure TryMoveCure(var Mx1, My1, Ax1, Ay1: integer; bnum: integer);
var
  curX, curY: integer;
  i, eneamount, aim: integer;
  step, myteam, curedis, rnum: integer;
  tempminHP: integer;
begin
  step := Brole[bnum].Step;
  myteam := Brole[bnum].Team;
  curedis := Rrole[Brole[bnum].rnum].Medcine div 15 + 1;

  tempminHP := MAX_HP;
  Mx1 := Bx;
  My1 := By;

  CalCanSelect(bnum, 0, step);

  for curX := 0 to 63 do
    for curY := 0 to 63 do
    begin
      if BField[3, curX, curY] >= 0 then
      begin
        for i := 0 to BRoleAmount - 1 do
        begin
          rnum := Brole[i].rnum;
          if (Brole[i].Team = myteam) and (Brole[i].dead = 0) and (abs(Brole[i].X - curX) +
            abs(Brole[i].Y - curY) < curedis) and (Rrole[rnum].CurrentHP < Rrole[rnum].MaxHP div 2) then
          begin
            if (Rrole[rnum].CurrentHP < tempminHP) then
            begin
              tempminHP := Rrole[rnum].CurrentHP;
              Mx1 := curX;
              My1 := curY;
              Ax1 := Brole[i].X;
              Ay1 := Brole[i].Y;
            end;
          end;
        end;
      end;
    end;
  //writeln(Ax1, Ay1, bnum);
  //if Ax1 >= 0 then writeln(Bfield[2, Ax1, Ay1]);
end;

procedure CureAction(bnum: integer);
var
  rnum, bnum1, rnum1, addlife: integer;
begin
  rnum := Brole[bnum].rnum;
  Rrole[rnum].PhyPower := Rrole[rnum].PhyPower - 5;
  bnum1 := BField[2, Ax, Ay];
  rnum1 := Brole[bnum1].rnum;
  addlife := Rrole[rnum].Medcine; //calculate the value
  if addlife < 0 then
    addlife := 0;
  if addlife + Rrole[rnum1].CurrentHP > Rrole[rnum1].MaxHP then
    addlife := Rrole[rnum1].MaxHP - Rrole[rnum1].CurrentHP;
  Rrole[rnum1].CurrentHP := Rrole[rnum1].CurrentHP + addlife;
  Rrole[rnum1].Hurt := Rrole[rnum1].Hurt - addlife div 10 div LIFE_HURT;
  if Rrole[rnum1].Hurt < 0 then
    Rrole[rnum1].Hurt := 0;
  Brole[bnum1].ShowNumber := addlife;
  SetAminationPosition(0, 0, 0);
  PlayActionAmination(bnum, 0);
  PlayMagicAmination(bnum, 0);
  ShowHurtValue(3);
  //writeln(bnum, bnum1, addlife);
end;

procedure RoundOver; overload;
var
  i1, i2: integer;
  removeStone: boolean;
begin
  BattleRound := BattleRound + 1;

  if (BattleRound mod 10 = 0) then
  begin
    //乱石嶙峋每整10回合清一次
    removeStone := False;
    for i1 := 0 to 63 do
      for i2 := 0 to 63 do
      begin
        if BField[1, i1, i2] = 1487 * 2 then
        begin
          BField[1, i1, i2] := 0;
          removeStone := True;
        end;
      end;
    if removeStone then
      InitialBfieldImage(1);
  end;
  {//以下处理状态类事件的回合数
  for i := 0 to BRoleAmount - 1 do
  begin
    if (SEMIREAL = 0) or (Brole[i].Acted = 1) then
    begin
      //情侣和状态恢复生命
      rnum := Brole[i].rnum;
      Rrole[rnum].CurrentHP := Rrole[rnum].CurrentHP + Rrole[rnum].MaxHP * Brole[i].StateLevel[5] div 100;
      Rrole[rnum].CurrentHP := Rrole[rnum].CurrentHP + Rrole[rnum].MaxHP * Brole[i].loverLevel[7] div 100;
      if Rrole[rnum].CurrentHP > Rrole[rnum].MaxHP then
        Rrole[rnum].CurrentHP := Rrole[rnum].MaxHP;

      //情侣和状态恢复内力
      rnum := Brole[i].rnum;
      Rrole[rnum].CurrentMP := Rrole[rnum].CurrentMP + Rrole[rnum].MaxMP * Brole[i].StateLevel[6] div 100;
      Rrole[rnum].CurrentMP := Rrole[rnum].CurrentMP + Rrole[rnum].MaxMP * Brole[i].loverLevel[8] div 100;
      if Rrole[rnum].CurrentMP < 0 then
        Rrole[rnum].CurrentMP := 0;
      if Rrole[rnum].CurrentMP > Rrole[rnum].MaxMP then
        Rrole[rnum].CurrentMP := Rrole[rnum].MaxMP;
      //状态恢复体力
      addphy := MAX_PHYSICAL_POWER * Brole[i].StateLevel[20] div 100;
      if (Rrole[rnum].PhyPower + addphy < 20) and (addphy < 0) then
        addphy := 0;
      Rrole[rnum].PhyPower := Rrole[rnum].PhyPower + addphy;
      if Rrole[rnum].PhyPower > MAX_PHYSICAL_POWER then
        Rrole[rnum].PhyPower := MAX_PHYSICAL_POWER;
      if Rrole[rnum].PhyPower < 1 then
        Rrole[rnum].PhyPower := 1;

      for j := 0 to high(Brole[i].StateLevel) do
      begin
        if Brole[i].StateRound[j] > 0 then
        begin
          Brole[i].StateRound[j] := Brole[i].StateRound[j] - 1;
          if Brole[i].StateRound[j] <= 0 then
          begin
            Brole[i].StateLevel[j] := 0;
            //if j = 27 then
            //Brole[i].Team := 1 - Brole[i].Team;
          end;
        end;
      end;
    end;
  end;}
end;

procedure RoundOver(bnum: integer); overload;
var
  rnum, j, addphy: integer;
begin
  if (SEMIREAL = 0) or (Brole[bnum].Acted = 1) then
  begin
    //情侣和状态恢复生命
    rnum := Brole[bnum].rnum;
    Rrole[rnum].CurrentHP := Rrole[rnum].CurrentHP + Rrole[rnum].MaxHP * Brole[bnum].StateLevel[5] div 100;
    Rrole[rnum].CurrentHP := Rrole[rnum].CurrentHP + Rrole[rnum].MaxHP * Brole[bnum].loverLevel[7] div 100;
    if Rrole[rnum].CurrentHP > Rrole[rnum].MaxHP then
      Rrole[rnum].CurrentHP := Rrole[rnum].MaxHP;

    //情侣和状态恢复内力
    rnum := Brole[bnum].rnum;
    Rrole[rnum].CurrentMP := Rrole[rnum].CurrentMP + Rrole[rnum].MaxMP * Brole[bnum].StateLevel[6] div 100;
    Rrole[rnum].CurrentMP := Rrole[rnum].CurrentMP + Rrole[rnum].MaxMP * Brole[bnum].loverLevel[8] div 100;
    if Rrole[rnum].CurrentMP < 0 then
      Rrole[rnum].CurrentMP := 0;
    if Rrole[rnum].CurrentMP > Rrole[rnum].MaxMP then
      Rrole[rnum].CurrentMP := Rrole[rnum].MaxMP;
    //状态恢复体力
    addphy := MAX_PHYSICAL_POWER * Brole[bnum].StateLevel[20] div 100;
    if (Rrole[rnum].PhyPower + addphy < 20) and (addphy < 0) then
      addphy := 0;
    Rrole[rnum].PhyPower := Rrole[rnum].PhyPower + addphy;
    if Rrole[rnum].PhyPower > MAX_PHYSICAL_POWER then
      Rrole[rnum].PhyPower := MAX_PHYSICAL_POWER;
    if Rrole[rnum].PhyPower < 1 then
      Rrole[rnum].PhyPower := 1;

    for j := 0 to high(Brole[bnum].StateLevel) do
    begin
      if Brole[bnum].StateRound[j] > 0 then
      begin
        Brole[bnum].StateRound[j] := Brole[bnum].StateRound[j] - 1;
        if Brole[bnum].StateRound[j] <= 0 then
        begin
          Brole[bnum].StateLevel[j] := 0;
          //if j = 27 then
          //Brole[i].Team := 1 - Brole[i].Team;
        end;
      end;
    end;
  end;
end;

function SelectAutoMode: boolean;
var
  menup, x, y, w, h, menu, i, amount, xm, ym: integer;
  a: array of smallint;
  tempmode: array of integer;
  modestring: array[0..3] of WideString;
  namestr: array of WideString;
  str: WideString;

  procedure ShowTeamModeMenu();
  var
    i: integer;
  begin
    LoadFreshScreen(x, y);
    //DrawRectangle(x, y, w, h, 0, ColColor(255), 30);
    for i := 0 to amount - 1 do
    begin
      if (i = menu) then
      begin
        DrawTextFrame(x, y + h * i, 13);
        DrawShadowText(@namestr[i][1], x + 19, y + 3 + h * i, ColColor($64), ColColor($66));
        DrawShadowText(@modestring[Brole[a[i]].AutoMode][1], x + 109, y + 3 + h * i,
          ColColor($64), ColColor($66));
      end
      else
      begin
        DrawTextFrame(x, y + h * i, 13, 20);
        DrawShadowText(@namestr[i][1], x + 19, y + 3 + h * i, 0, $202020);
        DrawShadowText(@modestring[Brole[a[i]].AutoMode][1], x + 109, y + 3 + h * i,
          0, $202020);
      end;
    end;
    DrawTextFrame(x, y + h * amount, 4);
    if menu = -2 then
      DrawShadowText(@str[1], x + 19, y + 3 + h * amount, ColColor($64), ColColor($66))
    else
      DrawShadowText(@str[1], x + 19, y + 3 + h * amount, 0, $202020);
    //SDL_UpdateRect2(screen, x, y, w + 1, h + 1);
    UpdateAllScreen;
  end;

begin
  x := 160;
  y := 82;
  w := 200;
  h := 28;
  ////SDL_EnableKeyRepeat(20, 100);
  Result := True;
  amount := 0;
  for i := 0 to BRoleAmount - 1 do
  begin
    if (Brole[i].Team = 0) and (Brole[i].Dead = 0) then
    begin
      amount := amount + 1;
      setlength(namestr, amount);
      setlength(a, amount);
      namestr[amount - 1] := pWideChar(@Rrole[Brole[i].rnum].Name[0]);
      a[amount - 1] := i;
    end;
  end;
  //h := amount * 22 + 28;
  modestring[1] := '疯子';
  modestring[2] := '傻子';
  modestring[3] := '呆子';
  modestring[0] := '手動';
  str := '確認';

  RecordFreshScreen(x, y, w + 1, (amount + 1) * h + 1);
  setlength(tempmode, BRoleAmount);
  for i := 0 to BRoleAmount - 1 do
  begin
    tempmode[i] := Brole[i].AutoMode;
  end;

  menu := 0;
  ShowTeamModeMenu;
  while (SDL_WaitEvent(@event) >= 0) do
  begin
    CheckBasicEvent;
    case event.type_ of
      SDL_KEYUP:
      begin
        if (event.key.keysym.sym = SDLK_RETURN) or (event.key.keysym.sym = SDLK_SPACE) then
        begin
          break;
        end;
        if (event.key.keysym.sym = SDLK_ESCAPE) then
        begin
          Result := False;
          break;
        end;
        if (event.key.keysym.sym = SDLK_LEFT) then
        begin
          Brole[a[menu]].AutoMode := Brole[a[menu]].AutoMode - 1;
          if Brole[a[menu]].AutoMode < 0 then
            Brole[a[menu]].AutoMode := 3;
          ShowTeamModeMenu;
        end;
        if (event.key.keysym.sym = SDLK_RIGHT) then
        begin
          Brole[a[menu]].AutoMode := Brole[a[menu]].AutoMode + 1;
          if Brole[a[menu]].AutoMode > 3 then
            Brole[a[menu]].AutoMode := 0;
          ShowTeamModeMenu;
        end;
      end;
      SDL_KEYDOWN:
      begin
        if (event.key.keysym.sym = SDLK_UP) then
        begin
          menu := menu - 1;
          if menu = -1 then
            menu := -2;
          if menu = -3 then
            menu := amount - 1;
          ShowTeamModeMenu;
        end;
        if (event.key.keysym.sym = SDLK_DOWN) then
        begin
          menu := menu + 1;
          if menu = amount then
            menu := -2;
          if menu = -1 then
            menu := 0;
          ShowTeamModeMenu;
        end;
      end;
      SDL_MOUSEBUTTONUP:
      begin
        if (event.button.button = SDL_BUTTON_LEFT) and MouseInRegion(x, y, w, amount * h + 32) then
        begin
          if (menu > -1) then
          begin
            Brole[a[menu]].AutoMode := Brole[a[menu]].AutoMode + 1;
            if Brole[a[menu]].AutoMode > 3 then
              Brole[a[menu]].AutoMode := 0;
            ShowTeamModeMenu;
          end
          else if (menu = -2) then
          begin
            break;
          end;
        end;
        if (event.button.button = SDL_BUTTON_RIGHT) then
        begin
          Result := False;
          break;
        end;
      end;
      SDL_MOUSEMOTION:
      begin
        if MouseInRegion(x, y, w, amount * h + 32, xm, ym) then
        begin
          menup := menu;
          menu := (ym - y) div h;
          if menu < 0 then
            menu := 0;
          if menu >= amount then
            menu := -2;
          if menup <> menu then
            ShowTeamModeMenu;
        end
        else
          menu := -1;
      end;
    end;
    event.key.keysym.sym := 0;
    event.button.button := 0;
  end;

  if Result = False then
    for i := 0 to BRoleAmount - 1 do
      Brole[i].AutoMode := tempmode[i];
  FreeFreshScreen;

  Redraw;
  UpdateAllScreen;
end;


procedure Auto(bnum: integer);
var
  a, i, menu: integer;
begin
  //setlength(menustring, 2);
  //menustring[1] := '單人';
  //menustring[0] := '全體';
  //menu := commonmenu2(157, 50, 98);
  ////SDL_EnableKeyRepeat(20, 100);
  //if menu = -1 then
  //  exit;

  //redraw;
  //SDL_UpdateRect2(screen, 157, 50, 100, 35);


  //if menu=1 then AutoMode[bnum]:= SelectAutoMode ;
  //if menu=0 then
  if not SelectAutoMode then
    exit;

  //if AutoMode[bnum]=-1 then
  //begin
  //  exit;
  //end
  //else
  //begin
  //  if  menu = 0 then
  //  begin
  for i := 0 to BRoleAmount - 1 do
  begin
    if (Brole[i].Team = 0) and (Brole[i].Dead = 0) then
    begin
      if Brole[i].AutoMode = 0 then
      begin
        Brole[i].Auto := 0;
      end
      else
        Brole[i].Auto := 1;
    end;
  end;
  //end;
  if Brole[bnum].Auto > 0 then
  begin
    AutoBattle3(bnum);
    Brole[bnum].Acted := 1;
  end;
  //end;

end;


//自动战斗AI3, 可以使用特技
procedure AutoBattle3(bnum: integer);
var
  i, p, a, temp, rnum, inum, eneamount, aim, level, Ax1, Ay1, temp1, temp2: integer;
  Cmnum, Cmlevel, Cmtype, Cmdis, Cmrange, magicid, bnum1: integer;
  Movex, Movey, Mx1, My1, twice, mainMType, tempMaxMType, minstep: integer;
  str: WideString;
begin
  rnum := Brole[bnum].rnum;
  ShowSimpleStatus(rnum, 80, CENTER_Y * 2 - 130);
  UpdateAllScreen;
  SDL_Delay(450);
  if Brole[bnum].AutoMode = 3 then
  begin //呆子型, 直接调息
    Rest(bnum);
  end
  else
  begin
    Brole[bnum].Acted := 0;

    //Life is less than 30%, 70% probality to medcine or eat a pill.
    //生命低于30%, 70%可能医疗或吃药
    if (Brole[bnum].Acted <> 1) and (Rrole[rnum].CurrentHP < (Rrole[rnum].MaxHP * 3) div 10) then
    begin
      //showmessage(inttostr(1));
      if (Brole[bnum].AutoMode > 0) or (Brole[bnum].Team <> 0) then
      begin
        if random(100) < 70 then
        begin
          //医疗大于60, 且体力大于50才对自身医疗
          if (Rrole[rnum].Medcine >= 60) and (Rrole[rnum].PhyPower >= 50) then
          begin
            FarthestMove(Movex, Movey, bnum);
            Ax := Movex;
            Ay := Movey;
            MoveAmination(bnum);
            Medcine(bnum);
          end
          else if (Brole[bnum].Team <> 0) or ((Brole[bnum].Team = 0) and (Brole[bnum].AutoMode = 2)) then
          begin
            // if can't medcine, eat the item which can add the most life on its body.
            //无法医疗则选择身上加生命最多的药品, 我方从物品栏选择
            if AutoUseItem(bnum, 45, 1) then
            begin
              FarthestMove(Movex, Movey, bnum);
              Ax := Movex;
              Ay := Movey;
              MoveAmination(bnum);
              AutoUseItem(bnum, 45);
            end;
          end;
        end;
      end;
    end;

    //MP is less than 30%, 60% probality to eat a pill.
    //内力低于30%, 60%可能吃药
    if (Brole[bnum].Acted <> 1) and (Rrole[rnum].CurrentMP < (Rrole[rnum].MaxMP * 3) div 10) then
    begin
      //showmessage(inttostr(2));
      if (Brole[bnum].Team <> 0) or ((Brole[bnum].Team = 0) and (Brole[bnum].AutoMode = 2)) then
      begin
        if (random(100) < 60) and AutoUseItem(bnum, 50, 1) then
        begin
          FarthestMove(Movex, Movey, bnum);
          Ax := Movex;
          Ay := Movey;
          MoveAmination(bnum);
          AutoUseItem(bnum, 50);
        end;
      end;
    end;

    //Physical power is less than 30%, 50% probality to eat a pill.
    //体力低于30%, 50%可能吃药
    if (Brole[bnum].Acted <> 1) and (Brole[bnum].Team <> 0) and (Rrole[rnum].PhyPower <
      (MAX_PHYSICAL_POWER * 3 div 10)) then
    begin
      //showmessage(inttostr(3));
      if (Brole[bnum].Team <> 0) or ((Brole[bnum].Team = 0) and (Brole[bnum].AutoMode = 2)) then
      begin
        if (random(100) < 50) and AutoUseItem(bnum, 48, 1) then
        begin
          FarthestMove(Movex, Movey, bnum);
          Ax := Movex;
          Ay := Movey;
          MoveAmination(bnum);
          AutoUseItem(bnum, 48);
        end;
      end;
    end;

    if AI_USE_SPECIAL <> 0 then
    begin
      //尝试使用特技
      if (Brole[bnum].Acted <> 1) and (Rrole[rnum].PhyPower >= 10) and (Rrole[rnum].Poison < 100) then
        SpecialAttack(bnum);
      //自身医疗大于70, 寻找生命最低的队友进行医疗
      //When Medcine is more than 70, and physical power is more than 70, 50% probability to cure one teammate.
      if (Brole[bnum].Acted <> 1) and (Rrole[rnum].Medcine > 70) and (Rrole[rnum].PhyPower >= 70) then
      begin
        if random(100) < 50 then
        begin
          NearestMoveByPro(Ax, Ay, Ax1, Ay1, bnum, 1, 0, 17, -1, 1);
          if (Ax1 <> -1) then
          begin
            MoveAmination(bnum);
            Ax := Ax1;
            Ay := Ay1;
            Medcine(bnum);
          end;
        end;
      end;
      //用毒大于80, 可能尝试用毒
      if (Brole[bnum].Acted <> 1) and (Rrole[rnum].UsePoi > 80) and (Rrole[rnum].PhyPower >= 60) then
      begin
        if random(100) < 50 then
        begin
          //应认为不知道对方的抗毒能力
          NearestMove(Ax1, Ay1, bnum);
          if (Ax1 <> -1) then
          begin
            MoveAmination(bnum);
            Ax := Ax1;
            Ay := Ay1;
            UsePoison(bnum);
          end;
        end;
      end;
      //有可能尝试解毒
      if (Brole[bnum].Acted <> 1) and (Rrole[rnum].MedPoi > 50) and (Rrole[rnum].PhyPower >= 70) then
      begin
        if random(100) < 50 then
        begin
          NearestMoveByPro(Ax, Ay, Ax1, Ay1, bnum, 1, 0, 20, 1, 2);
          if (Ax1 <> -1) then
          begin
            MoveAmination(bnum);
            Ax := Ax1;
            Ay := Ay1;
            MedPoison(bnum);
          end;
        end;
      end;
    end;

    //尝试攻击, 这里不会使用伤害类型为2的技能
    if (Brole[bnum].Acted <> 1) and (Rrole[rnum].PhyPower >= 10) and (Rrole[rnum].Poison < 100) then
    begin
      //首先判断此人的武功主系, 若为暗器系则计算预留范围
      tempMaxMType := 0;
      for i := 1 to 5 do
      begin
        if Rrole[rnum].Data[49 + i] > tempMaxMType then
        begin
          mainMType := i;
          tempMaxMType := Rrole[rnum].Data[49 + i];
        end;
      end;
      //水浒中暗器几乎全都是最低3格
      minstep := 1;
      if mainMType = 5 then
      begin
        for i := 0 to HaveMagicAmount(rnum) - 1 do
          minstep := max(minstep, Rmagic[Rrole[rnum].Magic[i]].MinStep + 1);
      end;

      NearestMoveByPro(Movex, Movey, temp1, temp2, bnum, 0, minstep, 0, 0, 0);
      TryAttack(Ax1, Ay1, magicid, Cmlevel, Movex, Movey, bnum);

      //移动并攻击
      if magicid > -1 then
      begin
        //移动
        Ax := Movex;
        Ay := Movey;
        MoveAmination(bnum);
        //攻击
        Ax := Ax1;
        Ay := Ay1;
        Cmnum := Rrole[Brole[bnum].rnum].Magic[magicid];
        Cmdis := Rmagic[Cmnum].MoveDistance[Cmlevel - 1];
        Cmrange := Rmagic[Cmnum].AttDistance[Cmlevel - 1];
        ModifyRange(bnum, Cmnum, Cmdis, Cmrange);
        Brole[bnum].Acted := 1;
        SetAminationPosition(Rmagic[Cmnum].AttAreaType, Cmdis, Cmrange);
        AttackAction(bnum, magicid, Cmnum, Cmlevel);
      end;
    end;

    //如果攻击失败, 则再次考虑使用特技
    if (Brole[bnum].Acted <> 1) and (Rrole[rnum].PhyPower >= 10) and (Rrole[rnum].Poison < 100) then
      SpecialAttack(bnum);

    //If all other actions fail, rest.
    //如果上面行动全部失败, 生命和内力都有一个多于一半就向敌人移动, 如果二者均小于1/10则远离,否则原地调息

    if Brole[bnum].Acted <> 1 then
    begin
      if (Rrole[rnum].CurrentHP > Rrole[rnum].MaxHP div 2) or (Rrole[rnum].CurrentMP >
        Rrole[rnum].MaxMP div 2) then
      begin
        //showmessage(inttostr(6));
        NearestMove(Movex, Movey, bnum);
        Ax := Movex;
        Ay := Movey;
        MoveAmination(bnum);
        Rest(bnum);

      end
      else if (Rrole[rnum].CurrentHP < Rrole[rnum].MaxHP div 10) and (Rrole[rnum].CurrentMP <
        Rrole[rnum].MaxMP div 10) then
      begin
        FarthestMove(Movex, Movey, bnum);
        Ax := Movex;
        Ay := Movey;
        MoveAmination(bnum);
        Rest(bnum);
      end
      else
      begin
        //showmessage(inttostr(7));
        Rest(bnum);
      end;
    end;
  end;

end;

//AI使用特技

function SpecialAttack(bnum: integer): boolean;
var
  rnum, mnum, level, rnd, r, movetype, Movex, Movey, dis, dis0, distance, range, minstep,
  maxCount, tempcount, i, i1, i2, m, magicid, twice: integer;
  select: boolean;
begin
  Result := False;
  select := False;
  movetype := 0;
  rnum := Brole[bnum].rnum;
  m := HaveMagicAmount(rnum);
  //选择特技的概率为: 1/武功总数
  //如果为状态类特技, 且作用对象为自身或者全体队友, 当自己没有相关buff时, 80%几率使用
  twice := 1;
  for i := 0 to m - 1 do
  begin
    mnum := Rrole[rnum].Magic[i];
    if (Rmagic[mnum].HurtType = 2) then
    begin
      if (random(m * 100) < 100) or ((Rmagic[mnum].ScriptNum = 0) and (Rmagic[mnum].AddMP[0] in [3, 4]) and
        ((Brole[bnum].StateLevel[Rmagic[mnum].AddMP[1]] <= 0) or
        (Brole[bnum].StateRound[Rmagic[mnum].AddMP[1]] <= 1)) and (random(100) < 80)) then
      begin
        select := True;
        magicid := i;
        break;
      end;
    end;
  end;

  //2是特技, 用AddMP[0]表示目标方式
  //0范围内敌方, 1范围内我方, 2敌方全体, 3我方全体；4自身；5范围内全部；6全部；7无高亮
  //选择特技时, 有3种行动方式, 1靠近, 2远离, 3不动
  //靠近: 0, 2, 5
  //远离: 4
  //不动: 1, 3, 6, 7
  if select then
  begin
    //确定等级,范围
    level := Rrole[rnum].MagLevel[magicid] div 100 + 1;
    if Rrole[rnum].CurrentMP < Rmagic[mnum].NeedMP * level then
      level := Rrole[rnum].CurrentMP div Rmagic[mnum].NeedMP;
    if level > 10 then
      level := 10;
    if level < 1 then
      exit;
    distance := Rmagic[mnum].MoveDistance[level - 1];
    range := Rmagic[mnum].AttDistance[level - 1];
    //选择移动模式
    case Rmagic[mnum].AddMP[0] of
      0, 2, 5: movetype := 1;
      1, 3, 6, 7:
      begin
        movetype := 3;
        if Rrole[rnum].CurrentHP < Rrole[rnum].MaxHP div 2 then
          movetype := 2;  //仅对我方或者不需考虑范围时, 生命值偏低则后退
        if Rrole[rnum].CurrentHP > Rrole[rnum].MaxHP * 4 div 5 then
          movetype := 1;  //生命值高于4/5则前进
      end;
      4: //仅能针对自己的状态类技能, 需判断此状态是否存在
      begin
        movetype := -1;
        case Rmagic[mnum].AddMP[1] of
          21:  //天地同寿, 伤逝
          begin
            if (Brole[bnum].StateLevel[Rmagic[mnum].AddMP[1]] = 0) then
            begin
              rnd := random(Rrole[rnum].MaxHP);
              if rnd > Rrole[rnum].CurrentHP then
                movetype := 1; //1  靠近敌人
            end;
          end;
            //乾坤大挪移,飞天神行,战神无双,倾国倾城,博采众家,爱恨情仇,鸳鸯双刀,柔情似水
            //庖丁解牛,孤注一掷,掌遏风雷,佛问魔心,丐世豪侠
            //温情脉脉,精灵古怪,深情款款,剑芒,伺机而动,毒箭穿心,古灵精怪
          {144, 131, 135, 134, 262, 140, 146, 142,
          261, 259, 257, 286, 258,
          284, 282, 283, 260, 287, 274, 141:}
          else
          begin
            if (Brole[bnum].StateLevel[Rmagic[mnum].AddMP[1]] = 0) then
            begin
              movetype := 3;
              if Rrole[rnum].CurrentHP < Rrole[rnum].MaxHP div 2 then
                movetype := 2;  //2  远离敌人
              //if Rrole[rnum].CurrentHP > Rrole[rnum].MaxHP * 4 div 5 then
              //movetype := 1;  //生命值高于4/5则前进
            end;
          end;
        end;
      end;
    end;
    //如果是万里独行则设为远离(暂时不用这个设定)
    //if Rmagic[mnum].ScriptNum = 20 then movetype := 2;
    //如果是森罗万象小于10级但我方只剩一人时则不使用
    if Rmagic[mnum].ScriptNum = 31 then
      if (level < 10) and (CalRNum(Brole[bnum].Team) <= 1) then
        movetype := -1;
    //移动模式选择成功, 则继续下一步
    if movetype > 0 then
    begin
      case movetype of
        1:
        begin
          NearestMove(Movex, Movey, bnum);
          Ax := Movex;
          Ay := Movey;
          MoveAmination(bnum);
        end;
        2:
        begin
          FarthestMove(Movex, Movey, bnum);
          Ax := Movex;
          Ay := Movey;
          MoveAmination(bnum);
        end;
      end;
      //如果是0,1,5则选择作用点
      if (Rmagic[mnum].AddMP[0] = 0) or (Rmagic[mnum].AddMP[0] = 1) or (Rmagic[mnum].AddMP[0] = 5) then
      begin
        minstep := -1;
        case Rmagic[mnum].AttAreaType of
          0:
            dis := distance;
          1:
            dis := 1;
          2:
          begin
            dis := 0;
          end;
          3:
            dis := distance;
          4:
            dis := 1;
          5:
            dis := 1;
          6:
          begin
            dis := distance;
            minstep := Rmagic[mnum].MinStep;
          end;
        end;
        //搜索人数最多的点, 该值同时标记是否能够找到目标
        //如果为状态类特技, 该人物已有此状态则不标记
        maxCount := 0;
        for i1 := max(Bx - dis, 0) to min(Bx + dis, 63) do
        begin
          dis0 := abs(i1 - Bx);
          for i2 := max(By - dis + dis0, 0) to min(By + dis - dis0, 63) do
          begin
            //存在最小攻击距离的武功无需计算距离过小的点
            if abs(Bx - i1) + abs(By - i2) <= minstep then
              continue;
            //这里可能可以针对面类改写, 因为面类设置动画比较慢
            SetAminationPosition(Bx, By, i1, i2, Rmagic[mnum].AttAreaType, distance, range);
            tempcount := 0;
            //选择原则, 优先级有一定随机性
            for i := 0 to BRoleAmount - 1 do
            begin
              if (Brole[i].Dead = 0) and (BField[4, Brole[i].X, Brole[i].Y] > 0) then
              begin
                if ((Rmagic[mnum].AddMP[0] = 0) and (Brole[i].Team <> Brole[bnum].Team)) or
                  ((Rmagic[mnum].AddMP[0] = 1) and (Brole[i].Team = Brole[bnum].Team)) or
                  (Rmagic[mnum].AddMP[0] = 5) then
                  if ((Rmagic[mnum].ScriptNum = 0) and
                    ((Brole[i].StateLevel[Rmagic[mnum].AddMP[1]] = 0) or
                    (Brole[i].StateRound[Rmagic[mnum].AddMP[1]] <= 1))) or (Rmagic[mnum].ScriptNum > 0) then
                    tempcount := tempcount + 100 + random(20);
              end;
            end;
            if tempcount > maxCount then
            begin
              maxCount := tempcount;
              Ax := i1;
              Ay := i2;
            end;
          end;
        end;
      end
      else
      begin
        //其他情况作用点设为自身即可
        maxCount := 1;
        Ax := Bx;
        Ay := By;
      end;
      if maxCount > 0 then
      begin
        //使用特技
        //状态类特技直接判定为已经行动, 其他特技需具体判断
        if Rmagic[mnum].ScriptNum = 0 then
          Brole[bnum].Acted := 1;
        SetAminationPosition(Rmagic[mnum].AttAreaType, distance, range, Rmagic[mnum].AddMP[0]);
        AttackAction(bnum, magicid, mnum, level);
      end;
    end;
  end;
end;


procedure TryAttack(var Ax1, Ay1, magicid, cmlevel: integer; Mx, My, bnum: integer);
var
  i, rnum, mnum, level, tempmaxhurt, mid: integer;
  i1, i2, dis, dis0: integer;
  step, range, AttAreaType, myteam, minstep: integer;
  temphurt, m: integer;
  aimHurt: array[0..63, 0..63] of integer;
begin
  magicid := -1;
  rnum := Brole[bnum].rnum;
  m := HaveMagicAmount(rnum);
  tempmaxhurt := 0;
  myteam := Brole[bnum].Team;
  for mid := 0 to m - 1 do
  begin
    mnum := Rrole[rnum].Magic[mid];
    if mnum <= 0 then
      break;
    if Rmagic[mnum].HurtType = 2 then
      continue;
    if (Rmagic[mnum].NeedItem >= 0) then
      if ((Brole[bnum].Team = 0) and (GetItemAmount(Rmagic[mnum].NeedItem) < Rmagic[mnum].NeedItemAmount)) then
        continue;
    level := Rrole[rnum].MagLevel[mid] div 100 + 1;
    //writeln(mid, ',',rnum, ',',mnum,',',Rrole[rnum].MagLevel[mid]);
    if Rrole[rnum].CurrentMP < Rmagic[mnum].NeedMP * level then
      level := Rrole[rnum].CurrentMP div Rmagic[mnum].NeedMP;
    if level > 10 then
      level := 10;
    if level <= 0 then
      continue;

    FillChar(aimHurt[0, 0], 4096 * 4, -1);
    step := Rmagic[mnum].MoveDistance[level - 1];
    range := Rmagic[mnum].AttDistance[level - 1];
    AttAreaType := Rmagic[mnum].AttAreaType;
    minstep := 0;

    ModifyRange(bnum, mnum, step, range);
    case AttAreaType of
      0:
        dis := step;
      1:
        dis := 1;
      2:
      begin
        dis := 0;
        minstep := -1;
      end;
      3:
        dis := step;
      4:
        dis := 1;
      5:
        dis := 1;
      6:
      begin
        dis := step;
        minstep := Rmagic[mnum].MinStep;
      end;
    end;

    //搜索收益最大的攻击点, 设置动画位置, 检查敌方是否处于位置之中
    for i1 := max(Mx - dis, 0) to min(Mx + dis, 63) do
    begin
      dis0 := abs(i1 - Mx);
      for i2 := max(My - dis + dis0, 0) to min(My + dis - dis0, 63) do
      begin
        //存在最小攻击距离的武功无需计算距离过小的点
        if abs(Mx - i1) + abs(My - i2) <= minstep then
          continue;
        //这里可能可以针对面类改写, 因为面类设置动画比较慢
        SetAminationPosition(Mx, My, i1, i2, AttAreaType, step, range);
        temphurt := 0;
        if ((AttAreaType = 0) or (AttAreaType = 3)) and (aimHurt[i1, i2] >= 0) then
        begin
          if aimHurt[i1, i2] > 0 then
            temphurt := aimHurt[i1, i2] + random(5) - random(5); //点面类攻击已经计算过的点简单处理
        end
        else
        begin
          for i := 0 to BRoleAmount - 1 do
          begin
            if (Brole[i].Team <> myteam) and (Brole[i].Dead = 0) and (BField[4, Brole[i].X, Brole[i].Y] > 0) then
            begin
              temphurt := temphurt + CalHurtValue2(bnum, i, mnum, level);
            end;
          end;
          aimHurt[i1, i2] := temphurt;
        end;
        if temphurt > tempmaxhurt then
        begin
          tempmaxhurt := temphurt;
          Ax1 := i1;
          Ay1 := i2;
          magicid := mid;
          cmlevel := level;
        end;
      end;
    end;
  end;

end;

function UseSpecialAbility(bnum, mnum, level: integer): boolean;
var
  Funcname: string;
  pFunc: function(bnum, mnum, level: integer): integer of object;
begin
  Result := False;
  if mnum > 0 then
    if (Rmagic[mnum].HurtType = 2) and (Rmagic[mnum].ScriptNum >= 0) then
    begin
      Funcname := Format('SA_%d', [Rmagic[mnum].ScriptNum]);
      TMethod(pFunc).Code := TSpecialAbility.MethodAddress(Funcname);
      if Assigned(TMethod(pFunc).Code) then
      begin
        pFunc(bnum, mnum, level);
        Result := True;
        ConsoleLog('Use Special Ability %d, level %d', [mnum, level]);
      end;
    end;
end;

function GetMagicWithSA2(SANum: smallint): smallint;
var
  i: integer;
begin
  Result := -1;
  for i := 1 to High(Rmagic) do
  begin
    if (Rmagic[i].HurtType = 4) and (Rmagic[i].ScriptNum = SANum) then
    begin
      Result := i;
      break;
    end;
  end;
end;

procedure CheckAttackAttachment(bnum, mnum, level: integer);
var
  Funcname: string;
  pFunc: function(bnum, mnum, mnum2, level: integer): integer of object;
  i: integer;
  f, mnum2: smallint;
begin
  f := Rrole[Brole[bnum].rnum].AmiFrameNum[0];
  mnum2 := GetMagicWithSA2(f);
  if (mnum2 > 0) and (Rmagic[mnum2].HurtType = 4) and (Rmagic[mnum2].Poison = 0) and
    (random(100) < Rmagic[mnum2].NeedMP) then
  begin
    Funcname := Format('SA2_%d', [f]);
    TMethod(pFunc).Code := TSpecialAbility2.MethodAddress(Funcname);
    if Assigned(TMethod(pFunc).Code) then
    begin
      pFunc(bnum, mnum, mnum2, level);
    end;
  end;

  for i := 0 to BRoleAmount - 1 do
  begin
    if (Brole[bnum].Team <> Brole[i].Team) and (Brole[i].Dead = 0) and (BField[4, Brole[i].X, Brole[i].Y] > 0) then
    begin
      f := Rrole[Brole[i].rnum].AmiFrameNum[0];
      mnum2 := GetMagicWithSA2(f);
      if (mnum2 > 0) and (Rmagic[mnum2].HurtType = 4) and (Rmagic[mnum2].Poison = 1) and
        (random(100) < Rmagic[mnum2].NeedMP) then
      begin
        Funcname := Format('SA2_%d', [f]);
        TMethod(pFunc).Code := TSpecialAbility2.MethodAddress(Funcname);
        if Assigned(TMethod(pFunc).Code) then
        begin
          pFunc(i, mnum, mnum2, level);
        end;
      end;
    end;
  end;
end;

procedure CheckDefenceAttachment(bnum, mnum, level: integer);
begin

end;

function CanSelectAim(bnum, aimbnum, mnum, aimMode: integer): boolean;
var
  HurtType: integer;
begin
  if mnum > 0 then
  begin
    HurtType := Rmagic[mnum].HurtType;
    aimMode := Rmagic[mnum].AddMP[0];
  end
  else
    HurtType := 2;
  if (Brole[aimbnum].Dead = 1) then
    Result := False
  else
    case HurtType of
      0, 1, 6: Result := Brole[bnum].Team <> Brole[aimbnum].Team;
      2://0-范围内敌方, 1-范围内我方, 2-敌方全部, 3-我方全部, 4-自身, 5-范围内全部, 6-全部, 7-不高亮
        case aimMode of
          0, 2: Result := Brole[bnum].Team <> Brole[aimbnum].Team;
          1, 3: Result := Brole[bnum].Team = Brole[aimbnum].Team;
          4: Result := bnum = aimbnum;
          5, 6: Result := True;
          7: Result := False;
        end;
      3: Result := False;
      else
        Result := False;
    end;
end;

//0特技, 状态类特技总入口

procedure TSpecialAbility.SA_0(bnum, mnum, level: integer);
var
  i, hurt, s, k, j, r: integer;
begin
  //状态类特技
  //AddMP, 0=适用目标（0范围内敌方, 1范围内我方, 2敌方全体, 3我方全体, 4自身, 5范围内全部, 6全部, 7空地）, 1-5=对应状态
  //Attack, 各级威力（0,1状态1；2,3状态2；4,5状态3；6,7状态4；8,9状态5）
  //HurtMP, 各级持续回合数
  ShowMagicName(mnum);
  for i := 0 to BRoleAmount - 1 do
  begin
    if (BField[4, Brole[i].X, Brole[i].Y] > 0) and (Brole[i].Dead = 0) then
    begin
      if (Rmagic[mnum].HurtType = 2) then
      begin
        hurt := 0;
        case Rmagic[mnum].AddMP[0] of
          0: if Brole[bnum].Team <> Brole[i].Team then
              hurt := 1;
          1: if Brole[bnum].Team = Brole[i].Team then
              hurt := 1;
          4: if bnum = i then
              hurt := 1;
        end;
        if hurt = 1 then
        begin
          s := 1;
          //Brole[i].shownumber := 1;
          while (s <= 5) and (Rmagic[mnum].AddMP[s] >= 0) do
          begin
            //k当前人物的水平
            //j特技能达到的水平
            k := Brole[i].StateLevel[Rmagic[mnum].AddMP[s]];
            j := Rmagic[mnum].Attack[(s - 1) * 2] + ((Rmagic[mnum].Attack[(s - 1) * 2 + 1] -
              Rmagic[mnum].Attack[(s - 1) * 2]) * (level - 1) div 9);
            //慈悲
            if Rmagic[mnum].AddMP[s] = 23 then
            begin
              Brole[i].StateLevel[Rmagic[mnum].AddMP[s]] := bnum;
              Brole[i].StateRound[Rmagic[mnum].AddMP[s]] := Rmagic[mnum].HurtMP[level - 1];
            end
            else
            //定身状态
            if (Rmagic[mnum].AddMP[s] = 26) then
            begin
              if (random(100) < j) {and (Brole[i].StateLevel[14] = 0)} then
              begin
                Brole[i].StateLevel[Rmagic[mnum].AddMP[s]] := -1;
                Brole[i].StateRound[Rmagic[mnum].AddMP[s]] := Rmagic[mnum].HurtMP[level - 1];
              end;
            end
            else
            begin
              //当前特技的水平定义为目前能够达到的最大值(负值为最小值)
              //如果二者异号, 强制为特技达到的水平, 即正面能覆盖负面, 或反之
              //其他情况, 包括有一个为0, 如果等级和回合能达到更大则覆盖, 即正面或负面效果只能保留最大
              r := Rmagic[mnum].HurtMP[level - 1];
              if bnum = i then
                r := r + 1;  //当对象为自身的时候, 回合数加1, 因为人物行动之后会立刻扣掉一回合
              ModifyState(i, Rmagic[mnum].AddMP[s], j, r);
            end;
            s := s + 1;
          end;
        end;
      end;
    end;
  end;
  PlaySoundA(Rmagic[mnum].SoundNum, 0);
  PlayActionAmination(bnum, Rmagic[mnum].MagicType); //动作效果
  //CalHurtRole(bnum, mnum, level, 1); //计算被打到的人物
  PlayMagicAmination(bnum, Rmagic[mnum].AmiNum, Rmagic[mnum].AddMP[0]); //武功效果
  //ShowHurtValue(Rmagic[mnum].HurtType, 1, str); //显示数字
  if Rmagic[mnum].NeedItem >= 0 then
    instruct_32(Rmagic[mnum].NeedItem, -Rmagic[mnum].NeedItemAmount);
end;

//状态增减

procedure ModifyState(bnum, statenum: integer; MaxValue, maxround: smallint);
var
  curvalue, curround: smallint;
begin
  if (bnum >= 0) and (bnum < BRoleAmount) and (MaxValue <> 0) and (maxround > 0) then
    if (statenum >= 0) and (statenum <= high(Brole[bnum].StateLevel)) then
    begin
      curvalue := Brole[bnum].StateLevel[statenum];
      curround := Brole[bnum].StateRound[statenum];
      case sign(curvalue) of
        0: //当前无状态, 直接写入
        begin
          curvalue := MaxValue;
          curround := maxround;
        end;
        1: //当前正面状态
        begin
          if MaxValue > 0 then
          begin
            //如需改写同面状态, 则选最大者
            curvalue := max(curvalue, MaxValue);
            curround := max(curround, maxround);
          end
          else
          begin
            //如需改为负面状态, 则首先计算能否抵消
            curvalue := curvalue + MaxValue;
            //刚好抵消则回合清零
            if curvalue = 0 then
              curround := 0;
            //未能完全抵消则回合数不变
            //if curvalue > 0 then curround := curround;
            //抵消仍有多余, 回合数若能完全抵消, 则按照新的
            if curvalue < 0 then
              curround := maxround;
          end;
        end;
        -1:
        begin
          if MaxValue < 0 then
          begin
            curvalue := min(curvalue, MaxValue);
            curround := max(curround, maxround);
          end
          else
          begin
            curvalue := curvalue + MaxValue;
            if curvalue = 0 then
              curround := 0;
            if curvalue > 0 then
              curround := maxround;
            //if curvalue < 0 then curround := maxround;
          end;
        end;
      end;
      Brole[bnum].StateLevel[statenum] := curvalue;
      Brole[bnum].StateRound[statenum] := curround;
    end;
  //ShowStringOnBrole('' + statestrs[statenum],bnum, 0, sign(maxvalue));
end;

//1特技, 娇生惯养

procedure TSpecialAbility.SA_1(bnum, mnum, level: integer);
begin
  ShowMagicName(mnum);
  GiveMeLife(bnum, mnum, level, 0);
end;

//人人为我, 自私自利

procedure GiveMeLife(bnum, mnum, level, Si: integer);
var
  i, addvalue, rnum, aimbnum: integer;
begin
  if BField[2, Ax, Ay] >= 0 then
  begin
    aimbnum := BField[2, Ax, Ay];
    if Brole[aimbnum].Team = Brole[bnum].Team then
    begin
      //ShowMagicName(mnum);
      instruct_67(Rmagic[mnum].SoundNum);
      PlayActionAmination(bnum, Rmagic[mnum].MagicType); //动作效果

      rnum := Brole[bnum].rnum;

      addvalue := 100 * level;
      if addvalue > Rrole[Brole[aimbnum].rnum].CurrentMP then
        addvalue := Rrole[Brole[aimbnum].rnum].CurrentMP;
      if addvalue > Rrole[Brole[bnum].rnum].MAXHP - Rrole[Brole[bnum].rnum].CurrentHP then
        addvalue := Rrole[Brole[bnum].rnum].MAXHP - Rrole[Brole[bnum].rnum].CurrentHP;
      BField[4, Brole[bnum].X, Brole[bnum].Y] := 1;
      BField[4, Brole[aimbnum].X, Brole[aimbnum].Y] := 1;
      if Brole[aimbnum].StateLevel[Si] > 10 then
        Brole[aimbnum].StateRound[Si] := Brole[aimbnum].StateRound[Si] + 1
      else
      begin
        Brole[aimbnum].StateLevel[Si] := 10;
        Brole[aimbnum].StateRound[Si] := 3;
      end;

      PlayMagicAmination(bnum, Rmagic[mnum].AmiNum, Rmagic[mnum].AddMP[0]);
    end;
  end;
  Brole[bnum].Acted := 1;
end;

//2特技, 舍己为人

procedure TSpecialAbility.SA_2(bnum, mnum, level: integer);
var
  i, aimbnum, rnum, MPnum: integer;
begin
  ShowMagicName(mnum);
  if BField[2, Ax, Ay] >= 0 then
  begin
    aimbnum := BField[2, Ax, Ay];
    if Brole[aimbnum].Team = Brole[bnum].Team then
    begin
      //ShowMagicName(mnum);
      instruct_67(Rmagic[mnum].SoundNum);
      PlayActionAmination(bnum, Rmagic[mnum].MagicType); //动作效果
      rnum := Brole[bnum].rnum;
      MPnum := 200 * level;
      if MPnum > Rrole[rnum].CurrentMP then
        MPnum := Rrole[rnum].CurrentMP;
      if MPnum > Rrole[Brole[aimbnum].rnum].MaxMP - Rrole[Brole[aimbnum].rnum].CurrentMP then
        MPnum := Rrole[Brole[aimbnum].rnum].MaxMP - Rrole[Brole[aimbnum].rnum].CurrentMP;
      Rrole[rnum].CurrentMP := Rrole[rnum].CurrentMP - MPnum;
      Rrole[Brole[aimbnum].rnum].CurrentMP := Rrole[Brole[aimbnum].rnum].CurrentMP + MPnum;
      PlayMagicAmination(bnum, Rmagic[mnum].AmiNum, Rmagic[mnum].AddMP[0]);
    end;
  end;
  Brole[bnum].Acted := 1;
end;

//3特技, 药王神篇

procedure TSpecialAbility.SA_3(bnum, mnum, level: integer);
var
  i, curenum, rnum, m: integer;
begin
  //如果是AI控制, 则在至少两名队友中毒才使用
  if (Brole[bnum].Team <> 0) or (Brole[bnum].Auto <> 0) then
  begin
    m := 0;
    for i := 0 to BRoleAmount - 1 do
    begin
      rnum := Brole[i].rnum;
      if Brole[bnum].team = Brole[i].team then
        if Rrole[rnum].Poison > 0 then
          m := m + 1;
    end;
    if m < 2 then
      exit;
  end;
  ShowMagicName(mnum);
  instruct_67(Rmagic[mnum].SoundNum);
  PlayActionAmination(bnum, Rmagic[mnum].MagicType); //动作效果

  rnum := Brole[bnum].rnum;
  curenum := 5 * level;
  for i := 0 to BRoleAmount - 1 do
  begin
    if (Brole[i].Team = Brole[bnum].Team) and (Brole[i].Dead = 0) then
    begin
      Brole[i].ShowNumber := min(Rrole[Brole[i].rnum].Poison, curenum);
      Rrole[Brole[i].rnum].Poison := max(0, Rrole[Brole[i].rnum].Poison - curenum);
      BField[4, Brole[i].X, Brole[i].Y] := 1;
    end;
  end;

  PlayMagicAmination(bnum, Rmagic[mnum].AmiNum, Rmagic[mnum].AddMP[0]);
  ShowHurtValue(4);
  Brole[bnum].Acted := 1;
end;


//4打坐吐纳, 减体加内

procedure TSpecialAbility.SA_4(bnum, mnum, level: integer);
var
  dePhy, addMP, rnum: integer;
begin
  //如果是AI控制, 则在内力少于一半才使用
  rnum := Brole[bnum].rnum;
  if (Brole[bnum].Team <> 0) or (Brole[bnum].Auto <> 0) then
    if Rrole[rnum].CurrentMP > Rrole[rnum].MaxMP div 2 then
      exit;
  ShowMagicName(mnum);
  instruct_67(Rmagic[mnum].SoundNum);
  PlayActionAmination(bnum, Rmagic[mnum].MagicType); //动作效果

  rnum := Brole[bnum].rnum;

  dePhy := 20;
  if dePhy > Rrole[rnum].PhyPower then
    dePhy := Rrole[rnum].PhyPower;
  addMp := dePhy * 100;
  if addMp > Rrole[rnum].MaxMP - Rrole[rnum].CurrentMP then
    addMp := Rrole[rnum].MaxMP - Rrole[rnum].CurrentMP;
  dePhy := addMp div 100;

  Rrole[rnum].PhyPower := Rrole[rnum].PhyPower - dePhy;
  Rrole[rnum].CurrentMP := Rrole[rnum].CurrentMP + addMp;

  BField[4, Brole[bnum].X, Brole[bnum].Y] := 1;
  Brole[bnum].ShowNumber := addMp;
  PlayMagicAmination(bnum, Rmagic[mnum].AmiNum, Rmagic[mnum].AddMP[0]);
  ShowHurtValue(2, 0, '+d%');
  Brole[bnum].Acted := 1;
end;

procedure TSpecialAbility.SA_5(bnum, mnum, level: integer);
begin
  ShowMagicName(mnum);
  GiveMeLife(bnum, mnum, level, 1);
end;

//5妙手空空, 偷取敌人物品
//当敌人身上没有物品时有一个列表, 几率与物品价格相关

procedure TSpecialAbility.SA_6(bnum, mnum, level: integer);
var
  i, aimbnum, aimrnum, rnum, itemid, itemnum, k: integer;
  str: WideString;
  stealitems: array [0..22] of smallint = (0, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15,
    16, 17, 18, 206, 207, 208, 209, 210);
  stealitems0: array [0..29] of smallint = (0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14,
    15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 171, 172);

  procedure StealRandom;
  var
    i: integer;
  begin
    if random(100) < level * 5 then
    begin
      case MODVersion of
        13: i := stealitems[random(length(stealitems))];
        0: i := stealitems0[random(length(stealitems0))];
      end;
      if random <= power(0.9954, Ritem[i].Price) then
      begin
        instruct_2(i, 1 + random(level));
      end;
    end;
  end;

begin
  ShowMagicName(mnum);
  aimbnum := BField[2, Ax, Ay];
  BField[4, Ax, Ay] := 1;
  instruct_67(Rmagic[mnum].SoundNum);
  PlayActionAmination(bnum, Rmagic[mnum].MagicType); //动作效果
  PlayMagicAmination(bnum, Rmagic[mnum].AmiNum, Rmagic[mnum].AddMP[0]); //武功效果
  if aimbnum >= 0 then
  begin
    if Brole[aimbnum].Team <> Brole[bnum].Team then
    begin
      rnum := Brole[bnum].rnum;
      aimrnum := Brole[aimbnum].rnum;
      itemid := -1;
      for k := 0 to 2 do
      begin
        if Rrole[aimrnum].TakingItem[k] >= 0 then
        begin
          if random(100) > 50 then
          begin
            itemid := Rrole[aimrnum].TakingItem[k];
            itemnum := random(Rrole[aimrnum].TakingItemAmount[k]) + 1;
            break;
          end;
        end;
      end;
      if itemid >= 0 then
      begin
        Rrole[aimrnum].TakingItemAmount[k] := Rrole[aimrnum].TakingItemAmount[k] - itemnum;
        if Rrole[aimrnum].TakingItemAmount[k] <= 0 then
          Rrole[aimrnum].TakingItem[k] := -1;
        instruct_2(itemid, itemnum);
      end
      else
        StealRandom;
    end;
  end;
  if (random(100) < 30) then
  begin
    str := UTF8Decode('偷天換日');
    ShowMagicName(0, str);
    FillChar(BField[4, 0, 0], 4096 * 2, 0);
    for i := 0 to BRoleAmount - 1 do
      if (Brole[bnum].Team <> Brole[i].Team) and (Brole[i].Dead = 0) then
        BField[4, Brole[i].x, Brole[i].y] := 1 + random(6);
    instruct_67(Rmagic[mnum].SoundNum);
    PlayActionAmination(bnum, Rmagic[mnum].MagicType); //动作效果
    PlayMagicAmination(bnum, 100, Rmagic[mnum].AddMP[0]); //武功效果
    Redraw;
    for i := 0 to BRoleAmount - 1 do
    begin
      Brole[i].ShowNumber := -1;
      rnum := Brole[bnum].rnum;
      if (Brole[bnum].Team <> Brole[i].Team) and (Brole[i].Dead = 0) then
      begin
        aimrnum := Brole[aimbnum].rnum;
        itemid := -1;
        for k := 0 to 2 do
        begin
          CheckBasicEvent;
          if Rrole[aimrnum].TakingItem[k] >= 0 then
          begin
            if random(100) < 30 then
            begin
              itemid := Rrole[aimrnum].TakingItem[k];
              itemnum := random(Rrole[aimrnum].TakingItemAmount[k]) + 1;
              break;
            end;
          end;
        end;
        if itemid >= 0 then
        begin
          Rrole[aimrnum].TakingItemAmount[k] := Rrole[aimrnum].TakingItemAmount[k] - itemnum;
          if Rrole[aimrnum].TakingItemAmount[k] <= 0 then
            Rrole[aimrnum].TakingItem[k] := -1;
          instruct_2(itemid, itemnum);
        end
        else
          StealRandom;
      end;
    end;
  end;
  Brole[bnum].Acted := 1;
end;

//7特技, 阎王敌, 全体加生命

procedure TSpecialAbility.SA_7(bnum, mnum, level: integer);
var
  i, curenum, rnum, m: integer;
begin
  //如果是AI控制, 则在至少两名队友生命少于4/5才使用
  if (Brole[bnum].Team <> 0) or (Brole[bnum].Auto <> 0) then
  begin
    m := 0;
    for i := 0 to BRoleAmount - 1 do
    begin
      rnum := Brole[i].rnum;
      if Brole[bnum].team = Brole[i].team then
        if Rrole[rnum].CurrentHP < Rrole[rnum].MaxHP * 4 div 5 then
          m := m + 1;
    end;
    if m < 2 then
      exit;
  end;

  ShowMagicName(mnum);
  instruct_67(Rmagic[mnum].SoundNum);
  PlayActionAmination(bnum, Rmagic[mnum].MagicType); //动作效果
  rnum := Brole[bnum].rnum;
  for i := 0 to BRoleAmount - 1 do
  begin
    if (Brole[i].Team = Brole[bnum].Team) and (Brole[i].Dead = 0) then
    begin
      curenum := Rrole[Brole[i].rnum].MaxHP * 5 * level div 100;
      Rrole[Brole[i].rnum].CurrentHP := Rrole[Brole[i].rnum].CurrentHP + curenum;
      if Rrole[Brole[i].rnum].CurrentHP > Rrole[Brole[i].rnum].MAXHP then
        Rrole[Brole[i].rnum].CurrentHP := Rrole[Brole[i].rnum].MAXHP;
      BField[4, Brole[i].X, Brole[i].Y] := 1;
      Brole[i].ShowNumber := curenum;
    end;
  end;
  PlayMagicAmination(bnum, Rmagic[mnum].AmiNum, Rmagic[mnum].AddMP[0]);
  ShowHurtValue(3);
  Brole[bnum].Acted := 1;
end;

//8特技, 运功疗伤, 减内加血

procedure TSpecialAbility.SA_8(bnum, mnum, level: integer);
var
  deMP, addHP, rnum: integer;
begin
  //如果是AI控制, 则在生命少于一半才使用
  rnum := Brole[bnum].rnum;
  if (Brole[bnum].Team <> 0) or (Brole[bnum].Auto <> 0) then
    if Rrole[rnum].CurrentHP > Rrole[rnum].MaxHP div 2 then
      exit;
  ShowMagicName(mnum);
  instruct_67(Rmagic[mnum].SoundNum);
  PlayActionAmination(bnum, Rmagic[mnum].MagicType); //动作效果

  deMP := 100 * level;
  if deMP > Rrole[rnum].CurrentMP then
    deMP := Rrole[rnum].CurrentMP;
  addHP := deMP;
  if addHP > Rrole[rnum].MaxHP - Rrole[rnum].CurrentHP then
    addHp := Rrole[rnum].MaxHP - Rrole[rnum].CurrentHP;
  deMP := addHp;

  Rrole[rnum].CurrentMP := Rrole[rnum].CurrentMP - deMP;
  Rrole[rnum].CurrentHP := Rrole[rnum].CurrentHP + addHp;

  BField[4, Brole[bnum].X, Brole[bnum].Y] := 1;
  Brole[bnum].ShowNumber := addHp;
  PlayMagicAmination(bnum, Rmagic[mnum].AmiNum, Rmagic[mnum].AddMP[0]);
  ShowHurtValue(3);
  Brole[bnum].Acted := 1;
end;

procedure TSpecialAbility.SA_9(bnum, mnum, level: integer);
begin
  ShowMagicName(mnum);
  ambush(bnum, mnum, level, 1);
end;

procedure TSpecialAbility.SA_10(bnum, mnum, level: integer);
begin
  ShowMagicName(mnum);
  ambush(bnum, mnum, level, 0);
end;

//十面埋伏, 潇湘夜雨

procedure ambush(bnum, mnum, level, Si: integer);
var
  i, rnum: integer;
begin
  rnum := Brole[bnum].rnum;
  for i := 0 to BRoleAmount - 1 do
    if Brole[i].Dead = 0 then
    begin
      if (Brole[i].Team <> Brole[bnum].team) and (Brole[i].StateLevel[18] = 0) then
      begin
        if Brole[i].StateLevel[Si] >= 0 then
        begin
          Brole[i].StateLevel[Si] := Rmagic[mnum].Attack[0] + trunc(Rmagic[mnum].Attack[0] *
            (100 + (Rmagic[mnum].Attack[1] - Rmagic[mnum].Attack[0]) * level / 10) / 100);
          Brole[i].StateRound[Si] := Rmagic[mnum].HurtMP[level];
        end
        else
        begin
          Brole[i].StateLevel[Si] := Brole[i].StateLevel[Si] - 1;
          Brole[i].StateRound[Si] := Brole[i].StateRound[Si] + 1;
        end;
        BField[4, Brole[i].X, Brole[i].Y] := 1;
      end;

      if Brole[i].StateLevel[18] > 0 then
      begin
        if Brole[i].StateLevel[Si] <= 0 then
        begin
          Brole[i].StateLevel[Si] := -(Rmagic[mnum].Attack[0] + trunc(Rmagic[mnum].Attack[0] *
            (100 + (Rmagic[mnum].Attack[1] - Rmagic[mnum].Attack[0]) * level / 10) / 100));
          Brole[i].StateRound[Si] := Rmagic[mnum].HurtMP[level];
        end
        else
        begin
          Brole[i].StateLevel[Si] := Brole[i].StateLevel[Si] + 1;
          Brole[i].StateRound[Si] := Brole[i].StateRound[Si] + 1;
        end;
        BField[4, Brole[i].X, Brole[i].Y] := 1;
      end;
    end;

  PlayMagicAmination(bnum, Rmagic[mnum].AmiNum, Rmagic[mnum].AddMP[0]);
  Brole[bnum].Acted := 1;
end;

//11特技, 狮子吼

procedure TSpecialAbility.SA_11(bnum, mnum, level: integer);
var
  i, hurt, rnum: integer;
begin
  ShowMagicName(mnum);
  instruct_67(Rmagic[mnum].SoundNum);
  PlayActionAmination(bnum, Rmagic[mnum].MagicType); //动作效果

  rnum := Brole[bnum].rnum;

  hurt := 50 * level;
  for i := 0 to BRoleAmount - 1 do
  begin
    if (i <> bnum) and (Brole[i].Dead = 0) and (Brole[i].StateLevel[18] = 0) then
    begin
      Rrole[Brole[i].rnum].CurrentHP := Rrole[Brole[i].rnum].CurrentHP - hurt;
      if Rrole[Brole[i].rnum].CurrentHP < 0 then
        Rrole[Brole[i].rnum].CurrentHP := 0;
      BField[4, Brole[i].X, Brole[i].Y] := 1;
      Brole[i].ShowNumber := hurt;
    end;

    if Brole[i].StateLevel[18] > 0 then
    begin
      Rrole[Brole[i].rnum].CurrentHP := Rrole[Brole[i].rnum].CurrentHP + hurt;
      if Rrole[Brole[i].rnum].CurrentHP > Rrole[Brole[i].rnum].MAXHP then
        Rrole[Brole[i].rnum].CurrentHP := Rrole[Brole[i].rnum].MAXHP;
      BField[4, Brole[i].X, Brole[i].Y] := 1;
      //brole[i].ShowNumber:=addmp;
    end;

  end;
  PlayMagicAmination(bnum, Rmagic[mnum].AmiNum, Rmagic[mnum].AddMP[0]);
  ShowHurtValue(0);
  Brole[bnum].Acted := 1;
end;

//吸星大法, 直线攻击, 吸内, 并拉近目标

procedure TSpecialAbility.SA_12(bnum, mnum, level: integer);
var
  i, incx, incy, curx, cury, aimx, aimy, aimbnum, hurt, rnum: integer;
begin
  ShowMagicName(mnum);
  instruct_67(Rmagic[mnum].SoundNum);
  PlayActionAmination(bnum, Rmagic[mnum].MagicType);
  PlayMagicAmination(bnum, Rmagic[mnum].AmiNum, Rmagic[mnum].AddMP[0]); //武功效果
  rnum := Brole[bnum].rnum;
  incx := Ax - Bx;
  incy := Ay - By;
  curx := Bx;
  cury := By;
  for i := 0 to Rmagic[mnum].movedistance[level - 1] - 1 do
  begin
    curx := curx + incx;
    cury := cury + incy;
    if BField[2, curx, cury] >= 0 then
    begin
      aimbnum := BField[2, curx, cury];
      aimx := curx;
      aimy := cury;
      while (BField[2, aimx - incx, aimy - incy] < 0) and (BField[1, aimx - incx, aimy - incy] <= 0) do
      begin
        aimx := aimx - incx;
        aimy := aimy - incy;
      end;
      BField[2, curx, cury] := -1;
      BField[2, aimx, aimy] := aimbnum;
      Brole[aimbnum].X := aimx;
      Brole[aimbnum].Y := aimy;

      hurt := Rmagic[mnum].HurtMP[level - 1] + random(5) - random(5);
      Brole[aimbnum].ShowNumber := hurt;
      Rrole[Brole[aimbnum].rnum].CurrentMP := Rrole[Brole[aimbnum].rnum].CurrentMP - hurt;
      if Rrole[Brole[aimbnum].rnum].CurrentMP <= 0 then
        Rrole[Brole[aimbnum].rnum].CurrentMP := 0;

      Brole[aimbnum].StateLevel[0] := -5 * level;
      Brole[aimbnum].StateRound[0] := level;
      Brole[aimbnum].StateLevel[1] := -5 * level;
      Brole[aimbnum].StateRound[1] := level;


      //增加己方内力及最大值
      Rrole[rnum].CurrentMP := Rrole[rnum].CurrentMP + hurt;
      Rrole[rnum].MaxMP := Rrole[rnum].MaxMP + random(hurt div 2);
      if Rrole[rnum].MaxMP > MAX_MP then
        Rrole[rnum].MaxMP := MAX_MP;
      if Rrole[rnum].CurrentMP > Rrole[rnum].MaxMP then
        Rrole[rnum].CurrentMP := Rrole[rnum].MaxMP;
    end;
  end;
  ShowHurtValue(1); //显示数字
  Brole[bnum].Acted := 1;
end;

//13特技, 含沙射影, 全体下毒

procedure TSpecialAbility.SA_13(bnum, mnum, level: integer);
var
  i, curenum, rnum: integer;
begin
  ShowMagicName(mnum);
  instruct_67(Rmagic[mnum].SoundNum);
  PlayActionAmination(bnum, Rmagic[mnum].MagicType);
  rnum := Brole[bnum].rnum;
  //curenum := MAX_PHYSICAL_POWER * 3 * level div 100;
  for i := 0 to BRoleAmount - 1 do
  begin
    if (Brole[i].Team <> Brole[bnum].Team) and (Brole[i].Dead = 0) then
    begin
      curenum := MAX_PHYSICAL_POWER * 3 * level div 100 + random(3);
      Rrole[Brole[i].rnum].Poison := Rrole[Brole[i].rnum].Poison + curenum;
      Brole[i].ShowNumber := curenum;
      if Rrole[Brole[i].rnum].Poison > 99 then
        Rrole[Brole[i].rnum].Poison := 99;
      BField[4, Brole[i].X, Brole[i].Y] := 1 + random(6);
    end;
  end;
  PlayMagicAmination(bnum, Rmagic[mnum].AmiNum, Rmagic[mnum].AddMP[0]);
  ShowHurtValue(2);
  Brole[bnum].Acted := 1;
end;

//14特技乱石嶙峋

procedure TSpecialAbility.SA_14(bnum, mnum, level: integer);
var
  stonenum, i, x, y, i1, i2, k, k1, havestone, rnum: integer;
  r: boolean;
  pos: TPosition;
begin
  ShowMagicName(mnum);
  instruct_67(Rmagic[mnum].SoundNum);
  PlayActionAmination(bnum, Rmagic[mnum].MagicType); //动作效果

  stonenum := Rmagic[mnum].Attack[0] + ((Rmagic[mnum].Attack[1] - Rmagic[mnum].Attack[0]) * level div 10);
  CalCanSelect(bnum, 1, Rmagic[mnum].MoveDistance[level - 1]);

  //首先计算场上的乱石数目
  {havestone := 0;
  for i := 0 to BRoleAmount - 1 do
    if Brole[i].IsStone > 0 then
      havestone := havestone + 1;}

  for i := 0 to stonenum - 1 do
  begin
    Ax := Bx;
    Ay := By;

    if (Brole[bnum].Auto = 0) and (Brole[bnum].Team = 0) then
    begin
      while (BField[2, Ax, Ay] <> -1) or (BField[1, Ax, Ay] <> 0) do
        while not SelectRange(bnum, 0, Rmagic[mnum].MoveDistance[level - 1], 0) do ;
    end
    else
    begin
      k := 0;
      for i1 := 0 to 63 do
        for i2 := 0 to 63 do
        begin
          if (BField[2, i1, i2] = -1) and (BField[1, i1, i2] = 0) and (BField[3, i1, i2] = 0) then
          begin
            k1 := random(10000);
            if k1 > k then
            begin
              k := k1;
              Ax := i1;
              Ay := i2;
            end;
          end;
        end;
    end;

    BField[1, Ax, Ay] := 1487 * 2;
    CalPosOnImage(Ax, Ay, x, y);
    //InitialBPic(1487, x, y, 1, CalBlock(Ax, Ay)); //建筑层需遮挡值
    Redraw;

    //乱石为我方不能攻击之队友, 防御999, 生命9999, 内力9999
    {k:=broleamount;
    rnum :=  925 + i+havestone;
    fillchar(brole[k],sizeof[TBattleRole],0);
    Brole[k].rnum := rnum;
    Brole[k].IsStone := rnum;
    Brole[k].Team := brole[bnum].Team;
    broleamount:=broleamount+1;}
  end;
  //InitialBFieldImage;
  Brole[bnum].Acted := 1;

end;

//15特技同仇敌忾, 多人围殴目标敌人

procedure TSpecialAbility.SA_15(bnum, mnum, level: integer);
var
  gridnum, Ax1, Ax2, Ay1, Ay2, x, y: integer;
  attackbnum, attackmnum, attacklevel, hurt: integer;
begin
  ShowMagicName(mnum);
  gridnum := Rmagic[mnum].Attack[0] + (Rmagic[mnum].Attack[1] - Rmagic[mnum].Attack[0]) * level div 10;
  Ax1 := Ax - gridnum;
  if Ax1 < 0 then
    Ax1 := 0;
  Ax2 := Ax + gridnum;
  if Ax2 > 63 then
    Ax2 := 63;
  Ay1 := Ay - gridnum;
  if Ay1 < 0 then
    Ay1 := 0;
  Ay2 := Ay + gridnum;
  if Ay2 > 63 then
    Ay2 := 63;

  BField[4, Ax, Ay] := 1;
  for x := Ax1 to Ax2 do
    for y := Ay1 to Ay2 do
    begin
      if BField[2, x, y] > -1 then
        if (Brole[BField[2, x, y]].Dead = 0) and (Brole[BField[2, x, y]].Team = Brole[bnum].Team) then
        begin
          attackbnum := BField[2, x, y];
          attackmnum := Rrole[Brole[attackbnum].rnum].magic[1];
          attacklevel := Rrole[Brole[attackbnum].rnum].maglevel[1] div 100 + 1;
          //AttackAction(attackbnum, attackmnum, attacklevel);
          ShowMagicName(attackmnum);
          instruct_67(Rmagic[attackmnum].SoundNum);
          PlayActionAmination(attackbnum, Rmagic[attackmnum].MagicType); //动作效果
          CalHurtRole(attackbnum, attackmnum, attacklevel, 1); //计算被打到的人物
          PlayMagicAmination(attackbnum, Rmagic[attackmnum].AmiNum, Rmagic[mnum].AddMP[0]); //武功效果
          Brole[attackmnum].Pic := 0;
          ShowHurtValue(Rmagic[attackmnum].HurtType); //显示数字
        end;
    end;
  Brole[bnum].Acted := 1;
end;

//16静诵黄庭, 全体恢复体力

procedure TSpecialAbility.SA_16(bnum, mnum, level: integer);
var
  i, curenum, rnum, m: integer;
begin
  //如果是AI控制, 则在至少两名队友体力低于一半才使用
  if (Brole[bnum].Team <> 0) or (Brole[bnum].Auto <> 0) then
  begin
    m := 0;
    for i := 0 to BRoleAmount - 1 do
    begin
      rnum := Brole[i].rnum;
      if Brole[bnum].team = Brole[i].team then
        if Rrole[rnum].PhyPower < MAX_PHYSICAL_POWER div 2 then
          m := m + 1;
    end;
    if m < 2 then
      exit;
  end;

  ShowMagicName(mnum);
  instruct_67(Rmagic[mnum].SoundNum);
  PlayActionAmination(bnum, Rmagic[mnum].MagicType); //动作效果

  rnum := Brole[bnum].rnum;

  curenum := MAX_PHYSICAL_POWER * 5 * level div 100;
  for i := 0 to BRoleAmount - 1 do
  begin
    if (Brole[i].Team = Brole[bnum].Team) and (Brole[i].Dead = 0) then
    begin
      Rrole[Brole[i].rnum].PhyPower := Rrole[Brole[i].rnum].PhyPower + curenum;
      if Rrole[Brole[i].rnum].PhyPower > MAX_PHYSICAL_POWER then
        Rrole[Brole[i].rnum].PhyPower := MAX_PHYSICAL_POWER;
      BField[4, Brole[i].X, Brole[i].Y] := 1;
      Brole[i].ShowNumber := curenum;
    end;
  end;

  PlayMagicAmination(bnum, Rmagic[mnum].AmiNum, Rmagic[mnum].AddMP[0]);
  ShowHurtValue(3);
  Brole[bnum].Acted := 1;
end;

//17乱世浮萍, 把行动机会让给目标队友

procedure TSpecialAbility.SA_17(bnum, mnum, level: integer);
var
  bnum2, oldactstatus: integer;
begin
  ShowMagicName(mnum);
  BField[4, Bx, By] := 1;
  BField[4, Ax, Ay] := 10;
  bnum2 := BField[2, Ax, Ay];
  Bx := Ax;
  By := Ay;
  if bnum2 >= 0 then
  begin
    if Brole[bnum2].Team = Brole[bnum].Team then
    begin
      PlayMagicAmination(bnum, Rmagic[mnum].AmiNum, Rmagic[mnum].AddMP[0]);
      oldactstatus := Brole[bnum2].Acted;
      Brole[bnum2].Acted := 0;
      if (Brole[bnum2].Auto = 0) and (Brole[bnum2].Team = 0) then
      begin
        while Brole[bnum2].Acted = 0 do
        begin
          case BattleMenu(bnum2) of
            0: MoveRole(bnum2);
            1: Attack(bnum2);
            2: UsePoison(bnum2);
            3: MedPoison(bnum2);
            4: Medcine(bnum2);
            5: BattleMenuItem(bnum2);
            6: Wait(bnum2);
            7: SelectShowStatus(bnum2);
            8, 9: Rest(bnum2);
          end;
        end;
      end
      else
        AutoBattle3(bnum2);
      Brole[bnum2].Acted := oldactstatus;
      Rrole[Brole[bnum].rnum].CurrentMP := Rrole[Brole[bnum].rnum].CurrentMP - Rmagic[mnum].NeedMP * level;
      if Rrole[Brole[bnum].rnum].CurrentMP < 0 then
        Rrole[Brole[bnum].rnum].CurrentMP := 0;
    end;
  end;
  Brole[bnum].Acted := 1;
end;

//18神照功, 复活队友

procedure TSpecialAbility.SA_18(bnum, mnum, level: integer);
var
  i, res, newlife, amount, k, k1, i1, i2, rnum, hurt, rnum2, bnum2: integer;
  bnumarray: array of smallint;
  str: WideString;
  menuString: array of WideString;
begin
  ShowMagicName(mnum);
  rnum := Brole[bnum].rnum;
  //AI控制时, 随机选择范围内一点
  if (Brole[bnum].Auto <> 0) or (Brole[bnum].Team <> 0) then
  begin
    k := 0;
    for i1 := 0 to 63 do
      for i2 := 0 to 63 do
      begin
        if (BField[2, i1, i2] = -1) and (BField[1, i1, i2] = 0) and (BField[3, i1, i2] = 0) then
        begin
          k1 := random(10000);
          if k1 > k then
          begin
            k := k1;
            Ax := i1;
            Ay := i2;
          end;
        end;
      end;
  end;
  if (BField[2, Ax, Ay] = -1) and (BField[1, Ax, Ay] = 0) and (Rrole[Brole[bnum].rnum].CurrentHP > 1) then
  begin
    setlength(menuString, 26);
    setlength(bnumarray, 26);
    amount := 0;
    for i := 0 to BRoleAmount - 1 do
    begin
      if (Brole[i].Team = Brole[bnum].Team) and (Brole[i].Dead = 1) then
      begin
        menuString[amount] := pWideChar(@Rrole[Brole[i].rnum].Name);
        bnumarray[amount] := i;
        amount := amount + 1;
      end;
    end;
    //我方统计被击退人数
    if amount > 0 then
    begin
      if (Brole[bnum].Auto > 0) or (Brole[bnum].Team <> 0) then
        res := 0
      else
        res := CommonMenu(300, 200, 105, amount - 1, 0, menuString);
      bnum2 := bnumarray[res];
      rnum2 := Brole[bnum2].rnum;
      newlife := min(Rrole[rnum].CurrentHP - 1, Rrole[rnum].MaxHP * level div 10);
      Rrole[rnum].CurrentHP := Rrole[rnum].CurrentHP - newlife;
      if Rrole[rnum].CurrentHP < 1 then
        Rrole[rnum].CurrentHP := 1;
      Brole[bnum2].Dead := 0;
      Rrole[rnum2].CurrentHP := newlife;
      if Rrole[rnum2].CurrentHP > Rrole[rnum2].MaxHP then
        Rrole[rnum2].CurrentHP := Rrole[rnum2].MaxHP;
      Brole[bnum2].X := Ax;
      Brole[bnum2].Y := Ay;
      Brole[bnum2].alpha := 0;
      Brole[bnum2].mixAlpha := 0;

      BField[2, Ax, Ay] := bnum2;
    end
    else
    begin
      Rrole[rnum].CurrentHP := min(Rrole[rnum].MaxHP, Rrole[rnum].CurrentHP + 60 * level);
    end;
  end
  else
  begin
    //没有被击退人员则恢复自己生命
    Rrole[rnum].CurrentHP := min(Rrole[rnum].MaxHP, Rrole[rnum].CurrentHP + 60 * level);
  end;
  Rrole[rnum].CurrentMP := max(0, Rrole[rnum].CurrentMP - Rmagic[mnum].NeedMP * level);
  PlayMagicAmination(bnum, Rmagic[mnum].AmiNum, Rmagic[mnum].AddMP[0]);
  Brole[bnum].Acted := 1;

end;

//19神行百变, 直线敌人随机陷入负面状态

procedure TSpecialAbility.SA_19(bnum, mnum, level: integer);
var
  bnumarray, bnumx, bnumy: array[0..30] of smallint;
  enemyamount, aimx, aimy, i, incx, incy, si, sn, sl, sr, i1, i2, k, bnum2, ax1, ay1: smallint;
  findenemy: boolean;
begin
  ShowMagicName(mnum);
  enemyamount := 0;
  findenemy := True;
  bnum2 := BField[2, Ax, Ay];
  //这里如果方向不正确, 所选位置没有敌人, 则重选方向, 否则失败
  if (bnum2 < 0) or (abs(Ax - Bx) + (Ay - By) <> 1) or (Brole[bnum2].Team = Brole[bnum].Team) then
  begin
    findenemy := False;
    k := 0;
    for i1 := -1 to 1 do
      for i2 := -1 to 1 do
      begin
        if (i1 * i2 = 0) and (i1 + i2 <> 0) then
        begin
          Ax1 := Bx + i1;
          Ay1 := By + i2;
          bnum2 := BField[2, Ax1, Ay1];
          if (bnum2 >= 0) and (Brole[bnum2].Team <> Brole[bnum].Team) then
          begin
            k := k + 1;
            if random(k) = 0 then
            begin
              Ax := Ax1;
              Ay := Ay1;
              findenemy := True;
            end;
          end;
        end;
      end;
  end;
  incx := Ax - Bx;
  incy := Ay - By;
  aimx := Ax;
  aimy := Ay;
  if findenemy then
  begin
    while True do
    begin
      if BField[2, aimx, aimy] <> -1 then
      begin
        if Brole[BField[2, aimx, aimy]].Team <> Brole[bnum].team then
        begin
          bnumarray[enemyamount] := BField[2, aimx, aimy];
          bnumx[enemyamount] := aimx;
          bnumy[enemyamount] := aimy;
          enemyamount := enemyamount + 1;
        end;
      end
      else
      if BField[1, aimx, aimy] = 0 then
        break
      else
      begin
        aimx := Bx;
        aimy := By;
        if enemyamount > 0 then
          enemyamount := 1;
        break;
      end;
      aimx := aimx + incx;
      aimy := aimy + incy;
    end;

    if enemyamount > 0 then
    begin
      for i := 0 to enemyamount - 1 do
      begin
        si := random(5);
        sn := Rmagic[mnum].addmp[si + 1];
        sl := Rmagic[mnum].Attack[si * 2] + (Rmagic[mnum].Attack[si * 2 + 1] - Rmagic[mnum].Attack[si * 2]) *
          level div 10;
        sr := Rmagic[mnum].hurtmp[level - 1];
        if sl < Brole[bnumarray[i]].StateLevel[sn] then
          Brole[bnumarray[i]].StateLevel[sn] := sl;
        if sr > Brole[bnumarray[i]].StateRound[sn] then
          Brole[bnumarray[i]].StateRound[sn] := sr;
        Rrole[Brole[bnumarray[i]].rnum].CurrentHP :=
          Rrole[Brole[bnumarray[i]].rnum].CurrentHP - Rrole[Brole[bnumarray[i]].rnum].MaxHP div 10;
        if Rrole[Brole[bnumarray[i]].rnum].CurrentHP < 1 then
          Rrole[Brole[bnumarray[i]].rnum].CurrentHP := 1;
        BField[4, bnumx[i], bnumy[i]] := (abs(bnumx[i] - Bx) + abs(bnumy[i] - By)) * 10;
      end;
    end;
    BField[2, Brole[bnum].X, Brole[bnum].Y] := -1;
    BField[2, aimx, aimy] := bnum;
    Brole[bnum].X := aimx;
    Brole[bnum].Y := aimy;
    Bx := aimx;
    By := aimy;
    PlayMagicAmination(bnum, Rmagic[mnum].AmiNum, Rmagic[mnum].AddMP[0]);
  end;
  Brole[bnum].Acted := 1;

end;

//20万里独行

procedure TSpecialAbility.SA_20(bnum, mnum, level: integer);
var
  step, pstep, rnum, hurtvalue, i1, i2, k, aimbnum, ax1, ay1, ax2, ay2: integer;
  select: boolean;
begin
  ShowMagicName(mnum);
  instruct_67(Rmagic[mnum].SoundNum);
  aimbnum := BField[2, Ax, Ay];
  step := abs(Ax - Brole[bnum].X) + abs(Ay - Brole[bnum].Y);
  select := False;
  Ax2 := Ax;
  Ay2 := Ay;
  //在目标身旁选择一个空位
  if (aimbnum >= 0) then
    for i1 := -1 to 1 do
      for i2 := -1 to 1 do
      begin
        k := 0;
        if (i1 * i2 = 0) and (i1 + i2 <> 0) then
        begin
          ax1 := Ax + i1;
          ay1 := Ay + i2;
          if (BField[1, ax1, ay1] <= 0) and (BField[2, ax1, ay1] < 0) or (BField[2, ax1, ay1] = bnum) then
          begin
            k := k + 1;
            if random(k) = 0 then
            begin
              Ax2 := ax1;
              Ay2 := ay1;
              select := True;
            end;
          end;
        end;
      end;
  for i1 := min(Ax2, Brole[bnum].X) to max(Ax2, Brole[bnum].X) do
  begin
    i2 := min(Ay2, Brole[bnum].Y) + random(abs(Ay2 - Brole[bnum].Y));
    BField[4, i1, i2] := 1 + random(4);
  end;
  BField[4, Ax2, Ay2] := 4;
  BField[2, Brole[bnum].X, Brole[bnum].Y] := -1;  //此处如果写成Bx, By在触发连击时可能会有问题
  BField[2, Ax2, Ay2] := bnum;
  Brole[bnum].X := Ax2;
  Brole[bnum].Y := Ay2;
  PlayMagicAmination(bnum, Rmagic[mnum].AmiNum);
  fillchar(BField[4, 0, 0], sizeof(BField[4]), 0);
  if select then
  begin
    BField[4, Ax, Ay] := 1;
    if Brole[aimbnum].Team <> Brole[bnum].Team then
    begin
      Rmagic[mnum].HurtType := 0;
      Rmagic[mnum].Attack[0] := 5 * step * level;
      Rmagic[mnum].Attack[1] := 10 * step * level;
      //PlaySoundA(Rmagic[mnum].SoundNum, 0);
      PlayActionAmination(bnum, Rmagic[mnum].MagicType); //动作效果
      CalHurtRole(bnum, mnum, level, 1); //计算被打到的人物
      PlayMagicAmination(bnum, Rmagic[mnum].AmiNum); //武功效果
      ShowHurtValue(Rmagic[mnum].HurtType); //显示数字
      Rmagic[mnum].HurtType := 2;
    end;
  end;
  Brole[bnum].Acted := 1;

end;

//21策马啸西风, 装备马匹者, 移动+4, 其余人+2

procedure TSpecialAbility.SA_21(bnum, mnum, level: integer);
var
  i, m: integer;
begin
  //如果是AI控制, 则在至少2人没有移动加成时使用
  if (Brole[bnum].Team <> 0) or (Brole[bnum].Auto <> 0) then
  begin
    m := 0;
    for i := 0 to BRoleAmount - 1 do
    begin
      if Brole[bnum].team = Brole[i].team then
        if (Brole[i].StateLevel[3] <= 0) then
          m := m + 1;
    end;
    if m = 0 then
      exit;
  end;
  ShowMagicName(mnum);
  for i := 0 to BRoleAmount - 1 do
  begin
    if (Brole[bnum].Team = Brole[i].Team) and (Brole[i].Dead = 0) then
    begin
      ModifyState(i, 3, 2, 3);
      if (Rrole[Brole[i].rnum].Equip[1] = 60) or (Rrole[Brole[i].rnum].Equip[1] = 61) then
      begin
        ModifyState(i, 3, 4, 3);
        Rrole[Brole[bnum].rnum].CurrentMP := Rrole[Brole[bnum].rnum].CurrentMP - Rmagic[mnum].NeedMP * (level - 1);
        if Rrole[Brole[bnum].rnum].CurrentMP < 0 then
          Rrole[Brole[bnum].rnum].CurrentMP := 0;
        if Rrole[Brole[bnum].rnum].CurrentMP > Rrole[Brole[bnum].rnum].MaxMP then
          Rrole[Brole[bnum].rnum].CurrentMP := Rrole[Brole[i].rnum].MaxHP;
      end;
      BField[4, Brole[i].X, Brole[i].Y] := 1 + random(6);
    end;
  end;
  CalMoveAbility;
  PlayMagicAmination(bnum, Rmagic[mnum].AmiNum, Rmagic[mnum].AddMP[0]);
  Brole[bnum].Acted := 1;
end;


//22侠之大者, 全体队友获得五种正面状态

procedure TSpecialAbility.SA_22(bnum, mnum, level: integer);
var
  i, j, sl: integer;
begin
  ShowMagicName(mnum);
  //FillChar(Bfield[4, 0, 0], 4096 * 2, 0);
  for i := 0 to BRoleAmount - 1 do
  begin
    if (Brole[i].Team = Brole[bnum].Team) and (Brole[i].Dead = 0) then
    begin
      for j := 0 to 4 do
      begin
        if Rmagic[mnum].AddMP[1 + j] >= 0 then
        begin
          sl := Rmagic[mnum].Attack[j * 2] + (Rmagic[mnum].Attack[j * 2 + 1] - Rmagic[mnum].Attack[j * 2]) *
            level div 10;
          Brole[i].StateLevel[Rmagic[mnum].AddMP[1 + j]] := sl;
          if Brole[i].StateRound[Rmagic[mnum].AddMP[1 + j]] < 3 then
            Brole[i].StateRound[Rmagic[mnum].AddMP[1 + j]] := 3;
        end;
      end;
      BField[4, Brole[i].X, Brole[i].Y] := 1 + random(6);
    end;
  end;
  PlayMagicAmination(bnum, Rmagic[mnum].AmiNum, Rmagic[mnum].AddMP[0]);
  Brole[bnum].Acted := 1;
end;


//23赏善, 将目标队友的正面状态分享给所有队员

procedure TSpecialAbility.SA_23(bnum, mnum, level: integer);
var
  i, j: integer;
  aimbrole: TBattleRole;
begin
  //如果是AI控制, 则在目标有正面状态时使用
  if (Brole[bnum].Team <> 0) or (Brole[bnum].Auto <> 0) then
  begin
    aimbrole := Brole[BField[2, Ax, Ay]];
    j := 0;
    for i := 0 to 20 do
      if aimbrole.StateLevel[i] > 0 then
        j := j + 1;
    if j = 0 then
      exit;
  end;
  ShowMagicName(mnum);
  if BField[2, Ax, Ay] >= 0 then
  begin
    aimbrole := Brole[BField[2, Ax, Ay]];
    if aimbrole.Team = Brole[bnum].Team then
    begin
      for i := 0 to BRoleAmount - 1 do
      begin
        if (Brole[i].Team = aimbrole.Team) and (Brole[i].rnum <> aimbrole.rnum) then
        begin
          for j := 0 to 20 do
          begin
            if aimbrole.StateLevel[j] > 0 then
            begin
              Brole[i].StateLevel[j] := aimbrole.StateLevel[j];
              Brole[i].StateRound[j] := 3;
            end;
          end;
          BField[4, Brole[i].X, Brole[i].Y] := 1;
        end;
      end;
      PlayMagicAmination(bnum, Rmagic[mnum].AmiNum, Rmagic[mnum].AddMP[0]);
    end;
  end;
  Brole[bnum].Acted := 1;
end;


//24罚恶, 将目标敌人的负面状态分享给所有敌人

procedure TSpecialAbility.SA_24(bnum, mnum, level: integer);
var
  i, j: integer;
  aimbrole: TBattleRole;
begin
  //如果是AI控制, 则在目标有负面状态时使用
  if (Brole[bnum].Team <> 0) or (Brole[bnum].Auto <> 0) then
  begin
    aimbrole := Brole[BField[2, Ax, Ay]];
    j := 0;
    for i := 0 to 6 do
      if aimbrole.StateLevel[i] < 0 then
        j := j + 1;
    if j = 0 then
      exit;
  end;
  ShowMagicName(mnum);
  if BField[2, Ax, Ay] >= 0 then
  begin
    aimbrole := Brole[BField[2, Ax, Ay]];
    if aimbrole.Team <> Brole[bnum].Team then
    begin
      for i := 0 to BRoleAmount - 1 do
      begin
        if (Brole[i].Team = aimbrole.Team) and (Brole[i].rnum <> aimbrole.rnum) then
        begin
          for j := 0 to 6 do
          begin
            if (j = 2) or (j = 4) then
              continue;
            if aimbrole.StateLevel[j] < 0 then
            begin
              Brole[i].StateLevel[j] := aimbrole.StateLevel[j];
              Brole[i].StateRound[j] := 3;
            end;
          end;
          BField[4, Brole[i].X, Brole[i].Y] := 1;
        end;
      end;
      PlayMagicAmination(bnum, Rmagic[mnum].AmiNum, Rmagic[mnum].AddMP[0]);
    end;
  end;
  Brole[bnum].Acted := 1;
end;

//25清心普善, 全体补内力

procedure TSpecialAbility.SA_25(bnum, mnum, level: integer);
var
  i, addmp, rnum, m: integer;
begin
  //如果是AI控制, 则在至少两名队友内力少于4/5才使用
  if (Brole[bnum].Team <> 0) or (Brole[bnum].Auto <> 0) then
  begin
    m := 0;
    for i := 0 to BRoleAmount - 1 do
    begin
      rnum := Brole[i].rnum;
      if Brole[bnum].team = Brole[i].team then
        if Rrole[rnum].CurrentMP < Rrole[rnum].MaxMP * 4 div 5 then
          m := m + 1;
    end;
    if m < 2 then
      exit;
  end;

  ShowMagicName(mnum);
  rnum := Brole[bnum].rnum;

  for i := 0 to BRoleAmount - 1 do
    if Brole[i].Dead = 0 then
    begin
      if (Brole[i].Team = Brole[bnum].team) and (Brole[i].StateLevel[18] = 0) and (i <> bnum) then
      begin
        addmp := Rrole[Brole[i].rnum].MAXMP * Rmagic[mnum].Attack[0] * level div 100;
        if Rrole[Brole[i].rnum].CurrentMP + addmp > Rrole[Brole[i].rnum].MAXMP then
          addmp := Rrole[Brole[i].rnum].MAXMP - Rrole[Brole[i].rnum].CurrentMP;
        Rrole[Brole[i].rnum].CurrentMP := Rrole[Brole[i].rnum].CurrentMP + addmp;
        BField[4, Brole[i].X, Brole[i].Y] := 1;
        Brole[i].ShowNumber := addmp;
      end;

      if Brole[i].StateLevel[18] > 0 then
      begin
        addmp := Rrole[Brole[i].rnum].MAXMP * Rmagic[mnum].Attack[0] * level div 50;
        if Rrole[Brole[i].rnum].CurrentMP + addmp > Rrole[Brole[i].rnum].MAXMP then
          addmp := Rrole[Brole[i].rnum].MAXMP - Rrole[Brole[i].rnum].CurrentMP;
        Rrole[Brole[i].rnum].CurrentMP := Rrole[Brole[i].rnum].CurrentMP + addmp;
        BField[4, Brole[i].X, Brole[i].Y] := 1;
        Brole[i].ShowNumber := addmp;
      end;
    end;

  PlayMagicAmination(bnum, Rmagic[mnum].AmiNum, Rmagic[mnum].AddMP[0]);
  ShowHurtValue(1, 0, '+%d');
  Brole[bnum].Acted := 1;
end;

//26先天一阳指, 直线攻击, 敌人减血, 并有一定概率定身, 我方加血

procedure TSpecialAbility.SA_26(bnum, mnum, level: integer);
var
  i, rand, rnum, hurt: integer;
begin
  ShowMagicName(mnum);
  instruct_67(Rmagic[mnum].SoundNum);
  PlayActionAmination(bnum, Rmagic[mnum].MagicType); //动作效果

  rnum := Brole[bnum].rnum;

  for i := 0 to BRoleAmount - 1 do
  begin
    if (BField[4, Brole[i].X, Brole[i].Y] <> 0) and (Brole[i].Dead = 0) and (bnum <> i) then
    begin
      Brole[i].ShowNumber := -1;
      //敌人伤害
      if Brole[i].Team <> Brole[bnum].Team then
      begin
        hurt := CalHurtValue(bnum, i, mnum, level, 1);
        Brole[i].ShowNumber := hurt;

        //受伤
        Rrole[Brole[i].rnum].CurrentHP := Rrole[Brole[i].rnum].CurrentHP - hurt;
        Rrole[Brole[i].rnum].Hurt := Rrole[Brole[i].rnum].Hurt + hurt * 100 div
          Rrole[Brole[i].rnum].MAXHP div LIFE_HURT;

        //定身
        rand := random(100);
        if rand < Rmagic[mnum].Attack[6] + (Rmagic[mnum].Attack[7] - Rmagic[mnum].Attack[6]) * level div 10 then
        begin
          Brole[i].StateLevel[26] := -1;
          Brole[i].StateRound[26] := 3;
          //ShowStringOnBrole('定身', bnum, 3);
        end;

        if Rrole[Brole[i].rnum].Hurt > 99 then
          Rrole[Brole[i].rnum].Hurt := 99;
        //出手一次, 获得1到10的经验值
        Brole[bnum].ExpGot := Brole[bnum].ExpGot + 1 + random(10);
        //if Rrole[Brole[i].rnum].CurrentHP <= 0 then Brole[bnum].ExpGot := Brole[bnum].ExpGot + hurt div 2;
        //把敌人打死获得30到50的经验值
        if Rrole[Brole[i].rnum].CurrentHP <= 0 then
        begin
          Rrole[Brole[i].rnum].CurrentHP := 0;
          Brole[bnum].ExpGot := Brole[bnum].ExpGot + 30 + random(20);
        end;
      end;

      //我方加血
      if Brole[i].Team = Brole[bnum].Team then
      begin
        hurt := Rmagic[mnum].Attack[4] + (Rmagic[mnum].Attack[5] - Rmagic[mnum].Attack[4]) * level div 10;
        Rrole[Brole[i].rnum].CurrentHP := Rrole[Brole[i].rnum].CurrentHP + Rrole[Brole[i].rnum].MaxHP * hurt div 100;
        if (Rrole[Brole[i].rnum].CurrentHP > Rrole[Brole[i].rnum].MaxHP) then
          Rrole[Brole[i].rnum].CurrentHP := Rrole[Brole[i].rnum].MaxHP;
        Brole[i].ShowNumber := Rrole[Brole[i].rnum].MaxHP * hurt div 100;
      end;
    end;
  end;
  PlayMagicAmination(bnum, Rmagic[mnum].AmiNum, Rmagic[mnum].AddMP[0]); //武功效果
  ShowHurtValue(5); //显示数字
  Brole[bnum].Acted := 1;
end;

//27韦编三绝, 控制目标敌人

procedure TSpecialAbility.SA_27(bnum, mnum, level: integer);
var
  i, Pctrl, Pm, aimBnum, enemyamount: integer;
begin
  ShowMagicName(mnum);
  Pctrl := random(100);
  Pm := Rmagic[mnum].Attack[0] + (Rmagic[mnum].Attack[1] - Rmagic[mnum].Attack[0]) * level div 10;

  enemyamount := 0;
  for i := 0 to BRoleAmount do
  begin
    if (Brole[i].Dead = 0) and (Brole[i].Team <> Brole[bnum].Team) then
      enemyamount := enemyamount + 1;
  end;
  if enemyamount = 1 then
    Pctrl := pm;

  //标记状态 -阵营编码-1
  if Pctrl < Pm then
  begin
    aimBnum := BField[2, Ax, Ay];
    if aimBnum >= 0 then
      if Brole[aimBnum].Team <> Brole[bnum].Team then
      begin
        Brole[aimBnum].StateLevel[27] := -Brole[bnum].Team - 1;
        Brole[aimBnum].StateRound[27] := 3;
        //Brole[aimBnum].Team := 1 - Brole[aimBnum].Team;
        BField[4, Ax, Ay] := 1;
      end
      else
      begin
        //可以解除我方混乱状态
        Brole[aimBnum].StateLevel[28] := 0;
        Brole[aimBnum].StateRound[28] := 0;
        BField[4, Ax, Ay] := 1;
      end;
  end;
  Brole[bnum].Acted := 1;
  PlayMagicAmination(bnum, Rmagic[mnum].AmiNum, Rmagic[mnum].AddMP[0]);
end;


//28断己相杀, 与目标敌人死磕, 直至一方死亡

procedure TSpecialAbility.SA_28(bnum, mnum, level: integer);
var
  i, Anum, rnumA, rnumB, hurt: integer;
  cmnum, cmlevel, cmatt, hmnumA, hmlevelA, hmattA, hmnumB, hmlevelB, hmattB: integer;
begin
  ShowMagicName(mnum);
  Anum := BField[2, Ax, Ay];
  if Anum >= 0 then
    if Brole[Anum].Team <> Brole[bnum].Team then
    begin
      hmattA := 0;
      hmnumA := 0;
      for i := 0 to 10 - 1 do
      begin
        cmnum := Rrole[Brole[Anum].rnum].magic[i];
        if cmnum <= 0 then
          break;
        if Rmagic[cmnum].HurtType = 2 then
          continue;
        cmlevel := Rrole[Brole[Anum].rnum].maglevel[i] div 100 + 1;
        cmatt := Rmagic[cmnum].Attack[0] + (Rmagic[cmnum].Attack[1] - Rmagic[cmnum].Attack[0]) * cmlevel div 10;
        if cmatt > hmattA then
        begin
          hmnumA := cmnum;
          hmlevelA := cmlevel;
          hmattA := cmatt;
        end;
      end;
      hmattB := 0;
      hmnumB := 0;
      for i := 0 to 10 - 1 do
      begin
        cmnum := Rrole[Brole[bnum].rnum].magic[i];
        if cmnum <= 0 then
          break;
        if Rmagic[cmnum].HurtType = 2 then
          continue;
        cmlevel := Rrole[Brole[bnum].rnum].maglevel[i] div 100 + 1;
        cmatt := Rmagic[cmnum].Attack[0] + (Rmagic[cmnum].Attack[1] - Rmagic[cmnum].Attack[0]) * cmlevel div 10;
        if cmatt > hmattB then
        begin
          hmnumB := cmnum;
          hmlevelB := cmlevel;
          hmattB := cmatt;
        end;
      end;

      rnumA := Brole[Anum].rnum;
      rnumB := Brole[Bnum].rnum;
      while True do
      begin
        ShowMagicName(hmnumB);
        instruct_67(Rmagic[hmnumB].SoundNum);
        PlayActionAmination(bnum, Rmagic[hmnumB].MagicType);
        hurt := CalHurtValue(bnum, Anum, hmnumB, hmlevelB, 1);
        BField[4, Brole[Anum].X, Brole[Anum].Y] := 1;
        Bx := Brole[Anum].X;
        By := Brole[Anum].Y;
        Ax := Brole[Bnum].X;
        Ay := Brole[Bnum].Y;
        PlayMagicAmination(bnum, Rmagic[hmnumB].AmiNum);
        Brole[Anum].ShowNumber := hurt;
        ShowHurtValue(Rmagic[hmnumB].HurtType);
        BField[4, Brole[Anum].X, Brole[Anum].Y] := 0;
        Brole[Anum].ShowNumber := 0;
        Rrole[rnumA].CurrentHP := Rrole[rnumA].CurrentHP - hurt;
        if Rrole[rnumA].CurrentHP <= 0 then
        begin
          Rrole[rnumA].CurrentHP := 0;
          break;
        end;

        ShowMagicName(hmnumA);
        instruct_67(Rmagic[hmnumA].SoundNum);
        PlayActionAmination(Anum, Rmagic[hmnumA].MagicType);
        hurt := CalHurtValue(Anum, Bnum, hmnumA, hmlevelA, 1);
        BField[4, Brole[Bnum].X, Brole[Bnum].Y] := 1;
        Bx := Brole[Bnum].X;
        By := Brole[Bnum].Y;
        Ax := Brole[Anum].X;
        Ay := Brole[Anum].Y;
        PlayMagicAmination(Anum, Rmagic[hmnumA].AmiNum);
        Brole[Bnum].ShowNumber := hurt;
        ShowHurtValue(Rmagic[hmnumA].HurtType);
        Brole[Bnum].ShowNumber := 0;
        BField[4, Brole[Bnum].X, Brole[Bnum].Y] := 0;
        Rrole[rnumB].CurrentHP := Rrole[rnumB].CurrentHP - hurt;
        if Rrole[rnumB].CurrentHP <= 0 then
        begin
          Rrole[rnumB].CurrentHP := 0;
          break;
        end;
      end;
      Rrole[rnumB].CurrentMP := Rrole[rnumB].CurrentMP - Rmagic[mnum].NeedMP * level;
      if Rrole[rnumB].CurrentMP < 0 then
        Rrole[rnumB].CurrentMP := 0;
      Rrole[rnumA].CurrentMP := Rrole[rnumA].CurrentMP - Rmagic[mnum].NeedMP * level;
      if Rrole[rnumA].CurrentMP < 0 then
        Rrole[rnumA].CurrentMP := 0;
      ClearDeadRolePic;
      Brole[Anum].Pic := 0;
      Brole[Bnum].Pic := 0;
    end;
  Brole[bnum].Acted := 1;
end;


//29七窍玲珑, 将目标队友的正面状态延长

procedure TSpecialAbility.SA_29(bnum, mnum, level: integer);
var
  i, j, ERound, aimbnum: integer;
begin
  //如果是AI控制, 则在目标有正面状态时使用
  if (Brole[bnum].Team <> 0) or (Brole[bnum].Auto <> 0) then
  begin
    aimbnum := BField[2, Ax, Ay];
    j := 0;
    for i := 0 to 20 do
      if Brole[aimbnum].StateLevel[i] > 0 then
        j := j + 1;
    if j = 0 then
      exit;
  end;
  ShowMagicName(mnum);
  for j := 0 to BRoleAmount - 1 do
  begin
    if (BField[4, Brole[j].X, Brole[j].Y] <> 0) and (Brole[j].Team = Brole[bnum].Team) then
    begin
      aimbnum := j;
      if Brole[aimbnum].Team = Brole[bnum].Team then
      begin
        ERound := Rmagic[mnum].Attack[0] + (Rmagic[mnum].Attack[1] - Rmagic[mnum].Attack[0]) * level div 10;
        for I := 0 to STATUS_AMOUNT - 3 do
        begin
          if Brole[aimbnum].StateLevel[i] > 0 then
            Brole[aimbnum].StateRound[i] := Brole[aimbnum].StateRound[i] + ERound;
        end;
      end;
    end;
  end;
  PlayMagicAmination(bnum, Rmagic[mnum].AmiNum, Rmagic[mnum].AddMP[0]);
  Brole[bnum].Acted := 1;
end;


//30特技排兵布阵, 改变目标队友的位置

procedure TSpecialAbility.SA_30(bnum, mnum, level: integer);
var
  i, x, y, aimbnum, k, i1, i2, k1: integer;
  r: boolean;
  aimbrole: TBattleRole;
begin
  //注意AI可能会乱用
  ShowMagicName(mnum);
  if BField[2, Ax, Ay] >= 0 then
  begin
    aimbnum := BField[2, Ax, Ay];
    BField[4, Ax, Ay] := 1;
    aimbrole := Brole[BField[2, Ax, Ay]];
    if aimbrole.Team = Brole[bnum].team then
    begin
      if (Brole[bnum].Auto = 0) and (Brole[bnum].Team = 0) then
      begin
        while BField[2, Ax, Ay] <> -1 do
          while not SelectRange(bnum, 0, Rmagic[mnum].MoveDistance[level - 1], 0) do ;
      end
      else
      begin
        k := 0;
        CalCanSelect(bnum, 1, Rmagic[mnum].MoveDistance[level - 1]);
        for i1 := 0 to 63 do
          for i2 := 0 to 63 do
          begin
            if (BField[2, i1, i2] = -1) and (BField[1, i1, i2] = 0) and (BField[3, i1, i2] = 0) then
            begin
              k1 := random(10000);
              if k1 > k then
              begin
                k := k1;
                Ax := i1;
                Ay := i2;
              end;
            end;
          end;
      end;
      BField[4, Ax, Ay] := 10;
      //ShowMagicName(mnum);
      instruct_67(Rmagic[mnum].SoundNum);
      PlayActionAmination(bnum, Rmagic[mnum].MagicType);
      PlayMagicAmination(bnum, Rmagic[mnum].AmiNum, Rmagic[mnum].AddMP[0]);
      BField[2, aimbrole.X, aimbrole.Y] := -1;
      Brole[aimbnum].X := Ax;
      Brole[aimbnum].Y := Ay;
      BField[2, Ax, Ay] := aimbnum;
    end;
  end;
  Brole[bnum].Acted := 1;
end;

//31森罗万象, 学会场上某队友的特技, 10级为从全部队友中选择
//在原版中运行时, 设定为

procedure TSpecialAbility.SA_31(bnum, mnum, level: integer);
var
  i, i1, amount, res, rnum, eachamount: integer;
  mnumarray: array of smallint;
  namemagic: WideString;
  menuString: array of WideString;
  ss: shortint;
  AI: boolean;
  forall: integer;
begin
  //level:=10;
  forall := GetItemAmount(COMPASS_ID);
  rnum := Brole[bnum].rnum;
  AI := (Brole[bnum].Auto <> 0) or (Brole[bnum].Team <> 0);
  if Rmagic[Rrole[rnum].Magic[0]].ScriptNum <> 31 then
  begin
    exit;
  end;
  ShowMagicName(mnum);
  //RecordFreshScreen;
  amount := 0;
  if (level < 10) or (MODVersion <> 13) then
  begin
    setlength(menuString, 260);
    setlength(mnumarray, 260);
    amount := 0;
    for i := 0 to BRoleAmount - 1 do
    begin
      if (((Brole[i].Team = Brole[bnum].Team) and (Brole[i].Dead = 0)) or (level = 10)) and (i <> bnum) then
      begin
        case MODVersion of
          13: eachamount := 1;
          else
            eachamount := 10
        end;
        for i1 := 0 to eachamount - 1 do
        begin
          if Rrole[Brole[i].rnum].magic[i1] > 0 then
          begin
            mnumarray[amount] := Rrole[Brole[i].rnum].magic[i1];
            namemagic := pWideChar(@Rrole[Brole[i].rnum].Name) + StringOfChar(' ', 10 -
              DrawLength(PChar(@Rrole[Brole[i].rnum].Name))) + pWideChar(
              @Rmagic[Rrole[Brole[i].rnum].magic[i1]].Name);
            //menustring[amount] := pwidechar(@namemagic);
            menuString[amount] := namemagic;
            ConsoleLog(menuString[amount]);
            amount := amount + 1;
          end;
        end;
      end;
    end;
  end
  else
  begin
    setlength(menuString, 100);
    setlength(mnumarray, 100);
    for i := 1 to 107 do
    begin
      ss := GetStarState(i);
      if (ss = 1) or (ss > 2) or (forall >= 2) then
      begin
        rnum := StarToRole(i);
        if Rrole[rnum].magic[0] > 0 then
        begin
          if Rmagic[Rrole[rnum].magic[0]].HurtType = 2 then
          begin
            mnumarray[amount] := Rrole[rnum].magic[0];
            namemagic := pWideChar(@Rrole[rnum].Name) + StringOfChar(' ', 10 -
              DrawLength(pWideChar(@Rrole[rnum].Name))) + pWideChar(@Rmagic[Rrole[rnum].magic[0]].Name);
            menuString[amount] := namemagic;
            ConsoleLog(menuString[amount]);
            amount := amount + 1;
          end;
        end;
      end;
    end;
  end;
  if amount > 0 then
  begin
    res := -1;
    if AI then
      res := random(amount)
    else
      while res < 0 do
      begin
        //LoadFreshScreen;
        res := CommonScrollMenu(CENTER_X - 60 - length(menuString[0]) * 5, 130, 105 +
          length(menuString[0]) * 10, amount - 1, 12, menuString);
      end;
  end;
  //FreeFreshScreen;
  Rrole[Brole[bnum].rnum].Magic[0] := mnumarray[res];
  PlayMagicAmination(bnum, Rmagic[mnumarray[res]].AmiNum, Rmagic[mnumarray[res]].AddMP[0]);
  if AI then
    ShowMagicName(Rrole[Brole[bnum].rnum].Magic[0]);
  Brole[bnum].Acted := 1;
end;

//32众生平等

procedure TSpecialAbility.SA_32(bnum, mnum, level: integer);
var
  i, minlife, rnum, life, sum: integer;
begin
  ShowMagicName(mnum);
  rnum := Brole[bnum].rnum;

  life := 0;
  sum := 0;
  {minlife := Rrole[Brole[bnum].rnum].CurrentHP;
  for i := 0 to BRoleAmount - 1 do
    if (Brole[i].dead = 0) and (Rrole[Brole[i].rnum].CurrentHP < minlife) then
      minlife := Rrole[Brole[i].rnum].CurrentHP;}

  for i := 0 to BRoleAmount - 1 do
    if (Brole[i].dead = 0) then
    begin
      life := life + Rrole[Brole[i].rnum].CurrentHP;
      sum := sum + 1;
    end;

  if sum <> 0 then
    life := life div sum
  else
    life := Rrole[Brole[bnum].rnum].CurrentHP;

  for i := 0 to BRoleAmount - 1 do
    if (Brole[i].dead = 0) then
    begin
      Rrole[Brole[i].rnum].CurrentHP := min(life, Rrole[Brole[i].rnum].MaxHP);
      //Brole[i].ShowNumber := minlife;
      BField[4, Brole[i].X, Brole[i].Y] := 1 + random(6);
    end;

  PlayMagicAmination(bnum, Rmagic[mnum].AmiNum, Rmagic[mnum].AddMP[0]);
  Brole[bnum].Acted := 1;
end;

//33不知所措, 交换两人mp

procedure TSpecialAbility.SA_33(bnum, mnum, level: integer);
var
  i, x, y, aimbnum1, aimbnum2, tempmp, rnum, k, k1: integer;
  r: boolean;
  str: WideString;
begin
  //AI会乱用
  ShowMagicName(mnum);
  rnum := Brole[bnum].rnum;
  if BField[2, Ax, Ay] >= 0 then
  begin
    aimbnum1 := BField[2, Ax, Ay];
    if (Brole[bnum].Auto = 0) and (Brole[bnum].Team = 0) then
    begin
      aimbnum2 := -1;
      while True do
      begin
        if not SelectRange(bnum, 0, Rmagic[mnum].MoveDistance[level - 1], 0) then
          break;
        aimbnum2 := BField[2, Ax, Ay];
        if aimbnum2 = aimbnum1 then
        begin
          str := '不可選同一人！';
          DrawTextWithRect(@str[1], CENTER_X - 70, CENTER_Y - 20, 145, ColColor(15), ColColor(17));
          WaitAnyKey;
        end;
        if (aimbnum2 >= 0) and (aimbnum2 <> aimbnum1) then
          break;
      end;
    end
    else
    begin
      k := 0;
      CalCanSelect(bnum, 1, Rmagic[mnum].MoveDistance[level - 1]);
      for i := 0 to BRoleAmount - 1 do
      begin
        if (Brole[i].Dead = 0) and (BField[3, Brole[i].x, Brole[i].y] >= 0) then
        begin
          //AI会随意选第二个人进行交换, 有失败可能
          k1 := random(10000);
          if (k1 > k) and (i <> aimbnum1) then
          begin
            k := k1;
            Ax := Brole[i].x;
            Ay := Brole[i].y;
          end;
        end;
      end;
    end;
    aimbnum2 := BField[2, Ax, Ay];
    instruct_67(Rmagic[mnum].SoundNum);
    PlayActionAmination(bnum, Rmagic[mnum].MagicType);
    if (aimbnum1 >= 0) and (aimbnum2 >= 0) and (aimbnum1 <> aimbnum2) then
    begin
      tempmp := Rrole[Brole[aimbnum1].rnum].CurrentMP;
      Rrole[Brole[aimbnum1].rnum].CurrentMP := Rrole[Brole[aimbnum2].rnum].CurrentMP;
      if Rrole[Brole[aimbnum1].rnum].CurrentMP > Rrole[Brole[aimbnum1].rnum].MaxMP then
        Rrole[Brole[aimbnum1].rnum].CurrentMP := Rrole[Brole[aimbnum1].rnum].MaxMP;
      Rrole[Brole[aimbnum2].rnum].CurrentMP := tempmp;
      if Rrole[Brole[aimbnum2].rnum].CurrentMP > Rrole[Brole[aimbnum2].rnum].MaxMP then
        Rrole[Brole[aimbnum2].rnum].CurrentMP := Rrole[Brole[aimbnum2].rnum].MaxMP;

      BField[4, Brole[aimbnum1].X, Brole[aimbnum1].Y] := 1;
      BField[4, Brole[aimbnum2].X, Brole[aimbnum2].Y] := 10;
    end;
  end;

  PlayMagicAmination(bnum, Rmagic[mnum].AmiNum, Rmagic[mnum].AddMP[0]);
  Brole[bnum].Acted := 1;
end;

//34颠三倒四, 交换两人hp

procedure TSpecialAbility.SA_34(bnum, mnum, level: integer);
var
  i, x, y, aimbnum1, aimbnum2, temphp, rnum, k, k1, i1, i2: integer;
  r: boolean;
  str: WideString;
begin
  //AI会乱用
  ShowMagicName(mnum);
  rnum := Brole[bnum].rnum;
  if BField[2, Ax, Ay] >= 0 then
  begin
    aimbnum1 := BField[2, Ax, Ay];
    if (Brole[bnum].Auto = 0) and (Brole[bnum].Team = 0) then
    begin
      aimbnum2 := -1;
      while True do
      begin
        if not SelectRange(bnum, 0, Rmagic[mnum].MoveDistance[level - 1], 0) then
          break;
        aimbnum2 := BField[2, Ax, Ay];
        if aimbnum2 = aimbnum1 then
        begin
          str := '不可選同一人！';
          DrawTextWithRect(@str[1], CENTER_X - 70, CENTER_Y - 20, 145, ColColor(15), ColColor(17));
          WaitAnyKey;
        end;
        if (aimbnum2 >= 0) and (aimbnum2 <> aimbnum1) then
          break;
      end;
    end
    else
    begin
      k := 0;
      CalCanSelect(bnum, 1, Rmagic[mnum].MoveDistance[level - 1]);
      for i := 0 to BRoleAmount - 1 do
      begin
        if (Brole[i].Dead = 0) and (BField[3, Brole[i].x, Brole[i].y] >= 0) then
        begin
          //AI会随意选第二个人进行交换, 有失败可能
          k1 := random(10000);
          if (k1 > k) and (i <> aimbnum1) then
          begin
            k := k1;
            Ax := Brole[i].x;
            Ay := Brole[i].y;
          end;
        end;
      end;
    end;
    aimbnum2 := BField[2, Ax, Ay];
    //ShowMagicName(mnum);
    instruct_67(Rmagic[mnum].SoundNum);
    PlayActionAmination(bnum, Rmagic[mnum].MagicType);

    if (aimbnum1 >= 0) and (aimbnum2 >= 0) and (aimbnum1 <> aimbnum2) then
    begin
      tempHp := Rrole[Brole[aimbnum1].rnum].CurrentHP;
      Rrole[Brole[aimbnum1].rnum].CurrentHP := Rrole[Brole[aimbnum2].rnum].CurrentHP;
      if Rrole[Brole[aimbnum1].rnum].CurrentHP > Rrole[Brole[aimbnum1].rnum].MaxHP then
        Rrole[Brole[aimbnum1].rnum].CurrentHP := Rrole[Brole[aimbnum1].rnum].MaxHP;
      Rrole[Brole[aimbnum2].rnum].CurrentHP := tempHp;
      if Rrole[Brole[aimbnum2].rnum].CurrentHP > Rrole[Brole[aimbnum2].rnum].MaxHP then
        Rrole[Brole[aimbnum2].rnum].CurrentMP := Rrole[Brole[aimbnum2].rnum].MaxHP;
    end;
    BField[4, Brole[aimbnum1].X, Brole[aimbnum1].Y] := 1;
    BField[4, Brole[aimbnum2].X, Brole[aimbnum2].Y] := 10;
  end;

  PlayMagicAmination(bnum, Rmagic[mnum].AmiNum, Rmagic[mnum].AddMP[0]);
  Brole[bnum].Acted := 1;
end;

//35特技, 破甲, 消除敌人正面状态, 变得容易受伤

procedure TSpecialAbility.SA_35(bnum, mnum, level: integer);
var
  i, aimbnum, rnum: integer;
begin
  ShowMagicName(mnum);
  if BField[2, Ax, Ay] >= 0 then
  begin
    aimbnum := BField[2, Ax, Ay];
    if Brole[aimbnum].Team <> Brole[bnum].Team then
    begin
      //ShowMagicName(mnum);
      instruct_67(Rmagic[mnum].SoundNum);
      PlayActionAmination(bnum, Rmagic[mnum].MagicType); //动作效果
      rnum := Brole[bnum].rnum;
      //仅针对前23个状态
      for i := 0 to 23 do
      begin
        if Brole[aimbnum].StateLevel[i] > 0 then
        begin
          Brole[aimbnum].StateLevel[i] := 0;
          Brole[aimbnum].StateRound[i] := 0;
        end;
      end;
      Brole[aimbnum].StateLevel[4] := -50;
      Brole[aimbnum].StateRound[4] := Brole[aimbnum].StateRound[4] + 3;
      PlayMagicAmination(bnum, Rmagic[mnum].AmiNum, Rmagic[mnum].AddMP[0]);
    end;
  end;
  Brole[bnum].Acted := 1;
end;

//36特技, 无坚不摧

procedure TSpecialAbility.SA_36(bnum, mnum, level: integer);
begin
  ShowMagicName(mnum);
  //无坚不摧, 武功威力为自身的攻击乘以等级
  Rmagic[mnum].HurtType := 0;
  Rmagic[mnum].Attack[0] := Rrole[Brole[bnum].rnum].Attack * level;
  Rmagic[mnum].Attack[1] := Rrole[Brole[bnum].rnum].Attack * level;
  if Rrole[Brole[bnum].rnum].Attack > 200 then
    needOffset := 1;
  PlaySoundA(Rmagic[mnum].SoundNum, 0);
  PlayActionAmination(bnum, Rmagic[mnum].MagicType); //动作效果
  CalHurtRole(bnum, mnum, level, 1); //计算被打到的人物
  PlayMagicAmination(bnum, Rmagic[mnum].AmiNum); //武功效果
  ShowHurtValue(Rmagic[mnum].HurtType); //显示数字
  Rmagic[mnum].HurtType := 2;
  Brole[bnum].Acted := 1;
end;

//37千娇百媚, 减少所有敌人轻功

procedure TSpecialAbility.SA_37(bnum, mnum, level: integer);
var
  i, rnum: integer;
begin
  ShowMagicName(mnum);
  rnum := Brole[bnum].rnum;
  for i := 0 to BRoleAmount - 1 do
  begin
    if Brole[i].Team <> Brole[bnum].team then
    begin
      if Brole[i].StateLevel[2] >= 0 then
      begin
        Brole[i].StateLevel[2] := Rmagic[mnum].Attack[0] + trunc(Rmagic[mnum].Attack[0] *
          (100 + (Rmagic[mnum].Attack[1] - Rmagic[mnum].Attack[0]) * level / 10) / 100);
        Brole[i].StateRound[2] := Rmagic[mnum].HurtMP[level];
      end
      else
      begin
        Brole[i].StateLevel[2] := Brole[i].StateLevel[2] - 1;
        Brole[i].StateRound[2] := Brole[i].StateRound[2] + 1;
      end;
      BField[4, Brole[i].x, Brole[i].Y] := 1;
    end;
  end;
  PlayMagicAmination(bnum, Rmagic[mnum].AmiNum, Rmagic[mnum].AddMP[0]);
  Brole[bnum].Acted := 1;
end;

//被动技能的名字, 触发时机, 几率, 动画均在r中

//0号被动技, 冷刃冰心
//20%几率发动定身2回合
procedure TSpecialAbility2.SA2_0(bnum, mnum, mnum2, level: integer);
var
  str: WideString;
  i, rnum, hurt: integer;
begin
  if (Rmagic[mnum].MagicType = 3) then
  begin
    ShowMagicName(mnum2);
    FillChar(BField[4, 0, 0], 4096 * 2, 0);
    for i := 0 to BRoleAmount - 1 do
    begin
      Brole[i].ShowNumber := -1;
      if (Brole[bnum].Team <> Brole[i].Team) and (Brole[i].Dead = 0) then
      begin
        BField[4, Brole[i].x, Brole[i].y] := 1 + random(6);
        rnum := Brole[i].rnum;
        hurt := 100 * level + Rrole[Brole[bnum].rnum].Level * 10 - Rrole[rnum].Defence;
        hurt := max(0, hurt);
        Rrole[rnum].CurrentHP := max(Rrole[rnum].CurrentHP - hurt, 0);
        Brole[i].ShowNumber := hurt;
        ModifyState(i, 26, -1, 3);
      end;
    end;
    //Rmagic[0].Attack[0] := 100 * level + Rrole[Brole[bnum].rnum].Level * 10;
    //Rmagic[0].Attack[1] := 200 * level + Rrole[Brole[bnum].rnum].Level * 20;
    PlayActionAmination(bnum, Rmagic[mnum].MagicType); //动作效果
    //CalHurtRole(bnum, 0, level, 1); //计算被打到的人物
    PlayMagicAmination(bnum, Rmagic[mnum2].AmiNum);
    ShowHurtValue(0); //显示数字
  end;
end;

//1断江斩
//20%几率攻击降低直线范围内敌人防御5回合
procedure TSpecialAbility2.SA2_1(bnum, mnum, mnum2, level: integer);
var
  str: WideString;
  i, rnum, hurt: integer;
begin
  if (Rmagic[mnum].MagicType = 3) then
  begin
    ShowMagicName(mnum2);
    Ax := Bx;
    Ay := By;
    case Brole[bnum].Face of
      0: Ax := Bx - 1;
      1: Ay := By + 1;
      2: Ay := By - 1;
      3: Ax := Bx + 1;
    end;
    SetAminationPosition(1, 32, 0);
    for i := 0 to BRoleAmount - 1 do
    begin
      Brole[i].ShowNumber := -1;
      if (Brole[bnum].Team <> Brole[i].Team) and (Brole[i].Dead = 0) and
        (BField[4, Brole[i].X, Brole[i].Y] > 0) then
      begin
        rnum := Brole[i].rnum;
        hurt := 100 * level + Rrole[Brole[bnum].rnum].Level * 10 - Rrole[rnum].Defence;
        hurt := max(0, hurt);
        Rrole[rnum].CurrentHP := max(Rrole[rnum].CurrentHP - hurt, 0);
        Brole[i].ShowNumber := hurt;
        ModifyState(i, 1, -50, 5);
      end;
    end;
    //Rmagic[0].Attack[0] := 100 * level + Rrole[Brole[bnum].rnum].Level * 10;
    //Rmagic[0].Attack[1] := 200 * level + Rrole[Brole[bnum].rnum].Level * 20;
    PlayActionAmination(bnum, Rmagic[mnum].MagicType); //动作效果
    //CalHurtRole(bnum, 0, level, 1); //计算被打到的人物
    PlayMagicAmination(bnum, Rmagic[mnum2].AmiNum);
    ShowHurtValue(0); //显示数字
  end;
end;

//2云龙九现
//30%几率被攻击敌军降低攻击五回合
procedure TSpecialAbility2.SA2_2(bnum, mnum, mnum2, level: integer);
var
  str: WideString;
  i, rnum, hurt: integer;
begin
  if (Rmagic[mnum].MagicType = 4) then
  begin
    ShowMagicName(mnum2);
    Ax := Bx;
    Ay := By;
    SetAminationPosition(3, 0, 4);
    for i := 0 to BRoleAmount - 1 do
    begin
      Brole[i].ShowNumber := -1;
      if (Brole[bnum].Team <> Brole[i].Team) and (Brole[i].Dead = 0) and
        (BField[4, Brole[i].X, Brole[i].Y] > 0) then
      begin
        rnum := Brole[i].rnum;
        hurt := 100 * level + Rrole[Brole[bnum].rnum].Level * 10 - Rrole[rnum].Defence;
        hurt := max(0, hurt);
        Rrole[rnum].CurrentHP := max(Rrole[rnum].CurrentHP - hurt, 0);
        Brole[i].ShowNumber := hurt;
        ModifyState(i, 0, -50, 5);
      end;
    end;
    //Rmagic[0].Attack[0] := 100 * level + Rrole[Brole[bnum].rnum].Level * 10;
    //Rmagic[0].Attack[1] := 200 * level + Rrole[Brole[bnum].rnum].Level * 20;
    PlayActionAmination(bnum, Rmagic[mnum].MagicType); //动作效果
    //CalHurtRole(bnum, 0, level, 1); //计算被打到的人物
    PlayMagicAmination(bnum, Rmagic[mnum2].AmiNum);
    ShowHurtValue(0); //显示数字
  end;
end;

//3破尽天下
//20%几率随机降低敌方兵器值-改为控制拳理等状态值
procedure TSpecialAbility2.SA2_3(bnum, mnum, mnum2, level: integer);
var
  str: WideString;
  i, rnum, hurt, j: integer;
begin
  if (mnum = 56) then
  begin
    ShowMagicName(mnum2);
    FillChar(BField[4, 0, 0], 4096 * 2, 0);
    for i := 0 to BRoleAmount - 1 do
    begin
      Brole[i].ShowNumber := -1;
      if (Brole[bnum].Team <> Brole[i].Team) and (Brole[i].Dead = 0) then
      begin
        BField[4, Brole[i].x, Brole[i].y] := 1 + random(6);
        rnum := Brole[i].rnum;
        hurt := 200 + random(Rrole[Brole[bnum].rnum].Level) * 5;
        Rrole[rnum].CurrentHP := max(Rrole[rnum].CurrentHP - hurt, 0);
        Brole[i].ShowNumber := hurt;
        for j := 29 to 33 do
        begin
          if Brole[i].StateLevel[j] > 0 then
          begin
            Brole[i].StateLevel[j] := 0;
            Brole[i].StateRound[j] := 0;
          end
          else
          if random(100) < 50 then
            Brole[i].StateLevel[j] := min(-99, Brole[i].StateLevel[j] - 15);
          Brole[i].StateRound[j] := Brole[i].StateRound[j] - 3;
        end;
        {if random(100) < 50 then Rrole[rnum].Fist := max(Rrole[rnum].Fist * 85 div 100, 10);
        if random(100) < 50 then Rrole[rnum].Sword := max(Rrole[rnum].Sword * 85 div 100, 10);
        if random(100) < 50 then Rrole[rnum].Knife := max(Rrole[rnum].Knife * 85 div 100, 10);
        if random(100) < 50 then Rrole[rnum].Unusual := max(Rrole[rnum].Unusual * 85 div 100, 10);
        if random(100) < 50 then Rrole[rnum].HidWeapon := max(Rrole[rnum].HidWeapon * 85 div 100, 10);}
      end;
    end;
    PlayActionAmination(bnum, Rmagic[mnum].MagicType); //动作效果
    //CalHurtRole(bnum, mnum, level, 1); //计算被打到的人物
    PlayMagicAmination(bnum, Rmagic[mnum2].AmiNum);
    ShowHurtValue(0); //显示数字
  end;
end;

//4有余不尽
//30%几率再使用一次降龙掌, 此次所耗内力减半, 同时恢复30%内力。
procedure TSpecialAbility2.SA2_4(bnum, mnum, mnum2, level: integer);
var
  str: WideString;
  i, rnum, hurt: integer;
begin
  if (mnum = 24) then
  begin
    ShowMagicName(mnum2);
    rnum := Brole[bnum].rnum;
    Rrole[rnum].CurrentMP := Rrole[rnum].CurrentMP + Rmagic[mnum].NeedMP * level div 2;
    Rrole[rnum].CurrentMP := min(Rrole[rnum].CurrentMP + Rrole[rnum].MaxMP * 30 div 100, Rrole[rnum].MaxMP);
    move(BField[4, 0, 0], BField[5, 0, 0], 4096 * 2);
    FillChar(BField[4, 0, 0], 4096 * 2, 0);
    BField[4, Brole[bnum].X, Brole[bnum].Y] := 1;
    PlayMagicAmination(bnum, Rmagic[mnum2].AmiNum);
    move(BField[5, 0, 0], BField[4, 0, 0], 4096 * 2);
    AttackAction(bnum, mnum, level);
  end;
end;

//5重剑无锋
//20%几率再使用一次玄铁剑法, 对敌人造成减攻减防减移动力
procedure TSpecialAbility2.SA2_5(bnum, mnum, mnum2, level: integer);
var
  str: WideString;
  i, rnum, hurt: integer;
begin
  if (mnum = 49) then
  begin
    ShowMagicName(mnum2);
    for i := 0 to BRoleAmount - 1 do
    begin
      if (Brole[bnum].Team <> Brole[i].Team) and (BField[4, Brole[i].X, Brole[i].Y] > 0) then
      begin
        {Brole[i].StateLevel[0] := -50;
        Brole[i].StateRound[0] := random(5);
        Brole[i].StateLevel[1] := -50;
        Brole[i].StateRound[1] := random(5);
        Brole[i].StateLevel[3] := -1;
        Brole[i].StateRound[3] := random(5);}
        ModifyState(i, 0, -50, random(5));
        ModifyState(i, 1, -50, random(5));
        ModifyState(i, 3, -1, random(5));
      end;
    end;
    move(BField[4, 0, 0], BField[5, 0, 0], 4096 * 2);
    FillChar(BField[4, 0, 0], 4096 * 2, 0);
    BField[4, Brole[bnum].X, Brole[bnum].Y] := 1;
    PlayMagicAmination(bnum, Rmagic[mnum2].AmiNum);
    move(BField[5, 0, 0], BField[4, 0, 0], 4096 * 2);
    AttackAction(bnum, mnum, level);
  end;
end;

//6意假情真
//40%几率攻击无视防御
procedure TSpecialAbility2.SA2_6(bnum, mnum, mnum2, level: integer);
var
  str: WideString;
  i, rnum, hurt: integer;
begin
  if (mnum = 47) then
  begin
    ShowMagicName(mnum2);
    move(BField[4, 0, 0], BField[5, 0, 0], 4096 * 2);
    FillChar(BField[4, 0, 0], 4096 * 2, 0);
    BField[4, Brole[bnum].X, Brole[bnum].Y] := 1;
    PlayMagicAmination(bnum, Rmagic[mnum2].AmiNum);
    move(BField[5, 0, 0], BField[4, 0, 0], 4096 * 2);
    for i := 0 to BRoleAmount - 1 do
    begin
      if (Brole[bnum].Team <> Brole[i].Team) and (BField[4, Brole[i].X, Brole[i].Y] > 0) then
      begin
        //设定目标减防御120%一回合
        Brole[i].StateLevel[1] := Brole[i].StateLevel[1] - 120;
        Brole[i].StateRound[1] := Brole[i].StateRound[1] + 1;
      end;
    end;
    AttackAction(bnum, mnum, level);
    for i := 0 to BRoleAmount - 1 do
    begin
      if (Brole[bnum].Team <> Brole[i].Team) and (BField[4, Brole[i].X, Brole[i].Y] > 0) then
      begin
        Brole[i].StateLevel[1] := Brole[i].StateLevel[1] + 120;
        Brole[i].StateRound[1] := Brole[i].StateRound[1] - 1;
      end;
    end;
  end;
end;

//7无影神拳
//30%几率攻击敌方全部
procedure TSpecialAbility2.SA2_7(bnum, mnum, mnum2, level: integer);
var
  str: WideString;
  i, rnum, hurt: integer;
begin
  if (mnum = 254) then
  begin
    ShowMagicName(mnum2);
    FillChar(BField[4, 0, 0], 4096 * 2, 0);
    for i := 0 to BRoleAmount - 1 do
    begin
      Brole[i].ShowNumber := -1;
      if (Brole[bnum].Team <> Brole[i].Team) and (Brole[i].Dead = 0) then
      begin
        BField[4, Brole[i].x, Brole[i].y] := 1 + random(6);
        rnum := Brole[i].rnum;
        hurt := random(100) + random(Rrole[Brole[bnum].rnum].CurrentHP);
        Rrole[rnum].CurrentHP := max(Rrole[rnum].CurrentHP - hurt, 0);
        Brole[i].ShowNumber := hurt;
      end;
    end;
    //Rrole[Brole[bnum].rnum].CurrentHP := min(Rrole[Brole[bnum].rnum].CurrentHP + );
    PlayActionAmination(bnum, Rmagic[mnum].MagicType); //动作效果
    PlayMagicAmination(bnum, Rmagic[mnum2].AmiNum);
    ShowHurtValue(Rmagic[mnum].HurtType); //显示数字
  end;
end;

//8一空到底
//40%几率发动互拼内力
procedure TSpecialAbility2.SA2_8(bnum, mnum, mnum2, level: integer);
var
  str: WideString;
  i, bnum2, rnum, rnum2, hurt, hurtMP: integer;
begin
  if (mnum = 332) then
  begin
    ShowMagicName(mnum2);
    bnum2 := BField[2, Ax, Ay];
    if (bnum2 >= 0) then
      if Brole[bnum].Team <> Brole[bnum2].Team then
      begin
        rnum := Brole[bnum].rnum;
        rnum2 := Brole[bnum2].rnum;
        hurt := Rrole[rnum].CurrentMP - Rrole[rnum2].CurrentMP;
        hurtMP := min(Rrole[rnum].CurrentMP, Rrole[rnum2].CurrentMP);
        Rrole[rnum].CurrentMP := Rrole[rnum].CurrentMP - hurtMP;
        Rrole[rnum2].CurrentMP := Rrole[rnum2].CurrentMP - hurtMP;
        if hurt >= 0 then
        begin
          Rrole[rnum2].CurrentHP := max(Rrole[rnum2].CurrentHP - hurt, 0);
          Brole[bnum].ShowNumber := 0;
          Brole[bnum2].ShowNumber := hurt;
        end
        else
        begin
          Rrole[rnum].CurrentHP := max(Rrole[rnum].CurrentHP - hurt, 0);
          Brole[bnum].ShowNumber := hurt;
          Brole[bnum2].ShowNumber := 0;
        end;
        BField[4, Brole[bnum].X, Brole[bnum].Y] := 1 + random(6);
        PlayActionAmination(bnum, Rmagic[mnum].MagicType); //动作效果
        PlayMagicAmination(bnum, Rmagic[mnum2].AmiNum);
        ShowHurtValue(Rmagic[mnum].HurtType); //显示数字
      end;
  end;
end;

//9分心二用天罗地网
//20%几率减少敌军10%生命, 30%几率陷入混乱状态
procedure TSpecialAbility2.SA2_9(bnum, mnum, mnum2, level: integer);
var
  str: WideString;
  i, rnum, hurt: integer;
begin
  if (mnum = 164) and (Rrole[Brole[bnum].rnum].Equip[0] = 31) then
  begin
    ShowMagicName(mnum2);
    Ax := Bx;
    Ay := By;
    SetAminationPosition(3, 0, 4);
    for i := 0 to BRoleAmount - 1 do
    begin
      Brole[i].ShowNumber := -1;
      if (Brole[bnum].Team <> Brole[i].Team) and (BField[4, Brole[i].X, Brole[i].Y] > 0) then
      begin
        rnum := Brole[i].rnum;
        hurt := Rrole[rnum].CurrentHP div 10;
        Rrole[rnum].CurrentHP := max(Rrole[rnum].CurrentHP - hurt, 0);
        Brole[i].ShowNumber := hurt;
        if (random(100) < 30) then
          ModifyState(i, 28, -1, 3);
      end;
    end;
    PlayActionAmination(bnum, Rmagic[mnum].MagicType); //动作效果
    PlayMagicAmination(bnum, Rmagic[mnum2].AmiNum);
    ShowHurtValue(Rmagic[mnum].HurtType); //显示数字
  end;
end;

//10火焰刀
procedure TSpecialAbility2.SA2_10(bnum, mnum, mnum2, level: integer);
var
  str: WideString;
  i, rnum, hurt: integer;
begin
  rnum := Brole[bnum].rnum;
  if (mnum = 87) and (HaveMagic(rnum, 299, 0)) then
  begin
    ShowMagicName(mnum2);
    Ax := Bx;
    Ay := By;
    SetAminationPosition(3, 0, 4);
    for i := 0 to BRoleAmount - 1 do
    begin
      Brole[i].ShowNumber := -1;
      if (Brole[bnum].Team <> Brole[i].Team) and (Brole[i].Dead = 0) and
        (BField[4, Brole[i].X, Brole[i].Y] > 0) then
      begin
        rnum := Brole[i].rnum;
        hurt := 100 * level + Rrole[Brole[bnum].rnum].Level * 10 - Rrole[rnum].Defence;
        hurt := max(0, hurt);
        Rrole[rnum].CurrentHP := max(Rrole[rnum].CurrentHP - hurt, 0);
        Brole[i].ShowNumber := hurt;
        Rrole[rnum].Poison := 100;
      end;
    end;
    PlayActionAmination(bnum, Rmagic[mnum].MagicType); //动作效果
    PlayMagicAmination(bnum, Rmagic[mnum2].AmiNum);
    ShowHurtValue(0); //显示数字
  end;
end;

//陆家刀法
procedure TSpecialAbility2.SA2_11(bnum, mnum, mnum2, level: integer);
var
  str: WideString;
  i, rnum, hurt: integer;
begin
  if (Rmagic[mnum].MagicType = 3) then
  begin
    ShowMagicName(mnum2);
    Ax := Bx;
    Ay := By;
    SetAminationPosition(3, 0, 6);
    for i := 0 to BRoleAmount - 1 do
    begin
      Brole[i].ShowNumber := -1;
      if (Brole[bnum].Team <> Brole[i].Team) and (Brole[i].Dead = 0) and
        (Bfield[4, Brole[i].X, Brole[i].Y] > 0) then
      begin
        rnum := Brole[i].rnum;
        hurt := 600;
        hurt := max(0, hurt);
        Rrole[rnum].CurrentHP := max(Rrole[rnum].CurrentHP - hurt, 0);
        Brole[i].ShowNumber := hurt;
      end;
    end;
    PlayActionAmination(bnum, Rmagic[mnum].MagicType); //动作效果
    PlayMagicAmination(bnum, Rmagic[mnum2].AmiNum);
    ShowHurtValue(0); //显示数字
  end;
end;

//100瑜伽密乘
//15%几率攻防增加三回合, 拳系特效触发概率提升
procedure TSpecialAbility2.SA2_100(bnum, mnum, mnum2, level: integer);
var
  str: WideString;
  i, rnum, hurt: integer;
begin
  rnum := Brole[bnum].rnum;
  if HaveMagic(rnum, 301, 0) then
  begin
    ShowMagicName(mnum2);
    //move(Bfield[4, 0, 0], Bfield[5, 0, 0], 4096 * 2);
    FillChar(BField[4, 0, 0], 4096 * 2, 0);
    BField[4, Brole[bnum].X, Brole[bnum].Y] := 1;
    PlayMagicAmination(bnum, Rmagic[mnum2].AmiNum);
    {Brole[bnum].StateLevel[0] := 50;
    Brole[bnum].StateRound[0] := 3;
    Brole[bnum].StateLevel[1] := 50;
    Brole[bnum].StateRound[1] := 3;}
    ModifyState(bnum, 0, 50, 3);
    ModifyState(bnum, 1, 50, 3);
    if random(100) < 50 then
      ModifyState(bnum, 29, 30, 3);
    if random(100) < 50 then
      ModifyState(bnum, 30, 30, 3);
    if random(100) < 50 then
      ModifyState(bnum, 31, 30, 3);
    if random(100) < 50 then
      ModifyState(bnum, 32, 30, 3);
    if random(100) < 50 then
      ModifyState(bnum, 33, 30, 3);
  end;
end;

//101九阳归一
//15%几率立刻恢复体力20点, 乾坤大挪移反伤效果提升20%
procedure TSpecialAbility2.SA2_101(bnum, mnum, mnum2, level: integer);
var
  str: WideString;
  i, rnum, hurt: integer;
begin
  rnum := Brole[bnum].rnum;
  //if (random(100) < 15) then
  if HaveMagic(rnum, 128, 0) and (not HaveMagic(rnum, 127, 0)) and (not HaveMagic(rnum, 129, 0)) and
    (Rrole[rnum].CurrentMP >= 9000) then
  begin
    ShowMagicName(mnum2);
    //move(Bfield[4, 0, 0], Bfield[5, 0, 0], 4096 * 2);
    FillChar(BField[4, 0, 0], 4096 * 2, 0);
    BField[4, Brole[bnum].X, Brole[bnum].Y] := 1;
    PlayMagicAmination(bnum, Rmagic[mnum2].AmiNum);
    Rrole[rnum].PhyPower := min(MAX_PHYSICAL_POWER, Rrole[rnum].PhyPower + 20);
    Brole[bnum].StateLevel[14] := Brole[i].StateLevel[14] + 50;
  end;
end;

end.
