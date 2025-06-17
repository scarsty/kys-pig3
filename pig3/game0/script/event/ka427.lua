Talk(65, "真希望瑛姑趕快來殺我，解除我的罪孽．", 65, 0);
if AskBattle() == true then goto label0 end;
    Talk(0, "．．．．", 0, 1);
    exit();
::label0::
    AddEthics(-1);
    if TryBattle(68) == false then goto label1 end;
        ModifyEvent(21, 1, -2, -2, 420, -1, -1, -2, -2, -2, -2, -2, -2);
        ModifyEvent(-2, -2, -2, -2, -1, -1, -1, 6226, 6226, 6226, -2, -2, -2);
        LightScene();
        AddEthics(-10);
        AddRepute(10);
        exit();
::label1::
        LightScene();
        Talk(65, "閣下還是回去請瑛姑親自來動手吧，我會在這等她的．", 65, 0);
exit();
