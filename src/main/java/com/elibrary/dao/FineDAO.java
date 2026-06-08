package com.elibrary.dao;

import com.elibrary.model.Fine;
import com.elibrary.util.DBConnection;

import java.math.BigDecimal;
import java.sql.*;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;

/**
 * DAO for fines table. Provides CRUD and query operations.
 */
public class FineDAO {

    public Fine findById(int fineId) throws SQLException {
        String sql = "SELECT * FROM fines WHERE fine_id = ?";
        try (Connection conn = DBConnection.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, fineId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return mapFine(rs);
                }
            }
        }
        return null;
    }

    public List<Fine> findByStudentId(int studentId) throws SQLException {
        String sql = "SELECT * FROM fines WHERE student_id = ? ORDER BY created_at DESC";
        try (Connection conn = DBConnection.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, studentId);
            try (ResultSet rs = ps.executeQuery()) {
                List<Fine> list = new ArrayList<>();
                while (rs.next())
                    list.add(mapFine(rs));
                return list;
            }
        }
    }

    public List<Fine> findAll() throws SQLException {
        String sql = "SELECT * FROM fines ORDER BY created_at DESC";
        try (Connection conn = DBConnection.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            try (ResultSet rs = ps.executeQuery()) {
                List<Fine> list = new ArrayList<>();
                while (rs.next())
                    list.add(mapFine(rs));
                return list;
            }
        }
    }

    public int insertFine(Fine fine) throws SQLException {
        String sql = "INSERT INTO fines (borrow_id, student_id, book_id, due_date, return_date, days_late, fine_amount, status) VALUES (?,?,?,?,?,?,?,?)";
        try (Connection conn = DBConnection.getConnection();
                PreparedStatement ps = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            ps.setInt(1, fine.getBorrowId());
            ps.setInt(2, fine.getStudentId());
            ps.setInt(3, fine.getBookId());
            ps.setDate(4, Date.valueOf(fine.getDueDate()));
            ps.setDate(5, fine.getReturnDate() == null ? null : Date.valueOf(fine.getReturnDate()));
            ps.setInt(6, fine.getDaysLate());
            ps.setBigDecimal(7, fine.getFineAmount() == null ? BigDecimal.ZERO : fine.getFineAmount());
            ps.setString(8, fine.getStatus() == null ? "UNPAID" : fine.getStatus());
            ps.executeUpdate();
            try (ResultSet keys = ps.getGeneratedKeys()) {
                if (keys.next())
                    return keys.getInt(1);
            }
        }
        return -1;
    }

    public boolean updateStatus(int fineId, String status) throws SQLException {
        String sql = "UPDATE fines SET status = ?, updated_at = CURRENT_TIMESTAMP WHERE fine_id = ?";
        try (Connection conn = DBConnection.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, status);
            ps.setInt(2, fineId);
            return ps.executeUpdate() > 0;
        }
    }

    public boolean deleteFine(int fineId) throws SQLException {
        String sql = "DELETE FROM fines WHERE fine_id = ?";
        try (Connection conn = DBConnection.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, fineId);
            return ps.executeUpdate() > 0;
        }
    }

    public BigDecimal totalFineForStudent(int studentId) throws SQLException {
        String sql = "WITH unpaid_fines AS ("
                + "SELECT borrow_id, fine_amount FROM fines WHERE student_id = ? AND status = 'UNPAID' "
                + "UNION ALL "
                + "SELECT id AS borrow_id, fine_amount FROM borrow WHERE student_id = ? AND fine_paid = FALSE AND fine_amount > 0 "
                + ") SELECT COALESCE(SUM(fine_amount), 0) FROM ("
                + "SELECT borrow_id, MAX(fine_amount) AS fine_amount FROM unpaid_fines GROUP BY borrow_id"
                + ") pending_fines";
        try (Connection conn = DBConnection.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, studentId);
            ps.setInt(2, studentId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next())
                    return rs.getBigDecimal(1);
            }
        }
        return BigDecimal.ZERO;
    }

    private Fine mapFine(ResultSet rs) throws SQLException {
        Fine f = new Fine();
        f.setFineId(rs.getInt("fine_id"));
        f.setBorrowId(rs.getInt("borrow_id"));
        f.setStudentId(rs.getInt("student_id"));
        f.setBookId(rs.getInt("book_id"));
        Date due = rs.getDate("due_date");
        Date ret = rs.getDate("return_date");
        if (due != null)
            f.setDueDate(due.toLocalDate());
        if (ret != null)
            f.setReturnDate(ret.toLocalDate());
        f.setDaysLate(rs.getInt("days_late"));
        f.setFineAmount(rs.getBigDecimal("fine_amount"));
        f.setStatus(rs.getString("status"));
        Timestamp c = rs.getTimestamp("created_at");
        Timestamp u = rs.getTimestamp("updated_at");
        if (c != null)
            f.setCreatedAt(c.toLocalDateTime());
        if (u != null)
            f.setUpdatedAt(u.toLocalDateTime());
        return f;
    }
}
