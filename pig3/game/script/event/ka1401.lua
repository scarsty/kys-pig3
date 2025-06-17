if UseItem(259) == true then goto label0 end;
    exit();
::label0::
    Talk(0, "符姑娘，此物可行？", -2, 0, 0, 0);
    Talk(102, "星宿柔絲索，通體由雪蠶絲所制。有了它，或許可以修復乾坤一氣袋。請公子稍等。", -2, 1, 0, 0);
    DarkScene();
    AddItem(259, -1);
    LightScene();
    Talk(102, "不出我所料，雪蠶絲果然可與這袋子契合。此物便交與公子了。", -2, 0, 0, 0);
    Talk(0, "謝過符姑娘。", -2, 1, 0, 0);
    Talk(102, "小事不足掛齒。", -2, 0, 0, 0);
    GetItem(51, 1);
exit();
