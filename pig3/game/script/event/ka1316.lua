if InTeam(17) == true then goto label0 end;
    Talk(415, "＜到星宿海清理門戶，還是帶上虛竹兄弟，讓他親自動手比較好。＞", -2, 1, 0, 0);
    exit();
::label0::
    Talk(345, "站住，何人膽敢擅闖星宿海？", -2, 0, 0, 0);
    Talk(414, "這裡就是星宿海？既沒有星宿也沒有海，看來這地方的名字還真跟這地方的主人一樣浪得虛名哩。", -2, 1, 0, 0);
    Talk(345, "住口，星宿老仙法力無邊，德配天地，豈容你這小子抵毀！", -2, 0, 0, 0);
    if TryBattle(183) == true then goto label1 end;
        Dead();
exit();
::label1::
        LightScene();
        Talk(345, "唉喲，疼死我啦！哼哼……你現在有命進去，待會沒命出來，可不是我們沒提醒過你……", -2, 1, 0, 0);
        DarkScene();
        ModifyEvent(102, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, -2, -2);
        LightScene();
exit();
