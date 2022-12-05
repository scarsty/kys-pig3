{$IFDEF android}
library kys_promise;

{$ELSE}
program kys_promise;
{$ENDIF}

//{$MODE Delphi}
{$IFDEF UNIX}
{$LINKLIB SDL2}
{$LINKLIB SDL2_ttf}
{$LINKLIB SDL2_image}
//{$LINKLIB SDL_mixer}
//{$LINKLIB SDL2_gfx}
//{$LINKLIB smpeg}
//{$LINKLIB lua}
{$LINKLIB bass}
{$LINKLIB bassmidi}
{$ELSE}

{$ENDIF}

//{$APPTYPE GUI}

uses
  SysUtils,
  LCLIntf, LCLType, LMessages,
  Forms, Interfaces,
  kys_main in 'kys_main.pas',
  kys_event in 'kys_event.pas',
  kys_battle in 'kys_battle.pas',
  kys_engine in 'kys_engine.pas',
  //kys_script in 'kys_script.pas',
  kys_littlegame in 'kys_littlegame.pas',
  Dialogs;

//{$R kys_promise.res}


{$R *.res}

begin
  // Application.Title := 'KYS';
  // alpplication..Create(kysw).Enabled;
  // form1.Show;
{$ifndef android}
  Application.Initialize;
  Run;
{$endif}
end.

