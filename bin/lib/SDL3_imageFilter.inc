{
  This file is part of:

    SDL3 for Pascal
    (https://github.com/PascalGameDevelopment/SDL3-for-Pascal)
    SPDX-License-Identifier: Zlib
}

//
// All routines return:
//   0   OK
//  -1   Error (internal error, parameter error)
//

// SDL_imageFilterAdd: D = saturation255(S1 + S2)
function SDL_imageFilterAdd(Src1, Src2, Dest: pcuint8; length: cuint): cint; cdecl;
  external GFX_LibName {$IFDEF DELPHI} {$IFDEF MACOS} name '_SDL_imageFilterAdd' {$ENDIF} {$ENDIF};

//  SDL_imageFilterMean: D = S1/2 + S2/2
function SDL_imageFilterMean(Src1, Src2, Dest: pcuint8; length: cuint): cint; cdecl;
  external GFX_LibName {$IFDEF DELPHI} {$IFDEF MACOS} name '_SDL_imageFilterMean' {$ENDIF} {$ENDIF};

//  SDL_imageFilterSub: D = saturation0(S1 - S2)
function SDL_imageFilterSub(Src1, Src2, Dest: pcuint8; length: cuint): cint; cdecl;
  external GFX_LibName {$IFDEF DELPHI} {$IFDEF MACOS} name '_SDL_imageFilterSub' {$ENDIF} {$ENDIF};

//  SDL_imageFilterAbsDiff: D = | S1 - S2 |
function SDL_imageFilterAbsDiff(Src1, Src2, Dest: pcuint8; length: cuint): cint; cdecl;
  external GFX_LibName {$IFDEF DELPHI} {$IFDEF MACOS} name '_SDL_imageFilterAbsDiff' {$ENDIF} {$ENDIF};

//  SDL_imageFilterMult: D = saturation(S1 * S2)
function SDL_imageFilterMult(Src1, Src2, Dest: pcuint8; length: cuint): cint; cdecl;
  external GFX_LibName {$IFDEF DELPHI} {$IFDEF MACOS} name '_SDL_imageFilterMult' {$ENDIF} {$ENDIF};

//  SDL_imageFilterMultNor: D = S1 * S2
function SDL_imageFilterMultNor(Src1, Src2, Dest: pcuint8; length: cuint): cint; cdecl;
  external GFX_LibName {$IFDEF DELPHI} {$IFDEF MACOS} name '_SDL_imageFilterMultNor' {$ENDIF} {$ENDIF};

//  SDL_imageFilterMultDivby2: D = saturation255(S1/2 * S2)
function SDL_imageFilterMultDivby2(Src1, Src2, Dest: pcuint8; length: cuint): cint; cdecl;
  external GFX_LibName {$IFDEF DELPHI} {$IFDEF MACOS} name '_SDL_imageFilterMultDivby2' {$ENDIF} {$ENDIF};

//  SDL_imageFilterMultDivby4: D = saturation255(S1/2 * S2/2)
function SDL_imageFilterMultDivby4(Src1, Src2, Dest: pcuint8; length: cuint): cint; cdecl;
  external GFX_LibName {$IFDEF DELPHI} {$IFDEF MACOS} name '_SDL_imageFilterMultDivby4' {$ENDIF} {$ENDIF};

//  SDL_imageFilterBitAnd: D = S1 & S2
function SDL_imageFilterBitAnd(Src1, Src2, Dest: pcuint8; length: cuint): cint; cdecl;
  external GFX_LibName {$IFDEF DELPHI} {$IFDEF MACOS} name '_SDL_imageFilterBitAnd' {$ENDIF} {$ENDIF};

//  SDL_imageFilterBitOr: D = S1 | S2
function SDL_imageFilterBitOr(Src1, Src2, Dest: pcuint8; length: cuint): cint; cdecl;
  external GFX_LibName {$IFDEF DELPHI} {$IFDEF MACOS} name '_SDL_imageFilterBitOr' {$ENDIF} {$ENDIF};

//  SDL_imageFilterDiv: D = S1 / S2
function SDL_imageFilterDiv(Src1, Src2, Dest: pcuint8; length: cuint): cint; cdecl;
  external GFX_LibName {$IFDEF DELPHI} {$IFDEF MACOS} name '_SDL_imageFilterDiv' {$ENDIF} {$ENDIF};

//  SDL_imageFilterBitNegation: D = !S
function SDL_imageFilterBitNegation(Src1, Dest: pcuint8; length: cuint): cint; cdecl;
  external GFX_LibName {$IFDEF DELPHI} {$IFDEF MACOS} name '_SDL_imageFilterBitNegation' {$ENDIF} {$ENDIF};

//  SDL_imageFilterAddByte: D = saturation255(S + C)
function SDL_imageFilterAddByte(Src1, Dest: pcuint8; length: cuint; C: cuint8): cint; cdecl;
  external GFX_LibName {$IFDEF DELPHI} {$IFDEF MACOS} name '_SDL_imageFilterAddByte' {$ENDIF} {$ENDIF};

//  SDL_imageFilterAddUint: D = saturation255(S + (uint)C)
function SDL_imageFilterAddUint(Src1, Dest: pcuint8; length, bpp, C: cuint): cint; cdecl;
  external GFX_LibName {$IFDEF DELPHI} {$IFDEF MACOS} name '_SDL_imageFilterAddUint' {$ENDIF} {$ENDIF};

//  SDL_imageFilterAddByteToHalf: D = saturation255(S/2 + C)
function SDL_imageFilterAddByteToHalf(Src1, Dest: pcuint8; length: cuint; C: cuint8): cint; cdecl;
  external GFX_LibName {$IFDEF DELPHI} {$IFDEF MACOS} name '_SDL_imageFilterAddByteToHalf' {$ENDIF} {$ENDIF};

//  SDL_imageFilterSubByte: D = saturation0(S - C)
function SDL_imageFilterSubByte(Src1, Dest: pcuint8; length: cuint; C: cuint8): cint; cdecl;
  external GFX_LibName {$IFDEF DELPHI} {$IFDEF MACOS} name '_SDL_imageFilterSubByte' {$ENDIF} {$ENDIF};

//  SDL_imageFilterSubUint: D = saturation0(S - (uint)C)
function SDL_imageFilterSubUint(Src1, Dest: pcuint8; length, bpp, C: cuint): cint; cdecl;
  external GFX_LibName {$IFDEF DELPHI} {$IFDEF MACOS} name '_SDL_imageFilterSubUint' {$ENDIF} {$ENDIF};

//  SDL_imageFilterShiftRight: D = saturation0(S >> N)
function SDL_imageFilterShiftRight(Src1, Dest: pcuint8; length: cuint; N: cuint8): cint; cdecl;
  external GFX_LibName {$IFDEF DELPHI} {$IFDEF MACOS} name '_SDL_imageFilterShiftRight' {$ENDIF} {$ENDIF};

//  SDL_imageFilterShiftRightUint: D = saturation0((uint)S >> N)
function SDL_imageFilterShiftRightUint(Src1, Dest: pcuint8; length: cuint; N: cuint8): cint; cdecl;
  external GFX_LibName {$IFDEF DELPHI} {$IFDEF MACOS} name '_SDL_imageFilterShiftRightUint' {$ENDIF} {$ENDIF};

//  SDL_imageFilterMultByByte: D = saturation255(S * C)
function SDL_imageFilterMultByByte(Src1, Dest: pcuint8; length: cuint; C: cuint8): cint; cdecl;
  external GFX_LibName {$IFDEF DELPHI} {$IFDEF MACOS} name '_SDL_imageFilterMultByByte' {$ENDIF} {$ENDIF};

//  SDL_imageFilterShiftRightAndMultByByte: D = saturation255((S >> N) * C)
function SDL_imageFilterShiftRightAndMultByByte(Src1, Dest: pcuint8; length: cuint; N, C: cuint8): cint; cdecl;
  external GFX_LibName {$IFDEF DELPHI} {$IFDEF MACOS} name '_SDL_imageFilterShiftRightAndMultByByte' {$ENDIF} {$ENDIF};

//  SDL_imageFilterShiftLeftByte: D = (S << N)
function SDL_imageFilterShiftLeftByte(Src1, Dest: pcuint8; length: cuint; N: cuint8): cint; cdecl;
  external GFX_LibName {$IFDEF DELPHI} {$IFDEF MACOS} name '_SDL_imageFilterShiftLeftByte' {$ENDIF} {$ENDIF};

//  SDL_imageFilterShiftLeftUint: D = ((uint)S << N)
function SDL_imageFilterShiftLeftUint(Src1, Dest: pcuint8; length: cuint; N: cuint8): cint; cdecl;
  external GFX_LibName {$IFDEF DELPHI} {$IFDEF MACOS} name '_SDL_imageFilterShiftLeftUint' {$ENDIF} {$ENDIF};

//  SDL_imageFilterShiftLeft: D = saturation255(S << N)
function SDL_imageFilterShiftLeft(Src1, Dest: pcuint8; length: cuint; N: cuint8): cint; cdecl;
  external GFX_LibName {$IFDEF DELPHI} {$IFDEF MACOS} name '_SDL_imageFilterShiftLeft' {$ENDIF} {$ENDIF};

//  SDL_imageFilterBinarizeUsingThreshold: D = S >= T ? 255:0
function SDL_imageFilterBinarizeUsingThreshold(Src1, Dest: pcuint8; length: cuint; T: cuint8): cint; cdecl;
  external GFX_LibName {$IFDEF DELPHI} {$IFDEF MACOS} name '_SDL_imageFilterBinarizeUsingThreshold' {$ENDIF} {$ENDIF};

//  SDL_imageFilterClipToRange: D = (S >= Tmin) & (S <= Tmax) 255:0
function SDL_imageFilterClipToRange(Src1, Dest: pcuint8; length: cuint; Tmin, Tmax: cuint8): cint; cdecl;
  external GFX_LibName {$IFDEF DELPHI} {$IFDEF MACOS} name '_SDL_imageFilterClipToRange' {$ENDIF} {$ENDIF};

//  SDL_imageFilterNormalizeLinear: D = saturation255((Nmax - Nmin)/(Cmax - Cmin)*(S - Cmin) + Nmin)
function SDL_imageFilterNormalizeLinear(Src, Dest: pcuint8; length: cuint; Cmin, Cmax, Nmin, Nmax: cint): cint; cdecl;
  external GFX_LibName {$IFDEF DELPHI} {$IFDEF MACOS} name '_SDL_imageFilterNormalizeLinear' {$ENDIF} {$ENDIF};

