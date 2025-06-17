if UseItem(193) == true then goto label0 end;
    exit();
::label0::
    AddItem(193, -1);
    Talk(82, "這位少俠請進．", 82, 0);
    DarkScene();
    ModifyEvent(-2, 0, -2, -2, 183, -1, -1, 5192, 5192, 5192, -2, 30, 48);
    ModifyEvent(-2, 20, -2, -2, 183, -1, -1, 5186, 5186, 5186, -2, 27, 48);
    ModifyEvent(-2, 1, -2, -2, 183, -1, -1, -2, -2, -2, -2, -2, -2);
    ModifyEvent(-2, 2, -2, -2, 183, -1, -1, -2, -2, -2, -2, -2, -2);
    LightScene();
exit();
