package com.elibrary.dao;

import com.elibrary.model.Admin;
import com.elibrary.util.DBConnection;
import com.elibrary.util.PasswordUtil;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

public class AdminDAO {
    public Admin authenticate(String email, String password) throws SQLException {
        String sql = "SELECT id, name, email, password, created_at, updated_at FROM admin WHERE email = ?";

        try (Connection connection = DBConnection.getConnection();
                PreparedStatement statement = connection.prepareStatement(sql)) {
            statement.setString(1, email);

            try (ResultSet resultSet = statement.executeQuery()) {
                if (resultSet.next()) {
                    String storedPassword = resultSet.getString("password");
                    if (PasswordUtil.matches(password, storedPassword)) {
                        return mapAdmin(resultSet);
                    }
                }
            }
        }

        return null;
    }

    public Admin findById(int id) throws SQLException {
        String sql = "SELECT id, name, email, password, created_at, updated_at FROM admin WHERE id = ?";

        try (Connection connection = DBConnection.getConnection();
                PreparedStatement statement = connection.prepareStatement(sql)) {
            statement.setInt(1, id);
            try (ResultSet resultSet = statement.executeQuery()) {
                if (resultSet.next()) {
                    return mapAdmin(resultSet);
                }
            }
        }

        return null;
    }

    public int countAdmins() throws SQLException {
        return count("SELECT COUNT(*) FROM admin");
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

    private Admin mapAdmin(ResultSet resultSet) throws SQLException {
        Admin admin = new Admin();
        admin.setId(resultSet.getInt("id"));
        admin.setName(resultSet.getString("name"));
        admin.setEmail(resultSet.getString("email"));
        java.sql.Timestamp createdAt = resultSet.getTimestamp("created_at");
        java.sql.Timestamp updatedAt = resultSet.getTimestamp("updated_at");
        if (createdAt != null) {
            admin.setCreatedAt(createdAt.toLocalDateTime());
        }
        if (updatedAt != null) {
            admin.setUpdatedAt(updatedAt.toLocalDateTime());
        }
        return admin;
    }
}
