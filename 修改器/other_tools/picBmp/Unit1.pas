unit Unit1;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Buttons, strutils, ComCtrls, ExtCtrls, XPMan;

type
  TForm1 = class(TForm)
    GroupBox1: TGroupBox;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Edit1: TEdit;
    Edit3: TEdit;
    Edit4: TEdit;
    Edit5: TEdit;
    GroupBox2: TGroupBox;
    Edit6: TEdit;
    Edit8: TEdit;
    SpeedButton1: TSpeedButton;
    SpeedButton2: TSpeedButton;
    OpenDialog1: TOpenDialog;
    OpenDialog2: TOpenDialog;
    Edit7: TEdit;
    Edit9: TEdit;
    Edit10: TEdit;
    CheckBox1: TCheckBox;
    CheckBox2: TCheckBox;
    GroupBox3: TGroupBox;
    BitBtn1: TBitBtn;
    BitBtn2: TBitBtn;
    Edit2: TEdit;
    Label6: TLabel;
    ProgressBar1: TProgressBar;
    Label4: TLabel;
    CheckBox3: TCheckBox;
    Image1: TImage;
    XPManifest1: TXPManifest;
    Button1: TButton;
    procedure BitBtn1Click(Sender: TObject);
    procedure BitBtn2Click(Sender: TObject);
    procedure SpeedButton1Click(Sender: TObject);
    procedure SpeedButton2Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    //function  rle8(str1:string; bk:byte):string;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;
  dir0, dir1, dir2: string;
  a1, a2, isFight: integer;

implementation

uses unit2;
{$R *.dfm}

procedure TForm1.BitBtn1Click(Sender: TObject);
begin
  //form3.Image1.Canvas.Lock;
  thread1.Create(false);

end;

procedure TForm1.BitBtn2Click(Sender: TObject);
begin
  close;
end;

procedure TForm1.SpeedButton1Click(Sender: TObject);
var
  str: string;
  i: integer;
  ch: char;
begin
  opendialog1.initialdir := dir1;
  if opendialog1.Execute then
  begin
    groupbox2.Caption := extractfilepath(opendialog1.FileName);
    str := extractfilename(opendialog1.FileName);
    i := 0;
    while i < length(str) do
    begin
      ch := str[i + 1];
      if (ch >= '0') and (ch <= '9') then
      begin
        edit6.Text := leftbstr(str, i);
        break;
      end;
      i := i + 1;
    end;
    while i < length(str) do
    begin
      ch := str[i + 1];
      if (ch < '0') or (ch > '9') then
      begin
        edit8.Text := rightbstr(str, length(str) - i);
        break;
      end;
      i := i + 1;
    end;
    a1 := 1;
  end;
  dir1 := opendialog1.initialdir;
  if a1 * a2 <> 0 then bitbtn1.Enabled := true;
end;

procedure TForm1.SpeedButton2Click(Sender: TObject);
var
  fileidx, length: integer;
begin
  opendialog2.initialdir := dir2;
  if opendialog2.Execute then
  begin
    groupbox1.Caption := extractfilepath(opendialog2.FileName);
    fileidx := fileopen(opendialog2.FileName, fmopenread);
    length := fileseek(fileidx, 0, 2);
    edit4.Text := inttostr(length div 8);
    edit1.Text := changefileext(extractfilename(opendialog2.FileName), '');
    fileclose(fileidx);
    a2 := 1;
  end;
  dir2 := opendialog2.initialdir;
  if a1 * a2 <> 0 then bitbtn1.Enabled := true;
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
  dir1 := '.';
  dir2 := '.';
  a1 := 0;
  a2 := 0;
  dir0 := extractfilepath(application.ExeName);
  isFight := 1;
  //showmessage(dir0);
end;

procedure TForm1.Button1Click(Sender: TObject);
begin
  image1.Picture.LoadFromFile(groupbox2.Caption + edit6.text + '1' + edit8.text);
  form1.Image1.Picture.SaveToFile('temp.bmp');
  form1.Image1.Picture.LoadFromFile('temp.bmp');
end;

end.

