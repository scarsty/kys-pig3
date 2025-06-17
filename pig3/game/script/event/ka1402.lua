if HaveItem(51) == true then goto label0 end;
    Talk(69, "（笑而不語）", -2, 0, 0, 0);
    exit();
::label0::
    Talk(69, "呵呵，小兄弟果知我意，那和尚我便同你走一趟吧。", -2, 1, 0, 0);
    DarkScene();
    ModifyEvent(39, 3, 0, 0, 0, 0, 0, 0, 0, 0, 0, -2, -2);
    LightScene();
    instruct_50(43, 0, 209, 60, 1, 0, 0);
    instruct_50(43, 0, 228, 60, 69, 0, 0);
    ModifyEvent(15, 27, 1, 0, 766, 0, 0, 7302, 7302, 7302, 0, -2, -2);
    GetItem(151, 1);
exit();
