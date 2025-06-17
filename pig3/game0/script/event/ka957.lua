Talk(16, "少俠別來無恙？", 16, 0);
if AskJoin () == true then goto label0 end;
    Talk(0, "一切還好．", 0, 1);
    exit();
::label0::
    Talk(0, "少了胡先生的奇妙醫術，一路上難免病痛煩身，是否可以再請胡先生幫忙呢？", 0, 1);
    if TeamIsFull() == false then goto label1 end;
        Talk(16, "你的隊伍已滿，我無法加入．", 16, 0);
        exit();
::label1::
        Talk(16, "少俠有求，胡某自當效力．", 16, 0);
        DarkScene();
        ModifyEvent(-2, -2, 0, -1, -1, -1, -1, -1, -1, -1, -1, -2, -2);
        LightScene();
        Join(16);
exit();
