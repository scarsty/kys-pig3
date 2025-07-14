unit SDL3_image;

{
  This file is part of:

    SDL3 for Pascal
    (https://github.com/PascalGameDevelopment/SDL3-for-Pascal)
    SPDX-License-Identifier: Zlib
}

{*
 * # CategorySDLImage
 *
 * Header file for SDL_image library
 *
 * A simple library to load images of various formats as SDL surfaces
  }

{$DEFINE SDL_IMAGE}

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
    IMG_LibName = 'SDL3_image.dll';
  {$ENDIF}

  {$IFDEF UNIX}
    {$IFDEF DARWIN}
      IMG_LibName = 'libSDL3_image.dylib';
      {$IFDEF FPC}
        {$LINKLIB libSDL3_image}
      {$ENDIF}
    {$ELSE}
      {$IFDEF FPC}
        IMG_LibName = 'libSDL3_image.so';
      {$ELSE}
        IMG_LibName = 'libSDL3_image.so.0';
      {$ENDIF}
    {$ENDIF}
  {$ENDIF}

  {$IFDEF MACOS}
    IMG_LibName = 'SDL3_image';
    {$IFDEF FPC}
      {$linklib libSDL3_image}
    {$ENDIF}
  {$ENDIF}

{*
 * Printable format: "%d.%d.%d", MAJOR, MINOR, MICRO
  }

const
  SDL_IMAGE_MAJOR_VERSION = 3;
  SDL_IMAGE_MINOR_VERSION = 2;
  SDL_IMAGE_MICRO_VERSION = 0;

{*
 * This is the version number macro for the current SDL_image version.
  }
function SDL_IMAGE_VERSION: Integer;

{*
 * This macro will evaluate to true if compiled with SDL_image at least X.Y.Z.
  }
function SDL_IMAGE_VERSION_ATLEAST(X, Y, Z: Integer): Boolean;

{*
 * This function gets the version of the dynamically linked SDL_image library.
 *
 * \returns SDL_image version.
 *
 * \since This function is available since SDL_image 3.0.0.
  }
function IMG_Version: cint; cdecl;
  external IMG_LibName {$IFDEF DELPHI} {$IFDEF MACOS} name '_IMG_Version' {$ENDIF} {$ENDIF};

{*
 * Load an image from an SDL data source into a software surface.
 *
 * An SDL_Surface is a buffer of pixels in memory accessible by the CPU. Use
 * this if you plan to hand the data to something else or manipulate it
 * further in code.
 *
 * There are no guarantees about what format the new SDL_Surface data will be;
 * in many cases, SDL_image will attempt to supply a surface that exactly
 * matches the provided image, but in others it might have to convert (either
 * because the image is in a format that SDL doesn't directly support or
 * because it's compressed data that could reasonably uncompress to various
 * formats and SDL_image had to pick one). You can inspect an SDL_Surface for
 * its specifics, and use SDL_ConvertSurface to then migrate to any supported
 * format.
 *
 * If the image format supports a transparent pixel, SDL will set the colorkey
 * for the surface. You can enable RLE acceleration on the surface afterwards
 * by calling: SDL_SetSurfaceColorKey(image, SDL_RLEACCEL,
 * image->format->colorkey);
 *
 * If `closeio` is true, `src` will be closed before returning, whether this
 * function succeeds or not. SDL_image reads everything it needs from `src`
 * during this call in any case.
 *
 * Even though this function accepts a file type, SDL_image may still try
 * other decoders that are capable of detecting file type from the contents of
 * the image data, but may rely on the caller-provided type string for formats
 * that it cannot autodetect. If `type` is nil, SDL_image will rely solely on
 * its ability to guess the format.
 *
 * There is a separate function to read files from disk without having to deal
 * with SDL_IOStream: `IMG_Load("filename.jpg")` will call this function and
 * manage those details for you, determining the file type from the filename's
 * extension.
 *
 * There is also IMG_Load_IO(), which is equivalent to this function except
 * that it will rely on SDL_image to determine what type of data it is
 * loading, much like passing a nil for type.
 *
 * If you are using SDL's 2D rendering API, there is an equivalent call to
 * load images directly into an SDL_Texture for use by the GPU without using a
 * software surface: call IMG_LoadTextureTyped_IO() instead.
 *
 * When done with the returned surface, the app should dispose of it with a
 * call to SDL_DestroySurface().
 *
 * \param src an SDL_IOStream that data will be read from.
 * \param closeio true to close/free the SDL_IOStream before returning, false
 *                to leave it open.
 * \param type a filename extension that represent this data ("BMP", "GIF",
 *             "PNG", etc).
 * \returns a new SDL surface, or nil on error.
 *
 * \since This function is available since SDL_image 3.0.0.
 *
 * \sa IMG_Load
 * \sa IMG_Load_IO
 * \sa SDL_DestroySurface
  }
function IMG_LoadTyped_IO(src: PSDL_IOStream; closeio: Boolean; type_: PAnsiChar): PSDL_Surface; cdecl;
  external IMG_LibName {$IFDEF DELPHI} {$IFDEF MACOS} name '_IMG_LoadTyped_IO' {$ENDIF} {$ENDIF};

{*
 * Load an image from a filesystem path into a software surface.
 *
 * An SDL_Surface is a buffer of pixels in memory accessible by the CPU. Use
 * this if you plan to hand the data to something else or manipulate it
 * further in code.
 *
 * There are no guarantees about what format the new SDL_Surface data will be;
 * in many cases, SDL_image will attempt to supply a surface that exactly
 * matches the provided image, but in others it might have to convert (either
 * because the image is in a format that SDL doesn't directly support or
 * because it's compressed data that could reasonably uncompress to various
 * formats and SDL_image had to pick one). You can inspect an SDL_Surface for
 * its specifics, and use SDL_ConvertSurface to then migrate to any supported
 * format.
 *
 * If the image format supports a transparent pixel, SDL will set the colorkey
 * for the surface. You can enable RLE acceleration on the surface afterwards
 * by calling: SDL_SetSurfaceColorKey(image, SDL_RLEACCEL,
 * image->format->colorkey);
 *
 * There is a separate function to read files from an SDL_IOStream, if you
 * need an i/o abstraction to provide data from anywhere instead of a simple
 * filesystem read; that function is IMG_Load_IO().
 *
 * If you are using SDL's 2D rendering API, there is an equivalent call to
 * load images directly into an SDL_Texture for use by the GPU without using a
 * software surface: call IMG_LoadTexture() instead.
 *
 * When done with the returned surface, the app should dispose of it with a
 * call to
 * [SDL_DestroySurface](https://wiki.libsdl.org/SDL3/SDL_DestroySurface)
 * ().
 *
 * \param file a path on the filesystem to load an image from.
 * \returns a new SDL surface, or nil on error.
 *
 * \since This function is available since SDL_image 3.0.0.
 *
 * \sa IMG_LoadTyped_IO
 * \sa IMG_Load_IO
 * \sa SDL_DestroySurface
  }
function IMG_Load(file_: PAnsiChar): PSDL_Surface; cdecl;
  external IMG_LibName {$IFDEF DELPHI} {$IFDEF MACOS} name '_IMG_Load' {$ENDIF} {$ENDIF};

{*
 * Load an image from an SDL data source into a software surface.
 *
 * An SDL_Surface is a buffer of pixels in memory accessible by the CPU. Use
 * this if you plan to hand the data to something else or manipulate it
 * further in code.
 *
 * There are no guarantees about what format the new SDL_Surface data will be;
 * in many cases, SDL_image will attempt to supply a surface that exactly
 * matches the provided image, but in others it might have to convert (either
 * because the image is in a format that SDL doesn't directly support or
 * because it's compressed data that could reasonably uncompress to various
 * formats and SDL_image had to pick one). You can inspect an SDL_Surface for
 * its specifics, and use SDL_ConvertSurface to then migrate to any supported
 * format.
 *
 * If the image format supports a transparent pixel, SDL will set the colorkey
 * for the surface. You can enable RLE acceleration on the surface afterwards
 * by calling: SDL_SetSurfaceColorKey(image, SDL_RLEACCEL,
 * image->format->colorkey);
 *
 * If `closeio` is true, `src` will be closed before returning, whether this
 * function succeeds or not. SDL_image reads everything it needs from `src`
 * during this call in any case.
 *
 * There is a separate function to read files from disk without having to deal
 * with SDL_IOStream: `IMG_Load("filename.jpg")` will call this function and
 * manage those details for you, determining the file type from the filename's
 * extension.
 *
 * There is also IMG_LoadTyped_IO(), which is equivalent to this function
 * except a file extension (like "BMP", "JPG", etc) can be specified, in case
 * SDL_image cannot autodetect the file format.
 *
 * If you are using SDL's 2D rendering API, there is an equivalent call to
 * load images directly into an SDL_Texture for use by the GPU without using a
 * software surface: call IMG_LoadTexture_IO() instead.
 *
 * When done with the returned surface, the app should dispose of it with a
 * call to SDL_DestroySurface().
 *
 * \param src an SDL_IOStream that data will be read from.
 * \param closeio true to close/free the SDL_IOStream before returning, false
 *                to leave it open.
 * \returns a new SDL surface, or nil on error.
 *
 * \since This function is available since SDL_image 3.0.0.
 *
 * \sa IMG_Load
 * \sa IMG_LoadTyped_IO
 * \sa SDL_DestroySurface
  }
function IMG_Load_IO(src: PSDL_IOStream; closeio: Boolean): PSDL_Surface; cdecl;
  external IMG_LibName {$IFDEF DELPHI} {$IFDEF MACOS} name '_IMG_Load_IO' {$ENDIF} {$ENDIF};

{*
 * Load an image from a filesystem path into a GPU texture.
 *
 * An SDL_Texture represents an image in GPU memory, usable by SDL's 2D Render
 * API. This can be significantly more efficient than using a CPU-bound
 * SDL_Surface if you don't need to manipulate the image directly after
 * loading it.
 *
 * If the loaded image has transparency or a colorkey, a texture with an alpha
 * channel will be created. Otherwise, SDL_image will attempt to create an
 * SDL_Texture in the most format that most reasonably represents the image
 * data (but in many cases, this will just end up being 32-bit RGB or 32-bit
 * RGBA).
 *
 * There is a separate function to read files from an SDL_IOStream, if you
 * need an i/o abstraction to provide data from anywhere instead of a simple
 * filesystem read; that function is IMG_LoadTexture_IO().
 *
 * If you would rather decode an image to an SDL_Surface (a buffer of pixels
 * in CPU memory), call IMG_Load() instead.
 *
 * When done with the returned texture, the app should dispose of it with a
 * call to SDL_DestroyTexture().
 *
 * \param renderer the SDL_Renderer to use to create the GPU texture.
 * \param file a path on the filesystem to load an image from.
 * \returns a new texture, or nil on error.
 *
 * \since This function is available since SDL_image 3.0.0.
 *
 * \sa IMG_LoadTextureTyped_IO
 * \sa IMG_LoadTexture_IO
  }
function IMG_LoadTexture(renderer: PSDL_Renderer; file_: PAnsiChar): PSDL_Texture; cdecl;
  external IMG_LibName {$IFDEF DELPHI} {$IFDEF MACOS} name '_IMG_LoadTexture' {$ENDIF} {$ENDIF};

{*
 * Load an image from an SDL data source into a GPU texture.
 *
 * An SDL_Texture represents an image in GPU memory, usable by SDL's 2D Render
 * API. This can be significantly more efficient than using a CPU-bound
 * SDL_Surface if you don't need to manipulate the image directly after
 * loading it.
 *
 * If the loaded image has transparency or a colorkey, a texture with an alpha
 * channel will be created. Otherwise, SDL_image will attempt to create an
 * SDL_Texture in the most format that most reasonably represents the image
 * data (but in many cases, this will just end up being 32-bit RGB or 32-bit
 * RGBA).
 *
 * If `closeio` is true, `src` will be closed before returning, whether this
 * function succeeds or not. SDL_image reads everything it needs from `src`
 * during this call in any case.
 *
 * There is a separate function to read files from disk without having to deal
 * with SDL_IOStream: `IMG_LoadTexture(renderer, "filename.jpg")` will call
 * this function and manage those details for you, determining the file type
 * from the filename's extension.
 *
 * There is also IMG_LoadTextureTyped_IO(), which is equivalent to this
 * function except a file extension (like "BMP", "JPG", etc) can be specified,
 * in case SDL_image cannot autodetect the file format.
 *
 * If you would rather decode an image to an SDL_Surface (a buffer of pixels
 * in CPU memory), call IMG_Load() instead.
 *
 * When done with the returned texture, the app should dispose of it with a
 * call to SDL_DestroyTexture().
 *
 * \param renderer the SDL_Renderer to use to create the GPU texture.
 * \param src an SDL_IOStream that data will be read from.
 * \param closeio true to close/free the SDL_IOStream before returning, false
 *                to leave it open.
 * \returns a new texture, or nil on error.
 *
 * \since This function is available since SDL_image 3.0.0.
 *
 * \sa IMG_LoadTexture
 * \sa IMG_LoadTextureTyped_IO
 * \sa SDL_DestroyTexture
  }
function IMG_LoadTexture_IO(renderer: PSDL_Renderer; src: PSDL_IOStream; closeio: Boolean): PSDL_Texture; cdecl;
  external IMG_LibName {$IFDEF DELPHI} {$IFDEF MACOS} name '_IMG_LoadTexture_IO' {$ENDIF} {$ENDIF};

{*
 * Load an image from an SDL data source into a GPU texture.
 *
 * An SDL_Texture represents an image in GPU memory, usable by SDL's 2D Render
 * API. This can be significantly more efficient than using a CPU-bound
 * SDL_Surface if you don't need to manipulate the image directly after
 * loading it.
 *
 * If the loaded image has transparency or a colorkey, a texture with an alpha
 * channel will be created. Otherwise, SDL_image will attempt to create an
 * SDL_Texture in the most format that most reasonably represents the image
 * data (but in many cases, this will just end up being 32-bit RGB or 32-bit
 * RGBA).
 *
 * If `closeio` is true, `src` will be closed before returning, whether this
 * function succeeds or not. SDL_image reads everything it needs from `src`
 * during this call in any case.
 *
 * Even though this function accepts a file type, SDL_image may still try
 * other decoders that are capable of detecting file type from the contents of
 * the image data, but may rely on the caller-provided type string for formats
 * that it cannot autodetect. If `type` is nil, SDL_image will rely solely on
 * its ability to guess the format.
 *
 * There is a separate function to read files from disk without having to deal
 * with SDL_IOStream: `IMG_LoadTexture("filename.jpg")` will call this
 * function and manage those details for you, determining the file type from
 * the filename's extension.
 *
 * There is also IMG_LoadTexture_IO(), which is equivalent to this function
 * except that it will rely on SDL_image to determine what type of data it is
 * loading, much like passing a nil for type.
 *
 * If you would rather decode an image to an SDL_Surface (a buffer of pixels
 * in CPU memory), call IMG_LoadTyped_IO() instead.
 *
 * When done with the returned texture, the app should dispose of it with a
 * call to SDL_DestroyTexture().
 *
 * \param renderer the SDL_Renderer to use to create the GPU texture.
 * \param src an SDL_IOStream that data will be read from.
 * \param closeio true to close/free the SDL_IOStream before returning, false
 *                to leave it open.
 * \param type a filename extension that represent this data ("BMP", "GIF",
 *             "PNG", etc).
 * \returns a new texture, or nil on error.
 *
 * \since This function is available since SDL_image 3.0.0.
 *
 * \sa IMG_LoadTexture
 * \sa IMG_LoadTexture_IO
 * \sa SDL_DestroyTexture
  }
function IMG_LoadTextureTyped_IO(renderer: PSDL_Renderer; src: PSDL_IOStream; closeio: Boolean; type_: PAnsiChar): PSDL_Texture; cdecl;
  external IMG_LibName {$IFDEF DELPHI} {$IFDEF MACOS} name '_IMG_LoadTextureTyped_IO' {$ENDIF} {$ENDIF};

{*
 * Detect AVIF image data on a readable/seekable SDL_IOStream.
 *
 * This function attempts to determine if a file is a given filetype, reading
 * the least amount possible from the SDL_IOStream (usually a few bytes).
 *
 * There is no distinction made between "not the filetype in question" and
 * basic i/o errors.
 *
 * This function will always attempt to seek `src` back to where it started
 * when this function was called, but it will not report any errors in doing
 * so, but assuming seeking works, this means you can immediately use this
 * with a different IMG_isTYPE function, or load the image without further
 * seeking.
 *
 * You do not need to call this function to load data; SDL_image can work to
 * determine file type in many cases in its standard load functions.
 *
 * \param src a seekable/readable SDL_IOStream to provide image data.
 * \returns non-zero if this is AVIF data, zero otherwise.
 *
 * \since This function is available since SDL_image 3.0.0.
 *
 * \sa IMG_isAVIF
 * \sa IMG_isICO
 * \sa IMG_isCUR
 * \sa IMG_isBMP
 * \sa IMG_isGIF
 * \sa IMG_isJPG
 * \sa IMG_isJXL
 * \sa IMG_isLBM
 * \sa IMG_isPCX
 * \sa IMG_isPNG
 * \sa IMG_isPNM
 * \sa IMG_isSVG
 * \sa IMG_isQOI
 * \sa IMG_isTIF
 * \sa IMG_isXCF
 * \sa IMG_isXPM
 * \sa IMG_isXV
 * \sa IMG_isWEBP
  }
function IMG_isAVIF(src: PSDL_IOStream): Boolean; cdecl;
  external IMG_LibName {$IFDEF DELPHI} {$IFDEF MACOS} name '_IMG_isAVIF' {$ENDIF} {$ENDIF};

{*
 * Detect ICO image data on a readable/seekable SDL_IOStream.
 *
 * This function attempts to determine if a file is a given filetype, reading
 * the least amount possible from the SDL_IOStream (usually a few bytes).
 *
 * There is no distinction made between "not the filetype in question" and
 * basic i/o errors.
 *
 * This function will always attempt to seek `src` back to where it started
 * when this function was called, but it will not report any errors in doing
 * so, but assuming seeking works, this means you can immediately use this
 * with a different IMG_isTYPE function, or load the image without further
 * seeking.
 *
 * You do not need to call this function to load data; SDL_image can work to
 * determine file type in many cases in its standard load functions.
 *
 * \param src a seekable/readable SDL_IOStream to provide image data.
 * \returns non-zero if this is ICO data, zero otherwise.
 *
 * \since This function is available since SDL_image 3.0.0.
 *
 * \sa IMG_isAVIF
 * \sa IMG_isCUR
 * \sa IMG_isBMP
 * \sa IMG_isGIF
 * \sa IMG_isJPG
 * \sa IMG_isJXL
 * \sa IMG_isLBM
 * \sa IMG_isPCX
 * \sa IMG_isPNG
 * \sa IMG_isPNM
 * \sa IMG_isSVG
 * \sa IMG_isQOI
 * \sa IMG_isTIF
 * \sa IMG_isXCF
 * \sa IMG_isXPM
 * \sa IMG_isXV
 * \sa IMG_isWEBP
  }
function IMG_isICO(src: PSDL_IOStream): Boolean; cdecl;
  external IMG_LibName {$IFDEF DELPHI} {$IFDEF MACOS} name '_IMG_isICO' {$ENDIF} {$ENDIF};

{*
 * Detect CUR image data on a readable/seekable SDL_IOStream.
 *
 * This function attempts to determine if a file is a given filetype, reading
 * the least amount possible from the SDL_IOStream (usually a few bytes).
 *
 * There is no distinction made between "not the filetype in question" and
 * basic i/o errors.
 *
 * This function will always attempt to seek `src` back to where it started
 * when this function was called, but it will not report any errors in doing
 * so, but assuming seeking works, this means you can immediately use this
 * with a different IMG_isTYPE function, or load the image without further
 * seeking.
 *
 * You do not need to call this function to load data; SDL_image can work to
 * determine file type in many cases in its standard load functions.
 *
 * \param src a seekable/readable SDL_IOStream to provide image data.
 * \returns non-zero if this is CUR data, zero otherwise.
 *
 * \since This function is available since SDL_image 3.0.0.
 *
 * \sa IMG_isAVIF
 * \sa IMG_isICO
 * \sa IMG_isBMP
 * \sa IMG_isGIF
 * \sa IMG_isJPG
 * \sa IMG_isJXL
 * \sa IMG_isLBM
 * \sa IMG_isPCX
 * \sa IMG_isPNG
 * \sa IMG_isPNM
 * \sa IMG_isSVG
 * \sa IMG_isQOI
 * \sa IMG_isTIF
 * \sa IMG_isXCF
 * \sa IMG_isXPM
 * \sa IMG_isXV
 * \sa IMG_isWEBP
  }
function IMG_isCUR(src: PSDL_IOStream): Boolean; cdecl;
  external IMG_LibName {$IFDEF DELPHI} {$IFDEF MACOS} name '_IMG_isCUR' {$ENDIF} {$ENDIF};

{*
 * Detect BMP image data on a readable/seekable SDL_IOStream.
 *
 * This function attempts to determine if a file is a given filetype, reading
 * the least amount possible from the SDL_IOStream (usually a few bytes).
 *
 * There is no distinction made between "not the filetype in question" and
 * basic i/o errors.
 *
 * This function will always attempt to seek `src` back to where it started
 * when this function was called, but it will not report any errors in doing
 * so, but assuming seeking works, this means you can immediately use this
 * with a different IMG_isTYPE function, or load the image without further
 * seeking.
 *
 * You do not need to call this function to load data; SDL_image can work to
 * determine file type in many cases in its standard load functions.
 *
 * \param src a seekable/readable SDL_IOStream to provide image data.
 * \returns non-zero if this is BMP data, zero otherwise.
 *
 * \since This function is available since SDL_image 3.0.0.
 *
 * \sa IMG_isAVIF
 * \sa IMG_isICO
 * \sa IMG_isCUR
 * \sa IMG_isGIF
 * \sa IMG_isJPG
 * \sa IMG_isJXL
 * \sa IMG_isLBM
 * \sa IMG_isPCX
 * \sa IMG_isPNG
 * \sa IMG_isPNM
 * \sa IMG_isSVG
 * \sa IMG_isQOI
 * \sa IMG_isTIF
 * \sa IMG_isXCF
 * \sa IMG_isXPM
 * \sa IMG_isXV
 * \sa IMG_isWEBP
  }
function IMG_isBMP(src: PSDL_IOStream): Boolean; cdecl;
  external IMG_LibName {$IFDEF DELPHI} {$IFDEF MACOS} name '_IMG_isBMP' {$ENDIF} {$ENDIF};

{*
 * Detect GIF image data on a readable/seekable SDL_IOStream.
 *
 * This function attempts to determine if a file is a given filetype, reading
 * the least amount possible from the SDL_IOStream (usually a few bytes).
 *
 * There is no distinction made between "not the filetype in question" and
 * basic i/o errors.
 *
 * This function will always attempt to seek `src` back to where it started
 * when this function was called, but it will not report any errors in doing
 * so, but assuming seeking works, this means you can immediately use this
 * with a different IMG_isTYPE function, or load the image without further
 * seeking.
 *
 * You do not need to call this function to load data; SDL_image can work to
 * determine file type in many cases in its standard load functions.
 *
 * \param src a seekable/readable SDL_IOStream to provide image data.
 * \returns non-zero if this is GIF data, zero otherwise.
 *
 * \since This function is available since SDL_image 3.0.0.
 *
 * \sa IMG_isAVIF
 * \sa IMG_isICO
 * \sa IMG_isCUR
 * \sa IMG_isBMP
 * \sa IMG_isJPG
 * \sa IMG_isJXL
 * \sa IMG_isLBM
 * \sa IMG_isPCX
 * \sa IMG_isPNG
 * \sa IMG_isPNM
 * \sa IMG_isSVG
 * \sa IMG_isQOI
 * \sa IMG_isTIF
 * \sa IMG_isXCF
 * \sa IMG_isXPM
 * \sa IMG_isXV
 * \sa IMG_isWEBP
  }
function IMG_isGIF(src: PSDL_IOStream): Boolean; cdecl;
  external IMG_LibName {$IFDEF DELPHI} {$IFDEF MACOS} name '_IMG_isGIF' {$ENDIF} {$ENDIF};

{*
 * Detect JPG image data on a readable/seekable SDL_IOStream.
 *
 * This function attempts to determine if a file is a given filetype, reading
 * the least amount possible from the SDL_IOStream (usually a few bytes).
 *
 * There is no distinction made between "not the filetype in question" and
 * basic i/o errors.
 *
 * This function will always attempt to seek `src` back to where it started
 * when this function was called, but it will not report any errors in doing
 * so, but assuming seeking works, this means you can immediately use this
 * with a different IMG_isTYPE function, or load the image without further
 * seeking.
 *
 * You do not need to call this function to load data; SDL_image can work to
 * determine file type in many cases in its standard load functions.
 *
 * \param src a seekable/readable SDL_IOStream to provide image data.
 * \returns non-zero if this is JPG data, zero otherwise.
 *
 * \since This function is available since SDL_image 3.0.0.
 *
 * \sa IMG_isAVIF
 * \sa IMG_isICO
 * \sa IMG_isCUR
 * \sa IMG_isBMP
 * \sa IMG_isGIF
 * \sa IMG_isJXL
 * \sa IMG_isLBM
 * \sa IMG_isPCX
 * \sa IMG_isPNG
 * \sa IMG_isPNM
 * \sa IMG_isSVG
 * \sa IMG_isQOI
 * \sa IMG_isTIF
 * \sa IMG_isXCF
 * \sa IMG_isXPM
 * \sa IMG_isXV
 * \sa IMG_isWEBP
  }
function IMG_isJPG(src: PSDL_IOStream): Boolean; cdecl;
  external IMG_LibName {$IFDEF DELPHI} {$IFDEF MACOS} name '_IMG_isJPG' {$ENDIF} {$ENDIF};

{*
 * Detect JXL image data on a readable/seekable SDL_IOStream.
 *
 * This function attempts to determine if a file is a given filetype, reading
 * the least amount possible from the SDL_IOStream (usually a few bytes).
 *
 * There is no distinction made between "not the filetype in question" and
 * basic i/o errors.
 *
 * This function will always attempt to seek `src` back to where it started
 * when this function was called, but it will not report any errors in doing
 * so, but assuming seeking works, this means you can immediately use this
 * with a different IMG_isTYPE function, or load the image without further
 * seeking.
 *
 * You do not need to call this function to load data; SDL_image can work to
 * determine file type in many cases in its standard load functions.
 *
 * \param src a seekable/readable SDL_IOStream to provide image data.
 * \returns non-zero if this is JXL data, zero otherwise.
 *
 * \since This function is available since SDL_image 3.0.0.
 *
 * \sa IMG_isAVIF
 * \sa IMG_isICO
 * \sa IMG_isCUR
 * \sa IMG_isBMP
 * \sa IMG_isGIF
 * \sa IMG_isJPG
 * \sa IMG_isLBM
 * \sa IMG_isPCX
 * \sa IMG_isPNG
 * \sa IMG_isPNM
 * \sa IMG_isSVG
 * \sa IMG_isQOI
 * \sa IMG_isTIF
 * \sa IMG_isXCF
 * \sa IMG_isXPM
 * \sa IMG_isXV
 * \sa IMG_isWEBP
  }
function IMG_isJXL(src: PSDL_IOStream): Boolean; cdecl;
  external IMG_LibName {$IFDEF DELPHI} {$IFDEF MACOS} name '_IMG_isJXL' {$ENDIF} {$ENDIF};

{*
 * Detect LBM image data on a readable/seekable SDL_IOStream.
 *
 * This function attempts to determine if a file is a given filetype, reading
 * the least amount possible from the SDL_IOStream (usually a few bytes).
 *
 * There is no distinction made between "not the filetype in question" and
 * basic i/o errors.
 *
 * This function will always attempt to seek `src` back to where it started
 * when this function was called, but it will not report any errors in doing
 * so, but assuming seeking works, this means you can immediately use this
 * with a different IMG_isTYPE function, or load the image without further
 * seeking.
 *
 * You do not need to call this function to load data; SDL_image can work to
 * determine file type in many cases in its standard load functions.
 *
 * \param src a seekable/readable SDL_IOStream to provide image data.
 * \returns non-zero if this is LBM data, zero otherwise.
 *
 * \since This function is available since SDL_image 3.0.0.
 *
 * \sa IMG_isAVIF
 * \sa IMG_isICO
 * \sa IMG_isCUR
 * \sa IMG_isBMP
 * \sa IMG_isGIF
 * \sa IMG_isJPG
 * \sa IMG_isJXL
 * \sa IMG_isPCX
 * \sa IMG_isPNG
 * \sa IMG_isPNM
 * \sa IMG_isSVG
 * \sa IMG_isQOI
 * \sa IMG_isTIF
 * \sa IMG_isXCF
 * \sa IMG_isXPM
 * \sa IMG_isXV
 * \sa IMG_isWEBP
  }
function IMG_isLBM(src: PSDL_IOStream): Boolean; cdecl;
  external IMG_LibName {$IFDEF DELPHI} {$IFDEF MACOS} name '_IMG_isLBM' {$ENDIF} {$ENDIF};

{*
 * Detect PCX image data on a readable/seekable SDL_IOStream.
 *
 * This function attempts to determine if a file is a given filetype, reading
 * the least amount possible from the SDL_IOStream (usually a few bytes).
 *
 * There is no distinction made between "not the filetype in question" and
 * basic i/o errors.
 *
 * This function will always attempt to seek `src` back to where it started
 * when this function was called, but it will not report any errors in doing
 * so, but assuming seeking works, this means you can immediately use this
 * with a different IMG_isTYPE function, or load the image without further
 * seeking.
 *
 * You do not need to call this function to load data; SDL_image can work to
 * determine file type in many cases in its standard load functions.
 *
 * \param src a seekable/readable SDL_IOStream to provide image data.
 * \returns non-zero if this is PCX data, zero otherwise.
 *
 * \since This function is available since SDL_image 3.0.0.
 *
 * \sa IMG_isAVIF
 * \sa IMG_isICO
 * \sa IMG_isCUR
 * \sa IMG_isBMP
 * \sa IMG_isGIF
 * \sa IMG_isJPG
 * \sa IMG_isJXL
 * \sa IMG_isLBM
 * \sa IMG_isPNG
 * \sa IMG_isPNM
 * \sa IMG_isSVG
 * \sa IMG_isQOI
 * \sa IMG_isTIF
 * \sa IMG_isXCF
 * \sa IMG_isXPM
 * \sa IMG_isXV
 * \sa IMG_isWEBP
  }
function IMG_isPCX(src: PSDL_IOStream): Boolean; cdecl;
  external IMG_LibName {$IFDEF DELPHI} {$IFDEF MACOS} name '_IMG_isPCX' {$ENDIF} {$ENDIF};

{*
 * Detect PNG image data on a readable/seekable SDL_IOStream.
 *
 * This function attempts to determine if a file is a given filetype, reading
 * the least amount possible from the SDL_IOStream (usually a few bytes).
 *
 * There is no distinction made between "not the filetype in question" and
 * basic i/o errors.
 *
 * This function will always attempt to seek `src` back to where it started
 * when this function was called, but it will not report any errors in doing
 * so, but assuming seeking works, this means you can immediately use this
 * with a different IMG_isTYPE function, or load the image without further
 * seeking.
 *
 * You do not need to call this function to load data; SDL_image can work to
 * determine file type in many cases in its standard load functions.
 *
 * \param src a seekable/readable SDL_IOStream to provide image data.
 * \returns non-zero if this is PNG data, zero otherwise.
 *
 * \since This function is available since SDL_image 3.0.0.
 *
 * \sa IMG_isAVIF
 * \sa IMG_isICO
 * \sa IMG_isCUR
 * \sa IMG_isBMP
 * \sa IMG_isGIF
 * \sa IMG_isJPG
 * \sa IMG_isJXL
 * \sa IMG_isLBM
 * \sa IMG_isPCX
 * \sa IMG_isPNM
 * \sa IMG_isSVG
 * \sa IMG_isQOI
 * \sa IMG_isTIF
 * \sa IMG_isXCF
 * \sa IMG_isXPM
 * \sa IMG_isXV
 * \sa IMG_isWEBP
  }
function IMG_isPNG(src: PSDL_IOStream): Boolean; cdecl;
  external IMG_LibName {$IFDEF DELPHI} {$IFDEF MACOS} name '_IMG_isPNG' {$ENDIF} {$ENDIF};

{*
 * Detect PNM image data on a readable/seekable SDL_IOStream.
 *
 * This function attempts to determine if a file is a given filetype, reading
 * the least amount possible from the SDL_IOStream (usually a few bytes).
 *
 * There is no distinction made between "not the filetype in question" and
 * basic i/o errors.
 *
 * This function will always attempt to seek `src` back to where it started
 * when this function was called, but it will not report any errors in doing
 * so, but assuming seeking works, this means you can immediately use this
 * with a different IMG_isTYPE function, or load the image without further
 * seeking.
 *
 * You do not need to call this function to load data; SDL_image can work to
 * determine file type in many cases in its standard load functions.
 *
 * \param src a seekable/readable SDL_IOStream to provide image data.
 * \returns non-zero if this is PNM data, zero otherwise.
 *
 * \since This function is available since SDL_image 3.0.0.
 *
 * \sa IMG_isAVIF
 * \sa IMG_isICO
 * \sa IMG_isCUR
 * \sa IMG_isBMP
 * \sa IMG_isGIF
 * \sa IMG_isJPG
 * \sa IMG_isJXL
 * \sa IMG_isLBM
 * \sa IMG_isPCX
 * \sa IMG_isPNG
 * \sa IMG_isSVG
 * \sa IMG_isQOI
 * \sa IMG_isTIF
 * \sa IMG_isXCF
 * \sa IMG_isXPM
 * \sa IMG_isXV
 * \sa IMG_isWEBP
  }
function IMG_isPNM(src: PSDL_IOStream): Boolean; cdecl;
  external IMG_LibName {$IFDEF DELPHI} {$IFDEF MACOS} name '_IMG_isPNM' {$ENDIF} {$ENDIF};

{*
 * Detect SVG image data on a readable/seekable SDL_IOStream.
 *
 * This function attempts to determine if a file is a given filetype, reading
 * the least amount possible from the SDL_IOStream (usually a few bytes).
 *
 * There is no distinction made between "not the filetype in question" and
 * basic i/o errors.
 *
 * This function will always attempt to seek `src` back to where it started
 * when this function was called, but it will not report any errors in doing
 * so, but assuming seeking works, this means you can immediately use this
 * with a different IMG_isTYPE function, or load the image without further
 * seeking.
 *
 * You do not need to call this function to load data; SDL_image can work to
 * determine file type in many cases in its standard load functions.
 *
 * \param src a seekable/readable SDL_IOStream to provide image data.
 * \returns non-zero if this is SVG data, zero otherwise.
 *
 * \since This function is available since SDL_image 3.0.0.
 *
 * \sa IMG_isAVIF
 * \sa IMG_isICO
 * \sa IMG_isCUR
 * \sa IMG_isBMP
 * \sa IMG_isGIF
 * \sa IMG_isJPG
 * \sa IMG_isJXL
 * \sa IMG_isLBM
 * \sa IMG_isPCX
 * \sa IMG_isPNG
 * \sa IMG_isPNM
 * \sa IMG_isQOI
 * \sa IMG_isTIF
 * \sa IMG_isXCF
 * \sa IMG_isXPM
 * \sa IMG_isXV
 * \sa IMG_isWEBP
  }
function IMG_isSVG(src: PSDL_IOStream): Boolean; cdecl;
  external IMG_LibName {$IFDEF DELPHI} {$IFDEF MACOS} name '_IMG_isSVG' {$ENDIF} {$ENDIF};

{*
 * Detect QOI image data on a readable/seekable SDL_IOStream.
 *
 * This function attempts to determine if a file is a given filetype, reading
 * the least amount possible from the SDL_IOStream (usually a few bytes).
 *
 * There is no distinction made between "not the filetype in question" and
 * basic i/o errors.
 *
 * This function will always attempt to seek `src` back to where it started
 * when this function was called, but it will not report any errors in doing
 * so, but assuming seeking works, this means you can immediately use this
 * with a different IMG_isTYPE function, or load the image without further
 * seeking.
 *
 * You do not need to call this function to load data; SDL_image can work to
 * determine file type in many cases in its standard load functions.
 *
 * \param src a seekable/readable SDL_IOStream to provide image data.
 * \returns non-zero if this is QOI data, zero otherwise.
 *
 * \since This function is available since SDL_image 3.0.0.
 *
 * \sa IMG_isAVIF
 * \sa IMG_isICO
 * \sa IMG_isCUR
 * \sa IMG_isBMP
 * \sa IMG_isGIF
 * \sa IMG_isJPG
 * \sa IMG_isJXL
 * \sa IMG_isLBM
 * \sa IMG_isPCX
 * \sa IMG_isPNG
 * \sa IMG_isPNM
 * \sa IMG_isSVG
 * \sa IMG_isTIF
 * \sa IMG_isXCF
 * \sa IMG_isXPM
 * \sa IMG_isXV
 * \sa IMG_isWEBP
  }
function IMG_isQOI(src: PSDL_IOStream): Boolean; cdecl;
  external IMG_LibName {$IFDEF DELPHI} {$IFDEF MACOS} name '_IMG_isQOI' {$ENDIF} {$ENDIF};

{*
 * Detect TIFF image data on a readable/seekable SDL_IOStream.
 *
 * This function attempts to determine if a file is a given filetype, reading
 * the least amount possible from the SDL_IOStream (usually a few bytes).
 *
 * There is no distinction made between "not the filetype in question" and
 * basic i/o errors.
 *
 * This function will always attempt to seek `src` back to where it started
 * when this function was called, but it will not report any errors in doing
 * so, but assuming seeking works, this means you can immediately use this
 * with a different IMG_isTYPE function, or load the image without further
 * seeking.
 *
 * You do not need to call this function to load data; SDL_image can work to
 * determine file type in many cases in its standard load functions.
 *
 * \param src a seekable/readable SDL_IOStream to provide image data.
 * \returns non-zero if this is TIFF data, zero otherwise.
 *
 * \since This function is available since SDL_image 3.0.0.
 *
 * \sa IMG_isAVIF
 * \sa IMG_isICO
 * \sa IMG_isCUR
 * \sa IMG_isBMP
 * \sa IMG_isGIF
 * \sa IMG_isJPG
 * \sa IMG_isJXL
 * \sa IMG_isLBM
 * \sa IMG_isPCX
 * \sa IMG_isPNG
 * \sa IMG_isPNM
 * \sa IMG_isSVG
 * \sa IMG_isQOI
 * \sa IMG_isXCF
 * \sa IMG_isXPM
 * \sa IMG_isXV
 * \sa IMG_isWEBP
  }
function IMG_isTIF(src: PSDL_IOStream): Boolean; cdecl;
  external IMG_LibName {$IFDEF DELPHI} {$IFDEF MACOS} name '_IMG_isTIF' {$ENDIF} {$ENDIF};

{*
 * Detect XCF image data on a readable/seekable SDL_IOStream.
 *
 * This function attempts to determine if a file is a given filetype, reading
 * the least amount possible from the SDL_IOStream (usually a few bytes).
 *
 * There is no distinction made between "not the filetype in question" and
 * basic i/o errors.
 *
 * This function will always attempt to seek `src` back to where it started
 * when this function was called, but it will not report any errors in doing
 * so, but assuming seeking works, this means you can immediately use this
 * with a different IMG_isTYPE function, or load the image without further
 * seeking.
 *
 * You do not need to call this function to load data; SDL_image can work to
 * determine file type in many cases in its standard load functions.
 *
 * \param src a seekable/readable SDL_IOStream to provide image data.
 * \returns non-zero if this is XCF data, zero otherwise.
 *
 * \since This function is available since SDL_image 3.0.0.
 *
 * \sa IMG_isAVIF
 * \sa IMG_isICO
 * \sa IMG_isCUR
 * \sa IMG_isBMP
 * \sa IMG_isGIF
 * \sa IMG_isJPG
 * \sa IMG_isJXL
 * \sa IMG_isLBM
 * \sa IMG_isPCX
 * \sa IMG_isPNG
 * \sa IMG_isPNM
 * \sa IMG_isSVG
 * \sa IMG_isQOI
 * \sa IMG_isTIF
 * \sa IMG_isXPM
 * \sa IMG_isXV
 * \sa IMG_isWEBP
  }
function IMG_isXCF(src: PSDL_IOStream): Boolean; cdecl;
  external IMG_LibName {$IFDEF DELPHI} {$IFDEF MACOS} name '_IMG_isXCF' {$ENDIF} {$ENDIF};

{*
 * Detect XPM image data on a readable/seekable SDL_IOStream.
 *
 * This function attempts to determine if a file is a given filetype, reading
 * the least amount possible from the SDL_IOStream (usually a few bytes).
 *
 * There is no distinction made between "not the filetype in question" and
 * basic i/o errors.
 *
 * This function will always attempt to seek `src` back to where it started
 * when this function was called, but it will not report any errors in doing
 * so, but assuming seeking works, this means you can immediately use this
 * with a different IMG_isTYPE function, or load the image without further
 * seeking.
 *
 * You do not need to call this function to load data; SDL_image can work to
 * determine file type in many cases in its standard load functions.
 *
 * \param src a seekable/readable SDL_IOStream to provide image data.
 * \returns non-zero if this is XPM data, zero otherwise.
 *
 * \since This function is available since SDL_image 3.0.0.
 *
 * \sa IMG_isAVIF
 * \sa IMG_isICO
 * \sa IMG_isCUR
 * \sa IMG_isBMP
 * \sa IMG_isGIF
 * \sa IMG_isJPG
 * \sa IMG_isJXL
 * \sa IMG_isLBM
 * \sa IMG_isPCX
 * \sa IMG_isPNG
 * \sa IMG_isPNM
 * \sa IMG_isSVG
 * \sa IMG_isQOI
 * \sa IMG_isTIF
 * \sa IMG_isXCF
 * \sa IMG_isXV
 * \sa IMG_isWEBP
  }
function IMG_isXPM(src: PSDL_IOStream): Boolean; cdecl;
  external IMG_LibName {$IFDEF DELPHI} {$IFDEF MACOS} name '_IMG_isXPM' {$ENDIF} {$ENDIF};

{*
 * Detect XV image data on a readable/seekable SDL_IOStream.
 *
 * This function attempts to determine if a file is a given filetype, reading
 * the least amount possible from the SDL_IOStream (usually a few bytes).
 *
 * There is no distinction made between "not the filetype in question" and
 * basic i/o errors.
 *
 * This function will always attempt to seek `src` back to where it started
 * when this function was called, but it will not report any errors in doing
 * so, but assuming seeking works, this means you can immediately use this
 * with a different IMG_isTYPE function, or load the image without further
 * seeking.
 *
 * You do not need to call this function to load data; SDL_image can work to
 * determine file type in many cases in its standard load functions.
 *
 * \param src a seekable/readable SDL_IOStream to provide image data.
 * \returns non-zero if this is XV data, zero otherwise.
 *
 * \since This function is available since SDL_image 3.0.0.
 *
 * \sa IMG_isAVIF
 * \sa IMG_isICO
 * \sa IMG_isCUR
 * \sa IMG_isBMP
 * \sa IMG_isGIF
 * \sa IMG_isJPG
 * \sa IMG_isJXL
 * \sa IMG_isLBM
 * \sa IMG_isPCX
 * \sa IMG_isPNG
 * \sa IMG_isPNM
 * \sa IMG_isSVG
 * \sa IMG_isQOI
 * \sa IMG_isTIF
 * \sa IMG_isXCF
 * \sa IMG_isXPM
 * \sa IMG_isWEBP
  }
function IMG_isXV(src: PSDL_IOStream): Boolean; cdecl;
  external IMG_LibName {$IFDEF DELPHI} {$IFDEF MACOS} name '_IMG_isXV' {$ENDIF} {$ENDIF};

{*
 * Detect WEBP image data on a readable/seekable SDL_IOStream.
 *
 * This function attempts to determine if a file is a given filetype, reading
 * the least amount possible from the SDL_IOStream (usually a few bytes).
 *
 * There is no distinction made between "not the filetype in question" and
 * basic i/o errors.
 *
 * This function will always attempt to seek `src` back to where it started
 * when this function was called, but it will not report any errors in doing
 * so, but assuming seeking works, this means you can immediately use this
 * with a different IMG_isTYPE function, or load the image without further
 * seeking.
 *
 * You do not need to call this function to load data; SDL_image can work to
 * determine file type in many cases in its standard load functions.
 *
 * \param src a seekable/readable SDL_IOStream to provide image data.
 * \returns non-zero if this is WEBP data, zero otherwise.
 *
 * \since This function is available since SDL_image 3.0.0.
 *
 * \sa IMG_isAVIF
 * \sa IMG_isICO
 * \sa IMG_isCUR
 * \sa IMG_isBMP
 * \sa IMG_isGIF
 * \sa IMG_isJPG
 * \sa IMG_isJXL
 * \sa IMG_isLBM
 * \sa IMG_isPCX
 * \sa IMG_isPNG
 * \sa IMG_isPNM
 * \sa IMG_isSVG
 * \sa IMG_isQOI
 * \sa IMG_isTIF
 * \sa IMG_isXCF
 * \sa IMG_isXPM
 * \sa IMG_isXV
  }
function IMG_isWEBP(src: PSDL_IOStream): Boolean; cdecl;
  external IMG_LibName {$IFDEF DELPHI} {$IFDEF MACOS} name '_IMG_isWEBP' {$ENDIF} {$ENDIF};

{*
 * Load a AVIF image directly.
 *
 * If you know you definitely have a AVIF image, you can call this function,
 * which will skip SDL_image's file format detection routines. Generally it's
 * better to use the abstract interfaces; also, there is only an SDL_IOStream
 * interface available here.
 *
 * \param src an SDL_IOStream to load image data from.
 * \returns SDL surface, or nil on error.
 *
 * \since This function is available since SDL_image 3.0.0.
 *
 * \sa IMG_LoadICO_IO
 * \sa IMG_LoadCUR_IO
 * \sa IMG_LoadBMP_IO
 * \sa IMG_LoadGIF_IO
 * \sa IMG_LoadJPG_IO
 * \sa IMG_LoadJXL_IO
 * \sa IMG_LoadLBM_IO
 * \sa IMG_LoadPCX_IO
 * \sa IMG_LoadPNG_IO
 * \sa IMG_LoadPNM_IO
 * \sa IMG_LoadSVG_IO
 * \sa IMG_LoadQOI_IO
 * \sa IMG_LoadTGA_IO
 * \sa IMG_LoadTIF_IO
 * \sa IMG_LoadXCF_IO
 * \sa IMG_LoadXPM_IO
 * \sa IMG_LoadXV_IO
 * \sa IMG_LoadWEBP_IO
  }
function IMG_LoadAVIF_IO(src: PSDL_IOStream): PSDL_Surface; cdecl;
  external IMG_LibName {$IFDEF DELPHI} {$IFDEF MACOS} name '_IMG_LoadAVIF_IO' {$ENDIF} {$ENDIF};

{*
 * Load a ICO image directly.
 *
 * If you know you definitely have a ICO image, you can call this function,
 * which will skip SDL_image's file format detection routines. Generally it's
 * better to use the abstract interfaces; also, there is only an SDL_IOStream
 * interface available here.
 *
 * \param src an SDL_IOStream to load image data from.
 * \returns SDL surface, or nil on error.
 *
 * \since This function is available since SDL_image 3.0.0.
 *
 * \sa IMG_LoadAVIF_IO
 * \sa IMG_LoadCUR_IO
 * \sa IMG_LoadBMP_IO
 * \sa IMG_LoadGIF_IO
 * \sa IMG_LoadJPG_IO
 * \sa IMG_LoadJXL_IO
 * \sa IMG_LoadLBM_IO
 * \sa IMG_LoadPCX_IO
 * \sa IMG_LoadPNG_IO
 * \sa IMG_LoadPNM_IO
 * \sa IMG_LoadSVG_IO
 * \sa IMG_LoadQOI_IO
 * \sa IMG_LoadTGA_IO
 * \sa IMG_LoadTIF_IO
 * \sa IMG_LoadXCF_IO
 * \sa IMG_LoadXPM_IO
 * \sa IMG_LoadXV_IO
 * \sa IMG_LoadWEBP_IO
  }
function IMG_LoadICO_IO(src: PSDL_IOStream): PSDL_Surface; cdecl;
  external IMG_LibName {$IFDEF DELPHI} {$IFDEF MACOS} name '_IMG_LoadICO_IO' {$ENDIF} {$ENDIF};

{*
 * Load a CUR image directly.
 *
 * If you know you definitely have a CUR image, you can call this function,
 * which will skip SDL_image's file format detection routines. Generally it's
 * better to use the abstract interfaces; also, there is only an SDL_IOStream
 * interface available here.
 *
 * \param src an SDL_IOStream to load image data from.
 * \returns SDL surface, or nil on error.
 *
 * \since This function is available since SDL_image 3.0.0.
 *
 * \sa IMG_LoadAVIF_IO
 * \sa IMG_LoadICO_IO
 * \sa IMG_LoadBMP_IO
 * \sa IMG_LoadGIF_IO
 * \sa IMG_LoadJPG_IO
 * \sa IMG_LoadJXL_IO
 * \sa IMG_LoadLBM_IO
 * \sa IMG_LoadPCX_IO
 * \sa IMG_LoadPNG_IO
 * \sa IMG_LoadPNM_IO
 * \sa IMG_LoadSVG_IO
 * \sa IMG_LoadQOI_IO
 * \sa IMG_LoadTGA_IO
 * \sa IMG_LoadTIF_IO
 * \sa IMG_LoadXCF_IO
 * \sa IMG_LoadXPM_IO
 * \sa IMG_LoadXV_IO
 * \sa IMG_LoadWEBP_IO
  }
function IMG_LoadCUR_IO(src: PSDL_IOStream): PSDL_Surface; cdecl;
  external IMG_LibName {$IFDEF DELPHI} {$IFDEF MACOS} name '_IMG_LoadCUR_IO' {$ENDIF} {$ENDIF};

{*
 * Load a BMP image directly.
 *
 * If you know you definitely have a BMP image, you can call this function,
 * which will skip SDL_image's file format detection routines. Generally it's
 * better to use the abstract interfaces; also, there is only an SDL_IOStream
 * interface available here.
 *
 * \param src an SDL_IOStream to load image data from.
 * \returns SDL surface, or nil on error.
 *
 * \since This function is available since SDL_image 3.0.0.
 *
 * \sa IMG_LoadAVIF_IO
 * \sa IMG_LoadICO_IO
 * \sa IMG_LoadCUR_IO
 * \sa IMG_LoadGIF_IO
 * \sa IMG_LoadJPG_IO
 * \sa IMG_LoadJXL_IO
 * \sa IMG_LoadLBM_IO
 * \sa IMG_LoadPCX_IO
 * \sa IMG_LoadPNG_IO
 * \sa IMG_LoadPNM_IO
 * \sa IMG_LoadSVG_IO
 * \sa IMG_LoadQOI_IO
 * \sa IMG_LoadTGA_IO
 * \sa IMG_LoadTIF_IO
 * \sa IMG_LoadXCF_IO
 * \sa IMG_LoadXPM_IO
 * \sa IMG_LoadXV_IO
 * \sa IMG_LoadWEBP_IO
  }
function IMG_LoadBMP_IO(src: PSDL_IOStream): PSDL_Surface; cdecl;
  external IMG_LibName {$IFDEF DELPHI} {$IFDEF MACOS} name '_IMG_LoadBMP_IO' {$ENDIF} {$ENDIF};

{*
 * Load a GIF image directly.
 *
 * If you know you definitely have a GIF image, you can call this function,
 * which will skip SDL_image's file format detection routines. Generally it's
 * better to use the abstract interfaces; also, there is only an SDL_IOStream
 * interface available here.
 *
 * \param src an SDL_IOStream to load image data from.
 * \returns SDL surface, or nil on error.
 *
 * \since This function is available since SDL_image 3.0.0.
 *
 * \sa IMG_LoadAVIF_IO
 * \sa IMG_LoadICO_IO
 * \sa IMG_LoadCUR_IO
 * \sa IMG_LoadBMP_IO
 * \sa IMG_LoadJPG_IO
 * \sa IMG_LoadJXL_IO
 * \sa IMG_LoadLBM_IO
 * \sa IMG_LoadPCX_IO
 * \sa IMG_LoadPNG_IO
 * \sa IMG_LoadPNM_IO
 * \sa IMG_LoadSVG_IO
 * \sa IMG_LoadQOI_IO
 * \sa IMG_LoadTGA_IO
 * \sa IMG_LoadTIF_IO
 * \sa IMG_LoadXCF_IO
 * \sa IMG_LoadXPM_IO
 * \sa IMG_LoadXV_IO
 * \sa IMG_LoadWEBP_IO
  }
function IMG_LoadGIF_IO(src: PSDL_IOStream): PSDL_Surface; cdecl;
  external IMG_LibName {$IFDEF DELPHI} {$IFDEF MACOS} name '_IMG_LoadGIF_IO' {$ENDIF} {$ENDIF};

{*
 * Load a JPG image directly.
 *
 * If you know you definitely have a JPG image, you can call this function,
 * which will skip SDL_image's file format detection routines. Generally it's
 * better to use the abstract interfaces; also, there is only an SDL_IOStream
 * interface available here.
 *
 * \param src an SDL_IOStream to load image data from.
 * \returns SDL surface, or nil on error.
 *
 * \since This function is available since SDL_image 3.0.0.
 *
 * \sa IMG_LoadAVIF_IO
 * \sa IMG_LoadICO_IO
 * \sa IMG_LoadCUR_IO
 * \sa IMG_LoadBMP_IO
 * \sa IMG_LoadGIF_IO
 * \sa IMG_LoadJXL_IO
 * \sa IMG_LoadLBM_IO
 * \sa IMG_LoadPCX_IO
 * \sa IMG_LoadPNG_IO
 * \sa IMG_LoadPNM_IO
 * \sa IMG_LoadSVG_IO
 * \sa IMG_LoadQOI_IO
 * \sa IMG_LoadTGA_IO
 * \sa IMG_LoadTIF_IO
 * \sa IMG_LoadXCF_IO
 * \sa IMG_LoadXPM_IO
 * \sa IMG_LoadXV_IO
 * \sa IMG_LoadWEBP_IO
  }
function IMG_LoadJPG_IO(src: PSDL_IOStream): PSDL_Surface; cdecl;
  external IMG_LibName {$IFDEF DELPHI} {$IFDEF MACOS} name '_IMG_LoadJPG_IO' {$ENDIF} {$ENDIF};

{*
 * Load a JXL image directly.
 *
 * If you know you definitely have a JXL image, you can call this function,
 * which will skip SDL_image's file format detection routines. Generally it's
 * better to use the abstract interfaces; also, there is only an SDL_IOStream
 * interface available here.
 *
 * \param src an SDL_IOStream to load image data from.
 * \returns SDL surface, or nil on error.
 *
 * \since This function is available since SDL_image 3.0.0.
 *
 * \sa IMG_LoadAVIF_IO
 * \sa IMG_LoadICO_IO
 * \sa IMG_LoadCUR_IO
 * \sa IMG_LoadBMP_IO
 * \sa IMG_LoadGIF_IO
 * \sa IMG_LoadJPG_IO
 * \sa IMG_LoadLBM_IO
 * \sa IMG_LoadPCX_IO
 * \sa IMG_LoadPNG_IO
 * \sa IMG_LoadPNM_IO
 * \sa IMG_LoadSVG_IO
 * \sa IMG_LoadQOI_IO
 * \sa IMG_LoadTGA_IO
 * \sa IMG_LoadTIF_IO
 * \sa IMG_LoadXCF_IO
 * \sa IMG_LoadXPM_IO
 * \sa IMG_LoadXV_IO
 * \sa IMG_LoadWEBP_IO
  }
function IMG_LoadJXL_IO(src: PSDL_IOStream): PSDL_Surface; cdecl;
  external IMG_LibName {$IFDEF DELPHI} {$IFDEF MACOS} name '_IMG_LoadJXL_IO' {$ENDIF} {$ENDIF};

{*
 * Load a LBM image directly.
 *
 * If you know you definitely have a LBM image, you can call this function,
 * which will skip SDL_image's file format detection routines. Generally it's
 * better to use the abstract interfaces; also, there is only an SDL_IOStream
 * interface available here.
 *
 * \param src an SDL_IOStream to load image data from.
 * \returns SDL surface, or nil on error.
 *
 * \since This function is available since SDL_image 3.0.0.
 *
 * \sa IMG_LoadAVIF_IO
 * \sa IMG_LoadICO_IO
 * \sa IMG_LoadCUR_IO
 * \sa IMG_LoadBMP_IO
 * \sa IMG_LoadGIF_IO
 * \sa IMG_LoadJPG_IO
 * \sa IMG_LoadJXL_IO
 * \sa IMG_LoadPCX_IO
 * \sa IMG_LoadPNG_IO
 * \sa IMG_LoadPNM_IO
 * \sa IMG_LoadSVG_IO
 * \sa IMG_LoadQOI_IO
 * \sa IMG_LoadTGA_IO
 * \sa IMG_LoadTIF_IO
 * \sa IMG_LoadXCF_IO
 * \sa IMG_LoadXPM_IO
 * \sa IMG_LoadXV_IO
 * \sa IMG_LoadWEBP_IO
  }
function IMG_LoadLBM_IO(src: PSDL_IOStream): PSDL_Surface; cdecl;
  external IMG_LibName {$IFDEF DELPHI} {$IFDEF MACOS} name '_IMG_LoadLBM_IO' {$ENDIF} {$ENDIF};

{*
 * Load a PCX image directly.
 *
 * If you know you definitely have a PCX image, you can call this function,
 * which will skip SDL_image's file format detection routines. Generally it's
 * better to use the abstract interfaces; also, there is only an SDL_IOStream
 * interface available here.
 *
 * \param src an SDL_IOStream to load image data from.
 * \returns SDL surface, or nil on error.
 *
 * \since This function is available since SDL_image 3.0.0.
 *
 * \sa IMG_LoadAVIF_IO
 * \sa IMG_LoadICO_IO
 * \sa IMG_LoadCUR_IO
 * \sa IMG_LoadBMP_IO
 * \sa IMG_LoadGIF_IO
 * \sa IMG_LoadJPG_IO
 * \sa IMG_LoadJXL_IO
 * \sa IMG_LoadLBM_IO
 * \sa IMG_LoadPNG_IO
 * \sa IMG_LoadPNM_IO
 * \sa IMG_LoadSVG_IO
 * \sa IMG_LoadQOI_IO
 * \sa IMG_LoadTGA_IO
 * \sa IMG_LoadTIF_IO
 * \sa IMG_LoadXCF_IO
 * \sa IMG_LoadXPM_IO
 * \sa IMG_LoadXV_IO
 * \sa IMG_LoadWEBP_IO
  }
function IMG_LoadPCX_IO(src: PSDL_IOStream): PSDL_Surface; cdecl;
  external IMG_LibName {$IFDEF DELPHI} {$IFDEF MACOS} name '_IMG_LoadPCX_IO' {$ENDIF} {$ENDIF};

{*
 * Load a PNG image directly.
 *
 * If you know you definitely have a PNG image, you can call this function,
 * which will skip SDL_image's file format detection routines. Generally it's
 * better to use the abstract interfaces; also, there is only an SDL_IOStream
 * interface available here.
 *
 * \param src an SDL_IOStream to load image data from.
 * \returns SDL surface, or nil on error.
 *
 * \since This function is available since SDL_image 3.0.0.
 *
 * \sa IMG_LoadAVIF_IO
 * \sa IMG_LoadICO_IO
 * \sa IMG_LoadCUR_IO
 * \sa IMG_LoadBMP_IO
 * \sa IMG_LoadGIF_IO
 * \sa IMG_LoadJPG_IO
 * \sa IMG_LoadJXL_IO
 * \sa IMG_LoadLBM_IO
 * \sa IMG_LoadPCX_IO
 * \sa IMG_LoadPNM_IO
 * \sa IMG_LoadSVG_IO
 * \sa IMG_LoadQOI_IO
 * \sa IMG_LoadTGA_IO
 * \sa IMG_LoadTIF_IO
 * \sa IMG_LoadXCF_IO
 * \sa IMG_LoadXPM_IO
 * \sa IMG_LoadXV_IO
 * \sa IMG_LoadWEBP_IO
  }
function IMG_LoadPNG_IO(src: PSDL_IOStream): PSDL_Surface; cdecl;
  external IMG_LibName {$IFDEF DELPHI} {$IFDEF MACOS} name '_IMG_LoadPNG_IO' {$ENDIF} {$ENDIF};

{*
 * Load a PNM image directly.
 *
 * If you know you definitely have a PNM image, you can call this function,
 * which will skip SDL_image's file format detection routines. Generally it's
 * better to use the abstract interfaces; also, there is only an SDL_IOStream
 * interface available here.
 *
 * \param src an SDL_IOStream to load image data from.
 * \returns SDL surface, or nil on error.
 *
 * \since This function is available since SDL_image 3.0.0.
 *
 * \sa IMG_LoadAVIF_IO
 * \sa IMG_LoadICO_IO
 * \sa IMG_LoadCUR_IO
 * \sa IMG_LoadBMP_IO
 * \sa IMG_LoadGIF_IO
 * \sa IMG_LoadJPG_IO
 * \sa IMG_LoadJXL_IO
 * \sa IMG_LoadLBM_IO
 * \sa IMG_LoadPCX_IO
 * \sa IMG_LoadPNG_IO
 * \sa IMG_LoadSVG_IO
 * \sa IMG_LoadQOI_IO
 * \sa IMG_LoadTGA_IO
 * \sa IMG_LoadTIF_IO
 * \sa IMG_LoadXCF_IO
 * \sa IMG_LoadXPM_IO
 * \sa IMG_LoadXV_IO
 * \sa IMG_LoadWEBP_IO
  }
function IMG_LoadPNM_IO(src: PSDL_IOStream): PSDL_Surface; cdecl;
  external IMG_LibName {$IFDEF DELPHI} {$IFDEF MACOS} name '_IMG_LoadPNM_IO' {$ENDIF} {$ENDIF};

{*
 * Load a SVG image directly.
 *
 * If you know you definitely have a SVG image, you can call this function,
 * which will skip SDL_image's file format detection routines. Generally it's
 * better to use the abstract interfaces; also, there is only an SDL_IOStream
 * interface available here.
 *
 * \param src an SDL_IOStream to load image data from.
 * \returns SDL surface, or nil on error.
 *
 * \since This function is available since SDL_image 3.0.0.
 *
 * \sa IMG_LoadAVIF_IO
 * \sa IMG_LoadICO_IO
 * \sa IMG_LoadCUR_IO
 * \sa IMG_LoadBMP_IO
 * \sa IMG_LoadGIF_IO
 * \sa IMG_LoadJPG_IO
 * \sa IMG_LoadJXL_IO
 * \sa IMG_LoadLBM_IO
 * \sa IMG_LoadPCX_IO
 * \sa IMG_LoadPNG_IO
 * \sa IMG_LoadPNM_IO
 * \sa IMG_LoadQOI_IO
 * \sa IMG_LoadTGA_IO
 * \sa IMG_LoadTIF_IO
 * \sa IMG_LoadXCF_IO
 * \sa IMG_LoadXPM_IO
 * \sa IMG_LoadXV_IO
 * \sa IMG_LoadWEBP_IO
  }
function IMG_LoadSVG_IO(src: PSDL_IOStream): PSDL_Surface; cdecl;
  external IMG_LibName {$IFDEF DELPHI} {$IFDEF MACOS} name '_IMG_LoadSVG_IO' {$ENDIF} {$ENDIF};

{*
 * Load a QOI image directly.
 *
 * If you know you definitely have a QOI image, you can call this function,
 * which will skip SDL_image's file format detection routines. Generally it's
 * better to use the abstract interfaces; also, there is only an SDL_IOStream
 * interface available here.
 *
 * \param src an SDL_IOStream to load image data from.
 * \returns SDL surface, or nil on error.
 *
 * \since This function is available since SDL_image 3.0.0.
 *
 * \sa IMG_LoadAVIF_IO
 * \sa IMG_LoadICO_IO
 * \sa IMG_LoadCUR_IO
 * \sa IMG_LoadBMP_IO
 * \sa IMG_LoadGIF_IO
 * \sa IMG_LoadJPG_IO
 * \sa IMG_LoadJXL_IO
 * \sa IMG_LoadLBM_IO
 * \sa IMG_LoadPCX_IO
 * \sa IMG_LoadPNG_IO
 * \sa IMG_LoadPNM_IO
 * \sa IMG_LoadSVG_IO
 * \sa IMG_LoadTGA_IO
 * \sa IMG_LoadTIF_IO
 * \sa IMG_LoadXCF_IO
 * \sa IMG_LoadXPM_IO
 * \sa IMG_LoadXV_IO
 * \sa IMG_LoadWEBP_IO
  }
function IMG_LoadQOI_IO(src: PSDL_IOStream): PSDL_Surface; cdecl;
  external IMG_LibName {$IFDEF DELPHI} {$IFDEF MACOS} name '_IMG_LoadQOI_IO' {$ENDIF} {$ENDIF};

{*
 * Load a TGA image directly.
 *
 * If you know you definitely have a TGA image, you can call this function,
 * which will skip SDL_image's file format detection routines. Generally it's
 * better to use the abstract interfaces; also, there is only an SDL_IOStream
 * interface available here.
 *
 * \param src an SDL_IOStream to load image data from.
 * \returns SDL surface, or nil on error.
 *
 * \since This function is available since SDL_image 3.0.0.
 *
 * \sa IMG_LoadAVIF_IO
 * \sa IMG_LoadICO_IO
 * \sa IMG_LoadCUR_IO
 * \sa IMG_LoadBMP_IO
 * \sa IMG_LoadGIF_IO
 * \sa IMG_LoadJPG_IO
 * \sa IMG_LoadJXL_IO
 * \sa IMG_LoadLBM_IO
 * \sa IMG_LoadPCX_IO
 * \sa IMG_LoadPNG_IO
 * \sa IMG_LoadPNM_IO
 * \sa IMG_LoadSVG_IO
 * \sa IMG_LoadQOI_IO
 * \sa IMG_LoadTIF_IO
 * \sa IMG_LoadXCF_IO
 * \sa IMG_LoadXPM_IO
 * \sa IMG_LoadXV_IO
 * \sa IMG_LoadWEBP_IO
  }
function IMG_LoadTGA_IO(src: PSDL_IOStream): PSDL_Surface; cdecl;
  external IMG_LibName {$IFDEF DELPHI} {$IFDEF MACOS} name '_IMG_LoadTGA_IO' {$ENDIF} {$ENDIF};

{*
 * Load a TIFF image directly.
 *
 * If you know you definitely have a TIFF image, you can call this function,
 * which will skip SDL_image's file format detection routines. Generally it's
 * better to use the abstract interfaces; also, there is only an SDL_IOStream
 * interface available here.
 *
 * \param src an SDL_IOStream to load image data from.
 * \returns SDL surface, or nil on error.
 *
 * \since This function is available since SDL_image 3.0.0.
 *
 * \sa IMG_LoadAVIF_IO
 * \sa IMG_LoadICO_IO
 * \sa IMG_LoadCUR_IO
 * \sa IMG_LoadBMP_IO
 * \sa IMG_LoadGIF_IO
 * \sa IMG_LoadJPG_IO
 * \sa IMG_LoadJXL_IO
 * \sa IMG_LoadLBM_IO
 * \sa IMG_LoadPCX_IO
 * \sa IMG_LoadPNG_IO
 * \sa IMG_LoadPNM_IO
 * \sa IMG_LoadSVG_IO
 * \sa IMG_LoadQOI_IO
 * \sa IMG_LoadTGA_IO
 * \sa IMG_LoadXCF_IO
 * \sa IMG_LoadXPM_IO
 * \sa IMG_LoadXV_IO
 * \sa IMG_LoadWEBP_IO
  }
function IMG_LoadTIF_IO(src: PSDL_IOStream): PSDL_Surface; cdecl;
  external IMG_LibName {$IFDEF DELPHI} {$IFDEF MACOS} name '_IMG_LoadTIF_IO' {$ENDIF} {$ENDIF};

{*
 * Load a XCF image directly.
 *
 * If you know you definitely have a XCF image, you can call this function,
 * which will skip SDL_image's file format detection routines. Generally it's
 * better to use the abstract interfaces; also, there is only an SDL_IOStream
 * interface available here.
 *
 * \param src an SDL_IOStream to load image data from.
 * \returns SDL surface, or nil on error.
 *
 * \since This function is available since SDL_image 3.0.0.
 *
 * \sa IMG_LoadAVIF_IO
 * \sa IMG_LoadICO_IO
 * \sa IMG_LoadCUR_IO
 * \sa IMG_LoadBMP_IO
 * \sa IMG_LoadGIF_IO
 * \sa IMG_LoadJPG_IO
 * \sa IMG_LoadJXL_IO
 * \sa IMG_LoadLBM_IO
 * \sa IMG_LoadPCX_IO
 * \sa IMG_LoadPNG_IO
 * \sa IMG_LoadPNM_IO
 * \sa IMG_LoadSVG_IO
 * \sa IMG_LoadQOI_IO
 * \sa IMG_LoadTGA_IO
 * \sa IMG_LoadTIF_IO
 * \sa IMG_LoadXPM_IO
 * \sa IMG_LoadXV_IO
 * \sa IMG_LoadWEBP_IO
  }
function IMG_LoadXCF_IO(src: PSDL_IOStream): PSDL_Surface; cdecl;
  external IMG_LibName {$IFDEF DELPHI} {$IFDEF MACOS} name '_IMG_LoadXCF_IO' {$ENDIF} {$ENDIF};

{*
 * Load a XPM image directly.
 *
 * If you know you definitely have a XPM image, you can call this function,
 * which will skip SDL_image's file format detection routines. Generally it's
 * better to use the abstract interfaces; also, there is only an SDL_IOStream
 * interface available here.
 *
 * \param src an SDL_IOStream to load image data from.
 * \returns SDL surface, or nil on error.
 *
 * \since This function is available since SDL_image 3.0.0.
 *
 * \sa IMG_LoadAVIF_IO
 * \sa IMG_LoadICO_IO
 * \sa IMG_LoadCUR_IO
 * \sa IMG_LoadBMP_IO
 * \sa IMG_LoadGIF_IO
 * \sa IMG_LoadJPG_IO
 * \sa IMG_LoadJXL_IO
 * \sa IMG_LoadLBM_IO
 * \sa IMG_LoadPCX_IO
 * \sa IMG_LoadPNG_IO
 * \sa IMG_LoadPNM_IO
 * \sa IMG_LoadSVG_IO
 * \sa IMG_LoadQOI_IO
 * \sa IMG_LoadTGA_IO
 * \sa IMG_LoadTIF_IO
 * \sa IMG_LoadXCF_IO
 * \sa IMG_LoadXV_IO
 * \sa IMG_LoadWEBP_IO
  }
function IMG_LoadXPM_IO(src: PSDL_IOStream): PSDL_Surface; cdecl;
  external IMG_LibName {$IFDEF DELPHI} {$IFDEF MACOS} name '_IMG_LoadXPM_IO' {$ENDIF} {$ENDIF};

{*
 * Load a XV image directly.
 *
 * If you know you definitely have a XV image, you can call this function,
 * which will skip SDL_image's file format detection routines. Generally it's
 * better to use the abstract interfaces; also, there is only an SDL_IOStream
 * interface available here.
 *
 * \param src an SDL_IOStream to load image data from.
 * \returns SDL surface, or nil on error.
 *
 * \since This function is available since SDL_image 3.0.0.
 *
 * \sa IMG_LoadAVIF_IO
 * \sa IMG_LoadICO_IO
 * \sa IMG_LoadCUR_IO
 * \sa IMG_LoadBMP_IO
 * \sa IMG_LoadGIF_IO
 * \sa IMG_LoadJPG_IO
 * \sa IMG_LoadJXL_IO
 * \sa IMG_LoadLBM_IO
 * \sa IMG_LoadPCX_IO
 * \sa IMG_LoadPNG_IO
 * \sa IMG_LoadPNM_IO
 * \sa IMG_LoadSVG_IO
 * \sa IMG_LoadQOI_IO
 * \sa IMG_LoadTGA_IO
 * \sa IMG_LoadTIF_IO
 * \sa IMG_LoadXCF_IO
 * \sa IMG_LoadXPM_IO
 * \sa IMG_LoadWEBP_IO
  }
function IMG_LoadXV_IO(src: PSDL_IOStream): PSDL_Surface; cdecl;
  external IMG_LibName {$IFDEF DELPHI} {$IFDEF MACOS} name '_IMG_LoadXV_IO' {$ENDIF} {$ENDIF};

{*
 * Load a WEBP image directly.
 *
 * If you know you definitely have a WEBP image, you can call this function,
 * which will skip SDL_image's file format detection routines. Generally it's
 * better to use the abstract interfaces; also, there is only an SDL_IOStream
 * interface available here.
 *
 * \param src an SDL_IOStream to load image data from.
 * \returns SDL surface, or nil on error.
 *
 * \since This function is available since SDL_image 3.0.0.
 *
 * \sa IMG_LoadAVIF_IO
 * \sa IMG_LoadICO_IO
 * \sa IMG_LoadCUR_IO
 * \sa IMG_LoadBMP_IO
 * \sa IMG_LoadGIF_IO
 * \sa IMG_LoadJPG_IO
 * \sa IMG_LoadJXL_IO
 * \sa IMG_LoadLBM_IO
 * \sa IMG_LoadPCX_IO
 * \sa IMG_LoadPNG_IO
 * \sa IMG_LoadPNM_IO
 * \sa IMG_LoadSVG_IO
 * \sa IMG_LoadQOI_IO
 * \sa IMG_LoadTGA_IO
 * \sa IMG_LoadTIF_IO
 * \sa IMG_LoadXCF_IO
 * \sa IMG_LoadXPM_IO
 * \sa IMG_LoadXV_IO
  }
function IMG_LoadWEBP_IO(src: PSDL_IOStream): PSDL_Surface; cdecl;
  external IMG_LibName {$IFDEF DELPHI} {$IFDEF MACOS} name '_IMG_LoadWEBP_IO' {$ENDIF} {$ENDIF};

{*
 * Load an SVG image, scaled to a specific size.
 *
 * Since SVG files are resolution-independent, you specify the size you would
 * like the output image to be and it will be generated at those dimensions.
 *
 * Either width or height may be 0 and the image will be auto-sized to
 * preserve aspect ratio.
 *
 * When done with the returned surface, the app should dispose of it with a
 * call to SDL_DestroySurface().
 *
 * \param src an SDL_IOStream to load SVG data from.
 * \param width desired width of the generated surface, in pixels.
 * \param height desired height of the generated surface, in pixels.
 * \returns a new SDL surface, or nil on error.
 *
 * \since This function is available since SDL_image 3.0.0.
  }
function IMG_LoadSizedSVG_IO(src: PSDL_IOStream; width: cint; height: cint): PSDL_Surface; cdecl;
  external IMG_LibName {$IFDEF DELPHI} {$IFDEF MACOS} name '_IMG_LoadSizedSVG_IO' {$ENDIF} {$ENDIF};

{*
 * Load an XPM image from a memory array.
 *
 * The returned surface will be an 8bpp indexed surface, if possible,
 * otherwise it will be 32bpp. If you always want 32-bit data, use
 * IMG_ReadXPMFromArrayToRGB888() instead.
 *
 * When done with the returned surface, the app should dispose of it with a
 * call to SDL_DestroySurface().
 *
 * \param xpm a null-terminated array of strings that comprise XPM data.
 * \returns a new SDL surface, or nil on error.
 *
 * \since This function is available since SDL_image 3.0.0.
 *
 * \sa IMG_ReadXPMFromArrayToRGB888
  }
function IMG_ReadXPMFromArray(xpm: PPAnsiChar): PSDL_Surface; cdecl;
  external IMG_LibName {$IFDEF DELPHI} {$IFDEF MACOS} name '_IMG_ReadXPMFromArray' {$ENDIF} {$ENDIF};

{*
 * Load an XPM image from a memory array.
 *
 * The returned surface will always be a 32-bit RGB surface. If you want 8-bit
 * indexed colors (and the XPM data allows it), use IMG_ReadXPMFromArray()
 * instead.
 *
 * When done with the returned surface, the app should dispose of it with a
 * call to SDL_DestroySurface().
 *
 * \param xpm a null-terminated array of strings that comprise XPM data.
 * \returns a new SDL surface, or nil on error.
 *
 * \since This function is available since SDL_image 3.0.0.
 *
 * \sa IMG_ReadXPMFromArray
  }
function IMG_ReadXPMFromArrayToRGB888(xpm: PPAnsiChar): PSDL_Surface; cdecl;
  external IMG_LibName {$IFDEF DELPHI} {$IFDEF MACOS} name '_IMG_ReadXPMFromArrayToRGB888' {$ENDIF} {$ENDIF};

{*
 * Save an SDL_Surface into a AVIF image file.
 *
 * If the file already exists, it will be overwritten.
 *
 * \param surface the SDL surface to save.
 * \param file path on the filesystem to write new file to.
 * \param quality the desired quality, ranging between 0 (lowest) and 100
 *                (highest).
 * \returns true on success or false on failure; call SDL_GetError() for more
 *          information.
 *
 * \since This function is available since SDL_image 3.0.0.
 *
 * \sa IMG_SaveAVIF_IO
  }
function IMG_SaveAVIF(surface: PSDL_Surface; file_: PAnsiChar; quality: cint): Boolean; cdecl;
  external IMG_LibName {$IFDEF DELPHI} {$IFDEF MACOS} name '_IMG_SaveAVIF' {$ENDIF} {$ENDIF};

{*
 * Save an SDL_Surface into AVIF image data, via an SDL_IOStream.
 *
 * If you just want to save to a filename, you can use IMG_SaveAVIF() instead.
 *
 * If `closeio` is true, `dst` will be closed before returning, whether this
 * function succeeds or not.
 *
 * \param surface the SDL surface to save.
 * \param dst the SDL_IOStream to save the image data to.
 * \param closeio true to close/free the SDL_IOStream before returning, false
 *                to leave it open.
 * \param quality the desired quality, ranging between 0 (lowest) and 100
 *                (highest).
 * \returns true on success or false on failure; call SDL_GetError() for more
 *          information.
 *
 * \since This function is available since SDL_image 3.0.0.
 *
 * \sa IMG_SaveAVIF
  }
function IMG_SaveAVIF_IO(surface: PSDL_Surface; dst: PSDL_IOStream; closeio: Boolean; quality: cint): Boolean; cdecl;
  external IMG_LibName {$IFDEF DELPHI} {$IFDEF MACOS} name '_IMG_SaveAVIF_IO' {$ENDIF} {$ENDIF};

{*
 * Save an SDL_Surface into a PNG image file.
 *
 * If the file already exists, it will be overwritten.
 *
 * \param surface the SDL surface to save.
 * \param file path on the filesystem to write new file to.
 * \returns true on success or false on failure; call SDL_GetError() for more
 *          information.
 *
 * \since This function is available since SDL_image 3.0.0.
 *
 * \sa IMG_SavePNG_IO
  }
function IMG_SavePNG(surface: PSDL_Surface; file_: PAnsiChar): Boolean; cdecl;
  external IMG_LibName {$IFDEF DELPHI} {$IFDEF MACOS} name '_IMG_SavePNG' {$ENDIF} {$ENDIF};

{*
 * Save an SDL_Surface into PNG image data, via an SDL_IOStream.
 *
 * If you just want to save to a filename, you can use IMG_SavePNG() instead.
 *
 * If `closeio` is true, `dst` will be closed before returning, whether this
 * function succeeds or not.
 *
 * \param surface the SDL surface to save.
 * \param dst the SDL_IOStream to save the image data to.
 * \param closeio true to close/free the SDL_IOStream before returning, false
 *                to leave it open.
 * \returns true on success or false on failure; call SDL_GetError() for more
 *          information.
 *
 * \since This function is available since SDL_image 3.0.0.
 *
 * \sa IMG_SavePNG
  }
function IMG_SavePNG_IO(surface: PSDL_Surface; dst: PSDL_IOStream; closeio: Boolean): Boolean; cdecl;
  external IMG_LibName {$IFDEF DELPHI} {$IFDEF MACOS} name '_IMG_SavePNG_IO' {$ENDIF} {$ENDIF};

{*
 * Save an SDL_Surface into a JPEG image file.
 *
 * If the file already exists, it will be overwritten.
 *
 * \param surface the SDL surface to save.
 * \param file path on the filesystem to write new file to.
 * \param quality [0; 33] is Lowest quality, [34; 66] is Middle quality, [67;
 *                100] is Highest quality.
 * \returns true on success or false on failure; call SDL_GetError() for more
 *          information.
 *
 * \since This function is available since SDL_image 3.0.0.
 *
 * \sa IMG_SaveJPG_IO
  }
function IMG_SaveJPG(surface: PSDL_Surface; file_: PAnsiChar; quality: cint): Boolean; cdecl;
  external IMG_LibName {$IFDEF DELPHI} {$IFDEF MACOS} name '_IMG_SaveJPG' {$ENDIF} {$ENDIF};

{*
 * Save an SDL_Surface into JPEG image data, via an SDL_IOStream.
 *
 * If you just want to save to a filename, you can use IMG_SaveJPG() instead.
 *
 * If `closeio` is true, `dst` will be closed before returning, whether this
 * function succeeds or not.
 *
 * \param surface the SDL surface to save.
 * \param dst the SDL_IOStream to save the image data to.
 * \param closeio true to close/free the SDL_IOStream before returning, false
 *                to leave it open.
 * \param quality [0; 33] is Lowest quality, [34; 66] is Middle quality, [67;
 *                100] is Highest quality.
 * \returns true on success or false on failure; call SDL_GetError() for more
 *          information.
 *
 * \since This function is available since SDL_image 3.0.0.
 *
 * \sa IMG_SaveJPG
  }
function IMG_SaveJPG_IO(surface: PSDL_Surface; dst: PSDL_IOStream; closeio: Boolean; quality: cint): Boolean; cdecl;
  external IMG_LibName {$IFDEF DELPHI} {$IFDEF MACOS} name '_IMG_SaveJPG_IO' {$ENDIF} {$ENDIF};

{*
 * Animated image support
 *
 * Currently only animated GIFs and WEBP images are supported.
  }
type
  PPIMG_Animation = ^PIMG_Animation;
  PIMG_Animation = ^TIMG_Animation;
  TIMG_Animation = record
          w: cint;
          h: cint;
          count: cint;
          frames: PPSDL_Surface;
          delays: pcint;
        end;

{*
 * Load an animation from a file.
 *
 * When done with the returned animation, the app should dispose of it with a
 * call to IMG_FreeAnimation().
 *
 * \param file path on the filesystem containing an animated image.
 * \returns a new IMG_Animation, or nil on error.
 *
 * \since This function is available since SDL_image 3.0.0.
 *
 * \sa IMG_FreeAnimation
  }
function IMG_LoadAnimation(file_: PAnsiChar): PIMG_Animation; cdecl;
  external IMG_LibName {$IFDEF DELPHI} {$IFDEF MACOS} name '_IMG_LoadAnimation' {$ENDIF} {$ENDIF};

{*
 * Load an animation from an SDL_IOStream.
 *
 * If `closeio` is true, `src` will be closed before returning, whether this
 * function succeeds or not. SDL_image reads everything it needs from `src`
 * during this call in any case.
 *
 * When done with the returned animation, the app should dispose of it with a
 * call to IMG_FreeAnimation().
 *
 * \param src an SDL_IOStream that data will be read from.
 * \param closeio true to close/free the SDL_IOStream before returning, false
 *                to leave it open.
 * \returns a new IMG_Animation, or nil on error.
 *
 * \since This function is available since SDL_image 3.0.0.
 *
 * \sa IMG_FreeAnimation
  }
function IMG_LoadAnimation_IO(src: PSDL_IOStream; closeio: Boolean): PIMG_Animation; cdecl;
  external IMG_LibName {$IFDEF DELPHI} {$IFDEF MACOS} name '_IMG_LoadAnimation_IO' {$ENDIF} {$ENDIF};

{*
 * Load an animation from an SDL datasource
 *
 * Even though this function accepts a file type, SDL_image may still try
 * other decoders that are capable of detecting file type from the contents of
 * the image data, but may rely on the caller-provided type string for formats
 * that it cannot autodetect. If `type` is nil, SDL_image will rely solely on
 * its ability to guess the format.
 *
 * If `closeio` is true, `src` will be closed before returning, whether this
 * function succeeds or not. SDL_image reads everything it needs from `src`
 * during this call in any case.
 *
 * When done with the returned animation, the app should dispose of it with a
 * call to IMG_FreeAnimation().
 *
 * \param src an SDL_IOStream that data will be read from.
 * \param closeio true to close/free the SDL_IOStream before returning, false
 *                to leave it open.
 * \param type a filename extension that represent this data ("GIF", etc).
 * \returns a new IMG_Animation, or nil on error.
 *
 * \since This function is available since SDL_image 3.0.0.
 *
 * \sa IMG_LoadAnimation
 * \sa IMG_LoadAnimation_IO
 * \sa IMG_FreeAnimation
  }
function IMG_LoadAnimationTyped_IO(src: PSDL_IOStream; closeio: Boolean; type_: PAnsiChar): PIMG_Animation; cdecl;
  external IMG_LibName {$IFDEF DELPHI} {$IFDEF MACOS} name '_IMG_LoadAnimationTyped_IO' {$ENDIF} {$ENDIF};

{*
 * Dispose of an IMG_Animation and free its resources.
 *
 * The provided `anim` Pointer is not valid once this call returns.
 *
 * \param anim IMG_Animation to dispose of.
 *
 * \since This function is available since SDL_image 3.0.0.
 *
 * \sa IMG_LoadAnimation
 * \sa IMG_LoadAnimation_IO
 * \sa IMG_LoadAnimationTyped_IO
  }
procedure IMG_FreeAnimation(anim: PIMG_Animation); cdecl;
  external IMG_LibName {$IFDEF DELPHI} {$IFDEF MACOS} name '_IMG_FreeAnimation' {$ENDIF} {$ENDIF};

{*
 * Load a GIF animation directly.
 *
 * If you know you definitely have a GIF image, you can call this function,
 * which will skip SDL_image's file format detection routines. Generally it's
 * better to use the abstract interfaces; also, there is only an SDL_IOStream
 * interface available here.
 *
 * \param src an SDL_IOStream that data will be read from.
 * \returns a new IMG_Animation, or nil on error.
 *
 * \since This function is available since SDL_image 3.0.0.
 *
 * \sa IMG_LoadAnimation
 * \sa IMG_LoadAnimation_IO
 * \sa IMG_LoadAnimationTyped_IO
 * \sa IMG_FreeAnimation
  }
function IMG_LoadGIFAnimation_IO(src: PSDL_IOStream): PIMG_Animation; cdecl;
  external IMG_LibName {$IFDEF DELPHI} {$IFDEF MACOS} name '_IMG_LoadGIFAnimation_IO' {$ENDIF} {$ENDIF};

{*
 * Load a WEBP animation directly.
 *
 * If you know you definitely have a WEBP image, you can call this function,
 * which will skip SDL_image's file format detection routines. Generally it's
 * better to use the abstract interfaces; also, there is only an SDL_IOStream
 * interface available here.
 *
 * \param src an SDL_IOStream that data will be read from.
 * \returns a new IMG_Animation, or nil on error.
 *
 * \since This function is available since SDL_image 3.0.0.
 *
 * \sa IMG_LoadAnimation
 * \sa IMG_LoadAnimation_IO
 * \sa IMG_LoadAnimationTyped_IO
 * \sa IMG_FreeAnimation
  }
function IMG_LoadWEBPAnimation_IO(src: PSDL_IOStream): PIMG_Animation; cdecl;
  external IMG_LibName {$IFDEF DELPHI} {$IFDEF MACOS} name '_IMG_LoadWEBPAnimation_IO' {$ENDIF} {$ENDIF};

implementation

function SDL_IMAGE_VERSION: Integer;
begin
  Result:=SDL_VERSIONNUM(SDL_IMAGE_MAJOR_VERSION, SDL_IMAGE_MINOR_VERSION, SDL_IMAGE_MICRO_VERSION);
end;

function SDL_IMAGE_VERSION_ATLEAST(X, Y, Z: Integer): Boolean;
begin
  Result:=((SDL_IMAGE_MAJOR_VERSION >= X) and
           ((SDL_IMAGE_MAJOR_VERSION > X) or (SDL_IMAGE_MINOR_VERSION >= Y)) and
           ((SDL_IMAGE_MAJOR_VERSION > X) or (SDL_IMAGE_MINOR_VERSION > Y) or (SDL_IMAGE_MICRO_VERSION >= Z)));
end;

end.

