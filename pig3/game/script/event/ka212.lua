instruct_50(5, 0, 0, 0, 0, 0, 0);
instruct_50(0, 1, 50, 0, 0, 0, 0);
instruct_50(0, 50, 1, 0, 0, 0, 0);
instruct_50(0, 33, 1, 0, 0, 0, 0);
::label4::
::label16::
instruct_50(3, 0, 2, 15, 13, 4, 0);
instruct_50(3, 0, 1, 15, 15, 468, 0);
instruct_50(4, 0, 4, 15, 0, 0, 0);
if CheckJumpFlag() == true then goto label0 end;
    instruct_50(32, 0, 15, 4, 0, 0, 0);
    instruct_50(26, 0, 0, -468, 24, 5, 0);
    instruct_50(4, 0, 0, 15, 0, 0, 0);
    if CheckJumpFlag() == true then goto label1 end;
::label0::
        instruct_50(32, 0, 15, 4, 0, 0, 0);
        instruct_50(26, 0, 0, -468, 25, 5, 0);
::label1::
        instruct_50(17, 1, 1, 5, 20, 30, 0);
        instruct_50(4, 0, 1, 30, 0, 0, 0);
        if CheckJumpFlag() == true then goto label2 end;
            instruct_50(20, 1, 5, 6, 0, 0, 0);
            instruct_50(4, 0, 2, 6, 0, 0, 0);
            if CheckJumpFlag() == true then goto label3 end;
                instruct_50(3, 0, 2, 2, 0, 30, 0);
                instruct_50(3, 0, 0, 2, 2, 1000, 0);
                instruct_50(3, 0, 3, 30, 30, 10, 0);
                instruct_50(3, 0, 2, 30, 30, 7, 0);
                instruct_50(1, 3, 0, 800, 0, 2, 0);
                instruct_50(32, 0, 2, 5, 0, 0, 0);
                instruct_50(27, 1, 1, 5, 100, 0, 0);
                instruct_50(32, 0, 2, 2, 0, 0, 0);
                instruct_50(10, 100, 3, 0, 0, 0, 0);
                instruct_50(0, 8, 19, 0, 0, 0, 0);
                instruct_50(3, 11, 1, 8, 8, 3, 0);
                instruct_50(12, 1, 180, 8, 0, 0, 0);
                instruct_50(8, 0, 716, 170, 0, 0, 0);
                instruct_50(9, 1, 15020, 170, 30, 0, 0);
                --instruct_50(0, 15019, 20729, 0, 0, 0, 0);
                setx50(15019,'價 ');
                instruct_50(10, 15020, 3, 0, 0, 0, 0);
                instruct_50(0, 8, 5, 0, 0, 0, 0);
                instruct_50(3, 11, 1, 8, 8, 3, 0);
                instruct_50(12, 1, 15030, 8, 0, 0, 0);
                instruct_50(9, 1, 15010, 170, 6, 0, 0);
                --instruct_50(0, 15009, -28209, 0, 0, 0, 0);
                setx50(15009,'量 ');
                instruct_50(11, 15000, 15019, 15030, 0, 0, 0);
                instruct_50(11, 14000, 15000, 15009, 0, 0, 0);
                instruct_50(32, 0, 2, 3, 0, 0, 0);
                instruct_50(11, 140, 0, 180, 0, 0, 0);
                instruct_50(32, 0, 2, 2, 0, 0, 0);
                instruct_50(11, 0, 140, 14000, 0, 0, 0);
                instruct_50(1, 3, 0, 200, 0, 5, 0);
                instruct_50(3, 0, 0, 0, 0, 1, 0);
::label2::
                instruct_50(3, 0, 0, 13, 13, 1, 0);
                instruct_50(4, 1, 0, 13, 1, 0, 0);
                if CheckJumpFlag() == true then goto label4 end;
::label3::
                    instruct_50(4, 0, 3, 0, 0, 0, 0);
                    if CheckJumpFlag() == true then goto label5 end;
                        Talk(90, "沒有可出售的物品。", -2, 0, 0, 0);
exit();
::label5::
                        instruct_50(4, 0, 2, 1, 200, 0, 0);
                        if CheckJumpFlag() == true then goto label6 end;
                            instruct_50(3, 0, 2, 2, 0, 30, 0);
                            instruct_50(3, 0, 0, 2, 2, 1000, 0);
                            instruct_50(1, 3, 0, 800, 0, 2, 0);
                            instruct_50(32, 0, 2, 4, 0, 0, 0);
                            instruct_50(8, 0, 717, 2000, 0, 0, 0);
                            instruct_50(3, 0, 0, 0, 0, 1, 0);
::label6::
                            instruct_50(40, 2561, 0, 800, 10, 36, 5);
                            instruct_50(4, 0, 0, 10, 1, 0, 0);
                            if CheckJumpFlag() == true then goto label7 end;
                                instruct_50(4, 0, 2, 1, 200, 0, 0);
                                if CheckJumpFlag() == true then goto label8 end;
                                    instruct_50(4, 1, 2, 10, 0, 0, 0);
                                    if JudgeSexual(257) == true then goto label9 end;
::label8::
                                        instruct_50(3, 0, 1, 10, 10, 1, 0);
                                        instruct_50(2, 11, 0, 200, 10, 28927, 0);
                                        instruct_50(43, 0, 214, 0, 0, 0, 0);
                                        instruct_50(20, 1, 28927, 6, 0, 0, 0);
                                        instruct_50(4, 1, 5, 10032, 6, 0, 0);
                                        if CheckJumpFlag() == true then goto label10 end;
                                            instruct_50(4, 0, 1, 10032, 0, 0, 0);
                                            if CheckJumpFlag() == true then goto label11 end;
                                                instruct_50(4, 0, 5, 10032, 1000, 0, 0);
                                                if CheckJumpFlag() == true then goto label12 end;
                                                    instruct_50(17, 1, 1, 28927, 20, 30, 0);
                                                    instruct_50(3, 0, 3, 30, 30, 10, 0);
                                                    instruct_50(3, 0, 2, 30, 30, 7, 0);
                                                    instruct_50(3, 1, 2, 30, 30, 10032, 0);
                                                    instruct_50(4, 0, 0, 30, 0, 0, 0);
                                                    if CheckJumpFlag() == true then goto label13 end;
                                                        instruct_50(20, 0, 0, 31, 0, 0, 0);
                                                        instruct_50(3, 1, 0, 31, 31, 30, 0);
                                                        instruct_50(4, 0, 0, 30, 0, 0, 0);
                                                        if CheckJumpFlag() == true then goto label14 end;
                                                            instruct_50(43, 4, 213, 0, 30, 0, 0);
                                                            instruct_50(43, 6, 213, 28927, 10032, 1, 1);
exit();
::label13::
::label14::
                                                            Talk(90, "身上金錢太多或出售貨品太多。", -2, 0, 0, 0);
exit();
::label11::
::label12::
                                                            Talk(90, "輸入錯誤。", -2, 0, 0, 0);
exit();
::label10::
                                                            Talk(90, "沒有那麼多物品。", -2, 0, 0, 0);
exit();
::label9::
                                                            instruct_50(3, 0, 0, 1, 1, 50, 0);
                                                            instruct_50(0, 0, 0, 0, 0, 0, 0);
::label15::
                                                            instruct_50(1, 101, 0, 800, 0, 0, 0);
                                                            instruct_50(1, 101, 0, 200, 0, 0, 0);
                                                            instruct_50(3, 0, 0, 0, 0, 1, 0);
                                                            instruct_50(4, 0, 0, 0, 50, 0, 0);
                                                            if CheckJumpFlag() == true then goto label15 end;
                                                                instruct_50(0, 0, 0, 0, 0, 0, 0);
                                                                instruct_50(0, 6, 0, 0, 0, 0, 0);
                                                                instruct_50(0, 15, 0, 0, 0, 0, 0);
                                                                instruct_50(4, 0, 2, 0, 0, 0, 0);
                                                                if CheckJumpFlag() == true then goto label16 end;
::label7::
                                                                    instruct_50(5, 0, 0, 0, 0, 0, 0);
exit();
