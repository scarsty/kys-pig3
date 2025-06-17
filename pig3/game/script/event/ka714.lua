if InTeam(8) == false then
	i=getsceneeventpro(16,19,4);
	if i==0 then
		math.randomseed(os.time())
		m=math.random(1,100);
		if m<=20 then
			DarkScene();
			putsceneeventpro(-1,16,19,4);
			LightScene();
			Talk(8, "哈哈，沒想到盈盈你也會彈奏這種殺氣騰騰的曲子，若不是知道你是鼎鼎大名的任大小姐，我還以為是京城裡的監市到出來巡查了呢。", -2, 0, 0, 0);
			Talk(14, "什麼殺氣騰騰，沒文化。怎麼，我們令狐大什麼的，也佔道經營被監市查過嗎？不然怎麼如此印象深刻呢？", -2, 1, 0, 0);
			Talk(8, "唉，傷心舊事兒啊，想當年我為了賒一壺猴兒酒，答應替一個老頭兒照看一下攤子，結果正好趕上監市巡查，害我被他們足足追了三條街，當時的情景還真是歷歷在目啊。", -2, 0, 0, 0);
			Talk(14, "三條街都甩不掉啊，看來令狐大俠您的輕功甚好……好的比較有限啊。", -2, 1, 0, 0);
			Talk(8, "唉，這你就不懂了吧，監市可是衙門裡的特遣隊啊，裡面的每個人都號稱擁有鷹的眼睛、狼的耳朵、豹的速度、熊的力量，上次我可是費勁了九牛二虎之力才能跑掉，也幸虧逃掉了，否則你當日在綠竹巷恐怕就只能見到一堆令狐白骨了。", -2, 0, 0, 0);
			Talk(14, "噗，就會嘴貧，白骨還能去綠竹巷，你是修煉成精了麼。", -2, 1, 0, 0);
			Talk(8, "我若是白骨精，那盈盈你豈不是齊天大聖轉世？", -2, 0, 0, 0);
			Talk(14, "好啊，你個大馬猴，還敢罵我是猢猻。", -2, 1, 0, 0);
			Talk(8, "嫁雞隨雞，嫁狗隨狗，嫁猴麼...", -2, 0, 0, 0);
			Talk(14, "啐，你這人，真是一點都沒正經。", -2, 1, 0, 0);
			a=math.random(15,30);
			b=math.random(2,5);
			b=b*10
			c=math.random(5,10);
			putrolepro(getrolepro(8, 51) + a, 8, 51);
			putrolepro(getrolepro(8, 18) + b, 8, 18);
			putrolepro(getrolepro(8, 42) + b, 8, 42);
			putrolepro(getrolepro(8, 43) + c, 8, 43);
			putrolepro(getrolepro(8, 44) + c, 8, 44);
			putrolepro(getrolepro(8, 45) + c, 8, 45);
			putrolepro(getrolepro(14, 53) + a, 14, 53);
			putrolepro(getrolepro(14, 18) + b, 14, 18);
			putrolepro(getrolepro(14, 42) + b, 14, 42);
			putrolepro(getrolepro(14, 43) + c, 14, 43);
			putrolepro(getrolepro(14, 44) + c, 14, 44);
			putrolepro(getrolepro(14, 45) + c, 14, 45);
			ShowTitle("令狐冲御劍增加"..a, 1);
			ShowTitle("令狐冲生命增加"..b, 1);
			ShowTitle("令狐冲內力增加"..b, 1);
			ShowTitle("令狐冲攻擊增加"..c, 1);
			ShowTitle("令狐冲防禦增加"..c, 1);
			ShowTitle("令狐冲輕功增加"..c, 1);
			ShowTitle("任盈盈特殊增加"..a, 1);
			ShowTitle("任盈盈生命增加"..b, 1);
			ShowTitle("任盈盈內力增加"..b, 1);
			ShowTitle("任盈盈攻擊增加"..c, 1);
			ShowTitle("任盈盈防禦增加"..c, 1);
			ShowTitle("任盈盈輕功增加"..c, 1);
			exit();
		end
	end
end
Talk(14, "從此紛爭不入目，琴瑟和諧遠江湖。", -2, 0, 0, 0);
exit();
