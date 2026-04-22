package com.alpha.federation.DBConnection;

import org.junit.jupiter.api.AfterEach;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import java.sql.Connection;
import java.sql.SQLException;

import static org.junit.jupiter.api.Assertions.*;

public class DBConnectionTest {
    
    private DBConnection dbConnection;
    private Connection connection;

    @BeforeEach
    void setUp() {
        dbConnection = new DBConnection();
    }


    @Test
    void testGetConnection() throws SQLException {
        connection = dbConnection.getConnection();
        
        assertNotNull(connection, "The connection should not be null");
        
        assertTrue(connection.isValid(2), "The connection should be valid and active");
    }

}