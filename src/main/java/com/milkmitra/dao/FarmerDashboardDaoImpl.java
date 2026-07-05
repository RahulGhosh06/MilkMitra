package com.milkmitra.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

import com.milkmitra.model.Farmer;
import com.milkmitra.model.FarmerDashboard;
import com.milkmitra.utils.DBConnection;

public class FarmerDashboardDaoImpl implements IFarmerDashboardDao
{
	private static final String SQL_YEARLY =
			"SELECT\r\n"
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

	private static final String SQL_TODAY_TOTALS =
			"SELECT\r\n"
			+ "    IFNULL(SUM(quantity), 0) AS todayMilk,\r\n"
			+ "    IFNULL(SUM(amount), 0) AS todayEarning\r\n"
			+ "FROM milkcollection\r\n"
			+ "WHERE farmerCode = ?\r\n"
			+ "AND collectionDate = ? \r\n"
			+ "AND isActive = 1;";

	private static final String SQL_MORNING =
			"SELECT " +
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
			"AND collectionDate = ? " +
			"AND shift = 'MORNING' " +
			"AND isActive = 1";

	private static final String SQL_EVENING =
			"SELECT " +
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
			"AND collectionDate = ? " +
			"AND shift = 'EVENING' " +
			"AND isActive = 1";

	private static final String SQL_FARMER_PROFILE =
			"select farmer_name, mobile, farmer_code, address, joining_date, bank_name, bank_account_no, ifsc_code, mpp_code, is_active from farmers where farmer_code = ?";

	public FarmerDashboardDaoImpl() {
		// Nothing held here now — each method below borrows its own
		// connection from the pool for just the duration of that call.
	}

	@Override
	public FarmerDashboard getFarmerDashboardData(String farmerCode) throws SQLException
	{
		java.time.LocalDate today = java.time.LocalDate.now(
				java.time.ZoneId.of("Asia/Kolkata"));
		java.sql.Date sqlToday = java.sql.Date.valueOf(today);

	    FarmerDashboard fDashboard = new FarmerDashboard();

	    try (Connection cn = DBConnection.getConnection()) {

	        // Yearly Collection Data
	        try (PreparedStatement pst1 = cn.prepareStatement(SQL_YEARLY)) {
	            pst1.setString(1, farmerCode);

	            try (ResultSet rs = pst1.executeQuery()) {
	                if (rs.next()) {
	                    fDashboard.setTotalActiveDaysThisYear(rs.getInt("totalActiveDaysThisYear"));
	                    fDashboard.setTotalMilkThisYear(rs.getDouble("totalMilkThisYear"));
	                    fDashboard.setTotalEarningThisYear(rs.getDouble("totalEarningThisYear"));
	                }
	            }
	        }

	        // Today's Total Milk & Earnings
	        try (PreparedStatement pst3 = cn.prepareStatement(SQL_TODAY_TOTALS)) {
	            pst3.setString(1, farmerCode);
	            pst3.setDate(2, sqlToday);

	            try (ResultSet rs = pst3.executeQuery()) {
	                if (rs.next()) {
	                    fDashboard.setTodayMilk(rs.getDouble("todayMilk"));
	                    fDashboard.setTodayEarning(rs.getDouble("todayEarning"));
	                }
	            }
	        }

	        // Morning shift
	        try (PreparedStatement pst4 = cn.prepareStatement(SQL_MORNING)) {
	            pst4.setString(1, farmerCode);
	            pst4.setDate(2, sqlToday);

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
	        }

	        // Evening shift
	        try (PreparedStatement pst5 = cn.prepareStatement(SQL_EVENING)) {
	            pst5.setString(1, farmerCode);
	            pst5.setDate(2, sqlToday);

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
	        }
	    }

	    return fDashboard;
	}

	@Override
	public Farmer getFarmerProfile(String farmerCode) throws SQLException {

		Farmer farmer = new Farmer();

		try (Connection cn = DBConnection.getConnection();
			 PreparedStatement pst6 = cn.prepareStatement(SQL_FARMER_PROFILE)) {

			pst6.setString(1, farmerCode);

			try (ResultSet rs = pst6.executeQuery()) {
				if (rs.next()) {
					farmer.setFarmerName(rs.getString("farmer_name"));
					farmer.setMobile(rs.getString("mobile"));
					farmer.setFarmerCode(rs.getString("farmer_code"));
					farmer.setAddress(rs.getString("address"));
					farmer.setJoiningDate(rs.getDate("joining_date").toLocalDate());
					farmer.setBankName(rs.getString("bank_name"));
					farmer.setAccountNo(rs.getString("bank_account_no"));
					farmer.setIfscCode(rs.getString("ifsc_code"));
					farmer.setMppCode(rs.getString("mpp_code"));
					farmer.setActive(rs.getBoolean("is_active"));
				}
			}
		}
		return farmer;
	}

	public void cleanUp() {
		// No-op now: try-with-resources closes everything immediately
		// after each method call. Kept so existing servlet calls don't break.
	}

}