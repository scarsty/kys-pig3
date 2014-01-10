unit kys_draw;

interface

uses
{$IFDEF fpc}
  FileUtil,
{$ENDIF}
{$IFDEF mswindows}
  Windows,
{$ENDIF}
  SysUtils,
  SDL_image,
  SDL,
  Math,
  kys_type,
  kys_main,
  kys_event;


//画单个图片的子程
procedure DrawPic(sur: PSDL_Surface; Pictype, num, px, py, shadow, alpha: integer; mixColor: uint32;
  mixAlpha: integer);
procedure DrawTitlePic(imgnum, px, py: integer; shadow: integer = 0; Alpha: integer = 0;
  mixColor: uint32 = 0; mixAlpha: integer = 0);
procedure DrawMPic(num, px, py: integer; Framenum: integer = -1); overload;
procedure DrawMPic(num, px, py, shadow, alpha: integer; mixColor: uint32; mixAlpha: integer;
  Framenum: integer = -1); overload;
procedure DrawSPic(num, px, py: integer); overload;
procedure DrawSPic(num, px, py, x, y, w, h: integer); overload;
procedure DrawSPic(num, px, py, shadow, alpha, depth: integer; mixColor: uint32; mixAlpha: integer); overload;
procedure InitialSPic(num, px, py, x, y, w, h: integer); overload;
procedure InitialSPic(num, px, py, x, y, w, h, needBlock, depth: integer); overload;
procedure InitialSPic(num, px, py, x, y, w, h, needBlock, depth, temp: integer); overload;
procedure DrawHeadPic(num, px, py: integer); overload;
procedure DrawHeadPic(num, px, py: integer; scr: PSDL_Surface); overload;
procedure DrawHeadPic(num, px, py, shadow, alpha: integer; mixColor: uint32; mixAlpha: integer); overload;
procedure DrawBPic(num, px, py, shadow: integer); overload;
procedure DrawBPic(num, px, py, shadow, alpha, depth: integer; mixColor: uint32; mixAlpha: integer); overload;
procedure DrawBPicInRect(num, px, py, shadow, x, y, w, h: integer);
procedure InitialBPic(num, px, py: integer); overload;
procedure InitialBPic(num, px, py, needBlock, depth: integer); overload;
procedure DrawEPic(num, px, py: integer; index: integer = 0); overload;
procedure DrawEPic(num, px, py, shadow, alpha, depth: integer; mixColor: uint32; mixAlpha: integer;
  index: integer = 0); overload;
procedure DrawFPic(num, px, py, index: integer); overload;
procedure DrawFPic(num, px, py, index, shadow, alpha, depth: integer; mixColor: uint32; mixAlpha: integer); overload;
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
procedure InitialScenceOnePosition(i1, i2, x1, y1, w, h, depth, temp: integer);
procedure LoadScencePart(x, y: integer);
procedure DrawBField();
procedure DrawBfieldWithoutRole(x, y: integer);
procedure DrawRoleOnBfield(x, y: integer; mixColor: uint32 = 0; mixAlpha: integer = 0; Alpha: integer = 75);
procedure InitialBFieldImage(layer: integer = 2);
procedure InitialBFieldPosition(i1, i2, depth: integer; layer: integer = 2);
procedure LoadBfieldPart(x, y: integer; noBuild: integer = 0);
procedure LoadBFieldPart2(x, y, alpha: integer);
procedure DrawBFieldWithCursor(AttAreaType, step, range: integer);
procedure DrawBlackScreen;
procedure DrawBFieldWithEft(Epicnum: integer; index: integer = 0); overload;
procedure DrawBFieldWithEft(Epicnum, beginpic, endpic, curlevel, bnum, SelectAimMode, flash: integer;
  mixColor: uint32; index: integer = 0; MixColor2: uint32 = 0; MixAlpha2: integer = 0); overload;
procedure DrawBFieldWithAction(bnum, Apicnum: integer);
procedure DrawClouds;
procedure DrawProgress;

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
  if sur = nil then
    sur := screen;
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
      DrawPNGTile(PNGIndex, 0, nil, screen, px, py, shadow, Alpha, mixColor, mixAlpha);
    end;
  end;
end;

//显示title.grp的内容(即开始的选单)

procedure DrawTitlePic(imgnum, px, py: integer; shadow: integer = 0; Alpha: integer = 0;
  mixColor: uint32 = 0; mixAlpha: integer = 0);
var
  len, grp, idx: integer;
  Area: TSDL_Rect;
  BufferIdx: TIntArray;
  BufferPic: TByteArray;
begin
  if PNG_TILE > 0 then
  begin
    if imgnum <= high(TitlePNGIndex) then
      DrawPNGTile(TitlePNGIndex[imgnum], 0, nil, screen, px, py, shadow, Alpha, mixColor, mixAlpha);
  end;
  if PNG_TILE = 0 then
  begin
    len := LoadIdxGrp('resource/title.idx', 'resource/title.grp', BufferIdx, BufferPic);
    Area.x := 0;
    Area.y := 0;
    Area.w := screen.w;
    Area.h := screen.h;
    if imgnum < len then
      DrawRLE8Pic(@ACol[0], imgnum, px, py, @BufferIdx[0], @BufferPic[0], @Area, nil, 0, 0, 0, 0);
  end;
end;

//显示主地图贴图

procedure DrawMPic(num, px, py: integer; Framenum: integer = -1); overload;
begin
  DrawMPic(num, px, py, 0, 0, 0, 0, Framenum);
end;

//显示主地图贴图

procedure DrawMPic(num, px, py, shadow, alpha: integer; mixColor: uint32; mixAlpha: integer;
  Framenum: integer = -1); overload;
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
          LoadOnePNGTile('resource/mmap/', pMPic, num, MPNGIndex[num], @MPNGTile[0]);
      DrawPNGTile(MPNGIndex[num], Framenum, nil, screen, px, py, shadow, alpha, mixColor, mixAlpha,
        4096, nil, 0, 0, 0, 0, 0);
    end;
    if (PNG_TILE = 0) then
    begin
      DrawRLE8Pic(@ACol[0], num, px, py, @Midx[0], @Mpic[0], nil, nil, 0, 0, 0, shadow, alpha,
        nil, nil, 0, 0, 0, 4096, mixColor, mixAlpha);
    end;
  end;
end;

//显示场景图片

procedure DrawSPic(num, px, py: integer); overload;
begin
  DrawSPic(num, px, py, 0, 0, 0, 0);
end;

procedure DrawSPic(num, px, py, x, y, w, h: integer); overload;
var
  Area: TSDL_Rect;
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
          LoadOnePNGTile('resource/smap/', pSPic, num, SPNGIndex[num], @SPNGTile[0]);
      DrawPNGTile(SPNGIndex[num], 0, nil, screen, px, py);
    end
    else
    begin
      Area.x := x;
      Area.y := y;
      Area.w := w;
      Area.h := h;
      DrawRLE8Pic(@ACol[0], num, px, py, @SIdx[0], @SPic[0], @Area, nil, 0, 0, 0, 0);
    end;
  end;
end;

//画考虑遮挡的内场景

procedure DrawSPic(num, px, py, shadow, alpha, depth: integer; mixColor: uint32; mixAlpha: integer); overload;
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
          LoadOnePNGTile('resource/smap/', pSPic, num, SPNGIndex[num], @SPNGTile[0]);
      DrawPNGTile(SPNGIndex[num], 0, nil, screen, px, py, shadow, alpha, mixColor, mixAlpha,
        depth, @BlockImg[0], ImageWidth, ImageHeight, sizeof(BlockImg[0]),
        BlockScreen.x, BlockScreen.y);
    end
    else
    begin
      DrawRLE8Pic(@ACol[0], num, px, py, @SIdx[0], @SPic[0], nil, nil, 0, 0, 0, shadow, alpha,
        @BlockImg[0], @BlockScreen, ImageWidth, ImageHeight, sizeof(BlockImg[0]),
        depth, mixColor, mixAlpha);
    end;
  end;

end;

//将场景图片信息画到映像

procedure InitialSPic(num, px, py, x, y, w, h: integer); overload;
begin
  InitialSPic(num, px, py, x, y, w, h, 0, 0, 0);

end;

//画到映像并记录深度数据

procedure InitialSPic(num, px, py, x, y, w, h, needBlock, depth: integer); overload;
begin
  InitialSPic(num, px, py, x, y, w, h, needBlock, depth, 0);

end;

procedure InitialSPic(num, px, py, x, y, w, h, needBlock, depth, temp: integer); overload;
var
  Area: TSDL_Rect;
  pImg: PSDL_Surface;
  pBlock: pchar;
  f: integer;
begin
  if (num >= 0) and (num < SPicAmount) then
  begin
    if temp = 0 then
    begin
      pImg := ImgScence;
      pBlock := @BlockImg[0];
    end
    else
    begin
      pImg := ImgScenceBack;
      pBlock := @BlockImg2[0];
    end;
    if x + w > ImageWidth then
      w := ImageWidth - x - 1;
    if y + h > ImageHeight then
      h := ImageHeight - y - 1;
    Area.x := x;
    Area.y := y;
    Area.w := w;
    Area.h := h;
    if num = 1941 then
    begin
      num := 0;
      py := py - 50;
    end;
    if (PNG_TILE > 0) then
    begin
      if temp <> 1 then
        if PNG_LOAD_ALL = 0 then
          if SPNGIndex[num].Loaded = 0 then
            LoadOnePNGTile('resource/smap', pSPic, num, SPNGIndex[num], @SPNGTile[0]);
      f := SDL_GetTicks div 300 + random(3);
      DrawPNGTile(SPNGIndex[num], f, @Area, pImg, px, py);
      if needBlock <> 0 then
      begin
        SetPNGTileBlock(SPNGIndex[num], f, px, py, depth, pBlock, ImageWidth, ImageHeight,
          sizeof(BlockImg[0]));
      end;
    end
    else
    begin
      if needBlock <> 0 then
      begin
        DrawRLE8Pic(@ACol[0], num, px, py, @SIdx[0], @SPic[0], @Area, pImg, ImageWidth, ImageHeight,
          sizeof(BlockImg[0]), 0, 0, pBlock, nil, 0, 0, 0, depth, 0, 0);
      end
      else
        DrawRLE8Pic(@ACol[0], num, px, py, @SIdx[0], @SPic[0], @Area, pImg, ImageWidth,
          ImageHeight, sizeof(BlockImg[0]), 0);
    end;
  end;
end;

//显示头像, 优先考虑'.head/'目录下的png图片

procedure DrawHeadPic(num, px, py: integer); overload;
begin
  DrawHeadPic(num, px, py, 0, 0, 0, 0);
end;

procedure DrawHeadPic(num, px, py: integer; scr: PSDL_Surface); overload;
var
  image: PSDL_Surface;
  dest: TSDL_Rect;
  str: string;
  Area: TSDL_Rect;
  offset: integer;
  y: smallint;
begin
  str := AppPath + 'resource/head/' + IntToStr(num) + '.png';
  if FileExistsUTF8(str) then
  begin
    image := IMG_Load(PChar(str));
    dest.x := px;
    dest.y := py;
    SDL_BlitSurface(image, nil, scr, @dest);
    SDL_FreeSurface(image);
  end
  else
  begin
    if scr = screen then
      DrawHeadPic(num, px, py)
    else
    begin
      if PNG_LOAD_ALL = 0 then
        if HPNGIndex[num].Loaded = 0 then
          LoadOnePNGTile('resource/head', pHPic, num, HPNGIndex[num], @HPNGTile[0]);
      DrawPNGTile(HPNGIndex[num], 0, nil, scr, 0, 0);
    end;
    {Area.x := 0;
    Area.y := 0;
    Area.w := scr.w;
    Area.h := scr.h;
    offset := 0;
    if num > 0 then
      offset := HIdx[num - 1];
    y := Psmallint(@HPic[offset + 6])^;
    //showmessage(inttostr(y));
    DrawRLE8Pic(@ACol1[0], num, px, py + y, @HIdx[0], @HPic[0], @Area, scr, scr.w, scr.h, 0,
      0, 0, nil, nil, 0, 0, 0, 0, 0, 0);}
  end;
end;

procedure DrawHeadPic(num, px, py, shadow, alpha: integer; mixColor: uint32; mixAlpha: integer); overload;
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
          LoadOnePNGTile('resource/head', pHPic, num, HPNGIndex[num], @HPNGTile[0]);
      DrawPNGTile(HPNGIndex[num], 0, nil, screen, px, py, shadow, alpha, mixColor, mixAlpha,
        0, nil, 0, 0, 0, 0, 0);
    end;
    if PNG_TILE = 0 then
    begin
      DrawRLE8Pic(@ACol[0], num, px, py, @HIdx[0], @HPic[0], nil, nil, 0, 0, 0, shadow, alpha,
        nil, nil, 0, 0, 0, 0, mixColor, mixAlpha);
    end;
  end;

end;

//显示战场图片

procedure DrawBPic(num, px, py, shadow: integer); overload;
begin
  DrawBPic(num, px, py, shadow, 0, 0, 0, 0);

end;

//用于画带透明度和遮挡的战场图

procedure DrawBPic(num, px, py, shadow, alpha, depth: integer; mixColor: uint32; mixAlpha: integer); overload;
begin
  if (num > 0) and (num < SPicAmount) then
  begin
    if PNG_TILE > 0 then
    begin
      //if PNG_LOAD_ALL = 0 then
      //if BPNGIndex[num].Loaded = 0 then
      //LoadOnePNGTile('resource/wmap/', pBPic, num, BPNGIndex[num], @BPNGTile[0]);
      DrawPNGTile(SPNGIndex[num], 0, nil, screen, px, py, shadow, alpha, mixColor, mixAlpha,
        depth, @BlockImg[0], ImageWidth, ImageHeight, sizeof(BlockImg[0]),
        BlockScreen.x, BlockScreen.y);
    end
    else
    begin
      DrawRLE8Pic(@ACol[0], num, px, py, @WIdx[0], @WPic[0], nil, nil, 0, 0, 0, shadow, alpha,
        @BlockImg[0], @BlockScreen, ImageWidth, ImageHeight, sizeof(BlockImg[0]),
        depth, mixColor, mixAlpha);
    end;
  end;

end;

//仅在某区域显示战场图

procedure DrawBPicInRect(num, px, py, shadow, x, y, w, h: integer);
var
  Area: TSDL_Rect;
begin
  if (num > 0) and (num < SPicAmount) then
  begin
    Area.x := x;
    Area.y := y;
    Area.w := w;
    Area.h := h;
    if PNG_TILE > 0 then
    begin
      //LoadOnePNGTile('resource/wmap/', num, BPNGIndex[num], @BPNGTile[0]);
      DrawPNGTile(SPNGIndex[num], 0, @Area, screen, px, py);
    end
    else
    begin
      DrawRLE8Pic(@ACol[0], num, px, py, @WIdx[0], @WPic[0], @Area, nil, 0, 0, 0, shadow);
    end;
  end;
end;

//将战场图片画到映像

procedure InitialBPic(num, px, py: integer); overload;
begin
  InitialBPic(num, px, py, 0, 0);
end;

//画到映像并记录遮挡

procedure InitialBPic(num, px, py, needBlock, depth: integer); overload;
var
  pImg: PSDL_Surface;
begin
  if (num > 0) and (num < SPicAmount) then
  begin
    if PNG_TILE > 0 then
    begin
      if PNG_LOAD_ALL = 0 then
        if SPNGIndex[num].Loaded = 0 then
          LoadOnePNGTile('resource/smap/', pSPic, num, SPNGIndex[num], @SPNGTile[0]);
      if needBlock <> 0 then
      begin
        SetPNGTileBlock(SPNGIndex[num], 0, px, py, depth, @BlockImg2[0], ImageWidth, ImageHeight,
          sizeof(BlockImg2[0]));
        pImg := ImgBBuild;
      end
      else
        pImg := ImgBfield;
      DrawPNGTile(SPNGIndex[num], 0, nil, pImg, px, py);
    end
    else
    begin
      if needBlock <> 0 then
        DrawRLE8Pic(@ACol[0], num, px, py, @WIdx[0], @WPic[0], nil, ImgBBuild, ImageWidth, ImageHeight,
          sizeof(BlockImg2[0]), 0, 0, @BlockImg2[0], nil, 0, 0, 0, depth, 0, 0)
      else
        DrawRLE8Pic(@ACol[0], num, px, py, @WIdx[0], @WPic[0], nil, ImgBfield,
          ImageWidth, ImageHeight, sizeof(BlockImg2[0]), 0);
    end;
  end;
end;

//显示效果图片

procedure DrawEPic(num, px, py: integer; index: integer = 0); overload;
begin
  DrawEPic(num, px, py, 0, 0, 0, 0, 0);

end;

procedure DrawEPic(num, px, py, shadow, alpha, depth: integer; mixColor: uint32; mixAlpha: integer;
  index: integer = 0); overload;
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
      DrawPNGTile(EPNGIndex[index, num], 0, nil, screen, px, py, shadow, alpha, mixColor, mixAlpha,
        depth, nil, 0, 0, 0, 0, 0);
    end;
    if PNG_TILE = 0 then
    begin
      DrawRLE8Pic(@ACol[0], num, px, py, @EIdx[0], @EPic[0], nil, nil, 0, 0, 0, shadow, alpha,
        nil, nil, 0, 0, 0, depth, mixColor, mixAlpha);
    end;
  end;
end;

//显示人物动作图片

procedure DrawFPic(num, px, py, index: integer); overload;
begin
  DrawFPic(num, px, py, 0, 0, 0, 0, 0, index);

end;

//用于画带透明度和遮挡的人物动作图片

procedure DrawFPic(num, px, py, index, shadow, alpha, depth: integer; mixColor: uint32; mixAlpha: integer); overload;
begin
  case PNG_TILE of
    1, 2:
    begin
      if FPicLoaded[index] = 0 then
      begin
        LoadPNGTiles(formatfloat('resource/fight/fight000', index), FPNGIndex[index], FPNGTile[index], 1);
        FPicLoaded[index] := 1;
      end;
      if (index >= 0) and (index < High(FPNGIndex)) then
        if (num >= Low(FPNGIndex[index])) and (num <= High(FPNGIndex[index])) then
          DrawPNGTile(FPNGIndex[index][num], 0, nil, screen, px, py, shadow, alpha, mixColor, mixAlpha,
            depth, @BlockImg2[0], ImageWidth, ImageHeight, sizeof(BlockImg2[0]),
            BlockScreen.x, BlockScreen.y);
    end;
    0:
    begin
      DrawRLE8Pic(@ACol[0], num, px, py, @FIdx[0], @FPic[0], nil, nil, 0, 0, 0, shadow,
        alpha, @BlockImg2[0], @BlockScreen, ImageWidth, ImageHeight, sizeof(BlockImg2[0]),
        depth, mixColor, mixAlpha);
    end;
  end;
end;

//主地图上画云

procedure DrawCPic(num, px, py, shadow, alpha: integer; mixColor: uint32; mixAlpha: integer);
begin
  if PNG_TILE > 0 then
  begin
    DrawPNGTile(CPNGIndex[num], 0, nil, screen, px, py, shadow, alpha, mixColor, mixAlpha);
  end;
  if PNG_TILE = 0 then
  begin
    DrawRLE8Pic(@ACol1[0], num, px, py, @CIdx[0], @CPic[0], nil, nil, 0, 0, 0, shadow, alpha,
      nil, nil, 0, 0, 0, 0, mixColor, mixAlpha);
  end;
end;

//画物品图

procedure DrawIPic(num, px, py, shadow, alpha: integer; mixColor: uint32; mixAlpha: integer);
begin
  if (num >= 0) and (num < IPicAmount) then
  begin
    if PNG_TILE > 0 then
    begin
      DrawPNGTile(IPNGIndex[num], 0, nil, screen, px, py, shadow, alpha, mixColor, mixAlpha);
    end;
    if PNG_TILE = 0 then
    begin
      DrawRLE8Pic(@ACol1[0], num, px, py, @CIdx[0], @CPic[0], nil, nil, 0, 0, 0, shadow, alpha,
        nil, nil, 0, 0, 0, 0, mixColor, mixAlpha);
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
      DrawTitlePic(0, OpenPicPosition.x, OpenPicPosition.y);
      DrawTitlePic(12, CENTER_X - 384 + 45, CENTER_Y - 240 + 53);
      DrawTitlePic(10, CENTER_X - 384 + 45, CENTER_Y - 240 + 43);
      DrawTitlePic(10, CENTER_X - 384 + 524, CENTER_Y - 240 + 43);
      DrawShadowText(@versionstr[1], OpenPicPosition.x + 5, CENTER_Y - 240 + 455, ColColor($64), ColColor($66));
      //DrawHeadPic(random(414), Center_x * 2 - 300, 100);
    end;
    4: //处于标题动画中
    begin
      CleanTextScreen;
      DrawTitlePic(0, OpenPicPosition.x, OpenPicPosition.y);
      DrawShadowText(@versionstr[1], OpenPicPosition.x + 5, CENTER_Y - 240 + 455, ColColor($64), ColColor($66));
    end;
  end;

end;


//显示主地图场景于屏幕

procedure DrawMMap;
var
  i1, i2, i, sum, x, y, k, c, widthregion, sumregion, num, axp, ayp: integer;
  temp: array[0..479, 0..479] of smallint;
  Width, Height, yoffset: smallint;
  pos: TPosition;
  BuildingList: array[0..2000] of TPosition;
  CenterList: array[0..2000] of integer;
begin
  //由上到下绘制, 先绘制地面和表面, 同时计算出现的建筑数目
  k := 0;
  widthregion := CENTER_X div 36 + 3;
  sumregion := CENTER_Y div 9 + 2;
  for sum := -sumregion to sumregion + 15 do
    for i := -Widthregion to Widthregion do
    begin
      if k >= High(CenterList) then
        break;
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
        temp[i1, i2] := 0;
        if building[i1, i2] <> 0 then
          temp[i1, i2] := building[i1, i2];
        //将主角和空船的位置计入建筑
        if (i1 = Mx) and (i2 = My) then
        begin
          if (InShip = 0) then
            if still = 0 then
              temp[i1, i2] := 2501 + MFace * 7 + MStep
            else
              temp[i1, i2] := 2528 + Mface * 6 + MStep
          else
            temp[i1, i2] := 3715 + MFace * 4 + (MStep + 1) div 2;
          temp[i1, i2] := temp[i1, i2] * 2;
        end;
        if MODVersion = 13 then
          if (i1 = Shipy) and (i2 = Shipx) and (InShip = 0) then
          begin
            temp[i1, i2] := 3715 + ShipFace * 4;
            temp[i1, i2] := temp[i1, i2] * 2;
          end;
        num := temp[i1, i2] div 2;
        if (num > 0) and (num < MPicAmount) then
        begin
          BuildingList[k].x := i1;
          BuildingList[k].y := i2;
          if PNG_TILE > 0 then
          begin
            if MPNGIndex[num].CurPointer <> nil then
            begin
              if MPNGIndex[num].CurPointer^ <> nil then
              begin
                Width := MPNGIndex[num].CurPointer^.w;
                Height := MPNGIndex[num].CurPointer^.h;
                yoffset := MPNGIndex[num].y;
              end;
            end;
          end
          else
          begin
            Width := SmallInt(Mpic[MIdx[num - 1]]);
            Height := SmallInt(Mpic[MIdx[num - 1] + 2]);
            yoffset := SmallInt(Mpic[MIdx[num - 1] + 6]);
          end;
          //根据图片的宽度计算图的中点, 为避免出现小数, 实际是中点坐标的2倍
          CenterList[k] := (i1 + i2) - (Width + 35) div 36 - (yoffset - Height + 1) div 9;
          k := k + 1;
        end;
      end
      else
        DrawMPic(0, pos.x, pos.y);
    end;
  //按照中点坐标排序
  for i1 := 0 to k - 2 do
    for i2 := i1 + 1 to k - 1 do
    begin
      if CenterList[i1] > CenterList[i2] then
      begin
        pos := BuildingList[i1];
        BuildingList[i1] := BuildingList[i2];
        BuildingList[i2] := pos;
        c := CenterList[i1];
        CenterList[i1] := CenterList[i2];
        CenterList[i2] := c;
      end;
    end;
  for i := 0 to k - 1 do
  begin
    x := BuildingList[i].x;
    y := BuildingList[i].y;
    Pos := GetPositionOnScreen(x, y, Mx, My);
    DrawMPic(temp[x, y] div 2, pos.x, pos.y);
  end;

  DrawClouds;
  if HaveText = 1 then
    CleanTextScreen;
end;

//画场景到屏幕

procedure DrawScence;
var
  x, y, xpoint, ypoint, axp, ayp: integer;
  dest: TSDL_Rect;
  word: WideString;
  pos: Tposition;
begin
  if IsCave(CurScence) then
  begin
    ShowBlackScreen := True;
  end
  else
    ShowBlackScreen := False;
  //DrawScenceWithoutRole(Sx, Sy);
  //先画无主角的场景, 再画主角
  //如在事件中, 则以Cx, Cy为中心, 否则以主角坐标为中心

  if (CurEvent < 0) then
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
  end;

  if (CurScence = 71) and (MODVersion = 13) then
  begin
    word := formatfloat('0', TimeInWater div 60) + ':' + formatfloat('00', TimeInWater mod 60);
    DrawShadowText(@word[1], 5, 5, ColColor(5), ColColor(7));
    if (time <= 0) then
    begin
      instruct_15;
    end;
  end;
  //if (blackscreen > 0) and (CurEvent > 0) then
  //DrawRectangleWithoutFrame(screen, 0, 0, screen.w, screen.h, 0, 100 - blackscreen * 10);

end;

//画不含主角的场景

procedure DrawScenceWithoutRole(x, y: integer);
var
  x1, y1: integer;
begin
  CalLTPosOnImageByCenter(x, y, x1, y1);
  LoadScencePart(x1, y1);
  if ShowBlackScreen then
    DrawBlackScreen;
  if HaveText = 1 then
    CleanTextScreen;
end;

procedure DrawBlackScreen;
var
  i1, i2: integer;
  distance: real;
  alphe: byte;
  //tempscr, tempscr1: PSDL_Surface;
begin
  if BlackScr = nil then
  begin
    BlackScr := SDL_CreateRGBSurface(screen.flags, screen.w, screen.h, 32, RMASK, GMASK, BMASK, AMASK);
    SDL_FillRect(BlackScr, nil, 0);
    for i1 := 0 to screen.w - 1 do
      for i2 := 0 to screen.h - 1 do
      begin
        distance := ((i1 - CENTER_X) * (i1 - CENTER_X) + (i2 - CENTER_Y) * (i2 - CENTER_Y)) / 15625;
        if distance > 1 then
          alphe := 255
        else
          alphe := round(distance * 255);
        PutPixel(BlackScr, i1, i2, SDL_MapRGBA(BlackScr.format, 0, 0, 0, alphe));
      end;
  end;
  SDL_BlitSurface(BlackScr, nil, screen, nil);

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
    DrawSPic(CurScenceRolePic, pos.x, pos.y - SData[CurScence, 4, Sx, Sy], 0, 100, CalBlock(Sx, Sy), 0, 0);
  end;
end;

procedure ExpandGroundOnImg();
var
  i1, i2, x, y, num: integer;
begin
  //绝情谷, 明教地道效果比较奇怪, 屏蔽
  if (EXPAND_GROUND <> 0) and ((MODVersion <> 13) or ((CurScence <> 81) and (CurScence <> 72))) then
  begin
    fillchar(ExGround, sizeof(ExGround), 0);
    for i1 := 0 to 63 do
      for i2 := 0 to 63 do
      begin
        case where of
          1: ExGround[i1, i2] := SData[CurScence, 0, i1, i2];
          2: ExGround[i1, i2] := Bfield[0, i1, i2];
        end;
      end;
    for i1 := 31 downto -64 do
      for i2 := 0 to 63 do
      begin
        if ExGround[i1, i2] <= 0 then ExGround[i1, i2] := ExGround[i1 + 1, i2];
      end;
    for i1 := 32 to 127 do
      for i2 := 0 to 63 do
      begin
        if ExGround[i1, i2] <= 0 then ExGround[i1, i2] := ExGround[i1 - 1, i2];
      end;
    for i1 := -64 to 127 do
      for i2 := 31 downto -64 do
      begin
        if ExGround[i1, i2] <= 0 then ExGround[i1, i2] := ExGround[i1, i2 + 1];
      end;
    for i1 := -64 to 127 do
      for i2 := 32 to 127 do
      begin
        if ExGround[i1, i2] <= 0 then ExGround[i1, i2] := ExGround[i1, i2 - 1];
      end;
    for i1 := -64 to 127 do
      for i2 := -64 to 127 do
      begin
        CalPosOnImage(i1, i2, x, y);
        num := ExGround[i1, i2] div 2;
        case where of
          1: InitialSPic(num, x, y, 0, 0, ImageWidth, ImageHeight, 0, 0, 0);
          2: InitialBPic(num, x, y, 0, 0);
        end;
      end;
  end;
end;

//Save the image informations of the whole scence.
//生成场景映像
//0-全部映像
//1-可见部分
//2-先刷新背景, 副线程专用

procedure InitialScence(Visible: integer = 0);
var
  i1, i2, x, y, x1, y1, w, h, num, mini, maxi, depth, sumi: integer;
  pos: TPosition;
  onback, now: uint32;
  dest: TSDL_Rect;
begin
  SDL_LockMutex(mutex);
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
  SDL_UnLockMutex(mutex);
end;

//上面函数的子程

procedure InitialScenceOnePosition(i1, i2, x1, y1, w, h, depth, temp: integer);
var
  i, x, y, num: integer;
begin
  CalPosOnImage(i1, i2, x, y);
  //InitialSPic2(SData[CurScence, 0, i1, i2] div 2, x, y, x1, y1, w, h, 1);
  if SData[CurScence, 4, i1, i2] > 0 then
  begin
    num := SData[CurScence, 0, i1, i2] div 2;
    InitialSPic(num, x, y, x1, y1, w, h, 1, depth, temp);
  end;
  if (SData[CurScence, 1, i1, i2] > 0) {and (SData[CurScence, 4, i1, i2] > 0)} then
  begin
    num := SData[CurScence, 1, i1, i2] div 2;
    InitialSPic(num, x, y - SData[CurScence, 4, i1, i2], x1, y1, w, h, 1, depth, temp);
  end;
  if (SData[CurScence, 2, i1, i2] > 0) then
  begin
    num := SData[CurScence, 2, i1, i2] div 2;
    InitialSPic(num, x, y - SData[CurScence, 5, i1, i2], x1, y1, w, h, 1, depth, temp);
  end;
  if (SData[CurScence, 3, i1, i2] >= 0) then
  begin
    num := DData[CurScence, SData[CurScence, 3, i1, i2], 5] div 2;
    if num > 0 then
    begin
      if PNG_LOAD_ALL = 0 then
        if ((temp = 0) or (CurEvent >= 0)) and (PNG_TILE > 0) then
        begin
          i := DData[CurScence, SData[CurScence, 3, i1, i2], 5] div 2;
          if SPNGIndex[i].Loaded = 0 then
            LoadOnePNGTile('resource/smap', pSPic, i, SPNGIndex[i], @SPNGTile[0]);
          for i := DData[CurScence, SData[CurScence, 3, i1, i2], 7] div 2
            to DData[CurScence, SData[CurScence, 3, i1, i2], 6] div 2 do
            if SPNGIndex[i].Loaded = 0 then
              LoadOnePNGTile('resource/smap', pSPic, i, SPNGIndex[i], @SPNGTile[0]);
        end;
      if SCENCEAMI = 2 then
        InitialSPic(num, x, y - SData[CurScence, 4, i1, i2], x1, y1, w, h, 1, depth, temp);
    end;
  end;
  //if (i1 = Sx) and (i2 = Sy) then
  //InitialSPic(2501 + SFace * 7 + SStep, x, y - SData[CurScence, 4, Sx, Sy], x1, y1, w, h);
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

//将场景映像画到屏幕并载入遮挡数据

procedure LoadScencePart(x, y: integer);
var
  i1, i2: integer;
  dest: TSDL_Rect;
begin
  dest.x := x;
  dest.y := y;
  dest.w := screen.w;
  dest.h := screen.h;
  BlockScreen.x := x;
  BlockScreen.y := y;
  //if (x < 0) or (x >= 2304 - CENTER_X * 2) or (y > 1402 - CENTER_Y * 2) then
  //SDL_FillRect(screen, nil, 0);
  //DrawMPic(2015, 0, 0);
  SDL_BlitSurface(ImgScence, @dest, screen, nil);

end;

//画战场

procedure DrawBField();
var
  i, i1, i2: integer;
begin
  DrawBfieldWithoutRole(Bx, By);
  for i1 := 0 to 63 do
    for i2 := 0 to 63 do
    begin
      if (Bfield[2, i1, i2] >= 0) and (Brole[Bfield[2, i1, i2]].Dead = 0) then
        DrawRoleOnBfield(i1, i2);
    end;
  DrawProgress;
  CleanTextScreen;

end;

//画不含主角的战场

procedure DrawBfieldWithoutRole(x, y: integer);
var
  x1, y1: integer;
begin
  CalLTPosOnImageByCenter(x, y, x1, y1);
  LoadBfieldPart(x1, y1);

end;

//画战场上人物, 需更新人物身前的遮挡

procedure DrawRoleOnBfield(x, y: integer; mixColor: uint32 = 0; mixAlpha: integer = 0; Alpha: integer = 75);
var
  i1, i2, depth, bnum, picnum: integer;
  pos: Tposition;
begin
  pos := GetPositionOnScreen(x, y, Bx, By);
  depth := CalBlock(x, y);
  bnum := Bfield[2, x, y];
  if Brole[bnum].Pic > 0 then
    picnum := Brole[bnum].Pic
  else
    picnum := Brole[bnum].StaticPic[Brole[bnum].Face];
  DrawFPic(picnum, pos.x, pos.y, Rrole[Brole[bnum].rnum].ActionNum, 0, Alpha, depth, mixColor, mixAlpha);

end;

//初始化战场映像
//0-地面, 1-建筑, 2-全部
procedure InitialBFieldImage(layer: integer = 2);
var
  sumi, i1, i2, a: integer;
begin
  FillChar(BlockImg2[0], sizeof(BlockImg2[0]) * length(BlockImg2), -1);
  SDL_FillRect(ImgBField, nil, 0);
  SDL_FillRect(ImgBBuild, nil, 1);
  ExpandGroundOnImg();
  for sumi := 0 to 126 do
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
  end;

end;

procedure InitialBFieldPosition(i1, i2, depth: integer; layer: integer = 2);
var
  x, y: integer;
begin
  if (i1 < 0) or (i2 < 0) or (i1 > 63) or (i2 > 63) then
  begin
    //InitialBPic(0, x, y, 0, 0);
  end
  else
  begin
    CalPosOnImage(i1, i2, x, y);
    if (EXPAND_GROUND = 0) and ((layer = 2) or (layer = 0)) then
      InitialBPic(bfield[0, i1, i2] div 2, x, y, 0, 0);
    if (bfield[1, i1, i2] > 0) and ((layer = 2) or (layer = 1)) then
    begin
      InitialBPic(bfield[1, i1, i2] div 2, x, y, 1, depth);
    end;
  end;
end;

//将战场映像画到屏幕并载入遮挡数据

procedure LoadBfieldPart(x, y: integer; noBuild: integer = 0);
var
  i1, i2: integer;
  dest: TSDL_Rect;
begin
  dest.x := x;
  dest.y := y;
  dest.w := screen.w;
  dest.h := screen.h;
  BlockScreen.x := x;
  BlockScreen.y := y;
  //if (x < 0) or (x >= 2304 - CENTER_X * 2) then
  //SDL_FillRect(screen, nil, 0);
  SDL_BlitSurface(ImgBfield, @dest, screen, nil);
  if nobuild = 0 then
    LoadBFieldPart2(x, y, 0);
  //SDL_BlitSurface(ImgBBuild, @dest, screen, nil);

end;

//直接载入建筑层Surface, 将战场分成两部分是为绘制带光标战场时可以单独载入建筑层

procedure LoadBFieldPart2(x, y, alpha: integer);
var
  i1, i2: integer;
  pix, colorin: uint32;
  pix1, pix2, pix3, pix4, color1, color2, color3, color4: byte;
  dest: TSDL_Rect;
begin
  dest.x := x;
  dest.y := y;
  dest.w := screen.w;
  dest.h := screen.h;
  SDL_SetAlpha(ImgBBuild, SDL_SRCALPHA, 255 - alpha * 255 div 100);
  SDL_BlitSurface(ImgBBuild, @dest, screen, nil);

end;

//画带光标的子程
//此子程效率不高

procedure DrawBFieldWithCursor(AttAreaType, step, range: integer);
var
  i, i1, i2, bnum, minstep, shadow, mixAlpha, x, y: integer;
  mixColor: uint32;
  pos: TPosition;
  HighLight: boolean;
begin
  SDL_FillRect(screen, nil, 0);
  CleanTextScreen;
  CalLTPosOnImageByCenter(Bx, By, x, y);
  LoadBfieldPart(x, y, 1);
  TransBlackScreen;
  SetAminationPosition(AttAreaType, step, range);
  for i1 := 0 to 63 do
    for i2 := 0 to 63 do
    begin
      if Bfield[0, i1, i2] > 0 then
      begin
        pos := GetPositionOnScreen(i1, i2, Bx, By);
        shadow := 0;
        case AttAreaType of
          0: //目标系点型(用于移动、点攻、用毒、医疗等)、目标系十型、目标系菱型、原地系菱型
          begin
            if Bfield[4, i1, i2] > 0 then
              shadow := 1
            else if (abs(i1 - Bx) + abs(i2 - By) <= step) and (Bfield[3, i1, i2] >= 0) then
              shadow := 0
            else
              shadow := -1;
          end;
          1: //方向系线型
          begin
            if Bfield[4, i1, i2] > 0 then
              shadow := 1
            else if ((i1 = Bx) and (abs(i2 - By) <= step)) or ((i2 = By) and (abs(i1 - Bx) <= step)) then
              shadow := 0
            else
              shadow := -1;
          end;
          2: //原地系十型、原地系叉型、原地系米型
          begin
            if Bfield[4, i1, i2] > 0 then
              shadow := 1
            else
              shadow := -1;
          end;
          3: //目标系方型、原地系方型
          begin
            if Bfield[4, i1, i2] > 0 then
              shadow := 1
            else if (abs(i1 - Bx) + abs(i2 - By) <= step) and (Bfield[0, i1, i2] >= 0) then
              shadow := 0
            else
              shadow := -1;
          end;
          4: //方向系菱型
          begin
            if Bfield[4, i1, i2] > 0 then
              shadow := 1
            else if (abs(i1 - Bx) + abs(i2 - By) <= step) and (abs(i1 - Bx) <> abs(i2 - By)) then
              shadow := 0
            else
              shadow := -1;
          end;
          5: //方向系角型
          begin
            if Bfield[4, i1, i2] > 0 then
              shadow := 1
            else if (abs(i1 - Bx) <= step) and (abs(i2 - By) <= step) and (abs(i1 - Bx) <> abs(i2 - By)) then
              shadow := 0
            else
              shadow := -1;
          end;
          6: //远程
          begin
            minstep := 3;
            if Bfield[4, i1, i2] > 0 then
              shadow := 1
            else if (abs(i1 - Bx) + abs(i2 - By) <= step) and (abs(i1 - Bx) + abs(i2 - By) > minstep) and
              (Bfield[3, i1, i2] >= 0) then
              shadow := 0
            else
              shadow := -1;
          end;
        end;
        if shadow >= 0 then
          DrawBPic(Bfield[0, i1, i2] div 2, pos.x, pos.y, shadow);
      end;
    end;

  LoadBFieldPart2(x, y, 30);

  for i1 := 0 to 63 do
    for i2 := 0 to 63 do
    begin
      pos := GetPositionOnScreen(i1, i2, Bx, By);
      {if Bfield[1, i1, i2] > 0 then
        DrawBPic(Bfield[1, i1, i2] div 2, pos.x, pos.y, 0);}
      bnum := Bfield[2, i1, i2];

      if (bnum >= 0) and (Brole[bnum].Dead = 0) then
      begin
        HighLight := False;
        //0-范围内敌方, 1-范围内我方, 2-敌方全部, 3-我方全部, 4-自身, 5-范围内全部, 6-全部, 7-不高亮
        case SelectAimMode of
          0: HighLight := (Bfield[4, i1, i2] > 0) and (Brole[bnum].Team <> 0);
          1: HighLight := (Bfield[4, i1, i2] > 0) and (Brole[bnum].Team = 0);
          2: HighLight := Brole[bnum].Team <> 0;
          3: HighLight := Brole[bnum].Team = 0;
          4: HighLight := (i1 = Bx) and (i2 = By);
          5: HighLight := (Bfield[4, i1, i2] > 0);
          6: HighLight := True;
          7: HighLight := False;
        end;
        //DrawBPic(Rrole[Brole[bnum].rnum].HeadNum * 4 + Brole[bnum].Face + BEGIN_BATTLE_ROLE_PIC, pos.x, pos.y, 0);
        mixColor := $FFFFFFFF;
        if highlight then
        begin
          mixAlpha := 50;
        end
        else
        begin
          mixAlpha := 0;
        end;
        DrawFPic(Brole[bnum].StaticPic[Brole[bnum].Face], pos.x, pos.y, Rrole[Brole[bnum].rnum].ActionNum,
          0, 75, CalBlock(i1, i2), mixColor, mixAlpha);
        HighLight := False;
      end;
    end;

end;


procedure DrawBFieldWithEft(Epicnum: integer; index: integer = 0); overload;
var
  i, i1, i2: integer;
  pos: TPosition;
begin
  DrawBfieldWithoutRole(Bx, By);

  for i1 := 0 to 63 do
    for i2 := 0 to 63 do
    begin
      pos := GetPositionOnScreen(i1, i2, Bx, By);
      if (Bfield[2, i1, i2] >= 0) and (Brole[Bfield[2, i1, i2]].Dead = 0) then
        DrawRoleOnBfield(i1, i2);
      if Bfield[4, i1, i2] > 0 then
        DrawEPic(Epicnum, pos.x, pos.y, 0, 25, 0, 0, 0, index);
    end;
  DrawProgress;
end;


procedure DrawBFieldWithEft(Epicnum, beginpic, endpic, curlevel, bnum, SelectAimMode, flash: integer;
  mixColor: uint32; index: integer = 0; MixColor2: uint32 = 0; MixAlpha2: integer = 0); overload;
var
  k, i1, i2, t: integer;
  pos: TPosition;
begin
  //flash-闪烁颜色, 未处理
  if needOffset <> 0 then
  begin
    offsetX := random(5);
    offsetY := random(5);
  end;
  DrawBfieldWithoutRole(Bx, By);
  for i1 := 0 to 63 do
    for i2 := 0 to 63 do
    begin
      pos := GetPositionOnScreen(i1, i2, Bx, By);
      k := Bfield[2, i1, i2];
      if k >= 0 then
      begin
        t := 0;
        if (Bfield[4, Brole[k].X, Brole[k].Y] > 0) then
          if CanSelectAim(bnum, k, -1, SelectAimMode) then t := 1;
        //行动人物的动作停留在最后一帧
        if (bnum = k) and (Brole[bnum].Pic > 0) then
          DrawFPic(Brole[bnum].pic, pos.x, pos.y, Rrole[Brole[bnum].rnum].ActionNum, 0, 75, CalBlock(i1, i2),
            mixColor, t * (10 + random(40)))
        else
          DrawRoleOnBfield(i1, i2, mixColor, t * (10 + random(40)));
      end;
      if (Bfield[4, i1, i2] > 0) {and (Bfield[1, i1, i2] = 0)} then
      begin
        k := Epicnum + curlevel - Bfield[4, i1, i2];
        if (k >= beginpic) and (k <= endpic) then
        begin
          DrawEPic(k, pos.x, pos.y, 0, 25, 0, MixColor2, random(2) * MixAlpha2, index);
        end;
      end;
    end;
  //needOffset := 0;
  offsetX := 0;
  offsetY := 0;
  DrawProgress;

end;


//画带人物动作的战场

procedure DrawBFieldWithAction(bnum, Apicnum: integer);
var
  i, i1, i2: integer;
  pos: TPosition;
begin
  DrawBfieldWithoutRole(Bx, By);
  for i1 := 0 to 63 do
    for i2 := 0 to 63 do
    begin
      if (Bfield[2, i1, i2] >= 0) and (Brole[Bfield[2, i1, i2]].Dead = 0) and (Bfield[2, i1, i2] <> bnum) then
      begin
        DrawRoleOnBfield(i1, i2);
      end;
      if (Bfield[2, i1, i2] = bnum) then
      begin
        pos := GetPositionOnScreen(i1, i2, Bx, By);
        DrawFPic(apicnum, pos.x, pos.y, Rrole[Brole[bnum].rnum].ActionNum, 0, 75, CalBlock(i1, i2), 0, 0);
      end;
    end;
  DrawProgress;

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
  dest: TSDL_Rect;
  range, p: array of integer;
  tempscr: PSDL_Surface;
begin
  if SEMIREAL = 1 then
  begin
    x := CENTER_X - 180;
    y := CENTER_Y * 2 - 70;
    dest.y := y;
    //DrawRectangleWithoutFrame(screen, 0, CENTER_Y * 2 - 50, CENTER_X * 2, 50, 0, 50);
    DrawMPic(2014, x - 150, y - 10);
    if length(BHead) = BRoleAmount then
    begin
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
          //p := Brole[range[i]].RealProgress * 500 div 10000;
          dest.x := p[i] + x;
          if BHead[Brole[range[i]].BHead] <> nil then
          begin
            tempscr := BHead[Brole[range[i]].BHead];
            SDL_BlitSurface(tempscr, nil, screen, @dest);
            {if (BField[4, Brole[range[i]].X, Brole[range[i]].Y] > 0)
              and (Brole[BField[2, Bx, By]].Team <> Brole[range[i]].Team) then
              DrawRectangleWithoutFrame(screen, dest.x, dest.y, tempscr.w, tempscr.h,
                SDL_MapRGB(screen.format, 200, 2, 0), 40);}
          end;
        end;
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

end.
