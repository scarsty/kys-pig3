Talk(25, "這麼久都不來看我，可想死人家了．這次來是不是來帶我走的．", 25, 0);
if AskJoin () == true then goto label0 end;
    Talk(0, "沒有．經過妳這邊，順路進來看看妳．", 0, 1);
    exit();
::label0::
    Talk(0, "我這不是來了嗎．走吧．", 0, 1);
    if TeamIsFull() == false then goto label1 end;
        Talk(25, "你的隊伍已滿，我無法加入．", 25, 0);
        exit();
::label1::
        Talk(25, "真的，沒騙我．我原以為你也是個負心漢，看來是誤會你了．走吧．", 25, 0);
        DarkScene();
        ModifyEvent(-2, -2, 0, -1, -1, -1, -1, -1, -1, -1, -1, -2, -2);
        LightScene();
        Join(25);
exit();
