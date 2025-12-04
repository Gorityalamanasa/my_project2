package com.recommendation.controller;

import java.io.*;

import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.sql.*;
import java.util.*;

public class MovieServlet extends HttpServlet {
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        List<Map<String, String>> movies = new ArrayList<>();
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            Connection conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/moviedb", "root", "Manasa@3307");
            Statement stmt = conn.createStatement();
            ResultSet rs = stmt.executeQuery("SELECT * FROM movies");

            while (rs.next()) {
                Map<String, String> movie = new HashMap<>();
                movie.put("title", rs.getString("title"));
                movie.put("genre", rs.getString("genre"));
                movie.put("rating", rs.getString("rating"));
                movie.put("description", rs.getString("description"));
              
                movie.put("image_filename", rs.getString("image_filename")); // e.g., inception.jpg

                movies.add(movie);
            }
            request.setAttribute("movies", movies);
            request.getRequestDispatcher("dashboard.jsp").forward(request, response);
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}
