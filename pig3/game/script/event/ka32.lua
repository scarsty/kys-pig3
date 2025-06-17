Join(16);
ModifyEvent(16, 21, 0, 0, 0, 0, 0, 0, 0, 0, 0, -2, -2);
instruct_50(43, 0, 209, 16, 3, 0, 0);
if InTeam(17) == false then goto label0 end;
    if InTeam(8) == false then goto label1 end;
        if InTeam(51) == false then goto label2 end;
            instruct_50(43, 0, 233, 8, 0, 0, 0);
            instruct_50(43, 8, 231, 8, 170, 28931, 0);
            instruct_50(43, 0, 233, 16, 0, 0, 0);
            instruct_50(43, 8, 231, 16, 170, 28931, 0);
            instruct_50(43, 0, 233, 17, 0, 0, 0);
            instruct_50(43, 8, 231, 17, 170, 28931, 0);
            instruct_50(43, 0, 233, 51, 0, 0, 0);
            instruct_50(43, 8, 231, 51, 170, 28931, 0);
::label0::
::label1::
::label2::
exit();
