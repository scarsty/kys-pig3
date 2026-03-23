{
  This file is part of:

    SDL3 for Pascal
    (https://github.com/PascalGameDevelopment/SDL3-for-Pascal)
    SPDX-License-Identifier: Zlib
}

Const
  {*!
    \brief Disable anti-aliasing (no smoothing).
  *}
  SMOOTHING_OFF = 0;

  {*!
    \brief Enable anti-aliasing (smoothing).
  *}
  SMOOTHING_ON = 1;

function rotozoomSurface(src: PSDL_Surface; angle, zoom: cdouble; smooth: cint): PSDL_Surface; cdecl;
  external GFX_LibName {$IFDEF DELPHI} {$IFDEF MACOS} name '_rotozoomSurface' {$ENDIF} {$ENDIF};

function rotozoomSurfaceXY(src: PSDL_Surface; angle, zoomx, zoomy: cdouble; smooth: cint): PSDL_Surface; cdecl;
  external GFX_LibName {$IFDEF DELPHI} {$IFDEF MACOS} name '_rotozoomSurfaceXY' {$ENDIF} {$ENDIF};

procedure rotozoomSurfaceSize(width, height: cint; angle, zoom: cdouble; dstwidth, dstheight: pcint); cdecl;
  external GFX_LibName {$IFDEF DELPHI} {$IFDEF MACOS} name '_rotozoomSurfaceSize' {$ENDIF} {$ENDIF};

procedure rotozoomSurfaceSizeXY(width, height: cint; angle, zoomx, zoomy: cdouble; dstwidth, dstheight: pcint); cdecl;
  external GFX_LibName {$IFDEF DELPHI} {$IFDEF MACOS} name '_rotozoomSurfaceSizeXY' {$ENDIF} {$ENDIF};

function zoomSurface(src: PSDL_Surface; zoomx, zoomy: cdouble; smooth: cint): PSDL_Surface; cdecl;
  external GFX_LibName {$IFDEF DELPHI} {$IFDEF MACOS} name '_zoomSurface' {$ENDIF} {$ENDIF};

procedure zoomSurfaceSize(width, height: cint; zoomx, zoomy: cdouble; dstwidth, dstheight: pcint); cdecl;
  external GFX_LibName {$IFDEF DELPHI} {$IFDEF MACOS} name '_zoomSurfaceSize' {$ENDIF} {$ENDIF};

function shrinkSurface(src: PSDL_Surface; factorx, factory: cint): PSDL_Surface; cdecl;
  external GFX_LibName {$IFDEF DELPHI} {$IFDEF MACOS} name '_shrinkSurface' {$ENDIF} {$ENDIF};

function rotateSurface90Degrees(src: PSDL_Surface; numClockwiseTurns: cint): PSDL_Surface; cdecl;
  external GFX_LibName {$IFDEF DELPHI} {$IFDEF MACOS} name '_rotateSurface90Degrees' {$ENDIF} {$ENDIF};
