Talk(0, "又有一群大蜘蛛，我得小心點，免得當了蜘蛛的點心．　　　", 0, 1);
if TryBattle(64) == true then goto label0 end;
    Dead();
    exit();
::label0::
    ModifyEvent(-2, 32, 0, 0, -1, -1, -1, -1, -1, -1, -2, -2, -2);
    ModifyEvent(-2, 33, 0, 0, -1, -1, -1, -1, -1, -1, -2, -2, -2);
    ModifyEvent(-2, 34, 0, 0, -1, -1, -1, -1, -1, -1, -2, -2, -2);
    ModifyEvent(-2, 35, 0, 0, -1, -1, -1, -1, -1, -1, -2, -2, -2);
    ModifyEvent(-2, 42, 0, 0, -1, -1, -1, -1, -1, -1, -2, -2, -2);
    LightScene();
    AddRepute(1);
exit();
