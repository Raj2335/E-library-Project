package com.elibrary.util;

import com.elibrary.model.Admin;
import com.elibrary.model.Student;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

public final class SessionUtil {
    public static final String ROLE_ADMIN = "ADMIN";
    public static final String ROLE_STUDENT = "STUDENT";
    public static final String ATTR_ROLE = "userRole";
    public static final String ATTR_ADMIN = "currentAdmin";
    public static final String ATTR_STUDENT = "currentStudent";

    private SessionUtil() {
    }

    public static boolean isAuthenticated(HttpServletRequest request) {
        HttpSession session = request.getSession(false);
        return session != null && session.getAttribute(ATTR_ROLE) != null;
    }

    public static boolean isAdmin(HttpServletRequest request) {
        HttpSession session = request.getSession(false);
        return session != null && ROLE_ADMIN.equals(session.getAttribute(ATTR_ROLE));
    }

    public static boolean isStudent(HttpServletRequest request) {
        HttpSession session = request.getSession(false);
        return session != null && ROLE_STUDENT.equals(session.getAttribute(ATTR_ROLE));
    }

    public static Admin getCurrentAdmin(HttpServletRequest request) {
        HttpSession session = request.getSession(false);
        if (session == null) {
            return null;
        }
        return (Admin) session.getAttribute(ATTR_ADMIN);
    }

    public static Student getCurrentStudent(HttpServletRequest request) {
        HttpSession session = request.getSession(false);
        if (session == null) {
            return null;
        }
        return (Student) session.getAttribute(ATTR_STUDENT);
    }
}

