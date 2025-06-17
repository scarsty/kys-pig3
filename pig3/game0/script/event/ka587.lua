PlayAnimation(13, 6420, 6448);
Talk(0, "哇！鱷魚！", 0, 1);
if TryBattle(89) == true then goto label0 end;
    Dead();
    exit();
::label0::
    ModifyEvent(-2, -2, 0, 0, -1, -1, -1, -1, -1, -1, -2, -2, -2);
    ModifyEvent(-2, 13, 0, 0, -1, -1, -1, -1, -1, -1, -2, -2, -2);
    SetSceneMap(-2, 0, 28, 34, 358);
    LightScene();
    AddRepute(1);
exit();
