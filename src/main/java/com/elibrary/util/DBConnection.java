package com.elibrary.util;

import java.io.IOException;
import java.io.InputStream;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;
import java.util.Properties;

public final class DBConnection {
    private static final String PROPERTIES_FILE = "application.properties";
    private static final Properties PROPERTIES = loadProperties();

    static {
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
        } catch (ClassNotFoundException exception) {
            throw new IllegalStateException("MySQL JDBC driver not found on the classpath.", exception);
        }
    }

    private DBConnection() {
    }

    public static Connection getConnection() throws SQLException {
        return DriverManager.getConnection(getUrl(), getUser(), getPassword());
    }

    private static String getUrl() {
        return getValue("DB_URL", "db.url");
    }

    private static String getUser() {
        return getValue("DB_USER", "db.user");
    }

    private static String getPassword() {
        return getValue("DB_PASSWORD", "db.password");
    }

    private static String getValue(String envKey, String propertyKey) {
        String envValue = System.getenv(envKey);
        if (envValue != null && !envValue.isBlank()) {
            return envValue;
        }

        String propertyValue = PROPERTIES.getProperty(propertyKey);
        if (propertyValue == null || propertyValue.isBlank()) {
            throw new IllegalStateException("Missing database property: " + propertyKey);
        }

        return propertyValue;
    }

    private static Properties loadProperties() {
        Properties properties = new Properties();

        try (InputStream inputStream = DBConnection.class.getClassLoader().getResourceAsStream(PROPERTIES_FILE)) {
            if (inputStream == null) {
                throw new IllegalStateException("application.properties not found in resources.");
            }
            properties.load(inputStream);
            return properties;
        } catch (IOException exception) {
            throw new IllegalStateException("Failed to load database configuration.", exception);
        }
    }
}
