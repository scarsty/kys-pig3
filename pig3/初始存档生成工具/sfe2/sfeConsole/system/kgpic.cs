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
    public class KGPic
    {
        string kgpicfilename = string.Empty;
        public KGPic(string filename)
        {
            kgpicfilename = filename;
        }
        public void toFolder(string flodername)
        {
            if(!Directory.Exists(flodername))Directory.CreateDirectory(flodername);
            using (FileStream fs = new FileStream(kgpicfilename, FileMode.Open))
            {
                using (BinaryReader br = new BinaryReader(fs))
                {
                    int num = br.ReadInt32();
                    List<int> PicIndex = new List<int>();
                    PicIndex.Add(num * 4 + 4);
                    for (int i = 0; i < num; i++)
                        PicIndex.Add(br.ReadInt32());
                    for (int i = 0; i < num; i++)
                    {
                        br.BaseStream.Position = PicIndex[i] + 12;
                        FileStream fout = new FileStream(string.Format(@"./{0}/{1}.png", flodername,i), FileMode.Create);
                        byte[] tmpbyte = new byte[PicIndex[i + 1 ] - PicIndex[i]];
                        fs.Read(tmpbyte, 0, tmpbyte.Length);
                        fout.Write(tmpbyte, 0, tmpbyte.Length);
                        fout.Close();
                        Console.WriteLine("{0}/{1}", i, num);
                    }
                }
            }
        }
    }
}
