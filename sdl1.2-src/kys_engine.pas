unit kys_engine;

//{$MODE Delphi}

interface

uses
{$IFDEF fpc}
  LConvEncoding,
  LCLType,
  LCLIntf,
  FileUtil,
{$ENDIF}
{$IFDEF mswindows}
  Windows,
  //xVideo,
  avcodec,
  avformat,
  swscale,
  avutil,
{$ENDIF}
  SysUtils,
  SDL_TTF,
  SDL_image,
  SDL_gfx,
  SDL,
  kys_type,
  kys_main,
  glext,
  gl,
  Dialogs,
  bassmidi,
  bass,
  Math,
  unzip,
  ziputils;

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
procedure display_bmp(file_name: pchar; x, y: integer);
procedure display_img(file_name: pchar; x, y: integer; sur: PSDL_Surface = nil);
function ColColor(num: integer): uint32;
procedure DrawRectangle(sur: PSDL_Surface; x, y, w, h: integer; colorin, colorframe: uint32; alpha: integer);
procedure DrawRectangleWithoutFrame(sur: PSDL_Surface; x, y, w, h: integer; colorin: uint32; alpha: integer);

//画RLE8图片的子程
function JudgeInScreen(px, py, w, h, xs, ys: integer): boolean; overload;
function JudgeInScreen(px, py, w, h, xs, ys, xx, yy, xw, yh: integer): boolean; overload;
procedure DrawRLE8Pic(colorPanel: pchar; num, px, py: integer; Pidx: Pinteger; Ppic: PByte;
  RectArea: pchar; Image: PSDL_Surface; widthI, heightI, sizeI: integer; shadow: integer); overload;
procedure DrawRLE8Pic(colorPanel: pchar; num, px, py: integer; Pidx: Pinteger; Ppic: PByte;
  RectArea: pchar; Image: PSDL_Surface; widthI, heightI, sizeI: integer; shadow, alpha: integer); overload;
procedure DrawRLE8Pic(colorPanel: pchar; num, px, py: integer; Pidx: Pinteger; Ppic: PByte;
  RectArea: pchar; Image: PSDL_Surface; widthI, heightI, sizeI: integer; shadow, alpha: integer;
  BlockImageW: pchar; BlockPosition: pchar; widthW, heightW, sizeW: integer; depth: integer;
  mixColor: uint32; mixAlpha: integer); overload;
function GetPositionOnScreen(x, y, CenterX, CenterY: integer): TPosition;

//显示文字的子程
function Big5ToUnicode(str: pchar): WideString;
function GBKToUnicode(str: pchar): WideString;
function PCharToUnicode(str: pchar; len: integer = -1): WideString;
function UnicodeToBig5(str: pWideChar): string;
function UnicodeToGBK(str: pWideChar): string;
procedure DrawText(sur: PSDL_Surface; word: puint16; x_pos, y_pos: integer; color: uint32);
procedure DrawEngText(sur: PSDL_Surface; word: puint16; x_pos, y_pos: integer; color: uint32);
procedure DrawShadowText(word: puint16; x_pos, y_pos: integer; color1, color2: uint32;
  sur: PSDL_Surface = nil; realposition: integer = 0); overload;
procedure DrawEngShadowText(word: puint16; x_pos, y_pos: integer; color1, color2: uint32; sur: PSDL_Surface = nil);
procedure DrawBig5Text(sur: PSDL_Surface; str: pchar; x_pos, y_pos: integer; color: uint32);
procedure DrawBig5ShadowText(word: pchar; x_pos, y_pos: integer; color1, color2: uint32);
procedure DrawTextWithRect(word: puint16; x, y, w: integer; color1, color2: uint32;
  alpha: integer = 50; Refresh: integer = 1);
procedure DrawGBKShadowText(word: pchar; x_pos, y_pos: integer; color1, color2: uint32);
procedure DrawU16ShadowText(word: pchar; x_pos, y_pos: integer; color1, color2: uint32);

function Simplified2Traditional(mSimplified: ansistring): ansistring;
procedure DrawPartPic(pic: PSDL_Surface; x, y, w, h, x1, y1: integer);
function Traditional2Simplified(mTraditional: string): string;
procedure PlayBeginningMovie;
procedure ZoomPic(scr: PSDL_Surface; x, y, w, h: integer);
function GetPngPic(pic: pbyte; idx: pint; num: integer): PSDL_Surface;
function ReadPicFromByte(p_byte: Pbyte; size: integer): PSDL_Surface;

procedure glhrStretchSurface(sur: PSDL_Surface; mode: integer = 0);
procedure SDL_UpdateRect2(scr1: PSDL_Surface; x, y, w, h: integer);
procedure SoftStretchToTextScreen; overload;
procedure SoftStretchToTextScreen(x, y, w, h: integer); overload;
procedure SDL_GetMouseState2(var x, y: integer);
procedure ResizeWindow(w, h: integer);
procedure ResizeSimpleText(initial: integer = 0);
procedure SwitchFullscreen;
procedure QuitConfirm;
procedure CheckBasicEvent;

procedure ChangeCol;


//用于读取的子程
procedure ReadTiles;
procedure LoadAllPNGTileThread;
procedure LoadSPNGTileThread;
function ReadFileToBuffer(p: pchar; filename: string; size, malloc: integer): pchar;
procedure FreeFileBuffer(var p: pchar);
function LoadIdxGrp(stridx, strgrp: string; var idxarray: TIntArray; var grparray: TByteArray): integer;
function LoadPNGTiles(path: string; var PNGIndexArray: TPNGIndexArray; var SurfaceArray: TSurfaceArray;
  LoadPic: integer = 1): integer;
procedure LoadOnePNGTile(path: string; p: pchar; filenum: integer; var PNGIndex: TPNGIndex;
  SurfacePointer: PPSDL_Surface; forceLoad: integer = 0);
function LoadSurfaceFromFile(filename: string): PSDL_Surface;
function LoadSurfaceFromMem(p: pchar; len: integer): PSDL_Surface;
function LoadStringFromIMZMEM(path: string; p: pchar; num: integer): string;
function LoadStringFromZIP(zfilename, filename: string): string;
//function LoadSurfaceFromZIPFile(zipFile: unzFile; filename: string): PSDL_Surface;
procedure FreeAllSurface;

//PNG贴图相关的子程
procedure DrawPNGTile(PNGIndex: TPNGIndex; FrameNum: integer; RectArea: pchar; scr: PSDL_Surface;
  px, py: integer); overload;
procedure DrawPNGTile(PNGIndex: TPNGIndex; FrameNum: integer; RectArea: pchar; scr: PSDL_Surface;
  px, py: integer; shadow, alpha: integer; mixColor: uint32; mixAlpha: integer); overload;
procedure DrawPNGTile(PNGIndex: TPNGIndex; FrameNum: integer; RectArea: pchar; scr: PSDL_Surface;
  px, py: integer; shadow, alpha: integer; mixColor: uint32; mixAlpha: integer; depth: integer;
  BlockImgR: pchar; Width, Height, size, leftupx, leftupy: integer); overload;
procedure SetPNGTileBlock(PNGIndex: TPNGIndex; FrameNum, px, py, depth: integer; BlockImageW: pchar;
  Width, Height, size: integer);

function MixSurface(sur: PSDL_Surface; mixColor: uint32; mixAlpha: integer; method: integer = 0): PSDL_Surface;
function CopyIndexSurface(PNGIndexArray: TPNGIndexArray; i: integer): PSDL_Surface;

procedure BlitRGBA(srcsur: PSDL_Surface; psrcrect: PSDL_Rect; dstsur: PSDL_Surface; pdstrect: PSDL_Rect);

procedure PlayMovie(const filename: string; fullwindow: integer);

procedure Big5ToGBK(p: pchar);
procedure Big5ToU16(p: pchar);

function DrawLength(str: WideString): integer; overload;
function DrawLength(p: pWideChar): integer; overload;
function DrawLength(p: pchar): integer; overload;

implementation

uses
  kys_battle,
  kys_draw;

procedure InitialMusic;
var
  i: integer;
  str: string;
  sf: BASS_MIDI_FONT;
  Flag: longword;
begin
  BASS_Set3DFactors(1, 0, 0);
  sf.font := BASS_MIDI_FontInit(PChar(AppPath + 'music/mid.sf2'), 0);
  BASS_MIDI_StreamSetFonts(0, sf, 1);
  sf.preset := -1; // use all presets
  sf.bank := 0;
  Flag := 0;
  if SOUND3D = 1 then
    Flag := BASS_SAMPLE_3D or BASS_SAMPLE_MONO or Flag;

  for i := 0 to High(Music) do
  begin
    str := AppPath + 'music/' + IntToStr(i) + '.mp3';
    if FileExists(PChar(str)) then
    begin
      try
        Music[i] := BASS_StreamCreateFile(False, PChar(str), 0, 0, 0);
      finally

      end;
    end
    else
    begin
      str := AppPath + 'music/' + IntToStr(i) + '.mid';
      if FileExists(PChar(str)) then
      begin
        try
          Music[i] := BASS_MIDI_StreamCreateFile(False, PChar(str), 0, 0, 0, 0);
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
    if FileExists(PChar(str)) then
      ESound[i] := BASS_SampleLoad(False, PChar(str), 0, 0, 1, Flag)
    else
      ESound[i] := 0;
    //showmessage(inttostr(esound[i]));
  end;
  for i := 0 to High(Asound) do
  begin
    str := AppPath + formatfloat('sound/atk00', i) + '.wav';
    if FileExists(PChar(str)) then
      ASound[i] := BASS_SampleLoad(False, PChar(str), 0, 0, 1, Flag)
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
      3:
        if (SDL_BYTEORDER = SDL_BIG_ENDIAN) then
          Result := PByteArray(p)[0] shl 16 or PByteArray(p)[1] shl 8 or PByteArray(p)[2]
        else
          Result := PByteArray(p)[0] or PByteArray(p)[1] shl 8 or PByteArray(p)[2] shl 16;
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
      3:
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
        end;
      4:
        puint32(p)^ := pixel;
    end;
  end;
end;


//显示bmp文件

procedure display_bmp(file_name: pchar; x, y: integer);
var
  image: PSDL_Surface;
  dest: TSDL_Rect;
begin
  if FileExists(file_name) then
  begin
    image := SDL_LoadBMP(file_name);
    if (image = nil) then
    begin
      MessageBox(0, PChar(Format('Couldn''t load %s : %s', [file_name, SDL_GetError])), 'Error', MB_OK or MB_ICONHAND);
      exit;
    end;
    dest.x := x;
    dest.y := y;
    if (SDL_BlitSurface(image, nil, screen, @dest) < 0) then
      MessageBox(0, PChar(Format('BlitSurface error : %s', [SDL_GetError])), 'Error', MB_OK or MB_ICONHAND);
    //SDL_UpdateRect2(screen, 0, 0, image.w, image.h);
    SDL_FreeSurface(image);
  end;
end;

//显示tif, png, jpg等格式图片

procedure display_img(file_name: pchar; x, y: integer; sur: PSDL_Surface = nil);
var
  image: PSDL_Surface;
  dest: TSDL_Rect;
begin
  if sur = nil then
    sur := screen;
  if FileExists(file_name) then
  begin
    image := IMG_Load(file_name);
    if (image = nil) then
    begin
      MessageBox(0, PChar(Format('Couldn''t load %s : %s', [file_name, SDL_GetError])),
        'Error', MB_OK or MB_ICONHAND);
      exit;
    end;
    dest.x := x;
    dest.y := y;
    if (SDL_BlitSurface(image, nil, sur, @dest) < 0) then
      MessageBox(0, PChar(Format('BlitSurface error : %s', [SDL_GetError])), 'Error', MB_OK or MB_ICONHAND);
    //SDL_UpdateRect2(screen, 0, 0, image.w, image.h);
    SDL_FreeSurface(image);
  end;
end;

//取调色板的颜色, 视频系统是32位色, 但很多时候仍需要原调色板的颜色

function ColColor(num: integer): uint32;
begin
  ColColor := SDL_MapRGB(screen.format, Acol[num * 3] * 4, Acol[num * 3 + 1] * 4, Acol[num * 3 + 2] * 4);
end;

//判断像素是否在屏幕内

function JudgeInScreen(px, py, w, h, xs, ys: integer): boolean; overload;
begin
  Result := False;
  if (px - xs + w >= 0) and (px - xs < screen.w) and (py - ys + h >= 0) and (py - ys < screen.h) then
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
    Result.x := Result.x + offsetX;
    Result.y := Result.y + offsetY;
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
  len := MultiByteToWideChar(950, 0, PChar(str), -1, nil, 0);
  setlength(Result, len - 1);
  MultiByteToWideChar(950, 0, PChar(str), length(str), pWideChar(Result), len + 1);
{$ENDIF}
end;

function GBKToUnicode(str: pchar): WideString;
var
  len: integer;
begin
{$IFDEF fpc}
  Result := UTF8Decode(CP936ToUTF8(str));
{$ELSE}
  len := MultiByteToWideChar(950, 0, PChar(str), -1, nil, 0);
  setlength(Result, len - 1);
  MultiByteToWideChar(950, 0, PChar(str), length(str), pWideChar(Result), len + 1);
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
  WideCharToMultiByte(950, 0, pWideChar(str), -1, PChar(Result), len + 1, nil, nil);
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
  WideCharToMultiByte(936, 0, pWideChar(str), -1, PChar(Result), len + 1, nil, nil);
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
      $02000000, PChar(mTraditional), L, @Result[1], L);
{$ELSE}
  Result := mTraditional;
{$ENDIF}
end; {   Traditional2Simplified   }

//显示unicode文字

procedure DrawText(sur: PSDL_Surface; word: puint16; x_pos, y_pos: integer; color: uint32);
var
  dest, src: TSDL_Rect;
  tempcolor: TSDL_Color;
  len, i, k: integer;
  word0: array[0..2] of uint16 = (32, 0, 0);
  word1: ansistring;
  word2: WideString;
  p1: pbyte;
  p2: pbyte;
  t: WideString;
  Text: PSDL_Surface;
  r, g, b: byte;
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
  //if IsConsole then
  //writeln(widestring(word));
  SDL_GetRGB(color, sur.format, @r, @g, @b);
  tempcolor.r := r;
  tempcolor.g := g;
  tempcolor.b := b;
  tempcolor.unused := $ff;
  {if (Text_Layer = 1) and (GLHR = 1) then
  begin
    tempcolor.r := r * 8 div 10;
    tempcolor.g := g * 8 div 10;
    tempcolor.b := b * 8 div 10;
  end;}
  //pword[0] := $20;
  //pword[2] := 0;

  if SIMPLE = 1 then
  begin
    t := Traditional2Simplified(pWideChar(word));
    word := puint16(t);
  end;
  dest.x := x_pos;
  {src.x := CHNFONT_SPACEWIDTH;
  src.y := 0;
  src.w := CHINESE_FONT_SIZE;
  src.h := CHINESE_FONT_SIZE;}

  while word^ > 0 do
  begin
    word0[1] := word^;
    Inc(word);
    if word0[1] >= $1000 then
    begin
      Text := TTF_RenderUNICODE_blended(font, @word0[0], tempcolor);
      dest.x := x_pos - CHNFONT_SPACEWIDTH;
      dest.y := y_pos;
      //dest:=getrealrect(dest);
      SDL_BlitSurface(Text, nil, sur, @dest);
      SDL_FreeSurface(Text);
      x_pos := x_pos + CHINESE_FONT_SIZE;
    end
    else
    begin
      if word0[1] <> $20 then
      begin
        Text := TTF_RenderUNICODE_blended(engfont, @word0[1], tempcolor);
        //showmessage(inttostr(pword[1]));
        //dest.x := x_pos + CHINESE_FONT_SIZE div 2;
        dest.x := x_pos;
        dest.y := y_pos + 4;
        //src.x := 0;
        //src.w := CHINESE_FONT_SIZE div 2;
        //dest:=getrealrect(dest);
        SDL_BlitSurface(Text, nil, sur, @dest);
        SDL_FreeSurface(Text);
      end;
      x_pos := x_pos + CHINESE_FONT_SIZE div 2;
    end;
  end;
  HaveText := 1;
end;


//显示英文

procedure DrawEngText(sur: PSDL_Surface; word: puint16; x_pos, y_pos: integer; color: uint32);
var
  dest: TSDL_Rect;
  Text: PSDL_Surface;
  tempcolor: TSDL_Color;
  r, g, b: byte;
begin
  SDL_GetRGB(color, sur.format, @r, @g, @b);
  tempcolor.r := r;
  tempcolor.g := g;
  tempcolor.b := b;
  {if (Text_Layer = 1) and (GLHR = 1) then
  begin
    tempcolor.r := r * 8 div 10;
    tempcolor.g := g * 8 div 10;
    tempcolor.b := b * 8 div 10;
  end;}
  tempcolor.unused := $ff;
  Text := TTF_RenderUNICODE_blended(engfont, word, tempcolor);
  dest.x := x_pos;
  dest.y := y_pos;// + 4;
  //dest:=getrealrect(dest);
  SDL_BlitSurface(Text, nil, sur, @dest);
  SDL_FreeSurface(Text);
  //DrawText(sur,word, x_pos, y_pos, color);
  HaveText := 1;
end;


//显示unicode中文阴影文字, 即将同样内容显示2次, 间隔1像素
procedure DrawShadowText(word: puint16; x_pos, y_pos: integer; color1, color2: uint32;
  sur: PSDL_Surface = nil; realPosition: integer = 0); overload;
var
  w, h: integer;
begin
  if sur = nil then
    sur := screen;
  if (Text_Layer = 1) and (sur = screen) then
  begin
    sur := TextScreen;
  end;
  if realPosition = 0 then
    GetRealRect(x_pos, y_pos, w, h);
  DrawText(sur, word, x_pos + 1, y_pos, color2);
  DrawText(sur, word, x_pos, y_pos, color1);

end;

//显示英文阴影文字

procedure DrawEngShadowText(word: puint16; x_pos, y_pos: integer; color1, color2: uint32; sur: PSDL_Surface = nil);
var
  w, h: integer;
begin
  if sur = nil then
    sur := screen;
  if (Text_Layer = 1) and (sur = screen) then
  begin
    sur := TextScreen;
  end;
  y_pos := y_pos + 4;
  GetRealRect(x_pos, y_pos, w, h);
  DrawEngText(sur, word, x_pos + 1, y_pos, color2);
  DrawEngText(sur, word, x_pos, y_pos, color1);

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
  len := MultiByteToWideChar(950, 0, PChar(str), -1, nil, 0);
  setlength(words, len - 1);
  MultiByteToWideChar(950, 0, PChar(str), length(str), pWideChar(words), len + 1);
{$ENDIF}
  DrawText(screen, @words[1], x_pos, y_pos, color);

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
  len := MultiByteToWideChar(950, 0, PChar(word), -1, nil, 0);
  setlength(words, len - 1);
  MultiByteToWideChar(950, 0, PChar(word), length(word), pWideChar(words), len + 1);
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
  len := MultiByteToWideChar(950, 0, PChar(word), -1, nil, 0);
  setlength(words, len - 1);
  MultiByteToWideChar(950, 0, PChar(word), length(word), pWideChar(words), len + 1);
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
  DrawRectangle(screen, x, y, w, 26, 0, ColColor(255), alpha);
  DrawShadowText(word, x + 3, y + 2, color1, color2);
  if Refresh <> 0 then
    SDL_UpdateRect2(screen, x, y, w + 1, 29);

end;

//画带边框矩形, (x坐标, y坐标, 宽度, 高度, 内部颜色, 边框颜色, 透明度）

procedure DrawRectangle(sur: PSDL_Surface; x, y, w, h: integer; colorin, colorframe: uint32; alpha: integer);
var
  i1, i2, l1, l2, l3, l4, x1, y1, w1, h1: integer;
  tempscr, tempsur1: PSDL_Surface;
  dest: TSDL_Rect;
  r, g, b, r1, g1, b1, a: byte;
begin
  {if (SDL_MustLock(screen)) then
  begin
    SDL_LockSurface(screen);
  end;}
  w := abs(w);
  h := abs(h);

  tempscr := SDL_CreateRGBSurface(sur.flags or SDL_SRCALPHA, w + 1, h + 1, 32, RMask, GMask, BMask, AMask);
  SDL_GetRGB(colorin, tempscr.format, @r, @g, @b);
  SDL_GetRGB(colorframe, tempscr.format, @r1, @g1, @b1);
  SDL_FillRect(tempscr, nil, SDL_MapRGBA(tempscr.format, r, g, b, alpha * 255 div 100));
  //if Text_Layer = 1 then
  //SDL_SetAlpha(tempscr, 0, 255);

  dest.x := x;
  dest.y := y;
  dest.w := 0;
  dest.h := 0;

  x1 := 0;
  y1 := 0;
  tempsur1 := tempscr;
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
        PutPixel(tempsur1, i1 + x1, i2 + y1, 0);
      end;
      //框线
      if text_layer = 0 then
        if (((l1 >= 4) and (l2 >= 4) and (l3 >= 4) and (l4 >= 4) and ((i1 = 0) or (i1 = w) or
          (i2 = 0) or (i2 = h))) or ((l1 = 4) or (l2 = 4) or (l3 = 4) or (l4 = 4))) then
        begin
          //a := round(200 - min(abs(i1/w-0.5),abs(i2/h-0.5))*2 * 100);
          a := round(250 - abs(i1 / w + i2 / h - 1) * 150);
          //writeln(a);
          PutPixel(tempsur1, i1 + x1, i2 + y1, SDL_MapRGBA(tempscr.format, r1, g1, b1, a));
        end;
    end;

  SDL_BlitSurface(tempscr, nil, sur, @dest);
  SDL_FreeSurface(tempscr);

  if (Text_Layer = 1) and (sur = screen) then
  begin
    sur := TextScreen;
    GetRealRect(x, y, w, h);

    tempscr := SDL_CreateRGBSurface(sur.flags or SDL_SRCALPHA, w + 1, h + 1, 32, RMask, GMask, BMask, AMask);
    SDL_GetRGB(colorframe, tempscr.format, @r1, @g1, @b1);
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
          PutPixel(tempscr, i1 + x1, i2 + y1, SDL_MapRGBA(tempscr.format, r1, g1, b1, a));
        end;
      end;
    dest.x := x;
    dest.y := y;
    dest.w := 0;
    dest.h := 0;
    SDL_BlitSurface(tempscr, nil, sur, @dest);
    SDL_FreeSurface(tempscr);
  end;
  {if (SDL_MustLock(screen)) then
  begin
    SDL_UnlockSurface(screen);
  end;}

end;

//画不含边框的矩形, 用于对话和黑屏

procedure DrawRectangleWithoutFrame(sur: PSDL_Surface; x, y, w, h: integer; colorin: uint32; alpha: integer);
var
  tempscr, tempscr1: PSDL_Surface;
  dest: TSDL_Rect;
  i1, i2: integer;
  tran: byte;
  bigtran: uint32;
  r, g, b, a: byte;
begin
  {if (SDL_MustLock(screen)) then
  begin
    SDL_LockSurface(screen);
  end;}
  if (w > 0) and (h > 0) then
  begin
    if sur.flags and SDL_SRCALPHA = 0 then
    begin
      tempscr := SDL_CreateRGBSurface(sur.flags, w, h, 32, RMask, GMask, BMask, 0);
      SDL_FillRect(tempscr, nil, colorin);
      SDL_SetAlpha(tempscr, SDL_SRCALPHA, 255 - alpha * 255 div 100);
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
      $04000000, PChar(mSimplified), L, @Result[1], L);
  //writeln(L,mSimplified,',',result,GetUserDefaultLCID);
{$ELSE}
  Result := mSimplified;
{$ENDIF}
end; {   Simplified2Traditional   }


procedure DrawPartPic(pic: PSDL_Surface; x, y, w, h, x1, y1: integer);
var
  dest1, dest: TSDL_Rect;
begin
  dest1.x := x;
  dest1.y := y;
  dest1.w := w;
  dest1.h := h;
  dest.x := x1;
  dest.y := y1;
  SDL_BlitSurface(Pic, @dest1, screen, @dest);
end;


procedure ZoomPic(scr: PSDL_Surface; x, y, w, h: integer);
var
  a, b: double;
  dest, sest: TSDL_Rect;
  temp: PSDL_Surface;
begin
  a := w / scr.w;
  b := h / scr.h;
  dest.x := x;
  dest.y := y;
  dest.w := w;
  dest.h := h;
  temp := zoomSurface(scr, a, b, 0);
  SDL_BlitSurface(temp, nil, screen, @dest);
  SDL_FreeSurface(temp);
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
  SDL_ShowCursor(SDL_DISABLE);
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
        DrawRectangleWithoutFrame(screen, 0, 0, screen.w, screen.h, 0, 100 - (i * 5));
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
    DrawRectangleWithoutFrame(screen, 0, 0, screen.w, screen.h, 0, i * 5);
    SDL_Delay(20);
    SDL_UpdateRect2(screen, 0, 0, screen.w, screen.h);
    //Setlength(BGidx, 0);
  end;
  SDL_ShowCursor(SDL_ENABLE);
end;

function GetPngPic(pic: pbyte; idx: pint; num: integer): PSDL_Surface;
var
  beginidx, len: integer;
  idxtemp: pint;
begin
  if (num = 0) then
  begin
    beginidx := 0;
  end
  else
  begin
    Inc(idx, 4 + num);
    beginidx := idx^;
    Inc(idx, -4 - num);
  end;
  Inc(idx, 5 + num);
  len := idx^ - beginidx;
  Inc(pic, beginidx);
  Result := ReadPicFromByte(pic, len);
end;

function ReadPicFromByte(p_byte: Pbyte; size: integer): PSDL_Surface;
begin
  Result := IMG_Load_RW(SDL_RWFromMem(p_byte, size), 1);
end;

procedure glhrStretchSurface(sur: PSDL_Surface; mode: integer = 0);
var
  TextureID, TextureIDText: GLUint;
  xcoord, ycoord: real;
begin
  glGenTextures(1, @TextureID);
  glBindTexture(GL_TEXTURE_2D, TextureID);
  glTexImage2D(GL_TEXTURE_2D, 0, GL_RGB, sur.w, sur.h, 0, GL_BGRA, GL_UNSIGNED_BYTE, sur.pixels);

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
  if (KEEP_SCREEN_RATIO = 1) and (mode = 1) then
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
end;

procedure SDL_UpdateRect2(scr1: PSDL_Surface; x, y, w, h: integer);
var
  realx, realy, realw, realh, ZoomType, i1, i2: integer;
  tempscr: PSDL_Surface;
  now, Next: uint32;
  destsrc, dest: TSDL_Rect;
  r, g, b, r1, g1, b1: byte;
  scale: real;
begin
  dest.x := x;
  dest.y := y;
  dest.w := w;
  dest.h := h;
  if scr1 = screen then
    SDL_BlitSurface(screen, @dest, prescreen, @dest);

  if GLHR = 1 then
  begin
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
    glClear(GL_COLOR_BUFFER_BIT);
    glhrStretchSurface(prescreen, 1);
    if (Text_Layer = 1) and (HaveText = 1) then
    begin
      glEnable(GL_BLEND);
      glBlendFunc(GL_ONE_MINUS_DST_COLOR, GL_ONE);
      glhrStretchSurface(TextScreen);
      glDisable(GL_BLEND);
    end;
    SDL_GL_SwapBuffers;
  end
  else
  begin
    if ScreenBlendMode > 0 then
    begin
      case ScreenBlendMode of
        1:
        begin
          r1 := 5;
          g1 := 10;
          b1 := 25;
        end;
        2:
        begin
          r1 := 200;
          g1 := 152;
          b1 := 20;
        end;
      end;
      DrawRectangleWithoutFrame(prescreen, x, y, w, h, SDL_MapRGB(screen.format, r1, g1, b1), 50);
    end;
    if (RealScreen.w = screen.w) and (RealScreen.h = screen.h) then
    begin
      SDL_BlitSurface(prescreen, nil, RealScreen, nil);
    end
    else
    begin
      if KEEP_SCREEN_RATIO = 1 then
      begin
        scale := min(RealScreen.w / screen.w, RealScreen.h / screen.h);
        //tempscr := zoomSurface(prescreen, RealScreen.w / screen.w, RealScreen.h / screen.h, SMOOTH);
        tempscr := zoomSurface(prescreen, scale, scale, SMOOTH);
        dest.x := 0;
        dest.y := 0;
        dest.w := RealScreen.w;
        dest.h := RealScreen.h;
        dest := GetRealRect(dest, 1);
        SDL_BlitSurface(tempscr, nil, RealScreen, @dest);
      end
      else
      begin
        tempscr := zoomSurface(prescreen, RealScreen.w / screen.w, RealScreen.h / screen.h, SMOOTH);
        SDL_BlitSurface(tempscr, nil, RealScreen, nil);
      end;
      SDL_FreeSurface(tempscr);
    end;
    {if (Text_Layer = 1) and (HaveText = 1) then
    begin
      SDL_BlitSurface(TextScreen, nil, RealScreen, nil);
    end;}
    SDL_UpdateRect(RealScreen, 0, 0, RealScreen.w, RealScreen.h);
  end;

end;

procedure SoftStretchToTextScreen; overload;
var
  tempscr: PSDL_Surface;
  dest: TSDL_Rect;
  scale: real;
begin
  if (RealScreen.w = screen.w) and (RealScreen.h = screen.h) then
  begin
    SDL_BlitSurface(screen, nil, TextScreen, nil);
  end
  else
  begin
    scale := min(RealScreen.w / screen.w, RealScreen.h / screen.h);
    tempscr := zoomSurface(screen, scale, scale, SMOOTH);
    dest.x := 0;
    dest.y := 0;
    dest.w := RealScreen.w;
    dest.h := RealScreen.h;
    dest := GetRealRect(dest);
    SDL_BlitSurface(tempscr, nil, TextScreen, @dest);
    SDL_FreeSurface(tempscr);
  end;
end;

procedure SoftStretchToTextScreen(x, y, w, h: integer); overload;
var
  tempscr, tempscr2: PSDL_Surface;
  dest, dest2: TSDL_Rect;
  scale: real;
begin
  dest.x := x;
  dest.y := y;
  dest.w := w;
  dest.h := h;
  if (RealScreen.w = screen.w) and (RealScreen.h = screen.h) then
  begin
    SDL_BlitSurface(screen, @dest, TextScreen, @dest);
  end
  else
  begin
    dest2 := GetRealRect(dest);
    tempscr := SDL_CreateRGBSurface(ScreenFlag, dest.w, dest.h, 32, RMask, GMask, BMask, 0);
    SDL_BlitSurface(screen, @dest, tempscr, nil);
    scale := min(RealScreen.w / screen.w, RealScreen.h / screen.h);
    tempscr2 := zoomSurface(tempscr, scale, scale, SMOOTH);
    SDL_BlitSurface(tempscr2, nil, TextScreen, @dest2);
    SDL_FreeSurface(tempscr);
    SDL_FreeSurface(tempscr2);
  end;
end;

procedure SDL_GetMouseState2(var x, y: integer);
var
  tempx, tempy: integer;
  px, py: integer;
  scale: real;
begin
  SDL_GetMouseState(tempx, tempy);
  if KEEP_SCREEN_RATIO = 1 then
  begin
    px := 0;
    py := 0;
    scale := min(RealScreen.w / screen.w, RealScreen.h / screen.h);
    if RealScreen.w / screen.w > RealScreen.h / screen.h then
    begin
      px := (RealScreen.w - round(screen.w * scale)) div 2;
    end
    else
    begin
      py := (RealScreen.h - round(screen.h * scale)) div 2;
    end;
    x := round((tempx - px) / scale);
    y := round((tempy - py) / scale);
  end
  else
  begin
    x := round(tempx / RealScreen.w * screen.w);
    y := round(tempy / RealScreen.h * screen.h);
  end;
end;

procedure ResizeWindow(w, h: integer);
var
  scale: real;
  i, x, y, w1, h1: integer;
begin
  //scale := min(w / screen.w, h/ screen.h);
  RealScreen := SDL_SetVideoMode(w, h, 32, ScreenFlag);
  event.type_ := 0;

  if (Text_Layer = 1) then
  begin
    SDL_FreeSurface(TextScreen);
    TextScreen := SDL_CreateRGBSurface(ScreenFlag or SDL_SRCALPHA, w, h, 32, RMask, GMask, BMask, AMASK);
    ResizeSimpleText;
    //SDL_SetAlpha(TextScreen, 0, 0);
    //SDL_SetColorKey(TextScreen,SDL_SRCCOLORKEY, 0);
    ResetFontSize;
  end;


  //ScreenScale := min(RealScreen.w / screen.w, RealScreen.h / screen.h);
  SDL_UpdateRect2(screen, 0, 0, screen.w, screen.h);

end;

procedure ResizeSimpleText(initial: integer = 0);
var
  i, x, y, w1, h1: integer;
begin
  if Text_Layer = 1 then
  begin
    x := 0;
    y := 0;
    w1 := 270;
    h1 := 90;
    GetRealRect(x, y, w1, h1);
    for i := 0 to 5 do
    begin
      if initial = 0 then
        SDL_FreeSurface(SimpleText[i]);
      SimpleText[i] := SDL_CreateRGBSurface(ScreenFlag or SDL_SRCALPHA, w1 + x, y + h1, 32,
        RMask, GMask, BMask, AMASK);
      SDL_FillRect(SimpleText[i], nil, 0);
      SDL_SetColorKey(SimpleText[i], SDL_SRCCOLORKEY, 0);
      SDL_SetAlpha(SimpleText[i], 0, 255);
    end;
  end;
end;

procedure SwitchFullscreen;
begin
  FULLSCREEN := 1 - FULLSCREEN;
  if FULLSCREEN = 0 then
  begin
    RealScreen := SDL_SetVideoMode(RESOLUTIONX, RESOLUTIONY, 32, ScreenFlag);
  end
  else
  begin
    RealScreen := SDL_SetVideoMode(CENTER_X * 2, CENTER_Y * 2, 32, ScreenFlag or SDL_FULLSCREEN);
  end;

end;

procedure QuitConfirm;
var
  tempscr, freshscr1: PSDL_Surface;
  menuString: array[0..1] of WideString;
  info: TSDL_SysWMinfo;
begin
  NeedRefreshScence := 0;
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
    tempscr := SDL_ConvertSurface(prescreen, screen.format, screen.flags);
    SDL_BlitSurface(tempscr, nil, screen, nil);
    DrawRectangleWithoutFrame(screen, 0, 0, screen.w, screen.h, 0, 50);
    SDL_UpdateRect2(screen, 0, 0, screen.w, screen.h);
    menuString[0] := '取消';
    menuString[1] := '確認';
    if CommonMenu(CENTER_X * 2 - 50, 2, 45, 1, 0, menuString) = 1 then
      Quit;
    Redraw;
    SDL_BlitSurface(tempscr, nil, screen, nil);
    SDL_UpdateRect2(screen, 0, 0, screen.w, screen.h);
    SDL_FreeSurface(tempscr);
    AskingQuit := False;
  end;
  NeedRefreshScence := 1;
end;

procedure CheckBasicEvent;
var
  i: integer;
begin
  if not ((LoadingTiles) or (LoadingScence)) then
    case event.type_ of
      SDL_QUITEV:
        QuitConfirm;
      SDL_VIDEORESIZE:
        ResizeWindow(event.resize.w, event.resize.h);
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

//RLE8图片绘制子程, 所有相关子程均对此封装. 最后一个参数为亮度, 仅在绘制战场选择对方时使用

procedure DrawRLE8Pic(colorPanel: pchar; num, px, py: integer; Pidx: Pinteger; Ppic: PByte;
  RectArea: pchar; Image: PSDL_Surface; widthI, heightI, sizeI: integer; shadow: integer); overload;
begin
  DrawRLE8Pic(colorPanel, num, px, py, Pidx, Ppic, RectArea, Image, widthI, heightI, sizeI, Shadow, 0);

end;

//增加透明度选项

procedure DrawRLE8Pic(colorPanel: pchar; num, px, py: integer; Pidx: Pinteger; Ppic: PByte;
  RectArea: pchar; Image: PSDL_Surface; widthI, heightI, sizeI: integer; shadow, alpha: integer); overload;
begin
  DrawRLE8Pic(colorPanel, num, px, py, Pidx, Ppic, RectArea, Image, widthI, heightI, sizeI,
    Shadow, alpha, nil, nil, 0, 0, 0, 0, 0, 0);

end;

//这是改写的绘制RLE8图片程序, 增加了选调色板, 遮挡控制, 亮度, 半透明, 混合色等
//colorPanel: Pchar; 调色板的指针. 某些情况下需要使用静态调色板, 避免静态图跟随水的效果
//num, px, py: integer; 图片的编号和位置
//Pidx: Pinteger; Ppic: PByte; 图片的索引和内容的资源所在地
//RectArea: Pchar; 画图的范围; 所指向地址应为连续4个integer, 表示一个矩形, 仅图片的部分或全部会出现在这个矩形内才画
//Image: PChar; widthI, heightI, sizeI: integer; 映像及其尺寸, 每单位长度（无用） 如果Img不为空则会将图画到这个镜像, 否则画到屏幕
//shadow, alpha: integer; 图片的暗度和透明度, 仅在画到屏幕上时有效
//BlockImageW: PChar; 大小与场景和战场映像相同. 如果此地址不为空则会记录该像素的场景深度depth, 用于遮挡计算.
//BlockScreenR: PChar; widthR, heightR, sizeR: integer; 该映像应该与屏幕像素数相同, 保存屏幕上每一点的深度
//depth: integer; 所画物件的绘图优先级
//当BlockImageW不为空时, 将该值写入BlockImageW
//但是需注意计算值在场景内包含高度的情况下是不准确的.
//当Image为空, 即画到屏幕上, 同时BlockPosition不为空时, 如果所绘像素的已有深度大于该深度, 则按照alpha绘制该像素
//即该值起作用的机会有两种: Image不为空到映像, 且BlockImageW不为空. 或者Image为空(到屏幕), 且BlockPosition不为空
//如果在画到屏幕时避免该值起作用, 可以设为一个很大的值
//MixColor: Uint32; MixAlpha: integer 图片的混合颜色和混合度, 仅在画到屏幕上时有效

procedure DrawRLE8Pic(colorPanel: pchar; num, px, py: integer; Pidx: Pinteger; Ppic: PByte;
  RectArea: pchar; Image: PSDL_Surface; widthI, heightI, sizeI: integer; shadow, alpha: integer;
  BlockImageW: pchar; BlockPosition: pchar; widthW, heightW, sizeW: integer; depth: integer;
  mixColor: uint32; mixAlpha: integer); overload;
var
  w, h, xs, ys, x, y, blockx, blocky: smallint;
  offset, length, p, isAlpha, lenInt: integer;
  l, l1, ix, iy, pixdepth, curdepth, alpha1: integer;
  pix, colorin: uint32;
  pix1, pix2, pix3, pix4, color1, color2, color3, color4: byte;
  area: TSDL_Rect;
begin
  if num = 0 then
    offset := 0
  else
  begin
    Inc(Pidx, num - 1);
    offset := Pidx^;
  end;

  Inc(Ppic, offset);
  w := Psmallint((Ppic))^;
  Inc(Ppic, 2);
  h := Psmallint((Ppic))^;
  Inc(Ppic, 2);
  xs := Psmallint((Ppic))^;
  Inc(Ppic, 2);
  ys := Psmallint((Ppic))^;
  Inc(Ppic, 2);
  pixdepth := 0;
  //if (num >= 1916) and (num <= 1941) then h := h - 50;
  if Image = nil then
    Image := screen;

  if RectArea <> nil then
  begin
    area := PSDL_Rect(RectArea)^;
  end
  else
  begin
    area.x := 0;
    area.y := 0;
    area.w := Image.w;
    area.h := Image.h;
  end;
  if (BlockPosition <> nil) then
  begin
    blockx := pint(BlockPosition)^;
    blocky := pint(BlockPosition + 4)^;
  end;
  alpha1 := (alpha shr 8) and $FF;
  if ((w > 1) or (h > 1)) and (px - xs + w >= area.x) and (px - xs < area.x + area.w) and
    (py - ys + h >= area.y) and (py - ys < area.y + area.h) then
  begin
    for iy := 1 to h do
    begin
      l := Ppic^;
      Inc(Ppic, 1);
      w := 1;
      p := 0;
      for ix := 1 to l do
      begin
        l1 := Ppic^;
        Inc(Ppic);
        if p = 0 then
        begin
          w := w + l1;
          p := 1;
        end
        else if p = 1 then
        begin
          p := 2 + l1;
        end
        else if p > 2 then
        begin
          p := p - 1;
          x := w - xs + px;
          y := iy - ys + py;
          if (x >= area.x) and (y >= area.y) and (x < area.x + area.w) and (y < area.y + area.h) then
          begin
            pix1 := puint8(colorPanel + l1 * 3)^ * (4 + shadow);
            pix2 := puint8(colorPanel + l1 * 3 + 1)^ * (4 + shadow);
            pix3 := puint8(colorPanel + l1 * 3 + 2)^ * (4 + shadow);
            pix4 := 0;
            //pix := sdl_maprgba(screen.format, pix1, pix2, pix3, pix4);
            if image = screen then
            begin
              if mixAlpha <> 0 then
              begin
                SDL_GetRGBA(mixColor, screen.format, @color1, @color2, @color3, @color4);
                pix1 := (mixAlpha * color1 + (100 - mixAlpha) * pix1) div 100;
                pix2 := (mixAlpha * color2 + (100 - mixAlpha) * pix2) div 100;
                pix3 := (mixAlpha * color3 + (100 - mixAlpha) * pix3) div 100;
                pix4 := (mixAlpha * color4 + (100 - mixAlpha) * pix4) div 100;
                //pix := pix1 + pix2 shl 8 + pix3 shl 16 + pix4 shl 24;
              end;
              if (alpha <> 0) then
              begin
                if (BlockImageW = nil) then
                begin
                  isAlpha := 1;
                end
                else
                begin
                  //以下表示需要遮挡
                  //被遮挡的像素按照低位计算, 未被遮挡的按照高位计算
                  if (x < blockx + screen.w) and (y < blocky + screen.h) then
                  begin
                    pixdepth := Psmallint(BlockImageW + ((x + blockx) * heightW + y + blocky) * sizeW)^;
                    curdepth := depth;
                    //if where = 1 then
                    //curdepth := depth - (w - xs - 1) div 18;
                    //处理过宽的图片, 仅画图时使用, 事实上该遮挡值只用来画主角, 起作用的唯一机会是拔金蛇剑时
                    if pixdepth >= curdepth then
                    begin
                      isAlpha := 1;
                    end
                    else
                      isAlpha := 0;
                  end;
                end;
                if (isAlpha = 1) and (Alpha < 100) then
                begin
                  colorin := GetPixel(screen, x, y);
                  SDL_GetRGBA(colorin, screen.format, @color1, @color2, @color3, @color4);
                  //pix1 := pix and $FF;
                  //color1 := colorin and $FF;
                  //pix2 := pix shr 8 and $FF;
                  //color2 := colorin shr 8 and $FF;
                  //pix3 := pix shr 16 and $FF;
                  //color3 := colorin shr 16 and $FF;
                  //pix4 := pix shr 24 and $FF;
                  //color4 := colorin shr 24 and $FF;
                  pix1 := (alpha * color1 + (100 - alpha) * pix1) div 100;
                  pix2 := (alpha * color2 + (100 - alpha) * pix2) div 100;
                  pix3 := (alpha * color3 + (100 - alpha) * pix3) div 100;
                  pix4 := (alpha * color4 + (100 - alpha) * pix4) div 100;
                  //pix := pix1 + pix2 shl 8 + pix3 shl 16 + pix4 shl 24;
                end;
                if (isAlpha = 0) and (alpha1 > 0) and (Alpha1 <= 100) then
                begin
                  colorin := GetPixel(screen, x, y);
                  SDL_GetRGBA(colorin, screen.format, @color1, @color2, @color3, @color4);
                  //pix1 := pix and $FF;
                  //color1 := colorin and $FF;
                  //pix2 := pix shr 8 and $FF;
                  //color2 := colorin shr 8 and $FF;
                  //pix3 := pix shr 16 and $FF;
                  //color3 := colorin shr 16 and $FF;
                  //pix4 := pix shr 24 and $FF;
                  //color4 := colorin shr 24 and $FF;
                  pix1 := (alpha1 * color1 + (100 - alpha1) * pix1) div 100;
                  pix2 := (alpha1 * color2 + (100 - alpha1) * pix2) div 100;
                  pix3 := (alpha1 * color3 + (100 - alpha1) * pix3) div 100;
                  pix4 := (alpha1 * color4 + (100 - alpha1) * pix4) div 100;
                  //pix := pix1 + pix2 shl 8 + pix3 shl 16 + pix4 shl 24;
                end;
              end;
              pix := SDL_MapRGBA(screen.format, pix1, pix2, pix3, pix4);
              if (Alpha < 100) or (pixdepth <= curdepth) then
                PutPixel(screen, x, y, pix);
            end
            else
            begin
              if (x < widthI) and (y < heightI) then
              begin
                if (BlockImageW <> nil) then
                begin
                  //if (depth < 0) then
                  //depth := (py div 9 - 1);
                  Psmallint(BlockImageW + (x * heightI + y) * sizeI)^ := depth;
                end;
                pix := SDL_MapRGBA(screen.format, pix1, pix2, pix3, pix4);
                PutPixel(Image, x, y, pix);
              end;
            end;
          end;
          w := w + 1;
          if p = 2 then
          begin
            p := 0;
          end;
        end;
      end;
    end;
  end;
end;

//读取贴图

procedure ReadTiles;
var
  i: integer;
  LoadThread, LoadThreadS: PSDL_Thread;
begin
  if PNG_TILE = 0 then
  begin
    if IsConsole then
      writeln('Reading idx and grp files...');
    MPicAmount := LoadIdxGrp('resource/mmap.idx', 'resource/mmap.grp', MIdx, MPic);
    SPicAmount := LoadIdxGrp('resource/sdx', 'resource/smp', SIdx, SPic);
    //BPicAmount := LoadIdxGrp('resource/wdx', 'resource/wmp', WIdx, WPic);
    EPicAmount[0] := LoadIdxGrp('resource/eft.idx', 'resource/eft.grp', EIdx, EPic);
    //LoadIdxGrp('resource/hdgrp.idx', 'resource/hdgrp.grp', HIdx, HPic);
    CPicAmount := LoadIdxGrp('resource/cloud.idx', 'resource/cloud.grp', CIdx, CPic);
    if IsConsole then
      writeln(MPicAmount, ' ', SPicAmount, ' ', {BPicAmount, ' ',} CPicAmount);
  end;

  LoadIdxGrp('resource/hdgrp.idx', 'resource/hdgrp.grp', HIdx, HPic);

  //PNG_LOAD_ALL:=1;
  if PNG_TILE > 0 then
  begin
    MPicAmount := LoadPNGTiles('resource/mmap', MPNGIndex, MPNGTile, PNG_LOAD_ALL);
    SPicAmount := LoadPNGTiles('resource/smap', SPNGIndex, SPNGTile, PNG_LOAD_ALL);
    //BPicAmount := LoadPNGTiles('resource/wmap', BPNGIndex, BPNGTile, PNG_LOAD_ALL);
    HPicAmount := LoadPNGTiles('resource/head', HPNGIndex, HPNGTile, PNG_LOAD_ALL);
    CPicAmount := LoadPNGTiles('resource/cloud', CPNGIndex, CPNGTile, 1);
    IPicAmount := LoadPNGTiles('resource/item', IPNGIndex, IPNGTile, 1);
    for i := 0 to High(EPicLoaded) do
    begin
      EPicLoaded[i] := 0;
    end;
  end;

  if BIG_PNG_TILE > 0 then
  begin
    {MMapSurface :=  LoadSurfaceFromFile(AppPath + 'resource/bigpng/mmap.png');
    if MMapSurface <> nil then
      writeln('Main map loaded.');}
  end;

  pMPic := nil;
  pSPic := nil;
  //pBPic := nil;
  //pEPic := nil;
  pHPic := nil;
  pEvent := nil;

  if (PNG_TILE = 2) and (PNG_LOAD_ALL = 0) then
  begin
    pMPic := ReadFileToBuffer(nil, AppPath + 'resource/mmap.imz', -1, 1);
    pSPic := ReadFileToBuffer(nil, AppPath + 'resource/smap.imz', -1, 1);
    //pBPic := ReadFileToBuffer(nil, AppPath + 'resource/wmap.imz', -1, 1);
    //pEPic := ReadFileToBuffer(nil, AppPath + 'resource/eft.imz', -1, 1);
    pHPic := ReadFileToBuffer(nil, AppPath + 'resource/head.imz', -1, 1);
  end;

  //部分最常用的贴图
  if (PNG_TILE > 0) and (PNG_LOAD_ALL = 0) then
  begin
    for i := 2001 to MPicAmount - 1 do
    begin
      LoadOnePNGTile('resource/mmap', pMPic, i, MPNGIndex[i], @MPNGTile[0]);
    end;
  end;

  {for i := 0 to HPicAmount - 1 do
  begin
    if fileexists(AppPath + 'resource/head/' + inttostr(i) + '.png') then
    begin
      LoadOnePNGTile('resource/head', nil, i, HPNGIndex[i], @HPNGTile[0]);
      if IsConsole then
        writeln('Custom head pic ', inttostr(i), ' has been loaded.');
    end;
  end;}

  //PNG_LOAD_ALL为2, 用另一线程载入贴图
  if PNG_LOAD_ALL = 2 then
  begin
    LoadThread := SDL_CreateThread(@LoadAllPNGTileThread, nil);
    //LoadThreadS := SDL_CreateThread(@LoadSPNGTileThread, nil);
  end
  else
    LoadingTiles := False;
  ReadingTiles := False;
end;

procedure LoadAllPNGTileThread;
var
  i: integer;
begin
  SDL_LockMutex(mutex);
  LoadingTiles := True;
  for i := 0 to MPicAmount - 1 do
    LoadOnePNGTile('resource/mmap', nil, i, MPNGIndex[i], @MPNGTile[0]);
  for i := 0 to SPicAmount - 1 do
    LoadOnePNGTile('resource/smap', nil, i, SPNGIndex[i], @SPNGTile[0]);
  //for i := 0 to BPicAmount - 1 do
  //LoadOnePNGTile('resource/wmap', nil, i, BPNGIndex[i], @BPNGTile[0]);
  //for i := 0 to EPicAmount - 1 do
  //LoadOnePNGTile('resource/eft', nil, i, EPNGIndex[i], @EPNGTile[0]);
  SDL_UnLockMutex(mutex);
  //LoadingTiles := False;
end;

procedure LoadSPNGTileThread;
var
  i: integer;
begin
  //SDL_LockMutex(mutex);
  //for i := 0 to MPicAmount -1 do
  //LoadOnePNGTile('resource/mmap', nil, i, MPNGIndex[i], @MPNGTile[0]);
  for i := 0 to SPicAmount - 1 do
    LoadOnePNGTile('resource/smap', nil, i, SPNGIndex[i], @SPNGTile[0]);
  //for i := 0 to BPicAmount -1 do
  //LoadOnePNGTile('resource/wmap', nil, i, BPNGIndex[i], @BPNGTile[0]);
  //for i := 0 to EPicAmount -1 do
  //LoadOnePNGTile('resource/eft', nil, i, EPNGIndex[i], @EPNGTile[0]);
  //SDL_UnLockMutex(mutex);
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

function LoadPNGTiles(path: string; var PNGIndexArray: TPNGIndexArray; var SurfaceArray: TSurfaceArray;
  LoadPic: integer = 1): integer;
const
  maxCount: integer = 9999;
var
  i, j, k, state, size, Count, pngoff: integer;
  //zipFile: unzFile;
  //info: unz_file_info;
  offset: array of smallint;
  p: pchar;
begin
  //载入偏移值文件, 计算贴图的最大数量
  size := 0;
  Result := 0;
  p := nil;

  if PNG_TILE = 2 then
  begin
    if IsConsole then
      writeln('Searching imz file... ', path);
    p := ReadFileToBuffer(nil, AppPath + path + '.imz', -1, 1);
    if p <> nil then
    begin
      Result := min(maxCount, pint(p)^);
      //最大的有帧数的数量作为贴图的最大编号
      for i := Result - 1 downto 0 do
      begin
        if pint(p + pint(p + 4 + i * 4)^ + 4)^ > 0 then
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
        pngoff := pint(p + 4 + i * 4)^;
        with PNGIndexArray[i] do
        begin
          Num := Count;
          x := psmallint(p + pngoff)^;
          y := psmallint(p + pngoff + 2)^;
          Frame := pint(p + pngoff + 4)^;
          Count := Count + frame;
          CurPointer := nil;
          Loaded := 0;
        end;
      end;
    end
    else
    if IsConsole then
      writeln('Can''t find imz file.');
  end;


  if (PNG_TILE = 1) or (p = nil) then
  begin
    if IsConsole then
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
        Num := -1;
        Frame := 0;
        CurPointer := nil;
        if FileExists(AppPath + path + IntToStr(i) + '.png') then
        begin
          Num := Count;
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
              Num := Count;
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

  if IsConsole then
    writeln(Result, ' index, ', Count, ' real tiles.');

  setlength(SurfaceArray, Count);
  for i := 0 to Count - 1 do
    SurfaceArray[i] := nil;

  if LoadPic = 1 then
  begin
    if IsConsole then
      writeln('Now loading...');
    for i := 0 to Result - 1 do
    begin
      LoadOnePNGTile(path, p, i, PNGIndexArray[i], @SurfaceArray[0], 1);
    end;
  end;
  FreeFileBuffer(p);

end;

//这个函数没有容错处理, 在独立文件和打包文件都不存在时会引起游戏崩溃, 需要特别注意!
//p如果为nil, 则试图读取文件
procedure LoadOnePNGTile(path: string; p: pchar; filenum: integer; var PNGIndex: TPNGIndex;
  SurfacePointer: PPSDL_Surface; forceLoad: integer = 0);
var
  j, k, index, len, off: integer;
  tempscr: PSDL_Surface;
  frommem: boolean;
begin
  SDL_PollEvent(@event);
  CheckBasicEvent;

  frommem := ((PNG_TILE = 2) and (p <> nil));
  if not frommem then
    path := path + '/';
  with PNGIndex do
  begin
    if ((Loaded = 0) or (forceLoad = 1)) and (Num >= 0) and (Frame > 0) then
    begin
      Loaded := 1;
      Inc(SurfacePointer, Num);
      CurPointer := SurfacePointer;
      if Frame = 1 then
      begin
        if frommem then
        begin
          off := pint(p + 4 + filenum * 4)^ + 8;
          index := pint(p + off)^;
          len := pint(p + off + 4)^;
          SurfacePointer^ := LoadSurfaceFromMem(p + index, len);
        end
        else
        begin
          SurfacePointer^ := LoadSurfaceFromFile(AppPath + path + IntToStr(filenum) + '.png');
          if SurfacePointer^ = nil then
            SurfacePointer^ := LoadSurfaceFromFile(AppPath + path + IntToStr(filenum) + '_0.png');
        end;
      end;
      if Frame > 1 then
      begin
        for j := 0 to Frame - 1 do
        begin
          if frommem then
          begin
            off := pint(p + 4 + filenum * 4)^ + 8;
            index := pint(p + off + j * 8)^;
            len := pint(p + off + j * 8 + 4)^;
            SurfacePointer^ := LoadSurfaceFromMem(p + index, len);
          end
          else
            SurfacePointer^ := LoadSurfaceFromFile(AppPath + path + IntToStr(filenum) + '_' + IntToStr(j) + '.png');
          Inc(SurfacePointer, 1);
        end;
      end;
    end;
  end;

end;

//从文件载入表面

function LoadSurfaceFromFile(filename: string): PSDL_Surface;
var
  tempscr: PSDL_Surface;
begin
  Result := nil;
  if fileexistsUTF8(filename) then
  begin
    tempscr := IMG_Load(PChar(filename));
    Result := SDL_DisplayFormatAlpha(tempscr);
    SDL_FreeSurface(tempscr);
    //writeln(filename);
  end;
end;

//从内存载入表面
function LoadSurfaceFromMem(p: pchar; len: integer): PSDL_Surface;
var
  tempscr: PSDL_Surface;
  tempRWops: PSDL_RWops;
begin
  Result := nil;
  tempRWops := SDL_RWFromMem(p, len);
  tempscr := IMG_LoadPNG_RW(tempRWops);
  Result := SDL_DisplayFormatAlpha(tempscr);
  SDL_FreeSurface(tempscr);
  SDL_FreeRW(tempRWops);

end;

function LoadStringFromIMZMEM(path: string; p: pchar; num: integer): string;
var
  index, len, off: integer;
begin
  off := pint(p + 4 + num * 4)^ + 8;
  index := pint(p + off)^;
  len := pint(p + off + 4)^;
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
  zfile := unzOpen(PChar(zfilename));
  if (zfile <> nil) then
  begin
    if (unzLocateFile(zfile, PChar(filename), 2) = UNZ_OK) then
    begin
      unzLocateFile(zfile, PChar(filename), 2);
      unzOpenCurrentFile(zfile);
      unzGetCurrentFileInfo(zfile, @file_info, nil, 0, nil, 0, nil, 0);
      len := file_info.uncompressed_size;
      setlength(Result, len);
      unzReadCurrentFile(zfile, PChar(Result), len);
      unzCloseCurrentFile(zfile);
    end;

    unzClose(zfile);
  end;
end;

procedure FreeAllSurface;
var
  i: integer;

  procedure FreeSurfaceArray(SurfaceArray: TSurfaceArray);
  var
    i: integer;
  begin
    for i := 0 to high(SurfaceArray) do
      if SurfaceArray[i] <> nil then
        SDL_FreeSurface(SurfaceArray[i]);
  end;

begin
  FreeSurfaceArray(MPNGTile);
  FreeSurfaceArray(SPNGTile);
  //FreeSurfaceArray(BPNGTile);
  //FreeSurfaceArray(EPNGTile);
  FreeSurfaceArray(CPNGTile);
  FreeSurfaceArray(TitlePNGTile);
  for i := 0 to high(FPNGTile) do
    FreeSurfaceArray(FPNGTile[i]);
  for i := 0 to high(EPNGTile) do
    FreeSurfaceArray(EPNGTile[i]);

  FreeSurfaceArray(freshscreen);

  SDL_FreeSurface(screen);
  SDL_FreeSurface(prescreen);
  //SDL_FreeSurface(freshscreen);
  SDL_FreeSurface(ImgScence);
  SDL_FreeSurface(ImgScenceBack);
  SDL_FreeSurface(ImgBField);
  SDL_FreeSurface(ImgBBuild);

  for i := 0 to 5 do
    SDL_FreeSurface(SimpleStatus[i]);
  if Text_Layer = 1 then
  begin
    SDL_FreeSurface(TextScreen);
    for i := 0 to 5 do
      SDL_FreeSurface(SimpleText[i]);
  end;
  FreeFileBuffer(pMPic);
  FreeFileBuffer(pSPic);
  //FreeFileBuffer(pBPic);
  FreeFileBuffer(pEPic);
  FreeFileBuffer(pHPic);

end;


procedure DrawPNGTile(PNGIndex: TPNGIndex; FrameNum: integer; RectArea: pchar; scr: PSDL_Surface;
  px, py: integer); overload;
begin
  DrawPNGTile(PNGIndex, FrameNum, RectArea, scr, px, py, 0, 0, 0, 0);
end;

procedure DrawPNGTile(PNGIndex: TPNGIndex; FrameNum: integer; RectArea: pchar; scr: PSDL_Surface;
  px, py: integer; shadow, alpha: integer; mixColor: uint32; mixAlpha: integer); overload;
begin
  DrawPNGTile(PNGIndex, FrameNum, RectArea, scr, px, py, shadow, alpha, mixColor, mixAlpha, 0, nil, 0, 0, 0, 0, 0);

end;

//参数含义:
//PNGIndex: PNG的索引结构; FrameNum: 帧数, 会取最大帧数的余数;
//RectArea: 更新范围; scr: 目标表面;
//px, py: 目标位置; shadow, alpha: 亮度和透明度. shadow为了兼容RLE8的参数;
//MixColor, MixAlpha: 混合色和混合度;
//depth: 遮挡值; BlockImgR: 目标的遮挡数据;
//Width, Height, size, leftupx, leftupy: 目标遮挡数据的结构以及左上角的位置
procedure DrawPNGTile(PNGIndex: TPNGIndex; FrameNum: integer; RectArea: pchar; scr: PSDL_Surface;
  px, py: integer; shadow, alpha: integer; mixColor: uint32; mixAlpha: integer; depth: integer;
  BlockImgR: pchar; Width, Height, size, leftupx, leftupy: integer); overload;
var
  dest, area: TSDL_Rect;
  tempscr, tempscrfront, tempscrback, CurSurface: PSDL_Surface;
  pixdepth, i1, i2: integer;
  tran, tran2, r, g, b, a: byte;
  bigtran, bigtran2, pixel, Mask, AlphaValue: uint32;
  x1, x2, y1, y2: integer;
  lenint: integer;
begin
  with PNGIndex do
  begin
    if (CurPointer <> nil) and (Loaded = 1) and (Frame > 0) then
    begin
      if frame > 1 then
        Inc(CurPointer, FrameNum mod Frame);
      CurSurface := CurPointer^;
      //DrawSurface(CurSurface, RectArea, scr, px - x, py - y, shadow, alpha, mixColor, mixAlpha,
      //depth, BlockImgR, Width, Height, size, leftupx, leftupy);
      if CurSurface <> nil then
      begin
        if RectArea <> nil then
        begin
          area := PSDL_Rect(RectArea)^;
          x1 := area.x;
          y1 := area.y;
          x2 := x1 + area.w;
          y2 := y1 + area.h;
        end
        else
        begin
          x1 := 0;
          y1 := 0;
          x2 := scr.w;
          y2 := scr.h;
        end;
        dest.x := px - x;
        dest.y := py - y;
        dest.w := CurSurface.w;
        dest.h := CurSurface.h;
        if (dest.x + CurSurface.w >= x1) and (dest.y + CurSurface.h >= y1) and (dest.x < x2) and
          (dest.y < y2) then
        begin
          if shadow > 0 then
          begin
            //MixColor := $FFFFFFFF;
            mixColor := ($FFFFFFFF and not AMask) xor GetPixel(CurSurface, CurSurface.w div 2, CurSurface.h div 2);
            mixAlpha := shadow * 50;
          end
          else if shadow < 0 then
          begin
            mixColor := 0;
            mixAlpha := -shadow * 25;
          end;
          if (mixAlpha = 0) and (BlockImgR = nil) then
          begin
            if (alpha > 0) then
            begin
              alpha := alpha and $FF;
              //注意, 使用以下特殊算法, 是由图片格式决定
              //资源标准为带有透明通道的Surface, 因此总的Alpha和ColorKey值无效
              //将所画图片直接画入背景, 再将结果与背景混合
              tempscr := SDL_CreateRGBSurface(scr.flags, CurSurface.w, CurSurface.h, 32, RMask, GMask, BMask, 0);
              //tempscr := SDL_DisplayFormat(CurSurface);
              SDL_BlitSurface(scr, @dest, tempscr, nil);
              SDL_BlitSurface(CurSurface, nil, tempscr, nil);
              SDL_SetAlpha(tempscr, SDL_SRCALPHA, 255 - alpha * 255 div 100);
              SDL_BlitSurface(tempscr, nil, scr, @dest);
              SDL_FreeSurface(tempscr);
            end
            else
              SDL_BlitSurface(CurSurface, nil, scr, @dest);
          end
          else
          begin
            //tempscr := SDL_CreateRGBSurface(screen.flags or SDL_SRCALPHA, CurSurface.w, CurSurface.h, 32, RMask, GMask, BMask, AMask);
            tempscr := SDL_DisplayFormatAlpha(CurSurface);
            //SDL_BlitSurface(tempscr, nil, scr, @dest);
            if (mixAlpha > 0) then
            begin
              //writeln(mixalpha);
              //mixalpha := 100;
              //tran := MixAlpha * 255 div 100;
              //bigtran := tran * $01010101;
              //Mask := tempscr.format.AMask;
              //tempscrfront := SDL_CreateRGBSurface(scr.flags or SDL_SRCALPHA, CurSurface.w,
              //CurSurface.h, 32, RMask, GMask, BMask, AMask);
              //tempscrfront := SDL_DisplayFormatAlpha(CurSurface);
              //SDL_FillRect(tempscrfront, nil, (MixColor and (not Mask)) or (bigtran and Mask));
              tempscrfront := MixSurface(tempscr, mixColor, mixAlpha, 0);
              SDL_BlitSurface(tempscrfront, nil, tempscr, nil);
              if (BlockImgR = nil) then
              begin
                if alpha > 0 then
                begin
                  alpha := alpha and $FF;
                  tempscrback := SDL_CreateRGBSurface(scr.flags, CurSurface.w, CurSurface.h,
                    32, RMask, GMask, BMask, 0);
                  //tempscrback := SDL_DisplayFormat(CurSurface);
                  SDL_BlitSurface(scr, @dest, tempscrback, nil);
                  SDL_BlitSurface(tempscr, nil, tempscrback, nil);
                  SDL_SetAlpha(tempscrback, SDL_SRCALPHA, 255 - alpha * 255 div 100);
                  SDL_BlitSurface(tempscrback, nil, scr, @dest);
                  SDL_FreeSurface(tempscrback);
                end
                else
                begin
                  SDL_BlitSurface(tempscr, nil, scr, @dest);
                end;
              end
              else
              begin
                //SDL_BlitSurface(tempscrback, nil, scr, @dest);
                //SDL_BlitSurface(tempscrback, nil, tempscr, nil);
              end;
              SDL_FreeSurface(tempscrfront);
            end;
            if (BlockImgR <> nil) then
            begin
              //当需要遮挡透明时, alpha的高位为非遮挡所使用的透明度
              //tran2 := 255 - ((alpha shr 8) and $FF) * 255 div 100;
              //alpha := alpha and $FF;;
              //tran := 255 - alpha * 255 div 100;
              tran2 := (alpha shr 8) and $ff;
              tran := alpha and $ff;
              if tran2 > 0 then
              begin
                tran := 100 - (100 - tran) * tran2 div 100;
              end;
              //将透明通道的值写入所有位, 具体的位置由蒙板决定
              //bigtran := tran * $01010101;
              //bigtran2 := tran2 * $01010101;
              Mask := tempscr.format.AMask;
              for i1 := 0 to tempscr.w - 1 do
              begin
                for i2 := 0 to tempscr.h - 1 do
                begin
                  pixdepth := psmallint(BlockImgR + ((dest.x + leftupx + i1) * Height + dest.y +
                    leftupy + i2) * size)^;
                  pixel := GetPixel(tempscr, i1, i2);
                  //AlphaValue := pixel and Mask;
                  if pixel and Mask > 0 then
                  begin
                    SDL_GetRGBA(pixel, tempscr.format, @r, @g, @b, @a);
                    if (pixdepth > depth) then
                    begin
                      //替换透明通道的值
                      //注意: 这里如果效率较低, 则改用完全指针, 或者汇编编写. 设置偏移也相同
                      a := a * (100 - tran) div 100;
                      pixel := SDL_MapRGBA(tempscr.format, r, g, b, a);
                      PutPixel(tempscr, i1, i2, pixel);
                    end
                    else
                    begin
                      if tran2 > 0 then
                      begin
                        a := a * (100 - tran2) div 100;
                        pixel := SDL_MapRGBA(tempscr.format, r, g, b, a);
                        PutPixel(tempscr, i1, i2, pixel);
                      end;
                    end;
                  end;
                end;
              end;
              SDL_BlitSurface(tempscr, nil, scr, @dest);
            end;
            SDL_FreeSurface(tempscr);
          end;
        end;
      end;
    end;
  end;
end;

{procedure DrawSurface(CurSurface: PSDL_Surface; RectArea: pchar; scr: PSDL_Surface; px, py: integer;
  shadow, alpha: integer; mixColor: uint32; mixAlpha: integer; depth: integer; BlockImgR: pchar;
  Width, Height, size, leftupx, leftupy: integer);
var
  dest, area: TSDL_Rect;
  tempscr, tempscrfront, tempscrback: PSDL_Surface;
  pixdepth, i1, i2: integer;
  tran, tran2, r, g, b, a: byte;
  bigtran, bigtran2, pixel, Mask, AlphaValue: uint32;
  x1, x2, y1, y2: integer;
  lenint: integer;
begin
  if CurSurface <> nil then
  begin
    if RectArea <> nil then
    begin
      area := PSDL_Rect(RectArea)^;
      x1 := area.x;
      y1 := area.y;
      x2 := x1 + area.w;
      y2 := y1 + area.h;
    end
    else
    begin
      x1 := 0;
      y1 := 0;
      x2 := scr.w;
      y2 := scr.h;
    end;
    dest.x := px;
    dest.y := py;
    dest.w := CurSurface.w;
    dest.h := CurSurface.h;
    if (dest.x + CurSurface.w >= x1) and (dest.y + CurSurface.h >= y1) and (dest.x < x2) and
      (dest.y < y2) then
    begin
      if shadow > 0 then
      begin
        //MixColor := $FFFFFFFF;
        mixColor := ($FFFFFFFF and not AMask) xor GetPixel(CurSurface, CurSurface.w div 2, CurSurface.h div 2);
        mixAlpha := shadow * 50;
      end
      else if shadow < 0 then
      begin
        mixColor := 0;
        mixAlpha := -shadow * 25;
      end;
      if (mixAlpha = 0) and (BlockImgR = nil) then
      begin
        if (alpha > 0) then
        begin
          alpha := alpha and $FF;
          //注意, 使用以下特殊算法, 是由图片格式决定
          //资源标准为带有透明通道的Surface, 因此总的Alpha和ColorKey值无效
          //将所画图片直接画入背景, 再将结果与背景混合
          tempscr := SDL_CreateRGBSurface(scr.flags, CurSurface.w, CurSurface.h, 32, RMask, GMask, BMask, 0);
          //tempscr := SDL_DisplayFormat(CurSurface);
          SDL_BlitSurface(scr, @dest, tempscr, nil);
          SDL_BlitSurface(CurSurface, nil, tempscr, nil);
          SDL_SetAlpha(tempscr, SDL_SRCALPHA, 255 - alpha * 255 div 100);
          SDL_BlitSurface(tempscr, nil, scr, @dest);
          SDL_FreeSurface(tempscr);
        end
        else
          SDL_BlitSurface(CurSurface, nil, scr, @dest);
      end
      else
      begin
        //tempscr := SDL_CreateRGBSurface(screen.flags or SDL_SRCALPHA, CurSurface.w, CurSurface.h, 32, RMask, GMask, BMask, AMask);
        tempscr := SDL_DisplayFormatAlpha(CurSurface);
        //SDL_BlitSurface(tempscr, nil, scr, @dest);
        if (mixAlpha > 0) then
        begin
          //writeln(mixalpha);
          //mixalpha := 100;
          //tran := MixAlpha * 255 div 100;
          //bigtran := tran * $01010101;
          //Mask := tempscr.format.AMask;
          //tempscrfront := SDL_CreateRGBSurface(scr.flags or SDL_SRCALPHA, CurSurface.w,
          //CurSurface.h, 32, RMask, GMask, BMask, AMask);
          //tempscrfront := SDL_DisplayFormatAlpha(CurSurface);
          //SDL_FillRect(tempscrfront, nil, (MixColor and (not Mask)) or (bigtran and Mask));
          tempscrfront := MixSurface(tempscr, mixColor, mixAlpha, 0);
          SDL_BlitSurface(tempscrfront, nil, tempscr, nil);
          if (BlockImgR = nil) then
          begin
            if alpha > 0 then
            begin
              alpha := alpha and $FF;
              tempscrback := SDL_CreateRGBSurface(scr.flags, CurSurface.w, CurSurface.h,
                32, RMask, GMask, BMask, 0);
              //tempscrback := SDL_DisplayFormat(CurSurface);
              SDL_BlitSurface(scr, @dest, tempscrback, nil);
              SDL_BlitSurface(tempscr, nil, tempscrback, nil);
              SDL_SetAlpha(tempscrback, SDL_SRCALPHA, 255 - alpha * 255 div 100);
              SDL_BlitSurface(tempscrback, nil, scr, @dest);
              SDL_FreeSurface(tempscrback);
            end
            else
            begin
              SDL_BlitSurface(tempscr, nil, scr, @dest);
            end;
          end
          else
          begin
            //SDL_BlitSurface(tempscrback, nil, scr, @dest);
            //SDL_BlitSurface(tempscrback, nil, tempscr, nil);
          end;
          SDL_FreeSurface(tempscrfront);
        end;
        if (BlockImgR <> nil) then
        begin
          //当需要遮挡透明时, alpha的高位为非遮挡所使用的透明度
          //tran2 := 255 - ((alpha shr 8) and $FF) * 255 div 100;
          //alpha := alpha and $FF;;
          //tran := 255 - alpha * 255 div 100;
          tran2 := (alpha shr 8) and $ff;
          tran := alpha and $ff;
          if tran2 > 0 then
          begin
            tran := 100 - (100 - tran) * tran2 div 100;
          end;
          //将透明通道的值写入所有位, 具体的位置由蒙板决定
          //bigtran := tran * $01010101;
          //bigtran2 := tran2 * $01010101;
          Mask := tempscr.format.AMask;
          for i1 := 0 to tempscr.w - 1 do
          begin
            for i2 := 0 to tempscr.h - 1 do
            begin
              pixdepth := psmallint(BlockImgR + ((dest.x + leftupx + i1) * Height + dest.y +
                leftupy + i2) * size)^;
              pixel := GetPixel(tempscr, i1, i2);
              //AlphaValue := pixel and Mask;
              if pixel and Mask > 0 then
              begin
                SDL_GetRGBA(pixel, tempscr.format, @r, @g, @b, @a);
                if (pixdepth > depth) then
                begin
                  //替换透明通道的值
                  //注意: 这里如果效率较低, 则改用完全指针, 或者汇编编写. 设置偏移也相同
                  a := a * (100 - tran) div 100;
                  pixel := SDL_MapRGBA(tempscr.format, r, g, b, a);
                  PutPixel(tempscr, i1, i2, pixel);
                end
                else
                begin
                  if tran2 > 0 then
                  begin
                    a := a * (100 - tran2) div 100;
                    pixel := SDL_MapRGBA(tempscr.format, r, g, b, a);
                    PutPixel(tempscr, i1, i2, pixel);
                  end;
                end;
              end;
            end;
          end;
          SDL_BlitSurface(tempscr, nil, scr, @dest);
        end;
        SDL_FreeSurface(tempscr);
      end;
    end;
  end;
end;}

procedure SetPNGTileBlock(PNGIndex: TPNGIndex; FrameNum, px, py, depth: integer; BlockImageW: pchar;
  Width, Height, size: integer);
var
  i, i1, i2, x1, y1: integer;
  CurSurface: PSDL_Surface;
begin
  with PNGIndex do
  begin
    if CurPointer <> nil then
    begin
      if frame > 1 then
        Inc(CurPointer, FrameNum mod Frame);
      CurSurface := CurPointer^;
      if CurSurface <> nil then
      begin
        x1 := px - x;
        y1 := py - y;
        for i1 := 0 to CurSurface.w - 1 do
        begin
          for i2 := 0 to CurSurface.h - 1 do
          begin
            //当该值并非透明色值时, 表示需要遮挡数据
            //游戏中的遮挡实际上可由绘图顺序决定, 即绘图顺序靠后的应有最大遮挡值
            //绘图顺序比较的优先级为: x, y的最小值; 坐标差绝对值; y较小(或x较大)
            //保存遮挡需要一个数组, 但是如果利用Surface可能会更快
            if ((GetPixel(CurSurface, i1, i2) and CurSurface.format.AMask) <> 0) and
              (x1 + i1 >= 0) and (x1 + i1 < Width) and (y1 + i2 >= 0) and (y1 + i2 < Height) then
            begin
              psmallint(BlockImageW + ((x1 + i1) * Height + y1 + i2) * size)^ := depth;
            end;
          end;
        end;
      end;
    end;
  end;

end;

//将表面与一单色混合
//混合方法method, 0 - 简单遮罩, 1 - 乘法混合
//1效率不高, 且需注意当混合值为100时结果并非纯色

function MixSurface(sur: PSDL_Surface; mixColor: uint32; mixAlpha: integer; method: integer = 0): PSDL_Surface;
var
  bigtran, Mask: uint32;
  tempsur: PSDL_Surface;
  i1, i2: integer;
  r, g, b, r1, g1, b1, a: byte;
begin
  Result := SDL_DisplayFormatAlpha(sur);
  if mixAlpha > 0 then
  begin
    tempsur := SDL_CreateRGBSurface(sur.flags or SDL_SRCALPHA, sur.w, sur.h, 32, RMask, GMask, BMask, AMask);
    case method of
      0:
      begin
        bigtran := (mixAlpha * 255 div 100) * $01010101;
        Mask := AMask;
        SDL_FillRect(tempsur, nil, (mixColor and (not Mask)) or (bigtran and Mask));
        SDL_BlitSurface(tempsur, nil, Result, nil);
      end;
      1:
      begin
        //writeln(method);
        SDL_GetRGB(mixColor, sur.format, @r1, @g1, @b1);
        r1 := 255 - (255 - r1) * mixAlpha div 100;
        g1 := 255 - (255 - g1) * mixAlpha div 100;
        b1 := 255 - (255 - b1) * mixAlpha div 100;
        for i1 := 0 to sur.w - 1 do
          for i2 := 0 to sur.h - 1 do
          begin
            SDL_GetRGBA(GetPixel(sur, i1, i2), sur.format, @r, @g, @b, @a);
            //r := 255 - (255 - r) * (100-mixAlpha) div 100;
            //g := 255 - (255 - g) * (100-mixAlpha)  div 100;
            //b := 255 - (255 - b) * (100-mixAlpha)  div 100;
            r := r * r1 div 255;
            g := g * g1 div 255;
            b := b * b1 div 255;
            PutPixel(Result, i1, i2, SDL_MapRGBA(sur.format, r, g, b, a));
          end;
      end;
    end;
    SDL_FreeSurface(tempsur);

  end;
end;

//复制Index的表面, 如为空返回一很小的表面, 避免Blit出错

function CopyIndexSurface(PNGIndexArray: TPNGIndexArray; i: integer): PSDL_Surface;
var
  PNGIndex: TPNGIndex;
begin
  Result := nil;
  if (i >= 0) and (i <= high(PNGIndexArray)) then
  begin
    PNGIndex := PNGIndexArray[i];
    if (PNGIndex.Loaded = 1) and (PNGIndex.Frame > 0) then
      Result := SDL_DisplayFormatAlpha(PNGIndex.CurPointer^);
  end;
  if Result = nil then
    Result := SDL_CreateRGBSurface(ScreenFlag, 1, 1, 32, RMask, GMask, BMask, 0);
end;

procedure BlitRGBA(srcsur: PSDL_Surface; psrcrect: PSDL_Rect; dstsur: PSDL_Surface; pdstrect: PSDL_Rect);
var
  srcrect, dstrect: TSDL_Rect;
  i1, i2: uint16;
  color: uint32;
begin
  if psrcrect = nil then
  begin
    srcrect.x := 0;
    srcrect.y := 0;
    srcrect.w := srcsur.w;
    srcrect.h := srcsur.h;
  end
  else
  begin
    srcrect := TSDL_Rect(psrcrect^);
  end;
  if pdstrect = nil then
  begin
    dstrect.x := 0;
    dstrect.y := 0;
    dstrect.w := dstsur.w;
    dstrect.h := dstsur.h;
  end
  else
  begin
    dstrect := TSDL_Rect(pdstrect^);
  end;
  for i1 := 0 to srcrect.w - 1 do
    for i2 := 0 to srcrect.h - 1 do
    begin
      if (i1 + srcrect.x >= 0) and (i1 + srcrect.x < srcsur.w) and (i2 + srcrect.y >= 0) and
        (i2 + srcrect.y < srcsur.h) and (i1 + dstrect.x >= 0) and (i1 + dstrect.x < dstsur.w) and
        (i2 + dstrect.y >= 0) and (i2 + dstrect.y < dstsur.h) then
      begin
        color := GetPixel(srcsur, i1 + srcrect.x, i2 + srcrect.y);
        if color and AMask <> 0 then
        begin
          PutPixel(dstsur, i1 + dstrect.x, i2 + dstrect.y, color);
        end;
      end;
    end;
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
  bmp: pSDL_Overlay;
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

  procedure LoadAudioThread;
  var
    pFormatCtxA: pAVFormatContext;
    pCodecCtxA: pAVCodecContext;
    pCodecA: pAVCodec;
    packetA: TAVPacket;
    bufferA: pbyte;
    audioStream, sizeA: integer;
    i: integer;
  begin
    //另开一个寻找音频
    av_open_input_file(pFormatCtxA, PChar(movieName), nil, 0, nil);
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
  av_register_all();
  if av_open_input_file(pFormatCtx, PChar(filename), nil, 0, nil) = 0 then
  begin
    av_find_stream_info(pFormatCtx);
    movieName := filename;
    LoadAudio := SDL_CreateThread(@LoadAudioThread, nil);
    //LoadAudioThread;
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
    size := avpicture_get_size(PIX_FMT_RGB24, pCodecCtx.Width, pCodecCtx.Height);
    buffer := av_malloc(size);
    avpicture_fill(pAVPicture(pFrameRGB), buffer, PIX_FMT_RGB24, pCodecCtx.Width, pCodecCtx.Height);
    if GLHR = 0 then
      bmp := SDL_CreateYUVOverlay(pCodecCtx.Width, pCodecCtx.Height, SDL_YV12_OVERLAY, RealScreen);

    frame_timer_begin := av_gettime() / 1e3;

    timerA := 0;
    while SDL_PollEvent(@event) >= 0 do
    begin
      time1 := av_gettime() / 1e3;
      ptimerA := timerA;
      if ((event.key.keysym.sym = SDLK_ESCAPE) or (event.button.button = SDL_BUTTON_RIGHT)) then
        break;
      //if (event.type_ = SDL_QUITEV) then
      //break;
      {if (event.type_ = SDL_VIDEORESIZE) then
      begin
        SDL_FreeYUVOverlay(bmp);
        bmp := SDL_CreateYUVOverlay(pCodecCtx.Width, pCodecCtx.Height, SDL_YV12_OVERLAY, RealScreen);
        rect.x := (RealScreen.w - pCodecCtx.Width) div 2;
        rect.y := (RealScreen.h - pCodecCtx.Height) div 2;;
        rect.w := pCodecCtx.Width;
        rect.h := pCodecCtx.Height;
      end;}
      CheckBasicEvent;
      //计算窗口的位置
      if fullwindow = 0 then
      begin
        if GLHR = 0 then
        begin
          rect.x := (RealScreen.w - pCodecCtx.Width) div 2;
          rect.y := (RealScreen.h - pCodecCtx.Height) div 2;
          rect.w := pCodecCtx.Width;
          rect.h := pCodecCtx.Height;
        end
        else
        begin
          xcoord := pCodecCtx.Width / RealScreen.w;
          ycoord := pCodecCtx.Height / RealScreen.h;
        end;
      end
      else
      begin
        if GLHR = 0 then
        begin
          rect.x := 0;
          rect.y := 0;
          scale := min(RealScreen.w / pCodecCtx.Width, RealScreen.h / pCodecCtx.Height);
          rect.w := round(pCodecCtx.Width * scale);
          rect.h := round(pCodecCtx.Height * scale);
          if RealScreen.w / pCodecCtx.Width > RealScreen.h / pCodecCtx.Height then
          begin
            rect.x := (RealScreen.w - rect.w) div 2;
          end
          else
          begin
            rect.y := (RealScreen.h - rect.h) div 2;
          end;
        end
        else
        begin
          xcoord := pCodecCtx.Width / RealScreen.w;
          ycoord := pCodecCtx.Height / RealScreen.h;
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
        end;
      end;

      if av_read_frame(pFormatCtx, packet) < 0 then
        break;
      if (packet.stream_index = videoStream) then
      begin
        avcodec_decode_video2(pCodecCtx, pFrame, frameFinished, @packet);
        if (frameFinished <> 0) then
        begin
          if GLHR = 0 then
          begin
            SDL_LockYUVOverlay(bmp);
            p := bmp.pixels;
            pict.Data[0] := pointer(p^);
            Inc(p, 2);
            pict.Data[1] := pointer(p^);
            Inc(p, -1);
            pict.Data[2] := pointer(p^);
            p2 := bmp.pitches;
            pict.linesize[0] := (p2^);
            Inc(p2, 2);
            pict.linesize[1] := (p2^);
            Inc(p2, -1);
            pict.linesize[2] := (p2^);
            img_convert_ctx :=
              sws_getContext(pCodecCtx.Width, pCodecCtx.Height, pCodecCtx.pix_fmt, pCodecCtx.Width,
              pCodecCtx.Height, PIX_FMT_YUV420P, SWS_BICUBIC, nil, nil, nil);
            sws_scale(img_convert_ctx, @pFrame.Data[0], @pFrame.linesize[0], 0, pCodecCtx.Height,
              @pict.Data[0], @pict.linesize[0]);
            sws_freeContext(img_convert_ctx);
            SDL_UnLockYUVOverlay(bmp);
            SDL_DisplayYUVOverlay(bmp, @rect);
          end
          else
          begin
            glGenTextures(1, @TextureID);
            glBindTexture(GL_TEXTURE_2D, TextureID);
            img_convert_ctx :=
              sws_getContext(pCodecCtx.Width, pCodecCtx.Height, pCodecCtx.pix_fmt, pCodecCtx.Width,
              pCodecCtx.Height, PIX_FMT_RGB24, SWS_BICUBIC, nil, nil, nil);
            sws_scale(img_convert_ctx, @pFrame.Data[0], @pFrame.linesize[0], 0, pCodecCtx.Height,
              @pFrameRGB.Data[0], @pFrameRGB.linesize[0]);
            sws_freeContext(img_convert_ctx);
            glTexImage2D(GL_TEXTURE_2D, 0, GL_RGB, pCodecCtx.Width, pCodecCtx.Height,
              0, GL_RGB, GL_UNSIGNED_BYTE, pFrameRGB.Data[0]);
            glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_LINEAR);
            glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_LINEAR);

            glClear(GL_COLOR_BUFFER_BIT);
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
            glDeleteTextures(1, @TextureID);
            SDL_GL_SwapBuffers();
          end;
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
    av_free_packet(@packet);

    if GLHR = 0 then
      SDL_FreeYUVOverlay(bmp);

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

end.
