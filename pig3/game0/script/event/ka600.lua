Talk(37, "謝謝兄台救了我．", 37, 0);
if AskJoin () == true then goto label0 end;
    exit();
::label0::
    Talk(0, "這樣好了，你要不要和我一起走，路上也有個照應．", 0, 1);
    if JudgeEthics(0, 60, 100) == true then goto label1 end;
        Talk(37, "不了！我這個不幸之人還是別害人的好．", 37, 1);
        exit();
::label1::
        if TeamIsFull() == false then goto label2 end;
            Talk(37, "你的隊伍已滿，我無法加入．", 37, 0);
            exit();
::label2::
            Talk(37, "好吧！如果你不怕被我這個不幸之人連累的話．", 37, 0);
            DarkScene();
            ModifyEvent(-2, -2, 0, 0, -1, -1, -1, -1, -1, -1, -2, -2, -2);
            ModifyEvent(-2, 9, 0, 0, -1, -1, -1, -1, -1, -1, -2, -2, -2);
            ModifyEvent(-2, 10, 0, 0, -1, -1, -1, -1, -1, -1, -2, -2, -2);
            LightScene();
            Join(37);
            AddEthics(3);
exit();
