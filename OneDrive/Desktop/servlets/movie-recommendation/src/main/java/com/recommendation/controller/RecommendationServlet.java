package com.recommendation.controller;

import java.io.*;
import jakarta.servlet.*;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.util.*;

@WebServlet("/RecommendationServlet")
public class RecommendationServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession(false);

        if (session == null || session.getAttribute("userId") == null) {
            response.sendRedirect("login.jsp?error=sessionExpired");
            return;
        }

        int userId = (Integer) session.getAttribute("userId");
        String username = (String) session.getAttribute("username");

        List<Map<String, String>> recommendedMovies = RecommendationUtil.getRecommendedMovies(userId);

        request.setAttribute("recommendedMovies", recommendedMovies);
        request.setAttribute("username", username);

        RequestDispatcher dispatcher = request.getRequestDispatcher("dashboard.jsp");
        dispatcher.forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        doGet(request, response);
    }
}
