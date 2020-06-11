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
    public partial class stringmod : Form
    {
        FileStream z;
        BinaryReader zread;
        public stringmod(FileStream a,BinaryReader b)
        {
            z = a;
            zread = b;
            InitializeComponent();
            
        }
        void tobig5(long address,int length,TextBox tb)
        {
            byte[] Cwords2 = new byte[length];
            byte[] big5bytes = new byte[length];
            z.Seek(address, SeekOrigin.Begin);
            big5bytes = zread.ReadBytes(length);
            tb.Text = System.Text.Encoding.GetEncoding("BIG5").GetString(big5bytes);            
        }
    }
}