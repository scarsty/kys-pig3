	listA={
		display={}
	};
	listB={
		display={}
	};
	
	for k,v in pairs(list1) do
		listA[k]={}
		listA[k]['id']=v
		listA[k]['name']=GetNameAsString(1,v)
		listA[k]['amount']=haveitemamount(v)
		listA['display'][k]=string.format('%-10s%6s',listA[k]['name'],listA[k]['amount'])
	end
		
	for k,v in pairs(list2) do
		listB[k]={}
		listB[k]['id']=v
		listB[k]['name']=GetNameAsString(1,v)
		listB[k]['amount']=haveitemamount(v)
		listB['display'][k]=string.format('%-10s%6s',listB[k]['name'],listB[k]['amount'])
	end

	Talk(personID, personSay, -2, 1, 0, 0);

	
	showstringwithbox(160, 180, '請選擇'..itemA);
	selectA=menu(#list1, 160, 210, 100,listA['display']);
	if(selectA==-1)then exit();end
	if(listA[selectA+1]['amount']<=0)then
		Talk(personID, "不要開玩笑！", -2, 1, 0, 0);
		exit();
	end
	
	showstringwithbox(390, 180, '請選擇'..itemB);
	selectB=menu(#list2,390,210,100,listB['display'])
	if(selectB==-1)then exit();end
	if(listB[selectB+1]['amount']<=0)then
		Talk(personID, "不要開另一個玩笑！", -2, 1, 0, 0);
		exit();
	end

	idA=listA[selectA+1]['id']
	idB=listB[selectB+1]['id']
	idC=list3[string.format('%s+%s',idA,idB)]
	if(idC==nil)then
		Talk(personID, "合成失敗！", -2, 1, 0, 0);
		exit();
	end
	additem(idA,-1);
	additem(idB,-1);
	--print(getitempro(idC, 41));
	if getitempro(idC, 41)==4 then
		getitem(idC,100);
	else
		getitem(idC,1);
	end