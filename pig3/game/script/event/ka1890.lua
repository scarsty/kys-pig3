function f1()
	putbattlepro(-1,b,33);
	putbattlepro(-1,b,34);
	putbattlepro(-1,b,35);
	putbattlepro(-1,b,36);
	putbattlepro(-1,b,37);
	putbattlepro(-1,b,38);
end

clear();

showstringwithbox(10, 10, '選擇被哪個人暴打');
a=menu(3, 10, 40, -1, {'虛僞帝之戰','無恥帝之戰','光頭強之戰'});
	math.randomseed(os.time());
	b=304;  

if a==0 then
	Talk(0, "虛僞帝？他是誰？", -2, 0, 0, 0);
	Talk(47, "只聽說是去過一趟希臘，那邊有十二個絶頂高手，據說是波斯十二寶樹王的師父。虛僞帝一個人打敗了希腊所有高手，說他們武功太差，但是招式還有些可取之處。最近遊歷到我們中原武林，想找人切磋一下。", -2, 1, 0, 0);
	Talk(0, "為啥聽起來這麽扯淡的樣子……", -2, 0, 0, 0);
	xwd=930;
    f1();
    setbattlename(b, "虛僞帝");
    putbattlepro(xwd,b,33);
	talk(456, '……', '虛僞帝', 1);
	rest();
	if trybattle(b) then
		talk(0, '……', -2, 0);
	else
		talk(0, '這人開掛的吧……', -2, 0);
	end;
	rest();
end

if a==1 then
	wcd=931;
	Talk(0, "無恥帝又是什麽人？", -2, 0, 0, 0);
	Talk(47, "也是去過希臘，但他將希臘所有高手的武功融為一體，實力不在虛僞帝之下。但我觀察，好像他的力道並不太強。", -2, 1, 0, 0);
	Talk(0, "一聽就不是什麽正經人。", -2, 0, 0, 0);
	f1();
    setbattlename(b, "無恥帝");
    putbattlepro(wcd,b,33);
	talk(454, '……', '無恥帝', 1);
	rest();
	if trybattle(b) then
		talk(0, '……', -2, 0);
	else
		talk(0, '這人不僅無恥，而且無聊……', -2, 0);
	end;
	rest();
end

if a== 2 then
	gtd=932;
	Talk(0, "這都是些啥人？", -2, 0, 0, 0);
	Talk(47, "我也搞不清楚，這些人一窩一窩的。", -2, 1, 0, 0);
	f1();
	setbattlename(b, "光頭強");
	putbattlepro(gtd,b,33);
	talk(455, '是兄弟就來砍我！', '光頭強', 1);
	Talk(0, "？？？", -2, 0, 0, 0);
	rest();
	if trybattle(b) then
		talk(455, '是兄弟就來砍我！', -2, 1);
	else
		
	end;
	talk(0, '這人是搞笑動畫來的吧……', -2, 0);
	rest();
end