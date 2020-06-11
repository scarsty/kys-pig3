VERSION 5.00
Begin VB.Form frmMapEdit 
   Caption         =   "地圖編輯器"
   ClientHeight    =   7770
   ClientLeft      =   165
   ClientTop       =   165
   ClientWidth     =   8880
   LinkTopic       =   "Form2"
   MDIChild        =   -1  'True
   ScaleHeight     =   518
   ScaleMode       =   3  'Pixel
   ScaleWidth      =   592
   WindowState     =   2  'Maximized
   Begin VB.PictureBox Picture2 
      AutoRedraw      =   -1  'True
      BackColor       =   &H00E0E0E0&
      FillStyle       =   0  'Solid
      Height          =   1260
      Index           =   1
      Left            =   0
      ScaleHeight     =   1200
      ScaleWidth      =   2370
      TabIndex        =   4
      Top             =   6240
      Width           =   2430
      Begin VB.Shape Shape1 
         BackColor       =   &H000080FF&
         BorderColor     =   &H0000FF00&
         BorderStyle     =   3  'Dot
         BorderWidth     =   2
         FillColor       =   &H80000008&
         Height          =   495
         Left            =   720
         Shape           =   4  'Rounded Rectangle
         Top             =   360
         Width           =   735
      End
   End
   Begin VB.PictureBox Picture1 
      BackColor       =   &H00FF80FF&
      BorderStyle     =   0  'None
      Height          =   7455
      Left            =   0
      ScaleHeight     =   497
      ScaleMode       =   3  'Pixel
      ScaleWidth      =   669
      TabIndex        =   40
      Top             =   0
      Width           =   10035
      Begin VB.PictureBox Picture2 
         AutoRedraw      =   -1  'True
         BackColor       =   &H00808080&
         BorderStyle     =   0  'None
         FillStyle       =   0  'Solid
         ForeColor       =   &H0000FFFF&
         Height          =   17280
         Index           =   0
         Left            =   0
         ScaleHeight     =   1152
         ScaleMode       =   3  'Pixel
         ScaleWidth      =   2304
         TabIndex        =   41
         Top             =   0
         Width           =   34560
         Begin VB.Timer Timer1 
            Interval        =   200
            Left            =   9360
            Top             =   4560
         End
         Begin VB.Line Line1 
            BorderColor     =   &H0000FF00&
            BorderWidth     =   2
            Index           =   0
            X1              =   -24
            X2              =   8
            Y1              =   0
            Y2              =   0
         End
         Begin VB.Line Line2 
            BorderColor     =   &H00404040&
            Index           =   0
            X1              =   0
            X2              =   0
            Y1              =   0
            Y2              =   24
         End
      End
   End
   Begin VB.HScrollBar HScroll1 
      Height          =   225
      LargeChange     =   160
      Left            =   360
      Max             =   2310
      SmallChange     =   32
      TabIndex        =   39
      Top             =   7500
      Width           =   9660
   End
   Begin VB.ComboBox Combo3 
      BackColor       =   &H00C0FFC0&
      BeginProperty Font 
         Name            =   "Times New Roman"
         Size            =   9
         Charset         =   0
         Weight          =   400
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Height          =   345
      ItemData        =   "mapedit.frx":0000
      Left            =   0
      List            =   "mapedit.frx":0002
      Style           =   2  'Dropdown List
      TabIndex        =   35
      Top             =   7440
      Width           =   390
   End
   Begin VB.Frame Frame1 
      Caption         =   "場景結構"
      BeginProperty Font 
         Name            =   "Times New Roman"
         Size            =   9
         Charset         =   0
         Weight          =   400
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      ForeColor       =   &H000000C0&
      Height          =   4215
      Index           =   1
      Left            =   10320
      TabIndex        =   30
      Top             =   3480
      Width           =   1575
      Begin VB.PictureBox Picture2 
         AutoRedraw      =   -1  'True
         BackColor       =   &H00E0E0E0&
         FillStyle       =   0  'Solid
         Height          =   3500
         Index           =   2
         Left            =   120
         ScaleHeight     =   229
         ScaleMode       =   3  'Pixel
         ScaleWidth      =   163
         TabIndex        =   38
         Top             =   1320
         Width           =   2500
      End
      Begin VB.VScrollBar VScroll2 
         Height          =   4095
         LargeChange     =   10
         Left            =   0
         TabIndex        =   36
         Top             =   120
         Width           =   135
      End
      Begin VB.ComboBox Combo4 
         BackColor       =   &H000000FF&
         BeginProperty Font 
            Name            =   "Times New Roman"
            Size            =   9
            Charset         =   0
            Weight          =   400
            Underline       =   0   'False
            Italic          =   0   'False
            Strikethrough   =   0   'False
         EndProperty
         ForeColor       =   &H00FFFFFF&
         Height          =   345
         Index           =   0
         ItemData        =   "mapedit.frx":0004
         Left            =   720
         List            =   "mapedit.frx":0006
         Style           =   2  'Dropdown List
         TabIndex        =   32
         Top             =   240
         Width           =   855
      End
      Begin VB.Label Label5 
         AutoSize        =   -1  'True
         Caption         =   "<快捷菜單>"
         BeginProperty Font 
            Name            =   "Times New Roman"
            Size            =   9
            Charset         =   0
            Weight          =   400
            Underline       =   0   'False
            Italic          =   0   'False
            Strikethrough   =   0   'False
         EndProperty
         ForeColor       =   &H00FF0000&
         Height          =   225
         Left            =   240
         MouseIcon       =   "mapedit.frx":0008
         MousePointer    =   99  'Custom
         TabIndex        =   0
         Top             =   600
         Width           =   930
      End
      Begin VB.Label Label4 
         AutoSize        =   -1  'True
         Caption         =   "貼圖海拔>"
         BeginProperty Font 
            Name            =   "Times New Roman"
            Size            =   9
            Charset         =   0
            Weight          =   400
            Underline       =   0   'False
            Italic          =   0   'False
            Strikethrough   =   0   'False
         EndProperty
         Height          =   225
         Left            =   240
         MouseIcon       =   "mapedit.frx":0312
         MousePointer    =   99  'Custom
         TabIndex        =   1
         ToolTipText     =   "不可超過200，因爲遊戲分辨率是320*200"
         Top             =   1080
         Width           =   825
      End
      Begin VB.Label Label2 
         AutoSize        =   -1  'True
         Caption         =   "貼圖索引>"
         BeginProperty Font 
            Name            =   "Times New Roman"
            Size            =   9
            Charset         =   0
            Weight          =   400
            Underline       =   0   'False
            Italic          =   0   'False
            Strikethrough   =   0   'False
         EndProperty
         Height          =   225
         Index           =   2
         Left            =   240
         TabIndex        =   34
         Top             =   840
         Width           =   825
      End
      Begin VB.Label Label2 
         AutoSize        =   -1  'True
         Caption         =   "操作區"
         BeginProperty Font 
            Name            =   "Times New Roman"
            Size            =   9
            Charset         =   0
            Weight          =   400
            Underline       =   0   'False
            Italic          =   0   'False
            Strikethrough   =   0   'False
         EndProperty
         Height          =   225
         Index           =   0
         Left            =   195
         TabIndex        =   33
         Top             =   300
         Width           =   540
      End
   End
   Begin VB.Frame Frame1 
      Caption         =   "事件"
      BeginProperty Font 
         Name            =   "Times New Roman"
         Size            =   9
         Charset         =   0
         Weight          =   400
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      ForeColor       =   &H000000C0&
      Height          =   3255
      Index           =   0
      Left            =   10320
      TabIndex        =   5
      Top             =   240
      Width           =   1575
      Begin VB.CommandButton Command1 
         Caption         =   "搜索閑置"
         BeginProperty Font 
            Name            =   "Times New Roman"
            Size            =   9
            Charset         =   0
            Weight          =   400
            Underline       =   0   'False
            Italic          =   0   'False
            Strikethrough   =   0   'False
         EndProperty
         Height          =   375
         Index           =   0
         Left            =   0
         TabIndex        =   37
         ToolTipText     =   "自動找尋下一個未用的事件(共200個)"
         Top             =   2880
         Width           =   855
      End
      Begin VB.ComboBox Combo1 
         BackColor       =   &H00FFC0C0&
         BeginProperty DataFormat 
            Type            =   1
            Format          =   "0"
            HaveTrueFalseNull=   0
            FirstDayOfWeek  =   0
            FirstWeekOfYear =   0
            LCID            =   2052
            SubFormatType   =   1
         EndProperty
         BeginProperty Font 
            Name            =   "Times New Roman"
            Size            =   9
            Charset         =   0
            Weight          =   400
            Underline       =   0   'False
            Italic          =   0   'False
            Strikethrough   =   0   'False
         EndProperty
         Height          =   345
         ItemData        =   "mapedit.frx":061C
         Left            =   840
         List            =   "mapedit.frx":061E
         Style           =   2  'Dropdown List
         TabIndex        =   29
         Top             =   2880
         Width           =   615
      End
      Begin VB.TextBox Text1 
         Alignment       =   1  'Right Justify
         BeginProperty Font 
            Name            =   "Times New Roman"
            Size            =   9
            Charset         =   0
            Weight          =   400
            Underline       =   0   'False
            Italic          =   0   'False
            Strikethrough   =   0   'False
         EndProperty
         Height          =   270
         Index           =   10
         Left            =   840
         MaxLength       =   5
         TabIndex        =   16
         ToolTipText     =   "十进制数"
         Top             =   2640
         Width           =   615
      End
      Begin VB.TextBox Text1 
         Alignment       =   1  'Right Justify
         BeginProperty Font 
            Name            =   "Times New Roman"
            Size            =   9
            Charset         =   0
            Weight          =   400
            Underline       =   0   'False
            Italic          =   0   'False
            Strikethrough   =   0   'False
         EndProperty
         Height          =   270
         Index           =   9
         Left            =   840
         MaxLength       =   5
         TabIndex        =   15
         ToolTipText     =   "十进制数"
         Top             =   2400
         Width           =   615
      End
      Begin VB.TextBox Text1 
         Alignment       =   1  'Right Justify
         BeginProperty Font 
            Name            =   "Times New Roman"
            Size            =   9
            Charset         =   0
            Weight          =   400
            Underline       =   0   'False
            Italic          =   0   'False
            Strikethrough   =   0   'False
         EndProperty
         Height          =   270
         Index           =   8
         Left            =   840
         MaxLength       =   5
         TabIndex        =   14
         ToolTipText     =   "十进制数"
         Top             =   2160
         Width           =   615
      End
      Begin VB.TextBox Text1 
         Alignment       =   1  'Right Justify
         BeginProperty Font 
            Name            =   "Times New Roman"
            Size            =   9
            Charset         =   0
            Weight          =   400
            Underline       =   0   'False
            Italic          =   0   'False
            Strikethrough   =   0   'False
         EndProperty
         Height          =   270
         Index           =   7
         Left            =   840
         MaxLength       =   5
         TabIndex        =   13
         ToolTipText     =   "十进制数"
         Top             =   1920
         Width           =   615
      End
      Begin VB.TextBox Text1 
         Alignment       =   1  'Right Justify
         BeginProperty Font 
            Name            =   "Times New Roman"
            Size            =   9
            Charset         =   0
            Weight          =   400
            Underline       =   0   'False
            Italic          =   0   'False
            Strikethrough   =   0   'False
         EndProperty
         Height          =   270
         Index           =   6
         Left            =   840
         MaxLength       =   5
         TabIndex        =   12
         ToolTipText     =   "十进制数"
         Top             =   1680
         Width           =   615
      End
      Begin VB.TextBox Text1 
         Alignment       =   1  'Right Justify
         BeginProperty Font 
            Name            =   "Times New Roman"
            Size            =   9
            Charset         =   0
            Weight          =   400
            Underline       =   0   'False
            Italic          =   0   'False
            Strikethrough   =   0   'False
         EndProperty
         Height          =   270
         Index           =   5
         Left            =   840
         MaxLength       =   5
         TabIndex        =   11
         ToolTipText     =   "十进制数"
         Top             =   1440
         Width           =   615
      End
      Begin VB.TextBox Text1 
         Alignment       =   1  'Right Justify
         BeginProperty Font 
            Name            =   "Times New Roman"
            Size            =   9
            Charset         =   0
            Weight          =   400
            Underline       =   0   'False
            Italic          =   0   'False
            Strikethrough   =   0   'False
         EndProperty
         Height          =   270
         Index           =   4
         Left            =   840
         MaxLength       =   5
         TabIndex        =   10
         ToolTipText     =   "十进制数"
         Top             =   1200
         Width           =   615
      End
      Begin VB.TextBox Text1 
         Alignment       =   1  'Right Justify
         BeginProperty Font 
            Name            =   "Times New Roman"
            Size            =   9
            Charset         =   0
            Weight          =   400
            Underline       =   0   'False
            Italic          =   0   'False
            Strikethrough   =   0   'False
         EndProperty
         Height          =   270
         Index           =   3
         Left            =   840
         MaxLength       =   5
         TabIndex        =   9
         ToolTipText     =   "十进制数"
         Top             =   960
         Width           =   615
      End
      Begin VB.TextBox Text1 
         Alignment       =   1  'Right Justify
         BeginProperty Font 
            Name            =   "Times New Roman"
            Size            =   9
            Charset         =   0
            Weight          =   400
            Underline       =   0   'False
            Italic          =   0   'False
            Strikethrough   =   0   'False
         EndProperty
         Height          =   270
         Index           =   2
         Left            =   840
         MaxLength       =   5
         TabIndex        =   8
         ToolTipText     =   "十进制数"
         Top             =   720
         Width           =   615
      End
      Begin VB.TextBox Text1 
         Alignment       =   1  'Right Justify
         BeginProperty Font 
            Name            =   "Times New Roman"
            Size            =   9
            Charset         =   0
            Weight          =   400
            Underline       =   0   'False
            Italic          =   0   'False
            Strikethrough   =   0   'False
         EndProperty
         Height          =   270
         Index           =   1
         Left            =   840
         MaxLength       =   5
         TabIndex        =   7
         ToolTipText     =   "十进制数"
         Top             =   480
         Width           =   615
      End
      Begin VB.TextBox Text1 
         Alignment       =   1  'Right Justify
         BeginProperty Font 
            Name            =   "Times New Roman"
            Size            =   9
            Charset         =   0
            Weight          =   400
            Underline       =   0   'False
            Italic          =   0   'False
            Strikethrough   =   0   'False
         EndProperty
         Height          =   270
         Index           =   0
         Left            =   840
         MaxLength       =   5
         TabIndex        =   6
         ToolTipText     =   "十进制数"
         Top             =   240
         Width           =   615
      End
      Begin VB.Label Label1 
         AutoSize        =   -1  'True
         Caption         =   "縱坐標Y"
         BeginProperty Font 
            Name            =   "Times New Roman"
            Size            =   9
            Charset         =   0
            Weight          =   400
            Underline       =   0   'False
            Italic          =   0   'False
            Strikethrough   =   0   'False
         EndProperty
         Height          =   225
         Index           =   10
         Left            =   120
         MousePointer    =   14  'Arrow and Question
         TabIndex        =   28
         ToolTipText     =   "取0到60"
         Top             =   2640
         Width           =   660
      End
      Begin VB.Label Label1 
         AutoSize        =   -1  'True
         Caption         =   "橫坐標X"
         BeginProperty Font 
            Name            =   "Times New Roman"
            Size            =   9
            Charset         =   0
            Weight          =   400
            Underline       =   0   'False
            Italic          =   0   'False
            Strikethrough   =   0   'False
         EndProperty
         Height          =   225
         Index           =   9
         Left            =   120
         MousePointer    =   14  'Arrow and Question
         TabIndex        =   27
         ToolTipText     =   "取0到60"
         Top             =   2400
         Width           =   675
      End
      Begin VB.Label Label1 
         AutoSize        =   -1  'True
         Caption         =   "動畫速度"
         BeginProperty Font 
            Name            =   "Times New Roman"
            Size            =   9
            Charset         =   0
            Weight          =   400
            Underline       =   0   'False
            Italic          =   0   'False
            Strikethrough   =   0   'False
         EndProperty
         ForeColor       =   &H00FF0000&
         Height          =   225
         Index           =   8
         Left            =   120
         MousePointer    =   99  'Custom
         TabIndex        =   26
         ToolTipText     =   "單擊開始/停止動畫"
         Top             =   2160
         Width           =   720
      End
      Begin VB.Label Label1 
         AutoSize        =   -1  'True
         Caption         =   "貼圖3"
         BeginProperty Font 
            Name            =   "Times New Roman"
            Size            =   9
            Charset         =   0
            Weight          =   400
            Underline       =   0   'False
            Italic          =   0   'False
            Strikethrough   =   0   'False
         EndProperty
         Height          =   225
         Index           =   7
         Left            =   120
         MouseIcon       =   "mapedit.frx":0620
         TabIndex        =   25
         ToolTipText     =   "同上，值不同時會顯示爲動畫"
         Top             =   1920
         Width           =   450
      End
      Begin VB.Label Label1 
         AutoSize        =   -1  'True
         Caption         =   "貼圖2"
         BeginProperty Font 
            Name            =   "Times New Roman"
            Size            =   9
            Charset         =   0
            Weight          =   400
            Underline       =   0   'False
            Italic          =   0   'False
            Strikethrough   =   0   'False
         EndProperty
         Height          =   225
         Index           =   6
         Left            =   120
         MouseIcon       =   "mapedit.frx":0A62
         TabIndex        =   24
         ToolTipText     =   "如果與貼圖1不同，則會顯示爲動畫"
         Top             =   1680
         Width           =   450
      End
      Begin VB.Label Label1 
         AutoSize        =   -1  'True
         Caption         =   "貼圖1"
         BeginProperty Font 
            Name            =   "Times New Roman"
            Size            =   9
            Charset         =   0
            Weight          =   400
            Underline       =   0   'False
            Italic          =   0   'False
            Strikethrough   =   0   'False
         EndProperty
         Height          =   225
         Index           =   5
         Left            =   120
         MouseIcon       =   "mapedit.frx":0EA4
         TabIndex        =   23
         ToolTipText     =   "決定了該觸發點顯示的什麽。例如寶箱、樹木、草地、人等等......(單擊使另兩個貼圖與此相同)"
         Top             =   1440
         Width           =   450
      End
      Begin VB.Label Label1 
         AutoSize        =   -1  'True
         Caption         =   "事件3"
         BeginProperty Font 
            Name            =   "Times New Roman"
            Size            =   9
            Charset         =   0
            Weight          =   400
            Underline       =   0   'False
            Italic          =   0   'False
            Strikethrough   =   0   'False
         EndProperty
         Height          =   225
         Index           =   4
         Left            =   120
         TabIndex        =   22
         ToolTipText     =   "主角走過時觸發"
         Top             =   1200
         Width           =   450
      End
      Begin VB.Label Label1 
         AutoSize        =   -1  'True
         Caption         =   "事件2"
         BeginProperty Font 
            Name            =   "Times New Roman"
            Size            =   9
            Charset         =   0
            Weight          =   400
            Underline       =   0   'False
            Italic          =   0   'False
            Strikethrough   =   0   'False
         EndProperty
         Height          =   225
         Index           =   3
         Left            =   120
         TabIndex        =   21
         ToolTipText     =   "主角使用物品時觸發"
         Top             =   960
         Width           =   450
      End
      Begin VB.Label Label1 
         AutoSize        =   -1  'True
         Caption         =   "事件1"
         BeginProperty Font 
            Name            =   "Times New Roman"
            Size            =   9
            Charset         =   0
            Weight          =   400
            Underline       =   0   'False
            Italic          =   0   'False
            Strikethrough   =   0   'False
         EndProperty
         Height          =   225
         Index           =   2
         Left            =   120
         MousePointer    =   14  'Arrow and Question
         TabIndex        =   20
         ToolTipText     =   "表示主角在該觸發點調查所引發的事件。詳細定義請查閱“事件對話修改器”"
         Top             =   720
         Width           =   450
      End
      Begin VB.Label Label1 
         AutoSize        =   -1  'True
         Caption         =   "編號"
         BeginProperty Font 
            Name            =   "Times New Roman"
            Size            =   9
            Charset         =   0
            Weight          =   400
            Underline       =   0   'False
            Italic          =   0   'False
            Strikethrough   =   0   'False
         EndProperty
         Height          =   225
         Index           =   1
         Left            =   120
         TabIndex        =   19
         Top             =   480
         Width           =   360
      End
      Begin VB.Label Label1 
         AutoSize        =   -1  'True
         Caption         =   "能否通過"
         BeginProperty Font 
            Name            =   "Times New Roman"
            Size            =   9
            Charset         =   0
            Weight          =   400
            Underline       =   0   'False
            Italic          =   0   'False
            Strikethrough   =   0   'False
         EndProperty
         Height          =   225
         Index           =   0
         Left            =   120
         MouseIcon       =   "mapedit.frx":12E6
         TabIndex        =   18
         ToolTipText     =   "0能通過，1不能通過"
         Top             =   240
         Width           =   720
      End
      Begin VB.Label Label1 
         AutoSize        =   -1  'True
         Caption         =   "编号索引"
         BeginProperty Font 
            Name            =   "Times New Roman"
            Size            =   9
            Charset         =   0
            Weight          =   400
            Underline       =   0   'False
            Italic          =   0   'False
            Strikethrough   =   0   'False
         EndProperty
         ForeColor       =   &H000000C0&
         Height          =   225
         Index           =   12
         Left            =   120
         TabIndex        =   17
         ToolTipText     =   "在一个场景中最多能有200个"
         Top             =   3000
         Width           =   720
      End
   End
   Begin VB.VScrollBar VScroll1 
      Height          =   7200
      LargeChange     =   80
      Left            =   10080
      Max             =   1200
      SmallChange     =   16
      TabIndex        =   3
      Top             =   240
      Width           =   225
   End
   Begin VB.ComboBox Combo2 
      BackColor       =   &H00C0E0FF&
      BeginProperty Font 
         Name            =   "Times New Roman"
         Size            =   9
         Charset         =   0
         Weight          =   400
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Height          =   345
      ItemData        =   "mapedit.frx":1728
      Left            =   10080
      List            =   "mapedit.frx":1872
      Style           =   2  'Dropdown List
      TabIndex        =   31
      Top             =   -45
      Width           =   1095
   End
   Begin VB.Label Label3 
      AutoSize        =   -1  'True
      Caption         =   "場景:0"
      BeginProperty Font 
         Name            =   "Times New Roman"
         Size            =   9
         Charset         =   0
         Weight          =   400
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      ForeColor       =   &H00FF0000&
      Height          =   225
      Left            =   11190
      TabIndex        =   2
      Top             =   60
      Width           =   495
   End
End
Attribute VB_Name = "frmMapEdit"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Option Explicit
'4,5层
'自动编辑
'自动拾取
Dim CurrentMapIDX As Long, CurrentEvtIDX As Long
Dim AddName(0 To 83) As String, AddAttrib(0 To 199, 0 To 10) As Integer
Dim inMapFile As String, inMapIdxFile As String
Dim Busying As Boolean, EnableAni As Boolean, aniFrameIndex As Integer
Dim xIndex As Integer, yIndex As Integer
Dim PointX As Integer, PointY As Integer
Dim ux As Integer, uy As Integer, lx As Integer, ly As Integer
Dim dx As Integer, dy As Integer, rx As Integer, ry As Integer
Dim LayerEditMode As Boolean, SelectedTileIDX As Long, SelectedTileYadd As Integer
Dim Combo1En As Boolean, Combo2En As Boolean
Dim CurrentJinDu As Integer, RefreshMode As Integer
Dim Drawing As Boolean

Const SRCCOPY = &HCC0020

Dim SmpMapNum As Long  ' 地图贴图的索引个数
Dim sInData(63, 63, 5) As Integer
Dim mMapPic() As RLEPic
Dim Started As Boolean
Dim sinID(100) As Long

Private Sub ReadInMapStru(Layer0 As Boolean, Layer1 As Boolean, Layer2 As Boolean, Layer3 As Boolean)
'读场景结构
Dim Filename As String
Dim Filenum As Integer
Dim I As Long, J As Long, tempstr1 As String
Me.MousePointer = 11
   Filename = GamePath & Sx_IDX(CurrentJinDu)
   tempstr1 = "由於讀取場景結構失敗，將無法繼續。"
   If ChkRequiredFile(Filename, 400, tempstr1, tempstr1, "讀取場景結構可能會出錯。") < 2 Then Exit Sub
    sinID(0) = 0
    Filenum = FreeFile()
    Open Filename For Binary Access Read As Filenum
    For I = 1 To 100
        Get Filenum, , sinID(I) '读索引到内存sinID
    Next I
    Close (Filenum)
    
    Filename = GamePath & Sx_GRP(CurrentJinDu)   '"\s1.grp"
    If ChkRequiredFile(Filename, 4915200, tempstr1, tempstr1, "讀取場景結構可能會出錯。") < 2 Then Exit Sub
    Filenum = FreeFile()
    Open Filename For Binary Access Read As Filenum
     Seek #Filenum, sinID(CurrentMapIDX) + 1
     Get Filenum, , sInData
    Close (Filenum)
    
    Call ReadDx_GRPfile(READMODE)

   If LoadSMap(CurrentMapIDX) = 0 Then Exit Sub

    Call ShowPicDIBn2(Layer0, Layer1, Layer2, Layer3)

End Sub

Private Sub ShowPicDIBn2(Layer0 As Boolean, Layer1 As Boolean, Layer2 As Boolean, Layer3 As Boolean)
Dim copmDC As Long
Dim bInfo As BITMAPINFO
Dim DIBSectionHandle As Long    ' Handle to DIBSection
Dim OldCompDCBM As Long         ' Original bitmap for CompDC
Dim CompDC As Long
Dim addR As Long
Dim Temp As Long
Dim lineSize As Long
Dim picData() As Long

Dim I As Long, J As Long
Dim rangeX As Long, rangeY As Long
Dim X0 As Integer, Y0 As Integer

Dim X1 As Long, Y1 As Long
Dim Pic As Long
Dim dx As Long, dy As Long
    
    Busying = True
    Me.MousePointer = 11
    X0 = 32
    Y0 = 32
    
'   Wd640 = 640
'   Ht480 = 480
'   Wd640 = 1152
'   Ht480 = 576

  Wd640 = 2304
  Ht480 = 1152

    CompDC = CreateCompatibleDC(0)
    With bInfo.bmiHeader
        .biSize = 40
        .biWidth = Wd640
        .biHeight = -Ht480
        .biPlanes = 1
        .biBitCount = 32
        .biCompression = 0
        lineSize = .biWidth * 4
        .biSizeImage = -lineSize * .biHeight
    End With
    DIBSectionHandle = CreateDIBSection(CompDC, bInfo, 0, addR, 0, 0)
    OldCompDCBM = SelectObject(CompDC, DIBSectionHandle)
    ReDim picData(bInfo.bmiHeader.biSizeImage / 4)
    Picture2(1).Cls
    rangeX = 64 '18 + 3 + 6    ' 保证不出现漏画贴图，把画的范围扩大
    rangeY = 0 ' 10 + 11 + 6     ' 其实有更好的办法可以先判断出应该画哪些
    Dim I1 As Long, J1 As Long
    ' 按屏幕坐标，从右向左，从上到下依次画每个贴图，保证贴图正确，
     For J = -rangeY To 2 * rangeX + rangeY
        For I = rangeX To 0 Step -1
            
                I1 = -rangeX + I + J \ 2
                J1 = -I + J \ 2 + J Mod 2
            X1 = XSCALE * (I1 - J1) + Wd640 / 2
            Y1 = YSCALE * (I1 + J1 + 2) + Ht480 / 2
            
            If Y0 + J1 >= 0 And X0 + I1 >= 0 And Y0 + J1 < 64 And X0 + I1 < 64 Then
                dx = sInData(X0 + I1, Y0 + J1, 4)
                dy = sInData(X0 + I1, Y0 + J1, 5)
                ' 画0层
                Pic = sInData(X0 + I1, Y0 + J1, 0) / 2
                If Layer0 Then
                 Call genPicData(Pic, addR, bInfo.bmiHeader.biWidth, -bInfo.bmiHeader.biHeight, X1, Y1)
                 Picture2(1).Circle (X1, Y1), 9, vbBlue ' Pic * 10000
                End If
                ' 画1层
                 Pic = sInData(X0 + I1, Y0 + J1, 1) / 2
                If Pic > 0 And Pic < SmpMapNum And Layer1 Then
                    Call genPicData(Pic, addR, bInfo.bmiHeader.biWidth, -bInfo.bmiHeader.biHeight, X1, Y1 - dx)
                    Picture2(1).Circle (X1, Y1), 9, vbCyan 'Pic * 100 + &H888888
                End If
                ' 画2层
                Pic = sInData(X0 + I1, Y0 + J1, 2) / 2
                If Pic > 0 And Layer2 Then
                    Call genPicData(Pic, addR, bInfo.bmiHeader.biWidth, -bInfo.bmiHeader.biHeight, X1, Y1 - dy)
                    Picture2(1).Circle (X1, Y1), 9, vbYellow 'Pic * 80000
                End If
                '3层
                Pic = sInData(X0 + I1, Y0 + J1, 3)
                If Pic >= 0 And Layer3 Then
                   Call genPicData(AddAttrib(Pic, 5) / 2, addR, bInfo.bmiHeader.biWidth, -bInfo.bmiHeader.biHeight, X1, Y1 - dx)
                   Picture2(1).Circle (X1, Y1 - dx), 48, vbRed
                End If
              
            End If
        Next I
    Next J



    ' 在当前坐标位置贴图
   ' Call genPicData(0, addR, bInfo.bmiHeader.biWidth, -bInfo.bmiHeader.biHeight, X2Pixel(1, 1), Y2Pixel(1, 1)) ' Wd640 / 2, Ht480 / 2)
    
    ' 复制到dib上
    Temp = BitBlt(Picture2(0).hdc, 0, 0, Wd640, Ht480, CompDC, 0, 0, &HCC0020)
    'StretchBlt Picture2(1).hdc, 0, 0, 180, 90, CompDC, 0, 0, Wd640, Ht480, SRCCOPY
    'StretchDIBits Picture2(1).hdc, 0, 0, 180, 90, 1000, 500, Wd640, Ht480, picData(0), bInfo, DIB_RGB_COLORS, &HCC0020
    'Picture2(1).PaintPicture Picture2(0).Image, 0, 0, 1800, 900, 0, 0, Wd640, Ht480
    Temp = GetLastError()
    Temp = SelectObject(CompDC, OldCompDCBM)
    Temp = DeleteDC(CompDC)
    Temp = DeleteObject(DIBSectionHandle)
    Picture2(0).Refresh
    Picture2(1).Refresh
Me.MousePointer = 0
  Busying = False
If Not MDIFormMain.mnu1MapEdit1(5).Checked Then Exit Sub
    ' 画第4层事件的编号
      Dim K As Integer
      For J = -rangeY To 2 * rangeX + rangeY
        For I = rangeX To 0 Step -1
            If J Mod 2 = 0 Then
                I1 = -rangeX + I + J \ 2
                J1 = -I + J \ 2
            Else
                I1 = -rangeX + I + J \ 2
                J1 = -I + J \ 2 + 1
            End If
            X1 = XSCALE * (I1 - J1) + Wd640 / 2
            Y1 = YSCALE * (I1 + J1) + Ht480 / 2
            If Y0 + J1 >= 0 And X0 + I1 >= 0 And Y0 + J1 < 64 And X0 + I1 < 64 Then
                Pic = sInData(X0 + I1, Y0 + J1, 3)
                If Pic >= 0 Then
                  With Picture2(0)
                    .CurrentX = X1 - YSCALE
                    .CurrentY = Y1 - sInData(X0 + I1, Y0 + J1, 4)
                    '.print Pic
                   End With
                 Picture2(0).Print "[" & Pic & "]"
                 'Picture2(1).Circle (X1, Y1), 18, &HFF00
                End If

            End If
        Next I
    Next J
  
 
End Sub



Private Sub Command6_Click()
    'pic1.Cls
   ' Call ShowPicDIBn2
   ' Picture2(0).Refresh
    'txt1.Text = SinData1(txtX.Text, txty.Text)
   ' txt2.Text = SinData2(txtX.Text, txty.Text)
   ' txt3.Text = SinData3(txtX.Text, txty.Text)
   ' txt4.Text = SinData4(txtX.Text, txty.Text)
   ' txt5.Text = SinData5(txtX.Text, txty.Text)
   ' txt6.Text = SinData6(txtX.Text, txty.Text)
   ' txtoffset1 = txtsnum * 49152 + 0 * 8192& + txty * 128& + txtX * 2&
   ' txtoffset1 = Hex(txtoffset1)
   ' txtoffset2 = txtsnum * 49152 + 1 * 8192& + txty * 128& + txtX * 2&
   ' txtoffset2 = Hex(txtoffset2)
End Sub

' 读取场景地图并转化为32位rle
Private Function LoadSMap(mapNum As Long) As Long
Dim FileId As String, filePic As String, fileColor As String
Dim Filenum As Integer, filenum2 As Integer, tempstr1 As String
Dim I As Long
Dim Value As Integer
Dim offSet As Long
Dim picDataLong As Long
Dim Num As Long
Dim Xx As Long, Yy As Long

Dim picNum2
Dim mMapIdx() As Long
    FileId = GamePath & SDXxxx(CurrentMapIDX)
    filePic = GamePath & SMPxxx(CurrentMapIDX)
    tempstr1 = "由於讀取場景貼圖數據失敗，將無法繼續。"
    LoadSMap = 0
    If ChkRequiredFile(FileId, -1, tempstr1, tempstr1, "") < 2 Then Exit Function
    If ChkRequiredFile(filePic, -1, tempstr1, tempstr1, "") < 2 Then Exit Function
    Filenum = FreeFile()
    Open FileId For Binary Access Read As Filenum
    SmpMapNum = LOF(Filenum) / 4
    ReDim mMapIdx(SmpMapNum)
    ReDim mMapPic(SmpMapNum)
    mMapIdx(0) = 0
    For Num = 1 To SmpMapNum ' 地图贴图的索引个数
        Get Filenum, , mMapIdx(Num)
    Next Num
    Close Filenum
    Filenum = FreeFile()
    Open filePic For Binary Access Read As Filenum
    For Num = 0 To SmpMapNum - 1 ' 地图贴图的索引个数
        offSet = mMapIdx(Num)
        For I = Num To SmpMapNum - 1
         picDataLong = mMapIdx(1 + I) - mMapIdx(Num)
         If picDataLong > 0 Then Exit For
        Next
        If picDataLong > 0 Then '判斷是否有相同圖
            Get Filenum, offSet + 1, mMapPic(Num).Width
            Get Filenum, , mMapPic(Num).Height
            Get Filenum, , mMapPic(Num).X
            Get Filenum, , mMapPic(Num).Y
            mMapPic(Num).dataLong = picDataLong - 8
            ReDim mMapPic(Num).Data(mMapPic(Num).dataLong - 1)
            'For i = 0 To mmapPic(num).dataLong - 1
            Get Filenum, , mMapPic(Num).Data
            'Next i
            Call RLEto32(mMapPic(Num))
        Else
            mMapPic(Num).Width = mMapPic(Num - 1).Width
            mMapPic(Num).Height = mMapPic(Num - 1).Height
            mMapPic(Num).X = mMapPic(Num - 1).X
            mMapPic(Num).Y = mMapPic(Num - 1).Y
            mMapPic(Num).dataLong = mMapPic(Num - 1).dataLong
            ReDim mMapPic(Num).Data(mMapPic(Num).dataLong - 1)
            mMapPic(Num).Data = mMapPic(Num - 1).Data
            Call RLEto32(mMapPic(Num))
        End If
            
            
    Next Num
    Close Filenum

    LoadSMap = 1
End Function
' 生成图象数据到addr指向的地址
' picnum 贴图编号
' width height addr指向的dib宽高
' x1,y1,绘图位置
Private Sub genPicData(picNum As Long, addR As Long, Width As Long, Height As Long, ByVal X1 As Long, ByVal Y1 As Long)
Dim I As Long, J As Long
Dim X As Long, Y As Long
Dim Row As Byte
Dim Start As Long
Dim P As Long
Dim MaskNum As Byte
Dim SolidNum As Byte
Dim Yoffset As Long
Dim Xoffset As Long
Dim offSet As Long
    
    X1 = X1 - mMapPic(picNum).X
    Y1 = Y1 - mMapPic(picNum).Y
    
    If X1 >= 0 And Y1 >= 0 And X1 + mMapPic(picNum).Width < Width And Y1 + mMapPic(picNum).Height < Height Then
        P = 0
        For I = 1 To mMapPic(picNum).Height
            Y = I
            Yoffset = (Y + Y1 - 1) * Width
            
            Row = mMapPic(picNum).Data(P)
            Start = P
            P = P + 1
            If Row > 0 Then
                X = 0
                Do
                    X = X + mMapPic(picNum).Data(P)
                    If X >= mMapPic(picNum).Width Then
                        Exit Do
                    End If
                    P = P + 1
                    SolidNum = mMapPic(picNum).Data(P)
                    P = P + 1
                    Xoffset = X + (X1)
                    offSet = Xoffset + Yoffset
                    Call CopyMemory(ByVal (addR + offSet * 4), mMapPic(picNum).Data32(P), 4 * SolidNum)
                    X = X + SolidNum
                    P = P + SolidNum
                    If X >= mMapPic(picNum).Width Then
                        Exit Do
                    End If
                    If P - Start >= Row Then
                        Exit Do
                    End If
                Loop
                If P + 1 >= mMapPic(picNum).dataLong Then
                    Exit For
                End If
            End If
        Next I
    Else
        P = 0
        For I = 1 To mMapPic(picNum).Height
            Y = I
            Yoffset = (Y + Y1 - 1) * Width
            
            Row = mMapPic(picNum).Data(P)
            Start = P
            P = P + 1
            If Row > 0 Then
                X = 0
                Do
                    X = X + mMapPic(picNum).Data(P)
                    If X >= mMapPic(picNum).Width Then
                        Exit Do
                    End If
                    P = P + 1
                    SolidNum = mMapPic(picNum).Data(P)
                    P = P + 1
                    Xoffset = X + (X1)
                    
                    If Y1 + Y - 1 >= 0 And Y1 + Y < Height And Xoffset + SolidNum >= 0 And Xoffset < Width Then
                        Dim p2 As Long
                        Dim ee As Long
                        
                        If Xoffset < 0 Then
                            offSet = Yoffset
                            p2 = P - Xoffset
                            ee = SolidNum + Xoffset
                        Else
                            offSet = Xoffset + Yoffset
                            p2 = P
                            ee = SolidNum
                        End If
                        If Xoffset + SolidNum >= Width Then
                            ee = ee - (Xoffset + SolidNum - Width + 1)
                        End If
                        Call CopyMemory(ByVal (addR + offSet * 4), mMapPic(picNum).Data32(p2), 4 * ee)
                    End If
                    X = X + SolidNum
                    P = P + SolidNum
                    If X >= mMapPic(picNum).Width Then
                        Exit Do
                    End If
                    If P - Start >= Row Then
                        Exit Do
                    End If
                Loop
                If P + 1 >= mMapPic(picNum).dataLong Then
                    Exit For
                End If
            End If
        Next I
    End If
            
End Sub



' 把贴图数据的8BitRLE压缩数据，转换为32Bit，方便以后处理
' RLE压缩格式：
' 第一个字节为第一行数据长度（几个字节）
' 后面一个字节为透明数据点个数，后面跟着为不透明数据点个数，然后是不透明的每个数据点8位颜色，
' 重复以上，直到第一行字节结束
' 读取下一行数据，直到没有后面数据
Private Sub RLEto32(Pic As RLEPic)
Dim P As Long  ' 指向RLE数据的指针
Dim p32 As Long   ' 指向32位非压缩数据的指针
Dim I As Long, J As Long
Dim Row As Byte
Dim Temp As Long
Dim Start As Long
Dim MaskNum As Long
Dim SolidNum As Long
   
    ReDim Pic.Data32(Pic.dataLong)

    P = 0
    p32 = 0
    For I = 1 To Pic.Height
        Row = Pic.Data(P)     ' 当前行数据个数
        Pic.Data32(P) = Row
        Start = P             ' 当前行起始位置
        P = P + 1             'P指向第一个点掩码个数
        If Row > 0 Then
            p32 = 0          'P32指向0
            Do
                MaskNum = Pic.Data(P)  ' 掩码个数
                Pic.Data32(P) = 0 ' MaskNum
                'Pic.Data32(P) = Row
                P = P + 1           'P指向第一个点
                p32 = p32 + MaskNum
                If p32 >= Pic.Width Then  ' 此掩码完成后位置指针已经指向最右端
                    Exit Do
                End If
                SolidNum = Pic.Data(P) ' 实际点的个数
                Pic.Data32(P) = SolidNum
                P = P + 1
                For J = 1 To SolidNum
                    Temp = Pic.Data(P)
                    Pic.Data32(P) = mColor_RGB(Temp)
                    p32 = p32 + 1
                    P = P + 1
                Next J
                If p32 >= Pic.Width Then   ' 实际点完成后位置指针已经指向最右端
                    Exit Do
                End If
                If P - Start >= Row Then           ' 当前行数据已经结束
                    Exit Do
                End If
            Loop
            If P + 1 >= Pic.dataLong Then
                Exit For
            End If
        End If
    Next I
   
End Sub



Private Sub Combo1_Click()
If Not Started Then Exit Sub
Busying = False
Text1(0).SetFocus
End Sub

Private Sub Combo2_Click()
If Not Started Then Exit Sub
Combo2En = False

CurrentMapIDX = Combo2.ListIndex
'ReadDx_GRPfile READMODE
'ReadSx_GRPfile READMODE
Label3.Caption = "場景:" & CurrentMapIDX
With MDIFormMain
  ReadInMapStru .mnu1_Layer(0).Checked, .mnu1_Layer(1).Checked, .mnu1_Layer(2).Checked, .mnu1_Layer(3).Checked
End With
Picture2(0).Refresh
  If Combo4(0).ListIndex > 0 Then
    VScroll2.Max = FileLen(GamePath & SDXxxx(CurrentMapIDX)) \ 4
    setStaBarText 7, "地面貼圖:0~" & VScroll2.Max
  Else
    VScroll2.Max = FileLen(GamePath & FMAP_IDX) \ 4
    setStaBarText 7, "底層貼圖:0~" & VScroll2.Max
  End If
End Sub

Private Sub Combo1_GotFocus()
Combo1En = True
Busying = True
End Sub

Private Sub Combo1_LostFocus()
Combo1En = False
RefreshText1
End Sub
Private Sub Combo2_GotFocus()
Combo2En = True
End Sub

Private Sub Combo2_LostFocus()
Combo2En = False
End Sub


Private Sub Combo4_Click(Index As Integer)

RefreshMode = Combo4(0).ListIndex
If Not Started Then Exit Sub
VScroll1.SetFocus

  If RefreshMode > 0 Then
    VScroll2.Max = FileLen(GamePath & SDXxxx(CurrentMapIDX)) \ 4
    setStaBarText 7, "地面貼圖:0~" & VScroll2.Max
    If RefreshMode > 2 Then Combo4(0).BackColor = vbRed Else Combo4(0).BackColor = vbBlue
    If RefreshMode < 4 Then Label4.Enabled = True Else Label4.Enabled = False
  Else
    VScroll2.Max = FileLen(GamePath & FMAP_IDX) \ 4
    setStaBarText 7, "底層貼圖:0~" & VScroll2.Max
    EnableAni = False
    Label4.Enabled = False: SelectedTileYadd = 0
  End If
    Label4.Caption = "貼圖海拔>" & SelectedTileYadd

End Sub


Private Sub Command1_Click(Index As Integer)
Dim I As Integer
Select Case Index
 Case 0           '搜索闲置
 For I = 0 To 199
 If AddAttrib(I, 9) + AddAttrib(I, 10) <= 0 Then
  CurrentEvtIDX = I
  Combo1.ListIndex = I
  RefreshText1
  Exit For
 End If
Next

End Select
End Sub

Private Sub Command1_MouseMove(Index As Integer, Button As Integer, Shift As Integer, X As Single, Y As Single)
Dim tempStr As String
Select Case Index
 Case 0           '搜索闲置
  tempStr = "搜索下一個未使用的事件，搜索條件爲X和Y都爲0"
 Case 1   '保存
  tempStr = "保存當前場景的事件和地圖，退出前別忘了點擊它"
 Case 2   '退出
  tempStr = "地圖編輯器很占資源，最好關閉再使用其它功能"
End Select
Command1(Index).ToolTipText = tempStr
End Sub

Private Sub Form_Activate()
Started = True
End Sub
Private Sub Form_Load()
'装载Form

Started = False
Randomize Timer
Busying = False
frmMapEdit_iniControls
RefreshMode = 3
SelectedTileYadd = 0
LayerEditMode = True
If Not palOK Then Call SetColor    '调色板初始化
setStaBarText 6, "動畫開"
setStaBarText 5, "模式:編輯"
'MDIFormMain.ProgressBar1.Max = 64
Combo2.ListIndex = 0
Combo1.ListIndex = 0
Combo4(0).ListIndex = 3
RefreshMode = 3
CurrentJinDu = 0
RefreshText1
EnableAni = True
Call DoWithMenu3(0)  '读进度
MDIFormMain.MousePointer = 0
MDIFormMain.mnuEditSx.Enabled = False
End Sub


Private Sub menuhelp_Click()

End Sub

Private Sub Form_QueryUnload(Cancel As Integer, UnloadMode As Integer)
Unload Me
End Sub

Private Sub Form_Unload(Cancel As Integer)
MDIFormMain.mnuEditSx.Enabled = True
End Sub

Private Sub Label1_Click(Index As Integer)
Select Case Index
 Case 0
  If Val(Text1(Index).Text) = 0 Then
   Text1(Index).Text = 1
  Else
   Text1(Index).Text = 0
  End If
 Case 2
  If MsgBox("要查看事件定義配置文件嗎？(evtlist.ini)", vbYesNo + vbQuestion, "提示") = vbYes Then
    Shell "notepad " & App.Path & "\evtlist.ini", vbNormalFocus
  End If
  Case 5, 6, 7

  Case 8
   EnableAni = Not EnableAni
   If EnableAni Then setStaBarText 6, "動畫開" Else setStaBarText 6, "動畫關"
 Case 9, 10
  Dim ret As String * 1
  ret = Chr$(13)
  MsgBox "《金庸群俠傳》斜45度視角地圖的坐標系統(x,y)如下:" & ret & "           (0,0)" & ret & "          *      *" & ret & "       *     北     *" & ret & "    *        ↑        *" & ret & "(0,60)   西←  →东   (60,0)" & ret & "    *        ↓        *" & ret & "       *     南     *" & ret & "          *      *" & ret & "          (60,60)" & ret & "x是从左上到右下递增的\，y是从右上到左下递增的/。" & ret & "但是改了也是无效的，因为真正有效的坐标是存在S?.GRP中。", vbInformation + vbOKOnly, "提示"
End Select
End Sub

Private Sub Label1_MouseMove(Index As Integer, Button As Integer, Shift As Integer, X As Single, Y As Single)
Select Case Index
Case 5, 6, 7
 VScroll2.Value = Val(Text1(Index).Text) \ 2
End Select
End Sub




Private Sub Label2_MouseMove(Index As Integer, Button As Integer, Shift As Integer, X As Single, Y As Single)
setStaBarText 1, "右鍵拾取/左鍵繪制"
End Sub

Private Sub Label4_MouseDown(Button As Integer, Shift As Integer, X As Single, Y As Single)
If Label4.Enabled = False Then Exit Sub
Dim tempINT As Integer
If Button = vbLeftButton Then tempINT = 1 Else tempINT = -1
SelectedTileYadd = SelectedTileYadd + tempINT
If SelectedTileYadd < 0 Then SelectedTileYadd = 199
If SelectedTileYadd > 199 Then SelectedTileYadd = 0
Label4.Caption = "貼圖海拔>" & SelectedTileYadd
End Sub
Private Sub Label5_Click()
PopupMenu MDIFormMain.mnu1
End Sub
Private Sub Label5_DblClick()
DoWithMenu1 0
End Sub


Private Sub Picture2_MouseDown(Index As Integer, Button As Integer, Shift As Integer, X As Single, Y As Single)
Select Case Index
Case 0
If Combo4(0).ListIndex < 0 Then Exit Sub
RefreshMode = Combo4(0).ListIndex
If xIndex < 0 Or yIndex < 0 Or xIndex > 63 Or yIndex > 63 Then Exit Sub
If LayerEditMode And Index = 0 And Not Busying And Button = vbLeftButton Then '左键绘图
 Drawing = True
 Picture2_MouseMove Index, Button, Shift, X, Y
 Exit Sub
End If

If Button = vbRightButton Then  '右键拾取
If sInData(xIndex, yIndex, Combo4(0).ListIndex) < 0 Then Exit Sub
Dim temp1 As Integer
 If RefreshMode = 3 Then
  temp1 = sInData(xIndex, yIndex, 3)
  Combo1.ListIndex = temp1
  CurrentEvtIDX = temp1
  RefreshText1
  SelectedTileIDX = AddAttrib(temp1, 5) / 2
  SelectedTileYadd = sInData(xIndex, yIndex, 4)
  VScroll2.Value = SelectedTileIDX
  Combo1En = False
 Else
   EnableAni = False
   setStaBarText 6, "動畫關"
   SelectedTileIDX = sInData(xIndex, yIndex, RefreshMode) / 2
   Combo1En = False
   If RefreshMode = 1 Or RefreshMode = 2 Then
    SelectedTileYadd = sInData(xIndex, yIndex, RefreshMode + 3)
    Label4.Caption = "貼圖海拔>" & SelectedTileYadd
   End If
 End If
 VScroll2.Value = SelectedTileIDX
End If

Case 1
 Picture2_MouseMove Index, Button, Shift, X, Y
Case 2
End Select
End Sub

Private Sub Picture2_MouseMove(Index As Integer, Button As Integer, Shift As Integer, X As Single, Y As Single)
'显示当前坐标
If Busying Then Exit Sub
If Drawing Then
 Dim yTemp As Long, I As Integer
 Select Case RefreshMode
  Case 0, 1, 2, 4, 5
   EnableAni = False
   setStaBarText 6, "動畫關"
   If RefreshMode = 1 Or RefreshMode = 2 Then sInData(xIndex, yIndex, RefreshMode + 3) = SelectedTileYadd
   DrawTile45 RefreshMode, Index, xIndex, yIndex, SelectedTileYadd, SelectedTileIDX
   sInData(xIndex, yIndex, RefreshMode) = SelectedTileIDX * 2
  Case 3
   sInData(xIndex, yIndex, 4) = SelectedTileYadd
   DrawTile45 RefreshMode, Index, xIndex, yIndex, SelectedTileYadd, SelectedTileIDX
   AddAttrib(CurrentEvtIDX, 5) = SelectedTileIDX * 2
   AddAttrib(CurrentEvtIDX, 9) = xIndex
   AddAttrib(CurrentEvtIDX, 10) = yIndex
   Dim Xx As Integer, Yy As Integer
   For Xx = 0 To 63
    For Yy = 0 To 63
     If Xx = xIndex And Yy = yIndex Then sInData(xIndex, yIndex, RefreshMode) = AddAttrib(CurrentEvtIDX, 1)
    Next
   Next
   RefreshText1
   setStaBarText 1, "第" & CurrentEvtIDX & "個事件被移到坐標" & xIndex & "/" & yIndex & ",請手動修改其它數據"
   Call PackLayer3
 End Select
 Picture2(Index).Refresh
End If
If Index = 1 And Button = 1 Then
    Dim tempINT As Integer
    With Picture2(0)
        tempINT = Y * (VScroll1.Max / .Height)
        tempINT = -tempINT * (tempINT > -1)
        If tempINT > VScroll1.Max Then tempINT = VScroll1.Max
        VScroll1 = tempINT
        tempINT = X * (HScroll1.Max / .Width)
        tempINT = -tempINT * (tempINT > -1)
        If tempINT > HScroll1.Max Then tempINT = HScroll1.Max
        HScroll1 = tempINT
    End With
    Exit Sub
End If
If Index <> 0 Then Exit Sub
With GetiMapPos(X, Y)
 xIndex = .X: yIndex = .Y
End With
'CurrentMouseXindex = xIndex: CurrentMouseYindex = yIndex
setStaBarText 2, "X:" & xIndex & "  Y:" & yIndex
If xIndex < 0 Or yIndex < 0 Or xIndex > 63 Or yIndex > 63 Then Exit Sub
With Pos2Pixel(xIndex, yIndex)
 PointX = .X + XSCALE
 PointY = .Y + YSCALE
End With
 ux = PointX: uy = PointY - YSCALE
 lx = PointX - XSCALE: ly = PointY
 dx = PointX: dy = PointY + YSCALE
 rx = PointX + XSCALE: ry = PointY
Line1(0).X1 = ux: Line1(0).Y1 = uy: Line1(0).X2 = rx: Line1(0).Y2 = ry
Line1(1).X1 = rx: Line1(1).Y1 = ry: Line1(1).X2 = dx: Line1(1).Y2 = dy
Line1(2).X1 = dx: Line1(2).Y1 = dy: Line1(2).X2 = lx: Line1(2).Y2 = ly
Line1(3).X1 = lx: Line1(3).Y1 = ly: Line1(3).X2 = ux: Line1(3).Y2 = uy
If RefreshMode = 0 Then
 inMapIdxFile = GamePath & FMAP_IDX
 inMapFile = GamePath & FMAP_GRP   '底层帖图调文件
Else
 inMapIdxFile = GamePath & SDXxxx(CurrentMapIDX)
 inMapFile = GamePath & SMPxxx(CurrentMapIDX)      '2，3层帖图调文件
End If
Select Case Combo4(0).ListIndex
  Case 0, 3, 4, 5
  setStaBarText 3, "貼圖:" & sInData(xIndex, yIndex, Combo4(0).ListIndex)
  Case 1, 2
  setStaBarText 3, "貼圖:" & sInData(xIndex, yIndex, Combo4(0).ListIndex)
  setStaBarText 4, "海拔:" & sInData(xIndex, yIndex, Combo4(0).ListIndex + 3)
End Select

End Sub

Private Sub Picture2_MouseUp(Index As Integer, Button As Integer, Shift As Integer, X As Single, Y As Single)
Drawing = False
End Sub

Private Sub Text1_Change(Index As Integer)
If Busying Then Exit Sub
Dim tempstr1 As String
tempstr1 = Text1(Index).Text
If Len(tempstr1) > 5 Then Text1(Index).Text = "0"
If Len(tempstr1) = 5 And Left(tempstr1, 4) > 3275 And Right(tempstr1, 1) > 7 Then Text1(Index).Text = "0"
tempstr1 = Text1(Index).Text
Text1(Index).ToolTipText = "十六進制數爲：" + Hex$(Val(tempstr1))
AddAttrib(CurrentEvtIDX, Index) = Val(tempstr1)
If (Index = 2 Or Index = 3 Or Index = 4) And Val(tempstr1) < Combo3.ListCount And Val(tempstr1) >= 0 Then
 Combo3.ListIndex = Val(tempstr1)
 setStaBarText 1, "事件:" & Combo3.List(Val(tempstr1))
End If

End Sub

Private Sub Text1_KeyPress(Index As Integer, KeyAscii As Integer)
Dim tempstr1 As String
tempstr1 = Text1(Index).Text
Select Case Chr(KeyAscii)
 Case "0" To "9"
 Case "-"
  If tempstr1 = "" Then Exit Sub
  If Left(tempstr1, 1) = "-" Then KeyAscii = 0: Exit Sub
  Text1(Index).Text = "-" & tempstr1: KeyAscii = 0
 Case Chr(vbKeyBack)
 Case Else
  KeyAscii = 0
End Select
End Sub

Private Sub Text1_LostFocus(Index As Integer)
If Text1(Index).Text = "-" Or Text1(Index).Text = "" Then Text1(Index).Text = "0"
Text1(Index).Text = Val(Text1(Index).Text)
End Sub

Private Sub Text1_MouseMove(Index As Integer, Button As Integer, Shift As Integer, X As Single, Y As Single)
Dim tempstr1 As String, tempINT As Integer
tempstr1 = Text1(Index).Text
tempINT = Val(tempstr1)
Select Case Index
Case 0
 tempstr1 = "通過爲0,不可過爲1"
 If tempINT < 0 Or tempINT > 1 Then tempstr1 = tempstr1 & "，此數據超出範圍!"
Case 0
 tempstr1 = "編號可以重複，取值範圍0~199"
 If tempINT < 0 Or tempINT > 1 Then tempstr1 = tempstr1 & "，此數據超出範圍!"

Case 2, 3, 4
 tempstr1 = "事件:" & Combo3.List(Val(tempstr1))
 If Val(tempstr1) >= Combo3.ListCount Then tempstr1 = "原始事件編號0~1017，此數據可能超出範圍!"
 If Val(tempstr1) < 0 Then tempstr1 = "-1表示沒有事件，其它負數可能無意義。"
Case 5
 If Text1(5) And Text1(6) And Text1(7) Then tempstr1 = "靜態貼圖"
Case 8
 tempstr1 = "速度要小於100，越小越快"
Case 9
Case 10
End Select
setStaBarText 1, tempstr1
End Sub

Private Sub Timer1_Timer()
On Error Resume Next
If Combo1En Then
 'If CurrentEvtIDX <> Combo1.ListIndex Then
 RefreshText1
 
 VScroll2.Value = AddAttrib(Combo1.ListIndex, 5) \ 2

End If

On Error GoTo 0
If Busying Then Exit Sub

If EnableAni Then
 aniFrameIndex = aniFrameIndex + 1
 If aniFrameIndex > 2 Then aniFrameIndex = 0
 VScroll2.Value = AddAttrib(Combo1.ListIndex, 5 + aniFrameIndex) \ 2
End If
If Combo2En Then setStaBarText 5, "場景:" & Combo2.ListIndex

End Sub

Private Sub VScroll1_Change()
Picture2(0).Top = -VScroll1.Value
Shape1.Top = VScroll1.Value
End Sub
Private Sub VScroll1_scroll()
Picture2(0).Top = -VScroll1.Value
Shape1.Top = VScroll1.Value
End Sub
Private Sub HScroll1_Scroll()
Picture2(0).Left = -HScroll1.Value
Shape1.Left = HScroll1.Value
End Sub
Private Sub HScroll1_change()
Picture2(0).Left = -HScroll1.Value
Shape1.Left = HScroll1.Value
End Sub

Private Sub frmMapEdit_iniControls()
'初始化窗体
  Wd640 = 2304
  Ht480 = 1152

Dim I As Integer
For I = 1 To 3
 Load Line1(I)
 Line1(I).Visible = True
Next
For I = 0 To 199
 Combo1.AddItem I
Next
For I = 0 To 5
 Combo4(0).AddItem "第" & I & "層"
Next
For I = 0 To Combo3.ListCount - 1
 Combo3.RemoveItem I
Next
ReadEvent Combo3   '读事件代码文件
Call SetComboHeight(Combo2, 500)
Call SetComboWidth(Combo2, 130)

For I = 0 To 83
 Combo2.List(I) = Left(Combo2.List(I), 5) & SMPxxx(I)
Next
Me.Icon = MDIFormMain.Icon
Label1(8).MouseIcon = Label5.MouseIcon
VScroll1.Max = Ht480 - VScroll1.Height - 15
HScroll1.Max = Wd640 - HScroll1.Width - 22
VScroll1.Value = VScroll1.Max / 3
HScroll1.Value = HScroll1.Max * 0.4
'Picture1.Width = Wd640
'Picture1.Height = Ht480
Picture2(0).Width = Wd640
Picture2(0).Height = Ht480
Label1(0) = "能否通過"
Label1(1) = "編號"
Label1(2) = "事件1"
Label1(3) = "事件2"
Label1(4) = "事件3"
Label1(5) = "貼圖1"
Label1(6) = "貼圖2"
Label1(7) = "貼圖3"
Label1(8) = "動畫速度"
Label1(9) = "橫坐標X"
Label1(10) = "縱坐標Y"

Label1(0).ToolTipText = "0能通過，1不能通過"
Label1(2).ToolTipText = "表示主角在該觸發點調查所引發的事件。詳細指令定義請查閱游泳的魚之“事件對話編輯器”"
Label1(3).ToolTipText = "主角使用物品時觸發"
Label1(4).ToolTipText = "主角走過時觸發"
Label1(5).ToolTipText = "決定了該觸發點顯示的什麽。例如寶箱、樹木、草地、人等等......(單擊使另兩個貼圖與此相同)"
Label1(6).ToolTipText = "如果與貼圖1不同，則會顯示爲動畫"
Label1(7).ToolTipText = "同上，值不同時會顯示爲動畫"
Label1(8).ToolTipText = "單擊開始/停止動畫"
Label1(9).ToolTipText = "取0到60"
Label1(10).ToolTipText = "取0到60"
Command1(0).ToolTipText = "自動找尋下一個未用的事件(共200個)"
Label4.ToolTipText = "不可超過200，因爲遊戲分辨率是320*200"

Label3 = "場景0"
Command1(0).Caption = "搜索閑置"
Frame1(0).Caption = "事件"
Frame1(1).Caption = "場景結構"
Label2(0) = "操作區"
Label2(2) = "貼圖索引>"
Label4 = "貼圖海拔>"
Label5 = "<快捷菜單>"
For I = 0 To Combo2.ListCount - 1
 Combo2.List(I) = Combo2.List(I)
Next
End Sub
Sub ReadEvent(combo_Obj As ComboBox)
'读事件代码文件1018个
Dim evtFile As Integer, tempstr1 As String
tempstr1 = "事件定義查閱列表將不可用。"
'If Dir(App.Path & "\evtlist.ini") = "" Then Exit Sub
If ChkRequiredFile(App.Path & "\evtlist.ini", -1, tempstr1, tempstr1, "") < 3 Then Exit Sub
evtFile = FreeFile
Open App.Path & "\evtlist.ini" For Input As evtFile
'If LOF(evtFile) < 500 Then Close evtFile: Exit Sub

Do
 Line Input #evtFile, tempstr1
 If EOF(evtFile) Then Close evtFile: Exit Sub
Loop Until Trim(tempstr1) = "[事件代號]"

Do
  Line Input #evtFile, tempstr1
  combo_Obj.AddItem Trim(tempstr1)
Loop Until EOF(evtFile)

Close evtFile
Call SetComboHeight(combo_Obj, 500)
Call SetComboWidth(combo_Obj, 400)

End Sub
Function ReadDx_GRPfile(Mode As Integer) As String
'读一个场景地图事件,200个
Dim K As Integer, M As Integer
Dim FileNum1 As Integer, tempstr1 As String, Filename As String
Filename = GamePath & Dx_GRP(CurrentJinDu)
If Mode = READMODE Then
  tempstr1 = "由於讀場景數據失敗，將無法繼續"
  If ChkRequiredFile(Filename, 440000, tempstr1, tempstr1, "讀取場景數據可能會出錯。") < 2 Then Exit Function
End If
FileNum1 = FreeFile
Open Filename For Binary As #FileNum1
temp4 = 400& * 11 * CurrentMapIDX + 1
Seek #FileNum1, temp4
 For K = 0 To 199
  For M = 0 To 10
   If Mode = READMODE Then
    Get #FileNum1, , AddAttrib(K, M)
   Else
    Put #FileNum1, , AddAttrib(K, M)
   End If
  Next
 Next
Close #FileNum1
RefreshText1
End Function
Function ReadSx_GRPfile(Mode As Integer) As String
'读一个场景地图结构数据，6层
Dim K As Integer, Y As Integer, X As Integer
Dim FileNum1 As Integer, tempStr As String
FileNum1 = FreeFile
Open GamePath & Sx_GRP(CurrentJinDu) For Binary As #FileNum1
   Seek #FileNum1, sinID(CurrentMapIDX) + 1
   If Mode = READMODE Then
    Get FileNum1, , sInData()
   Else
    Put FileNum1, , sInData()
   End If
Close #FileNum1
If Mode = READMODE Then tempStr = "讀取" Else tempStr = "保存"
setStaBarText 1, "進度" & (CurrentJinDu + 1) & "場景" & CurrentMapIDX & "數據" & tempStr & "完畢"
End Function

Function DrawTile45(RefreshMode As Integer, PictureboxIndex As Integer, xIndex As Integer, yIndex As Integer, yAdd As Integer, TileTypeIndex As Long) As Integer
RefreshMode = Combo4(0).ListIndex
Select Case RefreshMode
Case 0
 inMapIdxFile = GamePath & FMAP_IDX
 inMapFile = GamePath & FMAP_GRP   '底层帖图调文件
Case 1 To 5
 inMapIdxFile = GamePath & SDXxxx(CurrentMapIDX)
 inMapFile = GamePath & SMPxxx(CurrentMapIDX)      '2，3层帖图调文件
End Select
 Dim prePoint1 As POINTAPI
 PointX = XSCALE * 64 + (xIndex - yIndex) * XSCALE
 PointY = (xIndex + yIndex + 3) * YSCALE
 ux = PointX: uy = PointY - YSCALE
 MoveToEx Picture2(PictureboxIndex).hdc, ux, uy - yAdd, prePoint1
 Select Case PictureboxIndex
  Case 0
   Call DrawOneTile2(Picture2(PictureboxIndex), Picture2(2), ux, uy - yAdd, 0, 0, inMapFile, inMapIdxFile, TileTypeIndex, True, False)
  Case 1
   Picture2(PictureboxIndex).Circle (PointX, PointY), 9, TileTypeIndex
 End Select
End Function


Sub RefreshText1()
If Combo1.ListIndex < 0 Then Exit Sub
Dim I As Integer
For I = 0 To 10
 Text1(I).Text = AddAttrib(Combo1.ListIndex, I)
Next
CurrentEvtIDX = Combo1.ListIndex
End Sub

Private Sub VScroll2_Change()
'If Busying Then Exit Sub
Select Case Combo4(0).ListIndex
Case 0
 inMapIdxFile = GamePath & FMAP_IDX
 inMapFile = GamePath & FMAP_GRP   '底层帖图调文件
Case 1 To 5
 inMapIdxFile = GamePath & SDXxxx(CurrentMapIDX)
 inMapFile = GamePath & SMPxxx(CurrentMapIDX)      '2，3层帖图调文件
Case Else
 Exit Sub
End Select
SelectedTileIDX = VScroll2.Value
Label2(2).Caption = "貼圖索引>" & SelectedTileIDX
'Picture2(2).Cls
DrawOneTile2 Nothing, Picture2(2), 0, 0, 0, 0, inMapFile, inMapIdxFile, SelectedTileIDX, False, True
Picture2(2).Refresh
End Sub

Sub PackLayer3()
Dim X As Integer, Y As Integer, I As Integer
For X = 0 To 63
 For Y = 0 To 63
  sInData(X, Y, 3) = -1
 Next
Next
For I = 0 To 199
 X = AddAttrib(I, 9) Mod 64
 Y = AddAttrib(I, 10) Mod 64
 If X > 0 And Y > 0 Then sInData(X, Y, 3) = I ' AddAttrib(i, 1)
Next
End Sub

Sub DoWithMenu1(Index As Integer)
Select Case Index
 Case 0
  With MDIFormMain
   Call ShowPicDIBn2(.mnu1_Layer(0).Checked, .mnu1_Layer(1).Checked, .mnu1_Layer(2).Checked, .mnu1_Layer(3).Checked)
  End With
 Case 1
    Picture2(1).Visible = Not Picture2(1).Visible
    MDIFormMain.mnu1MapEdit1(1).Checked = Picture2(1).Visible
 Case 2
    Clipboard.Clear
    Clipboard.SetData Picture2(0).Image
 Case 3
   On Error Resume Next
   Dim systemDir As String, winDir As String, A1 As String, A2 As String
   systemDir = Space(255): winDir = Space(255)
   GetSystemDirectory systemDir, 255
   GetWindowsDirectory winDir, 255
   A1 = Left(Trim(systemDir), Len(Trim(systemDir)) - 1)
   A2 = Left(Trim(winDir), Len(Trim(winDir)) - 1)
   Shell A1 & "\mspaint", vbNormalFocus
   Shell A2 & "\mspaint", vbNormalFocus
   Shell Left(A2, 2) & "\Program Files\Accessories\mspaint", vbNormalFocus
   On Error GoTo 0
 Case 4
    Dim tempStr As String
    LayerEditMode = Not LayerEditMode
    MDIFormMain.mnu1MapEdit1(4).Checked = LayerEditMode
    If LayerEditMode Then tempStr = "編輯" Else tempStr = "鎖定"
    setStaBarText 5, "模式:" & tempStr
 Case 5
    MDIFormMain.mnu1MapEdit1(5).Checked = Not MDIFormMain.mnu1MapEdit1(5).Checked
    DoWithMenu1 0
 Case 6
    With MDIFormMain.mnu1MapEdit1(6)
       .Checked = Not .Checked
       If .Checked Then
         'Load frmTool1
         'Call ResetTool1
        Else
         'Unload frmTool1
       End If
    End With
End Select
End Sub

Sub DoWithMenu2(Index As Integer)
With MDIFormMain      '选层
    .mnu1_Layer(Index).Checked = Not .mnu1_Layer(Index).Checked
End With
Call DoWithMenu1(0)
End Sub
Sub DoWithMenu3(Index As Integer)
Me.MousePointer = 11
With MDIFormMain       '选择进度
    .mnu1_Jindu(CurrentJinDu).Checked = False
    CurrentJinDu = Index
    Me.Caption = "地圖編輯器-進度" & (CurrentJinDu + 1)
    .mnu1_Jindu(CurrentJinDu).Checked = True
    ReadInMapStru .mnu1_Layer(0).Checked, .mnu1_Layer(1).Checked, .mnu1_Layer(2).Checked, .mnu1_Layer(3).Checked
 End With
End Sub
Sub DoWithMenu4(Index As Integer)
Select Case Index
 Case 0    '保存
  ReadDx_GRPfile SAVEMODE
  ReadSx_GRPfile SAVEMODE
  MsgBox GamePath & Dx_GRP(CurrentJinDu) & vbCrLf & GamePath & Sx_GRP(CurrentJinDu) & vbCrLf & "文件写入成功！", vbInformation
 Case 1
  Unload Me
End Select
End Sub


Sub DoWithMenu5(Index As Integer)
Dim I As Integer
Select Case Index
 Case 0
      With MDIFormMain
       If .mnu1_Grid(0).Checked Then Exit Sub
       .mnu1_Grid(0).Checked = True
       For I = 2 To 7
        .mnu1_Grid(I).Checked = False
       Next
       On Error Resume Next
       Line2(0).Visible = False
       Line2(0).BorderColor = Line2(1).BorderColor
       For I = 1 To 129
        Unload Line2(I)
       Next
       On Error GoTo 0
       .mnu1_Grid(1).Enabled = False
      End With
 Case 1
        Dim Cc As ChooseColor, Rtn As Long
        Cc.lStructSize = Len(Cc)
        Cc.hwndOwner = Me.hwnd
        Cc.hInstance = App.hInstance
        Cc.flags = 0
        Cc.lpCustColors = String$(16 * 4, 0)
        Rtn = ChooseColor(Cc)
        If Rtn < 1 Then Exit Sub
        On Error Resume Next
        For I = 0 To 129
          Line2(I).BorderColor = Cc.rgbResult
        Next
        On Error GoTo 0
 Case 2 To 7
        With MDIFormMain
         For I = 0 To 7
         .mnu1_Grid(I).Checked = False
         Next I
         .mnu1_Grid(1).Enabled = True
         .mnu1_Grid(Index).Checked = True
        End With
        Dim K As Integer
        K = Index   '8位
        On Error Resume Next
        Line2(0).Visible = True
        Line2(0).BorderColor = Line2(1).BorderColor
        For I = 1 To 129
           Unload Line2(I)
        Next
        On Error GoTo 0
        
        For I = 1 To 2 ^ K + 1
         Load Line2(I)
         Line2(I).Visible = True
        Next
        
        For I = 0 To 2 ^ (K - 1)
         With Line2(I)
          If I Mod (2 ^ (K - 2)) = 0 Then .BorderColor = &HFF
         .X1 = Wd640 / 2 + I * (Wd640 / 2 ^ K): .Y1 = I * (Ht480 / 2 ^ K)
         .X2 = .X1 - Wd640 / 2: .Y2 = .Y1 + Ht480 / 2
         End With
         With Line2(I + 2 ^ (K - 1) + 1)
         If I Mod (2 ^ (K - 2)) = 0 Then .BorderColor = &HFF
         .X1 = Wd640 / 2 - I * (Wd640 / 2 ^ K): .Y1 = I * (Ht480 / 2 ^ K)
         .X2 = .X1 + Wd640 / 2: .Y2 = .Y1 + Ht480 / 2
         End With
        Next
End Select
End Sub

