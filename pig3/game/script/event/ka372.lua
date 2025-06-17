instruct_50(38, 0, 5, 107, 0, 0, 0);
instruct_50(4, 0, 2, 107, 4, 0, 0);
if CheckJumpFlag() == false then goto label0 end;
    instruct_50(5, 0, 0, 0, 0, 0, 0);
    instruct_50(26, 0, 0, 17650, 5, 100, 0);
    instruct_50(26, 0, 0, 10590, 29, 101, 0);
    instruct_50(26, 0, 0, 10588, 29, 102, 0);
    instruct_50(26, 0, 0, 10586, 29, 103, 0);
    instruct_50(4, 0, 2, 100, 0, 0, 0);
    if CheckJumpFlag() == false then goto label1 end;
        instruct_50(3, 0, 1, 103, 103, 1, 0);
::label1::
        instruct_50(4, 0, 2, 100, 1, 0, 0);
        if CheckJumpFlag() == false then goto label2 end;
            instruct_50(3, 0, 0, 102, 102, 1, 0);
::label2::
            instruct_50(4, 0, 2, 100, 2, 0, 0);
            if CheckJumpFlag() == false then goto label3 end;
                instruct_50(3, 0, 1, 102, 102, 1, 0);
::label3::
                instruct_50(4, 0, 2, 100, 3, 0, 0);
                if CheckJumpFlag() == false then goto label4 end;
                    instruct_50(3, 0, 0, 103, 103, 1, 0);
::label4::
                    instruct_50(24, 13, 101, 3, 102, 103, 104);
                    instruct_50(22, 3, 101, 104, 8, 105, 0);
                    instruct_50(4, 0, 2, 105, 0, 0, 0);
                    if CheckJumpFlag() == false then goto label5 end;
                        instruct_50(38, 0, 300, 107, 0, 0, 0);
                        instruct_50(3, 0, 0, 107, 107, 1, 0);
                        instruct_50(21, 11, 101, 104, 8, 107, 0);
                        instruct_50(22, 3, 101, 104, 1, 106, 0);
                        instruct_50(3, 0, 1, 106, 106, 100, 0);
                        instruct_50(3, 0, 0, 106, 106, 13326, 0);
                        instruct_50(32, 0, 106, 3, 0, 0, 0);
                        instruct_50(8, 0, 13326, 1000, 0, 0, 0);
                        instruct_50(9, 1, 2000, 1000, 107, 0, 0);
                        instruct_50(0, 0, 0, 0, 0, 0, 0);
                        Talk(102, -2000, "乞丐", 0, 1, 0);
                        instruct_50(0, 0, 2000, 75, 327, 28771, 0);
                        instruct_50(35, 0, 0, 0, 0, 0, 0);
::label0::
::label5::
exit();
