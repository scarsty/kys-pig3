//This macro file is used to screen the "write" command
//when the program is not a console one.
//There must be a semicolon at the end of write procedure.

//Never define too many macros!!

{$macro on}
{$ifndef console}
{$define nowrite}
{$endif}
{$ifdef darwin}
{$define nowrite}
{$endif}

{$ifdef nowrite}
{$define writeln := ;//}
{$define write := ;//}
{$endif}
