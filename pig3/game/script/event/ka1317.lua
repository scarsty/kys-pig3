instruct_50(17, 0, 0, 166, 66, 0, 0);
instruct_50(3, 0, 0, 0, 0, 1, 0);
instruct_50(16, 4, 0, 166, 66, 0, 0);
instruct_50(4, 0, 2, 0, 4, 0, 0);
if CheckJumpFlag() == true then goto label0 end;
    exit();
::label0::
    instruct_50(43, 0, 244, 34, 1, 0, 0);
    instruct_50(17, 0, 0, 166, 62, 0, 0);
    instruct_50(4, 0, 3, 0, 1, 0, 0);
    if CheckJumpFlag() == true then goto label1 end;
        ModifyEvent(102, 0, 1, 0, 1328, 0, 0, 6368, 6368, 6368, 0, -2, -2);
        ModifyEvent(102, 5, 1, 0, 1333, 0, 0, 6360, 6360, 6360, 0, -2, -2);
        ModifyEvent(102, 6, 1, 0, 1333, 0, 0, 6362, 6362, 6362, 0, -2, -2);
        ModifyEvent(102, 7, 1, 0, 1333, 0, 0, 6364, 6364, 6364, 0, -2, -2);
        exit();
::label1::
        ModifyEvent(102, 0, 1, 0, 1316, 0, 0, 6368, 6368, 6368, 0, -2, -2);
        ModifyEvent(102, 5, 1, 0, 1335, 0, 0, 6360, 6360, 6360, 0, -2, -2);
        ModifyEvent(102, 6, 1, 0, 1335, 0, 0, 6362, 6362, 6362, 0, -2, -2);
        ModifyEvent(102, 7, 1, 0, 1335, 0, 0, 6364, 6364, 6364, 0, -2, -2);
exit();
