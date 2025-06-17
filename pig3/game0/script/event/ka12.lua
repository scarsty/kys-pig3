Talk(0, "胡大哥，我知道苗人鳳的下落，而關於你們之間的恩怨是如此如此這般這般．．．", 0, 1);
if AskJoin () == true then goto label0 end;
    exit();
::label0::
    Talk(0, "胡大哥是否肯隨我一走？", 0, 1);
    if TeamIsFull() == false then goto label1 end;
        Talk(1, "你的隊伍已滿，我無法加入．", 1, 0);
        exit();
::label1::
        Talk(1, "好．我就隨你一走．", 1, 0);
        Talk(0, "胡大哥肯隨我一走，那再好也不過了．", 0, 1);
        DarkScene();
        ModifyEvent(-2, -2, 0, -1, -1, -1, -1, -1, -1, -1, -1, -2, -2);
        LightScene();
        Join(1);
        AddEthics(1);
exit();
