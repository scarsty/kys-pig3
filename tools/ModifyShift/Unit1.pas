unit Unit1;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ComCtrls, Buttons, StdCtrls, ExtCtrls, Spin, XPMan;

type
  TForm1 = class(TForm)
    StatusBar1: TStatusBar;
    OpenDialog1: TOpenDialog;
    Panel1: TPanel;
    Image1: TImage;
    Panel2: TPanel;
    SpeedButton1: TSpeedButton;
    Label1: TLabel;
    Edit1: TEdit;
    Edit3: TEdit;
    Edit4: TEdit;
    SpinEdit1: TSpinEdit;
    Edit2: TEdit;
    Edit5: TEdit;
    Button1: TButton;
    Button2: TButton;
    Button3: TButton;
    CheckBox1: TCheckBox;
    Button4: TButton;
    Button5: TButton;
    Timer1: TTimer;
    CheckBox2: TCheckBox;
    procedure FormCreate(Sender: TObject);
    procedure SpeedButton1Click(Sender: TObject);
    procedure ReadImage(imgnum: integer);
    procedure DrawPixel(x: integer; y: integer; c: Tcolor);
    procedure SpinEdit1Change(Sender: TObject);
    procedure Image1MouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer);
    procedure Image1Click(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure Image1DblClick(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure Image1MouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure CheckBox1Click(Sender: TObject);
    procedure Button4Click(Sender: TObject);
    procedure Button5Click(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
    //procedure WriteShift;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;
  dir0: string;
  sizex, shiftx: array of smallint;
  shifty: array of smallint;
  n: integer;

implementation

{$R *.dfm}

procedure TForm1.FormCreate(Sender: TObject);
begin
  dir0 := extractfilepath(application.ExeName);
end;

procedure TForm1.SpeedButton1Click(Sender: TObject);
var
  filegrp, fileidx, offset, length, i: integer;
begin
  if opendialog1.Execute then
  begin
    edit1.text := changefileext(opendialog1.FileName, '');
    filegrp := fileopen(edit1.text + '.grp', fmopenread);
    fileidx := fileopen(edit1.text + '.idx', fmopenread);
    n := fileseek(fileidx, 0, 2) div 4;
    spinedit1.Value := 1;
    spinedit1.MaxValue := n;
    setlength(sizex, n + 1);
    setlength(shiftx, n + 1);
    setlength(shifty, n + 1);
    for i := 1 to n do
    begin
      if i = 1 then offset := 0
      else begin
        fileseek(fileidx, (i - 2) * 4, 0);
        fileread(fileidx, offset, 4);
      end;
      fileseek(filegrp, offset, 0);
      fileread(filegrp, sizex[i], 2);
      fileseek(filegrp, 2, 1);
      fileread(filegrp, shiftx[i], 2);
      fileread(filegrp, shifty[i], 2);
    end;
    edit3.text := inttostr(shiftx[spinedit1.value]);
    edit4.text := inttostr(shifty[spinedit1.value]);
    fileclose(filegrp);
    fileclose(fileidx);
    readimage(spinedit1.value);
    statusbar1.Panels[0].Text := edit1.Text;
    statusbar1.Panels[1].Text := inttostr(n) + ' images.';
    button1.Enabled := true;
    button2.Enabled := true;
  end;
end;

procedure TForm1.ReadImage(imgnum: integer);
var
  filegrp, fileidx, filecol, offset, length, n, p: integer;
  x, y, sx, sy: smallint;
  l, l1, l2, ix, iy: byte;
  ch: array[1..3] of byte;
begin
  image1.Canvas.Brush.Color := clsilver;
  Image1.Canvas.FillRect(rect(0, 0, image1.width, image1.height));
  filegrp := fileopen(edit1.text + '.grp', fmopenread);
  fileidx := fileopen(edit1.text + '.idx', fmopenread);
  filecol := fileopen(dir0 + 'mmap.col', fmopenread);

  if imgnum = 1 then offset := 0
  else begin
    fileseek(fileidx, (imgnum - 2) * 4, 0);
    fileread(fileidx, offset, 4);
  end;
  fileseek(filegrp, offset, 0);
  fileread(filegrp, x, 2);
  fileread(filegrp, y, 2);
  fileread(filegrp, sx, 2);
  fileread(filegrp, sy, 2);
  //    showmessage(inttostr(x));
  for iy := 1 to y do
  begin
    fileread(filegrp, l, 1);
    //showmessage(inttostr(l));
    x := 1;
    p := 0;
    for ix := 1 to l do
    begin
      fileread(filegrp, l1, 1);
      if p = 0 then
      begin
        x := x + l1;
        p := 1;
      end else
        if p = 1 then
        begin
          p := 2 + l1;
        end else
          if p > 2 then
          begin
            p := p - 1;
            fileseek(filecol, l1 * 3, 0);
            fileread(filecol, ch[1], 3);
            if checkbox2.Checked = false then
              Drawpixel(x, iy, rgb(ch[1] * 4, ch[2] * 4, ch[3] * 4))
            else
              Drawpixel(x + sx, iy + sy, rgb(ch[1] * 4, ch[2] * 4, ch[3] * 4));
            x := x + 1;
            //showmessage(inttostr(ch[1]*4*256*256+ch[2]*4*256+ch[3]*4));
            if p = 2 then
            begin
              p := 0;
            end;
          end;
    end;
  end;
  fileclose(filegrp);
  fileclose(fileidx);
  fileclose(filecol);
  edit3.text := inttostr(shiftx[spinedit1.value]);
  edit4.text := inttostr(shifty[spinedit1.value]);
  x := shiftx[spinedit1.value];
  y := shifty[spinedit1.value];
  drawpixel(x + 1, y, clred);
  drawpixel(x - 1, y, clred);
  drawpixel(x, y + 1, clred);
  drawpixel(x, y - 1, clred);
  x := 0;
  y := 0;
  drawpixel(x + 1, y, clblack);
  drawpixel(x - 1, y, clblack);
  drawpixel(x, y + 1, clblack);
  drawpixel(x, y - 1, clblack);

end;

procedure TForm1.SpinEdit1Change(Sender: TObject);
begin
  readimage(spinedit1.Value);
end;

procedure TForm1.Image1MouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer);
begin
  edit2.Text := inttostr((x - 40) div 2);
  edit5.Text := inttostr((y - 40) div 2);
end;

procedure Tform1.DrawPixel(x: integer; y: integer; c: Tcolor);
var
  i1, i2: integer;
begin
  for i1 := 0 to 1 do
    for i2 := 0 to 1 do
      image1.Canvas.Pixels[x * 2 + i1 + 40, y * 2 + i2 + 40] := c;

end;

procedure TForm1.Image1Click(Sender: TObject);
begin
  edit3.Text := edit2.Text;
  edit4.text := edit5.Text;
end;

procedure TForm1.Button1Click(Sender: TObject);
begin
  shiftx[spinedit1.value] := strtoint(edit3.Text);
  shifty[spinedit1.value] := strtoint(edit4.Text);
  readimage(spinedit1.value);
end;

procedure TForm1.Image1DblClick(Sender: TObject);
begin
  image1click(Sender);
  Button1Click(Sender);
end;

procedure TForm1.Button2Click(Sender: TObject);
var
  filegrp, fileidx, i, offset: integer;
begin
  if checkbox1.Checked = true then
  begin
    for i := 1 to (n div 2) do
    begin
      shiftx[i + (n div 2)] := sizex[i] - shiftx[i];
      shifty[i + (n div 2)] := shifty[i];
    end;
  end;
  filegrp := fileopen(edit1.text + '.grp', fmopenreadwrite);
  fileidx := fileopen(edit1.text + '.idx', fmopenreadwrite);
  for i := 1 to n do
  begin
    if i = 1 then offset := 0
    else begin
      fileseek(fileidx, (i - 2) * 4, 0);
      fileread(fileidx, offset, 4);
    end;
    fileseek(filegrp, offset + 4, 0);
    filewrite(filegrp, shiftx[i], 2);
    filewrite(filegrp, shifty[i], 2);
  end;
  fileclose(filegrp);
  fileclose(fileidx);
end;

procedure TForm1.Button3Click(Sender: TObject);
begin
  close;
end;

procedure TForm1.Image1MouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  if button = mbright then
  begin
    if spinedit1.Value < spinedit1.MaxValue then
    begin
      spinedit1.value := spinedit1.Value + 1;
      //readimage(spinedit1.Value);
    end;
  end;
end;

procedure TForm1.CheckBox1Click(Sender: TObject);
begin
  if checkbox1.Checked = true then spinedit1.MaxValue := n div 2
  else spinedit1.MaxValue := n;
  spinedit1.Value := 1;
end;

procedure TForm1.Button4Click(Sender: TObject);
var
  i: integer;
begin
  for i := 1 to n do 
  begin
    shiftx[i] := strtoint(edit3.Text);
    shifty[i] := strtoint(edit4.Text);
  end;
  readimage(spinedit1.value);
end;

procedure TForm1.Button5Click(Sender: TObject);
var
  i: integer;
begin
  Timer1.Enabled := true;
  spinedit1.Value := 1;
end;

procedure TForm1.Timer1Timer(Sender: TObject);
begin
  spinedit1.Value := spinedit1.Value + 1;
  if spinedit1.Value = spinedit1.MaxValue then Timer1.Enabled := false;
end;

end.

