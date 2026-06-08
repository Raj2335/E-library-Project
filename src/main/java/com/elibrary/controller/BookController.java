package com.elibrary.controller;

import com.elibrary.dao.BookDAO;
import com.elibrary.model.Book;
import com.elibrary.model.Admin;
import com.elibrary.util.SessionUtil;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import java.io.IOException;

@WebServlet("/admin/books")
public class BookController extends HttpServlet {
    private final BookDAO bookDAO = new BookDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        if (!SessionUtil.isAdmin(request)) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }

        String action = request.getParameter("action");
        try {
            request.setAttribute("books", bookDAO.search(request.getParameter("q")));
            if ("edit".equalsIgnoreCase(action)) {
                String id = request.getParameter("id");
                if (id != null && !id.isBlank()) {
                    request.setAttribute("bookToEdit", bookDAO.findById(Integer.parseInt(id)));
                }
            }
            request.getRequestDispatcher("/admin/books.jsp").forward(request, response);
        } catch (Exception exception) {
            throw new ServletException("Failed to load books.", exception);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        if (!SessionUtil.isAdmin(request)) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }

        String action = request.getParameter("action");
        Admin currentAdmin = SessionUtil.getCurrentAdmin(request);

        try {
            if ("delete".equalsIgnoreCase(action)) {
                bookDAO.delete(Integer.parseInt(request.getParameter("id")));
            } else {
                Book book = new Book();
                String id = request.getParameter("id");
                if (id != null && !id.isBlank()) {
                    book.setId(Integer.parseInt(id));
                }
                book.setTitle(request.getParameter("title"));
                book.setAuthor(request.getParameter("author"));
                book.setIsbn(request.getParameter("isbn"));
                book.setCategory(request.getParameter("category"));
                book.setPublisher(request.getParameter("publisher"));
                book.setTotalQuantity(Integer.parseInt(request.getParameter("totalQuantity")));
                book.setAvailableQuantity(Integer.parseInt(request.getParameter("availableQuantity")));
                book.setShelfLocation(request.getParameter("shelfLocation"));
                book.setCoverImage(request.getParameter("coverImage"));
                book.setUpdatedBy(currentAdmin == null ? null : currentAdmin.getId());
                if (book.getId() == null) {
                    book.setCreatedBy(currentAdmin == null ? null : currentAdmin.getId());
                    bookDAO.insert(book);
                } else {
                    bookDAO.update(book);
                }
            }
            response.sendRedirect(request.getContextPath() + "/admin/books");
        } catch (Exception exception) {
            throw new ServletException("Failed to save book.", exception);
        }
    }
}

