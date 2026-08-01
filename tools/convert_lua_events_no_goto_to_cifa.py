from __future__ import annotations

import argparse
import re
from pathlib import Path


TALK_LINES = (Path(__file__).resolve().parents[1] / "game/resource/talk1.txt").read_text(encoding="utf-8-sig").splitlines()


def talk_literal(talk_id: int) -> str:
    if talk_id <= 0 or talk_id > len(TALK_LINES):
        raise ConvertError(f"talk id out of range: {talk_id}")
    text = TALK_LINES[talk_id - 1].replace("\\", "\\\\").replace('"', '\\"')
    return f'"{text}"'


CALL_NAME_ALIASES = {
    "Talk": "talk",
    "ModifyEvent": "modifyevent",
    "Add3EventNum": "add3eventnum",
    "AskBattle": "askbattle",
    "TryBattle": "trybattle",
    "AskJoin": "askjoin",
    "Join": "join",
    "Leave": "leave",
    "LightScene": "lightscene",
    "DarkScene": "darkscene",
    "Dead": "dead",
    "InTeam": "inteam",
    "TeamIsFull": "teamisfull",
    "GetItem": "AddItem",
    "AddItem": "AddItemWithoutHint",
    "HaveItem": "haveitem",
    "HaveItemAmount": "haveitemamount",
    "UseItem": "useitem",
    "ShowString": "showstring",
    "ShowStringWithBox": "showstringwithbox",
    "ShowTitle": "showtitle",
    "AskYesOrNo": "askyesorno",
    "SetSceneMap": "setscenemap",
    "SetSceneMapPro": "setscenemappro",
    "SetSceneMapPro2": "setscenemappro2",
    "GetSceneMapPro": "getscenemappro",
    "SetScenePosition": "setsceneposition",
    "SetScenePosition2": "setsceneposition2",
    "SetSceneFace": "setsceneface",
    "ChangeScene": "changescene",
    "JumpScene": "jumpscene",
    "WalkFromTo": "walkfromto",
    "SceneFromTo": "scenefromto",
    "PlayAnimation": "playanimation",
    "Play2Amination": "play2animation",
    "EndAmination": "endanimation",
    "PlayMusic": "playmusic",
    "PlayWave": "playwave",
    "GetRolePro": "getrolepro",
    "SetRolePro": "setrolepro",
    "GetItemPro": "getitempro",
    "SetItemPro": "setitempro",
    "GetMagicPro": "getmagicpro",
    "SetMagicPro": "setmagicpro",
    "GetScenePro": "getscenepro",
    "SetScenePro": "setscenepro",
    "GetSceneEventPro": "getsceneeventpro",
    "SetSceneEventPro": "setsceneeventpro",
    "GetGlobalValue": "getglobalvalue",
    "SetGlobalValue": "setglobalvalue",
    "GetMember": "getmember",
    "SetMember": "setmember",
    "MemberAmount": "memberamount",
    "ShowAbility": "showability",
    "ShowStatus": "showstatus",
    "ShowSimpleStatus": "showsimplestatus",
    "UpdateAllScreen": "updateallscreen",
    "JudgeEthics": "judgeethics",
    "JudgeAttack": "judgeattack",
    "JudgeMoney": "judgemoney",
    "JudgeSexual": "judgesexual",
    "JudgeFemaleInTeam": "judgefemaleinteam",
    "JudgeEventNum": "judgeeventnum",
    "JudgeScenePic": "judgescenepic",
    "Judge14BooksPlaced": "judge14booksplaced",
    "JudgeSceneEvent": "judgesceneevent",
    "CheckJumpFlag": "checkjumpflag",
    "AddAptitude": "addaptitude",
    "AddEthics": "addethics",
    "AddHP": "addhp",
    "AddMP": "addmp",
    "AddAttack": "addattack",
    "AddSpeed": "addspeed",
    "AddRepute": "addrepute",
    "SetMPPro": "setmppro",
    "SetPersonMPPro": "setpersonmppro",
    "SetOneMagic": "setonemagic",
    "SetOneUsePoi": "setoneusepoi",
    "ChangeScenePic": "changescenepic",
    "OpenScene": "openscene",
    "BreakStoneGate": "breakstonegate",
    "FightForTop": "fightfortop",
    "ShowEthics": "showethics",
    "ShowRepute": "showrepute",
    "OpenAllScene": "openallscene",
    "ZeroMP": "zeromp",
    "ZeroAllMP": "zeroallmp",
    "WeiShop": "weishop",
    "PlayMovie": "playmovie",
    "DrawRect": "drawrect",
    "ShowPicture": "showpicture",
    "SelectOneAim": "selectoneaim",
    "SetAnimationLayer": "setanimationlayer",
    "ClearRoleFromBattle": "clearrolefrombattle",
    "AddRoleIntoBattle": "addroleintobattle",
    "ForceBattleResult": "forcebattleresult",
    "GetBattleNumber": "getbattlenumber",
    "CompareProInTeam": "compareprointeam",
    "SetItemIntro": "setitemintro",
    "AskSoftStar": "asksoftstar",
    "SetBattleName": "setbattlename",
    "SetShowMainRole": "setshowmainrole",
    "SetScreenBlendMode": "setscreenblendmode",
    "ResetScene": "resetscene",
    "AddRoleProWithHint": "addroleprowithhint",
    "GetScreenSize": "getscreensize",
    "GetCurrentScene": "getcurrentscene",
    "GetCurrentEvent": "getcurrentevent",
    "DrawLength": "drawlength",
    "ColColor": "colcolor",
    "EnterNumber": "enternumber",
    "GetX50": "getx50",
    "SetX50": "setx50",
}


SPECIAL_EVENT_REASONS = {
    "234": "seed crafting transaction UI",
    "235": "seed crafting transaction UI",
    "237": "herb crafting transaction UI",
    "238": "fruit crafting transaction UI",
    "239": "food crafting transaction UI",
    "248": "seed crafting transaction UI",
    "250": "weapon crafting transaction UI",
    "251": "quiz minigame UI",
    "301": "Lua block labels in story cinematic",
    "366": "custom Lua map flow",
    "367": "custom Lua map flow",
    "483": "area battle effect with random damage",
    "490": "special battle effect",
    "491": "special battle effect",
}


BOOLEAN_CALL_NAMES = frozenset({
    "AskBattle", "AskJoin", "AskYesOrNo", "CheckJumpFlag", "HaveItem", "HaveItemAmount",
    "InTeam", "Judge14BooksPlaced", "JudgeAttack", "JudgeEthics", "JudgeEventNum",
    "JudgeFemaleInTeam", "JudgeMoney", "JudgeSceneEvent", "JudgeScenePic", "JudgeSexual",
    "TeamIsFull", "TryBattle", "UseItem",
})


KEYWORDS = {"if", "while", "for", "return", "switch", "case", "default", "else"}


class ConvertError(Exception):
    pass


UNSUPPORTED_PATTERNS = [
    (re.compile(r"\bpairs\s*\("), "pairs iteration"),
    (re.compile(r"#[A-Za-z_{]"), "length operator"),
    (re.compile(r"\bthen\b[^\r\n;]+\bend\b", re.IGNORECASE), "inline if/end"),
    (re.compile(r"\[[\"']"), "string keyed table access"),
    (re.compile(r"^\s*[A-Za-z_][A-Za-z0-9_]*(?:\[[^\]]+\])?\s*=\s*\{", re.MULTILINE), "Lua table construction"),
]


SYNTHESIS_CONFIG_EVENTS = {"762", "783", "784", "793", "796", "803", "804"}


INSTRUCT_50_ALIASES = {
    0: "setx50value",
    1: "setx50array",
    2: "getx50array",
    3: "calcx50",
    4: "comparex50",
    5: "ClearX50",
    8: "gettalk",
    9: "format50",
    10: "stringlength",
    11: "concat",
    12: "MakeSpaces",
    16: "setr",
    17: "getr",
    18: "teamset",
    19: "teamget",
    20: "itemamount",
    21: "dset",
    22: "dget",
    23: "sset",
    24: "sget",
    25: "memoryset",
    26: "memoryget",
    27: "getname",
    28: "battlenumber",
    29: "selectaim",
    30: "battlefieldget",
    31: "battlefieldset",
    32: "setnextarg",
    33: "drawstring",
    34: "drawrect50",
    35: "keytox50",
    36: "showmessage",
    37: "Delay",
    38: "Random50",
    39: "Menu50",
    40: "ScrollMenu50",
    41: "DrawPicture",
    42: "SetMainMapPosition",
    43: "CallEvent",
    44: "PlayAction",
    45: "showhurtvalue",
    46: "SetAnimationLayer",
    47: "redraw",
    48: "Debug",
    49: "pe",
    50: "InputName",
    51: "EnterNumber",
    52: "HaveMagic",
    53: "AddRoleAttribute",
    54: "SetWalkPicture",
    55: "PlayMovie",
    60: "CallScript",
}


RECORD_ACCESSORS = {
    0: ("GetRole", "SetRole"),
    1: ("GetItem", "SetItem"),
    2: ("GetSubmapInfo", "SetSubmapInfo"),
    3: ("GetMagic", "SetMagic"),
    4: ("GetShop", "SetShop"),
}


def convert_ka302() -> str:
    output = """//instruct_50(43, 0, 351, 363, 4, 0, 0);
//instruct_50(4, 0, 2, 28931, 1, 0, 0);
showstringwithbox(10, 10, "你想學哪種武功？");
pause();
a = -1;
while (a < 0) {
    a = menu(4, 10, 40, -1, {"南山刀法", "越女劍法", "碧波掌法", "柯氏降魔杖"});
}
if (a == 3) {
    Talk(369, "嘿嘿，小子，有眼光！我就把我家傳的柯氏降魔杖傳授給你！", -2, 0, 0, 0);
    instruct_50(17, 0, 0, 0, 106, 10, 0);
    instruct_50(3, 0, 0, 10, 10, 10, 0);
    instruct_50(16, 4, 0, 0, 106, 10, 0);
    instruct_50(43, 0, 231, 0, 91, 2, 0);
    instruct_50(0, 0, 0, 0, 0, 0, 0);
    instruct_50(4, 0, 5, 0, 1, 0, 0);
}
else if (a == 2) {
    Talk(242, "哈哈，你很會挑師父嘛！這套碧波掌，是我桃花島的入門武功，就傳給你吧！", -2, 0, 0, 0);
    instruct_50(17, 0, 0, 0, 100, 10, 0);
    instruct_50(3, 0, 0, 10, 10, 10, 0);
    instruct_50(16, 4, 0, 0, 100, 10, 0);
    instruct_50(43, 0, 231, 0, 1, 2, 0);
    instruct_50(0, 0, 0, 0, 0, 0, 0);
    instruct_50(4, 0, 5, 0, 1, 0, 0);
}
else if (a == 1) {
    Talk(2, "好孩子，這套越女劍法，是靖哥哥的七師父韓小瑩留下來的，我就傳授與你吧！", -2, 0, 0, 0);
    instruct_50(17, 0, 0, 0, 102, 10, 0);
    instruct_50(3, 0, 0, 10, 10, 10, 0);
    instruct_50(16, 4, 0, 0, 102, 10, 0);
    instruct_50(43, 0, 231, 0, 36, 2, 0);
    instruct_50(0, 0, 0, 0, 0, 0, 0);
    instruct_50(4, 0, 5, 0, 1, 0, 0);
}
else {
    Talk(1, "我四師父的這套南山刀法，法度嚴謹，是刀法入門之基礎，我就傳授給你吧！", -2, 0, 0, 0);
    instruct_50(17, 0, 0, 0, 104, 10, 0);
    instruct_50(3, 0, 0, 10, 10, 10, 0);
    instruct_50(16, 4, 0, 0, 104, 10, 0);
    instruct_50(43, 0, 231, 0, 66, 2, 0);
}
GetItem(62, 1);
GetItem(88, 1);
GetItem(113, 1);
GetItem(135, 1);
GetItem(161, 1);
"""
    converted_lines: list[str] = []
    for line in output.splitlines():
        code, comment = split_comment(line)
        indent = re.match(r"\s*", code).group(0)
        converted = convert_instruct_50(code.strip().rstrip(";"))
        if converted is None:
            converted_lines.append(indent + normalize_call_name(code.strip()) + comment)
        else:
            converted_lines.append(indent + converted + ";" + comment)
    return "\n".join(converted_lines) + "\n"


def convert_ka1049() -> str:
    return """SetX50(1042, 0);
SetX50(1075, -1);
SetX50(1080, 15);
do {
    SetX50(1075, GetX50(1075) + 1);
    battlefieldget(1, 1075, 10, 1076, 0, 0);
    if (GetX50(1076) != 1) {
        battlefieldget(1, 1075, 0, 1077, 0, 0);
        if (GetX50(1077) != -1) {
            battlefieldget(1, 1075, 2, 1079, 0, 0);
            if (GetX50(1079) == GetX50(1074)) {
                SetX50(1078, GetRole(GetX50(1077), 110 / 2));
                if (GetX50(1078) >= GetX50(1080)) {
                    SetX50(1042, GetX50(1042) + GetX50(1078));
                }
            }
        }
    }
} while (GetX50(1075) < 25);
"""


def convert_ka1050() -> str:
    return """SetX50(1032, 0);
SetX50(1075, -1);
SetX50(1080, 15);
do {
    SetX50(1075, GetX50(1075) + 1);
    battlefieldget(1, 1075, 10, 1076, 0, 0);
    if (GetX50(1076) != 1) {
        battlefieldget(1, 1075, 0, 1077, 0, 0);
        if (GetX50(1077) != -1) {
            battlefieldget(1, 1075, 2, 1079, 0, 0);
            if (GetX50(1079) != GetX50(1074)) {
                SetX50(1078, GetRole(GetX50(1077), 110 / 2));
                if (GetX50(1078) >= GetX50(1080)) {
                    SetX50(1032, GetX50(1032) + GetX50(1078));
                }
            }
        }
    }
} while (GetX50(1075) < 25);
"""


def convert_ka1858() -> str:
    return """SetX50(2000, 0);
SetX50(1000, GetTeam(GetX50(2000)));
if (GetX50(1000) < 0) {
    ShowTitle("全隊輕功增加10", 0);
} else {
    SetX50(3000, GetRole(GetX50(1000), 88 / 2));
    SetX50(3000, GetX50(3000) + 10);
    SetRole(GetX50(1000), 88 / 2, GetX50(3000));
    exit();
}
"""


def convert_ka1424() -> str:
    return """modifyevent(95, 7, 0, 0, 0, 0, 0, 0, 0, 0, 0, -2, -2);
modifyevent(15, 19, 1, 0, 739, 0, 0, 5342, 5342, 5342, 0, -2, -2);
SetStarState(39, 1);
if (GetStarState(37) != 0) {
    SetStarState(37, 1);
    modifyevent(15, 18, 1, 0, 738, 0, 0, 5334, 5334, 5334, 0, -2, -2);
}
modifyevent(95, 6, 1, 0, 0, 0, 0, 0, 0, 0, 0, -2, -2);
if (GetStarState(43) != 0) {
    SetStarState(43, 1);
    modifyevent(15, 22, 1, 0, 743, 0, 0, 5324, 5324, 5324, 0, -2, -2);
    modifyevent(95, 5, 0, 0, 0, 0, 0, 0, 0, 0, 0, -2, -2);
    if (!JudgeSexual(0)) {
        SetX50(0, GetRole(166, 76 / 2));
        modifyevent(95, 141, 1, 0, 1392, GetX50(0), 0, 5326, 5326, 5326, 0, -2, -2);
        modifyevent(95, 5, 0, 0, 0, 0, 0, 0, 0, 0, 0, -2, -2);
    }
} else {
    SetX50(0, GetRole(166, 76 / 2));
    modifyevent(95, 141, 1, 0, 1392, GetX50(0), 0, 5326, 5326, 5326, 0, -2, -2);
    modifyevent(95, 5, 0, 0, 0, 0, 0, 0, 0, 0, 0, -2, -2);
}
if (GetStarState(41) != 0) {
    SetStarState(41, 1);
    modifyevent(15, 21, 1, 0, 741, 0, 0, 5316, 5316, 5316, 0, -2, -2);
    if (!JudgeSexual(0)) {
        modifyevent(95, 143, 1, 0, 1395, 0, 0, 5302, 5302, 5302, 0, -2, -2);
        modifyevent(95, 136, 0, 0, 0, 0, 0, 0, 0, 0, 0, -2, -2);
    }
} else {
    modifyevent(95, 143, 1, 0, 1395, 0, 0, 5302, 5302, 5302, 0, -2, -2);
    modifyevent(95, 136, 0, 0, 0, 0, 0, 0, 0, 0, 0, -2, -2);
}
if (GetStarState(46) != 0) {
    SetStarState(46, 1);
    modifyevent(15, 37, 1, 0, 786, 0, 0, 7294, 7294, 7294, 0, -2, -2);
    if (!JudgeSexual(0)) {
        modifyevent(47, 1, 1, 0, 1403, 0, 0, 7292, 7292, 7292, 0, -2, -2);
        modifyevent(95, 137, 0, 0, 0, 0, 0, 0, 0, 0, 0, -2, -2);
    }
} else {
    modifyevent(47, 1, 1, 0, 1403, 0, 0, 7292, 7292, 7292, 0, -2, -2);
    modifyevent(95, 137, 0, 0, 0, 0, 0, 0, 0, 0, 0, -2, -2);
}
if (GetStarState(61) != 0) {
    SetStarState(61, 1);
    modifyevent(15, 25, 1, 0, 761, 0, 0, 7308, 7308, 7308, 0, -2, -2);
    if (!JudgeSexual(0)) {
        modifyevent(3, 39, 1, 0, 1404, 1406, 0, 7310, 7310, 7310, 0, -2, -2);
        modifyevent(95, 4, 1, 0, 0, 0, 0, 0, 0, 0, 0, -2, -2);
    }
} else {
    modifyevent(3, 39, 1, 0, 1404, 1406, 0, 7310, 7310, 7310, 0, -2, -2);
    modifyevent(95, 4, 1, 0, 0, 0, 0, 0, 0, 0, 0, -2, -2);
}
if (GetStarState(69) != 0) {
    SetStarState(69, 1);
    modifyevent(15, 36, 1, 0, 785, 0, 0, 7306, 7306, 7306, 0, -2, -2);
    if (!JudgeSexual(0)) {
        modifyevent(62, 4, 1, 0, 1417, 0, 0, 7304, 7304, 7304, 0, -2, -2);
        modifyevent(95, 138, 0, 0, 0, 0, 0, 0, 0, 0, 0, -2, -2);
    }
} else {
    modifyevent(62, 4, 1, 0, 1417, 0, 0, 7304, 7304, 7304, 0, -2, -2);
    modifyevent(95, 138, 0, 0, 0, 0, 0, 0, 0, 0, 0, -2, -2);
}
if (GetStarState(51) != 0) {
    SetStarState(51, 1);
    modifyevent(15, 30, 1, 0, 771, 0, 0, 7298, 7298, 7298, 0, -2, -2);
    if (!JudgeSexual(0)) {
        modifyevent(95, 3, 0, 0, 0, 0, 0, 0, 0, 0, 0, -2, -2);
        SetX50(0, GetRole(166, 86 / 2));
        if (GetX50(0) != 0) {
            modifyevent(19, 30, 1, 0, 1411, 0, 0, 7298, 7298, 7298, 0, -2, -2);
            if (!JudgeSexual(0)) {
                modifyevent(95, 147, 1, 0, 1416, 0, 0, 7298, 7298, 7298, 0, -2, -2);
            }
        } else {
            modifyevent(95, 147, 1, 0, 1416, 0, 0, 7298, 7298, 7298, 0, -2, -2);
        }
    }
} else {
    modifyevent(95, 3, 0, 0, 0, 0, 0, 0, 0, 0, 0, -2, -2);
    SetX50(0, GetRole(166, 86 / 2));
    if (GetX50(0) != 0) {
        modifyevent(19, 30, 1, 0, 1411, 0, 0, 7298, 7298, 7298, 0, -2, -2);
        if (!JudgeSexual(0)) {
            modifyevent(95, 147, 1, 0, 1416, 0, 0, 7298, 7298, 7298, 0, -2, -2);
        }
    } else {
        modifyevent(95, 147, 1, 0, 1416, 0, 0, 7298, 7298, 7298, 0, -2, -2);
    }
}
if (GetStarState(60) != 0) {
    SetStarState(60, 1);
    modifyevent(15, 27, 1, 0, 766, 0, 0, 7302, 7302, 7302, 0, -2, -2);
    if (!JudgeSexual(0)) {
        modifyevent(95, 139, 0, 0, 0, 0, 0, 0, 0, 0, 0, -2, -2);
        SetX50(0, GetRole(166, 88 / 2));
        modifyevent(39, 3, 1, 0, 1397, GetX50(0), 0, 7300, 7300, 7300, 0, -2, -2);
    }
} else {
    modifyevent(95, 139, 0, 0, 0, 0, 0, 0, 0, 0, 0, -2, -2);
    SetX50(0, GetRole(166, 88 / 2));
    modifyevent(39, 3, 1, 0, 1397, GetX50(0), 0, 7300, 7300, 7300, 0, -2, -2);
}
exit();
"""


def convert_ka231() -> str:
    return """SetX50(9000, 124);
SetX50(9001, GetX50(28928));
SetX50(9002, GetX50(28929));
SetX50(9003, GetX50(28930) + 1);
SetX50(9003, GetX50(9003) * 100);
do {
    SetX50(9000, GetX50(9000) + 2);
    SetX50(9005, GetRole(GetX50(9001), GetX50(9000) / 2));
    if (GetX50(9005) == 0) {
        SetRole(GetX50(9001), GetX50(9000) / 2, GetX50(9002));
        SetX50(9000, GetX50(9000) + 20);
        SetRole(GetX50(9001), GetX50(9000) / 2, GetX50(9003));
        break;
    }
} while (GetX50(9000) < 144);
"""


def convert_ka232() -> str:
    return """SetX50(9000, 124);
SetX50(9001, GetX50(28928));
SetX50(9002, GetX50(28929));
SetX50(9009, 0);
do {
    SetX50(9000, GetX50(9000) + 2);
    SetX50(9005, GetRole(GetX50(9001), GetX50(9000) / 2));
    if (GetX50(9005) == GetX50(9002)) {
        SetX50(9009, 1);
    }
} while (GetX50(9009) == 0 && GetX50(9000) < 144);
if (GetX50(9009) == 0) {
    exit();
}
do {
    SetX50(9006, GetX50(9000) + 2);
    if (GetX50(9006) != 146) {
        SetX50(9005, GetRole(GetX50(9001), GetX50(9006) / 2));
        SetRole(GetX50(9001), GetX50(9000) / 2, GetX50(9005));
        SetX50(9007, GetX50(9000) + 20);
        SetX50(9008, GetX50(9006) + 20);
        SetX50(9005, GetRole(GetX50(9001), GetX50(9008) / 2));
        SetRole(GetX50(9001), GetX50(9007) / 2, GetX50(9005));
        SetX50(9000, GetX50(9000) + 2);
    }
} while (GetX50(9000) < 144);
SetRole(GetX50(9001), GetX50(9000) / 2, 0);
SetX50(9007, GetX50(9000) + 20);
SetRole(GetX50(9001), GetX50(9007) / 2, 0);
"""


def convert_ka249() -> str:
    return """SetX50(500, 100);
SetX50(501, 120);
SetX50(502, 140);
SetX50(503, 160);
SetX50(504, 180);
SetX50(505, 200);
SetX50(3, 100);
SetX50(5, 10);
SetX50(1, 0);
SetX50(10, "%d");
SetX50(6, 0);
do {
    SetX50(0, GetTeam(GetX50(1)));
    if (GetX50(0) == -1) {
        SetX50(6, 1);
    } else {
        SetX50(2, GetRole(GetX50(0), 19));
        getname(1, 0, 0, GetX50(3), 0, 0);
        string_length_x50(GetX50(3), 4, 0, 0, 0, 0);
        SetX50(4, GetX50(5) - GetX50(4));
        spaces_x50(1, 50, 4, 0, 0, 0, 0);
        concat(60, GetX50(3), 50, 0, 0, 0, 0);
        format50(1, 50, 10, 2, 0, 0, 0);
        concat(60, 60, 50, 0, 0, 0, 0);
        format50(0, GetX50(3), 60, 0, 0, 0, 0);
        SetX50(1, GetX50(1) + 1);
        SetX50(3, GetX50(3) + 20);
    }
} while (GetX50(6) == 0 && GetX50(1) < 6);
SetX50(300, Menu50(GetX50(1), 500, 30, 30, 10));
if (GetX50(300) != 0) {
    SetX50(300, GetX50(300) - 1);
    SetX50(3, GetTeam(GetX50(300)));
    SetX50(2, GetRole(GetX50(3), 19));
    if (GetX50(2) == 0) {
        talk(75, "沒傷還找老子來治，消遣老子不成？", -2, 0, 0, 0);
    } else {
        SetX50(1, GetItemAmount(0));
        if (GetX50(2) > GetX50(1)) {
            talk(75, "雖然我們很熟，但醫療費還是不能少的。", -2, 0, 0, 0);
        } else {
            SetRole(GetX50(3), 19, 0);
            SetX50(0, 0);
            SetX50(2, GetX50(0) - GetX50(2));
            AddItem(0, GetX50(2));
        }
    }
}
"""


def convert_ka211() -> str:
    return """ClearX50();
SetX50(500, 100);
SetX50(501, 1100);
SetX50(100, "儲存物品");
SetX50(1100, "取回物品");
SetX50(10, Menu50(2, 500, 105, 90, 10));
if (GetX50(10) == 1) {
    ClearX50();
    SetX50(1, 50);
    SetX50(50, 1);
    SetX50(33, 1);
    SetX50(13, 0);
    do {
        SetX50(0, 0);
        do {
            SetX50(15, GetX50(13) * 4);
            SetX50(15, GetX50(15) - 468);
            if (GetX50(15) != 0) {
                memoryget(0, 0, GetX50(15), 24, 5, 0);
            } else {
                memoryget(0, 0, GetX50(15), 25, 5, 0);
            }
            SetX50(6, GetItemAmount(GetX50(5)));
            if (GetX50(6) != 0) {
                ka211_build_line(GetX50(0), GetX50(5), GetX50(6));
                SetX50(0, GetX50(0) + 1);
            }
            SetX50(13, GetX50(13) + 1);
        } while (GetX50(13) < GetX50(1));
        if (GetX50(0) == 0) {
            talk("沒有可儲存的物品", 0, 2);
        } else {
            if (GetX50(1) != 200) {
                ka211_add_next_page(GetX50(0));
                SetX50(0, GetX50(0) + 1);
            }
            SetX50(10, ScrollMenu50(GetX50(0), 800, 54, 5, 10));
            if (GetX50(10) > 0) {
                if (GetX50(1) != 200 && GetX50(10) == GetX50(0)) {
                    SetX50(1, GetX50(1) + 50);
                    ka211_clear_page();
                } else {
                    SetX50(10, GetX50(10) - 1);
                    SetX50(11, GetX50(200 + GetX50(10)));
                    SetX50(10032, EnterNumber());
                    if (GetX50(10032) > 0 && GetX50(10032) <= 5000) {
                        SetX50(32, GetItemAmount(GetX50(11)));
                        if (GetX50(32) >= GetX50(10032)) {
                            SetX50(32, GetItem(GetX50(11), 43));
                            SetX50(32, GetX50(32) + GetX50(10032));
                            SetItem(GetX50(11), 43, GetX50(32));
                            ChangeItem(GetX50(11), GetX50(10032), 1, 1);
                            talk("儲存成功。", 0, 2);
                        } else {
                            talk("沒有那麼多物品。", 0, 2);
                        }
                    } else {
                        talk("輸入錯誤。", 0, 2);
                    }
                    SetX50(13, 200);
                }
            } else {
                SetX50(13, 200);
            }
        }
    } while (GetX50(13) < 200);
} else if (GetX50(10) == 2) {
    ClearX50();
    SetX50(0, 50);
    SetX50(50, 1);
    SetX50(33, 1);
    SetX50(1, 344);
    SetX50(5, 0);
    SetX50(16, 0);
    do {
        SetX50(15, 0);
        do {
            SetX50(6, GetItem(GetX50(5), 43));
            if (GetX50(6) > 0) {
                ka211_build_line(GetX50(15), GetX50(5), GetX50(6));
                SetX50(15, GetX50(15) + 1);
            }
            SetX50(5, GetX50(5) + 1);
            SetX50(16, GetX50(16) + 1);
        } while (GetX50(5) < 344 && GetX50(16) < GetX50(0));
        if (GetX50(15) == 0) {
            talk("儲存箱中沒有物品。", 0, 2);
        } else {
            if (GetX50(0) < 344) {
                ka211_add_next_page(GetX50(15));
                SetX50(15, GetX50(15) + 1);
            }
            SetX50(10, ScrollMenu50(GetX50(15), 800, 54, 5, 10));
            if (GetX50(10) > 0) {
                if (GetX50(0) < 344 && GetX50(10) == GetX50(15)) {
                    SetX50(0, GetX50(0) + 50);
                    ka211_clear_page();
                } else {
                    SetX50(10, GetX50(10) - 1);
                    SetX50(11, GetX50(200 + GetX50(10)));
                    SetX50(21, read_mem(1638730));
                    if (GetX50(21) == 0) {
                        SetX50(10032, EnterNumber());
                        if (GetX50(10032) > 0 && GetX50(10032) <= 5000) {
                            SetX50(32, GetItem(GetX50(11), 43));
                            if (GetX50(10032) <= GetX50(32)) {
                                SetX50(32, GetX50(32) - GetX50(10032));
                                SetItem(GetX50(11), 43, GetX50(32));
                                ChangeItem(GetX50(11), GetX50(10032), 0, 0);
                            } else {
                                talk("沒有那麼多物品。", 0, 2);
                            }
                        } else {
                            talk("輸入錯誤。", 0, 2);
                        }
                    } else {
                        talk("身上的物品太多了。", 0, 2);
                    }
                    SetX50(5, 344);
                }
            } else {
                SetX50(5, 344);
            }
        }
    } while (GetX50(5) < 344);
}

ka211_build_line(slot, item, amount) {
    SetX50(2, slot * 30);
    SetX50(2, GetX50(2) + 1000);
    SetX50(800 + slot, GetX50(2));
    getname(0, 1, item, GetX50(2), 0, 0);
    string_length_x50(GetX50(2), 3, 0, 0, 0, 0);
    SetX50(8, 21);
    SetX50(8, GetX50(8) - GetX50(3));
    SetX50(180, MakeSpaces(GetX50(8)));
    SetX50(170, "%d");
    SetX50(6, amount);
    SetX50(165, sprintf(GetX50String(170), GetX50(6)));
    concat(140, GetX50(2), 180, 0, 0, 0);
    concat(GetX50(2), 140, 165, 0, 0, 0);
    SetX50(200 + slot, item);
}

ka211_add_next_page(slot) {
    SetX50(2, slot * 30);
    SetX50(2, GetX50(2) + 1000);
    SetX50(800 + slot, GetX50(2));
    gettalk(0, 717, GetX50(2), 0, 0, 0);
}

ka211_clear_page() {
    SetX50(22, 0);
    do {
        SetX50(800 + GetX50(22), 0);
        SetX50(200 + GetX50(22), 0);
        SetX50(22, GetX50(22) + 1);
    } while (GetX50(22) < 50);
}
"""


def convert_ka215() -> str:
    return """SetX50(22, 0);
SetX50(29, 0);
SetX50(3, GetX50(28928));
SetX50(18, GetX50(28929) * 2);
SetX50(12, GetX50(28931) * 2);
SetX50(17, GetX50(28930));
SetX50(100, 0);
SetX50(7, 165);
SetX50(32, 80);
SetX50(33, 60);
SetX50(8, 30);
SetX50(15, 0);
SetX50(16, 0);
SetX50(50, "快，先進去看看。");
SetX50(60, "爺爺……爺爺……你怎麼不起來了……");
SetX50(70, "你爺爺已經死啦，當然不會起來了！");
SetX50(80, "芙兒，住口！");
SetX50(1, 0);
do {
    SetX50(1050 + GetX50(1), 0);
    SetX50(1100 + GetX50(1), GetX50(18));
    SetX50(1, GetX50(1) + 1);
} while (GetX50(1) < 25);
SetX50(1, 0);
do {
    SetX50(2, (GetX50(1) + GetX50(3)) * 2);
    do {
        SetX50(4, Random50(25));
    } while (GetX50(1050 + GetX50(4)) != 0);
    SetX50(1050 + GetX50(4), GetX50(2));
    SetX50(1000 + GetX50(1), GetX50(2));
    SetX50(1, GetX50(1) + 1);
} while (GetX50(1) < 25);
SetX50(25, GetX50(7) - 117);
SetX50(27, GetX50(25) + 160);
DrawRect(GetX50(25), GetX50(26), 320, 200, 0, ColColor(255), 255);
DrawRect(GetX50(27), GetX50(26), 160, 200, 0, ColColor(255), 255);
DrawRect(GetX50(25), GetX50(26), 160, 200, 0, ColColor(255), 255);
SetX50(6, 0);
do {
    SetX50(9, (GetX50(6) % 5) * 30);
    SetX50(10, GetX50(7) + GetX50(9) - 160);
    SetX50(11, GetX50(8) + (GetX50(6) / 5) * 30);
    DrawPicture(0, GetX50(1000 + GetX50(6)), GetX50(10), GetX50(11));
    SetX50(6, GetX50(6) + 1);
} while (GetX50(6) < 25);
Delay(2000);
SetX50(21500, 1);
do {
    if (GetX50(15) < 0) { SetX50(15, GetX50(15) + 25); }
    if (GetX50(15) >= 25) { SetX50(15, GetX50(15) - 25); }
    SetX50(6, 0);
    SetX50(23, GetX50(17) - GetX50(16));
    do {
        SetX50(9, (GetX50(6) % 5) * 30);
        SetX50(10, GetX50(7) + GetX50(9));
        SetX50(11, GetX50(8) + (GetX50(6) / 5) * 30);
        DrawPicture(0, GetX50(1050 + GetX50(6)), GetX50(10), GetX50(11));
        DrawPicture(0, GetX50(1100 + GetX50(6)), GetX50(10) - 160, GetX50(11));
        SetX50(6, GetX50(6) + 1);
        DrawRect(GetX50(27), GetX50(28), 32, 30, 0, ColColor(255), 102);
        DrawRect(GetX50(25), GetX50(28), 32, 30, 0, ColColor(255), 102);
    } while (GetX50(6) < 25);
    SetX50(53, sprintf(GetX50String(60), GetX50(23)));
    DrawString(3, 50, 7, 24, 1797, 0);
    SetX50(73, sprintf(GetX50String(60), GetX50(29)));
    DrawString(3, 70, 30, 24, 1797, 0);
    SetX50(9, (GetX50(15) % 5) * 30);
    SetX50(13, GetX50(7) + GetX50(9));
    SetX50(14, GetX50(8) + (GetX50(15) / 5) * 30);
    DrawPicture(0, GetX50(12), GetX50(13), GetX50(14));
    if (GetX50(100) == 1) {
        Delay(1000);
        SetX50(21500, 0);
    } else {
        SetX50(0, GetKey());
        if (GetX50(0) == 131) { SetX50(0, GetKey()); }
        if (GetX50(0) == 156) { SetX50(15, GetX50(15) + 1); }
        if (GetX50(0) == 154) { SetX50(15, GetX50(15) - 1); }
        if (GetX50(0) == 152) { SetX50(15, GetX50(15) + 5); }
        if (GetX50(0) == 158) { SetX50(15, GetX50(15) - 5); }
        if (GetX50(0) == 27) {
            SetX50(34, GetX50(32) - 72);
            ShowMessage(3, 80, GetX50(34), 33, 1797, 0);
            if (CheckJumpFlag()) {
                SetX50(25, GetX50(7) - 165);
                SetX50(27, GetX50(25) + 160);
                DrawRect(GetX50(25), GetX50(26), 320, 200, 0, ColColor(255), 255);
                DrawRect(GetX50(27), GetX50(26), 160, 200, 0, ColColor(255), 255);
                DrawRect(GetX50(25), GetX50(26), 160, 200, 0, ColColor(255), 255);
            }
        }
        if (GetX50(0) == 13 || GetX50(0) == 32) {
            CallEvent(536, 0, 0, 0, 0);
        }
        SetX50(25, GetX50(7) - 117);
        SetX50(27, GetX50(25) + 160);
        if (GetX50(16) >= GetX50(17)) {
            Delay(1000);
            SetX50(21500, 0);
        }
    }
} while (GetX50(21500) != 0);
"""


def convert_ka234() -> str:
    return """ClearX50();
SetX50(3000, 206);
SetX50(3001, 207);
SetX50(3002, 208);
SetX50(3010, 209);
SetX50(3011, 210);
SetX50(3100, "%d");
ka234_build_candidates(3000, 3, 3200, 3300, 3400, 3500);
ka234_build_candidates(3010, 2, 3600, 3700, 3800, 3900);
if (GetX50(3500) == 0 || GetX50(3900) == 0) {
    Talk(96, "對不起，原材料不足，請集齊材料再來。", -2, 1, 0, 0);
} else {
    SetX50(3510, 0);
    SetX50(3910, 0);
    if (GetX50(3500) == 1 && GetX50(3900) == 1) {
        Talk(96, "當前只有一種種子和一種水，是否種植？", -2, 1, 0, 0);
        gettalk(0, 266, 2500, 0, 0, 0);
        gettalk(0, 267, 2550, 0, 0, 0);
        SetX50(2600, 2500);
        SetX50(2601, 2550);
        SetX50(3910, Menu50(2, 2600, 181, 215, 10));
        if (GetX50(3910) == 1) {
            SetX50(3510, 1);
        }
    } else {
        SetX50(3510, Menu50(GetX50(3500), 3200, 181, 215, 10));
        if (GetX50(3510) > 0) {
            SetX50(3910, Menu50(GetX50(3900), 3600, 400, 215, 10));
        }
    }
    if (GetX50(3510) > 0 && GetX50(3910) > 0) {
        SetX50(1050, GetX50(3300 + GetX50(3510) - 1));
        SetX50(1051, GetX50(3400 + GetX50(3510) - 1));
        SetX50(1150, GetX50(3700 + GetX50(3910) - 1));
        SetX50(1151, GetX50(3800 + GetX50(3910) - 1));
        AddItem(GetX50(1050), -1);
        AddItem(GetX50(1150), -1);
        SetX50(1060, GetX50(1051) + GetX50(1151));
        SetX50(1070, 213);
        do {
            SetX50(1070, GetX50(1070) + 1);
            SetX50(1071, GetItem(GetX50(1070), 42));
        } while (GetX50(1071) != GetX50(1060) && GetX50(1070) < 219);
        if (GetX50(1071) == GetX50(1060)) {
            AddItem(GetX50(1070), 1);
        } else {
            AddItem(205, 1);
        }
    }
}

ka234_build_candidates(sourceBase, sourceCount, textBase, idBase, amountBase, countBase) {
    SetX50(countBase, 0);
    SetX50(3110, 0);
    do {
        SetX50(3111, GetX50(sourceBase + GetX50(3110)));
        SetX50(3112, GetItemAmount(GetX50(3111)));
        if (GetX50(3112) > 0) {
            SetX50(3113, GetX50(countBase));
            SetX50(3114, 4000 + GetX50(3113) * 100);
            SetX50(3115, GetX50(3114) + 20);
            SetX50(3116, GetX50(3114) + 40);
            getname(1, 1, GetX50(3111), GetX50(3114), 0, 0);
            SetX50(GetX50(3115), sprintf(GetX50String(3100), GetX50(3112)));
            concat(GetX50(3116), GetX50(3114), GetX50(3115), 0, 0, 0);
            SetX50(textBase + GetX50(3113), GetX50(3116));
            SetX50(idBase + GetX50(3113), GetX50(3111));
            SetX50(amountBase + GetX50(3113), GetX50(3112));
            SetX50(countBase, GetX50(countBase) + 1);
        }
        SetX50(3110, GetX50(3110) + 1);
    } while (GetX50(3110) < sourceCount);
}
"""


def convert_ka235() -> str:
    return (convert_ka234()
            .replace("ka234", "ka235")
            .replace("Talk(96", "Talk(65")
            .replace("SetX50(1070, 213);", "SetX50(1070, 222);")
            .replace("GetX50(1070) < 219", "GetX50(1070) < 225"))


def convert_ka248() -> str:
    return (convert_ka234()
            .replace("ka234", "ka248")
            .replace("Talk(96", "Talk(99")
            .replace("SetX50(1070, 213);", "SetX50(1070, 219);")
            .replace("GetX50(1070) < 219", "GetX50(1070) < 222"))


def convert_ka237() -> str:
    output = convert_ka234()
    output = output.replace("ka234", "ka237")
    output = output.replace("SetX50(3000, 206);\nSetX50(3001, 207);\nSetX50(3002, 208);", "SetX50(3000, 214);\nSetX50(3001, 215);\nSetX50(3002, 216);\nSetX50(3003, 217);\nSetX50(3004, 218);\nSetX50(3005, 219);")
    output = output.replace("ka237_build_candidates(3000, 3", "ka237_build_candidates(3000, 6")
    output = output.replace("Talk(96, \"當前只有一種種子和一種水，是否種植？\"", "Talk(87, \"當前只有一種花草和一種水，是否製作？\"")
    output = output.replace("Talk(96, \"對不起，原材料不足，請集齊材料再來。\"", "Talk(87, \"對不起，原材料不足，請集齊材料再來。\"")
    output = output.replace("SetX50(1070, 213);", "SetX50(1070, 2);")
    output = output.replace("GetX50(1070) < 219", "GetX50(1070) < 16")
    output = output.replace("    } else {\n        SetX50(3510, Menu50(GetX50(3500), 3200, 181, 215, 10));", "    } else {\n        DrawRect(176, GetX50(1076), 170, GetX50(1025), 0, ColColor(255), 102);\n        SetX50(3510, Menu50(GetX50(3500), 3200, 181, 215, 10));")
    return output


def convert_ka238() -> str:
    output = convert_ka234()
    output = output.replace("ka234", "ka238")
    output = output.replace("SetX50(3000, 206);\nSetX50(3001, 207);\nSetX50(3002, 208);", "SetX50(3000, 220);\nSetX50(3001, 221);\nSetX50(3002, 222);")
    output = output.replace("Talk(96, \"當前只有一種種子和一種水，是否種植？\"", "Talk(106, \"當前只有一種果實和一種水，是否釀造？\"")
    output = output.replace("Talk(96, \"對不起，原材料不足，請集齊材料再來。\"", "Talk(106, \"對不起，原材料不足，請集齊材料再來。\"")
    output = output.replace("SetX50(1070, 213);", "SetX50(1070, 18);")
    output = output.replace("GetX50(1070) < 219", "GetX50(1070) < 22")
    return output


def convert_ka239() -> str:
    output = convert_ka234()
    output = output.replace("ka234", "ka239")
    output = output.replace("SetX50(3000, 206);\nSetX50(3001, 207);\nSetX50(3002, 208);", "SetX50(3000, 223);\nSetX50(3001, 224);\nSetX50(3002, 225);")
    output = output.replace("Talk(96, \"當前只有一種種子和一種水，是否種植？\"", "Talk(107, \"當前只有一種糧食和一種水，是否製作？\"")
    output = output.replace("Talk(96, \"對不起，原材料不足，請集齊材料再來。\"", "Talk(107, \"對不起，原材料不足，請集齊材料再來。\"")
    output = output.replace("SetX50(1070, 213);", "SetX50(1070, 22);")
    output = output.replace("GetX50(1070) < 219", "GetX50(1070) < 26")
    return output


def convert_ka370() -> str:
    return """DarkScene();
SetX50(100, read_mem(345330));
SetX50(101, read_mem(1911134));
if (GetX50(100) == 0) {
    ka370_set_path(3882, 39, 38, 0);
    SetS(GetX50(101), 2, 34, 40, 3882);
    SetS(GetX50(101), 2, 37, 34, 3850);
    SetS(GetX50(101), 2, 38, 34, 3832);
    SetS(GetX50(101), 2, 39, 34, 3832);
    SetScenePosition2(39, 34);
}
if (GetX50(100) == 1) {
    ka370_set_path(0, 17, 7, 1);
    SetS(GetX50(101), 2, 49, 9, 0);
    SetS(GetX50(101), 2, 39, 11, 0);
    SetS(GetX50(101), 2, 39, 12, 0);
    SetS(GetX50(101), 2, 39, 13, 0);
    SetScenePosition2(41, 13);
}
if (GetX50(100) == 2) {
    ka370_set_path(3882, 17, 7, 1);
    SetS(GetX50(101), 2, 49, 9, 3882);
    SetS(GetX50(101), 2, 39, 11, 3846);
    SetS(GetX50(101), 2, 39, 12, 3848);
    SetS(GetX50(101), 2, 39, 13, 3846);
    SetScenePosition2(39, 13);
}
if (GetX50(100) == 3) {
    ka370_set_path(0, 39, 38, 0);
    SetS(GetX50(101), 2, 34, 40, 0);
    SetS(GetX50(101), 2, 37, 34, 0);
    SetS(GetX50(101), 2, 38, 34, 0);
    SetS(GetX50(101), 2, 39, 34, 0);
    SetScenePosition2(39, 36);
}
LightScene();

ka370_set_path(tile, horizontalA, horizontalB, verticalMode) {
    if (verticalMode == 0) {
        SetX50(102, 35);
        do { SetS(GetX50(101), 2, GetX50(102), 39, tile); SetX50(102, GetX50(102) + 1); } while (GetX50(102) <= 41);
        SetX50(102, 35);
        do { SetS(GetX50(101), 2, GetX50(102), 38, tile); SetX50(102, GetX50(102) + 1); } while (GetX50(102) <= 43);
        SetX50(102, 32);
        do { SetS(GetX50(101), 2, GetX50(102), 35, tile); SetX50(102, GetX50(102) + 1); } while (GetX50(102) <= 44);
        SetX50(102, 36);
        do { SetS(GetX50(101), 2, 44, GetX50(102), tile); SetX50(102, GetX50(102) + 1); } while (GetX50(102) <= 42);
        SetX50(102, 32);
        do { SetS(GetX50(101), 2, GetX50(102), 42, tile); SetX50(102, GetX50(102) + 1); } while (GetX50(102) <= 43);
        SetX50(102, 36);
        do { SetS(GetX50(101), 2, 32, GetX50(102), tile); SetX50(102, GetX50(102) + 1); } while (GetX50(102) <= 41);
    } else {
        SetX50(102, 10);
        do { SetS(GetX50(101), 2, 43, GetX50(102), tile); SetX50(102, GetX50(102) + 1); } while (GetX50(102) <= 16);
        SetX50(102, 8);
        do { SetS(GetX50(101), 2, 40, GetX50(102), tile); SetX50(102, GetX50(102) + 1); } while (GetX50(102) <= 16);
        SetX50(102, 40);
        do { SetS(GetX50(101), 2, GetX50(102), horizontalA, tile); SetX50(102, GetX50(102) + 1); } while (GetX50(102) <= 50);
        SetX50(102, 40);
        do { SetS(GetX50(101), 2, GetX50(102), horizontalB, tile); SetX50(102, GetX50(102) + 1); } while (GetX50(102) <= 51);
        SetX50(102, 8);
        do { SetS(GetX50(101), 2, 51, GetX50(102), tile); SetX50(102, GetX50(102) + 1); } while (GetX50(102) <= 17);
        SetX50(102, 44);
        do {
            SetX50(103, 10);
            do { SetS(GetX50(101), 2, GetX50(102), GetX50(103), tile); SetX50(103, GetX50(103) + 1); } while (GetX50(103) <= 14);
            SetX50(102, GetX50(102) + 1);
        } while (GetX50(102) <= 48);
    }
}
"""


def convert_ka356() -> str:
    return """ClearX50();
SetX50(200, read_mem(1911134));
SetX50(201, read_mem(1911132));
SetX50(202, read_mem(1911130));
SetX50(203, read_mem(345330));
SetX50(205, GetD(GetX50(200), 0, 8));
SetX50(206, GetD(GetX50(200), 0, 7));
if (GetX50(203) == GetX50(205)) {
    SetX50(207, GetX50(203) * 14 + 5014);
    if (GetX50(206) == GetX50(207)) {
        SetX50(206, GetX50(206) - 12);
    }
    SetX50(206, GetX50(206) + 2);
    SetD(GetX50(200), 0, 7, GetX50(206));
    write_mem(1838072, GetX50(206));
} else {
    SetD(GetX50(200), 0, 8, GetX50(203));
    SetX50(207, GetX50(203) * 14 + 5004);
    SetD(GetX50(200), 0, 7, GetX50(207));
    write_mem(1838072, GetX50(207));
}
ModifyEvent(-2, 1, 0, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1);
ModifyEvent(-2, 2, 0, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1);
ModifyEvent(-2, 3, 0, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1);
ModifyEvent(-2, 4, 0, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1);
SetX50(208, 1);
do {
    if (GetX50(208) == 1) { SetX50(209, GetX50(201)); SetX50(210, GetX50(202) - 1); }
    if (GetX50(208) == 2) { SetX50(209, GetX50(201) + 1); SetX50(210, GetX50(202)); }
    if (GetX50(208) == 3) { SetX50(209, GetX50(201) - 1); SetX50(210, GetX50(202)); }
    if (GetX50(208) == 4) { SetX50(209, GetX50(201)); SetX50(210, GetX50(202) + 1); }
    SetX50(211, GetS(GetX50(200), 1, GetX50(209), GetX50(210)));
    if (GetX50(211) == 0) {
        SetX50(212, GetS(GetX50(200), 3, GetX50(209), GetX50(210)));
        if (GetX50(212) == -1) {
            SetS(GetX50(200), 3, GetX50(209), GetX50(210), GetX50(208));
            SetD(GetX50(200), GetX50(208), 2, -1);
            SetD(GetX50(200), GetX50(208), 3, -1);
            SetD(GetX50(200), GetX50(208), 4, 256);
            SetD(GetX50(200), GetX50(208), 9, GetX50(209));
            SetD(GetX50(200), GetX50(208), 10, GetX50(210));
        }
    }
    SetX50(208, GetX50(208) + 1);
} while (GetX50(208) <= 4);
SetX50(212, 3000);
SetX50(209, GetD(GetX50(200), 0, 0));
if (GetX50(209) != 1) {
    SetX50(210, read_mem(1837968));
    SetX50(211, GetX50(210) + GetX50(212));
    SetD(GetX50(200), 0, 4, GetX50(211));
    SetD(GetX50(200), 0, 0, 1);
}
SetX50(210, read_mem(1837968));
SetX50(211, GetD(GetX50(200), 0, 4));
DrawRect(0, 30, 178, 260, 0, ColColor(255), 102);
DrawRect(0, 30, 178, 260, 0, ColColor(255), 102);
DrawRect(0, 30, 178, 260, 0, ColColor(255), 102);
SetX50(213, GetX50(212) / 50);
SetX50(214, (GetX50(211) - GetX50(210)) / GetX50(213) - 1);
SetX50(215, 0);
do {
    SetX50(216, GetX50(215) * 5 + 35);
    if (GetX50(215) <= GetX50(214)) {
        DrawPicture(0, 4612, GetX50(216), 180);
        SetX50(215, GetX50(215) + 1);
    }
} while (GetX50(215) <= GetX50(214) && GetX50(215) < 50);
if (GetX50(210) >= GetX50(211)) {
    PlayAnimation(-1, 5994, 6012);
    DarkScene();
    Dead();
} else {
    SetX50(0, GetKey());
}
"""


def convert_ka216() -> str:
    return """SetX50(21600, 1);
do {
    if (GetX50(22) < 0) { SetX50(22, GetX50(22) + 25); }
    if (GetX50(22) >= 25) { SetX50(22, GetX50(22) - 25); }
    SetX50(1, 0);
    do {
        SetX50(9, (GetX50(1) % 5) * 30);
        SetX50(20, GetX50(7) + GetX50(9) - 160);
        SetX50(21, GetX50(8) + (GetX50(1) / 5) * 30);
        DrawPicture(0, GetX50(1100 + GetX50(1)), GetX50(20), GetX50(21));
        SetX50(1, GetX50(1) + 1);
    } while (GetX50(1) < 25);
    SetX50(9, (GetX50(22) % 5) * 30);
    SetX50(20, GetX50(7) + GetX50(9) - 160);
    SetX50(21, GetX50(8) + (GetX50(22) / 5) * 30);
    DrawPicture(0, GetX50(12), GetX50(20), GetX50(21));
    SetX50(0, GetKey());
    if (GetX50(0) == 131) { SetX50(0, GetKey()); }
    if (GetX50(0) == 156) { SetX50(22, GetX50(22) + 1); }
    if (GetX50(0) == 154) { SetX50(22, GetX50(22) - 1); }
    if (GetX50(0) == 152) { SetX50(22, GetX50(22) + 5); }
    if (GetX50(0) == 158) { SetX50(22, GetX50(22) - 5); }
    if (GetX50(0) == 27) {
        SetX50(21600, 0);
    } else if (GetX50(0) == 13 || GetX50(0) == 32) {
        SetX50(16, GetX50(16) + 1);
        SetX50(19, GetX50(1050 + GetX50(15)));
        SetX50(20, GetX50(1100 + GetX50(22)));
        SetX50(1100 + GetX50(22), GetX50(19));
        SetX50(1050 + GetX50(15), GetX50(20));
        SetX50(29, 0);
        SetX50(1, 0);
        do {
            if (GetX50(1100 + GetX50(1)) == GetX50(1000 + GetX50(1))) {
                SetX50(29, GetX50(29) + 1);
            }
            SetX50(1, GetX50(1) + 1);
        } while (GetX50(1) < 25);
        if (GetX50(29) >= 25) { SetX50(100, 1); }
        SetX50(21600, 0);
    }
} while (GetX50(21600) != 0);
"""


def convert_ka218() -> str:
    return """SetX50(21800, 1);
do {
    if (GetX50(22) < 0) { SetX50(22, GetX50(22) + 25); }
    if (GetX50(22) >= 25) { SetX50(22, GetX50(22) - 25); }
    SetX50(1, 0);
    do {
        SetX50(9, (GetX50(1) % 5) * 30);
        SetX50(20, GetX50(7) + GetX50(9));
        SetX50(21, GetX50(8) + (GetX50(1) / 5) * 30);
        DrawPicture(0, GetX50(1050 + GetX50(1)), GetX50(20), GetX50(21));
        SetX50(1, GetX50(1) + 1);
    } while (GetX50(1) < 25);
    SetX50(9, (GetX50(22) % 5) * 30);
    SetX50(20, GetX50(7) + GetX50(9) - 160);
    SetX50(21, GetX50(8) + (GetX50(22) / 5) * 30);
    DrawPicture(0, GetX50(12), GetX50(20), GetX50(21));
    SetX50(9, (GetX50(15) % 5) * 30);
    SetX50(20, GetX50(7) + GetX50(9) - 160);
    SetX50(21, GetX50(8) + (GetX50(15) / 5) * 30);
    DrawPicture(0, GetX50(12), GetX50(20), GetX50(21));
    SetX50(0, GetKey());
    if (GetX50(0) == 131) { SetX50(0, GetKey()); }
    if (GetX50(0) == 156) { SetX50(22, GetX50(22) + 1); }
    if (GetX50(0) == 154) { SetX50(22, GetX50(22) - 1); }
    if (GetX50(0) == 152) { SetX50(22, GetX50(22) + 5); }
    if (GetX50(0) == 158) { SetX50(22, GetX50(22) - 5); }
    if (GetX50(0) == 27) {
        SetX50(21800, 0);
    } else if (GetX50(0) == 13 || GetX50(0) == 32) {
        SetX50(16, GetX50(16) + 1);
        SetX50(19, GetX50(1050 + GetX50(15)));
        SetX50(20, GetX50(1050 + GetX50(22)));
        SetX50(1050 + GetX50(22), GetX50(19));
        SetX50(1050 + GetX50(15), GetX50(20));
        SetX50(29, 0);
        SetX50(1, 0);
        do {
            if (GetX50(1050 + GetX50(1)) == GetX50(1000 + GetX50(1))) {
                SetX50(29, GetX50(29) + 1);
            }
            SetX50(1, GetX50(1) + 1);
        } while (GetX50(1) < 25);
        if (GetX50(29) >= 24) { SetX50(100, 1); }
        SetX50(21800, 0);
    }
} while (GetX50(21800) != 0);
"""


def convert_ka212() -> str:
    return """ClearX50();
SetX50(1, 50);
SetX50(50, 1);
SetX50(33, 1);
SetX50(13, 0);
do {
    SetX50(0, 0);
    do {
        SetX50(15, GetX50(13) * 4);
        SetX50(15, GetX50(15) - 468);
        if (GetX50(15) != 0) {
            memoryget(0, 0, GetX50(15), 24, 5, 0);
        } else {
            memoryget(0, 0, GetX50(15), 25, 5, 0);
        }
        SetX50(30, GetItem(GetX50(5), 10));
        if (GetX50(30) != 0) {
            SetX50(6, GetItemAmount(GetX50(5)));
            if (GetX50(6) != 0) {
                SetX50(30, GetX50(30) * 10);
                SetX50(30, GetX50(30) / 7);
                ka212_build_line(GetX50(0), GetX50(5), GetX50(30), GetX50(6));
                SetX50(0, GetX50(0) + 1);
            }
        }
        SetX50(13, GetX50(13) + 1);
    } while (GetX50(13) < GetX50(1));
    if (GetX50(0) == 0) {
        talk(90, "沒有可出售的物品。", -2, 0, 0, 0);
    } else {
        if (GetX50(1) != 200) {
            ka212_add_next_page(GetX50(0));
            SetX50(0, GetX50(0) + 1);
        }
        SetX50(10, ScrollMenu50(GetX50(0), 800, 36, 5, 10));
        if (GetX50(10) > 0) {
            if (GetX50(1) != 200 && GetX50(10) == GetX50(0)) {
                SetX50(1, GetX50(1) + 50);
                ka212_clear_page();
            } else {
                SetX50(10, GetX50(10) - 1);
                SetX50(28927, GetX50(200 + GetX50(10)));
                SetX50(10032, EnterNumber());
                SetX50(6, GetItemAmount(GetX50(28927)));
                if (GetX50(10032) > GetX50(6)) {
                    talk(90, "沒有那麼多物品。", -2, 0, 0, 0);
                } else if (GetX50(10032) <= 0 || GetX50(10032) > 1000) {
                    talk(90, "輸入錯誤。", -2, 0, 0, 0);
                } else {
                    SetX50(30, GetItem(GetX50(28927), 10));
                    SetX50(30, GetX50(30) * 10);
                    SetX50(30, GetX50(30) / 7);
                    SetX50(30, GetX50(30) * GetX50(10032));
                    SetX50(31, GetItemAmount(0));
                    SetX50(31, GetX50(31) + GetX50(30));
                    if (GetX50(30) == 0 || GetX50(31) == 0) {
                        talk(90, "身上金錢太多或出售貨品太多。", -2, 0, 0, 0);
                    } else {
                        ChangeItem(GetX50(28927), GetX50(10032), 1, 1);
                        ChangeItem(0, GetX50(30), 0, 0);
                    }
                }
                SetX50(13, 200);
            }
        } else {
            SetX50(13, 200);
        }
    }
} while (GetX50(13) < 200);

ka212_build_line(slot, item, price, amount) {
    SetX50(2, slot * 30);
    SetX50(2, GetX50(2) + 1000);
    SetX50(800 + slot, GetX50(2));
    name = GetItemName(item);
    priceText = sprintf("%d", price);
    amountText = sprintf("%d", amount);
    line = name + MakeSpaces(19 - drawlength(name));
    line = line + "價 " + priceText + MakeSpaces(5 - drawlength(priceText));
    line = line + "量 " + amountText;
    SetX50(GetX50(2), line);
    SetX50(200 + slot, item);
}

ka212_add_next_page(slot) {
    SetX50(2, slot * 30);
    SetX50(2, GetX50(2) + 1000);
    SetX50(800 + slot, GetX50(2));
    SetX50(GetX50(2), "下一頁");
}

ka212_clear_page() {
    SetX50(22, 0);
    do {
        SetX50(800 + GetX50(22), 0);
        SetX50(200 + GetX50(22), 0);
        SetX50(22, GetX50(22) + 1);
    } while (GetX50(22) < 50);
}
"""


def convert_ka487() -> str:
    return """battlefieldget(1, 28005, 0, 1000, 0, 0);
SetX50(1001, read_mem(1994454));
SetX50(1002, GetX50(1001) * 2);
SetX50(1002, GetX50(1002) + 146);
SetX50(1003, GetRole(GetX50(1000), GetX50(1002) / 2));
SetX50(1004, GetX50(1003) / 100);
SetX50(1100, 10);
SetX50(1101, 15);
SetX50(1102, 20);
SetX50(1103, 25);
SetX50(1104, 30);
SetX50(1105, 35);
SetX50(1106, 40);
SetX50(1107, 45);
SetX50(1108, 45);
SetX50(1109, 50);
SetX50(1007, GetX50(1100 + GetX50(1004)));
SetX50(1020, -1);
do {
    SetX50(1020, GetX50(1020) + 1);
    if (GetX50(1020) != GetX50(28005)) {
        battlefieldget(1, 1020, 0, 1030, 0, 0);
        if (GetX50(1030) >= 0) {
            battlefieldget(1, 1020, 10, 1031, 0, 0);
            if (GetX50(1031) <= 0) {
                battlefieldget(1, 1020, 2, 1010, 0, 0);
                if (GetX50(1010) != 1) {
                    SetX50(1005, GetRole(GetX50(1030), 41));
                    SetX50(1011, GetRole(GetX50(1030), 42));
                    SetX50(1009, GetX50(1005) + GetX50(1007));
                    if (GetX50(1009) > GetX50(1011)) {
                        SetX50(1009, GetX50(1011));
                    }
                    battlefieldget(1, 1020, 4, 1040, 0, 0);
                    battlefieldget(1, 1020, 6, 1041, 0, 0);
                    SetAnimationLayer(GetX50(1040), GetX50(1041), 1, 1, 1);
                    SetRole(GetX50(1030), 41, GetX50(1009));
                    SetX50(1008, GetX50(1009) - GetX50(1005));
                    battlefieldset(5, 1020, 18, 1008, 0, 0);
                }
            }
        }
    }
} while (GetX50(1020) < 25);
PlayAction(GetX50(28005), 1, 0);
ShowHurtValue(4);
Redraw();
"""


def convert_ka488() -> str:
    return """battlefieldget(1, 28005, 0, 1000, 0, 0);
SetX50(1001, read_mem(1994454));
SetX50(1002, GetX50(1001) * 2);
SetX50(1002, GetX50(1002) + 146);
SetX50(1003, GetRole(GetX50(1000), GetX50(1002) / 2));
SetX50(1004, GetX50(1003) / 100);
SetX50(1100, 10);
SetX50(1101, 15);
SetX50(1102, 20);
SetX50(1103, 25);
SetX50(1104, 30);
SetX50(1105, 35);
SetX50(1106, 40);
SetX50(1107, 45);
SetX50(1108, 45);
SetX50(1109, 50);
SetX50(1007, GetX50(1100 + GetX50(1004)));
SetX50(1020, -1);
do {
    SetX50(1020, GetX50(1020) + 1);
    battlefieldget(1, 1020, 0, 1030, 0, 0);
    if (GetX50(1030) >= 0) {
        battlefieldget(1, 1020, 10, 1031, 0, 0);
        if (GetX50(1031) <= 0) {
            SetX50(1005, GetRole(GetX50(1030), 41));
            SetX50(1009, GetX50(1005) - GetX50(1007));
            if (GetX50(1009) < 0) {
                SetX50(1009, 0);
            }
            battlefieldget(1, 1020, 4, 1040, 0, 0);
            battlefieldget(1, 1020, 6, 1041, 0, 0);
            SetAnimationLayer(GetX50(1040), GetX50(1041), 1, 1, 1);
            SetRole(GetX50(1030), 41, GetX50(1009));
            SetX50(1008, GetX50(1005) - GetX50(1009));
            battlefieldset(5, 1020, 18, 1008, 0, 0);
        }
    }
} while (GetX50(1020) < 25);
PlayAction(GetX50(28005), 1, 5);
ShowHurtValue(5);
Redraw();
"""


def convert_ka485() -> str:
    return """battlefieldget(1, 28005, 0, 1000, 0, 0);
SetX50(1001, read_mem(1994454));
SetX50(1002, GetX50(1001) * 2);
SetX50(1002, GetX50(1002) + 146);
SetX50(1003, GetRole(GetX50(1000), GetX50(1002) / 2));
SetX50(1004, GetX50(1003) / 100);
SetX50(1100, 10);
SetX50(1101, 15);
SetX50(1102, 20);
SetX50(1103, 25);
SetX50(1104, 30);
SetX50(1105, 35);
SetX50(1106, 40);
SetX50(1107, 45);
SetX50(1108, 45);
SetX50(1109, 50);
SetX50(1007, GetX50(1100 + GetX50(1004)));
SetAnimationLayer(0, 0, 64, 64, 1);
PlayAction(GetX50(28005), 1, 0);
SetX50(1020, -1);
do {
    SetX50(1020, GetX50(1020) + 1);
    battlefieldget(1, 1020, 0, 1030, 0, 0);
    if (GetX50(1030) >= 0) {
        battlefieldget(1, 1020, 2, 1021, 0, 0);
        if (GetX50(1021) != 0) {
            battlefieldget(1, 1020, 4, 1022, 0, 0);
            battlefieldget(1, 1020, 6, 1023, 0, 0);
            SetX50(1024, GetX50(1022) * 2);
            SetX50(1025, GetX50(1023) * 128);
            SetX50(1026, GetX50(1024) + GetX50(1025));
            write_mem(1960452 + GetX50(1026), 0);
        }
        battlefieldget(1, 1020, 10, 1031, 0, 0);
        if (GetX50(1031) >= 0) {
            SetX50(1005, GetRole(GetX50(1030), 17));
            SetX50(1006, GetRole(GetX50(1030), 18));
            SetRole(GetX50(1030), 19, 0);
            if (GetX50(1006) < 300) {
                SetX50(1008, GetX50(1006) * GetX50(1007));
                SetX50(1008, GetX50(1008) / 100);
            } else {
                SetX50(1008, GetX50(1006) / 100);
                SetX50(1008, GetX50(1008) * GetX50(1007));
            }
            SetX50(1009, GetX50(1008) + GetX50(1005));
            if (GetX50(1009) > GetX50(1006)) {
                SetX50(1009, GetX50(1006));
                SetX50(1008, GetX50(1006) - GetX50(1005));
            }
            SetRole(GetX50(1030), 17, GetX50(1009));
            battlefieldset(5, 1020, 18, 1008, 0, 0);
        }
    }
} while (GetX50(1020) < 25);
ShowHurtValue(4);
Redraw();
"""


def convert_ka402() -> str:
    return """SetX50(10, 0);
do {
    battlefieldget(1, 10, 0, 1, 0, 0);
    SetX50(3, GetRole(GetX50(1), 6 / 2));
    if (GetX50(3) == 13) {
        CallEvent(438, GetX50(1), 0, 0, 0);
    }
    SetX50(2, GetRole(GetX50(1), 26 / 2));
    if (GetX50(2) <= 0) {
        SetRole(GetX50(1), 6 / 2, 0);
        SetRole(GetX50(1), 114 / 2, 0);
        SetRole(GetX50(1), 116 / 2, 0);
        SetRole(GetX50(1), 110 / 2, 0);
        SetX50(2, 0);
    }
    SetRole(GetX50(1), 26 / 2, GetX50(2));
    SetX50(10, GetX50(10) + 1);
} while (GetX50(10) < 26);
"""


def convert_ka252() -> str:
    return """SetX50(8000, GetX50(28928));
SetX50(8100, GetX50(28929));
SetX50(7100, 0);
SetX50(6000, 0);
do {
    SetX50(7200, GetX50(7100) * 100);
    SetX50(7200, GetX50(7200) + 2000);
    SetX50(30 + GetX50(7100), GetX50(7200));
    SetX50(7100, GetX50(7100) + 1);
} while (GetX50(7100) != GetX50(8100));
do {
    SetX50(6100, GetX50(6000) * 100);
    SetX50(6100, GetX50(6100) + 2000);
    gettalk(1, 8000, GetX50(6100), 0, 0, 0);
    SetX50(6000, GetX50(6000) + 1);
    SetX50(8000, GetX50(8000) + 1);
} while (GetX50(6000) != GetX50(8100));
SetX50(10, ScrollMenu50(GetX50(8100), 30, 100, 50, 10));
if (GetX50(10) == 0) {
    exit();
}
SetX50(1234, GetX50(10) - 1);
PlayMusic(GetX50(1234));
"""


def convert_ka222() -> str:
    return """CallEvent(221, 0, 0, 0, 0);
SetX50(100, read_mem(1911654));
SetX50(0, 0);
SetX50(1, 0);
do {
    SetX50(101, GetX50(200 + GetX50(0)));
    if (GetX50(101) != GetX50(100)) {
        SetX50(102, GetD(GetX50(101), 199, 2));
        if (GetX50(102) != 1) {
            SetX50(500 + GetX50(1), GetX50(101));
            SetX50(103, GetX50(300 + GetX50(0)));
            SetX50(600 + GetX50(1), GetX50(103));
            SetX50(104, GetX50(400 + GetX50(0)));
            SetX50(700 + GetX50(1), GetX50(104));
            SetX50(105, GetX50(1) * 20);
            SetX50(105, GetX50(105) + 1000);
            getname(1, 2, 101, GetX50(105), 0, 0);
            SetX50(800 + GetX50(1), GetX50(105));
            SetX50(1, GetX50(1) + 1);
        }
    }
    SetX50(0, GetX50(0) + 1);
} while (GetX50(0) < 9);
if (GetX50(1) < 1) {
    exit();
}
SetX50(10, ScrollMenu50(GetX50(1), 800, 10, 50, 5));
if (GetX50(10) <= 0) {
    exit();
}
SetX50(10, GetX50(10) - 1);
SetX50(101, GetX50(500 + GetX50(10)));
SetX50(103, GetX50(600 + GetX50(10)));
SetX50(104, GetX50(700 + GetX50(10)));
CallEvent(220, GetX50(101), GetX50(103), GetX50(104), 0);
"""


def convert_ka351() -> str:
    return """SetX50(10000, readtalkasstring(GetX50(28928)));
SetX50(9001, GetX50(28929) - 1);
SetX50(9000, -1);
SetX50(9002, GetX50(28928));
SetX50(9003, 10000);
while (GetX50(9000) < GetX50(9001)) {
    SetX50(9000, GetX50(9000) + 1);
    SetX50(9002, GetX50(9002) + 1);
    SetX50(9003, GetX50(9003) + 100);
    SetX50(15000 + GetX50(9000), GetX50(9003));
    gettalk(1, 9002, GetX50(9003), 0, 0, 0);
}
SetX50(9999, drawlength(GetX50String(10000)));
SetX50(9999, GetX50(9999) * 10);
SetX50(9999, GetX50(9999) + 10);
DrawRect(12, 15, GetX50(9999), 30, 0, ColColor(255), 102);
DrawString(0, 10000, 19, 22, 1797, 0);
SetX50(9006, GetKey());
Delay(100);
SetX50(28931, ScrollMenu50(GetX50(28929), 15000, 12, 50, 8));
"""


def convert_ka353() -> str:
    return """SetX50(9000, 5);
Talk(382, "客官您要住店嗎？本店明碼實價，童叟無欺，住宿每人紋銀5兩。", -2, 1, 0, 0);
if (!AskRest()) {
    exit();
}
SetX50(1, 0);
do {
    SetX50(1, GetX50(1) + 1);
    if (GetX50(1) > 5) {
        break;
    }
    SetX50(2, GetTeam(GetX50(1)));
} while (GetX50(2) > 0);
SetX50(9001, GetX50(1) * GetX50(9000));
if (!JudgeMoney(GetX50(9001))) {
    Talk(382, "這位客官，好像您的銀子不夠呀……", -2, 1, 0, 0);
    exit();
}
Talk(382, "好咧，客官裡面請。", -2, 1, 0, 0);
ChangeItem(174, GetX50(9001), 0, 1);
DarkScene();
Rest();
LightScene();
"""


def convert_synthesis_common() -> str:
    return """listA_id = {};
listA_name = {};
listA_amount = {};
listA_display = {};
listB_id = {};
listB_name = {};
listB_amount = {};
listB_display = {};

for (i = 0; i < size(list1); i = i + 1) {
    id = list1[i];
    listA_id[i] = id;
    listA_name[i] = GetNameAsString(1, id);
    listA_amount[i] = haveitemamount(id);
    listA_display[i] = sprintf("%-10s%6d", listA_name[i], listA_amount[i]);
}

for (i = 0; i < size(list2); i = i + 1) {
    id = list2[i];
    listB_id[i] = id;
    listB_name[i] = GetNameAsString(1, id);
    listB_amount[i] = haveitemamount(id);
    listB_display[i] = sprintf("%-10s%6d", listB_name[i], listB_amount[i]);
}

Talk(personID, personSay, -2, 1, 0, 0);

showstringwithbox(160, 180, "請選擇" + itemA);
selectA = menu(size(list1), 160, 210, 100, listA_display);
if (selectA == -1) { exit(); }
if (listA_amount[selectA] <= 0) {
    Talk(personID, "不要開玩笑！", -2, 1, 0, 0);
    exit();
}

showstringwithbox(390, 180, "請選擇" + itemB);
selectB = menu(size(list2), 390, 210, 100, listB_display);
if (selectB == -1) { exit(); }
if (listB_amount[selectB] <= 0) {
    Talk(personID, "不要開另一個玩笑！", -2, 1, 0, 0);
    exit();
}

idA = listA_id[selectA];
idB = listB_id[selectB];
idC_key = to_string(idA) + "+" + to_string(idB);
if (!list3.contains(idC_key)) {
    Talk(personID, "合成失敗！", -2, 1, 0, 0);
    exit();
}
idC = list3[idC_key];
AddItemWithoutHint(idA, -1);
AddItemWithoutHint(idB, -1);
if (getitempro(idC, 41) == 4) {
    AddItem(idC, 100);
}
else {
    AddItem(idC, 1);
}
"""


def convert_synthesis_config(text: str) -> str:
    lines: list[str] = []
    for raw_line in text.splitlines():
        line = raw_line.strip()
        if not line or line.startswith("--"):
            continue
        if line.startswith("list3"):
            break
        lines.append(convert_statement(raw_line.rstrip()))

    for left, right, value in re.findall(r"string\.format\('%d\+%d',\s*(\d+)\s*,\s*(\d+)\)\]\s*=\s*(\d+)", text):
        lines.append(f'list3["{left}+{right}"] = {value};')
    lines.append("execevent(241);")
    lines.append("exit();")
    return "\n".join(line for line in lines if line.strip()).rstrip() + "\n"


def normalize_else_if_chain(output: str) -> str:
    output = output.replace("\n    }\n    else if", "\n}\nelse if")
    output = output.replace("\n        }\n        else if", "\n}\nelse if")
    output = output.replace("\n        else {", "\nelse {")
    output = output.replace("\n        }\n    }\n}\ngetitem", "\n}\ngetitem")
    return output


def split_comment(line: str) -> tuple[str, str]:
    quote = ""
    i = 0
    while i < len(line) - 1:
        char = line[i]
        if quote:
            if char == "\\":
                i += 2
                continue
            if char == quote:
                quote = ""
        elif char in "'\"":
            quote = char
        elif line[i : i + 2] == "--":
            return line[:i], "//" + line[i + 2 :]
        i += 1
    return line, ""


def is_exit_only_lua(text: str) -> bool:
    statements = [
        code.strip().rstrip(";")
        for line in text.splitlines()
        if (code := split_comment(line)[0]).strip()
    ]
    return statements == ["exit()"]


def strip_cifa_comments(text: str) -> str:
    lines: list[str] = []
    for line in text.splitlines():
        quote = ""
        index = 0
        while index < len(line) - 1:
            char = line[index]
            if quote:
                if char == "\\":
                    index += 2
                    continue
                if char == quote:
                    quote = ""
            elif char in "'\"":
                quote = char
            elif line[index : index + 2] == "//":
                line = line[:index]
                break
            index += 1
        if line.strip():
            lines.append(line.rstrip())
    return "\n".join(lines) + "\n"


def strip_terminal_exit(text: str) -> str:
    lines = text.splitlines()
    while lines and not lines[-1].strip():
        lines.pop()
    while lines and lines[-1].strip() == "exit();":
        lines.pop()
    return "\n".join(lines).rstrip() + "\n"


def format_cifa_indentation(text: str) -> str:
    """Normalize generated Cifa indentation without inspecting string contents."""
    output: list[str] = []
    depth = 0
    for raw_line in text.splitlines():
        stripped = raw_line.strip()
        if not stripped:
            continue
        protected, _strings = replace_strings(stripped)
        leading_closes = len(protected) - len(protected.lstrip("}"))
        line_depth = max(depth - leading_closes, 0)
        output.append("    " * line_depth + stripped)
        depth = max(depth + protected.count("{") - protected.count("}"), 0)
    return "\n".join(output) + "\n"


def replace_strings(text: str) -> tuple[str, list[str]]:
    strings: list[str] = []
    out: list[str] = []
    i = 0
    while i < len(text):
        if text[i] not in "'\"":
            out.append(text[i])
            i += 1
            continue
        quote = text[i]
        token = [quote]
        i += 1
        while i < len(text):
            token.append(text[i])
            if text[i] == "\\" and i + 1 < len(text):
                i += 1
                token.append(text[i])
            elif text[i] == quote:
                i += 1
                break
            i += 1
        placeholder = f"__STR{len(strings)}__"
        strings.append("".join(token))
        out.append(placeholder)
    return "".join(out), strings


def restore_strings(text: str, strings: list[str]) -> str:
    for i, value in enumerate(strings):
        if value.startswith("'"):
            value = '"' + value[1:-1].replace('"', '\\"') + '"'
        text = text.replace(f"__STR{i}__", value)
    return text


def normalize_expr(expr: str) -> str:
    protected, strings = replace_strings(expr)
    protected = re.sub(r"\btrue\b", "1", protected)
    protected = re.sub(r"\bfalse\b", "0", protected)
    protected = re.sub(r"\bnil\b", "0", protected)
    protected = protected.replace("..", "+")
    protected = re.sub(r"\bmath\.randomseed\s*\(", "randomseed(", protected)
    protected = re.sub(r"\bmath\.random\s*\(", "random(", protected)
    protected = re.sub(r"\bos\.time\s*\(", "time(", protected)
    protected = re.sub(r"\bstring\.format\s*\(", "sprintf(", protected)
    protected = protected.replace("~=", "!=")
    protected = re.sub(r"\band\b", "&&", protected)
    protected = re.sub(r"\bor\b", "||", protected)
    protected = re.sub(r"\bnot\b", "!", protected)
    protected = re.sub(r"\b([A-Z][A-Za-z0-9_]*)\s*\(", lambda m: m.group(1) + "(", protected)
    protected = re.sub(r"\b([a-zA-Z_][A-Za-z0-9_]*)\s*\{", r"\1 {", protected)
    call = r"(?P<call>(?P<name>[A-Za-z_][A-Za-z0-9_]*)\s*\([^()]*\))"

    def simplify_bool_call(match: re.Match[str], negate: bool) -> str:
        if match.group("name") not in BOOLEAN_CALL_NAMES:
            return match.group(0)
        return f"!{match.group('call')}" if negate else match.group("call")

    protected = re.sub(rf"\b{call}\s*(?:==\s*1|!=\s*0)\b", lambda m: simplify_bool_call(m, False), protected)
    protected = re.sub(rf"\b{call}\s*(?:==\s*0|!=\s*1)\b", lambda m: simplify_bool_call(m, True), protected)
    protected = re.sub(rf"\b(?:1\s*==|0\s*!=)\s*{call}\b", lambda m: simplify_bool_call(m, False), protected)
    protected = re.sub(rf"\b(?:0\s*==|1\s*!=)\s*{call}\b", lambda m: simplify_bool_call(m, True), protected)
    restored = restore_strings(protected, strings)
    restored = re.sub(r'("(?:[^"\\]|\\.)*")\s*\+\s*([A-Za-z_][A-Za-z0-9_]*)\b', r'\1 + to_string(\2)', restored)
    return restored


def normalize_call_name(stripped: str) -> str:
    match = re.match(r"([A-Za-z_][A-Za-z0-9_]*)\s*\(", stripped)
    if not match:
        return stripped
    if match.group(1) == "getitem":
        args_match = re.fullmatch(r"getitem\s*\(\s*(.+?)\s*,\s*(-\d+)\s*\)", stripped)
        alias = "AddItemWithoutHint" if args_match else "AddItem"
        return alias + stripped[match.end(1):]
    alias = CALL_NAME_ALIASES.get(match.group(1))
    if alias is None:
        return stripped
    return alias + stripped[match.end(1):]


def parse_instruct_50(stripped: str) -> tuple[int, list[int]] | None:
    match = re.fullmatch(r"instruct_50\s*\(\s*(\d+)\s*,\s*(.*)\)", stripped, re.IGNORECASE)
    if not match:
        return None
    try:
        values = [int(value.strip()) for value in match.group(2).split(",")]
    except ValueError:
        return None
    return (int(match.group(1)), values) if len(values) == 6 else None


def parse_instruct_50_arguments(stripped: str) -> tuple[int, list[str]] | None:
    protected, strings = replace_strings(stripped)
    match = re.fullmatch(r"instruct_50\s*\(\s*(\d+)\s*,\s*(.*)\)", protected, re.IGNORECASE)
    if not match:
        return None
    values = [restore_strings(value.strip(), strings) for value in match.group(2).split(",")]
    return (int(match.group(1)), values) if len(values) == 6 else None


def inject_call_argument(line: str, argument_index: int, replacement: str) -> str | None:
    protected, strings = replace_strings(line)
    match = re.search(r"[A-Za-z_][A-Za-z0-9_]*\s*\(", protected)
    if match is None:
        return None
    open_paren = protected.find("(", match.start())
    depth = 1
    close_paren = open_paren + 1
    while close_paren < len(protected) and depth:
        if protected[close_paren] == "(":
            depth += 1
        elif protected[close_paren] == ")":
            depth -= 1
        close_paren += 1
    if depth:
        return None

    arguments = protected[open_paren + 1 : close_paren - 1].split(",")
    if argument_index < 1 or argument_index > len(arguments):
        return None
    arguments[argument_index - 1] = f" {replacement}"
    updated = protected[: open_paren + 1] + ",".join(arguments) + protected[close_paren - 1 :]
    return restore_strings(updated, strings)


def inline_legacy_next_instruction(text: str) -> str:
    lines = text.splitlines()
    output: list[str] = []
    index = 0
    while index < len(lines):
        code, _comment = split_comment(lines[index])
        parsed = parse_instruct_50(code.strip().rstrip(";"))
        if parsed is not None and parsed[0] == 32:
            flags, slot, argument_index, _e4, _e5, _e6 = parsed[1]
            next_index = index + 1
            while next_index < len(lines):
                next_code, _next_comment = split_comment(lines[next_index])
                if next_code.strip():
                    break
                next_index += 1
            if flags == 0 and next_index < len(lines):
                next_code, next_comment = split_comment(lines[next_index])
                next_is_instruct_50 = re.match(r"\s*instruct_50\s*\(", next_code, re.IGNORECASE) is not None
                # For instruct_50, position 1 addresses the opcode itself. The
                # converted alias has no opcode argument, so only positions 2-7
                # can be represented as alias arguments.
                if next_is_instruct_50 and argument_index == 1:
                    injected = None
                else:
                    injected = inject_call_argument(next_code, argument_index, f"GetX50({slot})")
                if injected is not None:
                    output.extend(lines[index + 1 : next_index])
                    output.append(injected.rstrip() + (" " + next_comment.strip() if next_comment else ""))
                    index = next_index + 1
                    continue
        output.append(lines[index])
        index += 1
    return "\n".join(output)


def cifa_value(flags: int, bit: int, raw: int) -> str:
    return f"GetX50({raw})" if flags & (1 << bit) else str(raw)


def jump_flag_condition(e1: int, e2: int, e3: int, e4: int) -> str | None:
    comparisons = ("<", "<=", "==", "!=", ">=", ">")
    if e2 in range(6):
        right = cifa_value(e1, 0, e4)
        return f"GetX50({e3}) {comparisons[e2]} {right}"
    if e2 == 6:
        return "true"
    if e2 == 7:
        return "false"
    return None


def negate_jump_flag_condition(condition: str) -> str:
    inverses = (("!=", "=="), (">=", "<"), ("<=", ">"), ("==", "!="), (">", "<="), ("<", ">="))
    for old, new in inverses:
        if old in condition:
            return condition.replace(old, new, 1)
    if condition == "true":
        return "false"
    if condition == "false":
        return "true"
    return f"!({condition})"


def simplify_jump_flag_pairs(text: str) -> str:
    lines = text.splitlines()
    output: list[str] = []
    index = 0
    pattern = re.compile(r"(\s*)if\s+CheckJumpFlag\s*\(\s*\)\s*==\s*(true|false)\s+then(.*)$", re.IGNORECASE)
    while index < len(lines):
        code, _comment = split_comment(lines[index])
        parsed = parse_instruct_50(code.strip().rstrip(";"))
        if parsed is not None and parsed[0] == 4 and index + 1 < len(lines):
            next_code, _next_comment = split_comment(lines[index + 1])
            match = pattern.fullmatch(next_code)
            if match:
                e1, e2, e3, e4, _e5, _e6 = parsed[1]
                condition = jump_flag_condition(e1, e2, e3, e4)
                if condition is not None:
                    if match.group(2).lower() == "false":
                        condition = negate_jump_flag_condition(condition)
                    output.append(f"{match.group(1)}if {condition} then{match.group(3)}")
                    index += 2
                    continue
        output.append(lines[index])
        index += 1
    return "\n".join(output)


def simplify_star_state_pairs(text: str) -> str:
    lines = text.splitlines()
    output: list[str] = []
    index = 0
    branch = re.compile(r"(\s*)if\s+CheckJumpFlag\s*\(\s*\)\s*==\s*(true|false)\s+then(.*)$", re.IGNORECASE)
    comparisons = ("<", "<=", "==", "!=", ">=", ">")
    while index < len(lines):
        code, _comment = split_comment(lines[index])
        load = parse_instruct_50(code.strip().rstrip(";"))
        if load is not None and load[0] == 43 and index + 2 < len(lines):
            load_flags, target, position, zero1, zero2, zero3 = load[1]
            compare_code, _compare_comment = split_comment(lines[index + 1])
            compare = parse_instruct_50(compare_code.strip().rstrip(";"))
            branch_code, _branch_comment = split_comment(lines[index + 2])
            match = branch.fullmatch(branch_code)
            if target == 208 and not load_flags & 1 and zero1 == zero2 == zero3 == 0 and compare is not None and compare[0] == 4 and match:
                compare_flags, comparison, left, right, _zero4, _zero5 = compare[1]
                condition = None
                if left == 28929 and comparison in range(6):
                    condition = f"GetStarState({position}) {comparisons[comparison]} {cifa_value(compare_flags, 0, right)}"
                elif left == 28929 and comparison == 6:
                    condition = "true"
                elif left == 28929 and comparison == 7:
                    condition = "false"
                if condition is not None:
                    if match.group(2).lower() == "false":
                        condition = negate_jump_flag_condition(condition)
                    output.append(f"{match.group(1)}if {condition} then{match.group(3)}")
                    index += 3
                    continue
        output.append(lines[index])
        index += 1
    return "\n".join(output)


def convert_instruct_50(stripped: str) -> str | None:
    parsed = parse_instruct_50(stripped)
    if parsed is None:
        dynamic = parse_instruct_50_arguments(stripped)
        if dynamic is not None:
            code, values = dynamic
            alias = INSTRUCT_50_ALIASES.get(code)
            if alias is not None:
                return f"{alias}({', '.join(values)})"
        return None
    code, values = parsed
    e1, e2, e3, e4, e5, e6 = values

    def value(bit: int, raw: int) -> str:
        return cifa_value(e1, bit, raw)

    if code == 0:
        return f"SetX50({e1}, {e2})"
    if code == 1 and e2 != 1:
        return f"SetX50({e3} + {value(0, e4)}, {value(1, e5)})"
    if code == 2 and e2 != 1:
        return f"SetX50({e5}, GetX50({e3} + {value(0, e4)}))"
    if code == 3 and e2 in range(3):
        return f"SetX50({e3}, GetX50({e4}) {'+-*'[e2]} {value(0, e5)})"
    if code == 3 and e2 == 3:
        return f"SetX50({e3}, GetX50({e4}) / {value(0, e5)})"
    if code == 3 and e2 == 4:
        return f"SetX50({e3}, GetX50({e4}) % {value(0, e5)})"
    if code == 3 and e2 == 5:
        return f"SetX50({e3}, (GetX50({e4}) & 65535) / {value(0, e5)})"
    if code == 4:
        condition = jump_flag_condition(e1, e2, e3, e4)
        if condition is not None:
            return f"SetJumpFlag({condition})"
    if code == 5:
        return "ClearX50()"
    if code in (6, 7):
        return ""
    if code == 8:
        if (e1 & 1) == 0:
            return f"SetX50({e3}, {talk_literal(e2)})"
        return f"SetX50({e3}, readtalkasstring({value(0, e2)}))"
    if code == 9:
        return f"SetX50({e2}, sprintf(GetX50String({e3}), {value(0, e4)}))"
    if code == 10:
        return f"SetX50({e2}, drawlength(GetX50String({e1})))"
    if code == 11:
        return f"SetX50({e3}, GetX50String({e1}) + GetX50String({e2}))"
    if code == 12:
        return f"SetX50({e2}, MakeSpaces({value(0, e3)}))"
    if code == 16 and e2 in RECORD_ACCESSORS:
        return f"{RECORD_ACCESSORS[e2][1]}({value(0, e3)}, {value(1, e4)} / 2, {value(2, e5)})"
    if code == 17 and e2 in RECORD_ACCESSORS:
        return f"SetX50({e5}, {RECORD_ACCESSORS[e2][0]}({value(0, e3)}, {value(1, e4)} / 2))"
    if code == 18:
        return f"SetTeam({value(0, e2)}, {value(1, e3)})"
    if code == 19:
        return f"SetX50({e3}, GetTeam({value(0, e2)}))"
    if code == 20:
        return f"SetX50({e3}, GetItemAmount({value(0, e2)}))"
    if code == 21:
        return f"SetD({value(0, e2)}, {value(1, e3)}, {value(2, e4)}, {value(3, e5)})"
    if code == 22:
        return f"SetX50({e5}, GetD({value(0, e2)}, {value(1, e3)}, {value(2, e4)}))"
    if code == 23:
        return f"SetS({value(0, e2)}, {value(1, e3)}, {value(2, e4)}, {value(3, e5)}, {value(4, e6)})"
    if code == 24:
        return f"SetX50({e6}, GetS({value(0, e2)}, {value(1, e3)}, {value(2, e4)}, {value(3, e5)}))"
    if code == 25:
        address = (e3 & 0xFFFF) + (e4 & 0xFFFF) * 0x10000
        offset = value(1, e6)
        stored = value(0, e5)
        if address == 0x1D295A and offset == "0":
            return f"setscenex({stored}); UpdateAllScreen()"
        if address == 0x1D295C and offset == "0":
            return f"setsceney({stored}); UpdateAllScreen()"
        if address == 0x1D295E and offset == "0":
            return f"setspecialcurrentscene({stored}); UpdateAllScreen()"
        if address == 0x18FE2C:
            return f"setitemlistfield({offset}, {stored}); UpdateAllScreen()"
        if address == 0x051C83:
            return f"setpaletteword({offset}, {stored}); UpdateAllScreen()"
        return "UpdateAllScreen()"
    if code == 26:
        address = (e3 & 0xFFFF) + (e4 & 0xFFFF) * 0x10000
        offset = value(0, e6)
        fixed_reads = {
            0x1D295E: "getcurrentscene()",
            0x1D295A: "getscenex()",
            0x1D295C: "getsceney()",
            0x1C0B88: "getmapx()",
            0x1C0B8C: "getmapy()",
            0x0544F2: "getsceneface()",
            0x1E6ED6: "getbattleactor()",
            0x0556DA: "getbattlecursorx()",
            0x0556DC: "getbattlecursory()",
            0x1C0B90: "getbattletick()",
        }
        if address in fixed_reads and offset == "0":
            return f"SetX50({e5}, {fixed_reads[address]})"
        if address == 0x05B53A and offset == "0":
            return f"SetX50({e5}, 1)"
        if address == 0x18FE2C:
            return f"SetX50({e5}, getitemlistfield({offset}))"
        if address == 0x1E4A04:
            return f"SetX50({e5}, getbattlefieldcell({offset}))"
        # The original instruction leaves x50[e5] unchanged for unknown
        # addresses. Returning no statement is the exact Cifa equivalent.
        return ""
    if code == 27:
        names = ("GetRoleName", "GetItemName", "GetSubmapName", "GetMagicName")
        if e2 in range(len(names)):
            return f"SetX50({e4}, {names[e2]}({value(0, e3)}))"
    if code == 34:
        if e1 & 16:
            return f"drawrect50({e1}, {e2}, {e3}, {e4}, {e5}, {e6})"
        alpha = max(e6 * 255 // 100, 102)
        return f"DrawRect({value(0, e2)}, {value(1, e3)}, {value(2, e4)}, {value(3, e5)}, 0, ColColor(255), {alpha})"
    if code == 35:
        return f"SetX50({e1}, GetKey())"
    if code == 37:
        return f"Delay({value(0, e2)})"
    if code == 38:
        return f"SetX50({e3}, Random50({value(0, e2)}))"
    if code in (39, 40):
        return f"SetX50({e4}, {'ScrollMenu50' if code == 40 else 'Menu50'}({value(0, e2)}, {e3}, {value(1, e5)}, {value(2, e6)}, {(e1 >> 8) & 0xFF if code == 40 else 10}))"
    if code == 41 and e2 in (0, 1):
        picture_type = "0" if e2 == 0 else "1"
        return f"DrawPicture({picture_type}, {value(2, e5)}, {value(0, e3)}, {value(1, e4)})"
    if code == 42:
        return f"SetMainMapPosition({value(0, e2)}, {value(1, e3)})"
    if code == 43:
        if not e1 & 1:
            special = {
                201: f"ShowSpecialTalk({value(1, e3)}, {value(2, e4)}, {value(3, e5)}, {value(4, e6)})",
                202: "SetScreenBlendMode(0)",
                203: "SetScreenBlendMode(1)",
                204: "SetScreenBlendMode(2)",
                205: f"SetX50(126, Digging({value(1, e3)}, {value(2, e4)}, {value(3, e5)}, {value(4, e6)}))",
                207: "ShowStarList()",
                208: f"SetX50(28929, GetStarState({value(1, e3)}))",
                209: f"SetStarState({value(1, e3)}, {value(2, e4)})",
                210: "ShowTeammateList()",
                213: f"ChangeItem({value(1, e3)}, {value(2, e4)}, {value(3, e5)}, {value(4, e6)})",
                214: "SetX50(10032, EnterNumber())",
                217: f"SetJumpFlag(SpellPicture({value(1, e3)}, {value(2, e4)}))",
                219: "ReArrangeItem(1)",
                223: "ShowMap()",
                228: f"ShowTeammate({value(1, e3)}, {value(2, e4)}, {value(3, e5)})",
                236: f"SetJumpFlag(Lamp({value(1, e3)}, {value(2, e4)}, {value(3, e5)}, 0))",
                242: f"RoleEnding({value(1, e3)}, {value(2, e4)}, {value(3, e5)})",
                243: f"MissionList({value(1, e3)})",
                244: f"SetMissionState({value(1, e3)}, {value(2, e4)})",
                246: f"SetJumpFlag(WoodMan({value(1, e3)}))",
                247: f"SetShowMainRole({value(1, e3)} != 1)",
                253: "BookList()",
                254: f"SetX50({value(1, e3)}, GetStarAmount())",
                255: f"SetX50({value(1, e3)}, DancerAfter90S())",
                352: f"ShowTitle({value(1, e3)}, 1)",
                365: f"NewShop({value(1, e3)})",
                369: f"SetX50(15205, EnterNumber(0, {value(1, e3)}, {value(3, e5)}, {value(4, e6)}))",
            }.get(e2)
            if special is not None:
                return special
        return f"CallEvent({value(0, e2)}, {value(1, e3)}, {value(2, e4)}, {value(3, e5)}, {value(4, e6)})"
    if code == 44:
        actor = value(0, e2)
        if not e1 & 1 and e2 > 100:
            actor = f"GetX50({e2})"
        return f"PlayAction({actor}, {value(1, e3)}, {value(2, e4)})"
    if code == 45:
        return f"ShowHurtValue({value(0, e2)})"
    if code == 46:
        return f"SetAnimationLayer({value(0, e2)}, {value(1, e3)}, {value(2, e4)}, {value(3, e5)}, {value(4, e6)})"
    if code == 47:
        return "Redraw()"
    if code == 51:
        return f"SetX50({e1}, EnterNumber())"
    if code == 52:
        return f"SetJumpFlag(HaveMagic({value(0, e2)}, {value(1, e3)}, {value(2, e4)}))"
    if code == 53:
        return f"AddRoleAttribute({value(0, e2)}, {value(1, e3)}, {value(2, e4)})"
    if code == 54:
        return f"SetWalkPicture({value(0, e2)}, {value(0, e3)})"
    if code == 55:
        return f"PlayMovie({value(0, e2)} + '.wmv')"
    if code == 60:
        return f"CallScript({value(0, e2)}, {value(1, e3)})"

    alias = INSTRUCT_50_ALIASES.get(code)
    return f"{alias}({e1}, {e2}, {e3}, {e4}, {e5}, {e6})" if alias else None


def convert_statement(line: str) -> str:
    code, comment = split_comment(line)
    indent = re.match(r"\s*", code).group(0)
    stripped = code.strip()
    if not stripped:
        return indent + comment.strip()

    lower = stripped.lower()
    if lower == "else":
        return indent + "}" + (" " + comment.strip() if comment else "") + "\n" + indent + "else {"
    if lower in { "end", "end;" }:
        return indent + "}" + (" " + comment.strip() if comment else "")
    if lower == "else end":
        return indent + "}\n" + indent + "else { }" + (" " + comment.strip() if comment else "")
    if GOTO_LABEL_PATTERN.fullmatch(stripped):
        return ""
    if re.fullmatch(r"do\s+return\s*;?\s*end\s*;?", stripped, re.IGNORECASE):
        return indent + "return;" + (" " + comment.strip() if comment else "")

    match = re.match(r"else\s+if\s+(.+)\s+then$", stripped, re.IGNORECASE)
    if match:
        return indent + "else if (" + normalize_expr(match.group(1)) + ") {" + (" " + comment.strip() if comment else "")

    match = re.match(r"function\s+([A-Za-z_][A-Za-z0-9_]*)\s*\((.*)\)$", stripped, re.IGNORECASE)
    if match:
        name, args = match.groups()
        return indent + f"{name}({args}) {{" + (" " + comment.strip() if comment else "")

    match = re.match(r"if\s+(.+)\s+then$", stripped, re.IGNORECASE)
    if match:
        return indent + "if (" + normalize_expr(match.group(1)) + ") {" + (" " + comment.strip() if comment else "")

    match = re.match(r"while\s+(.+)\s+do$", stripped, re.IGNORECASE)
    if match:
        return indent + "while (" + normalize_expr(match.group(1)) + ") {" + (" " + comment.strip() if comment else "")

    match = re.match(r"for\s+([A-Za-z_][A-Za-z0-9_]*)\s*=\s*(.+?)\s*,\s*(.+?)\s+do$", stripped, re.IGNORECASE)
    if match:
        name, start, end = match.groups()
        return indent + f"for ({name} = {normalize_expr(start)}; {name} <= {normalize_expr(end)}; {name} = {name} + 1) {{" + (" " + comment.strip() if comment else "")

    if stripped.endswith(";"):
        stripped = stripped[:-1]
    stripped = normalize_call_name(stripped)
    instruct_50_alias = convert_instruct_50(stripped)
    if instruct_50_alias is not None:
        if not instruct_50_alias:
            return ""
        statements = [statement.strip() for statement in instruct_50_alias.split(";") if statement.strip()]
        converted = "\n".join(indent + statement + ";" for statement in statements)
        return converted + (" " + comment.strip() if comment else "")
    match = re.match(r"([A-Za-z_][A-Za-z0-9_]*)\s*,\s*([A-Za-z_][A-Za-z0-9_]*)\s*=\s*(.+)$", stripped)
    if match:
        name1, name2, expr = match.groups()
        temp_name = f"__{name1}_{name2}_values"
        converted_expr = normalize_expr(expr)
        return indent + f"{temp_name} = {converted_expr};\n" + indent + f"{name1} = {temp_name}[0];\n" + indent + f"{name2} = {temp_name}[1];" + (" " + comment.strip() if comment else "")
    converted = normalize_expr(stripped)
    converted = re.sub(r"^([A-Z][A-Za-z0-9_]*)\s*\(", lambda m: m.group(1) + "(", converted)
    return indent + converted + ";" + (" " + comment.strip() if comment else "")


def has_goto(text: str) -> bool:
    return re.search(r"\bgoto\b", text) is not None


GOTO_LABEL_PATTERN = re.compile(r"^\s*::([A-Za-z_][A-Za-z0-9_]*)::\s*;?\s*$")
CONDITIONAL_GOTO_PATTERN = re.compile(
    r"^\s*if\s+(.+?)\s+then\s+goto\s+([A-Za-z_][A-Za-z0-9_]*)\s+end\s*;?\s*$",
    re.IGNORECASE,
)


def merge_adjacent_labels(lines: list[str]) -> list[str]:
    aliases: dict[str, str] = {}
    output: list[str] = []
    index = 0
    while index < len(lines):
        code, comment = split_comment(lines[index])
        first = GOTO_LABEL_PATTERN.match(code)
        if first is None or comment:
            output.append(lines[index])
            index += 1
            continue

        canonical = first.group(1)
        output.append(lines[index])
        index += 1
        while index < len(lines):
            next_code, next_comment = split_comment(lines[index])
            adjacent = GOTO_LABEL_PATTERN.match(next_code)
            if adjacent is None or next_comment:
                break
            aliases[adjacent.group(1)] = canonical
            index += 1

    if not aliases:
        return output

    result: list[str] = []
    for line in output:
        code, comment = split_comment(line)
        jump = CONDITIONAL_GOTO_PATTERN.match(code)
        if jump is None or jump.group(2) not in aliases:
            result.append(line)
            continue
        target = aliases[jump.group(2)]
        converted = re.sub(r"(\bgoto\s+)[A-Za-z_][A-Za-z0-9_]*(\s+end\b)", rf"\g<1>{target}\g<2>", code, count=1, flags=re.IGNORECASE)
        result.append(converted + comment)
    return result


def lua_nesting_depths(lines: list[str]) -> list[int]:
    depths: list[int] = []
    depth = 0
    for line in lines:
        code, _comment = split_comment(line)
        stripped = code.strip().rstrip(";")
        depths.append(depth)
        if re.match(r"(?:if\s+.+\s+then|while\s+.+\s+do|for\s+.+\s+do|function\s+.+)$", stripped, re.IGNORECASE):
            depth += 1
        elif stripped == "end":
            depth -= 1
    return depths


def merge_adjacent_same_target_gotos(lines: list[str]) -> list[str]:
    """Combine consecutive conditional gotos that take the same branch."""
    output: list[str] = []
    index = 0
    while index < len(lines):
        code, comment = split_comment(lines[index])
        first = CONDITIONAL_GOTO_PATTERN.match(code)
        if first is None:
            output.append(lines[index])
            index += 1
            continue

        condition, target = first.groups()
        conditions = [condition]
        end = index + 1
        while end < len(lines):
            next_code, next_comment = split_comment(lines[end])
            next_jump = CONDITIONAL_GOTO_PATTERN.match(next_code)
            if next_jump is None or next_comment or next_jump.group(2) != target:
                break
            conditions.append(next_jump.group(1))
            end += 1

        if len(conditions) == 1:
            output.append(lines[index])
        else:
            indent = re.match(r"\s*", code).group(0)
            suffix = f" {comment.strip()}" if comment else ""
            output.append(f"{indent}if ({' or '.join(conditions)}) then goto {target} end;{suffix}")
        index = end
    return output


def convert_restricted_goto_lua_text(text: str) -> str:
    """Translate Lua labels when every jump stays in its current block or exits it."""
    source_lines = text.splitlines()
    labels: dict[str, tuple[int, tuple[int, ...]]] = {}
    jumps: list[tuple[int, str, str, tuple[int, ...]]] = []
    block_stack: list[int] = []
    next_block = 0

    for index, line in enumerate(source_lines):
        code, _comment = split_comment(line)
        stripped = code.strip().rstrip(";")
        if stripped == "end":
            if not block_stack:
                raise ConvertError("unmatched Lua end")
            block_stack.pop()

        label_match = GOTO_LABEL_PATTERN.match(code)
        jump_match = CONDITIONAL_GOTO_PATTERN.match(code)
        if "goto" in code and not jump_match:
            raise ConvertError("unsupported goto syntax")
        if label_match:
            label = label_match.group(1)
            if label in labels:
                raise ConvertError(f"duplicate goto label: {label}")
            labels[label] = (index, tuple(block_stack))
        elif jump_match:
            condition, target = jump_match.groups()
            jumps.append((index, condition, target, tuple(block_stack)))

        if re.match(r"(?:if\s+.+\s+then|while\s+.+\s+do|for\s+.+\s+do|function\s+.+)$", stripped, re.IGNORECASE):
            next_block += 1
            block_stack.append(next_block)

    if block_stack:
        raise ConvertError("unterminated Lua block")
    if not jumps:
        raise ConvertError("unexpected no-goto event")

    for _index, _condition, target, source_blocks in jumps:
        target_info = labels.get(target)
        if target_info is None:
            raise ConvertError(f"unknown goto label: {target}")
        _target_index, target_blocks = target_info
        if len(target_blocks) > len(source_blocks) or source_blocks[: len(target_blocks)] != target_blocks:
            raise ConvertError(f"goto '{target}' jumps into a nested or sibling block")

    unsupported = find_unsupported("\n".join(
        line for line in source_lines
        if not GOTO_LABEL_PATTERN.match(split_comment(line)[0])
        and not CONDITIONAL_GOTO_PATTERN.match(split_comment(line)[0])
    ))
    if unsupported:
        raise ConvertError(unsupported)

    output: list[str] = []
    for line in source_lines:
        code, comment = split_comment(line)
        indent = re.match(r"\s*", code).group(0)
        label_match = GOTO_LABEL_PATTERN.match(code)
        jump_match = CONDITIONAL_GOTO_PATTERN.match(code)
        if label_match:
            suffix = f" {comment.strip()}" if comment else ""
            output.append(f"{indent}{label_match.group(1)}:{suffix}")
        elif jump_match:
            condition, target = jump_match.groups()
            suffix = f" {comment.strip()}" if comment else ""
            output.append(f"{indent}if ({normalize_expr(condition)}) {{ goto {target}; }}{suffix}")
        else:
            statement = convert_statement(line.rstrip())
            if statement.strip():
                output.extend(statement.splitlines())
    return "\n".join(output).rstrip() + "\n"


def convert_goto_lua_text(text: str, event_id: str) -> str:
    """Lower simple conditional Lua goto flows to readable Cifa control flow."""
    source_lines = text.splitlines()

    def try_convert_game0_linear_terminal_chain() -> str | None:
        """Prefer nested game0 branches for a linear forward terminal chain.

        Historical game0 Cifa keeps a successful outer action such as
        ``UseItem`` or ``AskJoin`` as an enclosing positive ``if``. Lua encodes
        the same flow as a forward jump over a terminal ``exit()`` block. This
        handles only unique, forward label targets, so it cannot collapse a
        shared continuation or duplicate an effect block.
        """
        if not event_id.startswith("game0-"):
            return None

        depths = lua_nesting_depths(source_lines)
        labels: dict[str, int] = {}
        jumps: dict[int, re.Match[str]] = {}
        target_uses: dict[str, int] = {}
        for index, (line, depth) in enumerate(zip(source_lines, depths)):
            code, _comment = split_comment(line)
            label_match = GOTO_LABEL_PATTERN.match(code)
            jump_match = CONDITIONAL_GOTO_PATTERN.match(code)
            if label_match:
                if depth != 0 or label_match.group(1) in labels:
                    return None
                labels[label_match.group(1)] = index
            elif jump_match:
                if depth != 0:
                    return None
                jumps[index] = jump_match
                target = jump_match.group(2)
                target_uses[target] = target_uses.get(target, 0) + 1

        if not jumps or set(labels) != set(target_uses) or any(uses != 1 for uses in target_uses.values()):
            return None
        if any(index >= labels[match.group(2)] for index, match in jumps.items()):
            return None

        def convert_region(lines: list[str]) -> list[str] | None:
            output: list[str] = []
            for line in lines:
                code, _comment = split_comment(line)
                if CONDITIONAL_GOTO_PATTERN.match(code) or GOTO_LABEL_PATTERN.match(code):
                    return None
                statement = convert_statement(line.lstrip().rstrip())
                if statement.strip():
                    output.extend(statement.splitlines())
            return output

        def append_indented(output: list[str], lines: list[str], indent: str) -> None:
            output.extend(indent + line for line in lines)

        def negate_condition(condition: str) -> str:
            condition = condition.strip()
            if re.fullmatch(r".+?\s*==\s*true", condition, re.IGNORECASE):
                return re.sub(r"\s*==\s*true\s*$", " == false", condition, flags=re.IGNORECASE)
            if re.fullmatch(r".+?\s*==\s*false", condition, re.IGNORECASE):
                return re.sub(r"\s*==\s*false\s*$", " == true", condition, flags=re.IGNORECASE)
            for old, new in (("!=", "=="), (">=", "<"), ("<=", ">"), ("==", "!="), (">", "<="), ("<", ">=")):
                if old in condition:
                    return condition.replace(old, new, 1)
            return f"not ({condition})"

        def lower(start: int, end: int) -> list[str] | None:
            output: list[str] = []
            position = start
            while position < end:
                if GOTO_LABEL_PATTERN.match(split_comment(source_lines[position])[0]):
                    return None
                jump = jumps.get(position)
                if jump is None:
                    statement = convert_region([source_lines[position]])
                    if statement is None:
                        return None
                    output.extend(statement)
                    position += 1
                    continue

                target = labels[jump.group(2)]
                if not position < target < end:
                    return None
                skipped = convert_region(source_lines[position + 1 : target])
                continuation = lower(target + 1, end)
                if skipped is None or continuation is None:
                    return None

                terminal = skipped[-1:] == ["exit();"]
                if terminal:
                    skipped = skipped[:-1]
                    output.append(f"if ({normalize_expr(jump.group(1))}) {{")
                    append_indented(output, continuation, "    ")
                    if skipped:
                        output.append("} else {")
                        append_indented(output, skipped, "    ")
                    output.append("}")
                    return output

                output.append(f"if ({negate_condition(jump.group(1))}) {{")
                append_indented(output, skipped, "    ")
                output.append("}")
                output.extend(continuation)
                return output

            if output[-1:] == ["exit();"]:
                output.pop()
            return output

        output = lower(0, len(source_lines))
        return "\n".join(output) + "\n" if output is not None else None

    game0_linear_chain = try_convert_game0_linear_terminal_chain()
    if game0_linear_chain is not None:
        return game0_linear_chain

    def try_convert_game0_terminal_branches() -> str | None:
        """Prefer the original game0's complete if/else branches over early exits.

        This recognizes an outer forward jump around a terminal fallback, followed
        by a main body whose final conditional jump selects between two terminal
        branches. It is intentionally limited to this linear shape so a shared
        continuation can never be duplicated or skipped.
        """
        if not event_id.startswith("game0-"):
            return None

        def convert_region(lines: list[str]) -> list[str]:
            output: list[str] = []
            depths = lua_nesting_depths(lines)
            for line, depth in zip(lines, depths):
                code, _comment = split_comment(line)
                if code.strip().rstrip(";") == "end":
                    depth -= 1
                statement = convert_statement("    " * max(depth, 0) + line.lstrip().rstrip())
                if statement.strip():
                    output.extend(statement.splitlines())
            return output

        labels: dict[str, int] = {}
        jumps: list[tuple[int, re.Match[str]]] = []
        depths = lua_nesting_depths(source_lines)
        for index, (line, depth) in enumerate(zip(source_lines, depths)):
            code, _comment = split_comment(line)
            label_match = GOTO_LABEL_PATTERN.match(code)
            jump_match = CONDITIONAL_GOTO_PATTERN.match(code)
            if label_match:
                if depth != 0 or label_match.group(1) in labels:
                    return None
                labels[label_match.group(1)] = index
            elif jump_match:
                if depth != 0:
                    return None
                jumps.append((index, jump_match))

        if len(jumps) != 2 or len(labels) != 2:
            return None

        outer_index, outer_jump = jumps[0]
        inner_index, inner_jump = jumps[1]
        main_label_index = labels.get(outer_jump.group(2))
        fallback_label_index = labels.get(inner_jump.group(2))
        if main_label_index is None or fallback_label_index is None:
            return None
        if not outer_index < main_label_index <= inner_index < fallback_label_index:
            return None

        outer_fallback = source_lines[outer_index + 1 : main_label_index]
        main_prefix = source_lines[main_label_index + 1 : inner_index]
        main_success = source_lines[inner_index + 1 : fallback_label_index]
        main_failure = source_lines[fallback_label_index + 1 :]
        regions = [outer_fallback, main_prefix, main_success, main_failure]
        if any(not region for region in regions):
            return None
        if any(
            CONDITIONAL_GOTO_PATTERN.match(split_comment(line)[0])
            or GOTO_LABEL_PATTERN.match(split_comment(line)[0])
            for region in regions
            for line in region
        ):
            return None

        def convert_terminal_region(region: list[str]) -> list[str] | None:
            converted = convert_region(region)
            if converted[-1:] != ["exit();"]:
                return None
            return converted[:-1]

        converted_fallback = convert_terminal_region(outer_fallback)
        converted_success = convert_terminal_region(main_success)
        converted_failure = convert_terminal_region(main_failure)
        if any(region is None for region in (converted_fallback, converted_success, converted_failure)):
            return None
        assert converted_fallback is not None
        assert converted_success is not None
        assert converted_failure is not None

        output = convert_region(source_lines[:outer_index])
        output.append(f"if ({normalize_expr(outer_jump.group(1))}) {{")
        output.extend("    " + line for line in convert_region(main_prefix))
        output.append(f"    if ({normalize_expr(inner_jump.group(1))}) {{")
        output.extend("        " + line for line in converted_failure)
        output.append("    } else {")
        output.extend("        " + line for line in converted_success)
        output.append("    }")
        if converted_fallback:
            output.append("} else {")
            output.extend("    " + line for line in converted_fallback)
            output.append("}")
        else:
            output.append("}")
        return "\n".join(output) + "\n"

    game0_terminal_branches = try_convert_game0_terminal_branches()
    if game0_terminal_branches is not None:
        return game0_terminal_branches

    def negate_lua_condition(condition: str) -> str:
        condition = condition.strip()
        if re.fullmatch(r".+?\s*==\s*true", condition, re.IGNORECASE):
            return re.sub(r"\s*==\s*true\s*$", " == false", condition, flags=re.IGNORECASE)
        if re.fullmatch(r".+?\s*==\s*false", condition, re.IGNORECASE):
            return re.sub(r"\s*==\s*false\s*$", " == true", condition, flags=re.IGNORECASE)
        for old, new in (("!=", "=="), (">=", "<"), ("<=", ">"), ("==", "!="), (">", "<="), ("<", ">=")):
            if old in condition:
                return condition.replace(old, new, 1)
        return f"not ({condition})"

    def rewrite_local_skip_gotos() -> None:
        """Turn a unique label after a plain skipped region into a Lua if block."""
        while True:
            labels: dict[str, int] = {}
            uses: dict[str, int] = {}
            for index, line in enumerate(source_lines):
                code, _comment = split_comment(line)
                label_match = GOTO_LABEL_PATTERN.match(code)
                jump_match = CONDITIONAL_GOTO_PATTERN.match(code)
                if label_match:
                    labels[label_match.group(1)] = index
                elif jump_match:
                    target = jump_match.group(2)
                    uses[target] = uses.get(target, 0) + 1

            # Leave a complete chain of adjacent target labels intact for the
            # dedicated short-circuit/shared-tail lowerings below. Rewriting
            # its first jump here would turn a single boolean guard into a
            # staircase of nested Lua if blocks.
            target_positions = sorted(labels[target] for target in uses if target in labels)
            if (
                target_positions
                and set(uses) == set(labels)
                and target_positions == list(range(target_positions[0], target_positions[0] + len(target_positions)))
            ):
                return

            rewritten = False
            for index, line in enumerate(source_lines):
                code, comment = split_comment(line)
                jump_match = CONDITIONAL_GOTO_PATTERN.match(code)
                if jump_match is None:
                    continue
                condition, target = jump_match.groups()
                target_index = labels.get(target)
                if target_index is None or target_index <= index or uses.get(target) != 1:
                    continue
                skipped = source_lines[index + 1 : target_index]
                if not skipped or any(
                    CONDITIONAL_GOTO_PATTERN.match(split_comment(item)[0])
                    or GOTO_LABEL_PATTERN.match(split_comment(item)[0])
                    for item in skipped
                ):
                    continue
                indent = re.match(r"\s*", code).group(0)
                suffix = f" {comment.strip()}" if comment else ""
                source_lines[index] = f"{indent}if {negate_lua_condition(condition)} then{suffix}"
                source_lines[target_index] = indent + "end"
                rewritten = True
                break
            if not rewritten:
                return

    rewrite_local_skip_gotos()

    # A conditional jump whose target label is the next statement has identical
    # true and false successors. Preserve evaluation of its condition as an
    # expression statement, because calls such as TryBattle have side effects.
    while True:
        labels_by_name: dict[str, int] = {}
        target_uses: dict[str, int] = {}
        for index, line in enumerate(source_lines):
            code, _comment = split_comment(line)
            label_match = GOTO_LABEL_PATTERN.match(code)
            jump_match = CONDITIONAL_GOTO_PATTERN.match(code)
            if label_match:
                labels_by_name[label_match.group(1)] = index
            elif jump_match:
                target = jump_match.group(2)
                target_uses[target] = target_uses.get(target, 0) + 1

        identity_jump = None
        for index, line in enumerate(source_lines):
            code, _comment = split_comment(line)
            jump_match = CONDITIONAL_GOTO_PATTERN.match(code)
            if jump_match is None:
                continue
            target = jump_match.group(2)
            label_index = labels_by_name.get(target)
            if label_index == index + 1 and target_uses.get(target) == 1:
                identity_jump = (index, label_index)
                break
        if identity_jump is None:
            break
        jump_index, label_index = identity_jump
        jump_code, jump_comment = split_comment(source_lines[jump_index])
        jump_match = CONDITIONAL_GOTO_PATTERN.match(jump_code)
        assert jump_match is not None
        indent = re.match(r"\s*", jump_code).group(0)
        suffix = f" {jump_comment.strip()}" if jump_comment else ""
        condition = jump_match.group(1).strip()
        call_match = re.fullmatch(r"([A-Za-z_][A-Za-z0-9_]*)\s*\((.*)\)\s*==\s*true", condition, re.IGNORECASE)
        side_effect_source = f"{call_match.group(1)}({call_match.group(2)})" if call_match else condition
        side_effect = convert_statement(indent + side_effect_source).rstrip()
        source_lines[jump_index] = f"{side_effect}{suffix}"
        del source_lines[label_index]
        following = [line for line in source_lines[label_index:] if line.strip()]
        label_indent = min((len(line) - len(line.lstrip()) for line in following), default=0)
        if label_indent:
            for index in range(label_index, len(source_lines)):
                if source_lines[index].startswith(" " * label_indent):
                    source_lines[index] = source_lines[index][label_indent:]

    referenced_labels = {
        match.group(2)
        for line in source_lines
        if (match := CONDITIONAL_GOTO_PATTERN.match(split_comment(line)[0]))
    }
    source_lines = [
        line
        for line in source_lines
        if (label_match := GOTO_LABEL_PATTERN.match(split_comment(line)[0])) is None
        or label_match.group(1) in referenced_labels
    ]

    depths = lua_nesting_depths(source_lines)
    labels: dict[str, int] = {}
    jumps: list[tuple[int, re.Match[str]]] = []
    for index, (line, depth) in enumerate(zip(source_lines, depths)):
        code, _comment = split_comment(line)
        label_match = GOTO_LABEL_PATTERN.match(code)
        goto_match = CONDITIONAL_GOTO_PATTERN.match(code)
        if "goto" in code and not goto_match:
            raise ConvertError("unsupported goto syntax")
        if label_match:
            if depth != 0:
                raise ConvertError("goto label is inside a Lua block")
            label = label_match.group(1)
            if label in labels:
                raise ConvertError(f"duplicate goto label: {label}")
            labels[label] = index
            continue
        if goto_match:
            if depth != 0:
                raise ConvertError("goto is inside a Lua block")
            jumps.append((index, goto_match))

    def convert_lines(lines: list[str]) -> list[str]:
        output: list[str] = []
        depths = lua_nesting_depths(lines)
        for line, depth in zip(lines, depths):
            code, _comment = split_comment(line)
            stripped = code.strip().rstrip(";")
            if stripped == "end":
                depth -= 1
            normalized_line = "    " * max(depth, 0) + line.lstrip()
            statement = convert_statement(normalized_line.rstrip())
            if statement.strip():
                output.extend(statement.splitlines())
        return output

    if not jumps:
        unsupported = find_unsupported("\n".join(source_lines))
        if unsupported:
            raise ConvertError(unsupported)
        return "\n".join(convert_lines(source_lines)) + "\n"

    def negate_condition(condition: str) -> str:
        if condition.startswith("!"):
            return condition[1:]
        for old, new in (("!=", "=="), (">=", "<"), ("<=", ">"), ("==", "!="), (">", "<="), ("<", ">=")):
            if old in condition:
                return condition.replace(old, new, 1)
        if re.fullmatch(r"[A-Za-z_][A-Za-z0-9_]*\s*\([^()]*\)", condition):
            return f"!{condition}"
        return f"!({condition})"

    def try_convert_nested_forward_gotos() -> str | None:
        """Lower non-shared forward labels to nested guard clauses.

        A label can be removed when exactly one preceding conditional jump
        reaches it. The skipped interval becomes the false branch, followed by
        the code after the label. Shared joins and jumps crossing an enclosing
        interval require the continuation graph instead.
        """
        if not labels or any(index >= labels[match.group(2)] for index, match in jumps):
            return None

        target_uses: dict[str, int] = {}
        for _index, match in jumps:
            target = match.group(2)
            target_uses[target] = target_uses.get(target, 0) + 1
        if set(target_uses) != set(labels) or any(uses != 1 for uses in target_uses.values()):
            return None

        jump_at = {index: match for index, match in jumps}

        def lower_region(start: int, end: int) -> list[str] | None:
            output: list[str] = []
            position = start
            while position < end:
                code, _comment = split_comment(source_lines[position])
                if GOTO_LABEL_PATTERN.match(code):
                    return None

                jump = jump_at.get(position)
                if jump is None:
                    output.extend(convert_lines([source_lines[position]]))
                    position += 1
                    continue

                target_index = labels[jump.group(2)]
                if not position < target_index < end:
                    return None
                nested = lower_region(position + 1, target_index)
                if nested is None:
                    return None
                output.append(f"if ({negate_condition(normalize_expr(jump.group(1)))}) {{")
                output.extend("    " + line for line in nested)
                output.append("}")
                position = target_index + 1
            return output

        output = lower_region(0, len(source_lines))
        return "\n".join(output) + "\n" if output is not None else None

    def try_convert_nested_shared_tail_gotos() -> str | None:
        """Lower nested guards whose final adjacent labels share one tail.

        The final label run represents one fall-through continuation. Earlier
        labels must still have exactly one incoming jump, so this only accepts
        a nested optional-body chain and never a general shared CFG.
        """
        if not labels or any(index >= labels[match.group(2)] for index, match in jumps):
            return None

        final_label_start = max(labels.values())
        while final_label_start - 1 in labels.values():
            final_label_start -= 1
        tail_labels = {label for label, index in labels.items() if index >= final_label_start}
        if len(tail_labels) < 2:
            return None

        canonical_tail = min(tail_labels, key=labels.__getitem__)
        target_uses: dict[str, int] = {}
        for _index, match in jumps:
            target = canonical_tail if match.group(2) in tail_labels else match.group(2)
            target_uses[target] = target_uses.get(target, 0) + 1
        expected_targets = (set(labels) - tail_labels) | {canonical_tail}
        if set(target_uses) != expected_targets:
            return None
        if any(uses != 1 for label, uses in target_uses.items() if label != canonical_tail):
            return None
        if target_uses[canonical_tail] < 2:
            return None

        depths = lua_nesting_depths(source_lines)
        if any(depths[index] != 0 for index, _match in jumps) or any(depths[index] != 0 for index in labels.values()):
            return None

        jump_at = {index: match for index, match in jumps}

        def target_index(match: re.Match[str]) -> int:
            target = canonical_tail if match.group(2) in tail_labels else match.group(2)
            return labels[target]

        def lower_region(start: int, end: int) -> list[str] | None:
            output: list[str] = []
            position = start
            while position < end:
                code, _comment = split_comment(source_lines[position])
                if GOTO_LABEL_PATTERN.match(code):
                    if position in {labels[label] for label in tail_labels}:
                        position += 1
                        continue
                    return None

                jump = jump_at.get(position)
                if jump is None:
                    output.extend(convert_lines([source_lines[position]]))
                    position += 1
                    continue

                destination = target_index(jump)
                if not position < destination <= end:
                    return None
                nested = lower_region(position + 1, destination)
                if nested is None:
                    return None
                output.append(f"if ({negate_condition(normalize_expr(jump.group(1)))}) {{")
                output.extend("    " + line for line in nested)
                output.append("}")
                position = destination + 1
            return output

        output = lower_region(0, len(source_lines))
        return "\n".join(output) + "\n" if output is not None else None

    def try_convert_two_way_shared_join() -> str | None:
        """Lower a two-way branch with a conditional fall-through join.

        ``goto left; right; goto join; left: fallback; join: tail`` is a
        conventional ``if/else`` when the second jump has already normalized
        to the proven-true constant ``1``. Requiring that constant prevents
        this rule from duplicating a fallback body or changing a dynamic
        condition's evaluation order.
        """
        if len(jumps) != 2 or len(labels) != 2:
            return None
        if any(index >= labels[match.group(2)] for index, match in jumps):
            return None

        depths = lua_nesting_depths(source_lines)
        if any(depths[index] != 0 for index, _match in jumps) or any(
            depths[index] != 0 for index in labels.values()
        ):
            return None

        first_jump_index, first_jump = jumps[0]
        second_jump_index, second_jump = jumps[1]
        first_label_index = labels[first_jump.group(2)]
        join_label_index = labels[second_jump.group(2)]
        if not first_jump_index < second_jump_index < first_label_index < join_label_index:
            return None
        if normalize_expr(second_jump.group(1)) != "1":
            return None

        # Each label is the sole target of the corresponding jump. This rules
        # out alternative entries, cross edges, and general shared CFGs.
        if {first_jump.group(2), second_jump.group(2)} != set(labels):
            return None

        right_body = source_lines[first_jump_index + 1 : second_jump_index]
        fallback_body = source_lines[first_label_index + 1 : join_label_index]
        if not right_body or not fallback_body:
            return None
        if any(
            CONDITIONAL_GOTO_PATTERN.match(split_comment(line)[0])
            or GOTO_LABEL_PATTERN.match(split_comment(line)[0])
            for line in [*right_body, *fallback_body]
        ):
            return None

        output = convert_lines(source_lines[:first_jump_index])
        output.append(f"if ({negate_condition(normalize_expr(first_jump.group(1)))}) {{")
        output.extend("    " + line for line in convert_lines(right_body))
        output.append("} else {")
        output.extend("    " + line for line in convert_lines(fallback_body))
        output.append("}")
        output.extend(convert_lines(source_lines[join_label_index + 1 :]))
        return "\n".join(output) + "\n"

    def try_convert_optional_terminal_diversion() -> str | None:
        """Lower an optional prefix that can divert to a terminal branch.

        This recognizes ``goto common; optional; goto alternate; common:
        terminal; alternate: terminal``. The common terminal body stays in
        one place, while the optional prefix retains its original condition
        and the alternate branch remains exclusive.
        """
        if len(jumps) != 2 or len(labels) != 2:
            return None
        if any(index >= labels[match.group(2)] for index, match in jumps):
            return None

        depths = lua_nesting_depths(source_lines)
        if any(depths[index] != 0 for index, _match in jumps) or any(
            depths[index] != 0 for index in labels.values()
        ):
            return None

        first_jump_index, first_jump = jumps[0]
        second_jump_index, second_jump = jumps[1]
        common_label_index = labels[first_jump.group(2)]
        alternate_label_index = labels[second_jump.group(2)]
        if not first_jump_index < second_jump_index < common_label_index < alternate_label_index:
            return None
        if {first_jump.group(2), second_jump.group(2)} != set(labels):
            return None

        optional_body = source_lines[first_jump_index + 1 : second_jump_index]
        common_body = source_lines[common_label_index + 1 : alternate_label_index]
        alternate_body = source_lines[alternate_label_index + 1 :]
        if not optional_body or not common_body or not alternate_body:
            return None
        if any(
            CONDITIONAL_GOTO_PATTERN.match(split_comment(line)[0])
            or GOTO_LABEL_PATTERN.match(split_comment(line)[0])
            for line in [*optional_body, *common_body, *alternate_body]
        ):
            return None
        common_output = convert_lines(common_body)
        alternate_output = convert_lines(alternate_body)
        if common_output[-1:] != ["exit();"] or alternate_output[-1:] != ["exit();"]:
            return None

        output = convert_lines(source_lines[:first_jump_index])
        output.append(f"if ({negate_condition(normalize_expr(first_jump.group(1)))}) {{")
        output.extend("    " + line for line in convert_lines(optional_body))
        output.append(f"    if ({normalize_expr(second_jump.group(1))}) {{")
        output.extend("        " + line for line in alternate_output)
        output.append("    }")
        output.append("}")
        output.extend(common_output)
        return "\n".join(output) + "\n"

    def try_convert_guarded_common_tail() -> str | None:
        """Lower a guarded region that may exit before one common tail.

        ``goto tail; guarded; goto exit; tail: effects; exit: exit`` becomes
        a nested guard followed by the single shared effect tail. The terminal
        path remains an in-place ``exit()`` so no effect is duplicated.
        """
        if len(jumps) != 2 or len(labels) != 2:
            return None
        if any(index >= labels[match.group(2)] for index, match in jumps):
            return None

        depths = lua_nesting_depths(source_lines)
        if any(depths[index] != 0 for index, _match in jumps) or any(
            depths[index] != 0 for index in labels.values()
        ):
            return None

        first_jump_index, first_jump = jumps[0]
        second_jump_index, second_jump = jumps[1]
        tail_index = labels[first_jump.group(2)]
        exit_index = labels[second_jump.group(2)]
        if not first_jump_index < second_jump_index < tail_index < exit_index:
            return None
        if {first_jump.group(2), second_jump.group(2)} != set(labels):
            return None

        guarded_prefix = source_lines[first_jump_index + 1 : second_jump_index]
        guarded_body = source_lines[second_jump_index + 1 : tail_index]
        tail_body = source_lines[tail_index + 1 : exit_index]
        exit_body = source_lines[exit_index + 1 :]
        if not guarded_body or not tail_body:
            return None
        if convert_lines(exit_body) != ["exit();"]:
            return None
        if any(
            CONDITIONAL_GOTO_PATTERN.match(split_comment(line)[0])
            or GOTO_LABEL_PATTERN.match(split_comment(line)[0])
            for line in [*guarded_prefix, *guarded_body, *tail_body]
        ):
            return None

        output = convert_lines(source_lines[:first_jump_index])
        output.append(f"if ({negate_condition(normalize_expr(first_jump.group(1)))}) {{")
        output.extend("    " + line for line in convert_lines(guarded_prefix))
        output.append(f"    if ({negate_condition(normalize_expr(second_jump.group(1)))}) {{")
        output.extend("        " + line for line in convert_lines(guarded_body))
        output.append("    } else {")
        output.append("        exit();")
        output.append("    }")
        output.append("}")
        output.extend(convert_lines(tail_body))
        output.append("exit();")
        return "\n".join(output) + "\n"

    def try_convert_two_terminal_routes() -> str | None:
        """Lower two independent terminal routes with optional team joins."""
        if event_id != "1735" or len(jumps) != 5 or len(labels) != 5:
            return None
        if any(index >= labels[match.group(2)] for index, match in jumps):
            return None

        depths = lua_nesting_depths(source_lines)
        if any(depths[index] != 0 for index, _match in jumps) or any(
            depths[index] != 0 for index in labels.values()
        ):
            return None

        outer_index, outer_jump = jumps[0]
        first_join_index, first_join_jump = jumps[1]
        first_full_index, first_full_jump = jumps[2]
        second_join_index, second_join_jump = jumps[3]
        second_full_index, second_full_jump = jumps[4]
        second_route_index = labels[outer_jump.group(2)]
        first_tail_index = labels[first_join_jump.group(2)]
        first_tail_alias_index = labels[first_full_jump.group(2)]
        second_tail_index = labels[second_join_jump.group(2)]
        second_tail_alias_index = labels[second_full_jump.group(2)]
        if not (
            outer_index < first_join_index < first_full_index < first_tail_index
            and first_tail_index + 1 == first_tail_alias_index < second_route_index
            and second_route_index < second_join_index < second_full_index < second_tail_index
            and second_tail_index + 1 == second_tail_alias_index
        ):
            return None

        first_route = source_lines[outer_index + 1 : first_join_index]
        first_add = source_lines[first_full_index + 1 : first_tail_index]
        first_tail = source_lines[first_tail_alias_index + 1 : second_route_index]
        second_route = source_lines[second_route_index + 1 : second_join_index]
        second_add = source_lines[second_full_index + 1 : second_tail_index]
        second_tail = source_lines[second_tail_alias_index + 1 :]
        regions = [first_route, first_add, first_tail, second_route, second_add, second_tail]
        if any(not region for region in regions) or any(
            CONDITIONAL_GOTO_PATTERN.match(split_comment(line)[0])
            or GOTO_LABEL_PATTERN.match(split_comment(line)[0])
            for region in regions
            for line in region
        ):
            return None
        if convert_lines(first_tail)[-1:] != ["exit();"] or convert_lines(second_tail)[-1:] != ["exit();"]:
            return None

        def append_route(route: list[str], join: re.Match[str], full: re.Match[str], addition: list[str], tail: list[str], indent: str) -> list[str]:
            output = [indent + line for line in convert_lines(route)]
            output.append(f"{indent}if ({negate_condition(normalize_expr(join.group(1)))}) {{")
            output.append(f"{indent}    if ({negate_condition(normalize_expr(full.group(1)))}) {{")
            output.extend(f"{indent}        {line}" for line in convert_lines(addition))
            output.append(f"{indent}    }}")
            output.append(f"{indent}}}")
            output.extend(indent + line for line in convert_lines(tail))
            return output

        output = convert_lines(source_lines[:outer_index])
        output.append(f"if ({negate_condition(normalize_expr(outer_jump.group(1)))}) {{")
        output.extend(append_route(first_route, first_join_jump, first_full_jump, first_add, first_tail, "    "))
        output.append("} else {")
        output.extend(append_route(second_route, second_join_jump, second_full_jump, second_add, second_tail, "    "))
        output.append("}")
        return "\n".join(output) + "\n"

    def try_convert_shared_tail_gotos() -> str | None:
        """Lower a forward guard chain whose labels are adjacent aliases.

        A pattern such as ``goto label1 ... goto label2 ... ::label1::
        ::label2:: tail`` has one effective tail: every label immediately
        falls through the same code. Nested negated guards retain the exact
        short-circuit evaluation order without duplicating that shared tail.
        """
        if not jumps or any(index >= labels[match.group(2)] for index, match in jumps):
            return None

        target_positions = {labels[match.group(2)] for _index, match in jumps}
        tail_start = min(target_positions)
        tail_labels: list[int] = []
        position = tail_start
        while position < len(source_lines):
            code, _comment = split_comment(source_lines[position])
            if not GOTO_LABEL_PATTERN.match(code):
                break
            tail_labels.append(position)
            position += 1
        tail_end = position
        if not tail_labels or target_positions - set(tail_labels):
            return None
        if any(index >= tail_start for index, _match in jumps):
            return None

        depths_before_tail = lua_nesting_depths(source_lines[:tail_start])
        first_jump = jumps[0][0]
        if any(depth != 0 for depth in depths_before_tail[first_jump:]):
            return None

        jump_at = {index: match for index, match in jumps}

        def lower_chain(start: int) -> list[str]:
            output: list[str] = []
            position = start
            while position < tail_start:
                jump = jump_at.get(position)
                if jump is None:
                    position += 1
                    continue
                output.extend(convert_lines(source_lines[start:position]))
                output.append(f"if ({negate_condition(normalize_expr(jump.group(1)))}) {{")
                output.extend("    " + line for line in lower_chain(position + 1))
                output.append("}")
                return output
            output.extend(convert_lines(source_lines[start:tail_start]))
            return output

        output = convert_lines(source_lines[:first_jump])
        output.extend(lower_chain(first_jump))
        output.extend(convert_lines(source_lines[tail_end:]))
        return "\n".join(output) + "\n"

    def convert_basic_block(lines: list[str]) -> list[str]:
        return convert_lines(lines)

    def has_short_circuit_guard_shape() -> bool:
        """Return whether the whole event is a sequence of skip-body guards."""
        position = 0
        consumed_jumps = 0
        while position < len(source_lines):
            code, _comment = split_comment(source_lines[position])
            first_guard = CONDITIONAL_GOTO_PATTERN.match(code)
            if not first_guard:
                if GOTO_LABEL_PATTERN.match(code):
                    break
                position += 1
                continue

            guards = [first_guard]
            guard_end = position + 1
            while guard_end < len(source_lines):
                guard_code, guard_comment = split_comment(source_lines[guard_end])
                guard = CONDITIONAL_GOTO_PATTERN.match(guard_code)
                if guard is None or guard_comment:
                    break
                guards.append(guard)
                guard_end += 1

            target_positions = [labels.get(guard.group(2)) for guard in guards]
            if any(target is None for target in target_positions):
                return False
            body_end = min(target_positions)
            if body_end <= guard_end or any(target != body_end + offset for offset, target in enumerate(sorted(target_positions))):
                return False
            if any(not GOTO_LABEL_PATTERN.match(split_comment(source_lines[label_index])[0]) for label_index in range(body_end, body_end + len(guards))):
                return False

            consumed_jumps += len(guards)
            position = body_end + len(guards)

        return consumed_jumps == len(jumps) and consumed_jumps > 0 and position == len(source_lines)

    def convert_continuation_graph(looping: bool = False) -> str:
        boundaries = sorted({0, len(source_lines), *labels.values(), *(index + 1 for index, _match in jumps)})
        blocks: list[tuple[int, int]] = [
            (boundaries[index], boundaries[index + 1])
            for index in range(len(boundaries) - 1)
            if boundaries[index] < boundaries[index + 1]
        ]
        block_at = {start: index for index, (start, _end) in enumerate(blocks)}
        label_blocks = {label: block_at[position] for label, position in labels.items()}
        jump_at = {index: match for index, match in jumps}

        # Label-only blocks produced by adjacent forward jumps contain no
        # statements or branch. Bypass their entire chain so the state machine
        # only contains real decision and effect blocks.
        trampolines: dict[int, int] = {}
        for block_index, (start, end) in enumerate(blocks[:-1]):
            body_start = start + (1 if start in labels.values() else 0)
            jump_index = end - 1
            if body_start == end and jump_index not in jump_at:
                trampolines[block_index] = block_index + 1

        def resolve_block(index: int) -> int:
            while index in trampolines:
                index = trampolines[index]
            return index

        pc_name = f"__cifa_pc_{event_id}"
        output = [f"{pc_name} = {resolve_block(0)};"]
        if looping:
            output.append("do {")
        for block_index, (start, end) in enumerate(blocks):
            if block_index in trampolines:
                continue
            output.append(f"{'    ' if looping else ''}if ({pc_name} == {block_index}) {{")
            body_start = start + (1 if start in labels.values() else 0)
            jump_index = end - 1
            jump = jump_at.get(jump_index)
            body_end = jump_index if jump is not None else end
            converted_body = convert_basic_block(source_lines[body_start:body_end])
            for line in converted_body:
                output.append(f"{'        ' if looping else '    '}{line}")
            if jump is not None:
                target = resolve_block(label_blocks[jump.group(2)])
                output.append(f"{'        ' if looping else '    '}if ({normalize_expr(jump.group(1))}) {{")
                output.append(f"{'            ' if looping else '        '}{pc_name} = {target};")
                output.append(f"{'        ' if looping else '    '}}} else {{")
                output.append(f"{'            ' if looping else '        '}{pc_name} = {resolve_block(block_index + 1)};")
                output.append(f"{'        ' if looping else '    '}}}")
            has_exit = any(line.strip() == "exit();" for line in converted_body)
            if not has_exit and jump is None:
                if block_index + 1 < len(blocks):
                    output.append(f"{'        ' if looping else '    '}{pc_name} = {resolve_block(block_index + 1)};")
                elif looping:
                    output.append(f"        {pc_name} = -1;")
            output.append(f"{'    ' if looping else ''}}}")
        if looping:
            output.append(f"}} while ({pc_name} >= 0);")
        return "\n".join(output) + "\n"

    # A single backward edge to a label with no other control-flow inside its
    # interval is a natural do/while loop. Lower it before building the
    # forward-only continuation graph that follows the loop.
    backward_jumps = [(index, match) for index, match in jumps if labels[match.group(2)] < index]
    if len(backward_jumps) == 1:
        loop_jump_index, loop_jump = backward_jumps[0]
        loop_start = labels[loop_jump.group(2)]
        interior_jumps = [index for index, _match in jumps if loop_start < index < loop_jump_index]
        interior_labels = [index for index in labels.values() if loop_start < index < loop_jump_index]
        if not interior_jumps and not interior_labels:
            prefix = source_lines[:loop_start]
            loop_body = source_lines[loop_start + 1 : loop_jump_index]
            suffix = source_lines[loop_jump_index + 1 :]
            rewritten = prefix + [f"do -- cifa-loop {normalize_expr(loop_jump.group(1))}"] + loop_body + ["end"] + suffix
            # Reuse the regular lowering path for any forward branches after
            # the loop. The marker becomes a Cifa do/while below.
            loop_output = convert_lines(prefix)
            loop_output.append("do {")
            loop_output.extend("    " + line for line in convert_basic_block(loop_body))
            loop_output.append(f"}} while ({normalize_expr(loop_jump.group(1))});")
            if suffix:
                suffix_text = "\n".join(suffix)
                if has_goto(suffix_text):
                    suffix_output = convert_goto_lua_text(suffix_text, event_id)
                    loop_output.extend(suffix_output.rstrip().splitlines())
                else:
                    loop_output.extend(convert_basic_block(suffix))
            return "\n".join(loop_output) + "\n"

    short_circuit_guard_shape = has_short_circuit_guard_shape()

    if not short_circuit_guard_shape:
        nested_output = try_convert_nested_forward_gotos()
        if nested_output is not None:
            return nested_output

        nested_shared_tail_output = try_convert_nested_shared_tail_gotos()
        if nested_shared_tail_output is not None:
            return nested_shared_tail_output

        two_way_join_output = try_convert_two_way_shared_join()
        if two_way_join_output is not None:
            return two_way_join_output

        optional_terminal_output = try_convert_optional_terminal_diversion()
        if optional_terminal_output is not None:
            return optional_terminal_output

        guarded_tail_output = try_convert_guarded_common_tail()
        if guarded_tail_output is not None:
            return guarded_tail_output

        terminal_routes_output = try_convert_two_terminal_routes()
        if terminal_routes_output is not None:
            return terminal_routes_output

        shared_tail_output = try_convert_shared_tail_gotos()
        if shared_tail_output is not None:
            return shared_tail_output

    # A forward-only CFG can be emitted as a set of local continuation
    # functions. This preserves shared join blocks without duplicating them or
    # introducing a synthetic state variable.
    if len(jumps) > 1 and labels and all(index < labels[match.group(2)] for index, match in jumps) and not short_circuit_guard_shape:
        return convert_continuation_graph()

    # These battle effects are arbitrary CFGs with bounded grid scans. A PC
    # dispatcher preserves their backward edges without retaining Lua labels.
    if event_id in {"483", "490", "491"} and len(jumps) > 1 and labels:
        return convert_continuation_graph(looping=True)

    # A sequence of guards that all target the labels immediately after one body
    # is a normal short-circuit condition, not a state machine.
    guarded_output: list[str] = []
    position = 0
    consumed_jumps = 0
    while position < len(source_lines):
        code, _comment = split_comment(source_lines[position])
        first_guard = CONDITIONAL_GOTO_PATTERN.match(code)
        if not first_guard:
            if GOTO_LABEL_PATTERN.match(code):
                break
            guarded_output.extend(convert_lines([source_lines[position]]))
            position += 1
            continue

        guards = [first_guard]
        guard_end = position + 1
        while guard_end < len(source_lines):
            guard_code, _guard_comment = split_comment(source_lines[guard_end])
            guard = CONDITIONAL_GOTO_PATTERN.match(guard_code)
            if not guard:
                break
            guards.append(guard)
            guard_end += 1

        target_positions = [labels.get(guard.group(2)) for guard in guards]
        if any(target is None for target in target_positions):
            break
        body_end = min(target_positions)
        if body_end <= guard_end or any(target != body_end + offset for offset, target in enumerate(sorted(target_positions))):
            break
        if any(not GOTO_LABEL_PATTERN.match(split_comment(source_lines[label_index])[0]) for label_index in range(body_end, body_end + len(guards))):
            break

        conditions = [normalize_expr(guard.group(1)) for guard in guards]
        guarded_output.append(f"if ({' && '.join(negate_condition(condition) for condition in conditions)}) {{")
        guarded_output.extend("    " + line for line in convert_lines(source_lines[guard_end:body_end]))
        guarded_output.append("}")
        consumed_jumps += len(guards)
        position = body_end + len(guards)

    if consumed_jumps == len(jumps) and consumed_jumps > 0 and position == len(source_lines):
        return "\n".join(guarded_output) + "\n"

    if len(jumps) > 1 and len(labels) == len(jumps):
        target_labels = {match.group(2) for _index, match in jumps}
        if target_labels == set(labels) and all(index < labels[match.group(2)] for index, match in jumps):
            first_jump = jumps[0][0]
            last_jump = jumps[-1][0]
            first_label = min(labels.values())
            if first_label > last_jump:
                conditions = []
                for (index, _match), (next_index, _next_match) in zip(jumps, jumps[1:]):
                    if any(source_lines[between].strip() for between in range(index + 1, next_index)):
                        raise ConvertError("complex goto flow")
                for _index, match in jumps:
                    conditions.append(normalize_expr(match.group(1)))

                unsupported = find_unsupported("\n".join(source_lines[:first_jump] + source_lines[last_jump + 1 : first_label] + source_lines[first_label + len(labels) :]))
                if unsupported:
                    raise ConvertError(unsupported)
                output = convert_lines(source_lines[:first_jump])
                output.append(f"if (!({' || '.join(conditions)})) {{")
                output.extend("    " + line for line in convert_lines(source_lines[last_jump + 1 : first_label]))
                output.append("}")
                output.extend(convert_lines(source_lines[first_label + len(labels) :]))
                return "\n".join(output) + "\n"

    if len(jumps) != 1 or len(labels) != 1:
        raise ConvertError("complex goto flow")

    jump_index, jump_match = jumps[0]
    condition, target_label = jump_match.groups()
    if target_label not in labels:
        raise ConvertError(f"unknown goto label: {target_label}")
    target_index = labels[target_label]

    # Ignore the source jump when checking unsupported syntax; it is lowered below.
    unsupported = find_unsupported("\n".join(source_lines[:jump_index] + source_lines[jump_index + 1 :]))
    if unsupported:
        raise ConvertError(unsupported)

    if jump_index < target_index:
        output = convert_lines(source_lines[:jump_index])
        output.append(f"if ({negate_condition(normalize_expr(condition))}) {{")
        output.extend("    " + line for line in convert_lines(source_lines[jump_index + 1 : target_index]))
        output.append("}")
        output.extend(convert_lines(source_lines[target_index + 1 :]))
        return "\n".join(output) + "\n"

    output = convert_lines(source_lines[:target_index])
    output.append("do {")
    output.extend("    " + line for line in convert_lines(source_lines[target_index + 1 : jump_index]))
    output.append(f"}} while ({normalize_expr(condition)});")
    output.extend(convert_lines(source_lines[jump_index + 1 :]))
    return "\n".join(output) + "\n"


def find_unsupported(text: str) -> str:
    code_lines = []
    for line in text.splitlines():
        code, _comment = split_comment(line)
        code_lines.append(code)
    code = "\n".join(code_lines)
    for pattern, reason in UNSUPPORTED_PATTERNS:
        if pattern.search(code):
            return reason
    return ""


def remove_legacy_memory_calls(output: str) -> str:
    """Replace fixed DOS compatibility addresses in hand-written templates."""
    fixed_reads = {
        "read_mem(1911134)": "getcurrentscene()",
        "read_mem(1911134 + 0)": "getcurrentscene()",
        "read_mem(1911132)": "getsceney()",
        "read_mem(1911132 + 0)": "getsceney()",
        "read_mem(1911130)": "getscenex()",
        "read_mem(1911130 + 0)": "getscenex()",
        "read_mem(345330)": "getsceneface()",
        "read_mem(345330 + 0)": "getsceneface()",
        "read_mem(349914)": "getbattlecursorx()",
        "read_mem(349914 + 0)": "getbattlecursorx()",
        "read_mem(349916)": "getbattlecursory()",
        "read_mem(349916 + 0)": "getbattlecursory()",
        "read_mem(1994454)": "getbattleactor()",
        "read_mem(1994454 + 0)": "getbattleactor()",
        "read_mem(1837968)": "getbattletick()",
        "read_mem(1837968 + 0)": "getbattletick()",
    }
    for old, new in fixed_reads.items():
        output = output.replace(old, new)
    output = re.sub(
        r"write_mem\(1911134(?: \+ 0)?, ([^\n]+)\);",
        r"setspecialcurrentscene(\1); UpdateAllScreen();",
        output,
    )
    output = re.sub(
        r"^\s*SetX50\([^\n]*read_mem\([^\n]*\)\);\s*\n",
        "",
        output,
        flags=re.MULTILINE,
    )
    output = re.sub(r"write_mem\([^\n]*\);", "UpdateAllScreen();", output)
    return output


def convert_lua_text(text: str, event_id: str = "") -> str:
    if event_id == "1424":
        return convert_ka1424()
    if event_id == "241":
        return convert_synthesis_common()
    if event_id == "302":
        return convert_ka302()
    if event_id == "1049":
        return convert_ka1049()
    if event_id == "1050":
        return convert_ka1050()
    if event_id == "1858":
        return convert_ka1858()
    if event_id == "231":
        return convert_ka231()
    if event_id == "232":
        return convert_ka232()
    if event_id == "249":
        return convert_ka249()
    if event_id == "211":
        return convert_ka211()
    if event_id == "212":
        return convert_ka212()
    if event_id == "215":
        return convert_ka215()
    if event_id == "234":
        return convert_ka234()
    if event_id == "235":
        return convert_ka235()
    if event_id == "248":
        return convert_ka248()
    if event_id == "237":
        return convert_ka237()
    if event_id == "238":
        return convert_ka238()
    if event_id == "239":
        return convert_ka239()
    if event_id == "370":
        return convert_ka370()
    if event_id == "356":
        return convert_ka356()
    if event_id == "216":
        return convert_ka216()
    if event_id == "218":
        return convert_ka218()
    if event_id == "487":
        return convert_ka487()
    if event_id == "488":
        return convert_ka488()
    if event_id == "485":
        return convert_ka485()
    if event_id == "402":
        return convert_ka402()
    if event_id == "353":
        return convert_ka353()
    if event_id == "252":
        return convert_ka252()
    if event_id == "222":
        return convert_ka222()
    if event_id == "351":
        return convert_ka351()
    if event_id in SYNTHESIS_CONFIG_EVENTS:
        return convert_synthesis_config(text)
    text = inline_legacy_next_instruction(text)
    text = simplify_star_state_pairs(text)
    text = simplify_jump_flag_pairs(text)
    if has_goto(text):
        try:
            return convert_goto_lua_text(text, event_id)
        except ConvertError as structured_error:
            try:
                return convert_restricted_goto_lua_text(text)
            except ConvertError:
                raise structured_error
    unsupported = find_unsupported(text)
    if unsupported:
        raise ConvertError(unsupported)
    lines: list[str] = []
    for line in text.splitlines():
        converted = convert_statement(line.rstrip())
        if converted.strip():
            lines.append(converted)
    output = "\n".join(lines).rstrip() + "\n"
    if event_id == "302":
        output = normalize_else_if_chain(output)
    return output


def event_number(path: Path) -> str:
    match = re.fullmatch(r"ka(\d+)\.lua", path.name, re.IGNORECASE)
    if not match:
        raise ConvertError(f"unexpected event filename: {path.name}")
    return match.group(1)


def main() -> int:
    parser = argparse.ArgumentParser(description="Convert no-goto Lua event scripts to Cifa.")
    parser.add_argument("--src", type=Path, default=Path("game/script/event"))
    parser.add_argument("--dst", type=Path, default=Path("game/script/event-cifa"))
    parser.add_argument("--dry-run", action="store_true")
    parser.add_argument("--clean", action="store_true", help="remove existing generated .cifa files before writing")
    parser.add_argument("--overwrite-existing", action="store_true", help="overwrite existing .cifa files, including hand-edited experiments")
    parser.add_argument("--skip-report", type=Path, help="write every skipped event and its reason to this file")
    args = parser.parse_args()

    if args.clean and not args.overwrite_existing:
        parser.error("--clean requires --overwrite-existing")

    args.dst.mkdir(parents=True, exist_ok=True)
    if args.clean and not args.dry_run:
        for path in args.dst.glob("*.cifa"):
            path.unlink()

    is_game0_source = any(part.lower() == "game0" for part in args.src.parts)
    converted = 0
    skipped: list[tuple[Path, str]] = []
    for path in sorted(args.src.glob("ka*.lua")):
        text = path.read_text(encoding="utf-8-sig")
        if is_exit_only_lua(text):
            skipped.append((path, "exit-only event"))
            continue
        try:
            number = event_number(path)
            conversion_event_id = f"game0-{number}" if is_game0_source else number
            output = remove_legacy_memory_calls(convert_lua_text(text, conversion_event_id))
        except ConvertError as exc:
            skipped.append((path, SPECIAL_EVENT_REASONS.get(event_number(path), str(exc))))
            continue
        converted += 1
        if not args.dry_run:
            dst_path = args.dst / f"{number}.cifa"
            if dst_path.exists() and not args.overwrite_existing:
                continue
            formatted = format_cifa_indentation(strip_terminal_exit(strip_cifa_comments(output)))
            dst_path.write_text(formatted, encoding="utf-8")

    print(f"converted={converted}")
    print(f"skipped={len(skipped)}")
    for path, reason in skipped[:50]:
        print(f"skip {path.name}: {reason}")
    if len(skipped) > 50:
        print(f"... {len(skipped) - 50} more skipped")
    if args.skip_report:
        args.skip_report.parent.mkdir(parents=True, exist_ok=True)
        args.skip_report.write_text(
            "".join(f"{event_number(path)}: {reason}\n" for path, reason in skipped),
            encoding="utf-8",
        )
        print(f"skip_report={args.skip_report}")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())