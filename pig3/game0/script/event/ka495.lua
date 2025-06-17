Talk(109, "公子有什麼事嗎？", 109, 0);
if AskJoin () == true then goto label0 end;
    Talk(0, "沒事，姑娘真是美麗．", 0, 1);
    exit();
::label0::
    Talk(0, "聽說姑娘武學淵博，不知是否能於在下旅程中，給予一些指導．", 0, 1);
    if InTeam(51) == true then goto label1 end;
        Talk(109, "我要留下來陪我表哥．", 109, 0);
        exit();
::label1::
        if TeamIsFull() == false then goto label2 end;
            Talk(109, "你的隊伍已滿，我無法加入．", 109, 0);
            exit();
::label2::
            Talk(109, "既然我表哥都加入了，我當然要伴著他．", 109, 0);
            DarkScene();
            ModifyEvent(-2, -2, 0, 0, -1, -1, -1, -1, -1, -1, -2, -2, -2);
            LightScene();
            Join(76);
            AddEthics(1);
exit();
