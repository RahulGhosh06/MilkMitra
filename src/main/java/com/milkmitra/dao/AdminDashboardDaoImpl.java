package com.milkmitra.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

import com.milkmitra.model.Dashboard;
import com.milkmitra.utils.DBConnection;

public class AdminDashboardDaoImpl implements IAdminDashboardDao
{
	private static final String SQL_TODAY_SUMMARY =
			"select\r\n"
			+ "    count(*) todayEntries,\r\n"
			+ "    sum(quantity) totalLtr,\r\n"
			+ "    sum(amount) totalValue,\r\n"
			+ "    avg(fat) avgFat,\r\n"
			+ "    avg(snf) avgSnf\r\n"
			+ "from milkcollection\r\n"
			+ "where collectionDate = ?\r\n"
			+ "and isActive = 1;";

	private static final String SQL_SHIFT_COUNT =
			"select\r\n"
			+ "    shift,\r\n"
			+ "    count(*) entries\r\n"
			+ "from milkcollection\r\n"
			+ "where collectionDate = ?\r\n"
			+ "and isActive = 1\r\n"
			+ "group by shift;";

	private static final String SQL_MILKTYPE_QTY =
			"select\r\n"
			+ "    milkType,\r\n"
			+ "    sum(quantity) qty\r\n"
			+ "from milkcollection\r\n"
			+ "where collectionDate = ?\r\n"
			+ "and isActive = 1\r\n"
			+ "group by milkType;";

	private static final String SQL_FARMER_OVERVIEW =
			"select\r\n"
			+ "    count(*) totalFarmers,\r\n"
			+ "    sum(case when is_active = 1 then 1 else 0 end) activeFarmers,\r\n"
			+ "    sum(case when is_active = 0 then 1 else 0 end) inactiveFarmers\r\n"
			+ "from farmers;";

	public AdminDashboardDaoImpl() {
		// Nothing held here now — getDashboardData() below borrows a
		// single connection from the pool for the duration of that call.
	}

	@Override
	public Dashboard getDashboardData() throws SQLException
	{
	    Dashboard dashboard = new Dashboard();

	    // Use the app's IST calendar date, NOT the DB server's own clock
	    // (curdate() relies on the MySQL server's timezone, which is UTC
	    // on Railway — that caused "today" to be wrong for ~5.5 hours
	    // around midnight IST).
	    java.sql.Date todayIst = java.sql.Date.valueOf(
	            java.time.LocalDate.now(java.time.ZoneId.of("Asia/Kolkata")));

	    try (Connection cn = DBConnection.getConnection()) {

	        // Today's Summary
	        try (PreparedStatement pst1 = cn.prepareStatement(SQL_TODAY_SUMMARY)) {
	            pst1.setDate(1, todayIst);

	            try (ResultSet rs = pst1.executeQuery()) {
	                if(rs.next())
	                {
	                    dashboard.setTodayEntries(rs.getInt("todayEntries"));
	                    dashboard.setTodayTotalLtr(rs.getDouble("totalLtr"));
	                    dashboard.setTodayValue(rs.getDouble("totalValue"));
	                    dashboard.setAvgFat(rs.getDouble("avgFat"));
	                    dashboard.setAvgSnf(rs.getDouble("avgSnf"));
	                }
	            }
	        }

	        // Morning / Evening Entries
	        try (PreparedStatement pst2 = cn.prepareStatement(SQL_SHIFT_COUNT)) {
	            pst2.setDate(1, todayIst);

	            try (ResultSet rs = pst2.executeQuery()) {
	                while(rs.next())
	                {
	                    String shift = rs.getString("shift");

	                    if("Morning".equalsIgnoreCase(shift))
	                    {
	                        dashboard.setMorningEntries(rs.getInt("entries"));
	                    }
	                    else if("Evening".equalsIgnoreCase(shift))
	                    {
	                        dashboard.setEveningEntries(rs.getInt("entries"));
	                    }
	                }
	            }
	        }

	        // Cow / Buffalo Milk
	        try (PreparedStatement pst3 = cn.prepareStatement(SQL_MILKTYPE_QTY)) {
	            pst3.setDate(1, todayIst);

	            try (ResultSet rs = pst3.executeQuery()) {
	                while(rs.next())
	                {
	                    String milkType = rs.getString("milkType");

	                    if("c".equalsIgnoreCase(milkType))
	                    {
	                        dashboard.setTodayCowLtr(rs.getDouble("qty"));
	                    }
	                    else if("B".equalsIgnoreCase(milkType))
	                    {
	                        dashboard.setTodayBufLtr(rs.getDouble("qty"));
	                    }
	                }
	            }
	        }

	        // Farmer Overview
	        try (PreparedStatement pst4 = cn.prepareStatement(SQL_FARMER_OVERVIEW);
	             ResultSet rs = pst4.executeQuery())
	        {
	            if(rs.next())
	            {
	                dashboard.setTotalFarmers(rs.getInt("totalFarmers"));
	                dashboard.setActiveFarmers(rs.getInt("activeFarmers"));
	                dashboard.setInactiveFarmers(rs.getInt("inactiveFarmers"));
	            }
	        }
	    }

	    return dashboard;
	}

	public void cleanUp() {
		// No-op: try-with-resources closes everything immediately after
		// getDashboardData() finishes.
	}

}