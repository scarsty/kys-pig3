
/**************************************************************

修改过的地方：
增加检测DirectInput键盘键位是否被按下的宏DIKEY()。

**************************************************************/

// watch for multiple inclusions
#ifndef DXLIB_DI
#define DXLIB_DI

// DEFINES ////////////////////////////////////////////////

// MACROS /////////////////////////////////////////////////

#define DIKEY(dik) ((keyboard_state[dik] & 0x80) ? 1 : 0)

// TYPES //////////////////////////////////////////////////

// PROTOTYPES /////////////////////////////////////////////

int DInput_Init(HINSTANCE hInstance);
void DInput_Shutdown(void);
int DInput_Init_Joystick(HWND hWnd, int min_x=-256, int max_x=256,
						 int min_y=-256, int max_y=256, int dead_band = 10);
int DInput_Init_Mouse(HWND hWnd);
int DInput_Init_Keyboard(HWND hWnd);
int DInput_Read_Joystick(void);
int DInput_Read_Mouse(void);
int DInput_Read_Keyboard(void);
void DInput_Release_Joystick(void);
void DInput_Release_Mouse(void);
void DInput_Release_Keyboard(void);
void DInput_Keyboard_Reset_State();
void DInput_Mouse_Reset_State();
void DInput_Joystick_Reset_State();

// GLOBALS ////////////////////////////////////////////////

// EXTERNALS //////////////////////////////////////////////

// directinput globals
extern LPDIRECTINPUT8       lpdi;       // dinput object
extern LPDIRECTINPUTDEVICE8 lpdikey;    // dinput keyboard
extern LPDIRECTINPUTDEVICE8 lpdimouse;  // dinput mouse
extern LPDIRECTINPUTDEVICE8 lpdijoy;    // dinput joystick 
extern GUID                 joystickGUID; // guid for main joystick
extern char                 joyname[80];  // name of joystick

// these contain the target records for all di input packets
extern UCHAR keyboard_state[256]; // contains keyboard state table
extern DIMOUSESTATE mouse_state;  // contains state of mouse
extern DIJOYSTATE joy_state;      // contains state of joystick
extern int joystick_found;        // tracks if stick is plugged in

#endif // DXLIB_DI