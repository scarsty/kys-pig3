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
namespace imzopr
{
    public class luapic
    {
        string idx = null;
        string grp = null;
        public luapic(string fileidx, string filegrp)
        {
            idx = fileidx;
            grp = filegrp;
        }
        public void SaveAllPng(string filepath)
        {
            if (!Directory.Exists(filepath)) Directory.CreateDirectory(filepath);
            List<int> tmpindex = new List<int>();
            using (FileStream fsidx = new FileStream(idx, FileMode.Open))
            {
                using (BinaryReader br = new BinaryReader(fsidx))
                {
                    tmpindex.Add(0);
                    int tmplength = (int)fsidx.Length / 4;
                    for (int i = 0; i < tmplength; i++)
                    {
                        tmpindex.Add(br.ReadInt32());
                    }
                    //while ((tmpindex0 = br.ReadInt32()) != null) ;
                }
            }
            using (FileStream fsgrp = new FileStream(grp, FileMode.Open))
            {
                for (int i = 0; i < tmpindex.Count - 1; i++)
                {
                    using (FileStream fswrite = new FileStream(string.Format(@"./{0}/{1}.png", filepath, i), FileMode.Create))
                    {
                        int length = tmpindex[i + 1] - tmpindex[i];
                        byte[] tmpbyte = new byte[length];
                        fsgrp.Read(tmpbyte, 0, length);
                        fswrite.Write(tmpbyte, 0, length);
                    }
                }
            }
        }
    }
}
