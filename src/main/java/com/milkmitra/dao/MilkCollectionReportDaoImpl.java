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

public class milkcollectionReportDaoImpl implements ImilkcollectionReportDao
{
	private Connection cn;
	private PreparedStatement pst1, pst2, pst3, pst4;
	
	public milkcollectionReportDaoImpl() throws ClassNotFoundException, Exception
	{
		cn = DBConnection.openConnection();
		
		//farmerCode, farmerName, totalQty, totalAmount..
		
		//1. Today's Collection Report
		String sql1 =
				"select * from milkcollection " +
				"where collectionDate = curdate() " +
				"and isActive = 1 " +
				"order by shift, farmerCode";

		pst1 = cn.prepareStatement(sql1);
		
		//2. ShiftWise Collection Report
		String sql2 = "select * from milkcollection where collectionDate = curdate() and shift = ? and isActive = 1 order by farmerCode" ;
		pst2 = cn.prepareStatement(sql2);
		
		
		//3. Datewise Collection Report
		String sql3 = "select mc.farmerCode,\r\n"
				+ "       f.farmer_name,\r\n"
				+ "       sum(mc.quantity) totalQty,\r\n"
				+ "       sum(mc.amount) totalAmount\r\n"
				+ "from milkcollection mc\r\n"
				+ "join farmers f\r\n"
				+ "on mc.farmerCode = f.farmer_code\r\n"
				+ "where mc.collectionDate between ? and ?\r\n"
				+ "group by mc.farmerCode,f.farmer_name\r\n"
				+ "order by mc.farmerCode" ;
		pst3 = cn.prepareStatement(sql3);
		
		String sql4 = "select * from milkcollection where farmerCode = ? and collectionDate between ? and ? order by collectionDate desc";
		pst4 = cn.prepareStatement(sql4);
				
		
	}
	
	@Override
	public List<Collection> getTodayCollections() throws SQLException {
		List<Collection> collections = new ArrayList<>();

	    try(ResultSet rs = pst1.executeQuery())
	    {
	        while(rs.next())
	        {
	        	Collection c = new Collection();

	        	c.setCollectionId(
	        	        rs.getInt("collectionId"));

	        	c.setFarmerCode(
	        	        rs.getString("farmerCode"));

	        	c.setCollectionDate(
	        	        rs.getDate("collectionDate").toLocalDate());

	        	c.setShift(
	        	        rs.getString("shift"));

	        	c.setMilkType(
	        	        rs.getString("milkType"));

	        	c.setQuantity(
	        	        rs.getDouble("quantity"));

	        	c.setFat(
	        	        rs.getDouble("fat"));

	        	c.setSnf(
	        	        rs.getDouble("snf"));

	        	c.setRatePerLtr(
	        	        rs.getDouble("ratePerLtr"));

	        	c.setAmount(
	        	        rs.getDouble("amount"));

	        	c.setCreatedAt(
	        	        rs.getTimestamp("createdAt"));

	        	collections.add(c);
	        }
	    }

	    return collections;
	}
	
	@Override
	public List<Collection> getCollectionsByShift(String shift) throws SQLException {
		pst2.setString(1, shift);
		List<Collection> collections = new ArrayList<>();
		
		try(ResultSet rs = pst2.executeQuery())
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
		return collections;
	}
	
	
	

	@Override
	public List<Report> getDateWiseCollectionReport(LocalDate fromDate, LocalDate toDate) throws SQLException
	{
		pst3.setDate(1, Date.valueOf(fromDate));
	    pst3.setDate(2, Date.valueOf(toDate));

	    List<Report> reports = new ArrayList<>();

	    try(ResultSet rs = pst3.executeQuery())
	    {
	        while(rs.next())
	        {
	            Report report = new Report();

	            report.setFarmerCode(
	                    rs.getString("farmerCode"));

	            report.setFarmerName(
	                    rs.getString("farmer_name"));

	            report.setTotalQty(
	                    rs.getDouble("totalQty"));

	            report.setTotalAmount(
	                    rs.getDouble("totalAmount"));

	            reports.add(report);
	        }
	    }

	    return reports;
	}
	
	@Override
	public List<Collection> getFarmerCollections(String farmerCode, LocalDate fromDate, LocalDate toDate) throws SQLException
	{
	    pst4.setString(1, farmerCode);
	    pst4.setDate(2, Date.valueOf(fromDate));
	    pst4.setDate(3, Date.valueOf(toDate));

	    List<Collection> collections = new ArrayList<>();

	    try(ResultSet rs = pst4.executeQuery())
	    {
	        while(rs.next())
	        {
	            Collection c = new Collection();

	            c.setCollectionId(
	                    rs.getInt("collectionId"));

	            c.setFarmerCode(
	                    rs.getString("farmerCode"));

	            c.setCollectionDate(
	                    rs.getDate("collectionDate").toLocalDate());

	            c.setShift(
	                    rs.getString("shift"));

	            c.setMilkType(
	                    rs.getString("milkType"));

	            c.setQuantity(
	                    rs.getDouble("quantity"));

	            c.setFat(
	                    rs.getDouble("fat"));

	            c.setSnf(
	                    rs.getDouble("snf"));

	            c.setAmount(
	                    rs.getDouble("amount"));

	            c.setRatePerLtr(
	                    rs.getDouble("ratePerLtr"));

	            c.setCreatedAt(
	                    rs.getTimestamp("createdAt"));

	            collections.add(c);
	        }
	    }

	    return collections;
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

	    System.out.println("milkcollection Report Dao Cleaned Up!!");
	}

}
