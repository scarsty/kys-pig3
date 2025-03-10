unit potdll;

interface

const
  LIB_NAME = 'smallpot.dll';

function PotCreateFromWindow(window: pointer): pointer; cdecl; external LIB_NAME;
function PotInputVideo(pot: pointer; filename: pansichar): integer; cdecl; external LIB_NAME;

implementation

end.
