if UseItem(240) == true then goto label0 end;
    exit();
::label0::
    GetItem(240, -1);
    Talk(257, "葬劍深山兮，友鵰鵬；無敵天下兮，魂難終。", -2, 0, 0, 0);
    if TryBattle(282) == true then goto label1 end;
        Dead();
        LightScene();
        exit();
::label1::
        instruct_50(17, 0, 0, 0, 146, 0, 0);
        instruct_50(3, 0, 0, 0, 0, 100, 0);
        instruct_50(16, 4, 0, 0, 146, 0, 0);
        LightScene();
        Talk(257, "求道卅載兮，買舟而東；舞劍放歌兮，笑盡英雄。", -2, 0, 0, 0);
        ModifyEvent(128, 0, 1, 0, 1757, 0, 0, 6698, 6698, 6698, 0, -2, -2);
exit();
