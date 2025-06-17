if UseItem(0) == true then goto label0 end;
    exit();
::label0::
    instruct_50(20, 0, 0, 0, 0, 0, 0);
    instruct_50(4, 0, 0, 0, 500, 0, 0);
    if CheckJumpFlag() == true then goto label1 end;
        Talk(102, "灰貂皮一張，客官您拿好。收您五百兩。", "商販甲", 0, 1, 0);
        AddItem(0, -500);
        GetItem(255, 1);
        ModifyEvent(105, 79, 0, 0, 1649, 0, 0, 0, 0, 0, 0, -2, -2);
        exit();
::label1::
        Talk(102, "客官，小本生意不賒賬，您錢夠了再來吧。", "商販甲", 0, 1, 0);
exit();
