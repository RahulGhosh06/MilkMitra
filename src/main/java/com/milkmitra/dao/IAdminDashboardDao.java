package com.milkmitra.dao;

import java.sql.SQLException;
import com.milkmitra.model.Dashboard;

public interface IAdminDashboardDao
{
	//1. Feature for Admin Dashboard cards
    Dashboard getDashboardData() throws SQLException;
}