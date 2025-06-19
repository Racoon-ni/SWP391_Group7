<%-- 
    Document   : product-detail
    Created on : Jun 20, 2025, 4:33:12 AM
    Author     : ThinhLVCE181726 <your.name at your.org>
--%>

<%@ page contentType="text/html; charset=UTF-8" %>
<%@ page import="model.Product" %>
<%@ page import="java.text.DecimalFormat" %>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Chi tiết sản phẩm</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.1/dist/css/bootstrap.min.css" rel="stylesheet" />
    <style>
        .product-img {
            max-width: 400px;
            max-height: 400px;
            object-fit: contain;
        }
    </style>
</head>
<body>
    <div class="container py-5">
        <%
            Product product = (Product) request.getAttribute("product");
            DecimalFormat df = new DecimalFormat("#,###");
        %>
        <h2 class="mb-4">Chi tiết sản phẩm: <%= product.getName() %></h2>
        <div class="row">
            <div class="col-md-6">
                <img src="<%= product.getImageUrl() != null ? product.getImageUrl() : "https://via.placeholder.com/400" %>" alt="Product Image" class="product-img">
            </div>
            <div class="col-md-6">
                <h3><%= product.getName() %></h3>
                <p><strong>Mô tả:</strong> <%= product.getDescription() %></p>
                <p><strong>Giá:</strong> <%= df.format(product.getPrice()) %> đ</p>
                <p><strong>Số lượng trong kho:</strong> <%= product.getStock() %></p>
                <p><strong>Loại sản phẩm:</strong> <%= product.getProductType() %></p>
                <p><strong>Danh mục:</strong> <%= product.getCategoryId() %></p>
                <div>
                    <a href="#" class="btn btn-primary">Thêm vào giỏ</a>
                </div>
            </div>
        </div>
        <a href="pc-list" class="btn btn-secondary mt-4">Quay lại danh sách sản phẩm</a>
    </div>
</body>
</html>

