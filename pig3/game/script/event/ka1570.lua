if InTeam(23) == true then goto label0 end;
    Talk(130, "哼，小子，你來幹什麼！", -2, 0, 0, 0);
    exit();
::label0::
    Talk(130, "你……你是銀姑的……", -2, 0, 0, 0);
    Talk(23, "湯沛，你無路可逃了。", -2, 1, 0, 0);
    Talk(130, "就憑你這個小丫頭也想留住我。", -2, 0, 0, 0);
    Talk(23, "我母親的仇，今日該報了。", -2, 1, 0, 0);
    Talk(130, "那就看你有沒有這本事了。", -2, 0, 0, 0);
    if TryBattle(277) == true then goto label1 end;
        Dead();
exit();
::label1::
        ModifyEvent(68, 35, 0, 0, 0, 0, 0, 0, 0, 0, 0, -2, -2);
        LightScene();
        Talk(23, "娘親，女兒今日已經手刃了仇人，希望您九泉之下，能夠安息。", -2, 1, 0, 0);
exit();
