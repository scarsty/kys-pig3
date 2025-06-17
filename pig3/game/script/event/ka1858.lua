instruct_50(0, 2000, -1, 0, 0, 0, 0);
::label1::
instruct_50(3, 0, 0, 2000, 2000, 1, 0);
instruct_50(19, 1, 2000, 1000, 0, 0, 0);
instruct_50(4, 0, 0, 1000, 0, 0, 0);
if CheckJumpFlag() == true then goto label0 end;
    instruct_50(17, 1, 0, 1000, 88, 3000, 0);
    instruct_50(3, 0, 0, 3000, 3000, 10, 0);
    instruct_50(16, 5, 0, 1000, 88, 3000, 0);
    instruct_50(4, 0, 6, 0, 0, 0, 0);
    if CheckJumpFlag() == true then goto label1 end;
        exit();
::label0::
        ShowTitle("全隊輕功增加10", 0);
exit();
