package com.alpha.federation.repository;

import com.alpha.federation.DBConnection.DBConnection;
import com.alpha.federation.model.Member;
import com.alpha.federation.model.enums.Gender;
import com.alpha.federation.model.enums.Occupation;

import org.springframework.stereotype.Repository;

import java.sql.*;
import java.time.LocalDate;
import java.util.ArrayList;
import java.util.List;

@Repository
public class MemberRepository {

    private final DBConnection dbConnection;

    public MemberRepository(DBConnection dbConnection) {
        this.dbConnection = dbConnection;
    }

    public void save(Member member) {
        String sql = "INSERT INTO members (id, first_name, last_name, birth_date, gender, address, profession, phone_number, email, occupation) " +
                     "VALUES (?, ?, ?, ?, ?::gender, ?, ?, ?, ?, ?::member_occupation)";
        try (Connection conn = dbConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setString(1, member.getId());
            pstmt.setString(2, member.getFirstName());
            pstmt.setString(3, member.getLastName());
            pstmt.setDate(4, Date.valueOf(member.getBirthDate()));
            pstmt.setString(5, member.getGender().name());
            pstmt.setString(6, member.getAddress());
            pstmt.setString(7, member.getProfession());
            pstmt.setString(8, member.getPhoneNumber());
            pstmt.setString(9, member.getEmail());
            pstmt.setString(10, member.getOccupation().name());
            pstmt.executeUpdate();
        } catch (SQLException e) {
            throw new RuntimeException("Error saving member: " + e.getMessage());
        }
    }

    public void saveReferees(String candidateId, List<String> refereeIds) {
        String sql = "INSERT INTO referees (candidate_id, referee_id) VALUES (?, ?)";
        try (Connection conn = dbConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            for (String refId : refereeIds) {
                pstmt.setString(1, candidateId);
                pstmt.setString(2, refId);
                pstmt.addBatch();
            }
            pstmt.executeBatch();
        } catch (SQLException e) {
            throw new RuntimeException("Error saving referees: " + e.getMessage());
        }
    }

    public Member findById(String id) {
        String sql = "SELECT * FROM members WHERE id = ?";
        try (Connection conn = dbConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setString(1, id);
            try (ResultSet rs = pstmt.executeQuery()) {
                if (rs.next()) {
                    return mapRow(rs);
                }
            }
        } catch (SQLException e) {
            throw new RuntimeException("Error searching member: " + e.getMessage());
        }
        return null;
    }

    public List<Member> findReferees(String candidateId) {
        List<Member> referees = new ArrayList<>();
        String sql = "SELECT m.* FROM members m JOIN referees r ON m.id = r.referee_id WHERE r.candidate_id = ?";
        try (Connection conn = dbConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setString(1, candidateId);
            try (ResultSet rs = pstmt.executeQuery()) {
                while (rs.next()) {
                    referees.add(mapRow(rs));
                }
            }
        } catch (SQLException e) {
            throw new RuntimeException("Error searching referees: " + e.getMessage());
        }
        return referees;
    }

    public LocalDate getAdhesionDate(String memberId) {
        String sql = "SELECT created_at FROM members WHERE id = ?";
        try (Connection conn = dbConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setString(1, memberId);
            try (ResultSet rs = pstmt.executeQuery()) {
                if (rs.next()) {
                    return rs.getDate("created_at").toLocalDate();
                }
            }
        } catch (SQLException e) {
            throw new RuntimeException("Error getting adhesion date: " + e.getMessage());
        }
        return null;
    }

    public Member mapRow(ResultSet rs) throws SQLException {
        Member m = new Member();
        m.setId(rs.getString("id"));
        m.setFirstName(rs.getString("first_name"));
        m.setLastName(rs.getString("last_name"));
        m.setBirthDate(rs.getDate("birth_date").toLocalDate());
        m.setGender(Gender.valueOf(rs.getString("gender")));
        m.setAddress(rs.getString("address"));
        m.setProfession(rs.getString("profession"));
        m.setPhoneNumber(rs.getString("phone_number"));
        m.setEmail(rs.getString("email"));
        m.setOccupation(Occupation.valueOf(rs.getString("occupation")));
        return m;
    }
}