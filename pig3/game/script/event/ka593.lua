Talk(348, "叫花子，沒錢花，叫聲大爺行行好，多了咱們也不要，紋銀五百請拿來。", -2, 1, 0, 0);
instruct_50(43, 0, 351, 2705, 2, 0, 0);
instruct_50(4, 0, 2, 28931, 2, 0, 0);
if CheckJumpFlag() == true then goto label0 end;
    if JudgeMoney(500) == true then goto label1 end;
        Talk(348, "連五百兩都沒有，比我們叫花子還窮啊……", -2, 1, 0, 0);
        exit();
::label1::
        AddItem(0, -500);
        Talk(348, "大爺真是出手豪闊呀，裡邊請。", -2, 1, 0, 0);
        DarkScene();
        ModifyEvent(55, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, -2, -2);
        LightScene();
        exit();
::label0::
        Talk(348, "嘿嘿，來到丐幫卻不賞錢，大爺，總得留下個腕吧。", -2, 1, 0, 0);
        if TryBattle(50) == true then goto label2 end;
            LightScene();
            Talk(348, "就這點功夫，還想進丐幫？", -2, 1, 0, 0);
            exit();
::label2::
            LightScene();
            Talk(348, "閣下武功了得，裡邊請！", -2, 1, 0, 0);
            DarkScene();
            ModifyEvent(55, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, -2, -2);
            LightScene();
exit();
