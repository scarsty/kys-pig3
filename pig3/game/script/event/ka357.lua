instruct_50(0, 300, 28961, 0, 0, 0, 0);
instruct_50(0, 301, 27861, 0, 0, 0, 0);
instruct_50(0, 302, 25203, 0, 0, 0, 0);
instruct_50(0, 303, 21205, 0, 0, 0, 0);
instruct_50(0, 304, 8230, 0, 0, 0, 0);
instruct_50(0, 305, 0, 0, 0, 0, 0);
setx50(300, '無法扳動……');
instruct_50(0, 310, -27002, 0, 0, 0, 0);
instruct_50(0, 311, -27002, 0, 0, 0, 0);
instruct_50(0, 312, -27002, 0, 0, 0, 0);
instruct_50(0, 313, 8230, 0, 0, 0, 0);
instruct_50(0, 314, 0, 0, 0, 0, 0);
setx50(310, '隆隆隆……');
instruct_50(0, 320, -28576, 0, 0, 0, 0);
instruct_50(0, 321, 26041, 0, 0, 0, 0);
instruct_50(0, 322, 20659, 0, 0, 0, 0);
instruct_50(0, 323, 20358, 0, 0, 0, 0);
instruct_50(0, 324, -32654, 0, 0, 0, 0);
instruct_50(0, 325, -26625, 0, 0, 0, 0);
instruct_50(0, 326, 8230, 0, 0, 0, 0);
instruct_50(0, 327, 0, 0, 0, 0, 0);
setx50(320, '遠方傳來響聲………');
instruct_50(26, 0, 0, 10590, 29, 200, 0);
instruct_50(26, 0, 0, 10588, 29, 201, 0);
instruct_50(26, 0, 0, 10586, 29, 202, 0);
instruct_50(26, 0, 0, 17650, 5, 203, 0);
instruct_50(4, 0, 2, 203, 0, 0, 0);
if CheckJumpFlag() == false then goto label0 end;
    instruct_50(3, 0, 0, 204, 201, 0, 0);
    instruct_50(3, 0, 1, 205, 202, 1, 0);
::label0::
    instruct_50(4, 0, 2, 203, 1, 0, 0);
    if CheckJumpFlag() == false then goto label1 end;
exit();
::label1::
        instruct_50(4, 0, 2, 203, 2, 0, 0);
        if CheckJumpFlag() == false then goto label2 end;
            instruct_50(3, 0, 1, 204, 201, 1, 0);
            instruct_50(3, 0, 0, 205, 202, 0, 0);
::label2::
            instruct_50(4, 0, 2, 203, 3, 0, 0);
            if CheckJumpFlag() == false then goto label3 end;
exit();
::label3::
                instruct_50(24, 13, 200, 2, 204, 205, 211);
                instruct_50(3, 0, 0, 211, 211, 2, 0);
                instruct_50(24, 13, 200, 3, 204, 205, 207);
                instruct_50(22, 3, 200, 207, 7, 208, 0);
                instruct_50(4, 0, 1, 208, -2, 0, 0);
                if CheckJumpFlag() == false then goto label4 end;
                    instruct_50(34, 0, 100, 100, 110, 25, 0);
                    instruct_50(33, 0, 300, 105, 104, 1797, 0);
                    instruct_50(35, 0, 0, 0, 0, 0, 0);
exit();
::label4::
                    instruct_50(3, 0, 2, 206, 204, 100, 0);
                    instruct_50(3, 1, 0, 206, 206, 205, 0);
                    instruct_50(4, 0, 2, 206, 846, 0, 0);
                    if CheckJumpFlag() == false then goto label5 end;
                        instruct_50(23, 29, 200, 2, 204, 205, 211);
                        instruct_50(21, 3, 200, 207, 7, -2, 0);
                        instruct_50(23, 1, 200, 1, 14, 43, 0);
                        instruct_50(34, 0, 100, 100, 150, 25, 0);
                        instruct_50(33, 0, 320, 105, 104, 1797, 0);
                        PlayWave(22);
                        instruct_50(35, 0, 0, 0, 0, 0, 0);
exit();
::label5::
                        instruct_50(4, 0, 2, 206, 2650, 0, 0);
                        if CheckJumpFlag() == false then goto label6 end;
                            instruct_50(23, 29, 200, 2, 204, 205, 211);
                            instruct_50(21, 3, 200, 207, 7, -2, 0);
                            instruct_50(23, 1, 200, 1, 52, 41, 0);
                            instruct_50(34, 0, 100, 100, 150, 25, 0);
                            instruct_50(33, 0, 320, 105, 104, 1797, 0);
                            PlayWave(22);
                            instruct_50(35, 0, 0, 0, 0, 0, 0);
exit();
::label6::
                            instruct_50(4, 0, 2, 206, 3407, 0, 0);
                            if CheckJumpFlag() == false then goto label7 end;
                                instruct_50(23, 29, 200, 2, 204, 205, 211);
                                instruct_50(21, 3, 200, 207, 7, -2, 0);
                                instruct_50(23, 1, 200, 1, 51, 17, 0);
                                instruct_50(34, 0, 100, 100, 150, 25, 0);
                                instruct_50(33, 0, 320, 105, 104, 1797, 0);
                                PlayWave(22);
                                instruct_50(35, 0, 0, 0, 0, 0, 0);
exit();
::label7::
                                instruct_50(4, 0, 2, 206, 3227, 0, 0);
                                if CheckJumpFlag() == false then goto label8 end;
                                    instruct_50(23, 29, 200, 2, 204, 205, 211);
                                    instruct_50(21, 3, 200, 207, 7, -2, 0);
                                    instruct_50(23, 1, 200, 1, 32, 23, 0);
                                    instruct_50(34, 0, 100, 100, 150, 25, 0);
                                    instruct_50(33, 0, 320, 105, 104, 1797, 0);
                                    PlayWave(22);
                                    instruct_50(35, 0, 0, 0, 0, 0, 0);
exit();
::label8::
                                    instruct_50(4, 0, 2, 206, 4838, 0, 0);
                                    if CheckJumpFlag() == true then goto label9 end;
                                        instruct_50(4, 0, 2, 206, 4713, 0, 0);
                                        if CheckJumpFlag() == true then goto label10 end;
                                            instruct_50(4, 0, 2, 206, 2722, 0, 0);
                                            if CheckJumpFlag() == true then goto label11 end;
                                                instruct_50(4, 0, 2, 206, 1531, 0, 0);
                                                if CheckJumpFlag() == true then goto label12 end;
                                                    instruct_50(4, 0, 2, 206, 513, 0, 0);
                                                    if CheckJumpFlag() == false then goto label13 end;
::label9::
::label10::
::label11::
::label12::
                                                        instruct_50(23, 29, 200, 2, 204, 205, 211);
                                                        instruct_50(21, 3, 200, 207, 7, -2, 0);
                                                        instruct_50(24, 1, 200, 3, 5, 13, 209);
                                                        instruct_50(22, 3, 200, 209, 8, 210, 0);
                                                        instruct_50(3, 0, 0, 210, 210, 1, 0);
                                                        instruct_50(21, 11, 200, 209, 8, 210, 0);
                                                        instruct_50(4, 0, 2, 210, 5, 0, 0);
                                                        if CheckJumpFlag() == true then goto label14 end;
                                                            instruct_50(34, 0, 100, 100, 90, 25, 0);
                                                            instruct_50(33, 0, 310, 105, 104, 1797, 0);
                                                            instruct_50(35, 0, 0, 0, 0, 0, 0);
exit();
::label14::
                                                            instruct_50(23, 1, 200, 1, 9, 26, 0);
                                                            instruct_50(34, 0, 100, 100, 150, 25, 0);
                                                            instruct_50(33, 0, 320, 105, 104, 1797, 0);
                                                            PlayWave(22);
                                                            instruct_50(35, 0, 0, 0, 0, 0, 0);
exit();
::label13::
                                                            instruct_50(4, 0, 2, 206, 1423, 0, 0);
                                                            if CheckJumpFlag() == true then goto label15 end;
                                                                instruct_50(4, 0, 2, 206, 1623, 0, 0);
                                                                if CheckJumpFlag() == true then goto label16 end;
                                                                    instruct_50(4, 0, 2, 206, 1823, 0, 0);
                                                                    if CheckJumpFlag() == false then goto label17 end;
::label15::
::label16::
                                                                        instruct_50(4, 0, 4, 211, 4996, 0, 0);
                                                                        if CheckJumpFlag() == false then goto label18 end;
                                                                            instruct_50(3, 0, 1, 211, 211, 4, 0);
::label18::
                                                                            instruct_50(23, 29, 200, 2, 204, 205, 211);
                                                                            instruct_50(24, 1, 200, 2, 14, 23, 209);
                                                                            instruct_50(24, 1, 200, 2, 16, 23, 210);
                                                                            instruct_50(24, 1, 200, 2, 18, 23, 212);
                                                                            instruct_50(4, 0, 2, 209, 4992, 0, 0);
                                                                            if CheckJumpFlag() == false then goto label19 end;
                                                                                instruct_50(4, 0, 2, 210, 4994, 0, 0);
                                                                                if CheckJumpFlag() == false then goto label20 end;
                                                                                    instruct_50(4, 0, 2, 212, 4994, 0, 0);
                                                                                    if CheckJumpFlag() == false then goto label21 end;
                                                                                        instruct_50(24, 1, 200, 3, 14, 23, 207);
                                                                                        instruct_50(21, 3, 200, 207, 7, -2, 0);
                                                                                        instruct_50(24, 1, 200, 3, 16, 23, 207);
                                                                                        instruct_50(21, 3, 200, 207, 7, -2, 0);
                                                                                        instruct_50(24, 1, 200, 3, 18, 23, 207);
                                                                                        instruct_50(21, 3, 200, 207, 7, -2, 0);
                                                                                        instruct_50(23, 1, 200, 1, 12, 15, 0);
                                                                                        instruct_50(34, 0, 100, 100, 150, 25, 0);
                                                                                        instruct_50(33, 0, 320, 105, 104, 1797, 0);
                                                                                        PlayWave(22);
                                                                                        instruct_50(35, 0, 0, 0, 0, 0, 0);
::label19::
::label20::
::label21::
exit();
::label17::
                                                                                        instruct_50(4, 0, 2, 206, 835, 0, 0);
                                                                                        if CheckJumpFlag() == false then goto label22 end;
                                                                                            instruct_50(24, 1, 200, 3, 8, 35, 209);
                                                                                            instruct_50(22, 3, 200, 209, 8, 210, 0);
                                                                                            instruct_50(4, 0, 2, 210, 1, 0, 0);
                                                                                            if CheckJumpFlag() == false then goto label23 end;
                                                                                                instruct_50(3, 0, 0, 210, 210, 1, 0);
                                                                                                instruct_50(21, 11, 200, 209, 8, 210, 0);
                                                                                                instruct_50(23, 29, 200, 2, 204, 205, 211);
                                                                                                instruct_50(21, 3, 200, 207, 7, -2, 0);
exit();
::label23::
                                                                                                instruct_50(34, 0, 100, 100, 110, 25, 0);
                                                                                                instruct_50(33, 0, 300, 105, 104, 1797, 0);
                                                                                                instruct_50(35, 0, 0, 0, 0, 0, 0);
exit();
::label22::
                                                                                                instruct_50(4, 0, 2, 206, 833, 0, 0);
                                                                                                if CheckJumpFlag() == false then goto label24 end;
                                                                                                    instruct_50(24, 1, 200, 3, 8, 35, 209);
                                                                                                    instruct_50(22, 3, 200, 209, 8, 210, 0);
                                                                                                    instruct_50(3, 0, 0, 210, 210, 1, 0);
                                                                                                    instruct_50(21, 11, 200, 209, 8, 210, 0);
                                                                                                    instruct_50(23, 29, 200, 2, 204, 205, 211);
                                                                                                    instruct_50(21, 3, 200, 207, 7, -2, 0);
exit();
::label24::
                                                                                                    instruct_50(4, 0, 2, 206, 831, 0, 0);
                                                                                                    if CheckJumpFlag() == false then goto label25 end;
                                                                                                        instruct_50(24, 1, 200, 3, 8, 35, 209);
                                                                                                        instruct_50(22, 3, 200, 209, 8, 210, 0);
                                                                                                        instruct_50(4, 0, 2, 210, 2, 0, 0);
                                                                                                        if CheckJumpFlag() == false then goto label26 end;
                                                                                                            instruct_50(23, 29, 200, 2, 204, 205, 211);
                                                                                                            instruct_50(21, 3, 200, 207, 7, -2, 0);
                                                                                                            instruct_50(23, 1, 200, 1, 21, 32, 0);
                                                                                                            instruct_50(34, 0, 100, 100, 150, 25, 0);
                                                                                                            instruct_50(33, 0, 320, 105, 104, 1797, 0);
                                                                                                            PlayWave(22);
                                                                                                            instruct_50(35, 0, 0, 0, 0, 0, 0);
exit();
::label26::
                                                                                                            instruct_50(34, 0, 100, 100, 110, 25, 0);
                                                                                                            instruct_50(33, 0, 300, 105, 104, 1797, 0);
                                                                                                            instruct_50(35, 0, 0, 0, 0, 0, 0);
::label25::
exit();
