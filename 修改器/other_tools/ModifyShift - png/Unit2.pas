unit Unit2;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, math;

type
  TForm2 = class(TForm)
    Edit1: TEdit;
    Edit2: TEdit;
    Edit3: TEdit;
    Edit4: TEdit;
    Button1: TButton;
    Button2: TButton;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form2: TForm2;

implementation

{$R *.dfm}

uses
  unit1;

procedure TForm2.Button1Click(Sender: TObject);
var
  i, x, y: integer;
begin
  x := strtoint(Edit3.Text);
  y := strtoint(Edit4.Text);
  for i := strtoint(Edit1.Text) to min(strtoint(Edit2.Text), unit1.n) do
  begin
    shiftx[i] := x;
    shifty[i] := y;
  end;
  close;
end;

procedure TForm2.Button2Click(Sender: TObject);
begin
  close;
end;

procedure TForm2.FormShow(Sender: TObject);
begin
  Edit1.Text := inttostr(form1.spinedit1.value);
  Edit2.Text := Edit1.Text;
  Edit3.Text := form1.Edit3.Text;
  Edit4.Text := form1.Edit4.Text;
end;

end.
