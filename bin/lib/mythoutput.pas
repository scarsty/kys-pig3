unit mythoutput;

{$mode delphi}

interface

{$ifdef android}
const
  LIB_NAME = 'libmythoutput.so';

function mythoutput(const str: pchar): integer; cdecl; external LIB_NAME;
function Android_ReadFiletoBuffer(p: pchar; filename: pchar; size: integer; ismalloc: integer): pchar; cdecl; external LIB_NAME;
//char* Android_ReadFiletoBuffer(char* p,char* filename,int size,int ismalloc);
{$endif}
implementation

end.

