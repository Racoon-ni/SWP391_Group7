<%-- 
    Document   : pc-best-seller
    Created on : Jun 17, 2025, 8:04:14 AM
    Author     : Huynh Trong Nguyen - CE190356
--%>
<%@ page pageEncoding="UTF-8" %>
<div class="pc-bestseller my-3" style="border-style: solid">
    <div class="d-flex justify-content-between align-items-start mb-3">
        <h3>PC bán chạy</h3>
        <a href="#">Xem tất cả</a>
    </div>

    <div class="d-flex flex-nowrap overflow-auto" style="gap: 2rem;">
        <%
            for (int i = 0; i < 4; i++) {
        %>
        <div class="card p-2 shadow-sm" style="width: 18rem; border: 1px solid #ddd; font-size: 0.85rem;">
            <img src="${pageContext.request.contextPath}/assets/images/product.webp" 
                 alt="PC Image">

            <div class="card-body text-center p-2">
                <h6 class="card-title mb-2" style="font-size: 0.9rem;">PC GVN Intel i5-13400F/<br>VGA RTX 5060</h6>

                <div class="rounded py-1 px-1 mb-2 d-flex flex-wrap justify-content-center gap-2"
                     style="background-color: #ddd;">

                    <span class="badge text-dark border"><i class="fas fa-microchip me-1"></i>i5</span>
                    <span class="badge text-dark border"><i class="fas fa-video me-1"></i>RTX 5060</span>
                    <span class="badge text-dark border"><i class="fas fa-server me-1"></i>B760M</span>
                    <span class="badge text-dark border"><i class="fas fa-memory me-1"></i>32GB</span>
                    <span class="badge text-dark border"><i class="fas fa-hdd me-1"></i>1TB</span>
                </div>

                <p class="text-muted mb-1" style="text-decoration: line-through; font-size: 0.8rem;">25.620.000₫</p>

                <p class="fw-bold mb-1" style="font-size: 1.1rem; color: #ff6666">
                    23.990.000₫ <span class="text-danger" style="font-size: 0.8rem; background-color: #ff9999; border-radius: 10px "> -6% </span>
                </p>

                <p class="text-muted small">
                    <span class="text-warning">0.0 <i class="fas fa-star"></i></span>
                    (0 đánh giá)
                </p>
            </div>
        </div>
        <%
            }
        %>          
    </div>
</div>