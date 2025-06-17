if UseItem(174) == true then goto label0 end;
    exit();
::label0::
    if JudgeMoney(10) == true then goto label1 end;
        Talk(106, "客倌，你別開玩笑了，燒刀子一壺可是要１０兩銀子的！", 106, 0);
        exit();
::label1::
        AddItem(174, -10);
        Talk(106, "客倌，你慢用，", 106, 0);
        GetItem(194, 1);
        ModifyEvent(-2, -2, -2, -2, 246, -1, -1, -2, -2, -2, -2, -2, -2);
exit();
