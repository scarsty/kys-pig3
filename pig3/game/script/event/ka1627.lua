Talk(416, "哇，一群怪物，看我的！", -2, 0, 0, 0);
if TryBattle(281) == true then goto label0 end;
    Dead();
    exit();
::label0::
    ModifyEvent(107, 27, 0, 0, 0, 0, 0, 0, 0, 0, 0, -2, -2);
    ModifyEvent(107, 26, 0, 0, 0, 0, 0, 0, 0, 0, 0, -2, -2);
    ModifyEvent(107, 25, 0, 0, 0, 0, 0, 0, 0, 0, 0, -2, -2);
    ModifyEvent(107, 24, 0, 0, 0, 0, 0, 0, 0, 0, 0, -2, -2);
    ModifyEvent(107, 23, 0, 0, 0, 0, 0, 0, 0, 0, 0, -2, -2);
    ModifyEvent(107, 22, 0, 0, 0, 0, 0, 0, 0, 0, 0, -2, -2);
    ModifyEvent(107, 21, 0, 0, 0, 0, 0, 0, 0, 0, 0, -2, -2);
    LightScene();
    GetItem(256, 1);
exit();
