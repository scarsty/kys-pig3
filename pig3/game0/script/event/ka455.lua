Talk(95, "很抱歉，敝教丘掌門現正閉關中，重陽宮恕不接客．", 95, 0);
if AskBattle() == true then goto label0 end;
    Talk(0, "真是不巧，那只好改天再登門拜訪了．", 0, 1);
    exit();
::label0::
    Talk(0, "那只好得罪了，因為裡面搞不好有我要的東西．", 0, 1);
    if TryBattle(73) == true then goto label1 end;
        Dead();
        exit();
::label1::
        ModifyEvent(-2, 1, -2, -2, 456, -1, -1, 6114, 6114, 6114, -2, 31, 48);
        ModifyEvent(-2, 2, -2, -2, 456, -1, -1, -2, -2, -2, -2, -2, -2);
        ModifyEvent(-2, 3, -2, -2, 456, -1, -1, -2, -2, -2, -2, -2, -2);
        ModifyEvent(-2, 4, -2, -2, 456, -1, -1, -2, -2, -2, -2, -2, -2);
        ModifyEvent(-2, 5, -2, -2, 456, -1, -1, -2, -2, -2, -2, -2, -2);
        ModifyEvent(-2, 6, -2, -2, 456, -1, -1, -2, -2, -2, -2, -2, -2);
        LightScene();
        AddRepute(1);
exit();
