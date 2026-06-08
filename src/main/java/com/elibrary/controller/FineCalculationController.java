package com.elibrary.controller;

import com.elibrary.dao.BorrowDAO;
import com.elibrary.dao.FineDAO;
import com.elibrary.model.Borrow;
import com.elibrary.model.Fine;
import com.elibrary.util.SessionUtil;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.math.BigDecimal;
import java.time.LocalDate;
import java.util.List;

@WebServlet("/admin/calculate-fines")
public class FineCalculationController extends HttpServlet {
    private final BorrowDAO borrowDAO = new BorrowDAO();
    private final FineDAO fineDAO = new FineDAO();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        if (!SessionUtil.isAdmin(request)) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }

        try {
            // Find active borrows (ISSUED/OVERDUE) and compute fines for overdue ones
            List<Borrow> active = borrowDAO.findActiveBorrows();
            int created = 0, updated = 0;
            LocalDate today = LocalDate.now();
            for (Borrow br : active) {
                LocalDate due = br.getDueDate();
                if (due == null)
                    continue;
                long daysLate = java.time.temporal.ChronoUnit.DAYS.between(due, today);
                if (daysLate <= 2) {
                    // within grace period, ignore
                    continue;
                }

                BigDecimal fineAmount = calculateFine(daysLate);

                Fine fine = new Fine();
                fine.setBorrowId(br.getId());
                fine.setStudentId(br.getStudentId());
                fine.setBookId(br.getBookId());
                fine.setDueDate(due);
                fine.setReturnDate(br.getReturnDate());
                fine.setDaysLate((int) daysLate);
                fine.setFineAmount(fineAmount);
                fine.setStatus("UNPAID");

                // If a fine already exists for this borrow, skip inserting duplicates by
                // checking findByStudentId
                boolean exists = false;
                for (Fine f : fineDAO.findByStudentId(br.getStudentId())) {
                    if (f.getBorrowId() == br.getId()) {
                        exists = true;
                        break;
                    }
                }
                if (!exists) {
                    fineDAO.insertFine(fine);
                    created++;
                } else {
                    updated++;
                }
            }

            request.getSession().setAttribute("flash", "Fines processed: created=" + created + ", updated=" + updated);
            response.sendRedirect(request.getContextPath() + "/admin/fines");
        } catch (Exception e) {
            throw new ServletException("Failed to calculate fines", e);
        }
    }

    private BigDecimal calculateFine(long daysLate) {
        // Apply rules based on total days late (first 2 days grace not included here)
        if (daysLate <= 2)
            return BigDecimal.ZERO;
        if (daysLate >= 3 && daysLate <= 7)
            return BigDecimal.valueOf(daysLate * 2L);
        if (daysLate >= 8 && daysLate <= 15)
            return BigDecimal.valueOf(daysLate * 5L);
        return BigDecimal.valueOf(daysLate * 10L);
    }
}

