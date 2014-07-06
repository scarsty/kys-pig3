unit kys_script;

{$i macro.inc}

interface

uses
{$IFDEF fpc}
{$ELSE}
  Windows,
{$ENDIF}
  SysUtils,
  SDL2,
  Math,
  lua52,
  kys_type,
  kys_main,
  kys_event,
  kys_engine,
  kys_battle,
  Classes;

//初始化脚本配置,运行脚本
procedure InitialScript;
procedure DestroyScript;
function ExecScript(filename, functionname: string): integer;
function ExecScriptString(script, functionname: string): integer;
function lua_tointeger(L: Plua_state; pos: integer): Lua_integer;

//具体指令,封装基本指令
function Blank(L: Plua_state): integer; cdecl;
function Pause(L: Plua_state): integer; cdecl;
function GetMousePositionScript(L: Plua_state): integer; cdecl;
function ClearButton(L: Plua_state): integer; cdecl;
function CheckButton(L: Plua_state): integer; cdecl;
function GetButton(L: Plua_state): integer; cdecl;
function GetTime(L: Plua_state): integer; cdecl;
function ExecEvent(L: Plua_state): integer; cdecl;

function Clear(L: Plua_state): integer; cdecl;
function OldTalk(L: Plua_state): integer; cdecl;
function Talk(L: Plua_state): integer; cdecl;
function GetItem(L: Plua_state): integer; cdecl;
function AddItem(L: Plua_state): integer; cdecl;
function ShowString(L: Plua_state): integer; cdecl;
function ShowStringWithBox(L: Plua_state): integer; cdecl;
function Menu(L: Plua_state): integer; cdecl;
function AskYesOrNo(L: Plua_state): integer; cdecl;
function ModifyEvent(L: Plua_state): integer; cdecl;
function UseItem(L: Plua_state): integer; cdecl;
function HaveItemAmount(L: Plua_state): integer; cdecl;
function HaveItemBool(L: Plua_state): integer; cdecl;
function AnotherGetItem(L: Plua_state): integer; cdecl;
function CompareProInTeam(L: Plua_state): integer; cdecl;
function AllLeave(L: Plua_state): integer; cdecl;
function AskBattle(L: Plua_state): integer; cdecl;
function TryBattle(L: Plua_state): integer; cdecl;
function AskJoin(L: Plua_state): integer; cdecl;
function Join(L: Plua_state): integer; cdecl;
function AskRest(L: Plua_state): integer; cdecl;
function Rest(L: Plua_state): integer; cdecl;
function LightScence(L: Plua_state): integer; cdecl;
function DarkScence(L: Plua_state): integer; cdecl;
function Dead(L: Plua_state): integer; cdecl;
function InTeam(L: Plua_state): integer; cdecl;
function TeamIsFull(L: Plua_state): integer; cdecl;
function LeaveTeam(L: Plua_state): integer; cdecl;
function LearnMagic(L: Plua_state): integer; cdecl;
//function Sprintf(L: Plua_state): integer; cdecl;
function GetMainMapPosition(L: Plua_state): integer; cdecl;
function SetMainMapPosition(L: Plua_state): integer; cdecl;
function GetScencePosition(L: Plua_state): integer; cdecl;
function SetScencePosition(L: Plua_state): integer; cdecl;
function GetScenceFace(L: Plua_state): integer; cdecl;
function SetScenceFace(L: Plua_state): integer; cdecl;
function Delay(L: Plua_state): integer; cdecl;
function DrawRect(L: Plua_state): integer; cdecl;
function MemberAmount(L: Plua_state): integer; cdecl;
function GetMember(L: Plua_state): integer; cdecl;
function PutMember(L: Plua_state): integer; cdecl;

function GetGlobalValue(L: Plua_state): integer; cdecl;
function PutGlobalValue(L: Plua_state): integer; cdecl;

function GetRolePro(L: Plua_state): integer; cdecl;
function PutRolePro(L: Plua_state): integer; cdecl;
function GetItemPro(L: Plua_state): integer; cdecl;
function PutItemPro(L: Plua_state): integer; cdecl;

function PutItemIntro(L: Plua_state): integer; cdecl; //冰枫月之怒添加

function GetMagicPro(L: Plua_state): integer; cdecl;
function PutMagicPro(L: Plua_state): integer; cdecl;
function GetScencePro(L: Plua_state): integer; cdecl;
function PutScencePro(L: Plua_state): integer; cdecl;
function GetScenceMapPro(L: Plua_state): integer; cdecl;
function PutScenceMapPro(L: Plua_state): integer; cdecl;
function GetScenceEventPro(L: Plua_state): integer; cdecl;
function PutScenceEventPro(L: Plua_state): integer; cdecl;
function JudgeScenceEvent(L: Plua_state): integer; cdecl;
function PlayMusic(L: Plua_state): integer; cdecl;
function PlayWave(L: Plua_state): integer; cdecl;
function WalkFromTo(L: Plua_state): integer; cdecl;
function ScenceFromTo(L: Plua_state): integer; cdecl;
function PlayAnimation(L: Plua_state): integer; cdecl;
function GetNameAsString(L: Plua_state): integer; cdecl;
function ChangeScence(L: Plua_state): integer; cdecl;
function ShowPicture(L: Plua_state): integer; cdecl;
function GetItemList(L: Plua_state): integer; cdecl;
function GetCurrentScence(L: Plua_state): integer; cdecl;
function GetCurrentEvent(L: Plua_state): integer; cdecl;

function GetBattleNumber(L: Plua_state): integer; cdecl;
function SelectOneAim(L: Plua_state): integer; cdecl;
function GetBattleRolePro(L: Plua_state): integer; cdecl;
function PutBattleRolePro(L: Plua_state): integer; cdecl;
function PlayAction(L: Plua_state): integer; cdecl;
//function GetRoundNumber(L: Plua_state): integer; cdecl;
function PlayHurtValue(L: Plua_state): integer; cdecl;
function SetAminationLayer(L: Plua_state): integer; cdecl;
function ClearRoleFromBattle(L: Plua_state): integer; cdecl;
function AddRoleIntoBattle(L: Plua_state): integer; cdecl;
function ForceBattleResult(L: Plua_state): integer; cdecl;
function AskSoftStar(L: Plua_state): integer; cdecl;
function WeiShop(L: Plua_state): integer; cdecl;
function OpenAllScence(L: Plua_state): integer; cdecl;
function ShowEthics(L: Plua_state): integer; cdecl;
function ShowRepute(L: Plua_state): integer; cdecl;
function OldPutScenceMapPro(L: Plua_state): integer; cdecl;
function ChangeMMapMusic(L: Plua_state): integer; cdecl;
function OldSetScencePosition(L: Plua_state): integer; cdecl;
function ZeroAllMP(L: Plua_state): integer; cdecl;
function SetOneUsePoi(L: Plua_state): integer; cdecl;
function Add3EventNum(L: Plua_state): integer; cdecl;
function Judge5Item(L: Plua_state): integer; cdecl;
function JudgeEthics(L: Plua_state): integer; cdecl;
function JudgeAttack(L: Plua_state): integer; cdecl;
function JudgeMoney(L: Plua_state): integer; cdecl;
function OldLearnMagic(L: Plua_state): integer; cdecl;
function AddAptitude(L: Plua_state): integer; cdecl;
function SetOneMagic(L: Plua_state): integer; cdecl;
function JudgeSexual(L: Plua_state): integer; cdecl;
function AddEthics(L: Plua_state): integer; cdecl;
function ChangeScencePic(L: Plua_state): integer; cdecl;
function OpenScence(L: Plua_state): integer; cdecl;
function JudgeFemaleInTeam(L: Plua_state): integer; cdecl;
function Play2Amination(L: Plua_state): integer; cdecl;
function AddSpeed(L: Plua_state): integer; cdecl;
function AddMP(L: Plua_state): integer; cdecl;
function AddAttack(L: Plua_state): integer; cdecl;
function AddHP(L: Plua_state): integer; cdecl;
function SetMPPro(L: Plua_state): integer; cdecl;
function JudgeEventNum(L: Plua_state): integer; cdecl;
function AddRepute(L: Plua_state): integer; cdecl;
function BreakStoneGate(L: Plua_state): integer; cdecl;
function FightForTop(L: Plua_state): integer; cdecl;
function JudgeScencePic(L: Plua_state): integer; cdecl;
function Judge14BooksPlaced(L: Plua_state): integer; cdecl;
function SetSexual(L: Plua_state): integer; cdecl;
function BackHome(L: Plua_state): integer; cdecl;

function EatOneItemScript(L: Plua_state): integer; cdecl;
function SelectOneTeamMemberScript(L: Plua_state): integer; cdecl;
function SetAttributeScript(L: Plua_state): integer; cdecl;

function SetRoleFace(L: Plua_state): integer; cdecl;
function EnterNumberScript(L: Plua_state): integer; cdecl;
function SetMenuEscType(L: Plua_state): integer; cdecl;

function GetBattlePro(L: Plua_state): integer; cdecl;
function PutBattlePro(L: Plua_state): integer; cdecl;

function ShowStatusScript(L: Plua_state): integer; cdecl;
function ShowSimpleStatusScript(L: Plua_state): integer; cdecl;
function UpdateAllScreenScript(L: Plua_state): integer; cdecl;
function ShowAbilityScript(L: Plua_state): integer; cdecl;

function GetScreenSize(L: Plua_state): integer; cdecl;

function JumpScenceScript(L: Plua_state): integer; cdecl;

function GetX50(L: Plua_state): integer; cdecl;
function PutX50(L: Plua_state): integer; cdecl;

function ShowTitleScript(L: Plua_state): integer; cdecl;
function ReadTalkAsString(L: Plua_state): integer; cdecl;
function CheckJumpFlag(L: Plua_state): integer; cdecl;
function ExitScript(L: Plua_state): integer; cdecl;
function AddRoleProWithHintScript(L: Plua_state): integer; cdecl;
function ColColorScript(L: Plua_state): integer; cdecl;
function SetBattleName(L: Plua_state): integer; cdecl;



implementation

uses
  kys_draw;

procedure InitialScript;
begin
  //LoadLua;
  //LoadLuaLib;
  //Lua_script := lua_open;
  Lua_script := luaL_newstate;
  luaL_openlibs(Lua_script);
  luaopen_base(Lua_script);
  luaopen_table(Lua_script);
  luaopen_math(Lua_script);
  luaopen_string(Lua_script);

  lua_register(Lua_script, 'add3eventnum', Add3EventNum);
  lua_register(Lua_script, 'instruct_26', Add3EventNum);
  lua_register(Lua_script, 'addaptitude', AddAptitude);
  lua_register(Lua_script, 'instruct_34', AddAptitude);
  lua_register(Lua_script, 'addattack', AddAttack);
  lua_register(Lua_script, 'instruct_47', AddAttack);
  lua_register(Lua_script, 'addethics', AddEthics);
  lua_register(Lua_script, 'instruct_37', AddEthics);
  lua_register(Lua_script, 'addhp', AddHP);
  lua_register(Lua_script, 'instruct_48', AddHP);
  lua_register(Lua_script, 'additem', AddItem);
  lua_register(Lua_script, 'instruct_32', AddItem);
  lua_register(Lua_script, 'addmp', AddMP);
  lua_register(Lua_script, 'instruct_46', AddMP);
  lua_register(Lua_script, 'addrepute', AddRepute);
  lua_register(Lua_script, 'instruct_56', AddRepute);
  lua_register(Lua_script, 'addroleintobattle', AddRoleIntoBattle);
  lua_register(Lua_script, 'addspeed', AddSpeed);
  lua_register(Lua_script, 'instruct_45', AddSpeed);
  lua_register(Lua_script, 'allleave', AllLeave);
  lua_register(Lua_script, 'instruct_59', AllLeave);
  lua_register(Lua_script, 'anothergetitem', AnotherGetItem);
  lua_register(Lua_script, 'instruct_41', AnotherGetItem);
  lua_register(Lua_script, 'npcgetitem', AnotherGetItem);
  lua_register(Lua_script, 'askbattle', AskBattle);
  lua_register(Lua_script, 'instruct_5', AskBattle);
  lua_register(Lua_script, 'askjoin', AskJoin);
  lua_register(Lua_script, 'instruct_9', AskJoin);
  lua_register(Lua_script, 'askrest', AskRest);
  lua_register(Lua_script, 'instruct_11', AskRest);
  lua_register(Lua_script, 'asksoftstar', AskSoftStar);
  lua_register(Lua_script, 'instruct_51', AskSoftStar);
  lua_register(Lua_script, 'askyesorno', AskYesOrNo);
  lua_register(Lua_script, 'endamination', BackHome);
  lua_register(Lua_script, 'instruct_62', BackHome);
  lua_register(Lua_script, 'instruct_24', Blank);
  lua_register(Lua_script, 'instruct_65', Blank);
  lua_register(Lua_script, 'instruct_7', Blank);
  lua_register(Lua_script, 'instruct_57', BreakStoneGate);
  lua_register(Lua_script, 'changemmapmusic', ChangeMMapMusic);
  lua_register(Lua_script, 'instruct_8', ChangeMMapMusic);
  lua_register(Lua_script, 'changescence', ChangeScence);
  lua_register(Lua_script, 'changescencepic', ChangeScencePic);
  lua_register(Lua_script, 'instruct_38', ChangeScencePic);
  lua_register(Lua_script, 'checkbutton', CheckButton);
  lua_register(Lua_script, 'clear', Clear);
  lua_register(Lua_script, 'instruct_0', Clear);
  lua_register(Lua_script, 'clearbutton', ClearButton);
  lua_register(Lua_script, 'clearrolefrombattle', ClearRoleFromBattle);
  lua_register(Lua_script, 'compareprointeam', CompareProInTeam);
  lua_register(Lua_script, 'darkscence', DarkScence);
  lua_register(Lua_script, 'instruct_14', DarkScence);
  lua_register(Lua_script, 'dead', Dead);
  lua_register(Lua_script, 'instruct_15', Dead);
  lua_register(Lua_script, 'delay', Delay);
  lua_register(Lua_script, 'drawrect', DrawRect);
  lua_register(Lua_script, 'eatoneitem', EatOneItemScript);
  lua_register(Lua_script, 'enternumber', EnterNumberScript);
  lua_register(Lua_script, 'execevent', ExecEvent);
  lua_register(Lua_script, 'instruct_58', FightForTop);
  lua_register(Lua_script, 'forcebattleresult', ForceBattleResult);
  lua_register(Lua_script, 'getbattlenumber', GetBattleNumber);
  lua_register(Lua_script, 'getbattlepro', GetBattlePro);
  lua_register(Lua_script, 'getbattlerolepro', GetBattleRolePro);
  lua_register(Lua_script, 'getbutton', GetButton);
  lua_register(Lua_script, 'getcurrentevent', GetCurrentEvent);
  lua_register(Lua_script, 'getcurrentscence', GetCurrentScence);
  lua_register(Lua_script, 'getitem', GetItem);
  lua_register(Lua_script, 'instruct_2', GetItem);
  lua_register(Lua_script, 'getitemlist', GetItemList);
  lua_register(Lua_script, 'getitempro', GetItemPro);
  lua_register(Lua_script, 'getmagicpro', GetMagicPro);
  lua_register(Lua_script, 'getmainmapposition', GetMainMapPosition);
  lua_register(Lua_script, 'getmember', GetMember);
  lua_register(Lua_script, 'getglobalvalue', GetGlobalValue);
  lua_register(Lua_script, 'getmouseposition', GetMousePositionScript);
  lua_register(Lua_script, 'getnameasstring', GetNameAsString);
  lua_register(Lua_script, 'getrolepro', GetRolePro);
  lua_register(Lua_script, 'getscenceeventpro', GetScenceEventPro);
  lua_register(Lua_script, 'getscenceface', GetScenceFace);
  lua_register(Lua_script, 'getscencemappro', GetScenceMapPro);
  lua_register(Lua_script, 'getscenceposition', GetScencePosition);
  lua_register(Lua_script, 'getscencepro', GetScencePro);
  lua_register(Lua_script, 'getscreensize', GetScreenSize);
  lua_register(Lua_script, 'gettime', GetTime);
  lua_register(Lua_script, 'haveitem', HaveItemBool);
  lua_register(Lua_script, 'haveitemamount', HaveItemAmount);
  lua_register(Lua_script, 'instruct_18', HaveItemBool);
  lua_register(Lua_script, 'instruct_43', HaveItemBool);
  lua_register(Lua_script, 'instruct_16', InTeam);
  lua_register(Lua_script, 'inteam', InTeam);
  lua_register(Lua_script, 'instruct_10', Join);
  lua_register(Lua_script, 'join', Join);
  lua_register(Lua_script, 'instruct_61', Judge14BooksPlaced);
  lua_register(Lua_script, 'judge14booksplaced', Judge14BooksPlaced);
  lua_register(Lua_script, 'instruct_50', Judge5Item);
  lua_register(Lua_script, 'instruct_29', JudgeAttack);
  lua_register(Lua_script, 'judgeattack', JudgeAttack);
  lua_register(Lua_script, 'instruct_28', JudgeEthics);
  lua_register(Lua_script, 'judgeethics', JudgeEthics);
  lua_register(Lua_script, 'instruct_55', JudgeEventNum);
  lua_register(Lua_script, 'judgeeventnum', JudgeEventNum);
  lua_register(Lua_script, 'instruct_42', JudgeFemaleInTeam);
  lua_register(Lua_script, 'judgefemaleinteam', JudgeFemaleInTeam);
  lua_register(Lua_script, 'instruct_31', JudgeMoney);
  lua_register(Lua_script, 'judgemoney', JudgeMoney);
  lua_register(Lua_script, 'judgescenceevent', JudgeScenceEvent);
  lua_register(Lua_script, 'instruct_60', JudgeScencePic);
  lua_register(Lua_script, 'judgescencepic', JudgeScencePic);
  lua_register(Lua_script, 'instruct_36', JudgeSexual);
  lua_register(Lua_script, 'judgesexual', JudgeSexual);
  lua_register(Lua_script, 'jumpscence', JumpScenceScript);
  lua_register(Lua_script, 'learnmagic', LearnMagic);
  lua_register(Lua_script, 'instruct_21', LeaveTeam);
  lua_register(Lua_script, 'leave', LeaveTeam);
  lua_register(Lua_script, 'leaveteam', LeaveTeam);
  lua_register(Lua_script, 'instruct_13', LightScence);
  lua_register(Lua_script, 'lightscence', LightScence);
  lua_register(Lua_script, 'memberamount', MemberAmount);
  lua_register(Lua_script, 'menu', Menu);
  lua_register(Lua_script, 'instruct_3', ModifyEvent);
  lua_register(Lua_script, 'modifyevent', ModifyEvent);
  lua_register(Lua_script, 'instruct_33', OldLearnMagic);
  lua_register(Lua_script, 'learnmagic2', OldLearnMagic);
  lua_register(Lua_script, 'instruct_17', OldPutScenceMapPro);
  lua_register(Lua_script, 'setscencemappro', OldPutScenceMapPro);
  lua_register(Lua_script, 'setscencemap', OldPutScenceMapPro);
  lua_register(Lua_script, 'instruct_19', OldSetScencePosition);
  lua_register(Lua_script, 'setscenceposition2', OldSetScencePosition);
  lua_register(Lua_script, 'instruct_1', OldTalk);
  lua_register(Lua_script, 'instruct_54', OpenAllScence);
  lua_register(Lua_script, 'openallscence', OpenAllScence);
  lua_register(Lua_script, 'instruct_39', OpenScence);
  lua_register(Lua_script, 'openscence', OpenScence);
  lua_register(Lua_script, 'pause', Pause);
  lua_register(Lua_script, 'instruct_44', Play2Amination);
  lua_register(Lua_script, 'playaction', PlayAction);
  lua_register(Lua_script, 'instruct_27', PlayAnimation);
  lua_register(Lua_script, 'playanimation', PlayAnimation);
  lua_register(Lua_script, 'playhurtvalue', PlayHurtValue);
  lua_register(Lua_script, 'instruct_66', PlayMusic);
  lua_register(Lua_script, 'playmusic', PlayMusic);
  lua_register(Lua_script, 'instruct_67', PlayWave);
  lua_register(Lua_script, 'playwave', PlayWave);
  lua_register(Lua_script, 'putbattlepro', PutBattlePro);
  lua_register(Lua_script, 'putbattlerolepro', PutBattleRolePro);
  lua_register(Lua_script, 'putitempro', PutItemPro);
  lua_register(Lua_script, 'putmagicpro', PutMagicPro);
  lua_register(Lua_script, 'putmember', PutMember);

  lua_register(Lua_script, 'putglobalvalue', PutGlobalValue);

  lua_register(Lua_script, 'putrolepro', PutRolePro);
  lua_register(Lua_script, 'putscenceeventpro', PutScenceEventPro);
  lua_register(Lua_script, 'putscencemappro', PutScenceMapPro);
  lua_register(Lua_script, 'putscencepro', PutScencePro);
  lua_register(Lua_script, 'instruct_12', Rest);
  lua_register(Lua_script, 'rest', Rest);
  lua_register(Lua_script, 'instruct_25', ScenceFromTo);
  lua_register(Lua_script, 'scencefromto', ScenceFromTo);
  lua_register(Lua_script, 'selectoneaim', SelectOneAim);
  lua_register(Lua_script, 'selectoneteammember', SelectOneTeamMemberScript);
  lua_register(Lua_script, 'setaminationlayer', SetAminationLayer);
  lua_register(Lua_script, 'setattribute', SetAttributeScript);
  lua_register(Lua_script, 'setmainmapposition', SetMainMapPosition);
  lua_register(Lua_script, 'setmenuesctype', SetMenuEscType);
  lua_register(Lua_script, 'instruct_49', SetMPPro);
  lua_register(Lua_script, 'setmppro', SetMPPro);
  lua_register(Lua_script, 'instruct_35', SetOneMagic);
  lua_register(Lua_script, 'setonemagic', SetOneMagic);
  lua_register(Lua_script, 'instruct_23', SetOneUsePoi);
  lua_register(Lua_script, 'setoneusepoi', SetOneUsePoi);
  lua_register(Lua_script, 'instruct_40', SetRoleFace);
  lua_register(Lua_script, 'setroleface', SetRoleFace);
  lua_register(Lua_script, 'setscenceface', SetScenceFace);
  lua_register(Lua_script, 'setscenceposition', SetScencePosition);
  lua_register(Lua_script, 'instruct_63', SetSexual);
  lua_register(Lua_script, 'showability', ShowAbilityScript);
  lua_register(Lua_script, 'instruct_52', ShowEthics);
  lua_register(Lua_script, 'showethics', ShowEthics);
  lua_register(Lua_script, 'showpicture', ShowPicture);
  lua_register(Lua_script, 'instruct_53', ShowRepute);
  lua_register(Lua_script, 'showrepute', ShowRepute);
  lua_register(Lua_script, 'showstatus', ShowStatusScript);
  lua_register(Lua_script, 'showstring', ShowString);
  lua_register(Lua_script, 'showstringwithbox', ShowStringWithBox);
  lua_register(Lua_script, 'talk', Talk);
  lua_register(Lua_script, 'instruct_20', TeamIsFull);
  lua_register(Lua_script, 'teamisfull', TeamIsFull);
  lua_register(Lua_script, 'instruct_6', TryBattle);
  lua_register(Lua_script, 'trybattle', TryBattle);
  lua_register(Lua_script, 'instruct_4', UseItem);
  lua_register(Lua_script, 'useitem', UseItem);
  lua_register(Lua_script, 'instruct_30', WalkFromTo);
  lua_register(Lua_script, 'walkfromto', WalkFromTo);
  lua_register(Lua_script, 'instruct_64', WeiShop);
  lua_register(Lua_script, 'weishop', WeiShop);
  lua_register(Lua_script, 'instruct_22', ZeroAllMP);
  lua_register(Lua_script, 'zeroallmp', ZeroAllMP);
  lua_register(Lua_script, 'getx50', GetX50);
  lua_register(Lua_script, 'putx50', PutX50);

  lua_register(Lua_script, 'showtitle', ShowTitleScript);
  lua_register(Lua_script, 'readtalkasstring', ReadTalkAsString);
  lua_register(Lua_script, 'checkjumpflag', CheckJumpFlag);
  lua_register(Lua_script, 'exit', ExitScript);
  lua_register(Lua_script, 'addroleprowithhint', AddRoleProWithHintScript);
  lua_register(Lua_script, 'colcolor', ColColorScript);
  lua_register(Lua_script, 'setbattlename', SetBattleName);
  lua_register(Lua_script, 'showsimplestatus', ShowSimpleStatusScript);
  lua_register(Lua_script, 'updateallscreen', UpdateAllScreenScript);

  lua_register(Lua_script, 'putitemintro', PutItemIntro); //冰枫月之怒添加

end;

procedure DestroyScript;
begin
  lua_close(Lua_script);
  //UnloadLuaLib;
  //UnloadLua;
end;


function ExecScript(filename, functionname: string): integer;
var
  Script: string;
  h, len: integer;
begin
  script := '';
  if FileExists(filename) then
  begin
    h := FileOpen(filename, fmopenread);
    len := FileSeek(h, 0, 2);
    setlength(Script, len);
    FileSeek(h, 0, 0);
    FileRead(h, Script[1], len);
    FileClose(h);
    ExecScriptString(script, functionname);
  end;
end;

function ExecScriptString(script, functionname: string): integer;
var
  len: integer;
begin
  try
{$IFDEF UNIX}
    Script := LowerCase(Script);
{$ELSE}
{$IFDEF FPC}
    Script := LowerCase(Script);
{$ELSE}
    Script := LowerCase(Script);
{$ENDIF}
{$ENDIF}
    //writeln(script);
    Result := lual_loadbuffer(Lua_script, @script[1], length(script), 'code');
    if Result = 0 then
    begin
      Result := lua_pcall(Lua_script, 0, 0, 0);
      //lua_dofile(Lua_script,pchar(filename[1]));
      if functionname <> '' then
      begin
        lua_getglobal(Lua_script, pchar(functionname));
        Result := lua_pcall(Lua_script, 0, 1, 0);
      end;
    end;
    //lua_gc(Lua_script, LUA_GCCOLLECT, 0);
    if Result <> 0 then
    begin
      writeln(lua_tostring(Lua_script, -1));
      lua_pop(Lua_script, 1);
    end;
  except
    Result := -1;
  end;
end;

//处理50 32指令改写参数的问题

function lua_tointeger(L: Plua_state; pos: integer): Lua_integer;
var
  n: integer;
begin
  n := lua_gettop(L);
  Result := lua52.lua_tointeger(L, pos);
  //writeln(n, pos, p5032pos, p5032value);
  if n + pos + 1 = p5032pos then
  begin
    Result := p5032value;
    p5032pos := -100;
  end;
end;


function Blank(L: Plua_state): integer; cdecl;
begin
  Result := 0;
end;

function Pause(L: Plua_state): integer; cdecl;
begin
  lua_pushinteger(L, WaitAnyKey);
  Result := 1;

end;

function GetMousePositionScript(L: Plua_state): integer; cdecl;
var
  x, y: integer;
begin
  SDL_PollEvent(@event);
  SDL_GetMouseState2(x, y);
  lua_pushinteger(L, x);
  lua_pushinteger(L, y);
  Result := 2;

end;

function ClearButton(L: Plua_state): integer; cdecl;
begin
  //event.type_ := 0;
  event.key.keysym.sym := 0;
  event.button.button := 0;
  Result := 0;

end;

//检查按键
//event.key.keysym.sym = 1 when mouse motion.

function CheckButton(L: Plua_state): integer; cdecl;
var
  t: integer;
begin
  SDL_PollEvent(@event);
  if (event.button.button > 0) then
  begin
    t := 1;
  end
  else
  begin
    t := 0;
  end;
  lua_pushinteger(L, t);
  SDL_Delay(10);
  Result := 1;

end;

function GetButton(L: Plua_state): integer; cdecl;
var
  t: integer;
begin
  lua_pushinteger(L, event.key.keysym.sym);
  lua_pushinteger(L, event.button.button);
  Result := 2;

end;

function ExecEvent(L: Plua_state): integer; cdecl;
var
  n, e, i: integer;
begin
  n := lua_gettop(L);
  e := lua_tointeger(L, -n);
  for i := 0 to n - 2 do
  begin
    x50[$7100 + i] := lua_tointeger(L, -n + 1 + i);
  end;
  CallEvent(e);
  Result := 0;

end;

//获取当前时间

function GetTime(L: Plua_state): integer; cdecl;
var
  t: integer;
begin
  t := floor(time * 86400);
  lua_pushinteger(L, t);
  Result := 1;

end;

function Clear(L: Plua_state): integer; cdecl;
begin
  Redraw;
  Result := 0;

end;

function OldTalk(L: Plua_state): integer; cdecl;
var
  talknum, headnum, dismode: integer;
begin
  talknum := lua_tointeger(L, -3);
  headnum := lua_tointeger(L, -2);
  dismode := lua_tointeger(L, -1);
  instruct_1(talknum, headnum, dismode);
  Result := 0;

end;

//冰枫月之怒添加
function PutItemIntro(L: Plua_state): integer; cdecl;
var
  n, itemnum, i, len: integer;
  str: WideString;
  p: pWideChar;
begin
  itemnum := lua_tointeger(L, -2);
  str := UTF8Decode(lua_tostring(L, -1));
  len := length(str);
  FillChar(Ritem[itemnum].Introduction[0], sizeof(@Ritem[0].Introduction), 0);
  if (len > 15) then
  begin
    writeln('Intro length is too long!');
  end
  else
  begin
    p := @Ritem[itemnum].Introduction[0];
    //Ritem[itemnum].Introduction :=str;
    for i := 1 to len do
    begin
      //if (i<=len) then
      p^ := str[i];
      //else p^:=char(0);
      p := p + 1;
      //Ritem[itemnum].Introduction[i-1]:=str[i];
    end;
  end;
  Result := 0;
end;




//talk指令, 参数为3个数字和两个字串,
//数字为头像号, 姓名号, 显示模式, 是否显示姓名, 颜色, 谈话编号
//字串为谈话内容, 指定姓名
//字串与数字的穿插顺序任意
//如果显示模式不指定则自动计算

function Talk(L: Plua_state): integer; cdecl;
var
  //head, dismode, n: integer;
  //content, Name: WideString;
  //len, headx, heady, diagx, diagy, Width, line, w1, l1, i: integer;
  //str: WideString;
  n, i, inum, istr: integer;
  nums: array[0..5] of integer = (-1, -2, -2, 0, 0, 0);
  strs: array[0..1] of WideString;
begin
  n := lua_gettop(L);
  inum := 0;
  istr := 0;
  strs[0] := '';
  strs[1] := '';
  for i := -n to -1 do
  begin
    if (inum <= high(nums)) then
    begin
      nums[inum] := lua_tointeger(L, i);
      inum := inum + 1;
    end;
  end;
  if not lua_isnumber(L, -n + 1) then
  begin
    strs[0] := UTF8Decode(lua_tostring(L, -n + 1));
  end;
  if not lua_isnumber(L, -n + 2) then
  begin
    strs[1] := UTF8Decode(lua_tostring(L, -n + 2));
  end;
  if nums[3] < 0 then
    nums[3] := abs(nums[3]);
  NewTalk(nums[0], nums[1], nums[2], nums[3], nums[4], nums[5], 0, strs[0], strs[1]);

  {Width := 48;
  line := 4;
  case dismode of
    0:
    begin
      headx := 40;
      heady := 85;
      diagx := 100;
      diagy := 30;
    end;
    1:
    begin
      headx := 546;
      heady := CENTER_Y * 2 - 75;
      diagx := 10;
      diagy := CENTER_Y * 2 - 130;
    end;
    2:
    begin
      headx := -1;
      heady := -1;
      diagx := 100;
      diagy := 30;
    end;
    5:
    begin
      headx := 40;
      heady := CENTER_Y * 2 - 75;
      diagx := 100;
      diagy := CENTER_Y * 2 - 130;
    end;
    4:
    begin
      headx := 546;
      heady := 85;
      diagx := 10;
      diagy := 30;
    end;
    3:
    begin
      headx := -1;
      heady := -1;
      diagx := 100;
      diagy := CENTER_Y * 2 - 130;
    end;
  end;
  DrawRectangleWithoutFrame(screen, 0, diagy - 10, 640, 120, 0, 40);
  if headx > 0 then
    DrawHeadPic(rnum, headx, heady);
  len := length(content);

  w1 := 0;
  l1 := 0;
  for i := 1 to len do
  begin
    if content[i] <> '*' then
    begin
      str := content[i];
      DrawShadowText(@str[1], diagx + w1 * 10, diagy + l1 * 22, ColColor($FF), ColColor($0));
      if integer(str[1]) < 128 then
        w1 := w1 + 1
      else
        w1 := w1 + 2;
      if w1 >= Width then
      begin
        w1 := 0;
        l1 := l1 + 1;
      end;
    end
    else
    begin
      w1 := 0;
      l1 := l1 + 1;
    end;
    if (l1 >= 4) and (i < len) then
    begin
      updateallscreen;
      WaitAnyKey;
      Redraw;
      DrawRectangleWithoutFrame(screen, 0, diagy - 10, 640, 120, 0, 40);
      if headx > 0 then
        DrawHeadPic(rnum, headx, heady);
      w1 := 0;
      l1 := 0;
    end;
  end;
  updateallscreen;
  WaitAnyKey;
  Redraw;
  Result := 0;}

end;

function GetItem(L: Plua_state): integer; cdecl;
var
  inum, amount: integer;
begin
  //writeln(lua_gettop(L));
  inum := lua_tointeger(L, -2);
  amount := lua_tointeger(L, -1);
  instruct_2(inum, amount);
  Result := 0;

end;

function AddItem(L: Plua_state): integer; cdecl;
var
  inum, amount: integer;
begin
  //writeln(lua_gettop(L));
  inum := lua_tointeger(L, -2);
  amount := lua_tointeger(L, -1);
  instruct_32(inum, amount);
  Result := 0;

end;

function ShowString(L: Plua_state): integer; cdecl;
var
  x, y, n, color1, color2: integer;
  str: WideString;
begin
  color1 := ColColor(5);
  color2 := ColColor(7);
  n := Lua_gettop(L);
  x := lua_tointeger(L, -n);
  y := lua_tointeger(L, -n + 1);
  str := UTF8Decode(lua_tostring(L, -n + 2));
  if n >= 5 then
  begin
    color1 := lua_tointeger(L, -n + 3);
    color2 := lua_tointeger(L, -n + 4);
  end;
  DrawShadowText(@str[1], x, y, color1, color2);
  UpdateAllScreen;
  Result := 0;

end;

function ShowStringWithBox(L: Plua_state): integer; cdecl;
var
  x, y, i, n, alpha, color1, color2, incolor, framecolor: integer;
  str: WideString;
begin
  alpha := 50;
  color1 := ColColor(5);
  color2 := ColColor(7);
  incolor := 0;
  framecolor := ColColor(255);
  n := Lua_gettop(L);
  x := lua_tointeger(L, -n);
  y := lua_tointeger(L, -n + 1);
  str := UTF8Decode(lua_tostring(L, -n + 2));
  if n >= 4 then
    alpha := lua_tointeger(L, -n + 3);
  if n >= 6 then
  begin
    color1 := lua_tointeger(L, -n + 4);
    color2 := lua_tointeger(L, -n + 5);
  end;
  if n >= 7 then
    incolor := lua_tointeger(L, -n + 6);
  if n >= 8 then
    framecolor := lua_tointeger(L, -n + 7);
  DrawRectangle(x, y - 2, DrawLength(str) * 10 + 8, 26, incolor, framecolor, alpha);
  DrawShadowText(@str[1], x + 3, y, color1, color2);
  UpdateAllScreen;
  Result := 0;

end;

function Menu(L: Plua_state): integer; cdecl;
var
  x, y, w, n, i, len, maxwidth, Width: integer;
  p: WideString;
  menuString: array of WideString;
begin
  n := lua_tointeger(L, -5);
  setlength(menuString, n);
  //setlength(menuengstring, 0);
  len := luaL_len(L, -1);
  n := min(n, len);
  maxwidth := 0;
  for i := 0 to n - 1 do
  begin
    lua_pushinteger(L, i + 1);
    lua_gettable(L, -2);
    p := UTF8Decode(lua_tostring(L, -1));
    if p <> '' then
    begin
      menuString[i] := p;
    end
    else
      menuString[i] := '';
    Width := DrawLength(menuString[i]);
    if Width > maxwidth then
      maxwidth := Width;
    lua_pop(L, 1);
  end;

  w := lua_tointeger(L, -2);
  y := lua_tointeger(L, -3);
  x := lua_tointeger(L, -4);
  if w <= 0 then
  begin
    w := maxwidth * 10 + 8;
  end;
  lua_pushinteger(L, CommonScrollMenu(x, y, w, n - 1, 10, menuString));
  Result := 1;

end;

function AskYesOrNo(L: Plua_state): integer; cdecl;
var
  x, y: integer;
  menuString: array[0..1] of WideString;
begin
  //setlength(menustring, 2);
  menuString[0] := ('否');
  menuString[1] := ('是');
  y := lua_tointeger(L, -2);
  x := lua_tointeger(L, -1);
  lua_pushinteger(L, CommonMenu2(x, y, 78, menuString));
  Result := 1;
  //writeln(result);

end;

function ModifyEvent(L: Plua_state): integer; cdecl;
var
  x: array of integer;
  i, n: integer;
begin
  n := lua_gettop(L);
  setlength(x, n);
  for i := 0 to n - 1 do
  begin
    x[i] := lua_tointeger(L, -(n - i));
  end;
  if n >= 13 then
    instruct_3(x);
  if n = 4 then
  begin
    if x[0] < 0 then
      x[0] := CurScence;
    if x[1] < 0 then
      x[1] := CurEvent;
    Ddata[x[0], x[1], x[2]] := x[3];
  end;
  Result := 0;

end;

function UseItem(L: Plua_state): integer; cdecl;
var
  inum, temp, n: integer;
begin
  n := lua_gettop(L);
  inum := lua_tointeger(L, -1);
  if n = 3 then
    inum := lua_tointeger(L, -3);
  lua_pushboolean(L, inum = CurItem);
  Result := 1;

end;

function HaveItemAmount(L: Plua_state): integer; cdecl;
var
  inum, n, i: integer;
begin
  inum := lua_tointeger(L, -1);
  for i := 0 to MAX_ITEM_AMOUNT do
  begin
    if RItemlist[i].Number = inum then
    begin
      n := RItemlist[i].Amount;
      break;
    end;
  end;
  lua_pushinteger(L, n);
  Result := 1;

end;

function HaveItemBool(L: Plua_state): integer; cdecl;
var
  n, inum: integer;
begin
  n := lua_gettop(L);
  inum := lua_tointeger(L, -n);
  lua_pushboolean(L, instruct_18(inum, 1, 0) = 1);
  Result := 1;

end;

//非队友得到物品

function AnotherGetItem(L: Plua_state): integer; cdecl;
begin
  instruct_41(lua_tointeger(L, -3), lua_tointeger(L, -2), lua_tointeger(L, -1));
  Result := 0;

end;

//队伍中某属性等于某值的人数

function CompareProInTeam(L: Plua_state): integer; cdecl;
var
  n, i: integer;
begin
  n := 0;
  for i := 0 to 5 do
  begin
    if Rrole[TeamList[i]].Data[lua_tointeger(L, -2)] = lua_tointeger(L, -1) then
      n := n + 1;
  end;

  lua_pushinteger(L, n);
  Result := 1;

end;

function AllLeave(L: Plua_state): integer; cdecl;
begin
  instruct_59;
  Result := 0;
end;

function AskBattle(L: Plua_state): integer; cdecl;
begin
  lua_pushboolean(L, instruct_5(1, 0) = 1);
  Result := 1;

end;

function TryBattle(L: Plua_state): integer; cdecl;
var
  t, n: integer;
begin
  n := lua_gettop(L);
  t := lua_tointeger(L, -n);
  if ForceBattleWin = 0 then
    lua_pushboolean(L, Battle(t, lua_tointeger(L, -1)))
  else
    lua_pushboolean(L, True);
  Result := 1;

end;

function AskJoin(L: Plua_state): integer; cdecl;
begin
  lua_pushboolean(L, instruct_9(1, 0) = 1);
  Result := 1;

end;

function Join(L: Plua_state): integer; cdecl;
begin
  instruct_10(lua_tointeger(L, -1));
  Result := 0;

end;

function AskRest(L: Plua_state): integer; cdecl;
begin
  lua_pushboolean(L, instruct_11(1, 0) = 1);
  Result := 1;

end;

function Rest(L: Plua_state): integer; cdecl;
begin
  instruct_12;
  Result := 0;

end;

function LightScence(L: Plua_state): integer; cdecl;
begin
  instruct_13;
  Result := 0;

end;

function DarkScence(L: Plua_state): integer; cdecl;
begin
  instruct_14;
  Result := 0;

end;

function Dead(L: Plua_state): integer; cdecl;
begin
  instruct_15;
  Result := 0;

end;

function InTeam(L: Plua_state): integer; cdecl;
begin
  lua_pushboolean(L, instruct_16(lua_tointeger(L, -lua_gettop(L)), 1, 0) = 1);
  Result := 1;

end;

function TeamIsFull(L: Plua_state): integer; cdecl;
begin
  lua_pushboolean(L, instruct_20(1, 0) = 1);
  Result := 1;

end;

function LeaveTeam(L: Plua_state): integer; cdecl;
begin
  instruct_21(lua_tointeger(L, -1));
  Result := 0;

end;

function LearnMagic(L: Plua_state): integer; cdecl;
var
  n, i, m: integer;
  x: array of integer;
begin
  n := lua_gettop(L);
  setlength(x, n);
  for i := 0 to n - 1 do
  begin
    x[i] := lua_tointeger(L, -(n - i));
  end;
  if n = 2 then
  begin
    instruct_33(x[0], x[1], 0);
  end;
  if n = 3 then
  begin
    StudyMagic(x[0], 0, x[1], x[2], 0);
  end;
  if n = 4 then
  begin
    StudyMagic(x[0], x[1], x[2], x[3], 0);
  end;
  Result := 0;

end;

function OldLearnMagic(L: Plua_state): integer; cdecl;
begin
  instruct_33(lua_tointeger(L, -3), lua_tointeger(L, -2), lua_tointeger(L, -1));
  Result := 0;

end;

//获取主地图坐标

function GetMainMapPosition(L: Plua_state): integer; cdecl;
begin
  lua_pushinteger(L, My);
  lua_pushinteger(L, Mx);
  Result := 2;
end;

//改变主地图坐标

function SetMainMapPosition(L: Plua_state): integer; cdecl;
begin
  Mx := lua_tointeger(L, -1);
  My := lua_tointeger(L, -2);
  Result := 0;
end;

//获取场景坐标

function GetScencePosition(L: Plua_state): integer; cdecl;
begin
  lua_pushinteger(L, Sy);
  lua_pushinteger(L, Sx);
  Result := 2;
end;

//改变场景坐标

function SetScencePosition(L: Plua_state): integer; cdecl;
begin
  Sx := lua_tointeger(L, -1);
  Sy := lua_tointeger(L, -2);
  Result := 0;
end;

function OldSetScencePosition(L: Plua_state): integer; cdecl;
begin
  instruct_19(lua_tointeger(L, -2), lua_tointeger(L, -1));
  Result := 0;
end;

function GetScenceFace(L: Plua_state): integer; cdecl;
begin
  lua_pushinteger(L, SFace);
  Result := 1;
end;

function SetScenceFace(L: Plua_state): integer; cdecl;
begin
  Sface := lua_tointeger(L, -1);
  Result := 0;
end;

//延时

function Delay(L: Plua_state): integer; cdecl;
begin
  SDL_Delay(lua_tointeger(L, -1));
  Result := 0;
end;

//绘制矩形

function DrawRect(L: Plua_state): integer; cdecl;
var
  n, i: integer;
  x: array of integer;
begin
  n := lua_gettop(L);
  setlength(x, n);
  for i := 0 to n - 1 do
  begin
    x[i] := lua_tointeger(L, -(n - i));
  end;
  Result := 0;
  if n = 7 then
    DrawRectangle(x[0], x[1], x[2], x[3], x[4], x[5], x[6]);
  if n = 6 then
    DrawRectangleWithoutFrame(x[0], x[1], x[2], x[3], x[4], x[5]);
  Result := 0;

end;

//队伍人数

function MemberAmount(L: Plua_state): integer; cdecl;
var
  n, i: integer;
begin
  n := 0;
  for i := 0 to 5 do
  begin
    if TeamList[i] >= 0 then
      n := n + 1;
  end;

  lua_pushinteger(L, n);
  Result := 1;

end;

//读队伍信息

function GetMember(L: Plua_state): integer; cdecl;
var
  n: integer;
begin
  n := lua_tointeger(L, -1);
  if (n >= 0) and (n <= 5) then
    lua_pushinteger(L, TeamList[n])
  else
    lua_pushinteger(L, 0);
  Result := 1;

end;

//写队伍信息

function PutMember(L: Plua_state): integer; cdecl;
begin
  TeamList[lua_tointeger(L, -1)] := lua_tointeger(L, -2);
  Result := 0;

end;


//读全局信息
function GetGlobalValue(L: Plua_state): integer; cdecl;
var
  n1, n2: integer;
begin
  n1 := lua_tointeger(L, -2);
  n2 := lua_tointeger(L, -1);
  //if (n >= 0) and (n <= 1000) then
  //lua_pushinteger(L, GlobalValue[n])
  if (n1 >= 0) and (n1 <= 20) and (n2 >= 0) and (n2 <= 14) then
    lua_pushinteger(L, Rshop[n1].Data[n2])
  else
    lua_pushinteger(L, -2);
  Result := 1;
end;

//写全局信息
function PutGlobalValue(L: Plua_state): integer; cdecl;
begin
  //GlobalValue[lua_tointeger(L, -1)] := lua_tointeger(L, -2);
  Rshop[lua_tointeger(L, -2)].Data[lua_tointeger(L, -1)] := lua_tointeger(L, -3);
  Result := 0;
end;


//读人物信息

function GetRolePro(L: Plua_state): integer; cdecl;
begin
  lua_pushinteger(L, Rrole[lua_tointeger(L, -2)].Data[lua_tointeger(L, -1)]);
  Result := 1;

end;

//写人物信息

function PutRolePro(L: Plua_state): integer; cdecl;
begin
  Rrole[lua_tointeger(L, -2)].Data[lua_tointeger(L, -1)] := lua_tointeger(L, -3);
  Result := 0;

end;

//读物品信息

function GetItemPro(L: Plua_state): integer; cdecl;
begin
  lua_pushinteger(L, Ritem[lua_tointeger(L, -2)].Data[lua_tointeger(L, -1)]);
  Result := 1;

end;

//写物品信息

function PutItemPro(L: Plua_state): integer; cdecl;
begin
  Ritem[lua_tointeger(L, -2)].Data[lua_tointeger(L, -1)] := lua_tointeger(L, -3);
  Result := 0;

end;

//读武功信息

function GetMagicPro(L: Plua_state): integer; cdecl;
begin
  lua_pushinteger(L, Rmagic[lua_tointeger(L, -2)].Data[lua_tointeger(L, -1)]);
  Result := 1;

end;

//写武功信息

function PutMagicPro(L: Plua_state): integer; cdecl;
begin
  Rmagic[lua_tointeger(L, -2)].Data[lua_tointeger(L, -1)] := lua_tointeger(L, -3);
  Result := 0;

end;

//读场景信息

function GetScencePro(L: Plua_state): integer; cdecl;
begin
  lua_pushinteger(L, Rscence[lua_tointeger(L, -2)].Data[lua_tointeger(L, -1)]);
  Result := 1;

end;

//写场景信息

function PutScencePro(L: Plua_state): integer; cdecl;
begin
  Rscence[lua_tointeger(L, -2)].Data[lua_tointeger(L, -1)] := lua_tointeger(L, -3);
  Result := 0;

end;

//读场景图信息

function GetScenceMapPro(L: Plua_state): integer; cdecl;
begin
  lua_pushinteger(L, sdata[lua_tointeger(L, -4), lua_tointeger(L, -3), lua_tointeger(L, -2), lua_tointeger(L, -1)]);
  Result := 1;

end;

//写场景图信息

function PutScenceMapPro(L: Plua_state): integer; cdecl;
begin
  sdata[lua_tointeger(L, -4), lua_tointeger(L, -3), lua_tointeger(L, -2),
    lua_tointeger(L, -1)] := lua_tointeger(L, -5);
  Result := 0;

end;

function OldPutScenceMapPro(L: Plua_state): integer; cdecl;
var
  list: array[0..4] of integer;
  i: integer;
begin
  for i := -5 to -1 do
    list[i + 5] := lua_tointeger(L, i);
  instruct_17(list);
  Result := 0;

end;

//读场景事件信息

function GetScenceEventPro(L: Plua_state): integer; cdecl;
begin
  lua_pushinteger(L, ddata[lua_tointeger(L, -3), lua_tointeger(L, -2), lua_tointeger(L, -1)]);
  Result := 1;

end;

//写场景事件信息

function PutScenceEventPro(L: Plua_state): integer; cdecl;
begin
  ddata[lua_tointeger(L, -3), lua_tointeger(L, -2), lua_tointeger(L, -1)] :=
    lua_tointeger(L, -4);
  Result := 0;

end;

function JudgeScenceEvent(L: Plua_state): integer; cdecl;
var
  t: integer;
begin
  t := 0;
  if DData[CurScence, lua_tointeger(L, -3), 2 + lua_tointeger(L, -2)] = lua_tointeger(L, -1) then
    t := 1;
  lua_pushinteger(L, t);
  Result := 1;
end;

function PlayMusic(L: Plua_state): integer; cdecl;
begin
  instruct_66(lua_tointeger(L, -1));
  Result := 0;
end;

function PlayWave(L: Plua_state): integer; cdecl;
begin
  instruct_67(lua_tointeger(L, -1));
  Result := 0;
end;

function WalkFromTo(L: Plua_state): integer; cdecl;
var
  x1, x2, y1, y2: integer;
begin
  x1 := lua_tointeger(L, -4);
  y1 := lua_tointeger(L, -3);
  x2 := lua_tointeger(L, -2);
  y2 := lua_tointeger(L, -1);
  instruct_30(x1, y1, x2, y2);
  Result := 0;

end;

function ScenceFromTo(L: Plua_state): integer; cdecl;
var
  x1, x2, y1, y2: integer;
begin
  x1 := lua_tointeger(L, -4);
  y1 := lua_tointeger(L, -3);
  x2 := lua_tointeger(L, -2);
  y2 := lua_tointeger(L, -1);
  instruct_25(x1, y1, x2, y2);
  Result := 0;

end;

function PlayAnimation(L: Plua_state): integer; cdecl;
var
  t, i1, i2: integer;
begin
  t := lua_tointeger(L, -3);
  i1 := lua_tointeger(L, -2);
  i2 := lua_tointeger(L, -1);
  instruct_27(t, i1, i2);
  Result := 0;

end;

function GetNameAsString(L: Plua_state): integer; cdecl;
var
  str: string;
  typenum, num: integer;
  p1: pWideChar;
begin
  typenum := lua_tointeger(L, -2);
  num := lua_tointeger(L, -1);
  case typenum of
    0: p1 := @Rrole[num].Name;
    1: p1 := @Ritem[num].Name;
    2: p1 := @Rscence[num].Name;
    3: p1 := @Rmagic[num].Name;
  end;
{$IFDEF fpc}
  str := UTF8Encode(WideString(p1));
{$ELSE}
  str := UTF8Encode(GBKToUnicode(p1));
{$ENDIF}
  lua_pushstring(L, @str[1]);
  Result := 1;

end;

function ReadTalkAsString(L: Plua_state): integer; cdecl;
var
  str: string;
  strw: WideString;
  typenum, num: integer;
  p1: pWideChar;
  a: array of byte;
begin
  num := lua_tointeger(L, -1);
  ReadTalk(num, a);
  strw := pWideChar(a);

{$IFDEF fpc}
  str := UTF8Encode(strw);
{$ELSE}
  str := UTF8Encode(GBKToUnicode(p1));
{$ENDIF}
  lua_pushstring(L, @str[1]);
  Result := 1;

end;

function ChangeScence(L: Plua_state): integer; cdecl;
var
  x, y, n: integer;
begin
  n := lua_gettop(L);
  CurScence := lua_tointeger(L, -n);
  if n = 1 then
  begin
    x := Rscence[CurScence].EntranceX;
    y := Rscence[CurScence].EntranceY;
  end
  else
  begin
    x := lua_tointeger(L, -n + 1);
    y := lua_tointeger(L, -n + 2);
  end;
  Cx := x + Cx - Sx;
  Cy := y + Cy - Sy;
  Sx := x;
  Sy := y;
  instruct_14;
  InitialScence;
  DrawScence;
  instruct_13;
  ShowScenceName(CurScence);
  CheckEvent3;
  Result := 0;

end;

function ShowPicture(L: Plua_state): integer; cdecl;
var
  t, p, n, x, y: integer;
begin
  n := lua_gettop(L);
  x := lua_tointeger(L, -2);
  y := lua_tointeger(L, -1);
  if n = 4 then
  begin
    t := lua_tointeger(L, -4);
    p := lua_tointeger(L, -3);
    case t of
      0: DrawMPic(p, x, y);
      1, 2: DrawSPic(p, x, y);
      3: DrawHeadPic(p, x, y);
      4: DrawEPic(p, x, y);
      //5:
    end;
  end;
  if n = 3 then
  begin
    //display_img(lua_tostring(L, -3), x, y);
  end;
  Result := 0;

end;

function GetItemList(L: Plua_state): integer; cdecl;
var
  i: integer;
begin
  i := lua_tointeger(L, -1);
  lua_pushinteger(L, RItemList[i].Number);
  lua_pushinteger(L, RItemList[i].Amount);
  Result := 2;
end;

function GetCurrentScence(L: Plua_state): integer; cdecl;
begin
  lua_pushinteger(L, CurScence);
  Result := 1;

end;

function GetCurrentEvent(L: Plua_state): integer; cdecl;
begin
  lua_pushinteger(L, CurEvent);
  Result := 1;

end;

//取得战斗序号

function GetBattleNumber(L: Plua_state): integer; cdecl;
var
  n, i, rnum, t: integer;
begin
  n := lua_gettop(L);
  if n = 0 then
    lua_pushinteger(L, x50[28005]);
  if n = 1 then
  begin
    rnum := lua_tointeger(L, -1);
    t := -1;
    for i := 0 to BRoleAmount - 1 do
    begin
      if Brole[i].rnum = rnum then
      begin
        t := i;
        break;
      end;
    end;
    lua_pushinteger(L, t);
  end;
  Result := 1;

end;

//选择目标

function SelectOneAim(L: Plua_state): integer; cdecl;
begin
  if lua_tointeger(L, -1) = 0 then
    SelectAim(lua_tointeger(L, -3), lua_tointeger(L, -2));
  lua_pushinteger(L, bfield[2, Ax, Ay]);
  Result := 1;
end;

//取战斗属性

function GetBattleRolePro(L: Plua_state): integer; cdecl;
begin
  lua_pushinteger(L, Brole[lua_tointeger(L, -2)].Data[lua_tointeger(L, -1)]);
  Result := 1;

end;

//写战斗属性

function PutBattleRolePro(L: Plua_state): integer; cdecl;
begin
  Brole[lua_tointeger(L, -2)].Data[lua_tointeger(L, -1)] := lua_tointeger(L, -3);
  Result := 0;

end;

function PlayAction(L: Plua_state): integer; cdecl;
var
  bnum, mtype, enum: integer;
begin
  bnum := lua_tointeger(L, -3);
  mtype := lua_tointeger(L, -2);
  enum := lua_tointeger(L, -1);
  PlayActionAmination(bnum, mtype);
  PlayMagicAmination(bnum, mtype);
  Result := 0;

end;

//function GetRoundNumber(L: Plua_state): integer; cdecl;

function PlayHurtValue(L: Plua_state): integer; cdecl;
var
  mode: integer;
begin
  mode := lua_tointeger(L, -1);
  ShowHurtValue(mode);
  Result := 0;

end;

function SetAminationLayer(L: Plua_state): integer; cdecl;
var
  x, y, w, h, t, i1, i2: integer;
begin
  x := lua_tointeger(L, -5);
  y := lua_tointeger(L, -4);
  w := lua_tointeger(L, -3);
  h := lua_tointeger(L, -2);
  t := lua_tointeger(L, -1);

  for i1 := x to x + w - 1 do
    for i2 := y to y + h - 1 do
      bfield[4, i1, i2] := t;

  Result := 0;

end;

function ClearRoleFromBattle(L: Plua_state): integer; cdecl;
var
  t: integer;
begin
  t := lua_tointeger(L, -1);
  Brole[t].Dead := 1;
  Result := 0;

end;

function AddRoleIntoBattle(L: Plua_state): integer; cdecl;
var
  rnum, team, x, y, bnum: integer;
begin
  bnum := BRoleAmount;
  BRoleAmount := BRoleAmount + 1;
  team := lua_tointeger(L, -4);
  rnum := lua_tointeger(L, -3);
  x := lua_tointeger(L, -2);
  y := lua_tointeger(L, -1);

  Brole[bnum].rnum := rnum;
  Brole[bnum].Team := team;
  Brole[bnum].X := x;
  Brole[bnum].Y := y;
  Brole[bnum].Face := 1;
  Brole[bnum].Dead := 0;
  Brole[bnum].Step := 0;
  Brole[bnum].Acted := 1;
  Brole[bnum].ShowNumber := -1;
  Brole[bnum].ExpGot := 0;

  lua_pushinteger(L, bnum);
  Result := 1;

end;

//强制设置战斗结果

function ForceBattleResult(L: Plua_state): integer; cdecl;
begin
  Bstatus := lua_tointeger(L, -1);
  Result := 0;
end;

function AskSoftStar(L: Plua_state): integer; cdecl;
begin
  instruct_51;
  Result := 0;
end;

function WeiShop(L: Plua_state): integer; cdecl;
begin
  instruct_64;
  Result := 0;
end;

function OpenAllScence(L: Plua_state): integer; cdecl;
begin
  instruct_54;
  Result := 0;
end;

function ShowEthics(L: Plua_state): integer; cdecl;
begin
  instruct_52;
  Result := 0;
end;

function ShowRepute(L: Plua_state): integer; cdecl;
begin
  instruct_53;
  Result := 0;
end;

function ChangeMMapMusic(L: Plua_state): integer; cdecl;
begin
  instruct_8(lua_tointeger(L, -1));
  Result := 0;
end;

function ZeroAllMP(L: Plua_state): integer; cdecl;
begin
  instruct_22;
  Result := 0;
end;

function SetOneUsePoi(L: Plua_state): integer; cdecl;
begin
  instruct_23(lua_tointeger(L, -2), lua_tointeger(L, -1));
  Result := 0;
end;

function Add3EventNum(L: Plua_state): integer; cdecl;
begin
  instruct_26(lua_tointeger(L, -5), lua_tointeger(L, -4), lua_tointeger(L, -3),
    lua_tointeger(L, -2), lua_tointeger(L, -1));
  Result := 0;
end;

function Judge5Item(L: Plua_state): integer; cdecl;
var
  n, i: integer;
  list: array[0..6] of integer;
begin
  for i := 0 to 6 do
    list[i] := lua_tointeger(L, i - 7);
  n := instruct_50(list);
  lua_pushboolean(L, n = list[5]);
  Result := 1;
end;

function JudgeEthics(L: Plua_state): integer; cdecl;
var
  n: integer;
begin
  n := lua_gettop(L);
  lua_pushboolean(L, instruct_28(lua_tointeger(L, -n), lua_tointeger(L, 1 - n), lua_tointeger(L, 2 - n), 1, 0) = 1);
  Result := 1;
end;

function JudgeAttack(L: Plua_state): integer; cdecl;
var
  n: integer;
begin
  n := lua_gettop(L);
  lua_pushboolean(L, instruct_29(lua_tointeger(L, -n), lua_tointeger(L, 1 - n), lua_tointeger(L, 2 - n), 1, 0) = 1);
  Result := 1;
end;

function JudgeMoney(L: Plua_state): integer; cdecl;
var
  n: integer;
begin
  n := lua_gettop(L);
  lua_pushboolean(L, instruct_31(lua_tointeger(L, -n), 1, 0) = 1);
  Result := 1;
end;

function AddAptitude(L: Plua_state): integer; cdecl;
begin
  instruct_34(lua_tointeger(L, -2), lua_tointeger(L, -1));
  Result := 0;
end;

function SetOneMagic(L: Plua_state): integer; cdecl;
begin
  instruct_35(lua_tointeger(L, -4), lua_tointeger(L, -3), lua_tointeger(L, -2),
    lua_tointeger(L, -1));
  Result := 0;
end;

function JudgeSexual(L: Plua_state): integer; cdecl;
begin
  lua_pushboolean(L, instruct_36(lua_tointeger(L, -lua_gettop(L)), 1, 0) = 1);
  Result := 1;
end;

function AddEthics(L: Plua_state): integer; cdecl;
begin
  instruct_37(lua_tointeger(L, -1));
  Result := 0;
end;

function ChangeScencePic(L: Plua_state): integer; cdecl;
begin
  instruct_38(lua_tointeger(L, -4), lua_tointeger(L, -3), lua_tointeger(L, -2),
    lua_tointeger(L, -1));
  Result := 0;
end;

function OpenScence(L: Plua_state): integer; cdecl;
begin
  instruct_39(lua_tointeger(L, -1));
  Result := 0;
end;

function JudgeFemaleInTeam(L: Plua_state): integer; cdecl;
begin
  lua_pushboolean(L, instruct_42(1, 0) = 1);
  Result := 1;
end;

function Play2Amination(L: Plua_state): integer; cdecl;
begin
  instruct_44(lua_tointeger(L, -6), lua_tointeger(L, -5), lua_tointeger(L, -4),
    lua_tointeger(L, -3), lua_tointeger(L, -2), lua_tointeger(L, -1));
  Result := 0;
end;

function AddSpeed(L: Plua_state): integer; cdecl;
begin
  instruct_45(lua_tointeger(L, -2), lua_tointeger(L, -1));
  Result := 0;
end;

function AddMP(L: Plua_state): integer; cdecl;
begin
  instruct_46(lua_tointeger(L, -2), lua_tointeger(L, -1));
  Result := 0;
end;

function AddAttack(L: Plua_state): integer; cdecl;
begin
  instruct_47(lua_tointeger(L, -2), lua_tointeger(L, -1));
  Result := 0;
end;

function AddHP(L: Plua_state): integer; cdecl;
begin
  instruct_48(lua_tointeger(L, -2), lua_tointeger(L, -1));
  Result := 0;
end;

function SetMPPro(L: Plua_state): integer; cdecl;
begin
  instruct_49(lua_tointeger(L, -2), lua_tointeger(L, -1));
  Result := 0;
end;

function JudgeEventNum(L: Plua_state): integer; cdecl;
var
  n: integer;
begin
  n := lua_gettop(L);
  lua_pushboolean(L, instruct_55(lua_tointeger(L, -n), lua_tointeger(L, 1 - n), 1, 0) = 1);
  Result := 1;
end;

function AddRepute(L: Plua_state): integer; cdecl;
begin
  instruct_56(lua_tointeger(L, -1));
  Result := 0;
end;

function BreakStoneGate(L: Plua_state): integer; cdecl;
begin
  instruct_57;
  Result := 0;
end;

function FightForTop(L: Plua_state): integer; cdecl;
begin
  instruct_58;
  Result := 0;
end;

function JudgeScencePic(L: Plua_state): integer; cdecl;
var
  n: integer;
begin
  n := lua_gettop(L);
  lua_pushboolean(L, instruct_60(lua_tointeger(L, -n), lua_tointeger(L, 1 - n), lua_tointeger(L, 2 - n), 1, 0) = 1);
  Result := 1;
end;

function Judge14BooksPlaced(L: Plua_state): integer; cdecl;
begin
  lua_pushboolean(L, instruct_61(1, 0) = 1);
  Result := 1;
end;

function SetSexual(L: Plua_state): integer; cdecl;
begin
  instruct_63(lua_tointeger(L, -2), lua_tointeger(L, -1));
  Result := 0;
end;

function BackHome(L: Plua_state): integer; cdecl;
begin
  instruct_62(lua_tointeger(L, -6), lua_tointeger(L, -5), lua_tointeger(L, -4),
    lua_tointeger(L, -3), lua_tointeger(L, -2), lua_tointeger(L, -1));
  Result := 0;
end;

function EatOneItemScript(L: Plua_state): integer; cdecl;
var
  n: integer;
begin
  n := lua_gettop(L);
  if n = 2 then
    EatOneItem(lua_tointeger(L, -n), lua_tointeger(L, 1 - n));
  Result := 0;
end;

function SelectOneTeamMemberScript(L: Plua_state): integer; cdecl;
begin
  lua_pushinteger(L, SelectOneTeamMember(0, 0, UTF8Decode(lua_tostring(L, -3)),
    lua_tointeger(L, -2), lua_tointeger(L, -1)));
  Result := 1;
end;

function SetAttributeScript(L: Plua_state): integer; cdecl;
begin
  SetAttribute(lua_tointeger(L, -5), lua_tointeger(L, -4),
    lua_tointeger(L, -3), lua_tointeger(L, -2), lua_tointeger(L, -1));
  Result := 0;
end;

function SetRoleFace(L: Plua_state): integer; cdecl;
begin
  instruct_40(lua_tointeger(L, -1));
  Result := 0;
end;

function EnterNumberScript(L: Plua_state): integer; cdecl;
begin
  lua_pushinteger(L, EnterNumber(lua_tointeger(L, -5), lua_tointeger(L, -4), lua_tointeger(L, -3),
    lua_tointeger(L, -2), lua_tointeger(L, -1)));
  Result := 1;
end;

function SetMenuEscType(L: Plua_state): integer; cdecl;
begin
  MenuEscType := lua_tointeger(L, -1);
  Result := 0;
end;

//读战场信息

function GetBattlePro(L: Plua_state): integer; cdecl;
begin
  lua_pushinteger(L, WarStaList[lua_tointeger(L, -2)].Data[lua_tointeger(L, -1)]);
  Result := 1;

end;

//写战场信息

function PutBattlePro(L: Plua_state): integer; cdecl;
begin
  WarStaList[lua_tointeger(L, -2)].Data[lua_tointeger(L, -1)] := lua_tointeger(L, -3);
  Result := 0;

end;

function ShowStatusScript(L: Plua_state): integer; cdecl;
begin
  ShowStatus(lua_tointeger(L, -1));
  UpdateAllScreen;
  Result := 0;
end;

function ShowSimpleStatusScript(L: Plua_state): integer; cdecl;
begin
  ShowSimpleStatus(lua_tointeger(L, -3), lua_tointeger(L, -2), lua_tointeger(L, -1));
  //UpdateAllScreen;
  Result := 0;
end;

function UpdateAllScreenScript(L: Plua_state): integer; cdecl;
begin
  UpdateAllScreen;
  Result := 0;
end;

function ShowAbilityScript(L: Plua_state): integer; cdecl;
begin
  ShowAbility(lua_tointeger(L, -1), -1);
  UpdateAllScreen;
  Result := 0;
end;

function GetScreenSize(L: Plua_state): integer; cdecl;
begin
  lua_pushinteger(L, CENTER_X * 2);
  lua_pushinteger(L, CENTER_Y * 2);
  Result := 2;
end;

function JumpScenceScript(L: Plua_state): integer; cdecl;
begin
  JumpScence(lua_tointeger(L, -3), lua_tointeger(L, -2), lua_tointeger(L, -1));
  Result := 0;
end;

function GetX50(L: Plua_state): integer; cdecl;
begin
  lua_pushinteger(L, x50[lua_tointeger(L, -1)]);
  Result := 1;
end;

function PutX50(L: Plua_state): integer; cdecl;
begin
  x50[lua_tointeger(L, -1)] := lua_tointeger(L, -2);
  Result := 0;
end;

function ShowTitleScript(L: Plua_state): integer; cdecl;
var
  talknum, color, n: integer;
  str: WideString = '';
begin
  n := Lua_gettop(L);
  talknum := lua_tointeger(L, -n);
  if not lua_isnumber(L, -n) then
    str := UTF8Decode(lua_tostring(L, -n));
  color := 1;
  if n > 1 then
    color := lua_tointeger(L, -1);
  NewTalk(0, talknum, -1, 2, 1, color, 0, str);
end;

function CheckJumpFlag(L: Plua_state): integer; cdecl;
begin
  lua_pushboolean(L, instruct_36(256, 1, 0) = 1);
  Result := 1;
end;

function ExitScript(L: Plua_state): integer; cdecl;
begin
  lua_pushstring(L, 'exit()');
  lua_error(L);
  Result := 1;
end;

function AddRoleProWithHintScript(L: Plua_state): integer; cdecl;
var
  n: integer;
  str: WideString = '';
begin
  n := Lua_gettop(L);
  if n >= 4 then
    str := UTF8Decode(lua_tostring(L, -n + 3));
  AddRoleProWithHint(lua_tointeger(L, -n), lua_tointeger(L, -n + 1),
    lua_tointeger(L, -n + 2), str);
  Result := 0;
end;

function ColColorScript(L: Plua_state): integer; cdecl;
begin
  lua_pushinteger(L, ColColor(lua_tointeger(L, -1)));
  Result := 1;
end;

function SetBattleName(L: Plua_state): integer; cdecl;
begin
  BattleNames[lua_tointeger(L, -2)] := UTF8Decode(lua_tostring(L, -1));
  Result := 0;
end;

end.
