Join(12);
ModifyEvent(16, 17, 0, 0, 0, 0, 0, 0, 0, 0, 0, -2, -2);
instruct_50(43, 0, 209, 12, 3, 0, 0);
if InTeam(13) == false then goto label0 end;
    instruct_50(43, 0, 233, 12, 0, 0, 0);
    instruct_50(43, 8, 231, 12, 164, 28931, 0);
    instruct_50(16, 0, 0, 13, 128, 164, 0);
::label0::
    if InTeam(11) == false then goto label1 end;
        if InTeam(76) == false then goto label2 end;
            instruct_50(43, 0, 233, 11, 0, 0, 0);
            instruct_50(43, 8, 231, 11, 174, 28931, 0);
            instruct_50(43, 0, 233, 12, 0, 0, 0);
            instruct_50(43, 8, 231, 12, 174, 28931, 0);
            instruct_50(43, 0, 233, 76, 0, 0, 0);
            instruct_50(43, 8, 231, 76, 174, 28931, 0);
::label1::
::label2::
exit();
