{
  This file is part of:

    SDL3 for Pascal
    (https://github.com/PascalGameDevelopment/SDL3-for-Pascal)
    SPDX-License-Identifier: Zlib
}

{*
 * # CategoryTouch
 *
 * SDL touch management.
  }

type
  PPSDL_TouchID = ^PSDL_TouchID;
  PSDL_TouchID = ^TSDL_TouchID;
  TSDL_TouchID = cuint64;

  PPSDL_FingerID = ^PSDL_FingerID;
  PSDL_FingerID = ^TSDL_FingerID;
  TSDL_FingerID = cuint64;

type
  PPSDL_TouchDeviceType = ^PSDL_TouchDeviceType;
  PSDL_TouchDeviceType = ^TSDL_TouchDeviceType;
  TSDL_TouchDeviceType = type Integer;
const
  SDL_TOUCH_DEVICE_INVALID = TSDL_TouchDeviceType(-1);
  SDL_TOUCH_DEVICE_DIRECT  = TSDL_TouchDeviceType(0);            { touch screen with window-relative coordinates  }
  SDL_TOUCH_DEVICE_INDIRECT_ABSOLUTE  = TSDL_TouchDeviceType(1); { trackpad with absolute device coordinates  }
  SDL_TOUCH_DEVICE_INDIRECT_RELATIVE  = TSDL_TouchDeviceType(2); { trackpad with screen cursor-relative coordinates  }

{*
 * Data about a single finger in a multitouch event.
 *
 * Each touch even is a collection of fingers that are simultaneously in
 * contact with the touch device (so a "touch" can be a "multitouch," in
 * reality), and this struct reports details of the specific fingers.
 *
 * \since This struct is available since SDL 3.1.3.
 *
 * \sa SDL_GetTouchFingers
  }
type
  PPSDL_Finger = ^PSDL_Finger;
  PSDL_Finger = ^TSDL_Finger;
  TSDL_Finger = record
      id: TSDL_FingerID; {*< the finger ID  }
      x: cfloat;         {*< the x-axis location of the touch event, normalized (0...1)  }
      y: cfloat;         {*< the y-axis location of the touch event, normalized (0...1)  }
      pressure: cfloat;  {*< the quantity of pressure applied, normalized (0...1)  }
    end;

{ #todo : SDL3-for-Pascal: Translate macro }
{ Used as the device ID for mouse events simulated with touch input  }
{ #define SDL_TOUCH_MOUSEID ((SDL_MouseID)-1) }

{ #todo : SDL3-for-Pascal: Translate macro }
{ Used as the SDL_TouchID for touch events simulated with mouse input  }
{ #define SDL_MOUSE_TOUCHID ((SDL_TouchID)-1) }

{*
 * Get a list of registered touch devices.
 *
 * On some platforms SDL first sees the touch device if it was actually used.
 * Therefore the returned list might be empty, although devices are available.
 * After using all devices at least once the number will be correct.
 *
 * \param count a Pointer filled in with the number of devices returned, may
 *              be nil.
 * \returns a 0 terminated array of touch device IDs or nil on failure; call
 *          SDL_GetError() for more information. This should be freed with
 *          SDL_free() when it is no longer needed.
 *
 * \since This function is available since SDL 3.1.3.
  }
function SDL_GetTouchDevices(count: pcint): PSDL_TouchID; cdecl;
  external SDL_LibName {$IFDEF DELPHI} {$IFDEF MACOS} name '_SDL_GetTouchDevices' {$ENDIF} {$ENDIF};

{*
 * Get the touch device name as reported from the driver.
 *
 * \param touchID the touch device instance ID.
 * \returns touch device name, or nil on failure; call SDL_GetError() for
 *          more information.
 *
 * \since This function is available since SDL 3.1.3.
  }
function SDL_GetTouchDeviceName(touchID: TSDL_TouchID): PAnsiChar; cdecl;
  external SDL_LibName {$IFDEF DELPHI} {$IFDEF MACOS} name '_SDL_GetTouchDeviceName' {$ENDIF} {$ENDIF};

{*
 * Get the type of the given touch device.
 *
 * \param touchID the ID of a touch device.
 * \returns touch device type.
 *
 * \since This function is available since SDL 3.1.3.
  }
function SDL_GetTouchDeviceType(touchID: TSDL_TouchID): TSDL_TouchDeviceType; cdecl;
  external SDL_LibName {$IFDEF DELPHI} {$IFDEF MACOS} name '_SDL_GetTouchDeviceType' {$ENDIF} {$ENDIF};

{*
 * Get a list of active fingers for a given touch device.
 *
 * \param touchID the ID of a touch device.
 * \param count a Pointer filled in with the number of fingers returned, can
 *              be nil.
 * \returns a nil terminated array of SDL_Finger pointers or nil on failure;
 *          call SDL_GetError() for more information. This is a single
 *          allocation that should be freed with SDL_free() when it is no
 *          longer needed.
 *
 * \since This function is available since SDL 3.1.3.
  }
function SDL_GetTouchFingers(touchID: TSDL_TouchID; count: pcint):PPSDL_Finger; cdecl;
  external SDL_LibName {$IFDEF DELPHI} {$IFDEF MACOS} name '_SDL_GetTouchFingers' {$ENDIF} {$ENDIF};

