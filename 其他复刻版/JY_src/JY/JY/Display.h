//-----------------------------------------------------------------------------
// Game.cpp - 显示图像
//-----------------------------------------------------------------------------

// INCLUDES ///////////////////////////////////////////////////////////////////
// DEFINES ////////////////////////////////////////////////////////////////////
// MACROS /////////////////////////////////////////////////////////////////////
// TYPES //////////////////////////////////////////////////////////////////////
// CLASS //////////////////////////////////////////////////////////////////////
// PROTOTYPES /////////////////////////////////////////////////////////////////
// EXTERNALS //////////////////////////////////////////////////////////////////
// GLOBALS ////////////////////////////////////////////////////////////////////
// FUNCTIONS //////////////////////////////////////////////////////////////////

//-----------------------------------------------------------------------------
// Name: __Display()
// Desc: 显示图像
//-----------------------------------------------------------------------------
int CGame::__Display()
	{
	// 清空后备缓冲表面
	DDraw_Fill_Surface(lpddsback,0);

	// 减少全部表面的活性
	CImageManager::SurfaceDeactivateAll();

#ifdef DEBUG
	// 开始计时
	StartTimer(&m_nCpuCount);
#endif // DEBUG

	// 显示世界地图
	if (m_WorldMap.Show(&m_Player.m_locWorld) != 0)
		{
		g_Log.Write("显示世界地图失败\r\n");
		return -1;
		}

#ifdef DEBUG
	// 结束计时
	StopTimer(&m_nCpuCount);
	m_nCpuCountSum += m_nCpuCount;
#endif // DEBUG

#ifdef DEBUG
	///////////////////////////////////////////////////////////
	// 显示调试信息

	char buffer[80];

	// 显示当前中心坐标，已用表面数/可容纳表面数
	sprintf_s(buffer, 80, "(%d, %d) %u/%u",
		m_Player.m_locWorld.x, m_Player.m_locWorld.y,
		CImageManager::SurfaceUsed(), CImageManager::MaxSurface());
	Draw_Text_GDI(buffer, 8, m_piGameWnd->ClientHeight() - 20, RGB(192,192,0), lpddsback);

	// 每秒计算一次时间关系
	// 因为计时过程、结算时机都不会受到暂停的影响，所以最终结果也不会
	// 允许丢帧时，还是等绘制完规定帧数后计算，因此除了恢复后会马上计算时间关系，也没有任何影响

	// 获取当前时间
	LONGLONG nCpuCountCurrent;
	m_Time.GetCurrentCpuCount(&nCpuCountCurrent);

	// 当前时间与上次计算时间相隔了一秒或以上
	if ( nCpuCountCurrent - m_nCpuCountLastCalc >= m_Time.CpuCount1s() )
		{
		m_Time.m_fPercent = (float)m_nCpuCountSum / (nCpuCountCurrent - m_nCpuCountLastCalc);
		m_nCpuCountLastCalc = nCpuCountCurrent;
		m_nCpuCountSum = 0;
		}

	// 显示每秒帧数（显示图像/主模块），一秒内Show()所用时间百分比
	sprintf_s(buffer, 80, "FPS: %.1f/%.1f  Show: %.1f%%",
		m_Time.m_fFpsImage, m_Time.m_fFpsMain, m_Time.m_fPercent *100);
	Draw_Text_GDI(buffer, 8, 8, RGB(192,192,0), lpddsback);
#endif // DEBUG

	///////////////////////////////////////////////////////////

	// 翻转表面
	if (DDraw_Flip(m_piGameWnd->rectClient()) != 1)
		{
		g_Log.Write("翻转表面失败\r\n");
		return -1;
		}

	return 0;
	} // end __Display
