package com.alpha.federation.repository;

import com.alpha.federation.DBConnection.DBConnection;
import com.alpha.federation.model.Collectivity;

import org.springframework.stereotype.Repository;



import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.SQLException;

@Repository
public class CollectivityRepository {
    private final DBConnection dbConnection;

    public CollectivityRepository(DBConnection dbConnection) {
        this.dbConnection = dbConnection;
    }

    public void save(Collectivity col) {
        String sql = "INSERT INTO collectivities (id, unique_number, unique_name, specialty, creation_date, " +
                "federation_approval, president_id, vice_president_id, secretary_id, treasurer_id) " +
                "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";

        try (Connection conn = dbConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {

            pstmt.setString(1, col.getId());
            pstmt.setString(2, col.getUniqueNumber());
            pstmt.setString(3, col.getUniqueName());
            pstmt.setString(4, col.getSpecialty());
            pstmt.setObject(5, col.getCreationDate()); // Utilise setObject pour LocalDate
            pstmt.setBoolean(6, col.isFederationApproval());

            // On stocke les IDs des membres du bureau
            pstmt.setString(7, col.getPresident().getId());
            pstmt.setString(8, col.getVicePresident().getId());
            pstmt.setString(9, col.getSecretary().getId());
            pstmt.setString(10, col.getTreasurer().getId());

            pstmt.executeUpdate();
        } catch (SQLException e) {
            throw new RuntimeException("Erreur lors de la création de la collectivité : " + e.getMessage());
        }
    }
}