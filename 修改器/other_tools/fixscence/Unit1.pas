unit Unit1;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, math, Buttons, XPMan, ComCtrls, Spin;

type
  TForm1 = class(TForm)
    XPManifest1: TXPManifest;
    OpenDialog1: TOpenDialog;
    GroupBox1: TGroupBox;
    Button1: TButton;
    ProgressBar1: TProgressBar;
    GroupBox2: TGroupBox;
    BitBtn1: TBitBtn;
    Edit1: TEdit;
    SpinEdit1: TSpinEdit;
    Button2: TButton;
    Edit2: TEdit;
    procedure Button1Click(Sender: TObject);
    procedure BitBtn1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

uses unit2;

{$R *.dfm}

procedure TForm1.Button1Click(Sender: TObject);
var
  str: string;
begin
  str := '错误使用本程序可能会造成文件的永久破坏！' + char(10) + char(13) + '确认要修复吗？';
  if messagebox(0, pchar(str), 'Warning!!', mb_okcancel) = idok then
    thread1.Create(False);

end;

procedure TForm1.BitBtn1Click(Sender: TObject);
begin
  if opendialog1.Execute then
    edit1.Text := opendialog1.FileName;

end;

procedure TForm1.Button2Click(Sender: TObject);
var
  h, offset, i, legth: integer;
  f: word;
  str: string;
begin
  h := fileopen(form1.edit1.Text, fmopenreadwrite);
  offset := $6000 + $C000 * spinedit1.Value;

  fileseek(h, offset, 0);
  for i := 1 to $1000 do
  begin
    f := 65535;
    filewrite(h, f, 2);
  end;
  fileclose(h);

  str := form1.edit1.Text;
  str[length(str) - 5] := 'd';
  //showmessage(str);

  h := fileopen(str, fmopenreadwrite);
  offset := 200 * 11 * 2 * spinedit1.Value;

  fileseek(h, offset, 0);
  for i := 1 to 200 * 11 * 2 do
  begin
    f := 0;
    filewrite(h, f, 2);
  end;
  fileclose(h);

  messagebox(0, 'Remove events OK.', 'Confirm', mb_ok);

end;

end.

