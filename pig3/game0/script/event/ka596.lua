Talk(91, "小子，竟敢擅闖我大輪寺，找死！", 91, 0);
if TryBattle(92) == true then goto label0 end;
    Dead();
    exit();
::label0::
    ModifyEvent(-2, 2, 0, 0, -1, -1, -1, -1, -1, -1, -2, -2, -2);
    ModifyEvent(-2, 3, 0, 0, -1, -1, -1, -1, -1, -1, -2, -2, -2);
    ModifyEvent(-2, 4, 0, 0, -1, -1, -1, -1, -1, -1, -2, -2, -2);
    ModifyEvent(-2, 5, 0, 0, -1, -1, -1, -1, -1, -1, -2, -2, -2);
    LightScene();
    GetItem(162, 1);
    AddRepute(1);
exit();
