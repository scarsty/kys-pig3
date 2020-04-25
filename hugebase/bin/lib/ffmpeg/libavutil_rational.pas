(*
 * rational numbers
 * Copyright (c) 2003 Michael Niedermayer <michaelni@gmx.at>
 *
 * This file is part of FFmpeg.
 *
 * FFmpeg is free software; you can redistribute it and/or
 * modify it under the terms of the GNU Lesser General Public
 * License as published by the Free Software Foundation; either
 * version 2.1 of the License, or (at your option) any later version.
 *
 * FFmpeg is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
 * Lesser General Public License for more details.
 *
 * You should have received a copy of the GNU Lesser General Public
 * License along with FFmpeg; if not, write to the Free Software
 * Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA 02110-1301 USA
 *)

(**
 * @file
 * rational numbers
 * @author Michael Niedermayer <michaelni@gmx.at>
 *)

(*
 * FFVCL - Delphi FFmpeg VCL Components
 * http://www.DelphiFFmpeg.com
 *
 * Original file: libavutil/rational.h
 * Ported by CodeCoolie@CNSW 2008/03/18 -> $Date:: 2014-07-23 #$
 *)

(*
FFmpeg Delphi/Pascal Headers and Examples License Agreement

A modified part of FFVCL - Delphi FFmpeg VCL Components.
Copyright (c) 2008-2014 DelphiFFmpeg.com
All rights reserved.
http://www.DelphiFFmpeg.com

Redistribution and use in source and binary forms, with or without
modification, are permitted provided that the following conditions
are met:
1. Redistributions of source code must retain the above copyright
   notice, this list of conditions and the following disclaimer.
2. Redistributions in binary form must reproduce the above copyright
   notice, this list of conditions and the following disclaimer in the
   documentation and/or other materials provided with the distribution.

This source code is provided "as is" by DelphiFFmpeg.com without
warranty of any kind, either expressed or implied, including but not
limited to the implied warranties of merchantability and/or fitness
for a particular purpose.

Please also notice the License agreement of FFmpeg libraries.
*)

unit libavutil_rational;

interface

{$I CompilerDefines.inc}

uses
{$IFDEF VCL_XE2_OR_ABOVE}
  System.Math;
{$ELSE}
  Math;
{$ENDIF}

{$I libversion.inc}

(**
 * @addtogroup lavu_math
 * @{
 *)

(**
 * rational number numerator/denominator
 *)
type
  PAVRational = ^TAVRational;
  TAVRational = record
    num: Integer; ///< numerator
    den: Integer; ///< denominator
  end;

(**
 * Create a rational.
 * Useful for compilers that do not support compound literals.
 * @note  The return value is not reduced.
 *)
function av_make_q(num, den: Integer): TAVRational; {$IFDEF USE_INLINE}inline;{$ENDIF}
(*
{
    AVRational r = { num, den };
    return r;
}
*)

(**
 * Compare two rationals.
 * @param a first rational
 * @param b second rational
 * @return 0 if a==b, 1 if a>b, -1 if a<b, and INT_MIN if one of the
 * values is of the form 0/0
 *)
function av_cmp_q(a, b: TAVRational): Integer; {$IFDEF USE_INLINE}inline;{$ENDIF}
(*
{
    const int64_t tmp= a.num * (int64_t)b.den - b.num * (int64_t)a.den;

    if(tmp) return (int)((tmp ^ a.den ^ b.den)>>63)|1;
    else if(b.den && a.den) return 0;
    else if(a.num && b.num) return (a.num>>31) - (b.num>>31);
    else                    return INT_MIN;
}
*)

(**
 * Convert rational to double.
 * @param a rational to convert
 * @return (double) a
 *)
function av_q2d(a: TAVRational): Double; {$IFDEF USE_INLINE}inline;{$ENDIF}
(*
{
    return a.num / (double) a.den;
}
*)

(**
 * Reduce a fraction.
 * This is useful for framerate calculations.
 * @param dst_num destination numerator
 * @param dst_den destination denominator
 * @param num source numerator
 * @param den source denominator
 * @param max the maximum allowed for dst_num & dst_den
 * @return 1 if exact, 0 otherwise
 *)
function av_reduce(dst_num, dst_den: PInteger; num, den, max: Int64): Integer; cdecl; external AVUTIL_LIBNAME name _PU + 'av_reduce';

(**
 * Multiply two rationals.
 * @param b first rational
 * @param c second rational
 * @return b*c
 *)
function av_mul_q(b, c: TAVRational): TAVRational; {$IFDEF USE_INLINE}inline;{$ENDIF}

(**
 * Divide one rational by another.
 * @param b first rational
 * @param c second rational
 * @return b/c
 *)
function av_div_q(b, c: TAVRational): TAVRational; {$IFDEF USE_INLINE}inline;{$ENDIF}

(**
 * Add two rationals.
 * @param b first rational
 * @param c second rational
 * @return b+c
 *)
function av_add_q(b, c: TAVRational): TAVRational; {$IFDEF USE_INLINE}inline;{$ENDIF}

(**
 * Subtract one rational from another.
 * @param b first rational
 * @param c second rational
 * @return b-c
 *)
function av_sub_q(b, c: TAVRational): TAVRational; {$IFDEF USE_INLINE}inline;{$ENDIF}

(**
 * Invert a rational.
 * @param q value
 * @return 1 / q
 *)
function av_inv_q(q: TAVRational): TAVRational; {$IFDEF USE_INLINE}inline;{$ENDIF}
(*
{
    AVRational r = { q.den, q.num };
    return r;
}
*)

(**
 * Convert a double precision floating point number to a rational.
 * inf is expressed as {1,0} or {-1,0} depending on the sign.
 *
 * @param d double to convert
 * @param max the maximum allowed numerator and denominator
 * @return (AVRational) d
 *)
function av_d2q(d: Double; max: Integer): TAVRational; {$IFDEF USE_INLINE}inline;{$ENDIF}

(**
 * @return 1 if q1 is nearer to q than q2, -1 if q2 is nearer
 * than q1, 0 if they have the same distance.
 *)
function av_nearer_q(q, q1, q2: TAVRational): Integer; cdecl; external AVUTIL_LIBNAME name _PU + 'av_nearer_q';

(**
 * Find the nearest value in q_list to q.
 * @param q_list an array of rationals terminated by {0, 0}
 * @return the index of the nearest value found in the array
 *)
function av_find_nearest_q_idx(q: TAVRational; const q_list: PAVRational): Integer; cdecl; external AVUTIL_LIBNAME name _PU + 'av_find_nearest_q_idx';

(**
 * @}
 *)

implementation


(**
 * Create a rational.
 * Useful for compilers that do not support compound literals.
 * @note  The return value is not reduced.
 *)
function av_make_q(num, den: Integer): TAVRational;
begin
  Result.num := num;
  Result.den := den;
end;

(**
 * Compare two rationals.
 * @param a first rational
 * @param b second rational
 * @return 0 if a==b, 1 if a>b, -1 if a<b, and INT_MIN if one of the
 * values is of the form 0/0
 *)
function av_cmp_q(a, b: TAVRational): Integer;
var
  tmp: Int64;
begin
(*
    const int64_t tmp= a.num * (int64_t)b.den - b.num * (int64_t)a.den;

    if(tmp) return (int)((tmp ^ a.den ^ b.den)>>63)|1;
    else if(b.den && a.den) return 0;
    else if(a.num && b.num) return (a.num>>31) - (b.num>>31);
    else                    return INT_MIN;
*)
  tmp := a.num * Int64(b.den) - b.num * Int64(a.den);
  if tmp <> 0 then
  begin
    tmp := tmp xor a.den xor b.den;
    if tmp > 0 then
      Result := 1
    else if tmp < 0 then
      Result := -1
    else
      Result := 1;
  end
  else if (b.den <> 0) and (a.den <> 0) then
    Result := 0
  else if (a.num <> 0) and (b.num <> 0) then
  begin
    if a.num > 0 then
    begin
      if b.num > 0 then
        Result := 0
      else
        Result := 1;
    end
    else
    begin
      if b.num > 0 then
        Result := 1
      else
        Result := 0;
    end;
  end
  else
    Result := Low(Integer);
end;

(**
 * Invert a rational.
 * @param q value
 * @return 1 / q
 *)
function av_inv_q(q: TAVRational): TAVRational;
begin
  Result.num := q.den;
  Result.den := q.num;
end;

(**
 * Convert rational to double.
 * @param a rational to convert
 * @return (double) a
 *)
function av_q2d(a: TAVRational): Double;
begin
  Result := a.num / a.den;
end;

(****** TODO: check from libavutil/rational.c **************)
function av_mul_q(b, c: TAVRational): TAVRational;
begin
  av_reduce(@Result.num, @Result.den,
            b.num * Int64(c.num),
            b.den * Int64(c.den), MaxInt);
end;

function av_div_q(b, c: TAVRational): TAVRational;
begin
  // return av_mul_q(b, (AVRational) { c.den, c.num });
  av_reduce(@Result.num, @Result.den,
            b.num * Int64(c.den),
            b.den * Int64(c.num), MaxInt);
end;

function av_add_q(b, c: TAVRational): TAVRational;
begin
  av_reduce(@Result.num, @Result.den,
            b.num * Int64(c.den) +
            c.num * Int64(b.den),
            b.den * Int64(c.den), MaxInt);
end;

function av_sub_q(b, c: TAVRational): TAVRational;
begin
  // return av_add_q(b, (AVRational) { -c.num, c.den });
  av_reduce(@Result.num, @Result.den,
            b.num * Int64(c.den) -
            c.num * Int64(b.den),
            b.den * Int64(c.den), MaxInt);
end;

function av_d2q(d: Double; max: Integer): TAVRational;
var
  exponent: Integer;
  den: Int64;
begin
  if IsNaN(d) then
  begin
    Result.num := 0;
    Result.den := 0;
    Exit;
  end;
  //if IsInfinite(d) then
  if Abs(d) > Int64(MaxInt) + Int64(3) then
  begin
    if d < 0 then
      Result.num := -1
    else
      Result.num := 1;
    Result.den := 0;
    Exit;
  end;
  exponent := Round(Log10(Abs(d) + 1e-20) / 0.69314718055994530941723212145817656807550013436025);
  if exponent < 0 then
    exponent := 0;
  den := 1 shl (61 - exponent);
  // (int64_t)rint() and llrint() do not work with gcc on ia64 and sparc64
  av_reduce(@Result.num, @Result.den, Floor(d * den + 0.5), den, max);
  if ((Result.num = 0) or (Result.den = 0)) and (d <> 0) and (max > 0) and (max < MaxInt) then
    av_reduce(@Result.num, @Result.den, Floor(d * den + 0.5), den, MaxInt);
end;

end.
