<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
        <!DOCTYPE html>
        <html lang="en">

        <head>
            <meta charset="UTF-8" />
            <meta name="viewport" content="width=device-width, initial-scale=1.0" />
            <title>E-Library Login</title>
            <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
            <link href="${pageContext.request.contextPath}/assets/css/style.css" rel="stylesheet">
        </head>

        <body class="auth-page app-page">
            <!-- Preloader -->
            <div id="preloader-overlay">
                <div class="preloader-card">
                    <div class="preloader-spinner"></div>
                    <div class="preloader-title">E-Library</div>
                    <div class="preloader-sub">Loading the smartest library experience...</div>
                </div>
            </div>
            <div class="container py-5">
                <div class="row justify-content-center align-items-center min-vh-100">
                    <div class="col-lg-10">
                        <div class="card border-0 shadow-lg overflow-hidden auth-card">
                            <div class="row g-0">
                                <div
                                    class="col-md-5 auth-side p-5 text-white d-flex flex-column justify-content-between">
                                    <div>
                                        <span class="badge text-bg-light text-dark mb-3">E-Library Management
                                            System</span>
                                        <h1 class="fw-bold mb-3">Smart library control for admin and students.</h1>
                                        <p class="opacity-75">Manage books, students, borrow cycles, and dashboards in
                                            one MVC web app.</p>
                                    </div>
                                    <small class="opacity-75">JSP + Servlets + JDBC + MySQL 8 + Tomcat 9</small>
                                </div>
                                <div class="col-md-7 p-5 bg-white">
                                    <h2 class="fw-bold mb-1">Sign in</h2>
                                    <p class="text-muted mb-4">Choose your role and continue.</p>

                                    <c:if test="${not empty errorMessage}">
                                        <div class="alert alert-danger">${errorMessage}</div>
                                    </c:if>

                                    <form action="${pageContext.request.contextPath}/auth" method="post" id="loginForm"
                                        class="vstack gap-3">
                                        <div>
                                            <label class="form-label">Login as</label>
                                            <select class="form-select" name="role" id="roleSelect"
                                                onchange="toggleLoginFields()" required>
                                                <option value="ADMIN">Admin</option>
                                                <option value="STUDENT">Student</option>
                                            </select>
                                        </div>

                                        <div id="adminFields">
                                            <label class="form-label">Admin Email</label>
                                            <input type="email" class="form-control" name="email"
                                                placeholder="admin@example.com">
                                        </div>

                                        <div id="adminPasswordField">
                                            <label class="form-label">Password</label>
                                            <input type="password" class="form-control" name="password"
                                                placeholder="Enter password">
                                        </div>

                                        <div id="studentFields" style="display: none;">
                                            <div class="mb-3">
                                                <label class="form-label">Roll Number</label>
                                                <input type="text" class="form-control" name="rollNum"
                                                    placeholder="2024CSE001">
                                            </div>
                                            <div>
                                                <label class="form-label">Student Email</label>
                                                <input type="email" class="form-control" name="studentEmail"
                                                    placeholder="student@example.com">
                                            </div>
                                        </div>

                                        <button type="submit" class="btn btn-primary btn-lg">Login</button>
                                        <p class="text-muted small mb-0">Student login uses roll number + email because
                                            the current schema has no student password field.</p>
                                    </form>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>

            <script>
                function toggleLoginFields() {
                    const role = document.getElementById('roleSelect').value;
                    const adminFields = document.getElementById('adminFields');
                    const adminPasswordField = document.getElementById('adminPasswordField');
                    const studentFields = document.getElementById('studentFields');

                    if (role === 'STUDENT') {
                        adminFields.style.display = 'none';
                        adminPasswordField.style.display = 'none';
                        studentFields.style.display = 'block';
                    } else {
                        adminFields.style.display = 'block';
                        adminPasswordField.style.display = 'block';
                        studentFields.style.display = 'none';
                    }
                }

                document.addEventListener('DOMContentLoaded', toggleLoginFields);
            </script>
            <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
            <script src="${pageContext.request.contextPath}/assets/js/preloader.js"></script>
        </body>

        </html>