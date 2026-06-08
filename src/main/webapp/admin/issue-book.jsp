<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
        <!DOCTYPE html>
        <html lang="en">

        <head>
            <meta charset="UTF-8" />
            <meta name="viewport" content="width=device-width, initial-scale=1.0" />
            <title>Issue Book</title>
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
                    <div class="col-lg-4">
                        <div class="card form-card p-4">
                            <h4 class="fw-bold mb-3">Issue Book</h4>
                            <form action="${pageContext.request.contextPath}/admin/issue-book" method="post"
                                class="row g-3">
                                <div class="col-12">
                                    <label class="form-label">Student</label>
                                    <select class="form-select" name="studentId" required>
                                        <option value="">Select student</option>
                                        <c:forEach var="student" items="${students}">
                                            <option value="${student.id}">${student.rollNum} - ${student.name}</option>
                                        </c:forEach>
                                    </select>
                                </div>
                                <div class="col-12">
                                    <label class="form-label">Book
                                        <button type="button" id="addBookBtn" class="btn btn-sm btn-outline-primary ms-2">+</button>
                                    </label>

                                    <div id="booksContainer">
                                        <div class="mb-2 book-select-row">
                                            <select class="form-select" name="bookId" required>
                                                <option value="">Select book</option>
                                                <c:forEach var="book" items="${books}">
                                                    <option value="${book.id}" <c:if test="${book.availableQuantity == 0}">
                                                        disabled class="book-option-out-of-stock"</c:if>>
                                                        ${book.title} (Available: ${book.availableQuantity}<c:if
                                                            test="${book.availableQuantity == 0}">, Out of stock</c:if>)
                                                    </option>
                                                </c:forEach>
                                            </select>
                                        </div>
                                    </div>
                                </div>
                                <div class="col-6">
                                    <label class="form-label">Issue Date</label>
                                    <input type="date" class="form-control" name="issueDate" required>
                                </div>
                                <div class="col-6">
                                    <label class="form-label">Due Date</label>
                                    <input type="date" class="form-control" name="dueDate" required>
                                </div>
                                <div class="col-12">
                                    <button class="btn btn-primary w-100" type="submit">Issue Book</button>
                                </div>
                            </form>
                        </div>
                    </div>
                    <div class="col-lg-8">
                        <div class="card table-card p-4">
                            <h4 class="fw-bold mb-3">Active Borrow Records</h4>
                            <div class="table-responsive">
                                <table class="table align-middle">
                                    <thead>
                                        <tr>
                                            <th>Student</th>
                                            <th>Book</th>
                                            <th>Issue</th>
                                            <th>Due</th>
                                            <th>Fine (₹)</th>
                                            <th>Status</th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <c:forEach var="borrow" items="${activeBorrows}">
                                            <tr>
                                                <td>${borrow.studentRollNum} - ${borrow.studentName}</td>
                                                <td>${borrow.bookTitle}</td>
                                                <td>${borrow.issueDate}</td>
                                                <td>${borrow.dueDate}</td>
                                                <td>₹ ${borrow.fineAmount}</td>
                                                <td>
                                                    <c:choose>
                                                        <c:when
                                                            test="${borrow.fineAmount > 0 && borrow.status == 'ISSUED'}">
                                                            <span class="badge bg-danger">${borrow.status}</span>
                                                        </c:when>
                                                        <c:when test="${borrow.status == 'ISSUED'}">
                                                            <span class="badge text-bg-warning">${borrow.status}</span>
                                                        </c:when>
                                                        <c:when test="${borrow.status == 'OVERDUE'}">
                                                            <span class="badge bg-danger">${borrow.status}</span>
                                                        </c:when>
                                                        <c:when test="${borrow.status == 'RETURNED'}">
                                                            <span class="badge bg-success">${borrow.status}</span>
                                                        </c:when>
                                                        <c:otherwise>
                                                            <span class="badge bg-secondary">${borrow.status}</span>
                                                        </c:otherwise>
                                                    </c:choose>
                                                </td>
                                            </tr>
                                        </c:forEach>
                                        <c:if test="${empty activeBorrows}">
                                            <tr>
                                                <td colspan="6" class="text-center text-muted py-4">No active borrow
                                                    records.</td>
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
            <script>
                document.addEventListener('DOMContentLoaded', function() {
                    const addBtn = document.getElementById('addBookBtn');
                    const container = document.getElementById('booksContainer');
                    if (!addBtn || !container) return;

                    addBtn.addEventListener('click', function() {
                        const firstSelect = container.querySelector('select');
                        if (!firstSelect) return;
                        const clone = firstSelect.cloneNode(true);
                        clone.value = '';

                        const row = document.createElement('div');
                        row.className = 'mb-2 book-select-row d-flex gap-2';
                        // wrap clone
                        const selectWrapper = document.createElement('div');
                        selectWrapper.style.flex = '1';
                        selectWrapper.appendChild(clone);
                        row.appendChild(selectWrapper);

                        // remove button
                        const removeBtn = document.createElement('button');
                        removeBtn.type = 'button';
                        removeBtn.className = 'btn btn-sm btn-outline-danger';
                        removeBtn.textContent = '−';
                        removeBtn.title = 'Remove this book';
                        removeBtn.addEventListener('click', function() { row.remove(); });
                        row.appendChild(removeBtn);

                        container.appendChild(row);
                    });
                });
            </script>
        </body>

        </html>