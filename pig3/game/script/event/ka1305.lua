instruct_50(43, 0, 351, 10159, 7, 0, 0);
instruct_50(4, 0, 2, 28931, 7, 0, 0);
if CheckJumpFlag() == true then goto label0 end;
    instruct_50(4, 0, 3, 28931, 6, 0, 0);
    if CheckJumpFlag() == true then goto label1 end;
        if HaveItem(40) == true then goto label2 end;
            Talk(0, "我好像沒有這樣一把刀……", -2, 0, 0, 0);
            exit();
::label2::
            Talk(0, "先生看看這把刀是否合用？", -2, 0, 0, 0);
            Talk(395, "不錯，比這勞什子強多了，少俠這就拿回去給他吧。", -2, 1, 0, 0);
            AddItem(40, -1);
            GetItem(44, 1);
            ModifyEvent(12, 2, 1, 0, 1319, 0, 0, 9188, 9188, 9188, 0, -2, -2);
            exit();
::label1::
            instruct_50(4, 0, 3, 28931, 5, 0, 0);
            if CheckJumpFlag() == true then goto label3 end;
                if HaveItem(41) == true then goto label4 end;
                    Talk(0, "我好像沒有這樣一把刀……", -2, 0, 0, 0);
                    exit();
::label4::
                    Talk(0, "先生看看這把刀是否合用？", -2, 0, 0, 0);
                    Talk(395, "不錯，比這勞什子強多了，少俠這就拿回去給他吧。", -2, 1, 0, 0);
                    AddItem(41, -1);
                    GetItem(44, 1);
                    ModifyEvent(12, 2, 1, 0, 1319, 0, 0, 9188, 9188, 9188, 0, -2, -2);
                    exit();
::label3::
                    instruct_50(4, 0, 3, 28931, 4, 0, 0);
                    if CheckJumpFlag() == true then goto label5 end;
                        if HaveItem(42) == true then goto label6 end;
                            Talk(0, "我好像沒有這樣一把刀……", -2, 0, 0, 0);
                            exit();
::label6::
                            Talk(0, "先生看看這把刀是否合用？", -2, 0, 0, 0);
                            Talk(395, "不錯，比這勞什子強多了，少俠這就拿回去給他吧。", -2, 1, 0, 0);
                            AddItem(42, -1);
                            GetItem(44, 1);
                            ModifyEvent(12, 2, 1, 0, 1319, 0, 0, 9188, 9188, 9188, 0, -2, -2);
                            exit();
::label5::
                            instruct_50(4, 0, 3, 28931, 3, 0, 0);
                            if CheckJumpFlag() == true then goto label7 end;
                                if HaveItem(43) == true then goto label8 end;
                                    Talk(0, "我好像沒有這樣一把刀……", -2, 0, 0, 0);
                                    exit();
::label8::
                                    Talk(0, "先生看看這把刀是否合用？", -2, 0, 0, 0);
                                    Talk(395, "不錯，比這勞什子強多了，少俠這就拿回去給他吧。", -2, 1, 0, 0);
                                    AddItem(43, -1);
                                    GetItem(44, 1);
                                    ModifyEvent(12, 2, 1, 0, 1319, 0, 0, 9188, 9188, 9188, 0, -2, -2);
                                    exit();
::label7::
                                    instruct_50(4, 0, 3, 28931, 2, 0, 0);
                                    if CheckJumpFlag() == true then goto label9 end;
                                        if HaveItem(45) == true then goto label10 end;
                                            Talk(0, "我好像沒有這樣一把刀……", -2, 0, 0, 0);
                                            exit();
::label10::
                                            Talk(0, "先生看看這把刀是否合用？", -2, 0, 0, 0);
                                            Talk(395, "不錯，比這勞什子強多了，少俠這就拿回去給他吧。", -2, 1, 0, 0);
                                            AddItem(45, -1);
                                            GetItem(44, 1);
                                            ModifyEvent(12, 2, 1, 0, 1319, 0, 0, 9188, 9188, 9188, 0, -2, -2);
                                            exit();
::label9::
                                            if HaveItem(46) == true then goto label11 end;
                                                Talk(0, "我好像沒有這樣一把刀……", -2, 0, 0, 0);
                                                exit();
::label11::
                                                Talk(0, "先生看看這把刀是否合用？", -2, 0, 0, 0);
                                                Talk(395, "不錯，比這勞什子強多了，少俠這就拿回去給他吧。", -2, 1, 0, 0);
                                                AddItem(46, -1);
                                                GetItem(44, 1);
                                                ModifyEvent(12, 2, 1, 0, 1319, 0, 0, 9188, 9188, 9188, 0, -2, -2);
                                                exit();
::label0::
                                                Talk(395, "&&少俠能幫我找把其他刀來麼？", -2, 0, 0, 0);
                                                Talk(0, "這個包在我身上。", -2, 1, 0, 0);
exit();
