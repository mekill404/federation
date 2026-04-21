package com.alpha.federation.repository;

import com.alpha.federation.DBConnection.DBConnection;
import com.alpha.federation.model.Collectivity;
import com.alpha.federation.model.Member;

import org.springframework.stereotype.Repository;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

@Repository
public class CollectivityRepository {

	private final DBConnection dbConnection;
	private final MemberRepository memberRepository;

	public CollectivityRepository(DBConnection dbConnection, MemberRepository memberRepository) {
		this.dbConnection = dbConnection;
		this.memberRepository = memberRepository;
	}

	public void save(Collectivity col) {
		String sql = "INSERT INTO collectivities (id, location, federation_approval, approval_date) VALUES (?, ?, ?, ?)";
		try (Connection conn = dbConnection.getConnection();
				PreparedStatement pstmt = conn.prepareStatement(sql)) {
			pstmt.setString(1, col.getId());
			pstmt.setString(2, col.getLocation());
			pstmt.setBoolean(3, true);
			pstmt.setDate(4, Date.valueOf(java.time.LocalDate.now()));
			pstmt.executeUpdate();
		} catch (SQLException e) {
			throw new RuntimeException("Error saving collectivity: " + e.getMessage());
		}
	}

	public void saveStructure(String collectivityId, String presidentId, String vicePresidentId,
			String treasurerId, String secretaryId, int year) {
		String sql = "INSERT INTO collectivity_structure (collectivity_id, mandat_year, president_id, vice_president_id, treasurer_id, secretary_id, start_date, end_date) "
				+
				"VALUES (?, ?, ?, ?, ?, ?, ?, ?)";
		try (Connection conn = dbConnection.getConnection();
				PreparedStatement pstmt = conn.prepareStatement(sql)) {
			pstmt.setString(1, collectivityId);
			pstmt.setInt(2, year);
			pstmt.setString(3, presidentId);
			pstmt.setString(4, vicePresidentId);
			pstmt.setString(5, treasurerId);
			pstmt.setString(6, secretaryId);
			pstmt.setDate(7, Date.valueOf(java.time.LocalDate.of(year, 1, 1)));
			pstmt.setDate(8, Date.valueOf(java.time.LocalDate.of(year, 12, 31)));
			pstmt.executeUpdate();
		} catch (SQLException e) {
			throw new RuntimeException("Error saving collectivity structure: " + e.getMessage());
		}
	}

	public void addMemberships(String collectivityId, List<String> memberIds) {
		String sql = "INSERT INTO membership (member_id, collectivity_id, role_in_collectivity, joined_at) VALUES (?, ?, ?::member_occupation, ?)";
		try (Connection conn = dbConnection.getConnection();
				PreparedStatement pstmt = conn.prepareStatement(sql)) {
			for (String memberId : memberIds) {
				pstmt.setString(1, memberId);
				pstmt.setString(2, collectivityId);
				pstmt.setString(3, "JUNIOR");
				pstmt.setDate(4, Date.valueOf(java.time.LocalDate.now()));
				pstmt.addBatch();
			}
			pstmt.executeBatch();
		} catch (SQLException e) {
			throw new RuntimeException("Error adding members: " + e.getMessage());
		}
	}

	public List<Member> getMembers(String collectivityId) {
		List<Member> members = new ArrayList<>();
		String sql = "SELECT m.* FROM members m JOIN membership ms ON m.id = ms.member_id WHERE ms.collectivity_id = ?";
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

	public void saveStructure(String id, Member president, Member vicePresident, Member treasurer, Member secretary,
			int currentYear) {
		throw new UnsupportedOperationException("Unimplemented method 'saveStructure'");
	}
}