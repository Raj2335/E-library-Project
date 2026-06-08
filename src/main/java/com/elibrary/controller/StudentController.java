package com.elibrary.controller;

import com.elibrary.dao.StudentDao;
import com.elibrary.model.Student;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import java.io.IOException;

@WebServlet("/admin/students")
public class StudentController extends HttpServlet {
    private final StudentDao studentDAO = new StudentDao();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        if (!com.elibrary.util.SessionUtil.isAdmin(request)) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }

        try {
            request.setAttribute("students", studentDAO.search(request.getParameter("q")));
            String action = request.getParameter("action");
            if ("edit".equalsIgnoreCase(action)) {
                String id = request.getParameter("id");
                if (id != null && !id.isBlank()) {
                    request.setAttribute("studentToEdit", studentDAO.findById(Integer.parseInt(id)));
                }
            }
            request.getRequestDispatcher("/admin/students.jsp").forward(request, response);
        } catch (Exception exception) {
            throw new ServletException("Failed to load students.", exception);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        if (!com.elibrary.util.SessionUtil.isAdmin(request)) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }

        String action = request.getParameter("action");
        try {
            if ("delete".equalsIgnoreCase(action)) {
                studentDAO.delete(Integer.parseInt(request.getParameter("id")));
            } else {
                Student student = new Student();
                String id = request.getParameter("id");
                if (id != null && !id.isBlank()) {
                    student.setId(Integer.parseInt(id));
                }
                student.setRollNum(request.getParameter("rollNum"));
                student.setName(request.getParameter("name"));
                student.setDept(request.getParameter("dept"));
                student.setYear(Integer.parseInt(request.getParameter("year")));
                student.setPhone(request.getParameter("phone"));
                student.setEmail(request.getParameter("email"));
                if (student.getId() == null) {
                    studentDAO.insert(student);
                } else {
                    studentDAO.update(student);
                }
            }
            response.sendRedirect(request.getContextPath() + "/admin/students");
        } catch (Exception exception) {
            throw new ServletException("Failed to save student.", exception);
        }
    }
}

