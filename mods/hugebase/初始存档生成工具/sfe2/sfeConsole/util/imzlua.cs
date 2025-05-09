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
using System.IO;
namespace sfeConsole.util
{
    public class imzlua
    {
        private string imzluadir = string.Empty;
        List<byte[]> mylua = new List<byte[]>();
        public imzlua(string dir)
        {
            imzluadir = dir;
        }
        public void save(string filename)
        {
            if (imzluadir == string.Empty)
                return;
            string[] files = Directory.GetFiles(imzluadir);
            FileStream fs = new FileStream(filename, FileMode.Create);
            for (int i = 0; i < files.Length; i++)
            {
                FileStream tmpfs = new FileStream(string.Format(@"{0}\ka{1}.lua", imzluadir,i), FileMode.Open);
                byte[] tmpbyte = new byte[tmpfs.Length];
                tmpfs.Read(tmpbyte, 0, tmpbyte.Length);
                mylua.Add(tmpbyte);
                tmpfs.Close();
            }
            BinaryWriter bw = new BinaryWriter(fs);
            int tmplength = (files.Length + 1) * 4;
            bw.Write(files.Length);
            for (int i = 0; i < files.Length; i++)
            {
                bw.Write(tmplength);
                tmplength += mylua[i].Length + 8;
            }
            for (int i = 0; i < files.Length; i++)
            {
                bw.Write((short)0);
                bw.Write((short)0);
                bw.Write((int)1);
                fs.Write(mylua[i], 0, mylua[i].Length);
            }
        }
    }
}
