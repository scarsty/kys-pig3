unit MyFFmpeg;

interface

uses
  ctypes, SysUtils;

const
{$IFDEF mswindows}
  av__codec = 'avcodec-52';
  LIBAVCODEC_VERSION_MAJOR   = 52;
  LIBAVCODEC_VERSION_MINOR   = 67;
  LIBAVCODEC_VERSION_RELEASE = 2;

  av__format = 'avformat-52';
  LIBAVFORMAT_VERSION_MAJOR   = 52;
  LIBAVFORMAT_VERSION_MINOR   = 62;
  LIBAVFORMAT_VERSION_RELEASE = 0;

  av__util = 'avutil-50';
  LIBAVUTIL_VERSION_MAJOR   = 50;
  LIBAVUTIL_VERSION_MINOR   = 15;
  LIBAVUTIL_VERSION_RELEASE = 2;

  sw__scale = 'swscale-0';
  LIBSWSCALE_VERSION_MAJOR   = 0;
  LIBSWSCALE_VERSION_MINOR   = 10;
  LIBSWSCALE_VERSION_RELEASE = 0;
{$ENDIF}

type
    TAVFormatContext = record
    av_class: PAVClass; (**< Set by avformat_alloc_context. *)
    (* Can only be iformat or oformat, not both at the same time. *)
    iformat: PAVInputFormat;
    oformat: PAVOutputFormat;
    priv_data: pointer;

    {$IF LIBAVFORMAT_VERSION_MAJOR >= 52}
    pb: PByteIOContext;
    {$ELSE}
    pb: TByteIOContext;
    {$IFEND}

    nb_streams: cuint;
    streams: array [0..MAX_STREAMS - 1] of PAVStream;
    filename: array [0..1023] of AnsiChar; (* input or output filename *)
    (* stream info *)
    timestamp: cint64;
    {$IF LIBAVFORMAT_VERSION < 52078003} // < 52.78.3
    title: array [0..511] of AnsiChar;
    author: array [0..511] of AnsiChar;
    copyright: array [0..511] of AnsiChar;
    comment: array [0..511] of AnsiChar;
    album: array [0..511] of AnsiChar;
    year: cint;  (**< ID3 year, 0 if none *)
    track: cint; (**< track number, 0 if none *)
    genre: array [0..31] of AnsiChar; (**< ID3 genre *)
    {$ELSE}
      {$IFDEF FF_API_OLD_METADATA}
    title: array [0..511] of AnsiChar;
    author: array [0..511] of AnsiChar;
    copyright: array [0..511] of AnsiChar;
    comment: array [0..511] of AnsiChar;
    album: array [0..511] of AnsiChar;
    year: cint;  (**< ID3 year, 0 if none *)
    track: cint; (**< track number, 0 if none *)
    genre: array [0..31] of AnsiChar; (**< ID3 genre *)
      {$ENDIF}
    {$IFEND}

    ctx_flags: cint; (**< Format-specific flags, see AVFMTCTX_xx *)
    (* private data for pts handling (do not modify directly). *)
    (**
     * This buffer is only needed when packets were already buffered but
     * not decoded, for example to get the codec parameters in MPEG
     * streams.
     *)
    packet_buffer: PAVPacketList;

    (**
     * Decoding: position of the first frame of the component, in
     * AV_TIME_BASE fractional seconds. NEVER set this value directly:
     * It is deduced from the AVStream values.
     *)
    start_time: cint64;
    (**
     * Decoding: duration of the stream, in AV_TIME_BASE fractional
     * seconds. Only set this value if you know none of the individual stream
     * durations and also dont set any of them. This is deduced from the
     * AVStream values if not set.
     *)
    duration: cint64;
    (**
     * decoding: total file size, 0 if unknown
     *)
    file_size: cint64;
    (**
     * Decoding: total stream bitrate in bit/s, 0 if not
     * available. Never set it directly if the file_size and the
     * duration are known as ffmpeg can compute it automatically.
     *)
    bit_rate: cint;

    (* av_read_frame() support *)
    cur_st: PAVStream;
    {$IF LIBAVFORMAT_VERSION_MAJOR < 53}
    cur_ptr_deprecated: pbyte;
    cur_len_deprecated: cint;
    cur_pkt_deprecated: TAVPacket;
    {$IFEND}

    (* av_seek_frame() support *)
    data_offset: cint64; (**< offset of the first packet *)
    index_built: cint;

    mux_rate: cint;
    {$IF LIBAVFORMAT_VERSION < 52034001} // < 52.34.1
    packet_size: cint;
    {$ELSE}
    packet_size: cuint;
    {$IFEND}
    preload: cint;
    max_delay: cint;

    (**
     * number of times to loop output in formats that support it
     *)
    loop_output: cint;

    flags: cint;
    loop_input: cint;

    {$IF LIBAVFORMAT_VERSION >= 50006000} // 50.6.0
    (**
     * decoding: size of data to probe; encoding: unused.
     *)
    probesize: cuint;
    {$IFEND}

    {$IF LIBAVFORMAT_VERSION >= 51009000} // 51.9.0
    (**
     * Maximum time (in AV_TIME_BASE units) during which the input should
     * be analyzed in av_find_stream_info().
     *)
    max_analyze_duration: cint;

    key: pbyte;
    keylen : cint;
    {$IFEND}

    {$IF LIBAVFORMAT_VERSION >= 51014000} // 51.14.0
    nb_programs: cuint;
    programs: PPAVProgram;
    {$IFEND}

    {$IF LIBAVFORMAT_VERSION >= 52003000} // 52.3.0
    (**
     * Forced video codec_id.
     * Demuxing: Set by user.
     *)
    video_codec_id: TCodecID;

    (**
     * Forced audio codec_id.
     * Demuxing: Set by user.
     *)
    audio_codec_id: TCodecID;

    (**
     * Forced subtitle codec_id.
     * Demuxing: Set by user.
     *)
    subtitle_codec_id: TCodecID;
    {$IFEND}

    {$IF LIBAVFORMAT_VERSION >= 52004000} // 52.4.0
    (**
     * Maximum amount of memory in bytes to use for the index of each stream.
     * If the index exceeds this size, entries will be discarded as
     * needed to maintain a smaller size. This can lead to slower or less
     * accurate seeking (depends on demuxer).
     * Demuxers for which a full in-memory index is mandatory will ignore
     * this.
     * muxing  : unused
     * demuxing: set by user
     *)
    max_index_size: cuint;
    {$IFEND}

    {$IF LIBAVFORMAT_VERSION >= 52009000} // 52.9.0
    (**
     * Maximum amount of memory in bytes to use for buffering frames
     * obtained from realtime capture devices.
     *)
    max_picture_buffer: cuint;
    {$IFEND}

    {$IF LIBAVFORMAT_VERSION >= 52014000} // 52.14.0
    nb_chapters: cuint;
    chapters: PAVChapterArray;
    {$IFEND}

    {$IF LIBAVFORMAT_VERSION >= 52016000} // 52.16.0
    (**
     * Flags to enable debugging.
     *)
    debug: cint;
    {$IFEND}

    {$IF LIBAVFORMAT_VERSION >= 52019000} // 52.19.0
    (**
     * Raw packets from the demuxer, prior to parsing and decoding.
     * This buffer is used for buffering packets until the codec can
     * be identified, as parsing cannot be done without knowing the
     * codec.
     *)
    raw_packet_buffer: PAVPacketList;
    raw_packet_buffer_end: PAVPacketList;

    packet_buffer_end: PAVPacketList;
    {$IFEND}

    {$IF LIBAVFORMAT_VERSION >= 52024001} // 52.24.1
    metadata: PAVMetadata;
    {$IFEND}

    {$IF LIBAVFORMAT_VERSION >= 52035000} // 52.35.0
    (**
     * Remaining size available for raw_packet_buffer, in bytes.
     * NOT PART OF PUBLIC API
     *)
    raw_packet_buffer_remaining_size: cint;
    {$IFEND}

    {$IF LIBAVFORMAT_VERSION >= 52056000} // 52.56.0
    (**
     * Start time of the stream in real world time, in microseconds
     * since the unix epoch (00:00 1st January 1970). That is, pts=0
     * in the stream was captured at this real world time.
     * - encoding: Set by user.
     * - decoding: Unused.
     *)
    start_time_realtime: cint64;
    {$IFEND}

  end;
  PPAVFormatContext = ^PAVFormatContext;
  PAVFormatContext = ^TAVFormatContext;

implementation

end.

