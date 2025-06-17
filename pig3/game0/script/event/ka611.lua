Talk(71, "小兄弟，得手了嗎？", 71, 0);
Talk(0, "哼！我差點就被你利用了．", 0, 1);
Talk(71, "你都知道了．", 71, 0);
Talk(0, "”鹿鼎記”是不是還在你這邊，老頭！", 0, 1);
Talk(71, "是在我這沒錯，你想怎樣？", 71, 0);
Talk(0, "我想怎樣！我想好好搥你一頓．", 0, 1);
if TryBattle(95) == true then goto label0 end;
    Dead();
    exit();
::label0::
    ModifyEvent(-2, -2, -2, -2, 612, -1, -1, -2, -2, -2, -2, -2, -2);
    LightScene();
    GetItem(150, 1);
    AddRepute(8);
exit();
