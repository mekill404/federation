package com.alpha.federation.repository;

import com.alpha.federation.DBConnection.DBConnection;
import com.alpha.federation.model.Member;
import com.alpha.federation.model.enums.StatutMembre;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

import org.springframework.stereotype.Repository;

@Repository
public class MemberRepository {

    private final DBConnection dbConnection;

    public MemberRepository(DBConnection dbConnection) {
        this.dbConnection = dbConnection;
    }

    public void save(Member member) {
        String sqlMember = "INSERT INTO members (id, last_name, first_name, email, status) VALUES (?, ?, ?, ?, ?)";
        String sqlReferees = "INSERT INTO parrainages (filleul_id, parrain_id) VALUES (?, ?)";

        try (Connection conn = dbConnection.getConnection()) {
            conn.setAutoCommit(false);
            try {
                try (PreparedStatement pstmt = conn.prepareStatement(sqlMember)) {
                    pstmt.setString(1, member.getId());
                    pstmt.setString(2, member.getLastName());
                    pstmt.setString(3, member.getFirstName());
                    pstmt.setString(4, member.getEmail());
                    pstmt.setString(5, member.getStatus().name());
                    pstmt.executeUpdate();
                }

                if (member.getReferees() != null && !member.getReferees().isEmpty()) {
                    try (PreparedStatement pstmt = conn.prepareStatement(sqlReferees)) {
                        for (Member ref : member.getReferees()) {
                            pstmt.setString(1, member.getId());
                            pstmt.setString(2, ref.getId());
                            pstmt.addBatch();
                        }
                        pstmt.executeBatch();
                    }
                }
                conn.commit();
            } catch (SQLException e) {
                conn.rollback(); 
                throw e;
            }
        } catch (SQLException e) {
            throw new RuntimeException("error save : " + e.getMessage());
        }
    }

    public Member findById(String id) {
        String sqlMember = "SELECT * FROM members WHERE id = ?";
        String sqlReferees = "SELECT m.* FROM members m JOIN parrainages p ON m.id = p.parrain_id WHERE p.filleul_id = ?";

        try (Connection conn = dbConnection.getConnection()) {
            Member member = null;
            
            try (PreparedStatement pstmt = conn.prepareStatement(sqlMember)) {
                pstmt.setString(1, id);
                try (ResultSet rs = pstmt.executeQuery()) {
                    if (rs.next()) {
                        member = mapResultSetToMember(rs);
                    }
                }
            }

            if (member != null) {
                try (PreparedStatement pstmt = conn.prepareStatement(sqlReferees)) {
                    pstmt.setString(1, id);
                    try (ResultSet rs = pstmt.executeQuery()) {
                        while (rs.next()) {
                            member.getReferees().add(mapResultSetToMember(rs));
                        }
                    }
                }
            }
            return member;
        } catch (SQLException e) {
            throw new RuntimeException("Erreur de lecture : " + e.getMessage());
        }
    }

    private Member mapResultSetToMember(ResultSet rs) throws SQLException {
        Member m = new Member();
        m.setId(rs.getString("id"));
        m.setLastName(rs.getString("last_name"));
        m.setFirstName(rs.getString("first_name"));
        m.setEmail(rs.getString("email"));
        m.setStatus(StatutMembre.valueOf(rs.getString("status")));
        return m;
    }
}