unit FFTypes;

interface

type
  PPPByte = ^PPByte;
  PPByte = ^PByte;

{$IFDEF BCB}
  PCardinal = ^Cardinal;
  PInt64 = ^Int64;
  PSingle = ^Single;
  PPWideChar = ^PWideChar;
  PWord = ^Word;
{$IFDEF VER140} // C++Builder 6
  PPointer = ^Pointer;
{$ENDIF}
{$ENDIF}

implementation

end.
