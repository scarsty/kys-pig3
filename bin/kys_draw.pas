unit kys_draw;

interface

uses
{$IFDEF fpc}
{$ENDIF}
{$IFDEF mswindows}
  Windows,
{$ENDIF}
  SysUtils,
  SDL2,
  Math,
  kys_type,
  kys_main,
  kys_event;


//画单个图片的子程
procedure DrawPic(sur: PSDL_Surface; Pictype, num, px, py, shadow, alpha: integer; mixColor: uint32;
  mixAlpha: integer);
procedure DrawTPic(imgnum, px, py: integer; region: psdl_rect = nil; shadow: integer = 0;
  Alpha: integer = 0; mixColor: uint32 = 0; mixAlpha: integer = 0; angle: real = 0);
procedure DrawMPic(num, px, py: integer; Framenum: integer = -1; shadow: integer = 0;
  alpha: integer = 0; mixColor: uint32 = 0; mixAlpha: integer = 0; scalex: real = 1;
  scaley: real = 1; angle: real = 0); overload;
procedure DrawSPic(num, px, py: integer); overload;
procedure DrawSPic(num, px, py: integer; region: psdl_rect; shadow, alpha: integer; mixColor: uint32;
  mixAlpha: integer); overload;
procedure DrawHeadPic(num, px, py: integer; shadow: integer = 0; alpha: integer = 0;
  mixColor: uint32 = 0; mixAlpha: integer = 0; scalex: real = 1; scaley: real = 1); overload;
procedure DrawEPic(num, px, py: integer; index: integer = 0); overload;
procedure DrawEPic(num, px, py, shadow, alpha: integer; mixColor: uint32; mixAlpha: integer;
  index: integer = 0; scalex: real = 1; scaley: real = 1; angle: real = 1; center: PSDL_Point = nil); overload;
procedure DrawFPic(num, px, py, index: integer); overload;
procedure DrawFPic(num, px, py, index, shadow, alpha: integer; mixColor: uint32; mixAlpha: integer); overload;
procedure DrawCPic(num, px, py, shadow, alpha: integer; mixColor: uint32; mixAlpha: integer);
procedure DrawIPic(num, px, py, shadow, alpha: integer; mixColor: uint32; mixAlpha: integer);

//绘制整个屏幕的子程
procedure Redraw;
procedure DrawMMap;
procedure DrawScence;
procedure DrawScenceWithoutRole(x, y: integer);
procedure DrawRoleOnScence(x, y: integer);
procedure ExpandGroundOnImg();
procedure InitialScence(Visible: integer = 0);
function CalBlock(x, y: integer): integer;
procedure CalPosOnImage(i1, i2: integer; var x, y: integer);
procedure CalLTPosOnImageByCenter(i1, i2: integer; var x, y: integer);
procedure DrawBField();
procedure DrawBfieldWithoutRole(x, y: integer);
procedure DrawRoleOnBfield(x, y: integer; mixColor: uint32 = 0; mixAlpha: integer = 0; Alpha: integer = 75);
procedure InitialBFieldImage(layer: integer = 2);
procedure DrawBFieldWithCursor(AttAreaType, step, range: integer);
procedure DrawBlackScreen;
procedure DrawBFieldWithEft(Epicnum, beginpic, endpic, curlevel, bnum, SelectAimMode, flash: integer;
  mixColor: uint32; index: integer = 0; shadow: integer = 0; alpha: integer = 0; MixColor2: uint32 = 0;
  MixAlpha2: integer = 0); overload;
procedure DrawBFieldWithAction(bnum, Apicnum: integer);
procedure DrawClouds;
procedure DrawProgress;

procedure LoadGroundTex(x, y: integer);

function DrawTextFrame(x, y: integer; len: integer; alpha: integer = 0; mixColor: uint32 = 0;
  mixAlpha: integer = 0): integer;

procedure DrawTextWithRect(word: puint16; x, y, w: integer; color1, color2: uint32;
  alpha: integer = 0; Refresh: integer = 1);

implementation

uses
  kys_engine,
  kys_battle;

procedure DrawPic(sur: PSDL_Surface; Pictype, num, px, py, shadow, alpha: integer; mixColor: uint32;
  mixAlpha: integer);
var
  PNGIndex: TPNGIndex;
  pPNGIndex: ^TPNGIndex;
  pSurface: PPSDL_Surface;
  path: string;
  inRegion: boolean;
  pPicByte: pbyte;
begin
  inregion := num >= 0;
  if PNG_TILE > 0 then
  begin
    case PicType of
      0:
      begin
        inregion := inregion and (num < length(MPNGIndex));
        pPNGIndex := @MPNGIndex[0];
      end;
      1:
      begin
        inregion := inregion and (num < length(SPNGIndex));
        pPNGIndex := @SPNGIndex[0];
      end;
      2:
      begin
        //inregion := inregion and (num < length(BPNGIndex));
        //pPNGIndex := @BPNGIndex[0];
      end;
      3:
      begin
        inregion := inregion and (num < length(TitlePNGIndex));
        pPNGIndex := @TitlePNGIndex[0];
      end;
      4:
      begin
        inregion := inregion and (num < length(HPNGIndex));
        pPNGIndex := @HPNGIndex[0];
      end;
      5:
      begin
        inregion := inregion and (num < length(EPNGIndex));
        pPNGIndex := @EPNGIndex[0];
      end;
      6:
      begin
        inregion := inregion and (num < length(CPNGIndex));
        pPNGIndex := @CPNGIndex[0];
      end;
    end;
    if inregion then
    begin
      Inc(pPNGIndex, num);
      PNGIndex := pPNGIndex^;
      //DrawPNGTile(PNGIndex, 0, nil, screen, px, py, shadow, Alpha, mixColor, mixAlpha);
    end;
  end;
end;

//显示title.grp的内容(即开始的选单)

procedure DrawTPic(imgnum, px, py: integer; region: psdl_rect = nil; shadow: integer = 0;
  Alpha: integer = 0; mixColor: uint32 = 0; mixAlpha: integer = 0; angle: real = 0);
var
  len, grp, idx: integer;
  Area: TSDL_Rect;
  BufferIdx: TIntArray;
  BufferPic: TByteArray;
begin
  if PNG_TILE > 0 then
  begin
    if imgnum <= high(TitlePNGIndex) then
      DrawPNGTile(render, TitlePNGIndex[imgnum], 0, px, py, region, shadow, alpha, mixColor,
        mixAlpha, 1, 1, angle, nil);
  end;

end;

//显示主地图贴图

procedure DrawMPic(num, px, py: integer; Framenum: integer = -1; shadow: integer = 0;
  alpha: integer = 0; mixColor: uint32 = 0; mixAlpha: integer = 0; scalex: real = 1;
  scaley: real = 1; angle: real = 0); overload;
var
  NeedGRP: integer;
begin
  if (num >= 0) and (num < MPicAmount) then
  begin
    if (PNG_TILE > 0) then
    begin
      if Framenum = -1 then
        Framenum := SDL_GetTicks div 200 + random(3);
      if (num = 1377) or (num = 1388) or (num = 1404) or (num = 1417) then
        Framenum := SDL_GetTicks div 200;
      //瀑布场景的闪烁需要
      if PNG_LOAD_ALL = 0 then
        if MPNGIndex[num].Loaded = 0 then
        begin
          LoadOnePNGTexture('resource/mmap/', pMPic, MPNGIndex[num]);
        end;
      DrawPNGTile(render, MPNGIndex[num], Framenum, px, py, nil, shadow, alpha, mixColor, mixAlpha,
        scalex, scaley, angle, nil);
    end;
    if (PNG_TILE = 0) then
    begin

    end;
  end;
end;

//显示场景图片

procedure DrawSPic(num, px, py: integer); overload;
var
  Area: TSDL_Rect;
  f: integer;
begin
  if (num >= 0) and (num < SPicAmount) then
  begin
    if num = 1941 then
    begin
      num := 0;
      py := py - 50;
    end;
    if PNG_TILE > 0 then
    begin
      if PNG_LOAD_ALL = 0 then
        if SPNGIndex[num].Loaded = 0 then
          LoadOnePNGTexture('resource/smap/', pSPic, SPNGIndex[num]);
      f := SDL_GetTicks div 300 + random(3);
      DrawPNGTile(render, SPNGIndex[num], f, px, py);
    end;
  end;
end;

//画考虑遮挡的内场景

procedure DrawSPic(num, px, py: integer; region: psdl_rect; shadow, alpha: integer; mixColor: uint32;
  mixAlpha: integer); overload;
begin
  if (num >= 0) and (num < SPicAmount) then
  begin
    if num = 1941 then
    begin
      num := 0;
      py := py - 50;
    end;
    if PNG_TILE > 0 then
    begin
      if PNG_LOAD_ALL = 0 then
        if SPNGIndex[num].Loaded = 0 then
          LoadOnePNGTexture('resource/smap/', pSPic, SPNGIndex[num]);
      DrawPNGTile(render, SPNGIndex[num], 0, px, py, region, shadow, alpha, mixColor, mixAlpha,
        1, 1, 0, nil);
    end
    else
    begin

    end;
  end;

end;



//显示头像

procedure DrawHeadPic(num, px, py: integer; shadow: integer = 0; alpha: integer = 0;
  mixColor: uint32 = 0; mixAlpha: integer = 0; scalex: real = 1; scaley: real = 1); overload;
var
  len, grp, idx: integer;
  str: string;
begin
  if (num >= 0) and (num < HPicAmount) then
  begin
    if PNG_TILE > 0 then
    begin
      if PNG_LOAD_ALL = 0 then
        if HPNGIndex[num].Loaded = 0 then
        begin
          LoadOnePNGTexture('resource/head', pHPic, HPNGIndex[num]);
        end;
      DrawPNGTile(render, HPNGIndex[num], 0, px, py, nil, shadow, alpha, mixColor, mixAlpha,
        scalex, scaley, 0, nil);
    end;
    if PNG_TILE = 0 then
    begin

    end;
  end;

end;


//显示效果图片

procedure DrawEPic(num, px, py: integer; index: integer = 0); overload;
begin
  DrawEPic(num, px, py, 0, 0, 0, 0, index);

end;

procedure DrawEPic(num, px, py, shadow, alpha: integer; mixColor: uint32; mixAlpha: integer;
  index: integer = 0; scalex: real = 1; scaley: real = 1; angle: real = 1; center: PSDL_Point = nil); overload;
begin
  if (num >= 0) and (num < EPicAmount[index]) then
  begin
    if PNG_TILE > 0 then
    begin
      {if PNG_LOAD_ALL = 0 then
        if EPNGIndex[num].Loaded = 0 then
          LoadOnePNGTile('resource/eft/', pEPic, num, EPNGIndex[num], @EPNGTile[0]);
      DrawPNGTile(EPNGIndex[num], 0, nil, screen, px, py, shadow, alpha, mixColor, mixAlpha,
        0, nil, 0, 0, 0, 0, 0);}
      DrawPNGTile(render, EPNGIndex[index, num], 0, px, py, nil, shadow, alpha, mixColor, mixAlpha,
        scalex, scaley, angle, center);
    end;
    if PNG_TILE = 0 then
    begin

    end;
  end;
end;

//显示人物动作图片

procedure DrawFPic(num, px, py, index: integer); overload;
begin
  DrawFPic(num, px, py, 0, 0, 0, 0, index);

end;

//用于画带透明度和遮挡的人物动作图片

procedure DrawFPic(num, px, py, index, shadow, alpha: integer; mixColor: uint32; mixAlpha: integer); overload;
begin
  case PNG_TILE of
    1, 2:
    begin
      if FPicLoaded[index] = 0 then
      begin
        LoadPNGTiles(formatfloat('resource/fight/fight000', index), FPNGIndex[index],
          FPNGTex[index], FPNGTile[index], 1);
        FPicLoaded[index] := 1;
      end;
      if (index >= 0) and (index < High(FPNGIndex)) then
        if (num >= Low(FPNGIndex[index])) and (num <= High(FPNGIndex[index])) then
          DrawPNGTile(render, FPNGIndex[index][num], 0, px, py, nil, shadow, alpha, mixColor, mixAlpha,
            1, 1, 0, nil);
    end;
    0:
    begin
    end;
  end;
end;

//主地图上画云

procedure DrawCPic(num, px, py, shadow, alpha: integer; mixColor: uint32; mixAlpha: integer);
begin
  if PNG_TILE > 0 then
  begin
    DrawPNGTile(render, CPNGIndex[num], 0, px, py, nil, shadow, alpha, mixColor, mixAlpha, 1, 1, 0, nil);
  end;
  if PNG_TILE = 0 then
  begin

  end;
end;

//画物品图

procedure DrawIPic(num, px, py, shadow, alpha: integer; mixColor: uint32; mixAlpha: integer);
begin
  if (num >= 0) and (num < IPicAmount) then
  begin
    if PNG_TILE > 0 then
    begin
      if PNG_LOAD_ALL = 0 then
        if IPNGIndex[num].Loaded = 0 then
          LoadOnePNGTexture('resource/item/', pIPic, IPNGIndex[num]);
      DrawPNGTile(render, IPNGIndex[num], 0, px, py, nil, shadow, alpha, mixColor, mixAlpha, 1, 1, 0, nil);
    end;
    if PNG_TILE = 0 then
    begin

    end;
  end;
end;

//重画屏幕, SDL_UpdateRect2(screen,0,0,screen.w,screen.h)可显示

procedure Redraw;
begin
  //ScreenTint := 1;
  case where of
    0: DrawMMap;
    1: DrawScence;
    2:
    begin
      DrawBField;
    end;
    3:
    begin
      CleanTextScreen;
      DrawTPic(0, OpenPicPosition.x, OpenPicPosition.y);
      DrawTPic(12, CENTER_X - 384 + 112, CENTER_Y - 240 + 15);
      DrawTPic(10, CENTER_X - 384 + 110, CENTER_Y - 240 + 5);
      DrawTPic(10, CENTER_X - 384 + 591, CENTER_Y - 240 + 5);
      DrawShadowText(@versionstr[1], OpenPicPosition.x + 5, CENTER_Y - 240 + 455, ColColor($64), ColColor($66));
    end;
    4: //处于标题动画中
    begin
      CleanTextScreen;
      DrawTPic(0, OpenPicPosition.x, OpenPicPosition.y);
      DrawShadowText(@versionstr[1], OpenPicPosition.x + 5, CENTER_Y - 240 + 455, ColColor($64), ColColor($66));
    end;
  end;

end;


//显示主地图场景于屏幕

procedure DrawMMap;
var
  i1, i2, i, sum, x, y, k, c, widthregion, sumregion, num, axp, ayp, h: integer;
  //temp: array[0..479, 0..479] of smallint;
  Width, Height, xoffset, yoffset: smallint;
  pos: TPosition;
  BuildArray: array[0..2000] of TBuildInfo;
  tempb: TBuildInfo;
begin
  //由上到下绘制, 先绘制地面和表面, 同时计算出现的建筑数目
  //SDL_RenderClear(render);
  k := 0;
  h := High(BuildArray);
  widthregion := CENTER_X div 36 + 3;
  sumregion := CENTER_Y div 9 + 2;
  for sum := -sumregion to sumregion + 15 do
    for i := -Widthregion to Widthregion do
    begin
      if k >= h then
      begin
        break;
      end;
      i1 := Mx + i + (sum div 2);
      i2 := My - i + (sum - sum div 2);
      Pos := GetPositionOnScreen(i1, i2, Mx, My);
      if (i1 >= 0) and (i1 < 480) and (i2 >= 0) and (i2 < 480) then
      begin
        if (BIG_PNG_TILE = 0) then
        begin
          DrawMPic(earth[i1, i2] div 2, pos.x, pos.y);
          if surface[i1, i2] > 0 then
            DrawMPic(surface[i1, i2] div 2, pos.x, pos.y);
        end;

        num := building[i1, i2] div 2;
        //将主角和空船的位置计入建筑
        if (i1 = Mx) and (i2 = My) then
        begin
          if (InShip = 0) then
            if still = 0 then
              num := 2501 + MFace * 7 + MStep
            else
              num := 2528 + Mface * 6 + MStep
          else
            num := 3715 + MFace * 4 + (MStep + 1) div 2;
        end;
        if MODVersion = 13 then
          if (i1 = Shipy) and (i2 = Shipx) and (InShip = 0) then
          begin
            num := 3715 + ShipFace * 4;
          end;
        if (num > 0) and (num < MPicAmount) then
        begin
          BuildArray[k].x := i1;
          BuildArray[k].y := i2;
          BuildArray[k].b := num;
          if PNG_TILE > 0 then
          begin
            Width := MPNGIndex[num].w;
            Height := MPNGIndex[num].h;
            //xoffset := MPNGIndex[num].x;
            yoffset := MPNGIndex[num].y;
          end
          else
          begin
            Width := SmallInt(Mpic[MIdx[num - 1]]);
            Height := SmallInt(Mpic[MIdx[num - 1] + 2]);
            //xoffset := SmallInt(Mpic[MIdx[num - 1] + 4]);
            yoffset := SmallInt(Mpic[MIdx[num - 1] + 6]);
          end;
          //根据图片的宽度计算图的中点, 为避免出现小数, 实际是中点坐标的2倍
          //次要排序依据是y坐标
          BuildArray[k].c := ((i1 + i2) - (Width + 35) div 36 - (yoffset - Height + 1) div 9) * 1024 + i2;
          //BuildArray[k].c := (i1 + i2) - (min(xoffset, Width - xoffset) + 17) div 18 - (yoffset - Height + 1) div 9;
          k := k + 1;
        end;
      end
      else
        DrawMPic(0, pos.x, pos.y);
    end;

  //按照中点坐标排序
  //write(k);tic;
  {for i1 := 0 to k - 2 do
    for i2 := i1 + 1 to k - 1 do
    begin
      if BuildArray[i1].c > BuildArray[i2].c then
      begin
        tempb := BuildArray[i1];
        BuildArray[i1] := BuildArray[i2];
        BuildArray[i2] := tempb;
      end;
    end;}
  //快速排序
  QuickSortB(BuildArray, 0, k - 1);
  //toc;
  for i := 0 to k - 1 do
  begin
    Pos := GetPositionOnScreen(BuildArray[i].x, BuildArray[i].y, Mx, My);
    DrawMPic(BuildArray[i].b, pos.x, pos.y);
  end;

  DrawClouds;
  if HaveText = 1 then
    CleanTextScreen;

end;

//画场景到屏幕

procedure DrawScence;
var
  x, y, xpoint, ypoint, axp, ayp, i, i1, i2, num, sum, widthregion, sumregion, cx1, cy1: integer;
  dest: TSDL_Rect;
  word: WideString;
  pos: Tposition;
begin
  //DrawScenceWithoutRole(Sx, Sy);
  //先画无主角的场景, 再画主角
  //如在事件中, 则以Cx, Cy为中心, 否则以主角坐标为中心

  if (CurEvent < 0) then
  begin
    Cx1 := Sx;
    Cy1 := Sy;
  end
  else
  begin
    Cx1 := Cx;
    Cy1 := Cy;
  end;

  widthregion := CENTER_X div 36 + 3;
  sumregion := CENTER_Y div 9;
  if ShowBlackScreen then
  begin
    widthregion := 100 div 36 + 3;
    sumregion := 100 div 9;
  end;
  LoadGroundTex(cx1, cy1);
  for sum := -sumregion to sumregion + 2 do
    for i := -Widthregion to Widthregion do
    begin
      i1 := Cx1 + i + (sum div 2);
      i2 := Cy1 - i + (sum - sum div 2);
      if (i1 >= -64) and (i1 <= 127) and (i2 >= -64) and (i2 <= 127) then
      begin
        num := ExGroundS[i1, i2] div 2;
        if (num > 0) and (SPNGIndex[num].Frame > 1) then
        begin
          Pos := GetPositionOnScreen(i1, i2, Cx1, Cy1);
          DrawSPic(num, pos.x, pos.y);
        end;
      end;
    end;

  for sum := -sumregion to sumregion + 15 do
    for i := -Widthregion to Widthregion do
    begin
      i1 := Cx1 + i + (sum div 2);
      i2 := Cy1 - i + (sum - sum div 2);
      if (i1 >= 0) and (i1 <= 63) and (i2 >= 0) and (i2 <= 63) then
      begin
        Pos := GetPositionOnScreen(i1, i2, Cx1, Cy1);

        if SData[CurScence, 4, i1, i2] > 0 then
        begin
          num := SData[CurScence, 0, i1, i2] div 2;
          if num > 0 then
            DrawSPic(num, pos.x, pos.y);
        end;
        if (SData[CurScence, 1, i1, i2] > 0) {and (SData[CurScence, 4, i1, i2] > 0)} then
        begin
          num := SData[CurScence, 1, i1, i2] div 2;
          //if num > 0 then
          DrawSPic(num, pos.x, pos.y - SData[CurScence, 4, i1, i2]);
        end;
        if showMR and (i1 = Sx) and (i2 = Sy) then
          DrawSPic(CurScenceRolePic, pos.x, pos.y - SData[CurScence, 4, i1, i2]);
        if (SData[CurScence, 2, i1, i2] > 0) then
        begin
          num := SData[CurScence, 2, i1, i2] div 2;
          //if num > 0 then
          DrawSPic(num, pos.x, pos.y - SData[CurScence, 5, i1, i2]);
        end;
        if (SData[CurScence, 3, i1, i2] >= 0) then
        begin
          num := DData[CurScence, SData[CurScence, 3, i1, i2], 5] div 2;
          if num > 0 then
            DrawSPic(num, pos.x, pos.y - SData[CurScence, 4, i1, i2]);
        end;
      end;
    end;

  {if (CurEvent < 0) then
  begin
    DrawScenceWithoutRole(Sx, Sy);
    DrawRoleOnScence(Sx, Sy);
  end
  else
  begin
    DrawScenceWithoutRole(Cx, Cy);
    if (DData[CurScence, CurEvent, 10] = Sx) and (DData[CurScence, CurEvent, 9] = Sy) then
    begin
      if DData[CurScence, CurEvent, 5] <= 0 then
      begin
        DrawRoleOnScence(Cx, Cy);
      end;
    end
    else
      DrawRoleOnScence(Cx, Cy);
  end;}

  if (CurScence = 71) and (MODVersion = 13) then
  begin
    word := formatfloat('0', TimeInWater div 60) + ':' + formatfloat('00', TimeInWater mod 60);
    DrawShadowText(@word[1], 5, 5, ColColor(5), ColColor(7));
    if (time <= 0) then
    begin
      instruct_15;
    end;
  end;
  if ShowBlackScreen then
    DrawBlackScreen;
  if HaveText = 1 then
    CleanTextScreen;
  //if (blackscreen > 0) and (CurEvent > 0) then
  //DrawRectangleWithoutFrame(screen, 0, 0, screen.w, screen.h, 0, 100 - blackscreen * 10);

end;

//画不含主角的场景

procedure DrawScenceWithoutRole(x, y: integer);
var
  x1, y1: integer;
begin
  CalLTPosOnImageByCenter(x, y, x1, y1);
  //LoadScencePart(x1, y1);
  if ShowBlackScreen then
    DrawBlackScreen;
  if HaveText = 1 then
    CleanTextScreen;
end;

procedure DrawBlackScreen;
var
  i1, i2, x, y: integer;
  distance: real;
  alpha: byte;
  //这里画点应该用CPU
begin
  if SW_SURFACE = 0 then
  begin
    if BlackScreenTex = nil then
    begin
      BlackScreenTex := SDL_CreateTexture(render, SDL_PIXELFORMAT_ARGB8888, SDL_TEXTUREACCESS_TARGET,
        CENTER_X * 2, CENTER_Y * 2);
      SDL_SetRenderTarget(render, BlackScreenTex);
      SDL_SetRenderDrawBlendMode(render, SDL_BLENDMODE_NONE);
      SDL_SetRenderDrawColor(render, 0, 0, 0, 255);
      SDL_RenderFillRect(render, 0);
      for i1 := 0 to CENTER_X * 2 - 1 do
        for i2 := 0 to CENTER_Y * 2 - 1 do
        begin
          x := i1 - CENTER_X;
          y := i2 - CENTER_Y + 20;
          distance := (x * x + y * y) / 15625;
          if distance > 1 then
            alpha := 255
          else
          begin
            alpha := round(distance * 255);
            SDL_SetRenderDrawColor(render, 0, 0, 0, alpha);
            SDL_RenderDrawPoint(render, i1, i2);
          end;
          SDL_SetTextureBlendMode(BlackScreenTex, SDL_BLENDMODE_BLEND);
        end;
      SDL_SetRenderTarget(render, screenTex);
    end;
    SDL_RenderCopy(render, BlackScreenTex, nil, nil);
  end
  else
  begin
    if BlackScreenSur = nil then
    begin
      BlackScreenSur := SDL_CreateRGBSurface(0, CENTER_X * 2, CENTER_Y * 2, 32, RMASK, GMASK, BMASK, AMASK);
      SDL_FillRect(BlackScreenSur, nil, MapRGBA(0, 0, 0, 255));
      for i1 := 0 to CENTER_X * 2 - 1 do
        for i2 := 0 to CENTER_Y * 2 - 1 do
        begin
          x := i1 - CENTER_X;
          y := i2 - CENTER_Y + 20;
          distance := (x * x + y * y) / 15625;
          if distance > 1 then
            alpha := 255
          else
          begin
            alpha := round(distance * 255);
            PutPixel(BlackScreenSur, i1, i2, MapRGBA(0, 0, 0, alpha));
          end;
        end;
    end;
    SDL_UpperBlit(BlackScreenSur, nil, screen, nil);
  end;

end;


//画主角于场景

procedure DrawRoleOnScence(x, y: integer);
var
  i, xpoint, ypoint: integer;
  pos, pos1: TPosition;
begin
  if ShowMR then
  begin
    pos := GetPositionOnScreen(Sx, Sy, x, y);
    //DrawSPic(CurScenceRolePic, pos.x, pos.y - SData[CurScence, 4, Sx, Sy], 0, 100, CalBlock(Sx, Sy), 0, 0);
  end;
end;

procedure ExpandGroundOnImg();
var
  i1, i2, x, y, num: integer;
  Ex: array[-64..127, -64..127] of smallint;
begin
  fillchar(Ex, sizeof(Ex), -1);
  for i1 := 0 to 63 do
    for i2 := 0 to 63 do
    begin
      case where of
        1: Ex[i1, i2] := SData[CurScence, 0, i1, i2];
        2: Ex[i1, i2] := BField[0, i1, i2];
      end;
    end;
  //绝情谷, 明教地道效果比较奇怪, 屏蔽
  if (EXPAND_GROUND <> 0) and ((MODVersion <> 13) or ((CurScence <> 81) and (CurScence <> 72))) then
  begin
    for i1 := 31 downto -64 do
      for i2 := 0 to 63 do
      begin
        if Ex[i1, i2] <= 0 then
          Ex[i1, i2] := Ex[i1 + 1, i2];
      end;
    for i1 := 32 to 127 do
      for i2 := 0 to 63 do
      begin
        if Ex[i1, i2] <= 0 then
          Ex[i1, i2] := Ex[i1 - 1, i2];
      end;
    for i1 := -64 to 127 do
      for i2 := 31 downto -64 do
      begin
        if Ex[i1, i2] <= 0 then
          Ex[i1, i2] := Ex[i1, i2 + 1];
      end;
    for i1 := -64 to 127 do
      for i2 := 32 to 127 do
      begin
        if Ex[i1, i2] <= 0 then
          Ex[i1, i2] := Ex[i1, i2 - 1];
      end;
  end;
  //生成一整块地面纹理
  if SW_SURFACE = 0 then
  begin
    case where of
      1: SDL_SetRenderTarget(render, ImgSGroundTex);
      2: SDL_SetRenderTarget(render, ImgBGroundTex);
    end;
  end
  else
  begin
    case where of
      1: CurTargetSurface := ImgSGround;
      2: CurTargetSurface := ImgBGround;
    end;
  end;
  for i1 := -64 to 127 do
    for i2 := -64 to 127 do
    begin
      CalPosOnImage(i1, i2, x, y);
      num := Ex[i1, i2] div 2;
      if num > 0 then
        DrawSPic(num, x, y);
    end;
  SDL_SetRenderTarget(render, screenTex);
  CurTargetSurface := screen;
  case where of
    1: move(Ex, ExGroundS, sizeof(Ex));
    2: move(Ex, ExGroundB, sizeof(Ex));
  end;
end;

//Save the image informations of the whole scence.
//生成场景映像
//0-全部映像
//1-可见部分
//2-先刷新背景, 副线程专用

procedure InitialScence(Visible: integer = 0);
var
  i1, i2, x, y, x1, y1, w, h, num, mini, maxi, depth, sumi, j: integer;
  pos: TPosition;
  onback, now: uint32;
  dest: TSDL_Rect;
begin
  //改成仅载入图形
  for i1 := 0 to 63 do
    for i2 := 0 to 63 do
    begin
      for j := 0 to 2 do
      begin
        num := SData[CurScence, j, i1, i2] div 2;
        if (num > 0) and (num < SPicAmount) then
          LoadOnePNGTexture('resource/smap', pSPic, SPNGIndex[num]);
      end;
      if (SData[CurScence, 3, i1, i2] >= 0) then
      begin
        num := DData[CurScence, SData[CurScence, 3, i1, i2], 5] div 2;
        if (num > 0) and (num < SPicAmount) then
          LoadOnePNGTexture('resource/smap', pSPic, SPNGIndex[num]);
        {for num := DData[CurScence, SData[CurScence, 3, i1, i2], 7] div 2
          to DData[CurScence, SData[CurScence, 3, i1, i2], 6] div 2 do
          if  (num > 0) and (num<SPicAmount) then
          LoadOnePNGTexture('resource/smap', pSPic, num, SPNGIndex[num], @SPNGTex[0]);}
      end;
    end;
  ExpandGroundOnImg();
  if IsCave(CurScence) then
  begin
    ShowBlackScreen := True;
  end
  else
    ShowBlackScreen := False;
  {SDL_LockMutex(mutex);
  LoadingScence := True;

  if Visible = 0 then
  begin
    x1 := 0;
    y1 := 0;
    w := ImageWidth;
    h := ImageHeight;
    SDL_FillRect(ImgScence, nil, 1);
    SDL_FillRect(ImgScenceBack, nil, 1);
    ExpandGroundOnImg();
  end
  else
  begin
    if CurEvent >= 0 then
    begin
      CalLTPosOnImageByCenter(Cx, Cy, x1, y1);
    end
    else
    begin
      CalLTPosOnImageByCenter(Sx, Sy, x1, y1);
    end;
    w := screen.w;
    h := screen.h;
    if (PNG_LOAD_ALL = 0) and (LoadingTiles) then
    begin
      x1 := 0;
      y1 := 0;
      w := ImageWidth;
      h := ImageHeight;
    end;
  end;

  if (Visible > 0) and (where = 1) then
    onback := 1
  else
    onback := 0;

  if (Visible = 2) and IsCave(CurScence) then
  begin
    x1 := x1 + CENTER_X - 125;
    y1 := y1 + CENTER_Y - 125;
    w := 250;
    h := 250;
  end;

  for i1 := 0 to 63 do
    for i2 := 0 to 63 do
    begin
      CalPosOnImage(i1, i2, x, y);
      if (SData[CurScence, 4, i1, i2] <= 0) then
      begin
        num := SData[CurScence, 0, i1, i2] div 2;
        if num > 0 then
          InitialSPic(num, x, y, x1, y1, w, h, 1, 0, onback);
      end;
    end;
  for sumi := 0 to 126 do
  begin
    for i1 := 63 downto 0 do
    begin
      i2 := sumi - i1;
      if (i2 >= 0) and (i2 <= 63) then
        InitialScenceOnePosition(i1, i2, x1, y1, w, h, CalBlock(i1, i2), onback);
    end;
  end;

  if (Visible > 0) and (where = 1) and (x1 >= 0) and (y1 >= 0) then
  begin
    //遮挡值仅更新主角附近的即可
    CalPosOnImage(Sx, Sy, x, y);
    x := x - 36;
    y := y - 100;
    for i1 := x to x + 72 do
      //for i2:=y to y+100 do
    begin
      num := i1 * ImageHeight + y;
      //blockImg[num]:=blockImg2[num];
      move(BlockImg2[num], BlockImg[num], 200);
    end;
    //Move(BlockImg2[0], BlockImg[0], sizeof(BlockImg[0])*length(BlockImg));
    dest.x := x1;
    dest.y := y1;
    dest.w := w;
    dest.h := h;
    SDL_BlitSurface(ImgScenceBack, @dest, ImgScence, @dest);
  end;
  LoadingScence := False;
  SDL_UnLockMutex(mutex);}
end;


function CalBlock(x, y: integer): integer;
begin
  //Result := 128 * min(x, y) + abs(x - y);
  //Result := 8192 - (x - 64) * (x - 64) - (y - 64) * (y - 64);
  Result := 128 * (x + y) + y;
end;

procedure CalPosOnImage(i1, i2: integer; var x, y: integer);
begin
  x := -i1 * 18 + i2 * 18 + ImageWidth div 2;
  y := i1 * 9 + i2 * 9 + 9 + CENTER_Y;
end;

procedure CalLTPosOnImageByCenter(i1, i2: integer; var x, y: integer);
begin
  x := -i1 * 18 + i2 * 18 + ImageWidth div 2 - CENTER_X;
  y := i1 * 9 + i2 * 9 + 9;
  if needOffset <> 0 then
  begin
    x := x + offsetX;
    y := y + offsetY;
  end;
end;


//画战场

procedure DrawBField();
var
  sumi, i, i1, i2, num, picnum, widthregion, sumregion, sum, x, y: integer;
  pos: tposition;
begin
  widthregion := CENTER_X div 36 + 3;
  sumregion := CENTER_Y div 9;
  LoadGroundTex(Bx, By);
  for sum := -sumregion to sumregion + 15 do
    for i := -Widthregion to Widthregion do
    begin
      i1 := Bx + i + (sum div 2);
      i2 := By - i + (sum - sum div 2);
      if (i1 >= -63) and (i1 <= 127) and (i2 >= -63) and (i2 <= 127) then
      begin
        Pos := GetPositionOnScreen(i1, i2, Bx, By);
        num := ExGroundB[i1, i2] div 2;

        //重画闪烁的地面贴图
        if (num > 0) and (SPNGIndex[num].Frame > 1) then
          DrawSPic(num, pos.x, pos.y);

        //建筑和人物
        if (i1 >= 0) and (i1 <= 63) and (i2 >= 0) and (i2 <= 63) then
        begin
          num := BField[1, i1, i2] div 2;
          if num > 0 then
          begin
            DrawSPic(num, pos.x, pos.y);
          end;
          num := BField[2, i1, i2];
          if num >= 0 then
          begin
            if Brole[num].Pic > 0 then
              picnum := Brole[num].Pic
            else
              picnum := Brole[num].StaticPic[Brole[num].Face];
            DrawFPic(picnum, pos.x, pos.y, Rrole[Brole[num].rnum].ActionNum,
              Brole[num].shadow, Brole[num].alpha, Brole[num].mixColor, Brole[num].mixAlpha);
          end;
        end;
      end;
    end;

  {for sumi := 0 to 126 do
  begin
    for i1 := 63 downto 0 do
    begin
      i2 := sumi - i1;
      if (i2 >= 0) and (i2 <= 63) then
      begin
           pos := GetPositionOnScreen(i1, i2, Bx, By);
        num:= bfield[0, i1, i2] div 2;
         if num >0 then  DrawSPic(num, pos.x, pos.y);
        num:= bfield[1, i1, i2] div 2;
         if num >0 then
           DrawSPic(num, pos.x, pos.y);
      end;
    end;
  end;}
  {DrawBfieldWithoutRole(Bx, By);

  for i1 := 0 to 63 do
    for i2 := 0 to 63 do
    begin
      if (Bfield[2, i1, i2] >= 0) and (Brole[Bfield[2, i1, i2]].Dead = 0) then
        DrawRoleOnBfield(i1, i2);
    end;}

  DrawProgress;
  CleanTextScreen;

end;

//画不含主角的战场

procedure DrawBfieldWithoutRole(x, y: integer);
var
  x1, y1: integer;
begin
  //CalLTPosOnImageByCenter(x, y, x1, y1);
  //LoadBfieldPart(x1, y1);

end;

//画战场上人物, 需更新人物身前的遮挡

procedure DrawRoleOnBfield(x, y: integer; mixColor: uint32 = 0; mixAlpha: integer = 0; Alpha: integer = 75);
var
  i1, i2, depth, bnum, picnum: integer;
  pos: Tposition;
begin
  {pos := GetPositionOnScreen(x, y, Bx, By);
  depth := CalBlock(x, y);
  bnum := Bfield[2, x, y];
  if Brole[bnum].Pic > 0 then
    picnum := Brole[bnum].Pic
  else
    picnum := Brole[bnum].StaticPic[Brole[bnum].Face];
  DrawFPic(picnum, pos.x, pos.y, Rrole[Brole[bnum].rnum].ActionNum, 0, Alpha, depth, mixColor, mixAlpha);}

end;

//初始化战场映像
//0-地面, 1-建筑, 2-全部
procedure InitialBFieldImage(layer: integer = 2);
var
  sumi, i1, i2, j, num: integer;
begin
  //FillChar(BlockImg2[0], sizeof(BlockImg2[0]) * length(BlockImg2), -1);
  //SDL_FillRect(ImgBField, nil, 0);
  //SDL_FillRect(ImgBBuild, nil, 1);
  for i1 := 0 to 63 do
    for i2 := 0 to 63 do
    begin
      for j := 0 to 2 do
      begin
        num := BField[j, i1, i2] div 2;
        if (num > 0) and (num < SPicAmount) then
          LoadOnePNGTexture('resource/smap', pSPic, SPNGIndex[num]);
      end;
    end;
  ExpandGroundOnImg();
  {for sumi := 0 to 126 do
  begin
    //InitialBFieldPosition(mini, mini, CalBlock(mini, mini));
    for i1 := 63 downto 0 do
    begin
      //InitialBFieldPosition(maxi, mini, CalBlock(maxi, mini));
      //InitialBFieldPosition(mini, maxi, CalBlock(mini, maxi));
      i2 := sumi - i1;
      if (i2 >= 0) and (i2 <= 63) then
        InitialBFieldPosition(i1, i2, CalBlock(i1, i2), layer);
    end;
  end;}

end;



//画带光标的子程
//此子程效率不高

procedure DrawBFieldWithCursor(AttAreaType, step, range: integer);
var
  i, i1, i2, bnum, minstep, shadow, mixAlpha, x, y, num: integer;
  mixColor: uint32;
  pos: TPosition;
  HighLight: boolean;
begin
  {SDL_FillRect(screen, nil, 0);
  CalLTPosOnImageByCenter(Bx, By, x, y);
  LoadBfieldPart(x, y, 1);
  TransBlackScreen;}
  CleanTextScreen;
  if SW_SURFACE = 0 then
    SDL_SetTextureColorMod(ImgBGroundTex, 128, 128, 128)
  else
    SDL_SetSurfaceColorMod(ImgBGround, 128, 128, 128);
  LoadGroundTex(Bx, By);
  if SW_SURFACE = 0 then
    SDL_SetTextureColorMod(ImgBGroundTex, 255, 255, 255)
  else
    SDL_SetSurfaceColorMod(ImgBGround, 255, 255, 255);
  SetAminationPosition(AttAreaType, step, range);
  for i1 := 0 to 63 do
    for i2 := 0 to 63 do
    begin
      if BField[0, i1, i2] > 0 then
      begin
        pos := GetPositionOnScreen(i1, i2, Bx, By);
        shadow := 0;
        case AttAreaType of
          0: //目标系点型(用于移动、点攻、用毒、医疗等)、目标系十型、目标系菱型、原地系菱型
          begin
            if BField[4, i1, i2] > 0 then
              shadow := 1
            else if (abs(i1 - Bx) + abs(i2 - By) <= step) and (BField[3, i1, i2] >= 0) then
              shadow := 0
            else
              shadow := -1;
          end;
          1: //方向系线型
          begin
            if BField[4, i1, i2] > 0 then
              shadow := 1
            else if ((i1 = Bx) and (abs(i2 - By) <= step)) or ((i2 = By) and (abs(i1 - Bx) <= step)) then
              shadow := 0
            else
              shadow := -1;
          end;
          2: //原地系十型、原地系叉型、原地系米型
          begin
            if BField[4, i1, i2] > 0 then
              shadow := 1
            else
              shadow := -1;
          end;
          3: //目标系方型、原地系方型
          begin
            if BField[4, i1, i2] > 0 then
              shadow := 1
            else if (abs(i1 - Bx) + abs(i2 - By) <= step) and (BField[0, i1, i2] >= 0) then
              shadow := 0
            else
              shadow := -1;
          end;
          4: //方向系菱型
          begin
            if BField[4, i1, i2] > 0 then
              shadow := 1
            else if (abs(i1 - Bx) + abs(i2 - By) <= step) and (abs(i1 - Bx) <> abs(i2 - By)) then
              shadow := 0
            else
              shadow := -1;
          end;
          5: //方向系角型
          begin
            if BField[4, i1, i2] > 0 then
              shadow := 1
            else if (abs(i1 - Bx) <= step) and (abs(i2 - By) <= step) and (abs(i1 - Bx) <> abs(i2 - By)) then
              shadow := 0
            else
              shadow := -1;
          end;
          6: //远程
          begin
            minstep := 3;
            if BField[4, i1, i2] > 0 then
              shadow := 1
            else if (abs(i1 - Bx) + abs(i2 - By) <= step) and (abs(i1 - Bx) + abs(i2 - By) > minstep) and
              (BField[3, i1, i2] >= 0) then
              shadow := 0
            else
              shadow := -1;
          end;
        end;
        if shadow = 0 then
          DrawSPic(BField[0, i1, i2] div 2, pos.x, pos.y, nil, shadow, 0, 0, 0);
        if shadow > 0 then
        begin
          DrawSPic(BField[0, i1, i2] div 2, pos.x, pos.y, nil, shadow, 0, 0, 0);
          //DrawMPic(1, pos.x, pos.y, 0, 0, 0, 0, 50);
        end;
      end;
    end;

  //LoadBFieldPart2(x, y, 30);

  for i1 := 0 to 63 do
    for i2 := 0 to 63 do
    begin
      pos := GetPositionOnScreen(i1, i2, Bx, By);
      if BField[1, i1, i2] > 0 then
        DrawSPic(BField[1, i1, i2] div 2, pos.x, pos.y, nil, 0, 30, 0, 0);
      bnum := BField[2, i1, i2];
      if (bnum >= 0) and (Brole[bnum].Dead = 0) then
      begin
        HighLight := False;
        //0-范围内敌方, 1-范围内我方, 2-敌方全部, 3-我方全部, 4-自身, 5-范围内全部, 6-全部, 7-不高亮
        case SelectAimMode of
          0: HighLight := (BField[4, i1, i2] > 0) and (Brole[bnum].Team <> 0);
          1: HighLight := (BField[4, i1, i2] > 0) and (Brole[bnum].Team = 0);
          2: HighLight := Brole[bnum].Team <> 0;
          3: HighLight := Brole[bnum].Team = 0;
          4: HighLight := (i1 = Bx) and (i2 = By);
          5: HighLight := (BField[4, i1, i2] > 0);
          6: HighLight := True;
          7: HighLight := False;
        end;

        mixColor := $FFFFFFFF;
        if highlight then
        begin
          mixAlpha := 20;
          shadow := 1;
        end
        else
        begin
          mixAlpha := 0;
          shadow := 0;
        end;
        DrawFPic(Brole[bnum].StaticPic[Brole[bnum].Face], pos.x, pos.y, Rrole[Brole[bnum].rnum].ActionNum,
          shadow, 0, mixColor, mixAlpha);
        HighLight := False;
      end;
    end;

end;

procedure DrawBFieldWithEft(Epicnum, beginpic, endpic, curlevel, bnum, SelectAimMode, flash: integer;
  mixColor: uint32; index: integer = 0; shadow: integer = 0; alpha: integer = 0; MixColor2: uint32 = 0;
  MixAlpha2: integer = 0); overload;
var
  k, i, t, i1, i2, rnum: integer;
  pos: TPosition;
begin
  //flash-闪烁颜色, 未处理
  if needOffset <> 0 then
  begin
    offsetX := random(5);
    offsetY := random(5);
  end;
  rnum := Brole[bnum].rnum;
  for i := 0 to BRoleAmount - 1 do
  begin
    //检测是否需要高亮
    t := 0;
    if (BField[4, Brole[i].X, Brole[i].Y] > 0) then
      if CanSelectAim(bnum, i, -1, SelectAimMode) then
        t := 1;
    if t = 1 then
    begin
      Brole[i].shadow := 1;
      Brole[i].mixColor := $FFFFFFff;
      Brole[i].mixAlpha := t * (10 + random(40));
    end;
  end;

  DrawBfield;
  for i1 := 0 to 63 do
    for i2 := 0 to 63 do
    begin
      if (BField[4, i1, i2] > 0) then
      begin
        pos := GetPositionOnScreen(i1, i2, Bx, By);
        k := Epicnum + curlevel - BField[4, i1, i2];
        if (k >= beginpic) and (k <= endpic) then
        begin
          //以下选择颜色
          shadow := 0;
          case Rrole[rnum].MPType of
            {0:
            begin
              MixColor2 := MapRGBA(255, 200, 64);
              MixAlpha2 := -1 * random(2);
            end;
            1:
            begin
              MixColor2 := MapRGBA(243, 128, 255);
              MixAlpha2 := -1 * random(2);
            end;}
            2:
            begin
              MixColor2 := $FFFFFFFF;
              MixAlpha2 := random(2) * 20 * Rrole[rnum].CurrentMP div MAX_MP;
              shadow := 1;
            end;
            3:
            begin
              MixColor2 := MapRGBA(64, 64, 64);
              MixAlpha2 := -1 * random(2);
            end;
            else
            begin
              MixColor2 := 0;
              MixAlpha2 := 0;
            end;
          end;
          if Rrole[rnum].AttPoi > 0 then
          begin
            MixColor2 := MapRGBA(255 - Rrole[rnum].AttPoi * 2, 255, 255 - Rrole[rnum].AttPoi * 2);
            MixAlpha2 := -1 * random(2);
          end;
          DrawEPic(k, pos.x, pos.y, shadow, 25, MixColor2, MixAlpha2, index);
        end;
      end;
    end;
  for i := 0 to BRoleAmount - 1 do
  begin
    Brole[i].shadow := 0;
    Brole[i].mixColor := 0;
    Brole[i].mixAlpha := 0;
  end;
  //needOffset := 0;
  offsetX := 0;
  offsetY := 0;

end;


//画带人物动作的战场

procedure DrawBFieldWithAction(bnum, Apicnum: integer);
var
  i, i1, i2: integer;
  pos: TPosition;
begin
  Brole[bnum].Pic := Apicnum;
  DrawBField;

end;


//绘制云

procedure DrawClouds;
var
  i, x, y: integer;
begin
  for i := 0 to CLOUD_AMOUNT - 1 do
  begin
    x := Cloud[i].Positionx - (-Mx * 18 + My * 18 + 8640 - CENTER_X);
    y := Cloud[i].Positiony - (Mx * 9 + My * 9 + 9 - CENTER_Y);
    DrawCPic(Cloud[i].Picnum, x, y, Cloud[i].Shadow, Cloud[i].Alpha, Cloud[i].mixColor, Cloud[i].mixAlpha);
  end;

end;

//显示半即时进度

procedure DrawProgress;
var
  i, j, x, y, curHead, temp: integer;
  mixColor: uint32;
  dest: TSDL_Rect;
  range, p: array of integer;
begin
  if SEMIREAL = 1 then
  begin
    x := CENTER_X - 180;
    y := CENTER_Y * 2 - 70;
    //DrawRectangleWithoutFrame(screen, 0, CENTER_Y * 2 - 50, CENTER_X * 2, 50, 0, 50);
    DrawMPic(2014, x - 150, y - 10);

    setlength(range, BRoleAmount);
    setlength(p, BRoleAmount);
    curHead := 0;
    for i := 0 to BRoleAmount - 1 do
    begin
      range[i] := i;
      p[i] := Brole[i].RealProgress * 480 div 10000;
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
        DrawHeadPic(Rrole[Brole[range[i]].rnum].HeadNum, p[i] + x, y, 0, 0, 0, 0, 0.25, 0.25);
        {if (BField[4, Brole[range[i]].X, Brole[range[i]].Y] > 0) and
          (Brole[BField[2, Bx, By]].Team <> Brole[range[i]].Team) then
          mixColor := MapRGBA(200, 50, 50)
        else
          mixColor := MapRGBA(255, 255, 255);
        DrawHeadPic(Rrole[Brole[range[i]].rnum].HeadNum, p[i] + x, y, 0, 0, mixColor, -1, 0.25, 0.25);}
      end;
  end;
end;

//画动态光标, 只能是M图片

procedure DrawMultiFramePic(num, x, y, time: integer);
var
  tempsur: PSDL_Surface;
  rect: TSDL_Rect;
begin
  //tempsur := ;
end;

procedure LoadGroundTex(x, y: integer);
var
  dest: TSDL_Rect;
begin
  CalLTPosOnImageByCenter(x, y, dest.x, dest.y);
  dest.w := CENTER_X * 2;
  dest.h := CENTER_Y * 2;
  if SW_SURFACE = 0 then
  begin
    case where of
      1: SDL_RenderCopy(render, ImgSGroundTex, @dest, nil);
      2: SDL_RenderCopy(render, ImgBGroundTex, @dest, nil);
    end;
  end
  else
  begin
    case where of
      1: SDL_UpperBlit(ImgSGround, @dest, screen, nil);
      2: SDL_UpperBlit(ImgBGround, @dest, screen, nil);
    end;
  end;
end;

function DrawTextFrame(x, y: integer; len: integer; alpha: integer = 0; mixColor: uint32 = 0;
  mixAlpha: integer = 0): integer;
var
  j: integer;
begin
  DrawMPic(2141, x, y, 0, 0, alpha, mixColor, mixAlpha);
  for j := 0 to len - 1 do
  begin
    DrawMPic(2142, x + 19 + j * 20, y, 0, 0, alpha, mixColor, mixAlpha);
  end;
  DrawMPic(2143, x + 19 + len * 20, y, 0, 0, alpha, mixColor, mixAlpha);
  Result := 19;
end;

//显示带边框的文字, 仅用于unicode, 需自定义宽度
//默认情况为透明度50, 立即刷新

procedure DrawTextWithRect(word: puint16; x, y, w: integer; color1, color2: uint32;
  alpha: integer = 0; Refresh: integer = 1);
var
  len, j: integer;
  p: pchar;
begin
  //DrawRectangle(x, y, w, 26, 0, ColColor(255), alpha);
  len := (DrawLength(pWideChar(word)) + 1) div 2;
  DrawTextFrame(x, y, len, alpha);
  DrawShadowText(word, x + 19, y + 3, color1, color2);
  if Refresh <> 0 then
    UpdateAllScreen;
  //SDL_UpdateRect2(screen, x, y, w + 1, 29);

end;

end.
