instruct_50(30, 1, 28005, 0, 1000, 0, 0);
instruct_50(26, 0, 0, 28374, 30, 1001, 0);
instruct_50(3, 0, 2, 1002, 1001, 2, 0);
instruct_50(3, 0, 0, 1002, 1002, 146, 0);
instruct_50(17, 3, 0, 1000, 1002, 1003, 0);
instruct_50(3, 0, 3, 1004, 1003, 100, 0);
instruct_50(1, 0, 0, 1100, 0, 10, 0);
instruct_50(1, 0, 0, 1100, 1, 15, 0);
instruct_50(1, 0, 0, 1100, 2, 20, 0);
instruct_50(1, 0, 0, 1100, 3, 25, 0);
instruct_50(1, 0, 0, 1100, 4, 30, 0);
instruct_50(1, 0, 0, 1100, 5, 35, 0);
instruct_50(1, 0, 0, 1100, 6, 40, 0);
instruct_50(1, 0, 0, 1100, 7, 45, 0);
instruct_50(1, 0, 0, 1100, 8, 45, 0);
instruct_50(1, 0, 0, 1100, 9, 50, 0);
instruct_50(2, 1, 0, 1100, 1004, 1007, 0);
instruct_50(46, 0, 0, 0, 64, 64, 1);
instruct_50(44, 0, 28005, 1, 0, 0, 0);
instruct_50(0, 1020, -1, 0, 0, 0, 0);
::label1::
::label3::
::label4::
::label8::
instruct_50(3, 0, 0, 1020, 1020, 1, 0);
instruct_50(4, 0, 2, 1020, 26, 0, 0);
if CheckJumpFlag() == true then goto label0 end;
    instruct_50(30, 1, 1020, 0, 1030, 0, 0);
    instruct_50(4, 0, 0, 1030, 0, 0, 0);
    if CheckJumpFlag() == true then goto label1 end;
        instruct_50(30, 1, 1020, 2, 1021, 0, 0);
        instruct_50(4, 0, 2, 1021, 0, 0, 0);
        if CheckJumpFlag() == true then goto label2 end;
            instruct_50(30, 1, 1020, 4, 1022, 0, 0);
            instruct_50(30, 1, 1020, 6, 1023, 0, 0);
            instruct_50(3, 0, 2, 1024, 1022, 2, 0);
            instruct_50(3, 0, 2, 1025, 1023, 128, 0);
            instruct_50(3, 1, 0, 1026, 1024, 1025, 0);
            instruct_50(25, 2, 0, -5628, 29, 0, 1026);
            instruct_50(4, 0, 6, 1021, 0, 0, 0);
            if CheckJumpFlag() == true then goto label3 end;
::label2::
                instruct_50(30, 1, 1020, 10, 1031, 0, 0);
                instruct_50(4, 0, 0, 1031, 0, 0, 0);
                if CheckJumpFlag() == true then goto label4 end;
                    instruct_50(17, 1, 0, 1030, 34, 1005, 0);
                    instruct_50(17, 1, 0, 1030, 36, 1006, 0);
                    instruct_50(16, 1, 0, 1030, 38, 0, 0);
                    instruct_50(4, 0, 4, 1006, 300, 0, 0);
                    if CheckJumpFlag() == true then goto label5 end;
                        instruct_50(3, 1, 2, 1008, 1006, 1007, 0);
                        instruct_50(3, 0, 3, 1008, 1008, 100, 0);
                        instruct_50(4, 0, 6, 1006, 300, 0, 0);
                        if CheckJumpFlag() == true then goto label6 end;
::label5::
                            instruct_50(3, 0, 3, 1008, 1006, 100, 0);
                            instruct_50(3, 1, 2, 1008, 1008, 1007, 0);
::label6::
                            instruct_50(3, 1, 0, 1009, 1008, 1005, 0);
                            instruct_50(4, 1, 1, 1009, 1006, 0, 0);
                            if CheckJumpFlag() == true then goto label7 end;
                                instruct_50(3, 0, 0, 1009, 1006, 0, 0);
                                instruct_50(3, 1, 1, 1008, 1006, 1005, 0);
::label7::
                                instruct_50(16, 5, 0, 1030, 34, 1009, 0);
                                instruct_50(31, 5, 1020, 18, 1008, 0, 0);
                                instruct_50(4, 1, 6, 1009, 1006, 0, 0);
                                if CheckJumpFlag() == true then goto label8 end;
::label0::
                                    instruct_50(45, 0, 4, 0, 0, 0, 0);
                                    instruct_50(47, 1, 28005, 0, 0, 0, 0);
exit();
