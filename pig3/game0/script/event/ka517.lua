SetSceneMap(-2, 1, 25, 14, 2916);
SetSceneMap(-2, 1, 25, 15, 4866);
Talk(0, "咦！這蒲團下居然藏有一本書，運氣真好．", 0, 1);
SetSceneMap(-2, 1, 25, 15, 0);
GetItem(44, 1);
ModifyEvent(-2, -2, 0, 0, -1, -1, -1, -1, -1, -1, -2, -2, -2);
exit();
