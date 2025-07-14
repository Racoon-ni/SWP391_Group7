<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List" %>
<%@ page import="model.Product" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
    <head>
        <title>Danh sách PC</title>
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.1/dist/css/bootstrap.min.css" rel="stylesheet">
        <link href="assets/css/styles.css" rel="stylesheet" />
        <style>
            .card-img-top {
                height: 180px;
                object-fit: cover;
            }
            .card-title {
                font-size: 1.1rem;
            }
        </style>
    </head>
    <body>
        <div class="container py-4">
            <h2 class="mb-4">Danh sách PC</h2>
            <div class="row">
                <%
                    List<Product> products = (List<Product>) request.getAttribute("products");
                    if (products != null && !products.isEmpty()) {
                        for (Product p : products) {
                            String imgUrl = p.getImageUrl() != null ? p.getImageUrl() : "https://via.placeholder.com/250x180?text=No+Image";
                %>
                <div class="col-md-3 mb-4">
                    <div class="card h-100 shadow">
                        <img src="<%= imgUrl%>" class="card-img-top" alt="Ảnh sản phẩm">
                        <div class="card-body">
                            <h5 class="card-title"><%= p.getName()%></h5>
                            <p class="card-text text-truncate" title="<%= p.getDescription()%>"><%= p.getDescription()%></p>
                            <div class="mb-2 fw-bold text-primary"><%= String.format("%,.0f", p.getPrice())%> đ</div>
                            <div class="mb-2"><span class="badge bg-secondary">Kho: <%= p.getStock()%></span></div>
                        </div>
                        <div class="card-footer bg-white">
                            <!-- Thêm vào giỏ -->
                            <c:choose>
                                <c:when test="${not empty sessionScope.user}">
                                    <form method="post" action="${pageContext.request.contextPath}/AddToCart">
                                        <input type="hidden" name="productId" value="<%= p.getProductId()%>" />
                                        <button type="submit" class="btn btn-primary btn-sm w-100">
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

                            <!-- Xem chi tiết -->
                            <a href="product-detail?id=<%= p.getProductId()%>" class="btn btn-outline-secondary btn-sm w-100 mt-2">
                                Xem chi tiết
                            </a>
                        </div>
                    </div>
                </div>
                <%
                    }
                } else {
                %>
                <div class="col-12">
                    <div class="alert alert-warning text-center">Không có dữ liệu</div>
                </div>
                <%
                    }
                %>
            </div>
        </div>
    </body>
</html>
