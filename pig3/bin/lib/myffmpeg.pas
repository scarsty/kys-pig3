unit MyFFmpeg;

interface

uses

  ctypes, SysUtils;

const
{$IF Defined(MSWindows)}
  av__codec = 'ffmpeg';
  av__format = 'ffmpeg';
  av__util = 'ffmpeg';
  sw__resample = 'ffmpeg';
{$ELSEIF Defined(Darwin)}
  av__codec = 'libavcodec';
  av__format = 'libavformat';
  av__util = 'libavutil';
  sw__resample = 'libswresample';
{$ELSEIF Defined(android)}
  av__codec = 'ffmpeg';
  av__format = 'ffmpeg';
  av__util = 'ffmpeg';
  sw__resample = 'ffmpeg';
{$IFEND}

AV_NUM_DATA_POINTERS = 8;

type
      TAVMediaType = (
    AVMEDIA_TYPE_UNKNOWN = -1,  ///< Usually treated as AVMEDIA_TYPE_DATA
    AVMEDIA_TYPE_VIDEO,
    AVMEDIA_TYPE_AUDIO,
    AVMEDIA_TYPE_DATA,          ///< Opaque data information usually continuous
    AVMEDIA_TYPE_SUBTITLE,
    AVMEDIA_TYPE_ATTACHMENT,    ///< Opaque data information usually sparse
    AVMEDIA_TYPE_NB
  );

  TAVCodecID = (
    AV_CODEC_ID_NONE,

    //* video codecs */
    AV_CODEC_ID_MPEG1VIDEO,
    AV_CODEC_ID_MPEG2VIDEO, ///< preferred ID for MPEG-1/2 video decoding
{$IFDEF FF_API_XVMC}
    AV_CODEC_ID_MPEG2VIDEO_XVMC,
{$IFEND}
    AV_CODEC_ID_H261,
    AV_CODEC_ID_H263,
    AV_CODEC_ID_RV10,
    AV_CODEC_ID_RV20,
    AV_CODEC_ID_MJPEG,
    AV_CODEC_ID_MJPEGB,
    AV_CODEC_ID_LJPEG,
    AV_CODEC_ID_SP5X,
    AV_CODEC_ID_JPEGLS,
    AV_CODEC_ID_MPEG4,
    AV_CODEC_ID_RAWVIDEO,
    AV_CODEC_ID_MSMPEG4V1,
    AV_CODEC_ID_MSMPEG4V2,
    AV_CODEC_ID_MSMPEG4V3,
    AV_CODEC_ID_WMV1,
    AV_CODEC_ID_WMV2,
    AV_CODEC_ID_H263P,
    AV_CODEC_ID_H263I,
    AV_CODEC_ID_FLV1,
    AV_CODEC_ID_SVQ1,
    AV_CODEC_ID_SVQ3,
    AV_CODEC_ID_DVVIDEO,
    AV_CODEC_ID_HUFFYUV,
    AV_CODEC_ID_CYUV,
    AV_CODEC_ID_H264,
    AV_CODEC_ID_INDEO3,
    AV_CODEC_ID_VP3,
    AV_CODEC_ID_THEORA,
    AV_CODEC_ID_ASV1,
    AV_CODEC_ID_ASV2,
    AV_CODEC_ID_FFV1,
    AV_CODEC_ID_4XM,
    AV_CODEC_ID_VCR1,
    AV_CODEC_ID_CLJR,
    AV_CODEC_ID_MDEC,
    AV_CODEC_ID_ROQ,
    AV_CODEC_ID_INTERPLAY_VIDEO,
    AV_CODEC_ID_XAN_WC3,
    AV_CODEC_ID_XAN_WC4,
    AV_CODEC_ID_RPZA,
    AV_CODEC_ID_CINEPAK,
    AV_CODEC_ID_WS_VQA,
    AV_CODEC_ID_MSRLE,
    AV_CODEC_ID_MSVIDEO1,
    AV_CODEC_ID_IDCIN,
    AV_CODEC_ID_8BPS,
    AV_CODEC_ID_SMC,
    AV_CODEC_ID_FLIC,
    AV_CODEC_ID_TRUEMOTION1,
    AV_CODEC_ID_VMDVIDEO,
    AV_CODEC_ID_MSZH,
    AV_CODEC_ID_ZLIB,
    AV_CODEC_ID_QTRLE,
    AV_CODEC_ID_TSCC,
    AV_CODEC_ID_ULTI,
    AV_CODEC_ID_QDRAW,
    AV_CODEC_ID_VIXL,
    AV_CODEC_ID_QPEG,
    AV_CODEC_ID_PNG,
    AV_CODEC_ID_PPM,
    AV_CODEC_ID_PBM,
    AV_CODEC_ID_PGM,
    AV_CODEC_ID_PGMYUV,
    AV_CODEC_ID_PAM,
    AV_CODEC_ID_FFVHUFF,
    AV_CODEC_ID_RV30,
    AV_CODEC_ID_RV40,
    AV_CODEC_ID_VC1,
    AV_CODEC_ID_WMV3,
    AV_CODEC_ID_LOCO,
    AV_CODEC_ID_WNV1,
    AV_CODEC_ID_AASC,
    AV_CODEC_ID_INDEO2,
    AV_CODEC_ID_FRAPS,
    AV_CODEC_ID_TRUEMOTION2,
    AV_CODEC_ID_BMP,
    AV_CODEC_ID_CSCD,
    AV_CODEC_ID_MMVIDEO,
    AV_CODEC_ID_ZMBV,
    AV_CODEC_ID_AVS,
    AV_CODEC_ID_SMACKVIDEO,
    AV_CODEC_ID_NUV,
    AV_CODEC_ID_KMVC,
    AV_CODEC_ID_FLASHSV,
    AV_CODEC_ID_CAVS,
    AV_CODEC_ID_JPEG2000,
    AV_CODEC_ID_VMNC,
    AV_CODEC_ID_VP5,
    AV_CODEC_ID_VP6,
    AV_CODEC_ID_VP6F,
    AV_CODEC_ID_TARGA,
    AV_CODEC_ID_DSICINVIDEO,
    AV_CODEC_ID_TIERTEXSEQVIDEO,
    AV_CODEC_ID_TIFF,
    AV_CODEC_ID_GIF,
    AV_CODEC_ID_DXA,
    AV_CODEC_ID_DNXHD,
    AV_CODEC_ID_THP,
    AV_CODEC_ID_SGI,
    AV_CODEC_ID_C93,
    AV_CODEC_ID_BETHSOFTVID,
    AV_CODEC_ID_PTX,
    AV_CODEC_ID_TXD,
    AV_CODEC_ID_VP6A,
    AV_CODEC_ID_AMV,
    AV_CODEC_ID_VB,
    AV_CODEC_ID_PCX,
    AV_CODEC_ID_SUNRAST,
    AV_CODEC_ID_INDEO4,
    AV_CODEC_ID_INDEO5,
    AV_CODEC_ID_MIMIC,
    AV_CODEC_ID_RL2,
    AV_CODEC_ID_ESCAPE124,
    AV_CODEC_ID_DIRAC,
    AV_CODEC_ID_BFI,
    AV_CODEC_ID_CMV,
    AV_CODEC_ID_MOTIONPIXELS,
    AV_CODEC_ID_TGV,
    AV_CODEC_ID_TGQ,
    AV_CODEC_ID_TQI,
    AV_CODEC_ID_AURA,
    AV_CODEC_ID_AURA2,
    AV_CODEC_ID_V210X,
    AV_CODEC_ID_TMV,
    AV_CODEC_ID_V210,
    AV_CODEC_ID_DPX,
    AV_CODEC_ID_MAD,
    AV_CODEC_ID_FRWU,
    AV_CODEC_ID_FLASHSV2,
    AV_CODEC_ID_CDGRAPHICS,
    AV_CODEC_ID_R210,
    AV_CODEC_ID_ANM,
    AV_CODEC_ID_BINKVIDEO,
    AV_CODEC_ID_IFF_ILBM,
    AV_CODEC_ID_IFF_BYTERUN1,
    AV_CODEC_ID_KGV1,
    AV_CODEC_ID_YOP,
    AV_CODEC_ID_VP8,
    AV_CODEC_ID_PICTOR,
    AV_CODEC_ID_ANSI,
    AV_CODEC_ID_A64_MULTI,
    AV_CODEC_ID_A64_MULTI5,
    AV_CODEC_ID_R10K,
    AV_CODEC_ID_MXPEG,
    AV_CODEC_ID_LAGARITH,
    AV_CODEC_ID_PRORES,
    AV_CODEC_ID_JV,
    AV_CODEC_ID_DFA,
    AV_CODEC_ID_WMV3IMAGE,
    AV_CODEC_ID_VC1IMAGE,
    AV_CODEC_ID_UTVIDEO,
    AV_CODEC_ID_BMV_VIDEO,
    AV_CODEC_ID_VBLE,
    AV_CODEC_ID_DXTORY,
    AV_CODEC_ID_V410,
    AV_CODEC_ID_XWD,
    AV_CODEC_ID_CDXL,
    AV_CODEC_ID_XBM,
    AV_CODEC_ID_ZEROCODEC,
    AV_CODEC_ID_MSS1,
    AV_CODEC_ID_MSA1,
    AV_CODEC_ID_TSCC2,
    AV_CODEC_ID_MTS2,
    AV_CODEC_ID_CLLC,
    AV_CODEC_ID_MSS2,
    AV_CODEC_ID_VP9,
    AV_CODEC_ID_AIC,
    AV_CODEC_ID_ESCAPE130_DEPRECATED,
    AV_CODEC_ID_G2M_DEPRECATED,
    AV_CODEC_ID_HNM4_VIDEO,
    AV_CODEC_ID_HEVC_DEPRECATED,
    AV_CODEC_ID_FIC,
    AV_CODEC_ID_ALIAS_PIX,
    AV_CODEC_ID_BRENDER_PIX_DEPRECATED,
    AV_CODEC_ID_PAF_VIDEO_DEPRECATED,
    AV_CODEC_ID_EXR_DEPRECATED,
    AV_CODEC_ID_VP7_DEPRECATED,
    AV_CODEC_ID_SANM_DEPRECATED,
    AV_CODEC_ID_SGIRLE_DEPRECATED,
    AV_CODEC_ID_MVC1_DEPRECATED,
    AV_CODEC_ID_MVC2_DEPRECATED,

(** see below. they need to be hard coded.
    AV_CODEC_ID_BRENDER_PIX= MKBETAG('B','P','I','X'),
    AV_CODEC_ID_Y41P       = MKBETAG('Y','4','1','P'),
    AV_CODEC_ID_ESCAPE130  = MKBETAG('E','1','3','0'),
    AV_CODEC_ID_EXR        = MKBETAG('0','E','X','R'),
    AV_CODEC_ID_AVRP       = MKBETAG('A','V','R','P'),

    AV_CODEC_ID_012V       = MKBETAG('0','1','2','V'),
    AV_CODEC_ID_G2M        = MKBETAG( 0 ,'G','2','M'),
    AV_CODEC_ID_AVUI       = MKBETAG('A','V','U','I'),
    AV_CODEC_ID_AYUV       = MKBETAG('A','Y','U','V'),
    AV_CODEC_ID_TARGA_Y216 = MKBETAG('T','2','1','6'),
    AV_CODEC_ID_V308       = MKBETAG('V','3','0','8'),
    AV_CODEC_ID_V408       = MKBETAG('V','4','0','8'),
    AV_CODEC_ID_YUV4       = MKBETAG('Y','U','V','4'),
    AV_CODEC_ID_SANM       = MKBETAG('S','A','N','M'),
    AV_CODEC_ID_PAF_VIDEO  = MKBETAG('P','A','F','V'),
    AV_CODEC_ID_AVRN       = MKBETAG('A','V','R','n'),
    AV_CODEC_ID_CPIA       = MKBETAG('C','P','I','A'),
    AV_CODEC_ID_XFACE      = MKBETAG('X','F','A','C'),
    AV_CODEC_ID_SGIRLE     = MKBETAG('S','G','I','R'),
    AV_CODEC_ID_MVC1       = MKBETAG('M','V','C','1'),
    AV_CODEC_ID_MVC2       = MKBETAG('M','V','C','2'),
    AV_CODEC_ID_SNOW       = MKBETAG('S','N','O','W'),
    AV_CODEC_ID_WEBP       = MKBETAG('W','E','B','P'),
    AV_CODEC_ID_SMVJPEG    = MKBETAG('S','M','V','J'),
    AV_CODEC_ID_HEVC       = MKBETAG('H','2','6','5'),
    AV_CODEC_ID_H265       = AV_CODEC_ID_HEVC,
    AV_CODEC_ID_VP7        = MKBETAG('V','P','7','0'),
    AV_CODEC_ID_APNG       = MKBETAG('A','P','N','G')
  *)
    //* various PCM "codecs" */
    //    AV_CODEC_ID_FIRST_AUDIO = 0x10000,     ///< A dummy id pointing at the start of audio codecs
    AV_CODEC_ID_PCM_S16LE = $10000,
    AV_CODEC_ID_PCM_S16BE,
    AV_CODEC_ID_PCM_U16LE,
    AV_CODEC_ID_PCM_U16BE,
    AV_CODEC_ID_PCM_S8,
    AV_CODEC_ID_PCM_U8,
    AV_CODEC_ID_PCM_MULAW,
    AV_CODEC_ID_PCM_ALAW,
    AV_CODEC_ID_PCM_S32LE,
    AV_CODEC_ID_PCM_S32BE,
    AV_CODEC_ID_PCM_U32LE,
    AV_CODEC_ID_PCM_U32BE,
    AV_CODEC_ID_PCM_S24LE,
    AV_CODEC_ID_PCM_S24BE,
    AV_CODEC_ID_PCM_U24LE,
    AV_CODEC_ID_PCM_U24BE,
    AV_CODEC_ID_PCM_S24DAUD,
    AV_CODEC_ID_PCM_ZORK,
    AV_CODEC_ID_PCM_S16LE_PLANAR,
    AV_CODEC_ID_PCM_DVD,
    AV_CODEC_ID_PCM_F32BE,
    AV_CODEC_ID_PCM_F32LE,
    AV_CODEC_ID_PCM_F64BE,
    AV_CODEC_ID_PCM_F64LE,
    AV_CODEC_ID_PCM_BLURAY,
    AV_CODEC_ID_PCM_LXF,
    AV_CODEC_ID_S302M,
    AV_CODEC_ID_PCM_S8_PLANAR,
(** see below. they need to be hard coded.
    AV_CODEC_ID_PCM_S24LE_PLANAR = MKBETAG(24,'P','S','P'),
    AV_CODEC_ID_PCM_S32LE_PLANAR = MKBETAG(32,'P','S','P'),
    AV_CODEC_ID_PCM_S16BE_PLANAR = MKBETAG('P','S','P',16),
  *)

    //* various ADPCM codecs */
    AV_CODEC_ID_ADPCM_IMA_QT = $11000,
    AV_CODEC_ID_ADPCM_IMA_WAV,
    AV_CODEC_ID_ADPCM_IMA_DK3,
    AV_CODEC_ID_ADPCM_IMA_DK4,
    AV_CODEC_ID_ADPCM_IMA_WS,
    AV_CODEC_ID_ADPCM_IMA_SMJPEG,
    AV_CODEC_ID_ADPCM_MS,
    AV_CODEC_ID_ADPCM_4XM,
    AV_CODEC_ID_ADPCM_XA,
    AV_CODEC_ID_ADPCM_ADX,
    AV_CODEC_ID_ADPCM_EA,
    AV_CODEC_ID_ADPCM_G726,
    AV_CODEC_ID_ADPCM_CT,
    AV_CODEC_ID_ADPCM_SWF,
    AV_CODEC_ID_ADPCM_YAMAHA,
    AV_CODEC_ID_ADPCM_SBPRO_4,
    AV_CODEC_ID_ADPCM_SBPRO_3,
    AV_CODEC_ID_ADPCM_SBPRO_2,
    AV_CODEC_ID_ADPCM_THP,
    AV_CODEC_ID_ADPCM_IMA_AMV,
    AV_CODEC_ID_ADPCM_EA_R1,
    AV_CODEC_ID_ADPCM_EA_R3,
    AV_CODEC_ID_ADPCM_EA_R2,
    AV_CODEC_ID_ADPCM_IMA_EA_SEAD,
    AV_CODEC_ID_ADPCM_IMA_EA_EACS,
    AV_CODEC_ID_ADPCM_EA_XAS,
    AV_CODEC_ID_ADPCM_EA_MAXIS_XA,
    AV_CODEC_ID_ADPCM_IMA_ISS,
    AV_CODEC_ID_ADPCM_G722,
    AV_CODEC_ID_ADPCM_IMA_APC,
    AV_CODEC_ID_ADPCM_VIMA_DEPRECATED,
(** see below. they need to be hard coded.
    AV_CODEC_ID_ADPCM_VIMA = MKBETAG('V','I','M','A'),
    AV_CODEC_ID_VIMA       = MKBETAG('V','I','M','A'),
    AV_CODEC_ID_ADPCM_AFC  = MKBETAG('A','F','C',' '),
    AV_CODEC_ID_ADPCM_IMA_OKI = MKBETAG('O','K','I',' '),
    AV_CODEC_ID_ADPCM_DTK  = MKBETAG('D','T','K',' '),
    AV_CODEC_ID_ADPCM_IMA_RAD = MKBETAG('R','A','D',' '),
    AV_CODEC_ID_ADPCM_G726LE = MKBETAG('6','2','7','G'),
  *)

    //* AMR */
    AV_CODEC_ID_AMR_NB = $12000,
    AV_CODEC_ID_AMR_WB,

    //* RealAudio codecs*/
    AV_CODEC_ID_RA_144 = $13000,
    AV_CODEC_ID_RA_288,

    //* various DPCM codecs */
    AV_CODEC_ID_ROQ_DPCM = $14000,
    AV_CODEC_ID_INTERPLAY_DPCM,
    AV_CODEC_ID_XAN_DPCM,
    AV_CODEC_ID_SOL_DPCM,

    //* audio codecs */
    AV_CODEC_ID_MP2 = $15000,
    AV_CODEC_ID_MP3, ///< preferred ID for decoding MPEG audio layer 1, 2 or 3
    AV_CODEC_ID_AAC,
    AV_CODEC_ID_AC3,
    AV_CODEC_ID_DTS,
    AV_CODEC_ID_VORBIS,
    AV_CODEC_ID_DVAUDIO,
    AV_CODEC_ID_WMAV1,
    AV_CODEC_ID_WMAV2,
    AV_CODEC_ID_MACE3,
    AV_CODEC_ID_MACE6,
    AV_CODEC_ID_VMDAUDIO,
    AV_CODEC_ID_FLAC,
    AV_CODEC_ID_MP3ADU,
    AV_CODEC_ID_MP3ON4,
    AV_CODEC_ID_SHORTEN,
    AV_CODEC_ID_ALAC,
    AV_CODEC_ID_WESTWOOD_SND1,
    AV_CODEC_ID_GSM, ///< as in Berlin toast format
    AV_CODEC_ID_QDM2,
    AV_CODEC_ID_COOK,
    AV_CODEC_ID_TRUESPEECH,
    AV_CODEC_ID_TTA,
    AV_CODEC_ID_SMACKAUDIO,
    AV_CODEC_ID_QCELP,
    AV_CODEC_ID_WAVPACK,
    AV_CODEC_ID_DSICINAUDIO,
    AV_CODEC_ID_IMC,
    AV_CODEC_ID_MUSEPACK7,
    AV_CODEC_ID_MLP,
    AV_CODEC_ID_GSM_MS, { as found in WAV }
    AV_CODEC_ID_ATRAC3,
{$IFDEF FF_API_VOXWARE}
    AV_CODEC_ID_VOXWARE,
{$IFEND}
    AV_CODEC_ID_APE,
    AV_CODEC_ID_NELLYMOSER,
    AV_CODEC_ID_MUSEPACK8,
    AV_CODEC_ID_SPEEX,
    AV_CODEC_ID_WMAVOICE,
    AV_CODEC_ID_WMAPRO,
    AV_CODEC_ID_WMALOSSLESS,
    AV_CODEC_ID_ATRAC3P,
    AV_CODEC_ID_EAC3,
    AV_CODEC_ID_SIPR,
    AV_CODEC_ID_MP1,
    AV_CODEC_ID_TWINVQ,
    AV_CODEC_ID_TRUEHD,
    AV_CODEC_ID_MP4ALS,
    AV_CODEC_ID_ATRAC1,
    AV_CODEC_ID_BINKAUDIO_RDFT,
    AV_CODEC_ID_BINKAUDIO_DCT,
    AV_CODEC_ID_AAC_LATM,
    AV_CODEC_ID_QDMC,
    AV_CODEC_ID_CELT,
    AV_CODEC_ID_G723_1,
    AV_CODEC_ID_G729,
    AV_CODEC_ID_8SVX_EXP,
    AV_CODEC_ID_8SVX_FIB,
    AV_CODEC_ID_BMV_AUDIO,
    AV_CODEC_ID_RALF,
    AV_CODEC_ID_IAC,
    AV_CODEC_ID_ILBC,
    AV_CODEC_ID_OPUS_DEPRECATED,
    AV_CODEC_ID_COMFORT_NOISE,
    AV_CODEC_ID_TAK_DEPRECATED,
    AV_CODEC_ID_PAF_AUDIO_DEPRECATED,
    AV_CODEC_ID_ON2AVC,
(** see below. they need to be hard coded.
    AV_CODEC_ID_FFWAVESYNTH = MKBETAG('F','F','W','S'),
    AV_CODEC_ID_SONIC       = MKBETAG('S','O','N','C'),
    AV_CODEC_ID_SONIC_LS    = MKBETAG('S','O','N','L'),
    AV_CODEC_ID_PAF_AUDIO   = MKBETAG('P','A','F','A'),
    AV_CODEC_ID_OPUS        = MKBETAG('O','P','U','S'),
    AV_CODEC_ID_TAK         = MKBETAG('t','B','a','K'),
    AV_CODEC_ID_EVRC        = MKBETAG('s','e','v','c'),
    AV_CODEC_ID_SMV         = MKBETAG('s','s','m','v'),
    AV_CODEC_ID_DSD_LSBF    = MKBETAG('D','S','D','L'),
    AV_CODEC_ID_DSD_MSBF    = MKBETAG('D','S','D','M'),
    AV_CODEC_ID_DSD_LSBF_PLANAR = MKBETAG('D','S','D','1'),
    AV_CODEC_ID_DSD_MSBF_PLANAR = MKBETAG('D','S','D','8'),
 *)

    //* subtitle codecs */
    //    AV_CODEC_ID_FIRST_SUBTITLE = 0x17000,          ///< A dummy ID pointing at the start of subtitle codecs.
    AV_CODEC_ID_DVD_SUBTITLE = $17000,
    AV_CODEC_ID_DVB_SUBTITLE,
    AV_CODEC_ID_TEXT,  ///< raw UTF-8 text
    AV_CODEC_ID_XSUB,
    AV_CODEC_ID_SSA,
    AV_CODEC_ID_MOV_TEXT,
    AV_CODEC_ID_HDMV_PGS_SUBTITLE,
    AV_CODEC_ID_DVB_TELETEXT,
    AV_CODEC_ID_SRT,
(** see below. they need to be hard coded.
    AV_CODEC_ID_MICRODVD   = MKBETAG('m','D','V','D'),
    AV_CODEC_ID_EIA_608    = MKBETAG('c','6','0','8'),
    AV_CODEC_ID_JACOSUB    = MKBETAG('J','S','U','B'),
    AV_CODEC_ID_SAMI       = MKBETAG('S','A','M','I'),
    AV_CODEC_ID_REALTEXT   = MKBETAG('R','T','X','T'),
    AV_CODEC_ID_STL        = MKBETAG('S','p','T','L'),
    AV_CODEC_ID_SUBVIEWER1 = MKBETAG('S','b','V','1'),
    AV_CODEC_ID_SUBVIEWER  = MKBETAG('S','u','b','V'),
    AV_CODEC_ID_SUBRIP     = MKBETAG('S','R','i','p'),
    AV_CODEC_ID_WEBVTT     = MKBETAG('W','V','T','T'),
    AV_CODEC_ID_MPL2       = MKBETAG('M','P','L','2'),
    AV_CODEC_ID_VPLAYER    = MKBETAG('V','P','l','r'),
    AV_CODEC_ID_PJS        = MKBETAG('P','h','J','S'),
    AV_CODEC_ID_ASS        = MKBETAG('A','S','S',' '),  ///< ASS as defined in Matroska
 *)

    //* other specific kind of codecs (generally used for attachments) */
    //    AV_CODEC_ID_FIRST_UNKNOWN = 0x18000,           ///< A dummy ID pointing at the start of various fake codecs.
    AV_CODEC_ID_TTF = $18000,
(** see below. they need to be hard coded.
    AV_CODEC_ID_BINTEXT    = MKBETAG('B','T','X','T'),
    AV_CODEC_ID_XBIN       = MKBETAG('X','B','I','N'),
    AV_CODEC_ID_IDF        = MKBETAG( 0 ,'I','D','F'),
    AV_CODEC_ID_OTF        = MKBETAG( 0 ,'O','T','F'),
    AV_CODEC_ID_SMPTE_KLV  = MKBETAG('K','L','V','A'),
    AV_CODEC_ID_DVD_NAV    = MKBETAG('D','N','A','V'),
    AV_CODEC_ID_TIMED_ID3   = MKBETAG('T','I','D','3'),
 *)

    AV_CODEC_ID_PROBE = $19000, ///< codec_id is not known (like AV_CODEC_ID_NONE) but lavf should attempt to identify it

    AV_CODEC_ID_MPEG2TS = $20000, (**< _FAKE_ codec to indicate a raw MPEG-2 TS
                               * stream (only used by libavformat) *)
    AV_CODEC_ID_MPEG4SYSTEMS = $20001, (**< _FAKE_ codec to indicate a MPEG-4 Systems
                                 * stream (only used by libavformat) *)
    AV_CODEC_ID_FFMETADATA = $21000,   ///< Dummy codec for streams containing only metadata information.

    (** hardcoded codecs from above. pascal needs them to be ordered **)
    AV_CODEC_ID_G2M = $0047324D, // MKBETAG( 0 ,'G','2','M'),
    AV_CODEC_ID_IDF = $00494446, // MKBETAG( 0 ,'I','D','F'),
    AV_CODEC_ID_OTF = $004F5446, // MKBETAG( 0 ,'O','T','F'),
    AV_CODEC_ID_PCM_S24LE_PLANAR = $18505350, // MKBETAG(24,'P','S','P'),
    AV_CODEC_ID_PCM_S32LE_PLANAR = $20505350, // MKBETAG(32,'P','S','P'),
    AV_CODEC_ID_012V = $30313256, // MKBETAG('0','1','2','V'),
    AV_CODEC_ID_EXR = $30455852, // MKBETAG('0','E','X','R'),
    AV_CODEC_ID_ADPCM_G726LE = $36323747, // MKBETAG('6','2','7','G'),
    AV_CODEC_ID_ADPCM_AFC = $41464320, // MKBETAG('A','F','C',' '),
    AV_CODEC_ID_ASS = $41534B20, // MKBETAG('A','S','S',' '),  ///< ASS as defined in Matroska
    AV_CODEC_ID_AVRP = $41565250, // MKBETAG('A','V','R','P'),
    AV_CODEC_ID_AVRN = $4156526E, // MKBETAG('A','V','R','n'),
    AV_CODEC_ID_AVUI = $41565549, // MKBETAG('A','V','U','I'),
    AV_CODEC_ID_AYUV = $41595556, // MKBETAG('A','Y','U','V'),
    AV_CODEC_ID_BRENDER_PIX = $42504958, // MKBETAG('B','P','I','X'),
    AV_CODEC_ID_BINTEXT = $42545854, // MKBETAG('B','T','X','T'),
    AV_CODEC_ID_CPIA = $43504941, // MKBETAG('C','P','I','A'),
    AV_CODEC_ID_DVD_NAV = $444E4156, // MKBETAG('D','N','A','V'),
    AV_CODEC_ID_DSD_LSBF_PLANAR = $44534431, // MKBETAG('D','S','D','1'),
    AV_CODEC_ID_DSD_MSBF_PLANAR = $44534438, // MKBETAG('D','S','D','8'),
    AV_CODEC_ID_DSD_LSBF = $4453444C, // MKBETAG('D','S','D','L'),
    AV_CODEC_ID_DSD_MSBF = $4453444D, // MKBETAG('D','S','D','M'),
    AV_CODEC_ID_ADPCM_DTK = $44544B20, // MKBETAG('D','T','K',' '),
    AV_CODEC_ID_ESCAPE130 = $45313330, // MKBETAG('E','1','3','0'),
    AV_CODEC_ID_FFWAVESYNTH = $46465753, // MKBETAG('F','F','W','S'),
    AV_CODEC_ID_JACOSUB = $4A535542, // MKBETAG('J','S','U','B'),
    AV_CODEC_ID_SMPTE_KLV = $4B4C5641, // MKBETAG('K','L','V','A'),
    AV_CODEC_ID_MPL2 = $4D504C32, // MKBETAG('M','P','L','2'),
    AV_CODEC_ID_MVC1 = $4D564331, // MKBETAG('M','V','C','1'),
    AV_CODEC_ID_MVC2 = $4D564332, // MKBETAG('M','V','C','2'),
    AV_CODEC_ID_ADPCM_IMA_OKI = $4F4B4920, // MKBETAG('O','K','I',' '),
    AV_CODEC_ID_OPUS = $4F505553, // MKBETAG('O','P','U','S'),
    AV_CODEC_ID_PAF_AUDIO = $50414641, // MKBETAG('P','A','F','A'),
    AV_CODEC_ID_PAF_VIDEO = $50414656, // MKBETAG('P','A','F','V'),
    AV_CODEC_ID_PCM_S16BE_PLANAR = $50535010, // MKBETAG('P','S','P',16),
    AV_CODEC_ID_PJS = $50684A53, // MKBETAG('P','h','J','S'),
    AV_CODEC_ID_ADPCM_IMA_RAD = $52414420, // MKBETAG('R','A','D',' '),
    AV_CODEC_ID_REALTEXT = $52545854, // MKBETAG('R','T','X','T'),
    AV_CODEC_ID_SAMI = $53414D49, // MKBETAG('S','A','M','I'),
    AV_CODEC_ID_SANM = $53414E4D, // MKBETAG('S','A','N','M'),
    AV_CODEC_ID_SGIRLE = $53474952, // MKBETAG('S','G','I','R'),
    AV_CODEC_ID_SMVJPEG = $534D564A, // MKBETAG('S','M','V','J'),
    AV_CODEC_ID_SNOW = $534E4F57, // MKBETAG('S','N','O','W'),
    AV_CODEC_ID_SONIC = $534F4E43, // MKBETAG('S','O','N','C'),
    AV_CODEC_ID_SONIC_LS = $534F4E4C, // MKBETAG('S','O','N','L'),
    AV_CODEC_ID_SUBRIP = $53526970, // MKBETAG('S','R','i','p'),
    AV_CODEC_ID_SUBVIEWER1 = $53625631, // MKBETAG('S','b','V','1'),
    AV_CODEC_ID_SUBVIEWER = $53756256, // MKBETAG('S','u','b','V'),
    AV_CODEC_ID_TARGA_Y216 = $54323136, // MKBETAG('T','2','1','6'),
    AV_CODEC_ID_TIMED_ID3 = $54494433, // MKBETAG('T','I','D','3'),
    AV_CODEC_ID_V308 = $56333038, // MKBETAG('V','3','0','8'),
    AV_CODEC_ID_V408 = $56413038, // MKBETAG('V','4','0','8'),
    AV_CODEC_ID_ADPCM_VIMA = $56494D41, // MKBETAG('V','I','M','A'),
    AV_CODEC_ID_VIMA = $56494D41, // MKBETAG('V','I','M','A'),
    AV_CODEC_ID_VPLAYER = $56506C72, // MKBETAG('V','P','l','r'),
    AV_CODEC_ID_WEBP = $57454250, // MKBETAG('W','E','B','P'),
    AV_CODEC_ID_WEBVTT = $57565454, // MKBETAG('W','V','T','T'),
    AV_CODEC_ID_XBIN = $5842494E, // MKBETAG('X','B','I','N'),
    AV_CODEC_ID_XFACE = $58464143, // MKBETAG('X','F','A','C'),
    AV_CODEC_ID_Y41P = $59343150, // MKBETAG('Y','4','1','P'),
    AV_CODEC_ID_YUV4 = $59555634, // MKBETAG('Y','U','V','4'),
    AV_CODEC_ID_EIA_608 = $63363038, // MKBETAG('c','6','0','8'),
    AV_CODEC_ID_MICRODVD = $6D445644, // MKBETAG('m','D','V','D')
    AV_CODEC_ID_EVRC = $73657663, // MKBETAG('s','e','v','c'),
    AV_CODEC_ID_SMV = $73736D76, // MKBETAG('s','s','m','v'),
    AV_CODEC_ID_TAK = $7442614B // MKBETAG('t','B','a','K'),

    );

  PAVPixelFormat = ^TAVPixelFormat;
  TAVPixelFormat = (
    AV_PIX_FMT_NONE = -1,
    AV_PIX_FMT_YUV420P,   ///< planar YUV 4:2:0, 12bpp, (1 Cr & Cb sample per 2x2 Y samples)
    AV_PIX_FMT_YUYV422,   ///< packed YUV 4:2:2, 16bpp, Y0 Cb Y1 Cr
    AV_PIX_FMT_RGB24,     ///< packed RGB 8:8:8, 24bpp, RGBRGB...
    AV_PIX_FMT_BGR24,     ///< packed RGB 8:8:8, 24bpp, BGRBGR...
    AV_PIX_FMT_YUV422P,   ///< planar YUV 4:2:2, 16bpp, (1 Cr & Cb sample per 2x1 Y samples)
    AV_PIX_FMT_YUV444P,   ///< planar YUV 4:4:4, 24bpp, (1 Cr & Cb sample per 1x1 Y samples)
    AV_PIX_FMT_YUV410P,   ///< planar YUV 4:1:0,  9bpp, (1 Cr & Cb sample per 4x4 Y samples)
    AV_PIX_FMT_YUV411P,   ///< planar YUV 4:1:1, 12bpp, (1 Cr & Cb sample per 4x1 Y samples)
    AV_PIX_FMT_GRAY8,     ///<        Y        ,  8bpp
    AV_PIX_FMT_MONOWHITE, ///<        Y        ,  1bpp, 0 is white, 1 is black, in each byte pixels are ordered from the msb to the lsb
    AV_PIX_FMT_MONOBLACK, ///<        Y        ,  1bpp, 0 is black, 1 is white, in each byte pixels are ordered from the msb to the lsb
    AV_PIX_FMT_PAL8,      ///< 8 bit with PIX_FMT_RGB32 palette
    AV_PIX_FMT_YUVJ420P,  ///< planar YUV 4:2:0, 12bpp, full scale (JPEG), deprecated in favor of PIX_FMT_YUV420P and setting color_range
    AV_PIX_FMT_YUVJ422P,  ///< planar YUV 4:2:2, 16bpp, full scale (JPEG), deprecated in favor of PIX_FMT_YUV422P and setting color_range
    AV_PIX_FMT_YUVJ444P,  ///< planar YUV 4:4:4, 24bpp, full scale (JPEG), deprecated in favor of PIX_FMT_YUV444P and setting color_range
{$IFDEF FF_API_XVMC}
    AV_PIX_FMT_XVMC_MPEG2_MC,///< XVideo Motion Acceleration via common packet passing
    AV_PIX_FMT_XVMC_MPEG2_IDCT,
    {$define AV_PIX_FMT_XVMC := (AV_PIX_FMT_XVMC_MPEG2_IDCT)}
{$ENDIF}
    AV_PIX_FMT_UYVY422,   ///< packed YUV 4:2:2, 16bpp, Cb Y0 Cr Y1
    AV_PIX_FMT_UYYVYY411, ///< packed YUV 4:1:1, 12bpp, Cb Y0 Y1 Cr Y2 Y3
    AV_PIX_FMT_BGR8,      ///< packed RGB 3:3:2,  8bpp, (msb)2B 3G 3R(lsb)
    AV_PIX_FMT_BGR4,      ///< packed RGB 1:2:1 bitstream,  4bpp, (msb)1B 2G 1R(lsb), a byte contains two pixels, the first pixel in the byte is the one composed by the 4 msb bits
    AV_PIX_FMT_BGR4_BYTE, ///< packed RGB 1:2:1,  8bpp, (msb)1B 2G 1R(lsb)
    AV_PIX_FMT_RGB8,      ///< packed RGB 3:3:2,  8bpp, (msb)2R 3G 3B(lsb)
    AV_PIX_FMT_RGB4,      ///< packed RGB 1:2:1 bitstream,  4bpp, (msb)1R 2G 1B(lsb), a byte contains two pixels, the first pixel in the byte is the one composed by the 4 msb bits
    AV_PIX_FMT_RGB4_BYTE, ///< packed RGB 1:2:1,  8bpp, (msb)1R 2G 1B(lsb)
    AV_PIX_FMT_NV12,      ///< planar YUV 4:2:0, 12bpp, 1 plane for Y and 1 plane for the UV components, which are interleaved (first byte U and the following byte V)
    AV_PIX_FMT_NV21,      ///< as above, but U and V bytes are swapped

    AV_PIX_FMT_ARGB,      ///< packed ARGB 8:8:8:8, 32bpp, ARGBARGB...
    AV_PIX_FMT_RGBA,      ///< packed RGBA 8:8:8:8, 32bpp, RGBARGBA...
    AV_PIX_FMT_ABGR,      ///< packed ABGR 8:8:8:8, 32bpp, ABGRABGR...
    AV_PIX_FMT_BGRA,      ///< packed BGRA 8:8:8:8, 32bpp, BGRABGRA...

    AV_PIX_FMT_GRAY16BE,  ///<        Y        , 16bpp, big-endian
    AV_PIX_FMT_GRAY16LE,  ///<        Y        , 16bpp, little-endian
    AV_PIX_FMT_YUV440P,   ///< planar YUV 4:4:0 (1 Cr & Cb sample per 1x2 Y samples)
    AV_PIX_FMT_YUVJ440P,  ///< planar YUV 4:4:0 full scale (JPEG), deprecated in favor of PIX_FMT_YUV440P and setting color_range
    AV_PIX_FMT_YUVA420P,  ///< planar YUV 4:2:0, 20bpp, (1 Cr & Cb sample per 2x2 Y & A samples)
{$IFDEF FF_API_VDPAU}
    AV_PIX_FMT_VDPAU_H264,///< H.264 HW decoding with VDPAU, data[0] contains a vdpau_render_state struct which contains the bitstream of the slices as well as various fields extracted from headers
    AV_PIX_FMT_VDPAU_MPEG1,///< MPEG-1 HW decoding with VDPAU, data[0] contains a vdpau_render_state struct which contains the bitstream of the slices as well as various fields extracted from headers
    AV_PIX_FMT_VDPAU_MPEG2,///< MPEG-2 HW decoding with VDPAU, data[0] contains a vdpau_render_state struct which contains the bitstream of the slices as well as various fields extracted from headers
    AV_PIX_FMT_VDPAU_WMV3,///< WMV3 HW decoding with VDPAU, data[0] contains a vdpau_render_state struct which contains the bitstream of the slices as well as various fields extracted from headers
    AV_PIX_FMT_VDPAU_VC1, ///< VC-1 HW decoding with VDPAU, data[0] contains a vdpau_render_state struct which contains the bitstream of the slices as well as various fields extracted from headers
{$ENDIF}
    AV_PIX_FMT_RGB48BE,   ///< packed RGB 16:16:16, 48bpp, 16R, 16G, 16B, the 2-byte value for each R/G/B component is stored as big-endian
    AV_PIX_FMT_RGB48LE,   ///< packed RGB 16:16:16, 48bpp, 16R, 16G, 16B, the 2-byte value for each R/G/B component is stored as little-endian

    AV_PIX_FMT_RGB565BE,  ///< packed RGB 5:6:5, 16bpp, (msb)   5R 6G 5B(lsb), big-endian
    AV_PIX_FMT_RGB565LE,  ///< packed RGB 5:6:5, 16bpp, (msb)   5R 6G 5B(lsb), little-endian
    AV_PIX_FMT_RGB555BE,  ///< packed RGB 5:5:5, 16bpp, (msb)1A 5R 5G 5B(lsb), big-endian, most significant bit to 0
    AV_PIX_FMT_RGB555LE,  ///< packed RGB 5:5:5, 16bpp, (msb)1A 5R 5G 5B(lsb), little-endian, most significant bit to 0

    AV_PIX_FMT_BGR565BE,  ///< packed BGR 5:6:5, 16bpp, (msb)   5B 6G 5R(lsb), big-endian
    AV_PIX_FMT_BGR565LE,  ///< packed BGR 5:6:5, 16bpp, (msb)   5B 6G 5R(lsb), little-endian
    AV_PIX_FMT_BGR555BE,  ///< packed BGR 5:5:5, 16bpp, (msb)1A 5B 5G 5R(lsb), big-endian, most significant bit to 1
    AV_PIX_FMT_BGR555LE,  ///< packed BGR 5:5:5, 16bpp, (msb)1A 5B 5G 5R(lsb), little-endian, most significant bit to 1

    AV_PIX_FMT_VAAPI_MOCO, ///< HW acceleration through VA API at motion compensation entry-point, Picture.data[3] contains a vaapi_render_state struct which contains macroblocks as well as various fields extracted from headers
    AV_PIX_FMT_VAAPI_IDCT, ///< HW acceleration through VA API at IDCT entry-point, Picture.data[3] contains a vaapi_render_state struct which contains fields extracted from headers
    AV_PIX_FMT_VAAPI_VLD,  ///< HW decoding through VA API, Picture.data[3] contains a vaapi_render_state struct which contains the bitstream of the slices as well as various fields extracted from headers

    AV_PIX_FMT_YUV420P16LE,  ///< planar YUV 4:2:0, 24bpp, (1 Cr & Cb sample per 2x2 Y samples), little-endian
    AV_PIX_FMT_YUV420P16BE,  ///< planar YUV 4:2:0, 24bpp, (1 Cr & Cb sample per 2x2 Y samples), big-endian
    AV_PIX_FMT_YUV422P16LE,  ///< planar YUV 4:2:2, 32bpp, (1 Cr & Cb sample per 2x1 Y samples), little-endian
    AV_PIX_FMT_YUV422P16BE,  ///< planar YUV 4:2:2, 32bpp, (1 Cr & Cb sample per 2x1 Y samples), big-endian
    AV_PIX_FMT_YUV444P16LE,  ///< planar YUV 4:4:4, 48bpp, (1 Cr & Cb sample per 1x1 Y samples), little-endian
    AV_PIX_FMT_YUV444P16BE,  ///< planar YUV 4:4:4, 48bpp, (1 Cr & Cb sample per 1x1 Y samples), big-endian
{$IFDEF FF_API_VDPAU}
    AV_PIX_FMT_VDPAU_MPEG4,  ///< MPEG4 HW decoding with VDPAU, data[0] contains a vdpau_render_state struct which contains the bitstream of the slices as well as various fields extracted from headers
{$ENDIF}
    AV_PIX_FMT_DXVA2_VLD,    ///< HW decoding through DXVA2, Picture.data[3] contains a LPDIRECT3DSURFACE9 pointer

    AV_PIX_FMT_RGB444LE,  ///< packed RGB 4:4:4, 16bpp, (msb)4A 4R 4G 4B(lsb), little-endian, most significant bits to 0
    AV_PIX_FMT_RGB444BE,  ///< packed RGB 4:4:4, 16bpp, (msb)4A 4R 4G 4B(lsb), big-endian, most significant bits to 0
    AV_PIX_FMT_BGR444LE,  ///< packed BGR 4:4:4, 16bpp, (msb)4A 4B 4G 4R(lsb), little-endian, most significant bits to 1
    AV_PIX_FMT_BGR444BE,  ///< packed BGR 4:4:4, 16bpp, (msb)4A 4B 4G 4R(lsb), big-endian, most significant bits to 1
    AV_PIX_FMT_YA8,       ///< 8bit gray, 8bit alpha
(* see const declaration way down
    AV_PIX_FMT_Y400A = AV_PIX_FMT_YA8, ///< alias for AV_PIX_FMT_YA8
    AV_PIX_FMT_GRAY8A= AV_PIX_FMT_YA8, ///< alias for AV_PIX_FMT_YA8
*)
    AV_PIX_FMT_BGR48BE,   ///< packed RGB 16:16:16, 48bpp, 16B, 16G, 16R, the 2-byte value for each R/G/B component is stored as big-endian
    AV_PIX_FMT_BGR48LE,   ///< packed RGB 16:16:16, 48bpp, 16B, 16G, 16R, the 2-byte value for each R/G/B component is stored as little-endian

    (**
     * The following 12 formats have the disadvantage of needing 1 format for each bit depth.
     * Notice that each 9/10 bits sample is stored in 16 bits with extra padding.
     * If you want to support multiple bit depths, then using AV_PIX_FMT_YUV420P16* with the bpp stored separately is better.
     *)
    AV_PIX_FMT_YUV420P9BE, ///< planar YUV 4:2:0, 13.5bpp, (1 Cr & Cb sample per 2x2 Y samples), big-endian
    AV_PIX_FMT_YUV420P9LE, ///< planar YUV 4:2:0, 13.5bpp, (1 Cr & Cb sample per 2x2 Y samples), little-endian
    AV_PIX_FMT_YUV420P10BE,///< planar YUV 4:2:0, 15bpp, (1 Cr & Cb sample per 2x2 Y samples), big-endian
    AV_PIX_FMT_YUV420P10LE,///< planar YUV 4:2:0, 15bpp, (1 Cr & Cb sample per 2x2 Y samples), little-endian
    AV_PIX_FMT_YUV422P10BE,///< planar YUV 4:2:2, 20bpp, (1 Cr & Cb sample per 2x1 Y samples), big-endian
    AV_PIX_FMT_YUV422P10LE,///< planar YUV 4:2:2, 20bpp, (1 Cr & Cb sample per 2x1 Y samples), little-endian
    AV_PIX_FMT_YUV444P9BE, ///< planar YUV 4:4:4, 27bpp, (1 Cr & Cb sample per 1x1 Y samples), big-endian
    AV_PIX_FMT_YUV444P9LE, ///< planar YUV 4:4:4, 27bpp, (1 Cr & Cb sample per 1x1 Y samples), little-endian
    AV_PIX_FMT_YUV444P10BE,///< planar YUV 4:4:4, 30bpp, (1 Cr & Cb sample per 1x1 Y samples), big-endian
    AV_PIX_FMT_YUV444P10LE,///< planar YUV 4:4:4, 30bpp, (1 Cr & Cb sample per 1x1 Y samples), little-endian
    AV_PIX_FMT_YUV422P9BE, ///< planar YUV 4:2:2, 18bpp, (1 Cr & Cb sample per 2x1 Y samples), big-endian
    AV_PIX_FMT_YUV422P9LE, ///< planar YUV 4:2:2, 18bpp, (1 Cr & Cb sample per 2x1 Y samples), little-endian
    AV_PIX_FMT_VDA_VLD,    ///< hardware decoding through VDA

{$IFDEF AV_PIX_FMT_ABI_GIT_MASTER}
    AV_PIX_FMT_RGBA64BE,  ///< packed RGBA 16:16:16:16, 64bpp, 16R, 16G, 16B, 16A, the 2-byte value for each R/G/B/A component is stored as big-endian
    AV_PIX_FMT_RGBA64LE,  ///< packed RGBA 16:16:16:16, 64bpp, 16R, 16G, 16B, 16A, the 2-byte value for each R/G/B/A component is stored as little-endian
    AV_PIX_FMT_BGRA64BE,  ///< packed RGBA 16:16:16:16, 64bpp, 16B, 16G, 16R, 16A, the 2-byte value for each R/G/B/A component is stored as big-endian
    AV_PIX_FMT_BGRA64LE,  ///< packed RGBA 16:16:16:16, 64bpp, 16B, 16G, 16R, 16A, the 2-byte value for each R/G/B/A component is stored as little-endian
{$ENDIF}
    AV_PIX_FMT_GBRP,      ///< planar GBR 4:4:4 24bpp
    AV_PIX_FMT_GBRP9BE,   ///< planar GBR 4:4:4 27bpp, big-endian
    AV_PIX_FMT_GBRP9LE,   ///< planar GBR 4:4:4 27bpp, little-endian
    AV_PIX_FMT_GBRP10BE,  ///< planar GBR 4:4:4 30bpp, big-endian
    AV_PIX_FMT_GBRP10LE,  ///< planar GBR 4:4:4 30bpp, little-endian
    AV_PIX_FMT_GBRP16BE,  ///< planar GBR 4:4:4 48bpp, big-endian
    AV_PIX_FMT_GBRP16LE,  ///< planar GBR 4:4:4 48bpp, little-endian

    (**
     * duplicated pixel formats for compatibility with libav.
     * FFmpeg supports these formats since May 8 2012 and Jan 28 2012 (commits f9ca1ac7 and 143a5c55)
     * Libav added them Oct 12 2012 with incompatible values (commit 6d5600e85)
     *)
    AV_PIX_FMT_YUVA422P_LIBAV,  ///< planar YUV 4:2:2 24bpp, (1 Cr & Cb sample per 2x1 Y & A samples)
    AV_PIX_FMT_YUVA444P_LIBAV,  ///< planar YUV 4:4:4 32bpp, (1 Cr & Cb sample per 1x1 Y & A samples)

    AV_PIX_FMT_YUVA420P9BE,  ///< planar YUV 4:2:0 22.5bpp, (1 Cr & Cb sample per 2x2 Y & A samples), big-endian
    AV_PIX_FMT_YUVA420P9LE,  ///< planar YUV 4:2:0 22.5bpp, (1 Cr & Cb sample per 2x2 Y & A samples), little-endian
    AV_PIX_FMT_YUVA422P9BE,  ///< planar YUV 4:2:2 27bpp, (1 Cr & Cb sample per 2x1 Y & A samples), big-endian
    AV_PIX_FMT_YUVA422P9LE,  ///< planar YUV 4:2:2 27bpp, (1 Cr & Cb sample per 2x1 Y & A samples), little-endian
    AV_PIX_FMT_YUVA444P9BE,  ///< planar YUV 4:4:4 36bpp, (1 Cr & Cb sample per 1x1 Y & A samples), big-endian
    AV_PIX_FMT_YUVA444P9LE,  ///< planar YUV 4:4:4 36bpp, (1 Cr & Cb sample per 1x1 Y & A samples), little-endian
    AV_PIX_FMT_YUVA420P10BE, ///< planar YUV 4:2:0 25bpp, (1 Cr & Cb sample per 2x2 Y & A samples, big-endian)
    AV_PIX_FMT_YUVA420P10LE, ///< planar YUV 4:2:0 25bpp, (1 Cr & Cb sample per 2x2 Y & A samples, little-endian)
    AV_PIX_FMT_YUVA422P10BE, ///< planar YUV 4:2:2 30bpp, (1 Cr & Cb sample per 2x1 Y & A samples, big-endian)
    AV_PIX_FMT_YUVA422P10LE, ///< planar YUV 4:2:2 30bpp, (1 Cr & Cb sample per 2x1 Y & A samples, little-endian)
    AV_PIX_FMT_YUVA444P10BE, ///< planar YUV 4:4:4 40bpp, (1 Cr & Cb sample per 1x1 Y & A samples, big-endian)
    AV_PIX_FMT_YUVA444P10LE, ///< planar YUV 4:4:4 40bpp, (1 Cr & Cb sample per 1x1 Y & A samples, little-endian)
    AV_PIX_FMT_YUVA420P16BE, ///< planar YUV 4:2:0 40bpp, (1 Cr & Cb sample per 2x2 Y & A samples, big-endian)
    AV_PIX_FMT_YUVA420P16LE, ///< planar YUV 4:2:0 40bpp, (1 Cr & Cb sample per 2x2 Y & A samples, little-endian)
    AV_PIX_FMT_YUVA422P16BE, ///< planar YUV 4:2:2 48bpp, (1 Cr & Cb sample per 2x1 Y & A samples, big-endian)
    AV_PIX_FMT_YUVA422P16LE, ///< planar YUV 4:2:2 48bpp, (1 Cr & Cb sample per 2x1 Y & A samples, little-endian)
    AV_PIX_FMT_YUVA444P16BE, ///< planar YUV 4:4:4 64bpp, (1 Cr & Cb sample per 1x1 Y & A samples, big-endian)
    AV_PIX_FMT_YUVA444P16LE, ///< planar YUV 4:4:4 64bpp, (1 Cr & Cb sample per 1x1 Y & A samples, little-endian)

    AV_PIX_FMT_VDPAU,        ///< HW acceleration through VDPAU, Picture.data[3] contains a VdpVideoSurface

    AV_PIX_FMT_XYZ12LE,      ///< packed XYZ 4:4:4, 36 bpp, (msb) 12X, 12Y, 12Z (lsb), the 2-byte value for each X/Y/Z is stored as little-endian, the 4 lower bits are set to 0
    AV_PIX_FMT_XYZ12BE,      ///< packed XYZ 4:4:4, 36 bpp, (msb) 12X, 12Y, 12Z (lsb), the 2-byte value for each X/Y/Z is stored as big-endian, the 4 lower bits are set to 0
    AV_PIX_FMT_NV16,         ///< interleaved chroma YUV 4:2:2, 16bpp, (1 Cr & Cb sample per 2x1 Y samples)
    AV_PIX_FMT_NV20LE,       ///< interleaved chroma YUV 4:2:2, 20bpp, (1 Cr & Cb sample per 2x1 Y samples), little-endian
    AV_PIX_FMT_NV20BE,       ///< interleaved chroma YUV 4:2:2, 20bpp, (1 Cr & Cb sample per 2x1 Y samples), big-endian

    (**
     * duplicated pixel formats for compatibility with libav.
     * FFmpeg supports these formats since Sat Sep 24 06:01:45 2011 +0200 (commits 9569a3c9f41387a8c7d1ce97d8693520477a66c3)
     * also see Fri Nov 25 01:38:21 2011 +0100 92afb431621c79155fcb7171d26f137eb1bee028
     * Libav added them Sun Mar 16 23:05:47 2014 +0100 with incompatible values (commit 1481d24c3a0abf81e1d7a514547bd5305232be30)
     *)
    AV_PIX_FMT_RGBA64BE_LIBAV,     ///< packed RGBA 16:16:16:16, 64bpp, 16R, 16G, 16B, 16A, the 2-byte value for each R/G/B/A component is stored as big-endian
    AV_PIX_FMT_RGBA64LE_LIBAV,     ///< packed RGBA 16:16:16:16, 64bpp, 16R, 16G, 16B, 16A, the 2-byte value for each R/G/B/A component is stored as little-endian
    AV_PIX_FMT_BGRA64BE_LIBAV,     ///< packed RGBA 16:16:16:16, 64bpp, 16B, 16G, 16R, 16A, the 2-byte value for each R/G/B/A component is stored as big-endian
    AV_PIX_FMT_BGRA64LE_LIBAV,     ///< packed RGBA 16:16:16:16, 64bpp, 16B, 16G, 16R, 16A, the 2-byte value for each R/G/B/A component is stored as little-endian

    AV_PIX_FMT_YVYU422,   ///< packed YUV 4:2:2, 16bpp, Y0 Cr Y1 Cb

    AV_PIX_FMT_VDA,          ///< HW acceleration through VDA, data[3] contains a CVPixelBufferRef

    AV_PIX_FMT_YA16BE,       ///< 16bit gray, 16bit alpha (big-endian)
    AV_PIX_FMT_YA16LE,       ///< 16bit gray, 16bit alpha (little-endian)


{$IFNDEF AV_PIX_FMT_ABI_GIT_MASTER}
    AV_PIX_FMT_RGBA64BE = $123,  ///< packed RGBA 16:16:16:16, 64bpp, 16R, 16G, 16B, 16A, the 2-byte value for each R/G/B/A component is stored as big-endian
    AV_PIX_FMT_RGBA64LE,  ///< packed RGBA 16:16:16:16, 64bpp, 16R, 16G, 16B, 16A, the 2-byte value for each R/G/B/A component is stored as little-endian
    AV_PIX_FMT_BGRA64BE,  ///< packed RGBA 16:16:16:16, 64bpp, 16B, 16G, 16R, 16A, the 2-byte value for each R/G/B/A component is stored as big-endian
    AV_PIX_FMT_BGRA64LE,  ///< packed RGBA 16:16:16:16, 64bpp, 16B, 16G, 16R, 16A, the 2-byte value for each R/G/B/A component is stored as little-endian
{$ENDIF}
    AV_PIX_FMT_0RGB = $123 + 4,      ///< packed RGB 8:8:8, 32bpp, 0RGB0RGB...
    AV_PIX_FMT_RGB0,      ///< packed RGB 8:8:8, 32bpp, RGB0RGB0...
    AV_PIX_FMT_0BGR,      ///< packed BGR 8:8:8, 32bpp, 0BGR0BGR...
    AV_PIX_FMT_BGR0,      ///< packed BGR 8:8:8, 32bpp, BGR0BGR0...
    AV_PIX_FMT_YUVA444P,  ///< planar YUV 4:4:4 32bpp, (1 Cr & Cb sample per 1x1 Y & A samples)
    AV_PIX_FMT_YUVA422P,  ///< planar YUV 4:2:2 24bpp, (1 Cr & Cb sample per 2x1 Y & A samples)

    AV_PIX_FMT_YUV420P12BE, ///< planar YUV 4:2:0,18bpp, (1 Cr & Cb sample per 2x2 Y samples), big-endian
    AV_PIX_FMT_YUV420P12LE, ///< planar YUV 4:2:0,18bpp, (1 Cr & Cb sample per 2x2 Y samples), little-endian
    AV_PIX_FMT_YUV420P14BE, ///< planar YUV 4:2:0,21bpp, (1 Cr & Cb sample per 2x2 Y samples), big-endian
    AV_PIX_FMT_YUV420P14LE, ///< planar YUV 4:2:0,21bpp, (1 Cr & Cb sample per 2x2 Y samples), little-endian
    AV_PIX_FMT_YUV422P12BE, ///< planar YUV 4:2:2,24bpp, (1 Cr & Cb sample per 2x1 Y samples), big-endian
    AV_PIX_FMT_YUV422P12LE, ///< planar YUV 4:2:2,24bpp, (1 Cr & Cb sample per 2x1 Y samples), little-endian
    AV_PIX_FMT_YUV422P14BE, ///< planar YUV 4:2:2,28bpp, (1 Cr & Cb sample per 2x1 Y samples), big-endian
    AV_PIX_FMT_YUV422P14LE, ///< planar YUV 4:2:2,28bpp, (1 Cr & Cb sample per 2x1 Y samples), little-endian
    AV_PIX_FMT_YUV444P12BE, ///< planar YUV 4:4:4,36bpp, (1 Cr & Cb sample per 1x1 Y samples), big-endian
    AV_PIX_FMT_YUV444P12LE, ///< planar YUV 4:4:4,36bpp, (1 Cr & Cb sample per 1x1 Y samples), little-endian
    AV_PIX_FMT_YUV444P14BE, ///< planar YUV 4:4:4,42bpp, (1 Cr & Cb sample per 1x1 Y samples), big-endian
    AV_PIX_FMT_YUV444P14LE, ///< planar YUV 4:4:4,42bpp, (1 Cr & Cb sample per 1x1 Y samples), little-endian
    AV_PIX_FMT_GBRP12BE,    ///< planar GBR 4:4:4 36bpp, big-endian
    AV_PIX_FMT_GBRP12LE,    ///< planar GBR 4:4:4 36bpp, little-endian
    AV_PIX_FMT_GBRP14BE,    ///< planar GBR 4:4:4 42bpp, big-endian
    AV_PIX_FMT_GBRP14LE,    ///< planar GBR 4:4:4 42bpp, little-endian
    AV_PIX_FMT_GBRAP,       ///< planar GBRA 4:4:4:4 32bpp
    AV_PIX_FMT_GBRAP16BE,   ///< planar GBRA 4:4:4:4 64bpp, big-endian
    AV_PIX_FMT_GBRAP16LE,   ///< planar GBRA 4:4:4:4 64bpp, little-endian
    AV_PIX_FMT_YUVJ411P,    ///< planar YUV 4:1:1, 12bpp, (1 Cr & Cb sample per 4x1 Y samples) full scale (JPEG), deprecated in favor of PIX_FMT_YUV411P and setting color_range

    AV_PIX_FMT_BAYER_BGGR8,    ///< bayer, BGBG..(odd line), GRGR..(even line), 8-bit samples */
    AV_PIX_FMT_BAYER_RGGB8,    ///< bayer, RGRG..(odd line), GBGB..(even line), 8-bit samples */
    AV_PIX_FMT_BAYER_GBRG8,    ///< bayer, GBGB..(odd line), RGRG..(even line), 8-bit samples */
    AV_PIX_FMT_BAYER_GRBG8,    ///< bayer, GRGR..(odd line), BGBG..(even line), 8-bit samples */
    AV_PIX_FMT_BAYER_BGGR16LE, ///< bayer, BGBG..(odd line), GRGR..(even line), 16-bit samples, little-endian */
    AV_PIX_FMT_BAYER_BGGR16BE, ///< bayer, BGBG..(odd line), GRGR..(even line), 16-bit samples, big-endian */
    AV_PIX_FMT_BAYER_RGGB16LE, ///< bayer, RGRG..(odd line), GBGB..(even line), 16-bit samples, little-endian */
    AV_PIX_FMT_BAYER_RGGB16BE, ///< bayer, RGRG..(odd line), GBGB..(even line), 16-bit samples, big-endian */
    AV_PIX_FMT_BAYER_GBRG16LE, ///< bayer, GBGB..(odd line), RGRG..(even line), 16-bit samples, little-endian */
    AV_PIX_FMT_BAYER_GBRG16BE, ///< bayer, GBGB..(odd line), RGRG..(even line), 16-bit samples, big-endian */
    AV_PIX_FMT_BAYER_GRBG16LE, ///< bayer, GRGR..(odd line), BGBG..(even line), 16-bit samples, little-endian */
    AV_PIX_FMT_BAYER_GRBG16BE, ///< bayer, GRGR..(odd line), BGBG..(even line), 16-bit samples, big-endian */
{$ifndef FF_API_XVMC}
    AV_PIX_FMT_XVMC,           ///< XVideo Motion Acceleration via common packet passing
{$endif}
    AV_PIX_FMT_NB        ///< number of pixel formats, DO NOT USE THIS if you want to link with shared libav* because the number of formats might differ between versions
  );

  TReadWriteFunc = function(opaque: Pointer; buf: PByteArray; buf_size: cint): cint; cdecl;
  TSeekFunc = function(opaque: Pointer; offset: cint64; whence: cint): cint64; cdecl;
  Tcallback = function(p: pointer): cint; cdecl;

  PAVIOInterruptCB = ^TAVIOInterruptCB;

  TAVIOInterruptCB = record
    callback: Tcallback;
    opaque: pointer;
  end;

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
    av_class: {const} Pointer;//PAVClass;
    buffer: PByteArray;  (**< Start of the buffer. *)
    buffer_size: cint;   (**< Maximum buffer size *)
    buf_ptr: PByteArray; (**< Current position in the buffer *)
    buf_end: PByteArray; (**< End of the data, may be less than
                              buffer+buffer_size if the read function returned
                              less data than requested, e.g. for streams where
                              no more data has been received yet. *)
    opaque: pointer;     (**< A private pointer, passed to the read/write/seek/...
                              functions. *)
    read_packet: TReadWriteFunc;
    write_packet: TReadWriteFunc;
    seek: TSeekFunc;
    pos: cint64;         (**< position in the file of the current buffer *)
    must_flush: cint;    (**< true if the next seek should flush *)
    eof_reached: cint;   (**< true if eof reached *)
    write_flag: cint;    (**< true if open for writing *)
    max_packet_size: cint;
    checksum: culong;
    checksum_ptr: PByteArray;
    update_checksum: function(checksum: culong; buf: {const} PAnsiChar; size: cuint): culong; cdecl;
    error: cint;         (**< contains the error code or 0 if no error happened *)
    (**
     * Pause or resume playback for network streaming protocols - e.g. MMS.
     *)
    read_pause: function(opaque: Pointer; pause: cint): cint; cdecl;
    (**
     * Seek to a given timestamp in stream with the specified stream_index.
     * Needed for some network streaming protocols which don't support seeking
     * to byte position.
     *)
    read_seek: function(opaque: Pointer; stream_index: cint; timestamp: cint64;
        flags: cint): cint64; cdecl;
    (**
     * A combination of AVIO_SEEKABLE_ flags or 0 when the stream is not seekable.
     *)
    seekable: cint;

    (**
     * max filesize, used to limit allocations
     * This field is internal to libavformat and access from outside is not allowed.
     *)
    maxsize: cint64;

    (**
     * avio_read and avio_write should if possible be satisfied directly
     * instead of going through a buffer, and avio_seek will always
     * call the underlying seek function directly.
     *)
    direct: cint;

    (**
     * Bytes read statistic
     * This field is internal to libavformat and access from outside is not allowed.
     *)
    bytes_read: cint64;

    (**
     * seek statistic
     * This field is internal to libavformat and access from outside is not allowed.
     *)
    seek_count: cint;

    (**
     * writeout statistic
     * This field is internal to libavformat and access from outside is not allowed.
     *)
    writeout_count: cint;

    (**
     * Original buffer size
     * used internally after probing and ensure seekback to reset the buffer size
     * This field is internal to libavformat and access from outside is not allowed.
     *)
    orig_buffer_size: cint;
  end;

    PAVRational = ^TAVRational;
  TAVRational = record
    num: cint; ///< numerator
    den: cint; ///< denominator
  end;

    TAVDurationEstimationMethod = (
    AVFMT_DURATION_FROM_PTS,    ///< Duration accurately estimated from PTSes
    AVFMT_DURATION_FROM_STREAM, ///< Duration estimated from a stream with a known duration
    AVFMT_DURATION_FROM_BITRATE ///< Duration estimated from bitrate (less accurate)
    );
      TAv_format_control_message = function (s: Pointer; type_: cint;
				  data: pointer; data_size: size_t): cint; cdecl;



           PAVCodec = ^TAVCodec;
               PAVCodecContext = ^TAVCodecContext;
                    PAVPacket = ^TAVPacket;
                      PPAVFrame = ^PAVFrame;
  PAVFrame = ^TAVFrame;

               TAVCodec = record
    (**
     * Name of the codec implementation.
     * The name is globally unique among encoders and among decoders (but an
     * encoder and a decoder can share the same name).
     * This is the primary way to find a codec from the user perspective.
     *)
    name: PAnsiChar;
    (**
     * Descriptive name for the codec, meant to be more human readable than name.
     * You should use the NULL_IF_CONFIG_SMALL() macro to define it.
     *)
    long_name: {const} PAnsiChar;
    type_: TAVMediaType;
    id: TAVCodecID;
    (**
     * Codec capabilities.
     * see CODEC_CAP_*
     *)
    capabilities: cint;
    supported_framerates: {const} PAVRational; ///< array of supported framerates, or NULL if any, array is terminated by {0,0}
    pix_fmts: {const} pointer;//PAVPixelFormat;          ///< array of supported pixel formats, or NULL if unknown, array is terminated by -1
    supported_samplerates: {const} PCint;      ///< array of supported audio samplerates, or NULL if unknown, array is terminated by 0
    sample_fmts: {const} pointer;//PAVSampleFormatArray; ///< array of supported sample formats, or NULL if unknown, array is terminated by -1
    channel_layouts: {const} PCuint64;         ///< array of support channel layouts, or NULL if unknown. array is terminated by 0
    max_lowres: byte;                          ///< array of support channel layouts, or NULL if unknown. array is terminated by 0
    priv_class: {const} pointer;//PAVClass;              ///< AVClass for the private context
    profiles: {const} pointer;//PAVProfile;              ///< array of recognized profiles, or NULL if unknown, array is terminated by {FF_PROFILE_UNKNOWN}

    (*****************************************************************
     * No fields below this line are part of the public API. They
     * may not be used outside of libavcodec and can be changed and
     * removed at will.
     * New public fields should be added right above.
     *****************************************************************
     *)
    priv_data_size: cint;
    next: PAVCodec;
    (**
     * @name Frame-level threading support functions
     * @{
     *)
    (**
     * If defined, called on thread contexts when they are created.
     * If the codec allocates writable tables in init(), re-allocate them here.
     * priv_data will be set to a copy of the original.
     *)
    init_thread_copy: function (avctx: PAVCodecContext): Pcint; cdecl;
    (**
     * Copy necessary context variables from a previous thread context to the current one.
     * If not defined, the next thread will start automatically; otherwise, the codec
     * must call ff_thread_finish_setup().
     *
     * dst and src will (rarely) point to the same context, in which case memcpy should be skipped.
     *)
    update_thread_context: function (dst: PAVCodecContext; src: {const} PAVCodecContext): cint; cdecl;
    (** @} *)

    (**
     * Private codec-specific defaults.
     *)
    defaults: {const} pointer;

    (**
     * Initialize codec static data, called from avcodec_register().
     *)
    init_static_data: procedure (codec: PAVCodec); cdecl;

    init: function (avctx: PAVCodecContext): cint; cdecl;
    encode_sub: function (avctx: PAVCodecContext; buf: PByteArray; buf_size: cint;
                          sub: {const} pointer{PAVSubtitle}): cint; cdecl;
    (**
     * Encode data to an AVPacket.
     *
     * @param      avctx          codec context
     * @param      avpkt          output AVPacket (may contain a user-provided buffer)
     * @param[in]  frame          AVFrame containing the raw data to be encoded
     * @param[out] got_packet_ptr encoder sets to 0 or 1 to indicate that a
     *                            non-empty packet was returned in avpkt.
     * @return 0 on success, negative error code on failure
     *)
    encode2: function (avctx: PAVCodecContext; avpkt: PAVPacket; frame: {const} PAVFrame;
                   got_packet_ptr: Pcint): cint; cdecl;
    decode: function (avctx: PAVCodecContext; outdata: pointer; var outdata_size: cint; avpkt: PAVPacket): cint; cdecl;
    close: function (avctx: PAVCodecContext): cint; cdecl;
    (**
     * Flush buffers.
     * Will be called when seeking
     *)
    flush: procedure (avctx: PAVCodecContext); cdecl;
  end; {TAVCodec}



    TAVCodecContext = record {720}
    (**
     * information on struct for av_log
     * - set by avcodec_alloc_context3
     *)
    av_class: Pointer;//PAVClass;
    log_level_offset: cint;

    codec_type: TAVMediaType; (* see AVMEDIA_TYPE_xxx *)
    codec:      PAVCodec;
{$IFDEF FF_API_CODEC_NAME}
    (**
     * @deprecated this field is not used for anything in libavcodec
     *)
    {attribute_deprecated}
    codec_name: array [0..31] of AnsiChar;
{$IFEND}
    codec_id:   TAVCodecID; (* see AV_CODEC_ID_xxx *)

    (**
     * fourcc (LSB first, so "ABCD" -> ('D'<<24) + ('C'<<16) + ('B'<<8) + 'A').
     * This is used to work around some encoder bugs.
     * A demuxer should set this to what is stored in the field used to identify the codec.
     * If there are multiple such fields in a container then the demuxer should choose the one
     * which maximizes the information about the used codec.
     * If the codec tag field in a container is larger than 32 bits then the demuxer should
     * remap the longer ID to 32 bits with a table or other structure. Alternatively a new
     * extra_codec_tag + size could be added but for this a clear advantage must be demonstrated
     * first.
     * - encoding: Set by user, if not then the default based on codec_id will be used.
     * - decoding: Set by user, will be converted to uppercase by libavcodec during init.
     *)
    codec_tag: cuint;

    (**
     * fourcc from the AVI stream header (LSB first, so "ABCD" -> ('D'<<24) + ('C'<<16) + ('B'<<8) + 'A').
     * This is used to work around some encoder bugs.
     * - encoding: unused
     * - decoding: Set by user, will be converted to uppercase by libavcodec during init.
     *)
    stream_codec_tag: cuint;

    priv_data: pointer;

    (**
     * Private context used for internal data.
     *
     * Unlike priv_data, this is not codec-specific. It is used in general
     * libavcodec functions.
     *)
    internal: pointer;//PAVCodecInternal;

    (**
     * Private data of the user, can be used to carry app specific stuff.
     * - encoding: Set by user.
     * - decoding: Set by user.
     *)
    opaque: pointer;

    (**
     * the average bitrate
     * - encoding: Set by user; unused for constant quantizer encoding.
     * - decoding: Set by libavcodec. 0 or some bitrate if this info is available in the stream.
     *)
    bit_rate: cint64;

    (**
     * number of bits the bitstream is allowed to diverge from the reference.
     *           the reference can be CBR (for CBR pass1) or VBR (for pass2)
     * - encoding: Set by user; unused for constant quantizer encoding.
     * - decoding: unused
     *)
    bit_rate_tolerance: cint;

    (**
     * Global quality for codecs which cannot change it per frame.
     * This should be proportional to MPEG-1/2/4 qscale.
     * - encoding: Set by user.
     * - decoding: unused
     *)
    global_quality: cint;

    (**
     * - encoding: Set by user.
     * - decoding: unused
     *)
    compression_level: cint;

    (**
     * CODEC_FLAG_*.
     * - encoding: Set by user.
     * - decoding: Set by user.
     *)
    flags: cint;

    (**
     * CODEC_FLAG2_*
     * - encoding: Set by user.
     * - decoding: Set by user.
     *)
    flags2: cint;

    (**
     * some codecs need / can use extradata like Huffman tables.
     * mjpeg: Huffman tables
     * rv10: additional flags
     * mpeg4: global headers (they can be in the bitstream or here)
     * The allocated memory should be FF_INPUT_BUFFER_PADDING_SIZE bytes larger
     * than extradata_size to avoid problems if it is read with the bitstream reader.
     * The bytewise contents of extradata must not depend on the architecture or CPU endianness.
     * - encoding: Set/allocated/freed by libavcodec.
     * - decoding: Set/allocated/freed by user.
     *)
    extradata: pbyte;
    extradata_size: cint;

    (**
     * This is the fundamental unit of time (in seconds) in terms
     * of which frame timestamps are represented. For fixed-fps content,
     * timebase should be 1/framerate and timestamp increments should be
     * identically 1.
     * This often, but not always is the inverse of the frame rate or field rate
     * for video.
     * - encoding: MUST be set by user.
     * - decoding: the use of this field for decoding is deprecated.
     *             Use framerate instead.
     *)
    time_base: TAVRational;

    (**
     * For some codecs, the time base is closer to the field rate than the frame rate.
     * Most notably, H.264 and MPEG-2 specify time_base as half of frame duration
     * if no telecine is used ...
     *
     * Set to time_base ticks per frame. Default 1, e.g., H.264/MPEG-2 set it to 2.
     *)
    ticks_per_frame: cint;

    (**
     * Codec delay.
     *
     * Encoding: Number of frames delay there will be from the encoder input to
     *           the decoder output. (we assume the decoder matches the spec)
     * Decoding: Number of frames delay in addition to what a standard decoder
     *           as specified in the spec would produce.
     *
     * Video:
     *   Number of frames the decoded output will be delayed relative to the
     *   encoded input.
     *
     * Audio:
     *   For encoding, this field is unused (see initial_padding).
     *
     *   For decoding, this is the number of samples the decoder needs to
     *   output before the decoder's output is valid. When seeking, you should
     *   start decoding this many samples prior to your desired seek point.
     *
     * - encoding: Set by libavcodec.
     * - decoding: Set by libavcodec.
     *)
    delay: cint;

    (* video only *)
    (**
     * picture width / height.
     * - encoding: MUST be set by user.
     * - decoding: May be set by the user before opening the decoder if known e.g.
     *             from the container. Some decoders will require the dimensions
     *             to be set by the caller. During decoding, the decoder may
     *             overwrite those values as required.
     *)
    width, height: cint;

    (**
     * Bitstream width / height, may be different from width/height e.g. when
     * the decoded frame is cropped before being output or lowres is enabled.
     * - encoding: unused
     * - decoding: May be set by the user before opening the decoder if known
     *             e.g. from the container. During decoding, the decoder may
     *             overwrite those values as required.
     *)
    coded_width, coded_height: cint;

    (**
     * the number of pictures in a group of pictures, or 0 for intra_only
     * - encoding: Set by user.
     * - decoding: unused
     *)
    gop_size: cint;

    (**
     * Pixel format, see AV_PIX_FMT_xxx.
     * May be set by the demuxer if known from headers.
     * May be overridden by the decoder if it knows better.
     * - encoding: Set by user.
     * - decoding: Set by user if known, overridden by libavcodec if known
     *)
    pix_fmt: TAVPixelFormat;

    (**
     * Motion estimation algorithm used for video coding.
     * 1 (zero), 2 (full), 3 (log), 4 (phods), 5 (epzs), 6 (x1), 7 (hex),
     * 8 (umh), 9 (iter), 10 (tesa) [7, 8, 10 are x264 specific, 9 is snow specific]
     * - encoding: MUST be set by user.
     * - decoding: unused
     *)
    me_method: cint;

    (**
     * If non NULL, 'draw_horiz_band' is called by the libavcodec
     * decoder to draw a horizontal band. It improves cache usage. Not
     * all codecs can do that. You must check the codec capabilities
     * beforehand.
     * The function is also used by hardware acceleration APIs.
     * It is called at least once during frame decoding to pass
     * the data needed for hardware render.
     * In that mode instead of pixel data, AVFrame points to
     * a structure specific to the acceleration API. The application
     * reads the structure and can change some fields to indicate progress
     * or mark state.
     * - encoding: unused
     * - decoding: Set by user.
     * @param height the height of the slice
     * @param y the y position of the slice
     * @param type 1->top field, 2->bottom field, 3->frame
     * @param offset offset into the AVFrame.data from which the slice should be read
     *)
    draw_horiz_band: procedure (s: PAVCodecContext;
                                src: {const} PAVFrame; offset: pointer{PAVNDPArray};
                                y: cint; type_: cint; height: cint); cdecl;

    (**
     * callback to negotiate the pixelFormat
     * @param fmt is the list of formats which are supported by the codec,
     * it is terminated by -1 as 0 is a valid format, the formats are ordered by quality.
     * The first is always the native one.
     * @note The callback may be called again immediately if initialization for
     * the selected (hardware-accelerated) pixel format failed.
     * @warning Behavior is undefined if the callback returns a value not
     * in the fmt list of formats.
     * @return the chosen format
     * - encoding: unused
     * - decoding: Set by user, if not set the native format will be chosen.
     *)
    get_format: function (s: PAVCodecContext; fmt: {const} PAVPixelFormat): TAVPixelFormat; cdecl;

    (**
     * maximum number of B-frames between non-B-frames
     * Note: The output will be delayed by max_b_frames+1 relative to the input.
     * - encoding: Set by user.
     * - decoding: unused
     *)
    max_b_frames: cint;

    (**
     * qscale factor between IP and B-frames
     * If > 0 then the last P-frame quantizer will be used (q= lastp_q*factor+offset).
     * If < 0 then normal ratecontrol will be done (q= -normal_q*factor+offset).
     * - encoding: Set by user.
     * - decoding: unused
     *)
    b_quant_factor: cfloat;

    (** obsolete FIXME remove *)
    rc_strategy: cint;

    b_frame_strategy: cint;

    (**
     * qscale offset between IP and B-frames
     * - encoding: Set by user.
     * - decoding: unused
     *)
    b_quant_offset: cfloat;

    (**
     * Size of the frame reordering buffer in the decoder.
     * For MPEG-2 it is 1 IPB or 0 low delay IP.
     * - encoding: Set by libavcodec.
     * - decoding: Set by libavcodec.
     *)
    has_b_frames: cint;

    (**
     * 0-> h263 quant 1-> mpeg quant
     * - encoding: Set by user.
     * - decoding: unused
     *)
    mpeg_quant: cint;

    (**
     * qscale factor between P and I-frames
     * If > 0 then the last p frame quantizer will be used (q= lastp_q*factor+offset).
     * If < 0 then normal ratecontrol will be done (q= -normal_q*factor+offset).
     * - encoding: Set by user.
     * - decoding: unused
     *)
    i_quant_factor: cfloat;

    (**
     * qscale offset between P and I-frames
     * - encoding: Set by user.
     * - decoding: unused
     *)
    i_quant_offset: cfloat;

    (**
     * luminance masking (0-> disabled)
     * - encoding: Set by user.
     * - decoding: unused
     *)
    lumi_masking: cfloat;

    (**
     * temporary complexity masking (0-> disabled)
     * - encoding: Set by user.
     * - decoding: unused
     *)
    temporal_cplx_masking: cfloat;

    (**
     * spatial complexity masking (0-> disabled)
     * - encoding: Set by user.
     * - decoding: unused
     *)
    spatial_cplx_masking: cfloat;

    (**
     * p block masking (0-> disabled)
     * - encoding: Set by user.
     * - decoding: unused
     *)
    p_masking: cfloat;

    (**
     * darkness masking (0-> disabled)
     * - encoding: Set by user.
     * - decoding: unused
     *)
    dark_masking: cfloat;

    (**
     * slice count
     * - encoding: Set by libavcodec.
     * - decoding: Set by user (or 0).
     *)
    slice_count: cint;

    (**
     * prediction method (needed for huffyuv)
     * - encoding: Set by user.
     * - decoding: unused
     *)
     prediction_method: cint;

    (**
     * slice offsets in the frame in bytes
     * - encoding: Set/allocated by libavcodec.
     * - decoding: Set/allocated by user (or NULL).
     *)
    slice_offset: PCint;

    (**
     * sample aspect ratio (0 if unknown)
     * That is the width of a pixel divided by the height of the pixel.
     * Numerator and denominator must be relatively prime and smaller than 256 for some video standards.
     * - encoding: Set by user.
     * - decoding: Set by libavcodec.
     *)
    sample_aspect_ratio: TAVRational;

    (**
     * motion estimation comparison function
     * - encoding: Set by user.
     * - decoding: unused
     *)
    me_cmp: cint;

    (**
     * subpixel motion estimation comparison function
     * - encoding: Set by user.
     * - decoding: unused
     *)
    me_sub_cmp: cint;
    (**
     * macroblock comparison function (not supported yet)
     * - encoding: Set by user.
     * - decoding: unused
     *)
    mb_cmp: cint;
    (**
     * interlaced DCT comparison function
     * - encoding: Set by user.
     * - decoding: unused
     *)
    ildct_cmp: cint;

    (**
     * ME diamond size & shape
     * - encoding: Set by user.
     * - decoding: unused
     *)
    dia_size: cint;

    (**
     * amount of previous MV predictors (2a+1 x 2a+1 square)
     * - encoding: Set by user.
     * - decoding: unused
     *)
    last_predictor_count: cint;

    (**
     * prepass for motion estimation
     * - encoding: Set by user.
     * - decoding: unused
     *)
    pre_me: cint;

    (**
     * motion estimation prepass comparison function
     * - encoding: Set by user.
     * - decoding: unused
     *)
    me_pre_cmp: cint;

    (**
     * ME prepass diamond size & shape
     * - encoding: Set by user.
     * - decoding: unused
     *)
    pre_dia_size: cint;

    (**
     * subpel ME quality
     * - encoding: Set by user.
     * - decoding: unused
     *)
    me_subpel_quality: cint;

{$IFDEF FF_API_AFD}
    (**
     * DTG active format information (additional aspect ratio
     * information only used in DVB MPEG-2 transport streams)
     * 0 if not set.
     *
     * - encoding: unused
     * - decoding: Set by decoder.
     * @deprecated Deprecated in favor of AVSideData
     *)
    {attribute_deprecated}
    dtg_active_format: cint;
{$IFEND}

    (**
     * maximum motion estimation search range in subpel units
     * If 0 then no limit.
     *
     * - encoding: Set by user.
     * - decoding: unused
     *)
    me_range: cint;

    (**
     * intra quantizer bias
     * - encoding: Set by user.
     * - decoding: unused
     *)
    intra_quant_bias: cint;

    (**
     * inter quantizer bias
     * - encoding: Set by user.
     * - decoding: unused
     *)
    inter_quant_bias: cint;

    (**
     * slice flags
     * - encoding: unused
     * - decoding: Set by user.
     *)
    slice_flags: cint;

{$IFDEF FF_API_XVMC}
    (**
     * XVideo Motion Acceleration
     * - encoding: forbidden
     * - decoding: set by decoder
     * @deprecated XvMC doesn't need it anymore.
     *)
    xvmc_acceleration: cint;
{$ENDIF}

    (**
     * macroblock decision mode
     * - encoding: Set by user.
     * - decoding: unused
     *)
    mb_decision: cint;

    (**
     * custom intra quantization matrix
     * - encoding: Set by user, can be NULL.
     * - decoding: Set by libavcodec.
     *)
    intra_matrix: PWord;

    (**
     * custom inter quantization matrix
     * - encoding: Set by user, can be NULL.
     * - decoding: Set by libavcodec.
     *)
    inter_matrix: PWord;

    (**
     * scene change detection threshold
     * 0 is default, larger means fewer detected scene changes.
     * - encoding: Set by user.
     * - decoding: unused
     *)
    scenechange_threshold: cint;

    (**
     * noise reduction strength
     * - encoding: Set by user.
     * - decoding: unused
     *)
    noise_reduction: cint;

{$IFDEF FF_API_MPV_OPT}
    (**
     * @deprecated this field is unused
     *)
     {attribute_deprecated}
     me_threshold: cint;

    (**
     * @deprecated this field is unused
     *)
     {attribute_deprecated}
     mb_threshold: cint;
{$ENDIF}
    (**
     * precision of the intra DC coefficient - 8
     * - encoding: Set by user.
     * - decoding: unused
     *)
    intra_dc_precision: cint;

    (**
     * Number of macroblock rows at the top which are skipped.
     * - encoding: unused
     * - decoding: Set by user.
     *)
    skip_top: cint;

    (**
     * Number of macroblock rows at the bottom which are skipped.
     * - encoding: unused
     * - decoding: Set by user.
     *)
    skip_bottom: cint;

{$IFDEF FF_API_MPV_OPT}
    (**
     * @deprecated use encoder private options instead
     *)
    {attribute_deprecated}
    border_masking: cfloat;
{$ENDIF}
    (**
     * minimum MB lagrange multipler
     * - encoding: Set by user.
     * - decoding: unused
     *)
    mb_lmin: cint;

    (**
     * maximum MB lagrange multipler
     * - encoding: Set by user.
     * - decoding: unused
     *)
    mb_lmax: cint;

    (**
     *
     * - encoding: Set by user.
     * - decoding: unused
     *)
    me_penalty_compensation: cint;

    (**
     *
     * - encoding: Set by user.
     * - decoding: unused
     *)
    bidir_refine: cint;

    (**
     *
     * - encoding: Set by user.
     * - decoding: unused
     *)
    brd_scale: cint;

    (**
     * minimum GOP size
     * - encoding: Set by user.
     * - decoding: unused
     *)
    keyint_min: cint;

    (**
     * number of reference frames
     * - encoding: Set by user.
     * - decoding: Set by lavc.
     *)
    refs: cint;

    (**
     * chroma qp offset from luma
     * - encoding: Set by user.
     * - decoding: unused
     *)
    chromaoffset: cint;

{$IFDEF FF_API_UNUSED_MEMBERS}
    (**
     * Multiplied by qscale for each frame and added to scene_change_score.
     * - encoding: Set by user.
     * - decoding: unused
     *)
    scenechange_factor: cint; {attribute_deprecated}
{$IFEND}

    (**
     *
     * Note: Value depends upon the compare function used for fullpel ME.
     * - encoding: Set by user.
     * - decoding: unused
     *)
    mv0_threshold: cint;

    (**
     * Adjust sensitivity of b_frame_strategy 1.
     * - encoding: Set by user.
     * - decoding: unused
     *)
    b_sensitivity: cint;

    (**
     * Chromaticity coordinates of the source primaries.
     * - encoding: Set by user
     * - decoding: Set by libavcodec
     *)
    color_primaries: cint;

    (**
     * Color Transfer Characteristic.
     * - encoding: Set by user
     * - decoding: Set by libavcodec
     *)
    color_trc: cint;

    (**
     * YUV colorspace type.
     * - encoding: Set by user
     * - decoding: Set by libavcodec
     *)
    colorspace: cint;

    (**
     * MPEG vs JPEG YUV range.
     * - encoding: Set by user
     * - decoding: Set by libavcodec
     *)
    color_range: cint;

    (**
     * This defines the location of chroma samples.
     * - encoding: Set by user
     * - decoding: Set by libavcodec
     *)
     chroma_sample_location: cint;

    (**
     * Number of slices.
     * Indicates number of picture subdivisions. Used for parallelized
     * decoding.
     * - encoding: Set by user
     * - decoding: unused
     *)
    slices: cint;

    (** Field order
     * - encoding: set by libavcodec
     * - decoding: Set by user.
     *)
    field_order: cint;

    (* audio only *)
    sample_rate: cint; ///< samples per second
    channels: cint;    ///< number of audio channels

    (**
     * audio sample format
     * - encoding: Set by user.
     * - decoding: Set by libavcodec.
     *)
    sample_fmt: cint;  ///< sample format

    (* The following data should not be initialized. *)
    (**
     * Number of samples per channel in an audio frame.
     *
     * - encoding: set by libavcodec in avcodec_open2(). Each submitted frame
     *   except the last must contain exactly frame_size samples per channel.
     *   May be 0 when the codec has CODEC_CAP_VARIABLE_FRAME_SIZE set, then the
     *   frame size is not restricted.
     * - decoding: may be set by some decoders to indicate constant frame size
     *)
    frame_size: cint;

    (**
     * Frame counter, set by libavcodec.
     *
     * - decoding: total number of frames returned from the decoder so far.
     * - encoding: total number of frames passed to the encoder so far.
     *
     *   @note the counter is not incremented if encoding/decoding resulted in
     *   an error.
     *)
    frame_number: cint;   ///< audio or video frame number

    (**
     * number of bytes per packet if constant and known or 0
     * Used by some WAV based audio codecs.
     *)
    block_align: cint;

    (**
     * Audio cutoff bandwidth (0 means "automatic")
     * - encoding: Set by user.
     * - decoding: unused
     *)
    cutoff: cint;

{$IFDEF FF_API_REQUEST_CHANNELS}
    (**
     * Decoder should decode to this many channels if it can (0 for default)
     * - encoding: unused
     * - decoding: Set by user.
     * @deprecated Deprecated in favor of request_channel_layout.
     *)
    request_channels: cint; {deprecated}
{$IFEND}

    (**
     * Audio channel layout.
     * - encoding: set by user.
     * - decoding: set by user, may be overwritten by libavcodec.
     *)
    channel_layout: cuint64;

    (**
     * Request decoder to use this channel layout if it can (0 for default)
     * - encoding: unused
     * - decoding: Set by user.
     *)
    request_channel_layout: cuint64;

    (**
     * Type of service that the audio stream conveys.
     * - encoding: Set by user.
     * - decoding: Set by libavcodec.
     *)
    audio_service_type: cint;

    (**
     * desired sample format
     * - encoding: Not used.
     * - decoding: Set by user.
     * Decoder will decode to this format if it can.
     *)
    request_sample_fmt: cint;

{$IFDEF FF_API_GET_BUFFER}
    (**
     * Called at the beginning of each frame to get a buffer for it.
     *
     * The function will set AVFrame.data[], AVFrame.linesize[].
     * AVFrame.extended_data[] must also be set, but it should be the same as
     * AVFrame.data[] except for planar audio with more channels than can fit
     * in AVFrame.data[]. In that case, AVFrame.data[] shall still contain as
     * many data pointers as it can hold.
     *
     * if CODEC_CAP_DR1 is not set then get_buffer() must call
     * avcodec_default_get_buffer() instead of providing buffers allocated by
     * some other means.
     *
     * AVFrame.data[] should be 32- or 16-byte-aligned unless the CPU doesn't
     * need it. avcodec_default_get_buffer() aligns the output buffer properly,
     * but if get_buffer() is overridden then alignment considerations should
     * be taken into account.
     *
     * @see avcodec_default_get_buffer()
     *
     * Video:
     *
     * If pic.reference is set then the frame will be read later by libavcodec.
     * avcodec_align_dimensions2() should be used to find the required width and
     * height, as they normally need to be rounded up to the next multiple of 16.
     *
     * If frame multithreading is used and thread_safe_callbacks is set,
     * it may be called from a different thread, but not from more than one at
     * once. Does not need to be reentrant.
     *
     * @see release_buffer(), reget_buffer()
     * @see avcodec_align_dimensions2()
     *
     * Audio:
     *
     * Decoders request a buffer of a particular size by setting
     * AVFrame.nb_samples prior to calling get_buffer(). The decoder may,
     * however, utilize only part of the buffer by setting AVFrame.nb_samples
     * to a smaller value in the output frame.
     *
     * Decoders cannot use the buffer after returning from
     * avcodec_decode_audio4(), so they will not call release_buffer(), as it
     * is assumed to be released immediately upon return. In some rare cases,
     * a decoder may need to call get_buffer() more than once in a single
     * call to avcodec_decode_audio4(). In that case, when get_buffer() is
     * called again after it has already been called once, the previously
     * acquired buffer is assumed to be released at that time and may not be
     * reused by the decoder.
     *
     * As a convenience, av_samples_get_buffer_size() and
     * av_samples_fill_arrays() in libavutil may be used by custom get_buffer()
     * functions to find the required data size and to fill data pointers and
     * linesize. In AVFrame.linesize, only linesize[0] may be set for audio
     * since all planes must be the same size.
     *
     * @see av_samples_get_buffer_size(), av_samples_fill_arrays()
     *
     * - encoding: unused
     * - decoding: Set by libavcodec, user can override.
     *
     * @deprecated use get_buffer2()
     *)
    get_buffer: function (c: PAVCodecContext; pic: PAVFrame): cint; cdecl; {deprecated;}

    (**
     * Called to release buffers which were allocated with get_buffer.
     * A released buffer can be reused in get_buffer().
     * pic.data[*] must be set to NULL.
     * - encoding: unused
     * - decoding: Set by libavcodec, user can override.
     *
     * @deprecated custom freeing callbacks should be set from get_buffer2()
     *)
    release_buffer: procedure (c: PAVCodecContext; pic: PAVFrame); cdecl; {deprecated;}

    (**
     * Called at the beginning of a frame to get cr buffer for it.
     * Buffer type (size, hints) must be the same. libavcodec won't check it.
     * libavcodec will pass previous buffer in pic, function should return
     * same buffer or new buffer with old frame "painted" into it.
     * If pic.data[0] == NULL must behave like get_buffer().
     * if CODEC_CAP_DR1 is not set then reget_buffer() must call
     * avcodec_default_reget_buffer() instead of providing buffers allocated by
     * some other means.
     * - encoding: unused
     * - decoding: Set by libavcodec, user can override
     *)
    reget_buffer: function (c: PAVCodecContext; pic: PAVFrame): cint; cdecl; {deprecated;}
{$ENDIF}

    (**
     * This callback is called at the beginning of each frame to get data
     * buffer(s) for it. There may be one contiguous buffer for all the data or
     * there may be a buffer per each data plane or anything in between. What
     * this means is, you may set however many entries in buf[] you feel necessary.
     * Each buffer must be reference-counted using the AVBuffer API (see description
     * of buf[] below).
     *
     * The following fields will be set in the frame before this callback is
     * called:
     * - format
     * - width, height (video only)
     * - sample_rate, channel_layout, nb_samples (audio only)
     * Their values may differ from the corresponding values in
     * AVCodecContext. This callback must use the frame values, not the codec
     * context values, to calculate the required buffer size.
     *
     * This callback must fill the following fields in the frame:
     * - data[]
     * - linesize[]
     * - extended_data:
     *   * if the data is planar audio with more than 8 channels, then this
     *     callback must allocate and fill extended_data to contain all pointers
     *     to all data planes. data[] must hold as many pointers as it can.
     *     extended_data must be allocated with av_malloc() and will be freed in
     *     av_frame_unref().
     *   * otherwise exended_data must point to data
     * - buf[] must contain one or more pointers to AVBufferRef structures. Each of
     *   the frame's data and extended_data pointers must be contained in these. That
     *   is, one AVBufferRef for each allocated chunk of memory, not necessarily one
     *   AVBufferRef per data[] entry. See: av_buffer_create(), av_buffer_alloc(),
     *   and av_buffer_ref().
     * - extended_buf and nb_extended_buf must be allocated with av_malloc() by
     *   this callback and filled with the extra buffers if there are more
     *   buffers than buf[] can hold. extended_buf will be freed in
     *   av_frame_unref().
     *
     * If CODEC_CAP_DR1 is not set then get_buffer2() must call
     * avcodec_default_get_buffer2() instead of providing buffers allocated by
     * some other means.
     *
     * Each data plane must be aligned to the maximum required by the target
     * CPU.
     *
     * @see avcodec_default_get_buffer2()
     *
     * Video:
     *
     * If AV_GET_BUFFER_FLAG_REF is set in flags then the frame may be reused
     * (read and/or written to if it is writable) later by libavcodec.
     *
     * avcodec_align_dimensions2() should be used to find the required width and
     * height, as they normally need to be rounded up to the next multiple of 16.
     *
     * Some decoders do not support linesizes changing between frames.
     *
     * If frame multithreading is used and thread_safe_callbacks is set,
     * this callback may be called from a different thread, but not from more
     * than one at once. Does not need to be reentrant.
     *
     * @see avcodec_align_dimensions2()
     *
     * Audio:
     *
     * Decoders request a buffer of a particular size by setting
     * AVFrame.nb_samples prior to calling get_buffer2(). The decoder may,
     * however, utilize only part of the buffer by setting AVFrame.nb_samples
     * to a smaller value in the output frame.
     *
     * As a convenience, av_samples_get_buffer_size() and
     * av_samples_fill_arrays() in libavutil may be used by custom get_buffer2()
     * functions to find the required data size and to fill data pointers and
     * linesize. In AVFrame.linesize, only linesize[0] may be set for audio
     * since all planes must be the same size.
     *
     * @see av_samples_get_buffer_size(), av_samples_fill_arrays()
     *
     * - encoding: unused
     * - decoding: Set by libavcodec, user can override.
     *)
    get_buffer2: function (s: PAVCodecContext; frame: PAVFrame; flags: cint): cint; cdecl;

    (**
     * If non-zero, the decoded audio and video frames returned from
     * avcodec_decode_video2() and avcodec_decode_audio4() are reference-counted
     * and are valid indefinitely. The caller must free them with
     * av_frame_unref() when they are not needed anymore.
     * Otherwise, the decoded frames must not be freed by the caller and are
     * only valid until the next decode call.
     *
     * - encoding: unused
     * - decoding: set by the caller before avcodec_open2().
     *)
    refcounted_frames: cint;

    (* - encoding parameters *)
    qcompress: cfloat;  ///< amount of qscale change between easy & hard scenes (0.0-1.0)
    qblur: cfloat;      ///< amount of qscale smoothing over time (0.0-1.0)

    (**
     * minimum quantizer
     * - encoding: Set by user.
     * - decoding: unused
     *)
    qmin: cint;

   (**
     * maximum quantizer
     * - encoding: Set by user.
     * - decoding: unused
     *)
   qmax: cint;

    (**
     * maximum quantizer difference between frames
     * - encoding: Set by user.
     * - decoding: unused
     *)
    max_qdiff: cint;
{$IFDEF FF_API_MPV_OPT}
    (**
     * @deprecated use encoder private options instead
     *)
    {attribute_deprecated}
    rc_qsquish: cfloat;

    {attribute_deprecated}
    rc_qmod_amp: cfloat;
    {attribute_deprecated}
    rc_qmod_freq: cint;
{$ENDIF}
    (**
     * decoder bitstream buffer size
     * - encoding: Set by user.
     * - decoding: unused
     *)
    rc_buffer_size: cint;
    (**
     * ratecontrol override, see RcOverride
     * - encoding: Allocated/set/freed by user.
     * - decoding: unused
     *)
    rc_override_count: cint;
    rc_override: Pointer;//PRcOverride;
{$IFDEF FF_API_MPV_OPT}
    (**
     * @deprecated use encoder private options instead
     *)
    {attribute_deprecated}
    rc_eq: {const} PAnsiChar;
{$ENDIF}
    (**
     * maximum bitrate
     * - encoding: Set by user.
     * - decoding: Set by libavcodec.
     *)
    rc_max_rate: cint;

    (**
     * minimum bitrate
     * - encoding: Set by user.
     * - decoding: unused
     *)
    rc_min_rate: cint;

{$IFDEF FF_API_MPV_OPT}

    (**
     * @deprecated use encoder private options instead
     *)
    {attribute_deprecated}
    rc_buffer_aggressivity: cfloat;

    {attribute_deprecated}
    rc_initial_cplx: cfloat;
{$ENDIF}
    (**
     * Ratecontrol attempt to use, at maximum, <value> of what can be used without an underflow.
     * - encoding: Set by user.
     * - decoding: unused.
     *)
    rc_max_available_vbv_use: cfloat;

    (**
     * Ratecontrol attempt to use, at least, <value> times the amount needed to prevent a vbv overflow.
     * - encoding: Set by user.
     * - decoding: unused.
     *)
    rc_min_vbv_overflow_use: cfloat;

    (**
     * Number of bits which should be loaded into the rc buffer before decoding starts.
     * - encoding: Set by user.
     * - decoding: unused
     *)
    rc_initial_buffer_occupancy: cint;

    (**
     * coder type
     * - encoding: Set by user.
     * - decoding: unused
     *)
    coder_type: cint;

    (**
     * context model
     * - encoding: Set by user.
     * - decoding: unused
     *)
    context_model: cint;

{$IFDEF FF_API_MPV_OPT}
    (**
     * @deprecated use encoder private options instead
     *)
    {attribute_deprecated}
    lmin: cint;

    (**
     * @deprecated use encoder private options instead
     *)
    {attribute_deprecated}
    lmax: cint;
{$ENDIF}
    (**
     * frame skip threshold
     * - encoding: Set by user.
     * - decoding: unused
     *)
    frame_skip_threshold: cint;

    (**
     * frame skip factor
     * - encoding: Set by user.
     * - decoding: unused
     *)
    frame_skip_factor: cint;

    (**
     * frame skip exponent
     * - encoding: Set by user.
     * - decoding: unused
     *)
    frame_skip_exp: cint;

    (**
     * frame skip comparison function
     * - encoding: Set by user.
     * - decoding: unused
     *)
    frame_skip_cmp: cint;

    (**
     * trellis RD quantization
     * - encoding: Set by user.
     * - decoding: unused
     *)
    trellis: cint;

    (**
     * - encoding: Set by user.
     * - decoding: unused
     *)
    min_prediction_order: cint;

    (**
     * - encoding: Set by user.
     * - decoding: unused
     *)
    max_prediction_order: cint;

    (**
     * GOP timecode frame start number, in non drop frame format
     * - encoding: Set by user, in non drop frame format
     * - decoding: Set by libavcodec (timecode in the 25 bits format, -1 if unset)
     *)
    timecode_frame_start: cint64;

    (* The RTP callback: This function is called   *)
    (* every time the encoder has a packet to send *)
    (* Depends on the encoder if the data starts   *)
    (* with a Start Code (it should) H.263 does.   *)
    (* mb_nb contains the number of macroblocks    *)
    (* encoded in the RTP payload                  *)
    rtp_callback: procedure (avctx: PAVCodecContext; data: pointer;
                             size: cint; mb_nb: cint); cdecl;

    rtp_payload_size: cint;     (* The size of the RTP payload: the coder will  *)
                                (* do it's best to deliver a chunk with size    *)
                                (* below rtp_payload_size, the chunk will start *)
                                (* with a start code on some codecs like H.263  *)
                                (* This doesn't take account of any particular  *)
                                (* headers inside the transmited RTP payload    *)

    (* statistics, used for 2-pass encoding *)
    mv_bits: cint;
    header_bits: cint;
    i_tex_bits: cint;
    p_tex_bits: cint;
    i_count: cint;
    p_count: cint;
    skip_count: cint;
    misc_bits: cint;

    (**
     * number of bits used for the previously encoded frame
     * - encoding: Set by libavcodec.
     * - decoding: unused
     *)
    frame_bits: cint;

    (**
     * pass1 encoding statistics output buffer
     * - encoding: Set by libavcodec.
     * - decoding: unused
     *)
    stats_out: PAnsiChar;

    (**
     * pass2 encoding statistics input buffer
     * Concatenated stuff from stats_out of pass1 should be placed here.
     * - encoding: Allocated/set/freed by user.
     * - decoding: unused
     *)
    stats_in: PAnsiChar;

    (**
     * Work around bugs in encoders which sometimes cannot be detected automatically.
     * - encoding: Set by user
     * - decoding: Set by user
     *)
    workaround_bugs: cint;

    (**
     * strictly follow the standard (MPEG4, ...).
     * - encoding: Set by user.
     * - decoding: Set by user.
     * Setting this to STRICT or higher means the encoder and decoder will
     * generally do stupid things, whereas setting it to unofficial or lower
     * will mean the encoder might produce output that is not supported by all
     * spec-compliant decoders. Decoders don't differentiate between normal,
     * unofficial and experimental (that is, they always try to decode things
     * when they can) unless they are explicitly asked to behave stupidly
     * (=strictly conform to the specs)
     *)
    strict_std_compliance: cint;

    (**
     * error concealment flags
     * - encoding: unused
     * - decoding: Set by user.
     *)
    error_concealment: cint;

    (**
     * debug
     * Code outside libavcodec should access this field using AVOptions
     * - encoding: Set by user.
     * - decoding: Set by user.
     *)
    debug: cint;

{$IFDEF FF_API_DEBUG_MV}
    (**
     * debug
     * - encoding: Set by user.
     * - decoding: Set by user.
     *)
    debug_mv: cint;
{$ENDIF}

    (**
     * Error recognition; may misdetect some more or less valid parts as errors.
     * - encoding: unused
     * - decoding: Set by user.
     *)
    err_recognition: cint;

    (**
     * opaque 64bit number (generally a PTS) that will be reordered and
     * output in AVFrame.reordered_opaque
     * - encoding: unused
     * - decoding: Set by user.
     *)
    reordered_opaque: cint64;

    (**
     * Hardware accelerator in use
     * - encoding: unused.
     * - decoding: Set by libavcodec
     *)
    hwaccel: pointer;//PAVHWAccel;

    (**
     * Hardware accelerator context.
     * For some hardware accelerators, a global context needs to be
     * provided by the user. In that case, this holds display-dependent
     * data FFmpeg cannot instantiate itself. Please refer to the
     * FFmpeg HW accelerator documentation to know how to fill this
     * is. e.g. for VA API, this is a struct vaapi_context.
     * - encoding: unused
     * - decoding: Set by user
     *)
    hwaccel_context: pointer;

    (**
     * error
     * - encoding: Set by libavcodec if flags&CODEC_FLAG_PSNR.
     * - decoding: unused
     *)
    error: array [0..AV_NUM_DATA_POINTERS - 1] of cuint64;

    (**
     * DCT algorithm, see FF_DCT_* below
     * - encoding: Set by user.
     * - decoding: unused
     *)
    dct_algo: cint;

    (**
     * IDCT algorithm, see FF_IDCT_* below.
     * - encoding: Set by user.
     * - decoding: Set by user.
     *)
    idct_algo: cint;

    (**
     * bits per sample/pixel from the demuxer (needed for huffyuv).
     * - encoding: Set by libavcodec.
     * - decoding: Set by user.
     *)
    bits_per_coded_sample: cint;

    (**
     * Bits per sample/pixel of internal libavcodec pixel/sample format.
     * - encoding: set by user.
     * - decoding: set by libavcodec.
     *)
    bits_per_raw_sample: cint;

{$IFDEF FF_API_LOWRES}
    (**
     * low resolution decoding, 1-> 1/2 size, 2->1/4 size
     * - encoding: unused
     * - decoding: Set by user.
     * Code outside libavcodec should access this field using:
     * av_codec_{get,set}_lowres(avctx)
     *)
    lowres: cint;
{$ENDIF}

    (**
     * the picture in the bitstream
     * - encoding: Set by libavcodec.
     * - decoding: unused
     *)
    coded_frame: PAVFrame;

    (**
     * thread count
     * is used to decide how many independent tasks should be passed to execute()
     * - encoding: Set by user.
     * - decoding: Set by user.
     *)
    thread_count: cint;

    (**
     * Which multithreading methods to use.
     * Use of FF_THREAD_FRAME will increase decoding delay by one frame per thread,
     * so clients which cannot provide future frames should not use it.
     *
     * - encoding: Set by user, otherwise the default is used.
     * - decoding: Set by user, otherwise the default is used.
     *)
    thread_type: cint;

    (**
     * Which multithreading methods are in use by the codec.
     * - encoding: Set by libavcodec.
     * - decoding: Set by libavcodec.
     *)
    active_thread_type: cint;

    (**
     * Set by the client if its custom get_buffer() callback can be called
     * from another thread, which allows faster multithreaded decoding.
     * draw_horiz_band() will be called from other threads regardless of this setting.
     * Ignored if the default get_buffer() is used.
     * - encoding: Set by user.
     * - decoding: Set by user.
     *)
    thread_safe_callbacks: cint;

    (**
     * The codec may call this to execute several independent things.
     * It will return only after finishing all tasks.
     * The user may replace this with some multithreaded implementation,
     * the default implementation will execute the parts serially.
     * @param count the number of things to execute
     * - encoding: Set by libavcodec, user can override.
     * - decoding: Set by libavcodec, user can override.
     *)
    execute: function (c: PAVCodecContext; func: TExecuteFunc; arg: Pointer; ret: PCint; count: cint; size: cint): cint; cdecl;

    (**
     * The codec may call this to execute several independent things.
     * It will return only after finishing all tasks.
     * The user may replace this with some multithreaded implementation,
     * the default implementation will execute the parts serially.
     * Also see avcodec_thread_init and e.g. the --enable-pthread configure option.
     * @param c context passed also to func
     * @param count the number of things to execute
     * @param arg2 argument passed unchanged to func
     * @param ret return values of executed functions, must have space for "count" values. May be NULL.
     * @param func function that will be called count times, with jobnr from 0 to count-1.
     *             threadnr will be in the range 0 to c->thread_count-1 < MAX_THREADS and so that no
     *             two instances of func executing at the same time will have the same threadnr.
     * @return always 0 currently, but code should handle a future improvement where when any call to func
     *         returns < 0 no further calls to func may be done and < 0 is returned.
     * - encoding: Set by libavcodec, user can override.
     * - decoding: Set by libavcodec, user can override.
     *)
      execute2: function (c: PAVCodecContext; func: TExecute2Func; arg2: Pointer; ret: Pcint; count: cint): cint; cdecl;

{$IFDEF FF_API_THREAD_OPAQUE}
    (**
     * @deprecated this field should not be used from outside of lavc
     *)
    thread_opaque: pointer;
{$ENDIF}

    (**
     * noise vs. sse weight for the nsse comparison function
     * - encoding: Set by user.
     * - decoding: unused
     *)
    nsse_weight: cint;

    (**
     * profile
     * - encoding: Set by user.
     * - decoding: Set by libavcodec.
     *)
    profile: cint;

    (**
     * level
     * - encoding: Set by user.
     * - decoding: Set by libavcodec.
     *)
    level: cint;

    (**
     * Skip loop filtering for selected frames.
     * - encoding: unused
     * - decoding: Set by user.
     *)
    skip_loop_filter: cint;

    (**
     * Skip IDCT/dequantization for selected frames.
     * - encoding: unused
     * - decoding: Set by user.
     *)
    skip_idct: cint;

    (**
     * Skip decoding for selected frames.
     * - encoding: unused
     * - decoding: Set by user.
     *)
    skip_frame: cint;

    (**
     * Header containing style information for text subtitles.
     * For SUBTITLE_ASS subtitle type, it should contain the whole ASS
     * [Script Info] and [V4+ Styles] section, plus the [Events] line and
     * the Format line following. It shouldn't include any Dialogue line.
     * - encoding: Set/allocated/freed by user (before avcodec_open2())
     * - decoding: Set/allocated/freed by libavcodec (by avcodec_open2())
     *)
    subtitle_header: Pcuint8;
    subtitle_header_size: cint;

{$IFDEF FF_API_ERROR_RATE}
    (**
     * @deprecated use the 'error_rate' private AVOption of the mpegvideo
     * encoders
     *)
    error_rate: cint;
{$ENDIF}

{$IFDEF FF_API_CODEC_PKT}
    (**
     * @deprecated this field is not supposed to be accessed from outside lavc
     *)
    pkt: PAVPacket;
{$ENDIF}

    (**
     * VBV delay coded in the last frame (in periods of a 27 MHz clock).
     * Used for compliant TS muxing.
     * - encoding: Set by libavcodec.
     * - decoding: unused.
     *)
    vbv_delay: cuint64;

    (**
     * Encoding only. Allow encoders to output packets that do not contain any
     * encoded data, only side data.
     *
     * Some encoders need to output such packets, e.g. to update some stream
     * parameters at the end of encoding.
     *
     * All callers are strongly recommended to set this option to 1 and update
     * their code to deal with such packets, since this behaviour may become
     * always enabled in the future (then this option will be deprecated and
     * later removed). To avoid ABI issues when this happens, the callers should
     * use AVOptions to set this field.
     *)
    side_data_only_packets: cint;

    (**
     * Audio only. The number of "priming" samples (padding) inserted by the
     * encoder at the beginning of the audio. I.e. this number of leading
     * decoded samples must be discarded by the caller to get the original audio
     * without leading padding.
     *
     * - decoding: unused
     * - encoding: Set by libavcodec. The timestamps on the output packets are
     *             adjusted by the encoder so that they always refer to the
     *             first sample of the data actually contained in the packet,
     *             including any added padding.  E.g. if the timebase is
     *             1/samplerate and the timestamp of the first input sample is
     *             0, the timestamp of the first output packet will be
     *             -initial_padding.
     *)
    initial_padding: cint;

    (**
     * - decoding: For codecs that store a framerate value in the compressed
     *             bitstream, the decoder may export it here. { 0, 1} when
     *             unknown.
     * - encoding: unused
     *)
    framerate: TAVRational;

    (**
     * Timebase in which pkt_dts/pts and AVPacket.dts/pts are.
     * Code outside libavcodec should access this field using:
     * av_codec_{get,set}_pkt_timebase(avctx)
     * - encoding unused.
     * - decoding set by user
     *)
    pkt_timebase: TAVRational;

    (**
     * AVCodecDescriptor
     * Code outside libavcodec should access this field using:
     * av_codec_{get,set}_codec_descriptor(avctx)
     * - encoding: unused.
     * - decoding: set by libavcodec.
     *)
    codec_descriptor: pointer;//PAVCodecDescriptor;

{$IFNDEF FF_API_LOWRES}
    (**
     * low resolution decoding, 1-> 1/2 size, 2->1/4 size
     * - encoding: unused
     * - decoding: Set by user.
     * Code outside libavcodec should access this field using:
     * av_codec_{get,set}_lowres(avctx)
     *)
    lowres: cint;
{$ENDIF}

    (**
     * Current statistics for PTS correction.
     * - decoding: maintained and used by libavcodec, not intended to be used by user apps
     * - encoding: unused
     *)
    pts_correction_num_faulty_pts: cint64; /// Number of incorrect PTS values so far
    pts_correction_num_faulty_dts: cint64; /// Number of incorrect DTS values so far
    pts_correction_last_pts: cint64;       /// PTS of the last frame
    pts_correction_last_dts: cint64;       /// DTS of the last frame

    (**
     * Character encoding of the input subtitles file.
     * - decoding: set by user
     * - encoding: unused
     *)
    sub_charenc: PAnsiChar;

    (**
     * Subtitles character encoding mode. Formats or codecs might be adjusting
     * this setting (if they are doing the conversion themselves for instance).
     * - decoding: set by libavcodec
     * - encoding: unused
     *)
    sub_charenc_mode: cint;

    (**
     * Skip processing alpha if supported by codec.
     * Note that if the format uses pre-multiplied alpha (common with VP6,
     * and recommended due to better video quality/compression)
     * the image will look as if alpha-blended onto a black background.
     * However for formats that do not use pre-multiplied alpha
     * there might be serious artefacts (though e.g. libswscale currently
     * assumes pre-multiplied alpha anyway).
     * Code outside libavcodec should access this field using AVOptions
     *
     * - decoding: set by user
     * - encoding: unused
     *)
    skip_alpha: cint;

    (**
     * Number of samples to skip after a discontinuity
     * - decoding: unused
     * - encoding: set by libavcodec
     *)
    seek_preroll: cint;

{$IFNDEF FF_API_DEBUG_MV}
    (**
     * debug motion vectors
     * Code outside libavcodec should access this field using AVOptions
     * - encoding: Set by user.
     * - decoding: Set by user.
     *)
    debug_mv: cint;
{$ENDIF}

    (**
     * custom intra quantization matrix
     * Code outside libavcodec should access this field using av_codec_g/set_chroma_intra_matrix()
     * - encoding: Set by user, can be NULL.
     * - decoding: unused.
     *)
    chroma_intra_matrix: PWord;

    (**
     * dump format separator.
     * can be ", " or "\n      " or anything else
     * Code outside libavcodec should access this field using AVOptions
     * (NO direct access).
     * - encoding: Set by user.
     * - decoding: Set by user.
     *)
    dump_separator: Pcuint8;

    (**
     * ',' separated list of allowed decoders.
     * If NULL then all are allowed
     * - encoding: unused
     * - decoding: set by user through AVOPtions (NO direct access)
     *)
    codec_whitelist: PAnsiChar;
  end; {TAVCodecContext}



  PPAVFormatContext = ^PAVFormatContext;
  PAVFormatContext = ^TAVFormatContext;
  TAVFormatContext = record
    av_class: Pointer;//PAVClass;
    iformat: Pointer;//PAVInputFormat;
    oformat: Pointer;//PAVOutputFormat;
    priv_data: pointer;
    pb: PAVIOContext;
    ctx_flags: cint;
    nb_streams: cuint;
    streams: Pointer;//PPAVStream;
    filename: array [0..1023] of AnsiChar; (* input or output filename *)
    start_time: cint64;
    duration: cint64;
    bit_rate: cint;
    packet_size: cuint;
    max_delay: cint;
    flags: cint;
    probesize: cuint;
    max_analyze_duration: cint;
    key: pbyte;
    keylen: cint;
    nb_programs: cuint;
    programs: Pointer;//PPAVProgram;
    video_codec_id: TAVCodecID;
    audio_codec_id: TAVCodecID;
    subtitle_codec_id: TAVCodecID;
    max_index_size: cuint;
    max_picture_buffer: cuint;
    nb_chapters: cuint;
    chapters: Pointer;//PAVChapterArray;
    metadata: Pointer;//PAVDictionary;
    start_time_realtime: cint64;
    fps_probe_size: cint;
    error_recognition: cint;
    interrupt_callback: TAVIOInterruptCB;
    debug: cint;
    max_interleave_delta: cint64;
    strict_std_compliance: cint;
    event_flags: cint;
    max_ts_probe: cint;
    avoid_negative_ts: cint;
    ts_id: cint;
    audio_preload: cint;
    max_chunk_duration: cint;
    max_chunk_size: cint;
    use_wallclock_as_timestamps: cint;
    avio_flags: cint;
    duration_estimation_method: TAVDurationEstimationMethod;
    skip_initial_bytes: cint64;
    correct_ts_overflow: cuint;
    seek2any: cint;
    flush_packets: cint;
    probe_score: cint;
    format_probesize: cint;
    codec_whitelist: PAnsiChar;
    format_whitelist: PAnsiChar;
    packet_buffer: Pointer;//PAVPacketList;
    packet_buffer_end_: Pointer;//PAVPacketList;
    data_offset: cint64; (**< offset of the first packet *)
    raw_packet_buffer_: Pointer;//PAVPacketList;
    raw_packet_buffer_end_: Pointer;//PAVPacketList;
    parse_queue: Pointer;//PAVPacketList;
    parse_queue_end: Pointer;//PAVPacketList;
    raw_packet_buffer_remaining_size: cint;
    offset: cint64;
    offset_timebase: TAVRational;
    internal: Pointer;//PAVFormatInternal;
    io_repositioned: cint;
    video_codec: Pointer;//PAVCodec;
    audio_codec: Pointer;//PAVCodec;
    subtitle_codec: Pointer;//PAVCodec;
    metadata_header_padding: cint;
    opaque: pointer;
    control_message_cb: TAv_format_control_message;
    output_ts_offset: cint64;
    max_analyze_duration2: cint64;
    probesize2: cint64;
    dump_separator: Pcuint8;
  end; (** TAVFormatContext **)

  PPSwrContext = ^PSwrContext;
  PSwrContext = ^TSwrContext;
  TSwrContext = record
  end;

  TAVFrame = record
    (**
     * pointer to the picture/channel planes.
     * This might be different from the first allocated byte
     *
     * Some decoders access areas outside 0,0 - width,height, please
     * see avcodec_align_dimensions2(). Some filters and swscale can read
     * up to 16 bytes beyond the planes, if these filters are to be used,
     * then 16 extra bytes must be allocated.
     *)
    data: array [0..AV_NUM_DATA_POINTERS - 1] of pbyte;

    (**
     * For video, size in bytes of each picture line.
     * For audio, size in bytes of each plane.
     *
     * For audio, only linesize[0] may be set. For planar audio, each channel
     * plane must be the same size.
     *
     * For video the linesizes should be multiples of the CPUs alignment
     * preference, this is 16 or 32 for modern desktop CPUs.
     * Some code requires such alignment other code can be slower without
     * correct alignment, for yet other it makes no difference.
     *
     * @note The linesize may be larger than the size of usable data -- there
     * may be extra padding present for performance reasons.
     *)
    linesize: array [0..AV_NUM_DATA_POINTERS - 1] of cint;

    (**
     * pointers to the data planes/channels.
     *
     * For video, this should simply point to data[].
     *
     * For planar audio, each channel has a separate data pointer, and
     * linesize[0] contains the size of each channel buffer.
     * For packed audio, there is just one data pointer, and linesize[0]
     * contains the total size of the buffer for all channels.
     *
     * Note: Both data and extended_data will always be set by get_buffer(),
     * but for planar audio with more channels that can fit in data,
     * extended_data must be used in order to access all channels.
     *)
    extended_data: ^pbyte;

    (**
     * width and height of the video frame
     *)
    width, height: cint;
    (**
     * number of audio samples (per channel) described by this frame
     *)
    nb_samples: cint;

    (**
     * format of the frame, -1 if unknown or unset
     * Values correspond to enum AVPixelFormat for video frames,
     * enum AVSampleFormat for audio)
     *)
    format: cint;

    (**
     * 1 -> keyframe, 0-> not
     *)
    key_frame: cint;

    (**
     * Picture type of the frame
     *)
    pict_type: cint;

{$IFDEF FF_API_AVFRAME_LAVC}
    //base: array [0..AV_NUM_DATA_POINTERS - 1] of pbyte; {deprecated}
{$ENDIF}

    (**
     * sample aspect ratio for the video frame, 0/1 if unknown/unspecified
     *)
    sample_aspect_ratio: TAVRational;

    (**
     * presentation timestamp in time_base units (time when frame should be shown to user)
     *)
    pts: cint64;

    (**
     * pts copied from the AVPacket that was decoded to produce this frame
     *)
    pkt_pts: cint64;

    (**
     * DTS copied from the AVPacket that triggered returning this frame. (if frame threading isn't used)
     * This is also the Presentation time of this AVFrame calculated from
     * only AVPacket.dts values without pts values.
     *)
    pkt_dts: cint64;

    (**
     * picture number in bitstream order
     *)
    coded_picture_number: cint;

    (**
     * picture number in display order
     *)
    display_picture_number: cint;

    (**
     * quality (between 1 (good) and FF_LAMBDA_MAX (bad))
     *)
    quality: cint;

{$IFDEF FF_API_AVFRAME_LAVC}
    //reference: cint; {deprecated}

    (**
     * QP table
     *)
    //qscale_table: pbyte; {deprecated}

    (**
     * QP store stride
     *)
    //qstride: cint; {deprecated}
    //qscale_type: cint; {deprecated}

    (**
     * mbskip_table[mb]>=1 if MB didn't change
     * stride= mb_width = (width+15)>>4
     *)
    //mbskip_table: pbyte; {deprecated}

    (**
     * motion vector table
     * @code
     * example:
     * int mv_sample_log2= 4 - motion_subsample_log2;
     * int mb_width= (width+15)>>4;
     * int mv_stride= (mb_width << mv_sample_log2) + 1;
     * motion_val[direction][x + y*mv_stride][0->mv_x, 1->mv_y];
     * @endcode
     *)
    //motion_val: array [0..1] of pointer;

    (**
     * macroblock type table
     * mb_type_base + mb_width + 2
     *)
    //mb_type: PCuint; {deprecated}

    (**
     * DCT coefficients
     *)
    //dct_coeff: PsmallInt; {deprecated}

    (**
     * motion reference frame index
     * the order in which these are stored can depend on the codec.
     *)
    //ref_index: array [0..1] of pbyte; {deprecated}
{$ENDIF}

    (**
     * for some private data of the user
     *)
    opaque: pointer;

    (**
     * error
     *)
    error: array [0..AV_NUM_DATA_POINTERS - 1] of cuint64;

{$IFDEF FF_API_AVFRAME_LAVC}
    //type_: cint; {deprecated}
{$ENDIF}

    (**
     * When decoding, this signals how much the picture must be delayed.
     * extra_delay = repeat_pict / (2*fps)
     *)
    repeat_pict: cint;

    (**
     * The content of the picture is interlaced.
     *)
    interlaced_frame: cint;

    (**
     * If the content is interlaced, is top field displayed first.
     *)
    top_field_first: cint;

    (**
     * Tell user application that palette has changed from previous frame.
     *)
    palette_has_changed: cint;

{$IFDEF FF_API_AVFRAME_LAVC}
    //buffer_hints: cint; {deprecated}
    (**
     * Pan scan.
     *)
    //pan_scan: PAVPanScan; {deprecated}
{$ENDIF}

    (**
     * reordered opaque 64bit (generally an integer or a double precision float
     * PTS but can be anything).
     * The user sets AVCodecContext.reordered_opaque to represent the input at
     * that time,
     * the decoder reorders values as needed and sets AVFrame.reordered_opaque
     * to exactly one of the values provided by the user through AVCodecContext.reordered_opaque
     * @deprecated in favor of pkt_pts
     *)
    reordered_opaque: cint64;

{$IFDEF FF_API_AVFRAME_LAVC}
    (**
     * @deprecated this field is unused
     *)
    //hwaccel_picture_private: pointer; {deprecated}
    //owner: pointer; {deprecated} (** Note: Should be a PAVCodecContext, but a type pointer is used to avoid a reference problem. *)
    //thread_opaque: pointer; {deprecated}

    (**
     * log2 of the size of the block which a single vector in motion_val represents:
     * (4->16x16, 3->8x8, 2-> 4x4, 1-> 2x2)
     *)
    //motion_subsample_log2: cuint8; {deprecated}
{$ENDIF}

    (**
     * Sample rate of the audio data.
     *)
    sample_rate: cint;

    (**
     * Channel layout of the audio data.
     *)
    channel_layout: cuint64;

    (**
     * AVBuffer references backing the data for this frame. If all elements of
     * this array are NULL, then this frame is not reference counted.
     *
     * There may be at most one AVBuffer per data plane, so for video this array
     * always contains all the references. For planar audio with more than
     * AV_NUM_DATA_POINTERS channels, there may be more buffers than can fit in
     * this array. Then the extra AVBufferRef pointers are stored in the
     * extended_buf array.
     *)
    buf: array [0..AV_NUM_DATA_POINTERS - 1] of pointer;//PAVBufferRef;

    (**
     * For planar audio which requires more than AV_NUM_DATA_POINTERS
     * AVBufferRef pointers, this array will hold all the references which
     * cannot fit into AVFrame.buf.
     *
     * Note that this is different from AVFrame.extended_data, which always
     * contains all the pointers. This array only contains the extra pointers,
     * which cannot fit into AVFrame.buf.
     *
     * This array is always allocated using av_malloc() by whoever constructs
     * the frame. It is freed in av_frame_unref().
     *)
    extended_buf: pointer;//PPAVBufferRef;

    (**
     * Number of elements in extended_buf.
     *)
    nb_extended_buf: cint;

    side_data: pointer;//^PAVFrameSideData;
    nb_side_data: cint;

    (**
     * @defgroup lavu_frame_flags AV_FRAME_FLAGS
     * Flags describing additional frame properties.
     *
     * @
     *)

    (**
     * Frame flags, a combination of @ref lavu_frame_flags
     *)
    flags: cint;

    (**
     * MPEG vs JPEG YUV range.
     * It must be accessed using av_frame_get_color_range() and
     * av_frame_set_color_range().
     * - encoding: Set by user
     * - decoding: Set by libavcodec
     *)
    color_range: cint;//TAVColorRange;

    color_primaries: cint;//TAVColorPrimaries;

    color_trc: cint;//TAVColorTransferCharacteristic;

    (**
     * YUV colorspace type.
     * It must be accessed using av_frame_get_colorspace() and
     * av_frame_set_colorspace().
     * - encoding: Set by user
     * - decoding: Set by libavcodec
     *)
    colorspace: cint;//TAVColorSpace;

    chroma_location: cint;//TAVChromaLocation;

    (**
     * frame timestamp estimated using various heuristics, in stream time base
     * Code outside libavcodec should access this field using:
     * av_frame_get_best_effort_timestamp(frame)
     * - encoding: unused
     * - decoding: set by libavcodec, read by user.
     *)
    best_effort_timestamp: cint64;

    (**
     * reordered pos from the last AVPacket that has been input into the decoder
     * Code outside libavcodec should access this field using:
     * av_frame_get_pkt_pos(frame)
     * - encoding: unused
     * - decoding: Read by user.
     *)
    pkt_pos: cint64;

    (**
     * duration of the corresponding packet, expressed in
     * AVStream->time_base units, 0 if unknown.
     * Code outside libavcodec should access this field using:
     * av_frame_get_pkt_duration(frame)
     * - encoding: unused
     * - decoding: Read by user.
     *)
    pkt_duration: cint64;

    (**
     * metadata.
     * Code outside libavcodec should access this field using:
     * av_frame_get_metadata(frame)
     * - encoding: Set by user.
     * - decoding: Set by libavcodec.
     *)
    metadata: pointer;//PAVDictionary;

    (**
     * decode error flags of the frame, set to a combination of
     * FF_DECODE_ERROR_xxx flags if the decoder produced a frame, but there
     * were errors during the decoding.
     * Code outside libavcodec should access this field using:
     * av_frame_get_decode_error_flags(frame)
     * - encoding: unused
     * - decoding: set by libavcodec, read by user.
     *)
    decode_error_flags: cint;

    (**
     * number of audio channels, only used for audio.
     * Code outside libavcodec should access this field using:
     * av_frame_get_channels(frame)
     * - encoding: unused
     * - decoding: Read by user.
     *)
    channels: cint;

    (**
     * size of the corresponding packet containing the compressed
     * frame. It must be accessed using av_frame_get_pkt_size() and
     * av_frame_set_pkt_size().
     * It is set to a negative value if unknown.
     * - encoding: unused
     * - decoding: set by libavcodec, read by user.
     *)
    pkt_size: cint;

    (**
     * Not to be accessed directly from outside libavutil
     *)
    qp_table_buf: pointer;//PAVBufferRef;
  end; {TAVFrame}

   TAVSampleFormat = (
    AV_SAMPLE_FMT_NONE = -1,
    AV_SAMPLE_FMT_U8,          ///< unsigned 8 bits
    AV_SAMPLE_FMT_S16,         ///< signed 16 bits
    AV_SAMPLE_FMT_S32,         ///< signed 32 bits
    AV_SAMPLE_FMT_FLT,         ///< float
    AV_SAMPLE_FMT_DBL,         ///< double

    AV_SAMPLE_FMT_U8P,         ///< unsigned 8 bits, planar
    AV_SAMPLE_FMT_S16P,        ///< signed 16 bits, planar
    AV_SAMPLE_FMT_S32P,        ///< signed 32 bits, planar
    AV_SAMPLE_FMT_FLTP,        ///< float, planar
    AV_SAMPLE_FMT_DBLP,        ///< double, planar

    AV_SAMPLE_FMT_NB           ///< Number of sample formats. DO NOT USE if linking dynamically
  );



  TAVPacket = record
    (**
     * A reference to the reference-counted buffer where the packet data is
     * stored.
     * May be NULL, then the packet data is not reference-counted.
     *)
    buf:          PAVBufferRef;
    (*
     * Presentation timestamp in AVStream->time_base units; the time at which
     * the decompressed packet will be presented to the user.
     * Can be AV_NOPTS_VALUE if it is not stored in the file.
     * pts MUST be larger or equal to dts as presentation cannot happen before
     * decompression, unless one wants to view hex dumps. Some formats misuse
     * the terms dts and pts/cts to mean something different. Such timestamps
     * must be converted to true pts/dts before they are stored in AVPacket.
     *)
    pts:          cint64;
    (*
     * Decompression timestamp in AVStream->time_base units; the time at which
     * the packet is decompressed.
     * Can be AV_NOPTS_VALUE if it is not stored in the file.
     *)
    dts:          cint64;
    data:         PByteArray;
    size:         cint;
    stream_index: cint;
    (**
     * A combination of AV_PKT_FLAG values
     *)
    flags:        cint;
    (**
     * Additional packet data that can be provided by the container.
     * Packet can contain several types of side information.
     *)
    side_data: PAVPacketSideData;
    side_data_elems: cint;
    (*
     * Duration of this packet in AVStream->time_base units, 0 if unknown.
     * Equals next_pts - this_pts in presentation order.
     *)
    duration:     cint;
{$IFDEF FF_API_DESTRUCT_PACKET}
    destruct:     procedure (para1: PAVPacket); cdecl;
    priv:         pointer;
{$ENDIF}

    pos:          cint64;       // byte position in stream, -1 if unknown

    (*
     * Time difference in AVStream->time_base units from the pts of this
     * packet to the point at which the output from the decoder has converged
     * independent from the availability of previous frames. That is, the
     * frames are virtually identical no matter if decoding started from
     * the very first frame or from this keyframe.
     * Is AV_NOPTS_VALUE if unknown.
     * This field has no meaning if the packet does not have AV_PKT_FLAG_KEY
     * set.
     *
     * The purpose of this field is to allow seeking in streams that have no
     * keyframes in the conventional sense. It corresponds to the
     * recovery point SEI in H.264 and match_time_delta in NUT. It is also
     * essential for some types of subtitle streams to ensure that all
     * subtitles are correctly displayed after seeking.
     *)
    convergence_duration: cint64;
  end; {TAVPacket}

      PAVPicture = ^TAVPicture;
    TAVPicture = record
      data: array [0..AV_NUM_DATA_POINTERS - 1] of PByteArray;
      linesize: array [0..AV_NUM_DATA_POINTERS - 1] of cint;       ///< number of bytes per line
    end; {TAVPicture}

      PPAVStream = ^PAVStream;
  PAVStream = ^TAVStream;
    TAVStream = record
    index: cint;    (**< stream index in AVFormatContext *)
    (**
     * Format-specific stream ID.
     * decoding: set by libavformat
     * encoding: set by the user, replaced by libavformat if left unset
     *)
    id: cint;       (**< format-specific stream ID *)
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
    codec: PAVCodecContext; (**< codec context *)
    priv_data: pointer;

{$IFDEF FF_API_LAVF_FRAC}
    (**
     * @deprecated this field is unused
     *)
    pts: TAVFrac; {attribute_deprecated}
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
    start_time: cint64;

    (**
     * Decoding: duration of the stream, in stream time base.
     * If a source file does not specify a duration, but does specify
     * a bitrate, this value will be estimated from bitrate and file size.
     *)
    duration: cint64;

    nb_frames: cint64;                 ///< number of frames in this stream if known or 0

    disposition: cint; (**< AV_DISPOSITION_* bitfield *)

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
    nb_side_data: cint;

    (**
     * Flags for the user to detect events happening on the stream. Flags must
     * be cleared by the user once the event has been handled.
     * A combination of AVSTREAM_EVENT_FLAG_*.
     *)
    event_flags: cint;

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
    info: PStreamInfo;

    pts_wrap_bits: cint; (**< number of bits in pts (used for wrapping control) *)

    // Timestamp generation support:
    (**
     * Timestamp corresponding to the last dts sync point.
     *
     * Initialized when AVCodecParserContext.dts_sync_point >= 0 and
     * a DTS is received from the underlying container. Otherwise set to
     * AV_NOPTS_VALUE by default.
     *)
    first_dts: cint64;
    cur_dts: cint64;
    last_IP_pts: cint64;
    last_IP_duration: cint;

    (**
     * Number of packets to buffer for codec probing
     *)
    probe_packets: cint;

     (**
     * Number of frames that have been demuxed during av_find_stream_info()
     *)
    codec_info_nb_frames: cint;

    (* av_read_frame() support *)
    need_parsing: TAVStreamParseType;
    parser: PAVCodecParserContext;

    (**
     * last packet in packet_buffer for this stream when muxing.
     *)
    last_in_packet_buffer: PAVPacketList;
    probe_data: TAVProbeData;
    pts_buffer: array [0..MAX_REORDER_DELAY] of cint64;

    index_entries: PAVIndexEntry; (**< Only used if the format does not
                                    support seeking natively. *)
    nb_index_entries: cint;
    index_entries_allocated_size: cuint;

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
    stream_identifier: cint;

    interleaver_chunk_size: cint64;
    interleaver_chunk_duration: cint64;

    (**
     * stream probing state
     * -1   -> probing finished
     *  0   -> no probing requested
     * rest -> perform probing with request_probe being the minimum score to accept.
     * NOT PART OF PUBLIC API
     *)
    request_probe: cint;
    (**
     * Indicates that everything up to the next keyframe
     * should be discarded.
     *)
    skip_to_keyframe: cint;

    (**
     * Number of samples to skip at the start of the frame decoded from the next packet.
     *)
    skip_samples: cint;

    (**
     * If not 0, the first audio sample that should be discarded from the stream.
     * This is broken by design (needs global sample count), but can't be
     * avoided for broken by design formats such as mp3 with ad-hoc gapless
     * audio support.
     *)
    first_discard_sample: cint64;

    (**
     * The sample after last sample that is intended to be discarded after
     * first_discard_sample. Works on frame boundaries only. Used to prevent
     * early EOF if the gapless info is broken (considered concatenated mp3s).
     *)
    last_discard_sample: cint64;

    (**
     * Number of internally decoded frames, used internally in libavformat, do not access
     * its lifetime differs from info which is why it is not in that structure.
     *)
    nb_decoded_frames: cint;

    (**
     * Timestamp offset added to timestamps before muxing
     * NOT PART OF PUBLIC API
     *)
    mux_ts_offset: cint64;

    (**
     * Internal data to check for wrapping of the time stamp
     *)
    pts_wrap_reference: cint64;

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
    pts_wrap_behavior: cint;

    (**
     * Internal data to prevent doing update_initial_durations() twice
     *)
    update_initial_durations_done: cint;

    (**
     * Internal data to generate dts from pts
     *)
    pts_reorder_error: array[0..MAX_REORDER_DELAY] of cint64;
    pts_reorder_error_count: array[0..MAX_REORDER_DELAY] of byte;

    (**
     * Internal data to analyze DTS and detect faulty mpeg streams
     *)
    last_dts_for_order_check: cint64;
    dts_ordered: byte;
    dts_misordered: byte;

		(**
     * Internal data to inject global side data
     *)
    inject_global_side_data: cint;

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
  end; (** TAVStream **)


procedure av_register_all();
  cdecl; external av__format;
function avformat_alloc_context(): PAVFormatContext;
  cdecl; external av__format;
function avformat_open_input(ps: PPAVFormatContext; filename: {const} PAnsiChar; fmt: PAVInputFormat;
  options: PPAVDictionary): cint;
  cdecl; external av__format;
function avformat_find_stream_info(ic: PAVFormatContext; options: PPAVDictionary): cint;
  cdecl; external av__format;
function avcodec_find_decoder(id: TAVCodecID): PAVCodec;
  cdecl; external av__codec;
function avcodec_open2(avctx: PAVCodecContext; codec: {const} PAVCodec; options: PPAVDictionary): cint;
  cdecl; external av__codec;
function av_frame_alloc(): PAVFrame;
  cdecl; external av__codec;
function av_read_frame(s: PAVFormatContext; var pkt: TAVPacket): cint;
  cdecl; external av__format;
function avcodec_decode_video2(avctx: PAVCodecContext; picture: PAVFrame; var got_picture_ptr: cint;
  avpkt: {const} PAVPacket): cint;
  cdecl; external av__codec;
procedure av_free_packet(pkt: PAVPacket);
  cdecl; external av__codec;
procedure av_free(ptr: pointer);
  cdecl; external av__util;
function avcodec_close(avctx: PAVCodecContext): cint;
  cdecl; external av__codec;
procedure avformat_close_input(s: PPAVFormatContext);
  cdecl; external av__format;
function av_mallocz(size: size_t): pointer;
  cdecl; external av__util;
function avcodec_decode_audio4(avctx: PAVCodecContext; frame: PAVFrame; got_frame_ptr: Pcint; avpkt: PAVPacket): cint;
  cdecl; external av__codec;
procedure av_bprint_channel_layout(bp: PAVBPrint; nb_channels: cint; channel_layout: cuint64);
  cdecl; external av__util;
function av_get_default_channel_layout(nb_channels: cint): cint64;
  cdecl; external av__util;
function av_opt_set_int(obj: pointer; Name: {const} PAnsiChar; val: cint64; search_flags: cint): cint;
  cdecl; external av__util;
function av_opt_set_sample_fmt(obj: pointer; Name: {const} PAnsiChar; fmt: TAVSampleFormat; search_flags: cint): cint;
  cdecl; external av__util;
function av_rescale_rnd(a, b, c: cint64; d: TAVRounding): cint64;
  cdecl; external av__util; {av_const}
function av_samples_alloc_array_and_samples(audio_data: PPPcuint8; linesize: Pcint;
  nb_channels: cint; nb_samples: cint; sample_fmt: TAVSampleFormat; align: cint): cint;
  cdecl; external av__util;
function av_samples_alloc(audio_data: PPcuint8; linesize: Pcint; nb_channels: cint;
  nb_samples: cint; sample_fmt: TAVSampleFormat; align: cint): cint;
  cdecl; external av__util;
function swr_convert(s: PSwrContext; out_: PPByte; out_count: cint; in_: {const} PPByte; in_count: cint): cint;
  cdecl; external sw__resample;
function av_samples_get_buffer_size(linesize: Pcint; nb_channels: cint; nb_samples: cint;
  sample_fmt: TAVSampleFormat; align: cint): cint;
  cdecl; external av__util;
procedure av_freep(ptr: pointer);
  cdecl; external av__util;
function swr_alloc(): PSwrContext;
  cdecl; external sw__resample;
procedure swr_free(s: PPSwrContext);
  cdecl; external sw__resample;

implementation

end.
