if JudgeEthics(0, 50, 100) == false then goto label0 end;
    Talk(68, "最近江湖上對你的風評還挺不錯的，希望你繼續保持下去.", 68, 0);
::label0::
    exit();
    Talk(68, "你這作惡多端的小子，老道饒不了你．", 68, 0);
    if TryBattle(75) == true then goto label1 end;
        LightScene();
        exit();
::label1::
        ModifyEvent(-2, -2, -2, -2, 459, -1, -1, -2, -2, -2, -2, -2, -2);
        LightScene();
exit();
