{
  This file is part of:

    SDL3 for Pascal
    (https://github.com/PascalGameDevelopment/SDL3-for-Pascal)
    SPDX-License-Identifier: Zlib
}

{*
 * # CategoryMouse
 *
 * SDL mouse handling.
  }

{*
 * This is a unique ID for a mouse for the time it is connected to the system,
 * and is never reused for the lifetime of the application.
 *
 * If the mouse is disconnected and reconnected, it will get a new ID.
 *
 * The value 0 is an invalid ID.
 *
 * \since This datatype is available since SDL 3.1.3.
  }
type
  PPSDL_MouseID = ^PSDL_MouseID;
  PSDL_MouseID = ^TSDL_MouseID;
  TSDL_MouseID = cuint32;

{*
 * The structure used to identify an SDL cursor.
 *
 * This is opaque data.
 *
 * \since This struct is available since SDL 3.1.3.
  }
type
  PPSDL_Cursor = ^PSDL_Cursor;
  PSDL_Cursor = type Pointer;

{*
 * Cursor types for SDL_CreateSystemCursor().
 *
 * \since This enum is available since SDL 3.1.3.
  }
type
  PPSDL_SystemCursor = ^PSDL_SystemCursor;
  PSDL_SystemCursor = ^TSDL_SystemCursor;
  TSDL_SystemCursor = type Integer;
const
  SDL_SYSTEM_CURSOR_DEFAULT  = TSDL_SystemCursor(0);       {*< Default cursor. Usually an arrow.  }
  SDL_SYSTEM_CURSOR_TEXT  = TSDL_SystemCursor(1);          {*< Text selection. Usually an I-beam.  }
  SDL_SYSTEM_CURSOR_WAIT  = TSDL_SystemCursor(2);          {*< Wait. Usually an hourglass or watch or spinning ball.  }
  SDL_SYSTEM_CURSOR_CROSSHAIR  = TSDL_SystemCursor(3);     {*< Crosshair.  }
  SDL_SYSTEM_CURSOR_PROGRESS  = TSDL_SystemCursor(4);      {*< Program is busy but still interactive. Usually it's WAIT with an arrow.  }
  SDL_SYSTEM_CURSOR_NWSE_RESIZE  = TSDL_SystemCursor(5);   {*< Double arrow pointing northwest and southeast.  }
  SDL_SYSTEM_CURSOR_NESW_RESIZE  = TSDL_SystemCursor(6);   {*< Double arrow pointing northeast and southwest.  }
  SDL_SYSTEM_CURSOR_EW_RESIZE  = TSDL_SystemCursor(7);     {*< Double arrow pointing west and east.  }
  SDL_SYSTEM_CURSOR_NS_RESIZE  = TSDL_SystemCursor(8);     {*< Double arrow pointing north and south.  }
  SDL_SYSTEM_CURSOR_MOVE  = TSDL_SystemCursor(9);          {*< Four pointed arrow pointing north, south, east, and west.  }
  SDL_SYSTEM_CURSOR_NOT_ALLOWED  = TSDL_SystemCursor(10);  {*< Not permitted. Usually a slashed circle or crossbones.  }
  SDL_SYSTEM_CURSOR_POINTER  = TSDL_SystemCursor(11);      {*< Pointer that indicates a link. Usually a pointing hand.  }
  SDL_SYSTEM_CURSOR_NW_RESIZE  = TSDL_SystemCursor(12);    {*< Window resize top-left. This may be a single arrow or a double arrow like NWSE_RESIZE.  }
  SDL_SYSTEM_CURSOR_N_RESIZE  = TSDL_SystemCursor(13);     {*< Window resize top. May be NS_RESIZE.  }
  SDL_SYSTEM_CURSOR_NE_RESIZE  = TSDL_SystemCursor(14);    {*< Window resize top-right. May be NESW_RESIZE.  }
  SDL_SYSTEM_CURSOR_E_RESIZE  = TSDL_SystemCursor(15);     {*< Window resize right. May be EW_RESIZE.  }
  SDL_SYSTEM_CURSOR_SE_RESIZE  = TSDL_SystemCursor(16);    {*< Window resize bottom-right. May be NWSE_RESIZE.  }
  SDL_SYSTEM_CURSOR_S_RESIZE  = TSDL_SystemCursor(17);     {*< Window resize bottom. May be NS_RESIZE.  }
  SDL_SYSTEM_CURSOR_SW_RESIZE  = TSDL_SystemCursor(18);    {*< Window resize bottom-left. May be NESW_RESIZE.  }
  SDL_SYSTEM_CURSOR_W_RESIZE  = TSDL_SystemCursor(19);     {*< Window resize left. May be EW_RESIZE.  }
  SDL_SYSTEM_CURSOR_COUNT  = TSDL_SystemCursor(20);

{*
 * Scroll direction types for the Scroll event
 *
 * \since This enum is available since SDL 3.1.3.
  }
type
  PPSDL_MouseWheelDirection = ^PSDL_MouseWheelDirection;
  PSDL_MouseWheelDirection = ^TSDL_MouseWheelDirection;
  TSDL_MouseWheelDirection =  Integer;
const
  SDL_MOUSEWHEEL_NORMAL = TSDL_MouseWheelDirection(0);  {*< The scroll direction is normal  }
  SDL_MOUSEWHEEL_FLIPPED = TSDL_MouseWheelDirection(1); {*< The scroll direction is flipped / natural  }

{*
 * A bitmask of pressed mouse buttons, as reported by SDL_GetMouseState, etc.
 *
 * - Button 1: Left mouse button
 * - Button 2: Middle mouse button
 * - Button 3: Right mouse button
 * - Button 4: Side mouse button 1
 * - Button 5: Side mouse button 2
 *
 * \since This datatype is available since SDL 3.1.3.
 *
 * \sa SDL_GetMouseState
 * \sa SDL_GetGlobalMouseState
 * \sa SDL_GetRelativeMouseState
  }
type
  PPSDL_MouseButtonFlags = ^PSDL_MouseButtonFlags;
  PSDL_MouseButtonFlags = ^TSDL_MouseButtonFlags;
  TSDL_MouseButtonFlags = type cuint32;

const
  SDL_BUTTON_LEFT  = TSDL_MouseButtonFlags(1);
  SDL_BUTTON_MIDDLE  = TSDL_MouseButtonFlags(2);
  SDL_BUTTON_RIGHT  = TSDL_MouseButtonFlags(3);
  SDL_BUTTON_X1  = TSDL_MouseButtonFlags(4);
  SDL_BUTTON_X2  = TSDL_MouseButtonFlags(5);

  {SDL3-for-Pascal: The C macro SDL_BUTTON_MASK is not implemented but the mask
                    defines are directly translated. }
  {#define SDL_BUTTON_MASK(X)   (1u << ((X)-1))  }
  SDL_BUTTON_LMASK  = TSDL_MouseButtonFlags(1 shl SDL_BUTTON_LEFT-1);    { SDL_BUTTON_MASK(SDL_BUTTON_LEFT)  }
  SDL_BUTTON_MMASK  = TSDL_MouseButtonFlags(1 shl SDL_BUTTON_MIDDLE-1);  { SDL_BUTTON_MASK(SDL_BUTTON_MIDDLE)  }
  SDL_BUTTON_RMASK  = TSDL_MouseButtonFlags(1 shl SDL_BUTTON_RIGHT-1);   { SDL_BUTTON_MASK(SDL_BUTTON_RIGHT)  }
  SDL_BUTTON_X1MASK  = TSDL_MouseButtonFlags(1 shl SDL_BUTTON_X1-1);     { SDL_BUTTON_MASK(SDL_BUTTON_X1)  }
  SDL_BUTTON_X2MASK  = TSDL_MouseButtonFlags(1 shl SDL_BUTTON_X2-1);     { SDL_BUTTON_MASK(SDL_BUTTON_X2)  }

{ Function prototypes  }

{*
 * Return whether a mouse is currently connected.
 *
 * \returns true if a mouse is connected, false otherwise.
 *
 * \since This function is available since SDL 3.1.3.
 *
 * \sa SDL_GetMice
  }
function SDL_HasMouse: Boolean; cdecl;
  external SDL_LibName {$IFDEF DELPHI} {$IFDEF MACOS} name '_SDL_HasMouse' {$ENDIF} {$ENDIF};

{*
 * Get a list of currently connected mice.
 *
 * Note that this will include any device or virtual driver that includes
 * mouse functionality, including some game controllers, KVM switches, etc.
 * You should wait for input from a device before you consider it actively in
 * use.
 *
 * \param count a Pointer filled in with the number of mice returned, may be
 *              nil.
 * \returns a 0 terminated array of mouse instance IDs or nil on failure;
 *          call SDL_GetError() for more information. This should be freed
 *          with SDL_free() when it is no longer needed.
 *
 * \since This function is available since SDL 3.1.3.
 *
 * \sa SDL_GetMouseNameForID
 * \sa SDL_HasMouse
  }
function SDL_GetMice(count: pcint): PSDL_MouseID; cdecl;
  external SDL_LibName {$IFDEF DELPHI} {$IFDEF MACOS} name '_SDL_GetMice' {$ENDIF} {$ENDIF};

{*
 * Get the name of a mouse.
 *
 * This function returns "" if the mouse doesn't have a name.
 *
 * \param instance_id the mouse instance ID.
 * \returns the name of the selected mouse, or nil on failure; call
 *          SDL_GetError() for more information.
 *
 * \since This function is available since SDL 3.1.3.
 *
 * \sa SDL_GetMice
  }
function SDL_GetMouseNameForID(instance_id: TSDL_MouseID): PAnsiChar; cdecl;
  external SDL_LibName {$IFDEF DELPHI} {$IFDEF MACOS} name '_SDL_GetMouseNameForID' {$ENDIF} {$ENDIF};

{*
 * Get the window which currently has mouse focus.
 *
 * \returns the window with mouse focus.
 *
 * \since This function is available since SDL 3.1.3.
  }
function SDL_GetMouseFocus: PSDL_Window; cdecl;
  external SDL_LibName {$IFDEF DELPHI} {$IFDEF MACOS} name '_SDL_GetMouseFocus' {$ENDIF} {$ENDIF};

{*
 * Retrieve the current state of the mouse.
 *
 * The current button state is returned as a button bitmask, which can be
 * tested using the SDL_BUTTON_MASK(X) macro (where `X` is generally 1 for the
 * left, 2 for middle, 3 for the right button), and `x` and `y` are set to the
 * mouse cursor position relative to the focus window. You can pass nil for
 * either `x` or `y`.
 *
 * \param x the x coordinate of the mouse cursor position relative to the
 *          focus window.
 * \param y the y coordinate of the mouse cursor position relative to the
 *          focus window.
 * \returns a 32-bit button bitmask of the current button state.
 *
 * \since This function is available since SDL 3.1.3.
 *
 * \sa SDL_GetGlobalMouseState
 * \sa SDL_GetRelativeMouseState
  }
function SDL_GetMouseState(x: pcfloat; y: pcfloat): TSDL_MouseButtonFlags; cdecl;
  external SDL_LibName {$IFDEF DELPHI} {$IFDEF MACOS} name '_SDL_GetMouseState' {$ENDIF} {$ENDIF};

{*
 * Get the current state of the mouse in relation to the desktop.
 *
 * This works similarly to SDL_GetMouseState(), but the coordinates will be
 * reported relative to the top-left of the desktop. This can be useful if you
 * need to track the mouse outside of a specific window and SDL_CaptureMouse()
 * doesn't fit your needs. For example, it could be useful if you need to
 * track the mouse while dragging a window, where coordinates relative to a
 * window might not be in sync at all times.
 *
 * Note: SDL_GetMouseState() returns the mouse position as SDL understands it
 * from the last pump of the event queue. This function, however, queries the
 * OS for the current mouse position, and as such, might be a slightly less
 * efficient function. Unless you know what you're doing and have a good
 * reason to use this function, you probably want SDL_GetMouseState() instead.
 *
 * \param x filled in with the current X coord relative to the desktop; can be
 *          nil.
 * \param y filled in with the current Y coord relative to the desktop; can be
 *          nil.
 * \returns the current button state as a bitmask which can be tested using
 *          the SDL_BUTTON_MASK(X) macros.
 *
 * \since This function is available since SDL 3.1.3.
 *
 * \sa SDL_CaptureMouse
 * \sa SDL_GetMouseState
  }
function SDL_GetGlobalMouseState(x: pcfloat; y: pcfloat): TSDL_MouseButtonFlags; cdecl;
  external SDL_LibName {$IFDEF DELPHI} {$IFDEF MACOS} name '_SDL_GetGlobalMouseState' {$ENDIF} {$ENDIF};

{*
 * Retrieve the relative state of the mouse.
 *
 * The current button state is returned as a button bitmask, which can be
 * tested using the `SDL_BUTTON_MASK(X)` macros (where `X` is generally 1 for
 * the left, 2 for middle, 3 for the right button), and `x` and `y` are set to
 * the mouse deltas since the last call to SDL_GetRelativeMouseState() or
 * since event initialization. You can pass nil for either `x` or `y`.
 *
 * \param x a Pointer filled with the last recorded x coordinate of the mouse.
 * \param y a Pointer filled with the last recorded y coordinate of the mouse.
 * \returns a 32-bit button bitmask of the relative button state.
 *
 * \since This function is available since SDL 3.1.3.
 *
 * \sa SDL_GetMouseState
  }
function SDL_GetRelativeMouseState(x: pcfloat; y: pcfloat): TSDL_MouseButtonFlags; cdecl;
  external SDL_LibName {$IFDEF DELPHI} {$IFDEF MACOS} name '_SDL_GetRelativeMouseState' {$ENDIF} {$ENDIF};

{*
 * Move the mouse cursor to the given position within the window.
 *
 * This function generates a mouse motion event if relative mode is not
 * enabled. If relative mode is enabled, you can force mouse events for the
 * warp by setting the SDL_HINT_MOUSE_RELATIVE_WARP_MOTION hint.
 *
 * Note that this function will appear to succeed, but not actually move the
 * mouse when used over Microsoft Remote Desktop.
 *
 * \param window the window to move the mouse into, or nil for the current
 *               mouse focus.
 * \param x the x coordinate within the window.
 * \param y the y coordinate within the window.
 *
 * \since This function is available since SDL 3.1.3.
 *
 * \sa SDL_WarpMouseGlobal
  }
procedure SDL_WarpMouseInWindow(window: PSDL_Window; x: cfloat; y: cfloat); cdecl;
  external SDL_LibName {$IFDEF DELPHI} {$IFDEF MACOS} name '_SDL_WarpMouseInWindow' {$ENDIF} {$ENDIF};

{*
 * Move the mouse to the given position in global screen space.
 *
 * This function generates a mouse motion event.
 *
 * A failure of this function usually means that it is unsupported by a
 * platform.
 *
 * Note that this function will appear to succeed, but not actually move the
 * mouse when used over Microsoft Remote Desktop.
 *
 * \param x the x coordinate.
 * \param y the y coordinate.
 * \returns true on success or false on failure; call SDL_GetError() for more
 *          information.
 *
 * \since This function is available since SDL 3.1.3.
 *
 * \sa SDL_WarpMouseInWindow
  }
function SDL_WarpMouseGlobal(x: cfloat; y: cfloat): Boolean; cdecl;
  external SDL_LibName {$IFDEF DELPHI} {$IFDEF MACOS} name '_SDL_WarpMouseGlobal' {$ENDIF} {$ENDIF};

{*
 * Set relative mouse mode for a window.
 *
 * While the window has focus and relative mouse mode is enabled, the cursor
 * is hidden, the mouse position is constrained to the window, and SDL will
 * report continuous relative mouse motion even if the mouse is at the edge of
 * the window.
 *
 * This function will flush any pending mouse motion for this window.
 *
 * \param window the window to change.
 * \param enabled true to enable relative mode, false to disable.
 * \returns true on success or false on failure; call SDL_GetError() for more
 *          information.
 *
 * \since This function is available since SDL 3.1.3.
 *
 * \sa SDL_GetWindowRelativeMouseMode
  }
function SDL_SetWindowRelativeMouseMode(window: PSDL_Window; enabled: Boolean): Boolean; cdecl;
  external SDL_LibName {$IFDEF DELPHI} {$IFDEF MACOS} name '_SDL_SetWindowRelativeMouseMode' {$ENDIF} {$ENDIF};

{*
 * Query whether relative mouse mode is enabled for a window.
 *
 * \param window the window to query.
 * \returns true if relative mode is enabled for a window or false otherwise.
 *
 * \since This function is available since SDL 3.1.3.
 *
 * \sa SDL_SetWindowRelativeMouseMode
  }
function SDL_GetWindowRelativeMouseMode(window: PSDL_Window): Boolean; cdecl;
  external SDL_LibName {$IFDEF DELPHI} {$IFDEF MACOS} name '_SDL_GetWindowRelativeMouseMode' {$ENDIF} {$ENDIF};

{*
 * Capture the mouse and to track input outside an SDL window.
 *
 * Capturing enables your app to obtain mouse events globally, instead of just
 * within your window. Not all video targets support this function. When
 * capturing is enabled, the current window will get all mouse events, but
 * unlike relative mode, no change is made to the cursor and it is not
 * restrained to your window.
 *
 * This function may also deny mouse input to other windows--both those in
 * your application and others on the system--so you should use this function
 * sparingly, and in small bursts. For example, you might want to track the
 * mouse while the user is dragging something, until the user releases a mouse
 * button. It is not recommended that you capture the mouse for long periods
 * of time, such as the entire time your app is running. For that, you should
 * probably use SDL_SetWindowRelativeMouseMode() or SDL_SetWindowMouseGrab(),
 * depending on your goals.
 *
 * While captured, mouse events still report coordinates relative to the
 * current (foreground) window, but those coordinates may be outside the
 * bounds of the window (including negative values). Capturing is only allowed
 * for the foreground window. If the window loses focus while capturing, the
 * capture will be disabled automatically.
 *
 * While capturing is enabled, the current window will have the
 * `SDL_WINDOW_MOUSE_CAPTURE` flag set.
 *
 * Please note that SDL will attempt to "auto capture" the mouse while the
 * user is pressing a button; this is to try and make mouse behavior more
 * consistent between platforms, and deal with the common case of a user
 * dragging the mouse outside of the window. This means that if you are
 * calling SDL_CaptureMouse() only to deal with this situation, you do not
 * have to (although it is safe to do so). If this causes problems for your
 * app, you can disable auto capture by setting the
 * `SDL_HINT_MOUSE_AUTO_CAPTURE` hint to zero.
 *
 * \param enabled true to enable capturing, false to disable.
 * \returns true on success or false on failure; call SDL_GetError() for more
 *          information.
 *
 * \since This function is available since SDL 3.1.3.
 *
 * \sa SDL_GetGlobalMouseState
  }
function SDL_CaptureMouse(enabled: Boolean): Boolean; cdecl;
  external SDL_LibName {$IFDEF DELPHI} {$IFDEF MACOS} name '_SDL_CaptureMouse' {$ENDIF} {$ENDIF};

{*
 * Create a cursor using the specified bitmap data and mask (in MSB format).
 *
 * `mask` has to be in MSB (Most Significant Bit) format.
 *
 * The cursor width (`w`) must be a multiple of 8 bits.
 *
 * The cursor is created in black and white according to the following:
 *
 * - data=0, mask=1: white
 * - data=1, mask=1: black
 * - data=0, mask=0: transparent
 * - data=1, mask=0: inverted color if possible, black if not.
 *
 * Cursors created with this function must be freed with SDL_DestroyCursor().
 *
 * If you want to have a color cursor, or create your cursor from an
 * SDL_Surface, you should use SDL_CreateColorCursor(). Alternately, you can
 * hide the cursor and draw your own as part of your game's rendering, but it
 * will be bound to the framerate.
 *
 * Also, SDL_CreateSystemCursor() is available, which provides several
 * readily-available system cursors to pick from.
 *
 * \param data the color value for each pixel of the cursor.
 * \param mask the mask value for each pixel of the cursor.
 * \param w the width of the cursor.
 * \param h the height of the cursor.
 * \param hot_x the x-axis offset from the left of the cursor image to the
 *              mouse x position, in the range of 0 to `w` - 1.
 * \param hot_y the y-axis offset from the top of the cursor image to the
 *              mouse y position, in the range of 0 to `h` - 1.
 * \returns a new cursor with the specified parameters on success or nil on
 *          failure; call SDL_GetError() for more information.
 *
 * \since This function is available since SDL 3.1.3.
 *
 * \sa SDL_CreateColorCursor
 * \sa SDL_CreateSystemCursor
 * \sa SDL_DestroyCursor
 * \sa SDL_SetCursor
  }
function SDL_CreateCursor(data: pcuint8; mask: pcuint8; w: cint; h: cint; hot_x: cint; hot_y: cint): PSDL_Cursor; cdecl;
  external SDL_LibName {$IFDEF DELPHI} {$IFDEF MACOS} name '_SDL_CreateCursor' {$ENDIF} {$ENDIF};

{*
 * Create a color cursor.
 *
 * If this function is passed a surface with alternate representations, the
 * surface will be interpreted as the content to be used for 100% display
 * scale, and the alternate representations will be used for high DPI
 * situations. For example, if the original surface is 32x32, then on a 2x
 * macOS display or 200% display scale on Windows, a 64x64 version of the
 * image will be used, if available. If a matching version of the image isn't
 * available, the closest larger size image will be downscaled to the
 * appropriate size and be used instead, if available. Otherwise, the closest
 * smaller image will be upscaled and be used instead.
 *
 * \param surface an SDL_Surface structure representing the cursor image.
 * \param hot_x the x position of the cursor hot spot.
 * \param hot_y the y position of the cursor hot spot.
 * \returns the new cursor on success or nil on failure; call SDL_GetError()
 *          for more information.
 *
 * \since This function is available since SDL 3.1.3.
 *
 * \sa SDL_CreateCursor
 * \sa SDL_CreateSystemCursor
 * \sa SDL_DestroyCursor
 * \sa SDL_SetCursor
  }
function SDL_CreateColorCursor(surface: PSDL_Surface; hot_x: cint; hot_y: cint): PSDL_Cursor; cdecl;
  external SDL_LibName {$IFDEF DELPHI} {$IFDEF MACOS} name '_SDL_CreateColorCursor' {$ENDIF} {$ENDIF};

{*
 * Create a system cursor.
 *
 * \param id an SDL_SystemCursor enum value.
 * \returns a cursor on success or nil on failure; call SDL_GetError() for
 *          more information.
 *
 * \since This function is available since SDL 3.1.3.
 *
 * \sa SDL_DestroyCursor
  }
function SDL_CreateSystemCursor(id: TSDL_SystemCursor): PSDL_Cursor; cdecl;
  external SDL_LibName {$IFDEF DELPHI} {$IFDEF MACOS} name '_SDL_CreateSystemCursor' {$ENDIF} {$ENDIF};

{*
 * Set the active cursor.
 *
 * This function sets the currently active cursor to the specified one. If the
 * cursor is currently visible, the change will be immediately represented on
 * the display. SDL_SetCursor(nil) can be used to force cursor redraw, if
 * this is desired for any reason.
 *
 * \param cursor a cursor to make active.
 * \returns true on success or false on failure; call SDL_GetError() for more
 *          information.
 *
 * \since This function is available since SDL 3.1.3.
 *
 * \sa SDL_GetCursor
  }
function SDL_SetCursor(cursor: PSDL_Cursor): Boolean; cdecl;
  external SDL_LibName {$IFDEF DELPHI} {$IFDEF MACOS} name '_SDL_SetCursor' {$ENDIF} {$ENDIF};

{*
 * Get the active cursor.
 *
 * This function returns a Pointer to the current cursor which is owned by the
 * library. It is not necessary to free the cursor with SDL_DestroyCursor().
 *
 * \returns the active cursor or nil if there is no mouse.
 *
 * \since This function is available since SDL 3.1.3.
 *
 * \sa SDL_SetCursor
  }
function SDL_GetCursor: PSDL_Cursor; cdecl;
  external SDL_LibName {$IFDEF DELPHI} {$IFDEF MACOS} name '_SDL_GetCursor' {$ENDIF} {$ENDIF};

{*
 * Get the default cursor.
 *
 * You do not have to call SDL_DestroyCursor() on the return value, but it is
 * safe to do so.
 *
 * \returns the default cursor on success or nil on failuree; call
 *          SDL_GetError() for more information.
 *
 * \since This function is available since SDL 3.1.3.
  }
function SDL_GetDefaultCursor: PSDL_Cursor; cdecl;
  external SDL_LibName {$IFDEF DELPHI} {$IFDEF MACOS} name '_SDL_GetDefaultCursor' {$ENDIF} {$ENDIF};

{*
 * Free a previously-created cursor.
 *
 * Use this function to free cursor resources created with SDL_CreateCursor(),
 * SDL_CreateColorCursor() or SDL_CreateSystemCursor().
 *
 * \param cursor the cursor to free.
 *
 * \since This function is available since SDL 3.1.3.
 *
 * \sa SDL_CreateColorCursor
 * \sa SDL_CreateCursor
 * \sa SDL_CreateSystemCursor
  }
procedure SDL_DestroyCursor(cursor: PSDL_Cursor); cdecl;
  external SDL_LibName {$IFDEF DELPHI} {$IFDEF MACOS} name '_SDL_DestroyCursor' {$ENDIF} {$ENDIF};

{*
 * Show the cursor.
 *
 * \returns true on success or false on failure; call SDL_GetError() for more
 *          information.
 *
 * \since This function is available since SDL 3.1.3.
 *
 * \sa SDL_CursorVisible
 * \sa SDL_HideCursor
  }
function SDL_ShowCursor: Boolean; cdecl;
  external SDL_LibName {$IFDEF DELPHI} {$IFDEF MACOS} name '_SDL_ShowCursor' {$ENDIF} {$ENDIF};

{*
 * Hide the cursor.
 *
 * \returns true on success or false on failure; call SDL_GetError() for more
 *          information.
 *
 * \since This function is available since SDL 3.1.3.
 *
 * \sa SDL_CursorVisible
 * \sa SDL_ShowCursor
  }
function SDL_HideCursor: Boolean; cdecl;
  external SDL_LibName {$IFDEF DELPHI} {$IFDEF MACOS} name '_SDL_HideCursor' {$ENDIF} {$ENDIF};

{*
 * Return whether the cursor is currently being shown.
 *
 * \returns `true` if the cursor is being shown, or `false` if the cursor is
 *          hidden.
 *
 * \since This function is available since SDL 3.1.3.
 *
 * \sa SDL_HideCursor
 * \sa SDL_ShowCursor
  }
function SDL_CursorVisible: Boolean; cdecl;
  external SDL_LibName {$IFDEF DELPHI} {$IFDEF MACOS} name '_SDL_CursorVisible' {$ENDIF} {$ENDIF};
