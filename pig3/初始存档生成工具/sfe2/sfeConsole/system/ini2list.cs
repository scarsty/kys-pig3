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
using sfeadd;
namespace imzopr.rdata
{
    public static class inilist
    {
        public struct R_modify
        {
            public string typeName;
            public List<R_dataType> ListR;
        }
        /*
         ; 数组个数，
         * 数组结构成员个数，
         * 字节数，
         * 是否字串，
         * 是否名称，
         * 引用数据类型,
         * 名字，
         * 说明
      ; 间隔使用空格，一定要注意字符串中间不能有空格，而且空格只能有一个，等号后面不能有空格。
         */
        public struct R_dataType
        {
            public int intDataNum
            {
                get
                {
                    return int.Parse(dataNum);
                }
            }
            public int intDataStructNum
            {
                get
                {
                    return int.Parse(dataStructNum);
                }
            }
            public int intbyteNum
            {
                get
                {
                    return int.Parse(byteNum);
                }
            } 
            /// <summary>
            /// 数组个数
            /// </summary>
            public string dataNum;
            /// <summary>
            /// 数组成员个数
            /// </summary>
            public string dataStructNum;
            /// <summary>
            /// 字节数
            /// </summary>
            public string byteNum;
            /// <summary>
            /// 是否字符串
            /// </summary>
            public string isString;
            /// <summary>
            /// 是否名称
            /// </summary>
            public string isName;
            /// <summary>
            /// 引用数据类型
            /// </summary>
            public string dataType;
            /// <summary>
            /// 名字
            /// </summary>
            public string nameStr;
            /// <summary>
            /// 说明
            /// </summary>
            public string DescriptionStr;
        }
        public static R_dataType RdatatypeInital()
        {
            //rtmp.byteNum = "0";
            R_dataType Rtmp = new R_dataType();
            Rtmp.dataNum = "1";
            Rtmp.dataStructNum = "1";
            Rtmp.byteNum = "2";
            Rtmp.isString = "0";
            Rtmp.isName = "0";
            Rtmp.dataType = "-1";
            Rtmp.nameStr = "新建项目";
            Rtmp.DescriptionStr = "双击输入详细内容";
            return Rtmp;
        }
        public static List<R_modify> RiniInital()
        {
            List<R_modify> rini = new List<R_modify>();
            R_modify rmodtmp = new R_modify();
            rmodtmp.typeName = "新建类型";
            rmodtmp.ListR = new List<R_dataType>();
            R_dataType rdatatmp = RdatatypeInital();
            rmodtmp.ListR.Add(rdatatmp);
            rini.Add(rmodtmp);
            return rini;
        }
        public static List<R_modify> ini2list(string inifilename)
        {
            try
            {
                inireader sfeini = new inireader(inifilename);
                int TypeNumber = sfeini.ReadIniInt("R_Modify", "TypeNumber");
                List<R_modify> R_ini = new List<R_modify>();
                for (int num = 0; num < TypeNumber; num++)
                {
                    R_modify Rmtmp = new R_modify();
                    Rmtmp.typeName = sfeini.ReadIniString("R_Modify", "TypeName" + num.ToString());
                    Rmtmp.ListR = new List<R_dataType>();
                    int TypeDataItem = sfeini.ReadIniInt("R_Modify", "TypeDataItem" + num.ToString());
                    for (int i = 0; i < TypeDataItem; i++)
                    {
                        string tmpstr = sfeini.ReadIniString("R_Modify", string.Format("data({0},{1})", num, i));
                        string[] splitstr = tmpstr.Split(' ');
                        R_dataType Rtmp = new R_dataType();
                        //煞笔般的分割导入
                        Rtmp.dataNum = splitstr[0].ToString();
                        Rtmp.dataStructNum = splitstr[1].ToString();
                        Rtmp.byteNum = splitstr[2].ToString();
                        Rtmp.isString = splitstr[3].ToString();
                        Rtmp.isName = splitstr[4].ToString();
                        Rtmp.dataType = splitstr[5].ToString();
                        Rtmp.nameStr = splitstr[6].ToString();
                        Rtmp.DescriptionStr = splitstr[7].ToString();
                        Rmtmp.ListR.Add(Rtmp);
                    }
                    R_ini.Add(Rmtmp);
                }
                
                return R_ini;
            }
            catch(Exception ee)
            {
                return null;
            }
        }
        public static void createR(List<R_modify> rini,string filename,string fileidx)
        {
            using (FileStream fgrp = new FileStream(filename, FileMode.Create))
            {
                using (FileStream fidx = new FileStream(fileidx, FileMode.Create))
                {
                    using (BinaryWriter bwgrp = new BinaryWriter(fgrp))
                    {
                        using (BinaryWriter bwidx = new BinaryWriter(fidx))
                        {
                            //calc rini
                            int[] Rlong = new int[rini.Count];
                            int Rindex = 0;
                            for (int i = 0; i < rini.Count; i++)
                            {
                                for (int j = 0; j < rini[i].ListR.Count; j++)
                                {
                                    Rlong[i] += int.Parse(rini[i].ListR[j].dataNum) *
                                                int.Parse(rini[i].ListR[j].dataStructNum) *
                                                int.Parse(rini[i].ListR[j].byteNum);
                                }
                                Rindex += Rlong[i];
                                bwidx.Write(Rindex);
                                byte[] tmpbuffer = new byte[Rlong[i]];
                                bwgrp.Write(tmpbuffer);
                            }
                            
                        }
                    }
                }
            }
        }
    }
}
