<%@ page session="false" %>
<nav class="navbar navbar-expand-lg navbar-dark bg-dark fixed-top">
    <div class="container">
        <a class="navbar-brand" href="dashboard.jsp">MovieRec</a>
        <div class="d-flex">
            <form action="LogoutServlet" method="get">
                <button class="btn btn-outline-light" type="submit">Logout</button>
            </form>
        </div>
    </div>
</nav>

