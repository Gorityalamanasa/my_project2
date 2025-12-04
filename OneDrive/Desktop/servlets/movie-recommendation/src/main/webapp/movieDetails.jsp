<%@ page import="java.sql.*" %>
<%@ page import="java.util.*" %>
<%@ page import="jakarta.servlet.http.*" %>

<%
    String title = request.getParameter("title");
    if (title == null) {
        response.sendRedirect("dashboard.jsp");
        return;
    }

    String genre = "", rating = "", description = "", imageFilename = "";
    int movieId = -1;
    List<Map<String, Object>> reviewList = new ArrayList<>();

    try {
        Class.forName("com.mysql.cj.jdbc.Driver");
        Connection conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/moviedb", "root", "Manasa@3307");

        // Fetch movie details
        PreparedStatement ps = conn.prepareStatement("SELECT * FROM movies WHERE title = ?");
        ps.setString(1, title);
        ResultSet rs = ps.executeQuery();
        if (rs.next()) {
            movieId = rs.getInt("id");
            genre = rs.getString("genre");
            rating = rs.getString("rating");
            description = rs.getString("description");
            imageFilename = rs.getString("image_filename");
        } else {
            // Handle the case where the movie was not found
            out.println("<h3>Movie not found. Please try again.</h3>");
            return;
        }

        // Fetch reviews for this movie
        ps = conn.prepareStatement("SELECT * FROM reviews WHERE movie_id = ?");
        ps.setInt(1, movieId);
        rs = ps.executeQuery();
        while (rs.next()) {
            Map<String, Object> review = new HashMap<>();
            review.put("user_id", rs.getInt("user_id"));
            review.put("rating", rs.getFloat("rating"));
            review.put("comment", rs.getString("comment"));
            reviewList.add(review);
        }

        conn.close();
    } catch (Exception e) {
        e.printStackTrace();
        out.println("<h3>Database error. Please try again later.</h3>");
        return;
    }

    session.setAttribute("movieId", movieId); // Optional: can also pass this with form
%>

<!DOCTYPE html>
<html>
<head>
    <title>Movie Details</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body class="container mt-5">

    <h2><%= title %></h2>
    <img src="images/<%= imageFilename != null ? imageFilename : "default.jpg" %>"
         class="img-fluid mb-3" style="max-height:300px;"
         onerror="this.onerror=null; this.src='images/default.jpg';"
         alt="Movie Poster">
    <p><strong>Genre:</strong> <%= genre %></p>
    <p><strong>Rating:</strong> <%= rating %></p>
    <p><strong>Description:</strong> <%= description %></p>

    <hr>

    <h4>Submit Your Review</h4>
   <form method="post" action="ReviewServlet" class="mb-4">
    <input type="hidden" name="movie_id" value="<%= movieId %>">
    <input type="hidden" name="title" value="<%= title %>"> <%-- ADD THIS --%>
    <div class="mb-2">
        <label>Rating (out of 10):</label>
        <input type="number" name="rating" step="0.1" min="0" max="10" class="form-control" required>
    </div>
    <div class="mb-2">
        <label>Comment:</label>
        <textarea name="comment" class="form-control" required></textarea>
    </div>
    <button type="submit" class="btn btn-primary">Submit Review</button>
</form>
   

    <hr>

    <h4>User Reviews</h4>
    <% if (reviewList.isEmpty()) { %>
        <p>No reviews yet. Be the first to review!</p>
    <% } else {
        for (Map<String, Object> review : reviewList) { %>
            <div class="border rounded p-2 mb-2">
                <strong>User ID:</strong> <%= review.get("user_id") %><br>
                <strong>Rating:</strong> <%= review.get("rating") %>/10<br>
                <strong>Comment:</strong> <%= review.get("comment") != null ? review.get("comment") : "No comment provided" %>
            </div>
    <%  }
    } %>

    <a href="dashboard.jsp" class="btn btn-secondary mt-4">Back to Dashboard</a>
</body>
</html>
