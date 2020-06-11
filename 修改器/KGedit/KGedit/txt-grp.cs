using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Text;
using System.Windows.Forms;
using System.IO;
using System.Runtime.InteropServices;

using Microsoft.VisualBasic;

namespace txt2grp
{
    public partial class txt2grp : Form
    {
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

        StringBuilder talkgrp = new StringBuilder();
        StringBuilder talkidx = new StringBuilder();
        StringBuilder kdefgrp = new StringBuilder();
        StringBuilder kdefidx = new StringBuilder();
        StringBuilder folder = new StringBuilder(300);
        StringBuilder txtname = new StringBuilder(300);



        public txt2grp()
        {
            InitializeComponent();
            GetPrivateProfileString("files", "talk.grp", "talk.grp", talkgrp, 100, ".\\jy.ini");
            GetPrivateProfileString("files", "talk.idx", "talk.idx", talkidx, 100, ".\\jy.ini");
            GetPrivateProfileString("files", "kdef.grp", "kdef.grp", kdefgrp, 100, ".\\jy.ini");
            GetPrivateProfileString("files", "kdef.idx", "kdef.idx", kdefidx, 100, ".\\jy.ini");
            GetPrivateProfileString("files", "txt", "talk.txt", txtname, 100, ".\\jy.ini");
            getfolder();
        }

        private void button1_Click(object sender, EventArgs e)
        {
            if (openFileDialog1.ShowDialog() == DialogResult.OK)
            {
                WritePrivateProfileString("files", "txt", openFileDialog1.FileName, ".\\jy.ini");
                GetPrivateProfileString("files", "txt", "", txtname, 300, ".\\jy.ini");
            }
        }

        private void button3_Click(object sender, EventArgs e)
        {
            if (folderBrowserDialog1.ShowDialog() == DialogResult.OK)
            {
                WritePrivateProfileString("files", "path", folderBrowserDialog1.SelectedPath, ".\\jy.ini");
                getfolder();
            }
        }

        void getfolder()
        {
            GetPrivateProfileString("files", "path", "", folder, 100, ".\\jy.ini");
            this.Text = this.Text + "  " + folder.ToString();

        }

        private void button2_Click(object sender, EventArgs e)
        {
            FileStream idxtalk = new FileStream(folder.ToString() + "\\" + talkidx.ToString(), FileMode.Open);
            FileStream idxkdef = new FileStream(folder.ToString() +"\\"+ kdefidx.ToString(), FileMode.Open);
            FileStream grptalk = new FileStream(folder.ToString() +"\\"+ talkgrp.ToString(), FileMode.Open);
            FileStream grpkdef = new FileStream(folder.ToString() +"\\"+ kdefgrp.ToString(), FileMode.Open);
            FileStream txt = new FileStream(txtname.ToString(), FileMode.Open);

            BinaryReader talkidxreader = new BinaryReader(idxtalk);
            BinaryWriter talkidxwrite = new BinaryWriter(idxtalk);
            BinaryWriter talkgrpwrite = new BinaryWriter(grptalk);

            BinaryReader kdefidxreader = new BinaryReader(idxkdef);
            BinaryWriter kdefidxwrite = new BinaryWriter(idxkdef);
            BinaryWriter kdefgrpwrite = new BinaryWriter(grpkdef);
            
            //读取txt
            StreamReader txtreader = new StreamReader(txt);
            string[] speaking=new string[2];
            txt.Seek(0, SeekOrigin.Begin);
            int count = 0;
            
            while(txtreader.Peek()!=-1)
            {
                speaking = txtreader.ReadLine().Split(':');//用半角冒号分割名字与对话
                ushort[] instruct = new ushort[9];
                instruct[0] = 01;//指令号
                instruct[2] = get_name_num(speaking[0]);//头像
                instruct[3] = (ushort)(count % 2);//左右屏
                instruct[4] = 0;//清屏

                //方便指令转换
                instruct[5] = 0;
                instruct[6] = 0;
                instruct[7] = 0;
                instruct[8] = 0;
                
                string speak = speaking[1];//得到对话
                speak = Strings.StrConv(speak, VbStrConv.TraditionalChinese, 0);
                byte[] Cwords = new byte[speak.Length*2];
                System.Text.Encoding.GetEncoding("BIG5").GetBytes(speak, 0, speak.Length, Cwords, 0);

                grptalk.Seek(0, SeekOrigin.End);
                for (int i = 0; i <Cwords.Length; i++)
                {
                    //全部异或ff
                    talkgrpwrite.Write((byte)(Cwords[i]^0xff ));//写入对话文件
                }
                grptalk.Seek(0, SeekOrigin.End);
                talkgrpwrite.Write((byte)0);//对话结尾

                textBox1.Text = textBox1.Text + count.ToString() + ": " + "\" " + speaking[1] + "\" " + "转换成功" + "\r\n";
                
                    instruct[1] = (ushort)(idxtalk.Length/4);
                idxtalk.Seek((instruct[1]-1)*4, SeekOrigin.Begin);
                int length = talkidxreader.ReadInt32() + (speak.Length ) * 2 + 1;
                idxtalk.Seek(0, SeekOrigin.End);
                talkidxwrite.Write(length);//写入对话索引

                grpkdef.Seek(0, SeekOrigin.End);
                for (int i = 0; i < instruct.Length; i++)
                {
                    kdefgrpwrite.Write(instruct[i]);//写入事件文件
                }
                count++;//对话数+1
            }
            kdefgrpwrite.Write(ushort.MaxValue);
            idxkdef.Seek((idxkdef.Length / 4 - 1) * 4, SeekOrigin.Begin);//定位到kdef最后一条记录
            int length_of_kdef= kdefidxreader.ReadInt32() + (count)*18+2;
            idxkdef.Seek(0, SeekOrigin.End);
            kdefidxwrite.Write(length_of_kdef);//写入事件索引

            idxkdef.Close();
            idxtalk.Close();

            grpkdef.Close();
            grptalk.Close();

            txt.Close();

            talkgrpwrite.Close();
            talkidxwrite.Close();
            talkidxreader.Close();

            kdefidxreader.Close();
            kdefgrpwrite.Close();
            kdefidxwrite.Close();

            txtreader.Close();
            MessageBox.Show("转换成功");
            return;
        }
        public ushort get_name_num(string name)
        {
            StringBuilder namenum=new StringBuilder(5);
            GetPrivateProfileString("name", name, "0", namenum, 5, ".\\jy.ini");
            return ushort.Parse(namenum.ToString());
        }
    }
   
}