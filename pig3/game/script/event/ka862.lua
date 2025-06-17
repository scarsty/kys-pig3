if InTeam(11) == true then goto label0 end;
    Talk(0, "陳公子，此去前路只怕凶險甚多，在下想請公子助我們一臂之力。", -2, 0, 0, 0);
    instruct_50(17, 0, 0, 166, 44, 0, 0);
    instruct_50(4, 0, 2, 0, 1, 0, 0);
    if CheckJumpFlag() == true then goto label1 end;
        Talk(15, "陳某心中另有要事，請少俠另尋他人罷。", -2, 1, 0, 0);
        exit();
::label1::
        Talk(15, "玉瓶，滿清皇帝一定是看到了那玉瓶上的美人，不行，我要跟你們一起去救香香！", -2, 1, 0, 0);
        DarkScene();
        ModifyEvent(84, 14, 0, 0, 0, 0, 0, 0, 0, 0, 0, -2, -2);
        LightScene();
        instruct_50(43, 0, 228, 30, 15, 0, 0);
        instruct_50(43, 0, 209, 30, 1, 0, 0);
        ModifyEvent(16, 20, 1, 0, 715, 0, 0, 7168, 7168, 7168, 0, -2, -2);
        GetItem(77, 1);
        exit();
::label0::
        Talk(0, "陳公子，此去前路只怕凶險甚多，在下想請公子助我們一臂之力。", -2, 0, 0, 0);
        Talk(15, "你救回了喀絲麗，我便跟你走一趟罷。", -2, 1, 0, 0);
        DarkScene();
        ModifyEvent(84, 14, 0, 0, 0, 0, 0, 0, 0, 0, 0, -2, -2);
        LightScene();
        instruct_50(43, 0, 228, 30, 15, 0, 0);
        instruct_50(43, 0, 209, 30, 1, 0, 0);
        ModifyEvent(16, 20, 1, 0, 715, 0, 0, 7168, 7168, 7168, 0, -2, -2);
        GetItem(77, 1);
exit();
