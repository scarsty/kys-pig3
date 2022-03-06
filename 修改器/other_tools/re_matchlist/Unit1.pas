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
    SpinEdit3: TSpinEdit;
    SpinEdit4: TSpinEdit;
    Button3: TButton;
    procedure Button1Click(Sender: TObject);
    procedure SpinEdit2Change(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;
  list: array[1..100, 1..3] of smallint;

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
    fileread(h, list[1, 1], 600);
    fileclose(h);
    spinedit1.Value := list[spinedit2.Value, 1];
    spinedit3.Value := list[spinedit2.Value, 2];    
    spinedit4.Value := list[spinedit2.Value, 3];
  end;
end;

procedure TForm1.SpinEdit2Change(Sender: TObject);
begin
  spinedit1.Value := list[spinedit2.Value, 1];
  spinedit3.Value := list[spinedit2.Value, 2];
  spinedit4.Value := list[spinedit2.Value, 3];
  
end;

procedure TForm1.Button2Click(Sender: TObject);
var
  h: integer;
begin
  h := filecreate(edit1.Text);
  filewrite(h, list[1, 1], 600);
  fileclose(h);
end;

procedure TForm1.Button3Click(Sender: TObject);
begin
  list[spinedit2.Value, 1] := spinedit1.Value;
  list[spinedit2.Value, 2] := spinedit3.Value;
  list[spinedit2.Value, 3] := spinedit4.Value;
end;

end.

