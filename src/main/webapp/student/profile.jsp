<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
        <!DOCTYPE html>
        <html lang="en">

        <head>
            <meta charset="UTF-8" />
            <meta name="viewport" content="width=device-width, initial-scale=1.0" />
            <title>Student Profile</title>
            <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
            <link href="${pageContext.request.contextPath}/assets/css/style.css" rel="stylesheet">
        </head>

        <body>
            <nav class="navbar navbar-expand-lg navbar-dark bg-dark">
                <div class="container-fluid">
                    <a class="navbar-brand fw-bold"
                        href="${pageContext.request.contextPath}/student/dashboard">E-Library Student</a>
                    <div class="ms-auto">
                        <a class="btn btn-outline-light btn-sm me-2"
                            href="${pageContext.request.contextPath}/student/dashboard">Dashboard</a>
                        <a class="btn btn-outline-light btn-sm"
                            href="${pageContext.request.contextPath}/logout">Logout</a>
                    </div>
                </div>
            </nav>

            <div class="container py-4">
                <div class="row justify-content-center">
                    <div class="col-lg-8">
                        <div class="card form-card p-4">
                            <div class="d-flex justify-content-between align-items-start mb-3">
                                <div>
                                    <span class="badge text-bg-primary brand-pill">Student Profile</span>
                                    <h2 class="fw-bold mt-2 mb-0">${profile.name}</h2>
                                    <p class="text-muted mb-0">Your registered student details.</p>
                                    <c:choose>
                                        <c:when test="${totalPending > 0}">
                                            <p class="text-danger fw-semibold mt-2 mb-0">Total Pending Fines: ₹
                                                <c:out value="${totalPending}" default="0.00" />
                                            </p>
                                        </c:when>
                                    </c:choose>
                                </div>
                            </div>

                            <div class="row g-3">
                                <div class="col-md-6">
                                    <div class="p-3 bg-light rounded-3"><small class="text-muted">Roll Number</small>
                                        <div class="fw-semibold">${profile.rollNum}</div>
                                    </div>
                                </div>
                                <div class="col-md-6">
                                    <div class="p-3 bg-light rounded-3"><small class="text-muted">Department</small>
                                        <div class="fw-semibold">${profile.dept}</div>
                                    </div>
                                </div>
                                <div class="col-md-6">
                                    <div class="p-3 bg-light rounded-3"><small class="text-muted">Year</small>
                                        <div class="fw-semibold">${profile.year}</div>
                                    </div>
                                </div>
                                <div class="col-md-6">
                                    <div class="p-3 bg-light rounded-3"><small class="text-muted">Phone</small>
                                        <div class="fw-semibold">${profile.phone}</div>
                                    </div>
                                </div>
                                <div class="col-12">
                                    <div class="p-3 bg-light rounded-3"><small class="text-muted">Email</small>
                                        <div class="fw-semibold">${profile.email}</div>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>

            <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
        </body>

        </html>