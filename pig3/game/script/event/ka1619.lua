Talk(341, "施主，想挑戰少林銅人巷嗎？不論勝敗，只有一次機會。", -2, 0, 0, 0);
instruct_50(43, 0, 351, 13863, 2, 0, 0);
instruct_50(4, 0, 2, 28931, 1, 0, 0);
if CheckJumpFlag() == true then goto label0 end;
    exit();
::label0::
    if TryBattle(278) == true then goto label1 end;
        ModifyEvent(59, 40, 1, 0, 1621, 0, 0, 5422, 5422, 5422, 0, -2, -2);
        LightScene();
        exit();
::label1::
        LightScene();
        GetItem(170, 1);
        ModifyEvent(59, 40, 1, 0, 1621, 0, 0, 5422, 5422, 5422, 0, -2, -2);
exit();
