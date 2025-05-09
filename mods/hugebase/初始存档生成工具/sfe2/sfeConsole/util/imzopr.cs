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
using System.Drawing;
using System.Drawing.Imaging;
using System.Runtime.InteropServices;
using WinRect = System.Drawing.Rectangle;
using System.Reflection;//要記得using
using NPOI;
using NPOI.HSSF.UserModel;
using NPOI.HPSF;
using NPOI.POIFS.FileSystem;
using NPOI.SS.UserModel;

namespace imzopr
{
    public class AsmResource
    {
        /// <summary>
        /// 从资源库内读取资源进入流
        /// </summary>
        /// <param name="filename">内部代号</param>
        /// <returns>流</returns>
        public Stream ReadStreamFromAssembly(string filename)
        {
            Assembly asm = Assembly.GetExecutingAssembly();
            string name = asm.GetName().Name;
            return asm.GetManifestResourceStream(name + ".resources." + filename);//載入圖片資源
        }
    }
    public class RleOpr:AsmResource
    {
        public class RGBtype
        {
            public byte bb;
            public byte gg;
            public byte rr;
            public byte aa;
            public int ARGB;
        }
        /// 读取调色板
        /// </summary>
        /// <param name="filename">文件名称</param>
        /// <returns>返回调色板值</returns>
        public RGBtype[,] LoadColor()
        {
            RGBtype[,] m_color_RGB = null;
            using (Stream fs = ReadStreamFromAssembly("Mmap.col"))
            {
                int colcnt = (int)(fs.Length / (256 * 3));
                m_color_RGB = new RGBtype[colcnt, 256];
                using (BinaryReader br = new BinaryReader(fs))
                {
                    for (int k = 0; k < colcnt; k++)
                    {
                        for (int i = 0; i < 256; i++)
                        {
                            RGBtype tmprgb = new RGBtype();
                            tmprgb.rr = (byte)(br.ReadByte() * 4);
                            tmprgb.gg = (byte)(br.ReadByte() * 4);
                            tmprgb.bb = (byte)(br.ReadByte() * 4);
                            tmprgb.aa = 0xff;
                            tmprgb.ARGB = Color.FromArgb(tmprgb.aa, tmprgb.rr, tmprgb.gg, tmprgb.bb).ToArgb();
                            m_color_RGB[k, i] = tmprgb;
                        }
                    }
                }
            }
            return m_color_RGB;
        }
        public RGBtype[,] JYcolor;// = new RGBtype[768];   
        public RlePic[] tmprle;
        /// <summary>
        /// 读取smap,RLEPIC等等
        /// </summary>
        /// <param name="fileId"></param>
        /// <param name="filePic"></param>
        /// <returns></returns>
        public RlePic[] LoadRlePic(string fileId, string filePic, bool isSmp)
        {
            long MapPicNum = 0; int[] mappidx;
            List<RlePic> tmpLst = new List<RlePic>();
            using (FileStream fs = new FileStream(fileId, FileMode.Open))
            {
                using (BinaryReader br = new BinaryReader(fs))
                {
                    MapPicNum = fs.Length / 4;
                    mappidx = new int[MapPicNum];
                    for (int i = 0; i < MapPicNum; i++)
                        mappidx[i] = br.ReadInt32();
                }
            }
            using (FileStream fs = new FileStream(filePic, FileMode.Open))
            {
                using (BinaryReader br = new BinaryReader(fs))
                {
                    int piclong = 0;
                    RlePic tmpRle = new RlePic();
                    for (int i = 0; i < MapPicNum; i++)
                    {
                        //offset = mappidx[i];
                        //fs.Seek(offset, SeekOrigin.Begin);
                        if (i == 0)
                            piclong = mappidx[0];
                        else
                            piclong = mappidx[i] - mappidx[i - 1];

                        if (piclong > 0)
                        {
                            tmpRle = new RlePic();
                            //br.ReadByte();
                            tmpRle.width = br.ReadInt16();
                            tmpRle.Height = br.ReadInt16();
                            tmpRle.x = br.ReadInt16();
                            tmpRle.y = br.ReadInt16();
                            tmpRle.datalong = piclong - 8;
                            tmpRle.data = br.ReadBytes(tmpRle.datalong);
                            tmpLst.Add(tmpRle);
                            // br.ReadByte();
                        }
                        else
                        {
                            tmpRle = new RlePic();
                            //br.ReadByte();
                            tmpRle.width = 0;
                            tmpRle.Height = 0;
                            tmpRle.x = 0;
                            tmpRle.y = 0;
                            tmpRle.datalong = 0;
                            tmpRle.data = new byte[0];
                            tmpLst.Add(tmpRle);
                        }
                    }
                    if (isSmp)
                    {
                        //杀掉0号数据
                        tmpRle = new RlePic();
                        //br.ReadByte();
                        tmpRle.width = 0;
                        tmpRle.Height = 0;
                        tmpRle.x = 0;
                        tmpRle.y = 0;
                        tmpRle.datalong = 0;
                        tmpRle.data = new byte[0];
                        tmpLst[0] = tmpRle;
                    }
                }

            }
            return tmpLst.ToArray();
        }
        public RleOpr(string fileid, string filepic, bool issmp)
        {
            JYcolor = LoadColor();
            tmprle = LoadRlePic(fileid, filepic, issmp);
        }
        public void saveAllPng(string filepath)
        {
            if(!Directory.Exists(filepath))
                Directory.CreateDirectory(filepath);
            Bitmap bitmap;
            using (FileStream indexfs = new FileStream(string.Format(@"./{0}/index.ka",filepath), FileMode.Create))
            {
                using(BinaryWriter br = new BinaryWriter(indexfs))
                {
                    for (int i = 0; i < tmprle.Length; i++)
                    {
                        int area = tmprle[i].Height * tmprle[i].width;
                        //PNG inside grp
                        if (tmprle[i].width > 512)
                        {
                            short a, b;
                            a = (short)(tmprle[i].data[11] + tmprle[i].data[10] * 256);
                            a /= 2;
                            br.Write(a);
                            b = (short)(tmprle[i].data[15] + tmprle[i].data[14] * 256);
                            b /= 2;
                            br.Write(b);
                            FileStream ppp = new FileStream(string.Format(@"./{0}/{1}.png", filepath, i), FileMode.Create);
                            BinaryWriter pppp = new BinaryWriter(ppp);
                            pppp.Write(tmprle[i].width);
                            pppp.Write(tmprle[i].Height);
                            pppp.Write(tmprle[i].x);
                            pppp.Write(tmprle[i].y);
                            pppp.Write(tmprle[i].data, 0, tmprle[i].datalong);
                            continue;
                        }
                        br.Write(tmprle[i].x);
                        br.Write(tmprle[i].y);
                        if (area > 1)
                        {
                            bool isShape = false;
                            for (int j = 0; j < 8; j++)
                            {
                                bitmap = tmprle[i].toPic(j, out isShape, JYcolor);
                                if (isShape)
                                {
                                    using (FileStream fs = new FileStream(string.Format(@"./{0}/{1}_{2}.png", filepath, i, j), FileMode.Create))
                                    {
                                        bitmap.Save(fs, ImageFormat.Png);
                                        bitmap.Dispose();
                                        fs.Close();
                                    }

                                }
                                else
                                {
                                    string tmpstr = string.Format(@"./{0}/{1}_{2}.png", filepath, i, j);
                                    if(j == 0)
                                    {
                                        tmpstr = string.Format(@"./{0}/{1}.png", filepath, i);
                                    }
                                    using (FileStream fs = new FileStream(tmpstr, FileMode.Create))
                                    {
                                        bitmap.Save(fs, ImageFormat.Png);
                                        bitmap.Dispose();
                                        fs.Close();
                                    }
                                    if(j == 0)
                                        break;
                                }
                            }
                        }
                    }
                }
            }
        }
    }
    public class RlePic
    {
        public RlePic()
        {
        }
        public short width;
        public short Height;
        public short x;
        public short y;
        public int datalong;
        public byte[] data;
        public MemoryStream toPng(int RollInt, out bool IsShape, RleOpr.RGBtype[,] JYcolor)
        {
            MemoryStream tmpmem = new MemoryStream();
            Bitmap bitmap = toPic(RollInt,out IsShape,JYcolor);
            bitmap.Save(tmpmem, ImageFormat.Png);
            bitmap.Dispose();
            return tmpmem;
        }
        public Bitmap toPic(int RollInt, out bool IsShape, RleOpr.RGBtype[,] JYcolor)
        {
            int[] s = new int[width * Height];
            Bitmap Img = new Bitmap(width, Height);
            #region decode
            int i = 0;
            byte PicWidth;
            int piclong, masklong;
            int Px = 0; int Py = 0;
            int dx = Px;
            IsShape = false;
            while (i < datalong)
            {
                PicWidth = data[i];
                i++;
                piclong = PicWidth + i;
                while (i < piclong)
                {
                    //Console.WriteLine(i);
                    //if (i == 1032)
                    //{
                    //    i = i;
                    //}
                    Px += data[i++];// i++;
                    masklong = data[i] + i + 1; i++;
                    while (i < masklong)
                    {
                        if (i >= piclong)
                        {
                            break;
                        }
                        int pos = Px + Py * width;
                        byte tmpbyte = data[i];
                        if (tmpbyte >= 0xe0 && tmpbyte <= 0xe7)
                        {
                            IsShape = true;
                            tmpbyte -= (byte)(RollInt);
                            if (tmpbyte < 0xe0)
                                tmpbyte += 8;
                        }
                        else if (tmpbyte >= 0xf4 && tmpbyte <= 0xfc)
                        {
                            IsShape = true;
                            tmpbyte -= (byte)(RollInt);
                            if (tmpbyte < 0xf4)
                                tmpbyte += 8;
                        }
                        if (pos < width * Height)
                        {
                            s[pos] = JYcolor[0, tmpbyte].ARGB;
                        }
                        Px++; i++;
                    }
                }
                Py++; Px = dx;
            }
            #endregion
            BitmapData data0 = Img.LockBits(new WinRect(0, 0, Img.Width, Img.Height), ImageLockMode.ReadWrite, PixelFormat.Format32bppArgb);
            IntPtr intptr = data0.Scan0;
            Marshal.Copy(s, 0, intptr, s.Length);
            Img.UnlockBits(data0);
            return Img;
        }

        public void toPic(int p, out bool isShape, RleOpr.RGBtype[] rGBtype)
        {
            throw new NotImplementedException();
        }
    }
    /// <summary>
    /// 打包格式
    /// </summary>
    public class imzopr
    {
        public class imzReturnClass
        {
            public class imzPngPerClass
            {
                public short X;
                public short Y;
                public List<PngListIndex> pnglistindex;
                public List<Stream> png;
                public int NUM;
                public imzPngPerClass()
                {
                    pnglistindex = new List<PngListIndex>();
                    png = new List<Stream>();
                }
            }
            public int NUM;
            public List<imzPngPerClass> imzPng;
            public imzReturnClass()
            {
                imzPng = new List<imzPngPerClass>();
            }
        }
        private string filepath = string.Empty;
        /// <summary>
        /// 映像个数
        /// </summary>
        private int imzNum;
        /// <summary>
        /// 映像指针列表
        /// </summary>
        private List<int> imzListIndex = new List<int>();
        /// <summary>
        /// 图片指针列表
        /// </summary>
        private List<imzPngIndexopr> imzPngListIndex = new List<imzPngIndexopr>();
        /// <summary>
        /// png数据组
        /// </summary>
        private List<imzPngOpr> imzPngList = new List<imzPngOpr>();
        //======================================================
        private int imzPngListIndexSize
        {
            get
            {
                int tmpIndex = 0;
                for (int i = 0; i < imzPngListIndex.Count; i++)
                {
                    tmpIndex += imzPngListIndex[i].Size;
                }
                return tmpIndex;
            }
        }
        private int imzListIndexSize
        {
            get
            {
                return 4 + imzListIndex.Count * 4;
            }
        }
        private List<IndexOpr> ListIndexXY = new List<IndexOpr>();
        private class imzPngIndexopr
        {
            public int Size
            {
                get
                {
                    return 8 + num * 8;
                }
            }
            public int num
            {
                get { return imzPngIndexStart.Count; }
            }
            public short X = 0;
            public short Y = 0;
            public List<imzPngIndexStartOpr> imzPngIndexStart;
            //public void ChangeIndexStart(
            public class imzPngIndexStartOpr
            {

                public int StartIndex;
                public int LengthIndex;
                public imzPngIndexStartOpr(int start, int length)
                {
                    StartIndex = start;
                    LengthIndex = length;
                }
            }
            public imzPngIndexopr()
            {
                imzPngIndexStart = new List<imzPngIndexStartOpr>();
            }
        }
        private class imzPngOpr
        {
            public int Size
            {
                get
                {
                    int tmpsize = 0;
                    for (int i = 0; i < streamList.Count; i++)
                    {
                        tmpsize += (int)streamList[i].Length;
                    }
                    return tmpsize;
                }
            }
            private List<MemoryStream> streamList;
            public imzPngOpr()
            {
                streamList = new List<MemoryStream>();
            }
        }
        private class IndexOpr
        {
            public short x;
            public short y;
            public IndexOpr(short px,short py)
            {
                x=px;
                y=py;
            }
        }
        private List<IndexOpr> ReadDir()
        {
            if (File.Exists(filepath + "/index.ka"))
            {
                List<IndexOpr> tmplist = new List<IndexOpr>();
                try
                {
                    using (FileStream fs = new FileStream(filepath + "/index.ka", FileMode.Open))
                    {
                        using (BinaryReader br = new BinaryReader(fs))
                        {
                            for (int i = 0; i < fs.Length / 4; i++)
                            {
                                short px = br.ReadInt16();
                                short py = br.ReadInt16();
                                IndexOpr tmpindex = new IndexOpr(px, py);
                                tmplist.Add(tmpindex);
                            }
                            br.Close();
                        }
                        fs.Close();
                        return tmplist;
                    }
                }
                catch
                {
                    return null;
                }
            }
            else
                return null;
            //return File.Exists(filepath + "/index.ka");
        }
        /// <summary>
        /// 填充指针列表
        /// </summary>
        /// <param name="filepath"></param>
        private void PakImzPngListIndex()
        {
            ListIndexXY = ReadDir();
            if (ListIndexXY != null)
            {
                imzNum = ListIndexXY.Count;
                for (int i = 0; i < imzNum; i++)
                {
                    imzPngIndexopr tmppngindex = new imzPngIndexopr();
                    if(File.Exists(filepath + string.Format(@"/{0}.png",i)))
                    {
                        tmppngindex.X = ListIndexXY[i].x;
                        tmppngindex.Y = ListIndexXY[i].y;
                        tmppngindex.imzPngIndexStart.Add(new imzPngIndexopr.imzPngIndexStartOpr(0, 0));
                        imzPngListIndex.Add(tmppngindex);
                    }
                    else
                    {
                        int tmpFileIndex = 0;
                        while (File.Exists(filepath + string.Format(@"/{0}_{1}.png",i, tmpFileIndex)))
                        {
                            tmppngindex.imzPngIndexStart.Add(new imzPngIndexopr.imzPngIndexStartOpr(0, 0));
                            tmpFileIndex++;
                        }
                        tmppngindex.X = ListIndexXY[i].x;
                        tmppngindex.Y = ListIndexXY[i].y;
                        imzPngListIndex.Add(tmppngindex);
                    }
                }
            }
        }
        private void PakImzListIndex()
        {
            if(ListIndexXY != null)
            {
                int FileIndex = 4 + imzPngListIndex.Count * 4;
                for (int i = 0; i < imzPngListIndex.Count; i++)
                {
                    imzListIndex.Add(FileIndex);
                    FileIndex += imzPngListIndex[i].Size;
                }
            }
        }
        private void PakImzPngList(string filename)
        {
            PakImzPngListIndex();
            PakImzListIndex();
            if (ListIndexXY != null)
            {
                imzNum = ListIndexXY.Count;
                FileStream fs = new FileStream(filename, FileMode.Create);
                BinaryWriter br = new BinaryWriter(fs);
                br.Write(imzNum);
                for (int i = 0; i < imzListIndex.Count; i++)
                {
                    br.Write(imzListIndex[i]);
                }
                fs.Seek(imzPngListIndexSize, SeekOrigin.Current);
                for (int i = 0; i < imzNum; i++)
                {
                    byte[] tmpbyte;
                    string tmpfilename;
                    switch (imzPngListIndex[i].imzPngIndexStart.Count)
                    {
                        case 0:
                            imzPngListIndex[i] = new imzPngIndexopr();
                            break;
                        case 1:
                            tmpfilename = string.Format(filepath + string.Format(@"/{0}.png", i));
                            imzPngListIndex[i].imzPngIndexStart = new List<imzPngIndexopr.imzPngIndexStartOpr>();
                            if(!File.Exists(tmpfilename))
                                tmpfilename = filepath + string.Format(@"/{0}_{1}.png", i, 0);
                            using (FileStream pngstream = new FileStream(tmpfilename, FileMode.Open))
                            {
                                tmpbyte = new byte[pngstream.Length];
                                pngstream.Read(tmpbyte, 0, (int)pngstream.Length);
                            
                            }
                            imzPngListIndex[i].imzPngIndexStart.Add(new imzPngIndexopr.imzPngIndexStartOpr((int)fs.Position,tmpbyte.Length));
                            fs.Write(tmpbyte, 0, tmpbyte.Length);
                            GC.Collect();
                            break;
                        default:
                            int tmpcount = imzPngListIndex[i].imzPngIndexStart.Count;
                            imzPngListIndex[i].imzPngIndexStart = new List<imzPngIndexopr.imzPngIndexStartOpr>();
                            for (int tmpFileIndex = 0; tmpFileIndex < tmpcount; tmpFileIndex++)
                            {
                                using (FileStream pngstream = new FileStream(filepath + string.Format(@"/{0}_{1}.png", i, tmpFileIndex),
                                    FileMode.Open))
                                {
                                    tmpbyte = new byte[pngstream.Length];
                                    pngstream.Read(tmpbyte, 0, (int)pngstream.Length);
                                }
                                imzPngListIndex[i].imzPngIndexStart.Add(new imzPngIndexopr.imzPngIndexStartOpr((int)fs.Position, tmpbyte.Length));
                                fs.Write(tmpbyte, 0, tmpbyte.Length);
                                GC.Collect();
                            }
                            break;
                    }
                }
                fs.Seek(imzListIndexSize, SeekOrigin.Begin);
                for (int i = 0; i < imzPngListIndex.Count; i++)
                {
                    br.Write(imzPngListIndex[i].X);
                    br.Write(imzPngListIndex[i].Y);
                    br.Write(imzPngListIndex[i].num);
                    for (int j = 0; j < imzPngListIndex[i].imzPngIndexStart.Count; j++)
                    {
                        br.Write(imzPngListIndex[i].imzPngIndexStart[j].StartIndex);
                        br.Write(imzPngListIndex[i].imzPngIndexStart[j].LengthIndex);
                    }
                }
                br.Close();
                fs.Close();
            }
        }
        public void package(string filename)
        {
            PakImzPngList(filename);
        }
        public imzopr(string file)
        {
            filepath = file;
        }
        public class PngListIndex
        {
            public int start;
            public int length;
            public PngListIndex(int Start,int Length)
            {
                start = Start;
                length = Length;
            }
        }
        public void ConvertKaIndexToXls(string filepath, string fileDest)
        {
            HSSFWorkbook hssfworkbook;

            hssfworkbook = new HSSFWorkbook();

            ////create a entry of DocumentSummaryInformation
            DocumentSummaryInformation dsi = PropertySetFactory.CreateDocumentSummaryInformation();
            dsi.Company = "MythKAst";
            hssfworkbook.DocumentSummaryInformation = dsi;

            ////create a entry of SummaryInformation
            SummaryInformation si = PropertySetFactory.CreateSummaryInformation();
            si.Subject = filepath;
            hssfworkbook.SummaryInformation = si;

            using (FileStream indexfs = new FileStream(string.Format(@"./{0}/index.ka", filepath), FileMode.Open))
            {
                using (BinaryReader br = new BinaryReader(indexfs))
                {
                    List<string> tmpstr = new List<string>();
                    int num = (int)indexfs.Length / 4;
                    tmpstr.Add(filepath + ":" + num.ToString());
                    //begin
                    ISheet sheet1 = hssfworkbook.CreateSheet("index");

                    IRow row = sheet1.CreateRow(0);
                    row.CreateCell(0).SetCellValue(filepath + "//请保留文件头");
                    row.CreateCell(1).SetCellValue("偏移x");
                    row.CreateCell(2).SetCellValue("偏移y");
                    for (int i = 1; i <  num; i++)
                    {
                        row = sheet1.CreateRow(i);
                        row.CreateCell(0).SetCellValue(i  - 1);
                        row.CreateCell(1).SetCellValue(br.ReadInt16());
                        row.CreateCell(2).SetCellValue(br.ReadInt16());
                    }


                    using (FileStream fs = new FileStream(fileDest, FileMode.Create))
                    {
                        hssfworkbook.Write(fs);
                    }
                }
            }
            Console.WriteLine("Saved in " + fileDest);
        }
        public void ConvertKaIndexFromXls(string fileDest, string filepath)
        {
            HSSFWorkbook hssfworkbook;
            ICell cell;
            using (FileStream file = new FileStream(fileDest, FileMode.Open, FileAccess.Read))
            {
                hssfworkbook = new HSSFWorkbook(file);
            }
            ISheet sheet = hssfworkbook.GetSheetAt(0);
            System.Collections.IEnumerator rows = sheet.GetRowEnumerator();
            rows.MoveNext();//skip header
            using (FileStream indexfs = new FileStream(string.Format(@"./{0}/index.ka", filepath), FileMode.Create))
            {
                using (BinaryWriter bw = new BinaryWriter(indexfs))
                {
                    while (rows.MoveNext())
                    {
                        IRow row = (HSSFRow)rows.Current;

                        cell = row.GetCell(1);
                        bw.Write((short)cell.NumericCellValue);
                        cell = row.GetCell(2);
                        bw.Write((short)cell.NumericCellValue);
                    }
                }
            }
            Console.WriteLine("Saved in " + filepath);
        }

        public void ConvertKaFightFromXls(string fileDest, string filepath)
        {
            HSSFWorkbook hssfworkbook;
            ICell cell;
            using (FileStream file = new FileStream(fileDest, FileMode.Open, FileAccess.Read))
            {
                hssfworkbook = new HSSFWorkbook(file);
            }
            ISheet sheet = hssfworkbook.GetSheetAt(0);
            System.Collections.IEnumerator rows = sheet.GetRowEnumerator();
            rows.MoveNext();//skip header
            using (FileStream indexfs = new FileStream(filepath, FileMode.Create))
            {
                using (BinaryWriter bw = new BinaryWriter(indexfs))
                {
                    while (rows.MoveNext())
                    {
                        IRow row = (HSSFRow)rows.Current;

                        for (int j = 1; j < 5 + 1; j++)
                        {

                            cell = row.GetCell(j);
                            bw.Write((short)cell.NumericCellValue);
                        }
                    }
                }
            }
            Console.WriteLine("Saved in " + filepath);
        }
        public void ConvertKaFightToXls(string filepath, string fileDest)
        {
            HSSFWorkbook hssfworkbook;

            hssfworkbook = new HSSFWorkbook();

            ////create a entry of DocumentSummaryInformation
            DocumentSummaryInformation dsi = PropertySetFactory.CreateDocumentSummaryInformation();
            dsi.Company = "MythKAst";
            hssfworkbook.DocumentSummaryInformation = dsi;

            ////create a entry of SummaryInformation
            SummaryInformation si = PropertySetFactory.CreateSummaryInformation();
            si.Subject = filepath;
            hssfworkbook.SummaryInformation = si;

            using (FileStream indexfs = new FileStream(filepath, FileMode.Open))
            {
                using (BinaryReader br = new BinaryReader(indexfs))
                {
                    List<string> tmpstr = new List<string>();
                    int num = (int)indexfs.Length / 4;
                    tmpstr.Add(filepath + ":" + num.ToString());
                    //begin
                    ISheet sheet1 = hssfworkbook.CreateSheet("fight");
                    IRow row = sheet1.CreateRow(0);

                    row.CreateCell(0).SetCellValue(filepath + "//请保留文件头");
                    row.CreateCell(1).SetCellValue("拳");
                    row.CreateCell(2).SetCellValue("剑");
                    row.CreateCell(3).SetCellValue("刀");
                    row.CreateCell(4).SetCellValue("特");
                    row.CreateCell(5).SetCellValue("暗");
                    for (int i = 1; i < 500 + 1; i++)
                    {
                        row = sheet1.CreateRow(i);
                        row.CreateCell(0).SetCellValue(i - 1);
                        for (int j = 1; j < 5 + 1; j++)
                        {
                            row.CreateCell(j).SetCellValue(br.ReadInt16());
                        }
                    }


                    using (FileStream fs = new FileStream(fileDest, FileMode.Create))
                    {
                        hssfworkbook.Write(fs);
                    }
                }
            }
            Console.WriteLine("Saved in " + fileDest);
        }
        public List<string> ConvertKaIndex(string filepath)
        {
            using (FileStream indexfs = new FileStream(string.Format(@"./{0}/index.ka", filepath), FileMode.Open))
            {
                using (BinaryReader br = new BinaryReader(indexfs))
                {
                    List<string> tmpstr = new List<string>();
                    int num = (int)indexfs.Length / 4;
                    tmpstr.Add(filepath + ":" + num.ToString());
                    for(int i = 0;i<num;i++)
                    {
                        tmpstr.Add(string.Format("{0} = {1},{2}", i, br.ReadInt16(), br.ReadInt16()));
                    }
                    return tmpstr;
                }
            }
        }
        public void UnpackagePic(string filename, string filepath)
        {
            if (!File.Exists(filename))
                return;
            if (!Directory.Exists(filepath))
                Directory.CreateDirectory(filepath);
            using (FileStream fs = new FileStream(filename, FileMode.Open))
            {
                using (FileStream indexfs = new FileStream(string.Format(@"./{0}/index.ka", filepath), FileMode.Create))
                {
                    using (BinaryWriter indexbw = new BinaryWriter(indexfs))
                    {
                        using (BinaryReader br = new BinaryReader(fs))
                        {
                            int num = br.ReadInt32();
                            List<int> startindex = new List<int>();
                            startindex.Add(4+num*4);
                            for (int i = 0; i < num; i++)
                            {
                                startindex.Add(br.ReadInt32());
                            }
                            for(int i = 0;i<num;i++){
                                fs.Seek(startindex[i], SeekOrigin.Begin);
                                indexbw.Write(Convert.ToInt16(br.ReadInt32()));//x
                                indexbw.Write(Convert.ToInt16(br.ReadInt32()));//y
                                br.ReadInt32();
                                string tmpstr = string.Format(@"./{0}/{1}.png", filepath, i);
                                using (FileStream fspng = new FileStream(tmpstr, FileMode.Create))
                                {
                                    byte[] tmpbyte = new byte[startindex[i + 1] - startindex[i] - 12];
                                    fs.Read(tmpbyte, 0, tmpbyte.Length);
                                    fspng.Write(tmpbyte, 0, tmpbyte.Length);
                                }
                            }
                        }
                    }
                }
            }
        }
        public void Unpackage(string filename,string filepath)
        {
            if (!Directory.Exists(filepath))
                Directory.CreateDirectory(filepath);
            using (FileStream fs = new FileStream(filename, FileMode.Open))
            {
                using (FileStream indexfs = new FileStream(string.Format(@"./{0}/index.ka", filepath), FileMode.Create))
                {
                    using (BinaryWriter indexbw = new BinaryWriter(indexfs))
                    {
                        using (BinaryReader br = new BinaryReader(fs))
                        {
                            int num = br.ReadInt32();
                            for (int i = 0; i < num; i++)
                            {
                                fs.Seek(i * 4 + 4, SeekOrigin.Begin);
                                int tmpindex = br.ReadInt32();
                                fs.Seek(tmpindex, SeekOrigin.Begin);
                                indexbw.Write(br.ReadInt16());//x
                                indexbw.Write(br.ReadInt16());//y
                                List<PngListIndex> TmpList = new List<PngListIndex>();
                                int IndexNum = br.ReadInt32();//num
                                for(int j =0;j<IndexNum;j++)
                                {
                                    TmpList.Add(new PngListIndex(br.ReadInt32(),
                                                                 br.ReadInt32()));
                                }
                                int pngIndex = 0;
                                foreach (PngListIndex list in TmpList)
                                {
                                    string tmpstr = string.Format(@"./{0}/{1}.png",filepath,i);
                                    fs.Seek(list.start, SeekOrigin.Begin);
                                    byte[] tmpbyte = new byte[list.length];
                                    fs.Read(tmpbyte, 0, list.length);
                                    if(TmpList.Count != 1)
                                        tmpstr = string.Format(@"./{0}/{1}_{2}.png",filepath,i,pngIndex);
                                    using (FileStream fspng = new FileStream(tmpstr, FileMode.Create))
                                    {
                                        fspng.Write(tmpbyte, 0, list.length);
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
        public imzReturnClass Unpachage(string filename)
        {
            try
            {
                using (FileStream fs = new FileStream(filename, FileMode.Open))
                {
                    using (BinaryReader br = new BinaryReader(fs))
                    {
                        imzReturnClass imzReturn = new imzReturnClass();
                        imzReturn.NUM = br.ReadInt32();
                        List<imzReturnClass.imzPngPerClass> tmppngPerclass = new List<imzReturnClass.imzPngPerClass>();
                        for (int i = 0; i < imzReturn.NUM; i++)
                        {
                            br.ReadInt32();
                        }
                        for (int i = 0; i < imzReturn.NUM; i++)
                        {
                            imzReturnClass.imzPngPerClass tmppngper = new imzReturnClass.imzPngPerClass();
                            tmppngper.X = br.ReadInt16();
                            tmppngper.Y = br.ReadInt16();
                            tmppngper.NUM = br.ReadInt32();
                            for (int j = 0; j < tmppngper.NUM; j++)
                            {
                                tmppngper.pnglistindex.Add(new PngListIndex(br.ReadInt32(), br.ReadInt32()));
                            }
                            tmppngPerclass.Add(tmppngper);
                        }
                        foreach (imzReturnClass.imzPngPerClass imzpng in tmppngPerclass)
                        {
                            foreach (PngListIndex listindex in imzpng.pnglistindex)
                            {
                                fs.Seek((int)listindex.start, SeekOrigin.Begin);
                                byte[] tmpbyte = new byte[listindex.length];
                                fs.Read(tmpbyte, 0, listindex.length);
                                MemoryStream tmp = new MemoryStream(tmpbyte);
                                imzpng.png.Add(tmp);
                            }
                        }
                        return imzReturn;
                    }
                }
            }
            catch
            {
                return null;
            }
        }
    }
}
