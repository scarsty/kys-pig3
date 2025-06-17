if HaveItem(236) == false then goto label0 end;
    if HaveItem(238) == false then goto label1 end;
        if HaveItem(237) == false then goto label2 end;
            Talk(0, "前輩，這幾樣東西都找齊了。", -2, 0, 0, 0);
            Talk(225, "哦？好，太好了。令狐兄弟有救了，咱們走！", -2, 1, 0, 0);
            Talk(8, "去哪？", -2, 0, 0, 0);
            Talk(225, "孤山梅莊！", -2, 1, 0, 0);
            DarkScene();
            ModifyEvent(19, 26, 0, 0, 0, 0, 0, 0, 0, 0, 0, -2, -2);
            ModifyEvent(19, 27, 0, 0, 0, 0, 0, 0, 0, 0, 0, -2, -2);
            ModifyEvent(28, 3, 0, 0, 0, 0, 0, 0, 0, 0, 0, -2, -2);
            AddItem(236, -1);
            AddItem(237, -1);
            AddItem(238, -1);
            LightScene();
            exit();
::label0::
::label1::
::label2::
            Talk(225, "還沒有找齊嗎？", -2, 0, 0, 0);
exit();
