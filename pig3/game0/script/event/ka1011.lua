if UseItem(154) == true then goto label0 end;
    exit();
::label0::
    AddItem(154, -1);
    ModifyEvent(-2, -2, -2, -2, -1, -1, -1, 4664, 4664, 4664, -2, -2, -2);
    if Judge14BooksPlaced() == true then goto label1 end;
        exit();
::label1::
        PlayWave(23);
        Talk(0, "咦！好像有什麼聲音．", 0, 1);
        DarkScene();
        SetSceneMap(-2, 1, 18, 25, 0);
        SetSceneMap(-2, 1, 18, 26, 0);
        LightScene();
exit();
