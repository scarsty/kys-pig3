DarkScene();
a=getsceneeventpro(15,29,5);--这四条先把原来大厅里的陆程两人重置。
b=getsceneeventpro(15,28,5);
PutSceneEventPro(0,15,29,5);
PutSceneEventPro(0,15,28,5);
PutSceneMapPro(4157*2,15,1,5,26);
PutSceneMapPro(4158*2,15,1,5,27);
PutSceneMapPro(4156*2,15,1,5,25);
PutSceneMapPro(3537*2,15,1,7,25);
PutSceneMapPro(3538*2,15,1,8,25);
c=getscenemappro(29,1,23,28);--如果在南部隘口攻破之后玩此列传，则重新把五毒教众贴图放上去。
if c<=0 then
	PutSceneMapPro(3398*2,29,1,33,32);
	PutSceneMapPro(3398*2,29,1,33,30);
	PutSceneMapPro(3398*2,29,1,30,35);
	PutSceneMapPro(3398*2,29,1,30,33);
	PutSceneMapPro(3398*2,29,1,30,31);
	PutSceneMapPro(3398*2,29,1,30,29);
	PutSceneMapPro(3398*2,29,1,30,27);
	PutSceneMapPro(3398*2,29,1,27,26);
	PutSceneMapPro(3398*2,29,1,27,34);
	PutSceneMapPro(3398*2,29,1,32,31);
	PutSceneMapPro(4160*2,29,1,27,32);
	PutSceneMapPro(4161*2,29,1,27,28);
	PutSceneMapPro(4162*2,29,1,27,30);
end
setshowmainrole(0);
LightScene();
ScenefromTo(18,8,7,25);
ShowTitle("突擊南部隘口", 1);
Talk(47, "冠英，瑤迦，你們回來有些日子了，襄陽那邊？", -2, 1, 0, 0);
Talk(72, "爹，襄陽有郭兄夫婦鎮守，沒那麼容易被韃子攻下的。", -2, 0, 0, 0);
Talk(47, "話雖如此，但我總覺得黃河三鬼這次來得太巧了一些，好像是專程把你們引回來一樣。", -2, 1, 0, 0);
Talk(72, "莫非其中有詐？", -2, 0, 0, 0);
Talk(47, "我也說不準，只是隱隱覺得，三鬼既然找上門來口口聲聲要報仇，為何與之串通一氣的譚青和四大惡人卻又不見蹤影。", -2, 1, 0, 0);
Talk(73, "爹的意思是，有人故意為之，目的是為了孤立郭兄夫婦麼？", -2, 0, 0, 0);
Talk(47, "不怕一萬，就怕萬一啊。冠英，你和瑤迦收拾一下，快些返回襄陽吧。", -2, 1, 0, 0);
Talk(72, "這，爹，三鬼雖被擊退，卻尚未伏誅，若是去而復返…", -2, 0, 0, 0);
Talk(47, "放心吧，爹雖然老了，卻還淪落到被三隻小鬼欺負的地步。", -2, 1, 0, 0);
Talk(72, "爹….", -2, 0, 0, 0);
Talk(47, "怎麼，你是對爹沒信心麼。", -2, 1, 0, 0);
Talk(72, "孩兒不敢，那爹，您多保重。", -2, 0, 0, 0);
Talk(47, "恩，去吧。", -2, 1, 0, 0);
PutSceneMapPro(3537*2,29,1,34,28);
PutSceneMapPro(3538*2,29,1,35,28);
DarkScene();
ChangeScene(29,31,30);
ScenefromTo(23,30,34,31);
LightScene();
Talk(72, "奇怪，隘口怎麼這麼多苗人。", -2, 0, 0, 0);
Talk(73, "苗人，難道是五毒教？", -2, 1, 0, 0);
Talk(72, "五毒教，這群邪魔外道在搞什麼鬼？", -2, 0, 0, 0);
Talk(350, "什麼人，膽敢在此窺視。", -2, 1, 0, 0);
Talk(72, "爾等封鎖南部隘口，意欲何為。", -2, 0, 0, 0);
Talk(350, "接教主法令，即日起南部隘口準進不準出，擅闖者殺無赦。", -2, 1, 0, 0);
Talk(72, "好大的口氣，倒要看看你們有沒有這個本事。", -2, 0, 0, 0);
Talk(350, "有人闖關，速速通知幾位護法。", -2, 1, 0, 0);
if TryBattle(302) == false then 
	Dead();
	LightScene();
	exit();
else
	Talk(72, "五毒教也不過如此。", -2, 0, 0, 0);
	Talk(123, "什麼人在此撒野。", -2, 1, 0, 0);
	Talk(72, "歸雲莊陸冠英。", -2, 0, 0, 0);
	Talk(125, "我道是誰，原來是太湖草寇的頭頭，在水裡稱王稱霸是你的事兒，怎麼，上了岸，你還想在我們面前蹦躂麼。", -2, 1, 0, 0);
	Talk(72, "貴教在此佈置，阻人北上，是何道理。", -2, 0, 0, 0);
	Talk(125, "哈哈，不知陸兄弟是要去哪裡啊。", -2, 1, 0, 0);
	Talk(72, "襄陽。", -2, 0, 0, 0);
	Talk(125, "那就對不住了，此路不通。", -2, 1, 0, 0);
	Talk(72, "貴教未免管得太寬了吧。", -2, 0, 0, 0);
	Talk(123, "和他囉嗦什麼，想去襄陽幫郭靖黃蓉的人統統都不準過。", -2, 1, 0, 0);
	Talk(124, "住口，你忘了師父怎麼交待的麼。", -2, 0, 0, 0);
	Talk(123, "你們這群賊子果然包藏禍心。", -2, 1, 0, 0);
	Talk(72, "襄陽。", -2, 0, 0, 0);
	Talk(125, "媽的，真是人頭豬腦，姓陸的，你既然知道了，就給我留下吧。", -2, 1, 0, 0);
	Talk(73, "夫君，我來幫你。", -2, 1, 0, 0);
	Talk(72, "瑤迦，你在一旁替我掠陣，以防這群賊子暗箭傷人。", -2, 0, 0, 0);
	Talk(73, "冠英你要當心啊。", -2, 1, 0, 0);
	if TryBattle(303) == false then 
		Dead();
		LightScene();
		exit();
	else
		Talk(123, "咳咳咳咳，姓陸的果然好手段。", -2, 0, 0, 0);
		Talk(124, "快通知師父。", -2, 1, 0, 0);
		Talk(125, "眾弟子聽令，把他們給我圍起來。", -2, 0, 0, 0);
		Talk(350, "是！", -2, 1, 0, 0);
		Talk(73, "冠英，他們人多勢眾，不宜硬拼。", -2, 0, 0, 0);
		Talk(72, "哼，邪魔小丑，容你們得意一時，早晚和你們算這筆賬。", -2, 0, 0, 0);
		DarkScene();
		if c<=0 then
			PutSceneMapPro(0,29,1,33,32);
			PutSceneMapPro(0,29,1,33,30);
			PutSceneMapPro(0,29,1,30,35);
			PutSceneMapPro(0,29,1,30,33);
			PutSceneMapPro(0,29,1,30,31);
			PutSceneMapPro(0,29,1,30,29);
			PutSceneMapPro(0,29,1,30,27);
			PutSceneMapPro(0,29,1,27,26);
			PutSceneMapPro(0,29,1,27,34);
			PutSceneMapPro(0,29,1,32,31);
			PutSceneMapPro(0,29,1,27,32);
			PutSceneMapPro(0,29,1,27,28);
			PutSceneMapPro(0,29,1,27,30);
		end
		PutSceneEventPro(a,15,29,5);
		PutSceneEventPro(b,15,28,5);
		PutSceneMapPro(0,15,1,5,26);
		PutSceneMapPro(0,15,1,5,27);
		PutSceneMapPro(0,15,1,5,25);
		PutSceneMapPro(0,15,1,7,25);
		PutSceneMapPro(0,15,1,8,25);
		PutSceneMapPro(0,29,1,34,28);
		PutSceneMapPro(0,29,1,35,28);
		changescene(15,8,18)
		setshowmainrole(1);
		LightScene();
	end
end