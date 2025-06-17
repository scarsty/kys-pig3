function f1()
	putbattlepro(-1,b,33);
	putbattlepro(-1,b,34);
	putbattlepro(-1,b,35);
	putbattlepro(-1,b,36);
	putbattlepro(-1,b,37);
	putbattlepro(-1,b,38);
end


	dongfang=226;
	zhang=280;
	wuming=181;
	murong=882;
	cheng=881;
	
	math.randomseed(os.time());
	b=293;  ---293戰鬥為原來的“決戰慕容復”，在目前版本中並未使用

	showtitle("絕世高手**你將依次挑戰4個絕世高手：東方不敗、張三丰、無名老僧、慕容復。請自己選擇出場人員，當然單挑是最難的。");
	rest();
	talk(dongfang, '東方不敗向閣下討教。', -2)
	talk(0, '葵花神功，天下閃避第一，如何應對呢？', -2, 1)
	setbattlename(b, "東方不敗");
	f1();
	putbattlepro(dongfang,b,33+math.random(0,5));
	trybattle(b);
	rest();
	
	talk(zhang, '小兄弟，小心接招。', -2)
	talk(0, '張真人教我神並天地，他自己一定也會這招吧。', -2, 1)
	setbattlename(b, "張三丰");
	f1();
	putbattlepro(zhang,b,33+math.random(0,5));
	trybattle(b);
	rest();
	
	talk(wuming, '今天被製作人叫出來活動一下筋骨。', -2)
	talk(0, '這老僧攻擊防禦都高的誇張啊，我能贏嗎？', -2, 1)
	setbattlename(b, "無名老僧");
	f1();
	putbattlepro(wuming,b,33+math.random(0,5));
	trybattle(b);
	rest();
	
	talk(149, '一群人你能贏我，一個人你還能贏我嗎？', -2)
	talk(0, '慕容復家傳的斗轉星移從逍遙派武功中得了好處，更難對付了。', -2, 1)
	setbattlename(b, "慕容復");
	f1();
	putbattlepro(murong,b,33+math.random(0,5));
	trybattle(b);
	rest();
	
	talk(dongfang, '這次我們一起上，你也多叫幾個人來吧！', -2)
	talk(303, '嘿嘿，我也來湊個數。', -2)
	talk(0, '………………………………', -2, 1)
	setbattlename(b, "絕世高手");
	f1();
	putbattlepro(dongfang,b,34);
	putbattlepro(zhang,b,35);
	putbattlepro(wuming,b,36);
	putbattlepro(murong,b,33);
	putbattlepro(cheng,b,37);
	if trybattle(b) then
		talk(0, '看來我已經無敵了。', -2, 1);
	else
		talk(0, '製作人你玩我是吧……', -2, 1);
	end;
	rest();

	

