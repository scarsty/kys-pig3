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
file1, file2, file3, p, i:integer;
str: array [1..256] of char;
begin
  file1:=fileopen('hdgrp.grp',fmopenreadwrite);
  file2:=fileopen('hdgrp.idx',fmopenreadwrite);
  file3:=fileopen('1',fmopenreadwrite);
  fileseek(file3,0,0);
  fileread(file3,str,85);
  showmessage(str);
  p:=378855-85;
  fileseek(file1,0,2);
  fileseek(file2,0,2);
  for i:=1 to 220 do
  begin
    filewrite(file1,str,85);
    p:=p+85;
    filewrite(file2,p,4);
    
  end;
  
end;

end.
