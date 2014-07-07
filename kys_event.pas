unit kys_event;

{$i macro.inc}

interface

uses
  LConvEncoding,
  LCLType,
  SysUtils,
  StrUtils,
  SDL2,
  Math,
  kys_type,
  kys_main,
  Dialogs,
  Classes;

//事件系统
//在英文中, instruct通常不作为名词, swimmingfish在他的一份反汇编文件中大量使用
//这个词表示"指令", 所以这里仍保留这种用法
procedure instruct_0;
procedure instruct_1(talknum, headnum, dismode: integer);
procedure SetRolePic(step: integer; pic: integer = -1);
procedure instruct_2(inum, amount: integer);
procedure ReArrangeItem(sort: integer = 0);
procedure instruct_3(list: array of integer);
function instruct_4(inum, jump1, jump2: integer): integer;
function instruct_5(jump1, jump2: integer): integer;
function instruct_6(battlenum, jump1, jump2, getexp: integer): integer;
procedure instruct_8(musicnum: integer);
function instruct_9(jump1, jump2: integer): integer;
procedure instruct_10(rnum: integer);
function instruct_11(jump1, jump2: integer): integer;
procedure instruct_12;
procedure instruct_13;
procedure instruct_14;
procedure instruct_15;
function instruct_16(rnum, jump1, jump2: integer): integer;
procedure instruct_17(list: array of integer);
function instruct_18(inum, jump1, jump2: integer): integer;
procedure instruct_19(x, y: integer);
function instruct_20(jump1, jump2: integer): integer;
procedure instruct_21(rnum: integer);
procedure instruct_22;
procedure instruct_23(rnum, Poison: integer);
procedure instruct_24;
procedure instruct_25(x1, y1, x2, y2: integer);
procedure instruct_26(snum, enum, add1, add2, add3: integer);
procedure instruct_27(enum, beginpic, endpic: integer);
function instruct_28(rnum, e1, e2, jump1, jump2: integer): integer;
function instruct_29(rnum, r1, r2, jump1, jump2: integer): integer;
procedure instruct_30(x1, y1, x2, y2: integer);
function instruct_31(moneynum, jump1, jump2: integer): integer;
procedure instruct_32(inum, amount: integer);
procedure instruct_33(rnum, mnum, dismode: integer);
procedure instruct_34(rnum, iq: integer);
procedure instruct_35(rnum, magiclistnum, magicnum, exp: integer);
function instruct_36(sexual, jump1, jump2: integer): integer;
procedure instruct_37(Ethics: integer);
procedure instruct_38(snum, layernum, oldpic, newpic: integer);
procedure instruct_39(snum: integer);
procedure instruct_40(director: integer);
procedure instruct_41(rnum, inum, amount: integer);
function instruct_42(jump1, jump2: integer): integer;
function instruct_43(inum, jump1, jump2: integer): integer;
procedure instruct_44(enum1, beginpic1, endpic1, enum2, beginpic2, endpic2: integer);
procedure instruct_44e(enum1, beginpic1, endpic1, enum2, beginpic2, enum3, beginpic3: integer);
procedure Show3HintString(str1, str2, str3: pWideChar);
procedure AddRoleProWithHint(rnum, datalist, value: integer; word: WideString = '');
procedure instruct_45(rnum, speed: integer);
procedure instruct_46(rnum, mp: integer);
procedure instruct_47(rnum, Attack: integer);
procedure instruct_48(rnum, hp: integer);
procedure instruct_49(rnum, MPpro: integer);
function instruct_50(list: array of integer): integer;
procedure instruct_51;
procedure ShowRolePro(rnum, datalist: integer; word: WideString);
procedure instruct_52;
procedure instruct_53;
procedure instruct_54;
function instruct_55(enum, value, jump1, jump2: integer): integer;
procedure instruct_56(Repute: integer);
procedure instruct_57;
procedure instruct_58;
procedure instruct_59;
function instruct_60(snum, enum, pic, jump1, jump2: integer): integer;
function instruct_61(jump1, jump2: integer): integer;
procedure instruct_62(enum1, beginpic1, endpic1, enum2, beginpic2, endpic2: integer);
procedure TextAmi(filename: string);
procedure EndAmi;
procedure instruct_63(rnum, sexual: integer);
procedure instruct_64;
procedure instruct_66(musicnum: integer);
procedure instruct_67(Soundnum: integer);
function e_GetValue(bit, t, x: integer): integer;
function instruct_50e(code, e1, e2, e3, e4, e5, e6: integer): integer;
function HaveMagic(person, mnum, lv: integer): boolean;
function HaveMagicAmount(rnum: integer; NeiGong: integer = 0): integer;
function GetMagicLevel(person, mnum: integer): integer;
procedure StudyMagic(rnum, magicnum, newmagicnum, level, dismode: integer);
procedure DivideName(fullname: WideString; var surname, givenname: WideString);
function ReplaceStr(const S, Srch, Replace: WideString): WideString;
procedure NewTalk(headnum, talknum, namenum, place, showhead, color, frame: integer;
  content: WideString = ''; disname: WideString = '');
procedure ShowTitle(talknum, color: integer);
function Digging(beginPic, goal, shovel, restrict: integer): integer;
procedure ShowSurface(x, y, blank: integer; surface: array of integer);
procedure TeammateList;
function StarToRole(Starnum: integer): integer;
procedure NewTeammateList;
function GetStarState(position: integer): integer;
procedure SetStarState(position, value: integer);
procedure ShowTeamMate(position, headnum, Count: integer);
function ReSetName(t, inum, newnamenum: integer): integer;
procedure JumpScence(snum, y, x: integer);
procedure ShowStarList;
procedure SetAttribute(rnum, selecttype, modlevel, minlevel, maxlevel: integer);
procedure CalAddPro(magictype: integer; var attackadd, speedadd, defenceadd, HPadd, MPadd: integer);
function Lamp(c, beginpic, whitecount, chance: integer): boolean;
function GetItemAmount(inum: integer): integer;
procedure MissionList(mode: integer);
function GetMissionState(position: integer): integer;
procedure SetMissionState(position, value: integer);
procedure RoleEnding(starnum, headnum, talknum: integer);
function WoodMan(Chamber: integer): boolean;
procedure ShowManWalk(face, Eface1, Eface2: integer);
procedure ShowWoodManWalk(num, Eface1, Eface2, RoleFace: integer);
function SpellPicture(num, chance: integer): boolean;
procedure ExchangePic(p1, p2: integer);
procedure BookList;
function GetStarAmount: smallint;
function DancerAfter90S: integer;

procedure ReadTalk(talknum: integer; var talk: Tbytearray; needxor: integer = 0);

procedure NewShop(shop_num: integer);

procedure ShowMap;
function EnterNumber(MinValue, MaxValue, x, y: integer; Default: integer = 0): smallint;

implementation

uses
  kys_script,
  kys_engine,
  kys_battle,
  kys_draw;


//事件系统
//事件指令含义请参阅其他相关文献

procedure instruct_0;
begin
  if NeedRefreshScence = 1 then
  begin
    //InitialScence(0);
    Redraw;
    NeedRefreshScence := 0;
  end;

  //SDL_UpdateRect2(screen,0,0,screen.w,screen.h);

end;

//对话

procedure instruct_1(talknum, headnum, dismode: integer);
var
  idx, grp, offset, len, i, p, l, headx, heady, diagx, diagy, namenum: integer;
  talkarray: array of byte;
  Name: WideString;
begin
  namenum := headnum;
  if dismode in [2, 3] then
    headnum := -1;
  if MODVersion = 81 then
    namenum := -2;
  NewTalk(headnum, talknum, namenum, dismode mod 2, 0, 0, 0);

  {case dismode of
    0:
    begin
      headx := 40;
      heady := 80;
      diagx := 100;
      diagy := 30;
    end;
    1:
    begin
      headx := 546;
      heady := CENTER_Y * 2 - 80;
      diagx := 10;
      diagy := CENTER_Y * 2 - 130;
    end;
    2:
    begin
      headx := -1;
      heady := -1;
      diagx := 100;
      diagy := 30;
    end;
    5:
    begin
      headx := 40;
      heady := CENTER_Y * 2 - 80;
      diagx := 100;
      diagy := CENTER_Y * 2 - 130;
    end;
    4:
    begin
      headx := 546;
      heady := 80;
      diagx := 10;
      diagy := 30;
    end;
    3:
    begin
      headx := -1;
      heady := -1;
      diagx := 100;
      diagy := CENTER_Y * 2 - 130;
    end;
  end;
  idx := FileOpen('resource/talk.idx', fmopenread);
  grp := FileOpen('resource/talk.grp', fmopenread);
  if talknum = 0 then
  begin
    offset := 0;
    FileRead(idx, len, 4);
  end
  else
  begin
    FileSeek(idx, (talknum - 1) * 4, 0);
    FileRead(idx, offset, 4);
    FileRead(idx, len, 4);
  end;
  len := (len - offset);
  setlength(talkarray, len + 1);
  FileSeek(grp, offset, 0);
  FileRead(grp, talkarray[0], len);
  FileClose(idx);
  FileClose(grp);
  DrawRectangleWithoutFrame(screen, 0, diagy - 10, 640, 120, 0, 40);
  if headx > 0 then
    DrawHeadPic(headnum, headx, heady);
  //if headnum <= MAX_HEAD_NUM then
  //begin
  //name := PreSpaceUnicode(@rrole[headnum].Name);
  //drawshadowtext(@name[1], headx + 20 - length(name) * 10, heady + 5, colcolor($ff), colcolor($0));
  //end;
  {for i := 0 to len - 1 do
  begin
    talkarray[i] := talkarray[i] xor $FF;
    if (talkarray[i] = $2A) then
      talkarray[i] := 0;
  end;}
  {talkarray[len - 1] := $20;
  p := 0;
  l := 0;
  for i := 0 to len do
  begin
    if talkarray[i] = 0 then
    begin
      DrawU16ShadowText(@talkarray[p], diagx, diagy + l * 22, ColColor($FF), ColColor($0));
      p := i + 1;
      l := l + 1;
      if (l >= 4) and (i < len) then
      begin
        updateallscreen;
        WaitAnyKey;
        Redraw;
        DrawRectangleWithoutFrame(screen, 0, diagy - 10, 640, 120, 0, 40);
        if headx > 0 then
          DrawHeadPic(headnum, headx, heady);
        l := 0;
      end;
    end;
  end;
  updateallscreen;
  WaitAnyKey;
  Redraw; }

end;

//设置主角的步数及图片

procedure SetRolePic(step: integer; pic: integer = -1);
begin
  if step >= 0 then
    sstep := step;
  if step >= 7 then
    step := 1;
  if pic < 0 then
    CurScenceRolePic := 2501 + SFace * 7 + Sstep;
end;

//得到物品可显示数量, 数量为负显示失去物品

procedure instruct_2(inum, amount: integer);
var
  i, x, y, l1, l2: integer;
  word: WideString;
begin
  instruct_32(inum, amount);
  SetRolePic(0);
  x := CENTER_X;
  y := CENTER_Y;
  if where = 2 then
  begin
    x := CENTER_X;
    y := CENTER_Y;
  end;

  //DrawRectangle(x - 85, y, 170, 76, 0, ColColor(255), 30);
  word := UTF8Decode(format('%d', [amount]));
  l1 := length(pWideChar(@Ritem[inum].Name));
  l2 := (length(word) + 1) div 2;
  DrawTextFrame(CENTER_X - (3 + l1 + l2) * 10 - 20, y, 3 + l1 + l2);
  x := CENTER_X - (3 + l1 + l2) * 10 + 1;
  DrawEngShadowText(@word[1], x + 40 + 20 + l1 * 20, 3 + y, 0, $202020);
  if amount >= 0 then
    word := '得到'
  else
  begin
    word := '失去';
    amount := -amount;
  end;
  DrawShadowText(@word[1], x, 3 + y, 0, ColColor($23));
  //word := '數量';
  //DrawShadowText(@word[1], x - 60, 3 + y, ColColor($64), ColColor($66));
  DrawIPic(inum, CENTER_X - 40, y - 90, 0, 0, 0, 0);

  DrawU16ShadowText(@Ritem[inum].Name, x + 40, 3 + y, ColColor($64), ColColor($66));
  UpdateAllScreen;
  //SDL_UpdateRect2(screen, x - 85, y, 171, 77);
  //有3种机会得到物品-平时, 战斗中偷窃, 战斗结束制造
  if (where = 2) then
  begin
    if BStatus = 0 then
    begin
      SDL_Delay(500);
      Redraw;
    end
    else
      WaitAnyKey;
  end
  else
  begin
    WaitAnyKey;
    Redraw;
  end;
  //updateallscreen;

end;

//重排物品，清除为0的物品
//合并同类物品（空间换时间）

procedure ReArrangeItem(sort: integer = 0);
var
  i, j, p: integer;
  item, amount: array of integer;
begin
  p := 0;
  setlength(item, MAX_ITEM_AMOUNT);
  setlength(amount, high(Ritem) + 1);
  fillchar(amount[0], sizeof(amount[0]) * length(amount), 0);
  for i := 0 to MAX_ITEM_AMOUNT - 1 do
  begin
    if (RItemList[i].Number >= 0) and (RItemList[i].Amount > 0) then
    begin
      if amount[RItemList[i].Number] = 0 then
      begin
        item[p] := RItemList[i].Number;
        amount[RItemList[i].Number] := RItemList[i].Amount;
        p := p + 1;
      end
      else
        amount[RItemList[i].Number] := amount[RItemList[i].Number] + RItemList[i].Amount;
    end;
  end;

  if sort = 0 then
  begin
    for i := 0 to MAX_ITEM_AMOUNT - 1 do
    begin
      if i < p then
      begin
        RItemList[i].Number := item[i];
        RItemList[i].Amount := amount[item[i]];
      end
      else
      begin
        RItemList[i].Number := -1;
        RItemList[i].Amount := 0;
      end;
    end;
  end
  else
  begin
    for i := 0 to MAX_ITEM_AMOUNT - 1 do
    begin
      RItemList[i].Number := -1;
      RItemList[i].Amount := 0;
    end;
    j := 0;
    for i := 0 to length(amount) - 1 do
    begin
      if amount[i] > 0 then
      begin
        RItemList[j].Number := i;
        RItemList[j].Amount := amount[i];
        j := j + 1;
      end;
    end;
  end;
end;

//改变事件, 如在当前场景需重置场景
//在需改变贴图较多时效率较低

procedure instruct_3(list: array of integer);
var
  i, i1, i2, curPic, preEventPic: integer;
begin
  curPic := DData[CurScence, CurEvent, 5];
  if list[0] = -2 then
    list[0] := CurScence;
  if list[1] = -2 then
    list[1] := CurEvent;
  if list[11] = -2 then
    list[11] := Ddata[list[0], list[1], 9];
  if list[12] = -2 then
    list[12] := Ddata[list[0], list[1], 10];
  preEventPic := DData[list[0], list[1], 5];
  //这里应该是原本z文件的bug, 如果不处于当前场景, 在连坐标值一起修改时, 并不会同时
  //对S数据进行修改. 而<苍龙逐日>中有几条语句无意中符合了这个bug而造成正确的结果
  //if list[0] = CurScence then
  Sdata[list[0], 3, Ddata[list[0], list[1], 10], Ddata[list[0], list[1], 9]] := -1;
  for i := 0 to 10 do
  begin
    if list[2 + i] <> -2 then
    begin
      Ddata[list[0], list[1], i] := list[2 + i];
    end;
  end;
  //if list[0] = CurScence then
  Sdata[list[0], 3, Ddata[list[0], list[1], 10], Ddata[list[0], list[1], 9]] := list[1];
  //if list[0] = CurScence then
  //UpdateScence(list[12], list[11]);
  if DData[CurScence, CurEvent, 5] <> curPic then
  begin
    if (PNG_TILE > 0) then
    begin
      i := DData[CurScence, CurEvent, 5] div 2;
      LoadOnePNGTexture('resource/smap/', pSPic, SPNGIndex[i]);
    end;
    Redraw;
  end;
  if (list[0] = CurScence) and (preEventPic <> DData[list[0], list[1], 5]) then
  begin
    NeedRefreshScence := 1;
  end;

end;

//是否使用了某剧情物品

function instruct_4(inum, jump1, jump2: integer): integer;
begin
  if inum = CurItem then
    Result := jump1
  else
    Result := jump2;

end;

//询问是否战斗

function instruct_5(jump1, jump2: integer): integer;
var
  menu: integer;
  menuString: array[0..2] of WideString;
begin
  menuString[0] := '取消';
  menuString[1] := '戰鬥';
  menuString[2] := '是否與之戰鬥？';
  DrawTextWithRect(@menuString[2][1], CENTER_X - 75, CENTER_Y - 85, 150, ColColor(5), ColColor(7));
  menu := CommonMenu2(CENTER_X - 49, CENTER_Y - 50, 48, menuString);
  if menu = 1 then
    Result := jump1
  else
    Result := jump2;
  Redraw;
  UpdateAllScreen;

end;

//战斗

function instruct_6(battlenum, jump1, jump2, getexp: integer): integer;
begin
  Result := jump2;
  if (ForceBattleWin = 1) or Battle(battlenum, getexp) then
    Result := jump1;

end;

//询问是否加入

procedure instruct_8(musicnum: integer);
begin
  exitscencemusicnum := musicnum;
end;

function instruct_9(jump1, jump2: integer): integer;
var
  menu: integer;
  menuString: array[0..2] of WideString;
begin
  menuString[0] := '取消';
  menuString[1] := '要求';
  menuString[2] := '是否要求加入？';
  DrawTextWithRect(@menuString[2][1], CENTER_X - 75, CENTER_Y - 85, 150, ColColor(5), ColColor(7));
  menu := CommonMenu2(CENTER_X - 49, CENTER_Y - 50, 48, menuString);
  if menu = 1 then
    Result := jump1
  else
    Result := jump2;
  Redraw;
  UpdateAllScreen;

end;

//加入队友, 同时得到其身上物品

procedure instruct_10(rnum: integer);
var
  i, i1: integer;
begin
  for i := 0 to 5 do
  begin
    if Teamlist[i] < 0 then
    begin
      Teamlist[i] := rnum;
      for i1 := 0 to 3 do
      begin
        if (Rrole[rnum].TakingItem[i1] >= 0) and (Rrole[rnum].TakingItemAmount[i1] > 0) then
        begin
          instruct_2(Rrole[rnum].TakingItem[i1], Rrole[rnum].TakingItemAmount[i1]);
          Rrole[rnum].TakingItem[i1] := -1;
          Rrole[rnum].TakingItemAmount[i1] := 0;
        end;
      end;
      break;
    end;
  end;

end;

//询问是否住宿
//改为通用

function instruct_11(jump1, jump2: integer): integer;
var
  menu: integer;
  menuString: array[0..2] of WideString;
begin
  menuString[0] := '取消';
  menuString[1] := '住宿';
  menuString[2] := '是否需要住宿？';
  DrawTextWithRect(@menuString[2][1], CENTER_X - 75, CENTER_Y - 85, 147, ColColor(5), ColColor(7));
  menu := CommonMenu2(CENTER_X - 49, CENTER_Y - 50, 48, menuString);
  if menu = 1 then
    Result := jump1
  else
    Result := jump2;
  Redraw;
  UpdateAllScreen;

end;

//住宿

procedure instruct_12;
var
  i, rnum: integer;
begin
  for i := 0 to 5 do
  begin
    rnum := Teamlist[i];
    if not ((rnum = -1) or (Rrole[rnum].Hurt > 33) or (Rrole[rnum].Poison > 0)) then
    begin
      Rrole[rnum].CurrentHP := Rrole[rnum].MaxHP;
      Rrole[rnum].CurrentMP := Rrole[rnum].MaxMP;
      Rrole[rnum].PhyPower := MAX_PHYSICAL_POWER;
    end;
  end;
end;


//亮屏, 在亮屏之前重新初始化场景

procedure instruct_13;
var
  i: integer;
begin
  //for i1:=0 to 199 do
  //for i2:=0 to 10 do
  //DData[CurScence, [i1,i2]:=Ddata[CurScence,i1,i2];
  //InitialScence;
  NeedRefreshScence := 0;
  {for i := 10 - blackscreen to 9 do
  begin
    Sdl_Delay(200);
    Redraw;
    DrawRectangleWithoutFrame(screen, 0, 0, screen.w, screen.h, 0, i * 10);
    updateallscreen;
  end;}
  blackscreen := 0;
  Redraw;
  UpdateAllScreen;
  {SDL_EventState(SDL_KEYDOWN, SDL_ENABLE);
  SDL_EventState(SDL_KEYUP, SDL_ENABLE);
  SDL_EventState(SDL_mousebuttonUP, SDL_ENABLE);
  SDL_EventState(SDL_mousebuttonDOWN, SDL_ENABLE);}
end;

//黑屏

procedure instruct_14;
var
  i: integer;
begin
  CleanTextScreen;
  for i := 10 downto 0 do
  begin
    //Redraw;
    SDL_Delay(10);
    DrawRectangleWithoutFrame(0, 0, CENTER_X * 2, CENTER_Y * 2, 0, i * 10);
    //SDL_SetTextureColorMod(screenTex, i * 25, i * 25, i * 25);
    UpdateAllScreen;
  end;
  SDL_Delay(50);
  blackscreen := 10;
  //SDL_SetTextureColorMod(screenTex, 255, 255, 255);
end;

//失败画面

procedure instruct_15;
var
  i, x, y: integer;
  str: WideString;
begin
  where := 3;
  Redraw;
  DrawRectangleWithoutFrame(0, 0, CENTER_X * 2, CENTER_Y * 2, MapRGBA(196, 25, 16), 60);
  str := ' 小村的傳說失敗了…';
  DrawShadowText(@str[1], CENTER_X - 120, CENTER_Y - 25, ColColor(255), ColColor(255));
  str := '但是遊戲是可以重來的！';
  DrawShadowText(@str[1], CENTER_X - 120, CENTER_Y, ColColor(255), ColColor(255));
  x := 425;
  y := 275;
  //DrawTitlePic(0, x, y);

  UpdateAllScreen;
  WaitAnyKey;
end;

//队伍中是否有某人

function instruct_16(rnum, jump1, jump2: integer): integer;
var
  i: integer;
begin
  Result := jump2;
  for i := 0 to 5 do
  begin
    if Teamlist[i] = rnum then
    begin
      Result := jump1;
      break;
    end;
  end;
end;

//改变场景数据

procedure instruct_17(list: array of integer);
var
  i1, i2: integer;
begin
  if list[0] = -2 then
    list[0] := CurScence;
  sdata[list[0], list[1], list[3], list[2]] := list[4];
  if list[0] = CurScence then
    NeedRefreshScence := 1;
end;

//是否有某物品

function instruct_18(inum, jump1, jump2: integer): integer;
var
  i: integer;
begin
  Result := jump2;
  for i := 0 to MAX_ITEM_AMOUNT - 1 do
  begin
    if RItemList[i].Number = inum then
    begin
      Result := jump1;
      break;
    end;
  end;
end;

//改变坐标

procedure instruct_19(x, y: integer);
begin
  Sx := y;
  Sy := x;
  Cx := Sx;
  Cy := Sy;
  Sstep := 0;
  CurScenceRolePic := 2501 + SFace * 7 + SStep;
  Redraw;
end;

//Judge the team is full or not.

function instruct_20(jump1, jump2: integer): integer;
var
  i: integer;
begin
  Result := jump1;
  for i := 0 to 5 do
  begin
    if TeamList[i] < 0 then
    begin
      Result := jump2;
      break;
    end;
  end;
end;

//加入某人

procedure instruct_21(rnum: integer);
var
  i, p: integer;
  newlist: array[0..5] of integer;
begin
  p := 0;
  for i := 0 to 5 do
  begin
    newlist[i] := -1;
    if Teamlist[i] <> rnum then
    begin
      newlist[p] := Teamlist[i];
      p := p + 1;
    end;
  end;
  for i := 0 to 5 do
    Teamlist[i] := newlist[i];
end;

procedure instruct_22;
var
  i: integer;
begin
  for i := 0 to 5 do
    Rrole[Teamlist[i]].CurrentMP := 0;
end;

procedure instruct_23(rnum, Poison: integer);
begin
  Rrole[rnum].UsePoi := Poison;
end;

//Black the screen when fail in battle.
//Note: never be used, leave it as blank.

procedure instruct_24;
begin
end;

//Note: never display the leading role.
//This will be improved when I have a better method.

procedure instruct_25(x1, y1, x2, y2: integer);
var
  i, s: integer;
begin
  s := sign(x2 - x1);
  i := x1 + s;
  Cx := y1;
  Cy := x1;
  if s <> 0 then
    while (SDL_PollEvent(@event) >= 0) do
    begin
      CheckBasicEvent;
      SDL_Delay(50);
      Cy := i;
      DrawScence;
      UpdateAllScreen;
      i := i + s;
      if (s * (x2 - i) < 0) then
        break;
    end;
  s := sign(y2 - y1);
  i := y1 + s;
  if s <> 0 then
    while (SDL_PollEvent(@event) >= 0) do
    begin
      CheckBasicEvent;
      SDL_Delay(50);
      Cx := i;
      DrawScence;
      UpdateAllScreen;
      i := i + s;
      if (s * (y2 - i) < 0) then
        break;
    end;
  Cx := y2;
  Cy := x2;
  //SSx:=0;
  //SSy:=0;
  //showmessage(inttostr(ssx*100+ssy));
end;

procedure instruct_26(snum, enum, add1, add2, add3: integer);
begin
  if snum = -2 then
    snum := CurScence;
  ddata[snum, enum, 2] := ddata[snum, enum, 2] + add1;
  ddata[snum, enum, 3] := ddata[snum, enum, 3] + add2;
  ddata[snum, enum, 4] := ddata[snum, enum, 4] + add3;

end;

//Note: of course an more effective engine can take place of it.
//动画, 至今仍不完善

procedure instruct_27(enum, beginpic, endpic: integer);
var
  i, xpoint, ypoint: integer;
begin
  if (DData[CurScence, enum, 10] = Sx) and (DData[CurScence, enum, 9] = Sy) then
    enum := -1;
  if enum = -1 then
  begin
    //showMR := false;
    i := beginpic;
    while SDL_PollEvent(@event) >= 0 do
    begin
      CheckBasicEvent;
      CurScenceRolePic := i div 2;
      SDL_Delay(WALK_SPEED2 * 2);
      DrawScence;
      UpdateAllScreen;
      i := i + 1;
      if i > endpic then
        break;
    end;
    //if MODVersion = 13 then
    //CurScenceRolePic := -1;
    //showMR := true;
  end
  else
  begin
    i := beginpic;
    while SDL_PollEvent(@event) >= 0 do
    begin
      CheckBasicEvent;
      DData[CurScence, enum, 5] := i;
      DData[CurScence, enum, 6] := i;
      DData[CurScence, enum, 7] := i;
      SDL_Delay(20);
      DrawScence;
      UpdateAllScreen;
      i := i + 1;
      if i > endpic then
        break;
    end;
  end;
end;

function instruct_28(rnum, e1, e2, jump1, jump2: integer): integer;
begin
  Result := jump2;
  if (Rrole[rnum].Ethics >= e1) and (Rrole[rnum].Ethics <= e2) then
    Result := jump1;
end;

function instruct_29(rnum, r1, r2, jump1, jump2: integer): integer;
begin
  Result := jump2;
  if (Rrole[rnum].Attack >= r1) {and (Rrole[rnum].Attack <= r2)} then
    Result := jump1;
end;

procedure instruct_30(x1, y1, x2, y2: integer);
var
  s: integer;
begin
  s := sign(x2 - x1);
  Sy := x1 + s;
  if s > 0 then
    Sface := 1;
  if s < 0 then
    Sface := 2;
  if s <> 0 then
    while SDL_PollEvent(@event) >= 0 do
    begin
      CheckBasicEvent;
      SDL_Delay(50);
      SStep := SStep + 1;
      if SStep >= 7 then
        SStep := 1;
      CurScenceRolePic := 2501 + SFace * 7 + SStep;
      Cx := Sx;
      Cy := Sy;
      DrawScence;
      UpdateAllScreen;
      Sy := Sy + s;
      if s * (x2 - Sy) < 0 then
        break;
    end;
  s := sign(y2 - y1);
  Sx := y1 + s;
  if s > 0 then
    Sface := 3;
  if s < 0 then
    Sface := 0;
  if s <> 0 then
    while SDL_PollEvent(@event) >= 0 do
    begin
      SDL_Delay(50);
      SStep := SStep + 1;
      if SStep >= 7 then
        SStep := 1;
      CurScenceRolePic := 2501 + SFace * 7 + SStep;
      Cx := Sx;
      Cy := Sy;
      DrawScence;
      UpdateAllScreen;
      Sx := Sx + s;
      if s * (y2 - Sx) < 0 then
        break;
    end;
  Sx := y2;
  Sy := x2;
  SStep := 0;
  CurScenceRolePic := 2501 + SFace * 7;
  Cx := Sx;
  Cy := Sy;
end;

function instruct_31(moneynum, jump1, jump2: integer): integer;
var
  i: integer;
begin
  Result := jump2;
  if moneynum <= 0 then
  begin
    Result := jump1;
  end
  else
  begin
    for i := 0 to MAX_ITEM_AMOUNT - 1 do
    begin
      if (RItemList[i].Number = MONEY_ID) and (RItemList[i].Amount >= moneynum) then
      begin
        Result := jump1;
        break;
      end;
    end;
  end;
end;

procedure instruct_32(inum, amount: integer);
var
  i: integer;
begin
  if Amount <> 0 then
  begin
    i := 0;
    while (RItemList[i].Number >= 0) and (i < MAX_ITEM_AMOUNT) do
    begin
      if (RItemList[i].Number = inum) then
      begin
        RItemList[i].Amount := RItemList[i].Amount + amount;
        if (RItemList[i].Amount < 0) and (amount >= 0) then
          RItemList[i].Amount := 32767;
        if (RItemList[i].Amount < 0) and (amount < 0) then
          RItemList[i].Amount := 0;
        break;
      end;
      i := i + 1;
    end;
    if RItemList[i].Number < 0 then
    begin
      RItemList[i].Number := inum;
      RItemList[i].Amount := amount;
    end;
    ReArrangeItem;
  end;
end;

//学到武功, 如果已有武功则升级, 如果已满10个不会洗武功

procedure instruct_33(rnum, mnum, dismode: integer);
var
  i, l, x, l1: integer;
  word: WideString;
begin
  if Rmagic[mnum].HurtType = 3 then
  begin
    for i := 0 to 3 do
    begin
      if (Rrole[rnum].neigong[i] <= 0) or (Rrole[rnum].neigong[i] = mnum) then
      begin
        if Rrole[rnum].neigong[i] > 0 then
          Rrole[rnum].NGlevel[i] := Rrole[rnum].NGlevel[i] + 100;
        Rrole[rnum].neigong[i] := mnum;
        if Rrole[rnum].NGLevel[i] > 999 then
          Rrole[rnum].NGlevel[i] := 999;
        break;
      end;
    end;
  end
  else
    for i := 0 to 9 do
    begin
      if (Rrole[rnum].Magic[i] <= 0) or (Rrole[rnum].Magic[i] = mnum) then
      begin
        if Rrole[rnum].Magic[i] > 0 then
          Rrole[rnum].Maglevel[i] := Rrole[rnum].Maglevel[i] + 100;
        Rrole[rnum].Magic[i] := mnum;
        if Rrole[rnum].MagLevel[i] > 999 then
          Rrole[rnum].Maglevel[i] := 999;
        break;
      end;
    end;
  //if i = 10 then rrole[rnum].data[i+63] := magicnum;
  if dismode = 0 then
  begin
    word := UTF8Decode('學會');
    Show3HintString(@Rrole[rnum].Name, @word[1], @Rmagic[mnum].Name);
  end;
end;

procedure instruct_34(rnum, iq: integer);
var
  word: WideString;
begin
  if Rrole[rnum].Aptitude + iq <= 100 then
  begin
    Rrole[rnum].Aptitude := Rrole[rnum].Aptitude + iq;
  end
  else
  begin
    iq := 100 - Rrole[rnum].Aptitude;
    Rrole[rnum].Aptitude := 100;
  end;
  if iq > 0 then
  begin
    word := UTF8Decode('資質增加');
    Show3HintString(@Rrole[rnum].Name, @word[1], pWideChar(UTF8Decode(format('%3d', [iq]))));
  end;
end;

procedure instruct_35(rnum, magiclistnum, magicnum, exp: integer);
var
  i: integer;
begin
  if (magiclistnum < 0) or (magiclistnum > 9) then
  begin
    for i := 0 to 9 do
    begin
      if Rrole[rnum].Magic[i] <= 0 then
      begin
        Rrole[rnum].Magic[i] := magicnum;
        Rrole[rnum].MagLevel[i] := exp;
        break;
      end;
    end;
    if i = 10 then
    begin
      Rrole[rnum].Magic[0] := magicnum;
      Rrole[rnum].MagLevel[i] := exp;
    end;
  end
  else
  begin
    Rrole[rnum].Magic[magiclistnum] := magicnum;
    Rrole[rnum].MagLevel[magiclistnum] := exp;
  end;
end;

function instruct_36(sexual, jump1, jump2: integer): integer;
begin
  Result := jump2;
  if Rrole[0].Sexual = sexual then
    Result := jump1;
  if sexual > 255 then
    if x50[$7000] = 0 then
      Result := jump1
    else
      Result := jump2;
end;

procedure instruct_37(Ethics: integer);
begin
  Rrole[0].Ethics := Rrole[0].Ethics + ethics;
  if Rrole[0].Ethics > 100 then
    Rrole[0].Ethics := 100;
  if Rrole[0].Ethics < 0 then
    Rrole[0].Ethics := 0;
end;

procedure instruct_38(snum, layernum, oldpic, newpic: integer);
var
  i1, i2: integer;
begin
  if snum = -2 then
    snum := CurScence;
  for i1 := 0 to 63 do
    for i2 := 0 to 63 do
    begin
      if Sdata[snum, layernum, i1, i2] = oldpic then
        Sdata[snum, layernum, i1, i2] := newpic;
    end;
  if snum = CurScence then
  begin
    //InitialScence(0);
    Redraw;
    NeedRefreshScence := 0;
  end;
end;

procedure instruct_39(snum: integer);
begin
  Rscence[snum].EnCondition := 0;
end;

procedure instruct_40(director: integer);
begin
  Sface := director;
  CurScenceRolePic := 2501 + SFace * 7;
  DrawScence;
end;

procedure instruct_41(rnum, inum, amount: integer);
var
  i, p: integer;
begin
  p := 0;
  for i := 0 to 3 do
  begin
    if Rrole[rnum].TakingItem[i] = inum then
    begin
      Rrole[rnum].TakingItemAmount[i] := Rrole[rnum].TakingItemAmount[i] + amount;
      p := 1;
      break;
    end;
  end;
  if p = 0 then
  begin
    for i := 0 to 3 do
    begin
      if Rrole[rnum].TakingItem[i] = -1 then
      begin
        Rrole[rnum].TakingItem[i] := inum;
        Rrole[rnum].TakingItemAmount[i] := amount;
        break;
      end;
    end;
  end;
  for i := 0 to 3 do
  begin
    if Rrole[rnum].TakingItemAmount[i] <= 0 then
    begin
      Rrole[rnum].TakingItem[i] := -1;
      Rrole[rnum].TakingItemAmount[i] := 0;
    end;
  end;

end;

function instruct_42(jump1, jump2: integer): integer;
var
  i: integer;
begin
  Result := jump2;
  for i := 0 to 5 do
  begin
    if Rrole[Teamlist[i]].Sexual = 1 then
    begin
      Result := jump1;
      break;
    end;
  end;
end;

function instruct_43(inum, jump1, jump2: integer): integer;
var
  i: integer;
begin
  Result := jump2;
  for i := 0 to MAX_ITEM_AMOUNT - 1 do
    if RItemList[i].Number = inum then
    begin
      Result := jump1;
      break;
    end;
end;

procedure instruct_44(enum1, beginpic1, endpic1, enum2, beginpic2, endpic2: integer);
var
  i: integer;
begin
  SData[CurScence, 3, DData[CurScence, enum1, 10], DData[CurScence, enum1, 9]] := enum1;
  SData[CurScence, 3, DData[CurScence, enum2, 10], DData[CurScence, enum2, 9]] := enum2;
  i := 0;
  while SDL_PollEvent(@event) >= 0 do
  begin
    CheckBasicEvent;
    DData[CurScence, enum1, 5] := beginpic1 + i;
    DData[CurScence, enum2, 5] := beginpic2 + i;
    //UpdateScence(DData[CurScence, enum1, 10], DData[CurScence, enum1, 9]);
    //UpdateScence(DData[CurScence, enum2, 10], DData[CurScence, enum2, 9]);
    SDL_Delay(20);
    //DrawScenceWithoutRole(Sx, Sy);
    DrawScence;
    UpdateAllScreen;
    i := i + 1;
    if i > endpic1 - beginpic1 then
      break;
  end;
  //SData[CurScence, 3, DData[CurScence, [enum,10],DData[CurScence, [enum,9]]:=-1;
end;

procedure Show3HintString(str1, str2, str3: pWideChar);
var
  l, l1, l2, l3, x: integer;
begin
  l1 := (DrawLength(str1) + 1) div 2;
  l2 := (DrawLength(str2) + 1) div 2;
  l3 := (DrawLength(str3) + 1) div 2;
  l := l1 + l2 + l3;
  x := CENTER_X - l * 10;
  DrawTextFrame(x - 19, 150, l);
  //DrawRectangle(CENTER_X - 75, 98, 150, 51, 0, ColColor(255), 30);
  if l1 > 0 then
    DrawShadowText(puint16(str1), x, 153, ColColor($64), ColColor($66));
  if l2 > 0 then
    DrawShadowText(puint16(str2), x + l1 * 20, 153, 0, $202020);
  if l3 > 0 then
    DrawShadowText(puint16(str3), x + l1 * 20 + l2 * 20, 153, ColColor($64), ColColor($66));
  UpdateAllScreen;
  WaitAnyKey;
  Redraw;
end;

procedure AddRoleProWithHint(rnum, datalist, value: integer; word: WideString = '');
begin
  Rrole[rnum].Data[datalist] := Rrole[rnum].Data[datalist] + value;
  if word <> '' then
  begin
    Show3HintString((@Rrole[rnum].Name), @word[1], pWideChar(UTF8Decode(format('%d', [value]))));
  end;
end;

procedure instruct_45(rnum, speed: integer);
begin
  AddRoleProWithHint(rnum, (pointer(@Rrole[0].Speed) - pointer(@Rrole[0])) div 2, speed, UTF8Decode('輕功增加'));
end;

procedure instruct_46(rnum, mp: integer);
begin
  AddRoleProWithHint(rnum, (pointer(@Rrole[0].MaxMP) - pointer(@Rrole[0])) div 2, mp, UTF8Decode('內力增加'));
  Rrole[rnum].CurrentMP := Rrole[rnum].MaxMP;
end;

procedure instruct_47(rnum, Attack: integer);
begin
  AddRoleProWithHint(rnum, (pointer(@Rrole[0].Attack) - pointer(@Rrole[0])) div 2, Attack, UTF8Decode('武力增加'));
end;

procedure instruct_48(rnum, hp: integer);
begin
  AddRoleProWithHint(rnum, (pointer(@Rrole[0].MaxHP) - pointer(@Rrole[0])) div 2, hp, UTF8Decode('生命增加'));
  Rrole[rnum].CurrentHP := Rrole[rnum].MaxHP;
end;

procedure instruct_49(rnum, MPpro: integer);
begin
  Rrole[rnum].MPType := MPpro;
end;

function instruct_50(list: array of integer): integer;
var
  i, p: integer;
  //instruct_50e: function (list1: array of integer): Integer;
begin
  Result := 0;
  if list[0] <= 128 then
  begin
    //instruct_50e:='';
    Result := instruct_50e(list[0], list[1], list[2], list[3], list[4], list[5], list[6]);
  end
  else
  begin
    Result := list[6];
    p := 0;
    for i := 0 to 4 do
    begin
      p := p + instruct_18(list[i], 1, 0);
    end;
    if p = 5 then
      Result := list[5];
  end;
end;

procedure instruct_51;
begin
  instruct_1(SOFTSTAR_BEGIN_TALK + random(SOFTSTAR_NUM_TALK), $72, 0);
end;

procedure ShowRolePro(rnum, datalist: integer; word: WideString);
begin
  Redraw;
  Show3HintString(pWideChar(''), pWideChar(word), pWideChar(UTF8Decode(format('%4d', [Rrole[rnum].Data[datalist]]))));
  //Redraw;
end;

procedure instruct_52;
begin
  ShowRolePro(0, (pointer(@Rrole[0].Ethics) - pointer(@Rrole[0])) div 2, UTF8Decode('你的品德指數為：'));
end;

procedure instruct_53;
begin
  ShowRolePro(0, (pointer(@Rrole[0].Repute) - pointer(@Rrole[0])) div 2, UTF8Decode('你的聲望指數為：'));
end;

//Open all scences.
//Note: in primary game, some scences are set to different entrancing condition.

procedure instruct_54;
var
  i: integer;
begin
  for i := 0 to 100 do
  begin
    Rscence[i].EnCondition := 0;
  end;
  Rscence[2].EnCondition := 2;
  Rscence[38].EnCondition := 2;
  Rscence[75].EnCondition := 1;
  Rscence[80].EnCondition := 1;
end;

//Judge the event number.

function instruct_55(enum, value, jump1, jump2: integer): integer;
begin
  Result := jump2;
  if DData[CurScence, enum, 2] = value then
    Result := jump1;
end;

//Add repute.
//声望刚刚超过200时家里出现请帖

procedure instruct_56(Repute: integer);
begin
  Rrole[0].Repute := Rrole[0].Repute + repute;
  if (Rrole[0].Repute > 200) and (Rrole[0].Repute - repute <= 200) then
  begin
    //showmessage('');
    instruct_3([70, 11, 0, 11, $3A4, -1, -1, $1F20, $1F20, $1F20, 0, 18, 21]);
  end;
end;

procedure instruct_57;
var
  i: integer;
begin
  {for i:=0 to endpic1-beginpic1 do
  begin
    DData[CurScence, [enum1,5]:=beginpic1+i;
    DData[CurScence, [enum2,5]:=beginpic2+i;
    UpdateScence(DData[CurScence, [enum1,10],DData[CurScence, [enum1,9]);
    UpdateScence(DData[CurScence, [enum2,10],DData[CurScence, [enum2,9]);
    sdl_delay(20);
    DrawScenceByCenter(Sx,Sy);
    DrawScence;
    SDL_UpdateRect2(screen,0,0,screen.w,screen.h);
  end;}
  instruct_27(-1, 3832 * 2, 3844 * 2);
  instruct_44e(2, 3845 * 2, 3873 * 2, 3, 3874 * 2, 4, 3903 * 2);
end;

procedure instruct_44e(enum1, beginpic1, endpic1, enum2, beginpic2, enum3, beginpic3: integer);
var
  i: integer;
begin
  SData[CurScence, 3, DData[CurScence, enum1, 10], DData[CurScence, enum1, 9]] := enum1;
  SData[CurScence, 3, DData[CurScence, enum2, 10], DData[CurScence, enum2, 9]] := enum2;
  SData[CurScence, 3, DData[CurScence, enum3, 10], DData[CurScence, enum3, 9]] := enum3;
  i := 0;
  while SDL_PollEvent(@event) >= 0 do
  begin
    CheckBasicEvent;
    DData[CurScence, enum1, 5] := beginpic1 + i;
    DData[CurScence, enum2, 5] := beginpic2 + i;
    DData[CurScence, enum3, 5] := beginpic3 + i;
    //UpdateScence(DData[CurScence, enum1, 10], DData[CurScence, enum1, 9]);
    //UpdateScence(DData[CurScence, enum2, 10], DData[CurScence, enum2, 9]);
    //InitialScence(1);
    SDL_Delay(20);
    //DrawScenceWithoutRole(Sx, Sy);
    DrawScence;
    UpdateAllScreen;
    i := i + 1;
    if i > endpic1 - beginpic1 then
      break;
  end;
  //SData[CurScence, 3, DData[CurScence, [enum,10],DData[CurScence, [enum,9]]:=-1;
end;

procedure instruct_58;
var
  i, p: integer;
const
  headarray: array[0..29] of integer = (8, 21, 23, 31, 32, 43, 7, 11, 14, 20, 33, 34, 10, 12, 19,
    22, 56, 68, 13, 55, 62, 67, 70, 71, 26, 57, 60, 64, 3, 69);
begin
  for i := 0 to 14 do
  begin
    p := random(2);
    instruct_1(2854 + i * 2 + p, headarray[i * 2 + p], random(2) * 4 + random(2));
    if not (Battle(102 + i * 2 + p, 0)) then
    begin
      instruct_15;
      break;
    end;
    instruct_14;
    instruct_13;
    if i mod 3 = 2 then
    begin
      instruct_1(2891, 70, 4);
      instruct_12;
      instruct_14;
      instruct_13;
    end;
  end;
  if where <> 3 then
  begin
    instruct_1(2884, 70, 0);
    instruct_1(2885, 70, 0);
    instruct_1(2886, 0, 3);
    instruct_1(2887, 0, 2);
    instruct_1(2888, 19, 1);
    instruct_1(2889, 0, 1);
    instruct_2($8F, 1);
  end;

end;

//全员离队, 但未清除相关事件

procedure instruct_59;
var
  i: integer;
begin
  for i := 1 to 5 do
    CallEvent(BEGIN_LEAVE_EVENT + TeamList[i] * 2);

end;

function instruct_60(snum, enum, pic, jump1, jump2: integer): integer;
begin
  Result := jump2;
  if snum = -2 then
    snum := CurScence;
  if Ddata[snum, enum, 5] = pic then
    Result := jump1;
  //showmessage(inttostr(Ddata[snum,enum,5]));
end;

function instruct_61(jump1, jump2: integer): integer;
var
  i: integer;
begin
  Result := jump1;
  for i := 11 to 24 do
  begin
    if Ddata[CurScence, i, 5] <> 4664 then
    begin
      Result := jump2;
    end;
  end;
end;

procedure instruct_62(enum1, beginpic1, endpic1, enum2, beginpic2, endpic2: integer);
var
  i: integer;
  str: WideString;
begin
  ShowMR := False;//CurScenceRolePic := -1;
  instruct_44(enum1, beginpic1, endpic1, enum2, beginpic2, endpic2);
  where := 3;
  Redraw;
  EndAmi;
  ShowMR := True;
  //display_img('end.png', 0, 0);
  //where := 3;
end;

procedure TextAmi(filename: string);
var
  x, y, i, len: integer;
  str: WideString;
  p: integer;
begin
  TurnBlack;
  Redraw;
  i := FileOpen(AppPath + filename, fmOpenRead);
  len := FileSeek(i, 0, 2);
  FileSeek(i, 0, 0);
  setlength(str, len + 1);
  FileRead(i, str[1], len);
  FileClose(i);
  p := 1;
  x := 70;
  y := 190;
  DrawRectangleWithoutFrame(0, 0, CENTER_X * 2, CENTER_Y * 2, 0, 60);
  for i := 1 to len + 1 do
  begin
    if str[i] = widechar(10) then
      str[i] := ' ';
    if str[i] = widechar(13) then
    begin
      str[i] := widechar(0);
      DrawShadowText(@str[p], x, y, ColColor($FF), ColColor($FF));
      p := i + 1;
      y := y + 25;
      UpdateAllScreen;
    end;
    if str[i] = widechar($2A) then
    begin
      str[i] := ' ';
      y := 190;
      Redraw;
      WaitAnyKey;
      DrawRectangleWithoutFrame(0, 0, CENTER_X * 2, CENTER_Y * 2, 0, 60);
    end;
  end;
  WaitAnyKey;
  TurnBlack;
  //instruct_13;
  BlackScreen := 0;
end;

procedure EndAmi;
var
  i: integer;
  words: TStringList;
begin
  words := TStringList.Create;
  words.LoadFromFile(AppPath + 'list/end.txt');
  PlayMP3(startmusic, -1);
  ScrollTextAmi(words, 26, 25, 33, 1, 40, 0, 30, -1, 0);
  words.Free;
  for i := CENTER_Y * 2 - TitlePNGIndex[1].h to 0 do
  begin
    if i mod 5 = 0 then
      DrawTPic(1, CENTER_X - 320, i);
    UpdateAllScreen;
    SDL_Delay(6);
  end;
  SDL_Delay(1000);
  Maker;
  //WaitAnyKey;

end;

//Set sexual.

procedure instruct_63(rnum, sexual: integer);
begin
  Rrole[rnum].Sexual := sexual;
end;

//韦小宝的商店

procedure instruct_64;
var
  i, amount, shopnum, menu, price: integer;
  list: array[0..4] of integer;
  menuString, menuEngString: array [0..4] of WideString;
begin
  //amount := 0;
  //任选一个商店, 因未写他去其他客栈的指令
  shopnum := random(5);
  NewShop(shopnum);
  instruct_1($BA0, $6F, 0);
  //p:=0;
  {for i := 0 to 4 do
  begin
    if Rshop[shopnum].Amount[i] > 0 then
    begin
      menuString[amount] := PreSpaceUnicode(@Ritem[Rshop[shopnum].Item[i]].Name);
      menuEngString[amount] := format('%10d', [Rshop[shopnum].Price[i]]);
      list[amount] := i;
      amount := amount + 1;
    end;
  end;
  instruct_1($B9E, $6F, 0);
  menu := CommonMenu(CENTER_X - 100, 150, 85 + length(menuEngString[0]) * 10, amount - 1, 0,
    menuString, menuEngString);
  if menu >= 0 then
  begin
    menu := list[menu];
    price := Rshop[shopnum].Price[menu];
    if instruct_31(price, 1, 0) = 1 then
    begin
      instruct_2(Rshop[shopnum].Item[menu], 1);
      instruct_32(MONEY_ID, -price);
      Rshop[shopnum].Amount[menu] := Rshop[shopnum].Amount[menu] - 1;
      instruct_1($BA0, $6F, 0);
    end
    else
      instruct_1($B9F, $6F, 0);
  end;}
end;

procedure instruct_66(musicnum: integer);
begin
  StopMP3;
  PlayMP3(musicnum, -1);
end;

procedure instruct_67(Soundnum: integer);
begin
  PlaySoundA(SoundNum, 0);
  {  if SoundNum in [Low(Asound)..High(Asound)] then
      if Asound[SoundNum] <> nil then
        Mix_PlayChannel(-1, Asound[SoundNum], 0);}
end;

//50指令中获取变量值

function e_GetValue(bit, t, x: integer): integer;
var
  i: integer;
begin
  i := t and (1 shl bit);
  if i = 0 then
    Result := x
  else
    Result := x50[x];
end;

//Expanded 50 instructs.

function instruct_50e(code, e1, e2, e3, e4, e5, e6: integer): integer;
var
  i, t1, grp, idx, offset, len, i1, i2: integer;
  p, p1: pchar;
  pw, pw1: puint16;
  //ps :pstring;
  str: string;
  word: WideString;
  wordutf8, word1utf8: WideString;
  menuString, menuEngString: array of WideString;
begin
  Result := 0;
  //writeln('Expanded 50, the code is ', code);
  case code of
    0: //Give a value to a papameter.
    begin
      x50[e1] := e2;
    end;
    1: //Give a value to one member in parameter group.
    begin
      t1 := e3 + e_GetValue(0, e1, e4);
      x50[t1] := e_GetValue(1, e1, e5);
      if e2 = 1 then
        x50[t1] := x50[t1] and $FF;
    end;
    2: //Get the value of one member in parameter group.
    begin
      t1 := e3 + e_GetValue(0, e1, e4);
      x50[e5] := x50[t1];
      if e2 = 1 then
        x50[t1] := x50[t1] and $FF;
    end;
    3: //Basic calculations.
    begin
      t1 := e_GetValue(0, e1, e5);
      case e2 of
        0: x50[e3] := x50[e4] + t1;
        1: x50[e3] := x50[e4] - t1;
        2: x50[e3] := x50[e4] * t1;
        3: if t1 <> 0 then
            x50[e3] := x50[e4] div t1;
        4: if t1 <> 0 then
            x50[e3] := x50[e4] mod t1;
        5: if t1 <> 0 then
            x50[e3] := uint16(x50[e4]) div t1;
      end;
    end;
    4: //Judge the parameter.
    begin
      x50[$7000] := 0;
      t1 := e_GetValue(0, e1, e4);
      case e2 of
        0: if not (x50[e3] < t1) then
            x50[$7000] := 1;
        1: if not (x50[e3] <= t1) then
            x50[$7000] := 1;
        2: if not (x50[e3] = t1) then
            x50[$7000] := 1;
        3: if not (x50[e3] <> t1) then
            x50[$7000] := 1;
        4: if not (x50[e3] >= t1) then
            x50[$7000] := 1;
        5: if not (x50[e3] > t1) then
            x50[$7000] := 1;
        6: x50[$7000] := 0;
        7: x50[$7000] := 1;
      end;
    end;
    5: //Zero all parameters.
    begin
      fillchar(x50[Low(x50)], sizeof(x50), 0);
    end;
    8: //Read talk to string.
    begin
      t1 := e_GetValue(0, e1, e2);
      if t1 <= 0 then
      begin
        len := TIdx[0];
        offset := 0;
      end
      else
      begin
        len := TIdx[t1] - TIdx[t1 - 1];
        offset := TIdx[t1 - 1];
      end;
      move(Tdef[offset], x50[e3], len);
      p := @x50[e3];
      Inc(p, len);
      p^ := char(0);
    end;
    9: //Format the string.
    begin
      e4 := e_GetValue(0, e1, e4);
      pw := @x50[e2];
      pw1 := @x50[e3];
      word := format(pWideChar(pw1), [e4]);
      //showmessage(pwidechar(pw1)+word);
      for i := 0 to length(word) - 1 do
      begin
        pw^ := uint16(word[i + 1]);
        Inc(pw);
      end;
      pw^ := 0;
    end;
    10: //Get the length of a string.
    begin
      x50[e2] := DrawLength(pWideChar(@x50[e1]));
      //showmessage(inttostr(x50[e2]));
    end;
    11: //Combine 2 strings.
    begin
      pw := @x50[e1];
      pw1 := @x50[e2];
      for i := 0 to length(pWideChar(pw1)) - 1 do
      begin
        pw^ := pw1^;
        Inc(pw);
        Inc(pw1);
      end;
      pw1 := @x50[e3];
      for i := 0 to length(pWideChar(pw1)) do
      begin
        pw^ := pw1^;
        Inc(pw);
        Inc(pw1);
      end;
      //p^:=char(0);
    end;
    12: //Build a string with spaces.
      //Note: here the width of one 'space'is the same as one Chinese charactor.
    begin
      e3 := e_GetValue(0, e1, e3);
      pw := @x50[e2];
      for i := 1 to e3 do
      begin
        pw^ := $20;
        Inc(pw);
      end;
      pw^ := 0;
    end;
    16: //Write R data.
    begin
      e3 := e_GetValue(0, e1, e3);
      e4 := e_GetValue(1, e1, e4);
      e5 := e_GetValue(2, e1, e5);
      case e2 of
        0: Rrole[e3].Data[e4 div 2] := e5;
        1: Ritem[e3].Data[e4 div 2] := e5;
        2:
        begin
          Rscence[e3].Data[e4 div 2] := e5;
          if (e4 >= 20) and (e4 < 28) then
          begin
            ReSetEntrance;
          end;
        end;
        3: Rmagic[e3].Data[e4 div 2] := e5;
        4: Rshop[e3].Data[e4 div 2] := e5;
      end;
    end;
    17: //Read R data.
    begin
      e3 := e_GetValue(0, e1, e3);
      e4 := e_GetValue(1, e1, e4);
      case e2 of
        0: x50[e5] := Rrole[e3].Data[e4 div 2];
        1: x50[e5] := Ritem[e3].Data[e4 div 2];
        2: x50[e5] := Rscence[e3].Data[e4 div 2];
        3: x50[e5] := Rmagic[e3].Data[e4 div 2];
        4: x50[e5] := Rshop[e3].Data[e4 div 2];
      end;
    end;
    18: //Write team data.
    begin
      e2 := e_GetValue(0, e1, e2);
      e3 := e_GetValue(1, e1, e3);
      TeamList[e2] := e3;
      //showmessage(inttostr(e3));
    end;
    19: //Read team data.
    begin
      e2 := e_GetValue(0, e1, e2);
      x50[e3] := TeamList[e2];
    end;
    20: //Get the amount of one item.
    begin
      e2 := e_GetValue(0, e1, e2);
      x50[e3] := 0;
      for i := 0 to MAX_ITEM_AMOUNT - 1 do
        if RItemList[i].Number = e2 then
        begin
          x50[e3] := RItemList[i].Amount;
          break;
        end;
      //showmessage('rer');
    end;
    21: //Write event in scence.
    begin
      e2 := e_GetValue(0, e1, e2);
      e3 := e_GetValue(1, e1, e3);
      e4 := e_GetValue(2, e1, e4);
      e5 := e_GetValue(3, e1, e5);
      Ddata[e2, e3, e4] := e5;
      if e2 = CurScence then
        NeedRefreshScence := 1;
      //if e2=CurScence then DData[CurScence, [e3,e4]:=e5;
      //InitialScence;
      //Redraw;
      //SDL_UpdateRect2(screen,0,0,screen.w,screen.h);
    end;
    22:
    begin
      e2 := e_GetValue(0, e1, e2);
      e3 := e_GetValue(1, e1, e3);
      e4 := e_GetValue(2, e1, e4);
      x50[e5] := Ddata[e2, e3, e4];
    end;
    23:
    begin
      e2 := e_GetValue(0, e1, e2);
      e3 := e_GetValue(1, e1, e3);
      e4 := e_GetValue(2, e1, e4);
      e5 := e_GetValue(3, e1, e5);
      e6 := e_GetValue(4, e1, e6);
      Sdata[e2, e3, e5, e4] := e6;
      if e2 = CurScence then
        NeedRefreshScence := 1;
      //if e2=CurScence then SData[CurScence, 3, e5,e4]:=e6;;
      //InitialScence;
      //Redraw;
      //SDL_UpdateRect2(screen,0,0,screen.w,screen.h);
    end;
    24:
    begin
      e2 := e_GetValue(0, e1, e2);
      e3 := e_GetValue(1, e1, e3);
      e4 := e_GetValue(2, e1, e4);
      e5 := e_GetValue(3, e1, e5);
      x50[e6] := Sdata[e2, e3, e5, e4];
      //showmessage(inttostr(sface));
    end;
    25:
    begin
      e5 := e_GetValue(0, e1, e5);
      e6 := e_GetValue(1, e1, e6);
      t1 := uint16(e3) + uint16(e4) * $10000 + uint16(e6);
      i := uint16(e3) + uint16(e4) * $10000;
      case t1 of
        $1D295A: Sx := e5;
        $1D295C: Sy := e5;
        //$1D2956: Cx := e5;
        //$1D2958: Cy := e5;
        //$0544f2:
      end;
      case i of
        $18FE2C:
        begin
          if e6 mod 4 <= 1 then
            Ritemlist[e6 div 4].Number := e5
          else
            Ritemlist[e6 div 4].Amount := e5;
        end;
        $051C83:
        begin
          Acol[e6] := e5 mod 256;
          Acol[e6 + 1] := e5 div 256;
          Acol1[e6] := ACol[e6];
          Acol1[e6 + 1] := ACol[e6 + 1];
          Acol2[e6] := ACol[e6];
          Acol2[e6 + 1] := ACol[e6 + 1];
        end;
        $01D295E:
        begin
          CurScence := e5;
          InitialScence;
        end;
      end;
      //redraw;
      UpdateAllScreen;
    end;
    26:
    begin
      e6 := e_GetValue(0, e1, e6);
      t1 := uint16(e3) + uint16(e4) * $10000 + uint(e6);
      i := uint16(e3) + uint16(e4) * $10000;
      case t1 of
        $1D295E: x50[e5] := CurScence;
        $1D295A: x50[e5] := Sx;
        $1D295C: x50[e5] := Sy;
        $1C0B88: x50[e5] := Mx;
        $1C0B8C: x50[e5] := My;
        //$1D2956: x50[e5] := Cx;
        //$1D2958: x50[e5] := Cy;
        $05B53A: x50[e5] := 1;
        $0544F2: x50[e5] := Sface;
        $1E6ED6: x50[e5] := x50[28100];
        $556DA: x50[e5] := Ax;
        $556DC: x50[e5] := Ay;
        $1C0B90: x50[e5] := SDL_GetTicks div 55 mod 65536;
      end;
      if (t1 - $18FE2C >= 0) and (t1 - $18FE2C < 800) then
      begin
        i := t1 - $18FE2C;
        //showmessage(inttostr(e3));
        if i mod 4 <= 1 then
          x50[e5] := Ritemlist[i div 4].Number
        else
          x50[e5] := Ritemlist[i div 4].Amount;
      end;

      if (t1 >= $1E4A04) and (t1 < $1E6A04) then
      begin
        i := (t1 - $1E4A04) div 2;
        //showmessage(inttostr(e3));
        x50[e5] := Bfield[2, i mod 64, i div 64];
      end;
    end;
    27: //Read name to string.
    begin
      e3 := e_GetValue(0, e1, e3);
      pw := @x50[e4];
      case e2 of
        0: pw1 := @Rrole[e3].Name;
        1: pw1 := @Ritem[e3].Name;
        2: pw1 := @Rscence[e3].Name;
        3: pw1 := @Rmagic[e3].Name;
      end;
      for i := 0 to 4 do
      begin
        pw^ := pw1^;
        if pw1^ = 0 then
          break;
        Inc(pw);
        Inc(pw1);
      end;
      //(p + i)^ := char($20);
      Inc(pw);
      pw^ := 0;
      //(p + i + 1)^ := char(0);
    end;
    28: //Get the battle number.
    begin
      x50[e1] := x50[28005];
    end;
    29: //Select aim.
    begin
      e2 := e_GetValue(0, e1, e2);
      e3 := e_GetValue(1, e1, e3);
      //showmessage('IN CASE');
      if e5 = 0 then
      begin
        SelectAim(e2, e3);
      end;
      x50[e4] := bfield[2, Ax, Ay];
    end;
    30: //Read battle properties.
    begin
      e2 := e_GetValue(0, e1, e2);
      e3 := e_GetValue(1, e1, e3);
      x50[e4] := Brole[e2].Data[e3 div 2];
    end;
    31: //Write battle properties.
    begin
      e2 := e_GetValue(0, e1, e2);
      e3 := e_GetValue(1, e1, e3);
      e4 := e_GetValue(2, e1, e4);
      Brole[e2].Data[e3 div 2] := e4;
    end;
    32: //Modify next instruct.
    begin
      e3 := e_GetValue(0, e1, e3);
      Result := 655360 * (e3 + 1) + x50[e2];
      if KDEF_SCRIPT > 0 then
      begin
        p5032pos := e3;
        p5032value := x50[e2];
      end;
      //showmessage(inttostr(result));
    end;
    33: //Draw a string.
    begin
      e3 := e_GetValue(0, e1, e3);
      e4 := e_GetValue(1, e1, e4);
      e5 := e_GetValue(2, e1, e5);
      //showmessage(inttostr(e5));
      i := 0;
      t1 := 0;
      pw := @x50[e2];
      pw1 := pw;
      //writeln(WideString(PWideChar(pw)));
      while uint16(pw^) > 0 do
      begin
        if uint16(pw^) = $2A then
        begin
          pw^ := 0;
          //DrawU16ShadowText(pchar(pw1), e3 - 2, e4 + 22 * i - 25, ColColor(e5 and $FF), ColColor((e5 and $FF00) shr 8));
          DrawU16ShadowText(pchar(pw1), e3 - 2, e4 + 22 * i - 25, 0, $202020);
          i := i + 1;
          pw1 := pw;
          Inc(pw1);
        end;
        Inc(pw);
      end;
      //Drawu16ShadowText(pchar(pw1), e3 - 2, e4 + 22 - 25, ColColor(e5 and $FF), ColColor((e5 and $FF00) shr 8));
      Drawu16ShadowText(pchar(pw1), e3 - 2, e4 + 22 - 25, 0, $202020);
      UpdateAllScreen;
      //waitanykey;
    end;
    34: //Draw a rectangle as background.
    begin
      e2 := e_GetValue(0, e1, e2);
      e3 := e_GetValue(1, e1, e3);
      e4 := e_GetValue(2, e1, e4);
      e5 := e_GetValue(3, e1, e5);
      e6 := e_GetValue(4, e1, e6);
      DrawRectangle(e2, e3, e4, e5, 0, ColColor($FF), max(e6, 40));
      //SDL_UpdateRect2(screen,e1,e2,e3+1,e4+1);
    end;
    35: //Pause and wait a key.
    begin
      i := WaitAnyKey;
      x50[e1] := i;
      case i of
        SDLK_LEFT: x50[e1] := 154;
        SDLK_RIGHT: x50[e1] := 156;
        SDLK_UP: x50[e1] := 158;
        SDLK_DOWN: x50[e1] := 152;
      end;
      if (i < 266) and (i >= 256) then
        x50[e1] := i - 208;
    end;
    36: //Draw a string with background then pause, if the key pressed is 'Y'then jump=0.
    begin
      e3 := e_GetValue(0, e1, e3);
      e4 := e_GetValue(1, e1, e4);
      e5 := e_GetValue(2, e1, e5);
      //word := PreSpaceunicode(@x50[e2]);
      //t1 := length(word);
      //drawtextwithrect(@word[1], e3, e4, t1 * 20 - 15, colcolor(e5 and $FF), colcolor((e5 and $FF00) shl 8));
      pw := @x50[e2];
      i1 := 1;
      i2 := 0;
      t1 := 0;
      while (pw^) > 0 do
      begin
        //showmessage('');
        if (pw^) = $2A then
        begin
          if t1 > i2 then
            i2 := t1;
          t1 := 0;
          i1 := i1 + 1;
        end;
        if (pw^) = $20 then
          t1 := t1 + 1;
        Inc(pw);
        t1 := t1 + 1;
      end;
      if t1 > i2 then
        i2 := t1;
      Inc(pw, -1);
      if i1 = 0 then
        i1 := 1;
      if (pw^) = $2A then
        i1 := i1 - 1;
      //DrawRectangle(e3, e4, i2 * 20 + 25, i1 * 22 + 5, 0, ColColor(255), 30);
      DrawTextFrame(e3, e4, i2);
      pw := @x50[e2];
      pw1 := pw;
      i := 0;
      while uint16(pw^) > 0 do
      begin
        if uint16(pw^) = $2A then
        begin
          pw^ := 0;
          DrawU16ShadowText(pchar(pw1), e3 + 3, e4 + 22 * i + 2, ColColor(e5 and $FF),
            ColColor((e5 and $FF00) shr 8));
          i := i + 1;
          pw1 := pw;
          Inc(pw1);
        end;
        Inc(pw);
      end;
      DrawU16ShadowText(pchar(pw1), e3 + 3, e4 + 22 * i + 2, ColColor(e5 and $FF), ColColor((e5 and $FF00) shr 8));
      UpdateAllScreen;
      i := WaitAnyKey;
      if i = SDLK_y then
        x50[$7000] := 0
      else
        x50[$7000] := 1;
      //redraw;
    end;
    37: //Delay.
    begin
      e2 := e_GetValue(0, e1, e2);
      SDL_Delay(e2);
    end;
    38: //Get a number randomly.
    begin
      e2 := e_GetValue(0, e1, e2);
      x50[e3] := random(e2);
    end;
    39: //Show a menu to select. The 40th instruct is too complicable, just use the 39th.
    begin
      e2 := e_GetValue(0, e1, e2);
      e5 := e_GetValue(1, e1, e5);
      e6 := e_GetValue(2, e1, e6);
      setlength(menuString, e2);
      setlength(menuEngString, 0);
      t1 := 0;
      for i := 0 to e2 - 1 do
      begin
        menuString[i] := '';
        menuString[i] := pWideChar(@x50[x50[e3 + i]]);
        i1 := DrawLength(pWideChar(@x50[x50[e3 + i]]));
        if i1 > t1 then
          t1 := i1;
      end;
      x50[e4] := CommonMenu(e5, e6, t1 * 10 + 7, e2 - 1, 0, menuString) + 1;
    end;
    40: //Show a menu to select.
    begin
      e2 := e_GetValue(0, e1, e2);
      e5 := e_GetValue(1, e1, e5);
      e6 := e_GetValue(2, e1, e6);
      setlength(menuString, e2);
      setlength(menuEngString, 0);
      i2 := 0;
      for i := 0 to e2 - 1 do
      begin
        menuString[i] := '';
        menuString[i] := pWideChar(@x50[x50[e3 + i]]);
        i1 := DrawLength(pWideChar(@x50[x50[e3 + i]]));
        if i1 > i2 then
          i2 := i1;
      end;
      t1 := (e1 shr 8) and $FF;
      if t1 = 0 then
        t1 := 5;
      x50[e4] := CommonScrollMenu(e5, e6, i2 * 10 + 7, e2 - 1, t1, menuString) + 1;
    end;
    41: //Draw a picture.
    begin
      e3 := e_GetValue(0, e1, e3);
      e4 := e_GetValue(1, e1, e4);
      e5 := e_GetValue(2, e1, e5);
      case e2 of
        0:
        begin
          if where = 1 then
            DrawSPic(e5 div 2, e3, e4)
          else
            DrawMPic(e5 div 2, e3, e4);
        end;
        1: DrawHeadPic(e5, e3, e4);
        2:
        begin
          //str := 'pic/' + IntToStr(e5) + '.png';
          //display_img(@str[1], e3, e4);
        end;
      end;
      UpdateAllScreen;
    end;
    42: //Change the poistion on world map.
    begin
      e2 := e_GetValue(0, e1, e2);
      e3 := e_GetValue(0, e1, e3);
      Mx := e3;
      My := e2;
    end;
    43: //Call another event.
    begin
      e2 := e_GetValue(0, e1, e2);
      e3 := e_GetValue(1, e1, e3);
      e4 := e_GetValue(2, e1, e4);
      e5 := e_GetValue(3, e1, e5);
      e6 := e_GetValue(4, e1, e6);
      x50[$7100] := e3;
      x50[$7101] := e4;
      x50[$7102] := e5;
      x50[$7103] := e6;
      writeln('Call another event or special process, the code is ', e2, ' - ', e3, ' ', e4, ' ', e5, ' ', e6);

      case e2 of
        201: NewTalk(e3, e4, e5, e6 mod 100, (e6 mod 100) div 10, e6 div 100, 0);
        202: ScreenBlendMode := 0; //白天
        203: ScreenBlendMode := 1;  //夜晚
        204: ScreenBlendMode := 2;  //黄昏
        205: x50[126] := Digging(e3, e4, e5, e6);
        207: ShowStarList;
        208: x50[28929] := GetStarState(e3);
        209: SetStarState(e3, e4);
        210: NewTeammateList;
        213:
        begin
          if e6 = 1 then
            e4 := 0 - e4;
          if e5 = 0 then
            instruct_2(e3, e4)
          else
            instruct_32(e3, e4);
        end;
        214: x50[10032] := EnterNumber(-32768, 32767, CENTER_X - 90, CENTER_Y - 90);
        217:
        begin
          x50[$7000] := 1;
          if SpellPicture(e3, e4) then
            x50[$7000] := 0;
        end;
        219: ReArrangeItem(1);
        223: ShowMap;
        228: ShowTeamMate(e3, e4, e5);
        236:
        begin
          x50[$7000] := 1;
          if Lamp(e3, e4, e5, 0) then
            x50[$7000] := 0;
        end;
        242: RoleEnding(e3, e4, e5);
        243: MissionList(e3);
        244: SetMissionState(e3, e4);
        246:
        begin
          x50[$7000] := 1;
          if WoodMan(e3) then
            x50[$7000] := 0;
        end;
        247:
        begin
          showMR := True;
          if e3 = 1 then
            showMR := False;
        end;
        253: BookList;
        254: x50[e3] := GetStarAmount;
        255: x50[e3] := DancerAfter90S;
        352: ShowTitle(e3, 1);
        365: NewShop(e3);   //商店
        369: x50[15205] := EnterNumber(0, e3, e5, e6);
        else
          CallEvent(e2);
      end;
      //showmessage(inttostr(e2));
    end;
    44: //Play amination.
    begin
      e2 := e_GetValue(0, e1, e2);
      if e2 > 100 then
        e2 := e_GetValue(0, 1, e2);
      e3 := e_GetValue(1, e1, e3);
      e4 := e_GetValue(2, e1, e4);
      PlayActionAmination(e2, e3);
      PlayMagicAmination(e2, e4);
    end;
    45: //Show values.
    begin
      e2 := e_GetValue(0, e1, e2);
      case e2 of
        1: e2 := 0;
        2: e2 := 2;
        3: e2 := 4;
        4: e2 := 3;
        5: e2 := 1;
      end;
      ShowHurtValue(e2);
    end;
    46: //Set effect layer.
    begin
      e2 := e_GetValue(0, e1, e2);
      e3 := e_GetValue(1, e1, e3);
      e4 := e_GetValue(2, e1, e4);
      e5 := e_GetValue(3, e1, e5);
      e6 := e_GetValue(4, e1, e6);
      for i1 := e2 to e2 + e4 - 1 do
        for i2 := e3 to e3 + e5 - 1 do
          bfield[4, i2, i1] := e6;
    end;
    47: //Here no need to re-set the pic, reset it to force refresh.
    begin
      Redraw;
      //UpdateAllScreen;
    end;
    48: //Show some parameters.
    begin
      str := '';
      for i := e1 to e1 + e2 - 1 do
        str := str + 'x' + IntToStr(i) + '=' + IntToStr(x50[i]) + char(13) + char(10);
      //messagebox(0, @str[1], 'KYS Windows', MB_OK);
    end;
    49: //In PE files, you can't call any procedure as your wish.
    begin
    end;
    50: //Enter name for items, magics and roles.
    begin
      e2 := e_GetValue(0, e1, e2);
      e3 := e_GetValue(1, e1, e3);
      e4 := e_GetValue(2, e1, e4);
      e5 := e_GetValue(3, e1, e5);
      //e2 := 0;
      //e5 := 10;
      case e2 of
        0: p := @Rrole[e3].Name[0];
        1: p := @Ritem[e3].Name[0];
        2: p := @Rmagic[e3].Name[0];
        3: p := @Rscence[e3].Name[0];
      end;
      //ShowMessage(IntToStr(e4));
      {$ifdef fpc}
      word1utf8 := CP950ToUTF8(p);
      {$else}
      word1 := Big5ToUnicode(p);
      word1 := MidStr(word1, 2, length(word1) - 1);
      {$endif}
      wordutf8 := '請輸入名字：';
      if FULLSCREEN = 0 then
        wordutf8 := InputBox('Enter name', wordutf8, word1utf8);
      {$ifdef fpc}
      str := UTF8ToCP950(wordutf8);
      {$else}
      str := UnicodeToBig5(@word[1]);
      {$endif}
      p1 := @str[1];
      for i := 0 to min(e5, length(p1)) - 1 do
        (p + i)^ := (p1 + i)^;
    end;
    51: //Enter a number.
    begin
      if FULLSCREEN = 0 then
        while (True) do
        begin
          wordutf8 := InputBox('输入数量 ', '输入数量', '0');
          try
            i := StrToInt(wordutf8);
            break;
          except
            ShowMessage('输入错误，请重新输入!');
          end;
        end;
      x50[e1] := i;
    end;
    52: //Judge someone grasp some mggic.
    begin
      e2 := e_GetValue(0, e1, e2);
      e3 := e_GetValue(1, e1, e3);
      e4 := e_GetValue(2, e1, e4);
      x50[$7000] := 1;
      if (HaveMagic(e2, e3, e4) = True) then
        x50[$7000] := 0;
    end;
    53: //increase someone's properties (18, 42, 43~58).
    begin
      e2 := e_GetValue(0, e1, e2);
      e3 := e_GetValue(1, e1, e3);
      e4 := e_GetValue(2, e1, e4);
      if (e3 >= 43) and (e3 <= 58) then
        Rrole[e2].Data[e3] := RegionParameter(Rrole[e2].Data[e3] + e4, 0, MaxProList[e3]);
      if e3 = 18 then
      begin
        Rrole[e2].MaxHP := min(Rrole[e2].MaxHP + e4, MAX_HP);
        Rrole[e2].CurrentHP := min(Rrole[e2].CurrentHP + e4, Rrole[e2].MaxHP);
      end;
      if e3 = 42 then
      begin
        Rrole[e2].MaxMP := min(Rrole[e2].MaxMP + e4, MAX_MP);
        Rrole[e2].CurrentMP := min(Rrole[e2].CurrentMP + e4, Rrole[e2].MaxMP);
      end;
    end;
    54:
    begin

    end;
    60: //Call scripts.
    begin
      e2 := e_GetValue(0, e1, e2);
      e3 := e_GetValue(1, e1, e3);
      ExecScript(AppPath + 'script/' + IntToStr(e2) + '.lua', 'f' + IntToStr(e3));
    end;
  end;

end;

//判断某人有否某武功某级

function HaveMagic(person, mnum, lv: integer): boolean;
var
  i: integer;
begin
  Result := False;
  for i := 0 to 9 do
    if (Rrole[person].Magic[i] = mnum) then
      if (Rrole[person].MagLevel[i] >= lv) then
      begin
        Result := True;
        break;
      end;
  if not Result then
    for i := 0 to 3 do
      if (Rrole[person].NeiGong[i] = mnum) then
        if (Rrole[person].NGLevel[i] >= lv) then
        begin
          Result := True;
          break;
        end;
end;

//计算某人武功数量

function HaveMagicAmount(rnum: integer; NeiGong: integer = 0): integer;
var
  i: integer;
begin
  Result := 0;
  if NeiGong = 0 then
  begin
    for i := 0 to 9 do
      if (Rrole[rnum].Magic[i] > 0) then
        Result := Result + 1;
  end
  else
  begin
    for i := 0 to 3 do
      if (Rrole[rnum].NeiGong[i] > 0) then
        Result := Result + 1;
  end;
end;

function GetMagicLevel(person, mnum: integer): integer;
var
  i: integer;
begin
  Result := 0;
  if mnum > 0 then
  begin
    case Rmagic[mnum].HurtType of
      3:
        for i := 0 to 3 do
        begin
          if (Rrole[person].NeiGong[i] = mnum) then
            Result := Rrole[person].NGLevel[i] div 100 + 1;
          if Result > 0 then
            break;
        end;
      0, 1, 2:
        for i := 0 to 9 do
        begin
          if (Rrole[person].Magic[i] = mnum) then
            Result := Rrole[person].MagLevel[i] div 100 + 1;
          if Result > 0 then
            break;
        end;
    end;
  end;

end;

procedure StudyMagic(rnum, magicnum, newmagicnum, level, dismode: integer);
var
  i: integer;
  word: WideString;
begin
  for i := 0 to 9 do
  begin
    if (Rrole[rnum].Magic[i] = magicnum) or (Rrole[rnum].Magic[i] = newmagicnum) then
    begin
      if level <> -2 then
        Rrole[rnum].Maglevel[i] := Rrole[rnum].Maglevel[i] + level * 100;
      Rrole[rnum].Magic[i] := newmagicnum;
      if Rrole[rnum].MagLevel[i] > 999 then
        Rrole[rnum].Maglevel[i] := 999;
      break;
    end;
  end;
  //if i = 10 then rrole[rnum].data[i+63] := magicnum;
  if dismode = 0 then
  begin
    DrawRectangle(CENTER_X - 75, 98, 145, 76, 0, ColColor(255), 30);
    word := '學會';
    DrawShadowText(@word[1], CENTER_X - 90, 125, ColColor(5), ColColor(7));
    DrawU16ShadowText(@Rrole[rnum].Name, CENTER_X - 90, 100, ColColor($21), ColColor($23));
    DrawU16ShadowText(@Rmagic[newmagicnum].Name, CENTER_X - 90, 150, ColColor($64), ColColor($66));
    UpdateAllScreen;
    WaitAnyKey;
    Redraw;
  end;
end;

procedure DivideName(fullname: WideString; var surname, givenname: WideString);
var
  surname2: TStringList;
  len, i, hysur: integer;
begin
  len := Length(fullname);
  case len of
    1:
    begin
      surname := '';
      givenname := fullname;
    end;
    2:
    begin
      surname := Copy(fullname, 1, 1);
      givenname := Copy(fullname, 2, 1);
    end;
    3:
    begin
      surname2 := TStringList.Create;
      surname2.Add('歐陽');
      surname2.Add('太史');
      surname2.Add('端木');
      surname2.Add('上官');
      surname2.Add('司馬');
      surname2.Add('東方');
      surname2.Add('獨孤');
      surname2.Add('南宮');
      surname2.Add('萬俟');
      surname2.Add('聞人');
      surname2.Add('夏侯');
      surname2.Add('諸葛');
      surname2.Add('尉遲');
      surname2.Add('公羊');
      surname2.Add('赫連');
      surname2.Add('澹台');
      surname2.Add('皇甫');
      surname2.Add('宗政');
      surname2.Add('濮陽');
      surname2.Add('公冶');
      surname2.Add('太叔');
      surname2.Add('申屠');
      surname2.Add('公孫');
      surname2.Add('慕容');
      surname2.Add('仲孫');
      surname2.Add('鍾離');
      surname2.Add('長孫');
      surname2.Add('宇文');
      surname2.Add('司徒');
      surname2.Add('鮮於');
      surname2.Add('司空');
      surname2.Add('閭丘');
      surname2.Add('子車');
      surname2.Add('亓官');
      surname2.Add('司寇');
      surname2.Add('巫馬');
      surname2.Add('公西');
      surname2.Add('顓孫');
      surname2.Add('壤駟');
      surname2.Add('公良');
      surname2.Add('漆雕');
      surname2.Add('樂正');
      surname2.Add('宰父');
      surname2.Add('穀梁');
      surname2.Add('拓跋');
      surname2.Add('夾穀');
      surname2.Add('軒轅');
      surname2.Add('令狐');
      surname2.Add('段幹');
      surname2.Add('百裏');
      surname2.Add('呼延');
      surname2.Add('東郭');
      surname2.Add('南門');
      surname2.Add('羊舌');
      surname2.Add('微生');
      surname2.Add('公戶');
      surname2.Add('公玉');
      surname2.Add('公儀');
      surname2.Add('梁丘');
      surname2.Add('公仲');
      surname2.Add('公上');
      surname2.Add('公門');
      surname2.Add('公山');
      surname2.Add('公堅');
      surname2.Add('左丘');
      surname2.Add('公伯');
      surname2.Add('西門');
      surname2.Add('公祖');
      surname2.Add('第五');
      surname2.Add('公乘');
      surname2.Add('貫丘');
      surname2.Add('公皙');
      surname2.Add('南榮');
      surname2.Add('東裏');
      surname2.Add('東宮');
      surname2.Add('仲長');
      surname2.Add('子書');
      surname2.Add('子桑');
      surname2.Add('即墨');
      surname2.Add('達奚');
      surname2.Add('褚師');
      surname2.Add('第二');
      surname := Copy(fullname, 1, 2);
      hysur := 0;
      for i := 0 to surname2.Count - 1 do
      begin
        if surname = UTF8Decode(surname2.Strings[i]) then
        begin
          hysur := 1;
          break;
        end;
      end;
      if hysur = 1 then
      begin
        givenname := Copy(fullname, 3, 1);
      end
      else
      begin
        surname := Copy(fullname, 1, 1);
        givenname := Copy(fullname, 2, 2);
      end;
      surname2.Free;
    end;
    else
    begin
      surname := Copy(fullname, 1, 2);
      givenname := Copy(fullname, 3, len - 2);
    end;
  end;
  //writeln(len, ',', fullname, ',', surname, ',', givenname);
end;


function ReplaceStr(const S, Srch, Replace: WideString): WideString;
var
  i: integer;
  Source: WideString;
begin
  Source := S;
  Result := '';
  repeat
    //i := Pos(UpperCase(Srch), UpperCase(Source));
    i := Pos(Srch, Source);
    if i > 0 then
    begin
      Result := Result + Copy(Source, 1, i - 1) + Replace;
      Source := Copy(Source, i + Length(Srch), MaxInt);
    end
    else
      Result := Result + Source;
  until i <= 0;
end;


procedure NewTalk(headnum, talknum, namenum, place, showhead, color, frame: integer;
  content: WideString = ''; disname: WideString = '');
var
  FileHandle, Offset, len, I, I2, ix, iy, xtemp, a: integer;
  Frame_X, Frame_Y, Frame_W, Frame_H, Head_X, Head_Y, Head_W, Head_H, Name_X, Name_Y, Name_W,
  Name_H, Talk_X, Talk_Y, Talk_W, Talk_H, MaxCol: integer;
  ForeGroundCol, BackGroundCol: byte;
  DrawForeGroundCol, DrawBackGroundCol: cardinal;
  Talk, Name, SurName, GivenName: array of byte;
{$IFDEF fpc}
  FullNameUTF8Str, SurNameUTF8Str, GivenNameUTF8Str: string;
{$ENDIF}
  FullNameStr, SurNameStr, GivenNameStr, TalkStr, NameStr, TempStr: WideString;
  Changed: boolean;
  HeadNumR: integer; //用于重定头像的对应人物, 以正确读取名字
  skipSync: boolean = False;
const
  NameIdxFile = 'resource/name.idx';
  NameGrpFile = 'resource/name.grp';
  TalkIdxFile = 'resource/talk.idx';
  TalkGrpFile = 'resource/talk.grp';
  RowSpacing = 25; //行距
  ColSpacing = 20; //列距
  MaxRow = 5;
  NameColSpacing = 20; //名字列距
  FullNameCode: WideString = '&&';
  SurNameCode: WideString = '$$';
  GivenNameCode: WideString = '%%';
  WaitAnyKeyCode: WideString = '@@';
  DelayCode: WideString = '##';
  NextLineCode: WideString = '**';
  ChangeColorCode: WideString = '^';
  ExpressionMin: integer = 412;
  ExpressionMax: integer = 429;
begin
  MaxCol := 25;
  MaxCol := trunc((CENTER_X * 2 - (768 - MaxCol * ColSpacing)) / ColSpacing);
  //*********设置位置、宽高、颜色等数据*********//
  //对话框边框位置
  Frame_X := 50;
  Frame_Y := CENTER_Y * 2 - 180;

  //对话字串位置及列数、行数
  Talk_X := Frame_X + 170;
  Talk_Y := Frame_Y + 35;
  Talk_W := MaxCol;
  Talk_H := MaxRow;
  Name_X := Talk_X;
  Name_Y := Frame_Y + 7;

  if place = 0 then //头像在左
  begin
    //头像位置
    Head_X := 30;
    Head_Y := CENTER_Y * 2 - 200;
    //名字位置
  end
  else if place = 1 then //头像在右
  begin
    Head_X := CENTER_X * 2 - 200;
    Head_Y := CENTER_Y * 2 - 200;
    Talk_X := Frame_X;
    Name_X := Talk_X;
    Name_Y := Frame_Y + 7;
  end
  else if place = 2 then
  begin
    Talk_X := Frame_X + 70;
  end;

  //特殊颜色值
  case color of
    0: color := 28515;
    1: color := 28421;
    2: color := 28435;
    3: color := 28563;
    4: color := 28466;
    5: color := 28450;
  end;

  //前景、背景颜色
  ForeGroundCol := color and $FF;
  BackGroundCol := (color and $FF00) shr 8;
  //******************************************//

  //*****************读取对话*****************//
  {len := 0;
  if talknum = 0 then
  begin
    offset := 0;
    len := TIdx[0];
  end
  else
  begin
    offset := TIdx[talknum - 1];
    len := TIdx[talknum] - offset;
  end;

  setlength(talk, len + 1);
  move(TDef[offset], talk[0], len);
  for i := 0 to len - 1 do
  begin
    talk[i] := talk[i] xor $FF;
    if talk[i] = 255 then
      talk[i] := 0;
  end;
  talk[len] := 0;}

  //如果talknum小于0, 则读取x50中的内容
  if content = '' then
  begin
    if (talknum >= 0) then
    begin
      ReadTalk(talknum, talk);
      //转为Unicode
      if length(Talk) > 0 then
        TalkStr := pWideChar(@Talk[0])
      else
        TalkStr := '';
    end
    else
    begin
      if (-talknum >= low(x50)) and (-talknum <= high(x50)) then
        TalkStr := pWideChar(@x50[-talknum])
      else
        TalkStr := '';
    end;
  end
  else
    TalkStr := content;
  TalkStr := ' ' + TalkStr;
  //******************************************//

  //*****************读取名字*****************//
  if disname = '' then
  begin
    case ModVersion of
      13:
        if namenum > 0 then
        begin
          ReadTalk(namenum, Name);
        end;
      0:
        if HeadNum > 0 then
          ReadTalk(BEGIN_NAME_IN_TALK + HeadNum, Name);
    end;

    HeadNumR := HeadNum;
    if (HeadNum >= ExpressionMin) and (HeadNum <= ExpressionMax) then
      HeadNumR := 0;
    if NameNum = -2 then
    begin
      for I := 0 to length(Rrole) - 1 do
      begin
        if Rrole[i].HeadNum = HeadNumR then
        begin
          len := 10;
          setlength(Name, len + 1);
          Move(Rrole[i].Name[0], Name[0], len);
          Name[len] := 0;
          break;
        end;
      end;
    end;

    if (namenum = -2) or (namenum > 0) then
      NameStr := pWideChar(@Name[0])
    else if (namenum = -1) or (namenum = 0) then
      NameStr := '';
    if (MODVersion = 0) and (namenum = 0) then
      NameStr := pWideChar(@Rrole[0].Name);
  end
  else
    NameStr := disname;
  //if Length(NameStr) > 10 then
  //begin
  //NameStr := '';
  //HeadNum := -1;
  //end;
  //******************************************//

  //*****************分析名字*****************//
  setlength(Name, 10);
  Move(Rrole[0].Name[0], Name[0], 10);
  //FullNameStr := UTF8Decode(CP950ToUTF8(PChar(@Name[0])));
  FullNameStr := pWideChar(@Name[0]);

{$IFDEF fpc}
  //FullNameUTF8Str := UTF8Encode(FullNameStr);
{$ELSE}
  //DivideName(FullNameStr, SurNameStr, GivenNameStr);
{$ENDIF}

  //******************************************//

  //***************替换对话字符串*************//
  //TalkStr := ReplaceStr(TalkStr, utf8decode('＜'), utf8decode('^4'));
  //替换字符串中的姓名
  if (Pos(FullNameCode, TalkStr) > 0) then
    TalkStr := ReplaceStr(TalkStr, FullNameCode, FullNameStr);
  SurNameStr := '';
  GivenNameStr := '';
  if (Pos(SurNameCode, TalkStr) > 0) or (Pos(GivenNameCode, TalkStr) > 0) then
  begin
    DivideName(FullNameStr, SurNameStr, GivenNameStr);
    //SurNameStr := UTF8Decode(SurNameUTF8Str);
    //GivenNameStr := UTF8Decode(GivenNameUTF8Str);
    TalkStr := ReplaceStr(TalkStr, SurNameCode, SurNameStr);
    TalkStr := ReplaceStr(TalkStr, GivenNameCode, GivenNameStr);
  end;

  //******************************************//

  //*****************显示对话*****************//

  //SetRolePic(0);
  Redraw;
  RecordFreshScreen;

  DrawForeGroundCol := ColColor(ForeGroundCol);
  DrawBackGroundCol := ColColor(BackGroundCol);
  len := length(TalkStr);
  I := 1;
  CleanKeyValue;
  while (True) do
  begin
    //显示背景
    //display_img('resource/talk.png', Frame_X, Frame_Y);
    DrawRectangleWithoutFrame(0, Frame_Y, CENTER_X * 2, 170, 0, 50);
    //显示头像
    if (showhead = 0) and (HeadNum >= 0) then
    begin
      DrawHeadPic(HeadNum, Head_X, Head_Y);
    end;
    //显示名字
    if (NameStr <> '') or (showhead <> 0) then
    begin
      for ix := 1 to length(NameStr) do
      begin
        Setlength(TempStr, 2);
        Move(NameStr[ix], TempStr[1], Sizeof(widechar));
        tempstr[2] := widechar(0);
        DrawShadowText(@TempStr[1], Name_X + (ix - 1) * NameColSpacing, Name_Y, ColColor(5), ColColor(7));
      end;
    end;
    UpdateAllScreen;
    //显示对话
    ix := 0;
    iy := 0;
    skipSync := False;
    if SkipTalk = 1 then
      break;
    while SDL_PollEvent(@event) >= 0 do
    begin
      CheckBasicEvent;
      if (event.key.keysym.sym = SDLK_ESCAPE) or (event.button.button = SDL_BUTTON_RIGHT) then
      begin
        skipSync := True;
        SkipTalk := 1;
        break;
      end;
      if (event.key.keysym.sym = SDLK_RETURN) or (event.button.button = SDL_BUTTON_LEFT) or
        (event.key.keysym.sym = SDLK_SPACE) then
        skipSync := True;
      if not ((ix < Talk_W) and (iy < Talk_H) and (I <= len)) then
        break;
      //检查是否等待按键
      setlength(TempStr, length(WaitAnyKeyCode));
      if len - I >= length(TempStr) then
      begin
        Move(TalkStr[I], TempStr[1], length(TempStr) * sizeof(widechar));
        if TempStr = WaitAnyKeyCode then
        begin
          Inc(I, length(TempStr));
          //updateallscreen;
          WaitAnyKey;
          Continue;
        end;
      end;
      //检查是否延时
      setlength(TempStr, length(DelayCode));
      if len - I >= length(TempStr) then
      begin
        Move(TalkStr[I], TempStr[1], length(TempStr) * sizeof(widechar));
        if TempStr = DelayCode then
        begin
          Inc(I, length(TempStr));
          //updateallscreen;
          SDL_Delay(500);
          Continue;
        end;
      end;
      //检查是否换行
      setlength(TempStr, length(NextLineCode));
      if len - I >= length(TempStr) then
      begin
        Move(TalkStr[I], TempStr[1], length(TempStr) * sizeof(widechar));
        if TempStr = NextLineCode then
        begin
          //当恰好处于换行位置时的处理(屏蔽, 未处理)
          //if I mod Talk_W <> 1 then
          //begin
          Inc(iy);
          ix := 0;
          //end;
          Inc(I, length(TempStr));
          if iy >= Talk_H then
          begin
            if I <= len then
            begin
              WaitAnyKey;
            end;
            //LoadFreshScreen;;
            break;
          end;
          Continue;
        end;
      end;
      //检查是否更换颜色
      Changed := False;
      setlength(TempStr, Length(ChangeColorCode) + 1);
      if len - I >= length(TempStr) then
      begin
        Move(TalkStr[I], TempStr[1], length(TempStr) * sizeof(widechar));
        for I2 := 0 to 5 do
          if TempStr = ChangeColorCode + UTF8Decode(IntToStr(I2)) then
          begin
            DrawBackGroundCol := ColColor($6F);
            case I2 of
              0: DrawForeGroundCol := ColColor($63);
              1: DrawForeGroundCol := ColColor($05);
              2: DrawForeGroundCol := ColColor($13);
              3: DrawForeGroundCol := ColColor($93);
              4: DrawForeGroundCol := ColColor($32);
              5: DrawForeGroundCol := ColColor($22);
            end;
            Inc(I, length(TempStr));
            Changed := True; //更换颜色
            break;
          end;
        if Changed = True then
          continue;
      end;
      //检查是否换回默认颜色
      setlength(TempStr, Length(ChangeColorCode) * 2);
      if len - I >= length(TempStr) then
      begin
        Move(TalkStr[I], TempStr[1], length(TempStr) * sizeof(widechar));
        if TempStr = ChangeColorCode + ChangeColorCode then
        begin
          DrawBackGroundCol := ColColor(BackGroundCol);
          DrawForeGroundCol := ColColor(ForeGroundCol);
          Inc(I, length(TempStr));
          Continue;
        end;
      end;
      //写字符
      if I <= len then
      begin
        Setlength(tempstr, 2);
        Move(TalkStr[I], TempStr[1], Sizeof(widechar));
        tempstr[2] := widechar(0);
        xtemp := Talk_X + ColSpacing * ix;
        //调整半角字符的位置
        if uint16(tempstr[1]) < $1000 then
          xtemp := xtemp + 5;
        DrawShadowText(@TempStr[1], xtemp, Talk_Y + RowSpacing * iy,
          DrawForeGroundCol, DrawBackGroundCol);
      end;
      Inc(I);
      if not skipSync then
      begin
        SDL_Delay(5); //每个字符间都延时
        UpdateAllScreen;
      end;
      Inc(ix);
      if (ix >= Talk_W) or (iy >= Talk_H) then
      begin
        ix := 0;
        Inc(iy);
        if iy >= Talk_H then
        begin
          if I <= len then
          begin
            UpdateAllScreen;
            WaitAnyKey;
            if skipSync then
              WaitAnyKey;
            skipSync := False;
          end;
          UpdateAllScreen;
          LoadFreshScreen;
          break;
        end;
      end;
    end;
    if I > len then
      break;
  end;
  FreeFreshScreen;
  UpdateAllScreen;
  if SkipTalk = 0 then
  begin
    WaitAnyKey;
    if skipSync then
      WaitAnyKey;
  end;
  //Redraw;
  //******************************************//

end;


procedure ShowTitle(talknum, color: integer);
begin
  NewTalk(0, talknum, -1, 2, 1, color, 0);
end;

function Digging(beginPic, goal, shovel, restrict: integer): integer;
var
  p1, i, n, blankpic, holepic, goldpic, moneypic, boompic, x, y, x1, y1, position: integer;
  Surface, outcome: array[0..80] of integer;
  str, str1, goalstr: WideString;
begin
  position := 0;
  x := 80;
  y := 90;
  blankpic := beginpic + 2;
  holepic := blankpic + 2;
  goldpic := holepic + 2;
  moneypic := goldpic + 2;
  boompic := moneypic + 2;
  Result := 0;
  for i := 0 to 80 do
  begin
    Surface[i] := blankpic;
    outcome[i] := holepic;
  end;
  i := 0;
  while i < 10 do
  begin
    n := random(81);
    if outcome[n] = holepic then
    begin
      outcome[n] := goldpic;
      Inc(i);
    end;
  end;
  i := 0;
  while i < 10 do
  begin
    n := random(81);
    if outcome[n] = holepic then
    begin
      outcome[n] := boompic;
      Inc(i);
    end;
  end;
  i := 0;
  while i < 10 do
  begin
    n := random(81);
    if outcome[n] = holepic then
    begin
      outcome[n] := moneypic;
      Inc(i);
    end;
  end;

  DrawRectangle(x, y, 200, 200, 0, ColColor($FF), 40);
  DrawRectangle(x, y - 30, 120, 30, 0, ColColor($FF), 40);
  DrawRectangle(x - 32, y - 30, 32, 230, 0, ColColor($FF), 40);

  for i := 0 to 81 - 1 do
  begin
    DrawSPic(blankpic div 2, (i mod 9) * 20 + 10 + x, (i div 9) * 20 + 10 + y);
    DrawSPic(outcome[i] div 2, (i mod 9) * 20 + 10 + x, (i div 9) * 20 + 10 + y);
  end;
  UpdateAllScreen;
  SDL_Delay(3000);
  Redraw;

  ShowSurface(x, y, blankpic, surface);
  DrawSPic(shovel div 2, (position mod 9) * 20 + 10 + x, (position div 9) * 20 + 5 + y);
  goalstr := IntToStr(goal);
  str := '目標:  X';
  setlength(str1, length(str));
  str1 := UnicodeToGBK(@str[1]);

  DrawShadowText(@str[1], x - 5, y - 25, ColColor($21), ColColor($23));
  DrawSPic(goldpic div 2, 55 + x, y - 25);
  DrawShadowText(@goalstr[1], x + 85, y - 25, ColColor($21), ColColor($23));
  for i := 0 to restrict - 1 do
    DrawSPic(shovel div 2, x - 27, y - 29 + (10 - i) * 20);

  UpdateAllScreen;

  while (SDL_WaitEvent(@event) >= 0) do
  begin
    CheckBasicEvent;
    case event.type_ of
      SDL_KEYUP:
      begin
        if ((event.key.keysym.sym = SDLK_RETURN) or (event.key.keysym.sym = SDLK_SPACE)) then
        begin
          if surface[position] = blankpic then
          begin
            surface[position] := outcome[position];
            restrict := restrict - 1;
            if outcome[position] = boompic then
            begin
              restrict := restrict - 1;
            end
            else if outcome[position] = goldpic then
            begin
              Inc(Result);
            end
            else if outcome[position] = moneypic then
            begin
              instruct_2(MONEY_ID, 5);
            end;
          end;
        end
        else if (event.key.keysym.sym = SDLK_RIGHT) then
        begin
          position := position + 1;
        end
        else if (event.key.keysym.sym = SDLK_LEFT) then
        begin
          position := position - 1;
        end
        else if (event.key.keysym.sym = SDLK_UP) then
        begin
          position := position - 9;
        end
        else if (event.key.keysym.sym = SDLK_DOWN) then
        begin
          position := position + 9;
        end;
        if position > 81 - 1 then
          position := position - 81;
        if position < 0 then
          position := position + 81;

      end;
      SDL_MOUSEBUTTONUP:
      begin
        if MouseInRegion(x + 10, y + 10, 180, 180, x1, y1) then
        begin
          p1 := position;
          position := (x1 - 10 - x) div 20 + ((y1 - 10 - y) div 20) * 9;
          if position = p1 then
          begin
            if surface[position] = blankpic then
            begin
              surface[position] := outcome[position];
              restrict := restrict - 1;
              if outcome[position] = boompic then
              begin
                restrict := restrict - 1;
              end
              else if outcome[position] = goldpic then
              begin
                Inc(Result);
              end
              else if outcome[position] = moneypic then
              begin
                instruct_2(MONEY_ID, 5);
              end;
            end;
          end;
        end;
      end;
    end;
    Redraw;
    ShowSurface(x, y, blankpic, surface);
    DrawSPic(shovel div 2, (position mod 9) * 20 + 10 + x, (position div 9) * 20 + 5 + y);
    DrawShadowText(@str[1], x - 5, y - 25, ColColor($21), ColColor($23));
    DrawSPic(goldpic div 2, 55 + x, y - 25);
    DrawShadowText(@goalstr[1], x + 85, y - 25, ColColor($21), ColColor($23));
    for i := 0 to restrict - 1 do
      DrawSPic(shovel div 2, x - 27, y - 29 + (10 - i) * 20);

    UpdateAllScreen;
    if restrict <= 0 then
    begin
      SDL_Delay(2000);
      WaitAnyKey;
      break;
    end;
  end;
end;

procedure ShowSurface(x, y, blank: integer; surface: array of integer);
var
  i: integer;
begin

  DrawRectangle(x, y, 200, 200, 0, ColColor($FF), 40);
  DrawRectangle(x, y - 30, 120, 30, 0, ColColor($FF), 40);
  DrawRectangle(x - 32, y - 30, 32, 230, 0, ColColor($FF), 40);

  for i := 0 to 81 - 1 do
  begin
    DrawSPic(blank div 2, (i mod 9) * 20 + 10 + x, (i div 9) * 20 + 10 + y);
    DrawSPic(surface[i] div 2, (i mod 9) * 20 + 10 + x, (i div 9) * 20 + 10 + y);
  end;
end;

function GetStarState(position: integer): integer;
var
  i, n: integer;
begin
  n := 119;
  if position > 82 then
  begin
    n := 120;
    position := position - 83;
  end;
  position := position + 30;
  if (position mod 2) = 0 then
  begin
    Result := Rrole[n].Data[position div 2] and $FF;
  end
  else
  begin
    Result := Rrole[n].Data[position div 2] shr 8;
  end;
end;

procedure TeammateList;
var
  x, y, i, n, len, t, menu, Count: integer;
  //StarList: array of widestring;
  mateList: array of integer;
  temp: WideString;
  menuString: array of WideString;
begin
  if (teamlist[0] >= 0) and (teamlist[1] >= 0) and (teamlist[2] >= 0) and (teamlist[3] >= 0) and
    (teamlist[4] >= 0) and (teamlist[5] >= 0) then
    exit;

  x := 220;
  y := 15;
  while True do
  begin
    menu := 0;
    n := 0;
    setlength(menuString, n);
    setlength(mateList, n);
    if (teamlist[0] >= 0) and (teamlist[1] >= 0) and (teamlist[2] >= 0) and (teamlist[3] >= 0) and
      (teamlist[4] >= 0) and (teamlist[5] >= 0) then
      break;
    for i := 0 to 107 do
    begin
      if GetStarState(i) = 1 then
      begin
        setlength(menuString, n + 1);
        setlength(mateList, n + 1);
        temp := concat('', Star[i]);
        temp := concat(temp, '');
        menuString[n] := concat(temp, RoleName[i]);
        mateList[n] := i;
        n := n + 1;
      end;
    end;
    Redraw;
    if length(matelist) > 0 then
    begin
      //drawrectangle(x, y, 200, n * 20 + 10, 0, colcolor($FF), 40);
      if length(mateList) > 20 then
        menu := CommonScrollMenu(x, y, 200, length(mateList) - 1, 20, menuString)
      else
        menu := CommonScrollMenu(x, y, 200, length(mateList) - 1, length(mateList), menuString);
      if menu = -1 then
        break;

      t := matelist[menu];
      //   if t >= 60 then
      //   begin
      //    if t = 109 then t := 114
      //    else t := t + 3;
      //   end;
      x50[$7100] := t;
      CallEvent(230);
      Redraw;
      UpdateAllScreen;
    end
    else
      break;
  end;
end;

function StarToRole(Starnum: integer): integer;
var
  head: array[0..107] of integer;
  {head: array[0..107] of integer = (0, 1, 2, 8, 4, 7, 6, 21, 34, 11, 3, 14, 12, 13, 23, 31,
    16, 17, 18, 5, 20, 22, 26, 27, 24, 25, 19, 30, 28, 29, 15, 32, 10, 33, 9, 35, 36, 38, 46,
    39, 40, 41, 48, 43, 49, 45, 89, 47, 37, 50, 51, 74, 52, 92, 93, 77, 44, 57, 58, 59, 69,
    64, 65, 66, 85, 55, 54, 72, 73, 88, 102, 71, 96, 76, 68, 78, 79, 42, 81, 82, 83, 84, 53,
    80, 56, 95, 70, 90, 97, 104, 105, 91, 67, 75, 369, 60, 99, 100, 101, 98, 103, 87, 86, 107, 106, 108, 114, 115);}
begin
  head[0] := 0;
  head[1] := 1;
  head[2] := 2;
  head[3] := 8;
  head[4] := 4;
  head[5] := 7;
  head[6] := 6;
  head[7] := 21;
  head[8] := 34;
  head[9] := 11;
  head[10] := 3;
  head[11] := 14;
  head[12] := 12;
  head[13] := 13;
  head[14] := 23;
  head[15] := 31;
  head[16] := 16;
  head[17] := 17;
  head[18] := 18;
  head[19] := 5;
  head[20] := 20;
  head[21] := 22;
  head[22] := 26;
  head[23] := 27;
  head[24] := 24;
  head[25] := 25;
  head[26] := 19;
  head[27] := 30;
  head[28] := 28;
  head[29] := 29;
  head[30] := 15;
  head[31] := 32;
  head[32] := 10;
  head[33] := 33;
  head[34] := 9;
  head[35] := 35;

  head[36] := 36;
  head[37] := 38;
  head[38] := 46;
  head[39] := 39;
  head[40] := 40;
  head[41] := 41;
  head[42] := 48;
  head[43] := 43;
  head[44] := 49;
  head[45] := 45;
  head[46] := 89;
  head[47] := 47;
  head[48] := 37;
  head[49] := 50;
  head[50] := 51;
  head[51] := 74;
  head[52] := 52;
  head[53] := 92;
  head[54] := 93;
  head[55] := 77;
  head[56] := 44;
  head[57] := 57;
  head[58] := 58;
  head[59] := 59;
  head[60] := 69;
  head[61] := 64;
  head[62] := 65;
  head[63] := 66;
  head[64] := 85;
  head[65] := 55;
  head[66] := 54;
  head[67] := 72;
  head[68] := 73;
  head[69] := 88;
  head[70] := 102;
  head[71] := 71;
  head[72] := 96;
  head[73] := 76;
  head[74] := 68;
  head[75] := 78;
  head[76] := 79;
  head[77] := 42;
  head[78] := 81;
  head[79] := 82;
  head[80] := 83;
  head[81] := 84;
  head[82] := 53;
  head[83] := 80;
  head[84] := 56;
  head[85] := 95;
  head[86] := 70;
  head[87] := 90;
  head[88] := 97;
  head[89] := 104;
  head[90] := 105;
  head[91] := 91;
  head[92] := 67;
  head[93] := 75;
  head[94] := 369;
  head[95] := 60;
  head[96] := 99;
  head[97] := 100;
  head[98] := 101;
  head[99] := 98;
  head[100] := 103;
  head[101] := 87;
  head[102] := 86;
  head[103] := 107;
  head[104] := 106;
  head[105] := 108;
  head[106] := 114;
  head[107] := 115;
  Result := head[Starnum];
end;

procedure NewTeammateList;
var
  xStar, yStar, xTeam, yTeam, xState, yState, Show, h: integer;
  CurrentStar, CurrentTeam, page, numStar, state, headn, menup, menu, x1, y1, pstar, pteam: integer;
  StarMenu, TeamMenu: array of WideString;
  StateList: array of integer;
  i, n, menuid: integer;
  temp, str1, str2, statusstr, str: WideString;
  escape, refresh: Bool;
  strs: array[0..21] of WideString;
  color1, color2: uint32;
begin
  xStar := 120;
  yStar := 75;
  CurrentStar := 0;
  CurrentTeam := 1;
  xTeam := 400;
  yTeam := 75;
  xState := 350;
  yState := 300;
  Show := 12;
  h := 28;
  setlength(StarMenu, Show);
  setlength(TeamMenu, 6);
  setlength(StateList, Show);
  menuid := 0;
  escape := False;
  refresh := True;
  str1 := '此人尚未收錄';
  str2 := '此人為功能人物，無法加入';
  Redraw;
  TransBlackScreen;
  RecordFreshScreen;
  while (not escape) do
  begin
    page := CurrentStar div Show;
    numStar := CurrentStar - page * Show;
    for i := page * Show to page * Show + Show - 1 do
    begin
      n := i - (i div Show) * Show;
      if (i = CurrentStar) and (menuid = 0) then
        temp := '>'
      else
        temp := ' ';
      temp := temp + Star[i] + ' ';
      StateList[n] := GetStarState(i);
      if StateList[n] > 0 then
      begin
        temp := temp + RoleName[i];
        if StateList[n] <> 2 then
          temp := temp + StringOfChar(' ', 16 - DrawLength(temp)) + IntToStr(Rrole[StarToRole(i)].Level);
      end
      else
        temp := temp + '-- -- --';
      StarMenu[n] := temp;
    end;

    for i := 0 to 5 do
    begin
      if (menuid = 1) and (CurrentTeam = i) then
        temp := ' >'
      else
        temp := '  ';
      if TeamList[i] <> -1 then
      begin
        temp := temp + pWideChar(@Rrole[TeamList[i]].Name[0]);
        temp := temp + StringOfChar(' ', 12 - DrawLength(temp)) + IntToStr(Rrole[TeamList[i]].Level);
      end
      else
        temp := temp + '  --------';
      TeamMenu[i] := temp;
    end;

    if refresh then
    begin
      refresh := False;
      LoadFreshScreen;
      //DrawRectangle(xStar, yStar, 200, show * h + 8, 0, ColColor(255), 50);
      for i := 0 to Show - 1 do
      begin
        DrawTextFrame(xStar - 16, yStar + h * i, 9, 10);
        if (i = numStar) and (menuid = 0) then
        begin
          DrawTextFrame(xStar - 16, yStar + h * i, 9);
          DrawShadowText(@StarMenu[i][1], xStar + 3, yStar + 3 + h * i, ColColor($64), ColColor($66));
        end
        else if StateList[i] = 2 then
        begin
          DrawShadowText(@StarMenu[i][1], xStar + 3, yStar + 3 + h * i, ColColor($78), ColColor($7a));
        end
        else if StateList[i] > 2 then
        begin
          DrawShadowText(@StarMenu[i][1], xStar + 3, yStar + 3 + h * i, $E02020, $a04040);
        end
        else
          DrawShadowText(@StarMenu[i][1], xStar + 3, yStar + 3 + h * i, 0, $202020);
      end;

      //DrawRectangle(xTeam, yTeam, 200, 28, 0, ColColor(255), 50);
      DrawTextFrame(xTeam - 16, yTeam, 8);
      DrawShadowText(@TeamMenu[0][1], xTeam + 3, yTeam + 3, 0, $202020);

      DrawRectangle(xTeam, yTeam + 38, 200, 4 * 22 + 28, 0, ColColor(255), 50);
      for i := 1 to 5 do
        if (i = CurrentTeam) and (menuid = 1) then
        begin
          DrawTextFrame(xTeam - 16, yTeam + 37 + h * (i - 1), 8);
          DrawShadowText(@TeamMenu[i][1], xTeam + 3, yTeam + 40 + h * (i - 1), ColColor($64), ColColor($66));
        end
        else
        begin
          DrawTextFrame(xTeam - 16, yTeam + 37 + h * (i - 1), 8, 10);
          DrawShadowText(@TeamMenu[i][1], xTeam + 3, yTeam + 40 + h * (i - 1), 0, $202020);
        end;

      //显示当前人物的状态
      if (menuid = 0) then
      begin
        state := GetStarState(CurrentStar);
        headn := StarToRole(CurrentStar);
      end
      else
      begin
        state := 3;
        headn := Teamlist[CurrentTeam];
      end;

      if ((state > 0) and (state <> 2) and (headn >= 0)) then
      begin
        //DrawRectangle(xState, yState + 83, 200, 95, 0, ColColor(255), 50);
        ShowSimpleStatus(headn, xState, yState - 3);
        {strs[0] := '攻擊';
        strs[1] := '防禦';
        strs[2] := '輕功';
        strs[3] := '移動';

        for i := 0 to 3 do
          DrawShadowText(@strs[i, 1], xState + 25, yState + 80 + 5 + 22 * i, ColColor($21), ColColor($23));

        statusstr := format('%4d', [Rrole[headn].Attack]);
        DrawEngShadowText(@statusstr[1], xState + 105, yState + 80 + 5, ColColor(5), ColColor(7));
        statusstr := format('%4d', [Rrole[headn].Defence]);
        DrawEngShadowText(@statusstr[1], xState + 105, yState + 80 + 27, ColColor(5), ColColor(7));
        statusstr := format('%4d', [Rrole[headn].Speed]);
        DrawEngShadowText(@statusstr[1], xState + 105, yState + 80 + 49, ColColor(5), ColColor(7));
        statusstr := format('%4d', [Rrole[headn].Movestep div 10]);
        DrawEngShadowText(@statusstr[1], xState + 105, yState + 80 + 71, ColColor(5), ColColor(7));}
      end;
      UpdateAllScreen;
    end;

    if (SDL_WaitEvent(@event) >= 0) then
    begin
      CheckBasicEvent;
      pstar := Currentstar;
      pteam := CurrentTeam;
      case event.type_ of
        SDL_KEYDOWN:
        begin
          if (event.key.keysym.sym = SDLK_PAGEDOWN) then
          begin
            if menuid = 0 then
            begin
              if CurrentStar < 108 - Show then
                CurrentStar := CurrentStar + Show;
            end;
          end;
          if (event.key.keysym.sym = SDLK_PAGEUP) then
          begin
            if menuid = 0 then
            begin
              if CurrentStar > Show - 1 then
                CurrentStar := CurrentStar - Show;
            end;
          end;
          if (event.key.keysym.sym = SDLK_DOWN) then
          begin
            if menuid = 0 then
            begin
              if CurrentStar < 107 then
              begin
                CurrentStar := CurrentStar + 1;
              end;
            end
            else
            begin
              if CurrentTeam < 5 then
                CurrentTeam := CurrentTeam + 1;
            end;
          end;
          if (event.key.keysym.sym = SDLK_UP) then
          begin
            if menuid = 0 then
            begin
              if CurrentStar > 0 then
              begin
                CurrentStar := CurrentStar - 1;
              end;
            end
            else
            begin
              if CurrentTeam > 1 then
                CurrentTeam := CurrentTeam - 1;
            end;
          end;
          if (event.key.keysym.sym = SDLK_LEFT) then
          begin
            menuid := 0;
          end;
          if (event.key.keysym.sym = SDLK_RIGHT) then
          begin
            menuid := 1;
          end;
        end;
        SDL_KEYUP:
        begin
          if ((event.key.keysym.sym = SDLK_ESCAPE)) then
          begin
            escape := True;
            Redraw;
          end;
          if (event.key.keysym.sym = SDLK_RETURN) or (event.key.keysym.sym = SDLK_SPACE) then
          begin
            if menuid = 0 then
            begin
              if (StateList[numstar] = 1) then
              begin
                if (teamlist[5] < 0) then
                begin
                  x50[$7100] := CurrentStar;
                  CallEvent(230);
                  refresh := True;
                end;
              end;
            end;
            if menuid = 1 then
            begin
              for i := 0 to 99 do
                if leavelist[i] = TeamList[CurrentTeam] then
                begin
                  CallEvent(BEGIN_LEAVE_EVENT + i * 2);
                  refresh := True;
                  break;
                end;
            end;
          end;
        end;
        SDL_MOUSEBUTTONUP:
        begin
          if (event.button.button = SDL_BUTTON_RIGHT) and (where <= 2) then
          begin
            escape := True;
            Redraw;
          end;
          if (event.button.button = SDL_BUTTON_LEFT) then
          begin
            if menuid = 0 then
            begin
              if (StateList[numstar] = 1) then
              begin
                if (teamlist[5] < 0) then
                begin
                  x50[$7100] := CurrentStar;
                  CallEvent(230);
                  refresh := True;
                end;
              end;
            end;
            if menuid = 1 then
            begin
              for i := 0 to 99 do
                if leavelist[i] = TeamList[CurrentTeam] then
                begin
                  CallEvent(BEGIN_LEAVE_EVENT + i * 2);
                  refresh := True;
                  break;
                end;
            end;
          end;
        end;
        SDL_MOUSEWHEEL:
        begin
          if (event.wheel.y < 0) then
          begin
            if menuid = 0 then
            begin
              if CurrentStar < 107 then
                CurrentStar := CurrentStar + 1;
            end;
            if menuid = 1 then
            begin
              if CurrentTeam < 5 then
                CurrentTeam := CurrentTeam + 1;
            end;
          end;
          if (event.wheel.y > 0) then
          begin
            if menuid = 0 then
            begin
              if CurrentStar > 0 then
                CurrentStar := CurrentStar - 1;
            end;
            if menuid = 1 then
            begin
              if CurrentTeam > 1 then
                CurrentTeam := CurrentTeam - 1;
            end;
          end;
        end;
        SDL_MOUSEMOTION:
        begin
          if MouseInRegion(xStar, yStar, 200, Show * h + 32, x1, y1) then
          begin
            menuid := 0;
            menup := CurrentStar;
            menu := (y1 - yStar - 2) div h;
            if menu > Show - 1 then
              menu := Show - 1;
            if menu < 0 then
              menu := 0;
            CurrentStar := menu + CurrentStar div Show * Show;
          end;
          if MouseInRegion(xTeam, yTeam, 200, 5 * h + 32, x1, y1) then
          begin
            menuid := 1;
            menup := CurrentTeam;
            menu := (y1 - yTeam - 40) div h + 1;
            if menu > 5 then
              menu := 5;
            if menu < 0 then
              menu := 0;
            CurrentTeam := menu;
          end;
        end;
      end;
      refresh := refresh or (pstar <> CurrentStar) or (pteam <> CurrentTeam);
      CleanKeyValue;
    end;
  end;
  FreeFreshScreen;
  event.key.keysym.sym := 0;
  event.button.button := 0;
  //SDL_EnableKeyRepeat(30, 30);
end;

procedure SetStarState(position, value: integer);
var
  i, n: integer;
begin
  n := 119;
  if position > 82 then
  begin
    n := 120;
    position := position - 83;
  end;
  position := position + 30;
  if (position mod 2) = 0 then
  begin
    Rrole[n].Data[position div 2] := (Rrole[n].Data[position div 2] and $FF00) or value;
  end
  else
  begin
    Rrole[n].Data[position div 2] := (Rrole[n].Data[position div 2] and $FF) or (value shl 8);
  end;

end;

procedure ShowTeamMate(position, headnum, Count: integer);
var
  hx, hy, hw, hh, i, l: integer;
  str1, str2, str: WideString;
begin
  if Count = 0 then
    Count := 1;

  hx := 263 - Count * 29;
  hy := 55;
  hw := 57;
  hh := 72;
  DrawRectangleWithoutFrame(0, 40, CENTER_X * 2, 230, 0, 40);

  hx := 263 - Count * 29;
  for i := 1 to Count do
  begin
    //DrawRectangle(screen, hx + 57 * i, hy, hw, hh, 0, colcolor($FF), 0);
    DrawHeadPic(headnum, hx + 57 * i, hy + 8);
  end;

  str1 := concat(Star[position], ' ');
  str2 := concat(RoleName[position], UTF8Decode(' 成為夥伴'));
  str := concat(str1, str2);
  l := length(str);
  DrawShadowText(@str[1], CENTER_X - 20 * (l div 2) - 10, 230, ColColor($5), ColColor($8));
  UpdateAllScreen;
  WaitAnyKey;
  Redraw;
end;

//未使用指令

function ReSetName(t, inum, newnamenum: integer): integer;
var
  NewName: string;
  offset, len, i, idx, grp: integer;
  p, np: pchar;
  talkarray: array of byte;
begin
  ReadTalk(newnamenum, talkarray);
  case t of
    0: p := @Rrole[inum].Name; //人物
    1: p := @Ritem[inum].Name; //物品
    2: p := @Rscence[inum].Name; //场景
    3: p := @Rmagic[inum].Name; //武功
    4: p := @Ritem[inum].Introduction; //物品说明
  end;
  for i := 0 to length(pWideChar(talkarray)) * 2 - 1 do
  begin
    (p + i)^ := (np + i)^;
  end;
  (p + i)^ := char(0);
  Result := 0;

end;

procedure JumpScence(snum, y, x: integer);
begin
  CurScence := snum;
  if x = -2 then
  begin
    x := Rscence[CurScence].EntranceX;
  end;
  if y = -2 then
  begin
    y := Rscence[CurScence].EntranceY;
  end;
  Cx := x + Cx - Sx;
  Cy := y + Cy - Sy;
  Sx := x;
  Sy := y;
  //instruct_14;
  TimeInWater := 30 + Rrole[0].CurrentMP div 100;
  InitialScence;
  DrawScence;
  instruct_13;
  ShowScenceName(CurScence);
  CheckEvent3;
end;

procedure ShowStarList;
var
  hx, hy, hw, hh, headnum, Count, n, i, c1, r1, offset, idx, len, grp, h: integer;
  str: ansistring;
  pword: array[0..1] of uint16;
  talkarray: array of byte;
  state: array[0..107] of integer;
  str1, str2: WideString;
  head: array[0..107] of integer;
  menuString: array [0..107] of WideString;

  x, y, w, max, maxshow: integer;
  menu, menup, menutop, status1: integer;
  headn, talkn, x1, y1: integer;

  procedure ShowCommonScrollMenu_starlist(x, y, w, max, maxshow, menu, menutop, headn: integer);
  var
    i, p: integer;
    hx, hy, hw, hh, Count, len, idx, grp, r1, c1, offset, state: integer;
    str1, str2: WideString;
    talkarray: array of byte;
    pword: array[0..1] of uint16;
    str: pchar;
    statusstr: WideString;
    strs: array[0..21] of WideString;
    color1, color2: uint32;
    pw: puint16;
  begin
    if max + 1 < maxshow then
      maxshow := max + 1;
    Redraw;
    TransBlackScreen;
    //DrawRectangle(x, y, w, maxshow * 22 + 6, 0, ColColor(255), 50);

    for i := menutop to menutop + maxshow - 1 do
      if i = menu then
      begin
        DrawTextFrame(x - 16, y + h * (i - menutop), 8);
        DrawShadowText(@menuString[i][1], x + 3, y + 3 + h * (i - menutop), ColColor($64), ColColor($66));
      end
      else
      begin
        DrawTextFrame(x - 16, y + h * (i - menutop), 8, 10);
        DrawShadowText(@menuString[i][1], x + 3, y + 3 + h * (i - menutop), 0, $202020);
      end;

    if (GetStarState(menu) > 0) then
    begin
      //绘制人物星位、姓名、头像
      Count := 1;
      //if (menu = 95) or (menu = 107) then
      //  Count := 4;
      //if menu = 105 then
      //  Count := 6;
      hx := CENTER_X - 384 + 383 - Count * 29;
      hy := CENTER_Y - 240 + 55;
      hw := 57;
      hh := 72;
      i := 0;
      //DrawRectangle(CENTER_X - 384 + 304, y, 379, maxshow * 22 + 6, 0, ColColor(255), 75);
      str1 := concat(Star[menu], ' ');
      str2 := concat(str1, RoleName[menu]);
      len := length(str2);
      DrawShadowText(@str2[1], CENTER_X - 384 + 484 - 20 * (len div 2), CENTER_Y - 240 + 220,
        ColColor($21), ColColor($23));
      for i := 0 to Count - 1 do
      begin
        //DrawRectangle(screen, hx + 57 * (i + 1), hy, hw, hh, 0, ColColor($FF), 0);
        DrawHeadPic(headn + i, hx + 57 * (i + 1), hy - 10);
      end;

      //简介
      ReadTalk(menu + 600, talkarray);
      str1 := ' ' + pWideChar(@talkarray[0]);
      pw := @str1[1];
      for i := 0 to length(str1) - 1 do
      begin
        if (pw^ = $2A) then
          pw^ := 0;
        Inc(pw);
      end;

      pword[1] := 0;
      pw := @str1[1];
      i := 0;
      r1 := 0;
      c1 := 0;
      len := length(pWideChar(pw));
      while i < len do
      begin
        pword[0] := puint16(pw)^;
        Inc(pw);
        i := i + 1;
        DrawU16ShadowText(@pword[0], CENTER_X - 320 + 250 + 20 * c1, CENTER_Y - 240 +
          270 + 23 * r1, ColColor(5), ColColor(7));
        Inc(c1);
        if c1 = 18 then
        begin
          c1 := 0;
          Inc(r1);
        end;
      end;

      //特技、功能说明
    {str := @talkarray[0];
    i := 0;
    r1 := 0;
    c1 := 0;
    while i < len do
    begin
      pword[0] := puint16(str + i)^;
      i := i + 2;
      DrawU16ShadowText(@pword[0], Center_x-320+230 + CHINESE_FONT_SIZE * c1, 345 + CHINESE_FONT_SIZE *
        r1, ColColor(5), ColColor(7));
      Inc(c1);
      if c1 = 18 then
      begin
        c1 := 0;
        Inc(r1);
      end;
    end;}

    end;
    UpdateAllScreen;
  end;

begin
  for i := 0 to 107 do
  begin
    state[i] := GetStarState(i);
    menuString[i] := star[i];
    if state[i] <> 0 then
    begin
      menuString[i] := menuString[i] + '  ' + rolename[i];
    end;
  end;

  head[0] := Rrole[0].HeadNum;
  head[1] := 1;
  head[2] := 2;
  head[3] := 8;
  head[4] := 4;
  head[5] := 7;
  head[6] := 6;
  head[7] := 21;
  head[8] := 34;
  head[9] := 11;
  head[10] := 3;
  head[11] := 14;
  head[12] := 12;
  head[13] := 13;
  head[14] := 23;
  head[15] := 31;
  head[16] := 16;
  head[17] := 17;
  head[18] := 18;
  head[19] := 5;
  head[20] := 20;
  head[21] := 22;
  head[22] := 26;
  head[23] := 27;
  head[24] := 24;
  head[25] := 25;
  head[26] := 19;
  head[27] := 30;
  head[28] := 28;
  head[29] := 29;
  head[30] := 15;
  head[31] := 32;
  head[32] := 10;
  head[33] := 33;
  head[34] := 9;
  head[35] := 35;
  head[36] := 36;
  head[37] := 38;
  head[38] := 46;
  head[39] := 39;
  head[40] := 40;
  head[41] := 41;
  head[42] := 48;
  head[43] := 43;
  head[44] := 49;
  head[45] := 45;
  head[46] := 89;
  head[47] := 47;
  head[48] := 37;
  head[49] := 50;
  head[50] := 51;
  head[51] := 74;
  head[52] := 52;
  head[53] := 92;
  head[54] := 93;
  head[55] := 77;
  head[56] := 44;
  head[57] := 57;
  head[58] := 58;
  head[59] := 59;
  head[60] := 69;
  head[61] := 64;
  head[62] := 65;
  head[63] := 66;
  head[64] := 85;
  head[65] := 55;
  head[66] := 54;
  head[67] := 72;
  head[68] := 73;
  head[69] := 88;
  head[70] := 102;
  head[71] := 71;
  head[72] := 96;
  head[73] := 76;
  head[74] := 68;
  head[75] := 78;
  head[76] := 79;
  head[77] := 42;
  head[78] := 81;
  head[79] := 82;
  head[80] := 83;
  head[81] := 84;
  head[82] := 53;
  head[83] := 80;
  head[84] := 56;
  head[85] := 95;
  head[86] := 70;
  head[87] := 90;
  head[88] := 97;
  head[89] := 104;
  head[90] := 105;
  head[91] := 91;
  head[92] := 67;
  head[93] := 75;
  head[94] := 369;
  head[95] := 430;
  head[96] := 99;
  head[97] := 100;
  head[98] := 101;
  head[99] := 98;
  head[100] := 103;
  head[101] := 87;
  head[102] := 86;
  head[103] := 107;
  head[104] := 106;
  head[105] := 431;
  head[106] := 114;
  head[107] := 432;

  x := CENTER_X - 384 + 84;
  y := CENTER_Y - 240 + 15;
  w := 200;
  max := 107;
  h := 28;
  maxshow := 15;
  //SDL_EnableKeyRepeat(20, 100);
  menu := 0;
  menutop := 0;
  ////SDL_EnableKeyRepeat(0,10);
  //DrawMMap;
  ShowCommonScrollMenu_starlist(x, y, w, max, maxshow, menu, menutop, head[menu]);

  //SDL_UpdateRect2(screen, x, y, w + 1, maxshow * 22 + 29);
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
          ShowCommonScrollMenu_starlist(x, y, w, max, maxshow, menu, menutop, head[menu]);
          // SDL_UpdateRect2(screen, x, y, w + 1, maxshow * 22 + 29);
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
            if menutop < 0 then
              menutop := 0;

          end;
          ShowCommonScrollMenu_starlist(x, y, w, max, maxshow, menu, menutop, head[menu]);
          // SDL_UpdateRect2(screen, x, y, w + 1, maxshow * 22 + 29);
        end;
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
          ShowCommonScrollMenu_starlist(x, y, w, max, maxshow, menu, menutop, head[menu]);
          //  SDL_UpdateRect2(screen, x, y, w + 1, maxshow * 22 + 29);
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
          ShowCommonScrollMenu_starlist(x, y, w, max, maxshow, menu, menutop, head[menu]);
          //  SDL_UpdateRect2(screen, x, y, w + 1, maxshow * 22 + 29);
        end;
      end;
      SDL_KEYUP:
      begin
        if ((event.key.keysym.sym = SDLK_ESCAPE)) and (where <= 2) then
        begin
          Redraw;
          UpdateAllScreen;
          break;
        end;
        //if (event.key.keysym.sym = sdlk_return) or (event.key.keysym.sym = sdlk_space) then
        //begin
        //  result := menu;
        //  Redraw;
        //  updateallscreen;
        //  break;
        //end;
      end;
      SDL_MOUSEBUTTONUP:
      begin
        if (event.button.button = SDL_BUTTON_RIGHT) and (where <= 2) then
        begin
          Redraw;
          UpdateAllScreen;
          break;
        end;
        {if (event.button.button = SDL_BUTTON_LEFT) then
        begin
          if menu > -1 then
          begin
            Result := menu;
            Redraw;
            SDL_UpdateRect2(screen, x, y, w + 1, maxshow * 22 + 29);
            //break;
          end;
        end;}
      end;
      SDL_MOUSEWHEEL:
      begin
        if (event.wheel.y < 0) then
        begin
          menu := menu + 1;
          menutop := menutop + 1;
          if menu > max then
            menu := 107;
          if menutop > 108 - maxshow then
            menutop := 108 - maxshow;
          ShowCommonScrollMenu_starlist(x, y, w, max, maxshow, menu, menutop, head[menu]);
          //SDL_UpdateRect2(screen, x, y, w + 1, maxshow * 22 + 29);
        end;
        if (event.wheel.y > 0) then
        begin
          menu := menu - 1;
          menutop := menutop - 1;
          if menu < 0 then
            menu := 0;
          if menutop < 0 then
            menutop := 0;
          ShowCommonScrollMenu_starlist(x, y, w, max, maxshow, menu, menutop, head[menu]);
          //SDL_UpdateRect2(screen, x, y, w + 1, maxshow * 22 + 29);
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
            ShowCommonScrollMenu_starlist(x, y, w, max, maxshow, menu, menutop, head[menu]);
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
  //SDL_EnableKeyRepeat(30, 30);

end;

//下棋小游戏

function Lamp(c, beginpic, whitecount, chance: integer): boolean;
var
  x, y, r, temp, i, pic2, pic3, menu, x1, y1: integer;
begin
  r := c;
  x := (CENTER_X * 2 - (c * 50)) div 2;
  y := (CENTER_Y * 2 - (r * 50)) div 2;
  pic2 := beginpic + 1;
  pic3 := beginpic + 2;
  menu := 0;
  setlength(gamearray, 1);
  setlength(gamearray[0], c * r);
  for i := 0 to c * r - 1 do
    gamearray[0][i] := beginpic;
  for i := 0 to whitecount - 1 do
  begin
    temp := random(c * r);
    while temp = beginpic do
      temp := random(c * r);
    gamearray[0][temp] := pic2;
  end;
  DrawRectangleWithoutFrame(x - 10, y - 10, c * 50 + 20, r * 50 + 20, 0, 60);
  for i := 0 to c * r - 1 do
  begin
    DrawSPic(gamearray[0][i], x + (i mod c) * 50, y + (i div c) * 50);
    if menu = i then
      DrawSPic(pic3, x + (menu mod c) * 50, y + (menu div c) * 50);
  end;
  UpdateAllScreen;
  while (SDL_WaitEvent(@event) >= 0) do
  begin
    CheckBasicEvent;
    case event.type_ of
      SDL_MOUSEMOTION:
      begin
        if MouseInRegion(x, y, 50 * c, 50 * r, x1, y1) then
          menu := (x1 - x) div 50 + (y1 - y) div 50 * c;
      end;
      SDL_MOUSEBUTTONUP:
      begin
        if event.button.button = SDL_BUTTON_RIGHT then
        begin
          Result := False;
          break;
        end;
        if event.button.button = SDL_BUTTON_LEFT then
        begin
          if MouseInRegion(x, y, 50 * c, 50 * r, x1, y1) then
            menu := (x1 - x) div 50 + (y1 - y) div 50 * c;
          if gamearray[0][menu] = beginpic then
            temp := pic2
          else
            temp := beginpic;
          gamearray[0][menu] := temp;
          if (menu mod c) > 0 then
          begin
            if gamearray[0][menu - 1] = beginpic then
              temp := pic2
            else
              temp := beginpic;
            gamearray[0][menu - 1] := temp;
          end;
          if (menu mod c) < c - 1 then
          begin
            if gamearray[0][menu + 1] = beginpic then
              temp := pic2
            else
              temp := beginpic;
            gamearray[0][menu + 1] := temp;
          end;
          if (menu div c) > 0 then
          begin
            if gamearray[0][menu - c] = beginpic then
              temp := pic2
            else
              temp := beginpic;
            gamearray[0][menu - c] := temp;
          end;
          if (menu div c) < r - 1 then
          begin
            if gamearray[0][menu + c] = beginpic then
              temp := pic2
            else
              temp := beginpic;
            gamearray[0][menu + c] := temp;
          end;
        end;
      end;
      SDL_KEYUP:
      begin
        if event.key.keysym.sym = SDLK_ESCAPE then
        begin
          Result := False;
          break;
        end;
        if event.key.keysym.sym = SDLK_UP then
          menu := menu - c;
        if event.key.keysym.sym = SDLK_DOWN then
          menu := menu + c;
        if event.key.keysym.sym = SDLK_LEFT then
          menu := menu - 1;
        if event.key.keysym.sym = SDLK_RIGHT then
          menu := menu + 1;
        if menu < 0 then
          menu := menu + c * r;
        if menu > c * r - 1 then
          menu := menu - c * r;
        if (event.key.keysym.sym = SDLK_RETURN) or (event.key.keysym.sym = SDLK_SPACE) then
        begin
          if gamearray[0][menu] = beginpic then
            temp := pic2
          else
            temp := beginpic;
          gamearray[0][menu] := temp;
          if (menu mod c) > 0 then
          begin
            if gamearray[0][menu - 1] = beginpic then
              temp := pic2
            else
              temp := beginpic;
            gamearray[0][menu - 1] := temp;
          end;
          if (menu mod c) < c - 1 then
          begin
            if gamearray[0][menu + 1] = beginpic then
              temp := pic2
            else
              temp := beginpic;
            gamearray[0][menu + 1] := temp;
          end;
          if (menu div c) > 0 then
          begin
            if gamearray[0][menu - c] = beginpic then
              temp := pic2
            else
              temp := beginpic;
            gamearray[0][menu - c] := temp;
          end;
          if (menu div c) < r - 1 then
          begin
            if gamearray[0][menu + c] = beginpic then
              temp := pic2
            else
              temp := beginpic;
            gamearray[0][menu + c] := temp;
          end;
        end;
      end;
    end;
    for i := 0 to c * r - 1 do
    begin
      DrawSPic(gamearray[0][i], x + (i mod c) * 50, y + (i div c) * 50);
      if menu = i then
        DrawSPic(pic3, x + (menu mod c) * 50, y + (menu div c) * 50);
    end;
    UpdateAllScreen;
    Result := True;
    for i := 0 to c * r - 1 do
    begin
      if gamearray[0][i] = pic2 then
        Result := False;
    end;
    if Result = True then
    begin
      SDL_Delay(1000);
      break;
    end;
  end;
  setlength(gamearray, 0);
end;


//selecttype: 十位-武功升级模式 个位-等级升级模式
//要增加的等级, 最低目标等级, 最高目标等级
//SetAttribute(rnum, 1, Rrole[rnum].Repute, Rrole[rnum].RoundLeave, 60);
procedure SetAttribute(rnum, selecttype, modlevel, minlevel, maxlevel: integer);
var
  lv, i, sum, j, leveltype, magictype, mnum, magiclevel, magichurt, times: integer;
  attackadd, speedadd, defenceadd, HPadd, MPadd: integer;
begin

  if minlevel = 0 then
    minlevel := 1;
  if maxlevel = 0 then
    maxlevel := 60;

  leveltype := selecttype mod 10;
  magictype := trunc(selecttype / 10);

  //升级模式
  //0-主角等级 1-队伍最高级 2-队伍最低级 3-除去最低级的平均等级(可能是写错了)
  case leveltype of
    0: lv := Rrole[0].Level;
    1:
    begin
      lv := Rrole[0].Level;
      for i := 1 to 5 do
      begin
        if teamlist[i] > 0 then
          if Rrole[teamlist[i]].Level > lv then
            lv := Rrole[teamlist[i]].Level;
      end;
    end;
    2:
    begin
      lv := Rrole[0].Level;
      for i := 1 to 5 do
      begin
        if teamlist[i] > 0 then
          if Rrole[teamlist[i]].Level < lv then
            lv := Rrole[teamlist[i]].Level;
      end;
    end;
    3:
    begin
      sum := Rrole[0].Level;
      lv := Rrole[0].Level;
      j := 1;
      for i := 1 to 5 do
      begin
        if teamlist[i] > 0 then
        begin
          j := j + 1;
          sum := sum + Rrole[teamlist[i]].Level;
          if Rrole[teamlist[i]].Level < lv then
            lv := Rrole[teamlist[i]].Level;
        end
        else
          break;
      end;
      if j > 1 then
      begin
        sum := sum - lv;
        lv := sum div (j - 1);
      end;
    end;
  end;
  lv := lv + modlevel;
  if lv > maxlevel then
    lv := maxlevel;
  if lv < minlevel then
    lv := minlevel;

  //这里设定敌人升到多少级就增加多少级的属性
  //logN(4, lv)的取值从0到3, 这个算法比较奇怪, 若一次升很多级可能导致属性过高

  //此处修改为首先依据武功进行兵器值的增加, 之后利用原本的升级子程增加属性
  Rrole[rnum].MaxHP := 50;
  Rrole[rnum].MaxMP := 40;
  Rrole[rnum].Defence := 30;
  Rrole[rnum].Speed := 30;
  Rrole[rnum].Attack := 30;

  Rrole[rnum].Fist := 10;
  Rrole[rnum].Sword := 10;
  Rrole[rnum].Knife := 10;
  Rrole[rnum].Unusual := 10;
  Rrole[rnum].HidWeapon := 10;

  //根据武功的个数对五维进行加成
  //0-不考虑 1-拳 2-剑 3-刀 4-特 5-暗
  //此处的设计相当奇怪
  //CalAddPro(magictype, attackadd, speedadd, defenceadd, HPadd, MPadd);
  for i := 0 to 9 do
  begin
    if Rrole[rnum].Magic[i] <= 0 then
      break
    else
      mnum := Rrole[rnum].Magic[i];
    magiclevel := trunc(Rrole[rnum].MagLevel[i] div 100) + 1;
    magichurt := Rmagic[mnum].Attack[0] + (Rmagic[mnum].Attack[1] - Rmagic[mnum].Attack[0]) * magiclevel div 10;
    if Rmagic[mnum].HurtType = 2 then
      magichurt := 1000;
    magichurt := magichurt div 10;
    case Rmagic[mnum].MagicType of
      1: Rrole[rnum].Fist := Rrole[rnum].Fist + magichurt;
      2: Rrole[rnum].Sword := Rrole[rnum].Sword + magichurt;
      3: Rrole[rnum].Knife := Rrole[rnum].Knife + magichurt;
      4: Rrole[rnum].Unusual := Rrole[rnum].Unusual + magichurt;
      5: Rrole[rnum].HidWeapon := Rrole[rnum].HidWeapon + magichurt;
    end;
    CalAddPro(magictype, attackadd, speedadd, defenceadd, HPadd, MPadd);
    magiclevel := trunc(Rrole[rnum].MagLevel[i] div 100) + 1;
    Rrole[rnum].MaxHP := Rrole[rnum].MaxHP + HPadd * magiclevel;
    Rrole[rnum].MaxMP := Rrole[rnum].MaxMP + MPadd * magiclevel;
    Rrole[rnum].Attack := Rrole[rnum].Attack + attackadd * magiclevel;
    Rrole[rnum].Defence := Rrole[rnum].Defence + defenceadd * magiclevel;
    Rrole[rnum].Speed := Rrole[rnum].Speed + trunc((speedadd + 0.5) * magiclevel);
  end;

  //内功
  for i := 0 to 3 do
  begin
    if Rrole[rnum].NeiGong[i] <= 0 then
      break
    else
      mnum := Rrole[rnum].NeiGong[i];
    magiclevel := trunc(Rrole[rnum].MagLevel[i] div 100) + 1;
    //每种内功加50生命, 50内力, 2攻击, 2防御, 2轻功, 1抗毒
    Rrole[rnum].MaxHP := Rrole[rnum].MaxHP + 50 * magiclevel;
    Rrole[rnum].MaxMP := Rrole[rnum].MaxMP + 50 * magiclevel;
    Rrole[rnum].Attack := Rrole[rnum].Attack + 2 * magiclevel;
    Rrole[rnum].Defence := Rrole[rnum].Defence + 2 * magiclevel;
    Rrole[rnum].Speed := Rrole[rnum].Speed + 2 * magiclevel;
    Rrole[rnum].DefPoi := Rrole[rnum].DefPoi + 2 * magiclevel;
  end;

  //自然升级算法

  {for i := 2 to lv do
  begin
    LevelUp(-1, rnum);
  end;
  Rrole[rnum].Level := lv;}

  //假设该人的第一个武功为其主修方向, 认为其练了50次, 1000为基准
  {mnum := Rrole[rnum].Magic[0];
  magiclevel := trunc(Rrole[rnum].MagLevel[0] div 100) + 1;
  magichurt := Rmagic[mnum].Attack[0] + (Rmagic[mnum].Attack[1] - Rmagic[mnum].Attack[0]) * magiclevel div 10;
  if Rmagic[mnum].HurtType = 2 then magichurt := 1000;
  times := magichurt * 50 div 1000;
  CalAddPro(Rmagic[mnum].magictype, attackadd, speedadd, defenceadd, HPadd, MPadd);

  Rrole[rnum].MaxHP := Rrole[rnum].MaxHP + HPadd * times;
  Rrole[rnum].MaxMP := Rrole[rnum].MaxMP + MPadd * times;
  Rrole[rnum].Attack := Rrole[rnum].Attack + attackadd * times;
  Rrole[rnum].Speed := Rrole[rnum].Speed + speedadd * times;
  Rrole[rnum].Defence := Rrole[rnum].Defence + defenceadd * times;}

  //rrole[rnum].MaxHP := 50 + (rrole[rnum].IncLife + 1) * 3 * (lv - 1);
  //rrole[rnum].MaxMP := 40 + (rrole[rnum].AddMP + 1) * 3 * (lv - 1);
  //rrole[rnum].Attack := 30 + (rrole[rnum].AddAtk + 1) * (lv - 1);
  //rrole[rnum].Speed := 30 + (rrole[rnum].AddSpeed+1) * (lv - 1);
  //rrole[rnum].Defence := 30 + (rrole[rnum].AddDef + 1) * (lv - 1);

  Rrole[rnum].Level := lv;
  Rrole[rnum].MaxHP := min(MAX_HP, 50 + trunc((Rrole[rnum].IncLife + 1) * lv * logN(4, lv)) + random(lv) - random(lv));
  Rrole[rnum].CurrentHP := Rrole[rnum].MaxHP;
  Rrole[rnum].MaxMP := min(MAX_MP, 40 + trunc((Rrole[rnum].AddMP + 1) * lv * logN(4, lv)) + random(lv) - random(lv));
  Rrole[rnum].CurrentMP := Rrole[rnum].MaxMP;
  Rrole[rnum].Attack := 30 + trunc((Rrole[rnum].AddAtk + 1) * (lv - 1) * logN(10, lv)) +
    random(lv div 2) - random(lv div 2);
  Rrole[rnum].Defence := 30 + trunc((Rrole[rnum].AddDef + 1) * (lv - 1) * logN(10, lv)) +
    random(lv div 2) - random(lv div 2);
  Rrole[rnum].Speed := 30 + trunc((Rrole[rnum].AddSpeed) * lv * logN(20, lv)) + random(lv div 2) - random(lv div 2);

  if Rrole[rnum].Fist > 10 then
    Rrole[rnum].Fist := Rrole[rnum].Fist + trunc(2 * lv * logN(20, lv)) + random(lv div 3) - random(lv div 3);
  if Rrole[rnum].Sword > 10 then
    Rrole[rnum].Sword := Rrole[rnum].Sword + trunc(2 * lv * logN(20, lv)) + random(lv div 3) - random(lv div 3);
  if Rrole[rnum].Knife > 10 then
    Rrole[rnum].Knife := Rrole[rnum].Knife + trunc(2 * lv * logN(20, lv)) + random(lv div 3) - random(lv div 3);
  if Rrole[rnum].Unusual > 10 then
    Rrole[rnum].Unusual := Rrole[rnum].Unusual + trunc(2 * lv * logN(20, lv)) + random(lv div 3) - random(lv div 3);
  if Rrole[rnum].HidWeapon > 10 then
    Rrole[rnum].HidWeapon := Rrole[rnum].HidWeapon + trunc(2 * lv * logN(20, lv)) +
      random(lv div 3) - random(lv div 3);

  if Rrole[rnum].Medcine > 10 then
    Rrole[rnum].Medcine := Rrole[rnum].Medcine + trunc(2 * lv * logN(20, lv)) + random(lv div 3) - random(lv div 3);
  if Rrole[rnum].UsePoi > 10 then
    Rrole[rnum].UsePoi := Rrole[rnum].UsePoi + trunc(2 * lv * logN(20, lv)) + random(lv div 3) - random(lv div 3);
  if Rrole[rnum].MedPoi > 10 then
    Rrole[rnum].MedPoi := Rrole[rnum].MedPoi + trunc(2 * lv * logN(20, lv)) + random(lv div 3) - random(lv div 3);

  for i := 46 to 54 do
  begin
    if Rrole[rnum].Data[i] > MaxProList[i] then
      Rrole[rnum].Data[i] := MaxProList[i];
  end;

  //第一项武功级别随等级调整, 用于敌人, 十位数字7
  if magictype = 7 then
  begin
    magiclevel := lv * 20;
    if magiclevel > 999 then
      magiclevel := 999;
    Rrole[rnum].MagLevel[0] := magiclevel;
  end;

end;

procedure CalAddPro(magictype: integer; var attackadd, speedadd, defenceadd, HPadd, MPadd: integer);
begin
  case magictype of
    1:
    begin
      attackadd := 4;
      speedadd := 0;
      defenceadd := 4;
      HPadd := 30;
      MPadd := 40;
    end;
    2:
    begin
      attackadd := 5;
      speedadd := 1;
      defenceadd := 3;
      HPadd := 20;
      MPadd := 30;
    end;
    3:
    begin
      attackadd := 3;
      speedadd := 0;
      defenceadd := 5;
      HPadd := 40;
      MPadd := 20;
    end;
    4:
    begin
      attackadd := 4;
      speedadd := 2;
      defenceadd := 4;
      HPadd := 30;
      MPadd := 20;
    end;
    5:
    begin
      attackadd := 2;
      speedadd := 3;
      defenceadd := 2;
      HPadd := 30;
      MPadd := 30;
    end;
    else
    begin
      attackadd := 0;
      speedadd := 0;
      defenceadd := 0;
      HPadd := 0;
      MPadd := 0;
    end;
  end;
end;

function GetItemAmount(inum: integer): integer;
var
  i: integer;
begin
  Result := 0;
  for i := 0 to MAX_ITEM_AMOUNT - 1 do
    if RItemList[i].Number = inum then
    begin
      Result := RItemList[i].Amount;
      break;
    end;
end;

function GetMissionState(position: integer): integer;
var
  i, n, p: integer;
begin
  n := 650 + position div 162;
  p := position div 2 + 18;
  if (position mod 2) = 0 then
  begin
    Result := Rrole[n].Data[p] and $FF;
  end
  else
  begin
    Result := (Rrole[n].Data[p] shr 8) and $FF;
  end;
  //writeln(position, result);
end;

procedure MissionList(mode: integer);
var
  x, y, i, n, len, t, menu, Count, tip: integer;
  //StarList: array of widestring;
  MissionList: array of integer;
  temp: WideString;
  str: WideString;
  missionTip: array[0..2] of WideString;
  menuString: array of WideString;
begin
  x := 70;
  y := 15;
  n := 0;
  menu := 0;
  setlength(menuString, MISSION_AMOUNT);
  setlength(MissionList, MISSION_AMOUNT);
  missiontip[0] := UTF8Decode('未開啟');
  missiontip[1] := UTF8Decode('未完成');
  missiontip[2] := UTF8Decode('已完成');
  for i := 0 to MISSION_AMOUNT - 1 do
  begin
    tip := GetMissionState(i);
    if (tip >= 1) and (tip <= 2) then
    begin
      if (mode = 0) or (tip = mode) then
      begin
        menuString[n] := ' ' + missiontip[tip] + '  ' + MissionStr[i];
        MissionList[n] := i;
        n := n + 1;
      end;
    end;
  end;
  Redraw;
  UpdateAllScreen;
  if length(MissionList) > 0 then
  begin
    menu := CommonScrollMenu(x, y, 500, n - 1, 15, menuString);
    Redraw;
    UpdateAllScreen;
  end;
end;

procedure SetMissionState(position, value: integer);
var
  i, n, p: integer;
begin
  n := 650 + position div 162;

  p := position div 2 + 18;
  if (position mod 2) = 0 then
  begin
    Rrole[n].Data[p] := (Rrole[n].Data[p] and $FF00) or value;
  end
  else
  begin
    Rrole[n].Data[p] := (Rrole[n].Data[p] and $FF) or (value shl 8);
  end;

end;

procedure RoleEnding(starnum, headnum, talknum: integer);
var
  status, newcolor, alen, n, ch, r1, c1, color1, color2, grp, idx, i, offset, len, hx, hy,
  Sx, Sy, nx, ny, tx, ty, cell, framex, l, w, h, framey: integer;
  str1, str2, str, talkstr, namestr: WideString;
  np3, np1, np2, tp, p1, ap: pchar;
  actorarray, name1, name2, talkarray: array of byte;
  pword: array[0..1] of uint16;
  r, g, b: byte;
  color: uint32;
  gray: boolean;
begin
  status := GetStarState(starnum);
  cell := 23;
  framex := CENTER_X - 384;
  framey := CENTER_Y - 240 + 160 * (starnum mod 3);
  h := 160;
  w := 768;
  pword[1] := 0;
  if starnum mod 3 = 0 then
    Redraw;
  r := random(128);
  g := random(128);
  b := random(128);
  color := MapRGBA(r, g, b);
  DrawRectangleWithoutFrame(framex, framey, w, h - 1, color, 50);

  //color := 28421;
  color1 := $5;
  color2 := $7;
  ty := framey + 10;
  hy := framey;
  Sy := ty;
  ny := ty + 22;
  if starnum and 1 = 0 then
  begin
    tx := framex + 250;
    hx := framex + 10;
    nx := hx + 160 + 40;
    Sx := hx + 160 + 40;
  end
  else
  begin
    tx := framex + 10;
    hx := framex + 588;
    nx := hx - 55;
    Sx := hx - 55;
  end;
  str1 := Star[starnum];
  if status = 0 then
  begin
    str2 := '？？？';
  end
  else
  begin
    if status = 5 then
      gray := True;
    DrawHeadPic(headnum, hx, hy);
    gray := False;
    str2 := RoleName[starnum];
  end;
  //DrawRectangle(screen, hx, hy - 68, 56, 72, 0, ColColor(255), 0);
  l := length(str1);
  DrawShadowText(@str1[1], Sx - (20 * l) div 2, Sy, ColColor($64), ColColor($66));
  l := length(str2);
  DrawShadowText(@str2[1], nx - (20 * l) div 2, ny, ColColor($64), ColColor($66));

  if status > 0 then
  begin
    ReadTalk(talknum, talkarray);
    namestr := pWideChar(@Rrole[0].Name[0]);
    talkstr := ' ' + pWideChar(@talkarray[0]);
    talkstr := ReplaceStr(talkstr, '&&', namestr);
    tp := @talkstr[1];
    ch := 0;
    c1 := 0;
    r1 := 0;
    while (puint16(tp + ch))^ <> 0 {((puint16(tp + ch))^ shl 8 <> 0) and ((puint16(tp + ch))^ shr 8 <> 0)} do
    begin
      pword[0] := (puint16(tp + ch))^;
      if pword[0] <> 0 {(pword[0] shr 8 <> 0) and (pword[0] shl 8 <> 0)} then
      begin
        ch := ch + 2;
        {if pword[0] = $2A2A then //**换行
        begin
          if c1 > 0 then
          begin
            Inc(r1);
          end;
          c1 := 0;
        end
        else if pword[0] = $2626 then //显示姓名
        begin
          i := 0;
          while (puint16(ap + i)^ shr 8 <> 0) and (puint16(ap + i)^ shl 8 <> 0) do
          begin
            pword[0] := puint16(ap + i)^;
            i := i + 2;
            DrawU16ShadowText(@pword[0], tx + CHINESE_FONT_SIZE * c1, ty + CHINESE_FONT_SIZE *
              r1, ColColor(color1), ColColor(color2));
            Inc(c1);
            if c1 = cell then
            begin
              c1 := 0;
              Inc(r1);
            end;
          end;
        end
        else //显示文字}
        begin
          DrawU16ShadowText(@pword, tx + 20 * c1, ty + 20 * r1, ColColor(color1), ColColor(color2));
          Inc(c1);
          if c1 = cell then
          begin
            c1 := 0;
            Inc(r1);
          end;
        end;
      end
      else
        break;
    end;
  end;
  UpdateAllScreen;

end;

function WoodMan(Chamber: integer): boolean;
var
  x, y, x1, y1, i, i3, i2, sta, offset, eface1, eface2, position, roleface, xm, ym: integer;
  CanWalk, stay: boolean;
  picnum: integer = 4714;
begin
  Result := True;
  x := 80;
  y := 90;
  eface1 := 0;
  eface2 := 0;
  roleface := 0;
  i := sizeof(woodmansta);
  sta := FileOpen('list/woodman.bin', fmopenread);
  offset := Chamber * i;
  FileSeek(sta, offset, 0);
  FileRead(sta, Woodmansta, i);
  FileClose(sta);
  if SPNGIndex[picnum].Loaded = 0 then
    LoadOnePNGTexture('resource/smap', pSPic, SPNGIndex[picnum]);
  WoodPic := SPNGIndex[picnum].CurPointerT^;
  if WoodPic = nil then
    WoodPic := SPNGIndex[picnum].CurPointer^;
  for i := 0 to 99 do
  begin
    x1 := i div 10;
    y1 := i mod 10;
    if (x1 + y1) mod 2 = 0 then
      DrawPartPic(WoodPic, 0, 450, 48, 30, x1 * 48 + x, y1 * 30 + y)
    else
      DrawPartPic(WoodPic, 48, 450, 48, 30, x1 * 48 + x, y1 * 30 + y);
  end;
  for y1 := 0 to 18 do
  begin
    for x1 := 0 to 18 do
    begin
      i := x1 * 19 + y1;
      if woodmansta.GameData[i] = 1 then
      begin
        if y1 mod 2 = 0 then
          DrawPartPic(WoodPic, 48, 192, 48, 48, (x1 div 2) * 48 + 23 + x, (y1 div 2) * 30 - 18 + y);
        if x1 mod 2 = 0 then
          DrawPartPic(WoodPic, 96, 192, 48, 48, (x1 div 2) * 48 + x, (y1 div 2) * 30 - 15 + y);
      end;
      if ((position div 10) * 2 = x1) and ((position mod 10) * 2 = y1) then

        DrawPartPic(WoodPic, 0, 192 + 18, 48, 30, (position div 10) * 48 + x, (position mod 10) * 30 + y);
      if (woodmansta.Exitx = x1) and (woodmansta.Exity = y1) then
      begin
        DrawPartPic(WoodPic, 96, 450, 48, 30, (x1 div 2) * 48 + x, (y1 div 2) * 30 + y);
      end;
      if (WoodmanSta.Exy[0][0] = x1) and (woodmansta.Exy[0][1] = y1) then
      begin
        DrawPartPic(WoodPic, 0, 48 * eface1, 48, 48, (x1 div 2) * 48 + x, (y1 div 2) * 30 - 25 + y);
      end;
      if (woodmansta.Exy[1][0] = x1) and (woodmansta.Exy[1][1] = y1) then
      begin
        DrawPartPic(WoodPic, 0, 48 * eface1, 48, 48, (x1 div 2) * 48 + x, (y1 div 2) * 30 - 25 + y);
      end;
      if (woodmansta.Rx = x1) and (woodmansta.Ry = y1) then
      begin
        DrawPartPic(WoodPic, 0, 240 + 48 * roleface, 48, 48, (x1 div 2) * 48 + x, (y1 div 2) * 30 - 25 + y);
      end;
    end;
  end;
  UpdateAllScreen;
  while (SDL_WaitEvent(@event) >= 0) do
  begin
    for i := 0 to 99 do
    begin
      x1 := i div 10;
      y1 := i mod 10;
      if (x1 + y1) mod 2 = 0 then
        DrawPartPic(WoodPic, 0, 450, 48, 30, x1 * 48 + x, y1 * 30 + y)
      else
        DrawPartPic(WoodPic, 48, 450, 48, 30, x1 * 48 + x, y1 * 30 + y);
    end;
    for y1 := 0 to 18 do
    begin
      for x1 := 0 to 18 do
      begin
        i := x1 * 19 + y1;
        if woodmansta.GameData[i] = 1 then
        begin
          if y1 mod 2 = 0 then
            DrawPartPic(WoodPic, 48, 192, 48, 48, (x1 div 2) * 48 + 23 + x, (y1 div 2) * 30 - 18 + y);
          if x1 mod 2 = 0 then
            DrawPartPic(WoodPic, 96, 192, 48, 48, (x1 div 2) * 48 + x, (y1 div 2) * 30 - 15 + y);
        end;
        if ((position div 10) * 2 = x1) and ((position mod 10) * 2 = y1) then

          DrawPartPic(WoodPic, 0, 192 + 18, 48, 30, (position div 10) * 48 + x, (position mod 10) * 30 + y);
        if (woodmansta.Exitx = x1) and (woodmansta.Exity = y1) then
        begin
          DrawPartPic(WoodPic, 96, 450, 48, 30, (x1 div 2) * 48 + x, (y1 div 2) * 30 + y);
        end;
        if (WoodmanSta.Exy[0][0] = x1) and (woodmansta.Exy[0][1] = y1) then
        begin
          DrawPartPic(WoodPic, 0, 48 * eface1, 48, 48, (x1 div 2) * 48 + x, (y1 div 2) * 30 - 25 + y);
        end;
        if (woodmansta.Exy[1][0] = x1) and (woodmansta.Exy[1][1] = y1) then
        begin
          DrawPartPic(WoodPic, 0, 48 * eface1, 48, 48, (x1 div 2) * 48 + x, (y1 div 2) * 30 - 25 + y);
        end;
        if (woodmansta.Rx = x1) and (woodmansta.Ry = y1) then
        begin
          DrawPartPic(WoodPic, 0, 240 + 48 * roleface, 48, 48, (x1 div 2) * 48 + x, (y1 div 2) * 30 - 25 + y);
        end;

      end;
    end;
    UpdateAllScreen;
    CheckBasicEvent;
    case event.type_ of
      SDL_MOUSEMOTION:
      begin
        if MouseInRegion(x, y, 480, 300, xm, ym) then
          position := (xm - x) div 48 * 10 + (ym - y) div 30;
      end;
      SDL_KeyUP:
      begin
        if event.key.keysym.sym = SDLK_ESCAPE then
        begin
          Result := False;
          Redraw;
          UpdateAllScreen;
          break;
        end;
        if event.key.keysym.sym = SDLK_UP then
          y1 := woodmansta.ry - 2;
        if event.key.keysym.sym = SDLK_DOWN then
          y1 := woodmansta.ry + 2;
        if event.key.keysym.sym = SDLK_LEFT then
          x1 := woodmansta.rx - 2;
        if event.key.keysym.sym = SDLK_RIGHT then
          x1 := woodmansta.rx + 2;
        CanWalk := False;
        stay := False;

        if (event.key.keysym.sym = SDLK_RETURN) or (event.key.keysym.sym = SDLK_SPACE) then
        begin
          CanWalk := True;
          stay := True;
        end;
        if y1 - woodmansta.ry = 2 then
          if woodmansta.GameData[woodmansta.Rx * 19 + woodmansta.Ry + 1] = 0 then
          begin
            CanWalk := True;
            roleface := 0;
          end;
        if y1 - woodmansta.ry = -2 then
          if woodmansta.GameData[woodmansta.Rx * 19 + woodmansta.Ry - 1] = 0 then
          begin
            CanWalk := True;
            roleface := 1;
          end;
        if x1 - woodmansta.rx = -2 then
          if woodmansta.GameData[(woodmansta.Rx - 1) * 19 + woodmansta.Ry] = 0 then
          begin
            CanWalk := True;
            roleface := 2;
          end;
        if x1 - woodmansta.rx = 2 then
          if woodmansta.GameData[(woodmansta.Rx + 1) * 19 + woodmansta.Ry] = 0 then
          begin
            CanWalk := True;
            roleface := 3;
          end;
        if CanWalk then
        begin
          if stay = False then
          begin
            ShowManWalk(roleface, Eface1, Eface2);
          end;
          if (woodmansta.Rx = woodmansta.ExitX) and (woodmansta.Ry = woodmansta.ExitY) then
          begin
            Result := True;
            SDL_Delay(1000);
            Redraw;
            UpdateAllScreen;
            break;
          end;
          for i3 := 0 to 1 do
          begin
            if (WoodmanSta.Exy[i3][0] <> 255) and (WoodmanSta.Exy[i3][1] <> 255) then
            begin
              for I2 := 0 to 1 do
              begin
                if i3 = 0 then
                begin
                  if (WoodmanSta.Exy[i3][0] < woodmansta.rx) and
                    (woodmansta.GameData[(WoodmanSta.Exy[i3][0] + 1) * 19 + woodmansta.Exy[i3][1]] = 0) then
                  begin
                    Eface1 := 3;
                    ShowWoodManWalk(i3, Eface1, Eface2, RoleFace);
                  end
                  else if (WoodmanSta.Exy[i3][0] > woodmansta.rx) and
                    (woodmansta.GameData[(WoodmanSta.Exy[i3][0] - 1) * 19 + woodmansta.Exy[i3][1]] = 0) then
                  begin
                    Eface1 := 2;
                    ShowWoodManWalk(i3, Eface1, Eface2, RoleFace);
                  end
                  else if (WoodMansta.Exy[i3][1] > WoodmanSta.ry) and
                    (WoodmanSta.GameData[WoodmanSta.Exy[i3][0] * 19 + WoodmanSta.Exy[i3][1] - 1] = 0) then
                  begin
                    Eface1 := 1;
                    ShowWoodManWalk(i3, Eface1, Eface2, RoleFace);
                  end
                  else if (WoodmanSta.Exy[i3][1] < WoodmanSta.ry) and
                    (WoodmanSta.GameData[WoodmanSta.Exy[i3][0] * 19 + WoodmanSta.Exy[i3][1] + 1] = 0) then
                  begin
                    Eface1 := 0;
                    ShowWoodManWalk(i3, Eface1, Eface2, RoleFace);
                  end;
                end
                else
                begin
                  if (WoodMansta.Exy[i3][1] > WoodmanSta.ry) and
                    (WoodmanSta.GameData[WoodmanSta.Exy[i3][0] * 19 + WoodmanSta.Exy[i3][1] + 1] = 0) then
                  begin
                    Eface1 := 1;
                    ShowWoodManWalk(i3, Eface1, Eface2, RoleFace);
                  end
                  else if (WoodmanSta.Exy[i3][1] < WoodmanSta.ry) and
                    (WoodmanSta.GameData[WoodmanSta.Exy[i3][0] * 19 + WoodmanSta.Exy[i3][1] - 1] = 0) then
                  begin
                    Eface1 := 0;
                    ShowWoodManWalk(i3, Eface1, Eface2, RoleFace);
                  end
                  else if (WoodmanSta.Exy[i3][0] < woodmansta.rx) and
                    (woodmansta.GameData[(WoodmanSta.Exy[i3][0] - 1) * 19 + woodmansta.Exy[i3][1]] = 0) then
                  begin
                    Eface1 := 3;
                    ShowWoodManWalk(i3, Eface1, Eface2, RoleFace);
                  end
                  else if (WoodmanSta.Exy[i3][0] > woodmansta.rx) and
                    (woodmansta.GameData[(WoodmanSta.Exy[i3][0] + 1) * 19 + woodmansta.Exy[i3][1]] = 0) then
                  begin
                    Eface1 := 2;
                    ShowWoodManWalk(i3, Eface1, Eface2, RoleFace);
                  end;
                end;
              end;

            end;
            if (WoodmanSta.Exy[i3][0] = WoodmanSta.Rx) and (WoodmanSta.Exy[i3][1] = WoodmanSta.Ry) then
            begin
              Result := False;
              SDL_Delay(1000);
              Redraw;
              UpdateAllScreen;
              //sdl_destroytexture(WoodPic);
              exit;
            end;
          end;
        end;
      end;
      SDL_MOUSEBUTTONUP:
      begin
        if event.button.button = SDL_BUTTON_RIGHT then
        begin
          Result := False;
          Redraw;
          UpdateAllScreen;
          break;
        end;
        x1 := (position div 10) * 2;
        y1 := (position mod 10) * 2;
        CanWalk := False;
        stay := False;
        if y1 - woodmansta.ry = 2 then
          if woodmansta.GameData[woodmansta.Rx * 19 + woodmansta.Ry + 1] = 0 then
          begin
            CanWalk := True;
            roleface := 0;
          end;
        if y1 - woodmansta.ry = -2 then
          if woodmansta.GameData[woodmansta.Rx * 19 + woodmansta.Ry - 1] = 0 then
          begin
            CanWalk := True;
            roleface := 1;
          end;
        if x1 - woodmansta.rx = -2 then
          if woodmansta.GameData[(woodmansta.Rx - 1) * 19 + woodmansta.Ry] = 0 then
          begin
            CanWalk := True;
            roleface := 2;
          end;
        if x1 - woodmansta.rx = 2 then
          if woodmansta.GameData[(woodmansta.Rx + 1) * 19 + woodmansta.Ry] = 0 then
          begin
            CanWalk := True;
            roleface := 3;
          end;
        if (x1 = woodmansta.rx) and (y1 = woodmansta.ry) then
        begin
          CanWalk := True;
          stay := True;
        end;
        if CanWalk then
        begin
          if stay = False then
          begin
            ShowManWalk(roleface, Eface1, Eface2);
          end;
          if (woodmansta.Rx = woodmansta.ExitX) and (woodmansta.Ry = woodmansta.ExitY) then
          begin
            Result := True;
            SDL_Delay(1000);
            Redraw;
            UpdateAllScreen;
            //sdl_destroytexture(WoodPic);
            exit;
          end;
          for i3 := 0 to 1 do
          begin
            if (WoodmanSta.Exy[i3][0] <> 255) and (WoodmanSta.Exy[i3][1] <> 255) then
            begin
              for I2 := 0 to 1 do
              begin
                if i3 = 0 then
                begin
                  if (WoodmanSta.Exy[i3][0] < woodmansta.rx) and
                    (woodmansta.GameData[(WoodmanSta.Exy[i3][0] + 1) * 19 + woodmansta.Exy[i3][1]] = 0) then
                  begin
                    Eface1 := 3;
                    ShowWoodManWalk(i3, Eface1, Eface2, RoleFace);
                  end
                  else if (WoodmanSta.Exy[i3][0] > woodmansta.rx) and
                    (woodmansta.GameData[(WoodmanSta.Exy[i3][0] - 1) * 19 + woodmansta.Exy[i3][1]] = 0) then
                  begin
                    Eface1 := 2;
                    ShowWoodManWalk(i3, Eface1, Eface2, RoleFace);
                  end
                  else if (WoodMansta.Exy[i3][1] > WoodmanSta.ry) and
                    (WoodmanSta.GameData[WoodmanSta.Exy[i3][0] * 19 + WoodmanSta.Exy[i3][1] - 1] = 0) then
                  begin
                    Eface1 := 1;
                    ShowWoodManWalk(i3, Eface1, Eface2, RoleFace);
                  end
                  else if (WoodmanSta.Exy[i3][1] < WoodmanSta.ry) and
                    (WoodmanSta.GameData[WoodmanSta.Exy[i3][0] * 19 + WoodmanSta.Exy[i3][1] + 1] = 0) then
                  begin
                    Eface1 := 0;
                    ShowWoodManWalk(i3, Eface1, Eface2, RoleFace);
                  end;
                end
                else
                begin
                  if (WoodMansta.Exy[i3][1] > WoodmanSta.ry) and
                    (WoodmanSta.GameData[WoodmanSta.Exy[i3][0] * 19 + WoodmanSta.Exy[i3][1] + 1] = 0) then
                  begin
                    Eface1 := 1;
                    ShowWoodManWalk(i3, Eface1, Eface2, RoleFace);
                  end
                  else if (WoodmanSta.Exy[i3][1] < WoodmanSta.ry) and
                    (WoodmanSta.GameData[WoodmanSta.Exy[i3][0] * 19 + WoodmanSta.Exy[i3][1] - 1] = 0) then
                  begin
                    Eface1 := 0;
                    ShowWoodManWalk(i3, Eface1, Eface2, RoleFace);
                  end
                  else if (WoodmanSta.Exy[i3][0] < woodmansta.rx) and
                    (woodmansta.GameData[(WoodmanSta.Exy[i3][0] - 1) * 19 + woodmansta.Exy[i3][1]] = 0) then
                  begin
                    Eface1 := 3;
                    ShowWoodManWalk(i3, Eface1, Eface2, RoleFace);
                  end
                  else if (WoodmanSta.Exy[i3][0] > woodmansta.rx) and
                    (woodmansta.GameData[(WoodmanSta.Exy[i3][0] + 1) * 19 + woodmansta.Exy[i3][1]] = 0) then
                  begin
                    Eface1 := 2;
                    ShowWoodManWalk(i3, Eface1, Eface2, RoleFace);
                  end;
                end;
              end;

            end;
            if (WoodmanSta.Exy[i3][0] = WoodmanSta.Rx) and (WoodmanSta.Exy[i3][1] = WoodmanSta.Ry) then
            begin
              Result := False;
              SDL_Delay(1000);
              Redraw;
              UpdateAllScreen;
              //sdl_destroytexture(WoodPic);
              exit;
            end;
          end;
        end;
      end;
    end;
    UpdateAllScreen;
  end;

end;

procedure ShowManWalk(face, Eface1, Eface2: integer);
var
  x, y, x1, y1, i, i1, x2, y2: integer;
begin
  x := 80;
  y := 90;
  x2 := 0;
  y2 := 0;
  if face = 0 then
    y2 := 10;
  if face = 1 then
    y2 := -10;
  if face = 2 then
    x2 := -16;
  if face = 3 then
    x2 := 16;
  for i1 := 0 to 2 do
  begin
    for i := 0 to 99 do
    begin
      x1 := i div 10;
      y1 := i mod 10;
      if (x1 + y1) mod 2 = 0 then
        DrawPartPic(WoodPic, 0, 450, 48, 30, x1 * 48 + x, y1 * 30 + y)
      else
        DrawPartPic(WoodPic, 48, 450, 48, 30, x1 * 48 + x, y1 * 30 + y);
    end;
    for y1 := 0 to 18 do
    begin
      for x1 := 0 to 18 do
      begin
        i := x1 * 19 + y1;
        if WoodmanSta.GameData[i] = 1 then
        begin
          if y1 mod 2 = 0 then
            DrawPartPic(WoodPic, 48, 192, 48, 48, (x1 div 2) * 48 + 23 + x, (y1 div 2) * 30 - 18 + y);
          if x1 mod 2 = 0 then
            DrawPartPic(WoodPic, 96, 192, 48, 48, (x1 div 2) * 48 + x, (y1 div 2) * 30 - 15 + y);
        end;
        if (WoodmanSta.Exitx = x1) and (WoodmanSta.Exity = y1) then
        begin
          DrawPartPic(WoodPic, 96, 450, 48, 30, (x1 div 2) * 48 + x, (y1 div 2) * 30 + y);
        end;
        if (WoodmanSta.Exy[0][0] = x1) and (WoodmanSta.Exy[0][1] = y1) then
        begin
          DrawPartPic(WoodPic, 0, 48 * eface1, 48, 48, (x1 div 2) * 48 + x, (y1 div 2) * 30 - 25 + y);
        end;
        if (WoodmanSta.Exy[1][0] = x1) and (WoodmanSta.Exy[1][1] = y1) then
        begin
          DrawPartPic(WoodPic, 0, 48 * eface1, 48, 48, (x1 div 2) * 48 + x, (y1 div 2) * 30 - 25 + y);
        end;
        if (WoodmanSta.Rx = x1) and (WoodmanSta.Ry = y1) then
        begin
          if (i1 = 2) then
          begin
            x2 := WoodmanSta.Rx;
            y2 := WoodmanSta.Ry;
            if face = 0 then
              y2 := WoodmanSta.Ry + 2;
            if face = 1 then
              y2 := WoodmanSta.Ry - 2;
            if face = 2 then
              x2 := WoodmanSta.Rx - 2;
            if face = 3 then
              x2 := WoodmanSta.Rx + 2;
            DrawPartPic(WoodPic, 0, 240 + 48 * face, 48, 48, (x2 div 2) * 48 + x, (y2 div 2) * 30 - 25 + y);

          end
          else
            DrawPartPic(WoodPic, 48 * (i1 + 1), 240 + 48 * face, 48, 48, (x1 div 2) * 48 +
              x + ((i1 + 1) * x2), (y1 div 2) * 30 - 25 + y + ((i1 + 1) * y2));
        end;
      end;
    end;

    UpdateAllScreen;
    SDL_Delay(100);
  end;
  if face = 0 then
    WoodmanSta.Ry := WoodmanSta.Ry + 2;
  if face = 1 then
    WoodmanSta.Ry := WoodmanSta.Ry - 2;
  if face = 2 then
    WoodmanSta.Rx := WoodmanSta.Rx - 2;
  if face = 3 then
    WoodmanSta.Rx := WoodmanSta.Rx + 2;
end;

procedure ShowWoodManWalk(num, Eface1, Eface2, RoleFace: integer);
var
  x, y, x1, y1, i, i1, i2, x2, y2: integer;
  Ex2, Ey2, Ex1, Ey1: pbyte;
  Ef1, Ef2: pinteger;
begin
  x := 80;
  y := 90;

  Ex1 := @WoodmanSta.Exy[num][0];
  Ey1 := @WoodmanSta.Exy[num][1];
  Ex2 := @WoodmanSta.Exy[abs(num - 1)][0];
  Ey2 := @WoodmanSta.Exy[abs(num - 1)][1];
  if num = 0 then
  begin
    Ef1 := @Eface1;
    Ef2 := @Eface2;
  end
  else
  begin
    Ef2 := @Eface1;
    Ef1 := @Eface2;
  end;
  x2 := 0;
  y2 := 0;
  if Ef1^ = 0 then
    y2 := 10;
  if Ef1^ = 1 then
    y2 := -10;
  if Ef1^ = 2 then
    x2 := -16;
  if Ef1^ = 3 then
    x2 := 16;


  for i1 := 0 to 2 do
  begin
    for i := 0 to 99 do
    begin
      x1 := i div 10;
      y1 := i mod 10;
      if (x1 + y1) mod 2 = 0 then
        DrawPartPic(WoodPic, 0, 450, 48, 30, x1 * 48 + x, y1 * 30 + y)
      else
        DrawPartPic(WoodPic, 48, 450, 48, 30, x1 * 48 + x, y1 * 30 + y);
    end;
    for y1 := 0 to 18 do
    begin
      for x1 := 0 to 18 do
      begin
        i := x1 * 19 + y1;
        if WoodmanSta.GameData[i] = 1 then
        begin
          if y1 mod 2 = 0 then
            DrawPartPic(WoodPic, 48, 192, 48, 48, (x1 div 2) * 48 + 23 + x, (y1 div 2) * 30 - 18 + y);
          if x1 mod 2 = 0 then
            DrawPartPic(WoodPic, 96, 192, 48, 48, (x1 div 2) * 48 + x, (y1 div 2) * 30 - 15 + y);
        end;
        if (WoodmanSta.Exitx = x1) and (WoodmanSta.Exity = y1) then
        begin
          DrawPartPic(WoodPic, 96, 450, 48, 30, (x1 div 2) * 48 + x, (y1 div 2) * 30 + y);
        end;
        if (ex1^ = x1) and (Ey1^ = y1) then
        begin
          if (i1 = 2) then
          begin
            x2 := Ex1^;
            y2 := Ey1^;
            if Ef1^ = 0 then
              y2 := Ey1^ + 2;
            if Ef1^ = 1 then
              y2 := Ey1^ - 2;
            if Ef1^ = 2 then
              x2 := Ex1^ - 2;
            if Ef1^ = 3 then
              x2 := Ex1^ + 2;
            DrawPartPic(WoodPic, 0, 48 * Ef1^, 48, 48, (x2 div 2) * 48 + x, (y2 div 2) * 30 - 25 + y);
          end
          else
            DrawPartPic(WoodPic, 48 * (i1 + 1), 48 * Ef1^, 48, 48, (x1 div 2) * 48 + x +
              (i1 + 1) * x2, (y1 div 2) * 30 - 25 + y + (i1 + 1) * y2);
        end;
        if (Ex2^ = x1) and (Ey2^ = y1) then
        begin
          DrawPartPic(WoodPic, 0, 48 * Ef2^, 48, 48, (x1 div 2) * 48 + x, (y1 div 2) * 30 - 25 + y);
        end;
        if (WoodmanSta.Rx = x1) and (WoodmanSta.Ry = y1) then
        begin
          DrawPartPic(WoodPic, 0, 240 + 48 * Roleface, 48, 48, (x1 div 2) * 48 + x, (y1 div 2) * 30 - 25 + y);
        end;
      end;
    end;

    UpdateAllScreen;
    SDL_Delay(100);
  end;
  if Ef1^ = 0 then
    Ey1^ := Ey1^ + 2;
  if Ef1^ = 1 then
    Ey1^ := Ey1^ - 2;
  if Ef1^ = 2 then
    Ex1^ := Ex1^ - 2;
  if Ef1^ = 3 then
    Ex1^ := Ex1^ + 2;
end;

function SpellPicture(num, chance: integer): boolean;
var
  x, y, w, h, i, x1, y1, r, right, menu, menu1, menu2, picnum, xm, ym: integer;
  pic: pointer;
  filename: string;
  word1, word: WideString;
begin
  setlength(gamearray, 1);
  setlength(gamearray[0], 25);
  menu := 0;
  menu2 := -1;
  x := 120;
  y := 20;
  w := 410;
  h := 440;
  right := 0;
  picnum := 4700 + num;
  if picnum >= SPicAmount then
    exit;
  if SPNGIndex[picnum].Loaded = 0 then
    LoadOnePNGTexture('resource/smap', pSPic, SPNGIndex[picnum]);
  Pic := SPNGIndex[picnum].CurPointerT^;
  if Pic = nil then
    Pic := SPNGIndex[picnum].CurPointer^;
  //filename := 'resource/Pic' + IntToStr(num);
  //if FileExists(filename) then
  //Pic := IMG_Load(@filename[1]);
  for i := 0 to 24 do
    gamearray[0][i] := -1;
  for i := 0 to 24 do
  begin
    while True do
    begin
      r := random(25);
      if (gamearray[0][r] = -1) and (i <> r) then
      begin
        gamearray[0][r] := i;
        break;
      end;
    end;
  end;

  Redraw;
  RecordFreshScreen(x - 5, y - 5, w + 1, h + 1);
  DrawRectangle(x - 5, y - 5, w, h, 0, ColColor(255), 50);
  for i := 0 to 24 do
  begin
    DrawPartPic(pic, ((24 - i) mod 5) * 80, ((24 - i) div 5) * 80, 80, 80, (i mod 5) * 80 +
      x, (i div 5) * 80 + y + 30);
  end;
  UpdateAllScreen;
  SDL_Delay(2000);

  LoadFreshScreen(x - 5, y - 5);
  DrawRectangle(x - 5, y - 5, w, h, 0, ColColor(255), 50);
  for i := 0 to 24 do
  begin
    DrawPartPic(pic, ((24 - gamearray[0][i]) mod 5) * 80, ((24 - gamearray[0][i]) div 5) *
      80, 80, 80, (i mod 5) * 80 + x, (i div 5) * 80 + y + 30);
  end;
  if menu2 > -1 then
    DrawRectangle((menu2 mod 5) * 80 + x, (menu2 div 5) * 80 + y + 30, 80, 80, 0, ColColor($64), 0);
  if menu > -1 then
    DrawRectangle((menu mod 5) * 80 + x, (menu div 5) * 80 + y + 30, 80, 80, 0, ColColor($255), 0);
  word := UTF8Decode('機會') + IntToStr(chance);
  word1 := UTF8Decode('命中') + IntToStr(right);
  DrawShadowText(@word[1], x + 25, y + 5, ColColor(5), ColColor(7));
  DrawShadowText(@word1[1], x + 220, y + 5, ColColor(5), ColColor(7));
  UpdateAllScreen;



  while (SDL_WaitEvent(@event) >= 0) do
  begin
    CheckBasicEvent;
    case event.type_ of
      SDL_KEYUP:
      begin
        menu1 := menu;
        if event.key.keysym.sym = SDLK_ESCAPE then
        begin
          if menu2 > -1 then
          begin
            menu2 := -1;
          end
          else
          begin
            Result := False;
            break;
          end;
        end;
        if event.key.keysym.sym = SDLK_UP then
          menu := menu - 5;
        if event.key.keysym.sym = SDLK_DOWN then
          menu := menu + 5;
        if event.key.keysym.sym = SDLK_LEFT then
          menu := menu - 1;
        if event.key.keysym.sym = SDLK_RIGHT then
          menu := menu + 1;
        if menu > 24 then
          menu := menu - 25;
        if menu < 0 then
          menu := menu + 25;
        if menu1 > -1 then
          DrawPartPic(pic, ((24 - gamearray[0][menu1]) mod 5) * 80, ((24 - gamearray[0][menu1]) div 5) *
            80, 80, 80, (menu1 mod 5) * 80 + x, (menu1 div 5) * 80 + y + 30);
        if (event.key.keysym.sym = SDLK_RETURN) or (event.key.keysym.sym = SDLK_SPACE) then
        begin
          if menu2 > -1 then
          begin
            ExchangePic(menu, menu2);
            menu2 := -1;
            chance := chance - 1;
          end
          else if menu > -1 then
            menu2 := menu;
        end;
      end;

      SDL_MOUSEMOTION:
      begin
        if menu > -1 then
          menu1 := menu;
        if MouseInRegion(x, y, w - 5, h - 5, xm, ym) then
        begin
          menu := (xm - x) div 80 + (ym - y - 30) div 80 * 5;
          if menu > 24 then
            menu := -1;
          if menu <> menu1 then
          begin
            if menu1 > -1 then
              DrawPartPic(pic, ((24 - gamearray[0][menu1]) mod 5) * 80, ((24 - gamearray[0][menu1]) div 5) *
                80, 80, 80, (menu1 mod 5) * 80 + x, (menu1 div 5) * 80 + y + 30);
          end;
        end;
      end;
      SDL_MOUSEBUTTONUP:
      begin
        if event.button.button = SDL_BUTTON_RIGHT then
        begin
          if menu2 > -1 then
          begin
            menu2 := -1;
          end
          else
          begin
            Result := False;
            break;
          end;
        end;
        if event.button.button = SDL_BUTTON_LEFT then
        begin
          if menu2 > -1 then
          begin
            ExchangePic(menu, menu2);
            menu2 := -1;
            chance := chance - 1;
          end
          else if menu > -1 then
            menu2 := menu;
        end;
      end;
    end;


    right := 0;
    for i := 0 to 24 do
    begin
      if gamearray[0][i] = i then
        right := right + 1;
    end;
    LoadFreshScreen(x - 5, y - 5);
    DrawRectangle(x - 5, y - 5, w, h, 0, ColColor(255), 50);
    for i := 0 to 24 do
    begin
      DrawPartPic(pic, ((24 - gamearray[0][i]) mod 5) * 80, ((24 - gamearray[0][i]) div 5) *
        80, 80, 80, (i mod 5) * 80 + x, (i div 5) * 80 + y + 30);
    end;
    if menu2 > -1 then
      DrawRectangle((menu2 mod 5) * 80 + x, (menu2 div 5) * 80 + y + 30, 80, 80, 0, ColColor($64), 0);
    if menu > -1 then
      DrawRectangle((menu mod 5) * 80 + x, (menu div 5) * 80 + y + 30, 80, 80, 0, ColColor($255), 0);
    word := UTF8Decode('機會') + IntToStr(chance);
    word1 := UTF8Decode('命中') + IntToStr(right);
    DrawShadowText(@word[1], x + 25, y + 5, ColColor(5), ColColor(7));
    DrawShadowText(@word1[1], x + 220, y + 5, ColColor(5), ColColor(7));
    UpdateAllScreen;


    if right = 25 then
      Result := True
    else
      Result := False;
    if Result then
    begin
      SDL_Delay(700);
      break;
    end
    else if chance = 0 then
    begin
      SDL_Delay(700);
      break;
    end;
  end;
  setlength(gamearray, 0);
  FreeFreshScreen;
end;

procedure ExchangePic(p1, p2: integer);
var
  t: smallint;
begin
  t := gamearray[0][p1];
  gamearray[0][p1] := gamearray[0][p2];
  gamearray[0][p2] := t;
end;


procedure BookList;
var
  x, y, w, h, i, j: integer;
  itemlist: array of smallint;
  menuString: array of WideString;
begin
  j := 0;
  x := 220;
  y := 10;
  w := 200;
  Redraw;
  UpdateAllScreen;
  setlength(menuString, MAX_ITEM_AMOUNT);
  setlength(itemlist, MAX_ITEM_AMOUNT);
  for i := 0 to MAX_ITEM_AMOUNT - 1 do
  begin
    if (Ritemlist[i].Number >= 0) and (Ritemlist[i].Amount > 0) then
    begin
      if Ritem[Ritemlist[i].Number].Magic >= 0 then
      begin
        j := j + 1;
        menuString[j - 1] := ' ' + pWideChar(@Ritem[Ritemlist[i].Number].Name[0]);
        itemlist[j - 1] := Ritemlist[i].Number;
      end;
    end;
  end;
  i := CommonScrollMenu(x, y, w, j - 1, 15, menuString);
  if i > -1 then
    i := itemlist[i];
  x50[28931] := i;

end;

function GetStarAmount: smallint;
var
  i, a: integer;
begin
  Result := 0;
  for i := 0 to 107 do
  begin
    if GetStarState(i) > 0 then
      Inc(Result);
  end;
end;

//劲舞团模式, 用于机关, 返回值为0=失败, 1=胜利；没有分数的计算, 可以内嵌入50指令
//此版本为非pic版本, 使用的贴图为：1000-1003, 1100-1103

function DancerAfter90S: integer;
var
  now, ori_time, demand_time: uint32; //demand_time must be a ms-level
  str: WideString;
  i, DanceNum, DanceLong, tmp: integer; //计数器,当前的贴图
  DanceList: array[0..9] of smallint;
  iskey: boolean;
begin
  Redraw;
  DanceNum := 0;
  DanceLong := 8;
  ori_time := SDL_GetTicks;
  demand_time := 10000; //10s
  iskey := True;
  DrawRectangle((320 - 43 * (DanceLong div 2)) - 5, 120 - 62, (DanceLong + 1) * 43 + 5, 45,
    ColColor(0), ColColor($255), 25);
  DrawRectangle(0, 420, 640, 14, ColColor(47), ColColor($255), 0);
  UpdateAllScreen;
  for i := 0 to DanceLong do
  begin
    tmp := random(4);
    DrawSPic(4678 + DanceList[i], 320 - 43 * (DanceLong div 2) + i * 43, 120 - 62); //end;70
    DanceList[i] := tmp;
  end;
  while SDL_PollEvent(@event) >= 0 do
  begin
    now := SDL_GetTicks;
    //70%,turn red
    if (now - ori_time) < (demand_time * 0.7) then
      DrawRectangle(0, 420, 640 * (now - ori_time) div demand_time, 14, ColColor(47), ColColor($255), 100)
    else if ((now - ori_time) >= (demand_time * 0.7)) and ((now - ori_time) <= (demand_time * 1)) then
      DrawRectangle(0, 420, 640 * (now - ori_time) div demand_time, 14, ColColor(70), ColColor($255), 100)
    else
    begin
      WaitAnyKey;
      //lose
      Result := 0;
      break;
    end;
    UpdateAllScreen;
    case event.type_ of
      SDL_KEYDOWN:
      begin
        //绘图的四个方向必须是上下右左（莫名其妙的排列）
        if (DanceNum <> DanceLong + 1) then
        begin
          if ((event.key.keysym.sym - 273) = DanceList[DanceNum]) and (iskey = True) then
          begin
            DrawSPic(4682 + DanceList[DanceNum], 320 - 43 * (DanceLong div 2) + DanceNum * 43, 120);
            //end;70
            DanceNum := DanceNum + 1;
            iskey := False;
          end
          else if (iskey = True) then
          begin
            for i := 0 to DanceNum do
              DrawSPic(4678 + DanceList[i], 320 - 43 * (DanceLong div 2) + i * 43, 120 - 62); //end;70
            DanceNum := 0;
            iskey := False;
          end;
        end
        else
        if (event.key.keysym.sym = SDLK_SPACE) and (iskey = True) then
          //done
        begin
          Result := 1;
          break;
        end;
      end;
      SDL_KEYUP:
      begin
        iskey := True;
        //Esc  quit
        if (event.key.keysym.sym = SDLK_ESCAPE) then
        begin
          Result := 0;
          break;
        end;
      end;
    end;
    event.key.keysym.sym := 0;
  end;
end;

procedure ReadTalk(talknum: integer; var talk: Tbytearray; needxor: integer = 0);
var
  len, offset, i: integer;
begin
  if (talknum >= 0) and (talknum <= high(TIdx)) then
  begin
    len := 0;
    if talknum = 0 then
    begin
      offset := 0;
      len := TIdx[0];
    end
    else
    begin
      offset := TIdx[talknum - 1];
      len := TIdx[talknum] - offset;
    end;

    setlength(talk, len + 1);
    move(TDef[offset], talk[0], len);
    if needxor = 1 then
      for i := 0 to len - 1 do
      begin
        talk[i] := talk[i] xor $FF;
        if talk[i] = 255 then
          talk[i] := 0;
      end;
    talk[len] := 0;
  end
  else
  begin
    setlength(talk, 1);
    talk[0] := 0;
  end;
end;

//改自winson7891的完美商店
//商店, 改成只有一頁

procedure NewShop(shop_num: integer);
type
  TShopList = record
    HoldAmount, BuyAmount: array [0..4] of smallint;
  end;

var
  i, menu, totalprice, money, k_num, select, lr: integer;
  x, y, w, x2, y2, w2, arrowlx, arrowrx, arrowy, l, pmenu, pselect, plr, pvalue, xm, ym: integer;
  totalbuy: array[0..4] of smallint;
  sell: TShop;
  buy, pbuy: TShopList;
  Shop_Str, word: WideString;
  menuString: array [0..4] of WideString;
  refresh, sure: boolean;

  procedure NewShop_Show(menu, select, money, lr: integer; sell: TShop; buy: TShopList);
  var
    i, totalprice, mixalphal, mixalphar: integer;
    mixcolorl, mixcolorr: uint32;
    word: array[0..2] of WideString;
    menuEngString: array[0..4] of WideString;
    word1, word2: WideString;
  begin
    LoadFreshScreen(x, y);
    //畫商店菜單, 計算總價格
    totalprice := 0;
    for i := 0 to 4 do
      totalprice := totalprice + sell.Price[i] * buy.BuyAmount[i];
    DrawRectangle(x, y, 420, 116, 0, ColColor(255), 50);
    for i := 0 to 4 do
    begin
      menuEngString[i] := format('%5d%7d%6d%9d', [sell.Price[i], sell.Amount[i], buy.HoldAmount[i],
        buy.BuyAmount[i]]);
      mixcolorl := 0;
      mixcolorr := 0;
      mixalphal := 0;
      mixalphar := 0;
      if i = menu then
      begin
        DrawShadowText(@menuString[i][1], x + 3, y + 2 + 22 * i, ColColor($64), ColColor($66));
        DrawEngShadowText(@menuEngString[i][1], x + 120, y + 2 + 22 * i, ColColor($64), ColColor($66));
        if lr < 0 then
        begin
          mixcolorl := $FFFFFFFF;
          mixalphal := 25;
        end;
        if lr > 0 then
        begin
          mixcolorr := $FFFFFFFF;
          mixalphar := 25;
        end;
      end
      else
      begin
        DrawShadowText(@menuString[i][1], x + 3, y + 2 + 22 * i, ColColor($5), ColColor($7));
        DrawEngShadowText(@menuEngString[i][1], x + 120, y + 2 + 22 * i, ColColor($5), ColColor($7));
      end;
      if buy.BuyAmount[i] <= 0 then
      begin
        mixcolorl := 0;
        mixalphal := 50;
      end;
      if (buy.BuyAmount[i] >= sell.Amount[i]) or (totalprice + sell.Price[i] > money) then
      begin
        mixcolorr := 0;
        mixalphar := 50;
      end;
      DrawMPic(2004, arrowlx, i * l + arrowy, -1, 0, 0, mixcolorl, mixalphal);
      DrawMPic(2005, arrowrx, i * l + arrowy, -1, 0, 0, mixcolorr, mixalphar);
    end;

    //畫現有銀兩以及花費估算
    word1 := '現有銀兩：' + UTF8Decode(format('%5d', [money]));
    DrawTextWithRect(@word1[1], x, y2, 160, ColColor(49), ColColor(47), 50, 0);
    //str(totalprice, temp);
    word2 := '花費估算：' + UTF8Decode(format('%5d', [totalprice]));
    DrawTextWithRect(@word2[1], x, y2 + 40, 160, ColColor(49), ColColor(47), 50, 0);
    //畫確定選單
    word[0] := '購買';
    word[1] := '反悔';
    word[2] := '離開';
    DrawRectangle(x2, y2, w2, 26, 0, ColColor(255), 50);
    for i := 0 to 2 do
      if (i = select) and (menu = 5) then
      begin
        DrawShadowText(@word[i][1], x2 + 9 + i * 60, y2 + 2, ColColor($66), ColColor($64));
      end
      else
      begin
        DrawShadowText(@word[i][1], x2 + 9 + i * 60, y2 + 2, ColColor($7), ColColor($5));
      end;
    //SDL_UpdateRect2(screen, x, y, 421, 117);
    UpdateAllScreen;
  end;

begin
  sell := RShop[shop_num];
  menu := 0;
  totalprice := 0;
  money := GetItemAmount(MONEY_ID);
  for i := 0 to 4 do
  begin
    buy.BuyAmount[i] := 0;
    totalbuy[i] := 0;
    buy.HoldAmount[i] := GetItemAmount(sell.Item[i]);
    menuString[i] := pWideChar(@Ritem[sell.Item[i]].Name);
  end;

  x := CENTER_X - 190;
  y := 200;
  w := 420;
  x2 := x + 240;
  y2 := y + 140;
  w2 := 180;
  arrowlx := x + 330;
  arrowrx := x + 400;
  arrowy := y + 5;
  l := 22;
  DrawRectangleWithoutFrame(0, 20, CENTER_X shl 1, 120, 0, 40);
  Shop_Str := '需要買什麽？';
  DrawShadowText(@Shop_Str[1], CENTER_X - 70, 55, ColColor($FF), ColColor($0));

  word := '品名         價格    存貨  持有     交易';
  DrawTextWithRect(@word[1], CENTER_X - 190, 155, 420, ColColor(49), ColColor(47));
  RecordFreshScreen(x, y, 421, CENTER_Y * 2 - y);

  refresh := True;
  lr := 0;
  select := 0;
  sure := False;
  while SDL_PollEvent(@event) >= 0 do
  begin
    if refresh then
    begin
      NewShop_Show(menu, select, money, lr, sell, buy);
      refresh := False;
      pmenu := menu;
      pselect := select;
      plr := lr;
    end;
    CheckBasicEvent;
    SDL_Delay(20);
    pbuy := buy;
    case event.type_ of
      SDL_KeyDown:
      begin
        if (menu >= 0) and (menu < 5) then
        begin
          pvalue := buy.BuyAmount[menu];
          case event.key.keysym.sym of
            SDLK_LEFT:
            begin
              buy.BuyAmount[menu] := max(0, buy.BuyAmount[menu] - 1);
              lr := -1;
            end;
            SDLK_RIGHT:
            begin
              buy.BuyAmount[menu] := min(sell.Amount[menu], buy.BuyAmount[menu] + 1);
              lr := 1;
            end;
          end;
          refresh := pvalue <> buy.BuyAmount[menu];
        end;
      end;
      SDL_KeyUp:
      begin
        lr := 0;
        case event.key.keysym.sym of
          SDLK_UP:
          begin
            menu := menu - 1;
            if menu < 0 then
              menu := 5;
          end;
          SDLK_DOWN:
          begin
            menu := menu + 1;
            if menu > 5 then
              menu := 0;
          end;
          SDLK_LEFT:
          begin
            if menu = 5 then
            begin
              select := (select - 1) mod 3;
            end;
          end;
          SDLK_RIGHT:
          begin
            if menu = 5 then
            begin
              select := (select + 1) mod 3;
            end;
          end;
          SDLK_ESCAPE:
          begin
            break;
          end;
          SDLK_RETURN, SDLK_SPACE:
          begin
            if menu = 5 then
            begin
              sure := True;
            end;
          end;
        end;
      end;
      SDL_MOUSEBUTTONDOWN:
      begin
        if (menu >= 0) and (menu < 5) then
        begin
          pvalue := buy.BuyAmount[menu];
          case event.button.button of
            SDL_BUTTON_LEFT:
            begin
              if MouseInRegion(arrowlx, y + 5, 20, 25 * 5) then
              begin
                buy.BuyAmount[menu] := max(0, buy.BuyAmount[menu] - 1);
                lr := -1;
              end
              else if MouseInRegion(arrowrx, y + 5, 20, 25 * 5) then
              begin
                buy.BuyAmount[menu] := min(sell.Amount[menu], buy.BuyAmount[menu] + 1);
                lr := 1;
              end
              else
                lr := 0;
            end;
          end;
          refresh := pvalue <> buy.BuyAmount[menu];
        end;
      end;
      SDL_MOUSEBUTTONUP:
      begin
        case event.button.button of
          SDL_BUTTON_LEFT:
          begin
            if (menu = 5) and (select >= 0) and (select <= 2) then
              sure := True;
          end;
          SDL_BUTTON_RIGHT:
          begin
            break;
          end;
        end;
        lr := 0;
      end;
      SDL_MOUSEMOTION:
      begin
        menu := -1;
        if MouseInRegion(x, y, w, l * 5 + 10, xm, ym) then
        begin
          menu := RegionParameter((ym - y - 5) div l, 0, 4);
        end;
        if MouseInRegion(x2, y2, w2, l + 10, xm, ym) then
        begin
          menu := 5;
          select := RegionParameter(trunc(3 * (xm - x2) div w2), 0, 2);
        end;
      end;
    end;
    //CleanKeyValue;
    event.key.keysym.sym := 0;
    totalprice := 0;
    for i := 0 to 4 do
    begin
      totalprice := totalprice + sell.Price[i] * buy.BuyAmount[i];
    end;
    if totalprice > money then
      buy := pbuy;
    if sure then
    begin
      sure := False;
      refresh := True;
      case select of
        0:
        begin
          for i := 0 to 4 do
          begin
            sell.Amount[i] := sell.Amount[i] - buy.BuyAmount[i];
            buy.HoldAmount[i] := buy.HoldAmount[i] + buy.BuyAmount[i];
            //instruct_32(sell.Item[i], buy.BuyAmount[i]);
            //instruct_32(MONEY_ID, -sell.Price[i] * buy.BuyAmount[i]);
            totalbuy[i] := totalbuy[i] + buy.BuyAmount[i];
            money := money - sell.Price[i] * buy.BuyAmount[i];
            buy.BuyAmount[i] := 0;
          end;
          //money := GetItemAmount(MONEY_ID);
        end;
        1:
        begin
          for i := 0 to 4 do
          begin
            sell.Amount[i] := sell.Amount[i] + totalbuy[i];
            //instruct_32(sell.Item[i], -totalbuy[i]);
            //instruct_32(MONEY_ID, sell.Price[i] * totalbuy[i]);
            buy.HoldAmount[i] := buy.HoldAmount[i] - totalbuy[i];
            buy.BuyAmount[i] := 0;
            totalbuy[i] := 0;
          end;
          money := GetItemAmount(MONEY_ID);
        end;
        2: break;
      end;
    end;
    refresh := refresh or (pmenu <> menu) or (pselect <> select) or (plr <> lr);
  end;
  //Rshop[shop_num] := sell;
  for i := 0 to 4 do
  begin
    Rshop[shop_num].Amount[i] := Rshop[shop_num].Amount[i] - totalbuy[i];
    instruct_32(Rshop[shop_num].Item[i], totalbuy[i]);
    instruct_32(MONEY_ID, -Rshop[shop_num].Price[i] * totalbuy[i]);
  end;
  FreeFreshScreen;
  CleanKeyValue;
end;


procedure ShowMap;
var
  i, u, n, x, y, l, p, xp, yp: integer;
  str1, str, strboat: WideString;
  str2, str3: array of WideString;
  scencex: array of integer;
  scencey: array of integer;
  scencenum: array of integer;
  dest1, dest: TSDL_Rect;
  picnum: integer = 4699;
  a11, a12, a21, a22, x0, y0: real;

  procedure TransCoord(var x, y: integer);
  var
    xt, yt: real;
  begin
    xt := a11 * x + a12 * y + x0;
    yt := a21 * x + a22 * y + y0;
    x := round(xt) + xp;
    y := max(round(yt), 53) + yp;
  end;

begin
  event.key.keysym.sym := 0;
  event.button.button := 0;
  n := 0;
  p := 0;
  u := 0;
  xp := CENTER_X - 320;
  ;
  yp := 10;
  Redraw;
  a11 := 1.2762;
  a12 := -0.7717;
  a21 := 0.1185;
  a22 := 1.6291;
  x0 := 121.9534;
  y0 := -194.0342;
  //if FileExists(AppPath + 'resource/map') then
  //Map_Pic := IMG_Load(PChar(AppPath + 'resource/map'));
  if picnum >= SPicAmount then
    exit;
  if SPNGIndex[picnum].Loaded = 0 then
    LoadOnePNGTexture('resource/smap', pSPic, SPNGIndex[picnum]);
  SPNGIndex[picnum].x := 0;
  SPNGIndex[picnum].y := 0;
  l := scenceAmount;
  for i := 0 to l - 1 do
  begin
    if ((Rscence[i].MainEntranceY1 = 0) and (Rscence[i].MainEntranceX1 = 0) and
      (Rscence[i].MainEntranceX2 = 0) and (Rscence[i].MainEntranceY2 = 0)) or (Rscence[i].EnCondition <> 0) then
      continue;
    Inc(u);
    setlength(scencex, u);
    setlength(scencey, u);
    setlength(scencenum, u);
    setlength(str2, u);
    setlength(str3, u);
    scencex[u - 1] := Rscence[i].MainEntranceX1;
    scencey[u - 1] := Rscence[i].MainEntranceY1;
    scencenum[u - 1] := i;
    str2[u - 1] := PCharToUnicode(@Rscence[i].Name[0], 5);
    str3[u - 1] := format('%3d, %3d', [Rscence[i].MainEntranceY1, Rscence[i].MainEntranceX1]);
  end;
  str := '你的位置';
  strboat := '船的位置';
  while SDL_PollEvent(@event) >= 0 do
  begin
    if (n mod 10 = 0) then
    begin

      dest1.x := 0;
      dest1.y := 30;
      dest1.w := 640;
      dest1.h := 380;
      DrawSPic(picnum, xp, yp + 30, @dest1, 0, 0, 0, 0);
      //  if i = p then continue;
      for i := 0 to u - 1 do
      begin
        x := 313 + ((scencey[i] - scencex[i]) * 5) div 8;
        y := 63 + ((scencey[i] + scencex[i]) * 5) div 16;
        TransCoord(x, y);
        dest1.x := 15;
        dest1.y := 0;
        dest1.w := 15;
        dest1.h := 15;
        DrawSPic(picnum, x, y, @dest1, 0, 0, 0, 0);
        if MouseInRegion(x, y, 15, 15) then
        begin
          p := i;
        end;
      end;
      x := 313 + ((scencey[p] - scencex[p]) * 5) div 8;
      y := 63 + ((scencey[p] + scencex[p]) * 5) div 16;
      TransCoord(x, y);
      dest1.x := 30;
      dest1.y := 0;
      dest1.w := 15;
      dest1.h := 15;
      DrawSPic(picnum, x, y, @dest1, 0, 0, 0, 0);
      //DrawSPic(picnum, dest.x,dest.y,@dest1,0,0,0,0);
      x := 313 + ((Shipx - Shipy) * 5) div 8;
      y := 63 + ((Shipx + Shipy) * 5) div 16;
      TransCoord(x, y);
      dest1.x := 45;
      dest1.y := 0;
      dest1.w := 15;
      dest1.h := 15;
      DrawSPic(picnum, x, y, @dest1, 0, 0, 0, 0);
      CleanTextScreen;
      //DrawSPic(picnum, dest.x,dest.y,@dest1,0,0,0,0);
      DrawShadowText(@str2[p][1], 37 + xp, 80 + yp, ColColor(21), ColColor(25));
      DrawEngShadowText(@str3[p][1], 37 + xp, 100 + yp, ColColor(255), ColColor(254));
      DrawShadowText(@str[1], 37 + xp, 275 + yp, ColColor(21), ColColor(25));
      str1 := format('%3d, %3d', [My, Mx]);
      DrawEngShadowText(@str1[1], 37 + xp, 295 + yp, ColColor(255), ColColor(254));
      DrawShadowText(@strboat[1], 37 + xp, 325 + yp, ColColor(21), ColColor(25));
      str1 := format('%3d, %3d', [shipx, shipy]);
      DrawEngShadowText(@str1[1], 37 + xp, 345 + yp, ColColor(255), ColColor(254));
    end;
    if n mod 20 = 1 then
    begin
      x := 313 + ((My - Mx) * 5) div 8;
      y := 63 + ((My + Mx) * 5) div 16;
      TransCoord(x, y);
      dest1.x := 0;
      dest1.y := 0;
      dest1.w := 15;
      dest1.h := 15;
      DrawSPic(picnum, x, y, @dest1, 0, 0, 0, 0);
      //DrawSPic(picnum, dest.x,dest.y,@dest1,0,0,0,0);
    end;
    UpdateAllScreen;

    SDL_Delay(20);
    n := n + 1;
    if n = 1000 then
      n := 0;
    CheckBasicEvent;
    case event.type_ of
      //方向键使用压下按键事件
      SDL_KEYUP:
      begin
        if (event.key.keysym.sym = SDLK_ESCAPE) or (event.key.keysym.sym = SDLK_RETURN) or
          (event.key.keysym.sym = SDLK_SPACE) then
          break;
        if (event.key.keysym.sym = SDLK_LEFT) or (event.key.keysym.sym = SDLK_UP) then
        begin
          if u <> 0 then
          begin
            p := p - 1;
            if p <= -1 then
              p := u - 1;
          end;
        end;
        if (event.key.keysym.sym = SDLK_RIGHT) or (event.key.keysym.sym = SDLK_DOWN) then
        begin
          if u <> 0 then
          begin
            p := p + 1;
            if p >= u then
              p := 0;
          end;
        end;
        event.key.keysym.sym := 0;
      end;
      SDL_MOUSEBUTTONUP:
        if event.button.button = SDL_BUTTON_RIGHT then
          break;
      SDL_MOUSEMOTION:
      begin
        for i := 0 to length(scencey) - 1 do
        begin
          x := 313 + ((scencey[i] - scencex[i]) * 5) div 8;
          y := 63 + ((scencey[i] + scencex[i]) * 5) div 16;
          TransCoord(x, y);
          if MouseInRegion(x, y, 15, 15) then
          begin
            p := i;
          end;
        end;
      end;
    end;
  end;

end;

//输入数字, 最小值, 最大值, 坐标x, y. 当结果被范围修正时有提示.

function EnterNumber(MinValue, MaxValue, x, y: integer; Default: integer = 0): smallint;
var
  value, i, menu, sure, pvalue, pmenu, highButton: integer;
  str: array[0..13] of WideString;
  color: uint32;
  strv, strr: WideString;
  //tempscr: psdl_surface;
  Button: array[0..13] of TSDL_Rect;
begin
  CleanKeyValue;
  value := Default;
  MinValue := max(-32768, MinValue);
  MaxValue := min(32767, MaxValue);
  //13个按钮的位置和大小
  for i := 0 to 9 do
  begin
    str[i] := IntToStr(i);
    Button[i].x := x + (i + 2) mod 3 * 35 + 20;
    Button[i].y := y + (3 - (i + 2) div 3) * 30 + 50;
    Button[i].w := 25;
    Button[i].h := 23;
  end;
  str[10] := '  ±';
  Button[10].x := x + 20;
  Button[10].y := y + 140;
  Button[10].w := 60;
  Button[10].h := 23;
  str[11] := '←';
  Button[11].x := x + 125;
  Button[11].y := y + 50;
  Button[11].w := 35;
  Button[11].h := 23;
  str[12] := 'AC';
  Button[12].x := x + 125;
  Button[12].y := y + 80;
  Button[12].w := 35;
  Button[12].h := 23;
  str[13] := 'OK';
  Button[13].x := x + 125;
  Button[13].y := y + 110;
  Button[13].w := 35;
  Button[13].h := 53;
  //Redraw;
  strv := UTF8Decode(format('範圍%d~%d', [MinValue, MaxValue]));
  DrawTextWithRect(@strv[1], x, y - 35, DrawLength(strv) * 10 + 8, 0, ColColor($27));
  DrawRectangle(x, y, 180, 180, 0, ColColor(255), 50, 0);
  DrawRectangle(x + 20, y + 10, 140, 23, 0, ColColor(255), 75, 0);
  highButton := high(Button);
  for  i := 0 to highButton do
  begin
    DrawRectangle(Button[i].x, Button[i].y, Button[i].w, Button[i].h, 0, ColColor(255), 50, 0);
  end;
  UpdateAllScreen;
  RecordFreshScreen(x, y, 181, 181);

  //在循环中写字体是为了字体分层模式容易处理
  menu := -1;
  sure := 0; //1-键盘按下, 2-鼠标按下
  pvalue := -1;
  pmenu := -1;
  while SDL_PollEvent(@event) >= 0 do
  begin
    CheckBasicEvent;
    case event.type_ of
      SDL_KeyUp:
      begin
        menu := -1;
        case event.key.keysym.sym of
          SDLK_0..SDLK_9: menu := event.key.keysym.sym - SDLK_0;
          SDLK_KP_1..SDLK_KP_9: menu := event.key.keysym.sym - SDLK_KP_1 + 1;
          SDLK_KP_0: menu := 0;
          SDLK_MINUS, SDLK_KP_MINUS: menu := 10;
          SDLK_BACKSPACE: menu := 11;
          SDLK_DELETE: menu := 12;
          SDLK_RETURN, SDLK_SPACE, SDLK_KP_ENTER: menu := highButton;
        end;
        sure := 1;
      end;
      SDL_MOUSEMOTION:
      begin
        menu := -1;
        for i := 0 to high(button) do
        begin
          if MouseInRegion(Button[i].x, Button[i].y, Button[i].w, Button[i].h) then
          begin
            menu := i;
            break;
          end;
        end;
      end;
      SDL_MOUSEBUTTONUP:
      begin
        case event.button.button of
          SDL_BUTTON_LEFT:
          begin
            menu := -1;
            for i := 0 to highButton do
            begin
              if MouseInRegion(Button[i].x, Button[i].y, Button[i].w, Button[i].h) then
              begin
                menu := i;
                break;
              end;
            end;
            if (menu >= 0) and (menu <= highButton) then
              sure := 2;
          end;
        end;
      end;
    end;
    //画界面
    if (value <> pvalue) or (menu <> pmenu) then
    begin
      LoadFreshScreen(x, y);
      strv := format('%6d', [value]);
      DrawShadowText(@strv[1], x + 80, y + 10, ColColor($64), ColColor($66));
      if (menu >= 0) and (menu <= highButton) then
      begin
        DrawRectangle(Button[menu].x, Button[menu].y, Button[menu].w, Button[menu].h,
          ColColor(20 * i + random(20)), ColColor(255), 50, 0);
      end;
      for i := 0 to highButton do
      begin
        DrawShadowText(@str[i][1], Button[i].x + 8, Button[i].y + Button[i].h div 2 - 11, ColColor(5), ColColor(7));
      end;
      UpdateAllScreen;
      pvalue := value;
      pmenu := menu;
    end;
    CleanKeyValue;
    //计算数值变化
    if sure > 0 then
    begin
      case menu of
        0.. 9:
          if value * 10 < 1e5 then
            value := 10 * value + menu;
        10: value := -value;
        11: value := value div 10;
        12: value := 0;
        else
          if menu = highButton then
            break;
      end;
      if sure = 1 then
        menu := -1;
    end;
    sure := 0;
    SDL_Delay(25);
  end;
  Result := RegionParameter(value, MinValue, MaxValue);
  //Redraw;
  if Result <> value then
  begin
    Redraw;
    UpdateAllScreen;
    strv := UTF8Decode(format('依據範圍自動調整為%d！', [Result]));
    DrawTextWithRect(@strv[1], x, y, DrawLength(strv) * 10 + 8, ColColor($64), ColColor($66));
    WaitAnyKey;
  end;
  CleanKeyValue;
  FreeFreshScreen;
end;

end.
