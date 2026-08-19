<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
        <!DOCTYPE html>
        <html lang="en">

        <head>
            <meta charset="UTF-8" />
            <meta name="viewport" content="width=device-width, initial-scale=1.0" />
            <title>Admin Dashboard</title>
            <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
            <link href="${pageContext.request.contextPath}/assets/css/style.css" rel="stylesheet">
        </head>

        <body class="app-page">
            <nav class="navbar navbar-expand-lg navbar-dark bg-dark">
                <div class="container-fluid">
                    <a class="navbar-brand fw-bold" href="${pageContext.request.contextPath}/admin/dashboard">E-Library
                        Admin</a>
                    <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navAdmin">
                        <span class="navbar-toggler-icon"></span>
                    </button>
                    <div class="collapse navbar-collapse" id="navAdmin">
                        <ul class="navbar-nav ms-auto">
                            <li class="nav-item"><a class="nav-link active"
                                    href="${pageContext.request.contextPath}/admin/dashboard">Dashboard</a></li>
                            <li class="nav-item"><a class="nav-link"
                                    href="${pageContext.request.contextPath}/admin/books">Books</a></li>
                            <li class="nav-item"><a class="nav-link"
                                    href="${pageContext.request.contextPath}/admin/students">Students</a></li>
                            <li class="nav-item"><a class="nav-link"
                                    href="${pageContext.request.contextPath}/admin/issue-book">Issue Book</a></li>
                            <li class="nav-item"><a class="nav-link"
                                    href="${pageContext.request.contextPath}/admin/return-book">Return Book</a></li>
                            <li class="nav-item"><a class="nav-link"
                                    href="${pageContext.request.contextPath}/logout">Logout</a></li>
                        </ul>
                    </div>
                </div>
            </nav>

            <div class="container py-4">
                <c:if test="${not empty sessionScope.flashMessage}">
                    <div class="alert alert-success">${sessionScope.flashMessage}</div>
                </c:if>

                <div class="page-header mb-4">
                    <span class="badge text-bg-primary brand-pill">Admin Overview</span>
                    <h1 class="fw-bold mt-2 mb-1">Dashboard</h1>
                    <p class="text-muted">Track catalog size, active borrowing, and the most recent circulation
                        activity.</p>
                </div>

                <div class="row g-4 mb-4">
                    <div class="col-md-3">
                        <div class="card stat-card p-3">
                            <div class="d-flex align-items-center gap-3">
                                <div class="stat-icon bg-gradient-blue">B</div>
                                <div>
                                    <div class="text-muted small">Total Books</div>
                                    <div class="fs-3 fw-bold">${totalBooks}</div>
                                </div>
                            </div>
                        </div>
                    </div>
                    <div class="col-md-3">
                        <div class="card stat-card p-3">
                            <div class="d-flex align-items-center gap-3">
                                <div class="stat-icon bg-gradient-green">S</div>
                                <div>
                                    <div class="text-muted small">Total Students</div>
                                    <div class="fs-3 fw-bold">${totalStudents}</div>
                                </div>
                            </div>
                        </div>
                    </div>
                    <div class="col-md-3">
                        <div class="card stat-card p-3">
                            <div class="d-flex align-items-center gap-3">
                                <div class="stat-icon bg-gradient-orange">I</div>
                                <div>
                                    <div class="text-muted small">Total Issued Books</div>
                                    <div class="fs-3 fw-bold">${totalIssuedBooks}</div>
                                </div>
                            </div>
                        </div>
                    </div>
                    <div class="col-md-3">
                        <div class="card stat-card p-3">
                            <div class="d-flex align-items-center gap-3">
                                <div class="stat-icon bg-gradient-slate">A</div>
                                <div>
                                    <div class="text-muted small">Available Books</div>
                                    <div class="fs-3 fw-bold">${totalAvailableBooks}</div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>

                <div class="card table-card p-4">
                    <div class="d-flex justify-content-between align-items-center mb-3">
                        <div>
                            <h4 class="fw-bold mb-0">Recent Borrow Activities</h4>
                            <small class="text-muted">Latest circulation events from the borrow table.</small>
                        </div>
                    </div>
                    <div class="table-responsive">
                        <table class="table align-middle">
                            <thead>
                                <tr>
                                    <th>Student</th>
                                    <th>Book</th>
                                    <th>Admin</th>
                                    <th>Issue Date</th>
                                    <th>Due Date</th>
                                    <th>Return Date</th>
                                    <th>Status</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:forEach var="borrow" items="${recentBorrows}">
                                    <tr>
                                        <td>${borrow.studentName}</td>
                                        <td>${borrow.bookTitle}</td>
                                        <td>${borrow.adminName}</td>
                                        <td>${borrow.issueDate}</td>
                                        <td>${borrow.dueDate}</td>
                                        <td>${borrow.returnDate}</td>
                                        <td>
                                            <c:choose>
                                                <c:when test="${borrow.status == 'ISSUED'}">
                                                    <span class="badge text-bg-warning">${borrow.status}</span>
                                                </c:when>
                                                <c:when test="${borrow.status == 'RETURNED'}">
                                                    <span class="badge text-bg-success">${borrow.status}</span>
                                                </c:when>
                                                <c:otherwise>
                                                    <span class="badge text-bg-info">${borrow.status}</span>
                                                </c:otherwise>
                                            </c:choose>
                                        </td>
                                    </tr>
                                </c:forEach>
                                <c:if test="${empty recentBorrows}">
                                    <tr>
                                        <td colspan="7" class="text-center text-muted py-4">No borrow activity found.
                                        </td>
                                    </tr>
                                </c:if>
                            </tbody>
                        </table>
                    </div>
                </div>
            </div>

            <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
        </body>

        </html>