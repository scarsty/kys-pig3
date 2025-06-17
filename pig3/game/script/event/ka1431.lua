if InTeam(51) == true then goto label0 end;
    Talk(95, "不對不對，你聽好了，我的謎面是“平蕪盡處暮天低”。", -2, 0, 0, 0);
    Talk(0, "……你急什麼，等我再找找。", -2, 1, 0, 0);
    exit();
::label0::
    Talk(95, "哈哈，真聰明，又猜對啦。", -2, 0, 0, 0);
    instruct_50(17, 0, 0, 0, 120, 0, 0);
    instruct_50(3, 0, 0, 0, 0, 2, 0);
    instruct_50(16, 4, 0, 0, 120, 0, 0);
    instruct_50(19, 0, 1, 1, 0, 0, 0);
    instruct_50(4, 0, 1, 1, 0, 0, 0);
    if CheckJumpFlag() == true then goto label1 end;
        instruct_50(17, 1, 0, 1, 120, 0, 0);
        instruct_50(3, 0, 0, 0, 0, 2, 0);
        instruct_50(16, 5, 0, 1, 120, 0, 0);
        instruct_50(19, 0, 2, 2, 0, 0, 0);
        instruct_50(4, 0, 1, 1, 0, 0, 0);
        if CheckJumpFlag() == true then goto label2 end;
            instruct_50(17, 1, 0, 2, 120, 0, 0);
            instruct_50(3, 0, 0, 0, 0, 2, 0);
            instruct_50(16, 5, 0, 2, 120, 0, 0);
            instruct_50(19, 0, 3, 3, 0, 0, 0);
            instruct_50(4, 0, 1, 1, 0, 0, 0);
            if CheckJumpFlag() == true then goto label3 end;
                instruct_50(17, 1, 0, 3, 120, 0, 0);
                instruct_50(3, 0, 0, 0, 0, 2, 0);
                instruct_50(16, 5, 0, 3, 120, 0, 0);
                instruct_50(19, 0, 4, 4, 0, 0, 0);
                instruct_50(4, 0, 1, 1, 0, 0, 0);
                if CheckJumpFlag() == true then goto label4 end;
                    instruct_50(17, 1, 0, 4, 120, 0, 0);
                    instruct_50(3, 0, 0, 0, 0, 2, 0);
                    instruct_50(16, 5, 0, 4, 120, 0, 0);
                    instruct_50(19, 0, 5, 5, 0, 0, 0);
                    instruct_50(4, 0, 1, 1, 0, 0, 0);
                    if CheckJumpFlag() == true then goto label5 end;
                        instruct_50(17, 1, 0, 5, 120, 0, 0);
                        instruct_50(3, 0, 0, 0, 0, 2, 0);
                        instruct_50(16, 5, 0, 5, 120, 0, 0);
::label1::
::label2::
::label3::
::label4::
::label5::
                        ModifyEvent(15, 41, 1, 0, 1432, 0, 0, 7060, 7060, 7060, 0, -2, -2);
                        ShowTitle("隊伍中所有人資質提高二點", 28421);
exit();
