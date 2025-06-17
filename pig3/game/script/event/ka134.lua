Join(85);
ModifyEvent(15, 35, 0, 0, 0, 0, 0, 0, 0, 0, 0, -2, -2);
instruct_50(43, 0, 209, 64, 3, 0, 0);
if InTeam(66) == false then goto label0 end;
    if InTeam(25) == false then goto label1 end;
        instruct_50(43, 0, 233, 25, 0, 0, 0);
        instruct_50(43, 8, 231, 25, 169, 28931, 0);
        instruct_50(43, 0, 233, 66, 0, 0, 0);
        instruct_50(43, 8, 231, 66, 169, 28931, 0);
        instruct_50(43, 0, 233, 85, 0, 0, 0);
        instruct_50(43, 8, 231, 85, 169, 28931, 0);
::label0::
::label1::
exit();
