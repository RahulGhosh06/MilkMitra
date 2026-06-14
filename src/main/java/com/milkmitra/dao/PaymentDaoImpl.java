package com.milkmitra.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.List;

import com.milkmitra.model.PaymentSummary;
import com.milkmitra.utils.DBConnection;
import com.milkmitra.utils.PaymentCycleUtil;

public class PaymentDaoImpl implements IPaymentDao {
	private Connection cn;
	private PreparedStatement pst1, pst2, pst3;

	public PaymentDaoImpl() throws Exception {
		cn = DBConnection.openConnection();

		// 1. For Admin
		String sql1 = "SELECT\r\n" + "COUNT(DISTINCT farmerCode) AS totalFarmers,\r\n"
				+ "IFNULL(SUM(quantity),0) AS totalMilk,\r\n" + "IFNULL(SUM(amount),0) AS totalAmount\r\n"
				+ "FROM milkcollection\r\n" + "WHERE collectionDate BETWEEN ? AND ?\r\n" + "AND isActive = 1";
		pst1 = cn.prepareStatement(sql1);

		// 2. For Farmer
		String sql2 = "SELECT " + "IFNULL(SUM(quantity),0) AS totalMilk, " + "IFNULL(SUM(amount),0) AS totalAmount "
				+ "FROM milkcollection " + "WHERE farmerCode = ? " + "AND collectionDate BETWEEN ? AND ? "
				+ "AND isActive = 1";

		pst2 = cn.prepareStatement(sql2);
		
		//3. Payment Cycle History
		String sql3 =
				"SELECT collectionDate, quantity, amount " +
				"FROM milkcollection " +
				"WHERE farmerCode=? " +
				"AND isActive=1 " +
				"ORDER BY collectionDate DESC";

				pst3 = cn.prepareStatement(sql3); //..... to be continued
	}

	@Override
	public PaymentSummary getCurrentCycleSummary() throws SQLException {

		PaymentSummary summary = PaymentCycleUtil.getCurrentCycle();

		pst1.setDate(1, java.sql.Date.valueOf(summary.getCycleStart()));

		pst1.setDate(2, java.sql.Date.valueOf(summary.getCycleEnd()));

		try (ResultSet rs = pst1.executeQuery()) {

			if (rs.next()) {

				summary.setTotalFarmers(rs.getInt("totalFarmers"));

				summary.setTotalMilk(rs.getDouble("totalMilk"));

				summary.setTotalAmount(rs.getDouble("totalAmount"));
			}
		}
		
		System.out.println(
		        "Current Cycle : "
		        + summary.getCycleStart()
		        + " -> "
		        + summary.getCycleEnd());

		System.out.println(
		        "Farmers : "
		        + summary.getTotalFarmers());

		System.out.println(
		        "Milk : "
		        + summary.getTotalMilk());

		System.out.println(
		        "Amount : "
		        + summary.getTotalAmount());

		return summary;
	}

	@Override
	public PaymentSummary getCurrentCycleSummary(String farmerCode) throws SQLException {

		PaymentSummary summary = PaymentCycleUtil.getCurrentCycle();

		pst2.setString(1, farmerCode);

		pst2.setDate(2, java.sql.Date.valueOf(summary.getCycleStart()));

		pst2.setDate(3, java.sql.Date.valueOf(summary.getCycleEnd()));

		try (ResultSet rs = pst2.executeQuery()) {

			if (rs.next()) {

				summary.setTotalMilk(rs.getDouble("totalMilk"));

				summary.setTotalAmount(rs.getDouble("totalAmount"));
			}
		}

		return summary;
	}

	@Override
	public List<PaymentSummary> getPaymentHistory(String farmerCode) throws SQLException {
		// TODO Auto-generated method stub
		return null;
	}
	
	public void cleanUp() throws SQLException {
		if (pst1 != null)
			pst1.close();
		if (pst2 != null)
			pst2.close();

		if (cn != null)
			cn.close();
	}

}
