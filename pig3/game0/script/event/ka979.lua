Talk(47, "愣小子，要幹嘛？", 47, 0);
if AskJoin () == true then goto label0 end;
    Talk(0, "沒事．", 0, 1);
    exit();
::label0::
    Talk(0, "阿紫姑娘，再加入我好嗎？", 0, 1);
    if TeamIsFull() == false then goto label1 end;
        Talk(47, "你的隊伍已滿，我無法加入．", 47, 0);
        exit();
::label1::
        Talk(47, "你不怕我的話就走吧．", 47, 0);
        DarkScene();
        ModifyEvent(-2, -2, 0, -1, -1, -1, -1, -1, -1, -1, -1, -2, -2);
        LightScene();
        Join(47);
exit();
