<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
        <!DOCTYPE html>
        <html lang="en">

        <head>
            <meta charset="UTF-8" />
            <meta name="viewport" content="width=device-width, initial-scale=1.0" />
            <title>Book Management</title>
            <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
            <link href="${pageContext.request.contextPath}/assets/css/style.css" rel="stylesheet">
        </head>

        <body class="app-page">
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
                <div class="page-header mb-4">
                    <span class="badge text-bg-primary brand-pill">Catalog Studio</span>
                    <h1 class="fw-bold mt-2 mb-1">Book Management</h1>
                    <p>Create, edit, and search the library catalog from one clean workspace.</p>
                </div>
                <c:if test="${not empty param.success}">
                    <div class="alert alert-success">${param.success}</div>
                </c:if>

                <div class="row g-4">
                    <div class="col-lg-5">
                        <div class="card form-card p-4">
                            <h4 class="fw-bold mb-3">
                                <c:choose>
                                    <c:when test="${not empty bookToEdit}">Edit Book</c:when>
                                    <c:otherwise>Add Book</c:otherwise>
                                </c:choose>
                            </h4>
                            <form action="${pageContext.request.contextPath}/admin/books" method="post" class="row g-3">
                                <input type="hidden" name="id" value="${bookToEdit.id}" />
                                <input type="hidden" name="action" value="save" />
                                <div class="col-12">
                                    <label class="form-label">Title</label>
                                    <input type="text" class="form-control" name="title" value="${bookToEdit.title}"
                                        required>
                                </div>
                                <div class="col-12">
                                    <label class="form-label">Author</label>
                                    <input type="text" class="form-control" name="author" value="${bookToEdit.author}"
                                        required>
                                </div>
                                <div class="col-md-6">
                                    <label class="form-label">ISBN</label>
                                    <input type="text" class="form-control" name="isbn" value="${bookToEdit.isbn}"
                                        required>
                                </div>
                                <div class="col-md-6">
                                    <label class="form-label">Category</label>
                                    <input type="text" class="form-control" name="category"
                                        value="${bookToEdit.category}">
                                </div>
                                <div class="col-md-6">
                                    <label class="form-label">Publisher</label>
                                    <input type="text" class="form-control" name="publisher"
                                        value="${bookToEdit.publisher}">
                                </div>
                                <div class="col-md-6">
                                    <label class="form-label">Shelf Location</label>
                                    <input type="text" class="form-control" name="shelfLocation"
                                        value="${bookToEdit.shelfLocation}">
                                </div>
                                <div class="col-md-6">
                                    <label class="form-label">Total Quantity</label>
                                    <input type="number" class="form-control" name="totalQuantity"
                                        value="${empty bookToEdit ? 1 : bookToEdit.totalQuantity}" min="0" required>
                                </div>
                                <div class="col-md-6">
                                    <label class="form-label">Available Quantity</label>
                                    <input type="number" class="form-control" name="availableQuantity"
                                        value="${empty bookToEdit ? 1 : bookToEdit.availableQuantity}" min="0" required>
                                </div>
                                <div class="col-12">
                                    <label class="form-label">Cover Image URL</label>
                                    <input type="text" class="form-control" name="coverImage"
                                        value="${bookToEdit.coverImage}">
                                </div>
                                <div class="col-12 d-flex gap-2">
                                    <button type="submit" class="btn btn-primary">Save</button>
                                    <a href="${pageContext.request.contextPath}/admin/books"
                                        class="btn btn-outline-secondary">Reset</a>
                                </div>
                            </form>
                        </div>
                    </div>

                    <div class="col-lg-7">
                        <div class="card table-card p-4">
                            <div class="d-flex justify-content-between align-items-center mb-3">
                                <h4 class="fw-bold mb-0">Books</h4>
                                <form class="d-flex" method="get"
                                    action="${pageContext.request.contextPath}/admin/books">
                                    <input type="search" class="form-control form-control-sm me-2" name="q"
                                        value="${param.q}" placeholder="Search books">
                                    <button class="btn btn-sm btn-outline-primary">Search</button>
                                </form>
                            </div>
                            <div class="table-responsive">
                                <table class="table align-middle">
                                    <thead>
                                        <tr>
                                            <th>Title</th>
                                            <th>ISBN</th>
                                            <th>Qty</th>
                                            <th>Available</th>
                                            <th>Actions</th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <c:forEach var="book" items="${books}">
                                            <c:set var="rowClass" value="" />
                                            <c:if test="${book.availableQuantity <= 0}">
                                                <c:set var="rowClass" value="table-secondary" />
                                            </c:if>
                                            <tr class="${rowClass}">
                                                <td>
                                                    <div class="fw-semibold">${book.title}</div>
                                                    <small class="text-muted">${book.author}</small>
                                                </td>
                                                <td>${book.isbn}</td>
                                                <td>${book.totalQuantity}</td>
                                                <td>
                                                    <c:choose>
                                                        <c:when test="${book.availableQuantity <= 0}">
                                                            <span class="badge text-bg-secondary">0</span>
                                                        </c:when>
                                                        <c:otherwise>
                                                            <span
                                                                class="badge badge-soft">${book.availableQuantity}</span>
                                                        </c:otherwise>
                                                    </c:choose>
                                                </td>
                                                <td>
                                                    <a class="btn btn-sm btn-outline-primary"
                                                        href="${pageContext.request.contextPath}/admin/books?action=edit&id=${book.id}">Edit</a>
                                                    <form action="${pageContext.request.contextPath}/admin/books"
                                                        method="post" class="d-inline"
                                                        onsubmit="return confirm('Delete this book?')">
                                                        <input type="hidden" name="action" value="delete" />
                                                        <input type="hidden" name="id" value="${book.id}" />
                                                        <button class="btn btn-sm btn-outline-danger"
                                                            type="submit">Delete</button>
                                                    </form>
                                                </td>
                                            </tr>
                                        </c:forEach>
                                        <c:if test="${empty books}">
                                            <tr>
                                                <td colspan="5" class="text-center text-muted py-4">No books found.</td>
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
            <script src="${pageContext.request.contextPath}/assets/js/preloader.js"></script>
        </body>

        </html>