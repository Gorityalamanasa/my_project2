package com.recommendation.controller;

import java.io.*;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.sql.*;

@SuppressWarnings("serial")
@WebServlet("/RegisterServlet") // Mapping the servlet to the URL
public class RegisterServlet extends HttpServlet {

@Override
protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
    response.setContentType("text/html"); // Set content type for HTML output
    PrintWriter out = response.getWriter(); // Get PrintWriter for response output

    String username = request.getParameter("username");
    String email = request.getParameter("email");
    String password = request.getParameter("password");

    // Check if any input field is empty
    if (username.isEmpty() || email.isEmpty() || password.isEmpty()) {
        out.println("<h3>All fields are required. Please fill in all fields.</h3>");
        return;
    }

    try {
        // Database connection
        Class.forName("com.mysql.cj.jdbc.Driver");
        Connection conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/moviedb", "root", "Manasa@3307");

        // Check if email already exists
        PreparedStatement checkEmail = conn.prepareStatement("SELECT * FROM users WHERE email = ?");
        checkEmail.setString(1, email);
        ResultSet rs = checkEmail.executeQuery();
        if (rs.next()) {
            out.println("<h3>Email is already registered. Please try another one.</h3>");
            return;
        }

        // Insert new user into the database
        PreparedStatement ps = conn.prepareStatement("INSERT INTO users(username, email, password) VALUES (?, ?, ?)");
        ps.setString(1, username);
        ps.setString(2, email);
        ps.setString(3, password);

        int result = ps.executeUpdate();
        if (result > 0) {
            out.println("<h3>Registration successful! You can now <a href='login.jsp'>login</a>.</h3>");
            response.sendRedirect("login.jsp");
        } else {
            out.println("<h3>Registration failed. Please try again later.</h3>");
        }
    } catch (SQLException e) {
        out.println("<h3>Error in database operation: " + e.getMessage() + "</h3>");
        e.printStackTrace();
    } catch (ClassNotFoundException e) {
        out.println("<h3>Error: MySQL Driver not found!</h3>");
        e.printStackTrace();
    } catch (Exception e) {
        out.println("<h3>Unexpected error: " + e.getMessage() + "</h3>");
        e.printStackTrace();
    }
}

@Override
protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
    // Redirecting GET requests to the registration page (in case of direct URL access)
    response.sendRedirect("register.jsp");
}


}
