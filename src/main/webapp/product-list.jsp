<%-- 
    Document   : product-list
    Created on : Jun 20, 2025, 12:05:21 AM
    Author     : ThinhLVCE181726 <your.name at your.org>
--%>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List" %>
<%@ page import="model.Product" %>
<!DOCTYPE html>
<html>
    <head>
        <title>Danh sách PC</title>
        <style>
            table {
                border-collapse: collapse;
                width: 90%;
            }
            th, td {
                border: 1px solid #ccc;
                padding: 8px;
                text-align: center;
            }
            img {
                width: 90px;
            }
        </style>
        <!-- Thêm vào <head> -->
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.1/dist/css/bootstrap.min.css" rel="stylesheet">
        <link href="assets/css/styles.css" rel="stylesheet" />
    </head>
    <body>
        <div class="container py-4">
            <h2 class="mb-4">Danh sách PC</h2>
            <div class="row">
                <%
                    List<Product> products = (List<Product>) request.getAttribute("products");
                    if (products != null && !products.isEmpty()) {
                        for (Product p : products) {
                %>
                <div class="col-md-3 mb-4">
                    <div class="card h-100 shadow">
                        <%
                            String imgUrl = p.getImageUrl() != null ? p.getImageUrl() : "https://via.placeholder.com/250x180?text=No+Image";
                        %>
                        <img src="<%= imgUrl%>" class="card-img-top" style="height:180px; object-fit:cover;">
                        <div class="card-body">
                            <h5 class="card-title" style="font-size: 1.1rem;"><%= p.getName()%></h5>
                            <p class="card-text text-truncate" title="<%= p.getDescription()%>"><%= p.getDescription()%></p>
                            <div class="mb-2 fw-bold text-primary" style="font-size: 1.1rem;">
                                <%= String.format("%,.0f", p.getPrice())%> đ
                            </div>
                            <div class="mb-2"><span class="badge bg-secondary">Kho: <%= p.getStock()%></span></div>
                        </div>
                        <div class="card-footer bg-white">
                            <!-- Nút Thêm vào giỏ hàng -->
                            <a href="#" class="btn btn-outline-primary btn-sm w-100">Thêm vào giỏ</a>
                            <!-- Link Xem Chi Tiết -->
                            <a href="product-detail?id=<%= p.getProductId() %>" class="btn btn-outline-secondary btn-sm w-100 mt-2">Xem chi tiết</a>
                        </div>
                    </div>
                </div>
                <%
                    }
                } else { %>
                <div class="col-12"><div class="alert alert-warning text-center">Không có dữ liệu</div></div>
                <% }%>
            </div>
        </div>
    </body>
</html>
