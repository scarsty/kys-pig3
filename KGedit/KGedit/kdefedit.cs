using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Text;
using System.Windows.Forms;
using System.IO;
using System.Runtime.InteropServices;

namespace WindowsApplication1
{
    public partial class kdefedit : Form
    {
        long add;
        Int16 newtalknum, newthingnum, newmagicnum;
        uint[] size = new uint[69];
        StringBuilder kdefgrpname = new StringBuilder();
        StringBuilder folder = new StringBuilder(100);
            

        [DllImport("kernel32")]
        private static extern long WritePrivateProfileString(string section, string key,
                                                             string val, string filePath);
        /*参数说明：section：INI文件中的段落；key：INI文件中的关键字；
          val：INI文件中关键字的数值；filePath：INI文件的完整的路径和名称。*/
        [DllImport("kernel32")]
        private static extern int GetPrivateProfileString(string section, string key,
                                                          string def, StringBuilder retVal,
                                                          int size, string filePath);
        /*参数说明：section：INI文件中的段落名称；key：INI文件中的关键字；
          def：无法读取时候时候的缺省数值；retVal：读取数值；size：数值的大小；
          filePath：INI文件的完整路径和名称。*/

        public kdefedit()
        {
            int l = 0;
            StringBuilder newtalknum1 = new StringBuilder(8);
            StringBuilder newthingnum1 = new StringBuilder(8);
            StringBuilder newmagic1 = new StringBuilder(8);
            StringBuilder sizestring = new StringBuilder(3);
            GetPrivateProfileString("numbers", "new talk", "201", newtalknum1, 8, ".\\jy.ini");
            GetPrivateProfileString("numbers", "new magic", "533", newmagic1, 8, ".\\jy.ini");
            GetPrivateProfileString("numbers", "new getthing", "202", newthingnum1, 8, ".\\jy.ini");
            newtalknum = Convert.ToInt16(newtalknum1.ToString());
            newthingnum = Convert.ToInt16(newthingnum1.ToString());
            newmagicnum = Convert.ToInt16(newmagic1.ToString());
            for (l = -1; l < 68; l++)
            {
                GetPrivateProfileString("size", "Attrib" + l.ToString(), "1", sizestring, 3, ".\\jy.ini");
                size[l + 1] = uint.Parse(sizestring.ToString());
            }
            InitializeComponent();
        }
        private void change_grp(string str)
        {
            short[] talk = { 1, 0, 0, 0, 0, 0, 0, 0 };
            short[] thing = { 2, 0, 0, 0, 0, 0, 0, 0 };
            short[] magic = { 35, 0, 0, 0, 0, 0, 0, 0 };
            short[] newtalk = { 50, 43, 0, newtalknum, 0, 0, 0, 0 };
            short[] newthing = { 50, 43, 0, newthingnum, 0, 0, 0, 0 };
            short[] newmagic = { 50, 43, 0, newmagicnum, 0, 0, 0, 0 };
            FileStream grp = new FileStream(folder.ToString() + "\\" + kdefgrpname.ToString(), FileMode.Open, FileAccess.ReadWrite);
            BinaryReader reader = new BinaryReader(grp);
            BinaryWriter writer = new BinaryWriter(grp);
            short[] buff = new short[8];
            int n = 0;
            add = 0;
            while (add < (grp.Length - 16))
            {

                grp.Seek(add, SeekOrigin.Begin);
                n = 0;
                buff[n] = reader.ReadInt16();
                if (buff[0] == 1 || buff[0] == 2 || buff[0] == 32 || buff[0] == 35 || buff[0] == 50)
                {
                    grp.Seek(add, SeekOrigin.Begin);
                    while (n < 8)
                    {
                        buff[n] = reader.ReadInt16();
                        n++;
                    }
                    if (str != null)
                    {
                        if (str == "原版对话指令——新版对话指令")
                        {
                            if ((((buff[0] == 1) && ((buff[4] == 0) && (buff[5] == 0))) && (buff[6] == 0)) && (buff[7] == 0))
                            {
                                newtalk[4] = buff[2];
                                newtalk[5] = buff[1];
                                newtalk[6] = match_name(buff[2]);
                                switch (buff[3])
                                {
                                    case 0: newtalk[7] = 0; break;
                                    case 1: newtalk[7] = 1; break;
                                    case 2: newtalk[7] = 0; newtalk[6] = 0; break;
                                    case 3: newtalk[7] = 1; newtalk[6] = 0; break;
                                    default: newtalk[7] = 0; break;
                                }
                                writer.Seek((int)add, SeekOrigin.Begin);
                                n = 0;
                                while (n < 8)
                                {
                                    writer.Write(newtalk[n]);
                                    n++;
                                } add += 16;
                            }
                            else add += size[buff[0] + 1] * 2;
                        }
                        if (str == "新版对话指令——原版对话指令")
                        {
                            if ((((buff[0] == 50) && (buff[1] == 43)) && (buff[2] == 0)) && (buff[3] == newtalknum))
                            {
                                talk[2] = buff[4];
                                talk[1] = buff[5];
                                if (buff[6] == 0)
                                {
                                    talk[3] = (short)(buff[7] + 2);
                                }
                                else talk[3] = buff[7];
                                writer.Seek((int)add, SeekOrigin.Begin);
                                n = 0;
                                while (n < 8)
                                {
                                    writer.Write(talk[n]);
                                    n++;
                                } add += 16;
                            }
                            else add += size[buff[0] + 1] * 2;
                        }
                        if (str == "原版物品指令——新版物品指令")
                        {
                            if (((((buff[0] == 2) && (buff[3] == 0)) && ((buff[4] == 0) && (buff[5] == 0))) && (buff[6] == 0)) && (buff[7] == 0))
                            {
                                newthing[4] = buff[1];
                                newthing[5] = buff[2];
                                newthing[6] = 0;
                                writer.Seek((int)add, SeekOrigin.Begin);
                                n = 0;
                                while (n < 8)
                                {
                                    writer.Write(newthing[n]);
                                    n++;
                                } add += 16;
                            }
                            else if (((((buff[0] == 32) && (buff[3] == 0)) && ((buff[4] == 0) && (buff[5] == 0))) && (buff[6] == 0)) && (buff[7] == 0))
                            {
                                newthing[4] = buff[1];
                                newthing[5] = buff[2];
                                newthing[6] = 1;
                                writer.Seek((int)add, SeekOrigin.Begin);
                                n = 0;
                                while (n < 8)
                                {
                                    writer.Write(newthing[n]);
                                    n++;
                                } add += 16;
                            }
                            else add += size[buff[0] + 1] * 2;
                        }
                        if (str == "新版物品指令——原版物品指令")
                        {
                            if ((((buff[0] == 50) && (buff[1] == 43)) && (buff[2] == 0)) && (buff[3] == newthingnum))
                            {
                                thing[1] = buff[4];
                                thing[2] = buff[5];
                                switch (buff[6])
                                {
                                    case 0: thing[0] = 2; break;
                                    case 1: thing[0] = 32; break;
                                    default: thing[0] = 32; break;
                                }
                                writer.Seek((int)add, SeekOrigin.Begin);
                                n = 0;
                                while (n < 8)
                                {
                                    writer.Write(thing[n]);
                                    n++;
                                } add += 16;
                            }
                            else add += size[buff[0] + 1] * 2;
                        }
                        if (str == "原版武功指令——新版武功指令")
                        {
                            if (((((buff[0] == 35) && (buff[5] == 0))) && (buff[6] == 0)) && (buff[7] == 0))
                            {
                                newmagic[4] = buff[1];
                                newmagic[5] = buff[3];
                                newmagic[6] = buff[4];
                                newmagic[7] = buff[2];
                                writer.Seek((int)add, SeekOrigin.Begin);
                                n = 0;
                                while (n < 8)
                                {
                                    writer.Write(newmagic[n]);
                                    n++;
                                } add += 16;
                            }
                            else add += size[buff[0] + 1] * 2;

                        }
                        if (str == "新版武功指令——原版武功指令")
                        {
                            if ((((buff[0] == 50) && (buff[1] == 43)) && (buff[2] == 0)) && (buff[3] == newmagicnum))
                            {
                                magic[1] = buff[4];
                                magic[2] = buff[7];
                                magic[3] = buff[5];
                                magic[4] = buff[6];
                                writer.Seek((int)add, SeekOrigin.Begin);
                                n = 0;
                                while (n < 8)
                                {
                                    writer.Write(magic[n]);
                                    n++;
                                } add += 16;
                            }
                            else add += size[buff[0] + 1] * 2;

                        }

                    }
                }
                else add += size[buff[0] + 1] * 2;
            }


            writer.Flush();
            writer.Close();
            reader.Close();
            grp.Close();
        }

        private void button1_Click(object sender, EventArgs e)
        {
            Button a = (Button)sender;
            change_grp(a.Text);
            MessageBox.Show("转换完毕");
        }
        private short match_name(short head)
        {
            StringBuilder retVal = new StringBuilder(5);
            GetPrivateProfileString("names", Convert.ToString(head), "-2", retVal, 5, @".\jy.ini");
            return Convert.ToInt16(retVal.ToString());
        }

        private void kdefedit_Load(object sender, EventArgs e)
        {
            GetPrivateProfileString("files", "kdef.grp", "kdef.grp", kdefgrpname, 100, ".\\jy.ini");
            GetPrivateProfileString("files", "path", "", folder, 100, ".\\jy.ini");
            getpath();
        }

        private void button7_Click(object sender, EventArgs e)
        {
            if (folderBrowserDialog1.ShowDialog() == DialogResult.OK)
            {
                WritePrivateProfileString("files", "path", folderBrowserDialog1.SelectedPath, ".\\jy.ini");
                getpath();
            }
        }

        public void getpath()
        {
            GetPrivateProfileString("files", "path", "", folder, 100, ".\\jy.ini");
            this.Text = this.Text + "  " + folder.ToString();
        }

    }
}