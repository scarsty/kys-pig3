using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Text;
using System.Windows.Forms;
using System.Runtime.InteropServices;
using pig3config;
using System.Net;
using imzopr;
using DeCompression;
using System.IO;
using System.Threading;
namespace pig3Launcher
{
    public partial class Form1 : Form
    {
        public bool canStartGame = true;
        public imzopr.inireader iniReader = null;
        [DllImport("user32.dll")]
        public static extern bool SendMessage(IntPtr hwnd, int wMsg, int wParam, int lParam);
        [DllImport("user32.dll")]
        public static extern bool ReleaseCapture();

            public enum DownloadType
            {
                FiniteList = 0,
                GameData = 1,
            }
            public void DownLoadFromInternet(string remoteUri, DownloadType type)
            {
                //创建WebClient实例
                Uri uri = new Uri(remoteUri);
                WebClient myWebClient = new WebClient();
                // 下载保存文件到程序运行目录下
                switch (type)
                {
                    case DownloadType.FiniteList:
                        myWebClient.DownloadProgressChanged += myWebClient_DownloadProgressChanged;
                        myWebClient.DownloadDataCompleted += myWebClient_DownloadDataCompleted;
                        break;
                    case DownloadType.GameData:
                        myWebClient.DownloadProgressChanged += myWebClient_DownloadProgressChanged;
                        myWebClient.DownloadDataCompleted += myWebClient_DownloadDataCompleted1;
                        break;

                }
                myWebClient.DownloadDataAsync(uri, this);
            }
            static void myWebClient_DownloadDataCompleted1(object sender, DownloadDataCompletedEventArgs e)
            {
                
                Form1 frm = (Form1)e.UserState;
                Application.DoEvents();
                byte[] tmp = e.Result;
                UnZipClass unzip = new UnZipClass();
                unzip.UnZip(tmp, @".\");
                
                string tmpv = frm.iniReader.ReadIniString("pig3", "nv");
                if (tmpv.Equals(frm.getVersions()))
                {
                    frm.canStartGame = true;
                    frm.label6.Text = "更新完毕，请点击开始游戏进行游戏！";
                    return;
                }
                else
                {
                    string newUrls = frm.iniReader.ReadIniString("pig3", "v" + frm.getVersions().ToString());
                    if (newUrls != string.Empty)
                    {
                        frm.DownLoadFromInternet(string.Format(@"{0}/{1}", "http://svn.mythkast.net:8088", newUrls), DownloadType.GameData);
                    }
                }
            }

            static void myWebClient_DownloadDataCompleted(object sender, DownloadDataCompletedEventArgs e)
            {
                Form1 frm = (Form1)e.UserState;
                if (e.Error == null && e.Cancelled == false)
                {
                    Application.DoEvents();
                    byte[] tmp = e.Result;
                    frm.iniReader = new inireader(new MemoryStream(tmp));

                    string tmpv = frm.iniReader.ReadIniString("pig3", "nv");
                    if (tmpv.Equals(frm.getVersions()))
                    {
                        frm.canStartGame = true;
                        frm.label1.Text = "当前版本：" + frm.getVersions();
                        frm.label6.Text = "更新完毕，请点击开始游戏进行游戏！";
                        return;
                    }
                    else
                    {
                        string newUrls = frm.iniReader.ReadIniString("pig3", "v" + frm.getVersions().ToString());
                        if (newUrls != string.Empty)
                        {
                            frm.DownLoadFromInternet(string.Format(@"{0}/{1}", "http://svn.mythkast.net:8088", newUrls), DownloadType.GameData);
                        }
                        else
                        {
                            newUrls = frm.iniReader.ReadIniString("pig3", "v" + tmpv.ToString());
                            if (newUrls != string.Empty)
                            {
                                frm.DownLoadFromInternet(string.Format(@"{0}/{1}", "http://svn.mythkast.net:8088", newUrls), DownloadType.GameData);
                            }
                            else
                            {
                                MessageBox.Show("下载失败！");
                                frm.canStartGame = true;

                            }
                        }
                    }
                }
                else
                {
                    MessageBox.Show("下载失败！");
                    frm.canStartGame = true;
                }
            }

            static void myWebClient_DownloadProgressChanged(object sender, DownloadProgressChangedEventArgs e)
            {
                Form1 frm = (Form1)e.UserState;
                frm.progressBar1.Maximum = 100;
                frm.progressBar1.Value = e.ProgressPercentage;
                frm.label6.Text = string.Format("downloaded {0} of {1} bytes. {2} % complete...",
                    e.BytesReceived,
                    e.TotalBytesToReceive,
                    e.ProgressPercentage);
                Application.DoEvents();
                //frm.Refresh();
                //throw new NotImplementedException();
            }
        public static class Process
        {
            /// <summary>  
            /// 以命令行方式操作一个文件  
            /// </summary>  
            /// <param name="CommandLine">命令行</param>  
            public static void ShellExecute(String CommandLine)
            {
                // 创建进程  
                System.Diagnostics.Process pro = new System.Diagnostics.Process();

                // 分离文件名和路径  
                // 定位路径  
                int IndexA = CommandLine.LastIndexOf('\\');
                if (IndexA >= 0)
                {   // 设定工作目录  
                    pro.StartInfo.WorkingDirectory = CommandLine.Substring(0, IndexA);
                }

                // 定位文件名，判断是否带参数  
                IndexA++;
                int IndexB = CommandLine.IndexOf(' ', IndexA);
                if (IndexB >= 0)
                {   // 带有参数  
                    pro.StartInfo.FileName = CommandLine.Substring(IndexA, IndexB - IndexA);
                    pro.StartInfo.Arguments = CommandLine.Substring(IndexB + 1);
                }
                else
                {   // 不带参数  
                    pro.StartInfo.FileName = CommandLine.Substring(IndexA);
                }

                pro.Start();
            }
        }
        void startDownLoad()
        {
            DownLoadFromInternet("http://svn.mythkast.net:8088/list.txt", DownloadType.FiniteList);
        }
        string getVersions()
        {
            try
            {

                System.Diagnostics.FileVersionInfo newVersion = System.Diagnostics.FileVersionInfo.GetVersionInfo(System.Environment.CurrentDirectory + "\\bin\\kys_pig3.exe");
                return newVersion.FileVersion.ToString();
            }
            catch
            {
                return string.Empty;
            }
            
        }
        public Form1()
        {
            InitializeComponent();
            CheckForIllegalCrossThreadCalls = false;
            this.FormClosed += Form1_FormClosed;
        }

        void Form1_FormClosed(object sender, FormClosedEventArgs e)
        {
            for (double d = 1; d >= 0.01; d -= 0.2)
            {
                System.Threading.Thread.Sleep(1);
                Application.DoEvents();
                this.Opacity = d;
                this.Refresh();
            }
            //throw new NotImplementedException();
        }

        private void button1_Click(object sender, EventArgs e)
        {
            try{
                if (canStartGame)
                {
                    Process.ShellExecute(@".\bin\kys_pig3.exe");
                    Application.Exit();
                }
                else
                {
                    MessageBox.Show("请等待更新");
                }
            }catch(Exception ee){
                MessageBox.Show("未找到exe文件，启动程序失败");
            }
        }

        private void linkLabel1_LinkClicked(object sender, LinkLabelLinkClickedEventArgs e)
        {
            //System.Diagnostics.Process.Start("iexplore.exe", "http://www.ttiexuedanxin.net");
            System.Diagnostics.ProcessStartInfo Info = new System.Diagnostics.ProcessStartInfo("http://www.tiexuedanxin.net");
            System.Diagnostics.Process Pro = System.Diagnostics.Process.Start(Info);
        }

        private void Form1_Paint(object sender, PaintEventArgs e)
        {
        }
        Thread thread;
        private void Form1_Load(object sender, EventArgs e)
        {
            panel1.Parent = pictureBox1;
            panel1.BackColor = Color.Transparent;
            label1.Parent = panel1;
            label1.BackColor = Color.Transparent;
            for (double d = 0.01; d < 1; d += 0.02)
            {
                System.Threading.Thread.Sleep(1);
                Application.DoEvents();
                this.Opacity = d;
                this.Refresh();
            }
            //System.Diagnostics.FileVersionInfo newVersion = System.Diagnostics.FileVersionInfo.GetVersionInfo(System.Environment.CurrentDirectory + "\\bin\\kys_pig3.exe");
            label1.Text = "当前版本：" + getVersions();
            this.Refresh();
        }

        private void button3_Click(object sender, EventArgs e)
        {
            //Form1_FormClosed(null, null);
            //thread.Abort();
            Application.Exit();
        }

        private void pictureBox1_MouseMove(object sender, MouseEventArgs e)
        {
            if (e.Button == MouseButtons.Left)
            {
                ReleaseCapture();
                SendMessage(this.Handle, 0x112, 0xf010 + 0x2, 0);
            }
        }

        private void pictureBox1_MouseDown(object sender, MouseEventArgs e)
        {
            ReleaseCapture();
            SendMessage(this.Handle, 0x112, 0xf010 + 0x2, 0);
        }

        private void pictureBox1_MouseUp(object sender, MouseEventArgs e)
        {
           
        }

        private void button2_Click(object sender, EventArgs e)
        {
            frmconfig frm = new frmconfig();
            frm.Show();
        }

        private void button4_Click(object sender, EventArgs e)
        {
            try
            {
                if (canStartGame)
                {
                    Process.ShellExecute(@".\bin\kys_pig3.exe 0");
                    Application.Exit();
                }
                else
                {
                    MessageBox.Show("请等待更新");
                }
            }
            catch (Exception ee)
            {
                MessageBox.Show("未找到exe文件，启动程序失败");
            }
        }

    }
}
