<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
        <!DOCTYPE html>
        <html lang="en">

        <head>
            <meta charset="UTF-8" />
            <meta name="viewport" content="width=device-width, initial-scale=1.0" />
            <title>Your Fines</title>
            <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
            <link href="${pageContext.request.contextPath}/assets/css/style.css" rel="stylesheet">
        </head>

        <body class="app-page">
            <nav class="navbar navbar-expand-lg navbar-dark bg-dark">
                <div class="container-fluid">
                    <a class="navbar-brand" href="${pageContext.request.contextPath}/student/dashboard">E-Library</a>
                    <div class="ms-auto">
                        <a class="btn btn-outline-light btn-sm"
                            href="${pageContext.request.contextPath}/logout">Logout</a>
                    </div>
                </div>
            </nav>

            <div class="container py-4">
                <div class="page-header mb-3">
                    <span class="badge text-bg-primary brand-pill">Student Finance</span>
                    <h1 class="fw-bold mt-2 mb-1">Your Fines</h1>
                    <p>Keep track of unpaid items and settle them quickly when needed.</p>
                </div>
                <div class="card form-card p-3 mb-3">
                    <strong>Total Pending:</strong>
                    <span class="text-danger">₹ ${totalPending}</span>
                </div>

                <div class="table-responsive">
                    <table class="table table-striped align-middle">
                        <thead>
                            <tr>
                                <th>Fine ID</th>
                                <th>Book ID</th>
                                <th>Due Date</th>
                                <th>Return Date</th>
                                <th>Days Late</th>
                                <th>Amount (₹)</th>
                                <th>Status</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach var="fine" items="${fines}">
                                <tr>
                                    <td>${fine.fineId}</td>
                                    <td>${fine.bookId}</td>
                                    <td>${fine.dueDate}</td>
                                    <td>
                                        <c:out value="${fine.returnDate}" default="-" />
                                    </td>
                                    <td>${fine.daysLate}</td>
                                    <td>${fine.fineAmount}</td>
                                    <td>
                                        <c:choose>
                                            <c:when test="${fine.status == 'PAID'}"><span
                                                    class="badge bg-success">PAID</span></c:when>
                                            <c:otherwise><span class="badge bg-danger">UNPAID</span></c:otherwise>
                                        </c:choose>
                                    </td>
                                </tr>
                            </c:forEach>
                            <c:if test="${empty fines}">
                                <tr>
                                    <td colspan="7" class="text-center text-muted">No fines found.</td>
                                </tr>
                            </c:if>
                        </tbody>
                    </table>
                </div>
            </div>

            <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
        </body>

        </html>