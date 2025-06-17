instruct_50(43, 0, 221, 0, 0, 0, 0);
instruct_50(26, 0, 0, 10590, 29, 100, 0);
instruct_50(0, 0, 0, 0, 0, 0, 0);
instruct_50(0, 1, 0, 0, 0, 0, 0);
::label2::
instruct_50(2, 1, 0, 200, 0, 101, 0);
instruct_50(4, 1, 2, 101, 100, 0, 0);
if CheckJumpFlag() == true then goto label0 end;
    instruct_50(22, 1, 101, 199, 2, 102, 0);
    instruct_50(4, 0, 2, 102, 1, 0, 0);
    if CheckJumpFlag() == true then goto label1 end;
        instruct_50(1, 3, 0, 500, 1, 101, 0);
        instruct_50(2, 1, 0, 300, 0, 103, 0);
        instruct_50(1, 3, 0, 600, 1, 103, 0);
        instruct_50(2, 1, 0, 400, 0, 104, 0);
        instruct_50(1, 3, 0, 700, 1, 104, 0);
        instruct_50(3, 0, 2, 105, 1, 20, 0);
        instruct_50(3, 0, 0, 105, 105, 1000, 0);
        instruct_50(32, 0, 105, 5, 0, 0, 0);
        instruct_50(27, 1, 2, 101, 1000, 0, 0);
        instruct_50(1, 3, 0, 800, 1, 105, 0);
        instruct_50(3, 0, 0, 1, 1, 1, 0);
::label0::
::label1::
        instruct_50(3, 0, 0, 0, 0, 1, 0);
        instruct_50(4, 0, 0, 0, 9, 0, 0);
        if CheckJumpFlag() == true then goto label2 end;
            instruct_50(4, 0, 0, 1, 1, 0, 0);
            if CheckJumpFlag() == true then goto label3 end;
                instruct_50(40, 2561, 1, 800, 10, 50, 5);
                instruct_50(4, 0, 1, 10, 0, 0, 0);
                if CheckJumpFlag() == true then goto label4 end;
                    instruct_50(3, 0, 1, 10, 10, 1, 0);
                    instruct_50(2, 1, 0, 500, 10, 101, 0);
                    instruct_50(2, 1, 0, 600, 10, 103, 0);
                    instruct_50(2, 1, 0, 700, 10, 104, 0);
                    instruct_50(43, 14, 220, 101, 103, 104, 0);
::label3::
::label4::
exit();
