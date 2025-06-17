PlayWave(21);
Talk(0, "哇！這是什麼怪物．", 0, 1);
Talk(53, "難道．．．．．．．．．．難道竟是傳說中的萬毒之王”莽牯朱蛤”，小心點！", 53, 1);
if TryBattle(78) == true then goto label0 end;
    Dead();
    exit();
::label0::
    ModifyEvent(-2, 2, 0, 0, -1, -1, -1, -1, -1, -1, -2, -2, -2);
    ModifyEvent(-2, 3, 0, 0, -1, -1, -1, -1, -1, -1, -2, -2, -2);
    ModifyEvent(-2, 4, 0, 0, -1, -1, -1, -1, -1, -1, -2, -2, -2);
    ModifyEvent(-2, 5, 0, 0, -1, -1, -1, -1, -1, -1, -2, -2, -2);
    LightScene();
    Talk(0, "真是好險，差點就變成了這”癩蛤蟆”的晚餐了．這會換我來頓”三杯田雞”．", 0, 1);
    GetItem(38, 1);
    AddRepute(3);
exit();
