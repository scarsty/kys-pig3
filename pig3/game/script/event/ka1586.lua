if UseItem(226) == true then goto label0 end;
    if UseItem(227) == true then goto label1 end;
        if UseItem(228) == true then goto label2 end;
            if UseItem(229) == true then goto label3 end;
                if UseItem(230) == true then goto label4 end;
                    exit();
::label4::
                    instruct_50(0, 3000, 406, 0, 0, 0, 0);
                    if JudgeSexual(0) == true then goto label5 end;
::label3::
                        instruct_50(0, 3000, 405, 0, 0, 0, 0);
                        if JudgeSexual(0) == true then goto label6 end;
::label2::
                            instruct_50(0, 3000, 404, 0, 0, 0, 0);
                            if JudgeSexual(0) == true then goto label7 end;
::label1::
                                instruct_50(0, 3000, 403, 0, 0, 0, 0);
                                if JudgeSexual(0) == true then goto label8 end;
::label0::
                                    instruct_50(0, 3000, 402, 0, 0, 0, 0);
::label5::
::label6::
::label7::
::label8::
                                    Talk(22, "要易容成這個樣子啊，好吧。", -2, 1, 0, 0);
                                    DarkScene();
                                    instruct_50(16, 4, 0, 0, 2, 3000, 0);
                                    LightScene();
                                    Talk(22, "怎麼樣，不錯吧？", -2, 1, 0, 0);
                                    Talk(0, "………………", -2, 0, 0, 0);
exit();
