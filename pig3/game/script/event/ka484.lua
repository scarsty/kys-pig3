instruct_50(26, 0, 0, 22234, 5, 1001, 0);
instruct_50(26, 0, 0, 22236, 5, 1002, 0);
instruct_50(3, 0, 2, 1001, 1001, 2, 0);
instruct_50(3, 0, 2, 1002, 1002, 128, 0);
instruct_50(3, 1, 0, 1003, 1001, 1002, 0);
instruct_50(26, 1, 0, 18948, 30, 1004, 1003);
instruct_50(30, 1, 1004, 0, 1005, 0, 0);
instruct_50(4, 0, 0, 1005, 0, 0, 0);
if CheckJumpFlag() == true then goto label0 end;
    instruct_50(30, 1, 1004, 2, 1040, 0, 0);
    instruct_50(4, 0, 2, 1040, 0, 0, 0);
    if CheckJumpFlag() == true then goto label1 end;
        instruct_50(44, 1, 28005, 1, 36, 0, 0);
        instruct_50(30, 1, 28005, 0, 1000, 0, 0);
        instruct_50(17, 1, 0, 1005, 30, 1040, 0);
        instruct_50(26, 0, 0, 28374, 30, 1021, 0);
        instruct_50(3, 0, 2, 1022, 1021, 2, 0);
        instruct_50(3, 0, 0, 1022, 1022, 146, 0);
        instruct_50(17, 3, 0, 1000, 1022, 1023, 0);
        instruct_50(3, 0, 3, 1024, 1023, 100, 0);
        instruct_50(38, 0, 11, 1025, 0, 0, 0);
        instruct_50(4, 1, 0, 1024, 1025, 0, 0);
        if CheckJumpFlag() == true then goto label2 end;
            instruct_50(17, 1, 0, 1005, 166, 1007, 0);
            instruct_50(17, 1, 0, 1005, 168, 1008, 0);
            instruct_50(3, 1, 0, 1009, 1007, 1008, 0);
            instruct_50(4, 0, 0, 1009, -1, 0, 0);
            if CheckJumpFlag() == true then goto label3 end;
                instruct_50(4, 0, 0, 1007, 0, 0, 0);
                if CheckJumpFlag() == true then goto label4 end;
                    instruct_50(4, 0, 0, 1008, 0, 0, 0);
                    if CheckJumpFlag() == true then goto label5 end;
                        instruct_50(38, 0, 2, 1030, 0, 0, 0);
                        instruct_50(4, 0, 2, 1030, 1, 0, 0);
                        if CheckJumpFlag() == true then goto label6 end;
::label5::
                            instruct_50(17, 1, 0, 1005, 174, 1017, 0);
                            instruct_50(3, 0, 1, 1017, 1017, 1, 0);
                            instruct_50(16, 5, 0, 1005, 174, 1017, 0);
                            instruct_50(32, 0, 1007, 1, 0, 0, 0);
                            GetItem(0, 1);
                            instruct_50(4, 0, 5, 1017, 0, 0, 0);
                            if CheckJumpFlag() == true then goto label7 end;
                                instruct_50(16, 1, 0, 1005, 166, -1, 0);
                                instruct_50(4, 0, 6, 1007, 0, 0, 0);
                                if CheckJumpFlag() == true then goto label8 end;
::label4::
::label6::
                                    instruct_50(17, 1, 0, 1005, 176, 1018, 0);
                                    instruct_50(3, 0, 1, 1018, 1018, 1, 0);
                                    instruct_50(16, 5, 0, 1005, 176, 1018, 0);
                                    instruct_50(32, 0, 1008, 1, 0, 0, 0);
                                    GetItem(0, 1);
                                    instruct_50(4, 0, 5, 1018, 0, 0, 0);
                                    if CheckJumpFlag() == true then goto label9 end;
                                        instruct_50(16, 1, 0, 1005, 168, -1, 0);
::label2::
::label3::
::label7::
::label8::
::label9::
                                        instruct_50(47, 1, 28005, 0, 0, 0, 0);
::label0::
::label1::
exit();
