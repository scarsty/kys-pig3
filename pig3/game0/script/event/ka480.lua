Talk(105, "客倌，看你一身打扮，不像是本地人，大老遠趕來，想必旅途一定勞累了．要不要在這住上一宿，讓你的體力，元氣恢復恢復．", 105, 0);
if AskRest() == true then goto  label0 end;
    exit();
::label0::
    if JudgeMoney(50) == true then goto label1 end;
        Talk(105, "走，走，走，沒錢就不要妨礙我做生意！", 105, 0);
        exit();
::label1::
        Talk(0, "好，我就試試看你們高昇客棧的服務好不好．", 0, 1);
        DarkScene();
        Rest();
        AddItem(174, -50);
        SetScenePosition2(38, 18);
        SetRoleFace(3);
        LightScene();
exit();
