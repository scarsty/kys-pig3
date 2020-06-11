unit Unit1;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Buttons, Grids;

type
  TForm1 = class(TForm)
    StringGrid1: TStringGrid;
    BitBtn1: TBitBtn;
    procedure BitBtn1Click(Sender: TObject);
    function Lu(x, y, a: integer): integer;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;
  AA: array[1..64, 1..64] of integer;

implementation

{$R *.dfm}

procedure TForm1.BitBtn1Click(Sender: TObject);
var
  i1, i2: integer;
begin
  AA[5, 6] := -1;
  //AA[6, 5] := -1;
  //AA[5, 4] := -1;
  AA[4, 5] := -1;
  Lu(5, 5, 20);
  for i1 := 1 to 10 do
    for i2 := 1 to 10 do
      StringGrid1.Cells[i1, i2] := inttostr(AA[i1, i2]);

end;

function TForm1.Lu(x, y, a: integer): integer;
var
  m: integer;
begin
  if a > 0 then
  begin
    a := a - 1;

    if AA[x, y] in [0..a] then
    begin
      AA[x, y] := a;
      if AA[x + 1, y] in [0..a] then
      begin
        //AA[x + 1, y] := 1;
        Lu(x + 1, y, a);
      end;
      if AA[x, y + 1] in [0..a] then
      begin
        //AA[x, y + 1] := 1;
        Lu(x, y + 1, a);
      end;
      if AA[x - 1, y] in [0..a] then
      begin
        //AA[x, y - 1] := 1;
        Lu(x - 1, y, a);
      end;
      if AA[x, y - 1] in [0..a] then
      begin
        //AA[x - 1, y] := 1;
        Lu(x, y - 1, a);
      end;
      //if AA[x, y] = 0 then AA[x, y] := a;
    end;
  end;
end;

end.

