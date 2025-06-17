function f1()
  m={}
  for i=1,20000 do m[i] = 1 end
  for i=2,20000 do
    if m[i] == 1 then 
      for j = i * 2, 20000, i do
        m[j] = 0;
      end
    end
  end
  
  str = ' ';
  for i = 2,20000 do
    if m[i] == 1 then
      str = str.. ' '..i
    end
  end
  talk(1,str,1)
end  
  

function f1()
	--f15();
	--rest();
	--trybattle(294);
	--execevent(664);
	--a=math.random(2,5);
	--showtitle("先鋒大大增加輕功"..a);
	--openscene(57);
	--join(130);
	--learnmagic(15, 15);
	--instruct_52();
	clear();
	setrolepro(enternumber(0,200, 200, 200, 0), 0, 25);
	for i=382,395 do
	setmagicpro(100, i, 16);
	end;
end


function f3()
	talk(16, 1, "下面你可以在5秒鐘之內移動鼠標，將會即時顯示鼠標的位置。**如果想中間退出的話，按任意的鍵即可。");
	t = gettime();
	clearbutton();
	while gettime() - t <= 5 do
		x, y = getmouseposition();
		clear();
		showstring(100, 70, x..", "..y);
		if checkbutton() > 0 then
			pause();
			break;
		end;
	end;
	clearbutton();
	talk(17, 0, "演示完畢，給錢。","叫我刘德华");
	talk("演示完畢，給錢!!!!!!!!!!!!!!!!。", 17, 0);
	talk(2, 17, 10000);
end


function f4()
	--darkscene();
	--lightscene();
	--learnmagic(0, 17);
	--putrolepro(33, 168, 25);
	--putrolepro(0, 169, 25);
	--putrolepro(getrolepro(166, 25) + 1, 166, 25);
	--putrolepro(0, 167, 25);
	execevent(574);
end

function f6()
	--join(257);
	allleave();
	join(226);
	--join(145);
	join(280);
	join(181);
	join(882);
	SetAttribute(181, 1, 60, 1, 60);
	SetAttribute(226, 1, 60, 1, 60);
	SetAttribute(280, 1, 60, 1, 60);
	SetAttribute(882, 1, 60, 1, 60);
end


function f9()
	rest();
	trybattle(294);
end
function f11()
	learnmagic(0, 278, 10);
end


function f12()
	putrolepro(4, 892, 25);
end

function f13()
	putrolepro(824, 6, 18);
	putrolepro(328, 6, 42);

	putrolepro(90, 6, 43);
	putrolepro(70, 6, 44);
	putrolepro(115, 6, 45);
	putrolepro(0, 6, 46);
	putrolepro(0, 6, 47);
	putrolepro(0, 6, 48);
	--putrolepro(50, 6, 49);
	putrolepro(10, 6, 50);
	putrolepro(10, 6, 51);
	putrolepro(40, 6, 52);
	putrolepro(10, 6, 53);
	putrolepro(30, 6, 54);
	putrolepro(50, 6, 58);
	putrolepro(1, 6, 15);
end


function f14()
--f14();
rest();
  putbattlepro(881,297,34);
  putbattlepro(-1,297,32);
  putbattlepro(-1,297,33);
  trybattle(297);
end

function f15()
	rest();
	--putbattlepro(getbattlepro(297,33)+1, 297, 33);
	trybattle(enternumber(0,298,100,100,0));
end

function f16()
	rest();
	trybattle(290);
end

function f17()
	getitem(204,500);
end

function f18()
i = 1
repeat
talk(readtalkasstring(i))
    if i<2 then
		talk(inteam(0))
    elseif i < 4 then
		talk("medium")
    else
		talk("big")
    end
	i = i + 1
until i > 5

end;


function f19()
showstringwithbox(10, 10, '請選擇材料');
a=menu(3, 10, 40, 100, {'靖鐵','沖金','雲石'});
if a==-1 then 
	exit();
else
	b=a+211
	c=haveitem(b);
	if c==0 then
		Talk(86, "你沒有該材料。", -2, 0, 0, 0);
		exit();
	else
		showstringwithbox(10, 10, '請選擇花草');
		z=menu(6, 10, 40, 100, {'芙蓉','紫薇','霜菊','嫣茶','芷蘭','盈竹'});
		if z==-1 then
			exit();
		else
			y=z+214
			x=haveitem(y);
			if x==0 then
				Talk(86, "你沒有該花草。", -2, 0, 0, 0);
				d=getnameasstring(1,b);
				showstringwithbox(10, 10, '現在只有'..d'這種材料，是否製作？');
				f=menu(2, 10, 40, 100, {'是','否'});
				if f~=0 then
					exit();
				end
			else 
				getitem(b,-1);
				getitem(y,-1);
				g=getitempro(b,42);
				h=getitempro(y,42);
				i=g+h
				j=187
				while j<203 do
					j=j+1
					k=getitempro(j,42);
					if k==i then
						getitem(j,50);
						exit();
					end
				end
				getitem(205,1);
			end 
		end
	end 
end 
exit();


end

function f20()
	putitemintro(0, '一张藏宝图，好像已经被撕毁');
end