
<%@ page pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<form action="${pageContext.request.contextPath}/filter" method="GET" class="mb-6 flex gap-4">
    <select name="categoryId" class="form-select">
        <option value="">Tất cả danh mục</option>
        <c:forEach var="cat" items="${categories}">
            <option value="${cat.categoryId}">${cat.name}</option>
        </c:forEach>
    </select>
    <select name="priceRange" class="form-select">
        <option value="">Tất cả giá</option>
        <option value="0-2000000">Dưới 2 triệu</option>
        <option value="2000000-5000000">2-5 triệu</option>
        <option value="5000000-10000000">5-10 triệu</option>
        <option value="10000000-">Trên 10 triệu</option>
    </select>
    <button type="submit" class="btn btn-primary">Lọc</button>
</form>
