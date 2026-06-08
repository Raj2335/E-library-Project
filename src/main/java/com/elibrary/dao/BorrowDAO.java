package com.elibrary.dao;

import com.elibrary.model.Borrow;
import com.elibrary.util.DBConnection;

import java.math.BigDecimal;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.time.LocalDate;
import java.util.ArrayList;
import java.util.List;

public class BorrowDAO {
    public int countIssuedBooks() throws SQLException {
        String sql = "SELECT COUNT(*) FROM borrow WHERE status IN ('ISSUED', 'OVERDUE')";
        try (Connection connection = DBConnection.getConnection();
                PreparedStatement statement = connection.prepareStatement(sql);
                ResultSet resultSet = statement.executeQuery()) {
            if (resultSet.next()) {
                return resultSet.getInt(1);
            }
            return 0;
        }
    }

    public List<Borrow> findRecentActivities(int limit) throws SQLException {
        String sql = "SELECT br.id, br.student_id, br.book_id, br.admin_id, br.issue_date, br.due_date, br.return_date, br.fine_amount, br.fine_paid, br.status, br.created_at, br.updated_at, s.name AS student_name, s.roll_num AS student_roll_num, b.title AS book_title, a.name AS admin_name FROM borrow br JOIN student s ON br.student_id = s.id JOIN book b ON br.book_id = b.id JOIN admin a ON br.admin_id = a.id ORDER BY br.created_at DESC LIMIT ?";
        return fetchBorrowList(sql, limit);
    }

    public List<Borrow> findCurrentBorrowsByStudentId(int studentId) throws SQLException {
        String sql = "SELECT br.id, br.student_id, br.book_id, br.admin_id, br.issue_date, br.due_date, br.return_date, "
                + "CASE WHEN GREATEST(DATEDIFF(CURDATE(), br.due_date), 0) <= 2 THEN 0.00 "
                + "WHEN GREATEST(DATEDIFF(CURDATE(), br.due_date), 0) BETWEEN 3 AND 7 THEN GREATEST(DATEDIFF(CURDATE(), br.due_date), 0) * 2 "
                + "WHEN GREATEST(DATEDIFF(CURDATE(), br.due_date), 0) BETWEEN 8 AND 15 THEN GREATEST(DATEDIFF(CURDATE(), br.due_date), 0) * 5 "
                + "ELSE GREATEST(DATEDIFF(CURDATE(), br.due_date), 0) * 10 END AS fine_amount, br.fine_paid, br.status, br.created_at, br.updated_at, "
                + "s.name AS student_name, s.roll_num AS student_roll_num, b.title AS book_title, a.name AS admin_name "
                + "FROM borrow br JOIN student s ON br.student_id = s.id JOIN book b ON br.book_id = b.id JOIN admin a ON br.admin_id = a.id "
                + "WHERE br.student_id = ? AND br.status IN ('ISSUED', 'OVERDUE') ORDER BY br.due_date ASC";
        return fetchBorrowList(sql, studentId);
    }

    public List<Borrow> findReturnedBorrowsByStudentId(int studentId) throws SQLException {
        String sql = "SELECT br.id, br.student_id, br.book_id, br.admin_id, br.issue_date, br.due_date, br.return_date, br.fine_amount, br.fine_paid, br.status, br.created_at, br.updated_at, "
                + "s.name AS student_name, s.roll_num AS student_roll_num, b.title AS book_title, a.name AS admin_name "
                + "FROM borrow br JOIN student s ON br.student_id = s.id JOIN book b ON br.book_id = b.id JOIN admin a ON br.admin_id = a.id "
                + "WHERE br.student_id = ? AND br.status = 'RETURNED' ORDER BY br.return_date DESC, br.created_at DESC";
        return fetchBorrowList(sql, studentId);
    }

    public List<Borrow> findActiveBorrows() throws SQLException {
        String sql = "SELECT br.id, br.student_id, br.book_id, br.admin_id, br.issue_date, br.due_date, br.return_date, CASE WHEN GREATEST(DATEDIFF(CURDATE(), br.due_date), 0) <= 2 THEN 0.00 WHEN GREATEST(DATEDIFF(CURDATE(), br.due_date), 0) BETWEEN 3 AND 7 THEN GREATEST(DATEDIFF(CURDATE(), br.due_date), 0) * 2 WHEN GREATEST(DATEDIFF(CURDATE(), br.due_date), 0) BETWEEN 8 AND 15 THEN GREATEST(DATEDIFF(CURDATE(), br.due_date), 0) * 5 ELSE GREATEST(DATEDIFF(CURDATE(), br.due_date), 0) * 10 END AS fine_amount, br.fine_paid, br.status, br.created_at, br.updated_at, s.name AS student_name, s.roll_num AS student_roll_num, b.title AS book_title, a.name AS admin_name FROM borrow br JOIN student s ON br.student_id = s.id JOIN book b ON br.book_id = b.id JOIN admin a ON br.admin_id = a.id WHERE br.status IN ('ISSUED', 'OVERDUE') ORDER BY br.due_date ASC";
        return fetchBorrowList(sql);
    }

    public Borrow findById(int id) throws SQLException {
        String sql = "SELECT br.id, br.student_id, br.book_id, br.admin_id, br.issue_date, br.due_date, br.return_date, br.fine_amount, br.fine_paid, br.status, br.created_at, br.updated_at, s.name AS student_name, s.roll_num AS student_roll_num, b.title AS book_title, a.name AS admin_name FROM borrow br JOIN student s ON br.student_id = s.id JOIN book b ON br.book_id = b.id JOIN admin a ON br.admin_id = a.id WHERE br.id = ?";

        try (Connection connection = DBConnection.getConnection();
                PreparedStatement statement = connection.prepareStatement(sql)) {
            statement.setInt(1, id);
            try (ResultSet resultSet = statement.executeQuery()) {
                if (resultSet.next()) {
                    return mapBorrow(resultSet);
                }
            }
        }
        return null;
    }

    public boolean issueBook(int studentId, int bookId, int adminId, LocalDate issueDate, LocalDate dueDate)
            throws SQLException {
        Connection connection = null;
        try {
            connection = DBConnection.getConnection();
            connection.setAutoCommit(false);

            int availableQuantity = 0;
            String stockSql = "SELECT available_quantity FROM book WHERE id = ? FOR UPDATE";
            try (PreparedStatement stockStatement = connection.prepareStatement(stockSql)) {
                stockStatement.setInt(1, bookId);
                try (ResultSet resultSet = stockStatement.executeQuery()) {
                    if (resultSet.next()) {
                        availableQuantity = resultSet.getInt(1);
                    } else {
                        throw new SQLException("Book not found.");
                    }
                }
            }

            if (availableQuantity <= 0) {
                throw new SQLException("Selected book is not available.");
            }

            String insertSql = "INSERT INTO borrow (student_id, book_id, admin_id, issue_date, due_date, fine_amount, fine_paid, status) VALUES (?, ?, ?, ?, ?, 0.00, FALSE, 'ISSUED')";
            try (PreparedStatement insertStatement = connection.prepareStatement(insertSql)) {
                insertStatement.setInt(1, studentId);
                insertStatement.setInt(2, bookId);
                insertStatement.setInt(3, adminId);
                insertStatement.setDate(4, java.sql.Date.valueOf(issueDate));
                insertStatement.setDate(5, java.sql.Date.valueOf(dueDate));
                insertStatement.executeUpdate();
            }

            String updateSql = "UPDATE book SET available_quantity = available_quantity - 1 WHERE id = ?";
            try (PreparedStatement updateStatement = connection.prepareStatement(updateSql)) {
                updateStatement.setInt(1, bookId);
                updateStatement.executeUpdate();
            }

            connection.commit();
            return true;
        } catch (SQLException exception) {
            if (connection != null) {
                connection.rollback();
            }
            throw exception;
        } finally {
            if (connection != null) {
                connection.setAutoCommit(true);
                connection.close();
            }
        }
    }

    public boolean returnBook(int borrowId, LocalDate returnDate, BigDecimal fineAmount, boolean finePaid, int adminId)
            throws SQLException {
        Connection connection = null;
        try {
            connection = DBConnection.getConnection();
            connection.setAutoCommit(false);

            int bookId;
            String borrowSql = "SELECT book_id, status FROM borrow WHERE id = ? FOR UPDATE";
            try (PreparedStatement borrowStatement = connection.prepareStatement(borrowSql)) {
                borrowStatement.setInt(1, borrowId);
                try (ResultSet resultSet = borrowStatement.executeQuery()) {
                    if (!resultSet.next()) {
                        throw new SQLException("Borrow record not found.");
                    }
                    String status = resultSet.getString("status");
                    if ("RETURNED".equalsIgnoreCase(status)) {
                        throw new SQLException("This book is already returned.");
                    }
                    bookId = resultSet.getInt("book_id");
                }
            }

            String updateBorrowSql = "UPDATE borrow SET return_date = ?, fine_amount = ?, fine_paid = ?, status = 'RETURNED', admin_id = ?, updated_at = CURRENT_TIMESTAMP WHERE id = ?";
            try (PreparedStatement statement = connection.prepareStatement(updateBorrowSql)) {
                statement.setDate(1, java.sql.Date.valueOf(returnDate));
                statement.setBigDecimal(2, fineAmount == null ? BigDecimal.ZERO : fineAmount);
                statement.setBoolean(3, finePaid);
                statement.setInt(4, adminId);
                statement.setInt(5, borrowId);
                statement.executeUpdate();
            }

            String updateBookSql = "UPDATE book SET available_quantity = available_quantity + 1 WHERE id = ?";
            try (PreparedStatement statement = connection.prepareStatement(updateBookSql)) {
                statement.setInt(1, bookId);
                statement.executeUpdate();
            }

            connection.commit();
            return true;
        } catch (SQLException exception) {
            if (connection != null) {
                connection.rollback();
            }
            throw exception;
        } finally {
            if (connection != null) {
                connection.setAutoCommit(true);
                connection.close();
            }
        }
    }

    private List<Borrow> fetchBorrowList(String sql, Object... params) throws SQLException {
        try (Connection connection = DBConnection.getConnection();
                PreparedStatement statement = connection.prepareStatement(sql)) {
            for (int index = 0; index < params.length; index++) {
                Object parameter = params[index];
                if (parameter instanceof Integer integer) {
                    statement.setInt(index + 1, integer);
                } else {
                    statement.setObject(index + 1, parameter);
                }
            }

            try (ResultSet resultSet = statement.executeQuery()) {
                List<Borrow> borrows = new ArrayList<>();
                while (resultSet.next()) {
                    borrows.add(mapBorrow(resultSet));
                }
                return borrows;
            }
        }
    }

    private Borrow mapBorrow(ResultSet resultSet) throws SQLException {
        Borrow borrow = new Borrow();
        borrow.setId(resultSet.getInt("id"));
        borrow.setStudentId(resultSet.getInt("student_id"));
        borrow.setBookId(resultSet.getInt("book_id"));
        borrow.setAdminId(resultSet.getInt("admin_id"));
        java.sql.Date issueDate = resultSet.getDate("issue_date");
        java.sql.Date dueDate = resultSet.getDate("due_date");
        java.sql.Date returnDate = resultSet.getDate("return_date");
        if (issueDate != null) {
            borrow.setIssueDate(issueDate.toLocalDate());
        }
        if (dueDate != null) {
            borrow.setDueDate(dueDate.toLocalDate());
        }
        if (returnDate != null) {
            borrow.setReturnDate(returnDate.toLocalDate());
        }
        borrow.setFineAmount(resultSet.getBigDecimal("fine_amount"));
        borrow.setFinePaid(resultSet.getBoolean("fine_paid"));
        borrow.setStatus(resultSet.getString("status"));
        java.sql.Timestamp createdAt = resultSet.getTimestamp("created_at");
        java.sql.Timestamp updatedAt = resultSet.getTimestamp("updated_at");
        if (createdAt != null) {
            borrow.setCreatedAt(createdAt.toLocalDateTime());
        }
        if (updatedAt != null) {
            borrow.setUpdatedAt(updatedAt.toLocalDateTime());
        }
        borrow.setStudentName(resultSet.getString("student_name"));
        borrow.setStudentRollNum(resultSet.getString("student_roll_num"));
        borrow.setBookTitle(resultSet.getString("book_title"));
        borrow.setAdminName(resultSet.getString("admin_name"));
        // DEBUG: log computed fine amount for troubleshooting
        try {
            java.math.BigDecimal dbg = resultSet.getBigDecimal("fine_amount");
            System.out.println("[DEBUG] Borrow id=" + borrow.getId() + " fine_amount=" + dbg);
        } catch (Exception ignore) {
        }
        return borrow;
    }
}
