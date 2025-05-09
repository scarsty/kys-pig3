/********************************************************************
  this is a part of sfe2
  Created by MythKAst
  ©2013 MythKAst Some rights reserved.


  You can build it with vs2010,mono
  Anybody who gets this source code is able to modify or rebuild it anyway,
  but please keep this section when you want to spread a new version.
  It's strongly not recommended to change the original copyright. Adding new version
  information, however, is Allowed. Thanks.
  For the latest version, please be sure to check my website:
  https://code.google.com/p/sfe2


  你可以用vs2010,mono编译这些代码
  任何得到此代码的人都可以修改或者重新编译这段代码，但是请保留这段文字。
  请不要修改原始版权，但是可以添加新的版本信息。
  最新版本请留意：https://code.google.com/p/sfe2

 MythKAst(asdic182@sina.com), in 2013 June.
*********************************************************************/
using System;
using System.Collections.Generic;
using System.Text;
using ICSharpCode.SharpZipLib;
using ICSharpCode.SharpZipLib.Zip;
using System.IO;

namespace ConsoleImz
{
    public class zipopr
    {
        public class ZipFileOpr
        {
            public Dictionary<string, Stream> ZipDictionary = null;
            public ZipFileOpr()
            {
                ZipDictionary = new Dictionary<string, Stream>();
            }
        }
        string filepath = string.Empty;
        public zipopr(string path)
        {
            filepath = path;
        }
        public zipopr()
        {
        }
        /// <summary>
        /// 解压所有的文件
        /// </summary>
        /// <returns></returns>
        public ZipFileOpr ZiptoFiles()
        {
            ZipInputStream s = new ZipInputStream(new FileStream(filepath, FileMode.Open));
            ZipEntry fileEntry;

            ZipFileOpr tmpzip = new ZipFileOpr();
            while ((fileEntry = s.GetNextEntry()) != null)
            {
                MemoryStream tmpstream = new MemoryStream();
                int size = (int)fileEntry.Size;
                byte[] buffer = new byte[size];
                size = s.Read(buffer, 0, size);
                tmpstream.Write(buffer, 0, size);
                tmpzip.ZipDictionary.Add(Path.GetFileName(fileEntry.Name), tmpstream);
            }
            s.Close();
            return tmpzip;
        }
        /// <summary>
        /// 替换文件名
        /// </summary>
        /// <param name="BaseOpr"></param>
        /// <param name="filename"></param>
        /// <param name="stream"></param>
        /// <returns></returns>
        public ZipFileOpr ReplaceFiles(ZipFileOpr BaseOpr,string filename, Stream stream)
        {
            string filenameLower = filename;
            if (BaseOpr.ZipDictionary.ContainsKey(filenameLower))
            {
                BaseOpr.ZipDictionary.Remove(filenameLower);
                BaseOpr.ZipDictionary.Add(filenameLower, stream);
            }
            return BaseOpr;
        }
        public Stream FilesToZip(ZipFileOpr BaseOpr)
        {
            MemoryStream stream = new MemoryStream();
            ZipOutputStream s = new ZipOutputStream(stream);
            s.UseZip64 = UseZip64.Off;
            foreach (KeyValuePair<string, Stream> item in BaseOpr.ZipDictionary)
            {
                s.SetLevel(-1);//设置压缩等级
                ZipEntry fileEntry = new ZipEntry(item.Key);
                //fileEntry.Name = item.Key;
                Stream zipstream = item.Value;
                fileEntry.DateTime = DateTime.Now;
                s.PutNextEntry(fileEntry);
                s.Write(((MemoryStream)zipstream).ToArray(), 0, (int)zipstream.Length);
            }
            s.CloseEntry();
            s.Finish();
            s.Close();
            return stream;
        }
        public Stream ZipToFile(string Ifilename)
        {
            ZipInputStream s = new ZipInputStream(new FileStream(filepath, FileMode.Open));
            ZipEntry fileEntry;
            MemoryStream streamWriter = null;

            while ((fileEntry = s.GetNextEntry()) != null)
            {
                string filename = Path.GetFileName(fileEntry.Name);
                if (filename != "" && filename.ToLower().Equals(Ifilename.ToLower()))
                {
                    //filename = addres + "\\" + filename;
                    streamWriter = new MemoryStream();
                    int size = (int)fileEntry.Size;
                    byte[] buffer = new byte[size];
                    size = s.Read(buffer, 0, size);
                    streamWriter.Write(buffer, 0, size);
                    //streamWriter.Close();
                    break;
                }
            }
            //s.CloseEntry();
            s.Close();
            if (streamWriter != null)
                streamWriter.Position = 0;
            return streamWriter;
        }
    }
}
