Talk(307, "小子，你也要來領教五行陣嗎？", -2, 0, 0, 0);
instruct_50(43, 0, 351, 15579, 2, 0, 0);
instruct_50(4, 0, 2, 28931, 1, 0, 0);
if CheckJumpFlag() == true then goto label0 end;
    exit();
::label0::
    SetAttribute(307, 1, 0, 0, 20);
    SetAttribute(311, 1, 0, 0, 20);
    SetAttribute(310, 1, 0, 0, 20);
    SetAttribute(309, 1, 0, 0, 20);
    SetAttribute(308, 1, 0, 0, 20);
    if TryBattle(28) == true then goto label1 end;
        Dead();
        exit();
::label1::
        ModifyEvent(21, 7, 1, 0, 1671, 0, 0, 8396, 8396, 8396, 0, -2, -2);
        ModifyEvent(21, 6, 1, 0, 1669, 0, 0, 8396, 8396, 8396, 0, -2, -2);
        ModifyEvent(21, 5, 1, 0, 1670, 0, 0, 8396, 8396, 8396, 0, -2, -2);
        ModifyEvent(21, 4, 1, 0, 1668, 0, 0, 8396, 8396, 8396, 0, -2, -2);
        ModifyEvent(21, 3, 1, 0, 1667, 0, 0, 8396, 8396, 8396, 0, -2, -2);
        LightScene();
        Talk(308, "你你你，再接我們的五行八卦陣！", -2, 0, 0, 0);
        if TryBattle(29) == true then goto label2 end;
            Dead();
            exit();
::label2::
            LightScene();
exit();
