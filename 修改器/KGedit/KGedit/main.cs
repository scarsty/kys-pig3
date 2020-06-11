using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Text;
using System.Windows.Forms;

namespace WindowsApplication1
{
    public partial class main : Form
    {
        public main()
        {
            InitializeComponent();
        }

        private void button1_Click(object sender, EventArgs e)
        {
            rfile a = new rfile();
            a.Show();
        }

        private void button2_Click(object sender, EventArgs e)
        {
            war a = new war();
            a.Show();
        }

        private void button3_Click(object sender, EventArgs e)
        {
            kdefedit a = new kdefedit();
            a.Show();

        }
        private void button4_Click(object sender, EventArgs e)
        {
            zedit a = new zedit();
            a.Show();
        }
        private void button5_Click(object sender, EventArgs e)
        {
            map a = new map();
            a.Show();
        }

        private void button6_Click(object sender, EventArgs e)
        {
            txt2grp.txt2grp a = new txt2grp.txt2grp();
            a.Show();
        }
    }
}