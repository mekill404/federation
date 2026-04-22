package com.alpha.federation.repository;

import com.alpha.federation.DBConnection.DBConnection;
import com.alpha.federation.model.PaymentEntity;
import org.springframework.stereotype.Repository;
import java.sql.*;
import java.util.UUID;

@Repository
public class PaymentRepository {
    private final DBConnection dbConnection;

    public PaymentRepository(DBConnection dbConnection) {
        this.dbConnection = dbConnection;
    }

    public PaymentEntity save(PaymentEntity payment) {
        String sql = "INSERT INTO payment (id, member_id, membership_fee_id, amount, payment_mode, account_credited_id, creation_date) " +
                     "VALUES (?, ?::uuid, ?::uuid, ?, ?::payment_mode, ?::uuid, ?)";
        try (Connection conn = dbConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            payment.setId(UUID.randomUUID().toString());
            pstmt.setString(1, payment.getId());
            pstmt.setString(2, payment.getMemberId());
            pstmt.setString(3, payment.getMembershipFeeId());
            pstmt.setDouble(4, payment.getAmount());
            pstmt.setString(5, payment.getPaymentMode().name());
            pstmt.setString(6, payment.getAccountCreditedId());
            pstmt.setDate(7, Date.valueOf(payment.getCreationDate()));
            pstmt.executeUpdate();
            return payment;
        } catch (SQLException e) {
            throw new RuntimeException("Error saving payment: " + e.getMessage());
        }
    }
}