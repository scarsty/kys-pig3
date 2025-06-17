if HaveItem(253) == false then goto label0 end;
    if HaveItem(254) == false then goto label1 end;
        if HaveItem(255) == false then goto label2 end;
            if InTeam(17) == true then goto label3 end;
                Talk(0, "姑娘請看這些東西是否合用？", -2, 1, 0, 0);
                Talk(102, "太好了，東西都齊了，我這就去趕製法衣。", -2, 0, 0, 0);
                DarkScene();
                AddItem(254, -1);
                AddItem(255, -1);
                AddItem(253, -1);
                LightScene();
                Talk(102, "終於趕出來了，還得麻煩少俠把這件衣服帶給尊主。", -2, 1, 0, 0);
                Talk(0, "姑娘真是好手藝，這麼短的時間居然能縫製出這樣一件華服！不如你和我們一道回歸雲莊把這件衣服親手交給虛竹兄弟吧，有什麼不合適的也能馬上改改，我和他說一聲，不算你抗命下山的。", -2, 0, 0, 0);
                Talk(102, "少俠言之有理，那我這就去歸雲莊。", -2, 1, 0, 0);
                DarkScene();
                ModifyEvent(101, 34, 0, 0, 0, 0, 0, 0, 0, 0, 0, -2, -2);
                LightScene();
                instruct_50(43, 0, 209, 70, 2, 0, 0);
                instruct_50(43, 0, 228, 70, 102, 0, 0);
                ModifyEvent(15, 84, 1, 0, 799, 1398, 0, 7286, 7286, 7286, 0, -2, -2);
                exit();
::label3::
                Talk(0, "姑娘請看這些東西是否合用？", -2, 0, 0, 0);
                Talk(102, "太好了，東西都齊了，我這就去趕製法衣。", -2, 1, 0, 0);
                DarkScene();
                AddItem(254, -1);
                AddItem(255, -1);
                AddItem(253, -1);
                LightScene();
                Talk(102, "終於趕出來了，奴婢工夫粗陋，請尊主賞穿。", -2, 0, 0, 0);
                Talk(17, "哇，這麼合身？符姑娘不愧是“針神”，這麼短的時間居然能縫製出這樣一件華服！我看歸雲莊裡許多朋友的衣衫也挺破的……不如你和我們一道回歸雲莊吧，給他們也做幾件衣服，好不好？", -2, 1, 0, 0);
                Talk(102, "婢子遵命。", -2, 0, 0, 0);
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
