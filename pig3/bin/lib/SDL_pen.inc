{
  This file is part of:

    SDL3 for Pascal
    (https://github.com/PascalGameDevelopment/SDL3-for-Pascal)
    SPDX-License-Identifier: Zlib
}

{*
 * # CategoryPen
 *
 * SDL pen event handling.
 *
 * SDL provides an API for pressure-sensitive pen (stylus and/or eraser)
 * handling, e.g., for input and drawing tablets or suitably equipped mobile /
 * tablet devices.
 *
 * To get started with pens, simply handle SDL_EVENT_PEN_* events. When a pen
 * starts providing input, SDL will assign it a unique SDL_PenID, which will
 * remain for the life of the process, as long as the pen stays connected.
 *
 * Pens may provide more than simple touch input; they might have other axes,
 * such as pressure, tilt, rotation, etc.
  }

{*
 * SDL pen instance IDs.
 *
 * Zero is used to signify an invalid/null device.
 *
 * These show up in pen events when SDL sees input from them. They remain
 * consistent as long as SDL can recognize a tool to be the same pen; but if a
 * pen physically leaves the area and returns, it might get a new ID.
 *
 * \since This datatype is available since SDL 3.1.3.
  }
type
  PPSDL_PenID = ^PSDL_PenID;
  PSDL_PenID = ^TSDL_PenID;
  TSDL_PenID = cuint32;

{*
 * Pen input flags, as reported by various pen events' `pen_state` field.
 *
 * \since This datatype is available since SDL 3.1.3.
  }
  PPSDL_PenInputFlags = ^PSDL_PenInputFlags;
  PSDL_PenInputFlags = ^TSDL_PenInputFlags;
  TSDL_PenInputFlags = cuint32;

const
  SDL_PEN_INPUT_DOWN  = TSDL_PenInputFlags(1 shl 0);        {*< pen is pressed down  }
  SDL_PEN_INPUT_BUTTON_1  = TSDL_PenInputFlags(1 shl 1);    {*< button 1 is pressed  }
  SDL_PEN_INPUT_BUTTON_2  = TSDL_PenInputFlags(1 shl 2);    {*< button 2 is pressed  }
  SDL_PEN_INPUT_BUTTON_3  = TSDL_PenInputFlags(1 shl 3);    {*< button 3 is pressed  }
  SDL_PEN_INPUT_BUTTON_4  = TSDL_PenInputFlags(1 shl 4);    {*< button 4 is pressed  }
  SDL_PEN_INPUT_BUTTON_5  = TSDL_PenInputFlags(1 shl 5);    {*< button 5 is pressed  }
  SDL_PEN_INPUT_ERASER_TIP  = TSDL_PenInputFlags(1 shl 30); {*< eraser tip is used  }

 {*
 * Pen axis indices.
 *
 * These are the valid values for the `axis` field in SDL_PenAxisEvent. All
 * axes are either normalised to 0..1 or report a (positive or negative) angle
 * in degrees, with 0.0 representing the centre. Not all pens/backends support
 * all axes: unsupported axes are always zero.
 *
 * To convert angles for tilt and rotation into vector representation, use
 * SDL_sinf on the XTILT, YTILT, or ROTATION component, for example:
 *
 * `SDL_sinf(xtilt * SDL_PI_F / 180.0)`.
 *
 * \since This enum is available since SDL 3.1.3
  }
type
  PPSDL_PenAxis = ^PSDL_PenAxis;
  PSDL_PenAxis = ^TSDL_PenAxis;
  TSDL_PenAxis = type Integer;
const
  SDL_PEN_AXIS_PRESSURE  = TSDL_PenAxis(0);             {*< Pen pressure.  Unidirectional: 0 to 1.0  }
  SDL_PEN_AXIS_XTILT  = TSDL_PenAxis(1);                {*< Pen horizontal tilt angle.  Bidirectional: -90.0 to 90.0 (left-to-right).  }
  SDL_PEN_AXIS_YTILT  = TSDL_PenAxis(2);                {*< Pen vertical tilt angle.  Bidirectional: -90.0 to 90.0 (top-to-down).  }
  SDL_PEN_AXIS_DISTANCE  = TSDL_PenAxis(3);             {*< Pen distance to drawing surface.  Unidirectional: 0.0 to 1.0  }
  SDL_PEN_AXIS_ROTATION  = TSDL_PenAxis(4);             {*< Pen barrel rotation.  Bidirectional: -180 to 179.9 (clockwise, 0 is facing up, -180.0 is facing down).  }
  SDL_PEN_AXIS_SLIDER  = TSDL_PenAxis(5);               {*< Pen finger wheel or slider (e.g., Airbrush Pen).  Unidirectional: 0 to 1.0  }
  SDL_PEN_AXIS_TANGENTIAL_PRESSURE  = TSDL_PenAxis(6);  {*< Pressure from squeezing the pen ("barrel pressure").  }
  SDL_PEN_AXIS_COUNT  = TSDL_PenAxis(7);                {*< Total known pen axis types in this version of SDL. This number may grow in future releases!  }

