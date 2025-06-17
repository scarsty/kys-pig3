if InTeam(33) == true then goto label0 end;
    Talk(95, "不對不對，你沒有帶來謎底中的人。我的謎語是：清靜無爭，終諡曰安。", -2, 0, 0, 0);
    Talk(415, "……你急什麼，等我再找找。", -2, 1, 0, 0);
    exit();
::label0::
    Talk(95, "咦？不錯，就是她了。看不出，你小子還有些小聰明。", -2, 0, 0, 0);
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
                        ShowTitle("隊伍中所有人資質提高二點", 28421);
                        Talk(0, "更聰明的還有呢！我有不少聰明絕頂的朋友，住在歸雲莊，你想不想找他們一起猜謎？", -2, 1, 0, 0);
                        Talk(95, "如此妙哉！這塊“金線帛”我也不記得從何處得來，送你玩玩。", -2, 0, 0, 0);
                        DarkScene();
                        ModifyEvent(13, 2, 0, 0, 0, 0, 0, 0, 0, 0, 0, -2, -2);
                        LightScene();
                        instruct_50(43, 0, 209, 85, 2, 0, 0);
                        instruct_50(43, 0, 228, 85, 95, 0, 0);
                        ModifyEvent(15, 41, 1, 0, 1426, 0, 0, 7060, 7060, 7060, 0, -2, -2);
                        GetItem(247, 1);
exit();
