#include <windows.h>
#include "src/Main.h"
//#include "resource.h"

extern "C"
{
	int
		main(
		int      argc,
		char    *argv[]
	);
};

int WINAPI WinMain(HINSTANCE hInstance,
				   HINSTANCE hPrevInstance,
				   LPTSTR    lpCmdLine,
				   int       nCmdShow)
{

	//UINT   ui   =   GetACP();   
	//if (ui == 936)
	//{
	//	g_CharSet = 0;
	//}
	//else
	//{
	//	g_CharSet = 1;
	//}
	strcpy(appPath, GetAppPath());
	//strcpy(appPath, "Storage Card\\JY");
	//strcpy(appPath, "Storage Card\\JY_XZCJH");
	//strcpy(appPath, "Storage Card\\½ð");
	//strcpy(appPath, "Storage Card\\JY_CLZR");
	main(0,0);

	return 0;
}