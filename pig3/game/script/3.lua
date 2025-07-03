function f0()
  w,h=getscreensize();
  clear();
  showstringwithbox(100, 70, "输入人物序号");
  a=enternumber(0,100,100,100,0);
  clear();
  DrawRect(0,0,w,h,0,50);
  showstatus(a);
  pause();
  clear();
  DrawRect(0,0,w,h,0,50);
  showability(a);
  pause();
  trybattle(a);
end

function f1()
ask2fight(59);

end

function f2()
  showstringwithbox(100, 70, "让哪个物品翻倍?");
  i=0;
  str = {};
  while i<200 do
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

function f3()
  talk(16, 1, "下面你可以在5秒鐘之內移動鼠標，將會即時顯示鼠標的位置。*如果想中間退出的話，按任意的鍵即可。");
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
  talk(17, 5, "演示完畢，給錢。");
end
 
function f4()
  darkscene();
  lightscene();
  learnmagic(0, 17);
end

function f5()
  if n == nil then 
    n = 0;
  else
    n = n + 1;
  end
  if n == 5 then
    getitem(1, 1);  --in SwimmingFish's Lua Edition, instruct_2 can be used.
    n = nil;
  else
    talk(0, 0, "一个空箱子。");
  end
end

function f6()
join(50);
end

function f7()
  showstringwithbox(100, 70, "吃哪个100次？");
  i=0;
  str = {};
  while i<200 do
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
  
  str = {};
  i = 0;
  while i<6 do
    num = getmember(i);
    str[i+1]=getnameasstring(0, num);
    i=i+1;
  end
  b = menu(i, 250, 100, 150, str);
  b = getmember(b);
  
  if a>=0 then
    item, num  = getitemlist(a);
    i = 0;
    while i < 100 do
      eatoneitem(b, item);
      i = i + 1;
    end;
  end
end

function ask2fight(num)
  
  -- num=59;
  clear();
  Talk(num,"我可以为你找来一些江湖名人陪你过招，只不过要收取一定的费用。但打赢之后同样有奖励哦",-2,1,0,0);
  clear();
  showstringwithbox(100, 70, "你要跟谁打一架？");
  i=1;
  str = {};
  l = {};
  m=1;
  while i<=75 do
    if getrolepro(i,17) > 0 then
      str[m]=getnameasstring(0, i);
      l[m]=i;
      m=m+1;
    end
    i=i+1;
  end
  a = menu(#l, 100, 100, 150, str);
  a=a+1;
  if a>=1 then
    if JudgeMoney(100,0,7) ==false then    --  31(1F):判断银子是否够100
        Talk(num,"对不起，你没有足够的银子！",-2,1,0,0)
        Clear();
		return;
    end 
	AddItem(174,-100);
    if AskBattle(1,0) ==false then    
        return; 
    end
	
    Talk(a,string.format("%s%s%s","在下Ｒ",getnameasstring(0, a),"Ｗ向少侠请教！"),-2,1,0,0);
    clear();
	PutBattlePro(a,0,33);
    if TryBattle(0,0,1,1) ==true then
       Talk(a,"少侠武功高强，在下甘拜下风！",-2,1,0,0);
	   clear();
	   winmoney=math.random(100)+100;
	   AddItem(174,winmoney);
	else Talk(a,"真是太弱了，回去再练练吧！",-2,1,0,0);
	     clear();
	end
	PutBattlePro(1,0,33);
	
  end

end