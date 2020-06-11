using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.IO;
using System.Text;
using System.Windows.Forms;

namespace WindowsApplication1
{
    public partial class war : Form
    {
        string war1 = "", war2 = "";
        public war()
        {
            InitializeComponent();
        }

        private void button1_Click(object sender, EventArgs e)
        {
            if (waropen.ShowDialog() == DialogResult.OK)
            {
                war1 = waropen.FileName;
                button2.Enabled = true;
                begin1.Enabled = true;
                end1.Enabled = true;
                FileStream a = new FileStream(war1, FileMode.Open);
                label5.Text = "0—" + (a.Length / 186 - 1).ToString();
                a.Close();
            }
            else 
            {
                war1 = "";
                button2.Enabled = false;
                begin1.Enabled = false;
                end1.Enabled = false;
                label5.Text = "范围：";
            }
        }

        private void button2_Click(object sender, EventArgs e)
        {
            if (waropen.ShowDialog() == DialogResult.OK)
            {
                war2 = waropen.FileName;
                runit.Enabled = true;
                begin2.Enabled = true;
                end2.Enabled = true;
                FileStream a = new FileStream(war2, FileMode.Open);
                label6.Text = "0—" + (a.Length / 186 - 1).ToString();
                a.Close();
            }
            else
            {
                war2 = "";
                runit.Enabled = false;
                begin2.Enabled = false;
                end2.Enabled = false;
                label6.Text = "范围：";
            }
        }

        private void runit_Click(object sender, EventArgs e)
        {
            if (begin1.Text == "" || begin2.Text == "" || end1.Text == "" || end2.Text == "")
            {
                MessageBox.Show("请输入正确的数值");
                return;
            }
            else
            {
                if (warsave.ShowDialog() == DialogResult.OK)
                {
                    int n=0;
                    FileStream warfile1 = new FileStream(war1, FileMode.Open);
                    FileStream warfile2 = new FileStream(war2, FileMode.Open);
                    BinaryReader rd1 = new BinaryReader(warfile1);
                    BinaryReader rd2 = new BinaryReader(warfile2);
                    byte[][] data1 = new byte[int.Parse(end1.Text) - int.Parse(begin1.Text) + 1][];
                    byte[][] data2 = new byte[int.Parse(end2.Text) - int.Parse(begin2.Text) + 1][];
                    for (n = 0; n < int.Parse(end1.Text) - int.Parse(begin1.Text) + 1; n++)
                    {
                        warfile1.Seek(186 * (int.Parse(begin1.Text) + n), SeekOrigin.Begin);
                        data1[n] = rd1.ReadBytes(186);
                    }
                    for (n = 0; n < int.Parse(end2.Text) - int.Parse(begin2.Text) + 1; n++)
                    {
                        warfile2.Seek(186 * (int.Parse(begin2.Text) + n), SeekOrigin.Begin);
                        data2[n] = rd2.ReadBytes(186);
                    }
                    rd1.Close();
                    rd2.Close();
                    warfile1.Close();
                    warfile2.Close();
                    
                    FileStream warfile3 = new FileStream(warsave.FileName, FileMode.Create);
                    BinaryWriter wt = new BinaryWriter(warfile3);

                    warfile3.Seek(0, SeekOrigin.Begin);
                    for (n = 0; n < int.Parse(end1.Text) - int.Parse(begin1.Text) + 1; n++)
                    {
                        wt.Write(data1[n], 0, 186);
                    }
                    for (n = 0; n < int.Parse(end2.Text) - int.Parse(begin2.Text) + 1; n++)
                    {
                        wt.Write(data2[n], 0, 186);
                    }
                    wt.Close();
                    warfile3.Close();
                    MessageBox.Show("合并成功");
                }
            }
        }
    }
}