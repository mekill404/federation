package com.alpha.federation.service;

import com.alpha.federation.DBConnection.DBConnection;
import java.sql.Connection;
import java.sql.PreparedStatement;

public class FinanceService {

    private DBConnection dbConnection;


    public FinanceService(DBConnection dbConnection) {
        this.dbConnection = dbConnection;
    }

    public void savePayment(String memberId, double amount, String accountId) {
        try (Connection conn = dbConnection.getConnection()) {
            conn.setAutoCommit(false);


            String sqlPay = "INSERT INTO payment (member_id, amount, account_id) VALUES (?, ?, ?)";
            PreparedStatement ps1 = conn.prepareStatement(sqlPay);
            ps1.setString(1, memberId);
            ps1.setDouble(2, amount);
            ps1.setString(3, accountId);
            ps1.executeUpdate();


            String sqlAcc = "UPDATE financial_account SET amount = amount + ? WHERE id = ?";
            PreparedStatement ps2 = conn.prepareStatement(sqlAcc);
            ps2.setDouble(1, amount);
            ps2.setString(2, accountId);
            ps2.executeUpdate();


            String sqlTrans = "INSERT INTO collectivity_transaction (amount, account_id, member_id, creation_date) VALUES (?, ?, ?, CURRENT_DATE)";
            PreparedStatement ps3 = conn.prepareStatement(sqlTrans);
            ps3.setDouble(1, amount);
            ps3.setString(2, accountId);
            ps3.setString(3, memberId);
            ps3.executeUpdate();

            conn.commit();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}
