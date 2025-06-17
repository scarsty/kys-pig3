if UseItem(132) == true then goto label0 end;
    exit();
::label0::
    AddItem(132, -1);
    Talk(41, "公子請往裡面走，島主已恭候多時了．", 41, 0);
    DarkScene();
    ModifyEvent(-2, -2, -2, -2, 351, -1, -1, 5146, 5146, 5146, -2, 30, 50);
    LightScene();
exit();
