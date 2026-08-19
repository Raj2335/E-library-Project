<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
        <!DOCTYPE html>
        <html lang="en">

        <head>
            <meta charset="UTF-8" />
            <meta name="viewport" content="width=device-width, initial-scale=1.0" />
            <title>Manage Fines</title>
            <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
            <link href="${pageContext.request.contextPath}/assets/css/style.css" rel="stylesheet">
        </head>

        <body>
            <nav class="navbar navbar-expand-lg navbar-dark bg-dark">
                <div class="container-fluid">
                    <a class="navbar-brand" href="${pageContext.request.contextPath}/admin/dashboard">E-Library
                        Admin</a>
                    <div class="ms-auto">
                        <a class="btn btn-outline-light btn-sm"
                            href="${pageContext.request.contextPath}/logout">Logout</a>
                    </div>
                </div>
            </nav>

            <div class="container py-4">
                <div class="d-flex justify-content-between align-items-center mb-3">
                    <h3>Fines</h3>
                    <form method="post" action="${pageContext.request.contextPath}/admin/calculate-fines">
                        <button class="btn btn-primary">Calculate Fines Now</button>
                    </form>
                </div>

                <form class="row g-2 mb-3" method="get" action="${pageContext.request.contextPath}/admin/fines">
                    <div class="col-auto">
                        <input type="number" name="studentId" class="form-control" placeholder="Student ID">
                    </div>
                    <div class="col-auto">
                        <button class="btn btn-outline-secondary">Search</button>
                        <a class="btn btn-outline-dark" href="${pageContext.request.contextPath}/admin/fines">Reset</a>
                    </div>
                </form>

                <div class="table-responsive">
                    <table class="table table-hover align-middle">
                        <thead>
                            <tr>
                                <th>Fine ID</th>
                                <th>Student ID</th>
                                <th>Book ID</th>
                                <th>Due Date</th>
                                <th>Return Date</th>
                                <th>Days Late</th>
                                <th>Amount (₹)</th>
                                <th>Status</th>
                                <th>Actions</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach var="fine" items="${fines}">
                                <tr>
                                    <td>${fine.fineId}</td>
                                    <td>${fine.studentId}</td>
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
                                    <td>
                                        <form method="post" action="${pageContext.request.contextPath}/admin/fines"
                                            style="display:inline-block">
                                            <input type="hidden" name="fineId" value="${fine.fineId}" />
                                            <button type="submit" name="action" value="markPaid"
                                                class="btn btn-sm btn-success">Mark Paid</button>
                                        </form>
                                        <form method="post" action="${pageContext.request.contextPath}/admin/fines"
                                            style="display:inline-block">
                                            <input type="hidden" name="fineId" value="${fine.fineId}" />
                                            <button type="submit" name="action" value="delete"
                                                class="btn btn-sm btn-danger"
                                                onclick="return confirm('Delete fine?')">Delete</button>
                                        </form>
                                    </td>
                                </tr>
                            </c:forEach>
                            <c:if test="${empty fines}">
                                <tr>
                                    <td colspan="9" class="text-center text-muted">No fines found.</td>
                                </tr>
                            </c:if>
                        </tbody>
                    </table>
                </div>

            </div>

            <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
        </body>

        </html>