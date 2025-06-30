<%-- 
    Document   : categories
    Created on : Jun 30, 2025, 12:40:34 AM
    Author     : ThinhLVCE181726 <your.name at your.org>
--%>

<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="model.Category, java.util.List" %>
<%
    List<Category> categories = (List<Category>) request.getAttribute("categories");
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8"/>
    <title>Danh mục sản phẩm</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.1/dist/css/bootstrap.min.css"/>
</head>
<body style="background:#f6f7fb;">
    <div class="container my-5">
        <h2 class="mb-4 fw-bold text-center">Tất cả danh mục sản phẩm</h2>
        <table class="table table-hover table-bordered bg-white">
            <thead>
                <tr>
                    <th>Mã</th>
                    <th>Tên danh mục</th>
                    <th>Loại</th>
                    <th>Danh mục cha</th>
                </tr>
            </thead>
            <tbody>
            <% for (Category c : categories) { %>
                <tr>
                    <td><%= c.getCategoryId() %></td>
                    <td>
                        <!-- Link đến trang liệt kê sản phẩm thuộc danh mục (mở rộng về sau) -->
                        <a href="products?categoryId=<%= c.getCategoryId() %>"><%= c.getName() %></a>
                    </td>
                    <td><%= c.getCategoryType() %></td>
                    <td>
                        <%-- Hiện parent id hoặc để trống nếu không có --%>
                        <%= (c.getParentId() == 0 ? "-" : c.getParentId()) %>

                    </td>
                </tr>
            <% } %>
            </tbody>
        </table>
    </div>
</body>
</html>

