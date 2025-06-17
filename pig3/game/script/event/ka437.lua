instruct_50(3, 0, 3, 10, 28928, 100, 0);
instruct_50(38, 0, 10, 12, 0, 0, 0);
instruct_50(4, 1, 4, 12, 10, 0, 0);
if CheckJumpFlag() == true then goto label0 end;
    instruct_50(3, 0, 0, 11, 28004, 0, 0);
    instruct_50(0, 28004, 0, 0, 0, 0, 0);
    instruct_50(17, 1, 0, 28003, 82, 13, 0);
    instruct_50(3, 1, 1, 13, 13, 11, 0);
    instruct_50(4, 0, 5, 13, 0, 0, 0);
    if CheckJumpFlag() == true then goto label1 end;
        instruct_50(0, 13, 0, 0, 0, 0, 0);
::label1::
        instruct_50(16, 5, 0, 28003, 82, 13, 0);
::label0::
exit();
