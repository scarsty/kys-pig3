{
  SDL_image:  An example image loading library for use with SDL
  Copyright (C) 1997-2016 Sam Lantinga <slouken@libsdl.org>

  This software is provided 'as-is', without any express or implied
  warranty. In no event will the authors be held liable for any damages
  arising from the use of this software.

  Permission is granted to anyone to use this software for any purpose,
  including commercial applications, and to alter it and redistribute it
  freely, subject to the following restrictions:

  1. The origin of this software must not be misrepresented; you must not
     claim that you wrote the original software. If you use this software
     in a product, an acknowledgment in the product documentation would be
     appreciated but is not required.
  2. Altered source versions must be plainly marked as such, and must not be
     misrepresented as being the original software.
  3. This notice may not be removed or altered from any source distribution.

  ===

  SDL2_image header for Free Pascal

}

unit SDL2_image;

interface

uses SDL2;

{$MACRO ON}
{$INLINE ON}
{$PACKRECORDS C}

{$DEFINE lSDL := cdecl; external 'SDL2_image'}

{$IFDEF DARWIN}
  {$linkframework SDL2}
  {$linkframework SDL2_image}
{$ENDIF}

const
  SDL_IMAGE_MAJOR_VERSION = 2;
  SDL_IMAGE_MINOR_VERSION = 0;
  SDL_IMAGE_PATCHLEVEL    = 1;

  IMG_INIT_JPG  = $00000001;
  IMG_INIT_PNG  = $00000002;
  IMG_INIT_TIF  = $00000004;
  IMG_INIT_WEBP = $00000008;

procedure SDL_IMAGE_VERSION(x: PSDL_Version); inline;
function IMG_Linked_Version: PSDL_Version; lSDL;

function IMG_Init(flags: longint): longint; lSDL;
procedure IMG_Quit; lSDL;

function IMG_LoadTyped_RW(src: PSDL_RWops; freesrc: longint; const type_: PAnsiChar): PSDL_Surface; lSDL;
function IMG_Load(const file_: PAnsiChar): PSDL_Surface; lSDL;
function IMG_Load_RW(src: PSDL_RWops; freesrc: longint): PSDL_Surface; lSDL;

function IMG_LoadTexture(renderer: PSDL_Renderer; const file_: PAnsiChar): PSDL_Texture; lSDL;
function IMG_LoadTexture_RW(renderer: PSDL_Renderer; src: PSDL_RWops; freesrc: longint): PSDL_Texture; lSDL;
function IMG_LoadTextureTyped_RW(renderer: PSDL_Renderer; src: PSDL_RWops; freesrc: longint; const type_: PAnsiChar): PSDL_Texture; lSDL;

function IMG_isICO(src: PSDL_RWops): longint; lSDL;
function IMG_isCUR(src: PSDL_RWops): longint; lSDL;
function IMG_isBMP(src: PSDL_RWops): longint; lSDL;
function IMG_isGIF(src: PSDL_RWops): longint; lSDL;
function IMG_isJPG(src: PSDL_RWops): longint; lSDL;
function IMG_isLBM(src: PSDL_RWops): longint; lSDL;
function IMG_isPCX(src: PSDL_RWops): longint; lSDL;
function IMG_isPNG(src: PSDL_RWops): longint; lSDL;
function IMG_isPNM(src: PSDL_RWops): longint; lSDL;
function IMG_isTIF(src: PSDL_RWops): longint; lSDL;
function IMG_isXCF(src: PSDL_RWops): longint; lSDL;
function IMG_isXPM(src: PSDL_RWops): longint; lSDL;
function IMG_isXV(src: PSDL_RWops): longint; lSDL;
function IMG_isWEBP(src: PSDL_RWops): longint; lSDL;

function IMG_LoadICO_RW(src: PSDL_RWops): PSDL_Surface; lSDL;
function IMG_LoadCUR_RW(src: PSDL_RWops): PSDL_Surface; lSDL;
function IMG_LoadBMP_RW(src: PSDL_RWops): PSDL_Surface; lSDL;
function IMG_LoadGIF_RW(src: PSDL_RWops): PSDL_Surface; lSDL;
function IMG_LoadJPG_RW(src: PSDL_RWops): PSDL_Surface; lSDL;
function IMG_LoadLBM_RW(src: PSDL_RWops): PSDL_Surface; lSDL;
function IMG_LoadPCX_RW(src: PSDL_RWops): PSDL_Surface; lSDL;
function IMG_LoadPNG_RW(src: PSDL_RWops): PSDL_Surface; lSDL;
function IMG_LoadPNM_RW(src: PSDL_RWops): PSDL_Surface; lSDL;
function IMG_LoadTGA_RW(src: PSDL_RWops): PSDL_Surface; lSDL;
function IMG_LoadTIF_RW(src: PSDL_RWops): PSDL_Surface; lSDL;
function IMG_LoadXCF_RW(src: PSDL_RWops): PSDL_Surface; lSDL;
function IMG_LoadXPM_RW(src: PSDL_RWops): PSDL_Surface; lSDL;
function IMG_LoadXV_RW(src: PSDL_RWops): PSDL_Surface; lSDL;
function IMG_LoadWEBP_RW(src: PSDL_RWops): PSDL_Surface; lSDL;

function IMG_ReadXPMFromArray(xpm: pPAnsiChar): PSDL_Surface; lSDL;

function IMG_SavePNG(surface: PSDL_Surface; const file_: PAnsiChar): longint; lSDL;
function IMG_SavePNG_RW(surface: PSDL_Surface; dst: PSDL_RWops; freedst: longint): longint; lSDL;

function IMG_SetError(const fmt: PAnsiChar): longint; cdecl; external 'SDL2' name 'SDL_SetError'; varargs;
function IMG_GetError: PAnsiChar; cdecl; external 'SDL2' name 'SDL_GetError';

implementation

procedure SDL_IMAGE_VERSION(x: PSDL_Version); inline;
begin
  x^.major := SDL_IMAGE_MAJOR_VERSION;
  x^.minor := SDL_IMAGE_MINOR_VERSION;
  x^.patch := SDL_IMAGE_PATCHLEVEL;
end;

end.
