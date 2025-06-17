instruct_50(8, 1, 28928, 10000, 0, 0, 0);
instruct_50(3, 0, 1, 9001, 28929, 1, 0);
instruct_50(0, 9000, -1, 0, 0, 0, 0);
instruct_50(3, 0, 0, 9002, 28928, 0, 0);
instruct_50(0, 9003, 10000, 0, 0, 0, 0);
::label1::
instruct_50(3, 0, 0, 9000, 9000, 1, 0);
instruct_50(4, 1, 5, 9000, 9001, 0, 0);
if CheckJumpFlag() == true then goto label0 end;
    instruct_50(3, 0, 0, 9002, 9002, 1, 0);
    instruct_50(3, 0, 0, 9003, 9003, 100, 0);
    instruct_50(1, 3, 0, 15000, 9000, 9003, 0);
    instruct_50(32, 0, 9003, 4, 0, 0, 0);
    instruct_50(8, 1, 9002, 9003, 0, 0, 0);
    instruct_50(4, 0, 6, 0, 0, 0, 0);
    if CheckJumpFlag() == true then goto label1 end;
::label0::
        instruct_50(10, 10000, 9999, 0, 0, 0, 0);
        instruct_50(3, 0, 2, 9999, 9999, 10, 0);
        instruct_50(3, 0, 0, 9999, 9999, 10, 0);
        instruct_50(34, 4, 12, 15, 9999, 30, 0);
        instruct_50(33, 0, 10000, 19, 22, 1797, 0);
        instruct_50(35, 9006, 0, 0, 0, 0, 0);
        instruct_50(37, 0, 100, 0, 0, 0, 0);
        instruct_50(40, 2049, 28929, 15000, 28931, 12, 50);
exit();
