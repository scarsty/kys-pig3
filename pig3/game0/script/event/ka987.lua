Talk(53, "公子別來無恙？", 53, 0);
if AskJoin () == true then goto label0 end;
    Talk(0, "一切還好．", 0, 1);
    exit();
::label0::
    Talk(0, "段兄弟願再陪我一遊嗎？", 0, 1);
    if TeamIsFull() == false then goto label1 end;
        Talk(53, "你的隊伍已滿，我無法加入．", 53, 0);
        exit();
::label1::
        Talk(53, "好啊．", 53, 0);
        DarkScene();
        ModifyEvent(-2, 0, 0, 0, -1, -1, -1, -1, -1, -1, -1, -2, -2);
        ModifyEvent(-2, 8, 0, 0, -1, -1, -1, -1, -1, -1, -1, -2, -2);
        LightScene();
        Join(53);
exit();
