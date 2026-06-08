package com.elibrary.config;

import java.io.IOException;
import java.io.InputStream;
import java.util.Properties;

public final class DatabaseConfig {
    private static final String PROPERTIES_FILE = "application.properties";
    private static final Properties PROPERTIES = loadProperties();

    private DatabaseConfig() {
    }

    public static String getUrl() {
        return readValue("DB_URL", "db.url");
    }

    public static String getUser() {
        return readValue("DB_USER", "db.user");
    }

    public static String getPassword() {
        return readValue("DB_PASSWORD", "db.password");
    }

    private static String readValue(String envKey, String propKey) {
        String envValue = System.getenv(envKey);
        if (envValue != null && !envValue.isBlank()) {
            return envValue;
        }

        String propValue = PROPERTIES.getProperty(propKey);
        if (propValue == null || propValue.isBlank()) {
            throw new IllegalStateException("Missing DB config value for " + propKey);
        }

        return propValue;
    }

    private static Properties loadProperties() {
        Properties properties = new Properties();

        try (InputStream input = DatabaseConfig.class.getClassLoader().getResourceAsStream(PROPERTIES_FILE)) {
            if (input == null) {
                throw new IllegalStateException("application.properties not found in resources.");
            }
            properties.load(input);
            return properties;
        } catch (IOException ex) {
            throw new IllegalStateException("Failed to read application.properties", ex);
        }
    }
}
