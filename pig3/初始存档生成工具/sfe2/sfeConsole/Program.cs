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
using imzopr;
using imzopr.rdata;
using System.Runtime.InteropServices;
using System.Reflection;
using imzopr.Drawing;
using System.Diagnostics;
namespace ConsoleImz
{
    public class Program
    {
        static Dictionary<string, string> argsAll = new Dictionary<string, string>();
        static bool IsExit;
        static void InitalAllArgs()
        {
            argsAll.Add("-rlew", "convert rle pic to floder\r\n        -rlew fileidx filegrp Filepath");
            argsAll.Add("-imzw", "Package floder to imz file\r\n        -imzw filePath file.imz");
            argsAll.Add("-imzr", "Unpackage imz file to floder\r\n        -imzr file.imz filePath");
            argsAll.Add("-indexw", "Convert xls file to index.ka\r\n        -indexw file.xls filepath");
            argsAll.Add("-indexr", "Convert index.ka to xls\r\n        -indexr FilePath file.xls ");
            argsAll.Add("-fightw", "Convert xls to fightframe.ka\r\n        -fightw file.xls fightframe.ka ");
            argsAll.Add("-fightr", "Convert fightframe.ka to xls\r\n        -fightr fightframe.ka file.xls ");
            argsAll.Add("-rangerw", "Convert xls to ranger.grp\r\n        -rangerw -zip/-auto -gbk/-big5 file.xls ranger.grp [ranger.idx]");
            argsAll.Add("-rangerr", "Convert ranger.grp to xls\r\n        -rangerr -zip/-auto -pig3/-promise/-basic/-auto -file.bt/-file.grp file.idx file.xls ");
            argsAll.Add("-gif2png", "Convert gif to png floder\r\n        -gif2png 1.gif pnglist 3501 ");
            argsAll.Add("-luar", " convert luapic file to floder\r\n        -luar fileidx filegrp Filepath");
            argsAll.Add("-picr", " convert pic file to floder\r\n        -picr 1.pic head");
            argsAll.Add("-kalua", " convert lua floder to imz\r\n        -kalua floder kdef.imz");
            argsAll.Add("-kgpicr", " convertkg pic file to floder\r\n        -picr 1.pic pic1");
        }


        static void analyzecommand(string[] args)
        {
            if (args[0].Length < 1) return;
            //if (args[0].Equals("exit")) { exit(args); return; }
            MethodInfo method = typeof(Program).GetMethod(args[0].Substring(1));
            if (method != null)
            {
                try
                {
                    int time0 = Environment.TickCount;
                    method.Invoke(null, new object[] { args });
                    GC.Collect();
                    Console.WriteLine(string.Format("AllOk:{0}ms", Environment.TickCount - time0));
                }
                catch (Exception ee)
                {
                    Console.WriteLine("error command :" + ee.Source.ToString());
                }
            }
            else
            {
                method = typeof(Program).GetMethod(args[0]);
                if (method != null)
                {
                    try
                    {
                        method.Invoke(null, new object[] { args });
                        GC.Collect();
                    }
                    catch (Exception ee)
                    {
                        Console.WriteLine("error command :" + ee.Source.ToString());
                    }
                }
                else
                {
                    //Console.WriteLine(getcmd(args));
                    Console.WriteLine("unkown command :" + args[0]);
                }
            }
        }

        static void Main(string[] args)
        {
            mydir = Environment.CurrentDirectory + @"\";
            IsExit = false;
            AppDomain.CurrentDomain.AssemblyResolve += CurrentDomain_AssemblyResolve;
            InitalAllArgs();
            if (args.Length > 1)
            {
                analyzecommand(args);
            }
            else
            {
                Console.WriteLine("sfeConsole -readme\r\n----------------MythKAst--------");
                foreach (KeyValuePair<string, string> item in argsAll)
                {
                    Console.Write(item.Key.PadRight(8));
                    Console.Write(" ");
                    Console.WriteLine(item.Value);
                    //Console.WriteLine("\r\n");
                }
                string analyzestr = string.Empty;
                do
                {
                    Console.Write("sfeConsole-" + mydir + ">");
                    analyzestr = Console.ReadLine();
                    string[] tmpstr = analyzestr.Split(' ');
                    //if(tmpstr.Length > 0)
                        analyzecommand(analyzestr.Split(' '));
                } while (!IsExit);
            }
        }

        private static Assembly CurrentDomain_AssemblyResolve(object sender, ResolveEventArgs args)
        {

            Assembly asm = Assembly.GetExecutingAssembly();
            string name = asm.GetName().Name;
            string resourceName = name + "." + new AssemblyName(args.Name).Name + ".dll";
            using (var stream = Assembly.GetExecutingAssembly().GetManifestResourceStream(resourceName))
            {
                byte[] assemblyData = new byte[stream.Length];
                stream.Read(assemblyData, 0, assemblyData.Length);
                return Assembly.Load(assemblyData);
            }
        }
        public static string mydir = string.Empty;
        #region static
        
        public static void pwd(string[] args)
        {
            Console.WriteLine(mydir);
        }

        public static void cd(string[] args)
        {
            if (args.Length > 1)
            {
                DirectoryInfo dir = new DirectoryInfo(mydir + args[1]);
                mydir = dir.FullName.ToString();
                //dir += args[1];
            }
            else
            {
                mydir = Environment.CurrentDirectory + @"\";
            }
        }

        public static void ls(string[] args)
        {
            foreach (string tmpdir in Directory.GetDirectories(mydir))
            {
                Console.WriteLine(tmpdir.Replace(mydir,"") + @"\");
            }
            foreach (string tmpfile in Directory.GetFiles(mydir))
            {
                Console.WriteLine(tmpfile.Replace(mydir, ""));
            }

        }

        public static void exit(string[] args)
        {
            Console.WriteLine("ready to exit");
            IsExit = true;
        }
        public static void fightw(string[] args)
        {

            imzopr.imzopr imz = new imzopr.imzopr("");
            imz.ConvertKaFightFromXls(args[1], args[2]);
        }

        public static void fightr(string[] args)
        {

            imzopr.imzopr imz = new imzopr.imzopr("");
            imz.ConvertKaFightToXls(args[1], args[2]);
        }

        public static void indexw(string[] args)
        {

            imzopr.imzopr imz = new imzopr.imzopr("");
            imz.ConvertKaIndexFromXls(args[1], args[2]);
        }

        public static void indexr(string[] args)
        {

            imzopr.imzopr imz = new imzopr.imzopr("");
            imz.ConvertKaIndexToXls(args[1], args[2]);
        }

        public static void imzr(string[] args)
        {
            imzopr.imzopr imz = new imzopr.imzopr(args[1]);
            imz.Unpackage(args[1], args[2]);
        }
        public static void kgpicr(string[] args)
        {
            imzopr.imzopr imz = new imzopr.imzopr(args[1]);
            imz.UnpackagePic(args[1], args[2]);
        }
        public static void rlew(string[] args)
        {
            imzopr.RleOpr rle = new RleOpr(args[1], args[2], false);
            rle.saveAllPng(args[3]);
        }

        public static void imzw(string[] args)
        {
            imzopr.imzopr imz = new imzopr.imzopr(args[1]);
            imz.package(args[2]);
        }

        public static void rangerr(string[] args)
        {
            Stream stream = null;
            switch (args[1])
            {
                case "-zip":
                    zipopr zip = new zipopr(args[3]);
                    stream = zip.ZipToFile("ranger.grp");
                    if (stream == null)
                        stream = zip.ZipToFile("r.grp");
                    if (stream == null)
                    {
                        for (int i = 1; i < 11; i++)
                        {
                            stream = zip.ZipToFile(string.Format("r{0}.grp", i));
                            if (stream != null) break;
                        }
                    }
                    break;
                case "-auto":
                    stream = new FileStream(args[3],FileMode.Open);
                    break;
                default:
                    return;
            }
            Rcore.SaveRToXls(stream,args[4], args[2].Substring(1),args[5]);
        }

        public static void rangerw(string[] args)
        {
            object[][][] tmpdata = Rcore.FromXls(args[3]);
            if (tmpdata != null)
            {
                Rcore.stringCodeType stringcode = Rcore.stringCodeType.BIG5;
                if (args[2].ToLower() == "-gbk") stringcode = Rcore.stringCodeType.GBK;
                Rcore.RsaveType rsavetype = Rcore.saveRanger(tmpdata, stringcode);
                MemoryStream stream = (MemoryStream)(rsavetype.RsaveStream); 
                if (args.Length > 5)
                {
                    int tmplength = 0;
                    using (FileStream fsIndex = new FileStream(args[5], FileMode.Create))
                    {
                        using (BinaryWriter bw = new BinaryWriter(fsIndex))
                        {
                            foreach (int index in rsavetype.Rindex)
                            {
                                tmplength += index;
                                bw.Write(tmplength);
                            }
                        }
                    }

                }
                switch (args[1])
                {
                    case "-zip":
                        zipopr zip = new zipopr(args[4]);
                        zipopr.ZipFileOpr zipfile = zip.ZiptoFiles();
                        zipfile = zip.ReplaceFiles(zipfile, "Ranger.grp", rsavetype.RsaveStream);
                        zipfile = zip.ReplaceFiles(zipfile, "r1.grp", rsavetype.RsaveStream);
                        zipfile = zip.ReplaceFiles(zipfile, "r.grp", rsavetype.RsaveStream);
                        MemoryStream zipstream = (MemoryStream)zip.FilesToZip(zipfile);
                        File.WriteAllBytes(args[4], zipstream.ToArray());
                        break;
                    case "-auto":
                        FileStream fs = new FileStream(args[4], FileMode.Create);
                        fs.Write(stream.ToArray(),0,(int)stream.Length);
                        fs.Close();
                        break;
                }
                
            }
            //imzopr.imzopr imz = new imzopr.imzopr(args[1]);
            //imz.package(args[2]);
        }

        public static void gif2png(string[] args)
        {
            imzopr.Drawing.KGGif kggif = new KGGif(args[1]);
            kggif.SaveAsPngToFolder(args[2], int.Parse(args[3]));
            kggif.Dispose();
        }
        public static void picr(string[] args)
        {
            imzopr.KGPic kgpic = new KGPic(args[1]);
            kgpic.toFolder(args[2]);
        }
        public static void luar(string[] args)
        {
            imzopr.luapic luapic = new luapic(args[1], args[2]);
            luapic.SaveAllPng(args[3]);
        }
        public static void kalua(string[] args)
        {
            sfeConsole.util.imzlua imzlua = new sfeConsole.util.imzlua(args[1]);
            imzlua.save(args[2]);
            //imzopr.luapic luapic = new luapic(args[1], args[2]);
            //luapic.SaveAllPng(args[3]);
        }
        #endregion
    }
}
