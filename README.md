# E-Library

A Java web application for managing a library system with separate admin and student workflows. The project is built with Java 17, Maven, MySQL, and a Java Servlet/JSP stack, and is intended to run on Apache Tomcat.

## Features

- Admin dashboard for library operations
- Student dashboard and profile management
- Book management
- Student management
- Issue and return tracking
- Fine calculation and tracking
- Login flow for different user roles
- MySQL-backed persistence
- JSP-based UI

## Tech Stack

- Java 17
- Maven
- Servlet API 4.0.1
- JSP / JSTL
- MySQL Connector/J 8.4
- Apache Tomcat 9

## Project Structure

```text
E library/
├── db/
│   └── schema.sql
├── src/
│   ├── main/
│   │   ├── java/
│   │   ├── resources/
│   │   └── webapp/
│   └── test/
├── target/
├── Tomcat 9.0_Tomcat/
├── pom.xml
├── README.md
├── README_RUN.md
├── startup.bat
├── stop.bat
└── .gitignore
```

## Prerequisites

Before running the project, make sure you have:

- JDK 17 or newer
- Maven 3.6+
- MySQL 8+
- Apache Tomcat 9
- A configured MySQL database named `elibrary`

## Database Setup

1. Create the database:

```sql
CREATE DATABASE elibrary CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci;
```

2. Import the schema:

```bash
mysql -u root -p elibrary < db/schema.sql
```

3. Verify the tables:

```bash
mysql -u root -p -D elibrary -e "SHOW TABLES;"
```

## Configuration

The application uses `src/main/resources/application.properties` for database settings.

Example:

```properties
db.url=jdbc:mysql://localhost:3306/elibrary
db.user=root
db.password=your_password
```

You can override the username and password using environment variables if desired:

```bash
set DB_USER=root
set DB_PASSWORD=your_password
```

## Build

From the project root, run:

```bash
mvn clean package
```

This generates the WAR file in the `target` directory.

## Run with Tomcat

### Option 1: Deploy the generated WAR

```bash
copy target\elibrary.war "C:\path\to\Tomcat 9.0_Tomcat\webapps\"
```

Then start Tomcat:

```bash
"C:\path\to\Tomcat 9.0_Tomcat\bin\startup.bat"
```

### Option 2: Use the project's startup script

```bash
startup.bat
```

## Access the Application

Open the following URL in your browser:

```text
http://localhost:8081/elibrary/
```

Common routes include:

- Login page: `/elibrary/login.jsp`
- Student books: `/elibrary/student/books`
- Admin dashboard: `/elibrary/admin/dashboard.jsp`

## Default Admin Credentials

The schema may create default records for the application. Check the SQL script in `db/schema.sql` if you need to confirm the initial admin or student credentials.

## Troubleshooting

### Database connection issues

- Confirm MySQL is running.
- Verify `db.url`, `db.user`, and `db.password` in `src/main/resources/application.properties`.
- Ensure the `elibrary` database exists and the schema was imported successfully.

### Tomcat fails to start

- Confirm `JAVA_HOME` is set correctly.
- Check that the Tomcat path is valid.
- Review logs under the Tomcat `logs` directory.

### Deployment issues

- Remove stale deployments from `Tomcat/webapps` if needed.
- Ensure only one version of the application is deployed.
- Clean the project before rebuilding:

```bash
mvn clean package
```

## Notes

This project is intended for local development and learning use. It is not a production-ready deployment configuration by default. For production environments, use stronger secrets management, environment-based configuration, and hardened database access settings.

## License

This project does not currently declare a formal license. If you are using it in a team or production environment, confirm the licensing requirements before sharing or deploying it publicly.
