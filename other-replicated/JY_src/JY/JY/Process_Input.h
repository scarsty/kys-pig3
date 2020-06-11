//-----------------------------------------------------------------------------
// Game.cpp - 处理输入
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
// Name: __ProcessInput()
// Desc: 处理输入
//-----------------------------------------------------------------------------
int CGame::__ProcessInput()
	{
	///////////////////////////////////////////////////////////
	// 获取DirectInput数据

	// 如果窗口处于激活状态，获取输入设备数据
	if ( m_piGameWnd->Check(GW_ACTIVATED) )
		{
		// 通常的获取失败会返回空数据，不必退出
		if (DInput_Read_Keyboard() == -1)
			{
			// DIERR_INPUTLOST：失去输入，需要重新获得键盘
			g_Log.Write("Lost keyboard input! That's impossible!\r\n");
			return -1;
			}

		// 通常的获取失败会返回空数据，不必退出
		if (DInput_Read_Mouse() == -1)
			{
			// DIERR_INPUTLOST：失去输入，需要重新获得键盘
			g_Log.Write("Lost mouse input! That's impossible!\r\n");
			return -1;
			}
		}
	// 如果窗口处于未激活状态，则清空输入设备数据
	else
		{
		DInput_Keyboard_Reset_State();
		DInput_Mouse_Reset_State();
		}

	///////////////////////////////////////////////////////////
	// 按下ESC后退出游戏
	// 此时还会执行完本帧，然后才离开主模块

	if (DIKEY(DIK_ESCAPE))
		{
		// 设置游戏状态为正在退出
		SET_BIT(m_nState, GM_CLOSING);
		return 0;
		}

	///////////////////////////////////////////////////////////
	// 确定动作
	// 部分工作最好移到坐标处理中进行

	if (m_nPressLength > 0)
		{
		--m_nPressLength;
		return 0;
		}

	///////////////////////////////////////////
	// 改变屏幕中心地图坐标

	// 获得地图坐标最大值
	const LOC * const locWorldMapMax = m_WorldMap.locMax();
	
	// PageDown
	if (DIKEY(DIK_NEXT))
		{
		if (++m_Player.m_locWorld.x > locWorldMapMax->x)
			m_Player.m_locWorld.x = locWorldMapMax->x;
		}
	// PageUp
	else if (DIKEY(DIK_PRIOR))
		{
		if (--m_Player.m_locWorld.y < 0)
			m_Player.m_locWorld.y = 0;
		}
	// Home
	else if (DIKEY(DIK_HOME))
		{
		if (--m_Player.m_locWorld.x < 0)
			m_Player.m_locWorld.x = 0;
		}
	// End
	else if (DIKEY(DIK_END))
		{
		if (++m_Player.m_locWorld.y > locWorldMapMax->y)
			m_Player.m_locWorld.y = locWorldMapMax->y;
		}
	else
		return 0;

	// 如果还按着Shift，则输入频率为60FPS，否则15FPS（帧率固定为60时）
	if (DIKEY(DIK_LSHIFT) || DIKEY(DIK_RSHIFT))
		m_nPressLength = 0;
	else
		m_nPressLength = 4;

	return 0;
	} // end __ProcessInput
