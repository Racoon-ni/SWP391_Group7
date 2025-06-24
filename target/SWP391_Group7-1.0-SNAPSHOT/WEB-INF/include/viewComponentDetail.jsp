<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ include file="header.jsp" %>

<html>
<head>
    <title>Chi tiết sản phẩm</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.1/dist/css/bootstrap.min.css">
</head>
<body>
<div class="container mt-5">
    <h3 class="mb-4 text-primary">Chi Tiết Sản Phẩm</h3>

    <c:if test="${not empty errorMessage}">
        <div class="alert alert-danger" role="alert">
            ${errorMessage}
        </div>
    </c:if>

    <div class="row">
        <c:forEach var="product" items="${productList}">
            <div class="col-md-4 mb-3">
                <div class="card shadow-sm h-100">
                    <c:choose>
                        <c:when test="${not empty product.imageUrl}">
                            <img src="${product.imageUrl}" class="card-img-top" alt="${product.name}" style="height: 200px; object-fit: cover;">
                        </c:when>
                        <c:otherwise>
                            <img src="https://via.placeholder.com/200" class="card-img-top" alt="No Image" style="height: 200px; object-fit: cover;">
                        </c:otherwise>
                    </c:choose>
                    <div class="card-body d-flex flex-column">
                        <h5 class="card-title">${product.name}</h5>
                        <p class="card-text">Mã sản phẩm: ${product.productId}</p>
                        <p class="card-text">Giá: ${product.price} VNĐ</p>
                        <p class="card-text">Số lượng tồn: ${product.stock}</p>
                        <p class="card-text">Loại sản phẩm: ${product.productType}</p>
                        <p class="card-text">Mô tả: ${product.description}</p>
                        <div class="d-flex justify-content-between mt-auto">
                            <a href="#" class="btn btn-primary">Thêm vào giỏ hàng</a>
                            <a href="#" class="btn btn-outline-danger"><i class="bi bi-heart"></i> Yêu thích</a>
                        </div>
                    </div>
                </div>
            </div>
        </c:forEach>
        <c:if test="${empty productList}">
            <div class="col-12">
                <p class="text-muted">Không có sản phẩm nào trong danh mục này.</p>
            </div>
        </c:if>
    </div>
</div>
<!-- Thêm Bootstrap Icons để hiển thị biểu tượng trái tim -->
<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">
</body>
</html>