unit potdll;

interface

const
  {$IFDEF WINDOWS}
  LIB_NAME = 'smallpot.dll';
  {$ELSE}
  LIB_NAME = 'libsmallpot.so';
  {$ENDIF}

function PotCreateFromWindow(window: pointer): pointer; cdecl; external LIB_NAME;
//function PotInputVideo(pot: pointer; filename: pansichar): integer; cdecl; external LIB_NAME;
function PotPlayVideo(pot: pointer; filename: pansichar; volume: single): integer; cdecl; external LIB_NAME;

implementation

end.
