package com.recommendation.controller;

import java.io.*;
import java.sql.*;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
@WebServlet("/SearchServlet")
public class SearchServlet extends HttpServlet {
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
        throws ServletException, IOException {
        
        String keyword = request.getParameter("query");
        String genre = request.getParameter("genre");
        String ratingStr = request.getParameter("rating");

        response.setContentType("text/html");
        PrintWriter out = response.getWriter();

        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            Connection conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/moviedb", "root", "Manasa@3307");

            StringBuilder sql = new StringBuilder("SELECT * FROM movies WHERE 1=1");
            if (keyword != null && !keyword.trim().isEmpty()) sql.append(" AND title LIKE ?");
            if (genre != null && !genre.trim().isEmpty()) sql.append(" AND genre = ?");
            if (ratingStr != null && !ratingStr.trim().isEmpty()) sql.append(" AND rating >= ?");

            PreparedStatement ps = conn.prepareStatement(sql.toString());

            int index = 1;
            if (keyword != null && !keyword.trim().isEmpty()) ps.setString(index++, "%" + keyword + "%");
            if (genre != null && !genre.trim().isEmpty()) ps.setString(index++, genre);
            if (ratingStr != null && !ratingStr.trim().isEmpty()) ps.setDouble(index++, Double.parseDouble(ratingStr));

            ResultSet rs = ps.executeQuery();

            boolean found = false;
            while (rs.next()) {
                found = true;
                out.println("<div class='card mb-3' onclick=\"viewMovieDetails('" + rs.getString("title") + "')\" style='cursor:pointer;'>");
                out.println("<div class='row g-0'>");
                out.println("<div class='col-md-3'><img src='images/" + rs.getString("image_filename") + "' class='img-fluid rounded-start'></div>");
                out.println("<div class='col-md-9'><div class='card-body'>");
                out.println("<h5 class='card-title'>" + rs.getString("title") + "</h5>");
                out.println("<p class='card-text'><strong>Genre:</strong> " + rs.getString("genre") + " | <strong>Rating:</strong> " + rs.getString("rating") + "</p>");
                out.println("<p class='card-text'>" + rs.getString("description") + "</p>");
                out.println("</div></div></div></div>");
            }

            if (!found) {
                out.println("<div class='alert alert-warning'>No movies found.</div>");
            }

            conn.close();
        } catch (Exception e) {
            out.println("<div class='alert alert-danger'>Error during search.</div>");
            e.printStackTrace();
        }
    }
}

