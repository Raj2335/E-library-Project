package com.elibrary.controller;

import com.elibrary.dao.FineDAO;
import com.elibrary.model.Fine;
import com.elibrary.util.SessionUtil;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.math.BigDecimal;
import java.util.List;

@WebServlet("/student/fines")
public class StudentFinesController extends HttpServlet {
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
            List<Fine> fines = fineDAO.findByStudentId(studentId);
            BigDecimal totalPending = fineDAO.totalFineForStudent(studentId);
            request.setAttribute("fines", fines);
            request.setAttribute("totalPending", totalPending);
            request.getRequestDispatcher("/student/fines.jsp").forward(request, response);
        } catch (Exception e) {
            throw new ServletException("Failed to load student fines", e);
        }
    }
}

