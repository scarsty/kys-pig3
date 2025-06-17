Talk(21, "閣下又來我恆山派做什麼？我定閒可是不承認這五嶽派的．", 21, 0);
if AskBattle() == true then goto label0 end;
    exit();
::label0::
    Talk(0, "好啊，你居然不承認我五嶽派，看來得再教訓教訓你．", 0, 1);
    if TryBattle(39) == true then goto label1 end;
        Dead();
        exit();
::label1::
        LightScene();
        AddEthics(-1);
exit();
