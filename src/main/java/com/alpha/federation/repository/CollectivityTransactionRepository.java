package com.alpha.federation.repository;

import com.alpha.federation.DBConnection.DBConnection;
import com.alpha.federation.model.CollectivityTransactionEntity;
import com.alpha.federation.model.enums.PaymentMode;
import org.springframework.stereotype.Repository;
import java.sql.*;
import java.time.LocalDate;
import java.util.ArrayList;
import java.util.List;
import java.util.UUID;

@Repository
public class CollectivityTransactionRepository {
    private final DBConnection dbConnection;

    public CollectivityTransactionRepository(DBConnection dbConnection) {
        this.dbConnection = dbConnection;
    }

    public CollectivityTransactionEntity save(CollectivityTransactionEntity transaction) {
        String sql = "INSERT INTO collectivity_transaction (id, collectivity_id, member_debited_id, amount, payment_mode, account_credited_id, creation_date) "
                +
                "VALUES (?, ?::uuid, ?::uuid, ?, ?::payment_mode, ?::uuid, ?)";
        try (Connection conn = dbConnection.getConnection();
                PreparedStatement pstmt = conn.prepareStatement(sql)) {
            transaction.setId(UUID.randomUUID().toString());
            pstmt.setString(1, transaction.getId());
            pstmt.setString(2, transaction.getCollectivityId());
            pstmt.setString(3, transaction.getMemberDebitedId());
            pstmt.setDouble(4, transaction.getAmount());
            pstmt.setString(5, transaction.getPaymentMode().name());
            pstmt.setString(6, transaction.getAccountCreditedId());
            pstmt.setDate(7, Date.valueOf(transaction.getCreationDate()));
            pstmt.executeUpdate();
            return transaction;
        } catch (SQLException e) {
            throw new RuntimeException("Error saving transaction: " + e.getMessage());
        }
    }

    public List<CollectivityTransactionEntity> findByCollectivityIdAndPeriod(String collectivityId, LocalDate from,
            LocalDate to) {
        List<CollectivityTransactionEntity> list = new ArrayList<>();
        String sql = "SELECT * FROM collectivity_transaction WHERE collectivity_id = ?::uuid AND creation_date BETWEEN ? AND ?";
        try (Connection conn = dbConnection.getConnection();
                PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setString(1, collectivityId);
            pstmt.setDate(2, Date.valueOf(from));
            pstmt.setDate(3, Date.valueOf(to));
            try (ResultSet rs = pstmt.executeQuery()) {
                while (rs.next())
                    list.add(mapRow(rs));
            }
        } catch (SQLException e) {
            throw new RuntimeException("Error finding transactions: " + e.getMessage());
        }
        return list;
    }

    private CollectivityTransactionEntity mapRow(ResultSet rs) throws SQLException {
        CollectivityTransactionEntity t = new CollectivityTransactionEntity();
        t.setId(rs.getString("id"));
        t.setCollectivityId(rs.getString("collectivity_id"));
        t.setMemberDebitedId(rs.getString("member_debited_id"));
        t.setAmount(rs.getDouble("amount"));
        t.setPaymentMode(PaymentMode.valueOf(rs.getString("payment_mode")));
        t.setAccountCreditedId(rs.getString("account_credited_id"));
        t.setCreationDate(rs.getDate("creation_date").toLocalDate());
        return t;
    }

    public Double sumAmountByAccountAfterDate(String accountId, LocalDate afterDate) {
        String sql = "SELECT SUM(amount) FROM collectivity_transaction WHERE account_credited_id = ?::uuid AND creation_date > ?";
        try (Connection conn = dbConnection.getConnection();
                PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setString(1, accountId);
            pstmt.setDate(2, Date.valueOf(afterDate));
            try (ResultSet rs = pstmt.executeQuery()) {
                if (rs.next()) {
                    return rs.getDouble(1);
                }
            }
        } catch (SQLException e) {
            throw new RuntimeException("Error summing transactions: " + e.getMessage());
        }
        return 0.0;
    }
}