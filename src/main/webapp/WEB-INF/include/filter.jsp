<%-- 
    Document   : filter
    Created on : Jul 25, 2025, 9:02:38 AM
    Author     : ThinhLVCE181726 <your.name at your.org>
--%>
<%@ page pageEncoding="UTF-8" %>
<%@ page import="java.util.*, model.Product" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<form action="${pageContext.request.contextPath}/filter" method="get" class="mb-4 d-flex gap-3 align-items-end">
    <!-- Filter theo loại sản phẩm -->
    <div>
        <label for="category" class="form-label">Danh mục</label>
        <select name="categoryId" id="category" class="form-select" style="border-radius:12px;">
            <option value="">Tất cả</option>
            <c:forEach var="cat" items="${categories}">
                <option value="${cat.categoryId}"
                    <c:if test="${param.categoryId == cat.categoryId}">selected</c:if>
                >${cat.name}</option>
            </c:forEach>
        </select>
    </div>
    <!-- Filter theo mức giá -->
    <div>
        <label for="priceRange" class="form-label">Mức giá</label>
        <select name="priceRange" id="priceRange" class="form-select" style="border-radius:12px;">
            <option value="">Tất cả</option>
            <option value="1" ${param.priceRange == '1' ? 'selected' : ''}>Dưới 2 triệu</option>
            <option value="2" ${param.priceRange == '2' ? 'selected' : ''}>2 - 5 triệu</option>
            <option value="3" ${param.priceRange == '3' ? 'selected' : ''}>5 - 10 triệu</option>
            <option value="4" ${param.priceRange == '4' ? 'selected' : ''}>Trên 10 triệu</option>
        </select>
    </div>
    <button type="submit" class="btn btn-primary" style="border-radius:12px; min-width: 100px;">Lọc</button>
</form>
