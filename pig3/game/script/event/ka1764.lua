if UseItem(240) == true then goto label0 end;
    exit();
::label0::
    GetItem(240, -1);
    Talk(0, "以眼還眼，以牙還牙；犯我禁忌，皆為仇讎。小子，這可是天堂有路你不走，地獄無門你自尋。", "火工頭陀", 0, 1, 0);
    Talk(0, "死道友不死貧道。嘿，小子，你居然被這禿驢盯上，那可就怨不得我了。", "百損道人", 0, 1, 0);
    if TryBattle(286) == true then goto label1 end;
        Dead();
        LightScene();
        exit();
::label1::
        instruct_50(17, 0, 0, 0, 146, 0, 0);
        instruct_50(3, 0, 0, 0, 0, 100, 0);
        instruct_50(16, 4, 0, 0, 146, 0, 0);
        LightScene();
        Talk(0, "總有一天……", "火工頭陀", 0, 1, 0);
        Talk(0, "嘿，這次卻是老道我錯了。可惜壞事還沒做夠啊……", "百損道人", 0, 1, 0);
        ModifyEvent(128, 4, 1, 0, 1765, 0, 0, 6698, 6698, 6698, 0, -2, -2);
exit();
