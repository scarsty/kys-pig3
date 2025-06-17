Talk(0, "賢弟，我們走了吧．", 0, 1);
if TeamIsFull() == false then goto label0 end;
    Talk(49, "你的隊伍已滿，我無法加入．", 49, 0);
    exit();
::label0::
    DarkScene();
    ModifyEvent(-2, 2, 0, 0, -1, -1, -1, -1, -1, -1, -2, -2, -2);
    LightScene();
    AddMP(49, 300);
    AddHP(49, 200);
    AddAttack(49, 30);
    AddSpeed(49, 20);
    LearnMagic2(49, 15, 0);
    SetPersonMPPro(person(49),2);
    Join(49);
exit();
