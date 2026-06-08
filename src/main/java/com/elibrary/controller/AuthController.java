package com.elibrary.controller;

import com.elibrary.dao.AdminDAO;
import com.elibrary.dao.StudentDao;
import com.elibrary.model.Admin;
import com.elibrary.model.Student;
import com.elibrary.util.SessionUtil;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import java.io.IOException;

@WebServlet("/auth")
public class AuthController extends HttpServlet {
    private final AdminDAO adminDAO = new AdminDAO();
    private final StudentDao studentDAO = new StudentDao();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String role = request.getParameter("role");
        String contextPath = request.getContextPath();

        try {
            if (SessionUtil.ROLE_ADMIN.equalsIgnoreCase(role)) {
                String email = request.getParameter("email");
                String password = request.getParameter("password");
                Admin admin = adminDAO.authenticate(email, password);
                if (admin != null) {
                    HttpSession session = request.getSession(true);
                    session.setAttribute(SessionUtil.ATTR_ROLE, SessionUtil.ROLE_ADMIN);
                    session.setAttribute(SessionUtil.ATTR_ADMIN, admin);
                    session.setAttribute("flashMessage", "Welcome, " + admin.getName() + ".");
                    response.sendRedirect(contextPath + "/admin/dashboard");
                    return;
                }
            } else if (SessionUtil.ROLE_STUDENT.equalsIgnoreCase(role)) {
                String rollNum = request.getParameter("rollNum");
                String email = request.getParameter("studentEmail");
                Student student = studentDAO.authenticate(rollNum, email);
                if (student != null) {
                    HttpSession session = request.getSession(true);
                    session.setAttribute(SessionUtil.ATTR_ROLE, SessionUtil.ROLE_STUDENT);
                    session.setAttribute(SessionUtil.ATTR_STUDENT, student);
                    session.setAttribute("flashMessage", "Welcome, " + student.getName() + ".");
                    response.sendRedirect(contextPath + "/student/books");
                    return;
                }
            }

            request.setAttribute("errorMessage", "Invalid login credentials.");
            request.getRequestDispatcher("/login.jsp").forward(request, response);
        } catch (Exception exception) {
            request.setAttribute("errorMessage", exception.getMessage());
            request.getRequestDispatcher("/login.jsp").forward(request, response);
        }
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws IOException {
        response.sendRedirect(request.getContextPath() + "/login.jsp");
    }
}

