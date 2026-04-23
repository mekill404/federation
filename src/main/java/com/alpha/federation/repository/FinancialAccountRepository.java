package com.alpha.federation.repository;

import com.alpha.federation.DBConnection.DBConnection;
import com.alpha.federation.model.FinancialAccountEntity;
import com.alpha.federation.model.enums.AccountType;
import com.alpha.federation.model.enums.Bank;
import com.alpha.federation.model.enums.MobileBankingService;
import org.springframework.stereotype.Repository;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import java.util.UUID;

@Repository
public class FinancialAccountRepository {
    private final DBConnection dbConnection;

    public FinancialAccountRepository(DBConnection dbConnection) {
        this.dbConnection = dbConnection;
    }

    public FinancialAccountEntity save(FinancialAccountEntity account) {
        String sql = "INSERT INTO financial_account (id, collectivity_id, account_type, holder_name, amount, " +
                     "bank_name, bank_code, bank_branch_code, bank_account_number, bank_account_key, " +
                     "mobile_banking_service, mobile_number) " +
                     "VALUES (?, ?, ?::account_type, ?, ?, ?::bank_name, ?, ?, ?, ?, ?::mobile_banking_service, ?)";
        try (Connection conn = dbConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            account.setId(UUID.randomUUID().toString());
            pstmt.setString(1, account.getId());
            pstmt.setString(2, account.getCollectivityId());
            pstmt.setString(3, account.getAccountType().name());
            pstmt.setString(4, account.getHolderName());
            pstmt.setDouble(5, account.getAmount() != null ? account.getAmount() : 0.0);
            if (account.getBankName() != null) pstmt.setString(6, account.getBankName().name());
            else pstmt.setNull(6, Types.VARCHAR);
            pstmt.setString(7, account.getBankCode());
            pstmt.setString(8, account.getBankBranchCode());
            pstmt.setString(9, account.getBankAccountNumber());
            pstmt.setString(10, account.getBankAccountKey());
            if (account.getMobileBankingService() != null) pstmt.setString(11, account.getMobileBankingService().name());
            else pstmt.setNull(11, Types.VARCHAR);
            pstmt.setString(12, account.getMobileNumber());
            pstmt.executeUpdate();
            return account;
        } catch (SQLException e) {
            throw new RuntimeException("Error saving financial account: " + e.getMessage());
        }
    }

    public FinancialAccountEntity findById(String id) {
        String sql = "SELECT * FROM financial_account WHERE id = ?";
        try (Connection conn = dbConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setString(1, id);
            try (ResultSet rs = pstmt.executeQuery()) {
                if (rs.next()) return mapRow(rs);
            }
        } catch (SQLException e) {
            throw new RuntimeException("Error finding financial account: " + e.getMessage());
        }
        return null;
    }

    public List<FinancialAccountEntity> findByCollectivityId(String collectivityId) {
        List<FinancialAccountEntity> list = new ArrayList<>();
        String sql = "SELECT * FROM financial_account WHERE collectivity_id = ?";
        try (Connection conn = dbConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setString(1, collectivityId);
            try (ResultSet rs = pstmt.executeQuery()) {
                while (rs.next()) list.add(mapRow(rs));
            }
        } catch (SQLException e) {
            throw new RuntimeException("Error finding accounts: " + e.getMessage());
        }
        return list;
    }

    public void updateAmount(String accountId, double newAmount) {
        String sql = "UPDATE financial_account SET amount = ? WHERE id = ?";
        try (Connection conn = dbConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setDouble(1, newAmount);
            pstmt.setString(2, accountId);
            pstmt.executeUpdate();
        } catch (SQLException e) {
            throw new RuntimeException("Error updating amount: " + e.getMessage());
        }
    }

    private FinancialAccountEntity mapRow(ResultSet rs) throws SQLException {
        FinancialAccountEntity acc = new FinancialAccountEntity();
        acc.setId(rs.getString("id"));
        acc.setCollectivityId(rs.getString("collectivity_id"));
        acc.setAccountType(AccountType.valueOf(rs.getString("account_type")));
        acc.setHolderName(rs.getString("holder_name"));
        acc.setAmount(rs.getDouble("amount"));
        String bankName = rs.getString("bank_name");
        if (bankName != null) acc.setBankName(Bank.valueOf(bankName));
        acc.setBankCode(rs.getString("bank_code"));
        acc.setBankBranchCode(rs.getString("bank_branch_code"));
        acc.setBankAccountNumber(rs.getString("bank_account_number"));
        acc.setBankAccountKey(rs.getString("bank_account_key"));
        String mobileService = rs.getString("mobile_banking_service");
        if (mobileService != null) acc.setMobileBankingService(MobileBankingService.valueOf(mobileService));
        acc.setMobileNumber(rs.getString("mobile_number"));
        return acc;
    }
}