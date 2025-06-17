instruct_50(6, 99, 27750, 28527, 114, 0, 0);
instruct_50(6, 100, 27746, 28257, 107, 0, 0);
instruct_50(6, 101, 28520, 25964, 0, 0, 0);
instruct_50(6, 102, 28519, 25708, 0, 0, 0);
instruct_50(6, 103, 28525, 25966, 121, 0, 0);
instruct_50(6, 104, 28514, 28015, 0, 0, 0);
instruct_50(2, 3, 0, 300, 118, 123, 0);
instruct_50(2, 3, 0, 400, 118, 124, 0);
instruct_50(4, 1, 3, 124, 100, 0, 0);
if CheckJumpFlag() == false then goto label0 end;
exit();
::label0::
    instruct_50(3, 0, 1, 125, 125, 1, 0);
    instruct_50(4, 1, 2, 123, 100, 0, 0);
    if CheckJumpFlag() == false then goto label1 end;
        instruct_50(3, 0, 0, 123, 101, 0, 0);
::label1::
        instruct_50(4, 1, 2, 123, 102, 0, 0);
        if CheckJumpFlag() == false then goto label2 end;
            instruct_50(3, 0, 0, 126, 126, 1, 0);
::label2::
            instruct_50(4, 1, 2, 123, 103, 0, 0);
            if CheckJumpFlag() == false then goto label3 end;
                instruct_50(38, 0, 40, 127, 0, 0, 0);
                instruct_50(3, 0, 0, 127, 127, 40, 0);
                instruct_50(32, 0, 127, 2, 0, 0, 0);
                GetItem(0, 1);
::label3::
                instruct_50(4, 1, 2, 123, 104, 0, 0);
                if CheckJumpFlag() == false then goto label4 end;
                    instruct_50(3, 0, 1, 125, 125, 1, 0);
::label4::
                    instruct_50(1, 3, 0, 400, 118, 123, 0);
                    instruct_50(34, 0, 0, 0, 200, 200, 0);
                    instruct_50(34, 0, 200, 0, 120, 200, 0);
exit();
