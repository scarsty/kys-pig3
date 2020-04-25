#ifndef INPUT_H
#define INPUT_H

#include "common.h"
#include "jycommon.h"

#ifdef __cplusplus
extern "C"
{
#endif

typedef struct tagJYINPUTSTATE
{
   JYDIRECTION           dir, prevdir;
   DWORD                  dwKeyPress;
} JYINPUTSTATE;

extern JYINPUTSTATE g_InputState;
enum PALKEY
{
   kKeyMenu        = (1 << 0),
   kKeySearch      = (1 << 1),
   kKeyDown        = (1 << 2),
   kKeyLeft        = (1 << 3),
   kKeyUp          = (1 << 4),
   kKeyRight       = (1 << 5),
   kKeyPgUp        = (1 << 6),
   kKeyPgDn        = (1 << 7),
   kKeyRepeat      = (1 << 8),
   kKeyAuto        = (1 << 9),
   kKeyDefend      = (1 << 10),
   kKeyUseItem     = (1 << 11),
   kKeyThrowItem   = (1 << 12),
   kKeyFlee        = (1 << 13),
   kKeyStatus      = (1 << 14),
   kKeyForce       = (1 << 15),
};
void DrawRect(BYTE* pixels, int x1, int x2, int y1, int y2, BYTE color);
VOID JY_ClearKeyState(VOID);
VOID JY_InitInput(VOID);
VOID JY_ProcessEvent(VOID);
VOID JY_ShutdownInput(VOID);

#ifdef __cplusplus
}
#endif

#endif