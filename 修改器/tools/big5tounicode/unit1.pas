unit Unit1;

{$mode objfpc}{$H+}

interface

uses
  Classes,
  SysUtils,
  FileUtil,
  Forms,
  Controls,
  Graphics,
  Dialogs,
  StdCtrls,
  LConvEncoding;

type

  { TForm1 }

  TForm1 = class(TForm)
    Button1: TButton;
    Button2: TButton;
    Button3: TButton;
    Edit1: TEdit;
    Edit2: TEdit;
    Edit3: TEdit;
    Edit4: TEdit;
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure Edit1Change(Sender: TObject);
  private
    { private declarations }
  public
    { public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.lfm}

{ TForm1 }

procedure TForm1.Button1Click(Sender: TObject);
var
  i: uint16;
  str: ansistring;
  wstr: WideString;
  p: pchar;
begin
  i := StrToInt(edit1.Text);
  if i > $1000 then
  begin
    edit2.Text := IntToStr(i);
    str := '  ';
    p := @i;
    str[1] := p^;
    str[2] := (p + 1)^;
    wstr := utf8decode(cp950toutf8(str));
    edit3.Text := utf8encode(wstr);
    edit4.Text := IntToStr(smallint(wstr[1]));
  end;
end;

procedure TForm1.Button2Click(Sender: TObject);
var
  h, h1: integer;
  d: uint32;
begin
  h := FileOpen('1', fmopenreadwrite);
  h1 := filecreate('2');
  while FileRead(h, d, 2) = 2 do
  begin
    if d > $1000 then
    begin
      edit1.Text := IntToStr(d);
      Button1Click(Sender);
      d := StrToInt(edit4.Text);
    end;
    FileWrite(h1, d, 2);
  end;
  FileClose(h);
  FileClose(h1);
end;

procedure TForm1.Button3Click(Sender: TObject);
var
  wstr: WideString;
begin
  wstr := utf8decode(edit3.Text);
  edit4.Text := IntToStr(smallint(wstr[1]));
end;

procedure TForm1.Edit1Change(Sender: TObject);
begin

end;

end.
