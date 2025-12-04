package com.recommendation.controller;

import java.sql.*;
import java.util.*;

public class RecommendationUtil {

    public static List<Map<String, String>> getRecommendedMovies(int userId) {
        List<Map<String, String>> recommendedMovies = new ArrayList<>();
        Set<String> preferredGenres = new HashSet<>();

        try {
            Class.forName("com.mysql.cj.jdbc.Driver");

            try (Connection conn = DriverManager.getConnection(
                    "jdbc:mysql://localhost:3306/moviedb", "root", "Manasa@3307")) {

                // Step 1: Get genres of movies reviewed by the user with rating >= 7
                String genreQuery = """
                    SELECT DISTINCT m.genre
                    FROM movies m
                    INNER JOIN reviews r ON m.id = r.movie_id
                    WHERE r.user_id = ? AND r.rating >= 7
                """;

                try (PreparedStatement ps = conn.prepareStatement(genreQuery)) {
                    ps.setInt(1, userId);
                    try (ResultSet rs = ps.executeQuery()) {
                        while (rs.next()) {
                            preferredGenres.add(rs.getString("genre"));
                        }
                    }
                }

                if (preferredGenres.isEmpty()) {
                    // No preferred genres — fallback to popular movies
                    String fallbackQuery = "SELECT * FROM movies ORDER BY rating DESC LIMIT 10";
                    try (PreparedStatement ps = conn.prepareStatement(fallbackQuery);
                         ResultSet rs = ps.executeQuery()) {
                        while (rs.next()) {
                            recommendedMovies.add(mapMovie(rs));
                        }
                    }
                    return recommendedMovies;
                }

                // Step 2: Recommend movies from those genres not reviewed by the user
                StringBuilder genreClause = new StringBuilder();
                for (int i = 0; i < preferredGenres.size(); i++) {
                    genreClause.append("?");
                    if (i < preferredGenres.size() - 1) genreClause.append(", ");
                }

                String recommendationQuery = """
                    SELECT * FROM movies
                    WHERE genre IN (""" + genreClause + ") " + """
                    AND id NOT IN (SELECT movie_id FROM reviews WHERE user_id = ?)
                    ORDER BY rating DESC
                    LIMIT 10
                """;

                try (PreparedStatement ps = conn.prepareStatement(recommendationQuery)) {
                    int index = 1;
                    for (String genre : preferredGenres) {
                        ps.setString(index++, genre);
                    }
                    ps.setInt(index, userId);

                    try (ResultSet rs = ps.executeQuery()) {
                        while (rs.next()) {
                            recommendedMovies.add(mapMovie(rs));
                        }
                    }
                }

            }
        } catch (Exception e) {
            e.printStackTrace();
        }

        return recommendedMovies;
    }

    private static Map<String, String> mapMovie(ResultSet rs) throws SQLException {
        Map<String, String> movie = new HashMap<>();
        movie.put("id", rs.getString("id"));
        movie.put("title", rs.getString("title"));
        movie.put("genre", rs.getString("genre"));
        movie.put("rating", rs.getString("rating"));
        movie.put("description", rs.getString("description"));
        movie.put("image", rs.getString("image_filename"));
        return movie;
    }
}
