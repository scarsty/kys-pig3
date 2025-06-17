Talk(83, "我們青竹幫的兄弟，遍佈中原各地，少俠想去哪裡，馬上給你送到！", -2, 1, 0, 0);
instruct_50(43, 0, 351, 6025, 8, 0, 0);
instruct_50(4, 0, 3, 28931, 1, 0, 0);
if CheckJumpFlag() == true then goto label0 end;
    SetRoleFace(2);
    instruct_50(42, 0, 326, 290, 0, 0, 0);
    JumpScene(15, 50, 27);
    instruct_50(43, 0, 1664, 0, 0, 0, 0);
    exit();
::label0::
    instruct_50(4, 0, 3, 28931, 2, 0, 0);
    if CheckJumpFlag() == true then goto label1 end;
        SetRoleFace(2);
        instruct_50(42, 0, 312, 205, 0, 0, 0);
        JumpScene(13, 49, 35);
        instruct_50(43, 0, 1664, 0, 0, 0, 0);
        exit();
::label1::
        instruct_50(4, 0, 3, 28931, 3, 0, 0);
        if CheckJumpFlag() == true then goto label2 end;
            SetRoleFace(0);
            instruct_50(42, 0, 335, 180, 0, 0, 0);
            JumpScene(19, 26, 45);
            instruct_50(43, 0, 1664, 0, 0, 0, 0);
            exit();
::label2::
            instruct_50(4, 0, 3, 28931, 4, 0, 0);
            if CheckJumpFlag() == true then goto label3 end;
                SetRoleFace(0);
                instruct_50(42, 0, 359, 230, 0, 0, 0);
                JumpScene(14, 26, 50);
                instruct_50(43, 0, 1664, 0, 0, 0, 0);
                exit();
::label3::
                instruct_50(4, 0, 3, 28931, 5, 0, 0);
                if CheckJumpFlag() == true then goto label4 end;
                    SetRoleFace(2);
                    instruct_50(42, 0, 296, 318, 0, 0, 0);
                    JumpScene(30, 54, 29);
                    exit();
::label4::
                    instruct_50(4, 0, 3, 28931, 6, 0, 0);
                    if CheckJumpFlag() == true then goto label5 end;
                        SetRoleFace(0);
                        instruct_50(42, 0, 246, 226, 0, 0, 0);
                        JumpScene(68, 42, 49);
                        instruct_50(43, 0, 1663, 0, 0, 0, 0);
                        exit();
::label5::
                        instruct_50(4, 0, 3, 28931, 7, 0, 0);
                        if CheckJumpFlag() == true then goto label6 end;
                            SetRoleFace(0);
                            instruct_50(42, 0, 140, 234, 0, 0, 0);
                            JumpScene(73, 31, 52);
                            instruct_50(43, 0, 1663, 0, 0, 0, 0);
                            exit();
::label6::
                            instruct_50(4, 0, 3, 28931, 8, 0, 0);
                            if CheckJumpFlag() == true then goto label7 end;
                                SetRoleFace(2);
                                instruct_50(42, 0, 213, 266, 0, 0, 0);
                                JumpScene(108, 48, 31);
                                instruct_50(43, 0, 1663, 0, 0, 0, 0);
                                exit();
::label7::
exit();
