Talk(18, "你搜集了不少武功祕籍啊，想知道哪個武功的情況呢？", -2, 0, 0, 0);
instruct_50(43, 0, 253, 0, 0, 0, 0);
instruct_50(4, 0, 2, 28931, -1, 0, 0);
if CheckJumpFlag() == true then goto label0 end;
    instruct_50(3, 0, 0, 0, 28931, 14123, 0);
    --instruct_50(43, 4, 201, 18, 0, -2, 0);
    Talk(18, getx50(0));
::label0::
exit();
