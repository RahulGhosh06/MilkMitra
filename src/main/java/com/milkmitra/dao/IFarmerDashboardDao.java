package com.milkmitra.dao;

import java.sql.SQLException;

import com.milkmitra.model.Farmer;
import com.milkmitra.model.FarmerDashboard;

public interface IFarmerDashboardDao {
	
	//1. Fetures for the Farmer Dashboard 
    FarmerDashboard getFarmerDashboardData(String farmerCode) throws SQLException;
    
   // Add to IFarmerDashboardDao
   Farmer getFarmerProfile(String farmerCode) throws SQLException;
}
