package com.recommendation.controller;

import java.io.*;

import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.sql.*;

public class AddMovieServlet extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
        throws ServletException, IOException {
        
        String title = request.getParameter("title");
        String genre = request.getParameter("genre");
        String rating = request.getParameter("rating");
        String description = request.getParameter("description");
        String imageUrl = request.getParameter("image_url");

        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            Connection conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/moviedb", "root", "Manasa@3307");
            PreparedStatement ps = conn.prepareStatement(
                "INSERT INTO movies (title, genre, rating, description, image_url) VALUES (?, ?, ?, ?, ?)"
            );
            ps.setString(1, title);
            ps.setString(2, genre);
            ps.setString(3, rating);
            ps.setString(4, description);
            ps.setString(5, imageUrl);
            ps.executeUpdate();
            conn.close();
        } catch (Exception e) {
            e.printStackTrace();
        }
        response.sendRedirect("admin.jsp");
    }
}
