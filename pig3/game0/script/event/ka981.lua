Talk(48, "你要幹嘛？", 48, 0);
if AskJoin () == true then goto label0 end;
    Talk(0, "沒事．", 0, 1);
    exit();
::label0::
    Talk(0, "鐵面，我需要你的幫忙，走吧．", 0, 1);
    if TeamIsFull() == false then goto label1 end;
        Talk(48, "你的隊伍已滿，我無法加入．", 48, 0);
        exit();
::label1::
        Talk(48, "嗯．", 48, 0);
        DarkScene();
        ModifyEvent(-2, -2, 0, -1, -1, -1, -1, -1, -1, -1, -1, -2, -2);
        LightScene();
        Join(48);
exit();
