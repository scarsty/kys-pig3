Talk(54, "小兄弟，最近還好嗎？", 54, 0);
if AskJoin () == true then goto label0 end;
    Talk(0, "托袁兄的福，一切還好．", 0, 1);
    exit();
::label0::
    Talk(0, "不瞞袁兄，最近諸事不順．．．．．．．", 0, 1);
    if TeamIsFull() == false then goto label1 end;
        Talk(54, "你的隊伍已滿，我無法加入．", 54, 0);
        exit();
::label1::
        Talk(54, "別說了，我們走吧．", 54, 0);
        DarkScene();
        ModifyEvent(-2, -2, 0, -1, -1, -1, -1, -1, -1, -1, -1, -2, -2);
        LightScene();
        Join(54);
exit();
