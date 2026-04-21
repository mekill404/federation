package com.alpha.federation.DBConnection;

import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;
@Configuration
public class DBConnection {
@Bean
    public Connection getConnection() {
        try {
            String jdbcURl = System.getProperty("DB_URL");
            String user = System.getProperty("DB_USER");
            String password = System.getProperty("DB_PASSWORD");
            return DriverManager.getConnection(jdbcURl, user, password);
        } catch (SQLException e) {
            throw new RuntimeException(e);
        }
    }

    public void closeConnection(Connection connection) {
        if (connection != null) {
            try {
                connection.close();
            } catch (SQLException e) {
                throw new RuntimeException(e);
            }
        }
    }
}