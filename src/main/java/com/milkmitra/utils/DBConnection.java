package com.milkmitra.utils;

import java.sql.Connection;
import java.sql.SQLException;

import com.zaxxer.hikari.HikariConfig;
import com.zaxxer.hikari.HikariDataSource;

public class DBConnection {

    private static HikariDataSource dataSource;

    static {
        String dbUrl  = System.getenv("DB_URL");
        String dbUser = System.getenv("DB_USER");
        String dbPass = System.getenv("DB_PASSWORD");

        if (dbUrl == null || dbUser == null || dbPass == null) {
            throw new IllegalStateException(
                "Missing DB_URL, DB_USER, or DB_PASSWORD environment variable. " +
                "Set these before starting the app.");
        }

        HikariConfig config = new HikariConfig();
        config.setJdbcUrl(dbUrl);
        config.setUsername(dbUser);
        config.setPassword(dbPass);
        config.setDriverClassName("com.mysql.cj.jdbc.Driver");

        config.setMaximumPoolSize(10);
        config.setMinimumIdle(2);
        config.setConnectionTimeout(30000); // 30 seconds
        config.setIdleTimeout(600000);       // 10 minutes
        config.setMaxLifetime(1800000);      // 30 minutes

        dataSource = new HikariDataSource(config);

        System.out.println("HikariCP connection pool initialized");
    }

        public static Connection getConnection() throws SQLException {
        return dataSource.getConnection();
    }
}