<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.sql.*" %> 
<%@ page import="javax.naming.*" %>
<%@ page import="javax.sql.*" %>
<%@ page session="true" %>
<%
    String username = (String) session.getAttribute("username");

    if (username != null) {
        // Already logged in – redirect to dashboard
        response.sendRedirect("RecommendationServlet");
        return;
    }
%>
<!DOCTYPE html>
<html>
<head>
    <title>Login - Movie Recommendation System</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            background-color: #f2f2f2;
        }

        .container {
            width: 400px;
            margin: 80px auto;
            padding: 30px;
            background-color: white;
            box-shadow: 0 0 10px rgba(0,0,0,0.3);
            border-radius: 8px;
        }

        h2 {
            text-align: center;
            margin-bottom: 20px;
        }

        label {
            display: block;
            margin: 10px 0 5px;
        }

        input[type="text"], input[type="password"] {
            width: 100%;
            padding: 8px;
            margin-bottom: 15px;
            border: 1px solid #ccc;
            border-radius: 4px;
        }

        input[type="submit"] {
            width: 100%;
            padding: 10px;
            background-color: #3498db;
            color: white;
            border: none;
            border-radius: 4px;
            cursor: pointer;
        }

        .error {
            color: red;
            margin-bottom: 15px;
            text-align: center;
        }
    </style>
</head>
<body>
    <div class="container">
        <h2>Login</h2>

        <%-- Show error message if exists --%>
        <%
            String errorMessage = (String) request.getAttribute("errorMessage");
            if (errorMessage != null) {
        %>
            <div class="error"><%= errorMessage %></div>
        <%
            }
        %>

        <form action="LoginServlet" method="post">
            <label for="email">Email:</label>
            <input type="text" id="email" name="email" required>

            <label for="password">Password:</label>
            <input type="password" id="password" name="password" required>

            <input type="submit" value="Login">
        </form>
    </div>
</body>
</html>
