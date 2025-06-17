instruct_50(0, 9000, 124, 0, 0, 0, 0);
instruct_50(3, 0, 0, 9001, 28928, 0, 0);
instruct_50(3, 0, 0, 9002, 28929, 0, 0);
::label1::
instruct_50(3, 0, 0, 9000, 9000, 2, 0);
instruct_50(17, 3, 0, 9001, 9000, 9005, 0);
instruct_50(4, 1, 2, 9005, 9002, 0, 0);
if CheckJumpFlag() == true then goto label0 end;
    instruct_50(4, 0, 0, 9000, 144, 0, 0);
    if CheckJumpFlag() == true then goto label1 end;
        exit();
::label0::
::label3::
        instruct_50(3, 0, 0, 9006, 9000, 2, 0);
        instruct_50(4, 0, 2, 9006, 146, 0, 0);
        if CheckJumpFlag() == true then goto label2 end;
            instruct_50(17, 3, 0, 9001, 9006, 9005, 0);
            instruct_50(16, 7, 0, 9001, 9000, 9005, 0);
            instruct_50(3, 0, 0, 9007, 9000, 20, 0);
            instruct_50(3, 0, 0, 9008, 9006, 20, 0);
            instruct_50(17, 3, 0, 9001, 9008, 9005, 0);
            instruct_50(16, 7, 0, 9001, 9007, 9005, 0);
            instruct_50(3, 0, 0, 9000, 9000, 2, 0);
            instruct_50(4, 0, 0, 9000, 144, 0, 0);
            if CheckJumpFlag() == true then goto label3 end;
::label2::
                instruct_50(16, 3, 0, 9001, 9000, 0, 0);
                instruct_50(3, 0, 0, 9007, 9000, 20, 0);
                instruct_50(16, 3, 0, 9001, 9007, 0, 0);
exit();
