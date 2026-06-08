package com.elibrary.controller;

import com.elibrary.dao.BookDAO;
import com.elibrary.dao.BorrowDAO;
import com.elibrary.dao.StudentDao;
import com.elibrary.util.SessionUtil;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.time.LocalDate;
import java.util.LinkedHashSet;
import java.util.List;
import java.util.Set;
import java.util.stream.Collectors;

@WebServlet("/admin/issue-book")
public class IssueBookController extends HttpServlet {
    private final BorrowDAO borrowDAO = new BorrowDAO();
    private final StudentDao studentDAO = new StudentDao();
    private final BookDAO bookDAO = new BookDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        if (!SessionUtil.isAdmin(request)) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }

        try {
            request.setAttribute("students", studentDAO.findAll());
            request.setAttribute("books", bookDAO.findAll());
            request.setAttribute("activeBorrows", borrowDAO.findActiveBorrows());
            request.getRequestDispatcher("/admin/issue-book.jsp").forward(request, response);
        } catch (Exception exception) {
            throw new ServletException("Failed to load issue book page.", exception);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        if (!SessionUtil.isAdmin(request)) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }

        try {
            int studentId = Integer.parseInt(request.getParameter("studentId"));
            String[] bookIds = request.getParameterValues("bookId");
            int adminId = SessionUtil.getCurrentAdmin(request).getId();
            LocalDate issueDate = LocalDate.parse(request.getParameter("issueDate"));
            LocalDate dueDate = LocalDate.parse(request.getParameter("dueDate"));

            if (bookIds == null || bookIds.length == 0) {
                request.getSession().setAttribute("flash", "No books selected to issue.");
                response.sendRedirect(request.getContextPath() + "/admin/issue-book");
                return;
            }
            // Deduplicate selected book IDs while preserving order
            Set<Integer> uniqueBookIds = new LinkedHashSet<>();
            for (String bid : bookIds) {
                if (bid == null || bid.trim().isEmpty()) continue;
                try {
                    uniqueBookIds.add(Integer.parseInt(bid.trim()));
                } catch (NumberFormatException ignored) {
                }
            }

            // Enforce per-student active borrow limit
            final int MAX_ACTIVE_BOOKS = 3; // change if different policy desired
            List<com.elibrary.model.Borrow> current = borrowDAO.findCurrentBorrowsByStudentId(studentId);
            Set<Integer> alreadyBorrowed = current.stream().map(com.elibrary.model.Borrow::getBookId).collect(Collectors.toSet());
            int remainingAllowed = Math.max(0, MAX_ACTIVE_BOOKS - current.size());

            int success = 0, failed = 0, skippedDueToAlready = 0, skippedDueToLimit = 0;
            for (Integer bookId : uniqueBookIds) {
                if (alreadyBorrowed.contains(bookId)) {
                    skippedDueToAlready++;
                    failed++;
                    continue;
                }
                if (remainingAllowed <= 0) {
                    skippedDueToLimit++;
                    failed++;
                    continue;
                }
                try {
                    boolean issued = borrowDAO.issueBook(studentId, bookId, adminId, issueDate, dueDate);
                    if (issued) {
                        success++;
                        remainingAllowed--;
                    } else {
                        failed++;
                    }
                } catch (Exception e) {
                    failed++;
                }
            }

            StringBuilder flash = new StringBuilder();
            flash.append("Books processed: success=").append(success).append(", failed=").append(failed);
            if (skippedDueToAlready > 0) flash.append(", skippedAlreadyBorrowed=").append(skippedDueToAlready);
            if (skippedDueToLimit > 0) flash.append(", skippedLimitReached=").append(skippedDueToLimit).append(" (max=").append(MAX_ACTIVE_BOOKS).append(")");
            request.getSession().setAttribute("flash", flash.toString());
            response.sendRedirect(request.getContextPath() + "/admin/issue-book");
        } catch (Exception exception) {
            throw new ServletException("Failed to issue book.", exception);
        }
    }
}

