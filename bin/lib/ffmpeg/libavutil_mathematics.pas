(*
 * copyright (c) 2005-2012 Michael Niedermayer <michaelni@gmx.at>
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

(*
 * FFVCL - Delphi FFmpeg VCL Components
 * http://www.DelphiFFmpeg.com
 *
 * Original file: libavutil/mathematics.h
 * Ported by CodeCoolie@CNSW 2008/03/29 -> $Date:: 2014-08-22 #$
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

unit libavutil_mathematics;

interface

{$I CompilerDefines.inc}

uses
  libavutil_rational;

{$I libversion.inc}

const
  M_E            = 2.7182818284590452354;   (* e *)
  {$EXTERNALSYM M_E}
  M_LN2          = 0.69314718055994530942;  (* log_e 2 *)
  {$EXTERNALSYM M_LN2}
  M_LN10         = 2.30258509299404568402;  (* log_e 10 *)
  {$EXTERNALSYM M_LN10}
  M_LOG2_10      = 3.32192809488736234787;  (* log_2 10 *)
  {$EXTERNALSYM M_PHI}
  M_PHI          = 1.61803398874989484820;  (* phi / golden ratio *)
  {$EXTERNALSYM M_LOG2_10}
  M_PI           = 3.14159265358979323846;  (* pi *)
  {$EXTERNALSYM M_PI}
  M_PI_2         = 1.57079632679489661923;  (* pi/2 *)
  {$EXTERNALSYM M_PI_2}
  M_SQRT1_2      = 0.70710678118654752440;  (* 1/sqrt(2) *)
  {$EXTERNALSYM M_SQRT1_2}
  M_SQRT2        = 1.41421356237309504880;  (* sqrt(2) *)
  {$EXTERNALSYM M_SQRT2}
//#ifndef NAN
//#define NAN            av_int2float(0x7fc00000)
//#endif
//#ifndef INFINITY
//#define INFINITY       av_int2float(0x7f800000)
//#endif

(**
 * @addtogroup lavu_math
 * @{
 *)

type
  TAVRounding = (
    AV_ROUND_ZERO     = 0, ///< Round toward zero
    AV_ROUND_INF      = 1, ///< Round away from zero
    AV_ROUND_DOWN     = 2, ///< Round toward -infinity
    AV_ROUND_UP       = 3, ///< Round toward +infinity
    AV_ROUND_NEAR_INF = 5, ///< Round to nearest and halfway cases away from zero
    AV_ROUND_PASS_MINMAX = 8192 ///< Flag to pass INT64_MIN/MAX through instead of rescaling, this avoids special cases for AV_NOPTS_VALUE
  );

(**
 * Return the greatest common divisor of a and b.
 * If both a and b are 0 or either or both are <0 then behavior is
 * undefined.
 *)
function av_gcd(a, b: Int64): Int64; cdecl; external AVUTIL_LIBNAME name _PU + 'av_gcd';

(**
 * Rescale a 64-bit integer with rounding to nearest.
 * A simple a*b/c isn't possible as it can overflow.
 *)
function av_rescale(a, b, c: Int64): Int64; cdecl; external AVUTIL_LIBNAME name _PU + 'av_rescale';

(**
 * Rescale a 64-bit integer with specified rounding.
 * A simple a*b/c isn't possible as it can overflow.
 *
 * @return rescaled value a, or if AV_ROUND_PASS_MINMAX is set and a is
 *         INT64_MIN or INT64_MAX then a is passed through unchanged.
 *)
function av_rescale_rnd(a, b, c: Int64; r: TAVRounding): Int64; cdecl; external AVUTIL_LIBNAME name _PU + 'av_rescale_rnd';

(**
 * Rescale a 64-bit integer by 2 rational numbers.
 *)
function av_rescale_q(a: Int64; bq, cq: TAVRational): Int64; cdecl; external AVUTIL_LIBNAME name _PU + 'av_rescale_q';

(**
 * Rescale a 64-bit integer by 2 rational numbers with specified rounding.
 *
 * @return rescaled value a, or if AV_ROUND_PASS_MINMAX is set and a is
 *         INT64_MIN or INT64_MAX then a is passed through unchanged.
 *)
function av_rescale_q_rnd(a: Int64; bq, cq: TAVRational;
                            r: TAVRounding): Int64; cdecl; external AVUTIL_LIBNAME name _PU + 'av_rescale_q_rnd';

(**
 * Compare 2 timestamps each in its own timebases.
 * The result of the function is undefined if one of the timestamps
 * is outside the int64_t range when represented in the others timebase.
 * @return -1 if ts_a is before ts_b, 1 if ts_a is after ts_b or 0 if they represent the same position
 *)
function av_compare_ts(ts_a: Int64; tb_a: TAVRational; ts_b: Int64; tb_b: TAVRational): Integer; cdecl; external AVUTIL_LIBNAME name _PU + 'av_compare_ts';

(**
 * Compare 2 integers modulo mod.
 * That is we compare integers a and b for which only the least
 * significant log2(mod) bits are known.
 *
 * @param mod must be a power of 2
 * @return a negative value if a is smaller than b
 *         a positive value if a is greater than b
 *         0                if a equals          b
 *)
function av_compare_mod(a, b, mod_: Int64): Int64; cdecl; external AVUTIL_LIBNAME name _PU + 'av_compare_mod';

(**
 * Rescale a timestamp while preserving known durations.
 *
 * @param in_ts Input timestamp
 * @param in_tb Input timebase
 * @param fs_tb Duration and *last timebase
 * @param duration duration till the next call
 * @param out_tb Output timebase
 *)
function av_rescale_delta(in_tb: TAVRational; in_ts: Int64; fs_tb: TAVRational; duration: Integer; last: PInt64; out_tb: TAVRational): Int64; cdecl; external AVUTIL_LIBNAME name _PU + 'av_rescale_delta';

(**
 * Add a value to a timestamp.
 *
 * This function guarantees that when the same value is repeatly added that
 * no accumulation of rounding errors occurs.
 *
 * @param ts Input timestamp
 * @param ts_tb Input timestamp timebase
 * @param inc value to add to ts
 * @param inc_tb inc timebase
 *)
function av_add_stable(ts_tb: TAVRational; ts: Int64; inc_tb: TAVRational; incr: TAVRational): Int64; cdecl; external AVUTIL_LIBNAME name _PU + 'av_add_stable';


(**
 * @}
 *)

implementation

end.
