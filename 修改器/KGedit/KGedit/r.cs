using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Text;
using System.IO;
using System.Windows.Forms;

namespace WindowsApplication1
{
    public partial class rfile : Form
    {
        FileStream grp1;
        FileStream grp2;
        FileStream idx1;
        FileStream idx2;
        FileStream grp3;
        FileStream idx3;
        static int[] rangeridx = { 182, 190, 52, 136, 30 };
            
        string file1grp="", file2grp="", file1idx="", file2idx="";
        public rfile()
        {
            InitializeComponent();
        }

        private void button2_Click(object sender, EventArgs e)
        {
            if (grpopenfile.ShowDialog() == DialogResult.OK)
            {
                file1grp = grpopenfile.FileName;
                if (idxopenfile.ShowDialog() == DialogResult.OK)
                {
                    file1idx = idxopenfile.FileName;
                    file1begin.Enabled = true;
                    file1end.Enabled = true;
                    FileStream a = new FileStream(file1idx, FileMode.Open);
                    BinaryReader b = new BinaryReader(a);
                    int[] size =new int[6];
                    int n=0;
                    a.Seek(0, SeekOrigin.Begin);
                    for (n = 0; n < 6; n++)
                    {
                        size[n] = b.ReadInt32();
                    }

                    label7.Text = "人物：(0—" + ((size[1] - size[0]) / rangeridx[0] - 1).ToString() + ")\n"
                        + "物品：(0—" + ((size[2] - size[1]) / rangeridx[1] - 1).ToString() + ")\n"
                        + "场景：(0—" + ((size[3] - size[2]) / rangeridx[2] - 1).ToString() + ")\n"
                        + "武功：(0—" + ((size[4] - size[3]) / rangeridx[3] - 1).ToString() + ")";
                    b.Close();
                    a.Close();
                    return;
                }
                else
                {
                    file1begin.Enabled = false;
                    file1end.Enabled = false;
                    file1grp = "";
                    file1idx = "";
                    file1begin.Text = "";
                    file1end.Text = "";
                    label7.Text = "";
                }
            }
            else
            {
                file1begin.Enabled = false;
                file1end.Enabled = false;
                file1grp = "";
                file1idx = "";
                file1begin.Text = "";
                file1end.Text = "";
            }
        }

        private void button3_Click(object sender, EventArgs e)
        {
            if (grpopenfile.ShowDialog() == DialogResult.OK)
            {
                file2grp = grpopenfile.FileName;
                if (idxopenfile.ShowDialog() == DialogResult.OK)
                {
                    file2idx = idxopenfile.FileName;
                    file2begin.Enabled = true;
                    file2end.Enabled = true;
                    FileStream a = new FileStream(file2idx, FileMode.Open);
                    BinaryReader b = new BinaryReader(a);
                    int[] size = new int[6];
                    int n = 0;
                    a.Seek(0, SeekOrigin.Begin);
                    for (n = 0; n < 6; n++)
                    {
                        size[n] = b.ReadInt32();
                        
                    }

                    label8.Text = "人物：(0—" + ((size[1]-size[0]) / rangeridx[0] - 1).ToString() + ")\n"
                        + "物品：(0—" + ((size[2]-size[1])  / rangeridx[1] - 1).ToString() + ")\n"
                        + "场景：(0—" + ((size[3]-size[2])  / rangeridx[2] - 1).ToString() + ")\n"
                        + "武功：(0—" + ((size[4] - size[3]) / rangeridx[3] - 1).ToString() + ")";
                    b.Close();
                    a.Close();
                    return;
                }
                else
                {
                    file2begin.Enabled = false;
                    file2end.Enabled = false;
                    file2grp = "";
                    file2idx = "";
                    file2begin.Text = "";
                    file2end.Text = "";
                    label8.Text = "";
                }
            }
            else
            {
                file2begin.Enabled = false;
                file2end.Enabled = false;
                file2grp = "";
                file2idx = "";
                file2begin.Text = "";
                file2end.Text = ""; 
            }
        }

        private void button1_Click(object sender, EventArgs e)
        {
            if (grpsave.ShowDialog() == DialogResult.OK)
            {
                if (idxsave.ShowDialog() == DialogResult.OK)
                {

                    int add = 0;
                    if (file1begin.Text == "" || file1end.Text == "" || file2end.Text == "" || file2end.Text == "")
                    {
                        MessageBox.Show("请输入起始值及结束值");
                        return;
                    }
                    if (radioButton1.Checked != true && radioButton2.Checked != true && radioButton3.Checked != true && radioButton4.Checked != true)
                    {
                        MessageBox.Show("请选择类别");
                        return;
                    }
                    if (radioButton1.Checked == true)
                    {
                        add = 0;
                    }
                    else if (radioButton2.Checked == true)
                    {
                        add = 1;
                    }
                    else if (radioButton3.Checked == true)
                    {
                        add = 2;
                    }
                    else if (radioButton4.Checked == true)
                    {
                        add = 3;
                    }


                    int add2 = 0;
                    int[] sizebuff ={ 0, 0, 0, 0, 0, 0 };
                    int[] addbuff ={ 0, 0, 0, 0, 0, 0 };
                    int[] addbuff2 ={ 0, 0, 0, 0, 0, 0 };
                    idx1 = new FileStream(file1idx, FileMode.Open);
                    BinaryReader ird1 = new BinaryReader(idx1);
                    for (add2 = 0; add2 < 6; add2++)
                    {
                        idx1.Seek(add2 * 4, SeekOrigin.Begin);
                        addbuff[add2] = ird1.ReadInt32();
                        idx1.Seek(add2 * 4, SeekOrigin.Begin);
                        if (add2 == 0)
                        {
                            sizebuff[add2] = 836;
                        }
                        else
                        {
                            sizebuff[add2] = (ird1.ReadInt32() - sizebuff[add2 - 1]) / rangeridx[add2 - 1];
                        }
                    }
                    ird1.Close();

                    idx2 = new FileStream(file2idx, FileMode.Open);
                    BinaryReader ird2 = new BinaryReader(idx2);
                    for (add2 = 0; add2 < 6; add2++)
                    {
                        idx2.Seek(add2 * 4, SeekOrigin.Begin);
                        addbuff2[add2] = ird2.ReadInt32();

                    }
                    ird2.Close();

                    byte[] data1 = new byte[(int.Parse(file1end.Text) - int.Parse(file1begin.Text) + 1) * rangeridx[add]];
                    byte[] data2 = new byte[(int.Parse(file2end.Text) - int.Parse(file2begin.Text) + 1) * rangeridx[add]];
                    byte[][] data = new byte[6][];

                    grp1 = new FileStream(file1grp, FileMode.Open);

                    BinaryReader grd1 = new BinaryReader(grp1);
                    grp1.Seek(0, SeekOrigin.Begin);
                    data[0] = grd1.ReadBytes(836);
                    data[1] = grd1.ReadBytes(addbuff[1] - addbuff[0]);
                    data[2] = grd1.ReadBytes(addbuff[2] - addbuff[1]);
                    data[3] = grd1.ReadBytes(addbuff[3] - addbuff[2]);
                    data[4] = grd1.ReadBytes(addbuff[4] - addbuff[3]);
                    data[5] = grd1.ReadBytes(addbuff[5] - addbuff[4]);

                    grp1.Seek((addbuff[add] + int.Parse(file1begin.Text) * rangeridx[add]), SeekOrigin.Begin);
                    data1 = grd1.ReadBytes(data1.Length);
                    grd1.Close();

                    grp2 = new FileStream(file2grp, FileMode.Open);
                    BinaryReader grd2 = new BinaryReader(grp2);
                    grp2.Seek((addbuff2[add] + int.Parse(file2begin.Text) * rangeridx[add]), SeekOrigin.Begin);
                    data2 = grd2.ReadBytes(data2.Length);


                    int[] sizeofranger = new int[6];
                    grd2.Close();

                    grp3 = new FileStream(grpsave.FileName, FileMode.Create);
                    idx3 = new FileStream(idxsave.FileName, FileMode.Create);
                    BinaryWriter gwt1 = new BinaryWriter(grp3);
                    BinaryWriter iwt1 = new BinaryWriter(idx3);

                    grp3.Seek(0, SeekOrigin.Begin);
                    gwt1.Write(data[0], 0, data[0].Length);
                    sizeofranger[0] = data[0].Length;
                    switch (add)
                    {
                        case 0:
                            gwt1.Write(data1, 0, data1.Length);
                            gwt1.Write(data2, 0, data2.Length);
                            sizeofranger[1] = data1.Length + data2.Length;
                            gwt1.Write(data[2], 0, data[2].Length);
                            sizeofranger[2] = data[2].Length;
                            gwt1.Write(data[3], 0, data[3].Length);
                            sizeofranger[3] = data[3].Length;
                            gwt1.Write(data[4], 0, data[4].Length);
                            sizeofranger[4] = data[4].Length;
                            break;
                        case 1:
                            gwt1.Write(data[1], 0, data[1].Length);
                            sizeofranger[1] = data[1].Length;
                            gwt1.Write(data1, 0, data1.Length);
                            gwt1.Write(data2, 0, data2.Length);
                            sizeofranger[2] = data1.Length + data2.Length;
                            gwt1.Write(data[3], 0, data[3].Length);
                            sizeofranger[3] = data[3].Length;
                            gwt1.Write(data[4], 0, data[4].Length);
                            sizeofranger[4] = data[4].Length;
                            break;
                        case 2:
                            gwt1.Write(data[1], 0, data[1].Length);
                            sizeofranger[1] = data[1].Length;
                            gwt1.Write(data[2], 0, data[2].Length);
                            sizeofranger[2] = data[2].Length;
                            gwt1.Write(data1, 0, data1.Length);
                            gwt1.Write(data2, 0, data2.Length);
                            sizeofranger[3] = data1.Length + data2.Length;
                            gwt1.Write(data[4], 0, data[4].Length);
                            sizeofranger[4] = data[4].Length;
                            break;
                        case 3:
                            gwt1.Write(data[1], 0, data[1].Length);
                            sizeofranger[1] = data[1].Length;
                            gwt1.Write(data[2], 0, data[2].Length);
                            sizeofranger[2] = data[2].Length;
                            gwt1.Write(data[3], 0, data[3].Length);
                            sizeofranger[3] = data[3].Length;
                            gwt1.Write(data1, 0, data1.Length);
                            gwt1.Write(data2, 0, data2.Length);
                            sizeofranger[4] = data1.Length + data2.Length;
                            break;
                    }

                    gwt1.Write(data[5], 0, data[5].Length);
                    sizeofranger[5] = data[5].Length;
                    idx3.Seek(0, SeekOrigin.Begin);
                    iwt1.Write(sizeofranger[0]);
                    iwt1.Write(sizeofranger[1] + sizeofranger[0]);
                    iwt1.Write(sizeofranger[2] + sizeofranger[1] + sizeofranger[0]);
                    iwt1.Write(sizeofranger[3] + sizeofranger[2] + sizeofranger[1] + sizeofranger[0]);
                    iwt1.Write(sizeofranger[4] + sizeofranger[3] + sizeofranger[2] + sizeofranger[1] + sizeofranger[0]);
                    iwt1.Write(sizeofranger[5] + sizeofranger[4] + sizeofranger[3] + sizeofranger[2] + sizeofranger[1] + sizeofranger[0]);

                    gwt1.Close();
                    iwt1.Close();
                    grp1.Close();
                    grp2.Close();
                    grp3.Close();
                    idx1.Close();
                    idx2.Close();
                    idx3.Close();

                    MessageBox.Show("合并成功");
                }

            }
        }

        private void Form1_Load(object sender, EventArgs e)
        {

        }


    }
}