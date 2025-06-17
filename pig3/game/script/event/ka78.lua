Join(44);
ModifyEvent(16, 34, 0, 0, 0, 0, 0, 0, 0, 0, 0, -2, -2);
instruct_50(43, 0, 209, 56, 3, 0, 0);
if InTeam(8) == false then goto label0 end;
    if InTeam(13) == false then goto label1 end;
        instruct_50(43, 0, 233, 8, 0, 0, 0);
        instruct_50(43, 8, 231, 8, 168, 28931, 0);
        instruct_50(43, 0, 233, 13, 0, 0, 0);
        instruct_50(43, 8, 231, 13, 168, 28931, 0);
        instruct_50(43, 0, 233, 44, 0, 0, 0);
        instruct_50(43, 8, 231, 44, 168, 28931, 0);
::label0::
::label1::
exit();
