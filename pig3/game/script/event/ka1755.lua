instruct_50(17, 0, 0, 166, 108, 1, 0);
instruct_50(17, 0, 0, 166, 110, 2, 0);
instruct_50(17, 0, 0, 166, 112, 3, 0);
instruct_50(4, 1, 5, 1, 2, 0, 0);
if CheckJumpFlag() == true then goto label0 end;
    instruct_50(4, 1, 5, 2, 3, 0, 0);
    if CheckJumpFlag() == true then goto label1 end;
        instruct_50(4, 0, 5, 3, 25, 0, 0);
        if CheckJumpFlag() == true then goto label2 end;
            instruct_50(16, 0, 0, 166, 118, 0, 0);
            exit();
::label2::
            instruct_50(16, 0, 0, 166, 118, 3, 0);
            exit();
::label1::
            instruct_50(4, 0, 5, 2, 25, 0, 0);
            if CheckJumpFlag() == true then goto label3 end;
                instruct_50(16, 0, 0, 166, 118, 0, 0);
                exit();
::label3::
                instruct_50(16, 0, 0, 166, 118, 2, 0);
                exit();
::label0::
                instruct_50(4, 1, 5, 1, 3, 0, 0);
                if CheckJumpFlag() == true then goto label4 end;
                    instruct_50(4, 0, 5, 3, 25, 0, 0);
                    if CheckJumpFlag() == true then goto label5 end;
                        instruct_50(16, 0, 0, 166, 118, 0, 0);
                        exit();
::label5::
                        instruct_50(16, 0, 0, 166, 118, 3, 0);
                        exit();
::label4::
                        instruct_50(4, 0, 5, 1, 25, 0, 0);
                        if CheckJumpFlag() == true then goto label6 end;
                            instruct_50(16, 0, 0, 166, 118, 0, 0);
                            exit();
::label6::
                            instruct_50(16, 0, 0, 166, 118, 1, 0);
exit();
