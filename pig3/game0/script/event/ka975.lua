Talk(44, "徒弟呀，你來看為師了．", 44, 0);
if AskJoin () == true then goto label0 end;
    Talk(0, "有沒有搞錯，徒弟是你，我才是你師父．", 0, 1);
    exit();
::label0::
    Talk(0, "有沒有搞錯，徒弟是你，我才是你師父．**走吧，師父我最近少個人伺候，總覺得渾身不對勁．", 0, 1);
    if TeamIsFull() == false then goto label1 end;
        Talk(44, "你的隊伍已滿，我無法加入．", 44, 0);
        exit();
::label1::
        Talk(44, "我就知道找我沒好事．", 44, 0);
        DarkScene();
        ModifyEvent(-2, -2, 0, -1, -1, -1, -1, -1, -1, -1, -1, -2, -2);
        LightScene();
        Join(44);
exit();
