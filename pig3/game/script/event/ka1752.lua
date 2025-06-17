instruct_50(0, 0, 0, 0, 0, 0, 0);
if InTeam(85) == false then goto label0 end;
    instruct_50(17, 0, 0, 166, 110, 0, 0);
::label0::
    instruct_50(0, 1, 0, 0, 0, 0, 0);
    if InTeam(84) == false then goto label1 end;
        instruct_50(17, 0, 0, 166, 112, 1, 0);
::label1::
        instruct_50(3, 1, 0, 2, 0, 1, 0);
        instruct_50(4, 0, 2, 2, 0, 0, 0);
        if CheckJumpFlag() == false then goto label2 end;
            instruct_50(16, 0, 0, 166, 116, 0, 0);
            exit();
::label2::
            instruct_50(4, 1, 0, 0, 1, 0, 0);
            if CheckJumpFlag() == true then goto label3 end;
                instruct_50(16, 0, 0, 166, 116, 1, 0);
                exit();
::label3::
                instruct_50(16, 0, 0, 166, 116, 2, 0);
exit();
