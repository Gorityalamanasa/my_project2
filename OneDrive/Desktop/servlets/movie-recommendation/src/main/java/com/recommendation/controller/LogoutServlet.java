
package com.recommendation.controller;

import java.io.*;

import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

public class LogoutServlet extends HttpServlet {
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
        throws ServletException, IOException {
        
        HttpSession session = request.getSession(false); // fetch session if exists
        if (session != null) {
            session.invalidate(); // logout
        }
        response.sendRedirect("index.jsp");
    }
}
