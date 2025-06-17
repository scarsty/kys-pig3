instruct_50(25, 1, 0, 2980, 28, 28928, 0);
instruct_50(25, 1, 0, 2976, 28, 28929, 0);
instruct_50(4, 0, 2, 28930, 0, 0, 0);
if CheckJumpFlag() == false then goto label0 end;
    instruct_50(3, 0, 1, 28929, 28929, 1, 0);
::label0::
    instruct_50(4, 0, 2, 28930, 1, 0, 0);
    if CheckJumpFlag() == false then goto label1 end;
        instruct_50(3, 0, 0, 28928, 28928, 1, 0);
::label1::
        instruct_50(4, 0, 2, 28930, 2, 0, 0);
        if CheckJumpFlag() == false then goto label2 end;
            instruct_50(3, 0, 0, 28929, 28929, 1, 0);
::label2::
            instruct_50(4, 0, 2, 28930, 3, 0, 0);
            if CheckJumpFlag() == false then goto label3 end;
                instruct_50(3, 0, 1, 28928, 28928, 1, 0);
::label3::
                instruct_50(25, 1, 0, 2982, 28, 28928, 0);
                instruct_50(25, 1, 0, 2978, 28, 28929, 0);
                instruct_50(4, 0, 2, 28930, -2, 0, 0);
                if CheckJumpFlag() == true then goto label4 end;
                    instruct_50(25, 1, 0, 17678, 5, 28930, 0);
                    instruct_50(3, 0, 2, 28931, 28930, 8, 0);
                    instruct_50(3, 0, 0, 28931, 28931, 7430, 0);
                    instruct_50(25, 1, 0, 3050, 28, 28931, 0);
::label4::
exit();
