<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
        <!DOCTYPE html>
        <html lang="en">

        <head>
            <meta charset="UTF-8" />
            <meta name="viewport" content="width=device-width, initial-scale=1.0" />
            <title>Book Catalog</title>
            <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
            <link href="${pageContext.request.contextPath}/assets/css/style.css" rel="stylesheet">
        </head>

        <body class="app-page">
            <!-- Preloader -->
            <div id="preloader-overlay">
                <div class="preloader-card">
                    <div class="preloader-spinner"></div>
                    <div class="preloader-title">E-Library</div>
                    <div class="preloader-sub">Preparing your catalog...</div>
                </div>
            </div>

            <nav class="navbar navbar-expand-lg navbar-dark bg-dark">
                <div class="container-fluid">
                    <a class="navbar-brand fw-bold" href="${pageContext.request.contextPath}/student/books">E-Library
                        Student</a>
                    <div class="ms-auto">
                        <a class="btn btn-outline-light btn-sm me-2"
                            href="${pageContext.request.contextPath}/student/dashboard">Dashboard</a>
                        <a class="btn btn-outline-light btn-sm"
                            href="${pageContext.request.contextPath}/logout">Logout</a>
                    </div>
                </div>
            </nav>

            <div class="container py-4">
                <div class="page-header mb-4">
                    <span class="badge text-bg-primary brand-pill">Book Section</span>
                    <h1 class="fw-bold mt-2 mb-1">Student Book Catalog</h1>
                    <p class="text-muted">Browse the available library books in a card layout with cover images.</p>
                </div>

                <div class="card form-card p-3 p-md-4 mb-4">
                    <form class="row g-3 align-items-end" method="get"
                        action="${pageContext.request.contextPath}/student/books">
                        <div class="col-md-8">
                            <label class="form-label">Search books</label>
                            <input type="search" class="form-control" name="q" value="${query}"
                                placeholder="Title, author, ISBN, category, or publisher">
                        </div>
                        <div class="col-md-4 d-flex gap-2">
                            <button class="btn btn-primary flex-grow-1" type="submit">Search</button>
                            <a class="btn btn-outline-secondary"
                                href="${pageContext.request.contextPath}/student/books">Reset</a>
                        </div>
                    </form>
                </div>

                <div class="card hero-card p-4">
                    <div class="row g-4 book-grid">
                        <c:forEach var="book" items="${books}">
                            <div class="col-12 col-sm-6 col-lg-4 col-xxl-3">
                                <c:set var="bookCardClass" value="card book-card h-100 overflow-hidden" />
                                <c:if test="${book.availableQuantity <= 0}">
                                    <c:set var="bookCardClass"
                                        value="card book-card h-100 overflow-hidden book-card-out-of-stock" />
                                </c:if>
                                <div class="${bookCardClass}">
                                    <c:choose>
                                        <c:when test="${not empty book.coverImage}">
                                            <img src="${book.coverImage}" class="book-cover" alt="${book.title}">
                                        </c:when>
                                        <c:otherwise>
                                            <img src="https://placehold.co/600x900/0f172a/f8fafc?text=Book+Cover"
                                                class="book-cover" alt="Book cover placeholder">
                                        </c:otherwise>
                                    </c:choose>
                                    <div class="card-body d-flex flex-column">
                                        <div class="d-flex justify-content-between align-items-start gap-2 mb-2">
                                            <h5 class="card-title fw-bold mb-0">${book.title}</h5>
                                            <c:choose>
                                                <c:when test="${book.availableQuantity <= 0}">
                                                    <span class="badge text-bg-secondary">Out of stock</span>
                                                </c:when>
                                                <c:otherwise>
                                                    <span class="badge text-bg-success">${book.availableQuantity}
                                                        left</span>
                                                </c:otherwise>
                                            </c:choose>
                                        </div>
                                        <p class="text-muted mb-2">by ${book.author}</p>
                                        <p class="small text-muted mb-3">${book.category}<c:if
                                                test="${not empty book.publisher}"> | ${book.publisher}</c:if>
                                        </p>
                                        <div class="mt-auto d-flex justify-content-between align-items-center">
                                            <span class="small text-muted">Shelf: ${book.shelfLocation}</span>
                                            <span class="badge badge-soft">ISBN ${book.isbn}</span>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </c:forEach>
                        <c:if test="${empty books}">
                            <div class="col-12">
                                <div class="alert alert-info mb-0">No books available yet.</div>
                            </div>
                        </c:if>
                    </div>
                </div>
            </div>

            <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
            <script src="${pageContext.request.contextPath}/assets/js/preloader.js"></script>
        </body>

        </html>