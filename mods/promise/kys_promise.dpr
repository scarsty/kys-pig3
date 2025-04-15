program kys_promise;

{$APPTYPE GUI}
//{$APPTYPE CONSOLE}

uses
  SysUtils,
  windows,
  kys_main in 'kys_main.pas',
  kys_event in 'kys_event.pas',
  kys_battle in 'kys_battle.pas',
  kys_engine in 'kys_engine.pas',
  kys_littlegame in 'kys_littlegame.pas',
  Dialogs;

{$R kys_promise.res}


begin
 // Application.Title := 'KYS';
 // alpplication..Create(kysw).Enabled;
  // form1.Show;
  Run;
end.
