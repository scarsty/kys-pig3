Talk(0, "徒兒，師父來看你了．", 0, 1);
Talk(44, "．．．．", 44, 0);
Talk(0, "叫師父啊．", 0, 1);
Talk(44, "．．．師．．師父．", 44, 0);
if AskJoin () == true then goto label0 end;
    Talk(0, "記得要乖哦！", 0, 1);
    exit();
::label0::
    Talk(0, "徒兒，你就跟為師的走吧．", 0, 1);
    if TeamIsFull() == false then goto label1 end;
        Talk(44, "你的隊伍已滿，我無法加入．", 44, 0);
        exit();
::label1::
        Talk(44, "是．", 44, 0);
        DarkScene();
        ModifyEvent(-2, -2, 0, 0, -1, -1, -1, -1, -1, -1, -2, -2, -2);
        LightScene();
        Join(44);
exit();
