unit Unit2;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ComCtrls, Buttons, StdCtrls, ExtCtrls, unit1;

type
  thread1 = class(TThread)
  private
    { Private declarations }
  protected
    procedure Execute; override;
  end;

implementation

{ Important: Methods and properties of objects in visual components can only be
  used in a method called using Synchronize, for example,

      Synchronize(UpdateCaption);

  and UpdateCaption could look like,

    procedure thread1.UpdateCaption;
    begin
      Form1.Caption := 'Updated in a thread';
    end; }

{ thread1 }

procedure thread1.Execute;
var
  filebmp, filegrp, fileidx, filegrp1, fileidx1, filecol, temp: integer;
  x_bmp, y_bmp, i, p, m, m1, i1, ifile, ifile1, offset, xm_bmp, i2, x_b0, x_b1, y_b0, y_b1, i0, e, emin: integer;
  x_grp, y_grp, x, y: word;
  bk, l, b1, b2, k, km: byte;
  line, line2, line3: array[1..256] of byte;
  ch, ch1: array[1..3] of byte;
  str: string;
  //time1,time2:real;
begin
  //time1:=time;
  form1.bitbtn1.Enabled := false;
  form1.bitbtn2.Enabled := false;
  bk := 255;
  filecol := fileopen(dir0 + 'mmap.col', fmopenread);
  if form1.CheckBox3.Checked = false
    then
  begin
    filegrp := filecreate(dir0 + form1.edit2.Text + '.grp');
    fileidx := filecreate(dir0 + form1.edit2.Text + '.idx');
  end else
  begin
    filegrp := fileopen(dir0 + form1.edit2.Text + '.grp', fmopenreadwrite);
    fileidx := fileopen(dir0 + form1.edit2.Text + '.idx', fmopenreadwrite);
    fileseek(filegrp, 0, 2);
    fileseek(fileidx, 0, 2);
  end;
  if form1.checkbox2.Checked = true then
  begin
    fileidx1 := fileopen(form1.groupbox1.Caption + form1.edit1.Text + '.idx', fmopenread);
    filegrp1 := fileopen(form1.groupbox1.Caption + form1.edit1.Text + '.grp', fmopenread);
  end;

  if form1.checkbox1.Checked = true then isfight := 2 else isfight := 1;
  form1.progressbar1.max := (strtoint(form1.edit4.Text) - strtoint(form1.edit3.Text) + 1) * isfight;
  for ifile := 1 to form1.progressbar1.max do
  begin
    form1.progressbar1.Position := ifile;
    form1.Label4.Caption := inttostr(ifile) + '/' + inttostr(form1.progressbar1.max);
    ifile1 := ifile + strtoint(form1.edit3.Text) - 1;
    if ifile > (form1.progressbar1.max div isfight) then ifile1 := ifile - (form1.progressbar1.max div isfight) + strtoint(form1.edit3.Text) - 1;
    str := '';
    while (fileexists(str) = false) and (ifile1 > 0) do
    begin
      str := form1.groupbox2.Caption + form1.edit6.text + inttostr(ifile1) + form1.edit8.text;
      if fileexists(str) = false then
      begin
        str := form1.groupbox2.Caption + form1.edit6.text + '0' + inttostr(ifile1) + form1.edit8.text;
      end;
      ifile1 := ifile1 - 1;
    end;

    form1.Image1.Picture.LoadFromFile(str);
    //form1.Image1.Picture.SaveToFile('temp.bmp');
    //form1.Image1.Picture.LoadFromFile('temp.bmp');
    form1.Image1.Canvas.Lock;
    x_bmp := form1.Image1.Picture.Width;
    y_bmp := form1.Image1.Picture.Height;

    i1 := 1;
    x_b0 := x_bmp;
    x_b1 := 0;
    y_b0 := y_bmp;
    y_b1 := 0;
    ch1[1] := byte(strtoint('$' + form1.edit5.Text));
    ch1[2] := byte(strtoint('$' + form1.edit9.Text));
    ch1[3] := byte(strtoint('$' + form1.edit10.Text));
    while i1 <= y_bmp do
    begin
      for i2 := 1 to x_bmp do
      begin
        ch[1] := getbvalue(form1.Image1.Canvas.Pixels[i2 - 1, i1 - 1]);
        ch[2] := getgvalue(form1.Image1.Canvas.Pixels[i2 - 1, i1 - 1]);
        ch[3] := getrvalue(form1.Image1.Canvas.Pixels[i2 - 1, i1 - 1]);
        if not ((ch[1] = ch1[1]) and (ch[2] = ch1[2]) and (ch[3] = ch1[3])) then
        begin
          if i2 < x_b0 then x_b0 := i2;
          if i2 > x_b1 then x_b1 := i2;
          if i1 < y_b0 then y_b0 := i1;
          if i1 > y_b1 then y_b1 := i1;
        end;
      end;
      i1 := i1 + 1;
    end;

    if form1.checkbox2.Checked = true then
    begin
      if ifile = 1 then offset := 0 else
      begin
        fileseek(fileidx1, ifile * 4 - 8, 0);
        fileread(fileidx1, offset, 4);
      end;
      fileseek(filegrp1, offset, 0);
      fileread(filegrp1, x_grp, 2);
      fileread(filegrp1, y_grp, 2);
      fileread(filegrp1, x, 2);
      fileread(filegrp1, y, 2);
    end
    else begin
      x_grp := x_b1 - x_b0 + 1;
      y_grp := y_b1 - y_b0 + 1;
      x := x_grp div 2;
      y := y_grp;
    end;

    filewrite(filegrp, x_grp, 2);
    filewrite(filegrp, y_grp, 2);
    filewrite(filegrp, x, 2);
    filewrite(filegrp, y, 2);

    i1 := y_b0;
    while i1 <= y_b1 do
    begin

      k := x_b0;
      km := 239;
      emin := 256 * 256 * 3;
      e := emin;
      while k <= x_b1 do
      begin
        ch[1] := getbvalue(form1.Image1.Canvas.Pixels[k - 1, i1 - 1]);
        ch[2] := getgvalue(form1.Image1.Canvas.Pixels[k - 1, i1 - 1]);
        ch[3] := getrvalue(form1.Image1.Canvas.Pixels[k - 1, i1 - 1]);
        ch1[1] := byte(strtoint('$' + form1.edit5.Text));
        ch1[2] := byte(strtoint('$' + form1.edit9.Text));
        ch1[3] := byte(strtoint('$' + form1.edit10.Text));
        if (ch[1] = ch1[1]) and (ch[2] = ch1[2]) and (ch[3] = ch1[3]) then
        begin
          line[k - x_b0 + 1] := 255;
        end
        else begin
          for i := 0 to 254 do
          begin
            fileseek(filecol, i * 3, 0);
            fileread(filecol, ch1[1], 3);
            e := (ch[1] - ch1[3] * 4) * (ch[1] - ch1[3] * 4) + (ch[2] - ch1[2] * 4) * (ch[2] - ch1[2] * 4) + (ch[3] - ch1[1] * 4) * (ch[3] - ch1[1] * 4);
            if e = 0 then
            begin
              km := byte(i);
              break;
            end;
            if e < emin then
            begin
              emin := e;
              km := byte(i);
            end;
          end;
          line[k - x_b0 + 1] := km;
          emin := 768 * 256;
          e := emin;
        end;
        k := k + 1;
      end;

      if ifile > (form1.progressbar1.max div isfight) then
      begin
        for i2 := 1 to x_grp do
        begin
          line3[i2] := line[x_grp + 1 - i2];
        end;
        for i2 := 1 to x_grp do
        begin
          line[i2] := line3[i2];
        end;
      end;

      m := 1;
      m1 := 1;
      i := 1;
      while i <= x_grp do
      begin
        b1 := 0;
        b2 := 0;
        m1 := m + 2;
        while (line[i] = bk) and (i <= x_grp) do
        begin
          b1 := b1 + 1;
          i := i + 1;
        end;
        line2[m] := b1;
        while (line[i] <> bk) and (i <= x_grp) do
        begin
          b2 := b2 + 1;
          line2[m1] := line[i];
          i := i + 1;
          m1 := m1 + 1;
        end;
        line2[m + 1] := b2;
        m := m1;
      end;

      m := m - 1;

      if line[x_grp] = bk then m := m - 2;

      l := byte(m);

      filewrite(filegrp, l, 1);
      filewrite(filegrp, line2[1], m);
      //end;
      i1 := i1 + 1;
    end;

    form1.Image1.Canvas.unLock;

    offset := fileseek(filegrp, 0, 2);
    filewrite(fileidx, offset, 4);
  end;

  if form1.checkbox2.Checked = true then
  begin
    fileclose(filegrp1);
    fileclose(fileidx1);
  end;

  fileclose(filegrp);
  fileclose(fileidx);
  fileclose(filecol);
  form1.bitbtn1.Enabled := true;
  form1.bitbtn2.Enabled := true;
  //time2:=time-time1;
  //form1.Label1.Caption:=timetostr(time2);
end;

end.

 