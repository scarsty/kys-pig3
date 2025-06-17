Join(1);
ModifyEvent(16, 8, 0, 0, 0, 0, 0, 0, 0, 0, 0, -2, -2);
instruct_50(43, 0, 209, 1, 3, 0, 0);
if InTeam(17) == false then goto label0 end;
    if InTeam(4) == false then goto label1 end;
        if InTeam(28) == false then goto label2 end;
            instruct_50(43, 0, 233, 1, 0, 0, 0);
            instruct_50(43, 8, 231, 1, 171, 28931, 0);
            instruct_50(43, 0, 233, 4, 0, 0, 0);
            instruct_50(43, 8, 231, 4, 171, 28931, 0);
            instruct_50(43, 0, 233, 17, 0, 0, 0);
            instruct_50(43, 8, 231, 17, 171, 28931, 0);
            instruct_50(43, 0, 233, 28, 0, 0, 0);
            instruct_50(43, 8, 231, 28, 171, 28931, 0);
::label0::
::label1::
::label2::
exit();
