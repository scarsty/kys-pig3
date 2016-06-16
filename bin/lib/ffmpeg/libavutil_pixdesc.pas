(*
 * pixel format descriptor
 * Copyright (c) 2009 Michael Niedermayer <michaelni@gmx.at>
 *
 * This file is part of FFmpeg.
 *
 * FFmpeg is free software; you can redistribute it and/or
 * modify it under the terms of the GNU Lesser General Public
 * License as published by the Free Software Foundation; either
 * version 2.1 of the License, or (at your option) any later version.
 *
 * FFmpeg is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
 * Lesser General Public License for more details.
 *
 * You should have received a copy of the GNU Lesser General Public
 * License along with FFmpeg; if not, write to the Free Software
 * Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA 02110-1301 USA
 *)

(*
 * FFVCL - Delphi FFmpeg VCL Components
 * http://www.DelphiFFmpeg.com
 *
 * Original file: libavutil/pixdesc.h
 * Ported by CodeCoolie@CNSW 2010/02/08 -> $Date:: 2015-03-24 #$
 *)

(*
FFmpeg Delphi/Pascal Headers and Examples License Agreement

A modified part of FFVCL - Delphi FFmpeg VCL Components.
Copyright (c) 2008-2014 DelphiFFmpeg.com
All rights reserved.
http://www.DelphiFFmpeg.com

Redistribution and use in source and binary forms, with or without
modification, are permitted provided that the following conditions
are met:
1. Redistributions of source code must retain the above copyright
   notice, this list of conditions and the following disclaimer.
2. Redistributions in binary form must reproduce the above copyright
   notice, this list of conditions and the following disclaimer in the
   documentation and/or other materials provided with the distribution.

This source code is provided "as is" by DelphiFFmpeg.com without
warranty of any kind, either expressed or implied, including but not
limited to the implied warranties of merchantability and/or fitness
for a particular purpose.

Please also notice the License agreement of FFmpeg libraries.
*)

unit libavutil_pixdesc;

interface

{$I CompilerDefines.inc}

uses
  libavutil_pixfmt;

{$I libversion.inc}

const
  mask_plane        = $0003;
  mask_step_minus1  = $001C;
  mask_offset_plus1 = $00E0;
  mask_shift        = $0700;
  mask_depth_minus1 = $7800;

type
  TAVComponentDescriptor = record
    (**
     * Which of the 4 planes contains the component.
     *)
    //uint16_t plane        : 2;

    (**
     * Number of elements between 2 horizontally consecutive pixels minus 1.
     * Elements are bits for bitstream formats, bytes otherwise.
     *)
    //uint16_t step_minus1  : 3;

    (**
     * Number of elements before the component of the first pixel plus 1.
     * Elements are bits for bitstream formats, bytes otherwise.
     *)
    //uint16_t offset_plus1 : 3;

    (**
     * Number of least significant bits that must be shifted away
     * to get the value.
     *)
    //uint16_t shift        : 3;

    (**
     * Number of bits in the component minus 1.
     *)
    //uint16_t depth_minus1 : 4;
    dummy: Word;
  end;

(**
 * Descriptor that unambiguously describes how the bits of a pixel are
 * stored in the up to 4 data planes of an image. It also stores the
 * subsampling factors and number of components.
 *
 * @note This is separate of the colorspace (RGB, YCbCr, YPbPr, JPEG-style YUV
 *       and all the YUV variants) AVPixFmtDescriptor just stores how values
 *       are stored not what these values represent.
 *)
  PAVPixFmtDescriptor = ^TAVPixFmtDescriptor;
  TAVPixFmtDescriptor = record
    name: PAnsiChar;
    nb_components: Byte;      ///< The number of components each pixel has, (1-4)

    (**
     * Amount to shift the luma width right to find the chroma width.
     * For YV12 this is 1 for example.
     * chroma_width = -((-luma_width) >> log2_chroma_w)
     * The note above is needed to ensure rounding up.
     * This value only refers to the chroma components.
     *)
    log2_chroma_w: Byte;      ///< chroma_width = -((-luma_width )>>log2_chroma_w)

    (**
     * Amount to shift the luma height right to find the chroma height.
     * For YV12 this is 1 for example.
     * chroma_height= -((-luma_height) >> log2_chroma_h)
     * The note above is needed to ensure rounding up.
     * This value only refers to the chroma components.
     *)
    log2_chroma_h: Byte;
    flags: Byte;

    (**
     * Parameters that describe how pixels are packed.
     * If the format has 2 or 4 components, then alpha is last.
     * If the format has 1 or 2 components, then luma is 0.
     * If the format has 3 or 4 components:
     *   if the RGB flag is set then 0 is red, 1 is green and 2 is blue;
     *   otherwise 0 is luma, 1 is chroma-U and 2 is chroma-V.
     *)
    comp: array[0..3] of TAVComponentDescriptor;

    (**
     * Alternative comma-separated names.
     *)
    alias: PAnsiChar;
  end;

const
(**
 * Pixel format is big-endian.
 *)
  AV_PIX_FMT_FLAG_BE          = (1 shl 0);
(**
 * Pixel format has a palette in data[1], values are indexes in this palette.
 *)
  AV_PIX_FMT_FLAG_PAL         = (1 shl 1);
(**
 * All values of a component are bit-wise packed end to end.
 *)
  AV_PIX_FMT_FLAG_BITSTREAM   = (1 shl 2);
(**
 * Pixel format is an HW accelerated format.
 *)
  AV_PIX_FMT_FLAG_HWACCEL     = (1 shl 3);
(**
 * At least one pixel component is not in the first data plane.
 *)
  AV_PIX_FMT_FLAG_PLANAR      = (1 shl 4);
(**
 * The pixel format contains RGB-like data (as opposed to YUV/grayscale).
 *)
  AV_PIX_FMT_FLAG_RGB         = (1 shl 5);

(**
 * The pixel format is "pseudo-paletted". This means that it contains a
 * fixed palette in the 2nd plane but the palette is fixed/constant for each
 * PIX_FMT. This allows interpreting the data as if it was PAL8, which can
 * in some cases be simpler. Or the data can be interpreted purely based on
 * the pixel format without using the palette.
 * An example of a pseudo-paletted format is AV_PIX_FMT_GRAY8
 *)
  AV_PIX_FMT_FLAG_PSEUDOPAL   = (1 shl 6);

(**
 * The pixel format has an alpha channel. This is set on all formats that
 * support alpha in some way. The exception is AV_PIX_FMT_PAL8, which can
 * carry alpha as part of the palette. Details are explained in the
 * AVPixelFormat enum, and are also encoded in the corresponding
 * AVPixFmtDescriptor.
 *
 * The alpha is always straight, never pre-multiplied.
 *
 * If a codec or a filter does not support alpha, it should set all alpha to
 * opaque, or use the equivalent pixel formats without alpha component, e.g.
 * AV_PIX_FMT_RGB0 (or AV_PIX_FMT_RGB24 etc.) instead of AV_PIX_FMT_RGBA.
 *)
  AV_PIX_FMT_FLAG_ALPHA       = (1 shl 7);

{$IFDEF FF_API_PIX_FMT}
(**
 * @deprecated use the AV_PIX_FMT_FLAG_* flags
 *)
  PIX_FMT_BE        = AV_PIX_FMT_FLAG_BE;
  PIX_FMT_PAL       = AV_PIX_FMT_FLAG_PAL;
  PIX_FMT_BITSTREAM = AV_PIX_FMT_FLAG_BITSTREAM;
  PIX_FMT_HWACCEL   = AV_PIX_FMT_FLAG_HWACCEL;
  PIX_FMT_PLANAR    = AV_PIX_FMT_FLAG_PLANAR;
  PIX_FMT_RGB       = AV_PIX_FMT_FLAG_RGB;
  PIX_FMT_PSEUDOPAL = AV_PIX_FMT_FLAG_PSEUDOPAL;
  PIX_FMT_ALPHA     = AV_PIX_FMT_FLAG_ALPHA;
{$ENDIF}

{$IFDEF FF_API_PIX_FMT_DESC}
(**
 * The array of all the pixel format descriptors.
 *)
//extern attribute_deprecated const AVPixFmtDescriptor av_pix_fmt_descriptors[];
{$ENDIF}

(**
 * Read a line from an image, and write the values of the
 * pixel format component c to dst.
 *
 * @param data the array containing the pointers to the planes of the image
 * @param linesize the array containing the linesizes of the image
 * @param desc the pixel format descriptor for the image
 * @param x the horizontal coordinate of the first pixel to read
 * @param y the vertical coordinate of the first pixel to read
 * @param w the width of the line to read, that is the number of
 * values to write to dst
 * @param read_pal_component if not zero and the format is a paletted
 * format writes the values corresponding to the palette
 * component c in data[1] to dst, rather than the palette indexes in
 * data[0]. The behavior is undefined if the format is not paletted.
 *)
{ // TODO:
void av_read_image_line(uint16_t *dst, const uint8_t *data[4],
                        const int linesize[4], const AVPixFmtDescriptor *desc,
                        int x, int y, int c, int w, int read_pal_component);
}

(**
 * Write the values from src to the pixel format component c of an
 * image line.
 *
 * @param src array containing the values to write
 * @param data the array containing the pointers to the planes of the
 * image to write into. It is supposed to be zeroed.
 * @param linesize the array containing the linesizes of the image
 * @param desc the pixel format descriptor for the image
 * @param x the horizontal coordinate of the first pixel to write
 * @param y the vertical coordinate of the first pixel to write
 * @param w the width of the line to write, that is the number of
 * values to write to the image line
 *)
{ // TODO:
void av_write_image_line(const uint16_t *src, uint8_t *data[4],
                         const int linesize[4], const AVPixFmtDescriptor *desc,
                         int x, int y, int c, int w);
}

(**
 * Return the pixel format corresponding to name.
 *
 * If there is no pixel format with name name, then looks for a
 * pixel format with the name corresponding to the native endian
 * format of name.
 * For example in a little-endian system, first looks for "gray16",
 * then for "gray16le".
 *
 * Finally if no pixel format has been found, returns AV_PIX_FMT_NONE.
 *)
function av_get_pix_fmt(const name: PAnsiChar): TAVPixelFormat; cdecl; external AVUTIL_LIBNAME name _PU + 'av_get_pix_fmt';

(**
 * Return the short name for a pixel format, NULL in case pix_fmt is
 * unknown.
 *
 * @see av_get_pix_fmt(), av_get_pix_fmt_string()
 *)
function av_get_pix_fmt_name(pix_fmt: TAVPixelFormat): PAnsiChar; cdecl; external AVUTIL_LIBNAME name _PU + 'av_get_pix_fmt_name';

(**
 * Print in buf the string corresponding to the pixel format with
 * number pix_fmt, or a header if pix_fmt is negative.
 *
 * @param buf the buffer where to write the string
 * @param buf_size the size of buf
 * @param pix_fmt the number of the pixel format to print the
 * corresponding info string, or a negative value to print the
 * corresponding header.
 *)
function av_get_pix_fmt_string(buf: PAnsiChar; buf_size: Integer;
                                        pix_fmt: TAVPixelFormat): PAnsiChar; cdecl; external AVUTIL_LIBNAME name _PU + 'av_get_pix_fmt_string';

(**
 * Return the number of bits per pixel used by the pixel format
 * described by pixdesc. Note that this is not the same as the number
 * of bits per sample.
 *
 * The returned number of bits refers to the number of bits actually
 * used for storing the pixel information, that is padding bits are
 * not counted.
 *)
function av_get_bits_per_pixel(const pixdesc: PAVPixFmtDescriptor): Integer; cdecl; external AVUTIL_LIBNAME name _PU + 'av_get_bits_per_pixel';

(**
 * Return the number of bits per pixel for the pixel format
 * described by pixdesc, including any padding or unused bits.
 *)
function av_get_padded_bits_per_pixel(const pixdesc: PAVPixFmtDescriptor): Integer; cdecl; external AVUTIL_LIBNAME name _PU + 'av_get_padded_bits_per_pixel';

(**
 * @return a pixel format descriptor for provided pixel format or NULL if
 * this pixel format is unknown.
 *)
function av_pix_fmt_desc_get(pix_fmt: TAVPixelFormat): PAVPixFmtDescriptor; cdecl; external AVUTIL_LIBNAME name _PU + 'av_pix_fmt_desc_get';

(**
 * Iterate over all pixel format descriptors known to libavutil.
 *
 * @param prev previous descriptor. NULL to get the first descriptor.
 *
 * @return next descriptor or NULL after the last descriptor
 *)
function av_pix_fmt_desc_next(const prev: PAVPixFmtDescriptor): PAVPixFmtDescriptor; cdecl; external AVUTIL_LIBNAME name _PU + 'av_pix_fmt_desc_next';

(**
 * @return an AVPixelFormat id described by desc, or AV_PIX_FMT_NONE if desc
 * is not a valid pointer to a pixel format descriptor.
 *)
function av_pix_fmt_desc_get_id(const desc: PAVPixFmtDescriptor): TAVPixelFormat; cdecl; external AVUTIL_LIBNAME name _PU + 'av_pix_fmt_desc_get_id';

(**
 * Utility function to access log2_chroma_w log2_chroma_h from
 * the pixel format AVPixFmtDescriptor.
 *
 * See av_get_chroma_sub_sample() for a function that asserts a
 * valid pixel format instead of returning an error code.
 * Its recommended that you use avcodec_get_chroma_sub_sample unless
 * you do check the return code!
 *
 * @param[in]  pix_fmt the pixel format
 * @param[out] h_shift store log2_chroma_w
 * @param[out] v_shift store log2_chroma_h
 *
 * @return 0 on success, AVERROR(ENOSYS) on invalid or unknown pixel format
 *)
function av_pix_fmt_get_chroma_sub_sample(pix_fmt: TAVPixelFormat;
                                     h_shift, v_shift: PInteger): Integer; cdecl; external AVUTIL_LIBNAME name _PU + 'av_pix_fmt_get_chroma_sub_sample';

(**
 * @return number of planes in pix_fmt, a negative AVERROR if pix_fmt is not a
 * valid pixel format.
 *)
function av_pix_fmt_count_planes(pix_fmt: TAVPixelFormat): Integer; cdecl; external AVUTIL_LIBNAME name _PU + 'av_pix_fmt_count_planes';

(**
 * Utility function to swap the endianness of a pixel format.
 *
 * @param[in]  pix_fmt the pixel format
 *
 * @return pixel format with swapped endianness if it exists,
 * otherwise AV_PIX_FMT_NONE
 *)
function av_pix_fmt_swap_endianness(pix_fmt: TAVPixelFormat): TAVPixelFormat; cdecl; external AVUTIL_LIBNAME name _PU + 'av_pix_fmt_swap_endianness';

const
  FF_LOSS_RESOLUTION  = $0001; (**< loss due to resolution change *)
  FF_LOSS_DEPTH       = $0002; (**< loss due to color depth change *)
  FF_LOSS_COLORSPACE  = $0004; (**< loss due to color space conversion *)
  FF_LOSS_ALPHA       = $0008; (**< loss of alpha bits *)
  FF_LOSS_COLORQUANT  = $0010; (**< loss due to color quantization *)
  FF_LOSS_CHROMA      = $0020; (**< loss of chroma (e.g. RGB to gray conversion) *)

(**
 * Compute what kind of losses will occur when converting from one specific
 * pixel format to another.
 * When converting from one pixel format to another, information loss may occur.
 * For example, when converting from RGB24 to GRAY, the color information will
 * be lost. Similarly, other losses occur when converting from some formats to
 * other formats. These losses can involve loss of chroma, but also loss of
 * resolution, loss of color depth, loss due to the color space conversion, loss
 * of the alpha bits or loss due to color quantization.
 * av_get_fix_fmt_loss() informs you about the various types of losses
 * which will occur when converting from one pixel format to another.
 *
 * @param[in] dst_pix_fmt destination pixel format
 * @param[in] src_pix_fmt source pixel format
 * @param[in] has_alpha Whether the source pixel format alpha channel is used.
 * @return Combination of flags informing you what kind of losses will occur
 * (maximum loss for an invalid dst_pix_fmt).
 *)
function av_get_pix_fmt_loss(dst_pix_fmt, src_pix_fmt: TAVPixelFormat;
                        has_alpha: Integer): Integer; cdecl; external AVUTIL_LIBNAME name _PU + 'av_get_pix_fmt_loss';

(**
 * Compute what kind of losses will occur when converting from one specific
 * pixel format to another.
 * When converting from one pixel format to another, information loss may occur.
 * For example, when converting from RGB24 to GRAY, the color information will
 * be lost. Similarly, other losses occur when converting from some formats to
 * other formats. These losses can involve loss of chroma, but also loss of
 * resolution, loss of color depth, loss due to the color space conversion, loss
 * of the alpha bits or loss due to color quantization.
 * av_get_fix_fmt_loss() informs you about the various types of losses
 * which will occur when converting from one pixel format to another.
 *
 * @param[in] dst_pix_fmt destination pixel format
 * @param[in] src_pix_fmt source pixel format
 * @param[in] has_alpha Whether the source pixel format alpha channel is used.
 * @return Combination of flags informing you what kind of losses will occur
 * (maximum loss for an invalid dst_pix_fmt).
 *)
function av_find_best_pix_fmt_of_2(dst_pix_fmt1, dst_pix_fmt2, src_pix_fmt: TAVPixelFormat;
                        has_alpha: Integer; loss_ptr: PInteger): TAVPixelFormat; cdecl; external AVUTIL_LIBNAME name _PU + 'av_find_best_pix_fmt_of_2';

(**
 * @return the name for provided color range or NULL if unknown.
 *)
function av_color_range_name(range: TAVColorRange): PAnsiChar; cdecl; external AVUTIL_LIBNAME name _PU + 'av_color_range_name';

(**
 * @return the name for provided color primaries or NULL if unknown.
 *)
function av_color_primaries_name(primaries: TAVColorPrimaries): PAnsiChar; cdecl; external AVUTIL_LIBNAME name _PU + 'av_color_primaries_name';

(**
 * @return the name for provided color transfer or NULL if unknown.
 *)
function av_color_transfer_name(transfer: TAVColorTransferCharacteristic): PAnsiChar; cdecl; external AVUTIL_LIBNAME name _PU + 'av_color_transfer_name';

(**
 * @return the name for provided color space or NULL if unknown.
 *)
function av_color_space_name(space: TAVColorSpace): PAnsiChar; cdecl; external AVUTIL_LIBNAME name _PU + 'av_color_space_name';

(**
 * @return the name for provided chroma location or NULL if unknown.
 *)
function av_chroma_location_name(location: TAVChromaLocation): PAnsiChar; cdecl; external AVUTIL_LIBNAME name _PU + 'av_chroma_location_name';

implementation

end.
