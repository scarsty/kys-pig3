Talk(16, "少俠如果有需要的話，儘管說出來．", 16, 0);
if AskJoin () == true then goto label0 end;
    Talk(0, "改日如果有需要時，我一定會來找胡前輩．", 0, 1);
    exit();
::label0::
    Talk(0, "好吧！那就麻煩胡前輩與我一起奔波江湖了．", 0, 1);
    if TeamIsFull() == false then goto label1 end;
        Talk(16, "你的隊伍已滿，我無法加入．", 16, 0);
        exit();
::label1::
        DarkScene();
        ModifyEvent(-2, -2, 0, 0, -1, -1, -1, -1, -1, -1, -2, -2, -2);
        LightScene();
        Join(16);
        AddEthics(1);
exit();
