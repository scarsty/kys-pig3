unit SDL3_ttf;

{
  This file is part of:

    SDL3 for Pascal
    (https://github.com/PascalGameDevelopment/SDL3-for-Pascal)
    SPDX-License-Identifier: Zlib
}

{*
 * # CategorySDLTTF
 *
 * Header file for SDL_ttf library
 *
 * This library is a wrapper around the excellent FreeType 2.0 library,
 * available at: https://www.freetype.org/
  }

{ #note: SDL3-for-Pascal: Based on file SDL_textengine.h version 3.1.0 (preview). }

{$DEFINE SDL_TTF}

{$I sdl.inc}

interface

{$IFDEF WINDOWS}
  uses
    SDL3,
    {$IFDEF FPC}
    ctypes,
    {$ENDIF}
    Windows;
{$ENDIF}

{$IF DEFINED(UNIX) AND NOT DEFINED(ANDROID)}
  uses
    SDL3,
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
    ctypes,
    UnixType;
{$ENDIF}

const

{$IFDEF WINDOWS}
  TTF_LibName = 'SDL3_ttf.dll';
{$ENDIF}

{$IFDEF UNIX}
  {$IFDEF DARWIN}
    TTF_LibName = 'libSDL3_ttf.dylib';
    {$IFDEF FPC}
      {$LINKLIB libSDL3_ttf}
    {$ENDIF}
  {$ELSE}
    {$IFDEF FPC}
      TTF_LibName = 'libSDL3_ttf.so';
    {$ELSE}
      TTF_LibName = 'libSDL3_ttf.so.0';
    {$ENDIF}
  {$ENDIF}
{$ENDIF}

{$IFDEF MACOS}
  TTF_LibName = 'SDL3_ttf';
  {$IFDEF FPC}
    {$linklib libSDL3_ttf}
  {$ENDIF}
{$ENDIF}

{*
 * Printable format: "%d.%d.%d", MAJOR, MINOR, MICRO
  }
const
  SDL_TTF_MAJOR_VERSION = 3;
  SDL_TTF_MINOR_VERSION = 1;
  SDL_TTF_MICRO_VERSION = 0;

{*
 * This is the version number macro for the current SDL_ttf version.
  }
function SDL_TTF_VERSION: Integer;

{*
 * This macro will evaluate to true if compiled with SDL_ttf at least X.Y.Z.
  }
function SDL_TTF_VERSION_ATLEAST(X, Y, Z: Integer): Boolean;

{*
 * This function gets the version of the dynamically linked SDL_ttf library.
 *
 * \returns SDL_ttf version.
 *
 * \threadsafety It is safe to call this function from any thread.
 *
 * \since This function is available since SDL_ttf 3.0.0.
  }
function TTF_Version: cint; cdecl;
  external TTF_LibName {$IFDEF DELPHI} {$IFDEF MACOS} name '_TTF_Version' {$ENDIF} {$ENDIF};


{*
 * Query the version of the FreeType library in use.
 *
 * TTF_Init() should be called before calling this function.
 *
 * \param major to be filled in with the major version number. Can be nil.
 * \param minor to be filled in with the minor version number. Can be nil.
 * \param patch to be filled in with the param version number. Can be nil.
 *
 * \threadsafety It is safe to call this function from any thread.
 *
 * \since This function is available since SDL_ttf 3.0.0.
 *
 * \sa TTF_Init
  }
procedure TTF_GetFreeTypeVersion(major: pcint; minor: pcint; patch: pcint); cdecl;
  external TTF_LibName {$IFDEF DELPHI} {$IFDEF MACOS} name '_TTF_GetFreeTypeVersion' {$ENDIF} {$ENDIF};

{*
 * Query the version of the HarfBuzz library in use.
 *
 * If HarfBuzz is not available, the version reported is 0.0.0.
 *
 * \param major to be filled in with the major version number. Can be nil.
 * \param minor to be filled in with the minor version number. Can be nil.
 * \param patch to be filled in with the param version number. Can be nil.
 *
 * \threadsafety It is safe to call this function from any thread.
 *
 * \since This function is available since SDL_ttf 3.0.0.
  }
procedure TTF_GetHarfBuzzVersion(major: pcint; minor: pcint; patch: pcint); cdecl;
  external TTF_LibName {$IFDEF DELPHI} {$IFDEF MACOS} name '_TTF_GetHarfBuzzVersion' {$ENDIF} {$ENDIF};

{*
 * The internal structure containing font information.
 *
 * Opaque data!
  }
type
  PPTTF_Font = ^PTTF_Font;
  PTTF_Font = type Pointer;

{*
 * Initialize SDL_ttf.
 *
 * You must successfully call this function before it is safe to call any
 * other function in this library.
 *
 * It is safe to call this more than once, and each successful TTF_Init() call
 * should be paired with a matching TTF_Quit() call.
 *
 * \returns true on success or false on failure; call SDL_GetError() for more
 *          information.
 *
 * \since This function is available since SDL_ttf 3.0.0.
 *
 * \sa TTF_Quit
  }
function TTF_Init: Boolean; cdecl;
  external TTF_LibName {$IFDEF DELPHI} {$IFDEF MACOS} name '_TTF_Init' {$ENDIF} {$ENDIF};

{*
 * Create a font from a file, using a specified point size.
 *
 * Some .fon fonts will have several sizes embedded in the file, so the point
 * size becomes the index of choosing which size. If the value is too high,
 * the last indexed size will be the default.
 *
 * When done with the returned TTF_Font, use TTF_CloseFont() to dispose of it.
 *
 * \param file path to font file.
 * \param ptsize point size to use for the newly-opened font.
 * \returns a valid TTF_Font, or nil on failure; call SDL_GetError() for more
 *          information.
 *
 * \threadsafety It is safe to call this function from any thread.
 *
 * \since This function is available since SDL_ttf 3.0.0.
 *
 * \sa TTF_CloseFont
  }
function TTF_OpenFont(file_: PAnsiChar; ptsize: cfloat): PTTF_Font; cdecl;
  external TTF_LibName {$IFDEF DELPHI} {$IFDEF MACOS} name '_TTF_OpenFont' {$ENDIF} {$ENDIF};

{*
 * Create a font from an SDL_IOStream, using a specified point size.
 *
 * Some .fon fonts will have several sizes embedded in the file, so the point
 * size becomes the index of choosing which size. If the value is too high,
 * the last indexed size will be the default.
 *
 * If `closeio` is true, `src` will be automatically closed once the font is
 * closed. Otherwise you should close `src` yourself after closing the font.
 *
 * When done with the returned TTF_Font, use TTF_CloseFont() to dispose of it.
 *
 * \param src an SDL_IOStream to provide a font file's data.
 * \param closeio true to close `src` when the font is closed, false to leave
 *                it open.
 * \param ptsize point size to use for the newly-opened font.
 * \returns a valid TTF_Font, or nil on failure; call SDL_GetError() for more
 *          information.
 *
 * \threadsafety It is safe to call this function from any thread.
 *
 * \since This function is available since SDL_ttf 3.0.0.
 *
 * \sa TTF_CloseFont
  }
function TTF_OpenFontIO(src: PSDL_IOStream; closeio: Boolean; ptsize: cfloat): PTTF_Font; cdecl;
  external TTF_LibName {$IFDEF DELPHI} {$IFDEF MACOS} name '_TTF_OpenFontIO' {$ENDIF} {$ENDIF};

{*
 * Create a font with the specified properties.
 *
 * These are the supported properties:
 *
 * - `TTF_PROP_FONT_CREATE_FILENAME_STRING`: the font file to open, if an
 *   SDL_IOStream isn't being used. This is required if
 *   `TTF_PROP_FONT_CREATE_IOSTREAM_POINTER` and
 *   `TTF_PROP_FONT_CREATE_EXISTING_FONT` aren't set.
 * - `TTF_PROP_FONT_CREATE_IOSTREAM_POINTER`: an SDL_IOStream containing the
 *   font to be opened. This should not be closed until the font is closed.
 *   This is required if `TTF_PROP_FONT_CREATE_FILENAME_STRING` and
 *   `TTF_PROP_FONT_CREATE_EXISTING_FONT` aren't set.
 * - `TTF_PROP_FONT_CREATE_IOSTREAM_OFFSET_NUMBER`: the offset in the iostream
 *   for the beginning of the font, defaults to 0.
 * - `TTF_PROP_FONT_CREATE_IOSTREAM_AUTOCLOSE_BOOLEAN`: true if closing the
 *   font should also close the associated SDL_IOStream.
 * - `TTF_PROP_FONT_CREATE_SIZE_FLOAT`: the point size of the font. Some .fon
 *   fonts will have several sizes embedded in the file, so the point size
 *   becomes the index of choosing which size. If the value is too high, the
 *   last indexed size will be the default.
 * - `TTF_PROP_FONT_CREATE_FACE_NUMBER`: the face index of the font, if the
 *   font contains multiple font faces.
 * - `TTF_PROP_FONT_CREATE_HORIZONTAL_DPI_NUMBER`: the horizontal DPI to use
 *   for font rendering, defaults to
 *   `TTF_PROP_FONT_CREATE_VERTICAL_DPI_NUMBER` if set, or 72 otherwise.
 * - `TTF_PROP_FONT_CREATE_VERTICAL_DPI_NUMBER`: the vertical DPI to use for
 *   font rendering, defaults to `TTF_PROP_FONT_CREATE_HORIZONTAL_DPI_NUMBER`
 *   if set, or 72 otherwise.
 * - `TTF_PROP_FONT_CREATE_EXISTING_FONT`: an optional TTF_Font that, if set,
 *   will be used as the font data source and the initial size and style of
 *   the new font.
 *
 * \param props the properties to use.
 * \returns a valid TTF_Font, or nil on failure; call SDL_GetError() for more
 *          information.
 *
 * \threadsafety It is safe to call this function from any thread.
 *
 * \since This function is available since SDL_ttf 3.0.0.
 *
 * \sa TTF_CloseFont
  }
function TTF_OpenFontWithProperties(props: TSDL_PropertiesID): PTTF_Font; cdecl;
  external TTF_LibName {$IFDEF DELPHI} {$IFDEF MACOS} name '_TTF_OpenFontWithProperties' {$ENDIF} {$ENDIF};

const
  TTF_PROP_FONT_CREATE_FILENAME_STRING = 'SDL_ttf.font.create.filename';
  TTF_PROP_FONT_CREATE_IOSTREAM_POINTER = 'SDL_ttf.font.create.iostream';
  TTF_PROP_FONT_CREATE_IOSTREAM_OFFSET_NUMBER = 'SDL_ttf.font.create.iostream.offset';
  TTF_PROP_FONT_CREATE_IOSTREAM_AUTOCLOSE_BOOLEAN = 'SDL_ttf.font.create.iostream.autoclose';
  TTF_PROP_FONT_CREATE_SIZE_FLOAT = 'SDL_ttf.font.create.size';
  TTF_PROP_FONT_CREATE_FACE_NUMBER = 'SDL_ttf.font.create.face';
  TTF_PROP_FONT_CREATE_HORIZONTAL_DPI_NUMBER = 'SDL_ttf.font.create.hdpi';
  TTF_PROP_FONT_CREATE_VERTICAL_DPI_NUMBER = 'SDL_ttf.font.create.vdpi';
  TTF_PROP_FONT_CREATE_EXISTING_FONT = 'SDL_ttf.font.create.existing_font';

{*
 * Create a copy of an existing font.
 *
 * The copy will be distinct from the original, but will share the font file
 * and have the same size and style as the original.
 *
 * When done with the returned TTF_Font, use TTF_CloseFont() to dispose of it.
 *
 * \param existing_font the font to copy.
 * \returns a valid TTF_Font, or nil on failure; call SDL_GetError() for more
 *          information.
 *
 * \threadsafety This function should be called on the thread that created the
 *               original font.
 *
 * \since This function is available since SDL_ttf 3.0.0.
 *
 * \sa TTF_CloseFont
  }
function TTF_CopyFont(existing_font: PTTF_Font): PTTF_Font; cdecl;
  external TTF_LibName {$IFDEF DELPHI} {$IFDEF MACOS} name '_TTF_CopyFont' {$ENDIF} {$ENDIF};

{*
 * Get the properties associated with a font.
 *
 * The following read-write properties are provided by SDL:
 *
 * - `TTF_PROP_FONT_OUTLINE_LINE_CAP_NUMBER`: The FT_Stroker_LineCap value
 *   used when setting the font outline, defaults to
 *   `FT_STROKER_LINECAP_ROUND`.
 * - `TTF_PROP_FONT_OUTLINE_LINE_JOIN_NUMBER`: The FT_Stroker_LineJoin value
 *   used when setting the font outline, defaults to
 *   `FT_STROKER_LINEJOIN_ROUND`.
 * - `TTF_PROP_FONT_OUTLINE_MITER_LIMIT_NUMBER`: The FT_Fixed miter limit used
 *   when setting the font outline, defaults to 0.
 *
 * \param font the font to query.
 * \returns a valid property ID on success or 0 on failure; call
 *          SDL_GetError() for more information.
 *
 * \threadsafety It is safe to call this function from any thread.
 *
 * \since This function is available since SDL_ttf 3.0.0.
  }
function TTF_GetFontProperties(font: PTTF_Font): TSDL_PropertiesID; cdecl;
  external TTF_LibName {$IFDEF DELPHI} {$IFDEF MACOS} name '_TTF_GetFontProperties' {$ENDIF} {$ENDIF};

const
  TTF_PROP_FONT_OUTLINE_LINE_CAP_NUMBER = 'SDL_ttf.font.outline.line_cap';
  TTF_PROP_FONT_OUTLINE_LINE_JOIN_NUMBER = 'SDL_ttf.font.outline.line_join';
  TTF_PROP_FONT_OUTLINE_MITER_LIMIT_NUMBER = 'SDL_ttf.font.outline.miter_limit';

{*
 * Get the font generation.
 *
 * The generation is incremented each time font properties change that require
 * rebuilding glyphs, such as style, size, etc.
 *
 * \param font the font to query.
 * \returns the font generation or 0 on failure; call SDL_GetError() for more
 *          information.
 *
 * \threadsafety This function should be called on the thread that created the
 *               font.
 *
 * \since This function is available since SDL_ttf 3.0.0.
  }
function TTF_GetFontGeneration(font: PTTF_Font): cuint32; cdecl;
  external TTF_LibName {$IFDEF DELPHI} {$IFDEF MACOS} name '_TTF_GetFontGeneration' {$ENDIF} {$ENDIF};

{*
 * Add a fallback font.
 *
 * Add a font that will be used for glyphs that are not in the current font.
 * The fallback font should have the same size and style as the current font.
 *
 * If there are multiple fallback fonts, they are used in the order added.
 *
 * This updates any TTF_Text objects using this font.
 *
 * \param font the font to modify.
 * \param fallback the font to add as a fallback.
 * \returns true on success or false on failure; call SDL_GetError() for more
 *          information.
 *
 * \threadsafety This function should be called on the thread that created
 *               both fonts.
 *
 * \since This function is available since SDL_ttf 3.0.0.
 *
 * \sa TTF_ClearFallbackFonts
 * \sa TTF_RemoveFallbackFont
  }
function TTF_AddFallbackFont(font: PTTF_Font; fallback: PTTF_Font): Boolean; cdecl;
  external TTF_LibName {$IFDEF DELPHI} {$IFDEF MACOS} name '_TTF_AddFallbackFont' {$ENDIF} {$ENDIF};

{*
 * Remove a fallback font.
 *
 * This updates any TTF_Text objects using this font.
 *
 * \param font the font to modify.
 * \param fallback the font to remove as a fallback.
 *
 * \threadsafety This function should be called on the thread that created
 *               both fonts.
 *
 * \since This function is available since SDL_ttf 3.0.0.
 *
 * \sa TTF_AddFallbackFont
 * \sa TTF_ClearFallbackFonts
  }
procedure TTF_RemoveFallbackFont(font: PTTF_Font; fallback: PTTF_Font); cdecl;
  external TTF_LibName {$IFDEF DELPHI} {$IFDEF MACOS} name '_TTF_RemoveFallbackFont' {$ENDIF} {$ENDIF};

{*
 * Remove all fallback fonts.
 *
 * This updates any TTF_Text objects using this font.
 *
 * \param font the font to modify.
 *
 * \threadsafety This function should be called on the thread that created the
 *               font.
 *
 * \since This function is available since SDL_ttf 3.0.0.
 *
 * \sa TTF_AddFallbackFont
 * \sa TTF_RemoveFallbackFont
 }
procedure TTF_ClearFallbackFonts(font: PTTF_Font); cdecl;
  external TTF_LibName {$IFDEF DELPHI} {$IFDEF MACOS} name '_TTF_ClearFallbackFonts' {$ENDIF} {$ENDIF};

{*
 * Set a font's size dynamically.
 *
 * This updates any TTF_Text objects using this font, and clears
 * already-generated glyphs, if any, from the cache.
 *
 * \param font the font to resize.
 * \param ptsize the new point size.
 * \returns true on success or false on failure; call SDL_GetError() for more
 *          information.
 *
 * \threadsafety This function should be called on the thread that created the
 *               font.
 *
 * \since This function is available since SDL_ttf 3.0.0.
 *
 * \sa TTF_GetFontSize
  }
function TTF_SetFontSize(font: PTTF_Font; ptsize: cfloat): Boolean; cdecl;
  external TTF_LibName {$IFDEF DELPHI} {$IFDEF MACOS} name '_TTF_SetFontSize' {$ENDIF} {$ENDIF};

{*
 * Set font size dynamically with target resolutions, in dots per inch.
 *
 * This updates any TTF_Text objects using this font, and clears
 * already-generated glyphs, if any, from the cache.
 *
 * \param font the font to resize.
 * \param ptsize the new point size.
 * \param hdpi the target horizontal DPI.
 * \param vdpi the target vertical DPI.
 * \returns true on success or false on failure; call SDL_GetError() for more
 *          information.
 *
 * \threadsafety This function should be called on the thread that created the
 *               font.
 *
 * \since This function is available since SDL_ttf 3.0.0.
 *
 * \sa TTF_GetFontSize
 * \sa TTF_GetFontSizeDPI
  }
function TTF_SetFontSizeDPI(font: PTTF_Font; ptsize: cfloat; hdpi: cint; vdpi: cint): Boolean; cdecl;
  external TTF_LibName {$IFDEF DELPHI} {$IFDEF MACOS} name '_TTF_SetFontSizeDPI' {$ENDIF} {$ENDIF};

{*
 * Get the size of a font.
 *
 * \param font the font to query.
 * \returns the size of the font, or 0.0f on failure; call SDL_GetError() for
 *          more information.
 *
 * \threadsafety This function should be called on the thread that created the
 *               font.
 *
 * \since This function is available since SDL_ttf 3.0.0.
 *
 * \sa TTF_SetFontSize
 * \sa TTF_SetFontSizeDPI
  }
function TTF_GetFontSize(font: PTTF_Font): cfloat; cdecl;
  external TTF_LibName {$IFDEF DELPHI} {$IFDEF MACOS} name '_TTF_GetFontSize' {$ENDIF} {$ENDIF};

{*
 * Get font target resolutions, in dots per inch.
 *
 * \param font the font to query.
 * \param hdpi a Pointer filled in with the target horizontal DPI.
 * \param vdpi a Pointer filled in with the target vertical DPI.
 * \returns true on success or false on failure; call SDL_GetError() for more
 *          information.
 *
 * \threadsafety This function should be called on the thread that created the
 *               font.
 *
 * \since This function is available since SDL_ttf 3.0.0.
 *
 * \sa TTF_SetFontSizeDPI
  }
function TTF_GetFontDPI(font: PTTF_Font; hdpi: pcint; vdpi: pcint): Boolean; cdecl;
  external TTF_LibName {$IFDEF DELPHI} {$IFDEF MACOS} name '_TTF_GetFontDPI' {$ENDIF} {$ENDIF};

{*
 * Font style flags for TTF_Font
 *
 * These are the flags which can be used to set the style of a font in
 * SDL_ttf. A combination of these flags can be used with functions that set
 * or query font style, such as TTF_SetFontStyle or TTF_GetFontStyle.
 *
 * \since This function is available since SDL_ttf 3.0.0.
 *
 * \sa TTF_SetFontStyle
 * \sa TTF_GetFontStyle
  }
type
  PPTTF_FontStyleFlags = ^PTTF_FontStyleFlags;
  PTTF_FontStyleFlags = ^TTTF_FontStyleFlags;
  TTTF_FontStyleFlags = type cuint32;

const
  TTF_STYLE_NORMAL  = TTTF_FontStyleFlags($00);        {*< No special style  }
  TTF_STYLE_BOLD  = TTTF_FontStyleFlags($01);          {*< Bold style  }
  TTF_STYLE_ITALIC  = TTTF_FontStyleFlags($02);        {*< Italic style  }
  TTF_STYLE_UNDERLINE  = TTTF_FontStyleFlags($04);     {*< Underlined text  }
  TTF_STYLE_STRIKETHROUGH  = TTTF_FontStyleFlags($08); {*< Strikethrough text  }

{*
 * Set a font's current style.
 *
 * This updates any TTF_Text objects using this font, and clears
 * already-generated glyphs, if any, from the cache.
 *
 * The font styles are a set of bit flags, OR'd together:
 *
 * - `TTF_STYLE_NORMAL` (is zero)
 * - `TTF_STYLE_BOLD`
 * - `TTF_STYLE_ITALIC`
 * - `TTF_STYLE_UNDERLINE`
 * - `TTF_STYLE_STRIKETHROUGH`
 *
 * \param font the font to set a new style on.
 * \param style the new style values to set, OR'd together.
 *
 * \threadsafety This function should be called on the thread that created the
 *               font.
 *
 * \since This function is available since SDL_ttf 3.0.0.
 *
 * \sa TTF_GetFontStyle
  }
procedure TTF_SetFontStyle(font: PTTF_Font; style: TTTF_FontStyleFlags); cdecl;
  external TTF_LibName {$IFDEF DELPHI} {$IFDEF MACOS} name '_TTF_SetFontStyle' {$ENDIF} {$ENDIF};

{*
 * Query a font's current style.
 *
 * The font styles are a set of bit flags, OR'd together:
 *
 * - `TTF_STYLE_NORMAL` (is zero)
 * - `TTF_STYLE_BOLD`
 * - `TTF_STYLE_ITALIC`
 * - `TTF_STYLE_UNDERLINE`
 * - `TTF_STYLE_STRIKETHROUGH`
 *
 * \param font the font to query.
 * \returns the current font style, as a set of bit flags.
 *
 * \threadsafety It is safe to call this function from any thread.
 *
 * \since This function is available since SDL_ttf 3.0.0.
 *
 * \sa TTF_SetFontStyle
  }
function TTF_GetFontStyle(font: PTTF_Font): TTTF_FontStyleFlags; cdecl;
  external TTF_LibName {$IFDEF DELPHI} {$IFDEF MACOS} name '_TTF_GetFontStyle' {$ENDIF} {$ENDIF};

{*
 * Set a font's current outline.
 *
 * This uses the font properties `TTF_PROP_FONT_OUTLINE_LINE_CAP_NUMBER`,
 * `TTF_PROP_FONT_OUTLINE_LINE_JOIN_NUMBER`, and
 * `TTF_PROP_FONT_OUTLINE_MITER_LIMIT_NUMBER` when setting the font outline.
 *
 * This updates any TTF_Text objects using this font, and clears
 * already-generated glyphs, if any, from the cache.
 *
 * \param font the font to set a new outline on.
 * \param outline positive outline value, 0 to default.
 * \returns true on success or false on failure; call SDL_GetError() for more
 *          information.
 *
 * \threadsafety This function should be called on the thread that created the
 *               font.
 *
 * \since This function is available since SDL_ttf 3.0.0.
 *
 * \sa TTF_GetFontOutline
  }
function TTF_SetFontOutline(font: PTTF_Font; outline: cint): Boolean; cdecl;
  external TTF_LibName {$IFDEF DELPHI} {$IFDEF MACOS} name '_TTF_SetFontOutline' {$ENDIF} {$ENDIF};

{*
 * Query a font's current outline.
 *
 * \param font the font to query.
 * \returns the font's current outline value.
 *
 * \threadsafety It is safe to call this function from any thread.
 *
 * \since This function is available since SDL_ttf 3.0.0.
 *
 * \sa TTF_SetFontOutline
  }
function TTF_GetFontOutline(font: PTTF_Font): cint; cdecl;
  external TTF_LibName {$IFDEF DELPHI} {$IFDEF MACOS} name '_TTF_GetFontOutline' {$ENDIF} {$ENDIF};

{*
 * Hinting flags for TTF (TrueType Fonts)
 *
 * This enum specifies the level of hinting to be applied to the font
 * rendering. The hinting level determines how much the font's outlines are
 * adjusted for better alignment on the pixel grid.
 *
 * \since This enum is available since SDL_ttf 3.0.0.
 *
 * \sa TTF_SetFontHinting
 * \sa TTF_GetFontHinting
  }
type
  PPTTF_HintingFlags = ^PTTF_HintingFlags;
  PTTF_HintingFlags = ^TTTF_HintingFlags;
  TTTF_HintingFlags =  Integer;
const
  TTF_HINTING_NORMAL  = TTTF_HintingFlags(0);         {*< Normal hinting applies standard grid-fitting.  }
  TTF_HINTING_LIGHT  = TTTF_HintingFlags(1);          {*< Light hinting applies subtle adjustments to improve rendering.  }
  TTF_HINTING_MONO  = TTTF_HintingFlags(2);           {*< Monochrome hinting adjusts the font for better rendering at lower resolutions.  }
  TTF_HINTING_NONE  = TTTF_HintingFlags(3);           {*< No hinting, the font is rendered without any grid-fitting.  }
  TTF_HINTING_LIGHT_SUBPIXEL  = TTTF_HintingFlags(4); {*< Light hinting with subpixel rendering for more precise font edges.  }

{*
 * Set a font's current hinter setting.
 *
 * This updates any TTF_Text objects using this font, and clears
 * already-generated glyphs, if any, from the cache.
 *
 * The hinter setting is a single value:
 *
 * - `TTF_HINTING_NORMAL`
 * - `TTF_HINTING_LIGHT`
 * - `TTF_HINTING_MONO`
 * - `TTF_HINTING_NONE`
 * - `TTF_HINTING_LIGHT_SUBPIXEL` (available in SDL_ttf 3.0.0 and later)
 *
 * \param font the font to set a new hinter setting on.
 * \param hinting the new hinter setting.
 *
 * \threadsafety This function should be called on the thread that created the
 *               font.
 *
 * \since This function is available since SDL_ttf 3.0.0.
 *
 * \sa TTF_GetFontHinting
  }
procedure TTF_SetFontHinting(font: PTTF_Font; hinting: TTTF_HintingFlags); cdecl;
  external TTF_LibName {$IFDEF DELPHI} {$IFDEF MACOS} name '_TTF_SetFontHinting' {$ENDIF} {$ENDIF};

{*
 * Query the number of faces of a font.
 *
 * \param font the font to query.
 * \returns the number of FreeType font faces.
 *
 * \threadsafety It is safe to call this function from any thread.
 *
 * \since This function is available since SDL_ttf 3.0.0.
  }
function TTF_GetNumFontFaces(font: PTTF_Font): cint; cdecl;
  external TTF_LibName {$IFDEF DELPHI} {$IFDEF MACOS} name '_TTF_GetNumFontFaces' {$ENDIF} {$ENDIF};

{*
 * Query a font's current FreeType hinter setting.
 *
 * The hinter setting is a single value:
 *
 * - `TTF_HINTING_NORMAL`
 * - `TTF_HINTING_LIGHT`
 * - `TTF_HINTING_MONO`
 * - `TTF_HINTING_NONE`
 * - `TTF_HINTING_LIGHT_SUBPIXEL` (available in SDL_ttf 3.0.0 and later)
 *
 * \param font the font to query.
 * \returns the font's current hinter value.
 *
 * \threadsafety It is safe to call this function from any thread.
 *
 * \since This function is available since SDL_ttf 3.0.0.
 *
 * \sa TTF_SetFontHinting
  }
function TTF_GetFontHinting(font: PTTF_Font): TTTF_HintingFlags; cdecl;
  external TTF_LibName {$IFDEF DELPHI} {$IFDEF MACOS} name '_TTF_GetFontHinting' {$ENDIF} {$ENDIF};

{*
 * Enable Signed Distance Field rendering for a font.
 *
 * SDF is a technique that helps fonts look sharp even when scaling and rotating, and requires special shader support for display.
 *
 * This works with Blended APIs, and generates the raw signed distance values in the alpha channel of the resulting texture.
 *
 * This updates any TTF_Text objects using this font, and clears already-generated glyphs, if any, from the cache.
 *
 * \param font the font to set SDF support on.
 * \param enabled true to enable SDF, false to disable.
 * \returns true on success or false on failure; call SDL_GetError()
 *          for more information.
 *
 * \threadsafety This function should be called on the thread that created the font.
 *
 * \since This function is available since SDL_ttf 3.0.0.
 *
 * \sa TTF_GetFontSDF
  }
function TTF_SetFontSDF(font: PTTF_Font; enabled: Boolean): Boolean; cdecl;
  external TTF_LibName {$IFDEF DELPHI} {$IFDEF MACOS} name '_TTF_SetFontSDF' {$ENDIF} {$ENDIF};

{*
 * Query whether Signed Distance Field rendering is enabled for a font.
 *
 * \param font the font to query
 *
 * \returns true if enabled, false otherwise.
 *
 * \threadsafety It is safe to call this function from any thread.
 *
 * \since This function is available since SDL_ttf 3.0.0.
 *
 * \sa TTF_SetFontSDF
  }
function TTF_GetFontSDF(font: PTTF_Font): Boolean; cdecl;
  external TTF_LibName {$IFDEF DELPHI} {$IFDEF MACOS} name '_TTF_GetFontSDF' {$ENDIF} {$ENDIF};

{*
 * The horizontal alignment used when rendering wrapped text.
 *
 * \since This enum is available since SDL_ttf 3.0.0.
  }
type
  PPTTF_HorizontalAlignment = ^PTTF_HorizontalAlignment;
  PTTF_HorizontalAlignment = ^TTTF_HorizontalAlignment;
  TTTF_HorizontalAlignment = type Integer;
  const
    TTF_HORIZONTAL_ALIGN_INVALID = -1;
    TTF_HORIZONTAL_ALIGN_LEFT  = TTTF_HorizontalAlignment(0);
    TTF_HORIZONTAL_ALIGN_CENTER  = TTTF_HorizontalAlignment(1);
    TTF_HORIZONTAL_ALIGN_RIGHT  = TTTF_HorizontalAlignment(2);

{*
 * Set a font's current wrap alignment option.
 *
 * This updates any TTF_Text objects using this font.
 *
 * \param font the font to set a new wrap alignment option on.
 * \param align the new wrap alignment option.
 *
 * \threadsafety This function should be called on the thread that created the
 *               font.
 *
 * \since This function is available since SDL_ttf 3.0.0.
 *
 * \sa TTF_GetFontWrapAlignment
  }
procedure TTF_SetFontWrapAlignment(font: PTTF_Font; align: TTTF_HorizontalAlignment); cdecl;
  external TTF_LibName {$IFDEF DELPHI} {$IFDEF MACOS} name '_TTF_SetFontWrapAlignment' {$ENDIF} {$ENDIF};

{*
 * Query a font's current wrap alignment option.
 *
 * \param font the font to query.
 * \returns the font's current wrap alignment option.
 *
 * \threadsafety It is safe to call this function from any thread.
 *
 * \since This function is available since SDL_ttf 3.0.0.
 *
 * \sa TTF_SetFontWrapAlignment
  }
function TTF_GetFontWrapAlignment(font: PTTF_Font): TTTF_HorizontalAlignment; cdecl;
  external TTF_LibName {$IFDEF DELPHI} {$IFDEF MACOS} name '_TTF_GetFontWrapAlignment' {$ENDIF} {$ENDIF};

{*
 * Query the total height of a font.
 *
 * This is usually equal to point size.
 *
 * \param font the font to query.
 * \returns the font's height.
 *
 * \threadsafety It is safe to call this function from any thread.
 *
 * \since This function is available since SDL_ttf 3.0.0.
  }
function TTF_GetFontHeight(font: PTTF_Font): cint; cdecl;
  external TTF_LibName {$IFDEF DELPHI} {$IFDEF MACOS} name '_TTF_GetFontHeight' {$ENDIF} {$ENDIF};

{*
 * Query the offset from the baseline to the top of a font.
 *
 * This is a positive value, relative to the baseline.
 *
 * \param font the font to query.
 * \returns the font's ascent.
 *
 * \threadsafety It is safe to call this function from any thread.
 *
 * \since This function is available since SDL_ttf 3.0.0.
  }
function TTF_GetFontAscent(font: PTTF_Font): cint; cdecl;
  external TTF_LibName {$IFDEF DELPHI} {$IFDEF MACOS} name '_TTF_GetFontAscent' {$ENDIF} {$ENDIF};

{*
 * Query the offset from the baseline to the bottom of a font.
 *
 * This is a negative value, relative to the baseline.
 *
 * \param font the font to query.
 * \returns the font's descent.
 *
 * \threadsafety It is safe to call this function from any thread.
 *
 * \since This function is available since SDL_ttf 3.0.0.
  }
function TTF_GetFontDescent(font: PTTF_Font): cint; cdecl;
  external TTF_LibName {$IFDEF DELPHI} {$IFDEF MACOS} name '_TTF_GetFontDescent' {$ENDIF} {$ENDIF};

{*
 * Set the spacing between lines of text for a font.
 *
 * This updates any TTF_Text objects using this font.
 *
 * \param font the font to modify.
 * \param lineskip the new line spacing for the font.
 *
 * \threadsafety This function should be called on the thread that created the
 *               font.
 *
 * \since This function is available since SDL_ttf 3.0.0.
 *
 * \sa TTF_GetFontLineSkip
  }
procedure TTF_SetFontLineSkip(font: PTTF_Font; lineskip: cint); cdecl;
  external TTF_LibName {$IFDEF DELPHI} {$IFDEF MACOS} name '_TTF_SetFontLineSkip' {$ENDIF} {$ENDIF};

{*
 * Query the spacing between lines of text for a font.
 *
 * \param font the font to query.
 * \returns the font's recommended spacing.
 *
 * \threadsafety It is safe to call this function from any thread.
 *
 * \since This function is available since SDL_ttf 3.0.0.
 *
 * \sa TTF_SetFontLineSkip
  }
function TTF_GetFontLineSkip(font: PTTF_Font): cint; cdecl;
  external TTF_LibName {$IFDEF DELPHI} {$IFDEF MACOS} name '_TTF_GetFontLineSkip' {$ENDIF} {$ENDIF};

{*
 * Set if kerning is enabled for a font.
 *
 * Newly-opened fonts default to allowing kerning. This is generally a good
 * policy unless you have a strong reason to disable it, as it tends to
 * produce better rendering (with kerning disabled, some fonts might render
 * the word `kerning` as something that looks like `keming` for example).
 *
 * This updates any TTF_Text objects using this font.
 *
 * \param font the font to set kerning on.
 * \param enabled true to enable kerning, false to disable.
 *
 * \threadsafety This function should be called on the thread that created the
 *               font.
 *
 * \since This function is available since SDL_ttf 3.0.0.
 *
 * \sa TTF_GetFontKerning
  }
procedure TTF_SetFontKerning(font: PTTF_Font; enabled: Boolean); cdecl;
  external TTF_LibName {$IFDEF DELPHI} {$IFDEF MACOS} name '_TTF_SetFontKerning' {$ENDIF} {$ENDIF};

{*
 * Query whether or not kerning is enabled for a font.
 *
 * \param font the font to query.
 * \returns true if kerning is enabled, false otherwise.
 *
 * \threadsafety It is safe to call this function from any thread.
 *
 * \since This function is available since SDL_ttf 3.0.0.
 *
 * \sa TTF_SetFontKerning
  }
function TTF_GetFontKerning(font: PTTF_Font): Boolean; cdecl;
  external TTF_LibName {$IFDEF DELPHI} {$IFDEF MACOS} name '_TTF_GetFontKerning' {$ENDIF} {$ENDIF};

{*
 * Query whether a font is fixed-width.
 *
 * A "fixed-width" font means all glyphs are the same width across; a
 * lowercase 'i' will be the same size across as a capital 'W', for example.
 * This is common for terminals and text editors, and other apps that treat
 * text as a grid. Most other things (WYSIWYG word processors, web pages, etc)
 * are more likely to not be fixed-width in most cases.
 *
 * \param font the font to query.
 * \returns true if the font is fixed-width, false otherwise.
 *
 * \threadsafety It is safe to call this function from any thread.
 *
 * \since This function is available since SDL_ttf 3.0.0.
  }
function TTF_FontIsFixedWidth(font: PTTF_Font): Boolean; cdecl;
  external TTF_LibName {$IFDEF DELPHI} {$IFDEF MACOS} name '_TTF_FontIsFixedWidth' {$ENDIF} {$ENDIF};

{*
 * Query whether a font is scalable or not.
 *
 * Scalability lets us distinguish between outline and bitmap fonts.
 *
 * \param font the font to query
 *
 * \returns true if the font is scalable, false otherwise.
 *
 * \threadsafety It is safe to call this function from any thread.
 *
 * \since This function is available since SDL_ttf 3.0.0.
 *
 * \sa TTF_SetFontSDF
  }
function TTF_FontIsScalable(font: PTTF_Font): Boolean; cdecl;
  external TTF_LibName {$IFDEF DELPHI} {$IFDEF MACOS} name '_TTF_FontIsScalable' {$ENDIF} {$ENDIF};

{*
 * Query a font's family name.
 *
 * This string is dictated by the contents of the font file.
 *
 * Note that the returned string is to internal storage, and should not be
 * modified or free'd by the caller. The string becomes invalid, with the rest
 * of the font, when `font` is handed to TTF_CloseFont().
 *
 * \param font the font to query.
 * \returns the font's family name.
 *
 * \threadsafety It is safe to call this function from any thread.
 *
 * \since This function is available since SDL_ttf 3.0.0.
  }
function TTF_GetFontFamilyName(font: PTTF_Font): PAnsiChar; cdecl;
  external TTF_LibName {$IFDEF DELPHI} {$IFDEF MACOS} name '_TTF_GetFontFamilyName' {$ENDIF} {$ENDIF};

{*
 * Query a font's style name.
 *
 * This string is dictated by the contents of the font file.
 *
 * Note that the returned string is to internal storage, and should not be
 * modified or free'd by the caller. The string becomes invalid, with the rest
 * of the font, when `font` is handed to TTF_CloseFont().
 *
 * \param font the font to query.
 * \returns the font's style name.
 *
 * \threadsafety It is safe to call this function from any thread.
 *
 * \since This function is available since SDL_ttf 3.0.0.
  }
function TTF_GetFontStyleName(font: PTTF_Font): PAnsiChar; cdecl;
  external TTF_LibName {$IFDEF DELPHI} {$IFDEF MACOS} name '_TTF_GetFontStyleName' {$ENDIF} {$ENDIF};

{*
 * Direction flags
 *
 * The values here are chosen to match
 * [hb_direction_t](https://harfbuzz.github.io/harfbuzz-hb-common.html#hb-direction-t)
 * .
 *
 * \since This enum is available since SDL_ttf 3.0.0.
 *
 * \sa TTF_SetFontDirection
  }
type
  PPTTF_Direction = ^PTTF_Direction;
  PTTF_Direction = ^TTTF_Direction;
  TTTF_Direction = type Integer;
const
  TTF_DIRECTION_INVALID  = TTTF_Direction(0);
  TTF_DIRECTION_LTR  = TTTF_Direction(4);      {*< Left to Right  }
  TTF_DIRECTION_RTL  = TTTF_Direction(5);      {*< Right to Left  }
  TTF_DIRECTION_TTB  = TTTF_Direction(6);      {*< Top to Bottom  }
  TTF_DIRECTION_BTT  = TTTF_Direction(7);      {*< Bottom to Top  }

{*
 * Set the direction to be used for text shaping by a font.
 *
 * This function only supports left-to-right text shaping if SDL_ttf was not
 * built with HarfBuzz support.
 *
 * This updates any TTF_Text objects using this font.
 *
 * \param font the font to modify.
 * \param direction the new direction for text to flow.
 * \returns true on success or false on failure; call SDL_GetError() for more
 *          information.
 *
 * \threadsafety This function should be called on the thread that created the
 *               font.
 *
 * \since This function is available since SDL_ttf 3.0.0.
  }
function TTF_SetFontDirection(font: PTTF_Font; direction: TTTF_Direction): Boolean; cdecl;
  external TTF_LibName {$IFDEF DELPHI} {$IFDEF MACOS} name '_TTF_SetFontDirection' {$ENDIF} {$ENDIF};

{*
 * Get the direction to be used for text shaping by a font.
 *
 * This defaults to TTF_DIRECTION_INVALID if it hasn't been set.
 *
 * \param font the font to query.
 * \returns the direction to be used for text shaping.
 *
 * \threadsafety This function should be called on the thread that created the
 *               font.
 *
 * \since This function is available since SDL_ttf 3.0.0.
  }
function TTF_GetFontDirection(font: PTTF_Font): TTTF_Direction; cdecl;
  external TTF_LibName {$IFDEF DELPHI} {$IFDEF MACOS} name '_TTF_GetFontDirection' {$ENDIF} {$ENDIF};

{*
 * Set the script to be used for text shaping by a font.
 *
 * This returns false if SDL_ttf isn't build with HarfBuzz support.
 *
 * This updates any TTF_Text objects using this font.
 *
 * \param font the font to modify.
 * \param script a script tag in the format used by HarfBuzz.
 * \returns true on success or false on failure; call SDL_GetError() for more
 *          information.
 *
 * \threadsafety This function should be called on the thread that created the
 *               font.
 *
 * \since This function is available since SDL_ttf 3.0.0.
  }
function TTF_SetFontScript(font: PTTF_Font; script: cuint32): Boolean; cdecl;
  external TTF_LibName {$IFDEF DELPHI} {$IFDEF MACOS} name '_TTF_SetFontScript' {$ENDIF} {$ENDIF};

{*
 * Get the script used for text shaping a font.
 *
 * \param font the font to query.
 * \returns a script tag in the format used by HarfBuzz.
 *
 * \threadsafety This function should be called on the thread that created the
 *               font.
 *
 * \since This function is available since SDL_ttf 3.0.0.
  }
function TTF_GetFontScript(font: PTTF_Font): cuint32; cdecl;
  external TTF_LibName {$IFDEF DELPHI} {$IFDEF MACOS} name '_TTF_GetFontScript' {$ENDIF} {$ENDIF};

{*
 * Get the script used by a 32-bit codepoint.
 *
 * \param ch the character code to check.
 * \returns a script tag in the format used by HarfBuzz on success, or 0 on
 *          failure; call SDL_GetError() for more information.
 *
 * \threadsafety This function is thread-safe.
 *
 * \since This function is available since SDL_ttf 3.0.0.
  }
function TTF_GetGlyphScript(ch: cuint32): cuint32; cdecl;
  external TTF_LibName {$IFDEF DELPHI} {$IFDEF MACOS} name '_TTF_GetGlyphScript' {$ENDIF} {$ENDIF};

{*
 * Set language to be used for text shaping by a font.
 *
 * If SDL_ttf was not built with HarfBuzz support, this function returns false.
 *
 * This updates any TTF_Text objects using this font.
 *
 * \param font the font to specify a language for.
 * \param language_bcp47 a null-terminated string containing the desired language's BCP47 code. Or null to reset the value.
 * \returns true on success or false on failure; call SDL_GetError()
 *          for more information.
 *
 * \threadsafety This function should be called on the thread that created the font.
 *
 * \since This function is available since SDL_ttf 3.0.0.
  }
function TTF_SetFontLanguage(font: PTTF_Font; language_bcp47: PAnsiChar): Boolean; cdecl;
  external TTF_LibName {$IFDEF DELPHI} {$IFDEF MACOS} name '_TTF_SetFontLanguage' {$ENDIF} {$ENDIF};

{*
 * Check whether a glyph is provided by the font for a UNICODE codepoint.
 *
 * \param font the font to query.
 * \param ch the codepoint to check.
 * \returns true if font provides a glyph for this character, false if not.
 *
 * \threadsafety This function should be called on the thread that created the
 *               font.
 *
 * \since This function is available since SDL_ttf 3.0.0.
  }
function TTF_FontHasGlyph(font: PTTF_Font; ch: cuint32): Boolean; cdecl;
  external TTF_LibName {$IFDEF DELPHI} {$IFDEF MACOS} name '_TTF_FontHasGlyph' {$ENDIF} {$ENDIF};

{*
 * The type of data in a glyph image
 *
 * \since This enum is available since SDL_ttf 3.0.0.
  }
type
  PPTTF_ImageType = ^PTTF_ImageType;
  PTTF_ImageType = ^TTTF_ImageType;
  TTTF_ImageType = type Integer;
const
  TTF_IMAGE_INVALID  = TTTF_ImageType(0);
  TTF_IMAGE_ALPHA  = TTTF_ImageType(1);    {*< The color channels are white  }
  TTF_IMAGE_COLOR  = TTTF_ImageType(2);    {*< The color channels have image data  }
  TTF_IMAGE_SDF  = TTTF_ImageType(3);      {*< The alpha channel has signed distance field information  }

{*
 * Get the pixel image for a UNICODE codepoint.
 *
 * \param font the font to query.
 * \param ch the codepoint to check.
 * \param image_type a Pointer filled in with the glyph image type, may be
 *                   nil.
 * \returns an SDL_Surface containing the glyph, or nil on failure; call
 *          SDL_GetError() for more information.
 *
 * \threadsafety This function should be called on the thread that created the
 *               font.
 *
 * \since This function is available since SDL_ttf 3.0.0.
  }
function TTF_GetGlyphImage(font: PTTF_Font; ch: cuint32; image_type: PTTF_ImageType): PSDL_Surface; cdecl;
  external TTF_LibName {$IFDEF DELPHI} {$IFDEF MACOS} name '_TTF_GetGlyphImage' {$ENDIF} {$ENDIF};

{*
 * Get the pixel image for a character index.
 *
 * This is useful for text engine implementations, which can call this with
 * the `glyph_index` in a TTF_CopyOperation
 *
 * \param font the font to query.
 * \param glyph_index the index of the glyph to return.
 * \param image_type a Pointer filled in with the glyph image type, may be
 *                   nil.
 * \returns an SDL_Surface containing the glyph, or nil on failure; call
 *          SDL_GetError() for more information.
 *
 * \threadsafety This function should be called on the thread that created the
 *               font.
 *
 * \since This function is available since SDL_ttf 3.0.0.
  }
function TTF_GetGlyphImageForIndex(font: PTTF_Font; glyph_index: cuint32; image_type: PTTF_ImageType): PSDL_Surface; cdecl;
  external TTF_LibName {$IFDEF DELPHI} {$IFDEF MACOS} name '_TTF_GetGlyphImageForIndex' {$ENDIF} {$ENDIF};

{*
 * Query the metrics (dimensions) of a font's glyph for a UNICODE codepoint.
 *
 * To understand what these metrics mean, here is a useful link:
 *
 * https://freetype.sourceforge.net/freetype2/docs/tutorial/step2.html
 *
 * \param font the font to query.
 * \param ch the codepoint to check.
 * \param minx a Pointer filled in with the minimum x coordinate of the glyph
 *             from the left edge of its bounding box. This value may be
 *             negative.
 * \param maxx a Pointer filled in with the maximum x coordinate of the glyph
 *             from the left edge of its bounding box.
 * \param miny a Pointer filled in with the minimum y coordinate of the glyph
 *             from the bottom edge of its bounding box. This value may be
 *             negative.
 * \param maxy a Pointer filled in with the maximum y coordinate of the glyph
 *             from the bottom edge of its bounding box.
 * \param advance a Pointer filled in with the distance to the next glyph from
 *                the left edge of this glyph's bounding box.
 * \returns true on success or false on failure; call SDL_GetError() for more
 *          information.
 *
 * \threadsafety This function should be called on the thread that created the
 *               font.
 *
 * \since This function is available since SDL_ttf 3.0.0.
  }
function TTF_GetGlyphMetrics(font: PTTF_Font; ch: cuint32; minx: pcint; maxx: pcint; miny: pcint; maxy: pcint; advance: pcint): Boolean; cdecl;
  external TTF_LibName {$IFDEF DELPHI} {$IFDEF MACOS} name '_TTF_GetGlyphMetrics' {$ENDIF} {$ENDIF};

{*
 * Query the kerning size between the glyphs of two UNICODE codepoints.
 *
 * \param font the font to query.
 * \param previous_ch the previous codepoint.
 * \param ch the current codepoint.
 * \param kerning a Pointer filled in with the kerning size between the two glyphs, in pixels, may be nil.
 * \returns true on success or false on failure; call SDL_GetError()
 *          for more information.
 *
 * \threadsafety This function should be called on the thread that created the font.
 *
 * \since This function is available since SDL_ttf 3.0.0.
  }
function TTF_GetGlyphKerning(font: PTTF_Font; previous_ch: cuint32; ch: cuint32; kerning: pcint): Boolean; cdecl;
  external TTF_LibName {$IFDEF DELPHI} {$IFDEF MACOS} name '_TTF_GetGlyphKerning' {$ENDIF} {$ENDIF};

{*
 * Calculate the dimensions of a rendered string of UTF-8 text.
 *
 * This will report the width and height, in pixels, of the space that the
 * specified string will take to fully render.
 *
 * \param font the font to query.
 * \param text text to calculate, in UTF-8 encoding.
 * \param length the length of the text, in bytes, or 0 for null terminated
 *               text.
 * \param w will be filled with width, in pixels, on return.
 * \param h will be filled with height, in pixels, on return.
 * \returns true on success or false on failure; call SDL_GetError() for more
 *          information.
 *
 * \threadsafety This function should be called on the thread that created the
 *               font.
 *
 * \since This function is available since SDL_ttf 3.0.0.
  }
function TTF_GetStringSize(font: PTTF_Font; text: PAnsiChar; length: csize_t; w: pcint; h: pcint): Boolean; cdecl;
  external TTF_LibName {$IFDEF DELPHI} {$IFDEF MACOS} name '_TTF_GetStringSize' {$ENDIF} {$ENDIF};

{*
 * Calculate the dimensions of a rendered string of UTF-8 text.
 *
 * This will report the width and height, in pixels, of the space that the
 * specified string will take to fully render.
 *
 * Text is wrapped to multiple lines on line endings and on word boundaries if
 * it extends beyond `wrap_width` in pixels.
 *
 * If wrap_width is 0, this function will only wrap on newline characters.
 *
 * \param font the font to query.
 * \param text text to calculate, in UTF-8 encoding.
 * \param length the length of the text, in bytes, or 0 for null terminated
 *               text.
 * \param wrap_width the maximum width or 0 to wrap on newline characters.
 * \param w will be filled with width, in pixels, on return.
 * \param h will be filled with height, in pixels, on return.
 * \returns true on success or false on failure; call SDL_GetError() for more
 *          information.
 *
 * \threadsafety This function should be called on the thread that created the
 *               font.
 *
 * \since This function is available since SDL_ttf 3.0.0.
  }
function TTF_GetStringSizeWrapped(font: PTTF_Font; text: PAnsiChar; length: csize_t; wrap_width: cint; w: pcint; h: pcint): Boolean; cdecl;
  external TTF_LibName {$IFDEF DELPHI} {$IFDEF MACOS} name '_TTF_GetStringSizeWrapped' {$ENDIF} {$ENDIF};

{*
 * Calculate how much of a UTF-8 string will fit in a given width.
 *
 * This reports the number of characters that can be rendered before reaching
 * `max_width`.
 *
 * This does not need to render the string to do this calculation.
 *
 * \param font the font to query.
 * \param text text to calculate, in UTF-8 encoding.
 * \param length the length of the text, in bytes, or 0 for null terminated
 *               text.
 * \param max_width maximum width, in pixels, available for the string, or 0
 *                  for unbounded width.
 * \param measured_width a Pointer filled in with the width, in pixels, of the
 *                       string that will fit, may be nil.
 * \param measured_length a Pointer filled in with the length, in bytes, of
 *                        the string that will fit, may be nil.
 * \returns true on success or false on failure; call SDL_GetError() for more
 *          information.
 *
 * \threadsafety This function should be called on the thread that created the
 *               font.
 *
 * \since This function is available since SDL_ttf 3.0.0.
  }
function TTF_MeasureString(font: PTTF_Font; text: PAnsiChar; length: csize_t; max_width: cint; measured_width: pcint; measured_length: pcsize_t): Boolean; cdecl;
  external TTF_LibName {$IFDEF DELPHI} {$IFDEF MACOS} name '_TTF_MeasureString' {$ENDIF} {$ENDIF};

{*
 * Render UTF-8 text at fast quality to a new 8-bit surface.
 *
 * This function will allocate a new 8-bit, palettized surface. The surface's
 * 0 pixel will be the colorkey, giving a transparent background. The 1 pixel
 * will be set to the text color.
 *
 * This will not word-wrap the string; you'll get a surface with a single line
 * of text, as long as the string requires. You can use
 * TTF_RenderText_Solid_Wrapped() instead if you need to wrap the output to
 * multiple lines.
 *
 * This will not wrap on newline characters.
 *
 * You can render at other quality levels with TTF_RenderText_Shaded,
 * TTF_RenderText_Blended, and TTF_RenderText_LCD.
 *
 * \param font the font to render with.
 * \param text text to render, in UTF-8 encoding.
 * \param length the length of the text, in bytes, or 0 for null terminated
 *               text.
 * \param fg the foreground color for the text.
 * \returns a new 8-bit, palettized surface, or nil if there was an error.
 *
 * \threadsafety This function should be called on the thread that created the
 *               font.
 *
 * \since This function is available since SDL_ttf 3.0.0.
 *
 * \sa TTF_RenderText_Blended
 * \sa TTF_RenderText_LCD
 * \sa TTF_RenderText_Shaded
 * \sa TTF_RenderText_Solid
 * \sa TTF_RenderText_Solid_Wrapped
  }
function TTF_RenderText_Solid(font: PTTF_Font; text: PAnsiChar; length: csize_t; fg: TSDL_Color): PSDL_Surface; cdecl;
  external TTF_LibName {$IFDEF DELPHI} {$IFDEF MACOS} name '_TTF_RenderText_Solid' {$ENDIF} {$ENDIF};

{*
 * Render word-wrapped UTF-8 text at fast quality to a new 8-bit surface.
 *
 * This function will allocate a new 8-bit, palettized surface. The surface's
 * 0 pixel will be the colorkey, giving a transparent background. The 1 pixel
 * will be set to the text color.
 *
 * Text is wrapped to multiple lines on line endings and on word boundaries if
 * it extends beyond `wrapLength` in pixels.
 *
 * If wrapLength is 0, this function will only wrap on newline characters.
 *
 * You can render at other quality levels with TTF_RenderText_Shaded_Wrapped,
 * TTF_RenderText_Blended_Wrapped, and TTF_RenderText_LCD_Wrapped.
 *
 * \param font the font to render with.
 * \param text text to render, in UTF-8 encoding.
 * \param length the length of the text, in bytes, or 0 for null terminated
 *               text.
 * \param fg the foreground color for the text.
 * \param wrapLength the maximum width of the text surface or 0 to wrap on
 *                   newline characters.
 * \returns a new 8-bit, palettized surface, or nil if there was an error.
 *
 * \threadsafety This function should be called on the thread that created the
 *               font.
 *
 * \since This function is available since SDL_ttf 3.0.0.
 *
 * \sa TTF_RenderText_Blended_Wrapped
 * \sa TTF_RenderText_LCD_Wrapped
 * \sa TTF_RenderText_Shaded_Wrapped
 * \sa TTF_RenderText_Solid
  }
function TTF_RenderText_Solid_Wrapped(font: PTTF_Font; text: PAnsiChar; length: csize_t; fg: TSDL_Color; wrapLength: cint): PSDL_Surface; cdecl;
  external TTF_LibName {$IFDEF DELPHI} {$IFDEF MACOS} name '_TTF_RenderText_Solid_Wrapped' {$ENDIF} {$ENDIF};

{*
 * Render a single 32-bit glyph at fast quality to a new 8-bit surface.
 *
 * This function will allocate a new 8-bit, palettized surface. The surface's
 * 0 pixel will be the colorkey, giving a transparent background. The 1 pixel
 * will be set to the text color.
 *
 * The glyph is rendered without any padding or centering in the X direction,
 * and aligned normally in the Y direction.
 *
 * You can render at other quality levels with TTF_RenderGlyph_Shaded,
 * TTF_RenderGlyph_Blended, and TTF_RenderGlyph_LCD.
 *
 * \param font the font to render with.
 * \param ch the character to render.
 * \param fg the foreground color for the text.
 * \returns a new 8-bit, palettized surface, or nil if there was an error.
 *
 * \threadsafety This function should be called on the thread that created the
 *               font.
 *
 * \since This function is available since SDL_ttf 3.0.0.
 *
 * \sa TTF_RenderGlyph_Blended
 * \sa TTF_RenderGlyph_LCD
 * \sa TTF_RenderGlyph_Shaded
  }
function TTF_RenderGlyph_Solid(font: PTTF_Font; ch: cuint32; fg: TSDL_Color): PSDL_Surface; cdecl;
  external TTF_LibName {$IFDEF DELPHI} {$IFDEF MACOS} name '_TTF_RenderGlyph_Solid' {$ENDIF} {$ENDIF};

{*
 * Render UTF-8 text at high quality to a new 8-bit surface.
 *
 * This function will allocate a new 8-bit, palettized surface. The surface's
 * 0 pixel will be the specified background color, while other pixels have
 * varying degrees of the foreground color. This function returns the new
 * surface, or nil if there was an error.
 *
 * This will not word-wrap the string; you'll get a surface with a single line
 * of text, as long as the string requires. You can use
 * TTF_RenderText_Shaded_Wrapped() instead if you need to wrap the output to
 * multiple lines.
 *
 * This will not wrap on newline characters.
 *
 * You can render at other quality levels with TTF_RenderText_Solid,
 * TTF_RenderText_Blended, and TTF_RenderText_LCD.
 *
 * \param font the font to render with.
 * \param text text to render, in UTF-8 encoding.
 * \param length the length of the text, in bytes, or 0 for null terminated
 *               text.
 * \param fg the foreground color for the text.
 * \param bg the background color for the text.
 * \returns a new 8-bit, palettized surface, or nil if there was an error.
 *
 * \threadsafety This function should be called on the thread that created the
 *               font.
 *
 * \since This function is available since SDL_ttf 3.0.0.
 *
 * \sa TTF_RenderText_Blended
 * \sa TTF_RenderText_LCD
 * \sa TTF_RenderText_Shaded_Wrapped
 * \sa TTF_RenderText_Solid
  }
function TTF_RenderText_Shaded(font: PTTF_Font; text: PAnsiChar; length: csize_t; fg: TSDL_Color; bg: TSDL_Color): PSDL_Surface; cdecl;
  external TTF_LibName {$IFDEF DELPHI} {$IFDEF MACOS} name '_TTF_RenderText_Shaded' {$ENDIF} {$ENDIF};

{*
 * Render word-wrapped UTF-8 text at high quality to a new 8-bit surface.
 *
 * This function will allocate a new 8-bit, palettized surface. The surface's
 * 0 pixel will be the specified background color, while other pixels have
 * varying degrees of the foreground color. This function returns the new
 * surface, or nil if there was an error.
 *
 * Text is wrapped to multiple lines on line endings and on word boundaries if
 * it extends beyond `wrap_width` in pixels.
 *
 * If wrap_width is 0, this function will only wrap on newline characters.
 *
 * You can render at other quality levels with TTF_RenderText_Solid_Wrapped,
 * TTF_RenderText_Blended_Wrapped, and TTF_RenderText_LCD_Wrapped.
 *
 * \param font the font to render with.
 * \param text text to render, in UTF-8 encoding.
 * \param length the length of the text, in bytes, or 0 for null terminated
 *               text.
 * \param fg the foreground color for the text.
 * \param bg the background color for the text.
 * \param wrap_width the maximum width of the text surface or 0 to wrap on
 *                   newline characters.
 * \returns a new 8-bit, palettized surface, or nil if there was an error.
 *
 * \threadsafety This function should be called on the thread that created the
 *               font.
 *
 * \since This function is available since SDL_ttf 3.0.0.
 *
 * \sa TTF_RenderText_Blended_Wrapped
 * \sa TTF_RenderText_LCD_Wrapped
 * \sa TTF_RenderText_Shaded
 * \sa TTF_RenderText_Solid_Wrapped
  }
function TTF_RenderText_Shaded_Wrapped(font: PTTF_Font; text: PAnsiChar; length: csize_t; fg: TSDL_Color; bg: TSDL_Color; wrap_width: cint): PSDL_Surface; cdecl;
  external TTF_LibName {$IFDEF DELPHI} {$IFDEF MACOS} name '_TTF_RenderText_Shaded_Wrapped' {$ENDIF} {$ENDIF};

{*
 * Render a single UNICODE codepoint at high quality to a new 8-bit surface.
 *
 * This function will allocate a new 8-bit, palettized surface. The surface's
 * 0 pixel will be the specified background color, while other pixels have
 * varying degrees of the foreground color. This function returns the new
 * surface, or nil if there was an error.
 *
 * The glyph is rendered without any padding or centering in the X direction,
 * and aligned normally in the Y direction.
 *
 * You can render at other quality levels with TTF_RenderGlyph_Solid,
 * TTF_RenderGlyph_Blended, and TTF_RenderGlyph_LCD.
 *
 * \param font the font to render with.
 * \param ch the codepoint to render.
 * \param fg the foreground color for the text.
 * \param bg the background color for the text.
 * \returns a new 8-bit, palettized surface, or nil if there was an error.
 *
 * \threadsafety This function should be called on the thread that created the
 *               font.
 *
 * \since This function is available since SDL_ttf 3.0.0.
 *
 * \sa TTF_RenderGlyph_Blended
 * \sa TTF_RenderGlyph_LCD
 * \sa TTF_RenderGlyph_Solid
  }
function TTF_RenderGlyph_Shaded(font: PTTF_Font; ch: cuint32; fg: TSDL_Color; bg: TSDL_Color): PSDL_Surface; cdecl;
  external TTF_LibName {$IFDEF DELPHI} {$IFDEF MACOS} name '_TTF_RenderGlyph_Shaded' {$ENDIF} {$ENDIF};

{*
 * Render UTF-8 text at high quality to a new ARGB surface.
 *
 * This function will allocate a new 32-bit, ARGB surface, using alpha
 * blending to dither the font with the given color. This function returns the
 * new surface, or nil if there was an error.
 *
 * This will not word-wrap the string; you'll get a surface with a single line
 * of text, as long as the string requires. You can use
 * TTF_RenderText_Blended_Wrapped() instead if you need to wrap the output to
 * multiple lines.
 *
 * This will not wrap on newline characters.
 *
 * You can render at other quality levels with TTF_RenderText_Solid,
 * TTF_RenderText_Shaded, and TTF_RenderText_LCD.
 *
 * \param font the font to render with.
 * \param text text to render, in UTF-8 encoding.
 * \param length the length of the text, in bytes, or 0 for null terminated
 *               text.
 * \param fg the foreground color for the text.
 * \returns a new 32-bit, ARGB surface, or nil if there was an error.
 *
 * \threadsafety This function should be called on the thread that created the
 *               font.
 *
 * \since This function is available since SDL_ttf 3.0.0.
 *
 * \sa TTF_RenderText_Blended_Wrapped
 * \sa TTF_RenderText_LCD
 * \sa TTF_RenderText_Shaded
 * \sa TTF_RenderText_Solid
  }
function TTF_RenderText_Blended(font: PTTF_Font; text: PAnsiChar; length: csize_t; fg: TSDL_Color): PSDL_Surface; cdecl;
  external TTF_LibName {$IFDEF DELPHI} {$IFDEF MACOS} name '_TTF_RenderText_Blended' {$ENDIF} {$ENDIF};

{*
 * Render word-wrapped UTF-8 text at high quality to a new ARGB surface.
 *
 * This function will allocate a new 32-bit, ARGB surface, using alpha
 * blending to dither the font with the given color. This function returns the
 * new surface, or nil if there was an error.
 *
 * Text is wrapped to multiple lines on line endings and on word boundaries if
 * it extends beyond `wrap_width` in pixels.
 *
 * If wrap_width is 0, this function will only wrap on newline characters.
 *
 * You can render at other quality levels with TTF_RenderText_Solid_Wrapped,
 * TTF_RenderText_Shaded_Wrapped, and TTF_RenderText_LCD_Wrapped.
 *
 * \param font the font to render with.
 * \param text text to render, in UTF-8 encoding.
 * \param length the length of the text, in bytes, or 0 for null terminated
 *               text.
 * \param fg the foreground color for the text.
 * \param wrap_width the maximum width of the text surface or 0 to wrap on
 *                   newline characters.
 * \returns a new 32-bit, ARGB surface, or nil if there was an error.
 *
 * \threadsafety This function should be called on the thread that created the
 *               font.
 *
 * \since This function is available since SDL_ttf 3.0.0.
 *
 * \sa TTF_RenderText_Blended
 * \sa TTF_RenderText_LCD_Wrapped
 * \sa TTF_RenderText_Shaded_Wrapped
 * \sa TTF_RenderText_Solid_Wrapped
  }
function TTF_RenderText_Blended_Wrapped(font: PTTF_Font; text: PAnsiChar; length: csize_t; fg: TSDL_Color; wrap_width: cint): PSDL_Surface; cdecl;
  external TTF_LibName {$IFDEF DELPHI} {$IFDEF MACOS} name '_TTF_RenderText_Blended_Wrapped' {$ENDIF} {$ENDIF};

{*
 * Render a single UNICODE codepoint at high quality to a new ARGB surface.
 *
 * This function will allocate a new 32-bit, ARGB surface, using alpha
 * blending to dither the font with the given color. This function returns the
 * new surface, or nil if there was an error.
 *
 * The glyph is rendered without any padding or centering in the X direction,
 * and aligned normally in the Y direction.
 *
 * You can render at other quality levels with TTF_RenderGlyph_Solid,
 * TTF_RenderGlyph_Shaded, and TTF_RenderGlyph_LCD.
 *
 * \param font the font to render with.
 * \param ch the codepoint to render.
 * \param fg the foreground color for the text.
 * \returns a new 32-bit, ARGB surface, or nil if there was an error.
 *
 * \threadsafety This function should be called on the thread that created the
 *               font.
 *
 * \since This function is available since SDL_ttf 3.0.0.
 *
 * \sa TTF_RenderGlyph_LCD
 * \sa TTF_RenderGlyph_Shaded
 * \sa TTF_RenderGlyph_Solid
  }
function TTF_RenderGlyph_Blended(font: PTTF_Font; ch: cuint32; fg: TSDL_Color): PSDL_Surface; cdecl;
  external TTF_LibName {$IFDEF DELPHI} {$IFDEF MACOS} name '_TTF_RenderGlyph_Blended' {$ENDIF} {$ENDIF};

{*
 * Render UTF-8 text at LCD subpixel quality to a new ARGB surface.
 *
 * This function will allocate a new 32-bit, ARGB surface, and render
 * alpha-blended text using FreeType's LCD subpixel rendering. This function
 * returns the new surface, or nil if there was an error.
 *
 * This will not word-wrap the string; you'll get a surface with a single line
 * of text, as long as the string requires. You can use
 * TTF_RenderText_LCD_Wrapped() instead if you need to wrap the output to
 * multiple lines.
 *
 * This will not wrap on newline characters.
 *
 * You can render at other quality levels with TTF_RenderText_Solid,
 * TTF_RenderText_Shaded, and TTF_RenderText_Blended.
 *
 * \param font the font to render with.
 * \param text text to render, in UTF-8 encoding.
 * \param length the length of the text, in bytes, or 0 for null terminated
 *               text.
 * \param fg the foreground color for the text.
 * \param bg the background color for the text.
 * \returns a new 32-bit, ARGB surface, or nil if there was an error.
 *
 * \threadsafety This function should be called on the thread that created the
 *               font.
 *
 * \since This function is available since SDL_ttf 3.0.0.
 *
 * \sa TTF_RenderText_Blended
 * \sa TTF_RenderText_LCD_Wrapped
 * \sa TTF_RenderText_Shaded
 * \sa TTF_RenderText_Solid
  }
function TTF_RenderText_LCD(font: PTTF_Font; text: PAnsiChar; length: csize_t; fg: TSDL_Color; bg: TSDL_Color): PSDL_Surface; cdecl;
  external TTF_LibName {$IFDEF DELPHI} {$IFDEF MACOS} name '_TTF_RenderText_LCD' {$ENDIF} {$ENDIF};

{*
 * Render word-wrapped UTF-8 text at LCD subpixel quality to a new ARGB
 * surface.
 *
 * This function will allocate a new 32-bit, ARGB surface, and render
 * alpha-blended text using FreeType's LCD subpixel rendering. This function
 * returns the new surface, or nil if there was an error.
 *
 * Text is wrapped to multiple lines on line endings and on word boundaries if
 * it extends beyond `wrap_width` in pixels.
 *
 * If wrap_width is 0, this function will only wrap on newline characters.
 *
 * You can render at other quality levels with TTF_RenderText_Solid_Wrapped,
 * TTF_RenderText_Shaded_Wrapped, and TTF_RenderText_Blended_Wrapped.
 *
 * \param font the font to render with.
 * \param text text to render, in UTF-8 encoding.
 * \param length the length of the text, in bytes, or 0 for null terminated
 *               text.
 * \param fg the foreground color for the text.
 * \param bg the background color for the text.
 * \param wrap_width the maximum width of the text surface or 0 to wrap on
 *                   newline characters.
 * \returns a new 32-bit, ARGB surface, or nil if there was an error.
 *
 * \threadsafety This function should be called on the thread that created the
 *               font.
 *
 * \since This function is available since SDL_ttf 3.0.0.
 *
 * \sa TTF_RenderText_Blended_Wrapped
 * \sa TTF_RenderText_LCD
 * \sa TTF_RenderText_Shaded_Wrapped
 * \sa TTF_RenderText_Solid_Wrapped
  }
function TTF_RenderText_LCD_Wrapped(font: PTTF_Font; text: PAnsiChar; length: csize_t; fg: TSDL_Color; bg: TSDL_Color; wrap_width: cint): PSDL_Surface; cdecl;
  external TTF_LibName {$IFDEF DELPHI} {$IFDEF MACOS} name '_TTF_RenderText_LCD_Wrapped' {$ENDIF} {$ENDIF};

{*
 * Render a single UNICODE codepoint at LCD subpixel quality to a new ARGB
 * surface.
 *
 * This function will allocate a new 32-bit, ARGB surface, and render
 * alpha-blended text using FreeType's LCD subpixel rendering. This function
 * returns the new surface, or nil if there was an error.
 *
 * The glyph is rendered without any padding or centering in the X direction,
 * and aligned normally in the Y direction.
 *
 * You can render at other quality levels with TTF_RenderGlyph_Solid,
 * TTF_RenderGlyph_Shaded, and TTF_RenderGlyph_Blended.
 *
 * \param font the font to render with.
 * \param ch the codepoint to render.
 * \param fg the foreground color for the text.
 * \param bg the background color for the text.
 * \returns a new 32-bit, ARGB surface, or nil if there was an error.
 *
 * \threadsafety This function should be called on the thread that created the
 *               font.
 *
 * \since This function is available since SDL_ttf 3.0.0.
 *
 * \sa TTF_RenderGlyph_Blended
 * \sa TTF_RenderGlyph_Shaded
 * \sa TTF_RenderGlyph_Solid
  }
function TTF_RenderGlyph_LCD(font: PTTF_Font; ch: cuint32; fg: TSDL_Color; bg: TSDL_Color): PSDL_Surface; cdecl;
  external TTF_LibName {$IFDEF DELPHI} {$IFDEF MACOS} name '_TTF_RenderGlyph_LCD' {$ENDIF} {$ENDIF};

{*
 * A text engine used to create text objects.
 *
 * This is a public interface that can be used by applications and libraries
 * to perform customize rendering with text objects. See
 * <SDL3_ttf/SDL_textengine.h> for details.
 *
 * There are three text engines provided with the library:
 *
 * - Drawing to an SDL_Surface, created with TTF_CreateSurfaceTextEngine()
 * - Drawing with an SDL 2D renderer, created with
 *   TTF_CreateRendererTextEngine()
 * - Drawing with the SDL GPU API, created with TTF_CreateGPUTextEngine()
 *
 * \since This struct is available since SDL_ttf 3.0.0.
  }
type
  PPTTF_TextEngine = ^PTTF_TextEngine;
  PTTF_TextEngine = type Pointer;

{*
 * Internal data for TTF_Text
 *
 * \since This struct is available since SDL_ttf 3.0.0.
  }
type
  PPTTF_TextData = ^PTTF_TextData;
  PTTF_TextData = type Pointer;

{*
 * Text created with TTF_CreateText()
 *
 * \since This struct is available since SDL_ttf 3.0.0.
 *
 * \sa TTF_CreateText
 * \sa TTF_GetTextProperties
 * \sa TTF_DestroyText
  }
type
  PPTTF_Text = ^PTTF_Text;
  PTTF_Text = ^TTTF_Text;
  TTTF_Text = record
      text: PAnsiChar;         {*< A copy of the UTF-8 string that this text object represents, useful for layout, debugging and retrieving substring text. This is updated when the text object is modified and will be freed automatically when the object is destroyed.  }
      num_lines: cint;         {*< The number of lines in the text, 0 if it's empty  }
      refcount: cint;          {*< Application reference count, used when freeing surface  }
      internal: PTTF_TextData; {*< Private  }
    end;

{*
 * Create a text engine for drawing text on SDL surfaces.
 *
 * \returns a TTF_TextEngine object or nil on failure; call SDL_GetError()
 *          for more information.
 *
 * \threadsafety It is safe to call this function from any thread.
 *
 * \since This function is available since SDL_ttf 3.0.0.
 *
 * \sa TTF_DestroySurfaceTextEngine
 * \sa TTF_DrawSurfaceText
  }
function TTF_CreateSurfaceTextEngine: PTTF_TextEngine; cdecl;
  external TTF_LibName {$IFDEF DELPHI} {$IFDEF MACOS} name '_TTF_CreateSurfaceTextEngine' {$ENDIF} {$ENDIF};

{*
 * Draw text to an SDL surface.
 *
 * `text` must have been created using a TTF_TextEngine from
 * TTF_CreateSurfaceTextEngine().
 *
 * \param text the text to draw.
 * \param x the x coordinate in pixels, positive from the left edge towards
 *          the right.
 * \param y the y coordinate in pixels, positive from the top edge towards the
 *          bottom.
 * \param surface the surface to draw on.
 * \returns true on success or false on failure; call SDL_GetError() for more
 *          information.
 *
 * \threadsafety This function should be called on the thread that created the
 *               text.
 *
 * \since This function is available since SDL_ttf 3.0.0.
 *
 * \sa TTF_CreateSurfaceTextEngine
 * \sa TTF_CreateText
 }
function TTF_DrawSurfaceText(text: PTTF_Text; x: cint; y: cint; surface: PSDL_Surface): Boolean; cdecl;
  external TTF_LibName {$IFDEF DELPHI} {$IFDEF MACOS} name '_TTF_DrawSurfaceText' {$ENDIF} {$ENDIF};

{*
 * Destroy a text engine created for drawing text on SDL surfaces.
 *
 * All text created by this engine should be destroyed before calling this
 * function.
 *
 * \param engine a TTF_TextEngine object created with
 *               TTF_CreateSurfaceTextEngine().
 *
 * \threadsafety This function should be called on the thread that created the
 *               engine.
 *
 * \since This function is available since SDL_ttf 3.0.0.
 *
 * \sa TTF_CreateSurfaceTextEngine
  }
procedure TTF_DestroySurfaceTextEngine(engine: PTTF_TextEngine); cdecl;
  external TTF_LibName {$IFDEF DELPHI} {$IFDEF MACOS} name '_TTF_DestroySurfaceTextEngine' {$ENDIF} {$ENDIF};

{*
 * Create a text engine for drawing text on an SDL renderer.
 *
 * \param renderer the renderer to use for creating textures and drawing text.
 * \returns a TTF_TextEngine object or nil on failure; call SDL_GetError()
 *          for more information.
 *
 * \threadsafety This function should be called on the thread that created the
 *               renderer.
 *
 * \since This function is available since SDL_ttf 3.0.0.
 *
 * \sa TTF_DestroyRendererTextEngine
  }
function TTF_CreateRendererTextEngine(renderer: PSDL_Renderer): PTTF_TextEngine; cdecl;
  external TTF_LibName {$IFDEF DELPHI} {$IFDEF MACOS} name '_TTF_CreateRendererTextEngine' {$ENDIF} {$ENDIF};

{*
 * Create a text engine for drawing text on an SDL renderer, with the
 * specified properties.
 *
 * These are the supported properties:
 *
 * - `TTF_PROP_RENDERER_TEXT_ENGINE_RENDERER`: the renderer to use for
 *   creating textures and drawing text
 * - `TTF_PROP_RENDERER_TEXT_ENGINE_ATLAS_TEXTURE_SIZE`: the size of the
 *   texture atlas
 *
 * \param props the properties to use.
 * \returns a TTF_TextEngine object or nil on failure; call SDL_GetError()
 *          for more information.
 *
 * \threadsafety This function should be called on the thread that created the
 *               renderer.
 *
 * \since This function is available since SDL_ttf 3.0.0.
 *
 * \sa TTF_DestroyRendererTextEngine
  }
function TTF_CreateRendererTextEngineWithProperties(props: TSDL_PropertiesID): PTTF_TextEngine; cdecl;
  external TTF_LibName {$IFDEF DELPHI} {$IFDEF MACOS} name '_TTF_CreateRendererTextEngineWithProperties' {$ENDIF} {$ENDIF};

const
  TTF_PROP_RENDERER_TEXT_ENGINE_RENDERER = 'SDL_ttf.renderer_text_engine.create.renderer';
  TTF_PROP_RENDERER_TEXT_ENGINE_ATLAS_TEXTURE_SIZE = 'SDL_ttf.renderer_text_engine.create.atlas_texture_size';

{*
 * Draw text to an SDL renderer.
 *
 * `text` must have been created using a TTF_TextEngine from
 * TTF_CreateRendererTextEngine(), and will draw using the renderer passed to
 * that function.
 *
 * \param text the text to draw.
 * \param x the x coordinate in pixels, positive from the left edge towards
 *          the right.
 * \param y the y coordinate in pixels, positive from the top edge towards the
 *          bottom.
 * \returns true on success or false on failure; call SDL_GetError() for more
 *          information.
 *
 * \threadsafety This function should be called on the thread that created the
 *               text.
 *
 * \since This function is available since SDL_ttf 3.0.0.
 *
 * \sa TTF_CreateRendererTextEngine
 * \sa TTF_CreateText
  }
function TTF_DrawRendererText(text: PTTF_Text; x: cfloat; y: cfloat): Boolean; cdecl;
  external TTF_LibName {$IFDEF DELPHI} {$IFDEF MACOS} name '_TTF_DrawRendererText' {$ENDIF} {$ENDIF};

{*
 * Destroy a text engine created for drawing text on an SDL renderer.
 *
 * All text created by this engine should be destroyed before calling this
 * function.
 *
 * \param engine a TTF_TextEngine object created with
 *               TTF_CreateRendererTextEngine().
 *
 * \threadsafety This function should be called on the thread that created the
 *               engine.
 *
 * \since This function is available since SDL_ttf 3.0.0.
 *
 * \sa TTF_CreateRendererTextEngine
  }
procedure TTF_DestroyRendererTextEngine(engine: PTTF_TextEngine); cdecl;
  external TTF_LibName {$IFDEF DELPHI} {$IFDEF MACOS} name '_TTF_DestroyRendererTextEngine' {$ENDIF} {$ENDIF};

{*
 * Create a text engine for drawing text with the SDL GPU API.
 *
 * \param device the SDL_GPUDevice to use for creating textures and drawing
 *               text.
 * \returns a TTF_TextEngine object or nil on failure; call SDL_GetError()
 *          for more information.
 *
 * \threadsafety This function should be called on the thread that created the
 *               device.
 *
 * \since This function is available since SDL_ttf 3.0.0.
 *
 * \sa TTF_DestroyGPUTextEngine
  }
function TTF_CreateGPUTextEngine(device: PSDL_GPUDevice): PTTF_TextEngine; cdecl;
  external TTF_LibName {$IFDEF DELPHI} {$IFDEF MACOS} name '_TTF_CreateGPUTextEngine' {$ENDIF} {$ENDIF};

{*
 * Create a text engine for drawing text with the SDL GPU API, with the
 * specified properties.
 *
 * These are the supported properties:
 *
 * - `TTF_PROP_GPU_TEXT_ENGINE_DEVICE`: the SDL_GPUDevice to use for creating
 *   textures and drawing text.
 * - `TTF_PROP_GPU_TEXT_ENGINE_ATLAS_TEXTURE_SIZE`: the size of the texture
 *   atlas
 *
 * \param props the properties to use.
 * \returns a TTF_TextEngine object or nil on failure; call SDL_GetError()
 *          for more information.
 *
 * \threadsafety This function should be called on the thread that created the
 *               device.
 *
 * \since This function is available since SDL_ttf 3.0.0.
 *
 * \sa TTF_DestroyGPUTextEngine
  }
function TTF_CreateGPUTextEngineWithProperties(props: TSDL_PropertiesID): PTTF_TextEngine; cdecl;
  external TTF_LibName {$IFDEF DELPHI} {$IFDEF MACOS} name '_TTF_CreateGPUTextEngineWithProperties' {$ENDIF} {$ENDIF};

const
  TTF_PROP_GPU_TEXT_ENGINE_DEVICE = 'SDL_ttf.gpu_text_engine.create.device';
  TTF_PROP_GPU_TEXT_ENGINE_ATLAS_TEXTURE_SIZE = 'SDL_ttf.gpu_text_engine.create.atlas_texture_size';

{*
 * Draw sequence returned by TTF_GetGPUTextDrawData
 *
 * \since This struct is available since SDL_ttf 3.0.0.
 *
 * \sa TTF_GetGPUTextDrawData
  }
type
  PPTTF_GPUAtlasDrawSequence = ^PTTF_GPUAtlasDrawSequence;
  PTTF_GPUAtlasDrawSequence = ^TTTF_GPUAtlasDrawSequence;
  TTTF_GPUAtlasDrawSequence = record
      atlas_texture: PSDL_GPUTexture; {*< Texture atlas that stores the glyphs  }
      xy: PSDL_FPoint;                {*< An array of vertex positions  }
      uv: PSDL_FPoint;                {*< An array of normalized texture coordinates for each vertex  }
      num_vertices: cint;             {*< Number of vertices  }
      indices: pcint;                 {*< An array of indices into the 'vertices' arrays  }
      num_indices: cint;              {*< Number of indices  }
      image_type: TTTF_ImageType;     {*< The image type of this draw sequence  }
      next: PTTF_GPUAtlasDrawSequence;{*< The next sequence (will be nil in case of the last sequence)  }
    end;

{*
 * Get the geometry data needed for drawing the text.
 *
 * `text` must have been created using a TTF_TextEngine from
 * TTF_CreateGPUTextEngine().
 *
 * The positive X-axis is taken towards the right and the positive Y-axis is
 * taken upwards for both the vertex and the texture coordinates, i.e, it
 * follows the same convention used by the SDL_GPU API. If you want to use a
 * different coordinate system you will need to transform the vertices
 * yourself.
 *
 * If the text looks blocky use linear filtering.
 *
 * \param text the text to draw.
 * \returns a nil terminated linked list of TTF_GPUAtlasDrawSequence objects
 *          or nil if the passed text is empty or in case of failure; call
 *          SDL_GetError() for more information.
 *
 * \threadsafety This function should be called on the thread that created the
 *               text.
 *
 * \since This function is available since SDL_ttf 3.0.0.
 *
 * \sa TTF_CreateGPUTextEngine
 * \sa TTF_CreateText
  }
function TTF_GetGPUTextDrawData(text: PTTF_Text): PTTF_GPUAtlasDrawSequence; cdecl;
  external TTF_LibName {$IFDEF DELPHI} {$IFDEF MACOS} name '_TTF_GetGPUTextDrawData' {$ENDIF} {$ENDIF};

{*
 * Destroy a text engine created for drawing text with the SDL GPU API.
 *
 * All text created by this engine should be destroyed before calling this
 * function.
 *
 * \param engine a TTF_TextEngine object created with
 *               TTF_CreateGPUTextEngine().
 *
 * \threadsafety This function should be called on the thread that created the
 *               engine.
 *
 * \since This function is available since SDL_ttf 3.0.0.
 *
 * \sa TTF_CreateGPUTextEngine
  }
procedure TTF_DestroyGPUTextEngine(engine: PTTF_TextEngine); cdecl;
  external TTF_LibName {$IFDEF DELPHI} {$IFDEF MACOS} name '_TTF_DestroyGPUTextEngine' {$ENDIF} {$ENDIF};

{*
 * The winding order of the vertices returned by TTF_GetGPUTextDrawData
 *
 * \since This enum is available since SDL_ttf 3.0.0.
  }
type
  PPTTF_GPUTextEngineWinding = ^PTTF_GPUTextEngineWinding;
  PTTF_GPUTextEngineWinding = ^TTTF_GPUTextEngineWinding;
  TTTF_GPUTextEngineWinding = type Integer;

const
  TTF_GPU_TEXTENGINE_WINDING_INVALID = TTTF_GPUTextEngineWinding(-1);
  TTF_GPU_TEXTENGINE_WINDING_CLOCKWISE  = TTTF_GPUTextEngineWinding(0);
  TTF_GPU_TEXTENGINE_WINDING_COUNTER_CLOCKWISE  = TTTF_GPUTextEngineWinding(1);

{*
 * Sets the winding order of the vertices returned by TTF_GetGPUTextDrawData
 * for a particular GPU text engine.
 *
 * \param engine a TTF_TextEngine object created with
 *               TTF_CreateGPUTextEngine().
 * \param winding the new winding order option.
 *
 * \threadsafety This function should be called on the thread that created the
 *               engine.
 *
 * \since This function is available since SDL_ttf 3.0.0.
 *
 * \sa TTF_GetGPUTextEngineWinding
  }
procedure TTF_SetGPUTextEngineWinding(engine: PTTF_TextEngine; winding: TTTF_GPUTextEngineWinding); cdecl;
  external TTF_LibName {$IFDEF DELPHI} {$IFDEF MACOS} name '_TTF_SetGPUTextEngineWinding' {$ENDIF} {$ENDIF};

{*
 * Get the winding order of the vertices returned by TTF_GetGPUTextDrawData
 * for a particular GPU text engine
 *
 * \param engine a TTF_TextEngine object created with
 *               TTF_CreateGPUTextEngine().
 * \returns the winding order used by the GPU text engine or
 *          TTF_GPU_TEXTENGINE_WINDING_INVALID in case of error.
 *
 * \threadsafety This function should be called on the thread that created the
 *               engine.
 *
 * \since This function is available since SDL_ttf 3.0.0.
 *
 * \sa TTF_SetGPUTextEngineWinding
  }
function TTF_GetGPUTextEngineWinding(engine: PTTF_TextEngine): TTTF_GPUTextEngineWinding; cdecl;
  external TTF_LibName {$IFDEF DELPHI} {$IFDEF MACOS} name '_TTF_GetGPUTextEngineWinding' {$ENDIF} {$ENDIF};

{*
 * Create a text object from UTF-8 text and a text engine.
 *
 * \param engine the text engine to use when creating the text object, may be
 *               nil.
 * \param font the font to render with.
 * \param text the text to use, in UTF-8 encoding.
 * \param length the length of the text, in bytes, or 0 for null terminated
 *               text.
 * \returns a TTF_Text object or nil on failure; call SDL_GetError() for more
 *          information.
 *
 * \threadsafety This function should be called on the thread that created the
 *               font and text engine.
 *
 * \since This function is available since SDL_ttf 3.0.0.
 *
 * \sa TTF_DestroyText
  }
function TTF_CreateText(engine: PTTF_TextEngine; font: PTTF_Font; text: PAnsiChar; length: csize_t): PTTF_Text; cdecl;
  external TTF_LibName {$IFDEF DELPHI} {$IFDEF MACOS} name '_TTF_CreateText' {$ENDIF} {$ENDIF};

{*
 * Get the properties associated with a text object.
 *
 * \param text the TTF_Text to query.
 * \returns a valid property ID on success or 0 on failure; call
 *          SDL_GetError() for more information.
 *
 * \threadsafety This function should be called on the thread that created the
 *               text.
 *
 * \since This function is available since SDL_ttf 3.0.0.
  }
function TTF_GetTextProperties(text: PTTF_Text): TSDL_PropertiesID; cdecl;
  external TTF_LibName {$IFDEF DELPHI} {$IFDEF MACOS} name '_TTF_GetTextProperties' {$ENDIF} {$ENDIF};

{*
 * Set the text engine used by a text object.
 *
 * This function may cause the internal text representation to be rebuilt.
 *
 * \param text the TTF_Text to modify.
 * \param engine the text engine to use for drawing.
 * \returns true on success or false on failure; call SDL_GetError() for more
 *          information.
 *
 * \threadsafety This function should be called on the thread that created the
 *               text.
 *
 * \since This function is available since SDL_ttf 3.0.0.
 *
 * \sa TTF_GetTextEngine
  }
function TTF_SetTextEngine(text: PTTF_Text; engine: PTTF_TextEngine): Boolean; cdecl;
  external TTF_LibName {$IFDEF DELPHI} {$IFDEF MACOS} name '_TTF_SetTextEngine' {$ENDIF} {$ENDIF};

{*
 * Get the text engine used by a text object.
 *
 * \param text the TTF_Text to query.
 * \returns the TTF_TextEngine used by the text on success or nil on failure;
 *          call SDL_GetError() for more information.
 *
 * \threadsafety This function should be called on the thread that created the
 *               text.
 *
 * \since This function is available since SDL_ttf 3.0.0.
 *
 * \sa TTF_SetTextEngine
  }
function TTF_GetTextEngine(text: PTTF_Text): PTTF_TextEngine; cdecl;
  external TTF_LibName {$IFDEF DELPHI} {$IFDEF MACOS} name '_TTF_GetTextEngine' {$ENDIF} {$ENDIF};

{*
 * Set the font used by a text object.
 *
 * When a text object has a font, any changes to the font will automatically
 * regenerate the text. If you set the font to nil, the text will continue to
 * render but changes to the font will no longer affect the text.
 *
 * This function may cause the internal text representation to be rebuilt.
 *
 * \param text the TTF_Text to modify.
 * \param font the font to use, may be nil.
 * \returns false if the text Pointer is null; otherwise, true. call
 *          SDL_GetError() for more information.
 *
 * \threadsafety This function should be called on the thread that created the
 *               text.
 *
 * \since This function is available since SDL_ttf 3.0.0.
 *
 * \sa TTF_GetTextFont
  }
function TTF_SetTextFont(text: PTTF_Text; font: PTTF_Font): Boolean; cdecl;
  external TTF_LibName {$IFDEF DELPHI} {$IFDEF MACOS} name '_TTF_SetTextFont' {$ENDIF} {$ENDIF};

{*
 * Get the font used by a text object.
 *
 * \param text the TTF_Text to query.
 * \returns the TTF_Font used by the text on success or nil on failure; call
 *          SDL_GetError() for more information.
 *
 * \threadsafety This function should be called on the thread that created the
 *               text.
 *
 * \since This function is available since SDL_ttf 3.0.0.
 *
 * \sa TTF_SetTextFont
  }
function TTF_GetTextFont(text: PTTF_Text): PTTF_Font; cdecl;
  external TTF_LibName {$IFDEF DELPHI} {$IFDEF MACOS} name '_TTF_GetTextFont' {$ENDIF} {$ENDIF};

{*
 * Set the direction to be used for text shaping a text object.
 *
 * This function only supports left-to-right text shaping if SDL_ttf was not
 * built with HarfBuzz support.
 *
 * \param text the text to modify.
 * \param direction the new direction for text to flow.
 * \returns true on success or false on failure; call SDL_GetError() for more
 *          information.
 *
 * \threadsafety This function should be called on the thread that created the
 *               text.
 *
 * \since This function is available since SDL_ttf 3.0.0.
  }
function TTF_SetTextDirection(text: PTTF_Text; direction: TTTF_Direction): Boolean; cdecl;
  external TTF_LibName {$IFDEF DELPHI} {$IFDEF MACOS} name '_TTF_SetTextDirection' {$ENDIF} {$ENDIF};

{*
 * Get the direction to be used for text shaping a text object.
 *
 * This defaults to the direction of the font used by the text object.
 *
 * \param text the text to query.
 * \returns the direction to be used for text shaping.
 *
 * \threadsafety This function should be called on the thread that created the
 *               text.
 *
 * \since This function is available since SDL_ttf 3.0.0.
  }
function TTF_GetTextDirection(text: PTTF_Text): TTTF_Direction; cdecl;
  external TTF_LibName {$IFDEF DELPHI} {$IFDEF MACOS} name '_TTF_GetTextDirection' {$ENDIF} {$ENDIF};

{*
 * Set the script to be used for text shaping a text object.
 *
 * This returns false if SDL_ttf isn't build with HarfBuzz support.
 *
 * \param text the text to modify.
 * \param script a script tag in the format used by HarfBuzz.
 * \returns true on success or false on failure; call SDL_GetError() for more
 *          information.
 *
 * \threadsafety This function should be called on the thread that created the
 *               text.
 *
 * \since This function is available since SDL_ttf 3.0.0.
  }
function TTF_SetTextScript(text: PTTF_Text; script: cuint32): Boolean; cdecl;
  external TTF_LibName {$IFDEF DELPHI} {$IFDEF MACOS} name '_TTF_SetTextScript' {$ENDIF} {$ENDIF};

{*
 * Get the script used for text shaping a text object.
 *
 * This defaults to the script of the font used by the text object.
 *
 * \param text the text to query.
 * \returns a script tag in the format used by HarfBuzz.
 *
 * \threadsafety This function should be called on the thread that created the
 *               text.
 *
 * \since This function is available since SDL_ttf 3.0.0.
  }
function TTF_GetTextScript(text: PTTF_Text): cuint32; cdecl;
  external TTF_LibName {$IFDEF DELPHI} {$IFDEF MACOS} name '_TTF_GetTextScript' {$ENDIF} {$ENDIF};

{*
 * Set the color of a text object.
 *
 * The default text color is white (255, 255, 255, 255).
 *
 * \param text the TTF_Text to modify.
 * \param r the red color value in the range of 0-255.
 * \param g the green color value in the range of 0-255.
 * \param b the blue color value in the range of 0-255.
 * \param a the alpha value in the range of 0-255.
 * \returns true on success or false on failure; call SDL_GetError() for more
 *          information.
 *
 * \threadsafety This function should be called on the thread that created the
 *               text.
 *
 * \since This function is available since SDL_ttf 3.0.0.
 *
 * \sa TTF_GetTextColor
 * \sa TTF_SetTextColorFloat
  }
function TTF_SetTextColor(text: PTTF_Text; r: cuint8; g: cuint8; b: cuint8; a: cuint8): Boolean; cdecl;
  external TTF_LibName {$IFDEF DELPHI} {$IFDEF MACOS} name '_TTF_SetTextColor' {$ENDIF} {$ENDIF};

{*
 * Set the color of a text object.
 *
 * The default text color is white (1.0f, 1.0f, 1.0f, 1.0f).
 *
 * \param text the TTF_Text to modify.
 * \param r the red color value, normally in the range of 0-1.
 * \param g the green color value, normally in the range of 0-1.
 * \param b the blue color value, normally in the range of 0-1.
 * \param a the alpha value in the range of 0-1.
 * \returns true on success or false on failure; call SDL_GetError() for more
 *          information.
 *
 * \threadsafety This function should be called on the thread that created the
 *               text.
 *
 * \since This function is available since SDL_ttf 3.0.0.
 *
 * \sa TTF_GetTextColorFloat
 * \sa TTF_SetTextColor
  }
function TTF_SetTextColorFloat(text: PTTF_Text; r: cfloat; g: cfloat; b: cfloat; a: cfloat): Boolean; cdecl;
  external TTF_LibName {$IFDEF DELPHI} {$IFDEF MACOS} name '_TTF_SetTextColorFloat' {$ENDIF} {$ENDIF};

{*
 * Get the color of a text object.
 *
 * \param text the TTF_Text to query.
 * \param r a Pointer filled in with the red color value in the range of
 *          0-255, may be nil.
 * \param g a Pointer filled in with the green color value in the range of
 *          0-255, may be nil.
 * \param b a Pointer filled in with the blue color value in the range of
 *          0-255, may be nil.
 * \param a a Pointer filled in with the alpha value in the range of 0-255,
 *          may be nil.
 * \returns true on success or false on failure; call SDL_GetError() for more
 *          information.
 *
 * \threadsafety This function should be called on the thread that created the
 *               text.
 *
 * \since This function is available since SDL_ttf 3.0.0.
 *
 * \sa TTF_GetTextColorFloat
 * \sa TTF_SetTextColor
  }
function TTF_GetTextColor(text: PTTF_Text; r: pcuint8; g: pcuint8; b: pcuint8; a: pcuint8): Boolean; cdecl;
  external TTF_LibName {$IFDEF DELPHI} {$IFDEF MACOS} name '_TTF_GetTextColor' {$ENDIF} {$ENDIF};

{*
 * Get the color of a text object.
 *
 * \param text the TTF_Text to query.
 * \param r a Pointer filled in with the red color value, normally in the
 *          range of 0-1, may be nil.
 * \param g a Pointer filled in with the green color value, normally in the
 *          range of 0-1, may be nil.
 * \param b a Pointer filled in with the blue color value, normally in the
 *          range of 0-1, may be nil.
 * \param a a Pointer filled in with the alpha value in the range of 0-1, may
 *          be nil.
 * \returns true on success or false on failure; call SDL_GetError() for more
 *          information.
 *
 * \threadsafety This function should be called on the thread that created the
 *               text.
 *
 * \since This function is available since SDL_ttf 3.0.0.
 *
 * \sa TTF_GetTextColor
 * \sa TTF_SetTextColorFloat
  }
function TTF_GetTextColorFloat(text: PTTF_Text; r: pcfloat; g: pcfloat; b: pcfloat; a: pcfloat): Boolean; cdecl;
  external TTF_LibName {$IFDEF DELPHI} {$IFDEF MACOS} name '_TTF_GetTextColorFloat' {$ENDIF} {$ENDIF};

{*
 * Set the position of a text object.
 *
 * This can be used to position multiple text objects within a single wrapping
 * text area.
 *
 * This function may cause the internal text representation to be rebuilt.
 *
 * \param text the TTF_Text to modify.
 * \param x the x offset of the upper left corner of this text in pixels.
 * \param y the y offset of the upper left corner of this text in pixels.
 *
 * \threadsafety This function should be called on the thread that created the
 *               text.
 *
 * \since This function is available since SDL_ttf 3.0.0.
 *
 * \sa TTF_GetTextPosition
  }
function TTF_SetTextPosition(text: PTTF_Text; x: cint; y: cint): Boolean; cdecl;
  external TTF_LibName {$IFDEF DELPHI} {$IFDEF MACOS} name '_TTF_SetTextPosition' {$ENDIF} {$ENDIF};

{*
 * Get the position of a text object.
 *
 * \param text the TTF_Text to query.
 * \param x a Pointer filled in with the x offset of the upper left corner of
 *          this text in pixels, may be nil.
 * \param y a Pointer filled in with the y offset of the upper left corner of
 *          this text in pixels, may be nil.
 *
 * \threadsafety This function should be called on the thread that created the
 *               text.
 *
 * \since This function is available since SDL_ttf 3.0.0.
 *
 * \sa TTF_SetTextPosition
  }
function TTF_GetTextPosition(text: PTTF_Text; x: pcint; y: pcint): Boolean; cdecl;
  external TTF_LibName {$IFDEF DELPHI} {$IFDEF MACOS} name '_TTF_GetTextPosition' {$ENDIF} {$ENDIF};

{*
 * Set whether wrapping is enabled on a text object.
 *
 * This function may cause the internal text representation to be rebuilt.
 *
 * \param text the TTF_Text to modify.
 * \param wrap_width the maximum width in pixels, 0 to wrap on newline
 *                   characters.
 * \returns true on success or false on failure; call SDL_GetError() for more
 *          information.
 *
 * \threadsafety This function should be called on the thread that created the
 *               text.
 *
 * \since This function is available since SDL_ttf 3.0.0.
 *
 * \sa TTF_GetTextWrapWidth
  }
function TTF_SetTextWrapWidth(text: PTTF_Text; wrap_width: cint): Boolean; cdecl;
  external TTF_LibName {$IFDEF DELPHI} {$IFDEF MACOS} name '_TTF_SetTextWrapWidth' {$ENDIF} {$ENDIF};

{*
 * Get whether wrapping is enabled on a text object.
 *
 * \param text the TTF_Text to query.
 * \param wrap_width a Pointer filled in with the maximum width in pixels or 0
 *                   if the text is being wrapped on newline characters.
 * \returns true on success or false on failure; call SDL_GetError() for more
 *          information.
 *
 * \threadsafety This function should be called on the thread that created the
 *               text.
 *
 * \since This function is available since SDL_ttf 3.0.0.
 *
 * \sa TTF_SetTextWrapWidth
  }
function TTF_GetTextWrapWidth(text: PTTF_Text; wrap_width: pcint): Boolean; cdecl;
  external TTF_LibName {$IFDEF DELPHI} {$IFDEF MACOS} name '_TTF_GetTextWrapWidth' {$ENDIF} {$ENDIF};

{*
 * Set whether whitespace should be visible when wrapping a text object.
 *
 * If the whitespace is visible, it will take up space for purposes of
 * alignment and wrapping. This is good for editing, but looks better when
 * centered or aligned if whitespace around line wrapping is hidden. This
 * defaults false.
 *
 * This function may cause the internal text representation to be rebuilt.
 *
 * \param text the TTF_Text to modify.
 * \param visible true to show whitespace when wrapping text, false to hide
 *                it.
 * \returns true on success or false on failure; call SDL_GetError() for more
 *          information.
 *
 * \threadsafety This function should be called on the thread that created the
 *               text.
 *
 * \since This function is available since SDL_ttf 3.0.0.
 *
 * \sa TTF_TextWrapWhitespaceVisible
  }
function TTF_SetTextWrapWhitespaceVisible(text: PTTF_Text; visible: Boolean): Boolean; cdecl;
  external TTF_LibName {$IFDEF DELPHI} {$IFDEF MACOS} name '_TTF_SetTextWrapWhitespaceVisible' {$ENDIF} {$ENDIF};

{*
 * Return whether whitespace is shown when wrapping a text object.
 *
 * \param text the TTF_Text to query.
 * \returns true if whitespace is shown when wrapping text, or false
 *          otherwise.
 *
 * \threadsafety This function should be called on the thread that created the
 *               text.
 *
 * \since This function is available since SDL_ttf 3.0.0.
 *
 * \sa TTF_SetTextWrapWhitespaceVisible
  }
function TTF_TextWrapWhitespaceVisible(text: PTTF_Text): Boolean; cdecl;
  external TTF_LibName {$IFDEF DELPHI} {$IFDEF MACOS} name '_TTF_TextWrapWhitespaceVisible' {$ENDIF} {$ENDIF};

{*
 * Set the UTF-8 text used by a text object.
 *
 * This function may cause the internal text representation to be rebuilt.
 *
 * \param text the TTF_Text to modify.
 * \param string the UTF-8 text to use, may be nil.
 * \param length the length of the text, in bytes, or 0 for null terminated
 *               text.
 * \returns true on success or false on failure; call SDL_GetError() for more
 *          information.
 *
 * \threadsafety This function should be called on the thread that created the
 *               text.
 *
 * \since This function is available since SDL_ttf 3.0.0.
 *
 * \sa TTF_AppendTextString
 * \sa TTF_DeleteTextString
 * \sa TTF_InsertTextString
  }
function TTF_SetTextString(text: PTTF_Text; _string: PAnsiChar; length: csize_t): Boolean; cdecl;
  external TTF_LibName {$IFDEF DELPHI} {$IFDEF MACOS} name '_TTF_SetTextString' {$ENDIF} {$ENDIF};

{*
 * Insert UTF-8 text into a text object.
 *
 * This function may cause the internal text representation to be rebuilt.
 *
 * \param text the TTF_Text to modify.
 * \param offset the offset, in bytes, from the beginning of the string if >=
 *               0, the offset from the end of the string if < 0. Note that
 *               this does not do UTF-8 validation, so you should only insert
 *               at UTF-8 sequence boundaries.
 * \param string the UTF-8 text to insert.
 * \param length the length of the text, in bytes, or 0 for null terminated
 *               text.
 * \returns true on success or false on failure; call SDL_GetError() for more
 *          information.
 *
 * \threadsafety This function should be called on the thread that created the
 *               text.
 *
 * \since This function is available since SDL_ttf 3.0.0.
 *
 * \sa TTF_AppendTextString
 * \sa TTF_DeleteTextString
 * \sa TTF_SetTextString
  }
function TTF_InsertTextString(text: PTTF_Text; offset: cint; _string: PAnsiChar; length: csize_t): Boolean; cdecl;
  external TTF_LibName {$IFDEF DELPHI} {$IFDEF MACOS} name '_TTF_InsertTextString' {$ENDIF} {$ENDIF};

{*
 * Append UTF-8 text to a text object.
 *
 * This function may cause the internal text representation to be rebuilt.
 *
 * \param text the TTF_Text to modify.
 * \param string the UTF-8 text to insert.
 * \param length the length of the text, in bytes, or 0 for null terminated
 *               text.
 * \returns true on success or false on failure; call SDL_GetError() for more
 *          information.
 *
 * \threadsafety This function should be called on the thread that created the
 *               text.
 *
 * \since This function is available since SDL_ttf 3.0.0.
 *
 * \sa TTF_DeleteTextString
 * \sa TTF_InsertTextString
 * \sa TTF_SetTextString
  }
function TTF_AppendTextString(text: PTTF_Text; _string: PAnsiChar; length: csize_t): Boolean; cdecl;
  external TTF_LibName {$IFDEF DELPHI} {$IFDEF MACOS} name '_TTF_AppendTextString' {$ENDIF} {$ENDIF};

{*
 * Delete UTF-8 text from a text object.
 *
 * This function may cause the internal text representation to be rebuilt.
 *
 * \param text the TTF_Text to modify.
 * \param offset the offset, in bytes, from the beginning of the string if >=
 *               0, the offset from the end of the string if < 0. Note that
 *               this does not do UTF-8 validation, so you should only delete
 *               at UTF-8 sequence boundaries.
 * \param length the length of text to delete, in bytes, or -1 for the
 *               remainder of the string.
 * \returns true on success or false on failure; call SDL_GetError() for more
 *          information.
 *
 * \threadsafety This function should be called on the thread that created the
 *               text.
 *
 * \since This function is available since SDL_ttf 3.0.0.
 *
 * \sa TTF_AppendTextString
 * \sa TTF_InsertTextString
 * \sa TTF_SetTextString
  }
function TTF_DeleteTextString(text: PTTF_Text; offset: cint; length: cint): Boolean; cdecl;
  external TTF_LibName {$IFDEF DELPHI} {$IFDEF MACOS} name '_TTF_DeleteTextString' {$ENDIF} {$ENDIF};

{*
 * Get the size of a text object.
 *
 * The size of the text may change when the font or font style and size
 * change.
 *
 * \param text the TTF_Text to query.
 * \param w a Pointer filled in with the width of the text, in pixels, may be
 *          nil.
 * \param h a Pointer filled in with the height of the text, in pixels, may be
 *          nil.
 * \returns true on success or false on failure; call SDL_GetError() for more
 *          information.
 *
 * \threadsafety This function should be called on the thread that created the
 *               text.
 *
 * \since This function is available since SDL_ttf 3.0.0.
  }
function TTF_GetTextSize(text: PTTF_Text; w: pcint; h: pcint): Boolean; cdecl;
  external TTF_LibName {$IFDEF DELPHI} {$IFDEF MACOS} name '_TTF_GetTextSize' {$ENDIF} {$ENDIF};

{*
 * Flags for TTF_SubString
 *
 * \since This datatype is available since SDL_ttf 3.0.0.
 *
 * \sa TTF_SubString
  }
type
  PPTTF_SubStringFlags = ^PTTF_SubStringFlags;
  PTTF_SubStringFlags = ^TTTF_SubStringFlags;
  TTTF_SubStringFlags = type cuint32;
const
  TTF_SUBSTRING_DIRECTION_MASK  = TTTF_SubStringFlags($000000FF); {*< The mask for the flow direction for this substring  }
  TTF_SUBSTRING_TEXT_START  = TTTF_SubStringFlags($00000100);     {*< This substring contains the beginning of the text  }
  TTF_SUBSTRING_LINE_START  = TTTF_SubStringFlags($00000200);     {*< This substring contains the beginning of line `line_index`  }
  TTF_SUBSTRING_LINE_END  = TTTF_SubStringFlags($00000400);       {*< This substring contains the end of line `line_index`  }
  TTF_SUBSTRING_TEXT_END  = TTTF_SubStringFlags($00000800);       {*< This substring contains the end of the text  }

{*
 * The representation of a substring within text.
 *
 * \since This struct is available since SDL_ttf 3.0.0.
 *
 * \sa TTF_GetNextTextSubString
 * \sa TTF_GetPreviousTextSubString
 * \sa TTF_GetTextSubString
 * \sa TTF_GetTextSubStringForLine
 * \sa TTF_GetTextSubStringForPoint
 * \sa TTF_GetTextSubStringsForRange
  }
type
  PPTTF_SubString = ^PTTF_SubString;
  PTTF_SubString = ^TTTF_SubString;
  TTTF_SubString = record
      flags: TTTF_SubStringFlags; {*< The flags for this substring  }
      offset: cint;               {*< The byte offset from the beginning of the text  }
      length: cint;               {*< The byte length starting at the offset  }
      line_index: cint;           {*< The index of the line that contains this substring  }
      cluster_index: cint;        {*< The internal cluster index, used for quickly iterating  }
      rect: TSDL_Rect;            {*< The rectangle, relative to the top left of the text, containing the substring  }
    end;

{*
 * Get the substring of a text object that surrounds a text offset.
 *
 * If `offset` is less than 0, this will return a zero length substring at the
 * beginning of the text with the TTF_SUBSTRING_TEXT_START flag set. If
 * `offset` is greater than or equal to the length of the text string, this
 * will return a zero length substring at the end of the text with the
 * TTF_SUBSTRING_TEXT_END flag set.
 *
 * \param text the TTF_Text to query.
 * \param offset a byte offset into the text string.
 * \param substring a Pointer filled in with the substring containing the
 *                  offset.
 * \returns true on success or false on failure; call SDL_GetError() for more
 *          information.
 *
 * \threadsafety This function should be called on the thread that created the
 *               text.
 *
 * \since This function is available since SDL_ttf 3.0.0.
  }
function TTF_GetTextSubString(text: PTTF_Text; offset: cint; substring: PTTF_SubString): Boolean; cdecl;
  external TTF_LibName {$IFDEF DELPHI} {$IFDEF MACOS} name '_TTF_GetTextSubString' {$ENDIF} {$ENDIF};

{*
 * Get the substring of a text object that contains the given line.
 *
 * If `line` is less than 0, this will return a zero length substring at the
 * beginning of the text with the TTF_SUBSTRING_TEXT_START flag set. If `line`
 * is greater than or equal to `text->num_lines` this will return a zero
 * length substring at the end of the text with the TTF_SUBSTRING_TEXT_END
 * flag set.
 *
 * \param text the TTF_Text to query.
 * \param line a zero-based line index, in the range [0 .. text->num_lines-1].
 * \param substring a Pointer filled in with the substring containing the
 *                  offset.
 * \returns true on success or false on failure; call SDL_GetError() for more
 *          information.
 *
 * \threadsafety This function should be called on the thread that created the
 *               text.
 *
 * \since This function is available since SDL_ttf 3.0.0.
  }
function TTF_GetTextSubStringForLine(text: PTTF_Text; line: cint; substring: PTTF_SubString): Boolean; cdecl;
  external TTF_LibName {$IFDEF DELPHI} {$IFDEF MACOS} name '_TTF_GetTextSubStringForLine' {$ENDIF} {$ENDIF};

{*
 * Get the substrings of a text object that contain a range of text.
 *
 * \param text the TTF_Text to query.
 * \param offset a byte offset into the text string.
 * \param length the length of the range being queried, in bytes, or -1 for
 *               the remainder of the string.
 * \param count a Pointer filled in with the number of substrings returned,
 *              may be nil.
 * \returns a nil terminated array of substring pointers or nil on failure;
 *          call SDL_GetError() for more information. This is a single
 *          allocation that should be freed with SDL_free() when it is no
 *          longer needed.
 *
 * \threadsafety This function should be called on the thread that created the
 *               text.
 *
 * \since This function is available since SDL_ttf 3.0.0.
  }
function TTF_GetTextSubStringsForRange(text: PTTF_Text; offset: cint; length: cint; count: pcint):PPTTF_SubString; cdecl;
  external TTF_LibName {$IFDEF DELPHI} {$IFDEF MACOS} name '_TTF_GetTextSubStringsForRange' {$ENDIF} {$ENDIF};

{*
 * Get the portion of a text string that is closest to a point.
 *
 * This will return the closest substring of text to the given point.
 *
 * \param text the TTF_Text to query.
 * \param x the x coordinate relative to the left side of the text, may be
 *          outside the bounds of the text area.
 * \param y the y coordinate relative to the top side of the text, may be
 *          outside the bounds of the text area.
 * \param substring a Pointer filled in with the closest substring of text to
 *                  the given point.
 * \returns true on success or false on failure; call SDL_GetError() for more
 *          information.
 *
 * \threadsafety This function should be called on the thread that created the
 *               text.
 *
 * \since This function is available since SDL_ttf 3.0.0.
  }
function TTF_GetTextSubStringForPoint(text: PTTF_Text; x: cint; y: cint; substring: PTTF_SubString): Boolean; cdecl;
  external TTF_LibName {$IFDEF DELPHI} {$IFDEF MACOS} name '_TTF_GetTextSubStringForPoint' {$ENDIF} {$ENDIF};

{*
 * Get the previous substring in a text object
 *
 * If called at the start of the text, this will return a zero length
 * substring with the TTF_SUBSTRING_TEXT_START flag set.
 *
 * \param text the TTF_Text to query.
 * \param substring the TTF_SubString to query.
 * \returns true on success or false on failure; call SDL_GetError() for more
 *          information.
 *
 * \threadsafety This function should be called on the thread that created the
 *               text.
 *
 * \since This function is available since SDL_ttf 3.0.0.
  }
function TTF_GetPreviousTextSubString(text: PTTF_Text; substring: PTTF_SubString; previous: PTTF_SubString): Boolean; cdecl;
  external TTF_LibName {$IFDEF DELPHI} {$IFDEF MACOS} name '_TTF_GetPreviousTextSubString' {$ENDIF} {$ENDIF};

{*
 * Get the next substring in a text object
 *
 * If called at the end of the text, this will return a zero length substring
 * with the TTF_SUBSTRING_TEXT_END flag set.
 *
 * \param text the TTF_Text to query.
 * \param substring the TTF_SubString to query.
 * \param next a Pointer filled in with the next substring.
 * \returns true on success or false on failure; call SDL_GetError() for more
 *          information.
 *
 * \threadsafety This function should be called on the thread that created the
 *               text.
 *
 * \since This function is available since SDL_ttf 3.0.0.
  }
function TTF_GetNextTextSubString(text: PTTF_Text; substring: PTTF_SubString; next: PTTF_SubString): Boolean; cdecl;
  external TTF_LibName {$IFDEF DELPHI} {$IFDEF MACOS} name '_TTF_GetNextTextSubString' {$ENDIF} {$ENDIF};

{*
 * Update the layout of a text object.
 *
 * This is automatically done when the layout is requested or the text is
 * rendered, but you can call this if you need more control over the timing of
 * when the layout and text engine representation are updated.
 *
 * \param text the TTF_Text to update.
 * \returns true on success or false on failure; call SDL_GetError() for more
 *          information.
 *
 * \threadsafety This function should be called on the thread that created the
 *               text.
 *
 * \since This function is available since SDL_ttf 3.0.0.
  }
function TTF_UpdateText(text: PTTF_Text): Boolean; cdecl;
  external TTF_LibName {$IFDEF DELPHI} {$IFDEF MACOS} name '_TTF_UpdateText' {$ENDIF} {$ENDIF};

{*
 * Destroy a text object created by a text engine.
 *
 * \param text the text to destroy.
 *
 * \threadsafety This function should be called on the thread that created the
 *               text.
 *
 * \since This function is available since SDL_ttf 3.0.0.
 *
 * \sa TTF_CreateText
  }
procedure TTF_DestroyText(text: PTTF_Text); cdecl;
  external TTF_LibName {$IFDEF DELPHI} {$IFDEF MACOS} name '_TTF_DestroyText' {$ENDIF} {$ENDIF};

{*
 * Dispose of a previously-created font.
 *
 * Call this when done with a font. This function will free any resources
 * associated with it. It is safe to call this function on nil, for example
 * on the result of a failed call to TTF_OpenFont().
 *
 * The font is not valid after being passed to this function. String pointers
 * from functions that return information on this font, such as
 * TTF_GetFontFamilyName() and TTF_GetFontStyleName(), are no longer valid
 * after this call, as well.
 *
 * \param font the font to dispose of.
 *
 * \threadsafety This function should not be called while any other thread is
 *               using the font.
 *
 * \since This function is available since SDL_ttf 3.0.0.
 *
 * \sa TTF_OpenFont
 * \sa TTF_OpenFontIO
  }
procedure TTF_CloseFont(font: PTTF_Font); cdecl;
  external TTF_LibName {$IFDEF DELPHI} {$IFDEF MACOS} name '_TTF_CloseFont' {$ENDIF} {$ENDIF};

{*
 * Deinitialize SDL_ttf.
 *
 * You must call this when done with the library, to free internal resources.
 * It is safe to call this when the library isn't initialized, as it will just
 * return immediately.
 *
 * Once you have as many quit calls as you have had successful calls to
 * TTF_Init, the library will actually deinitialize.
 *
 * Please note that this does not automatically close any fonts that are still
 * open at the time of deinitialization, and it is possibly not safe to close
 * them afterwards, as parts of the library will no longer be initialized to
 * deal with it. A well-written program should call TTF_CloseFont() on any
 * open fonts before calling this function!
 *
 * \threadsafety It is safe to call this function from any thread.
 *
 * \since This function is available since SDL_ttf 3.0.0.
  }
procedure TTF_Quit; cdecl;
  external TTF_LibName {$IFDEF DELPHI} {$IFDEF MACOS} name '_TTF_Quit' {$ENDIF} {$ENDIF};

{*
 * Check if SDL_ttf is initialized.
 *
 * This reports the number of times the library has been initialized by a call
 * to TTF_Init(), without a paired deinitialization request from TTF_Quit().
 *
 * In short: if it's greater than zero, the library is currently initialized
 * and ready to work. If zero, it is not initialized.
 *
 * Despite the return value being a signed integer, this function should not
 * return a negative number.
 *
 * \returns the current number of initialization calls, that need to
 *          eventually be paired with this many calls to TTF_Quit().
 *
 * \threadsafety It is safe to call this function from any thread.
 *
 * \since This function is available since SDL_ttf 3.0.0.
 *
 * \sa TTF_Init
 * \sa TTF_Quit
  }
function TTF_WasInit: cint; cdecl;
  external TTF_LibName {$IFDEF DELPHI} {$IFDEF MACOS} name '_TTF_WasInit' {$ENDIF} {$ENDIF};

implementation

function SDL_TTF_VERSION: Integer;
begin
  Result:=SDL_VERSIONNUM(SDL_TTF_MAJOR_VERSION, SDL_TTF_MINOR_VERSION, SDL_TTF_MICRO_VERSION);
end;

function SDL_TTF_VERSION_ATLEAST(X, Y, Z: Integer): Boolean;
begin
  Result:=((SDL_TTF_MAJOR_VERSION >= X) and
           ((SDL_TTF_MAJOR_VERSION > X) or (SDL_TTF_MINOR_VERSION >= Y)) and
           ((SDL_TTF_MAJOR_VERSION > X) or (SDL_TTF_MINOR_VERSION > Y) or (SDL_TTF_MICRO_VERSION >= Z)));
end;

end.

