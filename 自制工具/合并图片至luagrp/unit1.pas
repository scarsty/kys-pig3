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
  StdCtrls;

type

  { TForm1 }

  TForm1 = class(TForm)
    Button1: TButton;
    Button2: TButton;
    Edit1: TEdit;
    Edit2: TEdit;
    Edit3: TEdit;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    SelectDirectoryDialog1: TSelectDirectoryDialog;
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure Label1Click(Sender: TObject);
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

procedure TForm1.Label1Click(Sender: TObject);
begin

end;

procedure TForm1.Button1Click(Sender: TObject);
var
  i, grp, idx, pngfile, len: integer;
  w, h: word;
  bytes: array[0..1] of byte;
  offset: integer = 0;
  s: integer = 0;
  p: array[0..10000000] of byte;
begin
  grp := filecreate(label3.Caption + '/' + edit3.Text + '.grp');
  idx := filecreate(label3.Caption + '/' + edit3.Text + '.idx');
  showmessage(label3.Caption + '/' + edit3.Text + '.idx');
  for i := StrToInt(Edit1.Text) to StrToInt(Edit2.Text) do
  begin
    if FileExists(label3.Caption + '/' + IntToStr(i) + '.png') then
    begin
      pngfile := FileOpen(label3.Caption + '/' + IntToStr(i) + '.png', fmOpenRead);
    {FileSeek(pngfile, 18, 0);
    FileRead(pngfile, bytes[1], 1);
    FileRead(pngfile, bytes[0], 1);
    w := pword(@bytes[0])^;
    FileSeek(pngfile, 22, 0);
    FileRead(pngfile, bytes[1], 1);
    FileRead(pngfile, bytes[0], 1);
    h := pword(@bytes[0])^;
    FileWrite(grp, w, 2);
    FileWrite(grp, h, 2);
    FileWrite(grp, offset, 4);}
      len := FileSeek(pngfile, 0, 2);
      FileSeek(pngfile, 0, 0);
      FileRead(pngfile, p, len);
      FileWrite(grp, p, len);
      s := s + len;
      FileWrite(idx, s, 4);
      FileClose(pngfile);
    end
    else
    begin
      FileWrite(idx, s, 4);
    end;
  end;
  FileClose(grp);
  FileClose(idx);
end;

procedure TForm1.Button2Click(Sender: TObject);
begin
  if SelectDirectoryDialog1.Execute then
    label3.Caption := SelectDirectoryDialog1.FileName;
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
  label3.Caption := './';
end;

end.
