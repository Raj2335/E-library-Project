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
import java.util.List;

@WebServlet("/admin/fines")
public class AdminFinesController extends HttpServlet {
    private final FineDAO fineDAO = new FineDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        if (!SessionUtil.isAdmin(request)) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }

        try {
            String studentIdParam = request.getParameter("studentId");
            List<Fine> fines;
            if (studentIdParam != null && !studentIdParam.isBlank()) {
                int sid = Integer.parseInt(studentIdParam);
                fines = fineDAO.findByStudentId(sid);
            } else {
                fines = fineDAO.findAll();
            }
            request.setAttribute("fines", fines);
            request.getRequestDispatcher("/admin/fines.jsp").forward(request, response);
        } catch (Exception e) {
            throw new ServletException("Failed to load fines", e);
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
            String action = request.getParameter("action");
            if ("markPaid".equals(action)) {
                int fineId = Integer.parseInt(request.getParameter("fineId"));
                fineDAO.updateStatus(fineId, "PAID");
            } else if ("delete".equals(action)) {
                int fineId = Integer.parseInt(request.getParameter("fineId"));
                fineDAO.deleteFine(fineId);
            }
            response.sendRedirect(request.getContextPath() + "/admin/fines");
        } catch (Exception e) {
            throw new ServletException("Failed to update fine", e);
        }
    }
}

