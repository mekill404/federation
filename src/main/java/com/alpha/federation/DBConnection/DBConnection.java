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

            String url = "jdbc:postgresql://localhost:5432/federation";
            String user = "alking";
            String password = "Alpha 263035";


            return DriverManager.getConnection(url, user, password);
        } catch (SQLException e) {
            throw new RuntimeException("Erreur de connexion : " + e.getMessage());
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