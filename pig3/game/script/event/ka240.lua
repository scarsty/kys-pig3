showstringwithbox(10, 10, '請選擇材料');
a=menu(3, 10, 40, 100, {'靖鐵','衝金','雲石'});
if a<0 then 
	exit();
else
	a=a+211
	if haveitem(a) == false then
		Talk(86, "你沒有該材料。", -2, 0, 0, 0);
		exit();
	else
		showstringwithbox(10, 10, '請選擇花草');
		z=menu(6, 10, 40, 100, {'芙蓉','紫薇','霜菊','嫣茶','芷蘭','盈竹'});
		if z<0 then
			exit();
		else
			z=z+214
			if haveitem(z) == false then
				Talk(86, "你沒有該花草。", -2, 0, 0, 0);
				d=getnameasstring(1,a);
				showstringwithbox(10, 10, '現在只有'..d..'這種材料，是否製作？');
				b=menu(2, 10, 40, 100, {'是','否'});
				if b==0 then 
					getitem(a,-1);
					g=getitempro(a,42);
					i=g
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
				else end
			else 
				getitem(a,-1);
				getitem(z,-1);
				g=getitempro(a,42);
				h=getitempro(z,42);
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