if UseItem(186) == true then goto label0 end;
    exit();
::label0::
    AddItem(186, -1);
    Talk(73, "有幾個同伴是必需加入的．石破天，段譽，胡斐．", 73, 0);
    Add3EventNum(-2, 0, 0, 1, -1)
exit();
