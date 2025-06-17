if UseItem(0) == true then goto label0 end;
    if UseItem(261) == false then goto label1 end;
        Talk(0, "小二哥，我這有上好的黑狗肉，你家可否代做一份狗肉煲？銀子不會少你們的。", -2, 0, 0, 0);
        instruct_50(20, 0, 0, 0, 0, 0, 0);
        instruct_50(4, 0, 0, 0, 20, 0, 0);
        if CheckJumpFlag() == true then goto label2 end;
            Talk(383, "啊哈，我家大廚的手藝那可是窩窩頭上蒸籠——蓋了帽兒了！您就擎好兒吧！", -2, 1, 0, 0);
            DarkScene();
            LightScene();
            GetItem(0, -20);
            GetItem(261, -1);
            GetItem(262, 1);
            exit();
::label2::
            Talk(383, "客官，做倒是能做，可是這銀子……怎麼也要二十兩啊！", -2, 0, 0, 0);
::label1::
            exit();
::label0::
            instruct_50(20, 0, 0, 0, 0, 0, 0);
            instruct_50(4, 0, 0, 0, 10, 0, 0);
            if CheckJumpFlag() == true then goto label3 end;
                Talk(0, "小二哥，給我來盤狗肉。", -2, 0, 0, 0);
                Talk(383, "好咧，我這就給公子拿來。", -2, 1, 0, 0);
                GetItem(0, -10);
                GetItem(260, 1);
                exit();
::label3::
                Talk(383, "狗肉十兩銀子一盤，公子，你帶夠銀子再來吧。", -2, 0, 0, 0);
exit();
