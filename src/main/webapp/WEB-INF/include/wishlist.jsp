<%-- 
    Document   : wishlist.jsp
    Created on : 18-06-2025, 09:57:02
    Author     : Long
--%>

<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="model.Wishlist" %>
<%@ page import="java.util.List" %>
<%@ page import="model.User" %>


<%
    List<Wishlist> wishlist = (List<Wishlist>) request.getAttribute("wishlist");
%>

<!DOCTYPE html>
<html>
    <head>
        <meta charset="UTF-8">
        <title>Danh sách yêu thích</title>
        <style>
            table {
                width: 80%;
                margin: auto;
                border-collapse: collapse;
            }
            table, th, td {
                border: 1px solid gray;
            }
            th, td {
                padding: 10px;
                text-align: center;
            }
            img {
                width: 100px;
                height: auto;
            }
            h2 {
                text-align: center;
                margin-top: 40px;
            }
        </style>
    </head>
    <body>
        <h2>Danh sách sản phẩm yêu thích của bạn</h2>

        <%
            if (wishlist != null && !wishlist.isEmpty()) {
        %>
        <table>
            <tr>
                <th>Hình ảnh</th>
                <th>Tên sản phẩm</th>
                <th>Giá</th>
                <th>Ngày thêm</th>
            </tr>
            <%
                for (Wishlist item : wishlist) {
            %>
            <tr>
                <td><img src="<%= item.getImageUrl()%>" alt="Ảnh sản phẩm" /></td>
                <td><%= item.getProductName()%></td>
                <td><%= String.format("%,.0f", item.getPrice())%> đ</td>
                <td><%= new java.text.SimpleDateFormat("dd-MM-yyyy").format(item.getAddedAt())%></td>
            </tr>
            <% } %>
        </table>
        <%
        } else {
        %>
        <p style="text-align:center; color:gray;">Bạn chưa có sản phẩm yêu thích nào.</p>
        <%
            }
        %>
    </body>
</html>

