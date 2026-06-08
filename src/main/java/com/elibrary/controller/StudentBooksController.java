package com.elibrary.controller;

import com.elibrary.dao.BookDAO;
import com.elibrary.util.SessionUtil;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import java.io.IOException;

@WebServlet("/student/books")
public class StudentBooksController extends HttpServlet {
    private final BookDAO bookDAO = new BookDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        if (!SessionUtil.isStudent(request)) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }

        try {
            String query = request.getParameter("q");
            request.setAttribute("books", bookDAO.search(query));
            request.setAttribute("query", query == null ? "" : query.trim());
            request.getRequestDispatcher("/student/books.jsp").forward(request, response);
        } catch (Exception exception) {
            throw new ServletException("Failed to load student book catalog.", exception);
        }
    }
}
