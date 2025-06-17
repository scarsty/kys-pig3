Talk(102, "做一件衣服很麻煩，有時需要很多奇怪的材料，而我卻樂在其中！", -2, 0, 0, 0);
if HaveItem(245) == false then goto label0 end;
    if HaveItem(246) == false then goto label1 end;
        if HaveItem(247) == false then goto label2 end;
            if HaveItem(248) == false then goto label3 end;
                if HaveItem(249) == false then goto label4 end;
                    if HaveItem(250) == false then goto label5 end;
                        if HaveItem(251) == false then goto label6 end;
                            if HaveItem(252) == false then goto label7 end;
                                Talk(102, "哇，哇～～，冰蠶絲、水晶棋子、金線帛、明玉絹、昂日金針、白玉帶鉤、百花清露、玳瑁簪，這麼多奇異材料都起啦！這下就看我的了！", -2, 0, 0, 0);
                                DarkScene();
                                AddItem(245, -1);
                                AddItem(246, -1);
                                AddItem(247, -1);
                                AddItem(248, -1);
                                AddItem(249, -1);
                                AddItem(250, -1);
                                AddItem(251, -1);
                                AddItem(252, -1);
                                LightScene();
                                Talk(102, "這是我為您量身定做的，穿穿看吧！", -2, 0, 0, 0);
                                GetItem(244, 1);
                                ModifyEvent(15, 84, 1, 0, 1644, -2, 0, 7284, 7284, 7284, 0, -2, -2);
::label0::
::label1::
::label2::
::label3::
::label4::
::label5::
::label6::
::label7::
exit();
