(*
 * copyright (c) 2006 Michael Niedermayer <michaelni@gmx.at>
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
 * memory handling functions
 *)

(*
 * FFVCL - Delphi FFmpeg VCL Components
 * http://www.DelphiFFmpeg.com
 *
 * Original file: libavutil/mem.h
 * Ported by CodeCoolie@CNSW 2008/03/21 -> $Date:: 2014-10-16 #$
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

unit libavutil_mem;

interface

{$I CompilerDefines.inc}

{$I libversion.inc}

(**
 * @addtogroup lavu_mem
 * @{
 *)

(*
#if defined(__INTEL_COMPILER) && __INTEL_COMPILER < 1110 || defined(__SUNPRO_C)
    #define DECLARE_ALIGNED(n,t,v)      t __attribute__ ((aligned (n))) v
    #define DECLARE_ASM_CONST(n,t,v)    const t __attribute__ ((aligned (n))) v
#elif defined(__TI_COMPILER_VERSION__)
    #define DECLARE_ALIGNED(n,t,v)                      \
        AV_PRAGMA(DATA_ALIGN(v,n))                      \
        t __attribute__((aligned(n))) v
    #define DECLARE_ASM_CONST(n,t,v)                    \
        AV_PRAGMA(DATA_ALIGN(v,n))                      \
        static const t __attribute__((aligned(n))) v
#elif defined(__GNUC__)
    #define DECLARE_ALIGNED(n,t,v)      t __attribute__ ((aligned (n))) v
    #define DECLARE_ASM_CONST(n,t,v)    static const t av_used __attribute__ ((aligned (n))) v
#elif defined(_MSC_VER)
    #define DECLARE_ALIGNED(n,t,v)      __declspec(align(n)) t v
    #define DECLARE_ASM_CONST(n,t,v)    __declspec(align(n)) static const t v
#else
    #define DECLARE_ALIGNED(n,t,v)      t v
    #define DECLARE_ASM_CONST(n,t,v)    static const t v
#endif

#if AV_GCC_VERSION_AT_LEAST(3,1)
    #define av_malloc_attrib __attribute__((__malloc__))
#else
    #define av_malloc_attrib
#endif

#if AV_GCC_VERSION_AT_LEAST(4,3)
    #define av_alloc_size(...) __attribute__((alloc_size(__VA_ARGS__)))
#else
    #define av_alloc_size(...)
#endif
*)

(**
 * Allocate a block of size bytes with alignment suitable for all
 * memory accesses (including vectors if available on the CPU).
 * @param size Size in bytes for the memory block to be allocated.
 * @return Pointer to the allocated block, NULL if the block cannot
 * be allocated.
 * @see av_mallocz()
 *)
function av_malloc(size: Cardinal): Pointer; cdecl; external AVUTIL_LIBNAME name _PU + 'av_malloc';

(**
 * Allocate a block of size * nmemb bytes with av_malloc().
 * @param nmemb Number of elements
 * @param size Size of the single element
 * @return Pointer to the allocated block, NULL if the block cannot
 * be allocated.
 * @see av_malloc()
 *)
(*
av_alloc_size(1, 2) static inline void *av_malloc_array(size_t nmemb, size_t size)
{
    if (size <= 0 || nmemb >= INT_MAX / size)
        return NULL;
    return av_malloc(nmemb * size);
}
*)

(**
 * Allocate or reallocate a block of memory.
 * If ptr is NULL and size > 0, allocate a new block. If
 * size is zero, free the memory block pointed to by ptr.
 * @param ptr Pointer to a memory block already allocated with
 * av_realloc() or NULL.
 * @param size Size in bytes of the memory block to be allocated or
 * reallocated.
 * @return Pointer to a newly-reallocated block or NULL if the block
 * cannot be reallocated or the function is used to free the memory block.
 * @warning Pointers originating from the av_malloc() family of functions must
 *          not be passed to av_realloc(). The former can be implemented using
 *          memalign() (or other functions), and there is no guarantee that
 *          pointers from such functions can be passed to realloc() at all.
 *          The situation is undefined according to POSIX and may crash with
 *          some libc implementations.
 * @see av_fast_realloc()
 *)
function av_realloc(ptr: Pointer; size: Cardinal): Pointer; cdecl; external AVUTIL_LIBNAME name _PU + 'av_realloc';

(**
 * Allocate or reallocate a block of memory.
 * This function does the same thing as av_realloc, except:
 * - It takes two arguments and checks the result of the multiplication for
 *   integer overflow.
 * - It frees the input block in case of failure, thus avoiding the memory
 *   leak with the classic "buf = realloc(buf); if (!buf) return -1;".
 *)
function av_realloc_f(ptr: Pointer; nelem, elsize: Cardinal): Pointer; cdecl; external AVUTIL_LIBNAME name _PU + 'av_realloc_f';

(**
 * Allocate or reallocate a block of memory.
 * If *ptr is NULL and size > 0, allocate a new block. If
 * size is zero, free the memory block pointed to by ptr.
 * @param   ptr Pointer to a pointer to a memory block already allocated
 *          with av_realloc(), or pointer to a pointer to NULL.
 *          The pointer is updated on success, or freed on failure.
 * @param   size Size in bytes for the memory block to be allocated or
 *          reallocated
 * @return  Zero on success, an AVERROR error code on failure.
 * @warning Pointers originating from the av_malloc() family of functions must
 *          not be passed to av_reallocp(). The former can be implemented using
 *          memalign() (or other functions), and there is no guarantee that
 *          pointers from such functions can be passed to realloc() at all.
 *          The situation is undefined according to POSIX and may crash with
 *          some libc implementations.
 *)
function av_reallocp(ptr: Pointer; size: Cardinal): Integer; cdecl; external AVUTIL_LIBNAME name _PU + 'av_reallocp';

(**
 * Allocate or reallocate an array.
 * If ptr is NULL and nmemb > 0, allocate a new block. If
 * nmemb is zero, free the memory block pointed to by ptr.
 * @param ptr Pointer to a memory block already allocated with
 * av_realloc() or NULL.
 * @param nmemb Number of elements
 * @param size Size of the single element
 * @return Pointer to a newly-reallocated block or NULL if the block
 * cannot be reallocated or the function is used to free the memory block.
 * @warning Pointers originating from the av_malloc() family of functions must
 *          not be passed to av_realloc(). The former can be implemented using
 *          memalign() (or other functions), and there is no guarantee that
 *          pointers from such functions can be passed to realloc() at all.
 *          The situation is undefined according to POSIX and may crash with
 *          some libc implementations.
 *)
function av_realloc_array(ptr: Pointer; nmemb, size: Cardinal): Pointer; cdecl; external AVUTIL_LIBNAME name _PU + 'av_realloc_array';

(**
 * Allocate or reallocate an array through a pointer to a pointer.
 * If *ptr is NULL and nmemb > 0, allocate a new block. If
 * nmemb is zero, free the memory block pointed to by ptr.
 * @param ptr Pointer to a pointer to a memory block already allocated
 * with av_realloc(), or pointer to a pointer to NULL.
 * The pointer is updated on success, or freed on failure.
 * @param nmemb Number of elements
 * @param size Size of the single element
 * @return Zero on success, an AVERROR error code on failure.
 * @warning Pointers originating from the av_malloc() family of functions must
 *          not be passed to av_realloc(). The former can be implemented using
 *          memalign() (or other functions), and there is no guarantee that
 *          pointers from such functions can be passed to realloc() at all.
 *          The situation is undefined according to POSIX and may crash with
 *          some libc implementations.
 *)
function av_reallocp_array(ptr: Pointer; nmemb, size: Cardinal): Integer; cdecl; external AVUTIL_LIBNAME name _PU + 'av_reallocp_array';

(**
 * Free a memory block which has been allocated with av_malloc(z)() or
 * av_realloc().
 * @param ptr Pointer to the memory block which should be freed.
 * @note ptr = NULL is explicitly allowed.
 * @note It is recommended that you use av_freep() instead.
 * @see av_freep()
 *)
procedure av_free(ptr: Pointer); cdecl; external AVUTIL_LIBNAME name _PU + 'av_free';

(**
 * Allocate a block of size bytes with alignment suitable for all
 * memory accesses (including vectors if available on the CPU) and
 * zero all the bytes of the block.
 * @param size Size in bytes for the memory block to be allocated.
 * @return Pointer to the allocated block, NULL if it cannot be allocated.
 * @see av_malloc()
 *)
function av_mallocz(size: Cardinal): Pointer; cdecl; external AVUTIL_LIBNAME name _PU + 'av_mallocz';

(**
 * Allocate a block of nmemb * size bytes with alignment suitable for all
 * memory accesses (including vectors if available on the CPU) and
 * zero all the bytes of the block.
 * The allocation will fail if nmemb * size is greater than or equal
 * to INT_MAX.
 * @param nmemb
 * @param size
 * @return Pointer to the allocated block, NULL if it cannot be allocated.
 *)
function av_calloc(nmemb, size: Cardinal): Pointer; cdecl; external AVUTIL_LIBNAME name _PU + 'av_calloc';

(**
 * Allocate a block of size * nmemb bytes with av_mallocz().
 * @param nmemb Number of elements
 * @param size Size of the single element
 * @return Pointer to the allocated block, NULL if the block cannot
 * be allocated.
 * @see av_mallocz()
 * @see av_malloc_array()
 *)
(*
av_alloc_size(1, 2) static inline void *av_mallocz_array(size_t nmemb, size_t size)
{
    if (!size || nmemb >= INT_MAX / size)
        return NULL;
    return av_mallocz(nmemb * size);
}
*)

(**
 * Duplicate the string s.
 * @param s string to be duplicated
 * @return Pointer to a newly-allocated string containing a
 * copy of s or NULL if the string cannot be allocated.
 *)
function av_strdup(const s: PAnsiChar): PAnsiChar; cdecl; external AVUTIL_LIBNAME name _PU + 'av_strdup';

(**
 * Duplicate a substring of the string s.
 * @param s string to be duplicated
 * @param len the maximum length of the resulting string (not counting the
 *            terminating byte).
 * @return Pointer to a newly-allocated string containing a
 * copy of s or NULL if the string cannot be allocated.
 *)
function av_strndup(const s: PAnsiChar; len: Cardinal): PAnsiChar; cdecl; external AVUTIL_LIBNAME name _PU + 'av_strndup';

(**
 * Duplicate the buffer p.
 * @param p buffer to be duplicated
 * @return Pointer to a newly allocated buffer containing a
 * copy of p or NULL if the buffer cannot be allocated.
 *)
function av_memdup(const p: Pointer; size: Cardinal): Pointer; cdecl; external AVUTIL_LIBNAME name _PU + 'av_memdup';

(**
 * Free a memory block which has been allocated with av_malloc(z)() or
 * av_realloc() and set the pointer pointing to it to NULL.
 * @param ptr Pointer to the pointer to the memory block which should
 * be freed.
 * @note passing a pointer to a NULL pointer is safe and leads to no action.
 * @see av_free()
 *)
procedure av_freep(ptr: Pointer); cdecl; external AVUTIL_LIBNAME name _PU + 'av_freep';

(**
 * Add an element to a dynamic array.
 *
 * The array to grow is supposed to be an array of pointers to
 * structures, and the element to add must be a pointer to an already
 * allocated structure.
 *
 * The array is reallocated when its size reaches powers of 2.
 * Therefore, the amortized cost of adding an element is constant.
 *
 * In case of success, the pointer to the array is updated in order to
 * point to the new grown array, and the number pointed to by nb_ptr
 * is incremented.
 * In case of failure, the array is freed, *tab_ptr is set to NULL and
 * *nb_ptr is set to 0.
 *
 * @param tab_ptr pointer to the array to grow
 * @param nb_ptr  pointer to the number of elements in the array
 * @param elem    element to add
 * @see av_dynarray_add_nofree(), av_dynarray2_add()
 *)
procedure av_dynarray_add(tab_ptr: Pointer; nb_ptr: PInteger; elem: Pointer); cdecl; external AVUTIL_LIBNAME name _PU + 'av_dynarray_add';

(**
 * Add an element to a dynamic array.
 *
 * Function has the same functionality as av_dynarray_add(),
 * but it doesn't free memory on fails. It returns error code
 * instead and leave current buffer untouched.
 *
 * @param tab_ptr pointer to the array to grow
 * @param nb_ptr  pointer to the number of elements in the array
 * @param elem    element to add
 * @return >=0 on success, negative otherwise.
 * @see av_dynarray_add(), av_dynarray2_add()
 *)
function av_dynarray_add_nofree(tab_ptr: Pointer; nb_ptr: PInteger; elem: Pointer): Integer; cdecl; external AVUTIL_LIBNAME name _PU + 'av_dynarray_add_nofree';

(**
 * Add an element of size elem_size to a dynamic array.
 *
 * The array is reallocated when its number of elements reaches powers of 2.
 * Therefore, the amortized cost of adding an element is constant.
 *
 * In case of success, the pointer to the array is updated in order to
 * point to the new grown array, and the number pointed to by nb_ptr
 * is incremented.
 * In case of failure, the array is freed, *tab_ptr is set to NULL and
 * *nb_ptr is set to 0.
 *
 * @param tab_ptr   pointer to the array to grow
 * @param nb_ptr    pointer to the number of elements in the array
 * @param elem_size size in bytes of the elements in the array
 * @param elem_data pointer to the data of the element to add. If NULL, the space of
 *                  the new added element is not filled.
 * @return          pointer to the data of the element to copy in the new allocated space.
 *                  If NULL, the new allocated space is left uninitialized."
 * @see av_dynarray_add(), av_dynarray_add_nofree()
 *)
function av_dynarray2_add(tab_ptr: PPointer; nb_ptr: PInteger; elem_size: Cardinal;
                       const elem_data: PByte): Pointer; cdecl; external AVUTIL_LIBNAME name _PU + 'av_dynarray2_add';

(**
 * Multiply two size_t values checking for overflow.
 * @return  0 if success, AVERROR(EINVAL) if overflow.
 *)
(*
static inline int av_size_mult(size_t a, size_t b, size_t *r)
{
    size_t t = a * b;
    /* Hack inspired from glibc: only try the division if nelem and elsize
     * are both greater than sqrt(SIZE_MAX). */
    if ((a | b) >= ((size_t)1 << (sizeof(size_t) * 4)) && a && t / a != b)
        return AVERROR(EINVAL);
    *r = t;
    return 0;
}
*)

(**
 * Set the maximum size that may me allocated in one block.
 *)
procedure av_max_alloc(max: Cardinal); cdecl; external AVUTIL_LIBNAME name _PU + 'av_max_alloc';

(**
 * deliberately overlapping memcpy implementation
 * @param dst destination buffer
 * @param back how many bytes back we start (the initial size of the overlapping window), must be > 0
 * @param cnt number of bytes to copy, must be >= 0
 *
 * cnt > back is valid, this will copy the bytes we just copied,
 * thus creating a repeating pattern with a period length of back.
 *)
procedure av_memcpy_backptr(dst: PByte; back, cnt: Integer); cdecl; external AVUTIL_LIBNAME name _PU + 'av_memcpy_backptr';

(**
 * Reallocate the given block if it is not large enough, otherwise do nothing.
 *
 * @see av_realloc
 *)
function av_fast_realloc(ptr: Pointer; size: PCardinal; min_size: Cardinal): Pointer; cdecl; external AVUTIL_LIBNAME name _PU + 'av_fast_realloc';

(**
 * Allocate a buffer, reusing the given one if large enough.
 *
 * Contrary to av_fast_realloc the current buffer contents might not be
 * preserved and on error the old buffer is freed, thus no special
 * handling to avoid memleaks is necessary.
 *
 * @param ptr pointer to pointer to already allocated buffer, overwritten with pointer to new buffer
 * @param size size of the buffer *ptr points to
 * @param min_size minimum size of *ptr buffer after returning, *ptr will be NULL and
 *                 *size 0 if an error occurred.
 *)
procedure av_fast_malloc(ptr: Pointer; size: PCardinal; min_size: Cardinal); cdecl; external AVUTIL_LIBNAME name _PU + 'av_fast_malloc';

(**
 * @}
 *)

(**
 * Allocate a block of size * nmemb bytes with av_malloc().
 * @param nmemb Number of elements
 * @param size Size of the single element
 * @return Pointer to the allocated block, NULL if the block cannot
 * be allocated.
 * @see av_malloc()
 *)
function av_malloc_array(nmemb, size: Cardinal): Pointer; {$IFDEF USE_INLINE}inline;{$ENDIF}

(**
 * Allocate a block of size * nmemb bytes with av_mallocz().
 * @param nmemb Number of elements
 * @param size Size of the single element
 * @return Pointer to the allocated block, NULL if the block cannot
 * be allocated.
 * @see av_mallocz()
 * @see av_malloc_array()
 *)
function av_mallocz_array(nmemb, size: Cardinal): Pointer; {$IFDEF USE_INLINE}inline;{$ENDIF}

implementation


function av_malloc_array(nmemb, size: Cardinal): Pointer;
begin
  if (size <= 0) or (nmemb >= Cardinal(MaxInt) div size) then
    Result := nil
  else
    Result := av_malloc(nmemb * size);
end;

function av_mallocz_array(nmemb, size: Cardinal): Pointer;
begin
  if (size = 0) or (nmemb >= Cardinal(MaxInt) div size) then
    Result := nil
  else
    Result := av_mallocz(nmemb * size);
end;

end.
