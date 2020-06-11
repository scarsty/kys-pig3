unit Unit1;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Buttons, XPMan;

type
  TForm1 = class(TForm)
    Button1: TButton;
    GroupBox1: TGroupBox;
    Edit1: TEdit;
    Edit2: TEdit;
    Edit4: TEdit;
    Edit5: TEdit;
    Edit6: TEdit;
    Edit7: TEdit;
    Edit8: TEdit;
    Edit9: TEdit;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    Label9: TLabel;
    Label10: TLabel;
    GroupBox2: TGroupBox;
    Edit10: TEdit;
    Edit11: TEdit;
    Edit12: TEdit;
    Label11: TLabel;
    Label12: TLabel;
    Label13: TLabel;
    Button2: TButton;
    BitBtn1: TBitBtn;
    Edit3: TEdit;
    Button3: TButton;
    OpenDialog1: TOpenDialog;
    Edit14: TEdit;
    GroupBox3: TGroupBox;
    Edit13: TEdit;
    Label8: TLabel;
    Label14: TLabel;
    Edit15: TEdit;
    Edit16: TEdit;
    Label15: TLabel;
    Label16: TLabel;
    Edit17: TEdit;
    Edit18: TEdit;
    Label17: TLabel;
    XPManifest1: TXPManifest;
    Label18: TLabel;
    Edit19: TEdit;
    CheckBox1: TCheckBox;
    procedure Button1Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure BitBtn1Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
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
  chs, chs1: array[1..15] of Char;
  ch1: Byte;
  str, str1: string;
  Value: Byte;
  mk, klf1, klf2, baf, daf, df, hf1, hf2, rf1, rf2, ahf, rf3, rf4: integer;
begin
  Add := -strtoint('$' + '6600');

  FileZ := FileOpen(edit14.Text, fmOpenReadWrite);
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
        FileSeek(FileZ, Adress, 0);
        FileRead(FileZ, ch, 1);
        mk := Byte(ch);
        Edit1.Text := inttostr(mk);
      end;
      if str = 'knowledgefactor1' then
      begin
        FileSeek(FileZ, Adress, 0);
        FileRead(FileZ, chs, 2);
        if chs[1] + chs[2] = char(01) + char(192) then klf1 := 2
        else if chs[1] + chs[2] = char(144) + char(144) then klf1 := 1
        else if chs[1] + chs[2] = char(49) + char(192) then klf1 := 0
        else klf1 := -1;
        Edit2.Text := inttostr(klf1);
      end;
      if str = 'knowledgefactor2' then
      begin
        FileSeek(FileZ, Adress, 0);
        FileRead(FileZ, chs, 2);
        if chs[1] + chs[2] = char(01) + char(192) then klf2 := 2
        else if chs[1] + chs[2] = char(144) + char(144) then klf2 := 1
        else if chs[1] + chs[2] = char(49) + char(192) then klf2 := 0
        else klf1 := -1;
        Edit3.Text := inttostr(klf2);
      end;
      if str = 'baseattackfactor' then
      begin
        FileSeek(FileZ, Adress, 0);
        FileRead(FileZ, chs, 7);
        if chs[1] = char(137) then baf := 3
        else baf := byte(chs[3]);
        Edit4.Text := inttostr(baf);
      end;
      if str = 'divattackfactor' then
      begin
        FileSeek(FileZ, Adress, 0);
        FileRead(FileZ, chs, 2);
        if chs[2] = char(144) then daf := 1;
        if chs[2] = char(224) then daf := 2;
        if chs[2] = char(248) then daf := -1;
        Edit5.Text := inttostr(daf);
        if daf = -1 then Edit5.Text := '1/2';
      end;
      if str = 'defencefactor' then
      begin
        FileSeek(FileZ, Adress, 0);
        FileRead(FileZ, chs, 7);
        if chs[1] = char(105) then df := byte(chs[3])
        else df := 3;
        Edit6.Text := inttostr(df);
      end;
      if str = 'hurtfactor' then
      begin
        FileSeek(FileZ, Adress, 0);
        FileRead(FileZ, ch, 1);
        hf1 := byte(ch);
        Edit7.Text := inttostr(hf1);
      end;
      if str = 'randomfactor1' then
      begin
        FileSeek(FileZ, Adress, 0);
        FileRead(FileZ, ch, 1);
        rf1 := Byte(ch);
        Edit8.Text := inttostr(rf1);
      end;
      if str = 'randomfactor2' then
      begin
        FileSeek(FileZ, Adress, 0);
        FileRead(FileZ, ch, 1);
        rf2 := Byte(ch);
        Edit9.Text := inttostr(rf2);
      end;
      if str = 'addhurtfactor' then
      begin
        FileSeek(FileZ, Adress, 0);
        FileRead(FileZ, ch, 1);
        ahf := Byte(ch);
        Edit10.Text := inttostr(ahf);
      end;
      if str = 'randomfactor3' then
      begin
        FileSeek(FileZ, Adress, 0);
        FileRead(FileZ, ch, 1);
        rf3 := Byte(ch);
        Edit11.Text := inttostr(rf3);
      end;
      if str = 'randomfactor4' then
      begin
        FileSeek(FileZ, Adress, 0);
        FileRead(FileZ, ch, 1);
        rf4 := Byte(ch);
        Edit12.Text := inttostr(rf4);
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
        Edit16.Text := inttostr(rf4);
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
      if str = 'magicupspeed' then
      begin
        FileSeek(FileZ, Adress, 0);
        FileRead(FileZ, ch, 1);
        rf4 := Byte(ch);
        Edit19.Text := inttostr(rf4);
      end;
      if str = 'proinlevelup' then
      begin
        FileSeek(FileZ, Adress, 0);
        FileRead(FileZ, ch1, 1);
        if ch1 = 232 then checkbox1.Checked := false;
        if ch1 = 88 then checkbox1.Checked := true;
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
  Form2.Show;
end;

procedure TForm1.BitBtn1Click(Sender: TObject);
var
  Add, Adress, FileLength, i, sum, c: integer;
  FileZ, Fileini: integer;
  ch: Char;
  chs: array[1..15] of Char;
  ch1: Byte;
  chs1: array[1..15] of byte;
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
        FileSeek(FileZ, Adress, 0);
        mk := byte(strtoint(Edit1.Text));
        ch := char(mk);
        FileWrite(FileZ, ch, 1);
      end;
      if str = 'knowledgefactor1' then
      begin
        FileSeek(FileZ, Adress, 0);
        klf1 := strtoint(Edit2.Text);
        case klf1 of
          2: begin
              chs[1] := char(01); chs[2] := char(192);
            end;
          1: begin
              chs[1] := char(144); chs[2] := char(144);
            end;
          0: begin
              chs[1] := char(49); chs[2] := char(192);
            end;
        end;
        FileWrite(FileZ, chs, 2);
      end;
      if str = 'knowledgefactor2' then
      begin
        FileSeek(FileZ, Adress, 0);
        klf2 := strtoint(Edit3.Text);
        case klf2 of
          2: begin
              chs[1] := char(01); chs[2] := char(192);
            end;
          1: begin
              chs[1] := char(144); chs[2] := char(144);
            end;
          0: begin
              chs[1] := char(49); chs[2] := char(192);
            end;
        end;
        FileWrite(FileZ, chs, 2);
      end;
      if str = 'baseattackfactor' then
      begin
        FileSeek(FileZ, Adress, 0);
        chs[1] := char(105);
        chs[2] := char(194);
        chs[3] := char(strtoint(Edit4.Text));
        chs[4] := char(0);
        chs[5] := char(0);
        chs[6] := char(0);
        chs[7] := char(144);
        FileWrite(FileZ, chs, 7);
      end;
      if str = 'divattackfactor' then
      begin
        FileSeek(FileZ, Adress, 0);
        if (Edit5.Text = '1/2') or (Edit5.Text = '0.5') then
        begin
          chs[1] := char(209);
          chs[2] := char(248);
        end else
        begin
          if strtoint(Edit5.Text) = 1 then
          begin
            chs[1] := char(144);
            chs[2] := char(144);
          end;
          if strtoint(Edit5.Text) = 2 then
          begin
            chs[1] := char(209);
            chs[2] := char(224);
          end;
        end;
        FileWrite(FileZ, chs, 2);
      end;
      if str = 'defencefactor' then
      begin
        FileSeek(FileZ, Adress, 0);
        chs[1] := char(105);
        chs[2] := char(194);
        chs[3] := char(strtoint(Edit6.Text));
        chs[4] := char(0);
        chs[5] := char(0);
        chs[6] := char(0);
        chs[7] := char(144);
        FileWrite(FileZ, chs, 7);
      end;
      if str = 'hurtfactor' then
      begin
        FileSeek(FileZ, Adress, 0);
        hf1 := Byte(strtoint(Edit7.Text));
        ch := char(hf1);
        FileWrite(FileZ, ch, 1);
      end;
      if str = 'randomfactor1' then
      begin
        FileSeek(FileZ, Adress, 0);
        rf1 := Byte(strtoint(Edit8.Text));
        ch := char(rf1);
        FileWrite(FileZ, ch, 1);
      end;
      if str = 'randomfactor2' then
      begin
        FileSeek(FileZ, Adress, 0);
        rf2 := Byte(strtoint(Edit9.Text));
        ch := char(rf2);
        FileWrite(FileZ, ch, 1);
      end;
      if str = 'addhurtfactor' then
      begin
        FileSeek(FileZ, Adress, 0);
        ahf := Byte(strtoint(Edit10.Text));
        ch := char(ahf);
        FileWrite(FileZ, ch, 1);
      end;
      if str = 'randomfactor3' then
      begin
        FileSeek(FileZ, Adress, 0);
        rf3 := Byte(strtoint(Edit11.Text));
        ch := char(rf3);
        FileWrite(FileZ, ch, 1);
      end;
      if str = 'randomfactor4' then
      begin
        FileSeek(FileZ, Adress, 0);
        rf4 := Byte(strtoint(Edit12.Text));
        ch := char(rf4);
        FileWrite(FileZ, ch, 1);
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
        FileSeek(FileZ, Adress, 0);
        rf4 := byte(strtoint(Edit16.Text));
        ch := char(rf4);
        FileWrite(FileZ, ch, 1);
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
        FileSeek(FileZ, Adress, 0);
        rf4 := byte(strtoint(Edit19.Text));
        ch := char(rf4);
        FileWrite(FileZ, ch, 1);
      end;
      if str = 'proinlevelup' then
      begin
        if checkbox1.Checked = true then
        begin
          chs1[1] := 88; chs1[2] := 72; chs1[3] := 144; chs1[4] := 144;
          chs1[5] := 144; chs1[6] := 144; chs1[7] := 144; chs1[8] := 144;
        end
        else begin
          chs1[1] := 232; chs1[2] := 51; chs1[3] := 30; chs1[4] := 0;
          chs1[5] := 0; chs1[6] := 131; chs1[7] := 196; chs1[8] := 4;
        end;
        FileSeek(FileZ, Adress, 0);
        FileWrite(FileZ, chs1, 8);
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

end.

