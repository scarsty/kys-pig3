Talk(0, "王姑娘妳好．", 0, 1);
if InTeam(53) == true then goto label0 end;
    exit();
::label0::
    Talk(53, "神仙姊姊．．．神仙姊姊．．．", 53, 1);
    Talk(109, "．．．．．．", 109, 0);
    if InTeam(53) == true then goto label1 end;
        exit();
::label1::
        ModifyEvent(-2, 0, -2, -2, -1, -1, 491, -1, -1, -1, -2, -2, -2);
exit();
