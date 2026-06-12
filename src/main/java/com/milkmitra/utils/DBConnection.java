package com.milkmitra.utils;

import java.sql.Connection;
import java.sql.DriverManager;

public class DBConnection {

    private static Connection cn;

    public static Connection openConnection() throws Exception {

        if (cn == null || cn.isClosed()) {

            Class.forName("com.mysql.cj.jdbc.Driver");

            // Read from environment variables
            String dbUrl  = System.getenv("DB_URL");
            String dbUser = System.getenv("DB_USER");
            String dbPass = System.getenv("DB_PASSWORD");

            // Fallback to localhost for local development
            if (dbUrl  == null) dbUrl  = "jdbc:mysql://localhost:3306/milkmitra?useSSL=false&allowPublicKeyRetrieval=true";
            if (dbUser == null) dbUser = "root";
            if (dbPass == null) dbPass = "password";

            cn = DriverManager.getConnection(dbUrl, dbUser, dbPass);

            System.out.println("Connection Created");
        }

        return cn;
    }
}