unit Unit1;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls;

type
  TForm1 = class(TForm)
    Button1: TButton;
    procedure Button1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.dfm}

procedure TForm1.Button1Click(Sender: TObject);
var
  e: smallint;
  i, idx, grp, offset, length, p: integer;
  check: boolean;
  k: array[0..67] of integer;
begin
  k[61] := 0;k[25] := 1;k[13] := 2;k[2] := 3;k[58] := 4;k[59] := 5;k[38] := 6;k[37] := 7;k[40] := 8;k[20] := 9;
  k[36] := 10;k[17] := 11;k[4] := 12;k[43] := 13;k[23] := 14;k[0] := 15;k[39] := 16;k[66] := 17;k[31] := 18;k[1] := 19;
  k[45] := 20;k[16] := 21;k[47] := 22;k[65] := 23;k[53] := 24;k[21] := 25;k[22] := 26;k[30] := 27;k[5] := 28;k[55] := 29;
  k[48] := 30;k[44] := 31;k[12] := 32;k[49] := 33;k[28] := 34;k[60] := 35;k[9] := 36;k[7] := 37;k[57] := 38;k[42] := 39;
  k[67] := 40;k[56] := 41;k[34] := 42;k[24] := 43;k[33] := 44;k[14] := 45;k[18] := 46;k[8] := 47;k[50] := 48;k[11] := 49;
  k[52] := 50;k[15] := 51;k[46] := 52;k[32] := 53;k[27] := 54;k[6] := 55;k[51] := 56;k[62] := 57;k[35] := 58;k[26] := 59;
  k[63] := 60;k[10] := 61;k[29] := 62;k[41] := 63;k[19] := 64;k[54] := 65;k[64] := 66;k[3] := 67;
  
  idx := fileopen('kdef.grp', fmopenreadwrite);
  length := fileseek(idx, 0, 2);
  fileseek(idx,0,0);
  grp:=filecreate('new.grp');
  for i:=0 to length div 2 do
  begin
    fileread(idx,e,2);
    for p:=0 to 67 do 
    begin
      if k[p]=e then 
      begin
        e:=p;
        filewrite(grp,e,2);
        break;
      end;
    end;
    if p=68 then filewrite(grp,e,2);
  end;
  fileclose(idx);
  fileclose(grp);
  
  showmessage('');
  
end;

end.
