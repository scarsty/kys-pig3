instruct_50(17, 0, 0, 166, 54, 0, 0);
instruct_50(3, 0, 0, 0, 0, 1, 0);
instruct_50(16, 4, 0, 166, 54, 0, 0);
instruct_50(4, 0, 2, 0, 2, 0, 0);
if CheckJumpFlag() == true then goto label0 end;
    exit();
::label0::
    SetSceneMap(52, 1, 51, 17, 4398);
    SetSceneMap(52, 1, 52, 17, 4398);
    ModifyEvent(52, 13, 0, 0, 357, 0, 0, 0, 0, 0, 0, -2, -2);
    ModifyEvent(52, 23, 1, 0, 1174, 0, 0, 7316, 7316, 7316, 0, -2, -2);
exit();
