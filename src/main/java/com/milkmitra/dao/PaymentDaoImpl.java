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

	private static final String SQL_ADMIN_CYCLE_SUMMARY =
			"SELECT\r\n" + "COUNT(DISTINCT farmerCode) AS totalFarmers,\r\n"
			+ "IFNULL(SUM(quantity),0) AS totalMilk,\r\n" + "IFNULL(SUM(amount),0) AS totalAmount\r\n"
			+ "FROM milkcollection\r\n" + "WHERE collectionDate BETWEEN ? AND ?\r\n" + "AND isActive = 1";

	private static final String SQL_FARMER_CYCLE_SUMMARY =
			"SELECT " + "IFNULL(SUM(quantity),0) AS totalMilk, " + "IFNULL(SUM(amount),0) AS totalAmount "
			+ "FROM milkcollection " + "WHERE farmerCode = ? " + "AND collectionDate BETWEEN ? AND ? "
			+ "AND isActive = 1";

	private static final String SQL_PAYMENT_HISTORY =
			"SELECT collectionDate, quantity, amount " + "FROM milkcollection " + "WHERE farmerCode=? "
			+ "AND isActive=1 " + "ORDER BY collectionDate DESC";

	private static final String SQL_CYCLE_ENTRIES =
			"SELECT collectionDate, shift, milkType, quantity, fat, snf, ratePerLtr, amount "
			+ "FROM milkcollection " + "WHERE farmerCode = ? AND isActive = 1 "
			+ "AND collectionDate BETWEEN ? AND ? " + "ORDER BY collectionDate ASC, shift ASC";

	public PaymentDaoImpl() {
		// Nothing held here now — each method below borrows its own
		// connection from the pool for just the duration of that call.
	}

	@Override
	public PaymentSummary getCurrentCycleSummary() throws SQLException {

		PaymentSummary summary = PaymentCycleUtil.getCurrentCycle();

		try (Connection cn = DBConnection.getConnection();
			 PreparedStatement pst1 = cn.prepareStatement(SQL_ADMIN_CYCLE_SUMMARY)) {

			pst1.setDate(1, java.sql.Date.valueOf(summary.getCycleStart()));
			pst1.setDate(2, java.sql.Date.valueOf(summary.getCycleEnd()));

			try (ResultSet rs = pst1.executeQuery()) {
				if (rs.next()) {
					summary.setTotalFarmers(rs.getInt("totalFarmers"));
					summary.setTotalMilk(rs.getDouble("totalMilk"));
					summary.setTotalAmount(rs.getDouble("totalAmount"));
				}
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

		try (Connection cn = DBConnection.getConnection();
			 PreparedStatement pst2 = cn.prepareStatement(SQL_FARMER_CYCLE_SUMMARY)) {

			pst2.setString(1, farmerCode);
			pst2.setDate(2, java.sql.Date.valueOf(summary.getCycleStart()));
			pst2.setDate(3, java.sql.Date.valueOf(summary.getCycleEnd()));

			try (ResultSet rs = pst2.executeQuery()) {
				if (rs.next()) {
					summary.setTotalMilk(rs.getDouble("totalMilk"));
					summary.setTotalAmount(rs.getDouble("totalAmount"));
				}
			}
		}

		return summary;
	}

	@Override
	public List<PaymentSummary> getPaymentHistory(String farmerCode) throws SQLException {

		List<PaymentSummary> paymentList = new ArrayList<>();
		Map<String, PaymentSummary> cycleMap = new LinkedHashMap<>();

		try (Connection cn = DBConnection.getConnection();
			 PreparedStatement pst3 = cn.prepareStatement(SQL_PAYMENT_HISTORY)) {

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
		}

		paymentList.addAll(cycleMap.values());

		return paymentList;
	}

	@Override
	public List<PaymentSummary> getCycleEntries(String farmerCode, LocalDate cycleStart, LocalDate cycleEnd) throws SQLException {

		List<PaymentSummary> list = new ArrayList<>();

		try (Connection cn = DBConnection.getConnection();
			 PreparedStatement pst4 = cn.prepareStatement(SQL_CYCLE_ENTRIES)) {

			pst4.setString(1, farmerCode);
			pst4.setDate(2, java.sql.Date.valueOf(cycleStart));
			pst4.setDate(3, java.sql.Date.valueOf(cycleEnd));

			try (ResultSet rs = pst4.executeQuery()) {
				while (rs.next()) {
					PaymentSummary e = new PaymentSummary();
					e.setCollectionDate(rs.getDate("collectionDate").toLocalDate());
					e.setShift(rs.getString("shift"));
					e.setMilkType(rs.getString("milkType"));
					e.setTotalMilk(rs.getDouble("quantity"));
					e.setFat(rs.getDouble("fat"));
					e.setSnf(rs.getDouble("snf"));
					e.setRatePerLtr(rs.getDouble("ratePerLtr"));
					e.setTotalAmount(rs.getDouble("amount"));
					list.add(e);
				}
			}
		}

		return list;
	}

	public void cleanUp() {
		// No-op now: try-with-resources closes everything immediately
		// after each method call. Kept so existing servlet calls don't break.
	}

}