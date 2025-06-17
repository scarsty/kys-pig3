::label4::
::label6::
::label7::
instruct_50(1, 0, 0, 500, 0, 100, 0);
instruct_50(1, 0, 0, 500, 1, 120, 0);
instruct_50(1, 0, 0, 500, 2, 140, 0);
instruct_50(1, 0, 0, 500, 3, 160, 0);
instruct_50(1, 0, 0, 500, 4, 180, 0);
instruct_50(1, 0, 0, 500, 5, 200, 0);
instruct_50(0, 3, 100, 0, 0, 0, 0);
instruct_50(0, 5, 10, 0, 0, 0, 0);
instruct_50(0, 1, 0, 0, 0, 0, 0);
instruct_50(8, 0, 224, 10, 0, 0, 0);
::label1::
instruct_50(19, 1, 1, 0, 0, 0, 0);
instruct_50(4, 0, 2, 0, -1, 0, 0);
if CheckJumpFlag() == true then goto label0 end;
    instruct_50(17, 1, 0, 0, 38, 2, 0);
    instruct_50(32, 0, 3, 5, 0, 0, 0);
    instruct_50(27, 1, 0, 0, 100, 0, 0);
    instruct_50(32, 0, 3, 2, 0, 0, 0);
    instruct_50(10, 100, 4, 0, 0, 0, 0);
    instruct_50(3, 1, 1, 4, 5, 4, 0);
    instruct_50(12, 1, 50, 4, 0, 0, 0);
    instruct_50(32, 0, 3, 3, 0, 0, 0);
    instruct_50(11, 60, 100, 50, 0, 0, 0);
    instruct_50(9, 1, 50, 10, 2, 0, 0);
    instruct_50(11, 60, 60, 50, 0, 0, 0);
    instruct_50(32, 0, 3, 3, 0, 0, 0);
    instruct_50(9, 0, 100, 60, 0, 0, 0);
    instruct_50(3, 0, 0, 1, 1, 1, 0);
    instruct_50(3, 0, 0, 3, 3, 20, 0);
    instruct_50(4, 0, 0, 1, 6, 0, 0);
    if CheckJumpFlag() == true then goto label1 end;
::label0::
        instruct_50(39, 1, 1, 500, 300, 30, 30);
        instruct_50(4, 0, 2, 300, 0, 0, 0);
        if CheckJumpFlag() == false then goto label2 end;
exit();
::label2::
            instruct_50(3, 0, 1, 300, 300, 1, 0);
            instruct_50(19, 1, 300, 3, 0, 0, 0);
            instruct_50(17, 1, 0, 3, 38, 2, 0);
            instruct_50(4, 0, 2, 2, 0, 0, 0);
            if CheckJumpFlag() == false then goto label3 end;
                Talk(75, "沒傷還找老子來治，消遣老子不成？", -2, 0, 0, 0);
                instruct_50(4, 0, 6, 0, 0, 0, 0);
                if CheckJumpFlag() == true then goto label4 end;
exit();
::label3::
                    instruct_50(20, 0, 0, 1, 0, 0, 0);
                    instruct_50(4, 1, 5, 2, 1, 0, 0);
                    if CheckJumpFlag() == true then goto label5 end;
                        instruct_50(16, 1, 0, 3, 38, 0, 0);
                        instruct_50(0, 0, 0, 0, 0, 0, 0);
                        instruct_50(3, 1, 1, 2, 0, 2, 0);
                        instruct_50(32, 0, 2, 2, 0, 0, 0);
                        GetItem(0, 0);
                        instruct_50(4, 0, 6, 0, 0, 0, 0);
                        if CheckJumpFlag() == true then goto label6 end;
exit();
::label5::
                            Talk(75, "雖然我們很熟，但醫療費還是不能少的。", -2, 0, 0, 0);
                            instruct_50(4, 0, 6, 0, 0, 0, 0);
                            if CheckJumpFlag() == true then goto label7 end;
exit();
