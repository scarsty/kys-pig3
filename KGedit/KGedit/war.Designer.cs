namespace WindowsApplication1
{
    partial class war
    {
        /// <summary>
        /// 必需的设计器变量。
        /// </summary>
        private System.ComponentModel.IContainer components = null;

        /// <summary>
        /// 清理所有正在使用的资源。
        /// </summary>
        /// <param name="disposing">如果应释放托管资源，为 true；否则为 false。</param>
        protected override void Dispose(bool disposing)
        {
            if (disposing && (components != null))
            {
                components.Dispose();
            }
            base.Dispose(disposing);
        }

        #region Windows 窗体设计器生成的代码

        /// <summary>
        /// 设计器支持所需的方法 - 不要
        /// 使用代码编辑器修改此方法的内容。
        /// </summary>
        private void InitializeComponent()
        {
            this.button1 = new System.Windows.Forms.Button();
            this.button2 = new System.Windows.Forms.Button();
            this.begin1 = new System.Windows.Forms.TextBox();
            this.end1 = new System.Windows.Forms.TextBox();
            this.label1 = new System.Windows.Forms.Label();
            this.label2 = new System.Windows.Forms.Label();
            this.begin2 = new System.Windows.Forms.TextBox();
            this.end2 = new System.Windows.Forms.TextBox();
            this.label3 = new System.Windows.Forms.Label();
            this.label4 = new System.Windows.Forms.Label();
            this.waropen = new System.Windows.Forms.OpenFileDialog();
            this.runit = new System.Windows.Forms.Button();
            this.warsave = new System.Windows.Forms.SaveFileDialog();
            this.label5 = new System.Windows.Forms.Label();
            this.label6 = new System.Windows.Forms.Label();
            this.SuspendLayout();
            // 
            // button1
            // 
            this.button1.Location = new System.Drawing.Point(13, 13);
            this.button1.Name = "button1";
            this.button1.Size = new System.Drawing.Size(74, 69);
            this.button1.TabIndex = 0;
            this.button1.Text = "文件1";
            this.button1.UseVisualStyleBackColor = true;
            this.button1.Click += new System.EventHandler(this.button1_Click);
            // 
            // button2
            // 
            this.button2.Enabled = false;
            this.button2.Location = new System.Drawing.Point(12, 100);
            this.button2.Name = "button2";
            this.button2.Size = new System.Drawing.Size(74, 69);
            this.button2.TabIndex = 0;
            this.button2.Text = "文件2";
            this.button2.UseVisualStyleBackColor = true;
            this.button2.Click += new System.EventHandler(this.button2_Click);
            // 
            // begin1
            // 
            this.begin1.Enabled = false;
            this.begin1.Location = new System.Drawing.Point(141, 26);
            this.begin1.Name = "begin1";
            this.begin1.Size = new System.Drawing.Size(100, 21);
            this.begin1.TabIndex = 1;
            // 
            // end1
            // 
            this.end1.Enabled = false;
            this.end1.Location = new System.Drawing.Point(141, 61);
            this.end1.Name = "end1";
            this.end1.Size = new System.Drawing.Size(100, 21);
            this.end1.TabIndex = 1;
            // 
            // label1
            // 
            this.label1.AutoSize = true;
            this.label1.Location = new System.Drawing.Point(93, 35);
            this.label1.Name = "label1";
            this.label1.Size = new System.Drawing.Size(41, 12);
            this.label1.TabIndex = 2;
            this.label1.Text = "起始值";
            // 
            // label2
            // 
            this.label2.AutoSize = true;
            this.label2.Location = new System.Drawing.Point(94, 70);
            this.label2.Name = "label2";
            this.label2.Size = new System.Drawing.Size(41, 12);
            this.label2.TabIndex = 2;
            this.label2.Text = "结束值";
            // 
            // begin2
            // 
            this.begin2.Enabled = false;
            this.begin2.Location = new System.Drawing.Point(141, 113);
            this.begin2.Name = "begin2";
            this.begin2.Size = new System.Drawing.Size(100, 21);
            this.begin2.TabIndex = 1;
            // 
            // end2
            // 
            this.end2.Enabled = false;
            this.end2.Location = new System.Drawing.Point(141, 148);
            this.end2.Name = "end2";
            this.end2.Size = new System.Drawing.Size(100, 21);
            this.end2.TabIndex = 1;
            // 
            // label3
            // 
            this.label3.AutoSize = true;
            this.label3.Location = new System.Drawing.Point(93, 122);
            this.label3.Name = "label3";
            this.label3.Size = new System.Drawing.Size(41, 12);
            this.label3.TabIndex = 2;
            this.label3.Text = "起始值";
            // 
            // label4
            // 
            this.label4.AutoSize = true;
            this.label4.Location = new System.Drawing.Point(94, 157);
            this.label4.Name = "label4";
            this.label4.Size = new System.Drawing.Size(41, 12);
            this.label4.TabIndex = 2;
            this.label4.Text = "结束值";
            // 
            // waropen
            // 
            this.waropen.FileName = "war.sta";
            // 
            // runit
            // 
            this.runit.Location = new System.Drawing.Point(12, 189);
            this.runit.Name = "runit";
            this.runit.Size = new System.Drawing.Size(228, 25);
            this.runit.TabIndex = 3;
            this.runit.Text = "合并";
            this.runit.UseVisualStyleBackColor = true;
            this.runit.Click += new System.EventHandler(this.runit_Click);
            // 
            // warsave
            // 
            this.warsave.FileName = "war.sta";
            // 
            // label5
            // 
            this.label5.AutoSize = true;
            this.label5.Location = new System.Drawing.Point(249, 30);
            this.label5.Name = "label5";
            this.label5.Size = new System.Drawing.Size(41, 12);
            this.label5.TabIndex = 4;
            this.label5.Text = "范围：";
            // 
            // label6
            // 
            this.label6.AutoSize = true;
            this.label6.Location = new System.Drawing.Point(249, 116);
            this.label6.Name = "label6";
            this.label6.Size = new System.Drawing.Size(41, 12);
            this.label6.TabIndex = 4;
            this.label6.Text = "范围：";
            // 
            // war
            // 
            this.AutoScaleDimensions = new System.Drawing.SizeF(6F, 12F);
            this.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font;
            this.ClientSize = new System.Drawing.Size(377, 232);
            this.Controls.Add(this.label6);
            this.Controls.Add(this.label5);
            this.Controls.Add(this.runit);
            this.Controls.Add(this.label4);
            this.Controls.Add(this.label3);
            this.Controls.Add(this.label2);
            this.Controls.Add(this.end2);
            this.Controls.Add(this.label1);
            this.Controls.Add(this.begin2);
            this.Controls.Add(this.end1);
            this.Controls.Add(this.begin1);
            this.Controls.Add(this.button2);
            this.Controls.Add(this.button1);
            this.Name = "war";
            this.Text = "war文件合并";
            this.ResumeLayout(false);
            this.PerformLayout();

        }

        #endregion

        private System.Windows.Forms.Button button1;
        private System.Windows.Forms.Button button2;
        private System.Windows.Forms.TextBox begin1;
        private System.Windows.Forms.TextBox end1;
        private System.Windows.Forms.Label label1;
        private System.Windows.Forms.Label label2;
        private System.Windows.Forms.TextBox begin2;
        private System.Windows.Forms.TextBox end2;
        private System.Windows.Forms.Label label3;
        private System.Windows.Forms.Label label4;
        private System.Windows.Forms.OpenFileDialog waropen;
        private System.Windows.Forms.Button runit;
        private System.Windows.Forms.SaveFileDialog warsave;
        private System.Windows.Forms.Label label5;
        private System.Windows.Forms.Label label6;
    }
}