if UseItem(186) == true then goto label0 end;
    exit();
::label0::
    AddItem(186, -1);
    Talk(73, "江湖中有些地方，像摩天崖及雲鶴崖這兩地，若是隊伍中沒有輕功高強者是上不去的．還有些地方則是要找到它的入口後才進得去．", 73, 0);
    Add3EventNum(-2, 0, 0, 1, -1)
exit();
