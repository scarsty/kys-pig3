Talk(0, "道長劍法高明，在下想請道長同行一路，也好時時請教。", -2, 0, 0, 0);
instruct_50(17, 0, 0, 166, 42, 0, 0);
instruct_50(4, 0, 2, 0, 3, 0, 0);
if CheckJumpFlag() == true then goto label0 end;
    Talk(46, "呵呵，那先讓老道瞧瞧小兄弟的劍法進步如何？", -2, 1, 0, 0);
    if TryBattle(91) == true then goto label1 end;
        LightScene();
        exit();
::label1::
        LightScene();
        Talk(46, "小兄弟果然天賦極佳，進步神速，老道就隨你一行。", -2, 1, 0, 0);
        DarkScene();
        ModifyEvent(84, 9, 0, 0, 0, 0, 0, 0, 0, 0, 0, -2, -2);
        LightScene();
        instruct_50(43, 0, 228, 38, 46, 0, 0);
        instruct_50(43, 0, 209, 38, 1, 0, 0);
        ModifyEvent(16, 35, 1, 0, 746, 0, 0, 7184, 7184, 7184, 0, -2, -2);
        exit();
::label0::
        Talk(46, "哈哈，小兄弟既誠心邀請，老道也就不說什麼客套話了。", -2, 1, 0, 0);
        DarkScene();
        ModifyEvent(84, 9, 0, 0, 0, 0, 0, 0, 0, 0, 0, -2, -2);
        LightScene();
        instruct_50(43, 0, 228, 38, 46, 0, 0);
        instruct_50(43, 0, 209, 38, 1, 0, 0);
        ModifyEvent(16, 35, 1, 0, 746, 0, 0, 7184, 7184, 7184, 0, -2, -2);
exit();
