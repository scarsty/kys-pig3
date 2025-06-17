Talk(70, "怎麼？你也對繪畫感興趣？那你來試試這個。", -2, 0, 0, 0);
instruct_50(43, 0, 217, 1, 23, 0, 0);
if CheckJumpFlag() == true then goto label0 end;
    Talk(70, "失敗了啊，沒關係，下次再來。", -2, 0, 0, 0);
    exit();
::label0::
    Talk(70, "不錯嘛，這幅畫就送給你吧！", -2, 0, 0, 0);
    GetItem(230, 1);
    ShowTitle("系統提示：玩家可以自定義頭像。具體方法請訪問www.txdx.net。", 28421);
    ModifyEvent(15, 42, 1, 0, 1643, 0, 0, 7040, 7040, 7040, 0, -2, -2);
exit();
