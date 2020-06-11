
// INCLUDES ///////////////////////////////////////////////////////////////////

#include "config.h"
#include "FH_Log.h"
#include "FH_File.h"

// DEFINES ////////////////////////////////////////////////////////////////////
// MACROS /////////////////////////////////////////////////////////////////////
// TYPES //////////////////////////////////////////////////////////////////////
// CLASS //////////////////////////////////////////////////////////////////////
// PROTOTYPES /////////////////////////////////////////////////////////////////
// EXTERNALS //////////////////////////////////////////////////////////////////

extern CLog g_Log;

// GLOBALS ////////////////////////////////////////////////////////////////////

// 默认设置
const int  nFRAME_WIDTH		= 640;
const int  nFRAME_HEIGHT	= 480;
const int  nFRAME_RATE		= 60;
const int  nFRAME_BPP		= 32;
const bool bFULL_SCREEN		= false;
const bool bV_SYNC			= false;

const char fnMMAP_GRP[] = "MMAP.GRP";			// 世界地图相关文件名
const char fnMMAP_IDX[] = "MMAP.IDX";
const char fnMMAP_COL[] = "MMAP.COL";
const char fnEARTH[]	= "EARTH.002";
const char fnSURFACE[]	= "SURFACE.002";
const char fnBUILDING[] = "BUILDING.002";
const char fnBUILDX[]	= "BUILDX.002";
const char fnBUILDY[]	= "BUILDY.002";

// FUNCTIONS //////////////////////////////////////////////////////////////////

//-----------------------------------------------------------------------------
// Name: Load()
// Desc: 从文件中载入设置，并保证所有设置都是正确数据（在字面上正确，比如文件名不为空）
//-----------------------------------------------------------------------------
int CConfig::Load()
	{
	///////////////////////////////////////////////////////////
	// 如果还没有获取设置文件名，则获取之

	if (m_gcCfgFn[0] == '\0')
		{
		// 获得在执行文件所在文件夹中的、文件名与执行文件相同的、扩展名为ini的文件的完整路径
		if ( GetExeFileName_WithExt(m_gcCfgFn, "ini") != 0 )
			{
			g_Log.Write("获取ini文件名失败\r\n");
			return -1;
			}
		}

	///////////////////////////////////////////////////////////
	// 读取设置
	// 读取失败时安排了默认数据，所以绝不会返回错误值

	m_nFrameWidth = GetPrivateProfileInt("Config", "ScreenX", nFRAME_WIDTH, m_gcCfgFn);
	m_nFrameHeight = GetPrivateProfileInt("Config", "ScreenY", nFRAME_HEIGHT, m_gcCfgFn);
	m_nFrameRate = GetPrivateProfileInt("Config", "FrameRate", nFRAME_RATE, m_gcCfgFn);
	m_nFrameBpp = GetPrivateProfileInt("Config", "ColorDepth", nFRAME_BPP, m_gcCfgFn);
	m_bFullScreen =
		(GetPrivateProfileInt("Config", "FullScreen", bFULL_SCREEN, m_gcCfgFn) != 0) ? true : false;
	m_bVSync =
		(GetPrivateProfileInt("Config", "VerticalSync", bV_SYNC, m_gcCfgFn) != 0) ? true : false;

	// 读取世界地图相关文件名
	GetPrivateProfileString("World Map", "GRP", fnMMAP_GRP, m_fnMmapGrp, MAX_PATH, m_gcCfgFn);
	GetPrivateProfileString("World Map", "IDX", fnMMAP_IDX, m_fnMmapIdx, MAX_PATH, m_gcCfgFn);
	GetPrivateProfileString("World Map", "COL", fnMMAP_COL, m_fnMmapCol, MAX_PATH, m_gcCfgFn);
	GetPrivateProfileString("World Map", "Earth", fnEARTH, m_fnEarth, MAX_PATH, m_gcCfgFn);
	GetPrivateProfileString("World Map", "Surface", fnSURFACE, m_fnSurface, MAX_PATH, m_gcCfgFn);
	GetPrivateProfileString("World Map", "Building", fnBUILDING, m_fnBuilding, MAX_PATH, m_gcCfgFn);
	GetPrivateProfileString("World Map", "BuildX", fnBUILDX, m_fnBuildx, MAX_PATH, m_gcCfgFn);
	GetPrivateProfileString("World Map", "BuildY", fnBUILDY, m_fnBuildy, MAX_PATH, m_gcCfgFn);

	///////////////////////////////////////////////////////////
	// 修正设置
	// 修正得不精确，最好参照系统属性

	if (m_nFrameWidth <= 0 || m_nFrameWidth > 10000)
		m_nFrameWidth = nFRAME_WIDTH;

	if (m_nFrameHeight <= 0 || m_nFrameHeight > 10000)
		m_nFrameHeight = nFRAME_HEIGHT;

	if (m_nFrameRate < 0 || m_nFrameRate > 1000)
		m_nFrameRate = nFRAME_RATE;

	if (m_nFrameBpp <= 0 || m_nFrameBpp > 64 || m_nFrameBpp % 8 != 0)
		m_nFrameBpp = nFRAME_BPP;

	// 修正世界地图相关文件名
	if (!*m_fnMmapGrp) strcpy(m_fnMmapGrp, fnMMAP_GRP);
	if (!*m_fnMmapIdx) strcpy(m_fnMmapIdx, fnMMAP_IDX);
	if (!*m_fnMmapCol) strcpy(m_fnMmapCol, fnMMAP_COL);
	if (!*m_fnEarth) strcpy(m_fnEarth, fnEARTH);
	if (!*m_fnSurface) strcpy(m_fnSurface, fnSURFACE);
	if (!*m_fnBuilding) strcpy(m_fnBuilding, fnBUILDING);
	if (!*m_fnBuildx) strcpy(m_fnBuildx, fnBUILDX);
	if (!*m_fnBuildy) strcpy(m_fnBuildy, fnBUILDY);

	return 0;
	} // end Load



//-----------------------------------------------------------------------------
// Name: Reset()
// Desc: 恢复默认设置
//-----------------------------------------------------------------------------
void CConfig::Reset()
	{
	m_nFrameWidth = nFRAME_WIDTH;
	m_nFrameHeight = nFRAME_HEIGHT;
	m_nFrameRate = nFRAME_RATE;
	m_nFrameBpp = nFRAME_BPP;
	m_bFullScreen = bFULL_SCREEN;
	m_bVSync = bV_SYNC;

	// 世界地图相关文件名
	strcpy(m_fnMmapGrp, fnMMAP_GRP);
	strcpy(m_fnMmapIdx, fnMMAP_IDX);
	strcpy(m_fnMmapCol, fnMMAP_COL);
	strcpy(m_fnEarth, fnEARTH);
	strcpy(m_fnSurface, fnSURFACE);
	strcpy(m_fnBuilding, fnBUILDING);
	strcpy(m_fnBuildx, fnBUILDX);
	strcpy(m_fnBuildy, fnBUILDY);
	} // end Reset



//-----------------------------------------------------------------------------
// Name: Save()
// Desc: 保存当前设置到文件
//-----------------------------------------------------------------------------
int CConfig::Save()
	{
	///////////////////////////////////////////////////////////
	// 检查文件名是否有效

	if (m_gcCfgFn[0] == '\0')
		{
		g_Log.Write("在载入设置前就试图保存设置\r\n");
		return -1;
		}

	///////////////////////////////////////////////////////////
	// 保存设置到指定文件
	// 如果该文件不存在，函数会自动创建一个
	// WritePrivateProfileString: 当写入失败，或者所有参数都为0（把所有ini缓冲数据写入硬盘）时返回0
	// 如果每次都检查就太麻烦了，只检查第一个

	char str[65];		// _itoa()的结果最多65字节
	int result;

	result = WritePrivateProfileString("Config", "ScreenX", _itoa(m_nFrameWidth, str, 10), m_gcCfgFn);
	if (result == 0)
		{
		g_Log.Write("把设置保存到文件中时失败\r\n");
		return -1;
		}
	WritePrivateProfileString("Config", "ScreenY", _itoa(m_nFrameHeight, str, 10), m_gcCfgFn);
	WritePrivateProfileString("Config", "FrameRate", _itoa(m_nFrameRate, str, 10), m_gcCfgFn);
	WritePrivateProfileString("Config", "ColorDepth", _itoa(m_nFrameBpp, str, 10), m_gcCfgFn);
	WritePrivateProfileString("Config", "FullScreen", _itoa(m_bFullScreen?1:0, str, 10), m_gcCfgFn);
	WritePrivateProfileString("Config", "VerticalSync", _itoa(m_bVSync?1:0, str, 10), m_gcCfgFn);

	// 保存世界地图相关文件名
	WritePrivateProfileString("World Map", "GRP", m_fnMmapGrp, m_gcCfgFn);
	WritePrivateProfileString("World Map", "IDX", m_fnMmapIdx, m_gcCfgFn);
	WritePrivateProfileString("World Map", "COL", m_fnMmapCol, m_gcCfgFn);
	WritePrivateProfileString("World Map", "Earth", m_fnEarth, m_gcCfgFn);
	WritePrivateProfileString("World Map", "Surface", m_fnSurface, m_gcCfgFn);
	WritePrivateProfileString("World Map", "Building", m_fnBuilding, m_gcCfgFn);
	WritePrivateProfileString("World Map", "BuildX", m_fnBuildx, m_gcCfgFn);
	WritePrivateProfileString("World Map", "BuildY", m_fnBuildy, m_gcCfgFn);

	return 0;
	} // end Save
