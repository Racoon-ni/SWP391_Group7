<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>PC Store - Linh kiện</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.1/dist/css/bootstrap.min.css">
    <style>
        body { font-family: Arial, sans-serif; }
        .sidebar {
            min-width: 230px;
            max-width: 250px;
            background: #f6f6f6;
            border-right: 1px solid #ddd;
            height: 100vh;
            position: fixed;
            left: 0;
            top: 0;
            padding-top: 70px;
        }
        .sidebar a, .sidebar .nav-link {
            display: block;
            padding: 10px 18px;
            color: #333;
            font-weight: 500;
            text-decoration: none;
            border-bottom: 1px solid #e2e2e2;
        }
        .sidebar a.active, .sidebar a:hover {
            background: #c5a992;
            color: #fff;
        }
        .main-content {
            margin-left: 250px;
            padding: 24px 32px;
        }
        .card .card-img-top {
            height: 170px;
            object-fit: cover;
        }
        @media (max-width: 900px) {
            .sidebar { position: static; width: 100%; min-width: 0; max-width: none; height: auto; padding-top: 0;}
            .main-content { margin-left: 0; padding: 16px;}
        }
    </style>
</head>
<body>
    <!-- Sidebar bộ lọc -->
    <div class="sidebar">
        <a href="${pageContext.request.contextPath}/viewComponent?category=SSD" class="nav-link ${param.category eq 'SSD' ? 'active' : ''}">SSD</a>
        <a href="${pageContext.request.contextPath}/viewComponent?category=HDD" class="nav-link ${param.category eq 'HDD' ? 'active' : ''}">HDD</a>
        <a href="${pageContext.request.contextPath}/viewComponent?category=RAM" class="nav-link ${param.category eq 'RAM' ? 'active' : ''}">RAM</a>
        <a href="${pageContext.request.contextPath}/viewComponent?category=CPU" class="nav-link ${param.category eq 'CPU' ? 'active' : ''}">CPU</a>
        <a href="${pageContext.request.contextPath}/viewComponent?category=VGA" class="nav-link ${param.category eq 'VGA' ? 'active' : ''}">VGA (Card màn hình)</a>
        <!-- Thêm các loại linh kiện khác nếu muốn -->
    </div>
    <div class="main-content">
        <h2 class="fw-bold mb-4" style="color: #c5a992;">${param.category != null ? param.category : "Tất cả"} linh kiện</h2>

        <div class="row g-4">
            <c:choose>
                <c:when test="${not empty componentList}">
                    <c:forEach var="product" items="${componentList}">
                        <div class="col-sm-6 col-md-4 col-lg-3">
                            <div class="card h-100 shadow-sm">
                                <img src="${pageContext.request.contextPath}/images/${product.imageUrl}" class="card-img-top" alt="${product.name}">
                                <div class="card-body d-flex flex-column">
                                    <h5 class="card-title fw-semibold">${product.name}</h5>
                                    <c:if test="${not empty product.description}">
                                        <p class="text-muted small">${product.description}</p>
                                    </c:if>
                                    <p class="fw-bold mb-2" style="color: #c5a992;">${product.price}₫</p>
                                    <div class="mt-auto">
                                        <a href="${pageContext.request.contextPath}/viewComponentDetail.jsp?id=${product.productId}" class="btn btn-sm text-white" style="background-color: #c5a992;">Xem chi tiết</a>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </c:forEach>
                </c:when>
                <c:otherwise>
                    <div class="col-12 text-center text-muted">
                        Không tìm thấy sản phẩm nào!
                    </div>
                </c:otherwise>
            </c:choose>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.1/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
