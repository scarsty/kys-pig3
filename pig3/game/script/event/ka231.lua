instruct_50(0, 9000, 124, 0, 0, 0, 0);
instruct_50(3, 0, 0, 9001, 28928, 0, 0);
instruct_50(3, 0, 0, 9002, 28929, 0, 0);
instruct_50(3, 0, 1, 9003, 28930, 1, 0);
instruct_50(3, 0, 2, 9003, 9003, 100, 0);
::label1::
instruct_50(3, 0, 0, 9000, 9000, 2, 0);
instruct_50(17, 3, 0, 9001, 9000, 9005, 0);
instruct_50(4, 0, 2, 9005, 0, 0, 0);
if CheckJumpFlag() == true then goto label0 end;
    instruct_50(4, 0, 0, 9000, 144, 0, 0);
    if CheckJumpFlag() == true then goto label1 end;
        exit();
::label0::
        instruct_50(16, 7, 0, 9001, 9000, 9002, 0);
        instruct_50(3, 0, 0, 9000, 9000, 20, 0);
        instruct_50(16, 7, 0, 9001, 9000, 9003, 0);
exit();
