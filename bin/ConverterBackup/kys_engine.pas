unit kys_engine;

interface

uses
  Windows,
  SysUtils,
  SDL_TTF,
  //SDL_mixer,
  SDL_image,
  SDL_gfx,
  SDL,
  Math,
  kys_main,
  kys_event,
  glext,
  gl,
  Dialogs,
  bassmidi, bass;

//音频子程
procedure InitialMusic;
procedure PlayMP3(MusicNum, times: integer); overload;
procedure PlayMP3(filename: PChar; times: integer); overload;
procedure StopMP3;
procedure PlaySound(SoundNum, times: integer); overload;
procedure PlaySound(SoundNum, times, x, y, z: integer); overload;
procedure PlaySoundA(SoundNum, times: integer); overload;
procedure PlaySound(SoundNum: integer); overload;
procedure PlaySound(filename: PChar; times: integer); overload;

//基本绘图子程
procedure InitialSurfaces;
procedure DrawRLE8PicOnSurface(num: integer; w, h: integer; Ppic: PByte; surface: PSDL_Surface);
function getpixel(surface: PSDL_Surface; x: integer; y: integer): Uint32;
procedure putpixel(surface_: PSDL_Surface; x: integer; y: integer; pixel: Uint32);
procedure drawscreenpixel(x, y: integer; color: Uint32);
procedure display_bmp(file_name: PChar; x, y: integer);
procedure display_img(file_name: PChar; x, y: integer);
function ColColor(num: integer): Uint32;

//画RLE8图片的子程
function JudgeInScreen(px, py, w, h, xs, ys: integer): boolean; overload;
function JudgeInScreen(px, py, w, h, xs, ys, xx, yy, xw, yh: integer): boolean; overload;
procedure DrawRLE8Pic(num, px, py: integer; Pidx: Pinteger; Ppic: PByte; RectArea: TRect;
  Image: PChar; Shadow, Alpha: integer); overload;
procedure DrawRLE8Pic(colorPanel: PChar; num, px, py: integer; Pidx: Pinteger; Ppic: PByte;
  RectArea: PChar; Image: PChar; widthI, heightI, sizeI: integer; shadow: integer); overload;
procedure DrawRLE8Pic2(colorPanel: PChar; num, px, py: integer; Pidx: Pinteger; Ppic: PByte;
  RectArea: PChar; Image: PChar; widthI, heightI, sizeI: integer; shadow, alpha: integer);
function GetPositionOnScreen(x, y, CenterX, CenterY: integer): TPosition;
procedure DrawTitlePic(imgnum, px, py: integer);
procedure DrawMPic(num, px, py: integer);
procedure DrawSPic(num, px, py, x, y, w, h: integer);
procedure DrawSPic2(num, px, py, shadow, alpha, depth: integer; mixColor: Uint32; mixAlpha: integer);
procedure InitialSPic(num, px, py, x, y, w, h: integer);
procedure InitialSPic2(num, px, py, x, y, w, h, needBlock, depth: integer);
procedure InitialSPic3(num, px, py, x, y, w, h, needBlock, depth, temp: integer);
procedure DrawHeadPic(num, px, py: integer); overload;
procedure DrawHeadPic(num, px, py: integer; scr: PSDL_Surface); overload;
procedure DrawBPic(num, px, py, shadow: integer);
procedure DrawBPic2(num, px, py, shadow, alpha, depth: integer; mixColor: Uint32; mixAlpha: integer);
procedure DrawBPicInRect(num, px, py, shadow, x, y, w, h: integer);
procedure InitialBPic(num, px, py: integer);
procedure InitialBPic2(num, px, py, needblock, depth: integer);
procedure DrawEPic(num, px, py: integer);
procedure DrawFPic(num, px, py: integer);
procedure DrawFPicInRect(num, px, py, x, y, w, h: integer);

//显示文字的子程
function Big5ToUnicode(str: PChar): WideString;
function UnicodeToBig5(str: PWideChar): string;
function UnicodeToGBK(str: PWideChar): string;
procedure DrawText(sur: PSDL_Surface; word: PUint16; x_pos, y_pos: integer; color: Uint32);
procedure DrawEngText(sur: PSDL_Surface; word: PUint16; x_pos, y_pos: integer; color: Uint32);
procedure DrawShadowText(word: PUint16; x_pos, y_pos: integer; color1, color2: Uint32);
procedure DrawEngShadowText(word: PUint16; x_pos, y_pos: integer; color1, color2: Uint32);
procedure DrawBig5Text(sur: PSDL_Surface; str: PChar; x_pos, y_pos: integer; color: Uint32);
procedure DrawBig5ShadowText(word: PChar; x_pos, y_pos: integer; color1, color2: Uint32);
procedure DrawTextWithRect(word: puint16; x, y, w: integer; color1, color2: uint32);
procedure DrawRectangle(x, y, w, h: integer; colorin, colorframe: Uint32; alphe: integer);
procedure DrawRectangleWithoutFrame(x, y, w, h: integer; colorin: Uint32; alphe: integer);
procedure DrawGBShadowText(word: PChar; x_pos, y_pos: integer; color1, color2: Uint32);

//绘制整个屏幕的子程
procedure Redraw;
procedure DrawMMap;
procedure DrawScence;
procedure DrawScenceWithoutRole(x, y: integer);
procedure DrawRoleOnScence(x, y: integer);
procedure InitialScence(); overload;
procedure InitialScence(Visible: integer); overload;
procedure UpdateScence(xs, ys: integer);
procedure LoadScencePart(x, y: integer);
procedure DrawWholeBField;
procedure DrawBfieldWithoutRole(x, y: integer);
procedure DrawRoleOnBfield(x, y: integer);
procedure InitialWholeBField;
procedure LoadBfieldPart(x, y: integer);
procedure DrawBFieldWithCursor(AttAreaType, step, range: integer);
procedure DrawBlackScreen;
procedure DrawBFieldWithEft(Epicnum: integer); overload;
procedure DrawBFieldWithEft(Epicnum, beginpic, endpic, curlevel: integer); overload;
procedure DrawBFieldWithAction(bnum, Apicnum: integer);
function Simplified2Traditional(mSimplified: string): string;
procedure ShowMap;
procedure DrawPartPic(pic: psdl_surface; x, y, w, h, x1, y1: integer);
function Traditional2Simplified(mTraditional: string): string;
procedure PlayBeginningMovie;
procedure ZoomPic(scr: Psdl_surface; x, y, w, h: integer);
function GetPngPic(pic: pbyte; idx: pint; num: integer): Psdl_Surface;
function ReadPicFromByte(p_byte: Pbyte; size: integer): Psdl_Surface;
procedure findway(x1, y1: integer);
procedure Moveman(x1, y1, x2, y2: integer);

procedure SDL_UpdateRect2(scr1: PSDL_Surface; x, y, w, h: integer);
procedure SDL_GetMouseState2(var x, y: integer);
procedure ResizeWindow(w, h: integer);
procedure SwitchFullscreen;
procedure QuitConfirm;
procedure CheckBasicEvent;

procedure ChangeCol;
procedure DrawRLE8Pic3(colorPanel: PChar; num, px, py: integer; Pidx: Pinteger; Ppic: PByte;
  RectArea: PChar; Image: PChar; widthI, heightI, sizeI: integer; shadow, alpha: integer;
  BlockImageW: PChar; BlockScreenR: PChar; widthR, heightR, sizeR: integer; depth: integer;
  mixColor: Uint32; mixAlpha: integer);
procedure DrawRLE8Pic(colorPanel: PChar; num, px, py: integer; Pidx: Pinteger; Ppic: PByte;
  RectArea: PChar; Image: PSDL_Surface; widthI, heightI, sizeI: integer; shadow, alpha: integer;
  BlockImageW: PChar; BlockScreenR: PChar; widthR, heightR, sizeR: integer; depth: integer;
  MixColor: Uint32; MixAlpha: integer); overload;
procedure DrawRLE8PicA(colorPanel: PChar; num, px, py: integer; Pidx: Pinteger; Ppic: PByte;
  RectArea: TRect; Image: PChar; shadow, alpha: integer);

procedure DrawClouds;
procedure DrawCPic(num, px, py, shadow, alpha: integer; mixColor: Uint32; mixAlpha: integer);

implementation

uses kys_battle;

procedure InitialMusic;
var
  i: integer;
  str: string;
  sf: BASS_MIDI_FONT;
  Flag: longword;
begin
  BASS_Set3DFactors(1, 0, 0);
  sf.font := BASS_MIDI_FontInit(PChar('music\mid.sf2'), 0);
  BASS_MIDI_StreamSetFonts(0, sf, 1);
  sf.preset := -1; // use all presets
  sf.bank := 0;
  Flag := 0;
  if SOUND3D = 1 then
    Flag := BASS_SAMPLE_3D or BASS_SAMPLE_MONO or Flag;

  for i := 0 to 99 do
  begin
    str := 'music\' + IntToStr(i) + '.mp3';
    if fileexists(PChar(str)) then
    begin
      try
        Music[i] := BASS_StreamCreateFile(False, PChar(str), 0, 0, 0);
      finally

      end;
    end
    else
    begin
      str := 'music\' + IntToStr(i) + '.mid';
      if fileexists(PChar(str)) then
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

  for i := 0 to 99 do
  begin
    str := 'sound\e' + IntToStr(i) + '.wav';
    if fileexists(PChar(str)) then
      ESound[i] := BASS_SampleLoad(False, PChar(str), 0, 0, 1, Flag)
    else
      ESound[i] := 0;
    //showmessage(inttostr(esound[i]));
  end;
  for i := 0 to 99 do
  begin
    str := formatfloat('sound\atk00', i) + '.wav';
    if fileexists(PChar(str)) then
      ASound[i] := BASS_SampleLoad(False, PChar(str), 0, 0, 1, Flag)
    else
      ASound[i] := 0;
  end;

end;



//播放mp3音乐

procedure PlayMP3(MusicNum, times: integer); overload;
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

procedure PlayMP3(filename: PChar; times: integer); overload;
begin
  //if fileexists(filename) then
  //begin
  //Music := Mix_LoadMUS(filename);
  //Mix_volumemusic(MIX_MAX_VOLUME div 3);
  //Mix_PlayMusic(music, times);
  //end;

end;

//停止当前播放的音乐

procedure StopMP3;
begin
  {  Mix_HaltMusic;}

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
  if (SoundNum in [Low(Esound)..High(Esound)]) and (VOLUME > 0) then
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

  if (SoundNum in [Low(Esound)..High(Esound)]) and (VOLUME > 0) then
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
  if (SoundNum in [Low(Asound)..High(Asound)]) and (VOLUME > 0) then
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

procedure PlaySound(filename: PChar; times: integer); overload;
begin
  {if fileexists(filename) then
  begin
    Sound := Mix_LoadWav(filename);
    Mix_PlayChannel(-1, sound, times);
  end;}
end;

//将M，S，W贴图载入显存

procedure InitialSurfaces;
var
  i: integer;
begin
  if VideoMemMain = 1 then
  begin
    setlength(MSurface, MNumber);
    setlength(MInfo, MNumber);
    Minfo[0].w := psmallint(@MPic[0])^;
    Minfo[0].h := psmallint(@MPic[2])^;
    Minfo[0].offx := psmallint(@MPic[4])^;
    Minfo[0].offy := psmallint(@MPic[6])^;
    Msurface[0] := SDL_CreateRGBSurface(SDL_SWSURFACE, Minfo[0].w + 1, Minfo[0].h, 32, $FF, $FF00, $FF0000, $FF000000);
    DrawRLE8PicOnSurface(0, Minfo[0].w, Minfo[0].h, @Mpic[0], Msurface[0]);
    SDL_SetColorKey(Msurface[0], 0, 0);
    for i := 1 to MNumber - 1 do
    begin
      Minfo[i].w := psmallint(@MPic[Midx[i - 1]])^;
      Minfo[i].h := psmallint(@MPic[Midx[i - 1] + 2])^;
      Minfo[i].offx := psmallint(@MPic[Midx[i - 1] + 4])^;
      Minfo[i].offy := psmallint(@MPic[Midx[i - 1] + 6])^;
      Msurface[i] := SDL_CreateRGBSurface(SDL_SWSURFACE, Minfo[i].w + 1, Minfo[i].h, 32, $FF,
        $FF00, $FF0000, $FF000000);
      DrawRLE8PicOnSurface(i, Minfo[i].w, Minfo[i].h, @Mpic[Midx[i - 1]], Msurface[i]);
      SDL_SetColorKey(Msurface[i], 0, $0);
    end;
  end;

  if VideoMemScence = 1 then
  begin
    setlength(SSurface, SNumber);
    setlength(SInfo, SNumber);
    Sinfo[0].w := smallint(SPic[0]);
    Sinfo[0].h := smallint(SPic[2]);
    Sinfo[0].offx := smallint(SPic[4]);
    Sinfo[0].offy := smallint(SPic[6]);
    Ssurface[0] := SDL_CreateRGBSurface(SDL_SWSURFACE, Sinfo[0].w, Sinfo[0].h, 32, $FF, $FF00, $FF0000, $FF000000);
    DrawRLE8PicOnSurface(0, Sinfo[0].w, Sinfo[0].h, @Spic[0], Ssurface[0]);
    SDL_SetColorKey(Ssurface[0], 0, 0);
    for i := 1 to SNumber - 1 do
    begin
      Sinfo[i].w := psmallint(@SPic[Sidx[i - 1]])^;
      Sinfo[i].h := psmallint(@SPic[Sidx[i - 1] + 2])^;
      Sinfo[i].offx := psmallint(@SPic[Sidx[i - 1] + 4])^;
      Sinfo[i].offy := psmallint(@SPic[Sidx[i - 1] + 6])^;
      Ssurface[i] := SDL_CreateRGBSurface(SDL_SWSURFACE, Sinfo[i].w + 1, Sinfo[i].h, 32, $FF,
        $FF00, $FF0000, $FF000000);
      DrawRLE8PicOnSurface(i, Sinfo[i].w, Sinfo[i].h, @Spic[Sidx[i - 1]], Ssurface[i]);
      SDL_SetColorKey(Ssurface[i], 0, 0);
    end;
  end;

  if VideoMemBattle = 1 then
  begin
    setlength(BSurface, BNumber);
    setlength(BInfo, BNumber);
    Binfo[0].w := smallint(WPic[0]);
    Binfo[0].h := smallint(WPic[2]);
    Binfo[0].offx := smallint(WPic[4]);
    Binfo[0].offy := smallint(WPic[6]);
    Bsurface[0] := SDL_CreateRGBSurface(SDL_SWSURFACE, Binfo[0].w, Binfo[0].h, 32, $FF, $FF00, $FF0000, $FF000000);
    DrawRLE8PicOnSurface(0, Binfo[0].w, Binfo[0].h, @Wpic[0], Bsurface[0]);
    SDL_SetColorKey(Bsurface[0], 0, 0);
    for i := 1 to BNumber - 1 do
    begin
      Binfo[i].w := psmallint(@WPic[Widx[i - 1]])^;
      Binfo[i].h := psmallint(@WPic[Widx[i - 1] + 2])^;
      Binfo[i].offx := psmallint(@WPic[Widx[i - 1] + 4])^;
      Binfo[i].offy := psmallint(@WPic[Widx[i - 1] + 6])^;
      Bsurface[i] := SDL_CreateRGBSurface(SDL_SWSURFACE, Binfo[i].w + 1, Binfo[i].h, 32, $FF,
        $FF00, $FF0000, $FF000000);
      DrawRLE8PicOnSurface(i, Binfo[i].w, Binfo[i].h, @Wpic[Widx[i - 1]], Bsurface[i]);
      SDL_SetColorKey(Bsurface[i], 0, 0);
    end;
  end;
end;



procedure DrawRLE8PicOnSurface(num: integer; w, h: integer; Ppic: PByte; surface: PSDL_Surface);
var
  p: integer;
  l, l1, ix, iy, ww: integer;
  pix: Uint32;
begin
  if (SDL_MustLock(surface)) then
  begin
    if (SDL_LockSurface(surface) < 0) then
    begin
      MessageBox(0, PChar(Format('Can''t lock screen : %s', [SDL_GetError])), 'Error', MB_OK or MB_ICONHAND);
      exit;
    end;
  end;
  for ix := 0 to w - 1 do
    for iy := 0 to h - 1 do
      putpixel(surface, ix, iy, 0);
  Inc(Ppic, 8);
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
        pix := sdl_maprgb(surface.format, ACol[l1 * 3] * (4), ACol[l1 * 3 + 1] * (4), ACol[l1 * 3 + 2] * (4));
        putpixel(surface, w, iy, pix);
        w := w + 1;
        if p = 2 then
        begin
          p := 0;
        end;
      end;
    end;
  end;
  if (SDL_MustLock(surface)) then
  begin
    SDL_UnlockSurface(surface);
  end;

end;



//获取某像素信息

function getpixel(surface: PSDL_Surface; x: integer; y: integer): Uint32;
type
  TByteArray = array[0..2] of byte;
  PByteArray = ^TByteArray;
var
  bpp: integer;
  p: PInteger;
begin
  if (x >= 0) and (x < screen.w) and (y >= 0) and (y < screen.h) then
  begin
    bpp := surface.format.BytesPerPixel;
    // Here p is the address to the pixel we want to retrieve
    p := Pointer(Uint32(surface.pixels) + y * surface.pitch + x * bpp);
    case bpp of
      1:
        Result := longword(p^);
      2:
        Result := PUint16(p)^;
      3:
        if (SDL_BYTEORDER = SDL_BIG_ENDIAN) then
          Result := PByteArray(p)[0] shl 16 or PByteArray(p)[1] shl 8 or PByteArray(p)[2]
        else
          Result := PByteArray(p)[0] or PByteArray(p)[1] shl 8 or PByteArray(p)[2] shl 16;
      4:
        Result := PUint32(p)^;
      else
        Result := 0; // shouldn't happen, but avoids warnings
    end;
  end;

end;

//画像素

procedure putpixel(surface_: PSDL_Surface; x: integer; y: integer; pixel: Uint32);
type
  TByteArray = array[0..2] of byte;
  PByteArray = ^TByteArray;
var
  bpp: integer;
  p: PInteger;
  regionx1, regiony1, regionx2, regiony2: integer;
begin

  regionx1 := 0;
  regionx2 := screen.w;
  regiony1 := 0;
  regiony2 := screen.h;

  //{$IFDEF DARWIN}
  {if (RegionRect.w > 0) then
  begin
    regionx1 := RegionRect.x;
    regionx2 := RegionRect.x + RegionRect.w;
    regiony1 := RegionRect.y;
    regiony2 := RegionRect.y + RegionRect.h;
  end;}
  //{$ENDIF}

  if (x >= regionx1) and (x < regionx2) and (y >= regiony1) and (y < regiony2) then
  begin
    bpp := surface_.format.BytesPerPixel;
    // Here p is the address to the pixel we want to set
    p := Pointer(Uint32(surface_.pixels) + y * surface_.pitch + x * bpp);

    case bpp of
      1:
        longword(p^) := pixel;
      2:
        PUint16(p)^ := pixel;
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
        PUint32(p)^ := pixel;
    end;
  end;

end;

//画一个点

procedure drawscreenpixel(x, y: integer; color: Uint32);
begin
  (* Map the color yellow to this display (R := $ff, G := $FF, B := $00)
     Note:  If the display is palettized, you must set the palette first.
  *)
  if (SDL_MustLock(screen)) then
  begin
    if (SDL_LockSurface(screen) < 0) then
    begin
      MessageBox(0, PChar(Format('Can''t lock screen : %s', [SDL_GetError])), 'Error', MB_OK or MB_ICONHAND);
      exit;
    end;
  end;

  putpixel(screen, x, y, color);

  if (SDL_MustLock(screen)) then
  begin
    SDL_UnlockSurface(screen);
  end;
  // Update just the part of the display that we've changed
  SDL_UpdateRect2(screen, x, y, 1, 1);
end;

//显示bmp文件

procedure display_bmp(file_name: PChar; x, y: integer);
var
  image: PSDL_Surface;
  dest: TSDL_Rect;
begin
  if fileexists(file_name) then
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

procedure display_img(file_name: PChar; x, y: integer);
var
  image: PSDL_Surface;
  dest: TSDL_Rect;
begin
  if fileexists(file_name) then
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
    if (SDL_BlitSurface(image, nil, screen, @dest) < 0) then
      MessageBox(0, PChar(Format('BlitSurface error : %s', [SDL_GetError])), 'Error', MB_OK or MB_ICONHAND);
    //SDL_UpdateRect2(screen, 0, 0, image.w, image.h);
    SDL_FreeSurface(image);
  end;
end;

//取调色板的颜色, 视频系统是32位色, 但很多时候仍需要原调色板的颜色

function ColColor(num: integer): Uint32;
begin
  colcolor := SDL_mapRGB(screen.format, Acol[num * 3 + 2] * 4, Acol[num * 3 + 1] * 4, Acol[num * 3] * 4);
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

//RLE8图片绘制子程，所有相关子程均对此封装

procedure DrawRLE8Pic(num, px, py: integer; Pidx: Pinteger; Ppic: PByte; RectArea: TRect;
  Image: PChar; shadow, alpha: integer); overload;
var
  w, h, xs, ys: smallint;
  offset, length, p: integer;
  l, l1, ix, iy: integer;
  alphe, pix, colorin: Uint32;
  pix1, pix2, pix3, pix4, color1, color2, color3, color4: byte;
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
  if JudgeInScreen(px, py, w, h, xs, ys, RectArea.x, RectArea.y, RectArea.w, RectArea.h) then
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
          if (w - xs + px >= RectArea.x) and (iy - ys + py >= RectArea.y) and
            (w - xs + px < RectArea.x + RectArea.w) and (iy - ys + py < RectArea.y + RectArea.h) then
          begin
            if image = nil then
            begin
              pix := sdl_maprgb(screen.format, ACol[l1 * 3] * (4 + shadow), ACol[l1 * 3 + 1] *
                (4 + shadow), ACol[l1 * 3 + 2] * (4 + shadow));
              if alpha <> 0 then
              begin
                colorin := getpixel(screen, w - xs + px, iy - ys + py);
                pix1 := pix and $FF;
                color1 := colorin and $FF;
                pix2 := pix shr 8 and $FF;
                color2 := colorin shr 8 and $FF;
                pix3 := pix shr 16 and $FF;
                color3 := colorin shr 16 and $FF;
                pix4 := pix shr 24 and $FF;
                color4 := colorin shr 24 and $FF;
                pix1 := (alpha * color1 + (100 - alpha) * pix1) div 100;
                pix2 := (alpha * color2 + (100 - alpha) * pix2) div 100;
                pix3 := (alpha * color3 + (100 - alpha) * pix3) div 100;
                pix4 := (alpha * color4 + (100 - alpha) * pix4) div 100;
                pix := pix1 + pix2 shl 8 + pix3 shl 16 + pix4 shl 24;
              end;
              if HighLight then
              begin
                pix1 := pix and $FF;
                pix2 := pix shr 8 and $FF;
                pix3 := pix shr 16 and $FF;
                pix4 := pix shr 24 and $FF;
                pix1 := (50 * $FF + 50 * pix1) div 100;
                pix2 := (50 * $FF + 50 * pix2) div 100;
                pix3 := (50 * $FF + 50 * pix3) div 100;
                pix4 := (50 * $FF + 50 * pix4) div 100;
                pix := pix1 + pix2 shl 8 + pix3 shl 16 + pix4 shl 24;
              end;
              if (ShowBlackScreen = True) and (where = 1) then
              begin
                alphe := snowalpha[iy - ys + py][w - xs + px];
                if alphe = 100 then
                  pix := 0
                else if alphe <> 0 then
                begin
                  pix1 := pix and $FF;
                  pix2 := pix shr 8 and $FF;
                  pix3 := pix shr 16 and $FF;
                  pix4 := pix shr 24 and $FF;
                  pix1 := ((100 - alphe) * pix1) div 100;
                  pix2 := ((100 - alphe) * pix2) div 100;
                  pix3 := ((100 - alphe) * pix3) div 100;
                  pix4 := ((100 - alphe) * pix4) div 100;
                  pix := pix1 + pix2 shl 8 + pix3 shl 16 + pix4 shl 24;
                end;
              end;
              if Gray then
              begin
                pix1 := pix and $FF;
                pix2 := pix shr 8 and $FF;
                pix3 := pix shr 16 and $FF;
                pix4 := pix shr 24 and $FF;
                pix1 := (pix1 * 11) div 100 + (pix2 * 59) div 100 + (pix3 * 3) div 10;
                pix := pix1 + pix1 shl 8 + pix1 shl 16 + pix4 shl 24;
              end;
              putpixel(screen, w - xs + px, iy - ys + py, pix);
            end
            else
              Pint(image + ((w - xs + px) * (1152 + 250) + (iy - ys + py)) * 4)^ :=
                sdl_maprgb(screen.format, ACol[l1 * 3] * (4 + shadow), ACol[l1 * 3 + 1] *
                (4 + shadow), ACol[l1 * 3 + 2] * (4 + shadow));
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

//获取游戏中坐标在屏幕上的位置

function GetPositionOnScreen(x, y, CenterX, CenterY: integer): TPosition;
begin
  Result.x := -(x - CenterX) * 18 + (y - CenterY) * 18 + CENTER_X;
  Result.y := (x - CenterX) * 9 + (y - CenterY) * 9 + CENTER_Y;
end;

//显示title.grp的内容(即开始的选单)

procedure DrawTitlePic(imgnum, px, py: integer);
var
  len, grp, idx: integer;
  Area: TRect;
  BufferIdx: array[0..100] of integer;
  BufferPic: array[0..20000] of byte;
begin
  grp := fileopen('resource\title.grp', fmopenread);
  idx := fileopen('resource\title.idx', fmopenread);

  len := fileseek(idx, 0, 2);
  fileseek(idx, 0, 0);
  fileread(idx, BufferIdx[0], len);
  len := fileseek(grp, 0, 2);
  fileseek(grp, 0, 0);
  fileread(grp, BufferPic[0], len);

  fileclose(grp);
  fileclose(idx);

  Area.x := 0;
  Area.y := 0;
  Area.w := screen.w;
  Area.h := screen.h;
  DrawRLE8Pic(imgnum, px, py, @BufferIdx[0], @BufferPic[0], Area, nil, 0, 0);

end;

//显示主地图贴图

procedure DrawMPic(num, px, py: integer);
var
  dest: TSDL_Rect;
  Area: Trect;
begin
  Area.x := 0;
  Area.y := 0;
  Area.w := screen.w;
  Area.h := screen.h;
  if VideoMemMain = 1 then
  begin
    dest.x := -Minfo[num].offx + px;
    dest.y := -Minfo[num].offy + py;
    SDL_BlitSurface(MSurface[num], nil, screen, @dest);
  end
  else
    DrawRLE8Pic(num, px, py, @Midx[0], @Mpic[0], Area, nil, 0, 0);

end;

//显示场景图片

procedure DrawSPic(num, px, py, x, y, w, h: integer);
var
  dest: TSDL_Rect;
  Area: TRect;
begin
  Area.x := x;
  Area.y := y;
  Area.w := w;
  Area.h := h;
  if VideoMemScence = 1 then
  begin
    if JudgeInScreen(px, py, Sinfo[num].w, Sinfo[num].h, Sinfo[num].offx, Sinfo[num].offy) then
    begin
      dest.x := -Sinfo[num].offx + px;
      dest.y := -Sinfo[num].offy + py;
      SDL_BlitSurface(SSurface[num], nil, screen, @dest);
    end;
  end
  else
    DrawRLE8Pic(num, px, py, @SIdx[0], @SPic[0], Area, nil, 0, 0);

end;

procedure DrawSPic2(num, px, py, shadow, alpha, depth: integer; mixColor: Uint32; mixAlpha: integer);
var
  Area: TRect;
begin
  Area.x := 0;
  Area.y := 0;
  Area.w := screen.w;
  Area.h := screen.h;
  if (num > 0) {and (num < SPicAmount)} then
    DrawRLE8Pic3(@ACol[0], num, px, py, @SIdx[0], @SPic[0], @Area, nil, 0, 0, 0, shadow, alpha,
      nil, @BlockScreen[0], screen.w, screen.h, sizeof(integer), depth, mixColor, mixAlpha);

end;

//将场景图片信息写入映像

procedure InitialSPic(num, px, py, x, y, w, h: integer);
var
  Area: TRect;
begin
  if x + w > 2303 then
    w := 2303 - x;
  if y + h > 2303 then
    h := 2303 - y;
  Area.x := x;
  Area.y := y;
  Area.w := w;
  Area.h := h;
  DrawRLE8Pic(num, px, py, @SIdx[0], @SPic[0], Area, @ScenceImg[0], 0, 0);

end;

//画到映像并记录深度数据

procedure InitialSPic2(num, px, py, x, y, w, h, needBlock, depth: integer);
begin
  InitialSPic3(num, px, py, x, y, w, h, needBlock, depth, 0);

end;

procedure InitialSPic3(num, px, py, x, y, w, h, needBlock, depth, temp: integer);
var
  Area: TRect;
  pImg, pBlock: PChar;
begin
  if x + w > 2303 then
    w := 2303 - x;
  if y + h > 1151 + 250 then
    h := 1151 + 250 - y;
  Area.x := x;
  Area.y := y;
  Area.w := w;
  Area.h := h;
  if num = 1941 then
  begin
    num := 0;
    py := py - 50;
  end;

  if temp = 0 then
  begin
    pImg := @ScenceImg[0];
    pBlock := @BlockImg[0];
  end
  else
  begin
    pImg := @ScenceImg2[0];
    pBlock := @BlockImg2[0];
  end;
  if (num >= 0) {and (num < SPicAmount)} then
    if needBlock <> 0 then
    begin
      DrawRLE8Pic3(@ACol[0], num, px, py, @SIdx[0], @SPic[0], @Area, pImg, 2304, 1152 + 250,
        sizeof(UInt32), 0, 0, pBlock, nil, 0, 0, 0, depth, 0, 0);
    end
    else
      DrawRLE8Pic(@ACol[0], num, px, py, @SIdx[0], @SPic[0], @Area, pImg, 2304, 1152 + 250, sizeof(UInt32), 0);

end;

//显示头像, 优先考虑'.head\'目录下的png图片

procedure DrawHeadPic(num, px, py: integer); overload;
var
  len, grp, idx: integer;
  Area: TRect;
  str: string;
  b: boolean;
begin
  b := showblackscreen;
  showblackscreen := False;
  if num = 406 then
  begin
    str := 'head\head.png';
    display_img(@str[1], px, py - 60);
  end
  else
  begin
    Area.x := 0;
    Area.y := 0;
    Area.w := screen.w;
    Area.h := screen.h;
    DrawRLE8PicA(@ACol1[0], num, px, py, @HIdx[0], @HPic[0], Area, nil, 0, 0);
    //DrawRLE8Pic3(@ACol2[0], num, px, py, @HIdx[0], @HPic[0], @Area, nil, 0, 0, 0, 0, 0, nil, nil, 0, 0, 0, 128, 0, 0);

  end;
  showblackscreen := b;

end;

procedure DrawHeadPic(num, px, py: integer; scr: PSDL_Surface); overload;
var
  image: PSDL_Surface;
  dest: TSDL_Rect;
  str: string;
  Area: TRect;
  offset: integer;
  y: smallint;
begin
  str := AppPath + 'head/' + IntToStr(num) + '.png';
  if FileExists(str) then
  begin
    image := IMG_Load(PChar(str));
    dest.x := px;
    dest.y := py;
    SDL_BlitSurface(image, nil, scr, @dest);
    SDL_FreeSurface(image);
  end
  else
  begin
    Area.x := 0;
    Area.y := 0;
    Area.w := scr.w;
    Area.h := scr.h;
    offset := 0;
    if num > 0 then
      offset := HIdx[num - 1];
    y := Psmallint(@HPic[offset + 6])^;
    //showmessage(inttostr(y));
    DrawRLE8Pic(@ACol1[0], num, px, py + y, @HIdx[0], @HPic[0], @Area, scr, scr.w, scr.h, 0,
      0, 0, nil, nil, 0, 0, 0, 128, 0, 0);
  end;
end;

//显示战场图片

procedure DrawBPic(num, px, py, shadow: integer);
var
  dest: TSDL_Rect;
  Area: TRect;
begin
  Area.x := 0;
  Area.y := 0;
  Area.w := screen.w;
  Area.h := screen.h;
  if (VideoMemBattle = 1) and (shadow = 0) then
  begin
    //if JudgeInScreen(px, py, Binfo[num].w, Binfo[num].h, Binfo[num].offx, Binfo[num].offy) then
    begin
      dest.x := -Binfo[num].offx + px;
      dest.y := -Binfo[num].offy + py;
      SDL_BlitSurface(BSurface[num], nil, screen, @dest);
    end;
  end
  else
    //DrawRLE8Pic(num, px, py, @WIdx[0], @WPic[0], Area, nil, shadow, 0);
    DrawRLE8PicA(@ACol2[0], num, px, py, @WIdx[0], @WPic[0], Area, nil, shadow, 0);
  //DrawRLE8Pic3(@ACol2[0], num, px, py, @WIdx[0], @WPic[0], @Area, nil, 0, 0, 0, shadow, 0, nil, nil, 0, 0, 0, 128, 0, 0);

  //DrawRLE8Pic(122, px, py, @WIdx[0], @WPic[0], Area, nil, shadow);

end;

//用于画带透明度和遮挡的战场图片

procedure DrawBPic2(num, px, py, shadow, alpha, depth: integer; mixColor: Uint32; mixAlpha: integer);
var
  Area: TRect;
begin
  Area.x := 0;
  Area.y := 0;
  Area.w := screen.w;
  Area.h := screen.h;
  if (num > 0) {and (num < BPicAmount)} then
    DrawRLE8Pic3(@ACol[0], num, px, py, @WIdx[0], @WPic[0], @Area, nil, 0, 0, 0, shadow, alpha,
      nil, @BlockScreen[0], screen.w, screen.h, sizeof(integer), depth, mixColor, mixAlpha);

end;

//仅在某区域显示战场图片

procedure DrawBPicInRect(num, px, py, shadow, x, y, w, h: integer);
var
  Area: TRect;
begin
  Area.x := x;
  Area.y := y;
  Area.w := w;
  Area.h := h;
  DrawRLE8PicA(@ACol2[0], num, px, py, @WIdx[0], @WPic[0], Area, nil, shadow, 0);
  //DrawRLE8Pic3(@ACol2[0], num, px, py, @WIdx[0], @WPic[0], @Area, nil, 0, 0, 0, shadow, 0, nil, nil, 0, 0, 0, 128, 0, 0);

end;

//将战场图片画到映像

procedure InitialBPic(num, px, py: integer);
var
  Area: TRect;
begin
  Area.x := 0;
  Area.y := 0;
  Area.w := 2304;
  Area.h := 1152 + 250;
  DrawRLE8PicA(@ACol2[0], num, px, py, @WIdx[0], @WPic[0], Area, @BFieldImg[0], 0, 0);
  //DrawRLE8Pic3(@ACol2[0], num, px, py, @WIdx[0], @WPic[0], @Area, @BFieldImg[0], 0, 0, 0, 0, 0, nil, nil, 0, 0, 0, 128, 0, 0);

end;

//画到映像并记录深度数据

procedure InitialBPic2(num, px, py, needBlock, depth: integer);
var
  Area: TRect;
begin
  Area.x := 0;
  Area.y := 0;
  Area.w := 2304;
  Area.h := 1152 + 250;
  if (num > 0) {and (num < BPicAmount)} then
    if needBlock <> 0 then
      DrawRLE8Pic3(@ACol[0], num, px, py, @WIdx[0], @WPic[0], @Area, @BFieldImg[0], 2304,
        1152 + 250, sizeof(UInt32), 0, 0, @BlockImg[0], nil, 0, 0, 0, depth, 0, 0)
    else
      DrawRLE8Pic(@ACol[0], num, px, py, @WIdx[0], @WPic[0], @Area, @BFieldImg[0], 2304, 1152 +
        250, sizeof(UInt32), 0);
end;

//显示效果图片

procedure DrawEPic(num, px, py: integer);
var
  Area: TRect;
begin
  Area.x := 0;
  Area.y := 0;
  Area.w := screen.w;
  Area.h := screen.h;
  DrawRLE8PicA(@ACol2[0], num, px, py, @EIdx[0], @EPic[0], Area, nil, 0, 25);

end;

//显示人物动作图片

procedure DrawFPic(num, px, py: integer);
var
  Area: TRect;
begin
  Area.x := 0;
  Area.y := 0;
  Area.w := screen.w;
  Area.h := screen.h;
  DrawRLE8PicA(@ACol2[0], num, px, py, @FIdx[0], @FPic[0], Area, nil, 0, 0);

end;

procedure DrawFPicInRect(num, px, py, x, y, w, h: integer);
var
  Area: TRect;
begin
  Area.x := x;
  Area.y := y;
  Area.w := w;
  Area.h := h;
  DrawRLE8PicA(@ACol2[0], num, px, py, @FIdx[0], @FPic[0], Area, nil, 0, 0);

end;

//big5转为unicode

function Big5ToUnicode(str: PChar): WideString;
var
  len: integer;
begin
  len := MultiByteToWideChar(950, 0, PChar(str), -1, nil, 0);
  setlength(Result, len - 1);
  MultiByteToWideChar(950, 0, PChar(str), length(str), pwidechar(Result), len + 1);
  Result := ' ' + Result;

end;

//unicode转为big5, 仅用于输入姓名

function UnicodeToBig5(str: PWideChar): string;
var
  len: integer;
begin
  len := WideCharToMultiByte(950, 0, PWideChar(str), -1, nil, 0, nil, nil);
  setlength(Result, len + 1);
  WideCharToMultiByte(950, 0, PWideChar(str), -1, PChar(Result), len + 1, nil, nil);

end;

//unicode转为GBK, 仅用于输入姓名

function UnicodeToGBK(str: PWideChar): string;
var
  len: integer;
begin
  len := WideCharToMultiByte(936, 0, PWideChar(str), -1, nil, 0, nil, nil);
  setlength(Result, len + 1);
  WideCharToMultiByte(936, 0, PWideChar(str), -1, PChar(Result), len + 1, nil, nil);

end;
//显示unicode文字

procedure DrawText(sur: PSDL_Surface; word: PUint16; x_pos, y_pos: integer; color: Uint32);
var
  dest: TSDL_Rect;
  len, i: integer;
  pword: array[0..2] of Uint16;
  t: WideString;
begin
  //len := length(word);
  pword[0] := 32;
  pword[2] := 0;
  if SIMPLE = 1 then
  begin
    t := Traditional2Simplified(PwideChar(word));
    word := puint16(t);
  end;
  dest.x := x_pos;
  while word^ > 0 do
  begin
    pword[1] := word^;
    Inc(word);
    if pword[1] > 128 then
    begin
      Text := TTF_RenderUNICODE_blended(font, @pword[0], TSDL_Color(Color));
      //dest.x := x_pos;
      dest.x := x_pos - 10;
      dest.y := y_pos;
      SDL_BlitSurface(Text, nil, sur, @dest);
      x_pos := x_pos + 20;
    end
    else
    begin
      //if pword[1] <> 20 then
      begin
        Text := TTF_RenderUNICODE_blended(engfont, @pword[1], TSDL_Color(Color));
        //showmessage(inttostr(pword[1]));
        dest.x := x_pos + 10;
        dest.y := y_pos + 4;
        SDL_BlitSurface(Text, nil, sur, @dest);
      end;
      x_pos := x_pos + 10;
    end;
    SDL_FreeSurface(Text);
  end;

end;
//繁体汉字转化成简体汉字

function Traditional2Simplified(mTraditional: string): string; //返回繁体字符串
var
  L: integer;
begin
  L := Length(mTraditional);
  SetLength(Result, L);
  LCMapString(GetUserDefaultLCID,
    LCMAP_SIMPLIFIED_CHINESE, PChar(mTraditional), L, @Result[1], L);
end; {   Traditional2Simplified   }

//显示英文

procedure DrawEngText(sur: PSDL_Surface; word: PUint16; x_pos, y_pos: integer; color: Uint32);
var
  dest: TSDL_Rect;
begin
  Text := TTF_RenderUNICODE_blended(engfont, word, TSDL_Color(Color));
  dest.x := x_pos;
  dest.y := y_pos + 4;
  SDL_BlitSurface(Text, nil, sur, @dest);
  SDL_FreeSurface(Text);

end;

//显示unicode中文阴影文字, 即将同样内容显示2次, 间隔1像素

procedure DrawShadowText(word: PUint16; x_pos, y_pos: integer; color1, color2: Uint32);
begin
  DrawText(screen, word, x_pos + 1, y_pos, color2);
  DrawText(screen, word, x_pos, y_pos, color1);

end;

//显示英文阴影文字

procedure DrawEngShadowText(word: PUint16; x_pos, y_pos: integer; color1, color2: Uint32);
begin
  DrawEngText(screen, word, x_pos + 1, y_pos, color2);
  DrawEngText(screen, word, x_pos, y_pos, color1);

end;

//显示big5文字

procedure DrawBig5Text(sur: PSDL_Surface; str: PChar; x_pos, y_pos: integer; color: Uint32);
var
  len: integer;
  words: WideString;
begin
  len := MultiByteToWideChar(950, 0, PChar(str), -1, nil, 0);
  setlength(words, len - 1);
  MultiByteToWideChar(950, 0, PChar(str), length(str), pwidechar(words), len + 1);
  words := ' ' + words;
  drawtext(screen, @words[1], x_pos, y_pos, color);

end;

//显示big5阴影文字

procedure DrawBig5ShadowText(word: PChar; x_pos, y_pos: integer; color1, color2: Uint32);
var
  len: integer;
  words: WideString;
begin
  len := MultiByteToWideChar(950, 0, PChar(word), -1, nil, 0);
  setlength(words, len - 1);
  MultiByteToWideChar(950, 0, PChar(word), length(word), pwidechar(words), len + 1);
  words := ' ' + words;
  DrawText(screen, @words[1], x_pos + 1, y_pos, color2);
  DrawText(screen, @words[1], x_pos, y_pos, color1);

end;

procedure DrawGBShadowText(word: PChar; x_pos, y_pos: integer; color1, color2: Uint32);
var
  len: integer;
  words: WideString;
begin
  len := MultiByteToWideChar(936, 0, PChar(word), -1, nil, 0);
  setlength(words, len - 1);
  MultiByteToWideChar(936, 0, PChar(word), length(word), pwidechar(words), len + 1);
  words := ' ' + words;
  DrawText(screen, @words[1], x_pos + 1, y_pos, color2);
  DrawText(screen, @words[1], x_pos, y_pos, color1);

end;

//显示带边框的文字, 仅用于unicode, 需自定义宽度

procedure DrawTextWithRect(word: puint16; x, y, w: integer; color1, color2: uint32);
var
  len: integer;
  p: PChar;
begin
  DrawRectangle(x, y, w, 28, 0, colcolor(255), 30);
  DrawShadowText(word, x - 17, y + 2, color1, color2);
  SDL_UpdateRect2(screen, x, y, w + 1, 29);

end;

//画带边框矩形, (x坐标, y坐标, 宽, 高, 内部颜色, 边框颜色, 透明度)

procedure DrawRectangle(x, y, w, h: integer; colorin, colorframe: Uint32; alphe: integer);
var
  i1, i2, l1, l2, l3, l4: integer;
  pix: Uint32;
  pix1, pix2, pix3, pix4, color1, color2, color3, color4: byte;
begin
  if (SDL_MustLock(screen)) then
  begin
    SDL_LockSurface(screen);
  end;
  for i1 := x to x + w do
    for i2 := y to y + h do
    begin
      l1 := (i1 - x) + (i2 - y);
      l2 := -(i1 - x - w) + (i2 - y);
      l3 := (i1 - x) - (i2 - y - h);
      l4 := -(i1 - x - w) - (i2 - y - h);
      if (l1 >= 4) and (l2 >= 4) and (l3 >= 4) and (l4 >= 4) then
      begin
        pix := getpixel(screen, i1, i2);
        pix1 := pix and $FF;
        color1 := colorin and $FF;
        pix2 := pix shr 8 and $FF;
        color2 := colorin shr 8 and $FF;
        pix3 := pix shr 16 and $FF;
        color3 := colorin shr 16 and $FF;
        pix4 := pix shr 24 and $FF;
        color4 := colorin shr 24 and $FF;
        pix1 := (alphe * color1 + (100 - alphe) * pix1) div 100;
        pix2 := (alphe * color2 + (100 - alphe) * pix2) div 100;
        pix3 := (alphe * color3 + (100 - alphe) * pix3) div 100;
        pix4 := (alphe * color4 + (100 - alphe) * pix4) div 100;
        pix := pix1 + pix2 shl 8 + pix3 shl 16 + pix4 shl 24;
        putpixel(screen, i1, i2, pix);
      end;
      if (((l1 >= 4) and (l2 >= 4) and (l3 >= 4) and (l4 >= 4) and ((i1 = x) or (i1 = x + w) or
        (i2 = y) or (i2 = y + h))) or ((l1 = 4) or (l2 = 4) or (l3 = 4) or (l4 = 4))) then
      begin
        putpixel(screen, i1, i2, colorframe);
      end;
    end;
  if (SDL_MustLock(screen)) then
  begin
    SDL_UnlockSurface(screen);
  end;

end;

//画不含边框的矩形, 用于对话和黑屏

procedure DrawRectangleWithoutFrame(x, y, w, h: integer; colorin: Uint32; alphe: integer);
var
  i1, i2: integer;
  pix: Uint32;
  pix1, pix2, pix3, pix4, color1, color2, color3, color4: byte;
begin
  if (SDL_MustLock(screen)) then
  begin
    SDL_LockSurface(screen);
  end;
  for i1 := x to x + w do
    for i2 := y to y + h do
    begin
      pix := getpixel(screen, i1, i2);
      pix1 := pix and $FF;
      color1 := colorin and $FF;
      pix2 := pix shr 8 and $FF;
      color2 := colorin shr 8 and $FF;
      pix3 := pix shr 16 and $FF;
      color3 := colorin shr 16 and $FF;
      pix4 := pix shr 24 and $FF;
      color4 := colorin shr 24 and $FF;
      pix1 := (alphe * color1 + (100 - alphe) * pix1) div 100;
      pix2 := (alphe * color2 + (100 - alphe) * pix2) div 100;
      pix3 := (alphe * color3 + (100 - alphe) * pix3) div 100;
      pix4 := (alphe * color4 + (100 - alphe) * pix4) div 100;
      pix := pix1 + pix2 shl 8 + pix3 shl 16 + pix4 shl 24;
      putpixel(screen, i1, i2, pix);
    end;
  if (SDL_MustLock(screen)) then
  begin
    SDL_UnlockSurface(screen);
  end;

end;

//重画屏幕, SDL_UpdateRect2(screen,0,0,screen.w,screen.h)可显示

procedure Redraw;
begin
  case where of
    0: DrawMMap;
    1: DrawScence;
    2:
    begin
      DrawWholeBField;
      if SEMIREAL = 1 then
        DrawProgress;
    end;
    3:
    begin
      display_img('resource\open.png', 0, 0);
      drawshadowtext(@versionstr[1], 5, 455, colcolor(5), colcolor(7));
    end;
  end;

end;

//显示主地图场景于屏幕

procedure DrawMMap;
var
  i1, i2, i, sum, x, y, k, c: integer;
  temp: array[0..479, 0..479] of smallint;
  Width, Height, yoffset: smallint;
  pos: TPosition;
  BuildingList: array[0..1000] of TPosition;
  CenterList: array[0..1000] of integer;
begin
  if (SDL_MustLock(screen)) then
  begin
    if (SDL_LockSurface(screen) < 0) then
    begin
      MessageBox(0, PChar(Format('Can''t lock screen : %s', [SDL_GetError])), 'Error', MB_OK or MB_ICONHAND);
      exit;
    end;
  end;

  //由上到下绘制, 先绘制地面和表面, 同时计算出现的建筑数目
  k := 0;
  for sum := -29 to 41 do
    for i := -16 to 16 do
    begin
      if k >= 1000 then
        break;
      i1 := Mx + i + (sum div 2);
      i2 := My - i + (sum - sum div 2);
      Pos := GetPositionOnScreen(i1, i2, Mx, My);
      if (i1 >= 0) and (i1 < 480) and (i2 >= 0) and (i2 < 480) then
      begin
        if (sum >= -27) and (sum <= 28) and (i >= -9) and (i <= 9) then
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
              temp[i1, i2] := 2500 + MFace * 7 + MStep
            else
              temp[i1, i2] := 2528 + Mface * 6 + MStep
          else
            temp[i1, i2] := 3714 + MFace * 4 + (MStep + 1) div 2;
          temp[i1, i2] := temp[i1, i2] * 2;
        end;
        if (i1 = Shipy) and (i2 = Shipx) and (InShip = 0) then
        begin
          temp[i1, i2] := 3715 + ShipFace * 4;
          temp[i1, i2] := temp[i1, i2] * 2;
        end;
        if temp[i1, i2] > 0 then
        begin
          BuildingList[k].x := i1;
          BuildingList[k].y := i2;
          Width := smallint(Mpic[MIdx[temp[i1, i2] div 2 - 1]]);
          Height := smallint(Mpic[MIdx[temp[i1, i2] div 2 - 1] + 2]);
          yoffset := smallint(Mpic[MIdx[temp[i1, i2] div 2 - 1] + 6]);
          //根据图片的宽度计算图的中点，为避免出现小数，实际是中点坐标的2倍
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

  if (SDL_MustLock(screen)) then
  begin
    SDL_UnlockSurface(screen);
  end;
  //SDL_UpdateRect2(screen, 0,0,screen.w,screen.h);

end;

//画场景到屏幕

procedure DrawScence;
var
  i1, i2, x, y, xpoint, ypoint: integer;
  dest: tsdl_Rect;
  word: WideString;
  pos: Tposition;
begin
  if (SDL_MustLock(screen)) then
  begin
    if (SDL_LockSurface(screen) < 0) then
    begin
      MessageBox(0, PChar(Format('Can''t lock screen : %s', [SDL_GetError])), 'Error', MB_OK or MB_ICONHAND);
      exit;
    end;
  end;
  if (curscence = 6) or (curscence = 10) or (curscence = 26) or (curscence = 35) or
    (curscence = 52) or (curscence = 71) or (curscence = 72) or (curscence = 78) or
    (curscence = 87) or (curscence = 107) then
  begin
    { dest.x := 0;
     dest.y := 0;
     if (SDL_BlitSurface(blackscreen, nil, screen, @dest) < 0) then
       MessageBox(0, PChar(Format('BlitSurface error : %s', [SDL_GetError])), 'Error', MB_OK or MB_ICONHAND);
     }ShowBlackScreen := True;
  end
  else
    ShowBlackScreen := False;

  //先画无主角的场景, 再画主角
  //如在事件中, 则以Cx, Cy为中心, 否则以主角坐标为中心
  case VideoMemScence of
    0:
    begin
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
        if CurEvent <> begin_Event then
          DrawRoleOnScence(Cx, Cy);
      end;
    end;
    1:
    begin
      DrawScenceWithoutRole(Sx, Sy);
      for i1 := 0 to 63 do
        for i2 := 0 to 63 do
        begin
          pos := getpositiononscreen(i1, i2, Sx, Sy);
          if CurEvent >= 0 then
            pos := getpositiononscreen(i1, i2, Cx, Cy);
          //DrawSPic(SData[CurScence, 0, i1, i2] div 2, pos.x, pos.y, 0, 0, 0, 0);

          if (i1 = Sx) and (i2 = Sy) and (CurEvent < 0) then
            DrawSPic(2501 + SFace * 7 + SStep, pos.x, pos.y - SData[CurScence, 4, Sx, Sy], 0, 0, 0, 0);
          if (i1 = Sx) and (i2 = Sy) and (Curevent >= 0) then
            if (DData[CurScence, CurEvent, 10] = Sx) and (DData[CurScence, CurEvent, 9] = Sy) then
            begin
              if DData[CurScence, CurEvent, 5] <= 0 then
              begin
                DrawSPic(2501 + SFace * 7 + SStep, pos.x, pos.y - SData[CurScence, 4, Sx, Sy], 0, 0, 0, 0);
              end;
            end
            else
            if CurEvent <> begin_Event then
              DrawSPic(2501 + SFace * 7 + SStep, pos.x, pos.y - SData[CurScence, 4, Sx, Sy], 0, 0, 0, 0);

          if (SData[CurScence, 1, i1, i2] > 0) then
            DrawSPic(SData[CurScence, 1, i1, i2] div 2, pos.x, pos.y - SData[CurScence, 4, i1, i2], 0, 0, 0, 0);
          if (SData[CurScence, 2, i1, i2] > 0) then
            DrawSPic(SData[CurScence, 2, i1, i2] div 2, pos.x, pos.y - SData[CurScence, 5, i1, i2], 0, 0, 0, 0);
          if (SData[CurScence, 3, i1, i2] >= 0) and (DData[CurScence, SData[CurScence, 3, i1, i2], 5] > 0) then
            DrawSPic(DData[CurScence, SData[CurScence, 3, i1, i2], 5] div 2, pos.x, pos.y -
              SData[CurScence, 4, i1, i2], 0, 0, 0, 0);

        end;
    end;
  end;

  if (SDL_MustLock(screen)) then
  begin
    SDL_UnlockSurface(screen);
  end;
  //SDL_UpdateRect2(screen, 0,0,screen.w,screen.h);

  if (curscence = 71) then
  begin

    word := formatfloat('0', time div 60) + ':' + formatfloat('00', time mod 60);
    drawshadowtext(@word[1], 5, 5, colcolor(5), colcolor(7));


    if (time <= 0) then
    begin
      instruct_15;
    end;
  end;
end;
//画不含主角的场景(与DrawScenceByCenter相同)

procedure DrawScenceWithoutRole(x, y: integer);
var
  i1, i2, xpoint, ypoint: integer;
begin
  if (SDL_MustLock(screen)) then
  begin
    if (SDL_LockSurface(screen) < 0) then
    begin
      MessageBox(0, PChar(Format('Can''t lock screen : %s', [SDL_GetError])), 'Error', MB_OK or MB_ICONHAND);
      exit;
    end;
  end;

  loadScencePart(-x * 18 + y * 18 + 1151 - CENTER_X, x * 9 + y * 9 + 9 - CENTER_Y + 250);

  if (SDL_MustLock(screen)) then
  begin
    SDL_UnlockSurface(screen);
  end;
  //SDL_UpdateRect2(screen, 0,0,screen.w,screen.h);

end;


procedure DrawBlackScreen;
var
  i1, i2: integer;
  alphe, pix, pix1, pix2, pix3, pix4: Uint32;
begin

  if (SDL_MustLock(screen)) then
  begin
    SDL_LockSurface(screen);
  end;
  for i1 := 0 to screen.w do
    for i2 := 0 to screen.h do
    begin
      alphe := ((i1 - (screen.w shr 1)) * (i1 - (screen.w shr 1)) + (i2 - (screen.h shr 1)) *
        (i2 - (screen.h shr 1))) div 150;
      if alphe > 100 then
        alphe := 100;
      pix := getpixel(screen, i1, i2);
      pix1 := pix and $FF;
      pix2 := pix shr 8 and $FF;
      pix3 := pix shr 16 and $FF;
      pix4 := pix shr 24 and $FF;
      pix1 := ((100 - alphe) * pix1) div 100;
      pix2 := ((100 - alphe) * pix2) div 100;
      pix3 := ((100 - alphe) * pix3) div 100;
      pix4 := ((100 - alphe) * pix4) div 100;
      pix := pix1 + pix2 shl 8 + pix3 shl 16 + pix4 shl 24;
      putpixel(screen, i1, i2, pix);
    end;
  if (SDL_MustLock(screen)) then
  begin
    SDL_UnlockSurface(screen);
  end;
end;


//画主角于场景

procedure DrawRoleOnScence(x, y: integer);
var
  i1, i2, xpoint, ypoint: integer;
  pos, pos1: TPosition;
begin
  if ShowMR then
  begin
    pos := getpositiononscreen(Sx, Sy, x, y);

    DrawSPic2(2501 + SFace * 7 + SStep, pos.x, pos.y - SData[CurScence, 4, Sx, Sy], 0, 100, Sx + Sy, 0, 0);

    //重画主角附近的部分, 考虑遮挡
    //以下假设无高度地面不会产生任何对主角的遮挡
    {for i1 := Sx - 1 to Sx + 10 do
      for i2 := Sy - 1 to Sy + 10 do
      begin
        if (i1 in [0..63]) and (i2 in [0..63]) then
        begin
          pos1 := getpositiononscreen(i1, i2, x, y);
          if (i1 >= Sx) and (i2 >= Sy) and (SData[CurScence, 4, i1, i2] = 0) then
            DrawSPic(SData[CurScence, 0, i1, i2] div 2, pos1.x, pos1.y, pos.x - 20, pos.y - 60 - SData[CurScence, 4, Sx, Sy], 40, 60);
        end;
      end;}
    {for i1 := Sx - 1 to Sx + 10 do
      for i2 := Sy - 1 to Sy + 10 do
      begin
        if (i1 in [0..63]) and (i2 in [0..63]) then
        begin
          pos1 := getpositiononscreen(i1, i2, x, y);

                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                    if (i1 >= Sx) and (i2 >= Sy) { and (SData[CurScence, 4, i1, i1] <> 0)}{then
            DrawSPic(SData[CurScence, 0, i1, i2] div 2, pos1.x, pos1.y, pos.x - 20, pos.y - 60 - SData[CurScence, 4, Sx, Sy], 40, 60);
          if (i1 = Sx) and (i2 = Sy) then
            DrawSPic(2501 + SFace * 7 + SStep, pos.x, pos.y - SData[CurScence, 4, Sx, Sy], pos.x - 20, pos.y - 60 - SData[CurScence, 4, Sx, Sy], 40, 60);
          if (SData[CurScence, 1, i1, i2] > 0) and ((i2 > Sy) or (i1 > Sx)) then
            DrawSPic(SData[CurScence, 1, i1, i2] div 2, pos1.x, pos1.y - SData[CurScence, 4, i1, i2], pos.x - 20, pos.y - 60 - SData[CurScence, 4, Sx, Sy], 40, 60);
          if (SData[CurScence, 2, i1, i2] > 0) and ((i2 > Sy) or (i1 > Sx)) then
            DrawSPic(SData[CurScence, 2, i1, i2] div 2, pos1.x, pos1.y - SData[CurScence, 5, i1, i2], pos.x - 20, pos.y - 60 - SData[CurScence, 4, Sx, Sy], 40, 60);
          if (SData[CurScence, 3, i1, i2] >= 0) and ((i2 > Sy) or (i1 > Sx)) and (DData[CurScence, SData[CurScence, 3, i1, i2], 5] > 0) then
            DrawSPic(DData[CurScence, SData[CurScence, 3, i1, i2], 5] div 2, pos1.x, pos1.y - SData[CurScence, 4, i1, i2], pos.x - 20, pos.y - 60 - SData[CurScence, 4, Sx, Sy], 40, 60);
        end;
      end;}
  end;
end;

//Save the image informations of the whole scence.
//生成场景映像

procedure InitialScence(); overload;
var
  i1, i2, x, y: integer;
  pos: TPosition;
begin
  InitialScence(0);
  {for i1 := 0 to 2303 do
    for i2 := 0 to 1151 do
      ScenceImg[i1, i2] := 0;


  //画场景贴图的顺序应为先整体画出无高度的地面层，再将其他部分一起画出
  //以下使用的顺序可能在墙壁附近会造成少量的遮挡，在画图中应尽量避免这种状况
  //或者使用更合理的3D的顺序
  //for i1 := 0 to 63 do
   // for i2 := 0 to 63 do
    //begin
    //  x := -i1 * 18 + i2 * 18 + 1151;
     // y := i1 * 9 + i2 * 9 + 9;
      //if SData[CurScence, 4, i1, i2] <= 0 then
     // begin
     //   InitialSPic(SData[CurScence, 0, i1, i2] div 2, x, y, 0, 0, 2304, 1152);
    //  end;
   // end;
  for i1 := 0 to 63 do
    for i2 := 0 to 63 do
    begin
      x := -i1 * 18 + i2 * 18 + 1151;
      y := i1 * 9 + i2 * 9 + 9;
      // if SData[CurScence, 4, i1, i2] > 0 then
      InitialSPic(SData[CurScence, 0, i1, i2] div 2, x, y, 0, 0, 2304, 1152);
      if VideoMemScence = 0 then
      begin
        if (SData[CurScence, 1, i1, i2] > 0) then
          InitialSPic(SData[CurScence, 1, i1, i2] div 2, x, y - SData[CurScence, 4, i1, i2], 0, 0, 2304, 1152);


        if (SData[CurScence, 2, i1, i2] > 0) then
          InitialSPic(SData[CurScence, 2, i1, i2] div 2, x, y - SData[CurScence, 5, i1, i2], 0, 0, 2304, 1152);

        if DData[CurScence, SData[CurScence, 3, i1, i2], 7] >= 0 then
          DData[CurScence, SData[CurScence, 3, i1, i2], 7] := DData[CurScence, SData[CurScence, 3, i1, i2], 5];

        if (SData[CurScence, 3, i1, i2] >= 0) and (DData[CurScence, SData[CurScence, 3, i1, i2], 5] > 0) then
          InitialSPic(DData[CurScence, SData[CurScence, 3, i1, i2], 5] div 2, x, y - SData[CurScence, 4, i1, i2], 0, 0, 2304, 1152);
      end;
    end;}
end;

procedure InitialScence(Visible: integer); overload;
var
  i1, i2, x, y, x1, y1, w, h, sumi: integer;
  pos: TPosition;
  temp, now: uint32;
begin
  if CurEvent >= 0 then
  begin
    x1 := -Cx * 18 + Cy * 18 + 1151 - CENTER_X;
    y1 := Cx * 9 + Cy * 9 + 9 - CENTER_Y + 250;
  end
  else
  begin
    x1 := -Sx * 18 + Sy * 18 + 1151 - CENTER_X;
    y1 := Sx * 9 + Sy * 9 + 9 - CENTER_Y + 250;
  end;
  w := screen.w;
  h := screen.h;


  if (curscence = 6) or (curscence = 10) or (curscence = 26) or (curscence = 35) or
    (curscence = 52) or (curscence = 71) or (curscence = 72) or (curscence = 78) or
    (curscence = 87) or (curscence = 107) then
  begin
    x1 := x1 + CENTER_X - 125;
    y1 := y1 + CENTER_Y - 125;
    w := 250;
    h := 250;
  end;

  {if (x1 >= 0) and (x1 + w < 2304) and (y1 >= 0) and (y1 + h < 1152 + 250) then
    for i1 := x1 to x1 + w - 1 do
      for i2 := y1 to y1 + h - 1 do
      begin
        BlockImg[i1, i2] := 0;
      end;}



  if Visible = 0 then
  begin
    x1 := 0;
    y1 := 0;
    w := 2304;
    h := 1152 + 250;
    //temp := sdl_getticks;
    for i1 := x1 to x1 + w - 1 do
      for i2 := y1 to y1 + h - 1 do
      begin
        ScenceImg[i1, i2] := 0;
        ScenceImg2[i1, i2] := 0;
      end;
    //showmessage(inttostr(sdl_getticks-temp));
  end;

  temp := 0;
  if (Visible = 2) and (where = 1) then
    temp := 1;
  for i1 := 0 to 63 do
    for i2 := 0 to 63 do
    begin
      x := -i1 * 18 + i2 * 18 + 1151;
      y := i1 * 9 + i2 * 9 + 9 + 250;
      if SData[CurScence, 4, i1, i2] <= 0 then
        InitialSPic3(SData[CurScence, 0, i1, i2] div 2, x, y, x1, y1, w, h, 1, 0, temp);
      //if (SData[CurScence, 1, i1, i2] > 0) and (SData[CurScence, 4, i1, i2] = 0) then
      //InitialSPic2(SData[CurScence, 1, i1, i2] div 2, x, y, x1, y1, w, h, 1);
      //有高度地面层有可能造成遮挡, 无高度地面层遮挡优先级最低;
    end;

  for sumi := 0 to 63 * 2 do
    for i1 := 0 to 63 do
    begin
      i2 := sumi - i1;
      if (i2 >= 0) and (i2 < 64) then
      begin
        x := -i1 * 18 + i2 * 18 + 1151;
        y := i1 * 9 + i2 * 9 + 9 + 250;
        if SData[CurScence, 4, i1, i2] > 0 then
          InitialSPic3(SData[CurScence, 0, i1, i2] div 2, x, y, x1, y1, w, h, 1, i1 + i2, temp);
        //InitialSPic2(SData[CurScence, 0, i1, i2] div 2, x, y, x1, y1, w, h, 1);
        if VideoMemScence = 0 then
        begin
          if (SData[CurScence, 1, i1, i2] > 0) {and (SData[CurScence, 4, i1, i2] > 0)} then
            InitialSPic3(SData[CurScence, 1, i1, i2] div 2, x, y - SData[CurScence, 4, i1, i2],
              x1, y1, w, h, 1, i1 + i2, temp);
          if (SData[CurScence, 2, i1, i2] > 0) then
            InitialSPic3(SData[CurScence, 2, i1, i2] div 2, x, y - SData[CurScence, 5, i1, i2],
              x1, y1, w, h, 1, i1 + i2, temp);
          if (SData[CurScence, 3, i1, i2] >= 0) and (DData[CurScence, SData[CurScence, 3, i1, i2], 5] > 0) then
            InitialSPic3(DData[CurScence, SData[CurScence, 3, i1, i2], 5] div 2, x, y -
              SData[CurScence, 4, i1, i2], x1, y1, w, h, 1, i1 + i2, temp);
          //if DData[CurScence, SData[CurScence, 3, i1, i2], 7] >= 0 then
          //DData[CurScence, SData[CurScence, 3, i1, i2], 7] := DData[CurScence, SData[CurScence, 3, i1, i2], 5];

          //if (i1 = Sx) and (i2 = Sy) then
          //InitialSPic(2500 + SFace * 7 + SStep, x, y - SData[CurScence, 4, Sx, Sy], x1, y1, w, h);
        end;
      end;
    end;
  if (Visible = 2) and (where = 1) and (x1 >= 0) and (x1 < 2304 - w) and (y1 >= 0) and (y1 < 1152 - h) then
    for i1 := x1 to x1 + w - 1 do
      for i2 := y1 to y1 + h - 1 do
      begin
        ScenceImg[i1, i2] := ScenceImg2[i1, i2];
        BlockImg[i1, i2] := BlockImg2[i1, i2];
      end;
end;


//更改场景映像, 用于动画, 场景内动态效果

procedure UpdateScence(xs, ys: integer);
var
  i1, i2, x, y: integer;
  num, offset: integer;
  xp, yp, w, h: smallint;
begin

  xp := -xs * 18 + ys * 18 + 1151;
  yp := xs * 9 + ys * 9 + 250;
  //如在事件中, 直接给定更新范围
  if CurEvent < 0 then
  begin
    offset := 0;
    num := DData[CurScence, SData[CurScence, 3, xs, ys], 5] div 2;
    if num > 0 then
      offset := SIdx[num - 1];
    xp := xp - (SPic[offset + 4] + 256 * SPic[offset + 5]) - 3;
    yp := yp - (SPic[offset + 6] + 256 * SPic[offset + 7]) - 3 - SData[CurScence, 4, xs, ys];
    w := (SPic[offset] + 256 * SPic[offset + 1]) + 20;
    h := (SPic[offset + 2] + 256 * SPic[offset + 3]) + 6;
  end;
  if (CurEvent >= 0) or (num <= 0) then
  begin
    xp := xp - 30;
    yp := yp - 120;
    w := 100;
    h := 130;
  end;
  //计算贴图高度和宽度, 作为更新范围
  offset := max(h div 18, w div 36);

  for i1 := xs - offset to xs + 10 do
    for i2 := ys - offset to ys + 10 do
    begin
      x := -i1 * 18 + i2 * 18 + 1151;
      y := i1 * 9 + i2 * 9 + 9 + 250;

      InitialSPic(SData[CurScence, 0, i1, i2] div 2, x, y, xp, yp, w, h);
      if (i1 < 0) or (i2 < 0) or (i1 > 63) or (i2 > 63) then
        InitialSPic(0, x, y, xp, yp, w, h)
      else
      begin
        //InitialSPic(SData[CurScence, 0, i1,i2] div 2,x,y,xp,yp,w,h);
        if (SData[CurScence, 1, i1, i2] > 0) then
          InitialSPic(SData[CurScence, 1, i1, i2] div 2, x, y - SData[CurScence, 4, i1, i2], xp, yp, w, h);
        //if (i1=Sx) and (i2=Sy) then
        //InitialSPic(BEGIN_WALKPIC+SFace*7+SStep,x,y-SData[CurScence, 4, i1,i2],0,0,2304,1152);
        if (SData[CurScence, 2, i1, i2] > 0) then
          InitialSPic(SData[CurScence, 2, i1, i2] div 2, x, y - SData[CurScence, 5, i1, i2], xp, yp, w, h);
        if (SData[CurScence, 3, i1, i2] >= 0) and (DData[CurScence, SData[CurScence, 3, i1, i2], 5] > 0) then
          InitialSPic(DData[CurScence, SData[CurScence, 3, i1, i2], 5] div 2, x, y -
            SData[CurScence, 4, i1, i2], xp, yp, w, h);
        //if (i1=RScence[CurScence*26+15]) and (i2=RScence[CurScence*26+14]) then
        //DrawSPic(0,-(i1-Sx)*18+(i2-Sy)*18+CENTER_X,(i1-Sx)*9+(i2-Sy)*9+CENTER_Y);
        //if (i1=Sx) and (i2=Sy) then DrawSPic(2500+SFace*7+SStep,CENTER_X,CENTER_Y-SData[CurScence, 4, i1,i2]);
      end;
    end;

end;


//将场景映像画到屏幕

procedure LoadScencePart(x, y: integer);
var
  i1, i2: integer;
  alphe, pix, pix1, pix2, pix3, pix4: Uint32;
begin

  if (x < 0) or (x >= 2304 - CENTER_X) then
    SDL_FillRect(screen, nil, 0);

  for i1 := 0 to screen.w - 1 do
    for i2 := 0 to screen.h - 1 do
    begin
      alphe := snowalpha[i2][i1];
      pix := scenceimg[x + i1, y + i2];


      if ShowBlackScreen = True then
      begin
        if alphe = 100 then
          pix := 0
        else if alphe <> 0 then
        begin
          pix1 := pix and $FF;
          pix2 := pix shr 8 and $FF;
          pix3 := pix shr 16 and $FF;
          pix4 := pix shr 24 and $FF;
          pix1 := ((100 - alphe) * pix1) div 100;
          pix2 := ((100 - alphe) * pix2) div 100;
          pix3 := ((100 - alphe) * pix3) div 100;
          pix4 := ((100 - alphe) * pix4) div 100;
          pix := pix1 + pix2 shl 8 + pix3 shl 16 + pix4 shl 24;
        end;
      end;
      if (x + i1 >= 0) and (y + i2 >= 0) and (x + i1 < 2304) and (y + i2 < 1152 + 250) then
      begin
        putpixel(screen, i1, i2, pix);
        BlockScreen[i1 * screen.h + i2] := BlockImg[x + i1, y + i2];
      end
      else
      begin
        putpixel(screen, i1, i2, 0);
        BlockScreen[i1 * screen.h + i2] := 0;
      end;
    end;
end;

//画战场

procedure DrawWholeBField;
var
  i, i1, i2: integer;
  pos: TPosition;
begin
  if (SDL_MustLock(screen)) then
  begin
    if (SDL_LockSurface(screen) < 0) then
    begin
      MessageBox(0, PChar(Format('Can''t lock screen : %s', [SDL_GetError])), 'Error', MB_OK or MB_ICONHAND);
      exit;
    end;
  end;
  case VideoMemBattle of
    0:
    begin
      DrawBFieldWithoutRole(Bx, By);
      for i1 := 0 to 63 do
        for i2 := 0 to 63 do
        begin
          if (Bfield[2, i1, i2] >= 0) and (Brole[Bfield[2, i1, i2]].Dead = 0) then
            DrawRoleOnBfield(i1, i2);
        end;
    end;
    1:
    begin
      DrawBFieldWithoutRole(Bx, By);
      for i1 := 0 to 63 do
        for i2 := 0 to 63 do
        begin
          pos := GetPositionOnScreen(i1, i2, Bx, By);
          //if (bfield[0, i1, i2] > 0) then
          //DrawBPic(Bfield[0, i1, i2] div 2, pos.x, pos.y, 0);
          if (bfield[1, i1, i2] > 0) then
            DrawBPic(Bfield[1, i1, i2] div 2, pos.x, pos.y, 0);
          if (Bfield[2, i1, i2] >= 0) and (Brole[Bfield[2, i1, i2]].Dead = 0) then
            DrawBPic(Rrole[Brole[Bfield[2, i1, i2]].rnum].HeadNum * 4 + Brole[Bfield[2, i1, i2]].Face +
              BEGIN_BATTLE_ROLE_PIC, pos.x, pos.y, 0);
        end;
    end;
  end;


  if (SDL_MustLock(screen)) then
  begin
    SDL_UnlockSurface(screen);
  end;
end;

//画不含主角的战场

procedure DrawBFieldWithoutRole(x, y: integer);
var
  i1, i2, xpoint, ypoint: integer;
begin
  if (SDL_MustLock(screen)) then
  begin
    if (SDL_LockSurface(screen) < 0) then
    begin
      MessageBox(0, PChar(Format('Can''t lock screen : %s', [SDL_GetError])), 'Error', MB_OK or MB_ICONHAND);
      exit;
    end;
  end;

  loadBfieldPart(-x * 18 + y * 18 + 1151 - CENTER_X, x * 9 + y * 9 + 9 - CENTER_Y + 250);

  if (SDL_MustLock(screen)) then
  begin
    SDL_UnlockSurface(screen);
  end;
  //SDL_UpdateRect2(screen, 0,0,screen.w,screen.h);

end;

//画战场上人物, 需更新人物身前的遮挡

procedure DrawRoleOnBfield(x, y: integer);
var
  i1, i2, xpoint, ypoint: integer;
  pos, pos1: Tposition;
begin
  if (SDL_MustLock(screen)) then
  begin
    if (SDL_LockSurface(screen) < 0) then
    begin
      MessageBox(0, PChar(Format('Can''t lock screen : %s', [SDL_GetError])), 'Error', MB_OK or MB_ICONHAND);
      exit;
    end;
  end;

  pos := GetPositionOnScreen(x, y, Bx, By);
  DrawBPic2(Rrole[Brole[Bfield[2, x, y]].rnum].HeadNum * 4 + Brole[Bfield[2, x, y]].Face +
    BEGIN_BATTLE_ROLE_PIC, pos.x, pos.y, 0, 75, x + y, 0, 0);

  {for i1 := x to x + 10 do
    for i2 := y to y + 10 do
    begin
      if (i1 = x) and (i2 = y) then
        DrawBPic(Rrole[Brole[Bfield[2, x, y]].rnum].HeadNum * 4 + Brole[Bfield[2, x, y]].Face + BEGIN_BATTLE_ROLE_PIC, pos.x, pos.y, 0);

      if (Bfield[1, i1, i2] > 0) then
      begin
        pos1 := GetPositionOnScreen(i1, i2, Bx, By);
        DrawBPicInRect(Bfield[1, i1, i2] div 2, pos1.x, pos1.y, 0, pos.x - 20, pos.y - 60, 40, 60);
      end;
      // if (Bfield[2,i1, i2] >= 0) and (Brole[Bfield[2, i1, i2]].Dead = 0) then
      // begin
       //  pos1 := GetPositionOnScreen(i1, i2, Bx, By);
      //   DrawBPicInRect(Rrole[Brole[Bfield[2, i1, i2]].rnum].HeadNum * 4 + Brole[Bfield[2, i1, i2]].Face + BEGIN_BATTLE_ROLE_PIC, pos1.x, pos1.y, 0, pos.x - 20, pos.y - 60, 40, 60);
      // end;
    end;}

  if (SDL_MustLock(screen)) then
  begin
    SDL_UnlockSurface(screen);
  end;

end;

//初始化战场映像

procedure InitialWholeBField;
var
  i1, i2, x, y: integer;
begin
  for i1 := 0 to 2303 do
    for i2 := 0 to 1151 + 250 do
    begin
      BfieldImg[i1, i2] := 0;
      BlockImg[i1, i2] := -1;
    end;
  {for i1 := 0 to 63 do
    for i2 := 0 to 63 do
    begin
      x := -i1 * 18 + i2 * 18 + 1151;
      y := i1 * 9 + i2 * 9 + 9;
      if (i1 < 0) or (i2 < 0) or (i1 > 63) or (i2 > 63) then
        InitialBPic(0, x, y)
      else
      begin
        InitialBPic(bfield[0, i1, i2] div 2, x, y);
        if (bfield[1, i1, i2] > 0) and (VideoMemBattle = 0) then
          InitialBPic(bfield[1, i1, i2] div 2, x, y);
      end;
    end;}

  for i1 := 0 to 63 do
    for i2 := 0 to 63 do
    begin
      x := -i1 * 18 + i2 * 18 + 1151;
      y := i1 * 9 + i2 * 9 + 9 + 250;
      if (i1 < 0) or (i2 < 0) or (i1 > 63) or (i2 > 63) then
      begin
        InitialBPic2(0, x, y, 0, 0);
      end
      else
      begin
        InitialBPic2(bfield[0, i1, i2] div 2, x, y, 1, 0);
        if (bfield[1, i1, i2] > 0) then
          InitialBPic2(bfield[1, i1, i2] div 2, x, y, 1, i1 + i2);
      end;
    end;

end;

//将战场映像画到屏幕

{procedure LoadBFieldPart(x, y: integer);
var
  i1, i2: integer;
begin
  for i1 := 0 to screen.w - 1 do
    for i2 := 0 to screen.h - 1 do
      if (x + i1 >= 0) and (y + i2 >= 0) and (x + i1 < 2304) and (y + i2 < 1152) then
        putpixel(screen, i1, i2, Bfieldimg[x + i1, y + i2])
      else
        putpixel(screen, i1, i2, 0);

end;}

procedure LoadBFieldPart(x, y: integer);
var
  i1, i2: integer;
begin
  if (x < 0) or (x >= 2304 - CENTER_X) then
    SDL_FillRect(screen, nil, 0);
  for i1 := 0 to screen.w - 1 do
    for i2 := 0 to screen.h - 1 do
      if (x + i1 >= 0) and (y + i2 >= 0) and (x + i1 < 2304) and (y + i2 < 1152 + 250) then
      begin
        putpixel(screen, i1, i2, Bfieldimg[x + i1, y + i2]);
        BlockScreen[i1 * screen.h + i2] := BlockImg[x + i1, y + i2];
        //showmessage(inttostr(BlockScreen[i1, i2]));
      end
      else
      begin
        putpixel(screen, i1, i2, 0);
        BlockScreen[i1 * screen.h + i2] := 0;
      end;

end;

//利用遮挡信息中记录的建筑所占据的像素位置, 直接载入建筑的部分, 速度比直接画RLE8快

procedure LoadBFieldPart2(x, y, alpha: integer);
var
  i1, i2: integer;
  pix, pix1, pix2, pix3, pix4, colorin, color1, color2, color3, color4: Uint32;
begin
  for i1 := 0 to screen.w - 1 do
    for i2 := 0 to screen.h - 1 do
      if (x + i1 >= 0) and (y + i2 >= 0) and (x + i1 < 2304) and (y + i2 < 1152 + 250) and
        (BlockScreen[i1 * screen.h + i2] <> 0) then
      begin
        pix := Bfieldimg[x + i1, y + i2];
        if alpha <> 0 then
        begin
          colorin := getpixel(screen, i1, i2);
          pix1 := pix and $FF;
          color1 := colorin and $FF;
          pix2 := pix shr 8 and $FF;
          color2 := colorin shr 8 and $FF;
          pix3 := pix shr 16 and $FF;
          color3 := colorin shr 16 and $FF;
          pix4 := pix shr 24 and $FF;
          color4 := colorin shr 24 and $FF;
          pix1 := (alpha * color1 + (100 - alpha) * pix1) div 100;
          pix2 := (alpha * color2 + (100 - alpha) * pix2) div 100;
          pix3 := (alpha * color3 + (100 - alpha) * pix3) div 100;
          pix4 := (alpha * color4 + (100 - alpha) * pix4) div 100;
          pix := pix1 + pix2 shl 8 + pix3 shl 16 + pix4 shl 24;
        end;
        putpixel(screen, i1, i2, pix);
      end;

end;

//画带光标的子程
//此子程效率不高

procedure DrawBFieldWithCursor(AttAreaType, step, range: integer);
var
  i, i1, i2, bnum, minstep, shadow: integer;
  pos: TPosition;
begin
  if (SDL_MustLock(screen)) then
  begin
    if (SDL_LockSurface(screen) < 0) then
    begin
      MessageBox(0, PChar(Format('Can''t lock screen : %s', [SDL_GetError])), 'Error', MB_OK or MB_ICONHAND);
      exit;
    end;
  end;

  SetAminationPosition(AttAreaType, step, range);
  for i1 := 0 to 63 do
    for i2 := 0 to 63 do
    begin
      if Bfield[0, i1, i2] > 0 then
      begin
        pos := GetpositionOnScreen(i1, i2, Bx, By);
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
        DrawBPic(Bfield[0, i1, i2] div 2, pos.x, pos.y, shadow);
      end;
    end;


  loadBfieldPart2(-Bx * 18 + By * 18 + 1151 - CENTER_X, Bx * 9 + By * 9 + 9 - CENTER_Y + 250, 0);

  for i1 := 0 to 63 do
    for i2 := 0 to 63 do
    begin
      pos := getpositiononScreen(i1, i2, Bx, By);
      {if Bfield[1, i1, i2] > 0 then
        DrawBPic(Bfield[1, i1, i2] div 2, pos.x, pos.y, 0);}
      bnum := Bfield[2, i1, i2];

      if (bnum >= 0) and (Brole[bnum].Dead = 0) then
      begin
        //0-范围内敌方, 1-范围内我方, 2-敌方全部, 3-我方全部, 4-自身, 5-范围内全部, 6-全部，7-不高亮
        case SelectAimMode of
          0:
            if (Bfield[4, i1, i2] > 0) and (Brole[bnum].Team <> 0) then
              HighLight := True;
          1:
            if (Bfield[4, i1, i2] > 0) and (Brole[bnum].Team = 0) then
              HighLight := True;
          2:
            if (Brole[bnum].Team <> 0) then
              HighLight := True;
          3:
            if (Brole[bnum].Team = 0) then
              HighLight := True;
          4:
            if (i1 = Bx) and (i2 = By) then
              HighLight := True;
          5:
            if (Bfield[4, i1, i2] > 0) then
              HighLight := True;
          6:
            HighLight := True;
          7:
            HighLight := False;
        end;
        //DrawBPic(Rrole[Brole[bnum].rnum].HeadNum * 4 + Brole[bnum].Face + BEGIN_BATTLE_ROLE_PIC, pos.x, pos.y, 0);
        DrawBPic2(Rrole[Brole[bnum].rnum].HeadNum * 4 + Brole[bnum].Face + BEGIN_BATTLE_ROLE_PIC,
          pos.x, pos.y, 0, 75, i1 + i2, 0, 0);
        HighLight := False;
      end;
    end;
  if (SDL_MustLock(screen)) then
  begin
    SDL_UnlockSurface(screen);
  end;

end;


//画带效果的战场

procedure DrawBFieldWithEft(Epicnum: integer); overload;
var
  i, i1, i2: integer;
  pos: TPosition;
begin
  {if (SDL_MustLock(screen)) then
  begin
    if (SDL_LockSurface(screen) < 0) then
    begin
      MessageBox(0, PChar(Format('Can''t lock screen : %s', [SDL_GetError])), 'Error', MB_OK or MB_ICONHAND);
      exit;
    end;
  end;}
  {DrawBfieldWithoutRole(Bx, By);

  for i1 := 0 to 63 do
    for i2 := 0 to 63 do
    begin
      pos := getpositiononScreen(i1, i2, Bx, By);
      if (Bfield[2, i1, i2] >= 0) and (Brole[Bfield[2, i1, i2]].Dead = 0) then
        DrawRoleOnBField(i1, i2);
    end;}
  DrawBfieldWithoutRole(Bx, By);

  for i1 := 0 to 63 do
    for i2 := 0 to 63 do
    begin
      pos := getpositiononScreen(i1, i2, Bx, By);
      if (Bfield[2, i1, i2] >= 0) and (Brole[Bfield[2, i1, i2]].Dead = 0) then
        DrawRoleOnBField(i1, i2);
      if Bfield[4, i1, i2] > 0 then
        DrawEPic(Epicnum, pos.x, pos.y);
    end;
  {if (SDL_MustLock(screen)) then
  begin
    SDL_UnlockSurface(screen);
  end;}

end;

procedure DrawBFieldWithEft(Epicnum, beginpic, endpic, curlevel: integer); overload;
var
  k, i1, i2: integer;
  pos: TPosition;
begin
  DrawBfieldWithoutRole(Bx, By);

  for i1 := 0 to 63 do
    for i2 := 0 to 63 do
    begin
      pos := getpositiononScreen(i1, i2, Bx, By);
      if (Bfield[2, i1, i2] >= 0) and (Brole[Bfield[2, i1, i2]].Dead = 0) then
        DrawRoleOnBField(i1, i2);
      if Bfield[4, i1, i2] > 0 then
      begin
        k := Epicnum + curlevel - Bfield[4, i1, i2];
        if (k >= beginpic) and (k <= endpic) then
        begin
          DrawEPic(k, pos.x, pos.y);
          //writeln(k, ' ',curlevel, ' ', beginpic, ' ' ,endpic);
        end;
      end;
    end;

end;


//画带人物动作的战场

procedure DrawBFieldWithAction(bnum, Apicnum: integer);
var
  i, i1, ii1, ii2, i2: integer;
  pos, pos1: TPosition;
begin
  if (SDL_MustLock(screen)) then
  begin
    if (SDL_LockSurface(screen) < 0) then
    begin
      MessageBox(0, PChar(Format('Can''t lock screen : %s', [SDL_GetError])), 'Error', MB_OK or MB_ICONHAND);
      exit;
    end;
  end;

  case VideoMemBattle of
    0:
    begin
      DrawBfieldWithoutRole(Bx, By);
      for i1 := 0 to 63 do
        for i2 := 0 to 63 do
        begin
          if (Bfield[2, i1, i2] = bnum) then
          begin
            pos := GetPositionOnScreen(i1, i2, Bx, By);
            for ii1 := i1 to i1 + 10 do
              for ii2 := i2 to i2 + 10 do
              begin
                pos1 := GetPositionOnScreen(ii1, ii2, Bx, By);
                if (i1 = ii1) and (i2 = ii2) then
                  DrawFPic(apicnum, pos.x, pos.y);
                if (Bfield[1, ii1, ii2] > 0) then
                begin
                  DrawBPicInRect(Bfield[1, ii1, ii2] div 2, pos1.x, pos1.y, 0, pos.x - 20, pos.y - 60, 40, 60);
                end;
              end;
          end
          else if (Bfield[2, i1, i2] >= 0) and (Brole[Bfield[2, i1, i2]].Dead = 0) and
            (Bfield[2, i1, i2] <> bnum) then
          begin
            DrawRoleOnBfield(i1, i2);
          end;
        end;
    end;
    1:
    begin
      DrawBFieldWithoutRole(Bx, By);
      for i1 := 0 to 63 do
        for i2 := 0 to 63 do
        begin
          pos := GetPositionOnScreen(i1, i2, Bx, By);
          //DrawBPic(bfield[0, i1, i2] div 2, pos.x, pos.y, 0);
          if (bfield[1, i1, i2] > 0) then
            DrawBPic(bfield[1, i1, i2] div 2, pos.x, pos.y, 0);
          if (Bfield[2, i1, i2] >= 0) and (Brole[Bfield[2, i1, i2]].Dead = 0) then
            if Bfield[2, i1, i2] = bnum then
              DrawFPic(apicnum, pos.x, pos.y)
            else
              DrawBPic(Rrole[Brole[Bfield[2, i1, i2]].rnum].HeadNum * 4 + Brole[Bfield[2, i1, i2]].Face +
                BEGIN_BATTLE_ROLE_PIC, pos.x, pos.y, 0);
        end;
    end;
  end;

  if (SDL_MustLock(screen)) then
  begin
    SDL_UnlockSurface(screen);
  end;

end;


//简体汉字转化成繁体汉字

function Simplified2Traditional(mSimplified: string): string; //返回繁体字符串   //Win98下无效
var
  L: integer;
begin
  L := Length(mSimplified);
  SetLength(Result, L);
  LCMapString(GetUserDefaultLCID,
    LCMAP_TRADITIONAL_CHINESE, PChar(mSimplified), L, @Result[1], L);
end; {   Simplified2Traditional   }




procedure ShowMap;
var
  i, u, n, x, y, l, p: integer;
  str1, str, strboat: WideString;
  str2, str3: array of WideString;
  scencex: array of integer;
  scencey: array of integer;
  scencenum: array of integer;
  map_pic: Psdl_surface;
  dest1, dest: Tsdl_rect;
begin
  event.key.keysym.sym := 0;
  event.button.button := 0;
  n := 0;
  p := 0;
  u := 0;
  if fileexists('resource\map') then
    Map_Pic := IMG_Load('resource\map');

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
    str2[u - 1] := big5tounicode(@Rscence[i].Name[0]);
    str3[u - 1] := format('%3d, %3d', [Rscence[i].MainEntranceY1, Rscence[i].MainEntranceX1]);

  end;
  str := ' 你的位置';
  strboat := ' 船的位置';
  while SDL_PollEvent(@event) >= 0 do
  begin
    if (n mod 10 = 0) then
    begin

      dest1.x := 0;
      dest1.y := 30;
      dest1.w := 640;
      dest1.h := 380;
      dest.x := 0;
      dest.y := 30;
      SDL_BlitSurface(Map_Pic, @dest1, screen, @dest);
      //  if i = p then continue;
      for i := 0 to u - 1 do
      begin
        x := 313 + ((scencey[i] - scencex[i]) * 5) div 8;
        y := 63 + ((scencey[i] + scencex[i]) * 5) div 16;
        dest1.x := 15;
        dest1.y := 0;
        dest1.w := 15;
        dest1.h := 15;
        dest.x := x;
        dest.y := y;
        SDL_BlitSurface(Map_Pic, @dest1, screen, @dest);

        if (x < round(event.button.x / (RealScreen.w / screen.w))) and (x + 15 >
          round(event.button.x / (RealScreen.w / screen.w))) and (y < round(event.button.y /
          (RealScreen.h / screen.h))) and (y + 15 > round(event.button.y / (RealScreen.h / screen.h))) then
        begin
          p := i;
        end;
      end;
      x := 313 + ((scencey[p] - scencex[p]) * 5) div 8;
      y := 63 + ((scencey[p] + scencex[p]) * 5) div 16;
      dest1.x := 30;
      dest1.y := 0;
      dest1.w := 15;
      dest1.h := 15;
      dest.x := x;
      dest.y := y;
      SDL_BlitSurface(Map_Pic, @dest1, screen, @dest);
      SDL_BlitSurface(Map_Pic, @dest1, screen, @dest);
      x := 313 + ((Shipx - Shipy) * 5) div 8;
      y := 63 + ((Shipx + Shipy) * 5) div 16;

      dest1.x := 45;
      dest1.y := 0;
      dest1.w := 15;
      dest1.h := 15;
      dest.x := x;
      dest.y := y;
      SDL_BlitSurface(Map_Pic, @dest1, screen, @dest);
      SDL_BlitSurface(Map_Pic, @dest1, screen, @dest);

      drawshadowtext(@str2[p][1], 17, 80, colcolor(21), colcolor(25));
      drawengshadowtext(@str3[p][1], 37, 100, colcolor(255), colcolor(254));


      drawshadowtext(@str[1], 17, 275, colcolor(21), colcolor(25));
      str1 := format('%3d, %3d', [My, Mx]);
      drawengshadowtext(@str1[1], 37, 295, colcolor(255), colcolor(254));

      drawshadowtext(@strboat[1], 17, 325, colcolor(21), colcolor(25));
      str1 := format('%3d, %3d', [shipx, shipy]);
      drawengshadowtext(@str1[1], 37, 345, colcolor(255), colcolor(254));

    end;
    if n mod 20 = 1 then
    begin
      x := 313 + ((my - mx) * 5) div 8;
      y := 63 + ((my + mx) * 5) div 16;
      dest1.x := 0;
      dest1.y := 0;
      dest1.w := 15;
      dest1.h := 15;
      dest.x := x;
      dest.y := y;
      SDL_BlitSurface(Map_Pic, @dest1, screen, @dest);
      SDL_BlitSurface(Map_Pic, @dest1, screen, @dest);

    end;
    SDL_UpdateRect2(screen, 0, 0, 640, 440);
    sdl_delay(20);
    n := n + 1;
    if n = 1000 then
      n := 0;
    CheckBasicEvent;
    case event.type_ of
      //方向键使用压下按键事件
      SDL_KEYUP:
      begin
        if (event.key.keysym.sym = sdlk_escape) or (event.key.keysym.sym = sdlk_return) or
          (event.key.keysym.sym = sdlk_space) then
          break;
        if (event.key.keysym.sym = sdlk_left) or (event.key.keysym.sym = sdlk_up) then
        begin
          if u <> 0 then
          begin
            p := p - 1;
            if p <= -1 then
              p := u - 1;
          end;
        end;
        if (event.key.keysym.sym = sdlk_right) or (event.key.keysym.sym = sdlk_down) then
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
        if event.button.button = sdl_button_right then
          break;
      SDL_MOUSEMotion:
      begin
        for i := 0 to length(scencey) - 1 do
        begin
          x := 313 + ((scencey[i] - scencex[i]) * 5) div 8;
          y := 63 + ((scencey[i] + scencex[i]) * 5) div 16;
          if (x < round(event.button.x / (RealScreen.w / screen.w))) and (x + 15 >
            round(event.button.x / (RealScreen.w / screen.w))) and
            (y < round(event.button.y / (RealScreen.h / screen.h))) and (y + 15 >
            round(event.button.y / (RealScreen.h / screen.h))) then
          begin
            p := i;
          end;
        end;

      end;
    end;
  end;

  SDL_FreeSurface(Map_Pic);
end;

procedure DrawPartPic(pic: psdl_surface; x, y, w, h, x1, y1: integer);
var
  dest1, dest: Tsdl_rect;
begin
  dest1.x := x;
  dest1.y := y;
  dest1.w := w;
  dest1.h := h;
  dest.x := x1;
  dest.y := y1;
  SDL_BlitSurface(Pic, @dest1, screen, @dest);
end;


procedure ZoomPic(scr: Psdl_surface; x, y, w, h: integer);
var
  a, b: double;
  dest, sest: tsdl_Rect;
  temp: psdl_surface;
begin
  a := w / scr.w;
  b := h / scr.h;
  dest.x := x;
  dest.y := y;
  dest.w := w;
  dest.h := h;
  temp := zoomSurface(scr, a, b, 0);
  SDL_BlitSurface(temp, nil, screen, @dest);
  sdl_freesurface(temp);
end;

procedure PlayBeginningMovie;
var
  i, grp, idx, len: integer;
  MOV: psdl_surface;
  MOVpic: array of byte;
  MOVidx: array of integer;
begin
  //PlayMp3(1,-1);
  //sdl_delay(500);
  SDL_ShowCursor(SDL_DISABLE);
  if (fileexists('Logo') and fileexists('Txdx')) then
  begin
    grp := fileopen('Logo', fmopenread);
    len := fileseek(grp, 0, 2);
    fileseek(grp, 0, 0);
    Setlength(MOVpic, len);
    fileread(grp, MOVpic[0], len);
    fileclose(grp);

    idx := fileopen('Txdx', fmopenread);
    len := fileseek(idx, 0, 2);
    fileseek(idx, 0, 0);
    Setlength(MOVidx, (len div 4));
    fileread(idx, MOVidx[0], len);
    fileclose(idx);
    MOV := GetPngPic(@MOVPic[0], @MOVidx[0], 1);

    for i := 1 to MOVidx[0] - 1 do
    begin
      while Sdl_pollevent(@event) > 0 do
        CheckBasicEvent;
      MOV := GetPngPic(@MOVPic[0], @MOVidx[0], i);
      ZoomPic(MOV, (screen.w - mov.w) div 2, (screen.h - mov.h) div 2, MOV.w, MOV.h);
      if i * 5 < 100 then
      begin
        drawrectanglewithoutframe(0, 0, screen.w, screen.h, 0, 100 - (i * 5));
        sdl_delay(20);
      end
      else
        sdl_delay(50);
      SDL_UpdateRect2(screen, 0, 0, screen.w, screen.h);
      SDL_freeSurface(MOV);
    end;
    Setlength(MOVpic, 0);
    Setlength(MOVIDX, 0);
    //Setlength(BGidx, 0);
  end;
  sdl_delay(1500);
  for i := 0 to 20 do
  begin
    while Sdl_pollevent(@event) > 0 do
      CheckBasicEvent;
    drawrectanglewithoutframe(0, 0, screen.w, screen.h, 0, i * 5);
    sdl_delay(20);
    SDL_UpdateRect2(screen, 0, 0, screen.w, screen.h);
    //Setlength(BGidx, 0);
  end;
  SDL_ShowCursor(SDL_ENABLE);
end;

function GetPngPic(pic: pbyte; idx: pint; num: integer): Psdl_Surface;
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
  Result := readpicfrombyte(pic, len);
end;

function ReadPicFromByte(p_byte: Pbyte; size: integer): Psdl_Surface;
begin
  Result := IMG_Load_RW(SDL_RWFromMem(p_byte, size), 1);
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

//判定场景内某个位置能否行走

function CanWalkInScence(x, y: integer): boolean; overload;
begin
  Result := True;
  if (SData[CurScence, 1, x, y] <= 0) and (SData[CurScence, 1, x, y] >= -2) then
    Result := True
  else
    Result := False;
  if (abs(SData[CurScence, 4, x, y] - SData[CurScence, 4, sx, sy]) > 10) then
    Result := False;
  if (SData[CurScence, 3, x, y] >= 0) and (Result) and (DData[CurScence, SData[CurScence, 3, x, y], 0] = 1) then
    Result := False;
  //直接判定贴图范围
  if ((SData[CurScence, 0, x, y] >= 358) and (SData[CurScence, 0, x, y] <= 362)) or
    (SData[CurScence, 0, x, y] = 522) or (SData[CurScence, 0, x, y] = 1022) or
    ((SData[CurScence, 0, x, y] >= 1324) and (SData[CurScence, 0, x, y] <= 1330)) or
    (SData[CurScence, 0, x, y] = 1348) then
    Result := False;
  //if SData[CurScence, 0, x, y] = 1358 * 2 then result := true;

end;

function CanWalkInScence(x1, y1, x, y: integer): boolean; overload;
begin
  Result := True;
  if (SData[CurScence, 1, x, y] <= 0) and (SData[CurScence, 1, x, y] >= -2) then
    Result := True
  else
    Result := False;
  if (abs(SData[CurScence, 4, x, y] - SData[CurScence, 4, x1, y1]) > 10) then
    Result := False;
  if (SData[CurScence, 3, x, y] >= 0) and (Result) and (DData[CurScence, SData[CurScence, 3, x, y], 0] = 1) then
    Result := False;
  //直接判定贴图范围
  if ((SData[CurScence, 0, x, y] >= 358) and (SData[CurScence, 0, x, y] <= 362)) or
    (SData[CurScence, 0, x, y] = 522) or (SData[CurScence, 0, x, y] = 1022) or
    ((SData[CurScence, 0, x, y] >= 1324) and (SData[CurScence, 0, x, y] <= 1330)) or
    (SData[CurScence, 0, x, y] = 1348) then
    Result := False;
  //if SData[CurScence, 0, x, y] = 1358 * 2 then result := true;

end;

procedure findway(x1, y1: integer);
var
  Xlist: array[0..4096] of smallint;
  Ylist: array[0..4096] of smallint;
  steplist: array[0..4096] of smallint;
  curgrid, totalgrid: integer;
  Bgrid: array[1..4] of integer; //0空位，1可过，2已走过 ,3越界
  Xinc, Yinc: array[1..4] of integer;
  curX, curY, curstep, nextX, nextY: integer;
  i, i1, i2, i3: integer;

begin
  Xinc[1] := 0;
  Xinc[2] := 1;
  Xinc[3] := -1;
  Xinc[4] := 0;
  Yinc[1] := -1;
  Yinc[2] := 0;
  Yinc[3] := 0;
  Yinc[4] := 1;
  curgrid := 0;
  totalgrid := 0;
  Xlist[totalgrid] := x1;
  Ylist[totalgrid] := y1;
  steplist[totalgrid] := 0;
  totalgrid := totalgrid + 1;
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
            Bgrid[i] := 3
          else if Fway[nextX, nextY] >= 0 then
            Bgrid[i] := 2
          else if not canwalkinScence(cury, curx, nexty, nextx) then
            Bgrid[i] := 1
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
            ((earth[nextx, nexty] >= 506) and (earth[nextx, nexty] <= 670)) or
            ((earth[nextx, nexty] >= 1016) and (earth[nextx, nexty] <= 1022)) then
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
    end;
    curgrid := curgrid + 1;
    if (where = 0) and (curX - MX > 22) and (curY - My > 22) then
      break;
  end;
end;



procedure SDL_UpdateRect2(scr1: PSDL_Surface; x, y, w, h: integer);
var
  realx, realy, realw, realh, ZoomType: integer;
  tempscr: Psdl_surface;
  now, Next: Uint32;
  destsrc, dest: TSDL_Rect;
  TextureID: GLUint;
begin
  dest.x := x;
  dest.y := y;
  dest.w := w;
  dest.h := h;
  if scr1 = screen then
    SDL_BlitSurface(screen, @dest, prescreen, @dest);

  if GLHR = 1 then
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

    glENABLE(GL_TEXTURE_2D);
    glBEGIN(GL_QUADS);
    glTexCoord2f(0.0, 0.0);
    glVertex3f(-1.0, 1.0, 0.0);
    glTexCoord2f(1.0, 0.0);
    glVertex3f(1.0, 1.0, 0.0);
    glTexCoord2f(1.0, 1.0);
    glVertex3f(1.0, -1.0, 0.0);
    glTexCoord2f(0.0, 1.0);
    glVertex3f(-1.0, -1.0, 0.0);
    glEND;
    glDISABLE(GL_TEXTURE_2D);
    SDL_GL_SwapBuffers;
    glDeleteTextures(1, @TextureID);
  end
  else
  begin
    if (RealScreen.w = screen.w) and (RealScreen.h = screen.h) then
    begin
      SDL_BlitSurface(prescreen, nil, RealScreen, nil);
    end
    else
    begin
      tempscr := sdl_gfx.zoomSurface(prescreen, RealScreen.w / screen.w, RealScreen.h / screen.h, SMOOTH);
      SDL_BlitSurface(tempscr, nil, RealScreen, nil);
      sdl_freesurface(tempscr);
    end;
    SDL_UpdateRect(RealScreen, 0, 0, RealScreen.w, RealScreen.h);
  end;

end;


procedure SDL_GetMouseState2(var x, y: integer);
var
  tempx, tempy: integer;
begin
  SDL_GetMouseState(tempx, tempy);
  x := tempx * screen.w div RealScreen.w;
  y := tempy * screen.h div RealScreen.h;
end;

procedure ResizeWindow(w, h: integer);
begin
  RealScreen := SDL_SetVideoMode(w, h, 32, ScreenFlag);
  event.type_ := 0;
  SDL_UpdateRect2(Screen, 0, 0, screen.w, screen.h);
end;

procedure SwitchFullscreen;
begin
  fullscreen := 1 - fullscreen;
  if fullscreen = 0 then
  begin
    RealScreen := SDL_SetVideoMode(RESOLUTIONX, RESOLUTIONY, 32, ScreenFlag);
  end
  else
  begin
    realscreen := SDL_SetVideoMode(Center_X * 2, Center_Y * 2, 32, ScreenFlag or SDL_FULLSCREEN);
  end;

end;

procedure QuitConfirm;
var
  tempscr: Psdl_surface;
  menustring: array[0..2] of WideString;
begin
  if messagedlg('Are you sure to quit?', mtConfirmation, [mbOK, mbCancel], 0) = idOk then
    Quit;
  {if AskingQuit then
    exit;
  AskingQuit := True;
  tempscr := SDL_ConvertSurface(screen, screen.format, screen.flags);
  //SDL_BlitSurface(tempscr, nil, Screen, nil);
  DrawRectangleWithoutFrame(0, 0, screen.w, screen.h, 0, 50);
  SDL_UpdateRect2(screen, 0, 0, screen.w, screen.h);
  menustring[1] := ' 確認';
  menustring[0] := ' 取消';
  menustring[2] := ' 眞的要退出嗎？';
  //drawtextwithrect(@menustring[2][1], CENTER_X - 75, CENTER_Y - 85, 150, colcolor(5), colcolor(7));
  if commonmenu2(CENTER_X - 49, CENTER_Y - 50, 98, menustring) = 1 then
    Quit;
  SDL_BlitSurface(tempscr, nil, Screen, nil);
  SDL_UpdateRect2(screen, 0, 0, screen.w, screen.h);
  sdl_freesurface(tempscr);
  AskingQuit := False;}
end;

procedure CheckBasicEvent;
var
  i: integer;
begin
  case event.type_ of
    SDL_QUITEV:
      QuitConfirm;
    SDL_VIDEORESIZE:
      ResizeWindow(event.resize.w, event.resize.h);
    SDL_KEYUP:
      if (where = 2) and (event.key.keysym.sym = sdlk_Escape) then
      begin
        for i := 0 to BroleAmount - 1 do
        begin
          if Brole[i].Team = 0 then
            Brole[i].Auto := 0;
        end;
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
  now := sdl_getticks;
  if (NIGHT_EFFECT = 1) and (where = 0) then
  begin
    now_time := now_time + 0.3;
    if now_time > 1440 then now_time := 0;
    p := now_time / 1440;
    //writeln(p);
    if p > 0.5 then p := 1 - p;
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

  add0 := $e0;
  len := 8;
  a := now div 200 mod len;
  move(ACol1[add0 * 3], ACol[add0 * 3 + a * 3], (len - a) * 3);
  move(ACol1[add0 * 3 + (len - a) * 3], ACol[add0 * 3], a * 3);

  add0 := $f4;
  len := 9;
  a := now div 200 mod len;
  move(ACol1[add0 * 3], ACol[add0 * 3 + a * 3], (len - a) * 3);
  move(ACol1[add0 * 3 + (len - a) * 3], ACol[add0 * 3], a * 3); 

end;

//RLE8图片绘制子程，所有相关子程均对此封装. 最后一个参数为亮度, 仅在绘制战场选择对方时使用.

procedure DrawRLE8Pic(colorPanel: PChar; num, px, py: integer; Pidx: Pinteger; Ppic: PByte;
  RectArea: PChar; Image: PChar; widthI, heightI, sizeI: integer; shadow: integer); overload;
begin
  DrawRLE8Pic2(colorPanel, num, px, py, Pidx, Ppic, RectArea, Image, widthI, heightI, sizeI, Shadow, 0);

end;

//增加透明度选项

procedure DrawRLE8Pic2(colorPanel: PChar; num, px, py: integer; Pidx: Pinteger; Ppic: PByte;
  RectArea: PChar; Image: PChar; widthI, heightI, sizeI: integer; shadow, alpha: integer);
begin
  DrawRLE8Pic3(colorPanel, num, px, py, Pidx, Ppic, RectArea, Image, widthI, heightI, sizeI,
    Shadow, alpha, nil, nil, 0, 0, sizeof(integer), 128, 0, 0);

end;

//这是改写的绘制RLE8图片程序, 增加了选调色板, 遮挡控制, 亮度, 半透明, 混合色等
//colorPanel: Pchar; 调色板的指针. 某些情况下需要使用静态调色板, 避免静态图跟随水的效果
//num, px, py: integer; 图片的编号和位置
//Pidx: Pinteger; Ppic: PByte; 图片的索引和内容的资源所在地
//RectArea: Pchar; 画图的范围, 所指向地址应为连续4个integer, 表示一个矩形, 仅图片的部分或全部会出现在这个矩形内才画
//Image: PChar; widthI, heightI, sizeI: integer; 映像的位置, 尺寸, 每单位长度. 如果Img不为空, 则会将图画到这个镜像上, 否则画到屏幕
//shadow, alpha: integer; 图片的暗度和透明度, 仅在画到屏幕上时有效
//BlockImageW: PChar; 大小与场景和战场映像相同. 如果此地址不为空, 则会记录该像素的场景深度depth, 用于遮挡计算.
//BlockScreenR: PChar; widthR, heightR, sizeR: integer; 该映像应该与屏幕像素数相同, 保存屏幕上每一点的深度值
//depth: integer; 所画物件的深度, 即场景坐标 x + y, 深度高的物件会遮挡深度低的.
//当BlockImageW不为空时, 将该值写入BlockImageW, 如果该值超出范围(0~128), 会根据图片的y坐标计算一个,
//但是需注意计算值在场景内包含高度的情况下是不准确的.
//当Image为空, 即画到屏幕上时, 同时BlockScreenR不为空, 如果所绘像素的已有深度大于该值, 则按照alpha绘制该像素
//即该值起作用的机会有两种: Image不为空(到映像), 且BlockImageW不为空; 或者Image为空(到屏幕), 且BlockScreenR不为空.
//如果在画到屏幕时避免该值起作用, 可以设为128, 这是深度理论上的最大值(实际达不到)
//MixColor: Uint32; MixAlpha: integer 图片的混合颜色和混合度, 仅在画到屏幕上时有效

procedure DrawRLE8Pic3(colorPanel: PChar; num, px, py: integer; Pidx: Pinteger; Ppic: PByte;
  RectArea: PChar; Image: PChar; widthI, heightI, sizeI: integer; shadow, alpha: integer;
  BlockImageW: PChar; BlockScreenR: PChar; widthR, heightR, sizeR: integer; depth: integer;
  MixColor: Uint32; MixAlpha: integer);
var
  w, h, xs, ys: smallint;
  offset, length, p, isAlpha, lenInt, alphe: integer;
  l, l1, ix, iy, pixdepth, curdepth: integer;
  pix, colorin: Uint32;
  pix1, pix2, pix3, pix4, color1, color2, color3, color4: byte;
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

  lenInt := sizeof(integer);

  if ((w > 1) or (h > 1)) and (px - xs + w >= pint(RectArea)^) and (px - xs < pint(RectArea)^
    + pint(RectArea + lenInt * 2)^) and (py - ys + h >= pint(RectArea + lenInt)^) and
    (py - ys < pint(RectArea + lenInt)^ + pint(RectArea + lenInt * 3)^) then
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
          if (w - xs + px >= pint(RectArea)^) and (iy - ys + py >= pint(RectArea + lenInt)^) and
            (w - xs + px < pint(RectArea)^ + pint(RectArea + lenInt * 2)^) and
            (iy - ys + py < pint(RectArea + lenInt)^ + pint(RectArea + lenInt * 3)^) then
          begin
            pix1 := puint8(colorPanel + l1 * 3)^ * (4 + shadow);
            pix2 := puint8(colorPanel + l1 * 3 + 1)^ * (4 + shadow);
            pix3 := puint8(colorPanel + l1 * 3 + 2)^ * (4 + shadow);
            pix4 := 0;
            if image = nil then
            begin
              //pix := sdl_maprgb(screen.format, puint8(colorPanel + l1 * 3)^ * (4 + shadow),
              //puint8(colorPanel + l1 * 3 + 1)^ * (4 + shadow), puint8(colorPanel + l1 * 3 + 2)^ * (4 + shadow));
              if (alpha <> 0) then
              begin
                if (BlockScreenR = nil) then
                begin
                  isAlpha := 1;
                end
                else
                begin
                  if ((w - xs + px) < widthR) and ((iy - ys + py) < heightR) then
                  begin
                    pixdepth := pint(BlockScreenR + ((w - xs + px) * heightR + (iy - ys + py)) * sizeR)^;
                    curdepth := depth - (w - xs - 1) div 18;
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
                  colorin := getpixel(screen, w - xs + px, iy - ys + py);
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
                if HighLight then
                begin
                  //pix1 := pix and $FF;
                  //pix2 := pix shr 8 and $FF;
                  //pix3 := pix shr 16 and $FF;
                  //pix4 := pix shr 24 and $FF;
                  pix1 := (50 * $FF + 50 * pix1) div 100;
                  pix2 := (50 * $FF + 50 * pix2) div 100;
                  pix3 := (50 * $FF + 50 * pix3) div 100;
                  pix4 := (50 * $FF + 50 * pix4) div 100;
                  pix := pix1 + pix2 shl 8 + pix3 shl 16 + pix4 shl 24;
                end;
                if (ShowBlackScreen = True) and (where = 1) then
                begin
                  alphe := snowalpha[iy - ys + py][w - xs + px];
                  if alphe = 100 then
                    pix := 0
                  else if alphe <> 0 then
                  begin
                    //pix1 := pix and $FF;
                    //pix2 := pix shr 8 and $FF;
                    //pix3 := pix shr 16 and $FF;
                    //pix4 := pix shr 24 and $FF;
                    pix1 := ((100 - alphe) * pix1) div 100;
                    pix2 := ((100 - alphe) * pix2) div 100;
                    pix3 := ((100 - alphe) * pix3) div 100;
                    pix4 := ((100 - alphe) * pix4) div 100;
                    pix := pix1 + pix2 shl 8 + pix3 shl 16 + pix4 shl 24;
                  end;
                end;
                if Gray then
                begin
                  //pix1 := pix and $FF;
                  //pix2 := pix shr 8 and $FF;
                  //pix3 := pix shr 16 and $FF;
                  //pix4 := pix shr 24 and $FF;
                  pix1 := (pix1 * 11) div 100 + (pix2 * 59) div 100 + (pix3 * 3) div 10;
                  pix := pix1 + pix1 shl 8 + pix1 shl 16 + pix4 shl 24;
                end;
              end;
              if mixAlpha <> 0 then
              begin
                colorin := MixColor;
                //pix1 := pix and $FF;
                color1 := colorin and $FF;
                //pix2 := pix shr 8 and $FF;
                color2 := colorin shr 8 and $FF;
                //pix3 := pix shr 16 and $FF;
                color3 := colorin shr 16 and $FF;
                //pix4 := pix shr 24 and $FF;
                color4 := colorin shr 24 and $FF;
                pix1 := (mixAlpha * color1 + (100 - mixAlpha) * pix1) div 100;
                pix2 := (mixAlpha * color2 + (100 - mixAlpha) * pix2) div 100;
                pix3 := (mixAlpha * color3 + (100 - mixAlpha) * pix3) div 100;
                pix4 := (mixAlpha * color4 + (100 - mixAlpha) * pix4) div 100;
                //pix := pix1 + pix2 shl 8 + pix3 shl 16 + pix4 shl 24;
              end;
              pix := sdl_maprgba(screen.format, pix1, pix2, pix3, pix4);
              curdepth := depth - (w - xs - 1) div 18;
              if (Alpha < 100) or (pixdepth <= curdepth) then
                putpixel(screen, w - xs + px, iy - ys + py, pix);
            end
            else
            begin
              if ((w - xs + px) < widthI) and ((iy - ys + py) < heightI) then
              begin
                if (BlockImageW <> nil) then
                begin
                  //depth := depth;
                  if (depth < 0) or (depth >= 128) then
                    depth := ((py - 250) div 9 - 1);
                  Pint(BlockImageW + ((w - xs + px) * heightI + (iy - ys + py)) * sizeI)^ := depth;
                end;
                pix := sdl_maprgba(screen.format, pix1, pix2, pix3, pix4);
                Pint(image + ((w - xs + px) * heightI + (iy - ys + py)) * sizeI)^ := pix;
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

//这个子程似乎仅画进度条用到

procedure DrawRLE8Pic(colorPanel: PChar; num, px, py: integer; Pidx: Pinteger; Ppic: PByte;
  RectArea: PChar; Image: PSDL_Surface; widthI, heightI, sizeI: integer; shadow, alpha: integer;
  BlockImageW: PChar; BlockScreenR: PChar; widthR, heightR, sizeR: integer; depth: integer;
  MixColor: Uint32; MixAlpha: integer); overload;
var
  w, h, xs, ys, x, y: smallint;
  offset, length, p, isAlpha, lenInt: integer;
  l, l1, ix, iy, pixdepth, curdepth: integer;
  pix, colorin: Uint32;
  pix1, pix2, pix3, pix4, color1, color2, color3, color4: byte;
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
  lenInt := sizeof(integer);

  if ((w > 1) or (h > 1)) and (px - xs + w >= pint(RectArea)^) and (px - xs < pint(RectArea)^
    + pint(RectArea + lenInt * 2)^) and (py - ys + h >= pint(RectArea + lenInt)^) and
    (py - ys < pint(RectArea + lenInt)^ + pint(RectArea + lenInt * 3)^) then
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
          if (x >= pint(RectArea)^) and (y >= pint(RectArea + lenInt)^) and
            (x < pint(RectArea)^ + pint(RectArea + lenInt * 2)^) and (y <
            pint(RectArea + lenInt)^ + pint(RectArea + lenInt * 3)^) then
          begin
            pix1 := puint8(colorPanel + l1 * 3)^ * (4 + shadow);
            pix2 := puint8(colorPanel + l1 * 3 + 1)^ * (4 + shadow);
            pix3 := puint8(colorPanel + l1 * 3 + 2)^ * (4 + shadow);
            pix4 := 0;
            if image = nil then
            begin
              //pix := sdl_maprgb(screen.format, puint8(colorPanel + l1 * 3)^ * (4 + shadow),
              //puint8(colorPanel + l1 * 3 + 1)^ * (4 + shadow), puint8(colorPanel + l1 * 3 + 2)^ * (4 + shadow));
              if (alpha <> 0) then
              begin
                if (BlockScreenR = nil) then
                begin
                  isAlpha := 1;
                end
                else
                begin
                  if (x < widthR) and (y < heightR) then
                  begin
                    pixdepth := pint(BlockScreenR + (x * heightR + y) * sizeR)^;
                    curdepth := depth - (w - xs - 1) div 18;
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
                  colorin := getpixel(screen, x, y);
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
              end;
              if mixAlpha <> 0 then
              begin
                colorin := MixColor;
                //pix1 := pix and $FF;
                color1 := colorin and $FF;
                //pix2 := pix shr 8 and $FF;
                color2 := colorin shr 8 and $FF;
                //pix3 := pix shr 16 and $FF;
                color3 := colorin shr 16 and $FF;
                //pix4 := pix shr 24 and $FF;
                color4 := colorin shr 24 and $FF;
                pix1 := (mixAlpha * color1 + (100 - mixAlpha) * pix1) div 100;
                pix2 := (mixAlpha * color2 + (100 - mixAlpha) * pix2) div 100;
                pix3 := (mixAlpha * color3 + (100 - mixAlpha) * pix3) div 100;
                pix4 := (mixAlpha * color4 + (100 - mixAlpha) * pix4) div 100;
                //pix := pix1 + pix2 shl 8 + pix3 shl 16 + pix4 shl 24;
              end;
              pix := sdl_maprgba(screen.format, pix1, pix2, pix3, pix4);
              curdepth := depth - (w - xs - 1) div 18;
              if (Alpha < 100) or (pixdepth <= curdepth) then
                putpixel(screen, x, y, pix);
            end
            else
            begin
              if (x < widthI) and (y < heightI) then
              begin
                if (BlockImageW <> nil) then
                begin
                  //depth := depth;
                  if (depth < 0) or (depth >= 128) then
                    depth := (py div 9 - 1);
                  Pint(BlockImageW + (x * heightI + y) * sizeI)^ := depth;
                end;
                pix := sdl_maprgba(screen.format, pix1, pix2, pix3, pix4);
                putpixel(Image, x, y, pix);
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


procedure DrawRLE8PicA(colorPanel: PChar; num, px, py: integer; Pidx: Pinteger; Ppic: PByte;
  RectArea: TRect; Image: PChar; shadow, alpha: integer);
begin
  DrawRLE8Pic3(colorPanel, num, px, py, Pidx, Ppic, @RectArea, Image, 2304, 1402, sizeof(UInt32),
    Shadow, alpha, nil, nil, 0, 0, sizeof(integer), 128, 0, 0);

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
    DrawCPic(Cloud[i].Picnum, x, y, Cloud[i].Shadow, Cloud[i].Alpha, Cloud[i].MixColor, Cloud[i].MixAlpha);
  end;

end;

//主地图上画云

procedure DrawCPic(num, px, py, shadow, alpha: integer; mixColor: Uint32; mixAlpha: integer);
var
  Area: TRect;
begin
  Area.x := 0;
  Area.y := 0;
  Area.w := screen.w;
  Area.h := screen.h;
  DrawRLE8Pic3(@ACol1[0], num, px, py, @CIdx[0], @CPic[0], @Area, nil, 0, 0, 0, shadow, alpha,
    nil, nil, 0, 0, 0, 128, mixColor, mixAlpha);

end;


end.
