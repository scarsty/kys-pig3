Join(13);
ModifyEvent(16, 18, 0, 0, 0, 0, 0, 0, 0, 0, 0, -2, -2);
instruct_50(43, 0, 209, 13, 3, 0, 0);
if InTeam(12) == false then goto label0 end;
    instruct_50(43, 0, 233, 12, 0, 0, 0);
    instruct_50(43, 8, 231, 12, 164, 28931, 0);
    instruct_50(16, 0, 0, 13, 128, 164, 0);
::label0::
    if InTeam(8) == false then goto label1 end;
        if InTeam(44) == false then goto label2 end;
            instruct_50(43, 0, 233, 8, 0, 0, 0);
            instruct_50(43, 8, 231, 8, 168, 28931, 0);
            instruct_50(43, 0, 233, 13, 0, 0, 0);
            instruct_50(43, 8, 231, 13, 168, 28931, 0);
            instruct_50(43, 0, 233, 44, 0, 0, 0);
            instruct_50(43, 8, 231, 44, 168, 28931, 0);
::label1::
::label2::
            if InTeam(8) == false then goto label3 end;
                if InTeam(42) == false then goto label4 end;
                    if InTeam(51) == false then goto label5 end;
                        if InTeam(46) == false then goto label6 end;
                            instruct_50(43, 0, 233, 8, 0, 0, 0);
                            instruct_50(43, 8, 231, 8, 175, 28931, 0);
                            instruct_50(43, 0, 233, 13, 0, 0, 0);
                            instruct_50(43, 8, 231, 13, 175, 28931, 0);
                            instruct_50(43, 0, 233, 42, 0, 0, 0);
                            instruct_50(43, 8, 231, 42, 175, 28931, 0);
                            instruct_50(43, 0, 233, 51, 0, 0, 0);
                            instruct_50(43, 8, 231, 51, 175, 28931, 0);
                            instruct_50(43, 0, 233, 46, 0, 0, 0);
                            instruct_50(43, 8, 231, 46, 175, 28931, 0);
::label3::
::label4::
::label5::
::label6::
exit();
