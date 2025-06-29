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
            <h2 class="mb-4">Chi tiết sản phẩm: <%= product.getName()%></h2>
            <div class="row">
                <div class="col-md-6">
                    <img src="<%= product.getImageUrl() != null ? product.getImageUrl() : "https://via.placeholder.com/400"%>" alt="Product Image" class="product-img">
                </div>
                <div class="col-md-6">
                    <h3><%= product.getName()%></h3>
                    <p><strong>Mô tả:</strong> <%= product.getDescription()%></p>
                    <p><strong>Giá:</strong> <%= df.format(product.getPrice())%> đ</p>
                    <p><strong>Số lượng trong kho:</strong> <%= product.getStock()%></p>
                    <p><strong>Loại sản phẩm:</strong> <%= product.getProductType()%></p>
                    <p><strong>Danh mục:</strong> <%= product.getCategoryId()%></p>
                    <div>
                        <a href="#" class="btn btn-primary">Thêm vào giỏ</a>
                    </div>
                </div>
            </div>
            <a href="pc-list" class="btn btn-secondary mt-4">Quay lại danh sách sản phẩm</a>
        </div>
    </body>
    <%@ page import="java.util.List" %>
    <%@ page import="model.Voucher" %>
    <%
        List<Voucher> vouchers = (List<Voucher>) request.getAttribute("vouchers");
        Integer userId = (Integer) session.getAttribute("userId"); // từ session sau khi login
    %>

    <h3 class="text-xl font-semibold mt-8 mb-4 text-gray-800">Voucher đang có</h3>
    <% if (vouchers != null && !vouchers.isEmpty()) { %>
    <div class="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-3 gap-4">
        <% for (Voucher v : vouchers) {%>
        <div class="bg-white p-4 shadow-md rounded-lg flex flex-col justify-between border border-gray-200">
            <div>
                <h4 class="text-lg font-bold text-red-600 mb-1"><%= v.getCode()%></h4>
                <p class="text-sm text-gray-700 mb-1">
                    Giảm <%= v.getDiscountPercent()%>% cho đơn từ <span class="font-medium"><%= String.format("%,.0f", v.getMinOrderValue())%> đ</span>
                </p>
                <p class="text-xs text-gray-500">Hạn: <%= new java.text.SimpleDateFormat("dd-MM-yyyy").format(v.getExpiredAt())%></p>
            </div>
            <form action="GetVoucher" method="post" class="mt-4 text-right">
                <input type="hidden" name="voucherId" value="<%= v.getVoucherId()%>">
                <button type="submit" class="px-4 py-1 bg-red-500 hover:bg-red-600 text-white text-sm rounded transition">
                    Nhận ngay
                </button>
            </form>
        </div>
        <% } %>
    </div>
    <% } else { %>
    <p class="text-gray-500">Hiện chưa có voucher nào khả dụng.</p>
    <% }%>

</html>

