package com.milkmitra.dao;

import java.sql.SQLException;
import java.util.List;

import com.milkmitra.model.Farmer;

public interface IFarmerDao {
	
	//adding a method for inserting Farmer details by Admin..
	String addFarmer(Farmer farmer) throws SQLException;
	
	//adding a method for Listing all farmers....
	List<Farmer> getAllFarmers() throws SQLException;
	
	//adding a method for view farmer details..
	Farmer getFarmerDetails(String farmerCode) throws SQLException;
	
	//adding a method for Editing farmer details...
	int editFarmerDetails(Farmer farmer) throws SQLException; 
	
	//adding a method for deactivating Farmers by admin...
	int deactivateFarmer(String farmerCode) throws SQLException;
	
	//adding a method to reactivate Farmers by Admin
	int reactivateFarmer(String farmerCode) throws SQLException;
	
	

}
