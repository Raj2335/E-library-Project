package com.elibrary.dao;

import com.elibrary.model.Student;
import com.elibrary.util.DBConnection;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

public class StudentDao {
    public Student authenticate(String rollNum, String email) throws SQLException {
        String sql = "SELECT id, roll_num, name, dept, year, phone, email, created_at, updated_at FROM student WHERE roll_num = ? AND email = ?";

        try (Connection connection = DBConnection.getConnection();
                PreparedStatement statement = connection.prepareStatement(sql)) {
            statement.setString(1, rollNum);
            statement.setString(2, email);

            try (ResultSet resultSet = statement.executeQuery()) {
                if (resultSet.next()) {
                    return mapStudent(resultSet);
                }
            }
        }

        return null;
    }

    public int countStudents() throws SQLException {
        String sql = "SELECT COUNT(*) FROM student";

        try (Connection connection = DBConnection.getConnection();
                PreparedStatement statement = connection.prepareStatement(sql);
                ResultSet resultSet = statement.executeQuery()) {
            if (resultSet.next()) {
                return resultSet.getInt(1);
            }
            return 0;
        }
    }

    public Student findById(int id) throws SQLException {
        String sql = "SELECT id, roll_num, name, dept, year, phone, email, created_at, updated_at FROM student WHERE id = ?";

        try (Connection connection = DBConnection.getConnection();
                PreparedStatement statement = connection.prepareStatement(sql)) {
            statement.setInt(1, id);
            try (ResultSet resultSet = statement.executeQuery()) {
                if (resultSet.next()) {
                    return mapStudent(resultSet);
                }
            }
        }

        return null;
    }

    public List<Student> findAll() throws SQLException {
        return search(null);
    }

    public List<Student> search(String keyword) throws SQLException {
        StringBuilder sql = new StringBuilder(
                "SELECT id, roll_num, name, dept, year, phone, email, created_at, updated_at FROM student");
        boolean hasKeyword = keyword != null && !keyword.isBlank();
        if (hasKeyword) {
            sql.append(" WHERE roll_num LIKE ? OR name LIKE ? OR dept LIKE ? OR email LIKE ?");
        }
        sql.append(" ORDER BY id DESC");

        try (Connection connection = DBConnection.getConnection();
                PreparedStatement statement = connection.prepareStatement(sql.toString())) {
            if (hasKeyword) {
                String value = "%" + keyword.trim() + "%";
                statement.setString(1, value);
                statement.setString(2, value);
                statement.setString(3, value);
                statement.setString(4, value);
            }

            try (ResultSet resultSet = statement.executeQuery()) {
                List<Student> students = new ArrayList<>();
                while (resultSet.next()) {
                    students.add(mapStudent(resultSet));
                }
                return students;
            }
        }
    }

    public int insert(Student student) throws SQLException {
        String sql = "INSERT INTO student (roll_num, name, dept, year, phone, email) VALUES (?, ?, ?, ?, ?, ?)";

        try (Connection connection = DBConnection.getConnection();
                PreparedStatement statement = connection.prepareStatement(sql,
                        java.sql.Statement.RETURN_GENERATED_KEYS)) {
            statement.setString(1, student.getRollNum());
            statement.setString(2, student.getName());
            statement.setString(3, student.getDept());
            statement.setInt(4, student.getYear());
            statement.setString(5, student.getPhone());
            statement.setString(6, student.getEmail());
            statement.executeUpdate();

            try (ResultSet generatedKeys = statement.getGeneratedKeys()) {
                if (generatedKeys.next()) {
                    return generatedKeys.getInt(1);
                }
            }
        }

        throw new SQLException("Failed to create student.");
    }

    public boolean update(Student student) throws SQLException {
        String sql = "UPDATE student SET roll_num = ?, name = ?, dept = ?, year = ?, phone = ?, email = ? WHERE id = ?";

        try (Connection connection = DBConnection.getConnection();
                PreparedStatement statement = connection.prepareStatement(sql)) {
            statement.setString(1, student.getRollNum());
            statement.setString(2, student.getName());
            statement.setString(3, student.getDept());
            statement.setInt(4, student.getYear());
            statement.setString(5, student.getPhone());
            statement.setString(6, student.getEmail());
            statement.setInt(7, student.getId());
            return statement.executeUpdate() > 0;
        }
    }

    public boolean delete(int id) throws SQLException {
        String sql = "DELETE FROM student WHERE id = ?";

        try (Connection connection = DBConnection.getConnection();
                PreparedStatement statement = connection.prepareStatement(sql)) {
            statement.setInt(1, id);
            return statement.executeUpdate() > 0;
        }
    }

    private Student mapStudent(ResultSet resultSet) throws SQLException {
        Student student = new Student();
        student.setId(resultSet.getInt("id"));
        student.setRollNum(resultSet.getString("roll_num"));
        student.setName(resultSet.getString("name"));
        student.setDept(resultSet.getString("dept"));
        student.setYear(resultSet.getInt("year"));
        student.setPhone(resultSet.getString("phone"));
        student.setEmail(resultSet.getString("email"));
        java.sql.Timestamp createdAt = resultSet.getTimestamp("created_at");
        java.sql.Timestamp updatedAt = resultSet.getTimestamp("updated_at");
        if (createdAt != null) {
            student.setCreatedAt(createdAt.toLocalDateTime());
        }
        if (updatedAt != null) {
            student.setUpdatedAt(updatedAt.toLocalDateTime());
        }
        return student;
    }
}
