{
  This file is part of:

    SDL3 for Pascal
    (https://github.com/PascalGameDevelopment/SDL3-for-Pascal)
    SPDX-License-Identifier: Zlib
}

{*
 * A signed 8-bit integer type.
 *
 * \since This macro is available since SDL 3.2.0.
  }
type
  ppcint8_t=^pcint8_t;
  pcint8_t=^cint8_t;
  cint8_t=cint8;
const
  SDL_MAX_SINT8=cint8($7F);                 { 127  }
  SDL_MIN_SINT8=cint8(not ($7F));           { -128  }

{*
 * An unsigned 8-bit integer type.
 *
 * \since This macro is available since SDL 3.2.0.
  }
type
  ppcuint8_t=^pcuint8_t;
  pcuint8_t=^cuint8_t;
  cuint8_t=cuint8;
const
  SDL_MAX_UINT8=cuint8($FF);                { 255  }
  SDL_MIN_UINT8=cuint8($00);                { 0  }

{*
 * A signed 16-bit integer type.
 *
 * \since This macro is available since SDL 3.2.0.
  }
type
  ppcint16_t=^pcint16_t;
  pcint16_t=^cint16_t;
  cint16_t=cint16;
const
  SDL_MAX_SINT16=cint16($7FFF);             { 32767  }
  SDL_MIN_SINT16=cint16(not ($7FFF));      { -32768  }

{*
 * An unsigned 16-bit integer type.
 *
 * \since This macro is available since SDL 3.2.0.
  }
type
  ppcuint16_t=^pcuint16_t;
  pcuint16_t=^cuint16_t;
  cuint16_t=cuint16;
const
  SDL_MAX_UINT16=cuint16($FFFF);           { 65535  }
  SDL_MIN_UINT16=cuint16($0000);           { 0  }

{*
 * A signed 32-bit integer type.
 *
 * \since This macro is available since SDL 3.2.0.
  }
type
  ppcint32_t=^pcint32_t;
  pcint32_t=^cint32_t;
  cint32_t=cint32;
const
  SDL_MAX_SINT32=cint32($7FFFFFFF);        { 2147483647  }
  SDL_MIN_SINT32=cint32(not ($7FFFFFFF));  { -2147483648  }

{*
 * An unsigned 32-bit integer type.
 *
 * \since This macro is available since SDL 3.2.0.
  }
type
  ppcuint32_t=^pcuint32_t;
  pcuint32_t=^cuint32_t;
  cuint32_t=cuint32;
const
  SDL_MAX_UINT32=cuint32($FFFFFFFF);   { 4294967295  }
  SDL_MIN_UINT32=cuint32($00000000);   { 0  }

{*
 * A signed 64-bit integer type.
 *
 * \since This macro is available since SDL 3.2.0.
 *
 * \sa SDL_SINT64_C
  }
type
  ppcint64_t=^pcint64_t;
  pcint64_t=^cint64_t;
  cint64_t=cint64;
const
  { #note : SDL3-for-Pascal:
            The macro SDL_SINT64_C converts the values to guarantee their size.
            We do this simply by converting to cint64 here. }
  SDL_MAX_SINT64=cint64($7FFFFFFFFFFFFFFF);         { 9223372036854775807  }
  SDL_MIN_SINT64= not (cint64($7FFFFFFFFFFFFFFF));  { -9223372036854775808  }

{*
 * An unsigned 64-bit integer type.
 *
 * \since This macro is available since SDL 3.2.0.
 *
 * \sa SDL_UINT64_C
  }
type
  ppcuint64_t=^pcuint64_t;
  pcuint64_t=^cuint64_t;
  cuint64_t=cuint64;
const
  { #note : SDL3-for-Pascal:
            The macro SDL_SUINT64_C converts the values to guarantee their size.
            We do this simply by converting to cuint64 here. }
  SDL_MAX_UINT64=cuint64($FFFFFFFFFFFFFFFF);  { 18446744073709551615  }
  SDL_MIN_UINT64=cuint64($0000000000000000);  { 0  }

{*
 * SDL times are signed, 64-bit integers representing nanoseconds since the
 * Unix epoch (Jan 1, 1970).
 *
 * They can be converted between POSIX time_t values with SDL_NS_TO_SECONDS()
 * and SDL_SECONDS_TO_NS(), and between Windows FILETIME values with
 * SDL_TimeToWindows() and SDL_TimeFromWindows().
 *
 * \since This macro is available since SDL 3.2.0.
 *
 * \sa SDL_MAX_SINT64
 * \sa SDL_MIN_SINT64
  }
type
  PPSDL_Time = ^PSDL_Time;
  PSDL_Time = ^TSDL_Time;
  TSDL_Time = cint64;

const
  SDL_MAX_TIME = SDL_MAX_SINT64;
  SDL_MIN_TIME = SDL_MIN_SINT64;

{*
 * Epsilon constant, used for comparing floating-point numbers.
 *
 * Equals by default to platform-defined `FLT_EPSILON`, or
 * `1.1920928955078125e-07F` if that's not available.
 *
 * \since This macro is available since SDL 3.1.3.
  }
const
  SDL_FLT_EPSILON = cfloat(1.1920928955078125e-07);

{*
 * Compute the absolute value of `x`
 *
 * Domain: `-INF <= x <= INF`
 *
 * Range: `0 <= y <= INF`
 *
 * This function operates on double-precision floating point values, use
 * SDL_copysignf for single-precision floats.
 *
 * \param x floating point value to use as the magnitude.
 * \returns the absolute value of `x`.
 *
 * \threadsafety It is safe to call this function from any thread.
 *
 * \since This function is available since SDL 3.1.3.
 *
 * \sa SDL_fabsf
  }
function SDL_fabs(x: cdouble): cdouble; cdecl;
  external SDL_LibName {$IFDEF DELPHI} {$IFDEF MACOS} name '_SDL_fabs' {$ENDIF} {$ENDIF};

{*
 * Compute the absolute value of `x`
 *
 * Domain: `-INF <= x <= INF`
 *
 * Range: `0 <= y <= INF`
 *
 * This function operates on single-precision floating point values, use
 * SDL_copysignf for double-precision floats.
 *
 * \param x floating point value to use as the magnitude.
 * \returns the absolute value of `x`.
 *
 * \threadsafety It is safe to call this function from any thread.
 *
 * \since This function is available since SDL 3.1.3.
 *
 * \sa SDL_fabs
  }
function SDL_fabsf(x: cfloat): cfloat; cdecl;
  external SDL_LibName {$IFDEF DELPHI} {$IFDEF MACOS} name '_SDL_fabsf' {$ENDIF} {$ENDIF};

{*
 * A generic function pointer.
 *
 * In theory, generic function pointers should use this, instead of `void *`,
 * since some platforms could treat code addresses differently than data
 * addresses. Although in current times no popular platforms make this
 * distinction, it is more correct and portable to use the correct type for a
 * generic pointer.
 *
 * If for some reason you need to force this typedef to be an actual `void *`,
 * perhaps to work around a compiler or existing code, you can define
 * `SDL_FUNCTION_POINTER_IS_VOID_POINTER` before including any SDL headers.
 *
 * \since This datatype is available since SDL 3.1.3.
  }
type
  TSDL_FunctionPointer = procedure(parameter:Pointer); cdecl;

