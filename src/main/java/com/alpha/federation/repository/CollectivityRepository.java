package com.alpha.federation.repository;

import com.alpha.federation.DBConnection.DBConnection;
import com.alpha.federation.model.CollectivityEntity;
import com.alpha.federation.model.MemberEntity;
import org.springframework.stereotype.Repository;
import java.sql.*;
import java.time.LocalDate;
import java.util.ArrayList;
import java.util.List;
import java.util.UUID;

@Repository
public class CollectivityRepository {

    private final DBConnection dbConnection;
    private final MemberRepository memberRepository;

    public CollectivityRepository(DBConnection dbConnection, MemberRepository memberRepository) {
        this.dbConnection = dbConnection;
        this.memberRepository = memberRepository;
    }

    public CollectivityEntity save(CollectivityEntity col) {
        String sql = "INSERT INTO collectivities (id, location, federation_approval, approval_date) VALUES (?, ?, ?, ?)";
        try (Connection conn = dbConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            col.setId(UUID.randomUUID().toString());
            pstmt.setString(1, col.getId());
            pstmt.setString(2, col.getLocation());
            pstmt.setBoolean(3, col.isFederationApproval());
            pstmt.setDate(4, Date.valueOf(LocalDate.now()));
            pstmt.executeUpdate();
            return col;
        } catch (SQLException e) {
            throw new RuntimeException("Error saving collectivity: " + e.getMessage());
        }
    }

    public void saveStructure(String collectivityId, String presidentId, String vicePresidentId,
                              String treasurerId, String secretaryId, int year) {
        String sql = "INSERT INTO collectivity_structure (collectivity_id, mandat_year, president_id, vice_president_id, treasurer_id, secretary_id, start_date, end_date) " +
                     "VALUES (?, ?, ?, ?, ?, ?, ?, ?)";
        try (Connection conn = dbConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setString(1, collectivityId);
            pstmt.setInt(2, year);
            pstmt.setString(3, presidentId);
            pstmt.setString(4, vicePresidentId);
            pstmt.setString(5, treasurerId);
            pstmt.setString(6, secretaryId);
            pstmt.setDate(7, Date.valueOf(LocalDate.of(year, 1, 1)));
            pstmt.setDate(8, Date.valueOf(LocalDate.of(year, 12, 31)));
            pstmt.executeUpdate();
        } catch (SQLException e) {
            throw new RuntimeException("Error saving structure: " + e.getMessage());
        }
    }

    public void addMembership(String collectivityId, String memberId, String role) {
        String sql = "INSERT INTO membership (member_id, collectivity_id, role_in_collectivity, joined_at) VALUES (?, ?, ?::member_occupation, ?)";
        try (Connection conn = dbConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setString(1, memberId);
            pstmt.setString(2, collectivityId);
            pstmt.setString(3, role);
            pstmt.setDate(4, Date.valueOf(LocalDate.now()));
            pstmt.executeUpdate();
        } catch (SQLException e) {
            throw new RuntimeException("Error adding member: " + e.getMessage());
        }
    }

    public List<MemberEntity> getMembers(String collectivityId) {
        List<MemberEntity> members = new ArrayList<>();
        String sql = "SELECT m.* FROM member m JOIN membership ms ON m.id = ms.member_id WHERE ms.collectivity_id = ? AND ms.left_at IS NULL";
        try (Connection conn = dbConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setString(1, collectivityId);
            try (ResultSet rs = pstmt.executeQuery()) {
                while (rs.next()) {
                    members.add(memberRepository.mapRow(rs));
                }
            }
        } catch (SQLException e) {
            throw new RuntimeException("Error retrieving members: " + e.getMessage());
        }
        return members;
    }

    public boolean isMemberOfCollectivity(String memberId, String collectivityId) {
        String sql = "SELECT 1 FROM membership WHERE member_id = ? AND collectivity_id = ? AND left_at IS NULL";
        try (Connection conn = dbConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setString(1, memberId);
            pstmt.setString(2, collectivityId);
            try (ResultSet rs = pstmt.executeQuery()) {
                return rs.next();
            }
        } catch (SQLException e) {
            throw new RuntimeException("Error checking membership: " + e.getMessage());
        }
    }

    public CollectivityEntity findById(String id) {
        String sql = "SELECT * FROM collectivities WHERE id = ?";
        try (Connection conn = dbConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setString(1, id);
            try (ResultSet rs = pstmt.executeQuery()) {
                if (rs.next()) {
                    CollectivityEntity col = new CollectivityEntity();
                    col.setId(rs.getString("id"));
                    col.setLocation(rs.getString("location"));
                    col.setFederationApproval(rs.getBoolean("federation_approval"));
                    col.setApprovalDate(rs.getDate("approval_date").toLocalDate());
                    loadStructure(col);
                    col.setMembers(getMembers(col.getId()));
                    return col;
                }
            }
        } catch (SQLException e) {
            throw new RuntimeException("Error searching collectivity: " + e.getMessage());
        }
        return null;
    }

    private void loadStructure(CollectivityEntity col) {
        String sql = "SELECT * FROM collectivity_structure WHERE collectivity_id = ? AND is_active = true";
        try (Connection conn = dbConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setString(1, col.getId());
            try (ResultSet rs = pstmt.executeQuery()) {
                if (rs.next()) {
                    col.setPresident(memberRepository.findById(rs.getString("president_id")));
                    col.setVicePresident(memberRepository.findById(rs.getString("vice_president_id")));
                    col.setTreasurer(memberRepository.findById(rs.getString("treasurer_id")));
                    col.setSecretary(memberRepository.findById(rs.getString("secretary_id")));
                }
            }
        } catch (SQLException e) {
            throw new RuntimeException("Error loading structure: " + e.getMessage());
        }
    }
}