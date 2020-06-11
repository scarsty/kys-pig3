unit Unit1;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ComCtrls, Buttons, StdCtrls, ExtCtrls, Spin,
  pngimage;

type
  TForm1 = class(TForm)
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
    Button6: TButton;
    Button7: TButton;
    Button8: TButton;
    Button9: TButton;
    SpinEdit2: TSpinEdit;
    Image3: TImage;
    Button10: TButton;
    Edit6: TEdit;
    Edit7: TEdit;
    Button11: TButton;
    Button12: TButton;
    procedure FormCreate(Sender: TObject);
    procedure SpeedButton1Click(Sender: TObject);
    procedure ReadImage(imgnum: integer);
    procedure DrawPixel(x: integer; y: integer; c: Tcolor);
    procedure SpinEdit1Change(Sender: TObject);
    procedure Image1MouseMove(Sender: TObject; Shift: TShiftState; x, y: integer);
    procedure Image1Click(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure Image1DblClick(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure Image1MouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; x, y: integer);
    procedure CheckBox1Click(Sender: TObject);
    procedure Button4Click(Sender: TObject);
    procedure Button5Click(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
    procedure SpinEdit2Change(Sender: TObject);
    procedure FormResize(Sender: TObject);
    procedure Button6Click(Sender: TObject);
    procedure Button7Click(Sender: TObject);
    procedure Button8Click(Sender: TObject);
    procedure Button9Click(Sender: TObject);
    procedure Image3MouseMove(Sender: TObject; Shift: TShiftState; x, y: integer);
    procedure Image3Click(Sender: TObject);
    procedure Image3DblClick(Sender: TObject);
    procedure Button10Click(Sender: TObject);
    procedure Image1MouseUp(Sender: TObject; Button: TMouseButton; Shift: TShiftState; x, y: integer);
    procedure Edit6Change(Sender: TObject);
    procedure Edit7Change(Sender: TObject);
    procedure Button11Click(Sender: TObject);
    procedure Button12Click(Sender: TObject);
    // procedure WriteShift;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;
  dir0: string;
  sizex, shiftx, shifty: array [0 .. 9999] of smallint;
  n: integer;
  PngGround, png: TPngImage;
  trancol, trancol2: Tcolor;
  bx: integer = 200;
  by: integer = 200;
  scale: integer = 1;
  drag: integer = 0;
  dragx, dragy, dragx0, dragy0, px, py: integer;

implementation

{$R *.dfm}

uses
  unit2;

procedure TForm1.FormCreate(Sender: TObject);
begin
  dir0 := extractfilepath(application.ExeName);
  PngGround := TPngImage.Create;
  PngGround.LoadFromFile('ground.png');
  trancol := PngGround.Canvas.Pixels[0, 0];
  { bx := Image1.Width div 2;
    by := Image1.Height -50*scale; }
  scale := SpinEdit2.Value;
end;

procedure TForm1.FormResize(Sender: TObject);
begin
  Image1.Picture.Bitmap.Width := Image1.Width;
  Image1.Picture.Bitmap.Height := Image1.Height;
  SpinEdit2Change(Sender);
end;

procedure TForm1.SpeedButton1Click(Sender: TObject);
var
  filegrp, fileka, offset, length, i: integer;
begin
  if OpenDialog1.Execute then
  begin
    Edit1.text := changefileext(OpenDialog1.FileName, '');
    // filegrp := fileopen(edit1.text + '.grp', fmopenread);
    fileka := fileopen(Edit1.text + '.ka', fmopenread);
    n := fileseek(fileka, 0, 2) div 4 - 1;
    fileseek(fileka, 0, 0);
    SpinEdit1.Value := 0;
    SpinEdit1.MaxValue := n;
    // setlength(sizex, n + 1);
    // setlength(shiftx, n + 1);
    // setlength(shifty, n + 1);
    for i := 0 to n do
    begin
      // fileseek(fileka, offset, 0);
      // fileread(filegrp, sizex[i], 2);
      // fileseek(filegrp, 2, 1);
      fileread(fileka, shiftx[i], 2);
      fileread(fileka, shifty[i], 2);
    end;
    // fileread(fileka, );
    Edit3.text := inttostr(shiftx[SpinEdit1.Value]);
    Edit4.text := inttostr(shifty[SpinEdit1.Value]);
    // fileclose(filegrp);
    fileclose(fileka);
    ReadImage(SpinEdit1.Value);
    // StatusBar1.Panels[0].text := Edit1.text;
    // StatusBar1.Panels[1].text := inttostr(n) + ' images.';
    Button1.Enabled := true;
    Button2.Enabled := true;
    px := shiftx[SpinEdit1.Value];
    py := shifty[SpinEdit1.Value];
  end;
end;

procedure TForm1.ReadImage(imgnum: integer);
var
  filegrp, fileidx, filecol, offset, length, n, p: integer;
  x, y, sx, sy: smallint;
  l, l1, l2, ix, iy: smallint;
  ch: array [1 .. 3] of byte;
  FileName: string;
  col: Tcolor;
begin
  if OpenDialog1.FileName <> '' then
  begin
    Image1.Canvas.Brush.Color := clsilver;
    Image1.Canvas.FillRect(rect(0, 0, Image1.Width, Image1.Height));
    FileName := extractfilepath(OpenDialog1.FileName) + inttostr(SpinEdit1.Value) + '.png';
    if fileexists(FileName) then
    begin
      for ix := 0 to PngGround.Width - 1 do
        for iy := 0 to PngGround.Height - 1 do
        begin
          col := PngGround.Pixels[ix, iy];
          if col <> PngGround.TransparentColor then
            DrawPixel(ix - 18, iy - 17, col);
        end;

      png := TPngImage.Create;
      png.LoadFromFile(FileName);
      Image3.Picture.LoadFromFile(FileName);

      x := shiftx[SpinEdit1.Value];
      y := shifty[SpinEdit1.Value];
      for ix := 0 to png.Width - 1 do
        for iy := 0 to png.Height - 1 do
        begin
          if (png.AlphaScanline[iy]^)[ix] <> 0 then
          begin
            col := png.Canvas.Pixels[ix, iy];
            // writeln(col);
            // col := image3.Picture.Bitmap.Canvas.Pixels[ix,iy];
            DrawPixel(ix - x, iy - y, col);
          end;
        end;
      // image1.Canvas.Draw(bx,by,Image3.Picture.Graphic);
      png.Free;

      Edit3.text := inttostr(x);
      Edit4.text := inttostr(y);
      sx := bx - x * scale;
      sy := by - y * scale;
      Image1.Canvas.Pen.Color := clblack;
      Image1.Canvas.MoveTo(0, sy);
      Image1.Canvas.LineTo(Image1.Width, sy);
      Image1.Canvas.MoveTo(sx, 0);
      Image1.Canvas.LineTo(sx, Image1.Height);
      Image1.Canvas.Pen.Color := clred;
      Image1.Canvas.MoveTo(0, by);
      Image1.Canvas.LineTo(Image1.Width, by);
      Image1.Canvas.MoveTo(bx, 0);
      Image1.Canvas.LineTo(bx, Image1.Height);
    end;
  end;
end;

procedure TForm1.SpinEdit1Change(Sender: TObject);
begin
  px := shiftx[SpinEdit1.Value];
  py := shifty[SpinEdit1.Value];
  ReadImage(SpinEdit1.Value);
end;

procedure TForm1.SpinEdit2Change(Sender: TObject);
begin
  scale := SpinEdit2.Value;
  bx := Image1.Width div 2;
  by := Image1.Height - 30 * scale;
  Edit6.text := inttostr(bx);
  Edit7.text := inttostr(by);
  if OpenDialog1.FileName <> '' then
    ReadImage(SpinEdit1.Value);
end;

procedure TForm1.Image1MouseMove(Sender: TObject; Shift: TShiftState; x, y: integer);
var
  pt: tPoint;
begin
  if drag = 0 then
  begin
    Edit2.text := inttostr((x - bx) div scale + shiftx[SpinEdit1.Value]);
    Edit5.text := inttostr((y - by) div scale + shifty[SpinEdit1.Value]);
  end
  else
  begin
    Edit2.text := inttostr(-(x - dragx) div scale + dragx0);
    Edit5.text := inttostr(-(y - dragy) div scale + dragy0);
    Image1DblClick(Sender);
  end;
end;

procedure TForm1.Image1MouseUp(Sender: TObject; Button: TMouseButton; Shift: TShiftState; x, y: integer);
begin
  if drag = 1 then
  begin
    Edit2.text := inttostr((x - bx) div scale + shiftx[SpinEdit1.Value]);
    Edit5.text := inttostr((y - by) div scale + shifty[SpinEdit1.Value]);
    ReadImage(SpinEdit1.Value);
  end;
  drag := 0;
end;

procedure TForm1.Image3Click(Sender: TObject);
begin
  Edit3.text := Edit2.text;
  Edit4.text := Edit5.text;
end;

procedure TForm1.Image3DblClick(Sender: TObject);
begin
  Image3Click(Sender);
  Button1Click(Sender);
end;

procedure TForm1.Image3MouseMove(Sender: TObject; Shift: TShiftState; x, y: integer);
begin
  Edit2.text := inttostr(x);
  Edit5.text := inttostr(y);
end;

procedure TForm1.DrawPixel(x: integer; y: integer; c: Tcolor);
var
  i1, i2: integer;
begin
  for i1 := 0 to scale - 1 do
    for i2 := 0 to scale - 1 do
      Image1.Picture.Bitmap.Canvas.Pixels[x * scale + i1 + bx, y * scale + i2 + by] := c;

end;

procedure TForm1.Edit6Change(Sender: TObject);
begin
  bx := strtoint(Edit6.text);
  ReadImage(SpinEdit1.Value);
end;

procedure TForm1.Edit7Change(Sender: TObject);
begin
  by := strtoint(Edit7.text);
  ReadImage(SpinEdit1.Value);
end;

procedure TForm1.Image1Click(Sender: TObject);
begin
  Edit3.text := Edit2.text;
  Edit4.text := Edit5.text;
end;

procedure TForm1.Button10Click(Sender: TObject);
begin
  form2.ShowModal;
end;

procedure TForm1.Button11Click(Sender: TObject);
begin
  Edit6.text := '0';
  Edit7.text := '0';
  bx := 0;
  by := 0;
  // ReadImage(SpinEdit1.Value);
end;

procedure TForm1.Button12Click(Sender: TObject);
begin
  shiftx[SpinEdit1.Value] := px;
  shifty[SpinEdit1.Value] := py;
  ReadImage(SpinEdit1.Value);
end;

procedure TForm1.Button1Click(Sender: TObject);
begin
  shiftx[SpinEdit1.Value] := strtoint(Edit3.text);
  shifty[SpinEdit1.Value] := strtoint(Edit4.text);
  ReadImage(SpinEdit1.Value);
end;

procedure TForm1.Image1DblClick(Sender: TObject);
begin
  Image1Click(Sender);
  Button1Click(Sender);
end;

procedure TForm1.Button2Click(Sender: TObject);
var
  filegrp, fileidx, i, offset: integer;
begin
  { if CheckBox1.Checked = true then
    begin
    for i := 1 to (n div 2) do
    begin
    shiftx[i + (n div 2)] := sizex[i] - shiftx[i];
    shifty[i + (n div 2)] := shifty[i];
    end;
    end; }
  // filegrp := fileopen(Edit1.text + '.grp', fmopenreadwrite);
  copyfile(pwidechar(Edit1.text + '.ka'), pwidechar(Edit1.text + '.ka.bak'), false);
  fileidx := fileopen(Edit1.text + '.ka', fmopenreadwrite);
  fileseek(fileidx, 0, 0);
  for i := 0 to n do
  begin
    { if i = 1 then
      offset := 0
      else
      begin
      fileseek(fileidx, (i - 2) * 4, 0);
      fileread(fileidx, offset, 4);
      end; }
    filewrite(fileidx, shiftx[i], 2);
    filewrite(fileidx, shifty[i], 2);
  end;
  // fileclose(filegrp);
  fileclose(fileidx);
end;

procedure TForm1.Button3Click(Sender: TObject);
begin
  if messagedlg('Delete the backup file?', mtCustom, mbyesno, 0) = mryes then
    deletefile(Edit1.text + '.ka.bak');
  close;
  PngGround.Free;
end;

procedure TForm1.Image1MouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; x, y: integer);
begin
  if Button = mbright then
  begin
    if SpinEdit1.Value < SpinEdit1.MaxValue then
    begin
      SpinEdit1.Value := SpinEdit1.Value + 1;
      // readimage(spinedit1.Value);
    end;
  end;
  if Button = mbleft then
  begin
    drag := 1;
    dragx := x;
    dragy := y;
    dragx0 := shiftx[SpinEdit1.Value];
    dragy0 := shifty[SpinEdit1.Value];
  end;
end;

procedure TForm1.CheckBox1Click(Sender: TObject);
begin
  if CheckBox1.Checked = true then
    SpinEdit1.MaxValue := n div 2
  else
    SpinEdit1.MaxValue := n;
  SpinEdit1.Value := 1;
end;

procedure TForm1.Button4Click(Sender: TObject);
var
  i: integer;
begin
  for i := 0 to n do
  begin
    shiftx[i] := strtoint(Edit3.text);
    shifty[i] := strtoint(Edit4.text);
  end;
  ReadImage(SpinEdit1.Value);
end;

procedure TForm1.Button5Click(Sender: TObject);
var
  i: integer;
begin
  Timer1.Enabled := true;
  SpinEdit1.Value := 0;
end;

procedure TForm1.Button6Click(Sender: TObject);
begin
  Timer1.Enabled := true;
end;

procedure TForm1.Button7Click(Sender: TObject);
begin
  Timer1.Enabled := false;
end;

procedure TForm1.Button8Click(Sender: TObject);
begin
  if n < 9999 then
    n := n + 1;
  SpinEdit1.MaxValue := n;
end;

procedure TForm1.Button9Click(Sender: TObject);
begin
  if n > 0 then
    n := n - 1;
  SpinEdit1.MaxValue := n;
end;

procedure TForm1.Timer1Timer(Sender: TObject);
begin
  SpinEdit1.Value := SpinEdit1.Value + 1;
  if SpinEdit1.Value = SpinEdit1.MaxValue then
    Timer1.Enabled := false;
end;

end.
