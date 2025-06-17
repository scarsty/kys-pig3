instruct_50(3, 0, 0, 8000, 28928, 0, 0);
instruct_50(3, 0, 0, 8100, 28929, 0, 0);
instruct_50(0, 7100, 0, 0, 0, 0, 0);
instruct_50(0, 6000, 0, 0, 0, 0, 0);
instruct_50(0, 6000, 0, 0, 0, 0, 0);
::label0::
instruct_50(3, 0, 2, 7200, 7100, 100, 0);
instruct_50(3, 0, 0, 7200, 7200, 2000, 0);
instruct_50(1, 3, 0, 30, 7100, 7200, 0);
instruct_50(3, 0, 0, 7100, 7100, 1, 0);
instruct_50(4, 1, 2, 7100, 8100, 0, 0);
if CheckJumpFlag() == false then goto label0 end;
::label1::
    instruct_50(3, 0, 2, 6100, 6000, 100, 0);
    instruct_50(3, 0, 0, 6100, 6100, 2000, 0);
    instruct_50(32, 0, 6100, 4, 0, 0, 0);
    instruct_50(8, 1, 8000, 250, 0, 0, 0);
    instruct_50(3, 0, 0, 6000, 6000, 1, 0);
    instruct_50(3, 0, 0, 8000, 8000, 1, 0);
    instruct_50(4, 1, 2, 6000, 8100, 0, 0);
    if CheckJumpFlag() == false then goto label1 end;
        instruct_50(40, 2561, 8100, 30, 10, 100, 50);
        instruct_50(4, 0, 2, 10, 0, 0, 0);
        if CheckJumpFlag() == false then goto label2 end;
            exit();
::label2::
            instruct_50(3, 0, 1, 1234, 10, 1, 0);
            instruct_50(32, 0, 1234, 1, 0, 0, 0);
            PlayMusic(19);
exit();
