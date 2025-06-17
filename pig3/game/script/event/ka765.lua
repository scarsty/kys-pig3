instruct_50(17, 0, 0, 166, 72, 0, 0);
instruct_50(4, 0, 4, 0, 5, 0, 0);
if CheckJumpFlag() == true then goto label0 end;
    Talk(68, "怎麼，又想跟我的木人較量較量？", -2, 0, 0, 0);
    instruct_50(43, 2, 246, 0, 0, 0, 0);
    if CheckJumpFlag() == true then goto label1 end;
        Talk(68, "沒關係，仔細想想，其實啊，這木頭腦袋很笨的。", -2, 0, 0, 0);
        exit();
::label1::
        Talk(68, "這木頭腦袋還真是不行，我得想法改進改進我的木人了。這個鏟子就送給你吧。", -2, 0, 0, 0);
        instruct_50(17, 0, 0, 166, 72, 0, 0);
        instruct_50(3, 0, 0, 0, 0, 1, 0);
        instruct_50(16, 4, 0, 166, 72, 0, 0);
        GetItem(240, 1);
        exit();
::label0::
        Talk(68, "呵呵，看來我的木人奈何不了你了。", -2, 0, 0, 0);
exit();
