# Run instructions — E-Library

This document explains how to build, configure, and run the E-Library web application locally (Tomcat + MySQL).

## 1. Introduction

E-Library is a web-based library management application designed to help users manage books, members, and circulation activities through a browser-based interface. The project is implemented as a Java web application and is intended to run on Tomcat with a MySQL database backend.

### 1.1 Project Overview

The application provides separate areas for administrators and students. Administrators can manage books, students, issued items, returns, and fines, while students can browse the catalog, view their dashboard, and check related account information.

### 1.2 Objectives

The main objectives of the project are to simplify library operations, reduce manual record keeping, and provide a centralized system for tracking book availability, borrowing activity, and student access to library services.

### 1.3 Scope of the Project

The scope of the project covers local deployment, database-backed library management, authentication, catalog browsing, issue and return workflows, and fine tracking. It does not include cloud hosting, mobile clients, or third-party integrations beyond the local MySQL and Tomcat setup described below.

## Prerequisites

- Java JDK 17+ installed and `JAVA_HOME` set.
- Maven 3.6+ installed.
- MySQL 8+ server running and accessible.
- Local Tomcat 9 (optional) — deployment examples use the bundled Tomcat under `Tomcat 9.0_Tomcat`.

## Important files

- Application properties: src/main/resources/application.properties
- Database schema + seeds: db/schema.sql

## Database setup

1. Create the database and user (example):

```powershell
mysql -u root -p
CREATE DATABASE elibrary CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci;
USE elibrary;
SOURCE db/schema.sql;
EXIT;
```

2. Verify tables are created:

```powershell
mysql -u root -p -D elibrary -e "SHOW TABLES;"
```

3. If you need to change connection details, edit `src/main/resources/application.properties` and update `db.url`, `db.user`, and `db.password`.

## Build the WAR

From the project root run:

```powershell
mvn -DskipTests package
```

The built WAR will be at `target/elibrary.war`.

## Deploy to Tomcat (example using the included runtime)

1. Set `CATALINA_HOME` for the current PowerShell session (adjust path if yours differs):

```powershell
$env:CATALINA_HOME = 'C:\Users\omen\Desktop\E library\Tomcat 9.0_Tomcat'
```

2. Copy the WAR to Tomcat `webapps` and restart Tomcat:

```powershell
$env:CATALINA_HOME = "C:\Users\omen\Desktop\E library\Tomcat 9.0_Tomcat"
Copy-Item -Force target\elibrary.war "$env:CATALINA_HOME\webapps\ROOT.war"
& "$env:CATALINA_HOME\bin\shutdown.bat"
& "$env:CATALINA_HOME\bin\startup.bat"
```

Notes:

- `CATALINA_HOME` must point to the Tomcat installation root (the folder that contains `bin\catalina.bat`).
- If Tomcat is already running you can just copy the WAR; Tomcat will auto-deploy it.

## Access the app

Open in browser:

```
http://localhost:8081/elibrary/
```

Common pages:

- Login: `/elibrary/login.jsp`
- Student catalog: `/elibrary/student/books`

## Seed data

The repository includes `db/schema.sql` with example admin, students and sample books. Running the `SOURCE db/schema.sql;` command (see above) will insert the demo rows.

## Troubleshooting

- If Tomcat fails to start: ensure `CATALINA_HOME` is correct and `JAVA_HOME` points to a compatible JDK.
- If you see DB connection errors: confirm the credentials in `src/main/resources/application.properties` and that MySQL accepts connections from localhost.
- If duplicate servlet or class errors occur during deployment: ensure there are no duplicate classes in `target/classes` or multiple WARs with the same context name in `webapps`.

## Quick commands summary

```powershell
# Build
mvn -DskipTests package

# Deploy (example)
$env:CATALINA_HOME='C:\Users\omen\Desktop\E library\Tomcat 9.0_Tomcat'
if (!(Test-Path "$env:CATALINA_HOME\bin\startup.bat")) { throw "Invalid CATALINA_HOME: $env:CATALINA_HOME" }
Copy-Item -Force target\elibrary.war "$env:CATALINA_HOME\webapps\"
if (Test-Path "$env:CATALINA_HOME\bin\shutdown.bat") { & "$env:CATALINA_HOME\bin\shutdown.bat" }
& "$env:CATALINA_HOME\bin\startup.bat"
```

---

If you'd like, I can:

- automatically run the build and redeploy now,
- or run a browser check (Playwright) to confirm the preloader and student catalog are visible.
