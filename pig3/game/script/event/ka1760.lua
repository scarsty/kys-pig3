if UseItem(240) == true then goto label0 end;
    exit();
::label0::
    GetItem(240, -1);
    Talk(159, "身隕道存，執念不入極樂土。示法宏願，殘魂長待有緣人。", "達摩", 0, 0, 0);
    if TryBattle(285) == true then goto label1 end;
        Dead();
        LightScene();
        exit();
::label1::
        instruct_50(17, 0, 0, 0, 146, 0, 0);
        instruct_50(3, 0, 0, 0, 0, 100, 0);
        instruct_50(16, 4, 0, 0, 146, 0, 0);
        LightScene();
        Talk(159, "佛國清淨，尚需明王護法；紅塵滾滾，還得霹靂降魔。", "達摩", 0, 0, 0);
        ModifyEvent(128, 2, 1, 0, 1761, 0, 0, 6698, 6698, 6698, 0, -2, -2);
exit();
