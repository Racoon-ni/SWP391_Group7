<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
<head>
    <title>Danh sách sản phẩm</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.1/dist/css/bootstrap.min.css">
</head>
<body>
    <div class="container">
        <!-- Sidebar menu -->
        <div class="row">
            <div class="col-md-3">
                <ul class="list-group">
                    <li class="list-group-item"><a href="${pageContext.request.contextPath}/viewComponent?category=RAM">RAM</a></li>
                    <li class="list-group-item"><a href="${pageContext.request.contextPath}/viewComponent?category=SeriesCPU">Series CPU</a></li>
                    <li class="list-group-item"><a href="${pageContext.request.contextPath}/viewComponent?category=TheHeCPU">Thế hệ CPU</a></li>
                    <!-- Các mục khác như SSD, HDD có thể thêm vào -->
                </ul>
            </div>

            <!-- Main content -->
            <div class="col-md-9">
                <h2 class="fw-bold mb-4" style="color: #c5a992;">Danh sách sản phẩm: ${param.category}</h2>
                
                <div class="row g-4">
                    <c:forEach var="product" items="${componentList}">
                        <div class="col-sm-6 col-md-4 col-lg-3">
                            <div class="card h-100 shadow-sm">
                                <img src="${pageContext.request.contextPath}/images/${product.imageUrl}" class="card-img-top" alt="${product.name}" style="height: 180px; object-fit: cover;">
                                <div class="card-body d-flex flex-column">
                                    <h5 class="card-title fw-semibold">${product.name}</h5>
                                    <p class="text-muted">${product.description}</p>
                                    <p class="fw-bold mb-2" style="color: #c5a992;">${product.price}₫</p>
                                    <a href="${pageContext.request.contextPath}/viewComponentDetail.jsp?id=${product.productId}" class="btn btn-sm mt-auto text-white" style="background-color: #c5a992;">Xem chi tiết</a>
                                </div>
                            </div>
                        </div>
                    </c:forEach>
                </div>
            </div>
        </div>
    </div>
</body>
</html>
