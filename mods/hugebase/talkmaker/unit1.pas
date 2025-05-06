unit Unit1;

{$mode objfpc}{$H+}

interface

uses
  Classes,
  SysUtils,
  FileUtil,
  Forms,
  Controls,
  Graphics,
  Dialogs,
  StdCtrls,
  LConvEncoding;

type

  { TForm1 }

  TForm1 = class(TForm)
    Button1: TButton;
    Button2: TButton;
    Button3: TButton;
    Button4: TButton;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure Button4Click(Sender: TObject);
    //procedure FormCreate(Sender: TObject);
  private
    { private declarations }
  public
    { public declarations }
  end;

  TIntArray = array of integer;
  TByteArray = array of byte;

var
  Form1: TForm1;
  list, list1: TStringList;
  b, i, i1, t1, t: integer;
  tempstr: utf8string;
  tempstr1: ansistring;
  cf: char;
  TDef: TByteArray;
  TIdx: TIntArray;
{surname2: array[0..81] of string = ('歐陽', '太史', '端木', '上官', '司馬',
'東方', '獨孤', '南宮', '萬俟', '聞人', '夏侯', '諸葛', '尉遲', '公羊',
'赫連', '澹台', '皇甫', '宗政', '濮陽', '公冶', '太叔', '申屠', '公孫',
'慕容', '仲孫', '鍾離', '長孫', '宇文', '司徒', '鮮於', '司空', '閭丘',
'子車', '亓官', '司寇', '巫馬', '公西', '顓孫', '壤駟', '公良', '漆雕',
'樂正', '宰父', '穀梁', '拓跋', '夾穀', '軒轅', '令狐', '段幹', '百裏',
'呼延', '東郭', '南門', '羊舌', '微生', '公戶', '公玉', '公儀', '梁丘',
'公仲', '公上', '公門', '公山', '公堅', '左丘', '公伯', '西門', '公祖',
'第五', '公乘', '貫丘', '公皙', '南榮', '東裏', '東宮', '仲長', '子書',
'子桑', '即墨', '達奚', '褚師', '第二');}

implementation

{$R *.lfm}

{ TForm1 }

procedure ReadTalk(talknum: integer; var talk: Tbytearray; needxor: integer = 0);
var
  len, offset, i: integer;
begin
  len := 0;
  if talknum = 0 then
  begin
    offset := 0;
    len := TIdx[0];
  end
  else
  begin
    offset := TIdx[talknum - 1];
    len := TIdx[talknum] - offset;
  end;

  setlength(talk, len + 1);
  move(TDef[offset], talk[0], len);
  if needxor = 1 then
    for i := 0 to len - 1 do
    begin
      talk[i] := talk[i] xor $FF;
      if talk[i] = 255 then
        talk[i] := 0;
    end;
  talk[len] := 0;
end;

//载入IDX和GRP文件到变长数据, 不适于非变长数据

function LoadIdxGrp(stridx, strgrp: string; var idxarray: TIntArray; var grparray: TByteArray): integer;
var
  idx, grp, len, tnum: integer;
begin
  tnum := 0;
  if FileExists(strgrp) and FileExists(stridx) then
  begin
    grp := FileOpen(strgrp, fmopenread);
    len := FileSeek(grp, 0, 2);
    setlength(grparray, len + 4);
    FileSeek(grp, 0, 0);
    FileRead(grp, grparray[0], len);
    FileClose(grp);

    idx := FileOpen(stridx, fmopenread);
    tnum := FileSeek(idx, 0, 2) div 4;
    setlength(idxarray, tnum + 1);
    FileSeek(idx, 0, 0);
    FileRead(idx, idxarray[0], tnum * 4);
    FileClose(idx);
  end;
  Result := tnum;

end;



procedure TForm1.Button1Click(Sender: TObject);
begin
  list := TStringList.Create;
  list.loadfromfile('talkutf8.txt');
  b := filecreate('talk1.grp');
  i1 := filecreate('talk1.idx');
  t1 := 0;
  for i := 0 to list.Count - 1 do
  begin
    tempstr := (list.Strings[i]);
    t1 := t1 + FileWrite(b, tempstr[1], length(tempstr));
    cf := char(0);
    t1 := t1 + FileWrite(b, cf, 1);
    t1 := t1 + FileWrite(b, cf, 1);
    FileWrite(i1, t1, 4);
  end;
  //list.SaveToFile('talkutf8.txt');
  FileClose(b);
  FileClose(i1);

  b := filecreate('talk.grp');
  i1 := filecreate('talk.idx');
  t1 := 0;
  for i := 0 to list.Count - 1 do
  begin
    tempstr1 := UTF8ToCP950(list.Strings[i]);
    for t := 1 to length(tempstr1) do
      tempstr1[t] := char(byte(tempstr1[t]) xor $FF);
    t1 := t1 + FileWrite(b, tempstr1[1], length(tempstr1));
    cf := char(0);
    t1 := t1 + FileWrite(b, cf, 1);
    //t1 := t1 + filewrite(b, cf, 1);
    FileWrite(i1, t1, 4);
  end;
  //list.SaveToFile('talkutf8.txt');
  FileClose(b);
  FileClose(i1);


  list.Free;
  ShowMessage('Done.');
  copyfile('talk1.grp', 'talk2.grp', False);
  copyfile('talk1.idx', 'talk2.idx', False);
    {b:=filecreate('resource/talk1.grp');
  i1:=filecreate('resource/talk1.idx');
  t1:=0;
  list:=tstringlist.Create;
  for i := 0 to 15712 do
  begin
    readtalk(i,Namestr,1);
    if length(namestr)>0 then
      tempstr:=utf8decode(cp950toutf8(pchar(@namestr[0])))
    else
      tempstr:='';
    //writeln(tempstr);
      str:=inttostr(i)+utf8encode(tempstr);
    list.add(str);
    t1:=t1+filewrite(b,tempstr[1], length(tempstr)*2);
    cf:=char(0);
    t1:=t1+filewrite(b, cf, 1);
    t1:=t1+filewrite(b, cf, 1);
    filewrite(i1,t1,4);
  end;
  list.SaveToFile('talkutf8.txt');
  fileclose(b);
  fileclose(i1);}
   {  RoleName[0] := '主角';
    RoleName[1] := '郭靖';
    RoleName[2] := '黄蓉';
    RoleName[3] := '韦小宝';
    RoleName[4] := '石破天';
    RoleName[5] := '袁承志';
    RoleName[6] := '胡斐';
    RoleName[7] := '张无忌';
    RoleName[8] := '令狐冲';
    RoleName[9] := '阿九';
    RoleName[10] := '赵敏';
    RoleName[11] := '香香';
    RoleName[12] := '小龙女';
    RoleName[13] := '杨过';
    RoleName[14] := '任盈盈';
    RoleName[15] := '陈家洛';
    RoleName[16] := '周芷若';
    RoleName[17] := '虚竹';
    RoleName[18] := '王语嫣';
    RoleName[19] := '段誉';
    RoleName[20] := '小昭';
    RoleName[21] := '萧峰';
    RoleName[22] := '阿朱';
    RoleName[23] := '袁紫衣';
    RoleName[24] := '苗若兰';
    RoleName[25] := '程灵素';
    RoleName[26] := '萧中慧';
    RoleName[27] := '袁冠南';
    RoleName[28] := '狄云';
    RoleName[29] := '仪琳';
    RoleName[30] := '水笙';
    RoleName[31] := '李文秀';
    RoleName[32] := '双儿';
    RoleName[33] := '温青青';
    RoleName[34] := '霍青桐';
    RoleName[35] := '郭襄';
    RoleName[36] := '谢逊';
    RoleName[37] := '不戒';
    RoleName[38] := '范遥';
    RoleName[39] := '杨逍';
    RoleName[40] := '陈近南';
    RoleName[41] := '殷天正';
    RoleName[42] := '卓不凡';
    RoleName[43] := '韦一笑';
    RoleName[44] := '神雕';
    RoleName[45] := '朱子柳';
    RoleName[46] := '无尘';
    RoleName[47] := '陆乘风';
    RoleName[48] := '赵半山';
    RoleName[49] := '文泰来';
    RoleName[50] := '吴六奇';
    RoleName[51] := '莫大';
    RoleName[52] := '骆冰';
    RoleName[53] := '苏荃';
    RoleName[54] := '余鱼同';
    RoleName[55] := '李沅芷';
    RoleName[56] := '钟灵';
    RoleName[57] := '石清';
    RoleName[58] := '闵柔';
    RoleName[59] := '建宁';
    RoleName[60] := '灵鹫四剑';
    RoleName[61] := '周颠';
    RoleName[62] := '武三通';
    RoleName[63] := '蓝凤凰';
    RoleName[64] := '陆无双';
    RoleName[65] := '冯阿三';
    RoleName[66] := '说不得';
    RoleName[67] := '吴领军';
    RoleName[68] := '范百龄';
    RoleName[69] := '陆冠英';
    RoleName[70] := '程遥迦';
    RoleName[71] := '彭莹玉';
    RoleName[72] := '平一指';
    RoleName[73] := '黛绮丝';
    RoleName[74] := '薛慕华';
    RoleName[75] := '耶律齐';
    RoleName[76] := '康广陵';
    RoleName[77] := '木婉清';
    RoleName[78] := '田伯光';
    RoleName[79] := '乌老大';
    RoleName[80] := '程青竹';
    RoleName[81] := '曲非烟';
    RoleName[82] := '何铁手';
    RoleName[83] := '王难姑';
    RoleName[84] := '胡青牛';
    RoleName[85] := '张中';
    RoleName[86] := '冷谦';
    RoleName[87] := '焦宛儿';
    RoleName[88] := '程瑛';
    RoleName[89] := '张三';
    RoleName[90] := '李四';
    RoleName[91] := '柯镇恶';
    RoleName[92] := '苟读';
    RoleName[93] := '石清露';
    RoleName[94] := '冯默风';
    RoleName[95] := '阿绣';
    RoleName[96] := '公孙萼';
    RoleName[97] := '郭芙';
    RoleName[98] := '李傀儡';
    RoleName[99] := '阿珂';
    RoleName[100] := '韦春芳';
    RoleName[101] := '武敦儒';
    RoleName[102] := '武修文';
    RoleName[103] := '老头子';
    RoleName[104] := '祖千秋';
    RoleName[105] := '桃谷六仙';
    RoleName[106] := '胡桂南';
    RoleName[107] := '太岳四侠';   }
end;

procedure TForm1.Button2Click(Sender: TObject);
var
  namestr: array of byte;
  list: TStringList;
  str: string;
begin
  list := TStringList.Create;
  for i := 0 to LoadIdxGrp('talk.idx', 'talk.grp', TIdx, TDef) - 1 do
  begin
    readtalk(i, Namestr, 1);
    if length(namestr) > 0 then
      tempstr := UTF8Decode(CP936ToUTF8(PChar(@namestr[0])))
    else
      tempstr := '';
    str := UTF8Encode(tempstr);
    list.add(str);
  end;
  list.SaveToFile('talkutf8export.txt');
  list.Free;
  ShowMessage('Done.');
end;

procedure TForm1.Button3Click(Sender: TObject);
var
  namestr: array of byte;
  list: TStringList;
  str: string;
begin
  list := TStringList.Create;
  for i := 0 to LoadIdxGrp('talk1.idx', 'talk1.grp', TIdx, TDef) - 1 do
  begin
    readtalk(i, Namestr, 0);
    if length(namestr) > 0 then
      tempstr := PwideChar(@namestr[0])
    else
      tempstr := '';
    str := UTF8Encode(tempstr);
    list.add(str);
  end;
  list.SaveToFile('talkutf8export.txt');
  list.Free;
  ShowMessage('Done.');
end;

procedure TForm1.Button4Click(Sender: TObject);
begin
  list := TStringList.Create;
  list.loadfromfile('talkutf8.txt');
  list1 := TStringList.Create;
  list1.loadfromfile('1.txt');
  for i := 0 to list.Count - 1 do
  begin
    if list1.Strings[i] <> '0' then
      list.Strings[i]:='';
  end;
  list.SaveToFile('talkutf8new.txt');
  list.Free;
  list1.Free;
  ShowMessage('Done.');

end;


end.
