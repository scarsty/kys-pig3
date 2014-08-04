unit mythoutput;

{$mode delphi}

interface

{$ifdef android}
const
  LIB_NAME = 'libmythoutput.so';

function mythoutput(const str: pchar): integer; cdecl; external LIB_NAME;
{$endif}
implementation

end.

