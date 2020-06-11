unit Unit1;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Spin, ComCtrls, XPMan;

type
  TForm1 = class(TForm)
    SpinEdit1: TSpinEdit;
    Button1: TButton;
    Button2: TButton;
    OpenDialog1: TOpenDialog;
    SpinEdit2: TSpinEdit;
    Edit1: TEdit;
    XPManifest1: TXPManifest;
    procedure Button1Click(Sender: TObject);
    procedure SpinEdit2Change(Sender: TObject);
    procedure SpinEdit1Change(Sender: TObject);
    procedure Button2Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;
  leavelist: array[1..100] of smallint;

implementation

{$R *.dfm}

procedure TForm1.Button1Click(Sender: TObject);
var
  h: integer;
begin
  if opendialog1.Execute then
  begin
    h := fileopen(opendialog1.Filename, fmopenread);
    edit1.Text := opendialog1.Filename;
    fileread(h, leavelist, 200);
    fileclose(h);
    spinedit1.Value := leavelist[spinedit2.Value];
  end;
end;

procedure TForm1.SpinEdit2Change(Sender: TObject);
begin
  spinedit1.Value := leavelist[spinedit2.Value];
end;

procedure TForm1.SpinEdit1Change(Sender: TObject);
begin
  leavelist[spinedit2.Value] := spinedit1.Value;
end;

procedure TForm1.Button2Click(Sender: TObject);
var
  h: integer;
begin
  h := filecreate(edit1.Text);
  filewrite(h, leavelist, 200);
  fileclose(h);
end;

end.

 