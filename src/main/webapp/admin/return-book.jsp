<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
        <!DOCTYPE html>
        <html lang="en">

        <head>
            <meta charset="UTF-8" />
            <meta name="viewport" content="width=device-width, initial-scale=1.0" />
            <title>Return Book</title>
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
                    <span class="badge text-bg-primary brand-pill">Circulation</span>
                    <h1 class="fw-bold mt-2 mb-1">Return Book</h1>
                    <p>Close borrow records, calculate fines, and update return status in one place.</p>
                </div>
                <div class="row g-4">
                    <div class="col-lg-4">
                        <div class="card form-card p-4">
                            <h4 class="fw-bold mb-3">Return Book</h4>
                            <form action="${pageContext.request.contextPath}/admin/return-book" method="post"
                                class="row g-3">
                                <div class="col-12">
                                    <label class="form-label">Search Student (ID / Roll)</label>
                                    <input type="text" id="studentSearch" class="form-control mb-2"
                                        placeholder="Type student id or roll number to filter borrows">

                                    <label class="form-label">Borrow Record
                                        <button type="button" id="addReturnBtn"
                                            class="btn btn-sm btn-outline-primary ms-2">+ (Add)</button>
                                    </label>

                                    <div id="returnsContainer">
                                        <div class="mb-2 return-select-row d-flex gap-2">
                                            <select class="form-select return-select" name="borrowId" required>
                                                <option value="">Select borrow record</option>
                                                <c:forEach var="borrow" items="${activeBorrows}">
                                                    <option value="${borrow.id}" data-student-id="${borrow.studentId}"
                                                        data-student-roll="${borrow.studentRollNum}"
                                                        data-fine="${borrow.fineAmount}">
                                                        ${borrow.studentRollNum} - ${borrow.bookTitle} (Due
                                                        ${borrow.dueDate})
                                                    </option>
                                                </c:forEach>
                                            </select>
                                            <button type="button"
                                                class="btn btn-sm btn-outline-danger remove-return-btn d-none">−</button>
                                        </div>
                                    </div>
                                </div>
                                <div class="col-6">
                                    <label class="form-label">Return Date</label>
                                    <input type="date" id="returnDate" class="form-control" name="returnDate" required
                                        value="<%= java.time.LocalDate.now() %>">
                                </div>
                                <div class="col-6">
                                    <label class="form-label">Fine Amount</label>
                                    <input type="number" step="0.01" class="form-control" name="fineAmount"
                                        value="0.00">
                                </div>
                                <div class="col-12 form-check ms-2">
                                    <input class="form-check-input" type="checkbox" name="finePaid" id="finePaid">
                                    <label class="form-check-label" for="finePaid">Fine paid</label>
                                </div>
                                <div class="col-12">
                                    <button class="btn btn-success w-100" type="submit">Mark Returned</button>
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
                document.addEventListener('DOMContentLoaded', function () {
                    const search = document.getElementById('studentSearch');
                    const container = document.getElementById('returnsContainer');
                    const addBtn = document.getElementById('addReturnBtn');
                    const fineInput = document.querySelector('input[name="fineAmount"]');
                    const finePaidCheckbox = document.querySelector('input[name="finePaid"]');

                    function computeTotalFine() {
                        let total = 0.0;
                        const selects = container.querySelectorAll('select.return-select');
                        selects.forEach(sel => {
                            const opt = sel.options[sel.selectedIndex];
                            if (opt && opt.value) {
                                const raw = opt.dataset.fine;
                                const v = raw ? parseFloat(raw) : 0.0;
                                if (!isNaN(v)) total += v;
                            }
                        });
                        if (fineInput) fineInput.value = total.toFixed(2);
                        if (finePaidCheckbox) finePaidCheckbox.checked = total === 0;
                    }

                    function attachSelectHandlers(sel) {
                        sel.addEventListener('change', function () { computeTotalFine(); });
                    }

                    function syncRemoveButtons() {
                        const rows = container.querySelectorAll('.return-select-row');
                        const showRemove = rows.length > 1;
                        rows.forEach(row => {
                            const removeBtn = row.querySelector('.remove-return-btn');
                            if (removeBtn) {
                                removeBtn.classList.toggle('d-none', !showRemove);
                            }
                        });
                    }

                    // Initialize existing selects
                    container.querySelectorAll('select.return-select').forEach(attachSelectHandlers);

                    if (search) {
                        search.addEventListener('input', function () {
                            const q = this.value.trim().toLowerCase();
                            // filter options in all selects
                            container.querySelectorAll('select.return-select').forEach(borrowSelect => {
                                for (let i = 0; i < borrowSelect.options.length; i++) {
                                    const opt = borrowSelect.options[i];
                                    if (!opt.value) { opt.hidden = q !== ''; continue; }
                                    const sid = opt.dataset.studentId ? String(opt.dataset.studentId) : '';
                                    const sroll = opt.dataset.studentRoll ? String(opt.dataset.studentRoll).toLowerCase() : '';
                                    const matches = q === '' || sid.includes(q) || sroll.includes(q);
                                    opt.hidden = !matches;
                                }
                                // auto-select first visible
                                for (let i = 0; i < borrowSelect.options.length; i++) {
                                    const opt = borrowSelect.options[i];
                                    if (!opt.hidden && opt.value) { borrowSelect.value = opt.value; break; }
                                }
                                borrowSelect.dispatchEvent(new Event('change'));
                            });
                            computeTotalFine();
                        });
                    }

                    if (addBtn) {
                        addBtn.addEventListener('click', function () {
                            const MAX_SELECTS = 5;
                            const currentSelects = container.querySelectorAll('select.return-select').length;
                            if (currentSelects >= MAX_SELECTS) {
                                alert('You can return a maximum of ' + MAX_SELECTS + ' books at once.');
                                return;
                            }

                            const firstSelect = container.querySelector('select.return-select');
                            if (!firstSelect) return;
                            const clone = firstSelect.cloneNode(true);
                            clone.value = '';
                            attachSelectHandlers(clone);

                            const row = document.createElement('div');
                            row.className = 'mb-2 return-select-row d-flex gap-2';
                            const selectWrapper = document.createElement('div');
                            selectWrapper.style.flex = '1';
                            selectWrapper.appendChild(clone);
                            row.appendChild(selectWrapper);

                            const removeBtn = document.createElement('button');
                            removeBtn.type = 'button';
                            removeBtn.className = 'btn btn-sm btn-outline-danger remove-return-btn';
                            removeBtn.textContent = '−';
                            removeBtn.addEventListener('click', function () { row.remove(); computeTotalFine(); });
                            row.appendChild(removeBtn);

                            container.appendChild(row);
                            syncRemoveButtons();
                        });
                    }

                    // remove buttons for initial row
                    container.querySelectorAll('.remove-return-btn').forEach(btn => btn.addEventListener('click', function (e) {
                        const row = e.target.closest('.return-select-row'); if (row) { row.remove(); computeTotalFine(); }
                    }));

                    // initialize total on load
                    computeTotalFine();
                    syncRemoveButtons();
                });
            </script>
        </body>

        </html>