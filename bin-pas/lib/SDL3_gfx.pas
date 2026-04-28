unit SDL3_gfx;

{
  This file is part of:

    SDL3 for Pascal
    (https://github.com/PascalGameDevelopment/SDL3-for-Pascal)
    SPDX-License-Identifier: Zlib
}

{$I sdl.inc}

interface
  uses
    {$IFDEF FPC}
      ctypes,
    {$ENDIF}
    SDL3;

const
  {$IFDEF WINDOWS}
    GFX_LibName = 'SDL3_gfx.dll';
  {$ENDIF}

  {$IFDEF UNIX}
    {$IFDEF DARWIN}
      GFX_LibName = 'libSDL3_gfx.dylib';
      {$IFDEF FPC}
        {$LINKLIB libSDL3_gfx}
      {$ENDIF}
    {$ELSE}
      {$IFDEF FPC}
        GFX_LibName = 'libSDL3_gfx.so';
      {$ELSE}
        GFX_LibName = 'libSDL3_gfx.so.0';
      {$ENDIF}
    {$ENDIF}
  {$ENDIF}

  {$IFDEF MACOS}
    GFX_LibName = 'SDL3_gfx';
    {$IFDEF FPC}
      {$linklib libSDL3_gfx}
    {$ENDIF}
  {$ENDIF}

{$INCLUDE SDL3_framerate.inc}
{$INCLUDE SDL3_gfxPrimitives.inc}
{$INCLUDE SDL3_gfxPrimitives_font.inc}
{$INCLUDE SDL3_imageFilter.inc}
{$INCLUDE SDL3_rotozoom.inc}

implementation

end.
