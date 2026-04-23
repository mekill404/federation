package com.alpha.federation.DBConnection;

import org.springframework.stereotype.Component;

import com.alpha.federation.exception.ConflictException;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

@Component
public class DBConnection {

	public Connection getConnection() throws SQLException {
		String jdbcURL = System.getProperty("DB_URL");
		String user = System.getProperty("DB_USER");
		String password = System.getProperty("DB_PASSWORD");

		if (jdbcURL == null || user == null || password == null) {
			throw new ConflictException("Database credentials not set. Check your .env file or system properties.");
		}

		return DriverManager.getConnection(jdbcURL, user, password);
	}
}