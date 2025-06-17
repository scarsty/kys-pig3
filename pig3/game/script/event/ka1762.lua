if UseItem(240) == true then goto label0 end;
    exit();
::label0::
    GetItem(240, -1);
    Talk(263, "王兄，這區區小事便由我代勞吧。", -2, 0, 0, 0);
    Talk(262, "身隕道存，執念不入極樂土。示法宏願，殘魂長待有緣人。", -2, 0, 0, 0);
    if TryBattle(287) == true then goto label1 end;
        Dead();
        LightScene();
        exit();
::label1::
        LightScene();
        Talk(263, "哼。", -2, 0, 0, 0);
        Talk(262, "呵，此番便輪到我了。", -2, 0, 0, 0);
        if TryBattle(288) == true then goto label2 end;
            Dead();
            LightScene();
            exit();
::label2::
            LightScene();
            Talk(262, "唔……", -2, 0, 0, 0);
            Talk(263, "我等尚未出全力。", -2, 0, 0, 0);
            Talk(262, "當真如此？", -2, 0, 0, 0);
            Talk(263, "便要如此。", -2, 0, 0, 0);
            if TryBattle(284) == true then goto label3 end;
                Dead();
                LightScene();
                exit();
::label3::
                instruct_50(17, 0, 0, 0, 146, 0, 0);
                instruct_50(3, 0, 0, 0, 0, 100, 0);
                instruct_50(16, 4, 0, 0, 146, 0, 0);
                LightScene();
                Talk(262, "原來……你我都錯了。", -2, 0, 0, 0);
                Talk(263, "你我本都明白。", -2, 0, 0, 0);
                ModifyEvent(128, 3, 1, 0, 1763, 0, 0, 6698, 6698, 6698, 0, -2, -2);
exit();
