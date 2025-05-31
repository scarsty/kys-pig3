unit kys_engine;

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
  {$ENDIF}
  Classes,
  SysUtils,
  SDL2_ttf,
  SDL2_image,
  SDL2,
  kys_type,
  kys_main,
  Dialogs,
  bassmidi,
  bass,
  Math,
  {$IFDEF windows}
  potdll,
  {$endif}
  mythoutput,
  libzip;

type
  IntegerArray = array of integer;

function EventFilter(p: pointer; e: PSDL_Event): longint; cdecl;
procedure SendKeyEvent(keyvalue: integer); stdcall; export;

//音频子程
procedure InitialMusic;
procedure FreeAllMusic;
procedure PlayMP3(MusicNum, times: integer; frombeginning: integer = 1); overload;
procedure PlayMP3(filename: putf8char; times: integer); overload;
procedure StopMP3(frombeginning: integer = 1);
procedure PlaySound(SoundNum, times: integer); overload;
procedure PlaySound(SoundNum, times, x, y, z: integer); overload;
procedure PlaySoundA(SoundNum, times: integer); overload;
procedure PlaySound(SoundNum: integer); overload;
procedure PlaySound(filename: putf8char; times: integer); overload;

//基本绘图子程
function GetPixel(surface: PSDL_Surface; x: integer; y: integer): uint32;
procedure PutPixel(surface: PSDL_Surface; x: integer; y: integer; pixel: uint32);
function ColColor(num: integer): uint32; inline;
procedure DrawRectangle(x, y, w, h: integer; colorin, colorframe: uint32; alpha: integer; trans: integer = 1);
procedure DrawRectangleWithoutFrame(x, y, w, h: integer; colorin: uint32; alpha: integer);
procedure DrawItemFrame(x, y: integer; realcoord: integer = 0);

//画RLE8图片的子程
function JudgeInScreen(px, py, w, h, xs, ys: integer): boolean; overload; inline;
function JudgeInScreen(px, py, w, h, xs, ys, xx, yy, xw, yh: integer): boolean; overload; inline;
function GetPositionOnScreen(x, y, CenterX, CenterY: integer): TPosition;

//显示文字的子程
function Big5ToUnicode(str: putf8char): utf8string;
function GBKToUnicode(str: putf8char): utf8string;
//function str: putf8char; len: integer = -1: utf8string;
function UnicodeToBig5(str: putf8char): utf8string;
function UnicodeToGBK(str: putf8char): utf8string;
function IsStringUTF8(strtmp: utf8string): boolean;
procedure DrawText(word: utf8string; x_pos, y_pos: integer; color: uint32; engwidth: integer = -1);
procedure DrawEngText(word: utf8string; x_pos, y_pos: integer; color: uint32);
procedure DrawShadowText(word: utf8string; x_pos, y_pos: integer; color1, color2: uint32; Tex: PSDL_Texture = nil; Sur: PSDL_Surface = nil; realPosition: integer = 0; eng: integer = 0); overload;
procedure DrawEngShadowText(word: utf8string; x_pos, y_pos: integer; color1, color2: uint32; Tex: PSDL_Texture = nil; Sur: PSDL_Surface = nil);
//procedure DrawU16ShadowText(word: puint16; x_pos, y_pos: integer; color1, color2: uint32);

function Simplified2Traditional(mSimplified: utf8string): utf8string;
procedure DrawPartPic(pic: pointer; x, y, w, h, x1, y1: integer);
function Traditional2Simplified(mTraditional: utf8string): utf8string;
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

function JoyAxisMouse(interval: uint32; param: pointer): uint32; cdecl;

function CheckBasicEvent: uint32;
function AngleToDirection(y, x: real): integer;

procedure ChangeCol;

//用于读取的子程
procedure InitialPicArrays;
procedure ReadTiles;
function LoadPNGTilesThread(Data: pointer): longint; cdecl;
function ReadFileToBuffer(p: putf8char; filename: utf8string; size, malloc: integer): putf8char; overload;
function ReadFileToBuffer(p: putf8char; const filename: putf8char; size, malloc: integer): putf8char; overload;
function FileGetlength(filename: utf8string): integer;
procedure FreeFileBuffer(var p: putf8char);
function LoadIdxGrp(stridx, strgrp: utf8string): TIDXGRP;
function LoadPNGTiles(path: utf8string; var PNGIndexArray: TPNGIndexArray; LoadPic: integer = 1; frame: psmallint = nil): integer; overload;
procedure LoadOnePNGTexture(path: utf8string; z: pzip_t; var PNGIndex: TPNGIndex; forceLoad: integer = 0); overload;
function LoadTileFromFile(filename: utf8string; var pt: Pointer; usesur: integer; var w, h: integer): boolean;
function LoadTileFromMem(p: putf8char; len: integer; var pt: Pointer; usesur: integer; var w, h: integer): boolean;
function LoadStringFromIMZMEM(path: utf8string; p: putf8char; num: integer): utf8string;
//function LoadStringFromZIP(zfilename, filename: utf8string): utf8string; overload;
//function LoadStringFromZIP(zfile: unzFile; filename: utf8string): utf8string; overload;
//function LoadSurfaceFromZIPFile(zipFile: unzFile; filename: utf8string): PSDL_Surface;
//procedure FreeAllSurface;
procedure DestroyAllTextures(all: integer = 1);
procedure DestroyFontTextures();

procedure DrawPNGTile(render: PSDL_Renderer; PNGIndex: TPNGIndex; FrameNum: integer; px, py: integer); overload;
procedure DrawPNGTile(render: PSDL_Renderer; PNGIndex: TPNGIndex; FrameNum: integer; px, py: integer; region: PSDL_Rect; shadow, alpha: integer; mixColor: uint32; mixAlpha: integer; scalex, scaley, angle: real; center: PSDL_Point); overload;
procedure DrawPNGTileS(scr: PSDL_Surface; PNGIndex: TPNGIndex; FrameNum: integer; px, py: integer; region: PSDL_Rect; shadow, alpha: integer; mixColor: uint32; mixAlpha: integer; scalex, scaley, angle: real); overload;

function CopyIndexSurface(PNGIndexArray: TPNGIndexArray; i: integer): PSDL_Surface;

function PlayMovie(filename: utf8string): boolean;

//字串的绘制长度
function DrawLength(str: utf8string): integer; overload;
function DrawLength(p: putf8char): integer; overload;
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
procedure CleanKeyValue; inline;

//屏幕拉伸相关
procedure GetMousePosition(var x, y: integer; x0, y0: integer; yp: integer = 0);
function InRegion(x1, y1, x, y, w, h: integer): boolean; overload;
function MouseInRegion(x, y, w, h: integer): boolean; overload;
function MouseInRegion(x, y, w, h: integer; var x1, y1: integer): boolean; overload;
function GetRealRect(var x, y, w, h: integer; force: integer = 0): TSDL_Rect; overload;
function GetRealRect(rect: TSDL_Rect; force: integer = 0): TSDL_Rect; overload;
function KeepRatioScale(w1, h1, w2, h2: integer): TStretchInfo;

//这两个可能是加密时用过
procedure swap(var x, y: byte); overload;
procedure swap(var x, y: uint32); overload;

//几个数学函数
function round(x: real): integer; inline;
function RegionParameter(x, x1, x2: integer): integer;
function LinearInsert(x, x1, x2: real; y1, y2: integer): integer;
procedure QuickSort(var a: array of integer; l, r: integer);
procedure QuickSortB(var a: array of TBuildInfo; l, r: integer);
function InRegion(x, x1, x2: integer): boolean; overload;

//计时, 测速用
procedure tic;
procedure toc;

procedure ConsoleLog(formatstring: utf8string; content: array of const; cr: boolean = True); overload; inline;
procedure ConsoleLog(formatstring: utf8string = ''; cr: boolean = True); overload; inline;

function utf8follow(c1: utf8char): integer;

function readFiletostring(filename: utf8string): utf8string; overload;
function readnumbersformstring(str: utf8string): IntegerArray; overload;

implementation

uses
  kys_draw;

function EventFilter(p: pointer; e: PSDL_Event): longint; cdecl;
begin
  Result := 1;
  {or (e.type_ = SDL_FINGERMOTION)}
  case e.type_ of
    SDL_FINGERUP, SDL_FINGERDOWN, SDL_CONTROLLERAXISMOTION, SDL_CONTROLLERBUTTONDOWN, SDL_CONTROLLERBUTTONUP: Result := 0;
    SDL_FINGERMOTION:
      if CellPhone = 0 then
        Result := 0;
  end;
end;

procedure SendKeyEvent(keyvalue: integer);
var
  e: tsdl_event;
begin
  e.type_ := SDL_KEYUP;
  e.key.keysym.sym := keyvalue;
  SDL_PushEvent(@e);
end;

procedure InitialMusic;
var
  i: integer;
  str: utf8string;
  sf: BASS_MIDI_FONT;
  Flag: longword;
  p: putf8char;
begin
  BASS_Set3DFactors(1, 0, 0);
  sf.font := BASS_MIDI_FontInit(putf8char(AppPath + 'music/mid.sf2'), 0);
  BASS_MIDI_StreamSetFonts(0, sf, 1);
  sf.preset := -1; //use all presets
  sf.bank := 0;
  Flag := 0;
  if SOUND3D = 1 then
    Flag := BASS_SAMPLE_3D or BASS_SAMPLE_MONO or Flag;

  for i := 0 to high(Music) do
  begin
    str := AppPath + 'music/' + IntToStr(i) + '.mp3';
    if FileExists(putf8char(str)) then
    begin
      try
        {$IFDEF android0}
        p := ReadFileToBuffer(nil, putf8char(str), -1, 1);
        Music[i] := BASS_StreamCreateFile(True, p, 0, FileGetlength(str), 0);
        FreeFileBuffer(p);
        {$ELSE}
        Music[i] := BASS_StreamCreateFile(False, putf8char(str), 0, 0, 0);
        {$ENDIF}
      finally
      end;
    end
    else
    begin
      str := AppPath + 'music/' + IntToStr(i) + '.mid';
      if FileExists(putf8char(str)) then
      begin
        try
          {$IFDEF android0}
          p := ReadFileToBuffer(nil, putf8char(str), -1, 1);
          Music[i] := BASS_MIDI_StreamCreateFile(True, p, 0, FileGetlength(str), 0, 0);
          FreeFileBuffer(p);
          {$ELSE}
          Music[i] := BASS_MIDI_StreamCreateFile(False, putf8char(str), 0, 0, 0, 0);
          {$ENDIF}
          BASS_MIDI_StreamSetFonts(Music[i], sf, 1);
          //showmessage(inttostr(Music[i]));
        finally
        end;
      end
      else
        Music[i] := 0;
    end;
  end;

  for i := 0 to high(Esound) do
  begin
    str := AppPath + 'sound/e' + IntToStr(i) + '.wav';
    if FileExists(putf8char(str)) then
    begin
      {$IFDEF android0}
      p := ReadFileToBuffer(nil, putf8char(str), -1, 1);
      ESound[i] := BASS_SampleLoad(True, p, 0, FileGetlength(str), 1, Flag);
      FreeFileBuffer(p);
      {$ELSE}
      ESound[i] := BASS_SampleLoad(False, putf8char(str), 0, 0, 1, Flag);
      {$ENDIF}
    end
    else
      ESound[i] := 0;
    //showmessage(inttostr(esound[i]));
  end;
  for i := 0 to high(Asound) do
  begin
    str := AppPath + formatfloat('sound/atk00', i) + '.wav';
    if FileExists(putf8char(str)) then
    begin
      {$IFDEF android0}
      p := ReadFileToBuffer(nil, putf8char(str), -1, 1);
      ASound[i] := BASS_SampleLoad(True, p, 0, FileGetlength(str), 1, Flag);
      FreeFileBuffer(p);
      {$ELSE}
      ASound[i] := BASS_SampleLoad(False, putf8char(str), 0, 0, 1, Flag);
      {$ENDIF}
    end
    else
      ASound[i] := 0;
  end;
  //BASS_MIDI_FontFree(sf.font);
end;

procedure FreeAllMusic;
var
  i: integer;
begin
  for i := 0 to high(Music) do
  begin
    if Music[i] <> 0 then
      BASS_StreamFree(Music[i]);
  end;
  for i := 0 to high(Asound) do
  begin
    if Asound[i] <> 0 then
      BASS_SampleFree(Asound[i]);
  end;
  for i := 0 to high(Esound) do
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
    if (MusicNum in [low(Music) .. high(Music)]) and (VOLUME > 0) then
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

procedure PlayMP3(filename: putf8char; times: integer); overload;
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
  if (SoundNum in [low(Esound) .. high(Esound)]) and (VOLUMEWAV > 0) then
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

  if (SoundNum in [low(Esound) .. high(Esound)]) and (VOLUMEWAV > 0) then
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
  if (SoundNum in [low(Asound) .. high(Asound)]) and (VOLUMEWAV > 0) then
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

procedure PlaySound(filename: putf8char; times: integer); overload;
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
  TByteArray = array [0 .. 2] of byte;
  PByteArray = ^TByteArray;
var
  bpp: integer;
  p: PInteger;
begin
  if (x >= 0) and (x < surface.w) and (y >= 0) and (y < surface.h) then
  begin
    bpp := surface.format.BytesPerPixel;
    //Here p is the address to the pixel we want to retrieve
    p := Pointer(uint32(surface.pixels) + y * surface.pitch + x * bpp);
    case bpp of
      1: Result := longword(p^);
      2: Result := puint16(p)^;
      {3:
        if (SDL_BYTEORDER = SDL_BIG_ENDIAN) then
        Result := PByteArray(p)[0] shl 16 or PByteArray(p)[1] shl 8 or PByteArray(p)[2]
        else
        Result := PByteArray(p)[0] or PByteArray(p)[1] shl 8 or PByteArray(p)[2] shl 16;}
      4: Result := puint32(p)^;
      else
        Result := 0; //shouldn't happen, but avoids warnings
    end;
  end;

end;

//画像素
procedure PutPixel(surface: PSDL_Surface; x: integer; y: integer; pixel: uint32);
type
  TByteArray = array [0 .. 2] of byte;
  PByteArray = ^TByteArray;
var
  bpp: integer;
  p: PInteger;
begin
  if (x >= 0) and (x < surface.w) and (y >= 0) and (y < surface.h) then
  begin
    bpp := surface.format.BytesPerPixel;
    //Here p is the address to the pixel we want to set
    p := Pointer(uint32(surface.pixels) + y * surface.pitch + x * bpp);
    case bpp of
      1: longword(p^) := pixel;
      2: puint16(p)^ := pixel;
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
        end;}
      4: puint32(p)^ := pixel;
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
function JudgeInScreen(px, py, w, h, xs, ys: integer): boolean;
begin
  //Result := False;
  //if (px - xs + w >= 0) and (px - xs < screen.w) and (py - ys + h >= 0) and (py - ys < screen.h) then
  Result := True;
end;

//判断像素是否在指定范围内(重载)
function JudgeInScreen(px, py, w, h, xs, ys, xx, yy, xw, yh: integer): boolean;
begin
  //Result := False;
  Result := (px - xs + w >= xx) and (px - xs < xx + xw) and (py - ys + h >= yy) and (py - ys < yy + yh);
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
function Big5ToUnicode(str: putf8char): utf8string;
var
  len: integer;
begin
  {$IFDEF fpc}
  Result := CP950ToUTF8(str);
  {$ELSE}
  len := MultiByteToWideChar(950, 0, putf8char(str), -1, nil, 0);
  setlength(Result, len - 1);
  MultiByteToWideChar(950, 0, putf8char(str), length(str), putf8char(Result), len + 1);
  {$ENDIF}
end;

function GBKToUnicode(str: putf8char): utf8string;
var
  len: integer;
begin
  {$IFDEF fpc}
  Result := CP936ToUTF8(str);
  {$ELSE}
  len := MultiByteToWideChar(950, 0, putf8char(str), -1, nil, 0);
  setlength(Result, len - 1);
  MultiByteToWideChar(950, 0, putf8char(str), length(str), putf8char(Result), len + 1);
  {$ENDIF}
end;

{function str: putf8char; len: integer = -1: utf8string;
var
  strw: widestring;
begin
  strw := WideString(pwidechar(str));
  if len >= 0 then
  begin
    if length(strw) > len then
      setlength(strw, len);
  end;
  Result := utf8encode(strw);
end;}

//unicode转为big5, 仅用于输入姓名
function UnicodeToBig5(str: putf8char): utf8string;
var
  len: integer;
begin
  {$IFDEF fpc}
  Result := UTF8ToCP950((str));
  {$ELSE}
  len := WideCharToMultiByte(950, 0, putf8char(str), -1, nil, 0, nil, nil);
  setlength(Result, len + 1);
  WideCharToMultiByte(950, 0, putf8char(str), -1, putf8char(Result), len + 1, nil, nil);
  {$ENDIF}
end;

//unicode转为GBK, 仅用于输入姓名
function UnicodeToGBK(str: putf8char): utf8string;
var
  len: integer;
begin
  {$IFDEF fpc}
  Result := UTF8ToCP936((str));
  {$ELSE}
  len := WideCharToMultiByte(936, 0, putf8char(str), -1, nil, 0, nil, nil);
  setlength(Result, len + 1);
  WideCharToMultiByte(936, 0, putf8char(str), -1, putf8char(Result), len + 1, nil, nil);
  {$ENDIF}
end;

//繁体汉字转化成简体汉字
function Traditional2Simplified(mTraditional: utf8string): utf8string; //返回繁体字符串
var
  L: integer;
begin
  {$IFDEF windows}
  mTraditional := UTF8ToCP936(mTraditional);
  L := Length(mTraditional);
  SetLength(Result, L + 1);
  Result[L + 1] := char(0);
  if L > 0 then
    LCMapString($0800, $02000000, putf8char(mTraditional), L, @Result[1], L);
  result := CP936TOUTF8(result);
  {$ELSE}
  Result := mTraditional;
  {$ENDIF}
end; {Traditional2Simplified}

//生成或查找已知纹理, 返回其指针, 是否销毁由调用者决定
function CreateFontTile(num: integer; usesur: integer; var w, h: integer): pointer;
var
  size0, size, key: integer;
  pfont: PTTF_Font;
  needcreate: boolean;
  whitecolor: uint32 = $FFFFFFFF;
  word: array [0 .. 4] of byte = (32, 0, 0, 0, 0);
  src, dst: TSDL_Rect;
  sur, tempsur: PSDL_Surface;
  tex, temptex: PSDL_Texture;
  pt: putf8char;
begin
  //是否可能是已有纹理
  if num >= 128 then
  begin
    size0 := CHINESE_FONT_SIZE;
    size := CHINESE_FONT_REALSIZE;
    pfont := font;
    src.x := CHNFONT_SPACEWIDTH;
    src.y := 0;
    word[0] := 32;
    word[1] := num;
    word[2] := num shr 8;
    word[3] := num shr 16;
    pt := @word[1];
  end
  else
  begin
    size0 := ENGLISH_FONT_SIZE;
    size := ENGLISH_FONT_REALSIZE;
    pfont := engfont;
    src.x := 0;
    src.y := 0;
    word[0] := num;
    word[1] := 0;
    pt := @word[0];
  end;

  key := (size shl 24) or num;
  //可以直接查找的情况, 其他情况需要创建
  if CharTex.ContainsKey(key) then
  begin
    case usesur of
      0:
      begin
        tex := CharTex[key];
        Result := tex;
        SDL_QueryTexture(tex, nil, nil, @w, @h);
      end;
      else
      begin
        sur := CharTex[key];
        Result := sur;
        w := sur.w;
        h := sur.h;
      end;
    end;
  end
  else
  begin
    tempsur := TTF_RenderUTF8_blended(pfont, @word[0], TSDL_Color(whitecolor));
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
    SDL_BlitSurface(tempsur, @src, sur, @dst);
    {try
      SDL_FreeSurface(tempsur);
    except
      ConsoleLog('Free font surface %s %d failed', [widechar(num), size0]);
    end;}
    ConsoleLog(format('%s(%d)', [pt, CharTex.Count]), False);
    if usesur = 0 then
    begin
      tex := SDL_CreateTextureFromSurface(render, sur);
      SDL_FreeSurface(sur);
      Result := Tex;
      CharTex.add(key, tex);
    end
    else
    begin
      Result := pointer(sur);
      CharTex.add(key, sur);
    end;
  end;
end;

function IsStringUTF8(strtmp: utf8string): boolean;
var
  nBytes: byte;
  chr: byte;
  bAllAscii: boolean;
  i: integer;
begin
  nBytes := 0;
  bAllAscii := True;
  for i := 1 to length(strtmp) do
  begin
    chr := Ord(strtmp[i]);
    if (chr and $80) <> 0 then
      bAllAscii := False;
    if nBytes = 0 then
    begin
      if chr >= $80 then
      begin
        if chr >= $FC then
          nBytes := 6
        else if chr >= $F8 then
          nBytes := 5
        else if chr >= $F0 then
          nBytes := 4
        else if chr >= $E0 then
          nBytes := 3
        else if chr >= $C0 then
          nBytes := 2
        else
          Exit(False);
        Dec(nBytes);
      end;
    end
    else
    begin
      if (chr and $C0) <> $80 then
        Exit(False);
      Dec(nBytes);
    end;
  end;

  if nBytes > 0 then
    Exit(False);
  if bAllAscii then
    Exit(True);
  Result := True;
end;

//显示utf-8文字
//engsize如果未指定则按照中文宽度一半
procedure DrawText(word: utf8string; x_pos, y_pos: integer; color: uint32; engwidth: integer = -1);
var
  dest, src, dst: TSDL_Rect;
  tempcolor, whitecolor: TSDL_Color;
  len, i, k, len_utf8: integer;
  word0: array [0 .. 2] of uint16 = (32, 0, 0);
  word1: utf8string;
  word2: utf8string;
  p1: pbyte;
  p2: pbyte;
  t: utf8string;
  Sur: PSDL_Surface;
  Tex, ptex: PSDL_Texture;
  r, g, b, size: byte;
  saved: boolean;
  p: pointer;
  w, h: integer;
begin
  len := length(putf8char(word));
  if len = 0 then
    exit;
  GetRGBA(color, @r, @g, @b);
  tempcolor.r := r;
  tempcolor.g := g;
  tempcolor.b := b;
  tempcolor.a := 255;

  if engwidth <= 0 then
    engwidth := CHINESE_FONT_REALSIZE div 2;

  if SIMPLE = 1 then
  begin
    word := Traditional2Simplified(putf8char(word));
  end;

  dest.x := x_pos;
  dest.y := y_pos;
  i := 1;
  //如果当前为标准字号, 则创建纹理, 否则临时生成表面
  while i <= len do
  begin
    k := byte(word[i]);
    //i := word^;
    //word0[1] := i;
    //Inc(word);
    if k < 128 then
    begin
      dest.y := y_pos + 3;
      i := i + 1;
    end
    else
    begin
      dest.y := y_pos;
      len_utf8 := utf8follow(word[i]);
      k := byte(word[i]) + byte(word[i + 1]) * 256;
      if len_utf8 = 3 then
        k := k + byte(word[i + 2]) * 65536;
      i := i + len_utf8;
    end;
    p := CreateFontTile(k, SW_SURFACE, w, h);
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
      end;
      else
      begin
        sur := PSDL_Surface(p);
        SDL_SetSurfaceColorMod(sur, r, g, b);
        if TEXT_LAYER = 1 then
        begin
          SDL_SetSurfaceBlendMode(sur, SDL_BLENDMODE_MOD);
          SDL_BlitSurface(sur, nil, CurTargetSurface, @dest);
        end;
        SDL_SetSurfaceBlendMode(sur, SDL_BLENDMODE_BLEND);
        SDL_BlitSurface(sur, nil, CurTargetSurface, @dest);
      end;
    end;
    if k >= 128 then
      dest.x := dest.x + CHINESE_FONT_REALSIZE
    else
      dest.x := dest.x + engwidth;
  end;
  HaveText := 1;
end;


//显示英文
procedure DrawEngText(word: utf8string; x_pos, y_pos: integer; color: uint32);
var
  dest: TSDL_Rect;
  Text: PSDL_Surface;
  tempcolor: TSDL_Color;
  tex: PSDL_Texture;
  r, g, b: byte;
  str: utf8string = ' ';
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
procedure DrawShadowText(word: utf8string; x_pos, y_pos: integer; color1, color2: uint32; Tex: PSDL_Texture = nil; Sur: PSDL_Surface = nil; realPosition: integer = 0; eng: integer = 0); overload;
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
procedure DrawEngShadowText(word: utf8string; x_pos, y_pos: integer; color1, color2: uint32; Tex: PSDL_Texture = nil; Sur: PSDL_Surface = nil);
begin
  DrawShadowText(word, x_pos, y_pos + 4, color1, color2, Tex, Sur, 0, 1);
end;

//显示Unicode16阴影文字
procedure DrawU16ShadowText(word: puint16; x_pos, y_pos: integer; color1, color2: uint32);
var
  words: utf8string;
begin
  words := utf8encode(WideString(pwidechar(word)));
  DrawShadowText(words, x_pos + 1, y_pos, color1, color2);
end;

//画带边框矩形, (x坐标, y坐标, 宽度, 高度, 内部颜色, 边框颜色, 透明度, 可能转为单行框）
procedure DrawRectangle(x, y, w, h: integer; colorin, colorframe: uint32; alpha: integer; trans: integer = 1);
var
  i1, i2, l1, l2, l3, l4, x1, y1, w1, h1: integer;
  tempscr, tempsur1: PSDL_Surface;
  dest: TSDL_Rect;
  r, g, b, r1, g1, b1, a: byte;
  tex, ptex: PSDL_Texture;
  color: TSDL_Color;
begin
  if (h <= 35) and (trans <> 0) then
  begin
    DrawTextFrame(x - 12, y + 1, w div 10);
    exit;
  end;

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
        {if TEXT_LAYER = 0 then
          if (((l1 >= 4) and (l2 >= 4) and (l3 >= 4) and (l4 >= 4) and ((i1 = 0) or (i1 = w) or
          (i2 = 0) or (i2 = h))) or ((l1 = 4) or (l2 = 4) or (l3 = 4) or (l4 = 4))) then
          begin
          a := round(250 - abs(i1 / w + i2 / h - 1) * 150);
          SDL_SetRenderDrawColor(render, r1, g1, b1, a);
          SDL_RenderDrawPoint(render, i1, i2);
          end;}
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
          {if (((l1 >= 4) and (l2 >= 4) and (l3 >= 4) and (l4 >= 4) and ((i1 = 0) or (i1 = w) or
            (i2 = 0) or (i2 = h))) or ((l1 = 4) or (l2 = 4) or (l3 = 4) or (l4 = 4))) then
            begin
            a := round(250 - abs(i1 / w + i2 / h - 1) * 150);
            SDL_SetRenderDrawColor(render, r1, g1, b1, a);
            SDL_RenderDrawPoint(render, i1, i2);
            end;}
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
        {if TEXT_LAYER = 0 then
          if (((l1 >= 4) and (l2 >= 4) and (l3 >= 4) and (l4 >= 4) and ((i1 = 0) or (i1 = w) or
          (i2 = 0) or (i2 = h))) or ((l1 = 4) or (l2 = 4) or (l3 = 4) or (l4 = 4))) then
          begin
          //a := round(200 - min(abs(i1/w-0.5),abs(i2/h-0.5))*2 * 100);
          a := round(250 - abs(i1 / w + i2 / h - 1) * 150);
          //writeln(a);
          PutPixel(tempscr, i1 + x1, i2 + y1, MapRGBA(r1, g1, b1, a));
          end;}
      end;

    SDL_BlitSurface(tempscr, nil, CurTargetSurface, @dest);
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
          {if (((l1 >= 4) and (l2 >= 4) and (l3 >= 4) and (l4 >= 4) and ((i1 = 0) or (i1 = w) or
            (i2 = 0) or (i2 = h))) or ((l1 = 4) or (l2 = 4) or (l3 = 4) or (l4 = 4))) then
            begin
            //a := round(200 - min(abs(i1/w-0.5),abs(i2/h-0.5))*2 * 100);
            a := round(250 - abs(i1 / w + i2 / h - 1) * 150);
            //writeln(a);
            PutPixel(tempscr, i1 + x1, i2 + y1, MapRGBA(r1, g1, b1, a));
            end;}
        end;
      dest.x := x;
      dest.y := y;
      dest.w := 0;
      dest.h := 0;
      SDL_BlitSurface(tempscr, nil, TextScreen, @dest);
      SDL_FreeSurface(tempscr);
    end;
  end;
end;

//画不含边框的矩形, 用于对话, 黑屏, 血条
//注意大量画点运算应交给cpu
procedure DrawRectangleWithoutFrame(x, y, w, h: integer; colorin: uint32; alpha: integer);
var
  tempsur: PSDL_Surface;
  temptex: PSDL_Texture;
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
  if (SW_SURFACE = 0) and (alpha >= 0) then
  begin
    SDL_SetRenderDrawBlendMode(render, SDL_BLENDMODE_BLEND);
    SDL_SetRenderDrawColor(render, r, g, b, 255 - 255 * alpha div 100);
    dest.x := x;
    dest.y := y;
    dest.w := w;
    dest.h := h;
    SDL_RenderFillRect(render, @dest);
  end
  else
  begin
    if (w > 0) and (h > 0) then
    begin
      tempsur := SDL_CreateRGBSurface(0, w, h, 32, RMask, GMask, BMask, AMASK);
      SDL_FillRect(tempsur, nil, MapRGBA(r, g, b, 255 - alpha * 255 div 100));
      //SDL_SetSurfaceAlphaMod(tempscr, 255 - alpha * 255 div 100);
      SDL_SetSurfaceBlendMode(tempsur, SDL_BLENDMODE_BLEND);
      if CurTargetSurface = TextScreen then
        SDL_SetSurfaceBlendMode(tempsur, SDL_BLENDMODE_MOD);
      dest.x := x;
      dest.y := y;
      dest.w := w;
      dest.h := h;
      if alpha < 0 then
      begin
        //SDL_FillRect(tempscr, nil, MapRGBA(r, g, b, 255 - alpha * 255 div 100));
        for i1 := 0 to w - 1 do
          for i2 := 0 to h - 1 do
          begin
            case alpha of
              -1: a := round(250 - abs(i2 / h - 0.5) * 150);
              -2: a := round(150 + abs(i2 / h - 0.5) * 100);
            end;
            PutPixel(tempsur, i1, i2, MapRGBA(r, g, b, a));
          end;
      end;
      if SW_SURFACE = 0 then
      begin
        temptex := SDL_CreateTextureFromSurface(render, tempsur);
        SDL_SetTextureBlendMode(temptex, SDL_BLENDMODE_BLEND);
        SDL_RenderCopy(render, temptex, nil, @dest);
        SDL_DestroyTexture(temptex);
      end
      else
        SDL_BlitSurface(tempsur, nil, CurTargetSurface, @dest);
      SDL_FreeSurface(tempsur);
    end;
  end;
  //SDL_SetRenderTarget(render, ptex);

  //SDL_SetTextureAlphaMod(tex, 255-255*alpha div 100);
  //writeln(alpha);
  //SDL_SetRenderDrawColor(render, 255,255,255,255);
  //SDL_RenderCopy(render, tex, nil, @dest);
  //sdl_destroytexture(tex);
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
    //rectangleRGBA(sur, x, y, x+w, y+h, 0, 0, 0,alpha * 255 div 100);}

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
    xp := CENTER_X - 200;
    yp := 75;
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
function Simplified2Traditional(mSimplified: utf8string): utf8string; //返回繁体字符串
var
  L: integer;
begin
  {$IFDEF windows}
  mSimplified := UTF8ToCP936(mSimplified);
  L := Length(mSimplified);
  SetLength(Result, L + 1);
  Result[L + 1] := char(0);
  if L > 0 then
    LCMapString(GetUserDefaultLCID, $04000000, putf8char(mSimplified), L, @Result[1], L);
  //writeln(L,mSimplified,',',result,GetUserDefaultLCID);
  result := CP936TOUTF8(result);
  {$ELSE}
  Result := mSimplified;
  {$ENDIF}
end; {Simplified2Traditional}

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
      SDL_BlitSurface(PSDL_Surface(pic), @dest1, screen, @dest);
end;

procedure PlayBeginningMovie;
var
  i, GRP, IDX, len: integer;
  MOV: PSDL_Surface;
  MOVpic: array of byte;
  MOVidx: array of integer;
begin
end;

procedure SDL_UpdateRect2(scr1: PSDL_Surface; x, y, w, h: integer);
begin

end;

procedure SDL_GetMouseState2(var x, y: integer);
var
  tempx, tempy, temp: integer;
  px, py, w, h: integer;
  s: TStretchInfo;
begin
  SDL_GetMouseState(@tempx, @tempy);
  if ScreenRotate = 1 then
  begin
    x := round(tempy / RESOLUTIONY * CENTER_X * 2);
    y := CENTER_Y * 2 - round(tempx / RESOLUTIONX * CENTER_Y * 2);
    exit;
  end;
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
    for i := 0 to FreshScreen.Count - 1 do
      FreeFreshScreen;
    FreshScreen.Destroy();
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
      TextScreenTex := SDL_CreateTexture(render, SDL_PIXELFORMAT_ARGB8888, SDL_TEXTUREACCESS_TARGET, RESOLUTIONX, RESOLUTIONY);
      SDL_SetTextureBlendMode(TextScreenTex, SDL_BLENDMODE_BLEND);
      CleanTextScreen;
    end
    else
    begin
      TextScreen := SDL_CreateRGBSurface(0, RESOLUTIONX, RESOLUTIONY, 32, RMask, GMask, BMask, AMASK);
      TextScreenTex := SDL_CreateTexture(render, SDL_PIXELFORMAT_ARGB8888, SDL_TEXTUREACCESS_STREAMING, RESOLUTIONX, RESOLUTIONY);
      SDL_SetTextureBlendMode(TextScreenTex, SDL_BLENDMODE_BLEND);
    end;
    ResizeSimpleText(1); //设定简单状态使用的字体层
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
    ImgSGroundTex := SDL_CreateTexture(render, SDL_PIXELFORMAT_ARGB8888, SDL_TEXTUREACCESS_TARGET, ImageWidth, ImageHeight);
    ImgBGroundTex := SDL_CreateTexture(render, SDL_PIXELFORMAT_ARGB8888, SDL_TEXTUREACCESS_TARGET, ImageWidth, ImageHeight);
    SimpleStateTex := SDL_CreateTexture(render, SDL_PIXELFORMAT_ARGB8888, SDL_TEXTUREACCESS_TARGET, 960, 90);
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

    screenTex := SDL_CreateTexture(render, SDL_PIXELFORMAT_ARGB8888, SDL_TEXTUREACCESS_STREAMING, CENTER_X * 2, CENTER_Y * 2);
    SDL_SetTextureBlendMode(screenTex, SDL_BLENDMODE_NONE);
  end;
  //FreshScreenTex:=TList.Create();
  FreshScreen := TList.Create();
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
        SimpleTextTex[i] := SDL_CreateTexture(render, SDL_PIXELFORMAT_ARGB8888, SDL_TEXTUREACCESS_TARGET, w1 + x, y + h1);
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
  menuString: array [0 .. 1] of utf8string;
  Tex: PSDL_Texture;
begin
  //NeedRefreshScene := 0;
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
    if CommonMenu(CENTER_X * 2 - 100, 10, 47, 1, 0, menuString) = 1 then
      Quit;
    //Redraw;
    //SDL_BlitSurface(tempscr, nil, screen, nil);
    LoadFreshScreen;
    FreeFreshScreen;
    UpdateAllScreen;
    AskingQuit := False;
  end;
  //NeedRefreshScene := 1;
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
  i, x, y: integer;
  msCount: uint32;
  msWait: uint32;

  function inReturn(x, y: integer): boolean; inline;
  begin
    Result := (x > CENTER_X * 2 - 100) and (y > CENTER_Y * 2 - 100);
  end;

  function inEscape(x, y: integer): boolean; inline;
  begin
    Result := (x > CENTER_X * 2 - 100) and (y < 100);
  end;

  function inSwitchShowVirtualKey(x, y: integer): boolean; inline;
  begin
    Result := (x < 100) and (y < 100);
  end;

  function inVirtualKey(x, y: integer; var key: uint32): uint32;
  begin
    Result := 0;
    if inregion(x, y, VirtualKeyX, VirtualKeyY, VirtualKeySize, VirtualKeySize) then
      Result := SDLK_UP;
    if inregion(x, y, VirtualKeyX - VirtualKeySize - VirtualKeySpace, VirtualKeyY + VirtualKeySize + VirtualKeySpace, VirtualKeySize, VirtualKeySize) then
      Result := SDLK_LEFT;
    if inregion(x, y, VirtualKeyX, VirtualKeyY + VirtualKeySize * 2 + VirtualKeySpace * 2, VirtualKeySize, VirtualKeySize) then
      Result := SDLK_DOWN;
    if inregion(x, y, VirtualKeyX + VirtualKeySize + VirtualKeySpace, VirtualKeyY + VirtualKeySize, VirtualKeySize + VirtualKeySpace, VirtualKeySize) then
      Result := SDLK_RIGHT;
    key := Result;
  end;

begin
  //if not ((LoadingTiles) or (LoadingScene)) then
  SDL_FlushEvent(SDL_MOUSEWHEEL);
  SDL_FlushEvent(SDL_JOYAXISMOTION);
  SDL_FlushEvent(SDL_FINGERMOTION);
  //SDL_FlushEvent(SDL_FINGERDOWN);
  //SDL_FlushEvent(SDL_FINGERUP);
  if CellPhone = 1 then
    SDL_FlushEvent(SDL_MOUSEMOTION);
  //writeln(inttohex(event.type_, 4));
  //JoyAxisMouse;
  Result := event.type_;
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
      case event.jhat.Value of
        SDL_HAT_UP: event.key.keysym.sym := SDLK_UP;
        SDL_HAT_DOWN: event.key.keysym.sym := SDLK_DOWN;
        SDL_HAT_LEFT: event.key.keysym.sym := SDLK_LEFT;
        SDL_HAT_RIGHT: event.key.keysym.sym := SDLK_RIGHT;
      end;
    end;
    SDL_FINGERMOTION:
      if CellPhone = 1 then
      begin
        if event.tfinger.fingerId = 1 then
        begin
          msCount := SDL_GetTicks() - FingerTick;
          msWait := 50;
          if BattleSelecting then
            msWait := 100;
          if msCount > 500 then
            FingerCount := 1;
          if ((FingerCount <= 2) and (msCount > 200)) or ((FingerCount > 2) and (msCount > msWait)) then
          begin
            FingerCount := FingerCount + 1;
            FingerTick := SDL_GetTicks();
            event.type_ := SDL_KEYDOWN;
            event.key.keysym.sym := AngleToDirection(event.tfinger.dy, event.tfinger.dx);
          end;
        end;
      end;
    SDL_FINGERUP: ;
    SDL_MULTIGESTURE: ;
    SDL_QUITEV: QuitConfirm;
    SDL_WindowEvent:
    begin
      if event.window.event = SDL_WINDOWEVENT_RESIZED then
      begin
        ResizeWindow(event.window.data1, event.window.data2);
      end;
    end;
    SDL_APP_DIDENTERFOREGROUND: PlayMP3(nowmusic, -1, 0);
    SDL_APP_DIDENTERBACKGROUND: StopMP3(0);
    {SDL_MOUSEBUTTONDOWN:
      if (CellPhone = 1) and (event.button.button = SDL_BUTTON_LEFT) then
      begin
      SDL_GetMouseState(@x, @y);
      end;}
    SDL_MOUSEMOTION:
    begin
      if CellPhone = 1 then
      begin
        FingerCount := 0;
        SDL_GetMouseState2(x, y);
        if inEscape(x, y) or inReturn(x, y) then
          event.type_ := 0;
      end;
    end;
    SDL_MOUSEBUTTONDOWN:
    begin
      if (CellPhone = 1) and (showVirtualKey <> 0) then
      begin
        SDL_GetMouseState2(x, y);
        inVirtualKey(x, y, VirtualKeyValue);
        if VirtualKeyValue <> 0 then
        begin
          event.type_ := SDL_KEYDOWN;
          event.key.keysym.sym := VirtualKeyValue;
        end;
      end;
    end;
    SDL_KEYUP, SDL_MOUSEBUTTONUP:
    begin
      if (CellPhone = 1) and (event.type_ = SDL_MOUSEBUTTONUP) and (event.button.button = SDL_BUTTON_LEFT) then
      begin
        SDL_GetMouseState2(x, y);
        if inEscape(x, y) then
        begin
          //event.button.x := RESOLUTIONX div 2;
          //event.button.y := RESOLUTIONY div 2;
          event.button.button := SDL_BUTTON_RIGHT;
          event.key.keysym.sym := SDLK_ESCAPE;
          ConsoleLog('Change to escape');
        end
        else if inReturn(x, y) then
        begin
          //event.button.x := RESOLUTIONX div 2;
          //event.button.y := RESOLUTIONY div 2;
          event.type_ := SDL_KEYUP;
          event.key.keysym.sym := SDLK_RETURN;
          ConsoleLog('Change to return');
        end
        else if (showVirtualKey <> 0) and (inVirtualKey(x, y, VirtualKeyValue) <> 0) then
        begin
          if VirtualKeyValue <> 0 then
          begin
            event.type_ := SDL_KEYUP;
            event.key.keysym.sym := VirtualKeyValue;
          end;
        end
        else if inSwitchShowVirtualKey(x, y) then
        begin
          if ShowVirtualKey <> 0 then
            ShowVirtualKey := 0
          else
            ShowVirtualKey := 1;
          event.type_ := SDL_RELEASED;
          event.key.keysym.sym := 0;
        end
        else if (showVirtualKey <> 0) and (inVirtualKey(x, y, VirtualKeyValue) = 0) then
        begin
          event.type_ := SDL_RELEASED;
          event.key.keysym.sym := 0;
        end
        //手机在战场仅有确认键有用
        else if (where = 2) and (BattleSelecting) then
        begin
          event.button.button := 0;
        end;
        //第二指不触发事件
        if FingerCount >= 1 then
          event.button.button := 0;
      end;
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

function AngleToDirection(y, x: real): integer;
var
  angle: real;
  angleregion: real;
begin
  Result := 0;
  angle := arctan2(-y, x);
  angleregion := PI / 4;
  //注意这里的判断方法可能并不准确

  if (abs(angle + PI / 8) < angleregion) then
    Result := SDLK_RIGHT;
  if (abs(angle - PI * 3 / 8) < angleregion) then
    Result := SDLK_UP;
  if (abs(angle - PI * 7 / 8) < angleregion) or (angle < -PI * 7 / 8) then
    Result := SDLK_LEFT;
  if (abs(angle + PI * 5 / 8) < angleregion) then
    Result := SDLK_DOWN;
  if ScreenRotate = 1 then
    case Result of
      SDLK_UP: Result := SDLK_LEFT;
      SDLK_DOWN: Result := SDLK_RIGHT;
      SDLK_LEFT: Result := SDLK_DOWN;
      SDLK_RIGHT: Result := SDLK_UP;
    end;
end;

procedure ChangeCol;
var
  i, a, b, add0, len: integer;
  temp: array [0 .. 2] of byte;
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
  word: array [0 .. 1] of uint16 = (0, 0);
begin
  if PNG_TILE > 0 then
  begin
    MPicAmount := LoadPNGTiles('resource/mmap', MPNGIndex, PNG_LOAD_ALL);
    SPicAmount := LoadPNGTiles('resource/smap', SPNGIndex, PNG_LOAD_ALL);
    HPicAmount := LoadPNGTiles('resource/head', HPNGIndex, PNG_LOAD_ALL);
    IPicAmount := LoadPNGTiles('resource/item', IPNGIndex, PNG_LOAD_ALL);
    CPicAmount := LoadPNGTiles('resource/cloud', CPNGIndex, 1);

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
      pMPic := zip_open(putf8char(AppPath + 'resource/mmap.zip'), ZIP_RDONLY);
      pSPic := zip_open(putf8char(AppPath + 'resource/smap.zip'), ZIP_RDONLY);
      pHPic := zip_open(putf8char(AppPath + 'resource/head.zip'), ZIP_RDONLY);
      pIPic := zip_open(putf8char(AppPath + 'resource/item.zip'), ZIP_RDONLY);
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
    if fileexists(AppPath + 'resource/head/' + inttostr(i) + '.png') then
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
  pPic: pzip_t;
  pIndex: ^TPNGIndex;
  path: utf8string;
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
function ReadFileToBuffer(p: putf8char; filename: utf8string; size, malloc: integer): putf8char; overload;
var
  i: integer;
begin
  {$IFDEF android0}
  filename := StringReplace(filename, AppPath, 'game/', [rfReplaceAll]);
  Result := Android_ReadFiletoBuffer(p, putf8char(filename), size, malloc);
  {$ELSE}
  i := FileOpen(filename, fmopenread);
  if i > 0 then
  begin
    if size < 0 then
      size := FileSeek(i, 0, 2);
    if malloc = 1 then
    begin
      //GetMem(result, size + 4);
      Result := StrAlloc(size);
      p := Result;
      //writeln(StrBufSize(p));
    end;
    FileSeek(i, 0, 0);
    FileRead(i, p^, size);
    FileClose(i);
  end
  else if malloc = 1 then
    Result := nil;
  {$ENDIF}
end;

function ReadFileToBuffer(p: putf8char; const filename: putf8char; size, malloc: integer): putf8char; overload;
begin
  Result := ReadFileToBuffer(p, filename, size, malloc);
end;

function FileGetlength(filename: utf8string): integer;
begin
  {$IFDEF android0}
  filename := StringReplace(filename, AppPath, 'game/', [rfReplaceAll]);
  Result := Android_FileGetlength(putf8char(filename));
  {$ELSE}
  Result := 0;
  {$ENDIF}
end;

procedure FreeFileBuffer(var p: putf8char);
begin
  {$IFDEF android0}
  if p <> nil then
    Android_FileFreeBuffer(p);
  {$ELSE}
  if p <> nil then
    StrDispose(p);
  {$ENDIF}
  p := nil;
end;

//载入IDX和GRP文件到变长数据, 不适于非变长数据
function LoadIdxGrp(stridx, strgrp: utf8string): TIDXGRP;
var
  IDX, GRP, len, tnum: integer;
  pIDX, pGRP: putf8char;
begin
  tnum := 0;
  if FileExists(AppPath + strgrp) and FileExists(AppPath + stridx) then
  begin
    pIDX := ReadFileToBuffer(nil, AppPath + stridx, -1, 1);
    pGRP := ReadFileToBuffer(nil, AppPath + strgrp, -1, 1);
    tnum := StrBufSize(pIDX) div 4;
    setlength(Result.IDX, tnum + 1);
    Result.IDX[0] := 0;
    move(pIDX^, Result.IDX[1], tnum * 4);
    len := StrBufSize(pGRP);
    setlength(Result.GRP, len + 4);
    move(pGRP^, Result.GRP[0], len);
    FreeFileBuffer(pIDX);
    FreeFileBuffer(pGRP);
    {grp := FileOpen(AppPath + strgrp, fmopenread);
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
      FileClose(idx);}
  end;
  Result.Amount := tnum;

end;

//为了提高启动的速度, M之外的贴图均仅读入基本信息, 需要时才实际载入图, 并且游戏过程中通常不再释放资源
function LoadPNGTiles(path: utf8string; var PNGIndexArray: TPNGIndexArray; LoadPic: integer = 1; frame: psmallint = nil): integer; overload;
const
  maxCount: integer = 9999;
var
  i, j, k, state, size, Count, pngoff, n, n0: integer;
  //zipFile: unzFile;
  //info: unz_file_info;
  offset: array of smallint;
  buf: ansistring;
  p: putf8char;
  po: pointer;
  z: pzip_t;
  zf: pzip_file_t;
  len: ptruint;
  nums: array of integer;
begin
  //载入偏移值文件, 计算贴图的最大数量
  size := 0;
  Result := 0;
  p := nil;
  z := nil;
  if PNG_TILE = 2 then
  begin
    ConsoleLog('Searching file %s.zip', [path]);
    z := zip_open(PChar(AppPath + path + '.zip'), ZIP_RDONLY, nil);
    if z <> nil then
    begin
      //zf:=zip_fopen(z, 'index.ka', 8);
      //len:=zip_getsize(z, 'index.ka');
      //setlength(offset, len div 2 + 2);
      //zip_fread(zf, @offset[0], len);
      //zip_fclose(zf);
      buf := zip_express(z, 'index.ka');
      setlength(offset, length(buf) div 2 + 2);
      move(buf[1], offset[0], length(buf));
      Result := length(buf) div 4;

      if (frame <> nil) then
      begin
        nums := readnumbersformstring(zip_express(z, 'fightframe.txt'));
        for i := 0 to length(nums) div 2 - 1 do
        begin
          (frame +nums[i * 2])^ := nums[i * 2 + 1];
        end;
      end;

      for i := length(buf) div 4 downto 0 do
      begin
        if (zip_name_locate(z, PChar(IntToStr(i) + '.png')) >= 0) or (zip_name_locate(z, PChar(IntToStr(i) + '_0.png')) >= 0) then
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
        with PNGIndexArray[i] do
        begin
          FileNum := i;
          PointerNum := 1;
          Frame := 1;
          //CurPointer := nil;
          if zip_name_locate(z, PChar(IntToStr(i) + '.png')) >= 0 then
          begin
            PointerNum := Count;
            Frame := 1;
            Count := Count + 1;
          end
          else
          begin
            k := 0;
            while zip_name_locate(z, PChar(IntToStr(i) + '_' + IntToStr(k) + '.png')) >= 0 do
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
          setlength(Pointers, Frame);
        end;
      end;
      //ConsoleLog('%d index, %d real tiles', [Result, Count]);
    end
    else
      ConsoleLog('Can''t find zip file');
  end;

  if (PNG_TILE = 1) or (z = nil) then
  begin
    ConsoleLog('Searching index of png files %s/index.ka', [path]);
    path := path + '/';
    if (frame <> nil) then
    begin
      fillchar(frame^, 10, 0);
      nums := readnumbersformstring(readFiletostring(AppPath + path + '/fightframe.txt'));
      for i := 0 to length(nums) div 2 - 1 do
      begin
        (frame +nums[i * 2])^ := nums[i * 2 + 1];
      end;
    end;
    p := ReadFileToBuffer(nil, AppPath + path + '/index.ka', -1, 1);
    size := StrBufSize(p);
    setlength(offset, size div 2 + 2);
    move(p^, offset[0], size);
    FreeFileBuffer(p);

    for i := size div 4 downto 0 do
    begin
      if FileExists(AppPath + path + IntToStr(i) + '.png') or FileExists(AppPath + path + IntToStr(i) + '_0.png') then
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
        //CurPointer := nil;
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
        setlength(Pointers, Frame);
      end;
    end;
  end;

  ConsoleLog('%d index, %d real tiles', [Result, Count]);

  for i := 0 to Result - 1 do
    PNGIndexArray[i].BeginPointer := po;

  if LoadPic = 1 then
  begin
    ConsoleLog('Now loading...', False);
    for i := 0 to Result - 1 do
    begin
      LoadOnePNGTexture(path, z, PNGIndexArray[i], 1);
    end;
    ConsoleLog('end');
  end;
  zip_close(z);
  //FreeFileBuffer(p);

end;

//这个函数没有容错处理, 在独立文件和打包文件都不存在时会引起游戏崩溃, 需要特别注意!
//p如果为nil, 则试图读取文件
procedure LoadOnePNGTexture(path: utf8string; z: pzip_t; var PNGIndex: TPNGIndex; forceLoad: integer = 0); overload;
var
  i, j, k, index, len, off, w1, h1: integer;
  frommem: boolean;
  pb, pc: pointer;
  buf: ansistring;
begin
  SDL_PollEvent(@event);
  CheckBasicEvent;
  frommem := ((PNG_TILE = 2) and (z <> nil));
  if not frommem then
    path := path + '/';
  with PNGIndex do
  begin
    if ((Loaded = 0) or (forceLoad = 1)) and (PointerNum >= 0) and (Frame > 0) then
    begin
      Loaded := 1;
      w := 0;
      h := 0;
      //CurPointerT := BeginPointer;
      //CurPointer := BeginPointer;
      //Inc(CurPointerT, PointerNum);
      //Inc(CurPointer, PointerNum);
      //temptex := CurPointerT;
      //tempsur := CurPointer;

      if frommem then
      begin
        Frame := 1;
        buf := zip_express(z, IntToStr(filenum) + '.png');
        if length(buf) > 0 then
          LoadTileFromMem(@buf[1], length(buf), Pointers[0], SW_SURFACE, w, h)
        else
        begin
          setlength(Pointers, 10);
          for i := 0 to 9 do
          begin
            buf := zip_express(z, IntToStr(filenum) + '_' + IntToStr(i) + '.png');
            if length(buf) > 0 then
            begin
              LoadTileFromMem(@buf[1], length(buf), Pointers[i], SW_SURFACE, w, h);
            end
            else
            begin
              frame := i;
              PointerNum := 0;
              break;
            end;
          end;
          setlength(Pointers, Frame);
        end;
        //off := pinteger(p + 4 + filenum * 4)^ + 8;
        //index := pinteger(p + off)^;
        //len := pinteger(p + off + 4)^;
        //LoadTileFromMem(p + index, len, Pointers[0], SW_SURFACE, w, h);
      end
      else
      begin
        if Frame = 1 then
        begin
          if LoadTileFromFile(AppPath + path + IntToStr(filenum) + '.png', Pointers[0], SW_SURFACE, w, h) = False then
            LoadTileFromFile(AppPath + path + IntToStr(filenum) + '_0.png', Pointers[0], SW_SURFACE, w, h);
        end;
        if Frame > 1 then
        begin
          for j := 0 to Frame - 1 do
          begin
            LoadTileFromFile(AppPath + path + IntToStr(filenum) + '_' + IntToStr(j) + '.png', Pointers[j], SW_SURFACE, w1, h1);
            if (j = 0) then
            begin
              w := w1;
              h := h1;
            end;
            //Inc(temptex, 1);
            //Inc(tempsur, 1);
          end;
        end;
      end;
    end;
    Loaded := 1;
  end;

end;

//从文件载入表面
function LoadTileFromFile(filename: utf8string; var pt: Pointer; usesur: integer; var w, h: integer): boolean;
var
  tempscr: PSDL_Surface;
begin
  Result := False;
  pt := nil;
  if FileExists(filename) then
  begin
    Result := True;
    if usesur = 0 then
    begin
      pt := IMG_LoadTexture(render, putf8char(filename));
      if pt <> nil then
      begin
        SDL_SetTextureBlendMode(pt, SDL_BLENDMODE_BLEND);
        SDL_QueryTexture(pt, nil, nil, @w, @h);
        Result := True;
      end;
    end
    else
    begin
      tempscr := IMG_Load(putf8char(filename));
      pt := SDL_ConvertSurface(tempscr, screen.format, 0);
      SDL_FreeSurface(tempscr);
      //SDL_SetSurfaceBlendMode(ps^, SDL_BLENDMODE_BlEND);
      if pt <> nil then
      begin
        tempscr := PSDL_Surface(pt);
        w := tempscr.w;
        h := tempscr.h;
        Result := True;
      end;
    end;
  end;
end;


//从内存载入表面
function LoadTileFromMem(p: putf8char; len: integer; var pt: Pointer; usesur: integer; var w, h: integer): boolean;
var
  tempscr: PSDL_Surface;
  tempRWops: PSDL_RWops;
begin
  Result := False;
  tempRWops := SDL_RWFromMem(p, len);
  pt := nil;
  if usesur = 0 then
  begin
    pt := IMG_LoadTextureTyped_RW(render, tempRWops, 0, 'png');
    if pt <> nil then
    begin
      SDL_SetTextureBlendMode(pt, SDL_BLENDMODE_BLEND);
      SDL_QueryTexture(pt, nil, nil, @w, @h);
      Result := True;
    end;
  end
  else
  begin
    tempscr := IMG_LoadTyped_RW(tempRWops, 0, 'png');
    pt := SDL_ConvertSurface(tempscr, screen.format, 0);
    SDL_FreeSurface(tempscr);
    if pt <> nil then
    begin
      tempscr := pt;
      w := tempscr.w;
      h := tempscr.h;
      Result := True;
    end;
  end;
  SDL_FreeRW(tempRWops);

end;

function LoadStringFromIMZMEM(path: utf8string; p: putf8char; num: integer): utf8string;
var
  index, len, off: integer;
begin
  off := pinteger(p + 4 + num * 4)^ + 8;
  index := pinteger(p + off)^;
  len := pinteger(p + off + 4)^;
  //ConsoleLog('%d %d %d', [num, off, len]);
  setlength(Result, len);
  move((p + index)^, Result[1], len);
end;

procedure DestroyAllTextures(all: integer = 1);
var
  i: integer;

  {procedure DestoryTextureArray(TextureArray: TTextureArray);
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
    end;}
begin

  {ResetIndexArray(MPNGIndex);
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
  }
  if all = 1 then
  begin
    DestroyRenderTextures;
    SDL_DestroyTexture(screenTex);
    SDL_DestroyTexture(ImgSGroundTex);
    SDL_DestroyTexture(ImgBGroundTex);
    zip_close(pMPic);
    zip_close(pSPic);
    //zip_close(pBPic);
    //zip_close(pEPic);
    zip_close(pHPic);
    zip_close(pIPic);
  end;

end;

procedure DestroyFontTextures();
var
  i: integer;
begin
  {for i := 0 to high(CharTex) do
  begin
    if CharTex[i] <> nil then
    begin
      SDL_DestroyTexture(CharTex[i]);
      CharTex[i] := nil;
    end;
  end;}
end;

procedure DrawPNGTile(render: PSDL_Renderer; PNGIndex: TPNGIndex; FrameNum: integer; px, py: integer); overload;
var
  rect: TSDL_Rect;
  tex: PSDL_Texture;
begin
  if SW_SURFACE <> 0 then
  begin
    DrawPNGTileS(CurTargetSurface, PNGIndex, FrameNum, px, py, nil, 0, 0, 0, 0, 1, 1, 0);
    exit;
  end;
  with PNGIndex do
  begin
    if (Frame > 0) then
    begin
      tex := Pointers[0];
      rect.x := px - x;
      rect.y := py - y;
      rect.w := w;
      rect.h := h;
      if (Frame > 1) then
        tex := Pointers[FrameNum mod PNGIndex.Frame];
      SDL_SetTextureAlphaMod(tex, 255);
      SDL_SetTextureColorMod(tex, 255, 255, 255);
      SDL_RenderCopy(render, tex, nil, @rect);
    end;
  end;
end;

procedure DrawPNGTile(render: PSDL_Renderer; PNGIndex: TPNGIndex; FrameNum: integer; px, py: integer; region: PSDL_Rect; shadow, alpha: integer; mixColor: uint32; mixAlpha: integer; scalex, scaley, angle: real; center: PSDL_Point); overload;
var
  rect: TSDL_Rect;
  r, g, b, a, r1, g1, b1: byte;
  newtex: boolean;
  tex, tex1, ptex: PSDL_Texture;
begin
  if SW_SURFACE <> 0 then
  begin
    DrawPNGTileS(CurTargetSurface, PNGIndex, FrameNum, px, py, region, shadow, alpha, mixColor, mixAlpha, scalex, scaley, angle);
    exit;
  end;
  //shadow设置混合方式, 以及预设值等
  with PNGIndex do
  begin
    //if (CurPointerT = nil) or (CurPointerT^ = nil) then
    //exit;
    if (Frame = 0) then
      exit;
    tex := Pointers[0];
    if Frame > 1 then
      tex := Pointers[FrameNum mod Frame];
    //tex := CurPointerT^;
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
  SDL_SetTextureColorMod(tex, 255, 255, 255);
  SDL_SetTextureAlphaMod(tex, 255);
  if (mixAlpha > 0) and (shadow <= 0) then
  begin
    GetRGBA(mixColor, @r, @g, @b);
    r1 := max(0, 255 - (255 + g + b) * mixAlpha div 100);
    g1 := max(0, 255 - (255 + r + b) * mixAlpha div 100);
    b1 := max(0, 255 - (255 + r + g) * mixAlpha div 100);
    SDL_SetTextureColorMod(tex, r1, g1, b1);
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
  end;
  SDL_RenderCopyEx(render, tex, region, @rect, angle, center, SDL_FLIP_NONE);
  //SDL_RenderCopy(render, tex, nil, nil);
  if newtex then
    SDL_DestroyTexture(tex);

end;

procedure DrawPNGTileS(scr: PSDL_Surface; PNGIndex: TPNGIndex; FrameNum: integer; px, py: integer; region: PSDL_Rect; shadow, alpha: integer; mixColor: uint32; mixAlpha: integer; scalex, scaley, angle: real); overload;
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
      if Frame = 0 then
        exit;
      sur := Pointers[0];
      if Frame > 1 then
        sur := Pointers[FrameNum mod Frame];
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
    SDL_SetSurfaceColorMod(sur, 255, 255, 255);
    SDL_SetSurfaceAlphaMod(sur, 255);
    if (mixAlpha > 0) and (shadow <= 0) then
    begin
      GetRGBA(mixColor, @r, @g, @b);
      r1 := max(0, 255 - (255 + g + b) * mixAlpha div 100);
      g1 := max(0, 255 - (255 + r + b) * mixAlpha div 100);
      b1 := max(0, 255 - (255 + r + g) * mixAlpha div 100);
      SDL_SetSurfaceColorMod(sur, r1, g1, b1);
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
      SDL_BlitSurface(sur2, nil, sur, nil);
      SDL_FreeSurface(sur2);
    end;
    if alpha > 0 then
    begin
      SDL_SetSurfaceAlphaMod(sur, 255 * (100 - alpha) div 100);
    end;

    if (rect.w = PNGIndex.w) and (rect.h = PNGIndex.h) then
      SDL_BlitSurface(sur, region, scr, @rect)
    else
      SDL_UpperBlitScaled(sur, region, scr, @rect);
    if newsur then
      SDL_FreeSurface(sur);
  except
    ConsoleLog('Bad PNGINDEX, filenum %d, width %d, height %d', [PNGIndex.FileNum, PNGIndex.w, PNGIndex.h]);
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

function PlayMovie(filename: utf8string): boolean;
begin
  {$IFDEF windows}
  PotInputVideo(smallpot, @filename[1]);
  {$ENDIF}
end;

function DrawLength(str: utf8string): integer; overload;
var
  l, i: integer;
begin
  i := 1;
  Result := 0;
  while i <= length(str) do
  begin
    if byte(str[i]) >= 128 then
    begin
      Result := Result + 2;
      i := i + 3;
    end
    else
    begin
      Result := Result + 1;
      i := i + 1;
    end;
  end;
end;

function DrawLength(p: putf8char): integer; overload;
begin
  Result := DrawLength(utf8string(p));
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
  word: array [0 .. 1] of uint16 = (32, 0);
  tempcolor: TSDL_Color;
  p: putf8char;
begin
  if (TEXT_LAYER = 0) or (force = 1) then
    scale := 1
  else
    scale := min(RESOLUTIONX / CENTER_X / 2, RESOLUTIONY / CENTER_Y / 2);
  //ConsoleLog('scale is %f', [scale]);
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
  //ConsoleLog('size is %d and %d', [chnsize, engsize]);
  //{$ifdef android}
  {p := ReadFileToBuffer(nil, putf8char(AppPath + CHINESE_FONT), -1, 1);
    font := TTF_OpenFontRW(SDL_RWFromMem(p, FileGetlength(putf8char(AppPath + CHINESE_FONT))), 1, chnsize);
    //FreeFileBuffer(p);
    p := ReadFileToBuffer(nil, putf8char(AppPath + CHINESE_FONT), -1, 1);
    engfont := TTF_OpenFontRW(SDL_RWFromMem(p, FileGetlength(putf8char(AppPath + CHINESE_FONT))), 1, engsize);
    //FreeFileBuffer(p);}
  //{$else}
  font := TTF_OpenFont(putf8char(AppPath + CHINESE_FONT), chnsize);
  engfont := TTF_OpenFont(putf8char(AppPath + ENGLISH_FONT), engsize);
  //{$endif}

  CHINESE_FONT_REALSIZE := chnsize;
  ENGLISH_FONT_REALSIZE := engsize;
  //ConsoleLog('real size is %d and %d', [CHINESE_FONT_REALSIZE, ENGLISH_FONT_REALSIZE]);

  if (font = nil) or (engfont = nil) then
    ConsoleLog('Read fonts failed');

  //测试中文字体的空格宽度
  Text := TTF_RenderUNICODE_solid(font, @word[0], tempcolor);
  CHNFONT_SPACEWIDTH := Text.w;
  SDL_FreeSurface(Text);
  //ConsoleLog('space size is %d', [CHNFONT_SPACEWIDTH]);
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
    SDL_BlitSurface(SimpleStatus[i], nil, screen, @dest);

    if (TEXT_LAYER = 1) then
    begin
      if (mixAlpha > 0) then
      begin
        SDL_SetSurfaceColorMod(SimpleText[i], r1, g1, b1);
      end
      else
        SDL_SetSurfaceColorMod(SimpleText[i], 255, 255, 255);
      SDL_BlitSurface(SimpleText[i], @rectcut, TextScreen, @dest2);
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
  tex: PSDL_Texture;
  sur: PSDL_Surface;
begin
  dest.x := x;
  dest.y := y;
  dest.w := w;
  dest.h := h;
  if SW_SURFACE = 0 then
  begin
    tex := SDL_CreateTexture(render, SDL_PIXELFORMAT_ARGB8888, SDL_TEXTUREACCESS_TARGET, w, h);
    SDL_SetRenderTarget(render, tex);
    SDL_RenderCopy(render, screenTex, @dest, nil);
    SDL_SetRenderTarget(render, screenTex);
    FreshScreen.Add(tex);
  end
  else
  begin
    sur := SDL_CreateRGBSurface(0, w, h, 32, RMASK, GMASK, BMASK, AMASK);
    SDL_BlitSurface(screen, @dest, sur, nil);
    FreshScreen.Add(sur);
  end;
  //CleanTextScreenRect(x, y, w, h);
  ConsoleLog('Now the amount of fresh screens is %d', [FreshScreen.Count]);

end;

procedure LoadFreshScreen; overload;
begin
  LoadFreshScreen(0, 0);
end;

procedure LoadFreshScreen(x, y: integer); overload;
var
  i: integer;
  dest: TSDL_Rect;
  tex: PSDL_Texture;
  sur: PSDL_Surface;
begin
  i := FreshScreen.Count - 1;
  if i >= 0 then
  begin
    if SW_SURFACE = 0 then
    begin
      if FreshScreen[i] <> nil then
      begin
        tex := PSDL_Texture(FreshScreen[i]);
        dest.x := x;
        dest.y := y;
        SDL_QueryTexture(tex, nil, nil, @dest.w, @dest.h);
        CleanTextScreenRect(x, y, dest.w, dest.h);
        SDL_RenderCopy(render, tex, nil, @dest);
      end;
    end
    else
    begin
      if FreshScreen[i] <> nil then
      begin
        sur := PSDL_Surface(FreshScreen[i]);
        dest.x := x;
        dest.y := y;
        dest.w := sur.w;
        dest.h := sur.h;
        SDL_BlitSurface(sur, nil, screen, @dest);
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
  i := FreshScreen.Count - 1;
  if i >= 0 then
  begin
    if SW_SURFACE = 0 then
    begin
      SDL_DestroyTexture(PSDL_Texture(FreshScreen[i]));
      FreshScreen[i] := nil;
      FreshScreen.Delete(i);
    end
    else
    begin
      SDL_FreeSurface(PSDL_Surface(FreshScreen[i]));
      FreshScreen[i] := nil;
      FreshScreen.Delete(i);
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
  prect: PSDL_Rect;
  scr: PSDL_Texture;
  r, g, b: byte;
  degree: float;
  mid: TSDL_Point;
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
    begin
      if ScreenRotate = 0 then
      begin
        SDL_RenderCopy(render, screenTex, nil, nil);
      end
      else
      begin
        dest.x := RESOLUTIONX;
        dest.y := 0;
        dest.w := RESOLUTIONY;
        dest.h := RESOLUTIONX;
        mid.x := 0;
        mid.y := 0;
        SDL_RenderCopyEx(render, screenTex, nil, @dest, 90, @mid, 0);
      end;
    end;
    SDL_SetTextureColorMod(screenTex, 255, 255, 255);
    if (TEXT_LAYER = 1) and (HaveText = 1) then
    begin
      destfull.x := 0;
      destfull.y := 0;
      destfull.w := RESOLUTIONX;
      destfull.h := RESOLUTIONY;
      SDL_SetTextureColorMod(TextScreenTex, r, g, b);
      SDL_RenderCopy(render, TextScreenTex, nil, @destfull);
      SDL_SetTextureColorMod(TextScreenTex, 255, 255, 255);
    end;
    SDL_RenderPresent(render);
    SDL_SetRenderTarget(render, screenTex);
  end
  else
  begin
    if (where < 5) then
    begin
      if KEEP_SCREEN_RATIO = 1 then
      begin
        src.x := 0;
        src.y := 0;
        src.w := CENTER_X * 2;
        src.h := CENTER_Y * 2;
        dest := GetRealRect(src, 1);
        prect := @dest;
      end
      else
        prect := nil;
      if SW_OUTPUT = 0 then
      begin
        SDL_UpdateTexture(screenTex, nil, screen.pixels, screen.pitch);
        SDL_RenderClear(render);
        SDL_SetTextureColorMod(screenTex, r, g, b);
        SDL_RenderCopy(render, screenTex, nil, prect);
        SDL_SetTextureColorMod(screenTex, 255, 255, 255);
        if (TEXT_LAYER = 1) and (HaveText = 1) then
        begin
          SDL_UpdateTexture(TextScreenTex, nil, TextScreen.pixels, TextScreen.pitch);
          SDL_SetTextureColorMod(TextScreenTex, r, g, b);
          SDL_RenderCopy(render, TextScreenTex, nil, nil);
          SDL_SetTextureColorMod(TextScreenTex, 255, 255, 255);
        end;
        SDL_RenderPresent(render);
      end
      else
      begin
        SDL_BlitSurface(screen, nil, RealScreen, prect);
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
function InRegion(x1, y1, x, y, w, h: integer): boolean;
begin
  Result := (x1 >= x) and (y1 >= y) and (x1 < x + w) and (y1 < y + h);
end;

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

function InRegion(x, x1, x2: integer): boolean; overload;
begin
  Result := (x >= x1) and (x <= x2);
end;

{$IFDEF mswindows}

procedure tic;
begin
  QueryPerformanceFrequency(tttt);
  QueryPerformanceCounter(cccc1);
  //tttt := SDL_GetTicks;
end;

procedure toc;
begin
  QueryPerformanceCounter(cccc2);
  ConsoleLog(' %3.2f us', [(cccc2 - cccc1) / tttt * 1E6]);
end;

{$ELSE}

procedure tic;
begin
  tttt := SDL_GetTicks;
end;

procedure toc;
begin
  ConsoleLog(' %d ms', [SDL_GetTicks - tttt]);
end;

{$ENDIF}

procedure ConsoleLog(formatstring: utf8string; content: array of const; cr: boolean = True); overload; inline;
var
  i: integer;
  str: utf8string;
begin
  if IsConsole then
  begin
    Write(format(formatstring, content));
    if cr then
      writeln();
  end;
  {$IFDEF android}
  str := format(formatstring, content);
  mythoutput.mythoutput(putf8char(str));
  {i := fileopen(SDL_AndroidGetExternalStoragePath()+'/pig3_place_game_here',fmopenwrite);
    fileseek(i, 0, 2);
    filewrite(i, str[1], length(str));
    fileclose(i);}
  {$ENDIF}
end;

procedure ConsoleLog(formatstring: utf8string = ''; cr: boolean = True); overload; inline;
var
  i: integer;
  str: utf8string;
begin
  if IsConsole then
  begin
    Write(format(formatstring, []));
    if cr then
      writeln();
  end;
  {$IFDEF android}
  str := format(formatstring, []);
  mythoutput.mythoutput(putf8char(str));
  {i := fileopen(SDL_AndroidGetExternalStoragePath()+'/pig3_place_game_here',fmopenwrite);
    fileseek(i, 0, 2);
    filewrite(i, str[1], length(str));
    fileclose(i);}
  {$ENDIF}
end;

function utf8follow(c1: utf8char): integer;
var
  c: byte;
begin
  c := byte(c1);
  if (c and $80) = 0 then
    Result := 1
  else if (c and $E0) = $C0 then
    Result := 2
  else if (c and $F0) = $E0 then
    Result := 3
  else if (c and $F8) = $F0 then
    Result := 4
  else if (c and $FC) = $F8 then
    Result := 5
  else if (c and $FE) = $FC then
    Result := 6
  else
    Result := 1;    //skip one char
end;

function readFiletostring(filename: utf8string): utf8string; overload;
var
  f: TFileStream;
  len: integer;
begin
  Result := '';
  if not FileExists(filename) then
    exit;
  f := TFileStream.Create(filename, fmOpenRead or fmShareDenyNone);
  try
    len := f.Size;
    SetLength(Result, len);
    f.ReadBuffer(Result[1], len);
  finally
    f.Free;
  end;
end;

function readnumbersformstring(str: utf8string): IntegerArray; overload;
var
  i, n, k: integer;
  s: utf8string;
  //numbers1: array of integer;
begin
  i := 1;
  n := length(str);
  //k:=0;
  //setlength(numbers1, 10);
  while i <= n do
  begin
    if (str[i] >= '0') and (str[i] <= '9') then
    begin
      s := s + str[i];
    end
    else if (str[i] = ',') or (str[i] = #10) then
    begin
      //s[j] := #0;
      setlength(Result, length(Result) + 1);
      Result[length(Result) - 1] := StrToInt(s);
      //Inc(Result);
      s := '';
    end;
    Inc(i);
  end;
  if (s <> '') then
  begin
    setlength(Result, length(Result) + 1);
    Result[length(Result) - 1] := StrToInt(s);
  end;
end;

end.
