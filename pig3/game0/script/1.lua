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
  --clear();
  --f7();
  --menu(3, 100, 100, 100, {"in","56","2数字2"});
  --putrolepro(80, 0, 20);
  --allleave();
  --Join(5);
  --Join(26);
  --Join(27);
  --join(30);
  --for i=0,199 do
  --getitem(i,i);
  --end
  --trybattle(78);
  --putrolepro(900,0,73);
  --putrolepro(getrolepro(0,58)+20,0,58);
  --putrolepro(900,5,43);
  --for i=1,10 do
  --instruct_33(5,115,1);
  --instruct_33(5,302,1)
  --end;
  --trybattle(22);
  clear();
  showstringwithbox(100, 70, "想去哪里");
  i=0;
  str = {};
  l = {};
  m=1;
  while i<=134 do
    if getscenepro(i,10) > 0 then
      str[m]=getnameasstring(2, i);
      l[m]=i;
      m=m+1;
    end
    i=i+1;
  end
  a = menu(#l, 100, 100, 150, str);
  if a>=0 then
    SetMainMapPosition(getscenepro(l[a + 1],10)+1,getscenepro(l[a + 1],11)+1);
  end

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



