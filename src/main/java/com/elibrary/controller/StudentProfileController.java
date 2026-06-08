package com.elibrary.controller;

import com.elibrary.dao.StudentDao;
import com.elibrary.dao.FineDAO;
import java.math.BigDecimal;
import com.elibrary.util.SessionUtil;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import java.io.IOException;

@WebServlet("/student/profile")
public class StudentProfileController extends HttpServlet {
    private final StudentDao studentDAO = new StudentDao();
    private final FineDAO fineDAO = new FineDAO();

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
            BigDecimal totalPending = fineDAO.totalFineForStudent(studentId);
            request.setAttribute("totalPending", totalPending);
            request.getRequestDispatcher("/student/profile.jsp").forward(request, response);
        } catch (Exception exception) {
            throw new ServletException("Failed to load student profile.", exception);
        }
    }
}

