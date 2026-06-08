package com.elibrary.filter;

import com.elibrary.util.SessionUtil;

import javax.servlet.Filter;
import javax.servlet.FilterChain;
import javax.servlet.FilterConfig;
import javax.servlet.ServletException;
import javax.servlet.ServletRequest;
import javax.servlet.ServletResponse;
import javax.servlet.annotation.WebFilter;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import java.io.IOException;

@WebFilter("/*")
public class AuthFilter implements Filter {
    @Override
    public void init(FilterConfig filterConfig) {
    }

    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
            throws IOException, ServletException {
        HttpServletRequest httpRequest = (HttpServletRequest) request;
        HttpServletResponse httpResponse = (HttpServletResponse) response;
        String contextPath = httpRequest.getContextPath();
        String requestUri = httpRequest.getRequestURI().substring(contextPath.length());

        if (isPublicUri(requestUri)) {
            chain.doFilter(request, response);
            return;
        }

        HttpSession session = httpRequest.getSession(false);
        if (session == null || session.getAttribute(SessionUtil.ATTR_ROLE) == null) {
            httpResponse.sendRedirect(contextPath + "/login.jsp");
            return;
        }

        String role = (String) session.getAttribute(SessionUtil.ATTR_ROLE);
        if (requestUri.startsWith("/admin/") && !SessionUtil.ROLE_ADMIN.equals(role)) {
            httpResponse.sendRedirect(contextPath + "/student/dashboard");
            return;
        }
        if (requestUri.startsWith("/student/") && !SessionUtil.ROLE_STUDENT.equals(role)) {
            httpResponse.sendRedirect(contextPath + "/admin/dashboard");
            return;
        }

        chain.doFilter(request, response);
    }

    private boolean isPublicUri(String requestUri) {
        return requestUri.equals("/")
                || requestUri.equals("/index.jsp")
                || requestUri.equals("/login.jsp")
                || requestUri.equals("/auth")
                || requestUri.equals("/logout")
                || requestUri.startsWith("/assets/")
                || requestUri.startsWith("/images/");
    }

    @Override
    public void destroy() {
    }
}

