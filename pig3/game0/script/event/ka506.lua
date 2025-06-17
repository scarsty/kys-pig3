if InTeam(49) == true then goto label0 end;
    exit();
::label0::
    Talk(49, "終於回到少林寺了，我要趕緊去向師父報告，否則會被罵很慘．謝謝大哥一路上的照顧．", 49, 1);
    ModifyEvent(-2, 0, 0, 0, -1, -1, -1, -1, -1, -1, -2, -2, -2);
    ModifyEvent(-2, 1, 0, 0, -1, -1, -1, -1, -1, -1, -2, -2, -2);
    ModifyEvent(-2, 2, 0, 0, -1, -1, -1, -1, -1, -1, -2, -2, -2);
    SetSceneMap(53, 1, 22, 24, 1532);
    SetSceneMap(53, 1, 22, 23, 1534);
    SetSceneMap(53, 1, 23, 24, 0);
    SetSceneMap(53, 1, 24, 24, 1536);
    SetSceneMap(53, 1, 24, 23, 1538);
    Leave(49);
    AddEthics(10);
exit();
