package com.recommendation.controller;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.io.PrintWriter;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

@WebServlet("/dbtest")
public class DBTestServlet extends HttpServlet {

    private static final String DB_URL = "jdbc:mysql://localhost:3306/moviedb";
    private static final String DB_USER = "root";
    private static final String DB_PASS = "Manasa@3307";

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        response.setContentType("text/html");
        PrintWriter out = response.getWriter();

        try {
            Class.forName("com.mysql.cj.jdbc.Driver"); // Ensure driver is loaded
            Connection conn = DriverManager.getConnection(DB_URL, DB_USER, DB_PASS);

            if (conn != null) {
                out.println("<h2 style='color:green;'>MySQL JDBC Connection: SUCCESS!</h2>");
                conn.close();
            } else {
                out.println("<h2 style='color:red;'>Connection failed!</h2>");
            }
        } catch (ClassNotFoundException e) {
            out.println("<h2 style='color:red;'>MySQL Driver not found!</h2>");
            e.printStackTrace(out);
        } catch (SQLException e) {
            out.println("<h2 style='color:red;'>SQL Error!</h2>");
            e.printStackTrace(out);
        }
    }
}

