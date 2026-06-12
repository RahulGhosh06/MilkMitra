package com.milkmitra.utils;

import java.sql.Connection;
import java.sql.DriverManager;

public class DBConnection
{
	//add a static method to return DB connection instance
		//modify the code below, to ensure SINGLETON instance of the DB connection(not a scalable, will be replaced by connection pool from Hibernate onwards)
		
		private static Connection cn;
		public static  Connection openConnection() throws Exception, ClassNotFoundException
		{
			if(cn == null || cn.isClosed())
			{
				Class.forName("com.mysql.cj.jdbc.Driver");
				String url = "jdbc:mysql://localhost:3306/milkmitra?useSSL=false&allowPublicKeyRetrieval=true";
				cn =  DriverManager.getConnection(url,"root","password");
				
				System.out.println("Connection Created");
			}
			return cn;
		}
}
