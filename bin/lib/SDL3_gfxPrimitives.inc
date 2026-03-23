{
  This file is part of:

    SDL3 for Pascal
    (https://github.com/PascalGameDevelopment/SDL3-for-Pascal)
    SPDX-License-Identifier: Zlib
}

const
  SDL3_GFXPRIMITIVES_MAJOR = 1;
  SDL3_GFXPRIMITIVES_MINOR = 0;
  SDL3_GFXPRIMITIVES_MICRO = 0;

{* Note: all ___Color routines expect the color to be in format 0xRRGGBBAA *}

{* Pixel *}

function pixelColor(renderer: PSDL_Renderer; x, y: cint16; color: cuint32): Boolean; cdecl;
  external GFX_LibName {$IFDEF DELPHI} {$IFDEF MACOS} name '_pixelColor' {$ENDIF} {$ENDIF};
function pixelRGBA(renderer: PSDL_Renderer; x, y: cint16; r, g, b, a: cuint8): Boolean; cdecl;
  external GFX_LibName {$IFDEF DELPHI} {$IFDEF MACOS} name '_pixelRGBA' {$ENDIF} {$ENDIF};

{* Horizontal line *}

function hlineColor(renderer: PSDL_Renderer; x1, x2, y: cint16; color: cuint32): Boolean; cdecl;
  external GFX_LibName {$IFDEF DELPHI} {$IFDEF MACOS} name '_hlineColor' {$ENDIF} {$ENDIF};
function hlineRGBA(renderer: PSDL_Renderer; x1, x2, y: cint16; r, g, b, a: cuint8): Boolean; cdecl;
  external GFX_LibName {$IFDEF DELPHI} {$IFDEF MACOS} name '_hlineRGBA' {$ENDIF} {$ENDIF};

{* Vertical line *}

function vlineColor(renderer: PSDL_Renderer; x, y1, y2: cint16; color: cuint32): Boolean; cdecl;
  external GFX_LibName {$IFDEF DELPHI} {$IFDEF MACOS} name '_vlineColor' {$ENDIF} {$ENDIF};
function vlineRGBA(renderer: PSDL_Renderer; x, y1, y2: cint16; r, g, b, a: cuint8): Boolean; cdecl;
  external GFX_LibName {$IFDEF DELPHI} {$IFDEF MACOS} name '_vlineRGBA' {$ENDIF} {$ENDIF};

{* Rectangle *}

function rectangleColor(renderer: PSDL_Renderer; x1, y1, x2, y2: cint16; color: cuint32): Boolean; cdecl;
  external GFX_LibName {$IFDEF DELPHI} {$IFDEF MACOS} name '_rectangleColor' {$ENDIF} {$ENDIF};
function rectangleRGBA(renderer: PSDL_Renderer; x1, y1, x2, y2: cint16; r, g, b, a: cuint8): Boolean; cdecl;
  external GFX_LibName {$IFDEF DELPHI} {$IFDEF MACOS} name '_rectangleRGBA' {$ENDIF} {$ENDIF};

{* Rounded-Corner Rectangle *}

function roundedRectangleColor(renderer: PSDL_Renderer; x1, y1, x2, y2, rad: cint16; color: cuint32): Boolean; cdecl;
  external GFX_LibName {$IFDEF DELPHI} {$IFDEF MACOS} name '_roundedRectangleColor' {$ENDIF} {$ENDIF};
function roundedRectangleRGBA(renderer: PSDL_Renderer; x1, y1, x2, y2, rad: cint16; r, g, b, a: cuint8): Boolean; cdecl;
  external GFX_LibName {$IFDEF DELPHI} {$IFDEF MACOS} name '_roundedRectangleRGBA' {$ENDIF} {$ENDIF};

{* Filled rectangle (Box) *}

function boxColor(renderer: PSDL_Renderer; x1, y1, x2, y2: cint16; color: cuint32): Boolean; cdecl;
  external GFX_LibName {$IFDEF DELPHI} {$IFDEF MACOS} name '_boxColor' {$ENDIF} {$ENDIF};
function boxRGBA(renderer: PSDL_Renderer; x1, y1, x2, y2: cint16; r, g, b, a: cuint8): Boolean; cdecl;
  external GFX_LibName {$IFDEF DELPHI} {$IFDEF MACOS} name '_boxRGBA' {$ENDIF} {$ENDIF};

{* Rounded-Corner Filled rectangle (Box) *}

function roundedBoxColor(renderer: PSDL_Renderer; x1, y1, x2, y2, rad: cint16; color: cuint32): Boolean; cdecl;
  external GFX_LibName {$IFDEF DELPHI} {$IFDEF MACOS} name '_roundedBoxColor' {$ENDIF} {$ENDIF};
function roundedBoxRGBA(renderer: PSDL_Renderer; x1, y1, x2, y2, rad: cint16; r, g, b, a: cuint8): Boolean; cdecl;
  external GFX_LibName {$IFDEF DELPHI} {$IFDEF MACOS} name '_roundedBoxRGBA' {$ENDIF} {$ENDIF};

{* Line *}

function lineColor(renderer: PSDL_Renderer; x1, y1, x2, y2: cint16; color: cuint32): Boolean; cdecl;
  external GFX_LibName {$IFDEF DELPHI} {$IFDEF MACOS} name '_lineColor' {$ENDIF} {$ENDIF};
function lineRGBA(renderer: PSDL_Renderer; x1, y1, x2, y2: cint16; r, g, b, a: cuint8): Boolean; cdecl;
  external GFX_LibName {$IFDEF DELPHI} {$IFDEF MACOS} name '_lineRGBA' {$ENDIF} {$ENDIF};

{* AA Line *}

function aalineColor(renderer: PSDL_Renderer; x1, y1, x2, y2: cint16; color: cuint32): Boolean; cdecl;
  external GFX_LibName {$IFDEF DELPHI} {$IFDEF MACOS} name '_aalineColor' {$ENDIF} {$ENDIF};
function aalineRGBA(renderer: PSDL_Renderer; x1, y1, x2, y2: cint16; r, g, b, a: cuint8): Boolean; cdecl;
  external GFX_LibName {$IFDEF DELPHI} {$IFDEF MACOS} name '_aalineRGBA' {$ENDIF} {$ENDIF};

{* Thick Line *}

function thickLineColor(renderer: PSDL_Renderer; x1, y1, x2, y2: cint16; width: cuint8; color: cuint32): Boolean; cdecl;
  external GFX_LibName {$IFDEF DELPHI} {$IFDEF MACOS} name '_thickLineColor' {$ENDIF} {$ENDIF};
function thickLineRGBA(renderer: PSDL_Renderer; x1, y1, x2, y2: cint16; width, r, g, b, a: cuint8): Boolean; cdecl;
  external GFX_LibName {$IFDEF DELPHI} {$IFDEF MACOS} name '_thickLineRGBA' {$ENDIF} {$ENDIF};

{* Circle *}

function circleColor(renderer: PSDL_Renderer; x, y, rad: cint16; color: cuint32): Boolean; cdecl;
  external GFX_LibName {$IFDEF DELPHI} {$IFDEF MACOS} name '_circleColor' {$ENDIF} {$ENDIF};
function circleRGBA(renderer: PSDL_Renderer; x, y, rad: cint16; r, g, b, a: cuint8): Boolean; cdecl;
  external GFX_LibName {$IFDEF DELPHI} {$IFDEF MACOS} name '_circleRGBA' {$ENDIF} {$ENDIF};

{* Arc *}

function arcColor(renderer: PSDL_Renderer; x, y, rad, start, end_: cint16; color: cuint32): Boolean; cdecl;
  external GFX_LibName {$IFDEF DELPHI} {$IFDEF MACOS} name '_arcColor' {$ENDIF} {$ENDIF};
function arcRGBA(renderer: PSDL_Renderer; x, y, rad, start, end_: cint16; r, g, b, a: cuint8): Boolean; cdecl;
  external GFX_LibName {$IFDEF DELPHI} {$IFDEF MACOS} name '_arcRGBA' {$ENDIF} {$ENDIF};

{* AA Circle *}

function aacircleColor(renderer: PSDL_Renderer; x, y, rad: cint16; color: cuint32): Boolean; cdecl;
  external GFX_LibName {$IFDEF DELPHI} {$IFDEF MACOS} name '_aacircleColor' {$ENDIF} {$ENDIF};
function aacircleRGBA(renderer: PSDL_Renderer; x, y, rad: cint16; r, g, b, a: cuint8): Boolean; cdecl;
  external GFX_LibName {$IFDEF DELPHI} {$IFDEF MACOS} name '_aacircleRGBA' {$ENDIF} {$ENDIF};

{* Filled Circle *}

function filledCircleColor(renderer: PSDL_Renderer; x, y, r: cint16; color: cuint32): Boolean; cdecl;
  external GFX_LibName {$IFDEF DELPHI} {$IFDEF MACOS} name '_filledCircleColor' {$ENDIF} {$ENDIF};
function filledCircleRGBA(renderer: PSDL_Renderer; x, y, rad: cint16; r, g, b, a: cuint8): Boolean; cdecl;
  external GFX_LibName {$IFDEF DELPHI} {$IFDEF MACOS} name '_filledCircleRGBA' {$ENDIF} {$ENDIF};

{* Ellipse *}

function ellipseColor(renderer: PSDL_Renderer; x, y, rx, ry: cint16; color: cuint32): Boolean; cdecl;
  external GFX_LibName {$IFDEF DELPHI} {$IFDEF MACOS} name '_ellipseColor' {$ENDIF} {$ENDIF};
function ellipseRGBA(renderer: PSDL_Renderer; x, y, rx, ry: cint16; r, g, b, a: cuint8): Boolean; cdecl;
  external GFX_LibName {$IFDEF DELPHI} {$IFDEF MACOS} name '_ellipseRGBA' {$ENDIF} {$ENDIF};

{* AA Ellipse *}

function aaellipseColor(renderer: PSDL_Renderer; x, y, rx, ry: cint16; color: cuint32): Boolean; cdecl;
  external GFX_LibName {$IFDEF DELPHI} {$IFDEF MACOS} name '_aaellipseColor' {$ENDIF} {$ENDIF};
function aaellipseRGBA(renderer: PSDL_Renderer; x, y, rx, ry: cint16; r, g, b, a: cuint8): Boolean; cdecl;
  external GFX_LibName {$IFDEF DELPHI} {$IFDEF MACOS} name '_aaellipseRGBA' {$ENDIF} {$ENDIF};

{* Filled Ellipse *}

function filledEllipseColor(renderer: PSDL_Renderer; x, y, rx, ry: cint16; color: cuint32): Boolean; cdecl;
  external GFX_LibName {$IFDEF DELPHI} {$IFDEF MACOS} name '_filledEllipseColor' {$ENDIF} {$ENDIF};
function filledEllipseRGBA(renderer: PSDL_Renderer; x, y, rx, ry: cint16; r, g, b, a: cuint8): Boolean; cdecl;
  external GFX_LibName {$IFDEF DELPHI} {$IFDEF MACOS} name '_filledEllipseRGBA' {$ENDIF} {$ENDIF};

{* Pie *}

function pieColor(renderer: PSDL_Renderer; x, y, rad, start, end_: cint16; color: cuint32): Boolean; cdecl;
  external GFX_LibName {$IFDEF DELPHI} {$IFDEF MACOS} name '_pieColor' {$ENDIF} {$ENDIF};
function pieRGBA(renderer: PSDL_Renderer; x, y, rad, start, end_: cint16; r, g, b, a: cuint8): Boolean; cdecl;
  external GFX_LibName {$IFDEF DELPHI} {$IFDEF MACOS} name '_pieRGBA' {$ENDIF} {$ENDIF};

{* Filled Pie *}

function filledPieColor(renderer: PSDL_Renderer; x, y, rad, start, end_: cint16; color: cuint32): Boolean; cdecl;
  external GFX_LibName {$IFDEF DELPHI} {$IFDEF MACOS} name '_filledPieColor' {$ENDIF} {$ENDIF};
function filledPieRGBA(renderer: PSDL_Renderer; x, y, rad, start, end_: cint16; r, g, b, a: cuint8): Boolean; cdecl;
  external GFX_LibName {$IFDEF DELPHI} {$IFDEF MACOS} name '_filledPieRGBA' {$ENDIF} {$ENDIF};

{* Trigon *}

function trigonColor(renderer: PSDL_Renderer; x1, y1, x2, y2, x3, y3: cint16; color: cuint32): Boolean; cdecl;
  external GFX_LibName {$IFDEF DELPHI} {$IFDEF MACOS} name '_trigonColor' {$ENDIF} {$ENDIF};
function trigonRGBA(renderer: PSDL_Renderer; x1, y1, x2, y2, x3, y3: cint16; r, g, b, a: cuint8): Boolean; cdecl;
  external GFX_LibName {$IFDEF DELPHI} {$IFDEF MACOS} name '_trigonRGBA' {$ENDIF} {$ENDIF};

{* AA-Trigon *}

function aatrigonColor(renderer: PSDL_Renderer; x1, y1, x2, y2, x3, y3: cint16; color: cuint32): Boolean; cdecl;
  external GFX_LibName {$IFDEF DELPHI} {$IFDEF MACOS} name '_aatrigonColor' {$ENDIF} {$ENDIF};
function aatrigonRGBA(renderer: PSDL_Renderer;  x1, y1, x2, y2, x3, y3: cint16; r, g, b, a: cuint8): Boolean; cdecl;
  external GFX_LibName {$IFDEF DELPHI} {$IFDEF MACOS} name '_aatrigonRGBA' {$ENDIF} {$ENDIF};

{* Filled Trigon *}

function filledTrigonColor(renderer: PSDL_Renderer; x1, y1, x2, y2, x3, y3: cint16; color: cuint32): Boolean; cdecl;
  external GFX_LibName {$IFDEF DELPHI} {$IFDEF MACOS} name '_filledTrigonColor' {$ENDIF} {$ENDIF};
function filledTrigonRGBA(renderer: PSDL_Renderer; x1, y1, x2, y2, x3, y3: cint16; r, g, b, a: cuint8): Boolean; cdecl;
  external GFX_LibName {$IFDEF DELPHI} {$IFDEF MACOS} name '_filledTrigonRGBA' {$ENDIF} {$ENDIF};

{* Polygon *}

function polygonColor(renderer: PSDL_Renderer; const vx, vy: pcint16; n: cint; color: cuint32): Boolean; cdecl;
  external GFX_LibName {$IFDEF DELPHI} {$IFDEF MACOS} name '_polygonColor' {$ENDIF} {$ENDIF};
function polygonRGBA(renderer: PSDL_Renderer; const vx, vy: pcint16; n: cint; r, g, b, a: cuint8): Boolean; cdecl;
  external GFX_LibName {$IFDEF DELPHI} {$IFDEF MACOS} name '_polygonRGBA' {$ENDIF} {$ENDIF};

{* AA-Polygon *}

function aapolygonColor(renderer: PSDL_Renderer; const vx, vy: pcint16; n: cint; color: cuint32): Boolean; cdecl;
  external GFX_LibName {$IFDEF DELPHI} {$IFDEF MACOS} name '_aapolygonColor' {$ENDIF} {$ENDIF};
function aapolygonRGBA(renderer: PSDL_Renderer; const vx, vy: pcint16; n: cint; r, g, b, a: cuint8): Boolean; cdecl;
  external GFX_LibName {$IFDEF DELPHI} {$IFDEF MACOS} name '_aapolygonRGBA' {$ENDIF} {$ENDIF};

{* Filled Polygon *}

function filledPolygonColor(renderer: PSDL_Renderer; const vx, vy: pcint16; n: cint; color: cuint32): Boolean; cdecl;
  external GFX_LibName {$IFDEF DELPHI} {$IFDEF MACOS} name '_filledPolygonColor' {$ENDIF} {$ENDIF};
function filledPolygonRGBA(renderer: PSDL_Renderer; const vx, vy: pcint16; n: cint; r, g, b, a: cuint8): Boolean; cdecl;
  external GFX_LibName {$IFDEF DELPHI} {$IFDEF MACOS} name '_filledPolygonRGBA' {$ENDIF} {$ENDIF};

{* Textured Polygon *}

function texturedPolygon(renderer: PSDL_Renderer; const vx, vy: pcint16; n: cint; texture: PSDL_Surface; texture_dx: cint; texture_dy: cint): Boolean; cdecl;
  external GFX_LibName {$IFDEF DELPHI} {$IFDEF MACOS} name '_texturedPolygon' {$ENDIF} {$ENDIF};

{* Bezier *}

function bezierColor(renderer: PSDL_Renderer; const vx, vy: pcint16; n, s: cint; color: cuint32): Boolean; cdecl;
  external GFX_LibName {$IFDEF DELPHI} {$IFDEF MACOS} name '_bezierColor' {$ENDIF} {$ENDIF};
function bezierRGBA(renderer: PSDL_Renderer; const vx, vy: pcint16; n, s: cint; r, g, b, a: cuint8): Boolean; cdecl;
  external GFX_LibName {$IFDEF DELPHI} {$IFDEF MACOS} name '_bezierRGBA' {$ENDIF} {$ENDIF};

{* Characters/Strings *}

procedure gfxPrimitivesSetFont(const fontdata: Pointer; cw, ch: cuint32); cdecl;
  external GFX_LibName {$IFDEF DELPHI} {$IFDEF MACOS} name '_gfxPrimitivesSetFont' {$ENDIF} {$ENDIF};
procedure gfxPrimitivesSetFontRotation(rotation: cuint32); cdecl;
  external GFX_LibName {$IFDEF DELPHI} {$IFDEF MACOS} name '_gfxPrimitivesSetFontRotation' {$ENDIF} {$ENDIF};
function characterColor(renderer: PSDL_Renderer; x, y: cint16; c: AnsiChar; color: cuint32): Boolean; cdecl;
  external GFX_LibName {$IFDEF DELPHI} {$IFDEF MACOS} name '_characterColor' {$ENDIF} {$ENDIF};
function characterRGBA(renderer: PSDL_Renderer; x, y: cint16; c: AnsiChar; r, g, b, a: cuint8): Boolean; cdecl;
  external GFX_LibName {$IFDEF DELPHI} {$IFDEF MACOS} name '_characterRGBA' {$ENDIF} {$ENDIF};
function stringColor(renderer: PSDL_Renderer; x, y: cint16; const s: PAnsiChar; color: cuint32): Boolean; cdecl;
  external GFX_LibName {$IFDEF DELPHI} {$IFDEF MACOS} name '_stringColor' {$ENDIF} {$ENDIF};
function stringRGBA(renderer: PSDL_Renderer; x, y: cint16; const s: PAnsiChar; r, g, b, a: cuint8): Boolean; cdecl;
  external GFX_LibName {$IFDEF DELPHI} {$IFDEF MACOS} name '_stringRGBA' {$ENDIF} {$ENDIF};
