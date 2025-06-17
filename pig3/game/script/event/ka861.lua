Talk(48, "還沒找到嗎？", -2, 1, 0, 0);
instruct_50(20, 0, 199, 0, 0, 0, 0);
instruct_50(4, 0, 4, 0, 4, 0, 0);
if CheckJumpFlag() == true then
    Talk(0, "趙三爺，這是閣下的飛燕銀梭。", -2, 0, 0, 0);
    Talk(48, "唔，一枚不少，多謝小兄弟了。", -2, 1, 0, 0);
    DarkScene();
    ModifyEvent(84, 8, 0, 0, 0, 0, 0, 0, 0, 0, 0, -2, -2);
    LightScene();
    instruct_50(43, 0, 228, 42, 48, 0, 0);
    instruct_50(43, 0, 209, 42, 1, 0, 0);
    ModifyEvent(16, 36, 1, 0, 748, 0, 0, 7198, 7198, 7198, 0, -2, -2);
    GetItem(199, 100);
end
exit();