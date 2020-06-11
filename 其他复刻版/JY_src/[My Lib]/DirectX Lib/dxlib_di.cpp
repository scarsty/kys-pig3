// DirectX Lib - DirectInput

/**************************************************************
添加函数：
void DInput_Keyboard_Reset_State()
void DInput_Mouse_Reset_State()
void DInput_Joystick_Reset_State()

修改过的函数：
void DInput_Release_Joystick(void)
void DInput_Release_Mouse(void)
void DInput_Release_Keyboard(void)
void DInput_Shutdown(void)
int DInput_Read_Keyboard(void)
int DInput_Read_Mouse(void)
int DInput_Init(HINSTANCE hInstance)

修改过的其他地方：

问题：
所有设备都没有在被其他程序夺去获得状态后重新夺回的代码，一旦被夺去，程序将无法获得输入

**************************************************************/

// INCLUDES ///////////////////////////////////////////////

#define WIN32_LEAN_AND_MEAN  

#include <windows.h>   // include important windows stuff
#include <windowsx.h> 
#include <mmsystem.h>
#include <objbase.h>
#include <iostream> // include important C/C++ stuff
#include <conio.h>
#include <stdlib.h>
#include <malloc.h>
#include <memory.h>
#include <string.h>
#include <stdarg.h>
#include <stdio.h>
#include <math.h>
#include <io.h>
#include <fcntl.h>

#define DIRECTINPUT_VERSION 0x0800
#include <dinput.h>	// directX includes

#include "dxlib_di.h"

// DEFINES ////////////////////////////////////////////////

// TYPES //////////////////////////////////////////////////

// PROTOTYPES /////////////////////////////////////////////

// EXTERNALS /////////////////////////////////////////////
// GLOBALS ////////////////////////////////////////////////

// directinput globals
LPDIRECTINPUT8       lpdi      = NULL;    // dinput object
LPDIRECTINPUTDEVICE8 lpdikey   = NULL;    // dinput keyboard
LPDIRECTINPUTDEVICE8 lpdimouse = NULL;    // dinput mouse
LPDIRECTINPUTDEVICE8 lpdijoy   = NULL;    // dinput joystick
GUID                 joystickGUID;        // guid for main joystick
char                 joyname[80];         // name of joystick

// these contain the target records for all di input packets
UCHAR keyboard_state[256]; // contains keyboard state table
DIMOUSESTATE mouse_state;  // contains state of mouse
DIJOYSTATE joy_state;      // contains state of joystick
int joystick_found = 0;    // tracks if joystick was found and inited

// FUNCTIONS //////////////////////////////////////////////

//////////////////////////////////////////////////////////////////////////////

BOOL CALLBACK DInput_Enum_Joysticks(LPCDIDEVICEINSTANCE lpddi,
								LPVOID guid_ptr) 
{
// this function enumerates the joysticks, but
// stops at the first one and returns the
// instance guid of it, so we can create it

*(GUID*)guid_ptr = lpddi->guidInstance; 

// copy name into global
strcpy(joyname, (char *)lpddi->tszProductName);

// stop enumeration after one iteration
return(DIENUM_STOP);

} // end DInput_Enum_Joysticks

//////////////////////////////////////////////////////////////////////////////

int DInput_Init(HINSTANCE hInstance)
{
// this function initializes directinput

if (FAILED(DirectInput8Create(hInstance, DIRECTINPUT_VERSION, IID_IDirectInput8, (void **)&lpdi,NULL)))
   return(0);

// return success
return(1);

} // end DInput_Init

///////////////////////////////////////////////////////////

void DInput_Shutdown(void)
{
// this function shuts down directinput

DInput_Release_Joystick();

DInput_Release_Mouse();

DInput_Release_Keyboard();

if (lpdi)
	{
	lpdi->Release();
	lpdi = NULL;
	}

} // end DInput_Shutdown

///////////////////////////////////////////////////////////

int DInput_Init_Joystick(HWND const hWnd, int min_x, int max_x, int min_y, int max_y, int dead_zone)
{
// this function initializes the joystick, it allows you to set
// the minimum and maximum x-y ranges 

// first find the fucking GUID of your particular joystick
lpdi->EnumDevices(DI8DEVCLASS_GAMECTRL, 
                  DInput_Enum_Joysticks, 
                  &joystickGUID, 
                  DIEDFL_ATTACHEDONLY); 

// create a temporary IDIRECTINPUTDEVICE (1.0) interface, so we query for 2
LPDIRECTINPUTDEVICE lpdijoy_temp = NULL;

if (lpdi->CreateDevice(joystickGUID, &lpdijoy, NULL)!=DI_OK)
   return(0);

// set cooperation level
if (lpdijoy->SetCooperativeLevel(hWnd, 
	                 DISCL_NONEXCLUSIVE | DISCL_BACKGROUND)!=DI_OK)
   return(0);

// set data format
if (lpdijoy->SetDataFormat(&c_dfDIJoystick)!=DI_OK)
   return(0);

// set the range of the joystick
DIPROPRANGE joy_axis_range;

// first x axis
joy_axis_range.lMin = min_x;
joy_axis_range.lMax = max_x;

joy_axis_range.diph.dwSize       = sizeof(DIPROPRANGE); 
joy_axis_range.diph.dwHeaderSize = sizeof(DIPROPHEADER); 
joy_axis_range.diph.dwObj        = DIJOFS_X;
joy_axis_range.diph.dwHow        = DIPH_BYOFFSET;

lpdijoy->SetProperty(DIPROP_RANGE,&joy_axis_range.diph);

// now y-axis
joy_axis_range.lMin = min_y;
joy_axis_range.lMax = max_y;

joy_axis_range.diph.dwSize       = sizeof(DIPROPRANGE); 
joy_axis_range.diph.dwHeaderSize = sizeof(DIPROPHEADER); 
joy_axis_range.diph.dwObj        = DIJOFS_Y;
joy_axis_range.diph.dwHow        = DIPH_BYOFFSET;

lpdijoy->SetProperty(DIPROP_RANGE,&joy_axis_range.diph);


// and now the dead band
DIPROPDWORD dead_band; // here's our property word

// scale dead zone by 100
dead_zone*=100;

dead_band.diph.dwSize       = sizeof(dead_band);
dead_band.diph.dwHeaderSize = sizeof(dead_band.diph);
dead_band.diph.dwObj        = DIJOFS_X;
dead_band.diph.dwHow        = DIPH_BYOFFSET;

// deadband will be used on both sides of the range +/-
dead_band.dwData            = dead_zone;

// finally set the property
lpdijoy->SetProperty(DIPROP_DEADZONE,&dead_band.diph);

dead_band.diph.dwSize       = sizeof(dead_band);
dead_band.diph.dwHeaderSize = sizeof(dead_band.diph);
dead_band.diph.dwObj        = DIJOFS_Y;
dead_band.diph.dwHow        = DIPH_BYOFFSET;

// deadband will be used on both sides of the range +/-
dead_band.dwData            = dead_zone;


// finally set the property
lpdijoy->SetProperty(DIPROP_DEADZONE,&dead_band.diph);

// acquire the joystick
if (lpdijoy->Acquire()!=DI_OK)
   return(0);

// set found flag
joystick_found = 1;

// return success
return(1);

} // end DInput_Init_Joystick

///////////////////////////////////////////////////////////

int DInput_Init_Mouse(HWND const hWnd)
{
// this function intializes the mouse

// create a mouse device 
if (lpdi->CreateDevice(GUID_SysMouse, &lpdimouse, NULL)!=DI_OK)
   return(0);

// set cooperation level
// change to EXCLUSIVE FORGROUND for better control
if (lpdimouse->SetCooperativeLevel(hWnd, 
                       DISCL_NONEXCLUSIVE | DISCL_BACKGROUND)!=DI_OK)
   return(0);

// set data format
if (lpdimouse->SetDataFormat(&c_dfDIMouse)!=DI_OK)
   return(0);

// acquire the mouse
if (lpdimouse->Acquire()!=DI_OK)
   return(0);

// return success
return(1);

} // end DInput_Init_Mouse

///////////////////////////////////////////////////////////

int DInput_Init_Keyboard(HWND const hWnd)
{
// this function initializes the keyboard device

// create the keyboard device  
if (lpdi->CreateDevice(GUID_SysKeyboard, &lpdikey, NULL)!=DI_OK)
   return(0);

// set cooperation level
if (lpdikey->SetCooperativeLevel(hWnd, 
                 DISCL_NONEXCLUSIVE | DISCL_BACKGROUND)!=DI_OK)
    return(0);

// set data format
if (lpdikey->SetDataFormat(&c_dfDIKeyboard)!=DI_OK)
   return(0);

// acquire the keyboard
if (lpdikey->Acquire()!=DI_OK)
   return(0);

// return success
return(1);

} // end DInput_Init_Keyboard

///////////////////////////////////////////////////////////

int DInput_Read_Joystick(void)
{
// this function reads the joystick state

// make sure the joystick was initialized
if (!joystick_found)
   return(0);

if (lpdijoy)
    {
    // this is needed for joysticks only    
    if (lpdijoy->Poll()!=DI_OK)
        return(0);

    if (lpdijoy->GetDeviceState(sizeof(DIJOYSTATE), (LPVOID)&joy_state)!=DI_OK)
        return(0);
    }
else
    {
    // joystick isn't plugged in, zero out state
    DInput_Joystick_Reset_State();

    // return error
    return(0);
    } // end else

// return sucess
return(1);

} // end DInput_Read_Joystick

///////////////////////////////////////////////////////////

// 获取鼠标输入
int DInput_Read_Mouse(void)
{
// 当没有成功初始化鼠标时，直接返回空数据
if (lpdimouse == NULL)
	{
	DInput_Mouse_Reset_State();
	return 0;
	}
// 成功初始化鼠标，且窗口被激活，则试着获取鼠标输入
else 
	{
	// 获取鼠标输入，检查返回值
	switch (lpdimouse->GetDeviceState(sizeof(DIMOUSESTATE), (LPVOID)&mouse_state))
		{
		// 正常返回
		case DI_OK:
			{
			return 1;
			}
		// 失去输入，需要重新获得鼠标
		// 在协作等级里选择背景的话应该不会获得这个消息
		case DIERR_INPUTLOST:
			{
			// 测试用返回值
			return -1;
			}
		// 其他错误，返回空数据
		default:
			{
			DInput_Mouse_Reset_State();
			return 0;
			}
		}
	}

return 1;
} // end DInput_Read_Mouse

///////////////////////////////////////////////////////////

// 获取键盘输入
int DInput_Read_Keyboard(void)
{
// 当没有成功初始化键盘时，直接返回空数据
if (lpdikey == NULL)
	{
	DInput_Keyboard_Reset_State();
	return 0;
	}
// 成功初始化键盘，且窗口被激活，则试着获取键盘输入
else 
	{
	// 获取键盘输入，检查返回值
	switch (lpdikey->GetDeviceState(256, (LPVOID)keyboard_state))
		{
		// 正常返回
		case DI_OK:
			{
			return 1;
			}
		// 失去输入，需要重新获得键盘
		// 在协作等级里选择背景的话应该不会获得这个消息
		case DIERR_INPUTLOST:
			{
			// 测试用返回值
			return -1;
			}
		// 其他错误，返回空数据
		default:
			{
			DInput_Keyboard_Reset_State();
			return 0;
			}
		}
	}

return 1;
} // end DInput_Read_Keyboard

///////////////////////////////////////////////////////////

void DInput_Release_Joystick(void)
{
// this function unacquires and releases the joystick

if (lpdijoy)
    {    
    lpdijoy->Unacquire();
    lpdijoy->Release();
	lpdijoy = NULL;
    } // end if

} // end DInput_Release_Joystick

///////////////////////////////////////////////////////////

void DInput_Release_Mouse(void)
{
// this function unacquires and releases the mouse

if (lpdimouse)
    {    
    lpdimouse->Unacquire();
    lpdimouse->Release();
	lpdimouse = NULL;
    } // end if

} // end DInput_Release_Mouse

///////////////////////////////////////////////////////////

void DInput_Release_Keyboard(void)
{
// this function unacquires and releases the keyboard

if (lpdikey)
    {
    lpdikey->Unacquire();
    lpdikey->Release();
	lpdikey = NULL;
    } // end if

} // end DInput_Release_Keyboard

///////////////////////////////////////////////////////////

// 清空键盘输入数据
void DInput_Keyboard_Reset_State()
	{
	memset(keyboard_state,0,sizeof(keyboard_state));
	}

///////////////////////////////////////////////////////////

// 清空鼠标输入数据
void DInput_Mouse_Reset_State()
	{
	memset(&mouse_state,0,sizeof(mouse_state));
	}

///////////////////////////////////////////////////////////

// 清空操纵杆输入数据
void DInput_Joystick_Reset_State()
	{
	memset(&joy_state,0,sizeof(joy_state));
	}
