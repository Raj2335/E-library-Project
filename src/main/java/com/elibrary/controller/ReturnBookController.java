package com.elibrary.controller;

import com.elibrary.dao.BorrowDAO;
import com.elibrary.util.SessionUtil;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.math.BigDecimal;
import java.time.LocalDate;

@WebServlet("/admin/return-book")
public class ReturnBookController extends HttpServlet {
    private final BorrowDAO borrowDAO = new BorrowDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        if (!SessionUtil.isAdmin(request)) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }

        try {
            request.setAttribute("activeBorrows", borrowDAO.findActiveBorrows());
            request.getRequestDispatcher("/admin/return-book.jsp").forward(request, response);
        } catch (Exception exception) {
            throw new ServletException("Failed to load return book page.", exception);
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
            String[] borrowIds = request.getParameterValues("borrowId");
            LocalDate returnDate = LocalDate.parse(request.getParameter("returnDate"));
            boolean finePaid = "on".equalsIgnoreCase(request.getParameter("finePaid"));
            int adminId = SessionUtil.getCurrentAdmin(request).getId();

            if (borrowIds == null || borrowIds.length == 0) {
                request.getSession().setAttribute("flash", "No borrow records selected to return.");
                response.sendRedirect(request.getContextPath() + "/admin/return-book");
                return;
            }

            int success = 0, failed = 0;
            for (String bid : borrowIds) {
                if (bid == null || bid.trim().isEmpty()) continue;
                try {
                    int borrowId = Integer.parseInt(bid);
                    // fetch borrow to get due date
                    com.elibrary.model.Borrow br = borrowDAO.findById(borrowId);
                    if (br == null) { failed++; continue; }
                    java.time.LocalDate due = br.getDueDate();
                    long daysLate = 0L;
                    if (due != null) {
                        daysLate = java.time.temporal.ChronoUnit.DAYS.between(due, returnDate);
                    }
                    java.math.BigDecimal fineAmount = calculateFine(daysLate);
                    borrowDAO.returnBook(borrowId, returnDate, fineAmount, finePaid, adminId);
                    success++;
                } catch (Exception e) {
                    failed++;
                }
            }

            request.getSession().setAttribute("flash", "Returns processed: success=" + success + ", failed=" + failed);
            response.sendRedirect(request.getContextPath() + "/admin/return-book");
        } catch (Exception exception) {
            throw new ServletException("Failed to return book.", exception);
        }
    }

    private java.math.BigDecimal calculateFine(long daysLate) {
        if (daysLate <= 2) return java.math.BigDecimal.ZERO;
        if (daysLate >= 3 && daysLate <= 7) return java.math.BigDecimal.valueOf(daysLate * 2L);
        if (daysLate >= 8 && daysLate <= 15) return java.math.BigDecimal.valueOf(daysLate * 5L);
        return java.math.BigDecimal.valueOf(daysLate * 10L);
    }
}

