<%@ page contentType="text/html; charset=UTF-8" %>
<%@ page import="model.Product" %>
<%@ page import="java.text.DecimalFormat" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<<<<<<< HEAD
=======
<%@ page import="java.text.SimpleDateFormat" %>
>>>>>>> fc2302132c71aa13aaed03ea183a3ae763ab616d

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
                <p><strong>Danh mục:</strong> 
                    <%= product.getCategoryId() %>
                </p>

                <!-- Thêm vào giỏ -->
                <div class="mt-3">
                    <c:choose>
                        <c:when test="${not empty sessionScope.user}">
                            <form method="post" action="${pageContext.request.contextPath}/AddToCart">
                                <input type="hidden" name="productId" value="<%= product.getProductId() %>" />
                                <button type="submit" class="btn btn-primary">
                                    <i class="fa-solid fa-cart-plus"></i> Thêm vào giỏ
                                </button>
                            </form>
                        </c:when>
                         <c:otherwise>
                                    <button class="btn btn-primary btn-sm w-100 text-white">
                                        <a href="${pageContext.request.contextPath}/login" class="btn btn-primary btn-sm w-100 text-white text-center">
                                            <i class="fa-solid fa-cart-plus"></i> Thêm vào giỏ
                                        </a>
                                    </button>

                                </c:otherwise>
                    </c:choose>
                </div>
            </div>
        </div>

        <a href="pc-list" class="btn btn-secondary mt-4">Quay lại danh sách sản phẩm</a>
    </div>
</body>
</html>
