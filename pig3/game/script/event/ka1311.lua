if HaveItem(253) == false then goto label0 end;
    if HaveItem(254) == false then goto label1 end;
        if HaveItem(255) == false then goto label2 end;
            Talk(0, "你看這些東西是否合用？", -2, 1, 0, 0);
            Talk(102, "多謝尊主，東西都齊了，我這就去趕製法衣。", -2, 0, 0, 0);
            DarkScene();
            AddItem(254, -1);
            AddItem(255, -1);
            AddItem(253, -1);
            LightScene();
            Talk(102, "終於趕出來了，奴婢工夫粗陋，請尊主賞穿。", -2, 1, 0, 0);
            Talk(422, "不愧是本宮針神，真是好手藝，這麼短的時間居然能縫製出這樣一件華服！不如你和我們一道回歸雲莊吧，可以幫其他朋友也做些衣服，放心，不算你抗命下山的。", -2, 0, 0, 0);
            Talk(102, "婢子遵命。", -2, 1, 0, 0);
            DarkScene();
            ModifyEvent(101, 34, 0, 0, 0, 0, 0, 0, 0, 0, 0, -2, -2);
            LightScene();
            instruct_50(43, 0, 209, 70, 2, 0, 0);
            instruct_50(43, 0, 228, 70, 102, 0, 0);
            ModifyEvent(15, 84, 1, 0, 799, 1398, 0, 7286, 7286, 7286, 0, -2, -2);
            exit();
::label0::
::label1::
::label2::
            Talk(102, "蘇州蠶絲製品聞名天下，杭州盛產錦緞，關外的灰貂毛色最好。", -2, 0, 0, 0);
exit();
