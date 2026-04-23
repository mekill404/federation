package com.alpha.federation.repository;

import com.alpha.federation.DBConnection.DBConnection;
import com.alpha.federation.model.MembershipFeeEntity;
import com.alpha.federation.model.enums.ActivityStatus;
import com.alpha.federation.model.enums.Frequency;
import org.springframework.stereotype.Repository;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import java.util.UUID;

@Repository
public class MembershipFeeRepository {
    private final DBConnection dbConnection;

    public MembershipFeeRepository(DBConnection dbConnection) {
        this.dbConnection = dbConnection;
    }

    public MembershipFeeEntity save(MembershipFeeEntity fee) {
        String sql = "INSERT INTO membership_fee (id, collectivity_id, label, amount, frequency, eligible_from, status) " +
                     "VALUES (?, ?, ?, ?, ?::frequency, ?, ?::activity_status)";
        try (Connection conn = dbConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            fee.setId(UUID.randomUUID().toString());
            pstmt.setString(1, fee.getId());
            pstmt.setString(2, fee.getCollectivityId());
            pstmt.setString(3, fee.getLabel());
            pstmt.setDouble(4, fee.getAmount());
            pstmt.setString(5, fee.getFrequency().name());
            pstmt.setDate(6, Date.valueOf(fee.getEligibleFrom()));
            pstmt.setString(7, fee.getStatus() != null ? fee.getStatus().name() : ActivityStatus.ACTIVE.name());
            pstmt.executeUpdate();
            return fee;
        } catch (SQLException e) {
            throw new RuntimeException("Error saving membership fee: " + e.getMessage());
        }
    }

    public List<MembershipFeeEntity> findByCollectivityId(String collectivityId) {
        List<MembershipFeeEntity> fees = new ArrayList<>();
        String sql = "SELECT * FROM membership_fee WHERE collectivity_id = ?";
        try (Connection conn = dbConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setString(1, collectivityId);
            try (ResultSet rs = pstmt.executeQuery()) {
                while (rs.next()) fees.add(mapRow(rs));
            }
        } catch (SQLException e) {
            throw new RuntimeException("Error finding membership fees: " + e.getMessage());
        }
        return fees;
    }

    public MembershipFeeEntity findById(String id) {
        String sql = "SELECT * FROM membership_fee WHERE id = ?";
        try (Connection conn = dbConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setString(1, id);
            try (ResultSet rs = pstmt.executeQuery()) {
                if (rs.next()) return mapRow(rs);
            }
        } catch (SQLException e) {
            throw new RuntimeException("Error finding membership fee: " + e.getMessage());
        }
        return null;
    }

    private MembershipFeeEntity mapRow(ResultSet rs) throws SQLException {
        MembershipFeeEntity fee = new MembershipFeeEntity();
        fee.setId(rs.getString("id"));
        fee.setCollectivityId(rs.getString("collectivity_id"));
        fee.setLabel(rs.getString("label"));
        fee.setAmount(rs.getDouble("amount"));
        fee.setFrequency(Frequency.valueOf(rs.getString("frequency")));
        fee.setEligibleFrom(rs.getDate("eligible_from").toLocalDate());
        fee.setStatus(ActivityStatus.valueOf(rs.getString("status")));
        return fee;
    }
}