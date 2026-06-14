package com.milkmitra.dao;

import java.sql.SQLException;

import com.milkmitra.model.User;

public interface IUserDao
{
	User authenticate(String username, String password) throws SQLException; //for authentications
	
	//Creting Farmer In users Table For Login Purpose
	void createFarmerLogin(String mobile, String farmerCode, String email) throws SQLException;

	void cleanUp() throws SQLException;
	
}
