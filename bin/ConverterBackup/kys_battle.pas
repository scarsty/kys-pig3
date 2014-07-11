unit kys_battle;

interface

uses
  Windows,
  SysUtils,
  StrUtils,
  SDL_TTF,
  //SDL_mixer,
  SDL_image,
  SDL,
  Math,
  kys_main, Dialogs;

//战斗
//从游戏文件的命名来看, 应是'war'这个词的缩写,
//但实际上战斗的规模很小, 使用'battle'显然更合适
function Battle(battlenum, getexp: integer): boolean;
function InitialBField: boolean;
function SelectTeamMembers: integer;
procedure ShowMultiMenu(max, menu, status: integer; menustring: array of WideString);
procedure BattleMainControl;
procedure CalMoveAbility;
procedure ReArrangeBRole;
function BattleStatus: integer;
function BattleMenu(bnum: integer): integer;
procedure ShowBMenu(MenuStatus, menu, max: integer);
procedure DrawProgress;
procedure MoveRole(bnum: integer);
procedure MoveAmination(bnum: integer);

function Selectshowstatus(bnum: integer): boolean;
function SelectAim(bnum, step: integer): boolean;
function SelectRange(bnum, AttAreaType, step, range: integer): boolean;
function SelectDirector(bnum, AttAreaType, step, range: integer): boolean;
function SelectCross(bnum, AttAreaType, step, range: integer): boolean;
function SelectFar(bnum, mnum, level: integer): boolean;

procedure SeekPath(x, y, step: integer);
procedure SeekPath2(x, y, step, myteam, mode: integer);
procedure CalCanSelect(bnum, mode, step: integer);
procedure Attack(bnum: integer);
procedure AttackAction(bnum, mnum, level: integer);
procedure ShowMagicName(mnum: integer);
function SelectMagic(rnum: integer): integer;
procedure ShowMagicMenu(menustatus, menu, max: integer);
procedure SetAminationPosition(mode, step, range: integer); overload;
procedure SetAminationPosition(Bx, By, Ax, Ay, mode, step, range: integer; play: integer = 0); overload;
procedure PlayMagicAmination(bnum, enum: integer);
procedure CalHurtRole(bnum, mnum, level: integer; mode: integer = 0);
function CalHurtValue(bnum1, bnum2, mnum, level: integer; mode: integer = 0): integer;
function CalHurtValue2(bnum1, bnum2, mnum, level: integer; mode: integer = 0): integer;
procedure ShowHurtValue(mode: integer; team: integer = 0);
procedure ShowStringOnBrole(str: WideString; bnum, mode: integer);
procedure CalPoiHurtLife;
procedure ClearDeadRolePic;
procedure ShowSimpleStatus(rnum, x, y: integer);
procedure Wait(bnum: integer);
procedure RestoreRoleStatus;
procedure AddExp;
procedure CheckLevelUp;
procedure LevelUp(bnum: integer);
procedure CheckBook;
function CalRNum(team: integer): integer;
procedure BattleMenuItem(bnum: integer);
procedure UsePoision(bnum: integer);
procedure PlayActionAmination(bnum, mode: integer);
procedure Medcine(bnum: integer);
procedure MedPoision(bnum: integer);
procedure UseHiddenWeapen(bnum, inum: integer);
procedure Rest(bnum: integer);

procedure AutoBattle(bnum: integer);
procedure AutoUseItem(bnum, list: integer);

procedure AutoBattle2(bnum: integer);
procedure trymoveattack(var Mx1, My1, Ax1, Ay1, tempmaxhurt: integer; bnum, mnum, level: integer);
procedure calline(var Mx1, My1, Ax1, Ay1, tempmaxhurt: integer; curX, curY, bnum, mnum, level: integer);
procedure calarea(var Mx1, My1, Ax1, Ay1, tempmaxhurt: integer; curX, curY, bnum, mnum, level: integer);
procedure calpoint(var Mx1, My1, Ax1, Ay1, tempmaxhurt: integer; curX, curY, bnum, mnum, level: integer);
procedure calcross(var Mx1, My1, Ax1, Ay1, tempmaxhurt: integer; curX, curY, bnum, mnum, level: integer);
procedure caldirdiamond(var Mx1, My1, Ax1, Ay1, tempmaxhurt: integer; curX, curY, bnum, mnum, level: integer);
procedure caldirangle(var Mx1, My1, Ax1, Ay1, tempmaxhurt: integer; curX, curY, bnum, mnum, level: integer);
procedure calfar(var Mx1, My1, Ax1, Ay1, tempmaxhurt: integer; curX, curY, bnum, mnum, level: integer);
procedure nearestmove(var Mx1, My1: integer; bnum: integer);
procedure farthestmove(var Mx1, My1: integer; bnum: integer);
procedure trymovecure(var Mx1, My1, Ax1, Ay1: integer; bnum: integer);
procedure cureaction(bnum: integer);
procedure RoundOver;
procedure ShowModeMenu(menu: integer);
function SelectAutoMode: integer;
procedure ShowTeamModeMenu(menu: integer);
function TeamModeMenu: boolean;
procedure Auto(bnum: integer);
procedure SetEnemyAttribute;
function IFinbattle(num: integer): integer;
procedure PutStone(bnum, mnum, level: integer);
procedure gangbeat(bnum, mnum, level: integer);
procedure duckweed(bnum, mnum, level: integer);
procedure GodBless(bnum, mnum, level: integer);
procedure GhostChange(bnum, mnum, level: integer);
procedure LongWalk(bnum, mnum, level: integer);
procedure slashhorse(bnum, mnum, level: integer);
procedure HeroicSpirit(bnum, mnum, level: integer);
procedure Rewardgoodness(bnum, mnum, level: integer);
procedure PunishEvil(bnum, mnum, level: integer);
procedure ControlEnemy(bnum, mnum, level: integer);
procedure PKuntildie(bnum, mnum, level: integer);
procedure ExtendRound(bnum, mnum, level: integer);
procedure tactics(bnum, mnum, level: integer);
procedure xiantianyiyang(bnum, mnum, level: integer);
procedure xixing(bnum, mnum, level: integer);
procedure senluo(bnum, mnum, level: integer);
procedure ambush(bnum, mnum, level, Si: integer);
procedure AllEqual(bnum, mnum, level: integer);
procedure charming(bnum, mnum, level: integer);
procedure ClearHeart(bnum, mnum, level: integer);
procedure swapmp(bnum, mnum, level: integer);
procedure swapHp(bnum, mnum, level: integer);
procedure givemelife(bnum, mnum, level, Si: integer);
procedure IncreaceMP(bnum, mnum, level: integer);
procedure steal(bnum, mnum, level: integer);
procedure LionRoar(bnum, mnum, level: integer);
procedure cureall(bnum, mnum, level: integer);
procedure TransferMP(bnum, mnum, level: integer);
procedure pojia(bnum, mnum, level: integer);
procedure alladdPhy(bnum, mnum, level: integer);
procedure PoisonAll(bnum, mnum, level: integer);
procedure MedPoisonAll(bnum, mnum, level: integer);
procedure IncreaceHP(bnum, mnum, level: integer);


implementation

uses kys_script, kys_event, kys_engine;

//Battle.
//战斗, 返回值为是否胜利

function Battle(battlenum, getexp: integer): boolean;
var
  i, j, k, SelectTeamList, x, y: integer;
begin

  Bstatus := 0;
  CurrentBattle := battlenum;
  if InitialBField then
  begin
    //如果未发现自动战斗设定, 则选择人物
    SelectTeamList := SelectTeamMembers;
    for i := 0 to length(warsta.mate) - 1 do
    begin
      y := warsta.mate_x[i];
      x := warsta.mate_y[i];
      if SelectTeamList and (1 shl i) > 0 then
      begin
        Brole[BRoleAmount].rnum := TeamList[i];
        Brole[BRoleAmount].Team := 0;
        Brole[BRoleAmount].Y := y;
        Brole[BRoleAmount].X := x;
        Brole[BRoleAmount].Face := 2;
        Brole[BRoleAmount].Dead := 0;
        Brole[BRoleAmount].Step := 0;
        Brole[BRoleAmount].Acted := 0;
        Brole[BRoleAmount].ExpGot := 0;
        Brole[BRoleAmount].Auto := 0;
        BRoleAmount := BRoleAmount + 1;
      end;
    end;
    for i := 0 to length(warsta.mate) - 1 do
    begin
      y := warsta.mate_x[i] + 1;
      x := warsta.mate_y[i];
      if (warsta.mate[i] > 0) and (instruct_16(warsta.mate[i], 1, 0) = 0) then
      begin
        Brole[BRoleAmount].rnum := warsta.mate[i];
        Brole[BRoleAmount].Team := 0;
        Brole[BRoleAmount].Y := y;
        Brole[BRoleAmount].X := x;
        Brole[BRoleAmount].Face := 2;
        Brole[BRoleAmount].Dead := 0;
        Brole[BRoleAmount].Step := 0;
        Brole[BRoleAmount].Acted := 0;
        Brole[BRoleAmount].ExpGot := 0;
        Brole[BRoleAmount].Auto := 0;
        BRoleAmount := BRoleAmount + 1;
      end;
    end;
  end;
  //设定敌方角色的状态，珍珑之战除外
  if Currentbattle <> 178 then
    SetEnemyAttribute;

  if (Currentbattle = 159) or (Currentbattle = 292) then
  begin
    rrole[243].CurrentHP := 999;
    rrole[243].CurrentMP := 10;
    rrole[243].Movestep := 0;
    rrole[244].CurrentHP := 999;
    rrole[244].CurrentMP := 10;
    rrole[244].Movestep := 0;
  end;


  Setlength(AutoMode, BRoleAmount);
  for i := 0 to BRoleAmount - 1 do
  begin
    if Brole[i].Team = 0 then
      AutoMode[i] := 0
    else
      AutoMode[i] := -1;
    //战场状态和情侣加成清空
    for j := 0 to MAX_LOVER_STATE - 1 do
      brole[i].loverlevel[j] := 0;
    for k := 0 to STATUS_AMOUNT - 1 do
      brole[i].statelevel[k] := 0;

  end;
  turnblack;
  Where := 2;
  initialwholeBfield; //初始化场景
  stopMP3;
  playmp3(warsta.battlemusic, -1);
  blackscreen := 0;

  if SEMIREAL = 1 then
  begin
    setlength(BHead, BRoleAmount);
    for i := 0 to broleamount - 1 do
    begin
      BHead[i] := SDL_CreateRGBSurface(screen.flags, 56, 71, 32, 0, 0, 0, 0);
      SDL_FillRect(BHead[i], nil, 1);
      SDL_SetColorKey(BHead[i], SDL_SRCCOLORKEY, 1);
      DrawHeadPic(Rrole[Brole[i].rnum].HeadNum, 0, 0, BHead[i]);
      BRole[i].BHead := i;
    end;
  end;

  BattleMainControl;

  RestoreRoleStatus;

  //if (bstatus = 1) or ((bstatus = 2) and (getexp <> 0)) then
  if bstatus = 1 then
  begin
    AddExp;
    CheckLevelUp;
    CheckBook;
  end;

  SDL_UpdateRect2(screen, 0, 0, screen.w, screen.h);

  if SEMIREAL = 1 then
  begin
    for i := 0 to broleamount - 1 do
    begin
      SDL_FreeSurface(BHead[i]);
    end;
    setlength(BHead, 0);
  end;

  if Rscence[CurScence].EntranceMusic >= 0 then
  begin
    stopmp3;
    playmp3(Rscence[CurScence].EntranceMusic, -1);
  end;

  Where := 1;
  if bstatus = 1 then
    Result := True
  else
    Result := False;
  blackscreen := 10;
  SDL_EnableKeyRepeat(30, 35);
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
  sta, grp, idx, offset, i, i1, i2, x, y, fieldnum: integer;
begin
  i := sizeof(warsta);
  sta := fileopen('resource\war.sta', fmopenread);
  offset := currentbattle * i;
  fileseek(sta, offset, 0);
  fileread(sta, warsta, i);
  fileclose(sta);
  fieldnum := warsta.battlemap;
  if fieldnum = 0 then
    offset := 0
  else
  begin
    idx := fileopen('resource\warfld.idx', fmopenread);
    fileseek(idx, (fieldnum - 1) * 4, 0);
    fileread(idx, offset, 4);
    fileclose(idx);
  end;
  grp := fileopen('resource\warfld.grp', fmopenread);
  fileseek(grp, offset, 0);
  fileread(grp, Bfield[0, 0, 0], 2 * 64 * 64 * 2);
  fileclose(grp);
  for i1 := 0 to 63 do
    for i2 := 0 to 63 do
      Bfield[2, i1, i2] := -1;
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
  for i := 0 to length(warsta.mate) - 1 do
  begin
    y := warsta.mate_x[i];
    x := warsta.mate_y[i];
    if warsta.automate[i] >= 0 then
    begin
      Brole[BRoleAmount].rnum := warsta.automate[i];
      Brole[BRoleAmount].Team := 0;
      Brole[BRoleAmount].Y := y;
      Brole[BRoleAmount].X := x;
      Brole[BRoleAmount].Face := 2;
      Brole[BRoleAmount].Dead := 0;
      Brole[BRoleAmount].Step := 0;
      Brole[BRoleAmount].Acted := 0;
      Brole[BRoleAmount].ExpGot := 0;
      Brole[BRoleAmount].Auto := 0;
      BRoleAmount := BRoleAmount + 1;
    end;
  end;
  //如没有自动参战人物, 返回假, 激活选择人物
  if BRoleAmount > 0 then
    Result := False;
  for i := 0 to length(warsta.enemy) - 1 do
  begin
    y := warsta.enemy_x[i];
    x := warsta.enemy_y[i];
    if warsta.enemy[i] >= 0 then
    begin
      Brole[BRoleAmount].rnum := warsta.enemy[i];
      Brole[BRoleAmount].Team := 1;
      Brole[BRoleAmount].Y := y;
      Brole[BRoleAmount].X := x;
      Brole[BRoleAmount].Face := 1;
      Brole[BRoleAmount].Dead := 0;
      Brole[BRoleAmount].Step := 0;
      Brole[BRoleAmount].Acted := 0;
      Brole[BRoleAmount].ExpGot := 0;
      Brole[BRoleAmount].Auto := 0;
      BRoleAmount := BRoleAmount + 1;
    end;
  end;

end;


//选择人物, 返回值为整型, 按bit表示人物是否参战

function SelectTeamMembers: integer;
var
  i, menu, max, menup: integer;
  menustring: array[0..8] of WideString;
begin
  Result := 0;
  max := 1;
  menu := 0;
  //setlength(menustring, 7);
  for i := 0 to 5 do
  begin
    if Teamlist[i] >= 0 then
    begin
      menustring[i + 1] := Big5toUnicode(@RRole[Teamlist[i]].Name);
      max := max + 1;
    end;
  end;
  menustring[0] := ('    全員參戰');
  menustring[max] := ('    開始戰鬥');
  ShowMultiMenu(max, 0, 0, menustring);
  sdl_enablekeyrepeat(50, 30);
  while (SDL_WaitEvent(@event) >= 0) do
  begin
    CheckBasicEvent;
    case event.type_ of
      SDL_KEYUP:
      begin
        if ((event.key.keysym.sym = sdlk_return) or (event.key.keysym.sym = sdlk_space)) and (menu <> max) then
        begin
          //选中人物则反转对应bit
          if menu > 0 then
            Result := Result xor (1 shl (menu - 1))
          else
          if Result < round(power(2, (max - 1)) - 1) then
            Result := round(power(2, (max - 1)) - 1)
          else
            Result := 0;
          ShowMultiMenu(max, menu, Result, menustring);
        end;
        if ((event.key.keysym.sym = sdlk_return) or (event.key.keysym.sym = sdlk_space)) and (menu = max) then
        begin
          if Result <> 0 then
            break;
        end;
        if (event.key.keysym.sym = sdlk_up) then
        begin
          menu := menu - 1;
          if menu < 0 then
            menu := max;
          ShowMultiMenu(max, menu, Result, menustring);
        end;
        if (event.key.keysym.sym = sdlk_down) then
        begin
          menu := menu + 1;
          if menu > max then
            menu := 0;
          ShowMultiMenu(max, menu, Result, menustring);
        end;
      end;
      SDL_MOUSEBUTTONUP:
      begin
        if (event.button.button = sdl_button_left) and (menu <> max) then
        begin
          if menu > 0 then
            Result := Result xor (1 shl (menu - 1))
          else
          if Result < round(power(2, (max - 1)) - 1) then
            Result := round(power(2, (max - 1)) - 1)
          else
            Result := 0;
          ShowMultiMenu(max, menu, Result, menustring);
        end;
        if (event.button.button = sdl_button_left) and (menu = max) then
        begin
          if Result <> 0 then
            break;
        end;
      end;
      SDL_MOUSEMOTION:
      begin
        if (round(event.button.x / (RealScreen.w / screen.w)) >= CENTER_X - 75) and
          (round(event.button.x / (RealScreen.w / screen.w)) < CENTER_X + 75) and
          (round(event.button.y / (RealScreen.h / screen.h)) >= 150) and
          (round(event.button.y / (RealScreen.h / screen.h)) < max * 22 + 178) then
        begin
          menup := menu;
          menu := (round(event.button.y / (RealScreen.h / screen.h)) - 152) div 22;
          if menup <> menu then
            ShowMultiMenu(max, menu, Result, menustring);
        end;
      end;
    end;
  end;

end;

//显示选择参战人物选单

procedure ShowMultiMenu(max, menu, status: integer; menustring: array of WideString);
var
  i, x, y: integer;
  str, str1, str2: WideString;
begin
  x := CENTER_X - 105;
  y := 150;
  //{$IFDEF DARWIN}
  RegionRect.x := x + 30;
  RegionRect.y := y;
  RegionRect.w := 151;
  RegionRect.h := max * 22 + 29;
  //{$ENDIF}
  redraw;
  //{$IFDEF DARWIN}
  RegionRect.w := 0;
  RegionRect.h := 0;
  //{$ENDIF}
  str := (' 選擇參與戰鬥之人物');
  str1 := (' 參戰');
  //Drawtextwithrect(@str[1],x + 5, y-35, 200 , colcolor($23), colcolor($21));
  DrawRectangle(x + 30, y, 150, max * 22 + 28, 0, colcolor(255), 30);
  for i := 0 to max do
    if i = menu then
    begin
      drawshadowtext(@menustring[i][1], x + 13, y + 3 + 22 * i, colcolor($66), colcolor($64));
      if ((status and (1 shl (i - 1))) > 0) and (i > 0) and (i < max) then
        drawshadowtext(@str1[1], x + 113, y + 3 + 22 * i, colcolor($66), colcolor($64));
    end
    else
    begin
      drawshadowtext(@menustring[i][1], x + 13, y + 3 + 22 * i, colcolor($7), colcolor($5));
      if ((status and (1 shl (i - 1))) > 0) and (i > 0) and (i < max) then
        drawshadowtext(@str1[1], x + 113, y + 3 + 22 * i, colcolor($23), colcolor($21));
    end;
  SDL_UpdateRect2(screen, x + 30, y, 151, max * 22 + 28 + 1);
end;


//设定敌方角色的状态

procedure SetEnemyAttribute;
var
  i, enum: integer;
begin
  for i := 0 to 19 do
  begin
    enum := warsta.enemy[i];
    if enum <> -1 then
    begin
      //SetAttribute(enum, 71, rrole[enum].Repute , rrole[enum].RoundLeave , warsta.exp div 100);
      if enum > 331 then
        SetAttribute(enum, 73, rrole[enum].Repute, rrole[enum].RoundLeave, 60)
      else
        SetAttribute(enum, 1, rrole[enum].Repute, rrole[enum].RoundLeave, 60);
    end;
  end;
end;

//战斗主控制

procedure BattleMainControl;
var
  i, j, neinum, neilevel, bnum, pnum, act: integer;
  k, m, n, si, t, x1, y1, curepoi: integer;
  tempBrole: TBattleRole;
  delaytime: integer;
begin

  delaytime := 10; //毫秒

  Bx := Brole[0].X;
  By := Brole[0].Y;

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
      redraw;
      NewTalk(loverlist[k, 1], loverlist[k, 4], -2, 0, 0, 28515, 0);
      Bx := Brole[m].X;
      By := Brole[m].Y;
      redraw;
      NewTalk(loverlist[k, 0], loverlist[k, 4] + 1, -2, 0, 0, 28515, 0);
      Brole[m].loverlevel[loverlist[k, 2]] := loverlist[k, 3];
      //替代受伤
      if loverlist[k, 2] = 6 then
        for i := 0 to broleamount - 1 do
          if loverlist[k, 3] = brole[i].rnum then
          begin
            Brole[m].loverlevel[loverlist[k, 2]] := i;
            break;
          end;
    end;
  end;

  if SEMIREAL = 1 then
  begin
    for i := 0 to BroleAmount - 1 do
    begin
      Brole[i].RealProgress := random(7000);
    end;
  end;
  //redraw;
  //战斗未分出胜负则继续
  while BStatus = 0 do
  begin
    CalMoveAbility; //计算移动能力

    if SEMIREAL = 0 then
      ReArrangeBRole; //排列角色顺序

    ClearDeadRolePic; //清除阵亡角色

    //是否已行动, 显示数字清空
    for i := 0 to broleamount - 1 do
    begin
      if (SEMIREAL = 0) or (Brole[i].Acted = 1) then
      begin
        //for t := 0 to broleamount do Brole[t].ShowNumber := -1;
        //7号状态，战神，随机获得一种正面状态
        if Brole[i].StateLevel[7] > 0 then
        begin
          si := random(21);
          //0攻击,1防御,2轻功,4伤害,14乾坤,15灵精,11毒箭,
          if (si = 0) or (si = 1) or (si = 2) or (si = 4) or (si = 11) or (si = 14) or (si = 15) then
          begin
            Brole[i].StateLevel[si] := Brole[i].Statelevel[7];
            Brole[i].StateRound[si] := 3;
          end
          //7战神
          else if si = 7 then
            Brole[i].StateRound[7] := Brole[i].StateRound[7] + 1
          //5回血,6回内,20回体
          else if (si = 5) or (si = 6) or (si = 20) then
          begin
            Brole[i].StateLevel[si] := Brole[i].Statelevel[7] div 2;
            Brole[i].StateRound[si] := 3;
          end
          else
            //,3移动,16奇门,17博采,18聆音,19青翼,8风雷,9孤注,10倾国,12剑芒,13连击
          begin
            Brole[i].StateLevel[si] := 1;
            Brole[i].StateRound[si] := 3;
          end;
        end;

        //24号状态，悲歌，随机获得一种奖励（0攻、1防、3移、4加血1000、5加内1000、2加体50）
        if Brole[i].StateLevel[24] > 0 then
        begin
          si := random(6);
          //0攻击,1防御
          if (si = 0) or (si = 1) then
          begin
            if brole[i].StateLevel[si] <= 0 then
            begin
              Brole[i].StateLevel[si] := 20;
              Brole[i].StateRound[si] := 1;
            end
            else
              Brole[i].StateRound[si] := Brole[i].StateRound[si] + 1;
          end
          else if si = 3 then
          begin //3移动
            if brole[i].StateLevel[si] <= 0 then
            begin
              Brole[i].StateLevel[si] := 3;
              Brole[i].StateRound[si] := 1;
            end
            else
              Brole[i].StateRound[si] := Brole[i].StateRound[si] + 1;
          end
          else if si = 2 then
          begin //2加体50
            rrole[brole[i].rnum].PhyPower := rrole[brole[i].rnum].PhyPower + 50;
            if rrole[brole[i].rnum].PhyPower > MAX_PHYSICAL_POWER then
              rrole[brole[i].rnum].PhyPower := MAX_PHYSICAL_POWER;
          end
          else if si = 4 then
          begin //4加血1000
            rrole[brole[i].rnum].CurrentHP := rrole[brole[i].rnum].CurrentHP + 1000;
            if rrole[brole[i].rnum].CurrentHP > rrole[brole[i].rnum].MaxHP then
              rrole[brole[i].rnum].CurrentHP := rrole[brole[i].rnum].MaxHP;
          end
          else if si = 5 then
          begin //5加内1000
            rrole[brole[i].rnum].CurrentMP := rrole[brole[i].rnum].CurrentMP + 1000;
            if rrole[brole[i].rnum].CurrentMP > rrole[brole[i].rnum].MaxMP then
              rrole[brole[i].rnum].CurrentMP := rrole[brole[i].rnum].MaxMP;
          end;
        end;
      end;
      Brole[i].Acted := 0;
      Brole[i].ShowNumber := 0;
    end;

    if SEMIREAL = 1 then
    begin
      redraw;
      act := 0;
      while SDL_PollEvent(@event) >= 0 do
      begin
        for i := 0 to broleamount - 1 do
        begin
          Brole[i].RealProgress := Brole[i].RealProgress + Brole[i].RealSpeed + 10;
          if Brole[i].RealProgress >= 10000 then
          begin
            Brole[i].RealProgress := Brole[i].RealProgress - 10000;
            act := 1;
            break;
          end;
        end;
        if act = 1 then
          break;
        redraw;
        SDL_UpdateRect2(screen, 0, 0, screen.w, screen.h);
        sdl_delay(delaytime);

        CheckBasicEvent;

      end;
    end;

    if SEMIREAL = 0 then
      i := 0;

    while (i < broleamount) and (Bstatus = 0) do
    begin
      //当前人物位置作为屏幕中心
      Bx := Brole[i].X;
      By := Brole[i].Y;
      //showstringonbrole(' 123456677变态啦', i, 6);
      redraw;
      while (SDL_PollEvent(@event) >= 0) do
      begin
        CheckBasicEvent;

        if (event.key.keysym.sym = sdlk_Escape) or (event.button.button = sdl_button_right) then
        begin
          brole[i].Auto := 0;
          //AutoMode[i]:=-1;
          event.button.button := 0;
          event.key.keysym.sym := 0;
        end;
        break;
      end;
      //战场序号保存至变量28005
      x50[28005] := i;

      //26号状态，定身，直接略过
      if Brole[i].StateLevel[26] <> 0 then
        Brole[i].Acted := 1
      else
      //为我方且未阵亡, 非自动战斗, 则显示选单
      if (Brole[i].Dead = 0) then
      begin
        if (Brole[i].Team = 0) and (Brole[i].Auto = 0) then
        begin
          if Brole[i].Acted = 0 then
            tempBrole := Brole[i]; //记录一个临时人物信息，用于恢复位置
          case BattleMenu(i) of
            0: MoveRole(i);
            1: Attack(i);
            2: UsePoision(i);
            3: MedPoision(i);
            4: Medcine(i);
            5: BattleMenuItem(i);
            6: Wait(i);
            7: Selectshowstatus(i);
            8: Rest(i);
            9: Auto(i);
            -1:
            begin
              Bfield[2, tempBrole.X, tempBrole.Y] := i;
              Bfield[2, Brole[i].X, Brole[i].Y] := -1;
              Brole[i] := tempBrole;
            end;
          end;
        end
        else
        begin
          AutoBattle2(i);
          Brole[i].Acted := 1;
        end;
      end
      else
        Brole[i].Acted := 1;

      ClearDeadRolePic;
      redraw;
      Bstatus := BattleStatus;

      if (Brole[i].Acted = 1) then
      begin
        //内功恢复生命内力体力
        if Brole[i].Dead = 0 then
          for j := 0 to 3 do
          begin
            neinum := Rrole[Brole[i].rnum].neigong[j];
            if neinum <= 0 then
              break;
            neilevel := Rrole[Brole[i].rnum].NGLevel[j] div 100 + 1;
            if Rmagic[neinum].AttDistance[0] > 0 then
            begin
              Rrole[Brole[i].rnum].CurrentMP :=
                Rrole[Brole[i].rnum].CurrentMP + Rrole[Brole[i].rnum].MaxMP *
                (Rmagic[neinum].AttDistance[0] + (Rmagic[neinum].AttDistance[1] - Rmagic[neinum].AttDistance[0]) *
                neilevel div 10) div 100;
              showstringonbrole(big5tounicode(@rmagic[neinum].Name) + '·回内', i, 3);
            end;
            if Rrole[Brole[i].rnum].CurrentMP > Rrole[Brole[i].rnum].MaxMP then
              Rrole[Brole[i].rnum].CurrentMP := Rrole[Brole[i].rnum].MaxMP;
            if Rmagic[neinum].AttDistance[2] > 0 then
            begin
              Rrole[Brole[i].rnum].CurrentHP :=
                Rrole[Brole[i].rnum].CurrentHP + Rrole[Brole[i].rnum].MaxHP *
                (Rmagic[neinum].AttDistance[2] + (Rmagic[neinum].AttDistance[3] - Rmagic[neinum].AttDistance[2]) *
                neilevel div 10) div 100;
              showstringonbrole(big5tounicode(@rmagic[neinum].Name) + '·回血', i, 3);
            end;
            if Rrole[Brole[i].rnum].CurrentHP > Rrole[Brole[i].rnum].MaxHP then
              Rrole[Brole[i].rnum].CurrentHP := Rrole[Brole[i].rnum].MaxHP;
            if Rmagic[neinum].AddMP[4] > 0 then
            begin
              Rrole[Brole[i].rnum].PhyPower := Rrole[Brole[i].rnum].PhyPower + Rmagic[neinum].AddMP[4];
              showstringonbrole(big5tounicode(@rmagic[neinum].Name) + '·回体', i, 3);
            end;
            if Rrole[Brole[i].rnum].PhyPower > MAX_PHYSICAL_POWER then
              Rrole[Brole[i].rnum].PhyPower := MAX_PHYSICAL_POWER;

            if Rmagic[neinum].addmp[1] > 0 then
            begin
              //星宿毒功，周围5*5格人中毒
              for x1 := -2 to 2 do
                for y1 := -2 to 2 do
                begin
                  if (brole[i].X + x1 < 0) or (brole[i].X + x1 > 63) or (brole[i].Y + y1 < 0) or
                    (brole[i].Y + y1 > 63) then
                    continue;
                  if Bfield[2, brole[i].X + x1, brole[i].Y + y1] > 0 then
                  begin
                    bnum := Bfield[2, brole[i].X + x1, brole[i].Y + y1];
                    if brole[bnum].Team <> brole[i].Team then
                    begin
                      pnum := Rmagic[neinum].addmp[0] + (Rmagic[neinum].addmp[1] -
                        Rmagic[neinum].addmp[0]) * neilevel div 10;
                      if pnum > Rrole[brole[bnum].rnum].DefPoi then
                      begin
                        Rrole[brole[bnum].rnum].Poision := Rrole[brole[bnum].rnum].Poision + pnum;
                        showstringonbrole(big5tounicode(@rmagic[neinum].Name) + '·群毒', i, 2);
                        //if Rrole[brole[bnum].rnum].Poision>100 then Rrole[brole[bnum].rnum].Poision:=100;
                      end;
                    end;
                  end;
                end;
            end;

            //化毒，将中毒转化为内力
            if Rmagic[neinum].AttDistance[5] > 0 then
            begin
              curepoi := Rmagic[neinum].AttDistance[5] * neilevel;
              if curepoi > rrole[brole[i].rnum].Poision then
                curepoi := rrole[brole[i].rnum].Poision;
              if curepoi > 0 then
                showstringonbrole(big5tounicode(@rmagic[neinum].Name) + '·化毒', i, 4);
              rrole[brole[i].rnum].Poision := rrole[brole[i].rnum].Poision - curepoi;
              rrole[brole[i].rnum].CurrentMP := rrole[brole[i].rnum].CurrentMP + curepoi * neilevel;
              if rrole[brole[i].rnum].CurrentMP > rrole[brole[i].rnum].MaxMP then
                rrole[brole[i].rnum].CurrentMP := rrole[brole[i].rnum].MaxMP;
            end;

            //葵花宝典，每回合随机获得加轻、加移、闪避状态
            if Rmagic[neinum].AddMP[2] = 1 then
            begin
              if random(100) > 50 then
              begin
                brole[i].StateLevel[2] := 50;
                brole[i].StateRound[2] := 3;
                showstringonbrole(big5tounicode(@rmagic[neinum].Name) + '·身轻', i, 3);
              end;
              if random(100) > 50 then
              begin
                brole[i].StateLevel[3] := 5;
                brole[i].StateRound[3] := 3;
                showstringonbrole(big5tounicode(@rmagic[neinum].Name) + '·速行', i, 3);
              end;
              if random(100) > 50 then
              begin
                brole[i].StateLevel[16] := 50;
                brole[i].StateRound[16] := 3;
                showstringonbrole(big5tounicode(@rmagic[neinum].Name) + '·闪避', i, 3);
              end;
            end;

            //九阴真经，每回合随机获得加攻、加防状态，减受伤
            if Rmagic[neinum].AddMP[2] = 2 then
            begin
              if random(100) > 50 then
              begin
                brole[i].StateLevel[0] := 10 * neilevel;
                brole[i].StateRound[0] := 3;
                showstringonbrole(big5tounicode(@rmagic[neinum].Name) + '·威力', i, 3);
              end;
              if random(100) > 50 then
              begin
                brole[i].StateLevel[1] := 10 * neilevel;
                brole[i].StateRound[1] := 3;
                showstringonbrole(big5tounicode(@rmagic[neinum].Name) + '·刚体', i, 3);
              end;
              rrole[brole[i].rnum].Hurt := rrole[brole[i].rnum].Hurt - 10 * neilevel;
              if rrole[brole[i].rnum].Hurt < 0 then
                rrole[brole[i].rnum].Hurt := 0;
            end;

            //北冥真气，周围5*5格人减内，自己回内
            if Rmagic[neinum].addmp[2] = 3 then
            begin
              for x1 := -2 to 2 do
                for y1 := -2 to 2 do
                begin
                  if (brole[i].X + x1 < 0) or (brole[i].X + x1 > 63) or (brole[i].Y + y1 < 0) or
                    (brole[i].Y + y1 > 63) then
                    continue;
                  if Bfield[2, brole[i].X + x1, brole[i].Y + y1] > 0 then
                  begin
                    bnum := Bfield[2, brole[i].X + x1, brole[i].Y + y1];
                    if brole[bnum].Team <> brole[i].Team then
                    begin
                      pnum := 50 * neilevel;
                      if pnum > Rrole[brole[bnum].rnum].CurrentMP then
                        pnum := Rrole[brole[bnum].rnum].CurrentMP;
                      Rrole[brole[bnum].rnum].CurrentMP := Rrole[brole[bnum].rnum].CurrentMP - pnum;
                      rrole[brole[i].rnum].currentMP := rrole[brole[i].rnum].currentMP + pnum;
                      if rrole[brole[i].rnum].currentMP > rrole[brole[i].rnum].maxMP then
                        rrole[brole[i].rnum].currentMP := rrole[brole[i].rnum].maxMP;
                      showstringonbrole(big5tounicode(@rmagic[neinum].Name) + '·纳气', i, 1);
                    end;
                  end;
                end;
            end;

          end;
        i := i + 1;
        if SEMIREAL = 1 then
          break;
      end;
    end;
    CalPoiHurtLife; //计算中毒损血
    x50[28101] := broleamount;
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
    for i := 0 to BRoleAmount do
    begin
      if (Brole[i].rnum = num) and (Brole[i].Team = 0) then
      begin
        r := i;
      end;
    end;

  Result := r;
end;

//按轻功重排人物(未考虑装备)
//2号状态，轻功有加成

procedure ReArrangeBRole;
var
  i, i1, i2, x, t: integer;
  temp: TBattleRole;
begin
  for i1 := 0 to BRoleAmount - 2 do
    for i2 := i1 + 1 to BRoleAmount - 1 do
    begin
      if Rrole[Brole[i1].rnum].Speed * (100 + brole[i1].StateLevel[2] + Brole[i1].loverlevel[9]) div
        100 < Rrole[Brole[i2].rnum].Speed * (100 + brole[i2].StateLevel[2] + Brole[i2].loverlevel[9]) div 100 then
      begin
        temp := Brole[i1];
        Brole[i1] := Brole[i2];
        Brole[i2] := temp;
        t := AutoMode[i1];
        AutoMode[i1] := AutoMode[i2];
        AutoMode[i2] := t;
      end;
    end;

  for i1 := 0 to 63 do
    for i2 := 0 to 63 do
      Bfield[2, i1, i2] := -1;

  for i := 0 to BRoleAmount - 1 do
  begin
    if Brole[i].Dead = 0 then
      Bfield[2, Brole[i].X, Brole[i].Y] := i
    else
      Bfield[2, Brole[i].X, Brole[i].Y] := -1;
  end;

end;

//计算可移动步数(考虑装备)

procedure CalMoveAbility;
var
  i, rnum, addspeed, step: integer;
begin
  for i := 0 to broleamount - 1 do
  begin
    rnum := Brole[i].rnum;
    step := rrole[rnum].Movestep;
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

    Brole[i].Step := step div 10;
    if Brole[i].Step > 15 then
      Brole[i].Step := 15;
    //情侣和状态增加移动能力
    Brole[i].Step := Brole[i].Step + Brole[i].statelevel[3] + Brole[i].loverlevel[2] +
      ritem[rrole[rnum].Equip[1]].AddMove + ritem[rrole[rnum].Equip[0]].AddMove;
    if SEMIREAL = 1 then
    begin
      Brole[i].RealSpeed := trunc((Rrole[rnum].Speed) + 175) - Rrole[rnum].Hurt div
        10 - Rrole[rnum].Poision div 30;
      Brole[i].RealSpeed := Brole[i].RealSpeed div 3;
      //if Brole[i].RealSpeed > 200 then
      //Brole[i].RealSpeed := 200 + (Brole[i].RealSpeed - 200) div 3;
      if Brole[i].Step > 7 then
        Brole[i].Step := 7;
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
  for i := 0 to broleamount - 1 do
  begin
    if (Brole[i].Team = 0) and (Brole[i].Dead = 0) then
      sum0 := sum0 + 1;
    if (Brole[i].Team = 1) and (Brole[i].Dead = 0) then
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
  i, p, menustatus, menu, max, rnum, menup: integer;
  realmenu: array[0..9] of integer;
begin
  menustatus := $3E0;
  max := 4;
  //for i:=0 to 9 do
  rnum := brole[bnum].rnum;
  //移动是否可用
  if (brole[bnum].Step > 0) {and (brole[bnum].acted = 0)} then
  begin
    menustatus := menustatus or 1;
    max := max + 1;
  end;
  SDL_EnableKeyRepeat(20, 100);
  //can not attack when phisical<10
  //攻击是否可用
  if (rrole[rnum].PhyPower >= 10) and (rrole[rnum].Poision < 100) then
  begin
    p := 0;
    for i := 0 to 9 do
    begin
      if rrole[rnum].Magic[i] > 0 then
      begin
        if (Rmagic[rrole[rnum].Magic[i]].Data[8] <= 0) or
          ((Rmagic[rrole[rnum].Magic[i]].Data[8] > 0) and (Rmagic[rrole[rnum].Magic[i]].Data[9] <=
          GetItemAmount(Rmagic[rrole[rnum].Magic[i]].Data[8]))) and
          (Rmagic[rrole[rnum].Magic[i]].NeedMP <= rrole[rnum].CurrentMP) then
        begin
          p := 1;
          break;
        end;
      end;
    end;
    if p > 0 then
    begin
      menustatus := menustatus or 2;
      max := max + 1;
    end;
  end;
  //用毒是否可用
  if (Rrole[rnum].UsePoi > 0) and (rrole[rnum].PhyPower >= 30) then
  begin
    menustatus := menustatus or 4;
    max := max + 1;
  end;
  //解毒是否可用
  if (Rrole[rnum].MedPoi > 0) and (rrole[rnum].PhyPower >= 50) then
  begin
    menustatus := menustatus or 8;
    max := max + 1;
  end;
  //医疗是否可用
  if (Rrole[rnum].Medcine > 0) and (rrole[rnum].PhyPower >= 50) then
  begin
    menustatus := menustatus or 16;
    max := max + 1;
  end;
  //等待是否可用
  if SEMIREAL = 1 then
  begin
    menustatus := menustatus - 64;
    max := max - 1;
  end;

  ReDraw;
  ShowSimpleStatus(brole[bnum].rnum, 350, 50);
  SDL_UpdateRect2(screen, 0, 0, screen.w, screen.h);
  menu := 0;
  showbmenu(menustatus, menu, max);
  //SDL_UpdateRect2(screen,0,0,screen.w,screen.h);
  while (SDL_WaitEvent(@event) >= 0) do
  begin
    CheckBasicEvent;
    case event.type_ of
      SDL_KEYDOWN:
      begin
        if (event.key.keysym.sym = sdlk_up) then
        begin
          menu := menu - 1;
          if menu < 0 then
            menu := max;
          showbmenu(menustatus, menu, max);
        end;
        if (event.key.keysym.sym = sdlk_down) then
        begin
          menu := menu + 1;
          if menu > max then
            menu := 0;
          showbmenu(menustatus, menu, max);
        end;
        event.key.keysym.sym := 0;
      end;
      SDL_KEYUP:
      begin
        if (event.key.keysym.sym = sdlk_return) or (event.key.keysym.sym = sdlk_space) then
        begin
          break;
        end;
        if (event.key.keysym.sym = sdlk_escape) then
        begin
          menu := -1;
          break;
        end;
      end;
      SDL_MOUSEBUTTONUP:
      begin
        if (event.button.button = sdl_button_left) and (menu <> -1) then
          break;
        if (event.button.button = sdl_button_left) and (menu <> -1) then
        begin
          menu := -1;
          break;
        end;
      end;
      SDL_MOUSEMOTION:
      begin
        if (round(event.button.x / (RealScreen.w / screen.w)) >= 100) and
          (round(event.button.x / (RealScreen.w / screen.w)) < 147) and
          (round(event.button.y / (RealScreen.h / screen.h)) >= 50) and
          (round(event.button.y / (RealScreen.h / screen.h)) < max * 22 + 78) then
        begin
          menup := menu;
          menu := (round(event.button.y / (RealScreen.h / screen.h)) - 52) div 22;
          if menu > max then
            menu := max;
          if menu < 0 then
            menu := 0;
          if menup <> menu then
            showbmenu(menustatus, menu, max);
        end
        else
          menu := -1;
      end;
    end;
  end;
  //result:=0;
  p := 0;
  for i := 0 to 9 do
  begin
    if (menustatus and (1 shl i)) > 0 then
    begin
      p := p + 1;
      if p > menu then
        break;
    end;
  end;
  Result := i;
  if menu = -1 then
    Result := -1;
  SDL_EnableKeyRepeat(30, 35);
end;

//显示战斗主选单

procedure ShowBMenu(MenuStatus, menu, max: integer);
var
  i, p: integer;
  word: array[0..9] of WideString;
begin
  word[0] := ' 移動';
  word[1] := ' 武學';
  word[2] := ' 用毒';
  word[3] := ' 解毒';
  word[4] := ' 醫療';
  word[5] := ' 物品';
  word[6] := ' 等待';
  word[7] := ' 狀態';
  word[8] := ' 休息';
  word[9] := ' 自動';
  //{$IFDEF DARWIN}
  RegionRect.x := 100;
  RegionRect.y := 50;
  RegionRect.w := 48;
  RegionRect.h := max * 22 + 29;
  //{$ENDIF}
  redraw;
  //{$IFDEF DARWIN}
  RegionRect.w := 0;
  RegionRect.h := 0;
  //{$ENDIF}
  DrawRectangle(100, 50, 47, max * 22 + 28, 0, colcolor(255), 30);
  p := 0;
  for i := 0 to 9 do
  begin
    if (p = menu) and ((menustatus and (1 shl i) > 0)) then
    begin
      drawshadowtext(@word[i][1], 83, 53 + 22 * p, colcolor($64), colcolor($66));
      p := p + 1;
    end
    else if (p <> menu) and ((menustatus and (1 shl i) > 0)) then
    begin
      drawshadowtext(@word[i][1], 83, 53 + 22 * p, colcolor($21), colcolor($23));
      p := p + 1;
    end;
  end;
  SDL_UpdateRect2(screen, 100, 50, 48, max * 22 + 29);
end;

//显示半即时进度

procedure DrawProgress;
var
  i, j, x, y, curHead, temp: integer;
  dest: TSDL_Rect;
  range, p: array of integer;
begin
  x := 50;
  y := Center_Y * 2 - 80;
  dest.y := y;
  DrawRectangleWithoutFrame(0, CENTER_Y * 2 - 50, CENTER_X * 2, 50, 0, 50);
  if length(BHead) = BRoleAmount then
  begin
    setlength(range, BroleAmount);
    setlength(p, BroleAmount);
    curHead := 0;
    for i := 0 to BRoleAmount - 1 do
    begin
      range[i] := i;
      p[i] := BRole[i].RealProgress * 500 div 10000;
    end;
    for i := 0 to BRoleAmount - 2 do
      for j := i + 1 to BRoleAmount - 1 do
      begin
        if p[i] <= p[j] then
        begin
          temp := p[i];
          p[i] := p[j];
          p[j] := temp;
          temp := range[i];
          range[i] := range[j];
          range[j] := temp;
        end;
      end;

    for i := 0 to BRoleAmount - 1 do
      if Brole[range[i]].Dead = 0 then
      begin
        //p := Brole[range[i]].RealProgress * 500 div 10000;
        dest.x := p[i] + x;
        if BHead[Brole[range[i]].BHead] <> nil then
          SDL_BlitSurface(BHead[Brole[range[i]].BHead], nil, screen, @dest);
      end;
  end;

end;

//移动

procedure MoveRole(bnum: integer);
var
  s, i: integer;
begin
  CalCanSelect(bnum, 0, brole[bnum].Step);
  SelectAimMode := 4;
  if SelectAim(bnum, brole[bnum].Step) then
  begin
    if (Ax <> Bx) or (Ay <> By) then
      Brole[bnum].Acted := 2; //2表示移动过
    MoveAmination(bnum);

  end;

end;

//移动动画
{procedure MoveAmination(bnum: integer);
var
  s, i: integer;
begin
  //CalCanSelect(bnum, 0);
  //if SelectAim(bnum,Brole[bnum,6]) then
  brole[bnum].Step := brole[bnum].Step - abs(Ax - Bx) - abs(Ay - By);
  s := sign(Ax - Bx);
  if s < 0 then Brole[bnum].Face := 0;
  if s > 0 then Brole[bnum].Face := 3;
  i := Bx + s;
  if s <> 0 then
    while s * (Ax - i) >= 0 do
    begin
      sdl_delay(20);
      if Bfield[2, Bx, By] = bnum then Bfield[2, Bx, By] := -1;
      Bx := i;
      if Bfield[2, Bx, By] = -1 then Bfield[2, Bx, By] := bnum;
      Redraw;
      SDL_UpdateRect2(screen, 0, 0, screen.w, screen.h);
      i := i + s;
    end;
  s := sign(Ay - By);
  if s < 0 then Brole[bnum].Face := 2;
  if s > 0 then Brole[bnum].Face := 1;
  i := By + s;
  if s <> 0 then
    while s * (Ay - i) >= 0 do
    begin
      sdl_delay(20);
      if Bfield[2, Bx, By] = bnum then Bfield[2, Bx, By] := -1;
      By := i;
      if Bfield[2, Bx, By] = -1 then Bfield[2, Bx, By] := bnum;
      Redraw;
      SDL_UpdateRect2(screen, 0, 0, screen.w, screen.h);
      i := i + s;
    end;
  Brole[bnum].X := Bx;
  Brole[bnum].Y := By;
  Bfield[2, Bx, By] := bnum;

end;}

procedure MoveAmination(bnum: integer);
var
  s, i, a, tempx, tempy: integer;
  linebx, lineby: array[0..64] of integer;
  Xinc, Yinc: array[1..4] of integer;
begin
  //CalCanSelect(bnum, 0);
  //if SelectAim(bnum,Brole[bnum,6]) then
  if Bfield[3, Ax, Ay] > 0 then
  begin
    brole[bnum].Step := brole[bnum].Step - abs(Ax - Bx) - abs(Ay - By);
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
    for a := 1 to Bfield[3, Ax, Ay] do
      for i := 1 to 4 do
      begin
        tempx := linebx[a - 1] + Xinc[i];
        tempy := lineby[a - 1] + Yinc[i];
        if Bfield[3, tempx, tempy] = Bfield[3, linebx[a - 1], lineby[a - 1]] - 1 then
        begin
          linebx[a] := tempx;
          lineby[a] := tempy;
          if (Bfield[7, tempx, tempy] = 0) or ((Bfield[7, tempx, tempy] = 1) and
            (tempx = Ax) and (tempy = Ay)) then
            break;
        end;
      end;
    a := Bfield[3, Ax, Ay] - 1;
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

      sdl_delay(BATTLE_SPEED);
      if Bfield[2, Bx, By] = bnum then
        Bfield[2, Bx, By] := -1;
      Bx := linebx[a];
      By := lineby[a];
      if Bfield[2, Bx, By] = -1 then
        Bfield[2, Bx, By] := bnum;
      Redraw;
      SDL_UpdateRect2(screen, 0, 0, screen.w, screen.h);

      a := a - 1;
      if a < 0 then
        break;

    end;

    Brole[bnum].X := Bx;
    Brole[bnum].Y := By;

  end;

end;


//选择查看状态的目标

function Selectshowstatus(bnum: integer): boolean;
var
  Axp, Ayp, rnum, step, range, AttAreaType: integer;
  //strs: array[1..17] of widestring;
begin

  Ax := Bx;
  Ay := By;
  step := 64;
  range := 0;
  AttAreaType := 0;
  CalCanSelect(bnum, 2, 64);
  SelectAimMode := 5;
  DrawBFieldWithCursor(AttAreaType, step, range);
  SDL_UpdateRect2(screen, 0, 0, screen.w, screen.h);
  while (SDL_WaitEvent(@event) >= 0) do
  begin
    CheckBasicEvent;
    case event.type_ of
      SDL_KEYUP:
      begin
        if (event.key.keysym.sym = sdlk_return) or (event.key.keysym.sym = sdlk_space) then
        begin
          if Bfield[2, Ax, Ay] >= 0 then
          begin
            rnum := Brole[Bfield[2, Ax, Ay]].rnum;
            if Brole[Bfield[2, Ax, Ay]].Team = 1 then
              //ShowSimpleStatus(rnum, Ax, Ay)
              ShowStatus(rnum, Bfield[2, Ax, Ay])
            else
              ShowStatus(rnum, Bfield[2, Ax, Ay]);
          end;
        end;
        if (event.key.keysym.sym = sdlk_escape) then
        begin
          Result := False;
          break;
        end;
        if (event.key.keysym.sym = sdlk_left) then
        begin
          Ay := Ay - 1;
          if (abs(Ax - Bx) + abs(Ay - By) > step) then
            Ay := Ay + 1;
          DrawBFieldWithCursor(AttAreaType, step, range);
          SDL_UpdateRect2(screen, 0, 0, screen.w, screen.h);
        end;
        if (event.key.keysym.sym = sdlk_right) then
        begin
          Ay := Ay + 1;
          if (abs(Ax - Bx) + abs(Ay - By) > step) then
            Ay := Ay - 1;
          DrawBFieldWithCursor(AttAreaType, step, range);
          SDL_UpdateRect2(screen, 0, 0, screen.w, screen.h);
        end;
        if (event.key.keysym.sym = sdlk_down) then
        begin
          Ax := Ax + 1;
          if (abs(Ax - Bx) + abs(Ay - By) > step) then
            Ax := Ax - 1;
          DrawBFieldWithCursor(AttAreaType, step, range);
          SDL_UpdateRect2(screen, 0, 0, screen.w, screen.h);
        end;
        if (event.key.keysym.sym = sdlk_up) then
        begin
          Ax := Ax - 1;
          if (abs(Ax - Bx) + abs(Ay - By) > step) then
            Ax := Ax + 1;
          DrawBFieldWithCursor(AttAreaType, step, range);
          SDL_UpdateRect2(screen, 0, 0, screen.w, screen.h);
        end;
      end;
      SDL_MOUSEBUTTONUP:
      begin
        if (event.button.button = sdl_button_left) then
        begin
          if Bfield[2, Ax, Ay] >= 0 then
          begin
            rnum := Brole[Bfield[2, Ax, Ay]].rnum;
            if Brole[Bfield[2, Ax, Ay]].Team = 1 then
              ShowSimpleStatus(rnum, Ax, Ay)
            else
              ShowStatus(rnum);
          end;
        end;
        if (event.button.button = sdl_button_right) then
        begin
          Result := False;
          break;
        end;
      end;
      SDL_MOUSEMOTION:
      begin
        Axp := (-round(event.button.x / (RealScreen.w / screen.w)) + CENTER_x + 2 *
          round(event.button.y / (RealScreen.h / screen.h)) - 2 * CENTER_y + 18) div 36 + Bx;
        Ayp := (round(event.button.x / (RealScreen.w / screen.w)) - CENTER_x + 2 *
          round(event.button.y / (RealScreen.h / screen.h)) - 2 * CENTER_y + 18) div 36 + By;
        if (abs(Axp - Bx) + abs(Ayp - By) <= step) then
        begin
          Ax := Axp;
          Ay := Ayp;
          DrawBFieldWithCursor(AttAreaType, step, range);
          SDL_UpdateRect2(screen, 0, 0, screen.w, screen.h);
        end;
      end;
    end;
  end;

end;


//选择点

function SelectAim(bnum, step: integer): boolean;
var
  Axp, Ayp: integer;
begin
  SDL_EnableKeyRepeat(20, 100);
  Ax := Bx;
  Ay := By;
  DrawBFieldWithCursor(0, step, 0);
  if (Bfield[2, AX, AY] >= 0) then
    showsimpleStatus(Brole[Bfield[2, AX, AY]].rnum, 350, 50);
  SDL_UpdateRect2(screen, 0, 0, screen.w, screen.h);
  while (SDL_WaitEvent(@event) >= 0) do
  begin
    CheckBasicEvent;
    case event.type_ of
      SDL_KEYUP:
      begin
        if (event.key.keysym.sym = sdlk_return) or (event.key.keysym.sym = sdlk_space) then
        begin
          Result := True;
          x50[28927] := 1;
          break;
        end;
        if (event.key.keysym.sym = sdlk_escape) then
        begin
          Result := False;
          x50[28927] := 0;
          break;
        end;
      end;
      SDL_KEYDOWN:
      begin
        if (event.key.keysym.sym = sdlk_left) then
        begin
          Ay := Ay - 1;
          if (abs(Ax - Bx) + abs(Ay - By) > step) or (Bfield[3, Ax, Ay] < 0) then
            Ay := Ay + 1;
        end;
        if (event.key.keysym.sym = sdlk_right) then
        begin
          Ay := Ay + 1;
          if (abs(Ax - Bx) + abs(Ay - By) > step) or (Bfield[3, Ax, Ay] < 0) then
            Ay := Ay - 1;
        end;
        if (event.key.keysym.sym = sdlk_down) then
        begin
          Ax := Ax + 1;
          if (abs(Ax - Bx) + abs(Ay - By) > step) or (Bfield[3, Ax, Ay] < 0) then
            Ax := Ax - 1;
        end;
        if (event.key.keysym.sym = sdlk_up) then
        begin
          Ax := Ax - 1;
          if (abs(Ax - Bx) + abs(Ay - By) > step) or (Bfield[3, Ax, Ay] < 0) then
            Ax := Ax + 1;
        end;
      end;
      SDL_MOUSEBUTTONUP:
      begin
        if (event.button.button = sdl_button_left) then
        begin
          if (abs(Axp - Bx) + abs(Ayp - By) <= step) and (Bfield[3, Ax, Ay] >= 0) then
          begin
            Result := True;
            break;
          end;
        end;
        if (event.button.button = sdl_button_right) then
        begin
          Result := False;
          break;
        end;
      end;
      SDL_MOUSEMOTION:
      begin
        Axp := (-round(event.button.x / (RealScreen.w / screen.w)) + CENTER_x + 2 *
          round(event.button.y / (RealScreen.h / screen.h)) - 2 * CENTER_y + 18) div 36 + Bx;
        Ayp := (round(event.button.x / (RealScreen.w / screen.w)) - CENTER_x + 2 *
          round(event.button.y / (RealScreen.h / screen.h)) - 2 * CENTER_y + 18) div 36 + By;
        if (abs(Axp - Bx) + abs(Ayp - By) <= step) and (Bfield[3, Axp, Ayp] >= 0) then
        begin
          Ax := Axp;
          Ay := Ayp;
        end;
      end;
    end;
    DrawBFieldWithCursor(0, step, 0);
    if Bfield[2, Ax, Ay] >= 0 then
      ShowSimpleStatus(Brole[Bfield[2, Ax, Ay]].rnum, 350, 50);
    SDL_UpdateRect2(screen, 0, 0, screen.w, screen.h);

  end;
  SDL_EnableKeyRepeat(30, 35);
end;

//选择原地

function SelectCross(bnum, AttAreaType, step, range: integer): boolean;
var
  Axp, Ayp: integer;
begin
  Ax := Bx;
  Ay := By;
  DrawBFieldWithCursor(AttAreaType, step, range);
  SDL_UpdateRect2(screen, 0, 0, screen.w, screen.h);
  while (SDL_WaitEvent(@event) >= 0) do
  begin
    CheckBasicEvent;
    case event.type_ of
      SDL_KEYUP:
      begin
        if (event.key.keysym.sym = sdlk_return) or (event.key.keysym.sym = sdlk_space) then
        begin
          Result := True;
          break;
        end;
        if (event.key.keysym.sym = sdlk_escape) then
        begin
          Result := False;
          break;
        end;
      end;
      SDL_MOUSEBUTTONUP:
      begin
        if (event.button.button = sdl_button_left) then
        begin
          Result := True;
          break;
        end;
        if (event.button.button = sdl_button_right) then
        begin
          Result := False;
          break;
        end;
      end;
    end;
  end;

end;

//目标系点叉菱方型、原地系菱方型

function SelectRange(bnum, AttAreaType, step, range: integer): boolean;
var
  Axp, Ayp: integer;
begin
  Ax := Bx;
  Ay := By;
  DrawBFieldWithCursor(AttAreaType, step, range);
  if (Bfield[2, AX, AY] >= 0) then
    showsimpleStatus(Brole[Bfield[2, AX, AY]].rnum, 350, 50);
  SDL_UpdateRect2(screen, 0, 0, screen.w, screen.h);
  while (SDL_WaitEvent(@event) >= 0) do
  begin
    CheckBasicEvent;
    case event.type_ of
      SDL_KEYUP:
      begin
        if (event.key.keysym.sym = sdlk_return) or (event.key.keysym.sym = sdlk_space) then
        begin
          Result := True;
          x50[28927] := 1;
          break;
        end;
        if (event.key.keysym.sym = sdlk_escape) then
        begin
          Result := False;
          x50[28927] := 0;
          break;
        end;
        if (event.key.keysym.sym = sdlk_left) then
        begin
          Ay := Ay - 1;
          if (abs(Ax - Bx) + abs(Ay - By) > step) then
            Ay := Ay + 1;
        end;
        if (event.key.keysym.sym = sdlk_right) then
        begin
          Ay := Ay + 1;
          if (abs(Ax - Bx) + abs(Ay - By) > step) then
            Ay := Ay - 1;
        end;
        if (event.key.keysym.sym = sdlk_down) then
        begin
          Ax := Ax + 1;
          if (abs(Ax - Bx) + abs(Ay - By) > step) then
            Ax := Ax - 1;
        end;
        if (event.key.keysym.sym = sdlk_up) then
        begin
          Ax := Ax - 1;
          if (abs(Ax - Bx) + abs(Ay - By) > step) then
            Ax := Ax + 1;
        end;
        DrawBFieldWithCursor(AttAreaType, step, range);
        if (Bfield[2, AX, AY] >= 0) then
          showsimpleStatus(Brole[Bfield[2, AX, AY]].rnum, 350, 50);
        SDL_UpdateRect2(screen, 0, 0, screen.w, screen.h);
      end;
      SDL_MOUSEBUTTONUP:
      begin
        if (event.button.button = sdl_button_left) then
        begin
          Result := True;
          break;
        end;
        if (event.button.button = sdl_button_right) then
        begin
          Result := False;
          break;
        end;
      end;
      SDL_MOUSEMOTION:
      begin
        Axp := (-round(event.button.x / (RealScreen.w / screen.w)) + CENTER_x + 2 *
          round(event.button.y / (RealScreen.h / screen.h)) - 2 * CENTER_y + 18) div 36 + Bx;
        Ayp := (round(event.button.x / (RealScreen.w / screen.w)) - CENTER_x + 2 *
          round(event.button.y / (RealScreen.h / screen.h)) - 2 * CENTER_y + 18) div 36 + By;
        if (abs(Axp - Bx) + abs(Ayp - By) <= step) then
        begin
          Ax := Axp;
          Ay := Ayp;
          DrawBFieldWithCursor(AttAreaType, step, range);
          if (Bfield[2, AX, AY] >= 0) then
            showsimpleStatus(Brole[Bfield[2, AX, AY]].rnum, 350, 50);
          SDL_UpdateRect2(screen, 0, 0, screen.w, screen.h);
        end;
      end;
    end;
  end;

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

  minstep := Rmagic[mnum].unknow[1];

  Ax := Bx - minstep - 1;
  Ay := By;
  DrawBFieldWithCursor(AttAreaType, step, range);
  SDL_UpdateRect2(screen, 0, 0, screen.w, screen.h);
  while (SDL_WaitEvent(@event) >= 0) do
  begin
    CheckBasicEvent;
    case event.type_ of
      SDL_KEYUP:
      begin
        if (event.key.keysym.sym = sdlk_return) or (event.key.keysym.sym = sdlk_space) then
        begin
          Result := True;
          x50[28927] := 1;
          break;
        end;
        if (event.key.keysym.sym = sdlk_escape) then
        begin
          Result := False;
          x50[28927] := 0;
          break;
        end;
        if (event.key.keysym.sym = sdlk_left) then
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
          SDL_UpdateRect2(screen, 0, 0, screen.w, screen.h);
        end;
        if (event.key.keysym.sym = sdlk_right) then
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
          SDL_UpdateRect2(screen, 0, 0, screen.w, screen.h);
        end;
        if (event.key.keysym.sym = sdlk_down) then
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
          SDL_UpdateRect2(screen, 0, 0, screen.w, screen.h);
        end;
        if (event.key.keysym.sym = sdlk_up) then
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
          SDL_UpdateRect2(screen, 0, 0, screen.w, screen.h);
        end;
      end;
      SDL_MOUSEBUTTONUP:
      begin
        if (event.button.button = sdl_button_left) then
        begin
          Result := True;
          break;
        end;
        if (event.button.button = sdl_button_right) then
        begin
          Result := False;
          break;
        end;
      end;
      SDL_MOUSEMOTION:
      begin
        Axp := (-round(event.button.x / (RealScreen.w / screen.w)) + CENTER_x + 2 *
          round(event.button.y / (RealScreen.h / screen.h)) - 2 * CENTER_y + 18) div 36 + Bx;
        Ayp := (round(event.button.x / (RealScreen.w / screen.w)) - CENTER_x + 2 *
          round(event.button.y / (RealScreen.h / screen.h)) - 2 * CENTER_y + 18) div 36 + By;
        if (abs(Axp - Bx) + abs(Ayp - By) <= step) and (abs(Axp - Bx) + abs(Ayp - By) > minstep) then
        begin
          Ax := Axp;
          Ay := Ayp;
          DrawBFieldWithCursor(AttAreaType, step, range);
          SDL_UpdateRect2(screen, 0, 0, screen.w, screen.h);
        end;
      end;
    end;
  end;

end;


//选择方向

function SelectDirector(bnum, AttAreaType, step, range: integer): boolean;
var
  str: WideString;
begin
  Ax := Bx - 1;
  Ay := By;
  //str := ' 選擇攻擊方向';
  //Drawtextwithrect(@str[1], 280, 200, 125, colcolor($21), colcolor($23));
  DrawBFieldWithCursor(AttAreaType, step, range);
  SDL_UpdateRect2(screen, 0, 0, screen.w, screen.h);
  Result := False;
  while (SDL_WaitEvent(@event) >= 0) do
  begin
    CheckBasicEvent;
    case event.type_ of
      SDL_KEYUP:
      begin
        if (event.key.keysym.sym = sdlk_escape) then
        begin
          break;
        end;
        if (event.key.keysym.sym = sdlk_return) or (event.key.keysym.sym = sdlk_space) then
        begin
          if (Ax <> Bx) or (Ay <> By) then
            Result := True;
          break;
        end;
        if (event.key.keysym.sym = sdlk_left) then
        begin
          Ay := By - 1;
          Ax := Bx;
          DrawBFieldWithCursor(AttAreaType, step, range);
          SDL_UpdateRect2(screen, 0, 0, screen.w, screen.h);
        end;
        if (event.key.keysym.sym = sdlk_right) then
        begin
          Ay := By + 1;
          Ax := Bx;
          DrawBFieldWithCursor(AttAreaType, step, range);
          SDL_UpdateRect2(screen, 0, 0, screen.w, screen.h);
        end;
        if (event.key.keysym.sym = sdlk_down) then
        begin
          Ax := Bx + 1;
          Ay := By;
          DrawBFieldWithCursor(AttAreaType, step, range);
          SDL_UpdateRect2(screen, 0, 0, screen.w, screen.h);
        end;
        if (event.key.keysym.sym = sdlk_up) then
        begin
          Ax := Bx - 1;
          Ay := By;
          DrawBFieldWithCursor(AttAreaType, step, range);
          SDL_UpdateRect2(screen, 0, 0, screen.w, screen.h);
        end;
      end;
      Sdl_mousebuttonup:
      begin
        if event.button.button = sdl_button_right then
        begin
          Result := False;
          break;
        end;
        //按照所点击位置设置方向
        if event.button.button = sdl_button_left then
        begin
          if (round(event.button.x / (RealScreen.w / screen.w)) < CENTER_x) and
            (round(event.button.y / (RealScreen.h / screen.h)) < CENTER_y) then
          begin
            Ay := By - 1;
            Ax := Bx;
            Result := True;
            break;
          end;
          if (round(event.button.x / (RealScreen.w / screen.w)) < CENTER_x) and
            (round(event.button.y / (RealScreen.h / screen.h)) >= CENTER_y) then
          begin
            Ax := Bx + 1;
            Ay := By;
            Result := True;
            break;
          end;
          if (round(event.button.x / (RealScreen.w / screen.w)) >= CENTER_x) and
            (round(event.button.y / (RealScreen.h / screen.h)) < CENTER_y) then
          begin
            Ax := Bx - 1;
            Ay := By;
            Result := True;
            break;
          end;
          if (round(event.button.x / (RealScreen.w / screen.w)) >= CENTER_x) and
            (round(event.button.y / (RealScreen.h / screen.h)) >= CENTER_y) then
          begin
            Ay := By + 1;
            Ax := Bx;
            Result := True;
            break;
          end;
        end;
      end;
      SDL_MOUSEMOTION:
      begin
        if (round(event.button.x / (RealScreen.w / screen.w)) < CENTER_x) and
          (round(event.button.y / (RealScreen.h / screen.h)) < CENTER_y) then
        begin
          Ay := By - 1;
          Ax := Bx;
        end;
        if (round(event.button.x / (RealScreen.w / screen.w)) < CENTER_x) and
          (round(event.button.y / (RealScreen.h / screen.h)) >= CENTER_y) then
        begin
          Ax := Bx + 1;
          Ay := By;
        end;
        if (round(event.button.x / (RealScreen.w / screen.w)) >= CENTER_x) and
          (round(event.button.y / (RealScreen.h / screen.h)) < CENTER_y) then
        begin
          Ax := Bx - 1;
          Ay := By;
        end;
        if (round(event.button.x / (RealScreen.w / screen.w)) >= CENTER_x) and
          (round(event.button.y / (RealScreen.h / screen.h)) >= CENTER_y) then
        begin
          Ay := By + 1;
          Ax := Bx;
        end;
        DrawBFieldWithCursor(AttAreaType, step, range);
        SDL_UpdateRect2(screen, 0, 0, screen.w, screen.h);

      end;
    end;
  end;
end;


//计算可以被选中的位置
//利用递归确定

procedure SeekPath(x, y, step: integer);
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

end;


//计算可以被选中的位置
//利用队列
//移动过程中，旁边有敌人，则不能继续移动

procedure SeekPath2(x, y, step, myteam, mode: integer);
var
  Xlist: array[0..4096] of integer;
  Ylist: array[0..4096] of integer;
  steplist: array[0..4096] of integer;
  curgrid, totalgrid: integer;
  Bgrid: array[1..4] of integer; //0空位, 1建筑, 2友军, 3敌军, 4出界, 5已走过, 6水面, 7敌人身旁
  Xinc, Yinc: array[1..4] of integer;
  curX, curY, curstep, nextX, nextY, nextnextX, nextnextY: integer;
  i, j, minBeside: integer;
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
        Bgrid[i] := 0;
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
        else if (Bfield[2, nextX, nextY] >= 0) and (BRole[Bfield[2, nextX, nextY]].Dead = 0) then
        begin
          if BRole[Bfield[2, nextX, nextY]].Team = myteam then
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
        else
          Bgrid[i] := 0;
        for j := 1 to 4 do
        begin
          nextnextX := nextX + Xinc[j];
          nextnextY := nextY + Yinc[j];
          if (nextnextX >= 0) and (nextnextX < 63) and (nextnextY >= 0) and (nextnextY < 63) then
            if (Bfield[2, nextnextX, nextnextY] >= 0) and (BRole[Bfield[2, nextnextX, nextnextY]].Dead =
              0) and (BRole[Bfield[2, nextnextX, nextnextY]].Team <> myteam) then
            begin
              BField[7, nextX, nextY] := 1;
            end;
        end;
      end;

      //移动的情况
      //若为初始位置，不考虑旁边是敌军的情况
      //在移动过程中，旁边没有敌军的情况下才继续移动
      if mode = 0 then
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
              Bfield[3, Xlist[totalgrid], Ylist[totalgrid]] := steplist[totalgrid];
              //if (Bgrid[i] = 3) then Bfield[3, Xlist[totalgrid], Ylist[totalgrid]] := step;
              //showmessage(inttostr(steplist[totalgrid]));
              totalgrid := totalgrid + 1;
            end;
          end;
        end;
      end
      else
        //非移动的情况，攻击、医疗等
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

  //处理敌人身边的格子
end;

{var
  Xlist: array[0..4096] of integer;
  Ylist: array[0..4096] of integer;
  steplist: array[0..4096] of integer;
  curgrid, totalgrid: integer;
  Bgrid: array[1..4] of integer; //0空位，1建筑，2友军，3敌军，4出界，5已走过
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
      //若为初始位置，不考虑旁边是敌军的情况
      //在移动过程中，旁边没有敌军的情况下才继续移动
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
        //非移动的情况，攻击、医疗等
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
//mode=0移动，1攻击用毒医疗等，2查看状态

procedure CalCanSelect(bnum, mode, step: integer);
var
  i, i1, i2, step0: integer;
begin
  //step := Brole[bnum].Step;

  if mode = 0 then
  begin
    FillChar(Bfield[3, 0, 0], 4096 * 2, -1);
    FillChar(Bfield[7, 0, 0], 4096 * 2, 0);  //第7层标记敌人身旁的位置
    Bfield[3, Brole[bnum].X, Brole[bnum].Y] := 0;
    SeekPath2(Brole[bnum].X, Brole[bnum].Y, Step, Brole[bnum].Team, mode);
    if Brole[bnum].Acted = 0 then
      move(Bfield[3, 0, 0], Bfield[6, 0, 0], 4096 * 2)  //第6层标记第一次不能走到的位置
    else
      for i1 := 0 to 63 do
        for i2 := 0 to 63 do
        begin
          if Bfield[6, i1, i2] = -1 then
            Bfield[3, i1, i2] := -1;
        end;
  end;

  if mode = 1 then
  begin
    FillChar(Bfield[3, 0, 0], 4096 * 2, -1);
    for i1 := Brole[bnum].X - step to Brole[bnum].X + step do
    begin
      step0 := abs(i1 - Brole[bnum].X);
      for i2 := Brole[bnum].Y - step + step0 to Brole[bnum].Y + step - step0 do
      begin
        Bfield[3, i1, i2] := 0;
      end;
    end;
  end;

  if mode = 2 then
    for i1 := 0 to 63 do
      for i2 := 0 to 63 do
      begin
        Bfield[3, i1, i2] := -1;
        if Bfield[2, i1, i2] >= 0 then
          Bfield[3, i1, i2] := 0;
      end;

end;


//攻击

procedure Attack(bnum: integer);
var
  rnum, i, mnum, level, step, range, AttAreaType, i1, twice, temp: integer;
  str: string;
begin
  rnum := brole[bnum].rnum;
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
    if rmagic[mnum].HurtType = 2 then
      SelectAimMode := rmagic[mnum].AddMP[0]; //2是特技，用AddMP[0]表示目标方式
    //1范围内我方，2敌方全体，3我方全体；4自身；5范围内全部；6全部；7无高亮
    if rmagic[mnum].HurtType = 5 then
      selectaimMode := 5;



    //250号武功，乱石嶙峋
    if mnum = 250 then
    begin
      //消耗内力
      RRole[rnum].CurrentMP := RRole[rnum].CurrentMP - rmagic[mnum].NeedMP * ((level + 1) div 2);
      if RRole[rnum].CurrentMP < 0 then
        RRole[rnum].CurrentMP := 0;

      //消耗体力
      RRole[rnum].PhyPower := RRole[rnum].PhyPower - ((rmagic[mnum].NeedMP)) * 2;
      //RRole[rnum].PhyPower := RRole[rnum].PhyPower - 3;
      if RRole[rnum].PhyPower < 0 then
        RRole[rnum].PhyPower := 0;

      PutStone(bnum, mnum, level);
      Brole[bnum].Acted := 1;
      Rrole[rnum].MagLevel[i] := Rrole[rnum].MagLevel[i] + random(2) + 1;
      if Rrole[rnum].MagLevel[i] > 999 then
        Rrole[rnum].MagLevel[i] := 999;

    end
    else
    //256号武功，万里独行
    if mnum = 256 then
      LongWalk(bnum, mnum, level)
    else
    begin
      if i >= 0 then
      begin
        //依据攻击范围进一步选择
        step := Rmagic[mnum].MoveDistance[level - 1];
        range := Rmagic[mnum].AttDistance[level - 1];
        AttAreaType := Rmagic[mnum].AttAreaType;

        //12号状态，剑芒，攻击范围+1
        if (brole[bnum].StateLevel[12] > 0) and (rmagic[mnum].hurtType <> 2) then
        begin
          case AttAreaType of
            0, 3, 6: range := range + 1;
            1, 4, 5: step := step + 1;
            2:
            begin
              step := step + sign(step);
              range := range + sign(range);
            end;
          end;
        end;

        CalCanSelect(bnum, 1, step);
        case Rmagic[mnum].AttAreaType of
          0, 3:
          begin
            if SelectRange(bnum, AttAreaType, step, range) then
            begin
              SetAminationPosition(AttAreaType, step, range);
              Brole[bnum].Acted := 1;
            end;
          end;
          1, 4, 5:
          begin
            if SelectDirector(bnum, AttAreaType, step, range) then
            begin
              SetAminationPosition(AttAreaType, step, range);
              Brole[bnum].Acted := 1;
            end;
          end;
          2:
          begin
            if SelectCross(bnum, AttAreaType, step, range) then
            begin
              SetAminationPosition(AttAreaType, step, range);
              Brole[bnum].Acted := 1;
            end;
          end;
          6:
          begin
            if SelectFar(bnum, mnum, level) then
            begin
              SetAminationPosition(AttAreaType, step, range);
              Brole[bnum].Acted := 1;
            end;
          end;
        end;
        //如果行动成功, 武功等级增加, 播放效果
        if Brole[bnum].Acted = 1 then
        begin
          twice:=0;
          if rmagic[mnum].MagicType=2 then
            if random(1000)< rrole[brole[bnum].rnum].Sword  then
              twice:=1;

          for i1 := 0 to Brole[bnum].Statelevel[13] + rrole[brole[bnum].rnum].addnum + twice do
          begin
            //if Rmagic[mnum].Data[8]>= 0 then
            //instruct_32( Rmagic[mnum].Data[8],-Rmagic[mnum].Data[9]);


            Rrole[rnum].MagLevel[i] := Rrole[rnum].MagLevel[i] + random(2) + 1;
            if Rrole[rnum].MagLevel[i] > 999 then
              Rrole[rnum].MagLevel[i] := 999;

            //无坚不摧
            if mnum = 270 then
            begin
              //rmagic[mnum].Attack[0] := rrole[rnum].Attack * rrole[rnum].maglevel[i] div 100;
              rmagic[mnum].Attack[1] := rrole[rnum].Attack * rrole[rnum].maglevel[i] div 100;
            end;

            if rmagic[mnum].UnKnow[4] > 0 then
            begin
              //rmagic[mnum].UnKnow[4] := strtoint(InputBox('Enter name', 'ssss', '10'));
              execscript(PChar('script\SpecialMagic' + IntToStr(rmagic[mnum].UnKnow[4]) + '.lua'),
                PChar('f' + IntToStr(rmagic[mnum].UnKnow[4])));
              if rmagic[mnum].NeedMP * (level + 1) div 2 > rrole[rnum].CurrentMP then
              begin
                level := rrole[rnum].CurrentMP div rmagic[mnum].NeedMP * 2;
              end;
              rrole[rnum].CurrentMP := rrole[rnum].CurrentMP - rmagic[mnum].NeedMP * (level + 1) div 2;
              if rrole[rnum].CurrentMP < 0 then
                rrole[rnum].CurrentMP := 0;

            end
            else if mnum = 251 then
              gangbeat(bnum, mnum, level) //同仇敌忾
            else if mnum = 253 then
              duckweed(bnum, mnum, level) //乱世浮萍
            else if mnum = 254 then
              GodBless(bnum, mnum, level) //神照功
            else if mnum = 255 then
              GhostChange(bnum, mnum, level) //神行百变
            else if mnum = 263 then
              slashhorse(bnum, mnum, level) //策马啸西风
            else if mnum = 265 then
              HeroicSpirit(bnum, mnum, level) //侠之大者
            else if mnum = 267 then
              RewardGoodness(bnum, mnum, level) //赏善
            else if mnum = 268 then
              PunishEvil(bnum, mnum, level) //罚恶
            else if mnum = 272 then
              ControlEnemy(bnum, mnum, level) //韦编三绝
            else if mnum = 275 then
              PKuntildie(bnum, mnum, level) //断己相杀
            else if mnum = 276 then
              ExtendRound(bnum, mnum, level) //七窍玲珑
            else if mnum = 277 then
              tactics(bnum, mnum, level) //排兵布阵
            else if mnum = 271 then
              xiantianyiyang(bnum, mnum, level) //先天一阳指
            else if mnum = 202 then
              xixing(bnum, mnum, level) //吸星大法
            else if mnum = 278 then
              senluo(bnum, mnum, level) //森罗万象
            else if mnum = 157 then
              ambush(bnum, mnum, level, 1) //十面埋伏
            else if mnum = 158 then
              ambush(bnum, mnum, level, 0) //潇湘夜雨
            else if mnum = 282 then
              AllEqual(bnum, mnum, level) //众生平等
            else if mnum = 138 then
              charming(bnum, mnum, level) //千娇百媚
            else if mnum = 269 then
              clearheart(bnum, mnum, level) //清心普善
            else if mnum = 283 then
              swapmp(bnum, mnum, level) //不知所措
            else if mnum = 284 then
              swapHp(bnum, mnum, level) //颠三倒四
            else if mnum = 149 then
              givemelife(bnum, mnum, level, 0) //人人为我
            else if mnum = 153 then
              givemelife(bnum, mnum, level, 1) //自私自利
            else if mnum = 152 then
              IncreaceMP(bnum, mnum, level) //打坐吐纳
            else if mnum = 154 then
              steal(bnum, mnum, level) //妙手空空
            else if mnum = 159 then
              LionRoar(bnum, mnum, level) //狮子吼
            else if mnum = 155 then
              cureall(bnum, mnum, level) //阎王敌
            else if mnum = 150 then
              TransferMP(bnum, mnum, level) //舍己为人
            else if mnum = 288 then
              pojia(bnum, mnum, level) //破甲
            else if mnum = 252 then
              alladdPhy(bnum, mnum, level) //静诵黄庭
            else if mnum = 249 then
              PoisonAll(bnum, mnum, level) //含沙射影
            else if mnum = 151 then
              MedPoisonAll(bnum, mnum, level) //药王神篇
            else if mnum = 156 then
              IncreaceHP(bnum, mnum, level) //运功疗伤
            else
              AttackAction(bnum, mnum, level);
          end;
        end;
      end;
    end;
    if Brole[bnum].Acted = 1 then
      break;
  end;
end;

//攻击效果

procedure AttackAction(bnum, mnum, level: integer);
var
  i, movestep, j, incx, incy, aimx, aimy, incbing, neinum, neilevel, lastng: integer;

  p: double;
begin

  //自动时的吸星大法
  if mnum = 202 then
    xixing(bnum, mnum, level)
  else
  begin

    if Brole[bnum].Team = 0 then
      ShowMagicName(mnum);

    //内功效果的名称显示
    //内功影响武功伤害
    p := 1;
    lastng := -1;
    for i := 0 to 3 do
    begin
      neinum := Rrole[brole[bnum].rnum].neigong[i];
      if neinum <= 0 then
        break;
      neilevel := Rrole[brole[bnum].rnum].NGLevel[i] div 100 + 1;

      //普通内功对应类型的加成
      if ((Rmagic[neinum].MoveDistance[0] = 6) or (Rmagic[neinum].MoveDistance[0] = rmagic[mnum].MagicType)) and
        (Rmagic[neinum].MoveDistance[1] >= Rmagic[mnum].attack[1] div 100) then
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
        showstringonbrole(big5tounicode(@rmagic[neinum].Name) + '·威力', bnum, 3);
      end;

      //资质对武功加成，段家心法
      if Rmagic[neinum].AttDistance[7] > 0 then
      begin
        showstringonbrole(big5tounicode(@rmagic[neinum].Name) + '·威力', bnum, 3);
      end;

      //我方剩余人数加成，神龙吟
      if Rmagic[neinum].AttDistance[9] > 0 then
      begin
        showstringonbrole(big5tounicode(@rmagic[neinum].Name) + '·神威', bnum, 3);
      end;

      //对轻功加成的加成，玉女心经
      if Rmagic[neinum].MoveDistance[8] > 0 then
      begin
        showstringonbrole(big5tounicode(@rmagic[neinum].Name) + '·轻力', bnum, 3);
      end;

      //对内功加成的加成
      if Rmagic[neinum].MoveDistance[6] > 0 then
      begin
        showstringonbrole(big5tounicode(@rmagic[neinum].Name) + '·强内', bnum, 3);
      end;
    end;

    if lastng > 0 then
      showstringonbrole(big5tounicode(@rmagic[lastng].Name) + '·加力', bnum, 3);


    instruct_67(Rmagic[mnum].SoundNum);
    PlayActionAmination(bnum, Rmagic[mnum].MagicType); //动画效果
    CalHurtRole(bnum, mnum, level, 1); //计算被打到的人物
    PlayMagicAmination(bnum, Rmagic[mnum].AmiNum); //武功效果
    ShowHurtValue(rmagic[mnum].HurtType); //显示数字
    if Rmagic[mnum].Data[8] > 0 then
      instruct_32(Rmagic[mnum].Data[8], -Rmagic[mnum].Data[9]);
  end;
  //19号状态，青翼，被攻击后移动
  if rmagic[mnum].HurtType = 0 then
    for I := 0 to broleamount - 1 do
    begin
      if (Bfield[4, brole[i].X, brole[i].Y] > 0) and (brole[i].StateLevel[19] = 1) and (Brole[i].Auto = 0) then
      begin
        movestep := rrole[Brole[i].rnum].Movestep;
        movestep := movestep div 10;
        movestep := movestep + Brole[i].statelevel[3] + Brole[i].loverlevel[2] +
          ritem[rrole[Brole[i].rnum].Equip[1]].AddMove + ritem[rrole[Brole[i].rnum].Equip[0]].AddMove;
        Bx := brole[i].X;
        By := brole[i].Y;
        CalCanSelect(i, 0, movestep);
        SelectAim(i, movestep);
        Brole[i].X := Ax;
        Brole[i].Y := Ay;
        Bfield[2, Bx, By] := -1;
        Bfield[2, Ax, Ay] := i;
      end;
    end;

  //8号状态，风雷，攻击后直线敌人后移N格
  if brole[bnum].StateLevel[8] > 0 then
  begin
    for I := 0 to broleamount - 1 do
    begin
      if (Bfield[4, brole[i].X, brole[i].Y] > 0) then
        if (brole[i].x = Bx) or (brole[i].Y = By) then
        begin
          incx := sign(brole[i].X - Bx);
          incy := sign(brole[i].Y - By);
          aimx := brole[i].X;
          aimy := brole[i].Y;
          for j := 0 to brole[bnum].Statelevel[8] - 1 do
          begin
            if (bfield[2, aimx + incx, aimy + incy] = -1) and (bfield[1, aimx + incx, aimy + incy] = 0) then
            begin
              aimx := aimx + incx;
              aimy := aimy + incy;
            end
            else
              break;
          end;
          Bfield[2, brole[i].x, Brole[i].y] := -1;
          Brole[i].X := aimx;
          Brole[i].Y := aimy;
          Bfield[2, aimx, aimy] := i;
        end;
    end;
  end;

  //17号状态，博采，受攻击后增加兵器值
  if rmagic[mnum].HurtType = 0 then
    for I := 0 to broleamount - 1 do
    begin
      if (Bfield[4, brole[i].X, brole[i].Y] > 0) and (brole[i].StateLevel[17] > 0) then
      begin
        if random(100) < brole[i].StateLevel[17] then
        begin
          case rmagic[mnum].MagicType of
            1:
            begin
              if rrole[i].Fist >= 20 then
              begin
                rrole[brole[i].rnum].Fist := rrole[brole[i].rnum].Fist + 1;

                if rrole[brole[i].rnum].Fist > 999 then
                  rrole[brole[i].rnum].Fist := 999;
              end;
            end;
            2:
            begin
              if rrole[i].sword >= 20 then
              begin
                rrole[brole[i].rnum].sword := rrole[brole[i].rnum].Sword + 1;
                if rrole[brole[i].rnum].Sword > 999 then
                  rrole[brole[i].rnum].Sword := 999;
              end;
            end;
            3:
            begin
              if rrole[i].knife >= 20 then
              begin
                rrole[brole[i].rnum].knife := rrole[brole[i].rnum].Knife + 1;
                if rrole[brole[i].rnum].Knife > 999 then
                  rrole[brole[i].rnum].Knife := 999;
              end;
            end;
            4:
            begin
              if rrole[i].Unusual >= 20 then
              begin
                rrole[brole[i].rnum].Unusual := rrole[brole[i].rnum].Unusual + 1;
                if rrole[brole[i].rnum].Unusual > 999 then
                  rrole[brole[i].rnum].Unusual := 999;
              end;
            end;
          end;
        end;
      end;
    end;
end;

procedure ShowMagicName(mnum: integer);
var
  l: integer;
  str: WideString;
begin
  Redraw;
  str := big5tounicode(@Rmagic[mnum].Name);
  str := MidStr(str, 1, 6);
  l := length(str);
  drawtextwithrect(@str[1], CENTER_X - l * 10, CENTER_Y - 150, l * 20 - 14, colcolor($14), colcolor($16));
  SDL_UpdateRect2(screen, 0, 0, screen.w, screen.h);
  Sdl_Delay(400);
  event.key.keysym.sym := 0;
  event.button.button := 0;

end;

//选择武功

function SelectMagic(rnum: integer): integer;
var
  i, p, menustatus, max, menu, menup: integer;
  str: widestring;
begin
  menustatus := 0;
  max := 0;
  setlength(menustring, 10);
  setlength(menuengstring, 10);
  SDL_EnableKeyRepeat(20, 100);
  for i := 0 to 9 do
  begin
    if Rrole[rnum].Magic[i] > 0 then
    begin
      if ((Rmagic[Rrole[rnum].Magic[i]].Data[8] <= 0) or ((Rmagic[Rrole[rnum].Magic[i]].Data[8] > 0) and
        (Rmagic[Rrole[rnum].Magic[i]].Data[9] <= GetItemAmount(Rmagic[Rrole[rnum].Magic[i]].Data[8])))) and
        ((Rmagic[Rrole[rnum].Magic[i]].NeedMP <= Rrole[rnum].CurrentMP)) then
      begin
        menustatus := menustatus or (1 shl i);
        menustring[i] := Big5toUnicode(@Rmagic[Rrole[rnum].Magic[i]].Name);
        menuengstring[i] := format('%3d', [Rrole[rnum].MagLevel[i] div 100 + 1]);
        max := max + 1;
      end;
    end;
  end;
  max := max - 1;

  ReDraw;
  SDL_UpdateRect2(screen, 0, 0, screen.w, screen.h);
  menu := 0;
  if max < 0 then
  begin
    result := -1;
    str := ' 內力不足以發動任何武學！';
    drawtextwithrect(@str[1], 100, 50, 245, colcolor($21), colcolor($23));
    SDL_UpdateRect2(screen, 0, 0, screen.w, screen.h);
    waitanykey;
    exit;
  end;
  showmagicmenu(menustatus, menu, max);
  //SDL_UpdateRect2(screen,0,0,screen.w,screen.h);
  while (SDL_WaitEvent(@event) >= 0) do
  begin
    CheckBasicEvent;
    case event.type_ of
      SDL_KEYUP:
      begin
        if (event.key.keysym.sym = sdlk_return) or (event.key.keysym.sym = sdlk_space) then
        begin
          break;
        end;
        if (event.key.keysym.sym = sdlk_escape) then
        begin
          menu := -1;
          break;
        end;
      end;
      SDL_KEYDOWN:
      begin
        if (event.key.keysym.sym = sdlk_up) then
        begin
          menu := menu - 1;
          if menu < 0 then
            menu := max;
          showmagicmenu(menustatus, menu, max);
        end;
        if (event.key.keysym.sym = sdlk_down) then
        begin
          menu := menu + 1;
          if menu > max then
            menu := 0;
          showmagicmenu(menustatus, menu, max);
        end;
      end;
      SDL_MOUSEBUTTONUP:
      begin
        if (event.button.button = sdl_button_left) and (menu <> -1) then
        begin
          break;
        end;
        if (event.button.button = sdl_button_right) then
        begin
          menu := -1;
          break;
        end;
      end;
      SDL_MOUSEMOTION:
      begin
        if (round(event.button.x / (RealScreen.w / screen.w)) >= 100) and
          (round(event.button.x / (RealScreen.w / screen.w)) < 267) and
          (round(event.button.y / (RealScreen.h / screen.h)) >= 50) and
          (round(event.button.y / (RealScreen.h / screen.h)) < max * 22 + 78) then
        begin
          menup := menu;
          menu := (round(event.button.y / (RealScreen.h / screen.h)) - 52) div 22;
          if menu > max then
            menu := max;
          if menu < 0 then
            menu := 0;
          if menup <> menu then
            showmagicmenu(menustatus, menu, max);
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
      if (menustatus and (1 shl i)) > 0 then
      begin
        p := p + 1;
        if p > menu then
          break;
      end;
    end;
    Result := i;
  end;
  SDL_EnableKeyRepeat(30, 35);
end;

//显示武功选单

procedure ShowMagicMenu(menustatus, menu, max: integer);
var
  i, p: integer;
begin
  redraw;
  DrawRectangle(100, 50, 167, max * 22 + 28, 0, colcolor(255), 30);
  p := 0;
  for i := 0 to 9 do
  begin
    if (p = menu) and ((menustatus and (1 shl i) > 0)) then
    begin
      drawshadowtext(@menustring[i][1], 83, 53 + 22 * p, colcolor($64), colcolor($66));
      drawengshadowtext(@menuengstring[i][1], 223, 53 + 22 * p, colcolor($64), colcolor($66));
      p := p + 1;
    end
    else if (p <> menu) and ((menustatus and (1 shl i) > 0)) then
    begin
      drawshadowtext(@menustring[i][1], 83, 53 + 22 * p, colcolor($21), colcolor($23));
      drawengshadowtext(@menuengstring[i][1], 223, 53 + 22 * p, colcolor($21), colcolor($23));
      p := p + 1;
    end;
  end;
  SDL_UpdateRect2(screen, 0, 0, screen.w, screen.h);

end;

//设定攻击范围
//使用比较复杂但是高效的方式重写，主要是为AI计算也可使用

procedure SetAminationPosition(mode, step, range: integer); overload;
begin
  SetAminationPosition(Bx, By, Ax, Ay, mode, step, range);
end;

procedure SetAminationPosition(Bx, By, Ax, Ay, mode, step, range: integer; play: integer = 0); overload;
var
  i, i1, i2, dis0, dis, Ax1, Ay1, step1: integer;
begin
  FillChar(Bfield[4, 0, 0], 4096 * 2, 0);
  //按攻击类型判断是否在范围内
  case mode of
    0, 6: //目标系点型、目标系十型、目标系菱型、原地系菱型、远程
    begin
      dis := range;
      for i1 := max(Ax - dis, 0) to min(Ax + dis, 63) do
      begin
        dis0 := abs(i1 - Ax);
        for i2 := max(Ay - dis + dis0, 0) to min(Ay + dis - dis0, 63) do
        begin
          Bfield[4, i1, i2] := abs(i1 - Bx) + abs(i2 - By) * 2+1;
        end;
      end;
      //if (abs(i1 - Ax) + abs(i2 - Ay)) <= range then
      //Bfield[4, i1, i2] := 1;
    end;
    3: //目标系方型、原地系方型
    begin
      for i1 := max(Ax - range, 0) to min(Ax + range, 63) do
        for i2 := max(Ay - range, 0) to min(Ay + range, 63) do
          Bfield[4, i1, i2] := abs(i1 - Bx) + abs(i2 - By) * 2 + random(24)+1;
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
        Bfield[4, Bx + i1 * i, By + i2 * i] := i * 2+1;
        i := i + 1;
      end;
    end;
    2: //原地系十型、原地系叉型、原地系米型
    begin
      for i1 := max(Bx - step, 0) to min(Bx + step, 63) do
        Bfield[4, i1, By] := abs(i1 - Bx) * 4;
      for i2 := max(By - step, 0) to min(By + step, 63) do
        Bfield[4, Bx, i2] := abs(i2 - By) * 4;
      for i := 1 to range do
      begin
        i1 := -i;
        while i1 <= i do
        begin
          i2 := -i;
          while i2 <= i do
          begin
            if (Bx + i1 in [0.. 63]) and (By + i2 in [0.. 63]) then
              Bfield[4, Bx + i1, By + i2] := 2 * i * 2+1;
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
            Bfield[4, i1, i2] := abs(i1 - Bx) + abs(i2 - By) * 2+1;
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
          if (i1 in [0.. 63]) and (i2 in [0.. 63]) and (abs(i1 - Bx) <= step) and (abs(i2 - By) <= step) then
            Bfield[4, i1, i2] := abs(i1 - Bx) + abs(i2 - By) * 2+1;
        end;
      end;
      //Bfield[4, Bx, By] := 0;
    end;
    7: //啥东西？
    begin
      if ((Ax = Bx) and (i2 = Ay) and (abs(i1 - Ax) <= step)) or ((Ay = By) and (i1 = Ax) and
        (abs(i2 - Ay) <= step)) then
        Bfield[4, i1, i2] := 1;
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

procedure PlayMagicAmination(bnum, enum: integer);
var
  beginpic, i, i1, i2, endpic, x, y, z, min, max: integer;
  posA, posB: TPosition;
begin
  min := 1000;
  max := 0;
  for i1 := 0 to 63 do
    for i2 := 0 to 63 do
    begin
      if Bfield[4, i1, i2] > 0 then
      begin
        if Bfield[4, i1, i2] > max then
          max := Bfield[4, i1, i2];
        if Bfield[4, i1, i2] < min then
          min := Bfield[4, i1, i2];
      end;
    end;

  beginpic := 0;
  //含音效
  posA := getpositiononscreen(Ax, Ay, CENTER_X, CENTER_Y);
  posB := getpositiononscreen(Bx, By, CENTER_X, CENTER_Y);
  x := posA.x - posB.x;
  y := posB.y - posA.y;
  z := -((Ax + Ay) - (Bx + By)) * 9;

  playsound(enum, 0, x, y, z);
  for i := 0 to enum - 1 do
    beginpic := beginpic + effectlist[i];
  endpic := beginpic + effectlist[enum] - 1;

  i := beginpic;
  while (SDL_PollEvent(@event) >= 0) do
  begin
    CheckBasicEvent;
    DrawBFieldWithEft(i, beginpic, endpic, min);
    //DrawBFieldWithEft(i);
    SDL_UpdateRect2(screen, 0, 0, screen.w, screen.h);
    sdl_delay(BATTLE_SPEED);
    i := i + 1;
    if i > endpic + max - min then
      break;
    //writeln(k);
  end;
  event.key.keysym.sym := 0;
  event.button.button := 0;
end;

//判断是否有非行动方角色在攻击范围之内

procedure CalHurtRole(bnum, mnum, level: integer; mode: integer = 0);
var
  i, rnum, hurt, addpoi, mp, hurt1: integer;
  k, j, s, temp, i1, neinum, neilevel: integer;
begin
  rnum := brole[bnum].rnum;
  rrole[rnum].PhyPower := rrole[rnum].PhyPower - 3;
  if RRole[rnum].CurrentMP < rmagic[mnum].NeedMP * ((level + 1) div 2) then
    level := RRole[rnum].CurrentMP div rmagic[mnum].NeedMP * 2;
  if level > 10 then
    level := 10;

  //消耗内力
  RRole[rnum].CurrentMP := RRole[rnum].CurrentMP - rmagic[mnum].NeedMP * ((level + 1) div 2);

  //消耗体力
  //RRole[rnum].PhyPower := RRole[rnum].PhyPower - rmagic[mnum].NeedMP div 2;
  RRole[rnum].PhyPower := RRole[rnum].PhyPower - 3;
  if RRole[rnum].PhyPower < 0 then
    RRole[rnum].PhyPower := 0;

  //消耗自身生命
  RRole[rnum].CurrentHP := RRole[rnum].CurrentHP - rmagic[mnum].UnKnow[0] * ((level + 1) div 2);
  if RRole[rnum].CurrentHP < 0 then
    RRole[rnum].CurrentHP := 0;
  if RRole[rnum].CurrentHP > RRole[rnum].MaxHP then
    RRole[rnum].CurrentHP := RRole[rnum].MaxHP;
  for i := 0 to broleamount - 1 do
  begin
    if (Bfield[4, Brole[i].X, Brole[i].Y] > 0) and (Brole[bnum].Team <> Brole[i].Team) and
      (Brole[i].Dead = 0) and (bnum <> i) then
    begin
      Brole[i].ShowNumber := -1;
      //生命伤害
      if (rmagic[mnum].HurtType = 0) or (rmagic[mnum].HurtType = 6) then
      begin
        hurt := CalHurtValue(bnum, i, mnum, level, mode);

        //以下是状态影响最终伤害的处理, 主要是守方的被动状态
        //4 受伤害增加或减少
        hurt := (100 - brole[i].StateLevel[4]) * hurt div 100;
        Brole[i].ShowNumber := hurt;

        //15，靈精，内力代替
        if random(100) < brole[i].StateLevel[15] then
        begin
          Rrole[Brole[i].rnum].CurrentMP := Rrole[Brole[i].rnum].CurrentMP - hurt;
          if Rrole[Brole[i].rnum].CurrentMP <= 0 then
            Rrole[Brole[i].rnum].CurrentMP := 0;
          //Rrole[Brole[i].rnum].Hurt := Rrole[Brole[i].rnum].Hurt + hurt div LIFE_HURT;
          Brole[i].ShowNumber := hurt;
          hurt := 0;
        end;


        //16 奇门，不受伤
        temp := random(100);
        if temp < brole[i].StateLevel[16] then
        begin
          //Rrole[Brole[i].rnum].CurrentHP := Rrole[Brole[i].rnum].CurrentHP - hurt;
          hurt := 1;
          Brole[i].ShowNumber := hurt;
        end;


        //14 乾坤，反弹
        if brole[i].Statelevel[14] > 0 then
        begin
          hurt1 := hurt * brole[i].StateLevel[14] div 100;
          hurt := hurt - hurt1;
          Brole[i].ShowNumber := hurt;
          Brole[bnum].ShowNumber := hurt1;
          Rrole[Brole[bnum].rnum].CurrentHP := Rrole[Brole[bnum].rnum].CurrentHP - hurt1;
          Bfield[4, Brole[bnum].X, Brole[bnum].Y] := 1;
        end;

        //吸星融功法
        for i1 := 0 to 3 do
        begin
          neinum := Rrole[Brole[i].rnum].neigong[i1];
          if neinum <= 0 then break;
          if rmagic[neinum].AddMP[3] > 0 then
          begin
            hurt := hurt div 2;
            Rrole[Brole[i].rnum].CurrentMP := Rrole[Brole[i].rnum].CurrentMP + hurt;
            if mode = 1 then
              showstringonbrole(big5tounicode(@rmagic[neinum].Name) + '·融功', i, 1);
            if Rrole[Brole[i].rnum].CurrentMP > Rrole[Brole[i].rnum].MaxMP then
            Rrole[Brole[i].rnum].CurrentMP := Rrole[Brole[i].rnum].MaxMP;
          end;
        end;

        if (brole[i].loverlevel[6] > 0) and (brole[brole[i].loverlevel[6]].dead = 0) then
        begin
          //情侣，替代受伤
          Brole[brole[i].loverlevel[6]].ShowNumber := hurt;
          Rrole[brole[i].loverlevel[6]].CurrentHP := Rrole[brole[i].loverlevel[6]].CurrentHP - hurt;
          //if Rrole[brole[i].loverlevel[6]].CurrentHP<0 then Rrole[brole[i].loverlevel[6]].CurrentHP:=0;
        end
        else
        begin
          //慈悲状态，替代减血
          if brole[i].StateLevel[23] > 0 then
          begin
            Brole[brole[i].StateLevel[23]].ShowNumber := hurt;
            Bfield[4, brole[brole[i].StateLevel[23]].X, brole[brole[i].StateLevel[23]].Y] := 1;
            Bfield[4, brole[i].X, brole[i].Y] := 0;
            Rrole[Brole[brole[i].StateLevel[23]].rnum].CurrentHP :=
              Rrole[Brole[brole[i].StateLevel[23]].rnum].CurrentHP - hurt;
            //受伤
            Rrole[Brole[brole[i].StateLevel[23]].rnum].Hurt :=
              Rrole[Brole[brole[i].StateLevel[23]].rnum].Hurt + hurt * 100 div
              Rrole[Brole[brole[i].StateLevel[23]].rnum].MAXHP div LIFE_HURT;
          end
          else
          begin
            //内功影响，减血同时减体、减内，伤害转内力
            for i1 := 0 to 3 do
            begin
              neinum := Rrole[Brole[bnum].rnum].neigong[i1];
              if neinum <= 0 then
                break;
              neilevel := Rrole[Brole[bnum].rnum].NGLevel[i1] div 100 + 1;
              if rmagic[neinum].AttDistance[6] > 0 then
              begin
                rrole[brole[i].rnum].PhyPower :=
                  rrole[brole[i].rnum].PhyPower - rmagic[neinum].AttDistance[6] * neilevel;
                if mode = 1 then
                  showstringonbrole(big5tounicode(@rmagic[neinum].Name) + '·减体', i, 2);
                if rrole[brole[i].rnum].PhyPower < 1 then
                  rrole[brole[i].rnum].PhyPower := 1;
              end;
              if rmagic[neinum].AttDistance[8] > 0 then
              begin
                rrole[brole[i].rnum].CurrentMP :=
                  rrole[brole[i].rnum].CurrentMP - rmagic[neinum].AttDistance[8] * neilevel;
                if mode = 1 then
                  showstringonbrole(big5tounicode(@rmagic[neinum].Name) + '·杀内', i, 1);
                if rrole[brole[i].rnum].CurrentMP < 1 then
                  rrole[brole[i].rnum].CurrentMP := 1;
              end;
              if rmagic[neinum].AddMP[2] = 4 then
              begin //龙卷罡气，重伤
                rrole[brole[i].rnum].Hurt :=
                  rrole[brole[i].rnum].Hurt + 3 * neilevel;
                if mode = 1 then
                  showstringonbrole(big5tounicode(@rmagic[neinum].Name) + '·重伤', i, 1);
                if rrole[brole[i].rnum].Hurt > 100 then
                  rrole[brole[i].rnum].CurrentMP := 100;
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
        //出手一次，获得1到10的经验值
        Brole[bnum].ExpGot := Brole[bnum].ExpGot + 1 + random(10);
        //if Rrole[Brole[i].rnum].CurrentHP <= 0 then Brole[bnum].ExpGot := Brole[bnum].ExpGot + hurt div 2;
        //把敌人打死获得30到50的经验值
        if Rrole[Brole[i].rnum].CurrentHP <= 0 then
        begin
          Rrole[Brole[i].rnum].CurrentHP := 0;
          Brole[bnum].ExpGot := Brole[bnum].ExpGot + 30 + random(20);
        end;
      end;
      //内力伤害
      if (rmagic[mnum].HurtType = 1) or (rmagic[mnum].HurtType = 6) then
      begin
        hurt := rmagic[mnum].HurtMP[level - 1] + random(5) - random(5);
        Brole[i].ShowNumber := hurt;
        Rrole[Brole[i].rnum].CurrentMP := Rrole[Brole[i].rnum].CurrentMP - hurt;
        if Rrole[Brole[i].rnum].CurrentMP <= 0 then
          Rrole[Brole[i].rnum].CurrentMP := 0;
        //增加己方内力及最大值
        RRole[rnum].CurrentMP := RRole[rnum].CurrentMP + hurt;
        RRole[rnum].MaxMP := RRole[rnum].MaxMP + random(hurt div 2);
        if RRole[rnum].MaxMP > MAX_MP then
          RRole[rnum].MaxMP := MAX_MP;
        if RRole[rnum].CurrentMP > RRole[rnum].MaxMP then
          RRole[rnum].CurrentMP := RRole[rnum].MaxMP;
      end;
      //中毒
      addpoi := rrole[rnum].AttPoi div 5 + rmagic[mnum].Poision * level div 2 - rrole[Brole[i].rnum].DefPoi;
      if (rmagic[mnum].AttAreaType = 6) and (brole[i].Statelevel[11] > 0) then
        addpoi := addpoi + brole[i].Statelevel[11]; //毒箭状态
      if addpoi + rrole[Brole[i].rnum].Poision > 99 then
        addpoi := 99 - rrole[Brole[i].rnum].Poision;
      if addpoi < 0 then
        addpoi := 0;
      if rrole[Brole[i].rnum].DefPoi >= 99 then
        addpoi := 0;
      rrole[Brole[i].rnum].Poision := rrole[Brole[i].rnum].Poision + addpoi;
    end;

    //状态类特技
    //AddMP，0=适用目标（0范围内敌方，1范围内我方，2敌方全体，3我方全体；4自身；5范围内全部；6全部；7空地），1-5=对应状态
    //Attack，各级威力（0,1状态1；2,3状态2；4,5状态3；6,7状态4；8,9状态5）
    //HurtMP，各级持续回合数
    if (Bfield[4, Brole[i].X, Brole[i].Y] > 0) and (Brole[i].Dead = 0) then
    begin
      if (rmagic[mnum].HurtType = 2) then
      begin
        hurt := 0;
        case rmagic[mnum].AddMP[0] of
          0: if brole[bnum].Team <> brole[i].Team then
              hurt := 1;
          1: if brole[bnum].Team = brole[i].Team then
              hurt := 1;
          4: if bnum = i then
              hurt := 1;
        end;
        if hurt = 1 then
        begin
          s := 1;
          while (s <= 5) and (rmagic[mnum].AddMP[s] >= 0) do
          begin
            k := brole[i].statelevel[rmagic[mnum].AddMP[s]];
            j := rmagic[mnum].Attack[(s - 1) * 2] + ((rmagic[mnum].Attack[(s - 1) * 2 + 1] -
              rmagic[mnum].Attack[(s - 1) * 2]) * (level - 1) div 9);

            //慈悲
            if rmagic[mnum].AddMP[s] = 23 then
            begin
              brole[i].StateLevel[rmagic[mnum].AddMP[s]] := bnum;
              brole[i].StateRound[rmagic[mnum].AddMP[s]] := rmagic[mnum].HurtMP[level - 1];
            end
            else
            //定身状态
            if (rmagic[mnum].AddMP[s] = 26) then
            begin
              if random(100) < j then
              begin
                brole[i].StateLevel[rmagic[mnum].AddMP[s]] := -1;
                brole[i].StateRound[rmagic[mnum].AddMP[s]] := rmagic[mnum].HurtMP[level - 1];
              end;
            end
            else
            begin
              if K * j <= 0 then
              begin
                brole[i].StateLevel[rmagic[mnum].AddMP[s]] := j;
                brole[i].StateRound[rmagic[mnum].AddMP[s]] := rmagic[mnum].HurtMP[level - 1];
              end
              else
              begin
                if abs(k) < abs(j) then
                  brole[i].StateLevel[rmagic[mnum].AddMP[s]] := j;

                if rmagic[mnum].HurtMP[level - 1] > brole[i].StateRound[rmagic[mnum].AddMP[s]] then
                  brole[i].StateRound[rmagic[mnum].AddMP[s]] := rmagic[mnum].HurtMP[level - 1];
              end;
            end;

            s := s + 1;
          end;
        end;
        //  showmessage(inttostr(brole[i].State));
      end;
    end;
  end;
end;

//计算伤害值, 第一公式如小于0则取一个随机数, 无第二公式

function CalHurtValue(bnum1, bnum2, mnum, level: integer; mode: integer = 0): integer;
var
  i, j, rnum1, rnum2, mhurt, R1Att, R1Def, R2Att, R2Def, att, def, k1, k2, dis, neinum, neilevel, livenum: integer;
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
  R1Att := R1.Attack * (100 + b1.statelevel[0] + b1.loverlevel[0]) div 100;
  R2Def := R2.Defence * (100 + b2.StateLevel[1] + b2.loverLevel[1]) div 100;

  //如果有武器, 增加攻击, 检查配合列表
  if r1.Equip[0] >= 0 then
  begin
    R1att := R1att + ritem[r1.Equip[0]].AddAttack;
    for i := 0 to MAX_WEAPON_MATCH - 1 do
    begin
      if (matchlist[i, 0] = 0) then
        break;
      if (r1.Equip[0] = matchlist[i, 0]) and (mnum = matchlist[i, 1]) then
      begin
        R1att := R1att + matchlist[i, 2] * 2 div 3;
        break;
      end;
    end;
  end;
  //防具增加攻击
  if r1.Equip[1] >= 0 then
    R1att := R1att + ritem[r1.Equip[1]].AddAttack;
  //武器, 防具增加防御
  if r2.Equip[0] >= 0 then
    R2def := R2def + ritem[r2.Equip[0]].AddDefence;
  if r2.Equip[1] >= 0 then
    R2def := R2def + ritem[r2.Equip[1]].AddDefence;

  //9号状态，孤注，随生命减少而攻击增加
  if b1.StateLevel[9] > 0 then
  begin
    R1Att := R1Att * (r1.MaxHP * 2 - r1.CurrentHP) div r1.MaxHP;
  end;

  //计算双方武学常识
  k1 := 0;
  k2 := 0;
  for i := 0 to broleamount - 1 do
  begin
    if (Brole[i].Team = brole[bnum1].Team) and (Brole[i].Dead = 0) and
      (rrole[Brole[i].rnum].Knowledge > MIN_KNOWLEDGE) then
      k1 := k1 + rrole[Brole[i].rnum].Knowledge;
    if (Brole[i].Team = brole[bnum2].Team) and (Brole[i].Dead = 0) and
      (rrole[Brole[i].rnum].Knowledge > MIN_KNOWLEDGE) then
      k2 := k2 + rrole[Brole[i].rnum].Knowledge;
  end;

  //10号状态，倾国
  for i := 0 to broleamount - 1 do
  begin
    if (brole[i].Dead = 0) and (brole[i].StateLevel[10] > 0) then
      if brole[i].Team = b1.Team then
        k1 := k1 + brole[i].StateLevel[10]
      else if brole[i].Team = b2.Team then
        k2 := k2 + brole[i].StateLevel[10];
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
    neinum := Rrole[brole[bnum1].rnum].neigong[i];
    if neinum <= 0 then
      break;
    neilevel := Rrole[brole[bnum1].rnum].NGLevel[i] div 100 + 1;
    if ((Rmagic[neinum].MoveDistance[0] = 6) or (Rmagic[neinum].MoveDistance[0] = rmagic[mnum].MagicType)) and
      (Rmagic[neinum].MoveDistance[1] >= Rmagic[mnum].attack[1] div 100) then
      if (100 + Rmagic[neinum].movedistance[2] + (Rmagic[neinum].movedistance[3] - Rmagic[neinum].movedistance[2]) *
        neilevel / 10) / 100 > p then
      begin
        p := (100 + Rmagic[neinum].movedistance[2] + (Rmagic[neinum].movedistance[3] -
          Rmagic[neinum].movedistance[2]) * neilevel / 10) / 100;
      end;

    //特定武功加成
    if Rmagic[neinum].AttDistance[4] = mnum then
    begin
      p2 := 1 + 0.1 * neilevel;
    end;

    //资质对武功加成，段家心法
    if Rmagic[neinum].AttDistance[7] > 0 then
    begin
      p3 := (Rmagic[neinum].AttDistance[7] * rrole[rnum1].Aptitude) / 100;
    end;

    //我方剩余人数加成，神龙吟
    if Rmagic[neinum].AttDistance[9] > 0 then
    begin
      livenum := 0;
      for j := 0 to broleamount - 1 do
        if (brole[j].Team = B1.Team) and (brole[j].Dead = 0) then
          livenum := livenum + 1;
      p4 := 1 + livenum * 0.05 * Rmagic[neinum].AttDistance[9];
    end;

  end;
  mhurt := trunc(mhurt * p * p2 * p3 * p4);  //数据设好之后恢复此句
  //mhurt := trunc(mhurt * p);

  //情侣技影响武功伤害
  if brole[bnum1].loverlevel[4] > 0 then
    mhurt := mhurt * (100 + brole[bnum1].loverlevel[4]) div 100;

  //轻功加成
  if Rmagic[mnum].attack[3] > 0 then
  begin
    p := (R1.Speed * (b1.statelevel[2] + Rmagic[mnum].attack[3]) / 100 / 500) + 1;
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
  if Rmagic[mnum].attack[2] > 0 then
  begin
    p := (R1.MaxMP * (Rmagic[mnum].attack[2] + brole[bnum1].loverlevel[5]) / 100 / 9999) + 1;
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
  if (Rmagic[mnum].Data[9] > 0) then
    att := k1 * 2 + R1.HidWeapon * 4 + mhurt
  else
    att := k1 * 2 + R1Att * 2 + mhurt;

  //总防御
  def := R2Def * 2;
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
        showstringonbrole(big5tounicode(@rmagic[neinum].Name) + '·刚体', bnum2, 3);
    end;
  end;

  //武常影响防御
  def := def + k2 * 2;

  //攻击, 防御按受伤的折扣
  att := att * (100 - Rrole[rnum1].Hurt div 2) div 100;
  def := def * (100 - Rrole[rnum2].Hurt div 2) div 100;

  //showmessage(inttostr(att)+' '+inttostr(def));

  //总公式
  //result := (att - def) *2 div 3 + random(20) - random(20);
  Result := trunc((1.0 * att * att) / (att + def) / 4 + random(20) - random(20));
  //result := ( att * att ) div ( att + def ) div 4;

  //距离衰减
  dis := abs(b1.X - b2.X) + abs(b1.Y - b2.Y);
  if dis > 10 then
    dis := 10;
  Result := Result * (100 - (dis - 1) * 3) div 100;

  //轻功闪避
  if (R2.Speed >= R1.Speed) then
  begin
    p := 1 - ((R2.Speed - R1.Speed) / 360);
    if (p < 0) then
      p := 0;
    Result := trunc(Result * p);
  end;

  if (Result <= 0) or (level <= 0) then
    Result := random(10) + 1;
  if (Result > 9999) then
    Result := 9999;
  //if (r2.CurrentHP - result < 0) then result := r2.CurrentHP;
  //showmessage(inttostr(result));
  x50[28004] := Result;
  x50[28001] := bnum1;
  x50[28002] := mnum;
  x50[28003] := rnum2;
  //CallEvent(401);
  Result := x50[28004];

end;

function CalHurtValue2(bnum1, bnum2, mnum, level: integer; mode: integer = 0): integer;
begin
  Result := CalHurtValue(bnum1, bnum2, mnum, level, mode);
  if Result >= Rrole[Brole[bnum2].rnum].CurrentHP then
    Result := Result * 3 div 2;
end;

//0: red. 1: purple, 2: green
//显示数字

procedure ShowHurtValue(mode: integer; team: integer = 0);
var
  i, i1, x, y: integer;
  color1, color2: uint32;
  word: array of WideString;
  str: string;
begin
  case mode of
    0, 6: //伤血
    begin
      color1 := colcolor($10);
      color2 := colcolor($13);
      str := '-%d';
    end;
    1: //伤内
    begin
      color1 := colcolor($50);
      color2 := colcolor($53);
      str := '-%d';
    end;
    2: //中毒
    begin
      color1 := colcolor($30);
      color2 := colcolor($32);
      str := '+%d';
    end;
    3: //医疗
    begin
      color1 := colcolor($7);
      color2 := colcolor($5);
      str := '+%d';
    end;
    4: //解毒
    begin
      color1 := colcolor($91);
      color2 := colcolor($93);
      str := '-%d';
    end;
  end;
  setlength(word, broleamount);
  for i := 0 to broleamount - 1 do
  begin
    if Brole[i].ShowNumber > 0 then
    begin
      if mode = 5 then //先天一阳指，我方加血，敌方减血
        if brole[i].Team = team then
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
    redraw;
    for i := 0 to broleamount - 1 do
    begin
      if mode = 5 then //先天一阳指，我方加血，敌方减血
        if brole[i].Team = team then
        begin
          color1 := colcolor($7);
          color2 := colcolor($5);
        end
        else
        begin
          color1 := colcolor($10);
          color2 := colcolor($13);
        end;
      x := -(Brole[i].X - Bx) * 18 + (Brole[i].Y - By) * 18 + CENTER_X - 10;
      y := (Brole[i].X - Bx) * 9 + (Brole[i].Y - By) * 9 + CENTER_Y - 40;
      drawengshadowtext(@word[i, 1], x, y - i1 * 2, color1, color2);
    end;
    sdl_delay(BATTLE_SPEED);
    SDL_UpdateRect2(screen, 0, 0, screen.w, screen.h);
    i1 := i1 + 1;
    if i1 > 10 then
      break;
  end;
  redraw;

end;


procedure ShowStringOnBrole(str: WideString; bnum, mode: integer);
var
  len, i1, x, y: integer;
  color1, color2: uint32;
  formatstr: string;
  p: puint16;
begin
  if EFFECT_STRING = 1 then
  begin
    TTF_CloseFont(font);
    font := TTF_OpenFont(CHINESE_FONT, 15);
    case mode of
      0, 6: //伤血
      begin
        color1 := colcolor($ff);
        color2 := colcolor($fe);
        formatstr := '-%d';
      end;
      1: //伤内
      begin
        color1 := colcolor($50);
        color2 := colcolor($53);
        formatstr := '-%d';
      end;
      2: //中毒
      begin
        color1 := colcolor($30);
        color2 := colcolor($32);
        formatstr := '+%d';
      end;
      3: //医疗
      begin
        color1 := colcolor($7);
        color2 := colcolor($5);
        color1 := $FFFFFFFF;
        color2 := $FFFFFFFF;
        formatstr := '+%d';
      end;
      4: //解毒
      begin
        color1 := colcolor($91);
        color2 := colcolor($93);
        formatstr := '-%d';
      end;
    end;

    len := 0;
    p := @str[1];
    for i1 := 0 to length(pwidechar(str)) - 1 do
    begin
      if p^ > 255 then
        len := len + 2
      else
        len := len + 1;
      Inc(p);
    end;

    x := -(Brole[bnum].X - Bx) * 18 + (Brole[bnum].Y - By) * 18 + CENTER_X - 10;
    y := (Brole[bnum].X - Bx) * 9 + (Brole[bnum].Y - By) * 9 + CENTER_Y - 40;
    i1 := 0;
    while SDL_PollEvent(@event) >= 0 do
    begin
      CheckBasicEvent;
      redraw;
      drawshadowtext(@str[1], x - 5 * len, y - i1 * 2, color1, color2);
      sdl_delay(BATTLE_SPEED);
      SDL_UpdateRect2(screen, 0, 0, screen.w, screen.h);
      i1 := i1 + 1;
      if i1 > 10 then
        break;
    end;
    redraw;
    TTF_CloseFont(font);
    font := TTF_OpenFont(CHINESE_FONT, CHINESE_FONT_SIZE);
  end;
end;


//计算中毒减少的生命

procedure CalPoiHurtLife;
var
  i: integer;
  p: boolean;
begin
  p := False;
  for i := 0 to broleamount - 1 do
  begin
    Brole[i].ShowNumber := -1;
    if (Rrole[Brole[i].rnum].Poision > 0) and (Brole[i].Dead = 0) and (Brole[i].Acted = 1) then
    begin
      Rrole[Brole[i].rnum].CurrentHP := Rrole[Brole[i].rnum].CurrentHP - Rrole[Brole[i].rnum].Poision - 5 + random(5);
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
  i, j: integer;
begin
  for i := 0 to broleamount - 1 do
  begin
    if Rrole[Brole[i].rnum].CurrentHP <= 0 then
    begin
      Brole[i].Dead := 1;
      bfield[2, Brole[i].X, Brole[i].Y] := -1;

      //伤逝状态
      if brole[i].StateLevel[21] > 0 then
      begin
        for j := 0 to broleamount - 1 do
        begin
          if (brole[j].Team <> brole[i].team) and (brole[j].Dead = 0) then
          begin
            if brole[j].StateLevel[0] < 0 then
              brole[j].StateRound[0] := brole[j].StateRound[0] + 3
            else
            begin
              brole[j].StateLevel[0] := -10;
              brole[j].StateRound[0] := 3;
            end;
            if brole[j].StateLevel[1] < 0 then
              brole[j].StateRound[1] := brole[j].StateRound[1] + 3
            else
            begin
              brole[j].StateLevel[1] := -10;
              brole[j].StateRound[1] := 3;
            end;
            rrole[brole[j].rnum].Hurt := rrole[brole[j].rnum].Hurt + 10;
          end;
        end;
      end;

      //去掉慈悲状态
      for j := 0 to broleamount - 1 do
        if brole[j].StateLevel[23] = brole[i].rnum then
        begin
          brole[j].StateLevel[23] := 0;
          brole[j].StateRound[23] := 0;
        end;

      //bmount
    end;
  end;
  for i := 0 to broleamount - 1 do
    if Brole[i].Dead = 0 then
      bfield[2, Brole[i].X, Brole[i].Y] := i;

end;

//显示简单状态(x, y表示位置)

procedure ShowSimpleStatus(rnum, x, y: integer);
var
  i, magicnum: integer;
  p: array[0..10] of integer;
  str: WideString;
  strs: array[0..3] of WideString;
  strs1: array[1..17] of WideString;
  color1, color2: uint32;
begin
  strs[0] := ' 等級';
  strs[1] := ' 生命';
  strs[2] := ' 內力';
  strs[3] := ' 體力';

  DrawRectangle(x, y, 145, 203, 0, colcolor(255), 30);
  drawheadpic(Rrole[rnum].HeadNum, x + 50, y + 82);
  str := big5tounicode(@rrole[rnum].Name);
  drawshadowtext(@str[1], x + 60 - length(PChar(@rrole[rnum].Name)) * 5, y + 95, colcolor($64), colcolor($66));
  for i := 0 to 3 do
    drawshadowtext(@strs[i, 1], x - 17, y + 86 + 30 + 21 * i, colcolor($21), colcolor($23));

  str := format('%9d', [Rrole[rnum].Level]);
  drawengshadowtext(@str[1], x + 50, y + 30 + 86, colcolor(5), colcolor(7));

  case RRole[rnum].Hurt of
    34..66:
    begin
      color1 := colcolor($10);
      color2 := colcolor($E);
    end;
    67..1000:
    begin
      color1 := colcolor($14);
      color2 := colcolor($16);
    end;
    else
    begin
      color1 := colcolor($5);
      color2 := colcolor($7);
    end;
  end;
  str := format('%4d', [RRole[rnum].CurrentHP]);
  drawengshadowtext(@str[1], x + 50, y + 107 + 30, color1, color2);

  str := '/';
  drawengshadowtext(@str[1], x + 90, y + 107 + 30, colcolor($64), colcolor($66));

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
  drawengshadowtext(@str[1], x + 100, y + 107 + 30, color1, color2);

  //str:=format('%4d/%4d', [Rrole[rnum,17],Rrole[rnum,18]]);
  //drawengshadowtext(@str[1],x+50,y+107,colcolor($7),colcolor($5));
  if rrole[rnum].MPType = 0 then
  begin
    color1 := colcolor($50);
    color2 := colcolor($4E);
  end
  else
  if rrole[rnum].MPType = 1 then
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
  drawengshadowtext(@str[1], x + 50, y + 128 + 30, color1, color2);
  str := format('%9d', [rrole[rnum].PhyPower]);
  drawengshadowtext(@str[1], x + 50, y + 149 + 30, colcolor(5), colcolor(7));
  {if Rrole[rnum].State in [1..17] then
  begin
    strs1[1] := ' 激昂';
    strs1[2] := ' 成城';
    strs1[3] := ' 倾国';
    strs1[4] := ' 战神';
    strs1[5] := ' 拼搏';
    strs1[6] := ' 慈悲';
    strs1[7] := ' 茫然';
    strs1[8] := ' 媚惑';
    strs1[9] := ' 爱怜';
    strs1[10] := ' 精怪';
    strs1[11] := ' 奇门';
    strs1[12] := ' 乾坤';
    strs1[13] := ' 柔情';
    strs1[14] := ' 破罩';
    strs1[15] := ' 左右';
    strs1[16] := ' 鸳鸯';
    strs1[17] := ' 神行';
    drawtextwithrect(@strs1[Rrole[rnum].State, 1], x + 5, y + 5, 47, colcolor($64), colcolor($66));
  end;}

  SDL_UpdateRect2(screen, 0, 0, screen.w, screen.h);

end;

//等待, 似乎不太完善

procedure Wait(bnum: integer);
var
  i, i1, i2, x: integer;
begin
  Brole[bnum].Acted := 0;
  Brole[BroleAmount] := Brole[bnum];

  for i := bnum to BRoleAmount - 1 do
    Brole[i] := Brole[i + 1];

  for i := 0 to BRoleAmount - 1 do
  begin
    if Brole[i].Dead = 0 then
      Bfield[2, Brole[i].X, Brole[i].Y] := i
    else
      Bfield[2, Brole[i].X, Brole[i].Y] := -1;
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
      Brole[i].Statelevel[j] := 0;
      Brole[i].Stateround[j] := 0;
    end;

    //我方恢复部分生命, 内力; 敌方恢复全部
    if Brole[i].Team = 0 then
    begin
      RRole[rnum].CurrentHP := RRole[rnum].CurrentHP + RRole[rnum].MaxHP div 2;
      if RRole[rnum].CurrentHP <= 0 then
        RRole[rnum].CurrentHP := 1;
      if RRole[rnum].CurrentHP > RRole[rnum].MaxHP then
        RRole[rnum].CurrentHP := RRole[rnum].MaxHP;
      RRole[rnum].CurrentMP := RRole[rnum].CurrentMP + RRole[rnum].MaxMP div 20;
      if RRole[rnum].CurrentMP > RRole[rnum].MaxMP then
        RRole[rnum].CurrentMP := RRole[rnum].MaxMP;
      rrole[rnum].PhyPower := rrole[rnum].PhyPower + MAX_PHYSICAL_POWER div 2;
      if rrole[rnum].PhyPower > MAX_PHYSICAL_POWER then
        rrole[rnum].PhyPower := MAX_PHYSICAL_POWER;
    end
    else
    begin
      RRole[rnum].Hurt := 0;
      RRole[rnum].Poision := 0;
      RRole[rnum].CurrentHP := RRole[rnum].MaxHP;
      RRole[rnum].CurrentMP := RRole[rnum].MaxMP;
      rrole[rnum].PhyPower := MAX_PHYSICAL_POWER * 9 div 10;
    end;
  end;

  //恢复0号人物的森罗万象
  rrole[0].Magic[0] := 278;

end;



//增加经验

procedure AddExp;
var
  i, mnum, mlevel, i1, i2, rnum, basicvalue, amount, levels: integer;

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
  for i := 0 to BRoleAmount - 1 do
  begin
    rnum := Brole[i].rnum;
    //amount := Calrnum(0);
    if amount > 0 then
      basicvalue := warsta.exp div amount
    else
      basicvalue := 0;

    //太岳四侠练功，20级以上不得经验
    if (Rrole[rnum].Level >= 20) and (warsta.BattleNum = 31) then
      basicvalue := 0;
    //桃谷六仙练功，40级以上不得经验
    if (Rrole[rnum].Level >= 40) and (warsta.BattleNum = 160) then
      basicvalue := 0;

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

      mlevel := 0;
      mnum := Ritem[Rrole[rnum].PracticeBook].Magic;
      if (mnum >= 116) and (mnum <= 130) then
        for i1 := 0 to 3 do
          if Rrole[rnum].neigong[i1] = mnum then
          begin
            mlevel := Rrole[rnum].NGLevel[i1] div 100 + 1;
            break;
          end
          else
          if mnum > 0 then
            for i2 := 0 to 9 do
              if Rrole[rnum].Magic[i2] = mnum then
              begin
                mlevel := Rrole[rnum].MagLevel[i2] div 100 + 1;
                break;
              end;

      basicvalue := basicvalue + Brole[i].ExpGot;
      Rrole[rnum].Exp := Rrole[rnum].Exp + basicvalue;

      if mlevel < 10 then
      begin
        Rrole[rnum].ExpForBook := Rrole[rnum].ExpForBook + basicvalue div 5 * 4;
      end;

      Rrole[rnum].ExpForItem := Rrole[rnum].ExpForItem + basicvalue div 5 * 3;
      ShowSimpleStatus(rnum, 100, 50);
      DrawRectangle(100, 265, 145, 25, 0, colcolor(255), 25);
      str := ' 得經驗';
      Drawshadowtext(@str[1], 83, 267, colcolor($21), colcolor($23));
      str := format('%5d', [basicvalue]);
      Drawengshadowtext(@str[1], 188, 267, colcolor($64), colcolor($66));
      SDL_UpdateRect2(screen, 0, 0, screen.w, screen.h);
      Redraw;
      waitanykey;
    end;

  end;

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
      Rrole[rnum].Level := Rrole[rnum].Level + 1;
      LevelUp(i);
    end;
  end;

end;

//升级, 如是我方人物显示状态

procedure LevelUp(bnum: integer);
var
  i, rnum, add, levelA: integer;
  str: WideString;
begin

  rnum := brole[bnum].rnum;
  if Rrole[rnum].IncLife >= 8 then
    RRole[rnum].MaxHP := RRole[rnum].MaxHP + (Rrole[rnum].IncLife - 8 + random(10)) * 3
  else
    RRole[rnum].MaxHP := RRole[rnum].MaxHP + Rrole[rnum].IncLife + random(5);
  if RRole[rnum].MaxHP > MAX_HP then
    RRole[rnum].MaxHP := MAX_HP;
  RRole[rnum].CurrentHP := RRole[rnum].MaxHP;

  if Rrole[rnum].AddMP >= 8 then
    RRole[rnum].MaxMP := RRole[rnum].MaxMP + (Rrole[rnum].AddMP - 8 + random(10)) * 3
  else
    RRole[rnum].MaxMP := RRole[rnum].MaxMP + Rrole[rnum].AddMP + random(5);
  if RRole[rnum].MaxMP > MAX_MP then
    RRole[rnum].MaxMP := MAX_MP;
  RRole[rnum].CurrentMP := RRole[rnum].MaxMP;

  RRole[rnum].Attack := RRole[rnum].Attack + 3 - random(2) + random(RRole[rnum].AddAtk);
  Rrole[rnum].Defence := Rrole[rnum].Defence + 3 - random(2) + random(RRole[rnum].AddDef);

  Rrole[rnum].Speed := Rrole[rnum].Speed + 1 + random(RRole[rnum].AddSpeed);

  for i := 46 to 54 do
  begin
    //抗毒不增加
    if (rrole[rnum].Data[i] > 20) and (i <> 49) then
      rrole[rnum].Data[i] := rrole[rnum].Data[i] + random(3);
  end;
  for i := 43 to 54 do
  begin
    if rrole[rnum].Data[i] > maxprolist[i] then
      rrole[rnum].Data[i] := maxprolist[i];
  end;

  RRole[rnum].PhyPower := MAX_PHYSICAL_POWER;
  RRole[rnum].Hurt := 0;
  RRole[rnum].Poision := 0;

  if Brole[bnum].Team = 0 then
  begin
    ShowStatus(rnum);
    str := ' 升級';
    Drawtextwithrect(@str[1], 50, CENTER_Y - 150, 46, colcolor($21), colcolor($23));
    waitanykey;
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
    if (inum >= 157) and (inum <= 171) then
    begin
      mlevel := 0;
      mnum := Ritem[inum].Magic;
      if mnum > 0 then
        for i1 := 0 to 3 do
          if Rrole[rnum].neigong[i1] = mnum then
          begin
            mlevel := Rrole[rnum].NGLevel[i1] div 100 + 1;
            break;
          end;
      while (mlevel < 10) do
      begin
        p := mlevel;
        if p = 0 then
          p := 1;
        needexp := trunc((1 + (p - 1) * 0.5) * Ritem[Rrole[rnum].PracticeBook].NeedExp *
          (1 + (7 - Rrole[rnum].Aptitude / 15) * 0.5));
        if (Rrole[rnum].ExpForBook >= needexp) and (mlevel < 10) then
        begin
          redraw;
          EatOneItem(rnum, inum);
          waitanykey;
          redraw;
          SDL_UpdateRect2(screen, 0, 0, screen.w, screen.h);
          if mnum > 0 then
          begin
            instruct_33(rnum, mnum, 1);
          end;
          mlevel := mlevel + 1;
          Rrole[rnum].ExpForBook := Rrole[rnum].ExpForBook - needexp;
          //ShowStatus(rnum);
          //waitanykey;
        end
        else
          break;
      end;
    end
    else
    if inum >= 0 then
    begin
      mlevel := 1;
      mnum := Ritem[inum].Magic;
      if mnum > 0 then
        for i1 := 0 to 9 do
          if Rrole[rnum].Magic[i1] = mnum then
          begin
            mlevel := Rrole[rnum].MagLevel[i1] div 100 + 1;
            break;
          end;
      while (mlevel < 10) do
      begin
        needexp := trunc((1 + (mlevel - 1) * 0.5) * Ritem[Rrole[rnum].PracticeBook].NeedExp *
          (1 + (7 - Rrole[rnum].Aptitude / 15) * 0.5));
        if (Rrole[rnum].ExpForBook >= needexp) and (mlevel < 10) then
        begin
          redraw;
          EatOneItem(rnum, inum);
          waitanykey;
          redraw;
          SDL_UpdateRect2(screen, 0, 0, screen.w, screen.h);
          if mnum > 0 then
          begin
            instruct_33(rnum, mnum, 1);
          end;
          mlevel := mlevel + 1;
          Rrole[rnum].ExpForBook := Rrole[rnum].ExpForBook - needexp;
          //ShowStatus(rnum);
          //waitanykey;
        end
        else
          break;
      end;
      //是否能够炼出物品
      if (Rrole[rnum].ExpForItem >= ritem[inum].NeedExpForItem) and (ritem[inum].NeedExpForItem > 0) and
        (Brole[i].Team = 0) then
      begin
        redraw;
        p := 0;
        for i2 := 0 to 4 do
        begin
          if ritem[inum].GetItem[i2] >= 0 then
            p := p + 1;
        end;
        p := random(p);
        needitem := ritem[inum].NeedMaterial;
        if ritem[inum].GetItem[p] >= 0 then
        begin
          needitemamount := ritem[inum].NeedMatAmount[p];
          itemamount := 0;
          for i2 := 0 to MAX_ITEM_AMOUNT - 1 do
            if RItemList[i2].Number = needitem then
            begin
              itemamount := RItemList[i2].Amount;
              break;
            end;
          if needitemamount <= itemamount then
          begin
            ShowSimpleStatus(rnum, 350, 50);
            DrawRectangle(115, 63, 145, 25, 0, colcolor(255), 25);
            str := ' 製得物品';
            Drawshadowtext(@str[1], 127, 65, colcolor($21), colcolor($23));

            instruct_2(ritem[inum].GetItem[p], 30 + random(25));
            instruct_32(needitem, -needitemamount);
            Rrole[rnum].ExpForItem := 0;
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
  for i := 0 to broleamount - 1 do
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
    rnum := brole[bnum].rnum;
    mode := Ritem[inum].ItemType;
    case mode of
      3:
      begin
        EatOneItem(rnum, inum);
        instruct_32(inum, -1);
        Brole[bnum].Acted := 1;
        waitanykey;
      end;
      //     4:
      //  begin
      //    UseHiddenWeapen(bnum, inum);
      //   end;
    end;
  end;

end;

//动作动画

procedure PlayActionAmination(bnum, mode: integer);
var
  d1, d2, dm, rnum, i, beginpic, endpic, idx, grp, tnum, len, Ax1, Ay1: integer;
  filename: string;
begin
  Ax1 := Ax;
  Ay1 := Ay;
  //方向至少朝向一个将被打中的敌人
  for i := 0 to BRoleAmount - 1 do
  begin
    if (Brole[i].Team <> Brole[bnum].Team) and (Brole[i].Dead = 0) and (Bfield[4, Brole[i].X, Brole[i].Y] > 0) then
    begin
      Ax1 := Brole[i].X;
      Ay1 := Brole[i].Y;
      break;
    end;
  end;
  d1 := Ax1 - Bx;
  d2 := Ay1 - By;
  dm := abs(d1) - abs(d2);
  if (d1 <> 0) or (d2 <> 0) then
    if (dm >= 0) then
      if d1 < 0 then
        Brole[bnum].Face := 0
      else
        Brole[bnum].Face := 3
    else
    if d2 < 0 then
      Brole[bnum].Face := 2
    else
      Brole[bnum].Face := 1;

  Redraw;
  rnum := brole[bnum].rnum;
  if rrole[rnum].AmiFrameNum[mode] > 0 then
  begin
    beginpic := 0;
    for i := 0 to 4 do
    begin
      if i >= mode then
        break;
      beginpic := beginpic + rrole[rnum].AmiFrameNum[i] * 4;
    end;
    beginpic := beginpic + Brole[bnum].Face * rrole[rnum].AmiFrameNum[mode];
    endpic := beginpic + rrole[rnum].AmiFrameNum[mode] - 1;

    filename := format('%3d', [rrole[rnum].HeadNum]);

    for i := 1 to length(filename) do
      if filename[i] = ' ' then
        filename[i] := '0';

    idx := fileopen('fight\fight' + filename + '.idx', fmopenread);
    grp := fileopen('fight\fight' + filename + '.grp', fmopenread);
    len := fileseek(grp, 0, 2);
    fileseek(grp, 0, 0);
    fileread(grp, FPic[0], len);
    tnum := fileseek(idx, 0, 2) div 4;
    fileseek(idx, 0, 0);
    fileread(idx, FIdx[0], tnum * 4);
    fileclose(grp);
    fileclose(idx);

    i := beginpic;
    while (SDL_PollEvent(@event) >= 0) do
    begin
      CheckBasicEvent;
      DrawBfieldWithAction(bnum, i);
      SDL_UpdateRect2(screen, 0, 0, screen.w, screen.h);
      sdl_delay(BATTLE_SPEED);
      i := i + 1;
      if i > endpic then
        break;
    end;
  end;

end;

//用毒

procedure UsePoision(bnum: integer);
var
  rnum, bnum1, rnum1, poi, step, addpoi: integer;
  select: boolean;
begin
  rnum := brole[bnum].rnum;
  poi := Rrole[rnum].UsePoi;
  step := poi div 15 + 1;
  calcanselect(bnum, 1, step);
  SelectAimMode := 0;
  if (Brole[bnum].Team = 0) and (brole[bnum].Auto = 0) then
    select := selectaim(bnum, step);
  if (bfield[2, Ax, Ay] >= 0) and (select = True) then
  begin
    Brole[bnum].Acted := 1;
    rrole[rnum].PhyPower := rrole[rnum].PhyPower - 3;
    bnum1 := bfield[2, Ax, Ay];
    if brole[bnum1].Team <> Brole[bnum].Team then
    begin
      rnum1 := brole[bnum1].rnum;
      addpoi := Rrole[rnum].UsePoi div 3 - rrole[rnum1].DefPoi div 4;
      if addpoi < 0 then
        addpoi := 0;
      if addpoi + rrole[rnum1].Poision > 99 then
        addpoi := 99 - rrole[rnum1].Poision;
      rrole[rnum1].Poision := rrole[rnum1].Poision + addpoi;
      brole[bnum1].ShowNumber := addpoi;
      Brole[bnum].ExpGot := Brole[bnum].ExpGot + addpoi div 5;
      SetAminationPosition(0, 0, 0);
      PlayActionAmination(bnum, 0);
      PlayMagicAmination(bnum, 30);

      ShowHurtValue(2);
    end;
  end;
end;

//医疗

procedure Medcine(bnum: integer);
var
  rnum, bnum1, rnum1, med, step, addlife: integer;
  select: boolean;
begin
  rnum := brole[bnum].rnum;
  med := Rrole[rnum].Medcine;
  step := med div 15 + 1;
  calcanselect(bnum, 1, step);
  SelectAimMode := 1;
  if (Brole[bnum].Team = 0) and (brole[bnum].Auto = 0) then
    select := selectaim(bnum, step)
  else
  begin
    Ax := Bx;
    Ay := By;
  end;
  if (bfield[2, Ax, Ay] >= 0) and (select = True) then
  begin
    Brole[bnum].Acted := 1;
    rrole[rnum].PhyPower := rrole[rnum].PhyPower - 4;
    bnum1 := bfield[2, Ax, Ay];
    if brole[bnum1].Team = Brole[bnum].Team then
    begin
      rnum1 := brole[bnum1].rnum;
      addlife := med * 3 - Rrole[rnum1].Hurt + random(10) - 5;
      if addlife < 0 then
        addlife := 0;
      //if Rrole[rnum1].Hurt - med > 20 then
      //  addlife := 0;
      //if Rrole[rnum1].Hurt > 66 then
      //  addlife := 0;

      if addlife + rrole[rnum1].CurrentHP > rrole[rnum1].MaxHP then
        addlife := rrole[rnum1].MaxHP - rrole[rnum1].CurrentHP;
      rrole[rnum1].CurrentHP := rrole[rnum1].CurrentHP + addlife;
      Rrole[rnum1].Hurt := Rrole[rnum1].Hurt - addlife div 10 div LIFE_HURT;
      if Rrole[rnum1].Hurt < 0 then
        Rrole[rnum1].Hurt := 0;
      Brole[bnum].ExpGot := Brole[bnum].ExpGot + addlife div 10;
      brole[bnum1].ShowNumber := addlife;
      SetAminationPosition(0, 0, 0);
      PlayActionAmination(bnum, 0);
      PlayMagicAmination(bnum, 0);
      ShowHurtValue(3);
    end;
  end;

end;

//解毒

procedure MedPoision(bnum: integer);
var
  rnum, bnum1, rnum1, medpoi, step, minuspoi: integer;
  select: boolean;
begin
  rnum := brole[bnum].rnum;
  medpoi := Rrole[rnum].MedPoi;
  step := medpoi div 15 + 1;
  calcanselect(bnum, 1, step);
  SelectAimMode := 1;
  if (Brole[bnum].Team = 0) and (brole[bnum].Auto = 0) then
    select := selectaim(bnum, step)
  else
  begin
    Ax := Bx;
    Ay := By;
  end;
  if (bfield[2, Ax, Ay] >= 0) and (select = True) then
  begin
    Brole[bnum].Acted := 1;
    rrole[rnum].PhyPower := rrole[rnum].PhyPower - 5;
    bnum1 := bfield[2, Ax, Ay];
    if brole[bnum1].Team = Brole[bnum].Team then
    begin
      rnum1 := brole[bnum1].rnum;
      minuspoi := Rrole[rnum].MedPoi;
      if minuspoi < 0 then
        minuspoi := 0;
      if rrole[rnum1].Poision - minuspoi <= 0 then
        minuspoi := rrole[rnum1].Poision;
      rrole[rnum1].Poision := rrole[rnum1].Poision - minuspoi;
      brole[bnum1].ShowNumber := minuspoi;
      Brole[bnum].ExpGot := Brole[bnum].ExpGot + minuspoi div 5;
      SetAminationPosition(0, 0, 0);
      PlayActionAmination(bnum, 0);
      PlayMagicAmination(bnum, 36);
      ShowHurtValue(4);
    end;
  end;

end;

//使用暗器

procedure UseHiddenWeapen(bnum, inum: integer);
var
  rnum, bnum1, rnum1, hidden, step, hurt: integer;
  select: boolean;
begin
  rnum := brole[bnum].rnum;
  hidden := rrole[rnum].HidWeapon;
  step := hidden div 15 + 1;
  calcanselect(bnum, 1, step);
  SelectAimMode := 0;
  if ritem[inum].UnKnow7 > 0 then
    callevent(ritem[inum].UnKnow7)
  else
  begin
    if (Brole[bnum].Team = 0) and (brole[bnum].Auto = 0) then
      select := selectaim(bnum, step);
    if (bfield[2, Ax, Ay] >= 0) and (select = True) and (brole[bfield[2, Ax, Ay]].Team <> 0) then
    begin
      Brole[bnum].Acted := 1;
      instruct_32(inum, -1);
      bnum1 := bfield[2, Ax, Ay];
      if brole[bnum1].Team <> Brole[bnum].Team then
      begin
        rnum1 := brole[bnum1].rnum;
        hurt := rrole[rnum].HidWeapon div 2 - ritem[inum].AddCurrentHP div 3;
        hurt := hurt * (rrole[rnum1].Hurt div 33 + 1);
        if hurt < 0 then
          hurt := 0;
        rrole[rnum1].CurrentHP := rrole[rnum1].CurrentHP - hurt;
        brole[bnum1].ShowNumber := hurt;
        SetAminationPosition(0, 0, 0);
        PlayActionAmination(bnum, 0);
        PlayMagicAmination(bnum, ritem[inum].AmiNum);
        ShowHurtValue(0);
      end;
    end;
  end;

end;

//休息

procedure Rest(bnum: integer);
var
  rnum, i: integer;
begin
  Brole[bnum].Acted := 1;
  rnum := brole[bnum].rnum;
  i := 50;
  i := i + rrole[rnum].Hurt;
  i := i + rrole[rnum].Poision;
  if rrole[rnum].Hurt<60 then
  begin

  RRole[rnum].CurrentHP := RRole[rnum].CurrentHP + 2 + RRole[rnum].MaxHP div i;
  if RRole[rnum].CurrentHP > RRole[rnum].MaxHP then
    RRole[rnum].CurrentHP := RRole[rnum].MaxHP;
  rrole[rnum].PhyPower := rrole[rnum].PhyPower + MAX_PHYSICAL_POWER div 15;
  if rrole[rnum].PhyPower > MAX_PHYSICAL_POWER then
    rrole[rnum].PhyPower := MAX_PHYSICAL_POWER;
  end;

  if rrole[rnum].Poision < 60 then
  begin
  RRole[rnum].CurrentMP := RRole[rnum].CurrentMP + 2 + RRole[rnum].MaxMP div i;
  if RRole[rnum].CurrentMP > RRole[rnum].MaxMP then
    RRole[rnum].CurrentMP := RRole[rnum].MaxMP;
  end;


end;

//The AI.

procedure AutoBattle(bnum: integer);
var
  i, p, a, temp, rnum, inum, eneamount, aim, mnum, level, Ax1, Ay1, i1, i2, step, step1, dis0, dis: integer;
  str: WideString;
begin
  rnum := brole[bnum].rnum;
  showsimplestatus(rnum, 350, 50);
  sdl_delay(BATTLE_SPEED * 25);
  //showmessage('');
  //Life is less than 20%, 70% probality to medcine or eat a pill.
  //生命低于20%, 70%可能医疗或吃药
  if (Brole[bnum].Acted = 0) and (RRole[rnum].CurrentHP < RRole[rnum].MaxHP div 5) then
  begin
    if random(100) < 70 then
    begin
      //医疗大于50, 且体力大于50才对自身医疗
      if (Rrole[rnum].Medcine >= 50) and (rrole[rnum].PhyPower >= 50) and (random(100) < 50) then
      begin
        medcine(bnum);
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
  if (Brole[bnum].Acted = 0) and (RRole[rnum].CurrentMP < RRole[rnum].MaxMP div 5) then
  begin
    if random(100) < 60 then
    begin
      AutoUseItem(bnum, 50);
    end;
  end;

  //Physical power is less than 20%, 80% probality to eat a pill.
  //体力低于20%, 80%可能吃药
  if (Brole[bnum].Acted = 0) and (rrole[rnum].PhyPower < MAX_PHYSICAL_POWER div 5) then
  begin
    if random(100) < 80 then
    begin
      AutoUseItem(bnum, 48);
    end;
  end;

  //如未能吃药且体力大于10, 则尝试攻击
  if (Brole[bnum].Acted = 0) and (rrole[rnum].PhyPower >= 10) then
  begin
    //在敌方选择一个人物
    eneamount := Calrnum(1 - Brole[bnum].Team);
    aim := random(eneamount) + 1;
    //showmessage(inttostr(eneamount));
    for i := 0 to broleamount - 1 do
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
          if (dis < dis0) and (abs(i1 - Bx) + abs(i2 - By) <= brole[bnum].Step) then
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
        if RRole[rnum].CurrentMP < rmagic[mnum].NeedMP * ((level + 1) div 2) then
          level := RRole[rnum].CurrentMP div rmagic[mnum].NeedMP * 2;
        if level > 10 then
          level := 10;
        if level <= 0 then
          level := 1;
        if rmagic[mnum].Attack[level - 1] > temp then
        begin
          p := i1;
          temp := rmagic[mnum].Attack[level - 1];
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
          a := rmagic[mnum].MoveDistance[level - 1];
          if rmagic[mnum].AttAreaType = 3 then
            a := a + rmagic[mnum].AttDistance[level - 1];
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
    step := rmagic[mnum].MoveDistance[level - 1];
    step1 := 0;
    if rmagic[mnum].AttAreaType = 3 then
      step1 := rmagic[mnum].AttDistance[level - 1];
    if abs(Ax - Bx) + abs(Ay - By) <= step + step1 then
    begin
      //step := Rmagic[mnum, 28+level-1];
      if (rmagic[mnum].AttAreaType = 3) then
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
        for i1 := 0 to Brole[bnum].Statelevel[13] + rrole[brole[bnum].rnum].addnum do
        begin
          Rrole[rnum].MagLevel[p] := Rrole[rnum].MagLevel[p] + random(2) + 1;
          if Rrole[rnum].MagLevel[p] > 999 then
            Rrole[rnum].MagLevel[p] := 999;
          if rmagic[mnum].UnKnow[4] > 0 then
          begin
            //rmagic[mnum].UnKnow[4] := strtoint(InputBox('Enter name', 'ssss', '10'));
            execscript(PChar('script\SpecialMagic' + IntToStr(rmagic[mnum].UnKnow[4]) + '.lua'),
              PChar('f' + IntToStr(rmagic[mnum].UnKnow[4])));
            if rmagic[mnum].NeedMP * (level + 1) div 2 > rrole[rnum].CurrentMP then
            begin
              level := rrole[rnum].CurrentMP div rmagic[mnum].NeedMP * 2;
            end;
            rrole[rnum].CurrentMP := rrole[rnum].CurrentMP - rmagic[mnum].NeedMP * (level + 1) div 2;
            if rrole[rnum].CurrentMP < 0 then
              rrole[rnum].CurrentMP := 0;
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
    rest(bnum);

  //检查是否有esc被按下
  if SDL_PollEvent(@event) >= 0 then
  begin
    CheckBasicEvent;
    if (event.key.keysym.sym = sdlk_Escape) then
    begin
      brole[bnum].Auto := 0;
    end;
  end;
end;

//自动使用list的值最大的物品

procedure AutoUseItem(bnum, list: integer);
var
  i, p, temp, rnum, inum: integer;
  str: WideString;
begin
  rnum := brole[bnum].rnum;
  if Brole[bnum].Team <> 0 then
  begin
    temp := 0;
    p := -1;
    for i := 0 to 3 do
    begin
      if Rrole[rnum].TakingItem[i] >= 0 then
      begin
        if ritem[Rrole[rnum].TakingItem[i]].Data[list] > temp then
        begin
          temp := ritem[Rrole[rnum].TakingItem[i]].Data[list];
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
      if (RItemList[i].Amount > 0) and (ritem[RItemList[i].Number].ItemType = 3) then
      begin
        if ritem[RItemList[i].Number].Data[list] > temp then
        begin
          temp := ritem[RItemList[i].Number].Data[list];
          p := i;
        end;
      end;
    end;
  end;

  if p >= 0 then
  begin
    if Brole[bnum].Team <> 0 then
      inum := rrole[rnum].TakingItem[p]
    else
      inum := RItemList[p].Number;
    redraw;
    SDL_UpdateRect2(screen, 0, 0, screen.w, screen.h);
    EatOneItem(rnum, inum);
    if Brole[bnum].Team <> 0 then
      instruct_41(rnum, rrole[rnum].TakingItem[p], -1)
    else
      instruct_32(RItemList[p].Number, -1);
    Brole[bnum].Acted := 1;
    sdl_delay(300);
  end;

end;




//自动战斗AI，小小猪更改

procedure AutoBattle2(bnum: integer);
var
  i, p, a, temp, rnum, inum, eneamount, aim, mnum, level, Ax1, Ay1, i1, i2, step, step1, dis0, dis: integer;
  Cmnum, Cmlevel, Cmtype, Cmdis, Cmrange, Clevel: integer;
  Movex, Movey, Mx1, My1, tempmaxhurt, maxhurt, tempminHP, twice: integer;
  str: WideString;
begin
  rnum := brole[bnum].rnum;
  showsimplestatus(rnum, 350, 50);
  sdl_delay(450);

  if AutoMode[bnum] = 2 then
  begin
    rest(bnum);
  end
  else
  begin

    //showmessage('');
    //Life is less than 30%, 70% probality to medcine or eat a pill.
    //生命低于30%, 70%可能医疗或吃药
    if (Brole[bnum].Acted = 0) and (RRole[rnum].CurrentHP < (RRole[rnum].MaxHP * 3) div 10) then
    begin
      if (Brole[bnum].Team <> 0) or ((Brole[bnum].Team = 0) and (AutoMode[bnum] > 0)) then
      begin
        if random(100) < 70 then
        begin
          farthestmove(Movex, Movey, bnum);
          Ax := Movex;
          Ay := Movey;
          MoveAmination(bnum);
          //医疗大于50, 且体力大于50才对自身医疗
          if (Rrole[rnum].Medcine >= 50) and (rrole[rnum].PhyPower >= 50) then
          begin
            medcine(bnum);
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
    if (Brole[bnum].Acted = 0) and (RRole[rnum].CurrentMP < (RRole[rnum].MaxMP * 3) div 10) then
    begin
      if (Brole[bnum].Team <> 0) or ((Brole[bnum].Team = 0) and (AutoMode[bnum] = 1)) then
      begin
        if (random(100) < 60) then
        begin
          farthestmove(Movex, Movey, bnum);
          Ax := Movex;
          Ay := Movey;
          MoveAmination(bnum);
          AutoUseItem(bnum, 50);
        end;
      end;
    end;

    //Physical power is less than 30%, 80% probality to eat a pill.
    //体力低于30%, 80%可能吃药
    if (Brole[bnum].Acted = 0) and (Brole[bnum].Team <> 0) and (rrole[rnum].PhyPower <
      (MAX_PHYSICAL_POWER * 3 div 10)) then
    begin
      if (Brole[bnum].Team <> 0) or ((Brole[bnum].Team = 0) and (AutoMode[bnum] = 1)) then
      begin
        if random(100) < 80 then
        begin
          farthestmove(Movex, Movey, bnum);
          Ax := Movex;
          Ay := Movey;
          MoveAmination(bnum);
          AutoUseItem(bnum, 48);
        end;
      end;
    end;

    //自身医疗大于60，寻找生命低于50％的队友进行医疗
    if (Brole[bnum].Acted = 0) and (rrole[rnum].Medcine >= 60) and (rrole[rnum].PhyPower > 50) then
    begin
      if (Brole[bnum].Team <> 0) or ((Brole[bnum].Team = 0) and (AutoMode[bnum] > 0)) then
      begin
        Mx1 := -1;
        Ax1 := -1;
        trymovecure(Mx1, My1, Ax1, Ay1, bnum);
        if Ax1 <> -1 then
        begin
          //移动
          Ax := Mx1;
          Ay := My1;
          MoveAmination(bnum);

          //医疗
          Ax := Ax1;
          Ay := Ay1;
          cureaction(bnum);
          Brole[bnum].Acted := 1;
        end;
      end;
    end;

    //尝试攻击
    if (Brole[bnum].Acted = 0) and (rrole[rnum].PhyPower >= 10) then
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
        if ((mnum < 131) or (mnum > 160)) and (rmagic[mnum].NeedMP < rrole[rnum].CurrentMP) then
        begin
          if (Rmagic[mnum].Data[8] <= 0) or ((Rmagic[mnum].Data[8] > 0) and
            (Rmagic[mnum].Data[9] <= GetItemAmount(Rmagic[mnum].Data[8]))) then
          begin
            //if  Rmagic[mnum].Data[8]>= 0 then
            //           instruct_32(Rmagic[mnum].Data[8], -Rmagic[mnum].Data[9]);

            a := a + 1;
            level := Rrole[rnum].MagLevel[i] div 100 + 1;
            if RRole[rnum].CurrentMP < rmagic[mnum].NeedMP * ((level + 1) div 2) then
              level := RRole[rnum].CurrentMP div rmagic[mnum].NeedMP * 2;
            if level > 10 then
              level := 10;
            if level <= 0 then
              level := 1;

            for i1 := 0 to 63 do
              for i2 := 0 to 63 do
                Bfield[3, i1, i2] := -1;

            Bfield[3, Brole[bnum].X, Brole[bnum].Y] := 0;

            trymoveattack(Mx1, My1, Ax1, Ay1, tempmaxhurt, bnum, mnum, level);

            if tempmaxhurt > maxhurt then
            begin
              p := i;
              Cmnum := mnum;
              Clevel := level;
              Cmtype := rmagic[mnum].AttAreaType;
              Cmdis := rmagic[mnum].MoveDistance[level - 1];
              Cmrange := rmagic[mnum].AttDistance[level - 1];
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

        twice:=0;
        if rmagic[Rrole[rnum].Magic[p]].MagicType=2 then
          if random(1000)< rrole[brole[bnum].rnum].Sword  then
             twice:=1;

        for i1 := 0 to Brole[bnum].Statelevel[13] + rrole[brole[bnum].rnum].addnum + twice do
        begin
          mnum := Rrole[rnum].Magic[p];
          Rrole[rnum].MagLevel[p] := Rrole[rnum].MagLevel[p] + random(2) + 1;
          if Rrole[rnum].MagLevel[p] > 999 then
            Rrole[rnum].MagLevel[p] := 999;
          if rmagic[mnum].UnKnow[4] > 0 then
          begin
            execscript(PChar('script\SpecialMagic' + IntToStr(rmagic[mnum].UnKnow[4]) + '.lua'),
              PChar('f' + IntToStr(rmagic[mnum].UnKnow[4])));
            if rmagic[mnum].NeedMP * (level + 1) div 2 > rrole[rnum].CurrentMP then
            begin
              level := rrole[rnum].CurrentMP div rmagic[mnum].NeedMP * 2;
            end;
            rrole[rnum].CurrentMP := rrole[rnum].CurrentMP - rmagic[mnum].NeedMP * (level + 1) div 2;

            if rrole[rnum].CurrentMP < 0 then
              rrole[rnum].CurrentMP := 0;
          end
          else
            AttackAction(bnum, Cmnum, Clevel);
        end;
      end;
    end;

    //If all other actions fail, rest.
    //如果上面行动全部失败，则移动到离敌人最近的地方，休息
    if Brole[bnum].Acted = 0 then
    begin
      nearestmove(Movex, Movey, bnum);
      Ax := Movex;
      Ay := Movey;
      MoveAmination(bnum);
      rest(bnum);
    end;
  end;

end;

//尝试移动并攻击，step为最大移动步数
//武功已经事先选好，distance为武功距离，range为武功范围，AttAreaType为武功类型
//尝试每一个可以移动到的点，考察在该点攻击的情况，选择最合适的目标点

procedure trymoveattack(var Mx1, My1, Ax1, Ay1, tempmaxhurt: integer; bnum, mnum, level: integer);
var
  i, i1, i2, eneamount, aim, curX, curY, dis, dis0: integer;
  tempX, tempY, tempdis: integer;
  step, distance, range, AttAreaType, myteam, minstep: integer;
  tempBx, tempBy, tempAx, tempAy, temphurt: integer;
  aimHurt: array [0..63, 0..63] of integer;
begin
  step := brole[bnum].Step;
  minstep := 0;

  FillChar(aimHurt[0, 0], 4096 * 4, -1);
  distance := rmagic[mnum].MoveDistance[level - 1];
  range := rmagic[mnum].AttDistance[level - 1];
  AttAreaType := rmagic[mnum].AttAreaType;
  myteam := brole[bnum].Team;
  tempmaxhurt := 0;

  CalCanSelect(bnum, 0, step);

  Mx1 := -1;
  My1 := -1;
  //aim := 0;
  for curX := 0 to 63 do
    for curY := 0 to 63 do
    begin
      if Bfield[3, curX, curY] >= 0 then
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
            minstep := rmagic[mnum].unknow[1];
            //calfar(Mx1, My1, Ax1, Ay1, tempmaxhurt, curX, curY, bnum, mnum, level);
          end;
        end;
        for i1 := max(curX - dis, 0) to min(curX + dis, 63) do
        begin
          dis0 := abs(i1 - curX);
          for i2 := max(curY - dis + dis0, 0) to min(curY + dis - dis0, 63) do
          begin
            if abs(Ax - Bx) + abs(Ay - By) <= minstep then
              continue;
            SetAminationPosition(curX, curY, i1, i2, AttAreaType, distance, range);
            temphurt := 0;
            if ((AttAreaType = 0) or (AttAreaType = 3))
              and (aimHurt[i1, i2] >= 0) then
            begin
              if aimHurt[i1, i2] > 0 then
                temphurt := aimHurt[i1, i2] + random(5) - random(5);  //点面类攻击已经计算过的点简单处理
            end
            else
            begin
              for i := 0 to BRoleAmount - 1 do
              begin
                if (Brole[i].Team <> myteam) and (Brole[i].Dead = 0) and (Bfield[4, Brole[i].X, Brole[i].Y] > 0) then
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

//线型攻击的情况，分四个方向考虑，分别计算伤血量

procedure calline(var Mx1, My1, Ax1, Ay1, tempmaxhurt: integer; curX, curY, bnum, mnum, level: integer);
var
  i, tempX, tempY, ebnum, rnum, tempHP, temphurt: integer;
  distance, range, AttAreaType, myteam: integer;
begin
  distance := rmagic[mnum].MoveDistance[level - 1];
  range := rmagic[mnum].AttDistance[level - 1];
  AttAreaType := rmagic[mnum].AttAreaType;
  myteam := brole[bnum].Team;


  temphurt := 0;
  for i := curX - 1 downto curX - distance do
  begin
    ebnum := Bfield[2, i, curY];
    if (ebnum >= 0) and (Brole[ebnum].Dead = 0) and (Brole[ebnum].Team <> myteam) then
    begin
      temphurt := temphurt + CalHurtValue2(bnum, ebnum, mnum, level);
    end;
  end;
  if temphurt > tempmaxhurt then
  begin
    tempmaxhurt := temphurt;
    Mx1 := curX;
    My1 := curY;
    Ax1 := curX - 1;
    Ay1 := curY;
  end;

  temphurt := 0;
  for i := curX + 1 to curX + distance do
  begin
    ebnum := Bfield[2, i, curY];
    if (ebnum >= 0) and (Brole[ebnum].Dead = 0) and (Brole[ebnum].Team <> myteam) then
    begin
      temphurt := temphurt + CalHurtValue2(bnum, ebnum, mnum, level);
    end;
  end;
  if temphurt > tempmaxhurt then
  begin
    tempmaxhurt := temphurt;
    Mx1 := curX;
    My1 := curY;
    Ax1 := curX + 1;
    Ay1 := curY;
  end;


  temphurt := 0;
  for i := curY - 1 downto curY - distance do
  begin
    ebnum := Bfield[2, curX, i];
    if (ebnum >= 0) and (Brole[ebnum].Dead = 0) and (Brole[ebnum].Team <> myteam) then
    begin
      temphurt := temphurt + CalHurtValue2(bnum, ebnum, mnum, level);
    end;
  end;
  if temphurt > tempmaxhurt then
  begin
    tempmaxhurt := temphurt;
    Mx1 := curX;
    My1 := curY;
    Ax1 := curX;
    Ay1 := curY - 1;
  end;


  temphurt := 0;
  for i := curY + 1 to curY + distance do
  begin
    ebnum := Bfield[2, curX, i];
    if (ebnum >= 0) and (Brole[ebnum].Dead = 0) and (Brole[ebnum].Team <> myteam) then
    begin
      temphurt := temphurt + CalHurtValue2(bnum, ebnum, mnum, level);
    end;
  end;
  if temphurt > tempmaxhurt then
  begin
    tempmaxhurt := temphurt;
    Mx1 := curX;
    My1 := curY;
    Ax1 := curX;
    Ay1 := curY + 1;
  end;
end;

//方向系菱型

procedure caldirdiamond(var Mx1, My1, Ax1, Ay1, tempmaxhurt: integer; curX, curY, bnum, mnum, level: integer);
var
  i, tempX, tempY: integer;
  temphurt: array[1..4] of integer;
  distance, range, AttAreaType, myteam: integer;
begin
  distance := rmagic[mnum].MoveDistance[level - 1];
  range := rmagic[mnum].AttDistance[level - 1];
  AttAreaType := rmagic[mnum].AttAreaType;
  myteam := brole[bnum].Team;

  temphurt[1] := 0;
  temphurt[2] := 0;
  temphurt[3] := 0;
  temphurt[4] := 0;

  for i := 0 to broleamount - 1 do
  begin
    if (myteam <> Brole[i].Team) and (Brole[i].Dead = 0) then
    begin
      tempX := Brole[i].X;
      tempY := Brole[i].Y;
      if (abs(tempX - curX) + abs(tempY - curY) <= distance) and (abs(tempX - curX) <> abs(tempY - curY)) then
      begin
        if (tempX - curX > 0) and (abs(tempX - curX) > abs(tempY - curY)) then
        begin
          temphurt[1] := temphurt[1] + CalHurtValue2(bnum, i, mnum, level);
        end
        else
        if (tempX - curX < 0) and (abs(tempX - curX) > abs(tempY - curY)) then
        begin
          temphurt[2] := temphurt[2] + CalHurtValue2(bnum, i, mnum, level);
        end
        else
        if (tempY - curY > 0) and (abs(tempX - curX) < abs(tempY - curY)) then
        begin
          temphurt[3] := temphurt[3] + CalHurtValue2(bnum, i, mnum, level);
        end
        else
        if (tempY - curY < 0) and (abs(tempX - curX) < abs(tempY - curY)) then
        begin
          temphurt[4] := temphurt[4] + CalHurtValue2(bnum, i, mnum, level);
        end;
      end;
    end;
  end;

  if temphurt[1] > tempmaxhurt then
  begin
    tempmaxhurt := temphurt[1];
    Mx1 := curX;
    My1 := curY;
    Ax1 := curX + 1;
    Ay1 := curY;
  end;
  if temphurt[2] > tempmaxhurt then
  begin
    tempmaxhurt := temphurt[2];
    Mx1 := curX;
    My1 := curY;
    Ax1 := curX - 1;
    Ay1 := curY;
  end;
  if temphurt[3] > tempmaxhurt then
  begin
    tempmaxhurt := temphurt[3];
    Mx1 := curX;
    My1 := curY;
    Ax1 := curX;
    Ay1 := curY + 1;
  end;
  if temphurt[4] > tempmaxhurt then
  begin
    tempmaxhurt := temphurt[4];
    Mx1 := curX;
    My1 := curY;
    Ax1 := curX;
    Ay1 := curY - 1;
  end;
end;

//方向系角型

procedure caldirangle(var Mx1, My1, Ax1, Ay1, tempmaxhurt: integer; curX, curY, bnum, mnum, level: integer);
var
  i, tempX, tempY: integer;
  temphurt: array[1..4] of integer;
  distance, range, AttAreaType, myteam: integer;
begin
  distance := rmagic[mnum].MoveDistance[level - 1];
  range := rmagic[mnum].AttDistance[level - 1];
  AttAreaType := rmagic[mnum].AttAreaType;
  myteam := brole[bnum].Team;

  temphurt[1] := 0;
  temphurt[2] := 0;
  temphurt[3] := 0;
  temphurt[4] := 0;

  for i := 0 to broleamount - 1 do
  begin
    if (myteam <> Brole[i].Team) and (Brole[i].Dead = 0) then
    begin
      tempX := Brole[i].X;
      tempY := Brole[i].Y;
      if (abs(tempX - curX) <= distance) and (abs(tempY - curY) <= distance) and
        (abs(tempX - curX) <> abs(tempY - curY)) then
      begin
        if (tempX - curX > 0) and (abs(tempX - curX) > abs(tempY - curY)) then
        begin
          temphurt[1] := temphurt[1] + CalHurtValue2(bnum, i, mnum, level);
        end
        else
        if (tempX - curX < 0) and (abs(tempX - curX) > abs(tempY - curY)) then
        begin
          temphurt[2] := temphurt[2] + CalHurtValue2(bnum, i, mnum, level);
        end
        else
        if (tempY - curY > 0) and (abs(tempX - curX) < abs(tempY - curY)) then
        begin
          temphurt[3] := temphurt[3] + CalHurtValue2(bnum, i, mnum, level);
        end
        else
        if (tempY - curY < 0) and (abs(tempX - curX) < abs(tempY - curY)) then
        begin
          temphurt[4] := temphurt[4] + CalHurtValue2(bnum, i, mnum, level);
        end;
      end;
    end;
  end;

  if temphurt[1] > tempmaxhurt then
  begin
    tempmaxhurt := temphurt[1];
    Mx1 := curX;
    My1 := curY;
    Ax1 := curX + 1;
    Ay1 := curY;
  end;
  if temphurt[2] > tempmaxhurt then
  begin
    tempmaxhurt := temphurt[2];
    Mx1 := curX;
    My1 := curY;
    Ax1 := curX - 1;
    Ay1 := curY;
  end;
  if temphurt[3] > tempmaxhurt then
  begin
    tempmaxhurt := temphurt[3];
    Mx1 := curX;
    My1 := curY;
    Ax1 := curX;
    Ay1 := curY + 1;
  end;
  if temphurt[4] > tempmaxhurt then
  begin
    tempmaxhurt := temphurt[4];
    Mx1 := curX;
    My1 := curY;
    Ax1 := curX;
    Ay1 := curY - 1;
  end;
end;

//目标系方、原地系方

procedure calarea(var Mx1, My1, Ax1, Ay1, tempmaxhurt: integer; curX, curY, bnum, mnum, level: integer);
var
  i, j, k, m, n, tempX, tempY, temphurt: integer;
  distance, range, AttAreaType, myteam: integer;
begin
  distance := rmagic[mnum].MoveDistance[level - 1];
  range := rmagic[mnum].AttDistance[level - 1];
  AttAreaType := rmagic[mnum].AttAreaType;
  myteam := brole[bnum].Team;

  for i := curX - distance to curX + distance do
  begin
    m := (distance - sign(i - curX) * (i - curX));
    for j := curY - m to curY + m do
    begin
      temphurt := 0;
      for k := 0 to broleamount - 1 do
      begin
        if (myteam <> Brole[k].Team) and (Brole[k].Dead = 0) then
        begin
          tempX := Brole[k].X;
          tempY := Brole[k].Y;
          if (abs(tempX - i) <= range) and (abs(tempY - j) <= range) then
          begin
            temphurt := temphurt + CalHurtValue2(bnum, k, mnum, level);
          end;
        end;
      end;
      if temphurt > tempmaxhurt then
      begin
        Ax1 := i;
        Ay1 := j;
        Mx1 := curX;
        My1 := curY;
        tempmaxhurt := temphurt;
      end;
    end;
  end;
end;


//目标系点十菱，原地系菱

procedure calpoint(var Mx1, My1, Ax1, Ay1, tempmaxhurt: integer; curX, curY, bnum, mnum, level: integer);
var
  i, j, k, m, n, tempX, tempY, temphurt, ebnum, ernum, tempHP: integer;
  distance, range, AttAreaType, myteam: integer;
begin
  distance := rmagic[mnum].MoveDistance[level - 1];
  range := rmagic[mnum].AttDistance[level - 1];
  AttAreaType := rmagic[mnum].AttAreaType;
  myteam := brole[bnum].Team;


  for i := curX - distance to curX + distance do
  begin
    m := (distance - sign(i - curX) * (i - curX));
    for j := curY - m to curY + m do
    begin
      temphurt := 0;
      for k := 0 to broleamount - 1 do
      begin
        if (myteam <> Brole[k].Team) and (Brole[k].Dead = 0) then
        begin
          tempX := Brole[k].X;
          tempY := Brole[k].Y;
          if abs(tempX - i) + abs(tempY - j) <= range then
          begin
            temphurt := temphurt + CalHurtValue2(bnum, k, mnum, level);
          end;
        end;
      end;
      if temphurt > tempmaxhurt then
      begin
        Ax1 := i;
        Ay1 := j;
        Mx1 := curX;
        My1 := curY;
        tempmaxhurt := temphurt;
      end;
    end;
  end;
end;


//原地系十叉米

procedure calcross(var Mx1, My1, Ax1, Ay1, tempmaxhurt: integer; curX, curY, bnum, mnum, level: integer);
var
  i, tempX, tempY, temphurt, ebnum, rnum: integer;
  distance, range, AttAreaType, myteam: integer;
begin
  distance := rmagic[mnum].MoveDistance[level - 1];
  range := rmagic[mnum].AttDistance[level - 1];
  AttAreaType := rmagic[mnum].AttAreaType;
  myteam := brole[bnum].Team;

  temphurt := 0;
  for i := -range to range do
  begin
    ebnum := Bfield[2, curX + i, curY + i];
    if (ebnum >= 0) and (Brole[ebnum].Dead = 0) and (Brole[ebnum].Team <> myteam) then
    begin
      temphurt := temphurt + CalHurtValue2(bnum, ebnum, mnum, level);
    end;
  end;

  for i := -range to range do
  begin
    bnum := Bfield[2, curX + i, curY - i];
    if (bnum >= 0) and (Brole[bnum].Dead = 0) and (Brole[bnum].Team <> myteam) then
    begin
      temphurt := temphurt + CalHurtValue2(bnum, ebnum, mnum, level);
    end;
  end;

  for i := curX - distance to curX + distance do
  begin
    bnum := Bfield[2, i, curY];
    if (bnum >= 0) and (Brole[bnum].Dead = 0) and (Brole[bnum].Team <> myteam) then
    begin
      temphurt := temphurt + CalHurtValue2(bnum, ebnum, mnum, level);
    end;
  end;

  for i := curY - distance to curY + distance do
  begin
    bnum := Bfield[2, curX, i];
    if (bnum >= 0) and (Brole[bnum].Dead = 0) and (Brole[bnum].Team <> myteam) then
    begin
      temphurt := temphurt + CalHurtValue2(bnum, ebnum, mnum, level);
    end;
  end;

  if temphurt > tempmaxhurt then
  begin
    tempmaxhurt := temphurt;
    Mx1 := curX;
    My1 := curY;
    Ax1 := curX;
    Ay1 := curY;
  end;
end;

//远程系

procedure calfar(var Mx1, My1, Ax1, Ay1, tempmaxhurt: integer; curX, curY, bnum, mnum, level: integer);
var
  i, j, k, m, n, tempX, tempY, temphurt: integer;
  minstep: integer;
  distance, range, AttAreaType, myteam: integer;
begin
  distance := rmagic[mnum].MoveDistance[level - 1];
  range := rmagic[mnum].AttDistance[level - 1];
  AttAreaType := rmagic[mnum].AttAreaType;
  myteam := brole[bnum].Team;
  minstep := rmagic[mnum].unknow[1];

  for i := curX - distance to curX + distance do
  begin
    m := (distance - sign(i - curX) * (i - curX));
    for j := curY - m to curY + m do
    begin
      if abs(j - curY) + abs(i - curX) <= minstep then
        continue;
      temphurt := 0;
      for k := 0 to broleamount - 1 do
      begin
        if (myteam <> Brole[k].Team) and (Brole[k].Dead = 0) then
        begin
          tempX := Brole[k].X;
          tempY := Brole[k].Y;
          if abs(tempX - i) + abs(tempY - j) <= range then
          begin
            temphurt := temphurt + CalHurtValue2(bnum, k, mnum, level);
          end;
        end;
      end;
      if temphurt > tempmaxhurt then
      begin
        Ax1 := i;
        Ay1 := j;
        Mx1 := curX;
        My1 := curY;
        tempmaxhurt := temphurt;
      end;
    end;
  end;
end;


//移动到离最近的敌人最近的地方

procedure nearestmove(var Mx1, My1: integer; bnum: integer);
var
  i, i1, i2, tempdis, mindis: integer;
  aimX, aimY: integer;
  step, myteam: integer;

  Xlist: array[0..4096] of integer;
  Ylist: array[0..4096] of integer;
  steplist: array[0..4096] of integer;
  curgrid, totalgrid: integer;
  Bgrid: array[1..4] of integer; //0空位，1建筑，2友军，3敌军，4出界，5已走过
  Xinc, Yinc: array[1..4] of integer;
  curX, curY, curstep, nextX, nextY: integer;

begin
  myteam := brole[bnum].Team;
  mindis := 9999;
  step := brole[bnum].Step;

  Mx1 := Bx;
  My1 := By;
  //选择一个最近的敌人
  for i := 0 to broleamount - 1 do
  begin
    if (myteam <> Brole[i].Team) and (Brole[i].Dead = 0) then
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

  CalCanSelect(bnum, 0, step);

  for curX := 0 to 63 do
    for curY := 0 to 63 do
    begin
      if Bfield[3, curX, curY] >= 0 then
      begin
        tempdis := abs(curX - aimX) + abs(curY - aimY);
        if tempdis < mindis then
        begin
          mindis := tempdis;
          Mx1 := curX;
          My1 := curY;
        end;
      end;
    end;

  {for i1 := 0 to 63 do
    for i2 := 0 to 63 do
      Bfield[3, i1, i2] := -1;
  Bfield[3, Brole[bnum].X, Brole[bnum].Y] := 0;

  step := brole[bnum].Step;

  Mx := Bx;
  My := By;
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
  Xlist[totalgrid] := Bx;
  Ylist[totalgrid] := By;
  steplist[totalgrid] := 0;
  totalgrid := totalgrid + 1;
  while curgrid < totalgrid do
  begin
    curX := Xlist[curgrid];
    curY := Ylist[curgrid];
    tempdis := abs(curX - aimX) + abs(curY - aimY);
    if tempdis < mindis then
    begin
      mindis := tempdis;
      Mx := curX;
      My := curY;
    end;

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

    end;
    curgrid := curgrid + 1;
  end;}
end;


//移动到离敌人最远的地方（与每一个敌人的距离之和最大）

procedure farthestmove(var Mx1, My1: integer; bnum: integer);
var
  i, i1, i2, k, tempdis, maxdis: integer;
  aimX, aimY: integer;
  step, myteam: integer;

  Xlist: array[0..4096] of integer;
  Ylist: array[0..4096] of integer;
  steplist: array[0..4096] of integer;
  curgrid, totalgrid: integer;
  Bgrid: array[1..4] of integer; //0空位，1建筑，2友军，3敌军，4出界，5已走过
  Xinc, Yinc: array[1..4] of integer;
  curX, curY, curstep, nextX, nextY: integer;

begin
  step := brole[bnum].Step;
  myteam := brole[bnum].Team;
  maxdis := 0;

  Mx1 := Bx;
  My1 := By;

  CalCanSelect(bnum, 0, step);

  for curX := 0 to 63 do
    for curY := 0 to 63 do
    begin
      if Bfield[3, curX, curY] >= 0 then
      begin
        tempdis := 0;
        for k := 0 to broleamount - 1 do
        begin
          if (brole[k].Team <> myteam) and (brole[k].Dead = 0) then
            tempdis := tempdis + abs(curX - brole[k].X) + abs(curY - brole[k].Y);
        end;
        if tempdis > maxdis then
        begin
          maxdis := tempdis;
          Mx1 := curX;
          My1 := curY;
        end;
      end;
    end;

  {Xinc[1] := 1;
  Xinc[2] := -1;
  Xinc[3] := 0;
  Xinc[4] := 0;
  Yinc[1] := 0;
  Yinc[2] := 0;
  Yinc[3] := 1;
  Yinc[4] := -1;
  curgrid := 0;
  totalgrid := 0;
  Xlist[totalgrid] := Bx;
  Ylist[totalgrid] := By;
  steplist[totalgrid] := 0;
  totalgrid := totalgrid + 1;

  for i1 := 0 to 63 do
    for i2 := 0 to 63 do
      Bfield[3, i1, i2] := -1;
  Bfield[3, Brole[bnum].X, Brole[bnum].Y] := 0;

  while curgrid < totalgrid do
  begin
    curX := Xlist[curgrid];
    curY := Ylist[curgrid];
    tempdis := 0;
    for k := 0 to broleamount - 1 do
    begin
      if (brole[k].Team <> myteam) and (brole[k].Dead = 0) then
        tempdis := tempdis + abs(curX - brole[k].X) + abs(curY - brole[k].Y);
    end;
    if tempdis > maxdis then
    begin
      maxdis := tempdis;
      Mx := curX;
      My := curY;
    end;

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

    end;
    curgrid := curgrid + 1;
  end;}
end;


//在可医疗范围内，寻找生命不足一半的生命最少的友军，

procedure trymovecure(var Mx1, My1, Ax1, Ay1: integer; bnum: integer);
var
  Xlist: array[0..4096] of integer;
  Ylist: array[0..4096] of integer;
  steplist: array[0..4096] of integer;
  curgrid, totalgrid: integer;
  Bgrid: array[1..4] of integer; //0空位，1建筑，2友军，3敌军，4出界，5已走过
  Xinc, Yinc: array[1..4] of integer;
  curX, curY, curstep, nextX, nextY: integer;
  i, i1, i2, eneamount, aim: integer;
  tempX, tempY, tempdis: integer;
  step, myteam, curedis, rnum: integer;
  tempminHP: integer;

begin
  step := brole[bnum].Step;
  myteam := brole[bnum].Team;
  curedis := rrole[brole[bnum].rnum].Medcine div 15 + 1;

  tempminHP := MAX_HP;

  for curX := 0 to 63 do
    for curY := 0 to 63 do
    begin
      if Bfield[3, curX, curY] >= 0 then
      begin
        for i := 0 to broleamount - 1 do
        begin
          rnum := brole[i].rnum;
          if (brole[i].Team = myteam) and (brole[i].dead = 0) and (abs(brole[i].X - curX) +
            abs(brole[i].Y - curY) < curedis) and (rrole[rnum].CurrentHP < rrole[rnum].MaxHP div 2) then
          begin
            if (rrole[rnum].CurrentHP < tempminHP) then
            begin
              tempminHP := rrole[rnum].CurrentHP;
              Mx1 := curX;
              My1 := curY;
              Ax1 := brole[i].X;
              Ay1 := brole[i].Y;
            end;
          end;
        end;
      end;
    end;

  {for i1 := 0 to 63 do
    for i2 := 0 to 63 do
      Bfield[3, i1, i2] := -1;
  Bfield[3, Brole[bnum].X, Brole[bnum].Y] := 0;

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
  Xlist[totalgrid] := Bx;
  Ylist[totalgrid] := By;
  steplist[totalgrid] := 0;
  totalgrid := totalgrid + 1;

  while curgrid < totalgrid do
  begin
    curX := Xlist[curgrid];
    curY := Ylist[curgrid];

    for i := 0 to broleamount - 1 do
    begin
      rnum := brole[i].rnum;
      if (brole[i].Team = myteam) and (brole[i].dead = 0) and (abs(brole[i].X - curX) +
        abs(brole[i].Y - curY) < curedis) and (rrole[rnum].CurrentHP < rrole[rnum].MaxHP div 2) then
      begin
        if (rrole[rnum].CurrentHP < tempminHP) then
        begin
          tempminHP := rrole[rnum].CurrentHP;
          Mx1 := curX;
          My1 := curY;
          Ax1 := brole[i].X;
          Ay1 := brole[i].Y;
        end;
      end;
    end;

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
    end;
    curgrid := curgrid + 1;
  end;}
end;

procedure cureaction(bnum: integer);
var
  rnum, bnum1, rnum1, addlife: integer;
begin
  rnum := Brole[bnum].rnum;
  rrole[rnum].PhyPower := rrole[rnum].PhyPower - 5;
  bnum1 := bfield[2, Ax, Ay];
  rnum1 := brole[bnum1].rnum;
  addlife := Rrole[rnum].Medcine; //calculate the value
  if addlife < 0 then
    addlife := 0;
  if addlife + rrole[rnum1].CurrentHP > rrole[rnum1].MaxHP then
    addlife := rrole[rnum1].MaxHP - rrole[rnum1].CurrentHP;
  rrole[rnum1].CurrentHP := rrole[rnum1].CurrentHP + addlife;
  Rrole[rnum1].Hurt := Rrole[rnum1].Hurt - addlife div 10 div LIFE_HURT;
  if Rrole[rnum1].Hurt < 0 then
    Rrole[rnum1].Hurt := 0;
  brole[bnum1].ShowNumber := addlife;
  SetAminationPosition(0, 0, 0);
  PlayActionAmination(bnum, 0);
  PlayMagicAmination(bnum, 0);
  ShowHurtValue(3);
end;

procedure RoundOver;
var
  i, j, rnum,addphy: integer;
begin

  //以下处理状态类事件的回合数
  for i := 0 to 31 do
  begin
    if (SEMIREAL = 0) or (Brole[i].Acted = 1) then
    begin
      //情侣和状态恢复生命
      rnum := brole[i].rnum;
      rrole[rnum].CurrentHP := rrole[rnum].CurrentHP + rrole[rnum].MaxHP * brole[i].StateLevel[5] div 100;
      rrole[rnum].CurrentHP := rrole[rnum].CurrentHP + rrole[rnum].MaxHP * brole[i].loverLevel[7] div 100;
      if rrole[rnum].CurrentHP > rrole[rnum].MaxHP then
        rrole[rnum].CurrentHP := rrole[rnum].MaxHP;

      //情侣和状态恢复内力
      rnum := brole[i].rnum;
      rrole[rnum].CurrentMP := rrole[rnum].CurrentMP + rrole[rnum].MaxMP * brole[i].StateLevel[6] div 100;
      rrole[rnum].CurrentMP := rrole[rnum].CurrentMP + rrole[rnum].MaxMP * brole[i].loverLevel[8] div 100;
      if rrole[rnum].CurrentMP < 0 then
        rrole[rnum].CurrentMP := 0;
      if rrole[rnum].CurrentMP > rrole[rnum].MaxMP then
        rrole[rnum].CurrentMP := rrole[rnum].MaxMP;
      //状态恢复体力
      addphy:=MAX_PHYSICAL_POWER * brole[i].StateLevel[20];
      if rrole[rnum].PhyPower+addphy<20 then addphy:=0;
      rrole[rnum].PhyPower := rrole[rnum].PhyPower + addphy;
      if rrole[rnum].PhyPower > MAX_PHYSICAL_POWER then
        rrole[rnum].PhyPower := MAX_PHYSICAL_POWER;
      if rrole[rnum].PhyPower < 1 then
        rrole[rnum].PhyPower := 1;



      for j := 0 to STATUS_AMOUNT - 1 do
      begin
        if brole[i].StateRound[j] > 0 then
        begin
          brole[i].StateRound[j] := brole[i].StateRound[j] - 1;
          if brole[i].StateRound[j] = 0 then
          begin
            brole[i].StateLevel[j] := 0;
            if j = 27 then
              brole[i].Team := 1 - brole[i].Team;
          end;
        end;
      end;
    end;
  end;
end;

function SelectAutoMode: integer;
var
  i, p, menustatus, max, menu, menup: integer;
begin
  menustatus := 0;
  max := 0;
  setlength(menustring, 3);
  setlength(menuengstring, 0);
  //SDL_EnableKeyRepeat(20, 100);
  menustring[0] := ' 瘋子型';
  menustring[1] := ' 傻子型';
  menustring[2] := ' 呆子型';
  //{$IFDEF DARWIN}
  RegionRect.x := 169;
  RegionRect.y := 96;
  RegionRect.w := screen.w;
  RegionRect.h := screen.h;
  //{$ENDIF}
  redraw;
  //{$IFDEF DARWIN}
  RegionRect.w := 0;
  RegionRect.h := 0;
  //{$ENDIF}
  SDL_UpdateRect2(screen, 169, 96, screen.w, screen.h);
  menu := 0;
  showModemenu(menu);
  //SDL_UpdateRect2(screen,0,0,screen.w,screen.h);
  while (SDL_WaitEvent(@event) >= 0) do
  begin
    CheckBasicEvent;
    case event.type_ of
      SDL_KEYUP:
      begin
        if (event.key.keysym.sym = sdlk_return) or (event.key.keysym.sym = sdlk_space) then
        begin
          break;
        end;
        if (event.key.keysym.sym = sdlk_escape) then
        begin
          menu := -1;
          break;
        end;
      end;
      SDL_KEYDOWN:
      begin
        if (event.key.keysym.sym = sdlk_up) then
        begin
          menu := menu - 1;
          if menu < 0 then
            menu := 2;
          showModemenu(menu);
        end;
        if (event.key.keysym.sym = sdlk_down) then
        begin
          menu := menu + 1;
          if menu > 2 then
            menu := 0;
          showModemenu(menu);
        end;
      end;
      SDL_MOUSEBUTTONUP:
      begin
        if (event.button.button = sdl_button_left) and (menu <> -1) then
        begin
          break;
        end;
        if (event.button.button = sdl_button_right) then
        begin
          menu := -1;
          break;
        end;
      end;
      SDL_MOUSEMOTION:
      begin
        if (round(event.button.x / (RealScreen.w / screen.w)) >= 100) and
          (round(event.button.x / (RealScreen.w / screen.w)) < 267) and
          (round(event.button.y / (RealScreen.h / screen.h)) >= 50) and
          (round(event.button.y / (RealScreen.h / screen.h)) < 3 * 22 + 78) then
        begin
          menup := menu;
          menu := (round(event.button.y / (RealScreen.h / screen.h)) - 52) div 22;
          if menu > 2 then
            menu := 2;
          if menu < 0 then
            menu := 0;
          if menup <> menu then
            showModemenu(menu);
        end
        else
          menu := -1;
      end;
    end;
  end;


  Result := menu;
  redraw;
  setlength(menustring, 0);
  setlength(menuengstring, 0);
  //SDL_EnableKeyRepeat(30,35);
end;

//显示模式选单

procedure ShowModeMenu(menu: integer);
var
  i, x, y: integer;
begin

  x := 157;
  y := 50;
  //{$IFDEF DARWIN}
  RegionRect.x := x;
  RegionRect.y := y;
  RegionRect.w := 76;
  RegionRect.h := 75;
  //{$ENDIF}
  redraw;
  //{$IFDEF DARWIN}
  RegionRect.w := 0;
  RegionRect.h := 0;
  //{$ENDIF}
  DrawRectangle(x, y, 75, 74, 0, colcolor(255), 30);
  for i := 0 to 2 do
  begin
    if (i = menu) then
    begin
      drawshadowtext(@menustring[i][1], x - 17, 53 + 22 * i, colcolor($64), colcolor($66));
    end
    else
    begin
      drawshadowtext(@menustring[i][1], x - 17, 53 + 22 * i, colcolor($21), colcolor($23));
    end;
  end;
  SDL_UpdateRect2(screen, x, y, 169, 96);

end;

function TeamModeMenu: boolean;
var
  menup, x, y, w, menu, i, amount: integer;
  a: array of smallint;
  tempmode: array of integer;
begin
  x := 154;
  y := 50;
  w := 190;
  //SDL_EnableKeyRepeat(20, 100);
  Result := True;
  amount := 0;
  for i := 0 to broleamount - 1 do
  begin
    if (Brole[i].Team = 0) and (Brole[i].Dead = 0) then
    begin
      amount := amount + 1;
      setlength(a, amount);
      a[amount - 1] := i;
    end;
  end;
  setlength(tempmode, length(AutoMode));
  for i := 0 to broleamount - 1 do
  begin
    tempmode[i] := AutoMode[i];
  end;
  //for i := 0 to length(a) - 1 do
  //AutoMode[a[i]] := 0;
  menu := 0;
  showTeamModemenu(menu);
  while (SDL_WaitEvent(@event) >= 0) do
  begin
    CheckBasicEvent;
    case event.type_ of
      SDL_KEYUP:
      begin
        if (event.key.keysym.sym = sdlk_return) or (event.key.keysym.sym = sdlk_space) then
        begin
            {if menu = -2 then
              break
            else
            begin
              AutoMode[a[menu]] := AutoMode[a[menu]] + 1;
              if AutoMode[a[menu]] > 2 then AutoMode[a[menu]] := -1;
              showTeamModemenu(menu);
            end;}
          break;
        end;
        if (event.key.keysym.sym = sdlk_escape) then
        begin
          Result := False;
          break;
        end;
        //end;
        //SDL_KEYDOWN:
        //begin
        if (event.key.keysym.sym = sdlk_up) then
        begin
          menu := menu - 1;
          if menu = -1 then
            menu := -2;
          if menu = -3 then
            menu := amount - 1;
          showTeamModemenu(menu);
        end;
        if (event.key.keysym.sym = sdlk_down) then
        begin
          menu := menu + 1;
          if menu = amount then
            menu := -2;
          if menu = -1 then
            menu := 0;
          showTeamModemenu(menu);
        end;
        if (event.key.keysym.sym = sdlk_left) then
        begin
          AutoMode[a[menu]] := AutoMode[a[menu]] - 1;
          if AutoMode[a[menu]] < -1 then
            AutoMode[a[menu]] := 2;
          showTeamModemenu(menu);
        end;
        if (event.key.keysym.sym = sdlk_right) then
        begin
          AutoMode[a[menu]] := AutoMode[a[menu]] + 1;
          if AutoMode[a[menu]] > 2 then
            AutoMode[a[menu]] := -1;
          showTeamModemenu(menu);
        end;
      end;
      SDL_MOUSEBUTTONUP:
      begin
        if (event.button.button = sdl_button_left) then
        begin
          if (menu > -1) then
          begin
            AutoMode[a[menu]] := AutoMode[a[menu]] + 1;
            if AutoMode[a[menu]] > 2 then
              AutoMode[a[menu]] := -1;
            showTeamModemenu(menu);
          end
          else if (menu = -2) then
          begin
            break;
          end;
        end;
        if (event.button.button = sdl_button_right) then
        begin
          Result := False;
          break;
        end;
      end;
      SDL_MOUSEMOTION:
      begin
        if (round(event.button.x / (RealScreen.w / screen.w)) >= x) and
          (round(event.button.x / (RealScreen.w / screen.w)) < x + w) and
          (round(event.button.y / (RealScreen.h / screen.h)) >= y) and
          (round(event.button.y / (RealScreen.h / screen.h)) < amount * 22 + 78) then
        begin
          menup := menu;
          menu := (round(event.button.y / (RealScreen.h / screen.h)) - y) div 22;
          if menu < 0 then
            menu := 0;
          if menu >= amount then
            menu := -2;
          if menup <> menu then
            showTeamModemenu(menu);
        end
        else
          menu := -1;
      end;
    end;
    event.key.keysym.sym := 0;
    event.button.button := 0;
  end;
  //SDL_EnableKeyRepeat(30,35);
  redraw;
  if Result = False then
    for i := 0 to broleamount - 1 do
      AutoMode[i] := tempmode[i];

end;

procedure ShowTeamModeMenu(menu: integer);
var
  i, amount, x, y, w, h: integer;
  modestring: array[-1..2] of WideString;
  namestr: array of WideString;
  str: WideString;
  a: array of smallint;
begin
  amount := 0;
  x := 154;
  y := 50;
  w := 190;
  modestring[0] := ' 瘋子型';
  modestring[1] := ' 傻子型';
  modestring[2] := ' 呆子型';
  modestring[-1] := ' 手动';
  str := '  确定';
  for i := 0 to broleamount - 1 do
  begin
    if (Brole[i].Team = 0) and (Brole[i].Dead = 0) then
    begin
      amount := amount + 1;
      setlength(namestr, amount);
      setlength(a, amount);
      namestr[amount - 1] := ' ' + big5tounicode(@rrole[brole[i].rnum].Name[0]);
      a[amount - 1] := AutoMode[i];
    end;
  end;
  h := amount * 22 + 32;
  //{$IFDEF DARWIN}
  RegionRect.x := x;
  RegionRect.y := y;
  RegionRect.w := w + 1;
  RegionRect.h := h + 1;
  //{$ENDIF}
  redraw;
  //{$IFDEF DARWIN}
  RegionRect.w := 0;
  RegionRect.h := 0;
  //{$ENDIF}
  DrawRectangle(x, y, w, h, 0, colcolor(255), 30);
  for i := 0 to amount - 1 do
  begin
    if (i = menu) then
    begin
      drawshadowtext(@namestr[i][1], x - 17, 53 + 22 * i, colcolor($64), colcolor($66));
      //SDL_UpdateRect2(screen, x, y,w+2, h+2);
      drawshadowtext(@modestring[a[i]][1], x + 100 - 17, 53 + 22 * i, colcolor($64), colcolor($66));
      //SDL_UpdateRect2(screen, x, y,w+2, h+2);
    end
    else
    begin
      drawshadowtext(@namestr[i][1], x - 17, 53 + 22 * i, colcolor($21), colcolor($23));
      //SDL_UpdateRect2(screen, x, y,w+2, h+2);
      drawshadowtext(@modestring[a[i]][1], x + 100 - 17, 53 + 22 * i, colcolor($21), colcolor($23));
      //SDL_UpdateRect2(screen, x, y,w+2, h+2);
    end;

  end;
  if menu = -2 then
    drawshadowtext(@str[1], x - 17, 53 + 22 * amount, colcolor($64), colcolor($66))
  else
    drawshadowtext(@str[1], x - 17, 53 + 22 * amount, colcolor($21), colcolor($23));
  SDL_UpdateRect2(screen, x, y, w + 2, h + 2);

end;


procedure Auto(bnum: integer);
var
  a, i, menu: integer;
begin
  //setlength(menustring, 2);
  //menustring[1] := ' 單人';
  //menustring[0] := ' 全體';
  //menu := commonmenu2(157, 50, 98);
  //SDL_EnableKeyRepeat(20, 100);
  //if menu = -1 then
  //  exit;

  //redraw;
  //SDL_UpdateRect2(screen, 157, 50, 100, 35);


  //if menu=1 then AutoMode[bnum]:= SelectAutoMode ;
  //if menu=0 then
  if not TeamModeMenu then
    exit;

  //if AutoMode[bnum]=-1 then
  //begin
  //  exit;
  //end
  //else
  //begin
  //  if  menu = 0 then
  //  begin
  for i := 0 to broleamount - 1 do
  begin
    if (Brole[i].Team = 0) and (Brole[i].Dead = 0) then
    begin
      if AutoMode[i] = -1 then
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
    AutoBattle2(bnum);
    Brole[bnum].Acted := 1;
  end;
  //end;

end;

//特技乱石嶙峋

procedure PutStone(bnum, mnum, level: integer);
var
  stonenum, i, x, y: integer;
  r: boolean;
  pos: TPosition;
begin
  if Brole[bnum].Team = 0 then
    ShowMagicName(mnum);
  instruct_67(Rmagic[mnum].SoundNum);
  PlayActionAmination(bnum, Rmagic[mnum].MagicType); //动画效果

  stonenum := rmagic[mnum].attack[0] + ((rmagic[mnum].attack[1] - rmagic[mnum].attack[0]) * level div 10);
  CalCanSelect(bnum, 1, rmagic[mnum].MoveDistance[level - 1]);
  for i := 0 to stonenum - 1 do
  begin
    Ax := Bx;
    Ay := By;

    while (Bfield[2, Ax, Ay] <> -1) or (Bfield[1, Ax, Ay] <> 0) do
      while not SelectRange(bnum, 0, rmagic[mnum].MoveDistance[level - 1], 0) do ;

    Bfield[1, Ax, Ay] := 1487 * 2;
    x := -Ax * 18 + Ay * 18 + 1151;
    y := Ax * 9 + Ay * 9 + 9 + 250;
    InitialBPic2(1487, x, y, 1, Ax + Ay); //建筑层需遮挡值
    redraw;
  end;
  InitialWholeBField;
end;

//特技同仇敌忾，多人围殴目标敌人

procedure gangbeat(bnum, mnum, level: integer);
var
  gridnum, Ax1, Ax2, Ay1, Ay2, x, y: integer;
  attackbnum, attackmnum, attacklevel, hurt: integer;
begin
  gridnum := rmagic[mnum].attack[0] + (rmagic[mnum].attack[1] - rmagic[mnum].attack[0]) * level div 10;
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

  Bfield[4, Ax, Ay] := 1;
  for x := Ax1 to Ax2 do
    for y := Ay1 to Ay2 do
    begin
      if Bfield[2, x, y] > -1 then
        if (Brole[Bfield[2, x, y]].Dead = 0) and (Brole[Bfield[2, x, y]].Team = Brole[bnum].Team) then
        begin
          attackbnum := Bfield[2, x, y];
          attackmnum := rrole[brole[attackbnum].rnum].magic[1];
          attacklevel := rrole[brole[attackbnum].rnum].maglevel[1] div 100 + 1;
          //AttackAction(attackbnum, attackmnum, attacklevel);
          ShowMagicName(attackmnum);
          instruct_67(Rmagic[attackmnum].SoundNum);
          PlayActionAmination(attackbnum, Rmagic[attackmnum].MagicType); //动画效果
          CalHurtRole(attackbnum, attackmnum, attacklevel, 1); //计算被打到的人物
          PlayMagicAmination(attackbnum, Rmagic[attackmnum].AmiNum); //武功效果
          ShowHurtValue(rmagic[attackmnum].HurtType); //显示数字
        end;
    end;
end;

//乱世浮萍，把行动机会让给目标队友

procedure duckweed(bnum, mnum, level: integer);
var
  bnum2, oldactstatus: integer;
begin
  bnum2 := Bfield[2, Ax, Ay];
  Bx := Ax;
  By := Ay;
  if bnum2 >= 0 then
  begin
    if Brole[bnum2].Team = Brole[bnum].Team then
    begin
      oldactstatus := Brole[bnum2].Acted;
      Brole[bnum2].Acted := 0;
      while Brole[bnum2].Acted = 0 do
      begin
        case BattleMenu(bnum2) of
          0: MoveRole(bnum2);
          1: Attack(bnum2);
          2: UsePoision(bnum2);
          3: MedPoision(bnum2);
          4: Medcine(bnum2);
          5: BattleMenuItem(bnum2);
          6: Wait(bnum2);
          7: Selectshowstatus(bnum2);
          8: Rest(bnum2);
          9: Rest(bnum2);
        end;
      end;
      Brole[bnum2].Acted := oldactstatus;
      rrole[Brole[bnum].rnum].CurrentMP := rrole[Brole[bnum].rnum].CurrentMP - rmagic[mnum].NeedMP * level;
      if rrole[Brole[bnum].rnum].CurrentMP < 0 then
        rrole[Brole[bnum].rnum].CurrentMP := 0;
    end;
  end;
  brole[bnum].Acted := 1;
end;

//神照功，复活队友

procedure GodBless(bnum, mnum, level: integer);
var
  i, res, newlife, amount: integer;
  bnumarray: array of smallint;
begin
  if (Bfield[2, Ax, Ay] = -1) and (rrole[brole[bnum].rnum].CurrentHP > 1) then
  begin
    setlength(Menustring, 6);
    setlength(bnumarray, 6);
    amount := 0;
    for i := 0 to BRoleAmount - 1 do
    begin
      if (Brole[i].Team = Brole[bnum].Team) and (brole[i].Dead = 1) then
      begin
        menustring[amount] := Big5toUnicode(@RRole[Brole[i].rnum].Name);
        menuengstring[amount] := '';
        bnumarray[amount] := i;
        amount := amount + 1;
      end;
    end;

    if amount > 0 then
    begin
      res := commonmenu(300, 200, 105 + length(menuengstring[0]) * 10, amount - 1);
      newlife := rrole[brole[bnum].rnum].MaxHP * 35 div 100;
      if newlife > rrole[brole[bnum].rnum].CurrentHP - 1 then
        newlife := rrole[brole[bnum].rnum].CurrentHP - 1;
      rrole[brole[bnum].rnum].CurrentHP := rrole[brole[bnum].rnum].CurrentHP - newlife;
      if rrole[brole[bnum].rnum].CurrentHP < 1 then
        rrole[brole[bnum].rnum].CurrentHP := 1;
      brole[bnumarray[res]].Dead := 0;
      rrole[brole[bnumarray[res]].rnum].CurrentHP := newlife;
      if rrole[brole[bnumarray[res]].rnum].CurrentHP > rrole[brole[bnumarray[res]].rnum].MaxHP then
        rrole[brole[bnumarray[res]].rnum].CurrentHP := rrole[brole[bnumarray[res]].rnum].MaxHP;
      Brole[bnumarray[res]].X := Ax;
      Brole[bnumarray[res]].Y := Ay;
      Bfield[2, Ax, Ay] := bnumarray[res];
    end
    else
    begin
      rrole[brole[bnum].rnum].CurrentHP := rrole[brole[bnum].rnum].CurrentHP + 600;
      if rrole[brole[bnum].rnum].CurrentHP > rrole[brole[bnum].rnum].MaxHP then
        rrole[brole[bnum].rnum].CurrentHP := rrole[brole[bnum].rnum].MaxHP;
    end;
  end
  else
  begin
    rrole[brole[bnum].rnum].CurrentHP := rrole[brole[bnum].rnum].CurrentHP + 600;
    if rrole[brole[bnum].rnum].CurrentHP > rrole[brole[bnum].rnum].MaxHP then
      rrole[brole[bnum].rnum].CurrentHP := rrole[brole[bnum].rnum].MaxHP;
  end;
  rrole[brole[bnum].rnum].CurrentMP := rrole[brole[bnum].rnum].CurrentMP - rmagic[mnum].NeedMP * level;
  if rrole[brole[bnum].rnum].CurrentMP < 0 then
    rrole[brole[bnum].rnum].CurrentMP := 0;
  PlayMagicAmination(bnum, Rmagic[mnum].AmiNum);
  Brole[bnum].Acted := 1;
end;

//神行百变，直线敌人随机陷入负面状态

procedure GhostChange(bnum, mnum, level: integer);
var
  bnumarray, bnumx, bnumy: array[0..30] of smallint;
  enemyamount, aimx, aimy, i, incx, incy, si, sn, sl, sr: smallint;
begin
  enemyamount := 0;
  incx := Ax - Bx;
  incy := Ay - By;
  aimx := Ax;
  aimy := Ay;
  while True do
  begin
    if Bfield[2, aimx, aimy] <> -1 then
    begin
      if brole[Bfield[2, aimx, aimy]].Team <> brole[bnum].team then
      begin
        bnumarray[enemyamount] := Bfield[2, aimx, aimy];
        bnumx[enemyamount] := aimx;
        bnumy[enemyamount] := aimy;
        enemyamount := enemyamount + 1;
      end;
    end
    else
    if Bfield[1, aimx, aimy] = 0 then
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
    for I := 0 to enemyamount - 1 do
    begin
      si := random(5);
      sn := rmagic[mnum].addmp[si + 1];
      sl := rmagic[mnum].attack[si * 2] + (rmagic[mnum].attack[si * 2 + 1] - rmagic[mnum].attack[si * 2]) *
        level div 10;
      sr := rmagic[mnum].hurtmp[level - 1];
      if sl < brole[bnumarray[i]].statelevel[sn] then
        brole[bnumarray[i]].statelevel[sn] := sl;
      if sr > brole[bnumarray[i]].stateround[sn] then
        brole[bnumarray[i]].stateround[sn] := sr;

      rrole[brole[bnumarray[i]].rnum].CurrentHP:= rrole[brole[bnumarray[i]].rnum].CurrentHP -
        rrole[brole[bnumarray[i]].rnum].MaxHP div 10;
      if rrole[brole[bnumarray[i]].rnum].CurrentHP < 1 then rrole[brole[bnumarray[i]].rnum].CurrentHP:=1;

      Bfield[4, bnumx[i], bnumy[i]] := 1;
    end;
    Bfield[2, Bx, By] := -1;
    Bfield[2, aimx, aimy] := bnum;
    brole[bnum].X := aimx;
    brole[bnum].Y := aimy;
    PlayMagicAmination(bnum, Rmagic[mnum].AmiNum);
  end;
  Brole[bnum].Acted := 1;
end;

//万里独行

procedure LongWalk(bnum, mnum, level: integer);
var
  oldx, oldy, step, range, AttAreaType, rnum, hurtvalue: integer;
begin
  oldx := bx;
  oldy := by;
  moveRole(bnum);
  step := Rmagic[mnum].MoveDistance[level - 1];
  range := Rmagic[mnum].AttDistance[level - 1];
  AttAreaType := Rmagic[mnum].AttAreaType;
  CalCanSelect(bnum, 1, step);
  if SelectDirector(bnum, AttAreaType, step, range) then
  begin
    SetAminationPosition(AttAreaType, step, range);

    //此处默认万里独行是第一个武功，对第一个武功增加经验
    rnum := brole[bnum].rnum;
    Rrole[rnum].MagLevel[0] := Rrole[rnum].MagLevel[0] + random(2) + 1;
    if Rrole[rnum].MagLevel[0] > 999 then
      Rrole[rnum].MagLevel[0] := 999;
    if Brole[bnum].Team = 0 then
      ShowMagicName(mnum);
    instruct_67(Rmagic[mnum].SoundNum);
    PlayActionAmination(bnum, Rmagic[mnum].MagicType); //动画效果
    if Bfield[2, Ax, Ay] > 0 then
      if Brole[Bfield[2, Ax, Ay]].Team <> Brole[bnum].Team then
      begin
        hurtvalue := 350 * (abs(Bx - oldx) + abs(By - oldy));
        Bfield[4, Ax, Ay] := 1;
        Brole[Bfield[2, Ax, Ay]].ShowNumber := hurtvalue;
        rrole[Brole[Bfield[2, Ax, Ay]].rnum].CurrentHP := rrole[Brole[Bfield[2, Ax, Ay]].rnum].CurrentHP - hurtvalue;
        if rrole[Brole[Bfield[2, Ax, Ay]].rnum].CurrentHP < 0 then
          rrole[Brole[Bfield[2, Ax, Ay]].rnum].CurrentHP := 0;
        PlayMagicAmination(bnum, Rmagic[mnum].AmiNum); //武功效果
        ShowHurtValue(rmagic[mnum].HurtType); //显示数字
      end;
  end;
  Brole[bnum].Acted := 1;
end;

//策马啸西风，装备马匹者，移动+2

procedure slashhorse(bnum, mnum, level: integer);
var
  i: integer;
begin
  for I := 0 to broleamount - 1 do
  begin
    if (rrole[brole[i].rnum].Equip[1] = 60) or (rrole[brole[i].rnum].Equip[1] = 61) then
    begin
      brole[i].StateLevel[3] := 2;
      if brole[i].StateRound[3] < 3 then
        brole[i].StateRound[3] := 3;
      rrole[brole[bnum].rnum].CurrentMP := rrole[brole[bnum].rnum].CurrentMP - rmagic[mnum].NeedMP * (level - 1);
      if rrole[brole[bnum].rnum].CurrentMP < 0 then
        rrole[brole[bnum].rnum].CurrentMP := 0;
      if rrole[brole[bnum].rnum].CurrentMP > rrole[brole[bnum].rnum].MaxMP then
        rrole[brole[bnum].rnum].CurrentMP := rrole[brole[i].rnum].MaxHP;
      Bfield[4, brole[i].X, brole[i].Y] := 1;
    end;
  end;
  CalMoveAbility;
  brole[bnum].Acted := 1;
  PlayMagicAmination(bnum, Rmagic[mnum].AmiNum);
end;


//侠之大者，全体队友获得五种正面状态

procedure HeroicSpirit(bnum, mnum, level: integer);
var
  i, j, sl: integer;
begin
  for I := 0 to broleamount - 1 do
  begin
    if brole[i].Team = brole[bnum].team then
    begin
      for j := 0 to 4 do
      begin
        if rmagic[mnum].AddMP[1 + j] >= 0 then
        begin
          sl := rmagic[mnum].attack[j * 2] + (rmagic[mnum].attack[j * 2 + 1] - rmagic[mnum].attack[j * 2]) *
            level div 10;
          brole[i].statelevel[rmagic[mnum].AddMP[1 + j]] := sl;
          if brole[i].StateRound[rmagic[mnum].AddMP[1 + j]] < 3 then
            brole[i].StateRound[rmagic[mnum].AddMP[1 + j]] := 3;
        end;
      end;
    end;
  end;
  brole[bnum].Acted := 1;
  PlayMagicAmination(bnum, Rmagic[mnum].AmiNum);
end;


//赏善，将目标队友的正面状态分享给所有队员

procedure Rewardgoodness(bnum, mnum, level: integer);
var
  i, j: integer;
  aimbrole: TBattleRole;
begin
  if Bfield[2, Ax, Ay] >= 0 then
  begin
    aimbrole := brole[Bfield[2, Ax, Ay]];
    if aimbrole.Team = brole[bnum].Team then
    begin
      for I := 0 to broleamount - 1 do
      begin
        if (brole[i].Team = aimbrole.Team) and (brole[i].rnum <> aimbrole.rnum) then
        begin
          for j := 0 to 20 do
          begin
            if aimbrole.StateLevel[j] > 0 then
            begin
              brole[i].StateLevel[j] := aimbrole.StateLevel[j];
              brole[i].StateRound[j] := 3;
            end;
          end;
          Bfield[4, brole[i].X, brole[i].Y] := 1;
        end;
      end;
      PlayMagicAmination(bnum, Rmagic[mnum].AmiNum);
    end;
  end;
  brole[bnum].Acted := 1;
end;




//罚恶，将目标敌人的负面状态分享给所有敌人

procedure PunishEvil(bnum, mnum, level: integer);
var
  i, j: integer;
  aimbrole: TBattleRole;
begin
  if Bfield[2, Ax, Ay] >= 0 then
  begin
    aimbrole := brole[Bfield[2, Ax, Ay]];
    if aimbrole.Team <> brole[bnum].Team then
    begin
      for I := 0 to broleamount - 1 do
      begin
        if (brole[i].Team = aimbrole.Team) and (brole[i].rnum <> aimbrole.rnum) then
        begin
          for j := 0 to 6 do
          begin
            if (j = 2) or (j = 4) then
              continue;
            if aimbrole.StateLevel[j] < 0 then
            begin
              brole[i].StateLevel[j] := aimbrole.StateLevel[j];
              brole[i].StateRound[j] := 3;
            end;
          end;
          Bfield[4, brole[i].X, brole[i].Y] := 1;
        end;
      end;
      PlayMagicAmination(bnum, Rmagic[mnum].AmiNum);
    end;
  end;
  brole[bnum].Acted := 1;
end;


//韦编三绝，控制目标敌人

procedure ControlEnemy(bnum, mnum, level: integer);
var
  i, Pctrl, Pm, aimBnum: integer;
begin
  Pctrl := random(100);
  Pm := Rmagic[mnum].attack[0] + (Rmagic[mnum].attack[1] - Rmagic[mnum].attack[0]) * level div 10;
  if Pctrl < Pm then
  begin
    aimBnum := Bfield[2, Ax, Ay];
    if aimBnum >= 0 then
      if Brole[aimBnum].Team <> Brole[bnum].Team then
      begin
        Brole[aimBnum].StateLevel[27] := -1;
        Brole[aimBnum].StateRound[27] := 3;
        Brole[aimBnum].Team := 1 - Brole[aimBnum].Team;
        Bfield[4, Ax, Ay] := 1;
      end;
  end;
  Brole[bnum].Acted := 1;
  PlayMagicAmination(bnum, Rmagic[mnum].AmiNum);
end;


//断己相杀，与目标敌人死磕，直至一方死亡

procedure PKuntildie(bnum, mnum, level: integer);
var
  i, Anum, rnumA, rnumB, hurt: integer;
  cmnum, cmlevel, cmatt, hmnumA, hmlevelA, hmattA, hmnumB, hmlevelB, hmattB: integer;
begin
  Anum := Bfield[2, Ax, Ay];
  if Anum >= 0 then
    if Brole[Anum].Team <> Brole[bnum].Team then
    begin
      hmattA := 0;
      hmnumA := 0;
      for I := 0 to 10 - 1 do
      begin
        cmnum := rrole[brole[Anum].rnum].magic[i];
        if cmnum <= 0 then
          break;
        if rmagic[cmnum].HurtType = 2 then
          continue;
        cmlevel := rrole[brole[Anum].rnum].maglevel[i] div 100 + 1;
        cmatt := rmagic[cmnum].attack[0] + (rmagic[cmnum].attack[1] - rmagic[cmnum].attack[0]) * cmlevel div 10;
        if cmatt > hmattA then
        begin
          hmnumA := cmnum;
          hmlevelA := cmlevel;
          hmattA := cmatt;
        end;
      end;
      hmattB := 0;
      hmnumB := 0;
      for I := 0 to 10 - 1 do
      begin
        cmnum := rrole[brole[bnum].rnum].magic[i];
        if cmnum <= 0 then
          break;
        if rmagic[cmnum].HurtType = 2 then
          continue;
        cmlevel := rrole[brole[bnum].rnum].maglevel[i] div 100 + 1;
        cmatt := rmagic[cmnum].attack[0] + (rmagic[cmnum].attack[1] - rmagic[cmnum].attack[0]) * cmlevel div 10;
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
        Bfield[4, brole[Anum].X, brole[Anum].Y] := 1;
        Bx := brole[Anum].X;
        By := brole[Anum].Y;
        Ax := brole[Bnum].X;
        Ay := brole[Bnum].Y;
        PlayMagicAmination(bnum, Rmagic[hmnumB].AmiNum);
        Brole[Anum].ShowNumber := hurt;
        ShowHurtValue(rmagic[hmnumB].HurtType);
        Bfield[4, brole[Anum].X, brole[Anum].Y] := 0;
        Brole[Anum].ShowNumber := 0;
        rrole[rnumA].CurrentHP := rrole[rnumA].CurrentHP - hurt;
        if rrole[rnumA].CurrentHP <= 0 then
        begin
          rrole[rnumA].CurrentHP := 0;
          break;
        end;

        ShowMagicName(hmnumA);
        instruct_67(Rmagic[hmnumA].SoundNum);
        PlayActionAmination(Anum, Rmagic[hmnumA].MagicType);
        hurt := CalHurtValue(Anum, Bnum, hmnumA, hmlevelA, 1);
        Bfield[4, brole[Bnum].X, brole[Bnum].Y] := 1;
        Bx := brole[Bnum].X;
        By := brole[Bnum].Y;
        Ax := brole[Anum].X;
        Ay := brole[Anum].Y;
        PlayMagicAmination(Anum, Rmagic[hmnumA].AmiNum);
        Brole[Bnum].ShowNumber := hurt;
        ShowHurtValue(rmagic[hmnumA].HurtType);
        Brole[Bnum].ShowNumber := 0;
        Bfield[4, brole[Bnum].X, brole[Bnum].Y] := 0;
        rrole[rnumB].CurrentHP := rrole[rnumB].CurrentHP - hurt;
        if rrole[rnumB].CurrentHP <= 0 then
        begin
          rrole[rnumB].CurrentHP := 0;
          break;
        end;
      end;
      rrole[rnumB].CurrentMP := rrole[rnumB].CurrentMP - rmagic[mnum].NeedMP * level;
      if rrole[rnumB].CurrentMP < 0 then
        rrole[rnumB].CurrentMP := 0;
      rrole[rnumA].CurrentMP := rrole[rnumA].CurrentMP - rmagic[mnum].NeedMP * level;
      if rrole[rnumA].CurrentMP < 0 then
        rrole[rnumA].CurrentMP := 0;
    end;
  Brole[bnum].Acted := 1;
end;


//七窍玲珑，将目标队友的正面状态延长

procedure ExtendRound(bnum, mnum, level: integer);
var
  i, j, ERound, aimbnum: integer;
begin
  for j := 0 to broleamount - 1 do
  begin
    if (Bfield[4, brole[j].X, brole[j].Y] <> 0) and (brole[j].Team = brole[bnum].Team) then
    begin
      aimbnum := j;
      if brole[aimbnum].Team = brole[bnum].Team then
      begin
        ERound := Rmagic[mnum].attack[0] + (Rmagic[mnum].attack[1] - Rmagic[mnum].attack[0]) * level div 10;
        for I := 0 to STATUS_AMOUNT - 3 do
        begin
          if brole[aimbnum].StateLevel[i] > 0 then
            brole[aimbnum].StateRound[i] := brole[aimbnum].StateRound[i] + ERound;
        end;
      end;
    end;
  end;
  PlayMagicAmination(bnum, Rmagic[mnum].AmiNum);
  brole[bnum].Acted := 1;
end;


//特技排兵布阵，改变目标队友的位置

procedure tactics(bnum, mnum, level: integer);
var
  i, x, y, aimbnum: integer;
  r: boolean;
  aimbrole: TBattleRole;
begin
  if Bfield[2, Ax, Ay] >= 0 then
  begin
    aimbnum := Bfield[2, Ax, Ay];
    aimbrole := Brole[Bfield[2, Ax, Ay]];
    if aimbrole.Team = brole[bnum].team then
    begin
      while Bfield[2, Ax, Ay] <> -1 do
        while not SelectRange(bnum, 0, rmagic[mnum].MoveDistance[level - 1], 0) do ;

      ShowMagicName(mnum);
      instruct_67(Rmagic[mnum].SoundNum);
      PlayActionAmination(bnum, Rmagic[mnum].MagicType);

      Bfield[2, aimbrole.X, aimbrole.Y] := -1;
      brole[aimbnum].X := Ax;
      brole[aimbnum].Y := Ay;
      Bfield[2, Ax, Ay] := aimbnum;
    end;
  end;
  Brole[bnum].Acted := 1;
end;


//先天一阳指，直线攻击，敌人减血，并有一定概率定身，我方加血

procedure xiantianyiyang(bnum, mnum, level: integer);
var
  i, rand, rnum, hurt: integer;
begin
  ShowMagicName(mnum);
  instruct_67(Rmagic[mnum].SoundNum);
  PlayActionAmination(bnum, Rmagic[mnum].MagicType); //动画效果

  rnum := brole[bnum].rnum;
  rrole[rnum].PhyPower := rrole[rnum].PhyPower - 3;
  if RRole[rnum].CurrentMP < rmagic[mnum].NeedMP * ((level + 1) div 2) then
    level := RRole[rnum].CurrentMP div rmagic[mnum].NeedMP * 2;
  if level > 10 then
    level := 10;

  //消耗内力
  RRole[rnum].CurrentMP := RRole[rnum].CurrentMP - rmagic[mnum].NeedMP * ((level + 1) div 2);

  //消耗体力
  //RRole[rnum].PhyPower := RRole[rnum].PhyPower - rmagic[mnum].NeedMP div 2;
  RRole[rnum].PhyPower := RRole[rnum].PhyPower - 3;
  if RRole[rnum].PhyPower < 0 then
    RRole[rnum].PhyPower := 0;

  for i := 0 to broleamount - 1 do
  begin
    if (Bfield[4, Brole[i].X, Brole[i].Y] <> 0) and (Brole[i].Dead = 0) and (bnum <> i) then
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
        if rand < rmagic[mnum].attack[6] + (rmagic[mnum].attack[7] - rmagic[mnum].attack[6]) * level div 10 then
        begin
          brole[i].StateLevel[26] := -1;
          brole[i].StateRound[26] := 3;
        end;

        if Rrole[Brole[i].rnum].Hurt > 99 then
          Rrole[Brole[i].rnum].Hurt := 99;
        //出手一次，获得1到10的经验值
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
        hurt := rmagic[mnum].attack[4] + (rmagic[mnum].attack[5] - rmagic[mnum].attack[4]) * level div 10;
        rrole[brole[i].rnum].CurrentHP := rrole[brole[i].rnum].CurrentHP + rrole[brole[i].rnum].MaxHP * hurt div 100;
        if (rrole[brole[i].rnum].CurrentHP > rrole[brole[i].rnum].MaxHP) then
          rrole[brole[i].rnum].CurrentHP := rrole[brole[i].rnum].MaxHP;
        Brole[i].ShowNumber := rrole[brole[i].rnum].MaxHP * hurt div 100;
      end;
    end;
  end;

  PlayMagicAmination(bnum, Rmagic[mnum].AmiNum); //武功效果
  ShowHurtValue(3); //显示数字

end;

//吸星大法，直线攻击，吸内，并拉近目标

procedure xixing(bnum, mnum, level: integer);
var
  i, incx, incy, curx, cury, aimx, aimy, aimbnum, hurt, rnum: integer;
begin
  ShowMagicName(mnum);
  instruct_67(Rmagic[mnum].SoundNum);
  PlayActionAmination(bnum, Rmagic[mnum].MagicType);

  rnum := brole[bnum].rnum;
  incx := Ax - Bx;
  incy := Ay - By;
  curx := Bx;
  cury := By;
  for i := 0 to rmagic[mnum].movedistance[level - 1] - 1 do
  begin
    curx := curx + incx;
    cury := cury + incy;
    if Bfield[2, curx, cury] >= 0 then
    begin
      aimbnum := Bfield[2, curx, cury];
      aimx := curx;
      aimy := cury;
      while (Bfield[2, aimx - incx, aimy - incy] < 0) and (Bfield[1, aimx - incx, aimy - incy] <= 0) do
      begin
        aimx := aimx - incx;
        aimy := aimy - incy;
      end;
      Bfield[2, curx, cury] := -1;
      Bfield[2, aimx, aimy] := aimbnum;
      brole[aimbnum].X := aimx;
      brole[aimbnum].Y := aimy;

      hurt := rmagic[mnum].HurtMP[level - 1] + random(5) - random(5);
      Brole[aimbnum].ShowNumber := hurt;
      Rrole[Brole[aimbnum].rnum].CurrentMP := Rrole[Brole[aimbnum].rnum].CurrentMP - hurt;
      if Rrole[Brole[aimbnum].rnum].CurrentMP <= 0 then
        Rrole[Brole[aimbnum].rnum].CurrentMP := 0;

      Brole[aimbnum].StateLevel[0]:= -5 * level;
      Brole[aimbnum].StateRound[0]:= level;
      Brole[aimbnum].StateLevel[1]:= -5 * level;
      Brole[aimbnum].StateRound[1]:= level;


      //增加己方内力及最大值
      Rrole[rnum].CurrentMP := RRole[rnum].CurrentMP + hurt;
      RRole[rnum].MaxMP := RRole[rnum].MaxMP + random(hurt div 2);
      if RRole[rnum].MaxMP > MAX_MP then
        RRole[rnum].MaxMP := MAX_MP;
      if RRole[rnum].CurrentMP > RRole[rnum].MaxMP then
        RRole[rnum].CurrentMP := RRole[rnum].MaxMP;

    end;
  end;
  PlayMagicAmination(bnum, Rmagic[mnum].AmiNum); //武功效果
  ShowHurtValue(rmagic[mnum].HurtType); //显示数字
end;


//森罗万象，学会场上某队友的特技，10级为从全部队友中选择

procedure senluo(bnum, mnum, level: integer);
var
  i, amount, res, ss, rnum: integer;
  mnumarray: array of smallint;
  namemagic: string;
begin
  ShowMagicName(mnum);
  instruct_67(Rmagic[mnum].SoundNum);
  PlayActionAmination(bnum, Rmagic[mnum].MagicType); //动画效果

  rnum := brole[bnum].rnum;
  //消耗内力
  RRole[rnum].CurrentMP := RRole[rnum].CurrentMP - rmagic[mnum].NeedMP * ((level + 1) div 2);
  if RRole[rnum].CurrentMP < 0 then
    RRole[rnum].CurrentMP := 0;


  //消耗体力
  RRole[rnum].PhyPower := RRole[rnum].PhyPower - 3;
  if RRole[rnum].PhyPower < 0 then
    RRole[rnum].PhyPower := 0;

  amount := 0;
  if level < 10 then
  begin
    setlength(Menustring, 12);
    setlength(mnumarray, 12);
    amount := 0;
    for i := 0 to BRoleAmount - 1 do
    begin
      if (Brole[i].Team = Brole[bnum].Team) and (brole[i].Dead = 0) and (i <> bnum) then
      begin
        mnumarray[amount] := RRole[Brole[i].rnum].magic[0];
        namemagic := Big5toUnicode(@RRole[Brole[i].rnum].Name) + '：' +
          Big5toUnicode(@rmagic[RRole[Brole[i].rnum].magic[0]].Name);
        //menustring[amount] := Big5toUnicode(@namemagic);
        menustring[amount] := namemagic;
        menuengstring[amount] := '';
        amount := amount + 1;
      end;
    end;
    if amount > 0 then
    begin
      res := -1;
      while res = -1 do
        res := CommonMenu(300, 200, 105 + length(menustring[0]) * 10, amount - 1);
      rrole[brole[bnum].rnum].Magic[0] := mnumarray[res];
    end;
  end
  else
  begin
    setlength(Menustring, 100);
    setlength(menuengstring, 100);
    setlength(mnumarray, 100);
    for i := 1 to 108 - 1 do
    begin
      ss := GetStarState(i);
      if (ss = 1) or (ss > 2) then
      begin
        rnum := StarToRole(i);
        mnumarray[amount] := RRole[rnum].magic[0];
        namemagic := Big5toUnicode(@RRole[rnum].Name) + '：' + Big5toUnicode(@rmagic[RRole[rnum].magic[0]].Name);
        menustring[amount] := namemagic;
        menuengstring[amount] := '';
        amount := amount + 1;
      end;
    end;
    if amount > 0 then
    begin
      res := -1;
      while res = -1 do
        res := CommonScrollMenu(300, 50, 105 + length(menustring[0]) * 10, amount - 1, 15);
      rrole[brole[bnum].rnum].Magic[0] := mnumarray[res];
    end;
  end;



  PlayMagicAmination(bnum, Rmagic[mnum].AmiNum);
  brole[bnum].Acted := 1;

end;

//十面埋伏,潇湘夜雨

procedure ambush(bnum, mnum, level, Si: integer);
var
  i, rnum: integer;
begin
  ShowMagicName(mnum);
  instruct_67(Rmagic[mnum].SoundNum);
  PlayActionAmination(bnum, Rmagic[mnum].MagicType); //动画效果

  rnum := brole[bnum].rnum;
  //消耗内力
  RRole[rnum].CurrentMP := RRole[rnum].CurrentMP - rmagic[mnum].NeedMP * ((level + 1) div 2);
  if RRole[rnum].CurrentMP < 0 then
    RRole[rnum].CurrentMP := 0;

  //消耗体力
  RRole[rnum].PhyPower := RRole[rnum].PhyPower - 3;

  if RRole[rnum].PhyPower < 0 then
    RRole[rnum].PhyPower := 0;
  for i := 0 to broleamount - 1 do
    if brole[i].Dead = 0 then
    begin
      if (brole[i].Team <> brole[bnum].team) and (brole[i].StateLevel[18] = 0) then
      begin
        if brole[i].StateLevel[Si] >= 0 then
        begin
          brole[i].StateLevel[Si] := rmagic[mnum].attack[0] + trunc(rmagic[mnum].attack[0] *
            (100 + (rmagic[mnum].attack[1] - rmagic[mnum].attack[0]) * level / 10) / 100);
          brole[i].StateRound[Si] := rmagic[mnum].HurtMP[level];
        end
        else
        begin
          brole[i].StateLevel[Si] := brole[i].StateLevel[Si] - 1;
          brole[i].StateRound[Si] := brole[i].StateRound[Si] + 1;
        end;
        bfield[4, brole[i].X, brole[i].Y] := 1;
      end;

      if brole[i].StateLevel[18] > 0 then
      begin
        if brole[i].StateLevel[Si] <= 0 then
        begin
          brole[i].StateLevel[Si] := -(rmagic[mnum].attack[0] + trunc(rmagic[mnum].attack[0] *
            (100 + (rmagic[mnum].attack[1] - rmagic[mnum].attack[0]) * level / 10) / 100));
          brole[i].StateRound[Si] := rmagic[mnum].HurtMP[level];
        end
        else
        begin
          brole[i].StateLevel[Si] := brole[i].StateLevel[Si] + 1;
          brole[i].StateRound[Si] := brole[i].StateRound[Si] + 1;
        end;
        bfield[4, brole[i].X, brole[i].Y] := 1;
      end;
    end;

  PlayMagicAmination(bnum, Rmagic[mnum].AmiNum);
  brole[bnum].Acted := 1;
end;

//千娇百媚

procedure charming(bnum, mnum, level: integer);
var
  i, rnum: integer;
begin
  ShowMagicName(mnum);
  instruct_67(Rmagic[mnum].SoundNum);
  PlayActionAmination(bnum, Rmagic[mnum].MagicType); //动画效果

  rnum := brole[bnum].rnum;
  //消耗内力
  RRole[rnum].CurrentMP := RRole[rnum].CurrentMP - rmagic[mnum].NeedMP * ((level + 1) div 2);
  if RRole[rnum].CurrentMP < 0 then
    RRole[rnum].CurrentMP := 0;

  //消耗体力
  RRole[rnum].PhyPower := RRole[rnum].PhyPower - 3;
  if RRole[rnum].PhyPower < 0 then
    RRole[rnum].PhyPower := 0;

  for i := 0 to broleamount - 1 do
  begin
    if brole[i].Team <> brole[bnum].team then
    begin
      if brole[i].StateLevel[2] >= 0 then
      begin
        brole[i].StateLevel[2] := rmagic[mnum].attack[0] + trunc(rmagic[mnum].attack[0] *
          (100 + (rmagic[mnum].attack[1] - rmagic[mnum].attack[0]) * level / 10) / 100);
        brole[i].StateRound[2] := rmagic[mnum].HurtMP[level];
      end
      else
      begin
        brole[i].StateLevel[2] := brole[i].StateLevel[2] - 1;
        brole[i].StateRound[2] := brole[i].StateRound[2] + 1;
      end;
      bfield[4, brole[i].x, brole[i].Y] := 1;
    end;
  end;

  PlayMagicAmination(bnum, Rmagic[mnum].AmiNum);
  brole[bnum].Acted := 1;
end;

//众生平等

procedure AllEqual(bnum, mnum, level: integer);
var
  i, minlife, rnum: integer;
begin
  rnum := brole[bnum].rnum;
  //消耗内力
  RRole[rnum].CurrentMP := RRole[rnum].CurrentMP - rmagic[mnum].NeedMP * ((level + 1) div 2);
  if RRole[rnum].CurrentMP < 0 then
    RRole[rnum].CurrentMP := 0;

  //消耗体力
  RRole[rnum].PhyPower := RRole[rnum].PhyPower - 3;
  if RRole[rnum].PhyPower < 0 then
    RRole[rnum].PhyPower := 0;

  minlife := rrole[brole[bnum].rnum].CurrentHP;
  for i := 0 to broleamount - 1 do
    if (brole[i].dead = 0) and (rrole[brole[i].rnum].CurrentHP < minlife) then
      minlife := rrole[brole[i].rnum].CurrentHP;

  for i := 0 to broleamount - 1 do
    if (brole[i].dead = 0) then
    begin
      rrole[brole[i].rnum].CurrentHP := minlife;
      brole[i].ShowNumber := minlife;
      bfield[4, brole[i].X, brole[i].Y] := 1;
    end;

  PlayMagicAmination(bnum, Rmagic[mnum].AmiNum);
  brole[bnum].Acted := 1;
end;

//清心普善

procedure ClearHeart(bnum, mnum, level: integer);
var
  i, addmp, rnum: integer;
begin
  ShowMagicName(mnum);
  instruct_67(Rmagic[mnum].SoundNum);
  PlayActionAmination(bnum, Rmagic[mnum].MagicType); //动画效果

  rnum := brole[bnum].rnum;
  //消耗内力
  RRole[rnum].CurrentMP := RRole[rnum].CurrentMP - rmagic[mnum].NeedMP * ((level + 1) div 2);
  if RRole[rnum].CurrentMP < 0 then
    RRole[rnum].CurrentMP := 0;

  //消耗体力
  RRole[rnum].PhyPower := RRole[rnum].PhyPower - 3;
  if RRole[rnum].PhyPower < 0 then
    RRole[rnum].PhyPower := 0;

  for i := 0 to broleamount - 1 do
    if brole[i].Dead = 0 then
    begin
      if (brole[i].Team = brole[bnum].team) and (brole[i].StateLevel[18] = 0) and (i <> bnum) then
      begin
        addmp := rrole[brole[i].rnum].MAXMP * rmagic[mnum].attack[0] * level div 100;
        if rrole[brole[i].rnum].CurrentMP + addmp > rrole[brole[i].rnum].MAXMP then
          addmp := rrole[brole[i].rnum].MAXMP - rrole[brole[i].rnum].CurrentMP;
        rrole[brole[i].rnum].CurrentMP := rrole[brole[i].rnum].CurrentMP + addmp;
        bfield[4, brole[i].X, brole[i].Y] := 1;
        //brole[i].ShowNumber:=addmp;
      end;

      if brole[i].StateLevel[18] > 0 then
      begin
        addmp := rrole[brole[i].rnum].MAXMP * rmagic[mnum].attack[0] * level div 50;
        if rrole[brole[i].rnum].CurrentMP + addmp > rrole[brole[i].rnum].MAXMP then
          addmp := rrole[brole[i].rnum].MAXMP - rrole[brole[i].rnum].CurrentMP;
        rrole[brole[i].rnum].CurrentMP := rrole[brole[i].rnum].CurrentMP + addmp;
        bfield[4, brole[i].X, brole[i].Y] := 1;
        //brole[i].ShowNumber:=addmp;
      end;
    end;

  PlayMagicAmination(bnum, Rmagic[mnum].AmiNum);
  brole[bnum].Acted := 1;
end;


//不知所措，交换两人mp

procedure swapmp(bnum, mnum, level: integer);
var
  i, x, y, aimbnum1, aimbnum2, tempmp, rnum: integer;
  r: boolean;

begin
  ShowMagicName(mnum);
  instruct_67(Rmagic[mnum].SoundNum);
  PlayActionAmination(bnum, Rmagic[mnum].MagicType); //动画效果

  rnum := brole[bnum].rnum;
  //消耗内力
  RRole[rnum].CurrentMP := RRole[rnum].CurrentMP - rmagic[mnum].NeedMP * ((level + 1) div 2);
  if RRole[rnum].CurrentMP < 0 then
    RRole[rnum].CurrentMP := 0;

  //消耗体力
  RRole[rnum].PhyPower := RRole[rnum].PhyPower - 3;
  if RRole[rnum].PhyPower < 0 then
    RRole[rnum].PhyPower := 0;

  if Bfield[2, Ax, Ay] >= 0 then
  begin
    aimbnum1 := Bfield[2, Ax, Ay];

    while Bfield[2, Ax, Ay] < 0 do
      while not SelectRange(bnum, 0, rmagic[mnum].MoveDistance[level - 1], 0) do ;
    aimbnum2 := Bfield[2, Ax, Ay];

    ShowMagicName(mnum);
    instruct_67(Rmagic[mnum].SoundNum);
    PlayActionAmination(bnum, Rmagic[mnum].MagicType);

    tempmp := rrole[brole[aimbnum1].rnum].CurrentMP;
    rrole[brole[aimbnum1].rnum].CurrentMP := rrole[brole[aimbnum2].rnum].CurrentMP;
    if rrole[brole[aimbnum1].rnum].CurrentMP > rrole[brole[aimbnum1].rnum].MaxMP then
      rrole[brole[aimbnum1].rnum].CurrentMP := rrole[brole[aimbnum1].rnum].MaxMP;
    rrole[brole[aimbnum2].rnum].CurrentMP := tempmp;
    if rrole[brole[aimbnum2].rnum].CurrentMP > rrole[brole[aimbnum2].rnum].MaxMP then
      rrole[brole[aimbnum2].rnum].CurrentMP := rrole[brole[aimbnum2].rnum].MaxMP;

    Bfield[4, brole[aimbnum1].X, brole[aimbnum1].Y] := 1;
    Bfield[4, brole[aimbnum2].X, brole[aimbnum2].Y] := 1;
  end;

  PlayMagicAmination(bnum, Rmagic[mnum].AmiNum);
  brole[bnum].Acted := 1;
end;

//颠三倒四，交换两人hp

procedure swapHp(bnum, mnum, level: integer);
var
  i, x, y, aimbnum1, aimbnum2, temphp, rnum: integer;
  r: boolean;

begin
  ShowMagicName(mnum);
  instruct_67(Rmagic[mnum].SoundNum);
  PlayActionAmination(bnum, Rmagic[mnum].MagicType); //动画效果

  rnum := brole[bnum].rnum;
  //消耗内力
  RRole[rnum].CurrentMP := RRole[rnum].CurrentMP - rmagic[mnum].NeedMP * ((level + 1) div 2);
  if RRole[rnum].CurrentMP < 0 then
    RRole[rnum].CurrentMP := 0;

  //消耗体力
  RRole[rnum].PhyPower := RRole[rnum].PhyPower - 3;
  if RRole[rnum].PhyPower < 0 then
    RRole[rnum].PhyPower := 0;

  if Bfield[2, Ax, Ay] >= 0 then
  begin
    aimbnum1 := Bfield[2, Ax, Ay];

    while Bfield[2, Ax, Ay] < 0 do
      while not SelectRange(bnum, 0, rmagic[mnum].MoveDistance[level - 1], 0) do ;
    aimbnum2 := Bfield[2, Ax, Ay];

    ShowMagicName(mnum);
    instruct_67(Rmagic[mnum].SoundNum);
    PlayActionAmination(bnum, Rmagic[mnum].MagicType);

    tempHp := rrole[brole[aimbnum1].rnum].CurrentHP;
    rrole[brole[aimbnum1].rnum].CurrentHP := rrole[brole[aimbnum2].rnum].CurrentHP;
    if rrole[brole[aimbnum1].rnum].CurrentHP > rrole[brole[aimbnum1].rnum].MaxHP then
      rrole[brole[aimbnum1].rnum].CurrentHP := rrole[brole[aimbnum1].rnum].MaxHP;
    rrole[brole[aimbnum2].rnum].CurrentHP := tempHp;
    if rrole[brole[aimbnum2].rnum].CurrentHP > rrole[brole[aimbnum2].rnum].MaxHP then
      rrole[brole[aimbnum2].rnum].CurrentMP := rrole[brole[aimbnum2].rnum].MaxHP;

    Bfield[4, brole[aimbnum1].X, brole[aimbnum1].Y] := 1;
    Bfield[4, brole[aimbnum2].X, brole[aimbnum2].Y] := 1;
  end;

  PlayMagicAmination(bnum, Rmagic[mnum].AmiNum);
  brole[bnum].Acted := 1;
end;


//人人为我，自私自利

procedure givemelife(bnum, mnum, level, Si: integer);
var
  i, addvalue, rnum, aimbnum: integer;
begin
  if Bfield[2, Ax, Ay] >= 0 then
  begin
    aimbnum := Bfield[2, Ax, Ay];
    if brole[aimbnum].Team = brole[bnum].Team then
    begin
      ShowMagicName(mnum);
      instruct_67(Rmagic[mnum].SoundNum);
      PlayActionAmination(bnum, Rmagic[mnum].MagicType); //动画效果

      rnum := brole[bnum].rnum;
      //消耗内力
      RRole[rnum].CurrentMP := RRole[rnum].CurrentMP - rmagic[mnum].NeedMP * ((level + 1) div 2);
      if RRole[rnum].CurrentMP < 0 then
        RRole[rnum].CurrentMP := 0;

      //消耗体力
      RRole[rnum].PhyPower := RRole[rnum].PhyPower - 3;
      if RRole[rnum].PhyPower < 0 then
        RRole[rnum].PhyPower := 0;

      addvalue := 100 * level;
      if addvalue > rrole[brole[aimbnum].rnum].CurrentMP then
        addvalue := rrole[brole[aimbnum].rnum].CurrentMP;
      if addvalue > rrole[brole[bnum].rnum].MAXHP - rrole[brole[bnum].rnum].CurrentHP then
        addvalue := rrole[brole[bnum].rnum].MAXHP - rrole[brole[bnum].rnum].CurrentHP;
      bfield[4, brole[bnum].X, brole[bnum].Y] := 1;
      bfield[4, brole[aimbnum].X, brole[aimbnum].Y] := 1;
      if brole[aimbnum].StateLevel[Si] > 10 then
        brole[aimbnum].StateRound[Si] := brole[aimbnum].StateRound[Si] + 1
      else
      begin
        brole[aimbnum].StateLevel[Si] := 10;
        brole[aimbnum].StateRound[Si] := 3;
      end;

      PlayMagicAmination(bnum, Rmagic[mnum].AmiNum);
    end;
  end;
  brole[bnum].Acted := 1;
end;

//打坐吐纳，减体加内

procedure IncreaceMP(bnum, mnum, level: integer);
var
  dePhy, addMP, rnum: integer;
begin
  ShowMagicName(mnum);
  instruct_67(Rmagic[mnum].SoundNum);
  PlayActionAmination(bnum, Rmagic[mnum].MagicType); //动画效果

  rnum := brole[bnum].rnum;

  dePhy := 20;
  if dePhy > rrole[rnum].PhyPower then
    dePhy := rrole[rnum].PhyPower;
  addMp := dePhy * 100;
  if addMp > rrole[rnum].MaxMP - rrole[rnum].CurrentMP then
    addMp := rrole[rnum].MaxMP - rrole[rnum].CurrentMP;
  dePhy := addMp div 100;

  rrole[rnum].PhyPower := rrole[rnum].PhyPower - dePhy;
  rrole[rnum].CurrentMP := rrole[rnum].CurrentMP + addMp;

  Bfield[4, brole[bnum].X, brole[bnum].Y] := 1;
  brole[bnum].ShowNumber := addMp;
  PlayMagicAmination(bnum, Rmagic[mnum].AmiNum);
  brole[bnum].Acted := 1;
end;

//妙手空空

procedure steal(bnum, mnum, level: integer);
var
  i, aimbnum, aimrnum, rnum, itemid, itemnum: integer;
begin
  aimbnum := Bfield[2, Ax, Ay];
  if aimbnum > 0 then
  begin
    if brole[aimbnum].Team <> brole[bnum].Team then
    begin
      ShowMagicName(mnum);
      instruct_67(Rmagic[mnum].SoundNum);
      PlayActionAmination(bnum, Rmagic[mnum].MagicType); //动画效果

      rnum := brole[bnum].rnum;
      //消耗内力
      RRole[rnum].CurrentMP := RRole[rnum].CurrentMP - rmagic[mnum].NeedMP * ((level + 1) div 2);
      if RRole[rnum].CurrentMP < 0 then
        RRole[rnum].CurrentMP := 0;

      //消耗体力
      RRole[rnum].PhyPower := RRole[rnum].PhyPower - 3;
      if RRole[rnum].PhyPower < 0 then
        RRole[rnum].PhyPower := 0;

      aimrnum := brole[aimbnum].rnum;
      itemid := -1;
      for i := 0 to 2 do
      begin
        if rrole[aimrnum].TakingItem[i] >= 0 then
        begin
          if random(100) > 50 then
          begin
            itemid := rrole[aimrnum].TakingItem[i];
            itemnum := random(rrole[aimrnum].TakingItemAmount[i]) + 1;
            break;
          end;
        end;
      end;

      if itemid >= 0 then
      begin
        rrole[aimrnum].TakingItemAmount[i] := rrole[aimrnum].TakingItemAmount[i] - itemnum;
        if rrole[aimrnum].TakingItemAmount[i] <= 0 then
          rrole[aimrnum].TakingItem[i] := -1;
        instruct_2(itemid, itemnum);
      end;
    end;
  end;
  brole[bnum].Acted := 1;
end;

//狮子吼

procedure LionRoar(bnum, mnum, level: integer);
var
  i, hurt, rnum: integer;
begin
  ShowMagicName(mnum);
  instruct_67(Rmagic[mnum].SoundNum);
  PlayActionAmination(bnum, Rmagic[mnum].MagicType); //动画效果

  rnum := brole[bnum].rnum;
  //消耗内力
  RRole[rnum].CurrentMP := RRole[rnum].CurrentMP - rmagic[mnum].NeedMP * ((level + 1) div 2);
  if RRole[rnum].CurrentMP < 0 then
    RRole[rnum].CurrentMP := 0;

  //消耗体力
  RRole[rnum].PhyPower := RRole[rnum].PhyPower - 3;
  if RRole[rnum].PhyPower < 0 then
    RRole[rnum].PhyPower := 0;

  hurt := 50 * level;
  for i := 0 to Broleamount - 1 do
  begin
    if (i <> bnum) and (brole[i].Dead = 0) and (brole[i].StateLevel[18] = 0) then
    begin
      rrole[brole[i].rnum].CurrentHP := rrole[brole[i].rnum].CurrentHP - hurt;
      if rrole[brole[i].rnum].CurrentHP < 0 then
        rrole[brole[i].rnum].CurrentHP := 0;
      Bfield[4, brole[i].X, Brole[i].Y] := 1;
      brole[i].ShowNumber := hurt;
    end;

    if brole[i].StateLevel[18] > 0 then
    begin
      rrole[brole[i].rnum].CurrentHP := rrole[brole[i].rnum].CurrentHP + hurt;
      if rrole[brole[i].rnum].CurrentHP > rrole[brole[i].rnum].MAXHP then
        rrole[brole[i].rnum].CurrentHP := rrole[brole[i].rnum].MAXHP;
      bfield[4, brole[i].X, brole[i].Y] := 1;
      //brole[i].ShowNumber:=addmp;
    end;

  end;
  PlayMagicAmination(bnum, Rmagic[mnum].AmiNum);
  brole[bnum].Acted := 1;
end;


//阎王敌

procedure cureall(bnum, mnum, level: integer);
var
  i, curenum, rnum: integer;
begin
  ShowMagicName(mnum);
  instruct_67(Rmagic[mnum].SoundNum);
  PlayActionAmination(bnum, Rmagic[mnum].MagicType); //动画效果

  rnum := brole[bnum].rnum;
  //消耗内力
  RRole[rnum].CurrentMP := RRole[rnum].CurrentMP - rmagic[mnum].NeedMP * ((level + 1) div 2);
  if RRole[rnum].CurrentMP < 0 then
    RRole[rnum].CurrentMP := 0;

  //消耗体力
  RRole[rnum].PhyPower := RRole[rnum].PhyPower - 3;
  if RRole[rnum].PhyPower < 0 then
    RRole[rnum].PhyPower := 0;

  for i := 0 to broleamount - 1 do
  begin
    if (brole[i].Team = brole[bnum].Team) and (brole[i].Dead = 0) then
    begin
      curenum := rrole[brole[i].rnum].MaxHP * 5 * level div 100;
      rrole[brole[i].rnum].CurrentHP := rrole[brole[i].rnum].CurrentHP + curenum;
      if rrole[brole[i].rnum].CurrentHP > rrole[brole[i].rnum].MAXHP then
        rrole[brole[i].rnum].CurrentHP := rrole[brole[i].rnum].MAXHP;
      Bfield[4, brole[i].X, brole[i].Y] := 1;
      brole[i].ShowNumber := curenum;
    end;
  end;

  PlayMagicAmination(bnum, Rmagic[mnum].AmiNum);
  brole[bnum].Acted := 1;
end;

//舍己为人

procedure TransferMP(bnum, mnum, level: integer);
var
  i, aimbnum, rnum, MPnum: integer;
begin
  if Bfield[2, Ax, Ay] >= 0 then
  begin
    aimbnum := Bfield[2, Ax, Ay];
    if brole[aimbnum].Team = brole[bnum].Team then
    begin
      ShowMagicName(mnum);
      instruct_67(Rmagic[mnum].SoundNum);
      PlayActionAmination(bnum, Rmagic[mnum].MagicType); //动画效果

      rnum := brole[bnum].rnum;
      //消耗体力
      RRole[rnum].PhyPower := RRole[rnum].PhyPower - 3;
      if RRole[rnum].PhyPower < 0 then
        RRole[rnum].PhyPower := 0;

      MPnum := 200 * level;
      if MPnum > rrole[rnum].CurrentMP then
        MPnum := rrole[rnum].CurrentMP;
      if MPnum > rrole[brole[aimbnum].rnum].MaxMP - rrole[brole[aimbnum].rnum].CurrentMP then
        MPnum := rrole[brole[aimbnum].rnum].MaxMP - rrole[brole[aimbnum].rnum].CurrentMP;
      RRole[rnum].CurrentMP := RRole[rnum].CurrentMP - MPnum;
      rrole[brole[aimbnum].rnum].CurrentMP := rrole[brole[aimbnum].rnum].CurrentMP + MPnum;

      PlayMagicAmination(bnum, Rmagic[mnum].AmiNum);
    end;
  end;
  brole[bnum].Acted := 1;
end;

procedure pojia(bnum, mnum, level: integer);
var
  i, aimbnum, rnum: integer;
begin
  if Bfield[2, Ax, Ay] >= 0 then
  begin
    aimbnum := Bfield[2, Ax, Ay];
    if brole[aimbnum].Team <> brole[bnum].Team then
    begin
      ShowMagicName(mnum);
      instruct_67(Rmagic[mnum].SoundNum);
      PlayActionAmination(bnum, Rmagic[mnum].MagicType); //动画效果

      rnum := brole[bnum].rnum;
      //消耗内力
      RRole[rnum].CurrentMP := RRole[rnum].CurrentMP - rmagic[mnum].NeedMP * ((level + 1) div 2);
      if RRole[rnum].CurrentMP < 0 then
        RRole[rnum].CurrentMP := 0;

      //消耗体力
      RRole[rnum].PhyPower := RRole[rnum].PhyPower - 3;
      if RRole[rnum].PhyPower < 0 then
        RRole[rnum].PhyPower := 0;

      for i := 0 to STATUS_AMOUNT - 4 do
      begin
        if brole[aimbnum].StateLevel[i] > 0 then
        begin
          brole[aimbnum].StateLevel[i] := 0;
          brole[aimbnum].StateRound[i] := 0;
        end;
      end;

      brole[aimbnum].StateLevel[4] := -50;
      brole[aimbnum].StateRound[4] := brole[aimbnum].StateRound[4] + 3;
      PlayMagicAmination(bnum, Rmagic[mnum].AmiNum);
    end;
  end;
  brole[bnum].Acted := 1;
end;

//静诵黄庭

procedure alladdPhy(bnum, mnum, level: integer);
var
  i, curenum, rnum: integer;
begin
  ShowMagicName(mnum);
  instruct_67(Rmagic[mnum].SoundNum);
  PlayActionAmination(bnum, Rmagic[mnum].MagicType); //动画效果

  rnum := brole[bnum].rnum;
  //消耗内力
  RRole[rnum].CurrentMP := RRole[rnum].CurrentMP - rmagic[mnum].NeedMP * ((level + 1) div 2);
  if RRole[rnum].CurrentMP < 0 then
    RRole[rnum].CurrentMP := 0;

  //消耗体力
  RRole[rnum].PhyPower := RRole[rnum].PhyPower - 3;
  if RRole[rnum].PhyPower < 0 then
    RRole[rnum].PhyPower := 0;

  curenum := MAX_PHYSICAL_POWER * 5 * level div 100;
  for i := 0 to broleamount - 1 do
  begin
    if (brole[i].Team = brole[bnum].Team) and (brole[i].Dead = 0) then
    begin
      rrole[brole[i].rnum].PhyPower := rrole[brole[i].rnum].PhyPower + curenum;
      if rrole[brole[i].rnum].PhyPower > MAX_PHYSICAL_POWER then
        rrole[brole[i].rnum].PhyPower := MAX_PHYSICAL_POWER;
      Bfield[4, brole[i].X, brole[i].Y] := 1;
      brole[i].ShowNumber := curenum;
    end;
  end;

  PlayMagicAmination(bnum, Rmagic[mnum].AmiNum);
  brole[bnum].Acted := 1;
end;

//含沙射影

procedure PoisonAll(bnum, mnum, level: integer);
var
  i, curenum, rnum: integer;
begin
  ShowMagicName(mnum);
  instruct_67(Rmagic[mnum].SoundNum);
  PlayActionAmination(bnum, Rmagic[mnum].MagicType); //动画效果

  rnum := brole[bnum].rnum;
  //消耗内力
  RRole[rnum].CurrentMP := RRole[rnum].CurrentMP - rmagic[mnum].NeedMP * ((level + 1) div 2);
  if RRole[rnum].CurrentMP < 0 then
    RRole[rnum].CurrentMP := 0;

  //消耗体力
  RRole[rnum].PhyPower := RRole[rnum].PhyPower - 3;
  if RRole[rnum].PhyPower < 0 then
    RRole[rnum].PhyPower := 0;

  curenum := MAX_PHYSICAL_POWER * 3 * level div 100;
  for i := 0 to broleamount - 1 do
  begin
    if (brole[i].Team <> brole[bnum].Team) and (brole[i].Dead = 0) then
    begin
      rrole[brole[i].rnum].Poision := rrole[brole[i].rnum].Poision + curenum;
      if rrole[brole[i].rnum].Poision > 200 then
        rrole[brole[i].rnum].Poision := 200;
      Bfield[4, brole[i].X, brole[i].Y] := 1;
    end;
  end;

  PlayMagicAmination(bnum, Rmagic[mnum].AmiNum);
  brole[bnum].Acted := 1;
end;


//药王神篇

procedure MedPoisonAll(bnum, mnum, level: integer);
var
  i, curenum, rnum: integer;
begin
  ShowMagicName(mnum);
  instruct_67(Rmagic[mnum].SoundNum);
  PlayActionAmination(bnum, Rmagic[mnum].MagicType); //动画效果

  rnum := brole[bnum].rnum;
  //消耗内力
  RRole[rnum].CurrentMP := RRole[rnum].CurrentMP - rmagic[mnum].NeedMP * ((level + 1) div 2);
  if RRole[rnum].CurrentMP < 0 then
    RRole[rnum].CurrentMP := 0;

  //消耗体力
  RRole[rnum].PhyPower := RRole[rnum].PhyPower - 3;
  if RRole[rnum].PhyPower < 0 then
    RRole[rnum].PhyPower := 0;

  curenum := 5 * level;
  for i := 0 to broleamount - 1 do
  begin
    if (brole[i].Team = brole[bnum].Team) and (brole[i].Dead = 0) then
    begin
      rrole[brole[i].rnum].Poision := rrole[brole[i].rnum].Poision - curenum;
      if rrole[brole[i].rnum].Poision < 0 then
        rrole[brole[i].rnum].Poision := 0;
      Bfield[4, brole[i].X, brole[i].Y] := 1;
    end;
  end;

  PlayMagicAmination(bnum, Rmagic[mnum].AmiNum);
  brole[bnum].Acted := 1;
end;


//运功疗伤，减内加血

procedure IncreaceHP(bnum, mnum, level: integer);
var
  deMP, addHP, rnum: integer;
begin
  ShowMagicName(mnum);
  instruct_67(Rmagic[mnum].SoundNum);
  PlayActionAmination(bnum, Rmagic[mnum].MagicType); //动画效果

  rnum := brole[bnum].rnum;

  deMP := 100 * level;
  if deMP > rrole[rnum].currentMP then
    deMP := rrole[rnum].CurrentMP;
  addHP := deMP;
  if addHP > rrole[rnum].MaxHP - rrole[rnum].CurrentHP then
    addHp := rrole[rnum].MaxHP - rrole[rnum].CurrentHP;
  deMP := addHp;

  rrole[rnum].CurrentMP := rrole[rnum].CurrentMP - deMP;
  rrole[rnum].CurrentHP := rrole[rnum].CurrentHP + addHp;

  Bfield[4, brole[bnum].X, brole[bnum].Y] := 1;
  brole[bnum].ShowNumber := addHp;
  PlayMagicAmination(bnum, Rmagic[mnum].AmiNum);
  brole[bnum].Acted := 1;
end;

end.
