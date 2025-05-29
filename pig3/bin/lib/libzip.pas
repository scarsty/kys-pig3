(*
 * Copyright (c) 2023 XXIV
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in all
 * copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
 * SOFTWARE.
 *)
unit libzip;

{$ifdef fpc}
{$packrecords c}
{$endif}

interface

uses ctypes, SysUtils;

type
  zip_t = record
  end;
  Pzip_t = ^zip_t;

  zip_file_t = record
  end;
  Pzip_file_t = ^zip_file_t;

  zip_source_t  = record
  end;
      Pzip_source_t = ^zip_source_t;

  Zip_Stat_t = record
    valid: uint64;                // which fields have valid values
    Name: pchar;                  // name of the file
    index: uint64;                // index within archive
    size: uint64;                 // size of file (uncompressed)
    comp_size: uint64;            // size of file (compressed)
    mtime: TDateTime;             // modification time
    crc: cardinal;                // crc of file data
    comp_method: word;            // compression method used
    encryption_method: word;      // encryption method used
    flags: cardinal;              // reserved for future use
  end;

const
  zipdll = 'zip.dll';

  ZIP_CREATE = 1;
  ZIP_TRUNCATE = 8;
  ZIP_RDONLY = 16;

  ZIP_FL_UNCHANGED = 8;

function zip_open(zipname: pchar; level: integer = ZIP_RDONLY; plevel: pinteger = nil): Pzip_t; cdecl; external zipdll;
function zip_close(_Nonnull: pzip_t): integer; cdecl; external zipdll;
procedure zip_stat_init(var _Nonnull: zip_stat_t); cdecl; external zipdll;
function zip_stat(z: pzip_t; const Name: pchar; flags: integer; var st: zip_stat_t): integer; cdecl; external zipdll;
function zip_fopen(zip: Pzip_t; entryname: pchar; f: integer = ZIP_FL_UNCHANGED): pzip_file_t; cdecl; external zipdll;
function zip_fread(zip_file: pzip_file_t; buf: Pointer; len: uint64): integer; cdecl; external zipdll;
function zip_fclose(_Nonnull: pzip_file_t): integer; cdecl; external zipdll;

function zip_source_buffer(_Nonnull:pzip_t; const _Nullable:Pointer; len:uint64; needfree:integer=0): pzip_source_t; cdecl; external zipdll;
function zip_source_close(_Nonnull: pzip_source_t): integer; cdecl; external zipdll;

function zip_file_add(archive:pzip_t; const name:pchar; source:pzip_source_t; flags:integer): uint64; cdecl; external zipdll;

function zip_set_file_compression(zip: Pzip_t; index: uint64; comp_method: word; comp_flags: cardinal): integer; cdecl; external zipdll;

function zip_getsize(zip: Pzip_t; filename: pchar): longint;
function zip_express(zip: Pzip_t; filename: utf8string): ansistring; overload;
function zip_express(zip: Pzip_t; filename: utf8string; p: pointer; size: integer): integer; overload;
function zip_compress(zip: Pzip_t; filename: utf8string; p: pointer; size: integer): integer; overload;

implementation

function zip_getsize(zip: Pzip_t; filename: pchar): longint;
var
  zs: Zip_Stat_t;
begin
  zip_stat_init(zs);
  if zip_stat(zip, filename, ZIP_FL_UNCHANGED, zs) = 0 then
    Result := zs.size
  else
    Result := 0; // or some error handling
end;

function zip_express(zip: Pzip_t; filename: utf8string): ansistring; overload;
var
  zip_file: pzip_file_t;
  l, bytes_read: integer;
  zs: Zip_Stat_t;
begin
  Result := '';
  zip_file := zip_fopen(zip, @filename[1], ZIP_FL_UNCHANGED);
  if zip_file = nil then
    Exit(); // error opening file
  try
    zip_stat_init(zs);
    if zip_stat(zip, PChar(filename), ZIP_FL_UNCHANGED, zs) <> 0 then
      Exit();
    // Read the file into the buffer
    l := zs.size;
    SetLength(Result, l);
    bytes_read := zip_fread(zip_file, @Result[1], l);
    if bytes_read < 0 then
      Exit(); // error reading file
    //Result := bytes_read; // return number of bytes read
  finally
    zip_fclose(zip_file);
  end;
end;

function zip_express(zip: Pzip_t; filename: utf8string; p: pointer; size: integer): integer; overload;
var
  zip_file: pzip_file_t;
  bytes_read: integer;
  zs: Zip_Stat_t;
begin
  zip_file := zip_fopen(zip, @filename[1], ZIP_FL_UNCHANGED);
  if zip_file = nil then
    Exit(-1); // error opening file
  try
    zip_stat_init(zs);
    if zip_stat(zip, PChar(filename), ZIP_FL_UNCHANGED, zs) <> 0 then
      Exit(-1);
    // Read the file into the buffer
    bytes_read := zip_fread(zip_file, p, size);
    if bytes_read < 0 then
      Exit(-1); // error reading file
    Result := bytes_read; // return number of bytes read
  finally
    zip_fclose(zip_file);
  end;
end;

function zip_compress(zip: Pzip_t; filename: utf8string; p: pointer; size: integer): integer; overload;
var
  source: pzip_source_t;
  index: uint64;
begin
  source := zip_source_buffer(zip, p, size, 0);
  if source = nil then
    Exit(-1); // error creating source
  index := zip_file_add(zip, @filename[1], source, 8192);
  zip_set_file_compression(zip, index, 1, 10); // set compression method to deflate
  if index = uint64(-1) then
  begin
    zip_source_close(source); // free the source if adding failed
    Exit(-1); // error adding file
  end;
  Result := integer(index); // return the index of the added file
end;


end.
