using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Text;
using System.Windows.Forms;
using System.IO;

namespace WindowsApplication1
{
    public partial class zedit : Form
    {
        string name = "";
        public zedit()
        {
            InitializeComponent();
        }

        private void button1_Click(object sender, EventArgs e)
        {
            if (openFileDialog1.ShowDialog() == DialogResult.OK)
            {
                name = openFileDialog1.FileName;
                FileStream zdat = new FileStream(openFileDialog1.FileName, FileMode.Open);
                BinaryReader zread = new BinaryReader(zdat);
                zdat.Seek(0x2a57e, SeekOrigin.Begin);
                luopan.Text = zread.ReadInt16().ToString();
                zdat.Seek(0x2F367, SeekOrigin.Begin);
                gold.Text = zread.ReadInt16().ToString();
                zdat.Seek(0x00026d6e, SeekOrigin.Begin);
                beginmap.Text = zread.ReadInt16().ToString();
                zdat.Seek(0x00026dc0, SeekOrigin.Begin);
                beginy.Text = zread.ReadInt16().ToString();
                zdat.Seek(0x00026db7, SeekOrigin.Begin);
                beginx.Text = zread.ReadInt16().ToString();
                zdat.Seek(0x26e2e, SeekOrigin.Begin);
                beginpic.Text = zread.ReadInt16().ToString();
                zdat.Seek(0x26e4e, SeekOrigin.Begin);
                beginkdef.Text = zread.ReadInt16().ToString();
                zdat.Seek(0x2af04, SeekOrigin.Begin);
                zigong1.Text = zread.ReadByte().ToString();
                zdat.Seek(0x2af0e, SeekOrigin.Begin);
                zigong2.Text = zread.ReadByte().ToString();
                zdat.Seek(0x3a15e, SeekOrigin.Begin);
                health.Text = zread.ReadByte().ToString();
                zdat.Seek(0x3c60b, SeekOrigin.Begin);
                poison.Text = zread.ReadByte().ToString();
                zdat.Seek(0x391c4, SeekOrigin.Begin);
                know.Text = zread.ReadByte().ToString();
                zdat.Seek(0x3837a, SeekOrigin.Begin);
                konghui.Text = zread.ReadByte().ToString();
                zdat.Seek(0x5C5F7, SeekOrigin.Begin);
                gongshi.Text = zread.ReadInt16().ToString();
                zdat.Seek(0x5C63E, SeekOrigin.Begin);
                huihejieshu.Text = zread.ReadInt16().ToString();
                zdat.Seek(0x5C662, SeekOrigin.Begin);
                battlebegin.Text = zread.ReadInt16().ToString();
                zdat.Seek(0x5C701, SeekOrigin.Begin);
                leave.Text = zread.ReadInt16().ToString();
                zdat.Seek(0x5C728, SeekOrigin.Begin);
                auto.Text = zread.ReadInt16().ToString();
                zdat.Seek(0x5C6E6, SeekOrigin.Begin);
                readfile.Text = zread.ReadInt16().ToString();
                zdat.Seek(0x5C748, SeekOrigin.Begin);
                state.Text = zread.ReadInt16().ToString();
                zdat.Seek(0x5c7d5, SeekOrigin.Begin);
                inleave.Text = zread.ReadInt16().ToString();
                zdat.Seek(0x5C7F8, SeekOrigin.Begin);
                thingbox.Text = zread.ReadInt16().ToString();
                zdat.Seek(0x5C8f0, SeekOrigin.Begin);
                beginning.Text = zread.ReadInt16().ToString();

                bspojian.Text = "";
                zdat.Seek(0x271f1, SeekOrigin.Begin);
                bspojian.Text = zread.ReadChar().ToString();
                zdat.Seek(0x271fc, SeekOrigin.Begin);
                bspojian.Text = bspojian.Text + zread.ReadChar().ToString();
                zdat.Seek(0x27207, SeekOrigin.Begin);
                bspojian.Text = bspojian.Text + zread.ReadChar().ToString();
                zdat.Seek(0x27212, SeekOrigin.Begin);
                bspojian.Text = bspojian.Text + zread.ReadChar().ToString();
                zdat.Seek(0x2721d, SeekOrigin.Begin);
                bspojian.Text = bspojian.Text + zread.ReadChar().ToString();
                zdat.Seek(0x27228, SeekOrigin.Begin);
                bspojian.Text = bspojian.Text + zread.ReadChar().ToString();
                zdat.Seek(0x27233, SeekOrigin.Begin);
                bspojian.Text = bspojian.Text + zread.ReadChar().ToString();
                zdat.Seek(0x2723c, SeekOrigin.Begin);
                bspojian.Text = bspojian.Text + zread.ReadChar().ToString();

                zdat.Seek(0x0005B53A, SeekOrigin.Begin);
                if (zread.ReadInt16() == 1) checkBox1.Checked = true;
                else checkBox1.Checked = false;
                zdat.Seek(0x00027124, SeekOrigin.Begin);
                if (zread.ReadByte() == 0x90) checkBox2.Checked = true;
                else checkBox2.Checked = false;
                zdat.Seek(0x000333d7, SeekOrigin.Begin);
                if (zread.ReadByte() == 0x45) checkBox4.Checked = true;
                else checkBox4.Checked = false;
                zdat.Seek(0x0002145a, SeekOrigin.Begin);
                if (zread.ReadByte() == 0xa2) checkBox3.Checked = true;
                else checkBox3.Checked = false;
                zdat.Seek(0x000333bd, SeekOrigin.Begin);
                if (zread.ReadByte() == 0x7f) checkBox5.Checked = true;
                else checkBox5.Checked = false;
                zdat.Seek(0x3b702, SeekOrigin.Begin);
                if (zread.ReadByte() == 0x2B) checkBox6.Checked = true;
                else checkBox6.Checked = false;
                zdat.Seek(0x2e078, SeekOrigin.Begin);
                if (zread.ReadByte() == 0xe9) checkBox7.Checked = true;
                else checkBox7.Checked = false;
                zdat.Seek(0x2A892, SeekOrigin.Begin);/*物品栏事件*/
                if (zread.ReadByte() == 0xE9) checkBox8.Checked = true;
                else checkBox8.Checked = false;
                zdat.Seek(0x20DF6, SeekOrigin.Begin);/*开始画面事件*/
                if (zread.ReadByte() == 0x16) checkBox9.Checked = true;
                else checkBox9.Checked = false;

                titleidx.Text = "";
                titlegrp.Text = "";
                titlebig.Text = "";
                hdgrpidx.Text = "";
                hdgrpgrp.Text = "";
                int a = 0;
                for (a = 0; a < 9; a++)
                {
                    zdat.Seek(0x5820a + a, SeekOrigin.Begin);//读取文件名
                    titleidx.Text = titleidx.Text + zread.ReadChar().ToString();
                    zdat.Seek(0x58214 + a, SeekOrigin.Begin);//读取文件名
                    titlegrp.Text = titlegrp.Text + zread.ReadChar().ToString();
                    zdat.Seek(0x5821e + a, SeekOrigin.Begin);//读取文件名
                    titlebig.Text = titlebig.Text + zread.ReadChar().ToString();
                    zdat.Seek(0x58804 + a, SeekOrigin.Begin);//读取文件名
                    hdgrpidx.Text = hdgrpidx.Text + zread.ReadChar().ToString();
                    zdat.Seek(0x5880e + a, SeekOrigin.Begin);//读取文件名
                    hdgrpgrp.Text = hdgrpgrp.Text + zread.ReadChar().ToString();

                }
                kdefidx.Text = "";
                kdefgrp.Text = "";
                talkidx.Text = "";
                talkgrp.Text = "";
                deadbig.Text = "";
                for (a = 0; a < 8; a++)
                {
                    zdat.Seek(0x587C4 + a, SeekOrigin.Begin);//读取文件名
                    kdefidx.Text = kdefidx.Text + zread.ReadChar().ToString();
                    zdat.Seek(0x587DE + a, SeekOrigin.Begin);//读取文件名
                    kdefgrp.Text = kdefgrp.Text + zread.ReadChar().ToString();
                    zdat.Seek(0x587E7 + a, SeekOrigin.Begin);//读取文件名
                    talkidx.Text = talkidx.Text + zread.ReadChar().ToString();
                    zdat.Seek(0x587FB + a, SeekOrigin.Begin);//读取文件名
                    talkgrp.Text = talkgrp.Text + zread.ReadChar().ToString();
                    zdat.Seek(0x588B8 + a, SeekOrigin.Begin);//读取文件名
                    deadbig.Text = deadbig.Text + zread.ReadChar().ToString();
                    
                }

                zread.Close();
                zdat.Close();
                button2.Enabled = true;
            }
            else button2.Enabled = false;


        }

       private void button2_Click(object sender, EventArgs e)
        {
            FileStream zdat = new FileStream(name, FileMode.Open);
            BinaryWriter zwt = new BinaryWriter(zdat);

            zdat.Seek(0x2a57e, SeekOrigin.Begin);
            zwt.Write(short.Parse(luopan.Text));

            zdat.Seek(0x2F367, SeekOrigin.Begin);
            zwt.Write(short.Parse(gold.Text));

            zdat.Seek(0x00026d6e, SeekOrigin.Begin);
            zwt.Write(short.Parse(beginmap.Text));

            zdat.Seek(0x00026dc0, SeekOrigin.Begin);
            zwt.Write(short.Parse(beginy.Text));

            zdat.Seek(0x00026db7, SeekOrigin.Begin);

            zwt.Write(short.Parse(beginx.Text));

            /* if (checkBox1.Checked == false)
             {
                 zdat.Seek(0x00026dd2, SeekOrigin.Begin);
                 zwt.Write((short)(short.Parse(beginy.Text) - 11));

                 zdat.Seek(0x00026dc9, SeekOrigin.Begin);
                 zwt.Write((short)(short.Parse(beginx.Text) - 11));

                 zdat.Seek(0x002007a, SeekOrigin.Begin);
                 zwt.Write((byte)(0x00));
                 zdat.Seek(0x002007b, SeekOrigin.Begin);
                 zwt.Write((byte)(0x40));
                 zdat.Seek(0x002007c, SeekOrigin.Begin);
                 zwt.Write((byte)(0x01));
                 zdat.Seek(0x00200f2, SeekOrigin.Begin);
                 zwt.Write((short)640);
                 zdat.Seek(0x0020113, SeekOrigin.Begin);
                 zwt.Write((short)640);
                 zdat.Seek(0x0020135, SeekOrigin.Begin);
                 zwt.Write((short)640);
                 zdat.Seek(0x00203a6, SeekOrigin.Begin);
                 zwt.Write((byte)(0xe0));
                 zdat.Seek(0x00203a7, SeekOrigin.Begin);
                 zwt.Write((byte)(0x01));
                 zdat.Seek(0x00203b9, SeekOrigin.Begin);
                 zwt.Write((short)640);
                 zdat.Seek(0x00203e6, SeekOrigin.Begin);
                 zwt.Write((short)640);
                 zdat.Seek(0x0020445, SeekOrigin.Begin);
                 zwt.Write((short)640);
                 zdat.Seek(0x00204ab, SeekOrigin.Begin);
                 zwt.Write((short)640);

                 zdat.Seek(0x002057f, SeekOrigin.Begin);
                 zwt.Write((short)640);
                 zdat.Seek(0x0020606, SeekOrigin.Begin);
                 zwt.Write((short)640);
                 zdat.Seek(0x002061f, SeekOrigin.Begin);
                 zwt.Write((short)640);
                 zdat.Seek(0x0020654, SeekOrigin.Begin);
                 zwt.Write((short)624);
                 zdat.Seek(0x002066d, SeekOrigin.Begin);
                 zwt.Write((short)640);
                 zdat.Seek(0x002069e, SeekOrigin.Begin);
                 zwt.Write((short)632);

                 zdat.Seek(0x002072b, SeekOrigin.Begin);
                 zwt.Write((short)480);
                 zdat.Seek(0x002073e, SeekOrigin.Begin);
                 zwt.Write((short)640);
                 zdat.Seek(0x002076b, SeekOrigin.Begin);
                 zwt.Write((short)640);
                 zdat.Seek(0x00207cb, SeekOrigin.Begin);
                 zwt.Write((short)640);
                 zdat.Seek(0x0020834, SeekOrigin.Begin);
                 zwt.Write((short)640);
                 zdat.Seek(0x0020886, SeekOrigin.Begin);
                 zwt.Write((short)640);
                 zdat.Seek(0x00209a4, SeekOrigin.Begin);
                 zwt.Write((short)480);
                 zdat.Seek(0x00209b7, SeekOrigin.Begin);
                 zwt.Write((short)640);
                 zdat.Seek(0x00209e4, SeekOrigin.Begin);
                 zwt.Write((short)640);
                 zdat.Seek(0x0020a48, SeekOrigin.Begin);
                 zwt.Write((short)640);
                 zdat.Seek(0x0020ab5, SeekOrigin.Begin);
                 zwt.Write((short)640);
                 zdat.Seek(0x0020b0f, SeekOrigin.Begin);
                 zwt.Write((short)640);

                 zdat.Seek(0x00242be, SeekOrigin.Begin);
                 zwt.Write((byte)0x15);
                 zdat.Seek(0x002436d, SeekOrigin.Begin);
                 zwt.Write((byte)0x15);
                 zdat.Seek(0x0024b0b, SeekOrigin.Begin);
                 zwt.Write((byte)0x15);
                 zdat.Seek(0x0024b41, SeekOrigin.Begin);
                 zwt.Write((byte)0x15);
                 zdat.Seek(0x0024fe6d, SeekOrigin.Begin);
                 zwt.Write((byte)0x15);
                 zdat.Seek(0x0024ff7, SeekOrigin.Begin);
                 zwt.Write((byte)0x15);
             }
             else
             {
                 zdat.Seek(0x00026dd2, SeekOrigin.Begin);
                 zwt.Write((short)(short.Parse(beginy.Text) - 11 - 10));

                 zdat.Seek(0x00026dc9, SeekOrigin.Begin);
                 zwt.Write((short)(short.Parse(beginx.Text) - 11 - 14));

                 zdat.Seek(0x002007a, SeekOrigin.Begin);
                 zwt.Write((byte)(0x80));
                 zdat.Seek(0x002007b, SeekOrigin.Begin);
                 zwt.Write((byte)(0x3e));
                 zdat.Seek(0x002007c, SeekOrigin.Begin);
                 zwt.Write((byte)(0x00));
                 zdat.Seek(0x00200f2, SeekOrigin.Begin);
                 zwt.Write((short)320);
                 zdat.Seek(0x0020113, SeekOrigin.Begin);
                 zwt.Write((short)320);
                 zdat.Seek(0x0020135, SeekOrigin.Begin);
                 zwt.Write((short)320);
                 zdat.Seek(0x00203a6, SeekOrigin.Begin);
                 zwt.Write((byte)(0xc8));
                 zdat.Seek(0x00203a7, SeekOrigin.Begin);
                 zwt.Write((byte)(0x00));
                 zdat.Seek(0x00203b9, SeekOrigin.Begin);
                 zwt.Write((short)320);
                 zdat.Seek(0x00203e6, SeekOrigin.Begin);
                 zwt.Write((short)320);
                 zdat.Seek(0x0020445, SeekOrigin.Begin);
                 zwt.Write((short)320);
                 zdat.Seek(0x00204ab, SeekOrigin.Begin);
                 zwt.Write((short)320);


                 zdat.Seek(0x002057f, SeekOrigin.Begin);
                 zwt.Write((short)320);
                 zdat.Seek(0x0020606, SeekOrigin.Begin);
                 zwt.Write((short)320);
                 zdat.Seek(0x002061f, SeekOrigin.Begin);
                 zwt.Write((short)320);
                 zdat.Seek(0x0020654, SeekOrigin.Begin);
                 zwt.Write((short)304);
                 zdat.Seek(0x002066d, SeekOrigin.Begin);
                 zwt.Write((short)320);
                 zdat.Seek(0x002069e, SeekOrigin.Begin);
                 zwt.Write((short)312);

                 zdat.Seek(0x002072b, SeekOrigin.Begin);
                 zwt.Write((short)200);
                 zdat.Seek(0x002073e, SeekOrigin.Begin);
                 zwt.Write((short)320);
                 zdat.Seek(0x002076b, SeekOrigin.Begin);
                 zwt.Write((short)320);
                 zdat.Seek(0x00207cb, SeekOrigin.Begin);
                 zwt.Write((short)320);
                 zdat.Seek(0x0020834, SeekOrigin.Begin);
                 zwt.Write((short)320);
                 zdat.Seek(0x0020886, SeekOrigin.Begin);
                 zwt.Write((short)320);
                 zdat.Seek(0x00209a4, SeekOrigin.Begin);
                 zwt.Write((short)200);
                 zdat.Seek(0x00209b7, SeekOrigin.Begin);
                 zwt.Write((short)320);
                 zdat.Seek(0x00209e4, SeekOrigin.Begin);
                 zwt.Write((short)320);
                 zdat.Seek(0x0020a48, SeekOrigin.Begin);
                 zwt.Write((short)320);
                 zdat.Seek(0x0020ab5, SeekOrigin.Begin);
                 zwt.Write((short)320);
                 zdat.Seek(0x0020b0f, SeekOrigin.Begin);
                 zwt.Write((short)320);

                 zdat.Seek(0x00242be, SeekOrigin.Begin);
                 zwt.Write((byte)0x0b);
                 zdat.Seek(0x002436d, SeekOrigin.Begin);
                 zwt.Write((byte)0x0b);
                 zdat.Seek(0x0024b0b, SeekOrigin.Begin);
                 zwt.Write((byte)0x0b);
                 zdat.Seek(0x0024b41, SeekOrigin.Begin);
                 zwt.Write((byte)0x0b);
                 zdat.Seek(0x0024fe6d, SeekOrigin.Begin);
                 zwt.Write((byte)0x0b);
                 zdat.Seek(0x0024ff7, SeekOrigin.Begin);
                 zwt.Write((byte)0x0b);


                 zdat.Seek(0x0025484, SeekOrigin.Begin);
                 zwt.Write((byte)0x15);
                 zdat.Seek(0x002549a, SeekOrigin.Begin);
                 zwt.Write((byte)0x15);
             }*/

            zdat.Seek(0x26e2e, SeekOrigin.Begin);
            zwt.Write(short.Parse(beginpic.Text));

            zdat.Seek(0x26e4e, SeekOrigin.Begin);
            zwt.Write(short.Parse(beginkdef.Text));

            zdat.Seek(0x2af04, SeekOrigin.Begin);
            zwt.Write(byte.Parse(zigong1.Text));

            zdat.Seek(0x2af0e, SeekOrigin.Begin);
            zwt.Write(byte.Parse(zigong2.Text));

            zdat.Seek(0x2c061, SeekOrigin.Begin);
            zwt.Write(byte.Parse(zigong1.Text));

            zdat.Seek(0x2c06b, SeekOrigin.Begin);
            zwt.Write(byte.Parse(zigong2.Text));

            zdat.Seek(0x3a15e, SeekOrigin.Begin);
            zwt.Write(short.Parse(health.Text));

            zdat.Seek(0x391c4, SeekOrigin.Begin);
            zwt.Write(byte.Parse(know.Text));

            zdat.Seek(0x3837a, SeekOrigin.Begin);
            zwt.Write(byte.Parse(konghui.Text));

            zdat.Seek(0x3c60b, SeekOrigin.Begin);
            zwt.Write(short.Parse(poison.Text));
            char[] ch = new char[8];
            bspojian.Text.ToUpper().CopyTo(0, ch, 0, 8);

            zdat.Seek(0x271f1, SeekOrigin.Begin);
            zwt.Write(ch[0]);
            zdat.Seek(0x271fc, SeekOrigin.Begin);
            zwt.Write(ch[1]);
            zdat.Seek(0x27207, SeekOrigin.Begin);
            zwt.Write(ch[2]);
            zdat.Seek(0x27212, SeekOrigin.Begin);
            zwt.Write(ch[3]);
            zdat.Seek(0x2721d, SeekOrigin.Begin);
            zwt.Write(ch[4]);
            zdat.Seek(0x27228, SeekOrigin.Begin);
            zwt.Write(ch[5]);
            zdat.Seek(0x27233, SeekOrigin.Begin);
            zwt.Write(ch[6]);
            zdat.Seek(0x2723c, SeekOrigin.Begin);
            zwt.Write(ch[7]);


            char[] str = new char[10];
            int a = 0;
            for (a = 0; a < 9; a++)
            {
                titleidx.Text.ToUpper().CopyTo(0, str, 0, 9);
                zdat.Seek(0x05820a + a, SeekOrigin.Begin);
                zwt.Write(str[a]);

                titlegrp.Text.ToUpper().CopyTo(0, str, 0, 9);
                zdat.Seek(0x058214 + a, SeekOrigin.Begin);
                zwt.Write(str[a]);

                titlebig.Text.ToUpper().CopyTo(0, str, 0, 9);
                zdat.Seek(0x05821e + a, SeekOrigin.Begin);
                zwt.Write(str[a]);

                hdgrpidx.Text.ToUpper().CopyTo(0, str, 0, 9);
                zdat.Seek(0x58804 + a, SeekOrigin.Begin);//写入文件名
                zwt.Write(str[a]);

                hdgrpgrp.Text.ToUpper().CopyTo(0, str, 0, 9);
                zdat.Seek(0x5880e + a, SeekOrigin.Begin);//写入文件名
                zwt.Write(str[a]);

            }


            for (a = 0; a < 8; a++)
            {
                kdefidx.Text.ToUpper().CopyTo(0, str, 0, 8);
                zdat.Seek(0x587C4 + a, SeekOrigin.Begin);//写入文件名
                zwt.Write(str[a]);

                kdefgrp.Text.ToUpper().CopyTo(0, str, 0, 8);
                zdat.Seek(0x587DE + a, SeekOrigin.Begin);//写入文件名
                zwt.Write(str[a]);

                talkidx.Text.ToUpper().CopyTo(0, str, 0, 8);
                zdat.Seek(0x587E7 + a, SeekOrigin.Begin);//写入文件名
                zwt.Write(str[a]);

                talkgrp.Text.ToUpper().CopyTo(0, str, 0, 8);
                zdat.Seek(0x587FB + a, SeekOrigin.Begin);//写入文件名
                zwt.Write(str[a]);

                deadbig.Text.ToUpper().CopyTo(0, str, 0, 8);
                zdat.Seek(0x588B8 + a, SeekOrigin.Begin);//写入文件名
                zwt.Write(str[a]);


            }


            if (checkBox2.Checked == true)
            {
                zdat.Seek(0x00027124, SeekOrigin.Begin);
                zwt.Write((byte)0x90);
                zwt.Write((byte)0x90);
                zwt.Write((byte)0x90);
                zwt.Write((byte)0x90);
                zwt.Write((byte)0x90);
            }
            else
            {
                zdat.Seek(0x00027124, SeekOrigin.Begin);
                zwt.Write((byte)0xE8);
                zwt.Write((byte)0xFD);
                zwt.Write((byte)0x08);
                zwt.Write((byte)0x00);
                zwt.Write((byte)0x00);
            }

            zdat.Seek(0x5C5FD, SeekOrigin.Begin);
            zwt.Write((byte)0xE8);
            zwt.Write((byte)0xb6);
            zwt.Write((byte)0x1e);
            zwt.Write((byte)0x00);
            zwt.Write((byte)0x00);

            /*zdat.Seek(0x5c644, SeekOrigin.Begin);
            zwt.Write((byte)0xE8);
            zwt.Write((byte)0x79);
            zwt.Write((byte)0x1e);
            zwt.Write((byte)0x00);
            zwt.Write((byte)0x00);
            
            zdat.Seek(0x5C668, SeekOrigin.Begin);
            zwt.Write((byte)0xE8);
            zwt.Write((byte)0x4b);
            zwt.Write((byte)0x1e);
            zwt.Write((byte)0x00);
            zwt.Write((byte)0x00);

            zdat.Seek(0x5e214, SeekOrigin.Begin);
            zwt.Write((byte)0xE8);
            zwt.Write((byte)0x27);
            zwt.Write((byte)0xe2);
            zwt.Write((byte)0xff);
            zwt.Write((byte)0xff);

            zdat.Seek(0x5e6ea, SeekOrigin.Begin);
            zwt.Write((byte)0xE8);
            zwt.Write((byte)0x2a);
            zwt.Write((byte)0xfc);
            zwt.Write((byte)0xfc);
            zwt.Write((byte)0xff);
            */
            zdat.Seek(0x5c700, SeekOrigin.Begin);
            zwt.Write((byte)0x68);
            zwt.Write((byte)0xe6);
            zwt.Write((byte)0x03);
            zwt.Write((byte)0x00);
            zwt.Write((byte)0x00);
            zwt.Write((byte)0xE8);
            zwt.Write((byte)0x0f);
            zwt.Write((byte)0xfc);
            zwt.Write((byte)0xfc);
            zwt.Write((byte)0xff);
            zwt.Write((byte)0x83);
            zwt.Write((byte)0xc4);
            zwt.Write((byte)0x04);
            zwt.Write((byte)0xc3);
            if (checkBox3.Checked == true)
            {
                zdat.Seek(0x21459, SeekOrigin.Begin);
                zwt.Write((byte)0xe8);
                zwt.Write((byte)0xa2);
                zwt.Write((byte)0xb2);
                zwt.Write((byte)0x03);
                zwt.Write((byte)0x00);
            }
            else
            {
                zdat.Seek(0x21459, SeekOrigin.Begin);
                zwt.Write((byte)0xe8);
                zwt.Write((byte)0x5c);
                zwt.Write((byte)0x47);
                zwt.Write((byte)0x00);
                zwt.Write((byte)0x00);
            }
            zdat.Seek(0x19328, SeekOrigin.Begin);//重定位
            zwt.Write((byte)0x07);
            zwt.Write((byte)0x10);
            zwt.Write((byte)0x6f);
            zwt.Write((byte)0x07);
            zwt.Write((byte)0x02);
            zwt.Write((byte)0x20);
            zwt.Write((byte)0x00);
            zwt.Write((byte)0x21);
            zwt.Write((byte)0x00);

            zdat.Seek(0x5c760, SeekOrigin.Begin);//经验处理
            zwt.Write((byte)0x72);
            zwt.Write((byte)0x12);
            zwt.Write((byte)0x52);
            zwt.Write((byte)0x69);
            zwt.Write((byte)0xD6);
            zwt.Write((byte)0xB6);
            zwt.Write((byte)0x00);
            zwt.Write((byte)0x00);
            zwt.Write((byte)0x00);
            zwt.Write((byte)0x8D);
            zwt.Write((byte)0x48);
            zwt.Write((byte)0x01);
            zwt.Write((byte)0x66);
            zwt.Write((byte)0x89);
            zwt.Write((byte)0x9A);
            zwt.Write((byte)0x20);
            zwt.Write((byte)0x00);
            zwt.Write((byte)0x23);
            zwt.Write((byte)0x00);
            zwt.Write((byte)0x5A);
            zwt.Write((byte)0xC3);


            zdat.Seek(0x5c720, SeekOrigin.Begin);
            zwt.Write((byte)0x60);
            zwt.Write((byte)0x33);
            zwt.Write((byte)0xc0);
            zwt.Write((byte)0x50);
            zwt.Write((byte)0x50);
            zwt.Write((byte)0x50);
            zwt.Write((byte)0x50);
            zwt.Write((byte)0x68);
            zwt.Write((byte)0x00);
            zwt.Write((byte)0x00);
            zwt.Write((byte)0x00);
            zwt.Write((byte)0x00);
            zwt.Write((byte)0x50);
            zwt.Write((byte)0xe8);
            zwt.Write((byte)0x86);
            zwt.Write((byte)0x1d);
            zwt.Write((byte)0x00);
            zwt.Write((byte)0x00);
            zwt.Write((byte)0x83);
            zwt.Write((byte)0xc4);
            zwt.Write((byte)0x18);
            zwt.Write((byte)0x61);
            zwt.Write((byte)0xc3);
            if (checkBox4.Checked == true)
            {
                zdat.Seek(0x333d6, SeekOrigin.Begin);
                zwt.Write((byte)0xe8);
                zwt.Write((byte)0x45);
                zwt.Write((byte)0x93);
                zwt.Write((byte)0x02);
                zwt.Write((byte)0x00);
            }
            else
            {
                zdat.Seek(0x333d6, SeekOrigin.Begin);
                zwt.Write((byte)0xe8);
                zwt.Write((byte)0x70);
                zwt.Write((byte)0x76);
                zwt.Write((byte)0x00);
                zwt.Write((byte)0x00);
            }

            zdat.Seek(0x5c740, SeekOrigin.Begin);
            zwt.Write((byte)0x60);
            zwt.Write((byte)0x33);
            zwt.Write((byte)0xc0);
            zwt.Write((byte)0x50);
            zwt.Write((byte)0x50);
            zwt.Write((byte)0x50);
            zwt.Write((byte)0x50);
            zwt.Write((byte)0x68);
            zwt.Write((byte)0x00);
            zwt.Write((byte)0x00);
            zwt.Write((byte)0x00);
            zwt.Write((byte)0x00);
            zwt.Write((byte)0x50);
            zwt.Write((byte)0xe8);
            zwt.Write((byte)0x66);
            zwt.Write((byte)0x1d);
            zwt.Write((byte)0x00);
            zwt.Write((byte)0x00);
            zwt.Write((byte)0x83);
            zwt.Write((byte)0xc4);
            zwt.Write((byte)0x18);
            zwt.Write((byte)0x61);
            zwt.Write((byte)0xc3);
            if (checkBox5.Checked == true)
            {
                zdat.Seek(0x21446, SeekOrigin.Begin);
                zwt.Write((byte)0xe8);
                zwt.Write((byte)0xf5);
                zwt.Write((byte)0xb2);
                zwt.Write((byte)0x03);
                zwt.Write((byte)0x00);//大地图、场景
                zdat.Seek(0x333bc, SeekOrigin.Begin);
                zwt.Write((byte)0xe8);
                zwt.Write((byte)0x7f);
                zwt.Write((byte)0x93);
                zwt.Write((byte)0x02);
                zwt.Write((byte)0x00);//战斗图
            }
            else
            {
                zdat.Seek(0x21446, SeekOrigin.Begin);
                zwt.Write((byte)0xe8);
                zwt.Write((byte)0x1b);
                zwt.Write((byte)0x0c);
                zwt.Write((byte)0x00);
                zwt.Write((byte)0x00);
                zdat.Seek(0x333bc, SeekOrigin.Begin);
                zwt.Write((byte)0xe8);
                zwt.Write((byte)0xa5);
                zwt.Write((byte)0xec);
                zwt.Write((byte)0xfe);
                zwt.Write((byte)0xff);
            }
            zdat.Seek(0x5C5F7, SeekOrigin.Begin);
            zwt.Write(short.Parse(gongshi.Text));

            zdat.Seek(0x5C63E, SeekOrigin.Begin);
            zwt.Write(short.Parse(huihejieshu.Text));

            zdat.Seek(0x5C662, SeekOrigin.Begin);
            zwt.Write(short.Parse(battlebegin.Text));

            zdat.Seek(0x5C6E6, SeekOrigin.Begin);
            zwt.Write(short.Parse(readfile.Text));

            zdat.Seek(0x5C748, SeekOrigin.Begin);
            zwt.Write(short.Parse(state.Text));

            if (checkBox6.Checked == true)
            {
                zdat.Seek(0x3b700, SeekOrigin.Begin);
                zwt.Write((byte)0x00);
                zwt.Write((byte)0x66);
                zwt.Write((byte)0x2B);
                zwt.Write((byte)0x1C);
                zwt.Write((byte)0x45);
                zwt.Write((byte)0x8E);
                zwt.Write((byte)0x45);
                zwt.Write((byte)0x03);
                zwt.Write((byte)0x00);
                zwt.Write((byte)0xE8);
                zwt.Write((byte)0x52);
                zwt.Write((byte)0x10);
                zwt.Write((byte)0x02);
                zwt.Write((byte)0x00);
                zwt.Write((byte)0x40);
                zwt.Write((byte)0x69);

            }
            else
            {
                zdat.Seek(0x3b700, SeekOrigin.Begin);
                zwt.Write((byte)0x00);
                zwt.Write((byte)0x66);
                zwt.Write((byte)0x3B);
                zwt.Write((byte)0x1C);
                zwt.Write((byte)0x45);
                zwt.Write((byte)0x38);
                zwt.Write((byte)0xB4);
                zwt.Write((byte)0x05);
                zwt.Write((byte)0x00);
                zwt.Write((byte)0x72);
                zwt.Write((byte)0x03);
                zwt.Write((byte)0x8D);
                zwt.Write((byte)0x48);
                zwt.Write((byte)0x01);
                zwt.Write((byte)0x40);
                zwt.Write((byte)0x69);

            }

            zdat.Seek(0x5c701, SeekOrigin.Begin);
            zwt.Write(short.Parse(leave.Text));
            zdat.Seek(0x5c728, SeekOrigin.Begin);
            zwt.Write(short.Parse(auto.Text));

            zdat.Seek(0x5d266, SeekOrigin.Begin);/*四则运算增加无符号除法*/
            zwt.Write((byte)0xE9);
            zwt.Write((byte)0x15);
            zwt.Write((byte)0xF5);
            zwt.Write((byte)0xFF);
            zwt.Write((byte)0xFF);
            zwt.Write((byte)0x90);
            zwt.Write((byte)0x90);
            zwt.Write((byte)0x90);
            zwt.Write((byte)0x90);
            zwt.Write((byte)0x90);

            zdat.Seek(0x5d3e6, SeekOrigin.Begin);/*sprintf增加显示无符号数*/
            zwt.Write((byte)0xE9);
            zwt.Write((byte)0xB5);
            zwt.Write((byte)0xF3);
            zwt.Write((byte)0xFF);
            zwt.Write((byte)0xFF);

            zdat.Seek(0x5C7F0, SeekOrigin.Begin);/*物品栏事件*/
            zwt.Write((byte)0x60);
            zwt.Write((byte)0x33);
            zwt.Write((byte)0xC0);
            zwt.Write((byte)0x50);
            zwt.Write((byte)0x50);
            zwt.Write((byte)0x50);
            zwt.Write((byte)0x50);
            zwt.Write((byte)0x68);
            zwt.Write((byte)0x11);
            zwt.Write((byte)0x01);
            zwt.Write((byte)0x00);
            zwt.Write((byte)0x00);
            zwt.Write((byte)0x50);
            zwt.Write((byte)0xE8);
            zwt.Write((byte)0xB6);
            zwt.Write((byte)0x1C);
            zwt.Write((byte)0x00);
            zwt.Write((byte)0x00);
            zwt.Write((byte)0x83);
            zwt.Write((byte)0xC4);
            zwt.Write((byte)0x18);
            zwt.Write((byte)0x61);
            zwt.Write((byte)0xC3);
            zdat.Seek(0x5C7F8, SeekOrigin.Begin);
            zwt.Write(short.Parse(thingbox.Text));

            zdat.Seek(0x5c780, SeekOrigin.Begin);/*无符号数除法子程*/
            zwt.Write((byte)0x83);
            zwt.Write((byte)0xFB);
            zwt.Write((byte)0x04);
            zwt.Write((byte)0x7F);
            zwt.Write((byte)0x07);
            zwt.Write((byte)0x99);
            zwt.Write((byte)0xF7);
            zwt.Write((byte)0xFD);
            zwt.Write((byte)0x8B);
            zwt.Write((byte)0xC2);
            zwt.Write((byte)0xEB);
            zwt.Write((byte)0x08);
            zwt.Write((byte)0x25);
            zwt.Write((byte)0xFF);
            zwt.Write((byte)0xFF);
            zwt.Write((byte)0x00);
            zwt.Write((byte)0x00);
            zwt.Write((byte)0x99);
            zwt.Write((byte)0xF7);
            zwt.Write((byte)0xFD);
            zwt.Write((byte)0xE9);
            zwt.Write((byte)0xD2);
            zwt.Write((byte)0x0A);

            zdat.Seek(0x5c7a0, SeekOrigin.Begin);/*显示无符号数子程*/
            zwt.Write((byte)0xE8);
            zwt.Write((byte)0xA3);
            zwt.Write((byte)0x09);
            zwt.Write((byte)0x00);
            zwt.Write((byte)0x00);
            zwt.Write((byte)0x83);
            zwt.Write((byte)0x7C);
            zwt.Write((byte)0x24);
            zwt.Write((byte)0x30);
            zwt.Write((byte)0x00);
            zwt.Write((byte)0x0F);
            zwt.Write((byte)0x84);
            zwt.Write((byte)0x3B);
            zwt.Write((byte)0x0C);
            zwt.Write((byte)0x00);
            zwt.Write((byte)0x00);
            zwt.Write((byte)0x25);
            zwt.Write((byte)0xFF);
            zwt.Write((byte)0xFF);
            zwt.Write((byte)0x00);
            zwt.Write((byte)0x00);
            zwt.Write((byte)0xE9);
            zwt.Write((byte)0x31);
            zwt.Write((byte)0x0C);
            zwt.Write((byte)0x00);
            zwt.Write((byte)0x00);

            zdat.Seek(0x5c7c0, SeekOrigin.Begin);/*离队内嵌事件*/
            zwt.Write((byte)0x68);
            zwt.Write((byte)0x08);
            zwt.Write((byte)0x00);
            zwt.Write((byte)0x00);
            zwt.Write((byte)0x00);
            zwt.Write((byte)0xE8);
            zwt.Write((byte)0x54);
            zwt.Write((byte)0x25);
            zwt.Write((byte)0xFE);
            zwt.Write((byte)0xFF);
            zwt.Write((byte)0x60);
            zwt.Write((byte)0x33);
            zwt.Write((byte)0xC0);
            zwt.Write((byte)0x50);
            zwt.Write((byte)0x50);
            zwt.Write((byte)0x50);
            zwt.Write((byte)0xFF);
            zwt.Write((byte)0x74);
            zwt.Write((byte)0x24);
            zwt.Write((byte)0x28);
            zwt.Write((byte)0x68);
            zwt.Write((byte)0x56);
            zwt.Write((byte)0x02);
            zwt.Write((byte)0x00);
            zwt.Write((byte)0x00);
            zwt.Write((byte)0x50);
            zwt.Write((byte)0xE8);
            zwt.Write((byte)0xD9);
            zwt.Write((byte)0x1C);
            zwt.Write((byte)0x00);
            zwt.Write((byte)0x00);
            zwt.Write((byte)0x83);
            zwt.Write((byte)0xC4);
            zwt.Write((byte)0x18);
            zwt.Write((byte)0x61);
            zwt.Write((byte)0xE9);
            zwt.Write((byte)0x9A);
            zwt.Write((byte)0x18);
            zwt.Write((byte)0xFD);
            zwt.Write((byte)0xFF);


            zdat.Seek(0x5c7d5, SeekOrigin.Begin);
            zwt.Write(short.Parse(inleave.Text));
            zdat.Seek(0x5C8f0, SeekOrigin.Begin);
            zwt.Write(short.Parse(beginning.Text));//开头画面事件号

            if (checkBox7.Checked == true)
            {
                zdat.Seek(0x2E078, SeekOrigin.Begin);/*离队内嵌事件*/
                zwt.Write((byte)0xE9);
                zwt.Write((byte)0x43);
                zwt.Write((byte)0xE7);
                zwt.Write((byte)0x02);
                zwt.Write((byte)0x00);
            }
            else
            {
                zdat.Seek(0x2E078, SeekOrigin.Begin);/*离队内嵌事件*/
                zwt.Write((byte)0x68);
                zwt.Write((byte)0x08);
                zwt.Write((byte)0x00);
                zwt.Write((byte)0x00);
                zwt.Write((byte)0x00);
            }

            if (checkBox8.Checked == true)
            {
                zdat.Seek(0x2A0fa, SeekOrigin.Begin);/*物品栏事件*/
                zwt.Write((byte)0xE8);
                zwt.Write((byte)0xf1);
                zwt.Write((byte)0x26);
                zwt.Write((byte)0x03);
                zwt.Write((byte)0x00);
                zdat.Seek(0x2A892, SeekOrigin.Begin);/*物品栏事件*/
                zwt.Write((byte)0xE9);
                zwt.Write((byte)0x9F);
                zwt.Write((byte)0x01);
                zwt.Write((byte)0x00);
                zwt.Write((byte)0x00);
                zwt.Write((byte)0x90);
                zwt.Write((byte)0x90);
                zwt.Write((byte)0x90);
                zwt.Write((byte)0x90);
                zwt.Write((byte)0x90);
            }
            else
            {
                zdat.Seek(0x2A0fa, SeekOrigin.Begin);/*物品栏事件*/
                zwt.Write((byte)0xE8);
                zwt.Write((byte)0x87);
                zwt.Write((byte)0x00);
                zwt.Write((byte)0x00);
                zwt.Write((byte)0x00);
                zdat.Seek(0x2A892, SeekOrigin.Begin);/*物品栏事件*/
                zwt.Write((byte)0xeb);
                zwt.Write((byte)0x4e);
                zwt.Write((byte)0x3c);
                zwt.Write((byte)0x9a);
                zwt.Write((byte)0x0f);
                zwt.Write((byte)0x84);
                zwt.Write((byte)0x73);
                zwt.Write((byte)0x00);
                zwt.Write((byte)0x00);
                zwt.Write((byte)0x00);
            }
            zdat.Seek(0x5E3CB, SeekOrigin.Begin);/*显示大图1*/
            zwt.Write((byte)0xE9);
            zwt.Write((byte)0x40);
            zwt.Write((byte)0xE4);
            zwt.Write((byte)0xFF);
            zwt.Write((byte)0xFF);
            zwt.Write((byte)0x90);
            zwt.Write((byte)0x90);
            zwt.Write((byte)0x90);

            zdat.Seek(0x19331, SeekOrigin.Begin);/*显示大图2*/
            zwt.Write((byte)0x07);
            zwt.Write((byte)0x10);
            zwt.Write((byte)0x2D);
            zwt.Write((byte)0x08);
            zwt.Write((byte)0x02);
            zwt.Write((byte)0x00);
            zwt.Write((byte)0x00);
            zwt.Write((byte)0x25);
            zwt.Write((byte)0x00);

            zdat.Seek(0x5c810, SeekOrigin.Begin);/*显示大图3*/
            zwt.Write((byte)0x83);
            zwt.Write((byte)0x7C);
            zwt.Write((byte)0x24);
            zwt.Write((byte)0x18);
            zwt.Write((byte)0x02);
            zwt.Write((byte)0x74);
            zwt.Write((byte)0x0D);
            zwt.Write((byte)0x55);
            zwt.Write((byte)0x57);
            zwt.Write((byte)0x56);
            zwt.Write((byte)0xE8);
            zwt.Write((byte)0x71);
            zwt.Write((byte)0x0D);
            zwt.Write((byte)0xFD);
            zwt.Write((byte)0xFF);
            zwt.Write((byte)0x83);
            zwt.Write((byte)0xC4);
            zwt.Write((byte)0x0C);
            zwt.Write((byte)0xEB);
            zwt.Write((byte)0x17);
            zwt.Write((byte)0x60);
            zwt.Write((byte)0x8B);
            zwt.Write((byte)0xC5);
            zwt.Write((byte)0xE8);
            zwt.Write((byte)0x4D);
            zwt.Write((byte)0x09);
            zwt.Write((byte)0x00);
            zwt.Write((byte)0x00);
            zwt.Write((byte)0x68);
            zwt.Write((byte)0x00);
            zwt.Write((byte)0x00);
            zwt.Write((byte)0x27);
            zwt.Write((byte)0x00);
            zwt.Write((byte)0x50);
            zwt.Write((byte)0xE8);
            zwt.Write((byte)0x0E);
            zwt.Write((byte)0x07);
            zwt.Write((byte)0xFE);
            zwt.Write((byte)0xFF);
            zwt.Write((byte)0x83);
            zwt.Write((byte)0xC4);
            zwt.Write((byte)0x08);
            zwt.Write((byte)0x61);
            zwt.Write((byte)0xE9);
            zwt.Write((byte)0x96);
            zwt.Write((byte)0x1B);



　　　　　　zdat.Seek(0x19343, SeekOrigin.Begin);/*开头画面插入事件重定位*/
            zwt.Write((byte)0x07);
            zwt.Write((byte)0x10);
            zwt.Write((byte)0x13);
            zwt.Write((byte)0x09);
            zwt.Write((byte)0x02);
            zwt.Write((byte)0xAC);
            zwt.Write((byte)0x0B);
            zwt.Write((byte)0x1A);
            zwt.Write((byte)0x00);
            zwt.Write((byte)0x07);
            zwt.Write((byte)0x10);
            zwt.Write((byte)0x1A);
            zwt.Write((byte)0x09);
            zwt.Write((byte)0x02);
            zwt.Write((byte)0x0A);
            zwt.Write((byte)0x82);
            zwt.Write((byte)0x03);
            zwt.Write((byte)0x00);
            zwt.Write((byte)0x07);
            zwt.Write((byte)0x10);
            zwt.Write((byte)0x1F);
            zwt.Write((byte)0x09);
            zwt.Write((byte)0x02);
            zwt.Write((byte)0x14);
            zwt.Write((byte)0x82);
            zwt.Write((byte)0x03);
            zwt.Write((byte)0x00);


　　　　　　zdat.Seek(0x5c8ef, SeekOrigin.Begin);/*开头画面插入子程*/
            zwt.Write((byte)0x68);
            zwt.Write((byte)0xE8);
            zwt.Write((byte)0x00);
            zwt.Write((byte)0x00);
            zwt.Write((byte)0x00);
            zwt.Write((byte)0xE8);
            zwt.Write((byte)0x20);
            zwt.Write((byte)0xFA);
            zwt.Write((byte)0xFC);
            zwt.Write((byte)0xFF);
            zwt.Write((byte)0x83);
            zwt.Write((byte)0xC4);
            zwt.Write((byte)0x04);
            zwt.Write((byte)0xE8);
            zwt.Write((byte)0xAE);
            zwt.Write((byte)0x46);
            zwt.Write((byte)0xFC);
            zwt.Write((byte)0xFF);
            zwt.Write((byte)0x61);
            zwt.Write((byte)0xC3);
            zwt.Write((byte)0xB8);
            zwt.Write((byte)0x02);
            zwt.Write((byte)0x00);
            zwt.Write((byte)0x00);
            zwt.Write((byte)0x00);
            zwt.Write((byte)0xCD);
            zwt.Write((byte)0x10);
            zwt.Write((byte)0xB4);
            zwt.Write((byte)0x00);
            zwt.Write((byte)0xCD);
            zwt.Write((byte)0x21);
            zwt.Write((byte)0xC3);
            zwt.Write((byte)0x90);
            zwt.Write((byte)0x60);
            zwt.Write((byte)0xFF);
            zwt.Write((byte)0x35);
            zwt.Write((byte)0xAC);
            zwt.Write((byte)0x0B);
            zwt.Write((byte)0x1C);
            zwt.Write((byte)0x00);
            zwt.Write((byte)0x6A);
            zwt.Write((byte)0x00);
            zwt.Write((byte)0x68);
            zwt.Write((byte)0x0A);
            zwt.Write((byte)0x82);
            zwt.Write((byte)0x05);
            zwt.Write((byte)0x00);
            zwt.Write((byte)0x68);
            zwt.Write((byte)0x14);
            zwt.Write((byte)0x82);
            zwt.Write((byte)0x05);
            zwt.Write((byte)0x00);
            zwt.Write((byte)0xE8);
            zwt.Write((byte)0xB8);
            zwt.Write((byte)0x0D);
            zwt.Write((byte)0xFE);
            zwt.Write((byte)0xFF);
            zwt.Write((byte)0x83);
            zwt.Write((byte)0xC4);
            zwt.Write((byte)0x10);
            zwt.Write((byte)0xEB);
            zwt.Write((byte)0xC2);


            if (checkBox9.Checked == true)
            {
                zdat.Seek(0x20DF5, SeekOrigin.Begin);/*开头画面插入子程*/
                zwt.Write((byte)0xE8);
                zwt.Write((byte)0x16);
                zwt.Write((byte)0xBB);
                zwt.Write((byte)0x03);
                zwt.Write((byte)0x00);

            }
            else
            {
                zdat.Seek(0x20DF5, SeekOrigin.Begin);/*开头画面插入子程*/
                zwt.Write((byte)0xE8);
                zwt.Write((byte)0xB5);
                zwt.Write((byte)0x01);
                zwt.Write((byte)0x00);
                zwt.Write((byte)0x00);
             
            }

            zwt.Close();
            zdat.Close();
            MessageBox.Show("写入完成");
        }

        private void button3_Click(object sender, EventArgs e)
        {
            while (name != "")
            {
                FileStream zdat = new FileStream(name, FileMode.Open);
                BinaryReader zread = new BinaryReader(zdat);
                stringmod a = new stringmod(zdat, zread);
                a.Show();
            }
        }

        

        
    }
}