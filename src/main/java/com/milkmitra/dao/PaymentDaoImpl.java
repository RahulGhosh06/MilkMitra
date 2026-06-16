package com.milkmitra.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.time.LocalDate;
import java.util.ArrayList;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;

import com.milkmitra.model.PaymentSummary;
import com.milkmitra.utils.DBConnection;
import com.milkmitra.utils.PaymentCycleUtil;

public class PaymentDaoImpl implements IPaymentDao {
	private Connection cn;
	private PreparedStatement pst1, pst2, pst3, pst4;

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

		// 3. Payment Cycle History
		String sql3 = "SELECT collectionDate, quantity, amount " + "FROM milkcollection " + "WHERE farmerCode=? "
				+ "AND isActive=1 " + "ORDER BY collectionDate DESC";

		pst3 = cn.prepareStatement(sql3); // ..... to be continued

		// 4. Payment Cycle smart cards view
		String sql4 = "SELECT collectionDate, shift, cattleType, quantity, fat, snf, rate, amount "
				+ "FROM milkcollection " + "WHERE farmerCode = ? AND isActive = 1 "
				+ "AND collectionDate BETWEEN ? AND ? " + "ORDER BY collectionDate ASC, shift ASC";
		pst4 = cn.prepareStatement(sql4);
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

		System.out.println("Current Cycle : " + summary.getCycleStart() + " -> " + summary.getCycleEnd());

		System.out.println("Farmers : " + summary.getTotalFarmers());

		System.out.println("Milk : " + summary.getTotalMilk());

		System.out.println("Amount : " + summary.getTotalAmount());

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

		List<PaymentSummary> paymentList = new ArrayList<>();

		Map<String, PaymentSummary> cycleMap = new LinkedHashMap<>();

		pst3.setString(1, farmerCode);

		try (ResultSet rs = pst3.executeQuery()) {

			while (rs.next()) {

				LocalDate collectionDate = rs.getDate("collectionDate").toLocalDate();

				LocalDate cycleStart;
				LocalDate cycleEnd;

				int day = collectionDate.getDayOfMonth();

				if (day >= 1 && day <= 10) {

					cycleStart = collectionDate.withDayOfMonth(1);

					cycleEnd = collectionDate.withDayOfMonth(10);
				} else if (day >= 11 && day <= 20) {

					cycleStart = collectionDate.withDayOfMonth(11);

					cycleEnd = collectionDate.withDayOfMonth(20);
				} else {

					cycleStart = collectionDate.withDayOfMonth(21);

					cycleEnd = collectionDate.withDayOfMonth(collectionDate.lengthOfMonth());
				}

				String key = cycleStart + "_" + cycleEnd;

				if (!cycleMap.containsKey(key)) {

					PaymentSummary summary = new PaymentSummary();

					summary.setCycleStart(cycleStart);

					summary.setCycleEnd(cycleEnd);

					cycleMap.put(key, summary);
				}

				PaymentSummary summary = cycleMap.get(key);

				summary.setTotalMilk(summary.getTotalMilk() + rs.getDouble("quantity"));

				summary.setTotalAmount(summary.getTotalAmount() + rs.getDouble("amount"));
			}
		}

		paymentList.addAll(cycleMap.values());

		return paymentList;
	}

	@Override
	public List<PaymentSummary> getCycleEntries(String farmerCode, LocalDate cycleStart, LocalDate cycleEnd) throws SQLException {
	    List<PaymentSummary> list = new ArrayList<>();
	    pst4.setString(1, farmerCode);
	    pst4.setDate(2, java.sql.Date.valueOf(cycleStart));
	    pst4.setDate(3, java.sql.Date.valueOf(cycleEnd));
	    try (ResultSet rs = pst4.executeQuery()) {
	        while (rs.next()) {
	            PaymentSummary e = new PaymentSummary();
	            e.setCollectionDate(rs.getDate("collectionDate").toLocalDate());
	            e.setShift(rs.getString("shift"));
	            e.setCattleType(rs.getString("cattleType"));
	            e.setTotalMilk(rs.getDouble("quantity"));
	            e.setFat(rs.getDouble("fat"));
	            e.setSnf(rs.getDouble("snf"));
	            e.setRate(rs.getDouble("rate"));
	            e.setTotalAmount(rs.getDouble("amount"));
	            list.add(e);
	        }
	    }
	    return list;
	}
	
	public void cleanUp() throws SQLException {
		if (pst1 != null)
			pst1.close();
		if (pst2 != null)
			pst2.close();
		if (pst3 != null)
			pst3.close();
		if(pst4 != null)
			pst4.close();

		if (cn != null)
			cn.close();
	}

}
