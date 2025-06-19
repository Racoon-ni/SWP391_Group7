<%@ page contentType="text/html; charset=UTF-8" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="model.Product" %>
<%
    ArrayList<Product> products = (ArrayList<Product>) request.getAttribute("products");
%>
<!DOCTYPE html>
<html>
<head>
    <title>Danh sách sản phẩm</title>
</head>
<body>
    <h2>Danh sách sản phẩm và số lượng tồn kho</h2>
    <table border="1" cellpadding="8">
        <tr>
            <th>ID</th>
            <th>Tên sản phẩm</th>
            <th>Số lượng tồn kho</th>
        </tr>
        <c:forEach var="product" items="${products}">
            <tr>
                <td>${product.productId}</td>
                <td>${product.name}</td>
                <td>${product.stock}</td>
            </tr>
        </c:forEach>
    </table>
</body>
</html>
