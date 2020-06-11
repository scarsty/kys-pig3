unit Unit1;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, XPMan;

type
  TForm1 = class(TForm)
    Button1: TButton;
    Memo1: TMemo;
    Button2: TButton;
    XPManifest1: TXPManifest;
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
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
  file1, file2, file3, file4, i, si, p, pe: integer;
  i1, i2, i3, i4, edi, esi: integer;
  ch1, ch2, ch3, ch4: byte;

begin
  file1 := fileopen('kdef.idx', 0);
  esi := fileseek(file1, 0, 2);
  file2 := fileopen('z640.exe', 0);
  fileseek(file2, strtoint('$' + '5b565'), 0);
  fileread(file2, i1, 4);
  deletefile('new.idx');
  file3 := filecreate('new.idx');
  i1 := i1 and 15;
  edi := 0;
  i2 := 0;
  while i2 < esi - 1 do
  begin
    edi := 0;
    while edi < 15 do
    begin
      i4 := edi;
      i4 := i4 + i1;
      fileseek(file2, i4 + strtoint('$' + '5b575'), 0);
      fileread(file2, ch2, 1);
      fileseek(file1, i2, 0);
      fileread(file1, ch1, 1);
      ch1 := ch1 xor ch2;
      filewrite(file3, ch1, 1);
      i2 := i2 + 1;
      edi := edi + 1;
    end;
  end;
  fileclose(file1);
  fileclose(file2);
  fileclose(file3);

  file1 := fileopen('kdef.grp', 0);
  esi := fileseek(file1, 0, 2);
  file2 := fileopen('z640.exe', 0);
  file4 := fileopen('new.idx', 0);
  deletefile('new.grp');
  file3 := filecreate('new.grp');

  si := esi div 4;

  p := 0;
  for i := 0 to si do
  begin
    fileseek(file4, i * 4, 0);
    fileread(file4, pe, 4);
    if pe > 1677216 then break;

    fileseek(file2, strtoint('$' + '5b565'), 0);
    fileread(file2, i1, 4);

    i1 := i1 and 15;
    edi := 0;
    i2 := 0;
    while i2 < pe - p do
    begin
      edi := 0;
      while edi < 14 do
      begin
        i4 := edi;
        i4 := i4 + i1;
        fileseek(file2, i4 + strtoint('$' + '5b5b5'), 0);
        fileread(file2, ch2, 1);
        fileseek(file1, p + i2, 0);
        fileread(file1, ch1, 1);
        ch1 := ch1 xor ch2;
        fileseek(file3, p + i2, 0);
        filewrite(file3, ch1, 1);
        i2 := i2 + 1;
        edi := edi + 1;
      end;
    end;
    p := pe;
  end;
  fileclose(file1);
  fileclose(file2);
  fileclose(file3);
  fileclose(file4);

  showmessage('Patch OK! Please remove the rubbish data yourself!');

end;

procedure TForm1.Button2Click(Sender: TObject);
begin
  Close;
end;

end.

