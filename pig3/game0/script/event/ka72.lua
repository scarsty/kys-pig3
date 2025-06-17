Talk(9, "你能帶我去找義父嗎？", 9, 0);
if AskJoin () == true then goto label0 end;
    Talk(0, "這恐怕不行，我還有許多要事在身，無法帶你去找他．", 0, 1);
    Talk(9, "．．．．．", 9, 0);
    exit();
::label0::
    Talk(0, "好啊，我就帶你去找他．", 0, 1);
    if TeamIsFull() == false then goto label1 end;
        Talk(9, "你的隊伍已滿，我無法加入．", 9, 0);
        exit();
::label1::
        Talk(9, "謝謝這位大哥．", 9, 0);
        DarkScene();
        ModifyEvent(-2, -2, 0, -1, -1, -1, -1, -1, -1, -1, -1, -2, -2);
        LightScene();
        Join(9);
        AddEthics(2);
exit();
