package com.milkmitra.dao;

import java.sql.SQLException;

import com.milkmitra.model.User;

public interface IUserDao
{
	User authenticate(String username, String password) throws SQLException; //for authentications
	void cleanUp() 	throws SQLException;
	
	
}
