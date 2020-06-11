VERSION 5.00
Begin VB.Form FrmWarEdit 
   Caption         =   "Waredit"
   ClientHeight    =   7125
   ClientLeft      =   60
   ClientTop       =   345
   ClientWidth     =   10860
   BeginProperty Font 
      Name            =   "Times New Roman"
      Size            =   9
      Charset         =   0
      Weight          =   400
      Underline       =   0   'False
      Italic          =   0   'False
      Strikethrough   =   0   'False
   EndProperty
   LinkTopic       =   "Form2"
   MDIChild        =   -1  'True
   ScaleHeight     =   475
   ScaleMode       =   3  'Pixel
   ScaleWidth      =   724
   WindowState     =   2  'Maximized
   Begin VB.TextBox txtwarname 
      Height          =   375
      Left            =   3480
      TabIndex        =   154
      Top             =   600
      Width           =   1815
   End
   Begin VB.CommandButton cmddelwar 
      Caption         =   "deletewar"
      Height          =   375
      Left            =   9720
      TabIndex        =   153
      Top             =   5400
      Width           =   975
   End
   Begin VB.CommandButton cmdaddwar 
      Caption         =   "addwar"
      Height          =   375
      Left            =   9720
      TabIndex        =   152
      Top             =   4440
      Width           =   975
   End
   Begin VB.CommandButton cmdshow 
      Caption         =   "showpic"
      BeginProperty Font 
         Name            =   "ËÎÌו"
         Size            =   9
         Charset         =   134
         Weight          =   400
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Height          =   375
      Left            =   6120
      TabIndex        =   151
      Top             =   600
      Width           =   1815
   End
   Begin VB.CommandButton cmdcancel 
      Caption         =   "cancel"
      Height          =   375
      Left            =   9720
      TabIndex        =   150
      Top             =   3120
      Width           =   975
   End
   Begin VB.CommandButton cmdsave 
      Caption         =   "save"
      Height          =   375
      Left            =   9720
      TabIndex        =   149
      Top             =   2160
      Width           =   975
   End
   Begin VB.CommandButton cmdedit 
      Caption         =   "edit"
      Height          =   375
      Left            =   9720
      TabIndex        =   148
      Top             =   1320
      Width           =   975
   End
   Begin VB.TextBox txtenemyy 
      Height          =   270
      Index           =   19
      Left            =   8640
      TabIndex        =   147
      Top             =   6480
      Width           =   495
   End
   Begin VB.TextBox txtenemyX 
      Height          =   270
      Index           =   19
      Left            =   7920
      TabIndex        =   144
      Top             =   6480
      Width           =   495
   End
   Begin VB.ComboBox Comboenemy 
      Height          =   345
      Index           =   19
      Left            =   7800
      Style           =   2  'Dropdown List
      TabIndex        =   143
      Top             =   6120
      Width           =   1455
   End
   Begin VB.TextBox txtenemyy 
      Height          =   270
      Index           =   18
      Left            =   6720
      TabIndex        =   142
      Top             =   6480
      Width           =   495
   End
   Begin VB.TextBox txtenemyX 
      Height          =   270
      Index           =   18
      Left            =   6000
      TabIndex        =   139
      Top             =   6480
      Width           =   495
   End
   Begin VB.ComboBox Comboenemy 
      Height          =   345
      Index           =   18
      Left            =   5880
      Style           =   2  'Dropdown List
      TabIndex        =   138
      Top             =   6120
      Width           =   1455
   End
   Begin VB.TextBox txtenemyy 
      Height          =   270
      Index           =   17
      Left            =   4800
      TabIndex        =   137
      Top             =   6480
      Width           =   495
   End
   Begin VB.TextBox txtenemyX 
      Height          =   270
      Index           =   17
      Left            =   4080
      TabIndex        =   134
      Top             =   6480
      Width           =   495
   End
   Begin VB.ComboBox Comboenemy 
      Height          =   345
      Index           =   17
      Left            =   3960
      Style           =   2  'Dropdown List
      TabIndex        =   133
      Top             =   6120
      Width           =   1455
   End
   Begin VB.TextBox txtenemyy 
      Height          =   270
      Index           =   16
      Left            =   2880
      TabIndex        =   132
      Top             =   6480
      Width           =   495
   End
   Begin VB.TextBox txtenemyX 
      Height          =   270
      Index           =   16
      Left            =   2160
      TabIndex        =   129
      Top             =   6480
      Width           =   495
   End
   Begin VB.ComboBox Comboenemy 
      Height          =   345
      Index           =   16
      Left            =   2040
      Style           =   2  'Dropdown List
      TabIndex        =   128
      Top             =   6120
      Width           =   1455
   End
   Begin VB.TextBox txtenemyy 
      Height          =   270
      Index           =   15
      Left            =   960
      TabIndex        =   127
      Top             =   6480
      Width           =   495
   End
   Begin VB.TextBox txtenemyX 
      Height          =   270
      Index           =   15
      Left            =   240
      TabIndex        =   124
      Top             =   6480
      Width           =   495
   End
   Begin VB.ComboBox Comboenemy 
      Height          =   345
      Index           =   15
      Left            =   120
      Style           =   2  'Dropdown List
      TabIndex        =   123
      Top             =   6120
      Width           =   1455
   End
   Begin VB.TextBox txtenemyy 
      Height          =   270
      Index           =   14
      Left            =   8640
      TabIndex        =   122
      Top             =   5640
      Width           =   495
   End
   Begin VB.TextBox txtenemyX 
      Height          =   270
      Index           =   14
      Left            =   7920
      TabIndex        =   119
      Top             =   5640
      Width           =   495
   End
   Begin VB.ComboBox Comboenemy 
      Height          =   345
      Index           =   14
      Left            =   7800
      Style           =   2  'Dropdown List
      TabIndex        =   118
      Top             =   5280
      Width           =   1455
   End
   Begin VB.TextBox txtenemyy 
      Height          =   270
      Index           =   13
      Left            =   6720
      TabIndex        =   117
      Top             =   5640
      Width           =   495
   End
   Begin VB.TextBox txtenemyX 
      Height          =   270
      Index           =   13
      Left            =   6000
      TabIndex        =   114
      Top             =   5640
      Width           =   495
   End
   Begin VB.ComboBox Comboenemy 
      Height          =   345
      Index           =   13
      Left            =   5880
      Style           =   2  'Dropdown List
      TabIndex        =   113
      Top             =   5280
      Width           =   1455
   End
   Begin VB.TextBox txtenemyy 
      Height          =   270
      Index           =   12
      Left            =   4800
      TabIndex        =   112
      Top             =   5640
      Width           =   495
   End
   Begin VB.TextBox txtenemyX 
      Height          =   270
      Index           =   12
      Left            =   4080
      TabIndex        =   109
      Top             =   5640
      Width           =   495
   End
   Begin VB.ComboBox Comboenemy 
      Height          =   345
      Index           =   12
      Left            =   3960
      Style           =   2  'Dropdown List
      TabIndex        =   108
      Top             =   5280
      Width           =   1455
   End
   Begin VB.TextBox txtenemyy 
      Height          =   270
      Index           =   11
      Left            =   2880
      TabIndex        =   107
      Top             =   5640
      Width           =   495
   End
   Begin VB.TextBox txtenemyX 
      Height          =   270
      Index           =   11
      Left            =   2160
      TabIndex        =   104
      Top             =   5640
      Width           =   495
   End
   Begin VB.ComboBox Comboenemy 
      Height          =   345
      Index           =   11
      Left            =   2040
      Style           =   2  'Dropdown List
      TabIndex        =   103
      Top             =   5280
      Width           =   1455
   End
   Begin VB.TextBox txtenemyy 
      Height          =   270
      Index           =   10
      Left            =   960
      TabIndex        =   102
      Top             =   5640
      Width           =   495
   End
   Begin VB.TextBox txtenemyX 
      Height          =   270
      Index           =   10
      Left            =   240
      TabIndex        =   99
      Top             =   5640
      Width           =   495
   End
   Begin VB.ComboBox Comboenemy 
      Height          =   345
      Index           =   10
      Left            =   120
      Style           =   2  'Dropdown List
      TabIndex        =   98
      Top             =   5280
      Width           =   1455
   End
   Begin VB.TextBox txtenemyy 
      Height          =   270
      Index           =   9
      Left            =   8640
      TabIndex        =   97
      Top             =   4800
      Width           =   495
   End
   Begin VB.TextBox txtenemyX 
      Height          =   270
      Index           =   9
      Left            =   7920
      TabIndex        =   94
      Top             =   4800
      Width           =   495
   End
   Begin VB.ComboBox Comboenemy 
      Height          =   345
      Index           =   9
      Left            =   7800
      Style           =   2  'Dropdown List
      TabIndex        =   93
      Top             =   4440
      Width           =   1455
   End
   Begin VB.TextBox txtenemyy 
      Height          =   270
      Index           =   8
      Left            =   6720
      TabIndex        =   92
      Top             =   4800
      Width           =   495
   End
   Begin VB.TextBox txtenemyX 
      Height          =   270
      Index           =   8
      Left            =   6000
      TabIndex        =   89
      Top             =   4800
      Width           =   495
   End
   Begin VB.ComboBox Comboenemy 
      Height          =   345
      Index           =   8
      Left            =   5880
      Style           =   2  'Dropdown List
      TabIndex        =   88
      Top             =   4440
      Width           =   1455
   End
   Begin VB.TextBox txtenemyy 
      Height          =   270
      Index           =   7
      Left            =   4800
      TabIndex        =   87
      Top             =   4800
      Width           =   495
   End
   Begin VB.TextBox txtenemyX 
      Height          =   270
      Index           =   7
      Left            =   4080
      TabIndex        =   84
      Top             =   4800
      Width           =   495
   End
   Begin VB.ComboBox Comboenemy 
      Height          =   345
      Index           =   7
      Left            =   3960
      Style           =   2  'Dropdown List
      TabIndex        =   83
      Top             =   4440
      Width           =   1455
   End
   Begin VB.TextBox txtenemyy 
      Height          =   270
      Index           =   6
      Left            =   2880
      TabIndex        =   82
      Top             =   4800
      Width           =   495
   End
   Begin VB.TextBox txtenemyX 
      Height          =   270
      Index           =   6
      Left            =   2160
      TabIndex        =   79
      Top             =   4800
      Width           =   495
   End
   Begin VB.ComboBox Comboenemy 
      Height          =   345
      Index           =   6
      Left            =   2040
      Style           =   2  'Dropdown List
      TabIndex        =   78
      Top             =   4440
      Width           =   1455
   End
   Begin VB.TextBox txtenemyy 
      Height          =   270
      Index           =   5
      Left            =   960
      TabIndex        =   77
      Top             =   4800
      Width           =   495
   End
   Begin VB.TextBox txtenemyX 
      Height          =   270
      Index           =   5
      Left            =   240
      TabIndex        =   74
      Top             =   4800
      Width           =   495
   End
   Begin VB.ComboBox Comboenemy 
      Height          =   345
      Index           =   5
      Left            =   120
      Style           =   2  'Dropdown List
      TabIndex        =   73
      Top             =   4440
      Width           =   1455
   End
   Begin VB.TextBox txtenemyy 
      Height          =   270
      Index           =   4
      Left            =   8640
      TabIndex        =   72
      Top             =   3960
      Width           =   495
   End
   Begin VB.TextBox txtenemyX 
      Height          =   270
      Index           =   4
      Left            =   7920
      TabIndex        =   69
      Top             =   3960
      Width           =   495
   End
   Begin VB.ComboBox Comboenemy 
      Height          =   345
      Index           =   4
      Left            =   7800
      Style           =   2  'Dropdown List
      TabIndex        =   68
      Top             =   3600
      Width           =   1455
   End
   Begin VB.TextBox txtenemyy 
      Height          =   270
      Index           =   3
      Left            =   6720
      TabIndex        =   67
      Top             =   3960
      Width           =   495
   End
   Begin VB.TextBox txtenemyX 
      Height          =   270
      Index           =   3
      Left            =   6000
      TabIndex        =   64
      Top             =   3960
      Width           =   495
   End
   Begin VB.ComboBox Comboenemy 
      Height          =   345
      Index           =   3
      Left            =   5880
      Style           =   2  'Dropdown List
      TabIndex        =   63
      Top             =   3600
      Width           =   1455
   End
   Begin VB.TextBox txtenemyy 
      Height          =   270
      Index           =   2
      Left            =   4800
      TabIndex        =   62
      Top             =   3960
      Width           =   495
   End
   Begin VB.TextBox txtenemyX 
      Height          =   270
      Index           =   2
      Left            =   4080
      TabIndex        =   59
      Top             =   3960
      Width           =   495
   End
   Begin VB.ComboBox Comboenemy 
      Height          =   345
      Index           =   2
      Left            =   3960
      Style           =   2  'Dropdown List
      TabIndex        =   58
      Top             =   3600
      Width           =   1455
   End
   Begin VB.TextBox txtenemyy 
      Height          =   270
      Index           =   1
      Left            =   2880
      TabIndex        =   57
      Top             =   3960
      Width           =   495
   End
   Begin VB.TextBox txtenemyX 
      Height          =   270
      Index           =   1
      Left            =   2160
      TabIndex        =   54
      Top             =   3960
      Width           =   495
   End
   Begin VB.ComboBox Comboenemy 
      Height          =   345
      Index           =   1
      Left            =   2040
      Style           =   2  'Dropdown List
      TabIndex        =   53
      Top             =   3600
      Width           =   1455
   End
   Begin VB.TextBox txtenemyy 
      Height          =   270
      Index           =   0
      Left            =   960
      TabIndex        =   52
      Top             =   3960
      Width           =   495
   End
   Begin VB.TextBox txtenemyX 
      Height          =   270
      Index           =   0
      Left            =   240
      TabIndex        =   49
      Top             =   3960
      Width           =   495
   End
   Begin VB.ComboBox Comboenemy 
      Height          =   345
      Index           =   0
      Left            =   120
      Style           =   2  'Dropdown List
      TabIndex        =   48
      Top             =   3600
      Width           =   1455
   End
   Begin VB.TextBox txtpersony 
      Height          =   270
      Index           =   5
      Left            =   8880
      TabIndex        =   44
      Top             =   2640
      Width           =   495
   End
   Begin VB.TextBox txtpersonx 
      Height          =   270
      Index           =   5
      Left            =   8160
      TabIndex        =   43
      Top             =   2640
      Width           =   495
   End
   Begin VB.TextBox txtpersony 
      Height          =   270
      Index           =   4
      Left            =   7320
      TabIndex        =   40
      Top             =   2640
      Width           =   495
   End
   Begin VB.TextBox txtpersonx 
      Height          =   270
      Index           =   4
      Left            =   6600
      TabIndex        =   39
      Top             =   2640
      Width           =   495
   End
   Begin VB.TextBox txtpersony 
      Height          =   270
      Index           =   3
      Left            =   5760
      TabIndex        =   36
      Top             =   2640
      Width           =   495
   End
   Begin VB.TextBox txtpersonx 
      Height          =   270
      Index           =   3
      Left            =   5040
      TabIndex        =   35
      Top             =   2640
      Width           =   495
   End
   Begin VB.TextBox txtpersony 
      Height          =   270
      Index           =   2
      Left            =   4200
      TabIndex        =   32
      Top             =   2640
      Width           =   495
   End
   Begin VB.TextBox txtpersonx 
      Height          =   270
      Index           =   2
      Left            =   3480
      TabIndex        =   31
      Top             =   2640
      Width           =   495
   End
   Begin VB.TextBox txtpersony 
      Height          =   270
      Index           =   1
      Left            =   2640
      TabIndex        =   28
      Top             =   2640
      Width           =   495
   End
   Begin VB.TextBox txtpersonx 
      Height          =   270
      Index           =   1
      Left            =   1920
      TabIndex        =   27
      Top             =   2640
      Width           =   495
   End
   Begin VB.TextBox txtpersony 
      Height          =   270
      Index           =   0
      Left            =   1080
      TabIndex        =   24
      Top             =   2640
      Width           =   495
   End
   Begin VB.TextBox txtpersonx 
      Height          =   270
      Index           =   0
      Left            =   360
      TabIndex        =   23
      Top             =   2640
      Width           =   495
   End
   Begin VB.ComboBox ComboSelectperson 
      Height          =   345
      Index           =   5
      Left            =   7920
      Style           =   2  'Dropdown List
      TabIndex        =   21
      Top             =   1800
      Width           =   1455
   End
   Begin VB.ComboBox ComboSelectperson 
      Height          =   345
      Index           =   4
      Left            =   6360
      Style           =   2  'Dropdown List
      TabIndex        =   20
      Top             =   1800
      Width           =   1455
   End
   Begin VB.ComboBox ComboSelectperson 
      Height          =   345
      Index           =   3
      Left            =   4800
      Style           =   2  'Dropdown List
      TabIndex        =   19
      Top             =   1800
      Width           =   1455
   End
   Begin VB.ComboBox ComboSelectperson 
      Height          =   345
      Index           =   2
      Left            =   3240
      Style           =   2  'Dropdown List
      TabIndex        =   18
      Top             =   1800
      Width           =   1455
   End
   Begin VB.ComboBox ComboSelectperson 
      Height          =   345
      Index           =   1
      Left            =   1680
      Style           =   2  'Dropdown List
      TabIndex        =   17
      Top             =   1800
      Width           =   1455
   End
   Begin VB.ComboBox ComboSelectperson 
      Height          =   345
      Index           =   0
      Left            =   120
      Style           =   2  'Dropdown List
      TabIndex        =   16
      Top             =   1800
      Width           =   1455
   End
   Begin VB.ComboBox ComboPerson 
      Height          =   345
      Index           =   5
      Left            =   7920
      Style           =   2  'Dropdown List
      TabIndex        =   14
      Top             =   1080
      Width           =   1455
   End
   Begin VB.ComboBox ComboPerson 
      Height          =   345
      Index           =   4
      Left            =   6360
      Style           =   2  'Dropdown List
      TabIndex        =   13
      Top             =   1080
      Width           =   1455
   End
   Begin VB.ComboBox ComboPerson 
      Height          =   345
      Index           =   3
      Left            =   4800
      Style           =   2  'Dropdown List
      TabIndex        =   12
      Top             =   1080
      Width           =   1455
   End
   Begin VB.ComboBox ComboPerson 
      Height          =   345
      Index           =   2
      Left            =   3240
      Style           =   2  'Dropdown List
      TabIndex        =   11
      Top             =   1080
      Width           =   1455
   End
   Begin VB.ComboBox ComboPerson 
      Height          =   345
      Index           =   1
      Left            =   1680
      Style           =   2  'Dropdown List
      TabIndex        =   10
      Top             =   1080
      Width           =   1455
   End
   Begin VB.ComboBox ComboPerson 
      Height          =   345
      Index           =   0
      Left            =   120
      Style           =   2  'Dropdown List
      TabIndex        =   9
      Top             =   1080
      Width           =   1455
   End
   Begin VB.TextBox txtmusic 
      Height          =   270
      Left            =   9480
      TabIndex        =   7
      Top             =   600
      Width           =   1095
   End
   Begin VB.TextBox txtexp 
      Height          =   270
      Left            =   9480
      TabIndex        =   5
      Top             =   120
      Width           =   1095
   End
   Begin VB.TextBox txtMap 
      Height          =   270
      Left            =   7080
      TabIndex        =   3
      Top             =   120
      Width           =   855
   End
   Begin VB.ComboBox Combowar 
      Height          =   345
      Left            =   1200
      Style           =   2  'Dropdown List
      TabIndex        =   1
      Top             =   240
      Width           =   2055
   End
   Begin VB.Label Label9 
      Caption         =   "Label9"
      Height          =   255
      Left            =   3480
      TabIndex        =   155
      Top             =   240
      Width           =   2295
   End
   Begin VB.Label LabelY 
      Caption         =   "Y"
      Height          =   255
      Index           =   25
      Left            =   8520
      TabIndex        =   146
      Top             =   6480
      Width           =   255
   End
   Begin VB.Label Labelx 
      Caption         =   "X"
      Height          =   375
      Index           =   25
      Left            =   7800
      TabIndex        =   145
      Top             =   6480
      Width           =   255
   End
   Begin VB.Label LabelY 
      Caption         =   "Y"
      Height          =   255
      Index           =   24
      Left            =   6600
      TabIndex        =   141
      Top             =   6480
      Width           =   255
   End
   Begin VB.Label Labelx 
      Caption         =   "X"
      Height          =   375
      Index           =   24
      Left            =   5880
      TabIndex        =   140
      Top             =   6480
      Width           =   255
   End
   Begin VB.Label LabelY 
      Caption         =   "Y"
      Height          =   255
      Index           =   23
      Left            =   4680
      TabIndex        =   136
      Top             =   6480
      Width           =   255
   End
   Begin VB.Label Labelx 
      Caption         =   "X"
      Height          =   375
      Index           =   23
      Left            =   3960
      TabIndex        =   135
      Top             =   6480
      Width           =   255
   End
   Begin VB.Label LabelY 
      Caption         =   "Y"
      Height          =   255
      Index           =   22
      Left            =   2760
      TabIndex        =   131
      Top             =   6480
      Width           =   255
   End
   Begin VB.Label Labelx 
      Caption         =   "X"
      Height          =   375
      Index           =   22
      Left            =   2040
      TabIndex        =   130
      Top             =   6480
      Width           =   255
   End
   Begin VB.Label LabelY 
      Caption         =   "Y"
      Height          =   255
      Index           =   21
      Left            =   840
      TabIndex        =   126
      Top             =   6480
      Width           =   255
   End
   Begin VB.Label Labelx 
      Caption         =   "X"
      Height          =   375
      Index           =   21
      Left            =   120
      TabIndex        =   125
      Top             =   6480
      Width           =   255
   End
   Begin VB.Label LabelY 
      Caption         =   "Y"
      Height          =   255
      Index           =   20
      Left            =   8520
      TabIndex        =   121
      Top             =   5640
      Width           =   255
   End
   Begin VB.Label Labelx 
      Caption         =   "X"
      Height          =   375
      Index           =   20
      Left            =   7800
      TabIndex        =   120
      Top             =   5640
      Width           =   255
   End
   Begin VB.Label LabelY 
      Caption         =   "Y"
      Height          =   255
      Index           =   19
      Left            =   6600
      TabIndex        =   116
      Top             =   5640
      Width           =   255
   End
   Begin VB.Label Labelx 
      Caption         =   "X"
      Height          =   375
      Index           =   19
      Left            =   5880
      TabIndex        =   115
      Top             =   5640
      Width           =   255
   End
   Begin VB.Label LabelY 
      Caption         =   "Y"
      Height          =   255
      Index           =   18
      Left            =   4680
      TabIndex        =   111
      Top             =   5640
      Width           =   255
   End
   Begin VB.Label Labelx 
      Caption         =   "X"
      Height          =   375
      Index           =   18
      Left            =   3960
      TabIndex        =   110
      Top             =   5640
      Width           =   255
   End
   Begin VB.Label LabelY 
      Caption         =   "Y"
      Height          =   255
      Index           =   17
      Left            =   2760
      TabIndex        =   106
      Top             =   5640
      Width           =   255
   End
   Begin VB.Label Labelx 
      Caption         =   "X"
      Height          =   375
      Index           =   17
      Left            =   2040
      TabIndex        =   105
      Top             =   5640
      Width           =   255
   End
   Begin VB.Label LabelY 
      Caption         =   "Y"
      Height          =   255
      Index           =   16
      Left            =   840
      TabIndex        =   101
      Top             =   5640
      Width           =   255
   End
   Begin VB.Label Labelx 
      Caption         =   "X"
      Height          =   375
      Index           =   16
      Left            =   120
      TabIndex        =   100
      Top             =   5640
      Width           =   255
   End
   Begin VB.Label LabelY 
      Caption         =   "Y"
      Height          =   255
      Index           =   15
      Left            =   8520
      TabIndex        =   96
      Top             =   4800
      Width           =   255
   End
   Begin VB.Label Labelx 
      Caption         =   "X"
      Height          =   375
      Index           =   15
      Left            =   7800
      TabIndex        =   95
      Top             =   4800
      Width           =   255
   End
   Begin VB.Label LabelY 
      Caption         =   "Y"
      Height          =   255
      Index           =   14
      Left            =   6600
      TabIndex        =   91
      Top             =   4800
      Width           =   255
   End
   Begin VB.Label Labelx 
      Caption         =   "X"
      Height          =   375
      Index           =   14
      Left            =   5880
      TabIndex        =   90
      Top             =   4800
      Width           =   255
   End
   Begin VB.Label LabelY 
      Caption         =   "Y"
      Height          =   255
      Index           =   13
      Left            =   4680
      TabIndex        =   86
      Top             =   4800
      Width           =   255
   End
   Begin VB.Label Labelx 
      Caption         =   "X"
      Height          =   375
      Index           =   13
      Left            =   3960
      TabIndex        =   85
      Top             =   4800
      Width           =   255
   End
   Begin VB.Label LabelY 
      Caption         =   "Y"
      Height          =   255
      Index           =   12
      Left            =   2760
      TabIndex        =   81
      Top             =   4800
      Width           =   255
   End
   Begin VB.Label Labelx 
      Caption         =   "X"
      Height          =   375
      Index           =   12
      Left            =   2040
      TabIndex        =   80
      Top             =   4800
      Width           =   255
   End
   Begin VB.Label LabelY 
      Caption         =   "Y"
      Height          =   255
      Index           =   11
      Left            =   840
      TabIndex        =   76
      Top             =   4800
      Width           =   255
   End
   Begin VB.Label Labelx 
      Caption         =   "X"
      Height          =   375
      Index           =   11
      Left            =   120
      TabIndex        =   75
      Top             =   4800
      Width           =   255
   End
   Begin VB.Label LabelY 
      Caption         =   "Y"
      Height          =   255
      Index           =   10
      Left            =   8520
      TabIndex        =   71
      Top             =   3960
      Width           =   255
   End
   Begin VB.Label Labelx 
      Caption         =   "X"
      Height          =   375
      Index           =   10
      Left            =   7800
      TabIndex        =   70
      Top             =   3960
      Width           =   255
   End
   Begin VB.Label LabelY 
      Caption         =   "Y"
      Height          =   255
      Index           =   9
      Left            =   6600
      TabIndex        =   66
      Top             =   3960
      Width           =   255
   End
   Begin VB.Label Labelx 
      Caption         =   "X"
      Height          =   375
      Index           =   9
      Left            =   5880
      TabIndex        =   65
      Top             =   3960
      Width           =   255
   End
   Begin VB.Label LabelY 
      Caption         =   "Y"
      Height          =   255
      Index           =   8
      Left            =   4680
      TabIndex        =   61
      Top             =   3960
      Width           =   255
   End
   Begin VB.Label Labelx 
      Caption         =   "X"
      Height          =   375
      Index           =   8
      Left            =   3960
      TabIndex        =   60
      Top             =   3960
      Width           =   255
   End
   Begin VB.Label LabelY 
      Caption         =   "Y"
      Height          =   255
      Index           =   7
      Left            =   2760
      TabIndex        =   56
      Top             =   3960
      Width           =   255
   End
   Begin VB.Label Labelx 
      Caption         =   "X"
      Height          =   375
      Index           =   7
      Left            =   2040
      TabIndex        =   55
      Top             =   3960
      Width           =   255
   End
   Begin VB.Label LabelY 
      Caption         =   "Y"
      Height          =   255
      Index           =   6
      Left            =   840
      TabIndex        =   51
      Top             =   3960
      Width           =   255
   End
   Begin VB.Label Labelx 
      Caption         =   "X"
      Height          =   375
      Index           =   6
      Left            =   120
      TabIndex        =   50
      Top             =   3960
      Width           =   255
   End
   Begin VB.Label Label8 
      Caption         =   "Label8"
      Height          =   255
      Left            =   120
      TabIndex        =   47
      Top             =   3240
      Width           =   975
   End
   Begin VB.Label LabelY 
      Caption         =   "Y"
      Height          =   255
      Index           =   5
      Left            =   8760
      TabIndex        =   46
      Top             =   2640
      Width           =   255
   End
   Begin VB.Label Labelx 
      Caption         =   "X"
      Height          =   375
      Index           =   5
      Left            =   8040
      TabIndex        =   45
      Top             =   2640
      Width           =   255
   End
   Begin VB.Label LabelY 
      Caption         =   "Y"
      Height          =   255
      Index           =   4
      Left            =   7200
      TabIndex        =   42
      Top             =   2640
      Width           =   255
   End
   Begin VB.Label Labelx 
      Caption         =   "X"
      Height          =   375
      Index           =   4
      Left            =   6480
      TabIndex        =   41
      Top             =   2640
      Width           =   255
   End
   Begin VB.Label LabelY 
      Caption         =   "Y"
      Height          =   255
      Index           =   3
      Left            =   5640
      TabIndex        =   38
      Top             =   2640
      Width           =   255
   End
   Begin VB.Label Labelx 
      Caption         =   "X"
      Height          =   375
      Index           =   3
      Left            =   4920
      TabIndex        =   37
      Top             =   2640
      Width           =   255
   End
   Begin VB.Label LabelY 
      Caption         =   "Y"
      Height          =   255
      Index           =   2
      Left            =   4080
      TabIndex        =   34
      Top             =   2640
      Width           =   255
   End
   Begin VB.Label Labelx 
      Caption         =   "X"
      Height          =   375
      Index           =   2
      Left            =   3360
      TabIndex        =   33
      Top             =   2640
      Width           =   255
   End
   Begin VB.Label LabelY 
      Caption         =   "Y"
      Height          =   255
      Index           =   1
      Left            =   2520
      TabIndex        =   30
      Top             =   2640
      Width           =   255
   End
   Begin VB.Label Labelx 
      Caption         =   "X"
      Height          =   375
      Index           =   1
      Left            =   1800
      TabIndex        =   29
      Top             =   2640
      Width           =   255
   End
   Begin VB.Label LabelY 
      Caption         =   "Y"
      Height          =   255
      Index           =   0
      Left            =   960
      TabIndex        =   26
      Top             =   2640
      Width           =   255
   End
   Begin VB.Label Labelx 
      Caption         =   "X"
      Height          =   375
      Index           =   0
      Left            =   240
      TabIndex        =   25
      Top             =   2640
      Width           =   255
   End
   Begin VB.Label Label7 
      Caption         =   "Label7"
      Height          =   255
      Left            =   120
      TabIndex        =   22
      Top             =   2280
      Width           =   975
   End
   Begin VB.Label Label6 
      Caption         =   "Label6"
      Height          =   255
      Left            =   120
      TabIndex        =   15
      Top             =   1560
      Width           =   6495
   End
   Begin VB.Label Label5 
      Caption         =   "Label5"
      Height          =   255
      Left            =   120
      TabIndex        =   8
      Top             =   720
      Width           =   2175
   End
   Begin VB.Label Label4 
      Caption         =   "Label4"
      Height          =   255
      Left            =   8160
      TabIndex        =   6
      Top             =   600
      Width           =   1215
   End
   Begin VB.Label Label3 
      Caption         =   "Label3"
      Height          =   255
      Left            =   8160
      TabIndex        =   4
      Top             =   120
      Width           =   1335
   End
   Begin VB.Label Label2 
      Caption         =   "Label2"
      Height          =   255
      Left            =   6000
      TabIndex        =   2
      Top             =   120
      Width           =   1095
   End
   Begin VB.Label Label1 
      Caption         =   "warname"
      Height          =   255
      Left            =   120
      TabIndex        =   0
      Top             =   240
      Width           =   975
   End
End
Attribute VB_Name = "FrmWarEdit"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Option Explicit




Private Sub cmdaddwar_Click()
Dim Index As Long
Dim i As Long

    Index = Combowar.ListIndex
    If Index < 0 Then Exit Sub


    Warnum = Warnum + 1
    ReDim Preserve WarData(Warnum - 1)
    WarData(Warnum - 1).Name = "noname"
    
    WarData(Warnum - 1).mapid = txtMap.Text
    WarData(Warnum - 1).Experience = txtexp.Text
    WarData(Warnum - 1).musicid = txtmusic.Text
    For i = 0 To 5
       WarData(Warnum - 1).Warperson(i) = Comboperson(i).ListIndex - 1
    Next i
    For i = 0 To 5
        WarData(Warnum - 1).SelectWarperson(i) = ComboSelectperson(i).ListIndex - 1
    Next i
    For i = 0 To 5
        WarData(Warnum - 1).personX(i) = txtpersonx(i).Text
        WarData(Warnum - 1).personY(i) = txtpersony(i).Text
    Next i
    
    For i = 0 To 19
       WarData(Warnum - 1).Enemy(i) = Comboenemy(i).ListIndex - 1
       WarData(Warnum - 1).EnemyX(i) = txtenemyX(i).Text
       WarData(Warnum - 1).EnemyY(i) = txtenemyy(i).Text
    Next i

    
    
    Combowar.Clear
    For i = 0 To Warnum - 1
        Combowar.AddItem i & "-" & WarData(i).Name
    Next i
    Combowar.ListIndex = Warnum - 1

    
End Sub

Private Sub cmdcancel_Click()
    Unload Me
End Sub

Private Sub cmddelwar_Click()
Dim i As Long
    If MsgBox(LoadResStr(10022), vbYesNo) = vbYes Then
        Warnum = Warnum - 1
        ReDim Preserve WarData(Warnum - 1)
   
    
        Combowar.Clear
        For i = 0 To Warnum - 1
            Combowar.AddItem i & "-" & WarData(i).Name
        Next i
        Combowar.ListIndex = Warnum - 1
    End If

End Sub

Private Sub cmdedit_Click()
Dim Index As Long
Dim i As Long

    Index = Combowar.ListIndex
    If Index < 0 Then Exit Sub
    
     WarData(Index).mapid = txtMap.Text
     WarData(Index).Experience = txtexp.Text
     WarData(Index).musicid = txtmusic.Text
    For i = 0 To 5
       WarData(Index).Warperson(i) = Comboperson(i).ListIndex - 1
    Next i
    For i = 0 To 5
        WarData(Index).SelectWarperson(i) = ComboSelectperson(i).ListIndex - 1
    Next i
    For i = 0 To 5
        WarData(Index).personX(i) = txtpersonx(i).Text
        WarData(Index).personY(i) = txtpersony(i).Text
    Next i
    
    For i = 0 To 19
       WarData(Index).Enemy(i) = Comboenemy(i).ListIndex - 1
       WarData(Index).EnemyX(i) = txtenemyX(i).Text
       WarData(Index).EnemyY(i) = txtenemyy(i).Text
    Next i
    
    WarData(Index).Name = txtwarname.Text
    Combowar.Clear
    For i = 0 To Warnum - 1
        Combowar.AddItem i & "-" & WarData(i).Name
    Next i
    Combowar.ListIndex = Index
  
End Sub

Private Sub cmdsave_Click()
Dim filename As String
Dim filenum As Long
Dim i As Long, j As Long
Dim tmpbig5() As Byte
Dim tmplength As Long
    filename = G_Var.JYPath & G_Var.WarDefine
  '      If Dir(filename) <> "" Then
  '      Kill filename
  '  End If
 
 
    'filenum = FreeFile()
    filenum = OpenBin(G_Var.JYPath & G_Var.WarDefine, "W")
    For i = 0 To Warnum - 1
        Put #filenum, , WarData(i).Id
        Call UnicodetoBIG5(WarData(i).Name, tmplength, tmpbig5)
        If tmplength > 8 Then
            tmplength = 8
        End If
        For j = 0 To tmplength - 1
            WarData(i).namebig5(j) = tmpbig5(j)
        Next j
        WarData(i).namebig5(j) = 0
        
        Put #filenum, , WarData(i).namebig5
        Put #filenum, , WarData(i).mapid
        Put #filenum, , WarData(i).Experience
        Put #filenum, , WarData(i).musicid
        Put #filenum, , WarData(i).Warperson
        Put #filenum, , WarData(i).SelectWarperson
        Put #filenum, , WarData(i).personX
        Put #filenum, , WarData(i).personY
        Put #filenum, , WarData(i).Enemy
        Put #filenum, , WarData(i).EnemyX
        Put #filenum, , WarData(i).EnemyY
    Next i
       
    Close filenum
    MsgBox LoadResStr(10014) & filename
    
End Sub

Private Sub cmdshow_Click()
    If Combowar.ListIndex < 0 Then Exit Sub
    Load frmWMapEdit
    frmWMapEdit.WarID = Combowar.ListIndex
    frmWMapEdit.ComboScene.ListIndex = WarData(Combowar.ListIndex).mapid
    frmWMapEdit.Show
    'frmwarmap.Show vbModal
End Sub

Private Sub Combowar_click()
Dim Index As Long
Dim i As Long
    Index = Combowar.ListIndex
    txtMap.Text = WarData(Index).mapid
    txtwarname.Text = WarData(Index).Name
    txtexp.Text = WarData(Index).Experience
    txtmusic.Text = WarData(Index).musicid
    For i = 0 To 5
       Comboperson(i).ListIndex = WarData(Index).Warperson(i) + 1
    Next i
    For i = 0 To 5
       ComboSelectperson(i).ListIndex = WarData(Index).SelectWarperson(i) + 1
    Next i
    For i = 0 To 5
        txtpersonx(i).Text = WarData(Index).personX(i)
        txtpersony(i).Text = WarData(Index).personY(i)
    Next i
    
    For i = 0 To 19
       Comboenemy(i).ListIndex = WarData(Index).Enemy(i) + 1
       txtenemyX(i).Text = WarData(Index).EnemyX(i)
       txtenemyy(i).Text = WarData(Index).EnemyY(i)
    Next i
    
End Sub

Private Sub Form_Load()
    
Dim i As Long
Dim j As Long
    
    Me.Caption = LoadResStr(10001)
    Label1.Caption = LoadResStr(10002)
    Label2.Caption = LoadResStr(10003)
    Label3.Caption = LoadResStr(10004)
    Label4.Caption = LoadResStr(10005)
    Label5.Caption = LoadResStr(10006)
    Label6.Caption = LoadResStr(10007)
    Label7.Caption = LoadResStr(10008)
    Label8.Caption = LoadResStr(10009)
    cmdedit.Caption = LoadResStr(10010)
    cmdsave.Caption = LoadResStr(10011)
    cmdcancel.Caption = LoadResStr(10012)
    cmdShow.Caption = LoadResStr(10015)
    cmdaddwar.Caption = LoadResStr(10020)
    cmddelwar.Caption = LoadResStr(10021)
    Label9.Caption = LoadResStr(10023)
    
    Call LoadWar
    
    For i = 0 To Warnum - 1
        Combowar.AddItem i & "-" & WarData(i).Name
    Next i
    
    For j = 0 To 5
        Comboperson(j).AddItem LoadResStr(10013)
        For i = 0 To PersonNum - 1
            Comboperson(j).AddItem i & Person(i).Name1
        Next i
    Next j
    
    For j = 0 To 5
        ComboSelectperson(j).AddItem LoadResStr(10013)
        For i = 0 To PersonNum - 1
            ComboSelectperson(j).AddItem i & Person(i).Name1
        Next i
    Next j
    
    For j = 0 To 19
        Comboenemy(j).AddItem LoadResStr(10013)
        For i = 0 To PersonNum - 1
            Comboenemy(j).AddItem i & Person(i).Name1
        Next i
    Next j
    
    
End Sub

Private Sub LoadWar()
Dim filename As String
Dim filenum As Long
Dim i As Long
    'filename = G_Var.JYPath & "war.sta"
    'filenum = FreeFile()
    filenum = OpenBin(G_Var.JYPath & G_Var.WarDefine, "R")
    Warnum = LOF(filenum) / 186
    ReDim WarData(Warnum - 1)
    
    For i = 0 To Warnum - 1
        Get #filenum, , WarData(i).Id
        Get #filenum, , WarData(i).namebig5
        WarData(i).Name = Big5toUnicode(WarData(i).namebig5, 10)
        Get #filenum, , WarData(i).mapid
        Get #filenum, , WarData(i).Experience
        Get #filenum, , WarData(i).musicid
        Get #filenum, , WarData(i).Warperson
        Get #filenum, , WarData(i).SelectWarperson
        Get #filenum, , WarData(i).personX
        Get #filenum, , WarData(i).personY
        Get #filenum, , WarData(i).Enemy
        Get #filenum, , WarData(i).EnemyX
        Get #filenum, , WarData(i).EnemyY
    Next i
       
    Close filenum
    
       
End Sub
