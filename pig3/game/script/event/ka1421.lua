if HaveItem(263) == false then goto label0 end;
    if HaveItem(264) == false then goto label1 end;
        if HaveItem(265) == false then goto label2 end;
            Talk(0, "道長，可是這幾卷道書？", -2, 0, 0, 0);
            Talk(88, "正是正是，“兆者，始也。基者，本也。陰極陽生，乾坤相交，恍惚中有物，杳冥中有精，生機於此兆始返本。”原來如此，原來如此！", -2, 1, 0, 0);
            Talk(0, "恭喜道長得償所願。晚輩卻有一不情之請。", -2, 0, 0, 0);
            Talk(88, "小兄弟請說。", -2, 1, 0, 0);
            Talk(0, "現下戰火漸起，天下英雄于歸雲莊相聚，共商抗擊外族之策，不知道長可願同往？", -2, 0, 0, 0);
            Talk(88, "家國大事，自是含糊不得。", -2, 1, 0, 0);
            DarkScene();
            ModifyEvent(62, 4, 0, 0, 0, 0, 0, 0, 0, 0, 0, -2, -2);
            LightScene();
            instruct_50(43, 0, 209, 69, 1, 0, 0);
            instruct_50(43, 0, 228, 69, 88, 0, 0);
            ModifyEvent(15, 36, 1, 0, 785, 0, 0, 7306, 7306, 7306, 0, -2, -2);
            AddItem(263, -1);
            AddItem(264, -1);
            AddItem(265, -1);
            exit();
::label0::
::label1::
::label2::
            Talk(88, "經多方探聽，這書所缺的部分，武當、全真、青城分別有所收藏。只是我這身份……呵呵，不大方便，不大方便。", -2, 0, 0, 0);
exit();
