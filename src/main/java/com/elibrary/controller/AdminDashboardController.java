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

@WebServlet("/admin/dashboard")
public class AdminDashboardController extends HttpServlet {
    private final BookDAO bookDAO = new BookDAO();
    private final StudentDao studentDAO = new StudentDao();
    private final BorrowDAO borrowDAO = new BorrowDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        if (!SessionUtil.isAdmin(request)) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }

        try {
            request.setAttribute("totalBooks", bookDAO.countBooks());
            request.setAttribute("totalStudents", studentDAO.countStudents());
            request.setAttribute("totalIssuedBooks", borrowDAO.countIssuedBooks());
            request.setAttribute("totalAvailableBooks", bookDAO.countAvailableBooks());
            request.setAttribute("recentBorrows", borrowDAO.findRecentActivities(8));
            request.getRequestDispatcher("/admin/dashboard.jsp").forward(request, response);
        } catch (Exception exception) {
            throw new ServletException("Failed to load admin dashboard.", exception);
        }
    }
}

