if UseItem(240) == true then goto label0 end;
    exit();
::label0::
    GetItem(240, -1);
    Talk(226, "天地不仁，以萬物為芻狗。絕情斷性，方可陰陽調和，逆反先天。", "葵花太監", 0, 0, 0);
    Talk(226, "絕情斷性，是為了獲得天下無敵的武功。有了這武功，才有金錢和權勢，甚至是……人們的尊重。", "林遠圖", 0, 0, 0);
    if TryBattle(283) == true then goto label1 end;
        Dead();
        LightScene();
        exit();
::label1::
        instruct_50(17, 0, 0, 0, 146, 0, 0);
        instruct_50(3, 0, 0, 0, 0, 100, 0);
        instruct_50(16, 4, 0, 0, 146, 0, 0);
        LightScene();
        Talk(226, "天亦有時盡，人亦有時終……", "葵花太監", 0, 0, 0);
        Talk(226, "武功……終也有帶不來的東西。", "林遠圖", 0, 0, 0);
        ModifyEvent(128, 1, 1, 0, 1759, 0, 0, 6698, 6698, 6698, 0, -2, -2);
exit();
