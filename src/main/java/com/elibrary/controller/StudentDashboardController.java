package com.elibrary.controller;

import com.elibrary.dao.BorrowDAO;
import com.elibrary.dao.StudentDao;
import com.elibrary.util.SessionUtil;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import java.io.IOException;

@WebServlet("/student/dashboard")
public class StudentDashboardController extends HttpServlet {
    private final StudentDao studentDAO = new StudentDao();
    private final BorrowDAO borrowDAO = new BorrowDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        if (!SessionUtil.isStudent(request)) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }

        try {
            int studentId = SessionUtil.getCurrentStudent(request).getId();
            request.setAttribute("profile", studentDAO.findById(studentId));
            java.util.List<com.elibrary.model.Borrow> currentBorrows = borrowDAO
                    .findCurrentBorrowsByStudentId(studentId);
            request.setAttribute("currentBorrows", currentBorrows);
            request.setAttribute("currentBorrowCount", currentBorrows.size());
            request.setAttribute("returnedBorrows", borrowDAO.findReturnedBorrowsByStudentId(studentId));
            request.getRequestDispatcher("/student/dashboard.jsp").forward(request, response);
        } catch (Exception exception) {
            throw new ServletException("Failed to load student dashboard.", exception);
        }
    }
}

