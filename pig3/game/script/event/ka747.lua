Talk(47, "製作人說，我這裡開啟列傳。合不合理就這樣了。", -2, 1, 0, 0);
Talk(0, "啊，想想都有點小激動。", -2, 0, 0, 0);
showstringwithbox(10, 10, '選擇列傳內容');
a=menu(3, 10, 40, -1, {'四大高手列傳','陸冠英列傳','虛僞無恥的製作人'});
clear();
if a<0 then
	exit();
end

if a==0 then
	execevent(1871);
	exit();
end
if a==1 then
	showstringwithbox(10, 10, '請選擇內容');
	b=menu(4, 10, 40, -1, {'太湖戲鬼','戰楊康','戰三鬼','突擊南部隘口'});
	if b<0 then
		exit();
	end
	if b==0 then
		execevent(1867);
	end
	if b==1 then
		execevent(1868);
	end
	if b==2 then
		execevent(1869);
	end
	if b==3 then
		execevent(1872);
	end
end
if a==2 then
	execevent(1890);
	exit();
end