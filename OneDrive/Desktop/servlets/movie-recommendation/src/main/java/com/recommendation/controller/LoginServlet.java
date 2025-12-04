package com.recommendation.controller;

import java.io.IOException;
import java.sql.*;
import jakarta.servlet.*;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

@WebServlet("/LoginServlet")
public class LoginServlet extends HttpServlet {

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String email = request.getParameter("email");
        String password = request.getParameter("password");

        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;

        try {
            // Load JDBC driver
            Class.forName("com.mysql.cj.jdbc.Driver");

            // Connect to DB
            conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/moviedb", "root", "Manasa@3307");

            // Check user credentials
            String sql = "SELECT id, username, role FROM users WHERE email = ? AND password = ?";
            ps = conn.prepareStatement(sql);
            ps.setString(1, email);
            ps.setString(2, password);
            rs = ps.executeQuery();

            if (rs.next()) {
                int userId = rs.getInt("id");
                String username = rs.getString("username"); // FIXED: was "user"
                String role = rs.getString("role");

                // Create session and store user info
                HttpSession session = request.getSession();
                session.setAttribute("userId", userId);
                session.setAttribute("username", username);
                session.setAttribute("role", role);

                System.out.println("Login successful! Username: " + username + ", Role: " + role);

                // Redirect to dashboard
                response.sendRedirect("RecommendationServlet");

            } else {
                // Invalid login
                request.setAttribute("errorMessage", "Invalid email or password.");
                RequestDispatcher rd = request.getRequestDispatcher("login.jsp");
                rd.forward(request, response);
            }

        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("errorMessage", "Server error occurred.");
            RequestDispatcher rd = request.getRequestDispatcher("login.jsp");
            rd.forward(request, response);
        } finally {
            try {
                if (rs != null) rs.close();
                if (ps != null) ps.close();
                if (conn != null) conn.close();
            } catch (SQLException ex) {
                ex.printStackTrace();
            }
        }
    }
}
