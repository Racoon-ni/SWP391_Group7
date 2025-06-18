<%-- 
    Document   : admin-dashboard
    Created on : Mar 8, 2025, 6:33:35 PM
    Author     : LEGION
--%>

<%@ page contentType="text/html; charset=UTF-8" %>
<%--<%@ page import="model.User" %>

<%
    User user = (User) session.getAttribute("loggedUser");
%>--%>

<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Dashboard</title>

    </head>
    <body>
        <!-- Nhúng Sidebar -->
        <%@include file="WEB-INF/include/admin-side-bar.jsp" %>
        <!-- Main Content -->
        <div class="main-content">


            <!-- Nội dung chính -->
            <div class="container mt-4">
                <h2>Chào mừng, Admin <b>
                        <%--<%= user.getUsername()%>--%>
                    </b></h2>
                <p>Chào mừng bạn đến với trang quản trị. Đây là nơi quản lý tất cả nội dung.</p>
            </div>
        </div>

        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.1/dist/js/bootstrap.bundle.min.js"></script>
    </body>
</html>
