
<%@ page pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<form action="${pageContext.request.contextPath}/filter" method="GET" class="mb-6 flex gap-4">
    <select name="categoryId" class="form-select">
        <option value="">Tất cả danh mục</option>
        <c:forEach var="cat" items="${categories}">
            <option value="${cat.categoryId}">${cat.name}</option>
        </c:forEach>
    </select>
        <select name="priceRange" id="priceRange" class="form-select" style="border-radius:12px;">
            <option value="">Tất cả</option>
            <option value="1" ${param.priceRange == '1' ? 'selected' : ''}>Dưới 2 triệu</option>
            <option value="2" ${param.priceRange == '2' ? 'selected' : ''}>2 - 5 triệu</option>
            <option value="3" ${param.priceRange == '3' ? 'selected' : ''}>5 - 10 triệu</option>
            <option value="4" ${param.priceRange == '4' ? 'selected' : ''}>Trên 10 triệu</option>
        </select>
    <button type="submit" class="btn btn-primary">Lọc</button>
</form>
