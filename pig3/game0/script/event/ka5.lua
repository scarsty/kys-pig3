Talk(1, "小兄弟，再次造訪，是否練就了更高深的武功胡某候教．", 1, 0);
if AskBattle() == true then goto label0 end;
    exit();
::label0::
    Talk(0, "晚輩斗膽向前輩討教討教．", 0, 1);
    if TryBattle(7) == false then goto label1 end;
        LightScene();
        Talk(1, "可恨啊！可恨！只恨胡某刀譜不全，未能練成我祖傳之胡家刀法", 1, 0);
        ModifyEvent(-2, -2, -2, -2, 3, -2, -2, -2, -2, -2, -2, -2, -2);
        exit();
::label1::
        LightScene();
        Talk(1, "小兄弟，功夫雖有精進，但火侯仍嫌不夠．", 1, 0);
        Talk(0, "他日再向胡大哥領教刀法．", 0, 1);
        ModifyEvent(-2, -2, -2, -2, 4, -2, -2, -2, -2, -2, -2, -2, -2);
exit();
