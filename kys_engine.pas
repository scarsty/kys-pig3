unit kys_engine;

{$i macro.inc}

interface

uses
{$IFDEF fpc}
  LConvEncoding,
  LCLType,
  LCLIntf,
{$ENDIF}
{$IFDEF mswindows}
  Windows,
  //xVideo,
  avcodec,
  avformat,
  swscale,
  avutil,
{$ENDIF}
  Classes,
  SysUtils,
  SDL2_TTF,
  SDL2_image,
  SDL2,
  kys_type,
  kys_main,
  gl,
  Dialogs,
  bassmidi,
  bass,
  Math,
  unzip,
  ziputils;

function EventFilter(p: pointer; e: PSDL_Event): longint; cdecl;

//音频子程
procedure InitialMusic;
procedure FreeAllMusic;
procedure PlayMP3(MusicNum, times: integer; frombeginning: integer = 1); overload;
procedure PlayMP3(filename: pchar; times: integer); overload;
procedure StopMP3(frombeginning: integer = 1);
procedure PlaySound(SoundNum, times: integer); overload;
procedure PlaySound(SoundNum, times, x, y, z: integer); overload;
procedure PlaySoundA(SoundNum, times: integer); overload;
procedure PlaySound(SoundNum: integer); overload;
procedure PlaySound(filename: pchar; times: integer); overload;

//基本绘图子程
function GetPixel(surface: PSDL_Surface; x: integer; y: integer): uint32;
procedure PutPixel(surface: PSDL_Surface; x: integer; y: integer; pixel: uint32);
function ColColor(num: integer): uint32;
procedure DrawRectangle(x, y, w, h: integer; colorin, colorframe: uint32; alpha: integer);
procedure DrawRectangleWithoutFrame(x, y, w, h: integer; colorin: uint32; alpha: integer);
procedure DrawItemFrame(x, y: integer; realcoord: integer = 0);

//画RLE8图片的子程
function JudgeInScreen(px, py, w, h, xs, ys: integer): boolean; overload;
function JudgeInScreen(px, py, w, h, xs, ys, xx, yy, xw, yh: integer): boolean; overload;
function GetPositionOnScreen(x, y, CenterX, CenterY: integer): TPosition;

//显示文字的子程
function Big5ToUnicode(str: pchar): WideString;
function GBKToUnicode(str: pchar): WideString;
function PCharToUnicode(str: pchar; len: integer = -1): WideString;
function UnicodeToBig5(str: pWideChar): string;
function UnicodeToGBK(str: pWideChar): string;
procedure DrawText(word: puint16; x_pos, y_pos: integer; color: uint32; engwidth: integer = -1);
procedure DrawEngText(word: puint16; x_pos, y_pos: integer; color: uint32);
procedure DrawShadowText(word: puint16; x_pos, y_pos: integer; color1, color2: uint32;
  Tex: PSDL_Texture = nil; Sur: PSDL_Surface = nil; realPosition: integer = 0; eng: integer = 0); overload;
procedure DrawEngShadowText(word: puint16; x_pos, y_pos: integer; color1, color2: uint32;
  Tex: PSDL_Texture = nil; Sur: PSDL_Surface = nil);
procedure DrawBig5Text(sur: PSDL_Surface; str: pchar; x_pos, y_pos: integer; color: uint32);
procedure DrawBig5ShadowText(word: pchar; x_pos, y_pos: integer; color1, color2: uint32);
procedure DrawTextWithRect(word: puint16; x, y, w: integer; color1, color2: uint32;
  alpha: integer = 50; Refresh: integer = 1);
procedure DrawGBKShadowText(word: pchar; x_pos, y_pos: integer; color1, color2: uint32);
procedure DrawU16ShadowText(word: pchar; x_pos, y_pos: integer; color1, color2: uint32);

function Simplified2Traditional(mSimplified: ansistring): ansistring;
procedure DrawPartPic(pic: pointer; x, y, w, h, x1, y1: integer);
function Traditional2Simplified(mTraditional: string): string;
procedure PlayBeginningMovie;

procedure SDL_UpdateRect2(scr1: PSDL_Surface; x, y, w, h: integer);
procedure SDL_GetMouseState2(var x, y: integer);
procedure DestroyRenderTextures;
procedure CreateAssistantRenderTextures;
procedure CreateMainRenderTextures;
procedure ResizeWindow(w, h: integer);
procedure ResizeSimpleText(initial: integer = 0);
procedure SwitchFullscreen;
procedure QuitConfirm;

function JoyAxisMouse(interval: uint32; param: pointer): uint32;

function CheckBasicEvent: uint32;

procedure ChangeCol;


//用于读取的子程
procedure InitialPicArrays;
procedure ReadTiles;
function LoadPNGTilesThread(Data: pointer): longint; cdecl;
function ReadFileToBuffer(p: pchar; filename: string; size, malloc: integer): pchar;
procedure FreeFileBuffer(var p: pchar);
function LoadIdxGrp(stridx, strgrp: string; var idxarray: TIntArray; var grparray: TByteArray): integer;
function LoadPNGTiles(path: string; var PNGIndexArray: TPNGIndexArray; var TextureArray: TTextureArray;
  var SurfaceArray: TSurfaceArray; LoadPic: integer = 1): integer; overload;
procedure LoadOnePNGTexture(path: string; p: pchar; var PNGIndex: TPNGIndex; forceLoad: integer = 0); overload;
function LoadTileFromFile(filename: string; pt: PPSDL_Texture; ps: PPSDL_Surface; usesur: integer;
  var w, h: integer): boolean;
function LoadTileFromMem(p: pchar; len: integer; pt: PPSDL_Texture; ps: PPSDL_Surface;
  usesur: integer; var w, h: integer): boolean;
function LoadStringFromIMZMEM(path: string; p: pchar; num: integer): string;
function LoadStringFromZIP(zfilename, filename: string): string;
//function LoadSurfaceFromZIPFile(zipFile: unzFile; filename: string): PSDL_Surface;
//procedure FreeAllSurface;
procedure DestroyAllTextures(all: integer = 1);
procedure DestroyFontTextures();

procedure DrawPNGTile(render: PSDL_Renderer; PNGIndex: TPNGIndex; FrameNum: integer; px, py: integer); overload;
procedure DrawPNGTile(render: PSDL_Renderer; PNGIndex: TPNGIndex; FrameNum: integer;
  px, py: integer; region: psdl_rect; shadow, alpha: integer; mixColor: uint32; mixAlpha: integer;
  scalex, scaley, angle: real; center: PSDL_Point); overload;
procedure DrawPNGTileS(scr: PSDL_Surface; PNGIndex: TPNGIndex; FrameNum: integer; px, py: integer;
  region: psdl_rect; shadow, alpha: integer; mixColor: uint32; mixAlpha: integer;
  scalex, scaley, angle: real); overload;

function CopyIndexSurface(PNGIndexArray: TPNGIndexArray; i: integer): PSDL_Surface;

procedure PlayMovie(const filename: string; fullwindow: integer);

procedure Big5ToGBK(p: pchar);
procedure Big5ToU16(p: pchar);

//字串的绘制长度
function DrawLength(str: WideString): integer; overload;
function DrawLength(p: pWideChar): integer; overload;
function DrawLength(p: pchar): integer; overload;
//颜色
function MapRGBA(r, g, b: byte; a: byte = 255): uint32;
procedure GetRGBA(color: uint32; r, g, b: pbyte; a: pbyte = nil);

//屏幕控制相关
procedure SetFontSize(Chnsize, engsize: integer; force: integer = 0);
procedure ResetFontSize;
procedure LoadTeamSimpleStatus(var max: integer);
procedure DrawSimpleStatusByTeam(i, px, py: integer; mixColor: uint32; mixAlpha: integer);
procedure FreeTeamSimpleStatus(var SimpleStatus: array of PSDL_Surface);

procedure TransBlackScreen;
procedure RecordFreshScreen; overload;
procedure LoadFreshScreen; overload;
procedure RecordFreshScreen(x, y, w, h: integer); overload;
procedure LoadFreshScreen(x, y: integer); overload;
procedure FreeFreshScreen;
procedure UpdateAllScreen;

procedure CleanTextScreen; overload;
procedure CleanTextScreenRect(x, y, w, h: integer); overload;


//清键值
procedure CleanKeyValue;

//屏幕拉伸相关
procedure GetMousePosition(var x, y: integer; x0, y0: integer; yp: integer = 0);
function MouseInRegion(x, y, w, h: integer): boolean; overload;
function MouseInRegion(x, y, w, h: integer; var x1, y1: integer): boolean; overload;
function GetRealRect(var x, y, w, h: integer; force: integer = 0): TSDL_Rect; overload;
function GetRealRect(rect: TSDL_Rect; force: integer = 0): TSDL_Rect; overload;
function KeepRatioScale(w1, h1, w2, h2: integer): TStretchInfo;

//这两个可能是加密时用过
procedure swap(var x, y: byte); overload;
procedure swap(var x, y: uint32); overload;

//几个数学函数
function round(x: real): integer;
function RegionParameter(x, x1, x2: integer): integer;
function LinearInsert(x, x1, x2: real; y1, y2: integer): integer;
procedure QuickSort(var a: array of integer; l, r: Integer);
procedure QuickSortB(var a: array of TBuildInfo; l, r: integer);

//计时, 测速用
procedure tic;
procedure toc;

function Myth_VideoPlay(window: integer; filename: string): integer; cdecl; external 'myth-simpleplayer.dll';


implementation

uses
  kys_battle,
  kys_draw;

function EventFilter(p: pointer; e: PSDL_Event): longint; cdecl;
begin
  Result := 1;
  if (e.type_ >= $700) and (e.type_ <= $702) then
    Result := 0;
end;

procedure InitialMusic;
var
  i: integer;
  str: string;
  sf: BASS_MIDI_FONT;
  Flag: longword;
begin
  BASS_Set3DFactors(1, 0, 0);
  sf.font := BASS_MIDI_FontInit(pchar(AppPath + 'music/mid.sf2'), 0);
  BASS_MIDI_StreamSetFonts(0, sf, 1);
  sf.preset := -1; // use all presets
  sf.bank := 0;
  Flag := 0;
  if SOUND3D = 1 then
    Flag := BASS_SAMPLE_3D or BASS_SAMPLE_MONO or Flag;

  for i := 0 to High(Music) do
  begin
    str := AppPath + 'music/' + IntToStr(i) + '.mp3';
    if FileExists(pchar(str)) then
    begin
      try
        Music[i] := BASS_StreamCreateFile(False, pchar(str), 0, 0, 0);
      finally

      end;
    end
    else
    begin
      str := AppPath + 'music/' + IntToStr(i) + '.mid';
      if FileExists(pchar(str)) then
      begin
        try
          Music[i] := BASS_MIDI_StreamCreateFile(False, pchar(str), 0, 0, 0, 0);
          BASS_MIDI_StreamSetFonts(Music[i], sf, 1);
          //showmessage(inttostr(Music[i]));
        finally

        end;
      end
      else
        Music[i] := 0;
    end;
  end;

  for i := 0 to High(Esound) do
  begin
    str := AppPath + 'sound/e' + IntToStr(i) + '.wav';
    if FileExists(pchar(str)) then
      ESound[i] := BASS_SampleLoad(False, pchar(str), 0, 0, 1, Flag)
    else
      ESound[i] := 0;
    //showmessage(inttostr(esound[i]));
  end;
  for i := 0 to High(Asound) do
  begin
    str := AppPath + formatfloat('sound/atk00', i) + '.wav';
    if FileExists(pchar(str)) then
      ASound[i] := BASS_SampleLoad(False, pchar(str), 0, 0, 1, Flag)
    else
      ASound[i] := 0;
  end;
  //BASS_MIDI_FontFree(sf.font);
end;

procedure FreeAllMusic;
var
  i: integer;
begin
  for i := 0 to High(Music) do
  begin
    if Music[i] <> 0 then
      BASS_StreamFree(Music[i]);
  end;
  for i := 0 to High(Asound) do
  begin
    if Asound[i] <> 0 then
      BASS_SampleFree(Asound[i]);
  end;
  for i := 0 to High(Esound) do
  begin
    if Esound[i] <> 0 then
      BASS_SampleFree(Esound[i]);
  end;
end;


//播放mp3音乐

procedure PlayMP3(MusicNum, times: integer; frombeginning: integer = 1); overload;
var
  repeatable: boolean;
begin
  if times = -1 then
    repeatable := True
  else
    repeatable := False;
  try
    if (MusicNum in [Low(Music)..High(Music)]) and (VOLUME > 0) then
      if Music[MusicNum] <> 0 then
      begin
        //BASS_ChannelSlideAttribute(Music[nowmusic], BASS_ATTRIB_VOL, 0, 1000);
        BASS_ChannelStop(Music[nowmusic]);
        if frombeginning = 1 then
          BASS_ChannelSetPosition(Music[nowmusic], 0, BASS_POS_BYTE);
        BASS_ChannelSetAttribute(Music[MusicNum], BASS_ATTRIB_VOL, VOLUME / 100.0);
        if SOUND3D = 1 then
        begin
          //BASS_SetEAXParameters(EAX_ENVIRONMENT_UNDERWATER, -1, 0, 0);
          BASS_Apply3D();
        end;

        if repeatable then
          BASS_ChannelFlags(Music[MusicNum], BASS_SAMPLE_LOOP, BASS_SAMPLE_LOOP)
        else
          BASS_ChannelFlags(Music[MusicNum], 0, BASS_SAMPLE_LOOP);
        BASS_ChannelPlay(Music[MusicNum], False);
        nowmusic := musicnum;
      end;
  finally

  end;

end;

procedure PlayMP3(filename: pchar; times: integer); overload;
begin
  //if fileexists(filename) then
  //begin
  //Music := Mix_LoadMUS(filename);
  //Mix_volumemusic(MIX_MAX_VOLUME div 3);
  //Mix_PlayMusic(music, times);
  //end;

end;

//停止当前播放的音乐

procedure StopMP3(frombeginning: integer = 1);
begin
  BASS_ChannelStop(Music[nowmusic]);
  if frombeginning = 1 then
    BASS_ChannelSetPosition(Music[nowmusic], 0, BASS_POS_BYTE);

end;

//播放wav音效

procedure PlaySound(SoundNum, times: integer); overload;
var
  ch: HCHANNEL;
  repeatable: boolean;
begin
  if times = -1 then
    repeatable := True
  else
    repeatable := False;
  if (SoundNum in [Low(Esound)..High(Esound)]) and (VOLUMEWAV > 0) then
    if Esound[SoundNum] <> 0 then
    begin
      //Mix_VolumeChunk(Esound[SoundNum], Volume);
      //Mix_PlayChannel(-1, Esound[SoundNum], 0);
      BASS_SampleStop(Esound[soundnum]);
      ch := BASS_SampleGetChannel(Esound[soundnum], False);
      BASS_ChannelSetAttribute(ch, BASS_ATTRIB_VOL, VOLUMEWAV / 100.0);
      if repeatable then
        BASS_ChannelFlags(ch, BASS_SAMPLE_LOOP, BASS_SAMPLE_LOOP)
      else
        BASS_ChannelFlags(ch, 0, BASS_SAMPLE_LOOP);
      BASS_ChannelPlay(ch, repeatable);
    end;

end;

procedure PlaySound(SoundNum, times, x, y, z: integer); overload;
var
  ch: HCHANNEL;
  repeatable: boolean;
  pos, posvec, posvel: BASS_3DVECTOR;
  //音源的位置, 向量, 速度
  //p: PSource;
begin
  if times = -1 then
    repeatable := True
  else
    repeatable := False;

  if (SoundNum in [Low(Esound)..High(Esound)]) and (VOLUMEWAV > 0) then
    if Esound[SoundNum] <> 0 then
    begin
      //Mix_VolumeChunk(Esound[SoundNum], Volume);
      //Mix_PlayChannel(-1, Esound[SoundNum], 0);
      BASS_SampleStop(Esound[soundnum]);
      ch := BASS_SampleGetChannel(Esound[soundnum], False);
      //BASS_ChannelSet3DAttributes(ch, BASS_3DMODE_RELATIVE, -1, -1, -1, -1, -1);

      if SOUND3D = 1 then
      begin
        pos.x := x / 50.0;
        pos.y := y / 50.0;
        pos.z := z / 50.0;
        //posvec.x := x;
        //posvec.y := y;
        //posvec.z := z;
        //posvel.x := -x / 50.0;
        //posvel.y := -y / 50.0;
        //posvel.z := -z / 50.0;
        if (x = 0) and (y = 0) and (z = 0) then
        begin
          pos.z := 0.1;
          //posvel.z := -0.2;
        end;

        BASS_ChannelSet3DPosition(ch, pos, posvec, posvel);
        BASS_Apply3D();
      end;
      BASS_ChannelSetAttribute(ch, BASS_ATTRIB_VOL, VOLUMEWAV / 100.0);
      if repeatable then
        BASS_ChannelFlags(ch, BASS_SAMPLE_LOOP, BASS_SAMPLE_LOOP)
      else
        BASS_ChannelFlags(ch, 0, BASS_SAMPLE_LOOP);
      BASS_ChannelPlay(ch, repeatable);
      //BASS_Apply3D();
    end;

end;

procedure PlaySoundA(SoundNum, times: integer); overload;
var
  ch: HCHANNEL;
  repeatable: boolean;
begin
  if times = -1 then
    repeatable := True
  else
    repeatable := False;
  if (SoundNum in [Low(Asound)..High(Asound)]) and (VOLUMEWAV > 0) then
    if Asound[SoundNum] <> 0 then
    begin
      //Mix_VolumeChunk(Esound[SoundNum], Volume);
      //Mix_PlayChannel(-1, Esound[SoundNum], 0);
      BASS_SampleStop(Asound[soundnum]);
      ch := BASS_SampleGetChannel(Asound[soundnum], False);
      BASS_ChannelSetAttribute(ch, BASS_ATTRIB_VOL, VOLUMEWAV / 100.0);
      if repeatable then
        BASS_ChannelFlags(ch, BASS_SAMPLE_LOOP, BASS_SAMPLE_LOOP)
      else
        BASS_ChannelFlags(ch, 0, BASS_SAMPLE_LOOP);
      BASS_ChannelPlay(ch, repeatable);
    end;

end;

procedure PlaySound(SoundNum: integer); overload;
begin
  PlaySound(Soundnum, 0);

end;

procedure PlaySound(filename: pchar; times: integer); overload;
begin
  {if fileexists(filename) then
  begin
    Sound := Mix_LoadWav(filename);
    Mix_PlayChannel(-1, sound, times);
  end;}
end;


//获取某像素信息

function GetPixel(surface: PSDL_Surface; x: integer; y: integer): uint32;
type
  TByteArray = array[0..2] of byte;
  PByteArray = ^TByteArray;
var
  bpp: integer;
  p: PInteger;
begin
  if (x >= 0) and (x < surface.w) and (y >= 0) and (y < surface.h) then
  begin
    bpp := surface.format.BytesPerPixel;
    // Here p is the address to the pixel we want to retrieve
    p := Pointer(uint32(surface.pixels) + y * surface.pitch + x * bpp);
    case bpp of
      1:
        Result := longword(p^);
      2:
        Result := puint16(p)^;
      {3:
        if (SDL_BYTEORDER = SDL_BIG_ENDIAN) then
          Result := PByteArray(p)[0] shl 16 or PByteArray(p)[1] shl 8 or PByteArray(p)[2]
        else
          Result := PByteArray(p)[0] or PByteArray(p)[1] shl 8 or PByteArray(p)[2] shl 16;}
      4:
        Result := puint32(p)^;
      else
        Result := 0; // shouldn't happen, but avoids warnings
    end;
  end;

end;

//画像素

procedure PutPixel(surface: PSDL_Surface; x: integer; y: integer; pixel: uint32);
type
  TByteArray = array[0..2] of byte;
  PByteArray = ^TByteArray;
var
  bpp: integer;
  p: PInteger;
begin
  if (x >= 0) and (x < surface.w) and (y >= 0) and (y < surface.h) then
  begin
    bpp := surface.format.BytesPerPixel;
    // Here p is the address to the pixel we want to set
    p := Pointer(uint32(surface.pixels) + y * surface.pitch + x * bpp);
    case bpp of
      1:
        longword(p^) := pixel;
      2:
        puint16(p)^ := pixel;
      {3:
        if (SDL_BYTEORDER = SDL_BIG_ENDIAN) then
        begin
          PByteArray(p)[0] := (pixel shr 16) and $FF;
          PByteArray(p)[1] := (pixel shr 8) and $FF;
          PByteArray(p)[2] := pixel and $FF;
        end
        else
        begin
          PByteArray(p)[0] := pixel and $FF;
          PByteArray(p)[1] := (pixel shr 8) and $FF;
          PByteArray(p)[2] := (pixel shr 16) and $FF;
        end; }
      4:
        puint32(p)^ := pixel;
    end;
  end;
end;


//取调色板的颜色, 视频系统是32位色, 但很多时候仍需要原调色板的颜色

function ColColor(num: integer): uint32;
begin
  //result.
  ColColor := MapRGBA(Acol[num * 3] * 4, Acol[num * 3 + 1] * 4, Acol[num * 3 + 2] * 4);
end;

//判断像素是否在屏幕内

function JudgeInScreen(px, py, w, h, xs, ys: integer): boolean; overload;
begin
  Result := False;
  //if (px - xs + w >= 0) and (px - xs < screen.w) and (py - ys + h >= 0) and (py - ys < screen.h) then
  Result := True;

end;

//判断像素是否在指定范围内(重载)

function JudgeInScreen(px, py, w, h, xs, ys, xx, yy, xw, yh: integer): boolean; overload;
begin
  Result := False;
  if (px - xs + w >= xx) and (px - xs < xx + xw) and (py - ys + h >= yy) and (py - ys < yy + yh) then
    Result := True;

end;

//获取游戏中坐标在屏幕上的位置

function GetPositionOnScreen(x, y, CenterX, CenterY: integer): TPosition;
begin
  Result.x := -(x - CenterX) * 18 + (y - CenterY) * 18 + CENTER_X;
  Result.y := (x - CenterX) * 9 + (y - CenterY) * 9 + CENTER_Y;
  if needOffset <> 0 then
  begin
    Result.x := Result.x - offsetX;
    Result.y := Result.y - offsetY;
  end;
end;


//big5转为unicode

function Big5ToUnicode(str: pchar): WideString;
var
  len: integer;
begin
{$IFDEF fpc}
  Result := UTF8Decode(CP950ToUTF8(str));
{$ELSE}
  len := MultiByteToWideChar(950, 0, pchar(str), -1, nil, 0);
  setlength(Result, len - 1);
  MultiByteToWideChar(950, 0, pchar(str), length(str), pWideChar(Result), len + 1);
{$ENDIF}
end;

function GBKToUnicode(str: pchar): WideString;
var
  len: integer;
begin
{$IFDEF fpc}
  Result := UTF8Decode(CP936ToUTF8(str));
{$ELSE}
  len := MultiByteToWideChar(950, 0, pchar(str), -1, nil, 0);
  setlength(Result, len - 1);
  MultiByteToWideChar(950, 0, pchar(str), length(str), pWideChar(Result), len + 1);
{$ENDIF}
end;

function PCharToUnicode(str: pchar; len: integer = -1): WideString;
begin
  Result := pWideChar(str);
  if len >= 0 then
  begin
    if length(Result) > len then
      setlength(Result, len);
  end;
end;

//unicode转为big5, 仅用于输入姓名

function UnicodeToBig5(str: pWideChar): string;
var
  len: integer;
begin
{$IFDEF fpc}
  Result := UTF8ToCP950((str));
{$ELSE}
  len := WideCharToMultiByte(950, 0, pWideChar(str), -1, nil, 0, nil, nil);
  setlength(Result, len + 1);
  WideCharToMultiByte(950, 0, pWideChar(str), -1, pchar(Result), len + 1, nil, nil);
{$ENDIF}

end;

//unicode转为GBK, 仅用于输入姓名

function UnicodeToGBK(str: pWideChar): string;
var
  len: integer;
begin
{$IFDEF fpc}
  Result := UTF8ToCP936((str));
{$ELSE}
  len := WideCharToMultiByte(936, 0, pWideChar(str), -1, nil, 0, nil, nil);
  setlength(Result, len + 1);
  WideCharToMultiByte(936, 0, pWideChar(str), -1, pchar(Result), len + 1, nil, nil);
{$ENDIF}

end;

//繁体汉字转化成简体汉字

function Traditional2Simplified(mTraditional: string): string; //返回繁体字符串
var
  L: integer;
begin
  L := Length(mTraditional);
  SetLength(Result, L + 1);
  Result[L + 1] := char(0);
{$IFDEF windows}
  if L > 0 then
    LCMapString(GetUserDefaultLCID,
      $02000000, pchar(mTraditional), L, @Result[1], L);
{$ELSE}
  Result := mTraditional;
{$ENDIF}
end; {   Traditional2Simplified   }

//生成或查找已知纹理, 返回其指针, 是否销毁由调用者决定
//返回值为建议是否销毁是否已经保存

function CreateFontTile(num: uint16; usesur: integer; var p: pointer; var w, h: integer): boolean;
var
  size0, size: integer;
  pfont: PTTF_Font;
  needcreate: boolean;
  whitecolor: uint32 = $ffffffff;
  word: array[0..2] of uint16 = (32, 0, 0);
  src, dst: TSDL_Rect;
  sur, tempsur: PSDL_Surface;
  tex, temptex: PSDL_Texture;
begin
  Result := False;
  //是否可能是已有纹理
  if num >= $1000 then
  begin
    size0 := CHINESE_FONT_SIZE;
    size := CHINESE_FONT_REALSIZE;
    pfont := font;
    src.x := CHNFONT_SPACEWIDTH;
    src.y := 0;
    word[1] := num;
  end
  else
  begin
    size0 := ENGLISH_FONT_SIZE;
    size := ENGLISH_FONT_REALSIZE;
    pfont := engfont;
    src.x := 0;
    src.y := 0;
    word[0] := num;
  end;

  //可以直接查找的情况, 其他情况需要创建
  if (size = size0) and (CharSize[num] = size0) then
  begin
    case usesur of
      0:
      begin
        p := CharTex[num];
        SDL_QueryTexture(CharTex[num], nil, nil, @w, @h);
      end;
      else
      begin
        p := CharSur[num];
        w := CharSur[num].w;
        h := CharSur[num].h;
      end;
    end;
    Result := True;
  end
  else
  begin
    tempsur := TTF_RenderUNICODE_blended(pfont, @word[0], TSDL_Color(whitecolor));
    if tempsur <> nil then
    begin
      src.w := tempsur.w - src.x;
      src.h := tempsur.h;
    end
    else
    begin
      src.w := 0;
      src.h := 0;
    end;
    dst.x := 0;
    dst.y := 0;
    dst.w := src.w;
    dst.h := src.h;
    w := src.w;
    h := src.h;
    sur := SDL_CreateRGBSurface(0, dst.w, dst.h, 32, RMASK, GMASK, BMASK, AMASK);
    SDL_SetSurfaceBlendMode(tempsur, SDL_BLENDMODE_NONE);
    SDL_UpperBlit(tempsur, @src, sur, @dst);
    try
      SDL_FreeSurface(tempsur);
    except
      writeln('Free font surface ', widechar(num), size0, ' failed.');
    end;

    if usesur = 0 then
    begin
      tex := SDL_CreateTextureFromSurface(render, sur);
      SDL_FreeSurface(sur);
      p := Tex;
      //检查是否需要保存
      if size = size0 then
      begin
        Write(widechar(num));
        if CharSize[num] > 0 then
          SDL_DestroyTexture(CharTex[num]);
        CharTex[num] := tex;
        CharSize[num] := size0;
        Result := True;
      end;
    end
    else
    begin
      p := pointer(Sur);
      if size = size0 then
      begin
        Write(widechar(num));
        if CharSize[num] > 0 then
          SDL_FreeSurface(CharSur[num]);
        CharSur[num] := sur;
        CharSize[num] := size0;
        Result := True;
      end;
    end;

  end;
end;

//显示unicode文字
//engsize如果未指定则按照中文宽度一半

procedure DrawText(word: puint16; x_pos, y_pos: integer; color: uint32; engwidth: integer = -1);
var
  dest, src, dst: TSDL_Rect;
  tempcolor, whitecolor: TSDL_Color;
  len, i, k: integer;
  word0: array[0..2] of uint16 = (32, 0, 0);
  word1: ansistring;
  word2: WideString;
  p1: pbyte;
  p2: pbyte;
  t: WideString;
  Sur: PSDL_Surface;
  Tex, ptex: PSDL_Texture;
  r, g, b, size: byte;
  saved: boolean;
  p: pointer;
  w, h: integer;
begin
{$IFDEF fpc}
  //widestring在fpc中的默认赋值动作是将utf8码每字节间插入一个00.
  //此处删除这些0, 同时统计这些0的数目, 若与字串长度相同
  //即认为是一个纯英文字串, 或者是一个直接赋值的widestring,
  //需要再编码为Unicode, 否则即认为已经是Unicode
  len := length(pWideChar(word));
  setlength(word1, len * 2 + 1);
  p1 := @word1[1];
  p2 := pbyte(word);
  k := 0;
  for i := 0 to len - 1 do
  begin
    p1^ := p2^;
    Inc(p1);
    Inc(p2);
    if p2^ = 0 then
    begin
      k := k + 1;
      Inc(p2);
    end
    else
    begin
      p1^ := p2^;
      Inc(p1);
      Inc(p2);
    end;
  end;
  p1^ := 0;
  if k >= len then
  begin
    word2 := UTF8Decode(word1);
    word := @word2[1];
  end;
{$ELSE}
  //word2 := UTF8Decode(string(word));
  //word := @word2[1];
{$ENDIF}

  GetRGBA(color, @r, @g, @b);
  tempcolor.r := r;
  tempcolor.g := g;
  tempcolor.b := b;
  tempcolor.a := 255;

  if engwidth <= 0 then
    engwidth := CHINESE_FONT_REALSIZE div 2;

  if SIMPLE = 1 then
  begin
    t := Traditional2Simplified(pWideChar(word));
    word := puint16(t);
  end;

  dest.x := x_pos;
  dest.y := y_pos;

  //如果当前为标准字号, 则创建纹理, 否则临时生成表面
  while word^ > 0 do
  begin
    i := word^;
    word0[1] := i;
    Inc(word);
    if i >= $1000 then
      dest.y := y_pos
    else
      dest.y := y_pos + 4;
    saved := CreateFontTile(i, SW_SURFACE, p, w, h);
    dest.w := w;
    dest.h := h;
    case SW_SURFACE of
      0:
      begin
        tex := PSDL_Texture(p);
        SDL_SetTextureColorMod(tex, r, g, b);
        if TEXT_LAYER = 1 then
        begin
          SDL_SetTextureBlendMode(tex, SDL_BLENDMODE_MOD);
          SDL_RenderCopy(render, tex, nil, @dest);
          SDL_SetTextureBlendMode(tex, SDL_BLENDMODE_BLEND);
        end;
        SDL_RenderCopy(render, tex, nil, @dest);
        if not saved then
          SDL_DestroyTexture(tex);
      end;
      else
      begin
        sur := PSDL_Surface(p);
        SDL_SetSurfaceColorMod(sur, r, g, b);
        if TEXT_LAYER = 1 then
        begin
          SDL_SetSurfaceBlendMode(sur, SDL_BLENDMODE_MOD);
          SDL_UpperBlit(sur, nil, CurTargetSurface, @dest);
        end;
        SDL_SetSurfaceBlendMode(sur, SDL_BLENDMODE_BLEND);
        SDL_UpperBlit(sur, nil, CurTargetSurface, @dest);
      end;
    end;
    if i >= $1000 then
      dest.x := dest.x + CHINESE_FONT_REALSIZE
    else
      dest.x := dest.x + engwidth;
  end;
  HaveText := 1;

end;


//显示英文

procedure DrawEngText(word: puint16; x_pos, y_pos: integer; color: uint32);
var
  dest: TSDL_Rect;
  Text: PSDL_Surface;
  tempcolor: TSDL_Color;
  tex: PSDL_Texture;
  r, g, b: byte;
  str: WideString = ' ';
begin
  if (ENGLISH_FONT_SIZE = ENGLISH_FONT_REALSIZE) then
    DrawText(word, x_pos, y_pos - 4, color, -1)
  else
  begin
    //Text := TTF_RenderUNICODE_solid(engfont, @str[1], tempcolor);
    DrawText(word, x_pos, y_pos - 4, color, ENGLISH_FONT_REALSIZE div 2 + 1);
    //sdl_freesurface(Text);
  end;

end;


//显示unicode中文阴影文字, 即将同样内容显示2次, 间隔1像素
procedure DrawShadowText(word: puint16; x_pos, y_pos: integer; color1, color2: uint32;
  Tex: PSDL_Texture = nil; Sur: PSDL_Surface = nil; realPosition: integer = 0; eng: integer = 0); overload;
var
  w, h: integer;
  ptex: PSDL_Texture;
  pscreen: PSDL_Surface;
  changed: boolean = False;
begin
  if SW_SURFACE = 0 then
  begin
    ptex := SDL_GetRenderTarget(render);
    if Tex = nil then
    begin
      if TEXT_LAYER <> 0 then
        SDL_SetRenderTarget(render, TextScreenTex);
    end
    else
      SDL_SetRenderTarget(render, Tex);
  end
  else
  begin
    pscreen := CurTargetSurface;
    if Sur = nil then
    begin
      if TEXT_LAYER <> 0 then
        CurTargetSurface := TextScreen;
    end
    else
      CurTargetSurface := Sur;
  end;

  if realPosition = 0 then
    GetRealRect(x_pos, y_pos, w, h);
  if eng = 0 then
  begin
    DrawText(word, x_pos + 1, y_pos, color2);
    DrawText(word, x_pos, y_pos, color1);
  end
  else
  begin
    DrawEngText(word, x_pos + 1, y_pos, color2);
    DrawEngText(word, x_pos, y_pos, color1);
  end;

  //if changed then
  if SW_SURFACE = 0 then
    SDL_SetRenderTarget(render, ptex)
  else
    CurTargetSurface := pscreen;

end;

//显示英文阴影文字

procedure DrawEngShadowText(word: puint16; x_pos, y_pos: integer; color1, color2: uint32;
  Tex: PSDL_Texture = nil; Sur: PSDL_Surface = nil);
begin
  DrawShadowText(word, x_pos, y_pos + 4, color1, color2, Tex, Sur, 0, 1);
end;

//显示big5文字

procedure DrawBig5Text(sur: PSDL_Surface; str: pchar; x_pos, y_pos: integer; color: uint32);
var
  len: integer;
  words: WideString;
begin
{$IFDEF fpc}
  words := UTF8Decode(CP950ToUTF8(str));
{$ELSE}
  len := MultiByteToWideChar(950, 0, pchar(str), -1, nil, 0);
  setlength(words, len - 1);
  MultiByteToWideChar(950, 0, pchar(str), length(str), pWideChar(words), len + 1);
{$ENDIF}
  DrawText(@words[1], x_pos, y_pos, color);

end;

//显示big5阴影文字

procedure DrawBig5ShadowText(word: pchar; x_pos, y_pos: integer; color1, color2: uint32);
var
  len: integer;
  words: WideString;
begin
{$IFDEF fpc}
  words := UTF8Decode(CP950ToUTF8(word));
{$ELSE}
  len := MultiByteToWideChar(950, 0, pchar(word), -1, nil, 0);
  setlength(words, len - 1);
  MultiByteToWideChar(950, 0, pchar(word), length(word), pWideChar(words), len + 1);
{$ENDIF}
  DrawShadowText(@words[1], x_pos + 1, y_pos, color1, color2);

end;

//显示GBK阴影文字

procedure DrawGBKShadowText(word: pchar; x_pos, y_pos: integer; color1, color2: uint32);
var
  len: integer;
  words: WideString;
begin
{$IFDEF fpc}
  words := UTF8Decode(CP936ToUTF8(word));
{$ELSE}
  len := MultiByteToWideChar(950, 0, pchar(word), -1, nil, 0);
  setlength(words, len - 1);
  MultiByteToWideChar(950, 0, pchar(word), length(word), pWideChar(words), len + 1);
{$ENDIF}
  DrawShadowText(@words[1], x_pos + 1, y_pos, color1, color2);

end;

//显示Unicode16阴影文字

procedure DrawU16ShadowText(word: pchar; x_pos, y_pos: integer; color1, color2: uint32);
var
  words: WideString;
begin
  words := pWideChar(word);
  DrawShadowText(@words[1], x_pos + 1, y_pos, color1, color2);

end;

//显示带边框的文字, 仅用于unicode, 需自定义宽度
//默认情况为透明度50, 立即刷新

procedure DrawTextWithRect(word: puint16; x, y, w: integer; color1, color2: uint32;
  alpha: integer = 50; Refresh: integer = 1);
var
  len: integer;
  p: pchar;
begin
  DrawRectangle(x, y, w, 26, 0, ColColor(255), alpha);
  DrawShadowText(word, x + 3, y + 2, color1, color2);
  if Refresh <> 0 then
    UpdateAllScreen;
  //SDL_UpdateRect2(screen, x, y, w + 1, 29);

end;

//画带边框矩形, (x坐标, y坐标, 宽度, 高度, 内部颜色, 边框颜色, 透明度）

procedure DrawRectangle(x, y, w, h: integer; colorin, colorframe: uint32; alpha: integer);
var
  i1, i2, l1, l2, l3, l4, x1, y1, w1, h1: integer;
  tempscr, tempsur1: PSDL_Surface;
  dest: TSDL_Rect;
  r, g, b, r1, g1, b1, a: byte;
  tex, ptex: PSDL_Texture;
  color: TSDL_Color;
begin
  if SW_SURFACE = 0 then
  begin
    ptex := SDL_GetRenderTarget(render);
    tex := SDL_CreateTexture(render, SDL_PIXELFORMAT_ARGB8888, SDL_TEXTUREACCESS_TARGET, w + 1, h + 1);
    SDL_SetRenderTarget(render, tex);
    GetRGBA(colorin, @r, @g, @b);
    GetRGBA(colorframe, @r1, @g1, @b1);
    SDL_SetRenderDrawBlendMode(render, SDL_BLENDMODE_NONE);
    SDL_SetRenderDrawColor(render, r, g, b, alpha * 255 div 100);
    dest.x := x;
    dest.y := y;
    dest.w := w;
    dest.h := h;
    SDL_RenderFillRect(render, nil);

    for i1 := 0 to w do
      for i2 := 0 to h do
      begin
        l1 := i1 + i2;
        l2 := -(i1 - w) + (i2);
        l3 := (i1) - (i2 - h);
        l4 := -(i1 - w) - (i2 - h);
        //4边角
        if not ((l1 >= 4) and (l2 >= 4) and (l3 >= 4) and (l4 >= 4)) then
        begin
          SDL_SetRenderDrawColor(render, 0, 0, 0, 0);
          SDL_RenderDrawPoint(render, i1, i2);
        end;
        //框线
        if TEXT_LAYER = 0 then
          if (((l1 >= 4) and (l2 >= 4) and (l3 >= 4) and (l4 >= 4) and ((i1 = 0) or (i1 = w) or
            (i2 = 0) or (i2 = h))) or ((l1 = 4) or (l2 = 4) or (l3 = 4) or (l4 = 4))) then
          begin
            a := round(250 - abs(i1 / w + i2 / h - 1) * 150);
            SDL_SetRenderDrawColor(render, r1, g1, b1, a);
            SDL_RenderDrawPoint(render, i1, i2);
          end;
      end;
    SDL_SetRenderTarget(render, ptex);
    SDL_SetTextureBlendMode(tex, SDL_BLENDMODE_BLEND);
    //SDL_SetRenderDrawColor(render, 255, 255, 255, 255);
    SDL_RenderCopy(render, tex, nil, @dest);
    SDL_DestroyTexture(tex);

    if TEXT_LAYER = 1 then
    begin
      GetRealRect(x, y, w, h);
      dest.x := x;
      dest.y := y;
      dest.w := w;
      dest.h := h;
      tex := SDL_CreateTexture(render, SDL_PIXELFORMAT_ARGB8888, SDL_TEXTUREACCESS_TARGET, w + 1, h + 1);
      SDL_SetRenderTarget(render, tex);
      SDL_SetRenderDrawColor(render, 0, 0, 0, 0);
      SDL_RenderFillRect(render, nil);
      for i1 := 0 to w do
        for i2 := 0 to h do
        begin
          l1 := i1 + i2;
          l2 := -(i1 - w) + (i2);
          l3 := (i1) - (i2 - h);
          l4 := -(i1 - w) - (i2 - h);
          //框线
          if (((l1 >= 4) and (l2 >= 4) and (l3 >= 4) and (l4 >= 4) and ((i1 = 0) or (i1 = w) or
            (i2 = 0) or (i2 = h))) or ((l1 = 4) or (l2 = 4) or (l3 = 4) or (l4 = 4))) then
          begin
            a := round(250 - abs(i1 / w + i2 / h - 1) * 150);
            SDL_SetRenderDrawColor(render, r1, g1, b1, a);
            SDL_RenderDrawPoint(render, i1, i2);
          end;
        end;
      SDL_SetRenderTarget(render, TextScreenTex);
      SDL_SetTextureBlendMode(tex, SDL_BLENDMODE_BLEND);
      SDL_RenderCopy(render, tex, nil, @dest);
      SDL_DestroyTexture(tex);
      SDL_SetRenderTarget(render, ptex);
    end;
  end
  else
  begin
    w := abs(w);
    h := abs(h);

    tempscr := SDL_CreateRGBSurface(0, w + 1, h + 1, 32, RMask, GMask, BMask, AMask);
    GetRGBA(colorin, @r, @g, @b);
    GetRGBA(colorframe, @r1, @g1, @b1);
    SDL_FillRect(tempscr, nil, MapRGBA(r, g, b, alpha * 255 div 100));

    dest.x := x;
    dest.y := y;
    dest.w := 0;
    dest.h := 0;

    x1 := 0;
    y1 := 0;

    for i1 := 0 to w do
      for i2 := 0 to h do
      begin
        l1 := i1 + i2;
        l2 := -(i1 - w) + (i2);
        l3 := (i1) - (i2 - h);
        l4 := -(i1 - w) - (i2 - h);
        //4边角
        if not ((l1 >= 4) and (l2 >= 4) and (l3 >= 4) and (l4 >= 4)) then
        begin
          PutPixel(tempscr, i1 + x1, i2 + y1, 0);
        end;
        //框线
        if TEXT_LAYER = 0 then
          if (((l1 >= 4) and (l2 >= 4) and (l3 >= 4) and (l4 >= 4) and ((i1 = 0) or (i1 = w) or
            (i2 = 0) or (i2 = h))) or ((l1 = 4) or (l2 = 4) or (l3 = 4) or (l4 = 4))) then
          begin
            //a := round(200 - min(abs(i1/w-0.5),abs(i2/h-0.5))*2 * 100);
            a := round(250 - abs(i1 / w + i2 / h - 1) * 150);
            //writeln(a);
            PutPixel(tempscr, i1 + x1, i2 + y1, MapRGBA(r1, g1, b1, a));
          end;
      end;

    SDL_UpperBlit(tempscr, nil, CurTargetSurface, @dest);
    SDL_FreeSurface(tempscr);

    if (TEXT_LAYER = 1) and (CurTargetSurface = screen) then
    begin
      GetRealRect(x, y, w, h);
      tempscr := SDL_CreateRGBSurface(0, w + 1, h + 1, 32, RMask, GMask, BMask, AMask);
      GetRGBA(colorframe, @r1, @g1, @b1);
      SDL_FillRect(tempscr, nil, 0);
      x1 := 0;
      y1 := 0;
      for i1 := 0 to w do
        for i2 := 0 to h do
        begin
          l1 := i1 + i2;
          l2 := -(i1 - w) + (i2);
          l3 := (i1) - (i2 - h);
          l4 := -(i1 - w) - (i2 - h);
          //框线
          if (((l1 >= 4) and (l2 >= 4) and (l3 >= 4) and (l4 >= 4) and ((i1 = 0) or (i1 = w) or
            (i2 = 0) or (i2 = h))) or ((l1 = 4) or (l2 = 4) or (l3 = 4) or (l4 = 4))) then
          begin
            //a := round(200 - min(abs(i1/w-0.5),abs(i2/h-0.5))*2 * 100);
            a := round(250 - abs(i1 / w + i2 / h - 1) * 150);
            //writeln(a);
            PutPixel(tempscr, i1 + x1, i2 + y1, MapRGBA(r1, g1, b1, a));
          end;
        end;
      dest.x := x;
      dest.y := y;
      dest.w := 0;
      dest.h := 0;
      SDL_UpperBlit(tempscr, nil, TextScreen, @dest);
      SDL_FreeSurface(tempscr);
    end;
  end;
end;

//画不含边框的矩形, 用于对话, 黑屏, 血条

procedure DrawRectangleWithoutFrame(x, y, w, h: integer; colorin: uint32; alpha: integer);
var
  tempscr: PSDL_Surface;
  dest: TSDL_Rect;
  i1, i2: integer;
  tran: byte;
  bigtran: uint32;
  r, g, b, a: byte;
begin
  //ptex := SDL_GetRenderTarget(render);
  //tex := SDL_CreateTexture(render, SDL_PIXELFORMAT_ARGB8888, SDL_TEXTUREACCESS_TARGET, w, h);
  //SDL_SetRenderTarget(render, tex);
  GetRGBA(colorin, @r, @g, @b);
  if SW_SURFACE = 0 then
  begin
    SDL_SetRenderDrawBlendMode(render, SDL_BLENDMODE_BLEND);
    SDL_SetRenderDrawColor(render, r, g, b, 255 - 255 * alpha div 100);
    dest.x := x;
    dest.y := y;
    dest.w := w;
    dest.h := h;
    if alpha >= 0 then
      SDL_RenderFillRect(render, @dest);
    if alpha = -1 then
    begin
      for i1 := x to x + w - 1 do
        for i2 := y to y + h - 1 do
        begin
          //if (i1 < sur.w) and (i2 < sur.h) then
          begin
            a := round(250 - abs((i2 - y) / h - 0.5) * 150);
            //a := round(250 - abs((i1 - x) / w + (i2 - y) / h - 1) * 150);
            SDL_SetRenderDrawColor(render, r, g, b, a);
            SDL_RenderDrawPoint(render, i1, i2);
          end;
        end;
    end;
  end
  else
  begin
    if (w > 0) and (h > 0) then
    begin
      tempscr := SDL_CreateRGBSurface(0, w, h, 32, RMask, GMask, BMask, AMASK);
      SDL_FillRect(tempscr, nil, MapRGBA(r, g, b, 255 - alpha * 255 div 100));
      //SDL_SetSurfaceAlphaMod(tempscr, 255 - alpha * 255 div 100);
      SDL_SetSurfaceBlendMode(tempscr, SDL_BLENDMODE_BLEND);
      if CurTargetSurface = TextScreen then
        SDL_SetSurfaceBlendMode(tempscr, SDL_BLENDMODE_MOD);
      dest.x := x;
      dest.y := y;
      if alpha >= 0 then
        SDL_UpperBlit(tempscr, nil, CurTargetSurface, @dest);
      if alpha = -1 then
      begin
        //SDL_FillRect(tempscr, nil, MapRGBA(r, g, b, 255 - alpha * 255 div 100));
        for i1 := 0 to w - 1 do
          for i2 := 0 to h - 1 do
          begin
            a := round(250 - abs(i2 / h - 0.5) * 150);
            PutPixel(tempscr, i1, i2, MapRGBA(r, g, b, a));
          end;
        //if CurTargetSurface<> screen then
        //SDL_SetSurfaceBlendMode(tempscr, SDL_BLENDMODE_NONE);
        SDL_UpperBlit(tempscr, nil, CurTargetSurface, @dest);
      end;
      SDL_FreeSurface(tempscr);
    end;
  end;
  //SDL_SetRenderTarget(render, ptex);

  //SDL_SetTextureAlphaMod(tex, 255-255*alpha div 100);
  //writeln(alpha);
  //SDL_SetRenderDrawColor(render, 255,255,255,255);
  //SDL_RenderCopy(render, tex, nil, @dest);
  //sdl_destroytexture(tex);
  {if (SDL_MustLock(screen)) then
  begin
    SDL_LockSurface(screen);
  end;}
  {if (w > 0) and (h > 0) then
  begin
    if sur.flags = 0 then
    begin
      tempscr := SDL_CreateRGBSurface(sur.flags, w, h, 32, RMask, GMask, BMask, 0);
      SDL_FillRect(tempscr, nil, colorin);
      //SDL_SetAlpha(tempscr, 0, 255 - alpha * 255 div 100);
      dest.x := x;
      dest.y := y;
      //tempscr1 := sdl_displayformatalpha(tempscr);
      SDL_BlitSurface(tempscr, nil, sur, @dest);
      SDL_FreeSurface(tempscr);
    end
    else
    begin
      SDL_GetRGB(colorin, sur.format, @r, @g, @b);
      a := 255 - 255 * alpha div 100;
      for i1 := x to x + w - 1 do
        for i2 := y to y + h - 1 do
        begin
          if (i1 < sur.w) and (i2 < sur.h) then
          begin
            if alpha = -1 then
              a := round(250 - abs((i2 - y) / h - 0.5) * 150);
            //a := round(250 - abs((i1 - x) / w + (i2 - y) / h - 1) * 150);
            PutPixel(sur, i1, i2, SDL_MapRGBA(sur.format, r, g, b, a));
          end;
        end;
    end;
  end;
  //rectangleRGBA(sur, x, y, x+w, y+h, 0, 0, 0,alpha * 255 div 100);
  {if (SDL_MustLock(screen)) then
  begin
    SDL_UnlockSurface(screen);
  end;}

end;


//画白色边框作为物品选单的光标
//realcoord-使用实际坐标, 默认为物品栏的坐标
procedure DrawItemFrame(x, y: integer; realcoord: integer = 0);
var
  i, xp, yp, d, d2: integer;
  t: byte;
  color: uint32;
  ptex: PSDL_Texture;
  sur: PSDL_Surface;
begin
  d := 83;
  d2 := 80;
  //物品栏则计算物品的坐标, 否则按照绝对坐标绘图
  if realcoord = 0 then
  begin
    xp := CENTER_X - 384 + 300;
    yp := CENTER_Y - 240 + 65;
    x := x * d + 5 + xp;
    y := y * d + 35 + yp;
  end
  else
  begin
    x := x - 1;
    y := y - 1;
  end;

  if SW_SURFACE = 0 then
  begin
    if TEXT_LAYER = 1 then
    begin
      ptex := SDL_GetRenderTarget(render);
      SDL_SetRenderTarget(render, TextScreenTex);
      GetRealRect(x, y, d, d2);
    end;
    for i := 0 to d2 do
    begin
      t := 250 - i * 2;
      SDL_SetRenderDrawColor(render, t, t, t, 255);
      SDL_RenderDrawPoint(render, x + i, y);
      SDL_RenderDrawPoint(render, x + d2 - i, y + d2);
      SDL_RenderDrawPoint(render, x, y + i);
      SDL_RenderDrawPoint(render, x + d2, y + d2 - i);
    end;
    if TEXT_LAYER = 1 then
      SDL_SetRenderTarget(render, ptex);
  end
  else
  begin
    if TEXT_LAYER = 1 then
    begin
      sur := TextScreen;
      GetRealRect(x, y, d, d2);
    end
    else
      sur := screen;
    for i := 0 to d2 do
    begin
      t := 250 - i * 2;
      color := MapRGBA(t, t, t, 255);
      PutPixel(sur, x + i, y, color);
      PutPixel(sur, x + d2 - i, y + d2, color);
      PutPixel(sur, x, y + i, color);
      PutPixel(sur, x + d2, y + d2 - i, color);
    end;
  end;
end;


//简体汉字转化成繁体汉字

function Simplified2Traditional(mSimplified: ansistring): ansistring; //返回繁体字符串
var
  L: integer;
begin
  L := Length(mSimplified);
  SetLength(Result, L + 1);
  Result[L + 1] := char(0);
{$IFDEF windows}
  if L > 0 then
    LCMapString(GetUserDefaultLCID,
      $04000000, pchar(mSimplified), L, @Result[1], L);
  //writeln(L,mSimplified,',',result,GetUserDefaultLCID);
{$ELSE}
  Result := mSimplified;
{$ENDIF}
end; {   Simplified2Traditional   }


procedure DrawPartPic(pic: pointer; x, y, w, h, x1, y1: integer);
var
  dest1, dest: TSDL_Rect;
begin
  dest1.x := x;
  dest1.y := y;
  dest1.w := w;
  dest1.h := h;
  dest.x := x1;
  dest.y := y1;
  dest.w := w;
  dest.h := h;
  if pic <> nil then
    if SW_SURFACE = 0 then
      SDL_RenderCopy(render, PSDL_Texture(pic), @dest1, @dest)
    else
      SDL_UpperBlit(PSDL_Surface(pic), @dest1, screen, @dest);
end;

procedure PlayBeginningMovie;
var
  i, grp, idx, len: integer;
  MOV: PSDL_Surface;
  MOVpic: array of byte;
  MOVidx: array of integer;
begin
  //PlayMp3(1,-1);
  //sdl_delay(500);
  {SDL_ShowCursor(SDL_DISABLE);
  if (FileExists('Logo') and FileExists('Txdx')) then
  begin
    grp := FileOpen('Logo', fmopenread);
    len := FileSeek(grp, 0, 2);
    FileSeek(grp, 0, 0);
    Setlength(MOVpic, len);
    FileRead(grp, MOVpic[0], len);
    FileClose(grp);

    idx := FileOpen('Txdx', fmopenread);
    len := FileSeek(idx, 0, 2);
    FileSeek(idx, 0, 0);
    Setlength(MOVidx, (len div 4));
    FileRead(idx, MOVidx[0], len);
    FileClose(idx);
    MOV := GetPngPic(@MOVPic[0], @MOVidx[0], 1);

    for i := 1 to MOVidx[0] - 1 do
    begin
      while SDL_PollEvent(@event) > 0 do
        CheckBasicEvent;
      MOV := GetPngPic(@MOVPic[0], @MOVidx[0], i);
      ZoomPic(MOV, (screen.w - mov.w) div 2, (screen.h - mov.h) div 2, MOV.w, MOV.h);
      if i * 5 < 100 then
      begin
        DrawRectangleWithoutFrame(0, 0, screen.w, screen.h, 0, 100 - (i * 5));
        SDL_Delay(20);
      end
      else
        SDL_Delay(50);
      SDL_UpdateRect2(screen, 0, 0, screen.w, screen.h);
      SDL_FreeSurface(MOV);
    end;
    Setlength(MOVpic, 0);
    Setlength(MOVIDX, 0);
    //Setlength(BGidx, 0);
  end;
  SDL_Delay(1500);
  for i := 0 to 20 do
  begin
    while SDL_PollEvent(@event) > 0 do
      CheckBasicEvent;
    DrawRectangleWithoutFrame(0, 0, screen.w, screen.h, 0, i * 5);
    SDL_Delay(20);
    SDL_UpdateRect2(screen, 0, 0, screen.w, screen.h);
    //Setlength(BGidx, 0);
  end;
  SDL_ShowCursor(SDL_ENABLE);}
end;


procedure SDL_UpdateRect2(scr1: PSDL_Surface; x, y, w, h: integer);
var
  realx, realy, realw, realh, ZoomType, i1, i2: integer;
  tempscr: PSDL_Surface;
  now, Next: uint32;
  destsrc, dest: TSDL_Rect;
  TextureID, TextureIDText: GLUint;
  r, g, b, r1, g1, b1: byte;
  xcoord, ycoord, scale, x1, y1, x2, y2, rx1, ry1, rx2, ry2: real;
begin
  {dest.x := x;
  dest.y := y;
  dest.w := w;
  dest.h := h;
  if scr1 = screen then
    SDL_BlitSurface(screen, @dest, prescreen, @dest);

  if RENDERER = 1 then
  begin
    glGenTextures(1, @TextureID);
    glBindTexture(GL_TEXTURE_2D, TextureID);
    glTexImage2D(GL_TEXTURE_2D, 0, GL_RGB, screen.w, screen.h, 0, GL_BGRA, GL_UNSIGNED_BYTE, prescreen.pixels);

    if SMOOTH = 1 then
    begin
      glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_LINEAR);
      glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_LINEAR);
    end
    else
    begin
      glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_NEAREST);
      glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_NEAREST);
    end;

    case ScreenBlendMode of
      0:
      begin
        glColor3f(1, 1, 1);
      end;
      1:
      begin
        glColor3f(150 / 255, 150 / 255, 220 / 255);
      end;
      2:
      begin
        glColor3f(200 / 255, 152 / 255, 20 / 255);
      end;
    end;

    if KEEP_SCREEN_RATIO = 1 then
    begin
      xcoord := screen.w / RealScreen.w;
      ycoord := screen.h / RealScreen.h;
      if xcoord < ycoord then
      begin
        xcoord := xcoord / ycoord;
        ycoord := 1;
      end
      else
      begin
        ycoord := ycoord / xcoord;
        xcoord := 1;
      end;
    end
    else
    begin
      xcoord := 1;
      ycoord := 1;
    end;
    glClear(GL_COLOR_BUFFER_BIT);
    glBindTexture(GL_TEXTURE_2D, TextureID);
    glEnable(GL_TEXTURE_2D);
    glBegin(GL_QUADS);
    glTexCoord2f(0.0, 0.0);
    glVertex3f(-xcoord, ycoord, 0.0);
    glTexCoord2f(1.0, 0.0);
    glVertex3f(xcoord, ycoord, 0.0);
    glTexCoord2f(1.0, 1.0);
    glVertex3f(xcoord, -ycoord, 0.0);
    glTexCoord2f(0.0, 1.0);
    glVertex3f(-xcoord, -ycoord, 0.0);
    glEnd;
    glDisable(GL_TEXTURE_2D);
    glDeleteTextures(1, @TextureID);

    if (Text_Layer = 1) and (HaveText = 1) then
    begin
      glGenTextures(1, @TextureIDText);
      glBindTexture(GL_TEXTURE_2D, TextureIDText);
      glTexImage2D(GL_TEXTURE_2D, 0, GL_RGBA, RealScreen.w, RealScreen.h, 0, GL_BGRA,
        GL_UNSIGNED_BYTE, TextScreen.pixels);

      if SMOOTH = 1 then
      begin
        glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_LINEAR);
        glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_LINEAR);
      end
      else
      begin
        glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_NEAREST);
        glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_NEAREST);
      end; }

  //GetRealRect(x, y, w, h);

      {x1 := x / realscreen.w;
      y1 := y / realscreen.h;
      x2 := (x + w) / realscreen.w;
      y2 := (y + h) / realscreen.h;

      rx1 := x1 * 2 - 1;
      rx2 := x2 * 2 - 1;
      ry1 := -y1 * 2 + 1;
      ry2 := -y2 * 2 + 1;}

      {x1 := 0;
      y1 := 0;
      x2 := 1;
      y2 := 1;
      rx1 := -1;
      rx2 := 1;
      ry1 := 1;
      ry2 := -1;

      glBindTexture(GL_TEXTURE_2D, TextureIDText);
      glEnable(GL_TEXTURE_2D);
      glEnable(GL_BLEND);
      //glClearColor(0.0, 0.0, 0.0, 0.5);
      glBlendFunc(GL_ONE_MINUS_DST_COLOR, GL_ONE);
      //glBlendColor(0.8,0.8,0.8,0.8);
      //glBlendFunc(GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA);
      //glColor4f(1.0,1.0,1.0,0.0);
      //glEnable(GL_ALPHA_TEST);
      //glAlphaFunc(GL_ALWAYS ,0);
      glBegin(GL_QUADS);
      glTexCoord2f(x1, y1);
      glVertex3f(rx1, ry1, 0.0);
      glTexCoord2f(x2, y1);
      glVertex3f(rx2, ry1, 0.0);
      glTexCoord2f(x2, y2);
      glVertex3f(rx2, ry2, 0.0);
      glTexCoord2f(x1, y2);
      glVertex3f(rx1, ry2, 0.0);
      {glTexCoord2f(x1, y1);
      glVertex3f(rx1, ry1, 0.0);
      glTexCoord2f(x2, y1);
      glVertex3f(rx2, ry1, 0.0);
      glTexCoord2f(x2, y2);
      glVertex3f(rx2, ry2, 0.0);
      glTexCoord2f(x1, y2);
      glVertex3f(rx1, ry2, 0.0);}
  //glColor4f(1.0,1.0,1.0,1);
      {glEnd;
      glDisable(GL_TEXTURE_2D);
      glDisable(GL_BLEND);
      //glBlendFunc(GL_ZERO, GL_ZERO);
      //glDisable(GL_ALPHA_TEST);
      glDeleteTextures(1, @TextureIDText);
    end;
    //SDL_GL_SwapBuffers;
  end
  else
  begin
  end;}

end;


procedure SDL_GetMouseState2(var x, y: integer);
var
  tempx, tempy: integer;
  px, py: integer;
  s: TStretchInfo;
begin
  SDL_GetMouseState(@tempx, @tempy);
  if KEEP_SCREEN_RATIO = 1 then
  begin
    s := KeepRatioScale(CENTER_X * 2, CENTER_Y * 2, RESOLUTIONX, RESOLUTIONY);
    x := ((tempx - s.px) * s.den div s.num);
    y := ((tempy - s.py) * s.den div s.num);
  end
  else
  begin
    x := round(tempx / RESOLUTIONX * CENTER_X * 2);
    y := round(tempy / RESOLUTIONY * CENTER_Y * 2);
  end;
end;

procedure DestroyRenderTextures;
var
  i: integer;
begin
  if (RENDERER = 0) and (SW_SURFACE = 0) then
  begin
    SDL_DestroyTexture(screenTex);
    SDL_DestroyTexture(ImgSGroundTex);
    SDL_DestroyTexture(ImgBGroundTex);
    SDL_DestroyTexture(SimpleStateTex);

    for i := 0 to 5 do
      SDL_DestroyTexture(SimpleStatusTex[i]);
    for i := 0 to High(FreshScreenTex) do
      FreeFreshScreen;
    if TEXT_LAYER <> 0 then
      for i := 0 to 5 do
      begin
        SDL_DestroyTexture(SimpleTextTex[i]);
        SimpleTextTex[i] := nil;
      end;

    if BlackScreenTex <> nil then
    begin
      SDL_DestroyTexture(BlackScreenTex);
      BlackScreenTex := nil;
    end;
  end;

  if TEXT_LAYER = 1 then
  begin
    //DestroyFontTextures;
    SDL_DestroyTexture(TextScreenTex);
    if SW_SURFACE = 0 then
    begin

    end
    else
    begin
      SDL_FreeSurface(TextScreen);
    end;
  end;

end;

procedure CreateAssistantRenderTextures;
var
  i, x, y: integer;
begin
  //此处创建尺寸会变化的纹理, 并重新打开字体
  if TEXT_LAYER = 1 then
  begin
    if SW_SURFACE = 0 then
    begin
      TextScreenTex := SDL_CreateTexture(render, SDL_PIXELFORMAT_ARGB8888, SDL_TEXTUREACCESS_TARGET,
        RESOLUTIONX, RESOLUTIONY);
      SDL_SetTextureBlendMode(TextScreenTex, SDL_BLENDMODE_BLEND);
      CleanTextScreen;
    end
    else
    begin
      TextScreen := SDL_CreateRGBSurface(0, RESOLUTIONX, RESOLUTIONY, 32, RMask, GMask, BMask, AMASK);
      TextScreenTex := SDL_CreateTexture(render, SDL_PIXELFORMAT_ARGB8888, SDL_TEXTUREACCESS_STREAMING,
        RESOLUTIONX, RESOLUTIONY);
      SDL_SetTextureBlendMode(TextScreenTex, SDL_BLENDMODE_BLEND);
    end;
    ResizeSimpleText(1);  //设定简单状态使用的字体层
    TTF_CloseFont(font);
    TTF_CloseFont(engfont);
    SetFontSize(20, 18, -1);
  end;
end;

procedure CreateMainRenderTextures;
var
  i: integer;
begin
  //此处创建尺寸基本不会变化的纹理
  if SW_SURFACE = 0 then
  begin
    screenTex := SDL_CreateTexture(render, 0, SDL_TEXTUREACCESS_TARGET, CENTER_X * 2, CENTER_Y * 2);
    ImgSGroundTex := SDL_CreateTexture(render, SDL_PIXELFORMAT_ARGB8888, SDL_TEXTUREACCESS_TARGET,
      ImageWidth, ImageHeight);
    ImgBGroundTex := SDL_CreateTexture(render, SDL_PIXELFORMAT_ARGB8888, SDL_TEXTUREACCESS_TARGET,
      ImageWidth, ImageHeight);
    SimpleStateTex := SDL_CreateTexture(render, SDL_PIXELFORMAT_ARGB8888, SDL_TEXTUREACCESS_TARGET, 270, 90);
    for i := 0 to 5 do
      SimpleStatusTex[i] := SDL_CreateTexture(render, SDL_PIXELFORMAT_ARGB8888, SDL_TEXTUREACCESS_TARGET, 270, 90);

    SDL_SetTextureBlendMode(screenTex, SDL_BLENDMODE_NONE);
    SDL_SetTextureBlendMode(ImgSGroundTex, SDL_BLENDMODE_NONE);
    SDL_SetTextureBlendMode(ImgBGroundTex, SDL_BLENDMODE_NONE);
    SDL_SetTextureBlendMode(SimpleStateTex, SDL_BLENDMODE_BLEND);
    SDL_SetRenderTarget(render, screenTex);
  end
  else
  begin
    screen := SDL_CreateRGBSurface(0, CENTER_X * 2, CENTER_Y * 2, 32, RMask, GMask, BMask, AMASK);
    ImgSGround := SDL_CreateRGBSurface(0, ImageWidth, ImageHeight, 32, RMask, GMask, BMask, AMASK);
    //SDL_SetSurfaceBlendMode(ImgSGround, SDL_BLENDMODE_NONE);
    ImgBGround := SDL_CreateRGBSurface(0, ImageWidth, ImageHeight, 32, RMask, GMask, BMask, AMASK);
    SimpleState := SDL_CreateRGBSurface(0, 270, 90, 32, RMask, GMask, BMask, AMASK);
    for i := 0 to 5 do
      SimpleStatus[i] := SDL_CreateRGBSurface(0, 270, 90, 32, RMask, GMask, BMask, AMASK);
    //SDL_SetSurfaceBlendMode(ImgBGround, SDL_BLENDMODE_NONE);
    CurTargetSurface := screen;

    screenTex := SDL_CreateTexture(render, SDL_PIXELFORMAT_ARGB8888, SDL_TEXTUREACCESS_STREAMING,
      CENTER_X * 2, CENTER_Y * 2);
    SDL_SetTextureBlendMode(screenTex, SDL_BLENDMODE_NONE);
  end;
end;

procedure ResizeWindow(w, h: integer);
var
  i: integer;
begin
  //这是SDL2可能的问题, 如使用directx需重建全部可被渲染的纹理
  //因此在这里,如果使用directx则不准许改变窗口尺寸
  RESOLUTIONX := w;
  RESOLUTIONY := h;

  //SDL_SetRenderDrawBlendMode(render, SDL_BLENDMODE_NONE);
  SDL_SetRenderTarget(render, nil);
  DestroyRenderTextures;
  SDL_SetRenderDrawColor(render, 0, 0, 0, 0);
  SDL_SetWindowSize(window, w, h);
  SDL_RenderClear(render);

  if (RENDERER = 0) and (SW_SURFACE = 0) then
  begin
    CreateMainRenderTextures;
    if (where = 1) or (where = 2) then
      ExpandGroundOnImg;
  end;

  CreateAssistantRenderTextures;
  SDL_SetRenderTarget(render, screenTex);

  if MenuEscType >= 0 then
    LoadTeamSimpleStatus(i);
  //Redraw;
  UpdateAllScreen;

end;

procedure ResizeSimpleText(initial: integer = 0);
var
  i, x, y, w1, h1: integer;
begin
  if TEXT_LAYER = 1 then
  begin
    x := 0;
    y := 0;
    w1 := 270;
    h1 := 90;
    GetRealRect(x, y, w1, h1);

    for i := 0 to 5 do
    begin
      if SW_SURFACE = 0 then
      begin
        if SimpleTextTex[i] <> nil then
          SDL_DestroyTexture(SimpleTextTex[i]);
        SimpleTextTex[i] := SDL_CreateTexture(render, SDL_PIXELFORMAT_ARGB8888, SDL_TEXTUREACCESS_TARGET,
          w1 + x, y + h1);
        //这里的混合方式需设为none, 才能正常合并到Text层不留白边, 必须人为保证不会盖住原本的文字
        SDL_SetTextureBlendMode(SimpleTextTex[i], SDL_BLENDMODE_NONE);
      end
      else
      begin
        if SimpleText[i] <> nil then
          SDL_FreeSurface(SimpleText[i]);
        SimpleText[i] := SDL_CreateRGBSurface(0, w1 + x, y + h1, 32, RMask, GMask, BMask, AMASK);
      end;
    end;
  end;
end;

procedure SwitchFullscreen;
begin
  FULLSCREEN := 1 - FULLSCREEN;
  if FULLSCREEN = 0 then
  begin
    //RealScreen := SDL_SetVideoMode(RESOLUTIONX, RESOLUTIONY, 32, ScreenFlag);
  end
  else
  begin
    //RealScreen := SDL_SetVideoMode(CENTER_X * 2, CENTER_Y * 2, 32, ScreenFlag or SDL_FULLSCREEN);
  end;

end;

procedure QuitConfirm;
var
  menuString: array[0..1] of WideString;
  Tex: PSDL_Texture;
begin
  //NeedRefreshScence := 0;
  if (EXIT_GAME = 0) or (AskingQuit) then
  begin
    //以下为 Windows 的 API, 可能会影响移植性
    {SDL_version(info.version);
    SDL_GetWMInfo(@info);
    if MessageBox(info.window, 'Are you sure to quit?', 'Confirmation', MB_ICONQUESTION or MB_YESNO) = idYes then
      Quit;}
    if MessageDlg('Are you sure to quit?', mtConfirmation, [mbOK, mbCancel], 0) = idOk then
      Quit;
  end
  else
  begin
    if AskingQuit then
      exit;
    AskingQuit := True;
    RecordFreshScreen;
    TransBlackScreen;
    UpdateAllScreen;
    menuString[0] := '取消';
    menuString[1] := '確認';
    if CommonMenu(CENTER_X * 2 - 50, 2, 47, 1, 0, menuString) = 1 then
      Quit;
    //Redraw;
    //SDL_BlitSurface(tempscr, nil, screen, nil);
    LoadFreshScreen;
    FreeFreshScreen;
    UpdateAllScreen;
    AskingQuit := False;
  end;
  //NeedRefreshScence := 1;
end;

function JoyAxisMouse(interval: uint32; param: pointer): uint32;
var
  x, y, x1, y1: integer;
begin
  SDL_GetMouseState(@x, @y);
  x1 := SDL_JoystickGetAxis(joy, 0);
  y1 := SDL_JoystickGetAxis(joy, 1);
  if abs(x1) + abs(y1) > 10000 then
  begin
    x := x + x1 div 1000;
    y := y + y1 div 1000;
    SDL_WarpMouseInWindow(window, x, y);
  end;
  Result := JOY_AXIS_DELAY;

end;

function CheckBasicEvent: uint32;
var
  i: integer;
begin
  //if not ((LoadingTiles) or (LoadingScence)) then
  SDL_FlushEvent(SDL_MOUSEWHEEL);
  SDL_FlushEvent(SDL_JOYAXISMOTION);
  //writeln(inttohex(event.type_, 4));
  //JoyAxisMouse;
  case event.type_ of
    SDL_JOYBUTTONUP:
    begin
      event.type_ := SDL_KEYUP;
      if event.jbutton.button = JOY_ESCAPE then
        event.key.keysym.sym := SDLK_ESCAPE
      else if event.jbutton.button = JOY_RETURN then
        event.key.keysym.sym := SDLK_RETURN
      else if event.jbutton.button = JOY_MOUSE_LEFT then
      begin
        event.button.button := SDL_BUTTON_LEFT;
        event.type_ := SDL_MOUSEBUTTONUP;
      end
      else if event.jbutton.button = JOY_UP then
        event.key.keysym.sym := SDLK_UP
      else if event.jbutton.button = JOY_DOWN then
        event.key.keysym.sym := SDLK_DOWN
      else if event.jbutton.button = JOY_LEFT then
        event.key.keysym.sym := SDLK_LEFT
      else if event.jbutton.button = JOY_RIGHT then
        event.key.keysym.sym := SDLK_RIGHT;
    end;
    SDL_JOYBUTTONDOWN:
    begin
      event.type_ := SDL_KEYDOWN;
      if event.jbutton.button = JOY_UP then
        event.key.keysym.sym := SDLK_UP
      else if event.jbutton.button = JOY_DOWN then
        event.key.keysym.sym := SDLK_DOWN
      else if event.jbutton.button = JOY_LEFT then
        event.key.keysym.sym := SDLK_LEFT
      else if event.jbutton.button = JOY_RIGHT then
        event.key.keysym.sym := SDLK_RIGHT;
    end;
    SDL_JOYHATMOTION:
    begin
      event.type_ := SDL_KEYDOWN;
      case event.jhat.value of
        SDL_HAT_UP: event.key.keysym.sym := SDLK_UP;
        SDL_HAT_DOWN: event.key.keysym.sym := SDLK_DOWN;
        SDL_HAT_LEFT: event.key.keysym.sym := SDLK_LEFT;
        SDL_HAT_RIGHT: event.key.keysym.sym := SDLK_RIGHT;
      end;
    end;
    SDL_MULTIGESTURE:
    begin
      event.type_ := SDL_KEYUP;
      event.key.keysym.sym := SDLK_ESCAPE;
    end;
    SDL_QUITEV:
      QuitConfirm;
    SDL_WindowEvent:
      if event.window.event = SDL_WINDOWEVENT_RESIZED then
      begin
        ResizeWindow(event.window.data1, event.window.data2);
      end;
    SDL_KEYUP, SDL_MOUSEBUTTONUP:
    begin
      if (where = 2) and ((event.key.keysym.sym = SDLK_ESCAPE) or (event.button.button = SDL_BUTTON_RIGHT)) then
      begin
        for i := 0 to BRoleAmount - 1 do
        begin
          if Brole[i].Team = 0 then
            Brole[i].Auto := 0;
        end;
      end;
      if event.key.keysym.sym = SDLK_KP_ENTER then
        event.key.keysym.sym := SDLK_RETURN;
    end;
  end;
  //CheckRenderTextures;
end;

procedure ChangeCol;
var
  i, a, b, add0, len: integer;
  temp: array[0..2] of byte;
  now, next_time: uint32;
  p, p0, p1, p2: real;
begin
  if PNG_TILE = 0 then
  begin
    now := SDL_GetTicks;
    if (NIGHT_EFFECT = 1) and (where = 0) then
    begin
      now_time := now_time + 0.3;
      if now_time > 1440 then
        now_time := 0;
      p := now_time / 1440;
      //writeln(p);
      if p > 0.5 then
        p := 1 - p;
      p0 := 0.6 + p;
      p1 := 0.6 + p;
      p2 := 1 - 0.4 / 1.3 + p / 1.3;
      for i := 0 to 255 do
      begin
        b := i * 3;
        Acol1[b] := min(trunc(Acol2[b] * p0), 63);
        Acol1[b + 1] := min(trunc(Acol2[b + 1] * p1), 63);
        Acol1[b + 2] := min(trunc(Acol2[b + 2] * p2), 63);
      end;
      move(ACol1[0], ACol[0], 768);
    end;

    add0 := $E0;
    len := 8;
    a := now div 200 mod len;
    move(ACol1[add0 * 3], ACol[add0 * 3 + a * 3], (len - a) * 3);
    move(ACol1[add0 * 3 + (len - a) * 3], ACol[add0 * 3], a * 3);

    add0 := $F4;
    len := 9;
    a := now div 200 mod len;
    move(ACol1[add0 * 3], ACol[add0 * 3 + a * 3], (len - a) * 3);
    move(ACol1[add0 * 3 + (len - a) * 3], ACol[add0 * 3], a * 3);
  end;
end;


//读取贴图

//在另一线程中操作可变量长度不正常, 改为首先初始化全部图片, 在线程中读取

procedure InitialPicArrays;
var
  i: integer;
  word: array[0..1] of uint16 = (0, 0);
begin
  if PNG_TILE > 0 then
  begin
    MPicAmount := LoadPNGTiles('resource/mmap', MPNGIndex, MPNGTex, MPNGTile, PNG_LOAD_ALL);
    SPicAmount := LoadPNGTiles('resource/smap', SPNGIndex, SPNGTex, SPNGTile, PNG_LOAD_ALL);
    HPicAmount := LoadPNGTiles('resource/head', HPNGIndex, HPNGTex, HPNGTile, PNG_LOAD_ALL);
    CPicAmount := LoadPNGTiles('resource/cloud', CPNGIndex, CPNGTex, CPNGTile, 1);
    IPicAmount := LoadPNGTiles('resource/item', IPNGIndex, IPNGTex, IPNGTile, PNG_LOAD_ALL);

    pMPic := nil;
    pSPic := nil;
    pHPic := nil;
    pIPic := nil;

    {for i := 0 to 999 do
      if FPicLoaded[i] = 0 then
      begin
        LoadPNGTiles(formatfloat('resource/fight/fight000', i), FPNGIndex[i], FPNGTex[i], 1);
        FPicLoaded[i] := 1;
      end;
    for i := 0 to 105 do
      if EPicLoaded[i] = 0 then
      begin
        EPicAmount[i] := LoadPNGTiles(formatfloat('resource/eft/eft000', i), EPNGIndex[i], EPNGTex[i], 1);
        EPicLoaded[i] := 1;
      end;
    for i := $1000 to $FFFF do
    begin
      word[0] := i;
      DrawText(@word[0], 0, 0, 0);
    end;}

    if (PNG_TILE = 2) and (PNG_LOAD_ALL = 0) then
    begin
      pMPic := ReadFileToBuffer(nil, AppPath + 'resource/mmap.imz', -1, 1);
      pSPic := ReadFileToBuffer(nil, AppPath + 'resource/smap.imz', -1, 1);
      pHPic := ReadFileToBuffer(nil, AppPath + 'resource/head.imz', -1, 1);
      pIPic := ReadFileToBuffer(nil, AppPath + 'resource/item.imz', -1, 1);
    end;
    ReadTiles;
  end;
end;

procedure ReadTiles;
var
  i: integer;
  LoadThread, LoadThreadS: PSDL_Thread;
  d: TLoadTileData;
begin
  if BIG_PNG_TILE > 0 then
  begin
    {MMapSurface :=  LoadSurfaceFromFile(AppPath + 'resource/bigpng/mmap.png');
    if MMapSurface <> nil then
      writeln('Main map loaded.');}
  end;

  //部分最常用的贴图
  if (PNG_TILE > 0) and (PNG_LOAD_ALL = 0) then
  begin
    for i := 2001 to MPicAmount - 1 do
    begin
      LoadOnePNGTexture('resource/mmap', pMPic, MPNGIndex[i]);
    end;
    for i := 2501 to 2528 do
    begin
      LoadOnePNGTexture('resource/smap', pSPic, SPNGIndex[i]);
    end;
  end;

  {for i := 0 to HPicAmount - 1 do
  begin
    {if fileexists(AppPath + 'resource/head/' + inttostr(i) + '.png') then
    begin
      LoadOnePNGTile('resource/head', nil, i, HPNGIndex[i], @HPNGTile[0]);
        writeln('Custom head pic ', inttostr(i), ' has been loaded.');
    end;
  end;}

  if THREAD_READ_PNG = 1 then
  begin
    d.amount := MPicAmount;
    d.filemem := pMpic;
    d.beginIndex := @MPNGIndex[0];
    d.path := 'resource/mmap';
    LoadThread := SDL_CreateThread(@LoadPNGTilesThread, nil, @d);
  end;

  ReadingTiles := False;

end;

function LoadPNGTilesThread(Data: pointer): longint; cdecl;
var
  i: integer;
  d: TLoadTileData;
  pPic: pchar;
  pIndex: ^TPNGIndex;
  path: string;
begin
  d := TLoadTileData(Data^);
  pPic := d.filemem;
  pIndex := d.beginIndex;
  path := d.path;
  for i := 0 to d.amount - 1 do
  begin
    LoadOnePNGTexture(path, pPic, pIndex^);
    Inc(pIndex);
  end;
end;

//读入文件到缓冲区
//当读入的位置并非变长数据时, 务必设置 malloc = 0!
//size小于0时, 则读整个文件.

function ReadFileToBuffer(p: pchar; filename: string; size, malloc: integer): pchar;
var
  i: integer;
begin
  i := FileOpen(filename, fmopenread);
  if i > 0 then
  begin
    if size < 0 then
      size := FileSeek(i, 0, 2);
    if malloc = 1 then
    begin
      //GetMem(result, size + 4);
      Result := StrAlloc(size + 4);
      p := Result;
      //writeln(StrBufSize(p));
    end;
    FileSeek(i, 0, 0);
    FileRead(i, p^, size);
    FileClose(i);
  end
  else
  if malloc = 1 then
    Result := nil;
end;

procedure FreeFileBuffer(var p: pchar);
begin
  if p <> nil then
    StrDispose(p);
  p := nil;
end;

//载入IDX和GRP文件到变长数据, 不适于非变长数据

function LoadIdxGrp(stridx, strgrp: string; var idxarray: TIntArray; var grparray: TByteArray): integer;
var
  idx, grp, len, tnum: integer;
begin
  tnum := 0;
  if FileExists(AppPath + strgrp) and FileExists(AppPath + stridx) then
  begin
    grp := FileOpen(AppPath + strgrp, fmopenread);
    len := FileSeek(grp, 0, 2);
    setlength(grparray, len + 4);
    FileSeek(grp, 0, 0);
    FileRead(grp, grparray[0], len);
    FileClose(grp);

    idx := FileOpen(AppPath + stridx, fmopenread);
    tnum := FileSeek(idx, 0, 2) div 4;
    setlength(idxarray, tnum + 1);
    FileSeek(idx, 0, 0);
    FileRead(idx, idxarray[0], tnum * 4);
    FileClose(idx);
  end;
  Result := tnum;

end;

//为了提高启动的速度, M之外的贴图均仅读入基本信息, 需要时才实际载入图, 并且游戏过程中通常不再释放资源

function LoadPNGTiles(path: string; var PNGIndexArray: TPNGIndexArray; var TextureArray: TTextureArray;
  var SurfaceArray: TSurfaceArray; LoadPic: integer = 1): integer; overload;
const
  maxCount: integer = 9999;
var
  i, j, k, state, size, Count, pngoff: integer;
  //zipFile: unzFile;
  //info: unz_file_info;
  offset: array of smallint;
  p: pchar;
  po: pointer;
begin
  //载入偏移值文件, 计算贴图的最大数量
  size := 0;
  Result := 0;
  p := nil;

  if PNG_TILE = 2 then
  begin
    writeln('Searching imz file... ', path);
    p := ReadFileToBuffer(nil, AppPath + path + '.imz', -1, 1);
    if p <> nil then
    begin
      Result := min(maxCount, pinteger(p)^);
      //最大的有帧数的数量作为贴图的最大编号
      for i := Result - 1 downto 0 do
      begin
        if pinteger(p + pinteger(p + 4 + i * 4)^ + 4)^ > 0 then
        begin
          Result := i + 1;
          break;
        end;
      end;

      //初始化贴图索引, 并计算全部帧数和
      setlength(PNGIndexArray, Result);
      Count := 0;
      for i := 0 to Result - 1 do
      begin
        pngoff := pinteger(p + 4 + i * 4)^;
        with PNGIndexArray[i] do
        begin
          FileNum := i;
          PointerNum := Count;
          x := psmallint(p + pngoff)^;
          y := psmallint(p + pngoff + 2)^;
          Frame := pinteger(p + pngoff + 4)^;
          Count := Count + frame;
          CurPointer := nil;
          Loaded := 0;
        end;
      end;
    end
    else
      writeln('Can''t find imz file.');
  end;


  if (PNG_TILE = 1) or (p = nil) then
  begin
    writeln('Searching index of png files... ', path + '/index.ka');
    path := path + '/';
    p := ReadFileToBuffer(nil, AppPath + path + '/index.ka', -1, 1);
    size := StrBufSize(p);
    setlength(offset, size div 2 + 2);
    move(p^, offset[0], size);
    FreeFileBuffer(p);

    for i := size div 4 downto 0 do
    begin
      if FileExists(AppPath + path + IntToStr(i) + '.png') or FileExists(AppPath + path +
        IntToStr(i) + '_0.png') then
      begin
        Result := i + 1;
        break;
      end;
    end;
    //贴图的数量是有文件存在的最大数量
    setlength(PNGIndexArray, Result);
    //计算合法贴图文件的总数, 同时指定每个图的索引数据
    Count := 0;
    for i := 0 to Result - 1 do
    begin
      with PNGIndexArray[i] do
      begin
        FileNum := i;
        PointerNum := -1;
        Frame := 0;
        CurPointer := nil;
        if FileExists(AppPath + path + IntToStr(i) + '.png') then
        begin
          PointerNum := Count;
          Frame := 1;
          Count := Count + 1;
        end
        else
        begin
          k := 0;
          while FileExists(AppPath + path + IntToStr(i) + '_' + IntToStr(k) + '.png') do
          begin
            k := k + 1;
            if k = 1 then
              PointerNum := Count;
            Count := Count + 1;
          end;
          Frame := k;
        end;
        x := offset[i * 2];
        y := offset[i * 2 + 1];
        Loaded := 0;
        UseGRP := 0;
      end;
    end;
  end;

  writeln(Result, ' index, ', Count, ' real tiles.');

  if SW_SURFACE = 0 then
  begin
    setlength(TextureArray, Count);
    po := @TextureArray[0];
    for i := 0 to Count - 1 do
      TextureArray[i] := nil;
  end
  else
  begin
    setlength(SurfaceArray, Count);
    po := @SurfaceArray[0];
    for i := 0 to Count - 1 do
      SurfaceArray[i] := nil;
  end;

  for i := 0 to Result - 1 do
    PNGIndexArray[i].BeginPointer := po;

  if LoadPic = 1 then
  begin
    writeln('Now loading...');
    for i := 0 to Result - 1 do
    begin
      LoadOnePNGTexture(path, p, PNGIndexArray[i], 1);
    end;
  end;
  FreeFileBuffer(p);

end;

//这个函数没有容错处理, 在独立文件和打包文件都不存在时会引起游戏崩溃, 需要特别注意!
//p如果为nil, 则试图读取文件

procedure LoadOnePNGTexture(path: string; p: pchar; var PNGIndex: TPNGIndex; forceLoad: integer = 0); overload;
var
  j, k, index, len, off, w1, h1: integer;
  tempsur: PPSDL_Surface;
  temptex: PPSDL_Texture;
  frommem: boolean;
  pb, pc: pointer;
begin
  SDL_PollEvent(@event);
  CheckBasicEvent;
  frommem := ((PNG_TILE = 2) and (p <> nil));
  if not frommem then
    path := path + '/';
  with PNGIndex do
  begin
    if ((Loaded = 0) or (forceLoad = 1)) and (PointerNum >= 0) and (Frame > 0) then
    begin
      Loaded := 1;
      w := 0;
      h := 0;
      CurPointerT := BeginPointer;
      CurPointer := BeginPointer;
      Inc(CurPointerT, PointerNum);
      Inc(CurPointer, PointerNum);
      temptex := CurPointerT;
      tempsur := CurPointer;
      if Frame = 1 then
      begin
        if frommem then
        begin
          off := pinteger(p + 4 + filenum * 4)^ + 8;
          index := pinteger(p + off)^;
          len := pinteger(p + off + 4)^;
          LoadTileFromMem(p + index, len, temptex, tempsur, SW_SURFACE, w, h);
        end
        else
        begin
          if LoadTileFromFile(AppPath + path + IntToStr(filenum) + '.png', temptex, tempsur,
            SW_SURFACE, w, h) = False then
            LoadTileFromFile(AppPath + path + IntToStr(filenum) + '_0.png', temptex, tempsur, SW_SURFACE, w, h);
        end;
      end;
      if Frame > 1 then
      begin
        for j := 0 to Frame - 1 do
        begin
          if frommem then
          begin
            off := pinteger(p + 4 + filenum * 4)^ + 8;
            index := pinteger(p + off + j * 8)^;
            len := pinteger(p + off + j * 8 + 4)^;
            LoadTileFromMem(p + index, len, temptex, tempsur, SW_SURFACE, w, h);
          end
          else
            LoadTileFromFile(AppPath + path + IntToStr(filenum) + '_' + IntToStr(j) +
              '.png', temptex, tempsur, SW_SURFACE, w1, h1);
          if (j = 0) then
          begin
            w := w1;
            h := h1;
          end;
          Inc(temptex, 1);
          Inc(tempsur, 1);
        end;
      end;
    end;
    Loaded := 1;
  end;

end;

//从文件载入表面

function LoadTileFromFile(filename: string; pt: PPSDL_Texture; ps: PPSDL_Surface; usesur: integer;
  var w, h: integer): boolean;
var
  tempscr: PSDL_Surface;
begin
  Result := False;
  pt^ := nil;
  ps^ := nil;
  if FileExists(filename) then
  begin
    Result := True;
    if usesur = 0 then
    begin
      pt^ := IMG_LoadTexture(render, pchar(filename));
      if pt^ <> nil then
      begin
        SDL_SetTextureBlendMode(pt^, SDL_BLENDMODE_BLEND);
        SDL_QueryTexture(pt^, nil, nil, @w, @h);
        Result := True;
      end;
    end
    else
    begin
      tempscr := IMG_Load(pchar(filename));
      ps^ := SDL_ConvertSurface(tempscr, screen.format, 0);
      SDL_FreeSurface(tempscr);
      //SDL_SetSurfaceBlendMode(ps^, SDL_BLENDMODE_BlEND);
      if ps^ <> nil then
      begin
        w := ps^.w;
        h := ps^.h;
        Result := True;
      end;
    end;
  end;
end;


//从内存载入表面

function LoadTileFromMem(p: pchar; len: integer; pt: PPSDL_Texture; ps: PPSDL_Surface;
  usesur: integer; var w, h: integer): boolean;
var
  tempscr: PSDL_Surface;
  tempRWops: PSDL_RWops;
begin
  Result := False;
  tempRWops := SDL_RWFromMem(p, len);
  pt^ := nil;
  ps^ := nil;
  if usesur = 0 then
  begin
    pt^ := IMG_LoadTextureTyped_RW(render, tempRWops, 0, 'png');
    if pt^ <> nil then
    begin
      SDL_SetTextureBlendMode(pt^, SDL_BLENDMODE_BLEND);
      SDL_QueryTexture(pt^, nil, nil, @w, @h);
      Result := True;
    end;
  end
  else
  begin
    tempscr := IMG_LoadTyped_RW(tempRWops, 0, 'png');
    ps^ := SDL_ConvertSurface(tempscr, screen.format, 0);
    SDL_FreeSurface(tempscr);
    if ps <> nil then
    begin
      w := ps^.w;
      h := ps^.h;
      Result := True;
    end;
  end;
  SDL_FreeRW(tempRWops);

end;

function LoadStringFromIMZMEM(path: string; p: pchar; num: integer): string;
var
  index, len, off: integer;
begin
  off := pinteger(p + 4 + num * 4)^ + 8;
  index := pinteger(p + off)^;
  len := pinteger(p + off + 4)^;
  setlength(Result, len);
  move((p + index)^, Result[1], len);
end;

function LoadStringFromZIP(zfilename, filename: string): string;
var
  zfile: unzfile;
  file_info: unz_file_info;
  len: integer;
begin
  Result := '';
  zfile := unzOpen(pchar(zfilename));
  if (zfile <> nil) then
  begin
    if (unzLocateFile(zfile, pchar(filename), 2) = UNZ_OK) then
    begin
      unzLocateFile(zfile, pchar(filename), 2);
      unzOpenCurrentFile(zfile);
      unzGetCurrentFileInfo(zfile, @file_info, nil, 0, nil, 0, nil, 0);
      len := file_info.uncompressed_size;
      setlength(Result, len);
      unzReadCurrentFile(zfile, pchar(Result), len);
      unzCloseCurrentFile(zfile);
    end;

    unzClose(zfile);
  end;
end;

procedure DestroyAllTextures(all: integer = 1);
var
  i: integer;

  procedure DestoryTextureArray(TextureArray: TTextureArray);
  var
    i: integer;
  begin
    for i := 0 to high(TextureArray) do
    begin
      SDL_DestroyTexture(TextureArray[i]);
      TextureArray[i] := nil;
    end;
  end;

  procedure ResetIndexArray(PNGIndexArray: TPNGIndexArray);
  var
    i: integer;
  begin
    for i := 0 to high(PNGIndexArray) do
    begin
      PNGIndexArray[i].Loaded := 0;
      PNGIndexArray[i].CurPointerT := nil;
    end;
  end;

begin

  ResetIndexArray(MPNGIndex);
  ResetIndexArray(SPNGIndex);
  ResetIndexArray(CPNGIndex);
  ResetIndexArray(IPNGIndex);
  ResetIndexArray(TitlePNGIndex);
  for i := 0 to high(FPNGIndex) do
    ResetIndexArray(FPNGIndex[i]);
  for i := 0 to high(EPNGIndex) do
    ResetIndexArray(EPNGIndex[i]);
  fillchar(EPicLoaded, sizeof(EPicLoaded), 0);
  fillchar(FPicLoaded, sizeof(FPicLoaded), 0);

  DestoryTextureArray(MPNGTex);
  DestoryTextureArray(SPNGTex);
  DestoryTextureArray(CPNGTex);
  DestoryTextureArray(IPNGTex);
  DestoryTextureArray(TitlePNGTex);
  for i := 0 to high(FPNGTex) do
    DestoryTextureArray(FPNGTex[i]);
  for i := 0 to high(EPNGTex) do
    DestoryTextureArray(EPNGTex[i]);

  if all = 1 then
  begin
    DestroyRenderTextures;
    SDL_DestroyTexture(screenTex);
    SDL_DestroyTexture(ImgSGroundTex);
    SDL_DestroyTexture(ImgBGroundTex);
    FreeFileBuffer(pMPic);
    FreeFileBuffer(pSPic);
    //FreeFileBuffer(pBPic);
    //FreeFileBuffer(pEPic);
    FreeFileBuffer(pHPic);
    FreeFileBuffer(pIPic);
  end;

end;

procedure DestroyFontTextures();
var
  i: integer;
begin
  for i := 0 to high(CharTex) do
  begin
    if CharTex[i] <> nil then
    begin
      SDL_DestroyTexture(CharTex[i]);
      CharTex[i] := nil;
    end;
  end;
end;

procedure DrawPNGTile(render: PSDL_Renderer; PNGIndex: TPNGIndex; FrameNum: integer; px, py: integer); overload;
var
  rect: TSDL_Rect;
begin
  if SW_SURFACE <> 0 then
  begin
    DrawPNGTileS(CurTargetSurface, PNGIndex, FrameNum, px, py, nil, 0, 0, 0, 0, 1, 1, 0);
    exit;
  end;
  with PNGIndex do
  begin
    if (CurPointerT <> nil) and (CurPointerT^ <> nil) then
    begin
      rect.x := px - x;
      rect.y := py - y;
      rect.w := w;
      rect.h := h;
      if (Frame > 1) then
        Inc(CurPointerT, FrameNum mod PNGIndex.Frame);
      SDL_SetTextureAlphaMod(CurPointerT^, 255);
      SDL_SetTextureColorMod(CurPointerT^, 255, 255, 255);
      SDL_RenderCopy(render, CurPointerT^, nil, @rect);
    end;
  end;
end;


procedure DrawPNGTile(render: PSDL_Renderer; PNGIndex: TPNGIndex; FrameNum: integer;
  px, py: integer; region: psdl_rect; shadow, alpha: integer; mixColor: uint32; mixAlpha: integer;
  scalex, scaley, angle: real; center: PSDL_Point); overload;
var
  rect: TSDL_Rect;
  r, g, b, a, r1, g1, b1: byte;
  newtex: boolean;
  tex, tex1, ptex: PSDL_Texture;
begin
  if SW_SURFACE <> 0 then
  begin
    DrawPNGTileS(CurTargetSurface, PNGIndex, FrameNum, px, py, region, shadow, alpha, mixColor,
      mixAlpha, scalex, scaley, angle);
    exit;
  end;
  //shadow设置混合方式, 以及预设值等
  with PNGIndex do
  begin
    if (CurPointerT = nil) or (CurPointerT^ = nil) then
      exit;
    if Frame > 1 then
      Inc(CurPointerT, FrameNum mod Frame);
    tex := CurPointerT^;
    rect.x := px - x;
    rect.y := py - y;
    if region = nil then
    begin
      rect.w := w;
      rect.h := h;
    end
    else
    begin
      rect.w := region.w;
      rect.h := region.h;
    end;
    if (scalex <> 1) or (scaley <> 1) then
    begin
      rect.w := round(rect.w * scalex);
      rect.h := round(rect.h * scaley);
    end
    else
    begin

    end;
  end;

  newtex := False;
  if (shadow < 0) and (mixAlpha = 0) then
  begin
    mixColor := 0;
    mixAlpha := -25 * shadow;
  end;
  if (shadow > 0) and (mixAlpha = 0) then
  begin
    mixColor := $FFFFFFFF;
    mixAlpha := shadow * 10;
  end;

  //注意混合色的问题, 该算法很奇怪, 若强制指定混合色用mixAlpha < 0
  if (mixAlpha > 0) and (shadow <= 0) then
  begin
    GetRGBA(mixColor, @r, @g, @b);
    r1 := max(0, 255 - (255 + g + b) * mixAlpha div 100);
    g1 := max(0, 255 - (255 + r + b) * mixAlpha div 100);
    b1 := max(0, 255 - (255 + r + g) * mixAlpha div 100);
    SDL_SetTextureColorMod(tex, r1, g1, b1);
  end
  else
  begin
    SDL_SetTextureColorMod(tex, 255, 255, 255);
  end;
  if mixAlpha < 0 then
  begin
    GetRGBA(mixColor, @r, @g, @b);
    SDL_SetTextureColorMod(tex, r, g, b);
  end;
  if (mixAlpha > 0) and (shadow > 0) then
  begin
    GetRGBA(mixColor, @r, @g, @b);
    ptex := SDL_GetRenderTarget(render);
    tex1 := tex;
    tex := SDL_CreateTexture(render, SDL_PIXELFORMAT_ARGB8888, SDL_TEXTUREACCESS_TARGET, PNGIndex.w, PNGIndex.h);
    newtex := True;
    SDL_SetRenderTarget(render, tex);
    SDL_SetTextureBlendMode(tex1, SDL_BLENDMODE_NONE);
    SDL_RenderCopy(render, tex1, nil, nil);
    SDL_SetTextureBlendMode(tex1, SDL_BLENDMODE_BLEND);
    SDL_SetRenderDrawBlendMode(render, SDL_BLENDMODE_add);
    SDL_SetRenderDrawColor(render, r, g, b, 255 * mixAlpha div 100);
    SDL_SetTextureBlendMode(tex, SDL_BLENDMODE_BLEND);
    SDL_RenderFillRect(render, nil);
    SDL_SetRenderTarget(render, ptex);
  end;

  if alpha > 0 then
  begin
    SDL_SetTextureAlphaMod(tex, 255 * (100 - alpha) div 100);
  end
  else
  begin
    SDL_SetTextureAlphaMod(tex, 255);
  end;
  SDL_RenderCopyEx(render, tex, region, @rect, angle, center, SDL_FLIP_NONE);
  //SDL_RenderCopy(render, tex, nil, nil);
  if newtex then
    SDL_DestroyTexture(tex);

end;

procedure DrawPNGTileS(scr: PSDL_Surface; PNGIndex: TPNGIndex; FrameNum: integer; px, py: integer;
  region: psdl_rect; shadow, alpha: integer; mixColor: uint32; mixAlpha: integer;
  scalex, scaley, angle: real); overload;
var
  rect: TSDL_Rect;
  r, g, b, a, r1, g1, b1: byte;
  newsur: boolean;
  sur, sur1, sur2: PSDL_Surface;
begin
  //shadow设置混合方式, 以及预设值等
  try
    with PNGIndex do
    begin
      if (CurPointer = nil) or (CurPointer^ = nil) then
        exit;
      if Frame > 1 then
        Inc(CurPointer, FrameNum mod Frame);
      sur := CurPointer^;
      rect.x := px - x;
      rect.y := py - y;
      if region = nil then
      begin
        rect.w := w;
        rect.h := h;
      end
      else
      begin
        rect.w := region.w;
        rect.h := region.h;
      end;
      if (scalex <> 1) or (scaley <> 1) then
      begin
        rect.w := round(rect.w * scalex);
        rect.h := round(rect.h * scaley);
      end
      else
      begin

      end;
    end;

    newsur := False;
    if (shadow < 0) and (mixAlpha = 0) then
    begin
      mixColor := 0;
      mixAlpha := -25 * shadow;
    end;
    if (shadow > 0) and (mixAlpha = 0) then
    begin
      mixColor := $FFFFFFFF;
      mixAlpha := shadow * 25;
    end;

    //注意混合色的问题, 该算法很奇怪, 若强制指定混合色用mixAlpha < 0
    if (mixAlpha > 0) and (shadow <= 0) then
    begin
      GetRGBA(mixColor, @r, @g, @b);
      r1 := max(0, 255 - (255 + g + b) * mixAlpha div 100);
      g1 := max(0, 255 - (255 + r + b) * mixAlpha div 100);
      b1 := max(0, 255 - (255 + r + g) * mixAlpha div 100);
      SDL_SetSurfaceColorMod(sur, r1, g1, b1);
    end
    else
    begin
      SDL_SetSurfaceColorMod(sur, 255, 255, 255);
    end;
    if mixAlpha < 0 then
    begin
      SDL_GetRGB(mixColor, scr.format, @r, @g, @b);
      SDL_SetSurfaceColorMod(sur, r, g, b);
    end;
    if (mixAlpha > 0) and (shadow > 0) then
    begin
      GetRGBA(mixColor, @r, @g, @b);
      sur1 := sur;
      sur := SDL_ConvertSurface(sur1, screen.format, 0);
      sur2 := SDL_ConvertSurface(sur1, screen.format, 0);
      newsur := True;
      SDL_SetSurfaceColorMod(sur2, r, g, b);
      SDL_SetSurfaceAlphaMod(sur2, 255 * mixAlpha div 100);
      SDL_SetSurfaceBlendMode(sur2, SDL_BLENDMODE_ADD);
      SDL_UpperBlit(sur2, nil, sur, nil);
      SDL_FreeSurface(sur2);
    end;
    if alpha > 0 then
    begin
      SDL_SetSurfaceAlphaMod(sur, 255 * (100 - alpha) div 100);
    end
    else
    begin
      SDL_SetSurfaceAlphaMod(sur, 255);
    end;

    if (rect.w = PNGIndex.w) and (rect.h = PNGIndex.h) then
      SDL_UpperBlit(sur, region, scr, @rect)
    else
      SDL_UpperBlitScaled(sur, region, scr, @rect);
    if newsur then
      SDL_FreeSurface(sur);
  except
    writeln('Bad PNGINDEX, filenum, width and height are ', PNGIndex.FileNum, ', ', PNGIndex.w, ', ', PNGIndex.h);
  end;
end;


//复制Index的表面, 如为空返回一很小的表面, 避免Blit出错

function CopyIndexSurface(PNGIndexArray: TPNGIndexArray; i: integer): PSDL_Surface;
var
  PNGIndex: TPNGIndex;
begin
  {Result := nil;
  if (i >= 0) and (i <= high(PNGIndexArray)) then
  begin
    PNGIndex := PNGIndexArray[i];
    //if (PNGIndex.Loaded = 1) and (PNGIndex.Frame > 0) then
    //Result := SDL_DisplayFormatAlpha(PNGIndex.CurPointer^);
  end;
  if Result = nil then
    Result := SDL_CreateRGBSurface(ScreenFlag, 1, 1, 32, RMask, GMask, BMask, 0);}
end;


procedure PlayMovie(const filename: string; fullwindow: integer);
{$IFDEF MSWINDOWS}
var
  pFormatCtx: pAVFormatContext;
  pCodecCtx: pAVCodecContext;
  pCodec: pAVCodec;
  pFrame: pAVFrame;
  pFrameRGB: pAVFrame;
  packet: TAVPacket;
  i, videoStream, frameFinished, size, maxdelay, delay, totalsize: integer;
  buffer: pbyte;
  framenum, frametime, frame_timer_begin, timer, timerV, timerA, ptimerA, scale: real;
  //bmp: pSDL_Overlay;
  pict: TAVPicture;
  img_convert_ctx: pSwsContext;
  rect: TSDL_Rect;
  pp: pointer;
  p2: puint16;
  p: ppbyte;
  time1, time2, xcoord, ycoord: real;
  textureid: gluint;
  f: integer;
  LoadAudio: PSDL_Thread;
  s: TStretchInfo;
  {Channel: HSTREAM;
  pos: real;
  rect1: TRect;
  info: xVideo_ChannelInfo;}

  pFormatCtxA: pAVFormatContext;
  pCodecCtxA: pAVCodecContext;
  pCodecA: pAVCodec;
  packetA: TAVPacket;
  bufferA: pbyte;
  audioStream, sizeA: integer;

  bmp: PSDL_Texture;

  //info: SDL_SysWMinfo;

  function LoadAudioThread(Data: pointer): longint; cdecl;
  var
    pFormatCtxA: pAVFormatContext;
    pCodecCtxA: pAVCodecContext;
    pCodecA: pAVCodec;
    packetA: TAVPacket;
    bufferA: pbyte;
    audioStream, sizeA: integer;
    i: integer;
  begin
    Result := 0;
    //另开一个寻找音频
    av_open_input_file(pFormatCtxA, pchar(movieName), nil, 0, nil);
    //pFormatCtxA := pFormatCtx;
    av_find_stream_info(pFormatCtxA);
    audioStream := -1;
    for i := 0 to pFormatCtxA.nb_streams - 1 do
    begin
      if pFormatCtxA.streams[i].codec.codec_type = AVMEDIA_TYPE_AUDIO then
      begin
        audioStream := i;
        break;
      end;
    end;
    pCodecCtxA := pFormatCtxA.streams[audioStream].codec;
    pCodecA := avcodec_find_decoder(pCodecCtxA.codec_id);
    avcodec_open(pCodecCtxA, pCodecA);
    //push模式的全局bass音频流
    openAudio := BASS_StreamCreate(pCodecCtxA.sample_rate, pCodecCtxA.channels, 0, STREAMPROC_PUSH, nil);
    BASS_ChannelSetAttribute(openAudio, BASS_ATTRIB_VOL, VOLUME / 100.0);
    BASS_ChannelPlay(openAudio, False);
    //在副线程中生成完整音频
    bufferA := av_mallocz(AVCODEC_MAX_AUDIO_FRAME_SIZE);
    while True do
    begin
      if av_read_frame(pFormatCtxA, packetA) < 0 then
        break;
      if (packetA.stream_index = audioStream) then
      begin
        sizeA := AVCODEC_MAX_AUDIO_FRAME_SIZE;
        avcodec_decode_audio2(pCodecCtxA, pSmallint(bufferA), sizeA, packetA.Data, packetA.size);
        if openAudio <> 0 then
          BASS_StreamPutData(openAudio, bufferA, sizeA);
      end;
      av_free_packet(@packetA);
    end;
    av_free(bufferA);
    avcodec_close(pCodecCtxA);
    av_close_input_file(pFormatCtxA);

  end;

{$ENDIF}
begin
{$IFDEF MSWINDOWS}
  {xVideo_Init(0, 0);
  Channel := xVideo_StreamCreateFile(PChar(filename), 0, 0, 0);
  if Channel <> 0 then
  begin
    xVideo_ChannelSetAttribute(Channel, xVideo_ATTRIB_VOL, VOLUME);
    xVideo_ChannelGetInfo(Channel, @Info);
    if fullwindow = 0 then
      xVideo_ChannelResizeWindow(Channel, 0, (RealScreen.w - Info.Width) div 2,
        (RealScreen.h - Info.Height) div 2, Info.Width, Info.Height);
    pos := xVideo_ChannelGetLength(Channel, xVideo_POS_MILISEC);
    xVideo_ChannelPlay(Channel);
    while SDL_PollEvent(@event) >= 0 do
    begin
      CheckBasicEvent;
      if (event.type_ = SDL_QUITEV) and (EXIT_GAME = 1) then
        break;
      if ((event.key.keysym.sym = SDLK_ESCAPE) or (event.button.button = SDL_BUTTON_RIGHT)) then
        break;
      if xVideo_ChannelGetPosition(Channel, xVideo_POS_MILISEC) >= pos then
        break;
      SDL_Delay(40);
    end;
    xVideo_StreamFree(Channel);
  end;
  xVideo_Free();}
  //openAudio := BASS_StreamCreateFile(False, PChar(filename), 0, 0, 0);

  //sdl_setrendertarget(render,nil);


  where := 5;
  av_register_all();
  if av_open_input_file(pFormatCtx, pchar(filename), nil, 0, nil) = 0 then
  begin
    av_find_stream_info(pFormatCtx);
    movieName := filename;

    if THREAD_READ_PNG = 0 then
      LoadAudioThread(nil)
    else
      try
        LoadAudio := SDL_CreateThread(@LoadAudioThread, nil, nil);
      except
      end;

    //寻找视频
    videoStream := -1;
    for i := 0 to pFormatCtx.nb_streams - 1 do
    begin
      if pFormatCtx.streams[i].codec.codec_type = AVMEDIA_TYPE_VIDEO then
      begin
        videoStream := i;
        break;
      end;
    end;
    pCodecCtx := pFormatCtx.streams[videoStream].codec;
    frametime := 1e3 * pFormatCtx.streams[videoStream].r_frame_rate.den /
      pFormatCtx.streams[videoStream].r_frame_rate.num;  //每帧的时间(毫秒)
    //writeln(1 / frametime);
    maxdelay := round(frametime);
    pCodec := avcodec_find_decoder(pCodecCtx.codec_id);
    avcodec_open(pCodecCtx, pCodec);
    pFrame := avcodec_alloc_frame();
    pFrameRGB := avcodec_alloc_frame();
    size := avpicture_get_size(PIX_FMT_YUV420P, pCodecCtx.Width, pCodecCtx.Height);
    buffer := av_malloc(size);
    avpicture_fill(pAVPicture(pFrameRGB), buffer, PIX_FMT_YUV420P, pCodecCtx.Width, pCodecCtx.Height);
    bmp := SDL_CreateTexture(render, SDL_PIXELFORMAT_YV12, SDL_TEXTUREACCESS_STREAMING,
      pCodecCtx.Width, pCodecCtx.Height);

    frame_timer_begin := av_gettime() / 1e3;

    timerA := 0;
    while SDL_PollEvent(@event) >= 0 do
    begin
      time1 := av_gettime() / 1e3;
      ptimerA := timerA;
      if ((event.key.keysym.sym = SDLK_ESCAPE) or (event.button.button = SDL_BUTTON_RIGHT)) then
        break;
      CheckBasicEvent;
      if av_read_frame(pFormatCtx, packet) < 0 then
        break;
      if (packet.stream_index = videoStream) then
      begin
        avcodec_decode_video2(pCodecCtx, pFrame, frameFinished, @packet);
        if (frameFinished <> 0) then
        begin
          //img_convert_ctx :=
          //sws_getContext(pCodecCtx.Width, pCodecCtx.Height, pCodecCtx.pix_fmt, pCodecCtx.Width,
          //pCodecCtx.Height, PIX_FMT_YUV420P, SWS_BICUBIC, nil, nil, nil);
          //sws_scale(img_convert_ctx, @pFrame.Data[0], @pFrame.linesize[0], 0, pCodecCtx.Height,
          //@pFrameRGB.Data[0], @pFrameRGB.linesize[0]);
          //sws_freeContext(img_convert_ctx);
          SDL_UpdateYUVTexture(bmp, nil, pFrame.Data[0], pFrame.linesize[0],
            pFrame.Data[1], pFrame.linesize[1], pFrame.Data[2], pFrame.linesize[2]);
          //计算窗口的位置

          if SW_SURFACE = 0 then
          begin
            s := KeepRatioScale(pCodecCtx.Width, pCodecCtx.Height, CENTER_X * 2, CENTER_Y * 2);
            rect.x := s.px;
            rect.y := s.py;
            rect.w := pCodecCtx.Width * s.num div s.den;
            rect.h := pCodecCtx.Height * s.num div s.den;
            SDL_RenderCopy(render, bmp, nil, @rect);
            UpdateAllScreen;
          end
          else
          begin
            s := KeepRatioScale(pCodecCtx.Width, pCodecCtx.Height, RESOLUTIONX, RESOLUTIONY);
            rect.x := s.px;
            rect.y := s.py;
            rect.w := pCodecCtx.Width * s.num div s.den;
            rect.h := pCodecCtx.Height * s.num div s.den;
            SDL_RenderCopy(render, bmp, nil, @rect);
            SDL_RenderPresent(render);
          end;
          //av_free_packet(@packet);
          timerA := BASS_ChannelBytes2Seconds(openAudio, BASS_ChannelGetPosition(openAudio, BASS_POS_BYTE)) * 1e3;
          //音频的时间为标准
          //timerA := 0;  //测试用
          timerV := (pCodecCtx.frame_number - 1) * frametime;  //该帧的实际时间
          //writeln(timerA, ',' ,timerV);
          delay := round(timerV - timerA);   //让视频追赶音频
          //writeln(delay);
          if (delay > maxdelay) and (timerA <= ptimerA) then
          begin
            //如果以音频为标准的值明显不合理, 则可能是音频解码出现问题, 依据播放时间重新计算延迟
            //但是如果音频时间在变大, 说明音频解码正常, 可能是音频偏慢, 此时应保持延迟
            time2 := av_gettime() / 1e3;
            delay := maxdelay - round(time2 - time1);
            delay := min(maxdelay, delay);
          end;
          if delay > 0 then
            SDL_Delay(delay);
      {end
      else if (packet.stream_index = audioStream) then
      begin
        //BASS_ChannelPause(openAudio);
        sizeA := AVCODEC_MAX_AUDIO_FRAME_SIZE;
        avcodec_decode_audio2(pCodecCtxA, pSmallint(bufferA), sizeA, packet.Data, packet.size);
        BASS_StreamPutData(openAudio, bufferA, sizeA);
        BASS_ChannelPlay(openAudio, False);}
        end;
      end;
    end;
    av_free_packet(@packet);

    //if RENDERER = 0 then
    SDL_DestroyTexture(bmp);

    av_free(pFrame);
    av_free(pFrameRGB);
    av_free(buffer);
    avcodec_close(pCodecCtx);
    //avcodec_close(pCodecCtxA);
    av_close_input_file(pFormatCtx);
    //av_close_input_file(pFormatCtxA);
    if openAudio <> 0 then
    begin
      BASS_ChannelStop(openAudio);
      BASS_StreamFree(openAudio);
    end;
  end;

{$ENDIF}
end;

procedure Big5ToGBK(p: pchar);
var
  str: ansistring;
  l, i: integer;
begin
  l := length(p);
  str := UTF8ToCP936(CP950ToUTF8(p));
  for i := 0 to l - 1 do
  begin
    p^ := str[i + 1];
    Inc(p);
  end;
end;

procedure Big5ToU16(p: pchar);
var
  str: WideString;
  l, i: integer;
  p1: pchar;
begin
  l := length(p);
  str := UTF8Decode(CP950ToUTF8(p));
  p1 := @str[1];
  for i := 0 to length(str) * 2 - 1 do
  begin
    p^ := p1^;
    Inc(p);
    Inc(p1);
  end;
end;

function DrawLength(str: WideString): integer; overload;
var
  l, i: integer;
begin
  l := length(str);
  Result := l;
  for i := 1 to l do
  begin
    if uint16(str[i]) >= $1000 then
      Result := Result + 1;
  end;
end;

function DrawLength(p: pWideChar): integer; overload;
var
  l, i: integer;
begin
  l := length(p);
  Result := l;
  for i := 0 to l - 1 do
  begin
    if puint16(p)^ >= $1000 then
      Result := Result + 1;
    Inc(p);
  end;
end;

function DrawLength(p: pchar): integer; overload;
begin
  DrawLength(pWideChar(p));
end;

//顺序ARGB

function MapRGBA(r, g, b: byte; a: byte = 255): uint32;
begin
  Result := (r shl 16) or (g shl 8) or b or (a shl 24);
end;

procedure GetRGBA(color: uint32; r, g, b: pbyte; a: pbyte = nil);
begin
  if r <> nil then
    r^ := (color shr 16) and $FF;
  if g <> nil then
    g^ := (color shr 8) and $FF;
  if b <> nil then
    b^ := (color shr 0) and $FF;
  if a <> nil then
    a^ := (color shr 24) and $FF;
end;

//force: 1-不按照比例计算, 2-恢复为20, 18, -1-初始化
procedure SetFontSize(Chnsize, engsize: integer; force: integer = 0);
var
  scale: real;
  Text: PSDL_Surface;
  word: array[0..1] of uint16 = (32, 0);
  tempcolor: TSDL_Color;
begin
  if (TEXT_LAYER = 0) or (force = 1) then
    scale := 1
  else
    scale := min(RESOLUTIONX / CENTER_X / 2, RESOLUTIONY / CENTER_Y / 2);

  //非初始化时先关闭字体
  if force <> -1 then
  begin
    TTF_CloseFont(font);
    TTF_CloseFont(engfont);
  end;

  if (force = -1) then
  begin
    CHINESE_FONT_SIZE := round(20 * scale);
    ENGLISH_FONT_SIZE := round(18 * scale);
    chnsize := CHINESE_FONT_SIZE;
    engsize := ENGLISH_FONT_SIZE;
  end
  else if (force = 2) then
  begin
    chnsize := CHINESE_FONT_SIZE;
    engsize := ENGLISH_FONT_SIZE;
  end
  else
  begin

    chnsize := round(chnsize * scale);
    engsize := round(engsize * scale);
  end;

  font := TTF_OpenFont(pchar(AppPath + CHINESE_FONT), chnsize);
  engfont := TTF_OpenFont(pchar(AppPath + ENGLISH_FONT), engsize);
  CHINESE_FONT_REALSIZE := chnsize;
  ENGLISH_FONT_REALSIZE := engsize;

  //测试中文字体的空格宽度
  Text := TTF_RenderUNICODE_solid(font, @word[0], tempcolor);
  //writeln(text.w);
  CHNFONT_SPACEWIDTH := Text.w;
  SDL_FreeSurface(Text);
  //writeln(chnsize, engsize);
end;

procedure ResetFontSize;
begin
  SetFontSize(0, 0, 2);
end;


//以下2个用于将队伍的简单状态小图转为表面组
procedure LoadTeamSimpleStatus(var max: integer);
var
  i: integer;
begin
  for i := 0 to 5 do
  begin
    if TeamList[i] >= 0 then
    begin
      if SW_SURFACE = 0 then
      begin
        if TEXT_LAYER <> 0 then
        begin
          SDL_SetRenderTarget(render, SimpleTextTex[i]);
          SDL_SetRenderDrawBlendMode(render, SDL_BLENDMODE_NONE);
          SDL_SetRenderDrawColor(render, 255, 255, 255, 0);
          SDL_RenderFillRect(render, nil);
        end;
        SDL_SetRenderTarget(render, SimpleStatusTex[i]);
        SDL_SetRenderDrawBlendMode(render, SDL_BLENDMODE_NONE);
        SDL_SetRenderDrawColor(render, 0, 0, 0, 0);
        SDL_RenderClear(render);
        ShowSimpleStatus(TeamList[i], 0, 0, i);
        SDL_SetTextureBlendMode(SimpleStatusTex[i], SDL_BLENDMODE_BLEND);
      end
      else
      begin
        if TEXT_LAYER <> 0 then
        begin
          SDL_FillRect(SimpleText[i], nil, MapRGBA(255, 255, 255, 0));
          SDL_SetSurfaceBlendMode(SimpleText[i], SDL_BLENDMODE_NONE);
        end;
        CurTargetSurface := SimpleStatus[i];
        SDL_FillRect(CurTargetSurface, nil, 0);
        ShowSimpleStatus(TeamList[i], 0, 0, i);
        SDL_SetSurfaceBlendMode(SimpleStatus[i], SDL_BLENDMODE_BLEND);
      end;
      max := i;
    end;
  end;
  if SW_SURFACE = 0 then
    SDL_SetRenderTarget(render, screenTex)
  else
    CurTargetSurface := screen;
end;

procedure DrawSimpleStatusByTeam(i, px, py: integer; mixColor: uint32; mixAlpha: integer);
var
  tempsur: PSDL_Surface;
  dest, dest2, rectcut: TSDL_Rect;
  x, y, w, h: integer;
  r, g, b, r1, g1, b1: byte;
begin
  x := 0;
  y := 0;
  w := 270;
  h := 90;
  dest.x := px;
  dest.y := py;
  dest.w := w;
  dest.h := h;
  rectcut := GetRealRect(x, y, w, h);
  dest2 := GetRealRect(dest);
  //dest2.x := dest2.x - x;
  //dest2.y := dest2.y - y;
  GetRGBA(mixColor, @r, @g, @b);
  r1 := max(0, 255 - (255 + g + b) * mixAlpha div 100);
  g1 := max(0, 255 - (255 + r + b) * mixAlpha div 100);
  b1 := max(0, 255 - (255 + r + g) * mixAlpha div 100);
  if SW_SURFACE = 0 then
  begin
    if (mixAlpha > 0) then
    begin
      SDL_SetTextureColorMod(SimpleStatusTex[i], r1, g1, b1);
    end
    else
    begin
      SDL_SetTextureColorMod(SimpleStatusTex[i], 255, 255, 255);
    end;
    SDL_RenderCopy(render, SimpleStatusTex[i], nil, @dest);

    if (TEXT_LAYER = 1) then
    begin
      if (mixAlpha > 0) then
        SDL_SetTextureColorMod(SimpleTextTex[i], r1, g1, b1)
      else
        SDL_SetTextureColorMod(SimpleTextTex[i], 255, 255, 255);
      SDL_SetRenderTarget(render, TextScreenTex);
      SDL_RenderCopy(render, SimpleTextTex[i], @rectcut, @dest2);
      SDL_SetRenderTarget(render, screenTex);
    end;
  end
  else
  begin
    if (mixAlpha > 0) then
    begin
      SDL_SetSurfaceColorMod(SimpleStatus[i], r1, g1, b1);
    end
    else
    begin
      SDL_SetSurfaceColorMod(SimpleStatus[i], 255, 255, 255);
    end;
    SDL_UpperBlit(SimpleStatus[i], nil, screen, @dest);

    if (TEXT_LAYER = 1) then
    begin
      if (mixAlpha > 0) then
      begin
        SDL_SetSurfaceColorMod(SimpleText[i], r1, g1, b1);
      end
      else
        SDL_SetSurfaceColorMod(SimpleText[i], 255, 255, 255);
      SDL_UpperBlit(SimpleText[i], @rectcut, TextScreen, @dest2);
    end;
  end;
end;

procedure FreeTeamSimpleStatus(var SimpleStatus: array of PSDL_Surface);
var
  i: integer;
begin
  {for i := 0 to 5 do
  begin
    if TeamList[i] >= 0 then
    begin
      sdl_freesurface(simplestatus[i]);
    end;
  end;}
end;

//屏幕整体变半透明黑
procedure TransBlackScreen;
begin
  DrawRectangleWithoutFrame(0, 0, CENTER_X * 2, CENTER_Y * 2, 0, 50);
  if TEXT_LAYER = 1 then
  begin
    if SW_SURFACE = 0 then
    begin
      SDL_SetRenderTarget(render, TextScreenTex);
      SDL_SetRenderDrawBlendMode(render, SDL_BLENDMODE_MOD);
      SDL_SetRenderDrawColor(render, 128, 128, 128, 0);
      SDL_RenderClear(render);
      SDL_SetRenderTarget(render, screenTex);
    end
    else
    begin
      CurTargetSurface := TextScreen;
      DrawRectangleWithoutFrame(0, 0, RESOLUTIONX, RESOLUTIONY, MapRGBA(128, 128, 128, 0), 50);
      CurTargetSurface := screen;
    end;
  end;
end;

//以下一组函数记录及载入屏幕的一部分, 用于快速重绘
procedure RecordFreshScreen; overload;
begin
  RecordFreshScreen(0, 0, CENTER_X * 2, CENTER_Y * 2);
end;

procedure RecordFreshScreen(x, y, w, h: integer); overload;
var
  i: integer;
  dest: TSDL_Rect;
begin
  dest.x := x;
  dest.y := y;
  dest.w := w;
  dest.h := h;
  if SW_SURFACE = 0 then
  begin
    i := length(FreshScreenTex);
    setlength(FreshScreenTex, i + 1);
    FreshScreenTex[i] := SDL_CreateTexture(render, SDL_PIXELFORMAT_ARGB8888, SDL_TEXTUREACCESS_TARGET, w, h);
    SDL_SetRenderTarget(render, FreshScreenTex[i]);
    SDL_RenderCopy(render, screenTex, @dest, nil);
    SDL_SetRenderTarget(render, screenTex);
  end
  else
  begin
    i := length(FreshScreen);
    setlength(FreshScreen, i + 1);
    FreshScreen[i] := SDL_CreateRGBSurface(0, w, h, 32, RMASK, GMASK, BMASK, AMASK);
    SDL_UpperBlit(screen, @dest, FreshScreen[i], nil);
  end;
  //CleanTextScreenRect(x, y, w, h);
  writeln('Now the amount of fresh screens is ', i + 1, '.');

end;

procedure LoadFreshScreen; overload;
begin
  LoadFreshScreen(0, 0);
end;

procedure LoadFreshScreen(x, y: integer); overload;
var
  i: integer;
  dest: TSDL_Rect;
begin
  i := max(high(FreshScreenTex), high(FreshScreen));
  if i >= 0 then
  begin
    if SW_SURFACE = 0 then
    begin
      if FreshScreenTex[i] <> nil then
      begin
        dest.x := x;
        dest.y := y;
        SDL_QueryTexture(FreshScreenTex[i], nil, nil, @dest.w, @dest.h);
        CleanTextScreenRect(x, y, dest.w, dest.h);
        SDL_RenderCopy(render, FreshScreenTex[i], nil, @dest);
      end;
    end
    else
    begin
      if FreshScreen[i] <> nil then
      begin
        dest.x := x;
        dest.y := y;
        dest.w := FreshScreen[i].w;
        dest.h := FreshScreen[i].h;
        SDL_UpperBlit(freshscreen[i], nil, screen, @dest);
        CleanTextScreenRect(x, y, dest.w, dest.h);
      end;
    end;
  end
  else
  begin
    {SDL_SetRenderDrawColor(render, 0, 0, 0, 128);
    SDL_RenderFillrect(render, nil);}
  end;
end;

procedure FreeFreshScreen;
var
  i: integer;
begin
  i := max(high(FreshScreenTex), high(FreshScreen));
  if i >= 0 then
  begin
    if SW_SURFACE = 0 then
    begin
      SDL_DestroyTexture(FreshScreenTex[i]);
      FreshScreenTex[i] := nil;
      setlength(FreshScreenTex, i);
    end
    else
    begin
      SDL_FreeSurface(FreshScreen[i]);
      FreshScreen[i] := nil;
      setlength(FreshScreen, i);
    end;
  end;
  {if i > 0 then
  begin
    SDL_SetRenderTarget(render, screenTex);
    SDL_RenderCopy(render, freshscreenTex[i - 1], nil, nil);
  end;}
end;

//刷新全部屏幕
procedure UpdateAllScreen;
var
  src, dest, destfull: TSDL_Rect;
  scr: PSDL_Texture;
  r, g, b: byte;
begin
  case ScreenBlendMode of
    0:
    begin
      r := 255;
      g := 255;
      b := 255;
    end;
    1:
    begin
      r := 150;
      g := 150;
      b := 220;
    end;
    2:
    begin
      r := 200;
      g := 152;
      b := 20;
    end;
  end;

  if SW_SURFACE = 0 then
  begin
    SDL_SetRenderTarget(render, nil);
    SDL_SetRenderDrawColor(render, 0, 0, 0, 0);
    SDL_RenderClear(render);
    SDL_SetTextureColorMod(screenTex, r, g, b);
    if KEEP_SCREEN_RATIO = 1 then
    begin
      src.x := 0;
      src.y := 0;
      src.w := CENTER_X * 2;
      src.h := CENTER_Y * 2;
      dest := GetRealRect(src, 1);
      SDL_RenderCopy(render, screenTex, nil, @dest);
    end
    else
      SDL_RenderCopy(render, screenTex, nil, nil);
    if (TEXT_LAYER = 1) and (HaveText = 1) then
    begin
      destfull.x := 0;
      destfull.y := 0;
      destfull.w := RESOLUTIONX;
      destfull.h := RESOLUTIONY;
      SDL_SetTextureColorMod(TextScreenTex, r, g, b);
      SDL_RenderCopy(render, TextScreenTex, nil, @destfull);
    end;
    SDL_RenderPresent(render);
    SDL_SetRenderTarget(render, screenTex);
  end
  else
  begin
    if (where < 5) then
    begin
      src.x := 0;
      src.y := 0;
      src.w := CENTER_X * 2;
      src.h := CENTER_Y * 2;
      dest := GetRealRect(src, 1);
      if SW_OUTPUT = 0 then
      begin
        SDL_UpdateTexture(screenTex, nil, screen.pixels, screen.pitch);
        SDL_RenderClear(render);
        SDL_SetTextureColorMod(screenTex, r, g, b);
        SDL_RenderCopy(render, screenTex, nil, @dest);
        if (TEXT_LAYER = 1) and (HaveText = 1) then
        begin
          SDL_UpdateTexture(TextScreenTex, nil, TextScreen.pixels, TextScreen.pitch);
          SDL_SetTextureColorMod(TextScreenTex, r, g, b);
          SDL_RenderCopy(render, TextScreenTex, nil, nil);
        end;
        SDL_RenderPresent(render);
      end
      else
      begin
        SDL_UpperBlit(screen, nil, RealScreen, @dest);
        SDL_UpdateWindowSurface(window);
      end;
    end;
  end;

end;


//清除文字层
procedure CleanTextScreen; overload;
var
  ptex: PSDL_Texture;
begin
  if (TEXT_LAYER = 1) and (HaveText = 1) then
  begin
    if SW_SURFACE = 0 then
    begin
      SDL_SetRenderTarget(render, TextScreenTex);
      SDL_SetRenderDrawBlendMode(render, SDL_BLENDMODE_NONE);
      SDL_SetRenderDrawColor(render, 255, 255, 255, 0);
      SDL_RenderClear(render);
      SDL_SetRenderTarget(render, screenTex);
    end
    else
    begin
      SDL_FillRect(TextScreen, nil, MapRGBA(255, 255, 255, 0));
    end;
    HaveText := 0;
  end;
end;

procedure CleanTextScreenRect(x, y, w, h: integer); overload;
var
  dest: TSDL_Rect;
begin
  if (TEXT_LAYER = 1) then
  begin
    if (w = 0) or (h = 0) then
    begin
      CleanTextScreen;
    end
    else
    begin
      dest := GetRealRect(x, y, w, h);
      if SW_SURFACE = 0 then
      begin
        SDL_SetRenderTarget(render, TextScreenTex);
        SDL_SetRenderDrawBlendMode(render, SDL_BLENDMODE_NONE);
        SDL_SetRenderDrawColor(render, 255, 255, 255, 0);
        SDL_RenderFillRect(render, @dest);
        SDL_SetRenderTarget(render, screenTex);
      end
      else
      begin
        SDL_FillRect(TextScreen, @dest, MapRGBA(255, 255, 255, 0));
      end;
    end;
  end;
end;


//清键值
procedure CleanKeyValue;
begin
  event.key.keysym.sym := 0;
  event.button.button := 0;
end;

//换算当前鼠标的位置为人物坐标
procedure GetMousePosition(var x, y: integer; x0, y0: integer; yp: integer = 0);
var
  x1, y1: integer;
begin
  SDL_GetMouseState2(x1, y1);
  x := (-x1 + CENTER_X + 2 * (y1 + yp) - 2 * CENTER_Y + 18) div 36 + x0;
  y := (x1 - CENTER_X + 2 * (y1 + yp) - 2 * CENTER_Y + 18) div 36 + y0;
end;

//判断鼠标是否在区域内, 以画布的坐标为准
//第二个函数会返回鼠标的画布位置
function MouseInRegion(x, y, w, h: integer): boolean; overload;
var
  x1, y1: integer;
begin
  SDL_GetMouseState2(x1, y1);
  Result := (x1 >= x) and (y1 >= y) and (x1 < x + w) and (y1 < y + h);
end;

function MouseInRegion(x, y, w, h: integer; var x1, y1: integer): boolean; overload;
begin
  SDL_GetMouseState2(x1, y1);
  Result := (x1 >= x) and (y1 >= y) and (x1 < x + w) and (y1 < y + h);
end;


//获取换算后的位置, 会改变变量的值
//force = 1 会在不使用文字分层时强制计算
function GetRealRect(var x, y, w, h: integer; force: integer = 0): TSDL_Rect; overload;
var
  scale: real;
  px, py: integer;
  s: TStretchInfo;
begin
  if (TEXT_LAYER = 1) or (force = 1) then
  begin
    s := KeepRatioScale(CENTER_X * 2, CENTER_Y * 2, RESOLUTIONX, RESOLUTIONY);
    x := s.px + x * s.num div s.den;
    y := s.py + y * s.num div s.den;
    w := w * s.num div s.den;
    h := h * s.num div s.den;
  end;
  Result.x := x;
  Result.y := y;
  Result.w := w;
  Result.h := h;
end;

function GetRealRect(rect: TSDL_Rect; force: integer = 0): TSDL_Rect; overload;
var
  x, y, w, h: integer;
begin
  x := rect.x;
  y := rect.y;
  w := rect.w;
  h := rect.h;
  Result := GetRealRect(x, y, w, h, force);

end;

procedure swap(var x, y: byte); overload;
var
  t: byte;
begin
  t := x;
  x := y;
  y := t;
end;

procedure swap(var x, y: uint32); overload;
var
  t: uint32;
begin
  t := x;
  x := y;
  y := t;
end;

//四舍五入
function round(x: real): integer;
begin
  Result := floor(x + 0.5);
end;

//限制变量的范围
function RegionParameter(x, x1, x2: integer): integer;
var
  px: integer;
begin
  if x < x1 then
    x := x1;
  if x > x2 then
    x := x2;
  Result := x;
end;

//线性插值
function LinearInsert(x, x1, x2: real; y1, y2: integer): integer;
begin
  Result := y1 + trunc((x - x1) / (x2 - x1) * (y2 - y1));
end;

function KeepRatioScale(w1, h1, w2, h2: integer): TStretchInfo;
begin
  if w2 / w1 > h2 / h1 then
  begin
    Result.num := h2;
    Result.den := h1;
    Result.px := (w2 - w1 * h2 div h1) div 2;
    Result.py := 0;
  end
  else
  begin
    Result.num := w2;
    Result.den := w1;
    Result.px := 0;
    Result.py := (h2 - h1 * w2 div w1) div 2;
  end;
  //分子和分母均不能为零, 在后面的计算中均可能作为被除数
  if Result.num = 0 then
    Result.num := 1;
  if Result.den = 0 then
    Result.den := 1;
end;

procedure QuickSort(var a: array of integer; l, r: integer);
var
  i, j, x, t: integer;
begin
  i := l;
  j := r;
  x := a[(l + r) div 2];
  repeat
    while a[i] < x do
      Inc(i);
    while a[j] > x do
      Dec(j);
    if i <= j then
    begin
      t := a[i];
      a[i] := a[j];
      a[j] := t;
      Inc(i);
      Dec(j);
    end;
  until i > j;
  if i < r then
    QuickSort(a, i, r);
  if l < j then
    QuickSort(a, l, j);
end;


procedure QuickSortB(var a: array of TBuildInfo; l, r: integer);
var
  i, j: integer;
  x, t: TBuildInfo;
begin
  i := l;
  j := r;
  x := a[(l + r) div 2];
  repeat
    while a[i].c < x.c do
      Inc(i);
    while a[j].c > x.c do
      Dec(j);
    if i <= j then
    begin
      t := a[i];
      a[i] := a[j];
      a[j] := t;
      Inc(i);
      Dec(j);
    end;
  until i > j;
  if i < r then
    QuickSortB(a, i, r);
  if l < j then
    QuickSortB(a, l, j);
end;

{$ifdef mswindows}

procedure tic;
begin
  QueryPerformanceFrequency(tttt);
  QueryPerformanceCounter(cccc1);
  //tttt := SDL_GetTicks;
end;

procedure toc;
begin
  QueryPerformanceCounter(cccc2);
  writeln(' ', format('%3.2f', [(cccc2 - cccc1) / tttt * 1e6]), 'us.');
end;

{$else}

procedure tic;
begin
  tttt := SDL_GetTicks;
end;

procedure toc;
begin
  writeln(' ', SDL_GetTicks - tttt, 'ms.');
end;

{$endif}


end.
