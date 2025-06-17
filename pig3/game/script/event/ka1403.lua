Talk(89, "…………", -2, 0, 0, 0);
Talk(0, "…………", -2, 1, 0, 0);
if InTeam(64) == false then goto label0 end;
    if InTeam(74) == false then goto label1 end;
        if InTeam(88) == false then goto label2 end;
            if InTeam(69) == false then goto label3 end;
                Talk(89, "他們？", -2, 0, 0, 0);
                Talk(0, "不錯。", -2, 1, 0, 0);
                Talk(89, "同進退。", -2, 0, 0, 0);
                Talk(0, "好！", -2, 1, 0, 0);
                DarkScene();
                ModifyEvent(47, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, -2, -2);
                LightScene();
                instruct_50(43, 0, 209, 46, 1, 0, 0);
                instruct_50(43, 0, 228, 46, 89, 0, 0);
                ModifyEvent(15, 37, 1, 0, 786, 0, 0, 7294, 7294, 7294, 0, -2, -2);
                exit();
::label0::
::label1::
::label2::
::label3::
exit();
