
	
	math.randomseed(os.time());
	showtitle("戰鬥名可在txt目録里查看，編號為行號。");
	talk(0, '你tm是有多懶……', -2, 1);
	i = enternumber(1, 299, 200, 120, 0);
	trybattle(i-1);
	rest();

	

