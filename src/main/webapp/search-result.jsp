<%-- 
    Document   : search-result
    Created on : Jul 25, 2025, 8:24:59 AM
    Author     : ThinhLVCE181726 <your.name at your.org>
--%>
<%@ page pageEncoding="UTF-8" %>
<%@ page import="java.util.*, model.Product" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ include file="/WEB-INF/include/header.jsp" %>
<!-- Bootstrap 5 -->
<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.1/dist/css/bootstrap.min.css">
<!-- FontAwesome 6 -->
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">
<style>
body {
    background: #f5f6fa; /* Nền nhẹ */
}
.product-card-custom {
    border-radius: 18px !important;
    box-shadow: 0 4px 24px 0 rgba(0,0,0,0.06);
    transition: transform 0.2s, box-shadow 0.2s;
}
.product-card-custom:hover {
    transform: translateY(-4px) scale(1.025);
    box-shadow: 0 6px 32px 0 rgba(0,0,0,0.10);
}
.product-btn {
    min-width: 110px;
    min-height: 42px;
    font-size: 1rem;
}
.btn-primary {
    background: #2264e5;
    border-color: #2264e5;
}
.btn-primary:hover {
    background: #1450bd;
    border-color: #1450bd;
}
.btn-success {
    background: #169c52;
    border-color: #169c52;
}
.btn-success:hover {
    background: #117d42;
    border-color: #117d42;
}
.btn-light {
    background: #fff;
}
</style>

<div class="row row-cols-1 row-cols-md-4 g-4">
    <c:forEach var="p" items="${products}">
        <div class="col">
            <div class="card h-100 shadow-sm product-card-custom" style="border-radius: 18px; background: #fff;">
                <img src="${p.imageUrl}" class="card-img-top mx-auto d-block"
                    alt="${p.name}"
                    style="width: 180px; height: 180px; object-fit: contain; border-radius: 12px; margin-top: 24px; margin-bottom: 12px;">
                <div class="card-body d-flex flex-column align-items-center pb-2">
                    <h5 class="card-title fw-bold mb-1 text-center" style="font-size: 1.15rem;">${p.name}</h5>
                    <div class="mb-1 text-secondary" style="font-size: 0.98rem;">Mainboard</div>
                    <div class="mb-2 text-muted text-center" style="min-height:36px; font-size: 0.97rem;">${p.description}</div>
                    <div class="fw-bold mb-2" style="font-size: 1.15rem; color: #db147c;">${p.price} VNĐ</div>
                    <div class="mb-3 text-secondary" style="font-size: 0.97rem;">
                        Tồn kho: <span class="fw-semibold">${p.stock}</span>
                    </div>
                    <div class="d-flex gap-2 w-100 justify-content-center">
                        <a href="${pageContext.request.contextPath}/product-detail?id=${p.productId}"
                           class="btn btn-primary flex-grow-1 product-btn"
                           style="border-radius: 12px; font-weight: 500; font-size: 1rem;">
                            Xem chi tiết
                        </a>
                        <form action="${pageContext.request.contextPath}/add-to-cart" method="post" class="m-0 p-0 flex-grow-1">
                            <input type="hidden" name="productId" value="${p.productId}">
                            <button type="submit"
                                    class="btn btn-success flex-grow-1 product-btn"
                                    style="border-radius: 12px; font-weight: 500; font-size: 1rem;">
                                Thêm vào giỏ
                            </button>
                        </form>
                        <button type="button"
                                class="btn btn-light border d-flex align-items-center justify-content-center product-btn"
                                style="border-radius: 12px; width: 44px; height: 44px; padding: 0;">
                            <i class="fas fa-heart" style="color: #db147c; font-size: 1.4rem;"></i>
                        </button>
                    </div>
                </div>
            </div>
        </div>
    </c:forEach>
</div>

<%@include file="/WEB-INF/include/footer.jsp" %>