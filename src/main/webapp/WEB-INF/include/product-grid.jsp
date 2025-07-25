<%-- 
    Document   : product-grid
    Created on : Jul 25, 2025, 9:27:07 AM
    Author     : ThinhLVCE181726 <your.name at your.org>
--%>

<%@page pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<%-- product-grid.jsp --%>
<div class="row row-cols-1 row-cols-md-4 g-4">
    <c:forEach var="p" items="${products}">
        <div class="col">
            <div class="card h-100 shadow-sm product-card-custom" style="border-radius: 18px; background: #fff;">
                <img src="${p.imageUrl}" class="card-img-top mx-auto d-block"
                     alt="${p.name}"
                     style="width: 180px; height: 180px; object-fit: contain; border-radius: 12px; margin-top: 24px; margin-bottom: 12px;">
                <div class="card-body d-flex flex-column align-items-center pb-2">
                    <h5 class="card-title fw-bold mb-1 text-center" style="font-size: 1.15rem;">${p.name}</h5>
                    <div class="mb-1 text-secondary" style="font-size: 0.98rem;">${p.categoryName}</div>
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
