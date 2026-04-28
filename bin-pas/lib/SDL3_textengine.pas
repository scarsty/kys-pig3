unit SDL3_textengine;

{
  This file is part of:

    SDL3 for Pascal
    (https://github.com/PascalGameDevelopment/SDL3-for-Pascal)
    SPDX-License-Identifier: Zlib
}

{$DEFINE SDL_TTF_TEXTENGINE}

{$I sdl.inc}

interface

{$IFDEF WINDOWS}
  uses
    SDL3,
    SDL3_ttf,
    {$IFDEF FPC}
    ctypes,
    {$ENDIF}
    Windows;
{$ENDIF}

{$IF DEFINED(UNIX) AND NOT DEFINED(ANDROID)}
  uses
    SDL3,
    SDL3_ttf,
    {$IFDEF FPC}
    ctypes,
    UnixType,
    {$ENDIF}
    {$IFDEF DARWIN}
    CocoaAll;
    {$ELSE}
    X,
    XLib;
    {$ENDIF}
{$ENDIF}

{$IF DEFINED(UNIX) AND DEFINED(ANDROID) AND DEFINED(FPC)}
  uses
    SDL3,
    SDL3_ttf,
    ctypes,
    UnixType;
{$ENDIF}

{*
 *  \file SDL_textengine.h
 *
 * Definitions for implementations of the TTF_TextEngine interface.
  }

{ #note : SDL3-for-Pascal: Based on file SDL_textengine.h version 3.1.0 (preview). }

{*
 * A font atlas draw command.
 *
 * \since This enum is available since SDL_ttf 3.0.0.
  }
type
  PPTTF_DrawCommand = ^PTTF_DrawCommand;
  PTTF_DrawCommand = ^TTTF_DrawCommand;
  TTTF_DrawCommand = type Integer;
const
  TTF_DRAW_COMMAND_NOOP  = TTTF_DrawCommand(0);
  TTF_DRAW_COMMAND_FILL  = TTTF_DrawCommand(1);
  TTF_DRAW_COMMAND_COPY  = TTTF_DrawCommand(2);

{*
 * A filled rectangle draw operation.
 *
 * \since This struct is available since SDL_ttf 3.0.0.
 *
 * \sa TTF_DrawOperation
  }
type
  PPTTF_FillOperation = ^PTTF_FillOperation;
  PTTF_FillOperation = ^TTTF_FillOperation;
  TTTF_FillOperation = record
      cmd: TTTF_DrawCommand; {*< TTF_DRAW_COMMAND_FILL  }
      rect: TSDL_Rect;       {*< The rectangle to fill, in pixels. The x coordinate is relative to the left side of the text area, going right, and the y coordinate is relative to the top side of the text area, going down.  }
    end;

{*
 * A texture copy draw operation.
 *
 * \since This struct is available since SDL_ttf 3.0.0.
 *
 * \sa TTF_DrawOperation
  }
type
  PPTTF_CopyOperation = ^PTTF_CopyOperation;
  PTTF_CopyOperation = ^TTTF_CopyOperation;
  TTTF_CopyOperation = record
      cmd: TTTF_DrawCommand; {*< TTF_DRAW_COMMAND_COPY  }
      text_offset: cint;     {*< The offset in the text corresponding to this glyph.
                                                                   There may be multiple glyphs with the same text offset
                                                                   and the next text offset might be several Unicode codepoints
                                                                   later. In this case the glyphs and codepoints are grouped
                                                                   together and the group bounding box is the union of the dst
                                                                   rectangles for the corresponding glyphs.  }
      glyph_font: PTTF_Font; {*< The font containing the glyph to be drawn, can be passed to TTF_GetGlyphImageForIndex()  }
      glyph_index: cuint32;  {*< The glyph index of the glyph to be drawn, can be passed to TTF_GetGlyphImageForIndex()  }
      src: TSDL_Rect;        {*< The area within the glyph to be drawn  }
      dst: TSDL_Rect;        {*< The drawing coordinates of the glyph, in pixels. The x coordinate is relative to the left side of the text area, going right, and the y coordinate is relative to the top side of the text area, going down.  }
      reserved: Pointer;
    end;

{*
 * A text engine draw operation.
 *
 * \since This struct is available since SDL_ttf 3.0.0.
  }
type
  PPTTF_DrawOperation = ^PTTF_DrawOperation;
  PTTF_DrawOperation = ^TTTF_DrawOperation;
  TTTF_DrawOperation = record
      case Integer of
        0: (cmd: TTTF_DrawCommand);
        1: (fill: TTTF_FillOperation);
        2: (copy: TTTF_CopyOperation);
      end;

{ Private data in TTF_Text, to assist in text measurement and layout  }
type
  PPTTF_TextLayout = ^PTTF_TextLayout;
  PTTF_TextLayout = type Pointer;

{ Private data in TTF_Text, available to implementations }
type
  PPTTF_TextData = ^PTTF_TextData;
  PTTF_TextData = ^TTTF_TextData;
  TTTF_TextData = record
      font: PTTF_Font;             {*< The font used by this text, read-only.  }
      color: TSDL_FColor;          {*< The color of the text, read-only.  }

      needs_layout_update: Boolean;{*< True if the layout needs to be updated  }
      layout: PTTF_TextLayout;     {*< Cached layout information, read-only.  }
      x: cint;                     {*< The x offset of the upper left corner of this text, in pixels, read-only.  }
      y: cint;                     {*< The y offset of the upper left corner of this text, in pixels, read-only.  }
      w: cint;                     {*< The width of this text, in pixels, read-only.  }
      h: cint;                     {*< The height of this text, in pixels, read-only.  }
      num_ops: cint;               {*< The number of drawing operations to render this text, read-only.  }
      ops: PTTF_DrawOperation;     {*< The drawing operations used to render this text, read-only.  }
      num_clusters: cint;          {*< The number of substrings representing clusters of glyphs in the string, read-only  }
      clusters: PTTF_SubString;    {*< Substrings representing clusters of glyphs in the string, read-only  }

      props: TSDL_PropertiesID;    {*< Custom properties associated with this text, read-only. This field is created as-needed using TTF_GetTextProperties() and the properties may be then set and read normally  }

      needs_engine_update: Boolean;{*< True if the engine text needs to be updated  }
      engine: PTTF_TextEngine;     {*< The engine used to render this text, read-only.  }
      engine_text: Pointer;        {*< The implementation-specific representation of this text  }
    end;

{*
 * A text engine interface.
 *
 * This structure should be initialized using SDL_INIT_INTERFACE()
 *
 * \since This struct is available since SDL_ttf 3.0.0.
 *
 * \sa SDL_INIT_INTERFACE
  }
type
  PPTTF_TextEngine = ^PTTF_TextEngine;
  PTTF_TextEngine = ^TTTF_TextEngine;
  TTTF_TextEngine = record
      version: cuint32;     {*< The version of this interface  }
      userdata: Pointer;    {*< User data Pointer passed to callbacks  }

      { Create a text representation from draw instructions.
       *
       * All fields of `text` except `internal->engine_text` will already be filled out.
       *
       * This function should set the `internal->engine_text` field to a non-nil value.
       *
       * \param userdata the userdata Pointer in this interface.
       * \param text the text object being created.
      }
      CreateText: function(userdata: Pointer; text: PTTF_Text): Boolean; cdecl;

      {*
       * Destroy a text representation.
      }
      DestroyText: procedure(userdata: Pointer; text: PTTF_Text); cdecl;
    end;

{ Check the size of TTF_TextEngine
 *
 * If this assert fails, either the compiler is padding to an unexpected size,
 * or the interface has been updated and this should be updated to match and
 * the code using this interface should be updated to handle the old version.
  }
{ #todo : SDL3-for-Pascal: Implement }
// SDL_COMPILE_TIME_ASSERT(TTF_TextEngine_SIZE, ...

implementation

end.

