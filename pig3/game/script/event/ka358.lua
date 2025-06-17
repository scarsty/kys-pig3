instruct_50(26, 0, 0, 10590, 29, 200, 0);
instruct_50(26, 0, 0, 10588, 29, 201, 0);
instruct_50(26, 0, 0, 10586, 29, 202, 0);
instruct_50(24, 13, 200, 3, 201, 202, 203);
instruct_50(22, 3, 200, 203, 7, 204, 0);
instruct_50(3, 0, 2, 204, 204, -1, 0);
instruct_50(16, 5, 2, 200, 16, 204, 0);
instruct_50(16, 5, 2, 200, 44, 201, 0);
instruct_50(16, 5, 2, 200, 46, 202, 0);
instruct_50(22, 3, 200, 203, 8, 205, 0);
instruct_50(3, 0, 3, 206, 205, 100, 0);
instruct_50(3, 0, 4, 207, 205, 100, 0);
instruct_50(17, 1, 2, 200, 20, 208, 0);
instruct_50(17, 1, 2, 200, 22, 209, 0);
instruct_50(4, 0, 5, 208, 0, 0, 0);
if CheckJumpFlag() == true then goto label0 end;
    instruct_50(4, 0, 5, 209, 0, 0, 0);
    if CheckJumpFlag() == true then goto label1 end;
        instruct_50(16, 5, 2, 204, 48, 206, 0);
        instruct_50(16, 5, 2, 204, 50, 207, 0);
exit();
::label0::
::label1::
        instruct_50(16, 5, 2, 204, 28, 206, 0);
        instruct_50(16, 5, 2, 204, 30, 207, 0);
exit();
