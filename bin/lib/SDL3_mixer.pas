unit SDL3_mixer;

{$mode objfpc}{$H+}

interface

uses
  ctypes,
  SDL3;

const
{$IFDEF WINDOWS}
  SDL_MIXER_LIB = 'SDL3_mixer.dll';
{$ELSE}
  SDL_MIXER_LIB = 'SDL3_mixer';
{$ENDIF}

  { SDL3_mixer header version. }
  SDL_MIXER_MAJOR_VERSION = 3;
  SDL_MIXER_MINOR_VERSION = 2;
  SDL_MIXER_MICRO_VERSION = 0;

  { Special values used by duration query APIs. }
  MIX_DURATION_UNKNOWN = -1;
  MIX_DURATION_INFINITE = -2;

  { Property keys for mixers and audio loading. }
  MIX_PROP_MIXER_DEVICE_NUMBER = 'SDL_mixer.mixer.device';
  MIX_PROP_AUDIO_LOAD_IOSTREAM_POINTER = 'SDL_mixer.audio.load.iostream';
  MIX_PROP_AUDIO_LOAD_CLOSEIO_BOOLEAN = 'SDL_mixer.audio.load.closeio';
  MIX_PROP_AUDIO_LOAD_PREDECODE_BOOLEAN = 'SDL_mixer.audio.load.predecode';
  MIX_PROP_AUDIO_LOAD_PREFERRED_MIXER_POINTER = 'SDL_mixer.audio.load.preferred_mixer';
  MIX_PROP_AUDIO_LOAD_SKIP_METADATA_TAGS_BOOLEAN = 'SDL_mixer.audio.load.skip_metadata_tags';
  MIX_PROP_AUDIO_DECODER_STRING = 'SDL_mixer.audio.decoder';

  { Property keys for audio metadata. }
  MIX_PROP_METADATA_TITLE_STRING = 'SDL_mixer.metadata.title';
  MIX_PROP_METADATA_ARTIST_STRING = 'SDL_mixer.metadata.artist';
  MIX_PROP_METADATA_ALBUM_STRING = 'SDL_mixer.metadata.album';
  MIX_PROP_METADATA_COPYRIGHT_STRING = 'SDL_mixer.metadata.copyright';
  MIX_PROP_METADATA_TRACK_NUMBER = 'SDL_mixer.metadata.track';
  MIX_PROP_METADATA_TOTAL_TRACKS_NUMBER = 'SDL_mixer.metadata.total_tracks';
  MIX_PROP_METADATA_YEAR_NUMBER = 'SDL_mixer.metadata.year';
  MIX_PROP_METADATA_DURATION_FRAMES_NUMBER = 'SDL_mixer.metadata.duration_frames';
  MIX_PROP_METADATA_DURATION_INFINITE_BOOLEAN = 'SDL_mixer.metadata.duration_infinite';

  { Playback option keys used by MIX_PlayTrack and MIX_PlayTag. }
  MIX_PROP_PLAY_LOOPS_NUMBER = 'SDL_mixer.play.loops';
  MIX_PROP_PLAY_MAX_FRAME_NUMBER = 'SDL_mixer.play.max_frame';
  MIX_PROP_PLAY_MAX_MILLISECONDS_NUMBER = 'SDL_mixer.play.max_milliseconds';
  MIX_PROP_PLAY_START_FRAME_NUMBER = 'SDL_mixer.play.start_frame';
  MIX_PROP_PLAY_START_MILLISECOND_NUMBER = 'SDL_mixer.play.start_millisecond';
  MIX_PROP_PLAY_LOOP_START_FRAME_NUMBER = 'SDL_mixer.play.loop_start_frame';
  MIX_PROP_PLAY_LOOP_START_MILLISECOND_NUMBER = 'SDL_mixer.play.loop_start_millisecond';
  MIX_PROP_PLAY_FADE_IN_FRAMES_NUMBER = 'SDL_mixer.play.fade_in_frames';
  MIX_PROP_PLAY_FADE_IN_MILLISECONDS_NUMBER = 'SDL_mixer.play.fade_in_milliseconds';
  MIX_PROP_PLAY_FADE_IN_START_GAIN_FLOAT = 'SDL_mixer.play.fade_in_start_gain';
  MIX_PROP_PLAY_APPEND_SILENCE_FRAMES_NUMBER = 'SDL_mixer.play.append_silence_frames';
  MIX_PROP_PLAY_APPEND_SILENCE_MILLISECONDS_NUMBER = 'SDL_mixer.play.append_silence_milliseconds';
  MIX_PROP_PLAY_HALT_WHEN_EXHAUSTED_BOOLEAN = 'SDL_mixer.play.halt_when_exhausted';

  { Legacy compatibility constants used by the existing project code. }
  SDL_MIXER_INIT_FLAC = $00000001;
  SDL_MIXER_INIT_MOD = $00000002;
  SDL_MIXER_INIT_MP3 = $00000008;
  SDL_MIXER_INIT_OGG = $00000010;
  SDL_MIXER_INIT_MID = $00000020;
  MIX_MAX_VOLUME = 128;

type
  PPAnsiChar = ^PAnsiChar;

  { Some SDL3 Pascal headers in this project do not expose these C names. }
  SDL_AudioDeviceID = UInt32;
  SDL_PropertiesID = UInt32;
  Sint64 = Int64;

  { Core opaque handle types exposed by SDL3_mixer. }
  MIX_Mixer = Pointer;
  MIX_Audio = Pointer;
  MIX_Track = Pointer;
  MIX_Group = Pointer;
  MIX_AudioDecoder = Pointer;

  PPMIX_Track = ^MIX_Track;

  { Per-channel gains used for simple stereo positioning. }
  MIX_StereoGains = record
    left: Single;
    right: Single;
  end;
  PMIX_StereoGains = ^MIX_StereoGains;

  { Simple 3D position used for track spatialization. }
  MIX_Point3D = record
    x: Single;
    y: Single;
    z: Single;
  end;
  PMIX_Point3D = ^MIX_Point3D;

  { Track stopped, track mix, group mix, and post-mix callbacks. }
  MIX_TrackStoppedCallback = procedure(userdata: Pointer; track: MIX_Track); cdecl;
  MIX_TrackMixCallback = procedure(userdata: Pointer; track: MIX_Track; spec: PSDL_AudioSpec; pcm: PSingle; samples: cint); cdecl;
  MIX_GroupMixCallback = procedure(userdata: Pointer; group: MIX_Group; spec: PSDL_AudioSpec; pcm: PSingle; samples: cint); cdecl;
  MIX_PostMixCallback = procedure(userdata: Pointer; mixer: MIX_Mixer; spec: PSDL_AudioSpec; pcm: PSingle; samples: cint); cdecl;

  { Legacy opaque handle aliases kept for older call sites. }
  PMIX_Music = Pointer;
  PMIX_Chunk = Pointer;

{ Initialization and decoder discovery. }
{ Returns the version of the linked SDL3_mixer library. }
function MIX_Version(): cint; cdecl; external SDL_MIXER_LIB;
{ Initializes SDL3_mixer. Safe to call more than once. }
function MIX_Init(): Boolean; cdecl; external SDL_MIXER_LIB;
{ Shuts down SDL3_mixer and releases library-wide resources. }
procedure MIX_Quit(); cdecl; external SDL_MIXER_LIB;
{ Reports how many audio decoders are available. }
function MIX_GetNumAudioDecoders(): cint; cdecl; external SDL_MIXER_LIB;
{ Returns the name of an audio decoder by index. }
function MIX_GetAudioDecoder(index: cint): PAnsiChar; cdecl; external SDL_MIXER_LIB;

{ Mixer creation, destruction, and basic queries. }
{ Creates a mixer that outputs directly to an SDL playback device. }
function MIX_CreateMixerDevice(devid: SDL_AudioDeviceID; spec: PSDL_AudioSpec): MIX_Mixer; cdecl; external SDL_MIXER_LIB;
{ Creates a mixer that renders mixed audio into memory instead of a device. }
function MIX_CreateMixer(spec: PSDL_AudioSpec): MIX_Mixer; cdecl; external SDL_MIXER_LIB;
{ Destroys a mixer and any mixer-owned runtime state. }
procedure MIX_DestroyMixer(mixer: MIX_Mixer); cdecl; external SDL_MIXER_LIB;
{ Returns the SDL properties object associated with a mixer. }
function MIX_GetMixerProperties(mixer: MIX_Mixer): SDL_PropertiesID; cdecl; external SDL_MIXER_LIB;
{ Queries the output audio format of a mixer. }
function MIX_GetMixerFormat(mixer: MIX_Mixer; spec: PSDL_AudioSpec): Boolean; cdecl; external SDL_MIXER_LIB;
{ Locks a mixer so multiple changes can be applied atomically. }
procedure MIX_LockMixer(mixer: MIX_Mixer); cdecl; external SDL_MIXER_LIB;
{ Unlocks a mixer previously locked with MIX_LockMixer. }
procedure MIX_UnlockMixer(mixer: MIX_Mixer); cdecl; external SDL_MIXER_LIB;

{ Audio loading and lifetime management. }
{ Loads compressed or decoded audio from an SDL_IOStream. }
function MIX_LoadAudio_IO(mixer: MIX_Mixer; io: PSDL_IOStream; predecode: Boolean; closeio: Boolean): MIX_Audio; cdecl; external SDL_MIXER_LIB;
{ Loads audio from a file path. }
function MIX_LoadAudio(mixer: MIX_Mixer; path: PAnsiChar; predecode: Boolean): MIX_Audio; cdecl; external SDL_MIXER_LIB;
{ Loads audio from caller-owned memory without copying the source buffer. }
function MIX_LoadAudioNoCopy(mixer: MIX_Mixer; data: Pointer; datalen: NativeUInt; free_when_done: Boolean): MIX_Audio; cdecl; external SDL_MIXER_LIB;
{ Loads audio using a property bag for advanced control. }
function MIX_LoadAudioWithProperties(props: SDL_PropertiesID): MIX_Audio; cdecl; external SDL_MIXER_LIB;
{ Loads raw PCM audio from an SDL_IOStream. }
function MIX_LoadRawAudio_IO(mixer: MIX_Mixer; io: PSDL_IOStream; spec: PSDL_AudioSpec; closeio: Boolean): MIX_Audio; cdecl; external SDL_MIXER_LIB;
{ Loads raw PCM audio from memory. }
function MIX_LoadRawAudio(mixer: MIX_Mixer; data: Pointer; datalen: NativeUInt; spec: PSDL_AudioSpec): MIX_Audio; cdecl; external SDL_MIXER_LIB;
{ Wraps caller-owned raw PCM data without copying it. }
function MIX_LoadRawAudioNoCopy(mixer: MIX_Mixer; data: Pointer; datalen: NativeUInt; spec: PSDL_AudioSpec; free_when_done: Boolean): MIX_Audio; cdecl; external SDL_MIXER_LIB;
{ Creates a synthetic sine-wave audio source. }
function MIX_CreateSineWaveAudio(mixer: MIX_Mixer; hz: cint; amplitude: Single; ms: Sint64): MIX_Audio; cdecl; external SDL_MIXER_LIB;
{ Returns the SDL properties object associated with an audio object. }
function MIX_GetAudioProperties(audio: MIX_Audio): SDL_PropertiesID; cdecl; external SDL_MIXER_LIB;
{ Returns the duration of an audio object in sample frames. }
function MIX_GetAudioDuration(audio: MIX_Audio): Sint64; cdecl; external SDL_MIXER_LIB;
{ Queries the source format of an audio object. }
function MIX_GetAudioFormat(audio: MIX_Audio; spec: PSDL_AudioSpec): Boolean; cdecl; external SDL_MIXER_LIB;
{ Releases an audio object. }
procedure MIX_DestroyAudio(audio: MIX_Audio); cdecl; external SDL_MIXER_LIB;

{ Track creation, input binding, tags, and playback position control. }
{ Creates a new track owned by a mixer. }
function MIX_CreateTrack(mixer: MIX_Mixer): MIX_Track; cdecl; external SDL_MIXER_LIB;
{ Destroys a track and stops any playback on it. }
procedure MIX_DestroyTrack(track: MIX_Track); cdecl; external SDL_MIXER_LIB;
{ Returns the SDL properties object associated with a track. }
function MIX_GetTrackProperties(track: MIX_Track): SDL_PropertiesID; cdecl; external SDL_MIXER_LIB;
{ Returns the mixer that owns a track. }
function MIX_GetTrackMixer(track: MIX_Track): MIX_Mixer; cdecl; external SDL_MIXER_LIB;
{ Assigns a loaded audio object as the input source for a track. }
function MIX_SetTrackAudio(track: MIX_Track; audio: MIX_Audio): Boolean; cdecl; external SDL_MIXER_LIB;
{ Assigns an SDL_AudioStream as the input source for a track. }
function MIX_SetTrackAudioStream(track: MIX_Track; stream: PSDL_AudioStream): Boolean; cdecl; external SDL_MIXER_LIB;
{ Assigns a compressed audio stream as the input source for a track. }
function MIX_SetTrackIOStream(track: MIX_Track; io: PSDL_IOStream; closeio: Boolean): Boolean; cdecl; external SDL_MIXER_LIB;
{ Assigns a raw PCM stream as the input source for a track. }
function MIX_SetTrackRawIOStream(track: MIX_Track; io: PSDL_IOStream; spec: PSDL_AudioSpec; closeio: Boolean): Boolean; cdecl; external SDL_MIXER_LIB;
{ Adds a tag string to a track. }
function MIX_TagTrack(track: MIX_Track; tag: PAnsiChar): Boolean; cdecl; external SDL_MIXER_LIB;
{ Removes one tag, or all tags, from a track. }
procedure MIX_UntagTrack(track: MIX_Track; tag: PAnsiChar); cdecl; external SDL_MIXER_LIB;
{ Returns all tags currently attached to a track. }
function MIX_GetTrackTags(track: MIX_Track; count: Pcint): PPAnsiChar; cdecl; external SDL_MIXER_LIB;
{ Returns all tracks on a mixer that match a tag. }
function MIX_GetTaggedTracks(mixer: MIX_Mixer; tag: PAnsiChar; count: Pcint): PPMIX_Track; cdecl; external SDL_MIXER_LIB;
{ Seeks a track to a playback position in sample frames. }
function MIX_SetTrackPlaybackPosition(track: MIX_Track; frames: Sint64): Boolean; cdecl; external SDL_MIXER_LIB;
{ Returns the current playback position of a track in sample frames. }
function MIX_GetTrackPlaybackPosition(track: MIX_Track): Sint64; cdecl; external SDL_MIXER_LIB;
{ Reports remaining fade frames for a track, if any. }
function MIX_GetTrackFadeFrames(track: MIX_Track): Sint64; cdecl; external SDL_MIXER_LIB;
{ Returns the current loop count state of a track. }
function MIX_GetTrackLoops(track: MIX_Track): cint; cdecl; external SDL_MIXER_LIB;
{ Changes how many times a track should loop. }
function MIX_SetTrackLoops(track: MIX_Track; num_loops: cint): Boolean; cdecl; external SDL_MIXER_LIB;
{ Returns the MIX_Audio currently bound to a track, if any. }
function MIX_GetTrackAudio(track: MIX_Track): MIX_Audio; cdecl; external SDL_MIXER_LIB;
{ Returns the SDL_AudioStream currently bound to a track, if any. }
function MIX_GetTrackAudioStream(track: MIX_Track): PSDL_AudioStream; cdecl; external SDL_MIXER_LIB;
{ Returns how many frames remain to be mixed for a track. }
function MIX_GetTrackRemaining(track: MIX_Track): Sint64; cdecl; external SDL_MIXER_LIB;
{ Converts milliseconds to frames using a track's current input format. }
function MIX_TrackMSToFrames(track: MIX_Track; ms: Sint64): Sint64; cdecl; external SDL_MIXER_LIB;
{ Converts frames to milliseconds using a track's current input format. }
function MIX_TrackFramesToMS(track: MIX_Track; frames: Sint64): Sint64; cdecl; external SDL_MIXER_LIB;
{ Converts milliseconds to frames using an audio object's format. }
function MIX_AudioMSToFrames(audio: MIX_Audio; ms: Sint64): Sint64; cdecl; external SDL_MIXER_LIB;
{ Converts frames to milliseconds using an audio object's format. }
function MIX_AudioFramesToMS(audio: MIX_Audio; frames: Sint64): Sint64; cdecl; external SDL_MIXER_LIB;
{ Converts milliseconds to frames at an explicit sample rate. }
function MIX_MSToFrames(sample_rate: cint; ms: Sint64): Sint64; cdecl; external SDL_MIXER_LIB;
{ Converts frames to milliseconds at an explicit sample rate. }
function MIX_FramesToMS(sample_rate: cint; frames: Sint64): Sint64; cdecl; external SDL_MIXER_LIB;

{ Playback control: start, stop, pause, resume, and state queries. }
{ Starts or restarts playback on a single track. }
function MIX_PlayTrack(track: MIX_Track; options: SDL_PropertiesID): Boolean; cdecl; external SDL_MIXER_LIB;
{ Starts or restarts playback on all tracks with a given tag. }
function MIX_PlayTag(mixer: MIX_Mixer; tag: PAnsiChar; options: SDL_PropertiesID): Boolean; cdecl; external SDL_MIXER_LIB;
{ Plays an audio object without explicit caller-managed track ownership. }
function MIX_PlayAudio(mixer: MIX_Mixer; audio: MIX_Audio): Boolean; cdecl; external SDL_MIXER_LIB;
{ Stops a single track, optionally with fade out. }
function MIX_StopTrack(track: MIX_Track; fade_out_frames: Sint64): Boolean; cdecl; external SDL_MIXER_LIB;
{ Stops every track on a mixer, optionally with fade out. }
function MIX_StopAllTracks(mixer: MIX_Mixer; fade_out_ms: Sint64): Boolean; cdecl; external SDL_MIXER_LIB;
{ Stops all tagged tracks on a mixer, optionally with fade out. }
function MIX_StopTag(mixer: MIX_Mixer; tag: PAnsiChar; fade_out_ms: Sint64): Boolean; cdecl; external SDL_MIXER_LIB;
{ Pauses a single playing track. }
function MIX_PauseTrack(track: MIX_Track): Boolean; cdecl; external SDL_MIXER_LIB;
{ Pauses all playing tracks on a mixer. }
function MIX_PauseAllTracks(mixer: MIX_Mixer): Boolean; cdecl; external SDL_MIXER_LIB;
{ Pauses all playing tracks that match a tag. }
function MIX_PauseTag(mixer: MIX_Mixer; tag: PAnsiChar): Boolean; cdecl; external SDL_MIXER_LIB;
{ Resumes a previously paused track. }
function MIX_ResumeTrack(track: MIX_Track): Boolean; cdecl; external SDL_MIXER_LIB;
{ Resumes all paused tracks on a mixer. }
function MIX_ResumeAllTracks(mixer: MIX_Mixer): Boolean; cdecl; external SDL_MIXER_LIB;
{ Resumes all paused tracks that match a tag. }
function MIX_ResumeTag(mixer: MIX_Mixer; tag: PAnsiChar): Boolean; cdecl; external SDL_MIXER_LIB;
{ Reports whether a track is currently playing. }
function MIX_TrackPlaying(track: MIX_Track): Boolean; cdecl; external SDL_MIXER_LIB;
{ Reports whether a track is currently paused. }
function MIX_TrackPaused(track: MIX_Track): Boolean; cdecl; external SDL_MIXER_LIB;

{ Gain, rate, channel mapping, and spatial audio controls. }
{ Sets the master gain of a mixer. }
function MIX_SetMixerGain(mixer: MIX_Mixer; gain: Single): Boolean; cdecl; external SDL_MIXER_LIB;
{ Gets the master gain of a mixer. }
function MIX_GetMixerGain(mixer: MIX_Mixer): Single; cdecl; external SDL_MIXER_LIB;
{ Sets the gain of a specific track. }
function MIX_SetTrackGain(track: MIX_Track; gain: Single): Boolean; cdecl; external SDL_MIXER_LIB;
{ Gets the gain of a specific track. }
function MIX_GetTrackGain(track: MIX_Track): Single; cdecl; external SDL_MIXER_LIB;
{ Sets the gain of every track that matches a tag. }
function MIX_SetTagGain(mixer: MIX_Mixer; tag: PAnsiChar; gain: Single): Boolean; cdecl; external SDL_MIXER_LIB;
{ Sets the global playback rate ratio for a mixer. }
function MIX_SetMixerFrequencyRatio(mixer: MIX_Mixer; ratio: Single): Boolean; cdecl; external SDL_MIXER_LIB;
{ Gets the global playback rate ratio for a mixer. }
function MIX_GetMixerFrequencyRatio(mixer: MIX_Mixer): Single; cdecl; external SDL_MIXER_LIB;
{ Sets the playback rate ratio for one track. }
function MIX_SetTrackFrequencyRatio(track: MIX_Track; ratio: Single): Boolean; cdecl; external SDL_MIXER_LIB;
{ Gets the playback rate ratio for one track. }
function MIX_GetTrackFrequencyRatio(track: MIX_Track): Single; cdecl; external SDL_MIXER_LIB;
{ Overrides the output channel map for a track. }
function MIX_SetTrackOutputChannelMap(track: MIX_Track; chmap: Pcint; count: cint): Boolean; cdecl; external SDL_MIXER_LIB;
{ Applies left/right stereo gains to a track. }
function MIX_SetTrackStereo(track: MIX_Track; gains: PMIX_StereoGains): Boolean; cdecl; external SDL_MIXER_LIB;
{ Sets the 3D position of a track. }
function MIX_SetTrack3DPosition(track: MIX_Track; position: PMIX_Point3D): Boolean; cdecl; external SDL_MIXER_LIB;
{ Gets the current 3D position of a track. }
function MIX_GetTrack3DPosition(track: MIX_Track; position: PMIX_Point3D): Boolean; cdecl; external SDL_MIXER_LIB;

{ Group management and mix callbacks. }
{ Creates a group that can collect tracks inside a mixer. }
function MIX_CreateGroup(mixer: MIX_Mixer): MIX_Group; cdecl; external SDL_MIXER_LIB;
{ Destroys a group. }
procedure MIX_DestroyGroup(group: MIX_Group); cdecl; external SDL_MIXER_LIB;
{ Returns the SDL properties object associated with a group. }
function MIX_GetGroupProperties(group: MIX_Group): SDL_PropertiesID; cdecl; external SDL_MIXER_LIB;
{ Returns the mixer that owns a group. }
function MIX_GetGroupMixer(group: MIX_Group): MIX_Mixer; cdecl; external SDL_MIXER_LIB;
{ Assigns a track to a group. }
function MIX_SetTrackGroup(track: MIX_Track; group: MIX_Group): Boolean; cdecl; external SDL_MIXER_LIB;
{ Sets a callback that fires when a track stops. }
function MIX_SetTrackStoppedCallback(track: MIX_Track; cb: MIX_TrackStoppedCallback; userdata: Pointer): Boolean; cdecl; external SDL_MIXER_LIB;
{ Sets a callback for raw decoded audio on a track. }
function MIX_SetTrackRawCallback(track: MIX_Track; cb: MIX_TrackMixCallback; userdata: Pointer): Boolean; cdecl; external SDL_MIXER_LIB;
{ Sets a callback for processed track audio before final mix. }
function MIX_SetTrackCookedCallback(track: MIX_Track; cb: MIX_TrackMixCallback; userdata: Pointer): Boolean; cdecl; external SDL_MIXER_LIB;
{ Sets a post-mix callback for a track group. }
function MIX_SetGroupPostMixCallback(group: MIX_Group; cb: MIX_GroupMixCallback; userdata: Pointer): Boolean; cdecl; external SDL_MIXER_LIB;
{ Sets a post-mix callback for the whole mixer output. }
function MIX_SetPostMixCallback(mixer: MIX_Mixer; cb: MIX_PostMixCallback; userdata: Pointer): Boolean; cdecl; external SDL_MIXER_LIB;
{ Generates mixed PCM data into a caller-provided buffer. }
function MIX_Generate(mixer: MIX_Mixer; buffer: Pointer; buflen: cint): cint; cdecl; external SDL_MIXER_LIB;

{ Standalone decoder APIs for decode-only workflows. }
{ Creates a standalone decoder from a filesystem path. }
function MIX_CreateAudioDecoder(path: PAnsiChar; props: SDL_PropertiesID): MIX_AudioDecoder; cdecl; external SDL_MIXER_LIB;
{ Creates a standalone decoder from an SDL_IOStream. }
function MIX_CreateAudioDecoder_IO(io: PSDL_IOStream; closeio: Boolean; props: SDL_PropertiesID): MIX_AudioDecoder; cdecl; external SDL_MIXER_LIB;
{ Destroys a standalone decoder. }
procedure MIX_DestroyAudioDecoder(audiodecoder: MIX_AudioDecoder); cdecl; external SDL_MIXER_LIB;
{ Returns the SDL properties object associated with a decoder. }
function MIX_GetAudioDecoderProperties(audiodecoder: MIX_AudioDecoder): SDL_PropertiesID; cdecl; external SDL_MIXER_LIB;
{ Queries the output format produced by a decoder. }
function MIX_GetAudioDecoderFormat(audiodecoder: MIX_AudioDecoder; spec: PSDL_AudioSpec): Boolean; cdecl; external SDL_MIXER_LIB;
{ Decodes audio data into a caller-provided buffer. }
function MIX_DecodeAudio(audiodecoder: MIX_AudioDecoder; buffer: Pointer; buflen: cint; spec: PSDL_AudioSpec): cint; cdecl; external SDL_MIXER_LIB;

{ Compatibility section kept for the current codebase layout. }
implementation

end.
