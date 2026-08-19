<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
        <!DOCTYPE html>
        <html lang="en">

        <head>
            <meta charset="UTF-8" />
            <meta name="viewport" content="width=device-width, initial-scale=1.0" />
            <title>Student Dashboard</title>
            <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
            <link href="${pageContext.request.contextPath}/assets/css/style.css" rel="stylesheet">
        </head>

        <body class="app-page">
            <!-- Preloader -->
            <div id="preloader-overlay">
                <div class="preloader-card">
                    <div class="preloader-spinner"></div>
                    <div class="preloader-title">E-Library</div>
                    <div class="preloader-sub">Loading your dashboard...</div>
                </div>
            </div>

            <nav class="navbar navbar-expand-lg navbar-dark bg-dark">
                <div class="container-fluid">
                    <a class="navbar-brand fw-bold" href="${pageContext.request.contextPath}/student/books">E-Library
                        Student</a>
                    <div class="ms-auto">
                        <a class="btn btn-outline-light btn-sm me-2"
                            href="${pageContext.request.contextPath}/student/books">Open Catalog</a>
                        <a class="btn btn-outline-light btn-sm me-2"
                            href="${pageContext.request.contextPath}/student/profile">Profile</a>
                        <a class="btn btn-outline-light btn-sm"
                            href="${pageContext.request.contextPath}/logout">Logout</a>
                    </div>
                </div>
            </nav>

            <div class="container py-4">
                <div class="page-header mb-4">
                    <span class="badge text-bg-primary brand-pill">Student Overview</span>
                    <h1 class="fw-bold mt-2 mb-1">Welcome, ${profile.name}</h1>
                    <p class="text-muted">Browse featured books and track your active borrows below.</p>
                </div>

                <div class="row g-4 mb-4">
                    <div class="col-md-4">
                        <div class="card stat-card p-4">
                            <div class="text-muted small">Roll Number</div>
                            <div class="fs-4 fw-bold">${profile.rollNum}</div>
                        </div>
                    </div>
                    <div class="col-md-4">
                        <div class="card stat-card p-4">
                            <div class="text-muted small">Department</div>
                            <div class="fs-4 fw-bold">${profile.dept}</div>
                        </div>
                    </div>
                    <div class="col-md-4">
                        <div class="card stat-card p-4">
                            <div class="text-muted small">Active Borrows</div>
                            <div class="fs-4 fw-bold">${currentBorrowCount}</div>
                        </div>
                    </div>
                </div>

                <div class="card table-card p-4 mb-4" id="current-borrows">
                    <h4 class="fw-bold mb-3">Current Borrowed Books</h4>
                    <div class="table-responsive">
                        <table class="table align-middle">
                            <thead>
                                <tr>
                                    <th>Book</th>
                                    <th>Issue Date</th>
                                    <th>Due Date</th>
                                    <th>Status</th>
                                    <th>Fine</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:forEach var="borrow" items="${currentBorrows}">
                                    <c:set var="rowStyle" value="" />
                                    <c:if test="${borrow.status == 'ISSUED' && borrow.fineAmount > 0}">
                                        <c:set var="rowStyle" value="background-color:#f8d7da" />
                                    </c:if>
                                    <tr style="${rowStyle}">
                                        <td>${borrow.bookTitle}</td>
                                        <td>${borrow.issueDate}</td>
                                        <td>${borrow.dueDate}</td>
                                        <td>
                                            <c:choose>
                                                <c:when test="${borrow.status == 'ISSUED' && borrow.fineAmount > 0}">
                                                    <span class="badge text-bg-danger">${borrow.status}</span>
                                                </c:when>
                                                <c:otherwise>
                                                    <span class="badge text-bg-warning">${borrow.status}</span>
                                                </c:otherwise>
                                            </c:choose>
                                        </td>
                                        <td>₹ ${borrow.fineAmount}</td>
                                    </tr>
                                </c:forEach>
                                <c:if test="${empty currentBorrows}">
                                    <tr>
                                        <td colspan="5" class="text-center text-muted py-4">No active borrow records.
                                        </td>
                                    </tr>
                                </c:if>
                            </tbody>
                        </table>
                    </div>
                </div>

                <div class="card table-card p-4">
                    <h4 class="fw-bold mb-3">Returned Books</h4>
                    <div class="table-responsive">
                        <table class="table align-middle">
                            <thead>
                                <tr>
                                    <th>Book</th>
                                    <th>Issue Date</th>
                                    <th>Return Date</th>
                                    <th>Fine</th>
                                    <th>Status</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:forEach var="borrow" items="${returnedBorrows}">
                                    <tr>
                                        <td>${borrow.bookTitle}</td>
                                        <td>${borrow.issueDate}</td>
                                        <td>${borrow.returnDate}</td>
                                        <td>₹ ${borrow.fineAmount}</td>
                                        <td><span class="badge text-bg-success">${borrow.status}</span></td>
                                    </tr>
                                </c:forEach>
                                <c:if test="${empty returnedBorrows}">
                                    <tr>
                                        <td colspan="5" class="text-center text-muted py-4">No returned books yet.
                                        </td>
                                    </tr>
                                </c:if>
                            </tbody>
                        </table>
                    </div>
                </div>

            </div>

            <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
            <script src="${pageContext.request.contextPath}/assets/js/preloader.js"></script>
        </body>

        </html>