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
    public partial class map : Form
    {
        public map()
        {
            InitializeComponent();
        }

        private void radioButton_CheckedChanged(object sender, EventArgs e)
        {
            if (radioButton1.Checked == true)
            {
                button1.Enabled = true;
                button2.Enabled = true;
                textBox1.Enabled = true;
                textBox2.Enabled = true;
                textBox3.Enabled = true;
                button3.Enabled = false;
                button4.Enabled = false;
                textBox4.Enabled = false;
                textBox5.Enabled = false;
                textBox6.Enabled = false;
                checkBox2.Enabled = false;
                checkBox1.Enabled = true;
                button5.Enabled = true;
            }
            else if (radioButton2.Checked == true)
            {
                button3.Enabled = true;
                button4.Enabled = true;
                textBox4.Enabled = true;
                textBox5.Enabled = true;
                textBox6.Enabled = true;
                checkBox2.Enabled = true;
                button1.Enabled = false;
                button2.Enabled = false;
                textBox1.Enabled = false;
                textBox2.Enabled = false;
                textBox3.Enabled = false;
                button5.Enabled = true;
                checkBox1.Enabled = false;
            }
            else
            {
                button1.Enabled = false;
                button2.Enabled = false;
                textBox1.Enabled = false;
                textBox2.Enabled = false;
                textBox3.Enabled = false; 
                button3.Enabled = false;
                button4.Enabled = false;
                textBox4.Enabled = false;
                textBox5.Enabled = false;
                textBox6.Enabled = false;
                checkBox2.Enabled = false;
                button5.Enabled = false;
                checkBox1.Enabled = false;
            }
        }

        private void button1_Click(object sender, EventArgs e)
        {
            openFileDialog1.Filter = "S*.grp|S*.grp";
            if (openFileDialog1.ShowDialog() == DialogResult.OK)
            {
                textBox1.Text = openFileDialog1.FileName;
            } 
        }

        private void button2_Click(object sender, EventArgs e)
        {
            saveFileDialog1.Filter = "*.map|*.map";
            if (saveFileDialog1.ShowDialog() == DialogResult.OK)
            {
                textBox2.Text = saveFileDialog1.FileName;
            }
        }

        private void button5_Click(object sender, EventArgs e)
        {
            FileStream sg, map;
            int num;
            if (radioButton1.Checked == true)
            {
                if (textBox1.Text == "" || textBox2.Text == "" || textBox3.Text == "")
                {
                    MessageBox.Show("参数错误");
                    return;
                }
                else
                {
                    sg = new FileStream(textBox1.Text, FileMode.Open);
                    map = new FileStream(textBox2.Text, FileMode.Create);
                    num = int.Parse(textBox3.Text);
                    BinaryReader grpread = new BinaryReader(sg);
                    BinaryWriter mapwriter = new BinaryWriter(map);

                    int n=0,m=0;
                    for (n = 0; n < 6; n++)
                    {
                        for (m = 0; m < 64 * 64; m++)
                        {
                            if (checkBox1.Checked != true || n != 3)
                            {
                                sg.Seek((64 * 64 * 6 * num + m + 64 * 64 * n) * 2, SeekOrigin.Begin);
                                map.Seek(2 * (m + 64 * 64 * n), SeekOrigin.Begin);
                                mapwriter.Write(grpread.ReadInt16());
                            }
                            else
                            {
                                map.Seek(2 * (m + 64 * 64 * n), SeekOrigin.Begin);
                                mapwriter.Write((short)-1);
                            }
                        }
                    } MessageBox.Show("导出成功"); 
                    mapwriter.Close();
                    grpread.Close();
                    sg.Close();
                    map.Close();
                }
            }
            else if (radioButton2.Checked == true)
            {
                if (textBox4.Text == "" || textBox5.Text == "" || textBox6.Text == "")
                {
                    MessageBox.Show("参数错误");
                    return;
                }
                else
                {
                    sg = new FileStream(textBox4.Text, FileMode.Open);
                    map = new FileStream(textBox5.Text, FileMode.Open);
                    num = int.Parse(textBox6.Text);
                    BinaryReader mapread = new BinaryReader(map);
                    BinaryWriter grpwriter = new BinaryWriter(sg);

                    int n = 0, m = 0;
                    for (n = 0; n < 6; n++)
                    {
                        if (n != 3 || checkBox2.Checked != false)
                        {
                            for (m = 0; m < 64 * 64; m++)
                            {
                                sg.Seek((64 * 64 * 6 * num + m + 64 * 64 * n) * 2, SeekOrigin.Begin);
                                map.Seek(2 * (m + 64 * 64 * n), SeekOrigin.Begin);
                                grpwriter.Write(mapread.ReadInt16());
                            }

                        }
                    } MessageBox.Show("导入成功");
                    grpwriter.Close();
                    mapread.Close();
                    sg.Close();
                    map.Close();
                }
            }
        }

        private void button3_Click(object sender, EventArgs e)
        {
            openFileDialog1.Filter = "S*.grp|S*.grp";
            if (openFileDialog1.ShowDialog() == DialogResult.OK)
            {
                textBox4.Text = openFileDialog1.FileName;
            }
        }

        private void button4_Click(object sender, EventArgs e)
        {
            openFileDialog1.Filter = "*.map|*.map";
            if (openFileDialog1.ShowDialog() == DialogResult.OK)
            {
                textBox5.Text = openFileDialog1.FileName;
            }
        }

    }
}