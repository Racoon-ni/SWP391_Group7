<%-- 
    Document   : search-result
    Created on : Jul 25, 2025, 8:24:59 AM
    Author     : ThinhLVCE181726 <your.name at your.org>
--%>
<%@ page pageEncoding="UTF-8" %>
<%@ page import="java.util.*, model.Product" %>
<%@ include file="/WEB-INF/include/header.jsp" %>

<h3>Kết quả tìm kiếm cho: "${keyword}"</h3>
<c:if test="${empty products}">
    <div>Không tìm thấy sản phẩm phù hợp.</div>
</c:if>
<c:forEach var="p" items="${products}">
    <div class="card mb-3">
        <img src="${p.imageUrl}" alt="${p.name}" style="width: 100px;">
        <div>
            <h5>${p.name}</h5>
            <p>${p.description}</p>
            <p>Giá: ${p.price} đ</p>
            <!-- Thêm nút xem chi tiết, đặt hàng nếu muốn -->
        </div>
    </div>
</c:forEach>
<%@include file="/WEB-INF/include/footer.jsp" %>