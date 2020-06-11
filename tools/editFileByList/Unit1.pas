unit Unit1;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls;

type
  TForm1 = class(TForm)
    CheckBox1: TCheckBox;
    Button3: TButton;
    Panel1: TPanel;
    Edit1: TEdit;
    Edit2: TEdit;
    Button1: TButton;
    Button2: TButton;
    OpenDialog1: TOpenDialog;
    Label1: TLabel;
    OpenDialog2: TOpenDialog;
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;
  dir: string;

implementation

{$R *.dfm}

procedure TForm1.Button1Click(Sender: TObject);
begin
  if OpenDialog1.Execute then begin
    Edit1.Text := OpenDialog1.FileName;
  end;
end;

procedure TForm1.Button2Click(Sender: TObject);
begin
  if OpenDialog2.Execute then begin
    Edit2.Text := OpenDialog2.FileName;
  end;
end;

procedure TForm1.Button3Click(Sender: TObject);
var
  Add, Adress, FileLength, i, sum: integer;
  FileZ, FileL: integer;
  Buffer: PChar;
  ch: Char;
  ch1: Byte;
  str: string;
  Value: Byte;
begin
  if CheckBox1.Checked = True then
    Add := strtoint('$' + '6600')
  else Add := 0;

  FileZ := FileOpen(Edit1.Text, fmOpenReadWrite);
  FileL := FileOpen(Edit2.Text, fmOpenRead);
  if (FileZ <> -1) and (FileL <> -1) then begin
    FileLength := FileSeek(FileL, 0, 2);
    FileSeek(FileL, 0, 0);
    str := '';
    sum := 0;
    i := 0;
    while i < Filelength do
    begin
      FileRead(FileL, ch, 1);
      ch1 := Byte(ch);
      if ((ch1 >= 48) and (ch1 <= 57)) or ((ch1 >= 65) and (ch1 <= 70)) or ((ch1 >= 97) and (ch1 <= 102)) then
        str := str + ch;
      if (ch = ':') and (str <> '') then
      begin
        Adress := strtoint('$' + str) + Add;
        str := '';
      end;
      if (((ch1 = 13) or (i = FileLength - 1)) and (str <> '')) then
      begin
        //showmessage(str);
        Value := strtoint('$' + str);
        str := '';
        FileSeek(FileZ, Adress, 0);
        FileWrite(FileZ, Value, 1);
        sum := sum + 1;
      end;
      if ch = ';' then
      begin
        while not ((ch1 = 13) or (i = FileLength - 1)) do
        begin
          i := i + 1;
          FileRead(FileL, ch, 1);
          ch1 := Byte(ch);
        end
      end;
      i := i + 1;
    end;

    FileClose(FileZ);
    FileClose(FileL);
    Label1.Caption := inttostr(sum) + ' bytes modified.';
  end
  else
  begin
    //str:='Can not find file '+Edit1.Text +'.';
    showmessage('Can not find file!');
    FileClose(FileZ);
    FileClose(FileL);
  end;
end;

procedure TForm1.FormCreate(Sender: TObject);
var
  fileini: integer;
  FileLength, i: integer;
  str, str1: string;
  ch: Char;
  ch1: Byte;
begin
  dir := ExtractFileDir(Application.Exename);
  edit1.Text := dir + '\z.dat';
  edit2.Text := dir + '\list1.txt';
  //showmessage(dir);
  fileini := fileopen(dir + '\fz.ini', fmopenread);
  if fileini <> -1 then
  begin
    FileLength := FileSeek(Fileini, 0, 2);
    FileSeek(Fileini, 0, 0);
    str := '';
    str1 := '';
    i := 0;
    while i < Filelength do
    begin
      FileRead(Fileini, ch, 1);
      i := i + 1;
      ch1 := Byte(ch);
      if ((ch1 >= 48) and (ch1 <= 57)) or ((ch1 >= 65) and (ch1 <= 90)) or ((ch1 >= 97) and (ch1 <= 122)) then
        str := str + ch;
      if ch1 = 13 then str := '';
      if ch = '=' then
      begin
        while ch <> ';' do
        begin
          FileRead(Fileini, ch, 1);
          i := i + 1;
          ch1 := Byte(ch);
          if ch <> ';' then str1 := str1 + ch;
        end;
        str := lowercase(str);
        if str = 'zfile' then
        begin
          edit1.text := str1;
          str1 := '';
        end;
        if str = 'listfile' then
        begin
          edit2.text := str1;
          str1 := '';
        end;
      end
    end;
    fileclose(fileini);
  end;

end;

procedure TForm1.FormClose(Sender: TObject; var Action: TCloseAction);
var
  fileini: integer;
  str: string;
begin
  if fileexists(dir + '\fz.ini') then deletefile(dir + '\fz.ini');
  //showmessage(dir+'\fz.ini');
  fileini := filecreate(dir + '\fz.ini');
  str := 'ZFile=' + edit1.Text + ';' + char(13) + char(10);
  str := str + 'ListFile=' + edit2.Text + ';' + char(13) + char(10);
  filewrite(fileini, str[1], length(str));
  //showmessage(inttostr(sizeof(str)));
  fileclose(fileini);
end;

end.

