<%@ page import="java.sql.*, java.util.*" %>
<%@ page session="true" %>
<%
    String username = (String) session.getAttribute("user");
    String role = (String) session.getAttribute("role");

    if (username == null || role == null || !role.equals("admin")) {
        response.sendRedirect("login.jsp");
        return;
    }

    List<Map<String, String>> movieList = new ArrayList<>();
    try {
        Class.forName("com.mysql.cj.jdbc.Driver");
        Connection conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/moviedb", "root", "Manasa@3307");
        Statement stmt = conn.createStatement();
        ResultSet rs = stmt.executeQuery("SELECT * FROM movies");
        while (rs.next()) {
            Map<String, String> movie = new HashMap<>();
            movie.put("id", rs.getString("id"));
            movie.put("title", rs.getString("title"));
            movie.put("genre", rs.getString("genre"));
            movie.put("rating", rs.getString("rating"));
            movie.put("description", rs.getString("description"));
            movie.put("image_url", rs.getString("image_url"));
            movieList.add(movie);
        }
        conn.close();
    } catch (Exception e) {
        e.printStackTrace();
    }
%>

<!DOCTYPE html>
<html>
<head>
    <title>Admin Panel</title>
    <link rel="stylesheet" href="css/styles.css">
    <!-- Bootstrap 5 CDN -->
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>

<!-- Custom Styles -->
<link rel="stylesheet" href="css/styles.css">
    
</head>
<body>
    <h2>Admin Panel - Manage Movies</h2>

    <form action="AddMovieServlet" method="post">
        <h3>Add New Movie</h3>
        Title: <input type="text" name="title" required><br>
        Genre: <input type="text" name="genre" required><br>
        Rating: <input type="text" name="rating" required><br>
        Description: <textarea name="description" rows="4" cols="30" required></textarea><br>
        Image URL: <input type="text" name="image_url"><br>
        <input type="submit" value="Add Movie">
    </form>

    <form action="LogoutServlet" method="get" style="text-align:right;">
        <input type="submit" value="Logout" />
    </form>

    <h3>All Movies</h3>
    <table border="1" cellpadding="10">
        <tr>
            <th>Title</th><th>Genre</th><th>Rating</th><th>Description</th><th>Image</th><th>Actions</th>
        </tr>
        <% for (Map<String, String> movie : movieList) { %>
        <tr>
            <td><%= movie.get("title") %></td>
            <td><%= movie.get("genre") %></td>
            <td><%= movie.get("rating") %></td>
            <td><%= movie.get("description") %></td>
            <td><img src="<%= movie.get("image_url") %>" width="80"></td>
            <td>
                <form action="DeleteMovieServlet" method="post" style="display:inline;">
                    <input type="hidden" name="id" value="<%= movie.get("id") %>">
                    <input type="submit" value="Delete">
                </form>
            </td>
        </tr>
        <% } %>
    </table>

    <br><a href="dashboard.jsp">Back to Dashboard</a>
</body>
</html>
