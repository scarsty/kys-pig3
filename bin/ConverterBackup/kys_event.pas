unit kys_event;

interface

uses
  Windows,
  SysUtils,
  StrUtils,
  SDL_TTF,
  SDL_mixer,
  SDL_image,
  SDL,
  Math,
  kys_main, Dialogs;

//事件系统
//在英文中, instruct通常不作为名词, swimmingfish在他的一份反汇编文件中大量使用
//这个词表示"指令", 所以这里仍保留这种用法
procedure instruct_0;
procedure instruct_1(talknum, headnum, dismode: integer);
procedure instruct_2(inum, amount: integer);
procedure ReArrangeItem;
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
procedure instruct_23(rnum, Poision: integer);
procedure instruct_24;
procedure instruct_25(x1, y1, x2, y2: integer);
procedure instruct_26(snum, enum, add1, add2, add3: integer);
procedure instruct_27(enum, beginpic, endpic: integer);
function instruct_28(rnum, e1, e2, jump1, jump2: integer): integer;
function instruct_29(rnum, r1, r2, jump1, jump2: integer): integer;
procedure instruct_30(x1, y1, x2, y2: integer);
function instruct_31(moneynum, jump1, jump2: integer): integer;
procedure instruct_32(inum, amount: integer);
procedure instruct_33(rnum, magicnum, dismode: integer);
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
procedure instruct_45(rnum, speed: integer);
procedure instruct_46(rnum, mp: integer);
procedure instruct_47(rnum, attack: integer);
procedure instruct_48(rnum, hp: integer);
procedure instruct_49(rnum, MPpro: integer);
function instruct_50(list: array of integer): integer;
procedure instruct_51;
procedure instruct_52;
procedure instruct_53;
procedure instruct_54;
function instruct_55(enum, Value, jump1, jump2: integer): integer;
procedure instruct_56(Repute: integer);
procedure instruct_57;
procedure instruct_58;
procedure instruct_59;
function instruct_60(snum, enum, pic, jump1, jump2: integer): integer;
function instruct_61(jump1, jump2: integer): integer;
procedure instruct_62(enum1, beginpic1, endpic1, enum2, beginpic2, endpic2: integer);
procedure EndAmi;
procedure instruct_63(rnum, sexual: integer);
procedure instruct_64;
procedure instruct_66(musicnum: integer);
procedure instruct_67(Soundnum: integer);
function e_GetValue(bit, t, x: integer): integer;
function instruct_50e(code, e1, e2, e3, e4, e5, e6: integer): integer;
function HaveMagic(person, mnum, lv: integer): boolean;
procedure StudyMagic(rnum, magicnum, newmagicnum, level, dismode: integer);
procedure NewTalk(headnum, talknum, namenum, place, showhead, color, frame: integer);
procedure ShowTitle(talknum, color: integer);
function Digging(beginPic, goal, shovel, restrict: integer): integer;
procedure ShowSurface(x, y, blank: integer; surface: array of integer);
procedure TeammateList;
function StarToRole(Starnum: integer): integer;
procedure newTeammateList;
function GetStarState(position: integer): integer;
procedure SetStarState(position, Value: integer);
procedure ShowTeamMate(position, headnum, Count: integer);
function ReSetName(t, inum, newnamenum: integer): integer;
procedure JmpScence(snum, y, x: integer);
function CommonScrollMenu_starlist(x, y, w, max, maxshow: integer): integer;
procedure ShowCommonScrollMenu_starlist(x, y, w, max, maxshow, menu, menutop, headn: integer);
procedure ShowStarList;
procedure SetAttribute(rnum, selecttype, modlevel, minlevel, maxlevel: integer);
function Lamp(c, beginpic, whitecount, chance: integer): boolean;
function GetItemAmount(inum: integer): integer;
procedure MissionList(mode: integer);
function GetMissionState(position: integer): integer;
procedure SetMissionState(position, Value: integer);
procedure RoleEnding(starnum, headnum, talknum: integer);
function Woodman(Chamber: integer): boolean;
procedure ShowManWalk(face, Eface1, Eface2: integer);
procedure ShowWoodManWalk(num, Eface1, Eface2, RoleFace: integer);
function SpellPicture(num, chance: integer): boolean;
procedure ExchangePic(p1, p2: integer);
procedure ReSort;
procedure bookList;
function GetStarAmount: smallint;
function DancerAfter90S: integer;

implementation

uses kys_script, kys_engine, kys_battle;

//事件系统
//事件指令含义请参阅其他相关文献

procedure instruct_0;
begin
  redraw;
  //SDL_UpdateRect2(screen,0,0,screen.w,screen.h);

end;

procedure instruct_1(talknum, headnum, dismode: integer);
var
  idx, grp, offset, len, i, p, l, headx, heady, diagx, diagy: integer;
  talkarray: array of byte;
  Name: WideString;
begin
  case dismode of
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
  idx := fileopen('resource\talk.idx', fmopenread);
  grp := fileopen('resource\talk.grp', fmopenread);
  if talknum = 0 then
  begin
    offset := 0;
    fileread(idx, len, 4);
  end
  else
  begin
    fileseek(idx, (talknum - 1) * 4, 0);
    fileread(idx, offset, 4);
    fileread(idx, len, 4);
  end;
  len := (len - offset);
  setlength(talkarray, len + 1);
  fileseek(grp, offset, 0);
  fileread(grp, talkarray[0], len);
  fileclose(idx);
  fileclose(grp);
  drawrectanglewithoutframe(0, diagy - 10, 640, 120, 0, 40);
  if headx > 0 then
    drawheadpic(headnum, headx, heady);
  //if headnum <= MAX_HEAD_NUM then
  //begin
  //name := Big5toUnicode(@rrole[headnum].Name);
  //drawshadowtext(@name[1], headx + 20 - length(name) * 10, heady + 5, colcolor($ff), colcolor($0));
  //end;
  for i := 0 to len - 1 do
  begin
    talkarray[i] := talkarray[i] xor $FF;
    if (talkarray[i] = $2A) then
      talkarray[i] := 0;
  end;
  talkarray[len - 1] := $20;
  p := 0;
  l := 0;
  for i := 0 to len do
  begin
    if talkarray[i] = 0 then
    begin
      drawbig5shadowtext(@talkarray[p], diagx, diagy + l * 22, colcolor($FF), colcolor($0));
      p := i + 1;
      l := l + 1;
      if (l >= 4) and (i < len) then
      begin
        SDL_UpdateRect2(screen, 0, 0, screen.w, screen.h);
        WaitAnyKey;
        Redraw;
        drawrectanglewithoutframe(0, diagy - 10, 640, 120, 0, 40);
        if headx > 0 then
          drawheadpic(headnum, headx, heady);
        l := 0;
      end;
    end;
  end;
  SDL_UpdateRect2(screen, 0, 0, screen.w, screen.h);
  waitanykey;
  redraw;

end;

//得到物品可显示数量, 数量为负显示失去物品

procedure instruct_2(inum, amount: integer);
var
  i, x: integer;
  word: WideString;
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
  if RItemList[i].number < 0 then
  begin
    RItemList[i].Number := inum;
    RItemList[i].Amount := amount;
  end;

  ReArrangeItem;

  x := CENTER_X;
  if where = 2 then
    x := 190;

  DrawRectangle(x - 75, 98, 145, 76, 0, colcolor(255), 30);
  if amount >= 0 then
    word := ' 得到物品'
  else
  begin
    word := ' 失去物品';
    amount := -amount;
  end;
  drawshadowtext(@word[1], x - 90, 100, colcolor($21), colcolor($23));
  drawbig5shadowtext(@RItem[inum].Name, x - 90, 125, colcolor(5), colcolor(7));
  word := ' 數量';
  drawshadowtext(@word[1], x - 90, 150, colcolor($64), colcolor($66));
  word := format(' %5d', [amount]);
  drawengshadowtext(@word[1], x - 5, 150, colcolor($64), colcolor($66));
  SDL_UpdateRect2(screen, 0, 0, screen.w, screen.h);
  waitanykey;
  redraw;
  //SDL_UpdateRect2(screen, 0, 0, screen.w, screen.h);

end;

procedure ReArrangeItem;
var
  i, p: integer;
  item, amount: array of integer;
begin
  p := 0;
  setlength(item, MAX_ITEM_AMOUNT);
  setlength(amount, MAX_ITEM_AMOUNT);
  for i := 0 to MAX_ITEM_AMOUNT - 1 do
  begin
    if (RItemList[i].Number >= 0) and (RItemList[i].Amount > 0) then
    begin
      item[p] := RItemList[i].Number;
      amount[p] := RItemList[i].Amount;
      p := p + 1;
    end;
  end;
  for i := 0 to MAX_ITEM_AMOUNT - 1 do
  begin
    if i < p then
    begin
      RItemList[i].Number := item[i];
      RItemList[i].Amount := amount[i];
    end
    else
    begin
      RItemList[i].Number := -1;
      RItemList[i].Amount := 0;
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
    InitialScence(1);
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
begin
  setlength(menustring, 3);
  menustring[0] := ' 取消';
  menustring[1] := ' 戰鬥';
  menustring[2] := ' 是否與之戰鬥？';
  drawtextwithrect(@menustring[2][1], CENTER_X - 75, CENTER_Y - 85, 150, colcolor(5), colcolor(7));
  menu := commonmenu2(CENTER_X - 49, CENTER_Y - 50, 98);
  if menu = 1 then
    Result := jump1
  else
    Result := jump2;
  redraw;
  SDL_UpdateRect2(screen, 0, 0, screen.w, screen.h);

end;

//战斗

function instruct_6(battlenum, jump1, jump2, getexp: integer): integer;
begin
  Result := jump2;
  if Battle(battlenum, getexp) then
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
begin
  setlength(menustring, 3);
  menustring[0] := ' 取消';
  menustring[1] := ' 要求';
  menustring[2] := ' 是否要求加入？';
  drawtextwithrect(@menustring[2][1], CENTER_X - 75, CENTER_Y - 85, 150, colcolor(5), colcolor(7));
  menu := commonmenu2(CENTER_X - 49, CENTER_Y - 50, 98);
  if menu = 1 then
    Result := jump1
  else
    Result := jump2;
  redraw;
  SDL_UpdateRect2(screen, 0, 0, screen.w, screen.h);

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

function instruct_11(jump1, jump2: integer): integer;
var
  menu: integer;
begin
  setlength(menustring, 3);
  menustring[0] := '  否';
  menustring[1] := '  是';
  menustring[2] := ' 是否需要住宿？';
  drawtextwithrect(@menustring[2][1], CENTER_X - 75, CENTER_Y - 85, 150, colcolor(5), colcolor(7));
  menu := commonmenu2(CENTER_X - 49, CENTER_Y - 50, 98);
  if menu = 1 then
    Result := jump1
  else
    Result := jump2;
  redraw;
  SDL_UpdateRect2(screen, 0, 0, screen.w, screen.h);

end;

//住宿

procedure instruct_12;
var
  i, rnum: integer;
begin
  for i := 0 to 5 do
  begin
    rnum := Teamlist[i];
    if not ((rnum = -1) or (RRole[rnum].Hurt > 33) or (RRole[rnum].Poision > 0)) then
    begin
      RRole[rnum].CurrentHP := RRole[rnum].MaxHP;
      RRole[rnum].CurrentMP := RRole[rnum].MaxMP;
      RRole[rnum].PhyPower := MAX_PHYSICAL_POWER;
    end;
  end;

end;

//亮屏, 在亮屏之前重新初始化场景



//亮屏, 在亮屏之前重新初始化场景

procedure instruct_13;
var
  i: integer;
begin
  //for i1:=0 to 199 do
  //for i2:=0 to 10 do
  //DData[CurScence, [i1,i2]:=Ddata[CurScence,i1,i2];
  InitialScence;
  NeedRefreshScence := 0;
  for i := blackscreen downto 0 do
  begin
    //Sdl_Delay(5);
    Redraw;
    DrawRectangleWithoutFrame(0, 0, screen.w, screen.h, 0, i * 10);
    SDL_UpdateRect2(screen, 0, 0, screen.w, screen.h);
  end;
  blackscreen := 0;
  SDL_EventState(SDL_KEYDOWN, SDL_ENABLE);
  SDL_EventState(SDL_KEYUP, SDL_ENABLE);
  SDL_EventState(SDL_mousebuttonUP, SDL_ENABLE);
  SDL_EventState(SDL_mousebuttonDOWN, SDL_ENABLE);
end;

//黑屏

procedure instruct_14;
var
  i: integer;
begin
  SDL_EventState(SDL_KEYDOWN, SDL_IGNORE);
  SDL_EventState(SDL_KEYUP, SDL_IGNORE);
  SDL_EventState(SDL_mousebuttonUP, SDL_IGNORE);
  SDL_EventState(SDL_mousebuttonDOWN, SDL_IGNORE);
  for i := blackscreen to 10 do
  begin
    //Redraw;
    Sdl_Delay(10);
    DrawRectangleWithoutFrame(0, 0, screen.w, screen.h, 0, i * 10);
    SDL_UpdateRect2(screen, 0, 0, screen.w, screen.h);
  end;
  blackscreen := 10;

end;

//失败画面

procedure instruct_15;
var
  i, x, y: integer;
  str: WideString;
begin
  where := 3;
  redraw;
  drawrectanglewithoutframe(0, 0, CENTER_X * 2, CENTER_Y * 2, 0, 60);
  str := '  小村的傳說失敗了…';
  drawshadowtext(@str[1], CENTER_X - 120, CENTER_Y - 25, colcolor(255), colcolor(255));
  str := ' 但是遊戲是可以重來的！';
  drawshadowtext(@str[1], CENTER_X - 120, CENTER_Y, colcolor(255), colcolor(255));
  x := 425;
  y := 275;
  drawtitlepic(0, x, y);

  SDL_UpdateRect2(screen, 0, 0, screen.w, screen.h);
  waitanykey;
end;

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

procedure instruct_19(x, y: integer);
begin
  Sx := y;
  Sy := x;
  Cx := Sx;
  Cy := Sy;
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
    RRole[Teamlist[i]].CurrentMP := 0;
end;

procedure instruct_23(rnum, Poision: integer);
begin
  RRole[rnum].UsePoi := Poision;
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
  //showmessage(inttostr(ssx*100+ssy));
  if s <> 0 then
    while (SDL_PollEvent(@event) >= 0) do
    begin
      CheckBasicEvent;
      sdl_delay(50);
      DrawScenceWithoutRole(y1, i);
      //showmessage(inttostr(i));
      if curevent <> BEGIN_EVENT then
        DrawRoleOnScence(y1, i);
      SDL_UpdateRect2(screen, 0, 0, screen.w, screen.h);
      i := i + s;
      //showmessage(inttostr(s*(x2-i)));
      if (s * (x2 - i) < 0) then
        break;
    end;
  s := sign(y2 - y1);
  i := y1 + s;
  if s <> 0 then
    while (SDL_PollEvent(@event) >= 0) do
    begin
      CheckBasicEvent;
      sdl_delay(50);
      DrawScenceWithoutRole(i, x2);
      //showmessage(inttostr(i));
      if curevent <> BEGIN_EVENT then
        DrawRoleOnScence(i, x2);
      //Redraw;
      SDL_UpdateRect2(screen, 0, 0, screen.w, screen.h);
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
  AboutMainRole: boolean;
begin
  AboutMainRole := False;
  if enum = -1 then
  begin
    enum := CurEvent;
    if SData[CurScence, 3, Sx, Sy] >= 0 then
      enum := SData[CurScence, 3, Sx, Sy];
    AboutMainRole := True;
  end;
  if enum = SData[CurScence, 3, Sx, Sy] then
    AboutMainRole := True;
  SData[CurScence, 3, DData[CurScence, enum, 10], DData[CurScence, enum, 9]] := enum;

  i := beginpic;
  while SDL_PollEvent(@event) >= 0 do
  begin
    CheckBasicEvent;
    DData[CurScence, enum, 5] := i;
    UpdateScence(DData[CurScence, enum, 10], DData[CurScence, enum, 9]);
    sdl_delay(20);
    DrawScenceWithoutRole(Sx, Sy);
    if not (AboutMainRole) then
      DrawRoleOnScence(Sx, Sy);
    //showmessage(inttostr(enum+100*CurEvent));
    SDL_UpdateRect2(screen, 0, 0, screen.w, screen.h);
    i := i + 1;
    if i > endpic then
      break;
  end;

  //showmessage(inttostr(Sx+100*Sy));
  //showmessage(inttostr(DData[CurScence, [enum,10]+100*DData[CurScence, [enum,9]));
  DData[CurScence, enum, 5] := DData[CurScence, enum, 7];
  UpdateScence(DData[CurScence, enum, 10], DData[CurScence, enum, 9]);
end;

function instruct_28(rnum, e1, e2, jump1, jump2: integer): integer;
begin
  Result := jump2;
  if (rrole[rnum].Ethics >= e1) and (rrole[rnum].Ethics <= e2) then
    Result := jump1;
end;

function instruct_29(rnum, r1, r2, jump1, jump2: integer): integer;
begin
  Result := jump2;
  if (rrole[rnum].Attack >= r1) and (rrole[rnum].Attack <= r2) then
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
      sdl_delay(50);
      DrawScenceWithoutRole(Sx, Sy);
      SStep := SStep + 1;
      if SStep >= 7 then
        SStep := 1;
      DrawRoleOnScence(Sx, Sy);
      SDL_UpdateRect2(screen, 0, 0, screen.w, screen.h);
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
      sdl_delay(50);
      DrawScenceWithoutRole(Sx, Sy);
      SStep := SStep + 1;
      if SStep >= 7 then
        SStep := 1;
      DrawRoleOnScence(Sx, Sy);
      SDL_UpdateRect2(screen, 0, 0, screen.w, screen.h);
      Sx := Sx + s;
      if s * (y2 - Sx) < 0 then
        break;
    end;
  Sx := y2;
  Sy := x2;
  SStep := 0;
  Cx := Sx;
  Cy := Sy;
end;

function instruct_31(moneynum, jump1, jump2: integer): integer;
var
  i: integer;
begin
  Result := jump2;
  for i := 0 to MAX_ITEM_AMOUNT - 1 do
  begin
    if (RItemList[i].Number = MONEY_ID) and (RItemList[i].Amount >= moneynum) then
    begin
      Result := jump1;
      break;
    end;
  end;
end;

procedure instruct_32(inum, amount: integer);
var
  i: integer;
  word: WideString;
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

//学到武功, 如果已有武功则升级, 如果已满10个不会洗武功

procedure instruct_33(rnum, magicnum, dismode: integer);
var
  i: integer;
  word: WideString;
begin
  if (magicnum >= 116) and (magicnum <= 130) then
  begin
    for i := 0 to 3 do
    begin
      if (RRole[rnum].neigong[i] <= 0) or (RRole[rnum].neigong[i] = magicnum) then
      begin
        if RRole[rnum].neigong[i] > 0 then
          RRole[rnum].NGlevel[i] := RRole[rnum].NGlevel[i] + 100;
        RRole[rnum].neigong[i] := magicnum;
        if RRole[rnum].NGLevel[i] > 999 then
          RRole[rnum].NGlevel[i] := 999;
        break;
      end;
    end;
  end
  else
    for i := 0 to 9 do
    begin
      if (RRole[rnum].Magic[i] <= 0) or (RRole[rnum].Magic[i] = magicnum) then
      begin
        if RRole[rnum].Magic[i] > 0 then
          RRole[rnum].Maglevel[i] := RRole[rnum].Maglevel[i] + 100;
        RRole[rnum].Magic[i] := magicnum;
        if RRole[rnum].MagLevel[i] > 999 then
          RRole[rnum].Maglevel[i] := 999;
        break;
      end;
    end;
  //if i = 10 then rrole[rnum].data[i+63] := magicnum;
  if dismode = 0 then
  begin
    DrawRectangle(CENTER_X - 75, 98, 145, 76, 0, colcolor(255), 30);
    word := ' 學會';
    drawshadowtext(@word[1], CENTER_X - 90, 125, colcolor(5), colcolor(7));
    drawbig5shadowtext(@rrole[rnum].Name, CENTER_X - 90, 100, colcolor($21), colcolor($23));
    drawbig5shadowtext(@Rmagic[magicnum].Name, CENTER_X - 90, 150, colcolor($64), colcolor($66));
    SDL_UpdateRect2(screen, 0, 0, screen.w, screen.h);
    waitanykey;
    redraw;
  end;
end;

procedure instruct_34(rnum, iq: integer);
var
  word: WideString;
begin
  if RRole[rnum].Aptitude + iq <= 100 then
  begin
    RRole[rnum].Aptitude := RRole[rnum].Aptitude + iq;
  end
  else
  begin
    iq := 100 - RRole[rnum].Aptitude;
    RRole[rnum].Aptitude := 100;
  end;
  if iq > 0 then
  begin
    DrawRectangle(CENTER_X - 75, 98, 145, 51, 0, colcolor(255), 30);
    word := ' 資質增加';
    drawshadowtext(@word[1], CENTER_X - 90, 125, colcolor(5), colcolor(7));
    drawbig5shadowtext(@rrole[rnum].Name, CENTER_X - 90, 100, colcolor($21), colcolor($23));
    word := format('%3d', [iq]);
    drawengshadowtext(@word[1], CENTER_X + 30, 125, colcolor($64), colcolor($66));
    SDL_UpdateRect2(screen, 0, 0, screen.w, screen.h);
    waitanykey;
    redraw;
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
      if RRole[rnum].Magic[i] <= 0 then
      begin
        RRole[rnum].Magic[i] := magicnum;
        RRole[rnum].MagLevel[i] := exp;
        break;
      end;
    end;
    if i = 10 then
    begin
      RRole[rnum].Magic[0] := magicnum;
      RRole[rnum].MagLevel[i] := exp;
    end;
  end
  else
  begin
    RRole[rnum].Magic[magiclistnum] := magicnum;
    RRole[rnum].MagLevel[magiclistnum] := exp;
  end;
end;

function instruct_36(sexual, jump1, jump2: integer): integer;
begin
  Result := jump2;
  if rrole[0].Sexual = sexual then
    Result := jump1;
  if sexual > 255 then
    if x50[$7000] = 0 then
      Result := jump1
    else
      Result := jump2;
end;

procedure instruct_37(Ethics: integer);
begin
  RRole[0].Ethics := RRole[0].Ethics + ethics;
  if RRole[0].Ethics > 100 then
    RRole[0].Ethics := 100;
  if RRole[0].Ethics < 0 then
    RRole[0].Ethics := 0;
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
    NeedRefreshScence := 1;
end;

procedure instruct_39(snum: integer);
begin
  Rscence[snum].EnCondition := 0;
end;

procedure instruct_40(director: integer);
begin
  Sface := director;
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
    InitialScence(1);
    sdl_delay(20);
    //DrawScenceWithoutRole(Sx, Sy);
    DrawScence;
    SDL_UpdateRect2(screen, 0, 0, screen.w, screen.h);
    i := i + 1;
    if i > endpic1 - beginpic1 then
      break;
  end;
  //SData[CurScence, 3, DData[CurScence, [enum,10],DData[CurScence, [enum,9]]:=-1;
end;

procedure instruct_45(rnum, speed: integer);
var
  word: WideString;
begin
  RRole[rnum].Speed := RRole[rnum].Speed + speed;
  DrawRectangle(CENTER_X - 75, 98, 145, 51, 0, colcolor(255), 30);
  word := ' 輕功增加';
  drawshadowtext(@word[1], CENTER_X - 90, 125, colcolor(5), colcolor(7));
  drawbig5shadowtext(@rrole[rnum].Name, CENTER_X - 90, 100, colcolor($21), colcolor($23));
  word := format('%4d', [speed]);
  drawengshadowtext(@word[1], CENTER_X + 20, 125, colcolor($64), colcolor($66));
  SDL_UpdateRect2(screen, 0, 0, screen.w, screen.h);
  waitanykey;
  redraw;
end;

procedure instruct_46(rnum, mp: integer);
var
  word: WideString;
begin
  RRole[rnum].MaxMP := RRole[rnum].MaxMP + mp;
  RRole[rnum].CurrentMP := RRole[rnum].MaxMP;
  DrawRectangle(CENTER_X - 75, 98, 145, 51, 0, colcolor(255), 30);
  word := ' 內力增加';
  drawshadowtext(@word[1], CENTER_X - 90, 125, colcolor(5), colcolor(7));
  drawbig5shadowtext(@rrole[rnum].Name, CENTER_X - 90, 100, colcolor($21), colcolor($23));
  word := format('%4d', [mp]);
  drawengshadowtext(@word[1], CENTER_X + 20, 125, colcolor($64), colcolor($66));
  SDL_UpdateRect2(screen, 0, 0, screen.w, screen.h);
  waitanykey;
  redraw;
end;

procedure instruct_47(rnum, attack: integer);
var
  word: WideString;
begin
  RRole[rnum].Attack := RRole[rnum].Attack + attack;
  DrawRectangle(CENTER_X - 75, 98, 145, 51, 0, colcolor(255), 30);
  word := ' 武力增加';
  drawshadowtext(@word[1], CENTER_X - 90, 125, colcolor(5), colcolor(7));
  drawbig5shadowtext(@rrole[rnum].Name, CENTER_X - 90, 100, colcolor($21), colcolor($23));
  word := format('%4d', [attack]);
  drawengshadowtext(@word[1], CENTER_X + 20, 125, colcolor($64), colcolor($66));
  SDL_UpdateRect2(screen, 0, 0, screen.w, screen.h);
  waitanykey;
  redraw;
end;

procedure instruct_48(rnum, hp: integer);
var
  word: WideString;
begin
  RRole[rnum].MaxHP := RRole[rnum].MaxHP + hp;
  RRole[rnum].CurrentHP := RRole[rnum].MaxHP;
  DrawRectangle(CENTER_X - 75, 98, 145, 51, 0, colcolor(255), 30);
  word := ' 生命增加';
  drawshadowtext(@word[1], CENTER_X - 90, 125, colcolor(5), colcolor(7));
  drawbig5shadowtext(@rrole[rnum].Name, CENTER_X - 90, 100, colcolor($21), colcolor($23));
  word := format('%4d', [hp]);
  drawengshadowtext(@word[1], CENTER_X + 20, 125, colcolor($64), colcolor($66));
  SDL_UpdateRect2(screen, 0, 0, screen.w, screen.h);
  waitanykey;
  redraw;
end;

procedure instruct_49(rnum, MPpro: integer);
begin
  RRole[rnum].MPType := MPpro;
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

procedure instruct_52;
var
  word: WideString;
begin
  DrawRectangle(CENTER_X - 110, 98, 220, 26, 0, colcolor(255), 30);
  word := ' 你的品德指數為：';
  drawshadowtext(@word[1], CENTER_X - 125, 100, colcolor(5), colcolor(7));
  word := format('%3d', [rrole[0].Ethics]);
  drawengshadowtext(@word[1], CENTER_X + 65, 100, colcolor($64), colcolor($66));
  SDL_UpdateRect2(screen, 0, 0, screen.w, screen.h);
  waitanykey;
  redraw;
end;

procedure instruct_53;
var
  word: WideString;
begin
  DrawRectangle(CENTER_X - 110, 98, 220, 26, 0, colcolor(255), 30);
  word := ' 你的聲望指數為：';
  drawshadowtext(@word[1], CENTER_X - 125, 100, colcolor(5), colcolor(7));
  word := format('%3d', [rrole[0].Repute]);
  drawengshadowtext(@word[1], CENTER_X + 65, 100, colcolor($64), colcolor($66));
  SDL_UpdateRect2(screen, 0, 0, screen.w, screen.h);
  waitanykey;
  redraw;
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

function instruct_55(enum, Value, jump1, jump2: integer): integer;
begin
  Result := jump2;
  if DData[CurScence, enum, 2] = Value then
    Result := jump1;
end;

//Add repute.
//声望刚刚超过200时家里出现请帖

procedure instruct_56(Repute: integer);
begin
  RRole[0].Repute := RRole[0].Repute + repute;
  if (RRole[0].Repute > 200) and (RRole[0].Repute - repute <= 200) then
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
    InitialScence(1);
    sdl_delay(20);
    //DrawScenceWithoutRole(Sx, Sy);
    DrawScence;
    SDL_UpdateRect2(screen, 0, 0, screen.w, screen.h);
    i := i + 1;
    if i > endpic1 - beginpic1 then
      break;
  end;
  //SData[CurScence, 3, DData[CurScence, [enum,10],DData[CurScence, [enum,9]]:=-1;
end;

procedure instruct_58;
var
  i, p: integer;
begin
  for i := 0 to 14 do
  begin
    p := random(2);
    instruct_1(2854 + i * 2 + p, 0, 3);
    if not (battle(102 + i * 2 + p, 0)) then
    begin
      instruct_15;
      break;
    end;
    instruct_14;
    instruct_13;
    if i mod 3 = 2 then
    begin
      instruct_1(2891, 0, 3);
      instruct_12;
      instruct_14;
      instruct_13;
    end;
  end;
  if where <> 3 then
  begin
    instruct_1(2884, 0, 3);
    instruct_1(2885, 0, 3);
    instruct_1(2886, 0, 3);
    instruct_1(2887, 0, 3);
    instruct_1(2888, 0, 3);
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
    TeamList[i] := -1;

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
  //CurScenceRolePic := -1;
  instruct_44(enum1, beginpic1, endpic1, enum2, beginpic2, endpic2);
  where := 3;
  redraw;
  EndAmi;
  //display_img('end.png', 0, 0);
  //where := 3;
end;

procedure EndAmi;
var
  x, y, i, len: integer;
  str: WideString;
  p: integer;
begin
  instruct_14;
  redraw;
  i := fileopen('list\end.txt', fmOpenRead);
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
      y := 80;
      redraw;
      waitanykey;
      drawrectanglewithoutframe(0, 0, CENTER_X * 2, CENTER_Y * 2, 0, 60);
    end;
  end;
  waitanykey;
  instruct_14;

  for i := 440 - 794 to 0 do
  begin
    if i mod 5 = 0 then
      display_img('resource\end.png', 0, i);
    SDL_UpdateRect2(screen, 0, 0, screen.w, screen.h);
    sdl_delay(5);
  end;
  waitanykey;

end;

//Set sexual.

procedure instruct_63(rnum, sexual: integer);
begin
  RRole[rnum].Sexual := sexual;
end;

//韦小宝的商店

procedure instruct_64;
var
  i, amount, shopnum, menu, price: integer;
  list: array[0..4] of integer;
begin
  setlength(Menustring, 5);
  setlength(Menuengstring, 5);
  amount := 0;
  //任选一个商店, 因未写他去其他客栈的指令
  shopnum := random(5);
  //p:=0;
  for i := 0 to 4 do
  begin
    if Rshop[shopnum].Amount[i] > 0 then
    begin
      menustring[amount] := Big5toUnicode(@Ritem[Rshop[shopnum].Item[i]].Name);
      menuengstring[amount] := format('%10d', [Rshop[shopnum].Price[i]]);
      list[amount] := i;
      amount := amount + 1;
    end;
  end;
  instruct_1($B9E, $6F, 0);
  menu := commonmenu(CENTER_X - 100, 150, 85 + length(menuengstring[0]) * 10, amount - 1);
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
  end;
end;

procedure instruct_66(musicnum: integer);
begin
  stopmp3;
  playmp3(musicnum, -1);
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
  p, p1: PChar;
  //ps :pstring;
  str: string;
  word, word1: WideString;
begin
  Result := 0;
  case code of
    0: //Give a value to a papameter.
    begin
      x50[e1] := e2;
    end;
    1: //Give a value to one member in parameter group.
    begin
      t1 := e3 + e_getvalue(0, e1, e4);
      x50[t1] := e_getvalue(1, e1, e5);
      if e2 = 1 then
        x50[t1] := x50[t1] and $FF;
    end;
    2: //Get the value of one member in parameter group.
    begin
      t1 := e3 + e_getvalue(0, e1, e4);
      x50[e5] := x50[t1];
      if e2 = 1 then
        x50[t1] := x50[t1] and $FF;
    end;
    3: //Basic calculations.
    begin
      t1 := e_getvalue(0, e1, e5);
      case e2 of
        0: x50[e3] := x50[e4] + t1;
        1: x50[e3] := x50[e4] - t1;
        2: x50[e3] := x50[e4] * t1;
        3: x50[e3] := x50[e4] div t1;
        4: x50[e3] := x50[e4] mod t1;
        5: x50[e3] := Uint16(x50[e4]) div t1;
      end;
    end;
    4: //Judge the parameter.
    begin
      x50[$7000] := 0;
      t1 := e_getvalue(0, e1, e4);
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
      for i := -$8000 to $7FFF do
        x50[i] := 0;
    end;
    8: //Read talk to string.
    begin
      t1 := e_getvalue(0, e1, e2);
      idx := fileopen('resource\talk.idx', fmopenread);
      grp := fileopen('resource\talk.grp', fmopenread);
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
      fileseek(grp, offset, 0);
      fileread(grp, x50[e3], len);
      fileclose(idx);
      fileclose(grp);
      p := @x50[e3];
      for i := 0 to len - 1 do
      begin
        p^ := char(byte(p^) xor $FF);
        if p^ = char($FF) then
          p^ := char(0);
        p := p + 1;

      end;
      p^ := char(0);
      //x50[e3+i]:=0;
    end;
    9: //Format the string.
    begin
      e4 := e_getvalue(0, e1, e4);
      p := @x50[e2];
      p1 := @x50[e3];
      str := p1;
      str := format(string(p1), [e4]);
      for i := 0 to length(str) do
      begin
        p^ := str[i + 1];
        p := p + 1;
      end;
    end;
    10: //Get the length of a string.
    begin
      x50[e2] := length(PChar(@x50[e1]));
      //showmessage(inttostr(x50[e2]));
    end;
    11: //Combine 2 strings.
    begin
      p := @x50[e1];
      p1 := @x50[e2];
      for i := 0 to length(p1) - 1 do
      begin
        p^ := (p1 + i)^;
        p := p + 1;
      end;
      p1 := @x50[e3];
      for i := 0 to length(p1) do
      begin
        p^ := (p1 + i)^;
        p := p + 1;
      end;
      //p^:=char(0);
    end;
    12: //Build a string with spaces.
      //Note: here the width of one 'space' is the same as one Chinese charactor.
    begin
      e3 := e_getvalue(0, e1, e3);
      p := @x50[e2];
      for i := 0 to e3 do
      begin
        p^ := char($20);
        p := p + 1;
      end;
      p^ := char(0);
    end;
    16: //Write R data.
    begin
      e3 := e_getvalue(0, e1, e3);
      e4 := e_getvalue(1, e1, e4);
      e5 := e_getvalue(2, e1, e5);
      case e2 of
        0: Rrole[e3].Data[e4 div 2] := e5;
        1: Ritem[e3].Data[e4 div 2] := e5;
        2: Rscence[e3].Data[e4 div 2] := e5;
        3: Rmagic[e3].Data[e4 div 2] := e5;
        4: Rshop[e3].Data[e4 div 2] := e5;
      end;
    end;
    17: //Read R data.
    begin
      e3 := e_getvalue(0, e1, e3);
      e4 := e_getvalue(1, e1, e4);
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
      e2 := e_getvalue(0, e1, e2);
      e3 := e_getvalue(1, e1, e3);
      TeamList[e2] := e3;
      //showmessage(inttostr(e3));
    end;
    19: //Read team data.
    begin
      e2 := e_getvalue(0, e1, e2);
      x50[e3] := TeamList[e2];
    end;
    20: //Get the amount of one item.
    begin
      e2 := e_getvalue(0, e1, e2);
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
      e2 := e_getvalue(0, e1, e2);
      e3 := e_getvalue(1, e1, e3);
      e4 := e_getvalue(2, e1, e4);
      e5 := e_getvalue(3, e1, e5);
      Ddata[e2, e3, e4] := e5;
      //if e2=CurScence then DData[CurScence, [e3,e4]:=e5;
      //InitialScence;
      //Redraw;
      //SDL_UpdateRect2(screen,0,0,screen.w,screen.h);
    end;
    22:
    begin
      e2 := e_getvalue(0, e1, e2);
      e3 := e_getvalue(1, e1, e3);
      e4 := e_getvalue(2, e1, e4);
      x50[e5] := Ddata[e2, e3, e4];
    end;
    23:
    begin
      e2 := e_getvalue(0, e1, e2);
      e3 := e_getvalue(1, e1, e3);
      e4 := e_getvalue(2, e1, e4);
      e5 := e_getvalue(3, e1, e5);
      e6 := e_getvalue(4, e1, e6);
      Sdata[e2, e3, e5, e4] := e6;
      if e2 = CurScence then
        UpdateScence(e5, e4);
      //if e2=CurScence then SData[CurScence, 3, e5,e4]:=e6;;
      //InitialScence;
      //Redraw;
      //SDL_UpdateRect2(screen,0,0,screen.w,screen.h);
    end;
    24:
    begin
      e2 := e_getvalue(0, e1, e2);
      e3 := e_getvalue(1, e1, e3);
      e4 := e_getvalue(2, e1, e4);
      e5 := e_getvalue(3, e1, e5);
      x50[e6] := Sdata[e2, e3, e5, e4];
      //showmessage(inttostr(sface));
    end;
    25:
    begin
      e5 := e_getvalue(0, e1, e5);
      e6 := e_getvalue(1, e1, e6);
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
        end;
      end;
      //redraw;
      SDL_UpdateRect2(screen, 0, 0, screen.w, screen.h);
    end;
    26:
    begin
      e6 := e_getvalue(0, e1, e6);
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
        $1C0B90: x50[e5] := sdl_getticks div 55 mod 65536;
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
      e3 := e_getValue(0, e1, e3);
      p := @x50[e4];
      case e2 of
        0: p1 := @Rrole[e3].Name;
        1: p1 := @Ritem[e3].Name;
        2: p1 := @Rscence[e3].Name;
        3: p1 := @Rmagic[e3].Name;
      end;
      for i := 0 to 19 do
      begin
        (p + i)^ := (p1 + i)^;
        if (p1 + i)^ = char(0) then
          break;
      end;
      (p + i)^ := char($20);
      (p + i + 1)^ := char(0);
    end;
    28: //Get the battle number.
    begin
      x50[e1] := x50[28005];
    end;
    29: //Select aim.
    begin
      e2 := e_getvalue(0, e1, e2);
      e3 := e_getvalue(1, e1, e3);
      //showmessage('IN CASE');
      if e5 = 0 then
      begin
        selectaim(e2, e3);
      end;
      x50[e4] := bfield[2, Ax, Ay];
    end;
    30: //Read battle properties.
    begin
      e2 := e_getvalue(0, e1, e2);
      e3 := e_getvalue(1, e1, e3);
      x50[e4] := brole[e2].Data[e3 div 2];
    end;
    31: //Write battle properties.
    begin
      e2 := e_getvalue(0, e1, e2);
      e3 := e_getvalue(1, e1, e3);
      e4 := e_getvalue(2, e1, e4);
      brole[e2].Data[e3 div 2] := e4;
    end;
    32: //Modify next instruct.
    begin
      e3 := e_getvalue(0, e1, e3);
      Result := 655360 * (e3 + 1) + x50[e2];
      //showmessage(inttostr(result));
    end;
    33: //Draw a string.
    begin
      e3 := e_getvalue(0, e1, e3);
      e4 := e_getvalue(1, e1, e4);
      e5 := e_getvalue(2, e1, e5);
      //showmessage(inttostr(e5));
      i := 0;
      t1 := 0;
      p := @x50[e2];
      p1 := p;
      while byte(p^) > 0 do
      begin
        if byte(p^) = $2A then
        begin
          p^ := char(0);
          drawbig5shadowtext(p1, e3 - 22, e4 + 22 * i - 25, colcolor(e5 and $FF), colcolor((e5 and $FF00) shr 8));
          i := i + 1;
          p1 := p + 1;
        end;
        p := p + 1;
      end;
      drawbig5shadowtext(p1, e3 - 22, e4 + 22 - 25, colcolor(e5 and $FF), colcolor((e5 and $FF00) shr 8));
      SDL_UpdateRect2(screen, 0, 0, screen.w, screen.h);
      //waitanykey;
    end;
    34: //Draw a rectangle as background.
    begin
      e2 := e_getvalue(0, e1, e2);
      e3 := e_getvalue(1, e1, e3);
      e4 := e_getvalue(2, e1, e4);
      e5 := e_getvalue(3, e1, e5);
      e6 := e_getvalue(4, e1, e6);
      Drawrectangle(e2, e3, e4, e5, 0, colcolor($FF), e6 + 40);
      //SDL_UpdateRect2(screen,e1,e2,e3+1,e4+1);
    end;
    35: //Pause and wait a key.
    begin
      i := waitanykey;
      x50[e1] := i;
      case i of
        sdlk_left: x50[e1] := 154;
        sdlk_right: x50[e1] := 156;
        sdlk_up: x50[e1] := 158;
        sdlk_down: x50[e1] := 152;

      end;
      if (i < 266) and (i >= 256) then
        x50[e1] := i - 208;
    end;
    36: //Draw a string with background then pause, if the key pressed is 'Y' then jump=0.
    begin
      e3 := e_getvalue(0, e1, e3);
      e4 := e_getvalue(1, e1, e4);
      e5 := e_getvalue(2, e1, e5);
      //word := big5tounicode(@x50[e2]);
      //t1 := length(word);
      //drawtextwithrect(@word[1], e3, e4, t1 * 20 - 15, colcolor(e5 and $FF), colcolor((e5 and $FF00) shl 8));
      p := @x50[e2];
      i1 := 1;
      i2 := 0;
      t1 := 0;
      while byte(p^) > 0 do
      begin
        //showmessage('');
        if byte(p^) = $2A then
        begin
          if t1 > i2 then
            i2 := t1;
          t1 := 0;
          i1 := i1 + 1;
        end;
        if byte(p^) = $20 then
          t1 := t1 + 1;
        p := p + 1;
        t1 := t1 + 1;
      end;
      if t1 > i2 then
        i2 := t1;
      p := p - 1;
      if i1 = 0 then
        i1 := 1;
      if byte(p^) = $2A then
        i1 := i1 - 1;
      DrawRectangle(e3, e4, i2 * 10 + 25, i1 * 22 + 5, 0, colcolor(255), 30);
      p := @x50[e2];
      p1 := p;
      i := 0;
      while byte(p^) > 0 do
      begin
        if byte(p^) = $2A then
        begin
          p^ := char(0);
          drawbig5shadowtext(p1, e3 - 17, e4 + 22 * i + 2, colcolor(e5 and $FF), colcolor((e5 and $FF00) shr 8));
          i := i + 1;
          p1 := p + 1;
        end;
        p := p + 1;
      end;
      drawbig5shadowtext(p1, e3 - 17, e4 + 22 * i + 2, colcolor(e5 and $FF), colcolor((e5 and $FF00) shr 8));
      SDL_UpdateRect2(screen, 0, 0, screen.w, screen.h);
      i := waitanykey;
      if i = sdlk_y then
        x50[$7000] := 0
      else
        x50[$7000] := 1;
      //redraw;
    end;
    37: //Delay.
    begin
      e2 := e_getvalue(0, e1, e2);
      sdl_delay(e2);
    end;
    38: //Get a number randomly.
    begin
      e2 := e_getvalue(0, e1, e2);
      x50[e3] := random(e2);
    end;
    39: //Show a menu to select. The 40th instruct is too complicable, just use the 30th.
    begin
      e2 := e_getvalue(0, e1, e2);
      e5 := e_getvalue(1, e1, e5);
      e6 := e_getvalue(2, e1, e6);
      setlength(menustring, e2);
      setlength(menuengstring, 0);
      t1 := 0;
      for i := 0 to e2 - 1 do
      begin
        menustring[i] := big5tounicode(@x50[x50[e3 + i]]);
        i1 := length(PChar(@x50[x50[e3 + i]]));
        if i1 > t1 then
          t1 := i1;
      end;
      x50[e4] := commonmenu(e5, e6, t1 * 10 + 3, e2 - 1) + 1;
    end;
    40: //Show a menu to select. The 40th instruct is too complicable, just use the 30th.
    begin
      e2 := e_getvalue(0, e1, e2);
      e5 := e_getvalue(1, e1, e5);
      e6 := e_getvalue(2, e1, e6);
      setlength(menustring, e2);
      setlength(menuengstring, 0);
      i2 := 0;
      for i := 0 to e2 - 1 do
      begin
        menustring[i] := big5tounicode(@x50[x50[e3 + i]]);
        i1 := length(PChar(@x50[x50[e3 + i]]));
        if i1 > i2 then
          i2 := i1;
      end;
      t1 := (e1 shr 8) and $FF;
      if t1 = 0 then
        t1 := 5;
      //showmessage(inttostr(t1));
      x50[e4] := commonscrollmenu(e5, e6, i2 * 10 + 3, e2 - 1, t1) + 1;
    end;
    41: //Draw a picture.
    begin
      e3 := e_getvalue(0, e1, e3);
      e4 := e_getvalue(1, e1, e4);
      e5 := e_getvalue(2, e1, e5);
      case e2 of
        0:
        begin
          if where = 1 then
            DrawSPic(e5 div 2, e3, e4, 0, 0, screen.w, screen.h)
          else
            DrawMPic(e5 div 2, e3, e4);
        end;
        1: DrawHeadPic(e5, e3, e4);
        2:
        begin
          str := 'pic\' + IntToStr(e5) + '.png';
          display_img(@str[1], e3, e4);
        end;
      end;
      SDL_UpdateRect2(screen, 0, 0, screen.w, screen.h);
    end;
    42: //Change the poistion on world map.
    begin
      e2 := e_getvalue(0, e1, e2);
      e3 := e_getvalue(0, e1, e3);
      Mx := e3;
      My := e2;
    end;
    43: //Call another event.
    begin
      e2 := e_getvalue(0, e1, e2);
      e3 := e_getvalue(1, e1, e3);
      e4 := e_getvalue(2, e1, e4);
      e5 := e_getvalue(3, e1, e5);
      e6 := e_getvalue(4, e1, e6);
      x50[$7100] := e3;
      x50[$7101] := e4;
      x50[$7102] := e5;
      x50[$7103] := e6;
      if e2 = 213 then
      begin
        if e6 = 1 then
          e4 := 0 - e4;
        if e5 = 0 then
          instruct_2(e3, e4)
        else
          instruct_32(e3, e4);
      end
      else if e2 = 201 then
      begin
        NewTalk(e3, e4, e5, e6 mod 100, (e6 mod 100) div 10, e6 div 100, 0);
      end
      else if e2 = 352 then
      begin
        ShowTitle(e3, 1);
      end
      else if e2 = 210 then
      begin
        newTeammateList;
      end
      else if e2 = 209 then
      begin
        SetStarState(e3, e4);
      end
      else if e2 = 205 then
      begin
        x50[126] := Digging(e3, e4, e5, e6);
      end
      else if e2 = 228 then
      begin
        ShowTeamMate(e3, e4, e5);
      end
      else if e2 = 207 then
      begin
        ShowStarList;
      end
      else if e2 = 208 then
      begin
        x50[28929] := GetstarState(e3);
      end
      else if e2 = 236 then
      begin
        x50[$7000] := 1;
        if Lamp(e3, e4, e5, 0) then
          x50[$7000] := 0;
      end
      else if e2 = 217 then
      begin
        x50[$7000] := 1;
        if SpellPicture(e3, e4) then
          x50[$7000] := 0;
      end
      else if e2 = 219 then
      begin
        ReSort;
      end
      else if e2 = 223 then
      begin
        showmap;
      end
      else if e2 = 242 then
      begin
        RoleEnding(e3, e4, e5);
      end
      else if e2 = 243 then
      begin
        MissionList(e3);
      end
      else if e2 = 244 then
      begin
        SetMissionState(e3, e4);
      end
      else if e2 = 246 then
      begin
        x50[$7000] := 1;
        if WoodMan(e3) then
          x50[$7000] := 0;
      end
      else if e2 = 247 then
      begin
        showMR := True;
        if e3 = 1 then
          showMR := False;
      end
      else if e2 = 253 then
      begin
        bookList;
      end
      else if e2 = 254 then
      begin
        x50[e3] := GetStarAmount;
      end
      else if e2 = 255 then
      begin
        x50[e3] := DancerAfter90S;
      end
      else
        callevent(e2);
      //showmessage(inttostr(e2));
    end;
    44: //Play amination.
    begin
      e2 := e_getvalue(0, e1, e2);
      if e2 > 100 then
        e2 := e_getvalue(0, 1, e2);
      e3 := e_getvalue(1, e1, e3);
      e4 := e_getvalue(2, e1, e4);
      playActionAmination(e2, e3);
      playMagicAmination(e2, e4);
    end;
    45: //Show values.
    begin
      e2 := e_getvalue(0, e1, e2);
      case e2 of
        1: e2 := 0;
        2: e2 := 2;
        3: e2 := 4;
        4: e2 := 3;
        5: e2 := 1;
      end;
      showhurtvalue(e2);
    end;
    46: //Set effect layer.
    begin
      e2 := e_getvalue(0, e1, e2);
      e3 := e_getvalue(1, e1, e3);
      e4 := e_getvalue(2, e1, e4);
      e5 := e_getvalue(3, e1, e5);
      e6 := e_getvalue(4, e1, e6);
      for i1 := e2 to e2 + e4 - 1 do
        for i2 := e3 to e3 + e5 - 1 do
          bfield[4, i2, i1] := e6;
    end;
    47: //Here no need to re-set the pic.
    begin
    end;
    48: //Show some parameters.
    begin
      str := '';
      for i := e1 to e1 + e2 - 1 do
        str := str + 'x' + IntToStr(i) + '=' + IntToStr(x50[i]) + char(13) + char(10);
      //      messagebox(0, @str[1], 'KYS Windows', MB_OK);
    end;
    49: //In PE files, you can't call any procedure as your wish.
    begin
    end;
    50: //Enter name for items, magics and roles.
    begin
      e2 := e_getvalue(0, e1, e2);
      e3 := e_getvalue(1, e1, e3);
      e4 := e_getvalue(2, e1, e4);
      e5 := e_getvalue(3, e1, e5);

      case e2 of
        0: p := @Rrole[e3].Data[e4 div 2];
        1: p := @Ritem[e3].Data[e4 div 2];
        2: p := @Rmagic[e3].Data[e4 div 2];
        3: p := @Rscence[e3].Data[e4 div 2];
      end;
      //showmessage(inttostr(e4));
      word1 := big5tounicode(p);
      word1 := MidStr(word1, 2, length(word1) - 1);
      word := '請輸入名稱              ';
      word := InputBox('Enter name', word, word1);
      str := unicodetobig5(@word[1]);
      p1 := @str[1];
      for i := 0 to e5 - 1 do
        (p + i)^ := (p1 + i)^;
    end;
    51: //Enter a number.
    begin
      while (True) do
      begin
        word := InputBox('输入数量 ', '输入数量           ', '0');
        try
          i := StrToInt(word);
          break;
        except
          ShowMessage('输入错误，请重新输入！            ');
        end;
      end;
      x50[e1] := i;
    end;
    52: //Judge someone grasp some mggic.
    begin
      e2 := e_getvalue(0, e1, e2);
      e3 := e_getvalue(1, e1, e3);
      e4 := e_getvalue(2, e1, e4);
      x50[$7000] := 1;
      if (HaveMagic(e2, e3, e4) = True) then
        x50[$7000] := 0;
    end;
    60: //Call scripts.
    begin
      e2 := e_getvalue(0, e1, e2);
      e3 := e_getvalue(1, e1, e3);
      execscript(PChar('script\' + IntToStr(e2) + '.lua'), PChar('f' + IntToStr(e3)));
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
    if (RRole[person].Magic[i] = mnum) then
      if (RRole[person].MagLevel[i] >= lv) then
        Result := True;
end;

procedure StudyMagic(rnum, magicnum, newmagicnum, level, dismode: integer);
var
  i: integer;
  word: WideString;
begin
  for i := 0 to 9 do
  begin
    if (RRole[rnum].Magic[i] = magicnum) or (RRole[rnum].Magic[i] = newmagicnum) then
    begin
      if level <> -2 then
        RRole[rnum].Maglevel[i] := RRole[rnum].Maglevel[i] + level * 100;
      RRole[rnum].Magic[i] := newmagicnum;
      if RRole[rnum].MagLevel[i] > 999 then
        RRole[rnum].Maglevel[i] := 999;
      break;
    end;
  end;
  //if i = 10 then rrole[rnum].data[i+63] := magicnum;
  if dismode = 0 then
  begin
    DrawRectangle(CENTER_X - 75, 98, 145, 76, 0, colcolor(255), 30);
    word := ' 學會';
    drawshadowtext(@word[1], CENTER_X - 90, 125, colcolor(5), colcolor(7));
    drawbig5shadowtext(@rrole[rnum].Name, CENTER_X - 90, 100, colcolor($21), colcolor($23));
    drawbig5shadowtext(@Rmagic[newmagicnum].Name, CENTER_X - 90, 150, colcolor($64), colcolor($66));
    SDL_UpdateRect2(screen, 0, 0, screen.w, screen.h);
    waitanykey;
    redraw;
  end;
end;

procedure NewTalk(headnum, talknum, namenum, place, showhead, color, frame: integer);
var
  k, alen, newcolor, color1, color2, nh, nw, ch, c1, r1, n, namelen, i, t1, grp, idx, offset,
  len, i1, i2, face, c, nx, ny, hx, hy, hw, hh, x, y, w, h, cell, row: integer;
  np3, np, np1, np2, tp, p1, ap: PChar;
  actorarray, talkarray, namearray, name1, name2: array of byte;
  pword: array[0..1] of Uint16;
  {wd,} str: string;
  temp2: WideString;
  wd: string;
begin
  sstep := 0;
  pword[1] := 0;
  face := 4900;
  case color of
    0: color := 28515;
    1: color := 28421;
    2: color := 28435;
    3: color := 28563;
    4: color := 28466;
    5: color := 28450;
  end;
  color1 := color and $FF;
  color2 := (color shr 8) and $FF;
  x := 68;
  y := 320;
  w := 511;
  h := 109;
  nw := 86;
  nh := 28;
  hx := 68;
  hy := 244;
  hw := 57;
  hh := 72;
  nx := 129;
  ny := 288;
  if showhead = 1 then
    nx := x;

  row := 5;
  cell := 25;
  if place = 1 then
  begin
    hx := 522;
    nx := 431;
    if showhead = 1 then
      nx := x + w - nw;
  end;

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
  setlength(talkarray, len + 1);
  move(TDef[offset], talkarray[0], len);

  for i := 0 to len - 1 do
  begin
    talkarray[i] := talkarray[i] xor $FF;
    if talkarray[i] = 255 then
      talkarray[i] := 0;

  end;
  talkarray[i] := 0;
  tp := @talkarray[0];

  //read name
  //read name
  if namenum > 0 then
  begin
    namelen := 0;
    if namenum = 0 then
    begin
      offset := 0;
      namelen := TIdx[0];
    end
    else
    begin
      offset := TIdx[namenum - 1];
      namelen := TIdx[namenum] - offset;
    end;

    setlength(namearray, namelen + 1);
    move(TDef[offset], namearray[0], namelen);
    for i := 0 to namelen - 2 do
    begin
      namearray[i] := namearray[i] xor $FF;
      if namearray[i] = 255 then
        namearray[i] := 0;
    end;
    namearray[i] := 0;
    np := @namearray[0];
  end
  else if namenum = -2 then
  begin
    for i := 0 to length(rrole) - 1 do
    begin
      if Rrole[i].HeadNum = headnum then
      begin
        p1 := @Rrole[i].Name;
        namelen := 10;
        setlength(namearray, namelen);
        np := @namearray[0];
        for n := 0 to namelen - 1 do
        begin
          (np + n)^ := (p1 + n)^;
          // if (p1 + n)^ = char(0) then break;
        end;
        (np + n)^ := char(0);
        (np + n + 1)^ := char(0);
        break;
      end;
    end;
  end;

  p1 := @Rrole[0].Name;
  alen := length(p1) + 2;
  setlength(actorarray, alen);
  ap := @actorarray[0];
  for n := 0 to alen - 1 do
  begin
    (ap + n)^ := (p1 + n)^;
    if (p1 + n)^ = char(0) then
      break;
  end;
  (ap + n)^ := char($0);
  (ap + n + 1)^ := char(0);


  if alen = 4 then
  begin
    setlength(name1, 3);
    np1 := @name1[0];
    np1^ := ap^;
    (np1 + 1)^ := (ap + 1)^;
    (np1 + 2)^ := char(0);
    setlength(name2, 3);
    np2 := @name2[0];
    np2^ := ap^;
    (np2 + 1)^ := (ap + 1)^;
    (np2 + 2)^ := char(0);
    ;
  end
  else if alen = 6 then
  begin
    setlength(name1, 3);
    np1 := @name1[0];
    np1^ := ap^;
    (np1 + 1)^ := (ap + 1)^;
    (np1 + 2)^ := char(0);
    ;
    setlength(name2, 3);
    np2 := @name2[0];
    np2^ := (ap + 2)^;
    (np2 + 1)^ := (ap + 3)^;
    (np2 + 2)^ := char(0);
  end
  else if alen > 6 then
  begin
    if ((puint16(ap)^ = $6EAB) and ((puint16(ap + 2)^ = $63AE))) or
      ((puint16(ap)^ = $E8A6) and ((puint16(ap + 2)^ = $F9AA))) or ((puint16(ap)^ = $46AA) and
      ((puint16(ap + 2)^ = $E8A4))) or ((puint16(ap)^ = $4FA5) and ((puint16(ap + 2)^ = $B0AA))) or
      ((puint16(ap)^ = $7DBC) and ((puint16(ap + 2)^ = $65AE))) or ((puint16(ap)^ = $71A5) and
      ((puint16(ap + 2)^ = $A8B0))) or ((puint16(ap)^ = $D1BD) and ((puint16(ap + 2)^ = $AFB8))) or
      ((puint16(ap)^ = $71A5) and ((puint16(ap + 2)^ = $C5AA))) or ((puint16(ap)^ = $D3A4) and
      ((puint16(ap + 2)^ = $76A5))) or ((puint16(ap)^ = $BDA4) and ((puint16(ap + 2)^ = $5DAE))) or
      ((puint16(ap)^ = $DABC) and ((puint16(ap + 2)^ = $A7B6))) or ((puint16(ap)^ = $43AD) and
      ((puint16(ap + 2)^ = $DFAB))) or ((puint16(ap)^ = $71A5) and ((puint16(ap + 2)^ = $7BAE))) or
      ((puint16(ap)^ = $B9A7) and ((puint16(ap + 2)^ = $43C3))) or ((puint16(ap)^ = $61B0) and
      ((puint16(ap + 2)^ = $D5C1))) or ((puint16(ap)^ = $74A6) and ((puint16(ap + 2)^ = $E5A4))) or
      ((puint16(ap)^ = $DDA9) and ((puint16(ap + 2)^ = $5BB6))) then
    begin
      setlength(name1, 5);
      np1 := @name1[0];
      np1^ := ap^;
      (np1 + 1)^ := (ap + 1)^;
      (np1 + 2)^ := (ap + 2)^;
      (np1 + 3)^ := (ap + 3)^;
      (np1 + 4)^ := char(0);
      setlength(name2, alen + 1 - 4);
      np2 := @name2[0];
      for i := 0 to length(name2) - 1 do
        (np2 + i)^ := (ap + i + 4)^;
    end
    else
    begin
      setlength(name1, 3);
      np1 := @name1[0];
      np1^ := ap^;
      (np1 + 1)^ := (ap + 1)^;
      (np1 + 2)^ := char(0);
      setlength(name2, alen + 1 - 2);
      np2 := @name2[0];
      for i := 0 to length(name2) - 1 do
        (np2 + i)^ := (ap + i + 2)^;
    end;
  end;


  temp2 := big5tounicode(tp);

  str := unicodetoGBK(@temp2[1]);
  //showmessage(temp2);
  //showmessage(str);
  if SIMPLE = 1 then
    str := Traditional2Simplified(str);

  setlength(wd, 0);
  i := 0;
  while i < length(str) do
  begin
    setlength(wd, length(wd) + 1);
    wd[length(wd) - 1] := str[i];
    if (integer(str[i]) in [$81..$FE]) {and (integer(str[i + 1]) <> $7E)} then
    begin
      setlength(wd, length(wd) + 1);
      wd[length(wd) - 1] := str[i + 1];
      wd[length(wd) - 2] := str[i];
      Inc(i, 2);
      continue;
    end;
    if (integer(str[i]) in [$20..$7F]) then
    begin
      if str[i] = '^' then
      begin
        if (integer(str[i + 1]) in [$30..$39]) or (str[i + 1] = '^') then
        begin
          setlength(wd, length(wd) + 1);
          wd[length(wd) - 1] := str[i + 1];
          Inc(i, 2);
          continue;
        end;
      end
      else if (str[i] = '*') and (str[i + 1] = '*') then
      begin
        setlength(wd, length(wd) + 1);
        wd[length(wd) - 1] := str[i + 1];
        Inc(i, 2);
        continue;
      end
      else if (str[i] = '&') and (str[i + 1] = '&') then
      begin
        setlength(wd, length(wd) + 1);
        wd[length(wd) - 1] := str[i + 1];
        Inc(i, 2);
        continue;
      end
      else if (str[i] = '#') and (str[i + 1] = '#') then
      begin
        setlength(wd, length(wd) + 1);
        wd[length(wd) - 1] := str[i + 1];
        Inc(i, 2);
        continue;
      end
      else if (str[i] = '@') and (str[i + 1] = '@') then
      begin
        setlength(wd, length(wd) + 1);
        wd[length(wd) - 1] := str[i + 1];
        Inc(i, 2);
        continue;
      end
      else if (str[i] = '$') and (str[i + 1] = '$') then
      begin
        setlength(wd, length(wd) + 1);
        wd[length(wd) - 1] := str[i + 1];
        Inc(i, 2);
        continue;
      end
      else if (str[i] = '%') and (str[i + 1] = '%') then
      begin
        setlength(wd, length(wd) + 1);
        wd[length(wd) - 1] := str[i + 1];
        Inc(i, 2);
        continue;
      end;
      setlength(wd, length(wd) + 1);
      wd[length(wd) - 1] := char($A0 + (smallint(str[i]) - 32));
      wd[length(wd) - 2] := char($A3);
    end;
    Inc(i);
  end;
  tp := @wd[3];
  //showmessage(wd);

  ch := 0;

  while ((puint16(tp + ch))^ shl 8 <> 0) and ((puint16(tp + ch))^ shr 8 <> 0) do
  begin
    redraw;
    c1 := 0;
    r1 := 0;
    DrawRectangle(x, y, w, h, frame, colcolor($FF), 40);
    if (showhead = 0) or (headnum < 0) then
    begin
      DrawRectangle(hx, hy, hw, hh, frame, colcolor($FF), 40);
      if headnum = 0 then
      begin
        DrawHeadPic(RRole[0].HeadNum, hx, hy + 68);
      end
      else
      begin
        DrawHeadPic(headnum, hx, hy + 68);
      end;
    end;
    if namenum <> 0 then
    begin
      DrawRectangle(nx, ny, nw, nh, frame, colcolor($FF), 40);
      namelen := length(np);
      DrawBig5ShadowText(np, nx + 20 - namelen * 9 div 2, ny + 4, colcolor($63), colcolor($70));
    end;

    while r1 < row do
    begin
      pword[0] := (puint16(tp + ch))^;
      if (pword[0] shr 8 <> 0) and (pword[0] shl 8 <> 0) then
      begin
        ch := ch + 2;
        if (pword[0] and $FF) = $5E then //^^改变文字颜色
        begin
          case smallint((pword[0] and $FF00) shr 8) - $30 of
            0: newcolor := 28515;
            1: newcolor := 28421;
            2: newcolor := 28435;
            3: newcolor := 28563;
            4: newcolor := 28466;
            5: newcolor := 28450;
            64: newcolor := color;
            else
              newcolor := color;
          end;
          color1 := newcolor and $FF;
          color2 := (newcolor shr 8) and $FF;
        end
        else if pword[0] = $2323 then //## 延时
        begin
          sdl_delay(500);
        end
        else if pword[0] = $2A2A then //**换行
        begin
          if c1 > 0 then
            Inc(r1);
          c1 := 0;
        end
        else if pword[0] = $4040 then //@@等待击键
        begin
          SDL_UpdateRect2(screen, 0, 0, screen.w, screen.h);
          k := waitanykey;
          while (k = sdlk_right) or (k = sdlk_left) or (k = sdlk_up) or (k = sdlk_down) do
          begin
            k := waitanykey;
          end;
        end
        else if (pword[0] = $2626) or (pword[0] = $2525) or (pword[0] = $2424) then
        begin
          case pword[0] of
            $2626: np3 := ap; //&&显示姓名
            $2525: np3 := np2; //%%显示名
            $2424: np3 := np1; //$$显示姓
          end;
          i := 0;
          while (puint16(np3 + i)^ shr 8 <> 0) and (puint16(np3 + i)^ shl 8 <> 0) do
          begin
            pword[0] := puint16(np3 + i)^;
            i := i + 2;
            Drawbig5ShadowText(@pword[0], x - 14 + CHINESE_FONT_SIZE * c1, y + 4 +
              CHINESE_FONT_SIZE * r1, colcolor(color1), colcolor(color2));
            Inc(c1);
            if c1 = cell then
            begin
              c1 := 0;
              Inc(r1);
              if r1 = row then
              begin
                SDL_UpdateRect2(screen, 0, 0, screen.w, screen.h);
                k := waitanykey;
                while (k = sdlk_right) or (k = sdlk_left) or (k = sdlk_up) or (k = sdlk_down) do
                begin
                  k := waitanykey;
                end;
                c1 := 0;
                r1 := 0;
                redraw;
                DrawRectangle(x, y, w, h, frame, colcolor($FF), 40);
                if (showhead = 0) or (headnum < 0) then
                begin
                  DrawRectangle(hx, hy, hw, hh, frame, colcolor($FF), 40);
                  if headnum = 0 then
                  begin
                    DrawHeadPic(RRole[0].HeadNum, hx, hy + 68);
                  end
                  else
                  begin
                    DrawHeadPic(headnum, hx, hy + 68);
                  end;
                end;
                if namenum <> 0 then
                begin
                  DrawRectangle(nx, ny, nw, nh, frame, colcolor($FF), 40);
                  namelen := length(np);
                  DrawBIG5ShadowText(np, nx + 20 - namelen * 9 div 2, ny + 4, colcolor($63), colcolor($70));
                end;
              end;
            end;
          end;
        end
        else //显示文字
        begin
          DrawGBShadowText(@pword, x - 14 + CHINESE_FONT_SIZE * c1, y + 4 + CHINESE_FONT_SIZE *
            r1, colcolor(color1), colcolor(color2));
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
    SDL_UpdateRect2(screen, 0, 0, screen.w, screen.h);
    k := waitanykey;
    while (k = sdlk_right) or (k = sdlk_left) or (k = sdlk_up) or (k = sdlk_down) do
    begin
      k := waitanykey;
    end;
    if (pword[0] and $FF = 0) or (pword[0] and $FF00 = 0) then
      break;
  end;
  redraw;

  setlength(wd, 0);
  setlength(str, 0);
  setlength(temp2, 0);
end;

procedure ShowTitle(talknum, color: integer);
var
  newcolor, k, alen, x1, y1, ch, color1, color2, c1, r1, n, namelen, i, t1, grp, idx, offset,
  len, i1, i2, face, c, x, y, w, h, cell, row: integer;
  np3, np1, np2, tp, p1, ap: PChar;
  actorarray, name1, name2, talkarray: array of byte;
  pword: array[0..1] of Uint16;
  wd, str: string;
  temp2: WideString;
begin
  pword[1] := 0;
  face := 4900;
  case color of
    0: color := 28515;
    1: color := 28421;
    2: color := 28435;
    3: color := 28563;
    4: color := 28466;
    5: color := 28450;
  end;
  color1 := color and $FF;
  color2 := (color shr 8) and $FF;
  x := 0;
  y := 30;
  w := 640;
  h := 109;
  row := 5;
  cell := 25;

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
  setlength(talkarray, len + 1);
  move(TDef[offset], talkarray[0], len);

  for i := 0 to len - 1 do
  begin
    talkarray[i] := talkarray[i] xor $FF;
    if talkarray[i] = 255 then
      talkarray[i] := 0;
  end;
  talkarray[i] := 0;
  tp := @talkarray[0];

  if length(tp) > cell * 2 then
  begin
    x1 := 300 - cell * 10;
  end
  else
    x1 := 300 - length(tp) * 5;


  if ((length(tp) div 2) > cell * row) then
  begin
    y1 := y + (h div 2) - 50;
  end
  else
    y1 := y + (h div 2) - 10 - ((length(tp) div 2) div cell) * 10;

  p1 := @Rrole[0].Name;
  alen := length(p1) + 2;
  setlength(actorarray, alen);
  ap := @actorarray[0];
  for n := 0 to alen - 1 do
  begin
    (ap + n)^ := (p1 + n)^;
    if (p1 + n)^ = char(0) then
      break;
  end;
  (ap + n)^ := char($0);
  (ap + n + 1)^ := char(0);


  if alen = 4 then
  begin
    setlength(name1, 3);
    np1 := @name1[0];
    np1^ := ap^;
    (np1 + 1)^ := (ap + 1)^;
    (np1 + 2)^ := char(0);
    setlength(name2, 3);
    np2 := @name2[0];
    np2^ := ap^;
    (np2 + 1)^ := (ap + 1)^;
    (np2 + 2)^ := char(0);
    ;
  end
  else if alen = 6 then
  begin
    setlength(name1, 3);
    np1 := @name1[0];
    np1^ := ap^;
    (np1 + 1)^ := (ap + 1)^;
    (np1 + 2)^ := char(0);
    ;
    setlength(name2, 3);
    np2 := @name2[0];
    np2^ := (ap + 2)^;
    (np2 + 1)^ := (ap + 3)^;
    (np2 + 2)^ := char(0);
  end
  else if alen > 6 then
  begin
    if ((puint16(ap)^ = $6EAB) and ((puint16(ap + 2)^ = $63AE))) or
      ((puint16(ap)^ = $E8A6) and ((puint16(ap + 2)^ = $F9AA))) or ((puint16(ap)^ = $46AA) and
      ((puint16(ap + 2)^ = $E8A4))) or ((puint16(ap)^ = $4FA5) and ((puint16(ap + 2)^ = $B0AA))) or
      ((puint16(ap)^ = $7DBC) and ((puint16(ap + 2)^ = $65AE))) or ((puint16(ap)^ = $71A5) and
      ((puint16(ap + 2)^ = $A8B0))) or ((puint16(ap)^ = $D1BD) and ((puint16(ap + 2)^ = $AFB8))) or
      ((puint16(ap)^ = $71A5) and ((puint16(ap + 2)^ = $C5AA))) or ((puint16(ap)^ = $D3A4) and
      ((puint16(ap + 2)^ = $76A5))) or ((puint16(ap)^ = $BDA4) and ((puint16(ap + 2)^ = $5DAE))) or
      ((puint16(ap)^ = $DABC) and ((puint16(ap + 2)^ = $A7B6))) or ((puint16(ap)^ = $43AD) and
      ((puint16(ap + 2)^ = $DFAB))) or ((puint16(ap)^ = $71A5) and ((puint16(ap + 2)^ = $7BAE))) or
      ((puint16(ap)^ = $B9A7) and ((puint16(ap + 2)^ = $43C3))) or ((puint16(ap)^ = $61B0) and
      ((puint16(ap + 2)^ = $D5C1))) or ((puint16(ap)^ = $74A6) and ((puint16(ap + 2)^ = $E5A4))) or
      ((puint16(ap)^ = $DDA9) and ((puint16(ap + 2)^ = $5BB6))) then
    begin
      setlength(name1, 5);
      np1 := @name1[0];
      np1^ := ap^;
      (np1 + 1)^ := (ap + 1)^;
      (np1 + 2)^ := (ap + 2)^;
      (np1 + 3)^ := (ap + 3)^;
      (np1 + 4)^ := char(0);
      setlength(name2, alen + 1 - 4);
      np2 := @name2[0];
      for i := 0 to length(name2) - 1 do
        (np2 + i)^ := (ap + i + 4)^;
    end
    else
    begin
      setlength(name1, 3);
      np1 := @name1[0];
      np1^ := ap^;
      (np1 + 1)^ := (ap + 1)^;
      (np1 + 2)^ := char(0);
      setlength(name2, alen + 1 - 2);
      np2 := @name2[0];
      for i := 0 to length(name2) - 1 do
        (np2 + i)^ := (ap + i + 2)^;
    end;
  end;

  temp2 := big5tounicode(tp);

  str := unicodetoGBK(@temp2[1]);
  if SIMPLE = 1 then
    str := Traditional2Simplified(str);
  setlength(wd, 0);
  i := 0;
  while i < length(str) do
  begin
    setlength(wd, length(wd) + 1);
    wd[length(wd) - 1] := str[i];
    if (integer(str[i]) in [$81..$FE]) {and (integer(str[i + 1]) <> $7E)} then
    begin
      setlength(wd, length(wd) + 1);
      wd[length(wd) - 1] := str[i + 1];
      wd[length(wd) - 2] := str[i];
      Inc(i, 2);
      continue;
    end;
    if (integer(str[i]) in [$20..$7F]) then
    begin
      if str[i] = '^' then
      begin
        if (integer(str[i + 1]) in [$30..$39]) or (str[i + 1] = '^') then
        begin
          setlength(wd, length(wd) + 1);
          wd[length(wd) - 1] := str[i + 1];
          Inc(i, 2);
          continue;
        end;
      end
      else if (str[i] = '*') and (str[i + 1] = '*') then
      begin
        setlength(wd, length(wd) + 1);
        wd[length(wd) - 1] := str[i + 1];
        Inc(i, 2);
        continue;
      end
      else if (str[i] = '&') and (str[i + 1] = '&') then
      begin
        setlength(wd, length(wd) + 1);
        wd[length(wd) - 1] := str[i + 1];
        Inc(i, 2);
        continue;
      end
      else if (str[i] = '#') and (str[i + 1] = '#') then
      begin
        setlength(wd, length(wd) + 1);
        wd[length(wd) - 1] := str[i + 1];
        Inc(i, 2);
        continue;
      end
      else if (str[i] = '@') and (str[i + 1] = '@') then
      begin
        setlength(wd, length(wd) + 1);
        wd[length(wd) - 1] := str[i + 1];
        Inc(i, 2);
        continue;
      end
      else if (str[i] = '$') and (str[i + 1] = '$') then
      begin
        setlength(wd, length(wd) + 1);
        wd[length(wd) - 1] := str[i + 1];
        Inc(i, 2);
        continue;
      end
      else if (str[i] = '%') and (str[i + 1] = '%') then
      begin
        setlength(wd, length(wd) + 1);
        wd[length(wd) - 1] := str[i + 1];
        Inc(i, 2);
        continue;
      end;
      setlength(wd, length(wd) + 1);
      wd[length(wd) - 1] := char($A0 + (smallint(str[i]) - 32));
      wd[length(wd) - 2] := char($A3);
    end;
    Inc(i);
  end;
  tp := @wd[3];
  ch := 0;

  while ((puint16(tp + ch))^ shl 8 <> 0) and ((puint16(tp + ch))^ shr 8 <> 0) do
  begin
    redraw;
    c1 := 0;
    r1 := 0;
    DrawRectangleWithoutFrame(x, y, w, h, 0, 40);
    while r1 < row do
    begin
      pword[0] := (puint16(tp + ch))^;
      if (pword[0] shr 8 <> 0) and (pword[0] shl 8 <> 0) then
      begin
        ch := ch + 2;
        if (pword[0] and $FF) = $5E then //^^改变文字颜色
        begin
          case smallint((pword[0] and $FF00) shr 8) - $30 of
            0: newcolor := 28515;
            1: newcolor := 28421;
            2: newcolor := 28435;
            3: newcolor := 28563;
            4: newcolor := 28466;
            5: newcolor := 28450;
            64: newcolor := color;
            else
              newcolor := color;
          end;
          color1 := newcolor and $FF;
          color2 := (newcolor shl 8) and $FF;
        end
        else if pword[0] = $2323 then //## 延时
        begin
          sdl_delay(500);
        end
        else if pword[0] = $2A2A then //**换行
        begin
          if c1 > 0 then
          begin
            Inc(r1);
            DrawRectangleWithoutFrame(x, y + h + 11 * (r1 - 1) + 1, w, 10, 0, 40);
          end;
          c1 := 0;
        end
        else if pword[0] = $4040 then //@@等待击键
        begin
          SDL_UpdateRect2(screen, 0, 0, screen.w, screen.h);
          k := waitanykey;
          while (k = sdlk_right) or (k = sdlk_left) or (k = sdlk_up) or (k = sdlk_down) do
          begin
            k := waitanykey;
          end;
        end
        else if (pword[0] = $2626) or (pword[0] = $2525) or (pword[0] = $2424) then
        begin
          case pword[0] of
            $2626: np3 := ap; //&&显示姓名
            $2525: np3 := np2; //%%显示名
            $2424: np3 := np1; //$$显示姓
          end;
          i := 0;
          while (puint16(np3 + i)^ shr 8 <> 0) and (puint16(np3 + i)^ shl 8 <> 0) do
          begin
            pword[0] := puint16(np3 + i)^;
            i := i + 2;
            DrawBig5ShadowText(@pword[0], x1 + CHINESE_FONT_SIZE * c1, y1 + CHINESE_FONT_SIZE *
              r1, colcolor(color1), colcolor(color2));
            Inc(c1);
            if c1 = cell then
            begin
              c1 := 0;
              Inc(r1);
              if r1 = row then
              begin
                redraw;
                c1 := 0;
                r1 := 0;
                DrawRectangleWithoutFrame(x, y, w, h, 0, 40);
              end;
            end;
          end;
        end
        else //显示文字
        begin
          DrawGBShadowText(@pword, x1 + CHINESE_FONT_SIZE * c1, y1 + CHINESE_FONT_SIZE * r1,
            colcolor(color1), colcolor(color2));
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
    SDL_UpdateRect2(screen, 0, 0, screen.w, screen.h);
    k := waitanykey;
    while (k = sdlk_right) or (k = sdlk_left) or (k = sdlk_up) or (k = sdlk_down) do
    begin
      k := waitanykey;
    end;
    if (pword[0] and $FF = 0) or (pword[0] and $FF00 = 0) then
      break;
  end;
  redraw;
  //DrawBig5ShadowText(@pword, x1 + CHINESE_FONT_SIZE * c1, y1 + CHINESE_FONT_SIZE * r1, colcolor(color1), colcolor(color2));

  setlength(wd, 0);
  setlength(str, 0);
  setlength(temp2, 0);
end;

function Digging(beginPic, goal, shovel, restrict: integer): integer;
var
  p1, i, n, blankpic, holepic, goldpic, moneypic, boompic, x, y, position: integer;
  Surface, outcome: array[0..80] of integer;
  str, str1, goalstr: WideString;
begin
  position := 0;
  x := 235;
  y := 120;
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

  DrawRectangle(x, y, 200, 200, 0, colcolor($FF), 40);
  DrawRectangle(x, y - 30, 120, 30, 0, colcolor($FF), 40);
  DrawRectangle(x - 32, y - 30, 32, 230, 0, colcolor($FF), 40);

  for i := 0 to 81 - 1 do
  begin
    drawspic(blankpic div 2, (i mod 9) * 20 + 10 + x, (i div 9) * 20 + 10 + y, 0, 0, screen.w, screen.h);
    drawspic(outcome[i] div 2, (i mod 9) * 20 + 10 + x, (i div 9) * 20 + 10 + y, 0, 0, screen.w, screen.h);
  end;
  SDL_UpdateRect2(screen, 0, 0, screen.w, screen.h);
  sdl_delay(3000);
  redraw;

  showsurface(x, y, blankpic, surface);
  drawspic(shovel div 2, (position mod 9) * 20 + 10 + x, (position div 9) * 20 + 5 + y, 0, 0, screen.w, screen.h);
  goalstr := IntToStr(goal);
  str := Simplified2Traditional('目标:  X');
  setlength(str1, length(str));
  str1 := unicodetobig5(@str[1]);

  drawshadowtext(@str[1], x - 5, y - 25, colcolor($21), colcolor($23));
  drawspic(goldpic div 2, 55 + x, y - 25, 0, 0, screen.w, screen.h);
  drawshadowtext(@goalstr[1], x + 85, y - 25, colcolor($21), colcolor($23));
  for i := 0 to restrict - 1 do
    drawspic(shovel div 2, x - 27, y - 29 + (10 - i) * 20, 0, 0, screen.w, screen.h);

  SDL_UpdateRect2(screen, 0, 0, screen.w, screen.h);

  while (SDL_WaitEvent(@event) >= 0) do
  begin
    CheckBasicEvent;
    case event.type_ of
      SDL_KEYUP:
      begin
        if ((event.key.keysym.sym = sdlk_return) or (event.key.keysym.sym = sdlk_space)) then
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
        else if (event.key.keysym.sym = sdlk_right) then
        begin
          position := position + 1;
        end
        else if (event.key.keysym.sym = sdlk_left) then
        begin
          position := position - 1;
        end
        else if (event.key.keysym.sym = sdlk_up) then
        begin
          position := position - 9;
        end
        else if (event.key.keysym.sym = sdlk_down) then
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
        if (round(event.button.x / (RealScreen.w / screen.w)) >= x + 10) and
          (round(event.button.x / (RealScreen.w / screen.w)) <= x + 190) and
          (round(event.button.y / (RealScreen.h / screen.h)) >= y + 10) and
          (round(event.button.y / (RealScreen.h / screen.h)) <= y + 190) then
        begin
          p1 := position;
          position := (round(event.button.x / (RealScreen.w / screen.w)) - 10 - x) div 20 +
            ((round(event.button.y / (RealScreen.h / screen.h)) - 10 - y) div 20) * 9;
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
    redraw;
    showsurface(x, y, blankpic, surface);
    drawspic(shovel div 2, (position mod 9) * 20 + 10 + x, (position div 9) * 20 + 5 + y, 0, 0, screen.w, screen.h);
    drawshadowtext(@str[1], x - 5, y - 25, colcolor($21), colcolor($23));
    drawspic(goldpic div 2, 55 + x, y - 25, 0, 0, screen.w, screen.h);
    drawshadowtext(@goalstr[1], x + 85, y - 25, colcolor($21), colcolor($23));
    for i := 0 to restrict - 1 do
      drawspic(shovel div 2, x - 27, y - 29 + (10 - i) * 20, 0, 0, screen.w, screen.h);

    SDL_UpdateRect2(screen, 0, 0, screen.w, screen.h);
    if restrict <= 0 then
    begin
      sdl_delay(2000);
      waitanykey;
      break;
    end;
  end;
end;

procedure ShowSurface(x, y, blank: integer; surface: array of integer);
var
  i: integer;
begin

  DrawRectangle(x, y, 200, 200, 0, colcolor($FF), 40);
  DrawRectangle(x, y - 30, 120, 30, 0, colcolor($FF), 40);
  DrawRectangle(x - 32, y - 30, 32, 230, 0, colcolor($FF), 40);

  for i := 0 to 81 - 1 do
  begin
    drawspic(blank div 2, (i mod 9) * 20 + 10 + x, (i div 9) * 20 + 10 + y, 0, 0, screen.w, screen.h);
    drawspic(surface[i] div 2, (i mod 9) * 20 + 10 + x, (i div 9) * 20 + 10 + y, 0, 0, screen.w, screen.h);
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
    setlength(menustring, n);
    setlength(menuengstring, 0);
    setlength(mateList, n);
    if (teamlist[0] >= 0) and (teamlist[1] >= 0) and (teamlist[2] >= 0) and (teamlist[3] >= 0) and
      (teamlist[4] >= 0) and (teamlist[5] >= 0) then
      break;
    for i := 0 to 107 do
    begin
      if GetStarState(i) = 1 then
      begin
        setlength(menustring, n + 1);
        setlength(mateList, n + 1);
        temp := concat(' ', Star[i]);
        temp := concat(temp, ' ');
        menustring[n] := concat(temp, RoleName[i]);
        mateList[n] := i;
        n := n + 1;
      end;
    end;
    redraw;
    if length(matelist) > 0 then
    begin
      //drawrectangle(x, y, 200, n * 20 + 10, 0, colcolor($FF), 40);
      if length(mateList) > 20 then
        menu := commonscrollmenu(x, y, 200, length(mateList) - 1, 20)
      else
        menu := commonscrollmenu(x, y, 200, length(mateList) - 1, length(mateList));
      if menu = -1 then
        break;

      t := matelist[menu];
      //   if t >= 60 then
      //   begin
      //    if t = 109 then t := 114
      //    else t := t + 3;
      //   end;
      x50[$7100] := t;
      callevent(230);
      redraw;
      SDL_UpdateRect2(screen, 0, 0, 640, 440);
    end
    else
      break;
  end;
end;

function StarToRole(Starnum: integer): integer;
var
  head: array[0..107] of integer;
begin
  head[0] := rrole[0].HeadNum;
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

procedure newTeammatelist;
var
  xStar, yStar, xTeam, yTeam, xState, yState: integer;
  CurrentStar, CurrentTeam, page, numStar, state, headn, menup, menu: integer;
  StarMenu, TeamMenu: array of WideString;
  StateList: array of integer;
  i, n, menuid: integer;
  temp, str1, str2, statusstr: WideString;
  escape: bool;
  strs: array[0..21] of WideString;
  color1, color2: uint32;
begin

  xStar := 120;
  yStar := 15;
  CurrentStar := 0;
  CurrentTeam := 1;
  xTeam := 350;
  yTeam := 15;
  xState := 350;
  yState := 220;
  setlength(StarMenu, 18);
  setlength(TeamMenu, 6);
  setlength(StateList, 18);
  menuid := 0;
  escape := False;
  str1 := '此人尚未收录';
  str2 := '此人物为功能人物，无法加入';

  while (not escape) do
  begin
    page := CurrentStar div 18;
    numStar := CurrentStar - page * 18;

    for i := page * 18 to (page + 1) * 18 - 1 do
    begin
      n := i - (i div 18) * 18;
      if (i = CurrentStar) and (menuid = 0) then
        temp := ' >'
      else
        temp := '  ';
      temp := concat(temp, Star[i]);
      temp := concat(temp, ' ');
      StateList[n] := GetStarState(i);
      if StateList[n] > 0 then
      begin
        temp := concat(temp, RoleName[i]);
        if StateList[n] <> 2 then
          if length(temp) > 9 then
            temp := concat(temp, '  ', IntToStr(RRole[StarToRole(i)].Level))
          else
            temp := concat(temp, '    ', IntToStr(RRole[StarToRole(i)].Level));
      end
      else
        temp := concat(temp, '-- -- --');
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
        temp := concat(temp, Big5toUnicode(RRole[TeamList[i]].Name));
        if length(temp) > 5 then
          temp := concat(temp, '  ', IntToStr(RRole[TeamList[i]].Level))
        else
          temp := concat(temp, '    ', IntToStr(RRole[TeamList[i]].Level));
      end
      else
        temp := concat(temp, '  --------');
      TeamMenu[i] := temp;
    end;


    //{$IFDEF DARWIN}
    //RegionRect.x := xStar;
    //RegionRect.y := yStar;
    //RegionRect.w := 201;
    //RegionRect.h := 18 * 22 + 31;
    //{$ENDIF}
    redraw;
    //{$IFDEF DARWIN}
    //RegionRect.w := 0;
    //RegionRect.h := 0;
    //{$ENDIF}
    DrawRectangle(xStar, yStar, 200, 18 * 22 + 30, 0, colcolor(255), 30);
    for i := 0 to 17 do
      if (i = numStar) and (menuid = 0) then
      begin
        drawshadowtext(@StarMenu[i][1], xStar - 17, yStar + 2 + 22 * i, colcolor($64), colcolor($66));
      end
      else if StateList[i] = 2 then
      begin
        drawshadowtext(@StarMenu[i][1], xStar - 17, yStar + 2 + 22 * i, colcolor($80), colcolor($82));
      end
      else if StateList[i] > 2 then
      begin
        drawshadowtext(@StarMenu[i][1], xStar - 17, yStar + 2 + 22 * i, colcolor($20), colcolor($22));
      end
      else
        drawshadowtext(@StarMenu[i][1], xStar - 17, yStar + 2 + 22 * i, colcolor($5), colcolor($7));


    DrawRectangle(xTeam, yTeam, 200, 28, 0, colcolor(255), 30);
    drawshadowtext(@TeamMenu[0][1], xTeam - 17, yTeam + 2, colcolor($5), colcolor($7));

    DrawRectangle(xTeam, yTeam + 38, 200, 4 * 22 + 28, 0, colcolor(255), 30);
    for i := 1 to 5 do
      if (i = CurrentTeam) and (menuid = 1) then
      begin
        drawshadowtext(@TeamMenu[i][1], xTeam - 17, yTeam + 40 + 22 * (i - 1), colcolor($64), colcolor($66));
      end
      else
      begin
        drawshadowtext(@TeamMenu[i][1], xTeam - 17, yTeam + 40 + 22 * (i - 1), colcolor($5), colcolor($7));
      end;

    //显示当前人物的状态
    DrawRectangle(xState, yState, 200, 220, 0, colcolor(255), 30);
    if (menuid = 0) then
    begin
      state := getstarstate(CurrentStar);
      headn := StarToRole(CurrentStar);
    end
    else
    begin
      state := 3;
      headn := Teamlist[CurrentTeam];
    end;

    if ((state > 0) and (state <> 2)) then
    begin

      strs[0] := ' 等級';
      strs[1] := ' 生命';
      strs[2] := ' 內力';
      strs[3] := ' 攻擊';
      strs[4] := ' 防禦';
      strs[5] := ' 輕功';

      for i := 0 to 5 do
        drawshadowtext(@strs[i, 1], xState + 5, yState + 5 + 30 * i, colcolor($21), colcolor($23));

      statusstr := format('%4d', [Rrole[headn].Attack]);
      drawengshadowtext(@statusstr[1], xState + 65, yState + 95, colcolor(5), colcolor(7));
      statusstr := format('%4d', [Rrole[headn].Defence]);
      drawengshadowtext(@statusstr[1], xState + 65, yState + 125, colcolor(5), colcolor(7));
      statusstr := format('%4d', [Rrole[headn].Speed]);
      drawengshadowtext(@statusstr[1], xState + 65, yState + 155, colcolor(5), colcolor(7));

      statusstr := format('%4d', [Rrole[headn].Level]);
      drawengshadowtext(@statusstr[1], xState + 65, yState + 5, colcolor(5), colcolor(7));
      //生命值, 在受伤和中毒值不同时使用不同颜色
      case RRole[headn].Hurt of
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
      statusstr := format('%4d', [RRole[headn].CurrentHP]);
      drawengshadowtext(@statusstr[1], xState + 65, yState + 35, color1, color2);

      statusstr := '/';
      drawengshadowtext(@statusstr[1], xState + 105, yState + 35, colcolor($64), colcolor($66));

      case RRole[headn].Poision of
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
      statusstr := format('%4d', [RRole[headn].MaxHP]);
      drawengshadowtext(@statusstr[1], xState + 115, yState + 35, color1, color2);
      //内力, 依据内力性质使用颜色
      if rrole[headn].MPType = 0 then
      begin
        color1 := colcolor($50);
        color2 := colcolor($4E);
      end
      else if rrole[headn].MPType = 1 then
      begin
        color1 := colcolor($7);
        color2 := colcolor($5);
      end
      else
      begin
        color1 := colcolor($66);
        color2 := colcolor($63);
      end;
      statusstr := format('%4d/%4d', [RRole[headn].CurrentMP, RRole[headn].MaxMP]);
      drawengshadowtext(@statusstr[1], xState + 65, yState + 65, color1, color2);
    end;


    SDL_UpdateRect2(screen, xStar, yStar, 500, 450);

    while (SDL_WaitEvent(@event) >= 0) do
    begin
      CheckBasicEvent;
      case event.type_ of
        SDL_KEYDOWN:
        begin
          if (event.key.keysym.sym = sdlk_pagedown) then
          begin
            if menuid = 0 then
            begin
              if CurrentStar < 90 then
                CurrentStar := CurrentStar + 18;
              break;
            end;
          end;
          if (event.key.keysym.sym = sdlk_pageup) then
          begin
            if menuid = 0 then
            begin
              if CurrentStar > 17 then
                CurrentStar := CurrentStar - 18;
              break;
            end;
          end;
          if (event.key.keysym.sym = sdlk_down) then
          begin
            if menuid = 0 then
            begin
              if CurrentStar < 107 then
              begin
                CurrentStar := CurrentStar + 1;
              end;
              break;
            end
            else
            begin
              if CurrentTeam < 5 then
                CurrentTeam := CurrentTeam + 1;
              break;
            end;
          end;
          if (event.key.keysym.sym = sdlk_up) then
          begin
            if menuid = 0 then
            begin
              if CurrentStar > 0 then
              begin
                CurrentStar := CurrentStar - 1;
              end;
              break;
            end
            else
            begin
              if CurrentTeam > 1 then
                CurrentTeam := CurrentTeam - 1;
              break;
            end;
          end;
          if (event.key.keysym.sym = sdlk_left) then
          begin
            menuid := 0;
            break;
          end;
          if (event.key.keysym.sym = sdlk_right) then
          begin
            menuid := 1;
            break;
          end;
        end;
        SDL_KEYUP:
        begin
          if ((event.key.keysym.sym = sdlk_escape)) then
          begin
            escape := True;
            //{$IFDEF DARWIN}
            //RegionRect.x := xStar;
            //RegionRect.y := yStar;
            //RegionRect.w := 501;
            //RegionRect.h := 401;
            //{$ENDIF}
            redraw;
            //{$IFDEF DARWIN}
            //RegionRect.w := 0;
            //RegionRect.h := 0;
            //{$ENDIF}
            SDL_UpdateRect2(screen, xStar, yStar, 500, 400);
            break;
          end;
          if (event.key.keysym.sym = sdlk_return) or (event.key.keysym.sym = sdlk_space) then
          begin
            if menuid = 0 then
            begin
              if (StateList[numstar] = 1) then
              begin
                if (teamlist[5] < 0) then
                begin
                  x50[$7100] := CurrentStar;
                  callevent(230);
                end;
              end;
              break;
            end;
            if menuid = 1 then
            begin
              for i := 0 to 99 do
                if leavelist[i] = TeamList[CurrentTeam] then
                begin
                  callevent(BEGIN_LEAVE_EVENT + i * 2);
                  break;
                end;
            end;
            break;
          end;
        end;
        SDL_MOUSEBUTTONUP:
        begin
          if (event.button.button = sdl_button_right) and (where <= 2) then
          begin
            escape := True;
            //{$IFDEF DARWIN}
            //RegionRect.x := xStar;
            //RegionRect.y := yStar;
            //RegionRect.w := 501;
            //RegionRect.h := 401;
            //{$ENDIF}
            redraw;
            //{$IFDEF DARWIN}
            //RegionRect.w := 0;
            //RegionRect.h := 0;
            //{$ENDIF}
            SDL_UpdateRect2(screen, xStar, yStar, 500, 400);
            break;
          end;
          if (event.button.button = sdl_button_left) then
          begin
            if menuid = 0 then
            begin
              if (StateList[numstar] = 1) then
              begin
                if (teamlist[5] < 0) then
                begin
                  x50[$7100] := CurrentStar;
                  callevent(230);
                end;
              end;
              break;
            end;
            if menuid = 1 then
            begin
              for i := 0 to 99 do
                if leavelist[i] = TeamList[CurrentTeam] then
                begin
                  callevent(BEGIN_LEAVE_EVENT + i * 2);
                  break;
                end;
            end;
            break;
          end;
          if (event.button.button = sdl_button_wheeldown) then
          begin
            if menuid = 0 then
            begin
              if CurrentStar < 107 then
              begin
                CurrentStar := CurrentStar + 1;
              end;
              break;
            end
            else
            begin
              if CurrentTeam < 5 then
                CurrentTeam := CurrentTeam + 1;
              break;
            end;
          end;
          if (event.button.button = sdl_button_wheelup) then
          begin
            if menuid = 0 then
            begin
              if CurrentStar > 0 then
              begin
                CurrentStar := CurrentStar - 1;
              end;
              break;
            end
            else
            begin
              if CurrentTeam > 1 then
                CurrentTeam := CurrentTeam - 1;
              break;
            end;
          end;
        end;
        SDL_MOUSEMOTION:
        begin
          if (round(event.button.x / (RealScreen.w / screen.w)) >= xStar) and
            (round(event.button.x / (RealScreen.w / screen.w)) < xStar + 200) and
            (round(event.button.y / (RealScreen.h / screen.h)) > yStar) and
            (round(event.button.y / (RealScreen.h / screen.h)) < yStar + 18 * 22 + 29) then
          begin
            menuid := 0;
            menup := CurrentStar;
            menu := (round(event.button.y / (RealScreen.h / screen.h)) - yStar - 2) div 22;
            if menu > 17 then
              menu := 17;
            if menu < 0 then
              menu := 0;
            CurrentStar := menu + CurrentStar div 18 * 18;
            break;
          end;
          if (round(event.button.x / (RealScreen.w / screen.w)) >= xTeam) and
            (round(event.button.x / (RealScreen.w / screen.w)) < xTeam + 200) and
            (round(event.button.y / (RealScreen.h / screen.h)) > yTeam + 38) and
            (round(event.button.y / (RealScreen.h / screen.h)) < yTeam + 5 * 22 + 29) then
          begin
            menuid := 1;
            menup := CurrentTeam;
            menu := (round(event.button.y / (RealScreen.h / screen.h)) - yTeam - 40) div 22 + 1;
            if menu > 5 then
              menu := 5;
            if menu < 0 then
              menu := 0;
            CurrentTeam := menu;
            break;
          end;
        end;
      end;
    end;
  end;
  event.key.keysym.sym := 0;
  event.button.button := 0;
  SDL_EnableKeyRepeat(30, 30);
end;

procedure SetStarState(position, Value: integer);
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
    Rrole[n].Data[position div 2] := (Rrole[n].Data[position div 2] and $FF00) or Value;
  end
  else
  begin
    Rrole[n].Data[position div 2] := (Rrole[n].Data[position div 2] and $FF) or (Value shl 8);
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
  DrawRectangleWithoutFrame(0, 40, screen.w, 150, 0, 40);

  hx := 263 - Count * 29;
  for i := 1 to Count do
  begin
    DrawRectangle(hx + 57 * i, hy, hw, hh, 0, colcolor($FF), 0);
    DrawHeadPic(headnum, hx + 57 * i, hy + 68);
  end;

  str1 := concat(Star[position], ' ');
  str2 := concat(RoleName[position], ' 成為夥伴');
  str := concat(str1, str2);
  l := length(str);
  DrawShadowText(@str[1], 310 - 20 * (l div 2), 140, colcolor($5), colcolor($8));
  SDL_UpdateRect2(screen, 0, 0, screen.w, screen.h);
  waitanykey;
  redraw;
end;

function ReSetName(t, inum, newnamenum: integer): integer;
var
  NewName: string;
  offset, len, i, idx, grp: integer;
  p, np: PChar;
  talkarray: array of byte;
begin

  idx := fileopen('resource\talk.idx', fmopenread);
  grp := fileopen('resource\talk.grp', fmopenread);
  if newnamenum = 0 then
  begin
    offset := 0;
    fileread(idx, len, 4);
  end
  else
  begin
    fileseek(idx, (newnamenum - 1) * 4, 0);
    fileread(idx, offset, 4);
    fileread(idx, len, 4);
  end;
  len := (len - offset);
  setlength(talkarray, len + 1);
  fileseek(grp, offset, 0);
  fileread(grp, talkarray[0], len);
  fileclose(idx);
  fileclose(grp);
  for i := 0 to len - 1 do
  begin
    talkarray[i] := talkarray[i] xor $FF;
    if (talkarray[i] = $2A) then
      talkarray[i] := 0;
    if (talkarray[i] = $FF) then
      talkarray[i] := 0;
  end;
  talkarray[len] := 0;
  np := @talkarray[0];


  case t of
    0: p := @RRole[inum].Name; //人物
    1: p := @RItem[inum].Name1; //物品
    2: p := @RScence[inum].Name; //场景
    3: p := @RMagic[inum].Name; //武功
    4: p := @RItem[inum].Introduction; //物品说明
  end;

  for i := 0 to len - 1 do
  begin
    (p + i)^ := (np + i)^;
  end;
  (p + i)^ := char(0);

  Result := 0;

end;

procedure JmpScence(snum, y, x: integer);
begin
  CurScence := snum;
  if x = -2 then
  begin
    x := RScence[CurScence].EntranceX;
  end;
  if y = -2 then
  begin
    y := RScence[CurScence].EntranceY;
  end;
  Cx := x + Cx - Sx;
  Cy := y + Cy - Sy;
  Sx := x;
  Sy := y;
  instruct_14;
  time := 30 + rrole[0].CurrentMP div 100;
  InitialScence;
  Drawscence;
  instruct_13;
  ShowScenceName(CurScence);
  CheckEvent3;
end;

function CommonScrollMenu_starlist(x, y, w, max, maxshow: integer): integer;
var
  menu, menup, menutop: integer;
  head: array[0..107] of integer;
  headn, talkn, state: integer;

begin
  head[0] := rrole[0].HeadNum;
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

  SDL_EnableKeyRepeat(20, 100);
  menu := 0;
  menutop := 0;
  //SDL_EnableKeyRepeat(0,10);
  //DrawMMap;
  showcommonscrollMenu_starlist(x, y, w, max, maxshow, menu, menutop, head[menu]);


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
          showcommonscrollMenu_starlist(x, y, w, max, maxshow, menu, menutop, head[menu]);
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
          showcommonscrollMenu_starlist(x, y, w, max, maxshow, menu, menutop, head[menu]);
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
          showcommonscrollMenu_starlist(x, y, w, max, maxshow, menu, menutop, head[menu]);
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
          showcommonscrollMenu_starlist(x, y, w, max, maxshow, menu, menutop, head[menu]);
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
        //if (event.key.keysym.sym = sdlk_return) or (event.key.keysym.sym = sdlk_space) then
        //begin
        //  result := menu;
        //  Redraw;
        //  SDL_UpdateRect2(screen, 0, 0, screen.w, screen.h);
        //  break;
        //end;
      end;
      SDL_MOUSEBUTTONUP:
      begin
        if (event.button.button = sdl_button_right) and (where <= 2) then
        begin
          Result := -1;
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
          SDL_UpdateRect2(screen, x, y, w + 1, maxshow * 22 + 29);
          break;
        end;
        if (event.button.button = sdl_button_left) then
        begin
          if menu > -1 then
          begin
            Result := menu;
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
            SDL_UpdateRect2(screen, x, y, w + 1, maxshow * 22 + 29);
            break;
          end;
        end;
        if (event.button.button = sdl_button_wheeldown) then
        begin
          menu := menu + 20;
          menutop := menutop + 20;
          if menu > max then
            menu := 107;
          if menutop > 86 then
            menutop := 86;
          showcommonscrollMenu_starlist(x, y, w, max, maxshow, menu, menutop, head[menu]);
          //SDL_UpdateRect2(screen, x, y, w + 1, maxshow * 22 + 29);
        end;
        if (event.button.button = sdl_button_wheelup) then
        begin
          menu := menu - 20;
          menutop := menutop - 20;
          if menu < 0 then
            menu := 0;
          if menutop < 0 then
            menutop := 0;
          showcommonscrollMenu_starlist(x, y, w, max, maxshow, menu, menutop, head[menu]);
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
            showcommonscrollMenu_starlist(x, y, w, max, maxshow, menu, menutop, head[menu]);
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

procedure ShowCommonScrollMenu_starlist(x, y, w, max, maxshow, menu, menutop, headn: integer);
var
  i, p: integer;
  hx, hy, hw, hh, Count, len, idx, grp, r1, c1, offset, state: integer;
  str1, str2: WideString;
  talkarray: array of byte;
  pword: array[0..1] of uint16;
  str: PChar;
  statusstr: WideString;
  strs: array[0..21] of WideString;
  color1, color2: uint32;
begin

  //showmessage(inttostr(menu));
  if max + 1 < maxshow then
    maxshow := max + 1;
  //{$IFDEF DARWIN}
  RegionRect.x := x;
  RegionRect.y := y;
  RegionRect.w := 600;
  RegionRect.h := maxshow * 22 + 9;
  //{$ENDIF}
  redraw;
  //{$IFDEF DARWIN}
  RegionRect.w := 0;
  RegionRect.h := 0;
  //{$ENDIF}
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

  state := GetStarState(menu);
  if (state > 0) then
  begin
    //绘制人物星位、姓名、头像
    Count := 1;
    if (menu = 95) or (menu = 107) then
      Count := 4;
    if menu = 105 then
      Count := 6;
    hx := 383 - Count * 29;
    hy := 55;
    hw := 57;
    hh := 72;
    i := 0;
    DrawRectangle(240, y, 379, maxshow * 22 + 6, 0, colcolor(255), 30);
    str1 := concat(Star[menu], ' ');
    str2 := concat(str1, RoleName[menu]);
    len := length(str2);
    DrawShadowText(@str2[1], 440 - 20 * (len div 2), 140, colcolor($5), colcolor($8));
    for i := 0 to Count - 1 do
    begin
      DrawRectangle(hx + 57 * (i + 1), hy, hw, hh, 0, colcolor($FF), 0);
      DrawHeadPic(headn + i, hx + 57 * (i + 1), hy + 68);
    end;

    //简介
    idx := fileopen('resource\talk.idx', fmopenread);
    grp := fileopen('resource\talk.grp', fmopenread);
    fileseek(idx, (menu + 600 - 1) * 4, 0);
    fileread(idx, offset, 4);
    fileread(idx, len, 4);
    len := (len - offset);
    setlength(talkarray, len + 1);
    fileseek(grp, offset, 0);
    fileread(grp, talkarray[0], len);
    fileclose(idx);
    fileclose(grp);
    pword[1] := 0;
    for i := 0 to len - 1 do
    begin
      talkarray[i] := talkarray[i] xor $FF;
      if (talkarray[i] = $2A) then
        talkarray[i] := 0;
      if (talkarray[i] = $FF) then
        talkarray[i] := 0;
    end;
    talkarray[len] := 0;
    str := @talkarray[0];
    i := 0;
    r1 := 0;
    c1 := 0;
    while i < len do
    begin
      pword[0] := puint16(str + i)^;
      i := i + 2;
      DrawBig5ShadowText(@pword[0], 230 + CHINESE_FONT_SIZE * c1, 170 + CHINESE_FONT_SIZE *
        r1, colcolor(5), colcolor(7));
      Inc(c1);
      if c1 = 18 then
      begin
        c1 := 0;
        Inc(r1);
      end;
    end;

    //特技、功能说明
    idx := fileopen('resource\talk.idx', fmopenread);
    grp := fileopen('resource\talk.grp', fmopenread);
    fileseek(idx, (menu + 600 - 1) * 4, 0);
    fileread(idx, offset, 4);
    fileread(idx, len, 4);
    len := (len - offset);
    setlength(talkarray, len + 1);
    fileseek(grp, offset, 0);
    fileread(grp, talkarray[0], len);
    fileclose(idx);
    fileclose(grp);
    pword[1] := 0;
    for i := 0 to len - 1 do
    begin
      talkarray[i] := talkarray[i] xor $FF;
      if (talkarray[i] = $2A) then
        talkarray[i] := 0;
      if (talkarray[i] = $FF) then
        talkarray[i] := 0;
    end;
    talkarray[len] := 0;
    str := @talkarray[0];
    i := 0;
    r1 := 0;
    c1 := 0;
    while i < len do
    begin
      pword[0] := puint16(str + i)^;
      i := i + 2;
      DrawBig5ShadowText(@pword[0], 230 + CHINESE_FONT_SIZE * c1, 345 + CHINESE_FONT_SIZE *
        r1, colcolor(5), colcolor(7));
      Inc(c1);
      if c1 = 18 then
      begin
        c1 := 0;
        Inc(r1);
      end;
    end;

    //状态
    {if (state <> 2) then
    begin
      strs[0] := ' 等級';
      strs[1] := ' 生命';
      strs[2] := ' 內力';
      strs[3] := ' 攻擊';
      strs[4] := ' 防禦';
      strs[5] := ' 輕功';

      for i := 0 to 2 do
        drawshadowtext(@strs[i, 1], 270, 365 + 21 * i, colcolor($21), colcolor($23));
      for i := 3 to 5 do
        drawshadowtext(@strs[i, 1], 440, 365 + 21 * (i - 3), colcolor($21), colcolor($23));

      statusstr := format('%4d', [Rrole[headn].Attack]);
      drawengshadowtext(@statusstr[1], 500, 365 + 21 * 0, colcolor(5), colcolor(7));
      statusstr := format('%4d', [Rrole[headn].Defence]);
      drawengshadowtext(@statusstr[1], 500, 365 + 21 * 1, colcolor(5), colcolor(7));
      statusstr := format('%4d', [Rrole[headn].Speed]);
      drawengshadowtext(@statusstr[1], 500, 365 + 21 * 2, colcolor(5), colcolor(7));

      statusstr := format('%4d', [Rrole[headn].Level]);
      drawengshadowtext(@statusstr[1], 330, 365, colcolor(5), colcolor(7));
      //生命值, 在受伤和中毒值不同时使用不同颜色
      case RRole[headn].Hurt of
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
      statusstr := format('%4d', [RRole[headn].CurrentHP]);
      drawengshadowtext(@statusstr[1], 330, 386, color1, color2);

      statusstr := '/';
      drawengshadowtext(@statusstr[1], 370, 386, colcolor($64), colcolor($66));

      case RRole[headn].Poision of
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
      statusstr := format('%4d', [RRole[headn].MaxHP]);
      drawengshadowtext(@statusstr[1], 380, 386, color1, color2);
      //内力, 依据内力性质使用颜色
      if rrole[headn].MPType = 0 then
      begin
        color1 := colcolor($50);
        color2 := colcolor($4E);
      end
      else if rrole[headn].MPType = 1 then
      begin
        color1 := colcolor($7);
        color2 := colcolor($5);
      end
      else
      begin
        color1 := colcolor($66);
        color2 := colcolor($63);
      end;
      statusstr := format('%4d/%4d', [RRole[headn].CurrentMP, RRole[headn].MaxMP]);
      drawengshadowtext(@statusstr[1], 330, 407, color1, color2);
    end;}
    
  end;
  SDL_UpdateRect2(screen, x, y, 600, maxshow * 22 + 8);
end;

procedure ShowStarList;
var
  hx, hy, hw, hh, headnum, Count, n, i, c1, r1, offset, idx, len, grp: integer;
  str: PChar;
  pword: array[0..1] of uint16;
  talkarray: array of byte;
  state: array[0..107] of integer;
  str1, str2: WideString;
  head: array[0..107] of integer;
begin
  setlength(menustring, 108);
  setlength(menuengstring, 0);
  for i := 0 to 107 do
  begin
    state[i] := GetStarState(i);
    menustring[i] := concat(' ', star[i]);
    if state[i] <> 0 then
    begin
      menustring[i] := concat(menustring[i], ' ');
      menustring[i] := concat(menustring[i], rolename[i]);
    end;
  end;
  CommonScrollMenu_starlist(20, 15, 200, 108 - 1, 20);
  setlength(menustring, 0);
end;

function Lamp(c, beginpic, whitecount, chance: integer): boolean;
var
  x, y, r, temp, i, pic2, pic3, menu: integer;
begin
  r := c;
  x := (screen.w - (c * 50)) div 2;
  y := (screen.h - (r * 50)) div 2;
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
  drawrectanglewithoutframe(x - 10, y - 10, c * 50 + 20, r * 50 + 20, 0, 60);
  for i := 0 to c * r - 1 do
  begin
    drawSpic(gamearray[0][i], x + (i mod c) * 50, y + (i div c) * 50, x + (i mod c) * 50, y + (i div c) * 50, 51, 51);
    if menu = i then
      drawSpic(pic3, x + (menu mod c) * 50, y + (menu div c) * 50, x + (i mod c) * 50, y + (i div c) * 50, 51, 51);
  end;
  SDL_UpdateRect2(screen, 0, 0, screen.w, screen.h);
  while (SDL_WaitEvent(@event) >= 0) do
  begin
    CheckBasicEvent;
    case event.type_ of
      SDL_MOUSEMOTION:
      begin
        if (round(event.button.x / (RealScreen.w / screen.w)) > x) and
          (round(event.button.x / (RealScreen.w / screen.w)) < x + 50 * c) and
          (round(event.button.y / (RealScreen.h / screen.h)) > y) and
          (round(event.button.y / (RealScreen.h / screen.h)) < y + 50 * r) then

          menu := ((round(event.button.x / (RealScreen.w / screen.w)) - x) div 50) +
            (((round(event.button.y / (RealScreen.h / screen.h)) - y) div 50) * c);
      end;
      SDL_MOUSEBUTTONUP:
      begin
        if event.button.button = sdl_button_left then
        begin
          if (round(event.button.x / (RealScreen.w / screen.w)) > x) and
            (round(event.button.x / (RealScreen.w / screen.w)) < x + 50 * c) and
            (round(event.button.y / (RealScreen.h / screen.h)) > y) and
            (round(event.button.y / (RealScreen.h / screen.h)) < y + 50 * r) then

            menu := ((round(event.button.x / (RealScreen.w / screen.w)) - x) div 50) +
              (((round(event.button.y / (RealScreen.h / screen.h)) - y) div 50) * c);
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
        if event.key.keysym.sym = sdlk_escape then
        begin
          Result := False;
          break;
        end;
        if event.key.keysym.sym = sdlk_up then
          menu := menu - c;
        if event.key.keysym.sym = sdlk_down then
          menu := menu + c;
        if event.key.keysym.sym = sdlk_left then
          menu := menu - 1;
        if event.key.keysym.sym = sdlk_right then
          menu := menu + 1;
        if menu < 0 then
          menu := menu + c * r;
        if menu > c * r - 1 then
          menu := menu - c * r;
        if (event.key.keysym.sym = sdlk_return) or (event.key.keysym.sym = sdlk_space) then
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
      drawSpic(gamearray[0][i], x + (i mod c) * 50, y + (i div c) * 50, x + (i mod c) * 50,
        y + (i div c) * 50, 51, 51);
      if menu = i then
        drawSpic(pic3, x + (menu mod c) * 50, y + (menu div c) * 50, x + (i mod c) * 50, y + (i div c) * 50, 51, 51);
    end;
    SDL_UpdateRect2(screen, 0, 0, screen.w, screen.h);
    Result := True;
    for i := 0 to c * r - 1 do
    begin
      if gamearray[0][i] = pic2 then
        Result := False;
    end;
    if Result = True then
    begin
      sdl_delay(1000);
      break;
    end;
  end;
  setlength(gamearray, 0);
end;

procedure SetAttribute(rnum, selecttype, modlevel, minlevel, maxlevel: integer);
var
  lv, i, sum, leveltype, magictype, magicnum, magiclevel: integer;
  attackadd, speedadd, defenceadd, HPadd, MPadd: integer;
begin
  if minlevel = 0 then
    minlevel := 1;
  if maxlevel = 0 then
    maxlevel := 60;

  leveltype := selecttype mod 10;
  magictype := trunc(selecttype / 10);

  case leveltype of
    0: lv := rrole[0].Level;
    1:
    begin
      lv := rrole[0].Level;
      for i := 1 to 5 do
      begin
        if teamlist[i] > 0 then
          if rrole[teamlist[i]].Level > lv then
            lv := rrole[teamlist[i]].Level;
      end;
    end;
    2:
    begin
      lv := rrole[0].Level;
      for i := 1 to 5 do
      begin
        if teamlist[i] > 0 then
          if rrole[teamlist[i]].Level < lv then
            lv := rrole[teamlist[i]].Level;
      end;
    end;
    3:
    begin
      sum := rrole[0].Level;
      lv := rrole[0].Level;
      for i := 1 to 5 do
      begin
        if teamlist[i] > 0 then
        begin
          sum := sum + rrole[teamlist[i]].Level;
          if rrole[teamlist[i]].Level < lv then
            lv := rrole[teamlist[i]].Level;
        end
        else
          break;
      end;
      if i > 1 then
      begin
        sum := sum - lv;
        lv := sum div (i - 1);
      end;
    end;
  end;
  lv := lv + modlevel;
  if lv > maxlevel then
    lv := maxlevel;
  if lv < minlevel then
    lv := minlevel;


  rrole[rnum].Level := lv;
  //rrole[rnum].MaxHP := 50 + (rrole[rnum].IncLife + 1) * 3 * (lv - 1);
  rrole[rnum].MaxHP := 50 + trunc((rrole[rnum].IncLife + 1) * lv * logN(4, lv));
  rrole[rnum].CurrentHP := rrole[rnum].MaxHP;

  //rrole[rnum].MaxMP := 40 + (rrole[rnum].AddMP + 1) * 3 * (lv - 1);
  rrole[rnum].MaxMP := 40 + trunc((rrole[rnum].AddMP + 1) * lv * logN(4, lv));
  rrole[rnum].CurrentMP := rrole[rnum].MaxMP;

  //rrole[rnum].Attack := 30 + (rrole[rnum].AddAtk + 1) * (lv - 1);
  //rrole[rnum].Speed := 30 + (rrole[rnum].AddSpeed+1) * (lv - 1);
  //rrole[rnum].Defence := 30 + (rrole[rnum].AddDef + 1) * (lv - 1);

  rrole[rnum].Attack := 30 + trunc((rrole[rnum].AddAtk + 1) * (lv - 1) * logN(10, lv));
  rrole[rnum].Defence := 30 + trunc((rrole[rnum].AddDef + 1) * (lv - 1) * logN(10, lv));

  rrole[rnum].Speed := 30 + trunc((rrole[rnum].AddSpeed) * (lv) * logN(20, lv));


  //根据武功的个数对五维进行加成
  //0-不考虑; 1-拳；2-剑；3-刀; 4-特；5-暗
  if (magictype > 0) and (magictype < 6) then
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
    end;

    for magicnum := 1 to 10 do
    begin
      if rrole[rnum].Magic[magicnum] <= 0 then
        break;
      magiclevel := trunc(rrole[rnum].MagLevel[magicnum] div 100) + 1;
      rrole[rnum].MaxHP := rrole[rnum].MaxHP + HPadd * magiclevel;
      rrole[rnum].currentHP := rrole[rnum].CurrentHP + HPadd * magiclevel;
      rrole[rnum].MaxMP := rrole[rnum].MaxMP + MPadd * magiclevel;
      rrole[rnum].currentMP := rrole[rnum].CurrentMP + MPadd * magiclevel;
      rrole[rnum].Attack := rrole[rnum].Attack + attackadd * magiclevel;
      rrole[rnum].Speed := rrole[rnum].Speed + trunc((speedadd + 0.5) * magiclevel);
      rrole[rnum].Defence := rrole[rnum].Defence + defenceadd * magiclevel;

    end;
  end;


  //第一项武功级别随等级调整，用于敌人，十位数字7
  if magictype = 7 then
  begin
    magiclevel := lv * 20;
    if magiclevel > 999 then
      magiclevel := 999;
    rrole[rnum].MagLevel[0] := magiclevel;
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
    Result := Rrole[n].Data[p] shr 8;
  end;
end;

procedure MissionList(mode: integer);
var
  x, y, i, n, len, t, menu, Count, tip: integer;
  //StarList: array of widestring;
  MissionList: array of integer;
  temp: WideString;
  str: WideString;
  missionTip: array[0..2] of WideString;
begin
  x := 70;
  y := 15;
  n := 0;
  menu := 0;
  setlength(menustring, n);
  setlength(menuengstring, 0);
  setlength(MissionList, n);
  missiontip[0] := '未开启';
  missiontip[1] := '未完成';
  missiontip[2] := '已完成';
  for i := 0 to Mission_Amount - 1 do
  begin
    tip := GetMissionState(i);
    if tip >= 1 then
    begin
      if (mode = 0) or (tip = mode) then
      begin
        setlength(menustring, n + 1);
        setlength(MissionList, n + 1);
        temp := concat(' ', missiontip[tip]);
        temp := concat(temp, ' ');
        str := big5tounicode(@MissionStr[i][0]);
        menustring[n] := concat(temp, str);
        MissionList[n] := i;
        n := n + 1;
      end;
    end;
  end;
  redraw;
  //drawrectangle(x, y, 200, n * 20 + 10, 0, colcolor($FF), 40);
  if length(MissionList) > 0 then
  begin

    if length(MissionList) > 20 then
      menu := commonscrollmenu(x, y, 500, length(MissionList) - 1, 20)
    else
      menu := commonscrollmenu(x, y, 500, length(MissionList) - 1, length(MissionList));
    if menu = -1 then
      exit;

    //t := matelist[menu];
    // if t >= 60 then
    // begin
    //   if t = 109 then t := 114
    //   else t := t + 3;
    // end;
    // x50[$7100] := t;
    //  callevent(230);
    redraw;
    SDL_UpdateRect2(screen, 0, 0, 640, 440);
  end;
end;

procedure SetMissionState(position, Value: integer);
var
  i, n, p: integer;
begin
  n := 650 + position div 162;

  p := position div 2 + 18;
  if (position mod 2) = 0 then
  begin
    Rrole[n].Data[p] := (Rrole[n].Data[p] and $FF00) or Value;
  end
  else
  begin
    Rrole[n].Data[p] := (Rrole[n].Data[p] and $FF) or (Value shl 8);
  end;

end;

procedure RoleEnding(starnum, headnum, talknum: integer);
var
  status, color, newcolor, alen, n, ch, r1, c1, color1, color2, grp, idx, i, offset, len, hx,
  hy, sx, sy, nx, ny, tx, ty, cell, framex, l, w, h, framey: integer;
  str1, str2, str: WideString;
  np3, np1, np2, tp, p1, ap: PChar;
  actorarray, name1, name2, talkarray: array of byte;
  pword: array[0..1] of Uint16;
begin
  status := getstarstate(starnum);
  cell := 23;
  framex := 15;
  framey := 160 * (starnum mod 3);
  h := 160;
  w := 610;
  pword[1] := 0;
  drawrectanglewithoutframe(framex, framey, w, h - 1, 0, 75);
  // drawrectanglewithoutframe(0,framey,640,h-1,0,100);

  color := 28421;
  color1 := color and $FF;
  color2 := (color shr 8) and $FF;
  tx := framex + 100;
  ty := framey + 15;
  hy := framey + 82;
  hx := framex + 40;
  nx := 18 + hx;
  ny := 35 + hy;
  sx := 18 + hx;
  sy := 10 + hy;
  str1 := Star[starnum];
  if status = 0 then
  begin
    str2 := '？？？';
  end
  else
  begin
    if status = 5 then
      gray := True;
    drawheadPic(headnum, hx, hy);
    gray := False;
    str2 := RoleName[starnum];
  end;
  drawrectangle(hx, hy - 68, 56, 72, 0, colcolor(255), 0);
  l := length(str1);
  DrawShadowText(@str1[1], sx - (20 * l) div 2, sy, colcolor($5), colcolor($8));
  l := length(str2);
  DrawShadowText(@str2[1], nx - (20 * l) div 2, ny, colcolor($5), colcolor($8));

  if status > 0 then
  begin
    //读取对话
    idx := fileopen('resource\talk.idx', fmopenread);
    grp := fileopen('resource\talk.grp', fmopenread);
    if talknum = 0 then
    begin
      offset := 0;
      fileread(idx, len, 4);
    end
    else
    begin
      fileseek(idx, (talknum - 1) * 4, 0);
      fileread(idx, offset, 4);
      fileread(idx, len, 4);
    end;
    len := (len - offset);
    setlength(talkarray, len + 1);
    fileseek(grp, offset, 0);
    fileread(grp, talkarray[0], len);
    fileclose(idx);
    fileclose(grp);
    for i := 0 to len - 1 do
    begin
      talkarray[i] := talkarray[i] xor $FF;
      if talkarray[i] = 255 then
        talkarray[i] := 0;
    end;
    talkarray[i] := 0;
    tp := @talkarray[0];
    //读取姓名
    p1 := @Rrole[0].Name;
    alen := length(p1) + 2;
    setlength(actorarray, alen);
    ap := @actorarray[0];
    for n := 0 to alen - 1 do
    begin
      (ap + n)^ := (p1 + n)^;
      if (p1 + n)^ = char(0) then
        break;
    end;
    (ap + n)^ := char($0);
    (ap + n + 1)^ := char(0);

    ch := 0;
    c1 := 0;
    r1 := 0;
    while ((puint16(tp + ch))^ shl 8 <> 0) and ((puint16(tp + ch))^ shr 8 <> 0) do
    begin
      pword[0] := (puint16(tp + ch))^;
      if (pword[0] shr 8 <> 0) and (pword[0] shl 8 <> 0) then
      begin
        ch := ch + 2;

        if pword[0] = $2A2A then //**换行
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
            DrawBig5ShadowText(@pword[0], tx + CHINESE_FONT_SIZE * c1, ty + CHINESE_FONT_SIZE *
              r1, colcolor(color1), colcolor(color2));
            Inc(c1);
            if c1 = cell then
            begin
              c1 := 0;
              Inc(r1);
            end;
          end;
        end
        else //显示文字
        begin
          DrawBig5ShadowText(@pword, tx + CHINESE_FONT_SIZE * c1, ty + CHINESE_FONT_SIZE *
            r1, colcolor(color1), colcolor(color2));
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

  SDL_UpdateRect2(screen, framex, framey, w, h);
end;

function Woodman(Chamber: integer): boolean;
var
  x, y, x1, y1, i, i3, i2, sta, offset, eface1, eface2, position, roleface: integer;
  canwalk, stay: boolean;
begin
  Result := True;
  x := 80;
  y := 90;
  eface1 := 0;
  eface2 := 0;
  roleface := 0;
  i := sizeof(woodmansta);
  sta := fileopen('list\woodman.bin', fmopenread);
  offset := Chamber * i;
  fileseek(sta, offset, 0);
  fileread(sta, Woodmansta, i);
  fileclose(sta);
  if fileexists('resource\Woodman') then
    WoodPic := IMG_Load('resource\Woodman');
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
  SDL_UpdateRect2(screen, 0, 0, screen.w, screen.h);
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
    SDL_UpdateRect2(screen, 0, 0, screen.w, screen.h);

    CheckBasicEvent;
    case event.type_ of
      SDL_MOUSEMOTION:
      begin
        if (round(event.button.x / (RealScreen.w / screen.w)) > x) and
          (round(event.button.x / (RealScreen.w / screen.w)) < x + 480) and
          (round(event.button.y / (RealScreen.h / screen.h)) > y) and
          (round(event.button.y / (RealScreen.h / screen.h)) < y + 300) then
          position := ((round(event.button.x / (RealScreen.w / screen.w)) - x) div 48) *
            10 + ((round(event.button.y / (RealScreen.h / screen.h))) - y) div 30;
      end;
      SDL_KeyUP:
      begin
        if event.key.keysym.sym = sdlk_escape then
        begin
          Result := False;
          redraw;
          SDL_UpdateRect2(screen, 0, 0, screen.w, screen.h);
          exit;
        end;
        if event.key.keysym.sym = sdlk_up then
          y1 := woodmansta.ry - 2;
        if event.key.keysym.sym = sdlk_down then
          y1 := woodmansta.ry + 2;
        if event.key.keysym.sym = sdlk_left then
          x1 := woodmansta.rx - 2;
        if event.key.keysym.sym = sdlk_right then
          x1 := woodmansta.rx + 2;
        canwalk := False;
        stay := False;

        if (event.key.keysym.sym = sdlk_return) or (event.key.keysym.sym = sdlk_space) then
        begin
          canwalk := True;
          stay := True;
        end;
        if y1 - woodmansta.ry = 2 then
          if woodmansta.GameData[woodmansta.Rx * 19 + woodmansta.Ry + 1] = 0 then
          begin
            canwalk := True;
            roleface := 0;
          end;
        if y1 - woodmansta.ry = -2 then
          if woodmansta.GameData[woodmansta.Rx * 19 + woodmansta.Ry - 1] = 0 then
          begin
            canwalk := True;
            roleface := 1;
          end;
        if x1 - woodmansta.rx = -2 then
          if woodmansta.GameData[(woodmansta.Rx - 1) * 19 + woodmansta.Ry] = 0 then
          begin
            canwalk := True;
            roleface := 2;
          end;
        if x1 - woodmansta.rx = 2 then
          if woodmansta.GameData[(woodmansta.Rx + 1) * 19 + woodmansta.Ry] = 0 then
          begin
            canwalk := True;
            roleface := 3;
          end;
        if canwalk then
        begin
          if stay = False then
          begin
            ShowManWalk(roleface, Eface1, Eface2);
          end;
          if (woodmansta.Rx = woodmansta.ExitX) and (woodmansta.Ry = woodmansta.ExitY) then
          begin
            Result := True;
            sdl_delay(1000);
            redraw;
            SDL_UpdateRect2(screen, 0, 0, screen.w, screen.h);
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
                    showwoodmanwalk(i3, Eface1, Eface2, RoleFace);
                  end
                  else if (WoodmanSta.Exy[i3][0] > woodmansta.rx) and
                    (woodmansta.GameData[(WoodmanSta.Exy[i3][0] - 1) * 19 + woodmansta.Exy[i3][1]] = 0) then
                  begin
                    Eface1 := 2;
                    showwoodmanwalk(i3, Eface1, Eface2, RoleFace);
                  end
                  else if (WoodMansta.Exy[i3][1] > WoodmanSta.ry) and
                    (WoodmanSta.GameData[WoodmanSta.Exy[i3][0] * 19 + WoodmanSta.Exy[i3][1] - 1] = 0) then
                  begin
                    Eface1 := 1;
                    showwoodmanwalk(i3, Eface1, Eface2, RoleFace);
                  end
                  else if (WoodmanSta.Exy[i3][1] < WoodmanSta.ry) and
                    (WoodmanSta.GameData[WoodmanSta.Exy[i3][0] * 19 + WoodmanSta.Exy[i3][1] + 1] = 0) then
                  begin
                    Eface1 := 0;
                    showwoodmanwalk(i3, Eface1, Eface2, RoleFace);
                  end;
                end
                else
                begin
                  if (WoodMansta.Exy[i3][1] > WoodmanSta.ry) and
                    (WoodmanSta.GameData[WoodmanSta.Exy[i3][0] * 19 + WoodmanSta.Exy[i3][1] + 1] = 0) then
                  begin
                    Eface1 := 1;
                    showwoodmanwalk(i3, Eface1, Eface2, RoleFace);
                  end
                  else if (WoodmanSta.Exy[i3][1] < WoodmanSta.ry) and
                    (WoodmanSta.GameData[WoodmanSta.Exy[i3][0] * 19 + WoodmanSta.Exy[i3][1] - 1] = 0) then
                  begin
                    Eface1 := 0;
                    showwoodmanwalk(i3, Eface1, Eface2, RoleFace);
                  end
                  else if (WoodmanSta.Exy[i3][0] < woodmansta.rx) and
                    (woodmansta.GameData[(WoodmanSta.Exy[i3][0] - 1) * 19 + woodmansta.Exy[i3][1]] = 0) then
                  begin
                    Eface1 := 3;
                    showwoodmanwalk(i3, Eface1, Eface2, RoleFace);
                  end
                  else if (WoodmanSta.Exy[i3][0] > woodmansta.rx) and
                    (woodmansta.GameData[(WoodmanSta.Exy[i3][0] + 1) * 19 + woodmansta.Exy[i3][1]] = 0) then
                  begin
                    Eface1 := 2;
                    showwoodmanwalk(i3, Eface1, Eface2, RoleFace);
                  end;
                end;
              end;

            end;
            if (WoodmanSta.Exy[i3][0] = WoodmanSta.Rx) and (WoodmanSta.Exy[i3][1] = WoodmanSta.Ry) then
            begin
              Result := False;
              sdl_delay(1000);
              redraw;
              SDL_UpdateRect2(screen, 0, 0, screen.w, screen.h);
              SDL_FreeSurface(WoodPic);
              Exit;
            end;
          end;
        end;
      end;
      SDL_MOUSEBUTTONUP:
      begin
        x1 := (position div 10) * 2;
        y1 := (position mod 10) * 2;
        canwalk := False;
        stay := False;
        if y1 - woodmansta.ry = 2 then
          if woodmansta.GameData[woodmansta.Rx * 19 + woodmansta.Ry + 1] = 0 then
          begin
            canwalk := True;
            roleface := 0;
          end;
        if y1 - woodmansta.ry = -2 then
          if woodmansta.GameData[woodmansta.Rx * 19 + woodmansta.Ry - 1] = 0 then
          begin
            canwalk := True;
            roleface := 1;
          end;
        if x1 - woodmansta.rx = -2 then
          if woodmansta.GameData[(woodmansta.Rx - 1) * 19 + woodmansta.Ry] = 0 then
          begin
            canwalk := True;
            roleface := 2;
          end;
        if x1 - woodmansta.rx = 2 then
          if woodmansta.GameData[(woodmansta.Rx + 1) * 19 + woodmansta.Ry] = 0 then
          begin
            canwalk := True;
            roleface := 3;
          end;
        if (x1 = woodmansta.rx) and (y1 = woodmansta.ry) then
        begin
          canwalk := True;
          stay := True;
        end;
        if canwalk then
        begin
          if stay = False then
          begin
            ShowManWalk(roleface, Eface1, Eface2);
          end;
          if (woodmansta.Rx = woodmansta.ExitX) and (woodmansta.Ry = woodmansta.ExitY) then
          begin
            Result := True;
            sdl_delay(1000);
            redraw;
            SDL_UpdateRect2(screen, 0, 0, screen.w, screen.h);
            SDL_FreeSurface(WoodPic);
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
                    showwoodmanwalk(i3, Eface1, Eface2, RoleFace);
                  end
                  else if (WoodmanSta.Exy[i3][0] > woodmansta.rx) and
                    (woodmansta.GameData[(WoodmanSta.Exy[i3][0] - 1) * 19 + woodmansta.Exy[i3][1]] = 0) then
                  begin
                    Eface1 := 2;
                    showwoodmanwalk(i3, Eface1, Eface2, RoleFace);
                  end
                  else if (WoodMansta.Exy[i3][1] > WoodmanSta.ry) and
                    (WoodmanSta.GameData[WoodmanSta.Exy[i3][0] * 19 + WoodmanSta.Exy[i3][1] - 1] = 0) then
                  begin
                    Eface1 := 1;
                    showwoodmanwalk(i3, Eface1, Eface2, RoleFace);
                  end
                  else if (WoodmanSta.Exy[i3][1] < WoodmanSta.ry) and
                    (WoodmanSta.GameData[WoodmanSta.Exy[i3][0] * 19 + WoodmanSta.Exy[i3][1] + 1] = 0) then
                  begin
                    Eface1 := 0;
                    showwoodmanwalk(i3, Eface1, Eface2, RoleFace);
                  end;
                end
                else
                begin
                  if (WoodMansta.Exy[i3][1] > WoodmanSta.ry) and
                    (WoodmanSta.GameData[WoodmanSta.Exy[i3][0] * 19 + WoodmanSta.Exy[i3][1] + 1] = 0) then
                  begin
                    Eface1 := 1;
                    showwoodmanwalk(i3, Eface1, Eface2, RoleFace);
                  end
                  else if (WoodmanSta.Exy[i3][1] < WoodmanSta.ry) and
                    (WoodmanSta.GameData[WoodmanSta.Exy[i3][0] * 19 + WoodmanSta.Exy[i3][1] - 1] = 0) then
                  begin
                    Eface1 := 0;
                    showwoodmanwalk(i3, Eface1, Eface2, RoleFace);
                  end
                  else if (WoodmanSta.Exy[i3][0] < woodmansta.rx) and
                    (woodmansta.GameData[(WoodmanSta.Exy[i3][0] - 1) * 19 + woodmansta.Exy[i3][1]] = 0) then
                  begin
                    Eface1 := 3;
                    showwoodmanwalk(i3, Eface1, Eface2, RoleFace);
                  end
                  else if (WoodmanSta.Exy[i3][0] > woodmansta.rx) and
                    (woodmansta.GameData[(WoodmanSta.Exy[i3][0] + 1) * 19 + woodmansta.Exy[i3][1]] = 0) then
                  begin
                    Eface1 := 2;
                    showwoodmanwalk(i3, Eface1, Eface2, RoleFace);
                  end;
                end;
              end;

            end;
            if (WoodmanSta.Exy[i3][0] = WoodmanSta.Rx) and (WoodmanSta.Exy[i3][1] = WoodmanSta.Ry) then
            begin
              Result := False;
              sdl_delay(1000);
              redraw;
              SDL_UpdateRect2(screen, 0, 0, screen.w, screen.h);
              SDL_FreeSurface(WoodPic);
              Exit;
            end;
          end;
        end;
      end;
    end;
    SDL_UpdateRect2(screen, 0, 0, screen.w, screen.h);
  end;
  SDL_FreeSurface(WoodPic);

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

    SDL_UpdateRect2(screen, 0, 0, screen.w, screen.h);
    sdl_delay(100);
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
  Ef1, Ef2: pint;
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

    SDL_UpdateRect2(screen, 0, 0, screen.w, screen.h);
    sdl_delay(100);
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
  x, y, w, h, i, x1, y1, r, right, menu, menu1, menu2: integer;
  pic: psdl_surface;
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
  filename := 'resource\Pic' + IntToStr(num);
  if fileexists(filename) then
    Pic := IMG_Load(@filename[1]);

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

  redraw;
  drawrectangle(x - 5, y - 5, w, h, 0, colcolor(255), 100);
  for i := 0 to 24 do
  begin
    drawpartpic(pic, ((24 - i) mod 5) * 80, ((24 - i) div 5) * 80, 80, 80, (i mod 5) * 80 +
      x, (i div 5) * 80 + y + 30);
  end;
  SDL_UpdateRect2(screen, 0, 0, screen.w, screen.h);
  sdl_delay(2000);


  drawrectangle(x - 5, y - 5, w, h, 0, colcolor(255), 100);
  for i := 0 to 24 do
  begin
    drawpartpic(pic, ((24 - gamearray[0][i]) mod 5) * 80, ((24 - gamearray[0][i]) div 5) *
      80, 80, 80, (i mod 5) * 80 + x, (i div 5) * 80 + y + 30);
  end;
  if menu2 > -1 then
    drawrectangle((menu2 mod 5) * 80 + x, (menu2 div 5) * 80 + y + 30, 80, 80, 0, colcolor($64), 0);
  if menu > -1 then
    drawrectangle((menu mod 5) * 80 + x, (menu div 5) * 80 + y + 30, 80, 80, 0, colcolor($255), 0);
  word := '機會' + IntToStr(chance);
  word1 := '命中' + IntToStr(right);
  drawshadowtext(@word[1], x + 5, y + 5, colcolor(5), colcolor(7));
  drawshadowtext(@word1[1], x + 200, y + 5, colcolor(5), colcolor(7));
  SDL_UpdateRect2(screen, 0, 0, screen.w, screen.h);



  while (SDL_WaitEvent(@event) >= 0) do
  begin
    CheckBasicEvent;
    case event.type_ of
      SDL_KEYUP:
      begin
        menu1 := menu;
        if event.key.keysym.sym = sdlk_escape then
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
        if event.key.keysym.sym = sdlk_up then
          menu := menu - 5;
        if event.key.keysym.sym = sdlk_down then
          menu := menu + 5;
        if event.key.keysym.sym = sdlk_left then
          menu := menu - 1;
        if event.key.keysym.sym = sdlk_right then
          menu := menu + 1;
        if menu > 24 then
          menu := menu - 25;
        if menu < 0 then
          menu := menu + 25;
        if menu1 > -1 then
          drawpartpic(pic, ((24 - gamearray[0][menu1]) mod 5) * 80, ((24 - gamearray[0][menu1]) div 5) *
            80, 80, 80, (menu1 mod 5) * 80 + x, (menu1 div 5) * 80 + y + 30);
        if (event.key.keysym.sym = sdlk_return) or (event.key.keysym.sym = sdlk_space) then
        begin
          if menu2 > -1 then
          begin
            exchangepic(menu, menu2);
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
        if (round(event.button.x / (RealScreen.w / screen.w)) > x) and
          (round(event.button.x / (RealScreen.w / screen.w)) < x - 5 + w) and
          (round(event.button.y / (RealScreen.h / screen.h)) > y) and
          (round(event.button.y / (RealScreen.h / screen.h)) < y - 5 + h) then
        begin
          menu := ((round(event.button.x / (RealScreen.w / screen.w)) - x) div 80) +
            ((round(event.button.y / (RealScreen.h / screen.h)) - y - 30) div 80) * 5;
          if menu > 24 then
            menu := -1;
          if menu <> menu1 then
          begin
            if menu1 > -1 then
              drawpartpic(pic, ((24 - gamearray[0][menu1]) mod 5) * 80, ((24 - gamearray[0][menu1]) div 5) *
                80, 80, 80, (menu1 mod 5) * 80 + x, (menu1 div 5) * 80 + y + 30);
          end;
        end;
      end;
      SDL_MOUSEBUTTONUP:
      begin
        if event.button.button = sdl_button_right then
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
        if event.button.button = sdl_button_left then
        begin
          if menu2 > -1 then
          begin
            exchangepic(menu, menu2);
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
    drawrectangle(x - 5, y - 5, w, h, 0, colcolor(255), 100);
    for i := 0 to 24 do
    begin
      drawpartpic(pic, ((24 - gamearray[0][i]) mod 5) * 80, ((24 - gamearray[0][i]) div 5) *
        80, 80, 80, (i mod 5) * 80 + x, (i div 5) * 80 + y + 30);
    end;
    if menu2 > -1 then
      drawrectangle((menu2 mod 5) * 80 + x, (menu2 div 5) * 80 + y + 30, 80, 80, 0, colcolor($64), 0);
    if menu > -1 then
      drawrectangle((menu mod 5) * 80 + x, (menu div 5) * 80 + y + 30, 80, 80, 0, colcolor($255), 0);
    word := '機會' + IntToStr(chance);
    word1 := '命中' + IntToStr(right);
    drawshadowtext(@word[1], x + 5, y + 5, colcolor(5), colcolor(7));
    drawshadowtext(@word1[1], x + 200, y + 5, colcolor(5), colcolor(7));
    SDL_UpdateRect2(screen, 0, 0, screen.w, screen.h);


    if right = 25 then
      Result := True
    else
      Result := False;
    if Result then
    begin
      sdl_delay(700);
      break;
    end
    else if chance = 0 then
    begin
      sdl_delay(700);
      break;
    end;
  end;
  setlength(gamearray, 0);
end;

procedure ExchangePic(p1, p2: integer);
var
  t: smallint;
begin
  t := gamearray[0][p1];
  gamearray[0][p1] := gamearray[0][p2];
  gamearray[0][p2] := t;
end;

procedure ReSort;
var
  amount, i, j, inum: smallint;
begin
  for I := 0 to MAX_ITEM_AMOUNT - 2 do
  begin
    for J := MAX_ITEM_AMOUNT - 1 downto i + 1 do
    begin
      if (Ritemlist[j].Number < Ritemlist[j - 1].Number) and (Ritemlist[j].Number > -1) then
      begin
        amount := Ritemlist[j].Amount;
        inum := Ritemlist[j].Number;
        Ritemlist[j].Amount := Ritemlist[j - 1].Amount;
        Ritemlist[j].Number := Ritemlist[j - 1].Number;
        Ritemlist[j - 1].Amount := amount;
        Ritemlist[j - 1].Number := inum;
      end;
    end;
  end;
  //ReArrangeItem;
end;

procedure bookList;
var
  x, y, w, h, i, j: integer;
  itemlist: array of smallint;
begin
  j := 0;
  x := 220;
  y := 10;
  w := 200;
  setlength(menuengstring, 0);
  setlength(menustring, MAX_ITEM_AMOUNT);
  setlength(itemlist, MAX_ITEM_AMOUNT);
  for i := 0 to MAX_ITEM_AMOUNT - 1 do
  begin
    if (Ritemlist[i].Number >= 0) and (Ritemlist[i].Amount > 0) then
    begin
      if Ritem[Ritemlist[i].Number].Magic >= 0 then
      begin
        j := j + 1;
        menustring[j - 1] := ' ' + Big5toUnicode(@Ritem[Ritemlist[i].Number].Name[0]);
        itemlist[j - 1] := Ritemlist[i].Number;
      end;
    end;
  end;
  i := CommonScrollMenu(x, y, w, j - 1, 20);
  if i > -1 then
    i := itemlist[i];
  setlength(menustring, 0);
  x50[28931] := i;

end;

function GetStarAmount: smallint;
var
  i, a: integer;
begin
  Result := 0;
  for i := 0 to 107 do
  begin
    if getstarstate(i) > 0 then
      Inc(Result);
  end;
end;




//劲舞团模式，用于机关，返回值为0=失败，1=胜利；没有分数的计算，可以内嵌入50指令
//此版本为非pic版本，使用的贴图为：1000-1003，1100-1103

function DancerAfter90S: integer;
var
  now, ori_time, demand_time: uint32; //demand_time must be a ms-level
  str: WideString;
  i, DanceNum, DanceLong, tmp: integer; //计数器,当前的贴图
  DanceList: array[0..9] of smallint;
  iskey: boolean;
begin
  redraw;
  DanceNum := 0;
  DanceLong := 8;
  ori_time := sdl_getticks;
  demand_time := 10000; //10s
  iskey := True;
  DrawRectangle((320 - 43 * (DanceLong div 2)) - 5, 120 - 62, (DanceLong + 1) * 43 + 5, 45,
    colcolor(0), colcolor($255), 25);
  DrawRectangle(0, 420, 640, 14, colcolor(47), colcolor($255), 0);
  SDL_UpdateRect2(screen, 0, 0, screen.w, screen.h);
  for i := 0 to DanceLong do
  begin
    tmp := random(4);
    DrawSPic(4678 + DanceList[i], 320 - 43 * (DanceLong div 2) + i * 43, 120 - 62, 0, 0, screen.w, screen.h); //end;70
    DanceList[i] := tmp;
  end;
  while SDL_PollEvent(@event) >= 0 do
  begin
    now := sdl_getticks;
    //70%,turn red
    if (now - ori_time) < (demand_time * 0.7) then
      DrawRectangle(0, 420, 640 * (now - ori_time) div demand_time, 14, colcolor(47), colcolor($255), 100)
    else if ((now - ori_time) >= (demand_time * 0.7)) and ((now - ori_time) <= (demand_time * 1)) then
      DrawRectangle(0, 420, 640 * (now - ori_time) div demand_time, 14, colcolor(70), colcolor($255), 100)
    else
    begin
      waitanykey;
      //lose
      Result := 0;
      break;
    end;
    SDL_UpdateRect2(screen, 0, 0, screen.w, screen.h);
    case event.type_ of
      SDL_KEYDOWN:
      begin
        //绘图的四个方向必须是上下右左（莫名其妙的排列）
        if (DanceNum <> DanceLong + 1) then
        begin
          if ((event.key.keysym.sym - 273) = DanceList[DanceNum]) and (iskey = True) then
          begin
            DrawSPic(4682 + DanceList[DanceNum], 320 - 43 * (DanceLong div 2) + DanceNum *
              43, 120, 0, 0, screen.w, screen.h); //end;70
            DanceNum := DanceNum + 1;
            iskey := False;
          end
          else if (iskey = True) then
          begin
            for i := 0 to DanceNum do
              DrawSPic(4678 + DanceList[i], 320 - 43 * (DanceLong div 2) + i * 43, 120 -
                62, 0, 0, screen.w, screen.h); //end;70
            DanceNum := 0;
            iskey := False;
          end;
        end
        else
        if (event.key.keysym.sym = sdlk_space) and (iskey = True) then
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
        if (event.key.keysym.sym = sdlk_escape) then
        begin
          Result := 0;
          break;
        end;
      end;
    end;
    event.key.keysym.sym := 0;
  end;
end;


end.
