Talk(0, "林兄劍法不知練的怎樣了？", 0, 1);
Talk(36, "我迫不及待想上四川青城，誅滅他全派為我雙親報仇．**可是以我現在的功力，恐怕無法辦到．", 36, 0);
if AskJoin () == true then goto label0 end;
    Talk(0, "林兄別急，凡事慢慢來．", 0, 1);
    exit();
::label0::
    Talk(0, "不然這樣好了，我和林兄一起去，殺光他青城派．", 0, 1);
    if TeamIsFull() == false then goto label1 end;
        Talk(36, "你的隊伍已滿，我無法加入．", 36, 0);
        exit();
::label1::
        Talk(36, "真的，我們走吧．", 36, 0);
        DarkScene();
        ModifyEvent(-2, -2, 0, 0, -1, -1, -1, -1, -1, -1, -2, -2, -2);
        ModifyEvent(36, 3, -2, -2, 315, -1, -1, -2, -2, -2, -2, -2, -2);
        LightScene();
        Join(36);
        AddEthics(-4);
exit();
