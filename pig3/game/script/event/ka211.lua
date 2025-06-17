instruct_50(5, 0, 0, 0, 0, 0, 0);
instruct_50(1, 0, 0, 500, 0, 100, 0);
instruct_50(1, 0, 0, 500, 1, 1100, 0);
instruct_50(8, 0, 715, 100, 0, 0, 0);
instruct_50(8, 0, 714, 1100, 0, 0, 0);
instruct_50(0, 20, 2, 0, 0, 0, 0);
instruct_50(3, 0, 2, 21, 20, 18, 0);
instruct_50(3, 0, 0, 21, 21, 10, 0);
instruct_50(39, 1, 20, 500, 10, 105, 90);
instruct_50(4, 0, 0, 10, 1, 0, 0);
if CheckJumpFlag() == true then goto label0 end;
    instruct_50(4, 0, 2, 10, 1, 0, 0);
    if CheckJumpFlag() == false then goto label1 end;
        instruct_50(5, 0, 0, 0, 0, 0, 0);
        instruct_50(0, 1, 50, 0, 0, 0, 0);
        instruct_50(0, 50, 1, 0, 0, 0, 0);
        instruct_50(0, 33, 1, 0, 0, 0, 0);
::label5::
::label15::
        instruct_50(3, 0, 2, 15, 13, 4, 0);
        instruct_50(3, 0, 1, 15, 15, 468, 0);
        instruct_50(4, 0, 4, 15, 0, 0, 0);
        if CheckJumpFlag() == true then goto label2 end;
            instruct_50(32, 0, 15, 4, 0, 0, 0);
            instruct_50(26, 0, 0, -468, 24, 5, 0);
            instruct_50(4, 0, 0, 15, 0, 0, 0);
            if CheckJumpFlag() == true then goto label3 end;
::label2::
                instruct_50(32, 0, 15, 4, 0, 0, 0);
                instruct_50(26, 0, 0, -468, 25, 5, 0);
::label3::
                instruct_50(20, 1, 5, 6, 0, 0, 0);
                instruct_50(4, 0, 2, 6, 0, 0, 0);
                if CheckJumpFlag() == true then goto label4 end;
                    instruct_50(3, 0, 2, 2, 0, 30, 0);
                    instruct_50(3, 0, 0, 2, 2, 1000, 0);
                    instruct_50(1, 3, 0, 800, 0, 2, 0);
                    instruct_50(32, 0, 2, 5, 0, 0, 0);
                    instruct_50(27, 1, 1, 5, 100, 0, 0);
                    instruct_50(32, 0, 2, 2, 0, 0, 0);
                    instruct_50(10, 100, 3, 0, 0, 0, 0);
                    instruct_50(0, 8, 21, 0, 0, 0, 0);
                    instruct_50(3, 11, 1, 8, 8, 3, 0);
                    instruct_50(12, 1, 180, 8, 0, 0, 0);
                    instruct_50(8, 0, 716, 170, 0, 0, 0);
                    instruct_50(9, 1, 165, 170, 6, 0, 0);
                    instruct_50(32, 0, 2, 3, 0, 0, 0);
                    instruct_50(11, 140, 0, 180, 0, 0, 0);
                    instruct_50(32, 0, 2, 2, 0, 0, 0);
                    instruct_50(11, 0, 140, 165, 0, 0, 0);
                    instruct_50(1, 3, 0, 200, 0, 5, 0);
                    instruct_50(3, 0, 0, 0, 0, 1, 0);
                    instruct_50(3, 0, 0, 13, 13, 1, 0);
                    instruct_50(4, 1, 0, 13, 1, 0, 0);
                    if CheckJumpFlag() == true then goto label5 end;
::label4::
                        instruct_50(4, 0, 3, 0, 0, 0, 0);
                        if CheckJumpFlag() == true then goto label6 end;
                            Talk("沒有可儲存的物品", 0, 2);
exit();
::label6::
                            instruct_50(4, 0, 2, 1, 200, 0, 0);
                            if CheckJumpFlag() == true then goto label7 end;
                                instruct_50(3, 0, 2, 2, 0, 30, 0);
                                instruct_50(3, 0, 0, 2, 2, 1000, 0);
                                instruct_50(1, 3, 0, 800, 0, 2, 0);
                                instruct_50(32, 0, 2, 4, 0, 0, 0);
                                instruct_50(8, 0, 717, 2000, 0, 0, 0);
                                instruct_50(3, 0, 0, 0, 0, 1, 0);
::label7::
                                instruct_50(3, 0, 1, 9, 0, 0, 0);
                                instruct_50(3, 0, 2, 9, 9, 18, 0);
                                instruct_50(3, 0, 0, 9, 9, 10, 0);
                                instruct_50(40, 2561, 0, 800, 10, 54, 5);
                                instruct_50(4, 0, 0, 10, 1, 0, 0);
                                if CheckJumpFlag() == true then goto label8 end;
                                    instruct_50(4, 0, 2, 1, 200, 0, 0);
                                    if CheckJumpFlag() == true then goto label9 end;
                                        instruct_50(4, 1, 2, 10, 0, 0, 0);
                                        if JudgeSexual(257) == true then goto label10 end;
::label9::
                                            instruct_50(3, 0, 1, 10, 10, 1, 0);
                                            instruct_50(2, 11, 0, 200, 10, 11, 0);
                                            instruct_50(43, 0, 214, 0, 0, 0, 0);
                                            instruct_50(4, 0, 5, 10032, 0, 0, 0);
                                            if CheckJumpFlag() == false then goto label11 end;
                                                instruct_50(4, 0, 1, 10032, 5000, 0, 0);
                                                if CheckJumpFlag() == false then goto label12 end;
                                                    instruct_50(20, 1, 11, 32, 0, 0, 0);
                                                    instruct_50(4, 1, 0, 32, 10032, 0, 0);
                                                    if CheckJumpFlag() == true then goto label13 end;
                                                        instruct_50(17, 1, 1, 11, 86, 32, 0);
                                                        instruct_50(3, 1, 0, 32, 32, 10032, 0);
                                                        instruct_50(16, 5, 1, 11, 86, 32, 0);
                                                        instruct_50(43, 6, 213, 11, 10032, 1, 1);
                                                        Talk("儲存成功。", 0, 2);
exit();
::label11::
::label12::
                                                        Talk("輸入錯誤。", 0, 2);
exit();
::label13::
                                                        Talk("沒有那麼多物品。", 0, 2);
exit();
::label10::
                                                        instruct_50(3, 0, 0, 1, 1, 50, 0);
                                                        instruct_50(0, 0, 0, 0, 0, 0, 0);
::label14::
                                                        instruct_50(1, 101, 0, 800, 0, 0, 0);
                                                        instruct_50(1, 101, 0, 200, 0, 0, 0);
                                                        instruct_50(3, 0, 0, 0, 0, 1, 0);
                                                        instruct_50(4, 0, 0, 0, 50, 0, 0);
                                                        if CheckJumpFlag() == true then goto label14 end;
                                                            instruct_50(0, 0, 0, 0, 0, 0, 0);
                                                            instruct_50(0, 6, 0, 0, 0, 0, 0);
                                                            instruct_50(0, 15, 0, 0, 0, 0, 0);
                                                            instruct_50(4, 0, 2, 0, 0, 0, 0);
                                                            if CheckJumpFlag() == true then goto label15 end;
::label8::
exit();
::label1::
                                                                instruct_50(5, 0, 0, 0, 0, 0, 0);
                                                                instruct_50(0, 0, 50, 0, 0, 0, 0);
                                                                instruct_50(0, 50, 1, 0, 0, 0, 0);
                                                                instruct_50(0, 33, 1, 0, 0, 0, 0);
                                                                instruct_50(0, 1, 344, 0, 0, 0, 0);
::label18::
::label29::
                                                                instruct_50(17, 1, 1, 5, 86, 6, 0);
                                                                instruct_50(4, 0, 1, 6, 0, 0, 0);
                                                                if CheckJumpFlag() == true then goto label16 end;
                                                                    instruct_50(3, 0, 2, 2, 15, 30, 0);
                                                                    instruct_50(3, 0, 0, 2, 2, 1000, 0);
                                                                    instruct_50(1, 3, 0, 800, 15, 2, 0);
                                                                    instruct_50(32, 0, 2, 5, 0, 0, 0);
                                                                    instruct_50(27, 1, 1, 5, 100, 0, 0);
                                                                    instruct_50(32, 0, 2, 2, 0, 0, 0);
                                                                    instruct_50(10, 100, 3, 0, 0, 0, 0);
                                                                    instruct_50(0, 8, 21, 0, 0, 0, 0);
                                                                    instruct_50(3, 11, 1, 8, 8, 3, 0);
                                                                    instruct_50(12, 1, 180, 8, 0, 0, 0);
                                                                    instruct_50(8, 0, 716, 170, 0, 0, 0);
                                                                    instruct_50(9, 1, 165, 170, 6, 0, 0);
                                                                    instruct_50(32, 0, 2, 3, 0, 0, 0);
                                                                    instruct_50(11, 140, 0, 180, 0, 0, 0);
                                                                    instruct_50(32, 0, 2, 2, 0, 0, 0);
                                                                    instruct_50(11, 0, 140, 165, 0, 0, 0);
                                                                    instruct_50(1, 3, 0, 200, 15, 5, 0);
                                                                    instruct_50(3, 0, 0, 15, 15, 1, 0);
                                                                    instruct_50(3, 0, 0, 16, 16, 1, 0);
::label16::
                                                                    instruct_50(3, 0, 0, 5, 5, 1, 0);
                                                                    instruct_50(4, 1, 4, 5, 1, 0, 0);
                                                                    if CheckJumpFlag() == true then goto label17 end;
                                                                        instruct_50(4, 1, 0, 16, 0, 0, 0);
                                                                        if CheckJumpFlag() == true then goto label18 end;
::label17::
                                                                            instruct_50(4, 0, 3, 15, 0, 0, 0);
                                                                            if CheckJumpFlag() == true then goto label19 end;
                                                                                Talk("儲存箱中沒有物品。", 0, 2);
exit();
::label19::
                                                                                instruct_50(4, 1, 4, 0, 1, 0, 0);
                                                                                if CheckJumpFlag() == true then goto label20 end;
                                                                                    instruct_50(3, 0, 2, 2, 15, 30, 0);
                                                                                    instruct_50(3, 0, 0, 2, 2, 1000, 0);
                                                                                    instruct_50(1, 3, 0, 800, 15, 2, 0);
                                                                                    instruct_50(32, 0, 2, 4, 0, 0, 0);
                                                                                    instruct_50(8, 0, 717, 2000, 0, 0, 0);
                                                                                    instruct_50(3, 0, 0, 15, 15, 1, 0);
::label20::
                                                                                    instruct_50(3, 0, 1, 9, 15, 0, 0);
                                                                                    instruct_50(3, 0, 2, 9, 9, 18, 0);
                                                                                    instruct_50(3, 0, 0, 9, 9, 10, 0);
                                                                                    instruct_50(40, 2561, 15, 800, 10, 54, 5);
                                                                                    instruct_50(4, 0, 0, 10, 1, 0, 0);
                                                                                    if CheckJumpFlag() == true then goto label21 end;
                                                                                        instruct_50(4, 1, 4, 0, 1, 0, 0);
                                                                                        if CheckJumpFlag() == true then goto label22 end;
                                                                                            instruct_50(4, 1, 2, 10, 15, 0, 0);
                                                                                            if JudgeSexual(257) == true then goto label23 end;
::label22::
                                                                                                instruct_50(3, 0, 1, 10, 10, 1, 0);
                                                                                                instruct_50(2, 11, 0, 200, 10, 11, 0);
                                                                                                instruct_50(26, 0, 0, 330, 25, 21, 0);
                                                                                                instruct_50(4, 0, 2, 21, 0, 0, 0);
                                                                                                if CheckJumpFlag() == true then goto label24 end;
                                                                                                    Talk("身上的物品太多了。", 0, 2);
exit();
::label24::
                                                                                                    instruct_50(43, 0, 214, 0, 0, 0, 0);
                                                                                                    instruct_50(4, 0, 5, 10032, 0, 0, 0);
                                                                                                    if CheckJumpFlag() == false then goto label25 end;
                                                                                                        instruct_50(4, 0, 1, 10032, 5000, 0, 0);
                                                                                                        if CheckJumpFlag() == false then goto label26 end;
                                                                                                            instruct_50(17, 1, 1, 11, 86, 32, 0);
                                                                                                            instruct_50(48, 10, 2, 10032, 32, 0, 0);
                                                                                                            instruct_50(4, 1, 5, 10032, 32, 0, 0);
                                                                                                            if CheckJumpFlag() == true then goto label27 end;
                                                                                                                instruct_50(3, 1, 1, 32, 32, 10032, 0);
                                                                                                                instruct_50(16, 5, 1, 11, 86, 32, 0);
                                                                                                                instruct_50(43, 6, 213, 11, 10032, 0, 0);
exit();
::label27::
                                                                                                                Talk("沒有那麼多物品。", 0, 2);
exit();
::label25::
::label26::
                                                                                                                Talk("輸入錯誤。", 0, 2);
exit();
::label23::
                                                                                                                instruct_50(3, 0, 0, 0, 0, 50, 0);
                                                                                                                instruct_50(0, 15, 0, 0, 0, 0, 0);
::label28::
                                                                                                                instruct_50(1, 101, 0, 800, 15, 0, 0);
                                                                                                                instruct_50(1, 101, 0, 200, 15, 0, 0);
                                                                                                                instruct_50(3, 0, 0, 15, 15, 1, 0);
                                                                                                                instruct_50(4, 0, 0, 15, 50, 0, 0);
                                                                                                                if CheckJumpFlag() == true then goto label28 end;
                                                                                                                    instruct_50(0, 15, 0, 0, 0, 0, 0);
                                                                                                                    instruct_50(0, 6, 0, 0, 0, 0, 0);
                                                                                                                    instruct_50(4, 0, 2, 6, 0, 0, 0);
                                                                                                                    if CheckJumpFlag() == true then goto label29 end;
::label0::
::label21::
exit();
