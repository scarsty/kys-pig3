{
  This file is part of:

    SDL3 for Pascal
    (https://github.com/PascalGameDevelopment/SDL3-for-Pascal)
    SPDX-License-Identifier: Zlib
}

const
  {*!
    \brief Highest possible rate supported by framerate controller in Hz (1/s).
  *}
  FPS_UPPER_LIMIT = 200;

  {*!
    \brief Lowest possible rate supported by framerate controller in Hz (1/s).
  *}
  FPS_LOWER_LIMIT = 1;

  {*!
    \brief Default rate of framerate controller in Hz (1/s).
  *}
  FPS_DEFAULT = 30;

type
  {*!
    \brief Structure holding the state and timing information of the framerate controller.
  *}
  PPFPSmanager = ^PFPSmanager;
  PFPSmanager = ^TFPSmanager;
  TFPSmanager = record
    framecount: cuint32;
    rateticks: cfloat;
    baseticks: cuint64;
    lastticks: cuint64;
    rate: cuint32;
  end;

{* Functions return 0 or value for sucess and -1 for error *}

procedure SDL_initFramerate(manager: PFPSmanager); cdecl;
  external GFX_LibName {$IFDEF DELPHI} {$IFDEF MACOS} name '_SDL_initFramerate' {$ENDIF} {$ENDIF};

function SDL_setFramerate(manager: PFPSmanager; rate: cuint32): cint; cdecl;
  external GFX_LibName {$IFDEF DELPHI} {$IFDEF MACOS} name '_SDL_setFramerate' {$ENDIF} {$ENDIF};

function SDL_getFramerate(manager: PFPSmanager): cint; cdecl;
  external GFX_LibName {$IFDEF DELPHI} {$IFDEF MACOS} name '_SDL_getFramerate' {$ENDIF} {$ENDIF};

function SDL_getFramecount(manager: PFPSmanager): cint; cdecl;
  external GFX_LibName {$IFDEF DELPHI} {$IFDEF MACOS} name '_SDL_getFramecount' {$ENDIF} {$ENDIF};

function SDL_framerateDelay(manager: PFPSmanager): cuint64; cdecl;
  external GFX_LibName {$IFDEF DELPHI} {$IFDEF MACOS} name '_SDL_framerateDelay' {$ENDIF} {$ENDIF};
