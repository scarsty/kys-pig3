﻿unit kys_script;

interface

uses
  {$IFDEF fpc}
  {$ELSE}
  Windows,
  {$ENDIF}
  SysUtils,
  SDL3,
  Math,
  lua52,
  kys_type,
  kys_main,
  kys_event,
  kys_engine,
  kys_battle,
  Classes;

type
  TScriptRegister = record
    Name: putf8char;
    f: lua_CFunction;
  end;

//初始化脚本配置,运行脚本
procedure InitialScript;
procedure DestroyScript;
function ExecScript(filename, functionname: utf8string): integer;
function ExecScriptString(script, functionname: utf8string): integer;
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
function LightScene(L: Plua_state): integer; cdecl;
function DarkScene(L: Plua_state): integer; cdecl;
function Dead(L: Plua_state): integer; cdecl;
function InTeam(L: Plua_state): integer; cdecl;
function TeamIsFull(L: Plua_state): integer; cdecl;
function LeaveTeam(L: Plua_state): integer; cdecl;
function LearnMagic(L: Plua_state): integer; cdecl;
//function Sprintf(L: Plua_state): integer; cdecl;
function GetMainMapPosition(L: Plua_state): integer; cdecl;
function SetMainMapPosition(L: Plua_state): integer; cdecl;
function GetScenePosition(L: Plua_state): integer; cdecl;
function SetScenePosition(L: Plua_state): integer; cdecl;
function GetSceneFace(L: Plua_state): integer; cdecl;
function SetSceneFace(L: Plua_state): integer; cdecl;
function Delay(L: Plua_state): integer; cdecl;
function DrawRect(L: Plua_state): integer; cdecl;
function MemberAmount(L: Plua_state): integer; cdecl;
function GetMember(L: Plua_state): integer; cdecl;
function SetMember(L: Plua_state): integer; cdecl;

function GetGlobalValue(L: Plua_state): integer; cdecl;
function SetGlobalValue(L: Plua_state): integer; cdecl;

function GetRolePro(L: Plua_state): integer; cdecl;
function SetRolePro(L: Plua_state): integer; cdecl;
function GetItemPro(L: Plua_state): integer; cdecl;
function SetItemPro(L: Plua_state): integer; cdecl;

function SetItemIntro(L: Plua_state): integer; cdecl; //冰枫月之怒添加
function GetMagicPro(L: Plua_state): integer; cdecl;
function SetMagicPro(L: Plua_state): integer; cdecl;
function GetScenePro(L: Plua_state): integer; cdecl;
function SetScenePro(L: Plua_state): integer; cdecl;
function GetSceneMapPro(L: Plua_state): integer; cdecl;
function SetSceneMapPro(L: Plua_state): integer; cdecl;
function GetSceneEventPro(L: Plua_state): integer; cdecl;
function SetSceneEventPro(L: Plua_state): integer; cdecl;
function JudgeSceneEvent(L: Plua_state): integer; cdecl;
function PlayMusic(L: Plua_state): integer; cdecl;
function PlayWave(L: Plua_state): integer; cdecl;
function WalkFromTo(L: Plua_state): integer; cdecl;
function SceneFromTo(L: Plua_state): integer; cdecl;
function PlayAnimation(L: Plua_state): integer; cdecl;
function GetNameAsString(L: Plua_state): integer; cdecl;
function SetNameAsString(L: Plua_state): integer; cdecl;
function ChangeScene(L: Plua_state): integer; cdecl;
function ShowPicture(L: Plua_state): integer; cdecl;
function GetItemList(L: Plua_state): integer; cdecl;
function GetCurrentScene(L: Plua_state): integer; cdecl;
function GetCurrentEvent(L: Plua_state): integer; cdecl;

function GetBattleNumber(L: Plua_state): integer; cdecl;
function SelectOneAim(L: Plua_state): integer; cdecl;
function GetBattleRolePro(L: Plua_state): integer; cdecl;
function SetBattleRolePro(L: Plua_state): integer; cdecl;
function PlayAction(L: Plua_state): integer; cdecl;
//function GetRoundNumber(L: Plua_state): integer; cdecl;
function PlayHurtValue(L: Plua_state): integer; cdecl;
function SetAminationLayer(L: Plua_state): integer; cdecl;
function ClearRoleFromBattle(L: Plua_state): integer; cdecl;
function AddRoleIntoBattle(L: Plua_state): integer; cdecl;
function ForceBattleResult(L: Plua_state): integer; cdecl;
function AskSoftStar(L: Plua_state): integer; cdecl;
function WeiShop(L: Plua_state): integer; cdecl;
function OpenAllScene(L: Plua_state): integer; cdecl;
function ShowEthics(L: Plua_state): integer; cdecl;
function ShowRepute(L: Plua_state): integer; cdecl;
function OldSetSceneMapPro(L: Plua_state): integer; cdecl;
function ChangeMMapMusic(L: Plua_state): integer; cdecl;
function OldSetScenePosition(L: Plua_state): integer; cdecl;
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
function ChangeScenePic(L: Plua_state): integer; cdecl;
function OpenScene(L: Plua_state): integer; cdecl;
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
function JudgeScenePic(L: Plua_state): integer; cdecl;
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
function SetBattlePro(L: Plua_state): integer; cdecl;

function ShowStatusScript(L: Plua_state): integer; cdecl;
function ShowSimpleStatusScript(L: Plua_state): integer; cdecl;
function UpdateAllScreenScript(L: Plua_state): integer; cdecl;
function ShowAbilityScript(L: Plua_state): integer; cdecl;

function GetScreenSize(L: Plua_state): integer; cdecl;

function JumpSceneScript(L: Plua_state): integer; cdecl;

function GetX50(L: Plua_state): integer; cdecl;
function SetX50(L: Plua_state): integer; cdecl;

function ShowTitleScript(L: Plua_state): integer; cdecl;
function ReadTalkAsString(L: Plua_state): integer; cdecl;
function CheckJumpFlag(L: Plua_state): integer; cdecl;
function ExitScript(L: Plua_state): integer; cdecl;
function AddRoleProWithHintScript(L: Plua_state): integer; cdecl;
function ColColorScript(L: Plua_state): integer; cdecl;
function SetBattleName(L: Plua_state): integer; cdecl;

function SetShowMR(L: Plua_state): integer; cdecl;
function SetScreenBlendMode(L: Plua_state): integer; cdecl;

function PlayMovieScript(L: Plua_state): integer; cdecl;

function SetPro(L: Plua_state; pos: puint16): integer;

function ResetScene(L: Plua_state): integer; cdecl;

function setteam(L: Plua_state): integer; cdecl;
function getteam(L: Plua_state): integer; cdecl;

function readmem(L: Plua_state): integer; cdecl;
function writemem(L: Plua_state): integer; cdecl;

function getrolename(L: Plua_state): integer; cdecl;
function getitemname(L: Plua_state): integer; cdecl;
function getmagicname(L: Plua_state): integer; cdecl;
function getsubmapame(L: Plua_state): integer; cdecl;

function drawlength_s(L: Plua_state): integer; cdecl;
function getkey(L: Plua_state): integer; cdecl;

implementation

uses
  kys_draw;

procedure InitialScript;
var
  i: integer;
  list: array [0 .. 300] of TScriptRegister;
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

  {list[0].name:='talk';
    list[0].f:=Talk;

    for i:=0 to 0 do
    begin
    lua_register(Lua_script, list[i].name, list[i].f);
    end;}

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
  lua_register(Lua_script, 'changescene', ChangeScene);
  lua_register(Lua_script, 'changescenepic', ChangeScenePic);
  lua_register(Lua_script, 'instruct_38', ChangeScenePic);
  lua_register(Lua_script, 'checkbutton', CheckButton);
  lua_register(Lua_script, 'clear', Clear);
  lua_register(Lua_script, 'instruct_0', Clear);
  lua_register(Lua_script, 'clearbutton', ClearButton);
  lua_register(Lua_script, 'clearrolefrombattle', ClearRoleFromBattle);
  lua_register(Lua_script, 'compareprointeam', CompareProInTeam);
  lua_register(Lua_script, 'darkscene', DarkScene);
  lua_register(Lua_script, 'instruct_14', DarkScene);
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
  lua_register(Lua_script, 'getcurrentscene', GetCurrentScene);
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
  lua_register(Lua_script, 'getsceneeventpro', GetSceneEventPro);
  lua_register(Lua_script, 'getsceneface', GetSceneFace);
  lua_register(Lua_script, 'getscenemappro', GetSceneMapPro);
  lua_register(Lua_script, 'getsceneposition', GetScenePosition);
  lua_register(Lua_script, 'getscenepro', GetScenePro);
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
  lua_register(Lua_script, 'judgesceneevent', JudgeSceneEvent);
  lua_register(Lua_script, 'instruct_60', JudgeScenePic);
  lua_register(Lua_script, 'judgescenepic', JudgeScenePic);
  lua_register(Lua_script, 'instruct_36', JudgeSexual);
  lua_register(Lua_script, 'judgesexual', JudgeSexual);
  lua_register(Lua_script, 'jumpscene', JumpSceneScript);
  lua_register(Lua_script, 'learnmagic', LearnMagic);
  lua_register(Lua_script, 'instruct_21', LeaveTeam);
  lua_register(Lua_script, 'leave', LeaveTeam);
  lua_register(Lua_script, 'leaveteam', LeaveTeam);
  lua_register(Lua_script, 'instruct_13', LightScene);
  lua_register(Lua_script, 'lightscene', LightScene);
  lua_register(Lua_script, 'memberamount', MemberAmount);
  lua_register(Lua_script, 'menu', Menu);
  lua_register(Lua_script, 'instruct_3', ModifyEvent);
  lua_register(Lua_script, 'modifyevent', ModifyEvent);
  lua_register(Lua_script, 'instruct_33', OldLearnMagic);
  lua_register(Lua_script, 'learnmagic2', OldLearnMagic);
  lua_register(Lua_script, 'instruct_17', OldSetSceneMapPro);
  lua_register(Lua_script, 'setscenemappro2', OldSetSceneMapPro);
  lua_register(Lua_script, 'setscenemap', OldSetSceneMapPro);
  lua_register(Lua_script, 'instruct_19', OldSetScenePosition);
  lua_register(Lua_script, 'setsceneposition2', OldSetScenePosition);
  lua_register(Lua_script, 'instruct_1', OldTalk);
  lua_register(Lua_script, 'instruct_54', OpenAllScene);
  lua_register(Lua_script, 'openallscene', OpenAllScene);
  lua_register(Lua_script, 'instruct_39', OpenScene);
  lua_register(Lua_script, 'openscene', OpenScene);
  lua_register(Lua_script, 'pause', Pause);
  lua_register(Lua_script, 'instruct_44', Play2Amination);
  lua_register(Lua_script, 'play2animation', Play2Amination);
  lua_register(Lua_script, 'playaction', PlayAction);
  lua_register(Lua_script, 'instruct_27', PlayAnimation);
  lua_register(Lua_script, 'playanimation', PlayAnimation);
  lua_register(Lua_script, 'playhurtvalue', PlayHurtValue);
  lua_register(Lua_script, 'instruct_66', PlayMusic);
  lua_register(Lua_script, 'playmusic', PlayMusic);
  lua_register(Lua_script, 'instruct_67', PlayWave);
  lua_register(Lua_script, 'playwave', PlayWave);

  //set可以写成put
  lua_register(Lua_script, 'setbattlepro', SetBattlePro);
  lua_register(Lua_script, 'setbattlerolepro', SetBattleRolePro);
  lua_register(Lua_script, 'setitempro', SetItemPro);
  lua_register(Lua_script, 'setmagicpro', SetMagicPro);
  lua_register(Lua_script, 'setmember', SetMember);
  lua_register(Lua_script, 'setglobalvalue', SetGlobalValue);
  lua_register(Lua_script, 'setrolepro', SetRolePro);
  lua_register(Lua_script, 'setsceneeventpro', SetSceneEventPro);
  lua_register(Lua_script, 'setscenemappro', SetSceneMapPro);
  lua_register(Lua_script, 'setscenepro', SetScenePro);

  lua_register(Lua_script, 'putbattlepro', SetBattlePro);
  lua_register(Lua_script, 'putbattlerolepro', SetBattleRolePro);
  lua_register(Lua_script, 'putitempro', SetItemPro);
  lua_register(Lua_script, 'putmagicpro', SetMagicPro);
  lua_register(Lua_script, 'putmember', SetMember);
  lua_register(Lua_script, 'putglobalvalue', SetGlobalValue);
  lua_register(Lua_script, 'putrolepro', SetRolePro);
  lua_register(Lua_script, 'putsceneeventpro', SetSceneEventPro);
  lua_register(Lua_script, 'putscenemappro', SetSceneMapPro);
  lua_register(Lua_script, 'putscenepro', SetScenePro);

  lua_register(Lua_script, 'instruct_12', Rest);
  lua_register(Lua_script, 'rest', Rest);
  lua_register(Lua_script, 'instruct_25', SceneFromTo);
  lua_register(Lua_script, 'scenefromto', SceneFromTo);
  lua_register(Lua_script, 'selectoneaim', SelectOneAim);
  lua_register(Lua_script, 'selectoneteammember', SelectOneTeamMemberScript);
  lua_register(Lua_script, 'setaminationlayer', SetAminationLayer);
  lua_register(Lua_script, 'setattribute', SetAttributeScript);
  lua_register(Lua_script, 'setmainmapposition', SetMainMapPosition);
  lua_register(Lua_script, 'setmenuesctype', SetMenuEscType);
  lua_register(Lua_script, 'instruct_49', SetMPPro);
  lua_register(Lua_script, 'setmppro', SetMPPro);
  lua_register(Lua_script, 'setpersonmppro', SetMPPro);
  lua_register(Lua_script, 'instruct_35', SetOneMagic);
  lua_register(Lua_script, 'setonemagic', SetOneMagic);
  lua_register(Lua_script, 'instruct_23', SetOneUsePoi);
  lua_register(Lua_script, 'setoneusepoi', SetOneUsePoi);
  lua_register(Lua_script, 'instruct_40', SetRoleFace);
  lua_register(Lua_script, 'setroleface', SetRoleFace);
  lua_register(Lua_script, 'setsceneface', SetSceneFace);
  lua_register(Lua_script, 'setsceneposition', SetScenePosition);
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
  lua_register(Lua_script, 'setnameasstring', SetNameAsString);
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
  lua_register(Lua_script, 'setx50', SetX50);
  lua_register(Lua_script, 'putx50', SetX50);

  lua_register(Lua_script, 'showtitle', ShowTitleScript);
  lua_register(Lua_script, 'readtalkasstring', ReadTalkAsString);
  lua_register(Lua_script, 'checkjumpflag', CheckJumpFlag);
  lua_register(Lua_script, 'exit', ExitScript);
  lua_register(Lua_script, 'addroleprowithhint', AddRoleProWithHintScript);
  lua_register(Lua_script, 'colcolor', ColColorScript);
  lua_register(Lua_script, 'setbattlename', SetBattleName);
  lua_register(Lua_script, 'showsimplestatus', ShowSimpleStatusScript);
  lua_register(Lua_script, 'updateallscreen', UpdateAllScreenScript);

  lua_register(Lua_script, 'putitemintro', SetItemIntro); //冰枫月之怒添加

  lua_register(Lua_script, 'setitemintro', SetItemIntro); //冰枫月之怒添加

  lua_register(Lua_script, 'setshowmainrole', SetShowMR);
  lua_register(Lua_script, 'setscreenblendmode', SetScreenBlendMode);
  lua_register(Lua_script, 'playmovie', PlayMovieScript);
  lua_register(Lua_script, 'resetscene', ResetScene);

  lua_register(Lua_script, 'setteam', setteam);
  lua_register(Lua_script, 'getteam', getteam);

  lua_register(Lua_script, 'read_mem', readmem);
  lua_register(Lua_script, 'write_mem', writemem);

  lua_register(Lua_script, 'getrolename', getrolename);
  lua_register(Lua_script, 'getitemname', getitemname);
  lua_register(Lua_script, 'getmagicname', getmagicname);
  lua_register(Lua_script, 'getsubmapname', getsubmapame);

  lua_register(Lua_script, 'drawlength', drawlength_s);
  lua_register(Lua_script, 'getkey', getkey);

end;

procedure DestroyScript;
begin
  lua_close(Lua_script);
  //UnloadLuaLib;
  //UnloadLua;
end;

function ExecScript(filename, functionname: utf8string): integer;
var
  Script: utf8string;
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
  Result := 0;
end;

function ExecScriptString(script, functionname: utf8string): integer;
var
  len: integer;
begin
  try
    if (Script[1] = char($EF)) and (Script[2] = char($BB)) and (Script[3] = char($BF)) then
    begin
      kyslog('Found BOM, replace it to space');
      Script[1] := ' ';
      Script[2] := ' ';
      Script[3] := ' ';
    end;
    Script := LowerCase(Script);
    //kyslog(script);
    Result := lual_loadbuffer(Lua_script, @script[1], length(script), 'code');
    if Result = 0 then
    begin
      Result := lua_pcall(Lua_script, 0, 0, 0);
      //lua_dofile(Lua_script,putf8char(filename[1]));
      if functionname <> '' then
      begin
        lua_getglobal(Lua_script, putf8char(functionname));
        Result := lua_pcall(Lua_script, 0, 1, 0);
      end;
    end;
    //lua_gc(Lua_script, LUA_GCCOLLECT, 0);
    if Result <> 0 then
    begin
      kyslog(lua_tostring(Lua_script, -1));
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
  if ((pos < 0) and (n + pos + 1 = p5032pos)) or ((pos > 0) and (pos = p5032pos)) then
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
  event.key.key := 0;
  event.button.button := 0;
  Result := 0;

end;

//检查按键
//event.key.key = 1 when mouse motion.
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
  lua_pushinteger(L, event.key.key);
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
function SetItemIntro(L: Plua_state): integer; cdecl;
var
  n, itemnum, i, len: integer;
  str: utf8string;
  p: putf8char;
begin
  itemnum := lua_tointeger(L, -2);
  str := lua_tostring(L, -1);
  len := length(str);
  FillChar(Ritem[itemnum].Introduction[0], sizeof(@Ritem[0].Introduction), 0);
  if (len > 15) then
  begin
    kyslog('Intro length is too long!');
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

//talk(头像号, 内容[数字或字串], 姓名[数字或字串], 显示模式)
function Talk(L: Plua_state): integer; cdecl;
var
  //head, dismode, n: integer;
  //content, Name: utf8string;
  //len, headx, heady, diagx, diagy, Width, line, w1, l1, i: integer;
  //str: utf8string;
  n, i, inum, istr: integer;
  nums: array [0 .. 5] of integer = (-1, -2, -2, 0, 0, 0);
  strs: array [0 .. 1] of utf8string;
begin
  n := lua_gettop(L);
  inum := 0;
  istr := 0;
  strs[0] := '';
  strs[1] := '';
  for i := -n to -1 do
  begin
    if (inum <= high(nums)) {and lua_isnumber(L, i)} then
    begin
      nums[inum] := lua_tointeger(L, i);
      inum := inum + 1;
    end;
    {if (istr<2 )and lua_isstring(L, i) then
      begin
      strs[istr] := lua_tostring(L, i);
      istr:=istr+1;
      end;}
  end;
  if lua_type(L, -n + 1) <> LUA_TNUMBER then
  begin
    strs[0] := lua_tostring(L, -n + 1);
  end;
  if lua_type(L, -n + 2) <> LUA_TNUMBER then
  begin
    strs[1] := lua_tostring(L, -n + 2);
  end;
  if nums[3] < 0 then
    nums[3] := abs(nums[3]);
  NewTalk(nums[0], nums[1], nums[2], nums[3], nums[4], nums[5], 0, strs[0], strs[1]);
  Result := 0;
  //writeln(strs[0]);
  //writeln(strs[1]);
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
    DrawShadowText(str, diagx + w1 * 10, diagy + l1 * 22, ColColor($FF), ColColor($0));
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
  str: utf8string;
begin
  color1 := ColColor(5);
  color2 := ColColor(7);
  n := Lua_gettop(L);
  x := lua_tointeger(L, -n);
  y := lua_tointeger(L, -n + 1);
  str := lua_tostring(L, -n + 2);
  if n >= 5 then
  begin
    color1 := lua_tointeger(L, -n + 3);
    color2 := lua_tointeger(L, -n + 4);
  end;
  DrawShadowText(str, x, y, color1, color2);
  UpdateAllScreen;
  Result := 0;

end;

function ShowStringWithBox(L: Plua_state): integer; cdecl;
var
  x, y, i, n, alpha, color1, color2, incolor, framecolor: integer;
  str: utf8string;
begin
  alpha := 0;
  color1 := 0;
  color2 := $202020;
  incolor := 0;
  framecolor := ColColor(255);
  n := Lua_gettop(L);
  x := lua_tointeger(L, -n);
  y := lua_tointeger(L, -n + 1);
  str := lua_tostring(L, -n + 2);
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
  DrawTextFrame(x, y, DrawLength(str), alpha, framecolor, 0);
  DrawShadowText(str, x + 19, y + 3, color1, color2);
  UpdateAllScreen;
  Result := 0;

end;

function Menu(L: Plua_state): integer; cdecl;
var
  x, y, w, n, i, len, maxwidth, Width: integer;
  p: utf8string;
  menuString: array of utf8string;
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
    p := lua_tostring(L, -1);
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
  lua_pushinteger(L, CommonScrollMenu(x, y, w, n - 1, 15, menuString));
  Result := 1;

end;

function AskYesOrNo(L: Plua_state): integer; cdecl;
var
  x, y: integer;
  menuString: array [0 .. 1] of utf8string;
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
      x[0] := CurScene;
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
  inum: integer;
begin
  inum := lua_tointeger(L, -1);
  lua_pushinteger(L, GetItemAmount(inum));
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
  battlenum, getexp, single, n: integer;
begin
  n := lua_gettop(L);
  getexp := 1;
  single := 0;
  battlenum := lua_tointeger(L, -n);
  if n = 2 then
    getexp := lua_tointeger(L, -n + 1);
  if n = 3 then
    single := lua_tointeger(L, -n + 2);
  if ForceBattleWin = 0 then
    lua_pushboolean(L, Battle(battlenum, getexp, single))
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

function LightScene(L: Plua_state): integer; cdecl;
begin
  instruct_13;
  Result := 0;

end;

function DarkScene(L: Plua_state): integer; cdecl;
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
function GetScenePosition(L: Plua_state): integer; cdecl;
begin
  lua_pushinteger(L, Sy);
  lua_pushinteger(L, Sx);
  Result := 2;
end;

//改变场景坐标
function SetScenePosition(L: Plua_state): integer; cdecl;
begin
  Sx := lua_tointeger(L, -1);
  Sy := lua_tointeger(L, -2);
  Result := 0;
end;

function OldSetScenePosition(L: Plua_state): integer; cdecl;
begin
  instruct_19(lua_tointeger(L, -2), lua_tointeger(L, -1));
  Result := 0;
end;

function GetSceneFace(L: Plua_state): integer; cdecl;
begin
  lua_pushinteger(L, SFace);
  Result := 1;
end;

function SetSceneFace(L: Plua_state): integer; cdecl;
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
function SetMember(L: Plua_state): integer; cdecl;
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
function SetGlobalValue(L: Plua_state): integer; cdecl;
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
function SetRolePro(L: Plua_state): integer; cdecl;
begin
  setpro(L, @Rrole[lua_tointeger(L, -2)].Data[lua_tointeger(L, -1)]);
  Result := 0;
end;

//读物品信息
function GetItemPro(L: Plua_state): integer; cdecl;
begin
  lua_pushinteger(L, Ritem[lua_tointeger(L, -2)].Data[lua_tointeger(L, -1)]);
  Result := 1;
end;

//写物品信息
function SetItemPro(L: Plua_state): integer; cdecl;
begin
  setpro(L, @Ritem[lua_tointeger(L, -2)].Data[lua_tointeger(L, -1)]);
  Result := 0;
end;

//读武功信息
function GetMagicPro(L: Plua_state): integer; cdecl;
begin
  lua_pushinteger(L, Rmagic[lua_tointeger(L, -2)].Data[lua_tointeger(L, -1)]);
  Result := 1;
end;

//写武功信息
function SetMagicPro(L: Plua_state): integer; cdecl;
begin
  setpro(L, @Rmagic[lua_tointeger(L, -2)].Data[lua_tointeger(L, -1)]);
  Result := 0;
end;

//读场景信息
function GetScenePro(L: Plua_state): integer; cdecl;
begin
  lua_pushinteger(L, Rscene[lua_tointeger(L, -2)].Data[lua_tointeger(L, -1)]);
  Result := 1;

end;

//写场景信息
function SetScenePro(L: Plua_state): integer; cdecl;
begin
  setpro(L, @Rscene[lua_tointeger(L, -2)].Data[lua_tointeger(L, -1)]);
  Result := 0;
end;

//读场景图信息
function GetSceneMapPro(L: Plua_state): integer; cdecl;
begin
  lua_pushinteger(L, sdata[lua_tointeger(L, -4), lua_tointeger(L, -3), lua_tointeger(L, -1), lua_tointeger(L, -2)]);
  Result := 1;

end;

//写场景图信息
function SetSceneMapPro(L: Plua_state): integer; cdecl;
begin
  sdata[lua_tointeger(L, -4), lua_tointeger(L, -3), lua_tointeger(L, -1), lua_tointeger(L, -2)] := lua_tointeger(L, -5);
  Result := 0;

end;

function OldSetSceneMapPro(L: Plua_state): integer; cdecl;
var
  list: array [0 .. 4] of integer;
  i: integer;
begin
  for i := -5 to -1 do
    list[i + 5] := lua_tointeger(L, i);
  instruct_17(list);
  Result := 0;

end;

//读场景事件信息
function GetSceneEventPro(L: Plua_state): integer; cdecl;
var
  snum, enum: integer;
begin
  snum := lua_tointeger(L, -3);
  enum := lua_tointeger(L, -2);
  if snum = -2 then
    snum := CurScene;
  if enum = -2 then
    enum := CurEvent;
  lua_pushinteger(L, ddata[snum, enum, lua_tointeger(L, -1)]);
  Result := 1;

end;

//写场景事件信息
function SetSceneEventPro(L: Plua_state): integer; cdecl;
var
  snum, enum: integer;
begin
  snum := lua_tointeger(L, -3);
  enum := lua_tointeger(L, -2);
  if snum = -2 then
    snum := CurScene;
  if enum = -2 then
    enum := CurEvent;
  ddata[snum, enum, lua_tointeger(L, -1)] := lua_tointeger(L, -4);
  Result := 0;

end;

function JudgeSceneEvent(L: Plua_state): integer; cdecl;
var
  t: integer;
begin
  t := 0;
  if DData[CurScene, lua_tointeger(L, -3), 2 + lua_tointeger(L, -2)] = lua_tointeger(L, -1) then
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

function SceneFromTo(L: Plua_state): integer; cdecl;
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
  str: utf8string;
  typenum, num: integer;
  p1: putf8char;
begin
  typenum := lua_tointeger(L, -2);
  num := lua_tointeger(L, -1);
  case typenum of
    0: p1 := @Rrole[num].Name;
    1: p1 := @Ritem[num].Name;
    2: p1 := @Rscene[num].Name;
    3: p1 := @Rmagic[num].Name;
  end;
  {$IFDEF fpc}
  str := p1;
  {$ELSE}
  str := UTF8Encode(GBKToUnicode(p1));
  {$ENDIF}
  lua_pushstring(L, @str[1]);
  Result := 1;

end;

function SetNameAsString(L: Plua_state): integer; cdecl;
var
  str: utf8string;
  strw: utf8string;
  typenum, num, i: integer;
  p1: putf8char;
begin
  typenum := lua_tointeger(L, -2);
  num := lua_tointeger(L, -1);
  case typenum of
    0: p1 := @Rrole[num].Name;
    1: p1 := @Ritem[num].Name;
    2: p1 := @Rscene[num].Name;
    3: p1 := @Rmagic[num].Name;
  end;
  strw := lua_tostring(L, -3);
  Result := 0;
  for i := 0 to length(strw) do
  begin
    (p1 + i)^ := widechar(0);
    if i < length(strw) then
      (p1 + i)^ := strw[i + 1];
  end;

end;

function ReadTalkAsString(L: Plua_state): integer; cdecl;
var
  str: utf8string;
  strw: utf8string;
  typenum, num: integer;
  p1: putf8char;
  a: array of byte;
begin
  num := lua_tointeger(L, -1);
  ReadTalk(num, a);
  strw := putf8char(a);

  {$IFDEF fpc}
  str := UTF8Encode(strw);
  {$ELSE}
  str := UTF8Encode(GBKToUnicode(p1));
  {$ENDIF}
  lua_pushstring(L, @str[1]);
  Result := 1;

end;

function ChangeScene(L: Plua_state): integer; cdecl;
var
  x, y, n: integer;
begin
  n := lua_gettop(L);
  CurScene := lua_tointeger(L, -n);
  if n = 1 then
  begin
    x := Rscene[CurScene].EntranceX;
    y := Rscene[CurScene].EntranceY;
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
  InitialScene;
  DrawScene;
  instruct_13;
  ShowSceneName(CurScene);
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

function GetCurrentScene(L: Plua_state): integer; cdecl;
begin
  lua_pushinteger(L, CurScene);
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
function SetBattleRolePro(L: Plua_state): integer; cdecl;
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
var
  n: integer;
begin
  n := lua_gettop(L);
  if n = 0 then
    instruct_64
  else
    NewShop(lua_tointeger(L, -1));
  Result := 0;
end;

function OpenAllScene(L: Plua_state): integer; cdecl;
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
  instruct_26(lua_tointeger(L, -5), lua_tointeger(L, -4), lua_tointeger(L, -3), lua_tointeger(L, -2), lua_tointeger(L, -1));
  Result := 0;
end;

function Judge5Item(L: Plua_state): integer; cdecl;
var
  n, i: integer;
  list: array [0 .. 6] of integer;
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
  instruct_35(lua_tointeger(L, -4), lua_tointeger(L, -3), lua_tointeger(L, -2), lua_tointeger(L, -1));
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

function ChangeScenePic(L: Plua_state): integer; cdecl;
begin
  instruct_38(lua_tointeger(L, -4), lua_tointeger(L, -3), lua_tointeger(L, -2), lua_tointeger(L, -1));
  Result := 0;
end;

function OpenScene(L: Plua_state): integer; cdecl;
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
  instruct_44(lua_tointeger(L, -6), lua_tointeger(L, -5), lua_tointeger(L, -4), lua_tointeger(L, -3), lua_tointeger(L, -2), lua_tointeger(L, -1));
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

function JudgeScenePic(L: Plua_state): integer; cdecl;
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
  instruct_62(lua_tointeger(L, -6), lua_tointeger(L, -5), lua_tointeger(L, -4), lua_tointeger(L, -3), lua_tointeger(L, -2), lua_tointeger(L, -1));
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
  lua_pushinteger(L, SelectOneTeamMember(0, 0, utf8string(lua_tostring(L, -3)), lua_tointeger(L, -2), lua_tointeger(L, -1)));
  Result := 1;
end;

function SetAttributeScript(L: Plua_state): integer; cdecl;
begin
  SetAttribute(lua_tointeger(L, -5), lua_tointeger(L, -4), lua_tointeger(L, -3), lua_tointeger(L, -2), lua_tointeger(L, -1));
  Result := 0;
end;

function SetRoleFace(L: Plua_state): integer; cdecl;
begin
  instruct_40(lua_tointeger(L, -1));
  Result := 0;
end;

function EnterNumberScript(L: Plua_state): integer; cdecl;
begin
  lua_pushinteger(L, EnterNumber(lua_tointeger(L, -5), lua_tointeger(L, -4), lua_tointeger(L, -3), lua_tointeger(L, -2), lua_tointeger(L, -1)));
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
function SetBattlePro(L: Plua_state): integer; cdecl;
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

function JumpSceneScript(L: Plua_state): integer; cdecl;
begin
  JumpScene(lua_tointeger(L, -3), lua_tointeger(L, -2), lua_tointeger(L, -1));
  Result := 0;
end;

function GetX50(L: Plua_state): integer; cdecl;
begin
  lua_pushinteger(L, x50[lua_tointeger(L, -1)]);
  Result := 1;
end;

function SetX50(L: Plua_state): integer; cdecl;
var
  str: utf8string;
  p: putf8char;
  i: integer;
begin
  if lua_isstring(L, 2) then
  begin
    str := lua_tostring(L, 2);
    p := putf8char(@x50[lua_tointeger(L, 1)]);
    for i := 1 to length(str) do
    begin
      p^ := str[i];
      Inc(p);
    end;
    //p^:=utf8char(0);
  end
  else
    x50[lua_tointeger(L, 1)] := lua_tointeger(L, 2);
  Result := 0;
end;

function ShowTitleScript(L: Plua_state): integer; cdecl;
var
  talknum, color, n: integer;
  str: utf8string = '';
begin
  n := Lua_gettop(L);
  talknum := lua_tointeger(L, -n);
  if not lua_isnumber(L, -n) then
    str := lua_tostring(L, -n);
  color := 1;
  if n > 1 then
    color := lua_tointeger(L, -1);
  NewTalk(0, talknum, -1, 2, 1, color, 0, str);
  Result := 0;
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
  str: utf8string = '';
begin
  n := Lua_gettop(L);
  if n >= 4 then
    str := lua_tostring(L, -n + 3);
  AddRoleProWithHint(lua_tointeger(L, -n), lua_tointeger(L, -n + 1), lua_tointeger(L, -n + 2), str);
  Result := 0;
end;

function ColColorScript(L: Plua_state): integer; cdecl;
begin
  lua_pushinteger(L, ColColor(lua_tointeger(L, -1)));
  Result := 1;
end;

function SetBattleName(L: Plua_state): integer; cdecl;
begin
  BattleNames[lua_tointeger(L, -2)] := lua_tostring(L, -1);
  Result := 0;
end;

function SetShowMR(L: Plua_state): integer; cdecl;
var
  a: integer;
begin
  a := lua_tointeger(L, -1);
  ShowMR := a <> 0;
  Result := 0;
end;

function SetScreenBlendMode(L: Plua_state): integer; cdecl;
begin
  ScreenBlendMode := lua_tointeger(L, -1);
  Result := 0;
end;

function PlayMovieScript(L: Plua_state): integer; cdecl;
begin
  DrawRectangleWithoutFrame(0, 0, CENTER_X * 2, CENTER_Y * 2, 0, 0);
  //UpdateAllScreen;
  if PlayMovie(lua_tostring(L, -1)) then
  begin
    CleanKeyValue;
    WaitAnyKey;
  end;
  Redraw;
  //UpdateAllScreen;
  Result := 0;
end;

function SetPro(L: Plua_state; pos: puint16): integer;
var
  i: integer;
  str: utf8string;
begin
  Result := 1;
  if lua_isnumber(L, -3) then
  begin
    pos^ := lua_tointeger(L, -3);
  end
  else if lua_isstring(L, -3) then
  begin
    str := lua_tostring(L, -3);
    writeln(str);
    Result := length(str);
    for i := 0 to Result - 1 do
    begin
      putf8char(pos)^ := str[i + 1];
      Inc(pos);
    end;
  end;
end;

function ResetScene(L: Plua_state): integer; cdecl;
begin
  move(Rscene0[low(Rscene0)], Rscene[low(Rscene)], sizeof(Tscene) * length(Rscene));
  resetEntrance;
  Result := 0;
end;

function setteam(L: Plua_state): integer; cdecl;
begin
  TeamList[lua_tointeger(L, -2)] := lua_tointeger(L, -1);
  Result := 0;
end;

function getteam(L: Plua_state): integer; cdecl;
begin
  lua_pushnumber(L, TeamList[lua_tointeger(L, -1)]);
  Result := 1;
end;

function readmem(L: Plua_state): integer; cdecl;
var
  x: integer;
begin
  x := lua_tointeger(L, -1);
  instruct_50e(26, 0, 0, x mod 65536, x div 65536, 9999, 0);
  lua_pushnumber(L, x50[9999]);
  Result := 1;
end;

function writemem(L: Plua_state): integer; cdecl;
var
  x: integer;
begin
  x := lua_tointeger(L, -2);
  x50[9999] := lua_tointeger(L, -1);
  instruct_50e(25, 1, 0, x mod 65536, x div 65536, 9999, 0);
  Result := 0;
end;

function getrolename(L: Plua_state): integer; cdecl;
begin
  lua_pushstring(L, @Rrole[lua_tointeger(L, -1)].Name[0]);
  Result := 1;
end;

function getitemname(L: Plua_state): integer; cdecl;
begin
  lua_pushstring(L, @Ritem[lua_tointeger(L, -1)].Name[0]);
  Result := 1;
end;

function getmagicname(L: Plua_state): integer; cdecl;
begin
  lua_pushstring(L, @Rmagic[lua_tointeger(L, -1)].Name[0]);
  Result := 1;
end;

function getsubmapame(L: Plua_state): integer; cdecl;
begin
  lua_pushstring(L, @Rscene[lua_tointeger(L, -1)].Name[0]);
  Result := 1;
end;

function drawlength_s(L: Plua_state): integer; cdecl;
var
  str: utf8string;
begin
  str := lua_tostring(L, -1);
  lua_pushinteger(L, drawlength(str));
  Result := 1;
end;

function getkey(L: Plua_state): integer; cdecl;
var
  key: integer;
begin
  key := waitanykey();
  lua_pushinteger(L, key);
  Result := 1;
end;

end.
