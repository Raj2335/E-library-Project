<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
        <!DOCTYPE html>
        <html lang="en">

        <head>
            <meta charset="UTF-8" />
            <meta name="viewport" content="width=device-width, initial-scale=1.0" />
            <title>Student Management</title>
            <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
            <link href="${pageContext.request.contextPath}/assets/css/style.css" rel="stylesheet">
        </head>

        <body>
            <nav class="navbar navbar-expand-lg navbar-dark bg-dark">
                <div class="container-fluid">
                    <a class="navbar-brand fw-bold" href="${pageContext.request.contextPath}/admin/dashboard">E-Library
                        Admin</a>
                    <div class="ms-auto">
                        <a class="btn btn-outline-light btn-sm me-2"
                            href="${pageContext.request.contextPath}/admin/dashboard">Dashboard</a>
                        <a class="btn btn-outline-light btn-sm"
                            href="${pageContext.request.contextPath}/logout">Logout</a>
                    </div>
                </div>
            </nav>

            <div class="container py-4">
                <div class="row g-4">
                    <div class="col-lg-5">
                        <div class="card form-card p-4">
                            <h4 class="fw-bold mb-3">
                                <c:choose>
                                    <c:when test="${not empty studentToEdit}">Edit Student</c:when>
                                    <c:otherwise>Add Student</c:otherwise>
                                </c:choose>
                            </h4>
                            <form action="${pageContext.request.contextPath}/admin/students" method="post"
                                class="row g-3">
                                <input type="hidden" name="id" value="${studentToEdit.id}" />
                                <input type="hidden" name="action" value="save" />
                                <div class="col-md-6">
                                    <label class="form-label">Roll Number</label>
                                    <input type="text" class="form-control" name="rollNum"
                                        value="${studentToEdit.rollNum}" required>
                                </div>
                                <div class="col-md-6">
                                    <label class="form-label">Year</label>
                                    <input type="number" class="form-control" name="year"
                                        value="${empty studentToEdit ? 1 : studentToEdit.year}" min="1" required>
                                </div>
                                <div class="col-12">
                                    <label class="form-label">Name</label>
                                    <input type="text" class="form-control" name="name" value="${studentToEdit.name}"
                                        required>
                                </div>
                                <div class="col-md-6">
                                    <label class="form-label">Department</label>
                                    <input type="text" class="form-control" name="dept" value="${studentToEdit.dept}"
                                        required>
                                </div>
                                <div class="col-md-6">
                                    <label class="form-label">Phone</label>
                                    <input type="text" class="form-control" name="phone" value="${studentToEdit.phone}">
                                </div>
                                <div class="col-12">
                                    <label class="form-label">Email</label>
                                    <input type="email" class="form-control" name="email" value="${studentToEdit.email}"
                                        required>
                                </div>
                                <div class="col-12 d-flex gap-2">
                                    <button type="submit" class="btn btn-primary">Save</button>
                                    <a href="${pageContext.request.contextPath}/admin/students"
                                        class="btn btn-outline-secondary">Reset</a>
                                </div>
                            </form>
                        </div>
                    </div>

                    <div class="col-lg-7">
                        <div class="card table-card p-4">
                            <div class="d-flex justify-content-between align-items-center mb-3">
                                <h4 class="fw-bold mb-0">Students</h4>
                                <form class="d-flex" method="get"
                                    action="${pageContext.request.contextPath}/admin/students">
                                    <input type="search" class="form-control form-control-sm me-2" name="q"
                                        value="${param.q}" placeholder="Search students">
                                    <button class="btn btn-sm btn-outline-primary">Search</button>
                                </form>
                            </div>
                            <div class="table-responsive">
                                <table class="table align-middle">
                                    <thead>
                                        <tr>
                                            <th>Roll</th>
                                            <th>Name</th>
                                            <th>Dept</th>
                                            <th>Year</th>
                                            <th>Contact</th>
                                            <th>Actions</th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <c:forEach var="student" items="${students}">
                                            <tr>
                                                <td>${student.rollNum}</td>
                                                <td>${student.name}</td>
                                                <td>${student.dept}</td>
                                                <td>${student.year}</td>
                                                <td>${student.email}</td>
                                                <td>
                                                    <a class="btn btn-sm btn-outline-primary"
                                                        href="${pageContext.request.contextPath}/admin/students?action=edit&id=${student.id}">Edit</a>
                                                    <form action="${pageContext.request.contextPath}/admin/students"
                                                        method="post" class="d-inline"
                                                        onsubmit="return confirm('Delete this student?')">
                                                        <input type="hidden" name="action" value="delete" />
                                                        <input type="hidden" name="id" value="${student.id}" />
                                                        <button class="btn btn-sm btn-outline-danger"
                                                            type="submit">Delete</button>
                                                    </form>
                                                </td>
                                            </tr>
                                        </c:forEach>
                                        <c:if test="${empty students}">
                                            <tr>
                                                <td colspan="6" class="text-center text-muted py-4">No students found.
                                                </td>
                                            </tr>
                                        </c:if>
                                    </tbody>
                                </table>
                            </div>
                        </div>
                    </div>
                </div>
            </div>

            <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
        </body>

        </html>