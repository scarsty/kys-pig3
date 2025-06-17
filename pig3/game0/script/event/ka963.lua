Talk(28, "有什麼事嗎？", 28, 0);
if AskJoin () == true then goto label0 end;
    Talk(0, "沒事沒事．", 0, 1);
    exit();
::label0::
    Talk(0, "這次來是要您再隨我一走，隊伍中需要大夫．", 0, 1);
    if TeamIsFull() == false then goto label1 end;
        Talk(28, "你的隊伍已滿，我無法加入．", 28, 0);
        exit();
::label1::
        Talk(28, "走吧．", 28, 0);
        DarkScene();
        ModifyEvent(-2, -2, 0, -1, -1, -1, -1, -1, -1, -1, -1, -2, -2);
        LightScene();
        Join(28);
exit();
