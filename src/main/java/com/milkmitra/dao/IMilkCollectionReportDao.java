package com.milkmitra.dao;

import java.sql.SQLException;
import java.time.LocalDate;
import java.util.List;

import com.milkmitra.model.Collection;
import com.milkmitra.model.Report;

public interface IMilkCollectionReportDao
{
	//1. Today's Collection Report
	List<Collection> getTodayCollections() throws SQLException;
	
	//2. Collection Report By Shift
	List<Collection> getCollectionsByShift(String shift)throws SQLException;
		
		
	//3. Feature for Latest Payment Report Per Cycle... 
	List<Report> getDateWiseCollectionReport(LocalDate fromDate, LocalDate toDate) throws SQLException;
	
	//4. eature for View Section on DateWiseCollectionReport.jsp 
	List<Collection> getFarmerCollections(String farmerCode, LocalDate fromDate, LocalDate toDate) throws SQLException;

}
