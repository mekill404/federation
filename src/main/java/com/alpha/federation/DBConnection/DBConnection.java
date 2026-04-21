package com.alpha.federation.DBConnection;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

public class DBConnection {

    public Connection getConnection() {
        try {
            String jdbcURl = System.getenv("jdbc:postgresql://localhost:5432/agri_federation_db"); //
            String user = System.getenv("agri_federation_manager");
            String password = System.getenv("123456");
            return DriverManager.getConnection("jdbc:postgresql://localhost:5432/agri_federation_db", "postgres", "Alpha 263035");
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