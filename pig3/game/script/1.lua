function f0()
	clear();
	showstringwithbox(100, 70, "想去哪里");
	i=1;
	str = {};
	l1 = {1,15,13,14,19,22,45,61,62,68,73,104,108,105,89,100};
	if getscenepro(29,9) > 0 then
		l1 = {1,15,13,14,19,22};
	end
	if getscenepro(29,9) == 0 and getscenepro(83,9) > 0 then
		l1 = {1,15,13,14,19,22,45,61,62,68,73,104,108,105};
	end
	l={};
	m=1;
	while i<=#l1 do
		k = l1[i];
		if getscenepro(k,10) > 0 then
			str[m]=getnameasstring(2, k);
			l[m]=k;
			m=m+1;
		end
		i=i+1;
	end
	a = menu(#l, 100, 100, 150, str);
	if a>=0 then
		SetMainMapPosition(getscenepro(l[a + 1],10)+1,getscenepro(l[a + 1],11)+1);
	end
	setmenuesctype(-2);
end

function f1()
	showstringwithbox(100, 70, "让哪个物品翻倍?");
	i=0;
	str = {};
	while i<276 do
		item, num = getitemlist(i);
		if num>0 then
			-- tempstr = getnameasstring(1, item);
			str[i+1]=getnameasstring(1, item);
		else
			break;
		end
		i=i+1;
	end
	a = menu(i, 100, 100, 150, str);
	if a>=0 then
		item, num  = getitemlist(a);
		getitem(item, num);
	end
end

function f2()
	showstringwithbox(100, 70, "得到全部物品");
    for i=0, 276 do
		additem(i, 20);
	end
end

function f3()
	showstringwithbox(100, 70, "吃哪个100次？");
	i=0;
	str = {};
	while i<276 do
		item, num = getitemlist(i);
		if num>0 then
			-- tempstr = getnameasstring(1, item);
			str[i+1]=getnameasstring(1, item);
		else
			break;
		end
		i=i+1;
	end
	a = menu(i, 100, 100, 150, str);	

	if a>=0 then
		b = getmember(SelectOneTeamMember("选择队友", -1, -1));
		item, num  = getitemlist(a);
		i = 0;
		while i < 100 do
			eatoneitem(b, item);
			clear();
			i = i + 1;
		end;
	end
	rest();
end

function f4()
	--showstringwithbox(100, 70, "清除队友的武功");
	b = getmember(SelectOneTeamMember("清除队友的武功", -1, -1));
	if b<0 then return; end
	clear()
    showstringwithbox(100, 70, "保留几个？");
	i = enternumber(1, 9, 200, 120, 0);
	while i<10 do
		putrolepro(0, b, 63 + i);
		putrolepro(0, b, 73 + i);
		i=i+1;
	end
	rest();
end

function f5()
	--showstringwithbox(100, 70, "清除队友的内功");
	b = getmember(SelectOneTeamMember("清除队友的内功", -1, -1));
	if b<0 then return; end
	clear()
    showstringwithbox(100, 70, "保留几个？");
	i = enternumber(0, 9, 200, 120, 0);
	while i<4 do
		putrolepro(0, b, 92 + i);
		putrolepro(0, b, 96 + i);
		i=i+1;
	end
	rest();
end

function f6()
	showstringwithbox(100, 70, "直接习武");
	str = {'拳經','劍譜','刀録','奇門','暗典','心法'};
    t = menu(6, 100, 100, 150, str) + 1;
	str = {};
	items = {};
	i=0;
	k=0;
	while i<300 do
		item, num = getitemlist(i);
		if num>0 then
			if getitempro(item, 36) > 0  then
				if t<=5 and getmagicpro(getitempro(item, 36), 12)==t then
					str[k+1]=getnameasstring(1, item);
					items[k+1]=item;
					k=k+1;
				end
				if t==6 and getmagicpro(getitempro(item, 36), 14)==3 then
					str[k+1]=getnameasstring(1, item);
					items[k+1]=item;
					k=k+1;
				end
			end
		else
			break;
		end
		i=i+1;		
	end
	a = menu(#str, 200, 100, 150, str);
	if a>=0 then
		b = getmember(SelectOneTeamMember("直接习武", -1, -1));
		item  = items[a+1];
		i = 0;
		while i < 10 do
			eatoneitem(b, item);
			learnmagic(b, getitempro(item, 36));
			clear();
			i = i + 1;
		end;
	end
	rest();
end

function f7()
	showstringwithbox(100, 70, "直接习武");
	str = {'拳經','劍譜','刀録','奇門','暗典','心法'};
    t = menu(6, 100, 100, 150, str) + 1;
	str = {};
	items = {};
	i=0;
	k=0;
	while i<300 do
		item, num = getitemlist(i);
		if num>0 then
			if getitempro(item, 36) > 0  then
				if t<=5 and getmagicpro(getitempro(item, 36), 12)==t then
					str[k+1]=getnameasstring(1, item);
					items[k+1]=item;
					k=k+1;
				end
				if t==6 and getmagicpro(getitempro(item, 36), 14)==3 then
					str[k+1]=getnameasstring(1, item);
					items[k+1]=item;
					k=k+1;
				end
			end
		else
			break;
		end
		i=i+1;		
	end
	a = menu(#str, 200, 100, 150, str);
	if a>=0 then
		b = enternumber(0, 1000, 200, 120, 0);
		item  = items[a+1];
		i = 0;
		while i < 10 do
			eatoneitem(b, item);
			learnmagic(b, getitempro(item, 36));
			clear();
			i = i + 1;
		end;
	end
	rest();
end

function f8()
	b = enternumber(0, 1000, 200, 120, 0);
	getitem(b, 10);
end

function f9()
	i = enternumber(1, 299, 200, 120, 0);
	trybattle(i-1);
end

function f100()
	showtitle("修正場景錯亂");	
	resetscene();
	for i=0, 149 do
		openscene(i);
	end
end

function f101()		
	rest();
	execevent(enternumber(0, 2000, 200, 120, 0));
end

