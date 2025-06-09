using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Text;
using System.Windows.Forms;
using System.Runtime.InteropServices;

namespace pig3config
{
    public partial class frmconfig : Form
    {
        [DllImport("kernel32")]  
        private static extern long WritePrivateProfileString(
            string section, string key, string val, string filePath);
        [DllImport("kernel32")]
        private static extern int GetPrivateProfileString(
            string section, string key,
            string def, StringBuilder retVal,
            int size, string filePath);
        String iniPath;
        public frmconfig()
        {
            InitializeComponent();
            this.FormClosed += Form1_FormClosed;

           // iniPath = System.Diagnostics.Process.GetCurrentProcess().MainModule.FileName;
           // iniPath = iniPath.Substring(0, iniPath.LastIndexOf(@"\")) + "\\kysmod.ini";
            iniPath = @".\game\config\kysmod.ini";
            configIniValueAll(0);

            WALK_SPEED0.ValueChanged += (s, e) => WALK_SPEED1.Value = WALK_SPEED0.Value;
            walk_speed20.ValueChanged += (s, e) => walk_speed21.Value = walk_speed20.Value;
            battle_speed0.ValueChanged += (s, e) => battle_speed1.Value = battle_speed0.Value;
            VOLUME0.ValueChanged += (s, e) => VOLUME1.Value = VOLUME0.Value;
            VOLUMEWAV0.ValueChanged += (s, e) => VOLUMEWAV1.Value = VOLUMEWAV0.Value;

            WALK_SPEED1.KeyUp += (s, e) => WALK_SPEED0.Value = Convert.ToInt32(WALK_SPEED1.Value);
            WALK_SPEED1.ValueChanged += (s, e) => WALK_SPEED0.Value = Convert.ToInt32(WALK_SPEED1.Value);
            walk_speed21.KeyUp += (s, e) => walk_speed20.Value = Convert.ToInt32(walk_speed21.Value);
            walk_speed21.ValueChanged += (s, e) => walk_speed20.Value = Convert.ToInt32(walk_speed21.Value);
            battle_speed1.KeyUp += (s, e) => battle_speed0.Value = Convert.ToInt32(battle_speed1.Value);
            battle_speed1.ValueChanged += (s, e) => battle_speed0.Value = Convert.ToInt32(battle_speed1.Value);
            VOLUME1.KeyUp += (s, e) => VOLUME0.Value = Convert.ToInt32(VOLUME1.Value);
            VOLUME1.ValueChanged += (s, e) => VOLUME0.Value = Convert.ToInt32(VOLUME1.Value);
            VOLUMEWAV1.KeyUp += (s, e) => VOLUMEWAV0.Value = Convert.ToInt32(VOLUMEWAV1.Value);
            VOLUMEWAV1.ValueChanged += (s, e) => VOLUMEWAV0.Value = Convert.ToInt32(VOLUMEWAV1.Value);

        }
        void Form1_FormClosed(object sender, FormClosedEventArgs e)
        {

        }


        void configIniValue(int flag,String s,String k)
        {
            if (flag == 0) getIniValue(s,k);
            else if(flag==1)setIniValue(s, k);
        }
        void getIniValue(String s, String k)
        {
            StringBuilder temp = new StringBuilder(255);
            GetPrivateProfileString(s, k, "", temp, 255, iniPath);
            int v = 0;
            try
            {
                v = Convert.ToInt32(temp.ToString());
            }catch(Exception ee){
                return;
            }
            if (k == "SMOOTH")
            {
                if (v == 0) SMOOTH0.Checked = true;
                else if (v == 1) SMOOTH1.Checked = true;
                else if (v == 2) SMOOTH2.Checked = true;
                return;
            }
            if (k == "RENDERER")
            {
                if (v == 0) RENDERER0.Checked = true;
                else if (v == 1) RENDERER1.Checked = true;
                else if (v == 2) RENDERER2.Checked = true;
                return;
            }
            if (k == "WALK_SPEED")
            {
                WALK_SPEED0.Value = v;
                WALK_SPEED1.Value = v;
                return;
            }
            if (k == "walk_speed2")
            {
                walk_speed20.Value = v;
                walk_speed21.Value = v;
                return;
            }
            if (k == "battle_speed")
            {
                battle_speed0.Value = v;
                battle_speed1.Value = v;
                return;
            }
            if (k == "VOLUME")
            {
                VOLUME0.Value = v;
                VOLUME1.Value = v;
                return;
            }
            if (k == "VOLUMEWAV")
            {
                VOLUMEWAV0.Value = v;
                VOLUMEWAV1.Value = v;
                return;
            }
            foreach (Control cc in this.groupBox1.Controls)
            {
                if (k == cc.Name &&
                    cc.GetType().ToString().Substring(
                        cc.GetType().ToString().LastIndexOf(@".") + 1)=="CheckBox")
                {
                    ((CheckBox)cc).Checked = v == 1;
                    return;
                }
            }
            foreach (Control cc in this.groupBox3.Controls)
            {
                if (k == cc.Name &&
                    cc.GetType().ToString().Substring(
                        cc.GetType().ToString().LastIndexOf(@".") + 1) == "CheckBox")
                {
                    ((CheckBox)cc).Checked = v == 1;
                    return;
                }
            }
        }
        void setIniValue(String s, String k)
        {
            int v=0;
            if (k == "SMOOTH")
            {
                if (SMOOTH0.Checked) v=0;
                else if (SMOOTH1.Checked) v=1;
                else if (SMOOTH2.Checked) v=2;
                WritePrivateProfileString(s, k, Convert.ToString(v), iniPath);
                return;
            }
            if (k == "RENDERER")
            {
                if (RENDERER0.Checked) v=0;
                else if (RENDERER1.Checked) v=1;
                else if (RENDERER2.Checked) v=2;
                WritePrivateProfileString(s, k, Convert.ToString(v), iniPath);
                return;
            }
            if (k == "WALK_SPEED")
            {
                v=Convert.ToInt32(WALK_SPEED1.Value);
                WritePrivateProfileString(s, k, Convert.ToString(v), iniPath);
                return;
            }
            if (k == "walk_speed2")
            {
                v=Convert.ToInt32(walk_speed21.Value);
                WritePrivateProfileString(s, k, Convert.ToString(v), iniPath);
                return;
            }
            if (k == "battle_speed")
            {
                v = Convert.ToInt32(battle_speed1.Value);
                WritePrivateProfileString(s, k, Convert.ToString(v), iniPath);
                return;
            }
            if (k == "VOLUME")
            {
                v = Convert.ToInt32(VOLUME1.Value);
                WritePrivateProfileString(s, k, Convert.ToString(v), iniPath);
                return;
            }
            if (k == "VOLUMEWAV")
            {
                v = Convert.ToInt32(VOLUMEWAV1.Value);
                WritePrivateProfileString(s, k, Convert.ToString(v), iniPath);
                return;
            }
            foreach (Control cc in this.groupBox1.Controls)
            {
                if (k == cc.Name &&
                    cc.GetType().ToString().Substring(
                        cc.GetType().ToString().LastIndexOf(@".") + 1) == "CheckBox")
                {
                    if (((CheckBox)cc).Checked) v = 1;
                    else v = 0;
                    WritePrivateProfileString(s, k, Convert.ToString(v), iniPath);
                    return;
                }
            }
            foreach (Control cc in this.groupBox3.Controls)
            {
                if (k == cc.Name &&
                    cc.GetType().ToString().Substring(
                        cc.GetType().ToString().LastIndexOf(@".") + 1) == "CheckBox")
                {
                    if (((CheckBox)cc).Checked) v = 1;
                    else v = 0;
                    WritePrivateProfileString(s, k, Convert.ToString(v), iniPath);
                    return;
                }
            }
        }

        private void Form1_Load(object sender, EventArgs e)
        {

        }

        private void button1_Click(object sender, EventArgs e)
        {
            configIniValueAll(1);
            iniPath = @".\game0\config\kysmod.ini";
            configIniValueAll(1);
            MessageBox.Show("保存成功！");
        }

        private void configIniValueAll(int i)
        {
            configIniValue(i, "system", "SMOOTH");
            configIniValue(i, "system", "RENDERER");
            configIniValue(i, "system", "sw_surface");
            configIniValue(i, "system", "sw_output");

            configIniValue(i, "system", "PNG_LOAD_ALL");
            configIniValue(i, "system", "EXIT_GAME");
            configIniValue(i, "system", "WALK_SPEED");
            configIniValue(i, "system", "semireal");
            configIniValue(i, "system", "walk_speed2");

            configIniValue(i, "system", "fullscreen");
            configIniValue(i, "system", "simple");
            configIniValue(i, "system", "text_layer");
            configIniValue(i, "system", "zip_save");
            configIniValue(i, "system", "battle_speed");

            configIniValue(i, "system", "EFFECT_STRING");
            configIniValue(i, "system", "OPEN_MOVIE");
            configIniValue(i, "system", "KEEP_SCREEN_RATIO");
            configIniValue(i, "system", "EXPAND_GROUND");

            configIniValue(i, "system", "present_sync");
            configIniValue(i, "system", "FONT_VIDEOMEMERY");
            configIniValue(i, "system", "auto_levelup");
            configIniValue(i, "system", "THREAD_READ_PNG");
            configIniValue(i, "Music", "VOLUME");
            configIniValue(i, "Music", "VOLUMEWAV");
            configIniValue(i, "Music", "SOUND3D");
        }

        private void pictureBox1_Click(object sender, EventArgs e)
        {

        }

        private void button2_Click(object sender, EventArgs e)
        {
            this.Close();
        }
    }
}
