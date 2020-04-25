unit Unit1;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Buttons, Mask, ComCtrls, XPMan;

type
  TForm1 = class(TForm)
    OpenDialog1: TOpenDialog;
    GroupBox1: TGroupBox;
    Edit1: TEdit;
    SpeedButton1: TSpeedButton;
    OpenDialog2: TOpenDialog;
    BitBtn1: TBitBtn;
    BitBtn2: TBitBtn;
    MaskEdit14: TMaskEdit;
    Edit2: TEdit;
    SpeedButton2: TSpeedButton;
    BitBtn3: TBitBtn;
    Label1: TLabel;
    MaskEdit1: TMaskEdit;
    Label9: TLabel;
    GroupBox3: TGroupBox;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    Label8: TLabel;
    MaskEdit2: TMaskEdit;
    MaskEdit3: TMaskEdit;
    MaskEdit4: TMaskEdit;
    MaskEdit5: TMaskEdit;
    MaskEdit6: TMaskEdit;
    MaskEdit7: TMaskEdit;
    MaskEdit8: TMaskEdit;
    MaskEdit9: TMaskEdit;
    MaskEdit10: TMaskEdit;
    MaskEdit11: TMaskEdit;
    MaskEdit12: TMaskEdit;
    MaskEdit13: TMaskEdit;
    Label10: TLabel;
    MaskEdit15: TMaskEdit;
    Label11: TLabel;
    MaskEdit16: TMaskEdit;
    MaskEdit17: TMaskEdit;
    XPManifest1: TXPManifest;
    procedure BitBtn2Click(Sender: TObject);
    procedure BitBtn1Click(Sender: TObject);
    procedure BitBtn3Click(Sender: TObject);
    procedure SpeedButton1Click(Sender: TObject);
    procedure SpeedButton2Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.dfm}

procedure TForm1.BitBtn2Click(Sender: TObject);
var
  FileZ, File2, i, p, v, length, add: integer;
  ch, ch2: byte;
  address: integer;

begin
  FileZ := FileOpen(edit1.Text, fmOpenReadWrite);
  if fileZ = -1 then showmessage('Can not find Z file.')
  else begin
    Length := FileSeek(FileZ, 0, 2);
    if length < 370000 then add := -strtoint('$' + '6600') else add := 0;
    //size of dialog
    address := strtoint('$' + '2cd51');
    v := strtoint(maskedit2.Text);
    fileseek(filez, address + add, 0);
    filewrite(filez, v, 4);

    address := strtoint('$' + '2cd4f');
    v := strtoint(maskedit3.Text);
    ch := byte(v);
    fileseek(filez, address + add, 0);
    filewrite(filez, ch, 1);

    address := strtoint('$' + '2ce30');
    v := strtoint(maskedit4.Text);
    fileseek(filez, address + add, 0);
    filewrite(filez, v, 4);

    address := strtoint('$' + '2ce2e');
    v := strtoint(maskedit5.Text);
    ch := byte(v);
    fileseek(filez, address + add, 0);
    filewrite(filez, ch, 1);
    //position of dialog
    address := strtoint('$' + '2ccf0');
    v := strtoint(maskedit6.Text);
    fileseek(filez, address + add, 0);
    filewrite(filez, v, 4);
    address := strtoint('$' + '2cd34');
    v := strtoint(maskedit6.Text);
    fileseek(filez, address + add, 0);
    filewrite(filez, v, 4);

    address := strtoint('$' + '2ccf8');
    v := strtoint(maskedit7.Text);
    fileseek(filez, address + add, 0);
    filewrite(filez, v, 4);

    address := strtoint('$' + '2cd0c');
    v := strtoint(maskedit8.Text);
    fileseek(filez, address + add, 0);
    filewrite(filez, v, 4);
    address := strtoint('$' + '2cd20');
    v := strtoint(maskedit8.Text);
    fileseek(filez, address + add, 0);
    filewrite(filez, v, 4);

    address := strtoint('$' + '2cd3c');
    v := strtoint(maskedit9.Text);
    fileseek(filez, address + add, 0);
    filewrite(filez, v, 4);
    //position of head
    address := strtoint('$' + '2cce3');
    v := strtoint(maskedit10.Text);
    fileseek(filez, address + add, 0);
    filewrite(filez, v, 4);
    address := strtoint('$' + '2cd27');
    v := strtoint(maskedit10.Text);
    fileseek(filez, address + add, 0);
    filewrite(filez, v, 4);

    address := strtoint('$' + '2cce8');
    v := strtoint(maskedit11.Text);
    fileseek(filez, address + add, 0);
    filewrite(filez, v, 4);
    address := strtoint('$' + '2cd18');
    v := strtoint(maskedit11.Text);
    fileseek(filez, address + add, 0);
    filewrite(filez, v, 4);

    address := strtoint('$' + '2ccff');
    v := strtoint(maskedit12.Text);
    fileseek(filez, address + add, 0);
    filewrite(filez, v, 4);
    address := strtoint('$' + '2cd13');
    v := strtoint(maskedit12.Text);
    fileseek(filez, address + add, 0);
    filewrite(filez, v, 4);

    address := strtoint('$' + '2cd04');
    v := strtoint(maskedit13.Text);
    fileseek(filez, address + add, 0);
    filewrite(filez, v, 4);
    address := strtoint('$' + '2cd2c');
    v := strtoint(maskedit13.Text);
    fileseek(filez, address + add, 0);
    filewrite(filez, v, 4);

    address := strtoint('$' + '3da30');
    v := strtoint(maskedit14.Text);
    ch := byte(v);
    fileseek(filez, address + add, 0);
    filewrite(filez, ch, 1);

    address := strtoint('$' + '3d9e9');
    v := strtoint(maskedit15.Text);
    ch := byte(v);
    fileseek(filez, address + add, 0);
    filewrite(filez, ch, 1);

    address := strtoint('$' + '3da29');
    v := strtoint(maskedit16.Text);
    ch := byte(v);
    fileseek(filez, address + add, 0);
    filewrite(filez, ch, 1);

    address := strtoint('$' + '2cd41');
    v := strtoint(maskedit17.Text);
    ch := byte(v);
    fileseek(filez, address + add, 0);
    filewrite(filez, ch, 1);
    address := strtoint('$' + '2cd74');
    v := strtoint(maskedit17.Text);
    ch := byte(v);
    fileseek(filez, address + add, 0);
    filewrite(filez, ch, 1);
    address := strtoint('$' + '2cda9');
    v := strtoint(maskedit17.Text);
    ch := byte(v);
    fileseek(filez, address + add, 0);
    filewrite(filez, ch, 1);
    address := strtoint('$' + '2ce20');
    v := strtoint(maskedit17.Text);
    ch := byte(v);
    fileseek(filez, address + add, 0);
    filewrite(filez, ch, 1);
    address := strtoint('$' + '2ce53');
    v := strtoint(maskedit17.Text);
    ch := byte(v);
    fileseek(filez, address + add, 0);
    filewrite(filez, ch, 1);
    address := strtoint('$' + '2ce88');
    v := strtoint(maskedit17.Text);
    ch := byte(v);
    fileseek(filez, address + add, 0);
    filewrite(filez, ch, 1);

    fileclose(filez);
    showmessage('Patch Z file OK!');

  end;
end;

procedure TForm1.BitBtn1Click(Sender: TObject);
var
  FileZ, File2, i, p, Length, add: integer;
  ch, ch2: byte;
  address: array[1..30] of integer;
  size, v: array[1..30] of integer;

begin
  FileZ := FileOpen(edit1.Text, fmOpenRead);
  if fileZ = -1 then showmessage('Can not find Z file.')
  else begin
    Length := FileSeek(FileZ, 0, 2);
    if length < 370000 then add := -strtoint('$' + '6600') else add := 0;
    address[1] := strtoint('$' + '3da30'); size[1] := 1;
    address[2] := strtoint('$' + '2cd51'); size[2] := 4;
    address[3] := strtoint('$' + '2cd4f'); size[3] := 1;
    address[4] := strtoint('$' + '2ce30'); size[4] := 4;
    address[5] := strtoint('$' + '2ce2e'); size[5] := 1;
    address[6] := strtoint('$' + '2ccf0'); size[6] := 4;
    address[7] := strtoint('$' + '2ccf8'); size[7] := 4;
    address[8] := strtoint('$' + '2CD0c'); size[8] := 4;
    address[9] := strtoint('$' + '2CD3c'); size[9] := 4;
    address[10] := strtoint('$' + '2Cce3'); size[10] := 4;
    address[11] := strtoint('$' + '2Cce8'); size[11] := 4;
    address[12] := strtoint('$' + '2Ccff'); size[12] := 4;
    address[13] := strtoint('$' + '2CD04'); size[13] := 4;
    address[14] := strtoint('$' + '3d9e9'); size[14] := 1;
    address[15] := strtoint('$' + '3da29'); size[15] := 1;
    address[16] := strtoint('$' + '2cd41'); size[16] := 1;
    for i := 1 to 16 do
    begin
      v[i] := 0;
      fileseek(filez, address[i] + add, 0);
      fileread(filez, v[i], size[i]);
    end;
    maskedit2.Text := inttostr(v[2]);
    maskedit3.Text := inttostr(v[3]);
    maskedit4.Text := inttostr(v[4]);
    maskedit5.Text := inttostr(v[5]);
    maskedit6.Text := inttostr(v[6]);
    maskedit7.Text := inttostr(v[7]);
    maskedit8.Text := inttostr(v[8]);
    maskedit9.Text := inttostr(v[9]);
    maskedit10.Text := inttostr(v[10]);
    maskedit11.Text := inttostr(v[11]);
    maskedit12.Text := inttostr(v[12]);
    maskedit13.Text := inttostr(v[13]);
    maskedit14.Text := inttostr(v[1]);
    maskedit15.Text := inttostr(v[14]);
    maskedit16.Text := inttostr(v[15]);
    maskedit17.Text := inttostr(v[16]);
    fileclose(filez);

  end;
end;

procedure TForm1.BitBtn3Click(Sender: TObject);
var
  file0, fileidx, filegrp, length, i, p, x, p0, c: integer;
  ch, ch1: byte;
begin
  p0 := strtoint(Maskedit1.Text);
  p := 0;
  x := 0;
  c := 0;
  file0 := Fileopen(edit2.text, fmOpenread);
  if file0 = -1 then showmessage('Can not find the talking file.')
  else begin
    length := Fileseek(file0, 0, 2);
    filegrp := filecreate('talk1.grp');
    fileidx := filecreate('talk1.idx');
    i := 0;
    fileseek(file0, 0, 0);
    while i < length do
    begin
      fileread(file0, ch, 1);
      i := i + 1;
      if (c = 0) and (ch >= 128) and (ch <> 213) then
      begin
        filewrite(filegrp, ch, 1);
        p := p + 1;
        x := x + 1;
        c := 0;
      end;
      if ch = 213 then
      begin
      end;
      if (c = 0) and (ch < 127) and (ch > 0) then
      begin
        filewrite(filegrp, ch, 1);
        fileread(file0, ch, 1);
        i := i + 1;
        filewrite(filegrp, ch, 1);
        p := p + 1;
        x := x + 2;
      end;
      if (p >= p0) and (ch <> 0) then
      begin
        p := 0;
        ch1 := 213;
        Filewrite(filegrp, ch1, 1);
        x := x + 1;
      end;
      if (ch = 0) or (ch=255) then
      begin
        x := x + 1;
        filewrite(fileidx, x, 4);
        Filewrite(filegrp, ch, 1);
        p := 0;
      end;
    end;
    fileclose(fileidx);
    fileclose(filegrp);
    fileclose(file0);
    deletefile('talk.grp.bak');
    deletefile('talk.idx.bak');
    renamefile('talk.grp', 'talk.grp.bak');
    renamefile('talk.idx', 'talk.idx.bak');
    deletefile('talk.grp');
    deletefile('talk.idx');
    renamefile('talk1.grp', 'talk.grp');
    renamefile('talk1.idx', 'talk.idx');
    Showmessage('Patch talking file OK.');
  end;
end;

procedure TForm1.SpeedButton1Click(Sender: TObject);
begin
  if opendialog1.Execute then
  begin
    edit1.Text := opendialog1.FileName;
    form1.BitBtn1Click(sender);
  end;
end;

procedure TForm1.SpeedButton2Click(Sender: TObject);
begin
  if opendialog2.Execute then
  begin
    edit2.Text := opendialog2.FileName;
  end;
end;

end.

