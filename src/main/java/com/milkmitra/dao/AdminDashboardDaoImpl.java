package com.milkmitra.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

import com.milkmitra.model.Dashboard;
import com.milkmitra.utils.DBConnection;

public class AdminDashboardDaoImpl implements IAdminDashboardDao
{
	private Connection cn;
	private PreparedStatement pst1, pst2, pst3, pst4;
	
	public AdminDashboardDaoImpl() throws ClassNotFoundException, Exception
	{
		cn = DBConnection.openConnection();
		
		//1.Today's collection summary 
		String sql1 = "select\r\n"
				+ "    count(*) todayEntries,\r\n"
				+ "    sum(quantity) totalLtr,\r\n"
				+ "    sum(amount) totalValue,\r\n"
				+ "    avg(fat) avgFat,\r\n"
				+ "    avg(snf) avgSnf\r\n"
				+ "from milkcollection\r\n"
				+ "where collectionDate = curdate()\r\n"
				+ "and isActive = 1;";
		pst1 = cn.prepareStatement(sql1);
		
		//2.Morning / Evening count
		String sql2 = "select\r\n"
				+ "    shift,\r\n"
				+ "    count(*) entries\r\n"
				+ "from milkcollection\r\n"
				+ "where collectionDate = curdate()\r\n"
				+ "and isActive = 1\r\n"
				+ "group by shift;";
		pst2 = cn.prepareStatement(sql2);
		
		//3. Cow / Buffalo litres
		String sql3 = "select\r\n"
				+ "    milkType,\r\n"
				+ "    sum(quantity) qty\r\n"
				+ "from milkcollection\r\n"
				+ "where collectionDate = curdate()\r\n"
				+ "and isActive = 1\r\n"
				+ "group by milkType;";
		pst3 = cn.prepareStatement(sql3);
		
		//4. Farmer overview
		String sql4 = "select\r\n"
				+ "    count(*) totalFarmers,\r\n"
				+ "    sum(case when is_active = 1 then 1 else 0 end) activeFarmers,\r\n"
				+ "    sum(case when is_active = 0 then 1 else 0 end) inactiveFarmers\r\n"
				+ "from farmers;";
		pst4 = cn.prepareStatement(sql4);
				
				
		
	}

	@Override
	public Dashboard getDashboardData() throws SQLException
	{
	    Dashboard dashboard = new Dashboard();

	    // Today's Summary
	    try(ResultSet rs = pst1.executeQuery())
	    {
	        if(rs.next())
	        {
	            dashboard.setTodayEntries(
	                    rs.getInt("todayEntries"));

	            dashboard.setTodayTotalLtr(
	                    rs.getDouble("totalLtr"));

	            dashboard.setTodayValue(
	                    rs.getDouble("totalValue"));

	            dashboard.setAvgFat(
	                    rs.getDouble("avgFat"));

	            dashboard.setAvgSnf(
	                    rs.getDouble("avgSnf"));
	        }
	    }

	    // Morning / Evening Entries
	    try(ResultSet rs = pst2.executeQuery())
	    {
	        while(rs.next())
	        {
	            String shift = rs.getString("shift");

	            if("Morning".equalsIgnoreCase(shift))
	            {
	                dashboard.setMorningEntries(
	                        rs.getInt("entries"));
	            }
	            else if("Evening".equalsIgnoreCase(shift))
	            {
	                dashboard.setEveningEntries(
	                        rs.getInt("entries"));
	            }
	        }
	    }

	    // Cow / Buffalo Milk
	    try(ResultSet rs = pst3.executeQuery())
	    {
	        while(rs.next())
	        {
	            String milkType =
	                    rs.getString("milkType");

	            if("c".equalsIgnoreCase(milkType))
	            {
	                dashboard.setTodayCowLtr(
	                        rs.getDouble("qty"));
	            }
	            else if("B".equalsIgnoreCase(milkType))
	            {
	                dashboard.setTodayBufLtr(
	                        rs.getDouble("qty"));
	            }
	        }
	    }

	    // Farmer Overview
	    try(ResultSet rs = pst4.executeQuery())
	    {
	        if(rs.next())
	        {
	            dashboard.setTotalFarmers(
	                    rs.getInt("totalFarmers"));

	            dashboard.setActiveFarmers(
	                    rs.getInt("activeFarmers"));

	            dashboard.setInactiveFarmers(
	                    rs.getInt("inactiveFarmers"));
	        }
	    }

	    return dashboard;
	}
	
	public void cleanUp() throws SQLException
	{
	    if(pst1 != null)
	        pst1.close();

	    if(pst2 != null)
	        pst2.close();

	    if(pst3 != null)
	        pst3.close();

	    if(pst4 != null)
	        pst4.close();

	    if(cn != null)
	        cn.close();

	    System.out.println(
	            "Dashboard Dao Cleaned Up!!");
	}

}
