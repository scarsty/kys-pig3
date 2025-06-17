if InTeam(63) == true then goto label0 end;
    exit();
::label0::
    Talk(63, "這黑水潭似乎是有人特別佈局過，但卻也難不倒我．", 63, 1);
    DarkScene();
    ChangeScenePic(-2, 0, 994, 990);
    LightScene();
    ModifyEvent(-2, -2, -2, -2, -1, -1, -1, -1, -1, -1, -2, -2, -2);
    ModifyEvent(-2, 5, -2, -2, -1, -1, 434, -1, -1, -1, -2, -2, -2);
exit();
