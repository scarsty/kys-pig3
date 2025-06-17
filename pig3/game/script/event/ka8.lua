Join(4);
ModifyEvent(16, 11, 0, 0, 0, 0, 0, 0, 0, 0, 0, -2, -2);
instruct_50(43, 0, 209, 4, 3, 0, 0);
if InTeam(92) == false then goto label0 end;
    if InTeam(93) == false then goto label1 end;
        instruct_50(43, 0, 233, 4, 0, 0, 0);
        instruct_50(43, 8, 231, 4, 167, 28931, 0);
        instruct_50(43, 0, 233, 92, 0, 0, 0);
        instruct_50(43, 8, 231, 92, 167, 28931, 0);
        instruct_50(43, 0, 233, 93, 0, 0, 0);
        instruct_50(43, 8, 231, 93, 167, 28931, 0);
::label0::
::label1::
        if InTeam(17) == false then goto label2 end;
            if InTeam(1) == false then goto label3 end;
                if InTeam(28) == false then goto label4 end;
                    instruct_50(43, 0, 233, 1, 0, 0, 0);
                    instruct_50(43, 8, 231, 1, 171, 28931, 0);
                    instruct_50(43, 0, 233, 4, 0, 0, 0);
                    instruct_50(43, 8, 231, 4, 171, 28931, 0);
                    instruct_50(43, 0, 233, 17, 0, 0, 0);
                    instruct_50(43, 8, 231, 17, 171, 28931, 0);
                    instruct_50(43, 0, 233, 28, 0, 0, 0);
                    instruct_50(43, 8, 231, 28, 171, 28931, 0);
::label2::
::label3::
::label4::
exit();
