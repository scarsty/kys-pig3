if AskRest() == true then goto  label0 end;
    exit();
::label0::
    Talk(0, "為了走更遠的路，適當的休息也是必須的．我就好好的睡一覺吧！", 0, 1);
    DarkScene();
    Rest();
    SetRoleFace(3);
    LightScene();
    Talk(0, "一覺起來，精神十足．走吧，繼續冒險去了！", 0, 1);
exit();
