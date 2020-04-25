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
 * @ingroup libavf
 * Main libavformat public API header
 *)

(*
 * FFVCL - Delphi FFmpeg VCL Components
 * http://www.DelphiFFmpeg.com
 *
 * Original file: libavformat/avformat.h
 * Ported by CodeCoolie@CNSW 2008/03/19 -> $Date:: 2015-03-24 #$
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

unit libavformat;

interface

{$I CompilerDefines.inc}

uses
{$IFDEF BCB}
  FFTypes,
{$ENDIF}
  libavcodec,
  libavformat_avio,
  libavutil,
  libavutil_dict,
  libavutil_frame,
  libavutil_log,
  libavutil_rational;

{$I libversion.inc}

(**
 * @defgroup libavf I/O and Muxing/Demuxing Library
 * @{
 *
 * Libavformat (lavf) is a library for dealing with various media container
 * formats. Its main two purposes are demuxing - i.e. splitting a media file
 * into component streams, and the reverse process of muxing - writing supplied
 * data in a specified container format. It also has an @ref lavf_io
 * "I/O module" which supports a number of protocols for accessing the data (e.g.
 * file, tcp, http and others). Before using lavf, you need to call
 * av_register_all() to register all compiled muxers, demuxers and protocols.
 * Unless you are absolutely sure you won't use libavformat's network
 * capabilities, you should also call avformat_network_init().
 *
 * A supported input format is described by an AVInputFormat struct, conversely
 * an output format is described by AVOutputFormat. You can iterate over all
 * registered input/output formats using the av_iformat_next() /
 * av_oformat_next() functions. The protocols layer is not part of the public
 * API, so you can only get the names of supported protocols with the
 * avio_enum_protocols() function.
 *
 * Main lavf structure used for both muxing and demuxing is AVFormatContext,
 * which exports all information about the file being read or written. As with
 * most Libavformat structures, its size is not part of public ABI, so it cannot be
 * allocated on stack or directly with av_malloc(). To create an
 * AVFormatContext, use avformat_alloc_context() (some functions, like
 * avformat_open_input() might do that for you).
 *
 * Most importantly an AVFormatContext contains:
 * @li the @ref AVFormatContext.iformat "input" or @ref AVFormatContext.oformat
 * "output" format. It is either autodetected or set by user for input;
 * always set by user for output.
 * @li an @ref AVFormatContext.streams "array" of AVStreams, which describe all
 * elementary streams stored in the file. AVStreams are typically referred to
 * using their index in this array.
 * @li an @ref AVFormatContext.pb "I/O context". It is either opened by lavf or
 * set by user for input, always set by user for output (unless you are dealing
 * with an AVFMT_NOFILE format).
 *
 * @section lavf_options Passing options to (de)muxers
 * Lavf allows to configure muxers and demuxers using the @ref avoptions
 * mechanism. Generic (format-independent) libavformat options are provided by
 * AVFormatContext, they can be examined from a user program by calling
 * av_opt_next() / av_opt_find() on an allocated AVFormatContext (or its AVClass
 * from avformat_get_class()). Private (format-specific) options are provided by
 * AVFormatContext.priv_data if and only if AVInputFormat.priv_class /
 * AVOutputFormat.priv_class of the corresponding format struct is non-NULL.
 * Further options may be provided by the @ref AVFormatContext.pb "I/O context",
 * if its AVClass is non-NULL, and the protocols layer. See the discussion on
 * nesting in @ref avoptions documentation to learn how to access those.
 *
 * @defgroup lavf_decoding Demuxing
 * @{
 * Demuxers read a media file and split it into chunks of data (@em packets). A
 * @ref AVPacket "packet" contains one or more encoded frames which belongs to a
 * single elementary stream. In the lavf API this process is represented by the
 * avformat_open_input() function for opening a file, av_read_frame() for
 * reading a single packet and finally avformat_close_input(), which does the
 * cleanup.
 *
 * @section lavf_decoding_open Opening a media file
 * The minimum information required to open a file is its URL or filename, which
 * is passed to avformat_open_input(), as in the following code:
 * @code
 * const char    *url = "in.mp3";
 * AVFormatContext *s = NULL;
 * int ret = avformat_open_input(&s, url, NULL, NULL);
 * if (ret < 0)
 *     abort();
 * @endcode
 * The above code attempts to allocate an AVFormatContext, open the
 * specified file (autodetecting the format) and read the header, exporting the
 * information stored there into s. Some formats do not have a header or do not
 * store enough information there, so it is recommended that you call the
 * avformat_find_stream_info() function which tries to read and decode a few
 * frames to find missing information.
 *
 * In some cases you might want to preallocate an AVFormatContext yourself with
 * avformat_alloc_context() and do some tweaking on it before passing it to
 * avformat_open_input(). One such case is when you want to use custom functions
 * for reading input data instead of lavf internal I/O layer.
 * To do that, create your own AVIOContext with avio_alloc_context(), passing
 * your reading callbacks to it. Then set the @em pb field of your
 * AVFormatContext to newly created AVIOContext.
 *
 * Since the format of the opened file is in general not known until after
 * avformat_open_input() has returned, it is not possible to set demuxer private
 * options on a preallocated context. Instead, the options should be passed to
 * avformat_open_input() wrapped in an AVDictionary:
 * @code
 * AVDictionary *options = NULL;
 * av_dict_set(&options, "video_size", "640x480", 0);
 * av_dict_set(&options, "pixel_format", "rgb24", 0);
 *
 * if (avformat_open_input(&s, url, NULL, &options) < 0)
 *     abort();
 * av_dict_free(&options);
 * @endcode
 * This code passes the private options 'video_size' and 'pixel_format' to the
 * demuxer. They would be necessary for e.g. the rawvideo demuxer, since it
 * cannot know how to interpret raw video data otherwise. If the format turns
 * out to be something different than raw video, those options will not be
 * recognized by the demuxer and therefore will not be applied. Such unrecognized
 * options are then returned in the options dictionary (recognized options are
 * consumed). The calling program can handle such unrecognized options as it
 * wishes, e.g.
 * @code
 * AVDictionaryEntry *e;
 * if (e = av_dict_get(options, "", NULL, AV_DICT_IGNORE_SUFFIX)) {
 *     fprintf(stderr, "Option %s not recognized by the demuxer.\n", e->key);
 *     abort();
 * }
 * @endcode
 *
 * After you have finished reading the file, you must close it with
 * avformat_close_input(). It will free everything associated with the file.
 *
 * @section lavf_decoding_read Reading from an opened file
 * Reading data from an opened AVFormatContext is done by repeatedly calling
 * av_read_frame() on it. Each call, if successful, will return an AVPacket
 * containing encoded data for one AVStream, identified by
 * AVPacket.stream_index. This packet may be passed straight into the libavcodec
 * decoding functions avcodec_decode_video2(), avcodec_decode_audio4() or
 * avcodec_decode_subtitle2() if the caller wishes to decode the data.
 *
 * AVPacket.pts, AVPacket.dts and AVPacket.duration timing information will be
 * set if known. They may also be unset (i.e. AV_NOPTS_VALUE for
 * pts/dts, 0 for duration) if the stream does not provide them. The timing
 * information will be in AVStream.time_base units, i.e. it has to be
 * multiplied by the timebase to convert them to seconds.
 *
 * If AVPacket.buf is set on the returned packet, then the packet is
 * allocated dynamically and the user may keep it indefinitely.
 * Otherwise, if AVPacket.buf is NULL, the packet data is backed by a
 * static storage somewhere inside the demuxer and the packet is only valid
 * until the next av_read_frame() call or closing the file. If the caller
 * requires a longer lifetime, av_dup_packet() will make an av_malloc()ed copy
 * of it.
 * In both cases, the packet must be freed with av_free_packet() when it is no
 * longer needed.
 *
 * @section lavf_decoding_seek Seeking
 * @}
 *
 * @defgroup lavf_encoding Muxing
 * @{
 * Muxers take encoded data in the form of @ref AVPacket "AVPackets" and write
 * it into files or other output bytestreams in the specified container format.
 *
 * The main API functions for muxing are avformat_write_header() for writing the
 * file header, av_write_frame() / av_interleaved_write_frame() for writing the
 * packets and av_write_trailer() for finalizing the file.
 *
 * At the beginning of the muxing process, the caller must first call
 * avformat_alloc_context() to create a muxing context. The caller then sets up
 * the muxer by filling the various fields in this context:
 *
 * - The @ref AVFormatContext.oformat "oformat" field must be set to select the
 *   muxer that will be used.
 * - Unless the format is of the AVFMT_NOFILE type, the @ref AVFormatContext.pb
 *   "pb" field must be set to an opened IO context, either returned from
 *   avio_open2() or a custom one.
 * - Unless the format is of the AVFMT_NOSTREAMS type, at least one stream must
 *   be created with the avformat_new_stream() function. The caller should fill
 *   the @ref AVStream.codec "stream codec context" information, such as the
 *   codec @ref AVCodecContext.codec_type "type", @ref AVCodecContext.codec_id
 *   "id" and other parameters (e.g. width / height, the pixel or sample format,
 *   etc.) as known. The @ref AVStream.time_base "stream timebase" should
 *   be set to the timebase that the caller desires to use for this stream (note
 *   that the timebase actually used by the muxer can be different, as will be
 *   described later).
 * - It is advised to manually initialize only the relevant fields in
 *   AVCodecContext, rather than using @ref avcodec_copy_context() during
 *   remuxing: there is no guarantee that the codec context values remain valid
 *   for both input and output format contexts.
 * - The caller may fill in additional information, such as @ref
 *   AVFormatContext.metadata "global" or @ref AVStream.metadata "per-stream"
 *   metadata, @ref AVFormatContext.chapters "chapters", @ref
 *   AVFormatContext.programs "programs", etc. as described in the
 *   AVFormatContext documentation. Whether such information will actually be
 *   stored in the output depends on what the container format and the muxer
 *   support.
 *
 * When the muxing context is fully set up, the caller must call
 * avformat_write_header() to initialize the muxer internals and write the file
 * header. Whether anything actually is written to the IO context at this step
 * depends on the muxer, but this function must always be called. Any muxer
 * private options must be passed in the options parameter to this function.
 *
 * The data is then sent to the muxer by repeatedly calling av_write_frame() or
 * av_interleaved_write_frame() (consult those functions' documentation for
 * discussion on the difference between them; only one of them may be used with
 * a single muxing context, they should not be mixed). Do note that the timing
 * information on the packets sent to the muxer must be in the corresponding
 * AVStream's timebase. That timebase is set by the muxer (in the
 * avformat_write_header() step) and may be different from the timebase
 * requested by the caller.
 *
 * Once all the data has been written, the caller must call av_write_trailer()
 * to flush any buffered packets and finalize the output file, then close the IO
 * context (if any) and finally free the muxing context with
 * avformat_free_context().
 * @}
 *
 * @defgroup lavf_io I/O Read/Write
 * @{
 * @}
 *
 * @defgroup lavf_codec Demuxers
 * @{
 * @defgroup lavf_codec_native Native Demuxers
 * @{
 * @}
 * @defgroup lavf_codec_wrappers External library wrappers
 * @{
 * @}
 * @}
 * @defgroup lavf_protos I/O Protocols
 * @{
 * @}
 * @defgroup lavf_internal Internal
 * @{
 * @}
 * @}
 *
 *)

const
  AVSTREAM_EVENT_FLAG_METADATA_UPDATED = $0001; ///< The call resulted in updated metadata.
  MAX_PROBE_PACKETS  = 2500;  // defined in AVStream
  MAX_REORDER_DELAY  = 16;    // defined in AVStream

// const for AVFormatContext.flags;
  AVFMT_FLAG_GENPTS       = $0001; ///< Generate missing pts even if it requires parsing future frames.
  AVFMT_FLAG_IGNIDX       = $0002; ///< Ignore index.
  AVFMT_FLAG_NONBLOCK     = $0004; ///< Do not block when reading packets from input.
  AVFMT_FLAG_IGNDTS       = $0008; ///< Ignore DTS on frames that contain both DTS & PTS
  AVFMT_FLAG_NOFILLIN     = $0010; ///< Do not infer any values from other values, just return what is stored in the container
  AVFMT_FLAG_NOPARSE      = $0020; ///< Do not use AVParsers, you also must set AVFMT_FLAG_NOFILLIN as the fillin code works on frames and no parsing -> no frames. Also seeking to frames can not work if parsing to find frame boundaries has been disabled
  AVFMT_FLAG_NOBUFFER     = $0040; ///< Do not buffer frames when possible
  AVFMT_FLAG_CUSTOM_IO    = $0080; ///< The caller has supplied a custom AVIOContext, don't avio_close() it.
  AVFMT_FLAG_DISCARD_CORRUPT = $0100; ///< Discard frames marked corrupted
  AVFMT_FLAG_FLUSH_PACKETS   = $0200; ///< Flush the AVIOContext every packet.
(**
 * When muxing, try to avoid writing any random/volatile data to the output.
 * This includes any random IDs, real-time timestamps/dates, muxer version, etc.
 *
 * This flag is mainly intended for testing.
 *)
  AVFMT_FLAG_BITEXACT     = $0400;
  AVFMT_FLAG_MP4A_LATM    = $8000; ///< Enable RTP MP4A-LATM payload
  AVFMT_FLAG_SORT_DTS     = $10000; ///< try to interleave outputted packets by dts (using this flag can slow demuxing down)
  AVFMT_FLAG_PRIV_OPT     = $20000; ///< Enable use of private options by delaying codec open (this could be made default once all code is converted)
  AVFMT_FLAG_KEEP_SIDE_DATA = $40000; ///< Dont merge side data but keep it seperate.

  FF_FDEBUG_TS            = $0001;    // defined in AVFormatContext
  AVFMT_EVENT_FLAG_METADATA_UPDATED = $0001; ///< The call resulted in updated metadata.
  AVFMT_AVOID_NEG_TS_AUTO              = -1; ///< Enabled when required by target format
  AVFMT_AVOID_NEG_TS_MAKE_NON_NEGATIVE =  1; ///< Shift timestamps so they are non negative
  AVFMT_AVOID_NEG_TS_MAKE_ZERO         =  2; ///< Shift timestamps so that they start at 0
  RAW_PACKET_BUFFER_SIZE  = 2500000;  // defined in AVFormatContext

  AVINDEX_KEYFRAME     = $0001;

  AV_DISPOSITION_DEFAULT   = $0001;
  AV_DISPOSITION_DUB       = $0002;
  AV_DISPOSITION_ORIGINAL  = $0004;
  AV_DISPOSITION_COMMENT   = $0008;
  AV_DISPOSITION_LYRICS    = $0010;
  AV_DISPOSITION_KARAOKE   = $0020;
(**
 * Track should be used during playback by default.
 * Useful for subtitle track that should be displayed
 * even when user did not explicitly ask for subtitles.
 *)
  AV_DISPOSITION_FORCED    = $0040;
  AV_DISPOSITION_HEARING_IMPAIRED = $0080;  (**< stream for hearing impaired audiences *)
  AV_DISPOSITION_VISUAL_IMPAIRED  = $0100;  (**< stream for visual impaired audiences *)
  AV_DISPOSITION_CLEAN_EFFECTS    = $0200;  (**< stream without voice *)
(**
 * The stream is stored in the file as an attached picture/"cover art" (e.g.
 * APIC frame in ID3v2). The single packet associated with it will be returned
 * among the first few packets read from the file unless seeking takes place.
 * It can also be accessed at any time in AVStream.attached_pic.
 *)
  AV_DISPOSITION_ATTACHED_PIC     = $0400;

(**
 * To specify text track kind (different from subtitles default).
 *)
  AV_DISPOSITION_CAPTIONS     = $10000;
  AV_DISPOSITION_DESCRIPTIONS = $20000;
  AV_DISPOSITION_METADATA     = $40000;

(**
 * Options for behavior on timestamp wrap detection.
 *)
  AV_PTS_WRAP_IGNORE      = 0;   ///< ignore the wrap
  AV_PTS_WRAP_ADD_OFFSET  = 1;   ///< add the format specific offset on wrap detection
  AV_PTS_WRAP_SUB_OFFSET  = -1;  ///< subtract the format specific offset on wrap detection

  MAX_STD_TIMEBASES = (30 * 12 + 7 + 6);

  AV_PROGRAM_RUNNING = 1;

  AVFMTCTX_NOHEADER  = $0001; (**< signal that no header is present
                                   (streams are added dynamically) *)
(**
 * @defgroup metadata_api Public Metadata API
 * @{
 * @ingroup libavf
 * The metadata API allows libavformat to export metadata tags to a client
 * application when demuxing. Conversely it allows a client application to
 * set metadata when muxing.
 *
 * Metadata is exported or set as pairs of key/value strings in the 'metadata'
 * fields of the AVFormatContext, AVStream, AVChapter and AVProgram structs
 * using the @ref lavu_dict "AVDictionary" API. Like all strings in FFmpeg,
 * metadata is assumed to be UTF-8 encoded Unicode. Note that metadata
 * exported by demuxers isn't checked to be valid UTF-8 in most cases.
 *
 * Important concepts to keep in mind:
 * -  Keys are unique; there can never be 2 tags with the same key. This is
 *    also meant semantically, i.e., a demuxer should not knowingly produce
 *    several keys that are literally different but semantically identical.
 *    E.g., key=Author5, key=Author6. In this example, all authors must be
 *    placed in the same tag.
 * -  Metadata is flat, not hierarchical; there are no subtags. If you
 *    want to store, e.g., the email address of the child of producer Alice
 *    and actor Bob, that could have key=alice_and_bobs_childs_email_address.
 * -  Several modifiers can be applied to the tag name. This is done by
 *    appending a dash character ('-') and the modifier name in the order
 *    they appear in the list below -- e.g. foo-eng-sort, not foo-sort-eng.
 *    -  language -- a tag whose value is localized for a particular language
 *       is appended with the ISO 639-2/B 3-letter language code.
 *       For example: Author-ger=Michael, Author-eng=Mike
 *       The original/default language is in the unqualified "Author" tag.
 *       A demuxer should set a default if it sets any translated tag.
 *    -  sorting  -- a modified version of a tag that should be used for
 *       sorting will have '-sort' appended. E.g. artist="The Beatles",
 *       artist-sort="Beatles, The".
 * - Some protocols and demuxers support metadata updates. After a successful
 *   call to av_read_packet(), AVFormatContext.event_flags or AVStream.event_flags
 *   will be updated to indicate if metadata changed. In order to detect metadata
 *   changes on a stream, you need to loop through all streams in the AVFormatContext
 *   and check their individual event_flags.
 *
 * -  Demuxers attempt to export metadata in a generic format, however tags
 *    with no generic equivalents are left as they are stored in the container.
 *    Follows a list of generic tag names:
 *
 @verbatim
 album        -- name of the set this work belongs to
 album_artist -- main creator of the set/album, if different from artist.
                 e.g. "Various Artists" for compilation albums.
 artist       -- main creator of the work
 comment      -- any additional description of the file.
 composer     -- who composed the work, if different from artist.
 copyright    -- name of copyright holder.
 creation_time-- date when the file was created, preferably in ISO 8601.
 date         -- date when the work was created, preferably in ISO 8601.
 disc         -- number of a subset, e.g. disc in a multi-disc collection.
 encoder      -- name/settings of the software/hardware that produced the file.
 encoded_by   -- person/group who created the file.
 filename     -- original name of the file.
 genre        -- <self-evident>.
 language     -- main language in which the work is performed, preferably
                 in ISO 639-2 format. Multiple languages can be specified by
                 separating them with commas.
 performer    -- artist who performed the work, if different from artist.
                 E.g for "Also sprach Zarathustra", artist would be "Richard
                 Strauss" and performer "London Philharmonic Orchestra".
 publisher    -- name of the label/publisher.
 service_name     -- name of the service in broadcasting (channel name).
 service_provider -- name of the service provider in broadcasting.
 title        -- name of the work.
 track        -- number of this work in the set, can be in form current/total.
 variant_bitrate -- the total bitrate of the bitrate variant that the current stream is part of
 @endverbatim
 *
 * Look in the examples section for an application example how to use the Metadata API.
 *
 * @}
 *)

(* packet functions *)

(**
 * Allocate and read the payload of a packet and initialize its
 * fields with default values.
 *
 * @param s    associated IO context
 * @param pkt packet
 * @param size desired payload size
 * @return >0 (read size) if OK, AVERROR_xxx otherwise
 *)
function av_get_packet(s: PAVIOContext; pkt: PAVPacket; size: Integer): Integer; cdecl; external AVFORMAT_LIBNAME name _PU + 'av_get_packet';


(**
 * Read data and append it to the current content of the AVPacket.
 * If pkt->size is 0 this is identical to av_get_packet.
 * Note that this uses av_grow_packet and thus involves a realloc
 * which is inefficient. Thus this function should only be used
 * when there is no reasonable way to know (an upper bound of)
 * the final size.
 *
 * @param s    associated IO context
 * @param pkt packet
 * @param size amount of data to read
 * @return >0 (read size) if OK, AVERROR_xxx otherwise, previous data
 *         will not be lost even if an error occurs.
 *)
function av_append_packet(s: PAVIOContext; pkt: PAVPacket; size: Integer): Integer; cdecl; external AVFORMAT_LIBNAME name _PU + 'av_append_packet';

{$IFDEF FF_API_LAVF_FRAC}
(*************************************************)
(* fractional numbers for exact pts handling *)

(**
 * The exact value of the fractional number is: 'val + num / den'.
 * num is assumed to be 0 <= num < den.
*)
type
  PAVFrac = ^TAVFrac;
  TAVFrac = record
    val, num, den: Int64;
  end;
{$ENDIF}

(*************************************************)
(* input/output formats *)
type
  PPAVCodecTag = ^PAVCodecTag;
  PAVCodecTag = ^TAVCodecTag;
  TAVCodecTag = record
    // need {$ALIGN 8}
    // TODO: check from libavformat/internal.h
    id: TAVCodecID;
    tag: Integer;
  end;

(**
 * This structure contains the data a format has to probe a file.
 *)
  PAVProbeData = ^TAVProbeData;
  TAVProbeData = record
    filename: PAnsiChar;
    buf: PAnsiChar;      (**< Buffer must have AVPROBE_PADDING_SIZE of extra allocated bytes filled with zero. *)
    buf_size: Integer;   (**< Size of buf except extra allocated bytes *)
    mime_type: PAnsiChar;  (**< mime_type, when known. *)
  end;

const
  AVPROBE_SCORE_RETRY     = 25;     // (AVPROBE_SCORE_MAX/4);
  AVPROBE_SCORE_STREAM_RETRY = 24;  // (AVPROBE_SCORE_MAX/4-1);

  AVPROBE_SCORE_EXTENSION = 50;   ///< score for file extension
  AVPROBE_SCORE_MIME      = 75;   ///< score for file mime type
  AVPROBE_SCORE_MAX       = 100;  ///< maximum score

  AVPROBE_PADDING_SIZE = 32;      ///< extra allocated bytes at the end of the probe buffer

/// Demuxer will use avio_open, no opened file should be provided by the caller.
  AVFMT_NOFILE        = $0001;
  AVFMT_NEEDNUMBER    = $0002; (**< Needs '%d' in filename. *)
  AVFMT_SHOW_IDS      = $0008; (**< Show format stream IDs numbers. *)
  AVFMT_RAWPICTURE    = $0020; (**< Format wants AVPicture structure for
                                      raw picture data. *)
  AVFMT_GLOBALHEADER  = $0040; (**< Format wants global header. *)
  AVFMT_NOTIMESTAMPS  = $0080; (**< Format does not need / have any timestamps. *)
  AVFMT_GENERIC_INDEX = $0100; (**< Use generic index building code. *)
  AVFMT_TS_DISCONT    = $0200; (**< Format allows timestamp discontinuities. Note, muxers always require valid (monotone) timestamps *)
  AVFMT_VARIABLE_FPS  = $0400; (**< Format allows variable fps. *)
  AVFMT_NODIMENSIONS  = $0800; (**< Format does not need width/height *)
  AVFMT_NOSTREAMS     = $1000; (**< Format does not require any streams *)
  AVFMT_NOBINSEARCH   = $2000; (**< Format does not allow to fall back on binary search via read_timestamp *)
  AVFMT_NOGENSEARCH   = $4000; (**< Format does not allow to fall back on generic search *)
  AVFMT_NO_BYTE_SEEK  = $8000; (**< Format does not allow seeking by bytes *)
  AVFMT_ALLOW_FLUSH   = $10000; (**< Format allows flushing. If not set, the muxer will not receive a NULL packet in the write_packet function. *)
{$IF LIBAVFORMAT_VERSION_MAJOR <= 54}
  AVFMT_TS_NONSTRICT  = $8020000; //we try to be compatible to the ABIs of ffmpeg and major forks
{$ELSE}
  AVFMT_TS_NONSTRICT  = $20000;
{$IFEND}
                                  (**< Format does not require strictly
                                        increasing timestamps, but they must
                                        still be monotonic *)
  AVFMT_TS_NEGATIVE   = $40000; (**< Format allows muxing negative
                                        timestamps. If not set the timestamp
                                        will be shifted in av_write_frame and
                                        av_interleaved_write_frame so they
                                        start from 0.
                                        The user or muxer can override this through
                                        AVFormatContext.avoid_negative_ts
                                        *)

  AVFMT_SEEK_TO_PTS   = $4000000; (**< Seeking is based on PTS *)

(**
 * @addtogroup lavf_encoding
 * @{
 *)
type
  PAVDeviceInfoList = Pointer;  // defined in libavdevice/avdevice.h
  PAVDeviceCapabilitiesQuery = Pointer; // defined in libavdevice/avdevice.h
  PPAVFormatContext = ^PAVFormatContext;
  PAVFormatContext = ^TAVFormatContext;
  PAVOutputFormat = ^TAVOutputFormat;
  TAVOutputFormat = record
    name: PAnsiChar;
    (**
     * Descriptive name for the format, meant to be more human-readable
     * than name. You should use the NULL_IF_CONFIG_SMALL() macro
     * to define it.
     *)
    long_name: PAnsiChar;
    mime_type: PAnsiChar;
    extensions: PAnsiChar; (**< comma-separated filename extensions *)
    (* output support *)
    audio_codec: TAVCodecID;    (**< default audio codec *)
    video_codec: TAVCodecID;    (**< default video codec *)
    subtitle_codec: TAVCodecID; (**< default subtitle codec *)
    (**
     * can use flags: AVFMT_NOFILE, AVFMT_NEEDNUMBER, AVFMT_RAWPICTURE,
     * AVFMT_GLOBALHEADER, AVFMT_NOTIMESTAMPS, AVFMT_VARIABLE_FPS,
     * AVFMT_NODIMENSIONS, AVFMT_NOSTREAMS, AVFMT_ALLOW_FLUSH,
     * AVFMT_TS_NONSTRICT
     *)
    flags: Integer;

    (**
     * List of supported codec_id-codec_tag pairs, ordered by "better
     * choice first". The arrays are all terminated by AV_CODEC_ID_NONE.
     *)
    //const struct AVCodecTag * const *codec_tag;
    codec_tag: PPAVCodecTag;


    priv_class: PAVClass; ///< AVClass for the private context

    (*****************************************************************
     * No fields below this line are part of the public API. They
     * may not be used outside of libavformat and can be changed and
     * removed at will.
     * New public fields should be added right above.
     *****************************************************************
     *)
    next: PAVOutputFormat;
    (**
     * size of private data so that it can be allocated in the wrapper
     *)
    priv_data_size: Integer;

    write_header: function(s: PAVFormatContext): Integer; cdecl;
    (**
     * Write a packet. If AVFMT_ALLOW_FLUSH is set in flags,
     * pkt can be NULL in order to flush data buffered in the muxer.
     * When flushing, return 0 if there still is more data to flush,
     * or 1 if everything was flushed and there is no more buffered
     * data.
     *)
    write_packet: function(s: PAVFormatContext; pkt: PAVPacket): Integer; cdecl;
    write_trailer: function(s: PAVFormatContext): Integer; cdecl;
    (**
     * Currently only used to set pixel format if not YUV420P.
     *)
    interleave_packet: function(s: PAVFormatContext; pktout: PAVPacket;
                                pktin: PAVPacket; flush: Integer): Integer; cdecl;
    (**
     * Test if the given codec can be stored in this container.
     *
     * @return 1 if the codec is supported, 0 if it is not.
     *         A negative number if unknown.
     *         MKTAG('A', 'P', 'I', 'C') if the codec is only supported as AV_DISPOSITION_ATTACHED_PIC
     *)
    query_codec: function(id: TAVCodecID; std_compliance: Integer): Integer; cdecl;

    get_output_timestamp: procedure(s: PAVFormatContext; stream: Integer;
                                 dts, wall: PInt64); cdecl;
    (**
     * Allows sending messages from application to device.
     *)
    control_message: function(s: PAVFormatContext; ttype: Integer;
                           data: Pointer; data_size: Cardinal): Integer; cdecl;

    (**
     * Write an uncoded AVFrame.
     *
     * See av_write_uncoded_frame() for details.
     *
     * The library will free *frame afterwards, but the muxer can prevent it
     * by setting the pointer to NULL.
     *)
    write_uncoded_frame: function(s: PAVFormatContext; stream_index: Integer;
                               frame: PPAVFrame; flags: Cardinal): Integer; cdecl;
    (**
     * Returns device list with it properties.
     * @see avdevice_list_devices() for more details.
     *)
    get_device_list: function(s: PAVFormatContext; device_list: PAVDeviceInfoList): Integer; cdecl;
    (**
     * Initialize device capabilities submodule.
     * @see avdevice_capabilities_create() for more details.
     *)
    create_device_capabilities: function(s: PAVFormatContext; caps: PAVDeviceCapabilitiesQuery): Integer; cdecl;
    (**
     * Free device capabilities submodule.
     * @see avdevice_capabilities_free() for more details.
     *)
    free_device_capabilities: function(s: PAVFormatContext; caps: PAVDeviceCapabilitiesQuery): Integer; cdecl;
    data_codec: TAVCodecID; (**< default data codec *)
  end;
(**
 * @}
 *)

(**
 * @addtogroup lavf_decoding
 * @{
 *)
  PPAVInputFormat = ^PAVInputFormat;
  PAVInputFormat = ^TAVInputFormat;
  TAVInputFormat = record
    (**
     * A comma separated list of short names for the format. New names
     * may be appended with a minor bump.
     *)
    name: PAnsiChar;

    (**
     * Descriptive name for the format, meant to be more human-readable
     * than name. You should use the NULL_IF_CONFIG_SMALL() macro
     * to define it.
     *)
    long_name: PAnsiChar;

    (**
     * Can use flags: AVFMT_NOFILE, AVFMT_NEEDNUMBER, AVFMT_SHOW_IDS,
     * AVFMT_GENERIC_INDEX, AVFMT_TS_DISCONT, AVFMT_NOBINSEARCH,
     * AVFMT_NOGENSEARCH, AVFMT_NO_BYTE_SEEK, AVFMT_SEEK_TO_PTS.
     *)
    flags: Integer;

    (**
     * If extensions are defined, then no probe is done. You should
     * usually not use extension format guessing because it is not
     * reliable enough
     *)
    extensions: PAnsiChar;

    codec_tag: PPAVCodecTag;

    priv_class: PAVClass; ///< AVClass for the private context

    (**
     * Comma-separated list of mime types.
     * It is used check for matching mime types while probing.
     * @see av_probe_input_format2
     *)
    mime_type: PAnsiChar;

    (*****************************************************************
     * No fields below this line are part of the public API. They
     * may not be used outside of libavformat and can be changed and
     * removed at will.
     * New public fields should be added right above.
     *****************************************************************
     *)
    next: PAVInputFormat;

    (**
     * Raw demuxers store their codec ID here.
     *)
    raw_codec_id: Integer;

    (**
     * Size of private data so that it can be allocated in the wrapper.
     *)
    priv_data_size: Integer;

    (**
     * Tell if a given file has a chance of being parsed as this format.
     * The buffer provided is guaranteed to be AVPROBE_PADDING_SIZE bytes
     * big so you do not have to check for that unless you need more.
     *)
    read_probe: function(p: PAVProbeData): Integer; cdecl;

    (**
     * Read the format header and initialize the AVFormatContext
     * structure. Return 0 if OK. 'avformat_new_stream' should be
     * called to create new streams.
     *)
    read_header: function(s: PAVFormatContext): Integer; cdecl;

    (**
     * Read one packet and put it in 'pkt'. pts and flags are also
     * set. 'avformat_new_stream' can be called only if the flag
     * AVFMTCTX_NOHEADER is used and only in the calling thread (not in a
     * background thread).
     * @return 0 on success, < 0 on error.
     *         When returning an error, pkt must not have been allocated
     *         or must be freed before returning
     *)
    read_packet: function(s: PAVFormatContext; pkt: PAVPacket): Integer; cdecl;

    (**
     * Close the stream. The AVFormatContext and AVStreams are not
     * freed by this function
     *)
    read_close: function(s: PAVFormatContext): Integer; cdecl;

    (**
     * Seek to a given timestamp relative to the frames in
     * stream component stream_index.
     * @param stream_index Must not be -1.
     * @param flags Selects which direction should be preferred if no exact
     *              match is available.
     * @return >= 0 on success (but not necessarily the new offset)
     *)
    read_seek: function(s: PAVFormatContext;
                     stream_index: Integer; timestamp: Int64; flags: Integer): Integer; cdecl;

    (**
     * Get the next timestamp in stream[stream_index].time_base units.
     * @return the timestamp or AV_NOPTS_VALUE if an error occurred
     *)
    read_timestamp: function(s: PAVFormatContext; stream_index: Integer;
                              pos: PInt64; pos_limit: Int64): Int64; cdecl;

    (**
     * Start/resume playing - only meaningful if using a network-based format
     * (RTSP).
     *)
    read_play: function(s: PAVFormatContext): Integer; cdecl;

    (**
     * Pause playing - only meaningful if using a network-based format
     * (RTSP).
     *)
    read_pause: function(s: PAVFormatContext): Integer; cdecl;

    (**
     * Seek to timestamp ts.
     * Seeking will be done so that the point from which all active streams
     * can be presented successfully will be closest to ts and within min/max_ts.
     * Active streams are all streams that have AVStream.discard < AVDISCARD_ALL.
     *)
    read_seek2: function(s: PAVFormatContext; stream_index: Integer; min_ts, ts, max_ts: Int64; flags: Integer): Integer; cdecl;

    (**
     * Returns device list with it properties.
     * @see avdevice_list_devices() for more details.
     *)
    get_device_list: function(s: PAVFormatContext; device_list: PAVDeviceInfoList): Integer; cdecl;

    (**
     * Initialize device capabilities submodule.
     * @see avdevice_capabilities_create() for more details.
     *)
    create_device_capabilities: function(s: PAVFormatContext; caps: PAVDeviceCapabilitiesQuery): Integer; cdecl;

    (**
     * Free device capabilities submodule.
     * @see avdevice_capabilities_free() for more details.
     *)
    free_device_capabilities: function(s: PAVFormatContext; caps: PAVDeviceCapabilitiesQuery): Integer; cdecl;
  end;
(**
 * @}
 *)

  TAVStreamParseType = (
    AVSTREAM_PARSE_NONE,
    AVSTREAM_PARSE_FULL,       (**< full parsing and repack *)
    AVSTREAM_PARSE_HEADERS,    (**< Only parse headers, don't repack. *)
    AVSTREAM_PARSE_TIMESTAMPS, (**< full parsing and interpolation of timestamps for frames not starting on a packet boundary *)
    AVSTREAM_PARSE_FULL_ONCE,  (**< full parsing and repack of the first frame only, only implemented for H.264 currently *)
    (**< full parsing and repack with timestamp and position generation by parser for raw
      this assumes that each packet in the file contains no demuxer level headers and
      just codec level data, otherwise position generation would fail *)
    AVSTREAM_PARSE_FULL_RAW=(0 or (Ord('R') shl 8) or (Ord('A') shl 16) or (Ord('W') shl 24))
  );

  PAVIndexEntry = ^TAVIndexEntry;
  TAVIndexEntry = record
    pos: Int64;
    timestamp: Int64;         (**<
                               * Timestamp in AVStream.time_base units, preferably the time from which on correctly decoded frames are available
                               * when seeking to this entry. That means preferable PTS on keyframe based formats.
                               * But demuxers can choose to store a different timestamp, if it is more convenient for the implementation or nothing better
                               * is known
                               *)
//#define AVINDEX_KEYFRAME 0x0001
//    int flags:2;
//    int size:30; //Yeah, trying to keep the size of this small to reduce memory requirements (it is 24 vs. 32 bytes due to possible 8-byte alignment).
    flags_size: Integer;
    min_distance: Integer;         (**< Minimum distance between this and the previous keyframe, used to avoid unneeded searching. *)
  end;

  (**
   * Stream information used internally by av_find_stream_info()
   *)
  Pduration_error = ^Tduration_error;
  Tduration_error = array[0..1] of array[0..MAX_STD_TIMEBASES - 1] of Double;
  PInterStreamInfo = ^TInterStreamInfo;
  TInterStreamInfo = record
    last_dts: Int64;
    duration_gcd: Int64;
    duration_count: Integer;
    rfps_duration_sum: Int64;
    //double (*duration_error)[2][MAX_STD_TIMEBASES];
    duration_error: Pduration_error;
    codec_info_duration: Int64;
    codec_info_duration_fields: Int64;

    (**
     * 0  -> decoder has not been searched for yet.
     * >0 -> decoder found
     * <0 -> decoder with codec_id == -found_decoder has not been found
     *)
    found_decoder: Integer;

    last_duration: Int64;

    (**
     * Those are used for average framerate estimation.
     *)
    fps_first_dts: Int64;
    fps_first_dts_idx: Integer;
    fps_last_dts: Int64;
    fps_last_dts_idx: Integer;

  end;

  PAVPacketList = ^TAVPacketList;
  TAVPacketList = record
    pkt: TAVPacket;
    next: PAVPacketList;
  end;

(**
 * Stream structure.
 * New fields can be added to the end with minor version bumps.
 * Removal, reordering and changes to existing fields require a major
 * version bump.
 * sizeof(AVStream) must not be used outside libav*.
 *)
  PPAVStream = ^PAVStream;
  PAVStream = ^TAVStream;
  TAVStream = record
    index: Integer;    (**< stream index in AVFormatContext *)
    (**
     * Format-specific stream ID.
     * decoding: set by libavformat
     * encoding: set by the user, replaced by libavformat if left unset
     *)
    id: Integer;
    (**
     * Codec context associated with this stream. Allocated and freed by
     * libavformat.
     *
     * - decoding: The demuxer exports codec information stored in the headers
     *             here.
     * - encoding: The user sets codec information, the muxer writes it to the
     *             output. Mandatory fields as specified in AVCodecContext
     *             documentation must be set even if this AVCodecContext is
     *             not actually used for encoding.
     *)
    codec: PAVCodecContext;
    priv_data: Pointer;

{$IFDEF FF_API_LAVF_FRAC}
    (**
     * @deprecated this field is unused
     *)
    pts: TAVFrac;
{$ENDIF}

    (**
     * This is the fundamental unit of time (in seconds) in terms
     * of which frame timestamps are represented.
     *
     * decoding: set by libavformat
     * encoding: May be set by the caller before avformat_write_header() to
     *           provide a hint to the muxer about the desired timebase. In
     *           avformat_write_header(), the muxer will overwrite this field
     *           with the timebase that will actually be used for the timestamps
     *           written into the file (which may or may not be related to the
     *           user-provided one, depending on the format).
     *)
    time_base: TAVRational;

    (**
     * Decoding: pts of the first frame of the stream in presentation order, in stream time base.
     * Only set this if you are absolutely 100% sure that the value you set
     * it to really is the pts of the first frame.
     * This may be undefined (AV_NOPTS_VALUE).
     * @note The ASF header does NOT contain a correct start_time the ASF
     * demuxer must NOT set this.
     *)
    start_time: Int64;

    (**
     * Decoding: duration of the stream, in stream time base.
     * If a source file does not specify a duration, but does specify
     * a bitrate, this value will be estimated from bitrate and file size.
     *)
    duration: Int64;

    nb_frames: Int64;                 ///< number of frames in this stream if known or 0

    disposition: Integer; (**< AV_DISPOSITION_* bit field *)

    discard: TAVDiscard; ///< Selects which packets can be discarded at will and do not need to be demuxed.

    (**
     * sample aspect ratio (0 if unknown)
     * - encoding: Set by user.
     * - decoding: Set by libavformat.
     *)
    sample_aspect_ratio: TAVRational;

    metadata: PAVDictionary;

    (**
     * Average framerate
     *
     * - demuxing: May be set by libavformat when creating the stream or in
     *             avformat_find_stream_info().
     * - muxing: May be set by the caller before avformat_write_header().
     *)
    avg_frame_rate: TAVRational;

    (**
     * For streams with AV_DISPOSITION_ATTACHED_PIC disposition, this packet
     * will contain the attached picture.
     *
     * decoding: set by libavformat, must not be modified by the caller.
     * encoding: unused
     *)
    attached_pic: TAVPacket;

    (**
     * An array of side data that applies to the whole stream (i.e. the
     * container does not allow it to change between packets).
     *
     * There may be no overlap between the side data in this array and side data
     * in the packets. I.e. a given side data is either exported by the muxer
     * (demuxing) / set by the caller (muxing) in this array, then it never
     * appears in the packets, or the side data is exported / sent through
     * the packets (always in the first packet where the value becomes known or
     * changes), then it does not appear in this array.
     *
     * - demuxing: Set by libavformat when the stream is created.
     * - muxing: May be set by the caller before avformat_write_header().
     *
     * Freed by libavformat in avformat_free_context().
     *
     * @see av_format_inject_global_side_data()
     *)
    side_data: PAVPacketSideData;
    (**
     * The number of elements in the AVStream.side_data array.
     *)
    nb_side_data: Integer;

    (**
     * Flags for the user to detect events happening on the stream. Flags must
     * be cleared by the user once the event has been handled.
     * A combination of AVSTREAM_EVENT_FLAG_*.
     *)
    event_flags: Integer;
//#define AVSTREAM_EVENT_FLAG_METADATA_UPDATED 0x0001 ///< The call resulted in updated metadata.

    (*****************************************************************
     * All fields below this line are not part of the public API. They
     * may not be used outside of libavformat and can be changed and
     * removed at will.
     * New public fields should be added right above.
     *****************************************************************
     *)

    (**
     * Stream information used internally by av_find_stream_info()
     *)
(*
#define MAX_STD_TIMEBASES (30*12+7+6)
    struct {
        int64_t last_dts;
        int64_t duration_gcd;
        int duration_count;
        int64_t rfps_duration_sum;
        double (*duration_error)[2][MAX_STD_TIMEBASES];
        int64_t codec_info_duration;
        int64_t codec_info_duration_fields;

        /**
         * 0  -> decoder has not been searched for yet.
         * >0 -> decoder found
         * <0 -> decoder with codec_id == -found_decoder has not been found
         */
        int found_decoder;

        int64_t last_duration;

        /**
         * Those are used for average framerate estimation.
         */
        int64_t fps_first_dts;
        int     fps_first_dts_idx;
        int64_t fps_last_dts;
        int     fps_last_dts_idx;

    } *info;
*)
    info: PInterStreamInfo;

    pts_wrap_bits: Integer; (**< number of bits in pts (used for wrapping control) *)

    // Timestamp generation support:
    (**
     * Timestamp corresponding to the last dts sync point.
     *
     * Initialized when AVCodecParserContext.dts_sync_point >= 0 and
     * a DTS is received from the underlying container. Otherwise set to
     * AV_NOPTS_VALUE by default.
     *)
    first_dts: Int64;
    cur_dts: Int64;
    last_IP_pts: Int64;
    last_IP_duration: Integer;

    (**
     * Number of packets to buffer for codec probing
     *)
//#define MAX_PROBE_PACKETS 2500
    probe_packets: Integer;

    (**
     * Number of frames that have been demuxed during av_find_stream_info()
     *)
    codec_info_nb_frames: Integer;

    (* av_read_frame() support *)
    need_parsing: TAVStreamParseType;
    parser: PAVCodecParserContext;

    (**
     * last packet in packet_buffer for this stream when muxing.
     *)
    last_in_packet_buffer: PAVPacketList;
    probe_data: TAVProbeData;
//#define MAX_REORDER_DELAY 16
    pts_buffer: array[0..MAX_REORDER_DELAY] of Int64;

    index_entries: PAVIndexEntry; (**< Only used if the format does not
                                    support seeking natively. *)
    nb_index_entries: Integer;
    index_entries_allocated_size: Cardinal;

    (**
     * Real base framerate of the stream.
     * This is the lowest framerate with which all timestamps can be
     * represented accurately (it is the least common multiple of all
     * framerates in the stream). Note, this value is just a guess!
     * For example, if the time base is 1/90000 and all frames have either
     * approximately 3600 or 1800 timer ticks, then r_frame_rate will be 50/1.
     *
     * Code outside avformat should access this field using:
     * av_stream_get/set_r_frame_rate(stream)
     *)
    r_frame_rate: TAVRational;

    (**
     * Stream Identifier
     * This is the MPEG-TS stream identifier +1
     * 0 means unknown
     *)
    stream_identifier: Integer;

    interleaver_chunk_size: Int64;
    interleaver_chunk_duration: Int64;

    (**
     * stream probing state
     * -1   -> probing finished
     *  0   -> no probing requested
     * rest -> perform probing with request_probe being the minimum score to accept.
     * NOT PART OF PUBLIC API
     *)
    request_probe: Integer;
    (**
     * Indicates that everything up to the next keyframe
     * should be discarded.
     *)
    skip_to_keyframe: Integer;

    (**
     * Number of samples to skip at the start of the frame decoded from the next packet.
     *)
    skip_samples: Integer;

    (**
     * If not 0, the first audio sample that should be discarded from the stream.
     * This is broken by design (needs global sample count), but can't be
     * avoided for broken by design formats such as mp3 with ad-hoc gapless
     * audio support.
     *)
    first_discard_sample: Int64;

    (**
     * The sample after last sample that is intended to be discarded after
     * first_discard_sample. Works on frame boundaries only. Used to prevent
     * early EOF if the gapless info is broken (considered concatenated mp3s).
     *)
    last_discard_sample: Int64;

    (**
     * Number of internally decoded frames, used internally in libavformat, do not access
     * its lifetime differs from info which is why it is not in that structure.
     *)
    nb_decoded_frames: Integer;

    (**
     * Timestamp offset added to timestamps before muxing
     * NOT PART OF PUBLIC API
     *)
    mux_ts_offset: Int64;

    (**
     * Internal data to check for wrapping of the time stamp
     *)
    pts_wrap_reference: Int64;

    (**
     * Options for behavior, when a wrap is detected.
     *
     * Defined by AV_PTS_WRAP_ values.
     *
     * If correction is enabled, there are two possibilities:
     * If the first time stamp is near the wrap point, the wrap offset
     * will be subtracted, which will create negative time stamps.
     * Otherwise the offset will be added.
     *)
    pts_wrap_behavior: Integer;

    (**
     * Internal data to prevent doing update_initial_durations() twice
     *)
    update_initial_durations_done: Integer;

    (**
     * Internal data to generate dts from pts
     *)
    pts_reorder_error: array[0..MAX_REORDER_DELAY] of Int64;
    pts_reorder_error_count: array[0..MAX_REORDER_DELAY] of Byte;

    (**
     * Internal data to analyze DTS and detect faulty mpeg streams
     *)
    last_dts_for_order_check: Int64;
    dts_ordered: Byte;
    dts_misordered: Byte;

    (**
     * Internal data to inject global side data
     *)
    inject_global_side_data: Integer;

    (**
     * String containing paris of key and values describing recommended encoder configuration.
     * Paris are separated by ','.
     * Keys are separated from values by '='.
     *)
    recommended_encoder_configuration: PAnsiChar;

    (**
     * display aspect ratio (0 if unknown)
     * - encoding: unused
     * - decoding: Set by libavformat to calculate sample_aspect_ratio internally
     *)
    display_aspect_ratio: TAVRational;
  end;

(**
 * New fields can be added to the end with minor version bumps.
 * Removal, reordering and changes to existing fields require a major
 * version bump.
 * sizeof(AVProgram) must not be used outside libav*.
 *)
  PPAVProgram = ^PAVProgram;
  PAVProgram = ^TAVProgram;
  TAVProgram = record
    id: Integer;
    flags: Integer;
    discard: TAVDiscard;  ///< selects which program to discard and which to feed to the caller
    stream_index: PCardinal;
    nb_stream_indexes: Cardinal;
    metadata: PAVDictionary;

    program_num: Integer;
    pmt_pid: Integer;
    pcr_pid: Integer;

    (*****************************************************************
     * All fields below this line are not part of the public API. They
     * may not be used outside of libavformat and can be changed and
     * removed at will.
     * New public fields should be added right above.
     *****************************************************************
     *)
    start_time: Int64;
    end_time: Int64;

    pts_wrap_reference: Int64;    ///< reference dts for wrap detection
    pts_wrap_behavior: Integer;   ///< behavior on wrap detection
  end;

  PPAVChapter = ^PAVChapter;
  PAVChapter = ^TAVChapter;
  TAVChapter = record
    id: Integer;            ///< unique ID to identify the chapter
    time_base: TAVRational; ///< time base in which the start/end timestamps are specified
    start, eend: Int64;     ///< chapter start/end time in time_base units
    metadata: PAVDictionary;
  end;


(**
 * Callback used by devices to communicate with application.
 *)
  Tav_format_control_messageCall = function(s: PAVFormatContext; ttype: Integer;
                                         data: Pointer; data_size: Cardinal): Integer; cdecl;


(**
 * The duration of a video can be estimated through various ways, and this enum can be used
 * to know how the duration was estimated.
 *)
  TAVDurationEstimationMethod = (
    AVFMT_DURATION_FROM_PTS,    ///< Duration accurately estimated from PTSes
    AVFMT_DURATION_FROM_STREAM, ///< Duration estimated from a stream with a known duration
    AVFMT_DURATION_FROM_BITRATE ///< Duration estimated from bitrate (less accurate)
  );

  PAVFormatInternal = ^TAVFormatInternal;
  TAVFormatInternal = record
    // need {$ALIGN 8}
    // defined in libavformat/internal.h
  end;

(**
 * Format I/O context.
 * New fields can be added to the end with minor version bumps.
 * Removal, reordering and changes to existing fields require a major
 * version bump.
 * sizeof(AVFormatContext) must not be used outside libav*, use
 * avformat_alloc_context() to create an AVFormatContext.
 *)
  TAVFormatContext = record
    (**
     * A class for logging and @ref avoptions. Set by avformat_alloc_context().
     * Exports (de)muxer private options if they exist.
     *)
    av_class: PAVClass;

    (**
     * The input container format.
     *
     * Demuxing only, set by avformat_open_input().
     *)
    iformat: PAVInputFormat;

    (**
     * The output container format.
     *
     * Muxing only, must be set by the caller before avformat_write_header().
     *)
    oformat: PAVOutputFormat;

    (**
     * Format private data. This is an AVOptions-enabled struct
     * if and only if iformat/oformat.priv_class is not NULL.
     *
     * - muxing: set by avformat_write_header()
     * - demuxing: set by avformat_open_input()
     *)
    priv_data: Pointer;

    (**
     * I/O context.
     *
     * - demuxing: either set by the user before avformat_open_input() (then
     *             the user must close it manually) or set by avformat_open_input().
     * - muxing: set by the user before avformat_write_header(). The caller must
     *           take care of closing / freeing the IO context.
     *
     * Do NOT set this field if AVFMT_NOFILE flag is set in
     * iformat/oformat.flags. In such a case, the (de)muxer will handle
     * I/O in some other way and this field will be NULL.
     *)
    pb: PAVIOContext;

    (* stream info *)
    (**
     * Flags signalling stream properties. A combination of AVFMTCTX_*.
     * Set by libavformat.
     *)
    ctx_flags: Integer;

    (**
     * Number of elements in AVFormatContext.streams.
     *
     * Set by avformat_new_stream(), must not be modified by any other code.
     *)
    nb_streams: Cardinal;
    (**
     * A list of all streams in the file. New streams are created with
     * avformat_new_stream().
     *
     * - demuxing: streams are created by libavformat in avformat_open_input().
     *             If AVFMTCTX_NOHEADER is set in ctx_flags, then new streams may also
     *             appear in av_read_frame().
     * - muxing: streams are created by the user before avformat_write_header().
     *
     * Freed by libavformat in avformat_free_context().
     *)
    streams: PPAVStream;

    (**
     * input or output filename
     *
     * - demuxing: set by avformat_open_input()
     * - muxing: may be set by the caller before avformat_write_header()
     *)
    filename: array[0..1024-1] of AnsiChar;

    (**
     * Position of the first frame of the component, in
     * AV_TIME_BASE fractional seconds. NEVER set this value directly:
     * It is deduced from the AVStream values.
     *
     * Demuxing only, set by libavformat.
     *)
    start_time: Int64;

    (**
     * Duration of the stream, in AV_TIME_BASE fractional
     * seconds. Only set this value if you know none of the individual stream
     * durations and also do not set any of them. This is deduced from the
     * AVStream values if not set.
     *
     * Demuxing only, set by libavformat.
     *)
    duration: Int64;

    (**
     * Total stream bitrate in bit/s, 0 if not
     * available. Never set it directly if the file_size and the
     * duration are known as FFmpeg can compute it automatically.
     *)
    bit_rate: Integer;

    packet_size: Cardinal;
    max_delay: Integer;

    (**
     * Flags modifying the (de)muxer behaviour. A combination of AVFMT_FLAG_*.
     * Set by the user before avformat_open_input() / avformat_write_header().
     *)
    flags: Integer;
{
#define AVFMT_FLAG_GENPTS       0x0001 ///< Generate missing pts even if it requires parsing future frames.
#define AVFMT_FLAG_IGNIDX       0x0002 ///< Ignore index.
#define AVFMT_FLAG_NONBLOCK     0x0004 ///< Do not block when reading packets from input.
#define AVFMT_FLAG_IGNDTS       0x0008 ///< Ignore DTS on frames that contain both DTS & PTS
#define AVFMT_FLAG_NOFILLIN     0x0010 ///< Do not infer any values from other values, just return what is stored in the container
#define AVFMT_FLAG_NOPARSE      0x0020 ///< Do not use AVParsers, you also must set AVFMT_FLAG_NOFILLIN as the fillin code works on frames and no parsing -> no frames. Also seeking to frames can not work if parsing to find frame boundaries has been disabled
#define AVFMT_FLAG_NOBUFFER     0x0040 ///< Do not buffer frames when possible
#define AVFMT_FLAG_CUSTOM_IO    0x0080 ///< The caller has supplied a custom AVIOContext, don't avio_close() it.
#define AVFMT_FLAG_DISCARD_CORRUPT  0x0100 ///< Discard frames marked corrupted
#define AVFMT_FLAG_FLUSH_PACKETS    0x0200 ///< Flush the AVIOContext every packet.
/**
 * When muxing, try to avoid writing any random/volatile data to the output.
 * This includes any random IDs, real-time timestamps/dates, muxer version, etc.
 *
 * This flag is mainly intended for testing.
 */
#define AVFMT_FLAG_BITEXACT         0x0400
#define AVFMT_FLAG_MP4A_LATM    0x8000 ///< Enable RTP MP4A-LATM payload
#define AVFMT_FLAG_SORT_DTS    0x10000 ///< try to interleave outputted packets by dts (using this flag can slow demuxing down)
#define AVFMT_FLAG_PRIV_OPT    0x20000 ///< Enable use of private options by delaying codec open (this could be made default once all code is converted)
#define AVFMT_FLAG_KEEP_SIDE_DATA 0x40000 ///< Don't merge side data but keep it separate.
}

    (**
     * @deprecated deprecated in favor of probesize2
     *)
    probesize: Cardinal;

    (**
     * @deprecated deprecated in favor of max_analyze_duration2
     *)
    max_analyze_duration: Integer;

    key: PByte;
    keylen: Integer;

    nb_programs: Cardinal;
    programs: PPAVProgram;

    (**
     * Forced video codec_id.
     * Demuxing: Set by user.
     *)
    video_codec_id: TAVCodecID;

    (**
     * Forced audio codec_id.
     * Demuxing: Set by user.
     *)
    audio_codec_id: TAVCodecID;

    (**
     * Forced subtitle codec_id.
     * Demuxing: Set by user.
     *)
    subtitle_codec_id: TAVCodecID;

    (**
     * Maximum amount of memory in bytes to use for the index of each stream.
     * If the index exceeds this size, entries will be discarded as
     * needed to maintain a smaller size. This can lead to slower or less
     * accurate seeking (depends on demuxer).
     * Demuxers for which a full in-memory index is mandatory will ignore
     * this.
     * - muxing: unused
     * - demuxing: set by user
     *)
    max_index_size: Cardinal;

    (**
     * Maximum amount of memory in bytes to use for buffering frames
     * obtained from realtime capture devices.
     *)
    max_picture_buffer: Cardinal;

    (**
     * Number of chapters in AVChapter array.
     * When muxing, chapters are normally written in the file header,
     * so nb_chapters should normally be initialized before write_header
     * is called. Some muxers (e.g. mov and mkv) can also write chapters
     * in the trailer.  To write chapters in the trailer, nb_chapters
     * must be zero when write_header is called and non-zero when
     * write_trailer is called.
     * - muxing: set by user
     * - demuxing: set by libavformat
     *)
    nb_chapters: Cardinal;
    chapters: PPAVChapter;

    (**
     * Metadata that applies to the whole file.
     *
     * - demuxing: set by libavformat in avformat_open_input()
     * - muxing: may be set by the caller before avformat_write_header()
     *
     * Freed by libavformat in avformat_free_context().
     *)
    metadata: PAVDictionary;

    (**
     * Start time of the stream in real world time, in microseconds
     * since the Unix epoch (00:00 1st January 1970). That is, pts=0 in the
     * stream was captured at this real world time.
     * - muxing: Set by the caller before avformat_write_header(). If set to
     *           either 0 or AV_NOPTS_VALUE, then the current wall-time will
     *           be used.
     * - demuxing: Set by libavformat. AV_NOPTS_VALUE if unknown. Note that
     *             the value may become known after some number of frames
     *             have been received.
     *)
    start_time_realtime: Int64;


    (**
     * The number of frames used for determining the framerate in
     * avformat_find_stream_info().
     * Demuxing only, set by the caller before avformat_find_stream_info().
     *)
    fps_probe_size: Integer;

    (**
     * Error recognition; higher values will detect more errors but may
     * misdetect some more or less valid parts as errors.
     * Demuxing only, set by the caller before avformat_open_input().
     *)
    error_recognition: Integer;

    (**
     * Custom interrupt callbacks for the I/O layer.
     *
     * demuxing: set by the user before avformat_open_input().
     * muxing: set by the user before avformat_write_header()
     * (mainly useful for AVFMT_NOFILE formats). The callback
     * should also be passed to avio_open2() if it's used to
     * open the file.
     *)
    interrupt_callback: TAVIOInterruptCB;

    (**
     * Flags to enable debugging.
     *)
    debug: Integer;
//#define FF_FDEBUG_TS        0x0001

    (**
     * Maximum buffering duration for interleaving.
     *
     * To ensure all the streams are interleaved correctly,
     * av_interleaved_write_frame() will wait until it has at least one packet
     * for each stream before actually writing any packets to the output file.
     * When some streams are "sparse" (i.e. there are large gaps between
     * successive packets), this can result in excessive buffering.
     *
     * This field specifies the maximum difference between the timestamps of the
     * first and the last packet in the muxing queue, above which libavformat
     * will output a packet regardless of whether it has queued a packet for all
     * the streams.
     *
     * Muxing only, set by the caller before avformat_write_header().
     *)
    max_interleave_delta: Int64;

    (**
     * Allow non-standard and experimental extension
     * @see AVCodecContext.strict_std_compliance
     *)
    strict_std_compliance: Integer;

    (**
     * Flags for the user to detect events happening on the file. Flags must
     * be cleared by the user once the event has been handled.
     * A combination of AVFMT_EVENT_FLAG_*.
     *)
    event_flags: Integer;
//#define AVFMT_EVENT_FLAG_METADATA_UPDATED 0x0001 ///< The call resulted in updated metadata.

    (**
     * Maximum number of packets to read while waiting for the first timestamp.
     * Decoding only.
     *)
    max_ts_probe: Integer;

    (**
     * Avoid negative timestamps during muxing.
     * Any value of the AVFMT_AVOID_NEG_TS_* constants.
     * Note, this only works when using av_interleaved_write_frame. (interleave_packet_per_dts is in use)
     * - muxing: Set by user
     * - demuxing: unused
     *)
    avoid_negative_ts: Integer;
//#define AVFMT_AVOID_NEG_TS_AUTO             -1 ///< Enabled when required by target format
//#define AVFMT_AVOID_NEG_TS_MAKE_NON_NEGATIVE 1 ///< Shift timestamps so they are non negative
//#define AVFMT_AVOID_NEG_TS_MAKE_ZERO         2 ///< Shift timestamps so that they start at 0

    (**
     * Transport stream id.
     * This will be moved into demuxer private options. Thus no API/ABI compatibility
     *)
    ts_id: Integer;

    (**
     * Audio preload in microseconds.
     * Note, not all formats support this and unpredictable things may happen if it is used when not supported.
     * - encoding: Set by user via AVOptions (NO direct access)
     * - decoding: unused
     *)
    audio_preload: Integer;

    (**
     * Max chunk time in microseconds.
     * Note, not all formats support this and unpredictable things may happen if it is used when not supported.
     * - encoding: Set by user via AVOptions (NO direct access)
     * - decoding: unused
     *)
    max_chunk_duration: Integer;

    (**
     * Max chunk size in bytes
     * Note, not all formats support this and unpredictable things may happen if it is used when not supported.
     * - encoding: Set by user via AVOptions (NO direct access)
     * - decoding: unused
     *)
    max_chunk_size: Integer;

    (**
     * forces the use of wallclock timestamps as pts/dts of packets
     * This has undefined results in the presence of B frames.
     * - encoding: unused
     * - decoding: Set by user via AVOptions (NO direct access)
     *)
    use_wallclock_as_timestamps: Integer;

    (**
     * avio flags, used to force AVIO_FLAG_DIRECT.
     * - encoding: unused
     * - decoding: Set by user via AVOptions (NO direct access)
     *)
    avio_flags: Integer;

    (**
     * The duration field can be estimated through various ways, and this field can be used
     * to know how the duration was estimated.
     * - encoding: unused
     * - decoding: Read by user via AVOptions (NO direct access)
     *)
    duration_estimation_method: TAVDurationEstimationMethod;

    (**
     * Skip initial bytes when opening stream
     * - encoding: unused
     * - decoding: Set by user via AVOptions (NO direct access)
     *)
    skip_initial_bytes: Int64;

    (**
     * Correct single timestamp overflows
     * - encoding: unused
     * - decoding: Set by user via AVOptions (NO direct access)
     *)
    correct_ts_overflow: Cardinal;

    (**
     * Force seeking to any (also non key) frames.
     * - encoding: unused
     * - decoding: Set by user via AVOptions (NO direct access)
     *)
    seek2any: Integer;

    (**
     * Flush the I/O context after each packet.
     * - encoding: Set by user via AVOptions (NO direct access)
     * - decoding: unused
     *)
    flush_packets: Integer;

    (**
     * format probing score.
     * The maximal score is AVPROBE_SCORE_MAX, its set when the demuxer probes
     * the format.
     * - encoding: unused
     * - decoding: set by avformat, read by user via av_format_get_probe_score() (NO direct access)
     *)
    probe_score: Integer;

    (**
     * number of bytes to read maximally to identify format.
     * - encoding: unused
     * - decoding: set by user through AVOPtions (NO direct access)
     *)
    format_probesize: Integer;

    (**
     * ',' separated list of allowed decoders.
     * If NULL then all are allowed
     * - encoding: unused
     * - decoding: set by user through AVOptions (NO direct access)
     *)
    codec_whitelist: PAnsiChar;

    (**
     * ',' separated list of allowed demuxers.
     * If NULL then all are allowed
     * - encoding: unused
     * - decoding: set by user through AVOptions (NO direct access)
     *)
    format_whitelist: PAnsiChar;

    (**
     * An opaque field for libavformat internal usage.
     * Must not be accessed in any way by callers.
     *)
    internal: PAVFormatInternal;

    (**
     * IO repositioned flag.
     * This is set by avformat when the underlaying IO context read pointer
     * is repositioned, for example when doing byte based seeking.
     * Demuxers can use the flag to detect such changes.
     *)
    io_repositioned: Integer;

    (**
     * Forced video codec.
     * This allows forcing a specific decoder, even when there are multiple with
     * the same codec_id.
     * Demuxing: Set by user via av_format_set_video_codec (NO direct access).
     *)
    video_codec: PAVCodec;

    (**
     * Forced audio codec.
     * This allows forcing a specific decoder, even when there are multiple with
     * the same codec_id.
     * Demuxing: Set by user via av_format_set_audio_codec (NO direct access).
     *)
    audio_codec: PAVCodec;

    (**
     * Forced subtitle codec.
     * This allows forcing a specific decoder, even when there are multiple with
     * the same codec_id.
     * Demuxing: Set by user via av_format_set_subtitle_codec (NO direct access).
     *)
    subtitle_codec: PAVCodec;

    (**
     * Forced data codec.
     * This allows forcing a specific decoder, even when there are multiple with
     * the same codec_id.
     * Demuxing: Set by user via av_format_set_data_codec (NO direct access).
     *)
    data_codec: PAVCodec;

    (**
     * Number of bytes to be written as padding in a metadata header.
     * Demuxing: Unused.
     * Muxing: Set by user via av_format_set_metadata_header_padding.
     *)
    metadata_header_padding: Integer;

    (**
     * User data.
     * This is a place for some private data of the user.
     * Mostly usable with control_message_cb or any future callbacks in device's context.
     *)
    opaque: Pointer;

    (**
     * Callback used by devices to communicate with application.
     *)
    control_message_cb: Tav_format_control_messageCall;

    (**
     * Output timestamp offset, in microseconds.
     * Muxing: set by user via AVOptions (NO direct access)
     *)
    output_ts_offset: Int64;

    (**
     * Maximum duration (in AV_TIME_BASE units) of the data read
     * from input in avformat_find_stream_info().
     * Demuxing only, set by the caller before avformat_find_stream_info()
     * via AVOptions (NO direct access).
     * Can be set to 0 to let avformat choose using a heuristic.
     *)
    max_analyze_duration2: Int64;

    (**
     * Maximum size of the data read from input for determining
     * the input container format.
     * Demuxing only, set by the caller before avformat_open_input()
     * via AVOptions (NO direct access).
     *)
    probesize2: Int64;

    (**
     * dump format separator.
     * can be ", " or "\n      " or anything else
     * Code outside libavformat should access this field using AVOptions
     * (NO direct access).
     * - muxing: Set by user.
     * - demuxing: Set by user.
     *)
    dump_separator: PByte;

    (**
     * Forced Data codec_id.
     * Demuxing: Set by user.
     *)
    data_codec_id: TAVCodecID;
  end;


//TODO: API return record  function av_stream_get_r_frame_rate(const s: PAVStream): TAVRational; cdecl; external AVFORMAT_LIBNAME name _PU + 'av_stream_get_r_frame_rate';
procedure av_stream_set_r_frame_rate(s: PAVStream; r: TAVRational); cdecl; external AVFORMAT_LIBNAME name _PU + 'av_stream_set_r_frame_rate';
function av_stream_get_parser(const s: PAVStream): PAVCodecParserContext; cdecl; external AVFORMAT_LIBNAME name _PU + 'av_stream_get_parser';
function av_stream_get_recommended_encoder_configuration(const s: PAVStream): PAnsiChar; cdecl; external AVFORMAT_LIBNAME name _PU + 'av_stream_get_recommended_encoder_configuration';
procedure av_stream_set_recommended_encoder_configuration(s: PAVStream; configuration: PAnsiChar); cdecl; external AVFORMAT_LIBNAME name _PU + 'av_stream_set_recommended_encoder_configuration';

(**
 * Returns the pts of the last muxed packet + its duration
 *
 * the retuned value is undefined when used with a demuxer.
 *)
function av_stream_get_end_pts(const st: PAVStream): Int64; cdecl; external AVFORMAT_LIBNAME name _PU + 'av_stream_get_end_pts';

function av_format_get_probe_score(const s: PAVFormatContext): Integer; cdecl; external AVFORMAT_LIBNAME name _PU + 'av_format_get_probe_score';
function av_format_get_video_codec(const s: PAVFormatContext): PAVCodec; cdecl; external AVFORMAT_LIBNAME name _PU + 'av_format_get_video_codec';
procedure av_format_set_video_codec(s: PAVFormatContext; c: PAVCodec); cdecl; external AVFORMAT_LIBNAME name _PU + 'av_format_set_video_codec';
function av_format_get_audio_codec(const s: PAVFormatContext): PAVCodec; cdecl; external AVFORMAT_LIBNAME name _PU + 'av_format_get_audio_codec';
procedure av_format_set_audio_codec(s: PAVFormatContext; c: PAVCodec); cdecl; external AVFORMAT_LIBNAME name _PU + 'av_format_set_audio_codec';
function av_format_get_subtitle_codec(const s: PAVFormatContext): PAVCodec; cdecl; external AVFORMAT_LIBNAME name _PU + 'av_format_get_subtitle_codec';
procedure av_format_set_subtitle_codec(s: PAVFormatContext; c: PAVCodec); cdecl; external AVFORMAT_LIBNAME name _PU + 'av_format_set_subtitle_codec';
function av_format_get_data_codec(const s: PAVFormatContext): PAVCodec; cdecl; external AVFORMAT_LIBNAME name _PU + 'av_format_get_data_codec';
procedure av_format_set_data_codec(s: PAVFormatContext; c: PAVCodec); cdecl; external AVFORMAT_LIBNAME name _PU + 'av_format_set_data_codec';
function av_format_get_metadata_header_padding(const s: PAVFormatContext): Integer; cdecl; external AVFORMAT_LIBNAME name _PU + 'av_format_get_metadata_header_padding';
procedure av_format_set_metadata_header_padding(s: PAVFormatContext; c: Integer); cdecl; external AVFORMAT_LIBNAME name _PU + 'av_format_set_metadata_header_padding';
function av_format_get_opaque(const s: PAVFormatContext): Pointer; cdecl; external AVFORMAT_LIBNAME name _PU + 'av_format_get_opaque';
procedure av_format_set_opaque(s: PAVFormatContext; opaque: Pointer); cdecl; external AVFORMAT_LIBNAME name _PU + 'av_format_set_opaque';
function av_format_get_control_message_cb(const s: PAVFormatContext): Tav_format_control_messageCall; cdecl; external AVFORMAT_LIBNAME name _PU + 'av_format_get_control_message_cb';
procedure av_format_set_control_message_cb(s: PAVFormatContext; callback: Tav_format_control_messageCall); cdecl; external AVFORMAT_LIBNAME name _PU + 'av_format_set_control_message_cb';

(**
 * This function will cause global side data to be injected in the next packet
 * of each stream as well as after any subsequent seek.
 *)
procedure av_format_inject_global_side_data(s: PAVFormatContext); cdecl; external AVFORMAT_LIBNAME name _PU + 'av_format_inject_global_side_data';

(**
 * Returns the method used to set ctx->duration.
 *
 * @return AVFMT_DURATION_FROM_PTS, AVFMT_DURATION_FROM_STREAM, or AVFMT_DURATION_FROM_BITRATE.
 *)
function av_fmt_ctx_get_duration_estimation_method(const ctx: PAVFormatContext): TAVDurationEstimationMethod; cdecl; external AVFORMAT_LIBNAME name _PU + 'av_fmt_ctx_get_duration_estimation_method';


(**
 * @defgroup lavf_core Core functions
 * @ingroup libavf
 *
 * Functions for querying libavformat capabilities, allocating core structures,
 * etc.
 * @{
 *)

(**
 * Return the LIBAVFORMAT_VERSION_INT constant.
 *)
function avformat_version: Cardinal; cdecl; external AVFORMAT_LIBNAME name _PU + 'avformat_version';

(**
 * Return the libavformat build-time configuration.
 *)
function avformat_configuration: PAnsiChar; cdecl; external AVFORMAT_LIBNAME name _PU + 'avformat_configuration';

(**
 * Return the libavformat license.
 *)
function avformat_license: PAnsiChar; cdecl; external AVFORMAT_LIBNAME name _PU + 'avformat_license';

(**
 * Initialize libavformat and register all the muxers, demuxers and
 * protocols. If you do not call this function, then you can select
 * exactly which formats you want to support.
 *
 * @see av_register_input_format()
 * @see av_register_output_format()
 *)
procedure av_register_all; cdecl; external AVFORMAT_LIBNAME name _PU + 'av_register_all';

procedure av_register_input_format(format: PAVInputFormat); cdecl; external AVFORMAT_LIBNAME name _PU + 'av_register_input_format';
procedure av_register_output_format(format: PAVOutputFormat); cdecl; external AVFORMAT_LIBNAME name _PU + 'av_register_output_format';

(**
 * Do global initialization of network components. This is optional,
 * but recommended, since it avoids the overhead of implicitly
 * doing the setup for each session.
 *
 * Calling this function will become mandatory if using network
 * protocols at some major version bump.
 *)
function avformat_network_init: Integer; cdecl; external AVFORMAT_LIBNAME name _PU + 'avformat_network_init';

(**
 * Undo the initialization done by avformat_network_init.
 *)
function avformat_network_deinit: Integer; cdecl; external AVFORMAT_LIBNAME name _PU + 'avformat_network_deinit';

(**
 * If f is NULL, returns the first registered input format,
 * if f is non-NULL, returns the next registered input format after f
 * or NULL if f is the last one.
 *)
function av_iformat_next(const f: PAVInputFormat): PAVInputFormat; cdecl; external AVFORMAT_LIBNAME name _PU + 'av_iformat_next';

(**
 * If f is NULL, returns the first registered output format,
 * if f is non-NULL, returns the next registered output format after f
 * or NULL if f is the last one.
 *)
function av_oformat_next(const f: PAVOutputFormat): PAVOutputFormat; cdecl; external AVFORMAT_LIBNAME name _PU + 'av_oformat_next';

(**
 * Allocate an AVFormatContext.
 * avformat_free_context() can be used to free the context and everything
 * allocated by the framework within it.
 *)
function avformat_alloc_context(): PAVFormatContext; cdecl; external AVFORMAT_LIBNAME name _PU + 'avformat_alloc_context';

(**
 * Free an AVFormatContext and all its streams.
 * @param s context to free
 *)
procedure avformat_free_context(s: PAVFormatContext); cdecl; external AVFORMAT_LIBNAME name _PU + 'avformat_free_context';

(**
 * Get the AVClass for AVFormatContext. It can be used in combination with
 * AV_OPT_SEARCH_FAKE_OBJ for examining options.
 *
 * @see av_opt_find().
 *)
function avformat_get_class: PAVClass; cdecl; external AVFORMAT_LIBNAME name _PU + 'avformat_get_class';

(**
 * Add a new stream to a media file.
 *
 * When demuxing, it is called by the demuxer in read_header(). If the
 * flag AVFMTCTX_NOHEADER is set in s.ctx_flags, then it may also
 * be called in read_packet().
 *
 * When muxing, should be called by the user before avformat_write_header().
 *
 * User is required to call avcodec_close() and avformat_free_context() to
 * clean up the allocation by avformat_new_stream().
 *
 * @param s media file handle
 * @param c If non-NULL, the AVCodecContext corresponding to the new stream
 * will be initialized to use this codec. This is needed for e.g. codec-specific
 * defaults to be set, so codec should be provided if it is known.
 *
 * @return newly created stream or NULL on error.
 *)
function avformat_new_stream(s: PAVFormatContext; const c: PAVCodec): PAVStream; cdecl; external AVFORMAT_LIBNAME name _PU + 'avformat_new_stream';

(**
 * Get side information from stream.
 *
 * @param stream stream
 * @param type desired side information type
 * @param size pointer for side information size to store (optional)
 * @return pointer to data if present or NULL otherwise
 *)
function av_stream_get_side_data(stream: PAVStream;
                                 type_: TAVPacketSideDataType; size: PInteger): PByte; cdecl; external AVFORMAT_LIBNAME name _PU + 'av_stream_get_side_data';

function av_new_program(s: PAVFormatContext; id: Integer): PAVProgram; cdecl; external AVFORMAT_LIBNAME name _PU + 'av_new_program';

(**
 * @}
 *)


(**
 * Allocate an AVFormatContext for an output format.
 * avformat_free_context() can be used to free the context and
 * everything allocated by the framework within it.
 *
 * @param *ctx is set to the created format context, or to NULL in
 * case of failure
 * @param oformat format to use for allocating the context, if NULL
 * format_name and filename are used instead
 * @param format_name the name of output format to use for allocating the
 * context, if NULL filename is used instead
 * @param filename the name of the filename to use for allocating the
 * context, may be NULL
 * @return >= 0 in case of success, a negative AVERROR code in case of
 * failure
 *)
function avformat_alloc_output_context2(ctx: PPAVFormatContext; oformat: PAVOutputFormat;
                                   const format_name, filename: PAnsiChar): Integer; cdecl; external AVFORMAT_LIBNAME name _PU + 'avformat_alloc_output_context2';

(**
 * @addtogroup lavf_decoding
 * @{
 *)

(**
 * Find AVInputFormat based on the short name of the input format.
 *)
function av_find_input_format(const short_name: PAnsiChar): PAVInputFormat; cdecl; external AVFORMAT_LIBNAME name _PU + 'av_find_input_format';

(**
 * Guess the file format.
 *
 * @param pd        data to be probed
 * @param is_opened Whether the file is already opened; determines whether
 *                  demuxers with or without AVFMT_NOFILE are probed.
 *)
function av_probe_input_format(pd: PAVProbeData; is_opened: Integer): PAVInputFormat; cdecl; external AVFORMAT_LIBNAME name _PU + 'av_probe_input_format';

(**
 * Guess the file format.
 *
 * @param pd        data to be probed
 * @param is_opened Whether the file is already opened; determines whether
 *                  demuxers with or without AVFMT_NOFILE are probed.
 * @param score_max A probe score larger that this is required to accept a
 *                  detection, the variable is set to the actual detection
 *                  score afterwards.
 *                  If the score is <= AVPROBE_SCORE_MAX / 4 it is recommended
 *                  to retry with a larger probe buffer.
 *)
function av_probe_input_format2(pd: PAVProbeData; is_opened: Integer; score_max: PInteger): PAVInputFormat; cdecl; external AVFORMAT_LIBNAME name _PU + 'av_probe_input_format2';

(**
 * Guess the file format.
 *
 * @param is_opened Whether the file is already opened; determines whether
 *                  demuxers with or without AVFMT_NOFILE are probed.
 * @param score_ret The score of the best detection.
 *)
function av_probe_input_format3(pd: PAVProbeData; is_opened: Integer; score_ret: PInteger): PAVInputFormat; cdecl; external AVFORMAT_LIBNAME name _PU + 'av_probe_input_format3';

(**
 * Probe a bytestream to determine the input format. Each time a probe returns
 * with a score that is too low, the probe buffer size is increased and another
 * attempt is made. When the maximum probe size is reached, the input format
 * with the highest score is returned.
 *
 * @param pb the bytestream to probe
 * @param fmt the input format is put here
 * @param filename the filename of the stream
 * @param logctx the log context
 * @param offset the offset within the bytestream to probe from
 * @param max_probe_size the maximum probe buffer size (zero for default)
 * @return the score in case of success, a negative value corresponding to an
 *         the maximal score is AVPROBE_SCORE_MAX
 * AVERROR code otherwise
 *)
function av_probe_input_buffer2(pb: PAVIOContext; fmt: PPAVInputFormat;
                           const filename: PAnsiChar; logctx: Pointer;
                           offset, max_probe_size: Cardinal): Integer; cdecl; external AVFORMAT_LIBNAME name _PU + 'av_probe_input_buffer2';

(**
 * Like av_probe_input_buffer2() but returns 0 on success
 *)
function av_probe_input_buffer(pb: PAVIOContext; fmt: PPAVInputFormat;
                          const filename: PAnsiChar; logctx: Pointer;
                          offset, max_probe_size: Cardinal): Integer; cdecl; external AVFORMAT_LIBNAME name _PU + 'av_probe_input_buffer';

(**
 * Open an input stream and read the header. The codecs are not opened.
 * The stream must be closed with avformat_close_input().
 *
 * @param ps Pointer to user-supplied AVFormatContext (allocated by avformat_alloc_context).
 *           May be a pointer to NULL, in which case an AVFormatContext is allocated by this
 *           function and written into ps.
 *           Note that a user-supplied AVFormatContext will be freed on failure.
 * @param filename Name of the stream to open.
 * @param fmt If non-NULL, this parameter forces a specific input format.
 *            Otherwise the format is autodetected.
 * @param options  A dictionary filled with AVFormatContext and demuxer-private options.
 *                 On return this parameter will be destroyed and replaced with a dict containing
 *                 options that were not found. May be NULL.
 *
 * @return 0 on success, a negative AVERROR on failure.
 *
 * @note If you want to use custom IO, preallocate the format context and set its pb field.
 *)
function avformat_open_input(ps: PPAVFormatContext; const filename: PAnsiChar; fmt: PAVInputFormat; options: PPAVDictionary): Integer; cdecl; external AVFORMAT_LIBNAME name _PU + 'avformat_open_input';

function av_demuxer_open(ic: PAVFormatContext): Integer; cdecl; external AVFORMAT_LIBNAME name _PU + 'av_demuxer_open';

(**
 * Read packets of a media file to get stream information. This
 * is useful for file formats with no headers such as MPEG. This
 * function also computes the real framerate in case of MPEG-2 repeat
 * frame mode.
 * The logical file position is not changed by this function;
 * examined packets may be buffered for later processing.
 *
 * @param ic media file handle
 * @param options  If non-NULL, an ic.nb_streams long array of pointers to
 *                 dictionaries, where i-th member contains options for
 *                 codec corresponding to i-th stream.
 *                 On return each dictionary will be filled with options that were not found.
 * @return >=0 if OK, AVERROR_xxx on error
 *
 * @note this function isn't guaranteed to open all the codecs, so
 *       options being non-empty at return is a perfectly normal behavior.
 *
 * @todo Let the user decide somehow what information is needed so that
 *       we do not waste time getting stuff the user does not need.
 *)
function avformat_find_stream_info(ic: PAVFormatContext; options: PPAVDictionary): Integer; cdecl; external AVFORMAT_LIBNAME name _PU + 'avformat_find_stream_info';

(**
 * Find the programs which belong to a given stream.
 *
 * @param ic    media file handle
 * @param last  the last found program, the search will start after this
 *              program, or from the beginning if it is NULL
 * @param s     stream index
 * @return the next program which belongs to s, NULL if no program is found or
 *         the last program is not among the programs of ic.
 *)
function av_find_program_from_stream(ic: PAVFormatContext; last: PAVProgram; s: Integer): PAVProgram; cdecl; external AVFORMAT_LIBNAME name _PU + 'av_find_program_from_stream';

(**
 * Find the "best" stream in the file.
 * The best stream is determined according to various heuristics as the most
 * likely to be what the user expects.
 * If the decoder parameter is non-NULL, av_find_best_stream will find the
 * default decoder for the stream's codec; streams for which no decoder can
 * be found are ignored.
 *
 * @param ic                media file handle
 * @param type              stream type: video, audio, subtitles, etc.
 * @param wanted_stream_nb  user-requested stream number,
 *                          or -1 for automatic selection
 * @param related_stream    try to find a stream related (eg. in the same
 *                          program) to this one, or -1 if none
 * @param decoder_ret       if non-NULL, returns the decoder for the
 *                          selected stream
 * @param flags             flags; none are currently defined
 * @return  the non-negative stream number in case of success,
 *          AVERROR_STREAM_NOT_FOUND if no stream with the requested type
 *          could be found,
 *          AVERROR_DECODER_NOT_FOUND if streams were found but no decoder
 * @note  If av_find_best_stream returns successfully and decoder_ret is not
 *        NULL, then *decoder_ret is guaranteed to be set to a valid AVCodec.
 *)
function av_find_best_stream(ic: PAVFormatContext;
                        type_: TAVMediaType;
                        wanted_stream_nb,
                        related_stream: Integer;
                        decoder_ret: PPAVCodec;
                        flags: Integer): Integer; cdecl; external AVFORMAT_LIBNAME name _PU + 'av_find_best_stream';

(**
 * Return the next frame of a stream.
 * This function returns what is stored in the file, and does not validate
 * that what is there are valid frames for the decoder. It will split what is
 * stored in the file into frames and return one for each call. It will not
 * omit invalid data between valid frames so as to give the decoder the maximum
 * information possible for decoding.
 *
 * If pkt->buf is NULL, then the packet is valid until the next
 * av_read_frame() or until avformat_close_input(). Otherwise the packet
 * is valid indefinitely. In both cases the packet must be freed with
 * av_free_packet when it is no longer needed. For video, the packet contains
 * exactly one frame. For audio, it contains an integer number of frames if each
 * frame has a known fixed size (e.g. PCM or ADPCM data). If the audio frames
 * have a variable size (e.g. MPEG audio), then it contains one frame.
 *
 * pkt->pts, pkt->dts and pkt->duration are always set to correct
 * values in AVStream.time_base units (and guessed if the format cannot
 * provide them). pkt->pts can be AV_NOPTS_VALUE if the video format
 * has B-frames, so it is better to rely on pkt->dts if you do not
 * decompress the payload.
 *
 * @return 0 if OK, < 0 on error or end of file
 *)
function av_read_frame(s: PAVFormatContext; pkt: PAVPacket): Integer; cdecl; external AVFORMAT_LIBNAME name _PU + 'av_read_frame';

(**
 * Seek to the keyframe at timestamp.
 * 'timestamp' in 'stream_index'.
 *
 * @param s media file handle
 * @param stream_index If stream_index is (-1), a default
 * stream is selected, and timestamp is automatically converted
 * from AV_TIME_BASE units to the stream specific time_base.
 * @param timestamp Timestamp in AVStream.time_base units
 *        or, if no stream is specified, in AV_TIME_BASE units.
 * @param flags flags which select direction and seeking mode
 * @return >= 0 on success
 *)
function av_seek_frame(s: PAVFormatContext; stream_index: Integer; timestamp: Int64;
                                flags: Integer): Integer; cdecl; external AVFORMAT_LIBNAME name _PU + 'av_seek_frame';

(**
 * Seek to timestamp ts.
 * Seeking will be done so that the point from which all active streams
 * can be presented successfully will be closest to ts and within min/max_ts.
 * Active streams are all streams that have AVStream.discard < AVDISCARD_ALL.
 *
 * If flags contain AVSEEK_FLAG_BYTE, then all timestamps are in bytes and
 * are the file position (this may not be supported by all demuxers).
 * If flags contain AVSEEK_FLAG_FRAME, then all timestamps are in frames
 * in the stream with stream_index (this may not be supported by all demuxers).
 * Otherwise all timestamps are in units of the stream selected by stream_index
 * or if stream_index is -1, in AV_TIME_BASE units.
 * If flags contain AVSEEK_FLAG_ANY, then non-keyframes are treated as
 * keyframes (this may not be supported by all demuxers).
 * If flags contain AVSEEK_FLAG_BACKWARD, it is ignored.
 *
 * @param s media file handle
 * @param stream_index index of the stream which is used as time base reference
 * @param min_ts smallest acceptable timestamp
 * @param ts target timestamp
 * @param max_ts largest acceptable timestamp
 * @param flags flags
 * @return >=0 on success, error code otherwise
 *
 * @note This is part of the new seek API which is still under construction.
 *       Thus do not use this yet. It may change at any time, do not expect
 *       ABI compatibility yet!
 *)
function avformat_seek_file(s: PAVFormatContext; stream_index: Integer; min_ts, ts, max_ts: Int64; flags: Integer): Integer; cdecl; external AVFORMAT_LIBNAME name _PU + 'avformat_seek_file';

(**
 * Discard all internally buffered data. This can be useful when dealing with
 * discontinuities in the byte stream. Generally works only with formats that
 * can resync. This includes headerless formats like MPEG-TS/TS but should also
 * work with NUT, Ogg and in a limited way AVI for example.
 *
 * The set of streams, the detected duration, stream parameters and codecs do
 * not change when calling this function. If you want a complete reset, it's
 * better to open a new AVFormatContext.
 *
 * This does not flush the AVIOContext (s->pb). If necessary, call
 * avio_flush(s->pb) before calling this function.
 *
 * @param s media file handle
 * @return >=0 on success, error code otherwise
 *)
function avformat_flush(s: PAVFormatContext): Integer; cdecl; external AVFORMAT_LIBNAME name _PU + 'avformat_flush';

(**
 * Start playing a network-based stream (e.g. RTSP stream) at the
 * current position.
 *)
function av_read_play(s: PAVFormatContext): Integer; cdecl; external AVFORMAT_LIBNAME name _PU + 'av_read_play';

(**
 * Pause a network-based stream (e.g. RTSP stream).
 *
 * Use av_read_play() to resume it.
 *)
function av_read_pause(s: PAVFormatContext): Integer; cdecl; external AVFORMAT_LIBNAME name _PU + 'av_read_pause';

(**
 * Close an opened input AVFormatContext. Free it and all its contents
 * and set *s to NULL.
 *)
procedure avformat_close_input(s: PPAVFormatContext); cdecl; external AVFORMAT_LIBNAME name _PU + 'avformat_close_input';
(**
 * @}
 *)

// libavformat/internal.h
(**
 * Set the time base and wrapping info for a given stream. This will be used
 * to interpret the stream's timestamps. If the new time base is invalid
 * (numerator or denominator are non-positive), it leaves the stream
 * unchanged.
 *
 * @param s stream
 * @param pts_wrap_bits number of bits effectively used by the pts
 *        (used for wrap control)
 * @param pts_num time base numerator
 * @param pts_den time base denominator
 *)
procedure avpriv_set_pts_info(s: PAVStream; pts_wrap_bits: Integer;
                         pts_num, pts_den: Cardinal); cdecl; external AVFORMAT_LIBNAME name _PU + 'avpriv_set_pts_info';

const
  AVSEEK_FLAG_BACKWARD = 1; ///< seek backward
  AVSEEK_FLAG_BYTE     = 2; ///< seeking based on position in bytes
  AVSEEK_FLAG_ANY      = 4; ///< seek to any frame, even non key-frames
  AVSEEK_FLAG_FRAME    = 8; ///< seeking based on frame number

(**
 * @addtogroup lavf_encoding
 * @{
 *)
(**
 * Allocate the stream private data and write the stream header to
 * an output media file.
 *
 * @param s Media file handle, must be allocated with avformat_alloc_context().
 *          Its oformat field must be set to the desired output format;
 *          Its pb field must be set to an already opened AVIOContext.
 * @param options  An AVDictionary filled with AVFormatContext and muxer-private options.
 *                 On return this parameter will be destroyed and replaced with a dict containing
 *                 options that were not found. May be NULL.
 *
 * @return 0 on success, negative AVERROR on failure.
 *
 * @see av_opt_find, av_dict_set, avio_open, av_oformat_next.
 *)
function avformat_write_header(s: PAVFormatContext; options: PPAVDictionary): Integer; cdecl; external AVFORMAT_LIBNAME name _PU + 'avformat_write_header';

(**
 * Write a packet to an output media file.
 *
 * This function passes the packet directly to the muxer, without any buffering
 * or reordering. The caller is responsible for correctly interleaving the
 * packets if the format requires it. Callers that want libavformat to handle
 * the interleaving should call av_interleaved_write_frame() instead of this
 * function.
 *
 * @param s media file handle
 * @param pkt The packet containing the data to be written. Note that unlike
 *            av_interleaved_write_frame(), this function does not take
 *            ownership of the packet passed to it (though some muxers may make
 *            an internal reference to the input packet).
 *            <br>
 *            This parameter can be NULL (at any time, not just at the end), in
 *            order to immediately flush data buffered within the muxer, for
 *            muxers that buffer up data internally before writing it to the
 *            output.
 *            <br>
 *            Packet's @ref AVPacket.stream_index "stream_index" field must be
 *            set to the index of the corresponding stream in @ref
 *            AVFormatContext.streams "s->streams". It is very strongly
 *            recommended that timing information (@ref AVPacket.pts "pts", @ref
 *            AVPacket.dts "dts", @ref AVPacket.duration "duration") is set to
 *            correct values.
 * @return < 0 on error, = 0 if OK, 1 if flushed and there is no more data to flush
 *
 * @see av_interleaved_write_frame()
 *)
function av_write_frame(s: PAVFormatContext; pkt: PAVPacket): Integer; cdecl; external AVFORMAT_LIBNAME name _PU + 'av_write_frame';

(**
 * Write a packet to an output media file ensuring correct interleaving.
 *
 * This function will buffer the packets internally as needed to make sure the
 * packets in the output file are properly interleaved in the order of
 * increasing dts. Callers doing their own interleaving should call
 * av_write_frame() instead of this function.
 *
 * @param s media file handle
 * @param pkt The packet containing the data to be written.
 *            <br>
 *            If the packet is reference-counted, this function will take
 *            ownership of this reference and unreference it later when it sees
 *            fit.
 *            The caller must not access the data through this reference after
 *            this function returns. If the packet is not reference-counted,
 *            libavformat will make a copy.
 *            <br>
 *            This parameter can be NULL (at any time, not just at the end), to
 *            flush the interleaving queues.
 *            <br>
 *            Packet's @ref AVPacket.stream_index "stream_index" field must be
 *            set to the index of the corresponding stream in @ref
 *            AVFormatContext.streams "s->streams". It is very strongly
 *            recommended that timing information (@ref AVPacket.pts "pts", @ref
 *            AVPacket.dts "dts", @ref AVPacket.duration "duration") is set to
 *            correct values.
 *
 * @return 0 on success, a negative AVERROR on error. Libavformat will always
 *         take care of freeing the packet, even if this function fails.
 *
 * @see av_write_frame(), AVFormatContext.max_interleave_delta
 *)
function av_interleaved_write_frame(s: PAVFormatContext; pkt: PAVPacket): Integer; cdecl; external AVFORMAT_LIBNAME name _PU + 'av_interleaved_write_frame';

(**
 * Write a uncoded frame to an output media file.
 *
 * The frame must be correctly interleaved according to the container
 * specification; if not, then av_interleaved_write_frame() must be used.
 *
 * See av_interleaved_write_frame() for details.
 *)
function av_write_uncoded_frame(s: PAVFormatContext; stream_index: Integer;
                           frame: PAVFrame): Integer; cdecl; external AVFORMAT_LIBNAME name _PU + 'av_write_uncoded_frame';

(**
 * Write a uncoded frame to an output media file.
 *
 * If the muxer supports it, this function allows to write an AVFrame
 * structure directly, without encoding it into a packet.
 * It is mostly useful for devices and similar special muxers that use raw
 * video or PCM data and will not serialize it into a byte stream.
 *
 * To test whether it is possible to use it with a given muxer and stream,
 * use av_write_uncoded_frame_query().
 *
 * The caller gives up ownership of the frame and must not access it
 * afterwards.
 *
 * @return  >=0 for success, a negative code on error
 *)
function av_interleaved_write_uncoded_frame(s: PAVFormatContext; stream_index: Integer;
                                       frame: PAVFrame): Integer; cdecl; external AVFORMAT_LIBNAME name _PU + 'av_interleaved_write_uncoded_frame';

(**
 * Test whether a muxer supports uncoded frame.
 *
 * @return  >=0 if an uncoded frame can be written to that muxer and stream,
 *          <0 if not
 *)
function av_write_uncoded_frame_query(s: PAVFormatContext; stream_index: Integer): Integer; cdecl; external AVFORMAT_LIBNAME name _PU + 'av_write_uncoded_frame_query';

(**
 * Write the stream trailer to an output media file and free the
 * file private data.
 *
 * May only be called after a successful call to avformat_write_header.
 *
 * @param s media file handle
 * @return 0 if OK, AVERROR_xxx on error
 *)
function av_write_trailer(s: PAVFormatContext): Integer; cdecl; external AVFORMAT_LIBNAME name _PU + 'av_write_trailer';

(**
 * Return the output format in the list of registered output formats
 * which best matches the provided parameters, or return NULL if
 * there is no match.
 *
 * @param short_name if non-NULL checks if short_name matches with the
 * names of the registered formats
 * @param filename if non-NULL checks if filename terminates with the
 * extensions of the registered formats
 * @param mime_type if non-NULL checks if mime_type matches with the
 * MIME type of the registered formats
 *)
function av_guess_format(const short_name: PAnsiChar;
                                  const filename: PAnsiChar;
                                  const mime_type: PAnsiChar): PAVOutputFormat; cdecl; external AVFORMAT_LIBNAME name _PU + 'av_guess_format';

(**
 * Guess the codec ID based upon muxer and filename.
 *)
function av_guess_codec(fmt: PAVOutputFormat; const short_name: PAnsiChar;
                                 const filename: PAnsiChar; const mime_type: PAnsiChar;
                                 ttype: TAVMediaType): TAVCodecID; cdecl; external AVFORMAT_LIBNAME name _PU + 'av_guess_codec';

(**
 * Get timing information for the data currently output.
 * The exact meaning of "currently output" depends on the format.
 * It is mostly relevant for devices that have an internal buffer and/or
 * work in real time.
 * @param s          media file handle
 * @param stream     stream in the media file
 * @param[out] dts   DTS of the last packet output for the stream, in stream
 *                   time_base units
 * @param[out] wall  absolute time when that packet whas output,
 *                   in microsecond
 * @return  0 if OK, AVERROR(ENOSYS) if the format does not support it
 * Note: some formats or devices may not allow to measure dts and wall
 * atomically.
 *)
function av_get_output_timestamp(s: PAVFormatContext; stream: Integer;
                              dts, wall: Int64): Integer; cdecl; external AVFORMAT_LIBNAME name _PU + 'av_get_output_timestamp';


(**
 * @}
 *)


(**
 * @defgroup lavf_misc Utility functions
 * @ingroup libavf
 * @{
 *
 * Miscellaneous utility functions related to both muxing and demuxing
 * (or neither).
 *)

(**
 * Send a nice hexadecimal dump of a buffer to the specified file stream.
 *
 * @param f The file stream pointer where the dump should be sent to.
 * @param buf buffer
 * @param size buffer size
 *
 * @see av_hex_dump_log, av_pkt_dump2, av_pkt_dump_log2
 *)
procedure av_hex_dump(f: Pointer{FILE *}; const buf: PByte; size: Integer); cdecl; external AVFORMAT_LIBNAME name _PU + 'av_hex_dump';

(**
 * Send a nice hexadecimal dump of a buffer to the log.
 *
 * @param avcl A pointer to an arbitrary struct of which the first field is a
 * pointer to an AVClass struct.
 * @param level The importance level of the message, lower values signifying
 * higher importance.
 * @param buf buffer
 * @param size buffer size
 *
 * @see av_hex_dump, av_pkt_dump2, av_pkt_dump_log2
 *)
procedure av_hex_dump_log(avcl: Pointer; level: Integer; const buf: PByte; size: Integer); cdecl; external AVFORMAT_LIBNAME name _PU + 'av_hex_dump_log';

(**
 * Send a nice dump of a packet to the specified file stream.
 *
 * @param f The file stream pointer where the dump should be sent to.
 * @param pkt packet to dump
 * @param dump_payload True if the payload must be displayed, too.
 * @param st AVStream that the packet belongs to
 *)
procedure av_pkt_dump2(f: Pointer{FILE *}; const pkt: PAVPacket; dump_payload: Integer; const st: PAVStream); cdecl; external AVFORMAT_LIBNAME name _PU + 'av_pkt_dump2';


(**
 * Send a nice dump of a packet to the log.
 *
 * @param avcl A pointer to an arbitrary struct of which the first field is a
 * pointer to an AVClass struct.
 * @param level The importance level of the message, lower values signifying
 * higher importance.
 * @param pkt packet to dump
 * @param dump_payload True if the payload must be displayed, too.
 * @param st AVStream that the packet belongs to
 *)
procedure av_pkt_dump_log2(avcl: Pointer; level: Integer; const pkt: PAVPacket; dump_payload: Integer; const st: PAVStream); cdecl; external AVFORMAT_LIBNAME name _PU + 'av_pkt_dump_log2';

(**
 * Get the AVCodecID for the given codec tag tag.
 * If no codec id is found returns AV_CODEC_ID_NONE.
 *
 * @param tags list of supported codec_id-codec_tag pairs, as stored
 * in AVInputFormat.codec_tag and AVOutputFormat.codec_tag
 * @param tag  codec tag to match to a codec ID
 *)
function av_codec_get_id(const tags: PPAVCodecTag; tag: Cardinal): TAVCodecID; cdecl; external AVFORMAT_LIBNAME name _PU + 'av_codec_get_id';

(**
 * Get the codec tag for the given codec id id.
 * If no codec tag is found returns 0.
 *
 * @param tags list of supported codec_id-codec_tag pairs, as stored
 * in AVInputFormat.codec_tag and AVOutputFormat.codec_tag
 * @param id   codec ID to match to a codec tag
 *)
function av_codec_get_tag(const tags: PPAVCodecTag; id: TAVCodecID): Cardinal; cdecl; external AVFORMAT_LIBNAME name _PU + 'av_codec_get_tag';

(**
 * Get the codec tag for the given codec id.
 *
 * @param tags list of supported codec_id - codec_tag pairs, as stored
 * in AVInputFormat.codec_tag and AVOutputFormat.codec_tag
 * @param id codec id that should be searched for in the list
 * @param tag A pointer to the found tag
 * @return 0 if id was not found in tags, > 0 if it was found
 *)
function av_codec_get_tag2(const tags: PPAVCodecTag; id: TAVCodecID;
                            tag: PCardinal): Integer; cdecl; external AVFORMAT_LIBNAME name _PU + 'av_codec_get_tag2';

function av_find_default_stream_index(s: PAVFormatContext): Integer; cdecl; external AVFORMAT_LIBNAME name _PU + 'av_find_default_stream_index';

(**
 * Get the index for a specific timestamp.
 *
 * @param st        stream that the timestamp belongs to
 * @param timestamp timestamp to retrieve the index for
 * @param flags if AVSEEK_FLAG_BACKWARD then the returned index will correspond
 *                 to the timestamp which is <= the requested one, if backward
 *                 is 0, then it will be >=
 *              if AVSEEK_FLAG_ANY seek to any frame, only keyframes otherwise
 * @return < 0 if no such timestamp could be found
 *)
function av_index_search_timestamp(st: PAVStream; timestamp: Int64; flags: Integer): Integer; cdecl; external AVFORMAT_LIBNAME name _PU + 'av_index_search_timestamp';

(**
 * Add an index entry into a sorted list. Update the entry if the list
 * already contains it.
 *
 * @param timestamp timestamp in the time base of the given stream
 *)
function av_add_index_entry(st: PAVStream; pos: Int64; timestamp: Int64;
                                     size, distance, flags: Integer): Integer; cdecl; external AVFORMAT_LIBNAME name _PU + 'av_add_index_entry';


(**
 * Split a URL string into components.
 *
 * The pointers to buffers for storing individual components may be null,
 * in order to ignore that component. Buffers for components not found are
 * set to empty strings. If the port is not found, it is set to a negative
 * value.
 *
 * @param proto the buffer for the protocol
 * @param proto_size the size of the proto buffer
 * @param authorization the buffer for the authorization
 * @param authorization_size the size of the authorization buffer
 * @param hostname the buffer for the host name
 * @param hostname_size the size of the hostname buffer
 * @param port_ptr a pointer to store the port number in
 * @param path the buffer for the path
 * @param path_size the size of the path buffer
 * @param url the URL to split
 *)
procedure av_url_split(proto: PAnsiChar; proto_size: Integer;
                  authorization: PAnsiChar; authorization_size: Integer;
                  hostname: PAnsiChar; hostname_size: Integer;
                  port_ptr: PInteger;
                  path: PAnsiChar; path_size: Integer;
                  const url: PAnsiChar); cdecl; external AVFORMAT_LIBNAME name _PU + 'av_url_split';


(**
 * Print detailed information about the input or output format, such as
 * duration, bitrate, streams, container, programs, metadata, side data,
 * codec and time base.
 *
 * @param ic        the context to analyze
 * @param index     index of the stream to dump information about
 * @param url       the URL to print, such as source or destination file
 * @param is_output Select whether the specified context is an input(0) or output(1)
 *)
procedure av_dump_format(ic: PAVFormatContext;
                    index: Integer;
                    const url: PAnsiChar;
                    is_output: Integer); cdecl; external AVFORMAT_LIBNAME name _PU + 'av_dump_format';

(**
 * Return in 'buf' the path with '%d' replaced by a number.
 *
 * Also handles the '%0nd' format where 'n' is the total number
 * of digits and '%%'.
 *
 * @param buf destination buffer
 * @param buf_size destination buffer size
 * @param path numbered sequence string
 * @param number frame number
 * @return 0 if OK, -1 on format error
 *)
function av_get_frame_filename(buf: PAnsiChar; buf_size: Integer;
                          const path: PAnsiChar; number: Integer): Integer; cdecl; external AVFORMAT_LIBNAME name _PU + 'av_get_frame_filename';

(**
 * Check whether filename actually is a numbered sequence generator.
 *
 * @param filename possible numbered sequence string
 * @return 1 if a valid numbered sequence string, 0 otherwise
 *)
function av_filename_number_test(const filename: PAnsiChar): Integer; cdecl; external AVFORMAT_LIBNAME name _PU + 'av_filename_number_test';

(**
 * Generate an SDP for an RTP session.
 *
 * Note, this overwrites the id values of AVStreams in the muxer contexts
 * for getting unique dynamic payload types.
 *
 * @param ac array of AVFormatContexts describing the RTP streams. If the
 *           array is composed by only one context, such context can contain
 *           multiple AVStreams (one AVStream per RTP stream). Otherwise,
 *           all the contexts in the array (an AVCodecContext per RTP stream)
 *           must contain only one AVStream.
 * @param n_files number of AVCodecContexts contained in ac
 * @param buf buffer where the SDP will be stored (must be allocated by
 *            the caller)
 * @param size the size of the buffer
 * @return 0 if OK, AVERROR_xxx on error
 *)
function av_sdp_create(ac: PPAVFormatContext; n_files: Integer; buf: PAnsiChar; size: Integer): Integer; cdecl; external AVFORMAT_LIBNAME name _PU + 'av_sdp_create';

(**
 * Return a positive value if the given filename has one of the given
 * extensions, 0 otherwise.
 *
 * @param filename   file name to check against the given extensions
 * @param extensions a comma-separated list of filename extensions
 *)
function av_match_ext(const filename, extensions: PAnsiChar): Integer; cdecl; external AVFORMAT_LIBNAME name _PU + 'av_match_ext';

(**
 * Test if the given container can store a codec.
 *
 * @param ofmt           container to check for compatibility
 * @param codec_id       codec to potentially store in container
 * @param std_compliance standards compliance level, one of FF_COMPLIANCE_*
 *
 * @return 1 if codec with ID codec_id can be stored in ofmt, 0 if it cannot.
 *         A negative number if this information is not available.
 *)
function avformat_query_codec(const ofmt: PAVOutputFormat; codec_id: TAVCodecID;
                                      std_compliance: Integer): Integer; cdecl; external AVFORMAT_LIBNAME name _PU + 'avformat_query_codec';

(**
 * @defgroup riff_fourcc RIFF FourCCs
 * @{
 * Get the tables mapping RIFF FourCCs to libavcodec AVCodecIDs. The tables are
 * meant to be passed to av_codec_get_id()/av_codec_get_tag() as in the
 * following code:
 * @code
 * uint32_t tag = MKTAG('H', '2', '6', '4');
 * const struct AVCodecTag *table[] = { avformat_get_riff_video_tags(), 0 };
 * enum AVCodecID id = av_codec_get_id(table, tag);
 * @endcode
 *)
(**
 * @return the table mapping RIFF FourCCs for video to libavcodec AVCodecID.
 *)
function avformat_get_riff_video_tags: PAVCodecTag; cdecl; external AVFORMAT_LIBNAME name _PU + 'avformat_get_riff_video_tags';
(**
 * @return the table mapping RIFF FourCCs for audio to AVCodecID.
 *)
function avformat_get_riff_audio_tags: PAVCodecTag; cdecl; external AVFORMAT_LIBNAME name _PU + 'avformat_get_riff_audio_tags';
(**
 * @return the table mapping MOV FourCCs for video to libavcodec AVCodecID.
 *)
function avformat_get_mov_video_tags: PAVCodecTag; cdecl; external AVFORMAT_LIBNAME name _PU + 'avformat_get_mov_video_tags';
(**
 * @return the table mapping MOV FourCCs for audio to AVCodecID.
 *)
function avformat_get_mov_audio_tags: PAVCodecTag; cdecl; external AVFORMAT_LIBNAME name _PU + 'avformat_get_mov_audio_tags';

(**
 * @}
 *)

(**
 * Guess the sample aspect ratio of a frame, based on both the stream and the
 * frame aspect ratio.
 *
 * Since the frame aspect ratio is set by the codec but the stream aspect ratio
 * is set by the demuxer, these two may not be equal. This function tries to
 * return the value that you should use if you would like to display the frame.
 *
 * Basic logic is to use the stream aspect ratio if it is set to something sane
 * otherwise use the frame aspect ratio. This way a container setting, which is
 * usually easy to modify can override the coded value in the frames.
 *
 * @param format the format context which the stream is part of
 * @param stream the stream which the frame is part of
 * @param frame the frame with the aspect ratio to be determined
 * @return the guessed (valid) sample_aspect_ratio, 0/1 if no idea
 *)
function av_guess_sample_aspect_ratio(format: PAVFormatContext; stream: PAVStream; frame: PAVFrame): TAVRational;

(**
 * Guess the frame rate, based on both the container and codec information.
 *
 * @param ctx the format context which the stream is part of
 * @param stream the stream which the frame is part of
 * @param frame the frame for which the frame rate should be determined, may be NULL
 * @return the guessed (valid) frame rate, 0/1 if no idea
 *)
function av_guess_frame_rate(format: PAVFormatContext; st: PAVStream; frame: PAVFrame): TAVRational;

(**
 * Check if the stream st contained in s is matched by the stream specifier
 * spec.
 *
 * See the "stream specifiers" chapter in the documentation for the syntax
 * of spec.
 *
 * @return  >0 if st is matched by spec;
 *          0  if st is not matched by spec;
 *          AVERROR code if spec is invalid
 *
 * @note  A stream specifier can match several streams in the format.
 *)
function avformat_match_stream_specifier(s: PAVFormatContext; st: PAVStream;
                                    const spec: PAnsiChar): Integer; cdecl; external AVFORMAT_LIBNAME name _PU + 'avformat_match_stream_specifier';

function avformat_queue_attached_pictures(s: PAVFormatContext): Integer; cdecl; external AVFORMAT_LIBNAME name _PU + 'avformat_queue_attached_pictures';


(**
 * @}
 *)

implementation



(****** TODO: check from libavformat/utils.c **************)
function av_guess_sample_aspect_ratio(format: PAVFormatContext; stream: PAVStream; frame: PAVFrame): TAVRational;
var
  undef: TAVRational;
  stream_sample_aspect_ratio: TAVRational;
  codec_sample_aspect_ratio: TAVRational;
  frame_sample_aspect_ratio: TAVRational;
begin
  undef.num := 0;
  undef.den := 1;
  if Assigned(stream) then
  begin
    stream_sample_aspect_ratio := stream.sample_aspect_ratio;
    if Assigned(stream.codec) then
      codec_sample_aspect_ratio := stream.codec.sample_aspect_ratio
    else
      codec_sample_aspect_ratio := undef;
  end
  else
  begin
    stream_sample_aspect_ratio := undef;
    codec_sample_aspect_ratio := undef;
  end;
  if Assigned(frame) then
    frame_sample_aspect_ratio := frame.sample_aspect_ratio
  else
    frame_sample_aspect_ratio := codec_sample_aspect_ratio;

  av_reduce(@stream_sample_aspect_ratio.num, @stream_sample_aspect_ratio.den,
             stream_sample_aspect_ratio.num,  stream_sample_aspect_ratio.den, MaxInt);
  if (stream_sample_aspect_ratio.num <= 0) or (stream_sample_aspect_ratio.den <= 0) then
    stream_sample_aspect_ratio := undef;

  av_reduce(@frame_sample_aspect_ratio.num, @frame_sample_aspect_ratio.den,
             frame_sample_aspect_ratio.num,  frame_sample_aspect_ratio.den, MaxInt);
  if (frame_sample_aspect_ratio.num <= 0) or (frame_sample_aspect_ratio.den <= 0) then
    frame_sample_aspect_ratio := undef;

  if stream_sample_aspect_ratio.num <> 0 then
    Result := stream_sample_aspect_ratio
  else
    Result := frame_sample_aspect_ratio;
end;

(****** TODO: check from libavformat/utils.c **************)
function av_guess_frame_rate(format: PAVFormatContext; st: PAVStream; frame: PAVFrame): TAVRational;
var
  fr: TAVRational;
  codec_fr: TAVRational;
  avg_fr: TAVRational;
begin
  fr := st.r_frame_rate;
  codec_fr := av_inv_q(st.codec.time_base);
  avg_fr := st.avg_frame_rate;

  if (avg_fr.num > 0) and (avg_fr.den > 0) and (fr.num > 0) and (fr.den > 0) and
     (av_q2d(avg_fr) < 70) and (av_q2d(fr) > 210) then
    fr := avg_fr;

  if st.codec.ticks_per_frame > 1 then
  begin
    codec_fr.den := codec_fr.den * st.codec.ticks_per_frame;
    if (codec_fr.num > 0) and (codec_fr.den > 0) and (av_q2d(codec_fr) < av_q2d(fr) * 0.7) and
       (Abs(1.0 - av_q2d(av_div_q(avg_fr, fr))) > 0.1) then
      fr := codec_fr;
  end;

  Result := fr;
end;

end.
