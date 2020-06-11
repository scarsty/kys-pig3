unit Unit1;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls;

type
  TForm1 = class(TForm)
    Button1: TButton;
    Button2: TButton;
    Button3: TButton;
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
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
  p, i, m: integer;
begin
  p := filecreate('a.bin');
  for i:= 1 to 100 do
  begin
    //m := exp(i);
    filewrite(p,m,2);
    
  end;
end;

procedure TForm1.Button2Click(Sender: TObject);
var
  p: Pbyte;
  s: integer;
  a: integer;

begin
  a:=3467;
  p:=@a;
  s:=0;
  s:=s+p^;
  
  button2.Caption:=inttostr(sizeof(integer));
  inc(p);
end;

procedure TForm1.Button3Click(Sender: TObject);
var
  a, b, l, i: integer;
  p: byte;
begin
  a := fileopen('talk.grp', fmOpenReadWrite);
  l := fileseek(a, 0, 2);
  b := filecreate('a.grp');
  fileseek(a, 0, 0);
  for i := 0 to l - 1 do
  begin
    fileread(a, p, 1);
    p := p xor $FF;
    filewrite(b, p, 1);
    
  end;

  fileclose(a);
  fileclose(b);
end;

end.
