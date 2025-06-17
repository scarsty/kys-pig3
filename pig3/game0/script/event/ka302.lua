if InTeam(29) == false then goto label0 end;
    Talk(28, "田伯光！你這惡賊，我跟你拼了！", 28, 0);
    if TryBattle(52) == true then goto label1 end;
        Dead();
        exit();
::label1::
        ModifyEvent(-2, -2, 0, 0, -1, -1, -1, -1, -1, -1, -2, -2, -2);
        LightScene();
        AddEthics(-5);
        exit();
::label0::
        Talk(28, "你還在這做什麼？", 28, 0);
        Talk(0, "沒事逛逛．", 0, 1);
exit();
