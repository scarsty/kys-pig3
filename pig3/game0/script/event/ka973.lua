Talk(38, "好兄弟，你還好吧？我到現在還沒找到我媽媽及小黃呢？", 38, 0);
if AskJoin () == true then goto label0 end;
    Talk(0, "這樣子啊！那你可得努力找哦．", 0, 1);
    exit();
::label0::
    Talk(0, "那不然我們再一起找好了，路上也有個照應．", 0, 1);
    if TeamIsFull() == false then goto label1 end;
        Talk(38, "你的隊伍已滿，我無法加入．", 38, 0);
        exit();
::label1::
        Talk(38, "好啊．", 38, 0);
        DarkScene();
        ModifyEvent(-2, 7, 0, -1, -1, -1, -1, -1, -1, -1, -1, -2, -2);
        ModifyEvent(-2, 8, 0, -1, -1, -1, -1, -1, -1, -1, -1, -2, -2);
        LightScene();
        Join(38);
exit();
