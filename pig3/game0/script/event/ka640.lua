if JudgeAttack(0, 75, 1000) == true then goto label0 end;
    PlayAnimation(-1, 7864, 7912);
    Talk(0, "哇塞！我使盡了吃奶的力氣還拔不出來，難道要請亞瑟王來才行嗎？", 0, 1);
    exit();
::label0::
    ModifyEvent(-2, -2, 1, 1, -1, -1, -1, 4736, 4736, 4736, -2, -2, -2);
    PlayAnimation(-1, 7864, 7912);
    PlayAnimation(-1, 7864, 7964);
    Talk(0, "終於讓我給拔出來了！", 0, 1);
    GetItem(110, 1);
exit();
