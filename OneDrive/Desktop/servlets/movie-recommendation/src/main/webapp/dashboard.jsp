<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.*" %>
<%@ page session="true" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<%
    String username = (String) session.getAttribute("username");
    if (username == null) {
        response.sendRedirect("login.jsp");
        return;
    }
%>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>User Dashboard - Movie Recommendation System</title>

    <!-- Bootstrap 5 -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>

    <!-- Custom CSS -->
    <link rel="stylesheet" href="css/styles.css">

    <style>
        .movie-list {
            display: flex;
            flex-wrap: wrap;
            gap: 20px;
        }
        .movie-card {
            width: 300px;
            border: 1px solid #ddd;
            border-radius: 10px;
            padding: 15px;
            box-shadow: 0 2px 5px rgba(0,0,0,0.1);
            cursor: pointer;
            transition: 0.3s;
        }
        .movie-card:hover {
            box-shadow: 0 4px 10px rgba(0,0,0,0.2);
        }
        .movie-card img {
            width: 100%;
            height: 200px;
            object-fit: cover;
            border-radius: 5px;
        }
    </style>

    <!-- AJAX Search Script -->
    <script>
        function searchMovies() {
            const query = document.getElementById("searchBox").value;
            fetch("SearchServlet?query=" + encodeURIComponent(query))
                .then(response => response.text())
                .then(data => {
                    document.getElementById("movieResults").innerHTML = data;
                })
                .catch(error => console.error("Search failed:", error));
        }

        function viewMovieDetails(title) {
            window.location.href = "movieDetails.jsp?title=" + encodeURIComponent(title);
        }
    </script>
</head>
<body>

<nav class="navbar navbar-light bg-white shadow-sm">
    <div class="container-fluid">
        <a class="navbar-brand fw-bold" href="#">Movie Recommendation System</a>
        <form action="LogoutServlet" method="get" class="d-flex">
            <button class="btn btn-outline-danger">Logout</button>
        </form>
    </div>
</nav>

<div class="container mt-5 pt-4">
    <h3 class="mb-4">Welcome, <%= username %>! Here's your Movie Dashboard</h3>

    <!-- Search Bar -->
    <input type="text" id="searchBox" class="form-control my-3" placeholder="Search by movie title..." onkeyup="searchMovies()">

    <!-- Genre Dropdown Button -->
    <div class="dropdown mb-4">
        <button class="btn btn-outline-secondary dropdown-toggle" type="button" id="genreDropdown" data-bs-toggle="dropdown" aria-expanded="false">
            Browse by Genre
        </button>
        <ul class="dropdown-menu" aria-labelledby="genreDropdown">
            <li><a class="dropdown-item" href="search.jsp?genre=Action">Action</a></li>
            <li><a class="dropdown-item" href="search.jsp?genre=Comedy">Comedy</a></li>
            <li><a class="dropdown-item" href="search.jsp?genre=Thriller">Thriller</a></li>
            <li><a class="dropdown-item" href="search.jsp?genre=Drama">Drama</a></li>
            <li><a class="dropdown-item" href="search.jsp?genre=Horror">Horror</a></li>
            <li><a class="dropdown-item" href="search.jsp?genre=Romance">Romance</a></li>
            <li><a class="dropdown-item" href="search.jsp?genre=Sci-Fi">Sci-Fi</a></li>
        </ul>
    </div>

    <!-- Recommendations Section -->
    <div id="movieResults">
        <h4 class="mb-3">Recommended Movies</h4>

        <c:choose>
            <c:when test="${not empty recommendedMovies}">
                <div class="movie-list">
                    <c:forEach var="movie" items="${recommendedMovies}">
                        <div class="movie-card" onclick="viewMovieDetails('${movie.title}')">
                            <img src="images/${movie.image}" alt="${movie.title}" onerror="this.onerror=null; this.src='images/default.jpg';" />
                            <h5 class="mt-2">${movie.title}</h5>
                            <p><strong>Genre:</strong> ${movie.genre}</p>
                            <p><strong>Rating:</strong> ${movie.rating}</p>
                            <p class="small">${movie.description}</p>
                        </div>
                    </c:forEach>
                </div>
            </c:when>
            <c:otherwise>
                <div class="alert alert-info">No recommendations available. Please rate some movies to get personalized suggestions.</div>
            </c:otherwise>
        </c:choose>
    </div>
</div>

<footer class="bg-light text-center p-3 mt-4">
    <span class="text-muted">© 2025 MovieRec. All rights reserved.</span>
</footer>

</body>
</html>
