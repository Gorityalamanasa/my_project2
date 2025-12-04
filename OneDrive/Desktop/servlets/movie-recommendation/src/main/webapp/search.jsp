<%@ page import="java.sql.*" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
<head>
    <title>Search Movies</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css">
</head>
<body class="bg-light">

<div class="container mt-5">

    <!-- Search Form -->
    <form action="search.jsp" method="get" class="row g-3 mb-4">
        <div class="col-md-4">
            <input type="text" name="keyword" class="form-control" placeholder="Search by title..."
                   value="<%= request.getParameter("keyword") != null ? request.getParameter("keyword") : "" %>">
        </div>
        <div class="col-md-3">
            <select name="genre" class="form-select">
                <option value="">All Genres</option>
                <option value="Action" <%= "Action".equals(request.getParameter("genre")) ? "selected" : "" %>>Action</option>
                <option value="Drama" <%= "Drama".equals(request.getParameter("genre")) ? "selected" : "" %>>Drama</option>
                <option value="Comedy" <%= "Comedy".equals(request.getParameter("genre")) ? "selected" : "" %>>Comedy</option>
                <option value="Horror" <%= "Horror".equals(request.getParameter("genre")) ? "selected" : "" %>>Horror</option>
                <option value="Romance" <%= "Romance".equals(request.getParameter("genre")) ? "selected" : "" %>>Romance</option>
                <option value="Thriller" <%= "Thriller".equals(request.getParameter("genre")) ? "selected" : "" %>>Thriller</option>
                <option value="Sci-Fi" <%= "Sci-Fi".equals(request.getParameter("genre")) ? "selected" : "" %>>Sci-Fi</option>
                <!-- Add more genres as needed -->
            </select>
        </div>
        <div class="col-md-3">
            <select name="rating" class="form-select">
                <option value="">All Ratings</option>
                  <option value="10" <%= "10".equals(request.getParameter("rating")) ? "selected" : "" %>>10</option>
                <option value="9" <%= "9".equals(request.getParameter("rating")) ? "selected" : "" %>>9+</option>
                <option value="8" <%= "8".equals(request.getParameter("rating")) ? "selected" : "" %>>8+</option>
                <option value="7" <%= "7".equals(request.getParameter("rating")) ? "selected" : "" %>>7+</option>
                <option value="6" <%= "6".equals(request.getParameter("rating")) ? "selected" : "" %>>6+</option>
                <option value="5" <%= "5".equals(request.getParameter("rating")) ? "selected" : "" %>>5+</option>
                
            </select>
        </div>
        <div class="col-md-2">
            <button type="submit" class="btn btn-primary w-100">Search</button>
        </div>
    </form>

    <!-- Search Results -->
    <%
        String keyword = request.getParameter("keyword");
        String genre = request.getParameter("genre");
        String ratingStr = request.getParameter("rating");

        if (keyword == null) keyword = "";
        if (genre == null) genre = "";
        if (ratingStr == null) ratingStr = "";

        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            Connection conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/moviedb", "root", "Manasa@3307");

            StringBuilder sql = new StringBuilder("SELECT * FROM movies WHERE 1=1");
            if (!keyword.trim().isEmpty()) sql.append(" AND title LIKE ?");
            if (!genre.trim().isEmpty()) sql.append(" AND genre = ?");
            if (!ratingStr.trim().isEmpty()) sql.append(" AND rating >= ?");

            PreparedStatement ps = conn.prepareStatement(sql.toString());

            int i = 1;
            if (!keyword.trim().isEmpty()) ps.setString(i++, "%" + keyword + "%");
            if (!genre.trim().isEmpty()) ps.setString(i++, genre);
            if (!ratingStr.trim().isEmpty()) ps.setDouble(i++, Double.parseDouble(ratingStr));

            ResultSet rs = ps.executeQuery();

            boolean hasResults = false;
            while (rs.next()) {
                hasResults = true;
    %>
   <a href="movieDetails.jsp?title=<%= java.net.URLEncoder.encode(rs.getString("title"), "UTF-8") %>" class="text-decoration-none text-dark">
   
        <div class="card mb-4 p-3 shadow-sm">
            <div class="row g-0">
                <div class="col-md-3">
                    <img src="images/<%= rs.getString("image_filename") %>" class="img-fluid rounded" alt="Movie Image"
     onerror="this.onerror=null; this.src='images/default.jpg';">
                    
                </div>
                <div class="col-md-9">
                    <div class="card-body">
                        <h4 class="card-title"><%= rs.getString("title") %></h4>
                        <p class="card-text"><strong>Genre:</strong> <%= rs.getString("genre") %> |
                            <strong>Rating:</strong> <%= rs.getString("rating") %></p>
                        <p class="card-text"><%= rs.getString("description") %></p>
                    </div>
                </div>
            </div>
        </div>
    </a>
    <%
            }
            if (!hasResults) {
    %>
    <div class="alert alert-warning">No results found. Try different filters.</div>
    <%
            }
            conn.close();
        } catch (Exception e) {
    %>
    <div class="alert alert-danger">Error loading search results.</div>
    <pre><%= e.getMessage() %></pre>
    <%
        }
    %>

</div>

</body>
</html>
