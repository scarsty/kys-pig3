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
using System.Runtime.InteropServices;
using Microsoft.VisualBasic;
namespace sfeadd
{
    public static class Str
    {
        public static string Big5ToUnicode(byte[] big5bytes)
        {
            for (int i = 0; i < big5bytes.Length; i++)
            {
                if (big5bytes[i] == 255) big5bytes[i] = 0;
                if (big5bytes[i] == 0)
                {
                    for (int j = i; j < big5bytes.Length; j++)
                    {
                        big5bytes[j] = 0;
                    }
                    break;
                }
            }
            return System.Text.Encoding.GetEncoding("BIG5").GetString(big5bytes).Replace("\0","");
        }

        public static byte[] UnicodeToBig5(string str, int length)
        {
            //string st = Strings.StrConv(str.Replace(" ", ""), VbStrConv.TraditionalChinese, 0);
            byte[] big5bytes = System.Text.Encoding.GetEncoding("BIG5").GetBytes(str);
            if (length <= 0) return big5bytes;
            else
            {
                byte[] result = new byte[length];
                for (int i = 0; i < Math.Min(big5bytes.Length, length); i++)
                {
                    result[i] = big5bytes[i];
                }
                return result;
            }

        }

        public static byte[] UnicodeToBig5(string str)
        {
            return UnicodeToBig5(str, 0);
        }

        public static string GBKToUnicode(byte[] GBKbytes)
        {
            return System.Text.Encoding.GetEncoding("GBK").GetString(GBKbytes);
        }

        public static byte[] UnicodeToGBK(string str)
        {
            return UnicodeToGBK(str, 0);
        }

        public static byte[] UnicodeToGBK(string str, int length)
        {
            //string st = Strings.StrConv(str.Replace(" ", ""), VbStrConv.TraditionalChinese, 0);
            byte[] GBKbytes = System.Text.Encoding.UTF8.GetBytes(str);
            if (length <= 0) return GBKbytes;
            else
            {
                byte[] result = new byte[length];
                for (int i = 0; i < Math.Min(GBKbytes.Length, length); i++)
                {
                    result[i] = GBKbytes[i];
                }
                return result;
            }

        }

        public static string SimpleToTradition(string str)
        {
            return Strings.StrConv(str.Replace(" ", ""), VbStrConv.TraditionalChinese, 0);
        }

        public static string TraditionToSimple(string str)
        {
            return Strings.StrConv(str.Replace(" ", ""), VbStrConv.SimplifiedChinese, 0);
        }

        public static int GetStringLength(string str)
        {
            string st = Strings.StrConv(str.Replace(" ", ""), VbStrConv.TraditionalChinese, 0);
            byte[] big5bytes = System.Text.Encoding.GetEncoding("BIG5").GetBytes(st);

            int n = 0;
            for (int i = 0; i < big5bytes.Length; i++)
            {
                if (big5bytes[i] > 0) n++;
                else break;
            }
            return n;
        }

    }
}
