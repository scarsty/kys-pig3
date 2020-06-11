unit Unit1;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Buttons, ComCtrls, XPMan;

type
  TForm1 = class(TForm)
    GroupBox1: TGroupBox;
    Label1: TLabel;
    Label2: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label18: TLabel;
    Label19: TLabel;
    Label20: TLabel;
    Label21: TLabel;
    Label22: TLabel;
    Label23: TLabel;
    Edit1: TEdit;
    Edit2: TEdit;
    Edit4: TEdit;
    Edit5: TEdit;
    Edit20: TEdit;
    Edit19: TEdit;
    Edit24: TEdit;
    Edit21: TEdit;
    Edit22: TEdit;
    Edit25: TEdit;
    GroupBox4: TGroupBox;
    Label3: TLabel;
    Label25: TLabel;
    Label26: TLabel;
    Label27: TLabel;
    Label28: TLabel;
    Label29: TLabel;
    Label30: TLabel;
    Label6: TLabel;
    Edit3: TEdit;
    Edit26: TEdit;
    Edit27: TEdit;
    Edit28: TEdit;
    Edit29: TEdit;
    Edit30: TEdit;
    Edit31: TEdit;
    Edit6: TEdit;
    GroupBox5: TGroupBox;
    Label10: TLabel;
    Label9: TLabel;
    Label7: TLabel;
    Label24: TLabel;
    Edit8: TEdit;
    Edit9: TEdit;
    Edit7: TEdit;
    Edit23: TEdit;
    GroupBox2: TGroupBox;
    Label11: TLabel;
    Label12: TLabel;
    Label13: TLabel;
    Edit10: TEdit;
    Edit11: TEdit;
    Edit12: TEdit;
    GroupBox3: TGroupBox;
    Label8: TLabel;
    Label14: TLabel;
    Label16: TLabel;
    Label17: TLabel;
    Label15: TLabel;
    Edit13: TEdit;
    Edit15: TEdit;
    Edit17: TEdit;
    Edit18: TEdit;
    Edit16: TEdit;
    CheckBox1: TCheckBox;
    OpenDialog1: TOpenDialog;
    Button1: TButton;
    BitBtn1: TBitBtn;
    Button3: TButton;
    Edit14: TEdit;
    procedure Button1Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure BitBtn1Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    function ReadFactor(FileZ: integer; Adress: integer): integer;
    procedure WriteFactor(FileZ: integer; Adress: integer; f: integer; mode: integer);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;
  iniFile: string;

implementation

uses Unit2;

{$R *.dfm}

procedure TForm1.Button1Click(Sender: TObject);
var
  Add, Adress, FileLength, i, sum, c: integer;
  FileZ, Fileini: integer;
  ch: Char;
  chs: array[1..15] of Char;
  ch1: Byte;
  str, str1: string;
  Value: Byte;
  mk, klf1, klf2, baf, daf, df, hf1, hf2, rf1, rf2, ahf, rf3, rf4: integer;
begin
  Add := -strtoint('$' + '6600');

  FileZ := FileOpen(edit14.Text, fmOpenReadWrite);
  FileLength := FileSeek(FileZ, 0, 2);
  //FileClose(FileZ);
  if filelength > 370000 then Add := 0;
  Fileini := FileOpen(iniFile, fmOpenRead);
  //showmessage(inttostr(fileini));
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
        if ((ch1 >= 48) and (ch1 <= 57)) or ((ch1 >= 65) and (ch1 <= 90)) or ((ch1 >= 97) and (ch1 <= 122)) then
          str1 := str1 + ch;
      end;
      //showmessage(str1);
      Adress := strtoint('$' + str1) + Add;
      str1 := '';
      str := lowercase(str);

      if str = 'minknowledge' then
      begin
        Edit1.Text := inttostr(ReadFactor(FileZ, Adress));
        //showmessage('');
      end;
      if str = 'knowledge1' then
      begin
        Edit2.Text := inttostr(ReadFactor(FileZ, Adress));
      end;
      if str = 'baseattack' then
      begin
        Edit4.Text := inttostr(ReadFactor(FileZ, Adress));
      end;
      if str = 'magic' then
      begin
        Edit5.Text := inttostr(ReadFactor(FileZ, Adress));
      end;
      if str = 'energy1' then
      begin
        Edit20.Text := inttostr(ReadFactor(FileZ, Adress));
      end;
      if str = 'speed1' then
      begin
        Edit21.Text := inttostr(ReadFactor(FileZ, Adress));
      end;
      if str = 'fist1' then
      begin
        Edit19.Text := inttostr(ReadFactor(FileZ, Adress));
      end;
      if str = 'sword1' then
      begin
        Edit22.Text := inttostr(ReadFactor(FileZ, Adress));
      end;
      if str = 'knife1' then
      begin
        Edit24.Text := inttostr(ReadFactor(FileZ, Adress));
      end;
      if str = 'unusual1' then
      begin
        Edit25.Text := inttostr(ReadFactor(FileZ, Adress));
      end;
      if str = 'knowledge2' then
      begin
        Edit3.Text := inttostr(ReadFactor(FileZ, Adress));
      end;
      if str = 'defence' then
      begin
        Edit6.Text := inttostr(ReadFactor(FileZ, Adress));
      end;
      if str = 'energy2' then
      begin
        Edit26.Text := inttostr(ReadFactor(FileZ, Adress));
      end;
      if str = 'speed2' then
      begin
        Edit27.Text := inttostr(ReadFactor(FileZ, Adress));
      end;
      if str = 'fist2' then
      begin
        Edit28.Text := inttostr(ReadFactor(FileZ, Adress));
      end;
      if str = 'sword2' then
      begin
        Edit30.Text := inttostr(ReadFactor(FileZ, Adress));
      end;
      if str = 'knife2' then
      begin
        Edit29.Text := inttostr(ReadFactor(FileZ, Adress));
      end;
      if str = 'unusual2' then
      begin
        Edit31.Text := inttostr(ReadFactor(FileZ, Adress));
      end;

      if str = 'hurt1' then
      begin
        Edit7.Text := inttostr(ReadFactor(FileZ, Adress));
      end;
      if str = 'hurt2' then
      begin
        Edit23.Text := inttostr(ReadFactor(FileZ, Adress));
      end;
      if str = 'random1' then
      begin
        Edit8.Text := inttostr(ReadFactor(FileZ, Adress));
      end;
      if str = 'random2' then
      begin
        Edit9.Text := inttostr(ReadFactor(FileZ, Adress));
      end;
      if str = 'addhurt' then
      begin
        Edit10.Text := inttostr(ReadFactor(FileZ, Adress));
      end;
      if str = 'random3' then
      begin
        Edit11.Text := inttostr(ReadFactor(FileZ, Adress));
      end;
      if str = 'random4' then
      begin
        Edit12.Text := inttostr(ReadFactor(FileZ, Adress));
      end;
      if str = 'lifelost' then
      begin
        FileSeek(FileZ, Adress, 0);
        FileRead(FileZ, ch, 1);
        rf4 := Byte(ch);
        Edit15.Text := inttostr(rf4);
      end;
      if str = 'minpowermed' then
      begin
        FileSeek(FileZ, Adress, 0);
        FileRead(FileZ, ch, 1);
        rf4 := Byte(ch);
        //Edit16.Text:=inttostr(rf4);
      end;
      if str = 'enhancemed' then
      begin
        FileSeek(FileZ, Adress, 0);
        FileRead(FileZ, chs, 10);
        if chs[1] = char(105) then
          Edit17.Text := inttostr(byte(chs[3]))
        else
          Edit17.Text := '0';
      end;
      if str = 'hweapon' then
      begin
        FileSeek(FileZ, Adress, 0);
        FileRead(FileZ, ch, 1);
        rf4 := Byte(ch);
        Edit18.Text := inttostr(rf4);
      end;
      if str = 'posion' then
      begin
        FileSeek(FileZ, Adress, 0);
        FileRead(FileZ, chs, 3);
        if chs[2] = char(248) then
        begin
          Edit13.Text := '-' + inttostr(byte(chs[3]));
          if chs[1] = char(209) then
            Edit13.Text := '-1';
        end;
        if chs[2] = char(224) then
        begin
          Edit13.Text := '+' + inttostr(byte(chs[3]));
          if chs[1] = char(209) then
            Edit13.Text := '+1';
        end;
        if chs[3] = char(144) then Edit13.Text := '0';
      end;
      if str = 'magicupspeed' then
      begin
        Edit16.Text := inttostr(ReadFactor(FileZ, Adress));
      end;
      if str = 'proinlevelup' then
      begin
        ch1 := Byte(ReadFactor(FileZ, Adress));
        if ch1 = 232 then checkbox1.Checked := false;
        if ch1 = 88 then checkbox1.Checked := true;
      end;
    end;
    if (ch = '/') or (ch = '[') then
    begin
      while not ((ch1 = 13) or (i = FileLength - 1)) do
      begin
        FileRead(Fileini, ch, 1);
        i := i + 1;
        ch1 := Byte(ch);
      end;
      str := '';
    end;
  end;

  FileClose(FileZ);
  FileClose(Fileini);
end;

procedure TForm1.FormCreate(Sender: TObject);
var
  FileZ: integer;
begin
  iniFile := ExtractFileDir(Application.Exename) + '\zz.ini';
  FileZ := FileOpen(edit14.text, fmOpenReadWrite);
  if FileZ <> -1 then
  begin
    FileClose(FileZ);
    Button1.Click;
  end;
end;

procedure TForm1.Button2Click(Sender: TObject);
begin
  close;
end;

procedure TForm1.BitBtn1Click(Sender: TObject);
var
  Add, Adress, FileLength, i, sum, c, f: integer;
  FileZ, Fileini: integer;
  ch: Char;
  chs: array[1..15] of Char;
  ch1: Byte;
  chs1: array[1..15] of Byte;
  str, str1: string;
  Value: Byte;
  mk, klf1, klf2, baf, daf, df, hf1, hf2, rf1, rf2, ahf, rf3, rf4: integer;
begin
  Add := -strtoint('$' + '6600');

  FileZ := FileOpen(edit14.text, fmOpenReadWrite);
  FileLength := FileSeek(FileZ, 0, 2);
  if filelength > 370000 then Add := 0;
  Fileini := FileOpen(iniFile, fmOpenRead);
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
    //if UpperCase(str)='[HURT]' then
    if ch1 = 13 then str := '';
    if ch = '=' then
    begin
      while ch <> ';' do
      begin
        FileRead(Fileini, ch, 1);
        i := i + 1;
        ch1 := Byte(ch);
        if ((ch1 >= 48) and (ch1 <= 57)) or ((ch1 >= 65) and (ch1 <= 90)) or ((ch1 >= 97) and (ch1 <= 122)) then
          str1 := str1 + ch;
      end;
      Adress := strtoint('$' + str1) + Add;
      str1 := '';
      str := lowercase(str);

      if str = 'minknowledge' then
      begin
        ch1 := byte(strtoint(Edit1.Text));
        FileSeek(FileZ, Adress, 0);
        FileWrite(FileZ, ch1, 1);
      end;
      if str = 'knowledge1' then
      begin
        f := strtoint(Edit2.Text);
        WriteFactor(FileZ, Adress, f, 1);
      end;
      if str = 'baseattack' then
      begin
        ch1 := byte(strtoint(Edit4.Text));
        FileSeek(FileZ, Adress, 0);
        FileWrite(FileZ, ch1, 1);
      end;
      if str = 'magic' then
      begin
        f := strtoint(Edit5.Text);
        WriteFactor(FileZ, Adress, f, 1);
      end;
      if str = 'energy1' then
      begin
        f := strtoint(Edit20.Text);
        WriteFactor(FileZ, Adress, f, 1);
      end;
      if str = 'speed1' then
      begin
        f := strtoint(Edit21.Text);
        WriteFactor(FileZ, Adress, f, 1);
      end;
      if str = 'fist1' then
      begin
        f := strtoint(Edit19.Text);
        WriteFactor(FileZ, Adress, f, 1);
      end;
      if str = 'sword1' then
      begin
        f := strtoint(Edit22.Text);
        WriteFactor(FileZ, Adress, f, 1);
      end;
      if str = 'knife1' then
      begin
        f := strtoint(Edit24.Text);
        WriteFactor(FileZ, Adress, f, 1);
      end;
      if str = 'unusual1' then
      begin
        f := strtoint(Edit25.Text);
        WriteFactor(FileZ, Adress, f, 1);
      end;
      if str = 'knowledge2' then
      begin
        f := strtoint(Edit3.Text);
        WriteFactor(FileZ, Adress, f, 1);
      end;
      if str = 'defence' then
      begin
        ch1 := byte(strtoint(Edit6.Text));
        FileSeek(FileZ, Adress, 0);
        FileWrite(FileZ, ch1, 1);
      end;
      if str = 'energy2' then
      begin
        f := strtoint(Edit26.Text);
        WriteFactor(FileZ, Adress, f, 1);
      end;
      if str = 'speed2' then
      begin
        f := strtoint(Edit27.Text);
        WriteFactor(FileZ, Adress, f, 1);
      end;
      if str = 'fist2' then
      begin
        f := strtoint(Edit28.Text);
        WriteFactor(FileZ, Adress, f, 1);
      end;
      if str = 'sword2' then
      begin
        f := strtoint(Edit30.Text);
        WriteFactor(FileZ, Adress, f, 1);
      end;
      if str = 'knife2' then
      begin
        f := strtoint(Edit29.Text);
        WriteFactor(FileZ, Adress, f, 1);
      end;
      if str = 'unusual2' then
      begin
        f := strtoint(Edit31.Text);
        WriteFactor(FileZ, Adress, f, 1);
      end;

      if str = 'hurt1' then
      begin
        ch1 := byte(strtoint(Edit7.Text));
        FileSeek(FileZ, Adress, 0);
        FileWrite(FileZ, ch1, 1);
      end;
      if str = 'hurt2' then
      begin
        ch1 := byte(strtoint(Edit23.Text));
        FileSeek(FileZ, Adress, 0);
        FileWrite(FileZ, ch1, 1);
      end;
      if str = 'random1' then
      begin
        ch1 := byte(strtoint(Edit8.Text));
        FileSeek(FileZ, Adress, 0);
        FileWrite(FileZ, ch1, 1);
      end;
      if str = 'random2' then
      begin
        ch1 := byte(strtoint(Edit9.Text));
        FileSeek(FileZ, Adress, 0);
        FileWrite(FileZ, ch1, 1);
      end;
      if str = 'addhurt' then
      begin
        ch1 := byte(strtoint(Edit10.Text));
        FileSeek(FileZ, Adress, 0);
        FileWrite(FileZ, ch1, 1);
      end;
      if str = 'random3' then
      begin
        ch1 := byte(strtoint(Edit11.Text));
        FileSeek(FileZ, Adress, 0);
        FileWrite(FileZ, ch1, 1);
      end;
      if str = 'random4' then
      begin
        ch1 := byte(strtoint(Edit12.Text));
        FileSeek(FileZ, Adress, 0);
        FileWrite(FileZ, ch1, 1);
      end;
      if str = 'lifelost' then
      begin
        FileSeek(FileZ, Adress, 0);
        rf4 := byte(strtoint(Edit15.Text));
        ch := char(rf4);
        FileWrite(FileZ, ch, 1);
      end;
      if str = 'minpowermed' then
      begin
        //FileSeek(FileZ, Adress, 0);
        //rf4:=byte(strtoint(Edit16.Text));
        //ch:=char(rf4);
        //FileWrite(FileZ, ch, 1);
      end;
      if str = 'enhancemed' then
      begin
        FileSeek(FileZ, Adress, 0);
        chs[1] := char(105);
        chs[2] := char(219);
        chs[3] := char(byte(strtoint(Edit17.Text)));
        chs[4] := char(0);
        chs[5] := char(0);
        chs[6] := char(0);
        chs[7] := char(144);
        chs[8] := char(144);
        chs[9] := char(144);
        chs[10] := char(144);
        FileWrite(FileZ, chs, 10);
      end;
      if str = 'hweapon' then
      begin
        FileSeek(FileZ, Adress, 0);
        rf4 := byte(strtoint(Edit18.Text));
        ch := char(rf4);
        FileWrite(FileZ, ch, 1);
      end;
      if str = 'magicupspeed' then
      begin
        ch1 := byte(strtoint(Edit16.Text));
        FileSeek(FileZ, Adress, 0);
        FileWrite(FileZ, ch1, 1);
      end;
      if str = 'proinlevelup' then
      begin
        {if checkbox1.Checked = true then
        begin
          chs1[1] := 88; chs1[2] := 72; chs1[3] := 144; chs1[4] := 144;
          chs1[5] := 144; chs1[6] := 144; chs1[7] := 144; chs1[8] := 144;
        end
        else begin
          chs1[1] := 232; chs1[2] := 51; chs1[3] := 30; chs1[4] := 0;
          chs1[5] := 0; chs1[6] := 131; chs1[7] := 196; chs1[8] := 4;
        end;
        FileSeek(FileZ, Adress, 0);
        FileWrite(FileZ, chs1, 8);}
      end;
      if str = 'posion' then
      begin
        FileSeek(FileZ, Adress, 0);

        if strtoint(Edit13.Text) > 1 then
        begin
          chs[1] := char(193);
          chs[2] := char(224);
          chs[3] := char(byte(abs(strtoint(Edit13.Text))));
        end;
        if strtoint(Edit13.Text) < -1 then
        begin
          chs[1] := char(193);
          chs[2] := char(248);
          chs[3] := char(byte(abs(strtoint(Edit13.Text))));
        end;
        if strtoint(Edit13.Text) = 1 then
        begin
          chs[1] := char(209);
          chs[2] := char(224);
          chs[3] := char(144);
        end;
        if strtoint(Edit13.Text) = -1 then
        begin
          chs[1] := char(209);
          chs[2] := char(248);
          chs[3] := char(144);
        end;
        if strtoint(Edit13.Text) = 0 then
        begin
          chs[1] := char(144);
          chs[2] := char(144);
          chs[3] := char(144);
        end;
        FileWrite(FileZ, chs, 3);
      end;
    end;
    if (ch = '/') or (ch = '[') then
    begin
      while not ((ch1 = 13) or (i = FileLength - 1)) do
      begin
        FileRead(Fileini, ch, 1);
        i := i + 1;
        ch1 := Byte(ch);
      end;
      str := '';
    end;
  end;

  FileClose(FileZ);
  FileClose(Fileini);
end;

procedure TForm1.Button3Click(Sender: TObject);
begin
  if OpenDialog1.Execute then
  begin
    edit14.Text := OpenDialog1.Filename;
    Button1.Click;
  end;
  //edit14.Text:=ExtractFileDir(Application.Exename);
end;

function TForm1.ReadFactor(FileZ: integer; Adress: integer): integer;
var
  ch1, ch2: Byte;
  ch: Char;
  m: integer;
  //FileZ: integer;
begin
  //FileZ:=FileOpen(edit14.text, fmOpenReadWrite);
  FileSeek(FileZ, Adress, 0);
  FileRead(FileZ, ch1, 1);
  FileSeek(FileZ, Adress - 2, 0);
  FileRead(FileZ, ch2, 1);
  m := ch1;
  if ch2 = 193 then m := -m;
  ReadFactor := m;
  //FileClose(FileZ);
end;

procedure TForm1.WriteFactor;
var
  ch: array[1..6] of Byte;
begin
  if f < 0 then begin
    ch[1] := 193;
    if mode = 1 then ch[2] := 248;
    if mode = 2 then ch[2] := 251;
    if mode = 3 then ch[2] := 249;
    if mode = 4 then ch[2] := 250;
    ch[3] := -f;
    FileSeek(FileZ, Adress - 2, 0);
    FileWrite(FileZ, ch, 3);
    FileSeek(FileZ, Adress + 1, 0);
    FileRead(FileZ, ch, 3);
    if (ch[1] = 0) and (ch[2] = 0) and (ch[3] = 0) then begin
      ch[1] := 144; ch[2] := 144; ch[3] := 144;
      FileSeek(FileZ, Adress + 1, 0);
      FileWrite(FileZ, ch, 3);
    end;
  end
  else
  begin
    ch[1] := 107;
    if mode = 1 then ch[2] := 192;
    if mode = 2 then ch[2] := 219;
    if mode = 3 then ch[2] := 201;
    if mode = 4 then ch[2] := 210;
    ch[3] := f;
    FileSeek(FileZ, Adress - 2, 0);
    FileWrite(FileZ, ch, 3);
    FileSeek(FileZ, Adress + 1, 0);
    FileRead(FileZ, ch, 3);
    if (ch[1] = 0) and (ch[2] = 0) and (ch[3] = 0) then begin
      ch[1] := 144; ch[2] := 144; ch[3] := 144;
      FileSeek(FileZ, Adress + 1, 0);
      FileWrite(FileZ, ch, 3);
    end;
  end;
end;

end.

