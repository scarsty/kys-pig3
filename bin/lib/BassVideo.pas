unit BassVideo;

interface

uses Windows, Messages, Bass, ActiveX;

(* 2.4.1.2 *)
type
     TWMAudioFormat = record
      Bitrate : integer;
      Freq : integer;
      nChan : integer;
      wBitPerSample : integer;
     end;
     PWMAudioFormat = ^TWMAudioFormat;

    PASFConfig = ^TASFConfig;
    TASFConfig = record
       Version : integer;
       Has_Audio : BOOL;
       Has_Video : BOOL;
       VideoBitrate : integer;
       useVideoVBR : BOOL;
       VBRQuality : integer; // 0 -> 100
       VideoCodec : integer;
       SrcVideoFrameHeight, SrcVideoFrameWidth : integer;
       DestVideoFrameHeight, DestVideoFrameWidth : integer;
       VideoQuality : integer; // 0 -> 100
       AudioCodec : integer;
       AudioCodecFormat : integer;
       AudioBitrate : integer;
       // for auto config audio
       Audio_Frequency : integer;
       Audio_Channel : integer;
       Audio_Bits_Per_Sample : integer;
     end;

    HFilter = Pointer;
    HCapture = integer;
    TCallBackEnumEncoderFilter = function(Filter : HFilter; FilterName,
                                          FilterGuid : PChar;user : Pointer) : BOOL; stdcall;
    TAudioEncoderCallBack = procedure(chan : DWORD; NewDatasize : DWORD; user : Pointer); stdcall;
    TBassVideoFrameInfo = record
     AvgFrameRate    : integer;
     FrameDraw, FrameDrop : integer;
    end;
    TBassVideoInfo = record
     AvgTimePerFrame : Double;
     Height, Width : integer;
     FormatType : integer;
     VideoFormat : integer;
     VideoFormat_GUID : PGUID;
    end;

 TCallBackDraw = procedure(chan : DWORD; DC : HDC; user : Pointer); stdcall;
 TMsg = record
    msg : DWORD;
    param1,
    param2 : LongInt;
 end;

   TResizeType = (R43, R169, RSource, RFree, RCustom);
     VIDEOPROC  = function(Handle : DWORD; Action, param1, param2 : DWORD; user : Pointer): BOOL; stdcall;
     {
        Handle : the channels handle
        Action :
           BassVideo_OpenDone     = 1; // chan : DWORD = 0 if failed , <> 0 if success
           BassVideo_Buffering    = 2; // param1 : 0 if buffering done, <> 0 if buffering in progress , param2 = buffer % // this for used in future
           BassVideo_FoundVideo   = 3; // chan : DWORD tell the app must prepare the video windows & Handle
     }
     FILTERPROC = function(Handle : DWORD; FilterName : PChar; Filter : Pointer; User : Pointer): BOOL; stdcall;
     {
        callback when enum filter
        FilterName : name of the DirectShow Filter
        Filter : Pointer of IBaseFilter

     }
     QWORD = int64;
     HSTREAM = DWORD;
     OAHWND = Longint;

const // video display
      BassVideoDLL = 'bassvideo.dll';
      BassVideo_Config_Renderer           = $100; // for BassVideo_GetConfig/SetConfig
      BassVideo_Congfig_WMASF_READER      = $101; // 0 = use WM_ASFReader else use Windows Media Source Filter
      BassVideo_Config_Audio_Renderer     = $102; // 0 = use Bass, 1 = use Windows

      // video render option
      BassVideo_Default              = 0;
      BassVideo_VMR9                 = 1;
      BassVideo_VMR9_Windowless      = 2;
      BassVideo_EVR                  = 3;
      BassVideo_Overlay              = 4;
      BassVideo_NOVIdeo              = 5;

      // action
      BassVideo_OpenDone       = 1; // chan : DWORD = 0 if failed , <> 0 if success
      BassVideo_Buffering      = 2; // param1 : 0 if buffering done, <> 0 if buffering in progress , param2 = buffer %
      BassVideo_FoundVideo     = 3; // chan : DWORD tell the app must prepare the video windows & Handle
      BassVideo_EndStream      = 4;
      BassVideo_DShow_Event    = 5;
      BassVideo_WM_Move        = 6;
      BassVideo_WM_Size        = 7;
      BassVideo_WM_Paint       = 8;
      BassVideo_WM_Mouse_Click = 9;
      BassVideo_WM_Mouse_Move  = 10;
      BassVideo_PlayEvent      = 11;

      BassVideo_Is_Play        = 1;
      BassVideo_Is_Pause       = 2;
      BassVideo_Is_Stop        = 3;

      // flags :
      BASSVIDEO_AUTO_PAINT     = 2;
      BASSVIDEO_AUTO_RESIZE    = 4;
      BASSVIDEO_AUTO_MOVE      = 8;
      BASSVIDEO_FILTERNAME     = 16;
      BASSVIDEO_UNICODE        = 32;
      BASSVIDEO_VIDEOEFFECT    = 64;
      BASSVIDEO_DISABLE_VIDEO  = 128;
      {2.4.0.9 change :}
      // color set
      COLOR_Brightness         = 1;
      COLOR_Contrast           = 2;
      COLOR_Hue                = 3;
      COLOR_Saturation         = 4;

      BASSVIDEO_MEDIA_UNKNOWN    = 0;
      BASSVIDEO_MEDIA_AVI        = 2;

    Video_WMV            = 1;
    Video_AVI            = 0;
    EncoderType_Video    = 0;
    EncoderType_Audio    = 1;
    EncoderType_WMASF    = 2;
    Device_Video_Capture = 3;
    Device_Audio_Capture = 4;

// wmv encoding
    WM_PROFILE             = 0;
    WM_DONT_COMPRESS       = 1; // 0 = false , 1 = true
    WM_MULTI_PASS          = 2; // 0 = false , 1 = true
    WM_AUTOINDEX           = 3; // 0 = false , 1 = true

    WM_VIDEO_8             = 100;
    WM_VIDEO_9             = 101;
    WM_AUTO_SELECT         = -1; // for ASFConfig AudioCodec value

//  WMPofiles8
    wmp_V80_255VideoPDA    = 0;
    wmp_V80_150VideoPDA    = 1;
    wmp_V80_28856VideoMBR  = 2;
    wmp_V80_100768VideoMBR = 3;
    wmp_V80_288100VideoMBR = 4;
    wmp_V80_288Video       = 5;
    wmp_V80_56Video        = 6;
    wmp_V80_100Video       = 7;
    wmp_V80_256Video       = 8;
    wmp_V80_384Video       = 9;
    wmp_V80_768Video       = 10;
    wmp_V80_700NTSCVideo   = 11;
    wmp_V80_1400NTSCVideo  = 12;
    wmp_V80_384PALVideo    = 13;
    wmp_V80_700PALVideo    = 14;
    wmp_V80_288MonoAudio   = 15;
    wmp_V80_288StereoAudio = 16;
    wmp_V80_32StereoAudio  = 17;
    wmp_V80_48StereoAudio  = 18;
    wmp_V80_64StereoAudio  = 19;
    wmp_V80_96StereoAudio  = 20;
    wmp_V80_128StereoAudio = 21;
    wmp_V80_288VideoOnly   = 22;
    wmp_V80_56VideoOnly    = 23;
    wmp_V80_FAIRVBRVideo   = 24;
    wmp_V80_HIGHVBRVideo   = 25;
    wmp_V80_BESTVBRVideo   = 26;

    VIDEOTYPE_UNKNOW                                       = 00;
    //Uncompressed RGB Video Subtypes
    VIDEOTYPE_RGB1                                         = 01;
    VIDEOTYPE_RGB4                                         = 02;
    VIDEOTYPE_RGB8                                         = 03;
    VIDEOTYPE_RGB555                                       = 04;
    VIDEOTYPE_RGB565                                       = 05;
    VIDEOTYPE_RGB24                                        = 06;
    VIDEOTYPE_RGB32                                        = 07;
    VIDEOTYPE_ARGB1555                                     = 08;
    VIDEOTYPE_ARGB32                                       = 09;
    VIDEOTYPE_ARGB4444                                     = 10;
    VIDEOTYPE_A2R10G10B10                                  = 11;
    VIDEOTYPE_A2B10G10R10                                  = 12;
    //YUV
    VIDEOTYPE_AYUV                                         = 13;
    VIDEOTYPE_YUY2                                         = 14;
    VIDEOTYPE_UYVY                                         = 15;
    VIDEOTYPE_IMC1                                         = 16;
    VIDEOTYPE_IMC3                                         = 17;
    VIDEOTYPE_IMC2                                         = 18;
    VIDEOTYPE_IMC4                                         = 19;
    VIDEOTYPE_YV12                                         = 20;
    VIDEOTYPE_NV12                                         = 21;
    VIDEOTYPE_Y411                                         = 22;
    VIDEOTYPE_Y41P                                         = 23;
    VIDEOTYPE_Y211                                         = 24;
    VIDEOTYPE_YVYU                                         = 25;
    VIDEOTYPE_YVU9                                         = 26;
    VIDEOTYPE_IF09                                         = 27;
    //Analog Video Subtypes
    VIDEOTYPE_AnalogVideo_NTSC_M                           = 28;
    VIDEOTYPE_AnalogVideo_PAL_B                            = 29;
    VIDEOTYPE_AnalogVideo_PAL_D                            = 30;
    VIDEOTYPE_AnalogVideo_PAL_G                            = 31;
    VIDEOTYPE_AnalogVideo_PAL_H                            = 32;
    VIDEOTYPE_AnalogVideo_PAL_I                            = 33;
    VIDEOTYPE_AnalogVideo_PAL_M                            = 34;
    VIDEOTYPE_AnalogVideo_PAL_N                            = 35;
    VIDEOTYPE_AnalogVideo_SECAM_B                          = 36;
    VIDEOTYPE_AnalogVideo_SECAM_D                          = 37;
    VIDEOTYPE_AnalogVideo_SECAM_G                          = 38;
    VIDEOTYPE_AnalogVideo_SECAM_H                          = 39;
    VIDEOTYPE_AnalogVideo_SECAM_K                          = 40;
    VIDEOTYPE_AnalogVideo_SECAM_K1                         = 41;
    VIDEOTYPE_AnalogVideo_SECAM_L                          = 42;
    //DirectX Video Acceleration Video Subtypes
    VIDEOTYPE_AI44                                         = 43;
    VIDEOTYPE_IA44                                         = 44;
    //DV Video Subtypes
    VIDEOTYPE_dvsl                                         = 45;
    VIDEOTYPE_dvsd                                         = 46;
    VIDEOTYPE_dvhd                                         = 47;
    //Professional Formats
    VIDEOTYPE_dv25                                         = 48;
    VIDEOTYPE_dv50                                         = 49;
    VIDEOTYPE_dvh1                                         = 50;
    VIDEOTYPE_DVCS                                         = 51;
    //Video Mixing Renderer Video Subtypes
    //VMR-7 Subtypes
    VIDEOTYPE_RGB32_D3D_DX7_RT                             = 52;
    VIDEOTYPE_RGB16_D3D_DX7_RT                             = 53;
    VIDEOTYPE_ARGB32_D3D_DX7_RT                            = 54;
    VIDEOTYPE_ARGB4444_D3D_DX7_RT                          = 55;
    VIDEOTYPE_ARGB1555_D3D_DX7_RT                          = 56;
    //VMR-9 Subtypes
    VIDEOTYPE_RGB32_D3D_DX9_RT                             = 57;
    VIDEOTYPE_RGB16_D3D_DX9_RT                             = 58;
    VIDEOTYPE_ARGB32_D3D_DX9_RT                            = 59;
    VIDEOTYPE_ARGB4444_D3D_DX9_RT                          = 60;
    VIDEOTYPE_ARGB1555_D3D_DX9_RT                          = 61;
    //Miscellaneous Video Subtypes
    VIDEOTYPE_CFCC                                         = 62;
    VIDEOTYPE_CLJR                                         = 63;
    VIDEOTYPE_CPLA                                         = 64;
    VIDEOTYPE_CLPL                                         = 65;
    VIDEOTYPE_IJPG                                         = 66;
    VIDEOTYPE_MDVF                                         = 67;
    VIDEOTYPE_MJPG                                         = 68;
    VIDEOTYPE_MPEG1Packet                                  = 69;
    VIDEOTYPE_MPEG1Payload                                 = 70;
    VIDEOTYPE_Overlay                                      = 71;
    VIDEOTYPE_Plum                                         = 72;
    VIDEOTYPE_QTJpeg                                       = 73;
    VIDEOTYPE_QTMovie                                      = 74;
    VIDEOTYPE_QTRle                                        = 75;
    VIDEOTYPE_QTRpza                                       = 76;
    VIDEOTYPE_QTSmc                                        = 77;
    VIDEOTYPE_TVMJ                                         = 78;
    VIDEOTYPE_VPVBI                                        = 79;
    VIDEOTYPE_VPVideo                                      = 80;
    VIDEOTYPE_WAKE                                         = 81;
         // end new 2.4.1.0

function BassVideo_ErrorGetCode : integer; stdcall; external BassVideoDLL;

function BassVideo_StreamCreateFileUser(UserProc : BASS_FILEPROCS;
                                        MediaType, Flags, BassFlags : DWORD;
                                        CallBackProc : VIDEOPROC; user : Pointer): DWORD; stdcall; external BassVideoDLL;

function BassVideo_StreamCreateFileMem(data :Pointer; datalength : int64;
                                       MediaType, Flags, BassFlags : DWORD;
                                       CallBackProc : VIDEOPROC; user : Pointer): DWORD; stdcall; external BassVideoDLL;

function BassVideo_StreamCreateFile(FileName : Pointer; Flags, BassFlags : DWORD;
                                    CallBackProc : VIDEOPROC; user : Pointer) : DWORD; stdcall; external BassVideoDLL;


procedure BassVideo_SetConfig(Option : DWORD; Value : DWORD); stdcall; external BassVideoDLL;

function BassVideo_Play(handle: DWORD) : BOOL; stdcall; external BassVideoDLL;//  <--- 2.4.1.2 changes
function BassVideo_Stop(handle: DWORD) : BOOL; stdcall; external BassVideoDLL;
function BassVideo_Pause(handle: DWORD) : BOOL; stdcall; external BassVideoDLL;
function BassVideo_SetPosition(handle: DWORD; pos: Double): BOOL; stdcall; external BassVideoDLL;//  <--- 2.4.1.2 changes
function BassVideo_SetEndPosition(handle: DWORD; endpos: Double): BOOL; stdcall; external BassVideoDLL;//  <--- 2.4.1.2 changes
function BassVideo_GetPosition(handle: DWORD): Double; stdcall; external BassVideoDLL;//  <--- 2.4.1.2 changes
function BassVideo_GetLength(handle: DWORD): Double; stdcall; external BassVideoDLL;//  <--- 2.4.1.2 changes
procedure BassVideo_StreamFree(handle: DWORD); stdcall; external BassVideoDLL;

function BassVideo_Init : BOOL; stdcall; external BassVideoDLL;
procedure BassVideo_Free; stdcall; external BassVideoDLL;
function BassVideo_GetCurrentBuffering(Handle : DWORD) : integer; stdcall; external BassVideoDLL;
function BassVideo_SetEventNotify(chan : DWORD; hwnd: OAHWND; lMsg: Longint; lInstanceData: Longint) : BOOL; stdcall; external BassVideoDLL;
function BassVideo_GetEvent(chan : DWORD; out lEventCode: Longint;
                            out lParam1, lParam2: Longint; msTimeout: DWORD) : BOOL; stdcall; external BassVideoDLL;

                            // for video windows function
procedure BassVideo_SetVideoWindow(chan : DWORD; VideoWindowHandle : THandle;var VideoRect : TRect; VideoNum : integer); stdcall; external BassVideoDLL;
procedure BassVideo_Repaint(chan : DWORD; WinHandle : HWND; DC : HDC; VideoNum : integer); stdcall; external BassVideoDLL;
procedure BassVideo_WindowResize(chan : DWORD;var Rect : TRect; VideoNum : integer); stdcall; external BassVideoDLL;
procedure BassVideo_WindowMove(chan : DWORD; Msg : DWORD; wParam, lParam : LongInt; VideoNum : integer); stdcall; external BassVideoDLL;
function BassVideo_SetRatio(chan : DWORD; Value: TResizeType; custom : Double; VideoNum : integer) : HRESULT; stdcall; external BassVideoDLL;

function BassVideo_SetChannel(chan, newChan : DWORD) : DWORD; stdcall; external BassVideoDLL;
function BassVideo_AddFile(Oldchan : DWORD; newFile : Pointer; Flags, BassFlags : DWORD;
                           callbackproc : VIDEOPROC; user : Pointer) : DWORD; stdcall; external BassVideoDLL;
function BassVideo_GetVersion : DWORD; stdcall; external BassVideoDLL;
function BassVideo_EventToString(Event : Longint) : PChar; stdcall; external BassVideoDLL;

function BassVideo_AddVideo(chan : DWORD; ParentHandle : HWND; var Rect : TRECT; Flags : DWORD): BOOL; stdcall; external BassVideoDLL;

function BassVideo_GetGraph(chan : DWORD) : Pointer; stdcall; external BassVideoDLL;

function BassVideo_FrameStep(chan : DWORD): BOOL; stdcall; external BassVideoDLL;

// new function added (2.4.0.8)
function BassVideo_SetColor(Chan : DWORD; Color : integer; Value : single; VideoNum : integer; Flags : DWORD) : BOOL; stdcall; external BassVideoDLL;
function BassVideo_GetColorRange(Chan : DWORD; Color : integer; VideoNum : integer; Flags : DWORD; var CMax, CMin, CDef : Single) : BOOL; stdcall; external BassVideoDLL;

function BassVideo_CaptureBitmap(lpSourceFile : Pointer; CaptureTime : Double; BitmapOutput : Pointer; Flags : DWORD) : BOOL; stdcall; external BassVideoDLL;
(* Add Flags for UNICODE FILE NAME *)

procedure BassVideo_GetVideoInfo(chan : DWORD; var height, width : integer); stdcall; external BassVideoDLL;
function BassVideo_EnumFilter(chan : DWORD; callback : Pointer; user : Pointer) : BOOL; stdcall; external BassVideoDLL;
function BassVideo_HasFilterPropertyPage(chan : DWORD; Filter : Pointer; Flags : DWORD): BOOL; stdcall; external BassVideoDLL;
function BassVideo_ShowFilterPropertyPage(chan : DWORD; Filter : Pointer;parenthandle : HWND;Flags : DWORD): BOOL; stdcall; external BassVideoDLL;
function BassVideo_SaveGraphFile(chan : DWORD; FileName : Pointer; Flags : DWORD) : BOOL; stdcall; external BassVideoDLL;
procedure BassVideo_CloseWindow(chan : DWORD; VideoNum : integer); stdcall; external BassVideoDLL;
function BassVideo_GetVideoWindow(chan : DWORD; vidnum : integer): HWND; stdcall; external BassVideoDLL;

function BassVideo_SetTempoValue(chan, value : DWORD) : BOOL; stdcall; external BassVideoDLL;
function BassVideo_SetTempoEnable(chan : DWORD; value : BOOL) : BOOL; stdcall; external BassVideoDLL;
function BassVideo_GetTempoValue(chan : DWORD) : integer; stdcall; external BassVideoDLL;
function BassVideo_GetTempoEnable(chan : DWORD) : BOOL; stdcall; external BassVideoDLL;

// new 2.4.1.0
function BassVideo_SetPitchValue(chan, value : DWORD) : BOOL; stdcall; external BassVideoDLL;
function BassVideo_SetPitchEnable(chan : DWORD; value : BOOL) : BOOL; stdcall; external BassVideoDLL;
function BassVideo_GetPitchValue(chan : DWORD) : integer; stdcall; external BassVideoDLL;
function BassVideo_GetPitchEnable(chan : DWORD) : BOOL; stdcall; external BassVideoDLL;

function BassVideo_GetInfo(chan : DWORD; var info : TBassVideoInfo) : BOOL; stdcall; external BassVideoDLL;
function BassVideo_GetFrameInfo(chan : DWORD; var info : TBassVideoFrameInfo): BOOL; stdcall; external BassVideoDLL;

function BassVideo_EncoderAudio(chan : DWORD; VideoPreview : BOOL; DataProc : TAudioEncoderCallBack; user : Pointer): DWORD; stdcall; external BassVideoDLL;

function BassVideo_AddVideo2(chan : DWORD; ParentHandle : HWND; L, T, R, B : integer; Flags : DWORD): BOOL; stdcall; external BassVideoDLL;
// end new 2.4.1.0

// 2.4.1.1
function BassVideo_EnumEncoder(EncoderType : integer; CallBack : TCallBackEnumEncoderFilter;
                               user : Pointer): BOOL; stdcall; external BassVideoDLL;
function BassVideo_CreateEncoder(FilterGUID : PGUID): Pointer; stdcall; external BassVideoDLL;

function BassVideo_ConfigEncoderFilter(chan : DWORD;EncoderType : integer;parentHandle : HWND) : BOOL; stdcall; external BassVideoDLL;

function BassVideo_ConfigFilter(FilterType : integer; FilterName : PChar; parentHandle : HWND) : BOOL; stdcall; external BassVideoDLL;

// 2.4.1.2

function BassVideo_AddText(chan : DWORD; text : PWideChar; x, y : integer; fontname : PChar; fontheight, fontwidth : integer;
                           fontcolor : DWORD; fontstyle : DWORD): integer; stdcall; external BassVideoDLL;
function BassVideo_AddText2(chan : DWORD; text : PWideChar; x, y : integer; hfont : DWORD; fontcolor : DWORD): integer; stdcall; external BassVideoDLL;

function BassVideo_Set_Draw_CallBack(chan : DWORD; CallBackFunction : TCallBackDraw; user : Pointer): BOOL; stdcall; external BassVideoDLL;

function BassVideo_RemoveText(chan : DWORD; hText : integer): BOOL; stdcall; external BassVideoDLL;

function BassVideo_DVD_StreamCreate(dvdpath : PWideChar; flags, bassflags : DWORD;
                                    vidproc : VIDEOPROC; user : pointer): DWORD; stdcall; external BassVideoDLL;
function BassVideo_DVD_ShowMenu(chan : DWORD): BOOL; stdcall; external BassVideoDLL;
function BassVideo_DVD_MouseMove(chan : DWORD; lParam : LPARAM): BOOL; stdcall; external BassVideoDLL;
function BassVideo_DVD_MouseClick(chan : DWORD; lParam : LPARAM): BOOL; stdcall; external BassVideoDLL;
function BassVideo_DVD_EnableCaptions(chan : DWORD; CaptionEnable: BOOL): BOOL; stdcall; external BassVideoDLL;
function BassVideo_DVD_ShowTitle(chan : DWORD): BOOL; stdcall; external BassVideoDLL;
function BassVideo_DVD_SaveBookMarks(chan : DWORD; FileName, Name : PWideChar): BOOL; stdcall; external BassVideoDLL;
function BassVideo_DVD_RestoreBookMarks(chan : DWORD; FileName, Name : PWideChar): BOOL; stdcall; external BassVideoDLL;
function BassVideo_DVD_GetTitleCount(chan : DWORD): integer; stdcall; external BassVideoDLL;
function BassVideo_DVD_GetChapterCount(chan : DWORD; title : DWORD) : DWORD; stdcall; external BassVideoDLL;
function BassVideo_DVD_Play(chan : DWORD; title : integer; chapter : integer; time : Double): BOOL; stdcall; external BassVideoDLL;
function BassVideo_DVD_SetPlayRate(chan : DWORD; Rate : Double): BOOL; stdcall; external BassVideoDLL;
function BassVideo_DVD_PlayNextChapter(chan : DWORD) : BOOL; stdcall; external BassVideoDLL;
function BassVideo_DVD_PlayPrevChapter(chan : DWORD) : BOOL; stdcall; external BassVideoDLL;
function BassVideo_DVD_RePlayChapter(chan : DWORD) : BOOL; stdcall; external BassVideoDLL;
function BassVideo_DVD_PlayTitleInTime(chan : DWORD; title : integer; from_time, to_time : Double): BOOL; stdcall; external BassVideoDLL;
function BassVideo_DVD_PlayChapterAndStop(chan : DWORD; title, chapter, num : integer): BOOL; stdcall; external BassVideoDLL;
function BassVideo_DVD_GetAudioLanguageCount(Chan : DWORD; var LangCount: DWORD; var CurrentLang : DWORD): BOOL; stdcall; external BassVideoDLL;
function BassVideo_DVD_GetAudioLanguage(chan : DWORD; LangIndex : DWORD): PWideChar; stdcall; external BassVideoDLL;
function BassVideo_DVD_SetAudioLanguage(chan : DWORD; LangIndex : DWORD): BOOL; stdcall; external BassVideoDLL;
function BassVideo_DVD_GetSubtitleCount(chan : DWORD; var MaxSub : DWORD;var CurrentSub : DWORD;var isSubShow : BOOL): BOOL; stdcall; external BassVideoDLL;
function BassVideo_DVD_GetSubtitleName(chan : DWORD; LangIndex : DWORD): PWideChar; stdcall; external BassVideoDLL;
function BassVideo_DVD_SetSubtitle(chan : DWORD; LangIndex : DWORD): BOOL; stdcall; external BassVideoDLL;
function BassVideo_DVD_EnableSubtitle(chan : DWORD; Enable : BOOL): BOOL; stdcall; external BassVideoDLL;
function BassVideo_DVD_SelectParentalLevel(chan : DWORD; Level : DWORD): BOOL; stdcall; external BassVideoDLL;
function BassVideo_DVD_GetAngleCount(chan : DWORD;var anglemax : DWORD;var CurrentAngle : DWORD) : BOOL; stdcall; external BassVideoDLL;
function BassVideo_DVD_SetCurrentAngle(chan : DWORD;CurrentAngle : DWORD) : BOOL; stdcall; external BassVideoDLL;

function BassVideo_Capture_EnumDevice(DeviceType : integer; CallBack : Pointer; user : Pointer): BOOL; stdcall; external BassVideoDLL;
function BassVideo_Capture_StreamCreate(Video_Device, Audio_Device : Pointer; isFilterName : BOOL) : HCapture; stdcall; external BassVideoDLL;
function BassVideo_Capture_Start(handle : HCapture; Flags, BassFlags : DWORD; VidProc : VIDEOPROC; user : POinter) : DWORD; stdcall; external BassVideoDLL;
function BassVideo_Capture_ConfigDevice(handle : HCapture;Device :integer; parent : HWND): BOOL; stdcall; external BassVideoDLL;
function BassVideo_Capture_ConfigDevicePin(handle : HCapture;Device :integer; parent : HWND): BOOL; stdcall; external BassVideoDLL;

function BassVideo_Encoder_SetWMSetting(chan : DWORD; setting : dword; value : dword): BOOL; stdcall; external BassVideoDLL;

function BassVideo_EncoderVideo(_fin, _fout : Pointer; VideoType : integer; Flags : DWORD;
                                _VideoCodec, _AudioCodec : Pointer; VidProc : VIDEOPROC; user : POinter): DWORD; stdcall; external BassVideoDLL;
function BassVideo_Encoder_Create(chan : DWORD; FOut : PWideChar; OutputType : integer;
                                  EncoderSetting: Pointer): DWORD; stdcall; external BassVideoDLL;
                                  
function BassVideo_ReAddVideo(chan : DWORD): BOOL; stdcall; external BassVideoDLL;

function BassVideo_StreamCreateURL(URL : Pointer; Flags, BassFlags : DWORD;
                                    CallBackProc : VIDEOPROC; user : Pointer) : DWORD; stdcall; external BassVideoDLL;

function BassVideo_SetVolume(chan : DWORD; vol : integer): BOOL; stdcall; external BassVideoDLL;

function BassVideo_ReAddVideo2(chan : DWORD; mIndexLeft : integer): BOOL; stdcall; external BassVideoDLL;

function BassVideo_Encoder_GetWMSettingCount(SettingType : integer;var CodecCount : integer;
                                             var FormatCount : integer): BOOL; stdcall;  external BassVideoDLL;
                                             
function BassVideo_Encoder_GetWMSetting(SettingType, Codec, Format : integer;
                                        var value : Pointer): BOOL; stdcall; external BassVideoDLL;


function BassVideo_AddToRoot(chan : DWORD; add : BOOL): BOOL; stdcall; external BassVideoDLL;
implementation

end.
