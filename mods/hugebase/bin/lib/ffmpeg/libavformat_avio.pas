(*
 * copyright (c) 2001 Fabrice Bellard
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
 * @ingroup lavf_io
 * Buffered I/O operations
 *)

(*
 * FFVCL - Delphi FFmpeg VCL Components
 * http://www.DelphiFFmpeg.com
 *
 * Original file: libavformat/avio.h
 * Ported by CodeCoolie@CNSW 2008/03/20 -> $Date:: 2015-03-24 #$
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

unit libavformat_avio;

interface

{$I CompilerDefines.inc}

uses
  FFTypes,
  libavutil_bprint,
  libavutil_dict,
  libavutil_log;

{$I libversion.inc}

const
  AVIO_SEEKABLE_NORMAL = $0001; (**< Seeking works like for a local file *)

type
(**
 * Callback for checking whether to abort blocking functions.
 * AVERROR_EXIT is returned in this case by the interrupted
 * function. During blocking operations, callback is called with
 * opaque as parameter. If the callback returns 1, the
 * blocking operation will be aborted.
 *
 * No members can be added to this struct without a major bump, if
 * new elements have been added after this struct in AVFormatContext
 * or AVIOContext.
 *)
  PAVIOInterruptCB = ^TAVIOInterruptCB;
  TAVIOInterruptCB = record
    callback: function(opaque: Pointer): Integer; cdecl;
    opaque: Pointer;
  end;

(**
 * Bytestream IO Context.
 * New fields can be added to the end with minor version bumps.
 * Removal, reordering and changes to existing fields require a major
 * version bump.
 * sizeof(AVIOContext) must not be used outside libav*.
 *
 * @note None of the function pointers in AVIOContext should be called
 *       directly, they should only be set by the client application
 *       when implementing custom I/O. Normally these are set to the
 *       function pointers specified in avio_alloc_context()
 *)
  PPAVIOContext = ^PAVIOContext;
  PAVIOContext = ^TAVIOContext;
  TAVIOContext = record
    (**
     * A class for private options.
     *
     * If this AVIOContext is created by avio_open2(), av_class is set and
     * passes the options down to protocols.
     *
     * If this AVIOContext is manually allocated, then av_class may be set by
     * the caller.
     *
     * warning -- this field can be NULL, be sure to not pass this AVIOContext
     * to any av_opt_* functions in that case.
     *)
    av_class: PAVClass;
    buffer: PByte;        (**< Start of the buffer. *)
    buffer_size: Integer; (**< Maximum buffer size *)
    buf_ptr: PByte;       (**< Current position in the buffer *)
    buf_end: PByte;       (**< End of the data, may be less than
                               buffer+buffer_size if the read function returned
                               less data than requested, e.g. for streams where
                               no more data has been received yet. *)
    opaque: Pointer;      (**< A private pointer, passed to the read/write/seek/...
                               functions. *)
    read_packet: function(opaque: Pointer; buf: PByte; buf_size: Integer): Integer; cdecl;
    write_packet: function(opaque: Pointer; buf: PByte; buf_size: Integer): Integer; cdecl;
    seek: function(opaque: Pointer; offset: Int64; whence: Integer): Int64; cdecl;
    pos: Int64;           (**< position in the file of the current buffer *)
    must_flush: Integer;  (**< true if the next seek should flush *)
    eof_reached: Integer; (**< true if eof reached *)
    write_flag: Integer;  (**< true if open for writing *)
    max_packet_size: Integer;
    checksum: Cardinal;
    checksum_ptr: PByte;
    update_checksum: function(checksum: Cardinal; const buf: PByte; size: Cardinal): Cardinal; cdecl;
    error: Integer;       (**< contains the error code or 0 if no error happened *)
    (**
     * Pause or resume playback for network streaming protocols - e.g. MMS.
     *)
    read_pause: function(opaque: Pointer; pause: Integer): Integer; cdecl;
    (**
     * Seek to a given timestamp in stream with the specified stream_index.
     * Needed for some network streaming protocols which don't support seeking
     * to byte position.
     *)
    read_seek: function(opaque: Pointer; stream_index: Integer;
                        timestamp: Int64; flags: Integer): Int64; cdecl;
    (**
     * A combination of AVIO_SEEKABLE_ flags or 0 when the stream is not seekable.
     *)
    seekable: Integer;

    (**
     * max filesize, used to limit allocations
     * This field is internal to libavformat and access from outside is not allowed.
     *)
    maxsize: Int64;

    (**
     * avio_read and avio_write should if possible be satisfied directly
     * instead of going through a buffer, and avio_seek will always
     * call the underlying seek function directly.
     *)
    direct: Integer;

    (**
     * Bytes read statistic
     * This field is internal to libavformat and access from outside is not allowed.
     *)
    bytes_read: Int64;

    (**
     * seek statistic
     * This field is internal to libavformat and access from outside is not allowed.
     *)
    seek_count: Integer;

    (**
     * writeout statistic
     * This field is internal to libavformat and access from outside is not allowed.
     *)
    writeout_count: Integer;

    (**
     * Original buffer size
     * used internally after probing and ensure seekback to reset the buffer size
     * This field is internal to libavformat and access from outside is not allowed.
     *)
    orig_buffer_size: Integer;
  end;

(* unbuffered I/O *)

(**
 * Return the name of the protocol that will handle the passed URL.
 *
 * NULL is returned if no protocol could be found for the given URL.
 *
 * @return Name of the protocol or NULL.
 *)
function avio_find_protocol_name(const url: PAnsiChar): PAnsiChar; cdecl; external AVFORMAT_LIBNAME name _PU + 'avio_find_protocol_name';

(**
 * Return AVIO_FLAG_* access flags corresponding to the access permissions
 * of the resource in url, or a negative value corresponding to an
 * AVERROR code in case of failure. The returned access flags are
 * masked by the value in flags.
 *
 * @note This function is intrinsically unsafe, in the sense that the
 * checked resource may change its existence or permission status from
 * one call to another. Thus you should not trust the returned value,
 * unless you are sure that no other processes are accessing the
 * checked resource.
 *)
function avio_check(const url: PAnsiChar; flags: Integer): Integer; cdecl; external AVFORMAT_LIBNAME name _PU + 'avio_check';

(**
 * Allocate and initialize an AVIOContext for buffered I/O. It must be later
 * freed with av_free().
 *
 * @param buffer Memory block for input/output operations via AVIOContext.
 *        The buffer must be allocated with av_malloc() and friends.
 *        It may be freed and replaced with a new buffer by libavformat.
 *        AVIOContext.buffer holds the buffer currently in use,
 *        which must be later freed with av_free().
 * @param buffer_size The buffer size is very important for performance.
 *        For protocols with fixed blocksize it should be set to this blocksize.
 *        For others a typical size is a cache page, e.g. 4kb.
 * @param write_flag Set to 1 if the buffer should be writable, 0 otherwise.
 * @param opaque An opaque pointer to user-specific data.
 * @param read_packet  A function for refilling the buffer, may be NULL.
 * @param write_packet A function for writing the buffer contents, may be NULL.
 *        The function may not change the input buffers content.
 * @param seek A function for seeking to specified byte position, may be NULL.
 *
 * @return Allocated AVIOContext or NULL on failure.
 *)
type
  Tread_packetCall = function(opaque: Pointer; buf: PByte; buf_size: Integer): Integer; cdecl;
  Twrite_packetCall = function(opaque: Pointer; buf: PByte; buf_size: Integer): Integer; cdecl;
  TseekCall = function(opaque: Pointer; offset: Int64; whence: Integer): Int64; cdecl;
function avio_alloc_context(
                  buffer: PByte;
                  buffer_size: Integer;
                  write_flag: Integer;
                  opaque: Pointer;
                  read_packet: Tread_packetCall;
                  write_packet: Twrite_packetCall;
                  seek: TseekCall): PAVIOContext; cdecl; external AVFORMAT_LIBNAME name _PU + 'avio_alloc_context';

procedure avio_w8(s: PAVIOContext; b: Integer); cdecl; external AVFORMAT_LIBNAME name _PU + 'avio_w8';
procedure avio_write(s: PAVIOContext; const buf: PByte; size: Integer); cdecl; external AVFORMAT_LIBNAME name _PU + 'avio_write';
procedure avio_wl64(s: PAVIOContext; val: Int64); cdecl; external AVFORMAT_LIBNAME name _PU + 'avio_wl64';
procedure avio_wb64(s: PAVIOContext; val: Int64); cdecl; external AVFORMAT_LIBNAME name _PU + 'avio_wb64';
procedure avio_wl32(s: PAVIOContext; val: Cardinal); cdecl; external AVFORMAT_LIBNAME name _PU + 'avio_wl32';
procedure avio_wb32(s: PAVIOContext; val: Cardinal); cdecl; external AVFORMAT_LIBNAME name _PU + 'avio_wb32';
procedure avio_wl24(s: PAVIOContext; val: Cardinal); cdecl; external AVFORMAT_LIBNAME name _PU + 'avio_wl24';
procedure avio_wb24(s: PAVIOContext; val: Cardinal); cdecl; external AVFORMAT_LIBNAME name _PU + 'avio_wb24';
procedure avio_wl16(s: PAVIOContext; val: Cardinal); cdecl; external AVFORMAT_LIBNAME name _PU + 'avio_wl16';
procedure avio_wb16(s: PAVIOContext; val: Cardinal); cdecl; external AVFORMAT_LIBNAME name _PU + 'avio_wb16';

(**
 * Write a NULL-terminated string.
 * @return number of bytes written.
 *)
function avio_put_str(s: PAVIOContext; const str: PAnsiChar): Integer; cdecl; external AVFORMAT_LIBNAME name _PU + 'avio_put_str';

(**
 * Convert an UTF-8 string to UTF-16LE and write it.
 * @return number of bytes written.
 *)
function avio_put_str16le(s: PAVIOContext; const str: PAnsiChar): Integer; cdecl; external AVFORMAT_LIBNAME name _PU + 'avio_put_str16le';

(**
 * Convert an UTF-8 string to UTF-16BE and write it.
 * @return number of bytes written.
 *)
function avio_put_str16be(s: PAVIOContext; const str: PAnsiChar): Integer; cdecl; external AVFORMAT_LIBNAME name _PU + 'avio_put_str16be';

const
(**
 * Passing this as the "whence" parameter to a seek function causes it to
 * return the filesize without seeking anywhere. Supporting this is optional.
 * If it is not supported then the seek function will return <0.
 *)
  AVSEEK_SIZE  = $10000;

(**
 * Oring this flag as into the "whence" parameter to a seek function causes it to
 * seek by any means (like reopening and linear reading) or other normally unreasonable
 * means that can be extremely slow.
 * This may be ignored by the seek code.
 *)
  AVSEEK_FORCE = $20000;

(**
 * fseek() equivalent for AVIOContext.
 * @return new position or AVERROR.
 *)
function avio_seek(s: PAVIOContext; offset: Int64; whence: Integer): Int64; cdecl; external AVFORMAT_LIBNAME name _PU + 'avio_seek';

(**
 * Skip given number of bytes forward
 * @return new position or AVERROR.
 *)
function avio_skip(s: PAVIOContext; offset: Int64): Int64; cdecl; external AVFORMAT_LIBNAME name _PU + 'avio_skip';

(**
 * ftell() equivalent for AVIOContext.
 * @return position or AVERROR.
 *)
//static av_always_inline int64_t avio_tell(AVIOContext *s)
//{
//    return avio_seek(s, 0, SEEK_CUR);
//}

(**
 * Get the filesize.
 * @return filesize or AVERROR
 *)
function avio_size(s: PAVIOContext): Int64; cdecl; external AVFORMAT_LIBNAME name _PU + 'avio_size';

(**
 * feof() equivalent for AVIOContext.
 * @return non zero if and only if end of file
 *)
function avio_feof(s: PAVIOContext): Integer; cdecl; external AVFORMAT_LIBNAME name _PU + 'avio_feof';
{$IFDEF FF_API_URL_FEOF}
(**
 * @deprecated use avio_feof()
 *)
function url_feof(s: PAVIOContext): Integer; cdecl; external AVFORMAT_LIBNAME name _PU + 'url_feof';
{$ENDIF}

(** @warning currently size is limited *)
function avio_printf(s: PAVIOContext; const fmt: PAnsiChar): Integer; cdecl varargs; external AVFORMAT_LIBNAME name _PU + 'avio_printf';

(**
 * Force flushing of buffered data.
 *
 * For write streams, force the buffered data to be immediately written to the output,
 * without to wait to fill the internal buffer.
 *
 * For read streams, discard all currently buffered data, and advance the
 * reported file position to that of the underlying stream. This does not
 * read new data, and does not perform any seeks.
 *)
procedure avio_flush(s: PAVIOContext); cdecl; external AVFORMAT_LIBNAME name _PU + 'avio_flush';

(**
 * Read size bytes from AVIOContext into buf.
 * @return number of bytes read or AVERROR
 *)
function avio_read(s: PAVIOContext; buf: PAnsiChar; size: Integer): Integer; cdecl; external AVFORMAT_LIBNAME name _PU + 'avio_read';

(**
 * @name Functions for reading from AVIOContext
 * @{
 *
 * @note return 0 if EOF, so you cannot use it if EOF handling is
 *       necessary
 *)
function avio_r8(s: PAVIOContext): Integer; cdecl; external AVFORMAT_LIBNAME name _PU + 'avio_r8';
function avio_rl16(s: PAVIOContext): Cardinal; cdecl; external AVFORMAT_LIBNAME name _PU + 'avio_rl16';
function avio_rl24(s: PAVIOContext): Cardinal; cdecl; external AVFORMAT_LIBNAME name _PU + 'avio_rl24';
function avio_rl32(s: PAVIOContext): Cardinal; cdecl; external AVFORMAT_LIBNAME name _PU + 'avio_rl32';
function avio_rl64(s: PAVIOContext): Int64; cdecl; external AVFORMAT_LIBNAME name _PU + 'avio_rl64';
function avio_rb16(s: PAVIOContext): Cardinal; cdecl; external AVFORMAT_LIBNAME name _PU + 'avio_rb16';
function avio_rb24(s: PAVIOContext): Cardinal; cdecl; external AVFORMAT_LIBNAME name _PU + 'avio_rb24';
function avio_rb32(s: PAVIOContext): Cardinal; cdecl; external AVFORMAT_LIBNAME name _PU + 'avio_rb32';
function avio_rb64(s: PAVIOContext): Int64; cdecl; external AVFORMAT_LIBNAME name _PU + 'avio_rb64';
(**
 * @}
 *)

(**
 * Read a string from pb into buf. The reading will terminate when either
 * a NULL character was encountered, maxlen bytes have been read, or nothing
 * more can be read from pb. The result is guaranteed to be NULL-terminated, it
 * will be truncated if buf is too small.
 * Note that the string is not interpreted or validated in any way, it
 * might get truncated in the middle of a sequence for multi-byte encodings.
 *
 * @return number of bytes read (is always <= maxlen).
 * If reading ends on EOF or error, the return value will be one more than
 * bytes actually read.
 *)
function avio_get_str(pb: PAVIOContext; maxlen: Integer; buf: PAnsiChar; buflen: Integer): Integer; cdecl; external AVFORMAT_LIBNAME name _PU + 'avio_get_str';

(**
 * Read a UTF-16 string from pb and convert it to UTF-8.
 * The reading will terminate when either a null or invalid character was
 * encountered or maxlen bytes have been read.
 * @return number of bytes read (is always <= maxlen)
 *)
function avio_get_str16le(pb: PAVIOContext; maxlen: Integer; buf: PAnsiChar; buflen: Integer): Integer; cdecl; external AVFORMAT_LIBNAME name _PU + 'avio_get_str16le';
function avio_get_str16be(pb: PAVIOContext; maxlen: Integer; buf: PAnsiChar; buflen: Integer): Integer; cdecl; external AVFORMAT_LIBNAME name _PU + 'avio_get_str16be';


const
(**
 * @name URL open modes
 * The flags argument to avio_open must be one of the following
 * constants, optionally ORed with other flags.
 * @{
 *)
  AVIO_FLAG_READ  = 1;                                        (**< read-only *)
  AVIO_FLAG_WRITE = 2;                                        (**< write-only *)
  AVIO_FLAG_READ_WRITE = (AVIO_FLAG_READ or AVIO_FLAG_WRITE); (**< read-write pseudo flag *)
(**
 * @}
 *)

(**
 * Use non-blocking mode.
 * If this flag is set, operations on the context will return
 * AVERROR(EAGAIN) if they can not be performed immediately.
 * If this flag is not set, operations on the context will never return
 * AVERROR(EAGAIN).
 * Note that this flag does not affect the opening/connecting of the
 * context. Connecting a protocol will always block if necessary (e.g. on
 * network protocols) but never hang (e.g. on busy devices).
 * Warning: non-blocking protocols is work-in-progress; this flag may be
 * silently ignored.
 *)
  AVIO_FLAG_NONBLOCK  = 8;

(**
 * Use direct mode.
 * avio_read and avio_write should if possible be satisfied directly
 * instead of going through a buffer, and avio_seek will always
 * call the underlying seek function directly.
 *)
  AVIO_FLAG_DIRECT = $8000;

(**
 * Create and initialize a AVIOContext for accessing the
 * resource indicated by url.
 * @note When the resource indicated by url has been opened in
 * read+write mode, the AVIOContext can be used only for writing.
 *
 * @param s Used to return the pointer to the created AVIOContext.
 * In case of failure the pointed to value is set to NULL.
 * @param url resource to access
 * @param flags flags which control how the resource indicated by url
 * is to be opened
 * @return >= 0 in case of success, a negative value corresponding to an
 * AVERROR code in case of failure
 *)
function avio_open(s: PPAVIOContext; const url: PAnsiChar; flags: Integer): Integer; cdecl; external AVFORMAT_LIBNAME name _PU + 'avio_open';

(**
 * Create and initialize a AVIOContext for accessing the
 * resource indicated by url.
 * @note When the resource indicated by url has been opened in
 * read+write mode, the AVIOContext can be used only for writing.
 *
 * @param s Used to return the pointer to the created AVIOContext.
 * In case of failure the pointed to value is set to NULL.
 * @param url resource to access
 * @param flags flags which control how the resource indicated by url
 * is to be opened
 * @param int_cb an interrupt callback to be used at the protocols level
 * @param options  A dictionary filled with protocol-private options. On return
 * this parameter will be destroyed and replaced with a dict containing options
 * that were not found. May be NULL.
 * @return >= 0 in case of success, a negative value corresponding to an
 * AVERROR code in case of failure
 *)
function avio_open2(s: PPAVIOContext; const url: PAnsiChar; flags: Integer;
               const int_cb: PAVIOInterruptCB; options: PPAVDictionary): Integer; cdecl; external AVFORMAT_LIBNAME name _PU + 'avio_open2';

(**
 * Close the resource accessed by the AVIOContext s and free it.
 * This function can only be used if s was opened by avio_open().
 *
 * The internal buffer is automatically flushed before closing the
 * resource.
 *
 * @return 0 on success, an AVERROR < 0 on error.
 * @see avio_closep
 *)
function avio_close(s: PAVIOContext): Integer; cdecl; external AVFORMAT_LIBNAME name _PU + 'avio_close';

(**
 * Close the resource accessed by the AVIOContext *s, free it
 * and set the pointer pointing to it to NULL.
 * This function can only be used if s was opened by avio_open().
 *
 * The internal buffer is automatically flushed before closing the
 * resource.
 *
 * @return 0 on success, an AVERROR < 0 on error.
 * @see avio_close
 *)
function avio_closep(s: PPAVIOContext): Integer; cdecl; external AVFORMAT_LIBNAME name _PU + 'avio_closep';


(**
 * Open a write only memory stream.
 *
 * @param s new IO context
 * @return zero if no error.
 *)
function avio_open_dyn_buf(s: PPAVIOContext): Integer; cdecl; external AVFORMAT_LIBNAME name _PU + 'avio_open_dyn_buf';

(**
 * Return the written size and a pointer to the buffer. The buffer
 * must be freed with av_free().
 * Padding of FF_INPUT_BUFFER_PADDING_SIZE is added to the buffer.
 *
 * @param s IO context
 * @param pbuffer pointer to a byte buffer
 * @return the length of the byte buffer
 *)
function avio_close_dyn_buf(s: PAVIOContext; pbuffer: PPByte): Integer; cdecl; external AVFORMAT_LIBNAME name _PU + 'avio_close_dyn_buf';

(**
 * Iterate through names of available protocols.
 *
 * @param opaque A private pointer representing current protocol.
 *        It must be a pointer to NULL on first iteration and will
 *        be updated by successive calls to avio_enum_protocols.
 * @param output If set to 1, iterate over output protocols,
 *               otherwise over input protocols.
 *
 * @return A static string containing the name of current protocol or NULL
 *)
function avio_enum_protocols(opaque: PPointer; output: Integer): PAnsiChar; cdecl; external AVFORMAT_LIBNAME name _PU + 'avio_enum_protocols';

(**
 * Pause and resume playing - only meaningful if using a network streaming
 * protocol (e.g. MMS).
 *
 * @param h     IO context from which to call the read_pause function pointer
 * @param pause 1 for pause, 0 for resume
 *)
function avio_pause(h: PAVIOContext; pause: Integer): Integer; cdecl; external AVFORMAT_LIBNAME name _PU + 'avio_pause';

(**
 * Seek to a given timestamp relative to some component stream.
 * Only meaningful if using a network streaming protocol (e.g. MMS.).
 *
 * @param h IO context from which to call the seek function pointers
 * @param stream_index The stream index that the timestamp is relative to.
 *        If stream_index is (-1) the timestamp should be in AV_TIME_BASE
 *        units from the beginning of the presentation.
 *        If a stream_index >= 0 is used and the protocol does not support
 *        seeking based on component streams, the call will fail.
 * @param timestamp timestamp in AVStream.time_base units
 *        or if there is no stream specified then in AV_TIME_BASE units.
 * @param flags Optional combination of AVSEEK_FLAG_BACKWARD, AVSEEK_FLAG_BYTE
 *        and AVSEEK_FLAG_ANY. The protocol may silently ignore
 *        AVSEEK_FLAG_BACKWARD and AVSEEK_FLAG_ANY, but AVSEEK_FLAG_BYTE will
 *        fail if used and not supported.
 * @return >= 0 on success
 * @see AVInputFormat::read_seek
 *)
function avio_seek_time(h: PAVIOContext; stream_index: Integer;
                          timestamp: Int64; flags: Integer): Int64; cdecl; external AVFORMAT_LIBNAME name _PU + 'avio_seek_time';

(* Avoid a warning. The header can not be included because it breaks c++. *)
//struct AVBPrint;

(**
 * Read contents of h into print buffer, up to max_size bytes, or up to EOF.
 *
 * @return 0 for success (max_size bytes read or EOF reached), negative error
 * code otherwise
 *)
function avio_read_to_bprint(h: PAVIOContext; pb: PAVBPrint; max_size: Cardinal): Integer; cdecl; external AVFORMAT_LIBNAME name _PU + 'avio_read_to_bprint';

function avio_tell(s: PAVIOContext): Int64; {$IFDEF USE_INLINE}inline;{$ENDIF}

implementation


(**
 * ftell() equivalent for AVIOContext.
 * @return position or AVERROR.
 *)
function avio_tell(s: PAVIOContext): Int64;
begin
  Result := avio_seek(s, 0, {SEEK_CUR}1);
end;

end.
