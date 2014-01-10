program kys_pig3;

//{$MODE Delphi}
{$IFDEF UNIX}
{$LINKLIB SDL_ttf}
{$LINKLIB SDL_image}
//{$LINKLIB SDL_mixer}
{$linklib SDL_gfx}
{$LINKLIB lua}
{$linklib bass}
{$linklib bassmidi}
{$ELSE}

{$ENDIF}

//{$APPTYPE CONSOLE}

uses
  Forms,
  Interfaces,
  Dialogs,
  kys_type in 'kys_type.pas',
  kys_main in 'kys_main.pas',
  kys_event in 'kys_event.pas',
  kys_battle in 'kys_battle.pas',
  kys_engine in 'kys_engine.pas',
  kys_script in 'kys_script.pas',
  kys_draw in 'kys_draw.pas',
  bass in 'lib/bass.pas',
  bassmidi in 'lib/bassmidi.pas',
  unzip in 'lib/unzip.pas', {$IFDEF MSWINDOWS}
  avcodec in 'lib/avcodec.pas',
  avformat in 'lib/avformat.pas',
  avio in 'lib/avio.pas',
  avutil in 'lib/avutil.pas',
  swscale in 'lib/swscale.pas',
  mathematics in 'lib/mathematics.pas',
  rational in 'lib/rational.pas',
  opt in 'lib/opt.pas',
  UConfig in 'lib/UConfig.pas',  //xvideo in 'lib/xvideo.pas',
 {$ENDIF}
  lua52 in 'lib/lua52.pas';

{$R *.res}

begin

  Application.Initialize;
  Run;

end.
