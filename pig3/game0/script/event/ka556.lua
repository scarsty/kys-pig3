Talk(45, "少俠有什麼吩咐？", 45, 0);
if AskJoin () == true then goto label0 end;
    Talk(0, "沒什麼事，我路過這裡，進來看看你．", 0, 1);
    exit();
::label0::
    if TeamIsFull() == false then goto label1 end;
        Talk(45, "你的隊伍已滿，我無法加入．", 45, 0);
        exit();
::label1::
        Talk(0, "你的醫術很高明，就加入我的隊伍，日後也能幫我們治病療傷．", 0, 1);
        Talk(45, "是．", 45, 0);
        DarkScene();
        ModifyEvent(-2, -2, 0, 0, -1, -1, -1, -1, -1, -1, -2, -2, -2);
        LightScene();
        Join(45);
exit();
