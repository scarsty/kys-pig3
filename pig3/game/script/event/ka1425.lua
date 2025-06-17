instruct_50(17, 0, 0, 166, 90, 0, 0);
instruct_50(3, 0, 0, 0, 0, 1, 0);
instruct_50(16, 4, 0, 166, 90, 0, 0);
instruct_50(4, 0, 2, 0, 3, 0, 0);
if CheckJumpFlag() == true then goto label0 end;
    exit();
::label0::
    ModifyEvent(125, 2, 0, 0, 0, 0, 0, 0, 0, 0, 0, -2, -2);
    ModifyEvent(125, 3, 0, 0, 0, 0, 0, 0, 0, 0, 0, -2, -2);
    ModifyEvent(125, 19, 1, 0, 1482, 0, 0, 5134, 5134, 5134, 0, -2, -2);
    ModifyEvent(125, 22, 1, 0, 1482, 0, 0, 5138, 5138, 5138, 0, -2, -2);
exit();
