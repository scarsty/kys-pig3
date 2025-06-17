instruct_50(0, 1032, 0, 0, 0, 0, 0);
instruct_50(0, 1075, -1, 0, 0, 0, 0);
instruct_50(0, 1080, 15, 0, 0, 0, 0);
::label0::
::label2::
::label4::
instruct_50(3, 0, 0, 1075, 1075, 1, 0);
instruct_50(30, 1, 1075, 10, 1076, 0, 0);
instruct_50(4, 0, 2, 1076, 1, 0, 0);
if CheckJumpFlag() == true then goto label0 end;
    instruct_50(30, 1, 1075, 0, 1077, 0, 0);
    instruct_50(4, 0, 2, 1077, -1, 0, 0);
    if CheckJumpFlag() == true then goto label1 end;
        instruct_50(30, 1, 1075, 2, 1079, 0, 0);
        instruct_50(4, 1, 2, 1079, 1074, 0, 0);
        if CheckJumpFlag() == true then goto label2 end;
            instruct_50(17, 1, 0, 1077, 110, 1078, 0);
            instruct_50(4, 1, 0, 1078, 1080, 0, 0);
            if CheckJumpFlag() == true then goto label3 end;
                instruct_50(3, 1, 0, 1032, 1032, 1078, 0);
::label3::
                instruct_50(4, 0, 0, 1075, 25, 0, 0);
                if CheckJumpFlag() == true then goto label4 end;
::label1::
exit();
