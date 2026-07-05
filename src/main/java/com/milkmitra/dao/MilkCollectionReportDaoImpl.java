package com.milkmitra.dao;

import java.sql.Connection;
import java.sql.Date;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.time.LocalDate;
import java.util.ArrayList;
import java.util.List;

import com.milkmitra.model.Collection;
import com.milkmitra.model.Report;
import com.milkmitra.utils.DBConnection;

public class MilkCollectionReportDaoImpl implements IMilkCollectionReportDao
{
	private static final String SQL_TODAY =
			"select * from milkcollection " +
			"where collectionDate = curdate() " +
			"and isActive = 1 " +
			"order by shift, farmerCode";

	private static final String SQL_BY_SHIFT =
			"select * from milkcollection where collectionDate = curdate() and shift = ? and isActive = 1 order by farmerCode";

	private static final String SQL_DATEWISE =
			"select mc.farmerCode,\r\n"
			+ "       f.farmer_name,\r\n"
			+ "       sum(mc.quantity) totalQty,\r\n"
			+ "       sum(mc.amount) totalAmount\r\n"
			+ "from milkcollection mc\r\n"
			+ "join farmers f\r\n"
			+ "on mc.farmerCode = f.farmer_code\r\n"
			+ "where mc.collectionDate between ? and ?\r\n"
			+ "group by mc.farmerCode,f.farmer_name\r\n"
			+ "order by mc.farmerCode";

	private static final String SQL_FARMER_COLLECTIONS =
			"select * from milkcollection where farmerCode = ? and collectionDate between ? and ? order by collectionDate desc";

	public MilkCollectionReportDaoImpl() {
		// Nothing held here now — each method below borrows its own
		// connection from the pool for just the duration of that call.
	}

	@Override
	public List<Collection> getTodayCollections() throws SQLException {
		List<Collection> collections = new ArrayList<>();

		try (Connection cn = DBConnection.getConnection();
			 PreparedStatement pst1 = cn.prepareStatement(SQL_TODAY);
			 ResultSet rs = pst1.executeQuery())
		{
			while(rs.next())
			{
				Collection c = new Collection();
				c.setCollectionId(rs.getInt("collectionId"));
				c.setFarmerCode(rs.getString("farmerCode"));
				c.setCollectionDate(rs.getDate("collectionDate").toLocalDate());
				c.setShift(rs.getString("shift"));
				c.setMilkType(rs.getString("milkType"));
				c.setQuantity(rs.getDouble("quantity"));
				c.setFat(rs.getDouble("fat"));
				c.setSnf(rs.getDouble("snf"));
				c.setRatePerLtr(rs.getDouble("ratePerLtr"));
				c.setAmount(rs.getDouble("amount"));
				c.setCreatedAt(rs.getTimestamp("createdAt"));
				collections.add(c);
			}
		}

		return collections;
	}

	@Override
	public List<Collection> getCollectionsByShift(String shift) throws SQLException {
		List<Collection> collections = new ArrayList<>();

		try (Connection cn = DBConnection.getConnection();
			 PreparedStatement pst2 = cn.prepareStatement(SQL_BY_SHIFT)) {

			pst2.setString(1, shift);

			try (ResultSet rs = pst2.executeQuery())
			{
				while(rs.next())
				{
					System.out.println(
					        rs.getString("farmerCode") + " | " +
					        rs.getString("shift") + " | " +
					        rs.getString("milkType") + " | " +
					        rs.getDouble("fat") + " | " +
					        rs.getDouble("snf") + " | " +
					        rs.getDouble("ratePerLtr")
					    );

					Collection c = new Collection();

					c.setCollectionId(rs.getInt("collectionId"));
					c.setFarmerCode(rs.getString("farmerCode"));
					c.setCollectionDate(rs.getDate("collectionDate").toLocalDate());
					c.setShift(rs.getString("shift"));
					c.setMilkType(rs.getString("milkType"));
					c.setQuantity(rs.getDouble("quantity"));
					c.setFat(rs.getDouble("fat"));
					c.setSnf(rs.getDouble("snf"));
					c.setAmount(rs.getDouble("amount"));
					c.setRatePerLtr(rs.getDouble("ratePerLtr"));
					c.setCreatedAt(rs.getTimestamp("createdAt"));

					collections.add(c);
				}
			}
		}
		return collections;
	}

	@Override
	public List<Report> getDateWiseCollectionReport(LocalDate fromDate, LocalDate toDate) throws SQLException
	{
		List<Report> reports = new ArrayList<>();

		try (Connection cn = DBConnection.getConnection();
			 PreparedStatement pst3 = cn.prepareStatement(SQL_DATEWISE)) {

			pst3.setDate(1, Date.valueOf(fromDate));
			pst3.setDate(2, Date.valueOf(toDate));

			try (ResultSet rs = pst3.executeQuery())
			{
				while(rs.next())
				{
					Report report = new Report();
					report.setFarmerCode(rs.getString("farmerCode"));
					report.setFarmerName(rs.getString("farmer_name"));
					report.setTotalQty(rs.getDouble("totalQty"));
					report.setTotalAmount(rs.getDouble("totalAmount"));
					reports.add(report);
				}
			}
		}

		return reports;
	}

	@Override
	public List<Collection> getFarmerCollections(String farmerCode, LocalDate fromDate, LocalDate toDate) throws SQLException
	{
		List<Collection> collections = new ArrayList<>();

		try (Connection cn = DBConnection.getConnection();
			 PreparedStatement pst4 = cn.prepareStatement(SQL_FARMER_COLLECTIONS)) {

			pst4.setString(1, farmerCode);
			pst4.setDate(2, Date.valueOf(fromDate));
			pst4.setDate(3, Date.valueOf(toDate));

			try (ResultSet rs = pst4.executeQuery())
			{
				while(rs.next())
				{
					Collection c = new Collection();
					c.setCollectionId(rs.getInt("collectionId"));
					c.setFarmerCode(rs.getString("farmerCode"));
					c.setCollectionDate(rs.getDate("collectionDate").toLocalDate());
					c.setShift(rs.getString("shift"));
					c.setMilkType(rs.getString("milkType"));
					c.setQuantity(rs.getDouble("quantity"));
					c.setFat(rs.getDouble("fat"));
					c.setSnf(rs.getDouble("snf"));
					c.setAmount(rs.getDouble("amount"));
					c.setRatePerLtr(rs.getDouble("ratePerLtr"));
					c.setCreatedAt(rs.getTimestamp("createdAt"));
					collections.add(c);
				}
			}
		}

		return collections;
	}

	public void cleanUp() {
		// No-op now: try-with-resources closes everything immediately
		// after each method call. Kept so existing servlet calls don't break.
	}

}