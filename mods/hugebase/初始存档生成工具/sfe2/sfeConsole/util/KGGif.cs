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
using WinRect = System.Drawing.Rectangle;
using System.Runtime.InteropServices;
namespace imzopr.Drawing
{
    /// <summary>
    /// Gif图片类
    /// </summary>
    public class KGGif : IDisposable
    {
        private List<Bitmap> ImgLst = new List<Bitmap>();

        public Bitmap this[int idx]
        {
            get { return ImgLst[idx]; }
        }

        public int Count
        {
            get { return ImgLst.Count; }
        }

        public KGGif()
        {

        }

        public KGGif(string filename)
        {
            ReadGifFile(filename);
        }

        public void SaveAsPngToFile(int frame, string filename)
        {
            this[frame].Save(filename, ImageFormat.Png);
        }

        public void SaveAsPngToStream(int frame, Stream stream)
        {
            this[frame].Save(stream, ImageFormat.Png);
        }

        public WinRect GetMinRect()
        {
            int Min = Count * this[0].Width * this[0].Height;
            int TmpX = 1;
            int TmpY = Count;
            int DD = Math.Abs(this[0].Width - (this[0].Height * Count));
            for (int x = 1; x <= Count; x++)
            {
                int y = (Count % x == 0 ? 0 : 1) + (Count / x);
                if (x * this[0].Width * y * this[0].Height <= Min && DD > Math.Abs(this[0].Width * x - this[0].Height * y))
                {
                    TmpX = x;
                    TmpY = y;
                    Min = x * this[0].Width * y * this[0].Height;
                    DD = Math.Abs(this[0].Width * x - this[0].Height * y);
                }
            }
            WinRect ret = new WinRect(0, 0, TmpX * this[0].Width, TmpY * this[0].Height);
            return ret;
        }

        public void SaveAsPngToFolder(string folder, string formatStr = "{0:d3}.png")
        {
            if (!Directory.Exists(folder)) Directory.CreateDirectory(folder);
            for (int i = 0; i < ImgLst.Count; i++)
            {
                string filename = folder + "\\" + string.Format(formatStr, i);
                SaveAsPngToFile(i, filename);
            }
        }
        public void SaveAsPngToFolder(string folder, int Istart)
        {
            if (!Directory.Exists(folder)) Directory.CreateDirectory(folder);
            for (int i = Istart; i < ImgLst.Count + Istart; i++)
            {
                string filename = folder + "\\" + string.Format("{0}.png", i);
                SaveAsPngToFile(i - Istart, filename);
            }
        }
        public void SaveAllAsPngToStream(Stream stream)
        {
            WinRect rect = GetMinRect();

            int w = this[0].Width;
            int h = this[0].Height;

            int col = rect.Width / w;
            int row = rect.Height / h;


            using (Bitmap bmp = new Bitmap(rect.Width, rect.Height, PixelFormat.Format32bppArgb))
            using (Graphics g = Graphics.FromImage(bmp))
            {
                for (int i = 0; i < Count; i++)
                    g.DrawImage(
                        this[i],
                        new WinRect(w * (i % col), h * (i / col), w, h),
                        new WinRect(0, 0, w, h),
                        GraphicsUnit.Pixel);

                bmp.Save(stream, ImageFormat.Png);
            }
        }
        public void SaveAllAsPngToFile(string filename)
        {
            WinRect rect = GetMinRect();

            int w = this[0].Width;
            int h = this[0].Height;

            int col = rect.Width / w;
            int row = rect.Height / h;


            using (Bitmap bmp = new Bitmap(rect.Width, rect.Height, PixelFormat.Format32bppArgb))
            using (Graphics g = Graphics.FromImage(bmp))
            {
                for (int i = 0; i < Count; i++)
                    g.DrawImage(
                        this[i],
                        new WinRect(w * (i % col), h * (i / col), w, h),
                        new WinRect(0, 0, w, h),
                        GraphicsUnit.Pixel);

                bmp.Save(filename, ImageFormat.Png);
            }
        }

        public void ReadGifFile(string filename)
        {
            Dispose();
            using (Bitmap bmp = new Bitmap(filename))
            {
                int cnt2 = bmp.FrameDimensionsList.Length;
                for (int j = 0; j < cnt2; j++)
                {
                    FrameDimension fd = new FrameDimension(bmp.FrameDimensionsList[j]);
                    int cnt = bmp.GetFrameCount(fd);
                    for (int i = 0; i < cnt; i++)
                    {
                        bmp.SelectActiveFrame(fd, i);

                        Bitmap newbmp = new Bitmap(bmp.Width, bmp.Height, bmp.PixelFormat);
                        if (bmp.PixelFormat == PixelFormat.Format8bppIndexed)
                            newbmp.Palette = bmp.Palette;

                        BitmapData datadst = newbmp.LockBits(new WinRect(0, 0, bmp.Width, bmp.Height), ImageLockMode.ReadWrite, newbmp.PixelFormat);
                        BitmapData datasrc = bmp.LockBits(new WinRect(0, 0, bmp.Width, bmp.Height), ImageLockMode.ReadWrite, bmp.PixelFormat);

                        byte[] bs = new byte[datasrc.Stride * datasrc.Height];
                        Marshal.Copy(datasrc.Scan0, bs, 0, bs.Length);
                        Marshal.Copy(bs, 0, datadst.Scan0, bs.Length);

                        newbmp.UnlockBits(datadst);
                        bmp.UnlockBits(datasrc);

                        ImgLst.Add(newbmp);
                    }
                }
            }
        }
        public void Dispose()
        {
            for (int i = 0; i < ImgLst.Count; i++)
                ImgLst[i].Dispose();

            ImgLst.Clear();
            GC.Collect();
        }
    }
}