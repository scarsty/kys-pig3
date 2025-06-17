instruct_50(0, 9000, 5, 0, 0, 0, 0);
Talk(382, "客官您要住店嗎？本店明碼實價，童叟無欺，住宿每人紋銀5兩。", -2, 1, 0, 0);
if AskRest() == true then goto  label0 end;
    exit();
::label0::
    instruct_50(0, 1, 0, 0, 0, 0, 0);
::label2::
    instruct_50(3, 0, 0, 1, 1, 1, 0);
    instruct_50(4, 0, 5, 1, 5, 0, 0);
    if CheckJumpFlag() == true then goto label1 end;
        instruct_50(19, 1, 1, 2, 0, 0, 0);
        instruct_50(4, 0, 5, 2, 0, 0, 0);
        if CheckJumpFlag() == true then goto label2 end;
::label1::
            instruct_50(3, 1, 2, 9001, 1, 9000, 0);
            instruct_50(32, 0, 9001, 1, 0, 0, 0);
            if JudgeMoney(100) == true then goto label3 end;
                Talk(382, "這位客官，好像您的銀子不夠呀……", -2, 1, 0, 0);
                exit();
::label3::
                Talk(382, "好咧，客官裡面請。", -2, 1, 0, 0);
                instruct_50(43, 4, 213, 0, 9001, 0, 1);
                DarkScene();
                Rest();
                LightScene();
exit();
