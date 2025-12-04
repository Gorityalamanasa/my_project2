<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<html>
<head>
    <title>Register</title>
    <!-- Bootstrap 5 CDN -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>

    <!-- Custom Styles -->
    <link rel="stylesheet" href="css/styles.css">
</head>
<body class="container mt-5">
    <h2 class="mb-4">Register</h2>
    <form action="RegisterServlet" method="post">
        <div class="mb-3">
            <label class="form-label">Username:</label>
            <input type="text" name="username" class="form-control" required />
        </div>
        <div class="mb-3">
            <label class="form-label">Email:</label>
            <input type="email" name="email" class="form-control" required />
        </div>
        <div class="mb-3">
            <label class="form-label">Password:</label>
            <input type="password" name="password" class="form-control" required />
        </div>
        <input type="submit" value="Register" class="btn btn-primary" />
    </form>
    <p class="mt-3">Already have an account? <a href="login.jsp">Login here</a></p>
</body>
</html>
