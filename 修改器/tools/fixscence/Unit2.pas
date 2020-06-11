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
  i, p, len, len1: integer;
  f: word;
begin
  i := fileopen(form1.edit1.Text, fmopenreadwrite);
  len := fileseek(i, 0, 2);
  fileseek(i, 0, 0);
  p := 0;
  len1 := len div 100;
  while p <= len do
  begin
    fileread(i, f, 2);
    if (f div 2 > strtoint(form1.Edit2.Text)) and (p mod (64 * 64 * 6 * 2) < 64 * 64 * 2 * 3) then
    begin
      //showmessage(inttostr(f));
      f := 0;
      fileseek(i, p, 0);
      filewrite(i, f, 2);
    end;
    //label1.Caption:=inttostr(p)+'/'+inttostr(len);
    p := p + 2;
    if p mod len1 <= 1 then form1.ProgressBar1.Position := p div len1;
  end;
  messagebox(0, 'Fixed OK.', 'Confirm', mb_ok);
  fileclose(i);

end;

end.

 