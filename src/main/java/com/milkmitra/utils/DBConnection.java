package com.milkmitra.utils;

import java.sql.Connection;
import java.sql.DriverManager;

public class DBConnection {

    private static Connection cn;

    public static Connection openConnection() throws Exception {

        if (cn == null || cn.isClosed()) {

            Class.forName("com.mysql.cj.jdbc.Driver");

            String dbUrl  = System.getenv("DB_URL");
            String dbUser = System.getenv("DB_USER");
            String dbPass = System.getenv("DB_PASSWORD");

            if (dbUrl == null || dbUser == null || dbPass == null) {
                throw new IllegalStateException(
                    "Missing DB_URL, DB_USER, or DB_PASSWORD environment variable. " +
                    "Set these before starting the app.");
            }

            cn = DriverManager.getConnection(dbUrl, dbUser, dbPass);

            System.out.println("Connection Created");
        }

        return cn;
    }
}
