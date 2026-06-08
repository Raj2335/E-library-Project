package com.elibrary.dao;

import com.elibrary.model.Book;
import com.elibrary.util.DBConnection;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

public class BookDAO {
    public int countBooks() throws SQLException {
        return count("SELECT COUNT(*) FROM book");
    }

    public int countAvailableBooks() throws SQLException {
        return count("SELECT COALESCE(SUM(available_quantity), 0) FROM book");
    }

    public int countIssuedBooks() throws SQLException {
        return count("SELECT COUNT(*) FROM borrow WHERE status IN ('ISSUED', 'OVERDUE')");
    }

    public List<Book> findAll() throws SQLException {
        return search(null);
    }

    public List<Book> search(String keyword) throws SQLException {
        StringBuilder sql = new StringBuilder(
                "SELECT id, title, author, isbn, category, publisher, total_quantity, available_quantity, shelf_location, cover_image, created_by, updated_by, created_at, updated_at FROM book");
        boolean hasKeyword = keyword != null && !keyword.isBlank();
        if (hasKeyword) {
            sql.append(
                    " WHERE title LIKE ? OR author LIKE ? OR isbn LIKE ? OR category LIKE ? OR publisher LIKE ? OR shelf_location LIKE ?");
        }
        sql.append(" ORDER BY id DESC");

        try (Connection connection = DBConnection.getConnection();
                PreparedStatement statement = connection.prepareStatement(sql.toString())) {
            if (hasKeyword) {
                String value = "%" + keyword.trim() + "%";
                for (int index = 1; index <= 6; index++) {
                    statement.setString(index, value);
                }
            }

            try (ResultSet resultSet = statement.executeQuery()) {
                List<Book> books = new ArrayList<>();
                while (resultSet.next()) {
                    books.add(mapBook(resultSet));
                }
                return books;
            }
        }
    }

    public Book findById(int id) throws SQLException {
        String sql = "SELECT id, title, author, isbn, category, publisher, total_quantity, available_quantity, shelf_location, cover_image, created_by, updated_by, created_at, updated_at FROM book WHERE id = ?";

        try (Connection connection = DBConnection.getConnection();
                PreparedStatement statement = connection.prepareStatement(sql)) {
            statement.setInt(1, id);
            try (ResultSet resultSet = statement.executeQuery()) {
                if (resultSet.next()) {
                    return mapBook(resultSet);
                }
            }
        }

        return null;
    }

    public int insert(Book book) throws SQLException {
        String sql = "INSERT INTO book (title, author, isbn, category, publisher, total_quantity, available_quantity, shelf_location, cover_image, created_by, updated_by) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";

        try (Connection connection = DBConnection.getConnection();
                PreparedStatement statement = connection.prepareStatement(sql,
                        java.sql.Statement.RETURN_GENERATED_KEYS)) {
            statement.setString(1, book.getTitle());
            statement.setString(2, book.getAuthor());
            statement.setString(3, book.getIsbn());
            statement.setString(4, book.getCategory());
            statement.setString(5, book.getPublisher());
            statement.setInt(6, book.getTotalQuantity());
            statement.setInt(7, book.getAvailableQuantity());
            statement.setString(8, book.getShelfLocation());
            statement.setString(9, book.getCoverImage());
            statement.setInt(10, book.getCreatedBy());
            statement.setObject(11, book.getUpdatedBy());
            statement.executeUpdate();

            try (ResultSet generatedKeys = statement.getGeneratedKeys()) {
                if (generatedKeys.next()) {
                    return generatedKeys.getInt(1);
                }
            }
        }

        throw new SQLException("Failed to create book.");
    }

    public boolean update(Book book) throws SQLException {
        String sql = "UPDATE book SET title = ?, author = ?, isbn = ?, category = ?, publisher = ?, total_quantity = ?, available_quantity = ?, shelf_location = ?, cover_image = ?, updated_by = ? WHERE id = ?";

        try (Connection connection = DBConnection.getConnection();
                PreparedStatement statement = connection.prepareStatement(sql)) {
            statement.setString(1, book.getTitle());
            statement.setString(2, book.getAuthor());
            statement.setString(3, book.getIsbn());
            statement.setString(4, book.getCategory());
            statement.setString(5, book.getPublisher());
            statement.setInt(6, book.getTotalQuantity());
            statement.setInt(7, book.getAvailableQuantity());
            statement.setString(8, book.getShelfLocation());
            statement.setString(9, book.getCoverImage());
            statement.setObject(10, book.getUpdatedBy());
            statement.setInt(11, book.getId());
            return statement.executeUpdate() > 0;
        }
    }

    public boolean delete(int id) throws SQLException {
        String sql = "DELETE FROM book WHERE id = ?";

        try (Connection connection = DBConnection.getConnection();
                PreparedStatement statement = connection.prepareStatement(sql)) {
            statement.setInt(1, id);
            return statement.executeUpdate() > 0;
        }
    }

    private int count(String sql) throws SQLException {
        try (Connection connection = DBConnection.getConnection();
                PreparedStatement statement = connection.prepareStatement(sql);
                ResultSet resultSet = statement.executeQuery()) {
            if (resultSet.next()) {
                return resultSet.getInt(1);
            }
            return 0;
        }
    }

    private Book mapBook(ResultSet resultSet) throws SQLException {
        Book book = new Book();
        book.setId(resultSet.getInt("id"));
        book.setTitle(resultSet.getString("title"));
        book.setAuthor(resultSet.getString("author"));
        book.setIsbn(resultSet.getString("isbn"));
        book.setCategory(resultSet.getString("category"));
        book.setPublisher(resultSet.getString("publisher"));
        book.setTotalQuantity(resultSet.getInt("total_quantity"));
        book.setAvailableQuantity(resultSet.getInt("available_quantity"));
        book.setShelfLocation(resultSet.getString("shelf_location"));
        book.setCoverImage(resultSet.getString("cover_image"));
        book.setCreatedBy((Integer) resultSet.getObject("created_by"));
        book.setUpdatedBy((Integer) resultSet.getObject("updated_by"));
        java.sql.Timestamp createdAt = resultSet.getTimestamp("created_at");
        java.sql.Timestamp updatedAt = resultSet.getTimestamp("updated_at");
        if (createdAt != null) {
            book.setCreatedAt(createdAt.toLocalDateTime());
        }
        if (updatedAt != null) {
            book.setUpdatedAt(updatedAt.toLocalDateTime());
        }
        return book;
    }
}
