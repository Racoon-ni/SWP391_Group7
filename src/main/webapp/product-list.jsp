<%-- 
    Document   : product-list
    Created on : Jun 20, 2025, 12:05:21 AM
    Author     : ThinhLVCE181726 <your.name at your.org>
--%>

<%@ page contentType="text/html; charset=UTF-8" %>
<%@ page import="java.util.List" %>
<%@ page import="model.Product" %>
<!DOCTYPE html>
<html>
<head>
    <title>Danh sách PC</title>
    <style>
        table { border-collapse: collapse; width: 90%; }
        th, td { border: 1px solid #ccc; padding: 8px; text-align: center;}
        img { width: 90px; }
    </style>
</head>
<body>
    <h2>Danh sách PC</h2>
    <table>
        <tr>
            <th>Tên PC</th>
            <th>Mô tả</th>
            <th>Giá</th>
            <th>Số lượng</th>
            <th>Hình ảnh</th>
        </tr>
        <%
            List<Product> products = (List<Product>) request.getAttribute("products");
            if (products != null && !products.isEmpty()) {
                for(Product p : products){
        %>
        <tr>
            <td><%= p.getName() %></td>
            <td><%= p.getDescription() %></td>
            <td><%= p.getPrice() %></td>
            <td><%= p.getStock() %></td>
            <td>
                <% if(p.getImageUrl() != null) { %>
                    <img src="<%= p.getImageUrl() %>" alt="Hình PC" />
                <% } else { %>
                    Không có ảnh
                <% } %>
            </td>
        </tr>
        <%      }
            } else { %>
        <tr><td colspan="5">Không có dữ liệu</td></tr>
        <% } %>
    </table>
</body>
</html>
