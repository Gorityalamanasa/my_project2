package com.recommendation.controller;

import java.io.*;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.sql.*;

@WebServlet("/ReviewServlet")
public class ReviewServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        response.setContentType("text/html");
        PrintWriter out = response.getWriter();

        // Assuming user is logged in and userId is stored in session
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("userId") == null) {
            out.println("<h3>You must be logged in to submit a review. <a href='login.jsp'>Login here</a>.</h3>");
            return;
        }

        int userId = (int) session.getAttribute("userId");

        String movieIdStr = request.getParameter("movie_id");
        String ratingStr = request.getParameter("rating");
        String comment = request.getParameter("comment");

        // Validate input parameters (checking for null or empty values)
        if (movieIdStr == null || ratingStr == null || comment == null || comment.trim().isEmpty()) {
            out.println("<h3>All fields are required. Please try again.</h3>");
            return;
        }

        try {
            // Parsing movieId and rating with error handling
            int movieId = Integer.parseInt(movieIdStr);
            float rating = Float.parseFloat(ratingStr);

            // Check if the rating is within the valid range
            if (rating < 0 || rating > 10) {
                out.println("<h3>Rating should be between 0 and 10. Please try again.</h3>");
                return;
            }

            // Handle empty comment strings more gracefully
            if (comment == null || comment.trim().isEmpty()) {
                comment = "No comment provided."; // Or you could set a default comment if necessary
            }

            // Database connection and review insertion
            Class.forName("com.mysql.cj.jdbc.Driver");
            Connection conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/moviedb", "root", "Manasa@3307");

            // Prepare and execute the SQL insert statement
            PreparedStatement ps = conn.prepareStatement("INSERT INTO reviews (user_id, movie_id, rating, comment) VALUES (?, ?, ?, ?)");
            ps.setInt(1, userId);
            ps.setInt(2, movieId);
            ps.setFloat(3, rating);
            ps.setString(4, comment);

            int result = ps.executeUpdate();

            if (result > 0) {
                // Redirect to the movie details page after successful submission
                String movieTitle = request.getParameter("title");
                if (movieTitle == null || movieTitle.trim().isEmpty()) {
                    out.println("<h3>Missing movie title. Cannot redirect.</h3>");
                    return;
                }
                // Ensure comment and movieId are passed along
                response.sendRedirect("movieDetails.jsp?title=" + java.net.URLEncoder.encode(movieTitle, "UTF-8") + "&movie_id=" + movieId);
            } else {
                out.println("<h3>Failed to submit review. Please try again.</h3>");
            }

            conn.close();
        } catch (NumberFormatException e) {
            out.println("<h3>Invalid input. Please enter valid numeric values for rating and movie ID.</h3>");
            e.printStackTrace();
        } catch (SQLException e) {
            out.println("<h3>Database error: " + e.getMessage() + "</h3>");
            e.printStackTrace();
        } catch (ClassNotFoundException e) {
            out.println("<h3>MySQL JDBC Driver not found.</h3>");
            e.printStackTrace();
        } catch (Exception e) {
            out.println("<h3>Unexpected error: " + e.getMessage() + "</h3>");
            e.printStackTrace();
        }
    }

    // Optional: Redirect GET requests to home/dashboard
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        response.sendRedirect("dashboard.jsp");
    }
}
