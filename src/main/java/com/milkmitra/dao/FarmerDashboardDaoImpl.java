package com.milkmitra.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

import com.milkmitra.model.FarmerDashboard;
import com.milkmitra.utils.DBConnection;

public class FarmerDashboardDaoImpl implements IFarmerDashboardDao
{
	private Connection cn;
	private PreparedStatement pst1, pst2, pst3, pst4, pst5;
	
	public FarmerDashboardDaoImpl() throws Exception
	{
		cn = DBConnection.openConnection();
		
		//1. Fetching Yearly Data...
		String sql1 = "SELECT\r\n"
				+ "    COUNT(DISTINCT collectionDate) AS totalActiveDaysThisYear,\r\n"
				+ "    IFNULL(SUM(quantity),0) AS totalMilkThisYear,\r\n"
				+ "    IFNULL(SUM(amount),0) AS totalEarningThisYear\r\n"
				+ "FROM milkcollection\r\n"
				+ "WHERE farmerCode = ?\r\n"
				+ "AND collectionDate BETWEEN\r\n"
				+ "    CASE\r\n"
				+ "        WHEN MONTH(CURDATE()) >= 4\r\n"
				+ "        THEN CONCAT(YEAR(CURDATE()), '-04-01')\r\n"
				+ "        ELSE CONCAT(YEAR(CURDATE()) - 1, '-04-01')\r\n"
				+ "    END\r\n"
				+ "AND\r\n"
				+ "    CASE\r\n"
				+ "        WHEN MONTH(CURDATE()) >= 4\r\n"
				+ "        THEN CONCAT(YEAR(CURDATE()) + 1, '-03-31')\r\n"
				+ "        ELSE CONCAT(YEAR(CURDATE()), '-03-31')\r\n"
				+ "    END\r\n"
				+ "AND isActive = 1;";
		pst1 = cn.prepareStatement(sql1);
		
		//3. Fetching Today's Total milk and Earning...
		String sql3 = "SELECT\r\n"
				+ "    IFNULL(SUM(quantity), 0) AS todayMilk,\r\n"
				+ "    IFNULL(SUM(amount), 0) AS todayEarning\r\n"
				+ "FROM milkcollection\r\n"
				+ "WHERE farmerCode = ?\r\n"
				+ "AND collectionDate = CURDATE()\r\n"
				+ "AND isActive = 1;";
		
		pst3 = cn.prepareStatement(sql3);
		
		// 4. Fetching Morning Shift Data (Cow + Buffalo separately)
		String sql4 = "SELECT " +
		    "IFNULL(SUM(CASE WHEN milkType='C' THEN quantity ELSE 0 END),0) AS morningCowQty, " +
		    "IFNULL(MAX(CASE WHEN milkType='C' THEN fat END),0)             AS morningCowFat, " +
		    "IFNULL(MAX(CASE WHEN milkType='C' THEN snf END),0)             AS morningCowSnf, " +
		    "IFNULL(SUM(CASE WHEN milkType='C' THEN amount ELSE 0 END),0)   AS morningCowAmount, " +
		    "IFNULL(SUM(CASE WHEN milkType='B' THEN quantity ELSE 0 END),0) AS morningBufQty, " +
		    "IFNULL(MAX(CASE WHEN milkType='B' THEN fat END),0)             AS morningBufFat, " +
		    "IFNULL(MAX(CASE WHEN milkType='B' THEN snf END),0)             AS morningBufSnf, " +
		    "IFNULL(SUM(CASE WHEN milkType='B' THEN amount ELSE 0 END),0)   AS morningBufAmount " +
		    "FROM milkcollection " +
		    "WHERE farmerCode = ? " +
		    "AND collectionDate = CURDATE() " +
		    "AND shift = 'MORNING' " +
		    "AND isActive = 1";
		pst4 = cn.prepareStatement(sql4);

		// 5. Fetching Evening Shift Data (Cow + Buffalo separately)
		String sql5 = "SELECT " +
		    "IFNULL(SUM(CASE WHEN milkType='C' THEN quantity ELSE 0 END),0) AS eveningCowQty, " +
		    "IFNULL(MAX(CASE WHEN milkType='C' THEN fat END),0)             AS eveningCowFat, " +
		    "IFNULL(MAX(CASE WHEN milkType='C' THEN snf END),0)             AS eveningCowSnf, " +
		    "IFNULL(SUM(CASE WHEN milkType='C' THEN amount ELSE 0 END),0)   AS eveningCowAmount, " +
		    "IFNULL(SUM(CASE WHEN milkType='B' THEN quantity ELSE 0 END),0) AS eveningBufQty, " +
		    "IFNULL(MAX(CASE WHEN milkType='B' THEN fat END),0)             AS eveningBufFat, " +
		    "IFNULL(MAX(CASE WHEN milkType='B' THEN snf END),0)             AS eveningBufSnf, " +
		    "IFNULL(SUM(CASE WHEN milkType='B' THEN amount ELSE 0 END),0)   AS eveningBufAmount " +
		    "FROM milkcollection " +
		    "WHERE farmerCode = ? " +
		    "AND collectionDate = CURDATE() " +
		    "AND shift = 'EVENING' " +
		    "AND isActive = 1";
		pst5 = cn.prepareStatement(sql5);
	}

	@Override
	public FarmerDashboard getFarmerDashboardData(String farmerCode) throws SQLException
	{

	    FarmerDashboard fDashboard = new FarmerDashboard();
	    
	    // Yearly Collection Data
	    pst1.setString(1, farmerCode);

	    try(ResultSet rs = pst1.executeQuery())
	    {
	        if(rs.next())
	        {
	            fDashboard.setTotalActiveDaysThisYear(
	                    rs.getInt("totalActiveDaysThisYear"));

	            fDashboard.setTotalMilkThisYear(
	                    rs.getDouble("totalMilkThisYear"));

	            fDashboard.setTotalEarningThisYear(
	                    rs.getDouble("totalEarningThisYear"));
	        }
	    }

	    // Today's Total Milk & Earnings
	    pst3.setString(1, farmerCode);

	    try(ResultSet rs = pst3.executeQuery()) {

	        if(rs.next()) {

	            fDashboard.setTodayMilk(
	                    rs.getDouble("todayMilk"));

	            fDashboard.setTodayEarning(
	                    rs.getDouble("todayEarning"));
	        }
	    }

	 // Morning shift
	    pst4.setString(1, farmerCode);  // ADD THIS LINE
	    try (ResultSet rs = pst4.executeQuery()) {
	        if (rs.next()) {
	            fDashboard.setMorningCowQty(rs.getDouble("morningCowQty"));
	            fDashboard.setMorningCowFat(rs.getDouble("morningCowFat"));
	            fDashboard.setMorningCowSnf(rs.getDouble("morningCowSnf"));
	            fDashboard.setMorningCowAmount(rs.getDouble("morningCowAmount"));
	            fDashboard.setMorningBufQty(rs.getDouble("morningBufQty"));
	            fDashboard.setMorningBufFat(rs.getDouble("morningBufFat"));
	            fDashboard.setMorningBufSnf(rs.getDouble("morningBufSnf"));
	            fDashboard.setMorningBufAmount(rs.getDouble("morningBufAmount"));
	        }
	    }

	    // Evening shift
	    pst5.setString(1, farmerCode);  // ADD THIS LINE
	    try (ResultSet rs = pst5.executeQuery()) {
	        if (rs.next()) {
	            fDashboard.setEveningCowQty(rs.getDouble("eveningCowQty"));
	            fDashboard.setEveningCowFat(rs.getDouble("eveningCowFat"));
	            fDashboard.setEveningCowSnf(rs.getDouble("eveningCowSnf"));
	            fDashboard.setEveningCowAmount(rs.getDouble("eveningCowAmount"));
	            fDashboard.setEveningBufQty(rs.getDouble("eveningBufQty"));
	            fDashboard.setEveningBufFat(rs.getDouble("eveningBufFat"));
	            fDashboard.setEveningBufSnf(rs.getDouble("eveningBufSnf"));
	            fDashboard.setEveningBufAmount(rs.getDouble("eveningBufAmount"));
	        }
	    }
	    return fDashboard;
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
	    
	    if(pst5 != null)
	    	pst5.close();

	    if(cn != null)
	        cn.close();

	    System.out.println(
	            "Dashboard Dao Cleaned Up!!");
	}

}
